unit FirstGL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  GL, Glut,
  util1,DibG, StdCtrls, editcont,BMex1;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    scrollbarV1: TscrollbarV;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure scrollbarV1ScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    BMfen:TbitmapEx;

    angle:float;
    Nbits:integer;

  public
    { Déclarations publiques }

    procedure Dessin;
    procedure invalidate;override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure Tform1.dessin;
begin
  glEnable(GL_DEPTH_TEST);
  glViewPort(0,0,bmfen.Width div 2-1,bmfen.Height div 2-1);
  glClearColor(1,0,0,0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glColor3f(0,0,1);
  glLoadIdentity;
  glRotatef(angle, 1, 2, 3);
  glutWireTorus(0.2, 0.4, 16, 32);

  glViewPort(bmfen.Width div 2,bmfen.Height div 2,bmfen.Width div 2 -1,bmfen.Height div 2 -1);
  glLoadIdentity;
  glRotatef(angle, 1, 2, 3);
  glutWireTorus(0.2, 0.4, 16, 32);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Nbits:=getDeviceCaps(canvas.handle,bitsPixel);
  BMfen:=TbitmapEx.create;

  scrollbarV1.setParams(angle,0,360);
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  BMfen.free;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if (BMfen.width<>paintbox1.width) or
      (BMfen.height<>paintbox1.height)  then
    begin
      BMfen.width:=paintbox1.width;
      BMfen.height:=paintbox1.height;
    end;

end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  panel1.caption:=Istr(bmfen.Width)+' '+Istr(bmfen.Height) ;
  bmfen.Canvas.brush.Color:=clBlue;
  bmfen.Canvas.FillRect(rect(0,0,bmfen.Width-1,bmfen.Height-1));

  bmfen.initGLpaint;
  dessin;
  bmfen.doneGLpaint;

  {paintBM;}
                  
  initGraphic(bmfen);
  {bmfen.Canvas.brush.style:=bsClear;
  canvasGlb.TextOut(10,10,'Salut');}


  paintbox1.canvas.draw(0,0,BMfen);

end;

procedure Tform1.invalidate;
begin
  invalidateRect(handle,nil,false);
  {le invalidate de Delphi doit appeler invalidateRect(handle,nil,true), ce qui
   efface d'abord la fenêtre avant de réafficher }
end;


procedure TForm1.scrollbarV1ScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  angle:=x;
  invalidate;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  dib:Tbitmap;
begin
  dib:=Tbitmap.create;
  dib.width:=10;
  dib.height:=20;
  dib.free;

  messageCentral(Istr(getDeviceCaps(canvas.handle,bitsPixel)));;
end;

end.
