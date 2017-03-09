unit Triangulation1;

interface

uses classes, stdCtrls,
     util1;

type
  Tvertex=  class
              x,y:single;

            end;
  TvertexList=
            class(Tlist)
              function getvertex(n:integer):Tvertex;
              procedure setVertex(n:integer;p:Tvertex);
              property vertex[n:integer]:Tvertex read getVertex write setVertex; default;
              destructor destroy;override;
            end;

  Ttriangle=class;
  Tedge=    class
              org,dest: Tvertex;
              Tright, Tleft: Ttriangle;
            end;

  TedgeList=
            class(Tlist)
              function getEdge(n:integer):TEdge;
              procedure setEdge(n:integer;p:TEdge);
              property Edge[n:integer]:TEdge read getEdge write setEdge; default;

              destructor destroy;override;
            end;

  Ttriangle=class
              e1,e2,e3: Tedge;
              f1,f2,f3: boolean;

              function p1: Tvertex;
              function p2: Tvertex;
              function p3: Tvertex;

              function next(ae: Tedge): Tedge;overload;
              function prev(ae: Tedge): Tedge;overload;

              function opposite(ae: Tedge): Tvertex;
              function Next(p:Tvertex): Tvertex;overload;
              function prev(p:Tvertex): Tvertex;overload;

              function PtInsideCircumCircle(xP, yP: float ; var xc,yc,r:float):boolean;
              function PtInside(Dx,Dy:single):boolean;


            end;

  TtriangleList=
            class(Tlist)
              function getTriangle(n:integer):TTriangle;
              procedure setTriangle(n:integer;p:TTriangle);
              property Triangle[n:integer]:TTriangle read getTriangle write setTriangle; default;

              destructor destroy;override;
            end;

  Tpolyhedre=
            class
              Vertices: TVertexlist;
              Edges: TEdgelist;
              Triangles: Ttrianglelist;

              ValidE: Tlist;

              constructor create;
              destructor destroy;override;
              function addVertex(x,y:single):Tvertex;
              function addEdge(p1,p2:Tvertex; t1,t2:Ttriangle): Tedge;
              function addTriangle( ae1,ae2,ae3:Tedge): Ttriangle;

              function NewTriangle( ae1,ae2,ae3:Tedge): Ttriangle;

              procedure init(x1,y1,x2,y2:float);
              procedure AddPoint(x,y:single; var c1,c2,c3: Tedge);

              procedure flip(bc: Tedge; var c1,c2,c3,c4: Tedge);
              procedure PrintTrList(memo:Tmemo);
              procedure PrintEdgeList(memo:Tmemo);

              function EdgeValid(edge: Tedge):boolean;
              procedure Check(edge:Tedge);

              procedure InsertPoint(x,y:single);
            end;

implementation

uses Utriangle;

{ Simple functions }
function det( m11,m12,m13,
              m21,m22,m23,
              m31,m32,m33: single ): single;
begin
  result:=m11* (m22*m33-m23*m32) -m12*(m21*m33-m31*m23) + m13*(m21*32-m31*m22);
end;

function crossP(x1,y1,x2,y2:single): single;
begin
  result:=x1*y2-y1*x2;
end;

// P1 et P2 sont-ils du même coté de AB
function sameSide(p1x,p1y,p2x,p2y,ax,ay,bx,by:single): boolean;
var
  cp1,cp2:single;
begin
  cp1:=crossP(bx-ax,by-ay,p1x-ax,p1y-ay);   // AB ** AP1
  cp2:=crossP(bx-ax,by-ay,p2x-ax,p2y-ay);   // AB ** AP2

  result:=cp1*cp2>=0;
end;

function IsDirect(ax,ay,bx,by,cx,cy: single):boolean;
begin
  result:= crossP(bx-ax,by-ay,cx-ax,cy-ay)>=0;
end;


{ TvertexList }

destructor TvertexList.destroy;
var
  i:integer;
begin
  for i:=0 to count-1 do vertex[i].free;
  inherited;
