unit Regions1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysUtils,Graphics,forms,controls,math,
     editCont,
     util1,Dgraphic,stmDef,stmObj,formDlg2,IntegerSet1, stmDobj1;


{ Une région définit une zone dans une matrice, un bitmap ou un OIseq
  La région est définie en coordonnées réelles ( depuis le 16 janvier 2013).

}

type
  ThandleRects=array[1..8] of Trect;              {Les poignées permettant de modifier certaines régions}

  TpointList=array of Tpoint;

  TrealRect = record
                left,top,right,bottom: single;
              end;

  TSpoint= record
             x,y: single;
           end;

  Treg=class
          private
            ident:integer;                         {le type 1 pour rect , 2 pour ellipse, etc... }
            handle:Thandle;                        {le handle windows }

            pixList:array of Tpoint;               {liste des pixels}

          public
            myAd:pointer;
            color:integer;
            selected:boolean;                      
            filled:boolean;


            property regType:integer read ident;

            constructor create(x1a,y1a:single);
            class function regTypeName:AnsiString;virtual;

            procedure createHandle;virtual;
            procedure freeHandle;
            destructor destroy;override;
            function PtInRegion(x,y:single):boolean;virtual;
            procedure movePt(x,y:single;Fcorrect:boolean);virtual;

            procedure draw1;virtual;
            procedure draw;
            procedure AddPoint(x,y:single);virtual;

            procedure close;virtual;

            procedure move(dx,dy:single);virtual;
            procedure moveAbs(x,y:single);

            function pixCount:integer;
            procedure BuildPixList(dxu,x0u,dyu,y0u: float);
            function regionBox:Trealrect;virtual;

            function getPixel(num:integer):Tpoint;

            procedure AddPix(x1,y1: integer);
            procedure FreePix;
            procedure drawPix(dxu,x0u,dyu,y0u: float);

            procedure saveToStream(f:Tstream);virtual;
            procedure loadFromStream(f:Tstream);virtual;

            procedure saveToStream1(f:Tstream; DataPlot: TdataObj);virtual;
            procedure loadFromStream1(f:Tstream; DataPlot: TdataObj);virtual;

            function clone:Treg;virtual;

            function edit(title:AnsiString;xpos,ypos:integer):boolean;virtual;
            function getHandleRects(var rr:ThandleRects):integer;virtual;

            procedure modify(Hsel:integer; dx1, dy1: single);virtual;
            function CanRotate(var xR, yR: float): boolean;virtual;
            function ModifyTheta(deltaX,deltaY:float): float;virtual;
          end;

  Trectreg=class(Treg)
                x1,y1,x2,y2:single;

                constructor create(x1a,y1a:single);
                class function regTypeName:AnsiString;override;

                procedure createHandle;override;
                procedure draw1;override;
                procedure movePt(x,y:single;Fcorrect:boolean);override;
                function regionBox:Trealrect;override;

                procedure move(dx,dy:single);override;

                procedure saveToStream(f:Tstream);override;
                procedure loadFromStream(f:Tstream);override;

                procedure saveToStream1(f:Tstream; DataPlot: TdataObj);override;
                procedure loadFromStream1(f:Tstream; DataPlot: TdataObj);override;

                function clone:Treg;override;
                function edit(title:AnsiString;xpos,ypos:integer):boolean;override;
                function getHandleRects(var rr:ThandleRects):integer;override;

                procedure modify(Hsel:integer; dx1, dy1: single);override;
              end;

  Tellipsereg=
             class(Trectreg)
                constructor create(x1a,y1a:single);
                class function regTypeName:AnsiString;override;

                procedure createHandle;override;
                procedure draw1;override;
                procedure movePt(x,y:single;Fcorrect:boolean);override;

                function clone:Treg;override;
              end;

  Tpolygonreg=
             class(Treg)
                points:array of TSpoint;
                //times: array of longword;
                //time0:longword;

                constructor create(x1a,y1a:single);
                class function regTypeName:AnsiString;override;

                procedure createHandle;override;
                procedure draw1;override;
                procedure movePt(x,y:single;Fcorrect:boolean);override;
                procedure AddPoint(x,y:single);override;
                procedure close;override;
                function regionBox:Trealrect;override;

                procedure move(dx,dy:single);override;

                procedure saveToStream(f:Tstream);override;
                procedure loadFromStream(f:Tstream);override;
                procedure saveToStream1(f:Tstream; DataPlot: TdataObj);override;
                procedure loadFromStream1(f:Tstream; DataPlot: TdataObj);override;

                function clone:Treg;override;

                function getHandleRects(var rr:ThandleRects):integer;override;
              end;


  { TpixReg ne peut pas être construite au moyen de la souris
    La liste PixLines est construite directement pas des procédures externes.
  }
  Tpixreg=   class(Treg)

                Polygons:array of array of Tpoint;        {Contours permettant le tracé}

                constructor create;
                class function regTypeName:AnsiString;override;

                function PtInRegion(x,y:single):boolean;override;
                procedure draw1;override;

                procedure move(dx,dy:single);override;

                procedure saveToStream(f:Tstream);override;
                procedure loadFromStream(f:Tstream);override;
                procedure saveToStream1(f:Tstream; DataPlot: TdataObj);override;
                procedure loadFromStream1(f:Tstream; DataPlot: TdataObj);override;

                function clone:Treg;override;

                function regionBox:Trealrect;override;
                Procedure BuildPolygons;

                function getHandleRects(var rr:ThandleRects):integer;override;

              end;

  TSmartRectReg=
              class(Treg)
                deg:typeDegre;
                degIni:typeDegre;

                poly: TypePoly5R;

                procedure buildPoly;

                constructor create(x1a,y1a:single);
                class function regTypeName:AnsiString;override;

                procedure createHandle;override;
                procedure draw1;override;
                procedure movePt(x,y:single;Fcorrect:boolean);override;
                function regionBox:Trealrect;override;

                procedure move(dx1,dy1:single);override;

                procedure saveToStream(f:Tstream);override;
                procedure loadFromStream(f:Tstream);override;
                procedure saveToStream1(f:Tstream; DataPlot: TdataObj);override;
                procedure loadFromStream1(f:Tstream; DataPlot: TdataObj);override;

                function clone:Treg;override;
                function edit(title:AnsiString;xpos,ypos:integer):boolean;override;
                function getHandleRects(var rr:ThandleRects):integer;override;

                procedure modify(Hsel: integer; dx1, dy1: single);override;
                function CanRotate(var xR, yR: float): boolean;override;
                function ModifyTheta(deltaX,deltaY:float): float;override;
              end;


  TregList=class(Tlist)
              private
                 function getregion(i:integer):Treg;
               public
                 DefColor:integer;
                 NumHighLight:integer;            { Numéro de la région sélectionnée}
                 HighLightColor:integer;

                 LastSelected:integer;
                 HandleRects: THandleRects;
                 NbHandleRects:integer;
                 constructor create;

                 property region[i:integer]:Treg read getRegion;default; {i commence à zéro }
                 function last:Treg;
                 function PtInRegion(x,y:single;var numReg:integer): integer;

                 destructor destroy;override;
                 procedure clear;
                 procedure copy(regList:TregList);

                 procedure setColors(w:integer);
                 procedure Draw;
                 procedure delete(num:integer);
                 procedure BuildPixLists(dxu,x0u,dyu,y0u: float);
                 procedure drawPix(dxu,x0u,dyu,y0u: float);

                 procedure saveToStream(f:Tstream; dataPlot:TdataObj);
                 function loadFromStream(f:Tstream; dataPlot:TdataObj):boolean;

                 function loadFromFile(st:AnsiString; dataPlot:TdataObj): boolean;
                 function saveToFile(st:AnsiString; dataPlot:TdataObj): boolean;

                 procedure AddReg(rr:Treg);
                 procedure AddRegList(rr:TregList);

                 procedure AddSelection(n:integer);
                 procedure moveSelection(x1,y1:single);
                 procedure modifySelection(Hsel: integer; dx1,dy1:single);

                 procedure ClearSelection;
                 procedure deleteSelection;

                 procedure ShowHandles;
                 function PtInHandleRect(x,y: integer): integer;

                 function CanRotate(var xR,yR: float): boolean;
                 function ModifyTheta(deltaX,deltaY:float):float;
              end;




