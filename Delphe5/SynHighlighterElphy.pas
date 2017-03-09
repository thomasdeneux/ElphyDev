{ HighLighter pou Elphy

  C'est SynHighLighterPas  modifié.

  La fonction de codage est

  Function HighLightCode(st:string):integer;
  var
    i:integer;
  begin
    st:=UpperCase(st);
    result:=0;
    for i:=1 to length(st) do
    if st[i] in ['A'..'Z'] then inc(result,ord(st[i])-64);
  end;

  Les mots-clés sont introduits dans la fonction funcXXX où XXX est le code du mot clé

  On ajoute InitProcess(147), InitProcess0(147), Process(95), ProcessCont(147), EndProcess(118)
}

{------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynHighlighterPas.pas, released 2000-04-17.
The Original Code is based on the mwPasSyn.pas file from the
mwEdit component suite by Martin Waldenburg and other developers, the Initial
Author of this file is Martin Waldenburg.
Portions created by Martin Waldenburg are Copyright (C) 1998 Martin Waldenburg.
All Rights Reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: SynHighlighterPas.pas,v 1.30 2005/01/28 16:53:24 maelh Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}
{
@abstract(Provides a Pascal/Delphi syntax highlighter for SynEdit)
@author(Martin Waldenburg)
@created(1998, converted to SynEdit 2000-04-07)
@lastmod(2001-11-21)
The SynHighlighterPas unit provides SynEdit with a Object Pascal syntax highlighter.
Two extra properties included (DelphiVersion, PackageSource):
  DelphiVersion - Allows you to enable/disable the highlighting of various
                  language enhancements added in the different Delphi versions.
  PackageSource - Allows you to enable/disable the highlighting of package keywords
}

{$IFNDEF QSYNHIGHLIGHTERPAS}
unit SynHighlighterElphy;
{$ENDIF}

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
{$ELSE}
  Windows,
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
{$ENDIF}
  SysUtils,
  Classes,
  debug0;

type
  TtkTokenKind = (tkAsm, tkComment, tkIdentifier, tkKey, tkNull, tkNumber,
    tkSpace, tkString, tkSymbol, tkUnknown, tkFloat, tkHex, tkDirec, tkChar);

  TRangeState = (rsANil, rsAnsi, rsAnsiAsm, rsAsm, rsBor, rsBorAsm, rsProperty,
    rsExports, rsDirective, rsDirectiveAsm, rsUnKnown);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

  TDelphiVersion = (dvDelphi1, dvDelphi2, dvDelphi3, dvDelphi4, dvDelphi5,
    dvDelphi6, dvDelphi7, dvDelphi8, dvDelphi2005);

const
  LastDelphiVersion = dvDelphi2005;

type
  TSynElphySyn = class(TSynCustomHighlighter)
  private
    fAsmStart: Boolean;
    fRange: TRangeState;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fIdentFuncTable: array[0..191] of TIdentFuncTableFunc;
    fTokenPos: Integer;
    FTokenID: TtkTokenKind;
    fStringAttri: TSynHighlighterAttributes;
    fCharAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fFloatAttri: TSynHighlighterAttributes;
    fHexAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fAsmAttri: TSynHighlighterAttributes;
    fCommentAttri: TSynHighlighterAttributes;
    fDirecAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fDelphiVersion: TDelphiVersion;
    fPackageSource: Boolean;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func15: TtkTokenKind;
    function Func19: TtkTokenKind;
    function Func20: TtkTokenKind;
    function Func21: TtkTokenKind;
    function Func23: TtkTokenKind;
    function Func25: TtkTokenKind;
    function Func27: TtkTokenKind;
    function Func28: TtkTokenKind;
    function Func29: TtkTokenKind;
    function Func32: TtkTokenKind;
    function Func33: TtkTokenKind;
    function Func35: TtkTokenKind;
    function Func37: TtkTokenKind;
    function Func38: TtkTokenKind;
    function Func39: TtkTokenKind;
    function Func40: TtkTokenKind;
    function Func41: TtkTokenKind;
    function Func42: TtkTokenKind;
    function Func44: TtkTokenKind;
    function Func45: TtkTokenKind;
    function Func46: TtkTokenKind;
    function Func47: TtkTokenKind;
    function Func49: TtkTokenKind;
    function Func52: TtkTokenKind;
    function Func54: TtkTokenKind;
    function Func55: TtkTokenKind;
    function Func56: TtkTokenKind;
    function Func57: TtkTokenKind;
    function Func59: TtkTokenKind;
    function Func60: TtkTokenKind;
    function Func61: TtkTokenKind;
    function Func63: TtkTokenKind;
    function Func64: TtkTokenKind;
    function Func65: TtkTokenKind;
    function Func66: TtkTokenKind;
    function Func69: TtkTokenKind;
    function Func71: TtkTokenKind;
    function Func73: TtkTokenKind;
    function Func75: TtkTokenKind;
    function Func76: TtkTokenKind;
    function Func79: TtkTokenKind;
    function Func81: TtkTokenKind;
    function Func84: TtkTokenKind;
    function Func85: TtkTokenKind;
    function Func87: TtkTokenKind;
    function Func88: TtkTokenKind;
    function Func91: TtkTokenKind;
    function Func92: TtkTokenKind;
    function Func94: TtkTokenKind;
    function Func95: TtkTokenKind;
    function Func96: TtkTokenKind;
    function Func97: TtkTokenKind;
    function Func98: TtkTokenKind;
    function Func99: TtkTokenKind;
    function Func100: TtkTokenKind;
    function Func101: TtkTokenKind;
    function Func102: TtkTokenKind;
    function Func103: TtkTokenKind;
    function Func105: TtkTokenKind;
    function Func106: TtkTokenKind;
    function Func108: TtkTokenKind;
    function Func112: TtkTokenKind;
    function Func117: TtkTokenKind;
    function Func118: TtkTokenKind;
    function Func126: TtkTokenKind;
    function Func129: TtkTokenKind;
    function Func132: TtkTokenKind;
    function Func133: TtkTokenKind;
    function Func136: TtkTokenKind;
    function Func141: TtkTokenKind;
    function Func143: TtkTokenKind;
    function Func147: TtkTokenKind;
    function Func166: TtkTokenKind;
    function Func168: TtkTokenKind;
    function Func191: TtkTokenKind;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure AddressOpProc;
    procedure AsciiCharProc;
    procedure AnsiProc;
    procedure BorProc;
    procedure BraceOpenProc;
    procedure ColonOrGreaterProc;
    procedure CRProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure LFProc;
    procedure LowerProc;
    procedure NullProc;
    procedure NumberProc;
    procedure PointProc;
    procedure RoundOpenProc;
    procedure SemicolonProc;
    procedure SlashProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    procedure SetDelphiVersion(const Value: TDelphiVersion);
    procedure SetPackageSource(const Value: Boolean);
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource: string; override;
    function IsFilterStored: boolean; override;
  public
    class function GetCapabilities: TSynHighlighterCapabilities; override;
    class function GetLanguageName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetToken: string; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenID: TtkTokenKind;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
    procedure ResetRange; override;
    procedure SetLine({$IFDEF FPC}const {$ENDIF}NewValue: string; LineNumber:Integer); override;
    procedure SetRange(Value: Pointer); override;
    function UseUserSettings(VersionIndex: integer): boolean; override;
    procedure EnumUserSettings(DelphiVersions: TStrings); override;
    property IdentChars;
  published
    property AsmAttri: TSynHighlighterAttributes read fAsmAttri write fAsmAttri;
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property DirectiveAttri: TSynHighlighterAttributes read fDirecAttri
      write fDirecAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property FloatAttri: TSynHighlighterAttributes read fFloatAttri
      write fFloatAttri;
    property HexAttri: TSynHighlighterAttributes read fHexAttri
      write fHexAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property CharAttri: TSynHighlighterAttributes read fCharAttri
      write fCharAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property DelphiVersion: TDelphiVersion read fDelphiVersion write SetDelphiVersion
      default LastDelphiVersion;
    property PackageSource: Boolean read fPackageSource write SetPackageSource default True;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable: array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    Case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else Identifiers[I] := False;
    end;
    J := UpCase(I);
    Case I of
      'a'..'z', 'A'..'Z', '_': mHashTable[I] := Ord(J) - 64;
    else mHashTable[Char(I)] := 0;
    end;
  end;