end;

function TvertexList.getvertex(n: integer): Tvertex;
begin
  result:=items[n];
end;

procedure TvertexList.setVertex(n: integer; p: Tvertex);
begin
  items[n]:=p;
end;

{ TedgeList }

destructor TedgeList.destroy;
var
  i:integer;
begin
  for i:=0 to count-1 do Edge[i].free;
  inherited;
end;


function TEdgeList.getEdge(n: integer): TEdge;
begin
  result:=items[n];
end;

procedure TEdgeList.setEdge(n: integer; p: TEdge);
begin
  items[n]:=p;
end;


{ Ttriangle }


function Ttriangle.next(ae: Tedge): Tedge;
begin
  if ae=e1 then result:=e2
  else
  if ae=e2 then result:=e3
  else result:=e1;
end;

function Ttriangle.prev(ae: Tedge): Tedge;
begin
  if ae=e1 then result:=e3
  else
  if ae=e2 then result:=e1
  else result:=e2;
end;

function Ttriangle.opposite(ae: Tedge): Tvertex;
begin
  if not ((p1=ae.org) or (p1=ae.dest)) then result:=p1
  else
  if not ((p2=ae.org) or (p2=ae.dest)) then result:=p2
  else
  if not ((p3=ae.org) or (p3=ae.dest)) then result:=p3;

  if result=nil then messageCentral('Error opposite');
end;

function Ttriangle.p1: Tvertex;
begin
  if assigned(e1) then
  begin
    if not f1 then result:=e1.org else result:=e1.dest;
  end
  else result:=nil;
end;

function Ttriangle.p2: Tvertex;
begin
  if assigned(e2) then
  begin
    if not f2 then result:=e2.org else result:=e2.dest;
  end
  else result:=nil;
end;

function Ttriangle.p3: Tvertex;
begin
  if assigned(e3) then
  begin
    if not f3 then result:=e3.org else result:=e3.dest;
  end
  else result:=nil;
end;

//PtInside si P et P1 sont du même coté / P2P3
//      et si P et P3 sont du même coté / P1P2

function Ttriangle.PtInside(Dx, Dy: single): boolean;
begin
  result:= sameSide(Dx,Dy,p1.x,p1.y,p2.x,p2.y,p3.x,p3.y)
           and
           sameSide(Dx,Dy,p3.x,p3.y,p1.x,p1.y,p2.x,p2.y)
           and
           sameSide(Dx,Dy,p2.x,p2.y,p1.x,p1.y,p3.x,p3.y);

end;


function Ttriangle.PtInsideCircumCircle(xP, yP: float; var xc,yc,r:float): boolean;
{
begin
  result:= det(p1.x-xp,p1.y-yp,sqr(p1.x)-sqr(xp)+sqr(p1.y)-sqr(yp),
               p2.x-xp,p2.y-yp,sqr(p2.x)-sqr(xp)+sqr(p2.y)-sqr(yp),
               p3.x-xp,p3.y-yp,sqr(p3.x)-sqr(xp)+sqr(p3.y)-sqr(yp) ) >0;
end;
}

var
  m1,m2,mx1,mx2,my1,my2: float;
  dx,dy,rsqr,drsqr: float;
  st:string;

const
  Epsilon=1E-100;
