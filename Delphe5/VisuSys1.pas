unit VisuSys1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls, DisplayFrame1,

  DXdrawsG,
  util1,DdosFich,stmdef, debug0;

type
  TprocedureOfObject=procedure of object;

  TVisualSys = class(TForm)
    Label1: TLabel;
    enRefreshRate: TeditNum;
    Button1: TButton;
    Button2: TButton;
    cbUseAcqInt: TCheckBoxV;
    cbAlwaysActivate: TCheckBoxV;
    Label2: TLabel;
    cbDisplayMode: TcomboBoxV;
    Bmeasure: TButton;
    cbDevice: TcomboBoxV;
    Label3: TLabel;
    Shape1: TShape;
    Label4: TLabel;
    enScreenDistance: TeditNum;
    Label5: TLabel;
    enScreenHeight: TeditNum;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    PfileName: TPanel;
    Bchoose: TButton;
    Pdisplay: TPanel;
    CalibFrame: TDispFrame;
    cbPalette: TcomboBoxV;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    cbSyncMode: TcomboBoxV;
    BsyncParams: TButton;
    LlumMax: TLabel;
    enLumMax: TeditNum;
    cbWinMode: TCheckBoxV;
    procedure BmeasureClick(Sender: TObject);
    procedure BchooseClick(Sender: TObject);
    procedure cbSyncModeChange(Sender: TObject);
    procedure BsyncParamsClick(Sender: TObject);
    procedure cbDeviceChange(Sender: TObject);
  private
    { Private declarations }
    OldMonoPaletteNumber:integer;
    VSDriverIndex:integer;
    winMode1: boolean;
    procedure updateVars;
    procedure OnDrawCbPalette(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  public
    { Public declarations }

    procedure initDisplayMode;
    procedure execution;
  end;


function VisualSys: TVisualSys;

implementation

uses {$IFDEF DX11}FxCtrlDX11 {$ELSE} FxCtrlDX9  {$ENDIF} ,
     stmVS0,syspal32, VSsyncPrm;
{$R *.DFM} 

var
  visualSys0:TvisualSys;

function VisualSys: TVisualSys;
begin
  if not assigned(VisualSys0)
    then VisualSys0:=TVisualSys.create(formStm);
  result:=VisualSys0;
end;


procedure TvisualSys.updateVars;
var
  st:AnsiString;
  stDisplay: AnsiString;
  Adapter: integer;
  width1, height1,rate1: integer;
  w,code: integer;
begin
  stDisplay:=Istr(SSWidth)+'/'+Istr(SSHeight)+'/'+Istr(SSrefreshRate);
  updateAllVar(self);

  if TRUE or (cbDevice.text<>stDXdriver) or (cbDisplayMode.Text<>stDisplay) or (OldMonoPaletteNumber<>MonoPaletteNumber)
     or (winMode1<>visualStim.FXcontrol.FwinMode)  then
  begin
    Adapter:=cbDevice.ItemIndex;
    stDXdriver:=cbDevice.Text;
    st:=cbDisplayMode.Text;
    val(copy(st,1,pos('/',st)-1),w,code);
    if code=0 then SSwidth:=w;
    delete(st,1,pos('/',st));

    val(copy(st,1,pos('/',st)-1),w,code);
    if code=0 then SSheight:=w;
    delete(st,1,pos('/',st));

    val(st,w,code);
    if code=0 then SSrefreshRate:=w;

    dxScreen.Finalize;

    OldMonoPaletteNumber:= MonoPaletteNumber;
    SysPaletteNumber:=MonoPaletteNumber;


    if DXscreen.InitDevice(visualStim.FXcontrol.FwinMode,stDXdriver,SSwidth,SSheight,SSrefreshRate) then
    begin
      stDXdriver:=cbDevice.items[adapter];
      calculateScreenConst;
      //dxScreen.Initialize;
    end;
    syspal.update;

    VisualStim.FXcontrol.PaintControl;
  end;
end;

procedure TvisualSys.initDisplayMode;
var
  i:integer;
  st0:string;
begin
  st0:=Istr(SSWidth)+'/'+Istr(SSHeight)+'/'+Istr(SSrefreshRate);
  cbDisplayMode.Clear;
  with dxscreen.ScreenMode[VSdriverIndex] do
  begin
    for i:=0 to count-1 do
    begin
      cbDisplayMode.Items.add(strings[i]);
      if strings[i]=st0 then cbDisplayMode.itemIndex:=cbDisplayMode.items.Count-1;
    end;
  end;

end;

procedure TVisualSys.execution;
var
  i:integer;
  st, st0:AnsiString;
begin
  DX9end;

  if not assigned(dxScreen) then exit;
  OldMonoPaletteNumber:=MonoPaletteNumber;
  winMode1:= visualStim.FXcontrol.FwinMode;

  with cbDevice do
  begin
    clear;
    VSDriverIndex:=-1;
    for i:=0 to DXscreen.Nscreen-1 do
    begin
      items.add(DXscreen.ScreenId[i]);
      if (stDXdriver= DXscreen.ScreenId[i]) then  VSdriverIndex:=i;
    end;

    if VSDriverIndex=-1 then VSDriverIndex:=DXscreen.Nscreen-1;

    setvar(VSDriverIndex,t_longint,0);
  end;

  initDisplayMode;

  enScreenDistance.setVar(ScreenDistance,T_extended);
  enScreenHeight.setVar(ScreenHeight,T_extended);

  enRefreshRate.setVar(Tfreq,t_extended);
  enRefreshRate.setMinMax(1,100000  );
  cbUseAcqInt.setvar(visualStim.FXcontrol.FacqInterface);
  cbWinMode.setvar(visualStim.FXcontrol.FwinMode);

  cbAlwaysActivate.setvar(visualStim.FXcontrol.FalwaysActivate);

  PfileName.Caption:=CalibFileName;
  with CalibFrame do
  begin
    InstallArray(@syspal.lum,g_single,0,255);
    visu.Xmin:=0;
    visu.Xmax:=255;
    visu.Ymin:=0;
    visu.Ymax:=syspal.MaxLum*1.1;

    visu.color:=clBlue;
    visu.ScaleColor:=clBlack;
  end;

{  Sur certains systèmes, l'introduction de chaines vides provoque une erreur }
  cbPalette.setString('x |x |x |x |x |x |x ');
  cbPalette.setVar(MonoPaletteNumber,t_longint,1);

  cbPalette.OnDrawItem:=OnDrawCbPalette;

  cbSyncMode.setVar(VSsyncMode,t_longint,0);
  BsyncParams.Enabled:= (VSsyncMode=1);

  enLumMax.setVar(syspal.LuminanceMax,g_single);

  if showModal=mrOK then
    updateVars;
end;

procedure TVisualSys.BmeasureClick(Sender: TObject);
begin
  {updateVars;}

  cursor:=crHourGlass;
  VisualStim.FXcontrol.mesureRefreshTime1;
  cursor:=crDefault;

  enRefreshRate.updateCtrl;

end;


procedure TVisualSys.BchooseClick(Sender: TObject);
var
  st:AnsiString;
begin
  st:=GchooseFile('Choose a calibration file',CalibFileName);
  if st<>'' then
  begin
    syspal.ChangeCalib(st);
    PfileName.caption:=CalibFileName;
    CalibFrame.invalidate;
  end;
end;

procedure TVisualSys.OnDrawCbPalette(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  n,col:integer;
  Vred,Vgreen,Vblue:integer;
begin
 {  'R  ','G  ','B  ','RG ','RB ','GB ','RGB' (numéros de 1 à 7) }
  n:=index+1;
  Vred:=  255*ord(n in [1,4,5,7]);
  Vgreen:=255*ord(n in [2,4,6,7]);
  Vblue:= 255*ord(n in [3,5,6,7]);

  col:=rgb(Vred,Vgreen,Vblue);

  with TcomboBoxV(Control).Canvas do
  begin
    brush.Color:=col;
    brush.style:=bsSolid;
    FillRect(rect);
  end;


end;

procedure TVisualSys.cbSyncModeChange(Sender: TObject);
begin
  BsyncParams.Enabled:=(cbSyncMode.ItemIndex=1);
end;

procedure TVisualSys.BsyncParamsClick(Sender: TObject);
begin
  GetVSsyncParam.execute;
  VisualStim.FXcontrol.SetSpotParams;
end;

procedure TVisualSys.cbDeviceChange(Sender: TObject);
begin
  VSdriverIndex:=cbDevice.ItemIndex;
  initDisplayMode;
end;

Initialization
AffDebug('Initialization VisuSys1',0);
{$IFDEF FPC}
{$I VisuSys1.lrs}
{$ENDIF}
end.
