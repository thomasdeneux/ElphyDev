program NrnDrv2;

uses
  Forms,
  NrnDrvUnit1 in 'NrnDrvUnit1.pas' {NrnConsole};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNrnConsole, NrnConsole);
  Application.Run;
end.
