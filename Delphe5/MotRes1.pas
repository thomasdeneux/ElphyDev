unit MotRes1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Ncdef2,listG,debug0;

var
  tbMotsRes:ThashList;

procedure getLexRes(st:ShortString; var tp:typeLex; var tp2: typeLex2);

function getResName(tp:typeLex; tp2: typeLex2):AnsiString;

implementation

function getP2(tp: typelex2):pointer;
begin
  result:=pointer(ord(lex2)+ ord(tp)*256);
end;


procedure init;
begin
  tbMotsRes:=ThashList.create;

  with tbMotsRes do
  begin
    AddString('DO',pointer(motDO));
    AddString('IF',pointer(motIF));
    AddString('IN',pointer(motIN));
    AddString('OF',pointer(motOF));
    AddString('TO',pointer(motTO));
    AddString('END',pointer(motEND));
    AddString('FOR',pointer(motFOR));

    AddString('CASE',pointer(motCASE));
    AddString('ELSE',pointer(motELSE));
    AddString('GOTO',pointer(motGOTO));
    AddString('THEN',pointer(motTHEN));
    AddString('CHAR',pointer(motCHAR));


    AddString('TRUE',pointer(motTRUE));
    AddString('WITH',pointer(motWITH));


    AddString('ARRAY',pointer(motARRAY));
    AddString('BEGIN',pointer(motBEGIN));

    AddString('UNTIL',pointer(motUNTIL));
    AddString('WHILE',pointer(motWHILE));
    AddString('FALSE',pointer(motFALSE));
    AddString('DOWNTO',pointer(motDOWNTO));
    AddString('REPEAT',pointer(motREPEAT));

    AddString('STRING',pointer(motANSISTRING));
    AddString('SHORTSTRING',pointer(motShortSTRING));
    AddString('ANSISTRING',pointer(motANSISTRING));



    AddString('BYTE',pointer(motBYTE));
    AddString('SHORTINT',pointer(motShortInt));
    AddString('SMALLINT',pointer(motSmallInt));
    AddString('LONGINT',pointer(motLONGINT));
    AddString('WORD',pointer(motWord));
    AddString('LONGWORD',pointer(motLongWord));
    AddString('INT64',pointer(motInt64));

    AddString('INTEGER',pointer(motLongint));   {21 février 2002 passage au longint}
    AddString('CARDINAL',pointer(motLongWord));

    AddString('SINGLE',pointer(motSingle));
    AddString('DOUBLE',pointer(motDouble));
    AddString('EXTENDED',pointer(motExtended));
    AddString('REAL',pointer(motExtended));

    AddString('SCOMPLEX',pointer(motSingleComp));
    AddString('DCOMPLEX',pointer(motDoubleComp));
    AddString('COMPLEX',pointer(motExtComp));


    AddString('BOOLEAN',pointer(motBOOLEAN));


    AddString('EXIT',pointer(motExit));
    AddString('BREAK',pointer(motBreak));
    AddString('ORD',pointer(motOrd));
    AddString('INC',pointer(motInc));
    AddString('DEC',pointer(motDec));
    AddString('INCL',pointer(motInc));
    AddString('DECL',pointer(motDec));

    AddString('NIL',pointer(motNil));

    AddString('VARIANT',pointer(motVariant));
    AddString('TDATETIME',pointer(motDateTime));

    {********* Les lex2 }

    AddString('VAR',getP2(motVAR));
    AddString('CONST',getP2(motCONST));
    AddString('PROGRAM',getP2(motPROGRAM));
    AddString('FUNCTION',getP2(motFUNCTION));
    AddString('PROCEDURE',getP2(motPROCEDURE));
    AddString('PROCESS',getP2(motProcess));
    AddString('INTERFACE',getP2(motInterface));
    AddString('ENDPROCESS',getP2(motEndProcess));
    AddString('INITPROCESS',getP2(motInitProcess));
    AddString('PROCESSCONT',getP2(motProcessCont));
    AddString('INITPROCESS0',getP2(motInitProcess0));
    AddString('IMPLEMENTATION',getP2(motImplementation));
    AddString('INITIALIZATION',getP2(motInitialization));

    AddString('PROPERTY',getP2(motProperty));
    AddString('READONLY',getP2(motReadOnly));
    AddString('DEFAULT',getP2(motDefault));
    AddString('IMPLICIT',getP2(motImplicit));


    AddString('TYPE',getP2(motType));
    AddString('RECORD',getP2(motRecord));
    AddString('CLASS',getP2(motClass));
    AddString('FORWARD',getP2(motForward));
    AddString('UNIT',getP2(motUnit));
    AddString('USES',getP2(motUses));

  end;

  tbMotsRes.pack;

end;

function getMotReserve(tp:typeLex):AnsiString;
begin

end;

procedure getLexRes(st:ShortString; var tp:typeLex; var tp2: typeLex2);
var
  i:integer;
begin
  i:= intG( tbMotsRes.getFirstObj(st));
  tp:= typelex(i and $FF);
  tp2:=typelex2((i shr 8) and $FF);
end;

function getResName(tp:typeLex; tp2: typeLex2):AnsiString;
var
  p:pointer;
begin
  p:= pointer(ord(tp)+ ord(tp2)*256);

  result:=tbMotsRes.getString(p);
end;

Initialization
AffDebug('Initialization MotRes1',0);
  Init;
end.
