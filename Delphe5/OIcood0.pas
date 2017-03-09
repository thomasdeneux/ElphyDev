unit OIcood0;

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

  util1,Dpalette,colSat1, debug0,
  visu0,dataOpt1,stmObj;

type
  TOICooD = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    C_G0: TeditNum;
    C_X0: TeditNum;
    C_Y0: TeditNum;
    C_scale: TButton;
    C_options: TButton;
    C_color: TButton;
    Panel1: TPanel;
    C_ok: TButton;
    C_cancel: TButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    C_Cpxy: TeditNum;
    Label10: TLabel;
    Label1: TLabel;
    Label12: TLabel;
    C_Zmin: TeditNum;
    C_Zmax: TeditNum;
    C_scaleZ: TButton;
    Panel2: TPanel;
    Label9: TLabel;
    C_cpIndex: TeditNum;
    Label13: TLabel;
    C_two: TCheckBoxV;
    Label14: TLabel;
    editString1: TeditString;
    Label11: TLabel;
    C_cpZ: TeditNum;
    Button1: TButton;
    cbTransparent: TCheckBoxV;
    Label5: TLabel;
    enTransparent: TeditNum;
    procedure C_okClick(Sender: TObject);
    procedure C_scaleClick(Sender: TObject);
    procedure C_colorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure C_scaleZClick(Sender: TObject);
    procedure C_optionsClick(Sender: TObject);
  private
    { Déclarations private }
    uo0:typeUO;

  public
    { Déclarations public }

    function Choose(uo:typeUO; var transparent1:boolean; var TransparentValue1:double):boolean;
  end;

function OICooD: TOICooD;

implementation

uses stmOIseq1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FOICooD: TOICooD;

function OICooD: TOICooD;
begin
  if not assigned(FOICooD) then FOICooD:= TOICooD.create(nil);
  result:= FOICooD;
end;

procedure TOICooD.C_okClick(Sender: TObject);
begin
  updateAllVar(self);
end;


procedure TOICooD.C_scaleClick(Sender: TObject);
begin
  Toiseq(uo0).Gdisp:=1;
  Toiseq(uo0).xdisp:=0;
  Toiseq(uo0).ydisp:=0;

  C_G0.updateCtrl;
  C_x0.updateCtrl;
  C_y0.updateCtrl;
end;

procedure TOICooD.C_scaleZClick(Sender: TObject);
begin
  if Tbutton(sender).tag=0
    then TOIseq(uo0).autoscaleZ1(false)
    else TOIseq(uo0).autoscaleZ1(true);

  C_Zmin.updateCtrl;
  C_Zmax.updateCtrl;
end;


procedure TOICooD.C_colorClick(Sender: TObject);
var
  stPalName:Ansistring;
begin
  with TOIseq(uo0) do
  begin
    stPalName:=palName;
    if stmColsat.execution(TmatColor(visu.color).col1,TmatColor(visu.color).col2,stpalName,visu) then
    begin
      PalName:=stPalName;
      panel1.color:=getDColor(TmatColor(visu.color).col1,255);
      panel2.color:=getDColor(TmatColor(visu.color).col2,255);
    end;
  end;
end;


procedure TOICooD.FormActivate(Sender: TObject);
begin
  if assigned(uo0) then
  with TOIseq(uo0) do
  begin
    panel1.color:=getDColor(TmatColor(visu.color).col1,255);
    panel2.color:=getDColor(TmatColor(visu.color).col2,255);
  end;
end;

procedure TOICooD.C_optionsClick(Sender: TObject);
var
  chooseOpt:TchooseOpt;
begin
  chooseOpt:=TchooseOpt.create(self);
  with chooseOpt,TOISeq(uo0).visu do
  begin
    cbValueX.setVar(echX);
    cbTicksX.setVar(FtickX);
    cbExternalX.setvar(tickExtX);
    CbCompletX.setvar(completX);
    CbinvertX.setvar(inverseX);

    cbValueY.setVar(echY);
    cbTicksY.setVar(FtickY);
    cbExternalY.setvar(tickExtY);
    CbCompletY.setvar(completY);
    CbinvertY.setvar(inverseY);

    cbKeepRatio.setvar(keepRatio);

    adScaleColor:=@scaleColor;
    FontS:=fontVisu;

    cbX0.setVar(FscaleX0);
    cbY0.setVar(FscaleY0);

    if chooseOpt.showModal=mrOK then
      begin
        updateAllVar(chooseOpt);
      end;
  end;
  chooseOpt.free;
end;


function TOICooD.Choose(uo:typeUO; var transparent1:boolean; var TransparentValue1:double):boolean;
var
  stTitle:Ansistring;
begin
  uo0:=uo;

  with TOIseq(uo0) do
  begin
    stTitle:=title;

    editString1.setString(stTitle,1000);

    C_G0.setvar(visu.Gdisp,T_double);
    C_X0.setvar(visu.Xdisp,T_double);
    C_Y0.setvar(visu.Ydisp,T_double);

    C_Zmin.setvar(visu.Zmin,T_double);
    C_Zmax.setvar(visu.Zmax,T_double);

    C_cpxy.setvar(cpxy,T_smallint);
    C_cpz.setvar(visu.cpz,T_smallint);
    C_cpIndex.setvar(cpIndex,T_smallint);

    {C_aspect.setvar(visu.aspect,t_single);}

    C_two.setvar(visu.twoCol);

    cbTransparent.setVar(transparent1);
    enTransparent.setVar(TransparentValue1,g_double);

    result:=(self.showModal=mrOK);

    if result then
    begin
      updateAllVar(self);
      title:=stTitle;
    end;
  end;
end;


Initialization
AffDebug('Initialization OIcood0',0);
{$IFDEF FPC}
{$I OIcood0.lrs}
{$ENDIF}
end.
