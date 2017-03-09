#define TRANSFORM1_API __declspec(dllexport) 

#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>
#endif
#include <d3d9.h>

#include <math.h>              

#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>

#include "CudaUtil.h"
#include "Transform1.h"


typedef double2 Complex;

extern "C" {
  TRANSFORM1_API Ttransform* InitTransform( cudaGraphicsResource *Src, cudaGraphicsResource *Dest);   

  TRANSFORM1_API int DoneTransform(Ttransform* ptf); 
            
  TRANSFORM1_API int TransformCartToPol1(Ttransform* ptf, int BK);

  TRANSFORM1_API int WaveTransform1(Ttransform* ptf, float Amp, float a, float b, float tau, int x0, int y0, 
                               int yref, int RgbMask, int btheta);

  TRANSFORM1_API void InitSrcRect( Ttransform* ptf, int x, int y, int w, int h);
  TRANSFORM1_API void InitDestRect( Ttransform* ptf, int x, int y, int w, int h);
  TRANSFORM1_API void InitDumRect( Ttransform* ptf );  
  TRANSFORM1_API void InitCenters( Ttransform* ptf, float x1, float y1, float x2, float y2);
  TRANSFORM1_API int BltSurface(Ttransform* ptf,  float x0, float y0,float theta, float ax, float ay,
                     int AlphaMode, int LumMode,  int *Alpha1, int *Lum1,
                     int Mask);
  TRANSFORM1_API int SmoothSurface( Ttransform* ptf, int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref);
  TRANSFORM1_API int PixSum( Ttransform* ptf, int comp, int ref);

  TRANSFORM1_API void SetStream0(Ttransform* ptf, cudaStream_t stream);

  TRANSFORM1_API int BuildRings1(Ttransform* ptf, float AmpBase, float Amp, float a, float b, float tau, int x0, int y0, int RgbMask, int mode);
}

void InitCuda1();

Ttransform :: Ttransform()
{
  SrcResource = NULL;
  DestResource = NULL;
  woffset1 = 0;
  hoffset1 = 0;
  width1 = 0;
  height1 = 0;

  woffset2 = 0;
  hoffset2 = 0;
  width2 = 0;
  height2 = 0;

  LinearMem1 = 0;
  LinearMem2 = 0;
  LinearMemDum = 0;
  InitCuda1();
  stream0 = 0;
}

Ttransform* InitTransform(cudaGraphicsResource *Src, cudaGraphicsResource *Dest)
{ 
  Ttransform* p = new(Ttransform);
  p->Init(Src, Dest);
  return p;
}

void Ttransform :: Init(cudaGraphicsResource *Src, cudaGraphicsResource *Dest)
{
  SrcResource = Src;
  DestResource = Dest; 
}

int DoneTransform(Ttransform* ptf)
{
  return ptf->Done();
}

int Ttransform :: Done()
{      
  int res;
  res = cudaFree(LinearMem1);    
  LinearMem1=NULL;
    
  res = cudaFree(LinearMem2);    
  LinearMem2=NULL;
  
  res = cudaFree(LinearMemDum);    
  LinearMemDum=NULL;
  
  return 0;
}

void CartToPolK1(void *surface1,void *surface2, int width, int height, size_t pitch, int BK);

int Ttransform :: TransformCartToPol1(int BK)
{               
        cudaArray *cuArraySrc = NULL;
        cudaArray *cuArrayDest= NULL;

        int res = cudaGraphicsSubResourceGetMappedArray(&cuArrayDest, DestResource, 0, 0);
        if (res!=0) return res;
        if (SrcResource != NULL) res = cudaGraphicsSubResourceGetMappedArray(&cuArraySrc, SrcResource, 0, 0);
        else cuArraySrc = cuArrayDest;
        
        res = cudaMemcpy2DFromArray(                         // Copier la source dans LinearMem1
            LinearMem1, PitchMem1,
            cuArraySrc, woffset1*4*sizeof(char), hoffset1,                      
            width1*4*sizeof(char), height1, 
            cudaMemcpyDeviceToDevice); 
        if (res!=0) return res;                     
        
        CartToPolK1( LinearMem1, LinearMem2, width1, height1, PitchMem1, BK );     // Appeler le Kernel
        
        res = cudaMemcpy2DToArray(                            // Copier le résultat dans la destination   
            cuArrayDest,   
            woffset1*4*sizeof(char), hoffset1,                      
            LinearMem2, PitchMem2,       
            width1*4*sizeof(char), height1, 
            cudaMemcpyDeviceToDevice); 

        return res;
}

