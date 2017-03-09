unit flagClk0;

INTERFACE             

function getFlagClock:boolean;
function InstalleFlagClock(t:smallInt):boolean;
procedure DesinstalleFlagClock;


IMPLEMENTATION

function getFlagClock:boolean;
     external  {$IFDEF win32}'Fclk32.dll'{$ELSE}'FlagClk'{$ENDIF} index 1;
function InstalleFlagClock(t:smallInt):boolean;
     external  {$IFDEF win32}'Fclk32.dll'{$ELSE}'FlagClk'{$ENDIF} index 2;
procedure DesinstalleFlagClock;
     external  {$IFDEF win32}'Fclk32.dll'{$ELSE}'FlagClk'{$ENDIF} index 3;

end.