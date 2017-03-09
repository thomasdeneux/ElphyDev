unit StmMotionCloud1;

interface

uses windows, classes,graphics, sysutils,

     Direct3D9G, D3DX9G,

     util1,varconf1,Dgraphic, debug0,
     ippDefs,ipps,ippsOvr,
     stmdef,stmObj,stmMvtX1, stmObv0, defForm,
     Ncdef2,stmPG,
     syspal32,
     stmVSBM1,
     motionCloud2,
     stmMat1;



type
  TVSmotionCloud= class(TonOff)
                BMwidth, BMheight: integer;

                BMTexture: IDirect3DTexture9;

                FpolarMode: boolean; // si true, on appelle Cuda1.CartToPolar

                Acorrection: float;
                Bcorrection: float;

                mc: TmotionCloud;
                CudaFlag: boolean;
                CudaInit: boolean;

                procedure CreateBMtextures;

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure InitMvt; override;
                procedure InitObvis;override;

                procedure calculeMvt; override;
                procedure DoneMvt;override;

                procedure getFrame(mat: Tmatrix);
                procedure resetCuda;
              end;


procedure proTVSmotionCloud_create(var pu:typeUO);pascal;



procedure proTVSmotionCloud_PolarMode( w:boolean ;var pu:typeUO);pascal;
function fonctionTVSmotionCloud_PolarMode(var pu:typeUO): boolean;pascal;


procedure proTVSmotionCloud_Init(ss: float; Nx1,Ny1: integer; seed: longword;var pu:typeUO);pascal;

procedure proTVSmotionCloud_InstallGaborFilter( ss, r0, sr0, stheta0: float; var pu:typeUO);pascal;
procedure proTVSmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);pascal;

procedure proTVSmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);pascal;
procedure proTVSmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetGainOffset(a,b:float;var pu:typeUO);pascal;


procedure test;

implementation


var
 InitMC: function( p1:IDirect3DTexture9 ;  w,h:integer; Filter1: Psingle; a1, b1:single; Fpolar: longBool): integer;cdecl;
 DoneMC: function():integer;cdecl;
 UpdateMC: function():integer;cdecl;
 GetFrameK: function(p: Psingle):integer;cdecl;
 SetExpansionK: function (dx,x0,dy,y0:single): integer;cdecl;
 SetGainOffset: function (a1, b1: single): integer;cdecl;

 hh1: intG;

Const
  CudaMC1dll='CudaMC1.dll';

