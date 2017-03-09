
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// includes, project
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <cufft.h>
#include <curand.h>
#include <math.h>
#include "MC2.h"

#define PI 3.1415926536f


int MaxThreadsPerBlock;
int MaxThreadsX;
int MaxThreadsY;


// Conversion d'un vecteur réel en vecteur complexe
__global__ void
RealToCpx(const double *A, Complex *B, int numElements)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements)
    {
        B[i].x = A[i];
        B[i].y = 0;
    }    
}

// Conversion d'un vecteur complexe en vecteur réel
__global__ void
CpxToReal(const Complex *A, double *B, int numElements)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements)
    {
        B[i] = A[i].x;        
    }
}


// Multiplie point par point un vecteur complex par un vecteur réel 
__global__ void
MulCpx( Complex *A, const double *B, int numElements)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements)
    {
        A[i].x = A[i].x*B[i];
        A[i].y = A[i].y*B[i];
    }    
}

// Applique y = at*x +bt à chaque point d'un vecteur réel 
__global__ void
LinearTransform(double *A, int numElements, double at, double bt)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements)
    {
        A[i] = A[i]* at + bt;        
    }    
}




// Remplissage de la linearmem (tableau de pixels) associée à la texture avec le tableau de réel
// Alpha n'est pas modifié
__global__ void 
FillTex(void *surface, int width, int height, size_t pitch, double* src, int Mask)
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
        
    if (x >= width || y >= height) return;        
    
    double w = src[x + width*y];
    
    if (w<0) {w=0;}
    if (w>253) {w=253;}
                      
    
    pixel1 = (unsigned char *)( (char*)surface + y*pitch) + 4*x;
        
    //pixel1[3] = 255;                     // alpha = 255 sauf s'il fait partie du masque
    for (int i=0;i<4;i++)    
    {  if (Mask & (1<<i))  pixel1[i] = w;  } 
}

// Remplissage de la linearmem (tableau de pixels) associée à la texture avec le tableau de bytes
// Alpha n'est pas modifié
__global__ void 
FillTexByte(void *surface, int width, int height, size_t pitch, char* src, int Mask)
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
        
    if (x >= width || y >= height) return;        
    
    char w = src[x + width*y];                      
    
    pixel1 = (unsigned char *)( (char*)surface + y*pitch) + 4*x;
        
    // alpha n'est pas modifié sauf s'il fait partie du masque
    for (int i=0;i<4;i++)    
    {  if (Mask & (1<<i))  pixel1[i] = w;  } 
}


// Remplissage de la linearmem (tableau de pixels) associée à la texture avec le tableau de réel
// Alpha autorise l'affichage au dessus d'un certain seuil
__global__ void 
FillTexTh(void *surface, int width, int height, size_t pitch, double* src, int Mask, int th, int pixValue)
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
        
    if (x >= width || y >= height) return;        
    
    double w = src[x + width*y];
    
    if (w<0) {w=0;}
    if (w>253) {w=253;}
                      
    
    pixel1 = (unsigned char *)( (char*)surface + y*pitch) + 4*x;
        
    if (pixel1[3]>=th) 
    for (int i=0;i<3;i++)    
    {  if (Mask & (1<<i))  pixel1[i] = w;  } 
    else
    for (int i=0;i<3;i++)    
    {  if (Mask & (1<<i))  pixel1[i] = pixValue >> (i*8);  } 
    
    
}


// Processus auto-régressif X2 = a*X1 + b*X0 + N0;
 
__global__ void 
AutoRegK(double* X0, double* X1, double* X2, double* N0, int numElements, double a, double b)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements)
    {   
      X2[i] = a*X1[i] + b*X0[i] + N0[i];
    }
}


// Expansion 
// On applique une interpolation bi-linéaire à la source
__global__ void Kernel_Expansion1(double *tb1, double *tb2, int width, int height, double Dx, double x0, double Dy, double y0  )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;
    
        
    if (x >= width || y >= height) return;

    
    double xt = (x-x0)/Dx +x0;
    double yt = (y-y0)/Dy +y0;
   
    int x1 = ((int) xt) % width ;
    int y1 = ((int) yt) % height;

    int xp1 = (x1+1) % width;
    int yp1 = (y1+1) % height;
    
    double z1 =   tb1[width*y1+x1];
    double z2 =   tb1[width*yp1+x1];
    double z3 =   tb1[width*yp1+xp1];
    double z4 =   tb1[width*y1+xp1];

    double dx =  xt-floorf(xt);
    double dy =  yt-floorf(yt); 

    double zp = z1+ dy*(z2-z1);
    double zq = z4+ dy*(z3-z4);
    double ZR = zp+ dx*(zq-zp);
            
    tb2[width*y+x] = ZR;    
   
}

