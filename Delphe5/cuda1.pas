unit Cuda1;

interface

uses windows,
     {$IFDEF DX11}  {$ELSE} DXTypes, Direct3D9G, D3DX9G, {$ENDIF}
     util1;

Const
  Cuda2Dll = 'CudaPstw1.dll';     // CudaPstw1 est maintenant compilé directement dans Dexe5bis\Cuda



{  InitCuda et ReleaseCuda sont appelées dans DXscr9
   InitCuda teste la présence d'une carte Nvidia

   RegisterResources et UnregisterResources devraient être appelées dans InitMvt et DoneMvt

}
type
  TransformClass = pointer;
  TimageListClass = pointer;
var

  InitCUDA: function( g: IDirect3DDevice9 ): HRESULT; cdecl;
  ReleaseCUDA: function:HRESULT; cdecl;

  RegisterTexture: function (p: IDirect3DTexture9; w,h: integer ): HRESULT; cdecl;
  UnregisterTextures: function : HRESULT; cdecl;
  FillGrating: procedure; cdecl;

  RegisterTransformSurface: function(p: IDirect3DTexture9; var cudaResource:pointer): integer; cdecl;
  UnRegisterTransformSurface: function(cudaResource:pointer):integer; cdecl;

  MapResources: function( ppResources: Pointer; n:integer): integer; cdecl;
  UnMapResources: function( ppResources: Pointer; n: integer):integer; cdecl;

  InitTransform: function(Src,dest: pointer): TransformClass; cdecl;
  DoneTransform: function( tf:TransformClass):integer; cdecl;

  TransformCartToPol1: function( tf:TransformClass; BK:integer): integer; cdecl;
  WaveTransform1: function(tf: TransformClass; Amp, a, b, tau:single; x0,y0, yref, RgbMask: integer;btheta:longBool): integer;cdecl;

  DNpstw: function(Vsource:Psingle; Npoint:integer; Vt:Plongint; Ncode:integer; Vcode: Plongint; Ncycle:integer; Pstw:Psingle ; Npstw:integer):integer;cdecl;
  GetDeviceCount: function(var n:integer):integer;cdecl;
  TestAverage: function(Vsrc: Psingle; Vdest:Psingle; Npoint:integer; count:integer): integer;cdecl;

  InitSrcRect: procedure(tf: TransformClass; x, y, w, h: integer);cdecl;
  InitDestRect: procedure(tf: TransformClass; x, y, w, h: integer);cdecl;
  InitDumRect: procedure(tf: TransformClass);cdecl;
  InitCenters: procedure(tf: TransformClass; xcSrc, ycSrc, xcDest,ycDest:single);cdecl;

  BltSurface: function( tf: TransformClass;
                        x0,y0,theta, ax, ay: single;
                        AlphaMode, LumMode: integer;
                        Alpha, Lum: PtabLong;
                        Mask: integer):integer;cdecl;

  DisplaySurface: function( Resource1:pointer; Nx1, Ny1:integer;
                            Resource2:pointer; Nx2, Ny2:integer;
                            x0,y0,theta, ax, ay: single;
                            xcSrc, ycSrc, xcDest,ycDest:single;
                            AlphaMode, LumMode: integer;
                            Alpha, Lum: PtabLong;
                            Mask: integer):integer;cdecl;


  SmoothSurface: function( tf: TransformClass; Nlum,Nalpha,x0,y0,dmax1,dmax2:integer;ref: Plongint):integer;cdecl;
  TexPixSum: function(tf: TransformClass; comp:integer; ref: integer): integer;cdecl;

  SetStream0: function(tf: TransformClass; stream: pointer): integer;cdecl;

  BuildRings1: function(tf:TransformClass; AmpBase, Amp, a, b, tau: single; x0,y0,RgbMask,mode: integer): integer;cdecl;

  CreateCudaStream: function(): pointer;cdecl;
  FreeCudaStream:   procedure(stream:pointer);cdecl;

 CreateImageList: function ( w,h: integer): TimageListClass;cdecl;              // Crée une liste d'images
 FreeImageList: function ( p: TimageListClass ):integer;cdecl;                  // Détruit la liste
 ImageList_Add: function ( p: TimageListClass; image1:pointer ):integer;cdecl;  // Ajoute une image à la liste
 ImageList_UpdateTexture: function ( p: TimageListClass; num: integer; cudaResource: pointer ):integer;cdecl; // Fait passer une image de la liste dans une texture

 ImageList_setScaling: procedure( p: TimageListClass; a1, b1: single);cdecl;
 ImageList_setMask: procedure( p: TimageListClass; mask: integer);cdecl;



