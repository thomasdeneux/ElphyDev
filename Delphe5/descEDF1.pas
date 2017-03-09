unit descEDF1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes, sysutils,
     util1,dtf0,debug0,descac1,
     stmDef,memoForm;


type
  TEDFdescriptor=class(TfileDescriptor)
                 private
                    stPatient:AnsiString;
                    stRecording:AnsiString;
                    stStartDate:AnsiString;
                    stStartTime:AnsiString;
                    nbByte:integer;
                    nbDataRec:integer;
                    DataRecLength:float;
                    Qnbvoie:integer;

                    offsetFich:integer;
                    Fcontinu:boolean;

                    stDat:AnsiString;

                    stLabel:array of AnsiString;
                    stTransType: array of AnsiString;
                    stPhysDim: array of AnsiString;
                    stPreFil: array of AnsiString;
                    nbSamp:array of integer;
                    x0u,dxu:array of double;
                    y0u,dyu:array of double;

                    offrec,sizeRec:array of integer;
                    recSize:integer;
                  public
                    constructor create;override;
                    destructor destroy;override;

                    function init(st:AnsiString):boolean;override;
                    function nbvoie:integer;override;
                    function nbSeqDat:integer;override;
                    function getData(voie,seq:integer;var evtMode:boolean):typeDataB;override;
                    function getTpNum(voie,seq:integer):typetypeG;override;

                    function FichierContinu:boolean;override;

                    procedure displayInfo;override;

                    function unitX:AnsiString;override;
                    function unitY(num:integer):AnsiString;override;

                    class function FileTypeName:AnsiString;override;
                  end;


IMPLEMENTATION

{****************** Méthodes de TEDFdescriptor ******************************}

constructor TEDFdescriptor.create;
begin
end;

destructor TEDFdescriptor.destroy;
begin
end;


function TEDFdescriptor.init(st:AnsiString):boolean;
var
  Buf:array of char;
  f:TfileStream;
  i:integer;
  res:intG;

  J1,J2:array of integer;
  Y1,Y2:array of float;

  cntString:integer;

function Fstring(len:integer):AnsiString;
begin
  setlength(result,len);
  move(buf[cntString],result[1],len);
  inc(cntString,len);
end;

function Finteger(len:integer):integer;
  var
    st:shortstring;
    n,code:integer;
  begin
    byte(st[0]):=len;
    move(buf[cntString],st[1],len);
    inc(cntString,len);
    st:=FsupEspace(st);
    val(st,n,code);
    if code=0
      then result:=n
      else result:=0;
  end;

function Freal(len:integer):float;
  var
    st:shortstring;
    code:integer;
    x:float;
  begin
    byte(st[0]):=len;
    move(buf[cntString],st[1],len);
    inc(cntString,len);
    st:=FsupEspace(st);
    val(st,x,code);
    if code=0
      then result:=x
      else result:=0;
  end;


