program NrnDrv;

uses
  Forms,
  NrnDrv1 in 'NrnDrv1.pas' {Form1},
  NrnCom1 in 'NrnCom1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