// Transformation Cartesian To Polar
// On applique une interpolation bi-linéaire à la source
__global__ void Kernel_CartToPol1(double *tb1, double *tb2, int width, int height )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;
        
    if (x >= width || y >= height) return;        

    double R = 2* sqrtf( powf(x-width/2,2) + powf(y-height/2,2) );
    double theta = (atan2f( y-height/2 ,  x-width/2) +PI)*height/(2*PI);
  
    int x1 = ((int) R) % width ;
    int y1 = ((int) theta) % height;

    int xp1 = (x1+1) % width;
    int yp1 = (y1+1) % height;

    double z1 =   tb1[width*y1+x1];
    double z2 =   tb1[width*yp1+x1];
    double z3 =   tb1[width*yp1+xp1];
    double z4 =   tb1[width*y1+xp1];

    double dx =  theta-floorf(theta);
    double dy =  R-floorf(R); 

    double zp = 1.0*z1+ dy*(1.0*z2-z1);
    double zq = 1.0*z4+ dy*(1.0*z3-z4);
    double ZR = zp+ dx*(zq-zp);
  
    tb2[width*y+x] = ZR;  
   
}



int TMCstruct :: ComputeNoise(double* noise1, double* filter1, curandGenerator_t Agenerator, cudaStream_t stream )
{   

   //générer noise1 
   curandStatus_t res; 

   curandSetStream(Agenerator,stream);
   res = curandGenerateNormalDouble( Agenerator, noise1, Nx * Ny, mu, sigma);    

   //transformer noise1 en complexes 
   RealToCpx<<< Nx, Ny, 0, stream>>>(noise1,fftNoise ,Nx * Ny);
   // DFT de noise1==> fftNoise

   cufftSetStream(fftPlan,stream);
   cufftExecZ2Z(fftPlan, (Complex *)fftNoise, (Complex *)fftNoise, CUFFT_FORWARD );

   // multiplier fftNoise par filter                                  
   MulCpx<<<Nx,Ny,0, stream>>>(fftNoise,filter1,Nx*Ny);
  
   // DFT inverse du résultat
   cufftExecZ2Z(fftPlan, (Complex *)fftNoise, (Complex *)fftNoise, CUFFT_INVERSE );
    
   // La partie réelle donne noise
   CpxToReal<<<Nx,Ny,0,stream>>>(fftNoise, noise1,Nx*Ny);

   return 0;
}


int TMCstruct :: Autoreg()
{
  AutoRegK<<<Nx,Ny>>>( Xn0, Xn1, Xn2, Noise, Nx*Ny, aReg, bReg);

  if ( DxF !=1.0f || DyF !=1.0f ) 
  {
    dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                   // block dimensions are fixed to be 256 threads
    dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
    Kernel_Expansion1<<<Dg,Db>>>(Xn1, Xn0, Nx, Ny, DxF, X0F, DyF, Y0F  );
    Kernel_Expansion1<<<Dg,Db>>>(Xn2, Xn1, Nx, Ny, DxF, X0F, DyF, Y0F  );
  }
  else
  {
    cudaMemcpy( Xn0, Xn1, Nx*Ny*sizeof(double),cudaMemcpyDeviceToDevice);
    cudaMemcpy( Xn1, Xn2, Nx*Ny*sizeof(double),cudaMemcpyDeviceToDevice);    
  }
  return 0;
}

                            



extern "C"    {
  int InitK2();
  int DoneK2();
  int UpdateK2();
}


// Texture reference for 2D float texture
texture< uchar4, 2, cudaReadModeNormalizedFloat /*cudaReadModeElementType*/> tex;

__global__ void Kernel_CartToPol2( unsigned char *surface2, int width, int height, size_t pitch )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel2;

        
    if (x >= width || y >= height) return;
    
    float u = x / (float) width;
    float v = y / (float) height;

    
    float tu = 2* sqrtf( powf(u-0.5,2) + powf(v-0.5,2) );  //R
    float tv = (atan2f( v-0.5 ,  u-0.5) +PI)/(2*PI);       //theta  
          

    pixel2 = (unsigned char *)(surface2 + y*pitch) + 4*x;
        
    pixel2[1] = 255.0* tex2D(tex, tu, tv).y; 
   
}


