#ifndef _MC2_
#define _MC2_

#include <stdlib.h>
#include <cuda_runtime_api.h>


class TimageList {   
  char**       Images;
  int          MaxImage;
  int          Nimage;
  int          Nx;
  int          Ny;
  int          ColorMask;
    
  float        Atransform;
  float        Btransform;

  void*        LinearMem;
  size_t       PitchMem;
  
  
  cudaStream_t    streamK;

  cudaGraphicsResource* cudaResource;

public:
  TimageList();
  ~TimageList();
  int Init( int Nbx, int Nby);
  int AddImage(char* Image1);
  
  int ClearList();

  int UpdateTexture( int n, cudaGraphicsResource* cudaResource);
}; 


#endif