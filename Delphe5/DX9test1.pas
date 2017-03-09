unit DX9test1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DXTypes, Direct3D9G, D3DX9G, StdCtrls,
  math,

  util1, dibG, editcont;


Const
  WinMode=true;  

type
  TMainForm = class(TForm)
    Bcreate: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button1: TButton;
    Button3: TButton;
    cbAnimate: TCheckBoxV;
    Button4: TButton;
    procedure BcreateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Déclarations privées }
    DXform: Tform;
    IDX9: IDirect3D9;
    Idevice: IDirect3DDevice9;
    PresentParam: TD3DPresentParameters;
    GratingTexture: IDirect3DTexture9;
    GaussTexture: IDirect3DTexture9;

    VB: IDirect3DVertexBuffer9;
    NV2:integer;

    Frender: integer;
    Fanimate: boolean;

    procedure DXformResize(Sender: TObject);
  public
    { Déclarations publiques }
    Swidth, Sheight: integer;


    function InitD3D: HRESULT;
    procedure Cleanup;
    procedure Render;
    function InitVB1: HRESULT;
    function InitVB2: HRESULT;
    function InitVBsquare: HRESULT;

    function InitVB: HRESULT;

    procedure CreateGratingTexture;
    procedure CreateGaussTexture;
  end;

type
  TCustomVertex = packed record
    x, y, z, rhw: Single; // The transformed position for the vertex
    color: DWORD;         // The vertex color
  end;

  TCustomVertexArray = Array[0..0] of TCustomVertex;
  PCustomVertexArray = ^TCustomVertexArray;
const
  D3DFVF_CUSTOMVERTEX = (D3DFVF_XYZRHW or D3DFVF_DIFFUSE);


type
  TCustomVertex2 = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u,v:single;
  end;

  TCustomVertexArray2 = Array[0..0] of TCustomVertex2;
  PCustomVertexArray2 = ^TCustomVertexArray2;
const
  D3DFVF_CUSTOMVERTEX2 = (D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1);


type
  TCustomVertex3 = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u1,v1: single;
    u2,v2: single;

  end;

  TsquareVertex = Array[0..3] of TCustomVertex3;
  PsquareVertex = ^TsquareVertex;

const
  D3DFVF_CUSTOMVERTEX3 = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX2;


var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Const
  Imax=140;
  Jmax=70;

  dx=(1920-20) div Imax;
  dy=(1080-20) div Jmax;

function TmainForm.InitD3D: HRESULT;
var
  i,j,N, Nscreen: integer;
  screenId: array[0..10] of TD3DADAPTER_IDENTIFIER9;
  w: TD3DFORMAT;
  displayMode: TD3DDISPLAYMODE;
  Adapter: integer;
  prect: TD3DlockedRect;


