unit printMG0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,
  printers,
  {$IFDEF FPC}
  PrintersDlgs,
  {$ENDIF}
  Dialogs, editcont,

  util1,Dgraphic, debug0;

type

  { TprintMgDialog }

  TprintMgDialog = class(TForm)
    C_print: TButton;
    C_setup: TButton;
    C_cancel: TButton;
    C_orientation: TRadioGroup;
    CBbitmap: TCheckBoxV;
    CBmono: TCheckBoxV;
    CBwhiteBK: TCheckBoxV;
    EScomment: TeditString;
    Lcomment: TLabel;
    C_printName: TCheckBoxV;
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    enMagFactor: TeditNum;
    Label2: TLabel;
    enSymbFactor: TeditNum;
    cbAutoSymb: TCheckBoxV;
    PrinterSetupDialog1: TPrinterSetupDialog;
    rbAspect: TRadioButton;
    rbWholePage: TRadioButton;
    cbAutoFont: TCheckBoxV;
    cbSplitMatrix: TCheckBoxV;
    Button2: TButton;
    procedure C_setupClick(Sender: TObject);
    procedure cbAutoSymbClick(Sender: TObject);
    procedure cbAutoFontClick(Sender: TObject);

  private
    { Private declarations }
    procedure setAutoSymb;
    procedure setAutoFont;

  public
    { Public declarations }
    function execution:integer;
  end;

function printMgDialog:TprintMgDialog;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FprintMgDialog: TprintMgDialog;

function printMgDialog:TprintMgDialog;
begin
  if not assigned(FprintMgDialog) then FprintMgDialog:= TprintMgDialog.Create(nil);
  result:= FprintMgDialog;
end;

procedure TprintMgDialog.setAutoSymb;
begin
  enSymbFactor.enabled:=not PRautoSymb;
end;

procedure TprintMgDialog.setAutoFont;
begin
  enMagFactor.enabled:=not PRautoFont;
end;


function TprintMgDialog.execution:integer;
  begin
    CBbitmap.setvar(PRdraft);
    CBwhiteBK.setvar(PRwhiteBackGnd);
    CBmono.setvar(PRmonochrome);
    CBsplitMatrix.setVar(PRsplitMatrix);

    C_orientation.itemIndex:=ord(PRLandScape);
    C_printname.setvar(PRprintName);


    rbAspect.checked:=PRkeepAspectRatio;
    rbWholePage.checked:=not PRkeepAspectRatio;

    enMagFactor.setVar(PRfontMag,t_single);
    enMagFactor.setMinMax(0.2,5);

    enSymbFactor.setVar(PRSymbMag,t_single);
    enSymbFactor.setMinMax(1,20);

    cbAutoSymb.setvar(PRautoSymb);

    cbAutoFont.setvar(PRautoFont);


    esComment.setvar(PrintComment,sizeof(printComment)-1);

    setAutoSymb;
    setAutoFont;

    result:=showModal;
    if result<>0 then
      begin
        updateAllVar(self);
        PRLandScape:=(C_orientation.itemIndex=1);
        PRkeepAspectRatio:=rbAspect.checked;
      end;
  end;


procedure TprintMgDialog.C_setupClick(Sender: TObject);
begin
  PrinterSetupDialog1.execute;
end;

procedure TprintMgDialog.cbAutoSymbClick(Sender: TObject);
begin
  cbAutoSymb.updateVar;
  setAutoSymb;
end;

procedure TprintMgDialog.cbAutoFontClick(Sender: TObject);
begin
  cbAutoFont.updateVar;
  setAutoFont;
end;


Initialization
AffDebug('Initialization printMG0',0);
{$IFDEF FPC}
{$I printMG0.lrs}
{$ENDIF}
end.


