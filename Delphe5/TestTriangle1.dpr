program TestTriangle1;

uses
  Forms,
  Utriangle in 'Utriangle.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
