program winexec;

uses
  Forms,
  winexec1 in 'winexec1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
