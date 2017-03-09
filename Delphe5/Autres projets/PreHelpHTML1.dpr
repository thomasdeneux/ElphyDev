program PreHelpHTML1;

uses
  Forms,
  MpHlpHTML in 'MpHlpHTML.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
