unit Utriangle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, ExtCtrls,
  util1, Dgraphic, Triangulation1, editcont;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Btriangles: TButton;
    Panel2: TPanel;
    PaintBox1: TPaintBox;
    BEdges: TButton;
    Bgo: TButton;
    Bflip: TButton;
    cbEdgeSel: TcomboBoxV;
    procedure BtrianglesClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BEdgesClick(Sender: TObject);
    procedure BgoClick(Sender: TObject);
    procedure BflipClick(Sender: TObject);
    procedure cbEdgeSelChange(Sender: TObject);
  private
    { Déclarations privées }
    EdgeSel: integer;
  public
    { Déclarations publiques }
    poly: Tpolyhedre;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  i:integer;
  gx,gy:float;
begin
  with paintBox1 do initGraphic(canvas,left,top,width,height);
  setPropWorld(-10,-10,150);
  if assigned(poly) then
  with poly do
  begin
    for i:=0 to triangles.Count-1 do
    with triangles[i] do
    begin
      canvasGlb.Pen.Color:=clBlack;
      canvasGlb.moveto(convWx(p1.x),convWy(p1.y));
      canvasGlb.lineto(convWx(p2.x),convWy(p2.y));
      canvasGlb.lineto(convWx(p3.x),convWy(p3.y));
      canvasGlb.lineto(convWx(p1.x),convWy(p1.y));

      gx:=(p1.x+p2.x+p3.x)/3;
      gy:=(p1.y+p2.y+p3.y)/3;
//      canvasGlb.moveto(convWx(gx),convWy(gy));
      canvasGlb.TextOut(convWx(gx),convwY(gy),Istr(i));

    end;

    if (EdgeSel>=0) and (EdgeSel<edges.Count) then
    with Edges[EdgeSel] do
    begin
      canvasGlb.Pen.Color:=clRed;
      canvasGlb.moveto(convWx(org.x),convWy(org.y));
      canvasGlb.lineto(convWx(dest.x),convWy(dest.y));
      canvasGlb.ellipse(convWx(dest.x)-2,convWy(dest.y)-2,convWx(dest.x)+2,convWy(dest.y)+2) ;

    end;

  end;

  doneGraphic;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  poly:= Tpolyhedre.create;
  poly.init(-1000,-1000,1000,1000);


  EdgeSel:=0;

  cbEdgeSel.SetNumList(0,20,1);
  cbEdgeSel.setVar(EdgeSel,G_longint,0);

end;

procedure TForm1.BgoClick(Sender: TObject);
const
  cnt:integer=0;
var
  i,j:integer;
begin
  for i:=1 to 9 do
  for j:=1 to 9 do
    poly.InsertPoint(i*10,j*10);
  {
  inc(cnt);
  case cnt of
    1:  poly.InsertPoint(5,6);
    2:  poly.InsertPoint(30,35);
    3:  poly.InsertPoint(15,50);
    4:  poly.InsertPoint(80,50);
  end;
  }
  paintbox1.Invalidate;
  memo1.Invalidate;
end;

procedure TForm1.BtrianglesClick(Sender: TObject);
begin
  if not assigned(poly) then exit;

  memo1.Clear;
  poly.PrintTrList(memo1);
end;

procedure TForm1.BEdgesClick(Sender: TObject);
begin
  if not assigned(poly) then exit;

  memo1.Clear;
  poly.PrintEdgeList(memo1);
end;


procedure TForm1.BflipClick(Sender: TObject);
begin
  poly.Check(poly.Edges[EdgeSel]);
  paintbox1.Invalidate;
end;

procedure TForm1.cbEdgeSelChange(Sender: TObject);
var
  st:string;
begin
  paintBox1.Invalidate;

  cbEdgeSel.UpdateVar;
  memo1.Clear;
  if (EdgeSel>=0) and (EdgeSel<poly.edges.Count) then
  with poly.Edges[EdgeSel] do
  begin
    st:= Istr1(EdgeSel,2)+'  '+ Estr1(org.x,3,0)+','+Estr1(org.y,3,0)+'      '+Estr1(dest.x,3,0)+','+Estr1(dest.y,3,0)+'      ' + Istr(poly.triangles.indexof(Tleft))+'  '+Istr(poly.triangles.indexof(Tright));
    memo1.lines.Add(st);
  end;


end;

end.
