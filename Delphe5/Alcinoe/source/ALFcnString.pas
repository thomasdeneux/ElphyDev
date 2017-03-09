{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
              John O'Harrow (john@almcrest.demon.co.uk)

www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      Alcinoe String function
Version:      3.07

Description:  Powerfull stringreplace, Pos, Move, comparetext,
              uppercase, lowercase function. Also a powerfull
              FastTagReplace function To replace in string tag
              like <#tagname params1="value1" params2="value2">
              by custom value

Comments:     Part of this code is copyrighted by John O'Harrow
              John O'Harrow (john@almcrest.demon.co.uk)

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

History:      11/05/2005: Remove the bug in alFastTagReplace that raise
                          an exception when char % is found in the params
                          of a tag
							20/10/2005: Move AlANSICodePage1252UppercaseNoDiacritic to
							            ALWideUpperCaseNoDiacritic in alFcnUnicode...
              16/11/2005: minor update in ALFastTagReplace to better
                          handle the "Handled" property of TALHandleTagfunct
              02/12/2005: 1/ Correct AlCopyStr;
                          2/ Move some copy call to AlCopyStr call;
                          3/ Update AlFastTagReplace to better performance and
                             low memory usage;
              08/12/2005: Update AlFastTagReplace to correct a bug that make
                          rfignorecase wrong in some case
              16/12/2005: remove ALStringMatches that seam to not work propertly
                          use MatchesMask insteed !

Link :

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALfcnString;

{$DEFINE ALStringReplace_AllowLengthShortcut} {Use String Header for String Length (2% Faster)}

interface

uses Windows,
     SysUtils,
     Classes;

type

  {type declaration}
  TALHandleTagfunct = function(const TagString: string; TagParams: TStrings; ExtData: pointer; Var Handled: Boolean): string;
  TALMoveProc = procedure(const Source; var Dest; Count: Integer);
  TALCharPosFunct = function (Ch: Char; const Str: AnsiString): Integer;
  TALPosFunct = function (const SubStr: AnsiString; const Str: AnsiString): Integer;

{from John O'Harrow (john@almcrest.demon.co.uk) - original name: PosEx, PosExIgnoreCase (from ainsiStringReplace project)}
function ALPosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
function ALPosExIgnoreCase(const SubStr, S: string; Offset: Cardinal = 1): Integer;
{from John O'Harrow (john@almcrest.demon.co.uk) - original name: StringReplaceJOH_IA32_4}
function ALStringReplace(const S, OldPattern, NewPattern: AnsiString; Flags: TReplaceFlags): AnsiString;
{from FastCode John O'Harrow (john@almcrest.demon.co.uk) - original name: MoveJOH_IA32_6, MoveJOH_MMX_6, MoveJOH_SSE_6}
{Version: 2.20 - 11-FEB-2005}
procedure ALMove_IA32(const Source; var Dest; Count: Integer);
procedure ALMove_MMX (const Source; var Dest; Count: Integer);
procedure ALMove_SSE (const Source; var Dest; Count: Integer);
{from FastCode John O'Harrow (john@almcrest.demon.co.uk) - original name: PosJOH_IA32_a, PosJOH_MMX_a, PosJOH_SSE_a, PosJOH_SSE2_a}
function ALPos_IA32(const SubStr: AnsiString; const Str: AnsiString): Integer;
function ALPos_MMX(const SubStr: AnsiString; const Str: AnsiString): Integer;
function ALPos_SSE(const SubStr: AnsiString; const Str: AnsiString): Integer;
function ALPos_SSE2(const SubStr: AnsiString; const Str: AnsiString): Integer;
{from FastCode John O'Harrow (john@almcrest.demon.co.uk) - original name: CharPosJOH_IA32, CharPosJOH_MMX, CharPosJOH_SSE, CharPosJOH_SSE2}
function ALCharPos_IA32(Ch: Char; const Str: AnsiString): Integer;
function ALCharPos_MMX(Ch: Char; const Str: AnsiString): Integer;
function ALCharPos_SSE(Ch: Char; const Str: AnsiString): Integer;
function ALCharPos_SSE2(Ch: Char; const Str: AnsiString): Integer;
{from FastCode John O'Harrow (john@almcrest.demon.co.uk) - original name: CharPosEY_JOH_IA32_4_a}
function ALCharPosEX(const SearchCharacter: Char; const SourceString: AnsiString; Occurrence: Integer; StartPos: Integer): Integer; overload;
function ALCharPosEX(const SearchCharacter: Char; const SourceString: AnsiString; StartPos: Integer = 1): Integer; overload;
{from FastCode Aleksandr Sharahov - original name: CompareTextShaAsm4_d}
function ALCompareText(const S1, S2: string): integer;
{from FastCode Aleksandr Sharahov - original name: UpperCaseShaAsm4_d, LowerCaseShaAsm4_d}
function ALUpperCase(const s: string): string;
function ALLowerCase(const s: string): string;
{Alcinoe}
function  ALFastTagReplace(Const SourceString, TagStart, TagEnd: string; FastTagReplaceProc: TALHandleTagFunct; ReplaceStrParamName, ReplaceWith: String; AStripParamQuotes: Boolean; Flags: TReplaceFlags; ExtData: Pointer): string; overload;
function  ALFastTagReplace(const SourceString, TagStart, TagEnd: string; ReplaceStrParamName: String; AStripParamQuotes: Boolean; const Flags: TReplaceFlags=[rfreplaceall]): string; overload
function  ALFastTagReplace(const SourceString, TagStart, TagEnd: string; FastTagReplaceProc: TALHandleTagFunct; AStripParamQuotes: Boolean; ExtData: Pointer; Const flags: TReplaceFlags = [rfreplaceall]): string; overload;
function  ALFastTagReplace(const SourceString, TagStart, TagEnd: string; ReplaceWith: string; const Flags: TReplaceFlags=[rfreplaceall] ): string; overload;
function  ALExtractTagParams(const SourceString, TagStart, TagEnd: string; AStripParamQuotes: Boolean; TagParams: TStrings; IgnoreCase: Boolean): Boolean;
function  ALCopyStr(const aSourceString: string; aStart, aLength: Integer): string;
function  ALRandomStr(aLength: Longint): string;
function  ALNEVExtractName(const S: string): string;
function  ALNEVExtractValue(const s: string): string;
procedure ALExtractHeaderFields(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings; Decode: Boolean; StripQuotes: Boolean = False);
function  ALGetStringFromFile(filename: string): string;
procedure ALSaveStringtoFile(Str,filename: string);
Function  ALAnsiUpperCaseNoDiacritic(S: string): string;

{To jump directly to the good processor optimized procedure}
var ALMove: TALMoveProc;
    ALCharPos: TALCharPosFunct;
    ALPos: TALPosFunct;

implementation

uses HTTPAPP,
     ALCPUID;

{-------------------------------}
const CALMOVE_SMALLMOVESIZE = 36;

{-------------------------------------------------}
var VALMove_AnsiUpcase: packed array[Char] of Char;
    VALMove_PrefetchLimit: Integer;

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////ALPosEx from FastCode AINSIStringReplace John O'Harrow (john@almcrest.demon.co.uk)//////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

{*********************************}
{Fast Equivalent of Delphi 7 PosEx}
function ALPosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
asm
  push    ebx
  push    esi
  push    edx              {@Str}
  test    eax, eax
  jz      @@NotFound       {Exit if SubStr = ''}
  test    edx, edx
  jz      @@NotFound       {Exit if Str = ''}
  mov     esi, ecx
  mov     ecx, [edx-4]     {Length(Str)}
  mov     ebx, [eax-4]     {Length(SubStr)}
  add     ecx, edx
  sub     ecx, ebx         {Max Start Pos for Full Match}
  lea     edx, [edx+esi-1] {Set Start Position}
  cmp     edx, ecx
  jg      @@NotFound       {StartPos > Max Start Pos}
  cmp     ebx, 1           {Length(SubStr)}
  jle     @@SingleChar     {Length(SubStr) <= 1}
  push    edi
  push    ebp
  lea     edi, [ebx-2]     {Length(SubStr) - 2}
  mov     esi, eax
  movzx   ebx, [eax]       {Search Character}
@@Loop:                    {Compare 2 Characters per Loop}
  cmp     bl, [edx]
  jne     @@NotChar1
  mov     ebp, edi         {Remainder}
@@Char1Loop:
  movzx   eax, word ptr [esi+ebp]
  cmp     ax, [edx+ebp]
  jne     @@NotChar1
  sub     ebp, 2
  jnc     @@Char1Loop
  pop     ebp
  pop     edi
  jmp     @@SetResult
@@NotChar1:
  cmp     bl, [edx+1]
  jne     @@NotChar2
  mov     ebp, edi         {Remainder}
@@Char2Loop:
  movzx   eax, word ptr [esi+ebp]
  cmp     ax, [edx+ebp+1]
  jne     @@NotChar2
  sub     ebp, 2
  jnc     @@Char2Loop
  pop     ebp
  pop     edi
  jmp     @@CheckResult
@@NotChar2:
  add     edx, 2
  cmp     edx, ecx         {Next Start Position <= Max Start Position}
  jle     @@Loop
  pop     ebp
  pop     edi
  jmp     @@NotFound
@@SingleChar:
  jl      @@NotFound       {Needed for Zero-Length Non-NIL Strings}
  movzx   eax, [eax]       {Search Character}
@@CharLoop:
  cmp     al, [edx]
  je      @@SetResult
  cmp     al, [edx+1]
  je      @@CheckResult
  add     edx, 2
  cmp     edx, ecx
  jle     @@CharLoop
@@NotFound:
  xor     eax, eax
  pop     edx
  pop     esi
  pop     ebx
  ret
@@CheckResult:             {Check within String}
  cmp     edx, ecx
  jge     @@NotFound
  add     edx, 1
@@SetResult:
  pop     ecx              {@Str}
  pop     esi
  pop     ebx
  neg     ecx
  lea     eax, [edx+ecx+1]
end;

{***********************************}
{Non Case Sensitive version of PosEx}
function ALPosExIgnoreCase(const SubStr, S: string; Offset: Cardinal = 1): Integer;
asm
  push    ebx
  push    esi
  push    edx              {@Str}
  test    eax, eax
  jz      @@NotFound       {Exit if SubStr = ''}
  test    edx, edx
  jz      @@NotFound       {Exit if Str = ''}
  mov     esi, ecx
  mov     ecx, [edx-4]     {Length(Str)}
  mov     ebx, [eax-4]     {Length(SubStr)}
  add     ecx, edx
  sub     ecx, ebx         {Max Start Pos for Full Match}
  lea     edx, [edx+esi-1] {Set Start Position}
  cmp     edx, ecx
  jg      @@NotFound       {StartPos > Max Start Pos}
  cmp     ebx, 1           {Length(SubStr)}
  jle     @@SingleChar     {Length(SubStr) <= 1}
  push    edi
  push    ebp
  lea     edi, [ebx-2]     {Length(SubStr) - 2}
  mov     esi, eax
  push    edi              {Save Remainder to Check = Length(SubStr) - 2}
  push    ecx              {Save Max Start Position}
  lea     edi, VALMove_AnsiUpcase  {Uppercase Lookup Table}
  movzx   ebx, [eax]       {Search Character = 1st Char of SubStr}
  movzx   ebx, [edi+ebx]   {Convert to Uppercase}
@@Loop:                    {Loop Comparing 2 Characters per Loop}
  movzx   eax, [edx]       {Get Next Character}
  movzx   eax, [edi+eax]   {Convert to Uppercase}
  cmp     eax, ebx
  jne     @@NotChar1
  mov     ebp, [esp+4]     {Remainder to Check}
@@Char1Loop:
  movzx   eax, [esi+ebp]
  movzx   ecx, [edx+ebp]
  movzx   eax, [edi+eax]   {Convert to Uppercase}
  movzx   ecx, [edi+ecx]   {Convert to Uppercase}
  cmp     eax, ecx
  jne     @@NotChar1
  movzx   eax, [esi+ebp+1]
  movzx   ecx, [edx+ebp+1]
  movzx   eax, [edi+eax]   {Convert to Uppercase}
  movzx   ecx, [edi+ecx]   {Convert to Uppercase}
  cmp     eax, ecx
  jne     @@NotChar1
  sub     ebp, 2
  jnc     @@Char1Loop
  pop     ecx
  pop     edi
  pop     ebp
  pop     edi
  jmp     @@SetResult
@@NotChar1:
  movzx   eax, [edx+1]     {Get Next Character}
  movzx   eax, [edi+eax]   {Convert to Uppercase}
  cmp     bl, al
  jne     @@NotChar2
  mov     ebp, [esp+4]     {Remainder to Check}
@@Char2Loop:
  movzx   eax, [esi+ebp]
  movzx   ecx, [edx+ebp+1]
  movzx   eax, [edi+eax]   {Convert to Uppercase}
  movzx   ecx, [edi+ecx]   {Convert to Uppercase}
  cmp     eax, ecx
  jne     @@NotChar2
  movzx   eax, [esi+ebp+1]
  movzx   ecx, [edx+ebp+2]
  movzx   eax, [edi+eax]   {Convert to Uppercase}
  movzx   ecx, [edi+ecx]   {Convert to Uppercase}
  cmp     eax, ecx
  jne     @@NotChar2
  sub     ebp, 2
  jnc     @@Char2Loop
  pop     ecx
  pop     edi
  pop     ebp
  pop     edi
  jmp     @@CheckResult    {Check Match is within String Data}
@@NotChar2:
  add     edx, 2
  cmp     edx, [esp]       {Compate to Max Start Position}
  jle     @@Loop           {Loop until Start Position > Max Start Position}
  pop     ecx              {Dump Start Position}
  pop     edi              {Dump Remainder to Check}
  pop     ebp
  pop     edi
  jmp     @@NotFound
@@SingleChar:
  jl      @@NotFound       {Needed for Zero-Length Non-NIL Strings}
  lea     esi, VALMove_AnsiUpcase
  movzx   ebx, [eax]       {Search Character = 1st Char of SubStr}
  movzx   ebx, [esi+ebx]   {Convert to Uppercase}
@@CharLoop:
  movzx   eax, [edx]
  movzx   eax, [esi+eax]   {Convert to Uppercase}
  cmp     eax, ebx
  je      @@SetResult
  movzx   eax, [edx+1]
  movzx   eax, [esi+eax]   {Convert to Uppercase}
  cmp     eax, ebx
  je      @@CheckResult
  add     edx, 2
  cmp     edx, ecx
  jle     @@CharLoop
@@NotFound:
  xor     eax, eax
  pop     edx
  pop     esi
  pop     ebx
  ret
@@CheckResult:             {Check Match is within String Data}
  cmp     edx, ecx
  jge     @@NotFound
  add     edx, 1           {OK - Adjust Result}
@@SetResult:               {Set Result Position}
  pop     ecx              {@Str}
  pop     esi
  pop     ebx
  neg     ecx
  lea     eax, [edx+ecx+1]
end;




///////////////////////////////////////////////////////////////////////////////////////////////
//////////AlFastStringReplace from FastCode John O'Harrow (john@almcrest.demon.co.uk)//////////
///////////////////////////////////////////////////////////////////////////////////////////////

{****************************************}
{Non-Overlapping Move for Positive Counts}
procedure ALStringReplaceMoveEx(const Source; var Dest; Count: Integer);
const
  SMALLMOVESIZE = 16;
asm
  cmp     ecx, SMALLMOVESIZE
  ja      @Large
  lea     eax, [eax+ecx]
  lea     edx, [edx+ecx]
  jmp     dword ptr [@@FwdJumpTable+ecx*4]
@Large:
  fild    qword ptr [eax]
  fistp   qword ptr [edx]
  add     eax, ecx
  add     ecx, edx
  add     edx, 7+8
  neg     ecx
  and     edx, -8
  add     ecx, edx
  sub     edx, ecx {Writes Now QWORD Aligned}
@FwdLoop:
  fild    qword ptr [eax+ecx-8]
  fistp   qword ptr [edx+ecx-8]
  add     ecx, 8
  jle     @FwdLoop
  neg     ecx
  add     ecx, 8
  jmp     dword ptr [@@FwdJumpTable+ecx*4]
  nop {Align Jump Table}
@@FwdJumpTable:
  dd      @@Done {Removes need to test for zero size Move}
  dd      @@Fwd01,@@Fwd02,@@Fwd03,@@Fwd04,@@Fwd05,@@Fwd06,@@Fwd07,@@Fwd08
  dd      @@Fwd09,@@Fwd10,@@Fwd11,@@Fwd12,@@Fwd13,@@Fwd14,@@Fwd15,@@Fwd16
@@Fwd16:
  mov     ecx,[eax-16]
  mov     [edx-16],ecx
@@Fwd12:
  mov     ecx,[eax-12]
  mov     [edx-12],ecx
@@Fwd08:
  mov     ecx,[eax-8]
  mov     [edx-8],ecx
@@Fwd04:
  mov     ecx,[eax-4]
  mov     [edx-4],ecx
  ret
@@Fwd15:
  mov     ecx,[eax-15]
  mov     [edx-15],ecx
@@Fwd11:
  mov     ecx,[eax-11]
  mov     [edx-11],ecx
@@Fwd07:
  mov     ecx,[eax-7]
  mov     [edx-7],ecx
@@Fwd03:
  movzx   ecx, word ptr [eax-3]
  mov     [edx-3],cx
  movzx   ecx, byte ptr [eax-1]
  mov     [edx-1],cl
  ret
@@Fwd14:
  mov     ecx,[eax-14]
  mov     [edx-14],ecx
@@Fwd10:
  mov     ecx,[eax-10]
  mov     [edx-10],ecx
@@Fwd06:
  mov     ecx,[eax-6]
  mov     [edx-6],ecx
@@Fwd02:
  movzx   ecx, word ptr [eax-2]
  mov     [edx-2],cx
  ret
@@Fwd13:
  mov     ecx,[eax-13]
  mov     [edx-13],ecx
@@Fwd09:
  mov     ecx,[eax-9]
  mov     [edx-9],ecx
@@Fwd05:
  mov     ecx,[eax-5]
  mov     [edx-5],ecx
@@Fwd01:
  movzx   ecx, byte ptr [eax-1]
  mov     [edx-1],cl
@@Done:
end; {MoveEx}

{**************************************************************************}
{Replace all occurance of Old (Ignoring Case) with New in Non-Null String S}
procedure ALCharReplaceIC(var S: AnsiString; const Old, New: Char);
asm
  push  ebx
  push  edi
  push  esi
  mov   eax, [eax]         {@S}
  mov   ebx, ecx           {bl = New}
  lea   edi, VALMove_AnsiUpcase
  and   edx, $FF           {edx = Old}
  mov   ecx, [eax-4]       {Length(S)}
  movzx edx, [edx+edi]     {edx = Uppercase(Old)}
  lea   esi, [eax+ecx]
  neg   ecx
@@Loop:
  movzx eax, [esi+ecx]     {Next Char}
  movzx eax, [eax+edi]     {Convert to Uppercase}
  cmp   eax, edx           {Compare Char}
  jne   @@Next
  mov   [esi+ecx], bl      {Replace Char}
@@Next:
  add   ecx, 1
  jnz   @@Loop
  pop   esi
  pop   edi
  pop   ebx
end;

{***************************************************************************}
{Replace all occurance of Old (Case Sensitive) with New in Non-Null String S}
procedure ALCharReplaceCS(var S: AnsiString; const Old, New: Char);
asm
  push  ebx
  mov   eax, [eax]    {@S}
  mov   ebx, ecx      {bl = New, dl = Old}
  mov   ecx, [eax-4]  {Length(S)}
  add   eax, ecx
  neg   ecx                                  
@@Loop:
  cmp   dl, [eax+ecx] {Compare Next Char}
  jne   @@Next
  mov   [eax+ecx], bl {Replace Char}
@@Next:
  add   ecx, 1
  jnz   @@Loop
  pop   ebx
end;

{***************************************************************************************}
{from John O'Harrow (john@almcrest.demon.co.uk) - original name: StringReplaceJOH_IA32_4}
function ALStringReplace(const S, OldPattern, NewPattern: AnsiString; Flags: TReplaceFlags): AnsiString;
type
  TPosEx   = function(const SubStr, S: string; Offset: Cardinal = 1): Integer;
  TCharRep = procedure(var S: AnsiString; const Old, New: Char);
const
  StaticBufferSize = 16;
  PosExFunction: array[Boolean] of TPosEx   = (ALPosEx, ALPosExIgnoreCase);
  CharReplace: array[Boolean] of TCharRep = (ALCharReplaceCS, ALCharReplaceIC);
var
  SrcLen, OldLen, NewLen, Found, Count, Start, Match, BufSize, BufMax: Integer;
  StaticBuffer : array[0..StaticBufferSize-1] of Integer;
  Buffer       : PIntegerArray;
  PSrc, PRes   : PChar;
  IgnoreCase   : Boolean;
begin
{$IFDEF ALStringReplace_AllowLengthShortcut}
  SrcLen := 0;
  if (S <> '') then      
    SrcLen := PCardinal(Cardinal(S)-4)^;
  OldLen := 0;
  if (OldPattern <> '') then
    OldLen := PCardinal(Cardinal(OldPattern)-4)^;
  NewLen := 0;
  if (NewPattern <> '') then
    NewLen := PCardinal(Cardinal(NewPattern)-4)^;
{$ELSE}
  SrcLen := Length(S);
  OldLen := Length(OldPattern);
  NewLen := Length(NewPattern);
{$ENDIF}
  if (OldLen = 0) or (SrcLen < OldLen) then
    begin
      if SrcLen = 0 then
        Result := '' {Needed for Non-Nil Zero Length Strings}
      else
        Result := S
    end
  else
    begin
      IgnoreCase := rfIgnoreCase in Flags;
      if rfReplaceAll in Flags then
        begin
          if (OldLen = 1) and (NewLen = 1) then
            begin
              SetLength(Result, SrcLen);
              ALStringReplaceMoveEx(Pointer(S)^, Pointer(Result)^, SrcLen);
              CharReplace[IgnoreCase](Result, OldPattern[1], NewPattern[1]);
              Exit;
            end;
          Found := PosExFunction[IgnoreCase](OldPattern, S, 1);
          if Found <> 0 then
            begin
              Buffer    := @StaticBuffer;
              BufMax    := StaticBufferSize;
              BufSize   := 1;
              Buffer[0] := Found;
              repeat
                Inc(Found, OldLen);
                Found := PosExFunction[IgnoreCase](OldPattern, S, Found);
                if Found > 0 then
                  begin
                    if BufSize = BufMax then
                      begin {Create or Expand Dynamic Buffer}
                        BufMax := BufMax + (BufMax shr 1); {Grow by 50%}
                        if Buffer = @StaticBuffer then
                          begin {Create Dynamic Buffer}
                            GetMem(Buffer, BufMax * SizeOf(Integer));
                            ALStringReplaceMoveEx(StaticBuffer, Buffer^, SizeOf(StaticBuffer));
                          end
                        else {Expand Dynamic Buffer}
                          ReallocMem(Buffer, BufMax * SizeOf(Integer));
                      end;
                    Buffer[BufSize] := Found;
                    Inc(BufSize);
                  end
              until Found = 0;
              SetLength(Result, SrcLen + (BufSize * (NewLen - OldLen)));
              PSrc := Pointer(S);
              PRes := Pointer(Result);
              Start := 1;
              Match := 0;
              repeat
                Found := Buffer[Match];
                Count := Found - Start;
                Start := Found + OldLen;
                if Count > 0 then
                  begin
                    ALStringReplaceMoveEx(PSrc^, PRes^, Count);
                    Inc(PRes, Count);
                  end;
                Inc(PSrc, Count + OldLen);
                ALStringReplaceMoveEx(Pointer(NewPattern)^, PRes^, NewLen);
                Inc(PRes, NewLen);
                Inc(Match);
              until Match = BufSize;
              Dec(SrcLen, Start);
              if SrcLen >= 0 then
                ALStringReplaceMoveEx(PSrc^, PRes^, SrcLen + 1);
              if BufMax <> StaticBufferSize then
                FreeMem(Buffer); {Free Dynamic Buffwe if Created}
            end
          else {No Matches Found}                
            Result := S
        end
      else
        begin {Replace First Occurance Only}
          Found := PosExFunction[IgnoreCase](OldPattern, S, 1);
          if Found <> 0 then
            begin {Match Found}
              SetLength(Result, SrcLen - OldLen + NewLen);
              Dec(Found);
              PSrc := Pointer(S);
              PRes := Pointer(Result);
              if NewLen = OldLen then
                begin
                  ALStringReplaceMoveEx(PSrc^, PRes^, SrcLen);
                  Inc(PRes, Found);
                  ALStringReplaceMoveEx(Pointer(NewPattern)^, PRes^, NewLen);
                end
              else
                begin
                  ALStringReplaceMoveEx(PSrc^, PRes^, Found);
                  Inc(PRes, Found);
                  Inc(PSrc, Found + OldLen);
                  ALStringReplaceMoveEx(Pointer(NewPattern)^, PRes^, NewLen);
                  Inc(PRes, NewLen);
                  ALStringReplaceMoveEx(PSrc^, PRes^, SrcLen - Found - OldLen);
                end;
            end
          else {No Matches Found}
            Result := S
        end;
    end;
end;




//////////////////////////////////////////////////////////////////////////////////
//////////AlMove from FastCode John O'Harrow (john@almcrest.demon.co.uk)//////////
//////////////////////////////////////////////////////////////////////////////////

{***********************************}
{Perform Forward Move of 0..36 Bytes}
{On Entry, ECX = Count, EAX = Source+Count, EDX = Dest+Count.  Destroys ECX}
procedure ALSmallForwardMove;
asm
  jmp     dword ptr [@@FwdJumpTable+ecx*4]
  nop {Align Jump Table}
@@FwdJumpTable:
  dd      @@Done {Removes need to test for zero size move}
  dd      @@Fwd01, @@Fwd02, @@Fwd03, @@Fwd04, @@Fwd05, @@Fwd06, @@Fwd07, @@Fwd08
  dd      @@Fwd09, @@Fwd10, @@Fwd11, @@Fwd12, @@Fwd13, @@Fwd14, @@Fwd15, @@Fwd16
  dd      @@Fwd17, @@Fwd18, @@Fwd19, @@Fwd20, @@Fwd21, @@Fwd22, @@Fwd23, @@Fwd24
  dd      @@Fwd25, @@Fwd26, @@Fwd27, @@Fwd28, @@Fwd29, @@Fwd30, @@Fwd31, @@Fwd32
  dd      @@Fwd33, @@Fwd34, @@Fwd35, @@Fwd36
@@Fwd36:
  mov     ecx, [eax-36]
  mov     [edx-36], ecx
@@Fwd32:
  mov     ecx, [eax-32]
  mov     [edx-32], ecx
@@Fwd28:
  mov     ecx, [eax-28]
  mov     [edx-28], ecx
@@Fwd24:
  mov     ecx, [eax-24]
  mov     [edx-24], ecx
@@Fwd20:
  mov     ecx, [eax-20]
  mov     [edx-20], ecx
@@Fwd16:
  mov     ecx, [eax-16]
  mov     [edx-16], ecx
@@Fwd12:
  mov     ecx, [eax-12]
  mov     [edx-12], ecx
@@Fwd08:
  mov     ecx, [eax-8]
  mov     [edx-8], ecx
@@Fwd04:
  mov     ecx, [eax-4]
  mov     [edx-4], ecx
  ret
  nop
@@Fwd35:
  mov     ecx, [eax-35]
  mov     [edx-35], ecx
@@Fwd31:
  mov     ecx, [eax-31]
  mov     [edx-31], ecx
@@Fwd27:
  mov     ecx, [eax-27]
  mov     [edx-27], ecx
@@Fwd23:
  mov     ecx, [eax-23]
  mov     [edx-23], ecx
@@Fwd19:
  mov     ecx, [eax-19]
  mov     [edx-19], ecx
@@Fwd15:
  mov     ecx, [eax-15]
  mov     [edx-15], ecx
@@Fwd11:
  mov     ecx, [eax-11]
  mov     [edx-11], ecx
@@Fwd07:
  mov     ecx, [eax-7]
  mov     [edx-7], ecx
  mov     ecx, [eax-4]
  mov     [edx-4], ecx
  ret
  nop
@@Fwd03:
  movzx   ecx,  word ptr [eax-3]
  mov     [edx-3], cx
  movzx   ecx,  byte ptr [eax-1]
  mov     [edx-1], cl
  ret
@@Fwd34:
  mov     ecx, [eax-34]
  mov     [edx-34], ecx
@@Fwd30:
  mov     ecx, [eax-30]
  mov     [edx-30], ecx
@@Fwd26:
  mov     ecx, [eax-26]
  mov     [edx-26], ecx
@@Fwd22:
  mov     ecx, [eax-22]
  mov     [edx-22], ecx
@@Fwd18:
  mov     ecx, [eax-18]
  mov     [edx-18], ecx
@@Fwd14:
  mov     ecx, [eax-14]
  mov     [edx-14], ecx
@@Fwd10:
  mov     ecx, [eax-10]
  mov     [edx-10], ecx
@@Fwd06:
  mov     ecx, [eax-6]
  mov     [edx-6], ecx
@@Fwd02:
  movzx   ecx,  word ptr [eax-2]
  mov     [edx-2], cx
  ret
  nop
  nop
  nop
@@Fwd33:
  mov     ecx, [eax-33]
  mov     [edx-33], ecx
@@Fwd29:
  mov     ecx, [eax-29]
  mov     [edx-29], ecx
@@Fwd25:
  mov     ecx, [eax-25]
  mov     [edx-25], ecx
@@Fwd21:
  mov     ecx, [eax-21]
  mov     [edx-21], ecx
@@Fwd17:
  mov     ecx, [eax-17]
  mov     [edx-17], ecx
@@Fwd13:
  mov     ecx, [eax-13]
  mov     [edx-13], ecx
@@Fwd09:
  mov     ecx, [eax-9]
  mov     [edx-9], ecx
@@Fwd05:
  mov     ecx, [eax-5]
  mov     [edx-5], ecx
@@Fwd01:
  movzx   ecx,  byte ptr [eax-1]
  mov     [edx-1], cl
  ret
@@Done:
end;

{************************************}
{Perform Backward Move of 0..36 Bytes}
{On Entry, ECX = Count, EAX = Source, EDX = Dest.  Destroys ECX}
procedure ALSmallBackwardMove;
asm
  jmp     dword ptr [@@BwdJumpTable+ecx*4]
  nop {Align Jump Table}
@@BwdJumpTable:
  dd      @@Done {Removes need to test for zero size move}
  dd      @@Bwd01, @@Bwd02, @@Bwd03, @@Bwd04, @@Bwd05, @@Bwd06, @@Bwd07, @@Bwd08
  dd      @@Bwd09, @@Bwd10, @@Bwd11, @@Bwd12, @@Bwd13, @@Bwd14, @@Bwd15, @@Bwd16
  dd      @@Bwd17, @@Bwd18, @@Bwd19, @@Bwd20, @@Bwd21, @@Bwd22, @@Bwd23, @@Bwd24
  dd      @@Bwd25, @@Bwd26, @@Bwd27, @@Bwd28, @@Bwd29, @@Bwd30, @@Bwd31, @@Bwd32
  dd      @@Bwd33, @@Bwd34, @@Bwd35, @@Bwd36
@@Bwd36:
  mov     ecx, [eax+32]
  mov     [edx+32], ecx
@@Bwd32:
  mov     ecx, [eax+28]
  mov     [edx+28], ecx
@@Bwd28:
  mov     ecx, [eax+24]
  mov     [edx+24], ecx
@@Bwd24:
  mov     ecx, [eax+20]
  mov     [edx+20], ecx
@@Bwd20:
  mov     ecx, [eax+16]
  mov     [edx+16], ecx
@@Bwd16:
  mov     ecx, [eax+12]
  mov     [edx+12], ecx
@@Bwd12:
  mov     ecx, [eax+8]
  mov     [edx+8], ecx
@@Bwd08:
  mov     ecx, [eax+4]
  mov     [edx+4], ecx
@@Bwd04:
  mov     ecx, [eax]
  mov     [edx], ecx
  ret
  nop
  nop
  nop
@@Bwd35:
  mov     ecx, [eax+31]
  mov     [edx+31], ecx
@@Bwd31:
  mov     ecx, [eax+27]
  mov     [edx+27], ecx
@@Bwd27:
  mov     ecx, [eax+23]
  mov     [edx+23], ecx
@@Bwd23:
  mov     ecx, [eax+19]
  mov     [edx+19], ecx
@@Bwd19:
  mov     ecx, [eax+15]
  mov     [edx+15], ecx
@@Bwd15:
  mov     ecx, [eax+11]
  mov     [edx+11], ecx
@@Bwd11:
  mov     ecx, [eax+7]
  mov     [edx+7], ecx
@@Bwd07:
  mov     ecx, [eax+3]
  mov     [edx+3], ecx
  mov     ecx, [eax]
  mov     [edx], ecx
  ret
  nop
  nop
  nop
@@Bwd03:
  movzx   ecx,  word ptr [eax+1]
  mov     [edx+1], cx
  movzx   ecx,  byte ptr [eax]
  mov     [edx], cl
  ret
  nop
  nop
@@Bwd34:
  mov     ecx, [eax+30]
  mov     [edx+30], ecx
@@Bwd30:
  mov     ecx, [eax+26]
  mov     [edx+26], ecx
@@Bwd26:
  mov     ecx, [eax+22]
  mov     [edx+22], ecx
@@Bwd22:
  mov     ecx, [eax+18]
  mov     [edx+18], ecx
@@Bwd18:
  mov     ecx, [eax+14]
  mov     [edx+14], ecx
@@Bwd14:
  mov     ecx, [eax+10]
  mov     [edx+10], ecx
@@Bwd10:
  mov     ecx, [eax+6]
  mov     [edx+6], ecx
@@Bwd06:
  mov     ecx, [eax+2]
  mov     [edx+2], ecx
@@Bwd02:
  movzx   ecx,  word ptr [eax]
  mov     [edx], cx
  ret
  nop
@@Bwd33:
  mov     ecx, [eax+29]
  mov     [edx+29], ecx
@@Bwd29:
  mov     ecx, [eax+25]
  mov     [edx+25], ecx
@@Bwd25:
  mov     ecx, [eax+21]
  mov     [edx+21], ecx
@@Bwd21:
  mov     ecx, [eax+17]
  mov     [edx+17], ecx
@@Bwd17:
  mov     ecx, [eax+13]
  mov     [edx+13], ecx
@@Bwd13:
  mov     ecx, [eax+9]
  mov     [edx+9], ecx
@@Bwd09:
  mov     ecx, [eax+5]
  mov     [edx+5], ecx
@@Bwd05:
  mov     ecx, [eax+1]
  mov     [edx+1], ecx
@@Bwd01:
  movzx   ecx,  byte ptr[eax]
  mov     [edx], cl
  ret
  nop
  nop
@@Done:
end;

{****************************************************************************}
{Move ECX Bytes from EAX to EDX, where EAX > EDX and ECX > 36 (SMALLMOVESIZE)}
procedure ALForwards_IA32;
asm
  push    ebx
  mov     ebx, edx
  fild    qword ptr [eax]
  add     eax, ecx {QWORD Align Writes}
  add     ecx, edx
  add     edx, 7
  and     edx, -8
  sub     ecx, edx
  add     edx, ecx {Now QWORD Aligned}
  sub     ecx, 16
  neg     ecx
@FwdLoop:
  fild    qword ptr [eax+ecx-16]
  fistp   qword ptr [edx+ecx-16]
  fild    qword ptr [eax+ecx-8]
  fistp   qword ptr [edx+ecx-8]
  add     ecx, 16
  jle     @FwdLoop
  fistp   qword ptr [ebx]
  neg     ecx
  add     ecx, 16
  pop     ebx
  jmp     ALSmallForwardMove
end;

{****************************************************************************}
{Move ECX Bytes from EAX to EDX, where EAX < EDX and ECX > 36 (SMALLMOVESIZE)}
procedure ALBackwards_IA32;
asm
  push    ebx
  fild    qword ptr [eax+ecx-8]
  lea     ebx, [edx+ecx] {QWORD Align Writes}
  and     ebx, 7
  sub     ecx, ebx
  add     ebx, ecx {Now QWORD Aligned, EBX = Original Length}
  sub     ecx, 16
@BwdLoop:
  fild    qword ptr [eax+ecx]
  fild    qword ptr [eax+ecx+8]
  fistp   qword ptr [edx+ecx+8]
  fistp   qword ptr [edx+ecx]
  sub     ecx, 16
  jge     @BwdLoop
  fistp   qword ptr [edx+ebx-8]
  add     ecx, 16
  pop     ebx
  jmp     ALSmallBackwardMove
end;

{****************************************************************************}
{Move ECX Bytes from EAX to EDX, where EAX > EDX and ECX > 36 (SMALLMOVESIZE)}
procedure ALForwards_MMX;
const
  LARGESIZE = 1024;
asm
  cmp     ecx, LARGESIZE
  jge     @FwdLargeMove
  cmp     ecx, 72 {Size at which using MMX becomes worthwhile}
  jl      ALForwards_IA32
  push    ebx
  mov     ebx, edx
  movq    mm0, [eax] {First 8 Bytes}
  {QWORD Align Writes}
  add     eax, ecx
  add     ecx, edx
  add     edx, 7
  and     edx, -8
  sub     ecx, edx
  add     edx, ecx
  {Now QWORD Aligned}
  sub     ecx, 32
  neg     ecx
@FwdLoopMMX:
  movq    mm1, [eax+ecx-32]
  movq    mm2, [eax+ecx-24]
  movq    mm3, [eax+ecx-16]
  movq    mm4, [eax+ecx- 8]
  movq    [edx+ecx-32], mm1
  movq    [edx+ecx-24], mm2
  movq    [edx+ecx-16], mm3
  movq    [edx+ecx- 8], mm4
  add     ecx, 32
  jle     @FwdLoopMMX
  movq    [ebx], mm0 {First 8 Bytes}
  emms
  pop     ebx
  neg     ecx
  add     ecx, 32
  jmp     ALSmallForwardMove
@FwdLargeMove:
  push    ebx
  mov     ebx, ecx
  test    edx, 15
  jz      @FwdAligned
  {16 byte Align Destination}
  mov     ecx, edx
  add     ecx, 15
  and     ecx, -16
  sub     ecx, edx
  add     eax, ecx
  add     edx, ecx
  sub     ebx, ecx
  {Destination now 16 Byte Aligned}
  call    ALSmallForwardMove
@FwdAligned:
  mov     ecx, ebx
  and     ecx, -16
  sub     ebx, ecx {EBX = Remainder}
  push    esi
  push    edi
  mov     esi, eax          {ESI = Source}
  mov     edi, edx          {EDI = Dest}
  mov     eax, ecx          {EAX = Count}
  and     eax, -64          {EAX = No of Bytes to Blocks Moves}
  and     ecx, $3F          {ECX = Remaining Bytes to Move (0..63)}
  add     esi, eax
  add     edi, eax
  shr     eax, 3            {EAX = No of QWORD's to Block Move}
  neg     eax
@MMXcopyloop:
  movq    mm0, [esi+eax*8   ]
  movq    mm1, [esi+eax*8+ 8]
  movq    mm2, [esi+eax*8+16]
  movq    mm3, [esi+eax*8+24]
  movq    mm4, [esi+eax*8+32]
  movq    mm5, [esi+eax*8+40]
  movq    mm6, [esi+eax*8+48]
  movq    mm7, [esi+eax*8+56]
  movq    [edi+eax*8   ], mm0
  movq    [edi+eax*8+ 8], mm1
  movq    [edi+eax*8+16], mm2
  movq    [edi+eax*8+24], mm3
  movq    [edi+eax*8+32], mm4
  movq    [edi+eax*8+40], mm5
  movq    [edi+eax*8+48], mm6
  movq    [edi+eax*8+56], mm7
  add     eax, 8
  jnz     @MMXcopyloop
  emms                   {Empty MMX State}
  add     ecx, ebx
  shr     ecx, 2
  rep     movsd
  mov     ecx, ebx
  and     ecx, 3
  rep     movsb
  pop     edi
  pop     esi
  pop     ebx
end;

{****************************************************************************}
{Move ECX Bytes from EAX to EDX, where EAX < EDX and ECX > 36 (SMALLMOVESIZE)}
procedure ALBackwards_MMX;
asm
  cmp     ecx, 72 {Size at which using MMX becomes worthwhile}
  jl      ALBackwards_IA32
  push    ebx
  movq    mm0, [eax+ecx-8] {Get Last QWORD}
  {QWORD Align Writes}
  lea     ebx, [edx+ecx]
  and     ebx, 7
  sub     ecx, ebx
  add     ebx, ecx
  {Now QWORD Aligned}
  sub     ecx, 32
@BwdLoopMMX:
  movq    mm1, [eax+ecx   ]
  movq    mm2, [eax+ecx+ 8]
  movq    mm3, [eax+ecx+16]
  movq    mm4, [eax+ecx+24]
  movq    [edx+ecx+24], mm4
  movq    [edx+ecx+16], mm3
  movq    [edx+ecx+ 8], mm2
  movq    [edx+ecx   ], mm1
  sub     ecx, 32
  jge     @BwdLoopMMX
  movq    [edx+ebx-8],  mm0 {Last QWORD}
  emms
  add     ecx, 32
  pop     ebx
  jmp     ALSmallBackwardMove
end;

{***********************************************************}
{Dest MUST be 16-Byes Aligned, Count MUST be multiple of 16 }
procedure ALAlignedFwdMoveSSE(const Source; var Dest; Count: Integer);
const
  Prefetch = 512;
asm
  push    ebx
  mov     ebx, eax                {ebx = Source}
  mov     eax, ecx                {EAX = Count}
  and     eax, -128               {EAX = No of Bytes to Block Move}
  add     ebx, eax
  add     edx, eax
  shr     eax, 3                  {EAX = No of QWORD's to Block Move}
  neg     eax
  cmp     eax, VALMove_PrefetchLimit   {Count > Limit - Use Prefetch}
  jl      @Large
@Small:
  test    ebx, 15                 {Check if Both Source/Dest are Aligned}
  jnz     @SmallUnaligned
@SmallAligned:                    {Both Source and Dest 16-Byte Aligned}

  nop                             {Align Loops}
  nop
  nop

@SmallAlignedLoop:
  movaps  xmm0, [ebx+8*eax]
  movaps  xmm1, [ebx+8*eax+16]
  movaps  xmm2, [ebx+8*eax+32]
  movaps  xmm3, [ebx+8*eax+48]
  movaps  [edx+8*eax], xmm0
  movaps  [edx+8*eax+16], xmm1
  movaps  [edx+8*eax+32], xmm2
  movaps  [edx+8*eax+48], xmm3
  movaps  xmm4, [ebx+8*eax+64]
  movaps  xmm5, [ebx+8*eax+80]
  movaps  xmm6, [ebx+8*eax+96]
  movaps  xmm7, [ebx+8*eax+112]
  movaps  [edx+8*eax+64], xmm4
  movaps  [edx+8*eax+80], xmm5
  movaps  [edx+8*eax+96], xmm6
  movaps  [edx+8*eax+112], xmm7
  add     eax, 16
  js      @SmallAlignedLoop
  jmp     @Remainder

@SmallUnaligned:               {Source Not 16-Byte Aligned}
@SmallUnalignedLoop:
  movups  xmm0, [ebx+8*eax]
  movups  xmm1, [ebx+8*eax+16]
  movups  xmm2, [ebx+8*eax+32]
  movups  xmm3, [ebx+8*eax+48]
  movaps  [edx+8*eax], xmm0
  movaps  [edx+8*eax+16], xmm1
  movaps  [edx+8*eax+32], xmm2
  movaps  [edx+8*eax+48], xmm3
  movups  xmm4, [ebx+8*eax+64]
  movups  xmm5, [ebx+8*eax+80]
  movups  xmm6, [ebx+8*eax+96]
  movups  xmm7, [ebx+8*eax+112]
  movaps  [edx+8*eax+64], xmm4
  movaps  [edx+8*eax+80], xmm5
  movaps  [edx+8*eax+96], xmm6
  movaps  [edx+8*eax+112], xmm7
  add     eax, 16
  js      @SmallUnalignedLoop
  jmp     @Remainder

@Large:
  test    ebx, 15              {Check if Both Source/Dest Aligned}
  jnz     @LargeUnaligned
@LargeAligned:                 {Both Source and Dest 16-Byte Aligned}
@LargeAlignedLoop:
  prefetchnta [ebx+8*eax+Prefetch]
  prefetchnta [ebx+8*eax+Prefetch+64]
  movaps  xmm0, [ebx+8*eax]
  movaps  xmm1, [ebx+8*eax+16]
  movaps  xmm2, [ebx+8*eax+32]
  movaps  xmm3, [ebx+8*eax+48]
  movntps [edx+8*eax], xmm0
  movntps [edx+8*eax+16], xmm1
  movntps [edx+8*eax+32], xmm2
  movntps [edx+8*eax+48], xmm3
  movaps  xmm4, [ebx+8*eax+64]
  movaps  xmm5, [ebx+8*eax+80]
  movaps  xmm6, [ebx+8*eax+96]
  movaps  xmm7, [ebx+8*eax+112]
  movntps [edx+8*eax+64], xmm4
  movntps [edx+8*eax+80], xmm5
  movntps [edx+8*eax+96], xmm6
  movntps [edx+8*eax+112], xmm7
  add     eax, 16
  js      @LargeAlignedLoop
  sfence
  jmp     @Remainder

@LargeUnaligned:              {Source Not 16-Byte Aligned}
@LargeUnalignedLoop:
  prefetchnta [ebx+8*eax+Prefetch]
  prefetchnta [ebx+8*eax+Prefetch+64]
  movups  xmm0, [ebx+8*eax]
  movups  xmm1, [ebx+8*eax+16]
  movups  xmm2, [ebx+8*eax+32]
  movups  xmm3, [ebx+8*eax+48]
  movntps [edx+8*eax], xmm0
  movntps [edx+8*eax+16], xmm1
  movntps [edx+8*eax+32], xmm2
  movntps [edx+8*eax+48], xmm3
  movups  xmm4, [ebx+8*eax+64]
  movups  xmm5, [ebx+8*eax+80]
  movups  xmm6, [ebx+8*eax+96]
  movups  xmm7, [ebx+8*eax+112]
  movntps [edx+8*eax+64], xmm4
  movntps [edx+8*eax+80], xmm5
  movntps [edx+8*eax+96], xmm6
  movntps [edx+8*eax+112], xmm7
  add     eax, 16
  js      @LargeUnalignedLoop
  sfence

@Remainder:
  and     ecx, $7F {ECX = Remainder (0..112 - Multiple of 16)}
  jz      @Done
  add     ebx, ecx
  add     edx, ecx
  neg     ecx
@RemainderLoop:
  movups  xmm0, [ebx+ecx]
  movaps  [edx+ecx], xmm0
  add     ecx, 16
  jnz     @RemainderLoop
@Done:
  pop     ebx
end;

{****************************************************************************}
{Move ECX Bytes from EAX to EDX, where EAX > EDX and ECX > 36 (SMALLMOVESIZE)}
procedure ALForwards_SSE;
const
  LARGESIZE = 2048;
asm
  cmp     ecx, LARGESIZE
  jge     @FwdLargeMove
  cmp     ecx, CALMOVE_SMALLMOVESIZE+32
  movups  xmm0, [eax]
  jg      @FwdMoveSSE
  movups  xmm1, [eax+16]
  movups  [edx], xmm0
  movups  [edx+16], xmm1
  add     eax, ecx
  add     edx, ecx
  sub     ecx, 32
  jmp     ALSmallForwardMove
@FwdMoveSSE:
  push    ebx
  mov     ebx, edx
  {Align Writes}
  add     eax, ecx
  add     ecx, edx
  add     edx, 15
  and     edx, -16
  sub     ecx, edx
  add     edx, ecx
  {Now Aligned}
  sub     ecx, 32
  neg     ecx
@FwdLoopSSE:
  movups  xmm1, [eax+ecx-32]
  movups  xmm2, [eax+ecx-16]
  movaps  [edx+ecx-32], xmm1
  movaps  [edx+ecx-16], xmm2
  add     ecx, 32
  jle     @FwdLoopSSE
  movups  [ebx], xmm0 {First 16 Bytes}
  neg     ecx
  add     ecx, 32
  pop     ebx
  jmp     ALSmallForwardMove
@FwdLargeMove:
  push    ebx
  mov     ebx, ecx
  test    edx, 15
  jz      @FwdLargeAligned
  {16 byte Align Destination}
  mov     ecx, edx
  add     ecx, 15
  and     ecx, -16
  sub     ecx, edx
  add     eax, ecx
  add     edx, ecx
  sub     ebx, ecx
  {Destination now 16 Byte Aligned}
  call    ALSmallForwardMove
  mov     ecx, ebx
@FwdLargeAligned:
  and     ecx, -16
  sub     ebx, ecx {EBX = Remainder}
  push    edx
  push    eax
  push    ecx
  call    ALAlignedFwdMoveSSE
  pop     ecx
  pop     eax
  pop     edx
  add     ecx, ebx
  add     eax, ecx
  add     edx, ecx
  mov     ecx, ebx
  pop     ebx
  jmp     ALSmallForwardMove
end;

{****************************************************************************}
{Move ECX Bytes from EAX to EDX, where EAX < EDX and ECX > 36 (SMALLMOVESIZE)}
procedure ALBackwards_SSE;
asm
  cmp     ecx, CALMOVE_SMALLMOVESIZE+32
  jg      @BwdMoveSSE
  sub     ecx, 32
  movups  xmm1, [eax+ecx]
  movups  xmm2, [eax+ecx+16]
  movups  [edx+ecx], xmm1
  movups  [edx+ecx+16], xmm2
  jmp     ALSmallBackwardMove
@BwdMoveSSE:
  push    ebx
  movups  xmm0, [eax+ecx-16] {Last 16 Bytes}
  {Align Writes}
  lea     ebx, [edx+ecx]
  and     ebx, 15
  sub     ecx, ebx
  add     ebx, ecx
  {Now Aligned}
  sub     ecx, 32
@BwdLoop:
  movups  xmm1, [eax+ecx]
  movups  xmm2, [eax+ecx+16]
  movaps  [edx+ecx], xmm1
  movaps  [edx+ecx+16], xmm2
  sub     ecx, 32
  jge     @BwdLoop
  movups  [edx+ebx-16], xmm0  {Last 16 Bytes}
  add     ecx, 32
  pop     ebx
  jmp     ALSmallBackwardMove
end;

{************************************}
{Move using IA32 Instruction Set Only}
procedure ALMove_IA32(const Source; var Dest; Count: Integer);
asm
  cmp     ecx, CALMOVE_SMALLMOVESIZE
  ja      @Large {Count > SMALLMOVESIZE or Count < 0}
  cmp     eax, edx
  jbe     @SmallCheck
  add     eax, ecx
  add     edx, ecx
  jmp     ALSmallForwardMove
@SmallCheck:
  jne     ALSmallBackwardMove
  ret {For Compatibility with Delphi's move for Source = Dest}
@Large:
  jng     @Done {For Compatibility with Delphi's move for Count < 0}
  cmp     eax, edx
  ja      ALForwards_IA32
  je      @Done {For Compatibility with Delphi's move for Source = Dest}
  sub     edx, ecx
  cmp     eax, edx
  lea     edx, [edx+ecx]
  jna     ALForwards_IA32
  jmp     ALBackwards_IA32 {Source/Dest Overlap}
@Done:
end;

{******************************}
{Move using MMX Instruction Set}
procedure ALMove_MMX(const Source; var Dest; Count: Integer);
asm
  cmp     ecx, CALMOVE_SMALLMOVESIZE
  ja      @Large {Count > SMALLMOVESIZE or Count < 0}
  cmp     eax, edx
  jbe     @SmallCheck
  add     eax, ecx
  add     edx, ecx
  jmp     ALSmallForwardMove
@SmallCheck:
  jne     ALSmallBackwardMove
  ret {For Compatibility with Delphi's move for Source = Dest}
@Large:
  jng     @Done {For Compatibility with Delphi's move for Count < 0}
  cmp     eax, edx
  ja      ALForwards_MMX
  je      @Done {For Compatibility with Delphi's move for Source = Dest}
  sub     edx, ecx
  cmp     eax, edx
  lea     edx, [edx+ecx]
  jna     ALForwards_MMX
  jmp     ALBackwards_MMX {Source/Dest Overlap}
@Done:
end;

{******************************}
{Move using SSE Instruction Set}
procedure ALMove_SSE(const Source; var Dest; Count: Integer);
asm
  cmp     ecx, CALMOVE_SMALLMOVESIZE
  ja      @Large {Count > SMALLMOVESIZE or Count < 0}
  cmp     eax, edx
  jbe     @SmallCheck
  add     eax, ecx
  add     edx, ecx
  jmp     ALSmallForwardMove
@SmallCheck:
  jne     ALSmallBackwardMove
  ret {For Compatibility with Delphi's move for Source = Dest}
@Large:
  jng     @Done {For Compatibility with Delphi's move for Count < 0}
  cmp     eax, edx
  ja      ALForwards_SSE
  je      @Done {For Compatibility with Delphi's move for Source = Dest}
  sub     edx, ecx
  cmp     eax, edx
  lea     edx, [edx+ecx]
  jna     ALForwards_SSE
  jmp     ALBackwards_SSE {Source/Dest Overlap}
@Done:
end;

{**********************************}
{Called Once by Unit Initialisation}
procedure ALInitFastMovProc;
Var aCpuInfo: TALCpuinfo;
begin
  aCpuInfo := AlGetCpuInfo;

  if (isSSE in aCpuInfo.InstructionSupport)      then ALMove := AlMove_SSE  {Processor Supports SSE}
  else if (isMMX in aCpuInfo.InstructionSupport) then ALMove := AlMove_MMX  {Processor Supports MMX}
  else ALMove := ALMove_IA32;                                               {Processor does not Support MMX or SSE}
end;




////////////////////////////////////////////////////////////////////////
//////////ALPos from John O'Harrow (john@almcrest.demon.co.uk)//////////
////////////////////////////////////////////////////////////////////////

{****************************************************************************}
function ALPos_IA32(const SubStr: AnsiString; const Str: AnsiString): Integer;
asm
  test      eax, eax
  jz        @NotFoundExit    {Exit if SubStr = ''}
  test      edx, edx
  jz        @NotFound        {Exit if Str = ''}
  mov       ecx, [edx-4]     {Length(Str)}
  cmp       [eax-4], 1       {Length SubStr = 1?}
  je        @SingleChar      {Yes - Exit via CharPos}
  jl        @NotFound        {Exit if Length(SubStr) < 1}
  sub       ecx, [eax-4]     {Subtract Length(SubStr), -ve handled by
CharPos}
  add       ecx, 1           {Number of Chars to Check for 1st Char}
  push      esi              {Save Registers}
  push      edi
  push      ebx
  push      ebp
  mov       ebx, [eax]       {BL = 1st Char of SubStr}
  mov       esi, eax         {Start Address of SubStr}
  mov       edi, ecx         {Initial Remainder Count}
  mov       ebp, edx         {Start Address of Str}
@StrLoop:
  mov       eax, ebx         {AL  = 1st char of SubStr for next Search}
  mov       ecx, edi         {Remaining Length}
  push      edx              {Save Start Position}
  call      @CharPos         {Search for 1st Character}
  pop       edx              {Restore Start Position}
  jz        @StrExit         {Exit with Zero Result if 1st Char Not Found}
  mov       ecx, [esi-4]     {Length SubStr}
  add       edx, eax         {Update Start Position for Next Loop}
  sub       edi, eax         {Update Remaining Length for Next Loop}
  sub       ecx, 1           {Remaining Characters to Compare}
@StrCheck:
  mov       al, [edx+ecx-1]  {Compare Next Char of SubStr and Str}
  cmp       al, [esi+ecx]
  jne       @StrLoop         {Different - Return to First Character Search}
  sub       ecx, 1
  jg        @StrCheck        {Check each Remaining Character}
  mov       eax, edx         {All Characters Matched - Calculate Result}
  sub       eax, ebp
@StrExit:
  pop       ebp              {Restore Registers}
  pop       ebx
  pop       edi
  pop       esi
  ret
@NotFound:
  xor       eax, eax         {Return 0}
@NotFoundExit:
  ret
@SingleChar:
  mov       al, [eax]        {Search Character}
{Return Position of Character AL within a String of Length ECX starting}
{at Address EDX.  If Found, Return Index in EAX and Clear Zero Flag,   }
{otherwise Return 0 in EAX and Set Zero Flag.  Changes EAX, ECX and EDX}
@CharPos:
  push      ecx              {Save Length}
  neg       ecx
  cmp       ecx, -4
  jle       @NotSmall        {Length >= 4}
  or        ecx, ecx
  jge       @CharNotFound    {Exit if Length <= 0}
  cmp       al, [edx]        {Check 1st Char}
  je        @Found
  add       ecx, 1
  jz        @CharNotFound
  cmp       al, [edx+1]      {Check 2nd Char}
  je        @Found
  add       ecx, 1
  jz        @CharNotFound
  cmp       al, [edx+2]      {Check 3rd Char}
  je        @Found
  jmp       @CharNotFound
@NotSmall:
  sub       edx, ecx         {End of String}
@Loop:
  cmp       al, [edx+ecx]    {Compare Next 4 Characters}
  je        @Found
  cmp       al, [edx+ecx+1]
  je        @Found2
  cmp       al, [edx+ecx+2]
  je        @Found3
  cmp       al, [edx+ecx+3]
  je        @Found4
  add       ecx, 4           {Next Character Position}
  and       ecx, -4          {Prevent Read Past Last Character}
  jnz       @Loop            {Loop until all Characters Compared}
@CharNotFound:
  pop       ecx              {Restore Stack}
  xor       eax, eax         {Set Result to 0 and Set Zero Flag}
  ret                        {Finished}
@Found4:
  add       ecx, 1
@Found3:
  add       ecx, 1
@Found2:
  add       ecx, 1
@Found:
  add       ecx, 1
  pop       eax
  add       eax, ecx         {Set Result and Clear Zero Flag}
end;

{***************************************************************************}
function ALPos_MMX(const SubStr: AnsiString; const Str: AnsiString): Integer;
asm
  test      eax, eax
  jz        @NotFoundExit    {Exit if SurStr = ''}
  test      edx, edx
  jz        @NotFound        {Exit if Str = ''}
  mov       ecx, [edx-4]     {Length(Str)}
  cmp       [eax-4], 1       {Length SubStr = 1?}
  je        @SingleChar      {Yes - Exit via CharPos}
  jl        @NotFound        {Exit if Length(SubStr) < 1}
  sub       ecx, [eax-4]     {Subtract Length(SubStr), -ve handled by
CharPos}
  add       ecx, 1           {Number of Chars to Check for 1st Char}
  push      esi              {Save Registers}
  push      edi
  push      ebx
  push      ebp
  mov       esi, eax         {Start Address of SubStr}
  mov       edi, ecx         {Initial Remainder Count}
  mov       eax, [eax]       {AL = 1st Char of SubStr}
  mov       ebp, edx         {Start Address of Str}
  mov       ebx, eax         {Maintain 1st Search Char in BL}
@StrLoop:
  mov       eax, ebx         {AL  = 1st char of SubStr}
  mov       ecx, edi         {Remaining Length}
  push      edx              {Save Start Position}
  call      @CharPos         {Search for 1st Character}
  pop       edx              {Restore Start Position}
  test      eax, eax         {Result = 0?}
  jz        @StrExit         {Exit if 1st Character Not Found}
  mov       ecx, [esi-4]     {Length SubStr}
  add       edx, eax         {Update Start Position for Next Loop}
  sub       edi, eax         {Update Remaining Length for Next Loop}
  sub       ecx, 1           {Remaining Characters to Compare}
@StrCheck:
  mov       al, [edx+ecx-1]  {Compare Next Char of SubStr and Str}
  cmp       al, [esi+ecx]
  jne       @StrLoop         {Different - Return to First Character Search}
  sub       ecx, 1
  jnz       @StrCheck        {Check each Remaining Character}
  mov       eax, edx         {All Characters Matched - Calculate Result}
  sub       eax, ebp
@StrExit:
  pop       ebp              {Restore Registers}
  pop       ebx
  pop       edi
  pop       esi
  ret
@NotFound:
  xor       eax, eax         {Return 0}
@NotFoundExit:
  ret
@SingleChar:
  mov       al, [eax]        {Search Character}
@CharPos:
  CMP       ECX, 8
  JG        @@NotSmall
@@Small:
  or        ecx, ecx
  jle       @@NotFound       {Exit if Length <= 0}
  CMP       AL, [EDX]
  JZ        @Found1
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+1]
  JZ        @Found2
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+2]
  JZ        @Found3
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+3]
  JZ        @Found4
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+4]
  JZ        @Found5
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+5]
  JZ        @Found6
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+6]
  JZ        @Found7
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+7]
  JZ        @Found8
@@NotFound:
  XOR       EAX, EAX
  RET
@Found1:
  MOV       EAX, 1
  RET
@Found2:
  MOV       EAX, 2
  RET
@Found3:
  MOV       EAX, 3
  RET
@Found4:
  MOV       EAX, 4
  RET
@Found5:
  MOV       EAX, 5
  RET
@Found6:
  MOV       EAX, 6
  RET
@Found7:
  MOV       EAX, 7
  RET
@Found8:
  MOV       EAX, 8
  RET

@@NotSmall:                  {Length(Str) > 8}
  MOV       AH, AL
  ADD       EDX, ECX
  MOVD      MM0, EAX
  PUNPCKLWD MM0, MM0
  PUNPCKLDQ MM0, MM0
  PUSH      ECX              {Save Length}
  NEG       ECX
@@First8:
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
  JGE       @@Last8
@@Align:                     {Align to Previous 8 Byte Boundary}
  LEA       EAX, [EDX+ECX]
  AND       EAX, 7           {EAX -> 0 or 4}
  SUB       ECX, EAX
@@Loop:
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$IFNDEF NoUnroll}
  JGE       @@Last8
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$ENDIF}
  JL        @@Loop
@@Last8:
  MOVQ      MM1, [EDX-8]     {Position for Last 8 Used Characters}
  POP       EDX              {Original Length}
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched2       {Exit on Match at any Position}
  EMMS
  RET                        {Finished - Not Found}
@@Matched:                   {Set Result from 1st Match in EDX}
  POP       EDX              {Original Length}
  ADD       EDX, ECX
@@Matched2:
  EMMS
  SUB       EDX, 8           {Adjust for Extra ADD ECX,8 in Loop}
  TEST      AL, AL
  JNZ       @@MatchDone      {Match at Position 1 or 2}
  TEST      AH, AH
  JNZ       @@Match1         {Match at Position 3 or 4}
  SHR       EAX, 16
  TEST      AL, AL
  JNZ       @@Match2         {Match at Position 5 or 6}
  SHR       EAX, 8
  ADD       EDX, 6
  JMP       @@MatchDone
@@Match2:
  ADD       EDX, 4
  JMP       @@MatchDone
@@Match1:
  SHR       EAX, 8           {AL <- AH}
  ADD       EDX, 2
@@MatchDone:
  XOR       EAX, 2
  AND       EAX, 3           {EAX <- 1 or 2}
  ADD       EAX, EDX

end;

{***************************************************************************}
function ALPos_SSE(const SubStr: AnsiString; const Str: AnsiString): Integer;
asm
  test      eax, eax
  jz        @NotFoundExit    {Exit if SurStr = ''}
  test      edx, edx
  jz        @NotFound        {Exit if Str = ''}
  mov       ecx, [edx-4]     {Length(Str)}
  cmp       [eax-4], 1       {Length SubStr = 1?}
  je        @SingleChar      {Yes - Exit via CharPos}
  jl        @NotFound        {Exit if Length(SubStr) < 1}
  sub       ecx, [eax-4]     {Subtract Length(SubStr), -ve handled by
CharPos}
  add       ecx, 1           {Number of Chars to Check for 1st Char}
  push      esi              {Save Registers}
  push      edi
  push      ebx
  push      ebp
  mov       esi, eax         {Start Address of SubStr}
  mov       edi, ecx         {Initial Remainder Count}
  mov       eax, [eax]       {AL = 1st Char of SubStr}
  mov       ebp, edx         {Start Address of Str}
  mov       ebx, eax         {Maintain 1st Search Char in BL}
@StrLoop:
  mov       eax, ebx         {AL  = 1st char of SubStr}
  mov       ecx, edi         {Remaining Length}
  push      edx              {Save Start Position}
  call      @CharPos         {Search for 1st Character}
  pop       edx              {Restore Start Position}
  test      eax, eax         {Result = 0?}
  jz        @StrExit         {Exit if 1st Character Not Found}
  mov       ecx, [esi-4]     {Length SubStr}
  add       edx, eax         {Update Start Position for Next Loop}
  sub       edi, eax         {Update Remaining Length for Next Loop}
  sub       ecx, 1           {Remaining Characters to Compare}
@StrCheck:
  mov       al, [edx+ecx-1]  {Compare Next Char of SubStr and Str}
  cmp       al, [esi+ecx]
  jne       @StrLoop         {Different - Return to First Character Search}
  sub       ecx, 1
  jnz       @StrCheck        {Check each Remaining Character}
  mov       eax, edx         {All Characters Matched - Calculate Result}
  sub       eax, ebp
@StrExit:
  pop       ebp              {Restore Registers}
  pop       ebx
  pop       edi
  pop       esi
  ret
@NotFound:
  xor       eax, eax         {Return 0}
@NotFoundExit:
  ret
@SingleChar:
  mov       al, [eax]        {Search Character}
@CharPos:
  CMP       ECX, 8
  JG        @@NotSmall
@@Small:
  or        ecx, ecx
  jle       @@NotFound       {Exit if Length <= 0}
  CMP       AL, [EDX]
  JZ        @Found1
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+1]
  JZ        @Found2
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+2]
  JZ        @Found3
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+3]
  JZ        @Found4
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+4]
  JZ        @Found5
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+5]
  JZ        @Found6
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+6]
  JZ        @Found7
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+7]
  JZ        @Found8
@@NotFound:
  XOR       EAX, EAX
  RET
@Found1:
  MOV       EAX, 1
  RET
@Found2:
  MOV       EAX, 2
  RET
@Found3:
  MOV       EAX, 3
  RET
@Found4:
  MOV       EAX, 4
  RET
@Found5:
  MOV       EAX, 5
  RET
@Found6:
  MOV       EAX, 6
  RET
@Found7:
  MOV       EAX, 7
  RET
@Found8:
  MOV       EAX, 8
  RET
@@NotSmall:
  MOV       AH, AL
  ADD       EDX, ECX
  MOVD      MM0, EAX
  PSHUFW    MM0, MM0, 0
  PUSH      ECX
  NEG       ECX
@@First8:
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare Next 8 Bytes}
  PMOVMSKB  EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
  JGE       @@Last8
@@Align:
  LEA       EAX, [EDX+ECX]
  AND       EAX, 7
  SUB       ECX, EAX
@@Loop:                      {Loop Unrolled 2X}
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare Next 8 Bytes}
  PMOVMSKB  EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$IFNDEF NoUnroll}
  JGE       @@Last8
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare Next 8 Bytes}
  PMOVMSKB  EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$ENDIF}
  JL        @@loop
