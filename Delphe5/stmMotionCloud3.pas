unit stmMotionCloud3;

// On reprend stmMotionCloud2, en oubliant motionCloud2
// Tout devrait être calculé en cuda

interface

uses windows, classes,graphics, sysutils, math,

     Direct3D9G, D3DX9G,

     util1,varconf1,Dgraphic, debug0, clock0,
     ippDefs17, ipps17,
     stmdef,stmObj,stmMvtX1, stmObv0, defForm,
     Ncdef2,stmPG,
     syspal32,
     stmVSBM1,
     stmMat1,
     Laguerre1,
     stmvec1,
     motionCloud2; // For test Only


type
  TVSmotionCloud= class(TonOff)
                mc: pointer;
                BMwidth, BMheight: integer;

                FpolarMode: boolean; // si true, on appelle Cuda1.CartToPolar

                Lmean: float;
                Lsigma: float;

                ss: double;
                r0: double;
                sr0: double;
                stheta0: double;


                dtAR:float;
                Nsample: integer;
                seed: integer;

                DxF, x0F, DyF, y0F: double;

                DllFlag: boolean;        // DLL chargée
                InitFlag: boolean;       // InitMC2 a été appelée: les params généraux sont en place
                PinkFlag:boolean;
                FilterFlag: boolean;     // Le filtre est en place
                StimFlag: boolean;       // On a appelé InitMC2stim: le bruit est initialisé
                InitializeFlag: boolean;

                ParamValue, paramValueC: array of array of double;//  SS R0 SR0 STHETA0 LMEAN LSIGMA
                VariableGabFilter, VariableLum: boolean;
                stdBase:double;          // déviation standard donnée par l'algorithme:
                                         // on l'évalue au départ pour le pink noise
                                         // =50 pour motion cloud
                AlphaControl: boolean;
                AlphaThreshold: double;
                DefaultLum: double;

                Foct: boolean; // Ajouté le 7-12-16

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure InitMvt; override;
                procedure InitObvis;override;

                procedure calculeMvt; override;
                procedure DoneMvt;override;

                procedure SetLumCorrection(Fanim:boolean;Lm,Lsig: double);
                procedure InitStim( resource:pointer);
                procedure Initialize;
                procedure getFrame(mat: Tmatrix);

                procedure getFilter(mat: Tmatrix);
                procedure setFilter(mat: Tmatrix);

                procedure resetCuda;

                procedure AdjustLogGaborParams0(var r0,sr0,ss: double); // Ajouté le 7-12-16
                procedure AdjustLogGaborParams1(var r0,sr0,ss: double); // Ajouté le 7-12-16

                procedure AdjustLogGaborParams(var r0,sr0,ss: double);
                procedure AddTraj(num:integer;vec: Tvector);
                procedure  CalculCorrectValues;

                procedure InitPink(alpha:float);
                procedure SetAlphaThreshold(th,w:float);

                function isVisual:boolean;override;
                procedure FreeBM;override;

                procedure Resume;
                procedure Restart;
              end;


procedure proTVSmotionCloud_create(var pu:typeUO);pascal;


procedure proTVSmotionCloud_PolarMode( w:boolean ;var pu:typeUO);pascal;
function fonctionTVSmotionCloud_PolarMode(var pu:typeUO): boolean;pascal;

procedure proTVSmotionCloud_Foct( w:boolean ;var pu:typeUO);pascal;
function fonctionTVSmotionCloud_Foct(var pu:typeUO): boolean;pascal;


procedure proTVSmotionCloud_Init(dt1: float; Nsample1:integer; Nx1,Ny1: integer; seed1: longword;var pu:typeUO);pascal;
procedure proTVSmotionCloud_InitPinkNoise(alpha1: float; Nx1,Ny1: integer; seed1: longword;var pu:typeUO);pascal;
procedure proTVSmotionCloud_Initialize(var pu:typeUO);pascal;

procedure proTVSmotionCloud_InstallGaborFilter( ss1, r01, sr01, stheta01: float; var pu:typeUO);pascal;
procedure proTVSmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);pascal;

procedure proTVSmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);pascal;
procedure proTVSmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetLum(Lmean1, Lsigma1:float;var pu:typeUO);pascal;