implementation

uses stmMat1;

{ Treg }

procedure Treg.AddPoint(x, y: single);
begin

end;



function Treg.RegionBox:Trealrect;
begin
  with result do
  begin
    left:=0;
    right:=0;
    top:=0;
    bottom:=0;
  end;
end;

procedure Treg.close;
begin

end;

constructor Treg.create(x1a, y1a: single);
begin
  myAd:=self;
end;

procedure Treg.createHandle;
begin

end;

destructor Treg.destroy;
begin
  freeHandle;
  inherited;
end;

procedure Treg.draw1;
begin

end;

procedure Treg.draw;
begin
  if selected
    then canvasGlb.Pen.width:=2
    else canvasGlb.Pen.width:=1;
  if filled
    then canvasGlb.brush.style:=bsSolid
    else canvasGlb.brush.style:=bsCLear;

  try
    draw1;
  finally
    canvasGlb.Pen.width:=1;
    canvasGlb.brush.style:=bsCLear;
  end;
end;


procedure Treg.freeHandle;
begin
  deleteObject(handle);
  handle:=0;
end;


procedure Treg.FreePix;
begin
  setLength(pixList,0);
end;



function Treg.getPixel(num: integer): Tpoint;
begin
  result:=PixList[num];
end;



procedure Treg.movePt(x, y: single;Fcorrect:boolean);
begin

end;

procedure Treg.move(dx, dy: single);
begin

end;

procedure Treg.moveAbs(x, y: single);
begin
  with regionBox do move(x-left,y-top);
end;


function Treg.PtInRegion(x,y:single): boolean;
begin
  createHandle;
  result:=(handle<>0) and windows.PtInRegion(handle,round(x*10),round(y*10));
  freeHandle;
end;

procedure Treg.drawPix(dxu,x0u,dyu,y0u: float);
var
  i,j:integer;
  old:TbrushStyle;
  x1,x2,y1,y2:float;
begin
  if length(pixList)=0 then BuildPixList(dxu,x0u,dyu,y0u);


  with canvasGlb do
  begin
    pen.Color:=clRed;

    old:=brush.style;
    brush.Style:=bsClear;

    for i:=0 to high(pixList) do
    with pixList[i] do
    begin
      x1:= dxu*x+x0u;
      x2:= x1+dxu;
      y1:= dyu*y+y0u;
      y2:= y1+dyu;

      rectangle(convWx(x1),convWy(y1),convWx(x2),convWy(y2));
      if (i mod 1000=0) and testEscape then break;
    end;
    brush.style:=old;
  end;
end;

procedure Treg.loadFromStream(f: Tstream);
begin
end;

procedure Treg.saveToStream(f: Tstream);
begin
end;

procedure Treg.loadFromStream1(f: Tstream; DataPlot: TdataObj);
begin
end;

procedure Treg.saveToStream1(f: Tstream; DataPlot: TdataObj);
begin
end;


function Treg.clone: Treg;
begin
  result:=Treg.create(0,0);
end;

class function Treg.regTypeName: AnsiString;
begin
  result:='';
end;


function Treg.edit(title:AnsiString;xpos,ypos:integer):boolean;
var
  dlg:TdlgForm2;
begin
  dlg:=TdlgForm2.create(formStm);
  TRY
  dlg.borderStyle:=bsDialog;
  dlg.Caption:=title;

  dlg.Position:=poDesigned; {Seule cette valeur permet de changer la position}
  dlg.Left:=xpos;
  dlg.Top:=ypos;

  dlg.setColor('Color',color);
  dlg.setBoolean('Filled',filled);

  result:=(dlg.ShowModal=mrOK);
  if result then updateAllVar(dlg);
  FINALLY
  dlg.free;
  END;
end;

function Treg.getHandleRects(var rr: ThandleRects): integer;
begin
  result:=0;
end;