extern "C"  int CartToPolK2(cudaArray *cuArray ,void *surface2, int width, int height, size_t pitch)
{
       
        // Set texture parameters
    tex.addressMode[0] = cudaAddressModeWrap;
    tex.addressMode[1] = cudaAddressModeWrap;
    tex.filterMode = cudaFilterModeLinear;
    tex.normalized = true;    // access with normalized texture coordinates
       
    int error =0;  
    int res;
   
    cudaChannelFormatDesc channelDesc;
    res= cudaGetChannelDesc(&channelDesc, cuArray);
    if  ( res!=0 && error==0) error=1;

    res= cudaBindTextureToArray( tex, cuArray, channelDesc);
    if  ( res!=0 && error==0) error=2;
    
    dim3 Db = dim3(MaxThreadsX, MaxThreadsX );                   // block dimensions are fixed to be 256 threads
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_CartToPol2<<<Dg,Db>>>( (unsigned char *)surface2, width, height, pitch );

    
    res= cudaUnbindTexture(tex);
    if  ( res!=0 && error==0) error=3;
      
    //error =  channelDesc.x + channelDesc.y*100+ + channelDesc.z*10000+ channelDesc.w*1000000  ;
    return error;
    //error = cudaGetLastError();

   
}




int TMCstruct :: ComputeNoise2( Complex* fftNoise1, double* filter1)
{   
   //générer noise1 
   mu=0;
   sigma=1;
   curandStatus_t res = curandGenerateNormalDouble( generator, Noise, Nx*Ny, mu, sigma);
   //transformer Noise en complexes 
   RealToCpx<<<Nx,Ny>>>(Noise, fftNoise1 ,Nx*Ny);
   // DFT de noise1==> fftNoise
   cufftExecZ2Z(fftPlan, (Complex *)fftNoise1, (Complex *)fftNoise1, CUFFT_FORWARD );

   // multiplier fftNoise par filter
   MulCpx<<<Nx,Ny>>>(fftNoise1,filter1,Nx*Ny);
  
   
   return 0;
}


// Processus auto-régressif Xf2 = a*Xf1 + b*Xf0 + Nf0;
 
__global__ void 
AutoRegK2(Complex* Xf0, Complex* Xf1, Complex* Xf2, Complex* Nf0, int numElements, double* a, double* b, double* c)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElements)
    {   
      Xf2[i].x = a[i]*Xf1[i].x + b[i]*Xf0[i].x + c[i]*Nf0[i].x;
      Xf2[i].y = a[i]*Xf1[i].y + b[i]*Xf0[i].y + c[i]*Nf0[i].y;

    }
}

int TMCstruct :: Autoreg2()
{
  AutoRegK2<<<Nx,Ny>>>(Xnf0, Xnf1, Xnf2, fftNoise, Nx*Ny, afReg, bfReg, cfReg);

  cudaMemcpy( Xnf0, Xnf1, Nx*Ny*sizeof(Complex), cudaMemcpyDeviceToDevice);
  cudaMemcpy( Xnf1, Xnf2, Nx*Ny*sizeof(Complex), cudaMemcpyDeviceToDevice);    

  return 0;
}


int TMCstruct :: InitK2() 
{
  curandStatus_t curandResult = curandCreateGenerator(&generator, CURAND_RNG_PSEUDO_DEFAULT);
  curandSetPseudoRandomGeneratorSeed( generator, seed);

  //if (curandResult != CURAND_STATUS_SUCCESS)  { }

  cufftPlan2d(&fftPlan, Nx, Ny, CUFFT_Z2Z);

  //ComputeNoise2(Xnf1, Filter);
  //ComputeNoise2(Xnf0, Filter);

  for (int i=0;i<500*Nsample;i++)
  {
    ComputeNoise2( fftNoise,Filter);
    Autoreg2();
  }
  return 0;
}

int TMCstruct :: DoneK2()
{
  if (generator!=NULL)
  {
  curandDestroyGenerator(generator);
  cufftDestroy(fftPlan);

  generator = NULL;
  fftPlan = NULL;
  }
  return 0;
}


