unit descabf;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysUtils,
     util1,dtf0,Spk0,ficDefAc,debug0,descac1,
     stmDef,Mtag0,Mtag2;


type


  TABFdescriptor=class(TfileDescriptor)
                 private
                    offsetFich:integer;
                    Fcontinu:boolean;
                    Qnbvoie:integer;
                    Qnbpt:integer;
                    periode1,periode2:single;
                    clock2:boolean;
                    duree:float;

                    ux:AnsiString;
                    uy:array[1..16] of AnsiString;

                    stDat:AnsiString;

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
                    procedure getElphyTag(numseq:integer;var tags:TtagRecArray;
                                var x0u,dxu:float);override;

                    function unitX:AnsiString;override;
                    function unitY(num:integer):AnsiString;override;

                    class function FileTypeName:AnsiString;override;
                  end;


IMPLEMENTATION

{****************** Méthodes de TABFdescriptor ******************************}

constructor TABFdescriptor.create;
begin
end;

destructor TABFdescriptor.destroy;
begin
  if assigned(Mtag) then Freemem(Mtag,Mtag^.size);
end;


function TABFdescriptor.init(st:AnsiString):boolean;
var
  Buf:array[0..1412] of byte;

var
  f:TfileStream;
  i:integer;
  w:longint;
  v:integer;
  res:intG;

  periode1,periode2:float;
  ADCres:longint;
  ADCrange,ScaleF:float;
  ADCdiv:integer;

  Jru1,Jru2:integer;
  Yru1,Yru2:float;

function Finteger(n:integer):integer;
  begin
     Finteger:=Psmallint(@buf[n])^;
  end;

function Fsingle(n:integer):single;
  begin
     Fsingle:=Psingle(@buf[n])^;
  end;

function Flong(n:integer):longint;
  begin
     Flong:=Plongint(@buf[n])^;
  end;

function Fstring(n,l:integer):AnsiString;
begin
  setlength(result,l);
  move(buf[n],result[1],l);
end;

function numPhysique(n:integer):integer;   { n de 0 … 15 }
  var
    i:integer;
  begin
    numPhysique:=Finteger(410+n*2);
  end;

begin

  result:=false;
  stDat:=st;
  f:=nil;

  try
  f:=TfileStream.create(st,fmOpenRead);
  storeFileParams(f);

  fillchar(buf,sizeof(buf),0);
  f.Read(buf,sizeof(buf));


  if Fstring(0,4)<>'ABF ' then                                 { Une nouvelle version contient 'ABF2' }
    begin
      {messageCentral(st+' is not an ABF data file');}
      f.free;
      exit;
    end;

  offsetFich:=512*Flong(40);
  longueurDat:=Flong(10)*2;

  w:=Finteger(8);
  Fcontinu:= (w=1) or (w=3);

  w:=Finteger(120);
  if (w>0) and (w<=16) then QnbVoie:=w;

  w:=Flong(138);
  if (w>0) then QnbPt:=w div Qnbvoie;


  Periode1:=Fsingle(122);
  Periode2:=Fsingle(126);

  if not Fcontinu then
    begin
      Duree:=Periode1*QnbPt*QnbVoie*0.001;
      X0u:=0;
      if Qnbpt>0
        then Dxu:=Duree/Qnbpt
        else Dxu:=1;
      ux:='ms'
    end
  else
    begin
      X0u:=0;
      Dxu:=periode1*Qnbvoie/1E6;
      if Dxu=0 then Dxu:=1;
      Qnbpt:=longueurDat div (Qnbvoie*2);
      ux:='sec';
    end;


  ADCres:=Flong(252);
  if ADCres>=32768 then ADCdiv:=2 else ADCdiv:=1;

  ADCrange:=Fsingle(244);
  for i:=1 to QnbVoie do
    begin
      v:=numPhysique(i-1);

      uy[i]:=Fstring(602+v*8,8);

      Jru1:=0;
      Jru2:=ADCres div ADCdiv;

      Yru1:=Fsingle(986+v*4);
      scaleF:=Fsingle(922+v*4)*Fsingle(730+v*4)*Fsingle(1050+v*4)*ADCdiv;
      if scaleF<>0 then scaleF:=ADCrange/scaleF
                   else scaleF:=0;
      Yru2:=scaleF+Fsingle(986+v*4);

      Y0u[i]:=Yru1;
      Dyu[i]:=(Yru2-Yru1)/Jru2;
    end;

  if (Qnbpt<>0) and not Fcontinu
    then nbSeqDat0:=longueurDat div (Qnbpt*Qnbvoie*2)
    else nbSeqDat0:=1;

  OffTag:=512*Flong(44);
  nbtag:=Flong(48);
  SpaceTag:=64;

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

  f.free;
  duree0:=dxu*Qnbpt;
  result:=true;

  except
  f.Free;
  result:=false;
  end;

