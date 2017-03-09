#define CUDAMC1_API __declspec(dllexport) 



#include "ImageList1.h"

extern "C" {CUDAMC1_API TimageList* CreateImageList( int w, int h); }
extern "C" {CUDAMC1_API int FreeImageList( TimageList* p ); }
extern "C" {CUDAMC1_API int ImageList_Add( TimageList* p, char* image1 ); }
extern "C" {CUDAMC1_API int ImageList_UpdateTexture( TimageList* p, int n, cudaGraphicsResource* Resource ); }

TimageList :: TimageList() {
  
  MaxImage = 1000;
  Images = (char**) malloc(MaxImage);

  Nimage   = 0;
  Nx =       0;
  Ny =       0;
    
  
}

TimageList :: ~TimageList()
{
	cudaFree(LinearMem);
    LinearMem = NULL;

	ClearList();
    free( (void*) Images );
}

int TimageList :: Init( int Nbx, int Nby)
{
	Nx = Nbx;
	Ny = Nby;

	int res = cudaMallocPitch(&LinearMem, &PitchMem, Nx * sizeof(char) * 4, Ny);    
    return res;   
}

int TimageList :: AddImage(char* Image1)
{
  int res = cudaMalloc( (void**)&Images[Nimage], Nx*Ny* sizeof(char));    
  if (res==0) res = cudaMemcpy( Images[Nimage], Image1 , Nx*Ny* sizeof(char), cudaMemcpyHostToDevice);
  if (res==0) Nimage++;

  return res;
}
  
int TimageList :: ClearList()
{
	for (int i=0; i<Nimage; i++)
	{
		cudaFree(Images[i]);
		Images[i] = NULL;
	}
	Nimage = 0;
	return 0;
}

int FillByteTexture(void* LinearMem, int Nx, int Ny, size_t PitchMem, char* Image, int ColorMask);

int TimageList :: UpdateTexture( int n, cudaGraphicsResource* cudaResource)
{

  FillByteTexture(LinearMem, Nx, Ny, PitchMem, Images[n], ColorMask);

  cudaGraphicsResource *ppResources[1];
                
  ppResources[0]=  cudaResource;        
        
  int res = cudaGraphicsMapResources( 1, ppResources, 0);
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
               
        
  cudaGraphicsUnmapResources(1, ppResources, 0);
  return res;
}


TimageList* CreateImageList( int w, int h)
{
  TimageList* p = new(TimageList);
  int res = p->Init(w,h);
  
  return p;
} 

int FreeImageList( TimageList* p )
{
	delete(p);
	return 0;
} 

int ImageList_Add( TimageList* p, char* image1 )
{
	return p->AddImage(image1);
} 

int ImageList_UpdateTexture( TimageList* p, int n, cudaGraphicsResource* Resource )
{
	return p->UpdateTexture(n,Resource);
}