function InitCudaMC1: boolean;
begin
  result:=true;
  if hh1<>0 then exit;

  hh1:=GloadLibrary( Appdir+'Cuda\'+CudaMC1dll );
  result:=(hh1<>0);
  if not result then exit;

  InitMC:= getProc(hh1,'InitMC');
  DoneMC:= getProc(hh1,'DoneMC');
  UpdateMC:= getProc(hh1,'UpdateMC');
  GetFrameK:= getProc(hh1,'GetFrameK');
  SetExpansionK:= getProc(hh1,'SetExpansionK');
  SetGainOffset:= getProc(hh1,'SetGainOffset');
end;


{ TVSmotionCloud }

constructor TVSmotionCloud.create;
var
  i:integer;
begin
  inherited;

  BMwidth:= 256;
  BMHeight:= 256;

  Acorrection:= 1;
  Bcorrection:= 128;


  mc:= TmotionCloud.create;

  CudaFlag:= initCudaMC1;
  if not CudaFlag then sortieErreur('TVSmotionCloud : CudaMC1.dll not initialized');
end;

destructor TVSmotionCloud.destroy;
begin
  BMtexture:=nil;
  mc.Free;
  if CudaInit then DoneMC;

  inherited;
end;


class function TVSmotionCloud.STMClassName: AnsiString;
begin
  result:='VSmotionCloud';
end;


procedure TVSmotionCloud.InitMvt;
var
  i,res:integer;
begin
  if not CudaFlag then exit;
  inherited;

  CreateBMTextures;
  with mc do initMC(BMtexture,BMwidth,BMheight,@filter[0],a,b, FpolarMode);


  with mc do setExpansionK(DxF,x0F,DyF,y0F);
  setGainOffset(Acorrection,Bcorrection);
end;

procedure TVSmotionCloud.InitObvis;
begin
  TVSbitmap(obvis).ExternalTexture:=true;
  TVSbitmap(obvis).BMTexture:=BMtexture;
  TVSbitmap(obvis).BuildResource;

end;

procedure TVSmotionCloud.calculeMvt;
var
  tCycle,num:integer;
begin
  if not CudaFlag then exit;

  tCycle:=timeS mod dureeC;
  num:= timeS div dureeC;

  if num<CycleCount then
  begin
    if tcycle= 0 then UpdateMC;
  end
  else TVSbitmap(obvis).BMTexture:=nil;

end;

procedure TVSmotionCloud.DoneMvt;
var
  i:integer;
begin
  if not CudaFlag then exit;

  BMtexture:=nil;

  DoneMC;

  TVSbitmap(obvis).ExternalTexture:=false;

end;

procedure TVSmotionCloud.CreateBMtextures;
var
  res: integer;
begin
  res:=D3DXCreateTexture(DXscreen.Idevice,BMwidth,BMheight,0,0{D3DUSAGE_AUTOGENMIPMAP},D3DFMT_A8R8G8B8,D3DPOOL_DEFAULT,BMtexture);
end;


procedure TVSmotionCloud.getFrame(mat: Tmatrix);
var
  i,j:integer;
  Nx,Ny: integer;
  Xn:array of Single;
  res: integer;
begin
  if not CudaInit then
  begin
    with mc do
    begin
      res:= initMC(nil,BMwidth,BMheight,@filter[0],a,b, FpolarMode);
      res:= setExpansionK(DxF,x0F,DyF,y0F);
    end;
    CudaInit:=true;

    if res<>0 then messageCentral('GetFrame='+Istr(res));
  end;

  Nx:=BMwidth;
  Ny:= BMheight;

  setLength(Xn,Nx*Ny);
  getFrameK(@Xn[0]);

  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    mat[i,j]:=  Xn[i+Nx*j];

end;

procedure TVSmotionCloud.resetCuda;
begin
  if CudaInit then
  begin
    DoneMC;
    CudaInit:=false;
  end;
end;

{***************************** Méthodes STM de TVSmotionCloud ********************}

procedure proTVSmotionCloud_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSmotionCloud);
end;



procedure proTVSmotionCloud_PolarMode( w:boolean ;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSmotionCloud(pu).FpolarMode:=w;
end;

function fonctionTVSmotionCloud_PolarMode(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TVSmotionCloud(pu).FpolarMode;
end;



procedure proTVSmotionCloud_Init(ss: float; Nx1,Ny1: integer; seed: longword;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu).mc do
  begin
    init(ss, Nx1,Ny1, seed,false);
  end;

  with TVSmotionCloud(pu) do
  begin
    BMwidth:= Nx1;
    BMheight:=Ny1;
    resetCuda;
  end;
end;


procedure proTVSmotionCloud_InstallGaborFilter( ss, r0, sr0, stheta0: float; var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu).mc do
    InstallLogGaborFilter( ss, r0, sr0, stheta0);
  TVSmotionCloud(pu).resetCuda;
end;

procedure proTVSmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu).mc do
    InstallMaternFilter( ss, eta, alpha);
  TVSmotionCloud(pu).resetCuda;
end;

procedure proTVSmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TVSmotionCloud(pu).mc do
    installFilter(mat);
  TVSmotionCloud(pu).resetCuda;
end;

procedure proTVSmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TVSmotionCloud(pu) do getFrame(mat);
end;


procedure proTVSmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu).mc do
  begin
    DxF := DxF1;
    x0F := x0F1;
    DyF := DyF1;
    y0F := y0F1;
  end;
end;

procedure proTVSmotionCloud_SetGainOffset(a,b:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu) do
  begin
    Acorrection:= a;
    Bcorrection:= b;
  end;
end;


procedure test;
var
  tb: array of single;
  w:single;
begin
  setLength(tb,1000);
  if InitCudaMC1 then
  begin
//    w:= MySum(@tb[0],1000);
    messageCentral(Estr(w,3));
  end;
end;


Initialization
AffDebug('Initialization stmVSstreamer1',0);
registerObject(TVSmotionCloud,stim);


end.