begin
  Result:= E_FAIL;

  IDX9 := Direct3DCreate9(D3D_SDK_VERSION);
  if (IDX9 = nil) then Exit;

  Nscreen:=IDX9.GetAdapterCount;
  Memo1.Lines.Add('Nscreen= '+Istr(Nscreen));

  for i:=0 to Nscreen-1 do
  begin
    IDX9.GetAdapterIdentifier(i,0,screenId[i]);
    with ScreenId[i] do Memo1.Lines.Add(tabToString(Driver,512)+'  ' + tabToString(Description,512)+'  ' + tabToString(DeviceName,512));
  end;

  Adapter:=2;
  N:=IDX9.GetAdapterModeCount(Adapter,D3DFMT_X8R8G8B8 );
  Memo1.Lines.Add( 'AdapterModeCount = '+Istr(N));

  for i:=0 to N-1 do
  begin
    IDX9.EnumAdapterModes(Adapter, D3DFMT_X8R8G8B8, i, displayMode);
    with displayMode do Memo1.Lines.Add( Istr1(Width,5)+Istr1(Height,5)+ Istr1(RefreshRate,5)+ Istr1(ord(format),4) );
  end;

  FillChar(PresentParam, SizeOf(PresentParam), 0);

  if not WinMode then
  begin
    Swidth:=1920;
    Sheight:=1080;
    PresentParam.BackBufferWidth:= Swidth;
    PresentParam.BackBufferHeight:= Sheight;
    PresentParam.Windowed := false;
    PresentParam.SwapEffect := D3DSWAPEFFECT_DISCARD;
    PresentParam.BackBufferFormat := D3DFMT_X8R8G8B8;

    PresentParam.hDeviceWindow:=DXform.Handle;
    PresentParam.FullScreen_RefreshRateInHz:=120;
  end
  else
  begin
    PresentParam.Windowed := true;
    PresentParam.SwapEffect := D3DSWAPEFFECT_DISCARD;
    PresentParam.BackBufferFormat := D3DFMT_X8R8G8B8;
  end;

  Result:= IDX9.CreateDevice(2, D3DDEVTYPE_HAL, DXform.handle, D3DCREATE_SOFTWARE_VERTEXPROCESSING, @PresentParam, Idevice);
  if FAILED(Result) then
  begin
    MainForm.Memo1.Lines.Add( 'Failed CreateDevice '+Istr(result));
    Result:= E_FAIL;
    Exit;
  end;

  IDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CW);
  IDevice.SetRenderState(D3DRS_ZENABLE, 0);
  // Turn off D3D lighting, since we are providing our own vertex colors
  IDevice.SetRenderState(D3DRS_LIGHTING, iFalse);
//  IDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);

  CreateGratingTexture;
  CreateGaussTexture;

  DXform.Show;

  Result:= S_OK;
end;

procedure TMainForm.CreateGratingTexture;
var
  i,j: integer;
  bm:Tbitmap;
  memoryStream: TmemoryStream;
  res:integer;
begin

  bm:=Tbitmap.create;
  bm.Width:=512;
  bm.Height:=512;

  with bm.Canvas do
  for i:= 0 to bm.Width-1 do
  for j:= 0 to bm.height-1 do
   pixels[i,j]:=rgb(0,round(128+ 127*sin(2*pi/512*i)),0);

  memoryStream:= TmemoryStream.Create;
  bm.SaveToStream(memoryStream);

  res:=D3DXCreateTextureFromFileInMemory(Idevice,memoryStream.Memory,memoryStream.Size,GratingTexture);
  Memo1.Lines.Add( 'CreateTexture = '+Istr(res));
  memoryStream.free;
  bm.free;
end;

(*
procedure TMainForm.CreateGaussTexture;
var
  i,j: integer;
  bm:Tbitmap;
  memoryStream: TmemoryStream;
  res:integer;
  alpha, L0: single;
begin

  bm:=Tbitmap.create;
  bm.Width:=512;
  bm.Height:=512;

  L0:= bm.Width/6;

  with bm.Canvas do
  for i:= 0 to bm.Width-1 do
  for j:= 0 to bm.height-1 do
  begin
    alpha:= 255 *exp(- sqr((i-bm.Width/2)/L0)-sqr((j-bm.Height/2)/L0));
    pixels[i,j]:=rgb(0,round(alpha),0 );
  end;

  memoryStream:= TmemoryStream.Create;
  bm.SaveToStream(memoryStream);

  res:=D3DXCreateTextureFromFileInMemory(Idevice,memoryStream.Memory,memoryStream.Size,GaussTexture);
  Memo1.Lines.Add( 'CreateTexture = '+Istr(res));
  memoryStream.free;
  bm.free;
end;
*)
(*
procedure TMainForm.CreateGaussTexture;
var
  i,j: integer;
  bm:Tbitmap;
  memoryStream: TmemoryStream;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  alpha, L0: single;
begin
  bm:=Tbitmap.create;
  bm.Width:=512;
  bm.Height:=512;

  memoryStream:= TmemoryStream.Create;
  bm.SaveToStream(memoryStream);

  res:=D3DXCreateTextureFromFileInMemory(Idevice,memoryStream.Memory,memoryStream.Size,GaussTexture);
  Memo1.Lines.Add( 'CreateTexture = '+Istr(res));
  memoryStream.free;

  res:= GaussTexture.LockRect( 0, xrect, nil, 0);
  Memo1.Lines.Add( 'Lock Texture = '+Istr(res));
  Memo1.Lines.Add( 'Pbits ='+Istr(IntG(xrect.pbits))+ '   Pitch = '+Istr(xrect.Pitch));

  if res<>0 then exit;

  L0:= bm.Width/6;

  with xRect do
  begin
    for j:= 0 to bm.height-1 do
    begin
      p:= pointer(intG(pbits)+pitch*j);
      for i:= 0 to bm.Width-1 do
      begin
        alpha:= 255 *exp(- sqr((i-bm.Width/2)/L0)-sqr((j-bm.Height/2)/L0));
        p^[i]:=D3Dcolor_rgba(0,round(alpha),0,round(alpha) );
      end;
    end;
  end;

  res:=GaussTexture.UnlockRect(0);
  Memo1.Lines.Add( 'UnLock Texture = '+Istr(res));
  bm.free;
end;
*)