end;

procedure TSynElphySyn.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do
  begin
    {$IFDEF FPC}
    pF^ := @AltFunc;
    {$ELSE}
    pF^ := AltFunc;
    {$ENDIF}
    Inc(pF);
  end;

  fIdentFuncTable[15] := {$IFDEF FPC} @Func15; {$ELSE} Func15; {$ENDIF}
  fIdentFuncTable[19] := {$IFDEF FPC} @Func19; {$ELSE} Func19; {$ENDIF}
  fIdentFuncTable[20] := {$IFDEF FPC} @Func20; {$ELSE} Func20; {$ENDIF}
  fIdentFuncTable[21] := {$IFDEF FPC} @Func21; {$ELSE} Func21; {$ENDIF}
  fIdentFuncTable[23] := {$IFDEF FPC} @Func23; {$ELSE} Func23; {$ENDIF}
  fIdentFuncTable[25] := {$IFDEF FPC} @Func25; {$ELSE} Func25; {$ENDIF}
  fIdentFuncTable[27] := {$IFDEF FPC} @Func27; {$ELSE} Func27; {$ENDIF}
  fIdentFuncTable[28] := {$IFDEF FPC} @Func28; {$ELSE} Func28; {$ENDIF}
  fIdentFuncTable[29] := {$IFDEF FPC} @Func29; {$ELSE} Func29; {$ENDIF}
  fIdentFuncTable[32] := {$IFDEF FPC} @Func32; {$ELSE} Func32; {$ENDIF}
  fIdentFuncTable[33] := {$IFDEF FPC} @Func33; {$ELSE} Func33; {$ENDIF}
  fIdentFuncTable[35] := {$IFDEF FPC} @Func35; {$ELSE} Func35; {$ENDIF}
  fIdentFuncTable[37] := {$IFDEF FPC} @Func37; {$ELSE} Func37; {$ENDIF}
  fIdentFuncTable[38] := {$IFDEF FPC} @Func38; {$ELSE} Func38; {$ENDIF}
  fIdentFuncTable[39] := {$IFDEF FPC} @Func39; {$ELSE} Func39; {$ENDIF}
  fIdentFuncTable[40] := {$IFDEF FPC} @Func40; {$ELSE} Func40; {$ENDIF}
  fIdentFuncTable[41] := {$IFDEF FPC} @Func41; {$ELSE} Func41; {$ENDIF}
  fIdentFuncTable[42] := {$IFDEF FPC} @Func42; {$ELSE} Func42; {$ENDIF}
  fIdentFuncTable[44] := {$IFDEF FPC} @Func44; {$ELSE} Func44; {$ENDIF}
  fIdentFuncTable[45] := {$IFDEF FPC} @Func45; {$ELSE} Func45; {$ENDIF}
  fIdentFuncTable[46] := {$IFDEF FPC} @Func46; {$ELSE} Func46; {$ENDIF}
  fIdentFuncTable[47] := {$IFDEF FPC} @Func47; {$ELSE} Func47; {$ENDIF}
  fIdentFuncTable[49] := {$IFDEF FPC} @Func49; {$ELSE} Func49; {$ENDIF}
  fIdentFuncTable[52] := {$IFDEF FPC} @Func52; {$ELSE} Func52; {$ENDIF}
  fIdentFuncTable[54] := {$IFDEF FPC} @Func54; {$ELSE} Func54; {$ENDIF}
  fIdentFuncTable[55] := {$IFDEF FPC} @Func55; {$ELSE} Func55; {$ENDIF}
  fIdentFuncTable[56] := {$IFDEF FPC} @Func56; {$ELSE} Func56; {$ENDIF}
  fIdentFuncTable[57] := {$IFDEF FPC} @Func57; {$ELSE} Func57; {$ENDIF}
  fIdentFuncTable[59] := {$IFDEF FPC} @Func59; {$ELSE} Func59; {$ENDIF}
  fIdentFuncTable[60] := {$IFDEF FPC} @Func60; {$ELSE} Func60; {$ENDIF}
  fIdentFuncTable[61] := {$IFDEF FPC} @Func61; {$ELSE} Func61; {$ENDIF}
  fIdentFuncTable[63] := {$IFDEF FPC} @Func63; {$ELSE} Func63; {$ENDIF}
  fIdentFuncTable[64] := {$IFDEF FPC} @Func64; {$ELSE} Func64; {$ENDIF}
  fIdentFuncTable[65] := {$IFDEF FPC} @Func65; {$ELSE} Func65; {$ENDIF}
  fIdentFuncTable[66] := {$IFDEF FPC} @Func66; {$ELSE} Func66; {$ENDIF}
  fIdentFuncTable[69] := {$IFDEF FPC} @Func69; {$ELSE} Func69; {$ENDIF}
  fIdentFuncTable[71] := {$IFDEF FPC} @Func71; {$ELSE} Func71; {$ENDIF}
  fIdentFuncTable[73] := {$IFDEF FPC} @Func73; {$ELSE} Func73; {$ENDIF}
  fIdentFuncTable[75] := {$IFDEF FPC} @Func75; {$ELSE} Func75; {$ENDIF}
  fIdentFuncTable[76] := {$IFDEF FPC} @Func76; {$ELSE} Func76; {$ENDIF}
  fIdentFuncTable[79] := {$IFDEF FPC} @Func79; {$ELSE} Func79; {$ENDIF}
  fIdentFuncTable[81] := {$IFDEF FPC} @Func81; {$ELSE} Func81; {$ENDIF}
  fIdentFuncTable[84] := {$IFDEF FPC} @Func84; {$ELSE} Func84; {$ENDIF}
  fIdentFuncTable[85] := {$IFDEF FPC} @Func85; {$ELSE} Func85; {$ENDIF}
  fIdentFuncTable[87] := {$IFDEF FPC} @Func87; {$ELSE} Func87; {$ENDIF}
  fIdentFuncTable[88] := {$IFDEF FPC} @Func88; {$ELSE} Func88; {$ENDIF}
  fIdentFuncTable[91] := {$IFDEF FPC} @Func91; {$ELSE} Func91; {$ENDIF}
  fIdentFuncTable[92] := {$IFDEF FPC} @Func92; {$ELSE} Func92; {$ENDIF}
  fIdentFuncTable[94] := {$IFDEF FPC} @Func94; {$ELSE} Func94; {$ENDIF}
  fIdentFuncTable[95] := {$IFDEF FPC} @Func95; {$ELSE} Func95; {$ENDIF}
  fIdentFuncTable[96] := {$IFDEF FPC} @Func96; {$ELSE} Func96; {$ENDIF}
  fIdentFuncTable[97] := {$IFDEF FPC} @Func97; {$ELSE} Func97; {$ENDIF}
  fIdentFuncTable[98] := {$IFDEF FPC} @Func98; {$ELSE} Func98; {$ENDIF}
  fIdentFuncTable[99] := {$IFDEF FPC} @Func99; {$ELSE} Func99; {$ENDIF}
  fIdentFuncTable[100] :={$IFDEF FPC}  @Func100; {$ELSE} Func100; {$ENDIF}
  fIdentFuncTable[101] :={$IFDEF FPC}  @Func101; {$ELSE} Func101; {$ENDIF}
  fIdentFuncTable[102] :={$IFDEF FPC}  @Func102; {$ELSE} Func102; {$ENDIF}
  fIdentFuncTable[103] :={$IFDEF FPC}  @Func103; {$ELSE} Func103; {$ENDIF}
  fIdentFuncTable[105] :={$IFDEF FPC}  @Func105; {$ELSE} Func105; {$ENDIF}
  fIdentFuncTable[106] :={$IFDEF FPC}  @Func106; {$ELSE} Func106; {$ENDIF}
  fIdentFuncTable[108] :={$IFDEF FPC}  @Func108; {$ELSE} Func108; {$ENDIF}
  fIdentFuncTable[112] :={$IFDEF FPC}  @Func112; {$ELSE} Func112; {$ENDIF}
  fIdentFuncTable[117] :={$IFDEF FPC}  @Func117; {$ELSE} Func117; {$ENDIF}
  fIdentFuncTable[118] :={$IFDEF FPC}  @Func118; {$ELSE} Func118; {$ENDIF}
  fIdentFuncTable[126] :={$IFDEF FPC}  @Func126; {$ELSE} Func126; {$ENDIF}
  fIdentFuncTable[129] :={$IFDEF FPC}  @Func129; {$ELSE} Func129; {$ENDIF}
  fIdentFuncTable[132] :={$IFDEF FPC}  @Func132; {$ELSE} Func132; {$ENDIF}
  fIdentFuncTable[133] :={$IFDEF FPC}  @Func133; {$ELSE} Func133; {$ENDIF}
  fIdentFuncTable[136] :={$IFDEF FPC}  @Func136; {$ELSE} Func136; {$ENDIF}
  fIdentFuncTable[141] :={$IFDEF FPC}  @Func141; {$ELSE} Func141; {$ENDIF}
  fIdentFuncTable[143] :={$IFDEF FPC}  @Func143; {$ELSE} Func143; {$ENDIF}
  fIdentFuncTable[147] :={$IFDEF FPC}  @Func147; {$ELSE} Func147; {$ENDIF}
  fIdentFuncTable[166] :={$IFDEF FPC}  @Func166; {$ELSE} Func166; {$ENDIF}
  fIdentFuncTable[168] :={$IFDEF FPC}  @Func168; {$ELSE} Func168; {$ENDIF}
  fIdentFuncTable[191] :={$IFDEF FPC}  @Func191; {$ELSE} Func191; {$ENDIF}