@@Last8:
  PCMPEQB   MM0, [EDX-8]
  POP       ECX              {Original Length}
  PMOVMSKB  EAX, MM0
  TEST      EAX, EAX
  JNZ       @@Matched2
  EMMS
  RET                        {Finished}
@@Matched:                   {Set Result from 1st Match in EcX}
  POP       EDX              {Original Length}
  ADD       ECX, EDX
@@Matched2:
  EMMS
  BSF       EDX, EAX
  LEA       EAX, [EDX+ECX-7]
end;

{****************************************************************************}
function ALPos_SSE2(const SubStr: AnsiString; const Str: AnsiString): Integer;
asm
  test      eax, eax
  jz        @NotFoundExit    {Exit if SurStr = ''}
  test      edx, edx
  jz        @NotFound        {Exit if Str = ''}
  mov       ecx, [edx-4]     {Length(Str)}
  cmp       [eax-4], 1       {Length SubStr = 1?}
  je        @SingleChar      {Yes - Exit via CharPos}
  jl        @NotFound        {Exit if Length(SubStr) < 1}
  sub       ecx, [eax-4]     {Subtract Length(SubStr)}
  jl        @NotFound        {Exit if Length(SubStr) > Length(Str)}
  add       ecx, 1           {Number of Chars to Check for 1st Char}
  push      esi              {Save Registers}
  push      edi
  push      ebx
  push      ebp
  mov       esi, eax         {Start Address of SubStr}
  mov       edi, ecx         {Initial Remainder Count}
  mov       eax, [eax]       {AL = 1st Char of SubStr}
  mov       ebp, edx         {Start Address of Str}
  mov       ebx, eax         {Maintain 1st Search Char in BL}