procedure proTVSmotionCloud_getFilter(var mat: Tmatrix;var pu:typeUO);pascal;

procedure proTVSmotionCloud_AddTraj(st: AnsiString; var vec: Tvector;var pu:typeUO);pascal;
procedure proTVSmotionCloud_SetAlphaThreshold(th,w: float;var pu:typeUO);pascal;

function fonctionTVSbitmap_RectArea( xa,ya,dxa,dya,thetaa:float; k:integer; th:float; var pu:typeUO): float;pascal;

procedure proTVSmotionCloud_Seed(n:integer;var pu:typeUO);pascal;
function fonctionTVSmotionCloud_Seed(var pu:typeUO): integer;pascal;

procedure proTVSmotionCloud_Restart(var pu:typeUO);pascal;
procedure proTVSmotionCloud_Resume(var pu:typeUO);pascal;



procedure testSumTest;

procedure test;

procedure proGPUfft(var mat: Tmatrix; fwd: boolean);pascal;

implementation


var
  InitMC2: function( w,h:integer; seed: integer;Nsample1: integer): pointer;cdecl;
  InitMC2stim: function(mc:pointer; resource:Pointer):integer ;cdecl;
  InitializeMC2: function(mc:pointer):integer ;cdecl;

  DoneMC2: function(mc:pointer):integer;cdecl;
  DoneMC2stim: function(mc:pointer):integer;cdecl;
  UpdateMC2: function(mc:pointer):integer;cdecl;
  GetFrameK2: function(mc:pointer;p: PDouble):integer;cdecl;

  SetExpansionK2: function (mc:pointer;dx,x0,dy,y0:Double): integer;cdecl;
  SetGainOffset2: function (mc:pointer;a1, b1: Double): integer;cdecl;

  GetSumTest: function( A:Pdouble; Ntot:integer): double;cdecl;
  GetMaxThreadsPerBlock: function : integer;cdecl;

  InstallLogGaborFilterMC2: procedure(mc:pointer; dtAR, ss , r0, sr0, stheta0: double);cdecl;
  GetFilterMC2: function(mc:pointer;p: PDouble):integer;cdecl;
  SetFilterMC2: function(mc:pointer;p: PDouble):integer;cdecl;
  TestKernel: function(A: Pdouble; Ntot:integer; iter: integer; var res:double):double;cdecl;

  //fftGPU: procedure( mat: PDoubleComp; Nx,Ny: integer;Fwd: integer );cdecl;

  InitMCpink: function( w, h:integer;seed1: integer; C0x, D0x:Pdouble; Ncx:integer; Nfx,Nf0x: double; var error:integer ):pointer;cdecl;
  InitMCpinkStim: function(mc:pointer;Resource: pointer): integer;cdecl;
  InitializeMCpink: function(mc:pointer; var SumA, SqrSumA:double; var Ntot:integer): HRESULT;cdecl;
  DoneMCpink: function(mc:pointer):integer;cdecl;
  UpdateMCpink: function(mc:pointer; LaunchOnly: boolean):integer;cdecl;
  GetFrameKPink: function(mc:pointer; p: Pdouble):integer;cdecl;
  SetRgbMask: procedure (mc:pointer;n: integer);cdecl;
  SetSeed: procedure (mc:pointer;n: integer);cdecl;
  setAlphaTh: procedure (mc:pointer;th,w: integer);cdecl;

  RestartNoise: function(mc: pointer):integer;cdecl;
  ResumeNoise:  function(mc: pointer): integer;cdecl;

type
  TsinglePoint= record
                  x,y:single;
                end;
  TsingleRect= array[1..4] of TsinglePoint;
  PsingleRect= ^TsingleRect;

var
  RectInTextureArea: function( Resource: pointer; Pts:PsingleRect ;  w,h:integer; k:integer; th:single): double;cdecl;

  hh1: intG;


function InitCudaMC1: boolean;
var
  CudaMC1dll: AnsiString;
