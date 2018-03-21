unit DXscr9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1,DXTypes, Direct3D9G, D3DX9G, BMex1,debug0,
  cuda1,
  IppDefs17, Ipps17,
  reducstim1;

type
  TblendConfig= (BC_Sprite, BC_sprite2, BC_sprite3, BC_Mask, BC_final,BC_AlphaZero);

  TDXscreen9 = class(TForm)
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
    WinMode: boolean;
    Finitializing: boolean;
  public
    { Déclarations publiques }

    IDX9: IDirect3D9ex;
    Idevice: IDirect3DDevice9ex;

    renderSurface: Idirect3Dsurface9;
    RenderSurfaceOrg: Idirect3Dsurface9;
    PresentParam: TD3DPresentParameters;
    DisplayModeEx: TD3DDisplayModeEx;
    MultiSampleType: TD3DMultiSampleType;
    MultiSampleQuality: integer;

    renderResource: pointer;
    cudaUsed: boolean;

    Nscreen: integer;
    screenId: TstringList;
    ScreenMode: array[0..9] of TstringList;

    Initialized: boolean;
    PaintProc: procedure of object;
    registerCount:integer;

    FdeviceLost: boolean;
    FlipOK: boolean;

    function InitDX9: boolean;
    function InitDevice(windowMode: boolean; AdapterId:AnsiString;width1,height1,Rate1:integer): boolean;
    procedure ReInitWindowDevice;
    procedure Flip(const w: boolean=false);
    function candraw: boolean;

    function TestDevice: boolean;
    procedure FreeResources;
    procedure Finalize;
    procedure FillBK(col:integer);

    function SetGammaRamp(GammaRamp: TD3DgammaRamp): boolean;
    procedure SetDefRenderStates;

    function getbm(bm: TbitmapEx; alphaOnly:boolean): boolean;
    function getMatrix(mat1: pointer; alphaOnly:boolean): boolean;

    //procedure getMaskMat(mask: TArrayOfSingle; xp,yp: TarrayOfInteger; mat:PtabSingle;Nx,Ny: integer);
    procedure getMaskMat(mask:PtabSingle;Ni,Nj:integer; xp,yp: TarrayOfInteger; mat:PtabSingle;Nx,Ny: integer);
    procedure getPixMat(x1,y1,x2,y2:integer; mat:PtabSingle);

    procedure SetBlendConfig(BC: TblendConfig);
    procedure CheckRenderSurface;

    procedure registerCuda;
    procedure unregisterCuda;

    procedure messageRef(st:string);
  end;


implementation

uses stmdef,stmObj, syspal32, stmTransform1, stmMat1;

{$R *.dfm}


{ TDXscreenB9 }

function TDXscreen9.InitDX9: boolean;
var
  i, N, Adapter: integer;
  st:string;
  screenId0: TD3DADAPTER_IDENTIFIER9;
  displayMode: TD3DDISPLAYMODE;
  res: integer;
begin

  result:= initDirect3D9lib and initD3DX9lib;

  if not result then exit;

  res:= Direct3DCreate9ex(D3D_SDK_VERSION, IDX9);

  if (res<>0) or (IDX9 = nil) then Exit;

  Nscreen:=IDX9.GetAdapterCount;

  if not assigned(ScreenId) then ScreenId:=TstringList.create;
  for i:=0 to Nscreen-1 do
  begin
    IDX9.GetAdapterIdentifier(i,0,screenId0);
    st:= tabToString(screenId0.DeviceName,512) +'  '+ tabToString(screenId0.Description,512);
    ScreenId.Add(st);
  end;

  for Adapter:=0 to Nscreen-1 do
  begin
    if not assigned(ScreenMode[adapter]) then ScreenMode[adapter]:=TstringList.create;
    N:=IDX9.GetAdapterModeCount(Adapter,D3DFMT_X8R8G8B8 );
    for i:=0 to N-1 do
    begin
      IDX9.EnumAdapterModes(Adapter, D3DFMT_X8R8G8B8, i, displayMode);
      with displayMode do st:=Istr(Width)+'/'+Istr(Height)+'/'+Istr(refreshRate);
      ScreenMode[Adapter].Add(st);
    end;
  end;