@StrLoop:
  mov       eax, ebx         {AL  = 1st char of SubStr}
  mov       ecx, edi         {Remaining Length}
  push      edx              {Save Start Position}
  call      @CharPos         {Search for 1st Character}
  pop       edx              {Restore Start Position}
  test      eax, eax         {Result = 0?}
  jz        @StrExit         {Exit if 1st Character Not Found}
  mov       ecx, [esi-4]     {Length SubStr}
  add       edx, eax         {Update Start Position for Next Loop}
  sub       edi, eax         {Update Remaining Length for Next Loop}
  sub       ecx, 1           {Remaining Characters to Compare}
@StrCheck:
  mov       al, [edx+ecx-1]  {Compare Next Char of SubStr and Str}
  cmp       al, [esi+ecx]
  jne       @StrLoop         {Different - Return to First Character Search}
  sub       ecx, 1
  jnz       @StrCheck        {Check each Remaining Character}
  mov       eax, edx         {All Characters Matched - Calculate Result}
  sub       eax, ebp
@StrExit:
  pop       ebp              {Restore Registers}
  pop       ebx
  pop       edi
  pop       esi
  ret
@NotFound:
  xor       eax, eax         {Return 0}
@NotFoundExit:
  ret
@SingleChar:
  mov       al, [eax]        {Search Character}