begin
  result:=true;
  if hh1<>0 then exit;

  case FcudaVersion of
    1: CudaMC1dll:='CudaMC1.dll';
    2: CudaMC1dll:='CudaMC65.dll';
    3: CudaMC1dll:='CudaMC80.dll';
  end;

  hh1:=GloadLibrary( Appdir+'Cuda\'+CudaMC1dll );
  result:=(hh1<>0);
  if not result then exit;


  InitMC2:= getProc(hh1,'InitMC2');
  InitMC2stim:= getProc(hh1,'InitMC2stim');
  InitializeMC2:= getProc(hh1,'InitializeMC2');
  DoneMC2:= getProc(hh1,'DoneMC2');
  DoneMC2stim:= getProc(hh1,'DoneMC2stim');

  UpdateMC2:= getProc(hh1,'UpdateMC2');
  GetFrameK2:= getProc(hh1,'GetFrameK2');
  GetFilterMC2:= getProc(hh1,'GetFilter');
  SetFilterMC2:= getProc(hh1,'SetFilter');

  SetExpansionK2:= getProc(hh1,'SetExpansionK2');
  SetGainOffset2:= getProc(hh1,'SetGainOffset2');

  GetSumTest:= getProc(hh1,'GetSumTest');
  GetMaxThreadsPerBlock:= getProc(hh1,'GetMaxThreadsPerBlock');
  InstallLogGaborFilterMC2:= getProc(hh1,'InstallLogGaborFilter');
  TestKernel:= getProc(hh1,'TestKernel');
  //fftGPU:= getProc(hh1,'fft');

  InitMCpink:=getProc(hh1,'InitMCpink');
  DoneMCpink:=getProc(hh1,'DoneMCpink');
  InitializeMCpink:=getProc(hh1,'InitializeMCpink');
  UpdateMCpink:=getProc(hh1,'UpdateMCpink');
  GetFrameKPink:=getProc(hh1,'GetFrameKpink');
  InitMCpinkStim:= getProc(hh1,'InitMCpinkStim');
  SetRgbMask:= getProc(hh1,'SetRgbMask');
  SetSeed:= getProc(hh1,'SetSeed');
  SetAlphaTh:= getProc(hh1,'SetAlphaThreshold');
  RectInTextureArea:= getProc(hh1,'RectInTextureArea');

  RestartNoise:= getProc(hh1,'RestartNoise');
  ResumeNoise:= getProc(hh1,'ResumeNoise');

end;


procedure testSumTest;
type
  TReal = double;
var
  tb: array of Treal;
  i,rep:integer;
  res,tt,Tot: Treal;
const
  Ntot= 1024*1024;//     1 shl 24;

  Nrep=100;
begin
  if not InitCudaMC1 then exit;;
  setlength(tb,Ntot);
  fillchar(tb[0],Ntot*sizeof(Treal),0);

  Tot:=0;
  for i:=0 to Ntot-1 do
  begin
    tb[i]:= i/1E6;
    Tot:=Tot+tb[i];
  end;


  tt:= TestKernel(@tb[0],Ntot,100,res);
  messageCentral('Cuda res= '+Estr(res,6)+'   time='+Estr(tt,6)+'   tot='+Estr(tot,6) );


  initTimer2;
  for rep:=1 to Nrep do
  begin
    res:=0;
    ippsSum_64f(Pdouble(@tb[0]),Ntot,@res);
    //for i:=0 to Ntot-1 do res:=res+tb[i];
  end;
  messageCentral('IPPS res= '+Estr(res,3)+'   time='+Estr(getTimer2/1000/Nrep,3));

  initTimer2;
  for rep:=1 to Nrep do
  begin
    res:=0;
    for i:=0 to Ntot-1 do res:=res+tb[i];
  end;
  messageCentral('Loop res= '+Estr(res,3)+'   time='+Estr(getTimer2/1000/Nrep,3));

end;
{ TVSmotionCloud }

constructor TVSmotionCloud.create;
var
  i:integer;
begin
  inherited;

  BMwidth:= 256;
  BMHeight:= 256;

  Lmean:= 128;
  Lsigma:= 50;

  DllFlag:=initCudaMC1;
  if not DllFlag then sortieErreur('TVSmotionCloud : CudaMC1.dll not initialized');

  Foct:= true; // Jonathan 12-12-2016
end;

destructor TVSmotionCloud.destroy;
begin
  if InitFlag then
  begin
    if PinkFlag
      then DoneMCpink(mc)
      else DoneMC2(mc);
    mc:=nil;
  end;
  inherited;
end;


class function TVSmotionCloud.STMClassName: AnsiString;
begin
  result:='VSmotionCloud';
end;

procedure TVSmotionCloud.SetLumCorrection(Fanim:boolean;Lm,Lsig: double);
var
  Acorrection, Bcorrection: double;
begin
  if Fanim then
  begin
    // pour l'animation, on souhaite des valeurs de pixel
    Acorrection:= syspal.LumToPix(Lsig)/stdBase;                    // LumIndex remplacé par LumToPix 12-2016
    Bcorrection:= syspal.LumToPix(Lm);                              // Pb arrondis
  end
  else
  begin
    // pour la liste de matrices, on souhaite des luminances vraies
    Acorrection:= Lsig/stdBase;
    Bcorrection:= Lm;
  end;
  //with mc do setExpansionK2(DxF,x0F,DyF,y0F);
  setGainOffset2(mc,Acorrection,Bcorrection);
end;

procedure TVSmotionCloud.InitStim( resource:pointer); // appelé dans initMvt

begin
  if not InitializeFlag then Initialize;

  VariableGabFilter:=false;
  VariableLum:=(length(paramValue)>0) and ((length(paramValue[4])>0) or (length(paramValue[5])>0) );
  AlphaControl:= (length(paramValue)>0) and ((length(paramValue[6])>0) or (length(paramValue[7])>0) );
  if PinkFlag then
  begin
    InitMCpinkStim(mc,Resource);

    setLumCorrection(resource<>nil,Lmean,Lsigma);
  end
  else
  begin
    setLumCorrection(resource<>nil,Lmean,Lsigma);

    if (length(paramValue)>0) then
    begin
      VariableGabFilter:= (length(paramValue[0])>0) or (length(paramValue[1])>0) or (length(paramValue[2])>0) or (length(paramValue[3])>0);
      if VariableGabFilter then
      begin
        CalculCorrectValues;
        InstallLogGaborFilterMC2(mc, dtAR, paramValueC[0,0],paramValueC[1,0],paramValueC[2,0],paramValueC[3,0]);
      end;
    end;

    InitMC2stim(mc,Resource);
  end;

  StimFlag:=true;
end;

procedure TVSmotionCloud.Initialize;
var
  ss,ss2:double;
  Nt:integer;

begin
  if PinkFlag then
  begin
    ss:=1; ss2:=1; Nt:=1;
    setSeed(mc,seed);
    InitializeMCpink(mc,ss,ss2,Nt);
    if (Nt>1) and (ss2>0) then stdBase:= sqrt((ss2-sqr(Ss)/Nt)/(Nt-1)) else stdBase:=1;
  end
  else
  begin
    stdBase:=1;
    setSeed(mc,seed);
    InitializeMC2(mc);
  end;
  InitializeFlag:=true;
end;

procedure TVSmotionCloud.InitMvt;
begin
  if not DllFlag or not InitFlag or not FilterFlag then exit;

  initObvis;
  inherited;

  TVSbitmap(obvis).registerCuda;
  initStim(TVSbitmap(obvis).BMcudaResource);
end;

procedure TVSmotionCloud.InitObvis;
begin
  TVSbitmap(obvis).initBM(BMwidth,BMheight);
  TVSbitmap(obvis).prepareS;
  inherited;
end;

procedure TVSmotionCloud.calculeMvt;
var
  tCycle,num:integer;
  ss1,r01, sr01, stheta01: double;
  Lm,Lsig: double;
  th,thval: double;
  res: integer;
  RstON: boolean;
begin
  if not DllFlag or not InitFlag or not FilterFlag then exit;

  tCycle:=timeS mod dureeC;
  num:= timeS div dureeC;

  if num<CycleCount then
  begin
    if (tcycle=0) then
    begin
      if VariableGabFilter then
        InstallLogGaborFilterMC2(mc, dtAR,paramValueC[0,num],paramValueC[1,num],paramValueC[2,num],paramValueC[3,num]);

      lm:= Lmean;
      lsig:= Lsigma;
      if VariableLum then
      begin
        if (length(paramValue[4])>0) then lm:=paramValue[4,num];
        if (length(paramValue[5])>0) then lsig:=paramValue[5,num];
        SetLumCorrection(true,Lm,Lsig);
      end;

      if AlphaControl then
      begin
        if (length(paramValue[6])>0) then th:=paramValue[6,num] else th:= AlphaThreshold;
        if (length(paramValue[7])>0) then thval:=paramValue[7,num] else thval:= DefaultLum;
        SetAlphaThreshold(th,thval);
      end;

      rstOn:=false;
      if (lm>=0) and (length(paramValue)>8) and (length(paramValue[8])>0) then
        case round(paramValue[8][num]) of
          1: begin
               res:= RestartNoise(mc);
               Addwarning('RestartNoise', res and $FFFFFF);
               rstON:=true;
             end;
          2: begin
               res:= ResumeNoise(mc);
               Addwarning('ResumeNoise', res and $FFFFFF);
               rstON:=true;
             end;
        end;

        // Update affiche l'image puis lance le calcul pour l'image suivante
      if rstON and (Lm<0) and PinkFlag then UpdateMCpink(mc,true)
      else
      if (Lm>=0) then
      begin
        if PinkFlag
          then UpdateMCpink(mc,false)
          else UpdateMC2(mc);
      end;



    end;
  end;
end;

procedure TVSmotionCloud.DoneMvt;
begin
  DoneMC2stim(mc);
  TVSbitmap(obvis).UnRegisterCuda;
end;


procedure TVSmotionCloud.getFrame(mat: Tmatrix);
var
  i,j:integer;
  Nx,Ny: integer;
  Xn:array of Double;
  res: integer;
  lm,lsig: double;
Const
  NumF: integer=0;
begin
  if not DllFlag or not InitFlag or not FilterFlag then exit;

  if not StimFlag then
  begin
    initStim(nil);
    NumF:=0;
  end;

  if variableGabFilter then
  begin
    InstallLogGaborFilterMC2(mc, dtAR,paramValueC[0,numF],paramValueC[1,numF],paramValueC[2,numF],paramValueC[3,numF]);
    inc(numF);
  end;

  if  variableLum then
  begin
    if (length(paramValue[4])>0) then lm:=paramValue[4,numF] else lm:= Lmean;
    if (length(paramValue[5])>0) then lsig:=paramValue[5,numF] else lsig:= Lsigma;
    SetLumCorrection(false,Lm,Lsig);
  end;

  Nx:=BMwidth;
  Ny:= BMheight;

  setLength(Xn,Nx*Ny);
  if pinkFlag
    then getFrameKpink(mc,@Xn[0])
    else getFrameK2(mc,@Xn[0]);

  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    mat[i,j]:=  Xn[i+Nx*j];

end;

procedure TVSmotionCloud.getFilter(mat: Tmatrix);
var
  i,j:integer;
  Nx,Ny: integer;
  Xn:array of Double;
begin
  if not DllFlag or not InitFlag or not FilterFlag then exit;

  Nx:= BMwidth;
  Ny:= BMheight;

  setLength(Xn,Nx*Ny);
  getFilterMC2(mc,@Xn[0]);

  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    mat[i,j]:=  Xn[i+Nx*j];
end;

procedure TVSmotionCloud.setFilter(mat: Tmatrix);
var
  i,j:integer;
  Nx,Ny: integer;
  Xn:array of Double;
begin
  if not DllFlag or not InitFlag then exit;

  Nx:= BMwidth;
  Ny:= BMheight;

  if (mat.Icount<>Nx) or (mat.Jcount<>Ny) then exit;

  setLength(Xn,Nx*Ny);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
      Xn[i+Nx*j]:= mat[mat.Istart+i, mat.Jstart+j];

  setFilterMC2(mc,@Xn[0]);
end;

procedure TVSmotionCloud.resetCuda;
begin
  if InitFlag then
  begin
    if PinkFlag
      then DoneMCpink(mc)
      else DoneMC2(mc);
    InitFlag:=false;
    mc:=nil;
  end;
end;

procedure TVSmotionCloud.AdjustLogGaborParams0(var r0,sr0,ss: double);
var
  Degree: integer;
  Poly      : TNCompVector;
  InitGuess : TNcomplex;
  Tol       : Float;
  MaxIter   : integer;
  NumRoots  : integer;
  Roots     : TNCompVector;
  yRoots    : TNCompVector;
  Iter      : TNIntVector;
  Error     : byte;

  stR:string;
  i,i0:integer;
  GoodRoot: double;

Const
  Eps=1E-10;

begin
   Degree:=8;
   //Poly[0]:=Doublecomp(-sr0/sqr(r0),0);     //
   Poly[0]:=Doublecomp(-power(sr0, 2)/power(r0, 2),0); // correction Jonathan 7-12-16
   Poly[1]:=Doublecomp(0,0);
   Poly[2]:=Doublecomp(1,0);
   Poly[3]:=Doublecomp(0,0);
   Poly[4]:=Doublecomp(3,0);
   Poly[5]:=Doublecomp(0,0);
   Poly[6]:=Doublecomp(3,0);
   Poly[7]:=Doublecomp(0,0);
   Poly[8]:=Doublecomp(1,0);
   fillchar(InitGuess,sizeof(InitGuess),0);
   Tol:= 1e-6;
   MaxIter:=1000;

   Laguerre( Degree, Poly, InitGuess, Tol, MaxIter, NumRoots, Roots, yRoots, Iter, Error);
   {
   stR:='NumRoots= '+Istr(NumRoots)+'  Roots= ';
   for i:=0 to 8 do stR:= stR+ Estr(Roots[i].x,3)+'  '+Estr(Roots[i].y,3)+crlf;
   stR:=stR+crlf +' error= '+Istr(error);
   messageCentral(stR);
   }
  // ranger la racine réelle positive dans sr0
  // dans r0, ranger r0*(1+sqr(sr0))
  i0:=-1;
  for i:=1 to 8 do
  if (abs(Roots[i].y)<Eps) and (Roots[i].x>0) then i0:=i;


  if (i0<0) or (error<>0) then
  begin
    //messageCentral('Error AdjustLogGaborParams');
    exit;
  end;

  sr0:=Roots[i0].x;
  r0:= r0*(1+sqr(sr0));
  ss:=ss/r0;

end;

procedure TVSmotionCloud.AdjustLogGaborParams1(var r0,sr0,ss: double);
begin
  sr0 := power( ( exp( ln(2)/8 * power(sr0,2)  ) - 1 )  , 0.5 );
  r0 := r0*( 1+power(sr0, 2) );
  ss := ss/r0;
end;


procedure TVSmotionCloud.AdjustLogGaborParams(var r0,sr0,ss: double);
begin
  if Foct
    then AdjustLogGaborParams1( r0,sr0,ss)
    else AdjustLogGaborParams0( r0,sr0,ss);
end;

procedure TVSmotionCloud.AddTraj(num:Integer; vec: Tvector);
var
  i:integer;
begin
  if length(paramValue)=0 then setLength(paramValue,9);

  setLength(paramValue[num],vec.Icount);
  for i:=0 to vec.Icount-1 do
    paramValue[num,i]:= vec[vec.Istart+i];
end;

procedure  TVSmotionCloud.CalculCorrectValues;
var
  i, num: integer;
  ss1,r01,sr01,stheta01: double;
begin
  setLength(paramValueC,4);
  for i:=0 to 3 do
    setLength(paramValueC[i],cycleCount);

  for num:=0 to cycleCount-1 do
  begin
    if length(paramValue[0])>num then ss1:= paramValue[0,num] else ss1:= ss;
    if length(paramValue[1])>num then r01:= paramValue[1,num] else r01:= r0;
    if length(paramValue[2])>num then sr01:= paramValue[2,num] else sr01:= sr0;
    if length(paramValue[3])>num then stheta01:= paramValue[3,num] else stheta01:= stheta0;

    AdjustLogGaborParams(r01,sr01,ss1);

    paramValueC[0,num]:= ss1;
    paramValueC[1,num]:= r01;
    paramValueC[2,num]:= sr01;

    paramValueC[3,num]:= stheta01;
  end;
end;


function ModifiedAlpha(x:real):real;
const
  AA= -0.840662979445;
  BB=  1.786790559533;
  CC=  0.050161344013;
  DD= -0.133316349460;
begin
  if x< 0.5 then ModifiedAlpha:= 0.05
  else
  if x>1.99 then ModifiedAlpha:= 5
  else
  ModifiedAlpha:= AA+BB*x+CC*sqr(x)+DD/(2-x);
end;

procedure TVSmotionCloud.InitPink(alpha: float);
const
  Nc=16;
  Nf=2;
  Nf0=2;
var
  i,j:integer;
  omega,f0,A0,ll,alpha1:float;
  C0,D0: array[1..16] of double;
  res: integer;

begin
  alpha1:= modifiedAlpha(alpha);
  for i:=1 to Nc do
  begin
    omega:= Nf0*power(Nf,i-1);               // 2  4  8  16 ...
    f0:= 1/omega;
    if omega=2 then ll:=1 else ll:=1/tan(pi/omega);


    C0[i]:= (1-ll)/(1+ll);
    A0:= power(f0,-alpha1/2);
    D0[i]:= A0/(1+ll);
  end;

  mc:= initMCpink(BMwidth,BMheight,seed,@C0,@D0,Nc,Nf,Nf0, res);
  Addwarning('InitPink ', res);
end;

procedure TVSmotionCloud.SetAlphaThreshold(th, w: float);
begin
  if (th>=0) and (th<=1) then AlphaThreshold:=th;
  if (w>=0)and (w<=10000) then DefaultLum:=w;

  setAlphaTh(mc,round(255*AlphaThreshold),syspal.DX9color(DefaultLum,0));
end;

procedure TVSmotionCloud.Restart;
begin
  if assigned(mc) then restartNoise(mc);
end;

procedure TVSmotionCloud.Resume;
begin
  if assigned(mc) then resumeNoise(mc);
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

procedure proTVSmotionCloud_Foct( w:boolean ;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSmotionCloud(pu).Foct:=w;
end;

function fonctionTVSmotionCloud_Foct(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TVSmotionCloud(pu).Foct;
end;


procedure proTVSmotionCloud_Init(dt1: float;Nsample1:integer; Nx1,Ny1: integer; seed1: longword;var pu:typeUO);
begin
  verifierObjet(pu);

  if not initCudaMC1 then sortieErreur('CudaMC dll not loaded');
  with TVSmotionCloud(pu) do
  begin

    dtAR:=dt1/Nsample1;  // on initialise avec dt1/Nsample
    Nsample:= Nsample1;
    seed:=seed1;
    BMwidth:= Nx1;
    BMheight:=Ny1;

    mc:=initMC2(BMwidth,BMheight,seed,Nsample);
    if mc=nil then sortieErreur('TVSmotionCloud.Init : unable to install cuda object');

    setRgbMask(mc,CudaRgbMask);
    resetCuda;

    InitFlag:= true;
    FilterFlag:=false;
    StimFlag:=false;
    setLength(paramValue,0);
  end;
end;

procedure proTVSmotionCloud_SetAlphaThreshold(th,w:float;var pu:typeUO);
begin
  verifierObjet(pu);

  if not initCudaMC1 then sortieErreur('CudaMC dll not loaded');
  with TVSmotionCloud(pu) do SetAlphaThreshold(th,w);

end;

procedure proTVSmotionCloud_InitPinkNoise(alpha1: float; Nx1,Ny1: integer; seed1: longword;var pu:typeUO);
begin
  verifierObjet(pu);

  if not initCudaMC1 then sortieErreur('CudaMC dll not loaded');
  with TVSmotionCloud(pu) do
  begin

    seed:=seed1;
    BMwidth:= Nx1;
    BMheight:=Ny1;

    initPink(alpha1);
    setRgbMask(mc,CudaRgbMask);
    resetCuda;

    InitFlag:= true;
    PinkFlag:=true;
    FilterFlag:=false;
    StimFlag:=false;
  end;
end;


procedure proTVSmotionCloud_InstallGaborFilter( ss1, r01, sr01, stheta01: float; var pu:typeUO);
var
  r0A,sr0A,ssA: double;
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu) do
  begin
    ss:= ss1;
    r0:= r01;
    sr0:= sr01;
    stheta0:= stheta01;

    ssA:= ss1;
    r0A:= r01;
    sr0A:= sr01;


    if not DllFlag or not InitFlag then  sortieErreur('TVSmotionCloud : object not initialized');


    AdjustLogGaborParams(r0A,sr0A,ssA);            // on corrige les variables locales uniquement
    InstallLogGaborFilterMC2( mc,dtAR, ssA , r0A, sr0A, stheta0);
    FilterFlag:=true;
  end;
end;

procedure proTVSmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);
begin
  verifierObjet(pu);
  //with TVSmotionCloud(pu).mc do
  //  InstallMaternFilter( ss, eta, alpha);
  // FilterFlag:=true;
end;

procedure proTVSmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TVSmotionCloud(pu) do
  begin
    setFilter(mat);
    FilterFlag:=true;
  end;
end;

procedure proTVSmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);

  with TVSmotionCloud(pu) do
  begin
    if not DllFlag or not InitFlag or not FilterFlag then sortieErreur('TVSmotionCloud : object not initialized');
    getFrame(mat);
  end;