procedure Treg.modify(Hsel: integer; dx1, dy1: single);
begin

end;

procedure Treg.BuildPixList(dxu,x0u,dyu,y0u: float);
var
  regBox: TRect;
  i,j: integer;
  x,y:single;
begin
  freePix;

  with regionBox do
  begin
    regBox.left:=  round((left-x0u)/dxu);
    regBox.right:= round((right-x0u)/dxu);
    regBox.top:=   round((top-y0u)/dyu);
    regBox.bottom:=round((bottom-y0u)/dyu);
  end;

  with regbox do
  begin
    if Left>Right then swap(Left,Right);
    if top>bottom then swap(top,bottom);
  end;

  for i:=regbox.left to regbox.right do
  for j:=regbox.top to regbox.bottom do
  begin
    x:= (i+0.5)*dxu+x0u;
    y:= (j+0.5)*dyu+y0u;
    if ptInRegion( x,y ) then AddPix(i,j);
  end;

end;

function Treg.pixCount:integer;
begin
  result:=length(PixList);
end;

function Treg.CanRotate(var xR, yR: float): boolean;
begin
  result:=false;
end;

function Treg.ModifyTheta(deltaX, deltaY: float): float;
begin
  result:=0;
end;

procedure Treg.AddPix(x1, y1: integer);
begin
  setLength(PixList,length(PixList)+1);
  with PixList[high(PixList)] do
  begin
    x:=x1;
    y:=y1;
  end;
end;

{ Trectreg }



function TrectReg.RegionBox:TRealRect;
begin
  with result do
  begin
    left:=x1;
    right:=x2;
    top:=y1;
    bottom:=y2;
  end;
end;


constructor Trectreg.create(x1a, y1a: single);
begin
  inherited;

  ident:=1;

  x1:=x1a;
  y1:=y1a;
  x2:=x1a;
  y2:=y1a;
end;


procedure Trectreg.createHandle;
begin
   handle:=createRectRgn(round(x1*10),round(y1*10),round(x2*10),round(y2*10));
end;

procedure Trectreg.draw1;
begin
  canvasGlb.pen.Color:=color;
  if canvasGlb.Brush.style=bsSolid
    then canvasGlb.brush.Color:=color;

  canvasGlb.Rectangle(convWx(x1),convWy(y1),convWx(x2),convWy(y2));
end;


procedure Trectreg.movePt(x, y: single;Fcorrect:boolean);
begin
  x2:=x;
  y2:=y;

  if Fcorrect then
  begin
    if x2<x1 then
    begin
      x:=x1;
      x1:=x2;
      x2:=x;
    end;

    if y2<y1 then
    begin
      y:=y1;
      y1:=y2;
      y2:=y;
    end;
  end;

  freePix;
end;

type
  TrecRectreg=record
                x1,y1,x2,y2:integer;
                color:integer
              end;

procedure Trectreg.move(dx, dy: single);
begin
  x1:=x1+dx;
  x2:=x2+dx;
  y1:=y1+dy;
  y2:=y2+dy;
  freePix;
end;

procedure Trectreg.saveToStream(f: Tstream);
var
  rec:TrecRectreg;
  size:integer;
begin
  size:=sizeof(rec);
  rec.x1:=round(x1);
  rec.y1:=round(y1);
  rec.x2:=round(x2);
  rec.y2:=round(y2);
  rec.color:=color;

  f.Write(size,sizeof(size));
  f.Write(rec,sizeof(rec));
end;

procedure Trectreg.loadFromStream(f: Tstream);
var
  rec:TrecRectreg;
  size:integer;
begin
  f.read(size,sizeof(size));
  f.read(rec,size);

  x1:=rec.x1;
  y1:=rec.y1;
  x2:=rec.x2;
  y2:=rec.y2;
  color:=rec.color;
end;

type
  TrecRectregR=record
                x1,y1,x2,y2:single;
                color:integer
              end;


procedure Trectreg.saveToStream1(f: Tstream; DataPlot: TdataObj);
var
  rec:TrecRectregR;
  size:integer;
begin
  size:=sizeof(rec);
  rec.x1:=x1;
  rec.y1:=y1;
  rec.x2:=x2;
  rec.y2:=y2;
  rec.color:=color;

  f.Write(size,sizeof(size));
  f.Write(rec,sizeof(rec));
end;

procedure Trectreg.loadFromStream1(f: Tstream; DataPlot: TdataObj);
var
  rec:TrecRectregR;
  size:integer;
begin
  f.read(size,sizeof(size));
  f.read(rec,sizeof(rec));

  x1:=rec.x1;
  y1:=rec.y1;
  x2:=rec.x2;
  y2:=rec.y2;
  color:=rec.color;
end;


function Trectreg.clone: Treg;
begin
  result:=Trectreg.create(x1,y1);
  Trectreg(result).x2:=x2;
  Trectreg(result).y2:=y2;
end;



class function Trectreg.regTypeName: AnsiString;
begin
  result:='Rectangle';
end;

function Trectreg.edit(title:AnsiString;xpos,ypos:integer): boolean;
var
  dlg:TdlgForm2;
  w,h:single;
begin
  dlg:=TdlgForm2.create(formStm);
  dlg.borderStyle:=bsDialog;
  dlg.Caption:=title;

  dlg.Position:=poDesigned; {Seule cette valeur permet de changer la position}
  dlg.Left:=xpos;
  dlg.Top:=ypos;

  w:=x2-x1;
  h:=y2-y1;

  dlg.setNumVar('left',x1,g_single,6,0);
  dlg.setNumVar('top',y1,g_single,6,0);
  dlg.setNumVar('width',w,g_single,6,0);
  dlg.setNumVar('height',h,g_single,6,0);
  dlg.setColor('Color',color);
  dlg.setBoolean('Filled',filled);

  if dlg.ShowModal=mrOK then
  begin
    updateAllVar(dlg);
    x2:=x1+w;
    y2:=y1+h;
  end;

end;

function Trectreg.getHandleRects(var rr: ThandleRects): integer;
function box(x,y:float):Trect;
var
  i,j:integer;
