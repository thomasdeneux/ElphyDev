unit ElphyEpisode1;

interface

uses classes, sysutils,
     util1,Gdos, Dtrace1,
     stmObj, NcDef2, stmPG,
     ElphyFormat,DataGeneFile,ObjFile1, stmvec1;

type
  TElphyEpisode= class(typeUO)
                 private
                    Channels:array of Tvector;
                    ChXstart,ChXend:array of double;

                    TagCh:array of Tvector;
                    TagXstart,TagXend,TagTh:array of double;

                    nbspk: integer;
                    DxSpk: double;
                    unitXspk: string;

                    procedure setChCount(n:integer);
                    function getChCount:integer;
                    procedure setTagChCount(n:integer);
                    function getTagChCount:integer;
                 public
                    constructor create;override;
                    destructor destroy;override;
                    class function stmClassName:AnsiString;override;

                    property ChannelCount: integer read getChCount write setChCount;
                    property TagChannelCount: integer read getTagChCount write setTagChCount;


                    procedure processMessage(id:integer;source:typeUO;p:pointer);override;
                    procedure setChannel(num:integer;v:Tvector;x1,x2:float);
                    procedure setTagChannel(num:integer;v:Tvector;x1,x2,th:float);

                    procedure saveToStream(f: Tstream; Fdata:boolean);override;
                 end;


procedure proTElphyEpisode_create(var pu: typeUO);pascal;

procedure proTElphyEpisode_ChannelCount(nb:integer;var pu:typeUO);pascal;
function fonctionTElphyEpisode_ChannelCount(var pu:typeUO):integer;pascal;

procedure proTElphyEpisode_TagChannelCount(nb:integer;var pu:typeUO);pascal;
function fonctionTElphyEpisode_TagChannelCount(var pu:typeUO):integer;pascal;

procedure proTElphyEpisode_setChannel(num:integer;var v:Tvector;var pu:typeUO);pascal;
procedure proTElphyEpisode_setChannel_1(num:integer;var v:Tvector; x1,x2:float;var pu:typeUO);pascal;

procedure proTElphyEpisode_setTagChannel(num:integer;var v:Tvector; var pu:typeUO);pascal;
procedure proTElphyEpisode_setTagChannel_1(num:integer;var v:Tvector; x1,x2,th:float;var pu:typeUO);pascal;

procedure proTElphyEpisode_nbSpk(nb:integer;var pu:typeUO);pascal;
function fonctionTElphyEpisode_nbSpk(var pu:typeUO):integer;pascal;



implementation

{ TElphyEpisode }

constructor TElphyEpisode.create;
begin
  inherited;


end;

destructor TElphyEpisode.destroy;
var
  i: integer;
begin
  for i:=0 to high(channels) do derefObjet(typeUO(channels[i]));

  for i:=0 to high(TagCh) do derefObjet(typeUO(TagCh[i]));

  inherited;
end;

function TElphyEpisode.getChCount: integer;
begin
  result:=length(Channels);
end;

procedure TElphyEpisode.setChCount(n: integer);
begin
  setLength(Channels,n);
  setLength(ChXstart,n);
  setLength(ChXend,n);

  fillchar(Channels[0],sizeof(Channels[0])*n,0);
end;

function TElphyEpisode.getTagChCount: integer;
begin
  result:=length(TagCh);
end;

procedure TElphyEpisode.setTagChCount(n: integer);
begin
  setLength(TagCh,n);
  setLength(TagXstart,n);
  setLength(TagXend,n);
  setLength(TagTh,n);

  fillchar(TagCh[0],sizeof(tagCh[0])*n,0);
end;


procedure TElphyEpisode.processMessage(id: integer; source: typeUO; p: pointer);
var
  i:integer;
begin
  inherited;
  case id of
    UOmsg_destroy:
      begin
        for i:=0 to high(channels) do
          if (channels[i]=source) then
            begin
              channels[i]:=nil;
              derefObjet(source);
            end;

        for i:=0 to high(TagCh) do
          if (Tagch[i]=source) then
            begin
              Tagch[i]:=nil;
              derefObjet(source);
            end;
      end;
  end;
end;

procedure TElphyEpisode.saveToStream(f: Tstream; Fdata:boolean);
var
  Bseq: TseqBlock;
  seq: TseqRecord;

  BlocSize:integer;

  i,j,i1,i2:integer;
  ChType:integer;
  tbTag: array of word;
  tbTagSize, Nstored, max ,min: integer;
  okTag:boolean;
  n:integer;
  msk: word;


