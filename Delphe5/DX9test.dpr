program DX9test;

uses
  Forms,
  DX9test1 in 'DX9test1.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
