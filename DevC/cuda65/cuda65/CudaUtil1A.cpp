

int MaxDimBlock1 = 0;
int MaxDimBlock2 = 0;

#include <cuda_runtime_api.h>

int GetMaxThreadsPerBlock()
{
  int value;
  cudaDeviceGetAttribute ( &value, cudaDevAttrMaxThreadsPerBlock , 0 ); 
  return value;
}

void InitCuda1()
{
  if (MaxDimBlock1>0) return;

  MaxDimBlock1 = GetMaxThreadsPerBlock();
  if (MaxDimBlock1>=4096)
    MaxDimBlock2 = 64;
  else
  if (MaxDimBlock1>=1024)
    MaxDimBlock2 = 32;
  else MaxDimBlock2 = 16;

}