end;

function TSynElphySyn.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in ['a'..'z', 'A'..'Z'] do
  begin
    inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  if ToHash^ in ['_', '0'..'9'] then inc(ToHash);
  fStringLen := ToHash - fToIdent;
end; { KeyHash }

function TSynElphySyn.KeyComp(const aKey: string): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end else Result := False;
end; { KeyComp }

function TSynElphySyn.Func15: TtkTokenKind;
begin
  if KeyComp('If') then Result := tkKey else Result := tkIdentifier;
end;

function TSynElphySyn.Func19: TtkTokenKind;
begin
  if KeyComp('Do') then Result := tkKey else
    if KeyComp('And') then Result := tkKey else Result := tkIdentifier;
end;

function TSynElphySyn.Func20: TtkTokenKind;
begin
  if KeyComp('As') then Result := tkKey else Result := tkIdentifier;
end;

function TSynElphySyn.Func21: TtkTokenKind;
begin
  if KeyComp('Of') then Result := tkKey else Result := tkIdentifier;
end;

function TSynElphySyn.Func23: TtkTokenKind;
begin
  if KeyComp('End') then
  begin
    Result := tkKey;
    fRange := rsUnknown;
  end
  else if KeyComp('In') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func25: TtkTokenKind;
begin
  if KeyComp('Far') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func27: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi2) and KeyComp('Cdecl') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func28: TtkTokenKind;