begin
  fillchar(seq,sizeof(seq),0);
  with seq do
  begin
    // Seuls nbvoie, continu, TagMode et FormatOption sont indispensables
    nbvoie:=ChannelCount + ord(TagChannelCount>0);
    if TagChannelCount>0 then TagMode:=tmItc;
  end;

  seq.nbSpk:=nbSpk;
  seq.DxuSpk:=DxSpk;
  seq.unitXspk:=unitXspk;


  Bseq:= TseqBlock.create;
  Bseq.init1(seq);

  BlocSize:=0;
  for i:=0 to ChannelCount-1 do
  with Channels[i] do
  begin
    if (modeT=DM_Evt1) or (modeT=DM_evt2) then ChType:=1 else ChType:=0;
    i1:=invConvx(ChXstart[i]);
    i2:=invConvx(ChXend[i]);

    BlocSize:=BlocSize+ (i2-i1+1)*tailleTypeG[tpNum];
    Bseq.initChannel1(i,ChType,tpNum,i1,i2,Dxu,X0u,unitX,Dyu,y0u,unitY);

    if Bseq.seq.Dxu=0 then
    begin
      Bseq.seq.Dxu:= Dxu;                           //////////////////////////////////
      Bseq.seq.uX:= unitX;
    end;  
  end;



  if TagChannelCount>0 then
  with TagCh[0] do
  begin
    ChType:=0;
    i1:=invConvx(TagXstart[0]);
    i2:=invConvx(TagXend[0]);

    BlocSize:=BlocSize+ (i2-i1+1)*tailleTypeG[g_smallint];
    Bseq.initChannel1(ChannelCount,ChType, g_smallint ,i1,i2,Dxu,X0u,unitX,Dyu,y0u,unitY);
  end;
  Bseq.saveToStream(f,Fdata);

  WriteRdataHeader(f, Blocsize, now, true);
  for i:=0 to ChannelCount-1 do
  with Channels[i] do
  begin
    i1:=invConvx(ChXstart[i]);
    i2:=invConvx(ChXend[i]);

    saveToBin(f, tpNum, i1, i2 );
  end;

  {ICI construire tbTag }
  if TagChannelCount>0 then
  begin
    okTag:= true;

    for i:=0 to TagChannelCount-1 do
    with tagCh[i] do
    begin
      i1:=invConvx(TagXstart[i]);
      i2:=invConvx(TagXend[i]);

      if i=0 then n:=i2-i1+1
      else
      if n<>i2-i1+1 then okTag:=false;
    end;

    if okTag then
    begin
      tbTagSize:=n;
      if tbTagSize>1000000 then tbTagSize:= 1000000;

      setLength(tbTag,tbTagSize);
      

      Nstored:=0;

      repeat
        min:= i1+Nstored;
        max:=min+tbTagSize-1;
        if max>i2 then max:=i2;

        fillchar(tbTag[0],tbTagSize*2,0);
        for j:=0 to TagChannelCount-1 do
        with tagCh[j] do
        begin
          msk:=1 shl j;
          for i:=min to max do
            if Yvalue[i]>TagTh[j]
              then tbTag[i-min]:= tbTag[i-min] or msk;
        end;

        f.Write(tbTag[0],(max-min+1)*2);
        inc(Nstored,tbTagSize);
      until (max>=i2);

    end;
  end;
  Bseq.Free;
end;

procedure TElphyEpisode.setChannel(num: integer; v: Tvector; x1, x2: float);
begin
  if (num<0) or (num>=ChannelCount) then exit;

  derefObjet(typeUO(channels[num]));
  channels[num]:=v;
  refObjet(channels[num]);

  ChXstart[num]:=x1;
  ChXend[num]:=x2;
end;


procedure TElphyEpisode.setTagChannel(num: integer; v: Tvector; x1, x2, th: float);
begin
  if (num<0) or (num>=TagChannelCount) then exit;

  derefObjet(typeUO(TagCh[num]));
  TagCh[num]:=v;
  refObjet(TagCh[num]);

  TagXstart[num]:=x1;
  TagXend[num]:=x2;
  TagTh[num]:=th;
end;

class function TElphyEpisode.stmClassName: AnsiString;
begin
  result:='ElphyEpisode';

end;

{*************** Méthodes stm ******************************}

procedure proTElphyEpisode_create(var pu: typeUO);
begin
  createPgObject('',pu,TElphyEpisode);
end;

procedure proTElphyEpisode_ChannelCount(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<0) then sortieErreur('TelphyEpisode.ChannelCount : value out of range' );

  with TElphyEpisode(pu) do channelCount:=nb;
end;

function fonctionTElphyEpisode_ChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TElphyEpisode(pu) do result:=channelCount;
end;

procedure proTElphyEpisode_TagChannelCount(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<0) or (nb>16) then sortieErreur('TelphyEpisode.TagChannelCount : value out of range' );

  with TElphyEpisode(pu) do TagchannelCount:=nb;
end;

function fonctionTElphyEpisode_TagChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TElphyEpisode(pu) do result:=TagchannelCount;
end;

procedure proTElphyEpisode_setChannel(num:integer;var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TElphyEpisode(pu) do
  begin
    if (num<1) or (num>channelCount) then sortieErreur('TElphyEpisode.setChannel : channel number out of range');
    setChannel(num-1,v,v.Xstart,v.Xend);
  end;
end;

procedure proTElphyEpisode_setChannel_1(num:integer;var v:Tvector; x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TElphyEpisode(pu) do
  begin
    if (num<1) or (num>channelCount) then sortieErreur('TElphyEpisode.setChannel : channel number out of range');
    setChannel(num-1,v,x1,x2);
  end;
end;


procedure proTElphyEpisode_setTagChannel(num:integer;var v:Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TElphyEpisode(pu) do
  begin
    if (num<1) or (num>TagchannelCount) then sortieErreur('TElphyEpisode.setTagChannel : Tag number out of range');
    setTagChannel(num-1,v,v.Xstart, v.Xend, 0.5);
  end;
end;

procedure proTElphyEpisode_setTagChannel_1(num:integer;var v:Tvector; x1,x2,th:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TElphyEpisode(pu) do
  begin
    if (num<1) or (num>TagchannelCount) then sortieErreur('TElphyEpisode.setTagChannel : Tag number out of range');
    setTagChannel(num,v,x1,x2,th);
  end;
end;

procedure proTElphyEpisode_nbSpk(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TElphyEpisode(pu) do nbSpk:= nb;
end;

function fonctionTElphyEpisode_nbSpk(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TElphyEpisode(pu).nbSpk;
end;



initialization

registerObject(TElphyEpisode,sys);

end.
