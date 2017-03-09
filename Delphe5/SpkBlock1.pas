unit SpkBlock1;

interface


uses classes, sysutils,
     util1,Gdos, Dtrace1,
     stmdef, stmObj, NcDef2, stmPG,
     ElphyFormat,DataGeneFile,ObjFile1, stmvec1, stmSpkWave1, cyberk2;

type
  TSpkBlock= class(typeUO)
                 private
                    SpkChannels: array of Tvector;
                    WspkChannels: array of TwaveList;

                    SpkScale: TevtScaling;
                    WspkScale: TspkWaveScaling;


                    wavelen, pretrig: integer;

                    procedure setChCount(n:integer);
                    function getChCount:integer;
                 public
                    constructor create;override;
                    destructor destroy;override;
                    class function stmClassName:AnsiString;override;

                    property ChannelCount: integer read getChCount write setChCount;

                    procedure processMessage(id:integer;source:typeUO;p:pointer);override;
                    procedure setChannel(num:integer;vspk:Tvector; Const Wspk: TwaveList=nil);

                    function saveToStream0(f: Tstream): integer;
                    procedure saveToStream(f: Tstream; Fdata:boolean);override;
                 end;


procedure proTspkBlock_create(var pu: typeUO);pascal;

procedure proTspkBlock_ChannelCount(nb:integer;var pu:typeUO);pascal;
function fonctionTspkBlock_ChannelCount(var pu:typeUO):integer;pascal;

procedure proTspkBlock_setChannel(num:integer;var v:Tvector;var pu:typeUO);pascal;
procedure proTspkBlock_setChannel_1(num:integer;var vspk:Tvector; var wspk: TwaveList ;var pu:typeUO);pascal;



implementation

{ TspkBlock }

constructor TspkBlock.create;
begin
  inherited;

end;

destructor TspkBlock.destroy;
var
  i: integer;
begin
  for i:=0 to high(SpkChannels) do
  begin
    derefObjet(typeUO(Spkchannels[i]));
    derefObjet(typeUO(Wspkchannels[i]));
  end;
  inherited;
end;

function TspkBlock.getChCount: integer;
begin
  result:=length(SpkChannels);
end;

procedure TspkBlock.setChCount(n: integer);
begin
  setLength(SpkChannels,n);
  fillchar(SpkChannels[0],sizeof(SpkChannels[0])*n,0);
  setLength(WSpkChannels,n);
  fillchar(WSpkChannels[0],sizeof(WSpkChannels[0])*n,0);
end;


procedure TspkBlock.processMessage(id: integer; source: typeUO; p: pointer);
var
  i:integer;
  pp:typeUO;
begin
  inherited;
  case id of
    UOmsg_destroy:
      begin
        for i:=0 to high(Spkchannels) do
        begin
          if (Spkchannels[i]=source) then
            begin
              Spkchannels[i]:=nil;
              pp:= source;                  // Pb quand le même objet est référencé plusieurs fois
              derefObjet(pp);               // pp peut être mis à nil    
            end;
          if (WspkChannels[i]=source) then
            begin
              WspkChannels[i]:=nil;
              pp:= source;
              derefObjet(pp);
            end;
        end;
      end;
  end;
end;

function TspkBlock.saveToStream0(f: Tstream): integer;
var
  nbSpike,size,nbV:integer;
  wavelen,pretrig:integer;
  nb:array of integer;
  i,j:integer;
  tt: array of integer;
  Att: array of byte;

  FirstNonZero, FirstWnonzero: integer;
