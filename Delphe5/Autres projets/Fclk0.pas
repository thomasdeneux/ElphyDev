unit Fclk0;

interface

uses MMsystem;

function getFlagClock:boolean;export;
function InstalleFlagClock(t:smallInt):boolean;export;
procedure DesinstalleFlagClock;export;

Implementation

var
  id:integer;
  periode:integer;
var
  flag:boolean;


{Remarque importante:
 Le module MMSystem.pas de Delphi 2 contient une erreur!
 la procédure TFNTimeCallBack est déclarée sans la directive StdCall, or cette
 directive est obligatoire pour toutes les callback functions de Windows.

 Du coup, TimeSetEvent refuse MajFlag comme argument alors que la fonction
 ci-dessous est parfaitement corecte.
 On s'en tire en écrivant @MajFlag au lieu de MajFlag.
}

procedure MajFlag(id:integer;msg:integer;user:integer;dw1,dw2:integer);stdCall;
  begin
    flag:=true;
  end;

function getFlagClock:boolean;
  begin
    getFlagClock:=flag;
    flag:=false;
  end;


function InstalleFlagClock(t:smallInt):boolean;
  var
    tc:TTimeCaps;
  begin
    periode:=t;
    timeGetDevCaps(@tc,sizeof(tc));

    if (tc.wPeriodMin>Periode) or (tc.wPeriodMax<Periode) then
      begin
        InstalleFlagClock:=false;
        exit;
      end;

    flag:=false;
    TimeBeginPeriod(periode);
    id:=TimeSetEvent(periode,periode div 2,@MajFlag,0,Time_Periodic);
    InstalleFlagClock:=true;
  end;


procedure DesinstalleFlagClock;
  begin
    timeKillEvent(id);
    timeEndPeriod(periode);
  end;

end.