begin
  if KeyComp('Is') then
    Result := tkKey
  else if (fRange = rsProperty) and KeyComp('Read') then
    Result := tkKey
  else if KeyComp('Case') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func29: TtkTokenKind;
begin
  if KeyComp('on') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func32: TtkTokenKind;
begin
  if KeyComp('Label') then
    Result := tkKey
  else if KeyComp('Mod') then
    Result := tkKey
  else if KeyComp('File') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func33: TtkTokenKind;
begin
  if KeyComp('Or') then
    Result := tkKey
  else if KeyComp('Asm') then
  begin
    Result := tkKey;
    fRange := rsAsm;
    fAsmStart := True;
  end
  else if (fRange = rsExports) and KeyComp('name') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func35: TtkTokenKind;
begin
  if KeyComp('Nil') then
    Result := tkKey
  else if KeyComp('To') then
    Result := tkKey
  else if KeyComp('Div') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func37: TtkTokenKind;
begin
  if KeyComp('Begin') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func38: TtkTokenKind;
begin
  if KeyComp('Near') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func39: TtkTokenKind;
begin
  if KeyComp('For') then
    Result := tkKey
  else if KeyComp('Shl') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func40: TtkTokenKind;
begin
  if KeyComp('Packed') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func41: TtkTokenKind;
begin
  if KeyComp('Else') then
    Result := tkKey
  else if KeyComp('Var') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func42: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi8) and KeyComp('Final') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func44: TtkTokenKind;
begin
  if KeyComp('Set') then
    Result := tkKey
  else if PackageSource and KeyComp('package') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func45: TtkTokenKind;
begin
  if KeyComp('Shr') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func46: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi8) and KeyComp('Sealed') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func47: TtkTokenKind;
begin
  if KeyComp('Then') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func49: TtkTokenKind;
begin
  if KeyComp('Not') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func52: TtkTokenKind;
begin
  if KeyComp('Pascal') then
    Result := tkKey
  else if KeyComp('Raise') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func54: TtkTokenKind;
begin
  if KeyComp('Class') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func55: TtkTokenKind;
begin
  if KeyComp('Object') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func56: TtkTokenKind;
begin
  if (fRange in [rsProperty, rsExports]) and KeyComp('Index') then
    Result := tkKey
  else if KeyComp('Out') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;


function TSynElphySyn.Func57: TtkTokenKind;
begin
  if KeyComp('Goto') then
    Result := tkKey
  else if KeyComp('While') then
    Result := tkKey
  else if KeyComp('Xor') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func59: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Safecall') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func60: TtkTokenKind;
begin
  if KeyComp('With') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func61: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Dispid') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func63: TtkTokenKind;
begin
  if KeyComp('Public') then
    Result := tkKey
  else if KeyComp('Record') then
    Result := tkKey
  else if KeyComp('Array') then
    Result := tkKey
  else if KeyComp('Try') then
    Result := tkKey
  else if KeyComp('Inline') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func64: TtkTokenKind;
begin
  if KeyComp('Unit') then
    Result := tkKey
  else if KeyComp('Uses') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi8) and KeyComp('Helper') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func65: TtkTokenKind;
begin
  if KeyComp('Repeat') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func66: TtkTokenKind;
begin
  if KeyComp('Type') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func69: TtkTokenKind;
begin
  if KeyComp('Default') then
    Result := tkKey
  else if KeyComp('Dynamic') then
    Result := tkKey
  else if KeyComp('Message') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func71: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi2) and KeyComp('Stdcall') then
    Result := tkKey
  else if KeyComp('Const') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func73: TtkTokenKind;
