program ChrisProject;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FormTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTest, FormTest);
  Application.Run;
end.