@CharPos:
  PUSH      EBX
  MOV       EBX, EAX
  CMP       ECX, 16
  JL        @@Small
@@NotSmall:
  MOV       AH, AL           {Fill each Byte of XMM1 with AL}
  MOVD      XMM1, EAX
  PSHUFLW   XMM1, XMM1, 0
  PSHUFD    XMM1, XMM1, 0
@@First16:
  MOVUPS    XMM0, [EDX]      {Unaligned}
  PCMPEQB   XMM0, XMM1       {Compare First 16 Characters}
  PMOVMSKB  EAX, XMM0
  TEST      EAX, EAX
  JNZ       @@FoundStart     {Exit on any Match}
  CMP       ECX, 32
  JL        @@Medium         {If Length(Str) < 32, Check Remainder}
@@Align:
  SUB       ECX, 16          {Align Block Reads}
  PUSH      ECX
  MOV       EAX, EDX
  NEG       EAX
  AND       EAX, 15
  ADD       EDX, ECX
  NEG       ECX
  ADD       ECX, EAX
@@Loop:
  MOVAPS    XMM0, [EDX+ECX]  {Aligned}
  PCMPEQB   XMM0, XMM1       {Compare Next 16 Characters}
  PMOVMSKB  EAX, XMM0
  TEST      EAX, EAX
  JNZ       @@Found          {Exit on any Match}
  ADD       ECX, 16
  JLE       @@Loop
