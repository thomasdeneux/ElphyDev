unit standac1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,classes,sysutils,dateUtils,math,
     util1,chrono0,clock0,ncdef2,
     D7random1;




{Gestion de chaines}
function fonctionChr(i:integer):AnsiString;   pascal;
function fonctionCopy(st:AnsiString;p,l:integer):AnsiString;pascal;

procedure proDelete(var st:AnsiString;p,n:integer);pascal;
procedure proDelete_1(var st:PgString;sz:integer;p,n:integer);pascal;

procedure ProInsert(source:AnsiString;var st:AnsiString;p:integer);pascal;
procedure ProInsert_1(source:AnsiString;var st:PgString;sz:integer;p:integer);pascal;

function fonctionLength(st:AnsiString):integer; pascal;
function fonctionPos(s,st:AnsiString):integer; pascal;

procedure proSupSpace(var st:AnsiString);pascal;
procedure proSupSpace_1(var st:PgString;sz:integer);pascal;

function FonctionValInt(st:AnsiString):longint;pascal;
function FonctionValReal(st:AnsiString):float; pascal;


{Routines trigonométriques}
function fonctionSin(x:float):float;            pascal;
function fonctionCos(x:float):float;            pascal;
function fonctionTan(x:float):float;            pascal;

function fonctionArcSin(x:float):float;        pascal;
function fonctionArcCos(x:float):float;        pascal;
function fonctionArcTan(x:float):float;        pascal;

function fonctionSinC(x:float):float;          pascal;

{Routines mathématiques}
function fonctionAbs(x:integer):integer;        pascal;
function fonctionAbs_1(x:float):float;          pascal;

function fonctionAbsI(x:longint):longint;       pascal;

function fonctionExp(x:float):float;            pascal;
function fonctionFrac(x:float):float;           pascal;
function fonctionLn(x:float):float;             pascal;
function fonctionPi:float;                      pascal;

function fonctionRandom:float;                  pascal;
function fonctionRandom_1(n:integer):integer;  pascal;
function fonctionRandomI(n:longint):longint;    pascal;
procedure ProRandomize;                         pascal;
procedure proSetRandSeed(n:integer);            pascal;

function fonctionRound(x:float): int64;        pascal;
function fonctionTrunc(x:float): int64;        pascal;
function fonctionFloor(x:float): int64;        pascal;
function fonctionCeil(x:float):  int64;        pascal;

function fonctionSqrC(x:TfloatComp):TfloatComp; pascal;
function fonctionSqr(x:float):float;            pascal;
function fonctionSqrI(x:longint):longint;       pascal;

function fonctionSqrtC(x:TfloatComp):TfloatComp;pascal;
function fonctionSqrt(x:float):float;           pascal;

{Divers}
procedure proInitChrono;                        pascal;
function fonctionChrono:AnsiString;             pascal;
procedure ProDelay(m:integer);                  pascal;
function fonctionSizeof(var x;n:integer;tp:word):longint; pascal;

function fonctionPower(a,b:float): float;       pascal;




procedure proGsTest(var x: float);pascal;

function fonctionparamstr(i:integer):AnsiString;pascal;
function fonctionMaj(st:AnsiString):AnsiString;pascal;
function fonctionLowerCase(st:AnsiString):AnsiString;pascal;

procedure proDecodeDateTime(AValue: TDateTime;var AYear:integer;tYear:integer;
                                              var AMonth:integer; tMonth:integer;
                                              var ADay:integer; tDay:integer;
                                              var AHour:integer; tHour:integer;
                                              var AMinute:integer; tMinute:integer;
                                              var ASecond:integer; tSecond:integer;
                                              var AMilliSecond:integer; tMilliSecond:integer
                                              );pascal;

function fonctionEncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: integer):TDateTime;pascal;
function fonctionNow:TDateTime;pascal;

procedure proSimpleParser(buf:AnsiString;
                   var pcDef:integer;
                   var stMot:AnsiString;
                   var tp:integer;
                   var x:float;
                   var error:integer;
                   Sep:AnsiString);pascal;


function fonctionCreateDir(st:AnsiString):boolean;pascal;
function fonctionDeleteFile(FileName: AnsiString): Boolean;pascal;
function fonctionDirectoryExists(Directory: Ansistring): Boolean;pascal;

function fonctionTempDirectory: AnsiString;pascal;
function fonctionDataRoot: AnsiString;pascal;
function fonctionPgRoot: AnsiString;pascal;

function fonctionRenameFile(OldName, NewName: AnsiString): Boolean;pascal;
function fonctionRemoveDir(Dir: AnsiString): Boolean;pascal;
function fonctionCopyFile(src,dest:AnsiString): boolean;pascal;

function fonctionHstep(x:float):float;pascal;

IMPLEMENTATION

{Gestion de chaînes }