begin
  i:=convWx(x);
  j:=convWy(y);
  result:=rect(i-2,j-2,i+2,j+2);
end;

begin                         {          7            }
  rr[1]:=box(x1,y1);          {    4 ---------- 3     }
  rr[2]:=box(x2,y1);          {     |          |      }
  rr[3]:=box(x2,y2);          {   8 |          | 6    }
  rr[4]:=box(x1,y2);          {     |          |      }
                              {    1 ---------- 2     }
                              {          5            }
  rr[5]:=box((x1+x2)/2, y1);
  rr[6]:=box(x2, (y1+y2)/2);
  rr[7]:=box((x1+x2)/2, y2);
  rr[8]:=box(x1, (y1+y2)/2);

  result:=8;
end;


procedure Trectreg.modify(Hsel:integer; dx1, dy1: single);
procedure dep(var x,y:single);
begin
  x:=x+dx1;
  y:=y+dy1;
end;
begin
  case Hsel of
    1:   dep(x1,y1);
    2:   dep(x2,y1);
    3:   dep(x2,y2);
    4:   dep(x1,y2);

    5:   y1:=y1+dy1;
    6:   x2:=x2+dx1;
    7:   y2:=y2+dy1;
    8:   x1:=x1+dx1;
  end;

  if x1>x2 then swap(x1,x2);
  if y1>y2 then swap(y1,y2);

  freePix;
end;





{ Tellipsereg }



constructor Tellipsereg.create(x1a, y1a: single);
begin
  inherited;

  ident:=2;

  x1:=x1a;
  y1:=y1a;
  x2:=x1a;
  y2:=y1a;
end;


procedure Tellipsereg.createHandle;
begin
   handle:=createEllipticRgn(round(x1*10),round(y1*10),round(x2*10),round(y2*10));
end;

procedure Tellipsereg.draw1;
begin
  canvasGlb.pen.Color:=color;
  if canvasGlb.Brush.style=bsSolid
    then canvasGlb.brush.Color:=color;
  canvasGlb.ellipse(convWx(x1),convWy(y1),convWx(x2),convWy(y2));
end;

procedure Tellipsereg.movePt(x, y: single;Fcorrect:boolean);
begin
  x2:=x;
  y2:=y;

  if Fcorrect then
  begin
    if x2<x1 then
    begin
      x:=x1;
      x1:=x2;
      x2:=x;
    end;

    if y2<y1 then
    begin
      y:=y1;
      y1:=y2;
      y2:=y;
    end;
  end;

  freePix;
end;

function Tellipsereg.clone: Treg;
begin
  result:=Tellipsereg.create(x1,y1);
  Tellipsereg(result).x2:=x2;
  Tellipsereg(result).y2:=y2;
end;

class function Tellipsereg.regTypeName:AnsiString;
begin
  result:='Ellipse';
end;


{ Tpolygonreg }

procedure Tpolygonreg.AddPoint(x, y: single);
begin
  setLength(points,length(points)+1);
  points[high(points)].x:=x;
  points[high(points)].y:=y;

  freePix;
end;



function TpolygonReg.RegionBox:Trealrect;
var
  i: integer;
begin
  with result do
  begin
    left:= 1E20;
    right:=-1E20;
    top:= 1E20;
    bottom:=-1E20;
  end;

  with result do
  for i:=0 to high(points) do
  begin
    if points[i].x < left then left:= points[i].x;
    if points[i].x > right then right:= points[i].x;
    if points[i].y < top then top:= points[i].y;
    if points[i].y > bottom then bottom:= points[i].y;
  end;

end;


procedure Tpolygonreg.close;
begin
  if length(points)>0 then
    AddPoint(points[0].X,points[0].Y);
  freePix;
end;

constructor Tpolygonreg.create(x1a, y1a: single);
begin
  inherited;

  ident:=3;

  setLength(points,2);
  points[0].x:= x1a;
  points[0].y:= y1a;

  points[1]:=points[0];
end;


procedure Tpolygonreg.createHandle;
var
  i:integer;
  pts:array of Tpoint;
begin
  setLength(pts,length(points));

  for i:=0 to high(points) do
  with points[i] do
  begin
    pts[i].x:=round(x*10);
    pts[i].y:=round(y*10);
  end;
  handle:=CreatePolygonRgn( pts[0],length(pts),WINDING);
end;

procedure Tpolygonreg.draw1;
var
  poly:array of Tpoint;
  i:integer;
begin
  setlength(poly,length(points));
  for i:=0 to length(points)-1 do
  begin
    poly[i].x:=convWx(points[i].X);
    poly[i].y:=convWy(points[i].Y);
  end;

  canvasGlb.pen.Color:=color;
  if canvasGlb.Brush.style=bsSolid
    then canvasGlb.brush.Color:=color;
  canvasGlb.Polyline(poly) ;
end;


procedure Tpolygonreg.movePt(x, y: single;Fcorrect:boolean);
begin
  points[high(points)].x:= x;
  points[high(points)].y:= y;

  freePix;
end;

procedure Tpolygonreg.move(dx, dy: single);
var
  i:integer;
begin
  for i:=0 to high(points) do
  with points[i] do
  begin
    x:=x+dx;
    y:=y+dy;
  end;
  freePix;
end;

procedure Tpolygonreg.saveToStream(f:Tstream);
var
  nb:integer;
  size:integer;
begin
  nb:=length(points);
  size:=sizeof(color)+Sizeof(nb)+sizeof(Tpoint)*nb;

  f.Write(size,sizeof(size));
  f.Write(color,sizeof(color));
  f.Write(nb,sizeof(nb));
  if nb>0 then f.Write(points[0],sizeof(Tpoint)*nb);
end;


procedure Tpolygonreg.loadFromStream(f:Tstream);
var
  size,nb:integer;
begin
  f.Read(size,sizeof(size));
  f.Read(color,sizeof(color));
  f.read(nb,sizeof(nb));
  setLength(points,nb);
  if nb>0 then  f.read(points[0],sizeof(Tpoint)*nb);
end;



procedure Tpolygonreg.saveToStream1(f:Tstream; dataPlot: TdataObj);
var
  i,nb:integer;
  size:integer;
