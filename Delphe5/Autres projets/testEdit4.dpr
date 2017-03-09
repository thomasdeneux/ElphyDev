program testEdit4;

uses
  Forms,
  Gedit4 in 'Gedit4.pas' {edit4},
  Efind1 in 'Efind1.pas' {GEditFind},
  Ereplace in 'Ereplace.pas' {GEditReplace};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tedit4, edit4);
  Application.CreateForm(TGEditFind, GEditFind);
  Application.CreateForm(TGEditReplace, GEditReplace);
  Application.Run;
end.
