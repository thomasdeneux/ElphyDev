{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      Alcinoe Unicode functions
Version:      3.06

Description:  This unit contains a Unicode support library along
              with some additional files to use WideStrings/Unicode
              strings within your application.

Legal issues: Copyright (C) 1999-2005 by Arkadia Software Engineering

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :     14/11/2005: Add Function ALStringToWideString,
                          AlWideStringToString, ALUTF8Encode,
                          ALUTF8decode, ALGetCodePageFromName;

Link :

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit AlFcnUnicode;

interface

uses windows;

Function ALWideRemoveDiacritic(S: Widestring): Widestring;
Function ALWideUpperCaseNoDiacritic(S: Widestring): Widestring;
Function ALWideLowerCaseNoDiacritic(S: Widestring): Widestring;
Function ALUTF8RemoveDiacritic(S: UTF8String): UTF8String;
Function ALUTF8UpperCaseNoDiacritic(S: UTF8String): UTF8String;
Function ALUTF8LowerCaseNoDiacritic(S: UTF8String): UTF8String;
function ALUTF8UpperCase(const s: UTF8String): UTF8String;
function ALUTF8LowerCase(const s: UTF8String): UTF8String;
function AlUTF8DetectBOM(const P: PChar; const Size: Integer): Boolean;
function ALUTF8CharSize(const P: PChar; const Size: Integer): Integer;
function ALUTF8CharCount(const P: PChar; const Size: Integer): Integer; overload;
function ALUTF8CharCount(const S: Utf8String): Integer; overload;
Function ALUTF8Trunc(s:UTF8string; Count: Integer): UTF8String;
Function ALUTF8UpperFirstChar(s:UTF8string): UTF8String;
Function ALUTF8LowerCaseFirstCharUpper(s:UTF8string): UTF8String;
Function ALStringToWideString(const S: string; aCodePage: Word): WideString;
function AlWideStringToString(const WS: WideString; aCodePage: Word): string;
Function ALUTF8Encode(const S: string; aCodePage: Word): UTF8String;
Function ALUTF8decode(const S: UTF8String; aCodePage: Word): String;
Function ALGetCodePageFromName(Acharset:String): Word;

implementation

uses SysUtils,
     AlFcnString;

{********************************************************}
Function ALWideRemoveDiacritic(S: Widestring): Widestring;
var LenS, LenTmpWideStr: Integer;
    i,J: integer;
    TmpWideStr: WideString;
begin
  result := '';
  If s = '' then exit;

  {upper the result}
  LenS := length(S);

  {remove diacritic}
  LenTmpWideStr := FoldStringW(MAP_COMPOSITE, PwideChar(S), LenS, nil, 0);
  setlength(TmpWideStr,LenTmpWideStr);
  FoldStringW(MAP_COMPOSITE, PwideChar(S), LenS, PwideChar(TmpWideStr), LenTmpWideStr);
  i := 1;
  J := 1;
  SetLength(result,lenS);
  while J <= lenS do begin
    Result[j] := TmpWideStr[i];
    if S[j] <> TmpWideStr[i] then inc(i,2)
    else inc(i);
    inc(j);
  end;
end;

{*************************************************************}
Function ALWideUpperCaseNoDiacritic(S: Widestring): Widestring;
begin
  Result := ALWideRemoveDiacritic(WideUppercase(s));
end;

{*************************************************************}
Function ALWideLowerCaseNoDiacritic(S: Widestring): Widestring;
begin
  Result := ALWideRemoveDiacritic(Widelowercase(s));
end;

{********************************************************}
Function ALUTF8RemoveDiacritic(S: UTF8String): UTF8String;
begin
  Result := utf8Encode(
                       ALWideRemoveDiacritic(
                                             UTF8Decode(S)
                                            )
                      );
end;

{*************************************************************}
Function ALUTF8UpperCaseNoDiacritic(S: UTF8String): UTF8String;
begin
  Result := utf8Encode(
                       ALWideUpperCaseNoDiacritic(
                                                  UTF8Decode(S)
                                                 )
                      );
end;

{*************************************************************}
Function ALUTF8LowerCaseNoDiacritic(S: UTF8String): UTF8String;
begin
  Result := utf8Encode(
                       ALWideLowerCaseNoDiacritic(
                                                  UTF8Decode(S)
                                                 )
                      );
end;

{********************************************************}
function ALUTF8UpperCase(const s: UTF8String): UTF8String;
begin
  result := utf8encode(WideUppercase(utf8Decode(s)));
end;

{********************************************************}
function ALUTF8LowerCase(const s: UTF8String): UTF8String;
begin
  result := utf8encode(WideLowerCase(utf8Decode(s)));
end;

{*********************************************************************}
function AlUTF8DetectBOM(const P: PChar; const Size: Integer): Boolean;
var Q: PChar;
begin
  Result := False;
  if Assigned(P) and (Size >= 3) and (P^ = #$EF) then begin
    Q := P;
    Inc(Q);
    if Q^ = #$BB then begin
      Inc(Q);
      if Q^ = #$BF then Result := True;
    end;
  end;
end;

{****************************************************}
{give on how many bits is encoded the first char in P}
function ALUTF8CharSize(const P: PChar; const Size: Integer): Integer;
var C: Byte;
    I: Integer;
    Q: PChar;
begin
  if not Assigned(P) or (Size <= 0) then begin
    Result := 0;
    exit;
  end;
  C := Ord(P^);
  if C < $80 then Result := 1 // 1-byte (US-ASCII value)
  else if C and $C0 = $80 then Result := 1 // invalid encoding
  else begin
    // multi-byte character
    if C and $20 = 0 then Result := 2
    else if C and $10 = 0 then Result := 3
    else if C and $08 = 0 then Result := 4
    else begin
      Result := 1; // invalid encoding
      exit;
    end;
    if Size < Result then exit; // incomplete encoding
    Q := P;
    Inc(Q);
    For I := 1 to Result - 1 do
      if Ord(Q^) and $C0 <> $80 then begin
          Result := 1; // invalid encoding
          exit;
      end
      else Inc(Q);
  end;
end;

{******************************}
{give on how many char are in P}
function ALUTF8CharCount(const P: PChar; const Size: Integer): Integer;
var Q    : PChar;
    L, C : Integer;
begin
  Q := P;
  L := Size;
  Result := 0;
  While L > 0 do begin
    C := ALUTF8CharSize(Q, L);
    Dec(L, C);
    Inc(Q, C);
    Inc(Result);
  end;
end;

{******************************}
{give on how many char are in P}
function ALUTF8CharCount(const S: UTF8String): Integer;
begin
  Result := ALUTF8CharCount(Pointer(S), Length(S));
end;

{******************************}
{give on how many char are in P}
Function ALUTF8Trunc(s:UTF8string; Count: Integer): UTF8String;
var Q    : PChar;
    L, C, M : Integer;
begin
  L := Length(S);
  If (L = 0) or (Count >= L) then Begin
    Result := S;
    Exit;
  end;

  Q := Pchar(S);
  M := 0;

  While L > 0 do begin
    C := ALUTF8CharSize(Q, L);
    If M + C > Count then break;
    inc(M, C);
    Dec(L, C);
    Inc(Q, C);
  end;

  Result := ALCopyStr(S,1,M);
end;

{*****************************}
{Uppercase only the First char}
Function ALUTF8UpperFirstChar(s:UTF8string): UTF8String;
var tmpWideStr: WideString;
begin
  TmpWideStr := UTF8Decode(S);
  result := utf8encode(WideUpperCase(copy(TmpWideStr,1,1)) + copy(TmpWideStr,2,MaxInt));
end;

{***************************************************************}
Function ALUTF8LowerCaseFirstCharUpper(s:UTF8string): UTF8String;
var tmpWideStr: WideString;
begin
  TmpWideStr := UTF8Decode(S);
  result := utf8encode(WideUpperCase(copy(TmpWideStr,1,1)) + WidelowerCase(copy(TmpWideStr,2,MaxInt)));
end;

{****************************************************}
Function ALGetCodePageFromName(Acharset:String): Word;
begin
  Acharset := Trim(AlLowerCase(ACharset));

  if acharset='utf-8' then result := 65001 // unicode (utf-8)
  else if acharset='iso-8859-1' then result := 28591 // western european (iso)
  else if acharset='iso-8859-2' then result := 28592 // central european (iso)
  else if acharset='iso-8859-3' then result := 28593 // latin 3 (iso)
  else if acharset='iso-8859-4' then result := 28594 // baltic (iso)
  else if acharset='iso-8859-5' then result := 28595 // cyrillic (iso)
  else if acharset='iso-8859-6' then result := 28596 // arabic (iso)
  else if acharset='iso-8859-7' then result := 28597 // greek (iso)
  else if acharset='iso-8859-8' then result := 28598 // hebrew (iso-visual)
  else if acharset='iso-8859-9' then result := 28599 // turkish (iso)
  else if acharset='iso-8859-13' then result := 28603 // estonian (iso)
  else if acharset='iso-8859-15' then result := 28605 // latin 9 (iso)
  else if acharset='ibm037' then result := 37 // ibm ebcdic (us-canada)
  else if acharset='ibm437' then result := 437 // oem united states
  else if acharset='ibm500' then result := 500 // ibm ebcdic (international)
  else if acharset='asmo-708' then result := 708 // arabic (asmo 708)
  else if acharset='dos-720' then result := 720 // arabic (dos)
  else if acharset='ibm737' then result := 737 // greek (dos)
  else if acharset='ibm775' then result := 775 // baltic (dos)
  else if acharset='ibm850' then result := 850 // western european (dos)
  else if acharset='ibm852' then result := 852 // central european (dos)
  else if acharset='ibm855' then result := 855 // oem cyrillic
  else if acharset='ibm857' then result := 857 // turkish (dos)
  else if acharset='ibm00858' then result := 858 // oem multilingual latin i
  else if acharset='ibm860' then result := 860 // portuguese (dos)
  else if acharset='ibm861' then result := 861 // icelandic (dos)
  else if acharset='dos-862' then result := 862 // hebrew (dos)
  else if acharset='ibm863' then result := 863 // french canadian (dos)
  else if acharset='ibm864' then result := 864 // arabic (864)
  else if acharset='ibm865' then result := 865 // nordic (dos)
  else if acharset='cp866' then result := 866 // cyrillic (dos)
  else if acharset='ibm869' then result := 869 // greek, modern (dos)
  else if acharset='ibm870' then result := 870 // ibm ebcdic (multilingual latin-2)
  else if acharset='windows-874' then result := 874 // thai (windows)
  else if acharset='cp875' then result := 875 // ibm ebcdic (greek modern)
  else if acharset='shift_jis' then result := 932 // japanese (shift-jis)
  else if acharset='gb2312' then result := 936 // chinese simplified (gb2312)
  else if acharset='ks_c_5601-1987' then result := 949 // korean
  else if acharset='big5' then result := 950 // chinese traditional (big5)
  else if acharset='ibm1026' then result := 1026 // ibm ebcdic (turkish latin-5)
  else if acharset='ibm01047' then result := 1047 // ibm latin-1
  else if acharset='ibm01140' then result := 1140 // ibm ebcdic (us-canada-euro)
  else if acharset='ibm01141' then result := 1141 // ibm ebcdic (germany-euro)
  else if acharset='ibm01142' then result := 1142 // ibm ebcdic (denmark-norway-euro)
  else if acharset='ibm01143' then result := 1143 // ibm ebcdic (finland-sweden-euro)
  else if acharset='ibm01144' then result := 1144 // ibm ebcdic (italy-euro)
  else if acharset='ibm01145' then result := 1145 // ibm ebcdic (spain-euro)
  else if acharset='ibm01146' then result := 1146 // ibm ebcdic (uk-euro)
  else if acharset='ibm01147' then result := 1147 // ibm ebcdic (france-euro)
  else if acharset='ibm01148' then result := 1148 // ibm ebcdic (international-euro)
  else if acharset='ibm01149' then result := 1149 // ibm ebcdic (icelandic-euro)
  else if acharset='utf-16' then result := 1200 // unicode
  else if acharset='unicodefffe' then result := 1201 // unicode (big-endian)
  else if acharset='windows-1250' then result := 1250 // central european (windows)
  else if acharset='windows-1251' then result := 1251 // cyrillic (windows)
  else if acharset='windows-1252' then result := 1252 // western european (windows)
  else if acharset='windows-1253' then result := 1253 // greek (windows)
  else if acharset='windows-1254' then result := 1254 // turkish (windows)
  else if acharset='windows-1255' then result := 1255 // hebrew (windows)
  else if acharset='windows-1256' then result := 1256 // arabic (windows)
  else if acharset='windows-1257' then result := 1257 // baltic (windows)
  else if acharset='windows-1258' then result := 1258 // vietnamese (windows)
  else if acharset='johab' then result := 1361 // korean (johab)
  else if acharset='macintosh' then result := 10000 // western european (mac)
  else if acharset='x-mac-japanese' then result := 10001 // japanese (mac)
  else if acharset='x-mac-chinesetrad' then result := 10002 // chinese traditional (mac)
  else if acharset='x-mac-korean' then result := 10003 // korean (mac)
  else if acharset='x-mac-arabic' then result := 10004 // arabic (mac)
  else if acharset='x-mac-hebrew' then result := 10005 // hebrew (mac)
  else if acharset='x-mac-greek' then result := 10006 // greek (mac)
  else if acharset='x-mac-cyrillic' then result := 10007 // cyrillic (mac)
  else if acharset='x-mac-chinesesimp' then result := 10008 // chinese simplified (mac)
  else if acharset='x-mac-romanian' then result := 10010 // romanian (mac)
  else if acharset='x-mac-ukrainian' then result := 10017 // ukrainian (mac)
  else if acharset='x-mac-thai' then result := 10021 // thai (mac)
  else if acharset='x-mac-ce' then result := 10029 // central european (mac)
  else if acharset='x-mac-icelandic' then result := 10079 // icelandic (mac)
  else if acharset='x-mac-turkish' then result := 10081 // turkish (mac)
  else if acharset='x-mac-croatian' then result := 10082 // croatian (mac)
  else if acharset='x-chinese-cns' then result := 20000 // chinese traditional (cns)
  else if acharset='x-cp20001' then result := 20001 // tca taiwan
  else if acharset='x-chinese-eten' then result := 20002 // chinese traditional (eten)
  else if acharset='x-cp20003' then result := 20003 // ibm5550 taiwan
  else if acharset='x-cp20004' then result := 20004 // teletext taiwan
  else if acharset='x-cp20005' then result := 20005 // wang taiwan
  else if acharset='x-ia5' then result := 20105 // western european (ia5)
  else if acharset='x-ia5-german' then result := 20106 // german (ia5)
  else if acharset='x-ia5-swedish' then result := 20107 // swedish (ia5)
  else if acharset='x-ia5-norwegian' then result := 20108 // norwegian (ia5)
  else if acharset='us-ascii' then result := 20127 // us-ascii
  else if acharset='x-cp20261' then result := 20261 // t.61
  else if acharset='x-cp20269' then result := 20269 // iso-6937
  else if acharset='ibm273' then result := 20273 // ibm ebcdic (germany)
  else if acharset='ibm277' then result := 20277 // ibm ebcdic (denmark-norway)
  else if acharset='ibm278' then result := 20278 // ibm ebcdic (finland-sweden)
  else if acharset='ibm280' then result := 20280 // ibm ebcdic (italy)
  else if acharset='ibm284' then result := 20284 // ibm ebcdic (spain)
  else if acharset='ibm285' then result := 20285 // ibm ebcdic (uk)
  else if acharset='ibm290' then result := 20290 // ibm ebcdic (japanese katakana)
  else if acharset='ibm297' then result := 20297 // ibm ebcdic (france)
  else if acharset='ibm420' then result := 20420 // ibm ebcdic (arabic)
  else if acharset='ibm423' then result := 20423 // ibm ebcdic (greek)
  else if acharset='ibm424' then result := 20424 // ibm ebcdic (hebrew)
  else if acharset='x-ebcdic-koreanextended' then result := 20833 // ibm ebcdic (korean extended)
  else if acharset='ibm-thai' then result := 20838 // ibm ebcdic (thai)
  else if acharset='koi8-r' then result := 20866 // cyrillic (koi8-r)
  else if acharset='ibm871' then result := 20871 // ibm ebcdic (icelandic)
  else if acharset='ibm880' then result := 20880 // ibm ebcdic (cyrillic russian)
  else if acharset='ibm905' then result := 20905 // ibm ebcdic (turkish)
  else if acharset='ibm00924' then result := 20924 // ibm latin-1
  else if acharset='euc-jp' then result := 20932 // japanese (jis 0208-1990 and 0212-1990)
  else if acharset='x-cp20936' then result := 20936 // chinese simplified (gb2312-80)
  else if acharset='x-cp20949' then result := 20949 // korean wansung
  else if acharset='cp1025' then result := 21025 // ibm ebcdic (cyrillic serbian-bulgarian)
  else if acharset='koi8-u' then result := 21866 // cyrillic (koi8-u)
  else if acharset='x-europa' then result := 29001 // europa
  else if acharset='iso-8859-8-i' then result := 38598 // hebrew (iso-logical)
  else if acharset='iso-2022-jp' then result := 50220 // japanese (jis)
  else if acharset='csiso2022jp' then result := 50221 // japanese (jis-allow 1 byte kana)
  else if acharset='iso-2022-jp' then result := 50222 // japanese (jis-allow 1 byte kana - so/si)
  else if acharset='iso-2022-kr' then result := 50225 // korean (iso)
  else if acharset='x-cp50227' then result := 50227 // chinese simplified (iso-2022)
  else if acharset='euc-jp' then result := 51932 // japanese (euc)
  else if acharset='euc-cn' then result := 51936 // chinese simplified (euc)
  else if acharset='euc-kr' then result := 51949 // korean (euc)
  else if acharset='hz-gb-2312' then result := 52936 // chinese simplified (hz)
  else if acharset='gb18030' then result := 54936 // chinese simplified (gb18030)
  else if acharset='x-iscii-de' then result := 57002 // iscii devanagari
  else if acharset='x-iscii-be' then result := 57003 // iscii bengali
  else if acharset='x-iscii-ta' then result := 57004 // iscii tamil
  else if acharset='x-iscii-te' then result := 57005 // iscii telugu
  else if acharset='x-iscii-as' then result := 57006 // iscii assamese
  else if acharset='x-iscii-or' then result := 57007 // iscii oriya
  else if acharset='x-iscii-ka' then result := 57008 // iscii kannada
  else if acharset='x-iscii-ma' then result := 57009 // iscii malayalam
  else if acharset='x-iscii-gu' then result := 57010 // iscii gujarati
  else if acharset='x-iscii-pa' then result := 57011 // iscii punjabi
  else if acharset='utf-7' then result := 65000 // unicode (utf-7)
  else if acharset='utf-32' then result := 65005 // unicode (utf-32)
  else if acharset='utf-32be' then result := 65006 // unicode (utf-32 big-endian)
  else Result := 0; //Default ansi code page
end;

{**************************************************************************}
Function ALStringToWideString(const S: string; aCodePage: Word): WideString;
var InputLength,
    OutputLength: Integer;
begin
  InputLength := Length(S);
  OutputLength := MultiByteToWideChar(aCodePage, 0, PChar(S), InputLength, nil, 0);
  SetLength(Result, OutputLength);
  MultiByteToWideChar(aCodePage, 0, PChar(S), InputLength, PWideChar(Result), OutputLength);
end;

{***************************************************************************}
function AlWideStringToString(const WS: WideString; aCodePage: Word): string;
var InputLength,
    OutputLength: Integer;
begin
  InputLength := Length(WS);
  OutputLength := WideCharToMultiByte(aCodePage, 0, PWideChar(WS), InputLength, nil, 0, nil, nil);
  SetLength(Result, OutputLength);
  WideCharToMultiByte(aCodePage, 0, PWideChar(WS), InputLength, PChar(Result), OutputLength, nil, nil);
end;

{******************************************************************}
Function ALUTF8Encode(const S: string; aCodePage: Word): UTF8String;
begin
  Result := UTF8Encode(ALStringToWideString(S, aCodePage));
end;

{******************************************************************}
Function ALUTF8decode(const S: UTF8String; aCodePage: Word): String;
begin
  Result := ALWideStringToString(UTF8Decode(S), aCodePage);
end;

end.
