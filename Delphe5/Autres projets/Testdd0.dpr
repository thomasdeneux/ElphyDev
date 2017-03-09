program TestDD0;

uses
  Forms,
  TestDD in 'TestDD.pas' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