procedure TMainForm.CreateGaussTexture;
var
  i,j: integer;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  alpha, L0: single;
Const
  TextureSize=512;
begin

  res:=D3DXCreateTexture(Idevice,TextureSize,TextureSize,0,D3DUSAGE_AUTOGENMIPMAP,D3DFMT_A8R8G8B8,D3DPOOL_MANAGED,GaussTexture);

  Memo1.Lines.Add( 'CreateTexture = '+Istr(res));

  res:= GaussTexture.LockRect( 0, xrect, nil, 0);
  Memo1.Lines.Add( 'Lock Texture = '+Istr(res));
  Memo1.Lines.Add( 'Pbits ='+Istr(IntG(xrect.pbits))+ '   Pitch = '+Istr(xrect.Pitch));

  if res<>0 then exit;

  L0:= TextureSize/6;

  with xRect do
  begin
    for j:= 0 to TextureSize-1 do
    begin
      p:= pointer(intG(pbits)+pitch*j);
      for i:= 0 to TextureSize-1 do
      begin
        alpha:= 255 *exp(- sqr((i-TextureSize/2)/L0)-sqr((j-TextureSize/2)/L0));
        p^[i]:=D3Dcolor_rgba(0,round(alpha),0,round(alpha) );
      end;
    end;
  end;

  res:=GaussTexture.UnlockRect(0);
  Memo1.Lines.Add( 'UnLock Texture = '+Istr(res));
end;

//-----------------------------------------------------------------------------
// Name: Cleanup()
// Desc: Releases all previously initialized objects
//-----------------------------------------------------------------------------
procedure TmainForm.Cleanup;
begin
  if (Idevice <> nil) then  Idevice:= nil;
  if (IDX9 <> nil) then IDX9:= nil;
  if (VB <> nil) then  VB:= nil;
  if GratingTexture<>nil then GratingTexture:=nil;
end;


function TmainForm.InitVB1: HRESULT;
var
  vertices: array of TCustomVertex;
  i,j,col:integer;
  up: boolean;
  NVmax: integer;

  pVertices: Pointer;

  procedure store(i,j,col: integer);
  begin
    with vertices[NV2] do
    begin
      x:=dx*i+10;
      y:=dy*j+10;
      z:=0.5;
      rhw:=1;
      color:=  D3Dcolor_rgba(0,col,0,$FF);
    end;
    inc(NV2);
  end;

