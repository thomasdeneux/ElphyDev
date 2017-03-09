unit Dxtest1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mmsystem,
  DirectXGraphics,D3DX81mo, ExtCtrls, editcont;

type
  TDX8test = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    SimplePanel1: TSimplePanel;
    PaintBox1: TPaintBox;
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
    g_pd3dDevice:IDIRECT3DDEVICE8;
    g_pVB:IDIRECT3DVERTEXBUFFER8;
    g_pTexture:IDIRECT3DTEXTURE8;

    procedure render;
    procedure InitGeometry;
    procedure  SetupMatrices;
  public
    { Déclarations publiques }
    procedure ActiveDX8;
  end;

var
  DX8test: TDX8test;

procedure ShowDX;

implementation

{$R *.dfm}
CONST
  nbFace=5;

// A structure for our custom vertex type. We added texture coordinates
type
  TCUSTOMVERTEX=
    record
      position:TD3DVECTOR ;   // The position
      color:TD3DCOLOR;        // The color
      tu, tv:single;          // The texture coordinates
    end;
  TCUSTOMVERTEXarray=array[0..1] of TCUSTOMVERTEX;
  PCUSTOMVERTEXarray=^TCUSTOMVERTEXarray;


procedure ShowDX;
begin
  DX8test.ActiveDX8;
  DX8test.show;
end;

{ TDX8test }

var
  g_pD3D:IDIRECT3D8;


procedure TDX8test.ActiveDX8;
var
  d3DDM:TD3DDISPLAYMODE;
  d3dpp:TD3DPRESENT_PARAMETERS;
begin
   g_pD3D:= Direct3DCreate8( D3D_SDK_VERSION );
   if not assigned(g_pD3D) then exit;

   g_pD3D.GetAdapterDisplayMode( D3DADAPTER_DEFAULT, d3ddm );

   fillchar(d3dpp, sizeof(d3dpp),0 );
   d3dpp.Windowed := TRUE;
   d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
   d3dpp.BackBufferFormat := d3ddm.Format;
   d3dpp.EnableAutoDepthStencil := TRUE;
   d3dpp.AutoDepthStencilFormat := D3DFMT_D16;

   g_pD3D.CreateDevice( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, SimplePanel1.handle,
                        D3DCREATE_SOFTWARE_VERTEXPROCESSING+D3DCREATE_FPU_PRESERVE ,
                        d3dpp, g_pd3dDevice );

    // Turn off culling
   g_pd3dDevice.SetRenderState( D3DRS_CULLMODE, ord(D3DCULL_NONE) );

    // Turn off D3D lighting
   g_pd3dDevice.SetRenderState( D3DRS_LIGHTING, 0 );

    // Turn on the zbuffer
   g_pd3dDevice.SetRenderState( D3DRS_ZENABLE, 1 );

   initGeometry;
end;


procedure TDX8test.InitGeometry;
var
  pVertices:PCUSTOMVERTEXarray;
  i:integer;
  theta:single;

begin
  if  D3DXCreateTextureFromFile( g_pd3dDevice, 'banana2.bmp',g_pTexture)<>0 then exit;


  if g_pd3dDevice.CreateVertexBuffer( nbFace*2*sizeof(TCUSTOMVERTEX),
                                      0, D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1,
                                      D3DPOOL_DEFAULT, g_pVB )<>0 then exit;

  if FAILED( g_pVB.Lock( 0, 0, Pbyte(pVertices), 0 ) )  then exit;

  for i:=0 to nbFace-1 do
    begin
        theta := (2*D3DX_PI*i)/(nbFace-1);

        pVertices[2*i+0].position := D3DXVECTOR3( sin(theta),-1.0, cos(theta) );
        pVertices[2*i+0].color    := $0ffffffff;
        pVertices[2*i+0].tu       := i/(nbFace-1);
        pVertices[2*i+0].tv       := 1;

        pVertices[2*i+1].position := D3DXVECTOR3( sin(theta), 1.0, cos(theta) );
        pVertices[2*i+1].color    := $ff808080;
        pVertices[2*i+1].tu       := i/(nbFace-1);
        pVertices[2*i+1].tv       := 0.0;
    end;
  g_pVB.Unlock;

end;

procedure  TDX8test.SetupMatrices;
var
  matWorld,matView,matProj:TD3DXMATRIX;
  Eye, At, Up : TD3DXVector3;
begin
  D3DXMatrixIdentity( matWorld );
{  D3DXMatrixRotationX( matWorld, timeGetTime/1000);}
{  D3DXMatrixRotationY( matWorld, timeGetTime/2000);}
  g_pd3dDevice.SetTransform( D3DTS_WORLD, matWorld );

  eye:=D3DXVECTOR3( 0.0, 0,-5.0 );
  At:=D3DXVECTOR3( 0.0, 0.0, 0.0 );
  Up:=D3DXVECTOR3( 0.0, 1.0, 0.0 );
  D3DXMatrixLookAtLH( matView,eye,at,up);
  g_pd3dDevice.SetTransform( D3DTS_VIEW, matView );

  D3DXMatrixPerspectiveFovLH( matProj, D3DX_PI/4, simplePanel1.width/simplePanel1.height, 1.0, 100.0 );
  g_pd3dDevice.SetTransform( D3DTS_PROJECTION, matProj );
end;



procedure TDX8test.FormPaint(Sender: TObject);
begin
  Render;
  validateRect(SimplePanel1.handle,nil);
end;

procedure TDX8test.render;
begin
  if not assigned( g_pd3dDevice ) then exit;

  g_pd3dDevice.Clear( 0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,
                       D3DCOLOR_XRGB(0,0,255), 1, 0 );

  g_pd3dDevice.BeginScene;

  SetupMatrices;

  g_pd3dDevice.SetTexture( 0, g_pTexture );
  g_pd3dDevice.SetTextureStageState( 0, D3DTSS_COLOROP,   ord(D3DTOP_MODULATE) );
  g_pd3dDevice.SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
  g_pd3dDevice.SetTextureStageState( 0, D3DTSS_COLORARG2, D3DTA_DIFFUSE );
  g_pd3dDevice.SetTextureStageState( 0, D3DTSS_ALPHAOP,   ord(D3DTOP_DISABLE) );


  g_pd3dDevice.SetStreamSource( 0, g_pVB, sizeof(TCUSTOMVERTEX) );
  g_pd3dDevice.SetVertexShader( D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1 );
  g_pd3dDevice.DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2*nbFace-2 );

  g_pd3dDevice.EndScene;

  g_pd3dDevice.Present( Nil, Nil, 0, Nil );
end;

procedure TDX8test.Timer1Timer(Sender: TObject);
begin
 { render;}
end;

end.
