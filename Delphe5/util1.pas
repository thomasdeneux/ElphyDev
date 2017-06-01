unit util1;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,messages,sysutils,math,Dialogs,graphics,forms, Controls, stdCtrls, ExtCtrls, dateUtils,
     jpeg, pngImage ;



Const
  {$IFDEF DEBUG}
  DebugPath: AnsiString ='D:\delphe5\';
  {$ELSE}
  DebugPath: AnsiString ='';
  {$ENDIF}
  MatlabPath:AnsiString='';
  UnicDataRoot: AnsiString='';
  UnicPgRoot: AnsiString='';
  TempDirectory: AnsiString='c:\temp\';

  GDebugMode: boolean=false;
  DebugCode: integer=0;

  MainHW: Thandle=0;
var
  AppDir:AnsiString;      { Répertoire de l'application }
  AppData:AnsiString;     { Répertoire des paramètres de l'application ou des fichiers temporaires }

var
  MemManagerSize:integer; { Managed Memory in MegaBytes }

  exceptionMask0:TFPUexceptionMask;

  FnoSmartTestEscape: boolean;
type

  {$IFDEF WIN64}
  intG = int64;
  {$ELSE}
  intG = longint;
  {$ENDIF}

  PintG = ^intG;
  PgString=integer;        { Utilisé par le compilateur AC1 pour transmettre
                             les chaines par référence. Dans ce cas, on transmet une adresse
                             + la taille de la variable chaine }

const
  maxTick=30;

  maxEntierLong=2147483647;
  minEntierLong=-2147483647;

  maxLongWord=4294967295;

  maxFloat=1E300;        { 1E2000 dans les premières versions (extended)
                           on se limite aux doubles pour win64 }
 {$IFDEF WIN64}
  //maxmem=maxLongWord;  { Bizarrement, avec IPP version 7, en 64 bits, il est impossible d'allouer plus de 2 Gb }
  maxmem= maxEntierLong;
 {$ELSE}
  maxmem= maxEntierLong;
 {$ENDIF}


type
  float=extended;               // extended en 32 bits , double en 64 bits
  {$IFDEF WIN64}
  float_= array[0..9] of byte;  // structure de 10 octets qui aide aux conversions en 64 bits
  {$ELSE}
  float_= extended; 
  {$ENDIF}

  typeType=(octet,entier,entierLong,reel,etendu,chaine,booleen,rien);

  // Rem: il manque longword et int64 mais il est impossible de les insérer après longint:
  //       Le type est sauvé dans de nombreux objets
  //       On les ajoute à la fin (octobre 2016)

  typeTypeG=(G_byte,G_short,G_smallint,G_word,G_longint,
             G_single,G_real,G_double,G_extended,
             G_singleComp,G_doubleComp,G_extComp,
             G_none,
             G_longword, G_int64);
                                
Const
  MatlabTypes=[G_byte..G_single,G_double,G_singleComp,G_doubleComp ];

const
  tailleTypeG:array[G_byte..G_none] of byte=(1,1,2,2,4,4,6,8,10,8,16,20,0);
  TypeNameG:array[G_byte..G_int64] of string[10]=
             ('Byte','Short','Smallint','Word','Longint',
              'Single','Real48','Double','Extended',
              'SComplex','DComplex','Complex','None','Longword','Int64');

type
{
  st3=string[3];
  st9=string[9];
  st80=string[80];
}
  Pbyte=     ^byte;
  Pshort=    ^shortint;
  Pinteger=  ^integer;
  Pword=     ^word;
  Plongint=  ^longint;
  PsmallInt= ^smallInt;
  PDword=    ^longword;

  Preal=     ^real;
  Psingle=   ^single;
  Preal48=   ^Real48;
  Pdouble=   ^double;
  Pextended= ^extended;
  Pcomp=     ^comp;

  Pfloat=    ^float;
  Pboolean=  ^boolean;
  Pshortstring=   ^ShortString;
  Pchar0=    ^AnsiChar;

  typeTabOctet= array[0..65534] of byte;
  typeTabSHort= array[0..65535] of shortInt;
  typeTabOctet1=array[1..65534] of byte;
  typeTabWord=  array[0..32760] of word;
  typeTabEntier=array[0..32760] of smallint;
  typeTabEntier1=array[1..32760] of smallint;
  typeTabLong=  array[0..16380] of longint;
  typeTabLong1= array[1..16380] of longint;

  typeTabLongWord=  array[0..10000] of longword;
  typeTabLongWord1= array[1..10000] of longword;

  typeTabFloat= array[0..6500] of float;
  typeTabFloat1=array[1..6500] of float;
  typeTabSingle=array[0..16382] of single;

  typeTabDouble=array[0..8190] of double;
  typeTabDouble1=array[1..8190] of double;


  typeTabChar= array[0..65534] of AnsiChar;
  typeTabChar1= array[1..65534] of AnsiChar;

  typeTabPointer=  array[0..16380] of pointer;
  typeTabPointer1= array[1..16380] of pointer;
  PtabPointer=     ^typeTabPointer;
  PtabPointer1=    ^typeTabPointer1;

  PtabOctet=  ^typeTabOctet;
  PTabShort=^typeTabShort;
  PtabOctet1= ^typeTabOctet1;

  PtabWord=   ^typeTabWord;
  PtabEntier= ^typeTabEntier;
  PtabEntier1=^typeTabEntier1;
  PtabLong=   ^typeTabLong;
  PtabLongWord=   ^typeTabLongWord;

  PtabLong1=  ^typeTabLong1;
  PtabLongWord1=  ^typeTabLongWord1;

  PtabFloat=  ^typeTabFloat;
  PtabFloat1= ^typeTabFloat1;
  PtabSingle= ^typeTabSingle;

  PtabDouble=^typeTabDouble;
  PtabDouble1=^typeTabDouble1;


  PTabChar=  ^typeTabChar;
  PTabChar1=  ^typeTabChar1;

  typeTabBoolean=array[0..65000] of boolean;
  typeTabBoolean1=array[1..65000] of boolean;

  PTabBoolean=^typeTabBoolean;
  PTabBoolean1=^typeTabBoolean1;


  typeTabTabFloat1=array[1..16000] of PtabFloat1;
  PtabTabFloat1=^typeTabTabFloat1;

  typeTick=record
               w:float;
               aff:boolean;
           end;
  typeTabTick=array[1..maxTick] of typeTick;

  setChar=set of AnsiChar;
  setByte=set of byte;

  typeProcedure=procedure;
  typeFonctionEE=function(x:float):float;
  typeFonctionEL=function(i:longint):float;

  Ppointer=^pointer;

type
  TsingleComp=record
                x,y:single;
              end;
  TdoubleComp=record
                x,y:double;
              end;
  TFloatComp= record
                x,y:float;
              end;

  PsingleComp=^TsingleComp;
  PdoubleComp=^TdoubleComp;
  PFloatComp=^TFloatComp;

  typeTabSingleComp=array[0..1] of TsingleComp;
  PTabSingleComp=^typeTabSingleComp;
  typeTabDoubleComp=array[0..1] of TdoubleComp;
  PTabDoubleComp=^typeTabDoubleComp;
  typeTabFloatComp=array[0..1] of TFloatComp;
  PTabFloatComp=^typeTabFloatComp;

  TcybTag= record
             tt: longword;
             wt:  word;
           end;
  TtabCybTag= array[0..1] of TcybTag;
  PtabCybTag= ^TtabCybTag;

const
  stOui='TRUE';
  stNON='FALSE';
  stValidation='Validate';

const
  CRLF=#13+#10;

procedure ProcedureRien;

function chaineReel(x:float):AnsiString;
function division(excursion:float):float;
function MinP10(x:float):float;

function Istr(i:longint):AnsiString;

function Int64str(i:int64):AnsiString;
function Int64Str1(i: int64;n:integer):AnsiString;

function Estr0(x:float):AnsiString;
function Estr(x:float;m:integer):AnsiString;
function Istr1(i:longint;n:integer):AnsiString;
function Istr2(i:longint;n:integer):AnsiString;
function Estr1(x:float;n,m:integer):AnsiString;
function Bstr(x:boolean):AnsiString;

function Pstr(p:pointer):AnsiString;

function valI(st:AnsiString):longint;
function valR(st:AnsiString):float;

procedure writeEX(x:float;n,m:integer);
   { sortie d'un r‚el ‚tendu identique … write(x:n:m) mais en empŠchant
     les d‚bordements }
   { si m>=n ou bien x trop faible ou trop ‚lev‚,x est sorti sous le format
     +a.aaaE+aaaa , il faut n>=10 }

procedure writeOctet(x:byte;n:integer);
procedure writeInt (x:integer;n:integer);
procedure writeLong(x:Longint;n:integer);
procedure writeStr (st:AnsiString;n:integer);

function ChaineEtendu(x:float;n,m:integer):AnsiString;
function ChaineEtendu1(x:float;n,m:integer):AnsiString;

function exposant(x:float):integer;

function chaineGrad(x:float):AnsiString;

procedure affecterNombre(st:AnsiString;var z;t:typeType);
  { utilise la proc‚dure val pour convertir la chaine st en un nombre x
    de type t.  Si une erreur se produit, le variable x n'est pas affect‚e }



function Utime(n:longint):AnsiString;  { n est une date compact‚e ,les 2 routines }
function Udate(n:longint):AnsiString;  { renvoient l'heure et la date en langage  }
                                   { clair (12 et 15 caractŠres }

function UgetTime:AnsiString;  { les 2 routines renvoient }
function UgetDate:AnsiString;  { l'heure et la date du systŠme en langage  }
                           { clair (12 et 15 caractŠres }

function datePclamp:AnsiString; { renvoie la date … la mode Pclamp:
                              aamjj
                              le mois=1..9,A,B,C
                            }
function dateClassic:AnsiString;{ renvoie date sou la forme yymmdd }

function log10(x:float):float;
function exp10(x:float):float;

function truncL(x:float):longint;
function truncI(x:float):integer;

function roundI(x:float):integer;
function roundL(x:float):longint;


procedure TickLog(y1,y2:float;var NbTick:integer;var tabTick:typeTabTick);
procedure TickNorm(y1,y2:float;var NbTick:integer;var tabTick:typeTabTick;
                   modulo:integer);

procedure supespace(var buf:shortString);
procedure supespaceFin(var buf:shortString);
procedure supespaceDebut(var buf:shortString);

function Fsupespace(st:AnsiString):AnsiString;
function FsupespaceFin(st:AnsiString):AnsiString;
function FsupespaceDebut(st:AnsiString):AnsiString;
function FsupespaceDebutEtFin(st:AnsiString):AnsiString;


function Jgauche(st0:AnsiString;n:integer):AnsiString;
function Jdroite(st0:AnsiString;n:integer):AnsiString;
function Fmaj(st:AnsiString):AnsiString;

function nbCarSt(c:AnsiChar;st:Ansistring):integer;
  { donne le nb de caractŠres c dans st }

function sortirMot(sep:setchar;var st:AnsiString):AnsiString;
           { donne le premier mot de la chaîne st ou le premier caractère   }
           { de st contenu dans Sep en considérant que les espaces sont des }
           { séparateurs. Le mot est enlevé de st.}
           { Les espaces du début de st sont enlevés. }


function Hexa(w:integer;const nbDigit:integer=0):AnsiString;

function LongToHexa(w:intG):AnsiString;
function hexaTolong(st:Ansistring):longint;

type
  typeLexBase=(videB,nombreB,chaineB,motB,AutreB,finB);

procedure lireULexBase(buf:AnsiString;
                   var pcDef:integer;
                   var stMot:AnsiString;
                   var tp:typeLexBase;
                   var x:float;
                   var error:integer;
                   charSep:setChar);

{ lireULexBase sort les nombres signés,
                les chaines de caractères ( tous caractères entre  deux ' ),
                et les identificateurs.

  st designe le bloc de caractères.

  pcDef est la position du dernier caractŠre analys‚. Autrement dit, il
  faut pcDef=0 au premier appel.
  stMot est le mot sorti de la chaîne st.
  tp est le type obtenu.
  x est la valeur du nombre lorque tp=nombreB.

  error vaut 0 si le décodage est correct.
             1 si une chaîne n'a pas été fermée par '.
             2 si un nombre est incorrect:
                  + ou - non suivi de chiffres.
                  valeur illégale.
}


function testNAN(var x:float):boolean;
  { teste si le nombre x vaut NAN sans provoquer l'erreur 207
    La fonction est incomplète }



function gauss(x,s:float):float;

function maxavail:intG;


function SingleToEx(x:single):float;
{ on considŠre que x contient 6 chiffres significatifs et que le septiŠme
  doit ˆtre arrondi.
  Exemple: 1999.997 devient 2000.000
}

function exToSingle(x:float):single;

function ExecuteProcess(st1,st2:String):integer;
function getVolumeSerialNumber(drive:AnsiChar):AnsiString;

function AllocatedMem:int64;

function tabToString(var t;n:integer):AnsiString;
function ppcm(x1,x2:integer):integer;

type
  TCleFunction=function (i:integer):float;
  TechangeProc=procedure (i,j:integer);

procedure Sort(Imin,Imax:integer;cle0:TCleFunction;echange0:TechangeProc);

function NextStringG(var st,st1:AnsiString):boolean;

function CpxNumber(x,y:float):TfloatComp;
function SumCpx(z1,z2:TfloatComp):TfloatComp;
function ProdCpx(z1,z2:TfloatComp):TfloatComp;
function ProdZ1conjZ2(z1,z2:TfloatComp):TfloatComp;
function DiffCpx(z1,z2:TfloatComp):TfloatComp;
function DivCpx(z1,z2:TfloatComp):TfloatComp;
function InvCpx(z:TfloatComp):TfloatComp;
function FloatToCpx(x:float):TfloatComp;

function AngleCpx(z:TfloatComp):float;
function MdlCpx(z:TfloatComp):float;
function MdlCpx2(z:TfloatComp):float;

function Angle(x,y:float):float;
function sqrCpx(z:TfloatComp):TfloatComp;
function sqrtCpx(z:TfloatComp):TfloatComp;

function SingleComp(x,y:single):TsingleComp;
function DoubleComp(x,y:double):TdoubleComp;
function FloatComp(x,y:float):TfloatComp;

function EqualCpx(z1,z2: TfloatComp): boolean;


type
  TarrayOfInteger= array of integer;
  TarrayOfSingle=  array of single;
  TarrayOfDouble=  array of double;
  TarrayOfFloat=   array of float;
  TarrayOfBoolean= array of Boolean;

  TarrayOfInt64= array of int64;

  TarrayOfArrayOfInteger=array of array of integer;
  TarrayOfArrayOfSingle=array of array of single;

  TarrayOfString= array of AnsiString;
  TarrayOfPointer= array of pointer;

function Mediane(t:TarrayOfDouble;N:integer):double;



procedure messageCentral(st:String);overload;
procedure messageCentral(st,caption:String);overload;


function testEscape:boolean;
function testShiftEscape(const hh: integer=0):boolean;
function oem(st:AnsiString):AnsiString;
function ansi(st:AnsiString):AnsiString;

{$IFNDEF _OBJ}
type
 TfontDescriptor=
    object
      Name:String[32];
      height:smallInt;
      Size:smallInt;
      Color:Tcolor;
      {$IFDEF FPC}
      style:byte;       { TfontStyles utilise 4 octets dans la LCL }
      {$ELSE}
      style:Tfontstyles;
      {$ENDIF}
      procedure init;
      function info:AnsiString;
    end;



procedure DescToFont(var desc:TFontDescriptor;font:Tfont);
procedure FontToDesc(font:Tfont;var desc:TFontDescriptor);

type
  typeBoiteInfo=object
                  titreB:AnsiString;
                  buf:AnsiString;
                  constructor init(titre0:AnsiString);
                  procedure writeln(st:AnsiString);
                  procedure write(st:AnsiString);
                  destructor done;
                end;
{$ENDIF}

function typetypeMax(t1,t2:typetypeG):typetypeG;

function typeNameToTypeG(st: AnsiString): typetypeG;
Procedure DisplayLastError;
function getLastErrorString:AnsiString;

procedure swap(var x,y:integer);overload;
procedure swap(var x,y:pointer);overload;
procedure swap(var x,y:float);overload;
procedure swap(var x,y:single);overload;

procedure swapMem(var x,y;size:integer);


type
  TstringInfo=record
                 ref,len:integer;
              end;
  PstringInfo=^TstringInfo;

function stringInfo(var st):TstringInfo;
procedure ShowStringInfo(var st);

function PcharToString(p:pointer;n:integer):AnsiString;
procedure StringToPchar(st:AnsiString;nb:integer;var w);

procedure delay(ms:integer);
function LoadMatLabDLL(stf:AnsiString):intG;

function GLoadLibrary(st:AnsiString): intG;
function getProc(hh:Thandle;st:AnsiString; Const ShowNil: boolean=false):pointer;

function StringToDateTime(st:AnsiString):TdateTime;
function DateTimeToString(w: TdateTime;Const Fsec:boolean=true;Const Fms:boolean=true): AnsiString;

procedure SetVCLdef(form:Tform);

function sar(x,v:smallint): smallint;


function swapBytes(var x: smallint):  smallint;overload;
function swapBytes(var x: longint):   longint;overload;
function swapBytes(var x: double):   double;overload;


procedure proSwapBytes(var x:smallint);pascal;
procedure proSwapBytes_1(var x:longint);pascal;
procedure proSwapBytes_2(var x:double);pascal;

procedure checkRectangle(var rect1: Trect);
function CharToString(ch:PansiChar;nb:integer):Ansistring;

var
  FStoppedState:boolean;
  FlagStopDebug:boolean;

  FdebugMode: boolean;
  StepMode: integer;
  ProcNameOnStop: AnsiString;

procedure MyTest;

procedure LoadBitmapFromFile(bm:Tbitmap; stF:string);
// A un comportement curieux avec les PNG . Utiliser de préférence LoadDibFromFile

procedure SaveBitmapToFile(bm:Tbitmap; stF:string; const quality:integer=100);
function FindFileInPathList(stUnit,SearchPath1: AnsiString): AnsiString;


function StringEmpty(st: AnsiString): boolean;
// Renvoie true si la chaine est vide ou si elle ne contient que des espaces

function NextPower2(n:longword): longword;
function IsPower2(n:longword): boolean;


type
  TUgetV = function(t:pointer;n:integer):double;
  
function UgetShort(t:pointer;n:integer):double;
function UgetByte(t:pointer;n:integer):double;
function UgetSmallint(t:pointer;n:integer):double;
function UgetWord(t:pointer;n:integer):double;
function UgetLong(t:pointer;n:integer):double;
function UgetLongWord(t:pointer;n:integer):double;
function UgetSingle(t:pointer;n:integer):double;
function UgetDouble(t:pointer;n:integer):double;

function UFileAge(const FileName: string; Const mode:integer=1): Integer;
// mode=1 Last Write Time
//      2 Last Acces Time
//      3 Creation Time

IMPLEMENTATION

uses debug0, dibG;

procedure ProcedureRien;
  begin
  end;

function chaineReel{(x:float):AnsiString};
  var st:String[30];
  begin
    str(x:23:10,st);
    supespace(st);
    if pos('.',st)>0 then
      while st[length(st)]='0' do delete(st,length(st),1);

    if st[length(st)]='.' then delete(st,length(st),1);
    if st='-0' then st:='0';
    chaineReel:=st;
  end;

function chaineGrad(x:float):AnsiString;
  var
    st:String[30];
    p:integer;
  begin
    if x=0 then st:='0'
    else
    if (abs(x)<1E7) and (abs(x)>=1E-5) then
      begin
        str(x:20:10,st);
        supespace(st);
        if pos('.',st)>0 then
        while st[length(st)]='0' do delete(st,length(st),1);
        if st[length(st)]='.' then delete(st,length(st),1);
        if st='-0' then st:='0';
      end
    else
      begin
        str(x,st);
        delete(st,5,13);
        if copy(st,3,2)='.0' then delete(st,3,2);
        if st[length(st)-4]='+' then delete(st,length(st)-4,1);
        p:=length(st)-3;
        while st[p]='0' do delete(st,p,1);
        if st[1]=' ' then delete(st,1,1);
      end;

    chaineGrad:=st;
  end;


function division(excursion:float):float;
  var
      x,f:float;
  begin
      x:=0.2*abs(excursion);

      f:=1;
      while (x>=10) and (f<1E100) do
      begin
        x:=x/10;
        f:=f*10;
      end;

      while (x<1) and (f>1E-100) do
      begin
        x:=x*10;
        f:=f/10;
      end;

      if (f>=1E100) or (f<=1E-100) then result:=1   // gestion beta de débordements avec opengl
      else
      begin
        x:=x*5;
        if x<=10 then division:=f
        else
        if x<=20 then division:=f*2
        else
        division:=f*5;
      end;
  end;

function MinP10(x:float):float;
var
  code:integer;
  st:AnsiString;
  f:float;
begin
  str(x,st);
  val('1E'+copy(st,19,5),f,code);
  minP10:=f/10;
end;


function Istr(i:longint):AnsiString;
  var s:String[12];
  begin
    str(i,s);
    Istr:=s;
  end;

function Int64str(i:int64):AnsiString;
begin
  str(i,result);
end;


function Estr0(x:float):AnsiString;
  var
    st:String[30];
    pp,pE:integer;
  begin
    str(x,st);
    supespace(st);
    Estr0:=st;
  end;


function Estr(x:float;m:integer):AnsiString;
var
  st:String[30];
begin
  if m<0 then result:= Estr0(x)
  else
  begin
    str(x:25:m,st);
    supespace(st);
    result:=st;
  end;
end;


function Istr1(i:longint;n:integer):AnsiString;
  var
    st:String[80];
  begin
    str(i,st);
    while length(st)<n do st:=' '+st;
    result:=st;
  end;

function Int64Str1(i: int64;n:integer):AnsiString;
  var
    st:String[80];
  begin
    str(i,st);
    while length(st)<n do st:=' '+st;
    result:=st;
  end;


function Istr2(i:longint;n:integer):AnsiString;
  var
    st:String[80];
  begin
    str(i:n,st);
    for i:=1 to length(st) do
      if st[i]=' ' then st[i]:='0';
    Istr2:=st;
  end;


function Estr1(x:float;n,m:integer):AnsiString;
var
  st:String[30];
begin
  if (n=0) and (m=0)
    then str(x,st)
    else str(x:n:m,st);
  result:=st;
end;


function Bstr(x:boolean):AnsiString;
  begin
    if x then Bstr:='True'
         else Bstr:='False';
  end;

function Pstr(p:pointer):AnsiString;
begin
  result:=longToHexa(intG(p));
end;

function ChaineEtendu{(x:float;n,m:integer):AnsiString};
  var
    st:String[23];
    code:integer;
    a:float;
  begin
    if testNan(x) then
      begin
        chaineEtendu:='0';
        exit;
      end;
    str(x:n:m,st);
    val(copy(st,1,n),a,code);
    if (code<>0) or testNan(a) then a:=0;
    if (a=0) and (x<>0) or (pos('.',st)<>n-m) and (m<>0)
       or (m=0) and (length(st)>n)  then
      begin
        if n<10 then
          begin
            st:='!';
            while length(st)<n do st:=' '+st;
          end
        else
          str(x:n,st);
      end;
    chaineEtendu:=st;
  end;

function ChaineEtendu1(x:float;n,m:integer):AnsiString;
  var
    st:String[30];
  begin
    st:=chaineEtendu(x,n,m);
    supespace(st);

    if pos('E',st)>0 then
      begin
        if pos('.',st)>0 then
          begin
            while st[pos('E',st)-1]='0' do delete(st,pos('E',st)-1,1);
            if st[pos('E',st)-1]='.' then delete(st,pos('E',st)-1,1);
          end;
        while st[pos('E',st)+2]='0' do delete(st,pos('E',st)+2,1);
      end
    else
    if pos('.',st)>0 then
      begin
        while st[length(st)]='0' do delete(st,length(st),1);
        if st[length(st)]='.' then delete(st,length(st),1);
      end;

    chaineEtendu1:=st;
  end;



function valI(st:AnsiString):longint;
  var
    code:integer;
    i:longint;
  begin
    for i:=length(st) downto 1 do
      if (st[i]=' ') or (st[i]=#9)
        then delete(st,i,1);

    val(st,i,code);
    if code=0 then valI:=i
              else valI:=0;
  end;

function valR(st:AnsiString):float;
  var
    code:integer;
    x:float;
    i:integer;
  begin
    for i:=length(st) downto 1 do
      if (st[i]=' ') or (st[i]=#9)
        then delete(st,i,1);

    val(st,x,code);
    if code=0 then valR:=x
              else valR:=0;
  end;



procedure writeEX{(x:float;n,m:integer)};
  begin
    write(chaineEtendu(x,n,m));
  end;

procedure writeOctet(x:byte;n:integer);
  var
    st:String[10];
  begin
    str(x:n,st);
    if length(st)>n then write('!':n)
                    else write(st);
  end;


procedure writeInt(x:integer;n:integer);
  var
    st:String[10];
  begin
    str(x:n,st);
    if length(st)>n then write('!':n)
                    else write(st);
  end;


procedure writeLong(x:Longint;n:integer);
  var
    st:String[12];
  begin
    str(x:n,st);
    if length(st)>n then write('!':n)
                    else write(st);
  end;


procedure writeStr(st:AnsiString;n:integer);
  begin
    st:=copy(st,1,n);
    write(st,'':n-length(st));
  end;

function exposant{(x:float):integer};
  var
    st:String[26];
    i,code:integer;
  begin
   str(x,st);
   val(copy(st,19,5),i,code);
   exposant:=i;
  end;


procedure affecterNombre(st:AnsiString;var z;t:typeType);
    var
      code:integer;
      xE:extended;
      xB:byte     ABSOLUTE xE;
      xI:integer  ABSOLUTE xE;
      xL:longint  ABSOLUTE xE;
      xR:real     ABSOLUTE xE;

      zE:extended ABSOLUTE z;
      zB:byte     ABSOLUTE z;
      zI:integer  ABSOLUTE z;
      zL:longint  ABSOLUTE z;
      zR:real     ABSOLUTE z;

    begin
      case t of
        octet:       begin
                       val(st,xB,code);
                       if code=0 then zB:=xB;
                     end;
        entier:      begin
                       val(st,xI,code);
                       if code=0 then zI:=xI;
                     end;
        entierLong:  begin
                       val(st,xL,code);
                       if code=0 then zL:=xL;
                     end;
        reel:        begin
                       val(st,xR,code);
                       if code=0 then zR:=xR;
                     end;
        etendu:      begin
                       val(st,xE,code);
                       if code=0 then zE:=xE;
                     end;
      end;
    end;


function Udate(n:longint):AnsiString;
  var
    date:TdateTime;
    year,month,day:word;
    d:String[2];
    y:String[4];
    m:String[9];
  begin
    date:=FileDateToDateTime(n);
    DecodeDate(date,year,month,day);
    BEGIN
      str(year:4,y);
      case month of
        1: m:='january';
        2: m:='february';
        3: m:='march';
        4: m:='april';
        5: m:='may';
        6: m:='june';
        7: m:='july';
        8: m:='august';
        9: m:='september';
        10:m:='october';
        11:m:='november';
        12:m:='december';
      end;
      str(day:2,d);
    END;

    Udate:=d+' '+m+' '+y;

  end;

function Utime(n:longint):AnsiString;
  var
    date:TdateTime;
    hour,min,sec,ms:word;
    h,m,s:String[2];
  begin
    date:=FileDateToDateTime(n);
    decodeTime(date,hour,min,sec,ms);
    str(hour:2,h);
    str(min:2,m);
    str(sec:2,s);

    Utime:=h+'h '+m+'mn '+s+'s';
  end;

function UgetDate:AnsiString;
  var
    date:TdateTime;
    n:longint;
  begin
    date:=now;
    n:=DateTimeToFileDate(date);
    UgetDate:=Udate(n);
  end;

function UgetTime:AnsiString;
  var
    date:TdateTime;
    n:longint;
  begin
    date:=now;
    n:=DateTimeToFileDate(date);
    UgetTime:=Utime(n);
  end;


function datePclamp:AnsiString;
  var
    st:AnsiString;
    date:TdateTime;
    an,mois,jour:word;
  begin
    Date:=now;
    decodeDate(date,an,mois,jour);

    st:=copy(Istr(an),3,2);
    if mois<10 then st:=st+Istr(mois)
               else st:=st+chr(mois-10+ord('A'));
    if jour<10 then st:=st+'0'+Istr(jour)
               else st:=st+Istr(jour);
    datePclamp:=st;
  end;

function dateClassic:AnsiString;
  var
    st:AnsiString;
    date:TdateTime;
    an,mois,jour:word;
  begin
    Date:=now;
    decodeDate(date,an,mois,jour);

    st:=copy(Istr(an),3,2);
    if mois<10 then st:=st+'0'+Istr(mois)
               else st:=st+Istr(mois);
    if jour<10 then st:=st+'0'+Istr(jour)
               else st:=st+Istr(jour);
    result:=st;
  end;



function Log10(x:float):float;
  begin
    if x>0 then Log10:=ln(x)/ln(10)
           else Log10:=-10000;         { ln(1E-4000)=-9200 }
  end;

function exp10(x:float):float;
  begin
    x:=x*ln(10);
    if abs(x)<1419 then exp10:=exp(x)
    else
      begin
        if x<0 then exp10:=1E-1000
               else exp10:=1E1000;
      end;
  end;

function truncL(x:float):longint;
  const
     max=2147483647;
  begin
    if x>max then truncL:=max
    else
    if x<-max then truncL:=-max
    else truncL:=trunc(x);
  end;

function truncI(x:float):integer;
  const
     max=32767;
  begin
    if x>max then truncI:=max
    else
    if x<-max then truncI:=-max
    else truncI:=trunc(x);
  end;

function roundI(x:float):integer;
  const
     max=32767;
  begin
    if x>max then roundI:=max
    else
    if x<-max then roundI:=-max
    else roundI:=round(x);
  end;

function roundL(x:float):longint;
  const
     max=2147483647;
  begin
    if x>max then roundL:=max
    else
    if x<-max then roundL:=-max
    else roundL:=round(x);
  end;


procedure TickNorm(y1,y2:float;var NbTick:integer;var tabTick:typeTabTick;
                   modulo:integer);
  var
    dv,a:float;
    c:integer;
    Freturn:boolean;
    tbTk:typeTabTick;
    i:integer;

  begin
    {fillchar(tabTick,sizeof(tabTick),0);}

    if y1>y2 then
      begin
        a:=y1;
        y1:=y2;
        y2:=a;
        Freturn:=true;
      end
    else Freturn:=false;

    dv:=division(Y2-Y1);
    a:=dv*int(Y1/dv);
    if a<Y1 then a:=a+dv;

    if (Y1<0) and (Y2>0)
      then c:=10*modulo+roundI(a/dv)
      else c:=0;

    nbtick:=0;

    while (a<Y2) and (nbtick<maxtick) do
    begin
      inc(nbtick);
      with tabtick[nbtick] do
      begin
        w:=a;
        aff:=(c mod modulo=0);
      end;

      a:=a+dv;
      if abs(a/dv)<1E-10 then a:=0;

      inc(c);
    end;

    if Freturn then
      begin
        fillchar(tbTk,sizeof(tbTk),0);
        for i:=1 to nbtick do tbtk[i]:=tabTick[nbTick-i+1];
        tabTick:=tbTk;
      end;

  end;

procedure TickLog(y1,y2:float;var NbTick:integer;var tabTick:typeTabTick);
    var
      exc,a:float;
      N,i:integer;
      Freturn:boolean;
      tbTk:typeTabTick;


    procedure ranger(z:float;v:boolean);
      begin
        if nbTick>=maxTick then exit;
        inc(nbtick);
        tabTick[nbTick].w:=z;
        tabTick[nbTick].aff:=v;
      end;

    procedure set1(n:integer);
      var
        z:float;
        i:integer;
      begin
        z:=1;
        repeat  z:=z*0.1 until z<y1;
        i:=0;
        repeat
          if (z<=y2) and (z>=y1) and  (i mod n=0) then ranger(z,true);
          z:=z*10;
          inc(i);
        until z>y2;
      end;

    procedure set5;
      var
        z:float;
      begin
        z:=5;
        repeat  z:=z*0.1 until z<y1;
        repeat
          if (z<=y2) and (z>=y1) then ranger(z,false);
          z:=z*10;
        until z>y2;
      end;

    procedure set2;
      var
        z:float;
        i:integer;
      begin
        for i:=1 to 4 do
          begin
            z:=2*i;
            repeat  z:=z*0.1 until z<y1;
            repeat
              if (z<=y2) and (z>=y1) then ranger(z,false);
              z:=z*10;
            until z>y2;
          end;
      end;

    procedure trier;
      var
        ok:boolean;
        i:integer;
        z:typeTick;
      begin
        repeat
          ok:=true;
          for i:=1 to nbtick-1 do
            if tabtick[i].w>tabtick[i+1].w then
              begin
                z:=tabtick[i];
                tabtick[i]:=tabtick[i+1];
                tabtick[i+1]:=z;
                ok:=false;
              end;
        until ok;
      end;

    procedure setDiv;
      var
        z,dv:float;
        i:integer;
      begin
        dv:=division(y2-y1);
        z:=dv*trunc(y1/dv);
        if z<y1 then z:=z+dv;
        repeat
          if (z<=y2) and (z>=y1) then ranger(z,true);
          z:=z+dv;
        until z>y2;
        if nbTick>=8 then
          for i:=1 to nbtick div 2 do
            tabtick[i*2].aff:=false;
      end;

    begin        { of TickLog }
      {affdebug('tickLog '+estr(y1,3)+' '+estr(y2,3) );}
      fillchar(tabTick,sizeof(tabTick),0);

      if y1>y2 then
        begin
          a:=y1;
          y1:=y2;
          y2:=a;
          Freturn:=true;
        end
      else Freturn:=false;


      Nbtick:=0;
      if y2<=y1 then exit;
      exc:=log10(y2)-log10(y1);
      N:=truncI(exc);

      if N>=1 then
        begin
          if N>12 then set1(N div 8 +1)
                  else set1(1);
          if (3<=N) and (N<6) then set5;
          if (N<3) then set2;
        end
      else setdiv;
      trier;

      if Freturn then
        begin
          fillchar(tbTk,sizeof(tbTk),0);
          for i:=1 to nbtick do tbtk[i]:=tabTick[nbTick-i+1];
          tabTick:=tbTk;
        end;

    end;         { of TickLog }



procedure supEspaceFin(var buf:shortString);
  begin
    while (length(buf)>0) and (buf[length(buf)]=' ') do
      delete(buf,length(buf),1);
  end;

procedure supespaceDebut(var buf:shortString);
  begin
    while (length(buf)>0) and (buf[1]=' ') do delete(buf,1,1);
  end;

procedure supespace(var buf:shortString);
  begin
    while pos(' ',buf)>0 do delete(buf,pos(' ',buf),1);
  end;


function Jgauche(st0:AnsiString;n:integer):AnsiString;
  begin
    while length(st0)<n do st0:=st0+' ';
    Jgauche:=copy(st0,1,n);
  end;

function Jdroite(st0:AnsiString;n:integer):AnsiString;
  begin
    while length(st0)<n do st0:=' '+st0;
    Jdroite:=copy(st0,1,n);
  end;


function Fsupespace(st:AnsiString):AnsiString;
begin
  while pos(' ',st)>0 do delete(st,pos(' ',st),1);
  Fsupespace:=st;
end;

function FsupespaceFin(st:AnsiString):AnsiString;
begin
  while (length(st)>0) and (st[length(st)]=' ') do delete(st,length(st),1);
  FsupespaceFin:=st;
end;

function FsupespaceDebut(st:AnsiString):AnsiString;
begin
  while (length(st)>0) and (st[1]=' ') do delete(st,1,1);
  FsupespaceDebut:=st;
end;

function FsupespaceDebutEtFin(st:AnsiString):AnsiString;
begin
  while (length(st)>0) and (st[length(st)]=' ') do delete(st,length(st),1);
  while (length(st)>0) and (st[1]=' ') do delete(st,1,1);
  result:=st;
end;

function Fmaj(st:AnsiString):AnsiString;
 var
    i:integer;
  begin
    for i:=1 to length(st) do st[i]:=upcase(st[i]);
    Fmaj:=st;
  end;

function sortirMot(sep:setchar;var st:AnsiString):AnsiString;
  var
    p:integer;
  begin
    while (length(st)>0) and (st[1]=' ') do delete(st,1,1);
    p:=0;
    repeat inc(p) until (p>length(st)) or (st[p]=' ') or (st[p] in sep);
    if (p>length(st)) or (st[p]=' ')  then sortirMot:=copy(st,1,p-1)
    else
    if p=1 then sortirMot:=st[p]
    else
      begin
        sortirMot:=copy(st,1,p-1);
        dec(p);
      end;
    delete(st,1,p);
    while (length(st)>0) and (st[1]=' ') do delete(st,1,1);
  end;


function maxavail:intG;
  var
    mm:TmemoryStatus;
  begin
    mm.dwlength:=sizeof(mm);
    globalMemoryStatus(mm);
    result:=mm.dwTotalVirtual;
  end;




const
    digit:array[0..15] of AnsiChar='0123456789ABCDEF';

function Hexa(w:integer;const nbDigit:integer=0):AnsiString;
  var
    i:integer;
    st:AnsiString;
  begin
    st:='';
    repeat
      st:=digit[w and $F] +st;
      w:=w shr 4;
    until w=0;

    while length(st)<nbDigit do st:='0'+st;

    Hexa:=st;
  end;

function LongToHexa(w:intG):AnsiString;
var
  i:integer;
  st:AnsiString;
begin
  st:='';
  for i:=1 to 8 do
  begin
    st:=digit[w and $F] +st;
    w:=w shr 4;
    if w=0 then break;
  end;
  LongToHexa:=st;
end;


function hexaTolong(st:Ansistring):longint;
  var
    x:longint;
    i:integer;
    c:AnsiChar;
  begin
    st:=FsupEspace(st);
    st:=Fmaj(st);
    hexaTolong:=-1;
    x:=0;
    while st<>'' do
    begin
      c:=st[1];
      i:=0;
      while (i<=15) and (c<>digit[i]) do inc(i);
      if i<=15 then x:=x*16+i else exit;
      delete(st,1,1);
    end;
    hexaTolong:=x;
  end;

const
  lettre=['A'..'Z','a'..'z','_'];
  chiffre=['0'..'9'];

procedure lireULexBase(buf:AnsiString;
                   var pcDef:integer;
                   var stMot:AnsiString;
                   var tp:typeLexBase;
                   var x:float;
                   var error:integer;
                   charSep:setChar);

  const
    carfin=#26;
  var
    c:AnsiChar;
    code:integer;
    flagMoins:boolean;

  function lire:AnsiChar;
    begin
      inc(pcDef);
      if (length(buf) <pcDef)
        then lire:=carFin
        else lire:=buf[pcDef];
    end;

  procedure renvoyer;
    begin
      dec(pcDef);
    end;

  begin
    stMot:='';
    tp:=videB;
    error:=0;
    repeat c:=lire until (c <>' ');
    if c in charSep then
      begin
        tp:=motB;
        exit;
      end;

    if c=carFin then
      begin
        renvoyer;      { Les prochains appels renverront toujours Carfin }
        tp:=FinB;
        exit;
      end;
    case c of
      '''':
        begin
          stmot:='';
          repeat
            stMot:=stMot+lire;
          until  (stMot[length(stMot)] in [carfin,'''']);
          if stMot[length(stMot)]=carfin then error:=1;
          delete(stMot,length(stMot),1);
          tp:=chaineB;
          c:=lire;
        end;
      'A'..'Z','a'..'z','_':
        begin
          stMot:=c;
          repeat
            stMot:=stMot+lire;
          until not( stMot[length(stMot)] in lettre+chiffre );
          c:=stMot[length(stMot)];
          delete(stMot,length(stMot),1);
          tp:=motB;
        end;
      '0'..'9','+','-':
        begin
          flagMoins:=false;
          if c='+' then
            begin
              c:=lire;
              if not( c in ['0'..'9'] ) then
                begin
                  error:=2;
                  renvoyer;
                  exit;
                end;
            end;

          if c='-' then
            begin
              c:=lire;
              if not( c in ['0'..'9'] ) then
                begin
                  error:=2;
                  renvoyer;
                  exit;
                end
              else FlagMoins:=true;
            end;

          stMot:=c;
          while stMot[length(stMot)] in chiffre do stMot:=stMot+lire;

          if not (stMot[length(stMot)] in ['.','E','e']) then
            begin
              c:=stMot[length(stMot)];
              delete(stMot,length(stMot),1);
              val(stMot,x,code);
              if flagMoins then x:=-x;
              tp:=nombreB;
            end
          else
            begin
              if stMot[length(stMot)]='.' then
                begin
                  stMot:=stMot+lire;
                  while stMot[length(stMot)] in chiffre do stMot:=stMot+lire;
                end;

              if (stMot[length(stMot)]='E') or (stMot[length(stMot)]='e') then
                begin
                  stMot:=stMot+lire;
                  if (stMot[length(stMot)]='+') or (stMot[length(stMot)]='-') then
                    stMot:=stMot+lire;
                  while stMot[length(stMot)] in chiffre do stMot:=stMot+lire;
                end;

              c:=stMot[length(stMot)];
              delete(stMot,length(stMot),1);
              val(stMot,x,code);
              if flagMoins then x:=-x;
              if code=0 then tp:=nombreB
              else error:=2;
            end;
        end;

      else
        begin
          stMot:=c;
          c:=lire;
          tp:=AutreB;
        end;
    end;
    while c=' ' do c:=lire;
    if not(c in charSep) then renvoyer;
  end;


function nbCarSt(c:AnsiChar;st:Ansistring):integer;
  var
    i,n:integer;
  begin
    n:=0;
    for i:=1 to length(st) do
      if st[i]=c then inc(n);
    nbCarSt:=n;
  end;


function testNAN(var x:float):boolean;
  begin
    testNan:=false;
  end;



function arrondi10(x:float):float;
  var
    y:float;
    code:integer;
    st:String[30];
  begin
    arrondi10:=0;
    if x<=0 then exit;
    str(x,st);
    st:=copy(st,length(st)-4,5);
    val(st,y,code);

    arrondi10:=exp(y*ln(10));
  end;

function gauss(x,s:float):float;
  var
    i:integer;
    a:float;
  begin
    a:=0;
    for i:=1 to 12 do a:=a+random;
    gauss:=(a-6)*s+x;
  end;

function SingleToEx(x:single):float;
  var
    st,st1,st2:String[30];
    y:extended;
    code:integer;
  begin
    str(x,st);
    while pos(' ',st)>0 do delete(st,pos(' ',st),1);
    st1:=copy(st,1,pos('E',st)-1);
    st2:=copy(st,pos('E',st),10);
    val(st1,y,code);
    str(y:0:6,st1);
    st1:=st1+st2;
    val(st1,y,code);
    SingleToEx:=y;
  end;

function exToSingle(x:float):single;
begin
  exToSingle:=x;
end;


function ExecuteProcess(st1,st2:String):integer;
var
  processInfo:TprocessInformation;
  startUp:TstartUpInfo;
  flags:Dword;
  code:Dword;
begin
  flags:=0;
  fillchar(startUp,sizeof(startUp),0);
  startUp.cb:=sizeof(startUp);

  result:=-1;
  if not createProcess(Pchar(st1),Pchar(st2),nil,nil,false,Flags,nil,nil,startUp,processInfo)
    then exit;

  WaitForSingleObjectEx(processInfo.hprocess,1000000,false);

  if GetExitCodeProcess(processInfo.hprocess,code)
    then result:=code
    else result:=0;

end;

function getVolumeSerialNumber(drive:AnsiChar):AnsiString;
var
  ok:boolean;
  lpRootPathName:String[255];
  lpVolumeNameBuffer:String[255];
  lpVolumeSerialNumber,lpMaximumComponentLength,lpFileSystemFlags:Dword;
  lpFileSystemNameBuffer:String[255];

begin
  drive:=upcase(drive);
  lpRootPathName:=drive+':\'+#0;
  lpVolumeSerialNumber:=0;
  fillchar(lpVolumeNameBuffer,sizeof(lpVolumeNameBuffer),0);
  ok:=GetVolumeInformation(

        @lpRootPathName[1],         // address of root directory of the file system
        @lpVolumeNameBuffer[1],     // address of name of the volume
        255,                        // length of lpVolumeNameBuffer
        @lpVolumeSerialNumber,	    // address of volume serial number
        lpMaximumComponentLength,   // address of system's maximum filename length
        lpFileSystemFlags,	    // address of file system flags
        @lpFileSystemNameBuffer[1], // address of name of file system
        255                         // length of lpFileSystemNameBuffer
   );

  result:=longToHexa(lpVolumeSerialNumber);
end;

function AllocatedMem:int64;
begin
  result:=getHeapStatus.totalAllocated;
end;

function tabToString(var t;n:integer):AnsiString;
var
  i:integer;
  c:array[1..1000] of AnsiChar absolute t;
begin
  result:='';
  for i:=1 to n do
    if ord(c[i])>=32
      then result:=result+c[i]
      else exit;
end;

function ppcm(x1,x2:integer):integer; 
var
  i:integer;
begin
  if (x1=0) or (x2=0) or (x1=x2) then
    begin
      result:=x1;
      exit;
    end;

  if x1<x2 then i:=x2-1 else i:=x1-1;

  repeat
    inc(i);
  until (i mod x1=0) and (i mod x2=0);

  result:=i;
end;

var
  cle:TCleFunction;
  echange:TechangeProc;



procedure QuickSort(L, R: Integer);
var
  I, J: Integer;
  P, T: float;
begin
  repeat
    I := L;
    J := R;
    P := Cle((L + R) shr 1);
    repeat
      while cle(I)< P do Inc(I);
      while cle(J)> P do Dec(J);
      if I <= J then
      begin
        echange(I,J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure Sort(Imin,Imax:integer;cle0:TCleFunction;echange0:TechangeProc);
begin
  cle:=cle0;
  echange:=echange0;

  if (Imax>=Imin) then
    QuickSort(Imin, Imax);
end;

function NextStringG(var st,st1:AnsiString):boolean;
var
  k:integer;
begin
  k:=pos('|',st);
  if k<=0 then k:=length(st)+1;
  if k>1
    then st1:=copy(st,1,k-1)
    else st1:='';
  delete(st,1,k);
  result:=(st1<>'');
end;

function CpxNumber(x,y:float):TfloatComp;
begin
  result.x:=x;
  result.y:=y;
end;

function SumCpx(z1,z2:TfloatComp):TfloatComp;
begin
  result.x:=z1.x+z2.x;
  result.y:=z1.y+z2.y;
end;

function DiffCpx(z1,z2:TfloatComp):TfloatComp;
begin
  result.x:=z1.x-z2.x;
  result.y:=z1.y-z2.y;
end;


function ProdCpx(z1,z2:TfloatComp):TfloatComp;
begin
  result.x:=z1.x*z2.x-z1.y*z2.y;
  result.y:=z1.x*z2.y+z1.y*z2.x;
end;

function ProdZ1conjZ2(z1,z2:TfloatComp):TfloatComp;
begin
  result.x:=z1.x*z2.x+z1.y*z2.y;
  result.y:=-z1.x*z2.y+z1.y*z2.x;
end;


function DivCpx(z1,z2:TfloatComp):TfloatComp;
var
  m:float;
begin
  m:=sqr(z2.x)+sqr(z2.y);
  result.x:=(z1.x*z2.x+z1.y*z2.y)/m;
  result.y:=(z1.y*z2.x-z1.x*z2.y)/m;
end;

function InvCpx(z:TfloatComp):TfloatComp;
var
  m:float;
begin
  m:=sqr(z.x)+sqr(z.y);
  result.x:=z.x/m;
  result.y:=-z.y/m;
end;

function sqrtCpx(z:TfloatComp):TfloatComp;
var
  m,phi:float;
begin
  m:=sqrt(mdlCpx(z));
  phi:=angleCpx(z)/2;

  result.x:=m*cos(phi);
  result.y:=m*sin(phi);
end;

function sqrCpx(z:TfloatComp):TfloatComp;
begin
  result.x:=sqr(z.x)-sqr(z.y);
  result.y:=2*z.x*z.y;
end;


function FloatToCpx(x:float):TfloatComp;
begin
  result.x:=x;
  result.y:=0;
end;

function EqualCpx(z1,z2: TfloatComp): boolean;
begin
  result:=(z1.x=z2.x) and (z1.y=z2.y);
end;

function Angle(x,y:float):float;
begin
  if (x=0) and (y=0)
    then result:=0
    else result:=arcTan2(y,x);             { L'ordre est bien y,x }
end;

function AngleCpx(z:TfloatComp):float;
begin
  if (z.x=0) and (z.y=0)
    then result:=0
    else result:=arcTan2(z.y,z.x);         { L'ordre est bien y,x }

end;

function MdlCpx(z:TfloatComp):float;
begin
  result:=sqrt(sqr(z.x)+sqr(z.y));
end;

function MdlCpx2(z:TfloatComp):float;
begin
  result:=sqr(z.x)+sqr(z.y);
end;


function SingleComp(x,y:single):TsingleComp;
begin
  result.x:=x;
  result.y:=y;
end;

function DoubleComp(x,y:double):TdoubleComp;
begin
  result.x:=x;
  result.y:=y;
end;


function FloatComp(x,y:float):TfloatComp;
begin
  result.x:=x;
  result.y:=y;
end;


function Mediane1(var t:TarrayOfDouble;N,Ninf,Nsup:integer):double;
var
  t1,t2,t3:TarrayOfDouble;
  N1,N2,N3:integer;
  x,y:double;
  i:integer;
begin
  N1:=0;
  N2:=1;
  N3:=0;
  setLength(t1,N);
  setLength(t2,N);
  setLength(t3,N);

  x:=t[0];
  t2[0]:=x;


  for i:=1 to N-1 do
  begin
    y:=t[i];
    if y<x then
    begin
      t1[N1]:=y;
      inc(N1);
    end
    else
    if y=x then
    begin
      t2[N2]:=y;
      inc(N2);
    end
    else
    begin
      t3[N3]:=y;
      inc(N3);
    end;
  end;

  if N1>Ninf then
  begin
    setLength(t2,0);
    setLength(t3,0);
    result:=mediane1(t1,N1,Ninf,Nsup-N2-N3)
  end
  else
  if N3>Nsup then
  begin
    setLength(t1,0);
    setLength(t2,0);
    result:=mediane1(t3,N3,Ninf-N1-N2,Nsup)
  end
  else result:=x;

end;


function mediane(t:TarrayOfDouble;N:integer):double;
var
  Ninf,Nsup,i,Nb:integer;
  w:double;
begin
  if N<=0 then
    begin
      result:=0;
      exit;
    end;

  if N=1 then
    begin
      result:=t[0];
      exit;
    end;


  result:=mediane1(t,N,N div 2,N-N div 2-1);
  if (N mod 2=0) then
  begin
    w:=-1E100;
    Nb:=0;
    for i:=0 to N-1 do
    begin
      if (t[i]=result) then
      begin
        inc(Nb);
        if Nb>1 then w:=result;
      end;
      if (t[i] < result) and (t[i]>w) then w:=t[i];
    end;
    result:=(w+result)/2;

  end;


end;



function testEscape:boolean;
  var
    msg:Tmsg;
  begin
    if getInputState then
      while peekMessage(msg,0,Wm_keyDown,Wm_KeyDown,PM_remove) do
      if (msg.wparam=VK_Escape) and (getKeyState(vk_shift) and $8000=0) then
        begin
          testEscape:=true;
          exit;
        end;

    testEscape:=false;
  end;


{ Version originale de TestShiftEscape
  on teste simplement la touche Shift+Escape
}
function testShiftEscape1(const hh: integer=0):boolean;
var
  msg:Tmsg;
begin
  while peekMessage(msg,hh,Wm_keyDown,Wm_KeyDown,PM_remove OR PM_NOYIELD) do
  if (msg.wparam=VK_Escape) and (getKeyState(vk_shift) and $8000<>0) then
    begin
      result:=true;
      exit;
    end;

  result:=false;
end;

{ Pour améliorer le comportement de l'application pendant un long calcul (notamment, le basculement vers une autre app),
  on a essayé de laisser passer quelques messages .
  Ca a marché, mais les scrollbars ont eu un comportement anormal, quand le gestionnaire d'evt appelait TestShiftEscape.
  On a donc introduit le flag FnoSmartTestEscape positionné dés qu'on se trouve dans le gestionnaire d'une SB

  On appelle donc l'ancienne version quand on est dans ces gestionnaires.

  oct 2014: ce nouveau testShiftEscape a aussi des effets pervers en acquisition RTneuron!
}

function testShiftEscape(const hh: integer=0):boolean;             // 4 décembre 2012
var
  msg:Tmsg;
  i:integer;
begin

  if FnoSmartTestEscape then result:= testShiftEscape1
  else
  begin
    while peekMessage(msg,0,0,wm_paint-1,PM_Remove OR PM_NOYIELD) do
    begin
      translateMessage(msg);
      application.dispatch(msg);
    end;

  { On laisse tout passer sauf wm_paint
    Apparemment application.dispatch ne gère que ses propres messages
    translate/dispatch est très dangereux (transmet tout)
  }
    while peekMessage(msg,0,wm_paint+1,wm_user,PM_Remove OR PM_NOYIELD) do
    begin
      if (msg.wparam=VK_Escape) and (getKeyState(vk_shift) and $8000<>0) then
      begin
        Result:=true;
        exit;
      end;

      translateMessage(msg);
      application.dispatch(msg);
    end;

    result:=false;
  end;
end;


function oem(st:AnsiString):AnsiString;
  begin
    st:=st+#0;
    oemToAnsi(@st[1],@st[1]);
    delete(st,length(st),1);
    oem:=st;
  end;

function ansi(st:AnsiString):AnsiString;
  begin
    st:=st+#0;
    AnsiToOem(@st[1],@st[1]);
    delete(st,length(st),1);
    ansi:=st;
  end;


procedure messageCentral(st:String);
begin
 {$IFDEF WIN64}
  windows.MessageBox(MainHW,Pchar(st),'Elphy64',MB_ICONINFORMATION or MB_ApplMODAL or MB_TOPMOST);
 {$ELSE}
  windows.MessageBox(MainHW, Pchar(st),'Elphy2',MB_ICONINFORMATION or MB_ApplMODAL or MB_TOPMOST);
 {$ENDIF}

end;

procedure messageCentral(st,caption:String);
begin
  windows.MessageBox(0,Pchar(st),Pchar(caption),MB_ICONINFORMATION or MB_ApplMODAL or MB_TOPMOST);
end;

{$IFNDEF _OBJ}
procedure TfontDescriptor.init;
begin
  Name:='MS Sans Serif';
  height:=-11;
  Size:=8;
  fillchar(Color,sizeof(color),0);
  fillchar(style,sizeof(style),0);
end;

function TfontDescriptor.info:AnsiString;
begin
  result:=Name+','+Istr(height)+','+Istr(size)+','+Istr(color)+','+Istr(Pbyte(@style)^);
end;

procedure DescToFont(var desc:TFontDescriptor;font:Tfont);
  var
    styleDum:TfontStyles;
  begin
    if not assigned(font) then exit;
    if (desc.height=0) then exit;

    font.height:=desc.height;
    font.name:=desc.name ;
    font.size:=desc.size;
    font.color:=desc.color;
    {$IFDEF FPC}
    styleDum:=[];
    move(desc.style,styleDum,1);
    font.style:=styleDum;
    {$ELSE}
    font.style:=desc.style;
    {$ENDIF}

  end;

procedure FontToDesc(font:Tfont;var desc:TFontDescriptor);
  var
    styleDum:TfontStyles;

  begin
    if not assigned(font) then exit;

    fillchar(desc,sizeof(desc),0);
    desc.height:=font.height;
    desc.name:=font.name ;
    desc.size:=font.size;
    desc.color:=font.color;
    {$IFDEF FPC}
    styleDum:=font.style;
    move(styleDum,desc.style,1);
    {$ELSE}
    desc.style:=font.style;
    {$ENDIF}
  end;


{**************** Méthodes de typeBoiteInfo ********************************}

constructor typeBoiteInfo.init(titre0:AnsiString);
  begin
    titreB:=titre0;
    buf:='';
  end;

procedure typeBoiteInfo.writeln(st:AnsiString);
  begin
    buf:=buf+st+#10+#13;
  end;

procedure typeBoiteInfo.write(st:AnsiString);
  begin
    buf:=buf+st;
  end;


destructor typeBoiteInfo.done;
  begin
    application.messageBox(@buf[1],@titreB[1],mb_ok);
    buf:='';
    titreB:='';
  end;

{$ENDIF}

function typetypeMax(t1,t2:typetypeG):typetypeG;
begin
  if t1>t2 then result:=t1
           else result:=t2;
end;

function typeNameToTypeG(st: AnsiString): typetypeG;
var
  i: typetypeG;
begin
  st:=upperCase(st);
  for i:= g_byte to g_int64 do
    if Uppercase(typeNameG[i])=st then
    begin
      result:=i;
      exit;
    end;  
end;

Procedure DisplayLastError;
var
  MsgBuf:PansiChar;
  res:integer;
  error:integer;
begin
  error:=GetLastError;
  msgBuf:=nil;
  res:=FormatMessageA( FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                      Nil,
                      Error,
                      LANG_USER_DEFAULT,
                      @MsgBuf,
                      0,
                      NIL);

  MessageCentral('error='+Istr(error) + crlf + MsgBuf );

  LocalFree( intG(MsgBuf) );
end;


function getLastErrorString:AnsiString;
var
  MsgBuf:PansiChar;
  res:integer;
  error:integer;
begin
  error:=GetLastError;
  msgBuf:=nil;
  res:=FormatMessageA( FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                      Nil,
                      Error,
                      LANG_USER_DEFAULT,
                      @MsgBuf,
                      0,
                      NIL);

  result:='error '+Istr(error) +':'  + MsgBuf ;

  LocalFree( intG(MsgBuf) );
end;

procedure swap(var x,y:integer);
var
  z:integer;
begin
  z:=x;
  x:=y;
  y:=z;
end;

procedure swap(var x,y:pointer);
var
  z:pointer;
begin
  z:=x;
  x:=y;
  y:=z;
end;

procedure swap(var x,y:single);
var
  z:float;
begin
  z:=x;
  x:=y;
  y:=z;
end;


procedure swap(var x,y:float);
var
  z:float;
begin
  z:=x;
  x:=y;
  y:=z;
end;

procedure swapMem(var x,y;size:integer);
var
  pz:pointer;
begin
  getmem(pz,size);
  move(x,pz^,size);
  move(y,x,size);
  move(pz^,y,size);
  freemem(pz);
end;



{ Manipulation directe des chaines ANSI. Ce n'est pas très concluant }


function FirstCharAd(var st):pointer;
var
  p:^pointer;
begin
  p:=@st;
  result:=p^;
  { Si on écrit: result:= @st[1], le compilateur duplique d'abord la chaine }

end;

function stringInfo(var st):TstringInfo;
var
  p:PstringInfo;
  p1:pointer;
begin
  if pointer(st)<>nil then
  begin
    p1:=FirstCharAd(st);
    p:=pointer(intG(p1)-8);
    result.ref:=p^.ref;
    result.len:=p^.len;
  end
  else
  begin
    result.ref:=0;
    result.len:=0;
  end;
end;

{st est une chaine de caractères }
procedure ShowStringInfo(var st);
var
  info:TstringInfo;
  ad:AnsiString;
  st1:AnsiString;
begin
  info:=stringInfo(st);
  if pointer(st)<>nil then
  begin
    setlength(st1,info.len);
    move(Ppointer(st)^,st1[1],info.len);
    ad:=longToHexa( intG(FirstCharAd(st)) );
  end
  else
  begin
    ad:='nil';
    st1:='';
  end;

  messageCentral(st1+crlf+ad+'    ref='+Istr(info.ref)+'    len='+Istr(info.len));
end;


{pst est l'adresse du premier caractère d'une chaîne non nulle}
procedure incRef(pst:pointer);
var
  p:PstringInfo;
begin
  if pst<>nil then
  begin
    p:=pointer(intG(pst)-8);
    inc(p^.ref);
  end;
end;

procedure decRef(pst:pointer);
var
  p:PstringInfo;
  st:AnsiString;
begin
  if pst<>nil then
  begin
    p:=pointer(intG(pst)-8);
    if p^.ref>1 then dec(p^.ref)
    else
    begin
      pointer(st):=pst;
      st:='';
    end;
  end;
end;

function PcharToString(p:pointer;n:integer):AnsiString;
var
  p0:Ptabchar absolute p;
  i:integer;
begin
  result:='';
  for i:=0 to n-1 do
  if p0^[i]<>#0 then result:=result+p0^[i] else break;
end;

procedure StringToPchar(st:AnsiString;nb:integer;var w);
begin
  fillchar(w,nb,0);
  if length(st)<nb then nb:=length(st);
  move(st[1],w,nb);
end;

procedure delay(ms:integer);
var
  i:integer;
begin
  i:=getTickCount;
  repeat
  until getTickCount-i>ms;
end;

function LoadMatLabDLL(stf:AnsiString):intG;
var
  oldDir: AnsiString;
begin
  if (MatlabPath<>'') then
  begin
    setCurrentDir(extractFilePath(stf));
    if MatlabPath[length(MatlabPath)]<>'\' then stf:='\'+stf;
    result:=LoadLibraryExA(PAnsichar(MatlabPath+stf),0,LOAD_WITH_ALTERED_SEARCH_PATH );
  end
  else result:=0;
  if result=0 then result:=LoadLibraryA(Pansichar(stf));
end;

function GLoadLibrary(st:AnsiString): intG;
var
  stPath:AnsiString;
begin
  stPath:=extractfilePath(st);
  if stPath<>''
    then  result:=LoadLibraryExA(Pansichar(st),0,LOAD_WITH_ALTERED_SEARCH_PATH )
    else result:=LoadLibraryA(Pansichar(st));

  //if result=0 then
  //  messageCentral('GloadLibrary '+st+ crlf+  getLastErrorString);

  if result=0 //then messageCentral('DLL not loaded: '+st);
    then affdebug('DLL not loaded: '+st,0)
    else affdebug('DLL loaded: '+st,0);
end;

function getProc(hh:Thandle;st:AnsiString; Const ShowNil: boolean=false):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if ShowNil and (result=nil) then messageCentral(st+' '+Bstr(result<>nil));
end;

function StringToDateTime(st:AnsiString):TdateTime;
var
  yy,mm,dd,hh,min,sec,ms:integer;
  i,code:integer;
  FlagDate, FlagTime: boolean;
begin
  min:=0;
  sec:=0;
  ms :=0;

  FlagDate:=(pos('-',st)>0);
  FlagTime:=(pos(':',st)>0);

  try
    st:=FsupespaceDebutEtFin(st);
    if FlagDate then
    begin
      i:=pos('-',st);
      val(copy(st,1,i-1),yy,code);
      delete(st,1,i);

      i:=pos('-',st);
      val(copy(st,1,i-1),mm,code);
      delete(st,1,i);

      i:=pos(' ',st);
      if i<1 then i:=length(st)+1;
      val(copy(st,1,i-1),dd,code);
      delete(st,1,i);
    end;

    st:=FsupespaceDebutEtFin(st);
    if FlagTime then
    begin
      i:=pos(':',st);
      val(copy(st,1,i-1),hh,code);
      delete(st,1,i);

      i:=pos(':',st);
      if i=0 then i:=length(st)+1;
      val(copy(st,1,i-1),min,code);
      delete(st,1,i);

      i:=pos(':',st);
      if i=0 then i:=length(st)+1;
      val(copy(st,1,i-1),sec,code);
      delete(st,1,i);

      val(st,ms,code);
    end;

    if FlagDate and FlagTime then result:=encodeDateTime(yy,mm,dd,hh,min,sec,ms)
    else
    if FlagDate then result:=encodeDate(yy,mm,dd)
    else
    if FlagTime then result:=encodeTime(hh,min,sec,ms)
    else result:= encodeTime(0,0,0,0);

  except
    if yy<1900 then yy:=1900;
    if yy>2200 then yy:=2200;
    if mm<1 then mm:=1;
    if mm>12 then mm:=12;
    if dd<1 then dd:=1;
    if dd>31 then dd:=30;
    if (hh<0) or (hh>24) then hh:=0;
    if (min<0) or (min>59) then min:=0;
    if (sec<0) or (sec>59) then sec:=0;
    if (ms<0) or (ms>999) then ms:=0;

    if FlagDate and FlagTime then result:=encodeDateTime(yy,mm,dd,hh,min,sec,ms)
    else
    if FlagDate then result:=encodeDate(yy,mm,dd)
    else
    if FlagTime then result:=encodeTime(hh,min,sec,ms)
    else result:= encodeTime(0,0,0,0);

  end;
end;

function DateTimeToString(w: TdateTime;Const Fsec:boolean=true;Const Fms:boolean=true): AnsiString;
var
  yy,mm,dd,hh,min,sec,ms:word;
  FlagTime, FlagDate:boolean;
  stHformat:AnsiString;
begin
  FlagDate:=(int(w)>0);
  FlagTime:=(frac(w)>0);

  decodeDateTime(w,yy,mm,dd,hh,min,sec,ms);

  stHformat:='hh:mm';
  if Fsec then
  begin
    stHformat:=stHformat+':ss';
    if Fms then stHformat:=stHformat+':zzz';
  end;

  if FlagTime and FlagDate then result:= FormatDateTime('yyyy-mm-dd '+stHformat,w)
  else
  if FlagTime then result:= FormatDateTime(stHformat,w)
  else
  if FlagDate then result:= FormatDateTime('yyyy-mm-dd',w)
  else result:='0';

end;

procedure SetVCLdef(form:Tform);
var
  i:integer;
begin
  with form do
  for i := 0 to ComponentCount -1 do
    if Components[i] is TPanel then
      TPanel(Components[i]).ParentBackground:=false;
end;


function sar(x,v:smallint): smallint;
asm
  mov ax, x                              // A vérifier
  mov cx, v
  sar ax, cl
end;

function swapBytes(var x: smallint):  smallint;
var
  w1: array[1..2] of byte absolute x;
  w2: array[1..2] of byte absolute result;
begin
  w2[1]:=w1[2];
  w2[2]:=w1[1];

end;

function swapBytes(var x: longint):   longint;
var
  w1: array[1..4] of byte absolute x;
  w2: array[1..4] of byte absolute result;
begin
  w2[1]:=w1[4];
  w2[2]:=w1[3];
  w2[3]:=w1[2];
  w2[4]:=w1[1];

end;

function swapBytes(var x: double):   double;
var
  i:integer;
  w1: array[1..8] of byte absolute x;
  w2: array[1..8] of byte absolute result;
begin
  for i:=1 to 8 do w2[i]:=w1[9-i];
end;

procedure proSwapBytes(var x:smallint);
begin
  x:=swapBytes(x);
end;

procedure proSwapBytes_1(var x:longint);
begin
  x:=swapBytes(x);
end;

procedure proSwapBytes_2(var x:double);
begin
  x:=swapBytes(x);
end;

procedure checkRectangle(var rect1: Trect);
begin
  if rect1.left>rect1.Right then swap(rect1.left,rect1.Right);
  if rect1.top>rect1.bottom then swap(rect1.top,rect1.bottom); 
end;

function CharToString(ch:PansiChar;nb:integer):Ansistring;
var
  i:integer;
begin
  result:='';
  for i:=0 to nb-1 do
    if ch[i]<>#0 then result:= result+ch[i] else exit;
end;

procedure MyTest;
begin
  messageCentral('Hello');
end;

procedure LoadBitmapFromFile(bm:Tbitmap; stF:string);
var
  ext:string;
  png: TPNGobject;
  jp: TjpegImage;
begin
  ext:=Fmaj(ExtractFileExt(stf));

  if ext='.BMP' then bm.LoadFromFile(stF)
  else
  if ext='.PNG' then
  begin
    try
      PNG := TPNGObject.Create;
      PNG.LoadFromFile(stF);
      bm.Assign(PNG);  // Cette opération modifie les couleurs !!!
    finally
      PNG.free;
    end;
  end
  else
  if (ext='.JPG') or (ext='.JPEG') then
  begin
    try
      jp:=TjpegImage.create;
      jp.LoadFromFile(stF);
      bm.Assign(jp);
    finally
      jp.free;
    end;
  end;

end;

procedure SaveBitmapToFile(bm:Tbitmap; stF:string; const quality:integer=100);
var
  ext:string;
  png: TPNGobject;
  jp: TjpegImage;
begin
  ext:=Fmaj(ExtractFileExt(stf));

  if ext='.BMP' then bm.SaveToFile(stF)
  else
  if ext='.PNG' then
  begin
    try
      PNG := TPNGObject.Create;
      PNG.Assign(bm);
      PNG.SaveToFile(stF);
    finally
      PNG.free;
    end;
  end
  else
  if (ext='.JPG') or (ext='.JPEG') then
  begin
    try
      jp:=TjpegImage.create;
      jp.CompressionQuality:= quality;
      jp.Assign(bm);
      jp.SaveToFile(stF);
    finally
      jp.free;
    end;
  end;

end;

function FindFileInPathList(stUnit,SearchPath1: AnsiString): AnsiString;
var
  st,st1:string;
  p:integer;
begin
  result:='';
  stUnit:= extractFileName(stUnit);

  st:=SearchPath1;
  repeat
    p:= pos(';',st);
    if p=0 then p:=length(st)+1;
    if p>=1 then
    begin
      st1:=copy(st,1,p-1)+'\'+stUnit;
      if fileExists(st1) then
      begin
        result:=st1;
        exit;
      end;
      delete(st,1,p);
    end;
  until st='';

end;

function StringEmpty(st: AnsiString): boolean;
begin
  st:= FSupEspace(st);
  result:= st='';
end;

// fonction trouvée dans les exemples cuda
// je ne sais pas si elle est aussi efficace en pascal!
function NextPower2(n:longword): longword;
begin
  dec(n);

  n:= n or (n shr 1);
  n:= n or (n shr 2);
  n:= n or (n shr 4);
  n:= n or (n shr 8);
  n:= n or (n shr 16);

  inc(n);
  result:=n;
end;

function IsPower2(n:longword): boolean;
begin
  result:= n and (n-1) = 0;
end;


function UgetShort(t:pointer;n:integer):double;
begin
   result:= PtabShort(t)^[n];
end;

function UgetByte(t:pointer;n:integer):double;
begin
   result:= PtabOctet(t)^[n];
end;

function UgetSmallint(t:pointer;n:integer):double;
begin
   result:= PtabEntier(t)^[n];
end;

function UgetWord(t:pointer;n:integer):double;
begin
   result:= PtabWord(t)^[n];
end;

function UgetLong(t:pointer;n:integer):double;
begin
   result:= PtabLong(t)^[n];
end;

function UgetLongWord(t:pointer;n:integer):double;
begin
   result:= PtabLongWord(t)^[n];
end;

function UgetSingle(t:pointer;n:integer):double;
begin
   result:= PtabSingle(t)^[n];
end;

function UgetDouble(t:pointer;n:integer):double;
begin
   result:= PtabDouble(t)^[n];
end;


//équivalent à fileAge mais avec toutes les dates
function UFileAge(const FileName: string; Const mode:integer=1): Integer;
var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
begin
  result:=-1;
  if (mode<1) or (mode>3) then exit;

  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      case mode of
        1: FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
        2: FileTimeToLocalFileTime(FindData.ftLastAccessTime, LocalFileTime);
        3: FileTimeToLocalFileTime(FindData.ftCreationTime, LocalFileTime);
      end;
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
    end;
  end;
  Result := -1;
end;



initialization
  exceptionMask0:= getexceptionMask;

end.



