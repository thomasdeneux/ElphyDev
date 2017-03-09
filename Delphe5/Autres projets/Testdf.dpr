program Testdf;

uses
  Forms,
  TESTDF1 in 'TESTDF1.PAS' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