@Remainder:
  POP       EAX              {Check Remaining Characters}
  ADD       EDX, 16
  ADD       EAX, ECX         {Count from Last Loop End Position}
  JMP       DWORD PTR [@@JumpTable2-ECX*4]

@@NullString:
  XOR       EAX, EAX         {Result = 0}
  RET

@@FoundStart:
  BSF       EAX, EAX         {Get Set Bit}
  POP       EBX
  ADD       EAX, 1           {Set Result}
  RET

@@Found:
  POP       EDX
  BSF       EAX, EAX         {Get Set Bit}
  ADD       EDX, ECX
  POP       EBX
  LEA       EAX, [EAX+EDX+1] {Set Result}
  RET

@@Medium:
  ADD       EDX, ECX         {End of String}
  MOV       EAX, 16          {Count from 16}
  JMP       DWORD PTR [@@JumpTable1-64-ECX*4]

@@Small:
  ADD       EDX, ECX         {End of String}
  XOR       EAX, EAX         {Count from 0}
  JMP       DWORD PTR [@@JumpTable1-ECX*4]

  nop; nop; nop              {Aligb Jump Tables}

@@JumpTable1:
  DD        @@NotFound, @@01, @@02, @@03, @@04, @@05, @@06, @@07
  DD        @@08, @@09, @@10, @@11, @@12, @@13, @@14, @@15, @@16

