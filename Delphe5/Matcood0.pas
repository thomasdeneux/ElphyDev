unit Matcood0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, editcont,

  util1,Dpalette,colSat1,
  visu0,dataOpt2,angleOption1,cpxOpt1, debug0, stmdef;

type
  TMatCooD = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    C_Xmin: TeditNum;
    C_Xmax: TeditNum;
    C_Ymin: TeditNum;
    C_Ymax: TeditNum;
    C_scaleX: TButton;
    C_scaleY: TButton;
    C_grid: TCheckBoxV;
    C_font: TButton;
    C_color: TButton;
    Panel1: TPanel;
    C_ok: TButton;
    C_cancel: TButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    C_Cpx: TeditNum;
    C_CpY: TeditNum;
    Label10: TLabel;
    Label11: TLabel;
    Label1: TLabel;
    Label12: TLabel;
    C_Zmin: TeditNum;
    C_Zmax: TeditNum;
    C_scaleZ: TButton;
    Panel2: TPanel;
    Label9: TLabel;
    C_cpZ: TeditNum;
    Label13: TLabel;
    C_two: TCheckBoxV;
    Label14: TLabel;
    editString1: TeditString;
    cbDisplayMode: TcomboBoxV;
    Label15: TLabel;
    Label16: TLabel;
    cbCmode: TcomboBoxV;
    Label17: TLabel;
    cbAngleMode: TcomboBoxV;
    BangleOptions: TButton;
    BcpxOptions: TButton;
    GroupBox1: TGroupBox;
    cbLogX: TCheckBoxV;
    cbLogY: TCheckBoxV;
    cbLogZ: TCheckBoxV;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    C_x: TeditNum;
    Label7: TLabel;
    C_y: TeditNum;
    Label8: TLabel;
    C_dx: TeditNum;
    Label18: TLabel;
    C_dy: TeditNum;
    Label19: TLabel;
    C_theta: TeditNum;
    cbUsePosition: TCheckBoxV;
    procedure C_okClick(Sender: TObject);
    procedure C_scaleXClick(Sender: TObject);
    procedure C_scaleYClick(Sender: TObject);
    procedure C_colorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure C_OptionsClick(Sender: TObject);
    procedure C_scaleZClick(Sender: TObject);
    procedure BangleOptionsClick(Sender: TObject);
    procedure BcpxOptionsClick(Sender: TObject);
  private
    { Déclarations private }
    visu0:^TVisuInfo;
    wf0:PwfOptions;
    Adcolor:^Tmatcolor;
    palName0:AnsiString;
    procedure chooseOptionsDefault;
  public
    { Déclarations public }
    cadrerX,cadrerY,cadrerZ,cadrerC:TnotifyEvent;

    Options:procedure of Object;
    function Choose(var title:AnsiString;var visu:TVisuInfo;
                    var palName:AnsiString;
                    wf:PWFoptions;var degP:typeDegre;
                    cadrerX1,cadrerY1,cadrerZ1,cadrerC1:TnotifyEvent):boolean;
  end;

function MatCooD: TMatCooD;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FMatCooD: TMatCooD;

function MatCooD: TMatCooD;
begin
  if not assigned(FMatCooD) then FMatCooD:= TMatCooD.create(nil);
  result:= FMatCooD;
end;

procedure TMatCooD.C_okClick(Sender: TObject);
begin
  updateAllVar(self);
end;


procedure TMatCooD.C_scaleXClick(Sender: TObject);
begin
  if assigned(cadrerX) then
    begin
      cadrerX(sender);
      C_Xmin.updateCtrl;
      C_Xmax.updateCtrl;
    end;
end;

procedure TMatCooD.C_scaleYClick(Sender: TObject);
begin
  if assigned(cadrerY) then
    begin
      cadrerY(sender);
      C_Ymin.updateCtrl;
      C_Ymax.updateCtrl;
    end;
end;

procedure TMatCooD.C_scaleZClick(Sender: TObject);
begin
  if assigned(cadrerZ) then
    begin
      cadrerZ(sender);
      C_Zmin.updateCtrl;
      C_Zmax.updateCtrl;
    end;
end;


procedure TMatCooD.C_colorClick(Sender: TObject);
var
  n:integer;
  b1,b2:byte;
begin
  if not assigned(adColor) then exit;
  b1:=AdColor^.col1;
  b2:=AdColor^.col2;
  if stmColsat.execution(b1,b2,palName0,visu0^) then
    begin
      panel1.color:=getDColor(b1,255);
      panel2.color:=getDColor(b2,255);
      AdColor^.col1:=b1;
      AdColor^.col2:=b2;
      //C_contrast.updateCtrl;
    end;
end;


procedure TMatCooD.FormActivate(Sender: TObject);
begin
  if assigned(Adcolor) then
    begin
      panel1.color:=getDColor(AdColor^.col1,255);
      panel2.color:=getDColor(AdColor^.col2,255);
    end;