int TMCstruct :: UpdateK2()
{
  for (int i=0;i< Nsample; i++)  
  {
    ComputeNoise2(fftNoise, Filter);
    Autoreg2();
  }

  cufftExecZ2Z(fftPlan, Xnf2, Xnf2, CUFFT_INVERSE );
    
   // La partie réelle donne noise
  CpxToReal<<<Nx,Ny>>>(Xnf2, Noise,Nx*Ny);

  dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                   
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
  
  // Normaliser la DFT inverse: multiplication par  1.0/(Nx*Ny)  
  // et règler la valeur moyenne et l'amplitude
  //LinearTransform<<<Nx,Ny>>>(Noise ,Nx*Ny , 1.0/(Nx*Ny), 0);
  LinearTransform<<<Nx,Ny>>>(Noise ,Nx*Ny , Atransform/(1.0*Nx*Ny), Btransform);
  FillTex<<<Dg,Db>>>(LinearMem,Nx,Ny,PitchMem,Noise,ColorMask);
  return 0;
}



__global__ void Ksum(double* A, double* outD, int Ntot, int NbU)
{
  int idx = threadIdx.x;
  int Bidx = blockIdx.x;

  int Nthread = blockDim.x; 
  int Nblock = gridDim.x;
                          
    
  __shared__ double A0[4096];     // size = Nthread max 


  int i0 = Bidx*Nthread*NbU+ idx*NbU;
  A0[idx]=0;
  for (int i=0; i<NbU;i++) { if (i0+i<Ntot) A0[idx]+= A[i0+i];} 

  __syncthreads();
 
  if (idx==0)
  {
   outD[Bidx] =0;
   for (int i=0;i< Nthread;i++){outD[Bidx] += A0[i]; }
  }

}



double CudaSum(double* A, int Ntot,double* Odata)
{ 
  double tbres[2048];
  double res;
  double* Odata1;

  int Nthread =  MaxThreadsPerBlock;
  int Nblock =1024;

  while ((Nthread*Nblock>Ntot)&&(Nblock>1)) Nblock = Nblock/2;  
  int NbU = Ntot/(Nthread*Nblock);
  if (Ntot % (Nthread*Nblock) !=0) {NbU++;}

  
  while ((Nblock>NbU)&&(Nblock>1)) {
    Nblock = Nblock/2;  
    NbU = NbU*2;
  }
  
  if (Odata !=NULL) Odata1=Odata; else cudaMalloc((void**) &Odata1, Nblock* sizeof(double));        
  
  Ksum<<<Nblock,Nthread>>>(A,Odata1,Ntot,NbU);    
  cudaMemcpy(tbres,Odata1,Nblock*sizeof(double),cudaMemcpyDeviceToHost);
  
  if (Odata == NULL) cudaFree(Odata1);

  res = 0;
  for (int i=0;i<Nblock;i++) res+=tbres[i];
  return res;
}

__global__ void KSqrSum(double* A, double* outD, int Ntot, int NbU)
{
  int idx = threadIdx.x;
  int Bidx = blockIdx.x;

  int Nthread = blockDim.x; 
  int Nblock = gridDim.x;
                          
    
  __shared__ double A0[4096];     // size = Nthread max 


  int i0 = Bidx*Nthread*NbU+ idx*NbU;
  A0[idx]=0;
  for (int i=0; i<NbU;i++) { if (i0+i<Ntot) A0[idx]+=  A[i0+i]*A[i0+i];} 

  __syncthreads();
 
  if (idx==0)
  {
   outD[Bidx] =0;
   for (int i=0;i< Nthread;i++){outD[Bidx] += A0[i]; }
  }

}



double CudaSqrSum(double* A, int Ntot,double* Odata)
{ 
  double tbres[2048];
  double res;
  double* Odata1;

  int Nthread =  MaxThreadsPerBlock;
  int Nblock =1024;

  while ((Nthread*Nblock>Ntot)&&(Nblock>1)) Nblock = Nblock/2;  
  int Nb = Ntot/(Nthread*Nblock);
  if (Ntot % (Nthread*Nblock) !=0) {Nb++;}

  
  while ((Nblock>Nb)&&(Nblock>1)) {
    Nblock = Nblock/2;  
    Nb = Nb*2;
  }
  
  if (Odata !=NULL) Odata1=Odata; else cudaMalloc((void**) &Odata1, Nblock* sizeof(double));        
  
  KSqrSum<<<Nblock,Nthread>>>(A,Odata1,Ntot,Nb);    
  cudaMemcpy(tbres,Odata1,Nblock*sizeof(double),cudaMemcpyDeviceToHost);
  
  if (Odata == NULL) cudaFree(Odata1);

  res = 0;
  for (int i=0;i<Nblock;i++) res+=tbres[i];
  return res;
}


