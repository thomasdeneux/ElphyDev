
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "CudaUtil.h"

#define PI 3.1415926536f


extern int MaxThreadsPerBlock;
extern int MaxThreadsX;
extern int MaxThreadsY;

 
__global__ void Kernel_FillGrating(unsigned char *surface, int width, int height, size_t pitch )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;
    char *pixel;

    // in the case where, due to quantization into grids, we have
    // more threads than pixels, skip the threads which don't
    // correspond to valid pixels
    if (x >= width || y >= height) return;

    // get a pointer to the pixel at (x,y)
    pixel = (char *)(surface + y*pitch) + 4*x;

    // populate it
	
	pixel[0] = 0;                          // red
    pixel[1] = 128 + 127*cos(2*PI/width*y);// green 
    pixel[2] = 0;                          // blue
    pixel[3] = 0;                          // alpha

}

extern "C"
void FillGrating1(void *surface, int width, int height, size_t pitch)
{
    cudaError_t error = cudaSuccess;

    dim3 Db = dim3(16, 16);                   // block dimensions are fixed to be 256 threads
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_FillGrating<<<Dg,Db>>>((unsigned char *)surface, width, height, pitch );

    error = cudaGetLastError();

   
}

__global__ void interpol(int z1, int z2, int z3, int z4,float dx, float dy,float* zr)
{
   float zp = z1+ dy*(z2-z1);
   float zq = z4+ dy*(z3-z4);
   *zr = zp+ dx*(zq-zp);
}

__global__ void Kernel_CartToPol1(unsigned char *surface1, unsigned char *surface2, int width, int height, size_t pitch, int BK )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (x >= width || y >= height) return;

    float ZR;
    pixel1 = (unsigned char *)(surface1 + y*pitch) + 4*x;
    if (pixel1[3] != 0) 
    {
    
    float R;
    float theta;
 

    //R = 2* sqrtf( powf(x-width/2,2) + powf(y-height/2,2) );
    //theta = (atan2f( y-height/2 ,  x-width/2) +PI)*height/(2*PI);
  
    R = 2* sqrtf( powf(x-width/2,2) + powf(y-height/2,2) );
    theta = (atan2f( y-height/2 ,  x-width/2) +PI)*height/(2*PI);
    
    if (R==0) {R=1;}
    float R2= logf(R);
    float R2max = logf(sqrtf(width*width+height*height));
    R = R2/R2max*width;
    
    int x1 = ((int) R) % width ;
    int y1 = ((int) theta) % height;

    int xp1 = (x1+1) % width;
    int yp1 = (y1+1) % height;
    
    float z1 =   *((unsigned char *)(surface1 + y1*pitch  + 4*x1+1));
    float z2 =   *((unsigned char *)(surface1 + yp1*pitch + 4*x1+1));
    float z3 =   *((unsigned char *)(surface1 + yp1*pitch + 4*xp1+1));
    float z4 =   *((unsigned char *)(surface1 + y1*pitch  + 4*xp1+1));

    float dx =  theta-floorf(theta);
    float dy =  R-floorf(R); 

    float zp = 1.0*z1+ dy*(1.0*z2-z1);
    float zq = 1.0*z4+ dy*(1.0*z3-z4);
    ZR = zp+ dx*(zq-zp);

    //if (z1<1){ z1 = 1;}
    //if (z1>=253){ z1 = 253;}
    }
    else
    { ZR = BK;} 

    pixel2 = (unsigned char *)(surface2 + y*pitch) + 4*x;
    pixel2[1] = ZR;  
   
}

void CartToPolK1(void *surface1,void *surface2, int width, int height, size_t pitch, int BK)
{
    cudaError_t error = cudaSuccess;

    dim3 Db = dim3(32, 32);                  
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_CartToPol1<<<Dg,Db>>>((unsigned char *)surface1,(unsigned char *)surface2, width, height, pitch, BK );

    error = cudaGetLastError();

   
}

__global__ void Kernel_WaveTransformK1(unsigned char *surface1, unsigned char *surface2, int width, int height, size_t pitch,
                                       float Amp, float a, float b, float Rt, int x0, int y0, int yref, int Mask )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (x >= width || y >= height) return;

    pixel1 = (unsigned char *)(surface1 + y*pitch) + 4*x;
    pixel2 = (unsigned char *)(surface2 + y*pitch) + 4*x;
    
    float R =  sqrtf( powf(x-x0,2) + powf(y-y0,2) ) ;
    float ZR  = Amp*sin(a*R+b);
    if (Rt>0) ZR = ZR*expf(-R/Rt);
       

    for (int i=0;i<3;i++)
    {
      int w;
      if (yref>=0) w = yref + ZR;
      else
      w = pixel1[i] +ZR;

      if (w<0) w=0;
      else
      if (w>253) w=253;

      if (Mask & (1<<i))  pixel2[i] = w;  
    }
    if (yref<0)  pixel2[3] = pixel1[3]; // on copie alpha de la source
}

