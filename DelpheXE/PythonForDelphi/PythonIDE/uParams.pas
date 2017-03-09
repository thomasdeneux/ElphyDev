{
  Syn
  Copyright � 2003-2004, Danail Traichev. All rights reserved.
  neum@developer.bg,

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in compliance
  with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  the specific language governing rights and limitations under the License.

  The Original Code is uParams.pas, released Thu, 27 Mar 2003 10:22:27 UTC.

  The Initial Developer of the Original Code is Danail Traichev.
  Portions created by Danail Traichev are Copyright � 2003-2004 Danail Traichev.
  All Rights Reserved.

  Contributor(s): .

  Alternatively, the contents of this file may be used under the terms of the
  GNU General Public License Version 2 or later (the "GPL"), in which case
  the provisions of the GPL are applicable instead of those above.
  If you wish to allow use of your version of this file only under the terms
  of the GPL and not to allow others to use your version of this file
  under the MPL, indicate your decision by deleting the provisions above and
  replace them with the notice and other provisions required by the GPL.
  If you do not delete the provisions above, a recipient may use your version
  of this file under either the MPL or the GPL.

  You may retrieve the latest version of this file at the  home page,
  located at http://syn.sourceforge.net

 $Id: uParams.pas,v 1.12 2004/06/07 23:03:48 neum Exp $
 }
unit uParams;

interface

Uses
  Classes;


(* parameters, valid for current Windows configuration *)
procedure RegisterStandardParametersAndModifiers;
procedure UnRegisterStandardParametersAndModifiers;

procedure RegisterCustomParams;
procedure UnRegisterCustomParams;

Var
  CustomParams : TStringList;

implementation

uses
  Windows, SysUtils, Dialogs, Clipbrd, ComCtrls, jclFileUtils, jclDateTime,
  jclStrings, JclSysInfo, cParameters, Registry,  uEditAppIntfs,
  JvBrowseFolder, dmCommands, VarPyth, SynRegExpr, uCommonFunctions,
  frmPyIDEMain, StringResources;

function GetActiveDoc: string;
Var
  Editor : IEditor;
begin
  Result:= '';
  Editor := PyIDEMainForm.GetActiveEditor;
  if Assigned(Editor) then
    Result:= Editor.GetFileNameOrTitle;
end;

function GetModFiles: string;
var
  i: integer;
begin
  Result:= '';
  if Assigned(GI_EditorFactory) then begin
    with GI_EditorFactory do
      for i := 0 to GetEditorCount - 1 do
        with Editor[i] do
          if GetModified and (GetFileName <> '') then
            Result := Concat(Result, ' ', ExtractShortPathName(GetFileName));
    Delete(Result, 1, 1);
  end;
end;

function GetOpenFiles: string;
var
  i: integer;
begin
  Result:= '';
  if Assigned(GI_EditorFactory) then begin
    with GI_EditorFactory do
      for i := 0 to GetEditorCount - 1 do
        with Editor[i] do
          if GetFileName <> '' then
            Result := Concat(Result, ' ', ExtractShortPathName(GetFileName));
    Delete(Result, 1, 1);
  end;
end;

function GetCurWord(const AFileName: string): string;
var
  AEditor: IEditor;
begin
  Result:= '';
  if (AFileName = '') or SameText('ActiveDoc', AFileName) then
    AEditor:= GI_ActiveEditor
  else AEditor := GI_EditorFactory.GetEditorByName(AFileName);
  if Assigned(AEditor) then
    Result:= AEditor.GetSynEdit.WordAtCursor;
end;

function GetCurLine(const AFileName: string): string;
var
  AEditor: IEditor;
begin
  Result:= '';
  if (AFileName = '') or SameText('ActiveDoc', AFileName) then
    AEditor:= GI_ActiveEditor
  else AEditor:= GI_EditorFactory.GetEditorByName(AFileName);
  if Assigned(AEditor) then
    Result:= AEditor.GetSynEdit.LineText;
end;

function GetSelText(const AFileName: string): string;
var
  AEditor: IEditor;
begin
  Result:= '';
  if (AFileName = '') or SameText('ActiveDoc', AFileName) then
    AEditor:= GI_ActiveEditor
  else AEditor:= GI_EditorFactory.GetEditorByName(AFileName);
  if Assigned(AEditor) then
    Result:= AEditor.GetSynEdit.SelText;
end;

function SelectFile(const ATitle: string): string;
var
  SaveTitle: string;