end;

procedure TDXscreen9.CheckRenderSurface;
var
  res:integer;
begin
  if Idevice=nil then exit;

  if (renderSurface=nil) and (TransformList.UseRenderSurface) then
  begin
    Idevice.CreateRenderTarget(PresentParam.BackBufferWidth,PresentParam.BackBufferHeight,D3DFMT_A8R8G8B8,
                               {PresentParam.MultiSampleType} D3DMULTISAMPLE_NONE, {PresentParam.MultiSampleQuality} 0, false, renderSurface, Nil);

    Idevice.getRenderTarget(0,renderSurfaceOrg);   // incrémente le compteur de Idevice
    Idevice.SetRenderTarget(0,renderSurface);
  end
  else
  if (renderSurface<>nil) and not (TransformList.UseRenderSurface) then
  begin
    rendersurface:=nil;

    Idevice.SetRenderTarget(0,renderSurfaceOrg);
    renderSurfaceOrg:=nil;  // indispensable pour décrémenter le compteur de Idevice
  end;



end;

function TDXscreen9.InitDevice(windowMode: boolean;AdapterId:AnsiString;width1,height1,Rate1:integer): boolean;
var
  i, N, q: integer;
  st:string;
  res: integer;
  Adapter: integer;
  Pdisp:pointer;

  DispMode0: TD3DDisplayMode;
  Caps: TD3DCAPS9;