@@JumpTable2:
  DD        @@16, @@15, @@14, @@13, @@12, @@11, @@10, @@09, @@08
  DD        @@07, @@06, @@05, @@04, @@03, @@02, @@01, @@NotFound

@@16:
  ADD       EAX, 1
  CMP       BL, [EDX-16]
  JE        @@Done
@@15:
  ADD       EAX, 1
  CMP       BL, [EDX-15]
  JE        @@Done
@@14:
  ADD       EAX, 1
  CMP       BL, [EDX-14]
  JE        @@Done
@@13:
  ADD       EAX, 1
  CMP       BL, [EDX-13]
  JE        @@Done
@@12:
  ADD       EAX, 1
  CMP       BL, [EDX-12]
  JE        @@Done
@@11:
  ADD       EAX, 1
  CMP       BL, [EDX-11]
  JE        @@Done
@@10:
  ADD       EAX, 1
  CMP       BL, [EDX-10]
  JE        @@Done
@@09:
  ADD       EAX, 1
  CMP       BL, [EDX-9]
  JE        @@Done
@@08:
  ADD       EAX, 1
  CMP       BL, [EDX-8]
  JE        @@Done
@@07:
  ADD       EAX, 1
  CMP       BL, [EDX-7]
  JE        @@Done
@@06:
  ADD       EAX, 1
  CMP       BL, [EDX-6]
  JE        @@Done
@@05:
  ADD       EAX, 1
  CMP       BL, [EDX-5]
  JE        @@Done
@@04:
  ADD       EAX, 1
  CMP       BL, [EDX-4]
  JE        @@Done
@@03:
  ADD       EAX, 1
  CMP       BL, [EDX-3]
  JE        @@Done
@@02:
  ADD       EAX, 1
  CMP       BL, [EDX-2]
  JE        @@Done
@@01:
  ADD       EAX, 1
  CMP       BL, [EDX-1]
  JE        @@Done
@@NotFound:
  XOR       EAX, EAX
@@Done:
  POP       EBX
end;

{**********************************}
{Called Once by Unit Initialisation}
procedure ALInitFastPosFunct;
Var aCpuInfo: TALCpuinfo;
begin
  aCpuInfo := AlGetCpuInfo;

  if (isSSE2 in aCpuInfo.InstructionSupport)     then ALPos := AlPos_SSE2 {Processor Supports SSE}
  else if (isSSE in aCpuInfo.InstructionSupport) then ALPos := AlPos_SSE  {Processor Supports SSE}
  else if (isMMX in aCpuInfo.InstructionSupport) then ALPos := AlPos_MMX  {Processor Supports MMX}
  else ALPos := ALPos_IA32;                                               {Processor does not Support MMX or SSE}
end;




/////////////////////////////////////////////////////////////////////////////////////
//////////ALCharPos from FastCode John O'Harrow (john@almcrest.demon.co.uk)//////////
/////////////////////////////////////////////////////////////////////////////////////

{****************************************************************}
function ALCharPos_IA32(Ch: Char; const Str: AnsiString): Integer;
asm
  test edx, edx         {Str = NIL?}
  jz   @@NotFoundExit   {Yes - Jump}
  mov  ecx, [edx-4]     {ECX = Length(Str)}
  push ebx
  mov  ebx,ecx          {Save Length(Str)}
  neg  ecx
  jz   @@CharNotFound   {Exit if Length = 0}
  cmp  ecx, -8          {Length(Str) >= 8}
  jle  @@NotSmall
  cmp  al, [edx]        {Check 1st Char}
  je   @@Found
  inc  ecx
  jz   @@CharNotFound
  cmp  al, [edx+1]      {Check 2nd Char}
  je   @@Found
  inc  ecx
  jz   @@CharNotFound
  cmp  al, [edx+2]      {Check 3rd Char}
  je   @@Found
  inc  ecx
  jz   @@CharNotFound
  cmp  al, [edx+3]      {Check 4th Char}
  je   @@Found
  inc  ecx
  jz   @@CharNotFound
  cmp  al, [edx+4]      {Check 5th Char}
  je   @@Found
  inc  ecx
  jz   @@CharNotFound
  cmp  al, [edx+5]      {Check 6th Char}
  je   @@Found
  inc  ecx
  jz   @@CharNotFound
  cmp  al, [edx+6]      {Check 7th Char}
  je   @@Found
@@CharNotFound:
  pop  ebx              {Restore Stack}
@@NotFoundExit:
  xor  eax, eax         {Set Result to 0}
  ret                   {Finished}
@@Found8:
  add  ecx, 7
  jmp  @@Found
@@Found7:
  add  ecx, 6
  jmp  @@Found
@@Found6:
  add  ecx, 5
  jmp  @@Found
@@Found5:
  add  ecx, 4
  jmp  @@Found
@@Found4:
  add  ecx, 3
  jmp  @@Found
@@Found3:
  add  ecx, 2
  jmp  @@Found
@@Found2:
  add  ecx, 1
@@Found:
  lea  eax, [ebx+ecx+1] {Set Result}
  pop  ebx
  ret                   {Finished}
@@NotSmall:
  sub  edx, ecx         {End of String}
@@Loop:
  cmp  al, [edx+ecx]    {Compare Next 8 Characters}
  je   @@Found
  cmp  al, [edx+ecx+1]
  je   @@Found2
  cmp  al, [edx+ecx+2]
  je   @@Found3
  cmp  al, [edx+ecx+3]
  je   @@Found4
  cmp  al, [edx+ecx+4]
  je   @@Found5
  cmp  al, [edx+ecx+5]
  je   @@Found6
  cmp  al, [edx+ecx+6]
  je   @@Found7
  cmp  al, [edx+ecx+7]
  je   @@Found8
  add  ecx, 8           {Next Character Position}
  and  ecx, -8          {Prevent Read Past End of String}
  jnz  @@Loop           {Loop until all Characters Compared}
  pop  ebx              {Restore Stack}
  xor  eax, eax         {Set Result to 0}
end;

{***************************************************************}
function ALCharPos_MMX(Ch: Char; const Str: AnsiString): Integer;
asm
  TEST      EDX, EDX         {Str = NIL?}
  JZ        @@NotFound       {Yes - Jump}
  MOV       ECX, [EDX-4]     {ECX = Length(Str)}
  CMP       ECX, 8
  JG        @@NotSmall
  TEST      ECX, ECX
  JZ        @@NotFound       {Exit if Length = 0}
@@Small:
  CMP       AL, [EDX]
  JZ        @Found1
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+1]
  JZ        @Found2
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+2]
  JZ        @Found3
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+3]
  JZ        @Found4
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+4]
  JZ        @Found5
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+5]
  JZ        @Found6
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+6]
  JZ        @Found7
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+7]
  JZ        @Found8
@@NotFound:
  XOR       EAX, EAX
  RET
@Found1:
  MOV       EAX, 1
  RET
@Found2:
  MOV       EAX, 2
  RET
@Found3:
  MOV       EAX, 3
  RET
@Found4:
  MOV       EAX, 4
  RET
@Found5:
  MOV       EAX, 5
  RET
@Found6:
  MOV       EAX, 6
  RET
@Found7:
  MOV       EAX, 7
  RET
@Found8:
  MOV       EAX, 8
  RET

@@NotSmall:                  {Length(Str) > 8}
  MOV       AH, AL
  ADD       EDX, ECX
  MOVD      MM0, EAX
  PUNPCKLWD MM0, MM0
  PUNPCKLDQ MM0, MM0
  PUSH      ECX              {Save Length}
  NEG       ECX
@@First8:
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
  JGE       @@Last8
@@Align:                     {Align to Previous 8 Byte Boundary}
  LEA       EAX, [EDX+ECX]
  AND       EAX, 7           {EAX -> 0 or 4}
  SUB       ECX, EAX
@@Loop:
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$IFNDEF NoUnroll}
  JGE       @@Last8
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$ENDIF}
  JL        @@Loop
@@Last8:
  MOVQ      MM1, [EDX-8]     {Position for Last 8 Used Characters}
  POP       EDX              {Original Length}
  PCMPEQB   MM1, MM0         {Compare All 8 Bytes}
  PACKSSWB  MM1, MM1         {Pack Result into 4 Bytes}
  MOVD      EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched2       {Exit on Match at any Position}
  EMMS
  RET                        {Finished - Not Found}
@@Matched:                   {Set Result from 1st Match in EDX}
  POP       EDX              {Original Length}
  ADD       EDX, ECX
@@Matched2:
  EMMS
  SUB       EDX, 8           {Adjust for Extra ADD ECX,8 in Loop}
  TEST      AL, AL
  JNZ       @@MatchDone      {Match at Position 1 or 2}
  TEST      AH, AH
  JNZ       @@Match1         {Match at Position 3 or 4}
  SHR       EAX, 16
  TEST      AL, AL
  JNZ       @@Match2         {Match at Position 5 or 6}
  SHR       EAX, 8
  ADD       EDX, 6
  JMP       @@MatchDone
@@Match2:
  ADD       EDX, 4
  JMP       @@MatchDone
@@Match1:
  SHR       EAX, 8           {AL <- AH}
  ADD       EDX, 2
@@MatchDone:
  XOR       EAX, 2
  AND       EAX, 3           {EAX <- 1 or 2}
  ADD       EAX, EDX
end;

{***************************************************************}
function ALCharPos_SSE(Ch: Char; const Str: AnsiString): Integer;
asm
  TEST      EDX, EDX         {Str = NIL?}
  JZ        @@NotFound       {Yes - Jump}
  MOV       ECX, [EDX-4]     {ECX = Length(Str)}
  CMP       ECX, 8
  JG        @@NotSmall
  TEST      ECX, ECX
  JZ        @@NotFound       {Exit if Length = 0}
@@Small:
  CMP       AL, [EDX]
  JZ        @Found1
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+1]
  JZ        @Found2
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+2]
  JZ        @Found3
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+3]
  JZ        @Found4
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+4]
  JZ        @Found5
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+5]
  JZ        @Found6
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+6]
  JZ        @Found7
  DEC       ECX
  JZ        @@NotFound
  CMP       AL, [EDX+7]
  JZ        @Found8
@@NotFound:
  XOR       EAX, EAX
  RET
@Found1:
  MOV       EAX, 1
  RET
@Found2:
  MOV       EAX, 2
  RET
@Found3:
  MOV       EAX, 3
  RET
@Found4:
  MOV       EAX, 4
  RET
@Found5:
  MOV       EAX, 5
  RET
@Found6:
  MOV       EAX, 6
  RET
@Found7:
  MOV       EAX, 7
  RET
@Found8:
  MOV       EAX, 8
  RET
@@NotSmall:
  MOV       AH, AL
  ADD       EDX, ECX
  MOVD      MM0, EAX
  PSHUFW    MM0, MM0, 0
  PUSH      ECX
  NEG       ECX
@@First8:
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare Next 8 Bytes}
  PMOVMSKB  EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
  JGE       @@Last8
@@Align:
  LEA       EAX, [EDX+ECX]
  AND       EAX, 7
  SUB       ECX, EAX
@@Loop:                      {Loop Unrolled 2X}
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare Next 8 Bytes}
  PMOVMSKB  EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$IFNDEF NoUnroll}
  JGE       @@Last8
  MOVQ      MM1, [EDX+ECX]
  ADD       ECX, 8
  PCMPEQB   MM1, MM0         {Compare Next 8 Bytes}
  PMOVMSKB  EAX, MM1
  TEST      EAX, EAX
  JNZ       @@Matched        {Exit on Match at any Position}
  CMP       ECX, -8          {Check if Next Loop would pass String End}
{$ENDIF}
  JL        @@loop
@@Last8:
  PCMPEQB   MM0, [EDX-8]
  POP       ECX              {Original Length}
  PMOVMSKB  EAX, MM0
  TEST      EAX, EAX
  JNZ       @@Matched2
  EMMS
  RET                        {Finished}
@@Matched:                   {Set Result from 1st Match in EcX}
  POP       EDX              {Original Length}
  ADD       ECX, EDX
@@Matched2:
  EMMS
  BSF       EDX, EAX
  LEA       EAX, [EDX+ECX-7]
end;

{****************************************************************}
function ALCharPos_SSE2(Ch: Char; const Str: AnsiString): Integer;
asm
  test      edx, edx
  jz        @@NullString
  mov       ecx, [edx-4]
  push      ebx
  mov       ebx, eax
  cmp       ecx, 16
  jl        @@Small
@@NotSmall:
  mov       ah, al           {Fill each Byte of XMM1 with AL}
  movd      xmm1, eax
  pshuflw   xmm1, xmm1, 0
  pshufd    xmm1, xmm1, 0
@@First16:
  movups    xmm0, [edx]      {Unaligned}
  pcmpeqb   xmm0, xmm1       {Compare First 16 Characters}
  pmovmskb  eax, xmm0
  test      eax, eax
  jnz       @@FoundStart     {Exit on any Match}
  cmp       ecx, 32
  jl        @@Medium         {If Length(Str) < 32, Check Remainder}
