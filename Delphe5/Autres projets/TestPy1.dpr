program TestPy1;

uses
  Forms,
  UnitPy2 in 'UnitPy2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
