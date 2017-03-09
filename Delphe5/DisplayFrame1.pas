unit DisplayFrame1;


{ TdispFrame permet d'afficher une trace avec un minimum d'instructions.

  Il faut placer un frame dans une fenêtre et l'initialiser avec InstallArray.
  On peut aussi initialiser les paramètres de visu.

  On dispose du menu Coordonnées/BK color avec le clic droit.
  On pourrait perfectionner afin d'avoir les commandes FastCOO.


}
interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,

  util1,Dgraphic,dtf0,visu0, BMex1,cood0, Menus, debug0;

type
  TDispFrame = class(TFrame)
    PaintBox1: TPaintBox;
    PopupMenu1: TPopupMenu;
    Coordinates1: TMenuItem;
    ColorDialog1: TColorDialog;
    Backgroundcolor1: TMenuItem;
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Coordinates1Click(Sender: TObject);
    procedure Backgroundcolor1Click(Sender: TObject);
  private
    { Déclarations privées }
    BMfen:TbitmapEx;
    Fvalid:boolean;
    visu0:^TvisuInfo;

    procedure resizeBM;
    procedure BMpaint(forcer:boolean);
    procedure DrawBM;

    procedure cadrerX(sender:Tobject);
    procedure cadrerY(sender:Tobject);

    procedure initVisu0;
    procedure doneVisu0;

  public
    { Déclarations publiques }
    data:typedataB;
    visu:TvisuInfo;

    color0:integer;

    constructor create(Aowner:Tcomponent);override;
    destructor destroy;override;

    procedure InstallArray(p:pointer;tp:typetypeG;n1,n2:integer);
    procedure invalidate;override;

    function Coo:boolean;
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TDispFrame }


constructor TDispFrame.create(Aowner:Tcomponent);
begin
  inherited create(Aowner);

  BMfen:=TbitmapEx.create;
  visu.init;
  color0:=clWhite;
end;

destructor TDispFrame.destroy;
begin
  BMfen.free;
  visu.done;
  inherited;

end;

procedure TDispFrame.resizeBM;
begin
  if (BMfen.width<>paintbox1.width) or (BMfen.height<>paintbox1.height) then
  begin
    BMfen.width:=paintbox1.width;
    BMfen.height:=paintbox1.height;

    Fvalid:=false;
  end;
end;

procedure TDispFrame.DrawBM;
begin
  paintbox1.canvas.draw(0,0,BMfen);
end;

procedure TDispFrame.BMpaint(forcer: boolean);
begin
  if not assigned(data) then exit;

  if not Fvalid or forcer then
  with BMfen do
  begin
    initGraphic(canvas,0,0,width,height);
    clearWindow(color0);
    visu.displayTrace(data,nil,0);
    doneGraphic;
  end;
end;

procedure TDispFrame.InstallArray(p: pointer; tp: typetypeG; n1,n2: integer);
begin
  data.free;
  data:=nil;

  case tp of
    G_smallint: data:=typedataI.create(p,1,n1,n1,n2);
    G_longint: data:=typedataL.create(p,1,n1,n1,n2);
    G_single:  data:=typedataS.create(p,1,n1,n1,n2);
    G_extended:data:=typedataE.create(p,1,n1,n1,n2);
  end;

  Fvalid:=false;
end;

procedure TDispFrame.PaintBox1Paint(Sender: TObject);
begin
  resizeBM;

  BMpaint(false);

  DrawBM;

  Fvalid:=true;
end;

procedure TDispFrame.invalidate;
begin
  Fvalid:=false;
  invalidateRect(handle,nil,false);
  {le invalidate de Delphi doit appeler invalidateRect(handle,nil,true), ce qui
   efface d'abord la fenêtre avant de réafficher }
end;

procedure TDispFrame.cadrerX(sender:Tobject);
begin
  visu0^.cadrerX(data);
end;

procedure TDispFrame.cadrerY(sender:Tobject);
begin
  visu0^.cadrerY(data);
end;

procedure TDispFrame.initVisu0;
begin
  new(visu0);
  visu0^.init;
  visu0^.assign(visu);
end;

procedure TDispFrame.doneVisu0;
begin
  visu0^.done;
  dispose(visu0);
  visu0:=nil;
end;


function TDispFrame.coo:boolean;
var
  chg:boolean;
  title0:AnsiString;
begin
  InitVisu0;

  title0:='';

  if cood.choose(title0,visu0^,cadrerX,cadrerY) then
    begin
      chg:= not visu.compare(visu0^);
      visu.assign(visu0^);
    end
  else chg:=false;

  DoneVisu0;

  result:=chg;
  if result then invalidate;
end;




procedure TDispFrame.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
begin
  p:=paintBox1.clientToScreen(point(x,y));
  if button=mbRight then
    popupMenu1.popup(p.x,p.y);

end;

procedure TDispFrame.Coordinates1Click(Sender: TObject);
begin
  coo;
end;

procedure TDispFrame.Backgroundcolor1Click(Sender: TObject);
begin
  ColorDialog1.Color:=color0;
  if ColorDialog1.execute then
    begin
      color0:=ColorDialog1.Color;
      invalidate;
    end;
end;

Initialization
AffDebug('Initialization DisplayFrame1',0);
{$IFDEF FPC}
{$I DisplayFrame1.lrs}
{$ENDIF}
end.
