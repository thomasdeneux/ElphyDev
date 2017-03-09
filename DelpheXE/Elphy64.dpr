program Elphy64;

uses
  Vcl.Forms,
  multg0 in '..\Delphe5\multg0.pas' {MultiGform},
  mdac in '..\Delphe5\mdac.pas' {MainDac},
  FrameTable1 in '..\Delphe5\FrameTable1.pas' {TableFrame: TFrame},
  stmFunc1 in '..\delphe5\stmFunc1.pas',
  FuncProp in '..\Delphe5\FuncProp.pas' {FunctionProp},
  fitprop in '..\Delphe5\fitprop.pas',
  cyberKbrd2 in '..\Delphe5\cyberKbrd2.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.ModalPopupMode:=pmNone;        // This two properties
  Application.MainFormOnTaskbar := false;    // set the behaviour of stayOnTop Windows and dialogs

  Application.CreateForm(TMainDac, MainDac);
  Application.Run;
end.
