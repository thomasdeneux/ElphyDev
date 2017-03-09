unit Dprocess;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,debug0;

var
  timeProcess:integer;
    { compteur  incr�ment� � chaque cycle
      resetProcess le met � -1
      vaut 0 apr�s le premier executeProcess
    }

type
   TProcessProcedure = procedure of object;


procedure installeProcess(p: TProcessProcedure);
  { Installe une m�thode dans la table des processus }


procedure ExecuteProcess;
procedure ResetProcess;

IMPLEMENTATION


var
  Process: array of TprocessProcedure;


procedure ExecuteProcess;
var
  i:Integer;
begin
  inc(timeProcess);                     { � t=0 , on pr�pare la premi�re  stimulation }
  for i:=0 to high(Process) do Process[i];
end;

procedure installeProcess(p: TprocessProcedure);
begin
  setLength(Process,length(Process)+1);
  Process[high(process)]:=p;
end;


procedure resetProcess;
begin
  setLength(Process,0);
  timeProcess:=-1;
end;


Initialization
AffDebug('Initialization Dprocess',0);


finalization

end.