begin
  with CommandsDataModule.dlgFileOpen do begin
    Filter := SFilterAllFiles;
    SaveTitle:= Title;
    if ATitle <> '' then
      Title:= ATitle
    else
      Title := 'Select File';
    if Execute then begin
      Result:= FileName;
      Parameters.ChangeParameter('SelectedFile', FileName);
    end;
    Title:= SaveTitle;
  end;
end;

function SelectDir(const ATitle: string): string;
begin
  if BrowseDirectory(Result, ATitle, 0) then
      Parameters.ChangeParameter('SelectedDir', Result);
end;

function StrDefQuote(const AText: string): string;
begin
  Result:= StrQuote(AText, '"');
end;

function GetDateTime: string;
begin
  Result:= DateTimeToStr(Now);
end;

function GetDate(const AText: string): string;
begin
  Result:= DateToStr(StrToDateTime(AText));
end;

function GetTime(const AText: string): string;
begin
  Result:= TimeToStr(StrToDateTime(AText));
end;

function GetFileDate(const AFileName: string): string;
begin
  Result:= '';
  if FileExists(AFileName) then
    Result:= DateTimeToStr(FileDateToDateTime(FileAge(AFileName)));
end;

function GetFileDateCreate(const AFileName: string): string;
begin
  Result:= '';
  if FileExists(AFileName) then
    Result:= DateTimeToStr(FileTimeToDateTime(GetFileCreation(AFileName)));
end;

function GetFileDateWrite(const AFileName: string): string;
begin
  Result:= '';
  if FileExists(AFileName) then
    Result:= DateTimeToStr(FileTimeToDateTime(GetFileLastWrite(AFileName)));
end;

function GetFileDateAccess(const AFileName: string): string;
begin
  Result:= '';
  if FileExists(AFileName) then
    Result:= DateTimeToStr(FileTimeToDateTime(GetFileLastAccess(AFileName)));
end;

function GetDateFormated(const AText: string): string;
var
//  i: Integer;
  RegExpr : TRegExpr;
begin
  RegExpr := TRegExpr.Create;
  try
    RegExpr.Expression := '([^'']+)-''([^'']+)''';
    if RegExpr.Exec(AText)then
      Result:= FormatDateTime(RegExpr.Match[2],  StrToDateTime(RegExpr.Match[1]))
    else raise EParameterError.CreateFmt(Translate(SInvalidParameterFormat),
                                       [Concat(AText, '-', 'DateFormat')]);

  finally
    RegExpr.Free;
  end;
end;

function GetExe: string;
begin
  Result:= ParamStr(0);
end;

function GetParam(const AIndex: string): string;
(* Returns the commandline argument *)
var
  ix: integer;
begin
  Result := '';
  if StrConsistsOfNumberChars(AIndex) then begin
    ix := StrToInt(AIndex);
    if ix <= ParamCount then
      Result := ParamStr(ix);
  end;
end;

function GetClipboard: string;
(* returns clipboard as text *)
begin
  Result:= Clipboard.AsText;
end;

function GetFileExt(const AFileName: string): string;
(* returns extension without . *)
begin
  Result:= ExtractFileExt(AFileName);
  if Result <> '' then
    Delete(Result, 1, 1);
end;

function GetReg(const ARegKey: string): string;
(* returns registry key value *)
var
  Info: TRegDataInfo;
  AName: string;
  i: Integer;
  Buff: Pointer;