@@Align:
  sub       ecx, 16          {Align Block Reads}
  push      ecx
  mov       eax, edx
  neg       eax
  and       eax, 15
  add       edx, ecx
  neg       ecx
  add       ecx, eax
@@Loop:
  movaps    xmm0, [edx+ecx]  {Aligned}
  pcmpeqb   xmm0, xmm1       {Compare Next 16 Characters}
  pmovmskb  eax, xmm0
  test      eax, eax
  jnz       @@Found          {Exit on any Match}
  add       ecx, 16
  jle       @@Loop
  pop       eax              {Check Remaining Characters}
  add       edx, 16
  add       eax, ecx         {Count from Last Loop End Position}
  jmp       dword ptr [@@JumpTable2-ecx*4]
  nop
  nop
@@NullString:
  xor       eax, eax         {Result = 0}
  ret
  nop
@@FoundStart:
  bsf       eax, eax         {Get Set Bit}
  pop       ebx
  inc       eax              {Set Result}
  ret
  nop
  nop
@@Found:
  pop       edx
  bsf       eax, eax         {Get Set Bit}
  add       edx, ecx
  pop       ebx
  lea       eax, [eax+edx+1] {Set Result}
  ret
@@Medium:
  add       edx, ecx         {End of String}
  mov       eax, 16          {Count from 16}
  jmp       dword ptr [@@JumpTable1-64-ecx*4]
  nop
  nop
@@Small:
  add       edx, ecx         {End of String}
  xor       eax, eax         {Count from 0}
  jmp       dword ptr [@@JumpTable1-ecx*4]
  nop
@@JumpTable1:
  dd        @@NotFound, @@01, @@02, @@03, @@04, @@05, @@06, @@07
  dd        @@08, @@09, @@10, @@11, @@12, @@13, @@14, @@15, @@16
@@JumpTable2:
  dd        @@16, @@15, @@14, @@13, @@12, @@11, @@10, @@09, @@08
  dd        @@07, @@06, @@05, @@04, @@03, @@02, @@01, @@NotFound
@@16:
  add       eax, 1
  cmp       bl, [edx-16]
  je        @@Done
@@15:
  add       eax, 1
  cmp       bl, [edx-15]
  je        @@Done
@@14:
  add       eax, 1
  cmp       bl, [edx-14]
  je        @@Done
@@13:
  add       eax, 1
  cmp       bl, [edx-13]
  je        @@Done
@@12:
  add       eax, 1
  cmp       bl, [edx-12]
  je        @@Done
@@11:
  add       eax, 1
  cmp       bl, [edx-11]
  je        @@Done
@@10:
  add       eax, 1
  cmp       bl, [edx-10]
  je        @@Done
@@09:
  add       eax, 1
  cmp       bl, [edx-9]
  je        @@Done
@@08:
  add       eax, 1
  cmp       bl, [edx-8]
  je        @@Done
@@07:
  add       eax, 1
  cmp       bl, [edx-7]
  je        @@Done
@@06:
  add       eax, 1
  cmp       bl, [edx-6]
  je        @@Done
@@05:
  add       eax, 1
  cmp       bl, [edx-5]
  je        @@Done
@@04:
  add       eax, 1
  cmp       bl, [edx-4]
  je        @@Done
@@03:
  add       eax, 1
  cmp       bl, [edx-3]
  je        @@Done
@@02:
  add       eax, 1
  cmp       bl, [edx-2]
  je        @@Done
@@01:
  add       eax, 1
  cmp       bl, [edx-1]
  je        @@Done
@@NotFound:
  xor       eax, eax
  pop       ebx
  ret
@@Done:
  pop       ebx
end;


{**********************************}
{Called Once by Unit Initialisation}
procedure ALInitCharPosFunct;
Var aCpuinfo: TALCPUInfo;
begin
  aCpuInfo := AlGetCpuInfo;

  if (isSSE2 in aCpuInfo.InstructionSupport)     then ALCharPos := AlCharPos_SSE2 {Processor Supports SSE}
  else if (isSSE in aCpuInfo.InstructionSupport) then ALCharPos := AlCharPos_SSE  {Processor Supports SSE}
  else if (isMMX in aCpuInfo.InstructionSupport) then ALCharPos := AlCharPos_MMX  {Processor Supports MMX}
  else ALCharPos := ALCharPos_IA32;                                               {Processor does not Support MMX or SSE}
end;




///////////////////////////////////////////////////////////////////////////////////////
//////////ALCharPosEX from FastCode John O'Harrow (john@almcrest.demon.co.uk)//////////
///////////////////////////////////////////////////////////////////////////////////////

{****************************************}
{Can Read DWORD containing NULL Charatcer}
function ALCharPosEX(const SearchCharacter: Char;
                     const SourceString: AnsiString;
                     Occurrence: Integer;
                     StartPos: Integer): Integer;
asm
  test   edx, edx
  jz     @@NotFoundExit        {Exit if SourceString = ''}
  cmp    ecx, 1
  jl     @@NotFoundExit        {Exit if Occurence < 1}
  mov    ebp, StartPos         {Safe since EBP automatically saved}
  sub    ebp, 1
  jl     @@NotFoundExit        {Exit if StartPos < 1}
  push   ebx
  add    ebp, edx
  mov    ebx, [edx-4]
  add    ebx, edx
  sub    ebp, ebx
  jge    @@NotFound            {Traps Zero Length Non-Nil String}
@@Loop:
  cmp    al, [ebx+ebp]
  je     @@Check1
@@Next:
  cmp    al, [ebx+ebp+1]
  je     @@Check2
@@Next2:
  cmp    al, [ebx+ebp+2]
  je     @@Check3
@@Next3:
  cmp    al, [ebx+ebp+3]
  je     @@Check4
@@Next4:
  add    ebp, 4
  jl     @@Loop
@@NotFound:
  pop    ebx
@@NotFoundExit:
  xor    eax, eax
  jmp    @@Exit
@@Check4:
  sub    ecx, 1
  jnz    @@Next4
  add    ebp, 3
  jge    @@NotFound
  jmp    @@SetResult
@@Check3:
  sub    ecx, 1
  jnz    @@Next3
  add    ebp, 2
  jge    @@NotFound
  jmp    @@SetResult
@@Check2:
  sub    ecx, 1
  jnz    @@Next2
  add    ebp, 1
  jge    @@NotFound
  jmp    @@SetResult
@@Check1:
  sub    ecx, 1
  jnz    @@Next
@@SetResult:
  lea    eax, [ebx+ebp+1]
  sub    eax, edx
  pop    ebx
@@Exit:
end;

{****************************************}
{Can Read DWORD containing NULL Charatcer}
function ALCharPosEX(const SearchCharacter: Char;
                     const SourceString: AnsiString;
                     StartPos: Integer = 1): Integer;
begin
  result := ALCharPosEX(SearchCharacter, SourceString, 1, StartPos);
end;




//////////////////////////////////////////////////////////////////
//////////ALCompareText from FastCode Aleksandr Sharahov//////////
//////////////////////////////////////////////////////////////////

{****************************************************}
function ALCompareText(const S1, S2: string): integer;
asm
         test  eax, eax
         jz    @nil1
         test  edx, edx
         jnz   @ptrok

@nil2:   mov   eax, [eax-4]
         ret
@nil1:   test  edx, edx
         jz    @nil0
         sub   eax, [edx-4]
@nil0:   ret

@ptrok:  push  edi
         push  ebx
         xor   edi, edi
         mov   ebx, [eax-4]
         mov   ecx, ebx
         sub   ebx, [edx-4]
         adc   edi, -1
         push  ebx
         and   ebx, edi
         mov   edi, eax
         sub   ebx, ecx        //ebx := -min(Length(s1),Length(s2))
         jge   @len

@lenok:  sub   edi, ebx
         sub   edx, ebx

@loop:   mov   eax, [ebx+edi]
         mov   ecx, [ebx+edx]
         xor   eax, ecx
         jne   @differ
@same:   add   ebx, 4
         jl    @loop

@len:    pop   eax
         pop   ebx
         pop   edi
         ret

@loop2:  mov   eax, [ebx+edi]
         mov   ecx, [ebx+edx]
         xor   eax, ecx
         je    @same
@differ: test  eax, $DFDFDFDF  //$00 or $20
         jnz   @find
         add   eax, eax        //$00 or $40
         add   eax, eax        //$00 or $80
         test  eax, ecx
         jnz   @find
         and   ecx, $5F5F5F5F  //$41..$5A
         add   ecx, $3F3F3F3F  //$80..$99
         and   ecx, $7F7F7F7F  //$00..$19
         add   ecx, $66666666  //$66..$7F
         test  ecx, eax
         jnz   @find
         add   ebx, 4
         jl    @loop2

@len2:   pop   eax
         pop   ebx
         pop   edi
         ret

@loop3:  add   ebx, 1
         jge   @len2
@find:   movzx eax, [ebx+edi]
         movzx ecx, [ebx+edx]
         sub   eax, 'a'
         sub   ecx, 'a'
         cmp   al, 'z'-'a'
         ja    @upa
         sub   eax, 'a'-'A'
@upa:    cmp   cl, 'z'-'a'
         ja    @upc
         sub   ecx, 'a'-'A'
@upc:    sub   eax, ecx
         jz    @loop3

@found:  pop   ecx
         pop   ebx
         pop   edi
end;




////////////////////////////////////////////////////////////////
//////////ALUpperCase from FastCode Aleksandr Sharahov//////////
////////////////////////////////////////////////////////////////

{********************************************}
function AlUpperCase(const s: string): string;
asm
       push  ebx
       push  esi
       push  edi
       mov   esi, eax          // s
       mov   eax, edx
       test  esi, esi
       jz    @nil
       mov   ebx, [esi-4]      // Length(s)
       mov   edx, ebx
       mov   edi, eax          // @Result
       add   ebx, -1
       jl    @nil
       and   ebx, -4
       call  System.@LStrSetLength
       mov   eax, [ebx+esi]
       mov   edi, [edi]        // Result

@loop: mov   ecx, eax
       or    eax, $80808080    // $E1..$FA
       mov   edx, eax
       sub   eax, $7B7B7B7B    // $66..$7F
       xor   edx, ecx          // $80
       or    eax, $80808080    // $E6..$FF
       sub   eax, $66666666    // $80..$99
       and   eax, edx          // $80
       shr   eax, 2            // $20
       xor   eax, ecx          // Upper
       mov   [ebx+edi], eax
       mov   eax, [ebx+esi-4]
       sub   ebx, 4
       jge   @loop

       pop   edi
       pop   esi
       pop   ebx
       ret

@nil:  pop   edi
       pop   esi
       pop   ebx
       jmp    System.@LStrClr   // Result:=''
end;

{********************************************}
function ALLowerCase(const s: string): string;
asm
       push  ebx
       push  esi
       push  edi
       mov   esi, eax          // s
       mov   eax, edx
       test  esi, esi
       jz    @nil
       mov   ebx, [esi-4]      // Length(s)
       mov   edx, ebx
       mov   edi, eax          // @Result
       add   ebx, -1
       jl    @nil
       and   ebx, -4
       call  System.@LStrSetLength
       mov   eax, [ebx+esi]
       mov   edi, [edi]        // Result

@loop: mov   ecx, eax
       or    eax, $80808080    // $C1..$DA
       mov   edx, eax
       sub   eax, $5B5B5B5B    // $66..$7F
       xor   edx, ecx          // $80
       or    eax, $80808080    // $E6..$FF
       sub   eax, $66666666    // $80..$99
       and   eax, edx          // $80
       shr   eax, 2            // $20
       xor   eax, ecx          // Lower
       mov   [ebx+edi], eax
       mov   eax, [ebx+esi-4]
       sub   ebx, 4
       jge   @loop

       pop   edi
       pop   esi
       pop   ebx
       ret

@nil:  pop   edi
       pop   esi
       pop   ebx
       jmp    System.@LStrClr   // Result:=''
end;




///////////////////////////
//////////Alcinoe//////////
///////////////////////////

{********************************************************************************}
function ALCopyStr(const aSourceString: string; aStart, aLength: Integer): string;
var SourceStringLength: Integer;
begin
  SourceStringLength := Length(aSourceString);
  If (aStart < 1) then aStart := 1;

  if (SourceStringLength=0) or
     (aLength < 1) or
     (aStart > SourceStringLength) then Begin
    Result := '';
    Exit;
  end;

  if aLength > SourceStringLength - (aStart - 1) then aLength := SourceStringLength - (aStart-1);

  SetLength(Result,aLength);
  ALMove(aSourceString[aStart], Result[1], aLength);
end;

{*********************************************}
function ALRandomStr(aLength: Longint): string;
var X: Longint;
begin
  if aLength <= 0 then exit;
  SetLength(Result, aLength);
  for X:=1 to aLength do Result[X] := Chr(Random(26) + 65);
end;

{*************************************************}
function ALNEVExtractName(const S: string): string;
var P: Integer;
begin
  Result := S;
  P := alCharPos('=', Result);
  if P <> 0 then SetLength(Result, P-1)
  else SetLength(Result, 0);
end;

{**************************************************}
function ALNEVExtractValue(const s: string): string;
begin
  Result := AlCopyStr(s, Length(ALNEVExtractName(s)) + 2, MaxInt)
end;

{*********************************************************************}
function ALFastTagReplace(Const SourceString, TagStart, TagEnd: string;
                          FastTagReplaceProc: TALHandleTagFunct;
                          ReplaceStrParamName,
                          ReplaceWith: String;
                          AStripParamQuotes: Boolean;
                          Flags: TReplaceFlags;
                          ExtData: Pointer): string;
var  i: integer;
     ReplaceString: String;
     Token, FirstTagEndChar: Char;
     TokenStr, ParamStr: string;
     ParamList: TStringList;
     TagStartLength: integer;
     TagEndLength: integer;
     SourceStringLength: Integer;
     T1,T2: Integer;
     InDoubleQuote: Boolean;
     InsingleQuote: Boolean;
     Work_SourceString: String;
     Work_TagStart: String;
     Work_TagEnd: String;
     TagHandled: Boolean;
     ResultCurrentPos: integer;
     ResultCurrentLength: integer;