function fonctionChr(i:integer):AnsiString;
begin
  result:=chr(i);
end;


function fonctionCopy(st:AnsiString;p,l:integer):AnsiString;
begin
  if (p<1) or (p>length(st))
    then sortieErreur('Copy : position out of range');
  result:=copy(st,p,l);
end;

procedure proDelete(var st:AnsiString;p,n:integer);
begin
  if (p<1) or (p>length(st))
    then sortieErreur('Delete : position out of range');
  delete(st,p,n);
end;

procedure proDelete_1(var st:PgString;sz:integer;p,n:integer);
var
  st1:shortString absolute st;
begin
  if (p<1) or (p>length(st1)) then sortieErreur('Delete : position out of range');
  delete(st1,p,n);
end;



procedure ProInsert(source:AnsiString;var st:AnsiString;p:integer);
begin
  insert(source,st,p);
end;

procedure ProInsert_1(source:AnsiString;var st:PgString;sz:integer;p:integer);
var
  st1:shortString absolute st;
  st0:shortString;
begin
  st0:=st1;
  insert(source,st0,p);
  st1:=copy(st0,1,sz-1);
end;


function fonctionLength(st:AnsiString):integer;
begin
  result:=length(st);
end;

function fonctionPos(s,st:AnsiString):integer;
begin
  result:=pos(s,st);
end;

procedure proSupSpace(var st:AnsiString);
begin
  st:=Fsupespace(st);
end;

procedure proSupSpace_1(var st:PgString;sz:integer);
var
  st1:shortString absolute st;
begin
  st1:=Fsupespace(st1);
end;



function FonctionValInt(st:AnsiString):longint;
var
  code:integer;
  i:longint;
begin
  val(st,i,code);
  if code=0 then result:=i
            else result:=0;
end;

function FonctionValReal(st:AnsiString):float;
var
  code:integer;
  x:float;
begin
  val(st,x,code);
  if code=0 then result:=x
            else result:=0;
end;




{Routines trigonométriques}
function fonctionSin(x:float):float;
  begin
   fonctionSin:=sin(x);
  end;

function fonctionCos(x:float):float;
begin
  result:=cos(x);
end;

function fonctionTan(x:float):float;
begin
  result:=Tan(x);
end;

function fonctionArcSin(x:float):float;
begin
  result:=arcSin(x);
end;

function fonctionArcCos(x:float):float;
begin
  result:=arcCos(x);
end;

function fonctionArcTan(x:float):float;
begin
  result:=arctan(x);
end;

function fonctionSinC(x:float):float;
begin
  if abs(x)<1E-38
    then result:=1
    else result:=sin(x)/x;
end;

{Routines mathématiques}
function fonctionAbs(x:integer):integer;
begin
  result:=abs(x);
end;

function fonctionAbs_1(x:float):float;
begin
  result:=abs(x);
end;

function fonctionAbsI(x:longint):longint;
begin
  result:=abs(x);
end;

function fonctionExp(x:float):float;
begin
 result:=exp(x);
end;

function fonctionFrac(x:float):float;
begin
  result:=frac(x);
end;


function fonctionLn(x:float):float;
begin
  result:=ln(x);
end;

function fonctionPi:float;
begin
  result:=Pi;
end;

function fonctionRandom:float;
begin
  fonctionRandom:=GRandom;
end;

function fonctionRandom_1(n:integer):integer;
begin
  result:=Grandom(n);
end;

function fonctionRandomI(n:longint):longint;
begin
  fonctionRandomI:=GRandom(n);
end;

procedure ProRandomize;
begin
  Grandomize;
end;

procedure proSetRandSeed(n:integer);
begin
  GsetRandSeed(n);
end;

function fonctionRound(x:float): int64;
begin
  fonctionRound:=round(x);
end;

function fonctionTrunc(x:float): int64;
begin
  fonctionTrunc:=trunc(x);
end;

function fonctionFloor(x:float): int64;
begin
  result:=floor(x);
end;

function fonctionCeil(x:float): int64;
begin
  result:=ceil(x);
end;


function fonctionSqrC(x:TfloatComp):TfloatComp;
begin
  result:=sqrCpx(x);
end;

function fonctionSqr(x:float):float;
begin
  result:=sqr(x);
end;

function fonctionSqrI(x:longint):longint;
  begin
    fonctionSqrI:=sqr(x);
  end;

function fonctionSqrtC(x:TfloatComp):TfloatComp;
begin
   result:=sqrtCpx(x);
end;

function fonctionSqrt(x:float):float;
begin
   result:=sqrt(x);
end;


{Divers}

procedure proInitChrono;
  begin
    initChrono;
  end;

function fonctionChrono:AnsiString;
  begin
    fonctionChrono:=chrono;
  end;

