{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      Alcinoe crypt function
Version:      3.05

Description:  Simple Xor Encrypt and Decrypt function

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

History :

Link :

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALFcnCrypt;

interface

function ALXorEncrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;
function ALXorDecrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;

implementation

uses sysutils;

{************************************************************************************}
function ALXorEncrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;
var c : Byte;
    I:Integer;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    C := Byte(InString[I]) xor (StartKey shr 8);
    Result := Result + inttohex(c ,2);
    StartKey := (c + StartKey) * MultKey + AddKey;
  end;
end;

{************************************************************************************}
function ALXorDecrypt(const InString:string; StartKey,MultKey,AddKey:Integer): string;
Var C : Char;
    I:Integer;
begin
  Result := '';
  I := 1;
  While I < Length(InString) do begin
    C := Char(strtoint('$' + copy(InString,I,2)));
    Result := Result + CHAR(Byte(C) xor (StartKey shr 8));
    StartKey := (Byte(C) + StartKey) * MultKey + AddKey;
    Inc(i,2);
  end;
end;

end.
 