begin
  nb:=length(points);
  size:=sizeof(color)+Sizeof(nb)+sizeof(TSpoint)*nb;

  f.Write(size,sizeof(size));
  f.Write(color,sizeof(color));
  f.Write(nb,sizeof(nb));
  if nb>0 then f.Write(pointS[0],sizeof(TSpoint)*nb);
end;


procedure Tpolygonreg.loadFromStream1(f:Tstream; dataPlot: TdataObj);
var
  i,size,nb:integer;
begin
  f.Read(size,sizeof(size));
  f.Read(color,sizeof(color));
  f.read(nb,sizeof(nb));

  setLength(points,nb);

  if nb>0 then  f.read(pointS[0],sizeof(TSpoint)*nb);
end;


function TpolygonReg.clone: Treg;
var
  i:integer;
begin
  if length(points)>0
    then result:=Tpolygonreg.create(points[0].x,points[0].y)
    else result:=Tpolygonreg.create(0,0);

  for i:=1 to high(points) do
    Tpolygonreg(result).AddPoint(points[i].X,points[i].Y);
end;

class function Tpolygonreg.regTypeName:AnsiString;
begin
  result:='Polygon';
end;


function Tpolygonreg.getHandleRects(var rr: ThandleRects): integer;
begin
  result:=0;
end;


{ TsmartRectReg }



function TsmartRectReg.RegionBox:Trealrect;
var
  i: integer;
begin
  with result do
  begin
    left:= 1E20;
    right:=-1E20;
    top:= 1E20;
    bottom:=-1E20;
  end;

  BuildPoly;

  with result do
  for i:=1 to 4 do
  begin
    if poly[i].x < left then left:= poly[i].x;
    if poly[i].x > right then right:= poly[i].x;
    if poly[i].y < top then top:= poly[i].y;
    if poly[i].y > bottom then bottom:= poly[i].y;
  end;

end;


constructor TsmartRectReg.create(x1a, y1a: single);
begin
  inherited;

  ident:=5;

  with deg do
  begin
    x:=x1a;
    y:=y1a;
    dx:=1;
    dy:=1;
    theta:=0;
  end;
  BuildPoly;
end;


procedure TsmartRectReg.createHandle;
var
  i:integer;
  poly1: typePoly5;
begin
  for i:=1 to 5 do
  with poly[i] do
  begin
    poly1[i].x:=round(x*10);
    poly1[i].y:=round(y*10);
  end;
  handle:=CreatePolygonRgn( poly1,5,WINDING);
end;

procedure TsmartRectReg.draw1;
var
  poly1:typePoly5;
  i:integer;
begin
  buildPoly;
  canvasGlb.pen.Color:=color;
  if canvasGlb.Brush.style=bsSolid
    then canvasGlb.brush.Color:=color;

  for i:=1 to 5 do
  begin
    poly1[i].x:=convWx(poly[i].X);
    poly1[i].y:=convWy(poly[i].Y);
  end;

  canvasGlb.pen.Color:=color;
  if canvasGlb.Brush.style=bsSolid
    then canvasGlb.brush.Color:=color;
  canvasGlb.Polyline(poly1) ;
end;


procedure TsmartRectReg.movePt(x, y: single;Fcorrect:boolean);
begin
  deg.dx:=abs(x-deg.x);
  deg.dy:=abs(y-deg.y);

  if deg.dx=0 then deg.dx:=1;
  if deg.dy=0 then deg.dy:=1;

  buildPoly;
  freePix;
end;


procedure TsmartRectReg.move(dx1, dy1: single);
begin
  deg.x:=deg.x+dx1;
  deg.y:=deg.y+dy1;

  buildPoly;
  freePix;
end;

procedure TsmartRectReg.saveToStream(f: Tstream);
var
  size:integer;
begin
  size:=sizeof(deg)+sizeof(color);

  f.Write(size,sizeof(size));
  f.Write(deg,sizeof(deg));
  f.Write(color,sizeof(color));
end;

procedure TsmartRectReg.loadFromStream(f: Tstream);
var
  size: integer;
begin
  f.read(size,sizeof(size));
  f.read(deg,sizeof(deg));
  f.read(color,sizeof(color));
end;


procedure TsmartRectReg.saveToStream1(f: Tstream; dataPlot: TdataObj);
var
  size:integer;
begin
  size:=sizeof(deg)+sizeof(color);
  f.write(size,sizeof(size));
  f.write(deg,sizeof(deg));
  f.write(color,sizeof(color));
end;


procedure TsmartRectReg.loadFromStream1(f: Tstream; dataPlot: TdataObj);
var
  size:integer;
begin
  f.read(size,sizeof(size));
  f.read(deg,sizeof(deg));
  f.Read(color,sizeof(color));
end;


function TsmartRectReg.clone: Treg;
begin
  result:=TsmartRectReg.create(0,0);
  TsmartRectReg(result).deg:=deg;
end;



class function TsmartRectReg.regTypeName: AnsiString;
begin
  result:='Rectangle';
end;

function TsmartRectReg.edit(title:AnsiString;xpos,ypos:integer): boolean;
var
  dlg:TdlgForm2;
  w,h:integer;
begin
  dlg:=TdlgForm2.create(formStm);
  dlg.borderStyle:=bsDialog;
  dlg.Caption:=title;

  dlg.Position:=poDesigned; {Seule cette valeur permet de changer la position}
  dlg.Left:=xpos;
  dlg.Top:=ypos;

  dlg.setNumVar('xc',deg.x,g_single,10,3);
  dlg.setNumVar('yc',deg.y,g_single,10,3);
  dlg.setNumVar('dx',deg.dx,g_single,10,3);
  dlg.setNumVar('dy',deg.dy,g_single,10,3);
  dlg.setNumVar('theta',deg.theta,g_single,10,3);

  dlg.setColor('Color',color);
  dlg.setBoolean('Filled',filled);

  if dlg.ShowModal=mrOK then
  begin
    updateAllVar(dlg);
    BuildPoly;
  end;

end;

