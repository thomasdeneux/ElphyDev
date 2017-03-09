program NSdllTest;

uses
  Forms,
  TestNsDll in 'TestNsDll.pas' {NeuroShareTest},
  nsLib in 'nsLib.pas',
  FrameTable1 in 'FrameTable1.pas' {TableFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNeuroShareTest, NeuroShareTest);
  Application.Run;
end.