begin
  if ( abs(p1.y-p2.y) < EPSILON ) and (abs(p2.y-p3.y) < EPSILON ) then
  begin
    result:=false;
    exit;
  end
  else
  if abs(p2.y-p1.y) < EPSILON  then
  begin
    m2 := - (p3.x-p2.x) / (p3.y-p2.y);
    mx2 := (p2.x + p3.x) / 2.0;
    my2 := (p2.y + p3.y) / 2.0;
    xc := (p2.x + p1.x) / 2.0;
    yc := m2 * (xc - mx2) + my2;
  end
  else
  if abs(p3.y-p2.y)<EPSILON then
  begin
    m1 := - (p2.x-p1.x) / (p2.y-p1.y);
    mx1 := (p1.x + p2.x) / 2.0;
    my1 := (p1.y + p2.y) / 2.0;
    xc := (p3.x + p2.x) / 2.0;
    yc := m1 * (xc - mx1) + my1;
  end
  else
  begin
    m1 := - (p2.x-p1.x) / (p2.y-p1.y);
    m2 := - (p3.x-p2.x) / (p3.y-p2.y);
    mx1 := (p1.x + p2.x) / 2.0;
    mx2 := (p2.x + p3.x) / 2.0;
    my1 := (p1.y + p2.y) / 2.0;
    my2 := (p2.y + p3.y) / 2.0;
    if abs(m1-m2)<epsilon then
    begin
      result:=false;
      exit;
      st:=Estr1(xP,5,0)+Estr1(yP,5,0);
      messageCentral(st);
    end;
    xc := (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2);
    yc := m1 * (xc - mx1) + my1;
  end;

  dx := p2.x - xc;
  dy := p2.y - yc;
  rsqr := dx*dx + dy*dy;
  r := sqrt(rsqr);

  dx := xp - xc;
  dy := yp - yc;
  drsqr := dx*dx + dy*dy;


  result:= (drsqr < rsqr) ;
end;


function Ttriangle.next(p: Tvertex): Tvertex;
begin
  if p=p1 then result:=p2
  else
  if p=p2 then result:=p3
  else result:=p1;
end;

function Ttriangle.prev(p: Tvertex): Tvertex;
begin
  if p=p1 then result:=p3
  else
  if p=p2 then result:=p1
  else result:=p2;
end;

{ TtriangleList }

destructor TtriangleList.destroy;
var
  i:integer;
begin
  for i:=0 to count-1 do Triangle[i].free;
  inherited;
end;

function TTriangleList.getTriangle(n: integer): TTriangle;
begin
  result:=items[n];
end;

procedure TTriangleList.setTriangle(n: integer; p: TTriangle);
begin
  items[n]:=p;
end;


{ Tpolyhedre }

function Tpolyhedre.addVertex(x, y: single): Tvertex;
begin
  result:=Tvertex.create;
  result.x:=x;
  result.y:=y;
  Vertices.Add(result);
end;

function Tpolyhedre.addEdge(p1, p2: Tvertex; t1, t2: Ttriangle): Tedge;
begin
  result:=Tedge.create;
  result.org:=p1;
  result.dest:=p2;
  result.Tleft:=t1;
  result.Tright:=t2;

  Edges.Add(result);
end;


function Tpolyhedre.NewTriangle( ae1,ae2,ae3:Tedge):Ttriangle;
var
  pt1,pt2,pt3: Tvertex;
begin
  result:=nil;
  pt1:=ae1.org;
  pt2:=ae1.dest;
  if (ae2.org<>pt1) and (ae2.org<>pt2) then pt3:=ae2.org
  else
  if (ae2.dest<>pt1) and (ae2.dest<>pt2) then pt3:=ae2.dest
  else exit;


  result:=Ttriangle.Create;
  with result do
  begin
    if isDirect(pt1.x,pt1.y,pt2.x,pt2.y,pt3.x,pt3.y) then
    begin
      e1:=ae1;
      f1:= (ae1.org=pt2) and (ae1.dest=pt1);

      e2:=ae2;
      f2:= (ae2.org=pt3) and (ae2.dest=pt2);

      e3:=ae3;
      f3:= (ae3.org=pt1) and (ae3.dest=pt3);
    end
    else
    begin
      e1:=ae1;
      f1:= (ae1.org=pt1) and (ae1.dest=pt2);

      e2:=ae3;
      f2:= (ae3.org=pt3) and (ae3.dest=pt1);

      e3:=ae2;
      f3:= (ae2.org=pt2) and (ae3.dest=pt3);
    end;

    if not f1 then e1.Tleft:=result else e1.Tright:=result;
    if not f2 then e2.Tleft:=result else e2.Tright:=result;
    if not f3 then e3.Tleft:=result else e3.Tright:=result;
  end;