end;


procedure proTVSmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu) do
  begin
    DxF := DxF1;
    x0F := x0F1;
    DyF := DyF1;
    y0F := y0F1;
  end;
end;

procedure proTVSmotionCloud_SetLum(Lmean1, Lsigma1:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSmotionCloud(pu) do
  begin
    Lmean:= Lmean1;
    Lsigma:=Lsigma1;
  end;
end;

procedure proTVSmotionCloud_getFilter(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TVSmotionCloud(pu) do getFilter(mat);
end;

procedure proTVSmotionCloud_AddTraj(st: AnsiString; var vec: Tvector;var pu:typeUO);
var
  k:integer;
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with TVSmotionCloud(pu) do
  begin
    if vec.Icount<cycleCount then sortieErreur('TVSmotionCloud.AddTraj : Not enough data in vector');

    st:=UpperCase(st);
    if st='SS' then k:=0
    else
    if st='R0' then k:=1
    else
    if st='SR0' then k:=2
    else
    if st='STHETA0' then k:=3
    else
    if st='LMEAN' then k:=4
    else
    if st='LSIGMA' then k:=5
    else
    if st='ALPHATHRESHOLD' then k:=6
    else
    if st='DEFAULTLUM' then k:=7
    else
    if st='RESTARTNOISE' then k:=8

    else sortieErreur('TVSmotionCloud.AddTraj : Bad Parameter Name') ;

    AddTraj(k,vec);
  end;
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

procedure proGPUfft(var mat: Tmatrix; fwd: boolean);
begin
  if not InitCudaMC1 then exit;;
  verifierMatrice(mat);
  //fftGPU(mat.tbDC,mat.Icount,mat.Jcount,ord(fwd));
end;

function fonctionTVSbitmap_RectArea( xa,ya,dxa,dya,thetaa:float; k:integer; th:float; var pu:typeUO): float;
var
  degA:typeDegre;
  PR:typePoly5R;
  Drect: TsingleRect;
  i: integer;
begin
  if not initCudaMC1 then exit;

  verifierObjet(pu);
  degA.x:=xa;
  degA.y:=ya;
  degA.dx:=dxa;
  degA.dy:=dya;
  degA.theta:=thetaa;
  degToPolyR(degA,PR);



  with TVSbitmap(pu) do
  begin
    for i:=1 to 4 do
    begin
      Drect[i].x := width div 2 + PR[i].x/ DxBM*width;
      Drect[i].y := height div 2 + PR[i].y/ DyBM*height;
    end;

    registerCuda;
    try
    result:= RectInTextureArea( BMCudaResource, @DRect ,Width,Height, k,th);
    finally
    unregisterCuda;
    end;
  end;
end;

procedure proTVSmotionCloud_Seed(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSmotionCloud(pu).Seed:=n;
end;

function fonctionTVSmotionCloud_Seed(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:= TVSmotionCloud(pu).Seed;
end;

procedure proTVSmotionCloud_Restart(var pu:typeUO);
begin
  verifierObjet(pu);
  TVSmotionCloud(pu).Restart;
end;

procedure proTVSmotionCloud_Resume(var pu:typeUO);
begin
  verifierObjet(pu);
  TVSmotionCloud(pu).Resume;
end;

procedure proTVSmotionCloud_Initialize(var pu:typeUO);
begin
  verifierObjet(pu);
  TVSmotionCloud(pu).Initialize;
end;



procedure TVSmotionCloud.FreeBM;
begin
  resetCuda;
end;

function TVSmotionCloud.isVisual: boolean;
begin
  result:=true;
end;


Initialization
AffDebug('Initialization stmVSstreamer1',0);
registerObject(TVSmotionCloud,stim);


end.
