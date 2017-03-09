program TestProj;

uses
  Forms,
  TestDD in 'TestDD.pas' {Form1},
  DirectX in 'DirectX.pas';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