begin
  if KeyComp('Except') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func75: TtkTokenKind;
begin
  if (fRange = rsProperty) and KeyComp('Write') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func76: TtkTokenKind;
begin
  if KeyComp('Until') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func79: TtkTokenKind;
begin
  if KeyComp('Finally') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func81: TtkTokenKind;
begin
  if (fRange = rsProperty) and KeyComp('Stored') then
    Result := tkKey
  else if KeyComp('Interface') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi6) and KeyComp('deprecated') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func84: TtkTokenKind;
begin
  if KeyComp('Abstract') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func85: TtkTokenKind;
begin
  if KeyComp('Forward') then
    Result := tkKey
  else if KeyComp('Library') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func87: TtkTokenKind;
begin
  if KeyComp('String') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func88: TtkTokenKind;
begin
  if KeyComp('Program') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func91: TtkTokenKind;
begin
  if KeyComp('Downto') then
    Result := tkKey
  else if KeyComp('Private') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func92: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi4) and KeyComp('overload') then
    Result := tkKey
  else if KeyComp('Inherited') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func94: TtkTokenKind;
begin
  if KeyComp('Assembler') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi3) and (fRange = rsProperty) and KeyComp('Readonly') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func95: TtkTokenKind;
begin
  if KeyComp('Absolute') then
    Result := tkKey
  else
  if KeyComp('Process') then
    Result := tkKey
  else
  if PackageSource and KeyComp('contains') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func96: TtkTokenKind;
begin
  if KeyComp('Published') then
    Result := tkKey
  else if KeyComp('Override') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func97: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Threadvar') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func98: TtkTokenKind;
begin
  if KeyComp('Export') then
    Result := tkKey
  else if (fRange = rsProperty) and KeyComp('Nodefault') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func99: TtkTokenKind;
begin
  if KeyComp('External') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func100: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Automated') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func101: TtkTokenKind;
begin
  if KeyComp('Register') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi6) and KeyComp('platform') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func102: TtkTokenKind;
begin
  if KeyComp('Function') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func103: TtkTokenKind;
begin
  if KeyComp('Virtual') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func105: TtkTokenKind;
begin
  if KeyComp('Procedure') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func106: TtkTokenKind;
begin
  if KeyComp('Protected') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func108: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi8) and KeyComp('Operator') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func112: TtkTokenKind;
begin
  if PackageSource and KeyComp('requires') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func117: TtkTokenKind;
begin
  if KeyComp('Exports') then
  begin
    Result := tkKey;
    fRange := rsExports;
  end
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func118: TtkTokenKind;
begin
  if KeyComp('EndProcess')
    then Result := tkKey
    else Result := tkIdentifier;
end;

function TSynElphySyn.Func126: TtkTokenKind;
begin
  if (fRange = rsProperty) and (DelphiVersion >= dvDelphi4) and KeyComp('Implements') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func129: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Dispinterface') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func132: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi4) and KeyComp('Reintroduce') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func133: TtkTokenKind;
begin
  if KeyComp('Property') then
  begin
    Result := tkKey;
    fRange := rsProperty;
  end
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func136: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi2) and KeyComp('Finalization') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;


function TSynElphySyn.Func141: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and (fRange = rsProperty) and KeyComp('Writeonly') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func143: TtkTokenKind;
begin
  if KeyComp('Destructor') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func147: TtkTokenKind;
begin
  if KeyComp('InitProcess') then
    Result := tkKey
  else
  if KeyComp('InitProcess0') then
    Result := tkKey
  else
  if KeyComp('ProcessCont') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func166: TtkTokenKind;
begin
  if KeyComp('Constructor') then
    Result := tkKey
  else if KeyComp('Implementation') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func168: TtkTokenKind;
begin
  if KeyComp('Initialization') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.Func191: TtkTokenKind;
begin
  if (DelphiVersion >= dvDelphi3) and KeyComp('Resourcestring') then
    Result := tkKey
  else if (DelphiVersion >= dvDelphi3) and KeyComp('Stringresource') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TSynElphySyn.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier
end;

function TSynElphySyn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey < 192 then Result := fIdentFuncTable[HashKey]() else
    Result := tkIdentifier;
end;

procedure TSynElphySyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := {$IFDEF FPC} @NullProc; {$ELSE} NullProc; {$ENDIF}
      #10: fProcTable[I] := {$IFDEF FPC} @LFProc; {$ELSE} LFProc; {$ENDIF}
      #13: fProcTable[I] := {$IFDEF FPC} @CRProc; {$ELSE} CRProc; {$ENDIF}
      #1..#9, #11, #12, #14..#32:
        fProcTable[I] := {$IFDEF FPC} @SpaceProc; {$ELSE} SpaceProc; {$ENDIF}
      '#': fProcTable[I] := {$IFDEF FPC} @AsciiCharProc; {$ELSE} AsciiCharProc; {$ENDIF}
      '$': fProcTable[I] := {$IFDEF FPC} @IntegerProc; {$ELSE} IntegerProc; {$ENDIF}
      #39: fProcTable[I] := {$IFDEF FPC} @StringProc; {$ELSE} StringProc; {$ENDIF}
      '0'..'9': fProcTable[I] := {$IFDEF FPC} @NumberProc; {$ELSE} NumberProc; {$ENDIF}
      'A'..'Z', 'a'..'z', '_':
        fProcTable[I] := {$IFDEF FPC} @IdentProc; {$ELSE} IdentProc; {$ENDIF}
      '{': fProcTable[I] := {$IFDEF FPC} @BraceOpenProc; {$ELSE} BraceOpenProc; {$ENDIF}
      '}', '!', '"', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
        begin
          case I of
            '(': fProcTable[I] := {$IFDEF FPC} @RoundOpenProc; {$ELSE} RoundOpenProc; {$ENDIF}
            '.': fProcTable[I] := {$IFDEF FPC} @PointProc; {$ELSE} PointProc; {$ENDIF}
            ';': fProcTable[I] := {$IFDEF FPC} @SemicolonProc; {$ELSE} SemicolonProc; {$ENDIF}
            '/': fProcTable[I] := {$IFDEF FPC} @SlashProc; {$ELSE} SlashProc; {$ENDIF}
            ':', '>': fProcTable[I] := {$IFDEF FPC} @ColonOrGreaterProc; {$ELSE} ColonOrGreaterProc; {$ENDIF}
            '<': fProcTable[I] := {$IFDEF FPC} @LowerProc; {$ELSE} LowerProc; {$ENDIF}
            '@': fProcTable[I] := {$IFDEF FPC} @AddressOpProc; {$ELSE} AddressOpProc; {$ENDIF}
          else
            fProcTable[I] := {$IFDEF FPC} @SymbolProc; {$ELSE} SymbolProc; {$ENDIF}
          end;
        end;
    else
      fProcTable[I] := {$IFDEF FPC} @UnknownProc; {$ELSE} UnknownProc; {$ENDIF}
    end;