begin
  result:=0;

  nbSpike:=0;
  size:=0;
  nbV:=0;

  if channelCount=0 then exit;
  setLength(nb,ChannelCount+1);

  FirstNonZero:=-1;
  FirstWNonZero:=-1;

  for i:=0 to ChannelCount-1 do    // FlagW indique qu'il faut sauver les waveforms
  begin
    if assigned(spkChannels[i]) and (FirstNonZero=-1) then FirstNonZero:= i;
    if assigned(WspkChannels[i]) and (WspkChannels[i].Icount>0) and (FirstWNonZero=-1) then FirstWNonZero:= i;
  end;

  if FirstNonZero=-1 then
  begin
    result:=2;
    exit;
  end;

  for i:=0 to ChannelCount-1 do    // compter les spikes
  begin
    inc(nbV);
    if assigned(SpkChannels[i])
      then nb[nbV]:= SpkChannels[i].Icount
      else nb[nbV]:=0;
    if assigned(WspkChannels[i]) and (WSpkChannels[i].maxIndex<> nb[nbV]) then
    begin
      result:=3;
      exit;
    end;

    nbSpike:=nbSpike+nb[nbV];
  end;

  spkScale.Dxu:= SpkChannels[FirstNonZero].Dyu;
  spkScale.x0u:= SpkChannels[FirstNonZero].y0u;
  spkScale.unitX:= SpkChannels[FirstNonZero].unitX;

  if FirstWNonZero>=0 then
  begin
    WspkScale.Dxu:= WSpkChannels[FirstWNonZero].Dxu;            // la wavelist doit être correctement paramétrée
    WspkScale.x0u:= WSpkChannels[FirstWNonZero].x0u;
    WspkScale.unitX:= WSpkChannels[FirstWNonZero].unitX;
    WspkScale.Dyu:= WSpkChannels[FirstWNonZero].Dyu;
    WspkScale.y0u:= WSpkChannels[FirstWNonZero].y0u;
    WspkScale.unitY:= WSpkChannels[FirstWNonZero].unitY;

    WspkScale.dxuSource:= SpkChannels[FirstNonZero].Dyu;       // pris sur Spk
    WspkScale.unitXSource:= SpkChannels[FirstNonZero].unitX;   // pris sur Spk
    WspkScale.tpNum:= WSpkChannels[FirstNonZero].tpNum;

    wavelen:= WspkChannels[FirstWNonZero].Icount;
    pretrig:= -WspkChannels[FirstWNonZero].Istart;
  end;


  if nbSpike>0 then
  begin
    size:=(nbV+1)*sizeof(integer)  + nbSpike*5 ;  { 5 octets pour chaque spike }

    WriteRspkHeader(f,size,now,false,spkScale);

    f.Write(nbV,sizeof(nbV));
    f.Write(Nb[1],nbV*4);

    for i:=0 to ChannelCount-1 do
    if assigned(SpkChannels[i]) then
    with SpkChannels[i] do
    begin
      setLength(tt,Icount);
      setLength(Att,Icount);
      fillchar(Att[0],Icount,0);

      for j:= 0 to Icount-1 do
      begin
        tt[j]:= round(Yvalue[Istart+j]/SpkScale.Dxu);
        //Att[j]:= AttValue[Istart+j];
        Att[j]:= WspkChannels[i].AttValue[Istart+j];
      end;                                
      f.Write(tt[0],Icount*sizeof(integer));
      f.Write(Att[0],Icount*sizeof(byte));
    end;

    { Sauver les waveforms  }

    if FirstWnonZero<0 then exit;
    size:= (nbV+3)*sizeof(integer)  + nbSpike*( wavelen*2 +ElphySpkPacketFixedSize) ;

    WriteRspkWaveHeader(f,size,now,false,WspkScale);

    f.Write(wavelen,sizeof(wavelen));
    f.Write(pretrig,sizeof(pretrig));

    f.Write(nbV,sizeof(nbV));
    f.Write(Nb[1],nbV*4);

    for i:=0 to channelCount-1 do
      if assigned(WspkChannels[i]) then
        WspkChannels[i].SavePacketList(f,SpkChannels[i]);
  end;

end;

procedure TspkBlock.saveToStream(f: Tstream; Fdata:boolean);
begin
  if saveToStream0(f)<>0  then sortieErreur('TspkBlock.saveToStream : unable to save data');
end;

procedure TspkBlock.setChannel(num:integer;vspk:Tvector; Const Wspk: TwaveList=nil);

begin
  if (num<0) or (num>=ChannelCount) then exit;

  derefObjet(typeUO(Spkchannels[num]));
  Spkchannels[num]:=vspk;
  refObjet(Spkchannels[num]);

  derefObjet(typeUO(WSpkchannels[num]));
  WSpkchannels[num]:=Wspk;
  refObjet(WSpkchannels[num]);

end;



class function TspkBlock.stmClassName: AnsiString;
begin
  result:='SpkBlock';

end;

{*************** Méthodes stm ******************************}

procedure proTspkBlock_create(var pu: typeUO);
begin
  createPgObject('',pu,TspkBlock);
end;

procedure proTspkBlock_ChannelCount(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<0) then sortieErreur('TspkBlock.ChannelCount : value out of range' );

  with TspkBlock(pu) do channelCount:=nb;
end;

function fonctionTspkBlock_ChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TspkBlock(pu) do result:=channelCount;
end;


procedure proTspkBlock_setChannel(num:integer;var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TspkBlock(pu) do
  begin
    if (num<1) or (num>channelCount) then sortieErreur('TspkBlock.setChannel : channel number out of range');
    setChannel(num-1,v);
  end;
end;

procedure proTspkBlock_setChannel_1(num:integer;var vspk:Tvector; var wspk: TwaveList ;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vspk));
  verifierObjet(typeUO(Wspk));

  with TspkBlock(pu) do
  begin
    if (num<1) or (num>channelCount) then sortieErreur('TspkBlock.setChannel : channel number out of range');
    setChannel(num-1,vspk,wspk);
  end;
end;





initialization

registerObject(TspkBlock,sys);

end.