function InitCudaLib1: boolean;
function InitCudaLib2: boolean;

procedure TestImageList;

implementation

uses stmdef;

var
  hh1:intG;

function InitCudaLib1: boolean;
var
  cuda1dll: AnsiString;
begin
//  result:=FALSE;
//  exit;

  case FcudaVersion of
    1: Cuda1dll:='Cuda1.dll';
    2: Cuda1dll:='Cuda65.dll';
    3: Cuda1dll:='Cuda80.dll';
  end;

  result:=true;
  if hh1<>0 then exit;

  hh1:=GloadLibrary( Appdir+'Cuda\'+Cuda1dll );
  result:=(hh1<>0);
  if not result then exit;

  InitCUDA:= getProc(hh1,'InitCUDA');
  ReleaseCUDA:= getProc(hh1,'ReleaseCUDA');
  RegisterTexture:= getProc(hh1,'RegisterTexture');
  UnRegisterTextures:= getProc(hh1,'UnRegisterTextures');
  FillGrating:= getProc(hh1,'FillGrating');

  RegisterTransformSurface:= getProc(hh1,'RegisterTransformSurface');
  UnRegisterTransformSurface:= getProc(hh1,'UnRegisterTransformSurface');

  InitTransform:= getProc(hh1,'InitTransform');
  DoneTransform:= getProc(hh1,'DoneTransform');
  TransformCartToPol1:=   getProc(hh1,'TransformCartToPol1');
  WaveTransform1:= getProc(hh1,'WaveTransform1');

  MapResources:= getProc(hh1,'MapResources');
  UnMapResources:= getProc(hh1,'UnMapResources');
  BltSurface:=getProc(hh1,'BltSurface');
  DisplaySurface:=getProc(hh1,'DisplaySurface');
  InitSrcRect:= getProc(hh1,'InitSrcRect');
  InitDestRect:= getProc(hh1,'InitDestRect');
  InitDumRect:= getProc(hh1,'InitDumRect');
  InitCenters:= getProc(hh1,'InitCenters');

  SmoothSurface:=getProc(hh1,'SmoothSurface');
  TexPixSum:=getProc(hh1,'PixSum');

  CreateImageList:=          getProc(hh1, 'CreateImageList');
  FreeImageList:=            getProc(hh1, 'FreeImageList');
  ImageList_Add:=            getProc(hh1, 'ImageList_Add');
  ImageList_UpdateTexture:=  getProc(hh1, 'ImageList_UpdateTexture');
  ImageList_setScaling:=     getProc(hh1, 'ImageList_setScaling');
  ImageList_setMask:=        getProc(hh1, 'ImageList_setMask');

  SetStream0:=               getProc(hh1, 'SetStream0');
  CreateCudaStream:=         getProc(hh1, 'CreateCudaStream');
  FreeCudaStream:=           getProc(hh1, 'FreeCudaStream');

  BuildRings1:=              getProc(hh1,'BuildRings1');
end;

var
  hh2:intG;

function InitCudaLib2: boolean;
const
  CudaDeviceOK:boolean=false;
  Tested:boolean=false;
var
  res,nb:integer;

begin
  if tested then
  begin
    result:= (hh2<>0) and CudaDeviceOK;
    exit;
  end;

  tested:=true;

  hh2:=GloadLibrary(Appdir+'Cuda\'+ Cuda2dll );
  result:=(hh2<>0);
  if not result then exit;

  DNpstw:= getProc(hh2,'DNpstw');
  GetDeviceCount:= getProc(hh2,'GetDeviceCount');
  TestAverage:= getProc(hh2, 'TestAverage');

  

  res:= GetDeviceCount(nb);
  CudaDeviceOK:=(res=0) and (nb>0);
  result:=CudaDeviceOK;
end;


procedure TestImageList;
var
  p:pointer;
  i:integer;
  tab: array[1..10000] of byte;
begin
  p:= CreateImageList(100,100);
  for i:=1 to 10 do ImageList_add(p,@tab);
  FreeImageList(p);


end;

end.