end;

function Tpolyhedre.AddTriangle( ae1,ae2,ae3:Tedge):Ttriangle;
begin
  result:=NewTriangle(ae1,ae2,ae3);
  Triangles.add(result);
end;

constructor Tpolyhedre.create;
begin
  Vertices:=TVertexlist.create;
  Edges:=TEdgelist.create;
  Triangles:=Ttrianglelist.create;
end;

destructor Tpolyhedre.destroy;
begin
  Vertices.free;
  Edges.free;
  Triangles.free;
  inherited;
end;


procedure Tpolyhedre.init(x1,y1,x2,y2:float);
begin
  if x2<x1 then swap(x1,x2);
  if y2<y1 then swap(y1,y2);

  AddVertex(x1,y1);
  AddVertex(x2,y1);
  AddVertex(x2,y2);
  AddVertex(x1,y2);

  AddEdge(vertices[0],vertices[1],nil,nil);
  AddEdge(vertices[1],vertices[2],nil,nil);
  AddEdge(vertices[2],vertices[3],nil,nil);
  AddEdge(vertices[3],vertices[0],nil,nil);
  AddEdge(vertices[0],vertices[2],nil,nil);

  AddTriangle(Edges[0],Edges[1],Edges[4]);
  AddTriangle(Edges[4],Edges[2],Edges[3]);

  Edges[0].Tleft:= Triangles[0];
  Edges[1].Tleft:= Triangles[0];
  Edges[4].Tright:= Triangles[0];

  Edges[4].Tleft:= Triangles[1];
  Edges[2].Tleft:= Triangles[1];
  Edges[3].Tleft:= Triangles[1];


end;



procedure Tpolyhedre.AddPoint(x, y: single;var c1,c2,c3: Tedge);
var
  i:integer;
  p: Tvertex;
  PA1,PA2,PA3: Tedge;
  tr0,tr1,tr2,tr3: Ttriangle;
begin
  tr0:=nil;                           // trouver le triangle contenant p
  for i:=0 to triangles.Count-1 do
  if triangles[i].PtInside(x,y) then
  begin
    tr0:=triangles[i];
    break;
  end;

  if tr0=nil then exit;


  p:=AddVertex(x,y);                  // Ajouter p
  PA1:=AddEdge(p,Tr0.p1,nil,nil);     // Ajouter les bords
  PA2:=AddEdge(p,Tr0.p2,nil,nil);
  PA3:=AddEdge(p,Tr0.p3,nil,nil);

  tr1:=AddTriangle(PA1,tr0.e1,PA2);   // Ajouter les triangles
  tr2:=AddTriangle(PA2,tr0.e2,PA3);
  tr3:=AddTriangle(PA3,tr0.e3,PA1);

  c1:=tr0.e1;
  c2:=tr0.e2;
  c3:=tr0.e3;

  triangles.Remove(tr0);              // retirer le triangle initial

end;


procedure Tpolyhedre.PrintTrList(memo:Tmemo);
var
  i:integer;
  st:string;
begin
  for i:=0 to Triangles.Count-1 do
  with Triangles[i] do
  begin
    st:= Istr1(i,2)+' '+Estr1(p1.x,3,0)+','+Estr1(p1.y,3,0)+'      '+Estr1(p2.x,3,0)+','+Estr1(p2.y,3,0)+'      ' +Estr1(p3.x,3,0)+','+Estr1(p3.y,3,0) ;
    memo.lines.Add(st);
  end;
end;

procedure Tpolyhedre.PrintEdgeList(memo:Tmemo);
var
  i:integer;
  st:string;
begin
  for i:=0 to Edges.Count-1 do
  with Edges[i] do
  begin
    st:= Istr1(i,2)+'  '+ Estr1(org.x,3,0)+','+Estr1(org.y,3,0)+'      '+Estr1(dest.x,3,0)+','+Estr1(dest.y,3,0)+'      ' + Istr(triangles.indexof(Tleft))+'  '+Istr(triangles.indexof(Tright));
    memo.lines.Add(st);
  end;

