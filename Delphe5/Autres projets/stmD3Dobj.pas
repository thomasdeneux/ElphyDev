Retiré de Elphy le 24 juin 2010


unit stmD3Dobj;

interface
                              

uses windows,DirectXGraphics, D3DX81mo,
     util1,Dgraphic,dibG,listG,
     stmDef,stmObj,
     stmMat1;

type
  Tobject3D=class(typeUO)
    constructor create;override;
    class function stmClassName:string;override;
    procedure display3D(D3dDevice:IDIRECT3DDEVICE8;x,y,z,tx,ty,tz:single);virtual;
    procedure releaseDevice;virtual;
  end;


function rgbaValue(r,g,b,a:single):TD3DColorValue;
function D3Dvector(x,y,z:single):TD3Dvector;
function rgbToD3D(col:integer;a:single):TD3DColorValue;

implementation


function rgbaValue(r,g,b,a:single):TD3DColorValue;
begin
  result.r:=r;
  result.g:=g;
  result.b:=b;
  result.a:=a;
end;

function D3Dvector(x,y,z:single):TD3Dvector;
begin
  result.x:=x;
  result.y:=y;
  result.z:=z;
end;

function rgbToD3D(col:integer;a:single):TD3DColorValue;
begin
  result.r:=(col and $FF)/255;
  result.g:=((col shr 8) and $FF)/255;
  result.b:=((col shr 16) and $FF)/255;
  result.a:=a;
end;


{ Tobject3D }


constructor Tobject3D.create;
begin
  inherited;
end;


procedure Tobject3D.display3D(D3dDevice:IDIRECT3DDEVICE8;x,y,z,tx,ty,tz:single);
begin
end;

class function Tobject3D.stmClassName: string;
begin
  result:='Object3D';
end;


procedure Tobject3D.releaseDevice;
begin
end;


end.
