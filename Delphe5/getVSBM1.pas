unit getVSBM1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, defForm, StdCtrls, editcont,

  util1,Ddosfich,debug0,
  stmDef,stmObj, Buttons;

type
  TGetVSBM = class(TGenForm)
    Lx: TLabel;
    enX: TeditNum;
    Ly: TLabel;
    enY: TeditNum;
    Ldx: TLabel;
    enDX: TeditNum;
    Ldy: TLabel;
    enDY: TeditNum;
    CheckOnScreen: TCheckBox;
    CheckOnControl: TCheckBox;
    enX0: TeditNum;
    Label1: TLabel;
    Label2: TLabel;
    enY0: TeditNum;
    sbX: TscrollbarV;
    sbY: TscrollbarV;
    sbDx: TscrollbarV;
    sbDy: TscrollbarV;
    sbX0: TscrollbarV;
    sbY0: TscrollbarV;
    CheckLocked: TCheckBox;
    GroupBox1: TGroupBox;
    LabelFile: TLabel;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    enTheta: TeditNum;
    sbTheta: TscrollbarV;
    procedure enXExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbXScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure CheckOnScreenClick(Sender: TObject);
    procedure CheckOnControlClick(Sender: TObject);
    procedure CheckLockedClick(Sender: TObject);
    procedure enXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
    Fupdate:boolean;
    uo:typeUO;
  public
    { Déclarations publiques }
    procedure init(uo0:typeUO);

    procedure upDatePosition;override;
    procedure upDateSize;    override;
    procedure updateTheta;   override;
  end;

function GetVSBM: TGetVSBM;

implementation

uses stmVSBM1;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FGetVSBM: TGetVSBM;

function GetVSBM: TGetVSBM;
begin
  if not assigned(FGetVSBM) then FGetVSBM:= TGetVSBM.create(nil);
  result:= FGetVSBM;
end;





procedure TGetVSBM.FormCreate(Sender: TObject);
begin
  inherited;

  enX.Tag:=1;
  enY.Tag:=2;
  enDX.Tag:=3;
  enDY.Tag:=4;
  enX0.Tag:=5;
  enY0.Tag:=6;
  enTheta.Tag:= 7;

  sbX.Tag:=1;
  sbY.Tag:=2;
  sbDX.Tag:=3;
  sbDY.Tag:=4;
  sbX0.Tag:=5;
  sbY0.Tag:=6;
  sbTheta.Tag:= 7;
end;

procedure TGetVSBM.init(uo0: typeUO);
begin
  uo:=uo0;

  Fupdate:=true;

  with TVSbitmap(uo) do
  begin
    enX.setVar(deg.x,T_single);
    enX.setMinMax(-degXmax,degXmax);
    enX.Decimal:=2;
    sbX.setParams(deg.x,-degXmax,DegXmax);

    enY.setVar(deg.y,T_single);
    enY.setMinMax(-degYmax,degYmax);
    enY.Decimal:=2;
    sbY.setParams(deg.y,-DegYmax,DegYmax);

    enDX.setVar(deg.dx,T_single);
    enDX.setMinMax(DDegMin*2,100);
    enDX.Decimal:=2;
    sbDX.setParams(deg.dx,DDegMin*2,100);

    enDY.setVar(deg.dy,T_single);
    enDY.setMinMax(DdegMin*2,100);
    enDY.Decimal:=2;
    sbDY.setParams(deg.dy,DDegMin*2,100);

    enX0.setVar(x0,T_single);
    enX0.setMinMax(-degXmax*3,degXmax*3);
    enX0.Decimal:=2;
    sbX0.setParams(x0,-degXmax*3,degXmax*3);

    enY0.setVar(y0,T_single);
    enY0.setMinMax(-degYmax*3,degYmax*3);
    enY0.Decimal:=2;
    sbY0.setParams(y0,-degYmax*3,degYmax*3);

    enTheta.setVar(deg.theta,T_single);
    enTheta.setMinMax(-360,360);
    sbTheta.setParams(roundI(deg.theta),-360,360);

    CheckOnScreen.checked:=onScreen;
    CheckOnControl.checked:=onControl;
    CheckLocked.checked:=locked;

    LabelFile.Caption:= extractFileName(stFile);
  end;

  Fupdate:=false;