Const ResultBuffSize: integer = 16384;

     {-------------------------------}
     Function ExtractTokenStr: String;
     var x: Integer;
     Begin
       x := AlCharPos(' ',ReplaceString);
       if x > 0 then Result := trim( AlcopyStr(ReplaceString,1,x) )
       else Result := trim(ReplaceString);
     end;

     {--------------------------------}
     Function ExtractParamsStr: String;
     Begin
       Result := trim( AlcopyStr(ReplaceString,length(TokenStr) + 1, MaxInt) );
     end;

     {-----------------------------------}
     Procedure MoveStr2Result(Src:String);
     Var l: integer;
     Begin
       If Src <> '' then begin
         L := Length(Src);
         If L+ResultCurrentPos-1>ResultCurrentLength Then begin
           ResultCurrentLength := ResultCurrentLength + L + ResultBuffSize;
           SetLength(Result,ResultCurrentLength);
         end;
         AlMove(Src[1],Result[ResultCurrentPos],L);
         ResultCurrentPos := ResultCurrentPos + L;
       end;
     end;


begin
  if (SourceString = '') or (TagStart = '') or (TagEnd = '') then begin
    Result := SourceString;
    Exit;
  end;

  If rfIgnoreCase in flags then begin
    Work_SourceString := ALUppercase(SourceString);
    Work_TagStart := ALuppercase(TagStart);
    Work_TagEnd := ALUppercase(TagEnd);
  end
  Else begin
    Work_SourceString := SourceString;
    Work_TagStart := TagStart;
    Work_TagEnd := TagEnd;
  end;

  SourceStringLength := length(Work_SourceString);
  ResultCurrentLength := SourceStringLength;
  SetLength(Result,ResultCurrentLength);
  ResultCurrentPos := 1;
  TagStartLength := Length(Work_TagStart);
  TagEndLength := Length(Work_TagEnd);
  FirstTagEndChar := Work_TagEnd[1];
  i := 1;

  T1 := ALPosEx(Work_TagStart,Work_SourceString,i);
  T2 := T1 + TagStartLength;
  If (T1 > 0) and (T2 <= SourceStringLength) then begin
    InDoubleQuote := False;
    InsingleQuote := False;
    Token := Work_SourceString[T2];
    if token = '"' then InDoubleQuote := True
    else if token = '''' then InSingleQuote := True;
    While (T2 < SourceStringLength) and (InDoubleQuote or InSingleQuote or (Token <> FirstTagEndChar) or (ALPosEx(Work_TagEnd,Work_SourceString,T2) <> T2)) do begin
      inc(T2);
      Token := Work_SourceString[T2];
      If Token = '"' then InDoubleQuote := not InDoubleQuote and not InSingleQuote
      else If Token = '''' then InSingleQuote := not InSingleQuote and not InDoubleQuote
    end;
  end;


  While (T1 > 0) and (T2 > T1) do begin
    ReplaceString := AlCopyStr(SourceString,T1 + TagStartLength,T2 - T1 - TagStartLength);

    TagHandled := True;
    If assigned(FastTagReplaceProc) or (ReplaceStrParamName <> '') then begin
      TokenStr := ExtractTokenStr;
      ParamStr := ExtractParamsStr;
      ParamList := TStringList.Create;
      try
        ALExtractHeaderFields([' ', #9], [' ', #9], PChar(ParamStr), ParamList, False, AStripParamQuotes);
        If assigned(FastTagReplaceProc) then ReplaceString := FastTagReplaceProc(TokenStr, ParamList, ExtData, TagHandled)
        else ReplaceString := ParamList.Values[ReplaceStrParamName];
      finally
        ParamList.Free;
      end;
    end
    else ReplaceString := ReplaceWith;


    If tagHandled then MoveStr2Result(AlcopyStr(SourceString,i,T1 - i) + ReplaceString)
    else MoveStr2Result(AlcopyStr(SourceString,i,T2 + TagEndLength - i));
    i := T2 + TagEndLength;

    If TagHandled and (not (rfreplaceAll in flags)) then Break;

    T1 := ALPosEx(Work_TagStart,Work_SourceString,i);
    T2 := T1 + TagStartLength;
    If (T1 > 0) and (T2 <= SourceStringLength) then begin
      InDoubleQuote := False;
      InsingleQuote := False;
      Token := Work_SourceString[T2];
      if token = '"' then InDoubleQuote := True
      else if token = '''' then InSingleQuote := True;
      While (T2 < SourceStringLength) and (InDoubleQuote or InSingleQuote or (Token <> FirstTagEndChar) or (ALPosEx(Work_TagEnd,Work_SourceString,T2) <> T2)) do begin
        inc(T2);
        Token := Work_SourceString[T2];
        If Token = '"' then InDoubleQuote := not InDoubleQuote and not InSingleQuote
        else If Token = '''' then InSingleQuote := not InSingleQuote and not InDoubleQuote
      end;
    end;
  end;

  MoveStr2Result(AlcopyStr(SourceString,i,maxint));
  SetLength(Result,ResultCurrentPos-1);
end;

{*********************************************************************}
function ALFastTagReplace(const SourceString, TagStart, TagEnd: string;
                          ReplaceWith: string;
                          const Flags: TReplaceFlags=[rfreplaceall] ): string;
Begin
  Result := ALFastTagReplace(SourceString, TagStart, TagEnd, nil, '', ReplaceWith, True, flags, nil);
end;

{*********************************************************************}
function ALFastTagReplace(const SourceString, TagStart, TagEnd: string;
                          ReplaceStrParamName: string;
                          AStripParamQuotes: Boolean;
                          const Flags: TReplaceFlags=[rfreplaceall] ): string;
Begin
  Result := ALFastTagReplace(SourceString, TagStart, TagEnd, nil, ReplaceStrParamName, '', AStripParamQuotes, flags, nil);
end;

{*********************************************************************}
function ALFastTagReplace(const SourceString, TagStart, TagEnd: string;
                          FastTagReplaceProc: TALHandleTagFunct;
                          AStripParamQuotes: Boolean;
                          ExtData: Pointer;
                          Const flags: TReplaceFlags=[rfreplaceall]): string;
Begin
  result := ALFastTagReplace(SourceString, TagStart, TagEnd, FastTagReplaceProc, '', '', AStripParamQuotes, flags, extdata);
end;

{***********************************************************************}
function ALExtractTagParams(Const SourceString, TagStart, TagEnd: string;
                            AStripParamQuotes: Boolean;
                            TagParams: TStrings;
                            IgnoreCase: Boolean): Boolean;
var  ReplaceString: String;
     Token, FirstTagEndChar: Char;
     TokenStr, ParamStr: string;
     TagStartLength: integer;
     SourceStringLength: Integer;
     T1,T2: Integer;
     InDoubleQuote: Boolean;
     InsingleQuote: Boolean;
     Work_SourceString: String;
     Work_TagStart: String;
     Work_TagEnd: String;

     {-------------------------------}
     Function ExtractTokenStr: String;
     var x: Integer;
     Begin
       x := AlCharPos(' ',ReplaceString);
       if x > 0 then Result := trim( AlcopyStr(ReplaceString,1,x) )
       else Result := trim(ReplaceString);
     end;

     {--------------------------------}
     Function ExtractParamsStr: String;
     Begin
       Result := trim( AlcopyStr(ReplaceString,length(TokenStr) + 1, MaxInt) );
     end;

begin
  Result := False;
  if (SourceString = '') or (TagStart = '') or (TagEnd = '') then Exit;

  If IgnoreCase then begin
    Work_SourceString := ALUppercase(SourceString);
    Work_TagStart := ALuppercase(TagStart);
    Work_TagEnd := ALUppercase(TagEnd);
  end
  Else begin
    Work_SourceString := SourceString;
    Work_TagStart := TagStart;
    Work_TagEnd := TagEnd;
  end;

  TagStartLength := Length(Work_TagStart);
  SourceStringLength := length(SourceString);
  FirstTagEndChar := tagEnd[1];

  T1 := ALPosEx(Work_TagStart,Work_SourceString,1);
  T2 := T1 + TagStartLength;
  If (T1 > 0) and (T2 <= SourceStringLength) then begin
    InDoubleQuote := False;
    InsingleQuote := False;
    Token := Work_SourceString[T2];
    if token = '"' then InDoubleQuote := True
    else if token = '''' then InSingleQuote := True;
    While (T2 < SourceStringLength) and (InDoubleQuote or InSingleQuote or (Token <> FirstTagEndChar) or (ALPosEx(Work_TagEnd,Work_SourceString,T2) <> T2)) do begin
      inc(T2);
      Token := Work_SourceString[T2];
      If Token = '"' then InDoubleQuote := not InDoubleQuote and not InSingleQuote
      else If Token = '''' then InSingleQuote := not InSingleQuote and not InDoubleQuote
    end;
  end;

  If (T1 > 0) and (T2 > T1) Then begin
    ReplaceString := AlCopyStr(SourceString,T1 + TagStartLength,T2 - T1 - TagStartLength);

    TokenStr := ExtractTokenStr;
    ParamStr := ExtractParamsStr;
    ALExtractHeaderFields([' ', #9], [' ', #9], PChar(ParamStr), TagParams, False, AStripParamQuotes);
    Result := True
  end;
end;

{********************************************************}
{Parses a multi-valued string into its constituent fields.
 ExtractHeaderFields is a general utility to parse multi-valued HTTP header strings into separate substrings.
 * Separators is a set of characters that are used to separate individual values within the multi-valued string.
 * WhiteSpace is a set of characters that are to be ignored when parsing the string.
 * Content is the multi-valued string to be parsed.
 * Strings is the TStrings object that receives the individual values that are parsed from Content.
 * StripQuotes determines whether the surrounding quotes are removed from the resulting items. When StripQuotes is true, surrounding quotes are removed
   before substrings are added to Strings.
 Note:	Characters contained in Separators or WhiteSpace are treated as part of a value substring if the substring is surrounded by single or double quote
 marks. HTTP escape characters are converted using the HTTPDecode function.}
procedure ALExtractHeaderFields(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings; Decode: Boolean; StripQuotes: Boolean = False);
var
  Head, Tail: PChar;
  EOS, InQuote, LeadQuote: Boolean;
  QuoteChar: Char;
  ExtractedField: string;
  WhiteSpaceWithCRLF: TSysCharSet;
  SeparatorsWithCRLF: TSysCharSet;

  function DoStripQuotes(const S: string): string;
  var I: Integer;
      InStripQuote: Boolean;
      StripQuoteChar: Char;
  begin
    Result := S;
    InStripQuote := False;
    StripQuoteChar := #0;
    if StripQuotes then
      for I := Length(Result) downto 1 do
        if Result[I] in ['''', '"'] then
          if InStripQuote and (StripQuoteChar = Result[I]) then begin
            Delete(Result, I, 1);
            InStripQuote := False;
          end
          else if not InStripQuote then begin
            StripQuoteChar := Result[I];
            InStripQuote := True;
            Delete(Result, I, 1);
          end
  end;

Begin
  if (Content = nil) or (Content^ = #0) then Exit;
  WhiteSpaceWithCRLF := WhiteSpace + [#13, #10];
  SeparatorsWithCRLF := Separators + [#0, #13, #10, '"', ''''];
  Tail := Content;
  QuoteChar := #0;
  repeat
    while Tail^ in WhiteSpaceWithCRLF do Inc(Tail);
    Head := Tail;
    InQuote := False;
    LeadQuote := False;
    while True do begin
      while (InQuote and not (Tail^ in [#0, '"', ''''])) or not (Tail^ in SeparatorsWithCRLF) do Inc(Tail);
      if Tail^ in ['"',''''] then begin
        if (QuoteChar <> #0) and (QuoteChar = Tail^) then QuoteChar := #0
        else If QuoteChar = #0 then begin
            LeadQuote := Head = Tail;
            QuoteChar := Tail^;
            if LeadQuote then Inc(Head);
        end;
        InQuote := QuoteChar <> #0;
        if InQuote then Inc(Tail)
        else Break;
      end else Break;
    end;
    if not LeadQuote and (Tail^ <> #0) and (Tail^ in ['"','''']) then Inc(Tail);
    EOS := Tail^ = #0;
    if Head^ <> #0 then begin
      SetString(ExtractedField, Head, Tail-Head);
      if Decode then Strings.Add(HTTPDecode(DoStripQuotes(ExtractedField)))
      else Strings.Add(DoStripQuotes(ExtractedField));
    end;
    Inc(Tail);
  until EOS;
end;

{*****************************************************}
Function ALAnsiUpperCaseNoDiacritic(S: string): string;
var Len1, Len2: Integer;
    i,J: integer;
    TmpStr1,
    TmpStr2: String;
begin
  result := '';
  If s = '' then exit;

  {upper the result}
  TmpStr1 := AnsiUppercase(s);
  Len1 := length(TmpStr1);

  {remove diacritic}
  Len2 := FoldString(MAP_COMPOSITE, PChar(TmpStr1), Len1, nil, 0);
  setlength(TmpStr2,len2);
  FoldString(MAP_COMPOSITE, PChar(TmpStr1), Len1, PChar(TmpStr2), len2);
  i := 1;
  J := 1;
  SetLength(result,len1);
  while J <= len1 do begin
    Result[j] := TmpStr2[i];
    if TmpStr1[j] <> TmpStr2[i] then inc(i,2)
    else inc(i);
    inc(j);
  end;
end;

{*****************************************************}
function ALGetStringFromFile(filename: string): string;
Var AFileStream: TfileStream;
begin
  AFileStream := TFileStream.Create(filename,fmOpenRead + fmShareDenyWrite);
  try

    If AFileStream.size > 0 then begin
      SetLength(Result, AFileStream.size);
      AfileStream.Read(Result[1],AfileStream.Size)
    end
    else Result := '';

  finally
    AfileStream.Free;
  end;
end;

{*************************************************}
procedure ALSaveStringtoFile(Str,filename: string);
Var AStringStream: TStringStream;
    AMemoryStream: TMemoryStream;
begin
  AMemoryStream := TMemoryStream.Create;
  try

    AStringStream := TStringStream.Create(str);
    try
      AmemoryStream.LoadFromStream(AstringStream);
      AmemoryStream.SaveToFile(filename);
    finally
      AStringStream.Free;
    end;

  finally
    AMemoryStream.Free;
  end;
end;

{************}
var Ch: Char;
initialization
  for Ch := #0 to #255 do VALMove_AnsiUpcase[Ch] := Ch;
  CharUpperBuff(@VALMove_AnsiUpcase, 256);
  VALMove_PrefetchLimit := (ALGetCPUinfo.L2CacheSize div 16) * -1024;
  ALInitFastMovProc;
  ALInitCharPosFunct;
  ALInitFastPosFunct;

end.
