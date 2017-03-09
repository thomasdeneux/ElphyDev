
// includes, project
#include <cuda_runtime.h>
#include <cufft.h>
#include <curand.h>
#include <math.h>

#define PI 3.1415926536f


float*      matX;
float*      matY;

__global__ void Kernel_Interp(float *tb1, float *tb2, float *tbX, float *tbY, int width, int height, float a1,float b1, float c1, float a2,float b2, float c2 )
{
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int j = blockIdx.y*blockDim.y + threadIdx.y;
    
        
    if (i >= width || j >= height) return;

    int i0 = int (a1*i+b1) % 61;       // conversion de (i,j) en cm écran puis en unités tbX/tbY
    int j0 = int (a1*j+c1) % 61 ;


    float xt = tbX[width*j0+i0];     // coordonnées de la transformée dans le cortex en mm
    float yt = tbY[width*j0+i0];     // on suppose que le stockage tbX/tbY est ligne par ligne 
   
    int i1 = ((int) (xt*a2+b2) ) % width ;    // conversion en coordonnées bitmap
    int j1 = ((int) (yt*a2+c2) ) % height;

    int ip1 = (i1+1) % width;
    int jp1 = (j1+1) % height;
    
    float z1 =   tb1[width*j1+i1];
    float z2 =   tb1[width*jp1+i1];
    float z3 =   tb1[width*jp1+ip1];
    float z4 =   tb1[width*j1+ip1];

    float dx =  xt-floorf(xt);
    float dy =  yt-floorf(yt); 

    float zp = z1+ dy*(z2-z1);
    float zq = z4+ dy*(z3-z4);
    float ZR = zp+ dx*(zq-zp);
            
    tb2[width*j+i] = ZR;    
   
}


