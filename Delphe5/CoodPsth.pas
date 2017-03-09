unit CoodPsth;

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

  util1,visu0,Dtrace1,dataOpt1, debug0;

type
  TprocedureOfObject=procedure of object;

  TCooD = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
    editNum3: TeditNum;
    editNum4: TeditNum;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    Label7: TLabel;
    comboBoxV2: TcomboBoxV;
    Label8: TLabel;
    comboBoxV3: TcomboBoxV;
    CheckBoxV1: TCheckBoxV;
    CheckBoxV2: TCheckBoxV;
    CheckBoxV3: TCheckBoxV;
    Button4: TButton;
    Pcolor1: TPanel;
    Button5: TButton;
    Button6: TButton;
    editString1: TeditString;
    ColorDialog1: TColorDialog;
    enCpx: TeditNum;
    enCpY: TeditNum;
    Label10: TLabel;
    Label11: TLabel;
    Boptions: TButton;
    Button3: TButton;
    Pcolor2: TPanel;
    Label9: TLabel;
    cbCmode: TcomboBoxV;
    comboBoxV1: TcomboBoxV;
    Label12: TLabel;
    cbLineStyle: TcomboBoxV;
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BoptionsClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbCmodeChange(Sender: TObject);
  private
    { Déclarations private }
    visu0:^TVisuInfo;
    procedure chooseOptionsDefault;
  public
    { Déclarations public }
    cadrerX,cadrerY:TnotifyEvent;

    Options:procedure of Object;
    function Choose(var title:AnsiString;var visu:TVisuInfo;
          cadrerX1,cadrerY1:TnotifyEvent):boolean;
  end;

function CooD: TCooD;

implementation

uses stmVec1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FCooD: TCooD;

function CooD: TCooD;
begin
  if not assigned(FCooD) then FCooD:= TCooD.create(nil);
  result:= FCooD;
end;


procedure TCooD.Button5Click(Sender: TObject);
begin
  updateAllVar(self);
end;


procedure TCooD.Button1Click(Sender: TObject);
begin
  if assigned(cadrerX) then
    begin
      cadrerX(sender);
      editNum1.updateCtrl;
      editNum2.updateCtrl;
    end;
end;

procedure TCooD.Button2Click(Sender: TObject);
begin
  if assigned(cadrerY) then
    begin
      cadrerY(sender);
      editNum3.updateCtrl;
      editNum4.updateCtrl;
    end;
end;

procedure TCooD.Button4Click(Sender: TObject);
begin
  if assigned(visu0) then
    with colorDialog1 do
    begin
      color:=visu0^.color;
      execute;
      visu0^.color:=color;
      Pcolor1.color:=visu0^.color;
    end;
end;

procedure TCooD.Button3Click(Sender: TObject);
begin
  if assigned(visu0) then
    with colorDialog1 do
    begin
      color:=visu0^.color2;
      execute;
      visu0^.color2:=color;
      Pcolor2.color:=visu0^.color2;
    end;
end;


procedure TCooD.FormActivate(Sender: TObject);
begin
  if assigned(visu0) then
    begin
      pcolor1.color:=visu0^.color;
      pcolor2.color:=visu0^.color2;
    end;

  bringtofront;
end;


procedure TCooD.BoptionsClick(Sender: TObject);
begin
  if assigned(Options) then Options;
end;

procedure TcooD.chooseOptionsDefault;
  var
    chooseOpt:TchooseOpt;
  begin
    chooseOpt:=TchooseOpt.create(self);
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

      adScaleColor:=@visu0^.scaleColor;
      FontS:=visu0^.fontVisu;

      cbX0.setVar(visu0^.FscaleX0);
      cbY0.setVar(visu0^.FscaleY0);

      cbKeepRatio.setvar(visu0^.keepRatio);

      if chooseOpt.showModal=mrOK then
        begin
          updateAllVar(chooseOpt);
        end;

    end;
    chooseOpt.free;
  end;

function TCooD.Choose(var title:AnsiString;var visu:TVisuInfo;
          cadrerX1,cadrerY1:TnotifyEvent):boolean;
  begin
    resetvar(self);
    visu0:=@visu;

    with visu do
    begin
      editString1.setString(title,1000);
      editnum1.setvar(Xmin,T_double);

      editnum2.setvar(Xmax,T_double);

      editnum3.setvar(Ymin,T_double);
      editnum4.setvar(Ymax,T_double);

      with comboBoxV1 do
      begin
        setStringArray(tbStyleTrace,longNomStyleTrace,nbStyleTrace);
        setVar(ModeT,T_byte,1);
      end;

      with comboBoxV2 do
      begin
        setNumList(1,20,1);
        setVar(tailleT,T_byte,1);
      end;

      with comboBoxV3 do
      begin
        setNumList(1,20,1);
        setVar(largeurTrait,T_byte,1);
      end;

      checkBoxV1.setVar(modelogX);
      checkBoxV2.setVar(modelogY);
      checkBoxV3.setVar(grille);

      enCpx.setvar(cpx,T_smallint);
      enCpy.setvar(cpy,T_smallint);

      with cbCmode do
      begin
        setStringArray(tbComplexMode,longNomComplexMode,5);
        setVar(CpxMode,T_byte,0);
      end;

      with cbLineStyle do
      begin
        setStringArray(tbStyleTrait,LongNomStyleTrait,nbStyleTrait);
        setVar(StyleTrait,T_byte,1);
      end;


      //enSmoothFactor.setVar(SmoothFactor,g_longint);
    end;

    cadrerX:=cadrerX1;
    cadrerY:=cadrerY1;

    if not assigned(Options) then Options:=ChooseOptionsDefault;

    choose:=(showModal=mrOK);
  end;



procedure TCooD.cbCmodeChange(Sender: TObject);
begin
  cbCmode.UpdateVar;
end;

Initialization
AffDebug('Initialization Cood0',0);
{$IFDEF FPC}
{$I Cood0.lrs}
{$ENDIF}
end.