begin

  Finitializing:=true;
  result:=false;
  if IDX9=nil then exit;

  Idevice:=nil;

  Adapter:=ScreenId.IndexOf(AdapterId);
  if (Adapter<0) or (Adapter>=Nscreen) then Adapter:=Nscreen-1;
  if Nscreen<2 then WindowMode:=true;

  with displayModeEx do
  begin
    size:= sizeof(displayModeEx);
    Width:= width1;
    Height:= height1;
    RefreshRate:= rate1;
    Format:= D3DFMT_A8R8G8B8;
    ScanLineOrdering:= D3DSCANLINEORDERING_INVALID_0;
  end;

  if not WindowMode then  // Full Screen mode
  begin
    hide;

    st:=Istr(Width1)+'/'+Istr(Height1)+'/'+Istr(Rate1);
    if not( (Adapter>=0) and (Adapter<Nscreen) and (ScreenMode[Adapter].IndexOf(st)>=0)) then exit;

    FillChar(PresentParam, SizeOf(PresentParam), 0);

    PresentParam.BackBufferWidth:=width1;
    PresentParam.BackBufferHeight:=height1;
    PresentParam.Windowed := false;
    PresentParam.SwapEffect :=  {D3DSWAPEFFECT_FLIPEX;}  D3DSWAPEFFECT_DISCARD;
    PresentParam.BackBufferFormat := D3DFMT_A8R8G8B8;

    PresentParam.BackBufferCount:=30;   // 30 est la valeur maximale  DirectX9ex . 4 semble être le maximum Nvidia

    PresentParam.hDeviceWindow:= self.Handle;
    PresentParam.FullScreen_RefreshRateInHz:=rate1;

    PresentParam.EnableAutoDepthStencil := True;
    PresentParam.AutoDepthStencilFormat := D3DFMT_D16;
    PresentParam.PresentationInterval:=1;

    Pdisp:= @displayModeEx;
    //PresentParam.Flags:= ;
  end
  else
  begin              // Window mode
    //IDX9.GetAdapterDisplayMode(0, @DisplayMode);
    with screen.Monitors[Adapter] do
    begin
      self.Top:=top+100;
      self.Left:=left+100;
      if width1>width-200 then width1:=width-200;
      if height1>height-200 then height1:=height-200;

      self.Clientwidth:=width1;
      self.Clientheight:=height1;
    end;
    show;

    FillChar(PresentParam, SizeOf(PresentParam), 0);
    PresentParam.Windowed := true;
    PresentParam.SwapEffect := D3DSWAPEFFECT_DISCARD;
    PresentParam.EnableAutoDepthStencil := True;
    PresentParam.AutoDepthStencilFormat := D3DFMT_D16;

    Pdisp:=nil;
    PresentParam.BackBufferFormat:= DisplayModeEx.Format;
    PresentParam.BackBufferCount:=1;
    PresentParam.BackBufferWidth:= width1;
    PresentParam.BackBufferHeight:= height1;
    PresentParam.hDeviceWindow:= self.Handle;

  end;

  MultiSampleType:= D3DMULTISAMPLE_NONE;
  MultiSampleQuality:= 0;

                          // incompatible avec FLIPEX
  for i:=2 to 16 do
  begin
    res:=IDX9.CheckDeviceMultiSampleType(adapter,D3DDEVTYPE_HAL, D3DFMT_A8R8G8B8, windowMode,  TD3DMultiSampleType(i), @q);
    if res=0 then
    begin
      MultiSampleType:=  TD3DMultiSampleType(i);
      MultiSampleQuality:= q-1;
    end;
  end;

  PresentParam.MultiSampleType := MultiSampleType;
  PresentParam.MultiSampleQuality := MultiSampleQuality;

  winMode:=WindowMode;


  Res:= IDX9.CreateDeviceEx(Adapter, D3DDEVTYPE_HAL, {self.handle} formStm.handle, D3DCREATE_HARDWARE_VERTEXPROCESSING, @PresentParam, Pdisp , Idevice);
  if res<>0 then messageCentral('CreateDeviceEx = '+Istr(res and $FFFF) );

  AddWarning('DXscreen :  CreateDevice ', res and $FFFF );
  if res=0 then SetDefRenderStates;

  if assigned(Idevice) then res:= Idevice.GetDeviceCaps(Caps);


  DX9end;
  Result:= (res=0);
  Initialized:= (res=0);

  if (res=0) and initCudaLib1 then
  begin
    ReleaseCuda;
    res:=InitCuda( Idevice);         // il est indispensable d'appeler InitCuda
    AddWarning('DXscr9  :  InitCuda ',res);
    CudaUsed:= (res=0);

    CudaStream0:= CreateCudaStream();
  end
  else
  AddWarning('DXscr9  :  initCudaLib=false',1);

  CheckRenderSurface;
  Finitializing:=false;
end;

procedure TDXscreen9.Flip(const w: boolean);
var
  hh: Hresult;
begin
  {           Bad method
  repeat
    if Idevice<>nil
      then hh:= Idevice.PresentEx(nil, nil, 0, nil, D3DPRESENT_DONOTWAIT) // D3DPRESENT_FORCEIMMEDIATE donne un écran noir
      else hh:=0;
  until hh<>D3DERR_WASSTILLDRAWING;
  }
  if Idevice<>nil
    then hh:= Idevice.PresentEx(nil, nil, 0, nil, 0)
    else hh:=0;

  FlipOK:= (hh=0);
  //AddWarning('Present ',hh and $FFFF);


  if hh = D3DERR_DEVICENOTRESET then
  begin
    FreeResources;
    ReleaseCuda;
    FdeviceLost:=true;
  end;
end;

function TDXscreen9.TestDevice: boolean;
var
  hr: hresult;
  tt:integer;
