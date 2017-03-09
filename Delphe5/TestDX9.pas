unit TestDX9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MMsystem,
  Dialogs, StdCtrls, ExtCtrls, math,
  DXTypes, Direct3D9G, D3DX9G,
  util1, dibG, BMex1,stmdef,stmObj,
  stmMat1;

type
  TTestForm = class(TForm)
    PanelBottom: TPanel;
    Button1: TButton;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    BMfen: Tdib;
    Fredraw:boolean;

    IDX9: IDirect3D9;
    Idevice: IDirect3DDevice9;
    PresentParam: TD3DPresentParameters;
    renderSurface:Idirect3Dsurface9;


    Xobs, Yobs, Zobs: float;
    Dmin, Dmax: float;
    VB: Idirect3DVertexBuffer9;

    cnt:integer;

    procedure drawBM;
    procedure resizeBM(forcer:boolean);
    procedure BMpaint;

    function InitDX9: boolean;
    function InitDevice: boolean;
    procedure SetDeviceParams;

    function TestDevice: boolean;
    procedure invalidate;override;
  public
    { Déclarations publiques }
    mat: Tmatrix;

    procedure initCube;
    procedure DisplayMat;
end;

var
  TestForm: TTestForm;

implementation

{$R *.dfm}


function RgbToDev(w:longword): longword;
begin
  result:= D3DCOLOR_RGBA( w and $FF, (w shr 8) and $FF, (w shr 16) and $FF, $FF);
end;

procedure TTestForm.FormCreate(Sender: TObject);
var
  i,j:integer;
  d:float;
begin
  BMfen:=Tdib.create;
  BMfen.initRgbDib(Width,Height);

  Yobs:=100;
  Zobs:=100;

  Dmin:= -60;
  Dmax:=60;

  mat:=Tmatrix.create;
  mat.initTemp(0,9,0,9,g_single);

  for i:=mat.Istart to mat.Iend do
  for j:=mat.Jstart to mat.Jend do
  begin
    d:= sqrt(sqr(i-5)+sqr(j-5));
    mat[i,j]:= 10/(1+sqr(d));
  end;

end;

procedure TTestForm.FormDestroy(Sender: TObject);
begin
  BMfen.free;
end;

procedure TtestForm.drawBM;
begin
  paintbox1.canvas.draw(0,0,BMfen);
end;

procedure TTestForm.resizeBM(forcer: boolean);
begin
  if  forcer or (BMfen.width<>paintbox1.width) or (BMfen.height<>paintbox1.height)  then
    begin
      BMfen.width:=paintbox1.width;
      BMfen.height:=paintbox1.height;
      Fredraw:=true;

      PresentParam.BackBufferWidth:=Width;
      PresentParam.BackBufferHeight:=Height;
      if Idevice<>nil then Idevice.reset(PresentParam);
    end;

end;



procedure TTestForm.PaintBox1Paint(Sender: TObject);
begin
  resizeBM(false);

  if Fredraw then BMpaint;

  drawBM;

  panelBottom.Caption:=Istr(cnt);
end;


function TtestForm.InitDX9: boolean;
begin
  IDX9 := Direct3DCreate9(D3D_SDK_VERSION);
  result:= (IDX9 <> nil);
end;


function TtestForm.InitDevice: boolean;
var
  res: integer;
begin
  result:=false;
  if IDX9=nil then exit;

  Idevice:=nil;
  renderSurface:=nil;

  FillChar(PresentParam, SizeOf(PresentParam), 0);
  PresentParam.Windowed := true;
  PresentParam.SwapEffect := D3DSWAPEFFECT_DISCARD;
  //PresentParam.hDeviceWindow:=Handle;
  PresentParam.BackBufferFormat := D3DFMT_A8R8G8B8;
  PresentParam.EnableAutoDepthStencil := True;
  PresentParam.AutoDepthStencilFormat := D3DFMT_D16;


  Res:= IDX9.CreateDevice( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, handle, D3DCREATE_HARDWARE_VERTEXPROCESSING, @PresentParam, Idevice);

  setPrecisionMode(pmExtended);
  Result:= (res=0);
  if result then SetDeviceParams;

end;

procedure TTestForm.SetDeviceParams;
var
  ViewPort: TD3DVIEWPORT9;

