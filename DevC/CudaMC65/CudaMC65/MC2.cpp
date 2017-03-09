/* DLL permettant la gestion des motions clouds en CUDA

  InitMC2 : paramètres:   int w, int h, int seed1, int Nsamp)
              w et h : dimensions en pixels
              seed
              Nsamp: facteur de sur-échantillonnage
  InitMC2stim:
            param: cudaResource de la texture              
            La texture est créée extérieurement avec les paramètres D3DFMT_A8R8G8B8,D3DPOOL_DEFAULT
            

  UpdateMC :  remplit la texture avec le MC calculé
  GetFrameK : effectue le même calcul mais range le résultat dans une matrice.
              paramètre p : tableau de dimension w*h

  SetGainOffset permet de corriger la luminance finale
                paramètres a,b 
                On applique la transformation z' = a*z+b à chaque pixel de la matrice finale
                Les valeurs par défaut sont a=1 et b=128

                   
*/

#define CUDAMC1_API __declspec(dllexport) 

#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>   dfdf  df
#endif
#include <d3d9.h>

#include <math.h>              

#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>
#include <cufft.h>

//#include <helper_cuda.h>
//#include <helper_functions.h>

#include "MC2.h"

typedef double2 Complex;

extern "C" {CUDAMC1_API TMCstruct* InitMC2( int w, int h, int seed1, int Nsamp); }

extern "C" {CUDAMC1_API HRESULT InitMC2stim(TMCstruct* mc, cudaGraphicsResource* Resource); }
extern "C" {CUDAMC1_API HRESULT InitializeMC2(TMCstruct* mc); }

extern "C" {CUDAMC1_API HRESULT DoneMC2(TMCstruct* mc); }
extern "C" {CUDAMC1_API HRESULT DoneMC2stim(TMCstruct* mc); }


extern "C" {CUDAMC1_API int UpdateMC2(TMCstruct* mc);}
extern "C" {CUDAMC1_API int GetFrameK2(TMCstruct* mc, double* p); }
extern "C" {CUDAMC1_API int GetFilter(TMCstruct* mc, double* p); }
extern "C" {CUDAMC1_API int SetFilter(TMCstruct* mc, double* p); }


extern "C" {CUDAMC1_API int SetExpansionK2(TMCstruct* mc, double Dx1, double x01, double Dy1, double y01); }
extern "C" {CUDAMC1_API int SetGainOffset2(TMCstruct* mc, double a1, double b1); }

extern "C" {CUDAMC1_API void SetAlphaThreshold(TMCstruct* mc, int th, int ww); }

extern "C" {CUDAMC1_API double GetSumTest(double* A, int Ntot); }

extern "C" {CUDAMC1_API int GetMaxThreadsPerBlock(); }

extern "C" {CUDAMC1_API void InstallLogGaborFilter(TMCstruct* mc, double dtAR, double ss , double r0, double sr0, double stheta0); } 

extern "C" {CUDAMC1_API double TestKernel(double* A, int Ntot, int testIterations, double* res); }


extern "C" {CUDAMC1_API void* InitMCpink(int w, int h, int seed1, double* C0x, double* D0x, int Ncx, double Nfx, double Nf0x, int *error ); }
extern "C" {CUDAMC1_API HRESULT InitMCpinkStim(TMCstruct* mc, cudaGraphicsResource* Resource );}
extern "C" {CUDAMC1_API HRESULT InitializeMCpink(TMCstruct* mc, double* aa, double* bb, int* Nt);}

extern "C" {CUDAMC1_API HRESULT DoneMCpink(TMCstruct* mc);}
extern "C" {CUDAMC1_API int UpdateMCpink(TMCstruct* mc, boolean LaunchOnly);}
extern "C" {CUDAMC1_API int GetFrameKpink(TMCstruct* mc, double* p);}
extern "C" {CUDAMC1_API void SetRgbMask(TMCstruct* mc,int mask);} 
extern "C" {CUDAMC1_API void SetSeed(TMCstruct* mc,int seed1);} 

