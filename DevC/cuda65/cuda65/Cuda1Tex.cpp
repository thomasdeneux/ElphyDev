

#define CUDA1_API __declspec(dllexport) 

/*
// example:

extern "C" { CUDA1_API int cbVersion(void); }

int cbVersion()
{
    return 1234;
}
*/
#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>
#endif
#include <d3d9.h>

              

#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>

#include "CudaUtil.h"

extern "C" {CUDA1_API HRESULT InitCUDA(IDirect3DDevice9 *g); }       
extern "C" {CUDA1_API HRESULT ReleaseCUDA(); }

// Ces trois fonctions sont utilisées uniquement dans CudaTest (gratDX1)
extern "C" {CUDA1_API HRESULT RegisterTexture(IDirect3DTexture9 *p, int w, int h); }
extern "C" {CUDA1_API HRESULT UnRegisterTextures(); }
extern "C" {CUDA1_API int FillGrating();}

// DisplaySurface est utilisée par DisplayVSBM (peu utilisé)
extern "C" {CUDA1_API int DisplaySurface( cudaGraphicsResource *src, int Nx1, int Ny1, 
                     cudaGraphicsResource *dest, int Nx2, int Ny2, 
                     float x0, float y0,float theta, float ax, float ay,
                     float xcSrc, float ycSrc, float xcDest, float ycDest,
                     int AlphaMode, int LumMode, int *Alpha1, int *Lum1,
                     int Mask); 
           }



// Data structure for 2D texture shared between DX9 and CUDA
typedef struct TagTexture2D
{
    IDirect3DTexture9      *pTexture;
    cudaGraphicsResource   *cudaResource;    
    int                     width;
    int                     height;
} Ttexture2d;

void*                   LinearMem1;
size_t                  PitchMem1;

void*                   LinearMem2;
size_t                  PitchMem2;


Ttexture2d Texture2D;

// The CUDA kernel launchers that get called
extern "C"
{
    bool FillGrating1(void *surface, size_t width, size_t height, size_t pitch);
   
}


IDirect3DDevice9 *g_pD3DDevice;

HRESULT InitCUDA(IDirect3DDevice9 *g)
{

  int DevCount;
  int res =   cudaGetDeviceCount ( &DevCount ) ;

  if ((res==0) && (DevCount>0))
  {
    g_pD3DDevice = g;        

    res = cudaD3D9SetDirect3DDevice(g);
    return res;
    
    //if (res==0) return 0;

    //res = cudaDeviceReset();    
    //if (res==0) 
    //{ return cudaD3D9SetDirect3DDevice(g); }
    
  }
  else
  { return -1000; }
    
}

HRESULT ReleaseCUDA()
{       
    g_pD3DDevice = NULL;
    //cudaD3D9SetDirect3DDevice(NULL);
    return cudaDeviceReset();        
}


HRESULT RegisterTexture(IDirect3DTexture9 *p, int w, int h)
{
    int res;
    Texture2D.pTexture = p;
    Texture2D.width = w;
    Texture2D.height = h;

    res = cudaGraphicsD3D9RegisterResource(&Texture2D.cudaResource, p, cudaGraphicsRegisterFlagsNone);
    if (res!=0) return res;

    res = cudaMallocPitch(&LinearMem1, &PitchMem1, w * sizeof(char) * 4, h);    
    res = cudaMemset(LinearMem1, 1, PitchMem1 * h);
    
    if (1) 
    {
      res = cudaMallocPitch(&LinearMem2, &PitchMem2, w * sizeof(char) * 4, h);    
      res = cudaMemset(LinearMem2, 1, PitchMem2 * h);
    }
    
    return S_OK;
}


HRESULT UnRegisterTextures()
{       
    int res;
    res = cudaGraphicsUnregisterResource(Texture2D.cudaResource);
    if (res!=0) return res;
    
    res = cudaFree(LinearMem1);
    res = cudaFree(LinearMem2);
    
    LinearMem1=NULL;
    LinearMem2=NULL;

    return S_OK;
}


int DoCudaGrating()
{
        // On a besoin de cudaArray pour la copie
        cudaArray *cuArray;
        int res = cudaGraphicsSubResourceGetMappedArray(&cuArray, Texture2D.cudaResource, 0, 0);
        if (res!=0) return res;

        // Le kernel remplit cudaLinearMemory 
        FillGrating1(LinearMem1, Texture2D.width, Texture2D.height, PitchMem1 );     // t=0

        // puis on copie cudaLinearMemory dans la texture : cuArray est l'intermédiaire obligé
        res = cudaMemcpy2DToArray(
            cuArray, // dst array
            0, 0,    // offset
            LinearMem1, PitchMem1,       // src
            Texture2D.width*4*sizeof(char), Texture2D.height, // extent
            cudaMemcpyDeviceToDevice); // kind

        return res;
}