int TransformCartToPol1(Ttransform* ptf, int BK)
{
  return ptf->TransformCartToPol1( BK);
}

void WaveTransformK1( void *surface1,void *surface2, int width, int height, size_t pitch, 
                      float Amp, float a, float b, float Rt, int x0, int y0, int yref, int RgbMask );
void WaveTransformK2( void *surface1,void *surface2, int width, int height, size_t pitch, 
                      float Amp, float a, float b, int x0, int y0, int yref, int RgbMask );

int Ttransform :: WaveTransform1( float Amp, float a, float b, float Rt, int x0, int y0, int yref, int RgbMask, int btheta)
{               
        cudaArray *cuArraySrc = NULL;
        cudaArray *cuArrayDest= NULL;

        int res = cudaGraphicsSubResourceGetMappedArray(&cuArrayDest, DestResource, 0, 0);
        if (res!=0) return res;
        if (SrcResource != NULL) res = cudaGraphicsSubResourceGetMappedArray(&cuArraySrc, SrcResource, 0, 0);
        else cuArraySrc = cuArrayDest;
        
        res = cudaMemcpy2DFromArray(
            LinearMem1, PitchMem1,
            cuArraySrc, woffset1*4*sizeof(char), hoffset1,                      
            width1*4*sizeof(char), height1, 
            cudaMemcpyDeviceToDevice); 
        if (res!=0) return res;
       
        res = cudaMemcpy2DFromArray(
            LinearMem2, PitchMem2,
            cuArraySrc, woffset1*4*sizeof(char), hoffset1,                      
            width1*4*sizeof(char), height1, 
            cudaMemcpyDeviceToDevice); 
        if (res!=0) return res;
       

        if (btheta) WaveTransformK2( LinearMem1, LinearMem2, width1, height1, PitchMem1, 
                         Amp,a,b,x0-woffset1,y0-hoffset1, yref, RgbMask );     
        else
        WaveTransformK1( LinearMem1, LinearMem2, width1, height1, PitchMem1, 
                         Amp,a,b,Rt,x0-woffset1,y0-hoffset1, yref, RgbMask );     
        
        res = cudaMemcpy2DToArray(
            cuArrayDest, // dst array
            woffset1*4*sizeof(char), hoffset1,                      
            LinearMem2, PitchMem2,       // src
            width1*4*sizeof(char), height1, // extent
            cudaMemcpyDeviceToDevice); // kind

        return res;
}

  int WaveTransform1(Ttransform* ptf, float Amp, float a, float b, float tau, int x0, int y0, 
                               int yref, int RgbMask, int btheta)
  {
    return  ptf->WaveTransform1( Amp, a, b, tau, x0, y0, yref, RgbMask, btheta);
  }



void DispSurfaceOnSurface(void *surf1, int pitch1, int Nx1, int Ny1, 
                          void *surf2, int pitch2, int Nx2, int Ny2, 
                          float x0, float y0,float theta, float ax, float ay,
                          float xcSrc, float ycSrc, float xcDest, float ycDest,
                          int AlphaMode, int LumMode, Tint4 Lum, Tint4 Alpha,
                          int Mask, cudaStream_t stream);  
void DispTexOnSurface(    cudaArray *cuArraySrc , int Nx1, int Ny1, 
                          void *surf2, int pitch2, int Nx2, int Ny2, 
                          float x0, float y0,float theta, float ax, float ay,
                          float xcSrc, float ycSrc, float xcDest, float ycDest,
                          int AlphaMode, int LumMode, Tint4 Lum, Tint4 Alpha,
                          int Mask, cudaStream_t stream);  
 

void Ttransform :: InitSrcRect( int x, int y, int w, int h)
{   
  woffset1 = x;
  hoffset1 = y;
  width1 = w;
  height1 = h;

  int res;

  if (SrcResource != NULL)
  {
  res = cudaMallocPitch(&LinearMem1, &PitchMem1, w * sizeof(char) * 4, h);    
  res = cudaMemset(LinearMem1, 0, PitchMem1 * h);
  }
}


void InitSrcRect( Ttransform* ptf, int x, int y, int w, int h)
{
  ptf->InitSrcRect(x,y,w,h);
}