end;



function TABFdescriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
var
  res:intG;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
begin
  if (voie<1) or (voie>Qnbvoie) or (seq>nbseqDat0) then
    begin
      getData:=nil;
      exit;
    end;

  evtMode:=false;

  numSeqC:=seq;

  offsetS:=offsetFich+(seq-1)*Qnbpt*Qnbvoie*2+2*(voie-1);

  data0:=typedataFileI.create(stdat,offsetS,nbvoie,0,Qnbpt-1,false);

  data0.setConversionX(Dxu,X0u);
  data0.setConversionY(Dyu[voie],Y0u[voie]);

  getData:=data0;
end;

function TABFdescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  getTpNum:=G_smallint;
end;


function TABFdescriptor.nbVoie:integer;
begin
  nbvoie:=Qnbvoie;
end;

function TABFdescriptor.nbSeqDat:integer;
begin
  nbseqDat:=nbSeqDat0;
end;

function TABFdescriptor.nbPtSeq(voie:integer):integer;
begin
  nbPtSeq:=Qnbpt;
end;


function TABFdescriptor.FichierContinu:boolean;
begin
  FichierContinu:=Fcontinu;
end;

procedure TABFdescriptor.displayInfo;
var
  BoiteInfo:typeBoiteInfo;
  i,j:integer;
begin
  with BoiteInfo do
  begin
    BoiteInfo.init('File Informations');

    writeln(extractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    write(Istr(nbVoie)+' channel ');
    if nbvoie>1 then write('s');

    if not FContinu then
      begin
        writeln('  '+Istr(Qnbpt)+' samples/channel' );
        writeln('Episode duration:'+Estr1(Duree0,10,3)+' '+ux);
        write(Istr(nbSeqDat)+' episode');
        if nbSeqDat>1 then write('s');
      end
    else
      begin
        writeln('         Continuous file');
        writeln('Duration:    '+Estr1(Duree0,10,3)+' '+ux);
        writeln('Sampling interval per channel:'+Estr1(Dxu,10,6)+' '+ux);
      end;

    done;
  end;

end;


function TABFDescriptor.getMtag(numseq:integer):PMtagArray;
begin
  result:=nil;

  if assigned(Mtag) then
    begin
      getmem(result,Mtag^.size);
      move(Mtag^,result^,Mtag^.size);
    end;
end;

procedure TABFDescriptor.getElphyTag(numseq:integer;var tags:TtagRecArray;
                                var x0u,dxu:float);
var
  i:integer;
begin
  if not assigned(Mtag) then exit;

  setLength(tags,nbtag);
  for i:=0 to nbtag-1 do
    with tags[i] do
    begin
      SampleIndex:=Mtag^.t[i+1].date;
      Stime:=0;
      code:=0;
      ep:=1;
      st:='';
    end;

  dxu:=self.Dxu/nbvoie;
  x0u:=0;

end;



function TABFdescriptor.unitX: AnsiString;
begin
  result:=ux;
end;

function TABFdescriptor.unitY(num:integer): AnsiString;
begin
  result:=uy[num];
end;

class function TABFdescriptor.FileTypeName: AnsiString;
begin
  result:='Axon Binary Files';
end;

end.