extern "C" {CUDAMC1_API double RectInTextureArea(cudaGraphicsResource* Resource, float2* Pts, int w, int h, int k, float th); }

extern "C" {CUDAMC1_API int RestartNoise(TMCstruct* mc); }
extern "C" {CUDAMC1_API int ResumeNoise(TMCstruct* mc); }


void InitConstants();


TMCstruct :: TMCstruct() {
  Filter  = NULL;
  Noise  = NULL;
  Xn0  = NULL;
  Xn1  = NULL;
  Xn2  = NULL;
  Vdum  = NULL;

  Xnf0  = NULL;
  Xnf1  = NULL;
  Xnf2  = NULL;
  fftNoise  = NULL;
  

  LinearMem  = NULL;
  

  generator  = NULL;
  RstGenerator = NULL;

  fftPlan  = NULL;

  Noise1  = NULL;
  Noise2  = NULL;


  D0  = NULL;
  C0  = NULL;
  LastF  = NULL;  

  Noise1_init  = NULL;
  LastF_init = NULL;

  Noise1_cont  = NULL;
  LastF_cont = NULL;
  ContOffset = 0;
  
  RstState = 0;
  DoRestart = 0;
  streamK = NULL;
}


TMCstruct* InitMC2(int w, int h, int seed1, int Nsamp)
{    
  InitConstants();
 
  TMCstruct* p = new(TMCstruct);
  int res = p->InitMC2(w,h, seed1, Nsamp);
  if (res!=0)
  { 
    DoneMC2(p);
  }
  return p;
}

int TMCstruct :: InitMC2(int w, int h, int seed1, int Nsamp)
{
  int res;
  res = cudaMalloc( (void**)&Filter, w*h* sizeof(double));    
  if (res!=0) return res; 
   
  res = cudaMalloc( (void**)&afReg, w*h* sizeof(double));        
  res = cudaMalloc( (void**)&bfReg, w*h* sizeof(double));        
  res = cudaMalloc( (void**)&cfReg, w*h* sizeof(double));        
   
  res = cudaMalloc((void**)&Noise, w*h* sizeof(double));    
  res = cudaMemset(Noise, 0, w*h* sizeof(double));
                                                                                        
  res = cudaMalloc((void**)&Vdum, w*h* sizeof(double));    
  res = cudaMemset(Vdum, 0, w*h* sizeof(double));
    
  res = cudaMalloc((void**)&Xnf0, w*h* sizeof(Complex));    
  res = cudaMemset(Xnf0, 0, w*h* sizeof(Complex));
    
  res = cudaMalloc((void**)&Xnf1, w*h* sizeof(Complex));    
  res = cudaMemset(Xnf1, 0, w*h* sizeof(Complex));
    
  res = cudaMalloc((void**)&Xnf2, w*h* sizeof(Complex));    
  res = cudaMemset(Xnf2, 0, w*h* sizeof(Complex));
    
  res = cudaMalloc((void**)&fftNoise, w*h* sizeof(Complex));    
  res = cudaMemset(fftNoise, 0, w*h* sizeof(Complex));
    
  res = cudaMallocPitch(&LinearMem, &PitchMem, w * sizeof(char) * 4, h);    
  res = cudaMemset(LinearMem, 1, PitchMem * h);
    

  Nx = w;
  Ny = h;
        
  DxF = 1;
  X0F = 0;
  DyF = 1;
  Y0F = 0;

  Atransform = 1;
  Btransform = 0;

  Nsample = Nsamp;

  // Traiter le seed !
  seed = seed1;
  
  res = cudaStreamCreate ( &streamK );   
  //res = cudaStreamCreateWithFlags(&streamK, cudaStreamNonBlocking );   
  return res;
}

HRESULT InitMC2stim(TMCstruct* mc, cudaGraphicsResource* Resource)
{
  return mc->InitMC2stim(Resource);
}