void WaveTransformK1( void *surface1,void *surface2, int width, int height, size_t pitch, 
                      float Amp, float a, float b, float Rt, int x0, int y0, int yref, int RgbMask )
{
    dim3 Db = dim3(32, 32);                  
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_WaveTransformK1<<<Dg,Db>>>((unsigned char *)surface1,(unsigned char *)surface2, width, height, pitch, 
                                       Amp,a,b,Rt,x0,y0,yref, RgbMask );

}


__global__ void Kernel_WaveTransformK2(unsigned char *surface1, unsigned char *surface2, int width, int height, size_t pitch,
                                       float Amp, float a, float b, int x0, int y0, int yref, int Mask )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (x >= width || y >= height) return;

    pixel1 = (unsigned char *)(surface1 + y*pitch) + 4*x;
    pixel2 = (unsigned char *)(surface2 + y*pitch) + 4*x;
    
    
    float theta = atan2f( y-y0 ,  x-x0);
    float ZR  = Amp*sin(a*theta+b);
           

    for (int i=0;i<3;i++)
    {
      int w;
      if (yref>=0) w = yref + ZR;
      else
      w = pixel1[i] +ZR;

      if (w<0) w=0;
      else
      if (w>253) w=253;

      if (Mask & (1<<i))  pixel2[i] = w;  
    }
    if (yref<0)  pixel2[3] = pixel1[3]; // on copie alpha de la source
}

void WaveTransformK2( void *surface1,void *surface2, int width, int height, size_t pitch, 
                      float Amp, float a, float b,  int x0, int y0, int yref, int RgbMask )
{
    dim3 Db = dim3(32, 32);                  
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_WaveTransformK2<<<Dg,Db>>>((unsigned char *)surface1,(unsigned char *)surface2, width, height, pitch, 
                                       Amp,a,b,x0,y0,yref, RgbMask );

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





 int CartToPolK2(cudaArray *cuArray ,void *surface2, int width, int height, size_t pitch)
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
    
    dim3 Db = dim3(16, 16);                   // block dimensions are fixed to be 256 threads
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_CartToPol2<<<Dg,Db>>>( (unsigned char *)surface2, width, height, pitch );

    
    res= cudaUnbindTexture(tex);
    if  ( res!=0 && error==0) error=3;
      
    //error =  channelDesc.x + channelDesc.y*100+ + channelDesc.z*10000+ channelDesc.w*1000000  ;
    return error;
    //error = cudaGetLastError();
 }
   

  



__global__ void Kernel_Interp(unsigned char *surface2, int width, int height,size_t pitch, float *tbX, float *tbY )
{
        
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int j = blockIdx.y*blockDim.y + threadIdx.y;
    
    unsigned char *pixel2;
        
    if (i >= width || j >= height) return;

   
    float xt = tbX[j*width+i];
    float yt = tbY[j*width+i];
    
    float tu =  xt/(float) width ;    // conversion en coordonnées réduites bitmap
    float tv =  yt/(float) height ;

    
    pixel2 = (unsigned char *)(surface2 + j*pitch) + 4*i;       
    pixel2[1] =  255.0* tex2D(tex, tu, tv).y; 
    
   
}

int InterpK2(cudaArray *cuArray ,void *surface2, int width, int height, size_t pitch, float* matX, float* matY)
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
    
    dim3 Db = dim3(16, 16);                   // block dimensions are fixed to be 256 threads
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_Interp<<<Dg,Db>>>((unsigned char*) surface2,width, height,pitch, matX, matY);
    //Kernel_CartToPol2<<<Dg,Db>>>( (unsigned char *)surface2, width, height, pitch );
    
    res= cudaUnbindTexture(tex);
    if  ( res!=0 && error==0) error=3;
      
    //error =  channelDesc.x + channelDesc.y*100+ + channelDesc.z*10000+ channelDesc.w*1000000  ;
    return error;
    //error = cudaGetLastError();

}  


/* Copie d'une surface sur une autre

  Les opérations sont effectuées dans cet ordre:
    - on fait tourner la source autour de (xcSrc, ycSrc) d'un angle theta
    - on effectue un scaling (1/ax,1/ay)
    - on place le centre de la figure obtenue en (x0,y0)

  Le calcul fait les opérations à l'envers: connaissant le point de destination M(idest,jdest), il
  faut trouver le point de la source:

     - on calcule les coo de M par rapport à (xcdest,ycdest), puis par rapport à (x0,y0)
     - on effectue une rotation de -theta
     - puis un scaling (ax,ay)
     - puis on calcule les coo de M par rapport au coin du rectangle source

  
  Pas d'utilisation de tex2D
    Mode 1: simple copie (?)   , il est intéressant d'avoir une interp bilinéaire
    Mode 2: les pixels contiennent un index (1,2,3)
            on remplace l'index par Lum[index] ou Alpha[index]
            l'interp bilinéaire a peu d'intérêt

*/


