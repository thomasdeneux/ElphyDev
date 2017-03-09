unit getMseq1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stimForm, StdCtrls, editcont, Debug0;

type
  TgetMseq = class(TstimulusForm)
    Label1: TLabel;
    Label2: TLabel;
    enLum1: TeditNum;
    Label4: TLabel;
    enLum2: TeditNum;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    enSeed: TeditNum;
    cbOnControl: TCheckBox;
    cbOnScreen: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    enDtON: TeditNum;
    enDtOff: TeditNum;
    enCycleCount: TeditNum;
    enDelay: TeditNum;
    Button1: TButton;
    CBadjust: TCheckBoxV;
    enOrder: TeditNum;
    Label7: TLabel;
    cbDivX: TcomboBoxV;
    cbDivY: TcomboBoxV;
    cbExpansion: TcomboBoxV;
    procedure Button1Click(Sender: TObject);
    procedure cbOnControlClick(Sender: TObject);
    procedure cbOnScreenClick(Sender: TObject);
    procedure enOrderChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    selectRFD:procedure of object;
    onControlD,onScreenD:procedure(v:boolean) of object;
    orderChangeD:procedure of object;
  end;

var
  getMseq: TgetMseq;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetMseq.Button1Click(Sender: TObject);
begin
  if assigned(selectRFD) then selectRFD;
end;

procedure TgetMseq.cbOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then onControlD(cbOnControl.checked);
end;

procedure TgetMseq.cbOnScreenClick(Sender: TObject);
begin
  if assigned(onScreenD) then onScreenD(cbOnScreen.checked);
end;

procedure TgetMseq.enOrderChange(Sender: TObject);
begin
  enOrder.updateVar;
  if assigned(OrderChangeD) then OrderChangeD;
  enCycleCount.updateCtrl;
end;

Initialization
AffDebug('Initialization getMseq1',0);
{$IFDEF FPC}
{$I getMseq1.lrs}
{$ENDIF}
end.