function TsmartRectReg.getHandleRects(var rr: ThandleRects): integer;
var
  xm, ym: float;
  i: integer;
function box(x,y:float):Trect;
var
  i,j:integer;
begin
  i:=convWx(x);
  j:=convWy(y);
  result:=rect(i-2,j-2,i+2,j+2);
end;

begin                         {          7            }
  for i:=1 to 4 do
  with poly[i] do
  begin
    rr[i]:= box(x,y);

    xm:=(x+poly[i+1].x) / 2;
    ym:=(y+poly[i+1].y) / 2;
    rr[i+4]:= box(xm,ym);
  end;

  result:=8;

  degini:=deg;
end;


procedure TsmartRectReg.modify(Hsel:integer; dx1, dy1: single);
var
  dxs,dys:float;
  alpha:float;
  s,m,p:TRpoint;
  polyR:typePoly5R;
  oldDeg:typeDegre;
  old:single;
begin
  oldDeg:=deg;
  case Hsel of
    1..4:
      begin
            alpha:=-deg.theta*pi/180;
            if (Hsel=2) or (Hsel=3) then alpha:=alpha+pi;

            dxs:= poly[Hsel].x+ dx1 -deg.x;
            dys:= poly[Hsel].y+ dy1 -deg.y;
            deg.dx:=abs(2*dxs*cos(alpha)-2*dys*sin(alpha));
            deg.dy:=abs(2*dxs*sin(alpha)+2*dys*cos(alpha));
            if deg.dx<=1 then deg.dx:=2;
            if deg.dy<=1 then deg.dy:=2;
      end;
    5..8:
      begin
            degToPolyR(degIni,polyR);

            s.x:= (poly[Hsel-3].x+poly[Hsel-4].x) / 2 +dx1;
            s.y:= (poly[Hsel-3].y+poly[Hsel-4].y) / 2 +dy1;

            m.x:=(polyR[Hsel-3].x+polyR[Hsel-4].x)/2;
            m.y:=(polyR[Hsel-3].y+polyR[Hsel-4].y)/2;


            p.x:=s.x+polyR[Hsel-3].x-m.x;
            p.y:=s.y+polyR[Hsel-3].y-m.y;

            deg:=degIni;
            alignVerticeOnSegment(deg,Hsel-4,s,p);
      end;
  end;

  buildPoly;
  freePix;
end;



procedure TSmartRectReg.buildPoly;
var
  i:Integer;
  dx2,dy2:single;
  PR:typePoly5R;

begin
  dx2:=deg.dx/2;
  dy2:=deg.dy/2;

  DegRotationR(dx2,-dy2,PR[1].x,PR[1].y,0,0,deg.theta);
  DegRotationR(-dx2,-dy2,PR[2].x,PR[2].y,0,0,deg.theta);

  PR[3].x:=-PR[1].x;
  PR[3].y:=-PR[1].y;
  PR[4].x:=-PR[2].x;
  PR[4].y:=-PR[2].y;

  for i:=1 to 4 do
  begin
    poly[i].x:= PR[i].x+deg.x;
    poly[i].y:= PR[i].y+deg.y;
  end;
  Poly[5]:=Poly[1];
end;



function TSmartRectReg.CanRotate(var xR, yR: float): boolean;
begin
  result:=true;
  xR:=deg.x;
  yR:=deg.y;
end;

function TSmartRectReg.ModifyTheta(deltaX, deltaY: float): float;
begin
  deg.theta:=calculTheta(deltaX,deltaY);
  result:= deg.theta;
end;

{ Tpixreg }

constructor Tpixreg.create;
begin
  myad:=self;
  ident:=4;
end;

class function Tpixreg.regTypeName:AnsiString;
begin
  result:='PixelList';
end;

procedure Tpixreg.draw1;
var
  i,j:integer;
  poly:array of Tpoint;
begin
  canvasGlb.pen.Color:=color;
  if canvasGlb.Brush.style=bsSolid
    then canvasGlb.brush.Color:=color;

  for i:=0 to high(polygons) do
  begin
    setlength(poly,length(polygons[i]));
    for j:=0 to high(polygons[i]) do
    begin
      poly[j].x:=convWx(polygons[i][j].X);
      poly[j].y:=convWy(polygons[i][j].Y);
    end;

    if filled
      then canvasGlb.Polygon(poly)
      else canvasGlb.Polyline(poly);
  end;
end;

function Tpixreg.PtInRegion(x,y:single):boolean;
var
  i:integer;
  i0,j0:integer;
begin
  result:=true;
  i0:=round(x);
  j0:=round(y);
  for i:=0 to high(pixlist) do
  with pixlist[i] do
  if (x=i0) and (y=j0) then exit;

  result:=false;
end;


procedure Tpixreg.move(dx,dy:single);
var
  i:integer;
begin
  for i:=0 to high(pixlist) do
  with pixlist[i] do
  begin
    x:= x+ round(dx);
    y:= y+ round(dy);
  end;
  BuildPolygons;
end;

procedure Tpixreg.saveToStream(f:Tstream);
var
  nb:integer;
  size:integer;
begin
  nb:=length(pixlist);
  size:=sizeof(color)+Sizeof(nb)+sizeof(Tpoint)*nb;

  f.Write(size,sizeof(size));
  f.Write(color,sizeof(color));
  f.Write(nb,sizeof(nb));
  if nb>0 then f.Write(pixlist[0],sizeof(Tpoint)*nb);
end;


procedure Tpixreg.loadFromStream(f:Tstream);
var
  size,nb:integer;
begin
  f.Read(size,sizeof(size));
  f.Read(color,sizeof(color));
  f.read(nb,sizeof(nb));
  setLength(pixList,nb);
  if nb>0 then  f.read(pixlist[0],sizeof(Tpoint)*nb);
end;



procedure Tpixreg.saveToStream1(f:Tstream; dataPlot: TdataObj);
begin
  saveToStream(f);
end;


procedure Tpixreg.loadFromStream1(f:Tstream; dataPlot: TdataObj);
begin
  loadFromStream(f);
end;


