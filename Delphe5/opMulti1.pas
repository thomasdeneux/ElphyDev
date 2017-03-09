unit opmulti1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls,
  debug0;

type
  TOptionsMultg1 = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ESname: TeditString;
    Btitlefont: TButton;
    BBKcol: TButton;
    PanelBKcol: TPanel;
    cbScaleFont: TCheckBoxV;
    BscaleFont: TButton;
    BscaleColor: TButton;
    PanelScaleColor: TPanel;
    CBtitles: TCheckBoxV;
    CBoutline: TCheckBoxV;
    CBnum: TCheckBoxV;
    GroupBox2: TGroupBox;
    esMgCaption: TeditString;
    Label2: TLabel;
    procedure BBKcolClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtitlefontClick(Sender: TObject);
    procedure BscaleColorClick(Sender: TObject);
    procedure BscaleFontClick(Sender: TObject);
    procedure cbScaleFontClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    AdBKcolor,AdScaleColor:^Tcolor;
    AdTitlefont,AdScaleFont:Tfont;
  end;

function OptionsMultg1: TOptionsMultg1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FOptionsMultg1: TOptionsMultg1;

function OptionsMultg1: TOptionsMultg1;
begin
  if not assigned(FOptionsMultg1) then FOptionsMultg1:= TOptionsMultg1.create(nil);
  result:= FOptionsMultg1;
end;


procedure TOptionsMultg1.BBKcolClick(Sender: TObject);
begin
  if assigned(AdBKcolor) then
    with colorDialog1 do
    begin
      color:=AdBKColor^;
      execute;
      AdBKColor^:=color;
      PanelBKcol.color:=AdBKcolor^;
    end;
end;

procedure TOptionsMultg1.FormActivate(Sender: TObject);
begin
  if assigned(AdBKcolor) then panelBKcol.color:=AdBKColor^;
  if assigned(AdScalecolor) then panelScalecolor.color:=AdScaleColor^;

end;

procedure TOptionsMultg1.BtitlefontClick(Sender: TObject);
begin
 if assigned(AdTitleFont) then
    with FontDialog1 do
    begin
      font.assign(AdTitleFont);
      execute;
      AdTitleFont.assign(font);
    end;
end;

procedure TOptionsMultg1.BscaleColorClick(Sender: TObject);
begin
  if assigned(AdScalecolor) then
    with colorDialog1 do
    begin
      color:=AdScaleColor^;
      execute;
      AdScaleColor^:=color;
      PanelScalecolor.color:=AdScalecolor^;
    end;
end;

procedure TOptionsMultg1.BscaleFontClick(Sender: TObject);
begin
  if assigned(AdScaleFont) then
    with FontDialog1 do
    begin
      font.assign(AdScaleFont);
      execute;
      AdScaleFont.assign(font);
    end;
end;

procedure TOptionsMultg1.cbScaleFontClick(Sender: TObject);
begin
  BscaleFont.Enabled:=TcheckBoxV(sender).Checked;
  BscaleColor.Enabled:=TcheckBoxV(sender).Checked;
  PanelScaleColor.visible:=TcheckBoxV(sender).Checked;

end;

Initialization
AffDebug('Initialization opMulti1',0);
{$IFDEF FPC}
{$I opmulti1.lrs}
{$ENDIF}
end.