__global__ void KDispSurfaceOnSurface(unsigned char *surf1, int pitch1, int Nx1, int Ny1, 
                                     unsigned char *surf2, int pitch2, int Nx2, int Ny2, 
                                     float x0, float y0,float theta, float ax, float ay,
                                     float xcSrc, float ycSrc, float xcDest, float ycDest,
                                     int AlphaMode, int LumMode,  Tint4 Alpha, Tint4 Lum,
                                     int Mask)
{
    int idest = blockIdx.x*blockDim.x + threadIdx.x;
    int jdest = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (idest >= Nx2 || jdest >= Ny2) return;

    pixel2 = (unsigned char *)(surf2 + jdest*pitch2) + 4*idest;
        
    float x = (idest-xcDest) - x0;                      // coo par rapport à x0,y0
    float y = (jdest-ycDest) - y0;                      // x0 et y0 sont exprimés relativement au centre de la destination

    float xp = (x*cos(theta)-y*sin(theta)) * ax;        // rotation  -theta
    float yp = (x*sin(theta)+y*cos(theta)) * ay;        // et scaling (ax,ay)

    float xp0 = xcSrc + xp;                             // coo dans le rectangle source
    float yp0 = ycSrc + yp;


    int x1 = floorf(xp0) ;
    int y1 = floorf(yp0) ;
            
    if ( (x1<0) || (x1>=Nx1) || (y1<0) || (y1>=Ny1)) return;  // ajouter une valeur par défaut ?

    int xp1;
    int yp1;
    if (x1<Nx1-1) xp1= x1+1; else xp1= x1;
    if (y1<Ny1-1) yp1= y1+1; else yp1= y1;
        
    float dx =  xp0-x1;
    float dy =  yp0-y1; 


    for (int i=0; i<4; i++)
      {
        int z1 =   *((unsigned char *)(surf1 + y1*pitch1  + 4*x1+i));
        int z2 =   *((unsigned char *)(surf1 + yp1*pitch1 + 4*x1+i));
        int z3 =   *((unsigned char *)(surf1 + yp1*pitch1 + 4*xp1+i));
        int z4 =   *((unsigned char *)(surf1 + y1*pitch1  + 4*xp1+i));

        float zp;
        float zq;
        float z1a;
        float z2a;
        float z3a;
        float z4a;

        if ((i<3) && (Mask & (1<<i))) 
        {
          switch (LumMode)
          { 
            case 1:   float zp = z1+ dy*(z2-z1);
                      float zq = z4+ dy*(z3-z4);
                      pixel2[i] = (int) (zp+ dx*(zq-zp)+0.499999);                                   
                      break;

            case 2:   if ((z1>=1) && (z1<=3))
                      {
                        z1a = Lum.w[z1-1]; 
                        if (z1a>=0)
                        {
                          pixel2[i] = z1a;
                          /*
                          if ((z2>=1) && (z2<=3)) z2a = Lum[z2-1]; else z2a = z1a;
                          if ((z3>=1) && (z3<=3)) z3a = Lum[z3-1]; else z3a = z1a;
                          if ((z4>=1) && (z4<=3)) z4a = Lum[z4-1]; else z4a = z1a;

                          float zp = z1a+ dy*(z2a-z1a);
                          float zq = z4a+ dy*(z3a-z4a);
                          pixel2[i] = (int) (zp+ dx*(zq-zp)+0.499999);                                   
                          */
                        }
                      }
                      break;
                  
          } 
        }
        else
        if (i==3)
        {
          switch (AlphaMode)
          {
            case 1:   float zp = z1+ dy*(z2-z1);
                      float zq = z4+ dy*(z3-z4);
                      pixel2[i] = (int) (zp+ dx*(zq-zp)+0.499999);                        
                      break;

            case 2:   if ((z1>=1) && (z1<=3))
                      {
                        z1a = Alpha.w[z1-1];                                               
                        if (z1a>=0)
                        {
                          pixel2[i] = z1a;
                          /*
                          if ((z2>=1) && (z2<=3)) z2a = Alpha[z2-1]; else z2a = z1a;
                          if ((z3>=1) && (z3<=3)) z3a = Alpha[z3-1]; else z3a = z1a;
                          if ((z4>=1) && (z4<=3)) z4a = Alpha[z4-1]; else z4a = z1a;

                          float zp = z1a+ dy*(z2a-z1a);
                          float zq = z4a+ dy*(z3a-z4a);
                          pixel2[i] = (int) (zp+ dx*(zq-zp)+0.499999);                                   
                          */
                        }
                      }
                      break;
          }
        
        } 
      } 
}

void DispSurfaceOnSurface(void *surf1, int pitch1, int Nx1, int Ny1, 
                          void *surf2, int pitch2, int Nx2, int Ny2, 
                          float x0, float y0,float theta, float ax, float ay,
                          float xcSrc, float ycSrc, float xcDest, float ycDest,
                          int AlphaMode, int LumMode, Tint4 Alpha, Tint4 Lum, 
                          int Mask, cudaStream_t stream)                          
{
  dim3 Db =  dim3(MaxThreadsX, MaxThreadsY);                 
  dim3 Dg = dim3((Nx2+Db.x-1)/Db.x, (Ny2+Db.y-1)/Db.y);

  KDispSurfaceOnSurface<<<Dg,Db,0,stream>>>((unsigned char*)surf1, pitch1, Nx1, Ny1, 
                        (unsigned char*)surf2, pitch2, Nx2, Ny2, 
                        x0, y0,theta, ax, ay, 
                        xcSrc, ycSrc, xcDest, ycDest,
                        AlphaMode, LumMode, Alpha, Lum, Mask );

}


