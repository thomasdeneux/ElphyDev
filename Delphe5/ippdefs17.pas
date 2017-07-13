unit ippdefs17;


{$Z+,A+}
// Gérard Sadoc 2017
// Translation of ippdefs.h , ippbase.h , ipptypes.h


// Copyright 1999-2017 Intel Corporation All Rights Reserved.
//
// The source code, information and material ("Material") contained herein is
// owned by Intel Corporation or its suppliers or licensors, and title
// to such Material remains with Intel Corporation or its suppliers or
// licensors. The Material contains proprietary information of Intel
// or its suppliers and licensors. The Material is protected by worldwide
// copyright laws and treaty provisions. No part of the Material may be used,
// copied, reproduced, modified, published, uploaded, posted, transmitted,
// distributed or disclosed in any way without Intel's prior express written
// permission. No license under any patent, copyright or other intellectual
// property rights in the Material is granted to or conferred upon you,
// either expressly, by implication, inducement, estoppel or otherwise.
// Any license under such intellectual property rights must be express and
// approved by Intel in writing.
//
// Unless otherwise agreed by Intel in writing,
// you may not remove or alter this notice or any other notice embedded in
// Materials by Intel or Intel's suppliers or licensors in any way.
//



//              Intel(R) Integrated Performance Primitives (Intel(R) IPP)
//              Common Types and Macro Definitions
//




(* ///////////////////////////////////////////////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//         Copyright (c) 1999-2003 Intel Corporation. All Rights Reserved.
//
//          Intel(R) Integrated Performance Primitives
//            Common Types and Macro Definitions
//
*)

INTERFACE

uses util1;

Const              // incomplet mais rarement utilisé

  IPP_PI    =      3.14159265358979323846 ; (* ANSI C does not support M_PI *)
  IPP_2PI   =      6.28318530717958647692 ; (* 2*pi                         *)
  IPP_PI2   =      1.57079632679489661923 ; (* pi/2                         *)
  IPP_PI4   =      0.78539816339744830961 ; (* pi/4                         *)
  IPP_PI180 =      0.01745329251994329577 ; (* pi/180                       *)
  IPP_RPI   =      0.31830988618379067154 ; (* 1/pi                         *)
  IPP_SQRT2 =      1.41421356237309504880 ; (* sqrt(2)                      *)
  IPP_SQRT3 =      1.73205080756887729353 ; (* sqrt(3)                      *)
  IPP_LN2   =      0.69314718055994530942 ; (* ln(2)                        *)
  IPP_LN3   =      1.09861228866810969139 ; (* ln(3)                        *)
  IPP_E     =      2.71828182845904523536 ; (* e                            *)
  IPP_RE    =      0.36787944117144232159 ; (* 1/e                          *)
  IPP_EPS23 =      1.19209289e-07 ;
  IPP_EPS52 =      2.2204460492503131e-016 ;

  IPP_MAX_8U     =      $FF ;
  IPP_MAX_16U    =      $FFFF ;
  IPP_MAX_32U    =      $FFFFFFFF ;
  IPP_MIN_8U     =      0 ;
  IPP_MIN_16U    =      0 ;
  IPP_MIN_32U    =      0 ;
  IPP_MIN_8S     =      -128 ;
  IPP_MAX_8S     =      127 ;
  IPP_MIN_16S    =      -32768 ;
  IPP_MAX_16S    =      32767 ;
  IPP_MIN_32S    =      -2147483647 - 1 ;
  IPP_MAX_32S    =      2147483647 ;
  IPP_MIN_64U    =      0 ;

  IPP_MAX_64S  =        9223372036854775807 ;
  IPP_MIN_64S  =        9223372036854775807 - 1 ;

  IPP_MINABS_32F =    1.175494351e-38;
  IPP_MAXABS_32F =    3.402823466e+38;
  IPP_EPS_32F    =    1.192092890e-07;
  IPP_MINABS_64F =    2.2250738585072014e-308;
  IPP_MAXABS_64F =    1.7976931348623158e+308;
  IPP_EPS_64F    =    2.2204460492503131e-016;

  (*
  IPP_DEG_TO_RAD=    deg  ( (deg)/180.0 * IPP_PI )
  IPP_COUNT_OF=    obj   (sizeof(obj)/sizeof(obj[0]))

  IPP_MAX=    a, b  ( ((a) > (b)) ? (a) : (b) )
  IPP_MIN=    a, b  ( ((a) < (b)) ? (a) : (b) )
  *)