begin
  IDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW);
  IDevice.SetRenderState(D3DRS_ZENABLE, iTrue);

  with ViewPort do
  begin
    x:=paintbox1.Left;
    y:=paintbox1.top;
    width:= paintbox1.width;
    height:= paintbox1.height;
    minZ:=0;
    maxZ:=1;
  end;
  Idevice.SetViewport(Viewport);



  Idevice.CreateRenderTarget(PresentParam.BackBufferWidth,PresentParam.BackBufferHeight,D3DFMT_A8R8G8B8, D3DMULTISAMPLE_NONE {D3DMULTISAMPLE_4_SAMPLES } , 0, true, renderSurface, Nil);
  Idevice.SetRenderTarget(0,renderSurface);
  initCube;
end;


type
  TCUSTOMVERTEX=
    record
      position:TD3DVECTOR ;   // The position
      normal:  TD3DVECTOR ;   // The normal
      //color:TD3DCOLOR;        // The color
    end;
  TCUSTOMVERTEXarray=array[0..1] of TCUSTOMVERTEX;
  PCUSTOMVERTEXarray=^TCUSTOMVERTEXarray;
const
  Vformat=D3DFVF_XYZ or D3DFVF_NORMAL;  // or D3DFVF_DIFFUSE;


procedure TTestForm.BMpaint;
var
  i,j:integer;
  res:longword;
  vEyePt, vLookatPt, vUpVec: TD3DVector;
  matWorld,matView,matProj: TD3Dmatrix;

  desc1,desc2: TD3DSURFACE_DESC;
  dc:hdc;

  xRect: D3DLOCKED_RECT;
  p1: PtabLong;
  p2: PtabLong;

  Material: TD3DMATERIAL9 ;
  vecDir: TD3DXVECTOR3;
  light: TD3DLIGHT9;



begin
  if IDX9=nil then
    if not initDX9 then exit;
  if Idevice=nil then
    if not initDevice then exit;

  if not TestDevice then exit;


  Idevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, {D3Dcolor_XRGB(255,0,0)}  rgbToDev(Color), 1, 0);
    // Clear the backbuffer and the zbuffer


  //initcube;

    ZeroMemory(@material, SizeOf(material));
    material.Diffuse.r := 1.0; material.Ambient.r := 1.0;
    material.Diffuse.g := 1.0; material.Ambient.g := 1.0;
    material.Diffuse.b := 0.0; material.Ambient.b := 0.0;
    material.Diffuse.a := 1.0; material.Ambient.a := 1.0;
    IDevice.SetMaterial(Material);

    fillchar(light, sizeof(light),0);
    light._Type := D3DLIGHT_DIRECTIONAL;
    light.Diffuse.r := 1;
    light.Diffuse.g := 1;
    light.Diffuse.b := 1;

    vecDir:= D3DXVector3(1,-1,1 );
    D3DXVec3Normalize(light.Direction, vecDir);
    light.Range := 1000;
    res:=IDevice.SetLight(0, Light);
    if res<>0 then messageCentral('Res='+longtoHexa(res));

    IDevice.LightEnable(0, TRUE);
    IDevice.SetRenderState(D3DRS_LIGHTING, iTrue);
    IDevice.SetRenderState(D3DRS_AMBIENT, $00202020);


    D3DXMatrixRotationX(matWorld, timeGetTime/500.0);
    IDevice.SetTransform(D3DTS_WORLD, matWorld);

    vEyePt:=    D3DXVector3(0.0, 3.0,-5.0);
    vLookatPt:= D3DXVector3Zero;
    vUpVec:=    D3DXVector3(0.0, 1.0, 0.0);
    D3DXMatrixLookAtLH(matView, vEyePt, vLookatPt, vUpVec);
    IDevice.SetTransform(D3DTS_VIEW, matView);

    D3DXMatrixPerspectiveFovLH(matProj, D3DX_PI/4, bmfen.Width/bmfen.Height, 1, 100.0);
    IDevice.SetTransform(D3DTS_PROJECTION, matProj);

  if (SUCCEEDED(Idevice.BeginScene)) then
  begin

   // Render the vertex buffer contents
    res:=IDevice.SetStreamSource(0, VB, 0, SizeOf(TCustomVertex));
    if res<>0 then exit;

    res:=IDevice.SetFVF(Vformat);
    if res<>0 then exit;
    {
    res:=IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2*50-2);
    if res<>0 then exit;
    }
    for i:=0 to 5 do
      IDevice.DrawPrimitive( D3DPT_TRIANGLESTRIP, i*4, 2 );


    Idevice.EndScene;
   end;

  //res:=IDevice.Present(nil, nil, 0, nil);
  //if res<>0 then messageCentral('Res='+longtoHexa(res));
  {
  Ca marche mais c'est très lent
  dc:=0;
  if  (renderSurface<>nil) and (renderSurface.GetDC(dc)=0) then
  begin
    stretchBlt(bmfen.canvas.Handle,0,0,bmfen.Width,bmfen.Height,dc,paintbox1.Left,paintbox1.Top,bmfen.Width,bmfen.Height,srccopy);
    renderSurface.ReleaseDC(dc);
  end;
  }
  if (renderSurface<>nil) and (RenderSurface.LockRect(xRect,Nil, D3DLOCK_READONLY )=0) then
  begin
    with xrect do
    for j:=0 to bmfen.Height-1 do
    begin
      p1:=pointer(intG(pbits)+pitch*(j+paintbox1.Top));
      p2:=bmfen.ScanLine[j];
      for i:=0 to bmfen.Width-1 do
        p2^[i]:= p1^[i+paintbox1.left] and $FFFFFF;

    end;
    RenderSurface.UnlockRect;
  end;

  //delay(100);


  setPrecisionMode(pmExtended);

  Fredraw:=false;
