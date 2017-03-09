program UtriEvt;

uses
  Forms,
  Utri1 in 'Utri1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
