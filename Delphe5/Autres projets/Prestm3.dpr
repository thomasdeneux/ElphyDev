program PreStm3;

uses
  Forms,
  mphlp1 in 'mphlp1.pas' {Mhlp};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMhlp, Mhlp);
  Application.Run;
end.