end;

constructor TSynElphySyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fDelphiVersion := LastDelphiVersion;
  fPackageSource := True;

  fAsmAttri := TSynHighlighterAttributes.Create(SYNS_AttrAssembler);
  AddAttribute(fAsmAttri);
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style:= [fsItalic];
  AddAttribute(fCommentAttri);
  fDirecAttri := TSynHighlighterAttributes.Create(SYNS_AttrPreprocessor);
  fDirecAttri.Style:= [fsItalic];
  AddAttribute(fDirecAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style:= [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber);
  AddAttribute(fNumberAttri);
  fFloatAttri := TSynHighlighterAttributes.Create(SYNS_AttrFloat);
  AddAttribute(fFloatAttri);
  fHexAttri := TSynHighlighterAttributes.Create(SYNS_AttrHexadecimal);
  AddAttribute(fHexAttri);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString);
  AddAttribute(fStringAttri);
  fCharAttri := TSynHighlighterAttributes.Create(SYNS_AttrCharacter);
  AddAttribute(fCharAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol);
  AddAttribute(fSymbolAttri);
  SetAttributesOnChange({$IFDEF FPC}@{$ENDIF}DefHighlightChange);

  InitIdent;
  MakeMethodTables;
  fRange := rsUnknown;
  fAsmStart := False;
  fDefaultFilter := SYNS_FilterPascal;
end; { Create }

procedure TSynElphySyn.SetLine({$IFDEF FPC}Const {$ENDIF}NewValue: string; LineNumber:Integer);
begin
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end; { SetLine }

procedure TSynElphySyn.AddressOpProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] = '@' then inc(Run);
end;

procedure TSynElphySyn.AsciiCharProc;
begin
  fTokenID := tkChar;
  Inc(Run);
  while FLine[Run] in ['0'..'9', '$', 'A'..'F', 'a'..'f'] do
    Inc(Run);
end;

procedure TSynElphySyn.BorProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      if fRange in [rsDirective, rsDirectiveAsm] then
        fTokenID := tkDirec
      else
        fTokenID := tkComment;
      repeat
        if fLine[Run] = '}' then
        begin
          Inc(Run);
          if fRange in [rsBorAsm, rsDirectiveAsm] then
            fRange := rsAsm
          else
            fRange := rsUnKnown;
          break;
        end;
        Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynElphySyn.BraceOpenProc;
begin
  if (fLine[Run + 1] = '$') then
  begin
    if fRange = rsAsm then
      fRange := rsDirectiveAsm
    else
      fRange := rsDirective;
  end
  else
  begin
    if fRange = rsAsm then
      fRange := rsBorAsm
    else
      fRange := rsBor;
  end;
  BorProc;
end;

procedure TSynElphySyn.ColonOrGreaterProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] = '=' then inc(Run);
end;

procedure TSynElphySyn.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    Inc(Run);
end; { CRProc }


procedure TSynElphySyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end; { IdentProc }


procedure TSynElphySyn.IntegerProc;
begin
  inc(Run);
  fTokenID := tkHex;
  while FLine[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do
    Inc(Run);
end; { IntegerProc }


procedure TSynElphySyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end; { LFProc }


procedure TSynElphySyn.LowerProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] in ['=', '>'] then
    Inc(Run);
end; { LowerProc }


procedure TSynElphySyn.NullProc;
begin
  fTokenID := tkNull;
end; { NullProc }

procedure TSynElphySyn.NumberProc;
begin
  Inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', '.', 'e', 'E', '-', '+'] do
  begin
    case FLine[Run] of
      '.':
        if FLine[Run + 1] = '.' then
          Break
        else
          fTokenID := tkFloat;
      'e', 'E': fTokenID := tkFloat;
      '-', '+':
        begin
          if fTokenID <> tkFloat then // arithmetic
            Break;
          if not (FLine[Run - 1] in ['e', 'E']) then
            Break; //float, but it ends here
        end;
    end;
    Inc(Run);
  end;
end; { NumberProc }

procedure TSynElphySyn.PointProc;
begin
  fTokenID := tkSymbol;
  inc(Run);
  if fLine[Run] in ['.', ')'] then
    Inc(Run);
end; { PointProc }

procedure TSynElphySyn.AnsiProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if (fLine[Run] = '*') and (fLine[Run + 1] = ')') then begin
        Inc(Run, 2);
        if fRange = rsAnsiAsm then
          fRange := rsAsm
        else
          fRange := rsUnKnown;
        break;
      end;
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end;
end;

