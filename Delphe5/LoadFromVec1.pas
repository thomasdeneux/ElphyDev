unit LoadFromVec1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ComCtrls, SyslistTreeView, Buttons, StdCtrls, editcont,

  util1,stmObj,stmVec1, stmVecU1 ;

type
  TLoadFromVecDlg = class(TForm)
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
    TabSheet4: TTabSheet;
    Label7: TLabel;
    enX1a: TeditNum;
    BitBtn1: TBitBtn;
    Label8: TLabel;
    enX2a: TeditNum;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    procedure BokClick(Sender: TObject);
    procedure McadrerX1Click(Sender: TObject);
    procedure McadrerX2Click(Sender: TObject);
    procedure bcadrerX1Click(Sender: TObject);
    procedure bCadrerX2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Déclarations privées }
    x1e,x2e:float;
    x1m,x2m,xDm:float;
    x1a,x2a:float;
    dest0:Tvector;

    function Vsource:Tvector;
  public
    { Déclarations publiques }
    procedure execution(dest:Tvector);
  end;

function LoadFromVecDlg: TLoadFromVecDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FLoadFromVecDlg: TLoadFromVecDlg;

function LoadFromVecDlg: TLoadFromVecDlg;
begin
  if not assigned(FLoadFromVecDlg) then FLoadFromVecDlg:= TLoadFromVecDlg.create(nil);
  result:= FLoadFromVecDlg;
end;

{ TLoadFromVecDlg }

procedure TLoadFromVecDlg.execution(dest: Tvector);
begin
  if not dest.inf.temp or dest.readOnly then exit;

  dest0:=dest;
  syslistView1.Install;

  enX1.setVar(x1e,t_extended);
  enX2.setVar(x2e,t_extended);

  enMoveX1.setVar(x1m,t_extended);
  enMoveX2.setVar(x2m,t_extended);
  enXD.setVar(xdm,t_extended);

  enX1a.setVar(x1a,t_extended);
  enX2a.setVar(x2a,t_extended);


  showModal;
end;

procedure TLoadFromVecDlg.BokClick(Sender: TObject);
var
  ok:boolean;
begin
  ok:=(SyslistView1.ob is Tvector);

  if not ok then
  begin
    messageCentral('Source is not a vector');
    exit;
  end;

  modalResult:=mrOK;
  
  updateAllVar(self);

  case PageControl1.ActivePageIndex of
    0: proVcopy(Tvector(SyslistView1.ob),dest0);
    1: proVextract1(Tvector(SyslistView1.ob),x1e,x2e,dest0);
    2: proVmoveData(Tvector(SyslistView1.ob),x1m,x2m,dest0,xDm);
    3: proVappend(Tvector(SyslistView1.ob),x1a,x2a, dest0);
  end;

  dest0.invalidateData;
end;

function TLoadFromVecDlg.Vsource: Tvector;
begin
  if SyslistView1.ob is Tvector
    then result:=Tvector(SyslistView1.ob)
    else result:=nil;
end;

procedure TLoadFromVecDlg.McadrerX1Click(Sender: TObject);
begin
  if Vsource<>nil then
  begin
    x1m:=Vsource.Xstart;
    enMoveX1.UpdateCtrl;
  end;
end;


procedure TLoadFromVecDlg.McadrerX2Click(Sender: TObject);
begin
  if Vsource<>nil then
  begin
    x2m:=Vsource.Xend;
    enMoveX2.UpdateCtrl;
  end;
end;

procedure TLoadFromVecDlg.bcadrerX1Click(Sender: TObject);
begin
  if Vsource<>nil then
  begin
    x1e:=Vsource.Xstart;
    enX1.UpdateCtrl;
  end;
end;

procedure TLoadFromVecDlg.bCadrerX2Click(Sender: TObject);
begin
  if Vsource<>nil then
  begin
    x2e:=Vsource.Xend;
    enX2.UpdateCtrl;
  end;
end;

procedure TLoadFromVecDlg.BitBtn1Click(Sender: TObject);
begin
  if Vsource<>nil then
  begin
    x1a:=Vsource.Xstart;
    enX1a.UpdateCtrl;
  end;

end;

procedure TLoadFromVecDlg.BitBtn2Click(Sender: TObject);
begin
  if Vsource<>nil then
  begin
    x2a:=Vsource.Xend;
    enX2a.UpdateCtrl;
  end;

end;

end.
