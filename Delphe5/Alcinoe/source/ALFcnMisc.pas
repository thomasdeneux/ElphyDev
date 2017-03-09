{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      Alcinoe Misc function
Version:      3.05

Description:  Alcinoe Misc function

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

History :     09/01/2005: correct then AlEmptyDirectory function
Link :

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALFcnMisc;

interface

uses Windows,
     sysutils,
     messages;

function ALWinExecAndWait32(FileName:String; Visibility : integer):DWORD;
Function ALWinExecAndWait32V2(FileName: String; Visibility: integer): DWORD;
Function AlEmptyDirectory(Directory: String; SubDirectory: Boolean; Const RemoveEmptySubDirectory: Boolean = True; Const FileNameMask: String = '*.*'; Const MinFileAge: TdateTime = 0): Boolean;
Function AlCopyDirectory(SrcDirectory, DestDirectory: String; SubDirectory: Boolean; Const FileNameMask: String = '*.*'; Const ErraseIfExist: Boolean = False): Boolean;
Function AlBoolToInt(Value:Boolean):Integer;
Function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
Function ALIsInteger (const S : String) : Boolean;
Function ALIsSmallInt (const S : String) : Boolean;
function ALGetModuleName: string;
function ALGetModulePath: String;
Function AlGetFileVersion(const AFileName: string): String;
Function ALMakeGoodEndPath(Rep : string):string;
Function AlStrToBool(Value:String):Boolean;
Function ALMakeKeyStrByGUID: String;
function AlIsValidEmail(const Value: string): boolean;

implementation

uses Masks,
     alFcnString;

{***********************************************************************}
function ALWinExecAndWait32(FileName:String; Visibility : integer):DWORD;
var
  zAppName:array[0..512] of char;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  StrPCopy(zAppName,FileName);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName,                      { pointer to command line string }
    nil,                           { pointer to process security attributes}
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo)                   { pointer to PROCESS_INF }
  then Result := DWORD(-1)
  else begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Result);
    CloseHandle( ProcessInfo.hProcess );
    CloseHandle( ProcessInfo.hThread );
  end;
end;


{**************************************************************************}
{*  ALWinExecAndWait32V2:                                                  }
{*  Executes a program and waits for it to terminate                       }
{*  @Param FileName contains executable + any parameters                   }
{*  @Param Visibility is one of the ShowWindow options, e.g. SW_SHOWNORMAL }
{*  @Returns -1 in case of error, otherwise the programs exit code         }
{*  @Desc In case of error SysErrorMessage( GetlastError ) will return an  }
{*  error message. The routine will process paint messages and messages    }
{*  send from other threads while it waits.                                }
Function ALWinExecAndWait32V2(FileName: String; Visibility: integer): DWORD;

  {------------------------------------------}
  Procedure WaitFor( processHandle: THandle );
  Var msg: TMsg;
      ret: DWORD;
  Begin
    Repeat

      ret := MsgWaitForMultipleObjects(
               1,             { 1 handle to wait on }
               processHandle, { the handle }
               False,         { wake on any event }
               INFINITE,      { wait without timeout }
               QS_PAINT or    { wake on paint messages }
               QS_SENDMESSAGE { or messages from other threads }
               );
      If ret = WAIT_FAILED Then Exit;
      If ret = (WAIT_OBJECT_0 + 1) Then
        While PeekMessage( msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE ) Do
          DispatchMessage( msg );

    Until ret = WAIT_OBJECT_0;
  End;

Var
  zAppName:array[0..512] of char;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