end;


procedure Tpolyhedre.flip(bc: Tedge;var c1,c2,c3,c4: Tedge);
var
  tr1,tr2: Ttriangle;
  pA,pD: Tvertex;
  st:string;
begin
  with bc do
  st:=  'FLIP '+Estr1(org.x,3,0)+','+Estr1(org.y,3,0)+'      '+Estr1(dest.x,3,0)+','+Estr1(dest.y,3,0)+'      ' + Istr(triangles.indexof(Tleft))+'  '+Istr(triangles.indexof(Tright));
  form1.Memo1.Lines.Add(st);

  
  tr1:=bc.Tleft;
  tr2:=bc.Tright;

  pA:=tr1.opposite(bc);
  pD:=tr2.opposite(bc);

  c1:=tr1.next(bc);
  c2:=tr1.prev(bc);
  c3:=tr2.next(bc);
  c4:=tr2.prev(bc);

  bc.org:=pD;
  bc.dest:=pA;

  tr1.e1:=bc;
  tr1.f1:=false;
  tr1.e2:=c2;
  tr1.f2:= (c2.dest=pA);
  tr1.e3:=c3;
  tr1.f3:= (c3.org=pD);

  tr2.e1:=bc;
  tr2.f1:=true;
  tr2.e2:=c4;
  tr2.f2:= (c4.dest=pD);
  tr2.e3:=c1;
  tr2.f3:= (c1.org=pA);

  if c1.Tleft=tr1 then c1.Tleft:=tr2 else c1.Tright:=tr2;
  if c3.Tleft=tr2 then c3.Tleft:=tr1 else c3.Tright:=tr1;

  //form1.PaintBox1.refresh;
end;

function Tpolyhedre.EdgeValid(edge: Tedge): boolean;
var
  A, B, C, D: Tvertex;
  xc,yc,r:float;
begin
  if (edge.Tleft=nil) or (edge.Tright=nil) then result:=true
  else
  begin
    A:= edge.Tleft.opposite(edge) ;
    B:= edge.Tleft.next(A);
    C:= edge.Tleft.prev(A);
    D:= edge.Tright.opposite(edge);

    {if isDirect(A.x,A.y,C.x,C.y,D.x,D.y) or not isDirect(A.x,A.y,B.x,B.y,D.x,D.y) then result:=true
    else}
    result:=  not edge.Tleft.PtInsideCircumCircle(D.x,D.y,xc,yc,r);
  end;
end;

procedure Tpolyhedre.Check(edge: Tedge);
var
  c1,c2,c3,c4: Tedge;
  st:string;
begin
  if   edge=nil then exit;

  with edge do
  st:=  'CHECK '+Istr(edges.IndexOf(edge))+' '+ Estr1(org.x,3,0)+','+Estr1(org.y,3,0)+'      '
                                               + Estr1(dest.x,3,0)+','+Estr1(dest.y,3,0)+'      '
                                               + Istr(triangles.indexof(Tleft))+'  '+Istr(triangles.indexof(Tright))+'   '
                                               + Bstr(EdgeValid(edge));
  form1.Memo1.Lines.Add(st);

  if not EdgeValid(edge) then
  begin
    flip(edge,c1,c2,c3,c4);
    check(c1);
    check(c2);
    check(c3);
    check(c4);
  end;

end;



procedure Tpolyhedre.InsertPoint(x, y: single);
var
  c1,c2,c3: Tedge;
  st:string;
begin
  st:=  'ADD '+ Estr1(x,3,0)+','+Estr1(y,3,0);
  form1.Memo1.Lines.Add(st);

  AddPoint(x,y, c1,c2,c3);

  //form1.PaintBox1.refresh;

  Check(c1);
  Check(c2);
  Check(c3);


end;

end.
