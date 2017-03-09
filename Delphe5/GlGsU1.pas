unit GlGsU1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  gl,glu,
      util1,Dpalette;

type
  Tvector3s=record
              x,y,z:single;
            end;

procedure myLookAt(R,theta,phi:float);

function getTriangleNormal(x1,y1,z1,x2,y2,z2,x3,y3,z3:single):Tvector3s;
procedure TriangleWith2edges(x1,y1,z1,x2,y2,z2,x3,y3,z3:single);
procedure TriangleWithNormal(x1,y1,z1,x2,y2,z2,x3,y3,z3:single);
procedure TriangleWithNormalAndCol(x1,y1,z1,x2,y2,z2,x3,y3,z3:single;pal:TDpalette);

implementation

function getTriangleNormal(x1,y1,z1,x2,y2,z2,x3,y3,z3:single):Tvector3s;
var
  v1x,v1y,v1z,v2x,v2y,v2z,nx,ny,nz,a:single;
begin
  v1x:=x2-x1;
  v1y:=y2-y1;
  v1z:=z2-z1;

  v2x:=x3-x1;
  v2y:=y3-y1;
  v2z:=z3-z1;

  nx:=v1y*v2z-v1z*v2y;
  ny:=v1z*v2x-v1x*v2z;
  nz:=v1x*v2y-v1y*v2x;

  a:=sqrt(sqr(nx)+sqr(ny)+sqr(nz));

  result.x:=nx/a;
  result.y:=ny/a;
  result.z:=nz/a;
end;


procedure myLookAt(R,theta,phi:float);
var
  d,x,y,z:float;
begin
  theta:=theta*pi/180;
  phi:=phi*pi/180;
  d:=R*sin(theta);
  x:=d*cos(phi);
  y:=d*sin(phi);
  z:=R*cos(theta);

  if theta>0
    then gluLookAt(x,y,z,0,0,0,0,0,1)
    else gluLookAt(0,0,R,0,0,0,0,1,0);
end;

procedure TriangleWith2edges(x1,y1,z1,x2,y2,z2,x3,y3,z3:single);
begin
  glEdgeFlag(1);
  glVertex3f(x1,y1,z1);
  glVertex3f(x2,y2,z2);
  glEdgeFlag(0);
  glVertex3f(x3,y3,z3);
end;


procedure TriangleWithNormal(x1,y1,z1,x2,y2,z2,x3,y3,z3:single);
var
  v1x,v1y,v1z,v2x,v2y,v2z,nx,ny,nz,a:single;
begin
  v1x:=x2-x1;
  v1y:=y2-y1;
  v1z:=z2-z1;

  v2x:=x3-x1;
  v2y:=y3-y1;
  v2z:=z3-z1;

  nx:=v1y*v2z-v1z*v2y;
  ny:=v1z*v2x-v1x*v2z;
  nz:=v1x*v2y-v1y*v2x;

  a:=sqrt(sqr(nx)+sqr(ny)+sqr(nz));
  nx:=nx/a;
  ny:=ny/a;
  nz:=nz/a;


  glNormal3f(nx,ny,nz);

  glVertex3f(x1,y1,z1);
  glVertex3f(x2,y2,z2);
  glVertex3f(x3,y3,z3);
end;



procedure TriangleWithNormalAndCol(x1,y1,z1,x2,y2,z2,x3,y3,z3:single;pal:TDpalette);
type
  Tcol=record
         a,b,g,r:byte;
       end;
var
  v1x,v1y,v1z,v2x,v2y,v2z,nx,ny,nz,a:single;
  col:integer;
  col1:Tcol absolute col;
begin
  v1x:=x2-x1;
  v1y:=y2-y1;
  v1z:=z2-z1;

  v2x:=x3-x1;
  v2y:=y3-y1;
  v2z:=z3-z1;

  nx:=v1y*v2z-v1z*v2y;
  ny:=v1z*v2x-v1x*v2z;
  nz:=v1x*v2y-v1y*v2x;

  a:=sqrt(sqr(nx)+sqr(ny)+sqr(nz));
  nx:=nx/a;
  ny:=ny/a;
  nz:=nz/a;


  glNormal3f(nx,ny,nz);

  col:=pal.colorPal(z1);
  glColor3f(col1.r/255,col1.g/255,col1.b/255);
  glVertex3f(x1,y1,z1);

  col:=pal.colorPal(z2);
  glColor3f(col1.r/255,col1.g/255,col1.b/255);
  glVertex3f(x2,y2,z2);

  col:=pal.colorPal(z3);
  glColor3f(col1.r/255,col1.g/255,col1.b/255);
  glVertex3f(x3,y3,z3);
end;


end.
