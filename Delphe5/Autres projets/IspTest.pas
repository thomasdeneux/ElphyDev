(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsp.h
Purpose: NSP Common Header file
*)

unit NSP;

{$Z+,A+}

interface

uses
  Windows;

type
  Float  = Single;
  PFloat = ^Float;
  Short  = SmallInt;
  PShort = ^Short;

  NSPStatus = Integer;

  PSCplx = ^TSCplx;
  TSCplx = record
    Re : Float;
    Im : Float;
  end;

  PDCplx = ^TDCplx;
  TDCplx = record
    Re : Double;
    Im : Double;
  end;

  PWCplx = ^TWCplx;
  TWCplx = record
    Re : Short;
    Im : Short;
  end;

  PICplx = ^TICplx;
  TICplx = record
    Re : Integer;
    Im : Integer;
  end;

const
  SCplxZero : TSCplx = (Re: 0; Im: 0);
  DCplxZero : TDCplx = (Re: 0; Im: 0);
  WCplxZero : TWCplx = (Re: 0; Im: 0);
  ICplxZero : TICplx = (Re: 0; Im: 0);

  SCplxOneZero : TSCplx = (Re: 1; Im: 0);
  DCplxOneZero : TDCplx = (Re: 1; Im: 0);

  WCplxOneOne : TWCplx = (Re: 1; Im: 1);
  ICplxOneOne : TICplx = (Re: 1; Im: 1);
  SCplxOneOne : TSCplx = (Re: 1; Im: 1);
  DCplxOneOne : TDCplx = (Re: 1; Im: 1);

const
  NSP_EPS  = 1.0e-12;
  NSP_PI   = 3.14159265358979324;
  NSP_2PI  = 6.28318530717958648;
  NSP_PI_2 = 1.57079632679489662;
  NSP_PI_4 = 0.785398163397448310;

function NSPsDegToRad(const Deg : Float) : Float;
function NSPdDegToRad(const Deg : Double) : Double;

{------------- NSP Library Control Symbols -------------}
{ Insert '$' before 'DEFINE' to use any Symbol below or }
{ 'DEFINE nsp_UsesAll' to use all.                      }

{$DEFINE nsp_UsesAll}
{DEFINE nsp_UsesVector}
(*
nsp_UsesVector:     vector/scalar Zero,Set,Copy,Add,Sub,Mpy,Div,Conj
                    b<,Inv>Tresh<1,2>,bAbs<1,2>,bAdd<2,3>,bExp<1,2>,bLn<1,2>,
                    bMpy<2,3>, bSqr<1,2>, bSqrt<1,2>, Max, Maxext, Min, Minext
                    Mean, StDev
                    Dotprod, Dotprodext,
                    bConj<,Extend><1,2>, bConjFlip2
                    b<Mu,A>LawToLin, bLinTo<Mu,A>Law
                    AutoCorr<Biased,Unbiased>, CrossCorr,
                    Norm, Normext, Normalize, bDiv<1,2,3>,
                    <Up,Down>Sample,bArctan<1,2>
*)

{DEFINE nsp_UsesConversion}
(*
nsp_UsesConversion: bImag, bReal, bCplxTo2Real, b2RealToCplx,
                    b<,r>Mag, b<,rPhase>,
                    bFloatTo<Int,Fix,S31Fix,S15Fix,S7Fix,S1516Fix>,
                    b<Int,Fix,S31Fix,S15Fix,S7Fix,S1516Fix>ToFloat,
                    b<,r>CartToPolar, b<,r>PolarToCart
*)

{DEFINE nsp_UsesConvolution}
(*
nsp_UsesConvolution:Conv
                    Conv2D
                    Filter2D
*)

{DEFINE nsp_UsesDct}
(*
nsp_UsesDct:        Dct
*)

{DEFINE nsp_UsesTransform}
(*
nsp_UsesTransform:  Dft
                    Fft<,Nip>, <Real,Ccs>Fftl<,Nip>, MpyRC<Perm,Pack><2,3>
                    <Real,Ccs><,2>Fft<,Nip>
                    Goertz
*)

{DEFINE nsp_UsesFir}
(*
nsp_UsesFir:        struct FirState,FirInit<,Mr>,FirFree,Fir<Get,Set><Taps,Dlyl>
                    struct Fir<Taps|Dly>State, <Up,Down>Sample,
                    FirlInit<,Mr,Dlyl>, Firl, Firl<Get,Set><Taps,Dlyl>
*)

{DEFINE nsp_UsesFirGen}
(*
nsp_UsesFirGen:     dFirLowpass, nspdFirHighpass, nspdFirBandpass
                    nspdFirBandstop
*)

{DEFINE nsp_UsesIir}
(*
nsp_UsesIir:        struct Iir<Tap,Dly>State, IirlInit<,Bq,Dlyl>, Iirl
                    struct Iir<Tap,Dly>State, IirInit<,Bq>, Iir, IirFree
*)

{DEFINE nsp_UsesLms}
(*
nsp_UsesLms:        struct Lms<Tap,Dly>State, LmslInit<,Mr,Dlyl>,
                    Lmsl<Get,Set><Step,Leak>, Lmsl<,Na>
*)

{DEFINE nsp_UsesMedian}
(*
nsp_UsesMedian:     MedianFilter1,MedianFilter2
*)

{DEFINE nsp_UsesMisc}
(*
nsp_UsesMisc:       BitRevTbl,BitRev,
                    TwdTbl
*)

{DEFINE nsp_UsesSampleGen}
(*
nsp_UsesSampleGen:  struct ToneState, ToneInit, Tone
                    struct TrnglState, TrnglInit, Trngl
                    bRandUni, RandUni, RandUniInit
                    bRandGauss, RandGauss, RandGausInit
*)

{DEFINE nsp_UsesWin}
(*
nsp_UsesWin:        Win<Bartlett,Hann,Hamming,Blackman<,Std,Opt>,Kaiser>
*)

{DEFINE nsp_UsesWavelet}
(*
nsp_UsesWavelet:    WtInit, WtInitLen, WtSetState, WtGetState,
                    WtDecompose, WtReconstruct
*)


{$INCLUDE NSPError.int}
{$INCLUDE NSPAlloc.int}

{$IFDEF nsp_UsesAll}
  {$DEFINE nsp_UsesConvolution}
  {$DEFINE nsp_UsesConversion}
  {$DEFINE nsp_UsesDct}
  {$DEFINE nsp_UsesFir}
  {$DEFINE nsp_UsesFirGen}
  {$DEFINE nsp_UsesIir}
  {$DEFINE nsp_UsesLms}
  {$DEFINE nsp_UsesMedian}
  {$DEFINE nsp_UsesMisc}
  {$DEFINE nsp_UsesSampleGen}
  {$DEFINE nsp_UsesTransform}
  {$DEFINE nsp_UsesVector}
  {$DEFINE nsp_UsesWin}
  {$DEFINE nsp_UsesWavelet}
{$ENDIF nsp_UsesAll}

{$IFDEF nsp_UsesConvolution}
  {$INCLUDE NSPConv.int}
  {$INCLUDE NSPCnv2d.int}
  {$INCLUDE NSPFir2.int}
{$ENDIF nsp_UsesConvolution}

{$IFDEF nsp_UsesConversion}
  {$INCLUDE NSPCvrt.int}
{$ENDIF nsp_UsesConversion}

{$IFDEF nsp_UsesDct}
  {$INCLUDE NSPDct.int}
{$ENDIF nsp_UsesDct}

{$IFDEF nsp_UsesFir}
  {$INCLUDE NSPFirl.int}
  {$INCLUDE NSPFirh.int}
  {$INCLUDE NSPRsmpl.int}
{$ENDIF nsp_UsesFir}

{$IFDEF nsp_UsesFirGen}
  {$INCLUDE NSPFirg.int}
{$ENDIF nsp_UsesFirGen}

{$IFDEF nsp_UsesIir}
  {$INCLUDE NSPIirl.int}
  {$INCLUDE NSPIirh.int}
{$ENDIF nsp_UsesIir}

{$IFDEF nsp_UsesLms}
  {$INCLUDE NSPLmsl.int}
  {$INCLUDE NSPLmsh.int}
{$ENDIF nsp_UsesLms}

{$IFDEF nsp_UsesMedian}
  {$INCLUDE NSPMed.int}
{$ENDIF nsp_UsesMedian}

{$IFDEF nsp_UsesMisc}
  {$INCLUDE NSPMisc.int}
{$ENDIF nsp_UsesMisc}

{$IFDEF nsp_UsesSampleGen}
  {$INCLUDE NSPRand.int}
  {$INCLUDE NSPTone.int}
  {$INCLUDE NSPTrngl.int}
{$ENDIF nsp_UsesSampleGen}

{$IFDEF nsp_UsesTransform}
  {$INCLUDE NSPFft.int}
  {$INCLUDE NSPGrtz.int}
{$ENDIF nsp_UsesTransform}

{$IFDEF nsp_UsesVector}
  {$INCLUDE NSPArith.int}
  {$INCLUDE NSPCorr.int}
  {$INCLUDE NSPLaw.int}
  {$INCLUDE NSPLnexp.int}
  {$INCLUDE NSPSampl.int}
  {$INCLUDE NSPVec.int}
  {$INCLUDE NSPDotp.int}
  {$INCLUDE NSPNorm.int}
  {$INCLUDE NSPLogic.int}
  {$INCLUDE NSPDiv.int}
  {$INCLUDE NSPAtan.int}
{$ENDIF nsp_UsesVector}

{$IFDEF nsp_UsesWin}
  {$INCLUDE NSPWin.int}
{$ENDIF nsp_UsesWin}

{$IFDEF nsp_UsesWavelet}
  {$INCLUDE NSPWlt.int}
{$ENDIF nsp_UsesWavelet}

implementation

const
  nspDLL = 'NSP.DLL';

function NSPsDegToRad(const Deg : Float) : Float;
begin
  Result := Deg / 180.0 * NSP_PI;
end;

function NSPdDegToRad(const Deg : Double) : Double;
begin
  Result := Deg / 180.0 * NSP_PI;
end;

{$INCLUDE NSPError.imp}
{$INCLUDE NSPAlloc.imp}

{$IFDEF nsp_UsesConvolution}
  {$INCLUDE NSPConv.imp}
  {$INCLUDE NSPCnv2d.imp}
  {$INCLUDE NSPFir2.imp}
{$ENDIF nsp_UsesConvolution}

{$IFDEF nsp_UsesConversion}
  {$INCLUDE NSPCvrt.imp}
{$ENDIF nsp_UsesConversion}

{$IFDEF nsp_UsesDct}
  {$INCLUDE NSPDct.imp}
{$ENDIF nsp_UsesDct}

{$IFDEF nsp_UsesFir}
  {$INCLUDE NSPFirl.imp}
  {$INCLUDE NSPFirh.imp}
  {$INCLUDE NSPRsmpl.imp}
{$ENDIF nsp_UsesFir}

{$IFDEF nsp_UsesFirGen}
  {$INCLUDE NSPFirg.imp}
{$ENDIF nsp_UsesFirGen}

{$IFDEF nsp_UsesIir}
  {$INCLUDE NSPIirl.imp}
  {$INCLUDE NSPIirh.imp}
{$ENDIF nsp_UsesIir}

{$IFDEF nsp_UsesLms}
  {$INCLUDE NSPLmsl.imp}
  {$INCLUDE NSPLmsh.imp}
{$ENDIF nsp_UsesLms}

{$IFDEF nsp_UsesMedian}
  {$INCLUDE NSPMed.imp}
{$ENDIF nsp_UsesMedian}

{$IFDEF nsp_UsesMisc}
  {$INCLUDE NSPMisc.imp}
{$ENDIF nsp_UsesMisc}

{$IFDEF nsp_UsesSampleGen}
  {$INCLUDE NSPRand.imp}
  {$INCLUDE NSPTone.imp}
  {$INCLUDE NSPTrngl.imp}
{$ENDIF nsp_UsesSampleGen}

{$IFDEF nsp_UsesTransform}
  {$INCLUDE NSPFft.imp}
  {$INCLUDE NSPGrtz.imp}
{$ENDIF nsp_UsesTransform}

{$IFDEF nsp_UsesVector}
  {$INCLUDE NSPArith.imp}
  {$INCLUDE NSPCorr.imp}
  {$INCLUDE NSPLaw.imp}
  {$INCLUDE NSPLnexp.imp}
  {$INCLUDE NSPSampl.imp}
  {$INCLUDE NSPVec.imp}
  {$INCLUDE NSPDotp.imp}
  {$INCLUDE NSPNorm.imp}
  {$INCLUDE NSPLogic.imp}
  {$INCLUDE NSPDiv.imp}
  {$INCLUDE NSPAtan.imp}
{$ENDIF nsp_UsesVector}

{$IFDEF nsp_UsesWin}
  {$INCLUDE NSPWin.imp}
{$ENDIF nsp_UsesWin}

{$IFDEF nsp_UsesWavelet}
  {$INCLUDE NSPWlt.imp}
{$ENDIF nsp_UsesWavelet}

end.
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-200 Intel Corporation. All Rights Reserved.

From:    nspalloc.h
Purpose: NSP 32 bytes aligned allocator/deallocator
*)

function nspMalloc (Length : Integer) : Pointer; stdcall;

function nspsMalloc(Length : Integer) : PFloat;  stdcall;
function nspdMalloc(Length : Integer) : PDouble; stdcall;

function nspcMalloc(Length : Integer) : PSCplx;  stdcall;
function nspzMalloc(Length : Integer) : PDCplx;  stdcall;

function nspwMalloc(Length : Integer) : PShort;  stdcall;
function nspvMalloc(Length : Integer) : PWCplx;  stdcall;

procedure nspFree(  P      : Pointer);           stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-200 Intel Corporation. All Rights Reserved.

From:    nsparith.h
Purpose: NSP Scalar and Vector Arithmetics
*)

{-------------------------------------------------------------------------}
{   Miscellaneous Scalar Functions and Vector Functions                   }
{        Complex Add, Sub, Mpy, Div, Conj                                 }
{                                                                         }
{   These functions perform addition, subtraction, multiplication,        }
{   division, and conjugation on complex numbers a and b.                 }
function nspcAdd( A, B : TSCplx) : TSCplx; stdcall;
function nspcSub( A, B : TSCplx) : TSCplx; stdcall;
function nspcMpy( A, B : TSCplx) : TSCplx; stdcall;
function nspcDiv( A, B : TSCplx) : TSCplx; stdcall;
function nspcConj(A    : TSCplx) : TSCplx; stdcall;

procedure nspcAddOut( A, B : TSCplx; var Val : TSCplx); stdcall;
procedure nspcSubOut( A, B : TSCplx; var Val : TSCplx); stdcall;
procedure nspcMpyOut( A, B : TSCplx; var Val : TSCplx); stdcall;
procedure nspcDivOut( A, B : TSCplx; var Val : TSCplx); stdcall;
procedure nspcConjOut(A    : TSCplx; var Val : TSCplx); stdcall;

{---- Additional Functions -----------------------------------------------}
function  nspcSet(Re, Im : Float) : TSCplx; stdcall;
procedure nspcSetOut(Re, Im : Float; var Val : TSCplx); stdcall;

{-------------------------------------------------------------------------}
{        Vector Initialization                                            }
{   These functions initialize vectors of length n.                       }
procedure nspsbZero(Dst : PFloat; N : integer); stdcall;
procedure nspcbZero(Dst : PSCplx; N : integer); stdcall;

procedure nspsbSet(Val    : Float; Dst : PFloat; N : integer); stdcall;
procedure nspcbSet(Re, Im : Float; Dst : PSCplx; N : integer); stdcall;

