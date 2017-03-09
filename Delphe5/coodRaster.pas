unit coodRaster;

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

  util1,stmobj,visu0,Dtrace1,dataOpt1, debug0;

type
  TprocedureOfObject=procedure of object;

  TgetRasterCoo = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
    editNum3: TeditNum;
    editNum4: TeditNum;
    Button5: TButton;
    Button6: TButton;
    GroupBox1: TGroupBox;
    cbValueX: TCheckBoxV;
    cbTicksX: TCheckBoxV;
    cbExternalX: TCheckBoxV;
    CbCompletX: TCheckBoxV;
    cbInvertX: TCheckBoxV;
    GroupBox2: TGroupBox;
    cbTitles: TCheckBoxV;
    cbGrid: TCheckBoxV;
    CbInvertY: TCheckBoxV;
    Bcolor: TButton;
    Pcolor: TPanel;
    Bfont: TButton;
    ColorDialog2: TColorDialog;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    enHline: TeditNum;
    Label6: TLabel;
    enTitleWidth: TeditNum;
    Label7: TLabel;
    enCpx: TeditNum;
    Label8: TLabel;
    enTailleT: TeditNum;
    procedure Button5Click(Sender: TObject);
    procedure BcolorClick(Sender: TObject);
    procedure BfontClick(Sender: TObject);
  private
    { Déclarations private }
    raster0:typeUO;
  public
    { Déclarations public }
    function Choose(p:pointer):boolean;
  end;

function getRasterCoo: TgetRasterCoo;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

uses stmRaster1;

var
  FgetRasterCoo: TgetRasterCoo;

function getRasterCoo: TgetRasterCoo;
begin
  if not assigned(FgetRasterCoo) then FgetRasterCoo:= TgetRasterCoo.create(nil);
  result:= FgetRasterCoo;
end;

procedure TgetRasterCoo.Button5Click(Sender: TObject);
begin
  updateAllVar(self);
end;


function TgetRasterCoo.Choose(p:pointer):boolean;
begin
  raster0:=typeUO(p);

  with TrasterPlot(raster0) do
  begin
    editnum1.setvar(visu0^.Xmin,T_double);
    editnum2.setvar(visu0^.Xmax,T_double);

    editnum3.setvar(visu0^.Ymin,T_double);
    editnum4.setvar(visu0^.Ymax,T_double);

    cbGrid.setVar(visu0^.grille);

    cbValueX.setVar(visu0^.echX);
    cbTicksX.setVar(visu0^.FtickX);
    cbExternalX.setvar(visu0^.tickExtX);
    CbCompletX.setvar(visu0^.completX);
    CbinvertX.setvar(visu0^.inverseX);

    cbTitles.setVar(Ftitle);
    CbinvertY.setvar(visu0^.inverseY);

    enHline.setVar(Hline,g_longint);
    enHline.setMinMax(0,100);

    enTitleWidth.setVar(Wtitle,g_longint);
    enTitleWidth.setMinMax(0,10000);

    enCpx.setVar(visu0^.cpx,g_smallint);
    enTailleT.setVar(visu0^.tailleT,g_byte);

    pcolor.color:=ScaleColor;
  end;


  result:=(showModal=mrOK);
end;



procedure TgetRasterCoo.BcolorClick(Sender: TObject);
begin
  if assigned(raster0) then
    with colorDialog2 do
    begin
      color:=TrasterPlot(raster0).visu0^.ScaleColor;
      execute;
      TrasterPlot(raster0).visu0^.ScaleColor:=color;
      Pcolor.color:=color;
    end;
end;

procedure TgetRasterCoo.BfontClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    font.assign(TrasterPlot(raster0).visu0^.fontVisu);
    execute;
    TrasterPlot(raster0).visu0^.FontVisu.assign(font);
  end;
end;

Initialization
AffDebug('Initialization coodRaster',0);
{$IFDEF FPC}
{$I coodRaster.lrs}
{$ENDIF}
end.
