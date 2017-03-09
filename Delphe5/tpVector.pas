unit Tpvector;


{  Autrefois ,fiche de base pour de nombreux objets
   Maintenant utilisée par TimagePlot (stmBmp1) et TbitmapPlot(stmBMplot)
}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls,

  util1, Buttons, Menus,editcont,
  opVec1,stmObj,debug0;

type
  Tpaint0 = class(TForm)
    PaintBox1: TPaintBox;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    Properties1: TMenuItem;
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Options1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure PaintBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
  private

  public
    { Déclarations public }
    beginDragG:function:boolean of object;
    Dproperties:procedure(sender:Tobject) of object;

  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}


procedure Tpaint0.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with paintBox1 do
  begin
    if assigned(beginDragG) and beginDragG then beginDrag(false);
  end
end;


procedure Tpaint0.Options1Click(Sender: TObject);
var
  BKcolor:Tcolor;
begin
  BKcolor:=color;
  with optionsVec1 do
  begin
    Adcolor:=@BKColor;
  end;
  if optionsVec1.showModal=mrOK then
    begin
      updateAllVar(optionsVec1);
      color:=BKcolor;
      refresh;
    end;

end;

procedure Tpaint0.Properties1Click(Sender: TObject);
begin
  if assigned(Dproperties) then Dproperties(sender);
end;


procedure Tpaint0.PaintBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  resetDragUO;
end;

Initialization
AffDebug('Initialization tpVector',0);
{$IFDEF FPC}
{$I Tpvector.lrs}
{$ENDIF}
end.