begin

  if not FlagActivate then
  begin
    result:=false;
    exit;
  end;

  if FlipOK then
  begin
    result:=true;
    exit;
  end;

  result:=false;
  if Idevice=nil then exit;

  hr:= Idevice.CheckDeviceState(self.handle);
  AddWarning('CheckDeviceState ',hr and $FFFF);

  if hr = D3DERR_DEVICENOTRESET then
  begin
    hr :=  IDevice.ResetEx(PresentParam,DisplayModeEx);  // ça n'arrive jamais ! Heureusement

    if hr=0 then
    begin
      initCuda(Idevice);
      //RestoreContextResources();
      FdeviceLost:=false;
    end;
    result:= (hr=0);
  end
  else result:=true;

end;


procedure TDXscreen9.FreeResources;
var
  i,res:integer;
begin
  for i:=0 to HKpaint.count-1 do
    with TypeUO(HKpaint.items[i]) do freeBM;

end;


procedure TDXscreen9.ReInitWindowDevice;
var
  res: integer;
begin
  if Finitializing then exit;
  if IDX9=nil then exit;
  if not WinMode then exit;


  FillChar(PresentParam, SizeOf(PresentParam), 0);
  PresentParam.Windowed := true;
  PresentParam.SwapEffect := D3DSWAPEFFECT_DISCARD;
  PresentParam.BackBufferFormat := D3DFMT_A8R8G8B8;

  FreeMainResources;

  res:=Idevice.Reset(PresentParam);
  //if res=0 then
  begin
    SetDefRenderStates;
    SSwidth:=clientWidth;
    SSheight:=clientHeight;
    CalculateScreenConst;
  end;
  //Initialized:=(res=0);
  DX9end;

end;


procedure TDXscreen9.SetDefRenderStates;
begin
  IDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE{ D3DCULL_CW} );   // pour dense noise, il faut D3DCULL_CW
                                                                        // mais pour ???, il faut  D3DCULL_NONE
  IDevice.SetRenderState(D3DRS_ZENABLE, iFalse);             // True pour tester
  IDevice.SetRenderState(D3DRS_LIGHTING, iFalse);

end;


function TDXscreen9.candraw: boolean;
begin
  result:= (IDevice<>nil);
end;



// Permet de controler le compteur de références de Idevice
procedure TDXscreen9.messageRef(st:string);
var
  n:integer;
begin
  if Idevice<>nil then
  begin
    Idevice._AddRef;
    n:=Idevice._Release;
  end
  else n:=0;
  Affdebug(st+' Ref= '+Istr(n),132 );
end;

procedure TDXscreen9.Finalize;
var
  n:integer;
begin
  FreeResources;
  FreeMainResources;

  if renderSurfaceOrg<>nil then Idevice.SetRenderTarget(0,renderSurfaceOrg);
  renderSurfaceOrg:=nil; // indispensable
  renderSurface:=nil;

  FreeCudaStream(CudaStream0);
  releaseCuda;

  // il faut obtenir cntref=1 à ce stade
  Idevice:=nil;
  initialized:=false;
end;



procedure TDXscreen9.FillBK(col: integer);
begin
  if assigned(Idevice) then Idevice.Clear(0, nil, D3DCLEAR_TARGET, DevColBK, 0.0, 0);
end;




function TDXscreen9.SetGammaRamp(GammaRamp: TD3DgammaRamp): boolean;
begin
  if Idevice<>nil then Idevice.SetGammaRamp(0,D3DSGR_NO_CALIBRATION, GammaRamp );
  result:=true;
end;

procedure TDXscreen9.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  ;
end;

function TDXscreen9.getbm(bm: TbitmapEx; alphaOnly:boolean): boolean;
var
  DestSurface: Idirect3DSurface9;
  xRect: D3DLOCKED_RECT;
  i,j,res:integer;
  dc:hdc;
  p1: PtabLongWord;
  p2: PtabOctet;
  SSW,SSh,w,h:integer;
  kcol:integer;