begin
  Result:= E_FAIL;

  NVmax:=(Imax+2)*(Jmax+1)*4;
  setLength(vertices,NVmax);

  j:=0;
  NV2:=0;

  for j:=0 to Jmax-1 do
  begin
    for i:=0 to Imax-1 do
    begin
      col:=random(256);
      if (i=0) and (j<>0) then
      begin
        store(Imax,j+1,col);
        store(0,j+1,col);
      end;
      store(i,j+1,col);
      store(i,j,col);
      store(i+1,j+1,col);
      store(i+1,j,col);
    end;
  end;

  VB:=nil;
  if FAILED(IDevice.CreateVertexBuffer(SizeOf(TCustomVertex)*NV2, 0, D3DFVF_CUSTOMVERTEX, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TCustomVertex)*NV2);
  VB.Unlock;

  Memo1.Lines.Add( 'InitVB2 = '+Istr(NV2));
  Result:= S_OK;
end;

function TmainForm.InitVB2: HRESULT;
var
  vertices: array of TCustomVertex2;
  i,j,col:integer;
  up: boolean;
  NVmax: integer;

  pVertices: Pointer;

  procedure store(i,j,col: integer);
  begin
    with vertices[NV2] do
    begin
      x:=dx*i+10;
      y:=dy*j+10;
      z:=0;
      color:=  D3Dcolor_rgba(0,col,0,$FF);
    end;
    inc(NV2);
  end;

begin
  Result:= E_FAIL;

  NVmax:=(Imax+2)*(Jmax+1)*4;
  setLength(vertices,NVmax);

  j:=0;
  NV2:=0;

  for j:=0 to Jmax-1 do
  begin
    for i:=0 to Imax-1 do
    begin
      col:=random(256);
      if (i=0) and (j<>0) then
      begin
        store(Imax,j+1,col);
        store(0,j+1,col);
      end;
      store(i,j+1,col);
      store(i,j,col);
      store(i+1,j+1,col);
      store(i+1,j,col);
    end;
  end;

  VB:=nil;
  if FAILED(IDevice.CreateVertexBuffer(SizeOf(TCustomVertex2)*NV2, 0, D3DFVF_CUSTOMVERTEX2, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TCustomVertex2)*NV2);
  VB.Unlock;

  Memo1.Lines.Add( 'InitVB2 = '+Istr(NV2));
  Result:= S_OK;
end;

function TmainForm.InitVBsquare: HRESULT;
var
  vertices: TsquareVertex;
  i,j,col:integer;
  up: boolean;
  NVmax: integer;

  pVertices: Pointer;

  procedure store(i,j: integer);
  begin
    with vertices[NV2] do
    begin
      x:= 500 +1000*i;
      y:= 200 +600*j ;
      z:=0;
      color:=  D3Dcolor_rgba(0,64,0,$FF);

      u1:= -2 + i*5;
      v1:= -2 + j*5;

      u2:= 0 + i*20;
      v2:= 0 + j*1;

    end;
    inc(NV2);
  end;

