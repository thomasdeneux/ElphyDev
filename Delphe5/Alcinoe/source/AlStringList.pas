{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      TALStringList
Version:      3.10

Description:  TALStringList in inherited from Delphi TstringList.
              It's allow to search a name=value using a quicksort 
              algorithm when the list is sorted.

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
unit ALStringList;

interface

Uses Classes;

Type

  {--------------------------------}
  TALStringList = class(TStringList)
  private
  protected
    procedure Put(Index: Integer; const S: string); override;
  public
    function FindName(const S: string; var Index: Integer): Boolean; virtual;
    function IndexOfName(const Name: string): Integer; override;
  end;

implementation

{****************************************************************************}
function TALStringList.FindName(const S: string; var Index: Integer): Boolean;
var L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := Count - 1;
  while L <= H do begin
    I := (L + H) shr 1;
    C := CompareStrings(ExtractName(Get(I)), S);
    if C < 0 then L := I + 1
    else begin
      H := I - 1;
      if C = 0 then Result := True;
    end;
  end;
  Index := L;
end;

{**************************************************************}
function TALStringList.IndexOfName(const Name: string): Integer;
begin
  if not Sorted then Result := inherited IndexOfName(Name)
  else if not FindName(Name, Result) then Result := -1;
end;

{***********************************************************}
procedure TALStringList.Put(Index: Integer; const S: string);
begin
  If not sorted then inherited Put(Index, S)
  else begin
    delete(index);
    add(s);
  end;
end;

end.
