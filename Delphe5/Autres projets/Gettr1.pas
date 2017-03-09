unit getTr1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stimForm, StdCtrls, editcont,
  util1;

type
  TgetTranslation1 = class(TStimulusForm)   {Il aurait été plus astucieux de }
    Label1: TLabel;                         { faire hériter TgetTranslation1 }
    Lx: TLabel;                             { de TgetOnOff }
    Ly: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    enX: TeditNum;
    SBx: TScrollBar;
    enY: TeditNum;
    SBy: TScrollBar;
    enV0: TeditNum;
    sbV0: TScrollBar;
    enTheta0: TeditNum;
    sbTheta0: TScrollBar;
    CheckLocked: TCheckBox;
    CheckOnControl: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    enDtON: TeditNum;
    enDtOff: TeditNum;
    enCycleCount: TeditNum;
    enDelay: TeditNum;
    procedure sbxChange(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
    procedure CheckOnControlClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    majPosD:procedure of object;
    onControlD,onLockD:procedure(v:boolean) of object;

    procedure updatePosition;override;
  end;

var
  getTranslation1: TgetTranslation1;

implementation

{$R *.DFM}

procedure TgetTranslation1.sbxChange(Sender: TObject);
begin
  if sender is TeditNum then TeditNum(sender).updatevar
  else
    with TscrollBar(sender) do
    begin
      case tag of
        1:begin
            Psingle(enX.adVar)^:=position;
            enX.updateCtrl;
          end;
        2:begin
            Psingle(enY.adVar)^:=position;
            enY.updateCtrl;
          end;

        3:begin
            Psingle(env0.adVar)^:=position/60;
            env0.updateCtrl;
          end;
        4:begin
            Psingle(entheta0.adVar)^:=position;
            enTheta0.updateCtrl;
          end;
      end;
    end;
  if assigned(majPos) then majPos;
end;

procedure TgetTranslation1.upDatePosition;
  begin
    enX.updateCtrl;
    enY.updateCtrl;

    enTheta0.updateCtrl;
    enDtON.updateCtrl;

    sbx.position:=roundI(Psingle(enX.advar)^);
    sby.position:=roundI(Psingle(enY.advar)^);

    sbTheta0.position:=roundI(Psingle(enTheta0.advar)^);
  end;


procedure TgetTranslation1.CheckLockedClick(Sender: TObject);
begin
  if assigned(onLockD) then onLockD(Checklocked.checked);
end;

procedure TgetTranslation1.CheckOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then oncontrolD(CheckOnControl.checked);
end;

end.
