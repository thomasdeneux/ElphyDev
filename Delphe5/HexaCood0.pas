unit Hexacood0;

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
  THexaCooD = class(TForm)
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
    Label8: TLabel;
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
    C_contrast: TeditNum;
    Label6: TLabel;
    C_theta: TeditNum;
    Panel2: TPanel;
    Label9: TLabel;
    C_cpZ: TeditNum;
    Label13: TLabel;
    C_two: TCheckBoxV;
    Label14: TLabel;
    editString1: TeditString;
    cbDisplayMode: TcomboBoxV;
    Label15: TLabel;
    procedure C_okClick(Sender: TObject);
    procedure C_scaleXClick(Sender: TObject);
    procedure C_scaleYClick(Sender: TObject);
    procedure C_colorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure C_OptionsClick(Sender: TObject);
    procedure C_scaleZClick(Sender: TObject);
  private
    { Déclarations private }
    visu0:^TVisuInfo;
    Adcolor:^Tmatcolor;
    palName0:AnsiString;
    procedure chooseOptionsDefault;
  public
    { Déclarations public }
    cadrerX,cadrerY,cadrerZ:TnotifyEvent;

    Options:procedure of Object;
    function Choose(var title:AnsiString;var visu:TVisuInfo;
                    var palName:AnsiString;
                    var degP:typedegre;
                    cadrerX1,cadrerY1,cadrerZ1:TnotifyEvent):boolean;
  end;

function HexaCooD: THexaCooD;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FHexaCooD: THexaCooD;

function HexaCooD: THexaCooD;
begin
  if not assigned(FHexaCooD) then FHexaCooD:= THexaCooD.create(nil);
  result:= FHexaCooD;
end;

procedure THexaCooD.C_okClick(Sender: TObject);
begin
  updateAllVar(self);
end;


procedure THexaCooD.C_scaleXClick(Sender: TObject);
begin
  if assigned(cadrerX) then
    begin
      cadrerX(sender);
      C_Xmin.updateCtrl;
      C_Xmax.updateCtrl;
    end;
end;

procedure THexaCooD.C_scaleYClick(Sender: TObject);
begin
  if assigned(cadrerY) then
    begin
      cadrerY(sender);
      C_Ymin.updateCtrl;
      C_Ymax.updateCtrl;
    end;
end;

procedure THexaCooD.C_scaleZClick(Sender: TObject);
begin
  if assigned(cadrerZ) then
    begin
      cadrerZ(sender);
      C_Zmin.updateCtrl;
      C_Zmax.updateCtrl;
    end;
end;


procedure THexaCooD.C_colorClick(Sender: TObject);
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
      C_contrast.updateCtrl;
    end;
end;


procedure THexaCooD.FormActivate(Sender: TObject);
begin
  if assigned(Adcolor) then
    begin
      panel1.color:=getDColor(AdColor^.col1,255);
      panel2.color:=getDColor(AdColor^.col2,255);
    end;
end;

procedure THexaCooD.chooseOptionsDefault;
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


      if chooseOpt.showModal=mrOK then
        begin
          updateAllVar(chooseOpt);
        end;
    end;
    chooseOpt.free;
  end;


procedure THexaCooD.C_OptionsClick(Sender: TObject);
begin
  if assigned(Options) then Options;
end;

function THexaCooD.Choose(var title:AnsiString;var visu:TVisuInfo;var palName:AnsiString;var degP:typeDegre;
                         cadrerX1,cadrerY1,cadrerZ1:TnotifyEvent):boolean;
  var
    chg:boolean;
  begin
    resetvar(self);

    visu0:=@visu;
  

    with visu do
    begin
      editString1.setString(title,1000);

      C_Xmin.setvar(Xmin,T_double);
      C_Xmax.setvar(Xmax,T_double);

      C_Ymin.setvar(Ymin,T_double);
      C_Ymax.setvar(Ymax,T_double);

      C_Zmin.setvar(Zmin,T_double);
      C_Zmax.setvar(Zmax,T_double);


      C_contrast.setvar(gamma,T_single);
      C_grid.setVar(grille);

      C_cpx.setvar(cpx,T_smallint);
      C_cpy.setvar(cpy,T_smallint);
      C_cpz.setvar(cpz,T_smallint);

      {C_aspect.setvar(aspect,t_single);}
      C_theta.setvar(degP.theta,t_single);

      C_two.setvar(twoCol);

      with cbDisplayMode do
      begin
        setString('Normal|Smooth 3X3|Wires');
        setvar(modeMat,t_byte,0);
      end;


      palName0:=palName;


    end;

    Adcolor:=@visu.color;

    cadrerX:=cadrerX1;
    cadrerY:=cadrerY1;
    cadrerZ:=cadrerZ1;

    if not assigned(Options) then Options:=ChooseOptionsDefault;

    result:=(showModal=mrOK);
    if result then palName:=palName0;
  end;

Initialization
AffDebug('Initialization HexaCooD0',0);
  {$IFDEF FPC}
  {$I Hexacood0.lrs}
  {$ENDIF}
end.
