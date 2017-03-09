Retiré de Elphy le 24 juin 2010
unit StmSphere1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,DirectXGraphics, D3DX81mo,
     util1,Dgraphic,dibG,listG,
     stmDef,stmObj,stmD3Dobj,stmPG;

type
  Tsphere=class (Tobject3D)

    Fvalid:boolean;
    NSlices,Nstacks:integer;
    Radius:single;

    color0:integer;

    dev:IDIRECT3DDEVICE8;
    SphereMesh: ID3DXMESH ;
    material:TD3Dmaterial8;

    procedure initGeometry(D3dDevice:IDIRECT3DDEVICE8);

    constructor create;override;
    class function stmClassName:AnsiString;override;
    procedure display3D(D3dDevice:IDIRECT3DDEVICE8;x,y,z,tx,ty,tz:single);override;
    procedure releaseDevice;override;
  end;

procedure proTsphere_create(stName:AnsiString;R:float;slices,Stacks:integer; var pu:typeUO);pascal;
procedure proTsphere_color(col:integer; var pu:typeUO);pascal;
function fonctionTsphere_color(var pu:typeUO):integer;pascal;

implementation

{ Tsphere }

constructor Tsphere.create;
begin
  inherited;

  Nslices:=20;
  Nstacks:=20;
  Radius:=0.1;
  color0:=rgb(255,0,0);
end;

procedure Tsphere.initGeometry(D3dDevice: IDIRECT3DDEVICE8);
begin
  Fvalid:=false;
  SphereMesh:=nil;
  if FAILED( D3DXCreateSphere(d3dDevice, radius,Nslices, Nstacks, SphereMesh, Nil) )
    then exit;

  fillchar( material,sizeof(material),0);
  with material do
  begin
    Diffuse  := rgbtoD3D(color0,1);
    Ambient  := rgbtoD3D(color0,1);
  end;
  Fvalid:=true;
end;


procedure Tsphere.display3D(D3dDevice: IDIRECT3DDEVICE8; x, y, z, tx, ty,tz: single);
var
  matWorld:TD3DXMATRIX;
begin
  D3DXMatrixTranslation(matWorld,x,y,z);
  d3dDevice.SetTransform( D3DTS_WORLD, matWorld );

  if (dev<>d3dDevice) or not Fvalid then initGeometry(D3Ddevice);
  if not Fvalid then exit;

  d3dDevice.setMaterial(material);
  d3dDevice.lightEnable(0,true);
  d3dDevice.SetRenderState( D3DRS_LIGHTING, 1 );
  d3dDevice.SetRenderState(D3DRS_Ambient,rgb(128,128,128));


  SphereMesh.DrawSubset(0);

  dev:=d3dDevice;
end;


procedure Tsphere.releaseDevice;
begin
  inherited;
  sphereMesh:=nil;
  Fvalid:=false;
end;

class function Tsphere.stmClassName: AnsiString;
begin
  result:='Sphere';
end;


{************************ Méthodes STM ****************************************}

procedure proTsphere_create(stName:AnsiString;R:float;slices,Stacks:integer; var pu:typeUO);
begin

  createPgObject(stname,pu,Tsphere);
  with Tsphere(pu) do
  begin
    Radius:=R;
    Nslices:=Slices;
    Nstacks:=Stacks;
  end;
end;

procedure proTsphere_color(col:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tsphere(pu) do
  begin
    color0:=col;
    Fvalid:=false;
  end;
end;

function fonctionTsphere_color(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tsphere(pu) do
  begin
    result:=color0;
  end;
end;


Initialization
AffDebug('Initialization StmSphere1',0);
  registerObject(Tsphere,data);

end.
