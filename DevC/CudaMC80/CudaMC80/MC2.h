#ifndef _MC2_
#define _MC2_


#include <cuda_runtime_api.h>
#include <cuda_d3d9_interop.h>
#include <curand.h>

typedef double2 Complex;

class TMCstruct {   
  double*      Filter;
  double*      Noise;
  double*      Xn0;
  double*      Xn1;
  double*      Xn2;
  double*      Vdum;

  Complex*     Xnf0;
  Complex*     Xnf1;
  Complex*     Xnf2;
  Complex*     fftNoise;
  

  int          Nx;
  int          Ny;

  double       aReg;
  double       bReg;

  double*      afReg;
  double*      bfReg;
  double*      cfReg;

  double       mu;
  double       sigma;

  double       DxF;
  double       X0F;
  double       DyF;
  double       Y0F;

  double       Atransform;
  double       Btransform;

  void*        LinearMem;
  size_t       PitchMem;



  int          FpolarMode;
  int          Nsample;
  int          seed;   
  int          ColorMask;

  curandGenerator_t generator;
  curandGenerator_t RstGenerator;


  cufftHandle fftPlan;

  double*     Noise1;
  double*     Noise2;
  double*     D0;
  double*     C0;
  double*     LastF;

  double*     Noise1_init;
  double*     LastF_init;
  
  double*     Noise1_cont;
  double*     LastF_cont;
  
  long long   ContOffset;  
  boolean     RstState;
  boolean     DoRestart; 
  
  double      Nc;
  double      Nf;
  double      Nf0;

  int         AlphaTh;
  int         AlphaThV;


  cudaStream_t    streamK;

  cudaGraphicsResource* cudaResource;

public:
  TMCstruct();

  int ComputeNoise(double* noise1, double* filter1, curandGenerator_t Agenerator, cudaStream_t stream );
  int  Autoreg();
  int ComputeNoise2(Complex* fftNoise1, double* filter1);
  int Autoreg2();
  int InitK2(); 
  int DoneK2();
  int UpdateK2();
  void InstallLogGaborFilterK(double dtAR, double ss , double r0, double sr0, double stheta0);
  int AutoregPink(double* Noise1, double* LastF,cudaStream_t stream);
  
  int UpdateKpink(cudaStream_t stream);
  int UpdateKpink2(cudaStream_t stream);

  int InitKpink(double* aa, double* bb, int* Nt);
  int DoneKpink();
  int InitMC2(int w, int h, int seed1, int Nsamp);

  HRESULT InitMC2stim( cudaGraphicsResource* Resource);
  int SetExpansionK2( double Dx1, double x01, double Dy1, double y01);
  int SetGainOffset2( double a1, double b1);
  void SetAlphaThreshold(int th, int ww);
  HRESULT DoneMC2();
  HRESULT DoneMC2stim();
  int UpdateMC2();
  int GetFrameK2( double* p);
  int GetFilter( double* p);
  int SetFilter( double* p);
  void SetRgbMask(int mask);
  void SetSeed(int seed1);
  void InstallLogGaborFilter( double dtAR, double ss , double r0, double sr0, double stheta0);
  HRESULT InitMCpink( int w, int h, int seed1, double* C0x, double* D0x, int Ncx, double Nfx, double Nf0x );
  HRESULT DoneMCpink();
  HRESULT InitMCpinkStim(cudaGraphicsResource* Resource );
  int UpdateMCpink(boolean LaunchOnly);
  int GetFrameKpink( double* p);

  int RestartNoise();
  int ResumeNoise();

}; 




#endif
