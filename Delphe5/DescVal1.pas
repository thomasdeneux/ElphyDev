unit DescVal1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,SysUtils,
     util1, dtf0,debug0,Dgraphic,
     descac1,
     stmDef;


type

  TVALdescriptor=class(TfileDescriptor)
    private
      stDat:AnsiString;
      dateD:integer;

      header:TstringList;
      DataStart:integer;
      DFsize:integer;

      rate:float;
      Nchannels:integer;
      ampGain:array[1..16] of float;  {le numéro commence à zéro dans le fichier}
      dma_bufSize:integer;

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
      function unitX:AnsiString;override;
      function unitY(num:integer):AnsiString;override;

      class function FileTypeName:AnsiString;override;
    end;

implementation

{ TVALdescriptor }

constructor TVALdescriptor.create;
begin
  inherited;
  header:=TstringList.Create;
  {$IFDEF VER150}  { Delphi7 }
  header.NameValueSeparator:=#9;
  {$ENDIF}
end;


destructor TVALdescriptor.destroy;
begin
  header.free;
  inherited;
end;

procedure TVALdescriptor.displayInfo;
var
  st:AnsiString;
  i:integer;
begin
  st:='';
  {$IFDEF VER150} { Delphi7 }
  with header do
  for i:=0 to count-1 do
    st:=st+names[i]+'|'+valueFromIndex[i]+ crlf;
  messageCentral(st);
  {$ENDIF}
end;

function TVALdescriptor.FichierContinu: boolean;
begin
  result:=true;
end;

class function TVALdescriptor.FileTypeName: AnsiString;
begin
  result:='VAL';
end;

function TVALdescriptor.getData(voie, seq: integer;var evtMode: boolean): typeDataB;
var
  i:integer;
  data0:typeDataB;
  mask:Tmsk;
  segs:TKsegArray;
  nbseg,blocksize:integer;

begin
  data0:=nil;
  result:=nil;
  evtMode:=false;

  if (voie<1) or (voie>nbvoie) then exit;

  setLength(mask,nbvoie);
  for i:=0 to nbvoie-1 do
    mask[i]:=(i+1=voie);

  BlockSize:=dma_bufsize*2+4;
  nbseg:=(DFsize-DataStart) div BlockSize;

  setLength(segs,nbseg);
  for i:=0 to nbseg-1 do
  with segs[i] do
  begin
    off:=dataStart+4+i*BlockSize;
    size:=BlockSize-4;
  end;

  data0:=typedataFileIK.create
      (stdat,mask,segs,false,0,0);

  if assigned(data0) then
    begin
      data0.setConversionX(nbvoie/rate,0);
      data0.setConversionY(1E7/ampGain[voie]/2048,0);
    end;

  result:=data0;
end;

function TVALdescriptor.getTpNum(voie, seq: integer): typetypeG;
begin
  result:=G_smallint;
end;

function TVALdescriptor.init(st: AnsiString): boolean;
var
  f:TfileStream;
  ft:text;
  res:integer;
  cnt:integer;
  Ferror:boolean;
  st1:AnsiString;
  i:integer;
  stDum:string[15];
begin
  result:=false;

  stDat:=st;
  f:=nil;

  TRY
  f:=TfileStream.create(stDat,fmOpenRead);
  storeFileParams(f);

  DFsize:=f.size;

  stDum[0]:=#13;
  f.read(stDum[1],15);
  f.free;
  Except
  f.free;
  exit;
  End;

  if stDum<>'%%BEGINHEADER' then exit;

  DataStart:=0;

  assignFile(ft,st);
  TRY
  reset(ft);
  readln(ft,st1);
  inc(dataSTart,length(st1)+1);
  if st1<>'%%BEGINHEADER' then
    begin
      closeFile(ft);
      exit;
    end;

  cnt:=0;
  Header.add(st1);
  repeat
    readln(ft,st1);
    inc(dataSTart,length(st1)+1);
    Header.add(st1);
    Ferror:=(cnt>1000) or eof(ft) or (length(st1)>200);
    inc(cnt);
  until (st1='%%ENDHEADER') or Ferror;

  close(ft);
  if Ferror then exit;
  Except
  closeFile(ft);
  exit;
  End;

  {DisplayInfo;}

  with header do
  begin
    rate:=valR(values['% rate: ']);
    if rate<=0 then exit;

    dma_bufsize:=valI(values['% dma_bufsize: ']);
    if dma_bufsize<=0 then exit;

    nchannels:=valI(values['% nchannels: ']);
    if (nchannels<1) or (nchannels>16) then exit;

    for i:=1 to nchannels do
    begin
      ampGain[i]:=valR(values['% channel '+Istr(i-1)+' ampgain: ']);
      if ampGain[i]<=0 then ampGain[i]:=1;
    end;
  end;


  result:=(DFsize>DataStart);
end;

function TVALdescriptor.nbPtSeq(voie: integer): integer;
begin
  result:=0;
end;

function TVALdescriptor.nbSeqDat: integer;
begin
  result:=1;
end;

function TVALdescriptor.nbvoie: integer;
begin
  result:=nchannels;
end;

function TVALdescriptor.unitX: AnsiString;
begin
  result:='sec';
end;

function TVALdescriptor.unitY(num: integer): AnsiString;
begin
  result:='µV';
end;

end.
