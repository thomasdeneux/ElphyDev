program DBtest1;

uses
  Forms,
  Mdb1 in 'Mdb1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
