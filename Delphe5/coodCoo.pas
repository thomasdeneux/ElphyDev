unit coodCoo;

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

  util1,visu0,Dtrace1,dataOpt1;

type
  TprocedureOfObject=procedure of object;

  TgetCooDcoo = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
    editNum3: TeditNum;
    editNum4: TeditNum;
    cbGrid: TCheckBoxV;
    Button5: TButton;
    Button6: TButton;
    GroupBox1: TGroupBox;
    cbValueX: TCheckBoxV;
    cbTicksX: TCheckBoxV;
    cbExternalX: TCheckBoxV;
    CbCompletX: TCheckBoxV;
    cbInvertX: TCheckBoxV;
    GroupBox2: TGroupBox;
    cbValueY: TCheckBoxV;
    cbTicksY: TCheckBoxV;
    cbExternalY: TCheckBoxV;
    cbCompletY: TCheckBoxV;
    CbInvertY: TCheckBoxV;
    Bcolor: TButton;
    Pcolor: TPanel;
    Bfont: TButton;
    cbKeepRatio: TCheckBoxV;
    ColorDialog2: TColorDialog;
    FontDialog1: TFontDialog;
    cbLogX: TCheckBoxV;
    cbLogY: TCheckBoxV;
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BcolorClick(Sender: TObject);
    procedure BfontClick(Sender: TObject);
  private
    { Déclarations private }
    visu0:^TVisuInfo;
  public
    { Déclarations public }
    function Choose(var visu:TVisuInfo):boolean;
  end;

function getCooDcoo: TgetCooDcoo;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FgetCooDcoo: TgetCooDcoo;

function getCooDcoo: TgetCooDcoo;
begin
  if not assigned(FgetCooDcoo) then FgetCooDcoo:= TgetCooDcoo.create(nil);
  result:= FgetCooDcoo;
end;

procedure TgetCooDcoo.Button5Click(Sender: TObject);
begin
  updateAllVar(self);
end;


function TgetCooDcoo.Choose(var visu:TVisuInfo):boolean;
begin
  visu0:=@visu;
  with visu do
  begin
    editnum1.setvar(Xmin,T_double);
    editnum2.setvar(Xmax,T_double);

    editnum3.setvar(Ymin,T_double);
    editnum4.setvar(Ymax,T_double);

    cbLogX.setVar(modelogX);
    cbLogY.setVar(modelogY);
    cbGrid.setVar(grille);

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

  end;


  result:=(showModal=mrOK);
end;



procedure TgetCooDcoo.FormActivate(Sender: TObject);
begin
  if assigned(visu0) then pcolor.color:=visu0^.ScaleColor;
end;

procedure TgetCooDcoo.BcolorClick(Sender: TObject);
begin
  if assigned(visu0) then
    with colorDialog2 do
    begin
      color:=visu0^.ScaleColor;
      execute;
      visu0^.ScaleColor:=color;
      Pcolor.color:=color;
    end;
end;

procedure TgetCooDcoo.BfontClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    font.assign(visu0^.fontVisu);
    execute;
    visu0^.FontVisu.assign(font);
  end;
end;

Initialization
AffDebug('Initialization coodCoo',0);
{$IFDEF FPC}
{$I coodCoo.lrs}
{$ENDIF}
end.