__global__ void KGaborFilter1(double* filter, double* Vr, int width, int height, double ss , double r0, double sr0, double stheta0 )
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int j = blockIdx.y*blockDim.y + threadIdx.y;
            
    if (i >= width || j >= height) return;

    double x = i;
    double y = j;

    if (i> width/2)  x = width-i;
    if (j> height/2) y = height-j;
    
    #define Eps 1E-6;
    double r = sqrt(x*x+ y*y)+Eps;

    double theta;
    if (x>0) theta= atan2( y, x); else theta = PI/2;

    //double ff =  exp( cos(2*theta)/stheta0 )                                                          
    //             *
    //             exp(-0.5*pow(log(r/r0),2)/log(1+pow(sr0,2))) * pow(r0/r,3)*ss*r;
    
	// Correction Jonathan 7-12-16
	double ff =  exp( cos(2*theta)/(4*pow(stheta0,2) ) )                                                          
                 *
                 exp(-0.5*pow(log(r/r0),2)/log(1+pow(sr0,2))) * pow(r0/r,3)*4*pow(ss*r,3);
                 

    filter[i+j*width] = ff;    
    if (i>0 || j>0) Vr[i+j*width] =  ff/(4*pow(ss*r,3)); else Vr[i+j*width] = 0;
    

}


__global__ void KGaborFilter2(double* filter, int NumElements, double fMul )
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;

    if (i >NumElements) return;

    filter[i] = sqrt(filter[i]*fMul);
}


__global__ void  KparamAR(double* a, double* b, double* c, double ss, double dtAR, int width, int height)
{
    #define eps 1E-12;

    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int j = blockIdx.y*blockDim.y + threadIdx.y;
            
    if (i >= width || j >= height) return;
   
    int  x= i;
    int  y= j;

    if (i> width/2)  x = width-i;
    if (j> height/2) y = height-j;
  
    double r = sqrt( (double)x*x + (double)y*y )+Eps;

    a[i+j*width] =  2-dtAR*2*ss*r- pow(dtAR*ss*r,2);
    b[i+j*width] = -1+dtAR*2*ss*r;
    // c[i+j*width] =  50* pow(dtAR,2);
	// Correction Jonathan 7-12-16
	c[i+j*width] =  1;
  
}

void InitConstants();

void TMCstruct :: InstallLogGaborFilterK(double dtAR, double ss , double r0, double sr0, double stheta0)
{  
  dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
  KparamAR<<<Dg,Db>>>(afReg,bfReg,cfReg,ss,dtAR,Nx,Ny);

  double fN;
  KGaborFilter1<<<Dg,Db>>>(Filter,Vdum ,Nx,Ny ,ss ,r0, sr0, stheta0);
    
  fN = CudaSum(Vdum,Nx*Ny,NULL);
  
 // KGaborFilter2<<<Nx,Ny>>>(Filter,Nx*Ny, Nx*Ny/dtAR/fN);
  // Correction Jonathan 7-12-16
  KGaborFilter2<<<Nx,Ny>>>(Filter,Nx*Ny, Nx*Ny*pow(dtAR,3)/fN);
} 

__global__ void 
AutoRegPinkK(double* X0, double* X1, double* Y, double* C0, double* D0, double* LastF, int numElts, int Nc)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < numElts)
    {    
      for (int j=0; j<Nc; j++)
        LastF[j*numElts+i] = (X0[i]+X1[i])*D0[j] - C0[j]*LastF[j*numElts+i];
      
      double w = 0;
      for (int j=0; j<Nc; j++) w = w+ LastF[j*numElts+i];  
      Y[i] = w;     
    }
}
      
int TMCstruct :: AutoregPink(double* Noise1, double* LastF, cudaStream_t stream)
{
  AutoRegPinkK<<<(Nx*Ny+MaxThreadsPerBlock-1)/MaxThreadsPerBlock,MaxThreadsPerBlock, 0, stream>>>(Noise, Noise1, Noise2, 
                                                                                       C0, D0, LastF, Nx*Ny, Nc);

  cudaMemcpyAsync( Noise1, Noise, Nx*Ny*sizeof(double), cudaMemcpyDeviceToDevice, stream); 
  
  return 0;
}

