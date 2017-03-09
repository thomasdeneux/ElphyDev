unit Sysopt1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont;

type
  TSysOpt = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
  private
    { Déclarations private }
  public
    { Déclarations public }
    function execution(var nbCol,nbLig:integer):boolean;
  end;

var
  SysOpt: TSysOpt;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

function TsysOpt.execution(var nbCol,nbLig:integer):boolean;
  var
    ok:boolean;
  begin
    editNum1.setvar(nbLig,T_smallint);
    editNum1.setMinMax(1,32767);
    editNum2.setvar(nbCol,T_smallint);
    editNum2.setMinMax(1,12);

    ok:= (showModal=mrOk);

    if ok then
      begin
         ok:= MessageDlg('Spreadsheet data will be erased. Continue ?',
               mtConfirmation, [mbYes, mbNo], 0) = mrYes ;

         if ok then updateAllVar(self);
      end;

    execution:=ok;
  end;

Initialization
AffDebug('Initialization Sysopt1',0);
  {$IFDEF FPC}
  {$I Sysopt1.lrs}
  {$ENDIF}
end.
