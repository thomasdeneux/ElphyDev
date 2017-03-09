program PreCPL;

uses
  Forms,
  PreCPL1 in 'PreCPL1.pas' {Main};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
