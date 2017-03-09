unit Dataopt1;

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
  TchooseOpt = class(TForm)
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
    cbX0: TCheckBoxV;
    cbY0: TCheckBoxV;
    procedure BcolorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BfontClick(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    AdScaleColor:^Tcolor;
    FontS:Tfont;
  end;

                   
implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TchooseOpt.BcolorClick(Sender: TObject);
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

procedure TchooseOpt.FormActivate(Sender: TObject);
begin
  if assigned(AdScaleColor) then pcolor.color:=AdScaleColor^;
end;

procedure TchooseOpt.BfontClick(Sender: TObject);
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
AffDebug('Initialization dataOpt1',0);
{$IFDEF FPC}
{$I Dataopt1.lrs}
{$ENDIF}
end.
