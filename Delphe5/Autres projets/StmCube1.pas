Retiré de Elphy le 24 juin 2010

unit StmCube1;

interface

uses windows,DirectXGraphics,
     D3DX81mo,
     util1,Dgraphic,dibG,listG,
     stmDef,stmObj,stmD3Dobj,stmPG;

type
  Tcube=class (Tobject3D)

    Fvalid:boolean;
    Lx,Ly,Lz:single;

    color0:integer;

    dev:IDIRECT3DDEVICE8;
    VB:IDIRECT3DVERTEXBUFFER8;
    material:TD3Dmaterial8;

    procedure initGeometry(D3dDevice:IDIRECT3DDEVICE8);

    constructor create;override;
    class function stmClassName:string;override;
    procedure display3D(D3dDevice:IDIRECT3DDEVICE8;x,y,z,tx,ty,tz:single);override;
    procedure releaseDevice;override;
  end;

procedure proTcube_create(stName:String;dx,dy,dz:float;col:integer; var pu:typeUO);pascal;
procedure proTcube_color(col:integer; var pu:typeUO);pascal;
function fonctionTcube_color(var pu:typeUO):integer;pascal;

implementation

{ Tcube }

constructor Tcube.create;
begin
  inherited;

  Lx:=0.1;
  Ly:=0.1;
  Lz:=0.1;

  color0:=rgb(255,0,0);
end;


type
  TCUSTOMVERTEX=
    record
      position:TD3DVECTOR ;   // The position
      normal:  TD3DVECTOR ;   // The normal
      color:TD3DCOLOR;        // The color
    end;
  TCUSTOMVERTEXarray=array[0..1] of TCUSTOMVERTEX;
  PCUSTOMVERTEXarray=^TCUSTOMVERTEXarray;
const
  Vformat=D3DFVF_XYZ or D3DFVF_NORMAL or D3DFVF_DIFFUSE;



procedure Tcube.initGeometry(D3dDevice: IDIRECT3DDEVICE8);
var
  n0, n1, n2, n3, n4, n5: TD3DVector;

  pVertices:PCUSTOMVERTEXarray;
  i:integer;

procedure setVertex(num:integer;x,y,z:single;n:TD3Dvector;col:integer);
begin
  with pVertices[num] do
  begin
    position := D3DVECTOR( x,y, z );
    normal   := n;
    color    := col or $FF000000;
  end;
end;

begin
  Fvalid:=false;

  if d3dDevice.CreateVertexBuffer( 24*sizeof(TCUSTOMVERTEX),
                                    0, Vformat ,
                                    D3DPOOL_DEFAULT, VB )<>0 then exit;

  if FAILED( VB.Lock( 0, 0, windows.Pbyte(pVertices), 0 ) )  then exit;

   // Define the normals for the cube
  n0 := D3DVector( 0.0, 0.0,-1 ); // Front face
  n1 := D3DVector( 0.0, 0.0, 1 ); // Back face
  n2 := D3DVector( 0.0, 1.0, 0 ); // Top face
  n3 := D3DVector( 0.0,-1.0, 0 ); // Bottom face
  n4 := D3DVector( 1.0, 0.0, 0 ); // Right face
  n5 := D3DVector(-1.0, 0.0, 0 ); // Left face

  // Front face
  setVertex(0,-lx/2, ly/2,-lz/2, n0, color0 );
  setVertex(1, lx/2, ly/2,-lz/2, n0, color0 );
  setVertex(2,-lx/2,-ly/2,-lz/2, n0, color0 );
  setVertex(3, lx/2,-ly/2,-lz/2, n0, color0 );

  // Back face
  setVertex(4,-lx/2, ly/2, lz/2, n1, color0 );
  setVertex(5,-lx/2,-ly/2, lz/2, n1, color0 );
  setVertex(6, lx/2, ly/2, lz/2, n1, color0 );
  setVertex(7, lx/2,-ly/2, lz/2, n1, color0 );

  // Top face
  setVertex(8,-lx/2, ly/2, lz/2,  n2, color0 );
  setVertex(9, lx/2, ly/2, lz/2,  n2, color0 );
  setVertex(10,-lx/2, ly/2,-lz/2, n2, color0 );
  setVertex(11, lx/2, ly/2,-lz/2, n2, color0 );

  // Bottom face
  setVertex(12,-lx/2,-ly/2, lz/2, n3, color0 );
  setVertex(13,-lx/2,-ly/2,-lz/2, n3, color0 );
  setVertex(14, lx/2,-ly/2, lz/2, n3, color0 );
  setVertex(15, lx/2,-ly/2,-lz/2, n3, color0 );

  // Right face
  setVertex(16, lx/2, ly/2,-lz/2, n4, color0 );
  setVertex(17, lx/2, ly/2, lz/2, n4, color0 );
  setVertex(18, lx/2,-ly/2,-lz/2, n4, color0 );
  setVertex(19, lx/2,-ly/2, lz/2, n4, color0 );

  // Left face
  setVertex(20,-lx/2, ly/2,-lz/2, n5, color0 );
  setVertex(21,-lx/2,-ly/2,-lz/2, n5, color0 );
  setVertex(22,-lx/2, ly/2, lz/2, n5, color0 );
  setVertex(23,-lx/2,-ly/2, lz/2, n5, color0 );


  VB.Unlock;


  fillchar( material,sizeof(material),0);
  with material do
  begin
    Diffuse  := rgbtoD3D(color0,1);
    Ambient  := rgbtoD3D(color0,1);
  end;
  Fvalid:=true;
end;


procedure Tcube.display3D(D3dDevice: IDIRECT3DDEVICE8; x, y, z, tx, ty,tz: single);
var
  matWorld:TD3DMATRIX;
  i:integer;
begin
  D3DXMatrixTranslation(matWorld,x,y,z);
  d3dDevice.SetTransform( D3DTS_WORLD, matWorld );

  if (dev<>d3dDevice) or not Fvalid then initGeometry(D3Ddevice);
  if not Fvalid then exit;

  d3dDevice.setMaterial(material);
  d3dDevice.lightEnable(0,true);
  d3dDevice.SetRenderState( D3DRS_LIGHTING, 1 );
  d3dDevice.SetRenderState(D3DRS_Ambient,rgb(128,128,128));

  d3dDevice.SetStreamSource( 0, VB, sizeof(TCUSTOMVERTEX) );
  d3dDevice.SetVertexShader( Vformat );

  for i:=0 to 5 do
    d3dDevice.DrawPrimitive( D3DPT_TRIANGLESTRIP, i*4, 2 );


  dev:=d3dDevice;
end;


procedure Tcube.releaseDevice;
begin
  inherited;
  vb:=nil;
  Fvalid:=false;
end;

class function Tcube.stmClassName: string;
begin
  result:='Cube';
end;


{************************ Méthodes STM ****************************************}

procedure proTcube_create(stName:String;dx,dy,dz:float;col:integer; var pu:typeUO);
begin

  createPgObject(stname,pu,Tcube);
  with Tcube(pu) do
  begin
    Lx:=dx;
    Ly:=dy;
    Lz:=dz;
    color0:=col;
  end;
end;

procedure proTcube_color(col:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tcube(pu) do
  begin
    color0:=col;
    Fvalid:=false;
  end;
end;

function fonctionTcube_color(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tcube(pu) do
  begin
    result:=color0;
  end;
end;


initialization
  registerObject(Tcube,data);

end.