int FillGrating()
{
    //
    // map the resources we've registered so we can access them in Cuda
    // - it is most efficient to map and unmap all resources in a single call,
    //   and to have the map/unmap calls be the boundary between using the GPU
    //   for Direct3D and Cuda
    //

        cudaStream_t    stream = 0;
        
        cudaGraphicsResource *ppResources[1];
        
        ppResources[0]=  Texture2D.cudaResource;
           
      
        int res = cudaGraphicsMapResources( 1, ppResources, stream);
        if (res!=0) return res;
        
        // run kernels which will populate the contents of those textures        
        res= DoCudaGrating();
                
        // unmap the resources        
        cudaGraphicsUnmapResources(1, ppResources, stream);
        return res;
}   

void DispSurfaceOnSurface(void *surf1, int pitch1, int Nx1, int Ny1, 
                          void *surf2, int pitch2, int Nx2, int Ny2, 
                          float x0, float y0,float theta, float ax, float ay,
                          float xcSrc, float ycSrc, float xcDest, float ycDest,
                          int AlphaMode, int LumMode, Tint4 Lum, Tint4 Alpha,
                          int Mask, cudaStream_t stream);  
 

int DisplaySurface( cudaGraphicsResource *src, int Nx1, int Ny1, 
                     cudaGraphicsResource *dest, int Nx2, int Ny2, 
                     float x0, float y0,float theta, float ax, float ay,
                     float xcSrc, float ycSrc, float xcDest, float ycDest,
                     int AlphaMode, int LumMode,  int *Alpha1, int *Lum1,
                     int Mask, cudaStream_t stream)

{
  int res0=0;
  int res;
         
  cudaArray *cuArraySrc = NULL;
  cudaArray *cuArrayDest= NULL;

  void*                   LinearMem1;
  size_t                  PitchMem1;

  void*                   LinearMem2;
  size_t                  PitchMem2;

  Tint4                   Lum;
  Tint4                   Alpha;
    
  res = cudaMallocPitch(&LinearMem1, &PitchMem1, Nx1 * sizeof(char) * 4, Ny1);    
  res = cudaMemset(LinearMem1, 1, PitchMem1 * Ny1);
  res = cudaMallocPitch(&LinearMem2, &PitchMem2, Nx2 * sizeof(char) * 4, Ny2);    
  res = cudaMemset(LinearMem2, 1, PitchMem2 * Ny2);  
  
  for (int i=0;i<4;i++)
  {
	  Lum.w[i] = Lum1[i];
	  Alpha.w[i] = Alpha1[i];
  }

  res = cudaGraphicsSubResourceGetMappedArray(&cuArrayDest, dest, 0, 0);
  if (res!=0) return res;
  res = cudaGraphicsSubResourceGetMappedArray(&cuArraySrc, src, 0, 0);
  if (res!=0) return res;
  

  res = cudaMemcpy2DFromArray(
      LinearMem1, PitchMem1,
      cuArraySrc, 0, 0,                      
      Nx1*4*sizeof(char), Ny1, 
      cudaMemcpyDeviceToDevice); 
  if (res!=0) res0=res;

  res = cudaMemcpy2DFromArray(
      LinearMem2, PitchMem2,
      cuArrayDest, 0,0,                      
      Nx2*4*sizeof(char), Ny2, 
      cudaMemcpyDeviceToDevice); 
  if (res!=0) res0=res;
  
 
  DispSurfaceOnSurface(LinearMem1, PitchMem1, Nx1, Ny1, 
                       LinearMem2, PitchMem2, Nx2, Ny2, 
                       x0, y0,theta, ax, ay,
                       xcSrc, ycSrc, xcDest, ycDest,
                       AlphaMode, LumMode, Alpha, Lum,
                       Mask, 0 );  
   
  
  res = cudaMemcpy2DToArray(
      cuArrayDest, // dst array
      0,0,                      
      LinearMem2, PitchMem2, 
      Nx2*4*sizeof(char), Ny2,
      cudaMemcpyDeviceToDevice);
  if (res!=0) res0=res;

  res = cudaFree(LinearMem1);
  if (res!=0) res0=res;

  res = cudaFree(LinearMem2);
  if (res!=0) res0=res;
  

  return res0;         // renvoie la première erreur
}