begin
  // On suppose que bm est correctement paramètré.
  SSW:= presentParam.BackBufferWidth;
  SSH:= presentParam.BackBufferHeight;

  w:=bm.width;
  h:=bm.height;

  if AlphaOnly then kcol:=24  // malheureusement, on lit toujours 0 dans la composante alpha !
  else
  case sysPaletteNumber of
    1,4,5,7: kcol:= 0;
    2,6: kcol:= 8;
    3: kcol:= 16;
  end;

  result:= false;
  if IDevice.CreateOffscreenPlainSurface(SSW, SSH, D3DFMT_A8R8G8B8, D3DPOOL_SCRATCH, DestSurface, Nil)<>0 then exit ;
  if Idevice.GetFrontBufferData(0, DestSurface) <>0 then exit;

  if DestSurface.LockRect(xRect,Nil, D3DLOCK_READONLY )=0 then
    with xrect do
    for j:=0 to h-1 do
    begin
      p1:=pointer(intG(pbits)+pitch*(j+SSH div 2- h div 2));
      p2:=bm.ScanLine[j];
      for i:=0 to w-1 do p2^[i]:=(p1^[i+SSW div 2- w div 2] shr kcol) and $FF;
    end
  else exit;

  DestSurface.UnlockRect;
  result:=true;

end;

function TDXscreen9.getMatrix(mat1:pointer; alphaOnly:boolean): boolean;
var
  DestSurface: Idirect3DSurface9;
  xRect: D3DLOCKED_RECT;
  i,j,res:integer;
  dc:hdc;
  p1: PtabLongWord;
  p2: PtabOctet;
  SSW,SSh,w,h:integer;
  kcol:integer;
  mat:Tmatrix;
  i1,j1:integer;
begin
  // On suppose que mat est correctement dimensionnée.
  SSW:= presentParam.BackBufferWidth;
  SSH:= presentParam.BackBufferHeight;

  mat:=mat1;
  w:=mat.Icount;
  h:=mat.Jcount;
  i1:=mat.Istart;
  j1:=mat.Jstart;

  if AlphaOnly then kcol:=24  // malheureusement, on lit toujours 0 dans la composante alpha !
  else
  case sysPaletteNumber of
    1,4,5,7: kcol:= 0;
    2,6: kcol:= 8;
    3: kcol:= 16;
  end;

  result:= false;
  if IDevice.CreateOffscreenPlainSurface(SSW, SSH, D3DFMT_A8R8G8B8, D3DPOOL_SCRATCH, DestSurface, Nil)<>0 then exit ;
  if Idevice.GetFrontBufferData(0, DestSurface) <>0 then exit;

  if DestSurface.LockRect(xRect,Nil, D3DLOCK_READONLY )=0 then
    with xrect do
    for j:=0 to h-1 do
    begin
      p1:=pointer(intG(pbits)+pitch*(j+SSH div 2- h div 2));

      for i:=0 to w-1 do mat[i1+i,j1+j]:=(p1^[i+SSW div 2- w div 2] shr kcol) and $FF;
    end
  else exit;

  DestSurface.UnlockRect;
  result:=true;

end;



procedure TDXscreen9.FormPaint(Sender: TObject);
begin
  if winMode and initialized and assigned(paintProc) then PaintProc;
end;

procedure TDXscreen9.FormResize(Sender: TObject);
begin
  reinitWindowDevice;
end;


procedure TDXscreen9.getMaskMat(mask:PtabSingle;Ni,Nj:integer; xp,yp: TarrayOfInteger; mat:PtabSingle;Nx,Ny: integer);
type
  Tquad=record
          b,g,r,a:byte;
        end;
  TtabQuad=array[1..1] of Tquad;
  PtabQuad= ^TtabQuad;

var
  i,j,k:integer;
  DestSurface: Idirect3DSurface9;
  xRect: D3DLOCKED_RECT;
  p1: Ptabquad;
  tbS: TarrayOfSingle;
  Lmask: integer;
  MaskSum: single;


