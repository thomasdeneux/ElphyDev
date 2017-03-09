unit Gettrans;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,
  util1,defForm;

type
  TgetTranslation = class(TgenForm)
    Label1: TLabel;
    Lx: TLabel;
    enX: TeditNum;
    SBx: TScrollBar;
    Ly: TLabel;
    enY: TeditNum;
    SBy: TScrollBar;
    Label2: TLabel;
    enDtON: TeditNum;
    Label3: TLabel;
    Label4: TLabel;
    enV0: TeditNum;
    sbV0: TScrollBar;
    Label5: TLabel;
    enTheta0: TeditNum;
    sbTheta0: TScrollBar;
    enDtOff: TeditNum;
    Label6: TLabel;
    Label7: TLabel;
    enCycleCount: TeditNum;
    CheckLocked: TCheckBoxV;
    CheckOnControl: TCheckBoxV;
    sbDtOn: TScrollBar;
    sbDtOff: TScrollBar;
    sbCycles: TScrollBar;
    procedure SBxChange(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
    procedure CheckOnControlClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations private }

  public
    { Déclarations public }
    VonControl,Vlocked:boolean;
    majPosD:procedure of object;
    onControlD,onLockD:procedure(v:boolean) of object;

    procedure updatePosition;override;
  end;


implementation

{$R *.DFM}
procedure TgetTranslation.SBxChange(Sender: TObject);
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

        5:begin
            Plongint(enDtON.adVar)^:=position;
            enDtON.updateCtrl;
          end;
        6:begin
            Plongint(enDtOff.adVar)^:=position;
            enDtOff.updateCtrl;
          end;
        7:begin
            Pinteger(enCycleCount.adVar)^:=position;
            enCycleCount.updateCtrl;
          end;

      end;
    end;
  if assigned(majPosD) then majPosD;
end;

procedure TgetTranslation.upDatePosition;
  begin
    enX.updateCtrl;
    enY.updateCtrl;

    enTheta0.updateCtrl;
    enDtON.updateCtrl;

    sbx.position:=roundI(Psingle(enX.advar)^);
    sby.position:=roundI(Psingle(enY.advar)^);

    sbTheta0.position:=roundI(Psingle(enTheta0.advar)^);
    sbDtON.position:=Plongint(enDtON.advar)^;

  end;


procedure TgetTranslation.CheckLockedClick(Sender: TObject);
begin
  checkLocked.updateVar;
  if assigned(onLockD) then onLockD(Vlocked);
end;

procedure TgetTranslation.CheckOnControlClick(Sender: TObject);
begin
  checkOnControl.updateVar;
  if assigned(onControlD) then oncontrolD(VonControl);
end;

procedure TgetTranslation.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then
    begin
      updateAllVar(self);
      if assigned(majposD) then majPosD;
    end;
end;

end.