HRESULT TMCstruct :: InitMC2stim( cudaGraphicsResource* Resource)
{

  int res;
  cudaResource = Resource;    

  //XXL start
  cudaStream_t    stream = 0;        
  cudaGraphicsResource *ppResources[1];                
  ppResources[0]=  cudaResource;       
  
  if (Resource!=NULL)
  {
    res = cudaGraphicsMapResources( 1, ppResources, stream);
    if (res!=0) return res;
               
    cudaArray *cuArray;

    res = cudaGraphicsSubResourceGetMappedArray(&cuArray, cudaResource, 0, 0);
               
    // On copie la texture dans LinearMem              4juin 2015; on a besoin de alpha
    res = cudaMemcpy2DFromArray(
              LinearMem, PitchMem,
              cuArray, 0, 0,                      
              Nx*4*sizeof(char), Ny, // extent
              cudaMemcpyDeviceToDevice); // kind
    
        
    cudaGraphicsUnmapResources(1, ppResources, stream);
  } // XXL end

  // return InitK2(); 10-01-17
}

HRESULT InitializeMC2(TMCstruct* mc)
{
  return mc->InitK2();
}



int SetExpansionK2(TMCstruct* mc, double Dx1, double x01, double Dy1, double y01)
{
  return mc->SetExpansionK2(Dx1,x01,Dy1,y01);
}

int TMCstruct :: SetExpansionK2( double Dx1, double x01, double Dy1, double y01)
{
  DxF = Dx1;
  X0F = x01;
  DyF = Dy1;
  Y0F = y01;

  return 0;
}

int SetGainOffset2( TMCstruct* mc,double a1, double b1)
{
  return mc->SetGainOffset2(a1,b1);
}

int  TMCstruct :: SetGainOffset2( double a1, double b1)
{
  Atransform = a1;
  Btransform = b1;
  return 0;
}

void SetAlphaThreshold( TMCstruct* mc, int th, int ww)
{
  mc->SetAlphaThreshold(th,ww);
}

void  TMCstruct :: SetAlphaThreshold( int th, int ww)
{
  if (th>=0) AlphaTh = th; 
  if (ww>=0) AlphaThV= ww;
}

HRESULT  DoneMC2(TMCstruct* mc)
{
  if (mc!=NULL)
  {
    mc->DoneMC2();
    delete(mc);
  }
  return 0;
}

HRESULT  TMCstruct :: DoneMC2()
{       
    DoneK2();

    int res;

    DoneMC2stim();
        
    res = cudaFree(afReg);
    afReg=NULL;
    
    res = cudaFree(bfReg);
    bfReg=NULL;
    
    res = cudaFree(bfReg);
    bfReg=NULL;    
    
    res = cudaFree(Filter);
    Filter=NULL;
    
    res = cudaFree(Noise);
    Noise=NULL;
   
    res = cudaFree(Vdum);
    Vdum=NULL;
   
    res = cudaFree(fftNoise);
    fftNoise=NULL;
   
    res = cudaFree(Xnf0);
    Xnf0=NULL;
    
    res = cudaFree(Xnf1);
    Xnf1=NULL;
    
    res = cudaFree(Xnf2);
    Xnf1=NULL;
    
    res = cudaFree(LinearMem);
    LinearMem = NULL;

    cudaStreamDestroy(streamK);
    streamK=0;

    return S_OK;
}

HRESULT DoneMC2stim(TMCstruct* mc)
{
  return mc->DoneMC2stim();
}

HRESULT TMCstruct :: DoneMC2stim()
{     
    int res;
    
    DoneKpink();
    cudaResource = NULL;
    
    return 0;
}


int UpdateMC2(TMCstruct*mc)
{
  return mc->UpdateMC2();
}

int  TMCstruct :: UpdateMC2()
{
  // Calcul du MC suivant ; le résultat est dans LinearMem
  UpdateK2();

  cudaStream_t    stream = 0;
        
  cudaGraphicsResource *ppResources[1];
                
  ppResources[0]=  cudaResource;
           
        
  int res = cudaGraphicsMapResources( 1, ppResources, stream);
  if (res!=0) return res;
               
  cudaArray *cuArray;
  res = cudaGraphicsSubResourceGetMappedArray(&cuArray, cudaResource, 0, 0);
               
  // On copie LinearMem dans la texture
  res = cudaMemcpy2DToArray(
            cuArray, // dst array
            0, 0,    // offset
            LinearMem, PitchMem,       // src
            Nx*4*sizeof(char), Ny, // extent
            cudaMemcpyDeviceToDevice); // kind
               
        
  cudaGraphicsUnmapResources(1, ppResources, stream);
  return res;
    
}