/* Version de DispSurfaceOnSurface avec texture fetching

   On a forcément LumMode=2 ou 0 et AlphaMode=2 ou 0
   Pas de filtrage bilinéaire

*/

// Texture reference for 2D uchar4 texture
texture< uchar4, 2, cudaReadModeElementType > tex1;

__global__ void KDispTexOnSurface1(   int Nx1, int Ny1, 
                                     unsigned char *surf2, int pitch2, int Nx2, int Ny2, 
                                     float x0, float y0,float theta, float ax, float ay,
                                     float xcSrc, float ycSrc, float xcDest, float ycDest,
                                     int AlphaMode, int LumMode,  Tint4 Alpha, Tint4 Lum,
                                     int Mask)
{
    int idest = blockIdx.x*blockDim.x + threadIdx.x;
    int jdest = blockIdx.y*blockDim.y + threadIdx.y;
        
    unsigned char *pixel2;
        
    if (idest >= Nx2 || jdest >= Ny2) return;

    pixel2 = (unsigned char *)(surf2 + jdest*pitch2) + 4*idest;
        
    float x = (idest-xcDest) - x0;
    float y = (jdest-ycDest) - y0;

    float xp = (x*cos(theta)-y*sin(theta)) * ax;
    float yp = (x*sin(theta)+y*cos(theta)) * ay;

    float xp0 = xcSrc + xp;
    float yp0 = ycSrc + yp;


    int x1 = floorf(xp0) ;
    int y1 = floorf(yp0) ;
            
    if ( (x1<0) || (x1>=Nx1) || (y1<0) || (y1>=Ny1)) return;  // ajouter une valeur par défaut ?

    uchar4 pix = tex2D(tex1,x1,y1);

    int z1a;

    if (LumMode==2)
    {
    if ((pix.x>=1) && (pix.x<=3) && (Mask & 1) )
      {
        z1a = Lum.w[pix.x-1]; 
        if (z1a>=0) pixel2[0] = z1a;
      }
    if ((pix.y>=1) && (pix.y<=3) && (Mask & 2) )
      {
        z1a = Lum.w[pix.y-1]; 
        if (z1a>=0) pixel2[1] = z1a;
      }  
    if ((pix.z>=1) && (pix.z<=3) && (Mask & 4) )
      {
        z1a = Lum.w[pix.z-1]; 
        if (z1a>=0) pixel2[2] = z1a;
      }
    }

    if ((pix.w>=1) && (pix.w<=3) && (AlphaMode==2) )
    {
      z1a = Alpha.w[pix.w-1];                                               
      if (z1a>=0) pixel2[3] = z1a;
    } 
    else
    if ((AlphaMode==3) && (pixel2[3]==Alpha.w[0]))
    {
      pixel2[3]= pix.w*(255.0-Alpha.w[0])/255.0 + Alpha.w[0];
    }
   
}


void DispTexOnSurface(cudaArray *SrcArray , int Nx1, int Ny1, 
                          void *surf2, int pitch2, int Nx2, int Ny2, 
                          float x0, float y0,float theta, float ax, float ay,
                          float xcSrc, float ycSrc, float xcDest, float ycDest,
                          int AlphaMode, int LumMode, Tint4 Alpha, Tint4 Lum, 
                          int Mask, cudaStream_t stream)                          
{
 
        // Set texture parameters
    tex1.addressMode[0] = cudaAddressModeBorder;
    tex1.addressMode[1] = cudaAddressModeBorder;
    tex1.filterMode = cudaFilterModePoint;
    tex1.normalized = false;    
       
    int error =0;  
    int res;
   
    cudaChannelFormatDesc channelDesc;
    res= cudaGetChannelDesc(&channelDesc, SrcArray);
    if  ( res!=0 && error==0) error=1;

    res= cudaBindTextureToArray( tex1, SrcArray, channelDesc);
    if  ( res!=0 && error==0) error=2;

    dim3 Db =  dim3(MaxThreadsX, MaxThreadsY);                 
    dim3 Dg = dim3((Nx2+Db.x-1)/Db.x, (Ny2+Db.y-1)/Db.y);

    KDispTexOnSurface1<<<Dg,Db, 0,stream>>>( Nx1, Ny1, 
                        (unsigned char*)surf2, pitch2, Nx2, Ny2, 
                        x0, y0,theta, ax, ay, 
                        xcSrc, ycSrc, xcDest, ycDest,
                        AlphaMode, LumMode, Alpha, Lum, Mask );

    res= cudaUnbindTexture(tex1);
    if  ( res!=0 && error==0) error=3;
    
}


/*     SMOOTH
          
      On applique un filtre de smooth uniforme NxN à une texture
      LumMode<>0 : on applique le fitre à la luminance sinon on ne fait rien
      AlphaMode<>0 : on applique le fitre à la composante Alpha sinon on ne fait rien

      La première version KSmoothSurface est très mauvaise (peu efficace)
 
      La seconde applique successivement deux filtres 1D (SmoothCol et SmoothRow) et est nettement plus rapide

      TODO: ajouter Mask
*/

