
#define CUDAMC1_API __declspec(dllexport) 

#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>
#endif
#include <d3d9.h>

#include <math.h>              

#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>


extern "C" {CUDAMC1_API HRESULT InitRetina(IDirect3DTexture9 *p1, int w, int h, float* tbX, float* tbY, 
                                       float a1, float b1, float c1, float a2, float b2, float c2 ); 
           }
extern "C" {CUDAMC1_API HRESULT DoneRetina(); }

extern "C" {CUDAMC1_API int UpdateRetina();}
extern "C" {CUDAMC1_API int GetFrameRetina( float* p); }