procedure ProDelay(m:integer);
var
  t:longword;
  msg:Tmsg;
begin
  t:=getTickCount;
  repeat
  until getTickCount>t+m;
end;



function fonctionSizeof(var x;n:integer;tp:word):longint;
begin
  fonctionSizeof:=n;
end;




procedure proGsTest(var x:float);
begin
  x:=x+10;
  messageCentral(Estr(x,3));
end;


function fonctionparamstr(i:integer):AnsiString;
begin
  if (i>=0) and (i<=paramCount)
    then result:=paramstr(i)
    else result:='';
end;

function fonctionMaj(st:AnsiString):AnsiString;
begin
  result:=Uppercase(st);
end;

function fonctionLowerCase(st:AnsiString):AnsiString;
begin
  result:=Lowercase(st);
end;

procedure proDecodeDateTime(AValue: TDateTime;var AYear:integer;tYear:integer;
                                              var AMonth:integer; tMonth:integer;
                                              var ADay:integer; tDay:integer;
                                              var AHour:integer; tHour:integer;
                                              var AMinute:integer; tMinute:integer;
                                              var ASecond:integer; tSecond:integer;
                                              var AMilliSecond:integer; tMilliSecond:integer
                                              );
var
  AYear1, AMonth1, ADay1, AHour1, AMinute1, ASecond1, AMilliSecond1: Word;
begin
  decodeDateTime(Avalue,AYear1, AMonth1, ADay1, AHour1, AMinute1, ASecond1, AMilliSecond1);

  setIntegerWithTp(Ayear,typeNombre(tYear),Ayear1);
  setIntegerWithTp(AMonth,typeNombre(tMonth),AMonth1);
  setIntegerWithTp(ADay,typeNombre(tDay),ADay1);
  setIntegerWithTp(AHour,typeNombre(tHour),AHour1);
  setIntegerWithTp(AMinute,typeNombre(tMinute),AMinute1);
  setIntegerWithTp(ASecond,typeNombre(tSecond),ASecond1);
  setIntegerWithTp(AMilliSecond,typeNombre(tMilliSecond),AMilliSecond1);
end;

function fonctionEncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: integer):TDateTime;
begin
  result:=EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
end;

function fonctionNow:TDateTime;
begin
  result:=Now;
end;


procedure proSimpleParser(buf:AnsiString;
                   var pcDef:integer;
                   var stMot:AnsiString;
                   var tp:integer;
                   var x:float;
                   var error:integer;
                   Sep:AnsiString);
var
  charSep:SetChar;
  tp1:typeLexBase;
  i:integer;
begin
  charsep:=[];
  for i:=1 to length(sep) do CharSep:=CharSep+[sep[i]];

  LireUlexBase(buf, pcDef, stMot,tp1, x, error, charSep);
  tp:=ord(tp1);

end;

function fonctionCreateDir(st:AnsiString):boolean;
begin
  result:=createDir(st);
end;


function fonctionDeleteFile(FileName: AnsiString): Boolean;
begin
  result:= DeleteFile(FileName);
end;

function fonctionDirectoryExists(Directory: Ansistring): Boolean;
begin
  result:= DirectoryExists(Directory);
end;

function fonctionTempDirectory: AnsiString;
begin
  if DirectoryExists(TempDirectory)
    then result:= TempDirectory
    else result:= AppData;

  if (length(result)>0) and (result[length(result)]<>'\')
    then result:=result+'\';
end;

function fonctionDataRoot: AnsiString;
begin
  if DirectoryExists(UnicDataRoot)
    then result:= UnicDataRoot
    else result:= AppData;

  if (length(result)>0) and (result[length(result)]<>'\')
    then result:=result+'\';
end;

function fonctionPgRoot: AnsiString;
begin
  if DirectoryExists(UnicPgRoot)
    then result:= UnicPgRoot
    else result:= AppData;
  if (length(result)>0) and (result[length(result)]<>'\')
    then result:=result+'\';
end;

function fonctionRenameFile(OldName, NewName: AnsiString): Boolean;
begin
  result:= RenameFile(OldName, NewName);
end;

function fonctionRemoveDir(Dir: AnsiString): Boolean;
begin
  result:= RemoveDir( Dir);
end;

function fonctionCopyFile(src,dest:AnsiString): boolean;
var
  f1,f2: TfileStream;
begin
  result:=false;
  f1:=nil;
  f2:=nil;

  try
  f1:= TfileStream.create(src, fmOpenRead);
  f2:=TfileStream.create(dest, fmCreate);
  f2.copyFrom(f1,f1.Size);
  result:=true;

  except
  end;

  f1.free;
  f2.free;

end;

function fonctionHstep(x:float):float;
begin
  result:=ord(x>=0);
end;

function fonctionPower(a,b:float): float;
begin
  result:=power(a,b);
end;

end.