int GetFrameK2(TMCstruct* mc, double* p)
{
  return mc->GetFrameK2(p);
}

int TMCstruct :: GetFrameK2( double* p)
{
  UpdateK2();
  cudaMemcpy( p, Noise , Nx*Ny* sizeof(double), cudaMemcpyDeviceToHost);
  return 0;
}

int GetFilter(TMCstruct* mc, double* p)
{
  return mc->GetFilter(p);
}

int TMCstruct :: GetFilter( double* p)
{   
  cudaMemcpy( p, Filter , Nx*Ny* sizeof(double), cudaMemcpyDeviceToHost);
  //cudaMemcpy( p, cfReg , Nx*Ny* sizeof(double), cudaMemcpyDeviceToHost);
  return 0;
}

int SetFilter(TMCstruct* mc, double* p)
{
  return mc->SetFilter(p);
}

int TMCstruct :: SetFilter( double* p)
{   
  InitConstants();
  cudaMemcpy( Filter , p, Nx*Ny* sizeof(double), cudaMemcpyHostToDevice);
  
  return 0;
}

extern double CudaSum(double* A, int Ntot, double* Odata);

double GetSumTest(double* A, int Ntot)
{
    double* Ad;
    double* Odata;
    int res = cudaMalloc((void**) &Ad, Ntot* sizeof(double));        
    cudaMalloc((void**) &Odata, 2048* sizeof(double));        
    cudaMemcpy( Ad, A , Ntot* sizeof(double), cudaMemcpyHostToDevice);

    InitConstants();
    double ss = CudaSum( Ad,Ntot,Odata);

    cudaFree(Ad);
    cudaFree(Odata);
    return ss;
    
 
}

int GetMaxThreadsPerBlock()
{
  int value;
  cudaDeviceGetAttribute ( &value, cudaDevAttrMaxThreadsPerBlock , 0 ); 
  return value;
}

    
cudaDeviceProp prop;
int device;

extern int MaxThreadsPerBlock;
extern int MaxThreadsX;
extern int MaxThreadsY;

void InitConstants()
{
  if (MaxThreadsPerBlock == 0)
  {
    cudaGetDevice(&device);
    cudaGetDeviceProperties(&prop, device);

    MaxThreadsPerBlock = GetMaxThreadsPerBlock();

    MaxThreadsX = 16;
    while (MaxThreadsX*MaxThreadsX*4 <= MaxThreadsPerBlock) MaxThreadsX = MaxThreadsX*2;
    MaxThreadsY = MaxThreadsX ;
  }
  //if (ColorMask==0) ColorMask = 2;
}

void SetRgbMask(TMCstruct* mc, int mask)
{
  mc->SetRgbMask(mask);
}

void TMCstruct :: SetRgbMask(int mask)
{ 
  ColorMask = mask;
}

void SetSeed(TMCstruct* mc, int seed1)
{
  mc->SetSeed(seed1);
}

void TMCstruct :: SetSeed(int seed1)
{ 
  seed = seed1;
 
}

void InstallLogGaborFilter(TMCstruct* mc, double dtAR, double ss , double r0, double sr0, double stheta0)
{
  mc->InstallLogGaborFilter( dtAR, ss , r0, sr0, stheta0);
}

void TMCstruct :: InstallLogGaborFilter( double dtAR, double ss , double r0, double sr0, double stheta0)
{
  //AdjustLogGaborParams(r0,sr0,ss); en Pascal 
  InitConstants();
  InstallLogGaborFilterK( dtAR, ss , r0, sr0, stheta0);

}