__global__ void KSmoothSurface(unsigned char *surf1,unsigned char *surf2, int pitch, int Nx, int Ny, 
                               int N, int AlphaMode, int LumMode )
{
    int idest = blockIdx.x*blockDim.x + threadIdx.x;
    int jdest = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (idest >= Nx || jdest >= Ny) return;

    pixel2 =  (unsigned char  *)(surf2 + jdest*pitch) + 4*idest;

    float ss;
    
    int imin =idest-N; if (imin<0) imin=0;
    int imax =idest+N; if (imax>Nx-1) imax=Nx-1;
    int jmin =jdest-N; if (jmin<0) jmin=0;
    int jmax =jdest+N; if (jmax>Ny-1) jmax=Ny-1;
    int Nt=(imax-imin+1)*(jmax-jmin+1);
    //if (Nt=0) return;
    
    if (LumMode)
    {
      for (int k=0; k<3; k++)
      {         
        ss = 0;
        for (int i=imin; i<=imax; i++)
        for (int j=jmin; j<=jmax; j++)
          ss = ss + *((unsigned char *)(surf1 + j*pitch  + 4*i+k));         
        pixel2[k] = ss/Nt;
        
        // pixel2[k] = *((unsigned char *)(surf1 + jdest*pitch  + 4*idest+k));         

      }
    }
    
    if (AlphaMode)
    { ss=0;
      for (int i=imin; i<=imax; i++)
      for (int j=jmin; j<=jmax; j++)      
        ss = ss + *((unsigned char *)(surf1 + j*pitch  + 4*i+3));          

      pixel2[3] = ss/Nt;
    }
    

}

void SmoothSurf(void *surf1, void *surf2, int pitch, int Nx, int Ny, 
                               int N, int AlphaMode, int LumMode )
{
  dim3 Db = dim3(MaxThreadsX, MaxThreadsY);    
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);

   KSmoothSurface<<<Dg,Db>>>( (unsigned char*)surf1, (unsigned char*)surf2, pitch, Nx, Ny, N, AlphaMode, LumMode );


}

// Smooth colonne

__global__ void KSmoothSurfaceCol(unsigned char *surf1,unsigned char *surf2, int pitch, int Nx, int Ny,
                                  int N1, int N2, int x0, int y0, int dmax)
{
    int idest = blockIdx.x*blockDim.x + threadIdx.x;
    int jdest = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (idest >= Nx || jdest >= Ny) return;

    pixel2 =  (unsigned char  *)(surf2 + jdest*pitch) + 4*idest;

    float ss;
    
    
    int jmin;
    int jmax;
    int Nt;          
    float Kr = 1.0;

    if (dmax>0)
    {
      int d = sqrt(1.0*(idest-x0)*(idest-x0)+1.0*(jdest-y0)*(jdest-y0));
      if (d<=dmax) 
      { 
        Kr = (1.0*d)/dmax; 
        N1 = N1*Kr;
        N2 = N2*Kr;
      }
    }
    
    jmin =jdest-N1; if (jmin<0) jmin=0;
    jmax =jdest+N1; if (jmax>Ny-1) jmax=Ny-1;
    Nt=jmax-jmin+1;

    for (int k=0; k<3; k++)
    {         
      ss = 0;    
      for (int j=jmin; j<=jmax; j++)
        ss = ss + *((unsigned char *)(surf1 + j*pitch  + 4*idest+k));               
      pixel2[k] = ss/Nt;
    }
      
    jmin =jdest-N2; if (jmin<0) jmin=0;
    jmax =jdest+N2; if (jmax>Ny-1) jmax=Ny-1;
    Nt=jmax-jmin+1;
      
    ss=0;      
    for (int j=jmin; j<=jmax; j++)      
      ss = ss + *((unsigned char *)(surf1 + j*pitch  + 4*idest+3));          

    pixel2[3] = ss/Nt;    
    
}


// Smooth Colonne mais sur une texRef

__global__ void KSmoothTexCol(unsigned char *surf2, int pitch, int Nx, int Ny, int N1, int N2, int x0, int y0, int dmax)
{
    int idest = blockIdx.x*blockDim.x + threadIdx.x;
    int jdest = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (idest >= Nx || jdest >= Ny) return;

    pixel2 =  (unsigned char  *)(surf2 + jdest*pitch) + 4*idest;
       
    
    int jmin;
    int jmax;
    int Nt;                   
    float Kr = 1.0;

    if (dmax>0)
    {
      int d = sqrt(1.0*(idest-x0)*(idest-x0)+1.0*(jdest-y0)*(jdest-y0));
      if (d<=dmax) 
      { 
        Kr = (1.0*d)/dmax;
        N1 = N1*Kr;
        N2 = N2*Kr;
      }
    }
    jmin =jdest-N1; if (jmin<0) jmin=0;
    jmax =jdest+N1; if (jmax>Ny-1) jmax=Ny-1;
    Nt=jmax-jmin+1;

    int ss[4];
    uchar4 pix;  

	for (int j=0; j<4; j++) { ss[j] = 0; }

    for (int j=jmin; j<=jmax; j++)
    {
      pix = tex2D(tex1,idest,j);         
      
      ss[0] = ss[0]+pix.x;
      ss[1] = ss[1]+pix.y;
      ss[2] = ss[2]+pix.z;
    }     
    for (int i=0;i<3;i++) pixel2[i] = ss[i]/Nt;
      
    jmin =jdest-N2; if (jmin<0) jmin=0;
    jmax =jdest+N2; if (jmax>Ny-1) jmax=Ny-1;
    Nt=jmax-jmin+1;
      
    int s=0;      
    for (int j=jmin; j<=jmax; j++)      
    {
      pix = tex2D(tex1,idest,j);    
      s = s + pix.w;          
    }
    pixel2[3] = s/Nt;    
    
}