procedure nspsbCopy(Src : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbCopy(Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{        Vector Addition and multiplication                               }
{  These functions perform element-wise arithmetic on vectors of length n }

{ dst[i]=dst[i]+val;                                                      }
procedure nspsbAdd1(Val : Float;  Dst : PFloat; N : integer); stdcall;
procedure nspcbAdd1(Val : TSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]+src[i];                                                   }
procedure nspsbAdd2(Src : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbAdd2(Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=srcA[i]+srcB[i];                                                 }
procedure nspsbAdd3(SrcA : PFloat; SrcB : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbAdd3(SrcA : PSCplx; SrcB : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]-val;                                                      }
procedure nspsbSub1(Val : Float;  Dst : PFloat; N : integer); stdcall;
procedure nspcbSub1(Val : TSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]-val[i];                                                   }
procedure nspsbSub2(Val : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbSub2(Val : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=src[i]-val[i];                                                   }
procedure nspsbSub3(Src : PFloat; Val : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbSub3(Src : PSCplx; Val : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]*val;                                                      }
procedure nspsbMpy1(Val : Float;  Dst : PFloat; N : integer); stdcall;
procedure nspcbMpy1(Val : TSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]*src[i];                                                   }
procedure nspsbMpy2(Src : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbMpy2(Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=srcA[i]*srcB[i];                                                 }
procedure nspsbMpy3(SrcA : PFloat; SrcB : PFloat; Dst : PFloat; N : integer); stdcall;
procedure nspcbMpy3(SrcA : PSCplx; SrcB : PSCplx; Dst : PSCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{        Complex conjugates of scalars and vectors                        }

procedure nspcbConj1      (Vec : PSCplx;               N : integer); stdcall;
procedure nspcbConj2      (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;
procedure nspcbConjFlip2  (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;
procedure nspcbConjExtend1(Vec : PSCplx;               N : integer); stdcall;
procedure nspcbConjExtend2(Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{   Miscellaneous Scalar Functions and Vector Functions                   }
{        Complex Add, Sub, Mpy, Div, Conj                                 }
{   These functions perform addition, subtraction, multiplication,        }
{   division, and conjugation on complex numbers a and b.                 }
{                                                                         }

function nspzAdd( A, B : TDCplx) : TDCplx; stdcall;
function nspzSub( A, B : TDCplx) : TDCplx; stdcall;
function nspzMpy( A, B : TDCplx) : TDCplx; stdcall;
function nspzDiv( A, B : TDCplx) : TDCplx; stdcall;
function nspzConj(A    : TDCplx) : TDCplx; stdcall;

{---- Additional Functions -----------------------------------------------}

function nspzSet(Re, Im : Double) : TDCplx; stdcall;

{-------------------------------------------------------------------------}
{        Vector Initialization                                            }
{   These functions initialize vectors of length n.                       }

procedure nspdbZero(Dst : PDouble; N : Integer); stdcall;
procedure nspzbZero(Dst : PDCplx;  N : Integer); stdcall;

procedure nspdbSet(Val    : Double; Dst : PDouble; N : Integer); stdcall;
procedure nspzbSet(Re, Im : Double; Dst : PDCplx;  N : Integer); stdcall;

procedure nspdbCopy(Src, Dst : PDouble; N : Integer); stdcall;
procedure nspzbCopy(Src, Dst : PDCplx;  N : Integer); stdcall;

{-------------------------------------------------------------------------}
{        Vector Addition and multiplication                               }
{   These functions perform element-wise arithmetic on vectors of length n}

{ dst[i]=dst[i]+val;                                                      }
procedure nspdbAdd1(Val : Double; Dst : PDouble; N : Integer); stdcall;
procedure nspzbAdd1(Val : TDCplx; Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]+src[i];                                                   }
procedure nspdbAdd2(Src, Dst : PDouble; N : Integer); stdcall;
procedure nspzbAdd2(Src, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=srcA[i]+srcB[i];                                                 }
procedure nspdbAdd3(SrcA, SrcB, Dst : PDouble; N : Integer); stdcall;
procedure nspzbAdd3(SrcA, SrcB, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]-val;                                                      }
procedure nspdbSub1(Val : Double; Dst : PDouble; N : Integer); stdcall;
procedure nspzbSub1(Val : TDCplx; Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]-val[i];                                                   }
procedure nspdbSub2(Val, Dst : PDouble; N : Integer); stdcall;
procedure nspzbSub2(Val, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=src[i]-val[i];                                                   }
procedure nspdbSub3(Src, Val, Dst : PDouble; N : Integer); stdcall;
procedure nspzbSub3(Src, Val, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]*val;                                                      }
procedure nspdbMpy1(Val : Double; Dst : PDouble; N : Integer); stdcall;
procedure nspzbMpy1(Val : TDCplx; Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]*src[i];                                                   }
procedure nspdbMpy2(Src, Dst : PDouble; N : Integer); stdcall;
procedure nspzbMpy2(Src, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=srcA[i]*srcB[i];                                                 }
procedure nspdbMpy3(SrcA, SrcB, Dst : PDouble; N : Integer); stdcall;
procedure nspzbMpy3(SrcA, SrcB, Dst : PDCplx;  N : Integer); stdcall;

{-------------------------------------------------------------------------}
{                                                                         }
{        Complex conjugates of scalars and vectors                        }
{                                                                         }

procedure nspzbConj1(      Vec      : PDCplx; N : Integer); stdcall;
procedure nspzbConj2(      Src, Dst : PDCplx; N : Integer); stdcall;
procedure nspzbConjFlip2(  Src, Dst : PDCplx; N : Integer); stdcall;
procedure nspzbConjExtend1(Vec      : PDCplx; N : Integer); stdcall;
procedure nspzbConjExtend2(Src, Dst : PDCplx; N : Integer); stdcall;

{-------------------------------------------------------------------------}
{   Miscellaneous Scalar Functions and Vector Functions                   }
{        Complex Add, Sub, Mpy, Div, Conj                                 }
{   These functions perform addition, subtraction, multiplication,        }
{   division, and conjugation on complex numbers a and b.                 }
{                                                                         }

function nspvAdd(A, B        : TWCplx;
                 ScaleMode   : integer;
             var ScaleFactor : integer) : TWCplx; stdcall;
function nspvSub(A, B        : TWCplx;
                 ScaleMode   : integer;
             var ScaleFactor : integer) : TWCplx; stdcall;
function nspvMpy(A, B        : TWCplx;
                 ScaleMode   : integer;
             var ScaleFactor : integer) : TWCplx; stdcall;
function nspvDiv(A, B        : TWCplx)  : TWCplx; stdcall;
function nspvConj(A          : TWCplx)  : TWCplx; stdcall;

{---- Additional Functions -----------------------------------------------}

function nspvSet(Re, Im : Short) : TWCplx; stdcall;

{-------------------------------------------------------------------------}
{        Vector Initialization                                            }
{   These functions initialize vectors of length n.                       }

procedure nspwbZero(Dst : PShort; N : integer); stdcall;
procedure nspvbZero(Dst : PWCplx; N : integer); stdcall;

procedure nspwbSet(Val    : Short; Dst : PShort; N : integer); stdcall;
procedure nspvbSet(Re, Im : Short; Dst : PWCplx; N : integer); stdcall;

procedure nspwbCopy(Src : PShort; Dst : PShort; N : integer); stdcall;
procedure nspvbCopy(Src : PWCplx; Dst : PWCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{        Vector Addition and multiplication                               }
{   These functions perform element-wise arithmetic on vectors of length n}

procedure nspwbAdd1(Val         : Short;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbAdd1(Val         : TWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbAdd2(Src         : PShort;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbAdd2(Src         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbAdd3(SrcA        : PShort;
                    SrcB        : PShort;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbAdd3(SrcA        : PWCplx;
                    SrcB        : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbSub1(Val         : Short;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbSub1(Val         : TWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbSub2(Val         : PShort;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbSub2(Val         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbSub3(Src         : PShort;
                    Val         : PShort;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbSub3(Src         : PWCplx;
                    Val         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbMpy1(Val         : Short;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbMpy1(Val         : TWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbMpy2(Val         : PShort;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbMpy2(Val         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

procedure nspwbMpy3(SrcA        : PShort;
                    SrcB        : PShort;
                    Dst         : PShort;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
procedure nspvbMpy3(SrcA        : PWCplx;
                    SrcB        : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

{-------------------------------------------------------------------------}
{        Complex conjugates of vectors                                    }

procedure nspvbConj1(      Vec : PWCplx;               N : integer); stdcall;
procedure nspvbConj2(      Src : PWCplx; Dst : PWCplx; N : integer); stdcall;
procedure nspvbConjFlip2(  Src : PWCplx; Dst : PWCplx; N : integer); stdcall;
procedure nspvbConjExtend1(Vec : PWCplx;               N : integer); stdcall;
procedure nspvbConjExtend2(Src : PWCplx; Dst : PWCplx; N : integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1999 Intel Corporation. All Rights Reserved.

From:    nspatan.h
Purpose: Header file for function nspAtan
Author:  Turutin Y.
*)

procedure nspsbArctan1(Vec      : PFloat;  Len : Integer); stdcall;
procedure nspsbArctan2(Src, Dst : PFloat;  Len : Integer); stdcall;
procedure nspdbArctan1(Vec      : PDouble; Len : Integer); stdcall;
procedure nspdbArctan2(Src, Dst : PDouble; Len : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspcnv2d.h
Purpose: NSP 2D Filtering Functions
*)

{-------------------------------------------------------------------------}
{         Conv2D                                                          }
{                                                                         }
{ Perform finite, linear convolution of two two-dimensional signals.      }

procedure nspsConv2D(X           : PFloat;  XCols : Integer; XRows : Integer;
                     H           : PFloat;  HCols : Integer; HRows : Integer;
                     Y           : PFloat);  stdcall;
procedure nspdConv2D(X           : PDouble; XCols : Integer; XRows : Integer;
                     H           : PDouble; HCols : Integer; HRows : Integer;
                     Y           : PDouble); stdcall;
procedure nspwConv2D(X           : PShort;  XCols : Integer; XRows : Integer;
                     H           : PShort;  HCols : Integer; HRows : Integer;
                     Y           : PShort;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspconv.h
Purpose: NSP Convolution
*)

{-------------------------------------------------------------------------}
{         Conv                                                            }
{                                                                         }
{ Performs finite, linear convolution of two sequences.                   }

procedure nspsConv(X           : PFloat;  XLen : Integer;
                   H           : PFloat;  HLen : Integer;
                   Y           : PFloat); stdcall;
procedure nspcConv(X           : PSCplx;  XLen : Integer;
                   H           : PSCplx;  HLen : Integer;
                   Y           : PFloat); stdcall;
procedure nspdConv(X           : PDouble; XLen : Integer;
                   H           : PDouble; HLen : Integer;
                   Y           : PDouble); stdcall;
procedure nspzConv(X           : PDCplx;  XLen : Integer;
                   H           : PDCplx;  HLen : Integer;
                   Y           : PDCplx); stdcall;
procedure nspwConv(X           : PShort;  XLen : Integer;
                   H           : PShort;  HLen : Integer;
                   Y           : PShort;
                   ScaleMode   : Integer;
               var ScaleFactor : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspcorr.h
Purpose: NSP Correlation
*)

type
  TNSPAutoCorrType = (NSP_Normal, NSP_Biased, NSP_UnBiased);

{------------------------------------------------------------------------}
{        AutoCorrelation                                                 }
{                                                                        }
{
  Normal:
  ~~~~~~~
  dst[n] = S ~src[k] * src[k+n],  0 <= n < nLags
                                  0 <= k < len

  Biased:
  ~~~~~~~
  dst[n] = K* S ~src[k] * src[k+n],  0 <= n < nLags
                                     0 <= k < len
                                     K = 1/len
  UnBiased:
  ~~~~~~~~~
  dst[n] = K* S ~src[k] * src[k+n],  0 <= n < nLags
                                     0 <= k < len
                                     K = 1/(len-n)

                                             | src[k], 0<=k<len
                                   src(k) = <
                                             | 0, otherwise
}

procedure nspsAutoCorr(Src         : PFloat;  Len   : Integer;
                       Dst         : PFloat;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
procedure nspcAutoCorr(Src         : PSCplx;  Len   : Integer;
                       Dst         : PSCplx;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
procedure nspdAutoCorr(Src         : PDouble; Len   : Integer;
                       Dst         : PDouble; NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
procedure nspzAutoCorr(Src         : PDCplx;  Len   : Integer;
                       Dst         : PDCplx;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
procedure nspwAutoCorr(Src         : PShort;  Len   : Integer;
                       Dst         : PShort;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;
procedure nspvAutoCorr(Src         : PWCplx;  Len   : Integer;
                       Dst         : PWCplx;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;

{------------------------------------------------------------------------}
{        CrossCorralation                                                }
{
  dst[n] = S ~srcA[k] * srcB[k+n+loLag],  0 <= n <= hiLag-loLag
                                          0 <= k < lenA

                                                 | srcB[k], 0<=k<lenB
                                       srcB(k) = <
                                                 | 0, otherwise
  Number of result elements is hiLag-loLag+1.
  Estimate at lag of loLag in dst[0].
  Estimate at lag of hiLag in dst[hiLag-loLag].
}

procedure nspsCrossCorr(SrcA        : PFloat;  LenA         : Integer;
                        SrcB        : PFloat;  LenB         : Integer;
                        Dst         : PFloat;  LoLag, HiLag : Integer); stdcall;
procedure nspcCrossCorr(SrcA        : PSCplx;  LenA         : Integer;
                        SrcB        : PSCplx;  LenB         : Integer;
                        Dst         : PSCplx;  LoLag, HiLag : Integer); stdcall;
procedure nspdCrossCorr(SrcA        : PDouble; LenA         : Integer;
                        SrcB        : PDouble; LenB         : Integer;
                        Dst         : PDouble; LoLag, HiLag : Integer); stdcall;
procedure nspzCrossCorr(SrcA        : PDCplx;  LenA         : Integer;
                        SrcB        : PDCplx;  LenB         : Integer;
                        Dst         : PDCplx;  LoLag, HiLag : Integer); stdcall;
procedure nspwCrossCorr(SrcA        : PShort;  LenA         : Integer;
                        SrcB        : PShort;  LenB         : Integer;
                        Dst         : PShort;  LoLag, HiLag : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;
procedure nspvCrossCorr(SrcA        : PWCplx;  LenA         : Integer;
                        SrcB        : PWCplx;  LenB         : Integer;
                        Dst         : PWCplx;  LoLag,HiLag  : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspcvrt.h
Purpose: Data Convertion Functions.
*)

{-------Flags to determine the transformation-----------------------------}

const
  NSP_Noflags   = $0000;     // Specifies an absence of all flags
  NSP_Round     = $0080;     // Specifies that floating-point values
                             // should be rounded to the nearest integer
  NSP_TruncZero = $0100;     // Specifies that floating-point values
                             // should be truncated toward zero
  NSP_TruncNeg  = $0200;     // Specifies that floating-point values
                             // should be truncated toward negative
                             // infinity
  NSP_TruncPos  = $0400;     // Specifies that floating-point values
                             // should be truncated toward positive
                             // infinity
  NSP_Unsigned  = $0800;     // Specifies that integer values are
                             // unsigned
  NSP_Clip      = $1000;     // Specifies that floating-point values
                             // outside the allowable integer range
                             // are saturated to maximum(minimum)
                             // integer value
  NSP_OvfErr    = $2000;     // Specifies that an overflow error should
                             // be signaled with a call to nspError()

{-------------------------------------------------------------------------}
{ Maximum possible phase value for short function, corresponds to NSP_PI  }

  NSP_CVRT_MAXPHASE = 16383;

{-------------------------------------------------------------------------}
{             bFloatToInt, bIntToFloat                                    }
{                                                                         }
{Vector floating-point to integer and integer to floating-point conversion}
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,d>bFloatToInt                                                   }
{ DESCRIPTION:                                                            }
{   Converts the float point data in the input array and stores           }
{   the results in the output array.                                      }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an integer in bits,                 }
{                     and must be 8, 16 or 32;                            }
{   flags     - specifies the sort of the conversion and consists of the  }
{               bitwise-OR of flags, defined in the beginnig of this file }
{                                                                         }

procedure nspsbFloatToInt(Src      : PFloat;  Dst   : Pointer; Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;
procedure nspdbFloatToInt(Src      : PDouble; Dst   : Pointer; Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>bIntToFloat                                                   }
{ DESCRIPTION:                                                            }
{   Converts the integer data in the input array and stores the results   }
{   in the output array                                                   }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an integer in bits,                 }
{                     and must be 8, 16 or 32;                            }
{   flags     - specifies that integer values are unsigned or signed.     }
{                                                                         }

procedure nspsbIntToFloat(Src      : Pointer; Dst   : PFloat;  Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;
procedure nspdbIntToFloat(Src      : Pointer; Dst   : PDouble; Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;

{-------------------------------------------------------------------------}
{             bFloatToFix, bFixToFloat                                    }
{                                                                         }
{ Vector floating-point to fixed-point and                                }
{            fixed-point to floating-point conversion                     }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,d>bFloatToFix                                                   }
{ DESCRIPTION:                                                            }
{   Converts the floating-point data in the input array and stores        }
{   the results in the output array.                                      }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an fix-point in bits,               }
{                     and must be 8, 16 or 32;                            }
{   fractBits - specifies the number of fractional bits                   }
{   flags     - specifies the sort of the conversion and consists of the  }
{               bitwise-OR of flags, defined in the beginnig of this file }
{                                                                         }

procedure nspsbFloatToFix(Src       : PFloat;  Dst      : Pointer;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;
procedure nspdbFloatToFix(Src       : PDouble; Dst      : Pointer;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>bFixToFloat                                                   }
{ DESCRIPTION:                                                            }
{   Converts the fixed-point data in the input array and stores the       }
{       results in the output array                                       }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an integer in bits,                 }
{                     and must be 8, 16 or 32;                            }
{   fractBits - specifies the number of fractional bits                   }
{   flags     - specifies that fixed-point values are unsigned or signed  }
{                                                                         }

procedure nspsbFixToFloat(Src       : Pointer; Dst      : PFloat;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;
procedure nspdbFixToFloat(Src       : Pointer; Dst      : PDouble;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;

{-------------------------------------------------------------------------}
{ bFloatToS31Fix, bFloatToS15Fix, bFloatToS7Fix, bFloatToS1516Fix,        }
{ bS31FixToFloat, bS15FixToFloat, bS7FixToFloat, bS1516FixToFloat         }
{ Vector floating-point to fixed-point of format S.31, S.15, S.7, S15.16  }
{                and fixed-point of format S.31, S.15, S.7, S15.16        }
{                to floating-point conversion                             }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,d>bFloatToS31Fix                                                }
{   nsp<s,d>bFloatToS15Fix                                                }
{   nsp<s,d>bFloatToS7Fix                                                 }
{   nsp<s,d>bFloatToS1516Fix                                              }
{ DESCRIPTION:                                                            }
{   Converts the floating-point data in the input array and stores        }
{   the results in the output array.                                      }
{   nsp?bFloatToS31Fix() to format of S.31 (a sign bit,31 fractional bits)}
{   nsp?bFloatToS15Fix() to format of S.15 (a sign bit,15 fractional bits)}
{   nsp?bFloatToS7Fix()  to format of S.7  (a sign bit,7  fractional bits)}
{   nsp?bFloatToS1516Fix() to format of S15.16                            }
{                    (a sign bit, 15 integer bits, 16 fractional bits)    }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   flags     - specifies the sort of the conversion and consists of the  }
{               bitwise-OR of flags, defined in the beginnig of this file }

procedure nspsbFloatToS31Fix(  Src : PFloat;   Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;
procedure nspsbFloatToS15Fix(  Src : PFloat;   Dst   : PShort;
                               Len : Integer;  Flags : Integer); stdcall;
procedure nspsbFloatToS7Fix(   Src : PFloat;   Dst   : PByte;
                               Len : Integer;  Flags : Integer); stdcall;
procedure nspsbFloatToS1516Fix(Src : PFloat;   Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;

procedure nspdbFloatToS31Fix(  Src : PDouble;  Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;
procedure nspdbFloatToS15Fix(  Src : PDouble;  Dst   : PShort;
                               Len : Integer;  Flags : Integer); stdcall;
procedure nspdbFloatToS7Fix(   Src : PDouble;  Dst   : PByte;
                               Len : Integer;  Flags : Integer); stdcall;
procedure nspdbFloatToS1516Fix(Src : PDouble;  Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>bS31FixToFloat                                                }
{   nsp<s,d>bS15FixToFloat                                                }
{   nsp<s,d>bS7FixToFloat                                                 }
{   nsp<s,d>bS1516FixToFloat                                              }
{ DESCRIPTION:                                                            }
{   Converts the fixed-point data in the input array and stores the       }
{       results in the output array                                       }
{  nsp?bS31FixToFloat() from format of S.31(a sign bit,31 fractional bits)}
{  nsp?bS15FixToFloat() from format of S.15(a sign bit,15 fractional bits)}
{  nsp?bS7FixToFloat()  from format of S.7 (a sign bit,7  fractional bits)}
{  nsp?bS1516FixToFloat() from format of S15.16                           }
{                    (a sign bit, 15 integer bits, 16 fractional bits)    }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{                                                                         }

procedure nspsbS31FixToFloat(  Src : PLongint; Dst : PFloat;
                               Len : Integer); stdcall;
procedure nspsbS15FixToFloat(  Src : PShort;   Dst : PFloat;
                               Len : Integer); stdcall;
procedure nspsbS7FixToFloat(   Src : PByte;    Dst : PFloat;
                               Len : Integer); stdcall;
procedure nspsbS1516FixToFloat(Src : Plongint; Dst : PFloat;
                               Len : Integer); stdcall;

procedure nspdbS31FixToFloat(  Src : PLongint; Dst : PDouble;
                               Len : Integer); stdcall;
procedure nspdbS15FixToFloat(  Src : PShort;   Dst : PDouble;
                               Len : Integer); stdcall;
procedure nspdbS7FixToFloat(   Src : PByte;    Dst : PDouble;
                               Len : Integer); stdcall;
procedure nspdbS1516FixToFloat(Src : Plongint; Dst : PDouble;
                               Len : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bReal, bImag, bCplxTo2Real, b2RealToCplx                               }
{                                                                         }
{ Return the real and imaginary parts of complex vectors                  }
{ or construct complex vectors from real and imaginary components         }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bReal                                                       }
{ DESCRIPTION:                                                            }
{   Return the real part of the coplex vector                             }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   dst       - an output vector to store the real part;                  }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspcbReal(Src : PSCplx; Dst : PFloat;  Len : Integer); stdcall;
procedure nspzbReal(Src : PDCplx; Dst : PDouble; Len : Integer); stdcall;
procedure nspvbReal(Src : PWCplx; Dst : PShort;  Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bImag                                                       }
{ DESCRIPTION:                                                            }
{   Return the imaginary part of the coplex vector                        }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   dst       - an output vector to store the imaginary part;             }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspcbImag(Src : PSCplx; Dst : PFloat;  Len : Integer); stdcall;
procedure nspzbImag(Src : PDCplx; Dst : PDouble; Len : Integer); stdcall;
procedure nspvbImag(Src : PWCplx; Dst : PShort;  Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bCplxTo2Real                                                }
{ DESCRIPTION:                                                            }
{   Return the real and imaginary parts of the coplex vector              }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   dstReal   - an output vector to store the real part                   }
{   dstImag   - an output vector to store the imaginary part;             }
{   len       - a length of the arrays;                                   }
{                                                                         }

procedure nspcbCplxTo2Real(Src : PSCplx; DstReal, DstImag : PFloat;
                           Len : Integer); stdcall;
procedure nspzbCplxTo2Real(Src : PDCplx; DstReal, DstImag : PDouble;
                           Len : Integer); stdcall;
procedure nspvbCplxTo2Real(Src : PWCplx; DstReal, DstImag : PShort;
                           Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>b2RealToCplx                                                }
{ DESCRIPTION:                                                            }
{   Construct complex vector from real and imaginary components           }
{ PARAMETERS:                                                             }
{   srcReal   - an input real component. May be NULL - a real part of the }
{               output will be zero;                                      }
{   srcImag   - an input imaginary component. May be NULL - an imaginary  }
{               part of the output will be zero;                          }
{   dst       - an output complex vector;                                 }
{   len       - a length of the arrays;                                   }
{                                                                         }

procedure nspcb2RealToCplx(SrcReal, SrcImag : PFloat;  Dst : PSCplx;
                           Len              : Integer); stdcall;
procedure nspzb2RealToCplx(SrcReal, SrcImag : PDouble; Dst : PDCplx;
                           Len              : Integer); stdcall;
procedure nspvb2RealToCplx(SrcReal, SrcImag : PShort;  Dst : PWCplx;
                           Len              : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bCartToPolar, brCartToPolar, bPolarToCart, brPolarToCart               }
{                                                                         }
{ Cartesian to polar and polar to cartesian coordinate conversions.       }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bCartToPolar                                                }
{ DESCRIPTION:                                                            }
{   Convert cartesian coordinate to polar. Input data are formed as       }
{            a complex vector.                                            }
{ PARAMETERS:                                                             }
{   src       - an input complex vector;                                  }
{   mag       - an output vector to store the magnitude components;       }
{   phase     - an output vector to store the phase components (in rad)); }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspcbCartToPolar(Src : PSCplx; Mag, Phase : PFloat;
                           Len : Integer); stdcall;
procedure nspzbCartToPolar(Src : PDCplx; Mag, Phase : PDouble;
                           Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brCartToPolar                                               }
{ DESCRIPTION:                                                            }
{   Convert cartesian coordinate to polar. Input data are formed as       }
{            two different real vectors.                                  }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing the coordinates X;             }
{   srcImag   - an input vector containing the coordinates Y;             }
{   mag       - an output vector to store the magnitude components;       }
{   phase     - an output vector to store the phase components (in rad)); }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspsbrCartToPolar(SrcReal : PFloat;  SrcImag : PFloat;
                            Mag     : PFloat;  Phase   : PFloat;
                            Len     : Integer); stdcall;
procedure nspdbrCartToPolar(SrcReal : PDouble; SrcImag : PDouble;
                            Mag     : PDouble; Phase   : PDouble;
                            Len     : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bPolarToCart                                                }
{ DESCRIPTION:                                                            }
{   Convert polar coordinate to cartesian. Output data are formed as      }
{            a complex vector.                                            }
{ PARAMETERS:                                                             }
{   mag       - an input vector containing the magnitude components;      }
{   phase     - an input vector containing the phase components(in rad)); }
{   dst       - an output complex vector to store the cartesian coords;   }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspcbPolarToCart(Mag : PFloat;  Phase : PFloat;
                           Dst : PSCplx;  Len   : Integer); stdcall;
procedure nspzbPolarToCart(Mag : PDouble; Phase : PDouble;
                           Dst : PDCplx;  Len   : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>brPolarToCart                                                 }
{ DESCRIPTION:                                                            }
{   Convert polar coordinate to cartesian. Output data are formed as      }
{            two real vectors.                                            }
{ PARAMETERS:                                                             }
{   mag       - an input vector containing the magnitude components;      }
{   phase     - an input vector containing the phase components(in rad)); }
{   dstReal   - an output complex vector to store the coordinates X;      }
{   dstImag   - an output complex vector to store the coordinates Y;      }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspsbrPolarToCart(Mag     : PFloat;  Phase   : PFloat;
                            DstReal : PFloat;  DstImag : PFloat;
                            Len     : Integer); stdcall;
procedure nspdbrPolarToCart(Mag     : PDouble; Phase   : PDouble;
                            DstReal : PDouble; DstImag : PDouble;
                            Len     : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bPowerSpectr, brPowerSpectr, bMag, brMag, bPhase, brPhase              }
{                                                                         }
{ Compute the magnitude and phase of complex vector elements.             }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bMag                                                        }
{ DESCRIPTION:                                                            }
{   Compute the magnitude of complex vector elements.                     }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   mag       - an output vector to store the magnitude components;       }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspcbMag(Src         : PSCplx; Mag : PFloat;  Len : Integer); stdcall;
procedure nspzbMag(Src         : PDCplx; Mag : PDouble; Len : Integer); stdcall;
procedure nspvbMag(Src         : PWCplx; Mag : PShort;  Len : Integer;
                   ScaleMode   : Integer;
               var ScaleFactor : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brMag                                                       }
{ DESCRIPTION:                                                            }
{   Compute the magnitude of complex data formed as two real vectors.     }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing a real part of complex data    }
{   srcImag   - an input vector containing an imag. part of complex data  }
{   mag       - an output vector to store the magnitude components;       }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspsbrMag(SrcReal     : PFloat;  SrcImag : PFloat;
                    Mag         : PFloat;  Len     : Integer); stdcall;
procedure nspdbrMag(SrcReal     : PDouble; SrcImag : PDouble;
                    Mag         : PDouble; Len     : Integer); stdcall;
procedure nspwbrMag(SrcReal     : PShort;  SrcImag : PShort;
                    Mag         : PShort;  Len     : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bPhase                                                      }
{ DESCRIPTION:                                                            }
{   Compute the phase (in radians) of complex vector elements.            }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   phase     - an output vector to store the phase components;           }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }

procedure nspcbPhase(Src : PSCplx; Phase : PFloat;  Len : Integer); stdcall;
procedure nspzbPhase(Src : PDCplx; Phase : PDouble; Len : Integer); stdcall;
procedure nspvbPhase(Src : PWCplx; Phase : PShort;  Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brPhase                                                     }
{ DESCRIPTION:                                                            }
{   Compute the phase of complex data formed as two real vectors.         }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing a real part of complex data    }
{   srcImag   - an input vector containing an imag. part of complex data  }
{   phase     - an output vector to store the magnitude components;       }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }

procedure nspsbrPhase(SrcReal : PFloat;  SrcImag : PFloat;
                      Phase   : PFloat;  Len     : Integer); stdcall;
procedure nspdbrPhase(SrcReal : PDouble; SrcImag : PDouble;
                      Phase   : PDouble; Len     : Integer); stdcall;
procedure nspwbrPhase(SrcReal : PShort;  SrcImag : PShort;
                      Phase   : PShort;  Len     : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bPowerSpectr, brPowerSpectr                                            }
{                                                                         }
{ Compute the power spectrum of complex vector.                           }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bPowerSpectr                                                }
{ DESCRIPTION:                                                            }
{   Compute the power spectrum of complex vector.                         }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   spectr    - an output vector to store the power spectrum components;  }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspcbPowerSpectr(Src         : PSCplx; Spectr : PFloat;
                           Len         : Integer); stdcall;
procedure nspzbPowerSpectr(Src         : PDCplx; Spectr : PDouble;
                           Len         : Integer); stdcall;
procedure nspvbPowerSpectr(Src         : PWCplx; Spectr : PShort;
                           Len         : Integer;
                           ScaleMode   : Integer;
                       var ScaleFactor : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brPowerSpectr                                               }
{ DESCRIPTION:                                                            }
{   Compute the power spectrum of complex data formed as two real vectors }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing a real part of complex data    }
{   srcImag   - an input vector containing an imag. part of complex data  }
{   spectr    - an output vector to store the power spectrum components;  }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

procedure nspsbrPowerSpectr(SrcReal     : PFloat;  SrcImag : PFloat;
                            Spectr      : PFloat;  Len     : Integer); stdcall;
procedure nspdbrPowerSpectr(SrcReal     : PDouble; SrcImag : PDouble;
                            Spectr      : PDouble; Len     : Integer); stdcall;
procedure nspwbrPowerSpectr(SrcReal     : PShort;  SrcImag : PShort;
                            Spectr      : PShort;  Len     : Integer;
                            ScaleMode   : Integer;
                        var ScaleFactor : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspdct.h
Purpose:
*)

const
  NSP_DCT_Forward = 1;
  NSP_DCT_Inverse = 2;
  NSP_DCT_Free    = 8;

procedure nspsDct(Src, Dst : PFloat;  Len : Integer; Flags : Integer); stdcall;
procedure nspdDct(Src, Dst : PDouble; Len : Integer; Flags : Integer); stdcall;
procedure nspwDct(Src, Dst : PShort;  Len : Integer; Flags : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspdiv.h
Purpose: NSP Vector Arithmetics
*)

{-------------------------------------------------------------------------}
{                 Vector division functions                               }
{-------------------------------------------------------------------------}

{
  FUNCTION
    nsp?bDiv1

  DESCRIPTION
    Performs an element-wise division of elements
    of vectors and value.

       dst[i] /= val

  PARAMETERS
    val  value operand
    dst  Pointer to the input/output vector.
    n    The number of elements to be operated on.

  RETURN
    status
}
function nspsbDiv1(Val : Float;  Dst : PFloat;  N : Integer) : Integer; stdcall;
function nspdbDiv1(Val : Double; Dst : PDouble; N : Integer) : Integer; stdcall;
function nspwbDiv1(Val : Short;  Dst : PShort;  N : Integer) : Integer; stdcall;
function nspcbDiv1(Val : TSCplx; Dst : PSCplx;  N : Integer) : Integer; stdcall;
function nspzbDiv1(Val : TDCplx; Dst : PDCplx;  N : Integer) : Integer; stdcall;
function nspvbDiv1(Val : TWCplx; Dst : PWCplx;  N : Integer) : Integer; stdcall;

{
  FUNCTION
    nspsbDiv2

  DESCRIPTION
    Division the elements of two vectors and stores the results
    in the output array.

       dst[i] /= src[i]

  PARAMETERS
    src  Pointer to the vector to be Div
    dst  Pointer to the vector dst which stores the results
         of the Div operation src and dst.
    n    The number of elements to be operated on.

  RETURN
    status

}
function nspsbDiv2(Src : PFloat;  Dst : PFloat;  N : Integer) : Integer; stdcall;
function nspdbDiv2(Src : PDouble; Dst : PDouble; N : Integer) : Integer; stdcall;
function nspwbDiv2(Src : PShort;  Dst : PShort;  N : Integer) : Integer; stdcall;
function nspcbDiv2(Src : PSCplx;  Dst : PSCplx;  N : Integer) : Integer; stdcall;
function nspzbDiv2(Src : PDCplx;  Dst : PDCplx;  N : Integer) : Integer; stdcall;
function nspvbDiv2(Src : PWCplx;  Dst : PWCplx;  N : Integer) : Integer; stdcall;

{
  FUNCTION
    nspsbDiv3

  DESCRIPTION
    Performs an element-wise operation of elements
    of vectors and stores the results in a third.

       dst[i] = srcA[i] / srcB[i]

  PARAMETERS
    srcA Points to the first source vector
    srcB Pointers to the second source vector.
    dst  Pointer to the vector dst which stores the results
         of the Div operation srcA and srcB.
    n    The number of elements to be operated on.

  RETURN
    status
}

function nspsbDiv3(SrcA, SrcB, Dst : PFloat;  N : Integer) : Integer; stdcall;
function nspdbDiv3(SrcA, SrcB, Dst : PDouble; N : Integer) : Integer; stdcall;
function nspwbDiv3(SrcA, SrcB, Dst : PShort;  N : Integer) : Integer; stdcall;
function nspcbDiv3(SrcA, SrcB, Dst : PSCplx;  N : Integer) : Integer; stdcall;
function nspzbDiv3(SrcA, SrcB, Dst : PDCplx;  N : Integer) : Integer; stdcall;
function nspvbDiv3(SrcA, SrcB, Dst : PWCplx;  N : Integer) : Integer; stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspdotp.h
Purpose: NSP Vector Product Functions
*)

function nspsDotProd(SrcA, SrcB  : PFloat;  Len : Integer) : Float;  stdcall;
function nspcDotProd(SrcA, SrcB  : PSCplx;  Len : Integer) : TSCplx; stdcall;
procedure nspcDotProdOut(SrcA, SrcB : PSCplx; Len : Integer;
                     var Val : TSCplx); stdcall;
function nspdDotProd(SrcA, SrcB  : PDouble; Len : Integer) : Double; stdcall;
function nspzDotProd(SrcA, SrcB  : PDCplx;  Len : Integer) : TDCplx; stdcall;
function nspwDotProd(SrcA, SrcB  : PShort;  Len : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer)                : Short;  stdcall;
function nspvDotProd(SrcA, SrcB  : PWCplx;  Len : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer)                : TWCplx; stdcall;

{ Extend Dot Prod functions }
function nspwDotProdExt(SrcA, SrcB  : PShort; Len : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer) : Integer; stdcall;
function nspvDotProdExt(SrcA, SrcB  : PWCplx; Len : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer) : TICplx;  stdcall;
procedure nspvDotProdExtOut(SrcA, SrcB  : PWCplx; Len : Integer;
                            ScaleMode   : Integer;
                        var ScaleFactor : Integer;
                        var Val         : TICplx); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsperror.h
Purpose: NSP Error Handling Module
*)

type
  PNSPLibVersion = ^TNSPLibVersion;
  TNSPLibVersion = record
    Major           : Integer;    // e.g. 4
    Minor           : Integer;    // e.g. 00
    Build           : Integer;    // e.g. 32
    Name            : PChar;      // e.g. "nspp6l.lib","nspm5.dll"
    Version         : PChar;      // e.g. "v4.00"
    InternalVersion : PChar;      // e.g. "[4.00.32, 17/03/98]"
    BuildDate       : PChar;      // e.g. "Mar 17 98"
    CallConv        : PChar;      // e.g. "DLL",..
  end;

{--- NSPErrStatus,NSPErrMode Values Definition ---}

//* common status code definitions */
const
  NSP_StsOk           =  0;         // everithing is ok
  NSP_StsBackTrace    = -1;         // pseudo error for back trace
  NSP_StsError        = -2;         // unknown /unspecified error
  NSP_StsInternal     = -3;         // internal error (bad state)
  NSP_StsNoMem        = -4;         // out of memory
  NSP_StsBadArg       = -5;         // function arg/param is bad
  NSP_StsBadFunc      = -6;         // unsupported function
  NSP_StsNoConv       = -7;         // iter. didn't converge
  NSP_StsAutoTrace    = -8;         // Tracing through nsptrace.h
  NSP_StsDivideByZero = -9;
  NSP_StsNullPtr      = -10;
  NSP_StsBadSizeValue = -11;
  NSP_StsBadPtr       = -12;
  NSP_StsBadStruct    = -13;
  NSP_StsBadLen       = -14;        // bad vector length

  NSP_ErrModeLeaf     = 0;          // Print error and exit program
  NSP_ErrModeParent   = 1;          // Print error and continue
  NSP_ErrModeSilent   = 2;          // Don't print and continue

//* custom status code definitions */
  //* nspsmpl */
  NSP_StsBadFact       = -50;        // Negative FactorRange
  //* nspfirg */
  NSP_StsBadFreq       = -51;        // bad frequency value
  NSP_StsBadRel        = -52;        // bad relation between frequency

type
  TNSPErrorCallBack = function(
    Status   : NSPStatus;
    FuncName : PChar;
    Context  : PChar;
    FileName : PChar;
    Line     : Integer) : Integer; stdcall;

{ Flags for scaleMode parameter of nsp?Func(...,scaleMode,scaleFactor)    }
const
  NSP_NO_SCALE    = $0000;        // ignore factor
  NSP_FIXED_SCALE = $0002;        // fixed factor value
  NSP_AUTO_SCALE  = $0004;        // detect factor value

  NSP_OVERFLOW    = $0000;        // wrapround
  NSP_SATURATE    = $0001;        // saturate

{--- Get Library Version -------------------------}
{ Returns pointer to NSP lib info structure       }
function nspGetLibVersion : PNSPLibVersion; stdcall;

{--- Get/Set ErrStatus ---------------------------}
function nspGetErrStatus : NSPStatus; stdcall;
procedure nspSetErrStatus(Status : NSPStatus); stdcall;

{--- NspStdErrMode Declaration -------------------}
function nspGetErrMode : Integer; stdcall;
procedure nspSetErrMode(Mode : Integer); stdcall;

{--- nspError,nspErrorStr Declaration ------------}
function nspError(
  Status   : NSPStatus;
  Func     : PChar;
  Context  : PChar;
  FileName : PChar;
  Line     : integer) : NSPStatus; stdcall;
function nspErrorStr(Status : NSPStatus) : PChar; stdcall;

{--- nspRedirectError Declaration ----------------}
function nspNulDevReport(
  Status   : NSPStatus;
  FuncName : PChar;
  Context  : PChar;
  FileName : PChar;
  Line     : integer) : NSPStatus; stdcall;
function nspStdErrReport(
  Status   : NSPStatus;
  FuncName : PChar;
  Context  : PChar;
  FileName : PChar;
  Line     : integer) : NSPStatus; stdcall;
function nspGuiBoxReport(
  Status   : NSPStatus;
  FuncName : PChar;
  Context  : PChar;
  FileName : PChar;
  Line     : integer) : NSPStatus; stdcall;
function nspRedirectError(
  nspErrorFunc : TNSPErrorCallBack) : TNSPErrorCallBack; stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspfft.h
Purpose: NSP Fourier Transforms
*)

const
  NSP_Forw        =     1;
  NSP_Inv         =     2;
  NSP_Init        =     4;
  NSP_Free        =     8;
  NSP_NoScale     =    16;
  NSP_NoBitRev    =    32;
  NSP_InBitRev    =    64;
  NSP_OutBitRev   =   128;
  NSP_OutRCPack   =   256;
  NSP_OutRCPerm   =   512;
  NSP_InRCPack    =  1024;
  NSP_InRCPerm    =  4096;
  NSP_DoIntCore   =  8192;
  NSP_DoFloatCore = 16384;
  NSP_DoFastMMX   = 32768;

{------------------------------------------------------------------------}
{                                                                        }
{                                  Dft                                   }
{                                                                        }
{ Compute the forward  or inverse discrete Fourier transform  (DFT)      }
{ of a complex signal.                                                   }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspvDft(InSamps   : PWCplx;      OutSamps    : PWCplx;
                  Len       : Integer;     Flags       : Integer;
                  ScaleMode : Integer; var ScaleFactor : Integer); stdcall;
procedure nspcDft(InSamps   : PSCplx;      OutSamps    : PSCplx;
                  Len       : Integer;     Flags       : Integer); stdcall;
procedure nspzDft(InSamps   : PDCplx;      OutSamps    : PDCplx;
                  Len       : Integer;     Flags       : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                                  Fft                                   }
{                                                                        }
{ Compute  the forward  or inverse   fast Fourier  transform (FFT)       }
{ of a complex signal.                                                   }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspvFft(   Samps       : PWCplx;
                     Order       : Integer;  Flags    : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;
procedure nspcFft(   Samps       : PSCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;
procedure nspzFft(   Samps       : PDCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;

procedure nspvFftNip(InSamps     : PWCplx;   OutSamps : PWCplx;
                     Order       : Integer;  Flags    : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;
procedure nspcFftNip(InSamps     : PSCplx;   OutSamps : PSCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;
procedure nspzFftNip(InSamps     : PDCplx;   OutSamps : PDCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;

procedure nspvrFft(  ReSamps     : PShort;   ImSamps  : PShort;
                     Order       : Integer;  Flags    : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;
procedure nspcrFft(  ReSamps     : PFloat;   ImSamps  : PFloat;
                     Order       : Integer;  Flags    : Integer); stdcall;
procedure nspzrFft(  ReSamps     : PDouble;  ImSamps  : PDouble;
                     Order       : Integer;  Flags    : Integer); stdcall;

procedure nspvrFftNip(ReInSamps   : PShort;   ImInSamps  : PShort;
                      ReOutSamps  : Pshort;   ImOutSamps : PShort;
                      Order       : Integer;  Flags      : Integer;
                      ScaleMode   : Integer;
                  var ScaleFactor : Integer); stdcall;
procedure nspcrFftNip(ReInSamps   : PFloat;   ImInSamps  : PFloat;
                      ReOutSamps  : PFloat;   ImOutSamps : PFloat;
                      Order       : Integer;  Flags      : Integer); stdcall;
procedure nspzrFftNip(ReInSamps   : PDouble;  ImInSamps  : PDouble;
                      ReOutSamps  : PDouble;  ImOutSamps : PDouble;
                      Order       : Integer;  Flags      : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                         RealFftl, RealFftlNip                          }
{                                                                        }
{ Compute the  forward or inverse FFT  of a real signal  using RCPack or }
{ RCPerm format.                                                         }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwRealFftl(Samps       : PShort;
                       Order       : Integer; Flags : Integer;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;
procedure nspsRealFftl(Samps       : PFloat;
                       Order       : Integer; Flags : Integer); stdcall;
procedure nspdRealFftl(Samps       : PDouble;
                       Order       : Integer; Flags : Integer); stdcall;

procedure nspwRealFftlNip(InSamps     : PShort;   OutSamps : PShort;
                          Order       : Integer;  Flags    : Integer;
                          ScaleMode   : Integer;
                      var ScaleFactor : Integer); stdcall;
procedure nspsRealFftlNip(InSamps     : PFloat;   OutSamps : PFloat;
                          Order       : Integer;  Flags    : Integer); stdcall;
procedure nspdRealFftlNip(InSamps     : PDouble;  OutSamps : PDouble;
                          Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                            CcsFftl, CcsFftlNip                         }
{                                                                        }
{ Compute the  forward or inverse  FFT of a  complex conjugate-symmetric }
{ (CCS) signal using RCPack or RCPerm format.                            }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwCcsFftl(   Samps       : PShort;
                         Order       : Integer;  Flags : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsCcsFftl(   Samps       : PFloat;
                         Order       : Integer;  Flags : Integer); stdcall;
procedure nspdCcsFftl(   Samps       : PDouble;
                         Order       : Integer;  Flags : Integer); stdcall;

procedure nspwCcsFftlNip(InSamps     : PShort;   OutSamps : PShort;
                         Order       : Integer;  Flags : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsCcsFftlNip(InSamps     : PFloat;   OutSamps : PFloat;
                         Order       : Integer;  Flags    : Integer); stdcall;
procedure nspdCcsFftlNip(InSamps     : PDouble;  OutSamps : PDouble;
                         Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                       MpyRCPack2, MpyRCPack3                           }
{                                                                        }
{ Multiply two vectors stored in RCPack format.                          }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwMpyRCPack2(Src         : PShort;  Dst : PShort;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsMpyRCPack2(Src         : PFloat;  Dst : PFloat;
                         Order       : Integer); stdcall;
procedure nspdMpyRCPack2(Src         : PDouble; Dst : PDouble;
                         Order       : Integer); stdcall;

procedure nspwMpyRCPack3(SrcA        : PShort;   SrcB : PShort;  Dst : PShort;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsMpyRCPack3(SrcA        : PFloat;   SrcB : PFloat;  Dst : PFloat;
                         Order       : Integer); stdcall;
procedure nspdMpyRCPack3(SrcA        : PDouble;  SrcB : PDouble; Dst : PDouble;
                         Order       : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                        MpyRCPerm2, MpyRCPerm3                          }
{                                                                        }
{ Multiply two vectors stored in RCPerm format.                          }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwMpyRCPerm2(Src         : PShort;   Dst : PShort;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsMpyRCPerm2(Src         : PFloat;   Dst : PFloat;
                         Order       : Integer); stdcall;
procedure nspdMpyRCPerm2(Src         : PDouble;  Dst : PDouble;
                         Order       : Integer); stdcall;

procedure nspwMpyRCPerm3(SrcA        : PShort;   SrcB : PShort;  Dst : PShort;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsMpyRCPerm3(SrcA        : PFloat;   SrcB : PFloat;  Dst : PFloat;
                         Order       : Integer); stdcall;
procedure nspdMpyRCPerm3(SrcA        : PDouble;  SrcB : PDouble; Dst : PDouble;
                         Order       : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                        RealFft,  RealFftNip                            }
{                                                                        }
{ Compute the forward or inverse FFT of a real signal.                   }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwRealFft(   Samps       : PShort;
                         Order       : Integer;  Flags : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsRealFft(   Samps       : PFloat;
                         Order       : Integer;  Flags : Integer); stdcall;
procedure nspdRealFft(   Samps       : PDouble;
                         Order       : Integer;  Flags : Integer); stdcall;

procedure nspwRealFftNip(InSamps     : PShort;   OutSamps : PWCplx;
                         Order       : Integer;  Flags    : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsRealFftNip(InSamps     : PFloat;   OutSamps : PSCplx;
                         Order       : Integer;  Flags    : Integer); stdcall;
procedure nspdRealFftNip(InSamps     : PDouble;  OutSamps : PDCplx;
                         Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                            CcsFft, CcsFftNip                           }
{                                                                        }
{ Compute the  forward or inverse  FFT of a  complex conjugate-symmetric }
{ (CCS) signal.                                                          }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwCcsFft(   Samps       : PShort;
                        Order       : Integer;  Flags : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;
procedure nspsCcsFft(   Samps       : PFloat;
                        Order       : Integer;  Flags : Integer); stdcall;
procedure nspdCcsFft(   Samps       : PDouble;
                        Order       : Integer;  Flags : Integer); stdcall;

procedure nspwCcsFftNip(InSamps     : PWCplx;   OutSamps : PShort;
                        Order       : Integer;  Flags    : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;
procedure nspsCcsFftNip(InSamps     : PSCplx;   OutSamps : PFloat;
                        Order       : Integer;  Flags    : Integer); stdcall;
procedure nspdCcsFftNip(InSamps     : PDCplx;   OutSamps : PDouble;
                        Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                    nsp?Real2Fft, nsp?Real2FftNip                       }
{                                                                        }
{ Compute the forward or inverse FFT of two real signals.                }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwReal2Fft(   XSamps      : PShort;   YSamps    : PShort;
                          Order       : Integer;  Flags     : Integer;
                          ScaleMode   : Integer;
                      var ScaleFactor : Integer); stdcall;
procedure nspsReal2Fft(   XSamps      : PFloat;   YSmaps    : PFloat;
                          Order       : integer;  Flags     : Integer); stdcall;
procedure nspdReal2Fft(   XSamps      : PDouble;  YSmaps    : PDouble;
                          Order       : integer;  Flags     : Integer); stdcall;

procedure nspwReal2FftNip(XInSamps    : PShort;   XOutSamps : PWCplx;
                          YInSamps    : PShort;   YOutSamps : PWCplx;
                          Order       : Integer;  Flags     : Integer;
                          ScaleMode   : Integer;
                      var ScaleFactor : Integer); stdcall;
procedure nspsReal2FftNip(XInSamps    : PFloat;   XOutSamps : PSCplx;
                          YInSamps    : PFloat;   YOutSamps : PSCplx;
                          Order       : Integer;  Flags     : Integer); stdcall;
procedure nspdReal2FftNip(XInSamps    : PDouble;  XOutSamps : PDCplx;
                          YInSamps    : PDouble;  YOutSamps : PDCplx;
                          Order       : Integer;  Flags     : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                    nsp?Ccs2Fft, nsp?Ccs2FftNip                         }
{                                                                        }
{ Compute the forward or reverse  FFT of two complex conjugate-symmetric }
{ (CCS) signals.                                                         }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwCcs2Fft(   XSamps      : PShort;  YSamps     : PShort;
                         Order       : Integer;  Flags     : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsCcs2Fft(   XSamps      : PFloat;   YSamps    : PFloat;
                         Order       : Integer;  Flags     : Integer); stdcall;
procedure nspdCcs2Fft(   XSamps      : PDouble;  YSamps    : PDouble;
                         Order       : Integer;  Flags     : Integer); stdcall;

procedure nspwCcs2FftNip(XInSamps    : PWCplx;   XOutSamps : PShort;
                         YInSamps    : PWCplx;   YOutSamps : PShort;
                         Order       : Integer;  Flags     : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
procedure nspsCcs2FftNip(XInSamps    : PSCplx;   XOutSamps : PFloat;
                         YInSamps    : PSCplx;   YOutSamps : PFloat;
                         Order       : Integer;  Flags     : Integer); stdcall;
procedure nspdCcs2FftNip(XInSamps    : PDCplx;   XOutSamps : PDouble;
                         YInSamps    : PDCplx;   YOutSamps : PDouble;
                         Order       : Integer;  Flags     : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspfir2.h
Purpose: Filter2D
*)

procedure nspsFilter2D(X           : PFloat;   XCols : Integer; XRows : Integer;
                       H           : PFloat;   HCols : Integer; HRows : Integer;
                       Y           : PFloat);  stdcall;
procedure nspdFilter2D(X           : PDouble;  XCols : Integer; XRows : Integer;
                       H           : PDouble;  HCols : Integer; HRows : Integer;
                       Y           : PDouble); stdcall;
procedure nspwFilter2D(X           : PShort;   XCols : Integer; XRows : Integer;
                       H           : PFloat;   HCols : Integer; HRows : Integer;
                       Y           : PShort;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspfirg.h
Purpose: Declaration of FIR filters design functions and structures.
Author:  Michael S. Kulikov.

  FUNCTIONS:
      nspdFirLowpass   -
                 computes the lowpass FIR filter coefficients;

      nspdFirHighpass  -
                 computes the highpass FIR filter coefficients;

      nspdFirBandpass  -
                 computes the bandpass FIR filter coefficients;

      nspdFirBandstop  -
                 computes the bandstop FIR filter coefficients.

  ARGUMENTS:
      rLowFreq  -
                 low frequency (0 < rLowFreq < 0.5);

      rHighFreq -
                 high frequency (0 < rHighFreq < 0.5)
                 (the condition rLowFreq < rHighFreq must be true!);

      taps      -
                 pointer to the array which specifies
                 the filter coefficients;

      tapsLen   -
                 the number of taps in taps[] array (tapsLen>=5);

      winType   -
                 the NSP_WindowType switch variable,
                 which specifies the smoothing window type;

      doNormal  -
                 if doNormal=0 the functions calculates
                 non-normalized sequence of filter coefficients,
                 in other cases the sequence of coefficients
                 will be normalized.

  RETURN:
      value from  NSP_fStatus enum.

  ENUMS:
      NSP_WindowType -
                 NSP_WinRect         no smoothing (smoothing by
                                     rectangular window);
                 NSP_WinBartlett     smoothing by Bartlett window;
                 NSP_WinBlackmanOpt  smoothing by optimal
                                     Blackman window;
                 NSP_WinHamming      smoothing by Hamming window;
                 NSP_WinHann         smoothing by Hann window.

      Return    -
                NSP_StsOk            no error;
                NSP_StsNullPtr       the null pointer to taps[] array pass
                                     to function;
                NSP_StsBadLen        the length of coefficient is less five;
                NSP_StsBadFreq       the low or high frequency isn’t satisfy
                                     the condition 0 < rLowFreq < 0.5;
                NSP_StsBadRel        the high frequency is less low.

*)

type
  TNSP_WindowType = (
    NSP_WinRect,
    NSP_WinBartlett,
    NSP_WinBlackmanOpt,
    NSP_WinHamming,
    NSP_WinHann);

function nspdFirLowpass( RFreq     : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

function nspdFirHighpass(RFreq     : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

function nspdFirBandpass(RLowFreq  : Double;
                         RHighFreq : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

function nspdFirBandstop(RLowFreq  : Double;
                         RHighFreq : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspfirh.h
Purpose: NSP Finite Impulse Response high-level filter.
*)

{=== FIR high-level ======================================================}

type
  PFirSect = ^TFirSect;
  TFirSect = record
    Num : Integer;                 // section number
    Len : Integer;                 // section taps length in use
    XId : Integer;                 // section input data index
    TId : Integer;                 // section taps index
  end;

  PNSPFirState = ^TNSPFirState;
  TNSPFirState = record
    UpFactor    : Integer;         // up
    UpPhase     : Integer;         //   parameters
    DownFactor  : Integer;         // down
    DownPhase   : Integer;         //   parameters
    IsMultiRate : Integer;         // multi-rate mode flag
    IsInit      : Pointer;         // init flag

    TapsLen     : Integer;         // number of filter taps
    TapsBlk     : Integer;
    Taps        : Pointer;         // taps pointer in use

    DlylLen     : Integer;         // delay line length
    InpLen      : Integer;         // input buffer length
    UseInp      : Integer;         // input buffer length used
    Dlyl        : Pointer;         // extended dilter delay line
    DlylLimit   : Pointer;         // delay line buffer end pointer
    UseDlyl     : Pointer;         // delay line pointer in use

    Sect        : PFirSect;        // FIR sections

    TapsFactor  : Integer;         // taps scale factor
    UTapsLen    : Integer;         // number of filter taps (user def)
  end;

{-------------------------------------------------------------------------}
{ nsp?FirInit(), nsp?FirInitMr()                                          }
{ nspFirFree()                                                            }
{                                                                         }
{ Initialize a finite impulse response high-level (FIRH) filter           }

procedure nspsFirInit(   TapVals    : PFloat;  TapsLen   : Integer;
                         DlyVals    : PFloat;
                     var State      : TNSPFirState); stdcall;
procedure nspcFirInit(   TapVals    : PSCplx;  TapsLen   : Integer;
                         DlyVals    : PSCplx;
                     var State      : TNSPFirState); stdcall;
procedure nspdFirInit(   TapVals    : PDouble; TapsLen   : Integer;
                         DlyVals    : PDouble;
                     var State      : TNSPFirState); stdcall;
procedure nspzFirInit(   TapVals    : PDCplx;  TapsLen   : Integer;
                         DlyVals    : PDCplx;
                     var State      : TNSPFirState); stdcall;
procedure nspwFirInit(   TapVals    : PFloat;  TapsLen   : Integer;
                         DlyVals    : PShort;
                     var State      : TNSPFirState); stdcall;

procedure nspsFirInitMr( TapVals    : PFloat;  TapsLen   : Integer;
                         DlyVals    : PFloat;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
procedure nspcFirInitMr( TapVals    : PSCplx;  TapsLen   : Integer;
                         DlyVals    : PSCplx;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
procedure nspdFirInitMr( TapVals    : PDouble; TapsLen   : Integer;
                         DlyVals    : PDouble;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
procedure nspzFirInitMr( TapVals    : PDCplx;  TapsLen   : Integer;
                         DlyVals    : PDCplx;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
procedure nspwFirInitMr( TapVals    : PFloat;  TapsLen   : Integer;
                         DlyVals    : PShort;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;

procedure nspFirFree(var State      : TNSPFirState); stdcall;

{-------------------------------------------------------------------------}
{ nsp?Fir(), nsp?bFir()                                                   }
{                                                                         }
{ Dot and block product FIRH filtering                                    }

function nspsFir(  var State       : TNSPFirState; Samp : Float)  : Float;  stdcall;
function nspcFir(  var State       : TNSPFirState; Samp : TSCplx) : TSCplx; stdcall;

procedure nspcFirOut(var State : TNSPFirState;
                         Samp  : TSCplx;
                     var Val   : TSCplx); stdcall;

function nspdFir(  var State       : TNSPFirState; Samp : Double) : Double; stdcall;
function nspzFir(  var State       : TNSPFirState; Samp : TDCplx) : TDCplx; stdcall;

function nspwFir(  var State       : TNSPFirState; Samp : Short;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer) : Short; stdcall;

procedure nspsbFir(var State       : TNSPFirState; InSamps  : PFloat;
                       OutSamps    : PFloat;       NumIters : Integer); stdcall;
procedure nspcbFir(var State       : TNSPFirState; InSamps  : PSCplx;
                       OutSamps    : PSCplx;       NumIters : Integer); stdcall;

procedure nspdbFir(var State       : TNSPFirState; InSamps  : PDouble;
                       OutSamps    : PDouble;      NumIters : Integer); stdcall;
procedure nspzbFir(var State       : TNSPFirState; InSamps  : PDCplx;
                       OutSamps    : PDCplx;       NumIters : Integer); stdcall;

procedure nspwbFir(var State       : TNSPFirState; InSamps  : PShort;
                       OutSamps    : PShort;       NumIters : Integer;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;

{-------------------------------------------------------------------------}
{ nsp?FirGetTaps(), nsp?FirSetTaps()                                      }
{                                                                         }
{ Utility functions to get and set the FIR taps coefficients              }

procedure nspsFirGetTaps(const State : TNSPFirState; OutTaps : PFloat);  stdcall;
procedure nspcFirGetTaps(const State : TNSPFirState; OutTaps : PSCplx);  stdcall;

procedure nspdFirGetTaps(const State : TNSPFirState; OutTaps : PDouble); stdcall;
procedure nspzFirGetTaps(const State : TNSPFirState; OutTaps : PDCplx);  stdcall;

procedure nspwFirGetTaps(const State : TNSPFirState; OutTaps : PFloat);  stdcall;

procedure nspsFirSetTaps(InTaps : PFloat;  var State : TNSPFirState); stdcall;
procedure nspcFirSetTaps(InTaps : PSCplx;  var State : TNSPFirState); stdcall;

procedure nspdFirSetTaps(InTaps : PDouble; var State : TNSPFirState); stdcall;
procedure nspzFirSetTaps(InTaps : PDCplx;  var State : TNSPFirState); stdcall;

procedure nspwFirSetTaps(InTaps : PFloat;  var State : TNSPFirState); stdcall;

{-------------------------------------------------------------------------}
{ nsp?FirGetDlyl(), nsp?FirSetDlyl()                                      }
{                                                                         }
{ Utility functions to get and set the FIR delay line contents            }

procedure nspsFirGetDlyl(const State : TNSPFirState; OutDlyl : PFloat);  stdcall;
procedure nspcFirGetDlyl(const State : TNSPFirState; OutDlyl : PSCplx);  stdcall;

procedure nspdFirGetDlyl(const State : TNSPFirState; OutDlyl : PDouble); stdcall;
procedure nspzFirGetDlyl(const State : TNSPFirState; OutDlyl : PDCplx);  stdcall;

procedure nspwFirGetDlyl(const State : TNSPFirState; OutDlyl : PShort);  stdcall;

procedure nspsFirSetDlyl(InDlyl : PFloat;  var State : TNSPFirState); stdcall;
procedure nspcFirSetDlyl(InDlyl : PSCplx;  var State : TNSPFirState); stdcall;

procedure nspdFirSetDlyl(InDlyl : PDouble; var State : TNSPFirState); stdcall;
procedure nspzFirSetDlyl(InDlyl : PDCplx;  var State : TNSPFirState); stdcall;

procedure nspwFirSetDlyl(InDlyl : PShort;  var State : TNSPFirState); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspfirl.h
Purpose: NSP Finite Impulse Response low level filter
*)

{--- FIR low level filter structure -------------------------------------}

type
  TFirLmsTapState = record
    Taps         : Pointer;
    Len          : Integer;
    UpFactor     : Integer;
    UpPhase      : Integer;
    DownFactor   : Integer;
    DownPhase    : Integer;
    IsMultiRate  : Integer;
    IsFilterMode : Integer;
  end;

  TFirLmsDlyState = record
    Dlyl         : Pointer;
    Len          : Integer;
    IsFilterMode : Integer;
  end;

{--- Finite impulse response filter -------------------------------------}

  TNSPFirTapState = record
    FirLmsTapState : TFirLmsTapState;
    TapsFactor     : Integer;
  end;

{--- Delay line of FIR low level filter ---------------------------------}

  TNSPFirDlyState = TFirLmsDlyState;

{------------------------------------------------------------------------}
{        FirlInit, FirlInitMr, FirlInitDlyl                              }
{                                                                        }
{ Low level functions for cyclic FIR filtering via a tapped delay line.  }

procedure nspsFirlInit(Taps  : PFloat;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
procedure nspdFirlInit(Taps  : PDouble; TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
procedure nspcFirlInit(Taps  : PSCplx;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
procedure nspzFirlInit(Taps  : PDCplx;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
procedure nspwFirlInit(Taps  : PFloat;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;

procedure nspsFirlInitMr(Taps       : PFloat;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
procedure nspdFirlInitMr(Taps       : PDouble; TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
procedure nspcFirlInitMr(Taps       : PSCplx;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
procedure nspzFirlInitMr(Taps       : PDCplx;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
procedure nspwFirlInitMr(Taps       : PFloat;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;

procedure nspsFirlInitDlyl(var TapSt : TNSPFirTapState; Dlyl : PFloat;
                           var DlySt : TNSPFirDlyState); stdcall;
procedure nspcFirlInitDlyl(var TapSt : TNSPFirTapState; Dlyl : PSCplx;
                           var DlySt : TNSPFirDlyState); stdcall;
procedure nspdFirlInitDlyl(var TapSt : TNSPFirTapState; Dlyl : PDouble;
                           var DlySt : TNSPFirDlyState); stdcall;
procedure nspzFirlInitDlyl(var TapSt : TNSPFirTapState; Dlyl : PDCplx;
                           var DlySt : TNSPFirDlyState); stdcall;
procedure nspwFirlInitDlyl(var TapSt : TNSPFirTapState; Dlyl : PShort;
                           var DlySt : TNSPFirDlyState); stdcall;

{------------------------------------------------------------------------}
{        Firl, bFirl                                                     }
{                                                                        }
{ Filter either a single sample or  block of samples through a low-level }
{ FIR filter.                                                            }

function nspsFirl(var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : Float)   : Float; stdcall;
function nspcFirl(var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : TSCplx)  : TSCplx; stdcall;

procedure nspcFirlOut(var TapSt   : TNSPFirTapState;
                      var DlySt   : TNSPFirDlyState;
                          Samp    : TSCplx;
                      var Val     : TSCplx); stdcall;

function nspdFirl(var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : Double)  : Double; stdcall;
function nspzFirl(var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : TDCplx)  : TDCplx; stdcall;
function nspwFirl(var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : Short;
                      ScaleMode   : Integer;
                  var ScaleFactor : Integer) : Short; stdcall;

procedure nspsbFirl(var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PFloat;  OutSamps  : PFloat;
                        NumIters    : Integer); stdcall;
procedure nspcbFirl(var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PSCplx;  OutSamps  : PSCplx;
                        NumIters    : Integer); stdcall;
procedure nspdbFirl(var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PDouble; OutSamps  : PDouble;
                        NumIters    : Integer); stdcall;
procedure nspzbFirl(var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PDCplx;  OutSamps  : PDCplx;
                        NumIters    : Integer); stdcall;
procedure nspwbFirl(var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PShort;  OutSamps  : PShort;
                        NumIters    : Integer; ScaleMode : Integer;
                    var ScaleFactor : Integer); stdcall;

{------------------------------------------------------------------------}
{        FirlGetTaps, FirlSetTaps                                        }
{                                                                        }
{ Utility functions to get and set the tap coefficients of low-level FIR }
{ filters.                                                               }

procedure nspsFirlGetTaps(var TapSt : TNSPFirTapState; OutTaps : PFloat);  stdcall;
procedure nspcFirlGetTaps(var TapSt : TNSPFirTapState; OutTaps : PSCplx);  stdcall;
procedure nspdFirlGetTaps(var TapSt : TNSPFirTapState; OutTaps : PDouble); stdcall;
procedure nspzFirlGetTaps(var TapSt : TNSPFirTapState; OutTaps : PDCplx);  stdcall;
procedure nspwFirlGetTaps(var TapSt : TNSPFirTapState; OutTaps : PFloat);  stdcall;

procedure nspsFirlSetTaps(InTaps : PFloat;  var TapSt : TNSPFirTapState); stdcall;
procedure nspcFirlSetTaps(InTaps : PSCplx;  var TapSt : TNSPFirTapState); stdcall;
procedure nspdFirlSetTaps(InTaps : PDouble; var TapSt : TNSPFirTapState); stdcall;
procedure nspzFirlSetTaps(InTaps : PDCplx;  var TapSt : TNSPFirTapState); stdcall;
procedure nspwFirlSetTaps(InTaps : PFloat;  var TapSt : TNSPFirTapState); stdcall;

{------------------------------------------------------------------------}
{        FirlGetDlyl, FirlSetDlyl                                        }
{                                                                        }
{ Utility functions to get and set  the delay line contents of low-level }
{ FIR filters.                                                           }

procedure nspsFirlGetDlyl(var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PFloat);  stdcall;
procedure nspcFirlGetDlyl(var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PSCplx);  stdcall;
procedure nspdFirlGetDlyl(var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PDouble); stdcall;
procedure nspzFirlGetDlyl(var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PDCplx);  stdcall;
procedure nspwFirlGetDlyl(var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PShort);  stdcall;

procedure nspsFirlSetDlyl(var TapSt   : TNSPFirTapState;
                              InDlyl  : PFloat;
                          var DlySt   : TNSPFirDlyState); stdcall;
procedure nspcFirlSetDlyl(var TapSt   : TNSPFirTapState;
                              InDlyl  : PSCplx;
                          var DlySt   : TNSPFirDlyState); stdcall;
procedure nspdFirlSetDlyl(var TapSt   : TNSPFirTapState;
                              InDlyl  : PDouble;
                          var DlySt   : TNSPFirDlyState); stdcall;
procedure nspzFirlSetDlyl(var TapSt   : TNSPFirTapState;
                              InDlyl  : PDCplx;
                          var DlySt   : TNSPFirDlyState); stdcall;
procedure nspwFirlSetDlyl(var TapSt   : TNSPFirTapState;
                              InDlyl  : PShort;
                          var DlySt   : TNSPFirDlyState); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspgrtzl.h, nspgrtzw.h
Purpose: NSP Single Frequency DFT (Goertzel)
*)

{ Single Frequency DFT structures.                                       }

type
  TNSPSGoertzState = record
    Freq    : Float;
    CosV    : Float;
    SinV    : Float;
    CpcV    : Float;
    Prev2Re : Float;
    Prev2Im : Float;
    Prev1Re : Float;
    Prev1Im : Float;
  end;

  TNSPCGoertzState = TNSPSGoertzState;
  TNSPWGoertzState = TNSPSGoertzState;
  TNSPVGoertzState = TNSPSGoertzState;

  TNSPDGoertzState = record
    Freq    : Double;
    CosV    : Double;
    SinV    : Double;
    CpcV    : Double;
    Prev2Re : Double;
    Prev2Im : Double;
    Prev1Re : Double;
    Prev1Im : Double;
  end;

  TNSPZGoertzState = TNSPDGoertzState;
{------------------------------------------------------------------------}
{        GoertzInit                                                      }
{                                                                        }
{ Initializes the coefficients and zeros the delay line.                 }

procedure nspsGoertzInit(Freq : Float;  var State : TNSPSGoertzState); stdcall;
procedure nspcGoertzInit(Freq : Float;  var State : TNSPCGoertzState); stdcall;
procedure nspdGoertzInit(Freq : Double; var State : TNSPDGoertzState); stdcall;
procedure nspzGoertzInit(Freq : Double; var State : TNSPZGoertzState); stdcall;
procedure nspwGoertzInit(Freq : Float;  var State : TNSPWGoertzState); stdcall;
procedure nspvGoertzInit(Freq : Float;  var State : TNSPVGoertzState); stdcall;

{------------------------------------------------------------------------}
{        GoertzReset                                                     }
{                                                                        }
{ Zeros the delay line.                                                  }

procedure nspsGoertzReset(var State : TNSPSGoertzState); stdcall;
procedure nspcGoertzReset(var State : TNSPCGoertzState); stdcall;
procedure nspdGoertzReset(var State : TNSPDGoertzState); stdcall;
procedure nspzGoertzReset(var State : TNSPZGoertzState); stdcall;
procedure nspwGoertzReset(var State : TNSPWGoertzState); stdcall;
procedure nspvGoertzReset(var State : TNSPVGoertzState); stdcall;

{------------------------------------------------------------------------}
{        Goertz                                                          }
{                                                                        }
{ Single Frequency DFT (Goertzel algorithm)                              }

function nspsGoertz( var State       : TNSPSGoertzState;
                         Sample      : Float)   : TSCplx; stdcall;
function nspcGoertz( var State       : TNSPCGoertzState;
                         Sample      : TSCplx)  : TSCplx; stdcall;
function nspdGoertz( var State       : TNSPDGoertzState;
                         Sample      : Double)  : TDCplx; stdcall;
function nspzGoertz( var State       : TNSPZGoertzState;
                         Sample      : TDCplx)  : TDCplx; stdcall;
function nspwGoertz( var State       : TNSPWGoertzState;
                         Sample      : Short;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;
function nspvGoertz( var State       : TNSPVGoertzState;
                         Sample      : TWCplx;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;

function nspsbGoertz(var State       : TNSPSGoertzState;
                         InSamps     : PFloat;
                         Len         : Integer) : TSCplx; stdcall;
function nspcbGoertz(var State       : TNSPCGoertzState;
                         InSamps     : PSCplx;
                         Len         : Integer) : TSCplx; stdcall;
function nspdbGoertz(var State       : TNSPDGoertzState;
                         InSamps     : PDouble;
                         Len         : Integer) : TDCplx; stdcall;
function nspzbGoertz(var State       : TNSPZGoertzState;
                         InSamps     : PDCplx;
                         Len         : Integer) : TDCplx; stdcall;
function nspwbGoertz(var State       : TNSPWGoertzState;
                         InSamps     : PShort;
                         Len         : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;
function nspvbGoertz(var State       : TNSPVGoertzState;
                         InSamps     : PWCplx;
                         Len         : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;

procedure nspsGoertzOut( var State   : TNSPSGoertzState;
                             Sample  : Float;
                         var Val     : TSCplx); stdcall;
procedure nspcGoertzOut( var State   : TNSPCGoertzState;
                             Sample  : TSCplx;
                         var Val     : TSCplx); stdcall;
procedure nspsbGoertzOut(var State   : TNSPSGoertzState;
                             InSamps : PFloat;
                             Len     : Integer;
                         var Val     : TSCplx); stdcall;
procedure nspcbGoertzOut(var State   : TNSPCGoertzState;
                             InSamps : PSCplx;
                             Len     : Integer;
                         var Val     : TSCplx); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspiirh.h
Purpose: NSP Infinite Impulse Response Filtering.
*)

{-------------------------------------------------------------------------}
{         IirInit, IirInitBq, IirFree                                     }
{                                                                         }
{ These functions initialize an IIR filter and provide a higher-level     }
{ interface than the corresponding low-level IIR functions.               }
{                                                                         }

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>IirInit                                                     }
{ DESCRIPTION:                                                            }
{   These functions initialize an arbitrary order IIR filter.             }
{ PARAMETERS:                                                             }
{   iirType  - input, describes the filter structure to use, and currently}
{              must be NSP_IirDefault;                                    }
{   tapVals  - input, the 2*(order+1) length array specifies the filter   }
{              coefficients as discussed for the low-level IIR function   }
{              nsp?IirlInit());                                           }
{   order    - input, sets polinomial order;                              }
{   statePtr - output, the pointer to the IIR filter state structure.     }
{                                                                         }

procedure nspsIirInit(IirType : TNSPIirType; TapVals : PFloat;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
procedure nspcIirInit(IirType : TNSPIirType; TapVals : PSCplx;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
procedure nspdIirInit(IirType : TNSPIirType; TapVals : PDouble;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
procedure nspzIirInit(IirType : TNSPIirType; TapVals : PDCplx;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
procedure nspwIirInit(IirType : TNSPIirType; TapVals : PFloat;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
procedure nspwIirInitGain(IirType    : TNSPIirType; TapVals : PFloat;
                          Order      : Integer;
                      var State      : TNSPIirState;
                          Gain       : Float;
                          InputRange : Integer); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>IirInitBq                                                   }
{ DESCRIPTION:                                                            }
{   These functions initialize an IIR filter defined by a cascade of      }
{   biquads.                                                              }
{ PARAMETERS:                                                             }
{   iirType  - input, describes the filter structure to use, and currently}
{              must be NSP_IirDefault;                                    }
{   tapVals  - input, the 6*numQuads length array specifies the filter    }
{              coefficients as discussed for the low-level IIR function   }
{              nsp?IirlInitBq());                                         }
{   numQuads - input, sets the number of biduads;                         }
{   tapStPtr - output, pointer to the IIR state structure.                }
{                                                                         }

procedure nspsIirInitBq(IirType  : TNSPIirType; TapVals : PFloat;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
procedure nspcIirInitBq(IirType  : TNSPIirType; TapVals : PSCplx;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
procedure nspdIirInitBq(IirType  : TNSPIirType; TapVals : PDouble;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
procedure nspzIirInitBq(IirType  : TNSPIirType; TapVals : PDCplx;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
procedure nspwIirInitBq(IirType  : TNSPIirType; TapVals : PFloat;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nspIirFree                                                            }
{ DESCRIPTION:                                                            }
{   This function must be called after all filtering is done to free      }
{   dynamic memory associated with statePtr. After calling this function, }
{   statePtr should not be referenced again.                              }
{ PARAMETERS:                                                             }
{   statePtr - pointer to the IIR filter state structure.                 }
{                                                                         }

procedure nspIirFree(var State : TNSPIirState); stdcall;

{-------------------------------------------------------------------------}
{         Iir, bIir                                                       }
{                                                                         }
{ Filter a signal through a IIR filter.                                   }
{                                                                         }

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>Iir                                                         }
{ DESCRIPTION:                                                            }
{   These functions filter a single sample samp through an IIR filter and }
{   return the result.                                                    }
{ PARAMETERS:                                                             }
{   statePtr - input, pointer to the IIR state structure;                 }
{   samp     - input, the sample value.                                   }
{ RETURNS:                                                                }
{   the filtering result.                                                 }
{                                                                         }

function nspsIir(var State       : TNSPIirState;
                     Samp        : Float)   : Float;  stdcall;
function nspcIir(var State       : TNSPIirState;
                     Samp        : TSCplx)  : TSCplx; stdcall;
function nspdIir(var State       : TNSPIirState;
                     Samp        : Double)  : Double; stdcall;
function nspzIir(var State       : TNSPIirState;
                     Samp        : TDCplx)  : TDCplx; stdcall;
function nspwIir(var State       : TNSPIirState;
                     Samp        : Short;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer) : Short;  stdcall;

procedure nspcIirOut(var State : TNSPIirState;
                         Samp  : TSCplx;
                     var Val   : TSCplx); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>bIir                                                        }
{ DESCRIPTION:                                                            }
{   These functions filter a block of numIters samples inSamps through an }
{   IIR filter and return the result in outSamps.                         }
{ PARAMETERS:                                                             }
{   statePtr - input, pointer to the IIR state structure;                 }
{   inSamps  - input, the pointer to block of numIters samples;           }
{   outSamps - output, the pointer to block of numIters filtered samples; }
{   numIters - input, the size of samples' block.                         }
{                                                                         }

procedure nspsbIir(var State       : TNSPIirState;
                       InSamps     : PFloat;  OutSamps : PFloat;
                       NumIters    : Integer);          stdcall;
procedure nspcbIir(var State       : TNSPIirState;
                       InSamps     : PSCplx;  OutSamps : PSCplx;
                       NumIters    : Integer);          stdcall;
procedure nspdbIir(var State       : TNSPIirState;
                       InSamps     : PDouble; OutSamps : PDouble;
                       NumIters    : Integer);          stdcall;
procedure nspzbIir(var State       : TNSPIirState;
                       InSamps     : PDCplx;  OutSamps : PDCplx;
                       NumIters    : Integer);          stdcall;
procedure nspwbIir(var State       : TNSPIirState;
                       InSamps     : PShort;  OutSamps : PShort;
                       NumIters    : Integer;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer);          stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspiirl.h
Purpose: NSP Infinite Impulse Response Filtering.
*)

const
  MAX_IIR_FILTER = 1024;

{---- User tap type ------------------------------------------------------}

type
  TNSPIirType = (NSP_IirNull, NSP_IirDefault, NSP_IirUseTapsAsPtr);

{---- Implementation tap type of initialization --------------------------}

  TNSPIirInit = (NSP_IirInit, NSP_IirXInit, NSP_IirInitBq, NSP_IirXInitBq);

{---- IIR filter tap state structure -------------------------------------}

  TNSPIirTapState = record
    Order   : Integer;                 // order/number of biquads
    Taps    : Pointer;                 // pointer to taps
    IirType : TNSPIirType;             // user type
    IniType : TNSPIirInit;             // type of initialization
    TapsFactor : Integer;
  end;

{---- IIR filter delay line state structure ------------------------------}

  TNSPIirDlyState = record
    Dlyl : Pointer;                    // pointer to delay line
  end;

{---- IIR filter state structure -----------------------------------------}

  TNSPIirState = record
    TapSt : TNSPIirTapState;           // tap state structure
    DlySt : TNSPIirDlyState;           // delay line state structure
    Init  : Integer;                   // initialization flag
  end;

{-------------------------------------------------------------------------}
{         IirlInit, IirlInitBq, IirlInitDlyl                              }
{                                                                         }
{ Perform infinite impulse response filtering.                            }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>IirlInit                                                }
{ DESCRIPTION:                                                            }
{   Taps initialization of low-level arbitrary order IIR-filter with      }
{   transfer function expressed as the ratio of two polinomials of order  }
{   "order".                                                              }
{ PARAMETERS:                                                             }
{   iirType  - input, determines the filter structure to use, currently   }
{              must be NSP_IirDefault;                                    }
{   taps     - input/output, sets the array taps of filter with transfer  }
{              function                                                   }
{                   B0+B1/z+B2/z/z ... +Border/z**order                   }
{              H(z)=------------------------------------                  }
{                   A0+A1/z+A2/z/z ... +Aorder/z**order                   }
{              in following order:                                        }
{                  B0, B1, ... Border,A0, A1, ... Aorder.                 }
{              A0 must not be zero;                                       }
{   order    - input, sets polinomial order;                              }
{   tapStPtr - output, the pointer to the tap state structure.            }
{                                                                         }
{   gain - input, determines gain coefficient for filter output signal.   }
{          It have to be positive value .                                 }
{   InputRange - input, defines the bit range of input signal             }
{                (from 4 to 16 bit). This gives possibility for the       }
{                optimal taps recalculation from float to the internal    }
{                short whith a fixed point flavor when input signal       }
{                limitation is known.                                     }
{    When gain = 1.0 and InputRange =16 the result of nspwIirlInitGain is }
{    equal to nspwIirlInit.                                               }

procedure nspwIirlInit(IirType : TNSPIirType; Taps : PFloat;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
procedure nspsIirlInit(IirType : TNSPIirType; Taps : PFloat;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
procedure nspcIirlInit(IirType : TNSPIirType; Taps : PSCplx;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
procedure nspdIirlInit(IirType : TNSPIirType; Taps : PDouble;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
procedure nspzIirlInit(IirType : TNSPIirType; Taps : PDCplx;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
procedure nspwIirlInitGain(IirType    : TNSPIirType; Taps : PFloat;
                           Order      : Integer;
                       var State      : TNSPIirTapState;
                           Gain       : Float;
                           InputRange : Integer); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>IirlInitBq                                              }
{ DESCRIPTION:                                                            }
{   Low-level IIR-filter iinitialization taps to reference a cascade of   }
{   biquads. Transfer function is a product of numQuads biquads.          }
{ PARAMETERS:                                                             }
{   iirType  - input, determines the filter structure to use, currently   }
{              must be NSP_IirDefault;                                    }
{   taps     - input/output, sets the array taps of filter                }
{              with the transfer function                                 }
{                   (B10+B11/z+B12/z**2)* ... *(BnQ0+BnQ1/z+BnQ2/z**2)    }
{              H(z)=--------------------------------------------------    }
{                   (A10+A11/z+A12/z**2)* ... *(AnQ0+AnQ1/z+AnQ2/z**2)    }
{              in following order:                                        }
{                   B10, B11, B12, A10, A11, A12, ... ,                   }
{                   BnQ0, BnQ1, BnQ2, AnQ0, AnQ1, AnQ2.                   }
{              All Bi0 and Ai0 must not be zero;                          }
{   numQuads - input, sets the number of biduads;                         }
{   tapStPtr - output, pointer to the tap state structure.                }
{                                                                         }

procedure nspwIirlInitBq(IirType  : TNSPIirType; Taps : PFloat;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
procedure nspsIirlInitBq(IirType  : TNSPIirType; Taps : PFloat;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
procedure nspcIirlInitBq(IirType  : TNSPIirType; Taps : PSCplx;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
procedure nspdIirlInitBq(IirType  : TNSPIirType; Taps : PDouble;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
procedure nspzIirlInitBq(IirType  : TNSPIirType; Taps : PDCplx;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>IirlInitDlyl                                            }
{ DESCRIPTION:                                                            }
{   Initialization of delay array for low-level IIR-filter.               }
{ PARAMETERS:                                                             }
{   tapStPtr - input, the pointer to the tap state structure,             }
{              initializated previously by the function nsp?IirInit or    }
{              nsp?IirInitBq;                                             }
{   dlyl     - input/output, the delay line array. In this implementation }
{              the input array element values are ignored.                }
{   dlyStPtr - output, the pointer to the delay line state structure.     }
{                                                                         }

procedure nspwIirlInitDlyl(TapState : TNSPIirTapState; Dlyl : PLongint;
                       var DlyState : TNSPIirDlyState); stdcall;
procedure nspsIirlInitDlyl(TapState : TNSPIirTapState; Dlyl : PFloat;
                       var DlyState : TNSPIirDlyState); stdcall;
procedure nspcIirlInitDlyl(TapState : TNSPIirTapState; Dlyl : PSCplx;
                       var DlyState : TNSPIirDlyState); stdcall;
procedure nspdIirlInitDlyl(TapState : TNSPIirTapState; Dlyl : PDouble;
                       var DlyState : TNSPIirDlyState); stdcall;
procedure nspzIirlInitDlyl(TapState : TNSPIirTapState; Dlyl : PDCplx;
                       var DlyState : TNSPIirDlyState); stdcall;

{-------------------------------------------------------------------------}
{         Iirl, bIirl                                                     }
{                                                                         }
{ Filter a signal through a low-level IIR filter.                         }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>Iirl                                                        }
{ DESCRIPTION:                                                            }
{   filters a single sample throuth a low-level IIR filter and returns    }
{   the result.                                                           }
{ PARAMETERS:                                                             }
{   tapStPtr - input, pointer to the tap state structure;                 }
{   dlyStPtr - input, pointer to the delay line state structure;          }
{   smp      - input, the sample value.                                   }
{ RETURNS:                                                                }
{   the filtering result.                                                 }
{                                                                         }

function nspwIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : Short;
                        ScaleMode   : Integer;
                  var   ScaleFactor : Integer) : Short;  stdcall;
function nspsIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : Float)   : Float;  stdcall;
function nspcIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : TSCplx)  : TSCplx; stdcall;
function nspdIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : Double)  : Double; stdcall;
function nspzIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : TDCplx)  : TDCplx; stdcall;
procedure nspcIirlOut(const TapState : TNSPIirTapState;
                      var   DlyState : TNSPIirDlyState;
                            Samp     : TSCplx;
                      var   Val      : TSCplx); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>bIirl                                                   }
{ DESCRIPTION:                                                            }
{   filters an input block of samples throuth a low-level IIR filter and  }
{   returns the result in output block.                                   }
{ PARAMETERS:                                                             }
{   tapStPtr - input, the pointer to the tap state structure;             }
{   dlyStPtr - input, the pointer to the delay line state structure;      }
{   inSamps  - input, the block of samples;                               }
{   outSamps - output, the block of filtered samples;                     }
{   numIters - input, the size of samples' block.                         }
{                                                                         }

procedure nspwbIirl(const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PShort;  OutSamps : PShort;
                          NumIters    : Integer;
                          ScaleMode   : Integer;
                    var   ScaleFactor : Integer); stdcall;
procedure nspsbIirl(const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PFloat;  OutSamps : PFloat;
                          NumIters    : Integer); stdcall;
procedure nspcbIirl(const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PSCplx;  OutSamps : PSCplx;
                          NumIters    : Integer); stdcall;
procedure nspdbIirl(const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PDouble; OutSamps : PDouble;
                          NumIters    : Integer); stdcall;
procedure nspzbIirl(const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PDCplx;  OutSamps : PDCplx;
                          NumIters    : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsplaw.h
Purpose: Convert samples from 8-bit A-law and Mu-law encoded format
         to linear, or vice-versa.
Contents:
           nsp?bLinToALaw  -
                   Convert linear PCM samples to 8-bit A-law format.
           nsp?bALawToLin  -
                   Convert samples from 8-bit A-law encoded format
                   to linear PCM.
           nsp?bLinToMuLaw  -
                   Convert linear PCM samples to 8-bit Mu-law format.
           nsp?bMuLawToLin  -
                   Convert samples from 8-bit Mu-law encoded format
                   to linear PCM.
           nspMuLawToALaw  -
                   Converts samples from Mu-law encoded format
                   to A-law encoded format.
           nspALawToMuLaw  -
                   Converts samples from A-law encoded format
                   to Mu-law encoded format.
*)

procedure nspwbLinToALaw( Src : PShort;  Dst : PUCHAR; Len : Integer); stdcall;
procedure nspsbLinToALaw( Src : PFloat;  Dst : PUCHAR; Len : Integer); stdcall;
procedure nspdbLinToALaw( Src : PDouble; Dst : PUCHAR; Len : Integer); stdcall;

procedure nspwbALawToLin( Src : PUCHAR; Dst : PShort;  Len : Integer); stdcall;
procedure nspsbALawToLin( Src : PUCHAR; Dst : PFloat;  Len : Integer); stdcall;
procedure nspdbALawToLin( Src : PUCHAR; Dst : PDouble; Len : Integer); stdcall;

procedure nspwbLinToMuLaw(Src : PShort;  Dst : PUCHAR; Len : Integer); stdcall;
procedure nspsbLinToMuLaw(Src : PFloat;  Dst : PUCHAR; Len : Integer); stdcall;
procedure nspdbLinToMuLaw(Src : PDouble; Dst : PUCHAR; Len : Integer); stdcall;

procedure nspwbMuLawToLin(Src : PUCHAR; Dst : PShort;  Len : Integer); stdcall;
procedure nspsbMuLawToLin(Src : PUCHAR; Dst : PFloat;  Len : Integer); stdcall;
procedure nspdbMuLawToLin(Src : PUCHAR; Dst : PDouble; Len : Integer); stdcall;

procedure nspMuLawToALaw( Src : PUCHAR; Dst : PUCHAR; Len : Integer); stdcall;
procedure nspALawToMuLaw( Src : PUCHAR; Dst : PUCHAR; Len : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsplmsh.h
Purpose: NSP Adaptive FIR filter that uses the LMS algorithm
*)

type
  TNSPLmsState = record
    TapState : TNSPLmsTapState;
    DlyState : TNSPLmsDlyState;
    Err      : record
      case Integer of
        0: (sVal : Float);
        1: (dVal : Double);
        2: (cVal : TSCplx);
        3: (zVal : TDCplx);
    end;
  end;

{------------------------------------------------------------------------}

procedure nspsLmsInit(  LmsType    : TNSPLmsType; TapVals   : PFloat;
                        TapsLen    : Integer;     DlyVals   : PFloat;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;
procedure nspdLmsInit(  LmsType    : TNSPLmsType; TapVals   : PDouble;
                        TapsLen    : Integer;     DlyVals   : PDouble;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;
procedure nspcLmsInit(  LmsType    : TNSPLmsType; TapVals   : PSCplx;
                        TapsLen    : Integer;     DlyVals   : PSCplx;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;
procedure nspzLmsInit(  LmsType    : TNSPLmsType; TapVals   : PDCplx;
                        TapsLen    : Integer;     DlyVals   : PDCplx;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;

procedure nspsLmsInitMr(LmsType    : TNSPLmsType; TapVals   : PFloat;
                        TapsLen    : Integer;     DlyVals   : PFloat;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;
procedure nspdLmsInitMr(LmsType    : TNSPLmsType; TapVals   : PDouble;
                        TapsLen    : Integer;     DlyVals   : PDouble;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;
procedure nspcLmsInitMr(LmsType    : TNSPLmsType; TapVals   : PSCplx;
                        TapsLen    : Integer;     DlyVals   : PSCplx;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;
procedure nspzLmsInitMr(LmsType    : TNSPLmsType; TapVals   : PDCplx;
                        TapsLen    : Integer;     DlyVals   : PDCplx;
                        Step       : Float;       Leak      : Float;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;

procedure nspLmsFree(var State     : TNSPLmsState);           stdcall;

function nspsLms(    var State     : TNSPLmsState; Samp     : Float;
                         Err       : Float)  : Float;         stdcall;
function nspdLms(    var State     : TNSPLmsState; Samp     : Double;
                         Err       : Double) : Double;        stdcall;
function nspcLms(    var State     : TNSPLmsState; Samp     : TSCplx;
                         Err       : TSCplx) : TSCplx;        stdcall;
function nspzLms(    var State     : TNSPLmsState; Samp     : TDCplx;
                         Err       : TDCplx) : TDCplx;        stdcall;

function nspsbLms(   var State     : TNSPLmsState; InSamps  : PFloat;
                         Err       : Float)  : Float;         stdcall;
function nspdbLms(   var State     : TNSPLmsState; InSamps  : PDouble;
                         Err       : Double) : Double;        stdcall;
function nspcbLms(   var State     : TNSPLmsState; InSamps  : PSCplx;
                         Err       : TSCplx) : TSCplx;        stdcall;
function nspzbLms(   var State     : TNSPLmsState; InSamps  : PDCplx;
                         Err       : TDCplx) : TDCplx;        stdcall;

procedure nspsLmsGetTaps(const State    : TNSPLmsState;
                               OutTaps  : PFloat);  stdcall;
procedure nspdLmsGetTaps(const State    : TNSPLmsState;
                               OutTaps  : PDouble); stdcall;
procedure nspcLmsGetTaps(const State    : TNSPLmsState;
                               OutTaps  : PSCplx);  stdcall;
procedure nspzLmsGetTaps(const State    : TNSPLmsState;
                               OutTaps  : PDCplx);  stdcall;

procedure nspsLmsSetTaps(      InTaps   : PFloat;
                         var   State    : TNSPLmsState); stdcall;
procedure nspdLmsSetTaps(      InTaps   : PDouble;
                         var   State    : TNSPLmsState); stdcall;
procedure nspcLmsSetTaps(      InTaps   : PSCplx;
                         var   State    : TNSPLmsState); stdcall;
procedure nspzLmsSetTaps(      InTaps   : PDCplx;
                         var   State    : TNSPLmsState); stdcall;

procedure nspsLmsGetDlyl(const State    : TNSPLmsState;
                               OutDlyl  : PFloat);       stdcall;
procedure nspdLmsGetDlyl(const State    : TNSPLmsState;
                               OutDlyl  : PDouble);      stdcall;
procedure nspcLmsGetDlyl(const State    : TNSPLmsState;
                               OutDlyl  : PSCplx);       stdcall;
procedure nspzLmsGetDlyl(const State    : TNSPLmsState;
                               OutDlyl  : PDCplx);       stdcall;

procedure nspsLmsSetDlyl(      InDlyl   : PFloat;
                         var   State    : TNSPLmsState); stdcall;
procedure nspdLmsSetDlyl(      InDlyl   : PDouble;
                         var   State    : TNSPLmsState); stdcall;
procedure nspcLmsSetDlyl(      InDlyl   : PSCplx;
                         var   State    : TNSPLmsState); stdcall;
procedure nspzLmsSetDlyl(      InDlyl   : PDCplx;
                         var   State    : TNSPLmsState); stdcall;

function  nspsLmsGetStep(const State    : TNSPLmsState) : Float; stdcall;
function  nspsLmsGetLeak(const State    : TNSPLmsState) : Float; stdcall;

procedure nspsLmsSetStep(      Step     : Float;
                         var   State    : TNSPLmsState); stdcall;
procedure nspsLmsSetLeak(      Leak     : Float;
                         var   State    : TNSPLmsState); stdcall;

function nspsLmsDes(     var   State    : TNSPLmsState; Samp : Float;
                               Des      : Float)  : Float;     stdcall;
function nspdLmsDes(     var   State    : TNSPLmsState; Samp : Double;
                               Des      : Double) : Double;    stdcall;
function nspcLmsDes(     var   State    : TNSPLmsState; Samp : TSCplx;
                               Des      : TSCplx) : TSCplx;    stdcall;
function nspzLmsDes(     var   State    : TNSPLmsState; Samp : TDCplx;
                               Des      : TDCplx) : TDCplx;    stdcall;

procedure nspsbLmsDes(   var   State    : TNSPLmsState; InSamps  : PFloat;
                               DesSamps : PFloat;       OutSamps : PFloat;
                               NumIters : Integer);                stdcall;
procedure nspdbLmsDes(   var   State    : TNSPLmsState; InSamps  : PDouble;
                               DesSamps : PDouble;      OutSamps : PDouble;
                               NumIters : Integer);                stdcall;
procedure nspcbLmsDes(   var   State    : TNSPLmsState; InSamps  : PSCplx;
                               DesSamps : PSCplx;       OutSamps : PSCplx;
                               NumIters : Integer);                stdcall;
procedure nspzbLmsDes(   var   State    : TNSPLmsState; InSamps  : PDCplx;
                               DesSamps : PDCplx;       OutSamps : PDCplx;
                               NumIters : Integer);                stdcall;

function nspsLmsGetErrVal( const State : TNSPLmsState) : Float;  stdcall;
function nspdLmsGetErrVal( const State : TNSPLmsState) : Double; stdcall;
function nspcLmsGetErrVal( const State : TNSPLmsState) : TSCplx; stdcall;
function nspzLmsGetErrVal( const State : TNSPLmsState) : TDCplx; stdcall;

procedure nspsLmsSetErrVal(      Err   : Float;
                           var   State : TNSPLmsState); stdcall;
procedure nspdLmsSetErrVal(      Err   : Double;
                           var   State : TNSPLmsState); stdcall;
procedure nspcLmsSetErrVal(      Err   : TSCplx;
                           var   State : TNSPLmsState); stdcall;
procedure nspzLmsSetErrVal(      Err   : TDCplx;
                           var   State : TNSPLmsState); stdcall;

procedure nspcLmsOut( var State : TNSPLmsState;
                          Samp  : TSCplx;
                          Err   : TSCplx;
                      var Val   : TSCplx); stdcall;
procedure nspcbLmsOut(var State   : TNSPLmsState;
                          InSamps : PSCplx;
                          Err     : TSCplx;
                      var Val     : TSCplx); stdcall;
procedure nspcLmsDesOut(var State : TNSPLmsState;
                            Samp  : TSCplx;
                            Des   : TSCplx;
                        var Val   : TSCplx); stdcall;
procedure nspcLmsGetErrValOut(const State : TNSPLmsState;
                              var   Val   : TSCplx); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsplmsl.h
Purpose: NSP Adaptive FIR filter that uses the LMS algorithm.
*)

{--- LMS filter (method) type -------------------------------------------}

type
  TNSPLmsType = (NSP_LmsNull, NSP_LmsDefault);

{--- LMS low-level filter state structure -------------------------------}

  TNSPLmsTapState = record
    // FirLmsTapState;                    // Base filter state, see FIRL.H
    Taps         : Pointer;
    Len          : Integer;
    UpFactor     : Integer;
    UpPhase      : Integer;
    DownFactor   : Integer;
    DownPhase    : Integer;
    IsMultiRate  : Integer;
    IsFilterMode : Integer;
    // end FirLmsTapState;
    Leak         : Float;                 // Leak value to range taps magn
    Step         : Float;                 // Step-size to change taps magn
    ErrDly       : Integer;               // Delay of error signal
    LmsType      : TNSPLmsType;
  end;

{--- LMS low-level filter delay line ------------------------------------}

  TNSPLmsDlyState = record
    // FirLmsDlyState;
    Dlyl         : Pointer;
    Len          : Integer;
    IsFilterMode : Integer;
    // end FirLmsDlyState;
    AdaptB       : Integer;               // Is used in delay length definition
  end;

{------------------------------------------------------------------------}
{   LMSL of "integer" type uses Fixed Point representation of taps       }
{------------------------------------------------------------------------}

  FixedPoint = Integer;

  TNSPWLmsTapState = record
    // FirLmsTapState;                    // Base filter state, see FIRL.H
    Taps         : Pointer;
    Len          : Integer;
    UpFactor     : Integer;
    UpPhase      : Integer;
    DownFactor   : Integer;
    DownPhase    : Integer;
    IsMultiRate  : Integer;
    IsFilterMode : Integer;
    // end FirLmsTapState;
    Leak         : Float;                 // Leak value to arrange taps magn
    Step         : record                 // Step size to change taps values
      case Integer of
        0: (F : Float);
        1: (I : FixedPoint);
    end;
    ErrDly       : Integer;               // Delay of an error signal
    LmsType      : TNSPLmsType;
  end;

  TNSPWLmsDlyState = TNSPLmsDlyState;

{------------------------------------------------------------------------}
{ LmslInit, LmslInitMr, LmslInitDlyl                                     }
{                                                                        }
{ Initialize  an adaptive  FIR filter  that uses  the least  mean-square }
{ (LMS) algorithm.                                                       }

{--- Single-rate init ---------------------------------------------------}

procedure nspsLmslInit(LmsType : TNSPLmsType; Taps   : PFloat;
                       TapsLen : Integer;     Step   : Float;
                       Leak    : Float;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;
procedure nspdLmslInit(LmsType : TNSPLmsType; Taps   : PDouble;
                       TapsLen : Integer;     Step   : Float;
                       Leak    : Float;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;
procedure nspcLmslInit(LmsType : TNSPLmsType; Taps   : PSCplx;
                       TapsLen : Integer;     Step   : Float;
                       Leak    : Float;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;
procedure nspzLmslInit(LmsType : TNSPLmsType; Taps   : PDCplx;
                       TapsLen : Integer;     Step   : Float;
                       Leak    : Float;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;

{--- Multi-rate init ----------------------------------------------------}

procedure nspsLmslInitMr(LmsType    : TNSPLmsType; Taps      : PFloat;
                         TapsLen    : Integer;     Step      : Float;
                         Leak       : Float;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;
procedure nspdLmslInitMr(LmsType    : TNSPLmsType; Taps      : PDouble;
                         TapsLen    : Integer;     Step      : Float;
                         Leak       : Float;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;
procedure nspcLmslInitMr(LmsType    : TNSPLmsType; Taps      : PSCplx;
                         TapsLen    : Integer;     Step      : Float;
                         Leak       : Float;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;
procedure nspzLmslInitMr(LmsType    : TNSPLmsType; Taps      : PDCplx;
                         TapsLen    : Integer;     Step      : Float;
                         Leak       : Float;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;

{--- Delay line init ----------------------------------------------------}

procedure nspsLmslInitDlyl(var TapSt : TNSPLmsTapState;
                               Dlyl  : PFloat; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;
procedure nspdLmslInitDlyl(var TapSt : TNSPLmsTapState;
                               Dlyl  : PDouble; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;
procedure nspcLmslInitDlyl(var TapSt : TNSPLmsTapState;
                               Dlyl  : PSCplx; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;
procedure nspzLmslInitDlyl(var TapSt : TNSPLmsTapState;
                               Dlyl  : PDCplx; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;

{------------------------------------------------------------------------}
{ LmslGetStep, LmslSetStep, LmslGetLeak, LmslSetLeak                     }
{                                                                        }
{ Utility  functions  to  get  and  set  the  leak  and step values of a }
{ low-level LMS filter.                                                  }

function nspsLmslGetStep(const TapSt : TNSPLmsTapState) : Float; stdcall;
function nspsLmslGetLeak(const TapSt : TNSPLmsTapState) : Float; stdcall;

procedure nspsLmslSetStep(Step : Float; var TapSt : TNSPLmsTapState); stdcall;
procedure nspsLmslSetLeak(Leak : Float; var TapSt : TNSPLmsTapState); stdcall;

{------------------------------------------------------------------------}
{ Lmsl, bLmsl                                                            }
{                                                                        }
{ Filter samples through a low-level LMS filter.                         }

function nspsLmsl( var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : Float;  Err : Float)  : Float;  stdcall;
function nspcLmsl( var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : TSCplx; Err : TSCplx) : TSCplx; stdcall;
function nspdLmsl( var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : Double; Err : Double) : Double; stdcall;
function nspzLmsl( var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : TDCplx; Err : TDCplx) : TDCplx; stdcall;
procedure nspcLmslOut(var TapSt : TNSPLmsTapState;
                      var DlySt : TNSPLmsDlyState;
                          Samp  : TSCplx; Err : TSCplx;
                      var Val   : TSCplx); stdcall;

function nspsbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PFloat;  Err : Float)  : Float;  stdcall;
function nspcbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PSCplx;  Err : TSCplx) : TSCplx; stdcall;
function nspdbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PDouble; Err : Double) : Double; stdcall;
function nspzbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PDCplx;  Err : TDCplx) : TDCplx; stdcall;
procedure nspcbLmslOut(var TapSt   : TNSPLmsTapState;
                       var DlySt   : TNSPLmsDlyState;
                           InSamps : PSCplx; Err : TSCplx;
                       var Val     : TSCplx); stdcall;

{------------------------------------------------------------------------}
{ LmslNa, bLmslNa                                                        }
{                                                                        }
{ Filter a signal using a LMS filter, but without adapting the filter.   }

function nspsLmslNa(      const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : Float)  : Float;   stdcall;
function nspcLmslNa(      const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : TSCplx) : TSCplx;  stdcall;
function nspdLmslNa(      const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : Double) : Double;  stdcall;
function nspzLmslNa(      const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : TDCplx) : TDCplx;  stdcall;
procedure nspcLmslNaOut(const TapSt      : TNSPLmsTapState;
                        var   DlySt      : TNSPLmsDlyState;
                              Samp       : TSCplx;
                        var   Val        : TSCplx);  stdcall;

procedure nspsbLmslNa(    const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PFloat;  OutSamps : PFloat;
                                NumIters : Integer);          stdcall;
procedure nspcbLmslNa(    const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PSCplx;  OutSamps : PSCplx;
                                NumIters : Integer);          stdcall;
procedure nspdbLmslNa(    const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PDouble; OutSamps : PDouble;
                                NumIters : Integer);          stdcall;
procedure nspzbLmslNa(    const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PDCplx;  OutSamps : PDCplx;
                                NumIters : Integer);          stdcall;

procedure nspsLmslGetTaps(const TapSt    : TNSPLmsTapState;
                                OutTaps  : PFloat);           stdcall;
procedure nspcLmslGetTaps(const TapSt    : TNSPLmsTapState;
                                OutTaps  : PSCplx);           stdcall;
procedure nspdLmslGetTaps(const TapSt    : TNSPLmsTapState;
                                OutTaps  : PDouble);          stdcall;
procedure nspzLmslGetTaps(const TapSt    : TNSPLmsTapState;
                                OutTaps  : PDCplx);           stdcall;

procedure nspsLmslSetTaps(      InTaps   : PFloat;
                          var   TapSt    : TNSPLmsTapState);  stdcall;
procedure nspcLmslSetTaps(      InTaps   : PSCplx;
                          var   TapSt    : TNSPLmsTapState);  stdcall;
procedure nspdLmslSetTaps(      InTaps   : PDouble;
                          var   TapSt    : TNSPLmsTapState);  stdcall;
procedure nspzLmslSetTaps(      InTaps   : PDCplx;
                          var   TapSt    : TNSPLmsTapState);  stdcall;

procedure nspsLmslGetDlyl(const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PFloat);           stdcall;
procedure nspcLmslGetDlyl(const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PSCplx);           stdcall;
procedure nspdLmslGetDlyl(const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PDouble);          stdcall;
procedure nspzLmslGetDlyl(const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PDCplx);           stdcall;

procedure nspsLmslSetDlyl(const TapSt   : TNSPLmsTapState;
                                InDlyl  : PFloat;
                          var   DlySt   : TNSPLmsDlyState); stdcall;
procedure nspcLmslSetDlyl(const TapSt   : TNSPLmsTapState;
                                InDlyl  : PSCplx;
                          var   DlySt   : TNSPLmsDlyState); stdcall;
procedure nspdLmslSetDlyl(const TapSt   : TNSPLmsTapState;
                                InDlyl  : PDouble;
                          var   DlySt   : TNSPLmsDlyState); stdcall;
procedure nspzLmslSetDlyl(const TapSt   : TNSPLmsTapState;
                                InDlyl  : PDCplx;
                          var   DlySt   : TNSPLmsDlyState); stdcall;

{------------------------------------------------------------------------}
{   The wLmsl functions for data of short type.                          }
{   31-mar-97. New interface and new functions                           }
{      o leak is not used,                                               }
{      o adaptB is not used,                                             }
{      o filter taps are float in the function call,                     }
{      o step is float in the function call,                             }
{      o calculation are done with fixed point data.                     }
{------------------------------------------------------------------------}

{ Note that adaptB is not used }
procedure nspwLmslInitDlyl(var   TapSt   : TNSPWLmsTapState;
                                 Dlyl    : PShort;
                           var   DlySt   : TNSPWLmsDlyState); stdcall;

procedure nspwLmslSetDlyl( const TapSt   : TNSPWLmsTapState;
                                 InDlyl  : PShort;
                           var   DlySt   : TNSPWLmsDlyState); stdcall;

procedure nspwLmslGetDlyl( const TapSt   : TNSPWLmsTapState;
                           const DlySt   : TNSPWLmsDlyState;
                                 OutDlyl : PShort);           stdcall;

{ Note that leak is not used and taps are float }
procedure nspwLmslInit(LmsType : TNSPLmsType; Taps : PFloat;
                       TapsLen : Integer;     Step : Float;
                       ErrDly  : Integer;
                   var TapSt   : TNSPWLmsTapState);  stdcall;

procedure nspwLmslSetTaps(      InTaps  : PFloat;
                          var   TapSt   : TNSPWLmsTapState); stdcall;

procedure nspwLmslGetTaps(const TapSt   : TNSPWLmsTapState;
                                OutTaps : PFloat);           stdcall;

function nspwLmsl(        var   TapSt   : TNSPWLmsTapState;
                          var   DlySt   : TNSPWLmsDlyState;
                                Samp    : Short;
                                Err     : Short) : Short;    stdcall;

{ Note that step is float }
function  nspwLmslGetStep(const TapSt : TNSPWLmsTapState) : Float; stdcall;
procedure nspwLmslSetStep(      Step  : Float;
                          var   TapSt : TNSPWLmsTapState);         stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsplnexp.h
Purpose: Compute the natural log of vector elements
         Compute e to the power of vector elements

Contents:
         nsp?bLn1   -
                    Computes the natural log of each element
                    in the array in-place
         nsp?bLn2   -
                    Computes the natural log of each element
                    in the array and stores the results
                    in the another array
         nsp?bExp1  -
                    Computes e to the power of each element
                    in the array in-place
         nsp?bExp2  -
                    Computes e to the power of each element
                    in the array and stores the results
                    in the another array
*)

procedure nspsbLn1( Vec         : PFloat; Len : Integer); stdcall;
procedure nspsbLn2( Src         : PFloat; Dst : PFloat; Len : Integer); stdcall;
procedure nspsbExp1(Vec         : PFloat; Len : Integer); stdcall;
procedure nspsbExp2(Src         : PFloat; Dst : PFloat; Len : Integer); stdcall;

procedure nspdbLn1( Vec         : PDouble; Len : Integer); stdcall;
procedure nspdbLn2( Src         : PDouble; Dst : PDouble; Len : Integer); stdcall;
procedure nspdbExp1(Vec         : PDouble; Len : Integer); stdcall;
procedure nspdbExp2(Src         : PDouble; Dst : PDouble; Len : Integer); stdcall;

procedure nspwbLn1( Vec         : PShort; Len : Integer); stdcall;
procedure nspwbLn2( Src         : PShort; Dst : PShort; Len : Integer); stdcall;
procedure nspwbExp1(Vec         : PShort; Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;
procedure nspwbExp2(Src         : PShort; Dst : PShort; Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

{***** decimal functions        ****}
procedure nspsbLg1(Vec : PFloat;  Len : Integer ); stdcall;
procedure nspsbLg2(Src : PFloat;  Dst : PFloat; Len : Integer); stdcall;
procedure nspdbLg1(Vec : PDouble; Len : Integer); stdcall;
procedure nspdbLg2(Src : PDouble; Dst : PDouble; Len : Integer); stdcall;

{***** complex decimal functions  **}
procedure nspcbLg1(Vec : PSCplx;  Len : Integer); stdcall;
procedure nspcbLg2(Src : PSCplx;  Dst : PSCplx; Len : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsplogic.h
Purpose: NSP Vector Shift and Logical Operations Header File.
*)

{-------------------------------------------------------}
{              Vector Logical Functions                 }
{-------------------------------------------------------}


{
 bShift: Left or right arithmetic shift the elements of the vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results of the
              left shift  dst << nShift or right shift  dst >> nShift (L/R).
          n   The number of elements to be operated on.
      nShift  The number of position which vector elements to be shifted on.
}

procedure nspwbShiftL(Dst : PShort; N : Integer; NShift : Integer); stdcall;
procedure nspwbShiftR(Dst : PShort; N : Integer; NShift : Integer); stdcall;

{
  bAnd1 : ANDs the elements of a vector with a scalar.
  bAnd2 : ANDs the elements of two vectors.
  bAnd3 : ANDs the elements of two vectors and stores the result in
          a third vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the AND operation src AND dst.
        src   Pointer to the vector to be bitwise ANDed with
              elements of dst.
        val   The value to be ANDed with each element of the vector
              dst.
 srcA, srcB   Pointers to the vectors whose elements are to be
          n   The number of elements to be operated on.
}

procedure nspwbAnd1(Val : Short;  Dst : PShort; N : Integer); stdcall;
procedure nspwbAnd2(Src : PShort; Dst : PShort; N : Integer); stdcall;
procedure nspwbAnd3(SrcA, SrcB, Dst   : PShort; N : Integer); stdcall;

{
  bXor1 : XORs the elements of a vector with a scalar.
  bXor2 : XORs the elements of two vectors.
  bXor3 : XORs the elements of two vectors and stores the result in
          a third vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the XOR operation src XOR dst.
        src   Pointer to the vector to be bitwise XORed with
              elements of dst.
 srcA, srcB   Pointers to the vectors whose elements are to be
              bitwise XORed.
        val   The scalar which is XORed with each vector element.
          n   The number of elements to be operated on.
}

procedure nspwbXor1(Val : Short;  Dst : PShort; N : Integer); stdcall;
procedure nspwbXor2(Src : PShort; Dst : PShort; N : Integer); stdcall;
procedure nspwbXor3(SrcA, SrcB, Dst   : PShort; N : Integer); stdcall;

{
  bOr1  : ORs the elements of a vector with a scalar.
  bOr2  : ORs the elements of two vectors.
  bOr3  : ORs the elements of two vectors and stores the result in
          a third vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the OR operation src OR dst.
        src   Pointer to the vector to be bitwise ORed with
              elements of dst.
        val   The scalar which is ORed with each vector element.
 srcA, srcB   Pointers to the vectors whose elements are to be
              bitwise ORed.
          n   The number of elements to be operated on.
}

procedure nspwbOr1(Val : Short;  Dst : PShort; N : Integer); stdcall;
procedure nspwbOr2(Src : PShort; Dst : PShort; N : Integer); stdcall;
procedure nspwbOr3(SrcA, SrcB, Dst   : PShort; N : Integer); stdcall;

{
  bNot : Performs a logical NOT of the elements of a vector

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the logical operation NOT dst.
          n   The number of elements to be operated on.
}

procedure nspwbNot(Dst : PShort; N : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspmed.h
Purpose: NSP Median Filter
*)

procedure nspsbMedianFilter1(InOut    : PFloat; Len : Integer;
                             MaskSize : Integer); stdcall;
procedure nspdbMedianFilter1(InOut    : PDouble; Len : Integer;
                             MaskSize : Integer); stdcall;
procedure nspwbMedianFilter1(InOut    : PShort; Len : Integer;
                             MaskSize : Integer); stdcall;

procedure nspsbMedianFilter2(const pIn      : PFloat;  pOut : PFloat;
                                   Len      : Integer;
                                   MaskSize : Integer); stdcall;
procedure nspdbMedianFilter2(const pIn      : PDouble; pOut : PDouble;
                                   Len      : Integer;
                                   MaskSize : Integer); stdcall;
procedure nspwbMedianFilter2(const pIn      : PShort;  pOut : PShort;
                                   Len      : Integer;
                                   MaskSize : Integer); stdcall;
{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspmisc.h
Purpose: NSP Miscellaneous Signal Processing Functions
*)

{------------------------------------------------------------------------}
{                                                                        }
{      BitRev, CalcBitRevTbl, GetBitRevTbl, FreeBitRevTbls               }
{                                                                        }
{ Obtain bit-reversed numbers, indices, and indexing tables.             }
{                                                                        }
{------------------------------------------------------------------------}

function  nspBitRev(       A   : Integer;  Order : Integer) : Integer;  stdcall;
function  nspGetBitRevTbl(                 Order : Integer) : PInteger; stdcall;
procedure nspCalcBitRevTbl(Tbl : PInteger; Order : Integer);            stdcall;
procedure nspFreeBitRevTbls;                                            stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                     bBitRev1, bBitRev2                                 }
{                                                                        }
{ Permute a vector into binary bit-reversed order.                       }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspwbBitRev1(Vec   : PShort;  Order : Integer); stdcall;
procedure nspvbBitRev1(Vec   : PWCplx;  Order : Integer); stdcall;
procedure nspsbBitRev1(Vec   : PFloat;  Order : Integer); stdcall;
procedure nspcbBitRev1(Vec   : PSCplx;  Order : Integer); stdcall;
procedure nspdbBitRev1(Vec   : PDouble; Order : Integer); stdcall;
procedure nspzbBitRev1(Vec   : PDCplx;  Order : Integer); stdcall;

procedure nspwbBitRev2(Src   : PShort;  Dst   : PShort;
                       Order : Integer);                 stdcall;
procedure nspvbBitRev2(Src   : PWCplx;  Dst   : PWCplx;
                       Order : Integer);                 stdcall;
procedure nspsbBitRev2(Src   : PFloat;  Dst   : PFloat;
                       Order : Integer);                 stdcall;
procedure nspcbBitRev2(Src   : PSCplx;  Dst   : PSCplx;
                       Order : Integer);                 stdcall;
procedure nspdbBitRev2(Src   : PDouble; Dst   : PDouble;
                       Order : Integer);                 stdcall;
procedure nspzbBitRev2(Src   : PDCplx;  Dst   : PDCplx;
                       Order : Integer);                 stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                  GetFftTwdTbl, GetDftTwdTbl, FreeTwdTbls               }
{                                                                        }
{ Compute and store twiddle factors for FFT and DFT computations.        }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspvCalcDftTwdTbl(Tbl : PWCplx; Len   : Integer); stdcall;
procedure nspvCalcFftTwdTbl(Tbl : PWCplx; Order : Integer); stdcall;
procedure nspcCalcDftTwdTbl(Tbl : PSCplx; Len   : Integer); stdcall;
procedure nspcCalcFftTwdTbl(Tbl : PSCplx; Order : Integer); stdcall;
procedure nspzCalcDftTwdTbl(Tbl : PDCplx; Len   : Integer); stdcall;
procedure nspzCalcFftTwdTbl(Tbl : PDCplx; Order : Integer); stdcall;

function nspvGetDftTwdTbl(Len   : Integer) : PWCplx; stdcall;
function nspvGetFftTwdTbl(Order : Integer) : PWCplx; stdcall;
function nspcGetDftTwdTbl(Len   : Integer) : PSCplx; stdcall;
function nspcGetFftTwdTbl(Order : Integer) : PSCplx; stdcall;
function nspzGetDftTwdTbl(Len   : Integer) : PDCplx; stdcall;
function nspzGetFftTwdTbl(Order : Integer) : PDCplx; stdcall;

procedure nspvFreeTwdTbls; stdcall;
procedure nspcFreeTwdTbls; stdcall;
procedure nspzFreeTwdTbls; stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspnorm.h
Purpose:
*)

const
  NSP_C         = $01;
  NSP_L1        = $02;
  NSP_L2        = $04;
  NSP_RELATIVE  = $08;
  NSP_SQR_L2    = $10;


// Functions: nsp?Norm
//  Compute the C, L1 or L2 norm of the input vectors’ difference ||a-b||
//  or of one vector ||a||.
//  Vector x[n]' norm definitions:
//  C  norm: ||x[n]|| = MAX(|x[i]|)
//  L1 norm: ||x[n]|| = SUMM(|x[i]|)
//  L2 norm: ||x[n]|| = SQRT( SUMM(x[i]*x[i]) )
//  SQR_L2 norm: ||x[n]|| = SUMM(x[i]*x[i])
//
// Parameters:
//  srcA    - pointer to the first input vector a[n], must not be NULL.
//  srcB    - pointer to the second input vector b[n].
//  len     - the number of elements in the input vectors.
//  flag    - specifies the norm type and the relative mode.
//          Possible values:
//          NSP_C  - C  norm,
//          NSP_L1 - L1 norm,
//          NSP_L2 - L2 norm,
//          NSP_SQR_L2 - SQR_L2 norm,
//          NSP_C |NSP_RELATIVE - C  norm and relative mode,
//          NSP_L1|NSP_RELATIVE - L1 norm and relative mode,
//          NSP_L2|NSP_RELATIVE - L2 norm and relative mode.
//          NSP_SQR_L2|NSP_RELATIVE - SQR_L2 norm and relative mode.
//
//  Returned value:
//          ||a-b||       if srcB != NULL && !(flag & NSP_RELATIVE)
//          ||a||         if srcB == NULL && !(flag & NSP_RELATIVE)
//          ||a-b||/||a|| if srcB != NULL && flag & NSP_RELATIVE
//          1             if srcB == NULL && flag & NSP_RELATIVE
//          FLT_MAX       if ||a|| < FLT_MIN && flag & NSP_RELATIVE

function nspsNorm(SrcA : PFloat;  SrcB : PFloat;
                  Len  : Integer; Flag : Integer) : Float;  stdcall;
function nspcNorm(SrcA : PSCplx;  SrcB : PSCplx;
                  Len  : Integer; Flag : Integer) : Float;  stdcall;
function nspdNorm(SrcA : PDouble; SrcB : PDouble;
                  Len  : Integer; Flag : Integer) : Double; stdcall;
function nspzNorm(SrcA : PDCplx;  SrcB : PDCplx;
                  Len  : Integer; Flag : Integer) : Double; stdcall;
function nspwNorm(SrcA : PShort;  SrcB : PShort;
                  Len  : Integer; Flag : Integer) : Float;  stdcall;
function nspvNorm(SrcA : PWCplx;  SrcB : PWCplx;
                  Len  : Integer; Flag : Integer) : Float;  stdcall;

// Functions: nspwNormExt, nspvNormExt
//  Compute the C, L1 or L2 norm of the input vectors’ difference ||a-b||
//  or of one vector ||a|| as nsp?Norm functions
//  and scales the float result to int result according to scale mode and
//  scale factor.
//
// Parameters:
//  srcA    pointer to the first input vector a[n], must not be NULL.
//  srcB    pointer to the second input vector b[n].
//  len     the number of elements in the input vectors.
//  flag    specifies the norm type and the relative mode.
//          Possible values:
//          NSP_C  - C  norm,
//          NSP_L1 - L1 norm,
//          NSP_L2 - L2 norm,
//          NSP_SQR_L2 - SQR_L2 norm,
//          NSP_C |NSP_RELATIVE - C  norm and relative mode,
//          NSP_L1|NSP_RELATIVE - L1 norm and relative mode,
//          NSP_L2|NSP_RELATIVE - L2 norm and relative mode.
//          NSP_SQR_L2|NSP_RELATIVE - SQR_L2 norm and relative mode.
//  scaleMode    scale mode for returned value.
//               Below VALUE is float, non-negative result of nsp?Norm.
//               scale(VALUE) will be compute according to scaleMode:
//          NSP_NO_SCALE              - scale(VALUE) = (int)(VALUE+0.5)
//          NSP_NO_SCALE|NSP_SATURATE - scale(VALUE) = VALUE+0.5 >= INT_MAX ?
//                                                     INT_MAX :
//                                                     (int)(VALUE+0.5)
//          NSP_FIXED_SCALE              - scale(VALUE) =
//                                         (int)(VALUE/(1<<*scaleFactor))
//          NSP_FIXED_SCALE|NSP_SATURATE - scale(VALUE) =
//                                         (VALUE/(1<<*scaleFactor) >= INT_MAX ?
//                                         INT_MAX :
//                                         (int)(VALUE/(1<<*scaleFactor))
//          NSP_AUTO_SCALE - scale(VALUE) = (int)(VALUE/(1<<*scaleFactor)) where
//                           VALUE/(1<<*scaleFactor) < INT_MAX
//  scaleFactor  pointer to scale factor for returned value (see above)
//
//  Returned value:
//          scale(||a-b||)       if srcB != NULL && !(flag & NSP_RELATIVE)
//          scale(||a||)         if srcB == NULL && !(flag & NSP_RELATIVE)
//          scale(||a-b||/||a||) if srcB != NULL && flag & NSP_RELATIVE
//          1                    if srcB == NULL && flag & NSP_RELATIVE
//          scale(FLT_MAX)       if ||a|| < FLT_MIN && flag & NSP_RELATIVE

function nspwNormExt(SrcA        : PShort;  SrcB : PShort;
                     Len         : Integer; Flag : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer) : Integer; stdcall;
function nspvNormExt(SrcA        : PWCplx;  SrcB : PWCplx;
                     Len         : Integer; Flag : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer) : Integer; stdcall;

// Function: nsp?bNormalize().
//  Subtract the offset constant from the elements of the input vector a[n]
//  and divides the result by factor.
//  Output vector b[n] has the elements:
//      b[i] = ( a[i] - offset) / factor.
//
// Parameters:
//  src     pointer to the input vector a[n].
//  dst     pointer to the output vector b[n].
//  len     the number of elements in the input and output vectors.
//  offset  offset for each element a[i]
//  factor  factor for each element a[i]

procedure nspsbNormalize(Src    : PFloat;  Dst    : PFloat;  Len : Integer;
                         Offset : Float;   Factor : Float);  stdcall;
procedure nspcbNormalize(Src    : PSCplx;  Dst    : PSCplx;  Len : Integer;
                         Offset : TSCplx;  Factor : Float);  stdcall;
procedure nspdbNormalize(Src    : PDouble; Dst    : PDouble; Len : Integer;
                         Offset : Double;  Factor : Double); stdcall;
procedure nspzbNormalize(Src    : PDCplx;  Dst    : PDCplx;  Len : Integer;
                         Offset : TDCplx;  Factor : Double); stdcall;
procedure nspwbNormalize(Src    : PShort;  Dst    : PShort;  Len : Integer;
                         Offset : Short;   Factor : Float);  stdcall;
procedure nspvbNormalize(Src    : PWCplx;  Dst    : PWCplx;  Len : Integer;
                         Offset : TWCplx;  Factor : Float);  stdcall;

// Functions: nspsSum, nspdSum, nspcSum, nspzSum
//  Compute the sum of the input vectors’ elements.
//
// Parameters:
//  src   pointer to the input vector.
//  n     the number of elements in the input vector.
//
//  Returned value:  SUM (src[i])

function nspsSum(Src : PFloat;  N : Integer) : Float;  stdcall;
function nspdSum(Src : PDouble; N : Integer) : Double; stdcall;
function nspcSum(Src : PSCplx;  N : Integer; var Sum : TSCplx) : NSPStatus; stdcall;
function nspzSum(Src : PDCplx;  N : Integer; var Sum : TDCplx) : NSPStatus; stdcall;

// Function: nspwSum
//  Computes the sum of the input vectors’ elements with scaling.
//
// Parameters:
//  src          pointer to the input vector.
//  n            the number of elements in the input vector.
//  scaleMode    scale mode for returned value.
//  scaleFactor  pointer to scale factor for returned value.
//
//  Returned value:  SCALE (SUM (src[i]))

function nspwSum(Src         : PShort; N : Integer;
                 ScaleMode   : Integer;
             var ScaleFactor : Integer)  : Integer; stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From: nsprand.h
*)

const
  XBUFLEN = 32;

type
  TNSPSRandUniState = record
    Low, Muler   : Float;                  // Lower value and scale multiplier
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

  TNSPDRandUniState = record
    Low, Muler   : Double;                 // Lower value and scale multiplier
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

{
  A new state structure of the pseudo random numbers
  generator has two seed values (m_seed) now. Generator
  based on multiplication uses m_seed values. Generator
  based on subtraction uses d_seed and carry.
}

  TNSPWRandUniState = record
    Low, Muler   : Float;
    Center, Pwr2 : Integer;
    M_Seed       : array [0..1] of UINT;
    D_Seed       : array [0..2] of UINT;
    Carry        : UINT;
    QuickSeed    : Integer;
    Current      : Integer;
    XBuf         : array [0..XBUFLEN-1] of Short;
  end;

  TNSPCRandUniState = TNSPSRandUniState;
  TNSPZRandUniState = TNSPDRandUniState;
  TNSPVRandUniState = TNSPWRandUniState;

  TNSPSRandGausState = record
    Mean, StDev  : Float;                  // Mean and standard deviation values
    ExtraValue   : Float;                  // Value computed early
    UseExtra     : Integer;                // Flag to use extra value
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

  TNSPDRandGausState = record
    Mean, StDev  : Double;                 // Mean and standard deviation values
    ExtraValue   : Double;                 // Value computed early
    UseExtra     : Integer;                // Flag to use extra value
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

  TNSPWRandGausState = record
    UseExtra     : Integer;
    Seed2, Carry : UINT;
    Seed1        : array [0..2] of UINT;
    Mean, StDev  : Short;
    ExtraValue   : Short;
    QuickSeed    : Integer;
  end;

  TNSPCRandGausState = TNSPSRandGausState;
  TNSPZRandGausState = TNSPDRandGausState;
  TNSPVRandGausState = TNSPWRandGausState;

{-------------------------------------------------------------------------}
{
   Uniform distribution.
   Algorithm by G.Marsaglia and A.Zaman (Computers in Physics, vol.8,
   #1, 1994, 117) are used to build generator of uniformly distributed
   random numbers.
}

procedure nspsRandUniInit(Seed, Low, High : Float;
                      var State : TNSPSRandUniState); stdcall;
procedure nspcRandUniInit(Seed, Low, High : Float;
                      var State : TNSPCRandUniState); stdcall;
procedure nspdRandUniInit(Seed, Low, High : Double;
                      var State : TNSPDRandUniState); stdcall;
procedure nspzRandUniInit(Seed, Low, High : Double;
                      var State : TNSPZRandUniState); stdcall;
procedure nspwRandUniInit(Seed : UINT; Low, High : Short;
                      var State : TNSPWRandUniState); stdcall;
procedure nspvRandUniInit(Seed : UINT; Low, High : Short;
                      var State : TNSPVRandUniState); stdcall;

function  nspsRandUni(var State : TNSPSRandUniState) : Float;  stdcall;
function  nspcRandUni(var State : TNSPCRandUniState) : TSCplx; stdcall;
function  nspdRandUni(var State : TNSPDRandUniState) : Double; stdcall;
function  nspzRandUni(var State : TNSPZRandUniState) : TDCplx; stdcall;
function  nspwRandUni(var State : TNSPWRandUniState) : Short;  stdcall;
function  nspvRandUni(var State : TNSPVRandUniState) : TWCplx; stdcall;
procedure nspcRandUniOut(var State : TNSPCRandUniState;
                         var Val   : TSCplx); stdcall;

procedure nspsbRandUni(var State    : TNSPSRandUniState;
                           Samps    : PFloat;
                           SampsLen : Integer); stdcall;
procedure nspcbRandUni(var State    : TNSPCRandUniState;
                           Samps    : PSCplx;
                           SampsLen : Integer); stdcall;
procedure nspdbRandUni(var State    : TNSPDRandUniState;
                           Samps    : PDouble;
                           SampsLen : Integer); stdcall;
procedure nspzbRandUni(var State    : TNSPZRandUniState;
                           Samps    : PDCplx;
                           SampsLen : Integer); stdcall;
procedure nspwbRandUni(var State    : TNSPWRandUniState;
                           Samps    : PShort;
                           SampsLen : Integer); stdcall;
procedure nspvbRandUni(var State    : TNSPVRandUniState;
                           Samps    : PWCplx;
                           SampsLen : Integer); stdcall;

{
   Normal distribution.
   Algorithm by G.Box and M.Muller and by G.Marsaglia (Reference:
   D.Knuth. The Art of Computer Programming. vol.2, 1969) are used
   to build generator of normally distributed random numbers.
}

procedure nspsRandGausInit(Seed, Mean, StDev : Float;
                       var State : TNSPSRandGausState); stdcall;
procedure nspcRandGausInit(Seed, Mean, StDev : Float;
                       var State : TNSPCRandGausState); stdcall;
procedure nspdRandGausInit(Seed, Mean, StDev : Double;
                       var State : TNSPDRandGausState); stdcall;
procedure nspzRandGausInit(Seed, Mean, StDev : Double;
                       var State : TNSPZRandGausState); stdcall;
procedure nspwRandGausInit(Seed, Mean, StDev : Short;
                       var State : TNSPWRandGausState); stdcall;
procedure nspvRandGausInit(Seed, Mean, StDev : Short;
                       var State : TNSPVRandGausState); stdcall;

function nspsRandGaus(var State : TNSPSRandGausState) : Float;  stdcall;
function nspcRandGaus(var State : TNSPCRandGausState) : TSCplx; stdcall;
function nspdRandGaus(var State : TNSPDRandGausState) : Double; stdcall;
function nspzRandGaus(var State : TNSPZRandGausState) : TDCplx; stdcall;
function nspwRandGaus(var State : TNSPWRandGausState) : Short;  stdcall;
function nspvRandGaus(var State : TNSPVRandGausState) : TWCplx; stdcall;
procedure nspcRandGausOut(var State : TNSPCRandGausState;
                          var Val   : TSCplx); stdcall;

procedure nspsbRandGaus(var State    : TNSPSRandGausState;
                            Samps    : PFloat;
                            SampsLen : Integer); stdcall;
procedure nspcbRandGaus(var State    : TNSPCRandGausState;
                            Samps    : PSCplx;
                            SampsLen : Integer); stdcall;
procedure nspdbRandGaus(var State    : TNSPDRandGausState;
                            Samps    : PDouble;
                            SampsLen : Integer); stdcall;
procedure nspzbRandGaus(var State    : TNSPZRandGausState;
                            Samps    : PDCplx;
                            SampsLen : Integer); stdcall;
procedure nspwbRandGaus(var State    : TNSPWRandGausState;
                            Samps    : PShort;
                            SampsLen : Integer); stdcall;
procedure nspvbRandGaus(var State    : TNSPVRandGausState;
                            Samps    : PWCplx;
                            SampsLen : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1999 Intel Corporation. All Rights Reserved.

From: nsprsmpl.h
*)

type TNSPSampState = record
  NFactors    : Integer;
  NTaps       : Integer;
  SLen        : Integer;
  DLen        : Integer;
  IsSampInit  : Integer;
  FactorRange : PFloat;
  Freq        : PFloat;
  Taps        : Pointer;
  FirState    : TNSPFirState;
end;

function nspsSampInit(var SampSt : TNSPSampState;
                          FactorRange : PFloat;
                          Freq        : PFloat;
                          NFactors    : Integer;
                          NTaps       : Integer) : NSPStatus; stdcall;
function nspdSampInit(var SampSt : TNSPSampState;
                          FactorRange : PFloat;
                          Freq        : PFloat;
                          NFactors    : Integer;
                          NTaps       : Integer) : NSPStatus; stdcall;

function nspsSamp(var SampSt : TNSPSampState;
                      Src    : PFloat; SrcLen : Integer;
                      Dst    : PFloat; DstLen : Integer) : NSPStatus; stdcall;
function nspdSamp(var SampSt : TNSPSampState;
                      Src    : PDouble; SrcLen : Integer;
                      Dst    : PDouble; DstLen : Integer) : NSPStatus; stdcall;

procedure nspSampFree(var SampSt : TNSPSampState); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspsampl.h
Purpose: Purpose: NSP sample
*)

{-------------------------------------------------------------------------}
{        UpSample                                                         }
{                                                                         }
{ Up-sample  a  signal, conceptually increasing  its  sampling rate by an }
{ integer factor and forming output parameters for next sampling;         }

procedure nspsUpSample(Src    : PFloat;      SrcLen : Integer;
                       Dst    : PFloat;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
procedure nspcUpSample(Src    : PSCplx;      SrcLen : Integer;
                       Dst    : PSCplx;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
procedure nspdUpSample(Src    : PDouble;     SrcLen : Integer;
                       Dst    : PDouble; var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
procedure nspzUpSample(Src    : PDCplx;      SrcLen : Integer;
                       Dst    : PDCplx;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
procedure nspwUpSample(Src    : PShort;      SrcLen : Integer;
                       Dst    : PShort;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
procedure nspvUpSample(Src    : PWCplx;      SrcLen : Integer;
                       Dst    : PWCplx;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;

{-------------------------------------------------------------------------}
{        DownSample                                                       }
{                                                                         }
{ Down-sample a  signal, conceptually decreasing  its sample rate  by an  }
{ integer factor and forming output parameters for next sampling;         }

procedure nspsDownSample(Src    : PFloat;      SrcLen : Integer;
                         Dst    : PFloat;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
procedure nspcDownSample(Src    : PSCplx;      SrcLen : Integer;
                         Dst    : PSCplx;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
procedure nspdDownSample(Src    : PDouble;     SrcLen : Integer;
                         Dst    : PDouble; var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
procedure nspzDownSample(Src    : PDCplx;      SrcLen : Integer;
                         Dst    : PDCplx;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
procedure nspwDownSample(Src    : PShort;      SrcLen : Integer;
                         Dst    : PShort;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
procedure nspvDownSample(Src    : PWCplx;      SrcLen : Integer;
                         Dst    : PWCplx;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nsptone.h
Purpose: NSP Tone Generator. Declarator
*)

{--- Tone structures -----------------------------------------------------}

type
  TNSPSToneState = record
    CosBase  : Double;
    CosCurr  : Double;
    CosPrev  : Double;
    Mag      : Float;
    RFreq    : Float;
    Phase    : Float;
    IsInit   : array [0..3] of Char;
    Reserved : array [0..13] of Float;
  end;

  TNSPCToneState = record
    CosBase  : Double;
    CosCurr  : TDCplx;
    CosPrev  : TDCplx;
    Mag      : Float;
    RFreq    : Float;
    Phase    : Float;
    IsInit   : array [0..3] of Char;
    Reserved : array [0..9] of Float;
  end;

  TNSPDToneState = record
    CosBase : Double;
    CosCurr : Double;
    CosPrev : Double;
    Mag     : Double;
    RFreq   : Double;
    Phase   : Double;
    IsInit  : array [0..3] of Char;
  end;

  TNSPZToneState = record
    CosBase : Double;
    CosCurr : TDCplx;
    CosPrev : TDCplx;
    Mag     : Double;
    RFreq   : Double;
    Phase   : Double;
    IsInit  : array [0..3] of Char;
  end;

  TNSPWToneState = record
    Dummy   : array [0..31] of Double;
  end;

  TNSPVToneState = record
    Dummy   : array [0..31] of Double;
  end;

{--- Initialization ------------------------------------------------------}

procedure nspwToneInit(RFreq : Float;  Phase : Float;  Mag : Short;
                   var State : TNSPWToneState); stdcall;
procedure nspvToneInit(RFreq : Float;  Phase : Float;  Mag : Short;
                   var State : TNSPVToneState); stdcall;
procedure nspsToneInit(RFreq : Float;  Phase : Float;  Mag : Float;
                   var State : TNSPSToneState) ; stdcall;
procedure nspcToneInit(RFreq : Float;  Phase : Float;  Mag : Float;
                   var State : TNSPCToneState); stdcall;
procedure nspdToneInit(RFreq : Double; Phase : Double; Mag : Double;
                   var State : TNSPDToneState) ; stdcall;
procedure nspzToneInit(RFreq : Double; Phase : Double; Mag : Double;
                   var State : TNSPZToneState); stdcall;

{--- Dot product tone functions ------------------------------------------}

function nspwTone(var State : TNSPWToneState) : Short;  stdcall;
function nspvTone(var State : TNSPVToneState) : TWCplx; stdcall;
function nspsTone(var State : TNSPSToneState) : Float;  stdcall;
function nspcTone(var State : TNSPCToneState) : TSCplx; stdcall;
function nspdTone(var State : TNSPDToneState) : Double; stdcall;
function nspzTone(var State : TNSPZToneState) : TDCplx; stdcall;
procedure nspcToneOut(var State : TNSPCToneState;
                      var Val   : TSCplx); stdcall;

{--- Array product tone functions ----------------------------------------}

procedure nspwbTone(var State : TNSPWToneState;
                        Samps : PShort;  SampsLen : Integer); stdcall;
procedure nspvbTone(var State : TNSPVToneState;
                        Samps : PWCplx;  SampsLen : Integer); stdcall;
procedure nspsbTone(var State : TNSPSToneState;
                        Samps : PFloat;  SampsLen : Integer); stdcall;
procedure nspcbTone(var State : TNSPCToneState;
                        Samps : PSCplx;  SampsLen : Integer); stdcall;
procedure nspdbTone(var State : TNSPDToneState;
                        Samps : PDouble; SampsLen : Integer); stdcall;
procedure nspzbTone(var State : TNSPZToneState;
                        Samps : PDCplx;  SampsLen : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:     nsptrngl.h
Purpose:  Generating of signals with triangle wave form.
          Provides samples of a triangle of arbitrary frequency,
          phase, magnitude, and asymmetry.

          0 =< phase < 2PI,  -PI < asym < PI,
          mag > 0, 0 =< rfrec < 0.5

          asym = 0       => Triangle is symmetric (old version)
          asym = -PI+eps => Triangle with sheer back (0<eps)
          asym =  PI-eps => Triangle with sheer front-fore

          Like (cos) tone functions the triangle has period equal 2PI
          Triangle phase is given in radians.
*)

{--- Triangle structures -------------------------------------------------}

type
  TNSPWTrnglState = record
    Mag    : Float;
    Step   : Float;
    Step1  : Float;
    Step2  : Float;
    St12   : Float;
    St21   : Float;
    Shft1  : Float;
    Shft2  : Float;
    Delta1 : Float;
    Delta2 : Float;
    Last   : Float;
  end;

  TNSPVTrnglState = record
    Mag    : Float;
    Step   : TSCplx;
    Step1  : Float;
    Step2  : Float;
    St12   : Float;
    St21   : Float;
    Shft1  : Float;
    Shft2  : Float;
    Delta1 : Float;
    Delta2 : Float;
    Last   : TSCplx;
  end;

  TNSPSTrnglState = record
    Mag      : Float;
    Step     : Float;
    Step1    : Float;
    Step2    : Float;
    St12     : Float;
    St21     : Float;
    Shft1    : Float;
    Shft2    : Float;
    Delta1   : Float;
    Delta2   : Float;
    Last     : Float;
    Reserved : array [0..17] of Float;
  end;

  TNSPCTrnglState = record
    Mag    : Float;
    Step   : TSCplx;
    Step1  : Float;
    Step2  : Float;
    St12   : Float;
    St21   : Float;
    Shft1  : Float;
    Shft2  : Float;
    Delta1 : Float;
    Delta2 : Float;
    Last   : TSCplx;
    Reserved : array [0..12] of Float;
  end;

  TNSPDTrnglState = record
    Mag    : Double;
    Step   : Double;
    Step1  : Double;
    Step2  : Double;
    St12   : Double;
    St21   : Double;
    Shft1  : Double;
    Shft2  : Double;
    Delta1 : Double;
    Delta2 : Double;
    Last   : Double;
  end;

  TNSPZTrnglState = record
    Mag    : Double;
    Step   : TDCplx;
    Step1  : Double;
    Step2  : Double;
    St12   : Double;
    St21   : Double;
    Shft1  : Double;
    Shft2  : Double;
    Delta1 : Double;
    Delta2 : Double;
    Last   : TDCplx;
  end;

{--- Triangle initialization ---------------------------------------------}

procedure nspwTrnglInit(RFrq  : Float;  Phase : Float;
                        Mag   : Short;  Asym  : Float;
                    var State : TNSPWTrnglState); stdcall;
procedure nspvTrnglInit(RFrq  : Float;  Phase : Float;
                        Mag   : Short;  Asym  : Float;
                    var State : TNSPVTrnglState); stdcall;
procedure nspsTrnglInit(RFrq  : Float;  Phase : Float;
                        Mag   : Float;  Asym  : Float;
                    var State : TNSPSTrnglState); stdcall;
procedure nspcTrnglInit(RFrq  : Float;  Phase : Float;
                        Mag   : Float;  Asym  : Float;
                    var State : TNSPCTrnglState); stdcall;
procedure nspdTrnglInit(RFrq  : Double; Phase : Double;
                        Mag   : Double; Asym  : Double;
                    var State : TNSPDTrnglState); stdcall;
procedure nspzTrnglInit(RFrq  : Double; Phase : Double;
                        Mag   : Double; Asym  : Double;
                    var State : TNSPZTrnglState); stdcall;

{--- Single-Sample-Generating triangle functions -------------------------}

function nspwTrngl(var State : TNSPWTrnglState) : Short;  stdcall;
function nspvTrngl(var State : TNSPVTrnglState) : TWCplx; stdcall;
function nspsTrngl(var State : TNSPSTrnglState) : Float;  stdcall;
function nspcTrngl(var State : TNSPCTrnglState) : TSCplx; stdcall;
function nspdTrngl(var State : TNSPDTrnglState) : Double; stdcall;
function nspzTrngl(var State : TNSPZTrnglState) : TDCplx; stdcall;
procedure nspcTrnglOut(var State : TNSPCTrnglState;
                       var Val   : TSCplx); stdcall;

{--- Block-of-Samples-Generating triangle functions ----------------------}

procedure nspwbTrngl(var State    : TNSPWTrnglState;
                         Samps    : PShort;
                         SampsLen : Integer); stdcall;
procedure nspvbTrngl(var State    : TNSPVTrnglState;
                         Samps    : PWCplx;
                         SampsLen : Integer); stdcall;
procedure nspsbTrngl(var State    : TNSPSTrnglState;
                         Samps    : PFloat;
                         SampsLen : Integer); stdcall;
procedure nspcbTrngl(var State    : TNSPCTrnglState;
                         Samps    : PSCplx;
                         SampsLen : Integer); stdcall;
procedure nspdbTrngl(var State    : TNSPDTrnglState;
                         Samps    : PDouble;
                         SampsLen : Integer); stdcall;
procedure nspzbTrngl(var State    : TNSPZTrnglState;
                         Samps    : PDCplx;
                         SampsLen : Integer); stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspvec.h
Purpose: NSP Vector Arithmetic and Algebraic Functions
*)

{ ------------------------------------------------------------------------}
const
  NSP_GT     = 1;
  NSP_LT     = 0;
  HUGE_VAL_S = 3.402823466e+38;

procedure nspsbSqr1(Vec         : PFloat;  Len : Integer); stdcall;
procedure nspcbSqr1(Vec         : PSCplx;  Len : Integer); stdcall;
procedure nspdbSqr1(Vec         : PDouble; Len : Integer); stdcall;
procedure nspzbSqr1(Vec         : PDCplx;  Len : Integer); stdcall;
procedure nspwbSqr1(Vec         : PShort;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;
procedure nspvbSqr1(Vec         : PWCplx;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

procedure nspsbSqr2(Src, Dst    : PFloat;  Len : Integer); stdcall;
procedure nspcbSqr2(Src, Dst    : PSCplx;  Len : Integer); stdcall;
procedure nspdbSqr2(Src, Dst    : PDouble; Len : Integer); stdcall;
procedure nspzbSqr2(Src, Dst    : PDCplx;  Len : Integer); stdcall;
procedure nspwbSqr2(Src, Dst    : PShort;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;
procedure nspvbSqr2(Src, Dst    : PWCplx;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

procedure nspsbSqrt1(Vec        : PFloat;  Len : Integer); stdcall;
procedure nspcbSqrt1(Vec        : PSCplx;  Len : Integer); stdcall;
procedure nspdbSqrt1(Vec        : PDouble; Len : Integer); stdcall;
procedure nspzbSqrt1(Vec        : PDCplx;  Len : Integer); stdcall;
procedure nspwbSqrt1(Vec        : PShort;  Len : Integer); stdcall;
procedure nspvbSqrt1(Vec        : PWCplx;  Len : Integer); stdcall;

procedure nspsbSqrt2(Src, Dst   : PFloat;  Len : Integer); stdcall;
procedure nspcbSqrt2(Src, Dst   : PSCplx;  Len : Integer); stdcall;
procedure nspdbSqrt2(Src, Dst   : PDouble; Len : Integer); stdcall;
procedure nspzbSqrt2(Src, Dst   : PDCplx;  Len : Integer); stdcall;
procedure nspwbSqrt2(Src, Dst   : PShort;  Len : Integer); stdcall;
procedure nspvbSqrt2(Src, Dst   : PWCplx;  Len : Integer); stdcall;

procedure nspsbThresh1(Vec      : PFloat;  Len   : Integer;
                       Thresh   : Float;   RelOp : Integer); stdcall;
procedure nspcbThresh1(Vec      : PSCplx;  Len   : Integer;
                       Thresh   : Float;   RelOp : Integer); stdcall;
procedure nspdbThresh1(Vec      : PDouble; Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
procedure nspzbThresh1(Vec      : PDCplx;  Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
procedure nspwbThresh1(Vec      : PShort;  Len   : Integer;
                       Thresh   : Short;   RelOp : Integer); stdcall;
procedure nspvbThresh1(Vec      : PWCplx;  Len   : Integer;
                       Thresh   : Short;   RelOp : Integer); stdcall;

procedure nspsbThresh2(Src, Dst : PFloat;  Len   : Integer;
                       Thresh   : Float;   RelOp : Integer); stdcall;
procedure nspcbThresh2(Src, Dst : PSCplx;  Len   : Integer;
                       Thresh   : Float;   RelOp : Integer); stdcall;
procedure nspdbThresh2(Src, Dst : PDouble; Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
procedure nspzbThresh2(Src, Dst : PDCplx;  Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
procedure nspwbThresh2(Src, Dst : PShort;  Len   : Integer;
                       Thresh   : Short;   RelOp : Integer); stdcall;
procedure nspvbThresh2(Src, Dst : PWCplx;  Len   : Integer;
                       Thresh   : Short;   RelOp : Integer); stdcall;

procedure nspsbInvThresh1(Vec    : PFloat;  Len : Integer;
                          Thresh : Float);  stdcall;
procedure nspcbInvThresh1(Vec    : PSCplx;  Len : Integer;
                          Thresh : Float);  stdcall;
procedure nspdbInvThresh1(Vec    : PDouble; Len : Integer;
                          Thresh : Double); stdcall;
procedure nspzbInvThresh1(Vec    : PDCplx;  Len : Integer;
                          Thresh : Double); stdcall;

procedure nspsbInvThresh2(Src, Dst : PFloat;  Len : Integer;
                          Thresh   : Float);  stdcall;
procedure nspcbInvThresh2(Src, Dst : PSCplx;  Len : Integer;
                          Thresh   : Float);  stdcall;
procedure nspdbInvThresh2(Src, Dst : PDouble; Len : Integer;
                          Thresh   : Double); stdcall;
procedure nspzbInvThresh2(Src, Dst : PDCplx;  Len : Integer;
                          Thresh   : Double); stdcall;

procedure nspsbAbs1(Vec : PFloat;  Len : Integer); stdcall;
procedure nspdbAbs1(Vec : PDouble; Len : Integer); stdcall;
procedure nspwbAbs1(Vec : PShort;  Len : Integer); stdcall;

procedure nspsbAbs2(Src, Dst : PFloat;  Len : Integer); stdcall;
procedure nspdbAbs2(Src, Dst : PDouble; Len : Integer); stdcall;
procedure nspwbAbs2(Src, Dst : PShort;  Len : Integer); stdcall;

function nspsMax(Vec            : PFloat;  Len : Integer) : Float;  stdcall;
function nspdMax(Vec            : PDouble; Len : Integer) : Double; stdcall;
function nspwMax(Vec            : PShort;  Len : Integer) : Short;  stdcall;

function nspsMin(Vec            : PFloat;  Len : Integer) : Float;  stdcall;
function nspdMin(Vec            : PDouble; Len : Integer) : Double; stdcall;
function nspwMin(Vec            : PShort;  Len : Integer) : Short;  stdcall;

function nspsMaxExt(Vec         : PFloat;  Len : Integer;
                var Index       : Integer)     : Float;             stdcall;
function nspdMaxExt(Vec         : PDouble; Len : Integer;
                var Index       : Integer)     : Double;            stdcall;
function nspwMaxExt(Vec         : PShort;  Len : Integer;
                var Index       : Integer)     : Short;             stdcall;
function nspsMinExt(Vec         : PFloat;  Len : Integer;
                var Index       : Integer)     : Float;             stdcall;
function nspdMinExt(Vec         : PDouble; Len : Integer;
                var Index       : Integer)     : Double;            stdcall;
function nspwMinExt(Vec         : PShort;  Len : Integer;
                var Index       : Integer)     : Short;             stdcall;

function nspsMean(Vec           : PFloat;  Len : Integer) : Float;  stdcall;
function nspdMean(Vec           : PDouble; Len : Integer) : Double; stdcall;
function nspwMean(Vec           : PShort;  Len : Integer) : Short;  stdcall;
function nspcMean(Vec : PSCplx; Len : Integer; var Mean : TSCplx) : NSPStatus; stdcall;
function nspzMean(Vec : PDCplx; Len : Integer; var Mean : TDCplx) : NSPStatus; stdcall;
function nspvMean(Vec : PWCplx; Len : Integer; var Mean : TWCplx) : NSPStatus; stdcall;

function nspsStdDev(Vec         : PFloat;  Len : Integer) : Float;  stdcall;
function nspdStdDev(Vec         : PDouble; Len : Integer) : Double; stdcall;
function nspwStdDev(Vec         : PShort;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer) : Short; stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspwin.h
Purpose: NSP Windowing Functions. Declaration
*)

{------------------------------------------------------------------------}
{                                                                        }
{   Win                                                                  }
{                                                                        }
{ Multiply a vector by a windowing function.                             }
{                                                                        }

procedure nspsWinBartlett(Vec : PFloat;  N : Integer); stdcall;
procedure nspcWinBartlett(Vec : PSCplx;  N : Integer); stdcall;
procedure nspdWinBartlett(Vec : PDouble; N : Integer); stdcall;
procedure nspzWinBartlett(Vec : PDCplx;  N : Integer); stdcall;
procedure nspwWinBartlett(Vec : PShort;  N : Integer); stdcall;
procedure nspvWinBartlett(Vec : PWCplx;  N : Integer); stdcall;

procedure nspsWinBartlett2(Src : PFloat; Dst  : PFloat;  N : Integer); stdcall;
procedure nspcWinBartlett2(Src : PSCplx; Dst  : PSCplx;  N : Integer); stdcall;
procedure nspdWinBartlett2(Src : PDouble; Dst : PDouble; N : Integer); stdcall;
procedure nspzWinBartlett2(Src : PDCplx; Dst  : PDCplx;  N : Integer); stdcall;
procedure nspwWinBartlett2(Src : PShort; Dst  : PShort;  N : Integer); stdcall;
procedure nspvWinBartlett2(Src : PWCplx; Dst  : PWCplx;  N : Integer); stdcall;

procedure nspsWinHann(Vec : PFloat;  N : Integer); stdcall;
procedure nspcWinHann(Vec : PSCplx;  N : Integer); stdcall;
procedure nspdWinHann(Vec : PDouble; N : Integer); stdcall;
procedure nspzWinHann(Vec : PDCplx;  N : Integer); stdcall;
procedure nspwWinHann(Vec : PShort;  N : Integer); stdcall;
procedure nspvWinHann(Vec : PWCplx;  N : Integer); stdcall;

procedure nspsWinHann2(Src : PFloat;  Dst : PFloat;  N : Integer); stdcall;
procedure nspcWinHann2(Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
procedure nspdWinHann2(Src : PDouble; Dst : PDouble; N : Integer); stdcall;
procedure nspzWinHann2(Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
procedure nspwWinHann2(Src : PShort;  Dst : PShort;  N : Integer); stdcall;
procedure nspvWinHann2(Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

procedure nspsWinHamming(Vec : PFloat;  N : Integer); stdcall;
procedure nspcWinHamming(Vec : PSCplx;  N : Integer); stdcall;
procedure nspdWinHamming(Vec : PDouble; N : Integer); stdcall;
procedure nspzWinHamming(Vec : PDCplx;  N : Integer); stdcall;
procedure nspwWinHamming(Vec : PShort;  N : Integer); stdcall;
procedure nspvWinHamming(Vec : PWCplx;  N : Integer); stdcall;

procedure nspsWinHamming2(Src : PFloat;  Dst : PFloat;  N : Integer); stdcall;
procedure nspcWinHamming2(Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
procedure nspdWinHamming2(Src : PDouble; Dst : PDouble; N : Integer); stdcall;
procedure nspzWinHamming2(Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
procedure nspwWinHamming2(Src : PShort;  Dst : PShort;  N : Integer); stdcall;
procedure nspvWinHamming2(Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

procedure nspsWinBlackman(Vec : PFloat;  N : Integer; Alpha : Float);  stdcall;
procedure nspcWinBlackman(Vec : PSCplx;  N : Integer; Alpha : Float);  stdcall;
procedure nspdWinBlackman(Vec : PDouble; N : Integer; Alpha : Double); stdcall;
procedure nspzWinBlackman(Vec : PDCplx;  N : Integer; Alpha : Double); stdcall;
procedure nspwWinBlackman(Vec : PShort;  N : Integer; Alpha : Float);  stdcall;
procedure nspvWinBlackman(Vec : PWCplx;  N : Integer; Alpha : Float);  stdcall;

procedure nspsWinBlackman2(Src : PFloat;  Dst : PFloat;  N : Integer; Alpha : Float);  stdcall;
procedure nspcWinBlackman2(Src : PSCplx;  Dst : PSCplx;  N : Integer; Alpha : Float);  stdcall;
procedure nspdWinBlackman2(Src : PDouble; Dst : PDouble; N : Integer; Alpha : Double); stdcall;
procedure nspzWinBlackman2(Src : PDCplx;  Dst : PDCplx;  N : Integer; Alpha : Double); stdcall;
procedure nspwWinBlackman2(Src : PShort;  Dst : PShort;  N : Integer; Alpha : Float);  stdcall;
procedure nspvWinBlackman2(Src : PWCplx;  Dst : PWCplx;  N : Integer; Alpha : Float);  stdcall;

procedure nspsWinBlackmanStd(Vec : PFloat;  N : Integer); stdcall;
procedure nspcWinBlackmanStd(Vec : PSCplx;  N : Integer); stdcall;
procedure nspdWinBlackmanStd(Vec : PDouble; N : Integer); stdcall;
procedure nspzWinBlackmanStd(Vec : PDCplx;  N : Integer); stdcall;
procedure nspwWinBlackmanStd(Vec : PShort;  N : Integer); stdcall;
procedure nspvWinBlackmanStd(Vec : PWCplx;  N : Integer); stdcall;

procedure nspsWinBlackmanStd2(Src : PFloat;  Dst : PFloat;  N : Integer); stdcall;
procedure nspcWinBlackmanStd2(Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
procedure nspdWinBlackmanStd2(Src : PDouble; Dst : PDouble; N : Integer); stdcall;
procedure nspzWinBlackmanStd2(Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
procedure nspwWinBlackmanStd2(Src : PShort;  Dst : PShort;  N : Integer); stdcall;
procedure nspvWinBlackmanStd2(Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

procedure nspsWinBlackmanOpt(Vec : PFloat;  N : Integer); stdcall;
procedure nspcWinBlackmanOpt(Vec : PSCplx;  N : Integer); stdcall;
procedure nspdWinBlackmanOpt(Vec : PDouble; N : Integer); stdcall;
procedure nspzWinBlackmanOpt(Vec : PDCplx;  N : Integer); stdcall;
procedure nspwWinBlackmanOpt(Vec : PShort;  N : Integer); stdcall;
procedure nspvWinBlackmanOpt(Vec : PWCplx;  N : Integer); stdcall;

procedure nspsWinBlackmanOpt2(Src : PFloat;  Dst : PFloat;  N : Integer); stdcall;
procedure nspcWinBlackmanOpt2(Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
procedure nspdWinBlackmanOpt2(Src : PDouble; Dst : PDouble; N : Integer); stdcall;
procedure nspzWinBlackmanOpt2(Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
procedure nspwWinBlackmanOpt2(Src : PShort;  Dst : PShort;  N : Integer); stdcall;
procedure nspvWinBlackmanOpt2(Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

procedure nspsWinKaiser(Vec : PFloat;  N : Integer; Beta : Float);  stdcall;
procedure nspcWinKaiser(Vec : PSCplx;  N : Integer; Beta : Float);  stdcall;
procedure nspdWinKaiser(Vec : PDouble; N : Integer; Beta : Double); stdcall;
procedure nspzWinKaiser(Vec : PDCplx;  N : Integer; Beta : Double); stdcall;
procedure nspwWinKaiser(Vec : PShort;  N : Integer; Beta : Float);  stdcall;
procedure nspvWinKaiser(Vec : PWCplx;  N : Integer; Beta : Float);  stdcall;

procedure nspsWinKaiser2(Src : PFloat;  Dst : PFloat;  N : Integer; Beta : Float);  stdcall;
procedure nspcWinKaiser2(Src : PSCplx;  Dst : PSCplx;  N : Integer; Beta : Float);  stdcall;
procedure nspdWinKaiser2(Src : PDouble; Dst : PDouble; N : Integer; Beta : Double); stdcall;
procedure nspzWinKaiser2(Src : PDCplx;  Dst : PDCplx;  N : Integer; Beta : Double); stdcall;
procedure nspwWinKaiser2(Src : PShort;  Dst : PShort;  N : Integer; Beta : Float);  stdcall;
procedure nspvWinKaiser2(Src : PWCplx;  Dst : PWCplx;  N : Integer; Beta : Float);  stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.

From:    nspwlt.h
Purpose: NSP wavelet transform.
*)

{-------------------------------------------------------------------------}
{ Structure for store all information needed to decompose and reconstruct }
{ of wavelet transform:                                                   }
{-------------------------------------------------------------------------}

type
  TIntArray4     = array [0..3] of Integer;
  TPtrArray4     = array [0..3] of Pointer;
  TPFloatArray4  = array [0..3] of PFloat;
  TPDoubleArray4 = array [0..3] of PDouble;

  TNSPWtState = record
    WtCore    : Integer;
    WtType    : Integer;
    WtOrtType : Integer;
    Par1      : Integer;
    Par2      : Integer;
    DataOrder : Integer;
    Level     : Integer;
    Len_Filt  : TIntArray4;
    Ofs_Filt  : TIntArray4;
    Tap_Filt  : TPtrArray4;
    Src_Pad   : Pointer;
    Len_Dec   : Integer;
    Tree      : array [0..32] of Integer;
  end;

{ wtCore  -  for calculation core (float, double or short) control       }

const
  NSP_WtCoreFloat  =  1;
  NSP_WtCoreDouble =  2;
  NSP_WtCoreShort  =  4;

{ wtType  -  the type of wavelet                                         }

  NSP_Haar         =  1;
  NSP_Daublet      =  2;
  NSP_Symmlet      =  3;
  NSP_Coiflet      =  4;
  NSP_Vaidyanathan =  5;
  NSP_BSpline      =  6;
  NSP_BSplineDual  =  7;
  NSP_LinSpline    =  8;
  NSP_QuadSpline   =  9;
  NSP_WtByFilter   = 10;

{ wtOrtType  -  the orthogonality type of wavelet for add. control       }

  NSP_WtOrtType    =  1;
  NSP_WtBiOrtType  =  2;
  NSP_WtOrtUnknown =  3;

{
  par1, par2   -  the parameters of wavelet,
                  dependent from the type of wavelet.
  NSP_Haar           par1 - dummy
                     par2 - dummy
  NSP_Daublet        par1 = 1,2,3,4,5,6,7,8,9,10.
                     par2 - dummy
  NSP_Symmlet        par1 = 1,2,3,4,5,6,7.
                     par2 - dummy
  NSP_Coiflet        par1 = 1,2,3,4,5.
                     par2 - dummy
  NSP_Vaidyanathan   par1 - dummy
                     par2 - dummy

  NSP_BSpline        B - spline,
  NSP_BSplineDual               (par1, par2) must be:
                     box -
                         ( 1, 1 ), ( 1, 3 ), ( 1, 5 );
                     lin. spline -
                         ( 2, 2 ), ( 2, 4 ), ( 2, 6 ), ( 2, 8 );
                     quad. spline -
                         ( 3, 1 ), ( 3, 3 ), ( 3, 5 ), ( 3, 7 ), ( 3, 9 ).

  NSP_LinSpline      (eq. case NSP_BSpline with par1=2, par2=2.)
                     par1 - dummy
                     par2 - dummy
  NSP_QuadSpline     (eq. case NSP_BSpline with par1=3, par2=3.)
                     par1 - dummy
                     par2 - dummy
}

{ dataOrder  -  the length of data  L = pow(2,dataOrder)                 }

{ level  -  determines the number of levels of decompositions we need.   }

{
  Filters
  len_filt[] - length
  ofs_filt[] - offset
  tap_filt[] - taps
               [ 0 ] - low  pass analysis  filter
               [ 1 ] - high pass analysis  filter
               [ 2 ] - low  pass synthesis filter
               [ 3 ] - high pass synthesis filter
  Must be
      2 <= len_filt[ i ] ,
      0 <= ofs_filt[ i ] < len_filt[ i ] ,
      i = 0, 1, 2, 3;
      len_filt[ 0 ] = len_filt[ 3 ] ,
      len_filt[ 1 ] = len_filt[ 2 ] .

  src_pad - working array
}

{------------------------------------------------------------------------}
{                                                                        }
{ Free own wavelet memory                                                }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspWtFree(var State : TNSPWtState); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                The initialization of the wavelet transform.            }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspsWtInit(Par1      : Integer;     Par2   : Integer;
                     DataOrder : Integer;     Level  : Integer;
                 var State     : TNSPWtState; WtType : Integer); stdcall;
procedure nspdWtInit(Par1      : Integer;     Par2   : Integer;
                     DataOrder : Integer;     Level  : Integer;
                 var State     : TNSPWtState; WtType : Integer); stdcall;
procedure nspwWtInit(Par1      : Integer;     Par2   : Integer;
                     DataOrder : Integer;     Level  : Integer;
                 var State     : TNSPWtState; WtType : Integer); stdcall;

procedure nspsWtInitLen(Par1    : Integer;     Par2   : Integer;
                        Len     : Integer;     Level  : Integer;
                    var State   : TNSPWtState; WtType : Integer;
                    var Len_Dec : Integer);                      stdcall;
procedure nspdWtInitLen(Par1    : Integer;     Par2   : Integer;
                        Len     : Integer;     Level  : Integer;
                    var State   : TNSPWtState; WtType : Integer;
                    var Len_Dec : Integer);                      stdcall;
procedure nspwWtInitLen(Par1    : Integer;     Par2   : Integer;
                        Len     : Integer;     Level  : Integer;
                    var State   : TNSPWtState; WtType : Integer;
                    var Len_Dec : Integer);                      stdcall;

function nspsWtInitUserFilter(Tap_Filt : TPFloatArray4;
                              Len_Filt : TIntArray4;
                              Ofs_Filt : TIntArray4;
                              Len      : Integer;
                              Level    : Integer;
                          var State    : TNSPWtState;
                          var Len_Dec  : Integer) : NSPStatus; stdcall;

function nspdWtInitUserFilter(Tap_Filt : TPDoubleArray4;
                              Len_Filt : TIntArray4;
                              Ofs_Filt : TIntArray4;
                              Len      : Integer;
                              Level    : Integer;
                          var State    : TNSPWtState;
                          var Len_Dec  : Integer) : NSPStatus; stdcall;

function nspwWtInitUserFilter(Tap_Filt : TPFloatArray4;
                              Len_Filt : TIntArray4;
                              Ofs_Filt : TIntArray4;
                              Len      : Integer;
                              Level    : Integer;
                          var State    : TNSPWtState;
                          var Len_Dec  : Integer) : NSPStatus; stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                      Set all parameters of wavelet.                    }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspsWtSetState(var State     : TNSPWtState;    WtType : Integer;
                             Par1      : Integer;        Par2   : Integer;
                             DataOrder : Integer;        Level  : Integer;
                             fTaps     : TPFloatArray4;  fLen   : TIntArray4;
                             fOffset   : TIntArray4);             stdcall;
procedure nspdWtSetState(var State     : TNSPWtState;    WtType : Integer;
                             Par1      : Integer;        Par2   : Integer;
                             DataOrder : Integer;        Level  : Integer;
                             fTaps     : TPDoubleArray4; fLen   : TIntArray4;
                             fOffset   : TIntArray4);             stdcall;
procedure nspwWtSetState(var State     : TNSPWtState;    WtType : Integer;
                             Par1      : Integer;        Par2   : Integer;
                             DataOrder : Integer;        Level  : Integer;
                             fTaps     : TPFloatArray4;  fLen   : TIntArray4;
                             fOffset   : TIntArray4);             stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                      Get all parameters of wavelet.                    }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspsWtGetState(var State     : TNSPWtState;    var WtType : Integer;
                         var Par1      : Integer;        var Par2   : Integer;
                         var DataOrder : Integer;        var Level  : Integer;
                         var fTaps     : TPFloatArray4;  var fLen   : TIntArray4;
                         var fOffset   : TIntArray4);                 stdcall;
procedure nspdWtGetState(var State     : TNSPWtState;    var WtType : Integer;
                         var Par1      : Integer;        var Par2   : Integer;
                         var DataOrder : Integer;        var Level  : Integer;
                         var fTaps     : TPDoubleArray4; var fLen   : TIntArray4;
                         var fOffset   : TIntArray4);                 stdcall;
procedure nspwWtGetState(var State     : TNSPWtState;    var WtType : Integer;
                         var Par1      : Integer;        var Par2   : Integer;
                         var DataOrder : Integer;        var Level  : Integer;
                         var fTaps     : TPFloatArray4;  var fLen   : TIntArray4;
                         var fOffset   : TIntArray4);                 stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                          Wavelet decomposition.                        }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspsWtDecompose(var State : TNSPWtState;
                              Src   : PFloat;
                              Dst   : PFloat);  stdcall;
procedure nspdWtDecompose(var State : TNSPWtState;
                              Src   : PDouble;
                              Dst   : PDouble); stdcall;
procedure nspwWtDecompose(var State : TNSPWtState;
                              Src   : PShort;
                              Dst   : PShort);  stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                         Wavelet reconstruction.                        }
{                                                                        }
{------------------------------------------------------------------------}

procedure nspsWtReconstruct(var State : TNSPWtState;
                                Src   : PFloat;
                                Dst   : PFloat);  stdcall;
procedure nspdWtReconstruct(var State : TNSPWtState;
                                Src   : PDouble;
                                Dst   : PDouble); stdcall;
procedure nspwWtReconstruct(var State : TNSPWtState;
                                Src   : PShort;
                                Dst   : PShort);  stdcall;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function nspMalloc;  external nspDLL;
function nspsMalloc; external nspDLL;
function nspdMalloc; external nspDLL;
function nspcMalloc; external nspDLL;
function nspzMalloc; external nspDLL;
function nspwMalloc; external nspDLL;
function nspvMalloc; external nspDLL;

procedure nspFree; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function nspcAdd(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcAddOut(A,B,Val);
  Result := Val;
end;

function nspcSub(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcSubOut(A,B,Val);
  Result := Val;
end;

function nspcMpy(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcMpyOut(A,B,Val);
  Result := Val;
end;

function nspcDiv(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcDivOut(A,B,Val);
  Result := Val;
end;

function nspcConj(A : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcConjOut(A,Val);
  Result := Val;
end;

procedure nspcAddOut;  external nspDLL;
procedure nspcSubOut;  external nspDLL;
procedure nspcMpyOut;  external nspDLL;
procedure nspcDivOut;  external nspDLL;
procedure nspcConjOut; external nspDLL;

function nspcSet(Re, Im : Float) : TSCplx;
var
  Val : TSCplx;
begin
  nspcSetOut(Re,Im,Val);
  Result := Val;
end;

procedure nspcSetOut; external nspDLL;

procedure nspsbZero; external nspDLL;
procedure nspcbZero; external nspDLL;
procedure nspsbSet;  external nspDLL;
procedure nspcbSet;  external nspDLL;
procedure nspsbCopy; external nspDLL;
procedure nspcbCopy; external nspDLL;

procedure nspsbAdd1; external nspDLL;
procedure nspcbAdd1; external nspDLL;
procedure nspsbAdd2; external nspDLL;
procedure nspcbAdd2; external nspDLL;
procedure nspsbAdd3; external nspDLL;
procedure nspcbAdd3; external nspDLL;
procedure nspsbSub1; external nspDLL;
procedure nspcbSub1; external nspDLL;
procedure nspsbSub2; external nspDLL;
procedure nspcbSub2; external nspDLL;
procedure nspsbSub3; external nspDLL;
procedure nspcbSub3; external nspDLL;
procedure nspsbMpy1; external nspDLL;
procedure nspcbMpy1; external nspDLL;
procedure nspsbMpy2; external nspDLL;
procedure nspcbMpy2; external nspDLL;
procedure nspsbMpy3; external nspDLL;
procedure nspcbMpy3; external nspDLL;

procedure nspcbConj1;       external nspDLL;
procedure nspcbConj2;       external nspDLL;
procedure nspcbConjFlip2;   external nspDLL;
procedure nspcbConjExtend1; external nspDLL;
procedure nspcbConjExtend2; external nspDLL;

function nspvAdd;   external nspDLL;
function nspvSub;   external nspDLL;
function nspvMpy;   external nspDLL;
function nspvDiv;   external nspDLL;
function nspvConj;  external nspDLL;
function nspvSet;   external nspDLL;

procedure nspwbZero; external nspDLL;
procedure nspvbZero; external nspDLL;
procedure nspwbSet;  external nspDLL;
procedure nspvbSet;  external nspDLL;
procedure nspwbCopy; external nspDLL;
procedure nspvbCopy; external nspDLL;

procedure nspwbAdd1; external nspDLL;
procedure nspvbAdd1; external nspDLL;
procedure nspwbAdd2; external nspDLL;
procedure nspvbAdd2; external nspDLL;
procedure nspwbAdd3; external nspDLL;
procedure nspvbAdd3; external nspDLL;
procedure nspwbSub1; external nspDLL;
procedure nspvbSub1; external nspDLL;
procedure nspwbSub2; external nspDLL;
procedure nspvbSub2; external nspDLL;
procedure nspwbSub3; external nspDLL;
procedure nspvbSub3; external nspDLL;
procedure nspwbMpy1; external nspDLL;
procedure nspvbMpy1; external nspDLL;
procedure nspwbMpy2; external nspDLL;
procedure nspvbMpy2; external nspDLL;
procedure nspwbMpy3; external nspDLL;
procedure nspvbMpy3; external nspDLL;

procedure nspvbConj1;       external nspDLL;
procedure nspvbConj2;       external nspDLL;
procedure nspvbConjFlip2;   external nspDLL;
procedure nspvbConjExtend1; external nspDLL;
procedure nspvbConjExtend2; external nspDLL;

function nspzAdd;              external nspDLL;
function nspzSub;              external nspDLL;
function nspzMpy;              external nspDLL;
function nspzDiv;              external nspDLL;
function nspzConj;             external nspDLL;

function nspzSet;              external nspDLL;

procedure nspdbZero;           external nspDLL;
procedure nspzbZero;           external nspDLL;

procedure nspdbSet;            external nspDLL;
procedure nspzbSet;            external nspDLL;

procedure nspdbCopy;           external nspDLL;
procedure nspzbCopy;           external nspDLL;

procedure nspdbAdd1;           external nspDLL;
procedure nspzbAdd1;           external nspDLL;

procedure nspdbAdd2;           external nspDLL;
procedure nspzbAdd2;           external nspDLL;

procedure nspdbAdd3;           external nspDLL;
procedure nspzbAdd3;           external nspDLL;

procedure nspdbSub1;           external nspDLL;
procedure nspzbSub1;           external nspDLL;

procedure nspdbSub2;           external nspDLL;
procedure nspzbSub2;           external nspDLL;

procedure nspdbSub3;           external nspDLL;
procedure nspzbSub3;           external nspDLL;

procedure nspdbMpy1;           external nspDLL;
procedure nspzbMpy1;           external nspDLL;

procedure nspdbMpy2;           external nspDLL;
procedure nspzbMpy2;           external nspDLL;

procedure nspdbMpy3;           external nspDLL;
procedure nspzbMpy3;           external nspDLL;

procedure nspzbConj1;          external nspDLL;
procedure nspzbConj2;          external nspDLL;
procedure nspzbConjFlip2;      external nspDLL;
procedure nspzbConjExtend1;    external nspDLL;
procedure nspzbConjExtend2;    external nspDLL;


{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1999 Intel Corporation. All Rights Reserved.
*)

procedure nspsbArctan1; external nspDLL;
procedure nspsbArctan2; external nspDLL;
procedure nspdbArctan1; external nspDLL;
procedure nspdbArctan2; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsConv2D; external nspDLL;
procedure nspdConv2D; external nspDLL;
procedure nspwConv2D; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsConv; external nspDLL;
procedure nspcConv; external nspDLL;
procedure nspdConv; external nspDLL;
procedure nspzConv; external nspDLL;
procedure nspwConv; external nspDll;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsAutoCorr;  external nspDLL;
procedure nspcAutoCorr;  external nspDLL;
procedure nspdAutoCorr;  external nspDLL;
procedure nspzAutoCorr;  external nspDLL;
procedure nspwAutoCorr;  external nspDLL;
procedure nspvAutoCorr;  external nspDLL;

procedure nspsCrossCorr; external nspDLL;
procedure nspcCrossCorr; external nspDLL;
procedure nspdCrossCorr; external nspDLL;
procedure nspzCrossCorr; external nspDLL;
procedure nspwCrossCorr; external nspDLL;
procedure nspvCrossCorr; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsbFloatToInt;      external nspDLL;
procedure nspdbFloatToInt;      external nspDLL;

procedure nspsbIntToFloat;      external nspDLL;
procedure nspdbIntToFloat;      external nspDLL;

procedure nspsbFloatToFix;      external nspDLL;
procedure nspdbFloatToFix;      external nspDLL;

procedure nspsbFixToFloat;      external nspDLL;
procedure nspdbFixToFloat;      external nspDLL;

procedure nspsbFloatToS31Fix;   external nspDLL;
procedure nspsbFloatToS15Fix;   external nspDLL;
procedure nspsbFloatToS7Fix;    external nspDLL;
procedure nspsbFloatToS1516Fix; external nspDLL;
procedure nspdbFloatToS31Fix;   external nspDLL;
procedure nspdbFloatToS15Fix;   external nspDLL;
procedure nspdbFloatToS7Fix;    external nspDLL;
procedure nspdbFloatToS1516Fix; external nspDLL;


procedure nspsbS31FixToFloat;   external nspDLL;
procedure nspsbS15FixToFloat;   external nspDLL;
procedure nspsbS7FixToFloat;    external nspDLL;
procedure nspsbS1516FixToFloat; external nspDLL;
procedure nspdbS31FixToFloat;   external nspDLL;
procedure nspdbS15FixToFloat;   external nspDLL;
procedure nspdbS7FixToFloat;    external nspDLL;
procedure nspdbS1516FixToFloat; external nspDLL;

procedure nspcbReal;            external nspDLL;
procedure nspzbReal;            external nspDLL;
procedure nspvbReal;            external nspDLL;

procedure nspcbImag;            external nspDLL;
procedure nspzbImag;            external nspDLL;
procedure nspvbImag;            external nspDLL;

procedure nspcbCplxTo2Real;     external nspDLL;
procedure nspzbCplxTo2Real;     external nspDLL;
procedure nspvbCplxTo2Real;     external nspDLL;

procedure nspcb2RealToCplx;     external nspDLL;
procedure nspzb2RealToCplx;     external nspDLL;
procedure nspvb2RealToCplx;     external nspDLL;

procedure nspcbCartToPolar;     external nspDLL;
procedure nspzbCartToPolar;     external nspDLL;

procedure nspsbrCartToPolar;    external nspDLL;
procedure nspdbrCartToPolar;    external nspDLL;

procedure nspcbPolarToCart;     external nspDLL;
procedure nspzbPolarToCart;     external nspDLL;

procedure nspsbrPolarToCart;    external nspDLL;
procedure nspdbrPolarToCart;    external nspDLL;

procedure nspcbMag;             external nspDLL;
procedure nspzbMag;             external nspDLL;
procedure nspvbMag;             external nspDLL;

procedure nspsbrMag;            external nspDLL;
procedure nspdbrMag;            external nspDLL;
procedure nspwbrMag;            external nspDLL;

procedure nspcbPhase;           external nspDLL;
procedure nspzbPhase;           external nspDLL;
procedure nspvbPhase;           external nspDLL;

procedure nspsbrPhase;          external nspDLL;
procedure nspdbrPhase;          external nspDLL;
procedure nspwbrPhase;          external nspDLL;

procedure nspcbPowerSpectr;     external nspDLL;
procedure nspzbPowerSpectr;     external nspDLL;
procedure nspvbPowerSpectr;     external nspDLL;

procedure nspsbrPowerSpectr;    external nspDLL;
procedure nspdbrPowerSpectr;    external nspDLL;
procedure nspwbrPowerSpectr;    external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsDct; external nspDLL;
procedure nspdDct; external nspDLL;
procedure nspwDct; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function nspsbDiv1;  external nspDLL;
function nspdbDiv1;  external nspDLL;
function nspwbDiv1;  external nspDLL;
function nspcbDiv1;  external nspDLL;
function nspzbDiv1;  external nspDLL;
function nspvbDiv1;  external nspDLL;

function nspsbDiv2;  external nspDLL;
function nspdbDiv2;  external nspDLL;
function nspwbDiv2;  external nspDLL;
function nspcbDiv2;  external nspDLL;
function nspzbDiv2;  external nspDLL;
function nspvbDiv2;  external nspDLL;

function nspsbDiv3;  external nspDLL;
function nspdbDiv3;  external nspDLL;
function nspwbDiv3;  external nspDLL;
function nspcbDiv3;  external nspDLL;
function nspzbDiv3;  external nspDLL;
function nspvbDiv3;  external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function nspsDotProd;            external nspDLL;

function nspcDotProd(SrcA, SrcB  : PSCplx; Len : Integer) : TSCplx;
var
  Val : TSCplx;
begin
  nspcDotProdOut(SrcA,SrcB,Len,Val);
  Result := Val;
end;

procedure nspcDotProdOut;        external nspDLL;
function nspdDotProd;            external nspDLL;
function nspzDotProd;            external nspDLL;
function nspwDotProd;            external nspDLL;
function nspvDotProd;            external nspDLL;

function nspwDotProdExt;         external nspDLL;

function nspvDotProdExt(SrcA, SrcB  : PWCplx; Len : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer) : TICplx;
var
  Val : TICplx;
begin
  nspvDotProdExtOut(SrcA,SrcB,Len,ScaleMode,ScaleFactor,Val);
  Result := Val;
end;

procedure nspvDotProdExtOut;     external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function  nspGetLibVersion; external nspDLL;
function  nspGetErrStatus;  external nspDLL;
procedure nspSetErrStatus;  external nspDLL;
function  nspGetErrMode;    external nspDLL;
procedure nspSetErrMode;    external nspDLL;
function  nspError;         external nspDLL;
function  nspErrorStr;      external nspDLL;
function  nspNulDevReport;  external nspDLL;
function  nspStdErrReport;  external nspDLL;
function  nspGuiBoxReport;  external nspDLL;
function  nspRedirectError; external nspDLL;
{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspvDft;         external nspDLL;
procedure nspcDft;         external nspDLL;
procedure nspzDft;         external nspDLL;

procedure nspvFft;         external nspDLL;
procedure nspcFft;         external nspDLL;
procedure nspzFft;         external nspDLL;

procedure nspvFftNip;      external nspDLL;
procedure nspcFftNip;      external nspDLL;
procedure nspzFftNip;      external nspDLL;

procedure nspvrFft;        external nspDLL;
procedure nspcrFft;        external nspDLL;
procedure nspzrFft;        external nspDLL;

procedure nspvrFftNip;     external nspDLL;
procedure nspcrFftNip;     external nspDLL;
procedure nspzrFftNip;     external nspDLL;

procedure nspwRealFftl;    external nspDLL;
procedure nspsRealFftl;    external nspDLL;
procedure nspdRealFftl;    external nspDLL;

procedure nspwRealFftlNip; external nspDLL;
procedure nspsRealFftlNip; external nspDLL;
procedure nspdRealFftlNip; external nspDLL;

procedure nspwCcsFftl;     external nspDLL;
procedure nspsCcsFftl;     external nspDLL;
procedure nspdCcsFftl;     external nspDLL;

procedure nspwCcsFftlNip;  external nspDLL;
procedure nspsCcsFftlNip;  external nspDLL;
procedure nspdCcsFftlNip;  external nspDLL;

procedure nspwMpyRCPack2;  external nspDLL;
procedure nspsMpyRCPack2;  external nspDLL;
procedure nspdMpyRCPack2;  external nspDLL;

procedure nspwMpyRCPack3;  external nspDLL;
procedure nspsMpyRCPack3;  external nspDLL;
procedure nspdMpyRCPack3;  external nspDLL;

procedure nspwMpyRCPerm2;  external nspDLL;
procedure nspsMpyRCPerm2;  external nspDLL;
procedure nspdMpyRCPerm2;  external nspDLL;

procedure nspwMpyRCPerm3;  external nspDLL;
procedure nspsMpyRCPerm3;  external nspDLL;
procedure nspdMpyRCPerm3;  external nspDLL;

procedure nspwRealFft;     external nspDLL;
procedure nspsRealFft;     external nspDLL;
procedure nspdRealFft;     external nspDLL;

procedure nspwRealFftNip;  external nspDLL;
procedure nspsRealFftNip;  external nspDLL;
procedure nspdRealFftNip;  external nspDLL;

procedure nspwCcsFft;      external nspDLL;
procedure nspsCcsFft;      external nspDLL;
procedure nspdCcsFft;      external nspDLL;

procedure nspwCcsFftNip;   external nspDLL;
procedure nspsCcsFftNip;   external nspDLL;
procedure nspdCcsFftNip;   external nspDLL;

procedure nspwReal2Fft;    external nspDLL;
procedure nspsReal2Fft;    external nspDLL;
procedure nspdReal2Fft;    external nspDLL;

procedure nspwReal2FftNip; external nspDLL;
procedure nspsReal2FftNip; external nspDLL;
procedure nspdReal2FftNip; external nspDLL;

procedure nspwCcs2Fft;     external nspDLL;
procedure nspsCcs2Fft;     external nspDLL;
procedure nspdCcs2Fft;     external nspDLL;

procedure nspwCcs2FftNip;  external nspDLL;
procedure nspsCcs2FftNip;  external nspDLL;
procedure nspdCcs2FftNip;  external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsFilter2D; external nspDLL;
procedure nspdFilter2D; external nspDLL;
procedure nspwFilter2D; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function nspdFirLowpass;  external nspDLL;
function nspdFirHighpass; external nspDLL;
function nspdFirBandpass; external nspDLL;
function nspdFirBandstop; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsFirInit;       external nspDLL;
procedure nspcFirInit;       external nspDLL;
procedure nspdFirInit;       external nspDLL;
procedure nspzFirInit;       external nspDLL;
procedure nspwFirInit;       external nspDLL;

procedure nspsFirInitMr;     external nspDLL;
procedure nspcFirInitMr;     external nspDLL;
procedure nspdFirInitMr;     external nspDLL;
procedure nspzFirInitMr;     external nspDLL;
procedure nspwFirInitMr;     external nspDLL;

procedure nspFirFree;        external nspDLL;

function nspsFir;            external nspDLL;

function nspcFir(var State : TNSPFirState; Samp : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcFirOut(State,Samp,Val);
  Result := Val;
end;

procedure nspcFirOut;        external nspDLL;

function nspdFir;            external nspDLL;
function nspzFir;            external nspDLL;

function nspwFir;            external nspDLL;

procedure nspsbFir;          external nspDLL;
procedure nspcbFir;          external nspDLL;

procedure nspdbFir;          external nspDLL;
procedure nspzbFir;          external nspDLL;

procedure nspwbFir;          external nspDLL;

procedure nspsFirGetTaps;    external nspDLL;
procedure nspcFirGetTaps;    external nspDLL;

procedure nspdFirGetTaps;    external nspDLL;
procedure nspzFirGetTaps;    external nspDLL;

procedure nspwFirGetTaps;    external nspDLL;

procedure nspsFirSetTaps;    external nspDLL;
procedure nspcFirSetTaps;    external nspDLL;

procedure nspdFirSetTaps;    external nspDLL;
procedure nspzFirSetTaps;    external nspDLL;

procedure nspwFirSetTaps;    external nspDLL;

procedure nspsFirGetDlyl;    external nspDLL;
procedure nspcFirGetDlyl;    external nspDLL;

procedure nspdFirGetDlyl;    external nspDLL;
procedure nspzFirGetDlyl;    external nspDLL;

procedure nspwFirGetDlyl;    external nspDLL;

procedure nspsFirSetDlyl;    external nspDLL;
procedure nspcFirSetDlyl;    external nspDLL;

procedure nspdFirSetDlyl;    external nspDLL;
procedure nspzFirSetDlyl;    external nspDLL;

procedure nspwFirSetDlyl;    external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsFirlInit;       external nspDLL;
procedure nspdFirlInit;       external nspDLL;
procedure nspcFirlInit;       external nspDLL;
procedure nspzFirlInit;       external nspDLL;
procedure nspwFirlInit;       external nspDLL;

procedure nspsFirlInitMr;     external nspDLL;
procedure nspdFirlInitMr;     external nspDLL;
procedure nspcFirlInitMr;     external nspDLL;
procedure nspzFirlInitMr;     external nspDLL;
procedure nspwFirlInitMr;     external nspDLL;

procedure nspsFirlInitDlyl;   external nspDLL;
procedure nspcFirlInitDlyl;   external nspDLL;
procedure nspdFirlInitDlyl;   external nspDLL;
procedure nspzFirlInitDlyl;   external nspDLL;
procedure nspwFirlInitDlyl;   external nspDLL;

function nspsFirl;            external nspDLL;
function nspcFirl(var TapSt : TNSPFirTapState;
                  var DlySt : TNSPFirDlyState;
                      Samp  : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcFirlOut(TapSt,DlySt,Samp,Val);
  Result := Val;
end;

procedure nspcFirlOut;        external nspDLL;
function nspdFirl;            external nspDLL;
function nspzFirl;            external nspDLL;
function nspwFirl;            external nspDLL;

procedure nspsbFirl;          external nspDLL;
procedure nspcbFirl;          external nspDLL;
procedure nspdbFirl;          external nspDLL;
procedure nspzbFirl;          external nspDLL;
procedure nspwbFirl;          external nspDLL;

procedure nspsFirlGetTaps;    external nspDLL;
procedure nspcFirlGetTaps;    external nspDLL;
procedure nspdFirlGetTaps;    external nspDLL;
procedure nspzFirlGetTaps;    external nspDLL;
procedure nspwFirlGetTaps;    external nspDLL;

procedure nspsFirlSetTaps;    external nspDLL;
procedure nspcFirlSetTaps;    external nspDLL;
procedure nspdFirlSetTaps;    external nspDLL;
procedure nspzFirlSetTaps;    external nspDLL;
procedure nspwFirlSetTaps;    external nspDLL;

procedure nspsFirlGetDlyl;    external nspDLL;
procedure nspcFirlGetDlyl;    external nspDLL;
procedure nspdFirlGetDlyl;    external nspDLL;
procedure nspzFirlGetDlyl;    external nspDLL;
procedure nspwFirlGetDlyl;    external nspDLL;

procedure nspsFirlSetDlyl;    external nspDLL;
procedure nspcFirlSetDlyl;    external nspDLL;
procedure nspdFirlSetDlyl;    external nspDLL;
procedure nspzFirlSetDlyl;    external nspDLL;
procedure nspwFirlSetDlyl;    external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsGoertzInit;  external nspDLL;
procedure nspcGoertzInit;  external nspDLL;
procedure nspdGoertzInit;  external nspDLL;
procedure nspzGoertzInit;  external nspDLL;
procedure nspwGoertzInit;  external nspDLL;
procedure nspvGoertzInit;  external nspDLL;

procedure nspsGoertzReset; external nspDLL;
procedure nspcGoertzReset; external nspDLL;
procedure nspdGoertzReset; external nspDLL;
procedure nspzGoertzReset; external nspDLL;
procedure nspwGoertzReset; external nspDLL;
procedure nspvGoertzReset; external nspDLL;

function nspsGoertz(var State  : TNSPSGoertzState;
                        Sample : Float) : TSCplx;
var
  Val : TSCplx;
begin
  nspsGoertzOut(State,Sample,Val);
  Result := Val;
end;

function nspcGoertz(var State  : TNSPCGoertzState;
                        Sample : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcGoertzOut(State,Sample,Val);
  Result := Val;
end;

function nspdGoertz; external nspDLL;
function nspzGoertz; external nspDLL;
function nspwGoertz; external nspDLL;
function nspvGoertz; external nspDLL;

function nspsbGoertz(var State   : TNSPSGoertzState;
                         InSamps : PFloat;
                         Len     : Integer) : TSCplx;
var
  Val : TSCplx;
begin
  nspsbGoertzOut(State,InSamps,Len,Val);
  Result := Val;
end;

function nspcbGoertz(var State   : TNSPCGoertzState;
                         InSamps : PSCplx;
                         Len     : Integer) : TSCplx;
var
  Val : TSCplx;
begin
  nspcbGoertzOut(State,InSamps,Len,Val);
  Result := Val;
end;

function nspdbGoertz; external nspDLL;
function nspzbGoertz; external nspDLL;
function nspwbGoertz; external nspDLL;
function nspvbGoertz; external nspDLL;

procedure nspsGoertzOut;  external nspDLL;
procedure nspcGoertzOut;  external nspDLL;
procedure nspsbGoertzOut; external nspDLL;
procedure nspcbGoertzOut; external nspDLL;
{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsIirInit;       external nspDLL;
procedure nspcIirInit;       external nspDLL;
procedure nspdIirInit;       external nspDLL;
procedure nspzIirInit;       external nspDLL;
procedure nspwIirInit;       external nspDLL;
procedure nspwIirInitGain;   external nspDLL;

procedure nspsIirInitBq;     external nspDLL;
procedure nspcIirInitBq;     external nspDLL;
procedure nspdIirInitBq;     external nspDLL;
procedure nspzIirInitBq;     external nspDLL;
procedure nspwIirInitBq;     external nspDLL;

procedure nspIirFree;        external nspDLL;

function nspsIir;            external nspDLL;
function nspcIir(var State       : TNSPIirState;
                     Samp        : TSCplx)  : TSCplx;
var
  Val : TSCplx;
begin
  nspcIirOut(State,Samp,Val);
  Result := Val;
end;

function nspdIir;            external nspDLL;
function nspzIir;            external nspDLL;
function nspwIir;            external nspDLL;
procedure nspcIirOut;        external nspDLL;

procedure nspsbIir;          external nspDLL;
procedure nspcbIir;          external nspDLL;
procedure nspdbIir;          external nspDLL;
procedure nspzbIir;          external nspDLL;
procedure nspwbIir;          external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspwIirlInit;     external nspDLL;
procedure nspsIirlInit;     external nspDLL;
procedure nspcIirlInit;     external nspDLL;
procedure nspdIirlInit;     external nspDLL;
procedure nspzIirlInit;     external nspDLL;
procedure nspwIirlInitGain; external nspDLL;

procedure nspwIirlInitBq;   external nspDLL;
procedure nspsIirlInitBq;   external nspDLL;
procedure nspcIirlInitBq;   external nspDLL;
procedure nspdIirlInitBq;   external nspDLL;
procedure nspzIirlInitBq;   external nspDLL;

procedure nspwIirlInitDlyl; external nspDLL;
procedure nspsIirlInitDlyl; external nspDLL;
procedure nspcIirlInitDlyl; external nspDLL;
procedure nspdIirlInitDlyl; external nspDLL;
procedure nspzIirlInitDlyl; external nspDLL;

function nspwIirl;          external nspDLL;
function nspsIirl;          external nspDLL;
function nspcIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : TSCplx)  : TSCplx;
var
  Val : TSCplx;
begin
  nspcIirlOut(TapState,DlyState,Samp,Val);
  Result := Val;
end;

function nspdIirl;          external nspDLL;
function nspzIirl;          external nspDLL;
procedure nspcIirlOut;      external nspDLL;

procedure nspwbIirl;         external nspDLL;
procedure nspsbIirl;         external nspDLL;
procedure nspcbIirl;         external nspDLL;
procedure nspdbIirl;         external nspDLL;
procedure nspzbIirl;         external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspwbLinToALaw;  external nspDLL;
procedure nspsbLinToALaw;  external nspDLL;
procedure nspdbLinToALaw;  external nspDLL;

procedure nspwbALawToLin;  external nspDLL;
procedure nspsbALawToLin;  external nspDLL;
procedure nspdbALawToLin;  external nspDLL;

procedure nspwbLinToMuLaw; external nspDLL;
procedure nspsbLinToMuLaw; external nspDLL;
procedure nspdbLinToMuLaw; external nspDLL;

procedure nspwbMuLawToLin; external nspDLL;
procedure nspsbMuLawToLin; external nspDLL;
procedure nspdbMuLawToLin; external nspDLL;

procedure nspMuLawToALaw;  external nspDLL;
procedure nspALawToMuLaw;  external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsLmsInit;       external nspDLL;
procedure nspdLmsInit;       external nspDLL;
procedure nspcLmsInit;       external nspDLL;
procedure nspzLmsInit;       external nspDLL;

procedure nspsLmsInitMr;     external nspDLL;
procedure nspdLmsInitMr;     external nspDLL;
procedure nspcLmsInitMr;     external nspDLL;
procedure nspzLmsInitMr;     external nspDLL;

procedure nspLmsFree;        external nspDLL;

function nspsLms;            external nspDLL;
function nspdLms;            external nspDLL;
function nspcLms(var State : TNSPLmsState; Samp : TSCplx;
                     Err   : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmsOut(State,Samp,Err,Val);
  Result := Val;
end;

function nspzLms;            external nspDLL;

function nspsbLms;            external nspDLL;
function nspdbLms;            external nspDLL;
function nspcbLms(var State : TNSPLmsState; InSamps  : PSCplx;
                      Err   : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcbLmsOut(State,InSamps,Err,Val);
  Result := Val;
end;

function nspzbLms;            external nspDLL;

procedure nspsLmsGetTaps;       external nspDLL;
procedure nspdLmsGetTaps;       external nspDLL;
procedure nspcLmsGetTaps;       external nspDLL;
procedure nspzLmsGetTaps;       external nspDLL;

procedure nspsLmsSetTaps;       external nspDLL;
procedure nspdLmsSetTaps;       external nspDLL;
procedure nspcLmsSetTaps;       external nspDLL;
procedure nspzLmsSetTaps;       external nspDLL;

procedure nspsLmsGetDlyl;       external nspDLL;
procedure nspdLmsGetDlyl;       external nspDLL;
procedure nspcLmsGetDlyl;       external nspDLL;
procedure nspzLmsGetDlyl;       external nspDLL;

procedure nspsLmsSetDlyl;       external nspDLL;
procedure nspdLmsSetDlyl;       external nspDLL;
procedure nspcLmsSetDlyl;       external nspDLL;
procedure nspzLmsSetDlyl;       external nspDLL;

function  nspsLmsGetStep;       external nspDLL;
function  nspsLmsGetLeak;       external nspDLL;

procedure nspsLmsSetStep;       external nspDLL;
procedure nspsLmsSetLeak;       external nspDLL;

function nspsLmsDes;            external nspDLL;
function nspdLmsDes;            external nspDLL;
function nspcLmsDes(var State : TNSPLmsState; Samp : TSCplx;
                        Des   : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmsDesOut(State,Samp,Des,Val);
  Result := Val;
end;

function nspzLmsDes;            external nspDLL;

procedure nspsbLmsDes;                external nspDLL;
procedure nspdbLmsDes;                external nspDLL;
procedure nspcbLmsDes;                external nspDLL;
procedure nspzbLmsDes;                external nspDLL;

function nspsLmsGetErrVal;            external nspDLL;
function nspdLmsGetErrVal;            external nspDLL;
function nspcLmsGetErrVal(const State : TNSPLmsState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmsGetErrValOut(State,Val);
  Result := Val;
end;

function nspzLmsGetErrVal;            external nspDLL;

procedure nspsLmsSetErrVal;            external nspDLL;
procedure nspdLmsSetErrVal;            external nspDLL;
procedure nspcLmsSetErrVal;            external nspDLL;
procedure nspzLmsSetErrVal;            external nspDLL;

procedure nspcLmsOut;                  external nspDLL;
procedure nspcbLmsOut;                 external nspDLL;
procedure nspcLmsDesOut;               external nspDLL;
procedure nspcLmsGetErrValOut;         external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsLmslInit;       external nspDLL;
procedure nspdLmslInit;       external nspDLL;
procedure nspcLmslInit;       external nspDLL;
procedure nspzLmslInit;       external nspDLL;

procedure nspsLmslInitMr;     external nspDLL;
procedure nspdLmslInitMr;     external nspDLL;
procedure nspcLmslInitMr;     external nspDLL;
procedure nspzLmslInitMr;     external nspDLL;

procedure nspsLmslInitDlyl;   external nspDLL;
procedure nspdLmslInitDlyl;   external nspDLL;
procedure nspcLmslInitDlyl;   external nspDLL;
procedure nspzLmslInitDlyl;   external nspDLL;

function nspsLmslGetStep;     external nspDLL;
function nspsLmslGetLeak;     external nspDLL;

procedure nspsLmslSetStep;    external nspDLL;
procedure nspsLmslSetLeak;    external nspDLL;

function nspsLmsl;            external nspDLL;
function nspcLmsl(var TapSt : TNSPLmsTapState;
                  var DlySt : TNSPLmsDlyState;
                      Samp  : TSCplx; Err : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmslOut(TapSt,DlySt,Samp,Err,Val);
  Result := Val;
end;
function nspdLmsl;            external nspDLL;
function nspzLmsl;            external nspDLL;
procedure nspcLmslOut;        external nspDLL;

function nspsbLmsl;            external nspDLL;
function nspcbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PSCplx; Err : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcbLmslOut(TapSt,DlySt,InSamps,Err,Val);
  Result := Val;
end;
function nspdbLmsl;            external nspDLL;
function nspzbLmsl;            external nspDLL;
procedure nspcbLmslOut;        external nspDLL;

function nspsLmslNa;            external nspDLL;
function nspcLmslNa(const TapSt : TNSPLmsTapState;
                    var   DlySt : TNSPLmsDlyState;
                          Samp  : TSCplx) : TSCplx; stdcall;
var
  Val : TSCplx;
begin
  nspcLmslNaOut(TapSt,DlySt,Samp,Val);
  Result := Val;
end;
function nspdLmslNa;            external nspDLL;
function nspzLmslNa;            external nspDLL;
procedure nspcLmslNaOut;        external nspDLL;

procedure nspsbLmslNa;      external nspDLL;
procedure nspcbLmslNa;      external nspDLL;
procedure nspdbLmslNa;      external nspDLL;
procedure nspzbLmslNa;      external nspDLL;

procedure nspsLmslGetTaps;  external nspDLL;
procedure nspcLmslGetTaps;  external nspDLL;
procedure nspdLmslGetTaps;  external nspDLL;
procedure nspzLmslGetTaps;  external nspDLL;

procedure nspsLmslSetTaps;  external nspDLL;
procedure nspcLmslSetTaps;  external nspDLL;
procedure nspdLmslSetTaps;  external nspDLL;
procedure nspzLmslSetTaps;  external nspDLL;

procedure nspsLmslGetDlyl;  external nspDLL;
procedure nspcLmslGetDlyl;  external nspDLL;
procedure nspdLmslGetDlyl;  external nspDLL;
procedure nspzLmslGetDlyl;  external nspDLL;

procedure nspsLmslSetDlyl;  external nspDLL;
procedure nspcLmslSetDlyl;  external nspDLL;
procedure nspdLmslSetDlyl;  external nspDLL;
procedure nspzLmslSetDlyl;  external nspDLL;

procedure nspwLmslInitDlyl; external nspDLL;

procedure nspwLmslSetDlyl;  external nspDLL;

procedure nspwLmslGetDlyl;  external nspDLL;

procedure nspwLmslInit;     external nspDLL;

procedure nspwLmslSetTaps;  external nspDLL;

procedure nspwLmslGetTaps;  external nspDLL;

function nspwLmsl;          external nspDLL;

function  nspwLmslGetStep;  external nspDLL;
procedure nspwLmslSetStep;  external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsbLn1;  external nspDLL;
procedure nspsbLn2;  external nspDLL;
procedure nspsbExp1; external nspDLL;
procedure nspsbExp2; external nspDLL;

procedure nspdbLn1;  external nspDLL;
procedure nspdbLn2;  external nspDLL;
procedure nspdbExp1; external nspDLL;
procedure nspdbExp2; external nspDLL;

procedure nspwbLn1;  external nspDLL;
procedure nspwbLn2;  external nspDLL;
procedure nspwbExp1; external nspDLL;
procedure nspwbExp2; external nspDLL;

procedure nspsbLg1;  external nspDLL;
procedure nspsbLg2;  external nspDLL;
procedure nspdbLg1;  external nspDLL;
procedure nspdbLg2;  external nspDLL;
procedure nspcbLg1;  external nspDLL;
procedure nspcbLg2;  external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspwbShiftL; external nspDLL;
procedure nspwbShiftR; external nspDLL;

procedure nspwbAnd1;   external nspDLL;
procedure nspwbAnd2;   external nspDLL;
procedure nspwbAnd3;   external nspDLL;

procedure nspwbXor1;   external nspDLL;
procedure nspwbXor2;   external nspDLL;
procedure nspwbXor3;   external nspDLL;

procedure nspwbOr1;    external nspDLL;
procedure nspwbOr2;    external nspDLL;
procedure nspwbOr3;    external nspDLL;

procedure nspwbNot;    external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsbMedianFilter1; external nspDLL;
procedure nspdbMedianFilter1; external nspDLL;
procedure nspwbMedianFilter1; external nspDLL;

procedure nspsbMedianFilter2; external nspDLL;
procedure nspdbMedianFilter2; external nspDLL;
procedure nspwbMedianFilter2; external nspDLL;
{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function  nspBitRev;         external nspDLL;
function  nspGetBitRevTbl;   external nspDLL;
procedure nspCalcBitRevTbl;  external nspDLL;
procedure nspFreeBitRevTbls; external nspDLL;

procedure nspwbBitRev1;      external nspDLL;
procedure nspvbBitRev1;      external nspDLL;
procedure nspsbBitRev1;      external nspDLL;
procedure nspcbBitRev1;      external nspDLL;
procedure nspdbBitRev1;      external nspDLL;
procedure nspzbBitRev1;      external nspDLL;

procedure nspwbBitRev2;      external nspDLL;
procedure nspvbBitRev2;      external nspDLL;
procedure nspsbBitRev2;      external nspDLL;
procedure nspcbBitRev2;      external nspDLL;
procedure nspdbBitRev2;      external nspDLL;
procedure nspzbBitRev2;      external nspDLL;

procedure nspvCalcDftTwdTbl; external nspDLL;
procedure nspvCalcFftTwdTbl; external nspDLL;
procedure nspcCalcDftTwdTbl; external nspDLL;
procedure nspcCalcFftTwdTbl; external nspDLL;
procedure nspzCalcDftTwdTbl; external nspDLL;
procedure nspzCalcFftTwdTbl; external nspDLL;

function nspvGetDftTwdTbl;   external nspDLL;
function nspvGetFftTwdTbl;   external nspDLL;
function nspcGetDftTwdTbl;   external nspDLL;
function nspcGetFftTwdTbl;   external nspDLL;
function nspzGetDftTwdTbl;   external nspDLL;
function nspzGetFftTwdTbl;   external nspDLL;

procedure nspvFreeTwdTbls;   external nspDLL;
procedure nspcFreeTwdTbls;   external nspDLL;
procedure nspzFreeTwdTbls;   external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

function nspsNorm;        external nspDLL;
function nspcNorm;        external nspDLL;
function nspdNorm;        external nspDLL;
function nspzNorm;        external nspDLL;
function nspwNorm;        external nspDLL;
function nspvNorm;        external nspDLL;

function nspwNormExt;     external nspDLL;
function nspvNormExt;     external nspDLL;

procedure nspsbNormalize; external nspDLL;
procedure nspcbNormalize; external nspDLL;
procedure nspdbNormalize; external nspDLL;
procedure nspzbNormalize; external nspDLL;
procedure nspwbNormalize; external nspDLL;
procedure nspvbNormalize; external nspDLL;

function nspsSum;         external nspDLL;
function nspdSum;         external nspDLL;
function nspcSum;         external nspDLL;
function nspzSum;         external nspDLL;
function nspwSum;         external nspDLL;
{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsRandUniInit; external nspDLL;
procedure nspcRandUniInit; external nspDLL;
procedure nspdRandUniInit; external nspDLL;
procedure nspzRandUniInit; external nspDLL;
procedure nspwRandUniInit; external nspDLL;
procedure nspvRandUniInit; external nspDLL;

function  nspsRandUni;            external nspDLL;
function  nspcRandUni(var State : TNSPCRandUniState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcRandUniOut(State,Val);
  Result := Val;
end;
function  nspdRandUni;    external nspDLL;
function  nspzRandUni;    external nspDLL;
function  nspwRandUni;    external nspDLL;
function  nspvRandUni;    external nspDLL;
procedure nspcRandUniOut; external nspDLL;

procedure nspsbRandUni; external nspDLL;
procedure nspcbRandUni; external nspDLL;
procedure nspdbRandUni; external nspDLL;
procedure nspzbRandUni; external nspDLL;
procedure nspwbRandUni; external nspDLL;
procedure nspvbRandUni; external nspDLL;

procedure nspsRandGausInit; external nspDLL;
procedure nspcRandGausInit; external nspDLL;
procedure nspdRandGausInit; external nspDLL;
procedure nspzRandGausInit; external nspDLL;
procedure nspwRandGausInit; external nspDLL;
procedure nspvRandGausInit; external nspDLL;

function nspsRandGaus;            external nspDLL;
function nspcRandGaus(var State : TNSPCRandGausState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcRandGausOut(State,Val);
  Result := Val;
end;
function nspdRandGaus;     external nspDLL;
function nspzRandGaus;     external nspDLL;
function nspwRandGaus;     external nspDLL;
function nspvRandGaus;     external nspDLL;
procedure nspcRandGausOut; external nspDLL;

procedure nspsbRandGaus; external nspDLL;
procedure nspcbRandGaus; external nspDLL;
procedure nspdbRandGaus; external nspDLL;
procedure nspzbRandGaus; external nspDLL;
procedure nspwbRandGaus; external nspDLL;
procedure nspvbRandGaus; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1999 Intel Corporation. All Rights Reserved.
*)

function nspsSampInit; external nspDLL;
function nspdSampInit; external nspDLL;

function nspsSamp;     external nspDLL;
function nspdSamp;     external nspDLL;

procedure nspSampFree; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsUpSample;   external nspDLL;
procedure nspcUpSample;   external nspDLL;
procedure nspdUpSample;   external nspDLL;
procedure nspzUpSample;   external nspDLL;
procedure nspwUpSample;   external nspDLL;
procedure nspvUpSample;   external nspDLL;

procedure nspsDownSample; external nspDLL;
procedure nspcDownSample; external nspDLL;
procedure nspdDownSample; external nspDLL;
procedure nspzDownSample; external nspDLL;
procedure nspwDownSample; external nspDLL;
procedure nspvDownSample; external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspwToneInit;       external nspDLL;
procedure nspvToneInit;       external nspDLL;
procedure nspsToneInit;       external nspDLL;
procedure nspcToneInit;       external nspDLL;
procedure nspdToneInit;       external nspDLL;
procedure nspzToneInit;       external nspDLL;

function nspwTone;            external nspDLL;
function nspvTone;            external nspDLL;
function nspsTone;            external nspDLL;
function nspcTone(var State : TNSPCToneState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcToneOut(State,Val);
  Result := Val;
end;
function nspdTone;            external nspDLL;
function nspzTone;            external nspDLL;
procedure nspcToneOut;        external nspDLL;

procedure nspwbTone;          external nspDLL;
procedure nspvbTone;          external nspDLL;
procedure nspsbTone;          external nspDLL;
procedure nspcbTone;          external nspDLL;
procedure nspdbTone;          external nspDLL;
procedure nspzbTone;          external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspwTrnglInit; external nspDLL;
procedure nspvTrnglInit; external nspDLL;
procedure nspsTrnglInit; external nspDLL;
procedure nspcTrnglInit; external nspDLL;
procedure nspdTrnglInit; external nspDLL;
procedure nspzTrnglInit; external nspDLL;

function nspwTrngl;      external nspDLL;
function nspvTrngl;      external nspDLL;
function nspsTrngl;      external nspDLL;
function nspcTrngl(var State : TNSPCTrnglState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcTrnglOut(State,Val);
  Result := Val;
end;
function nspdTrngl;      external nspDLL;
function nspzTrngl;      external nspDLL;
procedure nspcTrnglOut;  external nspDLL;

procedure nspwbTrngl; external nspDll;
procedure nspvbTrngl; external nspDll;
procedure nspsbTrngl; external nspDll;
procedure nspcbTrngl; external nspDll;
procedure nspdbTrngl; external nspDll;
procedure nspzbTrngl; external nspDll;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsbSqr1;       external nspDLL;
procedure nspcbSqr1;       external nspDLL;
procedure nspdbSqr1;       external nspDLL;
procedure nspzbSqr1;       external nspDLL;
procedure nspwbSqr1;       external nspDLL;
procedure nspvbSqr1;       external nspDLL;

procedure nspsbSqr2;       external nspDLL;
procedure nspcbSqr2;       external nspDLL;
procedure nspdbSqr2;       external nspDLL;
procedure nspzbSqr2;       external nspDLL;
procedure nspwbSqr2;       external nspDLL;
procedure nspvbSqr2;       external nspDLL;

procedure nspsbSqrt1;      external nspDLL;
procedure nspcbSqrt1;      external nspDLL;
procedure nspdbSqrt1;      external nspDLL;
procedure nspzbSqrt1;      external nspDLL;
procedure nspwbSqrt1;      external nspDLL;
procedure nspvbSqrt1;      external nspDLL;

procedure nspsbSqrt2;      external nspDLL;
procedure nspcbSqrt2;      external nspDLL;
procedure nspdbSqrt2;      external nspDLL;
procedure nspzbSqrt2;      external nspDLL;
procedure nspwbSqrt2;      external nspDLL;
procedure nspvbSqrt2;      external nspDLL;

procedure nspsbThresh1;    external nspDLL;
procedure nspcbThresh1;    external nspDLL;
procedure nspdbThresh1;    external nspDLL;
procedure nspzbThresh1;    external nspDLL;
procedure nspwbThresh1;    external nspDLL;
procedure nspvbThresh1;    external nspDLL;

procedure nspsbThresh2;    external nspDLL;
procedure nspcbThresh2;    external nspDLL;
procedure nspdbThresh2;    external nspDLL;
procedure nspzbThresh2;    external nspDLL;
procedure nspwbThresh2;    external nspDLL;
procedure nspvbThresh2;    external nspDLL;

procedure nspsbInvThresh1; external nspDLL;
procedure nspcbInvThresh1; external nspDLL;
procedure nspdbInvThresh1; external nspDLL;
procedure nspzbInvThresh1; external nspDLL;

procedure nspsbInvThresh2; external nspDLL;
procedure nspcbInvThresh2; external nspDLL;
procedure nspdbInvThresh2; external nspDLL;
procedure nspzbInvThresh2; external nspDLL;

procedure nspsbAbs1;       external nspDLL;
procedure nspdbAbs1;       external nspDLL;
procedure nspwbAbs1;       external nspDLL;

procedure nspsbAbs2;       external nspDLL;
procedure nspdbAbs2;       external nspDLL;
procedure nspwbAbs2;       external nspDLL;

function nspsMax;          external nspDLL;
function nspdMax;          external nspDLL;
function nspwMax;          external nspDLL;

function nspsMin;          external nspDLL;
function nspdMin;          external nspDLL;
function nspwMin;          external nspDLL;

function nspsMaxExt;       external nspDLL;
function nspdMaxExt;       external nspDLL;
function nspwMaxExt;       external nspDLL;
function nspsMinExt;       external nspDLL;
function nspdMinExt;       external nspDLL;
function nspwMinExt;       external nspDLL;

function nspsMean;         external nspDLL;
function nspdMean;         external nspDLL;
function nspwMean;         external nspDLL;
function nspcMean;         external nspDLL;
function nspzMean;         external nspDLL;
function nspvMean;         external nspDLL;

function nspsStdDev;       external nspDLL;
function nspdStdDev;       external nspDLL;
function nspwStdDev;       external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspsWinBartlett;    external nspDLL;
procedure nspcWinBartlett;    external nspDLL;
procedure nspdWinBartlett;    external nspDLL;
procedure nspzWinBartlett;    external nspDLL;
procedure nspwWinBartlett;    external nspDLL;
procedure nspvWinBartlett;    external nspDLL;

procedure nspsWinBartlett2;   external nspDLL;
procedure nspcWinBartlett2;   external nspDLL;
procedure nspdWinBartlett2;   external nspDLL;
procedure nspzWinBartlett2;   external nspDLL;
procedure nspwWinBartlett2;   external nspDLL;
procedure nspvWinBartlett2;   external nspDLL;

procedure nspsWinHann;        external nspDLL;
procedure nspcWinHann;        external nspDLL;
procedure nspdWinHann;        external nspDLL;
procedure nspzWinHann;        external nspDLL;
procedure nspwWinHann;        external nspDLL;
procedure nspvWinHann;        external nspDLL;

procedure nspsWinHann2;       external nspDLL;
procedure nspcWinHann2;       external nspDLL;
procedure nspdWinHann2;       external nspDLL;
procedure nspzWinHann2;       external nspDLL;
procedure nspwWinHann2;       external nspDLL;
procedure nspvWinHann2;       external nspDLL;

procedure nspsWinHamming;     external nspDLL;
procedure nspcWinHamming;     external nspDLL;
procedure nspdWinHamming;     external nspDLL;
procedure nspzWinHamming;     external nspDLL;
procedure nspwWinHamming;     external nspDLL;
procedure nspvWinHamming;     external nspDLL;

procedure nspsWinHamming2;    external nspDLL;
procedure nspcWinHamming2;    external nspDLL;
procedure nspdWinHamming2;    external nspDLL;
procedure nspzWinHamming2;    external nspDLL;
procedure nspwWinHamming2;    external nspDLL;
procedure nspvWinHamming2;    external nspDLL;

procedure nspsWinBlackman;    external nspDLL;
procedure nspcWinBlackman;    external nspDLL;
procedure nspdWinBlackman;    external nspDLL;
procedure nspzWinBlackman;    external nspDLL;
procedure nspwWinBlackman;    external nspDLL;
procedure nspvWinBlackman;    external nspDLL;

procedure nspsWinBlackman2;   external nspDLL;
procedure nspcWinBlackman2;   external nspDLL;
procedure nspdWinBlackman2;   external nspDLL;
procedure nspzWinBlackman2;   external nspDLL;
procedure nspwWinBlackman2;   external nspDLL;
procedure nspvWinBlackman2;   external nspDLL;

procedure nspsWinBlackmanStd; external nspDLL;
procedure nspcWinBlackmanStd; external nspDLL;
procedure nspdWinBlackmanStd; external nspDLL;
procedure nspzWinBlackmanStd; external nspDLL;
procedure nspwWinBlackmanStd; external nspDLL;
procedure nspvWinBlackmanStd; external nspDLL;

procedure nspsWinBlackmanStd2; external nspDLL;
procedure nspcWinBlackmanStd2; external nspDLL;
procedure nspdWinBlackmanStd2; external nspDLL;
procedure nspzWinBlackmanStd2; external nspDLL;
procedure nspwWinBlackmanStd2; external nspDLL;
procedure nspvWinBlackmanStd2; external nspDLL;

procedure nspsWinBlackmanOpt; external nspDLL;
procedure nspcWinBlackmanOpt; external nspDLL;
procedure nspdWinBlackmanOpt; external nspDLL;
procedure nspzWinBlackmanOpt; external nspDLL;
procedure nspwWinBlackmanOpt; external nspDLL;
procedure nspvWinBlackmanOpt; external nspDLL;

procedure nspsWinBlackmanOpt2; external nspDLL;
procedure nspcWinBlackmanOpt2; external nspDLL;
procedure nspdWinBlackmanOpt2; external nspDLL;
procedure nspzWinBlackmanOpt2; external nspDLL;
procedure nspwWinBlackmanOpt2; external nspDLL;
procedure nspvWinBlackmanOpt2; external nspDLL;

procedure nspsWinKaiser;      external nspDLL;
procedure nspcWinKaiser;      external nspDLL;
procedure nspdWinKaiser;      external nspDLL;
procedure nspzWinKaiser;      external nspDLL;
procedure nspwWinKaiser;      external nspDLL;
procedure nspvWinKaiser;      external nspDLL;

procedure nspsWinKaiser2;     external nspDLL;
procedure nspcWinKaiser2;     external nspDLL;
procedure nspdWinKaiser2;     external nspDLL;
procedure nspzWinKaiser2;     external nspDLL;
procedure nspwWinKaiser2;     external nspDLL;
procedure nspvWinKaiser2;     external nspDLL;

{EOF}
(*
       INTEL CORPORATION PROPRIETARY INFORMATION
This software is supplied under the terms of a license agreement or
nondisclosure agreement with Intel Corporation and may not be copied
or disclosed except in accordance with the terms of that agreement.
  Copyright (c) 1998-2000 Intel Corporation. All Rights Reserved.
*)

procedure nspWtFree;           external nspDLL;

procedure nspsWtInit;          external nspDLL;
procedure nspdWtInit;          external nspDLL;
procedure nspwWtInit;          external nspDLL;
procedure nspsWtInitLen;       external nspDLL;
procedure nspdWtInitLen;       external nspDLL;
procedure nspwWtInitLen;       external nspDLL;

function nspsWtInitUserFilter; external nspDLL;
function nspdWtInitUserFilter; external nspDLL;
function nspwWtInitUserFilter; external nspDLL;

procedure nspsWtSetState;      external nspDLL;
procedure nspdWtSetState;      external nspDLL;
procedure nspwWtSetState;      external nspDLL;

procedure nspsWtGetState;      external nspDLL;
procedure nspdWtGetState;      external nspDLL;
procedure nspwWtGetState;      external nspDLL;

procedure nspsWtDecompose;     external nspDLL;
procedure nspdWtDecompose;     external nspDLL;
procedure nspwWtDecompose;     external nspDLL;

procedure nspsWtReconstruct;   external nspDLL;
procedure nspdWtReconstruct;   external nspDLL;
procedure nspwWtReconstruct;   external nspDLL;

{EOF}
