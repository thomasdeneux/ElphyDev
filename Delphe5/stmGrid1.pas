unit stmGrid1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,debug0,
     stmdef,stmObj,stmObv0;

type
  Tgrid=class(TvisualObject)
            deg:typeDegre;
            nX,nY:smallInt;
            posX,posY:array of array of Single;

            obvisA:array of array of Tresizable;

            constructor create;override;
            class function STMClassName:AnsiString;override;

            procedure CalculeCentre(x,y:integer;var ic,jc:single);
            procedure initGrille(deg1:typeDegre;nbx,nby:integer);
            procedure afficheS;override;

            destructor destroy;override;
          end;


implementation


{*********************   Méthodes de Tgrid   ***************************}


constructor Tgrid.create;
begin
  inherited create;
end;

procedure Tgrid.CalculeCentre(x,y:integer;var ic,jc:single);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((x-nX/2 + 0.5) * deg.dX) / nX;
    y0 := ((y-nY/2 + 0.5) * deg.dY) / nY;
    DegRotationR(x0,y0,xc,yc,0,0,deg.theta);
    ic:=xc+deg.x;
    jc:=yc+deg.y;
  end;

procedure Tgrid.initGrille(deg1:typeDegre;nbx,nby:integer);
var
  i,j:integer;
  poly:typePoly5;
begin
  deg:=deg1;
  nx:=nbx;
  ny:=nby;

  setLength(posX,nx,ny);
  setLength(posY,nx,ny);

  setLength(obvisA,nx,ny);

  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
    begin
      calculeCentre(i,j,posX[i,j],posY[i,j]);
      obvisA[i,j]:=nil;
    end;

end;


class function Tgrid.STMClassName:AnsiString;
  begin
    STMClassName:='Grid';
  end;


procedure Tgrid.afficheS;
var
  i,j:integer;
begin
  if (DXscreen=nil) or not DXscreen.canDraw then exit;
  if not assigned(obvisA) then exit;

  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
    if assigned(obvisA[i,j]) then
      with obvisA[i,j] do
      begin
        deg.x:=posX[i,j];
        deg.y:=posY[i,j];
        Blt(deg);
      end
    
end;

destructor Tgrid.destroy;
begin
  inherited destroy;
end;

end.