double TestKernel(double* A,int Ntot, int testIterations,double* res)
{
	/*
StopWatchInterface *timer = 0;
sdkCreateTimer(&timer);
sdkResetTimer(&timer);

double* Ad;
double* Odata;
cudaMalloc((void**) &Ad, Ntot* sizeof(double));        
cudaMalloc((void**) &Odata, 256* sizeof(double));        

cudaMemcpy( Ad, A , Ntot* sizeof(double), cudaMemcpyHostToDevice);

InitConstants();

 
 for (int i = 0; i < testIterations; ++i)
    {

        cudaDeviceSynchronize();
        sdkStartTimer(&timer);

        // execute the kernel
         *res = CudaSum( Ad, Ntot, NULL);

        cudaDeviceSynchronize();
        sdkStopTimer(&timer);
    }


 float reduceTime =  sdkGetAverageTimerValue(&timer);

 sdkDeleteTimer(&timer);

 cudaFree(Ad);
 cudaFree(Odata);
 return reduceTime;
 */
	return 0.0;
}


void* InitMCpink(  int w, int h, int seed1, double* C0x, double* D0x, int Ncx, double Nfx, double Nf0x, int* error )
{
  TMCstruct* mc = new(TMCstruct);

  *error = mc->InitMCpink( w, h, seed1, C0x, D0x, Ncx, Nfx, Nf0x );
  return mc;
}

HRESULT TMCstruct :: InitMCpink( int w, int h, int seed1, double* C0x, double* D0x, int Ncx, double Nfx, double Nf0x )
{
    int res;
    
    InitConstants();
    
    Nx = w;
    Ny = h; 
    seed = seed1;
    
    
    Nc = Ncx;
    Nf = Nfx;
    Nf0 = Nf0x;

    AlphaTh=0;
    res = cudaMalloc( (void**)&Filter, w*h* sizeof(double));       
	if (res!=0) return res;
//    cudaMemcpy( Filter, filter1 , w*h* sizeof(double), cudaMemcpyHostToDevice);
     
    res = cudaMalloc((void**)&Noise, w*h* sizeof(double));    
    res = cudaMemset(Noise, 0, w*h* sizeof(double));
   
    res = cudaMalloc((void**)&Noise1, w*h* sizeof(double));    
    res = cudaMemset(Noise1, 0, w*h* sizeof(double));
                                         
    res = cudaMalloc((void**)&Noise2, w*h* sizeof(double));    
    res = cudaMemset(Noise2, 0, w*h* sizeof(double));
   
    res = cudaMalloc((void**)&C0, Nc* sizeof(double));    
    res = cudaMemcpy(C0, C0x , Nc* sizeof(double),cudaMemcpyHostToDevice);
    
    res = cudaMalloc((void**)&D0, Nc* sizeof(double));    
    res = cudaMemcpy(D0, D0x , Nc* sizeof(double),cudaMemcpyHostToDevice);
    
    res = cudaMalloc((void**)&LastF, w*h*Nc* sizeof(double));    
    res = cudaMemset(LastF, 0, w*h*Nc* sizeof(double));      

    res = cudaMalloc((void**)&fftNoise, w*h* sizeof(Complex));    
    res = cudaMemset(fftNoise, 0, w*h* sizeof(Complex));
    
    res = cudaMallocPitch(&LinearMem, &PitchMem, w * sizeof(char) * 4, h);    
    res = cudaMemset(LinearMem, 1, PitchMem * h);
    
    /////////////////////////
    res = cudaMalloc((void**)&Noise1_init, w*h* sizeof(double));    
    res = cudaMemset(Noise1_init, 0, w*h* sizeof(double));
    
    res = cudaMalloc((void**)&LastF_init, w*h*Nc* sizeof(double));    
    res = cudaMemset(LastF_init, 0, w*h*Nc* sizeof(double));
    
    res = cudaMalloc((void**)&Noise1_cont, w*h* sizeof(double));    
    res = cudaMemset(Noise1_cont, 0, w*h* sizeof(double));
    
    res = cudaMalloc((void**)&LastF_cont, w*h*Nc* sizeof(double));    
    res = cudaMemset(LastF_cont, 0, w*h*Nc* sizeof(double));
    
    res = curandCreateGenerator(&generator, CURAND_RNG_PSEUDO_DEFAULT);
    res = curandCreateGenerator(&RstGenerator, CURAND_RNG_PSEUDO_DEFAULT);
   
    cufftPlan2d(&fftPlan, Nx, Ny, CUFFT_Z2Z);
 
	res = cudaStreamCreate ( &streamK );   

    return 0;
}

