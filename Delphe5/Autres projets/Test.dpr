program test;

uses
  Forms,
  test0 in 'test0.pas' {Form1},
  DisplayFrame1 in 'DisplayFrame1.pas' {DispFrame: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
