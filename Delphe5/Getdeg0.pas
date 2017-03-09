unit Getdeg0;

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
  TDegform = class(TGenForm)
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
    procedure SBxChange(Sender: TObject);
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

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TDegform.setDeg(var deg:typeDegre;OnScr,onCont,lock:boolean);
begin
  deg0:=@deg;
  Fupdate:=true;
  enX.setVar(deg.x,T_single);
  enX.setMinMax(-degXmax,degXmax);
  enX.Decimal:=2;
  sbX.setParams(roundI( (DegXmax+deg.x)*100),0,roundI(DegXmax*200));

  enY.setVar(deg.y,T_single);
  enY.setMinMax(-degYmax,degYmax);
  enY.Decimal:=2;
  sbY.setParams(roundI((DegYmax+deg.y)*100),0,roundI(DegYmax*200));

  enDX.setVar(deg.dx,T_single);
  enDX.setMinMax(DDegMin*2,100);
  enDX.Decimal:=2;
  sbDX.setParams(roundI(deg.dx*100),0,roundI(DegXmax*200));

  enDY.setVar(deg.dy,T_single);
  enDY.setMinMax(DdegMin*2,100);
  enDY.Decimal:=2;
  sbDY.setParams(roundI(deg.dy*100),0,roundI(DegYmax*200));

  enTheta.setVar(deg.theta,T_single);
  enTheta.setMinMax(-360,360);
  sbTheta.setParams(roundI(deg.theta),-360,360);

  enLum.setVar(deg.lum,T_single);
  enLum.setMinMax(0,100);

  CheckOnScreen.checked:=onScr;
  CheckOnControl.checked:=onCont;
  CheckLocked.checked:=lock;

  Fupdate:=false;
end;



procedure TDegform.enXExit(Sender: TObject);
begin
  if Fupdate then exit;

  TeditNum(sender).updatevar;
  case TeditNum(sender).tag of
    1: sbX.position:=round((DegXmax+deg0^.x)*100);
    2: sbY.position:=round((DegYmax+deg0^.y)*100);
    3: sbDx.position:=round(deg0^.dx*100);
    4: sbDy.position:=round(deg0^.dy*100);
    5: sbTheta.position:=round(deg0^.theta);
  end;

  if assigned(majpos) then majPos;
end;

procedure TDegform.SBxChange(Sender: TObject);
begin
  with TscrollBar(sender) do
  case tag of
    1:begin
        deg0^.x:=position/100-DegXmax;
        enX.updateCtrl;
      end;
    2:begin
        deg0^.y:=position/100-DegYmax;
        enY.updateCtrl;
      end;
    3:begin
        deg0^.dx:=position/100;
        enDX.updateCtrl;
      end;
    4:begin
        deg0^.dy:=position/100;
        enDY.updateCtrl;
      end;
    5:begin
        deg0^.theta:=position;
        enTheta.updateCtrl;
      end;
  end;
  if assigned(majpos) then majPos;

end;



procedure TDegform.upDatePosition;
  begin
    Fupdate:=true;
    enX.updateCtrl;
    enY.updateCtrl;
    sbX.position:=round((DegXmax+deg0^.x)*100);
    sbY.position:=round((DegYmax+deg0^.y)*100);;
    Fupdate:=false;
  end;

procedure TDegform.upDateSize;
  begin
    Fupdate:=true;
    enDX.updateCtrl;
    sbDX.position:=roundI(deg0^.dx*100);
    enDY.updateCtrl;
    sbDY.position:=roundI(deg0^.dy)*100;
    Fupdate:=false;
  end;

procedure TDegform.upDateTheta;
  begin
    Fupdate:=true;
    enTheta.updateCtrl;
    sbTheta.position:=roundI(deg0^.theta);
    Fupdate:=false;
  end;

procedure TDegform.CheckOnScreenClick(Sender: TObject);
begin
  if  assigned(onScreenD) then onScreenD(CheckOnScreen.checked);
end;

procedure TDegform.CheckOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then onControlD(checkOnControl.checked);
end;

procedure TDegform.CheckLockedClick(Sender: TObject);
begin
  if assigned(onLockD) then onLockD(checkLocked.checked);
end;


procedure TDegform.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then VKreturn;
end;




Initialization
AffDebug('Initialization Getdeg0',0);
{$IFDEF FPC}
{$I Getdeg0.lrs}
{$ENDIF}
end.