end;



function TTestForm.TestDevice: boolean;
var
  hr: hresult;
  tt:integer;
begin
  result:=false;
  if Idevice=nil then exit;

  hr:=Idevice.TestCooperativeLevel;
  if FAILED(hr) then
  begin
    VB:=nil;
    renderSurface:=nil;
    tt:=0;
    repeat
      delay(100);
      hr:= Idevice.Reset(PresentParam);
      tt:=tt+100;
      if tt>3000 then exit;
    until hr = 0 ;
    result:= (hr=0);

    SetDeviceParams;

  end
  else result:=true;

end;

function getD3DcolorValue(r1,g1,b1,a1:float):TD3DcolorValue;
begin
  with result do
  begin
    r:=r1;
    g:=g1;
    b:=b1;
    a:=a1;
  end;
end;



procedure TtestForm.initCube;
var
  n0, n1, n2, n3, n4, n5: TD3DVector;

  Vertices: array of TCUSTOMVERTEX;
  pVertices: PcustomVertexArray;
  i:integer;
Const
  lx=3;
  ly=3;
  lz=3;
var
  color0:integer;

procedure setVertex(x,y,z:single;n:TD3Dvector;col:integer);
begin
  setlength(Vertices, length(Vertices)+1);
  with Vertices[length(Vertices)-1] do
  begin
    position := D3DXVECTOR3( x,y, z );
    normal   := n;
    //color    := col or $FF000000;
  end;
end;

begin
  setlength(vertices,0);

   // Define the normals for the cube
  n0 := D3DXVector3( 0.0, 0.0, -1 ); // Front face
  n1 := D3DXVector3( 0.0, 0.0, 1 ); // Back face
  n2 := D3DXVector3( 0.0, 1.0, 0 ); // Top face
  n3 := D3DXVector3( 0.0,-1.0, 0 ); // Bottom face
  n4 := D3DXVector3( 1.0, 0.0, 0 ); // Right face
  n5 := D3DXVector3(-1.0, 0.0, 0 ); // Left face

  // Front face
  color0:=rgb(random(256),random(256),random(256));
  setVertex(-lx/2, ly/2,-lz/2, n0, color0 );
  setVertex( lx/2, ly/2,-lz/2, n0, color0 );
  setVertex(-lx/2,-ly/2,-lz/2, n0, color0 );
  setVertex( lx/2,-ly/2,-lz/2, n0, color0 );

  // Back face
    color0:=rgb(random(256),random(256),random(256));
  setVertex(-lx/2, ly/2, lz/2, n1, color0 );
  setVertex(-lx/2,-ly/2, lz/2, n1, color0 );
  setVertex( lx/2, ly/2, lz/2, n1, color0 );
  setVertex( lx/2,-ly/2, lz/2, n1, color0 );

  // Top face
    color0:=rgb(random(256),random(256),random(256));
  setVertex(-lx/2, ly/2, lz/2,  n2, color0 );
  setVertex( lx/2, ly/2, lz/2,  n2, color0 );
  setVertex(-lx/2, ly/2,-lz/2, n2, color0 );
  setVertex( lx/2, ly/2,-lz/2, n2, color0 );

  // Bottom face
    color0:=rgb(random(256),random(256),random(256));
  setVertex(-lx/2,-ly/2, lz/2, n3, color0 );
  setVertex(-lx/2,-ly/2,-lz/2, n3, color0 );
  setVertex( lx/2,-ly/2, lz/2, n3, color0 );
  setVertex( lx/2,-ly/2,-lz/2, n3, color0 );

  // Right face
    color0:=rgb(random(256),random(256),random(256));
  setVertex( lx/2, ly/2,-lz/2, n4, color0 );
  setVertex( lx/2, ly/2, lz/2, n4, color0 );
  setVertex( lx/2,-ly/2,-lz/2, n4, color0 );
  setVertex( lx/2,-ly/2, lz/2, n4, color0 );

  // Left face
    color0:=rgb(random(256),random(256),random(256));
  setVertex(-lx/2, ly/2,-lz/2, n5, color0 );
  setVertex(-lx/2,-ly/2,-lz/2, n5, color0 );
  setVertex(-lx/2, ly/2, lz/2, n5, color0 );
  setVertex(-lx/2,-ly/2, lz/2, n5, color0 );
  
  if IDevice.CreateVertexBuffer( sizeof(TCUSTOMVERTEX)*length(Vertices),
                                    0, Vformat ,
                                    D3DPOOL_DEFAULT, VB, nil )<>0 then exit;

  if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TcustomVertex)*length(vertices));
  VB.Unlock;

  inc(cnt);
