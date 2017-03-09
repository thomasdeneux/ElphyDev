unit DXCommon;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows;

type
{$IFDEF UNICODE}
  PCharAW = PWideChar;
{$ELSE}
  PCharAW = PAnsiChar;
{$ENDIF}
  
function IsNTandDelphiRunning : boolean;
function RegGetStringValue(Hive: HKEY; const KeyName, ValueName: AnsiString): AnsiString;
function ExistFile(const FileName: AnsiString): Boolean;

implementation

function RegGetStringValue(Hive: HKEY; const KeyName, ValueName: AnsiString): AnsiString;
var EnvKey  : HKEY;
    Buf     : array[0..255] of char;
    BufSize : DWord;
    RegType : DWord;
    rc      : DWord;
begin
  Result := '';
  BufSize := Sizeof(Buf);
  ZeroMemory(@Buf, BufSize);
  RegType := REG_SZ;
  try
    if (RegOpenKeyEx(Hive, Pansichar(KeyName), 0, KEY_READ, EnvKey) = ERROR_SUCCESS) then
    begin
      try
        if (ValueName = '') then rc := RegQueryValueEx(EnvKey, nil, nil, @RegType, @Buf, @BufSize)
          else rc := RegQueryValueEx(EnvKey, Pansichar(ValueName), nil, @RegType, @Buf, @BufSize);
        if rc = ERROR_SUCCESS then Result := AnsiString(Buf);
      finally
        RegCloseKey(EnvKey);
      end;
    end;
  finally
    RegCloseKey(Hive);
  end;
end;


function ExistFile(const FileName: AnsiString): Boolean;
var hFile: THandle;
begin
  hFile := CreateFile(Pansichar(FileName), 0, 0, nil, OPEN_EXISTING, 0, 0);
  Result := hFile <> INVALID_HANDLE_VALUE;
  if Result = true then CloseHandle(hFile);
end;


function IsNTandDelphiRunning : boolean;
var
  OSVersion  : TOSVersionInfo;
  ProgName   : array[0..255] of char;
begin
  OSVersion.dwOsVersionInfoSize := sizeof(OSVersion);
  GetVersionEx(OSVersion);
  ProgName[0] := #0;
  lstrcat(ProgName, Pansichar(ParamStr(0)));
  CharLowerBuff(ProgName, SizeOf(ProgName));
  // Not running in NT or program is not Delphi itself ?
  result := ( (OSVersion.dwPlatformID = VER_PLATFORM_WIN32_NT) and
              (Pos('delphi32.exe', AnsiString(ProgName)) > 0) );
end;


end.
 
