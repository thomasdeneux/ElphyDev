program TestCPL;

uses
  Forms,
  MCPL1 in 'MCPL1.pas' {Main},
  Gedit2 in 'Gedit2.pas' {Gedit},
  MemoForm in 'memoForm.pas' {ViewText},
  Nexe2 in 'Nexe2.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TViewText, ViewText);
  Application.Run;
end.
