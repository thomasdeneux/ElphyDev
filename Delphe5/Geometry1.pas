unit Geometry1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysutils,math,util1,listG,NcDef2;

type
  TRPoint=record
               x,y:float;
             end;


  TpolyR=array of TRPoint;

{ On considère des polygones convexes orientés dans le sens des aiguilles d'une montre }

function segment(const A,B:TRpoint):TpolyR;
function PtInside(M:TRpoint;poly:TpolyR):boolean;
function PolyRinter(poly1,poly2:TpolyR):TpolyR;
function PolyRArea(poly:TpolyR):float;

procedure testGeom;

function PointInSector(xa,ya,xb,yb,Dtheta,xm,ym:float):boolean;
function fonctionPointInSector(xa,ya,xb,yb,Dtheta,xm,ym:float):boolean;pascal;
function SegAngle(xa,ya,xb,yb:float):float;
function fonctionSegAngle(xa,ya,xb,yb:float):float;pascal;

implementation



function Rpoint(x,y:float):TRpoint;
begin
  result.x:=x;
  result.y:=y;
end;

function segment(const A,B:TRpoint):TpolyR;
begin
  setLength(result,2);
  result[0]:=A;
  result[1]:=B;
end;

function poly5R(p1,p2,p3,p4:TRpoint):TpolyR;
begin
  setLength(result,5);
  result[0]:=p1;
  result[1]:=p2;
  result[2]:=p3;
  result[3]:=p4;
  result[4]:=p1;
end;


{ Indique si le point M est à droite du segment AB
  Renvoie une valeur positive si M est à droite
          zéro si M est sur la droite AB
          une valeur négative si M est à gauche
}
function PtRight(M:TRpoint; AB:TpolyR):float;
begin
  result:=(M.x-AB[0].x)*(AB[1].y-AB[0].y) - (M.y-AB[0].y)*(AB[1].x-AB[0].x);
end;

{Indique si le point est strictement intérieur au polygone }

{Indique si le point est strictement intérieur au polygone
 Deuxième méthode }
function PtInside(M:TRpoint;poly:TpolyR):boolean;
var
  n,i:integer;
  xc:float;

function coupe(var p1,p2:TRPoint):boolean;
  begin
    if p1.y=p2.y then coupe:=(m.y=p1.y)
    else
    if p1.x=p2.x then coupe:=(m.x<=p1.x) and
                             ( (m.y>=p1.y) and (m.y<=p2.y)  or
                               (m.y>=p2.y) and (m.y<=p1.y) )
    else
    begin
      xc:=p1.x+(p2.x-p1.x)*(m.y-p1.y)/(p2.y-p1.y);
      coupe:=(xc>=m.x) and
             ( (p1.x<=xc) and (xc<=p2.x) or (p2.x<=xc) and (xc<=p1.x) );
    end;
  end;

begin
  n:=0;
  for i:=0 to high(poly)-1 do
    if coupe(poly[i],poly[i+1]) then inc(n);
  result:=(n and 1<>0);
end;

function SegInterSeg(A,B,C,D:TRpoint;var M:TRpoint):boolean;
const
  eps=1E-30;
var
  k1,k2:float;
begin
  result:=false;
  if (a.y=b.y) and (c.y=d.y) then exit;

  if a.y=b.y then
    begin
      m.y:=a.y;
      k2:=(d.x-c.x)/(d.y-c.y);
      m.x:=c.x+k2*(m.y-c.y);
    end
  else
  if c.y=d.y then
    begin
      m.y:=c.y;
      k1:=(b.x-a.x)/(b.y-a.y);
      m.x:=a.x+k1*(m.y-a.y);
    end
  else
    begin
      k1:=(b.x-a.x)/(b.y-a.y);
      k2:=(d.x-c.x)/(d.y-c.y);
      if k1=k2 then exit;

      m.y:=(c.x-a.x+k1*a.y-k2*c.y)/(k1-k2);
      m.x:=a.x+k1*(m.y-a.y);
    end;

  result:=((m.x-a.x)*(m.x-b.x)<=eps) and
          ((m.y-a.y)*(m.y-b.y)<=eps) and
          ((m.x-c.x)*(m.x-d.x)<=eps) and
          ((m.y-c.y)*(m.y-d.y)<=eps) ;
end;

var
  R:TlistG;
  bary:TRpoint;

function compare(item1,item2:pointer):integer;
var
  w:float;
begin
  w:=PtRight(TRpoint(item1^), segment(bary, TRpoint(item2^)));
  if w>0 then result:=1
  else
  if w<0 then result:=-1
  else result:=0;
end;

function PolyRinter(poly1,poly2:TpolyR):TpolyR;
var
  i,j:integer;
  IP,A,B:TRpoint;

begin
  R:=TlistG.create(sizeof(TRpoint));

  for i:=0 to high(poly1)-1 do
  for j:=0 to high(poly2)-1 do
    if SegInterSeg(poly1[i],poly1[i+1],poly2[j],poly2[j+1],IP) then R.add(@IP);

  for i:=0 to high(poly1)-1 do
    if PtInside(poly1[i],poly2) then R.add(@poly1[i]);

  for i:=0 to high(poly2)-1 do
    if PtInside(poly2[i],poly1) then R.add(@poly2[i]);

  setLength(result,0);
  if R.count=0 then exit;

  bary.x:=0;
  bary.y:=0;

  for i:=0 to R.Count-1 do
  begin
    bary.x:=bary.x+TRpoint(R[i]^).x;
    bary.y:=bary.y+TRpoint(R[i]^).y;
  end;
  bary.x:=bary.x/R.Count;
  bary.y:=bary.y/R.Count;

  R.Sort(compare);

  if R.count>0 then
  begin
    setLength(result,R.Count+1);
    for i:=0 to R.Count-1 do
     result[i]:=TRpoint(R[i]^);
    result[R.count]:=TRpoint(R[0]^);
  end;
end;

function PolyRArea(poly:TpolyR):float;
var
  i:integer;
begin
  result:=0;

  for i:=0 to high(poly)-1 do
    result:=result+(poly[i+1].x-poly[i].x)*(poly[i+1].y+poly[i].y)/2;

  result:=abs(result);
end;


function SegAngle(xa,ya,xb,yb:float):float;
var
  sint,cost:float;
  aa:float;
begin
  aa:=sqrt(sqr(xa-xb)+sqr(ya-yb));

  if (aa<>0) then
  begin
    sint:=(yb-ya)/aa;
    cost:=(xb-xa)/aa;
    result:=arcsin(sint);
    if cost<0 then
      if sint>0
        then result:=pi-result
        else result:=-pi-result;
  end
  else result:=0;
end;

function fonctionSegAngle(xa,ya,xb,yb:float):float;
begin
  result:=SegAngle(xa,ya,xb,yb);
end;

{ Le segment AB et l'angle Dtheta définissent un secteur d'origine A
 et d'axe de symétrie AB. L'angle au sommet est Dtheta .
}
function PointInSector(xa,ya,xb,yb,Dtheta,xm,ym:float):boolean;
var
  thetaSec,thetaM:float;
  Diff1,Diff2,Diff3:float;
begin
  if (xa=xm) and (ya=ym) then
  begin
    result:=true;       { Le point M est à l'origine du secteur }
    exit;
  end;

  thetaSec:=SegAngle(xa,ya,xb,yb);
  thetaM:=SegAngle(xa,ya,xm,ym);

  Diff1:=abs(thetaSec-thetaM);
  Diff2:=abs(thetaSec-thetaM-2*pi);
  Diff3:=abs(thetaSec-thetaM+2*pi);

  if Diff2<Diff1 then Diff1:=Diff2;
  if Diff3<Diff1 then Diff1:=Diff3;

  result:=(Diff1<Dtheta/2);
end;

function fonctionPointInSector(xa,ya,xb,yb,Dtheta,xm,ym:float):boolean;
begin
  if (xa=xb) and (ya=yb)
    then sortieErreur('Bad sector');
  result:=PointInSector(xa,ya,xb,yb,Dtheta,xm,ym);
end;

procedure testGeom;
var
  M:TRpoint;
  poly1,poly2:TpolyR;
begin
  M:=Rpoint(-0.2,-1.7);
  poly1:=poly5R(Rpoint(1,-1),Rpoint(-1,-1),Rpoint(-1,1),Rpoint(1,1));
  poly2:=poly5R(Rpoint(1,-10),Rpoint(-1,-10),Rpoint(-1,0),Rpoint(1,0));

  messageCentral(Bstr(PtInside(M,poly1)));

end;

end.