// Smooth Row
__global__ void KSmoothSurfaceRow(unsigned char *surf1,unsigned char *surf2, int pitch, int Nx, int Ny, 
                               int N1, int N2, int x0, int y0, int dmax, int dmax2, int ref1, int ref2, int ref3 )
{
    int idest = blockIdx.x*blockDim.x + threadIdx.x;
    int jdest = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
    unsigned char *pixel2;
        
    if (idest >= Nx || jdest >= Ny) return;

    pixel2 =  (unsigned char  *)(surf2 + jdest*pitch) + 4*idest;

    float ss;
    float Kr = 1.0;
    float Kr2 = 1.0;

    //if (Nt=0) return;
    if (dmax>0)
    {
      int d = sqrt(1.0*(idest-x0)*(idest-x0)+1.0*(jdest-y0)*(jdest-y0));
      if (d<=dmax) 
      { 
        Kr = (1.0*d)/dmax;
        N1 = N1*Kr;
        N2 = N2*Kr;
      }
      if (d<=dmax2) 
      { 
        Kr2 = (1.0*d)/dmax2;
      }
    }

    int imin =idest-N1; if (imin<0) imin=0;
    int imax =idest+N1; if (imax>Nx-1) imax=Nx-1;     
    int Nt= imax-imin+1;

    int ref[3];
    ref[0] = ref1;
    ref[1] = ref2;
    ref[2] = ref3;

    for (int k=0; k<3; k++)
    {         
      ss = 0;
      for (int i=imin; i<=imax; i++)        
        ss = ss + *((unsigned char *)(surf1 + jdest*pitch  + 4*i+k));         
      
      pixel2[k] = ref[k] + (ss/Nt-ref[k])*Kr2;               
      //pixel2[k] = ss/Nt;               
    }
    
    imin =idest-N2; if (imin<0) imin=0;
    imax =idest+N2; if (imax>Nx-1) imax=Nx-1;     
    Nt= imax-imin+1;

    ss=0;
    for (int i=imin; i<=imax; i++) 
      ss = ss + *((unsigned char *)(surf1 + jdest*pitch  + 4*i+3));          

    pixel2[3] = ss/Nt; // 255+(ss/Nt-255) * Kr ;    
}


void SmoothSurf2(void *surf1, void *surf2, void *surfDum, int pitch, int Nx, int Ny, 
                               int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref )
{
  dim3 Db = dim3(MaxThreadsX, MaxThreadsY);    
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
  
  KSmoothSurfaceCol<<<Dg,Db>>>( (unsigned char*)surf1, (unsigned char*)surfDum, pitch, Nx, Ny, N1, N2, x0, y0, dmax );
  KSmoothSurfaceRow<<<Dg,Db>>>( (unsigned char*)surfDum, (unsigned char*)surf2, pitch, Nx, Ny, N1, N2, x0, y0, dmax,dmax2, ref[0], ref[1], ref[2]);
}


void SmoothTex2(cudaArray *SrcArray, void *surf2, void *surfDum, int pitch, int Nx, int Ny, 
                               int N1, int N2, int x0, int y0, int dmax, int dmax2, int* ref,  cudaStream_t stream)
{
  
        // Set texture parameters
    tex1.addressMode[0] = cudaAddressModeBorder;
    tex1.addressMode[1] = cudaAddressModeBorder;
    tex1.filterMode = cudaFilterModePoint;
    tex1.normalized = false;    
       
    int error =0;  
    int res;
   
    cudaChannelFormatDesc channelDesc;
    res= cudaGetChannelDesc(&channelDesc, SrcArray);
    if  ( res!=0 && error==0) error=1;

    res= cudaBindTextureToArray( tex1, SrcArray, channelDesc);
    if  ( res!=0 && error==0) error=2;

    dim3 Db =  dim3(MaxThreadsX, MaxThreadsY);                 
    dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);

    KSmoothTexCol<<<Dg,Db,0,stream>>>( (unsigned char*)surfDum, pitch, Nx, Ny, N1, N2, x0, y0, dmax);

    res= cudaUnbindTexture(tex1);
    if  ( res!=0 && error==0) error=3;
    
    KSmoothSurfaceRow<<<Dg,Db,0,stream>>>( (unsigned char*)surfDum, (unsigned char*)surf2, pitch, Nx, Ny, N1, N2, x0, y0, dmax,dmax2, ref[0],ref[1],ref[2]);

}