void Ttransform :: InitDumRect()
{ 
  int res;
  res = cudaMallocPitch(&LinearMemDum, &PitchMemDum, width1 * sizeof(char) * 4, height1);    
  res = cudaMemset(LinearMemDum, 0, PitchMemDum * height1); 
}

void InitDumRect( Ttransform* ptf)
{
  ptf->InitDumRect();
}

void Ttransform :: InitDestRect( int x, int y, int w, int h)
{   
  woffset2 = x;
  hoffset2 = y;
  width2 = w;
  height2 = h;

  int res;

  if (DestResource != NULL)
  {
  res = cudaMallocPitch(&LinearMem2, &PitchMem2, w * sizeof(char) * 4, h);    
  res = cudaMemset(LinearMem2, 0, PitchMem2 * h);
  }
}

void InitDestRect( Ttransform* ptf, int x, int y, int w, int h)
{
  ptf->InitDestRect(x,y,w,h);
}

void Ttransform :: InitCenters( float x1, float y1, float x2, float y2)
{   
  xcSrc = x1;
  ycSrc = y1;

  xcDest = x2;
  ycDest = y2;
}

void InitCenters( Ttransform* ptf, float x1, float y1, float x2, float y2)
{
  ptf->InitCenters(x1, y1, x2, y2);
}

int Ttransform :: BltSurface(  float x0, float y0,float theta, float ax, float ay,
                     int AlphaMode, int LumMode,  int *Alpha1, int *Lum1,
                     int Mask)

{
  int res0=0;
  int res;

  Tint4                   Lum;
  Tint4                   Alpha;
   
  for (int i=0;i<4;i++)
  {
	  Lum.w[i] = Lum1[i];
	  Alpha.w[i] = Alpha1[i];
  }
	 
  
  cudaArray *cuArraySrc = NULL;
  cudaArray *cuArrayDest= NULL;
 
  res = cudaGraphicsSubResourceGetMappedArray(&cuArrayDest, DestResource, 0, 0);
  if (res!=0) return res;
  if (SrcResource != NULL) res = cudaGraphicsSubResourceGetMappedArray(&cuArraySrc, SrcResource, 0, 0);
  else cuArraySrc = cuArrayDest;
  
  if ((LumMode==1) || (AlphaMode==1))
  {
  res = cudaMemcpy2DFromArrayAsync(
            LinearMem1, PitchMem1,
            cuArraySrc, woffset1*4*sizeof(char), hoffset1,                      
            width1*4*sizeof(char), height1, 
            cudaMemcpyDeviceToDevice,
			stream0); 
  if (res!=0) return res;
  }     
  res = cudaMemcpy2DFromArrayAsync(
            LinearMem2, PitchMem2,
            cuArrayDest, woffset2*4*sizeof(char), hoffset2,                      
            width2*4*sizeof(char), height2, 
            cudaMemcpyDeviceToDevice,
			stream0); 
  if (res!=0) return res;
  
  if ((LumMode==1) || (AlphaMode==1))
  DispSurfaceOnSurface(LinearMem1, PitchMem1, width1, height1, 
                       LinearMem2, PitchMem2, width2, height2, 
                       x0, y0,theta, ax, ay,
                       xcSrc, ycSrc,xcDest, ycDest,
                       AlphaMode, LumMode, Alpha, Lum,
                       Mask,stream0 );  
  
  else
  DispTexOnSurface(    cuArraySrc, width1, height1, 
                       LinearMem2, PitchMem2, width2, height2, 
                       x0, y0,theta, ax, ay,
                       xcSrc, ycSrc,xcDest, ycDest,
                       AlphaMode, LumMode, Alpha, Lum,
                       Mask, stream0);  

  res = cudaMemcpy2DToArrayAsync(
            cuArrayDest,
            woffset2*4*sizeof(char), hoffset2,                      
            LinearMem2, PitchMem2,            
            width2*4*sizeof(char), height2,   
            cudaMemcpyDeviceToDevice,
			stream0);        


  return res0;         // renvoie la première erreur
}

int BltSurface(Ttransform* ptf,  float x0, float y0,float theta, float ax, float ay,
                     int AlphaMode, int LumMode,  int *Alpha1, int *Lum1,
                     int Mask)
{
  return ptf->BltSurface( x0, y0, theta, ax, ay,                           
                          AlphaMode, LumMode, Alpha1, Lum1, Mask);
}



void SmoothSurf2(void *surf1, void *surf2, void *surfDum, int pitch, int Nx, int Ny, 
                               int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref, cudaStream_t stream);
