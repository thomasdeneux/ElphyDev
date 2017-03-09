unit LoadFromMat1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ComCtrls, SyslistTreeView, Buttons, StdCtrls, editcont,

  util1,stmObj,stmMat1, stmMatU1 ;

type
  TLoadFromMatDlg = class(TForm)
    GroupBox1: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Bok: TButton;
    Bcancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    enX1: TeditNum;
    enX2: TeditNum;
    bcadrerX1: TBitBtn;
    bCadrerX2: TBitBtn;
    Label3: TLabel;
    enMoveX1: TeditNum;
    McadrerX1: TBitBtn;
    Label4: TLabel;
    enMoveX2: TeditNum;
    McadrerX2: TBitBtn;
    Label5: TLabel;
    enXD: TeditNum;
    Label6: TLabel;
    SyslistView1: TSyslistView;
    Label10: TLabel;
    enY1: TeditNum;
    bcadrerY1: TBitBtn;
    Label11: TLabel;
    enY2: TeditNum;
    bcadrerY2: TBitBtn;
    Label12: TLabel;
    enMoveY1: TeditNum;
    McadrerY1: TBitBtn;
    McadrerY2: TBitBtn;
    enMoveY2: TeditNum;
    Label13: TLabel;
    Label16: TLabel;
    enYD: TeditNum;
    procedure BokClick(Sender: TObject);
    procedure cadrerClick(Sender: TObject);
  private
    { Déclarations privées }
    x1e,x2e,y1e,y2e:float;
    x1m,x2m,y1m,y2m,xDm,yDm:float;
    dest0:Tmatrix;

    function Vsource:Tmatrix;
  public
    { Déclarations publiques }
    procedure execution(dest:Tmatrix);
  end;

function LoadFromMatDlg: TLoadFromMatDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FLoadFromMatDlg: TLoadFromMatDlg;

function LoadFromMatDlg: TLoadFromMatDlg;
begin
  if not assigned(FLoadFromMatDlg) then FLoadFromMatDlg:= TLoadFromMatDlg.create(nil);
  result:= FLoadFromMatDlg;
end;

{ TLoadFromVecDlg }

procedure TLoadFromMatDlg.execution(dest: Tmatrix);
begin
  if not dest.inf.temp or dest.readOnly then exit;

  dest0:=dest;
  syslistView1.Install;

  enX1.setVar(x1e,t_extended);
  enX2.setVar(x2e,t_extended);
  enY1.setVar(y1e,t_extended);
  enY2.setVar(y2e,t_extended);

  enMoveX1.setVar(x1m,t_extended);
  enMoveX2.setVar(x2m,t_extended);
  enMoveY1.setVar(y1m,t_extended);
  enMoveY2.setVar(y2m,t_extended);

  enXD.setVar(xdm,t_extended);
  enYD.setVar(ydm,t_extended);

  showModal;
end;

procedure TLoadFromMatDlg.BokClick(Sender: TObject);
var
  ok:boolean;
begin
  ok:=(SyslistView1.ob is Tmatrix);

  if not ok then
  begin
    messageCentral('Source is not a matrix');
    exit;
  end;

  modalResult:=mrOK;

  updateAllVar(self);

  case PageControl1.ActivePageIndex of
    0: proMcopy(Tmatrix(SyslistView1.ob),dest0);
    1: proMextract1(Tmatrix(SyslistView1.ob),x1e,x2e,y1e,y2e,dest0);
    2: proMmoveData(Tmatrix(SyslistView1.ob),x1m,x2m,y1m,y2m,dest0,xDm,yDm);
  end;

  dest0.invalidate;
end;

function TLoadFromMatDlg.Vsource: Tmatrix;
begin
  if SyslistView1.ob is Tmatrix
    then result:=Tmatrix(SyslistView1.ob)
    else result:=nil;
end;

procedure TLoadFromMatDlg.cadrerClick(Sender: TObject);
begin
  if Vsource=nil then exit;

  if sender=bcadrerX1 then
  begin
    x1e:=Vsource.Xstart;
    enX1.UpdateCtrl;
  end
  else
  if sender=bcadrerX2 then
  begin
    x2e:=Vsource.Xend;
    enX2.UpdateCtrl;
  end
  else
  if sender=bcadrerY1 then
  begin
    y1e:=Vsource.Ystart;
    enY1.UpdateCtrl;
  end
  else
  if sender=bcadrerY2 then
  begin
    y2e:=Vsource.Yend;
    enY2.UpdateCtrl;
  end
  else
  if sender=McadrerX1 then
  begin
    x1m:=Vsource.Xstart;
    enMoveX1.UpdateCtrl;
  end
  else
  if sender=McadrerX2 then
  begin
    x2m:=Vsource.Xend;
    enMoveX2.UpdateCtrl;
  end
  else
  if sender=McadrerY1 then
  begin
    y1m:=Vsource.Ystart;
    enMoveY1.UpdateCtrl;
  end
  else
  if sender=McadrerY2 then
  begin
    y2m:=Vsource.Yend;
    enMoveY2.UpdateCtrl;
  end;
end;

end.