begin
  result:=false;

  stDat:=st;
  f:=nil;
  TRY
  f:=TfileStream.create(stDat,fmOpenRead);

  storeFileParams(f);

  setLength(buf,256);
  fillchar(buf[0],256,0);
  f.Read(buf[0],256);


  cntString:=0;
  if Fstring(8)<>'0       ' then
    begin
      {messageCentral(st+' is not an EDF data file');}
      f.free;
      exit;
    end;

  stPatient:=Fstring(80);
  stRecording:=Fstring(80);
  stStartDate:=Fstring(8);
  stStartTime:=Fstring(8);
  nbByte:=Finteger(8);
  Fstring(44);
  nbDataRec:=Finteger(8);
  DataRecLength:=Freal(8);
  Qnbvoie:=Finteger(4);


  offsetFich:=256+256*Qnbvoie;
  Fcontinu:= true;

  setLength(stLabel,Qnbvoie);
  setLength(stTransType,Qnbvoie);
  setLength(stPhysDim,Qnbvoie);
  setLength(Dxu,Qnbvoie);
  setLength(Dyu,Qnbvoie);
  setLength(y0u,Qnbvoie);
  setLength(stPrefil,Qnbvoie);
  setLength(nbSamp,Qnbvoie);

  setLength(y1,Qnbvoie);
  setLength(y2,Qnbvoie);
  setLength(j1,Qnbvoie);
  setLength(j2,Qnbvoie);

  setLength(Offrec,Qnbvoie);
  setLength(SizeRec,Qnbvoie);

  setLength(buf,256*Qnbvoie);
  fillchar(buf[0],256*Qnbvoie,0);
  f.Read(buf[0],256*Qnbvoie);
  cntString:=0;

  for i:=0 to Qnbvoie-1 do stLabel[i]:=Fstring(16);
  for i:=0 to Qnbvoie-1 do stTransType[i]:=Fstring(80);
  for i:=0 to Qnbvoie-1 do stPhysDim[i]:=Fstring(8);

  for i:=0 to Qnbvoie-1 do y1[i]:=Freal(8);
  for i:=0 to Qnbvoie-1 do y2[i]:=Freal(8);
  for i:=0 to Qnbvoie-1 do j1[i]:=Finteger(8);
  for i:=0 to Qnbvoie-1 do j2[i]:=Finteger(8);

  for i:=0 to Qnbvoie-1 do stPreFil[i]:=Fstring(80);
  for i:=0 to Qnbvoie-1 do nbSamp[i]:=Finteger(8);

  recSize:=0;
  for i:=0 to Qnbvoie-1 do
  begin
    if (j2[i]<>j1[i]) and (Y2[i]<>Y1[i]) then
    begin
      Dyu[i]:=(Y2[i]-Y1[i])/(j2[i]-j1[i]);
      y0u[i]:=Y1[i]-J1[i]*Dyu[i];
    end
    else
    begin
      messageCentral('Bad parameters in file header');
      Dyu[i]:=1;
      y0u[i]:=0;
    end;

    if nbSamp[i]<>0
      then Dxu[i]:=DataRecLength/nbSamp[i]
      else Dxu[i]:=1;

    offrec[i]:=recSize;
    sizeRec[i]:=nbSamp[i]*2;
    recSize:=recSize+sizeRec[i];
  end;

  f.free;
  result:=true;

  EXCEPT
    f.free;
    result:=false;
  END;

end;



function TEDFdescriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
var
  i:integer;
  data0:typedataFileIK;
  mask:Tmsk;
  segs:TKsegArray;
begin
  if (voie<1) or (voie>Qnbvoie) or (seq>1) then
    begin
      getData:=nil;
      exit;
    end;

  setLength(mask,1);
  mask[0]:=true;
  setLength(segs,NbDataRec);

  for i:=0 to nbDataRec-1 do
  with segs[i] do
  begin
    off:=256*(1+Qnbvoie)+Offrec[voie-1]+i*RecSize;
    size:=sizeRec[voie-1];
  end;

  evtMode:=false;

  data0:=typedataFileIK.create(stDat,mask,segs,false,0,0);

  data0.setConversionX(Dxu[voie-1],0);
  data0.setConversionY(Dyu[voie-1],Y0u[voie-1]);

  result:=data0;
end;

function TEDFdescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  getTpNum:=G_smallint;
end;


function TEDFdescriptor.nbVoie:integer;
begin
  nbvoie:=Qnbvoie;
end;

function TEDFdescriptor.nbSeqDat:integer;
begin
  result:=1
end;


function TEDFdescriptor.FichierContinu:boolean;
begin
  result:=true;
end;

procedure TEDFdescriptor.displayInfo;
var
  viewText:TviewText;
  st:AnsiString;
  i:integer;
begin
  viewText:=TviewText.create(nil);
  with ViewText do
  begin
    Caption:='File info';
    Font.Name:='Courier New';
    Font.size:=10;

    memo1.Lines.add(ExtractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    memo1.Lines.add('Format: EDF');

    memo1.Lines.add(stPatient);
    memo1.Lines.add(stRecording);
    memo1.Lines.add(stStartDate);
    memo1.Lines.add(stStartTime);

    memo1.Lines.add('Number of channels: '+Istr(Qnbvoie));

    memo1.Lines.add('');
    for i:=1 to Qnbvoie do
    begin
      memo1.Lines.add('Channel '+Istr(i)+'  :');
      memo1.Lines.add('        '+stLabel[i-1]);
      memo1.Lines.add('        '+stTransType[i-1]);
    end;

    showModal;
  end;
  viewText.free;
end;



function TEDFdescriptor.unitX: AnsiString;
begin
  result:='sec';
end;

function TEDFdescriptor.unitY(num:integer): AnsiString;
begin
  result:=stPhysDim[num-1];
end;

class function TEDFdescriptor.FileTypeName: AnsiString;
begin
  result:='European Data File';
end;

end.

