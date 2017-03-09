extern int MaxThreadsPerBlock;
extern int MaxThreadsX;
extern int MaxThreadsY;


__global__ void Kernel_Rings1(unsigned char *surface1, int width, int height, size_t pitch,
                                       float Amp, float a, float b, float Rt, int x0, int y0, float yref, int Mask )
{
    int x = blockIdx.x*blockDim.x + threadIdx.x;
    int y = blockIdx.y*blockDim.y + threadIdx.y;

    unsigned char *pixel1;
           
    if (x >= width || y >= height) return;

    pixel1 = (unsigned char *)(surface1 + y*pitch) + 4*x;
       
    float R =  sqrtf( powf(x-x0,2) + powf(y-y0,2) ) ;
    float ZR  = Amp*sin(a*R+b);
    if (Rt>0) ZR = ZR*expf(-R/Rt);
       
	int w = yref + ZR;     

    if (w<0) w=0;
    else
    if (w>253) w=253;

	for (int i=0;i<3;i++)
    {
      if (Mask & (1<<i))  pixel1[i] = w;  
    }
    pixel1[3] =w; // alpha comme les autres 
}

void BuildRingsK1( void *surface1, int width, int height, size_t pitch, 
                      float Amp, float a, float b, float Rt, int x0, int y0, float yref, int RgbMask, int mode )
{
    dim3 Db = dim3(MaxThreadsX, MaxThreadsY);                  
    dim3 Dg = dim3((width+Db.x-1)/Db.x, (height+Db.y-1)/Db.y);

    Kernel_Rings1<<<Dg,Db>>>((unsigned char *)surface1, width, height, pitch, Amp,a,b,Rt,x0,y0,yref, RgbMask );

}
