unit dxtest1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,MMsystem, StdCtrls,
  DirectXGraphics, D3DX81mo, ExtCtrls, editcont,
  util1,dibG,stmMat1;

type
  TDX8test = class(TForm)
    Panel1: TPanel;
    SimplePanel1: TSimplePanel;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    sbD: TscrollbarV;
    sbPhi: TscrollbarV;
    sbAlpha: TscrollbarV;
    LabelD: TLabel;
    LabelPhi: TLabel;
    LabelAlpha: TLabel;
    procedure PaintBox1Paint(Sender: TObject);
    procedure sbDScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbPhiScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbAlphaScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    d3dDevice:IDIRECT3DDEVICE8;  { Le device }
    VB:IDIRECT3DVERTEXBUFFER8;   { Un vertexBuffer }
    Texture:IDIRECT3DTEXTURE8;   { Une texture }

    MatTex: IDIRECT3DTEXTURE8;   { Une texture }
    D0,phi0,alpha0:float;

    d3DDM:TD3DDISPLAYMODE;

    procedure render;
    procedure InitGeometry;
    procedure  SetupMatrices(D,alpha,phi:float);

    procedure createMatTexture;
  public
    { Déclarations publiques }
    function ActiveDX8:boolean;
    function ActiveFullScreen:boolean;
  end;


var
  DX8test: TDX8test;

procedure ShowDX;

implementation

{$R *.dfm}

