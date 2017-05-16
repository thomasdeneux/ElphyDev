unit StmMotionCloud2;

interface

uses windows, classes,graphics, sysutils,

     Direct3D9G, D3DX9G,

     util1,varconf1,Dgraphic, debug0,
     ippDefs17, ipps17,
     stmdef,stmObj,stmMvtX1, stmObv0, defForm,
     Ncdef2,stmPG,
     syspal32,
     stmVSBM1,
     motionCloud2,
     stmMat1,
     clock0;



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


procedure proTVSmotionCloud_Init(dt1: float; Nsample1:integer; Nx1,Ny1: integer; seed: longword;var pu:typeUO);pascal;

procedure proTVSmotionCloud_InstallGaborFilter( ss, r0, sr0, stheta0: float; var pu:typeUO);pascal;
procedure proTVSmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);pascal;

procedure proTVSmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);pascal;
procedure proTVSmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetLum(Lmean, Lsigma:float;var pu:typeUO);pascal;

procedure proTVSmotionCloud_getFilter(var mat: Tmatrix;var pu:typeUO);pascal;

procedure testSumTest;

procedure test;

implementation


var
  InitMC2: function( p1:IDirect3DTexture9 ;  w,h:integer; Filter1: PDouble; a1, b1, c1: PDouble; Fpolar: longBool;Nsample1: integer): integer;cdecl;
  DoneMC2: function():integer;cdecl;
  UpdateMC2: function():integer;cdecl;
  GetFrameK2: function(p: PDouble):integer;cdecl;
  SetExpansionK2: function (dx,x0,dy,y0:Double): integer;cdecl;
  SetGainOffset2: function (a1, b1: Double): integer;cdecl;

  GetSumTest: function( A:Pdouble; Ntot:integer): double;cdecl;
  GetMaxThreadsPerBlock: function : integer;cdecl;

  InstallLogGaborFilterMC2: procedure( dtAR, ss , r0, sr0, stheta0: double);cdecl;
  TestKernel: function(A: Pdouble; Ntot:integer; iter: integer; var res:double):single;cdecl;
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


  InitMC2:= getProc(hh1,'InitMC2');
  DoneMC2:= getProc(hh1,'DoneMC2');
  UpdateMC2:= getProc(hh1,'UpdateMC2');
  GetFrameK2:= getProc(hh1,'GetFrameK2');
  SetExpansionK2:= getProc(hh1,'SetExpansionK2');
  SetGainOffset2:= getProc(hh1,'SetGainOffset2');

  GetSumTest:= getProc(hh1,'GetSumTest');
  GetMaxThreadsPerBlock:= getProc(hh1,'GetMaxThreadsPerBlock');
  InstallLogGaborFilterMC2:= getProc(hh1,'InstallLogGaborFilter');
  TestKernel:= getProc(hh1,'TestKernel');
end;

procedure testSumTest;
var
  tb: array of double;
  i,rep:integer;
  res,tt: double;
const
  Ntot=1000000;
begin
  if not InitCudaMC1 then exit;;
  setlength(tb,Ntot);
  fillchar(tb[0],Ntot*sizeof(double),0);
  for i:=0 to Ntot-1 do  tb[i]:=1;
  tt:= TestKernel(@tb[0],Ntot,100,res);
  messageCentral('res= '+Estr(res,6)+'   time='+Estr(tt,6) );

  initTimer2;
  for rep:=1 to 1000 do
  begin
    res:=0;
    for i:=0 to Ntot-1 do res:=res+tb[i];
  end;
  messageCentral(Estr(getTimer2/1000,3));


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
  if CudaInit then DoneMC2;

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
  with mc do initMC2(BMtexture,BMwidth,BMheight,@filter^[0],@a[0],@b[0],@c[0], FpolarMode,Nsample);

  //InstallLogGaborFilterMC2( dtAR, ss , r0, sr0, stheta0);

  //with mc do setExpansionK2(DxF,x0F,DyF,y0F);
  setGainOffset2(Acorrection,Bcorrection);

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
    if tcycle= 0 then UpdateMC2;
  end
  else TVSbitmap(obvis).BMTexture:=nil;
end;

procedure TVSmotionCloud.DoneMvt;
var
  i:integer;
begin
  if not CudaFlag then exit;

  BMtexture:=nil;

  DoneMC2;

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
  Xn:array of Double;
  res: integer;
begin
  if not CudaInit then
  begin
    with mc do
    begin
      res:= initMC2(nil,BMwidth,BMheight,@filter[0],@a[0],@b[0],@c[0], FpolarMode,Nsample);
      //messageCentral('res='+Istr(res));
      res:= setExpansionK2(DxF,x0F,DyF,y0F);
    end;
    CudaInit:=true;

    if res<>0 then messageCentral('GetFrame='+Istr(res));
  end;

  Nx:=BMwidth;
  Ny:= BMheight;

  setLength(Xn,Nx*Ny);
  getFrameK2(@Xn[0]);

  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    mat[i,j]:=  Xn[i+Nx*j];

end;

procedure TVSmotionCloud.resetCuda;
begin
  if CudaInit then
  begin
    DoneMC2;
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



procedure proTVSmotionCloud_Init(dt1: float;Nsample1:integer; Nx1,Ny1: integer; seed: longword;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu).mc do
  begin
    dtAR:=dt1/Nsample1;  // on initialise avec dt1/Nsample
    Nsample:= Nsample1;
    init(Nx1,Ny1, seed,false);
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

procedure proTVSmotionCloud_SetLum(Lmean, Lsigma:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu) do
  begin
    Acorrection:= syspal.LumIndex(Lsigma)/50;
    Bcorrection:= syspal.LumIndex(Lmean);
  end;
end;

procedure proTVSmotionCloud_getFilter(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TVSmotionCloud(pu).mc do getFilter(mat);
end;


procedure test;
var
  tb: array of Double;
  w:Double;
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
