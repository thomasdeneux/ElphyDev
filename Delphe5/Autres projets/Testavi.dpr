program testavi;

uses
  Forms,
  Uavi1 in 'Uavi1.pas' {Form1},
  RLE0 in 'RLE0.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
