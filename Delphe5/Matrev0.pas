unit Matrev0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses graphics,classes,
     util1,tpVector,Daffmat,Dpalette;

type
  typeMatRev=class
               name:AnsiString;
               nx,ny:integer;
               tb:PtabEntier;
               form:TpaintVector;
               Lmin,Lmax:integer;
               gamma:float;
               affMat:typeAffMat;
               dp:TDpalette;

               procedure AfficheMat;
               procedure PaintMat(sender:Tobject);
               function getColorA(i,j:longint):longint;
               procedure show(owner:Tcomponent);

               constructor create;
               destructor destroy;override;
               procedure setParam(nbX,nbY:integer;aspect,theta1:float);
               {procedure add(time:integer;var place:TplaceRev;w:integer);}

               function getI(i,j:integer):integer;
               procedure setI(i,j:integer;w:integer);
               procedure addI(i,j:integer;w:integer);
               procedure refresh(cadre:boolean);
               function getMax:integer;
               function getMin:integer;
               procedure cadrer;

               procedure recupParam(l1,l2,g:integer);

             end;

implementation


{*********************   Méthodes de TypeMatRev  *************************}


constructor typeMatRev.create;
begin
  inherited create;

  Lmin:=0;
  Lmax:=10;
  gamma:=1;
end;

destructor typeMatRev.destroy;
begin
  if (nx<>0) and (ny<>0) then freemem(tb,longint(nx)*ny*2);
  form.free;
end;

procedure typeMatRev.setParam(nbX,nbY:integer;aspect,theta1:float);
begin
  if (nx<>0) and (ny<>0) then freemem(tb,longint(nx)*ny*2);
  nx:=0;
  ny:=0;

  if maxAvail<longint(nbX)*nbY*2 then exit;
  getmem(tb,longint(nbX)*nbY*2);
  fillchar(tb^,longint(nbX)*nbY*2,0);
  nx:=nbX;
  ny:=nbY;


  Lmin:=0;
  Lmax:=10;
  with affMat do
  begin
    init(nx,ny,aspect,theta1);
    getCol:=getColorA;
  end;
end;

function typeMatRev.getI(i,j:integer):integer;
  begin
    getI:=tb^[ny*i+j];
  end;

procedure typeMatRev.setI(i,j:integer;w:integer);
  begin
    tb^[ny*i+j]:=w;
  end;

procedure typeMatRev.addI(i,j:integer;w:integer);
  begin
    inc(tb^[ny*i+j],w);
  end;


{
procedure typeMatRev.add(time:integer;var place:TplaceRev;w:integer);
begin
  with place do
  if (time>=dmin) and (time<dmax) and (cont and place.contrast<>0 )
    then inc(tb^[ny*x+y],w);
end;
}
function typeMatRev.getColorA(i,j:longint):longint;
  begin
    getColorA:=dp.colorPal(tb^[ny*(i-1)+j-1]);
  end;

procedure typeMatRev.AfficheMat;

begin
  if (nx=0) and (ny=0) then exit;

  dp.create;
  dp.setPalette(Lmin,Lmax,gamma);
  with affMat do
  begin
    affiche;
    drawBorder(clWhite);
  end;
  dp.free;
end;


procedure typeMatRev.paintMat(sender:Tobject);
var
  i,min,max:integer;

begin
  if (nx=0) and (ny=0) then exit;

  if Lmax=0 then Lmax:=1;

  with form.paintBox1 do
  begin
    initGraphic(canvas,left,top,width,height);
    mainWindow;

    setWindow(5,5,width-5,height-5);
    afficheMat;
  end;
end;

procedure typeMatRev.recupParam(l1,l2,g:integer);
begin
  Lmax:=l1;
  Lmin:=l2;
  gamma:=g;
end;

procedure typeMatRev.show(owner:Tcomponent);
var
  st:AnsiString;
begin
  if not assigned(form) then
    begin
      form:=TpaintVector.create(owner);
      form.color:=clBlack;
      form.onPaint:=paintMat;
      form.caption:=name;
    end;

  {
  st:='RevCor matrix '+Estr(dmin*16.66,0)+'/'+Estr(dmax*16.66,0);
  case cont of
    1: st:=st+' S';
    2: st:=st+' C';
    3: st:=st+' SC';
  end;
  }
  form.show;
end;

procedure typeMatRev.refresh(cadre:boolean);
begin
  if cadre then cadrer;
  if assigned(form) then
    begin
      form.repaint;
    end;
end;

function typeMatRev.getMax:integer;
  var
    i,max:integer;
  begin
    max:=0;
    for i:=0 to nx*ny-1 do
      if tb^[i]>max then max:=tb^[i];
    getMax:=max;
  end;

function typeMatRev.getMin:integer;
  var
    i,min:integer;
  begin
    min:=32767;
    for i:=0 to nx*ny-1 do
      if tb^[i]<min then min:=tb^[i];
    getMin:=min;
  end;

procedure typeMatRev.cadrer;
  begin
    Lmin:=getMin;
    Lmax:=getMax;
    if Lmax=Lmin then Lmax:=Lmin+1;
  end;

end.