var
  D3D8:IDIRECT3D8; {L'unique interface IDIRECT3D8 }



CONST
  nbFace=4;

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
  if DX8test.ActiveDX8
    then DX8test.show;


  {DX8test.ActiveFullScreen;}
end;



{ TDX8test }


function TDX8test.ActiveDX8:boolean;
var

  d3dpp:TD3DPRESENT_PARAMETERS;
const
  IsOK:boolean=false;
begin
  if IsOK then
    begin
      result:=true;
      exit;
    end;

  result:=false;
  D3D8:= Direct3DCreate8( D3D_SDK_VERSION );
  if not assigned(D3D8) then exit;

  D3D8.GetAdapterDisplayMode( D3DADAPTER_DEFAULT, d3ddm );

  fillchar(d3dpp, sizeof(d3dpp),0 );
  d3dpp.Windowed := TRUE;
  d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
  d3dpp.BackBufferFormat := d3ddm.Format;
  d3dpp.EnableAutoDepthStencil := TRUE;
  d3dpp.AutoDepthStencilFormat := D3DFMT_D16;

  if Failed( D3D8.CreateDevice( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, SimplePanel1.handle,
                        D3DCREATE_SOFTWARE_VERTEXPROCESSING+D3DCREATE_FPU_PRESERVE ,
                        d3dpp, d3dDevice ) )
     then exit;

   // Turn off culling
  d3dDevice.SetRenderState( D3DRS_CULLMODE, ord(D3DCULL_NONE) );

   // Turn off D3D8 lighting
  d3dDevice.SetRenderState( D3DRS_LIGHTING, 0 );

   // Turn on the zbuffer
  d3dDevice.SetRenderState( D3DRS_ZENABLE, 1 );

  initGeometry;

  isOK:=true;
  result:=true;
end;

function TDX8test.ActiveFullScreen:boolean;
var
  d3DDM:TD3DDISPLAYMODE;
  d3dpp:TD3DPRESENT_PARAMETERS;
begin
  result:=false;
  D3D8:= Direct3DCreate8( D3D_SDK_VERSION );
  if not assigned(D3D8) then exit;

  D3D8.GetAdapterDisplayMode( 1{D3DADAPTER_DEFAULT}, d3ddm );

  fillchar(d3dpp, sizeof(d3dpp),0 );
  d3dpp.Windowed := false;
  d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;

  d3dpp.EnableAutoDepthStencil := TRUE;
  d3dpp.AutoDepthStencilFormat := D3DFMT_D16;
  d3dpp.BackBufferWidth  := d3ddm.Width;
  d3dpp.BackBufferHeight := d3ddm.Height;
  d3dpp.BackBufferFormat := d3ddm.Format;
  d3dpp.FullScreen_RefreshRateInHz:=150;

  if Failed( D3D8.CreateDevice( 1{D3DADAPTER_DEFAULT}, D3DDEVTYPE_HAL,handle,
                        D3DCREATE_SOFTWARE_VERTEXPROCESSING+D3DCREATE_FPU_PRESERVE ,
                        d3dpp, d3dDevice ) )
     then exit;

   // Turn off culling
  d3dDevice.SetRenderState( D3DRS_CULLMODE, ord(D3DCULL_NONE) );

   // Turn off D3D8 lighting
  d3dDevice.SetRenderState( D3DRS_LIGHTING, 0 );

   // Turn on the zbuffer
  d3dDevice.SetRenderState( D3DRS_ZENABLE, 1 );

  initGeometry;

  render;
  repeat until testEscape;
  result:=true;
end;


procedure TDX8test.InitGeometry;
var
  pVertices:PCUSTOMVERTEXarray;
  i:integer;
  theta:single;

begin
  {if  D3DXCreateTextureFromFile( d3dDevice, 'banana2.bmp',Texture)<>0 then exit;}
  createMatTexture;


  if d3dDevice.CreateVertexBuffer( (nbFace+1)*2*sizeof(TCUSTOMVERTEX),
                                      0, D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1,
                                      D3DPOOL_DEFAULT, VB )<>0 then exit;

  if FAILED( VB.Lock( 0, 0, windows.Pbyte(pVertices), 0 ) )  then exit;

  for i:=0 to nbFace do
    begin
        theta := (2*D3DX_PI*i)/(nbFace) + Pi/nbFace;

        pVertices[2*i+0].position := D3DXVECTOR3( sin(theta),-1.0, cos(theta) );
        pVertices[2*i+0].color    := $0ffffffff;
        pVertices[2*i+0].tu       := 10/16* (i mod 2);
        pVertices[2*i+0].tv       := 10/16;

        pVertices[2*i+1].position := D3DXVECTOR3( sin(theta), 1.0, cos(theta) );
        pVertices[2*i+1].color    := $ff808080;
        pVertices[2*i+1].tu       := 10/16* (i mod 2);
        pVertices[2*i+1].tv       := 0.0;
    end;
  VB.Unlock;

end;

procedure  TDX8test.SetupMatrices(D,alpha,phi:float);
var
  matWorld,matView,matProj:TD3DXMATRIX;
  Eye, At, Up : TD3DXVector3;
begin
  D3DXMatrixIdentity( matWorld );
{  D3DXMatrixRotationX( matWorld, timeGetTime/1000);}
{  D3DXMatrixRotationY( matWorld, timeGetTime/2000);}
  d3dDevice.SetTransform( D3DTS_WORLD, matWorld );


  eye:=D3DXVECTOR3( D*cos(alpha)*sin(phi), D*sin(alpha),-D*cos(alpha)*cos(phi));
  At:=D3DXVECTOR3( 0.0, 0.0, 0.0 );
  Up:=D3DXVECTOR3( -sin(alpha)*sin(phi),cos(alpha),sin(alpha)*cos(phi));
  D3DXMatrixLookAtLH( matView,eye,at,up);

  d3dDevice.SetTransform( D3DTS_VIEW, matView );

  D3DXMatrixPerspectiveFovLH( matProj, D3DX_PI/4, simplePanel1.width/simplePanel1.height, 1.0, 100.0 );
  d3dDevice.SetTransform( D3DTS_PROJECTION, matProj );
end;



procedure TDX8test.render;
begin
  if not assigned( d3dDevice ) then exit;

  d3dDevice.Clear( 0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,
                       D3DCOLOR_XRGB(0,0,255), 1, 0 );

  d3dDevice.BeginScene;

  SetupMatrices(D0,phi0,alpha0);

  d3dDevice.SetTexture( 0, Texture );
  d3dDevice.SetTextureStageState( 0, D3DTSS_COLOROP,   ord(D3DTOP_MODULATE) );
  d3dDevice.SetTextureStageState( 0, D3DTSS_COLORARG1, D3DTA_TEXTURE );
  d3dDevice.SetTextureStageState( 0, D3DTSS_COLORARG2, D3DTA_DIFFUSE );
  d3dDevice.SetTextureStageState( 0, D3DTSS_ALPHAOP,   ord(D3DTOP_DISABLE) );


  d3dDevice.SetStreamSource( 0, VB, sizeof(TCUSTOMVERTEX) );
  d3dDevice.SetVertexShader( D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1 );
  d3dDevice.DrawPrimitive( D3DPT_TRIANGLESTRIP, 0, 2*(nbFace+1)-2 );

  d3dDevice.EndScene;

  d3dDevice.Present( Nil, Nil, 0, Nil );

  labelD.Caption:=Estr(D0,3);
  labelPhi.Caption:=Estr(Phi0,3);
  labelAlpha.Caption:=Estr(Alpha0,3);
end;


procedure TDX8test.PaintBox1Paint(Sender: TObject);
begin

  Render;
  validateRect(SimplePanel1.handle,nil);

end;

procedure TDX8test.sbDScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  d0:=x;
  render;
end;

procedure TDX8test.sbPhiScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  phi0:=x;
  render;
end;

procedure TDX8test.sbAlphaScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  alpha0:=x;
  render;
end;

procedure TDX8test.FormCreate(Sender: TObject);
begin
  D0:=5;
  sbD.setParams(D0,1,10);
  sbD.dxSmall:=0.01;
  sbD.dxLarge:=0.1;

  sbPhi.setParams(phi0,-pi,pi);
  sbPhi.dxSmall:=0.01;
  sbPhi.dxLarge:=0.1;

  sbAlpha.setParams(alpha0,-pi/2,pi/2);
  sbAlpha.dxSmall:=0.01;
  sbAlpha.dxLarge:=0.1;

end;

procedure TDX8test.createMatTexture;
var
  res:integer;
  mat:Tmatrix;
  i,j,i0,j0:integer;
  d,p:float;
begin
  mat:=Tmatrix.create;

  with mat do
  begin
    initTemp(1,100,1,100,G_single);
    palName:='HotColdLin';

    i0:=Iend div 2;
    j0:=Jend div 2;
    p:=Iend/4;
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      d:=sqrt( sqr(i-i0)+sqr(j-j0));
      Zvalue[i,j]:=100*sin(2*pi/p*d);
    end;

    autoscaleX;
    autoscaleY;
    autoscaleZ;

    createTexture(d3dDevice,texture);
  end;

  mat.free;
end;

end.