function Tpixreg.clone:Treg;
begin
  result:=Tpixreg.create;

  setLength(result.pixList,length(pixlist));
  system.move(pixlist[0],result.pixlist[0],sizeof(Tpoint)*length(pixList));
end;

function TpixReg.regionBox:Trealrect;
var
  i:integer;
begin
  if length(pixlist)=0 then
  with result do
  begin
    left:=  0;
    right:= 0;
    top:=   0;
    bottom:=0;
    exit;
  end;

  with result,pixlist[0] do
  begin
    left:=  x;
    right:= x+1;
    top:=   y;
    bottom:=y+1;
  end;

  for i:=1 to high(pixlist) do
  with pixlist[i],result do
  begin
    if y<top then top:=y;
    if y+1>bottom then bottom:=y+1;
    if x<left then left:=x;
    if x+1>right then right:=x;
  end;
end;



Procedure TpixReg.BuildPolygons;
var
  MatP:array of array of boolean; {Tableau des points appartenant à la région}
  rect0:Trealrect;                {region box}

  BV,BH:array of array of boolean;
  N1,N2:integer;
  VV,fin:boolean;
  i,j,k,i0,j0:integer;
  last:Tpoint;

procedure add0(i1,j1:integer);
begin
  setLength(polygons,length(polygons)+1);
  setLength(polygons[high(polygons)],1);
  polygons[high(polygons),0]:=point(i1,j1);
  last:=point(i1,j1);
end;

procedure add1(i1,j1:integer);
begin
  setLength(polygons[high(polygons)],length(polygons[high(polygons)])+1);
  polygons[high(polygons),high(polygons[high(polygons)])]:=point(i1,j1);
  last:=point(i1,j1);
end;

procedure clore;
var
  p1,p2:Tpoint;
begin
  if (length(polygons)>0) and (length(polygons[high(polygons)])>1) then
  begin
    p1:=polygons[high(polygons),0];
    p2:=polygons[high(polygons),high(polygons[high(polygons)])];

    if not comparemem(@p1,@p2,sizeof(Tpoint)) and (abs(p1.x-p2.x)<=1) and (abs(p1.y-p2.y)<=1) then add1(p1.x,p2.y);
  end;
end;

function testUp:boolean;
begin
  result:=(j0>0) and BV[i0,j0-1];
  if result then
  begin
    add1(i0,j0-1);
    BV[i0,j0-1]:=false;
    dec(j0);
  end;
end;

function testDw:boolean;
begin
  result:=(j0<N2) and BV[i0,j0];
  if result then
  begin
    add1(i0,j0+1);
    BV[i0,j0]:=false;
    inc(j0);
  end;
end;

function testLeft:boolean;
begin
  result:=(i0>0) and BH[i0-1,j0];
  if result then
  begin
    add1(i0-1,j0);
    BH[i0-1,j0]:=false;
    dec(i0);
  end;
end;

function testRight:boolean;
begin
  result:=(i0<N1) and BH[i0,j0];
  if result then
  begin
    add1(i0+1,j0);
    BH[i0,j0]:=false;
    inc(i0);
  end;
end;


begin
  rect0:=regionBox;
  with rect0 do
  setLength(matP,round(right-left),round(bottom-top));

  for k:=0 to high(PixList) do
  with pixList[k] do
    matP[x-round(rect0.left),y-round(rect0.Top)]:=true;
{ matP contient un tableau de booléens (0..N1-1,0..N2-1)
  On construit BV qui représente les limites verticales   (0..N1,0..n2-1)
            et BH qui représente les limites horizontales (0..N1-1,0..N2)
}

  setLength(polygons,0,0);

  N1:=length(matP);
  N2:=length(matP[0]);
  setLength(BV,N1+1,N2);
  setLength(BH,N1,N2+1);

  for i:=0 to N1 do
  for j:=0 to N2-1 do
    BV[i,j]:=false;

  for i:=0 to N1-1 do
  for j:=0 to N2 do
    BH[i,j]:=false;

  for i:=0 to N1-1 do
  for j:=0 to N2-1 do
    if matP[i,j] then
    begin
      if (i=0) or not matP[i-1,j] then BV[i,j]:=true;

      if (i=N1-1) or not matP[i+1,j] then BV[i+1,j]:=true;

      if (j=0) or not matP[i,j-1] then BH[i,j]:=true;

      if (j=N2-1) or not matP[i,j+1] then BH[i,j+1]:=true;
    end;

{ Partant d'un point acceptable (sur une frontière), on cherche un contour.
}
  for i:=0 to N1-1 do
  for j:=0 to N2-1 do
  if BV[i,j] or (j>0) and BV[i,j-1] or BH[i,j] or (i>0) and BH[i-1,j] then
  begin
    i0:=i;
    j0:=j;
    Add0(i0,j0);  {premier point}

    repeat
    until not( testUp or testRight or testDw or testLeft );

    clore;         {fermer le contour si possible}
  end;

  for i:=0 to high(polygons) do
  for j:=0 to high(polygons[i]) do
    with polygons[i,j] do
    begin
      x:= x + round(rect0.Left);
      y:= y + round(rect0.top);
    end;

end;


function Tpixreg.getHandleRects(var rr: ThandleRects): integer;
begin
   result:=0;
end;



{ TregList }

procedure TregList.BuildPixLists(dxu,x0u,dyu,y0u: float);
var
  i:integer;
begin
  for i:=0 to count-1 do
    region[i].BuildPixList(dxu,x0u,dyu,y0u);
end;

constructor TregList.create;
begin
  inherited;
  defColor:=clYellow;
  HighLightColor:=clGreen;
  NumHighLight:=-1;
end;

procedure TregList.delete(num: integer);
begin
   if (num>=0) and (num<count) then
   begin
     region[num].free;
     inherited delete(num);
   end;
end;

procedure TregList.clear;
var
  i:integer;
begin
  for i:=0 to count-1 do
    region[i].Free;
  inherited;
end;



destructor TregList.destroy;
var
  i:integer;
begin
  clear;
  inherited;
end;

procedure TregList.Draw;
var
  i:integer;
