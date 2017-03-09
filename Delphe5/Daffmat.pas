unit Daffmat;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, graphics,
     util1,Dpalette,Dgraphic,math,
     debug0;

{ Affichage d'une matrice.

  La matrice doit être déclarée Array[Xdim1..Xdim2,Ydim1..Ydim2] of typeQuelconque;
  C'est la fonction getCol qui fournit la couleur d'un pave (i,j) et qui est
  seule concernée par le type.

  La matrice est affichée dans la fenêtre courante de Dgraphic en tenant compte
  du rapport d'aspect et de l'orientation. On s'arrange pour que les dimensions
  soient les plus grandes possibles à l'intérieur de la fenêtre courante.
  Le rapport d'aspect correspond à la totalité de la matrice.
}


type
  Tpoly4=array[1..4] of Tpoint;

  TaffpaveU=procedure (poly:Tpoly4;i,j:integer) of object;

  //TR4ex=array[1..4] of float;

  typeAffMat=object
             private
               Xdim1,Xdim2,Ydim1,Ydim2:integer;
               NbdimX,nbDimY:integer;
               angle:float;
               ratio:float;

               dxc,dyc:float;

               Rbase:array[1..4,1..2] of float;

               ix1,ix2,iy1,iy2:integer;
               x3,y3:float;
               a11,a12,a21,a22:float;

               invX,invY:boolean;

               keepRatio:boolean;
               dxAff,dyAff:float;

               deltaIx,deltaIy:integer;

               procedure affPave(ix,iy:integer);
               procedure movetoP(ix,iy:integer);

             public
               affPaveU:TaffPaveU;
               movePaveU:TaffPaveU;

               Fwires:boolean;

               procedure init(i1,j1,i2,j2:integer;aspectRatio,theta:float);
               procedure affiche;
               procedure afficheCell(i,j:integer);

               procedure setXlimits(i1,i2:integer);
               procedure setYlimits(j1,j2:integer);
               procedure setKeepRatio(w:boolean);
               procedure setInv(ivx,ivy:boolean);
               procedure drawBorder(col:longint);
               procedure affichePave(i,j:integer);

               procedure DisplayInRect(x,y,dx,dy,theta:float);
               function getIrect:Trect;

               procedure CalculRbase0;
               procedure CalculRbase1;
               procedure CalculRbasePara;
               procedure CalculRbase;

               procedure setDxAffDyAff(dx,dy:float);

               function getPixelPos(var x,y:integer):boolean;overload;
               function getPixelPos(var x,y:float):boolean;overload;
             end;



IMPLEMENTATION

procedure typeAffMat.init(i1,j1,i2,j2:integer;aspectRatio,theta:float);
begin
  Xdim1:=i1;
  Xdim2:=i2;
  Ydim1:=j1;
  Ydim2:=j2;

  angle:=0;
  ratio:=1;

  ix1:=i1;
  ix2:=i2;
  iy1:=j1;
  iy2:=j2;

  ratio:=aspectRatio;
  angle:=-theta*pi/180;

  invx:=false;
  invy:=false;

  dxAff:=0;
  dyAff:=0;
  Fwires:=false;

  deltaIx:=1;
  deltaIy:=1;

  fillchar(Rbase,sizeof(Rbase),0);
end;

procedure typeAffMat.setXlimits(i1,i2:integer);
begin
  ix1:=i1;
  ix2:=i2;
  if ix2<ix1 then ix2:=ix1;
end;

procedure typeAffMat.setYlimits(j1,j2:integer);
begin
  iy1:=j1;
  iy2:=j2;
  if iy2<iy1 then iy2:=iy1;
end;

procedure typeAffMat.setInv(ivx,ivy:boolean);
begin
  invX:=ivx;
  invY:=ivy;
end;

procedure typeAffMat.setKeepRatio(w:boolean);
begin
  keepRatio:=w;
end;

procedure rotation(x1,y1:float;var x2,y2:float;x0,y0,angle:float);
var
  sin0,cos0:float;
  dx,dy:float;

