unit InstallStdTools;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  util1, Gdos,
  stmdef,stmObj,Imacro1,MacMan1;

type
  TInstallStdToolsDlg = class(TForm)
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Bcancel: TButton;
    Button2: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execute;
  end;

var
  InstallStdToolsDlg: TInstallStdToolsDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TInstallStdToolsDlg }



procedure TInstallStdToolsDlg.execute;
var
  stf,stTitle:AnsiString;
begin
{  if showModal=mrOK then
    TmacroManager(DacMacroMan).InstallFilesAsTools(AppData+'*.pg2');
}
end;

Initialization
AffDebug('Initialization InstallStdTools',0);
{$IFDEF FPC}
{$I InstallStdTools.lrs}
{$ENDIF}
end.
