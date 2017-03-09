unit dataOpt2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont, ExtCtrls,
  util1,debug0;

type
  TchooseMatOpt = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    cbValueX: TCheckBoxV;
    cbTicksX: TCheckBoxV;
    cbExternalX: TCheckBoxV;
    CbCompletX: TCheckBoxV;
    GroupBox2: TGroupBox;
    cbValueY: TCheckBoxV;
    cbTicksY: TCheckBoxV;
    cbExternalY: TCheckBoxV;
    cbCompletY: TCheckBoxV;
    Bcolor: TButton;
    Pcolor: TPanel;
    ColorDialog1: TColorDialog;
    Bfont: TButton;
    FontDialog1: TFontDialog;
    cbInvertX: TCheckBoxV;
    CbInvertY: TCheckBoxV;
    cbKeepRatio: TCheckBoxV;
    GroupBox3: TGroupBox;
    enDx: TLabel;
    enDeltaX: TeditNum;
    Label8: TLabel;
    enDeltaY: TeditNum;
    Label1: TLabel;
    enLeft: TeditNum;
    Label2: TLabel;
    enRight: TeditNum;
    Label3: TLabel;
    enTop: TeditNum;
    Label4: TLabel;
    enBottom: TeditNum;
    cbUsesWF: TCheckBoxV;
    cbX0: TCheckBoxV;
    cbY0: TCheckBoxV;
    procedure BcolorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BfontClick(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    AdScaleColor:^Tcolor;     {adresse de la variable couleur}
    FontS:Tfont;              {adresse de la fonte }
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TchooseMatOpt.BcolorClick(Sender: TObject);
begin
  if assigned(AdScaleColor) then
    with colorDialog1 do
    begin
      color:=AdScaleColor^;
      execute;
      AdScaleColor^:=color;
      Pcolor.color:=AdScaleColor^;
    end;
end;

procedure TchooseMatOpt.FormActivate(Sender: TObject);
begin
  if assigned(AdScaleColor) then pcolor.color:=AdScaleColor^;
end;

procedure TchooseMatOpt.BfontClick(Sender: TObject);
begin
  if assigned(FontS) then
    with FontDialog1 do
    begin
      font.assign(FontS);
      execute;
      FontS.assign(font);
    end;
end;

Initialization
AffDebug('Initialization dataOpt2',0);
{$IFDEF FPC}
{$I dataOpt2.lrs}
{$ENDIF}
end.
