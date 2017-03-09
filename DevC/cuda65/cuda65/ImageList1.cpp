#define CUDAMC1_API __declspec(dllexport) 



#include "ImageList1.h"

extern "C" {CUDAMC1_API TimageList* CreateImageList( int w, int h); }
extern "C" {CUDAMC1_API int FreeImageList( TimageList* p ); }
extern "C" {CUDAMC1_API int ImageList_Add( TimageList* p, char* image1 ); }
extern "C" {CUDAMC1_API int ImageList_UpdateTexture( TimageList* p, int n, cudaGraphicsResource* Resource ); }
extern "C" {CUDAMC1_API void ImageList_setScaling( TimageList* p, float a1, float b1); }
extern "C" {CUDAMC1_API void ImageList_setMask( TimageList* p, int mask); } 


void InitCuda1();

TimageList :: TimageList() {
  
  MaxImage = 1000;
  Images = (unsigned char**) malloc(MaxImage*sizeof(char*));

  Nimage   = 0;
  Nx =       0;
  Ny =       0;

  a = 1.0;
  b = 0;
  ColorMask = 2;
  InitCuda1();
}

TimageList :: ~TimageList()
{
	cudaFree(LinearMem);
    LinearMem = NULL;

	ClearList();
    free(  Images );
}

int TimageList :: Init( int Nbx, int Nby)
{
	Nx = Nbx;
	Ny = Nby;

	int res = cudaMallocPitch(&LinearMem, &PitchMem, Nx * sizeof(char) * 4, Ny);    
	res = cudaMemset(LinearMem, 0, PitchMem * Ny);

    return res;   
}

int TimageList :: AddImage(char* Image1)
{
  if (Nimage<MaxImage)
	{
      int res = cudaMalloc( (void**)&Images[Nimage], Nx*Ny* sizeof(char));    
      if (res==0) res = cudaMemcpy( Images[Nimage], Image1 , Nx*Ny* sizeof(char), cudaMemcpyHostToDevice);
      if (res==0) Nimage++;
	  return res;
    }
  else return -1;
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

int FillByteTexture(void* LinearMem, int Nx, int Ny, size_t PitchMem, unsigned char* Image, int ColorMask, float a, float b);

int TimageList :: UpdateTexture( int n, cudaGraphicsResource* cudaResource)
{
  if (n>=Nimage) return -1;

  FillByteTexture(LinearMem, Nx, Ny, PitchMem, Images[n], ColorMask,a,b);

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

void TimageList :: SetScaling( float a1, float b1)
{
	a = a1;
	b = b1;
}

void TimageList ::SetMask(int mask)
{
	ColorMask = mask;
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

void ImageList_setScaling( TimageList* p, float a1, float b1)
{
	p->SetScaling(a1,b1);
}

void ImageList_setMask( TimageList* p, int mask)
{
	p->SetMask(mask);
}




