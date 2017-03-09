unit Lineform;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,

  util1,editCont, Debug0,
  stmDef, Buttons,
  defForm;

type
  TLineForm = class(TgenForm)
    enX: TeditNum;
    SBx: TScrollBar;
    Lx: TLabel;
    Ly: TLabel;
    Ltheta: TLabel;
    enY: TeditNum;
    enTheta: TeditNum;
    SBy: TScrollBar;
    SBtheta: TScrollBar;
    CheckOnScreen: TCheckBoxV;
    Label1: TLabel;
    enColor: TeditNum;
    CheckOnControl: TCheckBoxV;
    CheckLocked: TCheckBoxV;
    procedure enXExit(Sender: TObject);
    procedure CheckOnScreenClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckOnControlClick(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    onScreenD,onControlD,onLockD:procedure(v:boolean) of object;

    procedure upDatePosition;  override;
    procedure updateTheta;     override;
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}


procedure TLineForm.enXExit(Sender: TObject);
begin
  if sender is TeditNum then
  begin
    TeditNum(sender).updatevar;
    if sender=enX then sbX.position:=round(Psingle(enX.advar)^*100)
    else
    if sender=enY then sbY.position:=round(Psingle(enY.advar)^*100)
    else
    if sender=enTheta then sbTheta.position:=round(Psingle(enTheta.advar)^);


  end
  else
  with TscrollBar(sender) do
  begin
    case tag of
      1: begin
           Psingle(enX.advar)^:=position/100;
           enX.updateCtrl;
         end;
      2: begin
           Psingle(enY.advar)^:=position/100;
           enY.updateCtrl;
         end;
      3: begin
           Psingle(enTheta.advar)^:=position;
           enTheta.updateCtrl;
         end;
    end;
  end;

  if assigned(majpos) then majPos;
end;

procedure TLineForm.upDatePosition;
  begin
    enX.updateCtrl;
    enY.updateCtrl;
    sbx.position:=roundL(Psingle(enX.advar)^*100);
    sby.position:=roundL(Psingle(enY.advar)^*100);
  end;

procedure TLineForm.upDateTheta;
  begin
    enTheta.updateCtrl;
    sbTheta.position:=roundI((Psingle(enY.advar)^));
  end;

procedure TLineForm.CheckOnScreenClick(Sender: TObject);
begin
  if  assigned(onScreenD) then onScreenD(CheckOnScreen.checked);
end;

procedure TLineForm.CheckOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then onControlD(checkOnControl.checked);
end;

procedure TLineForm.CheckLockedClick(Sender: TObject);
begin
  if assigned(onLockD) then onLockD(checkLocked.checked);
end;


procedure TLineForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then
    begin
      updateAllVar(self);
      if assigned(majpos) then majPos;
    end;
end;



Initialization
AffDebug('Initialization lineForm',0);
{$IFDEF FPC}
{$I Lineform.lrs}
{$ENDIF}
end.