end;

procedure TGetVSBM.upDatePosition;
begin
  Fupdate:=true;
  enX.updateCtrl;
  enY.updateCtrl;

  with TVSbitmap(uo) do
  begin
    sbX.setParams(deg.x,-degXmax,DegXmax);
    sbY.setParams(deg.y,-degYmax,DegYmax);
  end;
  Fupdate:=false;
end;

procedure TGetVSBM.upDateSize;
begin
  Fupdate:=true;

  enDX.updateCtrl;
  enDY.updateCtrl;

  with TVSbitmap(uo) do
  begin
    sbDX.setParams(deg.dx,DDegMin*2,100);
    sbDY.setParams(deg.dy,DDegMin*2,100);
  end;
  Fupdate:=false;
end;


procedure TGetVSBM.updateTheta;
begin
  Fupdate:=true;
  enTheta.updateCtrl;
  with TVSbitmap(uo) do sbTheta.position:=roundI(deg.theta);
  Fupdate:=false;
end;

procedure TGetVSBM.enXExit(Sender: TObject);
begin
  if Fupdate then exit;

  TeditNum(sender).updatevar;

  with TVSbitmap(uo) do
  case TeditNum(sender).tag of
    1: sbX.setParams(deg.x,-degXmax,DegXmax);
    2: sbY.setParams(deg.y,-DegYmax,DegYmax);
    3: sbDX.setParams(deg.dx,DDegMin*2,100);
    4: sbDY.setParams(deg.dy,DDegMin*2,100);
    5: sbX0.setParams(x0,-degXmax*3,degXmax*3);
    6: sbY0.setParams(y0,-degYmax*3,degYmax*3);
    7: sbTheta.setParams(deg.theta,-360,360);
  end;

  uo.majPos;
end;

procedure TGetVSBM.enXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then enXexit(sender);
end;


procedure TGetVSBM.sbXScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  inherited;

  with TVSbitmap(uo) do
  case TscrollbarV(sender).Tag of
    1: begin
         deg.x:=x;
         enX.UpdateCtrl;
       end;
    2: begin
         deg.y:=x;
         enY.UpdateCtrl;
       end;
    3: begin
         deg.dx:=x;
         enDX.UpdateCtrl;
       end;
    4: begin
         deg.dy:=x;
         enDY.UpdateCtrl;
       end;
    5: begin
         x0:=x;
         enx0.UpdateCtrl;
       end;
    6: begin
         y0:=x;
         eny0.UpdateCtrl;
       end;
    7: begin
         deg.theta:=x;
         enTheta.UpdateCtrl;
       end;
  end;

  uo.majPos;
end;

procedure TGetVSBM.CheckOnScreenClick(Sender: TObject);
begin
  uo.OnScreen:=CheckOnScreen.checked;
end;

procedure TGetVSBM.CheckOnControlClick(Sender: TObject);
begin
  uo.OnControl:=CheckOnControl.checked;
end;

procedure TGetVSBM.CheckLockedClick(Sender: TObject);
begin
  uo.Locked:=CheckLocked.checked;
end;


procedure TGetVSBM.BitBtn1Click(Sender: TObject);
var
  st:AnsiString;
begin
  with TVSbitmap(uo) do
  begin
    st:= GchooseFile('Choose a graphic file',stFile);
    if (st<>'') then
    begin
      LoadFromFile(st);
      fileOK:=false;
      majpos;
      LabelFile.Caption:= extractFileName(stFile);
    end;
  end;

end;


Initialization
AffDebug('Initialization getVSBM1',0);
{$IFDEF FPC}
{$I getVSBM1.lrs}
{$ENDIF}
end.
