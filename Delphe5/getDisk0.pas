unit Getdisk0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  {$ENDIF}
  Windows,SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,

  util1,editCont,
  stmDef, Buttons,
  defForm,
  debug0;

type
  TDiskForm = class(TgenForm)
    enX: TeditNum;
    SBx: TScrollBar;
    Lx: TLabel;
    Ly: TLabel;
    Ldx: TLabel;
    Ltheta: TLabel;
    enY: TeditNum;
    enDiam: TeditNum;
    enTheta: TeditNum;
    SBy: TScrollBar;
    SBdiam: TScrollBar;
    SBtheta: TScrollBar;
    Label1: TLabel;
    enLum: TeditNum;
    CheckLocked: TCheckBox;
    CheckOnScreen: TCheckBox;
    CheckOnControl: TCheckBox;
    procedure enXExit(Sender: TObject);
    procedure CheckOnScreenClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckOnControlClick(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
  private
    { Déclarations private }
    deg0:^typeDegre;
    Diam:single;
    Fupdate:boolean;
  public
    { Déclarations public }
    onScreenD,onControlD,onLockD:procedure(v:boolean) of object;

    procedure setDeg(var deg:typeDegre;onscr,onCont,lock:boolean);
    procedure upDatePosition;override;
    procedure upDateSize;    override;
    procedure updateTheta;   override;
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TDiskForm.setDeg(var deg:typeDegre;OnScr,onCont,lock:boolean);
begin
  deg0:=@deg;
  Fupdate:=true;
  enX.setVar(deg.x,T_single);
  enX.setMinMax(0,SSwidth-1);
  enX.Decimal:=0;
  sbX.setParams(roundI(deg.x),0,SSwidth-1);

  enY.setVar(deg.y,T_single);
  enY.setMinMax(0,SSheight-1);
  enY.Decimal:=0;
  sbY.setParams(roundI(deg.y),0,SSheight-1);


  if deg.dx<deg.dy then diam:=deg.dx else diam:=deg.dy;

  enDiam.setVar(diam,T_single);
  enDiam.setMinMax(2,1000);
  enDiam.Decimal:=0;
  sbDiam.setParams(roundI(diam),0,SSwidth);

  enTheta.setVar(deg.theta,T_single);
  enTheta.setMinMax(-360,360);
  sbTheta.setParams(roundI(deg.theta),-360,360);

  enLum.setVar(deg.lum,T_single);
  enLum.setMinMax(0,10000);

  CheckOnScreen.checked:=onscr;
  CheckOnControl.checked:=onCont;
  CheckLocked.checked:=lock;

  Fupdate:=false;
end;



procedure TDiskForm.enXExit(Sender: TObject);
begin
  if Fupdate then exit;

  with deg0^ do
  begin
    if sender is TeditNum then TeditNum(sender).updatevar
    else
    with TscrollBar(sender) do
    begin
      case tag of
        1:begin
            x:=position;
            enX.updateCtrl;
          end;
        2:begin
            y:=position;
            enY.updateCtrl;
          end;
        3:begin
            diam:=position;
            enDiam.updateCtrl;
          end;
        5:begin
            theta:=position;
            enTheta.updateCtrl;
          end;
      end;
    end;

    deg0^.dx:=diam;
    deg0^.dy:=diam;

    if assigned(majpos) then majPos;
  end;
end;

procedure TDiskForm.upDatePosition;
  begin
    Fupdate:=true;
    enX.updateCtrl;
    enY.updateCtrl;
    sbx.position:=roundI(deg0^.x);
    sby.position:=roundI(deg0^.y);
    Fupdate:=false;
  end;

procedure TDiskForm.upDateSize;
  begin
    if deg0^.dx<deg0^.dy then diam:=deg0^.dx else diam:=deg0^.dy;

    Fupdate:=true;
    enDiam.updateCtrl;
    sbDiam.position:=roundI(deg0^.dx);
    Fupdate:=false;
  end;

procedure TDiskForm.upDateTheta;
  begin
    Fupdate:=true;
    enTheta.updateCtrl;
    sbTheta.position:=roundI(deg0^.theta);
    Fupdate:=false;
  end;

procedure TDiskForm.CheckOnScreenClick(Sender: TObject);
begin
  if  assigned(onScreenD) then onScreenD(checkOnScreen.checked);
end;

procedure TDiskForm.CheckOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then onControlD(checkOnControl.checked);
end;

procedure TDiskForm.CheckLockedClick(Sender: TObject);
begin
  if assigned(onLockD) then onLockD(checkLocked.checked);
end;


procedure TDiskForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then
    begin
      updateAllVar(self);
      if assigned(majpos) then majPos;
    end;
end;



Initialization
AffDebug('Initialization getDisk0',0);
{$IFDEF FPC}
{$I Getdisk0.lrs}
{$ENDIF}
end.
