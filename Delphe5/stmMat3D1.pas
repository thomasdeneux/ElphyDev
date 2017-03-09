Retiré de Elphy le 24 juin 2010

unit stmMat3D1;
                    

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,DirectXGraphics, D3DX81mo,
     util1,Dgraphic,dibG,listG,
     stmDef,stmObj,stmD3Dobj,
     stmMat1,stmPG;

type
  Tmat3D=class(Tobject3D)
    dev:IDIRECT3DDEVICE8;
    VB:IDIRECT3DVERTEXBUFFER8;
    Texture:IDIRECT3DTEXTURE8;

    procedure initGeometry(D3dDevice:IDIRECT3DDEVICE8);
    procedure createMatTexture(D3dDevice:IDIRECT3DDEVICE8);

    constructor create;override;
    class function stmClassName:AnsiString;override;
    procedure display3D(D3dDevice:IDIRECT3DDEVICE8;x,y,z,tx,ty,tz:single);override;
    procedure releaseDevice;override;
  end;

procedure proTmat3D_create(stName:AnsiString; var pu:typeUO);pascal;

implementation


{ Tmat3D }

type
  TCUSTOMVERTEX=
    record
      position:TD3DVECTOR ;   // The position
      color:TD3DCOLOR;        // The color
      tu, tv:single;          // The texture coordinates
    end;
  TCUSTOMVERTEXarray=array[0..1] of TCUSTOMVERTEX;
  PCUSTOMVERTEXarray=^TCUSTOMVERTEXarray;


constructor Tmat3D.create;
begin
  inherited;

end;



procedure Tmat3D.createMatTexture(D3dDevice:IDIRECT3DDEVICE8);
var
  res:integer;
  mat:Tmatrix;
  i,j,i0,j0:integer;
  d,p:float;
  desc:TD3DSURFACE_DESC;
  LockedRect: TD3DLOCKED_RECT;

begin
  mat:=Tmatrix.create;

  with mat do
  begin
    initTemp(1,100,1,100,G_single);
    {palName:='HotColdLin';}

    i0:=Iend div 2;
    j0:=Jend div 2;
    p:=Iend/4;
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      d:=sqrt( sqr(i-i0)+sqr(j-j0));
      if d<p then
        Zvalue[i,j]:=abs(100*sin(2*pi/p*d));
    end;

    autoscaleX;
    autoscaleY;
    autoscaleZ;

    createTexture(d3dDevice,texture);
  end;

  mat.free;

  {
  texture.GetLevelDesc(0,Desc);

  res:=texture.LockRect(0, LockedRect, nil, 0);
  if res=0 then
  begin
   with LockedRect do
   for i:=0 to 9 do
    Fillchar(PtabOctet(pBits)^[pitch*(70+i)],4*100,0);

   texture.unLockRect(0);
 end;
  }

end;

procedure Tmat3D.initGeometry(D3dDevice:IDIRECT3DDEVICE8);
var
  pVertices:PCUSTOMVERTEXarray;
  i:integer;

procedure setVertex(num:integer;x,y,z:single;col:integer;u,v:single);
begin
  with pVertices[num] do
  begin
    position := D3DXVECTOR3( x,y, z );
    color    := col;
    tu       := u;
    tv       := v;
  end;
end;


begin
  createMatTexture(d3dDevice);

  if d3dDevice.CreateVertexBuffer( 4*sizeof(TCUSTOMVERTEX),
                                    0, D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1,
                                    D3DPOOL_DEFAULT, VB )<>0 then exit;

  if FAILED( VB.Lock( 0, 0, windows.Pbyte(pVertices), 0 ) )  then exit;

  setVertex(0, -1, 1,0, d3dColor_colorValue(1,0,0,0.5), 0,0);
  setVertex(1,  1, 1,0, d3dColor_colorValue(1,0,0,0.5), 1,0);
  setVertex(2, -1,-1,0, d3dColor_colorValue(1,0,0,0.5), 0,1);
  setVertex(3,  1,-1,0, d3dColor_colorValue(1,0,0,0.5), 1,1);

  VB.Unlock;
end;

procedure Tmat3D.display3D(D3dDevice:IDIRECT3DDEVICE8;x,y,z,tx,ty,tz:single);
var
  matWorld:TD3DXMATRIX;
  material:TD3Dmaterial8;
begin
  D3DXMatrixTranslation(matWorld,x,y,z);

  d3dDevice.SetTransform( D3DTS_WORLD, matWorld );

  if (dev<>d3dDevice) or not assigned(VB) then initGeometry(D3Ddevice);

  d3dDevice.SetTexture( 0, Texture );
  d3dDevice.SetTextureStageState( 0, D3DTSS_COLOROP,   ord(D3DTOP_SELECTARG1) );
  d3dDevice.SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
  d3dDevice.SetTextureStageState( 0, D3DTSS_ALPHAOP,   ord(D3DTOP_SELECTARG1) );
  d3dDevice.SetTextureStageState( 0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE );

  d3dDevice.lightEnable(0,false);
  d3dDevice.SetRenderState( D3DRS_LIGHTING, 0 );

  d3dDevice.SetRenderState(D3DRS_ALPHABLENDENABLE,1);
  d3dDevice.SetRenderState(D3DRS_SRCBLEND,ord(D3DBLEND_SRCALPHA));
  d3dDevice.SetRenderState(D3DRS_DESTBLEND,ord(D3DBLEND_INVSRCALPHA));


  d3dDevice.SetStreamSource( 0, VB, sizeof(TCUSTOMVERTEX) );
  d3dDevice.SetVertexShader( D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1 );
  d3dDevice.DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2 );

  d3dDevice.SetRenderState(D3DRS_ALPHABLENDENABLE,0);
  d3dDevice.SetRenderState(D3DRS_SRCBLEND,ord(D3DBLEND_ONE));
  d3dDevice.SetRenderState(D3DRS_DESTBLEND,ord(D3DBLEND_ZERO));


  d3dDevice.SetTexture( 0, nil );

  dev:=d3dDevice;

end;

class function Tmat3D.stmClassName: AnsiString;
begin
  result:='Mat3D';
end;


procedure Tmat3D.releaseDevice;
begin
  vb:=nil;
  texture:=nil;
  dev:=nil;
end;

procedure proTmat3D_create(stName:AnsiString; var pu:typeUO);
begin
  createPgObject(stname,pu,Tmat3D);
end;

Initialization
AffDebug('Initialization stmMat3D1',0);
  registerObject(Tmat3D,data);

end.
