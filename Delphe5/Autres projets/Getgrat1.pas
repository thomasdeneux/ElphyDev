unit Getgrat1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,

  util1,editCont,
  stmDef, Buttons,
  defForm;

type
  TgetGrating1 = class(TgenForm)
    enX: TeditNum;
    SBx: TScrollBar;
    Lx: TLabel;
    Ly: TLabel;
    Ldx: TLabel;
    Ldy: TLabel;
    Ltheta: TLabel;
    enY: TeditNum;
    enDX: TeditNum;
    enDY: TeditNum;
    enTheta: TeditNum;
    SBy: TScrollBar;
    SBdx: TScrollBar;
    SBdy: TScrollBar;
    SBtheta: TScrollBar;
    Label1: TLabel;
    enContrast: TeditNum;
    enPeriod: TeditNum;
    Label3: TLabel;
    enPhase: TeditNum;
    Label4: TLabel;
    CheckLocked: TCheckBox;
    CheckOnControl: TCheckBox;
    CheckOnScreen: TCheckBox;
    procedure enXExit(Sender: TObject);
    procedure CheckOnScreenClick(Sender: TObject);
    procedure CheckOnControlClick(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations private }
    deg0:^typeDegre;
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

{$R *.DFM}

procedure TgetGrating1.setDeg(var deg:typeDegre;OnScr,onCont,lock:boolean);
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

  enDX.setVar(deg.dx,T_single);
  enDX.setMinMax(2,1000);
  enDX.Decimal:=0;
  sbDX.setParams(roundI(deg.dx),0,SSwidth);

  enDY.setVar(deg.dy,T_single);
  enDY.setMinMax(2,1000);
  enDY.Decimal:=0;
  sbDY.setParams(roundI(deg.dy),0,SSheight);

  enTheta.setVar(deg.theta,T_single);
  enTheta.setMinMax(-360,360);
  sbTheta.setParams(roundI(deg.theta),-360,360);

  CheckOnScreen.checked:=onscr;
  CheckOnControl.checked:=onCont;
  CheckLocked.checked:=lock;

  Fupdate:=false;
end;



procedure TgetGrating1.enXExit(Sender: TObject);
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
            dx:=position;
            enDX.updateCtrl;
          end;
        4:begin
            dy:=position;
            enDY.updateCtrl;
          end;
        5:begin
            theta:=position;
            enTheta.updateCtrl;
          end;
      end;
    end;

    if assigned(majpos) then majPos;
  end;
end;

procedure TgetGrating1.upDatePosition;
  begin
    Fupdate:=true;
    enX.updateCtrl;
    enY.updateCtrl;
    sbx.position:=roundI(deg0^.x);
    sby.position:=roundI(deg0^.y);
    Fupdate:=false;
  end;

procedure TgetGrating1.upDateSize;
  begin
    Fupdate:=true;
    enDX.updateCtrl;
    sbDX.position:=roundI(deg0^.dx);
    enDY.updateCtrl;
    sbDY.position:=roundI(deg0^.dy);
    Fupdate:=false;
  end;

procedure TgetGrating1.upDateTheta;
  begin
    Fupdate:=true;
    enTheta.updateCtrl;
    sbTheta.position:=roundI(deg0^.theta);
    Fupdate:=false;
  end;

procedure TgetGrating1.CheckOnScreenClick(Sender: TObject);
begin
  if  assigned(onScreenD) then onScreenD(checkOnScreen.checked);
end;

procedure TgetGrating1.CheckOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then onControlD(checkOnControl.checked);
end;

procedure TgetGrating1.CheckLockedClick(Sender: TObject);
begin
  if assigned(onLockD) then onLockD(checkLocked.checked);
end;


procedure TgetGrating1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then VKreturn;
end;


end.