type
  IppCpuType=      (* Enumeration:         Processor:                 *)
   (ippCpuUnknown = 0,
    ippCpuPP,         (* Intel(R) Pentium(R) processor                *)
    ippCpuPMX,        (* Pentium(R) processor with MMX(TM) technology *)
    ippCpuPPR,        (* Pentium(R) Pro processor                     *)
    ippCpuPII,        (* Pentium(R) II processor                      *)
    ippCpuPIII,       (* Pentium(R) III processor                     *)
    ippCpuP4,         (* Pentium(R) 4 processor                       *)
    ippCpuP4HT,       (* Pentium(R) 4 Processor with HT Technology    *)
    ippCpuP4HT2,
    ippCpuCentrino,   (* Intel(R) Centrino(TM) mobile technology      *)
    ippCpuITP = $10,  (* Intel(R) Itanium(R) processor                *)
    ippCpuITP2        (* Itanium(R) 2 processor                       *)
    );

  IppLibraryVersion=
    record
       major: integer;                     (* e.g. 1                               *)
       minor: integer;                     (* e.g. 2                               *)
       majorBuild: integer;                (* e.g. 3                               *)
       build: integer;                     (* e.g. 10, always >= majorBuild        *)
       targetCpu: array[1..4] of Ansichar; (* corresponding to Intel(R) processor  *)
       Name: Pansichar;                        (* e.g. "ippsw7"                        *)
       Version: Pansichar;                     (* e.g. "v1.2 Beta"                     *)
       BuildDate: Pansichar;                   (* e.g. "Jul 20 99"                     *)
    end;
  PIppLibraryVersion=^IppLibraryVersion;

  Ipp8u  = byte;
  Ipp16u = word;
  Ipp32u = longword;

  Ipp8s  = shortint;
  Ipp16s = smallint;
  Ipp32s = longint;

  Ipp32f = single;
  Ipp64s = int64;
  Ipp64u = int64;          { uint64 n'existe pas }
  Ipp64f = double;

  Ipp16f = single;         // inconnu en pascal

  Ipp8sc = record
             re: Ipp8s;
             Im: Ipp8s;
           end;

  Ipp16sc =record
             re: Ipp16s;
             Im: Ipp16s;
           end;

  Ipp32sc =record
             re: Ipp32s;
             Im: Ipp32s;
           end;

  Ipp32fc = TsingleComp;
           {
           record
             re: Ipp32f;
             Im: Ipp32f;
           end;
           }
  Ipp64sc =record
             re: Ipp64s;
             Im: Ipp64s;
           end;

  Ipp64fc = TdoubleComp;
           {
           record
             re: Ipp64f;
             Im: Ipp64f;
           end;
           }
  PIpp8u =  Pbyte; {^Ipp8u;}
  PIpp16u = Pword; {^Ipp16u;}
  PIpp32u = Plongword; {^Ipp32u;}

  PIpp8s =  Pshortint; {^Ipp8s;}
  PIpp16s = Psmallint; { ^Ipp16s;}
  PIpp32s = Plongint; {^Ipp32s;}

  PIpp32f = {^Ipp32f;}Psingle;
  PIpp64s = ^Ipp64s;
  PIpp64u = ^Ipp64u;
  PIpp64f = {^Ipp64f}Pdouble;
  Pipp16f = ^Ipp16f;   // inconnu

  PIpp8sc = ^Ipp8sc;

  PIpp16sc = ^Ipp16sc;

  PIpp32sc = ^Ipp32sc;

  PIpp32fc = {^Ipp32fc;}PsingleComp;

  PIpp64sc = ^Ipp64sc;

  PIpp64fc = {^Ipp64fc;}PdoubleComp;


type
  IppDataType = (
   {ippUndef}
   _ipp1u   ,
   _ipp8u   ,
   _ipp8uc  ,
   _ipp8s   ,
   _ipp8sc  ,
   _ipp16u  ,
   _ipp16uc ,
   _ipp16s  ,
   _ipp16sc ,
   _ipp32u  ,
   _ipp32uc ,
   _ipp32s  ,
   _ipp32sc ,
   _ipp32f  ,
   _ipp32fc ,
   _ipp64u  ,
   _ipp64uc ,
   _ipp64s  ,
   _ipp64sc ,
   _ipp64f  ,
   _ipp64fc );

  IppBool = (
    ippFalse,
    ippTrue );

{ ippTypes.h }


(*****************************************************************************)
(*                   Below are ippCore domain specific definitions           *)
(*****************************************************************************)

Const
  ippCPUID_MMX =       $00000001;   (* Intel Architecture MMX technology supported  *)
  ippCPUID_SSE =       $00000002;   (* Streaming SIMD Extensions                    *)
  ippCPUID_SSE2 =      $00000004;   (* Streaming SIMD Extensions 2                  *)
  ippCPUID_SSE3 =      $00000008;   (* Streaming SIMD Extensions 3                  *)
  ippCPUID_SSSE3 =     $00000010;   (* Supplemental Streaming SIMD Extensions 3     *)
  ippCPUID_MOVBE =     $00000020;   (* The processor supports MOVBE instruction     *)
  ippCPUID_SSE41 =     $00000040;   (* Streaming SIMD Extensions 4.1                *)
  ippCPUID_SSE42 =     $00000080;   (* Streaming SIMD Extensions 4.2                *)
  ippCPUID_AVX =       $00000100;   (* Advanced Vector Extensions instruction set   *)
  ippAVX_ENABLEDBYOS = $00000200;   (* The operating system supports AVX            *)
  ippCPUID_AES =       $00000400;   (* AES instruction                              *)
  ippCPUID_CLMUL =     $00000800;   (* PCLMULQDQ instruction                        *)
  ippCPUID_ABR =       $00001000;   (* Reserved                                     *)
  ippCPUID_RDRAND =    $00002000;   (* Read Random Number instructions              *)
  ippCPUID_F16C =      $00004000;   (* Float16 instructions                         *)
  ippCPUID_AVX2 =      $00008000;   (* Advanced Vector Extensions 2 instruction set *)
  ippCPUID_ADCOX =     $00010000;   (* ADCX and ADOX instructions                   *)
  ippCPUID_RDSEED =    $00020000;   (* The RDSEED instruction                       *)
  ippCPUID_PREFETCHW = $00040000;   (* The PREFETCHW instruction                    *)
  ippCPUID_SHA =       $00080000;   (* Intel (R) SHA Extensions                     *)
  ippCPUID_AVX512F =   $00100000;   (* AVX-512 Foundation instructions              *)
  ippCPUID_AVX512CD =  $00200000;   (* AVX-512 Conflict Detection instructions      *)
  ippCPUID_AVX512ER =  $00400000;   (* AVX-512 Exponential & Reciprocal instructions*)
  ippCPUID_AVX512PF =  $00800000;   (* AVX-512 Prefetch instructions                *)
  ippCPUID_AVX512BW =  $01000000;   (* AVX-512 Byte & Word instructions             *)
  ippCPUID_AVX512DQ =  $02000000;   (* AVX-512 DWord & QWord instructions           *)
  ippCPUID_AVX512VL =  $04000000;   (* AVX-512 Vector Length extensions             *)
  ippCPUID_AVX512VBMI =$08000000;   (* X-512 Vector Length extensions             *)
  ippCPUID_MPX =       $10000000;   (* Intel MPX (Memory Protection Extensions)     *)
  ippCPUID_KNC =       $80000000;   (* Intel(R) Xeon Phi(TM) Coprocessor            *)

  ippCPUID_NOCHECK =   $8000000000000000;   (* Force ippSetCpuFeatures to set CPU features without check *)

  ippCPUID_GETINFO_A = $616f666e69746567;   (* Force ipp_GetCpuFeatures to work as cpuid instruction *)

type
  ippCache= record
              type1: integer;
              level: integer;
              size: integer;
            end;


(*****************************************************************************)
(*                   Below are ippSP domain specific definitions             *)
(*****************************************************************************)

Const
//IppRoundMode
   ippRndZero=           0;
   ippRndNear=           1;
   ippRndFinancial=      2;
   ippRndHintAccurate= $10;

//IppHintAlgorithm
    ippAlgHintNone =     0;
    ippAlgHintFast =     1;
    ippAlgHintAccurate = 2;


//IppCmpOp
    ippCmpLess =      0;
    ippCmpLessEq =    1;
    ippCmpEq =        2;
    ippCmpGreaterEq=  3;
    ippCmpGreater=    4;


// IppAlgType
    ippAlgAuto    = $00000000;
    ippAlgDirect  = $00000001;
    ippAlgFFT     = $00000002;
    ippAlgMask    = $000000FF;


// IppsNormOp
    ippsNormNone  = $00000000; (* default *)
    ippsNormA     = $00000100; (* biased normalization *)
    ippsNormB     = $00000200; (* unbiased normalization *)
    ippsNormMask  = $0000FF00;


// IppNormType
    ippNormInf  =   $00000001;
    ippNormL1   =   $00000002;
    ippNormL2   =   $00000004;

type
  IppRoundMode = integer;
  IppHintAlgorithm = integer;
  IppCmpOp = integer;
  IppAlgType = integer;
  IppsNormOp = integer;
  IppNormType = integer;

Const
    IPP_FFT_DIV_FWD_BY_N = 1;
    IPP_FFT_DIV_INV_BY_N = 2;
    IPP_FFT_DIV_BY_SQRTN = 4;
    IPP_FFT_NODIV_BY_ANY = 8;



    IPP_DIV_FWD_BY_N = 1;
    IPP_DIV_INV_BY_N = 2;
    IPP_DIV_BY_SQRTN = 4;
    IPP_NODIV_BY_ANY = 8;

type
  IppPointPolar =
    record
      rho:   Ipp32f;
      theta: Ipp32f ;
    end;


  IppWinType=  (ippWinBartlett,ippWinBlackman,ippWinHamming,ippWinHann,ippWinRect);

  IppsIIRFilterType = (ippButterworth, ippChebyshev1);

  IppsZCType=  ( ippZCR, ippZCXor, ippZCC );


  IppsROI = record
              left: integer;
              right: integer;
            end;


  IppsRandUniState_8u = pointer;
  PIppsRandUniState_8u = ^IppsRandUniState_8u;

  IppsRandUniState_16s = pointer;
  PIppsRandUniState_16s = ^IppsRandUniState_16s;

  IppsRandUniState_32f = pointer;
  PIppsRandUniState_32f = ^IppsRandUniState_32f;

  IppsRandUniState_64f = pointer;
  PIppsRandUniState_64f = ^IppsRandUniState_64f;


  IppsRandGaussState_8u = pointer;
  PIppsRandGaussState_8u = ^IppsRandGaussState_8u;

  IppsRandGaussState_16s = pointer;
  PIppsRandGaussState_16s = ^IppsRandGaussState_16s;

  IppsRandGaussState_32f = pointer;
  PIppsRandGaussState_32f = ^IppsRandGaussState_32f;

  IppsRandGaussState_64f = pointer;
  PIppsRandGaussState_64f = ^IppsRandGaussState_64f;


  IppsFFTSpec_C_32fc = pointer;
  PIppsFFTSpec_C_32fc = ^IppsFFTSpec_C_32fc;

  IppsFFTSpec_C_32f = pointer;
  PIppsFFTSpec_C_32f = ^IppsFFTSpec_C_32f;

  IppsFFTSpec_R_32f = pointer;
  PIppsFFTSpec_R_32f = ^IppsFFTSpec_R_32f;


  IppsFFTSpec_C_64fc = pointer;
  PIppsFFTSpec_C_64fc = ^IppsFFTSpec_C_64fc;

  IppsFFTSpec_C_64f = pointer;
  PIppsFFTSpec_C_64f = ^IppsFFTSpec_C_64f;

  IppsFFTSpec_R_64f = pointer;
  PIppsFFTSpec_R_64f = ^IppsFFTSpec_R_64f;


  IppsDFTSpec_C_32fc = pointer;
  PIppsDFTSpec_C_32fc = ^IppsDFTSpec_C_32fc;

  IppsDFTSpec_C_32f = pointer;
  PIppsDFTSpec_C_32f = ^IppsDFTSpec_C_32f;

  IppsDFTSpec_R_32f = pointer;
  PIppsDFTSpec_R_32f = ^IppsDFTSpec_R_32f;


  IppsDFTSpec_C_64fc = pointer;
  PIppsDFTSpec_C_64fc = ^IppsDFTSpec_C_64fc;

  IppsDFTSpec_C_64f = pointer;
  PIppsDFTSpec_C_64f = ^IppsDFTSpec_C_64f;

  IppsDFTSpec_R_64f = pointer;
  PIppsDFTSpec_R_64f = ^IppsDFTSpec_R_64f;


  IppsDCTFwdSpec_32f = pointer;
  PIppsDCTFwdSpec_32f = ^IppsDCTFwdSpec_32f;

  IppsDCTInvSpec_32f = pointer;
  PIppsDCTInvSpec_32f = ^IppsDCTInvSpec_32f;


  IppsDCTFwdSpec_64f = pointer;
  PIppsDCTFwdSpec_64f = ^IppsDCTFwdSpec_64f;

  IppsDCTInvSpec_64f = pointer;
  PIppsDCTInvSpec_64f = ^IppsDCTInvSpec_64f;


  IppsWTFwdState_32f = pointer;
  PIppsWTFwdState_32f = ^IppsWTFwdState_32f;

  IppsWTFwdState_8u32f = pointer;
  PIppsWTFwdState_8u32f = ^IppsWTFwdState_8u32f;

  IppsWTFwdState_16s32f = pointer;
  PIppsWTFwdState_16s32f = ^IppsWTFwdState_16s32f;

  IppsWTFwdState_16u32f = pointer;
  PIppsWTFwdState_16u32f = ^IppsWTFwdState_16u32f;

  IppsWTInvState_32f = pointer;
  PIppsWTInvState_32f = ^IppsWTInvState_32f;

  IppsWTInvState_32f8u = pointer;
  PIppsWTInvState_32f8u = ^IppsWTInvState_32f8u;

  IppsWTInvState_32f16s = pointer;
  PIppsWTInvState_32f16s = ^IppsWTInvState_32f16s;

  IppsWTInvState_32f16u = pointer;
  PIppsWTInvState_32f16u = ^IppsWTInvState_32f16u;


  IppsIIRState_32f = pointer;
  PIppsIIRState_32f = ^IppsIIRState_32f;

  IppsIIRState_32fc = pointer;
  PIppsIIRState_32fc = ^IppsIIRState_32fc;

  IppsIIRState32f_16s = pointer;
  PIppsIIRState32f_16s = ^IppsIIRState32f_16s;

  IppsIIRState32fc_16sc = pointer;
  PIppsIIRState32fc_16sc = ^IppsIIRState32fc_16sc;

  IppsIIRState_64f = pointer;
  PIppsIIRState_64f = ^IppsIIRState_64f;

  IppsIIRState_64fc = pointer;
  PIppsIIRState_64fc = ^IppsIIRState_64fc;

  IppsIIRState64f_32f = pointer;
  PIppsIIRState64f_32f = ^IppsIIRState64f_32f;

  IppsIIRState64fc_32fc = pointer;
  PIppsIIRState64fc_32fc = ^IppsIIRState64fc_32fc;

  IppsIIRState64f_32s = pointer;
  PIppsIIRState64f_32s = ^IppsIIRState64f_32s;

  IppsIIRState64fc_32sc = pointer;
  PIppsIIRState64fc_32sc = ^IppsIIRState64fc_32sc;

  IppsIIRState64f_16s = pointer;
  PIppsIIRState64f_16s = ^IppsIIRState64f_16s;

  IppsIIRState64fc_16sc = pointer;
  PIppsIIRState64fc_16sc = ^IppsIIRState64fc_16sc;


  IppsFIRSpec_32f = pointer;
  PIppsFIRSpec_32f = ^IppsFIRSpec_32f;

  IppsFIRSpec_64f = pointer;
  PIppsFIRSpec_64f = ^IppsFIRSpec_64f;

  IppsFIRSpec_32fc = pointer;
  PIppsFIRSpec_32fc = ^IppsFIRSpec_32fc;

  IppsFIRSpec_64fc = pointer;
  PIppsFIRSpec_64fc = ^IppsFIRSpec_64fc;


  IppsFIRLMSState_32f = pointer;
  PIppsFIRLMSState_32f = ^IppsFIRLMSState_32f;

  IppsFIRLMSState32f_16s = pointer;
  PIppsFIRLMSState32f_16s = ^IppsFIRLMSState32f_16s;


  IppsHilbertSpec = pointer;
  PIppsHilbertSpec = ^IppsHilbertSpec;


  IppsFIRSparseState_32f = pointer;
  PIppsFIRSparseState_32f = ^IppsFIRSparseState_32f;

  IppsIIRSparseState_32f = pointer;
  PIppsIIRSparseState_32f = ^IppsIIRSparseState_32f;


  IppsResamplingPolyphase_16s = pointer;
  PIppsResamplingPolyphase_16s = ^IppsResamplingPolyphase_16s;

  IppsResamplingPolyphaseFixed_16s = pointer;
  PIppsResamplingPolyphaseFixed_16s = ^IppsResamplingPolyphaseFixed_16s;

  IppsResamplingPolyphase_32f = pointer;
  PIppsResamplingPolyphase_32f = ^IppsResamplingPolyphase_32f;

  IppsResamplingPolyphaseFixed_32f = pointer;
  PIppsResamplingPolyphaseFixed_32f = ^IppsResamplingPolyphaseFixed_32f;



(*****************************************************************************)
(*                   Below are ippIP domain specific definitions             *)
(*****************************************************************************)

Const
   IPP_TEMPORAL_COPY     = $0;
   IPP_NONTEMPORAL_STORE = $01;
   IPP_NONTEMPORAL_LOAD  = $02;

type
  IppEnum = integer;

// #define IPP_DEG_TO_RAD( deg ) ( (deg)/180.0 * IPP_PI )

Const
 // IppiNormOp;
    ippiNormNone        = $00000000; (* default *)
    ippiNorm            = $00000100; (* normalized form *)
    ippiNormCoefficient = $00000200; (* correlation coefficient in the range [-1.0 ... 1.0] *)
    ippiNormMask        = $0000FF00;


type
   IppiROIShape = integer;
Const
   ippiROIFull   = $00000000;
   ippiROIValid  = $00010000;
   ippiROISame   = $00020000;
   ippiROIMask   = $00FF0000;


type
   IppChannels = integer;
Const
   ippC0    =  0;
   ippC1    =  1;
   ippC2    =  2;
   ippC3    =  3;
   ippC4    =  4;
   ippP2    =  5;
   ippP3    =  6;
   ippP4    =  7;
   ippAC1   =  8;
   ippAC4   =  9;
   ippA0C4  = 10;
   ippAP4   = 11;


type
    IppiBorderType = integer;
Const
    ippBorderRepl         =  1;
    ippBorderWrap         =  2;
    ippBorderMirror       =  3; (* left border: 012... -> 21012... *)
    ippBorderMirrorR      =  4; (* left border: 012... -> 210012... *)
    ippBorderDefault      =  5;
    ippBorderConst        =  6;
    ippBorderTransp       =  7;

    (* Flags to use source image memory pixels from outside of the border in particular directions *)
    ippBorderInMemTop     =  $0010;
    ippBorderInMemBottom  =  $0020;
    ippBorderInMemLeft    =  $0040;
    ippBorderInMemRight   =  $0080;
    ippBorderInMem        =  ippBorderInMemLeft or ippBorderInMemTop or ippBorderInMemRight or ippBorderInMemBottom;

    (* Flags to use source image memory pixels from outside of the border for first stage only in multi-stage filters *)
    ippBorderFirstStageInMem = $0F00;

type
  IppiAxis= ( ippAxsHorizontal,
              ippAxsVertical,
              ippAxsBoth,
              ippAxs45,
              ippAxs135);


type
  IppiRect=
    record
      x: integer;
      y: integer;
      width: integer;
      height: integer;
    end;

  PIppiRect=^IppIrect;

  IppiPoint =
    record
      x,y: integer;
    end;
  PIppiPoint = ^IppiPoint;

  IPPIsize =
    record
      width, height: integer;
    end;
  PIPPIsize = ^IPPIsize;

  IppiPoint_32f =
    record
      x,y: Ipp32f;
    end;
  PIppiPoint_32f = ^IppiPoint_32f;


type
  IppiMaskSize = integer;
Const

  ippMskSize1x3 = 13;
  ippMskSize1x5 = 15;
  ippMskSize3x1 = 31;
  ippMskSize3x3 = 33;
  ippMskSize5x1 = 51;
  ippMskSize5x5 = 55;


  IPPI_INTER_NN     = 1;
  IPPI_INTER_LINEAR = 2;
  IPPI_INTER_CUBIC  = 4;
  IPPI_INTER_CUBIC2P_BSPLINE = 5;     (* two-parameter cubic filter (B=1, C=0) *)
  IPPI_INTER_CUBIC2P_CATMULLROM = 6;  (* two-parameter cubic filter (B=0, C=1/2) *)
  IPPI_INTER_CUBIC2P_B05C03 = 7;      (* two-parameter cubic filter (B=1/2, C=3/10) *)
  IPPI_INTER_SUPER  = 8;
  IPPI_INTER_LANCZOS = 16;
  IPPI_ANTIALIASING  = (1 shl 29);
  IPPI_SUBPIXEL_EDGE = (1 shl 30);
  IPPI_SMOOTH_EDGE   = (1 shl 31);


type
  IppiInterpolationType = integer;
Const
  ippNearest = IPPI_INTER_NN;
  ippLinear = IPPI_INTER_LINEAR;
  ippCubic = IPPI_INTER_CUBIC2P_CATMULLROM;
  ippLanczos = IPPI_INTER_LANCZOS;
  ippHahn = 0;
  ippSuper = IPPI_INTER_SUPER;


type
  IppiFraction =(
    ippPolyphase_1_2 ,
    ippPolyphase_3_5 ,
    ippPolyphase_2_3 ,
    ippPolyphase_7_10 ,
    ippPolyphase_3_4 );

Const

  IPP_FASTN_ORIENTATION = $0001;
  IPP_FASTN_NMS         = $0002;
  IPP_FASTN_CIRCLE      = $0004;
  IPP_FASTN_SCORE_MODE0 = $0020;

type
  IppiAlphaType =(
    ippAlphaOver,
    ippAlphaIn,
    ippAlphaOut,
    ippAlphaATop,
    ippAlphaXor,
    ippAlphaPlus,
    ippAlphaOverPremul,
    ippAlphaInPremul,
    ippAlphaOutPremul,
    ippAlphaATopPremul,
    ippAlphaXorPremul,
    ippAlphaPlusPremul );


  IppiDeconvFFTState_32f_C1R = pointer;
  PIppiDeconvFFTState_32f_C1R = ^IppiDeconvFFTState_32f_C1R;

  IppiDeconvFFTState_32f_C3R = pointer;
  PIppiDeconvFFTState_32f_C3R = ^IppiDeconvFFTState_32f_C3R;

  IppiDeconvLR_32f_C1R = pointer;
  PIppiDeconvLR_32f_C1R = ^IppiDeconvLR_32f_C1R;

  IppiDeconvLR_32f_C3R = pointer;
  PIppiDeconvLR_32f_C3R = ^IppiDeconvLR_32f_C3R;

type
  IppiFilterBilateralType = integer;
Const

  ippiFilterBilateralGauss = 100;
  ippiFilterBilateralGaussFast = 101;


type
  IppiFilterBilateralSpec = pointer;
  PIppiFilterBilateralSpec = ^IppiFilterBilateralSpec;

type
   IppiDistanceMethodType = integer;
Const
   ippDistNormL1   =   $00000002;


type
  IppiResizeFilterType = (
    ippResizeFilterHann,
    ippResizeFilterLanczos );


  IppiResizeFilterState = pointer;
  PIppiResizeFilterState = ^IppiResizeFilterState;


  IppiBorderSize =
    record
      borderLeft: Ipp32u;
      borderTop: Ipp32u;
      borderRight: Ipp32u;
      borderBottom: Ipp32u;
    end;
  PIppiBorderSize = ^IppiBorderSize;

  IppiWarpDirection =(
    ippWarpForward,
    ippWarpBackward );


  IppiWarpTransformType = (
    ippWarpAffine,
    ippWarpPerspective,
    ippWarpBilinear );


  IppiResizeSpec_32f = pointer;
  PIppiResizeSpec_32f = ^IppiResizeSpec_32f;

  IppiResizeYUV422Spec = pointer;
  PIppiResizeYUV422Spec = ^IppiResizeYUV422Spec;

  IppiResizeYUV420Spec = pointer;
  PIppiResizeYUV420Spec = ^IppiResizeYUV420Spec;


  IppiResizeSpec_64f = pointer;
  PIppiResizeSpec_64f = ^IppiResizeSpec_64f;

  IppiWarpSpec = pointer;
  PIppiWarpSpec = ^IppiWarpSpec;

  IppiFilterBorderSpec = pointer;
  PIppiFilterBorderSpec = ^IppiFilterBorderSpec;

  IppiThresholdAdaptiveSpec = pointer;
  PIppiThresholdAdaptiveSpec = ^IppiThresholdAdaptiveSpec;

  IppiHistogramSpec = pointer;
  PIppiHistogramSpec = ^IppiHistogramSpec;

  IppiHOGConfig =
    record
       cvCompatible:integer;   (* openCV compatible output format *)
       cellSize: integer;      (* squre cell size (pixels) *)
       blockSize: integer;     (* square block size (pixels) *)
       blockStride: integer;   (* block displacement (the same for x- and y- directions) *)
       nbins: integer;         (* required number of bins *)
       sigma: Ipp32f;          (* gaussian factor of HOG block weights *)
       l2thresh: Ipp32f;       (* normalization factor *)
       winsize: IppiSize;      (* detection window size (pixels) *)
    end;
  PIppiHOGConfig = ^IppiHOGConfig;

  IppiFFTSpec_C_32fc = pointer;
  PIppiFFTSpec_C_32fc = ^IppiFFTSpec_C_32fc;

  IppiFFTSpec_R_32f = pointer;
  PIppiFFTSpec_R_32f = ^IppiFFTSpec_R_32f;


  IppiDFTSpec_C_32fc = pointer;
  PIppiDFTSpec_C_32fc = ^IppiDFTSpec_C_32fc;

  IppiDFTSpec_R_32f = pointer;
  PIppiDFTSpec_R_32f = ^IppiDFTSpec_R_32f;


  IppiDCTFwdSpec_32f = pointer;
  PIppiDCTFwdSpec_32f = ^IppiDCTFwdSpec_32f;

  IppiDCTInvSpec_32f = pointer;
  PIppiDCTInvSpec_32f = ^IppiDCTInvSpec_32f;


  IppiWTFwdSpec_32f_C1R = pointer;
  PIppiWTFwdSpec_32f_C1R = ^IppiWTFwdSpec_32f_C1R;

  IppiWTInvSpec_32f_C1R = pointer;
  PIppiWTInvSpec_32f_C1R = ^IppiWTInvSpec_32f_C1R;

  IppiWTFwdSpec_32f_C3R = pointer;
  PIppiWTFwdSpec_32f_C3R = ^IppiWTFwdSpec_32f_C3R;

  IppiWTInvSpec_32f_C3R = pointer;
  PIppiWTInvSpec_32f_C3R = ^IppiWTInvSpec_32f_C3R;


  IppiMomentState_64f = pointer;
  PIppiMomentState_64f = ^IppiMomentState_64f;

  IppiHuMoment_64f = array[0..6] of Ipp64f;

  IppiLUT_Spec = pointer;
  PIppiLUT_Spec = ^IppiLUT_Spec;

Const
  IPP_HOG_MAX_CELL  = 16;  (* max size of CELL *)
  IPP_HOG_MAX_BLOCK = 64;  (* max size of BLOCK *)
  IPP_HOG_MAX_BINS  = 16;  (* max number of BINS *)

type
  IppiHOGSpec = pointer;
  PIppiHOGSpec = ^IppiHOGSpec;




         (**** Below are 3D Image (Volume) Processing specific definitions ****)

type
  IpprVolume =
    record
      width: integer;
      height: integer;
      depth: integer;
    end;

  IpprCuboid =
    record
      x: integer;
      y: integer;
      z: integer;
      width: integer;
      height: integer;
      depth: integer;
    end;
  PIpprCuboid = ^IpprCuboid;

  IpprPoint =
    record
      x,y,z: integer;
    end;
  PIpprPoint = ^IPPrPoint;

(*****************************************************************************)
(*                   Below are ippCV domain specific definitions             *)
(*****************************************************************************)

  IppiDifferentialKernel= (
    ippFilterSobelVert,
    ippFilterSobelHoriz,
    ippFilterSobel,
    ippFilterScharrVert,
    ippFilterScharrHoriz,
    ippFilterScharr,
    ippFilterCentralDiffVert,
    ippFilterCentralDiffHoriz,
    ippFilterCentralDiff );


Const
  // IppiKernelType
  ippKernelSobel     =  0;
  ippKernelScharr    =  1;
  ippKernelSobelNeg  =  2;


  //IppiNorm
    ippiNormInf = 0;
    ippiNormL1 = 1;
    ippiNormL2 = 2;
    ippiNormFM = 3;

type
  IppiMorphState = pointer;
  PIppiMorphState = ^IppiMorphState;

  IppiMorphStateL = pointer;
  PIppiMorphStateL = ^IppiMorphStateL;

  IppiMorphAdvState = pointer;
  PIppiMorphAdvState = ^IppiMorphAdvState;

  IppiMorphAdvStateL = pointer;
  PIppiMorphAdvStateL = ^IppiMorphAdvStateL;

  IppiMorphGrayState_8u = pointer;
  PIppiMorphGrayState_8u = ^IppiMorphGrayState_8u;

  IppiMorphGrayState_8uL = pointer;
  PIppiMorphGrayState_8uL = ^IppiMorphGrayState_8uL;

  IppiMorphGrayState_32f = pointer;
  PIppiMorphGrayState_32f = ^IppiMorphGrayState_32f;

  IppiMorphGrayState_32fL = pointer;
  PIppiMorphGrayState_32fL = ^IppiMorphGrayState_32fL;


  IppiConvState = pointer;
  PIppiConvState = ^IppiConvState;


  IppiConnectedComp =
    record
      area:  Ipp64f;                (*  area of the segmented component  *)
      value: array[0..2] of Ipp64f; (*  gray scale value of the segmented component  *)
      rect:  IppiRect;              (*  bounding rectangle of the segmented component  *)
    end;

  IppiPyramidState = pointer;
  PIppiPyramidState = ^IppiPyramidState;


  IppiPyramidDownState_8u_C1R = pointer;
  PIppiPyramidDownState_8u_C1R = ^IppiPyramidDownState_8u_C1R;

  IppiPyramidDownState_16u_C1R = pointer;
  PIppiPyramidDownState_16u_C1R = ^IppiPyramidDownState_16u_C1R;

  IppiPyramidDownState_32f_C1R = pointer;
  PIppiPyramidDownState_32f_C1R = ^IppiPyramidDownState_32f_C1R;

  IppiPyramidDownState_8u_C3R = pointer;
  PIppiPyramidDownState_8u_C3R = ^IppiPyramidDownState_8u_C3R;

  IppiPyramidDownState_16u_C3R = pointer;
  PIppiPyramidDownState_16u_C3R = ^IppiPyramidDownState_16u_C3R;

  IppiPyramidDownState_32f_C3R = pointer;
  PIppiPyramidDownState_32f_C3R = ^IppiPyramidDownState_32f_C3R;

  IppiPyramidUpState_8u_C1R = pointer;
  PIppiPyramidUpState_8u_C1R = ^IppiPyramidUpState_8u_C1R;

  IppiPyramidUpState_16u_C1R = pointer;
  PIppiPyramidUpState_16u_C1R = ^IppiPyramidUpState_16u_C1R;

  IppiPyramidUpState_32f_C1R = pointer;
  PIppiPyramidUpState_32f_C1R = ^IppiPyramidUpState_32f_C1R;

  IppiPyramidUpState_8u_C3R = pointer;
  PIppiPyramidUpState_8u_C3R = ^IppiPyramidUpState_8u_C3R;

  IppiPyramidUpState_16u_C3R = pointer;
  PIppiPyramidUpState_16u_C3R = ^IppiPyramidUpState_16u_C3R;

  IppiPyramidUpState_32f_C3R = pointer;
  PIppiPyramidUpState_32f_C3R = ^IppiPyramidUpState_32f_C3R;



  IppiPyramid  =
    record
      pImage:  ^PIpp8u;
      pROI:    ^IppiSize;
      pRate:   ^Ipp64f;
      pStep:   ^integer;
      pState:  ^Ipp8u;
      level:   integer;
    end;

  IppiOptFlowPyrLK = pointer;
  PIppiOptFlowPyrLK = ^IppiOptFlowPyrLK;


  IppiOptFlowPyrLK_8u_C1R = pointer;
  PIppiOptFlowPyrLK_8u_C1R = ^IppiOptFlowPyrLK_8u_C1R;

  IppiOptFlowPyrLK_16u_C1R = pointer;
  PIppiOptFlowPyrLK_16u_C1R = ^IppiOptFlowPyrLK_16u_C1R;

  IppiOptFlowPyrLK_32f_C1R = pointer;
  PIppiOptFlowPyrLK_32f_C1R = ^IppiOptFlowPyrLK_32f_C1R;


  IppiHaarClassifier_32f = pointer;
  PIppiHaarClassifier_32f = ^IppiHaarClassifier_32f;

  IppiHaarClassifier_32s = pointer;
  PIppiHaarClassifier_32s = ^IppiHaarClassifier_32s;


  IppFGHistogramState_8u_C1R = pointer;
  PIppFGHistogramState_8u_C1R = ^IppFGHistogramState_8u_C1R;

  IppFGHistogramState_8u_C3R = pointer;
  PIppFGHistogramState_8u_C3R = ^IppFGHistogramState_8u_C3R;


  IppFGGaussianState_8u_C1R = pointer;
  PIppFGGaussianState_8u_C1R = ^IppFGGaussianState_8u_C1R;

  IppFGGaussianState_8u_C3R = pointer;
  PIppFGGaussianState_8u_C3R = ^IppFGGaussianState_8u_C3R;


  IppiInpaintFlag = (
    IPP_INPAINT_TELEA,
    IPP_INPAINT_NS
  );

  IppFilterGaussianSpec = pointer;
  PIppFilterGaussianSpec = ^IppFilterGaussianSpec;


  IppiInpaintState_8u_C1R = pointer;
  PIppiInpaintState_8u_C1R = ^IppiInpaintState_8u_C1R;

  IppiInpaintState_8u_C3R = pointer;
  PIppiInpaintState_8u_C3R = ^IppiInpaintState_8u_C3R;


  IppiHoughProbSpec = pointer;
  PIppiHoughProbSpec = ^IppiHoughProbSpec;


  IppiFastNSpec = pointer;
  PIppiFastNSpec = ^IppiFastNSpec;


  IppiCornerFastN =
    record
       x: integer;
       y: integer;
       cornerType: integer;
       orientation: integer;
       angle: single;
       score: single;
    end;

  IppFGMMState_8u_C3R = pointer;
  PIppFGMMState_8u_C3R = ^IppFGMMState_8u_C3R;


  IppFGMModel =
    record
      numFrames: longword;
      maxNGauss: longword;
      varInit: Ipp32f;
      varMin: Ipp32f;
      varMax: Ipp32f;
      varWBRatio: Ipp32f;
      bckgThr: Ipp32f;
      varNGRatio: Ipp32f;
      reduction: Ipp32f;
      shadowValue: Ipp8u;
      chadowFlag: AnsiChar;
      shadowRatio: Ipp32f;
    end;

Const
  IPP_SEGMENT_QUEUE    = $01;
  IPP_SEGMENT_DISTANCE = $02;
  IPP_SEGMENT_BORDER_4 = $40;
  IPP_SEGMENT_BORDER_8 = $80;

// #define IPP_TRUNC(a,b) ((a)&~((b)-1))
// #define IPP_APPEND(a,b) (((a)+(b)-1)&~((b)-1))

(*****************************************************************************)
(*                   Below are ippCC domain specific definitions             *)
(*****************************************************************************)
Const
   IPP_UPPER        = 1;
   IPP_LEFT         = 2;
   IPP_CENTER       = 4;
   IPP_RIGHT        = 8;
   IPP_LOWER        = 16;
   IPP_UPPER_LEFT   = 32;
   IPP_UPPER_RIGHT  = 64;
   IPP_LOWER_LEFT   = 128;
   IPP_LOWER_RIGHT  = 256;


type
  IppiDitherType = (
    ippDitherNone,
    ippDitherFS,
    ippDitherJJN,
    ippDitherStucki,
    ippDitherBayer );


(*****************************************************************************)
(*                   Below are ippCH domain specific definitions             *)
(*****************************************************************************)


type
  IppRegExpFind =
    record
      pFind: pointer;
      lenFind: integer;
    end;


  IppRegExpState = pointer;
  PIppRegExpState = ^IppRegExpState;


  IppRegExpFormat = (
    ippFmtASCII,
    ippFmtUTF8 );


  IppRegExpReplaceState = pointer;
  PIppRegExpReplaceState = ^IppRegExpReplaceState;



(*****************************************************************************)
(*                   Below are ippDC domain specific definitions             *)
(*****************************************************************************)

  IppMTFState_8u = pointer;
  PIppMTFState_8u = ^IppMTFState_8u;


  IppBWTSortAlgorithmHint =(
    ippBWTItohTanakaLimSort,
    ippBWTItohTanakaUnlimSort,
    ippBWTSuffixSort,
    ippBWTAutoSort );


  IppLZSSState_8u = pointer;
  PIppLZSSState_8u = ^IppLZSSState_8u;


  IppLZ77State_8u = pointer;
  PIppLZ77State_8u = ^IppLZ77State_8u;

  IppLZ77ComprLevel =(
    IppLZ77FastCompr,
    IppLZ77AverageCompr,
    IppLZ77BestCompr );

  IppLZ77Chcksm =(
    IppLZ77NoChcksm,
    IppLZ77Adler32,
    IppLZ77CRC32 );

  IppLZ77Flush =(
    IppLZ77NoFlush,
    IppLZ77SyncFlush,
    IppLZ77FullFlush,
    IppLZ77FinishFlush );

  IppLZ77Pair =
    record
      length: Ipp16u;
      offset: Ipp16u;
    end;

  IppLZ77DeflateStatus = (
    IppLZ77StatusInit,
    IppLZ77StatusLZ77Process,
    IppLZ77StatusHuffProcess,
    IppLZ77StatusFinal );

  IppLZ77HuffMode =(
    IppLZ77UseFixed,
    IppLZ77UseDynamic,
    IppLZ77UseStored );

  IppLZ77InflateStatus = (
    IppLZ77InflateStatusInit,
    IppLZ77InflateStatusHuffProcess,
    IppLZ77InflateStatusLZ77Process,
    IppLZ77InflateStatusFinal );


  IppInflateState  =
    record
      pWindow: PIpp8u;            (* pointer to the sliding window
                                    (the dictionary for the LZ77 algorithm) *)
      winSize: longword;          (* size of the sliding window *)
      tableType: longword;        (* type of Huffman code tables
                                    (for example, 0 - tables for Fixed Huffman codes) *)
      tableBufferSize: longword;  (* (ENOUGH = 2048) * (sizeof(code) = 4) -
                                    sizeof(IppInflateState) *)
    end;

  (* this type is used as a translator of the inflate_mode type from zlib *)
  IppInflateMode = (
    ippTYPE,
    ippLEN,
    ippLENEXT );


  IppDeflateFreqTable =
    record
      freq: Ipp16u;
      code: Ipp16u;
    end;

  IppDeflateHuffCode =
    record
      code:Ipp16u;
      len: Ipp16u;
    end;


  IppRLEState_BZ2 = pointer;
  PIppRLEState_BZ2 = ^IppRLEState_BZ2;


  IppEncodeHuffState_BZ2 = pointer;
  PIppEncodeHuffState_BZ2 = ^IppEncodeHuffState_BZ2;


  IppDecodeHuffState_BZ2 = pointer;
  PIppDecodeHuffState_BZ2 = ^IppDecodeHuffState_BZ2;


  IppLZOMethod = (
    IppLZO1XST,       (* Single-threaded, generic LZO-compatible*)
    IppLZO1XMT );     (* Multi-threaded *)


  IppLZOState_8u = pointer;
  PIppLZOState_8u = ^IppLZOState_8u;



(* /////////////////////////////////////////////////////////////////////////////
//        The following enumerator defines a status of Intel(R) IPP operations
//                     negative value means error
*)
type
  IppStatus = integer;

Const

    (* errors *)
    ippStsNotSupportedModeErr    = -9999;(* The requested mode is currently not supported.  *)
    ippStsCpuNotSupportedErr     = -9998;(* The target CPU is not supported. *)
    ippStsInplaceModeNotSupportedErr = -9997;(* The inplace operation is currently not supported. *)

    ippStsABIErrRBX              = -8000; (* RBX is not saved by Intel(R) IPP function *)
    ippStsABIErrRDI              = -8001; (* RDI is not saved by Intel(R) IPP function *)
    ippStsABIErrRSI              = -8002; (* RSI is not saved by Intel(R) IPP function *)
    ippStsABIErrRBP              = -8003; (* RBP is not saved by Intel(R) IPP function *)
    ippStsABIErrR12              = -8004; (* R12 is not saved by Intel(R) IPP function *)
    ippStsABIErrR13              = -8005; (* R13 is not saved by Intel(R) IPP function *)
    ippStsABIErrR14              = -8006; (* R14 is not saved by Intel(R) IPP function *)
    ippStsABIErrR15              = -8007; (* R15 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM6             = -8008; (* XMM6 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM7             = -8009; (* XMM7 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM8             = -8010; (* XMM8 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM9             = -8011; (* XMM9 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM10            = -8012; (* XMM10 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM11            = -8013; (* XMM11 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM12            = -8014; (* XMM12 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM13            = -8015; (* XMM13 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM14            = -8016; (* XMM14 is not saved by Intel(R) IPP function *)
    ippStsABIErrXMM15            = -8017; (* XMM15 is not saved by Intel(R) IPP function *)

    ippStsIIRIIRLengthErr        = -234; (* Vector length for IIRIIR function is less than 3*(IIR order) *)
    ippStsWarpTransformTypeErr   = -233; (* The warp transform type is illegal *)
    ippStsExceededSizeErr        = -232; (* Requested size exceeded the maximum supported ROI size *)
    ippStsWarpDirectionErr       = -231; (* The warp transform direction is illegal *)

    ippStsFilterTypeErr          = -230; (* The filter type is incorrect or not supported *)

    ippStsNormErr                = -229; (* The norm is incorrect or not supported *)

    ippStsAlgTypeErr             = -228; (* Algorithm type is not supported.        *)
    ippStsMisalignedOffsetErr    = -227; (* The offset is not aligned with an element. *)

    ippStsQuadraticNonResidueErr = -226; (* SQRT operation on quadratic non-residue value. *)

    ippStsBorderErr              = -225; (* Illegal value for border type.*)

    ippStsDitherTypeErr          = -224; (* Dithering type is not supported. *)
    ippStsH264BufferFullErr      = -223; (* Buffer for the output bitstream is full. *)
    ippStsWrongAffinitySettingErr= -222; (* An affinity setting does not correspond to the affinity setting that was set by f.ippSetAffinity(). *)
    ippStsLoadDynErr             = -221; (* Error when loading the dynamic library. *)

    ippStsPointAtInfinity        = -220; (* Point at infinity is detected.  *)

    ippStsUnknownStatusCodeErr   = -216; (* Unknown status code. *)

    ippStsOFBSizeErr             = -215; (* Incorrect value for crypto OFB block size. *)
    ippStsLzoBrokenStreamErr     = -214; (* LZO safe decompression function cannot decode LZO stream. *)

    ippStsRoundModeNotSupportedErr  = -213; (* Rounding mode is not supported. *)
    ippStsDecimateFractionErr    = -212; (* Fraction in Decimate is not supported. *)
    ippStsWeightErr              = -211; (* Incorrect value for weight. *)

    ippStsQualityIndexErr        = -210; (* Cannot calculate the quality index for an image filled with a constant. *)
    ippStsIIRPassbandRippleErr   = -209; (* Ripple in passband for Chebyshev1 design is less than zero; equal to zero; or greater than 29. *)
    ippStsFilterFrequencyErr     = -208; (* Cutoff frequency of filter is less than zero; equal to zero; or greater than 0.5. *)
    ippStsFIRGenOrderErr         = -207; (* Order of the FIR filter for design is less than 1.                    *)
    ippStsIIRGenOrderErr         = -206; (* Order of the IIR filter for design is less than 1; or greater than 12. *)

    ippStsConvergeErr            = -205; (* The algorithm does not converge. *)
    ippStsSizeMatchMatrixErr     = -204; (* The sizes of the source matrices are unsuitable. *)
    ippStsCountMatrixErr         = -203; (* Count value is less than; or equal to zero. *)
    ippStsRoiShiftMatrixErr      = -202; (* RoiShift value is negative or not divisible by the size of the data type. *)

    ippStsResizeNoOperationErr   = -201; (* One of the output image dimensions is less than 1 pixel. *)
    ippStsSrcDataErr             = -200; (* The source buffer contains unsupported data. *)
    ippStsMaxLenHuffCodeErr      = -199; (* Huff: Max length of Huffman code is more than the expected one. *)
    ippStsCodeLenTableErr        = -198; (* Huff: Invalid codeLenTable. *)
    ippStsFreqTableErr           = -197; (* Huff: Invalid freqTable. *)

    ippStsIncompleteContextErr   = -196; (* Crypto: set up of context is not complete. *)

    ippStsSingularErr            = -195; (* Matrix is singular. *)
    ippStsSparseErr              = -194; (* Positions of taps are not in ascending order; or are negative; or repetitive. *)
    ippStsBitOffsetErr           = -193; (* Incorrect bit offset value. *)
    ippStsQPErr                  = -192; (* Incorrect quantization parameter value. *)
    ippStsVLCErr                 = -191; (* Illegal VLC or FLC is detected during stream decoding. *)
    ippStsRegExpOptionsErr       = -190; (* RegExp: Options for the pattern are incorrect. *)
    ippStsRegExpErr              = -189; (* RegExp: The structure pRegExpState contains incorrect data. *)
    ippStsRegExpMatchLimitErr    = -188; (* RegExp: The match limit is exhausted. *)
    ippStsRegExpQuantifierErr    = -187; (* RegExp: Incorrect quantifier. *)
    ippStsRegExpGroupingErr      = -186; (* RegExp: Incorrect grouping. *)
    ippStsRegExpBackRefErr       = -185; (* RegExp: Incorrect back reference. *)
    ippStsRegExpChClassErr       = -184; (* RegExp: Incorrect character class. *)
    ippStsRegExpMetaChErr        = -183; (* RegExp: Incorrect metacharacter. *)
    ippStsStrideMatrixErr        = -182;  (* Stride value is not positive or not divisible by the size of the data type. *)
    ippStsCTRSizeErr             = -181;  (* Incorrect value for crypto CTR block size. *)
    ippStsJPEG2KCodeBlockIsNotAttached =-180; (* Codeblock parameters are not attached to the state structure. *)
    ippStsNotPosDefErr           = -179;      (* Matrix is not positive definite. *)

    ippStsEphemeralKeyErr        = -178; (* ECC: Invalid ephemeral key.   *)
    ippStsMessageErr             = -177; (* ECC: Invalid message digest.  *)
    ippStsShareKeyErr            = -176; (* ECC: Invalid share key.   *)
    ippStsIvalidPublicKey        = -175; (* ECC: Invalid public key.  *)
    ippStsIvalidPrivateKey       = -174; (* ECC: Invalid private key. *)
    ippStsOutOfECErr             = -173; (* ECC: Point out of EC.     *)
    ippStsECCInvalidFlagErr      = -172; (* ECC: Invalid Flag.        *)

    ippStsMP3FrameHeaderErr      = -171;  (* Error in fields of the IppMP3FrameHeader structure. *)
    ippStsMP3SideInfoErr         = -170;  (* Error in fields of the IppMP3SideInfo structure. *)

    ippStsBlockStepErr           = -169;  (* Step for Block is less than 8. *)
    ippStsMBStepErr              = -168;  (* Step for MB is less than 16. *)

    ippStsAacPrgNumErr           = -167;  (* AAC: Invalid number of elements for one program.   *)
    ippStsAacSectCbErr           = -166;  (* AAC: Invalid section codebook.                     *)
    ippStsAacSfValErr            = -164;  (* AAC: Invalid scalefactor value.                    *)
    ippStsAacCoefValErr          = -163;  (* AAC: Invalid quantized coefficient value.          *)
    ippStsAacMaxSfbErr           = -162;  (* AAC: Invalid coefficient index.  *)
    ippStsAacPredSfbErr          = -161;  (* AAC: Invalid predicted coefficient index.  *)
    ippStsAacPlsDataErr          = -160;  (* AAC: Invalid pulse data attributes.  *)
    ippStsAacGainCtrErr          = -159;  (* AAC: Gain control is not supported.  *)
    ippStsAacSectErr             = -158;  (* AAC: Invalid number of sections.  *)
    ippStsAacTnsNumFiltErr       = -157;  (* AAC: Invalid number of TNS filters.  *)
    ippStsAacTnsLenErr           = -156;  (* AAC: Invalid length of TNS region.  *)
    ippStsAacTnsOrderErr         = -155;  (* AAC: Invalid order of TNS filter.  *)
    ippStsAacTnsCoefResErr       = -154;  (* AAC: Invalid bit-resolution for TNS filter coefficients.  *)
    ippStsAacTnsCoefErr          = -153;  (* AAC: Invalid coefficients of TNS filter. *)
    ippStsAacTnsDirectErr        = -152;  (* AAC: Invalid direction TNS filter.  *)
    ippStsAacTnsProfileErr       = -151;  (* AAC: Invalid TNS profile.  *)
    ippStsAacErr                 = -150;  (* AAC: Internal error.  *)
    ippStsAacBitOffsetErr        = -149;  (* AAC: Invalid current bit offset in bitstream.  *)
    ippStsAacAdtsSyncWordErr     = -148;  (* AAC: Invalid ADTS syncword.  *)
    ippStsAacSmplRateIdxErr      = -147;  (* AAC: Invalid sample rate index.  *)
    ippStsAacWinLenErr           = -146;  (* AAC: Invalid window length (not short or long).  *)
    ippStsAacWinGrpErr           = -145;  (* AAC: Invalid number of groups for current window length.  *)
    ippStsAacWinSeqErr           = -144;  (* AAC: Invalid window sequence range.  *)
    ippStsAacComWinErr           = -143;  (* AAC: Invalid common window flag.  *)
    ippStsAacStereoMaskErr       = -142;  (* AAC: Invalid stereo mask.  *)
    ippStsAacChanErr             = -141;  (* AAC: Invalid channel number.  *)
    ippStsAacMonoStereoErr       = -140;  (* AAC: Invalid mono-stereo flag.  *)
    ippStsAacStereoLayerErr      = -139;  (* AAC: Invalid this Stereo Layer flag.  *)
    ippStsAacMonoLayerErr        = -138;  (* AAC: Invalid this Mono Layer flag.  *)
    ippStsAacScalableErr         = -137;  (* AAC: Invalid scalable object flag.  *)
    ippStsAacObjTypeErr          = -136;  (* AAC: Invalid audio object type.  *)
    ippStsAacWinShapeErr         = -135;  (* AAC: Invalid window shape.  *)
    ippStsAacPcmModeErr          = -134;  (* AAC: Invalid PCM output interleaving indicator.  *)
    ippStsVLCUsrTblHeaderErr          = -133;  (* VLC: Invalid header inside table. *)
    ippStsVLCUsrTblUnsupportedFmtErr  = -132;  (* VLC: Table format is not supported.  *)
    ippStsVLCUsrTblEscAlgTypeErr      = -131;  (* VLC: Ecs-algorithm is not supported. *)
    ippStsVLCUsrTblEscCodeLengthErr   = -130;  (* VLC: Esc-code length inside table header is incorrect. *)
    ippStsVLCUsrTblCodeLengthErr      = -129;  (* VLC: Code length inside table is incorrect.  *)
    ippStsVLCInternalTblErr           = -128;  (* VLC: Invalid internal table. *)
    ippStsVLCInputDataErr             = -127;  (* VLC: Invalid input data. *)
    ippStsVLCAACEscCodeLengthErr      = -126;  (* VLC: Invalid AAC-Esc code length. *)
    ippStsNoiseRangeErr         = -125;  (* Noise value for Wiener Filter is out of range. *)
    ippStsUnderRunErr           = -124;  (* Error in data under run. *)
    ippStsPaddingErr            = -123;  (* Detected padding error indicates the possible data corruption. *)
    ippStsCFBSizeErr            = -122;  (* Incorrect value for crypto CFB block size. *)
    ippStsPaddingSchemeErr      = -121;  (* Invalid padding scheme.  *)
    ippStsInvalidCryptoKeyErr   = -120;  (* A compromised key causes suspansion of the requested cryptographic operation.  *)
    ippStsLengthErr             = -119;  (* Incorrect value for string length. *)
    ippStsBadModulusErr         = -118;  (* Bad modulus caused a failure in module inversion. *)
    ippStsLPCCalcErr            = -117;  (* Cannot evaluate linear prediction. *)
    ippStsRCCalcErr             = -116;  (* Cannot compute reflection coefficients. *)
    ippStsIncorrectLSPErr       = -115;  (* Incorrect values for Linear Spectral Pair. *)
    ippStsNoRootFoundErr        = -114;  (* No roots are found for equation. *)
    ippStsJPEG2KBadPassNumber   = -113;  (* Pass number exceeds allowed boundaries [0;nOfPasses-1]. *)
    ippStsJPEG2KDamagedCodeBlock= -112;  (* Codeblock for decoding contains damaged data. *)
    ippStsH263CBPYCodeErr       = -111;  (* Illegal Huffman code is detected through CBPY stream processing. *)
    ippStsH263MCBPCInterCodeErr = -110;  (* Illegal Huffman code is detected through MCBPC Inter stream processing. *)
    ippStsH263MCBPCIntraCodeErr = -109;  (* Illegal Huffman code is detected through MCBPC Intra stream processing. *)
    ippStsNotEvenStepErr        = -108;  (* Step value is not pixel multiple. *)
    ippStsHistoNofLevelsErr     = -107;  (* Number of levels for histogram is less than 2. *)
    ippStsLUTNofLevelsErr       = -106;  (* Number of levels for LUT is less than 2. *)
    ippStsMP4BitOffsetErr       = -105;  (* Incorrect bit offset value. *)
    ippStsMP4QPErr              = -104;  (* Incorrect quantization parameter. *)
    ippStsMP4BlockIdxErr        = -103;  (* Incorrect block index. *)
    ippStsMP4BlockTypeErr       = -102;  (* Incorrect block type. *)
    ippStsMP4MVCodeErr          = -101;  (* Illegal Huffman code is detected during MV stream processing. *)
    ippStsMP4VLCCodeErr         = -100;  (* Illegal Huffman code is detected during VLC stream processing. *)
    ippStsMP4DCCodeErr          = -99;   (* Illegal code is detected during DC stream processing. *)
    ippStsMP4FcodeErr           = -98;   (* Incorrect fcode value. *)
    ippStsMP4AlignErr           = -97;   (* Incorrect buffer alignment .           *)
    ippStsMP4TempDiffErr        = -96;   (* Incorrect temporal difference.         *)
    ippStsMP4BlockSizeErr       = -95;   (* Incorrect size of a block or macroblock. *)
    ippStsMP4ZeroBABErr         = -94;   (* All BAB values are equal to zero.             *)
    ippStsMP4PredDirErr         = -93;   (* Incorrect prediction direction.        *)
    ippStsMP4BitsPerPixelErr    = -92;   (* Incorrect number of bits per pixel.    *)
    ippStsMP4VideoCompModeErr   = -91;   (* Incorrect video component mode.       *)
    ippStsMP4LinearModeErr      = -90;   (* Incorrect DC linear mode. *)
    ippStsH263PredModeErr       = -83;   (* Incorrect Prediction Mode value.                                       *)
    ippStsH263BlockStepErr      = -82;   (* The step value is less than 8.                                         *)
    ippStsH263MBStepErr         = -81;   (* The step value is less than 16.                                        *)
    ippStsH263FrameWidthErr     = -80;   (* The frame width is less than 8.                                        *)
    ippStsH263FrameHeightErr    = -79;   (* The frame height is less than; or equal to zero.                        *)
    ippStsH263ExpandPelsErr     = -78;   (* Expand pixels number is less than 8.                               *)
    ippStsH263PlaneStepErr      = -77;   (* Step value is less than the plane width.                           *)
    ippStsH263QuantErr          = -76;   (* Quantizer value is less than; or equal to zero; or greater than 31. *)
    ippStsH263MVCodeErr         = -75;   (* Illegal Huffman code is detected during MV stream processing.                  *)
    ippStsH263VLCCodeErr        = -74;   (* Illegal Huffman code is detected during VLC stream processing.                 *)
    ippStsH263DCCodeErr         = -73;   (* Illegal code is detected during DC stream processing.                          *)
    ippStsH263ZigzagLenErr      = -72;   (* Zigzag compact length is more than 64.                             *)
    ippStsFBankFreqErr          = -71;   (* Incorrect value for the filter bank frequency parameter. *)
    ippStsFBankFlagErr          = -70;   (* Incorrect value for the filter bank parameter.           *)
    ippStsFBankErr              = -69;   (* Filter bank is not correctly initialized.              *)
    ippStsNegOccErr             = -67;   (* Occupation count is negative.                     *)
    ippStsCdbkFlagErr           = -66;   (* Incorrect value for the codebook flag parameter. *)
    ippStsSVDCnvgErr            = -65;   (* SVD algorithm does not converge.               *)
    ippStsJPEGHuffTableErr      = -64;   (* JPEG Huffman table is destroyed.        *)
    ippStsJPEGDCTRangeErr       = -63;   (* JPEG DCT coefficient is out of range. *)
    ippStsJPEGOutOfBufErr       = -62;   (* Attempt to access out of the buffer limits.   *)
    ippStsDrawTextErr           = -61;   (* System error in the draw text operation. *)
    ippStsChannelOrderErr       = -60;   (* Incorrect order of the destination channels. *)
    ippStsZeroMaskValuesErr     = -59;   (* All values of the mask are equal to zero. *)
    ippStsQuadErr               = -58;   (* The quadrangle is nonconvex or degenerates into triangle; line; or point *)
    ippStsRectErr               = -57;   (* Size of the rectangle region is less than; or equal to 1. *)
    ippStsCoeffErr              = -56;   (* Incorrect values for transformation coefficients.   *)
    ippStsNoiseValErr           = -55;   (* Incorrect value for noise amplitude for dithering.             *)
    ippStsDitherLevelsErr       = -54;   (* Number of dithering levels is out of range.             *)
    ippStsNumChannelsErr        = -53;   (* Number of channels is incorrect; or not supported.                  *)
    ippStsCOIErr                = -52;   (* COI is out of range. *)
    ippStsDivisorErr            = -51;   (* Divisor is equal to zero; function is aborted. *)
    ippStsAlphaTypeErr          = -50;   (* Illegal type of image compositing operation.                           *)
    ippStsGammaRangeErr         = -49;   (* Gamma range bounds is less than; or equal to zero.                      *)
    ippStsGrayCoefSumErr        = -48;   (* Sum of the conversion coefficients must be less than; or equal to 1.    *)
    ippStsChannelErr            = -47;   (* Illegal channel number.                                                *)
    ippStsToneMagnErr           = -46;   (* Tone magnitude is less than; or equal to zero.                          *)
    ippStsToneFreqErr           = -45;   (* Tone frequency is negative; or greater than; or equal to 0.5.           *)
    ippStsTonePhaseErr          = -44;   (* Tone phase is negative; or greater than; or equal to 2*PI.              *)
    ippStsTrnglMagnErr          = -43;   (* Triangle magnitude is less than; or equal to zero.                      *)
    ippStsTrnglFreqErr          = -42;   (* Triangle frequency is negative; or greater than; or equal to 0.5.       *)
    ippStsTrnglPhaseErr         = -41;   (* Triangle phase is negative; or greater than; or equal to 2*PI.          *)
    ippStsTrnglAsymErr          = -40;   (* Triangle asymmetry is less than -PI; or greater than; or equal to PI.   *)
    ippStsHugeWinErr            = -39;   (* Kaiser window is too big.                                             *)
    ippStsJaehneErr             = -38;   (* Magnitude value is negative.                                           *)
    ippStsStrideErr             = -37;   (* Stride value is less than the length of the row. *)
    ippStsEpsValErr             = -36;   (* Negative epsilon value.             *)
    ippStsWtOffsetErr           = -35;   (* Invalid offset value for wavelet filter.                                       *)
    ippStsAnchorErr             = -34;   (* Anchor point is outside the mask.                                             *)
    ippStsMaskSizeErr           = -33;   (* Invalid mask size.                                                           *)
    ippStsShiftErr              = -32;   (* Shift value is less than zero.                                                *)
    ippStsSampleFactorErr       = -31;   (* Sampling factor is less than; or equal to zero.                                *)
    ippStsSamplePhaseErr        = -30;   (* Phase value is out of range: 0 <= phase < factor.                             *)
    ippStsFIRMRFactorErr        = -29;   (* MR FIR sampling factor is less than; or equal to zero.                         *)
    ippStsFIRMRPhaseErr         = -28;   (* MR FIR sampling phase is negative; or greater than; or equal to the sampling factor. *)
    ippStsRelFreqErr            = -27;   (* Relative frequency value is out of range.                                     *)
    ippStsFIRLenErr             = -26;   (* Length of a FIR filter is less than; or equal to zero.                         *)
    ippStsIIROrderErr           = -25;   (* Order of an IIR filter is not valid. *)
    ippStsDlyLineIndexErr       = -24;   (* Invalid value for the delay line sample index. *)
    ippStsResizeFactorErr       = -23;   (* Resize factor(s) is less than; or equal to zero. *)
    ippStsInterpolationErr      = -22;   (* Invalid interpolation mode. *)
    ippStsMirrorFlipErr         = -21;   (* Invalid flip mode.                                         *)
    ippStsMoment00ZeroErr       = -20;   (* Moment value M(0;0) is too small to continue calculations. *)
    ippStsThreshNegLevelErr     = -19;   (* Negative value of the level in the threshold operation.    *)
    ippStsThresholdErr          = -18;   (* Invalid threshold bounds. *)
    ippStsContextMatchErr       = -17;   (* Context parameter does not match the operation. *)
    ippStsFftFlagErr            = -16;   (* Invalid value for the FFT flag parameter. *)
    ippStsFftOrderErr           = -15;   (* Invalid value for the FFT order parameter. *)
    ippStsStepErr               = -14;   (* Step value is not valid. *)
    ippStsScaleRangeErr         = -13;   (* Scale bounds are out of range. *)
    ippStsDataTypeErr           = -12;   (* Data type is incorrect or not supported. *)
    ippStsOutOfRangeErr         = -11;   (* Argument is out of range; or point is outside the image. *)
    ippStsDivByZeroErr          = -10;   (* An attempt to divide by zero. *)
    ippStsMemAllocErr           = -9;    (* Memory allocated for the operation is not enough.*)
    ippStsNullPtrErr            = -8;    (* Null pointer error. *)
    ippStsRangeErr              = -7;    (* Incorrect values for bounds: the lower bound is greater than the upper bound. *)
    ippStsSizeErr               = -6;    (* Incorrect value for data size. *)
    ippStsBadArgErr             = -5;    (* Incorrect arg/param of the function.  *)
    ippStsNoMemErr              = -4;    (* Not enough memory for the operation. *)
    ippStsSAReservedErr3        = -3;    (* Unknown/unspecified error; -3. *)
    ippStsErr                   = -2;    (* Unknown/unspecified error; -2. *)
    ippStsSAReservedErr1        = -1;    (* Unknown/unspecified error; -1. *)

     (* no errors *)
    ippStsNoErr                 =   0;   (* No errors. *)

     (* warnings  *)
    ippStsNoOperation       =   1;       (* No operation has been executed. *)
    ippStsMisalignedBuf     =   2;       (* Misaligned pointer in operation in which it must be aligned. *)
    ippStsSqrtNegArg        =   3;       (* Negative value(s) for the argument in the Sqrt function. *)
    ippStsInvZero           =   4;       (* INF result. Zero value was met by InvThresh with zero level. *)
    ippStsEvenMedianMaskSize=   5;       (* Even size of the Median Filter mask was replaced with the odd one. *)
    ippStsDivByZero         =   6;       (* Zero value(s) for the divisor in the Div function. *)
    ippStsLnZeroArg         =   7;       (* Zero value(s) for the argument in the Ln function.     *)
    ippStsLnNegArg          =   8;       (* Negative value(s) for the argument in the Ln function. *)
    ippStsNanArg            =   9;       (* Argument value is not a number.                  *)
    ippStsJPEGMarker        =   10;      (* JPEG marker in the bitstream.                 *)
    ippStsResFloor          =   11;      (* All result values are floored.                        *)
    ippStsOverflow          =   12;      (* Overflow in the operation.                   *)
    ippStsLSFLow            =   13;      (* Quantized LP synthesis filter stability check is applied at the low boundary of [0;pi]. *)
    ippStsLSFHigh           =   14;      (* Quantized LP synthesis filter stability check is applied at the high boundary of [0;pi]. *)
    ippStsLSFLowAndHigh     =   15;      (* Quantized LP synthesis filter stability check is applied at both boundaries of [0;pi]. *)
    ippStsZeroOcc           =   16;      (* Zero occupation count. *)
    ippStsUnderflow         =   17;      (* Underflow in the operation. *)
    ippStsSingularity       =   18;      (* Singularity in the operation.                                       *)
    ippStsDomain            =   19;      (* Argument is out of the function domain.                                      *)
    ippStsNonIntelCpu       =   20;      (* The target CPU is not Genuine Intel.                                         *)
    ippStsCpuMismatch       =   21;      (* Cannot set the library for the given CPU.                                     *)
    ippStsNoIppFunctionFound =  22;      (* Application does not contain Intel(R) IPP function calls.                            *)
    ippStsDllNotFoundBestUsed = 23;      (* Dispatcher cannot find the newest version of the Intel(R) IPP dll.                  *)
    ippStsNoOperationInDll  =   24;      (* The function does nothing in the dynamic version of the library.             *)
    ippStsInsufficientEntropy=  25;      (* Generation of the prime/key failed due to insufficient entropy in the random seed and stimulus bit string. *)
    ippStsOvermuchStrings   =   26;      (* Number of destination strings is more than expected.                         *)
    ippStsOverlongString    =   27;      (* Length of one of the destination strings is more than expected.              *)
    ippStsAffineQuadChanged =   28;      (* 4th vertex of destination quad is not equal to customer's one.               *)
    ippStsWrongIntersectROI =   29;      (* ROI has no intersection with the source or destination ROI. No operation. *)
    ippStsWrongIntersectQuad =  30;      (* Quadrangle has no intersection with the source or destination ROI. No operation. *)
    ippStsSmallerCodebook   =   31;      (* Size of created codebook is less than the cdbkSize argument. *)
    ippStsSrcSizeLessExpected = 32;      (* DC: Size of the source buffer is less than the expected one. *)
    ippStsDstSizeLessExpected = 33;      (* DC: Size of the destination buffer is less than the expected one. *)
    ippStsStreamEnd           = 34;      (* DC: The end of stream processed. *)
    ippStsDoubleSize        =   35;      (* Width or height of image is odd. *)
    ippStsNotSupportedCpu   =   36;      (* The CPU is not supported. *)
    ippStsUnknownCacheSize  =   37;      (* The CPU is supported; but the size of the cache is unknown. *)
    ippStsSymKernelExpected =   38;      (* The Kernel is not symmetric. *)
    ippStsEvenMedianWeight  =   39;      (* Even weight of the Weighted Median Filter is replaced with the odd one. *)
    ippStsWrongIntersectVOI =   40;      (* VOI has no intersection with the source or destination volume. No operation.                            *)
    ippStsI18nMsgCatalogInvalid=41;      (* Message Catalog is invalid; English message returned.                                                    *)
    ippStsI18nGetMessageFail  = 42;      (* Failed to fetch a localized message; English message returned. For more information use errno on Linux* OS and GetLastError on Windows* OS. *)
    ippStsWaterfall           = 43;      (* Cannot load required library; waterfall is used. *)
    ippStsPrevLibraryUsed     = 44;      (* Cannot load required library; previous dynamic library is used. *)
    ippStsLLADisabled         = 45;      (* OpenMP* Low Level Affinity is disabled. *)
    ippStsNoAntialiasing      = 46;      (* The mode does not support antialiasing. *)
    ippStsRepetitiveSrcData   = 47;      (* DC: The source data is too repetitive. *)
    ippStsSizeWrn             = 48;      (* The size does not allow to perform full operation. *)
    ippStsFeatureNotSupported = 49;      (* Current CPU doesn't support at least 1 of the desired features. *)
    ippStsUnknownFeature      = 50;      (* At least one of the desired features is unknown. *)
    ippStsFeaturesCombination = 51;      (* Wrong combination of features. *)
    ippStsAccurateModeNotSupported = 52;  (* Accurate mode is not supported. *)

  ippStsOk = ippStsNoErr;


//#define ippRectInfinite ippiWarpGetRectInfinite()






function IPPI_rect(x1,y1,w1,h1:integer):IPPIrect;
function IPPI_size(w1,h1:integer):IPPIsize;

IMPLEMENTATION

function IPPI_rect(x1,y1,w1,h1:integer):IPPIrect;
begin
  result.x:=x1;
  result.y:=y1;
  result.width:=w1;
  result.height:=h1;
end;

function IPPI_size(w1,h1:integer):IPPIsize;
begin
  result.width:=w1;
  result.height:=h1;
end;


end.



