#ifndef _Transform1_
#define _Transform1_


#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>
#include <curand.h>

typedef double2 Complex;

class Ttransform {   
  cudaGraphicsResource   *SrcResource;        //
  cudaGraphicsResource   *DestResource;       //
  int                     woffset1;            // zone de la source concernée
  int                     hoffset1; 
  int                     width1;
  int                     height1;

  int                     woffset2;            // zone de la source concernée
  int                     hoffset2; 
  int                     width2;
  int                     height2;

  float                   xcSrc;
  float                   ycSrc;

  float                   xcDest;
  float                   ycDest;

  void*                   LinearMem1;
  size_t                  PitchMem1;
  void*                   LinearMem2;
  size_t                  PitchMem2;
 
  void*                   LinearMemDum;
  size_t                  PitchMemDum;

public:
  Ttransform();    

  void Init(cudaGraphicsResource   *Src, cudaGraphicsResource   *Dest); 
  void InitSrcRect( int x, int y, int w, int h );  
  void InitDestRect( int x, int y, int w, int h);  
  void InitDumRect();  
  void InitCenters( float x1, float y1,float x2, float y2 );  

  int Done();
  int TransformCartToPol1( int BK);
  int WaveTransform1( float Amp, float a, float b, float Rt, int x0, int y0, int yref, int RgbMask, int btheta);

  int BltSurface(  float x0, float y0,float theta, float ax, float ay,
                   int AlphaMode, int LumMode,  int *Alpha1, int *Lum1,
                   int Mask);

  int SmoothSurface( int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref);

  int PixSum (int comp, int ref);
}; 


#endif