int DoneKpink();


HRESULT  DoneMCpink(TMCstruct* mc)
{
  if (mc!=NULL)
  {
    mc->DoneMCpink();
    delete(mc);
  }
  return 0;
}

HRESULT TMCstruct :: DoneMCpink()
{       
    DoneKpink();

    int res;

    DoneMC2stim();
            
    
    res = cudaFree(Filter);
    Filter=NULL;
    
    res = cudaFree(Noise);
    Noise=NULL;
   
    res = cudaFree(Noise1);
    Noise1=NULL;
                 
    res = cudaFree(Noise2);
    Noise2=NULL;
  
    res = cudaFree(C0);
    C0=NULL;
  
    res = cudaFree(D0);
    D0=NULL;

    res = cudaFree(LastF);
    LastF=NULL;
        
    res = cudaFree(fftNoise);
    fftNoise=NULL;
   
    res = cudaFree(LinearMem);
    LinearMem = NULL;

    /////////////////////
    res = cudaFree(Noise1_init);
    Noise1_init=NULL;
    
    res = cudaFree(LastF_init);
    LastF_init=NULL;
    
    res = cudaFree(Noise1_cont);
    Noise1_cont=NULL;
    
    res = cudaFree(LastF_cont);
    LastF_cont=NULL;

    cudaStreamDestroy(streamK);
    streamK =0;
    curandDestroyGenerator(generator);
    generator = 0;
    curandDestroyGenerator(RstGenerator);
    RstGenerator = 0;
    cufftDestroy(fftPlan);
    fftPlan = 0;
  
    return S_OK;
}



int UpdateMCpink(TMCstruct* mc,boolean LaunchOnly)
{
  return mc->UpdateMCpink(LaunchOnly);
}

int TMCstruct :: UpdateMCpink(boolean LaunchOnly)
{
  cudaGraphicsResource *ppResources[1];                
  ppResources[0]=  cudaResource;
  cudaArray *cuArray;
  int res; 
  if (!LaunchOnly)
  {
	  // Attendre la fin du calcul déclenché sur l'image précédente
	  UpdateKpink2(streamK);
	  cudaStreamSynchronize(streamK);      
  

	  // Puis copier LinearMem dans la texture

	  res = cudaGraphicsMapResources( 1, ppResources, 0);
	  if (res!=0) return res;
               
	  res = cudaGraphicsSubResourceGetMappedArray(&cuArray, cudaResource, 0, 0);
               
  
	  res = cudaMemcpy2DToArray(
				cuArray, // dst array
				0, 0,    // offset
				LinearMem, PitchMem,       // src
				Nx*4*sizeof(char), Ny, // extent
				cudaMemcpyDeviceToDevice); // kind
               
        
	  cudaGraphicsUnmapResources(1, ppResources, 0);
	  cudaStreamSynchronize(0);
  }

  if (DoRestart)
  {
	   cudaMemcpyAsync( Noise1, Noise1_init , Nx*Ny* sizeof(double), cudaMemcpyDeviceToDevice, streamK);
       cudaMemcpyAsync( LastF, LastF_init , Nx*Ny*Nc* sizeof(double), cudaMemcpyDeviceToDevice, streamK);
    
       curandSetGeneratorOffset(RstGenerator, Nx*Ny*250 );
	   DoRestart = 0;
  }
  // Calcul du MC suivant en mode asynchrone ; le résultat est dans LinearMem
  UpdateKpink(streamK);

  return res;
}

int GetFrameKpink(TMCstruct* mc, double* p)
{
  return mc->GetFrameKpink(p);
}

int TMCstruct :: GetFrameKpink( double* p)
{
  UpdateKpink(0);
  UpdateKpink2(0);

  cudaMemcpy( p, Noise2 , Nx*Ny* sizeof(double), cudaMemcpyDeviceToHost);
  return 0;
}



