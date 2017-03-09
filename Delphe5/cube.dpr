program Cube;

uses
  Forms,
  MainCube in 'MainCube.pas' {MainForm},
  D3DUtils in '..\delphiX2000\Samples\d3dim\D3DUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Direct3D Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
