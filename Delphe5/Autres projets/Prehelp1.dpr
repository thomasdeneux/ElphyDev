program PreHelp1;

uses
  Forms,
  mphlp1 in 'mpHlp1.pas' {Mhlp},
  Precomp0 in 'precomp0.pas',
  ElphyHead in 'ElphyHead.pas' {ElphyEntete};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMhlp, Mhlp);
  Application.CreateForm(TElphyEntete, ElphyEntete);
  Application.Run;
end.
