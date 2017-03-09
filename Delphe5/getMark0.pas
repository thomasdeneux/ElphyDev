unit getMark0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  defForm, StdCtrls, editcont,

  util1,stmDef,stmObj, debug0;

type
  TMarkForm = class(TgenForm)
    Lx: TLabel;
    Ly: TLabel;
    Label1: TLabel;
    enX: TeditNum;
    SBx: TScrollBar;
    enY: TeditNum;
    SBy: TScrollBar;
    CheckOnScreen: TCheckBoxV;
    enLum: TeditNum;
    CheckOnControl: TCheckBoxV;
    CheckLocked: TCheckBoxV;
    procedure enXExit(Sender: TObject);
    procedure CheckOnScreenClick(Sender: TObject);
    procedure CheckOnControlClick(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
  private
    { Déclarations privées }
    deg0:^typeDegre;
    Fupdate:boolean;
  public
    { Déclarations publiques }
    onScreenD,onControlD,onLockD:procedure(v:boolean) of object;

    procedure setDeg(var deg:typeDegre;onscr,onCont,lock:boolean);
    procedure upDatePosition;override;
  end;

var
  MarkForm: TMarkForm;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TmarkForm.setDeg(var deg:typeDegre;OnScr,onCont,lock:boolean);
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

  enLum.setVar(deg.lum,T_single);
  enLum.setMinMax(0,100);

  CheckOnScreen.checked:=onScr;
  CheckOnControl.checked:=onCont;
  CheckLocked.checked:=lock;

  Fupdate:=false;
end;




procedure TmarkForm.upDatePosition;
  begin
    Fupdate:=true;
    enX.updateCtrl;
    enY.updateCtrl;
    sbX.position:=round((DegXmax+deg0^.x)*100);
    sbY.position:=round((DegXmax+deg0^.y)*100);
    Fupdate:=false;
  end;



procedure TMarkForm.enXExit(Sender: TObject);
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
            x:=position/100-DegXmax;
            enX.updateCtrl;
          end;
        2:begin
            y:=position/100-DegXmax;
            enY.updateCtrl;
          end;
      end;
    end;

    if assigned(majpos) then majPos;
  end;
end;

procedure TMarkForm.CheckOnScreenClick(Sender: TObject);
begin
  if  assigned(onScreenD) then onScreenD(CheckOnScreen.checked);
end;

procedure TMarkForm.CheckOnControlClick(Sender: TObject);
begin
  inherited;
  if  assigned(onControlD) then onControlD(CheckOnControl.checked);
end;

procedure TMarkForm.CheckLockedClick(Sender: TObject);
begin
  inherited;
  if  assigned(onLockD) then onLockD(CheckLocked.checked);
end;

Initialization
AffDebug('Initialization getMark0',0);
{$IFDEF FPC}
{$I getMark0.lrs}
{$ENDIF}
end.