int RestartNoise(TMCstruct* mc)
{
  return mc->RestartNoise();
}

int TMCstruct :: RestartNoise()
{  
  RstState = true;
  DoRestart = true;
  
  return 0;                                                                                
}

int ResumeNoise(TMCstruct* mc)
{
  return mc->ResumeNoise();
}

int TMCstruct :: ResumeNoise()
{
  int res =0;  

  RstState = false;
  
  return res;                                                                                
}


HRESULT InitMCpinkStim(TMCstruct* mc, cudaGraphicsResource* Resource)
{
  return mc->InitMCpinkStim(Resource);
}

HRESULT TMCstruct :: InitMCpinkStim(cudaGraphicsResource* Resource)
{   
  int res;
  cudaResource = Resource;    

  cudaStream_t    stream = 0;        
  cudaGraphicsResource *ppResources[1];                
  ppResources[0]=  cudaResource;       
  
  if (Resource!=NULL)
  {
    res = cudaGraphicsMapResources( 1, ppResources, stream);
    if (res!=0) return res;
               
    cudaArray *cuArray;

    res = cudaGraphicsSubResourceGetMappedArray(&cuArray, cudaResource, 0, 0);
               
    // On copie la texture dans LinearMem              4juin 2015; on a besoin de alpha
    res = cudaMemcpy2DFromArray(
              LinearMem, PitchMem,
              cuArray, 0, 0,                      
              Nx*4*sizeof(char), Ny, // extent
              cudaMemcpyDeviceToDevice); // kind
    
        
    cudaGraphicsUnmapResources(1, ppResources, stream);
  } 

  //res = InitKpink(aa,bb,Nt);

  UpdateKpink(streamK);
  UpdateKpink2(streamK);
  cudaStreamSynchronize(streamK);

  return res;
}

HRESULT InitializeMCpink(TMCstruct* mc,double* aa, double* bb, int* Nt)
{
  return mc->InitKpink( aa, bb, Nt);
}




void texFillRect(void* surface, double* tb, int width, int height, size_t pitch, float2* Pts, int k, float th);

double RectInTextureArea(cudaGraphicsResource* Resource, float2* Pts, int w, int h, int k, float th)
{
  cudaStream_t    stream = 0;
  void*        LinearMem;
  size_t       PitchMem;
  cudaArray *cuArray;    
  double* tb;
  float2* tbPts;

  cudaGraphicsResource *ppResources[1];
                
  ppResources[0]=  Resource;
                     
  int res = cudaGraphicsMapResources( 1, ppResources, stream);
  if (res!=0) return 0;
               
  res = cudaGraphicsSubResourceGetMappedArray(&cuArray, Resource, 0, 0);
  
  res = cudaMallocPitch(&LinearMem, &PitchMem, w * sizeof(char) * 4, h);    

  res = cudaMalloc( (void**)&tb, w*h* sizeof(double));        
  res = cudaMemset(tb, 0, w*h* sizeof(double));

  res = cudaMalloc( (void**)&tbPts, 4* sizeof(float2));        
  res = cudaMemset(tbPts, 0, 4* sizeof(float2));

  // Copier la texture dans LinearMem
  res =  cudaMemcpy2DFromArray(
            LinearMem, PitchMem,
            cuArray, 0, 0,                      
            w*4*sizeof(char), h, // extent
            cudaMemcpyDeviceToDevice); // kind
    
  // Copier le tableau de Pts en mémoire GPU
  res =  cudaMemcpy(tbPts,Pts,4*sizeof(float2),cudaMemcpyHostToDevice);


  InitConstants();
  texFillRect(LinearMem, tb, w, h, PitchMem, tbPts, k, th);
  double result = CudaSum(tb, w*h, NULL);

  res = cudaFree(LinearMem);
  LinearMem = NULL;

  res = cudaFree(tb);
  tb = NULL;

  res = cudaGraphicsUnmapResources(1, ppResources, stream);
  return result;
 
}

