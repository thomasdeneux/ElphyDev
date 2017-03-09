unit descPcl;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes, sysutils,
     util1,dtf0,debug0,descac1,stmDef,Mtag0;


type


  TpclampDescriptor=class(TfileDescriptor)
                 private
                    offsetFich:integer;
                    Fcontinu:boolean;
                    Qnbvoie:integer;
                    Qnbpt:integer;
                    periode1,periode2:single;
                    clock2:boolean;
                    duree:float;

                    unitX:AnsiString;
                    unitY:array[1..16] of AnsiString;

                    stDat: AnsiString;

                    nbSeqDat0:integer;
                    duree0:float;

                    x0u,dxu:double;
                    y0u,dyu:array[1..16] of double;
                    sampleSize:integer;

                    numSeqC:integer;

                    longueurDat,tailleSeq:integer;

                    offtag:longint;
                    spaceTag:longint;
                    nbtag:word;

                    Mtag:PMtagArray;

                  public
                    constructor create;override;
                    destructor destroy;override;

                    function init(st:AnsiString):boolean;override;
                    function nbvoie:integer;override;
                    function nbSeqDat:integer;override;
                    function nbPtSeq(voie:integer):integer;override;
                    function getData(voie,seq:integer;var evtMode:boolean):typeDataB;override;
                    function getTpNum(voie,seq:integer):typetypeG;override;
                    function FichierContinu:boolean;override;

                    procedure displayInfo;override;

                    function getMtag(numseq:integer):PMtagArray;override;
                    class function FileTypeName:AnsiString;override;
                  end;


IMPLEMENTATION

{****************** Méthodes de TpclampDescriptor ******************************}

constructor TpclampDescriptor.create;
begin
end;

destructor TpclampDescriptor.destroy;
begin
  if assigned(Mtag) then Freemem(Mtag,Mtag^.size);
end;


function TpclampDescriptor.init(st:AnsiString):boolean;
type
  typeBufFetch=record
                 typeF:    single;
                 nbChan:   single;
                 nbSample: single;
                 nbEpisode:single;
                 Clk1:     single;
                 Clk2:     single;
                 bid1:     array[7..22] of single;
                 tagInfo:  single;
                 bid5:     array[24..30] of single;
                 ascending:single;
                 FirstChan:single;
                 bid2:     array[33..80] of single;
                 comment:  array[1..77] of char;
                 bid3:     array[1..243] of byte;
                 ExtOffset:array[0..15] of single;
                 ExtGain:  array[0..15] of single;
                 bid4:     array[1..32] of single;
                 unitM:    array[0..15] of array[1..8] of char;
               end;

var
  BufFetch:typeBufFetch;

var
  i,j:integer;
  w:integer;
  v:array[1..16] of integer;
  res:intG;
  f:TfileStream;
  jru1,jru2,yru1,yru2:float;