/*                       
*/

__global__ void KtexSumX( int* outD, int NtotX, int NtotY, int NbUx, int NbUy, int ref)
{
  int idx = threadIdx.x;
  int Bidx = blockIdx.x;
  int idy = threadIdx.y;
  int Bidy = blockIdx.y;

  int NthreadX = blockDim.x; 
  int NblockX = gridDim.x;
  int NthreadY = blockDim.y; 
  int NblockY = gridDim.y;                       
    
  __shared__ int A0[4096];     // size = Nthread max 

  int i0 = Bidx*NthreadX*NbUx+ idx*NbUx;
  int j0 = Bidy*NthreadY*NbUy+ idy*NbUy;


  int IA0 = idx + NthreadX*idy; 
  A0[IA0]=0;
  for (int i=0; i<NbUx; i++)
  for (int j=0; j<NbUy; j++)
  { if ((i0+i<NtotX)&& (j0+j<NtotY))
    { uchar4 pix = tex2D(tex1,i0+i,j0+j);
      if (pix.x==ref) A0[IA0]++ ;
    }
  } 

  __syncthreads();
 
  if ((idx==0) && (idy==0))
  {
   outD[Bidx+NblockX*Bidy] =0;
   for (int i=0;i< NthreadX*NthreadY; i++)   
   {outD[Bidx+NblockX*Bidy] += A0[i]; }
  }

}

__global__ void KtexSumY( int* outD, int NtotX, int NtotY, int NbUx, int NbUy, int ref)
{
  int idx = threadIdx.x;
  int Bidx = blockIdx.x;
  int idy = threadIdx.y;
  int Bidy = blockIdx.y;

  int NthreadX = blockDim.x; 
  int NblockX = gridDim.x;
  int NthreadY = blockDim.y; 
  int NblockY = gridDim.y;                       
    
  __shared__ int A0[4096];     // size = Nthread max 

  int i0 = Bidx*NthreadX*NbUx+ idx*NbUx;
  int j0 = Bidy*NthreadY*NbUy+ idy*NbUy;


  int IA0 = idx + NthreadX*idy; 
  A0[IA0]=0;
  for (int i=0; i<NbUx; i++)
  for (int j=0; j<NbUy; j++)
  { if ((i0+i<NtotX)&& (j0+j<NtotY))
    { uchar4 pix = tex2D(tex1,i0+i,j0+j);
      if (pix.y==ref) A0[IA0]++ ;
    }
  } 

  __syncthreads();
 
  if ((idx==0) && (idy==0))
  {
   outD[Bidx+NblockX*Bidy] =0;
   for (int i=0;i< NthreadX*NthreadY; i++)   
   {outD[Bidx+NblockX*Bidy] += A0[i]; }
  }

}


__global__ void KtexSumZ( int* outD, int NtotX, int NtotY, int NbUx, int NbUy, int ref)
{
  int idx = threadIdx.x;
  int Bidx = blockIdx.x;
  int idy = threadIdx.y;
  int Bidy = blockIdx.y;

  int NthreadX = blockDim.x; 
  int NblockX = gridDim.x;
  int NthreadY = blockDim.y; 
  int NblockY = gridDim.y;                       
    
  __shared__ int A0[4096];     // size = Nthread max 

  int i0 = Bidx*NthreadX*NbUx+ idx*NbUx;
  int j0 = Bidy*NthreadY*NbUy+ idy*NbUy;


  int IA0 = idx + NthreadX*idy; 
  A0[IA0]=0;
  for (int i=0; i<NbUx; i++)
  for (int j=0; j<NbUy; j++)
  { if ((i0+i<NtotX)&& (j0+j<NtotY))
    { uchar4 pix = tex2D(tex1,i0+i,j0+j);
      if (pix.z==ref) A0[IA0]++ ;
    }
  } 

  __syncthreads();
 
  if ((idx==0) && (idy==0))
  {
   outD[Bidx+NblockX*Bidy] =0;
   for (int i=0;i< NthreadX*NthreadY; i++)   
   {outD[Bidx+NblockX*Bidy] += A0[i]; }
  }

}

__global__ void KtexSumW( int* outD, int NtotX, int NtotY, int NbUx, int NbUy, int ref)
{
  int idx = threadIdx.x;
  int Bidx = blockIdx.x;
  int idy = threadIdx.y;
  int Bidy = blockIdx.y;

  int NthreadX = blockDim.x; 
  int NblockX = gridDim.x;
  int NthreadY = blockDim.y; 
  int NblockY = gridDim.y;                       
    
  __shared__ int A0[4096];     // size = Nthread max 

  int i0 = Bidx*NthreadX*NbUx+ idx*NbUx;
  int j0 = Bidy*NthreadY*NbUy+ idy*NbUy;


  int IA0 = idx + NthreadX*idy; 
  A0[IA0]=0;
  for (int i=0; i<NbUx; i++)
  for (int j=0; j<NbUy; j++)
  { if ((i0+i<NtotX)&& (j0+j<NtotY))
    { uchar4 pix = tex2D(tex1,i0+i,j0+j);
      if (pix.w==ref) A0[IA0]++ ;
    }
  } 

  __syncthreads();
 
  if ((idx==0) && (idy==0))
  {
   outD[Bidx+NblockX*Bidy] =0;
   for (int i=0;i< NthreadX*NthreadY; i++)   
   {outD[Bidx+NblockX*Bidy] += A0[i]; }
  }

}