begin
  if DXscreen.IDevice.CreateOffscreenPlainSurface(SSWidth, SSHeight, D3DFMT_A8R8G8B8, D3DPOOL_SCRATCH, DestSurface, Nil)<>0 then exit ;
  if DXscreen.Idevice.GetFrontBufferData(0, DestSurface) <>0 then exit;

  if DestSurface.LockRect(xRect,Nil, D3DLOCK_READONLY )=0 then
  begin
    setLength(tbS,SSwidth*SSheight);

    k:=0;
    with xrect do
    for j:=0 to SSheight-1 do              // on copie le contenu de l'écran ligne par ligne dans un tableau de singles tbS
    begin
      p1:=pointer(intG(pbits)+pitch*j);
      for i:=0 to SSwidth-1 do
      begin
        tbS[k]:=(p1^[i].g);
        inc(k);
      end;
    end;

    DestSurface.UnlockRect;
  end
  else exit;

  IPPStest;
  getMask(mask, Ni,Nj, xp, yp, mat ,@tbS[0],Nx ,Ny ,SSwidth);

  IppsSum_32f(Psingle(mask), Ni*Nj, @MaskSum,ippAlgHintNone);
  if MaskSum<>0 then   IppsMulC_32f_I(1/MaskSum, Psingle(mat), Nx*Ny);
  IPPSend;
end;

procedure TDXscreen9.getPixMat(x1,y1,x2,y2:integer; mat:PtabSingle);
type
  Tquad=record
          b,g,r,a:byte;
        end;
  TtabQuad=array[1..1] of Tquad;
  PtabQuad= ^TtabQuad;

var
  i,j,k:integer;
  DestSurface: Idirect3DSurface9;
  xRect: D3DLOCKED_RECT;
  p1: Ptabquad;
  Ny: integer;

begin
  if DXscreen.IDevice.CreateOffscreenPlainSurface(SSWidth, SSHeight, D3DFMT_A8R8G8B8, D3DPOOL_SCRATCH, DestSurface, Nil)<>0 then exit ;
  if DXscreen.Idevice.GetFrontBufferData(0, DestSurface) <>0 then exit;

  Ny:= y2-y1+1;

  if DestSurface.LockRect(xRect,Nil, D3DLOCK_READONLY )=0 then
  begin
    k:=0;
    with xrect do
    for j:=y1 to y2 do
    begin
      p1:=pointer(intG(pbits)+pitch*j);
      for i:= x1 to x2 do
      begin
        mat[(i-x1)*Ny+j-y1 ]:= p1^[i].g;
        inc(k);
      end;
    end;

    DestSurface.UnlockRect;
  end
  else exit;

end;