end;

procedure TmatCooD.chooseOptionsDefault;
  var
    chooseOpt:TchooseMatOpt;
  begin
    chooseOpt:=TchooseMatOpt.create(self);
    with chooseOpt do
    begin
      cbValueX.setVar(visu0^.echX);
      cbTicksX.setVar(visu0^.FtickX);
      cbExternalX.setvar(visu0^.tickExtX);
      CbCompletX.setvar(visu0^.completX);
      CbinvertX.setvar(visu0^.inverseX);

      cbValueY.setVar(visu0^.echY);
      cbTicksY.setVar(visu0^.FtickY);
      cbExternalY.setvar(visu0^.tickExtY);
      CbCompletY.setvar(visu0^.completY);
      CbinvertY.setvar(visu0^.inverseY);

      cbKeepRatio.setvar(visu0^.keepRatio);

      adScaleColor:=@visu0^.scaleColor;
      FontS:=visu0^.fontVisu;

      cbX0.setVar(visu0^.FscaleX0);
      cbY0.setVar(visu0^.FscaleY0);

      if assigned(wf0) then
      with wf0^ do
      begin
        enDeltaX.setvar(dxAff,t_single);
        enDeltaX.setminmax(-100,100);
        enDeltaY.setvar(dyAff,t_single);
        enDeltaY.setminmax(-100,100);

        enLeft.setvar(Mleft,t_single);
        enLeft.setminmax(0,100);

        enRight.setvar(Mright,t_single);
        enRight.setminmax(0,100);

        enTop.setvar(Mtop,t_single);
        enTop.setminmax(0,100);

        enBottom.setvar(Mbottom,t_single);
        enBottom.setminmax(0,100);

        cbUsesWF.setvar(Active);
      end;

      if chooseOpt.showModal=mrOK then
        begin
          updateAllVar(chooseOpt);
        end;
    end;
    chooseOpt.free;
  end;


procedure TMatCooD.C_OptionsClick(Sender: TObject);
begin
  if assigned(Options) then Options;
end;

function TmatCooD.Choose(var title:AnsiString;var visu:TVisuInfo;var palName:AnsiString;
                         wf:PWFoptions;var degP: typeDegre;
                         cadrerX1,cadrerY1,cadrerZ1,cadrerC1:TnotifyEvent):boolean;
  var
    chg:boolean;
  begin
    resetvar(self);

    visu0:=@visu;
    wf0:=wf;

    with visu do
    begin
      editString1.setString(title,1000);

      C_Xmin.setvar(Xmin,T_double);
      C_Xmax.setvar(Xmax,T_double);

      C_Ymin.setvar(Ymin,T_double);
      C_Ymax.setvar(Ymax,T_double);

      C_Zmin.setvar(Zmin,T_double);
      C_Zmax.setvar(Zmax,T_double);


      C_grid.setVar(grille);

      C_cpx.setvar(cpx,T_smallint);
      C_cpy.setvar(cpy,T_smallint);
      C_cpz.setvar(cpz,T_smallint);

      {C_aspect.setvar(aspect,t_single);}
      C_x.setvar(degP.x,T_single);
      C_y.setvar(degP.y,T_single);
      C_dx.setvar(degP.dx,T_single);
      C_dy.setvar(degP.dy,T_single);
      C_theta.setvar(degP.theta,t_single);
      cbUsePosition.setVar(degP.FUse);

      C_two.setvar(twoCol);

      with cbDisplayMode do
      begin
        setString('Normal|Smooth 3X3|Smooth 3X3 Bis');
        setvar(modeMat,t_byte,0);
      end;

      with cbCmode do
      begin
        setStringArray(tbComplexMode,longNomComplexMode,nbComplexMode);
        setVar(CpxMode,T_byte,0);
      end;

      with cbAngleMode do
      begin
        setString('None|angle=value|angle=Cpx arg');
        setVar(AngularMode,T_byte,0);
      end;


      palName0:=palName;

      cbLogX.setVar(modeLogX);
      cbLogY.setVar(modeLogY);
      cbLogZ.setVar(modeLogZ);


    end;

    Adcolor:=@visu.color;

    cadrerX:=cadrerX1;
    cadrerY:=cadrerY1;
    cadrerZ:=cadrerZ1;
    cadrerC:=cadrerC1;

    if not assigned(Options) then Options:=ChooseOptionsDefault;

    result:=(showModal=mrOK);
    if result then palName:=palName0;
  end;

procedure TMatCooD.BangleOptionsClick(Sender: TObject);
begin
  angularOpt.execution(visu0^);

end;

procedure TMatCooD.BcpxOptionsClick(Sender: TObject);
begin
  cbCmode.updateVar;
  CpxOpt.execution(visu0^,cadrerC);
end;

Initialization
AffDebug('Initialization Matcood0',0);
{$IFDEF FPC}
{$I Matcood0.lrs}
{$ENDIF}
end.
