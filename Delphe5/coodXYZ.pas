unit CoodXYZ;

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

  util1,visu0,Dtrace1,stmObj, ColorFrame1, debug0;

type
  TprocedureOfObject=procedure of object;

  TCooXYZ = class(TForm)
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
    cbShowScale: TCheckBoxV;
    Button5: TButton;
    Button6: TButton;
    editString1: TeditString;
    ColorDialog1: TColorDialog;
    Label7: TLabel;
    Label8: TLabel;
    editNum5: TeditNum;
    editNum6: TeditNum;
    Button3: TButton;
    ColFrame1: TColFrame;
    cbShowGrid: TCheckBoxV;
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations private }
    uo0:typeUO;
    title1:AnsiString;
  public
    { Déclarations public }

    function Choose(uo:typeUO) :boolean;
  end;

function CooXYZ: TCooXYZ;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
uses stmXYZplot1;

var
  FCooXYZ: TCooXYZ;

function CooXYZ: TCooXYZ;
begin
  if not assigned(FCooXYZ) then FCooXYZ:= TCooXYZ.create(nil);
  result:= FCooXYZ;
end;


procedure TCooXYZ.Button5Click(Sender: TObject);
begin
  updateAllVar(self);
end;


procedure TCooXYZ.Button1Click(Sender: TObject);
begin
  if assigned(uo0) then
    with TXYZplot(uo0) do
    begin
      cadrerX(sender);
      editNum1.updateCtrl;
      editNum2.updateCtrl;
    end;
end;

procedure TCooXYZ.Button2Click(Sender: TObject);
begin
  if assigned(uo0) then
    with TXYZplot(uo0) do
    begin
      cadrerY(sender);
      editNum3.updateCtrl;
      editNum4.updateCtrl;
    end;
end;

procedure TCooXYZ.Button3Click(Sender: TObject);
begin
  if assigned(uo0) then
    with TXYZplot(uo0) do
    begin
      cadrerZ(sender);
      editNum5.updateCtrl;
      editNum6.updateCtrl;
    end;
end;



function TCooXYZ.Choose(uo:typeUO):boolean;
var
  XminOld,XmaxOld,YminOld,YmaxOld,ZminOld,ZmaxOld: double;
  ScaleColorOld,modeOld:integer;
  FshowScaleOld:boolean;
begin
  resetvar(self);
  uo0:=uo;

  with TXYZplot(uo0) do
  begin
    title1:=title;

    XminOld:=Xmin;
    XmaxOld:=Xmax;
    YminOld:=Ymin;
    YmaxOld:=Ymax;
    ZminOld:=Zmin;
    ZmaxOld:=Zmax;
    ScaleColorOld:=ScaleColor;
    FshowScaleOld:=FshowScale;

    editString1.setString(title1,1000);
    editnum1.setvar(Xmin,T_double);
    editnum2.setvar(Xmax,T_double);

    editnum3.setvar(Ymin,T_double);
    editnum4.setvar(Ymax,T_double);

    editnum5.setvar(Zmin,T_double);
    editnum6.setvar(Zmax,T_double);

    ColFrame1.init(ScaleColor);
    cbShowScale.setVar(FshowScale);
    cbShowGrid.setVar(FshowGrid);

    result:=(self.showModal=mrOK);

    if result then
    begin
      title:=title1;
    end
    else
    begin
      Xmin:=XminOld;
      Xmax:=XmaxOld;
      Ymin:=YminOld;
      Ymax:=YmaxOld;
      Zmin:=ZminOld;
      Zmax:=ZmaxOld;

      ScaleColor:=ScaleColorOld;
      FshowScale:=FshowScaleOld;
    end;
  end;
end;



Initialization
AffDebug('Initialization CoodXYZ',0);
{$IFDEF FPC}
{$I CoodXYZ.lrs}
{$ENDIF}
end.