Begin
  StrPCopy(zAppName,FileName);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  If not CreateProcess(nil,
    zAppName,                { pointer to command line string }
    nil,                     { pointer to process security attributes }
    nil,                     { pointer to thread security attributes }
    false,                   { handle inheritance flag }
    CREATE_NEW_CONSOLE or    { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                     { pointer to new environment block }
    nil,                     { pointer to current directory name }
    StartupInfo,             { pointer to STARTUPINFO }
    ProcessInfo)             { pointer to PROCESS_INF }
  Then Result := DWORD(-1)   { failed, GetLastError has error code }
  Else Begin
     Waitfor(ProcessInfo.hProcess);
     GetExitCodeProcess(ProcessInfo.hProcess, Result);
     CloseHandle( ProcessInfo.hProcess );
     CloseHandle( ProcessInfo.hThread );
  End;
End;

{******************************************}
Function AlEmptyDirectory(Directory: String;
                          SubDirectory: Boolean;
                          Const RemoveEmptySubDirectory: Boolean = True;
                          Const FileNameMask: String = '*.*';
                          Const MinFileAge: TdateTime = 0): Boolean;
var sr: TSearchRec;
    aBool: Boolean;
begin
  Result := True;
  Directory := ALMakeGoodEndPath(Directory);
  if FindFirst(Directory + '*.*', faAnyFile	, sr) = 0 then begin
    repeat
      If (sr.Name <> '.') and (sr.Name <> '..') Then Begin
        If ((sr.Attr and faDirectory) <> 0) then begin
          If SubDirectory then begin
            AlEmptyDirectory(Directory + sr.Name, True, RemoveEmptySubDirectory, fileNameMask, MinFileAge);
            If RemoveEmptySubDirectory then begin
              Abool := RemoveDir(Directory + sr.Name);
              If result and (fileNameMask = '*.*') then Result := Abool;
            end;
          end;
        end
        else If (
                 (FileNameMask = '*.*') or
                 MatchesMask(sr.Name, FileNameMask)
                )
                and
                (
                 (MinFileAge<=0) or
                 (FileDateToDateTime(sr.Time) < MinFileAge)
                )
        then begin
          abool := Deletefile(Directory + sr.Name);
          If result then result := aBool;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end
end;

{************************************}
Function AlCopyDirectory(SrcDirectory,
                         DestDirectory: String;
                         SubDirectory: Boolean;
                         Const FileNameMask: String = '*.*';
                         Const ErraseIfExist: Boolean = False): Boolean;
var sr: TSearchRec;
    aBool: Boolean;
begin
  Result := True;
  SrcDirectory := ALMakeGoodEndPath(SrcDirectory);
  DestDirectory := ALMakeGoodEndPath(DestDirectory);
  If not DirectoryExists(DestDirectory) and (not Createdir(DestDirectory)) then begin
    result := False;
    exit;
  end;

  if FindFirst(SrcDirectory + '*.*', faAnyFile, sr) = 0 then begin
    repeat
      If (sr.Name <> '.') and (sr.Name <> '..') Then Begin
        If ((sr.Attr and faDirectory) <> 0) then begin
          If SubDirectory and
             (
              not AlCopyDirectory(
                                  SrcDirectory + sr.Name,
                                  DestDirectory + sr.Name,
                                  SubDirectory,
                                  FileNameMask,
                                  ErraseIfExist
                                 )
             )
          then Result := False;
        end
        else If (
                 (FileNameMask = '*.*') or
                 MatchesMask(sr.Name, FileNameMask)
                )
        then begin
          If (not fileExists(DestDirectory + sr.Name)) or ErraseIfExist
            then abool := Copyfile(
                                   Pchar(SrcDirectory + sr.Name),
                                   Pchar(DestDirectory + sr.Name),
                                   not ErraseIfExist
                                  )
            else aBool := True;
          If result then result := aBool;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end
end;

{******************************************}
Function AlBoolToInt(Value:Boolean):Integer;
Begin
  If Value then result := 1
  else result := 0;
end;

{***************************************************************}
Function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
Begin
  result := (LTotal - (LBorder*2) - LObject) div 2 + LBorder;
End;

{************************************************}
Function ALIsInteger (const S : String) : Boolean;
var i : Integer;
Begin
 Result := TryStrToInt(S, I);
End;

{*************************************************}
Function ALIsSmallInt (const S : String) : Boolean;
var i : Integer;
Begin
 Result := TryStrToInt(S, I) and (i <= 32767) and (I >= -32768);
End;

{*******************************}
function ALGetModuleName: string;
var ModName: array[0..MAX_PATH] of Char;
begin
  SetString(Result, ModName, Windows.GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
  If ALpos('\\?\',result) = 1 then delete(Result,1,4);
end;

{*******************************}
function ALGetModulePath: String;
begin
  Result:=ExtractFilePath(ALGetModuleName);
  If (length(result) > 0) and (result[length(result)] <> '\') then result := result + '\';
end;

{*********************************************************}
Function AlGetFileVersion(const AFileName: string): String;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := '';
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result := inttostr(HiWord(FI.dwFileVersionMS)) +'.'+ inttostr(LoWord(FI.dwFileVersionMS)) +'.'+ inttostr(HiWord(FI.dwFileVersionLS)) +'.'+ inttostr(LoWord(FI.dwFileVersionLS));
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

{**********************************************}
Function ALMakeGoodEndPath(Rep : string):string;
begin
  if (length(Rep) > 0) and (Rep[length(Rep)] <> '\') then Rep := Rep + '\';
  result := Rep;
end;

{*****************************************}
Function AlStrToBool(Value:String):Boolean;
Begin
  Result := False;
  TryStrtoBool(Value,Result);
end;

{***********************************}
Function  ALMakeKeyStrByGUID: String;
Var aGUID: TGUID;
Begin
  CreateGUID(aGUID);
  Result := GUIDToString(aGUID);
  Delete(Result,1,1);
  Delete(Result,Length(result),1);
End;

{**************************************************}
function AlIsValidEmail(const Value: string): boolean;

 {----------------------------------------------}
 function CheckAllowed(const s: string): boolean;
 var i: integer;
 begin
   Result:= false;
   for i:= 1 to Length(s) do begin
     // illegal char in s -> no valid address
     if not (s[i] in ['a'..'z','A'..'Z','0'..'9','_','-','.']) then Exit;
   end;
   Result:= true;
 end;

var i: integer;
    namePart, serverPart: string;
begin
  Result:= false;
  i:= AlCharPos('@', Value);
  if (i = 0) or (ALpos('..', Value) > 0) then Exit;
  namePart:= Copy(Value, 1, i - 1);
  serverPart:= Copy(Value, i + 1, Length(Value));
  if (Length(namePart) = 0)         // @ or name missing
    or ((Length(serverPart) < 4))   // name or server missing or
    then Exit;                      // too short
  i:= AlCharPos('.', serverPart);
  // must have dot and at least 2 places from end
  if (i = 0) or (i > (Length(serverPart) - 2)) then Exit;
  Result:= CheckAllowed(namePart) and CheckAllowed(serverPart);
end;

end.