end;

(*
procedure TtestForm.initCube;
var
  i: DWORD;
  theta: Single;
  pVertices: PCustomVertexArray;
begin
  // Create the vertex buffer.
  if FAILED(IDevice.CreateVertexBuffer(50*2*SizeOf(TCustomVertex),
                                            0, Vformat,
                                            D3DPOOL_DEFAULT, VB, nil))
  then Exit;

  // Fill the vertex buffer. We are algorithmically generating a cylinder
  // here, including the normals, which are used for lighting.
  if FAILED(VB.Lock(0, 0, Pointer(pVertices), 0))  then Exit;

  for i:= 0 to 49 do
  begin
    theta := (2*D3DX_PI*i)/(50-1);
    pVertices[2*i+0].position := D3DXVector3(Sin(theta),-1.0, Cos(theta));
    pVertices[2*i+0].normal   := D3DXVector3(Sin(theta), 0.0, Cos(theta));
    pVertices[2*i+1].position := D3DXVector3(Sin(theta), 1.0, Cos(theta));
    pVertices[2*i+1].normal   := D3DXVector3(Sin(theta), 0.0, Cos(theta));
  end;
  VB.Unlock;

  inc(cnt);
end;
*)


procedure TTestForm.DisplayMat;
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;

  i,j:integer;


begin
  //IDevice.SetRenderState(D3DRS_AMBIENT, D3DCOLOR_RGBA(0,255,0,22));
  //IDevice.SetRenderState(D3DRS_SHADEMODE, D3DSHADE_GOURAUD);
(*

  fillchar(Material, sizeof(material),0);
  Material.Diffuse :=  getD3DColorValue(1, 1, 0, 1);
  Material.Ambient :=  getD3DColorValue(1, 1, 0, 1);
  Material.Specular := getD3DColorValue(0, 0, 0, 0);
  Material.Emissive := getD3DColorValue(0, 0, 0, 0);
  Material.Power := 0;
  IDevice.SetMaterial(Material);

  fillchar(light, sizeof(light),0);
  light._Type := D3DLIGHT_DIRECTIONAL;
  light.Diffuse.r := 1;
  light.Diffuse.g := 1;
  light.Diffuse.b := 1;
  vecDir := D3DXVECTOR3(1, -1, 0);

  D3DXVec3Normalize(light.Direction, vecDir);
  light.Range := 1000;
  IDevice.SetLight(0, Light);
  IDevice.LightEnable(0, TRUE);
  IDevice.SetRenderState(D3DRS_LIGHTING, iTrue);
  IDevice.SetRenderState(D3DRS_AMBIENT, $00202020);

  if VB=nil then initCube;

   // Render the vertex buffer contents
    IDevice.SetStreamSource(0, VB, 0, SizeOf(TCustomVertex));
    IDevice.SetFVF(Vformat);
    IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2*50-2);

  {
  res:=IDevice.SetStreamSource(0, VB, 0, SizeOf(TcustomVertex));
  res:=IDevice.SetFVF(Vformat);

  for i:=0 to 5 do
    IDevice.DrawPrimitive( D3DPT_TRIANGLESTRIP, i*4, 2 );

   }
*)
end;

procedure TTestForm.Button1Click(Sender: TObject);
begin
  Fredraw:=true;
  invalidateRect(handle,nil,false);
end;

procedure TTestForm.invalidate;
begin
  invalidateRect(handle,nil,false);
end;

end.
