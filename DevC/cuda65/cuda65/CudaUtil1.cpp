

int MaxThreadsPerBlock=0;
int MaxThreadsX=0;
int MaxThreadsY=0;

#include <cuda_runtime_api.h>


extern "C" {
  __declspec(dllexport)  cudaStream_t CreateCudaStream( );   
  __declspec(dllexport)  void FreeCudaStream(cudaStream_t stream);
}

int GetMaxThreadsPerBlock()
{
  int value;
  cudaDeviceGetAttribute ( &value, cudaDevAttrMaxThreadsPerBlock , 0 ); 
  return value;
}

void InitCuda1()
{
  if (MaxThreadsPerBlock>0) return;

  MaxThreadsPerBlock = GetMaxThreadsPerBlock();
  if (MaxThreadsPerBlock>=4096)
    MaxThreadsX = 64;
  else
  if (MaxThreadsPerBlock>=1024)
    MaxThreadsX = 32;
  else MaxThreadsX = 16;

  MaxThreadsY = MaxThreadsX;
}


cudaStream_t CreateCudaStream( ){   
	cudaStream_t stream = 0;
	int  res = cudaStreamCreate ( &stream );   
	return stream;
}

void FreeCudaStream(cudaStream_t stream){
    cudaStreamDestroy(stream);
}