int TMCstruct :: UpdateKpink(cudaStream_t stream)
{
  if (RstState) ComputeNoise(Noise, Filter, RstGenerator, stream);  
  else ComputeNoise(Noise, Filter, generator, stream);   

  if (RstState) 
     AutoregPink(Noise1,LastF, stream);
     else AutoregPink(Noise1_cont,LastF_cont, stream);
  
  return 0;
}

int TMCstruct :: UpdateKpink2(cudaStream_t stream)
{
  dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                  
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
  LinearTransform<<<Nx,Ny,0, stream>>>(Noise2, Nx*Ny , Atransform, Btransform);

  if (AlphaTh>0)  FillTexTh<<<Dg,Db,0, stream>>>(LinearMem,Nx,Ny,PitchMem,Noise2,ColorMask,AlphaTh,AlphaThV );
  else FillTex<<<Dg,Db,0,stream>>>(LinearMem,Nx,Ny,PitchMem,Noise2,ColorMask );
               
  return 0;
}


int TMCstruct :: InitKpink(double* aa, double* bb, int* Nt)
{
  cudaStream_t    stream = 0;

  mu = 0;
  sigma = 1;
  curandStatus_t curandResult;
  
  curandSetStream(generator, stream);
  curandSetStream(RstGenerator, stream);

  curandSetPseudoRandomGeneratorSeed( generator, seed);
  curandSetPseudoRandomGeneratorSeed( RstGenerator, seed);
    
  //cufftSetStream(fftPlan, stream);
 
  *aa=0;
  *bb=0;
  *Nt=0;
  for (int i=0;i<250;i++)
  {
    ComputeNoise(Noise,Filter, generator,0);
    AutoregPink(Noise1, LastF,0);
    if (i>=50)
    {
    *aa = *aa + CudaSum(Noise2,Nx*Ny,NULL);
    *bb = *bb + CudaSqrSum(Noise2,Nx*Ny,NULL);
    *Nt = *Nt+1;
    }
  }
    
  *Nt = *Nt*Nx*Ny; 

  curandSetGeneratorOffset(generator, Nx*Ny*250 );

  cudaMemcpy( Noise1_init, Noise1 , Nx*Ny* sizeof(double), cudaMemcpyDeviceToDevice);
  cudaMemcpy( LastF_init, LastF,    Nx*Ny*Nc* sizeof(double), cudaMemcpyDeviceToDevice);
  
  cudaMemcpy( Noise1_cont, Noise1 , Nx*Ny* sizeof(double), cudaMemcpyDeviceToDevice);
  cudaMemcpy( LastF_cont, LastF,    Nx*Ny*Nc* sizeof(double), cudaMemcpyDeviceToDevice);
  
  return 0;
}

int TMCstruct :: DoneKpink()
{
  
  return 0;
}


// On remplit tb avec 1 pour les pixels situés dans le quadrilatère Pts et tels que pixel[k]>=th
// k= 0,1,2,3
__global__ void 
KtexFillRect(void* surface, double* tb, int width, int height, size_t pitch, float2* Pts, int k, float th)
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
        
    if (x >= width || y >= height) return;        
    
    pixel1 = (unsigned char *)( (char*)surface + y*pitch) + 4*x;

    if ( 
        ((Pts[1].y-Pts[0].y)*(x-Pts[0].x)-( y-Pts[0].y)*(Pts[1].x-Pts[0].x)>=0)
        &&
        ((Pts[2].y-Pts[1].y)*(x-Pts[1].x)-( y-Pts[1].y)*(Pts[2].x-Pts[1].x)>=0)
        &&
        ((Pts[3].y-Pts[2].y)*(x-Pts[2].x)-( y-Pts[2].y)*(Pts[3].x-Pts[2].x)>=0)
        &&
        ((Pts[0].y-Pts[3].y)*(x-Pts[3].x)-( y-Pts[3].y)*(Pts[0].x-Pts[3].x)>=0)
        &&
        (pixel1[k]>=th)
        ) 
        tb[x + width*y] = 1;
           
        
    
}

void texFillRect(void* surface, double* tb, int width, int height, size_t pitch, float2* Pts, int k, float th)
{
  dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                   
  dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

  KtexFillRect<<<Dg,Db>>>( surface, tb, width, height, pitch, Pts, k,  th); 
  
}

int FillByteTexture(void* LinearMem, int Nx, int Ny, size_t PitchMem, char* Image, int ColorMask)
{
  dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                   
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
    
  FillTexByte<<<Dg,Db>>>(LinearMem,Nx,Ny,PitchMem,Image,ColorMask);
  return 0;
}