begin
  for i:=0 to count-1 do
  begin
    if i=NumHighLight then swap(region[i].color,HighLightColor);

    if i=lastSelected
      then NbHandleRects:=region[i].getHandleRects(HandleRects);

    region[i].draw;
    if i=NumHighLight then swap(region[i].color,HighLightColor);
  end;
  showHandles;
end;

function TregList.getregion(i: integer): Treg;
begin
  result:=items[i];
end;

function TregList.last: Treg;
begin
  result:=inherited last;
end;

function TregList.PtInRegion(x, y: single;var numReg:integer): integer;
begin
  result:=count-1;
  while (result>=0) and not region[result].PtInRegion(x,y)
  do dec(result);

end;

procedure TregList.drawPix(dxu,x0u,dyu,y0u: float);
var
  i:integer;
begin
  for i:=0 to count-1 do
    region[i].drawPix(dxu,x0u,dyu,y0u);
end;

Const
  IDrgnFile:String[13]='Elphy regions';


procedure TregList.saveToStream(f:Tstream; dataPlot: TdataObj);
var
  i:integer;
  nb:integer;
  fixedSize:integer;
  version: integer;
begin
  f.Write(IDrgnFile,sizeof(IDrgnFile));

  fixedSize:=sizeof(version);              // ajouté le 15 janvier 2013
  f.Write(fixedSize,sizeof(fixedSize));
  version:=1;
  f.Write(version,sizeof(version));

  nb:=count;
  f.Write(nb,sizeof(nb));           { nombre de régions }
  for i:=0 to count-1 do            { puis pour chaque région }
  begin
    f.Write(region[i].ident,4);     { son type }
    region[i].saveToStream1(f, dataPlot);     { et ses data } // saveToStream1 après le 15-01-2013
  end;
end;


function TregList.loadFromStream(f:Tstream; dataPlot: TdataObj):boolean;
var
  i:integer;
  nb,id:integer;
  reg:Treg;
  st:String[13];
  fixedSize:integer;
  version:integer;
begin
  result:=false;
  f.read(st,sizeof(st));
  if st<>IDrgnFile then exit;

  clear;

  f.Read(fixedSize,sizeof(fixedSize));

  version:=0;
  if FixedSize=4 then f.Read(version,sizeof(version));

  f.Read(nb,sizeof(nb));

  for i:=0 to nb-1 do
  begin
    f.read(id,4);
    case id of
       1: reg:=Trectreg.create(0,0);
       2: reg:=Tellipsereg.create(0,0);
       3: reg:=Tpolygonreg.create(0,0);
       4: reg:=Tpixreg.create;
       5: reg:=TsmartRectReg.create(0,0);
       else reg:=nil;
    end;

    if assigned(reg) then
    begin
      case version of
        0: reg.loadFromStream(f);
        1: reg.loadFromStream1(f,dataPlot);
      end;
      add(reg);
    end
    else exit;
  end;
  result:=true;
end;




function TregList.loadFromFile(st: AnsiString; dataPlot: TdataObj): boolean;
var
  stream:TfileStream;
begin
  stream:=TfileStream.create(st,fmOpenRead);
  try
    result:= loadFromStream(stream, dataPlot);
  finally
    stream.free;
  end;
end;


function TregList.saveToFile(st: AnsiString; dataPlot: TdataObj): boolean;
var
  stream:TfileStream;
begin
  stream:=TfileStream.create(st,fmCreate);
  try
    saveToStream(stream,dataPlot);
    stream.free;
    stream:=nil;
    result:=true;
  except
    stream.free;
    result:=false;
  end;
end;


procedure TregList.copy(regList: TregList);
var
  i:integer;
begin
  clear;
  for i:=0 to regList.Count-1 do
    add(regList.region[i].clone);
end;

procedure TregList.AddReg(rr: Treg);
begin
  if assigned(rr) then Add(rr.clone);
end;

procedure TregList.AddRegList(rr: TregList);
var
  i:integer;
begin
  if assigned(rr) then
  for i:=0 to rr.Count-1 do
    add(Treg(rr[i]).clone);
end;

procedure TregList.setColors(w: integer);
var
  i:integer;
begin
  for i:=0 to count-1 do
    region[i].color:=w;
end;




procedure TregList.AddSelection(n: integer);
begin
  if (n>=0) and (n<count) then
  begin
    region[n].selected:=true;
    LastSelected:=n;
  end;
end;

procedure TregList.ClearSelection;
var
  i:integer;
begin
  for i:=0 to count-1 do
    region[i].selected:=false;
end;

procedure TregList.moveSelection(x1, y1: single);
var
  i:integer;
begin
  for i:=0 to count-1 do
    with region[i] do
    if selected then move(x1,y1);
end;


procedure TregList.deleteSelection;
var
  i:integer;
begin
  for i:=count-1 downto 0 do
    if region[i].selected then delete(i);
end;

procedure TregList.ShowHandles;
var
  i:integer;
begin
  if (LastSelected>=0) and (LastSelected<count) then
  begin
    canvasGlb.pen.color:=clred;
    for i:=1 to nbHandleRects do canvasGlb.Rectangle(HandleRects[i]);
  end;
end;

function TregList.PtInHandleRect(x, y: integer): integer;
var
  i:integer;
begin
  result:=0;
  for i:=1 to nbHandleRects do
    if PtInRect(HandleRects[i],point(x,y)) then
    begin
      result:=i;
      exit;
    end;

end;

procedure TregList.modifySelection(Hsel:integer; dx1, dy1: single);
begin
  if (LastSelected>=0) and (LastSelected<count)
    then region[LastSelected].modify(Hsel, dx1, dy1);
end;

function TregList.CanRotate(var xR, yR: float): boolean;
begin
  if (LastSelected>=0) and (LastSelected<count)
    then result:= region[LastSelected].canRotate(xR,yR)
    else result:=false;
end;

function TregList.ModifyTheta(deltaX, deltaY: float): float;
begin
  if (LastSelected>=0) and (LastSelected<count)
    then result:= region[LastSelected].modifyTheta(deltaX, deltaY)
    else result:=0;
end;


end.