procedure TSynElphySyn.RoundOpenProc;
begin
  Inc(Run);
  case fLine[Run] of
    '*':
      begin
        Inc(Run);
        if fRange = rsAsm then
          fRange := rsAnsiAsm
        else
          fRange := rsAnsi;
        fTokenID := tkComment;
        if not (fLine[Run] in [#0, #10, #13]) then
          AnsiProc;
      end;
    '.':
      begin
        inc(Run);
        fTokenID := tkSymbol;
      end;
  else
    fTokenID := tkSymbol;
  end;
end;

procedure TSynElphySyn.SemicolonProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
  if fRange in [rsProperty, rsExports] then
    fRange := rsUnknown;
end;

procedure TSynElphySyn.SlashProc;
begin
  Inc(Run);
  if (fLine[Run] = '/') and (fDelphiVersion > dvDelphi1) then
  begin
    fTokenID := tkComment;
    repeat
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end
  else
    fTokenID := tkSymbol;
end;

procedure TSynElphySyn.SpaceProc;
begin
  inc(Run);
  fTokenID := tkSpace;
  while FLine[Run] in [#1..#9, #11, #12, #14..#32] do inc(Run);
end;

procedure TSynElphySyn.StringProc;
begin
  fTokenID := tkString;
  Inc(Run);
  while not (fLine[Run] in [#0, #10, #13]) do begin
    if fLine[Run] = #39 then begin
      Inc(Run);
      if fLine[Run] <> #39 then
        break;
    end;
    Inc(Run);
  end;
end;

procedure TSynElphySyn.SymbolProc;
begin
  inc(Run);
  fTokenID := tkSymbol;
end;

procedure TSynElphySyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run, 2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynElphySyn.Next;
begin
  fAsmStart := False;
  fTokenPos := Run;
  case fRange of
    rsAnsi, rsAnsiAsm:
      AnsiProc;
    rsBor, rsBorAsm, rsDirective, rsDirectiveAsm:
      BorProc;
  else
    fProcTable[fLine[Run]];
  end;
end;

function TSynElphySyn.GetDefaultAttribute(Index: integer):
  TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TSynElphySyn.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynElphySyn.GetToken: string;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynElphySyn.GetTokenID: TtkTokenKind;
begin
  if not fAsmStart and (fRange = rsAsm)
    and not (fTokenId in [tkNull, tkComment, tkDirec, tkSpace])
  then
    Result := tkAsm
  else
    Result := fTokenId;
end;

function TSynElphySyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case GetTokenID of
    tkAsm: Result := fAsmAttri;
    tkComment: Result := fCommentAttri;
    tkDirec: Result := fDirecAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkFloat: Result := fFloatAttri;
    tkHex: Result := fHexAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkChar: Result := fCharAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TSynElphySyn.GetTokenKind: integer;
begin
  Result := Ord(GetTokenID);
end;

function TSynElphySyn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TSynElphySyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

procedure TSynElphySyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

procedure TSynElphySyn.ResetRange;
begin
  fRange:= rsUnknown;
end;

procedure TSynElphySyn.EnumUserSettings(DelphiVersions: TStrings);
begin
  { returns the user settings that exist in the registry }
{$IFNDEF SYN_CLX}
  with TBetterRegistry.Create do
  begin
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly('\SOFTWARE\Borland\Delphi') then
      begin
        try
          GetKeyNames(DelphiVersions);
        finally
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
  end;
{$ENDIF}
end;

function TSynElphySyn.UseUserSettings(VersionIndex: integer): boolean;
// Possible parameter values:
//   index into TStrings returned by EnumUserSettings
// Possible return values:
//   true : settings were read and used
//   false: problem reading settings or invalid version specified - old settings
//          were preserved

{$IFNDEF SYN_CLX}
  function ReadDelphiSettings(settingIndex: integer): boolean;

    function ReadDelphiSetting(settingTag: string; attri: TSynHighlighterAttributes; key: string): boolean;

      function ReadDelphi2Or3(settingTag: string; attri: TSynHighlighterAttributes; name: string): boolean;
      var
        i: integer;
      begin
        for i := 1 to Length(name) do
          if name[i] = ' ' then name[i] := '_';
        Result := attri.LoadFromBorlandRegistry(HKEY_CURRENT_USER,
                '\Software\Borland\Delphi\'+settingTag+'\Highlight',name,true);
      end; { ReadDelphi2Or3 }

      function ReadDelphi4OrMore(settingTag: string; attri: TSynHighlighterAttributes; key: string): boolean;
      begin
        Result := attri.LoadFromBorlandRegistry(HKEY_CURRENT_USER,
               '\Software\Borland\Delphi\'+settingTag+'\Editor\Highlight',key,false);
      end; { ReadDelphi4OrMore }

    begin { ReadDelphiSetting }
      try
        if (settingTag[1] = '2') or (settingTag[1] = '3')
          then Result := ReadDelphi2Or3(settingTag,attri,key)
          else Result := ReadDelphi4OrMore(settingTag,attri,key);
      except Result := false; end;
    end; { ReadDelphiSetting }

  var
    tmpAsmAttri       : TSynHighlighterAttributes;
    tmpCommentAttri   : TSynHighlighterAttributes;
    tmpIdentAttri     : TSynHighlighterAttributes;
    tmpKeyAttri       : TSynHighlighterAttributes;
    tmpNumberAttri    : TSynHighlighterAttributes;
    tmpSpaceAttri     : TSynHighlighterAttributes;
    tmpStringAttri    : TSynHighlighterAttributes;
    tmpSymbolAttri    : TSynHighlighterAttributes;
    iVersions         : TStringList;
    iVersionTag       : string;
  begin { ReadDelphiSettings }
    {$IFDEF SYN_DELPHI_7_UP}
    Result := False; // Silence the compiler warning 
    {$ENDIF}
    iVersions := TStringList.Create;
    try
      EnumUserSettings( iVersions );
      if (settingIndex < 0) or (settingIndex >= iVersions.Count) then
      begin
        Result := False;
        Exit;
      end;
      iVersionTag := iVersions[ settingIndex ];
    finally
      iVersions.Free;
    end;
    tmpAsmAttri     := TSynHighlighterAttributes.Create('');
    tmpCommentAttri := TSynHighlighterAttributes.Create('');
    tmpIdentAttri   := TSynHighlighterAttributes.Create('');
    tmpKeyAttri     := TSynHighlighterAttributes.Create('');
    tmpNumberAttri  := TSynHighlighterAttributes.Create('');
    tmpSpaceAttri   := TSynHighlighterAttributes.Create('');
    tmpStringAttri  := TSynHighlighterAttributes.Create('');
    tmpSymbolAttri  := TSynHighlighterAttributes.Create('');

    Result := ReadDelphiSetting( iVersionTag, tmpAsmAttri,'Assembler') and
      ReadDelphiSetting( iVersionTag, tmpCommentAttri,'Comment') and
      ReadDelphiSetting( iVersionTag, tmpIdentAttri,'Identifier') and
      ReadDelphiSetting( iVersionTag, tmpKeyAttri,'Reserved word') and
      ReadDelphiSetting( iVersionTag, tmpNumberAttri,'Number') and
      ReadDelphiSetting( iVersionTag, tmpSpaceAttri,'Whitespace') and
      ReadDelphiSetting( iVersionTag, tmpStringAttri,'String') and
      ReadDelphiSetting( iVersionTag, tmpSymbolAttri,'Symbol');
      
    if Result then
    begin
      fAsmAttri.AssignColorAndStyle( tmpAsmAttri );
      fCharAttri.AssignColorAndStyle( tmpStringAttri ); { Delphi lacks Char attribute }
      fCommentAttri.AssignColorAndStyle( tmpCommentAttri );
      fDirecAttri.AssignColorAndStyle( tmpCommentAttri ); { Delphi lacks Directive attribute }
      fFloatAttri.AssignColorAndStyle( tmpNumberAttri ); { Delphi lacks Float attribute }
      fHexAttri.AssignColorAndStyle( tmpNumberAttri ); { Delphi lacks Hex attribute }
      fIdentifierAttri.AssignColorAndStyle( tmpIdentAttri );
      fKeyAttri.AssignColorAndStyle( tmpKeyAttri );
      fNumberAttri.AssignColorAndStyle( tmpNumberAttri );
      fSpaceAttri.AssignColorAndStyle( tmpSpaceAttri );
      fStringAttri.AssignColorAndStyle( tmpStringAttri );
      fSymbolAttri.AssignColorAndStyle( tmpSymbolAttri );
    end;
    tmpAsmAttri.Free;
    tmpCommentAttri.Free;
    tmpIdentAttri.Free;
    tmpKeyAttri.Free;
    tmpNumberAttri.Free;
    tmpSpaceAttri.Free;
    tmpStringAttri.Free;
    tmpSymbolAttri.Free;
  end; { ReadDelphiSettings }
{$ENDIF}

begin
{$IFNDEF SYN_CLX}
  Result := ReadDelphiSettings( VersionIndex );
{$ELSE}
  Result := False;
{$ENDIF}
end; { TSynElphySyn.UseUserSettings }

function TSynElphySyn.GetIdentChars: TSynIdentChars;
begin
  Result := TSynValidStringChars;
end;

function TSynElphySyn.GetSampleSource: string;
begin
  Result := '{ Syntax highlighting }'#13#10 +
             'procedure TForm1.Button1Click(Sender: TObject);'#13#10 +
             'var'#13#10 +
             '  Number, I, X: Integer;'#13#10 +
             'begin'#13#10 +
             '  Number := 123456;'#13#10 +
             '  Caption := ''The Number is'' + #32 + IntToStr(Number);'#13#10 +
             '  for I := 0 to Number do'#13#10 +
             '  begin'#13#10 +
             '    Inc(X);'#13#10 +
             '    Dec(X);'#13#10 +
             '    X := X + 1.0;'#13#10 +
             '    X := X - $5E;'#13#10 +
             '  end;'#13#10 +
             '  {$R+}'#13#10 +
             '  asm'#13#10 +
             '    mov AX, 1234H'#13#10 +
             '    mov Number, AX'#13#10 +
             '  end;'#13#10 +
             '  {$R-}'#13#10 +
             'end;';
end; { GetSampleSource }


class function TSynElphySyn.GetLanguageName: string;
begin
  Result := SYNS_LangPascal;
end;

class function TSynElphySyn.GetCapabilities: TSynHighlighterCapabilities;
begin
  Result := inherited GetCapabilities + [hcUserSettings];
end;

function TSynElphySyn.IsFilterStored: boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterPascal;
end;

procedure TSynElphySyn.SetDelphiVersion(const Value: TDelphiVersion);
begin
  if fDelphiVersion <> Value then
  begin
    fDelphiVersion := Value;
    if (fDelphiVersion < dvDelphi3) and fPackageSource then
      fPackageSource := False;
    DefHighlightChange( Self );
  end;
end;


procedure TSynElphySyn.SetPackageSource(const Value: Boolean);
begin
  if fPackageSource <> Value then
  begin
    fPackageSource := Value;
    if fPackageSource and (fDelphiVersion < dvDelphi3) then
      fDelphiVersion := dvDelphi3;
    DefHighlightChange( Self );
  end;
end;


Initialization
AffDebug('Initialization SynHighlighterElphy',0);
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynElphySyn);
{$ENDIF}
end.