begin
  init:=false;
  fillchar(bufFetch,sizeof(bufFetch),0);

  stDat:=st;
  f:=nil;

  TRY
  f:=TfileStream.create(stDat,fmOpenRead);
  storeFileParams(f);

  f.Read(BufFetch,sizeof(BufFetch));

  with bufFetch do
  begin
    if (typeF<>1) and (typeF<>10) then
      begin
        {messageCentral('File is not a Pclamp data file');}
        f.free;
        exit;
      end;

    FContinu:=(typeF=10);

    w:=roundI(nbChan);
    if (w>0) and (w<=16) then QnbVoie:=w
    else
      begin
        f.free;;
        exit;
      end;

    w:=roundI(nbSample);
    if (w>0) then QnbPt:=w else
      begin
        f.free;;
        exit;
      end;

    v[1]:=roundI(firstChan) and $0F;

    if ascending=0
      then for i:=2 to QnbVoie do v[i]:=(v[i-1]+1) and $0F
      else for i:=2 to QnbVoie do v[i]:=(v[i-1]-1) and $0F;

    unitX:='ms ';

    if clock2
      then Duree:=Clk2*QnbPt*QnbVoie*0.001
      else Duree:=Clk1*QnbPt*QnbVoie*0.001;

    X0u:=0;

    LongueurDat:=roundL(nbEpisode*nbSample*2);
    offsetFich:=1024;

    if not Fcontinu then
      begin
        Dxu:=Duree/Qnbpt;
        unitX:='ms';
      end
    else
      begin
        Dxu:=Clk1/1E6;
        unitX:='ms';
        Qnbpt:=longueurDat div (Qnbvoie*2);
      end;


    for i:=1 to QnbVoie do
      begin
        unitY[i]:='';
        for j:=1 to 8 do
          if (unitM[v[i]][j]<>#0) and (unitM[v[i]][j]<>' ')
            then unitY[i]:=unitY[i]+unitM[v[i]][j];
        Jru1:=0;
        Jru2:=2048;
        Yru1:=extOffset[v[i]];
        if abs(extGain[v[i]])>1E-20 then
          Yru2:=10.0/extGain[v[i]]+extOffset[v[i]];
        Y0u[i]:=Yru1;
        Dyu[i]:=(Yru2-Yru1)/Jru2;
      end;

    OffTag:=512*roundL(TagInfo);
    if offTag>0 then
      begin
        f.Position:=OffTag;
        f.read(nbtag,2);
        inc(offTag,2);
        SpaceTag:=4;
      end;

    if nbtag>0 then
      begin
        Mtag:=AllocMtagArray(nbtag);
        for i:=1 to nbTag do
          begin
            f.Position:=offtag+SpaceTag*(i-1);
            f.read(w,4);
            Mtag^.add(w,0);
          end;
      end;

  end;

  if (Qnbpt<>0) and not Fcontinu
    then nbSeqDat0:=longueurDat div (Qnbpt*Qnbvoie*2)
    else nbSeqDat0:=1;

  duree0:=dxu*Qnbpt;

  f.free;
  Result:=true;
  Except
  f.free;
  result:=false;
  End;

end;



function TpclampDescriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
var
  res:intG;
  f:file;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
begin
  if (voie<1) or (voie>nbvoie) or (seq>nbseqDat) then
    begin
      getData:=nil;
      exit;
    end;

  evtMode:=false;
  numSeqC:=seq;

  offsetS:=offsetFich+(seq-1)*Qnbpt*Qnbvoie*2+2*(voie-1);
  {
  messageCentral(Istr(voie)+'/'+Istr(seq)+'/'+Istr(offsetS)+'/'+Istr(Qnbpt)
                +'/'+Estr(dxu,6)+'/'+Estr(dyu[voie],6)+'/'+Estr(y0u[voie],6)

  );}

  data0:=typedataFileI.create(stdat,offsetS,nbvoie,0,Qnbpt-1,false);

  data0.setConversionX(Dxu,X0u);
  data0.setConversionY(Dyu[voie],Y0u[voie]);

  getData:=data0;
end;

function TpclampDescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  getTpNum:=G_smallint;
end;


function TpclampDescriptor.nbVoie:integer;
begin
  nbvoie:=Qnbvoie;
end;

function TpclampDescriptor.nbSeqDat:integer;
begin
  nbseqDat:=nbSeqDat0;
end;

function TpclampDescriptor.nbPtSeq(voie:integer):integer;
begin
  nbPtSeq:=Qnbpt;
end;


function TpclampDescriptor.FichierContinu:boolean;
begin
  FichierContinu:=Fcontinu;
end;

procedure TpclampDescriptor.displayInfo;
var
  BoiteInfo:typeBoiteInfo;
  i,j:integer;
begin
  with BoiteInfo do
  begin
    BoiteInfo.init('File Informations');

    writeln(ExtractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    write(Istr(nbVoie)+' channel ');
    if nbvoie>1 then write('s');

    if not FContinu then
      begin
        writeln('  '+Istr(Qnbpt)+' samples/channel' );
        writeln('Episode duration:'+Estr1(Duree0,10,3)+' '+unitX);
        write(Istr(nbSeqDat)+' episode');
        if nbSeqDat>1 then write('s');
      end
    else
      begin
        writeln('         Continuous file');
        writeln('Duration:    '+Estr1(Duree0,10,3)+' '+unitX);
        writeln('Sampling interval per channel:'+Estr1(Dxu,10,6)+' '+unitX);
      end;

    done;
  end;

end;

function TPclampDescriptor.getMtag(numseq:integer):PMtagArray;
begin
  result:=nil;

  if assigned(Mtag) then
    begin
      getmem(result,Mtag^.size);
      move(Mtag^,result^,Mtag^.size);
    end;
end;



class function TpclampDescriptor.FileTypeName: AnsiString;
begin
  result:='Pclamp';
end;

end.