begin
  with TRegistry.Create(KEY_READ and not KEY_NOTIFY) do try
    Result:= '';
    if ARegKey = '' then Exit;
    i:= Pos('\', ARegKey);
    (* read root key *)
    if i > 1 then begin
      AName:= Copy(ARegKey, 1, i-1);
      if (AName = 'HKCU') or (AName = 'HKEY_CURRENT_USER') then
        RootKey:= HKEY_CURRENT_USER
      else if (AName = 'HKLM') or (AName = 'HKEY_LOCAL_MACHINE') then
        RootKey:= HKEY_LOCAL_MACHINE
      else if (AName = 'HKCR') or (AName = 'HKEY_CLASSES_ROOT') then
        RootKey:= HKEY_CLASSES_ROOT
      else if (AName = 'HKU') or (AName = 'HKEY_USERS') then
        RootKey:= HKEY_USERS
      else if (AName = 'HKPD') or (AName = 'HKEY_PERFORMANCE_DATA') then
        RootKey:= HKEY_PERFORMANCE_DATA
      else if (AName = 'HKCC') or (AName = 'HKEY_CURRENT_CONFIG') then
        RootKey:= HKEY_CURRENT_CONFIG
      else if (AName = 'HKDD') or (AName = 'HKEY_DYN_DATA') then
        RootKey:= HKEY_DYN_DATA;
      AName:= Copy(ARegKey, i, MaxInt);
    end
    else AName:= ARegKey;
    (* if key exists, read key data *)
    if OpenKeyReadOnly(ExtractFilePath(AName)) then begin
      AName:= ExtractFileName(ARegKey);
      if not GetDataInfo(AName, Info) then
        Info.RegData:= rdUnknown;
      (* convert value to string *)
      case Info.RegData of
      rdString,
      rdExpandString:
        Result:= ReadString(AName);
      rdInteger:
        Result:= IntToStr(ReadInteger(AName));
      rdUnknown,
      rdBinary:
        begin
          GetMem(Buff, Info.DataSize);
          try
            ReadBinaryData(AName, Buff^, Info.DataSize);
            SetLength(Result, 2 * Info.DataSize);
            BinToHex(Buff, PChar(Result), Info.DataSize);
          finally
            FreeMem(Buff);
          end;
        end;
      end;
    end;
  finally
    Free;
  end;
end;

function GetFileText(const AFileName: string): string;
(* returns file text (searches editor and project enviroment too) *)
var
  AEditor: IEditor;
begin
  Result:= '';
  // look in open files
  AEditor:= GI_EditorFactory.GetEditorByNameOrTitle(AFileName);
  if Assigned(AEditor) then
    Result:= AEditor.GetSynEdit.Text
  else begin
    if FileExists(AFileName) then
      Result:= FileToStr(AFileName);
  end;
end;

function GetShortFileName(const APath: string): string;
(* returns short file name even for nonexisting files *)
begin
  if APath = '' then Result:= ''
  else begin
    Result:= PathGetShortName(APath);
    // if different - function is working
    if (Result = '') or
       (Result = APath) and not FileExists(PathRemoveSeparator(APath)) then
    begin
      Result:= ExtractFilePath(APath);
      // we are up to top level
      if (Result = '') or (Result[Length(Result)] = ':') then
        Result:= APath
      else Result:= Concat(GetShortFileName(PathRemoveSeparator(Result)),
                           PathDelim, ExtractFileName(APath));
    end;
  end;
end;

function GetActivePythonDir : string;
begin
  Result := IncludeTrailingPathDelimiter(SysModule.prefix);
end;

function GetPythonDir (VersionString : string) : string;
{$IFDEF MSWINDOWS}
var
  key : String;
  AllUserInstall : Boolean;
{$ENDIF}
begin
  Result := '';

  // Python provides for All user and Current user installations
  // All User installations place the Python DLL in the Windows System directory
  // and write registry info to HKEY_LOCAL_MACHINE
  // Current User installations place the DLL in the install path and
  // the registry info in HKEY_CURRENT_USER.
  // Hence, for Current user installations we need to try and find the install path
  // since it may not be on the system path.

  AllUserInstall := False;
  key := Format('\Software\Python\PythonCore\%s\InstallPath', [VersionString]);
  try
    with TRegistry.Create do
      try
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey(Key, False) then
          Result := ReadString('');
      finally
        Free;
      end;
  except
    // under WinNT, with a user without admin rights, the access to the
    // LocalMachine keys would raise an exception.
  end;
  // We do not seem to have an All User Python Installation.
  // Check whether we have a current user installation
  if not AllUserInstall then
    with TRegistry.Create do
      try
        RootKey := HKEY_CURRENT_USER;
        if OpenKey(Key, False) then
          Result := ReadString('');
      finally
        Free;
      end;

  if Result <> '' then
    Result := IncludeTrailingPathDelimiter(Result);
end;


function GetPythonVersion: string;
begin
  Result := SysModule.version;
end;

procedure RegisterStandardParametersAndModifiers;
begin
  with Parameters do begin
    (* parameters, valid for current Windows configuration *)
    // Python Paths etc.
    RegisterParameter('Python23Dir', GetPythonDir('2.3'), nil);
    RegisterParameter('Python24Dir', GetPythonDir('2.4'), nil);
    RegisterParameter('Python25Dir', GetPythonDir('2.5'), nil);
    RegisterParameter('Python23Exe', '$[PYTHON23DIR]python.exe', nil);
    RegisterParameter('Python24Exe', '$[PYTHON24DIR]python.exe', nil);
    RegisterParameter('Python25Exe', '$[PYTHON25DIR]python.exe', nil);
    RegisterParameter('PythonDir', 'Directory of active python version', GetActivePythonDir);
    RegisterParameter('PythonExe', '$[PYTHONDIR]python.exe', nil);
    RegisterParameter('PythonVersion', 'Version of active Python', GetPythonVersion);

    // register system paths and parameters
    RegisterParameter('ProgramFiles', 'Program Files directory', GetProgramFilesFolder);
    RegisterParameter('CommonFiles', 'Common Files directory', GetCommonFilesFolder);
    RegisterParameter('Windows', 'Windows installation directory', GetWindowsFolder);
    RegisterParameter('WindowsSystem', 'Windows System directory', GetWindowsSystemFolder);
    RegisterParameter('WindowsTemp', 'Windows Temp Directory', GetWindowsTempFolder);
    RegisterParameter('MyDocuments', 'MyDocuments directory', GetPersonalFolder);
    RegisterParameter('Desktop', 'Desktop Directory', GetDesktopDirectoryFolder);

    // register parameters
    RegisterParameter('Paste', 'Clipboard As Text', GetClipboard);
    RegisterParameter('UserName', 'User Name', GetLocalUserName);
    RegisterParameter('CurrentDir', 'Current Directory', GetCurrentFolder);
    RegisterParameter('Exe', 'Executable Name', GetExe);

    // register parameter modifiers
    RegisterModifier('Path', 'Path of file', ExtractFilePath);
    RegisterModifier('Dir', 'Path without delimeter', ExtractFileDir);
    RegisterModifier('Name', 'File name', ExtractFileName);
    RegisterModifier('Ext', 'File Extension', ExtractFileExt);
    RegisterModifier('ExtOnly', 'File extension without "."', GetFileExt);
    RegisterModifier('NoExt', 'File name without extension', PathRemoveExtension);
    RegisterModifier('Drive', 'File drive', ExtractFileDrive);
    RegisterModifier('Full', 'Expanded file name', ExpandFileName);
    RegisterModifier('UNC', 'Expanded UNC file name', ExpandUNCFileName);
    RegisterModifier('Long', 'Long file name', GetLongFileName);
    RegisterModifier('Short', 'Short file name', GetShortFileName);
    RegisterModifier('Sep', 'Path with separator added', PathAddSeparator);
    RegisterModifier('NoSep', 'Path with final separator removed', PathRemoveSeparator);
    RegisterModifier('Type', 'File type', FileGetTypeName);
    RegisterModifier('Text', 'Contents of text file', FileToStr);
    RegisterModifier('Param', 'Command line parameter', GetParam);
    RegisterModifier('Reg', 'Value of registry key', GetReg);
    RegisterModifier('Env', 'Value of environment variable', GetEnvironmentVariable);
    RegisterModifier('UpperCase', 'Upper case of string', AnsiUpperCase);
    RegisterModifier('LowerCase', 'Lpper case of string', AnsiLowerCase);
    RegisterModifier('Quote', 'Quoted string', StrDefQuote);
    RegisterModifier('UnQuote', 'Unquoted string', StrUnquote);

   (* parameters, specific for PyScripter *)
    RegisterParameter('SelectFile', '$[-SelectFile]', nil);
    RegisterParameter('SelectedFile', '', nil);
    RegisterParameter('SelectDir', '$[-SelectDir]', nil);
    RegisterParameter('SelectedDir', '', nil);
    RegisterParameter('DateTime', 'Current Date and Time', GetDateTime);
    RegisterModifier('SelectFile', 'Select file', SelectFile);
    RegisterModifier('SelectDir', 'Select directory', SelectDir);
    RegisterModifier('Date', 'Date of a datetime value', GetDate);
    RegisterModifier('Time', 'Time of a datetime value', GetTime);
    RegisterModifier('FileDate', 'Date of a file', GetFileDate);
    RegisterModifier('DateCreate', 'Creation date of a file', GetFileDateCreate);
    RegisterModifier('DateWrite',  'Last modification date of a file', GetFileDateWrite);
    RegisterModifier('DateAccess', 'Last access date of a file', GetFileDateAccess);
    RegisterModifier('DateFormat', 'Formatted date', GetDateFormated);

    (* parameters, that change often in one syn session *)
    (* editor related *)
    RegisterParameter('ActiveDoc', 'Active Document Name', GetActiveDoc);
    RegisterParameter('ModFiles', 'Modified Files', GetModFiles);
    RegisterParameter('OpenFiles', 'Open Files', GetOpenFiles);
    RegisterParameter('CurWord', '$[-CurWord]', nil);
    RegisterParameter('CurLine', '$[-CurLine]', nil);
    RegisterParameter('SelText', '$[-SelText]', nil);
    RegisterModifier('EdText', 'Text of the active document or a file', GetFileText);
    RegisterModifier('CurWord', 'Current word in the active document', GetCurWord);
    RegisterModifier('CurLine', 'Current line in the active document', GetCurLine);
    RegisterModifier('SelText', 'Selected text in the active document', GetSelText);
  end;

end;

procedure UnRegisterStandardParametersAndModifiers;
begin
  // unregister parameter modifiers
  with Parameters do begin
   (* parameters, valid for current Windows configuration *)
    // Python Paths etc.
    UnRegisterParameter('Python24Dir');
    UnRegisterParameter('Python23Dir');
    UnRegisterParameter('Python24Exe');
    UnRegisterParameter('Python23Exe');
    UnRegisterParameter('PythonDir');
    UnRegisterParameter('PythonExe');
    UnRegisterParameter('PythonVersion');

    // unregister system paths and parameters
    UnRegisterParameter('ProgramFiles');
    UnRegisterParameter('CommonFiles');
    UnRegisterParameter('Windows');
    UnRegisterParameter('WindowsSystem');
    UnRegisterParameter('WindowsTemp');
    UnRegisterParameter('MyDocuments');
    UnRegisterParameter('Desktop');

    // unregister parameters
    UnRegisterParameter('Paste');
    UnRegisterParameter('UserName');
    UnRegisterParameter('CurrentDir');
    UnRegisterParameter('Exe');

    // unregister modifiers
    UnRegisterModifier('Path');
    UnRegisterModifier('Dir');
    UnRegisterModifier('Name');
    UnRegisterModifier('Ext');
    UnRegisterModifier('ExtOnly');
    UnRegisterModifier('NoExt');
    UnRegisterModifier('Drive');
    UnRegisterModifier('Full');
    UnRegisterModifier('UNC');
    UnRegisterModifier('Long');
    UnRegisterModifier('Short');
    UnRegisterModifier('Sep');
    UnRegisterModifier('NoSep');
    UnRegisterModifier('Type');
    UnRegisterModifier('Text');
    UnRegisterModifier('Param');
    UnRegisterModifier('Reg');
    UnRegisterModifier('Env');
    UnRegisterModifier('UpperCase');
    UnRegisterModifier('LowerCase');
    UnRegisterModifier('Quote');
    UnRegisterModifier('UnQuote');

   (* parameters, specific for syn *)
    UnRegisterParameter('SelectFile');
    UnRegisterParameter('SelectedFile');
    UnRegisterParameter('SelectDir');
    UnRegisterParameter('SelectedDir');
    UnRegisterParameter('DateTime');
    UnRegisterModifier('SelectFile');
    UnRegisterModifier('SelectDir');
    UnRegisterModifier('Date');
    UnRegisterModifier('Time');
    UnRegisterModifier('FileDate');
    UnRegisterModifier('DateCreate');
    UnRegisterModifier('DateWrite');
    UnRegisterModifier('DateAccess');
    UnRegisterModifier('DateFormat');

    (* parameters, that change often in one syn session *)
    (* editor related *)
    UnRegisterParameter('ActiveDoc');
    UnRegisterParameter('ModFiles');
    UnRegisterParameter('OpenFiles');
    UnRegisterParameter('CurWord');
    UnRegisterParameter('CurLine');
    UnRegisterParameter('SelText');
    UnRegisterModifier('EdText');
    UnRegisterModifier('CurWord');
    UnRegisterModifier('CurLine');
    UnRegisterModifier('SelText');
  end;
end;

procedure RegisterCustomParams;
Var
  i : integer;
  ParamName : string;
begin
  with Parameters do begin
    Clear;
    Modifiers.Clear;
    RegisterStandardParametersAndModifiers;
    for i := 0 to CustomParams.Count - 1 do begin
      ParamName := CustomParams.Names[i];
      if ParamName <> '' then
        RegisterParameter(ParamName, CustomParams.Values[ParamName], nil);
    end;
    Sort;
  end;
  CommandsDataModule.PrepareParameterCompletion;
end;

procedure UnRegisterCustomParams;
begin
  Parameters.Clear;
  Parameters.Modifiers.Clear;
  RegisterStandardParametersAndModifiers;
  Parameters.Sort;
end;


initialization
  CustomParams := TStringList.Create;
  RegisterStandardParametersAndModifiers;
  Parameters.Sort;

finalization
  FreeAndNil(CustomParams);
end.

