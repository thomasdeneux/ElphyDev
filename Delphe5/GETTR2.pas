unit getTr2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  geton0, StdCtrls, editcont,

  util1,stmdef, debug0;

type
  TgetTranslation2 = class(TgetOnOff1)
    Label1: TLabel;
    Lx: TLabel;
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
    CheckBNforth: TCheckBoxV;
    CheckOrtho: TCheckBoxV;
    CheckInitPos: TCheckBoxV;
    procedure CheckLockedClick(Sender: TObject);
    procedure CheckOnControlClick(Sender: TObject);
    procedure ChangePos(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    majPosD:procedure of object;
    onControlD,onLockD:procedure(v:boolean) of object;

    procedure updatePosition;override;
  end;

var
  getTranslation2: TgetTranslation2;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetTranslation2.upDatePosition;
begin
  enX.updateCtrl;
  enY.updateCtrl;

  enTheta0.updateCtrl;
  enDtON.updateCtrl;

  sbx.position:=roundL(100*Psingle(enX.advar)^);
  sby.position:=roundL(100*Psingle(enY.advar)^);

  sbTheta0.position:=roundL(Psingle(enTheta0.advar)^);
end;




procedure TgetTranslation2.CheckLockedClick(Sender: TObject);
begin
  if assigned(onLockD) then onLockD(Checklocked.checked);
end;

procedure TgetTranslation2.CheckOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then oncontrolD(CheckOnControl.checked);
end;

procedure TgetTranslation2.ChangePos(Sender: TObject);
begin
  if sender is TeditNum then TeditNum(sender).updatevar
  else
    with TscrollBar(sender) do
    begin
      case tag of
        1:begin
            Psingle(enX.adVar)^:=position/100;
            enX.updateCtrl;
          end;
        2:begin
            Psingle(enY.adVar)^:=position/100;
            enY.updateCtrl;
          end;

        3:begin
            Psingle(env0.adVar)^:=position/100;
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

Initialization
AffDebug('Initialization GETTR2',0);
{$IFDEF FPC}
{$I getTr2.lrs}
{$ENDIF}
end.