int TexSum(cudaArray *SrcArray , int NtotX, int NtotY, int* Odata, int Comp, int ref )
{ 
  int tbres[2048];
  int res;
  int* Odata1;

  int NthreadX =  MaxThreadsX;
  int NblockX =1024;

  while ((NthreadX*NblockX>NtotX)&&(NblockX>1)) NblockX = NblockX/2;  
  int NbUx = NtotX/(NthreadX*NblockX);
  if (NtotX % (NthreadX*NblockX) !=0) {NbUx++;}

  
  while ((NblockX>NbUx)&&(NblockX>1)) {
    NblockX = NblockX/2;  
    NbUx = NbUx*2;
  }

  int NthreadY =  MaxThreadsY;
  int NblockY =1024;

  while ((NthreadY*NblockY>NtotY)&&(NblockY>1)) NblockY = NblockY/2;  
  int NbUy = NtotY/(NthreadY*NblockY);
  if (NtotY % (NthreadY*NblockY) !=0) {NbUy++;}
  
  while ((NblockY>NbUy)&&(NblockY>1)) {
    NblockY = NblockY/2;  
    NbUy = NbUy*2;
  }
    
  if (Odata !=NULL) Odata1=Odata; else cudaMalloc((void**) &Odata1, NblockX*NblockY* sizeof(int));        

  tex1.addressMode[0] = cudaAddressModeBorder;
  tex1.addressMode[1] = cudaAddressModeBorder;
  tex1.filterMode = cudaFilterModePoint;
  tex1.normalized = false;    
       
  int error =0;  
 
   
  cudaChannelFormatDesc channelDesc;
  res= cudaGetChannelDesc(&channelDesc, SrcArray);
  if  ( res!=0 && error==0) error=1;

  res= cudaBindTextureToArray( tex1, SrcArray, channelDesc);
  if  ( res!=0 && error==0) error=2;

  if (error!=0)
	  {
		  if (Odata == NULL) cudaFree(Odata1);
		  return -error;

	  }


  dim3 Db = dim3(NthreadX, NthreadY);    
  dim3 Dg = dim3(NblockX, NblockY);    

  
  switch (Comp)
  {
    case 1: KtexSumX<<<Dg,Db>>>(Odata1,NtotX,NtotY,NbUx,NbUy, ref ); 
            break;
    case 2: KtexSumY<<<Dg,Db>>>(Odata1,NtotX,NtotY,NbUx,NbUy, ref ); 
            break;
    case 3: KtexSumZ<<<Dg,Db>>>(Odata1,NtotX,NtotY,NbUx,NbUy, ref ); 
            break;
    case 4: KtexSumW<<<Dg,Db>>>(Odata1,NtotX,NtotY,NbUx,NbUy, ref ); 
            break;
  }

  res= cudaUnbindTexture(tex1);

  cudaMemcpy(tbres,Odata1,NblockX*NblockY*sizeof(int),cudaMemcpyDeviceToHost);
  
  if (Odata == NULL) cudaFree(Odata1);

  res = 0;
  for (int i=0;i<NblockX*NblockY;i++) res+=tbres[i];
  return res;

}


// Remplissage de la linearmem (tableau de pixels) associée à la texture avec le tableau de bytes
// Alpha n'est pas modifié
__global__ void 
FillTexByte(void *surface, int width, int height, size_t pitch,unsigned char* src, int Mask, float Ascale, float Bscale)
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
        
    if (x >= width || y >= height) return;        
    
	//Ascale = 1.0;
	//Bscale = 0;


	int w = src[x + width*y];
    w =  Ascale*w + Bscale;

	if (w<0)   { w = 0;}
	else
	if (w>253) { w = 253;}

	pixel1 = (unsigned char *)( (char*)surface + y*pitch) + 4*x;
        
	pixel1[3] =255;
    // alpha n'est pas modifié sauf s'il fait partie du masque
    for (int i=0;i<4;i++)    
    {  if (Mask & (1<<i))  pixel1[i] = w;  } 
}

int FillByteTexture(void* LinearMem, int Nx, int Ny, size_t PitchMem, unsigned char* Image, int ColorMask, float Ascale, float Bscale)
{
  dim3 Db = dim3(MaxThreadsX, MaxThreadsX);                   
  dim3 Dg = dim3((Nx+Db.x-1)/Db.x, (Ny+Db.y-1)/Db.y);
    
  FillTexByte<<<Dg,Db>>>(LinearMem,Nx,Ny,PitchMem,Image,ColorMask, Ascale, Bscale);
  return 0;
}
