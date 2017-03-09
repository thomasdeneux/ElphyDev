unit stmGrid0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,debug0,
     stmdef,stmObj,stmObv0;

type
  Tgrid=class(TvisualObject)
            deg:typeDegre;
            nX,nY:smallInt;
            posX,posY:PtabSingle;
            ObvisOn:PtabBoolean;

            obvisA:array[1..2] of Tresizable;

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
  if assigned(posX) then freemem(posX,sizeof(single)*nx*ny);
  if assigned(posY) then freemem(posY,sizeof(single)*nx*ny);
  if assigned(obvisOn) then freemem(obvisOn,sizeof(boolean)*nx*ny);

  deg:=deg1;
  nx:=nbx;
  ny:=nby;

  getmem(posX,sizeof(single)*nx*ny);
  getmem(posY,sizeof(single)*nx*ny);
  getmem(obvisOn,sizeof(boolean)*nx*ny);


  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
      begin
        calculeCentre(i,j,posX^[i+nx*j],posY^[i+nx*j]);
      end;
  fillchar(obvisOn^,sizeof(boolean)*nx*ny,0);

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
  if not assigned(obvisA[1]) or not assigned(obvisA[2]) then exit;


  for i:=0 to nx*ny-1 do
    begin
      if obvisOn^[i] then
          with obvisA[1] do
          begin
            deg.x:=posX[i];
            deg.y:=posY[i];
            blt(deg);
          end
        else
        with obvisA[2] do
          begin
            deg.x:=posX[i];
            deg.y:=posY[i];
            blt(deg);
          end;
    end;
end;

destructor Tgrid.destroy;
begin
  if assigned(posX) then freemem(posX,sizeof(single)*nx*ny);
  if assigned(posY) then freemem(posY,sizeof(single)*nx*ny);
  if assigned(obvisOn) then freemem(obvisOn,sizeof(boolean)*nx*ny);

  inherited destroy;
end;

end.