begin
  dx:=x1-x0;
  dy:=y1-y0;
  sin0:=sin(angle);
  cos0:=cos(angle);
  x2:=(dx*cos0-dy*sin0)  +x0;
  y2:=(dx*sin0+dy*cos0)  +y0;
end;


procedure typeAffMat.CalculRbase0;
var
  dx,dy:float;
  kx,ky,kmul:float;
  xmax,ymax:float;
  i:integer;
  x,y:float;
  ratio1:float;

begin

  ratio1:=ratio*(Xdim2-Xdim1+1)*(iy2-iy1+1)/(Ydim2-Ydim1+1)/(ix2-ix1+1);
                                                       { le rapport d'aspect apparent }
                                                       { tient compte des dimensions de }
                                                       { la matrice et de la zone de la }
                                                       { matrice affichée }
  dx:=1;
  dy:=ratio1;

  rotation(dx,dy,Rbase[1,1],Rbase[1,2],0,0,angle);     { faire tourner un petit rectangle }
  rotation(-dx,dy,Rbase[2,1],Rbase[2,2],0,0,angle);    { de dimensions (1,ratio) autour de }
  rotation(-dx,-dy,Rbase[3,1],Rbase[3,2],0,0,angle);   { son centre }
  rotation(dx,-dy,Rbase[4,1],Rbase[4,2],0,0,angle);


  xmax:=0;
  ymax:=0;                                             { chercher son encombrement en }
                                                       { X et Y }
  for i:=1 to 4 do
    begin
      if Rbase[i,1]>xmax then xmax:=Rbase[i,1];
      if Rbase[i,2]>ymax then ymax:=Rbase[i,2];
    end;

  kx:=(x2act-x1act)/(xmax*2);                          { trouver par quel facteur on doit }
  ky:=(y2act-y1act)/(ymax*2);                          { multiplier ses dimensions pour }
                                                       { qu'il soit exactement à l'intérieur}
  if kx>ky then kmul:=ky else kmul:=kx;                { du rectangle déterminé par }
                                                       { setWindow }



  for i:=1 to 4 do                                     { Appliquer le facteur multiplicatif}
    begin
      Rbase[i,1]:=Rbase[i,1]*kmul;
      Rbase[i,2]:=Rbase[i,2]*kmul;
    end;

  x3:=Rbase[3,1]+(x1act+x2act)/2;                      { position du point n°3 dans la }
  y3:=Rbase[3,2]+(y1act+y2act)/2;                      { fenêtre }


  dxc:=kmul*2/(ix2-ix1+1);                             { calculer les dimensions d'un }
  dyc:=kmul*2*ratio1/(iy2-iy1+1);                      { rectangle élémentaire }


  rotation(dxC/2,dyC/2,Rbase[1,1],Rbase[1,2],0,0,angle);   { le faire tourner }
  rotation(-dxC/2,dyC/2,Rbase[2,1],Rbase[2,2],0,0,angle);
  rotation(-dxC/2,-dyC/2,Rbase[3,1],Rbase[3,2],0,0,angle);
  rotation(dxC/2,-dyC/2,Rbase[4,1],Rbase[4,2],0,0,angle);

  x:=Rbase[3,1];
  y:=Rbase[3,2];

  for i:=1 to 4 do                                     { calculer ses coordonnées par }
    begin                                              { rapport au point n°3 }
      Rbase[i,1]:=Rbase[i,1]-x;
      Rbase[i,2]:=Rbase[i,2]-y;
    end;                                               { Ouf }


  a11:=dxC*cos(angle);
  a12:=-dyC*sin(angle);
  a21:=dxC*sin(angle);
  a22:=dyC*cos(angle);

end;


procedure typeAffMat.CalculRbase1;
var
  i,j:integer;
  x1,y1,x2,y2:integer;
begin
  getWindowG(x1,y1,x2,y2);
  dxC:=(x2-x1)/(ix2-ix1+1);
  dyC:=(y2-y1)/(iy2-iy1+1);

  rotation(dxC,dyC,Rbase[1,1],Rbase[1,2],0,0,0);
  rotation(0,dyC,Rbase[2,1],Rbase[2,2],0,0,0);
  rotation(0,0,Rbase[3,1],Rbase[3,2],0,0,0);
  rotation(dxC,0,Rbase[4,1],Rbase[4,2],0,0,0);

  x3:=x1;
  y3:=y1;

  a11:=dxC;
  a12:=0;
  a21:=0;
  a22:=dyC;

  deltaIx:=round(1/dxC);
  if deltaIx<1 then deltaIx:=1;

  deltaIy:=round(1/dyC);
  if deltaIy<1 then deltaIy:=1;

end;

procedure typeAffMat.CalculRbasePara;
var
  i,j:integer;
  x1,y1,x2,y2:integer;
  dxA,dyA:float;
  xx0,yy0:float;

  nbc,nbl:integer;
  Ltot,Htot:float;
  incDx,incDy:float;
  DxIntA,DyIntA:float;
begin
  dxA:=dxAff/100;
  dyA:=dyAff/100;

  getWindowG(x1,y1,x2,y2);

  Ltot:=x2-x1+1;
  Htot:=y2-y1+1;
  nbc:=ix2-ix1+1;
  nbl:=iy2-iy1+1;

  dxC:=Ltot*(1-abs(dxA)) / nbc;
  dyC:=Htot*(1-abs(dyA)) / nbl;

  IncDx:=Ltot*dxA/nbl;
  IncDy:=Htot*dyA/nbc;

  if dxA>=0 then xx0:=0 else xx0:=-Ltot*dxA;
  if dyA>=0 then yy0:=0 else yy0:=-Htot*dyA;


  Rbase[1,1]:=dxC+incDx;
  Rbase[1,2]:=dyC+incdy;

  Rbase[2,1]:=incDx;
  Rbase[2,2]:=dyC;

  Rbase[3,1]:=0;
  Rbase[3,2]:=0;

  Rbase[4,1]:=dxC;
  Rbase[4,2]:=incDy;

  x3:=x1+xx0;
  y3:=y1+yy0;

  a11:=dxC;
  a12:=incDx;
  a21:=incDy;
  a22:=dyC;
end;


procedure typeAffMat.CalculRbase;
begin
  if (dxAff<>0) or (dyAff<>0) or Fwires
  then calculRbasePara
  else
    begin
      if keepRatio or (angle<>0)
        then calculRbase0
        else calculRbase1;
    end;
end;

procedure typeAffMat.movetoP(ix,iy:integer);
var
  poly:Tpoly4;
  dx,dy:float;
  i:integer;
  ixu,iyu:integer;
begin
  if (ix<Xdim1) or (ix>Xdim2) or (iy<Ydim1) or (iy>Ydim2) then exit;

  if invX then ixu:=ix2-ix+ix1 else ixu:=ix;
  if not invY then iyu:=iy2-iy+iy1 else iyu:=iy;

  dx:=a11*(ixu-ix1)+a12*(iyu-iy1);
  dy:=a21*(ixu-ix1)+a22*(iyu-iy1);

  for i:=1 to 4 do
    begin
      poly[i].x:=round(Rbase[i,1]+dx+x3);
      poly[i].y:=round(Rbase[i,2]+dy+y3);
    end;

  MOvePaveU(poly,ix,iy);
end;

procedure typeAffMat.affPave(ix,iy:integer);
var
  poly:Tpoly4;
  dx,dy:float;
  i:integer;
  ixu,iyu:integer;
begin
  if (ix<Xdim1) or (ix>Xdim2) or (iy<Ydim1) or (iy>Ydim2) then exit;

  if invX then ixu:=ix2-ix+ix1 else ixu:=ix;
  if not invY then iyu:=iy2-iy+iy1 else iyu:=iy;

  dx:=a11*(ixu-ix1)+a12*(iyu-iy1);
  dy:=a21*(ixu-ix1)+a22*(iyu-iy1);

  for i:=1 to 4 do
    begin
      poly[i].x:=round(Rbase[i,1]+dx+x3);
      poly[i].y:=round(Rbase[i,2]+dy+y3);
    end;

  AffPaveU(poly,ix,iy);
end;


procedure typeAffMat.drawBorder(col:longint);
var
  r:array[1..4,1..2] of float;
  poly:array[1..5] of Tpoint;
  i:integer;
  nx,ny:integer;
begin
  nx:=ix2-ix1+1;
  ny:=iy2-iy1+1;

  fillChar(r,sizeof(r),0);
  rotation(dxC*nX+1,dyC*nY+1,R[1,1],R[1,2],0,0,angle);
  rotation(-1,dyC*nY+1,R[2,1],R[2,2],0,0,angle);
  rotation(-1,-1,R[3,1],R[3,2],0,0,angle);
  rotation(dxC*nX+1,-1,R[4,1],R[4,2],0,0,angle);


  for i:=1 to 4 do
    begin
      poly[i].x:=round(R[i,1]+x3);
      poly[i].y:=round(R[i,2]+y3);
    end;
  poly[5]:=poly[1];

  setClippingOff;
  with canvasGlb do
  begin
    pen.color:=col;
    polyLine(poly);
  end;

end;

function typeAffMat.getIRect:Trect;
begin
  result.left:=roundI(x3);
  result.right:=roundI(x3+dxC*(ix2-ix1+1));
  result.top:=roundI(y3);
  result.bottom:=roundI(y3+dyC*(iy2-iy1+1));
end;


procedure typeAffMat.affiche;
var
  i,j:integer;
  Bcol,Pcol:integer;
  Bstyle:TbrushStyle;
  Pstyle:TpenStyle;

  
begin
  Bcol:=canvasGlb.brush.color;
  Pcol:=canvasGlb.pen.color;
  Bstyle:=canvasGlb.brush.style;
  Pstyle:=canvasGlb.pen.style;

  canvasGlb.brush.style:=BSsolid;
  canvasGlb.pen.style:=PSsolid;

  calculRbase;

  if Fwires then
    begin
      for i:=ix1 to ix2 do
        begin
          movetoP(i,iy1);
          for j:=iy1 to iy2 do
            affPave(i,j);
        end;
      for j:=iy1 to iy2 do
        begin
          movetoP(ix1,j);
          for i:=ix1 to ix2 do
            affPave(i,j);
        end;
    end
  else
  {
    for i:=ix1 to ix2 do
      for j:=iy1 to iy2 do
        affPave(i,j);
   }
  begin
    i:=ix1;
    while i<=ix2 do
    begin
      j:=iy1;
      while j<=iy2 do
      begin
        affPave(i,j);
        inc(j,deltaIy);
      end;
      if deltaIy>1 then affPave(i,iy2);
      inc(i,deltaIx);
    end;

    if deltaIx>1 then
    begin
      j:=iy1;
      while j<=iy2 do
      begin
        affPave(ix2,j);
        inc(j,deltaIy);
      end;
      affPave(ix2,iy2);
    end;
  end;
  canvasGlb.brush.color:=Bcol;
  canvasGlb.pen.color:=Pcol;
  canvasGlb.brush.style:=Bstyle;
  canvasGlb.pen.style:=Pstyle;

end;

function typeAffMat.getPixelPos(var x,y:integer):boolean;
var
  gx,gy:double;
  Lx,Ly:double;
  xa,ya:double;

begin
  calculRbase;

  {Rappel:
      dx:=a11*(ixu-ix1)+a12*(iyu-iy1);
      dy:=a21*(ixu-ix1)+a22*(iyu-iy1);
  }
  Lx:=sqrt(sqr(Rbase[1,1]-Rbase[2,1]) + sqr(Rbase[1,2]-Rbase[2,2]) );
  Ly:=sqrt(sqr(Rbase[1,1]-Rbase[4,1]) + sqr(Rbase[1,2]-Rbase[4,2]) );

  xa:=x-x3;
  ya:=y-y3;

  gx:= a11*xa/Lx - a12*ya/Ly;
  gy:=-a21*xa/Lx + a22*ya/Ly;

  x:=floor(gx/Lx);
  y:=floor(gy/Ly);

  if invX then x:=ix2-x else x:=x+ix1;
  if not invY then y:=iy2-y else y:=y+iy1;

  result:=(x>=ix1) and (x<=ix2) and (y>=iy1) and (y<=iy2);
end;

function typeAffMat.getPixelPos(var x,y:float):boolean;
var
  gx,gy:double;
  Lx,Ly:double;
  xa,ya:double;

begin
  calculRbase;

  {Rappel:
      dx:=a11*(ixu-ix1)+a12*(iyu-iy1);
      dy:=a21*(ixu-ix1)+a22*(iyu-iy1);
  }
  Lx:=sqrt(sqr(Rbase[1,1]-Rbase[2,1]) + sqr(Rbase[1,2]-Rbase[2,2]) );
  Ly:=sqrt(sqr(Rbase[1,1]-Rbase[4,1]) + sqr(Rbase[1,2]-Rbase[4,2]) );

  xa:=x-x3;
  ya:=y-y3;

  gx:= a11*xa/Lx - a12*ya/Ly;
  gy:=-a21*xa/Lx + a22*ya/Ly;

  x:=gx/Lx;
  y:=gy/Ly;

  if invX then x:=ix2-x+1 else x:=x+ix1;
  if not invY then y:=iy2-y+1 else y:=y+iy1;

  result:=(x>=ix1) and (x<=ix2) and (y>=iy1) and (y<=iy2);
end;

procedure typeAffMat.afficheCell(i,j:integer);
var
  Bcol,Pcol:integer;
  Bstyle:TbrushStyle;
  Pstyle:TpenStyle;

begin
  if (i<Xdim1) or (i>Xdim2) or (j<Ydim1) or (j>Ydim2) then exit;

  Bcol:=canvasGlb.brush.color;
  Pcol:=canvasGlb.pen.color;
  Bstyle:=canvasGlb.brush.style;
  Pstyle:=canvasGlb.pen.style;

  canvasGlb.brush.style:=BSsolid;
  canvasGlb.pen.style:=PSsolid;

  calculRbase;

  affPave(i,j);

  canvasGlb.brush.color:=Bcol;
  canvasGlb.pen.color:=Pcol;
  canvasGlb.brush.style:=Bstyle;
  canvasGlb.pen.style:=Pstyle;

end;


procedure typeAffMat.affichePave(i,j:integer);
begin
  affPave(i,j);
end;

procedure typeAffMat.DisplayInRect(x,y,dx,dy,theta:float);
var
  i,j:integer;
begin
  theta:=-theta*pi/180;
  dxC:=dx/(ix2-ix1+1);
  dyC:=dy/(iy2-iy1+1);

  rotation(dxC,dyC,Rbase[1,1],Rbase[1,2],0,0,theta);
  rotation(0,dyC,Rbase[2,1],Rbase[2,2],0,0,theta);
  rotation(0,0,Rbase[3,1],Rbase[3,2],0,0,theta);
  rotation(dxC,0,Rbase[4,1],Rbase[4,2],0,0,theta);

  rotation(-dx/2,-dy/2,x3,y3,0,0,theta);

  x3:=x+x3;
  y3:=y+y3;

  a11:=dxC*cos(theta);
  a12:=-dyC*sin(theta);
  a21:=dxC*sin(theta);
  a22:=dyC*cos(theta);


  for i:=ix1 to ix2 do
      for j:=iy1 to iy2 do
          affPave(i,j);
end;

procedure typeAffMat.setDxAffDyAff(dx,dy:float);
begin
  dxAff:=dx;
  dyAff:=dy;
end;


end.