procedure TDXscreen9.SetBlendConfig(BC: TblendConfig);
begin
  case BC of
    BC_sprite:
      begin                                                             //  Si alpha source=1 , on copie la source
        Idevice.SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );          //  Si alpha source=0 , c'est le fond qui reste
                                                                        //  Si alpha intermédiaire, on mélange
        Idevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
        Idevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SrcALPHA);
        Idevice.SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_InvSrcALPHA );

        IDevice.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, itrue);   // alpha dest non modifié
        Idevice.SetRenderState(D3DRS_BLENDOPALPHA,    D3DBLENDOP_ADD);
        Idevice.SetRenderState(D3DRS_SRCBLENDALPHA,   D3DBLEND_ZERO);
        Idevice.SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ONE );
      end;

    BC_sprite2:
      begin                                                             //  Si alpha dest=1 , on copie la source
        Idevice.SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );          //  Si alpha dest=0 , c'est le fond qui reste
                                                                        //  Si alpha intermédiaire, on mélange
        Idevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
        Idevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DestALPHA);
        Idevice.SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_InvDestALPHA );

        IDevice.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, itrue);   // alpha dest = alpha source
        Idevice.SetRenderState(D3DRS_BLENDOPALPHA,    D3DBLENDOP_ADD);
        Idevice.SetRenderState(D3DRS_SRCBLENDALPHA,   D3DBLEND_ONE);
        Idevice.SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ZERO );
      end;

    BC_sprite3:
      begin                                                             //  Si alpha dest=1 , on copie la source
        Idevice.SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );          //  Si alpha dest=0 , c'est le fond qui reste
                                                                        //  Si alpha intermédiaire, on mélange
        Idevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
        Idevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DestALPHA);
        Idevice.SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_InvDestALPHA );

        IDevice.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, itrue);   // alpha dest ne change pas
        Idevice.SetRenderState(D3DRS_BLENDOPALPHA,    D3DBLENDOP_ADD);
        Idevice.SetRenderState(D3DRS_SRCBLENDALPHA,   D3DBLEND_ZERO);
        Idevice.SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ONE );
      end;

    BC_mask:
      begin                                                             //  Forcer alpha avec le alpha de la source
        Idevice.SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );

        Idevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);          // ne pas copier la source
        Idevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
        Idevice.SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_ONE );

        IDevice.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, iTrue);
        Idevice.SetRenderState(D3DRS_BLENDOPALPHA,    D3DBLENDOP_ADD);  // copier le alpha de la source
        Idevice.SetRenderState(D3DRS_SRCBLENDALPHA,   D3DBLEND_ONE);
        Idevice.SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ZERO );
      end;

    BC_final:
      begin                                                             //  Masquage
        Idevice.SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );          // la source est un grand rectangle de couleur BK

        Idevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);          // copier la source quand alphaDest=0
        Idevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_invDestAlpha);
        Idevice.SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_DestAlpha );

        IDevice.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, itrue);
        Idevice.SetRenderState(D3DRS_BLENDOPALPHA,    D3DBLENDOP_ADD);  // ne pas modifier le alpha de la destination
        Idevice.SetRenderState(D3DRS_SRCBLENDALPHA,   D3DBLEND_ZERO);
        Idevice.SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ONE );
      end;

    BC_AlphaZero:
      begin                                                             // Alpha =0;
        Idevice.SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );          // la source est un grand rectangle de couleur BK

        Idevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);          // Ne pas copier
        Idevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
        Idevice.SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_ONE );

        IDevice.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, iTrue);
        Idevice.SetRenderState(D3DRS_BLENDOPALPHA,    D3DBLENDOP_ADD);  // forcer alpha =0
        Idevice.SetRenderState(D3DRS_SRCBLENDALPHA,   D3DBLEND_ZERO);
        Idevice.SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ZERO );
      end;
  end;


end;


procedure TDXscreen9.registerCuda;
var
  res:integer;
begin
  if RenderResource=nil then
  begin
    res:=cuda1.RegisterTransformSurface(Idirect3DTexture9(renderSurface), RenderResource);
    if res<>0 then WarningList.add('RegisterTransformSurface ='+Istr(res));
  end;
(*
  if (registerCount=0) then
  begin
    res:=cuda1.RegisterTransformSurface(Idirect3DTexture9(renderSurface), RenderResource);
    AddWarning('DXscreen.RegisterCuda ',res);
  end;
  inc(RegisterCount);
*)
end;

procedure TDXscreen9.UnRegisterCuda;
var
  res:integer;
begin
  if RenderResource<>nil then
  begin
    res:=cuda1.UnRegisterTransformSurface(RenderResource);
    RenderResource:=nil;
    if res<>0 then WarningList.add('UnRegisterTransformSurface ='+Istr(res));
  end;
 (*
  dec(RegisterCount);
  if (registerCount=0) and (RenderResource<>nil) then
  begin
    res:=cuda1.UnRegisterTransformSurface(RenderResource);
    RenderResource:=nil;
    AddWarning('DXscreen.unRegisterCuda ', res);
  end;
  *)
end;


end.