void SmoothTex2(cudaArray *SrcArray, void *surf2, void *surfDum, int pitch, int Nx, int Ny, 
                               int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref,  cudaStream_t stream);


int Ttransform::SmoothSurface( int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref)
{

  cudaArray *cuArraySrc = NULL;
  cudaArray *cuArrayDest= NULL;
                                                                                                                                         
  int res = cudaGraphicsSubResourceGetMappedArray(&cuArrayDest, DestResource, 0, 0);
  if (res!=0) return res;
  if (SrcResource != NULL) res = cudaGraphicsSubResourceGetMappedArray(&cuArraySrc, SrcResource, 0, 0);
  else cuArraySrc = cuArrayDest;
  
  /*
  res = cudaMemcpy2DFromArray(
            LinearMem1, PitchMem1,
            cuArraySrc, woffset1*4*sizeof(char), hoffset1,                      
            width1*4*sizeof(char), height1, 
            cudaMemcpyDeviceToDevice); 
  if (res!=0) return res;
  */     
  res = cudaMemcpy2DFromArrayAsync(
            LinearMem2, PitchMem2,
            cuArrayDest, woffset2*4*sizeof(char), hoffset2,                      
            width2*4*sizeof(char), height2, 
            cudaMemcpyDeviceToDevice, stream0); 
  if (res!=0) return res;
  
 
  //SmoothSurf2(LinearMem1, LinearMem2, LinearMemDum, PitchMem2, width2, height2, N1, N2);  
  SmoothTex2(cuArraySrc, LinearMem2, LinearMemDum, PitchMem2, width2, height2, N1, N2, x0,y0,dmax, dmax2,ref, stream0);   
  
  res = cudaMemcpy2DToArrayAsync(
            cuArrayDest,
            woffset2*4*sizeof(char), hoffset2,                      
            LinearMem2, PitchMem2,            
            width2*4*sizeof(char), height2,   
            cudaMemcpyDeviceToDevice, stream0);        


  return res;
}
int SmoothSurface( Ttransform* ptf, int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref)
{
  return ptf->SmoothSurface( N1, N2,x0,y0,dmax,dmax2, ref);
}

int TexSum(cudaArray *SrcArray , int NtotX, int NtotY, int* Odata, int Comp, int ref );

  
int Ttransform::PixSum(int comp, int ref)
{
  cudaArray *SrcArray = NULL;
  
  int res = 0;
  if (SrcResource != NULL) res = cudaGraphicsSubResourceGetMappedArray(&SrcArray, SrcResource, 0, 0);
  
  if (res==0) res = TexSum( SrcArray , width1, height1, NULL, comp, ref );
  else res = -res;

  return res;
}

int PixSum( Ttransform* ptf, int comp, int ref)
{
  return ptf->PixSum(comp,ref);
}

void Ttransform::SetStream(cudaStream_t stream)
{ 
	stream0 = stream;
}


void SetStream0(Ttransform* ptf, cudaStream_t stream)
{ 
	ptf->SetStream(stream);
}


void BuildRingsK1( void *surface1, int width, int height, size_t pitch, 
                      float Amp, float a, float b, float Rt, int x0, int y0, float yref, int RgbMask, int mode );

int Ttransform :: Rings1( float AmpBase, float Amp, float a, float b, float Rt, int x0, int y0, int RgbMask, int mode)
{               
        cudaArray *cuArraySrc = NULL;
        cudaArray *cuArrayDest= NULL;

        int res = cudaGraphicsSubResourceGetMappedArray(&cuArrayDest, DestResource, 0, 0);
        if (res!=0) return res;
               		      
        BuildRingsK1( LinearMem2, width2, height2, PitchMem2, 
                         Amp,a,b,Rt,x0-woffset2,y0-hoffset2, AmpBase, RgbMask, mode );     
        
        res = cudaMemcpy2DToArray(
            cuArrayDest, // dst array
            woffset2*4*sizeof(char), hoffset2,                      
            LinearMem2, PitchMem2,       // src
            width2*4*sizeof(char), height2, // extent
            cudaMemcpyDeviceToDevice); // kind

        return res;
}

  int BuildRings1(Ttransform* ptf, float AmpBase, float Amp, float a, float b, float tau, int x0, int y0, int RgbMask, int mode)
  {
    return  ptf->Rings1( AmpBase, Amp, a, b, tau, x0, y0, RgbMask, mode);
  }
