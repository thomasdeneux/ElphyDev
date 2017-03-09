

#define CUDA1_API __declspec(dllexport) 

#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>
#endif
#include <d3d9.h>
              
#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>



extern "C" {
  CUDA1_API HRESULT RegisterTransformSurface(IDirect3DTexture9 *p, cudaGraphicsResource   **cudaResource);
  CUDA1_API HRESULT UnRegisterTransformSurface(cudaGraphicsResource   *cudaResource);

  CUDA1_API HRESULT MapResources(cudaGraphicsResource **ppResources, int n);
  CUDA1_API HRESULT UnMapResources(cudaGraphicsResource **ppResources, int n);
}
 

HRESULT RegisterTransformSurface(IDirect3DTexture9 *p,cudaGraphicsResource   **cudaResource)
{   
  return  cudaGraphicsD3D9RegisterResource(cudaResource, p, cudaGraphicsRegisterFlagsNone);    
}

CUDA1_API HRESULT UnRegisterTransformSurface(cudaGraphicsResource   *cudaResource)
{   
  return cudaGraphicsUnregisterResource(cudaResource);
}

HRESULT MapResources(cudaGraphicsResource **ppResources, int n)
{    
        cudaStream_t    stream = 0;        
        return cudaGraphicsMapResources(n, ppResources, stream);
}

HRESULT UnMapResources(cudaGraphicsResource **ppResources, int n)
{    
        cudaStream_t    stream = 0;        
        return cudaGraphicsUnmapResources(n, ppResources, stream);
}