begin
  Result:= E_FAIL;

  NV2:=0;
  store(0,1);
  store(0,0);
  store(1,1);
  store(1,0);

  VB:=nil;
  if FAILED(IDevice.CreateVertexBuffer(SizeOf(TCustomVertex3)*4, 0, D3DFVF_CUSTOMVERTEX3, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices, SizeOf(TCustomVertex3)*4);
  VB.Unlock;

  Result:= S_OK;
end;

function TmainForm.InitVB: HRESULT;
begin
  case Frender of
    1: initVB1;
    2: initVB2;
    3: initVBsquare;
  end;
end;


procedure TmainForm.Render;
Const
  N:integer=0;
var
  hr, res: Hresult;
  tt:integer;
  pVertices: PCustomVertexArray;
  pVertices2: PCustomVertexArray2;
  pVertices3: PsquareVertex;
  i: integer;
  line,column, col:integer;
  mat, m: TD3DMatrix;
  vEyePt, vLookatPt, vUpVec: TD3DVector;
  sinT,cosT,u1,v1: single;
  Ag,Bg, contrast: single;
  BKcol: integer;

begin
  BKcol:=100;

  if (Idevice = nil) then Exit;

  hr:=Idevice.TestCooperativeLevel;
  if FAILED(hr) then
  begin
    VB:=nil;
    initVB;
    Memo1.Lines.Add( 'Render Failed = '+Istr(hr));

    tt:=0;
    repeat
      delay(100);
      hr:= Idevice.Reset(PresentParam);
      tt:=tt+100;
      if tt>2000 then exit;
    until hr = 0 ;
  end;



  inc(N);
  Memo1.Lines.Add( 'Render = '+Istr(N));

  Idevice.Clear(0, nil, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0,BKcol,0), 1.0, 0);

  case Frender of
    1:begin
        if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;
        for i:=0 to NV2-1 do
        begin
          line:=i div(Imax*4+2);
          column:= (i mod (Imax*4+2));
          if (column mod 4=0) and (column<Imax*4) then col:=random(256);

          pVertices^[i].color:= D3Dcolor_rgba(0,col,0,$FF);
        end;

        VB.Unlock;
      end;
    2:begin
        if FAILED(VB.Lock(0, 0, pointer(pVertices2), 0)) then Exit;
        for i:=0 to NV2-1 do
        begin
          line:=i div(Imax*4+2);
          column:= (i mod (Imax*4+2));
          if (column mod 4=0) and (column<Imax*4) then col:=random(256);

          pVertices2^[i].color:= D3Dcolor_rgba(0,col,0,$FF);
        end;

        VB.Unlock;
      end;

    3:begin
        if FAILED(VB.Lock(0, 0, pointer(pVertices3), 0)) then Exit;

        cosT:=cos(pi/(2*120));
        sinT:=sin(pi/(2*120));


        for i:=0 to 3 do
        with pVertices3^[i] do
        begin
          Memo1.Lines.Add( '      u1 = '+Estr(u1,6));
          Memo1.Lines.Add( '      v1 = '+Estr(v1,6));

          u2:=u2+0.005;
          {v:=v+0.005;

          u1:=u-0.5;
          v1:=v-0.5;
          u:=cosT*u1 - sinT*v1 +0.5;
          v:=sinT*u1 + cosT*v1 +0.5;

          Memo1.Lines.Add( 'u = '+Estr(u,6));
          Memo1.Lines.Add( 'v = '+Estr(v,6));
          }
        end;
        VB.Unlock;
      end;
  end;


  if (SUCCEEDED(Idevice.BeginScene)) then
  begin
    //World
    D3DXMatrixTranslation(mat,-Swidth/2,-Sheight/2,0);
    D3DXMatrixRotationZ(m, pi/6);
    D3DXMatrixMultiply(mat,mat,m);
    D3DXMatrixTranslation(m,Swidth/2,Sheight/2,0);
    D3DXMatrixMultiply(mat,mat,m);
    //D3DXMatrixScaling(m,0.1,0.1,1);
    //D3DXMatrixMultiply(mat,mat,m);

    res:=IDevice.SetTransform(D3DTS_WORLD, mat);

    //View
    vEyePt:= D3DXVector3(Swidth/2, Sheight/2,  -1000 );
    vLookatPt:= D3DXVector3(Swidth/2, Sheight/2, 0.0);
    vUpVec:= D3DXVector3(0.0, 1.0, 0.0);
    D3DXMatrixLookAtLH(mat, vEyePt, vLookatPt, vUpVec);
    Idevice.SetTransform(D3DTS_VIEW, mat);

    //Projection
    D3DXMatrixPerspectiveFovLH(mat,arctan(Sheight/2/1000)*2 , Swidth/Sheight, 0, 1);
    res:=IDevice.SetTransform(D3DTS_PROJECTION, mat);


    case Frender of
      1:begin
          res:=IDevice.SetStreamSource(0, VB, 0, SizeOf(TCustomVertex));
          Memo1.Lines.Add( 'SetStreamSource = '+Istr(res));

          res:=IDevice.SetFVF(D3DFVF_CUSTOMVERTEX);
          Memo1.Lines.Add( 'SetFVF = '+Istr(res));
        end;
      2:begin
          res:=IDevice.SetStreamSource(0, VB, 0, SizeOf(TCustomVertex2));
          Memo1.Lines.Add( 'SetStreamSource = '+Istr(res));

          res:=IDevice.SetFVF(D3DFVF_CUSTOMVERTEX2);
          Memo1.Lines.Add( 'SetFVF = '+Istr(res));
        end;

      3:begin
         (*
           GaussTexture contient alpha décroissant de 1 à 0 , soit exp(-x²)

           GratingTexture contient 0.5 + 0.5*sin(x)

           Op 0 crée 0.5 + 0.5*exp(-x²)*sin(x)

           Op 1 multiplie par A
           Op 2 ajoute B

           Au final , on a A/2+B +A/2*exp(-x²)*sin(x)

           A/2 est l'amplitude de la sinusoïde
           A/2+B doit être égal au backGround,  donc B = BackGround -A/2


         *)
          with Idevice do
          begin
            SetTexture(0,GaussTexture);
            SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_SELECTARG1);
            SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
            SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

            SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1);
            SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
            SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

            SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
            SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
            SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
            SetSamplerState(0, D3DSAMP_ADDRESSU,  D3DTADDRESS_BORDER );
            SetSamplerState(0, D3DSAMP_ADDRESSV,  D3DTADDRESS_BORDER );
            SetSamplerState(0, D3DSAMP_BORDERCOLOR, D3Dcolor_rgba(0,0,0,0)  );


            SetTexture(1,GratingTexture);
            SetTextureStageState(1, D3DTSS_CONSTANT, D3Dcolor_rgba(0,128,0,255) );
            SetTextureStageState(1, D3DTSS_COLOROP,   D3DTOP_BLENDCURRENTALPHA);
            SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
            SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CONSTANT);

            SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
            SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
            SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
            SetSamplerState(1, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
            SetSamplerState(1, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );


            Contrast:=0.8;

            Ag:=2*BKcol/255*Contrast;
            Bg:=BKcol/255-Ag/2;

            SetSamplerState(2, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
            SetSamplerState(2, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
            SetSamplerState(2, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

            SetTextureStageState(2, D3DTSS_CONSTANT, D3Dcolor_rgba(0,round(Ag*255),0,255) );
            SetTextureStageState(2, D3DTSS_COLOROP,   D3DTOP_MODULATE);
            SetTextureStageState(2, D3DTSS_COLORARG1, D3DTA_CURRENT);
            SetTextureStageState(2, D3DTSS_COLORARG2, D3DTA_CONSTANT);

            SetSamplerState(3, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
            SetSamplerState(3, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
            SetSamplerState(3, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

            SetTextureStageState(3, D3DTSS_CONSTANT, D3Dcolor_rgba(0,round(Bg*255),0,255) );
            SetTextureStageState(3, D3DTSS_COLOROP,   D3DTOP_ADD);
            SetTextureStageState(3, D3DTSS_COLORARG1, D3DTA_CURRENT);
            SetTextureStageState(3, D3DTSS_COLORARG2, D3DTA_CONSTANT);
          end;
          (*
          Idevice.SetTexture(0,GaussTexture);

          Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_SELECTARG1);
          Idevice.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
          Idevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

          Idevice.SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1);
          Idevice.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
          Idevice.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

          Idevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
          Idevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
          Idevice.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
          Idevice.SetSamplerState(0, D3DSAMP_ADDRESSU,  D3DTADDRESS_BORDER );
          Idevice.SetSamplerState(0, D3DSAMP_ADDRESSV,  D3DTADDRESS_BORDER );

          Idevice.SetTexture(1,GratingTexture);
          Idevice.SetTextureStageState(1, D3DTSS_CONSTANT, D3Dcolor_rgba(0,128,0,255) );
          //Idevice.SetTextureStageState(1, D3DTSS_CONSTANT, D3Dcolor_rgba(0,255,0,255) );

          Idevice.SetTextureStageState(1, D3DTSS_COLOROP,   D3DTOP_MODULATE);
          Idevice.SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
          Idevice.SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);

          Idevice.SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
          Idevice.SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
          Idevice.SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
          Idevice.SetSamplerState(1, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
          Idevice.SetSamplerState(1, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );

          Idevice.SetTextureStageState(2, D3DTSS_COLOROP,   D3DTOP_DISABLE);

{
          Idevice.SetTextureStageState(2, D3DTSS_CONSTANT, D3Dcolor_rgba(0,128,0,255) );
          Idevice.SetTextureStageState(2, D3DTSS_COLOROP,   D3DTOP_MODULATE);
          Idevice.SetTextureStageState(2, D3DTSS_COLORARG1, D3DTA_CURRENT);
          Idevice.SetTextureStageState(2, D3DTSS_COLORARG2, D3DTA_CONSTANT);

          Idevice.SetTextureStageState(3, D3DTSS_CONSTANT, D3Dcolor_rgba(0,36,0,255) );
          Idevice.SetTextureStageState(3, D3DTSS_COLOROP,   D3DTOP_ADD);
          Idevice.SetTextureStageState(3, D3DTSS_COLORARG1, D3DTA_CURRENT);
          Idevice.SetTextureStageState(3, D3DTSS_COLORARG2, D3DTA_CONSTANT);
}
          *)
          res:=IDevice.SetStreamSource(0, VB, 0, SizeOf(TCustomVertex3));
          Memo1.Lines.Add( 'SetStreamSource = '+Istr(res));

          res:=IDevice.SetFVF(D3DFVF_CUSTOMVERTEX3);
          Memo1.Lines.Add( 'SetFVF = '+Istr(res));
        end;
    end;

    res:=IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, NV2-2 );
    Memo1.Lines.Add( 'DrawPrimitive = '+Istr(res));

    Idevice.SetTexture(0,nil);
    Idevice.EndScene;
  end;

  // Present the backbuffer contents to the display
  Idevice.Present(nil, nil, 0, nil);
end;



procedure TMainForm.BcreateClick(Sender: TObject);
begin
  initD3D;


end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  CleanUp;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  i:integer;
  tt:integer;
begin

  Frender:=Tbutton(sender).Tag;

  InitVB;

  delay(20);
  tt:=GetTickCount;
  if Fanimate then
    for i:=1 to 600 do  render
  else render;

  tt:=GetTickCount-tt;
  Memo1.Lines.Add( 'Render Time = '+Istr(tt));
end;

procedure TMainForm.DXformResize(Sender: TObject);
begin
  if WinMode then
  begin
    Swidth:=DXform.width;
    Sheight:=DXform.height;
    if Idevice<>nil then Idevice.Reset(PresentParam);

  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DXform:=Tform.Create(self);
  DXform.Width:=800;
  DXform.Height:=600;
  DXform.Left:=100;
  DXform.Top:=100;

  DXform.OnResize:=DXformResize;

  cbAnimate.setVar(Fanimate);
  cbAnimate.UpdateVarOnToggle:=true;
end;


procedure TMainForm.Button4Click(Sender: TObject);
var
  hr:hresult;
  tt:integer;
begin
  if (Idevice = nil) then Exit;

  hr:=Idevice.TestCooperativeLevel;
  if FAILED(hr) then
  begin
    Memo1.Lines.Add( 'Render Failed = '+Istr(hr));

    VB:=nil;

    tt:=0;
    repeat
      delay(100);
      hr:= Idevice.Reset(PresentParam);
      tt:=tt+100;
      if tt>2000 then break;
    until Succeeded(hr) ;
  end;
  Memo1.Lines.Add( 'Render = '+Bstr(hr=0));

  Idevice.Clear(0, nil, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0,64,0), 1.0, 0);
  Idevice.Present(nil, nil, 0, nil);
end;

end.