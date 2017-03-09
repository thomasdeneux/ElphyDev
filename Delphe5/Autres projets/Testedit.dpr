program TestEdit;

uses
  Forms,
  Gedit1 in 'Gedit1.pas' {Gedit},
  Ereplace in 'Ereplace.pas' {GEditReplace},
  Efind1 in 'Efind1.pas' {GEditFind};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGedit, Gedit);
  Application.CreateForm(TGEditReplace, GEditReplace);
  Application.CreateForm(TGEditFind, GEditFind);
  Application.Run;
end.
