program ConvIPP;



uses
  Forms,
  IPPAPIconv0 in 'IPPAPIconv0.pas' {Form1},
  UlexC in 'UlexC.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
