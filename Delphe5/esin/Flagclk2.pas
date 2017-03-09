unit flagClk2;

INTERFACE

uses  Windows, SysUtils;

var
  getFlagClock:function :boolean;

  InstalleFlagClock:function (t:smallInt):boolean;

  DesinstalleFlagClock:procedure ;


IMPLEMENTATION

var
  DLLhandle:Thandle;



initialization
DLLhandle:=loadLibrary('FCLK32.DLL');

getFlagClock := GetProcAddress(DLLHandle,'getFlagClock' );
InstalleFlagClock := GetProcAddress(DLLHandle,'InstalleFlagClock' );
DesinstalleFlagClock := GetProcAddress(DLLHandle,'DesinstalleFlagClock' );


finalization
freeLibrary(DLLhandle);

end.

