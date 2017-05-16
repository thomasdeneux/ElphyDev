{ Version Delphi de IPPS.H
  Gérard Sadoc 5 avril 2005

  Utiliser convIPP pour traduire les macros IPPAPI
  Supprimer les directives conditionnelles
  Modifier les typedef struct

}

{$Z+,A+}  (*si un type énuméré est déclaré en mode $Z4 (= $Z+),
           il est stocké sous la forme d'un double mot non signé.
           En mode {$A8} ou {$A+}, les champs des types enregistrement déclarés
           sans le modificateur packed et les champs des structures classe
           sont alignés sur les frontières des quadruples mots.
          *)

Unit ipps;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses ippdefs, classes;

Const
  DLLname1='ipps-7.0.dll';

  DLLname2='ipps20.dll';

procedure IPPStest;
procedure IPPSend;
function InitIPPS:boolean;
procedure freeIPPS;

(* ////////////////////////////////// "ipps.h" /////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//         Copyright (c) 1999-2003 Intel Corporation. All Rights Reserved.
//
//                  Intel(R) Integrated Performance Primitives
//                  Signal Processing (ipps)
//
*)

(*
typedef struct {
    int left;
    int right;
} IppsROI;
*)

var
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetStatusString
//  Purpose:    convert the library status code to a readable string
//  Parameters:
//    StsCode   IPP status code
//  Returns:    pointer to string describing the library status code
//
//  Notes:      don't free the pointer
*)
  ippGetStatusString: function(StsCode:IppStatus):Pansichar;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetCpuType
//  Purpose:    detects CPU type
//  Parameter:  none
//  Return:     IppCpuType
//
*)

  ippGetCpuType: function:IppCpuType;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetCpuClocks
//  Purpose:    reading of time stamp counter (TSC) register value
//  Returns:    TSC value
//
//  Note:      An hardware exception is possible if TSC reading is not supported by
/              the current chipset
*)

  ippGetCpuClocks: function:Ipp64u;stdcall;


(* ///////////////////////////////////////////////////////////////////////////
//  Names:  ippSetFlushToZero,
//          ippSetDenormAreZero.
//
//  Purpose: ippSetFlushToZero enables or disables the flush-to-zero mode,
//           ippSetDenormAreZero enables or disables the denormals-are-zeros
//           mode.
//
//  Arguments:
//     value       - !0 or 0 - set or clear the corresponding bit of MXCSR
//     pUMask      - pointer to user store current underflow exception mask
//                   ( may be NULL if don't want to store )
//
//  Return:
//   ippStsNoErr              - Ok
//   ippStsCpuNotSupportedErr - the mode is not suppoted
*)

  ippSetFlushToZero: function(value:longint;pUMask:PlongWord):IppStatus;stdcall;
  ippSetDenormAreZeros: function(value:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsGetLibVersion
//  Purpose:    get the library version
//  Parameters:
//  Returns:    pointer to structure describing version of the ipps library
//
//  Notes:      don't free the pointer
*)
  ippsGetLibVersion: function:PIppLibraryVersion;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                   Functions to allocate and free memory;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMalloc
//  Purpose:    32-byte aligned memory allocation
//  Parameter:
//    len       number of elements (according to their type)
//  Returns:    pointer to allocated memory
//
//  Notes:      the memory allocated by ippsMalloc has to be free by ippsFree
//              function only;
*)

  ippsMalloc_8u: function(len:longint):PIpp8u;stdcall;
  ippsMalloc_16u: function(len:longint):PIpp16u;stdcall;
  ippsMalloc_32u: function(len:longint):PIpp32u;stdcall;
  ippsMalloc_8s: function(len:longint):PIpp8s;stdcall;
  ippsMalloc_16s: function(len:longint):PIpp16s;stdcall;
  ippsMalloc_32s: function(len:longint):PIpp32s;stdcall;
  ippsMalloc_64s: function(len:longint):PIpp64s;stdcall;

  ippsMalloc_32f: function(len:longint):PIpp32f;stdcall;
  ippsMalloc_64f: function(len:longint):PIpp64f;stdcall;

  ippsMalloc_8sc: function(len:longint):PIpp8sc;stdcall;
  ippsMalloc_16sc: function(len:longint):PIpp16sc;stdcall;
  ippsMalloc_32sc: function(len:longint):PIpp32sc;stdcall;
  ippsMalloc_64sc: function(len:longint):PIpp64sc;stdcall;
  ippsMalloc_32fc: function(len:longint):PIpp32fc;stdcall;
  ippsMalloc_64fc: function(len:longint):PIpp64fc;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFree
//  Purpose:    free memory allocated by the ippsMalloc functions
//  Parameter:
//    ptr       pointer to the memory allocated by the ippsMalloc functions
//
//  Notes:      use the function to free memory allocated by ippsMalloc_*
*)
  ippsFree: procedure(ptr:pointer);stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                   Vector Initialization functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCopy
//  Purpose:    copy data from source to destination vector
//  Parameters:
//    pSrc        pointer to the input vector
//    pDst        pointer to the output vector
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)

  ippsCopy_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsCopy_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsCopy_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsCopy_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCopy_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsCopy_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsCopy_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMove
//  Purpose:    The ippsMove function copies "len" elements from src to dst.
//              If some regions of the source area and the destination overlap,
//              ippsMove ensures that the original source bytes in the overlapping
//              region are copied before being overwritten.
//
//  Parameters:
//    pSrc        pointer to the input vector
//    pDst        pointer to the output vector
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)

  ippsMove_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsMove_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMove_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsMove_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMove_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMove_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMove_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsZero
//  Purpose:    set elements of the vector to zero of corresponding type
//  Parameters:
//    pDst       pointer to the destination vector
//    len        length of the vectors
//  Return:
//    ippStsNullPtrErr        pointer to the vector is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)

  ippsZero_8u: function(pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsZero_16s: function(pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsZero_16sc: function(pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsZero_32f: function(pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsZero_32fc: function(pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsZero_64f: function(pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsZero_64fc: function(pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSet
//  Purpose:    set elements of the destination vector to the value
//  Parameters:
//    val        value to set the elements of the vector
//    pDst       pointer to the destination vector
//    len        length of the vectors
//  Return:
//    ippStsNullPtrErr        pointer to the vector is NULL
//    ippStsSizeErr           length of the vector is less or equal zero
//    ippStsNoErr             otherwise
*)

  ippsSet_8u: function(val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSet_16s: function(val:Ipp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSet_16sc: function(val:Ipp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsSet_32s: function(val:Ipp32s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsSet_32sc: function(val:Ipp32sc;pDst:PIpp32sc;len:longint):IppStatus;stdcall;
  ippsSet_32f: function(val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSet_32fc: function(val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSet_64s: function(val:Ipp64s;pDst:PIpp64s;len:longint):IppStatus;stdcall;
  ippsSet_64sc: function(val:Ipp64sc;pDst:PIpp64sc;len:longint):IppStatus;stdcall;
  ippsSet_64f: function(val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSet_64fc: function(val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRandUniform_Direct_16s, ippsRandUniform_Direct_32f, ippsRandUniform_Direct_64f
//
//  Purpose:    Makes pseudo-random samples with a uniform distribution and places them in
//              the vector.
//
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer to vector is NULL
//    ippStsBadSizeErr         The length of the vector is less or equal zero
//
//  Arguments:
//    low                      The lower bounds of the uniform distributions range.
//    high                     The upper bounds of the uniform distributions range.
//    pSeed                    The pointer to the seed value used by the pseudo-random number
//                             generation algorithm.
//    pSrcDst                  The pointer to vector
//    len                      Vector's length
*)

  ippsRandUniform_Direct_16s: function(pDst:PIpp16s;len:longint;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippsRandUniform_Direct_32f: function(pDst:PIpp32f;len:longint;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippsRandUniform_Direct_64f: function(pDst:PIpp64f;len:longint;low:Ipp64f;high:Ipp64f;pSeed:PlongWord):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRandGauss_Direct_16s, ippsRandGauss_Direct_32f, ippsRandGauss_Direct_64f
//
//  Purpose:    Makes pseudo-random samples with a Normal distribution distribution and places
//              them in the vector.
//
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer to vector is NULL
//    ippStsBadSizeErr         The length of the vector is less or equal zero
//
//  Arguments:
//    mean                     The mean of the Normal distribution.
//    stdev                    The standard deviation of the Normal distribution.
//    pSeed                    The pointer to the seed value used by the pseudo-random number
//                             generation algorithm.
//    pSrcDst                  The pointer to vector
//    len                      Vector's length
*)

  ippsRandGauss_Direct_16s: function(pDst:PIpp16s;len:longint;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippsRandGauss_Direct_32f: function(pDst:PIpp32f;len:longint;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippsRandGauss_Direct_64f: function(pDst:PIpp64f;len:longint;mean:Ipp64f;stdev:Ipp64f;pSeed:PlongWord):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////// *)

type
  IppsRandUniState_8u = pointer;
  IppsRandUniState_16s = pointer;
  IppsRandUniState_32f = pointer;

  IppsRandGaussState_8u = pointer;
  IppsRandGaussState_16s = pointer;
  IppsRandGaussState_32f = pointer;


  PIppsRandUniState_8u =^IppsRandUniState_8u;
  PIppsRandUniState_16s =^IppsRandUniState_16s;
  PIppsRandUniState_32f =^IppsRandUniState_32f;

  PIppsRandGaussState_8u =^IppsRandGaussState_8u;
  PIppsRandGaussState_16s =^IppsRandGaussState_16s;
  PIppsRandGaussState_32f =^IppsRandGaussState_32f;


var
(* /////////////////////////////////////////////////////////////////////////
// Name:                ippsRandUniformInitAlloc_8u,  ippsRandUniformInitAlloc_16s,
//                      ippsRandUniformInitAlloc_32f
// Purpose:             Allocate and initializate parameters for the generator
//                      of noise with uniform distribution.
// Returns:
// Parameters:
//    pRandUniState     A pointer to the structure containing parameters for the
//                      generator of noise.
//    low               The lower bounds of the uniform distribution’s range.
//    high              The upper bounds of the uniform distribution’s range.
//    seed              The seed value used by the pseudo-random number generation
//                      algorithm.
//
// Returns:
//    ippStsNullPtrErr  pRandUniState==NULL
//    ippMemAllocErr    Can not allocate random uniform state
//    ippStsNoErr       No errors
//
*)
  ippsRandUniformInitAlloc_8u: function(var pRandUniState:PIppsRandUniState_8u;low:Ipp8u;high:Ipp8u;seed:longWord):IppStatus;stdcall;

  ippsRandUniformInitAlloc_16s: function(var pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;stdcall;

  ippsRandUniformInitAlloc_32f: function(var pRandUniState:PIppsRandUniState_32f;low:Ipp32f;high:Ipp32f;seed:longWord):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
// Name:                     ippsRandUniform_8u,  ippsRandUniform_16s,
//                           ippsRandUniform_32f
// Purpose:                  Makes pseudo-random samples with a uniform distribution
//                           and places them in the vector.
// Parameters:
//    pDst                   The pointer to vector
//    len                    Vector's length
//    pRandUniState          A pointer to the structure containing parameters for the
//                           generator of noise
// Returns:
//    ippStsNullPtrErr       pRandUniState==NULL
//    ippStsContextMatchErr  pState->idCtx != idCtxRandUni
//    ippStsNoErr            No errors
*)

  ippsRandUniform_8u: function(pDst:PIpp8u;len:longint;pRandUniState:PIppsRandUniState_8u):IppStatus;stdcall;
  ippsRandUniform_16s: function(pDst:PIpp16s;len:longint;pRandUniState:PIppsRandUniState_16s):IppStatus;stdcall;
  ippsRandUniform_32f: function(pDst:PIpp32f;len:longint;pRandUniState:PIppsRandUniState_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
// Name:                     ippsRandUniformFree_8u, ippsRandUniformFree_16s
//                           ippsRandUniformFree_32f
// Purpose:                  Close random uniform state
//
// Parameters:
//    pRandUniState          Pointer to the random uniform state
//
// Returns:
//    ippStsNullPtrErr       pState==NULL
//    ippStsContextMatchErr  pState->idCtx != idCtxRandUni
//    ippStsNoErr,           No errors
*)

  ippsRandUniformFree_8u: function(pRandUniState:PIppsRandUniState_8u):IppStatus;stdcall;
  ippsRandUniformFree_16s: function(pRandUniState:PIppsRandUniState_16s):IppStatus;stdcall;
  ippsRandUniformFree_32f: function(pRandUniState:PIppsRandUniState_32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
// Name:                ippsRandGaussInitAlloc_8u,  ippsRandGaussInitAlloc_16s,
//                      ippsRandGaussInitAlloc_32f
// Purpose:             Allocate and initializate parameters for the generator of noise.
// Returns:
// Parameters:
//    pRandGaussState   A pointer to the structure containing parameters for the
//                      generator of noise.
//    mean              The mean of the normal distribution.
//    stdDev            The standard deviation of the normal distribution.
//    seed              The seed value used by the pseudo-random number
//
// Returns:
//    ippStsNullPtrErr  pRandGaussState==NULL
//    ippMemAllocErr    Can not allocate normal random state
//    ippStsNoErr       No errors
//
*)
  ippsRandGaussInitAlloc_8u: function(var pRandGaussState:PIppsRandGaussState_8u;mean:Ipp8u;stdDev:Ipp8u;seed:longWord):IppStatus;stdcall;

  ippsRandGaussInitAlloc_16s: function(var pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;stdcall;

  ippsRandGaussInitAlloc_32f: function(var pRandGaussState:PIppsRandGaussState_32f;mean:Ipp32f;stdDev:Ipp32f;seed:longWord):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
// Name:                     ippsRandGauss_8u,  ippsRandGauss_16s,
//                           ippsRandGauss_32f
// Purpose:                  Makes pseudo-random samples with a normal distribution
//                           and places them in the vector.
// Parameters:
//    pDst                   The pointer to vector
//    len                    Vector's length
//    pRandUniState          A pointer to the structure containing parameters
//                           for the generator of noise
//    ippStsContextMatchErr  pState->idCtx != idCtxRandGauss
// Returns:
//    ippStsNullPtrErr       pRandGaussState==NULL
//    ippStsNoErr            No errors
*)

  ippsRandGauss_8u: function(pDst:PIpp8u;len:longint;pRandGaussState:PIppsRandGaussState_8u):IppStatus;stdcall;
  ippsRandGauss_16s: function(pDst:PIpp16s;len:longint;pRandGaussState:PIppsRandGaussState_16s):IppStatus;stdcall;
  ippsRandGauss_32f: function(pDst:PIpp32f;len:longint;pRandGaussState:PIppsRandGaussState_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
// Name:                     ippsRandGaussFree_8u, ippsRandGaussFree_16s,
//                           ippsRandGaussFree_32f
// Purpose:                  Close random normal state
//
// Parameters:
//    pRandUniState          Pointer to the random normal state
//
// Returns:
//    ippStsNullPtrErr       pState==NULL
//    ippStsContextMatchErr  pState->idCtx != idCtxRandGauss
//    ippStsNoErr,           No errors
*)

  ippsRandGaussFree_8u: function(pRandGaussState:PIppsRandGaussState_8u):IppStatus;stdcall;
  ippsRandGaussFree_16s: function(pRandGaussState:PIppsRandGaussState_16s):IppStatus;stdcall;
  ippsRandGaussFree_32f: function(pRandGaussState:PIppsRandGaussState_32f):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRandGaussGetSize_16s
//
//  Purpose:    Gaussian sequence generator state variable size -
//              computes the size,in bytes,
//              of the state variable structure ippsRandGaussState_16s.
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         pRandGaussStateSize==NULL
//  Arguments:
//    pRandGaussStateSize      pointer to the computed values of the size
//                             of the structure ippsRandGaussState_16s.
*)
  ippsRandGaussGetSize_16s: function(pRandGaussStateSize:Plongint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////
// Name:                ippsRandGaussInit_16s
// Purpose:             Initializes the Gaussian sequence generator state structure with
//                      given parameters (mean, variance, seed).
// Parameters:
//    pRandGaussState   A pointer to the structure containing parameters for the
//                      generator of noise.
//    mean              Mean of the normal distribution.
//    stdDev            Standard deviation of the normal distribution.
//    seed              Seed value used by the pseudo-random number generator
//
// Returns:
//    ippStsNullPtrErr  pRandGaussState==NULL
//    ippMemAllocErr    Can not allocate normal random state
//    ippStsNoErr       No errors
//
*)
  ippsRandGaussInit_16s: function(pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRandUniformGetSize_16s
//
//  Purpose:    Uniform sequence generator state variable size -
//              computes the size,in bytes,
//              of the state variable structure ippsRandIniState_16s.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         pRandUniformStateSize==NULL
//  Arguments:
//    pRandGaussStateSize      pointer to the computed value of the size
//                             of the structure ippsRandUniState_16s.
*)
  ippsRandUniformGetSize_16s: function(pRandUniformStateSize:Plongint):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////////////////
// Name:                ippsRandUniformInit_16s
// Purpose:             Initializes the uniform sequence generator state structure with
//                      given parameters (boundaries, seed)
// Parameters:
//    pRandUniState     Pointer to the structure containing parameters for the
//                      generator of noise.
//    low               Lower bound of the uniform distribution's range.
//    high              Upper bounds of the uniform distribution's range.
//    seed              Seed value used by the pseudo-random number generation
//                      algorithm.
//
*)
  ippsRandUniformInit_16s: function(pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////
//  Name:               ippsVectorJaehne
//  Purpose:            creates Jaehne vector
//
//  Parameters:
//    pDst              the pointer to the destination vector
//    len               length of the vector
//    magn              magnitude of the signal
//
//  Return:
//    ippStsNoErr       indicates no error
//    ippStsNullPtrErr  indicates an error when the pDst pointer is NULL
//    ippStsBadSizeErr  indicates an error when len is less or equal zero
//    ippStsJaehneErr   indicates an error when magnitude value is negative
//
//  Notes:              pDst[n] = magn*sin(0.5*pi*n^2/len), n=0,1,2,..len-1.
//
*)
  ippsVectorJaehne_8u: function(pDst:PIpp8u;len:longint;magn:Ipp8u):IppStatus;stdcall;
  ippsVectorJaehne_8s: function(pDst:PIpp8s;len:longint;magn:Ipp8s):IppStatus;stdcall;
  ippsVectorJaehne_16u: function(pDst:PIpp16u;len:longint;magn:Ipp16u):IppStatus;stdcall;
  ippsVectorJaehne_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s):IppStatus;stdcall;
  ippsVectorJaehne_32u: function(pDst:PIpp32u;len:longint;magn:Ipp32u):IppStatus;stdcall;
  ippsVectorJaehne_32s: function(pDst:PIpp32s;len:longint;magn:Ipp32s):IppStatus;stdcall;
  ippsVectorJaehne_32f: function(pDst:PIpp32f;len:longint;magn:Ipp32f):IppStatus;stdcall;
  ippsVectorJaehne_64f: function(pDst:PIpp64f;len:longint;magn:Ipp64f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsTone_Direct
//  Purpose:        generates a tone
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Some of pointers to input or output data are NULL
//    ippStsSizeErr      The length of vector is less or equal zero
//    ippStsToneMagnErr  The magn value is less than or equal to zero
//    ippStsToneFreqErr  The rFreq value is less than 0 or greater than or equal to 0.5
//                       for real tone and 1.0 for complex tone
//    ippStsTonePhaseErr The phase value is less 0 or greater or equal 2*PI
//  Parameters:
//    magn            Magnitude of the tone; that is, the maximum value
//                    attained by the wave
//    rFreq           Frequency of the tone relative to the sampling
//                    frequency. It must be in range [0.0, 0.5) for real, and
//                    [0.0, 1.0) for complex tone
//    pPhase          Phase of the tone relative to a cosinewave. It must
//                    be in range [0.0, 2*PI).
//    pDst            Pointer to the destination vector.
//    len             Length of the vector
//    hint            Suggests using specific code
//  Notes:
//    for real:  pDst[i] = magn * cos(IPP_2PI * rfreq * i + phase);
//    for cplx:  pDst[i].re = magn * cos(IPP_2PI * rfreq * i + phase);
//               pDst[i].im = magn * sin(IPP_2PI * rfreq * i + phase);
*)


  ippsTone_Direct_32f: function(pDst:PIpp32f;len:longint;magn:single;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_Direct_32fc: function(pDst:PIpp32fc;len:longint;magn:single;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_Direct_64f: function(pDst:PIpp64f;len:longint;magn:double;rFreq:double;pPhase:Pdouble;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_Direct_64fc: function(pDst:PIpp64fc;len:longint;magn:double;rFreq:double;pPhase:Pdouble;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_Direct_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_Direct_16sc: function(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;stdcall;

type

  IppToneState_16s = pointer;
  PIppToneState_16s =^IppToneState_16s;

var

(*
//  Name:                ippsToneInitAllocQ15_16s
//  Purpose:             Allocates memory for the structure IppToneState_16s,
//                       initializes it with a set of cosinwave parameters (magnitude,
//                       frequency, phase).
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Double pointer to pToneState is NULL
//    ippStsToneMagnErr  The magn value is less than or equal to zero
//    ippStsToneFreqErr  The freqQ15 value is less than 0 or greater than 16383
//    ippStsTonePhaseErr The phaseQ15 value is less than 0 or greater than 205886
//  Parameters:
//    **pToneState       Double pointer to the structure IppToneState_16s.
//    magn               Magnitude of the tone; that is, the maximum value
//                       attained by the wave.
//    rFreqQ15           Frequency of the tone relative to the sampling
//                       frequency. It must be between 0 and 16383
//    phaseQ15           Phase of the tone relative to a cosinewave. It must
//                       be between 0 and 205886.
//  Notes:
*)
  ippsToneInitAllocQ15_16s: function(var pToneState:PIppToneState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;stdcall;

(*
//  Name:                ippsToneFree_16s
//  Purpose:             Frees memory, which was allocated
//                       for the structure IppToneState_16s.
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Pointer to pToneState is NULL
//  Parameters:
//    *pToneState        Pointer to the structure IppToneState_16s.
//  Notes:
*)
  ippsToneFree: function(pToneState:PIppToneState_16s):IppStatus;stdcall;

(*
//  Name:                ippsToneGetStateSizeQ15_16s
//  Purpose:             Computes the size, in bytes, of the structure IppToneState_16s
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Pointer to pToneState size is NULL
//  Parameters:
//    *pToneStateSize    Pointer to the computed value of the size
//                       of the structure IppToneState_16s.
//  Notes:
*)
  ippsToneGetStateSizeQ15_16s: function(pToneStateSize:Plongint):IppStatus;stdcall;

(*
//  Name:                ippsToneInitQ15_16s
//  Purpose:             initializes the structure IppToneState_16s with
//                       given set of cosinewave parameters (magnitude,
//                       frequency, phase)
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Pointer to pToneState is NULL
//    ippStsToneMagnErr  The magn value is less than or equal to zero
//    ippStsToneFreqErr  The rFreqQ15 value is less than 0 or greater 16383
//    ippStsTonePhaseErr The phaseQ15 value is less than 0 or greater 205886
//  Parameters:
//    *pToneState        Pointer to the structure IppToneState_16s.
//    magn               Magnitude of the tone; that is, the maximum value
//                       attained by the wave.
//    rFreqQ15           Frequency of the tone relative to the sampling
//                       frequency. It must be between 0 and 16383
//    phaseQ15           Phase of the tone relative to a cosinewave. It must
//                       be between 0 and 205886.
//  Notes:
*)
  ippsToneInitQ15_16s: function(pToneState:PIppToneState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;stdcall;

(*
//  Name:                ippsToneQ15_16s
//  Purpose:             generates a tone
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   One of the specified pointers is NULL
//    ippStsSizeErr      len is less than or equal to 0
//  Parameters:
//    pDst               Pointer to the destination vector.
//    len                Length of the vector
//    *pToneState        Pointer to the structure IppToneState_16s.
//  Notes:
*)

  ippsToneQ15_16s: function(pDst:PIpp16s;len:longint;pToneState:PIppToneState_16s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsTriangle_Direct
//  Purpose:        generates a Triangle
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Some of pointers to input or output data are NULL
//    ippStsSizeErr       The length of vector is less or equal zero
//    ippStsTrnglMagnErr  The magn value is less or equal to zero
//    ippStsTrnglFreqErr  The rfreq value is less 0 or greater or equal 0.5
//    ippStsTrnglPhaseErr The phase value is less 0 or greater or equal 2*PI
//    ippStsTrnglAsymErr  The asym value is less -PI or greater or equal PI
//  Parameters:
//    magn            Magnitude of the Triangle; that is, the maximum value
//                    attained by the wave
//    rFreq           Frequency of the Triangle relative to the sampling
//                    frequency. It must be in range [0.0, 0.5)
//    pPhase          POinter to the phase of the Triangle relative to acosinewave. It must
//                    be in range [0.0, 2*PI)
//    asym            Asymmetry of a triangle. It must be in range [-PI,PI).
//    pDst            Pointer to destination vector.
//    len             Length of the vector
*)


  ippsTriangle_Direct_64f: function(pDst:PIpp64f;len:longint;magn:double;rFreq:double;asym:double;pPhase:Pdouble):IppStatus;stdcall;
  ippsTriangle_Direct_64fc: function(pDst:PIpp64fc;len:longint;magn:double;rFreq:double;asym:double;pPhase:Pdouble):IppStatus;stdcall;
  ippsTriangle_Direct_32f: function(pDst:PIpp32f;len:longint;magn:single;rFreq:single;asym:single;pPhase:Psingle):IppStatus;stdcall;
  ippsTriangle_Direct_32fc: function(pDst:PIpp32fc;len:longint;magn:single;rFreq:single;asym:single;pPhase:Psingle):IppStatus;stdcall;
  ippsTriangle_Direct_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:single;asym:single;pPhase:Psingle):IppStatus;stdcall;
  ippsTriangle_Direct_16sc: function(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:single;asym:single;pPhase:Psingle):IppStatus;stdcall;

type
  IppTriangleState_16s =pointer;
  PIppTriangleState_16s =^IppTriangleState_16s;

var
(*
//  Name:                ippsTriangleInitAllocQ15_16s
//  Purpose:             Allocates memory for the structure IppTriangleState_16s,
//                       initializes it with a set of wave parameters (magnitude,
//                       frequency, phase, asymmetry).
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Double pointer to pTriangleState is NULL
//    ippStsTriangleMagnErr  The magn value is less than or equal to zero
//    ippStsTriangleFreqErr  The freqQ15 value is less than 0 or greater than 16383
//    ippStsTriangleAsymErr  The phaseQ15 value is less tahn 0 or greater than 205886
//    ippStsTrianglePhaseErr The asymQ15 value is less than -102943 or greater than 102943
//  Parameters:
//    **pTriangleState   Double pointer to the structure IppTriangleState_16s.
//    magn               Magnitude of the Triangle; that is, the maximum value
//                       attained by the wave.
//    rFreqQ15           Frequency of the Triangle relative to the sampling
//                       frequency. It must be between 0 and 16383
//    phaseQ15           Phase of the Triangle relative to a wave. It must
//                       be between 0 and 205886.
//    asymQ15            Asymmetry of the Triangle relative to a wave. It must
//                       be between -102943 and 102943.
//  Notes:
*)
  ippsTriangleInitAllocQ15_16s: function(var pTriangleState:PIppTriangleState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;stdcall;



(*
//  Name:                ippsTriangleFree_16s
//  Purpose:             Frees memory, which was allocated
//                       for the structure IppTriangleState_16s.
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Pointer to pTriangleState is NULL
//  Parameters:
//    *pTriangleState    Pointer to the structure IppTriangleState_16s.
//  Notes:
*)
  ippsTriangleFree: function(pTriangleState:PIppTriangleState_16s):IppStatus;stdcall;



(*
//  Name:                ippsTriangleGetStateSizeQ15_16s
//  Purpose:             Computes the size, in bytes, of the structure IppTriangleState_16s
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Pointer to pTriangleState size is NULL
//  Parameters:
//    *pTriangleStateSize Pointer to the computed value of the size
//                        of the structure IppTriangleState_16s.
//  Notes:
*)
  ippsTriangleGetStateSizeQ15_16s: function(pTriangleStateSize:Plongint):IppStatus;stdcall;

(*
//  Name:                ippsTriangleInitQ15_16s
//  Purpose:             Initializes the structure IppTriangleState_16s
//                       with a given set of cosinewave parameters (magnitude,
//                       frequency, phase)
//  Context:
//  Returns:               IppStatus
//    ippStsNoErr          Ok
//    ippStsNullPtrErr     The pointer to pTriangleState is NULL
//    ippStsTrngleMagnErr  The magn value is less than or equal to zero
//    ippStsTrngleFreqErr  The freqQ15 value is less than 0 or greater than 16383
//    ippStsTrnglePhaseErr The phaseQ15 value is less than 0 or greater than 205886
//    ippStsTrngleAsymErr  The asymQ15 value is less than -102943 or greater than 102943
//  Parameters:
//    *pTriangleState    Pointer to the structure IppTriangleState_16s.
//    magn               Magnitude of the Triangle; that is, the maximum value
//                       attained by the wave.
//    rFreqQ15           Frequency of the Triangle relative to the sampling
//                       frequency. It must be between 0 and 16383
//    phaseQ15           Phase of the Triangle relative to a wave. It must
//                       be between 0 and 205886.
//    asymQ15            Asymmetry of the Triangle relative to a wave. It must
//                       be between -102943 and 102943.

//  Notes:
*)
  ippsTriangleInitQ15_16s: function(pTriangleState:PIppTriangleState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;stdcall;


(*
//  Name:                ippsTriangleQ15_16s
//  Purpose:             generates a Triangle
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//  Parameters:
//    pDst               The pointer to destination vector.
//    len                The length of vector
//    *pTriangleState    Pointer to the structure IppTriangleState_16s.
//  Notes:
*)
  ippsTriangleQ15_16s: function(pDst:PIpp16s;len:longint;pTriangleState:PIppTriangleState_16s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsToneQ15_Direct_16s
//  Purpose:        generates a tone
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   The pointer to the destination vector is NULL
//    ippStsSizeErr      The length of the vector is less than or equal to zero
//    ippStsToneMagnErr  The magn value is less than or equal to zero
//    ippStsToneFreqErr  The rFreqQ15 value is less than 0 or greater than 16383
//    ippStsTonePhaseErr The phaseQ15 value is less than 0 or greater than 205886

//  Parameters:
//    pDst          Pointer to the destination vector.
//    len           Length of the vector
//    magn          Magnitude of the tone; that is, the maximum value
//                  attained by the wave.It must be between 0 and 32767
//    rFreqQ15      Frequency of the tone relative to the sampling
//                  frequency. It must be between 0 and 16383
//    phaseQ15      Phase of the tone relative to a cosinewave. It must
//                  be between 0 and 205886.
*)
  ippsToneQ15_Direct_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsTriangleQ15_Direct_16s
//  Purpose:        generates a Triangle
//  Context:
//  Returns:                 IppStatus
//    ippStsNoErr            Ok
//    ippStsNullPtrErr       The pointer to the destination vectro is NULL
//    ippStsSizeErr          The length of the vector is less than or equal to zero
//    ippStsTriangleMagnErr  The magn value is less than or equal to zero
//    ippStsTriangleFreqErr  The rFfreqQ15 value is less than 0 or greater than 16383
//    ippStsTriangleAsymErr  The asymQ15 value is less than 0 or greater than 205886
//    ippStsTrianglePhaseErr The phaseQ15 value is less than -102943 or greater tahn 102943
//  Parameters:
//    pDst          Pointer to the destination vector.
//    len           Length of the vector
//    mag           Magnitude of the Triangle; that is, the maximum value
//                  attained by the wave. It must be between 0 and 32767.
//    rFreqQ15      Frequency of the Triangle relative to the sampling
//                  frequency. It must be between 0 and 16383
//    phaseQ15      The phase of the Triangle relative to a wave. It must
//                  be between 0 and 205886.
//    asymQ15       The asymmmetry of the Triangle relative to a wave. It must
//                  be between -102943 and 102943.
//  Notes:
*)
  ippsTriangleQ15_Direct_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////
//  Name:               ippsVectorRamp_8u,  ippsVectorRamp_8s,
//                      ippsVectorRamp_16u, ippsVectorRamp_16s,
//                      ippsVectorRamp_32u, ippsVectorRamp_32s,
//                      ippsVectorRamp_32f, ippsVectorRamp_64f
//  Purpose:            Creates ramp vector
//
//  Parameters:
//    pDst              A pointer to the destination vector
//    len               Vector's length
//    offset            Offset value
//    slope             Slope coefficient
//
//  Return:
//    ippStsNoErr       No error
//    ippStsNullPtrErr  pDst pointer is NULL
//    ippStsBadSizeErr  Vector's length is less or equal zero
//    ippStsNoErr       No error
//
//  Notes:              Dst[n] = offset + slope * n
//
*)
  ippsVectorRamp_8u: function(pDst:PIpp8u;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_8s: function(pDst:PIpp8s;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_16u: function(pDst:PIpp16u;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_16s: function(pDst:PIpp16s;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_32u: function(pDst:PIpp32u;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_32s: function(pDst:PIpp32s;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_32f: function(pDst:PIpp32f;len:longint;offset:single;slope:single):IppStatus;stdcall;
  ippsVectorRamp_64f: function(pDst:PIpp64f;len:longint;offset:single;slope:single):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                   Convert functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsReal
//  Purpose:    form vector with real part of the input complex vector
//  Parameters:
//    pSrc       pointer to the input complex vector
//    pDstRe     pointer to the output vector to store the real part
//    len        length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr       pointer(s) to the data is NULL
//    ippStsSizeErr          length of the vectors is less or equal zero
//    ippStsNoErr            otherwise
*)

  ippsReal_64fc: function(pSrc:PIpp64fc;pDstRe:PIpp64f;len:longint):IppStatus;stdcall;
  ippsReal_32fc: function(pSrc:PIpp32fc;pDstRe:PIpp32f;len:longint):IppStatus;stdcall;
  ippsReal_16sc: function(pSrc:PIpp16sc;pDstRe:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsImag
//  Purpose:    form vector with imaginary part of the input complex vector
//  Parameters:
//    pSrc       pointer to the input complex vector
//    pDstRe     pointer to the output vector to store the real part
//    len        length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr       pointer(s) to the data is NULL
//    ippStsSizeErr          length of the vectors is less or equal zero
//    ippStsNoErr            otherwise
*)

  ippsImag_64fc: function(pSrc:PIpp64fc;pDstIm:PIpp64f;len:longint):IppStatus;stdcall;
  ippsImag_32fc: function(pSrc:PIpp32fc;pDstIm:PIpp32f;len:longint):IppStatus;stdcall;
  ippsImag_16sc: function(pSrc:PIpp16sc;pDstIm:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCplxToReal
//  Purpose:    form the real and imaginary parts of the input complex vector
//  Parameters:
//    pSrc       pointer to the input complex vector
//    pDstRe     pointer to output vector to store the real part
//    pDstIm     pointer to output vector to store the imaginary part
//    len        length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)

  ippsCplxToReal_64fc: function(pSrc:PIpp64fc;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;stdcall;
  ippsCplxToReal_32fc: function(pSrc:PIpp32fc;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCplxToReal_16sc: function(pSrc:PIpp16sc;pDstRe:PIpp16s;pDstIm:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRealToCplx
//  Purpose:    form complex vector from the real and imaginary components
//  Parameters:
//    pSrcRe     pointer to the input vector with real part, may be NULL
//    pSrcIm     pointer to the input vector with imaginary part, may be NULL
//    pDst       pointer to the output complex vector
//    len        length of the vectors
//  Return:
//    ippStsNullPtrErr        pointer to the destination data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
//
//  Notes:      one of the two input pointers may be NULL. In this case
//              the corresponding values of the output complex elements is 0
*)

  ippsRealToCplx_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsRealToCplx_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsRealToCplx_16s: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16sc;len:longint):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Names:       ippsConj, ippsConjFlip
//  Purpose:     complex conjugate data vector
//  Parameters:
//    pSrc               pointer to the input vetor
//    pDst               pointer to the output vector
//    len                length of the vectors
//  Return:
//    ippStsNullPtrErr      pointer(s) to the data is NULL
//    ippStsSizeErr         length of the vectors is less or equal zero
//    ippStsNoErr           otherwise
//  Notes:
//    the ConjFlip version conjugates and stores result in reverse order
*)

  ippsConj_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsConj_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsConj_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsConj_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsConj_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsConj_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsConjFlip_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsConjFlip_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsConjFlip_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsConjCcs_64fc_I: function(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_32fc_I: function(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_16sc_I: function(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_64fc: function(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_16sc: function(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_64fc_I: function(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_32fc_I: function(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_16sc_I: function(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_64fc: function(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_16sc: function(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_64fc_I: function(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_32fc_I: function(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_16sc_I: function(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_64fc: function(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_16sc: function(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert
//  Purpose:    Converts integer data to floating point data
//  Parameters:
//    pSrc        pointer to integer data to be converted
//    pDst        pointer to the destination vector
//    len         length of the vectors
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)
  ippsConvert_8s16s: function(pSrc:PIpp8s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsConvert_16s32s: function(pSrc:PIpp16s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsConvert_32s16s: function(pSrc:PIpp32s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsConvert_8s32f: function(pSrc:PIpp8s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_8u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_16s32f: function(pSrc:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_16u32f: function(pSrc:PIpp16u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_32s64f: function(pSrc:PIpp32s;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsConvert_32s32f: function(pSrc:PIpp32s;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert
//  Purpose:    convert floating point data to integer data
//  Parameters:
//    pSrc         pointer to the input floating point data to be converted
//    pDst         pointer to destination vector
//    len          length of the vectors
//    rndmode      rounding mode, rndZero or rndNear
//    scaleFactor  scale factor value
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
//  Note:
//    an out-of-range result will be saturated
*)

  ippsConvert_32f8s_Sfs: function(pSrc:PIpp32f;pDst:PIpp8s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f8u_Sfs: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f16s_Sfs: function(pSrc:PIpp32f;pDst:PIpp16s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f16u_Sfs: function(pSrc:PIpp32f;pDst:PIpp16u;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f32s_Sfs: function(pSrc:PIpp64f;pDst:PIpp32s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f32s_Sfs: function(pSrc:PIpp32f;pDst:PIpp32s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert_32f64f
//  Purpose:    Converts floating point data Ipp32f
//              to floating point data Ipp64f
//  Parameters:
//    pSrc          pointer to the input vector
//    pDst          pointer to the output vector
//    len           length of the vectors
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)

  ippsConvert_32f64f: function(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert_64f32f
//  Purpose:    Converts floating point data Ipp64f
//              to floating point data Ipp32f
//  Parameters:
//    pSrc          pointer to the input vector
//    pDst          pointer to the output vector
//    len           length of the vectors
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
//  Note:
//    an out-of-range result will be saturated
*)

  ippsConvert_64f32f: function(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert
//  Purpose:    Converts integer data to floating point data
//  Parameters:
//    pSrc          pointer to integer data to be converted
//    pDst          pointer to the destination vector
//    len           length of the vectors
//    scaleFactor   scale factor value
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)

  ippsConvert_16s32f_Sfs: function(pSrc:PIpp16s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_16s64f_Sfs: function(pSrc:PIpp16s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32s32f_Sfs: function(pSrc:PIpp32s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32s64f_Sfs: function(pSrc:PIpp32s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32s16s_Sfs: function(pSrc:PIpp32s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert
//  Purpose:    Converts 24u data to 32u or 32f data.
//              Converts 32u or 32f data to 24u data.
//              Converts 24s data to 32s or 32f data.
//              Converts 32s or 32f data to 24s data.
//  Parameters:
//    pSrc          pointer to the input vector
//    pDst          pointer to the output vector
//    len           length of the vectors
//    scaleFactor   scale factor value
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)

  ippsConvert_24u32u: function(pSrc:PIpp8u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsConvert_32u24u_Sfs: function(pSrc:PIpp32u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_24u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_32f24u_Sfs: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_24s32s: function(pSrc:PIpp8u;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsConvert_32s24s_Sfs: function(pSrc:PIpp32s;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_24s32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_32f24s_Sfs: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;


type
   Ipp16f = Ipp16s;
   PIpp16f =^Ipp16f;
var
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert_16s16f
//  Purpose:    Converts integer data to floating point data
//  Parameters:
//    pSrc        pointer to integer data to be converted
//    pDst        pointer to the destination vector
//    len         length of the vectors
//    rndmode      rounding mode, rndZero or rndNear
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)

  ippsConvert_16s16f: function(pSrc:PIpp16s;pDst:PIpp16f;len:longint;rndmode:IppRoundMode):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert_16f16s_Sfs
//  Purpose:    convert floating point data to integer data
//  Parameters:
//    pSrc         pointer to the input floating point data to be converted
//    pDst         pointer to destination vector
//    len          length of the vectors
//    rndmode      rounding mode, rndZero or rndNear
//    scaleFactor  scale factor value
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
//  Note:
//    an out-of-range result will be saturated
*)
  ippsConvert_16f16s_Sfs: function(pSrc:PIpp16f;pDst:PIpp16s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert_32f16f
//  Purpose:    Converts floating point data Ipp32f
//              to floating point data Ipp16f
//  Parameters:
//    pSrc          pointer to the input vector
//    pDst          pointer to the output vector
//    len           length of the vectors
//    rndmode      rounding mode, rndZero or rndNear
//  Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)
  ippsConvert_32f16f: function(pSrc:PIpp32f;pDst:PIpp16f;len:longint;rndmode:IppRoundMode):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert_16f32f
//  Purpose:    Converts floating point data Ipp16f
//              to floating point data Ipp32f
//  Parameters:
//    pSrc          pointer to the input vector
//    pDst          pointer to the output vector
//    len           length of the vectors
Return:
//    ippStsNullPtrErr    pointer(s) to the data is NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)
  ippsConvert_16f32f: function(pSrc:PIpp16f;pDst:PIpp32f;len:longint):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold
//  Purpose:    execute threshold operation on every element of the vector
//  Parameters:
//    level      level of the threshold operation
//    pSrcDst    pointer to the vector for in-place operation
//    pSrc       pointer to the input vector
//    pDst       pointer to the output vector
//    len        length of the vectors
//    relOp      comparison mode, cmpLess or cmpGreater
//  Return:
//    ippStsNullPtrErr          pointer(s) to the data is NULL
//    ippStsSizeErr             length of the vectors is less or equal zero
//    ippStsThreshNegLevelErr   negative level value in complex operation
//    ippStsNoErr               otherwise
//  Notes:
//  real data
//    cmpLess    : pDst[n] = pSrc[n] < level ? level : pSrc[n];
//    cmpGreater : pDst[n] = pSrc[n] > level ? level : pSrc[n];
//  complex data
//    cmpLess    : pDst[n] = abs(pSrc[n]) < level ? pSrc[n]*k : pSrc[n];
//    cmpGreater : pDst[n] = abs(pSrc[n]) > level ? pSrc[n]*k : pSrc[n];
//    where k = level / abs(pSrc[n]);
*)

  ippsThreshold_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;

  ippsThreshold_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThresholdLT
//              ippsThresholdGT
//  Purpose:    execute threshold operation on every element of the vector,
//              "less than" for ippsThresoldLT
//              "greater then for ippsThresholdGT
//  Parameters:
//    pSrcDst    pointer to the vector for in-place operation
//    pSrc       pointer to the input vector
//    pDst       pointer to the output vector
//    len         length of the vectors
//    level      level of the threshold operation
//  Return:
//    ippStsNullPtrErr          pointer(s) to the data is NULL
//    ippStsSizeErr             length of the vectors is less or equal zero
//    ippStsThreshNegLevelErr   negative level value in complex operation
//    ippStsNoErr               otherwise
*)
  ippsThreshold_LT_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;

  ippsThreshold_LT_32s_I: function(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LT_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;

  ippsThreshold_GT_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThresholdLTValue
//              ippsThresholdGTValue
//  Purpose:    execute threshold operation on every element of the vector with
//              replace on value,
//              "less than" for ippsThresoldLTValue
//              "greater then for ippsThresholdGTValue
//  Parameters:
//    pSrcDst    pointer to the vector for in-place operation
//    pSrc       pointer to the input vector
//    pDst       pointer to the output vector
//    len         length of the vectors
//    level      level of the threshold operation
//    value      value of replace
//  Return:
//    ippStsNullPtrErr          pointer(s) to the data is NULL
//    ippStsSizeErr             length of the vectors is less or equal zero
//    ippStsThreshNegLevelErr   negative level value in complex operation
//    ippStsNoErr               otherwise
*)
  ippsThreshold_LTVal_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTVal_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_LTVal_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTVal_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_LTVal_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTVal_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_LTVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTVal_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_LTVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTVal_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_LTVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTVal_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_GTVal_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GTVal_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_GTVal_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GTVal_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_GTVal_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GTVal_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_GTVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GTVal_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_GTVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GTVal_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_GTVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GTVal_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsThresholdLTInv
//
//  Purpose:    replace elements of vector values by their inversion after
//              threshold operation
//  Parameters:
//    level      level of threshold operation
//    pSrcDst    pointer to the vector in in-place operation
//    pSrc       pointer to the source vector
//    pDst       pointer to the destination vector
//    len        length of the vectors
//  Return:
//    ippStsNullPtrErr              pointer(s) to the data is NULL
//    ippStsSizeErr                 length of the vector is less or equal zero
//    ippStsThreshNegLevelErr       negative level value
//    ippStsInvZero                 level value and source element value are zero
//    ippStsNoErr                   otherwise
*)

  ippsThreshold_LTInv_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTInv_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;

  ippsThreshold_LTInv_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTInv_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////// *)


  ippsThreshold_LTValGTVal_32f_I: function(pSrcDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_64f_I: function(pSrcDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;stdcall;

  ippsThreshold_LTValGTVal_16s_I: function(pSrcDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsCartToPolar
//
//  Purpose:    Convert cartesian coordinate to polar. Input data are formed as
//              a complex vector.
//
//  Parameters:
//   pSrc          an input complex vector
//   pDstMagn      an output vector to store the magnitude components
//   pDstPhase     an output vector to store the phase components (in radians)
//   len           a length of the array
//  Return:
//   ippStsNoErr           Ok
//   ippStsNullPtrErr      Some of pointers to input or output data are NULL
//   ippStsSizeErr         The length of the arrays is less or equal zero
//
*)

  ippsCartToPolar_32fc: function(pSrc:PIpp32fc;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCartToPolar_64fc: function(pSrc:PIpp64fc;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsCartToPolar
//
//  Purpose:    Convert cartesian coordinate to polar. Input data are formed as
//              two real vectors.
//
//  Parameters:
//   pSrcRe       an input vector containing the coordinates X
//   pSrcIm       an input vector containing the coordinates Y
//   pDstMagn     an output vector to store the magnitude components
//   pDstPhase    an output vector to store the phase components (in radians)
//   len          a length of the array
//  Return:
//   ippStsNoErr           Ok
//   ippStsNullPtrErr      Some of pointers to input or output data are NULL
//   ippStsSizeErr         The length of the arrays is less or equal zero
//
*)

  ippsCartToPolar_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCartToPolar_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsPolarToCart
//
//  Purpose:    Convert polar coordinate to cartesian. Output data are formed as
//              a complex vector.
//
//  Parameters:
//   pDstMagn      an input vector containing the magnitude components
//   pDstPhase     an input vector containing the phase components(in radians)
//   pDst          an output complex vector to store the cartesian coordinates
//   len           a length of the arrays
//  Return:
//   ippStsNoErr           Ok
//   ippStsNullPtrErr      Some of pointers to input or output data are NULL
//   ippStsSizeErr         The length of the arrays is less or equal zero
//
*)

  ippsPolarToCart_32fc: function(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsPolarToCart_64fc: function(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsPolarToCart
//
//  Purpose:    Convert polar coordinate to cartesian. Output data are formed as
//              two real vectors.
//
//  Parameters:
//   pDstMagn     an input vector containing the magnitude components
//   pDstPhase    an input vector containing the phase components(in radians)
//   pSrcRe       an output complex vector to store the coordinates X
//   pSrcIm       an output complex vector to store the coordinates Y
//   len          a length of the arrays
//  Return:
//   ippStsNoErr           Ok
//   ippStsNullPtrErr      Some of pointers to input or output data are NULL
//   ippStsSizeErr         The length of the arrays is less or equal zero
//
*)

  ippsPolarToCart_32f: function(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPolarToCart_64f: function(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                          Companding functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsALawToLin
//  Purpose:    convert from A-Law to linear PCM value
//  Parameters:
//    pSrc        pointer to the input vector containing A-Law values
//    pDst        pointer to the output vector for store linear PCM values
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
  ippsALawToLin_8u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsALawToLin_8u16s: function(pSrc:PIpp8u;pDst:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMuLawToLin
//  Purpose:    convert from Mu-Law to linear PCM value
//  Parameters:
//    pSrc        pointer to the input vector containing Mu-Law values
//    pDst        pointer to the output vector for store linear PCM values
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
  ippsMuLawToLin_8u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMuLawToLin_8u16s: function(pSrc:PIpp8u;pDst:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsLinToALaw
//  Purpose:    convert from linear PCM to A-Law value
//  Parameters:
//    pSrc        pointer to the input vector containing linear PCM values
//    pDst        pointer to the output vector for store A-Law values
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
  ippsLinToALaw_32f8u: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsLinToALaw_16s8u: function(pSrc:PIpp16s;pDst:PIpp8u;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMuLawToLin
//  Purpose:    convert from linear PCM to Mu-Law value
//  Parameters:
//    pSrc        pointer to the input vector containing linear PCM values
//    pDst        pointer to the output vector for store Mu-Law values
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
  ippsLinToMuLaw_32f8u: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsLinToMuLaw_16s8u: function(pSrc:PIpp16s;pDst:PIpp8u;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsALawToMuLaw, ippsMuLawToALaw
//  Purpose:    convert from A-Law to Mu-Law and vice-versa
//  Parameters:
//    pSrc        pointer to the input vector containing A-Law or Mu-Law values
//    pDst        pointer to the output vector for store Mu-Law or A-Law values
//    len         length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)
  ippsALawToMuLaw_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsMuLawToALaw_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsPreemphasize_32f
//  Purpose:
//    Compute the preemphasizes a single precision real signal.
//  Parameters:
//    pSrcDst  pointer to the vector for in-place operation.
//    len      length of  the input vector.
//    val      The multiplier to be used in the preemphasis difference equation
//             y(n) = x(n) - a * x(n-1)  where y  is the preemphasized  output
//             and x is the input. Usually a value  of 0.95  is  used for speech
//             audio  signals.
//  Return:
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Some of pointers to input or output data are NULL
//    ippStsSizeErr       The length of the arrays is less or equal zero
*)
  ippsPreemphasize_32f: function(pSrcDst:PIpp32f;len:longint;val:Ipp32f):IppStatus;stdcall;
  ippsPreemphasize_16s: function(pSrcDst:PIpp16s;len:longint;val:Ipp32f):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFlip
//  Purpose:    dst[i] = src[len-i-1], i=0..len-1
//  Parameters:
//    pSrc      pointer to the input vector
//    pDst      pointer to the output vector
//    len       length of the vectors, number of items
//  Return:
//    ippStsNullPtrErr        pointer(s) to the data is NULL
//    ippStsSizeErr           length of the vectors is less or equal zero
//    ippStsNoErr             otherwise
*)

  ippsFlip_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsFlip_8u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsFlip_16u: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsFlip_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsFlip_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsFlip_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsFlip_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsFlip_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsUpdateLinear_16s32s_I
//  Purpose:    Calc Update Linear value
//  Return:
//   IPP_NO_ERR                 Ok
//   IPP_NULL_PTR_ERR           Pointer to pSrc or pointer to pSrcDst is NULL
//   IPP_BADSIZE_ERR            The length of the array is less or equal zero
//  Parameters:
//   pSrc           pointer to vector
//   len            a length of the array
//   pSrcDst        pointer to input and output
//   srcShiftRight  shiftright of src (0<=srcShiftRight<=15)
//   alpha          weight
//   hint           code specific use hints
//
*)
  ippsUpdateLinear_16s32s_I: function(pSrc:PIpp16s;len:longint;pSrcDst:PIpp32s;srcShiftRight:longint;alpha:Ipp16s;hint:IppHintAlgorithm):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsUpdatePower_16s32s_I
//  Purpose:    Calc Update Power value
//  Return:
//   IPP_NO_ERR                 Ok
//   IPP_NULL_PTR_ERR           Pointer to pSrc or pointer to pSrcDst is NULL
//   IPP_BADSIZE_ERR            The length of the array is less or equal zero
//  Parameters:
//   pSrc           pointer to vector
//   len            a length of the array
//   pSrcDst        pointer to input and output
//   srcShiftRight  shiftright of src (0<=srcShiftRight<=31)
//   alpha          weight
//   hint           code specific use hints
//
*)
  ippsUpdatePower_16s32s_I: function(pSrc:PIpp16s;len:longint;pSrcDst:PIpp32s;srcShiftRight:longint;alpha:Ipp16s;hint:IppHintAlgorithm):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsJoin_32f16s_D2L
//  Purpose:    Join of vectors.
//  Parameters:
//      pSrc        pointer to pointers to the input vectors
//      pDst        pointer to the output vector
//      nChannels   number of channels
//      chanlen     length of the channel
//  Return:
//      ippStsNullPtrErr        pointer(s) to the data is NULL
//      ippStsSizeErr           nChannels or chanlen are less or equal zero
//      ippStsNoErr             otherwise
//
*)

  ippsJoin_32f16s_D2L: function(var pSrc:PIpp32f;nChannels:longint;chanLen:longint;pDst:PIpp16s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSwapBytes
//  Purpose:    switches from a "big endian" order to the "little endian" order and vice-versa
//  Parameters:
//    pSrc                 pointer to the source vector
//    pSrcDst              pointer to the source/destination vector
//    pDst                 pointer to the destination vector
//    len                  length of the vectors
//  Return:
//    ippStsNullPtrErr     pointer to the vector is NULL
//    ippStsSizeErr        length of the vectors is less or equal zero
//    ippStsNoErr          otherwise
*)

  ippsSwapBytes_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_24u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_32u_I: function(pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_16u: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_24u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_32u: function(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Arithmetic functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippsAdd, ippsSub, ippsMul
//
//  Purpose:    add, subtract and multiply operations upon every element of
//              the source vector
//  Arguments:
//    pSrc                 pointer to the source vector
//    pSrcDst              pointer to the source/destination vector
//    pSrc1                pointer to the first source vector
//    pSrc2                pointer to the second source vector
//    pDst                 pointer to the destination vector
//    len                  length of the vectors
//    scaleFactor          scale factor value
//  Return:
//    ippStsNullPtrErr     pointer(s) to the data is NULL
//    ippStsSizeErr        length of the vectors is less or equal zero
//    ippStsNoErr          otherwise
//  Note:
//    AddC(X,v,Y)    :  Y[n] = X[n] + v
//    MulC(X,v,Y)    :  Y[n] = X[n] * v
//    SubC(X,v,Y)    :  Y[n] = X[n] - v
//    SubCRev(X,v,Y) :  Y[n] = v - X[n]
//    Sub(X,Y)       :  Y[n] = Y[n] - X[n]
//    Sub(X,Y,Z)     :  Z[n] = Y[n] - X[n]
*)

  ippsAddC_16s_I: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSubC_16s_I: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMulC_16s_I: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAddC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAddC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubCRev_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMulC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAddC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAddC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSubC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubCRev_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMulC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsMulC_32f16s_Sfs: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_Low_32f16s: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint):IppStatus;stdcall;


  ippsAddC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsAddC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAddC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubCRev_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMulC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAddC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAddC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSubC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubCRev_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMulC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsAddC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsAdd_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSub_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMul_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAdd_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAdd_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSub_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSub_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMul_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMul_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAdd_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAdd_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSub_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSub_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMul_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMul_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;


  ippsAdd_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32sc_ISfs: function(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32sc_ISfs: function(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32sc_ISfs: function(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_8u16u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsMul_8u16u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAdd_16s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSub_16s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMul_16s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAdd_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAdd_32u: function(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsAdd_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSub_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMul_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAdd_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAdd_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSub_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSub_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMul_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMul_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAdd_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAdd_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSub_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSub_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMul_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMul_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsAdd_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16u16s_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;


  ippsMul_32s32sc_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32s32sc_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsAddProduct
//  Purpose:    multiplies elements of two source vectors and adds product to
//              the accumulator vector
//  Parameters:
//    pSrc1                pointer to the first source vector
//    pSrc2                pointer to the second source vector
//    pSrcDst              pointer to the source/destination (accumulator) vector
//    len                  length of the vectors
//    scaleFactor          scale factor value
//  Return:
//    ippStsNullPtrErr     pointer to the vector is NULL
//    ippStsSizeErr        length of the vectors is less or equal zero
//    ippStsNoErr          otherwise
//
//  Notes:                 pSrcDst[n] = pSrcDst[n] + pSrc1[n] * pSrc2[n], n=0,1,2,..len-1.
*)

  ippsAddProduct_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddProduct_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddProduct_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddProduct_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAddProduct_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsAddProduct_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAddProduct_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSqr
//  Purpose:    compute square value for every element of the source vector
//  Parameters:
//    pSrcDst          pointer to the source/destination vector
//    pSrc             pointer to the input vector
//    pDst             pointer to the output vector
//    len              length of the vectors
//   scaleFactor       scale factor value
//  Return:
//    ippStsNullPtrErr    pointer(s) the source data NULL
//    ippStsSizeErr       length of the vectors is less or equal zero
//    ippStsNoErr         otherwise
*)
  ippsSqr_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqr_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqr_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqr_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsSqr_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqr_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqr_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqr_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsSqr_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsSqr_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_8u_ISfs: function(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_8u_Sfs: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16u_ISfs: function(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16u_Sfs: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDiv
//
//  Purpose:    divide every element of the source vector by the scalar value
//              or by corresponding element of the second source vector
//  Arguments:
//    val               the divisor value
//    pSrc              pointer to the divisor source vector
//    pSrc1             pointer to the divisor source vector
//    pSrc2             pointer to the dividend source vector
//    pDst              pointer to the destination vector
//    pSrcDst           pointer to the source/destination vector
//    len               vector's length, number of items
//    scaleFactor       scale factor parameter value
//  Return:
//    ippStsNullPtrErr     pointer(s) to the data vector is NULL
//    ippStsSizeErr        length of the vector is less or equal zero
//    ippStsDivByZeroErr   the scalar divisor value is zero
//    ippStsDivByZero      Warning status if an element of divisor vector is
//                      zero. If the dividend is zero then result is
//                      NaN, if the dividend is not zero then result
//                      is Infinity with correspondent sign. The
//                      execution is not aborted. For the integer operation
//                      zero instead of NaN and the corresponding bound
//                      values instead of Infinity
//    ippStsNoErr          otherwise
//  Note:
//    DivC(v,X,Y)  :    Y[n] = X[n] / v
//    DivC(v,X)    :    X[n] = X[n] / v
//    Div(X,Y)     :    Y[n] = Y[n] / X[n]
//    Div(X,Y,Z)   :    Z[n] = Y[n] / X[n]
*)

  ippsDiv_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDiv_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDiv_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDiv_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsDiv_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsDivC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDivC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDivC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDivC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsDivC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsDiv_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDiv_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDiv_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDiv_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsDiv_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsDiv_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsDiv_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;ScaleFactor:longint):IppStatus;stdcall;


  ippsDivC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDivC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDivC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDivC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsDivC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsDivCRev_16u: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsDivCRev_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDivCRev_16u_I: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsDivCRev_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSqrt
//  Purpose:    compute square root value for every element of the source vector
//   pSrc                 pointer to the source vector
//   pDst                 pointer to the destination vector
//   pSrcDst              pointer to the source/destination vector
//   len                  length of the vector(s), number of items
//   scaleFactor          scale factor value
//  Return:
//   ippStsNullPtrErr        pointer to vector is NULL
//   ippStsSizeErr           length of the vector is less or equal zero
//   ippStsSqrtNegArg        negative value in real sequence
//   ippStsNoErr             otherwise
*)
  ippsSqrt_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqrt_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqrt_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqrt_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsSqrt_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqrt_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqrt_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqrt_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsSqrt_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsSqrt_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsSqrt_64s_ISfs: function(pSrcDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_64s_Sfs: function(pSrc:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsSqrt_8u_ISfs: function(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_8u_Sfs: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16u_ISfs: function(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16u_Sfs: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsCubrt
//  Purpose:    Compute cube root of every elements of the source vector
//  Parameters:
//   pSrc                 pointer to the source vector
//   pDst                 pointer to the destination vector
//   len                  length of the vector(s)
//   ScaleFactor          scale factor value
//  Return:
//   ippStsNullPtrErr        pointer(s) to the data vector is NULL
//   ippStsSizeErr           length of the vector(s) is less or equal 0
//   ippStsNoErr             otherwise
*)

  ippsCubrt_32s16s_Sfs: function(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;sFactor:longint):IppStatus;stdcall;
  ippsCubrt_32f: function(pSrc:PIpp32f;pDst:PIpp32f;Len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsAbs
//  Purpose:    compute absolute value of each element of the source vector
//  Parameters:
//   pSrcDst            pointer to the source/destination vector
//   pSrc               pointer to the source vector
//   pDst               pointer to the destination vector
//   len                length of the vector(s), number of items
//  Return:
//   ippStsNullPtrErr      pointer(s) to data vector is NULL
//   ippStsSizeErr         length of a vector is less or equal 0
//   ippStsNoErr           otherwise
*)
  ippsAbs_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAbs_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAbs_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;

  ippsAbs_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAbs_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAbs_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;

  ippsAbs_32s_I: function(pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsAbs_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsMagnitude
//  Purpose:    compute magnitude of every complex element of the source
//  Parameters:
//   pSrcDst            pointer to the source/destination vector
//   pSrc               pointer to the source vector
//   pDst               pointer to the destination vector
//   len                length of the vector(s), number of items
//   scaleFactor        scale factor value
//  Return:
//   ippStsNullPtrErr      pointer(s) to data vector is NULL
//   ippStsSizeErr         length of a vector is less or equal 0
//   ippStsNoErr           otherwise
//  Notes:
//         dst = sqrt( src.re^2 + src.im^2 )
*)
  ippsMagnitude_32fc: function(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_64fc: function(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMagnitude_16sc32f: function(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMagnitude_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMagnitude_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMagnitude_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsMagnitude_16s32f: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;

  ippsMagSquared_32sc32s_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsExp
//  Purpose:    compute exponent value for all elements of the source vector
//  Parameters:
//   pSrcDst            pointer to the source/destination vector
//   pSrc               pointer to the source vector
//   pDst               pointer to the destination vector
//   len                length of the vector(s)
//   scaleFactor        scale factor value
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data vector is NULL
//   ippStsSizeErr         length of the vector(s) is less or equal 0
//   ippStsNoErr           otherwise
*)
  ippsExp_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsExp_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsExp_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_32s_ISfs: function(pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_64s_ISfs: function(pSrcDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsExp_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsExp_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsExp_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_64s_Sfs: function(pSrc:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsExp_32f64f: function(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsLn
//  Purpose:    compute natural logarithm of every elements of the source vector
//  Parameters:
//   pSrcDst              pointer to the source/destination vector
//   pSrc                 pointer to the source vector
//   pDst                 pointer to the destination vector
//   len                  length of the vector(s)
//   ScaleFactor          scale factor value
//  Return:
//   ippStsNullPtrErr        pointer(s) to the data vector is NULL
//   ippStsSizeErr           length of the vector(s) is less or equal 0
//   ippStsLnZeroArg         zero value in the source vector
//   ippStsLnNegArg          negative value in the source vector
//   ippStsNoErr             otherwise
//  Notes:
//                Ln( x<0 ) = NaN
//                Ln( 0 ) = -Inf
*)

  ippsLn_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsLn_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsLn_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsLn_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsLn_64f32f: function(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;stdcall;

  ippsLn_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsLn_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsLn_32s16s_Sfs: function(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsLn_32s_ISfs: function(pSrcDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsLn_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ipps10Log10_32s_ISfs
//              ipps10Log10_32s_Sfs
//
//  Purpose:    compute decimal logarithm multiplied by 10 of every elements
//              of the source vector (for integer only).
//
//  Parameters:
//   pSrcDst              pointer to the source/destination vector
//   pSrc                 pointer to the source vector
//   pDst                 pointer to the destination vector
//   Len                  length of the vector(s)
//   ScaleFactor          scale factor value
//  Return:
//   ippStsNullPtrErr     pointer(s) to the data vector is NULL
//   ippStsSizeErr        length of the vector(s) is less or equal 0
//   ippStsLnZeroArg      zero value in the source vector
//   ippStsLnNegArg       negative value in the source vector
//   ippStsNoErr          otherwise
//
*)
  ipps10Log10_32s_ISfs: function(pSrcDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;stdcall;
  ipps10Log10_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSumLn
//  Purpose:    computes sum of natural logarithm every elements of the source vector
//  Parameters:
//   pSrc                 pointer to the source vector
//   pSum                 pointer to the result
//   len                  length of the vector
//  Return:
//   ippStsNullPtrErr     pointer(s) to the data vector is NULL
//   ippStsSizeErr        length of the vector(s) is less or equal 0
//   ippStsLnZeroArg      zero value in the source vector
//   ippStsLnNegArg       negative value in the source vector
//   ippStsNoErr          otherwise
*)


  ippsSumLn_32f: function(pSrc:PIpp32f;len:longint;pSum:PIpp32f):IppStatus;stdcall;
  ippsSumLn_64f: function(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;stdcall;
  ippsSumLn_32f64f: function(pSrc:PIpp32f;len:longint;pSum:PIpp64f):IppStatus;stdcall;
  ippsSumLn_16s32f: function(pSrc:PIpp16s;len:longint;pSum:PIpp32f):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSortAscend, ippsSortDescend
//
//  Purpose:    Execute sorting of all elemens of the vector.
//              ippsSortAscend  is sorted in increasing order.
//              ippsSortDescend is sorted in decreasing order.
//  Arguments:
//    pSrcDst              pointer to the source/destination vector
//    len                  length of the vector
//  Return:
//    ippStsNullPtrErr     pointer to the data is NULL
//    ippStsSizeErr        length of the vector is less or equal zero
//    ippStsNoErr          otherwise
*)

  ippsSortAscend_8u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSortAscend_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSortAscend_32s_I: function(pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsSortAscend_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSortAscend_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsSortDescend_8u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSortDescend_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSortDescend_32s_I: function(pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsSortDescend_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSortDescend_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;





(* /////////////////////////////////////////////////////////////////////////////
//                  Vector Measures Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSum
//  Purpose:    sum all elements of the source vector
//  Parameters:
//   pSrc                pointer to the source vector
//   pSum                pointer to the result
//   len                 length of the vector
//   scaleFactor         scale factor value
//  Return:
//   ippStsNullPtrErr       pointer to the vector or result is NULL
//   ippStsSizeErr          length of the vector is less or equal 0
//   ippStsNoErr            otherwise
*)
  ippsSum_32f: function(pSrc:PIpp32f;len:longint;pSum:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsSum_64f: function(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;stdcall;
  ippsSum_32fc: function(pSrc:PIpp32fc;len:longint;pSum:PIpp32fc;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsSum_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_16sc32sc_Sfs: function(pSrc:PIpp16sc;len:longint;pSum:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_16s_Sfs: function(pSrc:PIpp16s;len:longint;pSum:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;pSum:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_32s_Sfs: function(pSrc:PIpp32s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;stdcall;

  ippsSum_64fc: function(pSrc:PIpp64fc;len:longint;pSum:PIpp64fc):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsMean
//  Purpose:    compute average value of all elements of the source vector
//  Parameters:
//   pSrc                pointer to the source vector
//   pMean               pointer to the result
//   len                 length of the source vector
//   scaleFactor         scale factor value
//  Return:
//   ippStsNullPtrErr       pointer(s) to the vector or the result is NULL
//   ippStsSizeErr          length of the vector is less or equal 0
//   ippStsNoErr            otherwise
*)
  ippsMean_32f: function(pSrc:PIpp32f;len:longint;pMean:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsMean_32fc: function(pSrc:PIpp32fc;len:longint;pMean:PIpp32fc;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsMean_64f: function(pSrc:PIpp64f;len:longint;pMean:PIpp64f):IppStatus;stdcall;
  ippsMean_16s_Sfs: function(pSrc:PIpp16s;len:longint;pMean:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsMean_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;pMean:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsMean_64fc: function(pSrc:PIpp64fc;len:longint;pMean:PIpp64fc):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsStdDev
//  Purpose:    compute standard deviation value of all elements of the vector
//  Parameters:
//   pSrc               pointer to the vector
//   len                length of the vector
//   pStdDev            pointer to the result
//   scaleFactor        scale factor value
//  Return:
//   ippStsNoErr           Ok
//   ippStsNullPtrErr      pointer to the vector or the result is NULL
//   ippStsSizeErr         length of the vector is less than 2
//  Functionality:stdcall;
//         std = sqrt( sum( (x[n] - mean(x))^2, n=0..len-1 ) / (len-1) )
*)
  ippsStdDev_32f: function(pSrc:PIpp32f;len:longint;pStdDev:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsStdDev_64f: function(pSrc:PIpp64f;len:longint;pStdDev:PIpp64f):IppStatus;stdcall;

  ippsStdDev_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pStdDev:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsStdDev_16s_Sfs: function(pSrc:PIpp16s;len:longint;pStdDev:PIpp16s;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsMax
//  Purpose:    find maximum value among all elements of the source vector
//  Parameters:
//   pSrc                 pointer to the source vector
//   pMax                 pointer to the result
//   len                  length of the vector
//  Return:
//   ippStsNullPtrErr        pointer(s) to the vector or the result is NULL
//   ippStsSizeErr           length of the vector is less or equal 0
//   ippStsNoErr             otherwise
*)
  ippsMax_32f: function(pSrc:PIpp32f;len:longint;pMax:PIpp32f):IppStatus;stdcall;
  ippsMax_64f: function(pSrc:PIpp64f;len:longint;pMax:PIpp64f):IppStatus;stdcall;
  ippsMax_16s: function(pSrc:PIpp16s;len:longint;pMax:PIpp16s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:       ippsMaxIndx
//
//  Purpose:    find element with max value and return the value and the index
//  Parameters:
//   pSrc           pointer to the input vector
//   len            length of the vector
//   pMax           address to place max value found
//   pIndx          address to place index found, may be NULL
//  Return:
//   ippStsNullPtrErr        pointer(s) to the data is NULL
//   ippStsSizeErr           length of the vector is less or equal zero
//   ippStsNoErr             otherwise
*)

  ippsMaxIndx_16s: function(pSrc:PIpp16s;len:longint;pMax:PIpp16s;pIndx:Plongint):IppStatus;stdcall;
  ippsMaxIndx_32f: function(pSrc:PIpp32f;len:longint;pMax:PIpp32f;pIndx:Plongint):IppStatus;stdcall;
  ippsMaxIndx_64f: function(pSrc:PIpp64f;len:longint;pMax:PIpp64f;pIndx:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsMin
//  Purpose:    find minimum value among all elements of the source vector
//  Parameters:
//   pSrc                 pointer to the source vector
//   pMin                 pointer to the result
//   len                  length of the vector
//  Return:
//   ippStsNullPtrErr        pointer(s) to the vector or the result is NULL
//   ippStsSizeErr           length of the vector is less or equal 0
//   ippStsNoErr             otherwise
*)
  ippsMin_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f):IppStatus;stdcall;
  ippsMin_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f):IppStatus;stdcall;
  ippsMin_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:       ippsMinIndx
//
//  Purpose:    find element with min value and return the value and the index
//  Parameters:
//   pSrc           pointer to the input vector
//   len            length of the vector
//   pMin           address to place min value found
//   pIndx          address to place index found, may be NULL
//  Return:
//   ippStsNullPtrErr        pointer(s) to the data is NULL
//   ippStsSizeErr           length of the vector is less or equal zero
//   ippStsNoErr             otherwise
*)
  ippsMinIndx_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pIndx:Plongint):IppStatus;stdcall;
  ippsMinIndx_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pIndx:Plongint):IppStatus;stdcall;
  ippsMinIndx_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pIndx:Plongint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:              ippsMinEvery, ippsMaxEvery
//  Purpose:            calculation min/max value for every element of two vectors
//  Parameters:
//   pSrc               pointer to input vector
//   pSrcDst            pointer to input/output vector
//   len                vector's length
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data is NULL
//   ippStsSizeErr         vector`s length is less or equal zero
//   ippStsNoErr           otherwise
*)

  ippsMinEvery_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMinEvery_32s_I: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsMinEvery_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMaxEvery_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMaxEvery_32s_I: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsMaxEvery_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;


  ippsMinMax_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMax:PIpp64f):IppStatus;stdcall;
  ippsMinMax_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMax:PIpp32f):IppStatus;stdcall;
  ippsMinMax_32s: function(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMax:PIpp32s):IppStatus;stdcall;
  ippsMinMax_32u: function(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMax:PIpp32u):IppStatus;stdcall;
  ippsMinMax_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMax:PIpp16s):IppStatus;stdcall;
  ippsMinMax_16u: function(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMax:PIpp16u):IppStatus;stdcall;
  ippsMinMax_8u: function(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMax:PIpp8u):IppStatus;stdcall;


  ippsMinMaxIndx_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMinIndx:Plongint;pMax:PIpp64f;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMinIndx:Plongint;pMax:PIpp32f;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_32s: function(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMinIndx:Plongint;pMax:PIpp32s;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_32u: function(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMinIndx:Plongint;pMax:PIpp32u;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMinIndx:Plongint;pMax:PIpp16s;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_16u: function(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMinIndx:Plongint;pMax:PIpp16u;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_8u: function(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMinIndx:Plongint;pMax:PIpp8u;pMaxIndx:Plongint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsPhase_64fc
//    ippsPhase_32fc
//    ippsPhase_16sc_Sfs
//    ippsPhase_16sc32f
//  Purpose:
//    Compute the phase (in radians) of complex vector elements.
//  Parameters:
//    pSrcRe    - an input complex vector
//    pDst      - an output vector to store the phase components;
//    len       - a length of the arrays.
//    scaleFactor   - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNoErr               Ok
//    ippStsNullPtrErr          Some of pointers to input or output data are NULL
//    ippStsBadSizeErr          The length of the arrays is less or equal zero
*)
  ippsPhase_64fc: function(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsPhase_32fc: function(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPhase_16sc32f: function(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPhase_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsPhase_64f
//    ippsPhase_32f
//    ippsPhase_16s_Sfs
//    ippsPhase_16s32f
//  Purpose:
//    Compute the phase of complex data formed as two real vectors.
//  Parameters:
//    pSrcRe    - an input vector containing a real part of complex data
//    pSrcIm    - an input vector containing an imaginary part of complex data
//    pDst      - an output vector to store the phase components
//    len       - a length of the arrays.
//    scaleFactor   - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNoErr               Ok
//    ippStsNullPtrErr          Some of pointers to input or output data are NULL
//    ippStsBadSizeErr          The length of the arrays is less or equal zero
*)
  ippsPhase_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsPhase_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPhase_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsPhase_16s32f: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsPhase_32sc_Sfs
//  Purpose:
//    Compute the phase (in radians) of complex vector elements.
//  Parameters:
//    pSrcRe    - an input complex vector
//    pDst      - an output vector to store the phase components;
//    len       - a length of the arrays.
//    scaleFactor   - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNoErr               Ok
//    ippStsNullPtrErr          Some of pointers to input or output data are NULL
//    ippStsBadSizeErr          The length of the arrays is less or equal zero
*)
  ippsPhase_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippsMaxOrder_64f
//      ippsMaxOrder_32f
//      ippsMaxOrder_32s
//      ippsMaxOrder_16s
//  Purpose:
//     Determines the maximal number of binary digits for data representation.
//  Parameters:
//    pSrc     The pointer on input signal vector.
//    pOrder   Pointer to result value.
//    len      The  length of  the input vector.
//  Return:
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Some of pointers to input or output data are NULL
//    ippStsSizeErr       The length of the arrays is less or equal zero
//    ippStsNanArg        If not a number is met in a input value
*)

  ippsMaxOrder_64f: function(pSrc:PIpp64f;len:longint;pOrder:Plongint):IppStatus;stdcall;
  ippsMaxOrder_32f: function(pSrc:PIpp32f;len:longint;pOrder:Plongint):IppStatus;stdcall;
  ippsMaxOrder_32s: function(pSrc:PIpp32s;len:longint;pOrder:Plongint):IppStatus;stdcall;
  ippsMaxOrder_16s: function(pSrc:PIpp16s;len:longint;pOrder:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsArctan
//
//  Purpose: compute arctangent value for all elements of the source vector
//
//  Return:
//   stsNoErr           Ok
//   stsNullPtrErr      Some of pointers to input or output data are NULL
//   stsBadSizeErr      The length of the arrays is less or equal zero
//
//  Parameters:
//   pSrcDst            pointer to the source/destination vector
//   pSrc               pointer to the source vector
//   pDst               pointer to the destination vector
//   len                a length of the array
//
*)

  ippsArctan_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsArctan_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsArctan_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsArctan_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsFindNearestOne
//  Purpose:        Searches the table for an element closest to the reference value
//                  and returns its value and index
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   At least one of the specified pointers is NULL
//    ippStsSizeErr      The length of the table is less than or equal to zero
//  Parameters:
//    inpVal        reference Value
//    pOutVal       pointer to the found value
//    pOutIndx      pointer to the found index
//    pTable        table for search
//    tblLen        length of the table
//  Notes:
//                  The table should contain monotonically increasing values
*)

  ippsFindNearestOne_16u: function(inpVal:Ipp16u;pOutVal:PIpp16u;pOutIndex:Plongint;pTable:PIpp16u;tblLen:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsFindNearest
//  Purpose:        Searches the table for elements closest to the reference values
//                  and the their indexes
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   At least one of the specified pointers is NULL
//    ippStsSizeErr      The length of table or pVals is less than or equal to zero
//  Parameters:
//    pVals         pointer to the reference values vector
//    pOutVals      pointer to the vector with the found values
//    pOutIndexes   pointer to the array with indexes of the found elements
//    len           length of the input vector
//    pTable        table for search
//    tblLen        length of the table
//  Notes:
//                  The table should contain monotonically increasing values
*)


  ippsFindNearest_16u: function(pVals:PIpp16u;pOutVals:PIpp16u;pOutIndexes:Plongint;len:longint;pTable:PIpp16u;tblLen:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                      Vector logical functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Names:              ippsAnd, ippsOr, ippsXor, ippsNot, ippsLShiftC, ippsRShiftC
//  Purpose:            logical operations and vector shifts
//  Parameters:
//   val                1) value to be ANDed/ORed/XORed with each element of the vector (And, Or, Xor);
//                      2) position`s number which vector elements to be SHIFTed on (ShiftC)
//   pSrc               pointer to input vector
//   pSrcDst            pointer to input/output vector
//   pSrc1              pointer to first input vector
//   pSrc2              pointer to second input vector
//   pDst               pointer to output vector
//   length             vector's length
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data is NULL
//   ippStsSizeErr         vector`s length is less or equal zero
//   ippStsShiftErr        shift`s value is less zero
//   ippStsNoErr           otherwise
*)

  ippsAndC_8u_I: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsAndC_8u: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsAndC_16u_I: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAndC_16u: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAndC_32u_I: function(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsAndC_32u: function(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsAnd_8u_I: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsAnd_8u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsAnd_16u_I: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAnd_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAnd_32u_I: function(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsAnd_32u: function(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;

  ippsOrC_8u_I: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsOrC_8u: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsOrC_16u_I: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsOrC_16u: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsOrC_32u_I: function(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsOrC_32u: function(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsOr_8u_I: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsOr_8u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsOr_16u_I: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsOr_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsOr_32u_I: function(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsOr_32u: function(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;

  ippsXorC_8u_I: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsXorC_8u: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsXorC_16u_I: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsXorC_16u: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsXorC_32u_I: function(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsXorC_32u: function(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsXor_8u_I: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsXor_8u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsXor_16u_I: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsXor_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsXor_32u_I: function(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsXor_32u: function(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;

  ippsNot_8u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsNot_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsNot_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsNot_16u: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsNot_32u_I: function(pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsNot_32u: function(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;

  ippsLShiftC_8u_I: function(val:longint;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsLShiftC_8u: function(pSrc:PIpp8u;val:longint;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsLShiftC_16u_I: function(val:longint;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsLShiftC_16u: function(pSrc:PIpp16u;val:longint;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsLShiftC_16s_I: function(val:longint;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsLShiftC_16s: function(pSrc:PIpp16s;val:longint;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsLShiftC_32s_I: function(val:longint;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsLShiftC_32s: function(pSrc:PIpp32s;val:longint;pDst:PIpp32s;len:longint):IppStatus;stdcall;

  ippsRShiftC_8u_I: function(val:longint;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsRShiftC_8u: function(pSrc:PIpp8u;val:longint;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsRShiftC_16u_I: function(val:longint;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsRShiftC_16u: function(pSrc:PIpp16u;val:longint;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsRShiftC_16s_I: function(val:longint;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsRShiftC_16s: function(pSrc:PIpp16s;val:longint;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsRShiftC_32s_I: function(val:longint;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsRShiftC_32s: function(pSrc:PIpp32s;val:longint;pDst:PIpp32s;len:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                  Dot Product Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDotProd
//  Purpose:    compute Dot Product value
//  Arguments:
//     pSrc1               pointer to the source vector
//     pSrc2               pointer to the another source vector
//     len                 vector's length, number of items
//     pDp                 pointer to the result
//     scaleFactor         scale factor value
//  Return:
//     ippStsNullPtrErr       pointer(s) pSrc pDst is NULL
//     ippStsSizeErr          length of the vectors is less or equal 0
//     ippStsNoErr            otherwise
//  Notes:
//     the functions don't conjugate one of the source vectorsstdcall;
*)

  ippsDotProd_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp32f):IppStatus;stdcall;
  ippsDotProd_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;stdcall;
  ippsDotProd_32f32fc: function(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;stdcall;

  ippsDotProd_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pDp:PIpp64f):IppStatus;stdcall;
  ippsDotProd_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;
  ippsDotProd_64f64fc: function(pSrc1:PIpp64f;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;

  ippsDotProd_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16s16sc_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsDotProd_16s64s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp64s):IppStatus;stdcall;
  ippsDotProd_16sc64sc: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;stdcall;
  ippsDotProd_16s16sc64sc: function(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;stdcall;

  ippsDotProd_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32f):IppStatus;stdcall;
  ippsDotProd_16sc32fc: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp32fc):IppStatus;stdcall;
  ippsDotProd_16s16sc32fc: function(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp32fc):IppStatus;stdcall;

  ippsDotProd_32f64f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp64f):IppStatus;stdcall;
  ippsDotProd_32fc64fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;
  ippsDotProd_32f32fc64fc: function(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;


  ippsDotProd_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16sc32sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16s16sc32sc_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsDotProd_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_32s32sc_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16s32s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//          ippsPowerSpectr_64fc
//          ippsPowerSpectr_32fc
//          ippsPowerSpectr_16sc_Sfs
//          ippsPowerSpectr_16sc32f
//  Purpose:
//    Compute the power spectrum of complex vector
//  Parameters:
//    pSrcRe    - pointer to the real part of input vector.
//    pSrcIm    - pointer to the image part of input vector.
//    pDst      - pointer to the result.
//    len       - vector length.
//    scaleFactor   - scale factor for rezult (only for integer data).
//  Return:
//   ippStsNullPtrErr  indicates that one or more pointers to the data is NULL.
//   ippStsSizeErr     indicates that vector length is less or equal zero.
//   ippStsNoErr       otherwise.
*)



  ippsPowerSpectr_64fc: function(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsPowerSpectr_32fc: function(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPowerSpectr_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsPowerSpectr_16sc32f: function(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//          ippsPowerSpectr_64f
//          ippsPowerSpectr_32f
//          ippsPowerSpectr_16s_Sfs
//          ippsPowerSpectr_16s32f
//  Purpose:
//    Compute the power spectrum of complex data formed as two real vectors
//  Parameters:
//    pSrcRe    - pointer to the real part of input vector.
//    pSrcIm    - pointer to the image part of input vector.
//    pDst      - pointer to the result.
//    len       - vector length.
//    scaleFactor   - scale factor for rezult (only for integer data).
//  Return:
//   ippStsNullPtrErr  indicates that one or more pointers to the data is NULL.
//   ippStsSizeErr     indicates that vector length is less or equal zero.
//   ippStsNoErr       otherwise.
*)

  ippsPowerSpectr_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsPowerSpectr_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;

  ippsPowerSpectr_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsPowerSpectr_16s32f: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Linear Transform
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsNormalize_64fc
//    ippsNormalize_32fc
//    ippsNormalize_16sc_Sfs
//  Purpose:
//    Complex vector normalization using offset and division method.
//  Parameters:
//    pSrc      - an input complex vector
//    pDst      - an output complex vector
//    len       - a length of the arrays.
//    vsub      - complex a subtrahend
//    vdiv      - denominator
//    scaleFactor   - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNoErr            Ok
//    ippStsNullPtrErr       Some of pointers to input or output data are NULL
//    ippStsSizeErr          The length of the arrays is less or equal zero
//    ippStsDivByZeroErr     denominator equal zero or less than float
//                           format minimum
*)
  ippsNormalize_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;vsub:Ipp64fc;vdiv:Ipp64f):IppStatus;stdcall;
  ippsNormalize_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;vsub:Ipp32fc;vdiv:Ipp32f):IppStatus;stdcall;
  ippsNormalize_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;vsub:Ipp16sc;vdiv:longint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsNormalize_64f
//    ippsNormalize_32f
//    ippsNormalize_16s_Sfs
//  Purpose:
//    Normalize elements of real vector with the help of offset and division.
//  Parameters:
//    pSrc      - an input vector of real data
//    pDst      - an output vector of real data
//    len       - a length of the arrays.
//    vsub      - subtrahend
//    vdiv      - denominator
//    scaleFactor   - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNoErr               Ok
//    ippStsNullPtrErr          Some of pointers to input or output data are NULL
//    ippStsSizeErr             The length of the arrays is less or equal zero
//    ippStsDivByZeroErr        denominator equal zero or less than float
//                           format minimum
*)
  ippsNormalize_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;vsub:Ipp64f;vdiv:Ipp64f):IppStatus;stdcall;
  ippsNormalize_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;vsub:Ipp32f;vdiv:Ipp32f):IppStatus;stdcall;
  ippsNormalize_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;vsub:Ipp16s;vdiv:longint;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for FFT Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)

type

IppsFFTSpec_C_16sc =pointer;
PIppsFFTSpec_C_16sc=^IppsFFTSpec_C_16sc;

IppsFFTSpec_C_16s =pointer;
PIppsFFTSpec_C_16s=^IppsFFTSpec_C_16s;

IppsFFTSpec_R_16s =pointer;
PIppsFFTSpec_R_16s=^IppsFFTSpec_R_16s;

IppsFFTSpec_C_32fc =pointer;
PIppsFFTSpec_C_32fc=^IppsFFTSpec_C_32fc;

IppsFFTSpec_C_32f =pointer;
PIppsFFTSpec_C_32f=^IppsFFTSpec_C_32f;

IppsFFTSpec_R_32f =pointer;
PIppsFFTSpec_R_32f=^IppsFFTSpec_R_32f;

IppsFFTSpec_C_64fc =pointer;
PIppsFFTSpec_C_64fc=^IppsFFTSpec_C_64fc;

IppsFFTSpec_C_64f =pointer;
PIppsFFTSpec_C_64f=^IppsFFTSpec_C_64f;

IppsFFTSpec_R_64f =pointer;
PIppsFFTSpec_R_64f=^IppsFFTSpec_R_64f;



var
(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Context Functions;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTInitAlloc_C, ippsFFTInitAlloc_R
//  Purpose:    create and initialize of FFT context
//  Arguments:
//     order    - base-2 logarithm of the number of samples in FFT
//     flag     - normalization flag
//     hint     - code specific use hints
//     pFFTSpec - where write pointer to new context
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL
//     ippStsFftOrderErr      bad the order value
//     ippStsFftFlagErr       bad the normalization flag value
//     ippStsMemAllocErr      memory allocation error
*)

  ippsFFTInitAlloc_C_16sc: function(var pFFTSpec:PIppsFFTSpec_C_16sc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsFFTInitAlloc_C_16s: function(var pFFTSpec:PIppsFFTSpec_C_16s;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsFFTInitAlloc_R_16s: function(var pFFTSpec:PIppsFFTSpec_R_16s;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsFFTInitAlloc_C_32fc: function(var pFFTSpec:PIppsFFTSpec_C_32fc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsFFTInitAlloc_C_32f: function(var pFFTSpec:PIppsFFTSpec_C_32f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsFFTInitAlloc_R_32f: function(var pFFTSpec:PIppsFFTSpec_R_32f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsFFTInitAlloc_C_64fc: function(var pFFTSpec:PIppsFFTSpec_C_64fc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsFFTInitAlloc_C_64f: function(var pFFTSpec:PIppsFFTSpec_C_64f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsFFTInitAlloc_R_64f: function(var pFFTSpec:PIppsFFTSpec_R_64f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTFree_C, ippsFFTFree_R
//  Purpose:    delete FFT context
//  Arguments:
//     pFFTSpec - pointer to FFT context to be deleted
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippsFFTFree_C_16sc: function(pFFTSpec:PIppsFFTSpec_C_16sc):IppStatus;stdcall;
  ippsFFTFree_C_16s: function(pFFTSpec:PIppsFFTSpec_C_16s):IppStatus;stdcall;
  ippsFFTFree_R_16s: function(pFFTSpec:PIppsFFTSpec_R_16s):IppStatus;stdcall;

  ippsFFTFree_C_32fc: function(pFFTSpec:PIppsFFTSpec_C_32fc):IppStatus;stdcall;
  ippsFFTFree_C_32f: function(pFFTSpec:PIppsFFTSpec_C_32f):IppStatus;stdcall;
  ippsFFTFree_R_32f: function(pFFTSpec:PIppsFFTSpec_R_32f):IppStatus;stdcall;

  ippsFFTFree_C_64fc: function(pFFTSpec:PIppsFFTSpec_C_64fc):IppStatus;stdcall;
  ippsFFTFree_C_64f: function(pFFTSpec:PIppsFFTSpec_C_64f):IppStatus;stdcall;
  ippsFFTFree_R_64f: function(pFFTSpec:PIppsFFTSpec_R_64f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTGetBufSize_C, ippsFFTGetBufSize_R
//  Purpose:    get size of the FFT work buffer (on bytes)
//  Arguments:
//     pFFTSpec - pointer to the FFT structure
//     pSize     - Pointer to the FFT work buffer size value
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL or pSize == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippsFFTGetBufSize_C_16sc: function(pFFTSpec:PIppsFFTSpec_C_16sc;pSize:Plongint):IppStatus;stdcall;
  ippsFFTGetBufSize_C_16s: function(pFFTSpec:PIppsFFTSpec_C_16s;pSize:Plongint):IppStatus;stdcall;
  ippsFFTGetBufSize_R_16s: function(pFFTSpec:PIppsFFTSpec_R_16s;pSize:Plongint):IppStatus;stdcall;

  ippsFFTGetBufSize_C_32fc: function(pFFTSpec:PIppsFFTSpec_C_32fc;pSize:Plongint):IppStatus;stdcall;
  ippsFFTGetBufSize_C_32f: function(pFFTSpec:PIppsFFTSpec_C_32f;pSize:Plongint):IppStatus;stdcall;
  ippsFFTGetBufSize_R_32f: function(pFFTSpec:PIppsFFTSpec_R_32f;pSize:Plongint):IppStatus;stdcall;

  ippsFFTGetBufSize_C_64fc: function(pFFTSpec:PIppsFFTSpec_C_64fc;pSize:Plongint):IppStatus;stdcall;
  ippsFFTGetBufSize_C_64f: function(pFFTSpec:PIppsFFTSpec_C_64f;pSize:Plongint):IppStatus;stdcall;
  ippsFFTGetBufSize_R_64f: function(pFFTSpec:PIppsFFTSpec_R_64f;pSize:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Complex Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTFwd_CToC, ippsFFTInv_CToC
//  Purpose:    compute forward and inverse FFT of the complex signal
//  Arguments:
//     pFFTSpec - pointer to FFT context
//     pSrc     - pointer to source complex signal
//     pDst     - pointer to destination complex signal
//     pSrcRe   - pointer to real      part of source signal
//     pSrcIm   - pointer to imaginary part of source signal
//     pDstRe   - pointer to real      part of destination signal
//     pDstIm   - pointer to imaginary part of destination signal
//     pBuffer  - pointer to work buffer
//     scaleFactor
//              - scale factor for output result
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL or
//                            pSrc == NULL or pDst == NULL or
//                            pSrcRe == NULL or pSrcIm == NULL or
//                            pDstRe == NULL or pDstIm == NULL or
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsFFTFwd_CToC_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;pFFTSpec:PIppsFFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;pFFTSpec:PIppsFFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pFFTSpec:PIppsFFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pFFTSpec:PIppsFFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Real Packed Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTFwd_RToPerm, ippsFFTFwd_RToPack, ippsFFTFwd_RToCCS
//              ippsFFTInv_PermToR, ippsFFTInv_PackToR, ippsFFTInv_CCSToR
//  Purpose:    compute forward and inverse FFT of real signal
//              using Perm, Pack or Ccs packed format
//  Arguments:
//     pFFTSpec - pointer to FFT context
//     pSrc     - pointer to source signal
//     pDst     - pointer to destination signal
//     pBuffer  - pointer to work buffer
//     scaleFactor
//              - scale factor for output result
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL or
//                            pSrc == NULL or pDst == NULL
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsFFTFwd_RToPerm_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToPack_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToCCS_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PermToR_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PackToR_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CCSToR_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_RToPerm_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToPack_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToCCS_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PermToR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PackToR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CCSToR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_RToPerm_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToPack_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToCCS_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PermToR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PackToR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CCSToR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DFT Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)

type
  IppsDFTSpec_C_16sc= pointer;
  PIppsDFTSpec_C_16sc= ^IppsDFTSpec_C_16sc;

  IppsDFTSpec_C_16s= pointer;
  PIppsDFTSpec_C_16s= ^IppsDFTSpec_C_16s;

  IppsDFTSpec_R_16s= pointer;
  PIppsDFTSpec_R_16s= ^IppsDFTSpec_R_16s;

  IppsDFTSpec_C_32fc= pointer;
  PIppsDFTSpec_C_32fc= ^IppsDFTSpec_C_32fc;

  IppsDFTSpec_C_32f= pointer;
  PIppsDFTSpec_C_32f= ^IppsDFTSpec_C_32f;

  IppsDFTSpec_R_32f= pointer;
  PIppsDFTSpec_R_32f= ^IppsDFTSpec_R_32f;

  IppsDFTSpec_C_64fc= pointer;
  PIppsDFTSpec_C_64fc= ^IppsDFTSpec_C_64fc;

  IppsDFTSpec_C_64f= pointer;
  PIppsDFTSpec_C_64f= ^IppsDFTSpec_C_64f;

  IppsDFTSpec_R_64f= pointer;
  PIppsDFTSpec_R_64f= ^IppsDFTSpec_R_64f;

  IppsDFTOutOrdSpec_C_32fc= pointer;
  PIppsDFTOutOrdSpec_C_32fc= ^IppsDFTOutOrdSpec_C_32fc;

  IppsDFTOutOrdSpec_C_64fc= pointer;
  PIppsDFTOutOrdSpec_C_64fc= ^IppsDFTOutOrdSpec_C_64fc;


var
(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Context Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTInitAlloc_C, ippsDFTInitAlloc_R
//  Purpose:    create and initialize of DFT context
//  Arguments:
//     length   - number of samples in DFT
//     flag     - normalization flag
//     hint     - code specific use hints
//     pDFTSpec - where write pointer to new context
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL
//     ippStsSizeErr          bad the length value
//     ippStsFFTFlagErr       bad the normalization flag value
//     ippStsMemAllocErr      memory allocation error
*)

  ippsDFTInitAlloc_C_16sc: function(var pDFTSpec:PIppsDFTSpec_C_16sc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDFTInitAlloc_C_16s: function(var pDFTSpec:PIppsDFTSpec_C_16s;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDFTInitAlloc_R_16s: function(var pDFTSpec:PIppsDFTSpec_R_16s;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsDFTInitAlloc_C_32fc: function(var pDFTSpec:PIppsDFTSpec_C_32fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDFTInitAlloc_C_32f: function(var pDFTSpec:PIppsDFTSpec_C_32f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDFTInitAlloc_R_32f: function(var pDFTSpec:PIppsDFTSpec_R_32f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsDFTInitAlloc_C_64fc: function(var pDFTSpec:PIppsDFTSpec_C_64fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDFTInitAlloc_C_64f: function(var pDFTSpec:PIppsDFTSpec_C_64f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDFTInitAlloc_R_64f: function(var pDFTSpec:PIppsDFTSpec_R_64f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsDFTOutOrdInitAlloc_C_32fc: function(var pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsDFTOutOrdInitAlloc_C_64fc: function(var pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTFree_C, ippsDFTFree_R
//  Purpose:    delete DFT context
//  Arguments:
//     pDFTSpec - pointer to DFT context to be deleted
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippsDFTFree_C_16sc: function(pDFTSpec:PIppsDFTSpec_C_16sc):IppStatus;stdcall;
  ippsDFTFree_C_16s: function(pDFTSpec:PIppsDFTSpec_C_16s):IppStatus;stdcall;
  ippsDFTFree_R_16s: function(pDFTSpec:PIppsDFTSpec_R_16s):IppStatus;stdcall;

  ippsDFTFree_C_32fc: function(pDFTSpec:PIppsDFTSpec_C_32fc):IppStatus;stdcall;
  ippsDFTFree_C_32f: function(pDFTSpec:PIppsDFTSpec_C_32f):IppStatus;stdcall;
  ippsDFTFree_R_32f: function(pDFTSpec:PIppsDFTSpec_R_32f):IppStatus;stdcall;

  ippsDFTFree_C_64fc: function(pDFTSpec:PIppsDFTSpec_C_64fc):IppStatus;stdcall;
  ippsDFTFree_C_64f: function(pDFTSpec:PIppsDFTSpec_C_64f):IppStatus;stdcall;
  ippsDFTFree_R_64f: function(pDFTSpec:PIppsDFTSpec_R_64f):IppStatus;stdcall;

  ippsDFTOutOrdFree_C_32fc: function(pDFTSpec:PIppsDFTOutOrdSpec_C_32fc):IppStatus;stdcall;

  ippsDFTOutOrdFree_C_64fc: function(pDFTSpec:PIppsDFTOutOrdSpec_C_64fc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTGetBufSize_C, ippsDFTGetBufSize_R
//  Purpose:    get size of the DFT work buffer (on bytes)
//  Arguments:
//     pDFTSpec - pointer to DFT context
//     pSize     - where write size of buffer
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL or pSize == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippsDFTGetBufSize_C_16sc: function(pDFTSpec:PIppsDFTSpec_C_16sc;pSize:Plongint):IppStatus;stdcall;
  ippsDFTGetBufSize_C_16s: function(pDFTSpec:PIppsDFTSpec_C_16s;pSize:Plongint):IppStatus;stdcall;
  ippsDFTGetBufSize_R_16s: function(pDFTSpec:PIppsDFTSpec_R_16s;pSize:Plongint):IppStatus;stdcall;

  ippsDFTGetBufSize_C_32fc: function(pDFTSpec:PIppsDFTSpec_C_32fc;pSize:Plongint):IppStatus;stdcall;
  ippsDFTGetBufSize_C_32f: function(pDFTSpec:PIppsDFTSpec_C_32f;pSize:Plongint):IppStatus;stdcall;
  ippsDFTGetBufSize_R_32f: function(pDFTSpec:PIppsDFTSpec_R_32f;pSize:Plongint):IppStatus;stdcall;

  ippsDFTGetBufSize_C_64fc: function(pDFTSpec:PIppsDFTSpec_C_64fc;pSize:Plongint):IppStatus;stdcall;
  ippsDFTGetBufSize_C_64f: function(pDFTSpec:PIppsDFTSpec_C_64f;pSize:Plongint):IppStatus;stdcall;
  ippsDFTGetBufSize_R_64f: function(pDFTSpec:PIppsDFTSpec_R_64f;pSize:Plongint):IppStatus;stdcall;

  ippsDFTOutOrdGetBufSize_C_32fc: function(pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;size:Plongint):IppStatus;stdcall;

  ippsDFTOutOrdGetBufSize_C_64fc: function(pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;size:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Complex Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTFwd_CToC, ippsDFTInv_CToC
//  Purpose:    compute forward and inverse DFT of the complex signal
//  Arguments:
//     pDFTSpec - pointer to DFT context
//     pSrc     - pointer to source complex signal
//     pDst     - pointer to destination complex signal
//     pSrcRe   - pointer to real      part of source signal
//     pSrcIm   - pointer to imaginary part of source signal
//     pDstRe   - pointer to real      part of destination signal
//     pDstIm   - pointer to imaginary part of destination signal
//     pBuffer  - pointer to work buffer
//     scaleFactor
//              - scale factor for output result
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL or
//                            pSrc == NULL or pDst == NULL or
//                            pSrcRe == NULL or pSrcIm == NULL or
//                            pDstRe == NULL or pDstIm == NULL or
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsDFTFwd_CToC_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;pDFTSpec:PIppsDFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;pDFTSpec:PIppsDFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_CToC_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pDFTSpec:PIppsDFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pDFTSpec:PIppsDFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTFwd_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTFwd_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTOutOrdFwd_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTOutOrdInv_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTOutOrdFwd_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTOutOrdInv_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Real Packed Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTFwd_RToPerm, ippsDFTFwd_RToPack, ippsDFTFwd_RToCCS
//              ippsDFTInv_PermToR, ippsDFTInv_PackToR, ippsDFTInv_CCSToR
//  Purpose:    compute forward and inverse DFT of real signal
//              using Perm, Pack or Ccs packed format
//  Arguments:
//     pDFTSpec - pointer to DFT context
//     pSrc     - pointer to source signal
//     pDst     - pointer to destination signal
//     pBuffer  - pointer to work buffer
//     scaleFactor
//              - scale factor for output result
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL or
//                            pSrc == NULL or pDst == NULL
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsDFTFwd_RToPerm_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_RToPack_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_RToCCS_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_PermToR_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_PackToR_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CCSToR_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTFwd_RToPerm_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_RToPack_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_RToCCS_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_PermToR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_PackToR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CCSToR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTFwd_RToPerm_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_RToPack_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_RToCCS_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_PermToR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_PackToR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CCSToR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//              Vector multiplication in RCPack and in RCPerm formats
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Names:              ippsMulPack, ippsMulPerm
//  Purpose:            multiply two vectors stored in RCPack and RCPerm formats
//  Parameters:
//   pSrc               pointer to input vector (in-place case)
//   pSrcDst            pointer to output vector (in-place case)
//   pSrc1              pointer to first input vector
//   pSrc2              pointer to second input vector
//   pDst               pointer to output vector
//   length             vector's length
//   scaleFactor        scale factor
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data is NULL
//   ippStsSizeErr         vector`s length is less or equal zero
//   ippStsNoErr           otherwise
*)

  ippsMulPack_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulPerm_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulPack_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;stdcall;
  ippsMulPerm_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;stdcall;
  ippsMulPack_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;stdcall;
  ippsMulPerm_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;stdcall;
  ippsMulPack_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulPerm_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulPack_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;length:longint):IppStatus;stdcall;
  ippsMulPerm_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;length:longint):IppStatus;stdcall;
  ippsMulPack_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;length:longint):IppStatus;stdcall;
  ippsMulPerm_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;length:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:              ippsMulPackConj
//  Purpose:            multiply on a complex conjugate vector and store in RCPack format
//  Parameters:
//   pSrc               pointer to input vector (in-place case)
//   pSrcDst            pointer to output vector (in-place case)
//   length             vector's length
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data is NULL
//   ippStsSizeErr         vector`s length is less or equal zero
//   ippStsNoErr           otherwise
*)

  ippsMulPackConj_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;stdcall;
  ippsMulPackConj_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:        ippsGoertz
//  Purpose:      compute DFT for single frequency (Goertzel algorithm)
//  Parameters:
//    freq                 single relative frequency value [0, 1.0)
//    pSrc                 pointer to the input vector
//    len                  length of the vector
//    pVal                 pointer to the DFT result value computed
//    scaleFactor          scale factor value
//  Return:
//    ippStsNullPtrErr        pointer to the data is NULL
//    ippStsSizeErr           length of the vector is less or equal zero
//    ippStsRelFreqErr        frequency value out of range
//    ippStsNoErr             otherwise
*)

  ippsGoertz_32fc: function(pSrc:PIpp32fc;len:longint;pVal:PIpp32fc;freq:Ipp32f):IppStatus;stdcall;
  ippsGoertz_64fc: function(pSrc:PIpp64fc;len:longint;pVal:PIpp64fc;freq:Ipp64f):IppStatus;stdcall;

  ippsGoertz_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;pVal:PIpp16sc;freq:Ipp32f;scaleFactor:longint):IppStatus;stdcall;

  ippsGoertz_32f: function(pSrc:PIpp32f;len:longint;pVal:PIpp32fc;freq:Ipp32f):IppStatus;stdcall;
  ippsGoertz_16s_Sfs: function(pSrc:PIpp16s;len:longint;pVal:PIpp16sc;freq:Ipp32f;scaleFactor:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:        ippsGoertzTwo
//  Purpose:      compute DFT for dual frequency (Goertzel algorithm)
//  Parameters:
//    freq                 pointer to two relative frequency values [0, 1.0)
//    pSrc                 pointer to the input vector
//    len                  length of the vector
//    pVal                 pointer to the DFT result value computed
//    scaleFactor          scale factor value
//  Return:
//    ippStsNullPtrErr        pointer to the data is NULL
//    ippStsSizeErr           length of the vector is less or equal zero
//    ippStsRelFreqErr        frequency values out of range
//    ippStsNoErr             otherwise
*)

  ippsGoertzTwo_32fc: function(pSrc:PIpp32fc;len:longint;var Val:Ipp32fc;var freq:Ipp32f):IppStatus;stdcall;
  ippsGoertzTwo_64fc: function(pSrc:PIpp64fc;len:longint;var Val:Ipp64fc;var freq:Ipp64f):IppStatus;stdcall;
  ippsGoertzTwo_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;var Val:Ipp16sc;var freq:Ipp32f;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DCT Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)

type
IppsDCTFwdSpec_16s = pointer;
PIppsDCTFwdSpec_16s =^IppsDCTFwdSpec_16s;

IppsDCTInvSpec_16s = pointer;
PIppsDCTInvSpec_16s =^IppsDCTInvSpec_16s;

IppsDCTFwdSpec_32f = pointer;
PIppsDCTFwdSpec_32f =^IppsDCTFwdSpec_32f;

IppsDCTInvSpec_32f = pointer;
PIppsDCTInvSpec_32f =^IppsDCTInvSpec_32f;

IppsDCTFwdSpec_64f = pointer;
PIppsDCTFwdSpec_64f =^IppsDCTFwdSpec_64f;

IppsDCTInvSpec_64f = pointer;
PIppsDCTInvSpec_64f =^IppsDCTInvSpec_64f;


var
(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Context Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDCTFwdInitAlloc, ippsDCTInvInitAlloc
//  Purpose:    create and initialize of DCT context
//  Arguments:
//     length   - number of samples in DCT
//     flag     - normalization flag
//     hint     - code specific use hints
//     pDCTSpec - where write pointer to new context
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL
//     ippStsSizeErr          bad the length value
//     ippStsMemAllocErr      memory allocation error
*)

  ippsDCTFwdInitAlloc_16s: function(var pDCTSpec:PIppsDCTFwdSpec_16s;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDCTInvInitAlloc_16s: function(var pDCTSpec:PIppsDCTInvSpec_16s;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsDCTFwdInitAlloc_32f: function(var pDCTSpec:PIppsDCTFwdSpec_32f;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDCTInvInitAlloc_32f: function(var pDCTSpec:PIppsDCTInvSpec_32f;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsDCTFwdInitAlloc_64f: function(var pDCTSpec:PIppsDCTFwdSpec_64f;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsDCTInvInitAlloc_64f: function(var pDCTSpec:PIppsDCTInvSpec_64f;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDCTFwdFree, ippsDCTInvFree
//  Purpose:    delete DCT context
//  Arguments:
//     pDCTSpec - pointer to DCT context to be deleted
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippsDCTFwdFree_16s: function(pDCTSpec:PIppsDCTFwdSpec_16s):IppStatus;stdcall;
  ippsDCTInvFree_16s: function(pDCTSpec:PIppsDCTInvSpec_16s):IppStatus;stdcall;

  ippsDCTFwdFree_32f: function(pDCTSpec:PIppsDCTFwdSpec_32f):IppStatus;stdcall;
  ippsDCTInvFree_32f: function(pDCTSpec:PIppsDCTInvSpec_32f):IppStatus;stdcall;

  ippsDCTFwdFree_64f: function(pDCTSpec:PIppsDCTFwdSpec_64f):IppStatus;stdcall;
  ippsDCTInvFree_64f: function(pDCTSpec:PIppsDCTInvSpec_64f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDCTFwdGetBufSize, ippsDCTInvGetBufSize
//  Purpose:    get size of the DCT work buffer (on bytes)
//  Arguments:
//     pDCTSpec  - pointer to the DCT structure
//     pSize     - pointer to the DCT work buffer size value
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL or pSize == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippsDCTFwdGetBufSize_16s: function(pDCTSpec:PIppsDCTFwdSpec_16s;pSize:Plongint):IppStatus;stdcall;
  ippsDCTInvGetBufSize_16s: function(pDCTSpec:PIppsDCTInvSpec_16s;pSize:Plongint):IppStatus;stdcall;

  ippsDCTFwdGetBufSize_32f: function(pDCTSpec:PIppsDCTFwdSpec_32f;pSize:Plongint):IppStatus;stdcall;
  ippsDCTInvGetBufSize_32f: function(pDCTSpec:PIppsDCTInvSpec_32f;pSize:Plongint):IppStatus;stdcall;

  ippsDCTFwdGetBufSize_64f: function(pDCTSpec:PIppsDCTFwdSpec_64f;pSize:Plongint):IppStatus;stdcall;
  ippsDCTInvGetBufSize_64f: function(pDCTSpec:PIppsDCTInvSpec_64f;pSize:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDCTFwd, ippsDCTInv
//  Purpose:    compute forward and inverse DCT of signal
//  Arguments:
//     pDCTSpec - pointer to DCT context
//     pSrc     - pointer to source signal
//     pDst     - pointer to destination signal
//     pBuffer  - pointer to work buffer
//     scaleFactor
//              - scale factor for output result
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL or
//                            pSrc == NULL or pDst == NULL
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsDCTFwd_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDCTSpec:PIppsDCTFwdSpec_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;pDCTSpec:PIppsDCTInvSpec_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDCTFwd_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDCTFwd_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTFwdSpec_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTInvSpec_64f;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Functions for Fixed Filter Banksstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* //////////////////////////////////////////////////////////////////////
// Name:       ippsWTHaar
// Purpose:    one level Haar Wavelet Transform
// Arguments:
//   pSrc        - source vector;
//   len         - length of source vector;
//   pDstLow     - coarse "low frequency" component destination;
//   pDstHigh    - detail "high frequency" component destination;
//   pSrcLow     - coarse "low frequency" component source;
//   pSrcHigh    - detail "high frequency" component source;
//   pDst        - destination vector;
//   scaleFactor - scale factor value
//  Return:
//   ippStsNullPtrErr    pointer(s) to the data vector is NULL
//   ippStsSizeErr       the length is less or equal zero
//   ippStsNoErr         otherwise
*)

  ippsWTHaarFwd_8s: function(pSrc:PIpp8s;len:longint;pDstLow:PIpp8s;pDstHigh:PIpp8s):IppStatus;stdcall;
  ippsWTHaarFwd_16s: function(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s):IppStatus;stdcall;
  ippsWTHaarFwd_32s: function(pSrc:PIpp32s;len:longint;pDstLow:PIpp32s;pDstHigh:PIpp32s):IppStatus;stdcall;
  ippsWTHaarFwd_64s: function(pSrc:PIpp64s;len:longint;pDstLow:PIpp64s;pDstHigh:PIpp64s):IppStatus;stdcall;
  ippsWTHaarFwd_32f: function(pSrc:PIpp32f;len:longint;pDstLow:PIpp32f;pDstHigh:PIpp32f):IppStatus;stdcall;
  ippsWTHaarFwd_64f: function(pSrc:PIpp64f;len:longint;pDstLow:PIpp64f;pDstHigh:PIpp64f):IppStatus;stdcall;

  ippsWTHaarFwd_8s_Sfs: function(pSrc:PIpp8s;len:longint;pDstLow:PIpp8s;pDstHigh:PIpp8s;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarFwd_16s_Sfs: function(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarFwd_32s_Sfs: function(pSrc:PIpp32s;len:longint;pDstLow:PIpp32s;pDstHigh:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarFwd_64s_Sfs: function(pSrc:PIpp64s;len:longint;pDstLow:PIpp64s;pDstHigh:PIpp64s;scaleFactor:longint):IppStatus;stdcall;

  ippsWTHaarInv_8s: function(pSrcLow:PIpp8s;pSrcHigh:PIpp8s;pDst:PIpp8s;len:longint):IppStatus;stdcall;
  ippsWTHaarInv_16s: function(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWTHaarInv_32s: function(pSrcLow:PIpp32s;pSrcHigh:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsWTHaarInv_64s: function(pSrcLow:PIpp64s;pSrcHigh:PIpp64s;pDst:PIpp64s;len:longint):IppStatus;stdcall;
  ippsWTHaarInv_32f: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWTHaarInv_64f: function(pSrcLow:PIpp64f;pSrcHigh:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsWTHaarInv_8s_Sfs: function(pSrcLow:PIpp8s;pSrcHigh:PIpp8s;pDst:PIpp8s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarInv_16s_Sfs: function(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarInv_32s_Sfs: function(pSrcLow:PIpp32s;pSrcHigh:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarInv_64s_Sfs: function(pSrcLow:PIpp64s;pSrcHigh:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Fucntions for User Filter Banks
///////////////////////////////////////////////////////////////////////////// *)

type

IppsWTFwdState_32f = pointer;
PIppsWTFwdState_32f =^IppsWTFwdState_32f;

IppsWTFwdState_8s32f = pointer;
PIppsWTFwdState_8s32f =^IppsWTFwdState_8s32f;

IppsWTFwdState_8u32f = pointer;
PIppsWTFwdState_8u32f =^IppsWTFwdState_8u32f;

IppsWTFwdState_16s32f = pointer;
PIppsWTFwdState_16s32f =^IppsWTFwdState_16s32f;

IppsWTFwdState_16u32f = pointer;
PIppsWTFwdState_16u32f =^IppsWTFwdState_16u32f;

IppsWTInvState_32f = pointer;
PIppsWTInvState_32f =^IppsWTInvState_32f;

IppsWTInvState_32f8s = pointer;
PIppsWTInvState_32f8s =^IppsWTInvState_32f8s;

IppsWTInvState_32f8u = pointer;
PIppsWTInvState_32f8u =^IppsWTInvState_32f8u;

IppsWTInvState_32f16s = pointer;
PIppsWTInvState_32f16s =^IppsWTInvState_32f16s;

IppsWTInvState_32f16u = pointer;
PIppsWTInvState_32f16u =^IppsWTInvState_32f16u;

var
(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdInitAlloc_32f, ippsWTFwdInitAlloc_8s32f,
//              ippsWTFwdInitAlloc_8u32f, ippsWTFwdInitAlloc_16s32f,
//              ippsWTFwdInitAlloc_16u32f
//
// Purpose:     Allocate and initialize
//                forward wavelet transform pState structure.
// Parameters:
//   pState    - pointer to pointer to allocated and initialized
//                pState structure.
//   pTapsLow  - pointer to lowpass filter taps;
//   lenLow    - length of lowpass filter;
//   offsLow   - input delay of lowpass filter;
//   pTapsHigh - pointer to highpass filter taps;
//   lenHigh   - length of highpass filter;
//   offsHigh  - input delay of highpass filter;
//
// Returns:
//   ippStsNoErr        - Ok;
//   ippStsNullPtrErr   - pointer to filter taps are NULL
//                          or pointer to pState structure is NULL;
//   ippStsSizeErr      - filter length is less or equal zero;
//   ippStsWtOffsetErr  - filter delay is less than (-1).
//
// Notes:   filter input delay minimum value is (-1) that corresponds to
//            downsampling phase equal 1 (first sample excluded,
//            second included and so on);
*)
  ippsWTFwdInitAlloc_32f: function(var pState:PIppsWTFwdState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTFwdInitAlloc_8s32f: function(var pState:PIppsWTFwdState_8s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTFwdInitAlloc_8u32f: function(var pState:PIppsWTFwdState_8u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTFwdInitAlloc_16s32f: function(var pState:PIppsWTFwdState_16s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTFwdInitAlloc_16u32f: function(var pState:PIppsWTFwdState_16u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdSetDlyLine_32f, ippsWTFwdSetDlyLine_8s32f,
//              ippsWTFwdSetDlyLine_8u32f, ippsWTFwdSetDlyLine_16s32f,
//              ippsWTFwdSetDlyLine_16u32f
//
// Purpose:     The function copies the pointed vectors to internal delay lines.stdcall;
//
// Parameters:
//   pState   - pointer to pState structure;
//   pDlyLow  - pointer to delay line for lowpass filtering;
//   pDlyHigh - pointer to delay line for highpass filtering.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers pDlyLow
//                              or pDlyHigh vectors are NULL;
//   ippStspStateMatchErr   - mismatch pState structure.
//
// Notes: lengths of delay lines:
//          len(pDlyLow)  = lenLow  + offsLow  - 1;
//          len(pDlyHigh) = lenHigh + offsHigh - 1;
//  lenLow, offsLow, lenHigh, offsHigh - parameters
//    for ippsWTFwdInitAlloc function.stdcall;
*)
  ippsWTFwdSetDlyLine_32f: function(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdSetDlyLine_8s32f: function(pState:PIppsWTFwdState_8s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdSetDlyLine_8u32f: function(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdSetDlyLine_16s32f: function(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdSetDlyLine_16u32f: function(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdGetDlyLine_32f, ippsWTFwdGetDlyLine_8s32f,
//              ippsWTFwdGetDlyLine_8u32f, ippsWTFwdGetDlyLine_16s32f,
//              ippsWTFwdGetDlyLine_16u32f
//
// Purpose:     The function copies data from interanl delay linesstdcall;
//                to the pointed vectors.
// Parameters:
//   pState   - pointer to pState structure;
//   pDlyLow  - pointer to delay line for lowpass filtering;
//   pDlyHigh - pointer to delay line for highpass filtering.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers pDlyLow
//                              or pDlyHigh vectors are NULL;
//   ippStspStateMatchErr   - mismatch pState structure.
//
// Notes: lengths of delay lines:
//          len(pDlyLow)  = lenLow  + offsLow  - 1;
//          len(pDlyHigh) = lenHigh + offsHigh - 1;
//  lenLow, offsLow, lenHigh, offsHigh - parameters
//    for ippsWTFwdInitAlloc function.stdcall;
*)
  ippsWTFwdGetDlyLine_32f: function(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdGetDlyLine_8s32f: function(pState:PIppsWTFwdState_8s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdGetDlyLine_8u32f: function(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdGetDlyLine_16s32f: function(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTFwdGetDlyLine_16u32f: function(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwd_32f, ippsWTFwd_16s32f, ippsWTFwd_16u32f,
//              ippsWTFwd_8s32f, ippsWTFwd_8u32f
//
// Purpose:     Forward wavelet transform.
//
// Parameters:
//   pSrc     - pointer to source block of data;
//   pDstLow  - pointer to destination block of
//                "low-frequency" component;
//   pDstHigh - pointer to destination block of
//                "high-frequency" component;
//   dstLen   - length of destination;
//   pState    - pointer to pState structure.
//
//  Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers to pSrc, pDstLow
//                              or pDstHigh vectors are NULL;
//   ippStsSizeErr          - the length is less or equal zero;
//   ippStspStateMatchErr    - mismatch pState structure.
//
// Notes:      source block length must be 2 * dstLen.
*)
  ippsWTFwd_32f: function(pSrc:PIpp32f;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_32f):IppStatus;stdcall;

  ippsWTFwd_8s32f: function(pSrc:PIpp8s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8s32f):IppStatus;stdcall;

  ippsWTFwd_8u32f: function(pSrc:PIpp8u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8u32f):IppStatus;stdcall;

  ippsWTFwd_16s32f: function(pSrc:PIpp16s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16s32f):IppStatus;stdcall;

  ippsWTFwd_16u32f: function(pSrc:PIpp16u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16u32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdFree_32f, ippsWTFwdFree_8s32f, ippsWTFwdFree_8u32f,
//              ippsWTFwdFree_16s32f, ippsWTFwdFree_16u32f
//
// Purpose:     Free and Deallocate forward wavelet transofrm pState structure.
//
// Parameters:
//   IppsWTFwdState_32f *pState - pointer to pState structure.
//
//  Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - Pointer to pState structure is NULL;
//   ippStspStateMatchErr   - Mismatch pState structure.
//
// Notes:      if pointer to pState is NULL, ippStsNoErr will be returned.
*)
  ippsWTFwdFree_32f: function(pState:PIppsWTFwdState_32f):IppStatus;stdcall;

  ippsWTFwdFree_8s32f: function(pState:PIppsWTFwdState_8s32f):IppStatus;stdcall;

  ippsWTFwdFree_8u32f: function(pState:PIppsWTFwdState_8u32f):IppStatus;stdcall;

  ippsWTFwdFree_16s32f: function(pState:PIppsWTFwdState_16s32f):IppStatus;stdcall;

  ippsWTFwdFree_16u32f: function(pState:PIppsWTFwdState_16u32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvInitAlloc_32f,   ippsWTInvInitAlloc_32f8s,
//              ippsWTInvInitAlloc_32f8u, ippsWTInvInitAlloc_32f16s,
//              ippsWTInvInitAlloc_32f16u
//
// Purpose:     Allocate and initialize
//                inverse wavelet transform pState structure.
// Parameters:
//   pState    - pointer to pointer to allocated and initialized
//                pState structure.
//   pTapsLow  - pointer to lowpass filter taps;
//   lenLow    - length of lowpass filter;
//   offsLow   - input delay of lowpass filter;
//   pTapsHigh - pointer to highpass filter taps;
//   lenHigh   - length of highpass filter;
//   offsHigh  - input delay of highpass filter;
//
// Returns:
//   ippStsNoErr        - Ok;
//   ippStsNullPtrErr   - pointer to filter taps are NULL
//                          or pointer to pState structure is NULL;
//   ippStsSizeErr      - filter length is less or equal zero;
//   ippStsWtOffsetErr  - filter delay is less than (-1).
//
// Notes:       filter output delay minimum value is 0 that corresponds to
//             upsampling phase equal 0 (first sample included,
//                                          second sample is zero and so on);
//              pointer to returned error status may be NULL if no error
//             diagnostic required.
*)
  ippsWTInvInitAlloc_32f: function(var pState:PIppsWTInvState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTInvInitAlloc_32f8s: function(var pState:PIppsWTInvState_32f8s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTInvInitAlloc_32f8u: function(var pState:PIppsWTInvState_32f8u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTInvInitAlloc_32f16s: function(var pState:PIppsWTInvState_32f16s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

  ippsWTInvInitAlloc_32f16u: function(var pState:PIppsWTInvState_32f16u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvSetDlyLine_32f, ippsWTInvSetDlyLine_32f8s,
//              ippsWTInvSetDlyLine_32f8u, ippsWTInvSetDlyLine_32f16s,
//              ippsWTInvSetDlyLine_32f16u
//
// Purpose:     The function copies the pointed vectors to internal delay lines.stdcall;
//
// Parameters:
//   pState   - pointer to pState structure;
//   pDlyLow  - pointer to delay line for lowpass filtering;
//   pDlyHigh - pointer to delay line for highpass filtering.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers pDlyLow
//                              or pDlyHigh vectors are NULL;
//   ippStspStateMatchErr   - mismatch pState structure.
//
// Notes: lengths of delay lines (as "C" expression):
//          len(pDlyLow)  = (lenLow   + offsLow  - 1) / 2;
//          len(pDlyHigh) = (lenHigh  + offsHigh - 1) / 2;
//  lenLow, offsLow, lenHigh, offsHigh - parameters
//    for ippsWTInvInitAlloc function.stdcall;
*)
  ippsWTInvSetDlyLine_32f: function(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvSetDlyLine_32f8s: function(pState:PIppsWTInvState_32f8s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvSetDlyLine_32f8u: function(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvSetDlyLine_32f16s: function(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvSetDlyLine_32f16u: function(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvGetDlyLine_32f, ippsWTInvGetDlyLine_32f8s,
//              ippsWTInvGetDlyLine_32f8u, ippsWTInvGetDlyLine_32f16s,
//              ippsWTInvGetDlyLine_32f16u
//
// Purpose:     The function copies data from interanl delay lines;
//                to the pointed vectors.
// Parameters:
//   pState   - pointer to pState structure;
//   pDlyLow  - pointer to delay line for lowpass filtering;
//   pDlyHigh - pointer to delay line for highpass filtering.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers pDlyLow
//                              or pDlyHigh vectors are NULL;
//   ippStspStateMatchErr    - mismatch pState structure.
//
// Notes: lengths of delay lines (as "C" expression):
//          len(pDlyLow)  = (lenLow   + offsLow  - 1) / 2;
//          len(pDlyHigh) = (lenHigh  + offsHigh - 1) / 2;
//  lenLow, offsLow, lenHigh, offsHigh - parameters
//    for ippsWTInvInitAlloc function;
*)
  ippsWTInvGetDlyLine_32f: function(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvGetDlyLine_32f8s: function(pState:PIppsWTInvState_32f8s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvGetDlyLine_32f8u: function(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvGetDlyLine_32f16s: function(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

  ippsWTInvGetDlyLine_32f16u: function(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInv_32f, ippsWTInv_32f16s, ippsWTInv_32f16u,
//              ippsWTInv_32f8s, ippsWTInv_32f8u
//
// Purpose:     Inverse wavelet transform.
//
// Parameters:
//   srcLow  - pointer to source block of
//               "low-frequency" component;
//   srcHigh - pointer to source block of
//               "high-frequency" component;
//   dstLen  - length of components.
//   dst     - pointer to destination block of
//               reconstructed data;
//   pState  - pointer to pState structure;
//
//  Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers to pDst pSrcLow
//                              or pSrcHigh vectors are NULL;
//   ippStsSizeErr          - the length is less or equal zero;
//   ippStspStateMatchErr    - mismatch pState structure.
//
// Notes:      destination block length must be 2 * srcLen.
*)

  ippsWTInv_32f: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp32f;pState:PIppsWTInvState_32f):IppStatus;stdcall;

  ippsWTInv_32f8s: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8s;pState:PIppsWTInvState_32f8s):IppStatus;stdcall;

  ippsWTInv_32f8u: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8u;pState:PIppsWTInvState_32f8u):IppStatus;stdcall;

  ippsWTInv_32f16s: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16s;pState:PIppsWTInvState_32f16s):IppStatus;stdcall;

  ippsWTInv_32f16u: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16u;pState:PIppsWTInvState_32f16u):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvFree_32f, ippsWTInvFree_32f8s, ippsWTInvFree_32f8u,
//              ippsWTInvFree_32f16s, ippsWTInvFree_32f16u
//
// Purpose:     Free and Deallocate inverse wavelet transofrm pState structure.
//
// Parameters:
//   IppsWTInvState_32f *pState - pointer to pState structure.
//
//  Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - Pointer to pState structure is NULL;
//   ippStspStateMatchErr   - Mismatch pState structure.
//
// Notes:      if pointer to pState is NULL, ippStsNoErr will be returned.
*)
  ippsWTInvFree_32f: function(pState:PIppsWTInvState_32f):IppStatus;stdcall;

  ippsWTInvFree_32f8s: function(pState:PIppsWTInvState_32f8s):IppStatus;stdcall;

  ippsWTInvFree_32f8u: function(pState:PIppsWTInvState_32f8u):IppStatus;stdcall;

  ippsWTInvFree_32f16s: function(pState:PIppsWTInvState_32f16s):IppStatus;stdcall;

  ippsWTInvFree_32f16u: function(pState:PIppsWTInvState_32f16u):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                  Filtering
///////////////////////////////////////////////////////////////////////////// *)


(* /////////////////////////////////////////////////////////////////////////////
//                  Convolution functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConv
//  Purpose:    Linear Convolution of 1D signals
//  Parameters:
//      pSrc1                pointer to the first source vector
//      pSrc2                pointer to the second source vector
//      lenSrc1              length of the first source vector
//      lenSrc2              length of the second source vector
//      pDst                 pointer to the destination vector
//  Returns:    IppStatus
//      ippStsNullPtrErr        pointer(s) to the data is NULL
//      ippStsSizeErr           length of the vectors is less or equal zero
//      ippStsMemAllocErr       no memory for internal buffers
//      ippStsNoErr             otherwise
//  Notes:
//          Length of the destination data vector is lenSrc1+lenSrc2-1.
//          The input signal are exchangeable because of
//          commutative convolution property.
//          Some other values may be returned by FFT transform functions;
*)

  ippsConv_32f: function(pSrc1:PIpp32f;lenSrc1:longint;pSrc2:PIpp32f;lenSrc2:longint;pDst:PIpp32f):IppStatus;stdcall;
  ippsConv_16s_Sfs: function(pSrc1:PIpp16s;lenSrc1:longint;pSrc2:PIpp16s;lenSrc2:longint;pDst:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsConv_64f: function(pSrc1:PIpp64f;lenSrc1:longint;pSrc2:PIpp64f;lenSrc2:longint;pDst:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsConvCyclic
//  Purpose:    Cyclic Convolution of 1D signals of fixed size
//  Parameters: the pointers to data of fixed size
//  Returns:    IppStatus
//                ippStsNoErr    parameters are not checked
//  Notes:
//          The length of the convolution is given in the function name.;
*)

  ippsConvCyclic8x8_32f: function(x:PIpp32f;h:PIpp32f;y:PIpp32f):IppStatus;stdcall;
  ippsConvCyclic8x8_16s_Sfs: function(x:PIpp16s;h:PIpp16s;y:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsConvCyclic4x4_32f32fc: function(x:PIpp32f;h:PIpp32fc;y:PIpp32fc):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                     IIR filters (float and double taps versions)
///////////////////////////////////////////////////////////////////////////// *)

type

IppsIIRState_32f = pointer;
PIppsIIRState_32f =^IppsIIRState_32f;

IppsIIRState_32fc = pointer;
PIppsIIRState_32fc =^IppsIIRState_32fc;

IppsIIRState32f_16s = pointer;
PIppsIIRState32f_16s =^IppsIIRState32f_16s;

IppsIIRState32fc_16sc = pointer;
PIppsIIRState32fc_16sc =^IppsIIRState32fc_16sc;

IppsIIRState_64f = pointer;
PIppsIIRState_64f =^IppsIIRState_64f;

IppsIIRState_64fc = pointer;
PIppsIIRState_64fc =^IppsIIRState_64fc;

IppsIIRState64f_32f = pointer;
PIppsIIRState64f_32f =^IppsIIRState64f_32f;

IppsIIRState64fc_32fc = pointer;
PIppsIIRState64fc_32fc =^IppsIIRState64fc_32fc;

IppsIIRState64f_32s = pointer;
PIppsIIRState64f_32s =^IppsIIRState64f_32s;

IppsIIRState64fc_32sc = pointer;
PIppsIIRState64fc_32sc =^IppsIIRState64fc_32sc;

IppsIIRState64f_16s = pointer;
PIppsIIRState64f_16s =^IppsIIRState64f_16s;

IppsIIRState64fc_16sc = pointer;
PIppsIIRState64fc_16sc =^IppsIIRState64fc_16sc;

IppsIIRState32s_16s = pointer;
PIppsIIRState32s_16s =^IppsIIRState32s_16s;

IppsIIRState32sc_16sc = pointer;
PIppsIIRState32sc_16sc =^IppsIIRState32sc_16sc;


var
(* /////////////////////////////////////////////////////////////////////////////
//  Initialize context
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:     ippsIIRInitAlloc, ippsIIRFree
//  Purpose:       initialize context arbitrary order IIR filter
//  Parameters:
//      pState      - pointer to filter context
//      pTaps       - pointer to filter coefficients
//      order       - arbitrary filter order
//      pDelay      - pointer to delay line data, can be NULL
//  Return: IppStatus
//      ippStsMemAllocErr    - memory allocation error
//      ippStsNullPtrErr     - pointer(s) to the data is NULL
//      ippStsIIROrderErr    - filter order < 0
//      ippStsDivByZeroErr   - A(0) is zero
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNoErr          - otherwise
//  Order of the coefficients in the input taps buffer:
//     B(0),B(1),B(2)..,B(order);
//     A(0),A(1),A(2)..,A(order);
//     . . .
//  Note:
//      A(0) != 0
//      ippsIIRClose function works for both AR and BQ contexts;
*)

  ippsIIRInitAlloc_32f: function(var pState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRInitAlloc_32fc: function(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRInitAlloc32f_16s: function(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRInitAlloc32fc_16sc: function(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsIIRInitAlloc_64f: function(var pState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc_64fc: function(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRInitAlloc64f_32f: function(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc64fc_32fc: function(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRInitAlloc64f_32s: function(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc64fc_32sc: function(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRInitAlloc64f_16s: function(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc64fc_16sc: function(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsIIRFree_32f: function(pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIRFree_32fc: function(pState:PIppsIIRState_32fc):IppStatus;stdcall;
  ippsIIRFree32f_16s: function(pState:PIppsIIRState32f_16s):IppStatus;stdcall;
  ippsIIRFree32fc_16sc: function(pState:PIppsIIRState32fc_16sc):IppStatus;stdcall;

  ippsIIRFree_64f: function(pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIRFree_64fc: function(pState:PIppsIIRState_64fc):IppStatus;stdcall;
  ippsIIRFree64f_32f: function(pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIRFree64fc_32fc: function(pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;
  ippsIIRFree64f_32s: function(pState:PIppsIIRState64f_32s):IppStatus;stdcall;
  ippsIIRFree64fc_32sc: function(pState:PIppsIIRState64fc_32sc):IppStatus;stdcall;
  ippsIIRFree64f_16s: function(pState:PIppsIIRState64f_16s):IppStatus;stdcall;
  ippsIIRFree64fc_16sc: function(pState:PIppsIIRState64fc_16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:     ippsIIRInitAlloc_BiQuad
//  Purpose:   initialize biquad numBq-section filter
//  Parameters:
//      pState      - pointer to filter context
//      pTaps       - pointer to filter coefficients
//      numBq       - number biquads of BQ filter
//      pDelay      - pointer to delay line data, can be NULL
//  Return: IppStatus
//      ippStsMemAllocErr  - memory allocation error
//      ippStsNullPtrErr   - pointer(s) pState or pTaps is NULL
//      ippStsIIROrderErr  - numBq <= 0
//      ippStsDivByZeroErr - A(n,0) or B(n,0) is zero
//      ippStsNoErr        - otherwise
//
//  Order of the coefficients in the input taps buffer:
//     B(0,0),B(0,1),B(0,2),A(0,0),A(0,1),A(0,2);
//     B(1,0),B(1,1),B(1,2),A(1,0),A(1,1),A(1,2);
//     . . .
//  Notice:
//      A(n,0) != 0 and B(n,0) != 0
*)

  ippsIIRInitAlloc_BiQuad_32f: function(var pState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRInitAlloc_BiQuad_32fc: function(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRInitAlloc32f_BiQuad_16s: function(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRInitAlloc32fc_BiQuad_16sc: function(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsIIRInitAlloc_BiQuad_64f: function(var pState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc_BiQuad_64fc: function(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRInitAlloc64f_BiQuad_32f: function(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc64fc_BiQuad_32fc: function(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRInitAlloc64f_BiQuad_32s: function(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc64fc_BiQuad_32sc: function(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRInitAlloc64f_BiQuad_16s: function(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRInitAlloc64fc_BiQuad_16sc: function(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Work with Delay Line
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsIIRGetDlyLine, ippsIIRSetDlyLine
//  Purpose:    set and get delay line
//  Parameters:
//      pState              - pointer to IIR filter context
//      pDelay              - pointer to delay line to be set
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) pState or pDelay is NULL
//      ippStsNoErr            - otherwise
*)

  ippsIIRGetDlyLine_32f: function(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRSetDlyLine_32f: function(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;

  ippsIIRGetDlyLine_32fc: function(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRSetDlyLine_32fc: function(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsIIRGetDlyLine32f_16s: function(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRSetDlyLine32f_16s: function(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;stdcall;

  ippsIIRGetDlyLine32fc_16sc: function(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRSetDlyLine32fc_16sc: function(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsIIRGetDlyLine_64f: function(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine_64f: function(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;

  ippsIIRGetDlyLine_64fc: function(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine_64fc: function(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsIIRGetDlyLine64f_32f: function(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_32f: function(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;stdcall;

  ippsIIRGetDlyLine64fc_32fc: function(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine64fc_32fc: function(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsIIRGetDlyLine64f_32s: function(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_32s: function(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;stdcall;

  ippsIIRGetDlyLine64fc_32sc: function(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine64fc_32sc: function(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsIIRGetDlyLine64f_16s: function(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_16s: function(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;stdcall;

  ippsIIRGetDlyLine64fc_16sc: function(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine64fc_16sc: function(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Filtering
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:           ippsIIROne
//  Purpose:         IIR filter with float or double taps. One sample operation
//  Parameters:
//      pState              - pointer to IIR filter context
//      src                 - input sample
//      pDstVal             - output sample
//      scaleFactor         - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsNoErr            - otherwise
//
//  Note: Don't modify scaleFactor value unless context is changed
*)

  ippsIIROne_32f: function(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIROne_32fc: function(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsIIRState_32fc):IppStatus;stdcall;

  ippsIIROne32f_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIROne32fc_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsIIROne_64f: function(src:Ipp64f;pDstVal:PIpp64f;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIROne_64fc: function(src:Ipp64fc;pDstVal:PIpp64fc;pState:PIppsIIRState_64fc):IppStatus;stdcall;

  ippsIIROne64f_32f: function(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIROne64fc_32fc: function(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;

  ippsIIROne64f_32s_Sfs: function(src:Ipp32s;pDstVal:PIpp32s;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIROne64fc_32sc_Sfs: function(src:Ipp32sc;pDstVal:PIpp32sc;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsIIROne64f_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIROne64fc_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsIIR
//  Purpose:       IIR filter with float or double taps. Vector filtering
//  Parameters:
//      pState              - pointer to filter context
//      pSrcDst             - pointer to input/output vector in in-place ops
//      pSrc                - pointer to input vector
//      pDst                - pointer to output vector
//      len                 - length of the vectors
//      scaleFactor         - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsSizeErr          - length of the vectors <= 0
//      ippStsNoErr            - otherwise
//
//  Note: Don't modify scaleFactor value unless context is changed
*)

  ippsIIR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIR_32f_I: function(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIR_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;stdcall;
  ippsIIR_32fc_I: function(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;stdcall;

  ippsIIR32f_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32f_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32fc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32fc_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsIIR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIR_64f_I: function(pSrcDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIR_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;stdcall;
  ippsIIR_64fc_I: function(pSrcDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;stdcall;

  ippsIIR64f_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIR64f_32f_I: function(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIR64fc_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;
  ippsIIR64fc_32fc_I: function(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;

  ippsIIR64f_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64f_32s_ISfs: function(pSrcDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_32sc_ISfs: function(pSrcDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsIIR64f_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64f_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                     IIR filters (integer taps version)
///////////////////////////////////////////////////////////////////////////// *)


(* /////////////////////////////////////////////////////////////////////////////
//  Initialize context
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsIIRInitAlloc, ippsIIRInitAlloc_BiQuad, ippsIIRFree
//  Purpose:       create and initialize IIR context for AR filter
//  Parameters:
//      pState      - pointer to filter context
//      pTaps       - pointer to filter coefficients
//      order       - arbitrary filter order
//      tapsFactor  - scale factor for Ipp32s context taps
//      numBq       - number of biquads in BQ filter
//      pDelay      - pointer to delay line, may be NULL
//  Return:
//      ippStsNoErr        - Ok
//      ippStsMemAllocErr  - memory allocate error
//      ippStsNullPtrErr   - pointer(s) to pState or pTaps is NULL
//      ippStsIIROrderErr  - filter order < 0 or numBq <= 0
//      ippStsDivByZeroErr - A(0) or A(n,0) or B(n,0) is zero
//
//  the Ipp32s taps from the source Ipp32f taps and taps factor
//  may be prepared by this way, for example
//
//   ippsAbs_64f( taps, tmp, 6 );
//   ippsMax_64f( tmp, 6, &tmax );
//
//   tapsfactor = 0;
//   if( tmax > IPP_MAX_32S )
//      while( (tmax/=2) > IPP_MAX_32S ) ++tapsfactor;
//   else
//      while( (tmax*=2) < IPP_MAX_32S ) --tapsfactor;
//
//   if( tapsfactor > 0 )
//      ippsDivC_64f_I( (float)(1<<(++tapsfactor)), taps, 6 );
//   else if( tapsfactor < 0 )
//      ippsMulC_64f_I( (float)(1<<(-(tapsfactor))), taps, 6 );
//
//   ippsCnvrt_64f32s_Sfs( taps, taps32s, 6, rndNear, 0 );
//
//  Order of coefficients at the enter is:
//     B(0),B(1),...,B(order),A(0),A(1),...,A(order)
//  A(0) != 0
*)

  ippsIIRInitAlloc32s_16s: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;order:longint;tapsFactor:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIRInitAlloc32s_16s32f: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32s):IppStatus;stdcall;

  ippsIIRInitAlloc32sc_16sc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;order:longint;tapsFactor:longint;pDlyLine:PIpp32sc):IppStatus;stdcall;
  ippsIIRInitAlloc32sc_16sc32fc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32sc):IppStatus;stdcall;

  ippsIIRInitAlloc32s_BiQuad_16s: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIRInitAlloc32s_BiQuad_16s32f: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32s):IppStatus;stdcall;

  ippsIIRInitAlloc32sc_BiQuad_16sc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32sc):IppStatus;stdcall;
  ippsIIRInitAlloc32sc_BiQuad_16sc32fc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32sc):IppStatus;stdcall;

  ippsIIRFree32s_16s: function(pState:PIppsIIRState32s_16s):IppStatus;stdcall;
  ippsIIRFree32sc_16sc: function(pState:PIppsIIRState32sc_16sc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Work with Delay Line
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsIIRGetDlyLine, ippsIIRSetDlyLine
//  Purpose:    set and get delay line
//  Parameters:
//      pState              - pointer to IIR filter context
//      pDelay              - pointer to delay line to be set
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsNoErr            - otherwise
*)

  ippsIIRGetDlyLine32s_16s: function(pState:PIppsIIRState32s_16s;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIRSetDlyLine32s_16s: function(pState:PIppsIIRState32s_16s;pDlyLine:PIpp32s):IppStatus;stdcall;

  ippsIIRGetDlyLine32sc_16sc: function(pState:PIppsIIRState32sc_16sc;pDlyLine:PIpp32sc):IppStatus;stdcall;
  ippsIIRSetDlyLine32sc_16sc: function(pState:PIppsIIRState32sc_16sc;pDlyLine:PIpp32sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Filtering
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsIIROne
//  Purpose:       IIR filter. One sample operation
//  Parameters:
//      pState              - pointer to the filter context
//      src                 - the input sample
//      pDstVal             - pointer to the output sample
//      scaleFactor         - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong context
//      ippStsNullPtrErr       - pointer(s) to pState or pDstVal is NULL
//      ippStsNoErr            - otherwise
//
//  Note: Don't modify scaleFactor value unless context is changed
*)

  ippsIIROne32s_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIROne32sc_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:        ippsIIR
//  Purpose:      IIR filter. Vector filtering
//  Parameters:
//      pState              - pointer to the filter context
//      pSrc                - pointer to input data
//      pSrcDst             - pointer to input/ouput data
//      pDst                - pointer to output data
//      len                 - length of the vectors
//      scaleFactor         - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong context
//      ippStsNullPtrErr       - pointer(s) pState or pSrc or pDst is NULL
//      ippStsSizeErr          - length of the vectors <= 0
//      ippStsNoErr            - otherwise
//
//  Note: Don't modify scaleFactor value unless context is changed
*)

  ippsIIR32s_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32sc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsIIR32s_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32sc_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippsIIR_Direct_16s, ippsIIR_Direct_16s_I,
//          ippsIIROne_Direct_16s, ippsIIROne_Direct_16s_I,
//          ippsIIR_BiQuadDirect_16s, ippsIIR_BiQuadDirect_16s_I,
//          ippsIIROne_BiQuadDirect_16s, ippsIIROne_BiQuadDirect_16s_I.
//  Purpose: IIR filter with 16s taps. One sample (with suffix One), or vector
//           operation, direct (without State structure) form. Suffix "BiQuad"
//           means numBq-section filter, else the arbitrary coefficients IIR
//           filter.
//  Parameters:
//      pSrc        - pointer to the input array.
//      src         - input sample in 'One' case.
//      pDst        - pointer to the output array.
//      pDstVal     - pointer to the output sample in 'One' case.
//      pSrcDst     - pointer to the input and output array for the in-place
//                                                                   operation.
//      pSrcDstVal  - pointer to the input and output sample for in-place
//                                                     operation in 'One' case.
//      pTaps       - pointer to filter coefficients
//      order       - arbitrary filter order
//      numBq       - number biquads of BQ filter
//      pDlyLine    - pointer to delay line data
//  Return: IppStatus
//      ippStsNullPtrErr    - pointer(s) to the data is NULL
//      ippStsIIROrderErr   - filter order < 0
//      ippStsScaleRangeErr - if A(0) < 0, see "Note..."
//      ippStsMemAllocErr   - memory allocation error
//      ippStsSizeErr       - length of the vectors <= 0
//      ippStsNoErr         - otherwise
//
//  Order of the coefficients in the input taps buffer for the arbitrary
//                                                                      filter:
//     B(0),B(1),B(2)..,B(order);
//     A(0),A(1),A(2)..,A(order);
//     . . .
//  Note:
//      A(0) >= 0, and means the scale factor (not divisor !) for all the
//                                                                  other taps.
//  Order of the coefficients in the input taps buffer for BiQuad-section
//                                                                      filter:
//     B(0,0),B(0,1),B(0,2),A(0,0),A(0,1),A(0,2);
//     B(1,0),B(1,1),B(1,2),A(1,0),A(1,1),A(1,2);
//     ........
//  Note:
//      A(0,0) >= 0, A(1,0) >= 0..., and means the scale factor (not divisor !)
//      for all the other taps of each section.
*)

  ippsIIR_Direct_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIR_Direct_16s_I: function(pSrcDst:PIpp16s;len:longint;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIROne_Direct_16s: function(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIROne_Direct_16s_I: function(pSrcDst:PIpp16s;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;stdcall;

  ippsIIR_BiQuadDirect_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIR_BiQuadDirect_16s_I: function(pSrcDst:PIpp16s;len:longint;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIROne_BiQuadDirect_16s: function(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIROne_BiQuadDirect_16s_I: function(pSrcDstVal:PIpp16s;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;stdcall;



(* ////////////////////////////////////////////////////////////////////////////
//          Initialize IIR state with external memory buffer
//////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsIIRGetStateSize, ippsIIRGetStateSize_BiQuad,
//                ippsIIRInit, ippsIIRInit_BiQuad
//  Purpose:      ippsIIRGetStateSize - calculates the size of the IIR State
//                                                                   structure;
//                ippsIIRInit - initialize IIR state - set taps and delay line
//                using external memory buffer;
//  Parameters:
//      pTaps       - pointer to the filter coefficients;
//      order       - order of the filter;
//      numBq       - order of the filter;
//      pDlyLine    - pointer to the delay line values, can be NULL;
//      pState      - pointer to the IIR state created or NULL;
//      tapsFactor  - scaleFactor for taps (integer version);
//      pStateSize  - pointer where to store the calculated IIR State structure
//                                                             size (in bytes);
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsIIROrderErr      - order <= 0 or numBq < 1
//         ippStsNoErr            - otherwise
*)

(* ******************************** 32s_16s ******************************** *)
  ippsIIRGetStateSize32s_16s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32sc_16sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32s_BiQuad_16s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32sc_BiQuad_16sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit32s_16s: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;order:longint;tapsFactor:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32sc_16sc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;order:longint;tapsFactor:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32s_BiQuad_16s: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32sc_BiQuad_16sc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;stdcall;

(* ****************************** 32s_16s32f ******************************* *)
  ippsIIRGetStateSize32s_16s32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32sc_16sc32fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32s_BiQuad_16s32f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32sc_BiQuad_16sc32fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit32s_16s32f: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32sc_16sc32fc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32s_BiQuad_16s32f: function(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32sc_BiQuad_16sc32fc: function(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;stdcall;
(* ********************************** 32f ********************************** *)
  ippsIIRGetStateSize_32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_32fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_32f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_32fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit_32f: function(var pState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_32fc: function(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_32f: function(var pState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_32fc: function(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
(* ******************************** 32f_16s ******************************** *)
  ippsIIRGetStateSize32f_16s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32fc_16sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32f_BiQuad_16s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32fc_BiQuad_16sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit32f_16s: function(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32fc_16sc: function(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32f_BiQuad_16s: function(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32fc_BiQuad_16sc: function(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
(* ********************************** 64f ********************************** *)
  ippsIIRGetStateSize_64f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_64fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_64f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_64fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit_64f: function(var pState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_64fc: function(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_64f: function(var pState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_64fc: function(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
(* ******************************** 64f_16s ******************************** *)
  ippsIIRGetStateSize64f_16s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_16sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_16s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_BiQuad_16sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit64f_16s: function(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_16sc: function(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_16s: function(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_BiQuad_16sc: function(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
(* ******************************** 64f_32s ******************************** *)
  ippsIIRGetStateSize64f_32s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_32sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_32s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_BiQuad_32sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit64f_32s: function(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_32sc: function(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_32s: function(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_BiQuad_32sc: function(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
(* ******************************** 64f_32f ******************************** *)
  ippsIIRGetStateSize64f_32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_32fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_32f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_BiQuad_32fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRInit64f_32f: function(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_32fc: function(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_32f: function(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_BiQuad_32fc: function(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:              ippsIIRSetTaps
//  Purpose:            set new IIR taps values to state
//  Parameters:
//      pTaps       -   pointer to new IIR taps
//      pState      -   pointer to the IIR filter state
//      tapsFactor  -   scaleFactor for taps (integer version only)
//  Return:
//      ippStsContextMatchErr  -   wrong state identifier
//      ippStsNullPtrErr       -   pointer(s) to the data is NULL
//      ippStsNoErr            -   otherwise
*)
  ippsIIRSetTaps_32f: function(pTaps:PIpp32f;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIRSetTaps_32fc: function(pTaps:PIpp32fc;pState:PIppsIIRState_32fc):IppStatus;stdcall;
  ippsIIRSetTaps32f_16s: function(pTaps:PIpp32f;pState:PIppsIIRState32f_16s):IppStatus;stdcall;
  ippsIIRSetTaps32fc_16sc: function(pTaps:PIpp32fc;pState:PIppsIIRState32fc_16sc):IppStatus;stdcall;
  ippsIIRSetTaps32s_16s: function(pTaps:PIpp32s;pState:PIppsIIRState32s_16s;tapsFactor:longint):IppStatus;stdcall;
  ippsIIRSetTaps32sc_16sc: function(pTaps:PIpp32sc;pState:PIppsIIRState32sc_16sc;tapsFactor:longint):IppStatus;stdcall;
  ippsIIRSetTaps32s_16s32f: function(pTaps:PIpp32f;pState:PIppsIIRState32s_16s):IppStatus;stdcall;
  ippsIIRSetTaps32sc_16sc32fc: function(pTaps:PIpp32fc;pState:PIppsIIRState32sc_16sc):IppStatus;stdcall;
  ippsIIRSetTaps_64f: function(pTaps:PIpp64f;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIRSetTaps_64fc: function(pTaps:PIpp64fc;pState:PIppsIIRState_64fc):IppStatus;stdcall;
  ippsIIRSetTaps64f_32f: function(pTaps:PIpp64f;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIRSetTaps64fc_32fc: function(pTaps:PIpp64fc;pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;
  ippsIIRSetTaps64f_32s: function(pTaps:PIpp64f;pState:PIppsIIRState64f_32s):IppStatus;stdcall;
  ippsIIRSetTaps64fc_32sc: function(pTaps:PIpp64fc;pState:PIppsIIRState64fc_32sc):IppStatus;stdcall;
  ippsIIRSetTaps64f_16s: function(pTaps:PIpp64f;pState:PIppsIIRState64f_16s):IppStatus;stdcall;
  ippsIIRSetTaps64fc_16sc: function(pTaps:PIpp64fc;pState:PIppsIIRState64fc_16sc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                     FIR filters (float and double taps versions)
///////////////////////////////////////////////////////////////////////////// *)

type

IppsFIRState_32f = pointer;
PIppsFIRState_32f =^IppsFIRState_32f;

IppsFIRState_32fc = pointer;
PIppsFIRState_32fc =^IppsFIRState_32fc;

IppsFIRState32f_16s = pointer;
PIppsFIRState32f_16s =^IppsFIRState32f_16s;

IppsFIRState32fc_16sc = pointer;
PIppsFIRState32fc_16sc =^IppsFIRState32fc_16sc;

IppsFIRState_64f = pointer;
PIppsFIRState_64f =^IppsFIRState_64f;

IppsFIRState_64fc = pointer;
PIppsFIRState_64fc =^IppsFIRState_64fc;

IppsFIRState64f_32f = pointer;
PIppsFIRState64f_32f =^IppsFIRState64f_32f;

IppsFIRState64fc_32fc = pointer;
PIppsFIRState64fc_32fc =^IppsFIRState64fc_32fc;

IppsFIRState64f_32s = pointer;
PIppsFIRState64f_32s =^IppsFIRState64f_32s;

IppsFIRState64fc_32sc = pointer;
PIppsFIRState64fc_32sc =^IppsFIRState64fc_32sc;

IppsFIRState64f_16s = pointer;
PIppsFIRState64f_16s =^IppsFIRState64f_16s;

IppsFIRState64fc_16sc = pointer;
PIppsFIRState64fc_16sc =^IppsFIRState64fc_16sc;

IppsFIRState32s_16s = pointer;
PIppsFIRState32s_16s =^IppsFIRState32s_16s;

IppsFIRState32sc_16sc = pointer;
PIppsFIRState32sc_16sc =^IppsFIRState32sc_16sc;

var
(* /////////////////////////////////////////////////////////////////////////////
//  Initialize FIR state
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:         ippsFIRInitAlloc, ippsFIRMRInitAlloc, ippsFIRFree
//  Purpose:      create and initialize FIR state - set taps and delay line
//                and close it
//  Parameters:
//      pTaps       - pointer to the filter coefficients
//      tapsLen     - number of coefficients
//      pDlyLine    - pointer to the delay line values, can be NULL
//      state       - pointer to the FIR state created or NULL;
//   Return:
//      status      - status value returned, its value are
//         ippStsMemAllocErr      - memory allocation error
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsFIRLenErr        - tapsLen <= 0
//         ippStsFIRMRFactorErr   - factor <= 0
//         ippStsFIRMRPhaseErr    - phase < 0 || factor <= phase
//         ippStsContextMatchErr  - wrong state identifier
//         ippStsNoErr            - otherwise
*)

  ippsFIRInitAlloc_32f: function(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRMRInitAlloc_32f: function(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRInitAlloc_32fc: function(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsFIRMRInitAlloc_32fc: function(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRInitAlloc32f_16s: function(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRMRInitAlloc32f_16s: function(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRInitAlloc32fc_16sc: function(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRMRInitAlloc32fc_16sc: function(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;

  ippsFIRInitAlloc_64f: function(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsFIRMRInitAlloc_64f: function(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsFIRInitAlloc_64fc: function(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsFIRMRInitAlloc_64fc: function(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsFIRInitAlloc64f_32f: function(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRMRInitAlloc64f_32f: function(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRInitAlloc64fc_32fc: function(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsFIRMRInitAlloc64fc_32fc: function(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRInitAlloc64f_32s: function(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsFIRMRInitAlloc64f_32s: function(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsFIRInitAlloc64fc_32sc: function(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc):IppStatus;stdcall;
  ippsFIRMRInitAlloc64fc_32sc: function(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc):IppStatus;stdcall;

  ippsFIRInitAlloc64f_16s: function(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRMRInitAlloc64f_16s: function(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRInitAlloc64fc_16sc: function(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRMRInitAlloc64fc_16sc: function(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;

  ippsFIRFree_32f: function(pState:PIppsFIRState_32f):IppStatus;stdcall;

  ippsFIRFree_32fc: function(pState:PIppsFIRState_32fc):IppStatus;stdcall;

  ippsFIRFree32f_16s: function(pState:PIppsFIRState32f_16s):IppStatus;stdcall;

  ippsFIRFree32fc_16sc: function(pState:PIppsFIRState32fc_16sc):IppStatus;stdcall;

  ippsFIRFree_64f: function(pState:PIppsFIRState_64f):IppStatus;stdcall;

  ippsFIRFree_64fc: function(pState:PIppsFIRState_64fc):IppStatus;stdcall;

  ippsFIRFree64f_32f: function(pState:PIppsFIRState64f_32f):IppStatus;stdcall;

  ippsFIRFree64fc_32fc: function(pState:PIppsFIRState64fc_32fc):IppStatus;stdcall;

  ippsFIRFree64f_32s: function(pState:PIppsFIRState64f_32s):IppStatus;stdcall;

  ippsFIRFree64fc_32sc: function(pState:PIppsFIRState64fc_32sc):IppStatus;stdcall;

  ippsFIRFree64f_16s: function(pState:PIppsFIRState64f_16s):IppStatus;stdcall;

  ippsFIRFree64fc_16sc: function(pState:PIppsFIRState64fc_16sc):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//          Initialize FIR state with external memory buffer
//////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsFIRGetStateSize, ippsFIRMRGetStateSize,
//                ippsFIRInit, ippsFIRMRInit
//  Purpose:      ippsFIRGetStateSize - calculates the size of the FIR State
//                                                                   structure;
//                ippsFIRInit - initialize FIR state - set taps and delay line
//                using external memory buffer;
//  Parameters:
//      pTaps       - pointer to the filter coefficients;
//      tapsLen     - number of coefficients;
//      pDlyLine    - pointer to the delay line values, can be NULL;
//      pState      - pointer to the FIR state created or NULL;
//      upFactor    - multi-rate up factor;
//      upPhase     - multi-rate up phase;
//      downFactor  - multi-rate down factor;
//      downPhase   - multi-rate down phase;
//      pStateSize  - pointer where to store the calculated FIR State structure
//                                                             size (in bytes);
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsFIRLenErr        - tapsLen <= 0
//         ippStsFIRMRFactorErr   - factor <= 0
//         ippStsFIRMRPhaseErr    - phase < 0 || factor <= phase
//         ippStsNoErr            - otherwise
*)

(* ******************************** 32s_16s ******************************** *)
  ippsFIRGetStateSize32s_16s: function(tapsLen:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRInit32s_16s: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize32s_16s: function(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit32s_16s: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRInit32sc_16sc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize32sc_16sc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit32sc_16sc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize32sc_16sc32fc: function(tapsLen:longint;pStateSize:Plongint):IppStatus;stdcall;
(* ****************************** 32s_16s32f ******************************* *)
  ippsFIRGetStateSize32s_16s32f: function(tapsLen:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRInit32s_16s32f: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize32s_16s32f: function(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit32s_16s32f: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize32sc_16sc: function(tapsLen:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRInit32sc_16sc32fc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize32sc_16sc32fc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit32sc_16sc32fc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
(* ********************************** 32f ********************************** *)
  ippsFIRInit_32f: function(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRInit_32fc: function(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize_32f: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRGetStateSize_32fc: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit_32f: function(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize_32f: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRGetStateSize_32fc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit_32fc: function(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;stdcall;
(* ******************************** 32f_16s ******************************** *)
  ippsFIRGetStateSize32f_16s: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit32f_16s: function(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize32fc_16sc: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit32fc_16sc: function(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize32f_16s: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit32f_16s: function(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize32fc_16sc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit32fc_16sc: function(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
(* ********************************** 64f ********************************** *)
  ippsFIRInit_64f: function(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRInit_64fc: function(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize_64f: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRGetStateSize_64fc: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit_64f: function(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize_64f: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRGetStateSize_64fc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit_64fc: function(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc;pBuffer:PIpp8u):IppStatus;stdcall;
(* ******************************** 64f_16s ******************************** *)
  ippsFIRGetStateSize64f_16s: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit64f_16s: function(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize64fc_16sc: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit64fc_16sc: function(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize64f_16s: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit64f_16s: function(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize64fc_16sc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit64fc_16sc: function(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;stdcall;
(* ******************************** 64f_32s ******************************** *)
  ippsFIRGetStateSize64f_32s: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit64f_32s: function(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize64fc_32sc: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit64fc_32sc: function(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize64f_32s: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit64f_32s: function(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize64fc_32sc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit64fc_32sc: function(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;pBuffer:PIpp8u):IppStatus;stdcall;
(* ******************************** 64f_32f ******************************** *)
  ippsFIRGetStateSize64f_32f: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit64f_32f: function(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGetStateSize64fc_32fc: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRInit64fc_32fc: function(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize64f_32f: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit64f_32f: function(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRMRGetStateSize64fc_32fc: function(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRMRInit64fc_32fc: function(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:              ippsFIRGetTaps
//  Purpose:            get FIR taps value from state
//  Parameters:
//      pTaps       -   pointer to buffer to get FIR taps
//      pState      -   pointer to the FIR filter state
//  Return:
//      ippStsContextMatchErr  -   wrong state identifier
//      ippStsNullPtrErr       -   pointer(s) to the data is NULL
//      ippStsNoErr            -   otherwise
*)

  ippsFIRGetTaps_32f: function(pState:PIppsFIRState_32f;pTaps:PIpp32f):IppStatus;stdcall;
  ippsFIRGetTaps_32fc: function(pState:PIppsFIRState_32fc;pTaps:PIpp32fc):IppStatus;stdcall;

  ippsFIRGetTaps32f_16s: function(pState:PIppsFIRState32f_16s;pTaps:PIpp32f):IppStatus;stdcall;
  ippsFIRGetTaps32fc_16sc: function(pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc):IppStatus;stdcall;

  ippsFIRGetTaps_64f: function(pState:PIppsFIRState_64f;pTaps:PIpp64f):IppStatus;stdcall;
  ippsFIRGetTaps_64fc: function(pState:PIppsFIRState_64fc;pTaps:PIpp64fc):IppStatus;stdcall;

  ippsFIRGetTaps64f_32f: function(pState:PIppsFIRState64f_32f;pTaps:PIpp64f):IppStatus;stdcall;
  ippsFIRGetTaps64fc_32fc: function(pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc):IppStatus;stdcall;

  ippsFIRGetTaps64f_32s: function(pState:PIppsFIRState64f_32s;pTaps:PIpp64f):IppStatus;stdcall;
  ippsFIRGetTaps64fc_32sc: function(pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc):IppStatus;stdcall;

  ippsFIRGetTaps64f_16s: function(pState:PIppsFIRState64f_16s;pTaps:PIpp64f):IppStatus;stdcall;
  ippsFIRGetTaps64fc_16sc: function(pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:              ippsFIRGSetTaps
//  Purpose:            set FIR taps value to state
//  Parameters:
//      pTaps       -   pointer to buffer to set FIR taps
//      pState      -   pointer to the FIR filter state
//  Return:
//      ippStsContextMatchErr  -   wrong state identifier
//      ippStsNullPtrErr       -   pointer(s) to the data is NULL
//      ippStsNoErr            -   otherwise
*)

  ippsFIRSetTaps_32f: function(pTaps:PIpp32f;pState:PIppsFIRState_32f):IppStatus;stdcall;
  ippsFIRSetTaps_32fc: function(pTaps:PIpp32fc;pState:PIppsFIRState_32fc):IppStatus;stdcall;
  ippsFIRSetTaps32f_16s: function(pTaps:PIpp32f;pState:PIppsFIRState32f_16s):IppStatus;stdcall;
  ippsFIRSetTaps32fc_16sc: function(pTaps:PIpp32fc;pState:PIppsFIRState32fc_16sc):IppStatus;stdcall;
  ippsFIRSetTaps32s_16s: function(pTaps:PIpp32s;pState:PIppsFIRState32s_16s;tapsFactor:longint):IppStatus;stdcall;
  ippsFIRSetTaps32sc_16sc: function(pTaps:PIpp32sc;pState:PIppsFIRState32sc_16sc;tapsFactor:longint):IppStatus;stdcall;
  ippsFIRSetTaps32s_16s32f: function(pTaps:PIpp32f;pState:PIppsFIRState32s_16s):IppStatus;stdcall;
  ippsFIRSetTaps32sc_16sc32fc: function(pTaps:PIpp32fc;pState:PIppsFIRState32sc_16sc):IppStatus;stdcall;
  ippsFIRSetTaps_64f: function(pTaps:PIpp64f;pState:PIppsFIRState_64f):IppStatus;stdcall;
  ippsFIRSetTaps_64fc: function(pTaps:PIpp64fc;pState:PIppsFIRState_64fc):IppStatus;stdcall;
  ippsFIRSetTaps64f_32f: function(pTaps:PIpp64f;pState:PIppsFIRState64f_32f):IppStatus;stdcall;
  ippsFIRSetTaps64fc_32fc: function(pTaps:PIpp64fc;pState:PIppsFIRState64fc_32fc):IppStatus;stdcall;
  ippsFIRSetTaps64f_32s: function(pTaps:PIpp64f;pState:PIppsFIRState64f_32s):IppStatus;stdcall;
  ippsFIRSetTaps64fc_32sc: function(pTaps:PIpp64fc;pState:PIppsFIRState64fc_32sc):IppStatus;stdcall;
  ippsFIRSetTaps64f_16s: function(pTaps:PIpp64f;pState:PIppsFIRState64f_16s):IppStatus;stdcall;
  ippsFIRSetTaps64fc_16sc: function(pTaps:PIpp64fc;pState:PIppsFIRState64fc_16sc):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Work with Delay Line
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:           ippsFIRGetDlyLine, ippsFIRSetDlyLine
//  Purpose:         set and get delay line
//  Parameters:
//      pDlyLine            - pointer to delay line
//      pState              - pointer to the filter state
//  Return:
//      ippStsContextMatchErr  - wrong state identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsNoErr            - otherwise
//  Note: pDlyLine may be NULL
*)

  ippsFIRGetDlyLine_32f: function(pState:PIppsFIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRSetDlyLine_32f: function(pState:PIppsFIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;

  ippsFIRGetDlyLine_32fc: function(pState:PIppsFIRState_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsFIRSetDlyLine_32fc: function(pState:PIppsFIRState_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRGetDlyLine32f_16s: function(pState:PIppsFIRState32f_16s;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRSetDlyLine32f_16s: function(pState:PIppsFIRState32f_16s;pDlyLine:PIpp16s):IppStatus;stdcall;

  ippsFIRGetDlyLine32fc_16sc: function(pState:PIppsFIRState32fc_16sc;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRSetDlyLine32fc_16sc: function(pState:PIppsFIRState32fc_16sc;pDlyLine:PIpp16sc):IppStatus;stdcall;

  ippsFIRGetDlyLine_64f: function(pState:PIppsFIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsFIRSetDlyLine_64f: function(pState:PIppsFIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;

  ippsFIRGetDlyLine_64fc: function(pState:PIppsFIRState_64fc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsFIRSetDlyLine_64fc: function(pState:PIppsFIRState_64fc;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsFIRGetDlyLine64f_32f: function(pState:PIppsFIRState64f_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRSetDlyLine64f_32f: function(pState:PIppsFIRState64f_32f;pDlyLine:PIpp32f):IppStatus;stdcall;

  ippsFIRGetDlyLine64fc_32fc: function(pState:PIppsFIRState64fc_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsFIRSetDlyLine64fc_32fc: function(pState:PIppsFIRState64fc_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRGetDlyLine64f_32s: function(pState:PIppsFIRState64f_32s;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsFIRSetDlyLine64f_32s: function(pState:PIppsFIRState64f_32s;pDlyLine:PIpp32s):IppStatus;stdcall;

  ippsFIRGetDlyLine64fc_32sc: function(pState:PIppsFIRState64fc_32sc;pDlyLine:PIpp32sc):IppStatus;stdcall;
  ippsFIRSetDlyLine64fc_32sc: function(pState:PIppsFIRState64fc_32sc;pDlyLine:PIpp32sc):IppStatus;stdcall;

  ippsFIRGetDlyLine64f_16s: function(pState:PIppsFIRState64f_16s;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRSetDlyLine64f_16s: function(pState:PIppsFIRState64f_16s;pDlyLine:PIpp16s):IppStatus;stdcall;

  ippsFIRGetDlyLine64fc_16sc: function(pState:PIppsFIRState64fc_16sc;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRSetDlyLine64fc_16sc: function(pState:PIppsFIRState64fc_16sc;pDlyLine:PIpp16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Filtering
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsFIROne
//  Purpose:       FIR filter. One point filtering
//  Parameters:
//      src            - input sample
//      pDstVal        - output sample
//      pState         - pointer to the filter state
//      scaleFactor    - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong state identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsNoErr            - otherwise
*)

  ippsFIROne_32f: function(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsFIRState_32f):IppStatus;stdcall;
  ippsFIROne_32fc: function(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsFIRState_32fc):IppStatus;stdcall;

  ippsFIROne32f_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne32fc_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne_64f: function(src:Ipp64f;pDstVal:PIpp64f;pState:PIppsFIRState_64f):IppStatus;stdcall;
  ippsFIROne_64fc: function(src:Ipp64fc;pDstVal:PIpp64fc;pState:PIppsFIRState_64fc):IppStatus;stdcall;

  ippsFIROne64f_32f: function(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsFIRState64f_32f):IppStatus;stdcall;
  ippsFIROne64fc_32fc: function(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsFIRState64fc_32fc):IppStatus;stdcall;

  ippsFIROne64f_32s_Sfs: function(src:Ipp32s;pDstVal:PIpp32s;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne64fc_32sc_Sfs: function(src:Ipp32sc;pDstVal:PIpp32sc;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne64f_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne64fc_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsFIR
//  Purpose:       FIR filter. Vector filtering
//  Parameters:
//      pSrcDst     - pointer to the input/output vector in in-place operation
//      pSrc        - pointer to the input vector
//      pDst        - pointer to the output vector
//      numIters    - number iterations (for single-rate equal length data vector)
//      pState      - pointer to the filter state
//      scaleFactor - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong state identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsSizeErr          - numIters is less or equal zero
//      ippStsNoErr            - otherwise
//  Note: for Multi-Rate filtering
//          length pSrc = numIters*downFactor
//          length pDst = numIters*upFactor
//          for inplace functions max this valuesstdcall;
*)

  ippsFIR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pState:PIppsFIRState_32f):IppStatus;stdcall;
  ippsFIR_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pState:PIppsFIRState_32fc):IppStatus;stdcall;

  ippsFIR32f_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32fc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR_32f_I: function(pSrcDst:PIpp32f;numIters:longint;pState:PIppsFIRState_32f):IppStatus;stdcall;
  ippsFIR_32fc_I: function(pSrcDst:PIpp32fc;numIters:longint;pState:PIppsFIRState_32fc):IppStatus;stdcall;

  ippsFIR32f_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32fc_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pState:PIppsFIRState_64f):IppStatus;stdcall;
  ippsFIR_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pState:PIppsFIRState_64fc):IppStatus;stdcall;

  ippsFIR_64f_I: function(pSrcDst:PIpp64f;numIters:longint;pState:PIppsFIRState_64f):IppStatus;stdcall;
  ippsFIR_64fc_I: function(pSrcDst:PIpp64fc;numIters:longint;pState:PIppsFIRState_64fc):IppStatus;stdcall;

  ippsFIR64f_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pState:PIppsFIRState64f_32f):IppStatus;stdcall;
  ippsFIR64fc_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pState:PIppsFIRState64fc_32fc):IppStatus;stdcall;

  ippsFIR64f_32f_I: function(pSrcDst:PIpp32f;numIters:longint;pState:PIppsFIRState64f_32f):IppStatus;stdcall;
  ippsFIR64fc_32fc_I: function(pSrcDst:PIpp32fc;numIters:longint;pState:PIppsFIRState64fc_32fc):IppStatus;stdcall;

  ippsFIR64f_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR64f_32s_ISfs: function(pSrcDst:PIpp32s;numIters:longint;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_32sc_ISfs: function(pSrcDst:PIpp32sc;numIters:longint;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR64f_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR64f_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                     FIR filters (integer taps version)
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Initialize State
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:       ippsFIRInitAlloc, ippsFIRMRInitAlloc, ippsFIRFree
//  Purpose:     create and initialize FIR state, set taps and delay line
//  Parameters:
//      pTaps          - pointer to the filter coefficients
//      tapsLen        - number of coefficients
//      tapsFactor     - scale factor of Ipp32s taps
//      pDlyLine       - pointer delay line, may be NULL
//      state          - pointer to the state created or NULL
//  Return:
//      status         - status returned, its values are
//          ippStsMemAllocErr  - memory allocation error
//          ippStsNullPtrErr   - pointer(s) to the data is NULL
//          ippStsFIRLenErr    - tapsLen <= 0
//          ippStsFIRMRFactorErr   - factor <= 0
//          ippStsFIRMRPhaseErr    - phase < 0 || factor <= phase
//          ippStsNoErr        - otherwise
//  Notes:   pTaps and tapsFactor for Ipp32s calculate as follows
//
//          Ipp64f mpy = 1.0;
//          Ipp32f pFTaps[tapsLen];     // true values of the coefficients
//          Ipp32s pTaps[tapsLen];      // values to be pass to integer FIR
//
//          ... calculate coefficients, filling pFTaps ...
//
//          max = MAX(abs(pFTaps[i]));   for i = 0..tapsLen-1
//
//          tapsFactor = 0;
//          if (max > IPP_MAX_32S) {
//              while (max > IPP_MAX_32S) {
//                  tapsFactor++;
//                  max *= 0.5;
//                  mpy *= 0.5;
//              }
//          } else {
//              while (max < IPP_MAX_32S && tapsFactor > -17) {
//                  tapsFactor--;
//                  max += max;
//                  mpy += mpy;
//              }
//              tapsFactor++;
//              mpy *= 0.5;
//          }
//
//          for (i = 0; i < tapsLen; i++)
//              if (pFTaps[i] < 0)
//                  pSTaps[i] = (Ipp32s)(mpy*pFTaps[i]-0.5);
//              else
//                  pSTaps[i] = (Ipp32s)(mpy*pFTaps[i]+0.5);
*)
  ippsFIRInitAlloc32s_16s: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRMRInitAlloc32s_16s: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRInitAlloc32s_16s32f: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRMRInitAlloc32s_16s32f: function(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRInitAlloc32sc_16sc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRMRInitAlloc32sc_16sc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRInitAlloc32sc_16sc32fc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRMRInitAlloc32sc_16sc32fc: function(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;stdcall;

  ippsFIRFree32s_16s: function(pState:PIppsFIRState32s_16s):IppStatus;stdcall;

  ippsFIRFree32sc_16sc: function(pState:PIppsFIRState32sc_16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:              ippsFIRGetTaps
//  Purpose:            get FIR taps value from state
//  Parameters:
//      pTaps       -   pointer to buffer to get FIR taps
//      pState      -   pointer to the FIR filter state
//  Return:
//      ippStsContextMatchErr  -   wrong state identifier
//      ippStsNullPtrErr       -   pointer(s) to the data is NULL
//      ippStsNoErr            -   otherwise
*)

  ippsFIRGetTaps32s_16s: function(pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsFactor:Plongint):IppStatus;stdcall;
  ippsFIRGetTaps32sc_16sc: function(pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsFactor:Plongint):IppStatus;stdcall;
  ippsFIRGetTaps32s_16s32f: function(pState:PIppsFIRState32s_16s;pTaps:PIpp32f):IppStatus;stdcall;
  ippsFIRGetTaps32sc_16sc32fc: function(pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Work with Delay Line
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:             ippsFIRGetDlyLine, ippsFIRSetDlyLine
//  Purpose:           set and get delay line
//  Parameters:
//      pDlyLine       - pointer to the delay line
//      pState         - pointer to the FIR filter state
//  Return:
//      ippStsContextMatchErr  -   wrong state identifier
//      ippStsNullPtrErr       -   pointer(s) to the data is NULL
//      ippStsNoErr            -   otherwise
//  Note: pDlyLine may be NULL
*)

  ippsFIRGetDlyLine32s_16s: function(pState:PIppsFIRState32s_16s;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRSetDlyLine32s_16s: function(pState:PIppsFIRState32s_16s;pDlyLine:PIpp16s):IppStatus;stdcall;
  ippsFIRGetDlyLine32sc_16sc: function(pState:PIppsFIRState32sc_16sc;pDlyLine:PIpp16sc):IppStatus;stdcall;
  ippsFIRSetDlyLine32sc_16sc: function(pState:PIppsFIRState32sc_16sc;pDlyLine:PIpp16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Filtering
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsFIROne, ippsFIROne
//  Purpose:          FIR filter with integer taps. One sample filtering
//  Parameters:
//      src            - input sample
//      pDstVal        - pointer to the output sample
//      pState         - pointer to the FIR filter state
//      scaleFactor    - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong state identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsNoErr            - otherwise
*)
  ippsFIROne32s_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne32sc_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:        ippsFIR
//  Purpose:      FIR filter with integer taps. Vector filtering
//  Parameters:
//      pSrc          - pointer to the input vector
//      pDst          - pointer to the output vector
//      pSrcDst       - pointer to input/output vector in in-place operation
//      numIters      - number iterations (for single-rate equal length data vector)
//      pState        - pointer to the filter state
//      scaleFactor   - scale factor value
//  Return:
//      ippStsContextMatchErr  - wrong State identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsSizeErr          - numIters <= 0
//      ippStsNoErr            - otherwise
//  Note: for Multi-Rate filtering
//          length pSrc = numIters*downFactor
//          length pDst = numIters*upFactor
//          for inplace functions max this valuesstdcall;
*)

  ippsFIR32s_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32sc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR32s_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32sc_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                  FIR LMS filters
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//   Names:     ippsFIRLMSOne_Direct
//   Purpose:   direct form of a FIR LMS filter. One point operation.
//   Parameters:
//      src          source signal sample
//      refval       desired signal sample
//      pTapsInv     FIR taps coefficient values to be fitted
//      tapsLen      number of the taps
//      pDlyLine     pointer to the delay line values
//      pDlyIndex    pointer to the current index of delay line
//      mu           adaptation step
//      muQ15        adaptation step, integer version
//                   muQ15 = (int)(mu * (1<<15) + 0.5f)
//      pDstVal      where write output sample to
//   Return:
//      ippStsNullPtrErr  pointer the the data is null
//      ippStsSizeErr     the taps length is equal or less zero
//      ippStsNoErr       otherwise
//   Note: adaptation error value has been deleted from the parameter
//         list because it can be computed as (refval - dst).
//         taps array is enverted, delay line is of double size = tapsLen * 2
*)
  ippsFIRLMSOne_Direct_32f: function(src:Ipp32f;refval:Ipp32f;pDstVal:PIpp32f;pTapsInv:PIpp32f;tapsLen:longint;mu:single;pDlyLine:PIpp32f;pDlyIndex:Plongint):IppStatus;stdcall;

  ippsFIRLMSOne_Direct32f_16s: function(src:Ipp16s;refval:Ipp16s;pDstVal:PIpp16s;pTapsInv:PIpp32f;tapsLen:longint;mu:single;pDlyLine:PIpp16s;pDlyIndex:Plongint):IppStatus;stdcall;

  ippsFIRLMSOne_DirectQ15_16s: function(src:Ipp16s;refval:Ipp16s;pDstVal:PIpp16s;pTapsInv:PIpp32s;tapsLen:longint;muQ15:longint;pDlyLine:PIpp16s;pDlyIndex:Plongint):IppStatus;stdcall;


(* context oriented functions *)
type
  IppsFIRLMSState_32f = pointer;
  PIppsFIRLMSState_32f =^IppsFIRLMSState_32f;

  IppsFIRLMSState32f_16s = pointer;
  PIppsFIRLMSState32f_16s =^IppsFIRLMSState32f_16s;



var
(* /////////////////////////////////////////////////////////////////////////////
//   Names:      ippsFIRLMS
//   Purpose:    LMS filtering with context use
//   Parameters:
//      pState    pointer to the state
//      pSrc      pointer to the source signal
//      pRef      pointer to the desired signal
//      pDst      pointer to the output signal
//      len       length of the signals
//      mu        adaptation step
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsSizeErr          the length of signals is equal or less zero
//      ippStsContextMatchErr    wrong state identifier
//      ippStsNoErr            otherwise
*)
  ippsFIRLMS_32f: function(pSrc:PIpp32f;pRef:PIpp32f;pDst:PIpp32f;len:longint;mu:single;pState:PIppsFIRLMSState_32f):IppStatus;stdcall;

  ippsFIRLMS32f_16s: function(pSrc:PIpp16s;pRef:PIpp16s;pDst:PIpp16s;len:longint;mu:single;pStatel:PIppsFIRLMSState32f_16s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSInitAlloc, ippsFIRLMSFree
//   Purpose:     LMS initialization functionsstdcall;
//   Parameters:
//      pTaps     pointer to the taps values. May be null
//      tapsLen   number of the taps
//      pDlyLine  pointer to the delay line. May be null
//      dlyLineIndex  current index value for the delay line
//      pState    address of pointer to the state returned
//   Return:
//      ippStsNullPtrErr       pointer is null
//      ippStsContextMatchErr    wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSInitAlloc_32f: function(var pState:PIppsFIRLMSState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;stdcall;

  ippsFIRLMSInitAlloc32f_16s: function(var pState:PIppsFIRLMSState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;stdcall;

  ippsFIRLMSFree_32f: function(pState:PIppsFIRLMSState_32f):IppStatus;stdcall;
  ippsFIRLMSFree32f_16s: function(pState:PIppsFIRLMSState32f_16s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:        ippsFIRLMSGetTaps
//   Purpose:      get taps values
//   Parameters:
//      pstate          pointer to the state
//      pTaps           pointer to the array to store the taps values
//   Return:
//      ippStsNullPtrErr   pointer to the data is null
//      ippStsNoErr        otherwise
*)

  ippsFIRLMSGetTaps_32f: function(pState:PIppsFIRLMSState_32f;pOutTaps:PIpp32f):IppStatus;stdcall;
  ippsFIRLMSGetTaps32f_16s: function(pState:PIppsFIRLMSState32f_16s;pOutTaps:PIpp32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSGetDlyl, ippsFIRLMSSetDlyl
//   Purpose:     set or get delay line
//   Parameters:
//      pState         pointer to the state structure
//      pDlyLine       pointer to the delay line of the single size = tapsLen
//      pDlyLineIndex  pointer to get the current delay line index
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsContextMatchErr    wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSGetDlyLine_32f: function(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIRLMSGetDlyLine32f_16s: function(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIRLMSSetDlyLine_32f: function(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;stdcall;
  ippsFIRLMSSetDlyLine32f_16s: function(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  FIR LMS MR filters
///////////////////////////////////////////////////////////////////////////// *)

(* context oriented functions *)
type

IppsFIRLMSMRState32s_16s = pointer;
PIppsFIRLMSMRState32s_16s =^IppsFIRLMSMRState32s_16s;

IppsFIRLMSMRState32sc_16sc = pointer;
PIppsFIRLMSMRState32sc_16sc =^IppsFIRLMSMRState32sc_16sc;



var
(* /////////////////////////////////////////////////////////////////////////////
//   Names:      ippsFIRLMSMROne, ippsFIRLMSMROneVal
//   Purpose:    LMS MR filtering with context use
//   Parameters:
//      val       the source signal last value to update delay line
//      pDstVal   pointer to the output signal value
//      pState    pointer to the state
//   Return:
//      ippStsNullPtrErr        pointer to the data is null
//      ippStsContextMatchErr   wrong state identifier
//      ippStsNoErr             otherwise
*)
  ippsFIRLMSMROne32s_16s: function(pDstVal:PIpp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;stdcall;
  ippsFIRLMSMROneVal32s_16s: function(val:Ipp16s;pDstVal:PIpp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;stdcall;

  ippsFIRLMSMROne32sc_16sc: function(pDstVal:PIpp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;stdcall;
  ippsFIRLMSMROneVal32sc_16sc: function(val:Ipp16sc;pDstVal:PIpp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSMRInitAlloc, ippsFIRLMSMRFree
//   Purpose:     LMS MR initialization functionsstdcall;
//   Parameters:
//      pState        address of pointer to the state returned
//      pTaps         pointer to the taps values. May be null
//      tapsLen       number of the taps
//      pDlyLine      pointer to the delay line. May be null
//      dlyLineIndex  current index value for the delay line
//      dlyStep       sample down factor
//      updateDly     update delay in sampls
//      mu            adaptation step
//   Return:
//      ippStsNullPtrErr       pointer is null
//      ippStsContextMatchErr  wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSMRInitAlloc32s_16s: function(var pState:PIppsFIRLMSMRState32s_16s;pTaps:PIpp32s;tapsLen:longint;pDlyLine:PIpp16s;dlyLineIndex:longint;dlyStep:longint;updateDly:longint;mu:longint):IppStatus;stdcall;
  ippsFIRLMSMRFree32s_16s: function(pState:PIppsFIRLMSMRState32s_16s):IppStatus;stdcall;

  ippsFIRLMSMRInitAlloc32sc_16sc: function(var pState:PIppsFIRLMSMRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;pDlyLine:PIpp16sc;dlyLineIndex:longint;dlyStep:longint;updateDly:longint;mu:longint):IppStatus;stdcall;
  ippsFIRLMSMRFree32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:        ippsFIRLMSMRGetTaps, ippsFIRLMSMRSetTaps,
//                 ippsFIRLMSMRGetTapsPointer
//   Purpose:      get & set taps values
//   Parameters:
//      pState     pointer to the state
//      pOutTaps   pointer to the array to store the taps values
//      pInTaps    pointer to the taps values. May be null
//      pTaps      pointer to the state taps values. For direct access
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsContextMatchErr  wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSMRSetTaps32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;pInTaps:PIpp32s):IppStatus;stdcall;
  ippsFIRLMSMRGetTaps32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;pOutTaps:PIpp32s):IppStatus;stdcall;
  ippsFIRLMSMRGetTapsPointer32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;var pTaps:PIpp32s):IppStatus;stdcall;

  ippsFIRLMSMRSetTaps32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;pInTaps:PIpp32sc):IppStatus;stdcall;
  ippsFIRLMSMRGetTaps32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;pOutTaps:PIpp32sc):IppStatus;stdcall;
  ippsFIRLMSMRGetTapsPointer32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;var pTaps:PIpp32sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSMRGetDlyLine, ippsFIRLMSMRSetDlyLine,
//                ippsFIRLMSMRGetDlyVal
//   Purpose:     set or get delay line, or get one delay line value from
//                specified position
//   Parameters:
//      pState          pointer to the state structure
//      pInDlyLine      pointer to the delay line of the (see state definition)
//                          size = tapsLen * dlyStep + updateDly (may be null)
//      pOutDlyLine     pointer to the delay line of the (see state definition)
//                      size = tapsLen * dlyStep + updateDly
//      pOutDlyLineIndex  pointer to get the current delay line index
//      dlyLineIndex    current index value for the delay line
//      index           to get one value posted into delay line "index" iterations ago
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsContextMatchErr  wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSMRSetDlyLine32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;pInDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;stdcall;
  ippsFIRLMSMRGetDlyLine32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;pOutDlyLine:PIpp16s;pOutDlyIndex:Plongint):IppStatus;stdcall;
  ippsFIRLMSMRGetDlyVal32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;pOutVal:PIpp16s;index:longint):IppStatus;stdcall;
  ippsFIRLMSMRSetDlyLine32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;pInDlyLine:PIpp16sc;dlyLineIndex:longint):IppStatus;stdcall;
  ippsFIRLMSMRGetDlyLine32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;pOutDlyLine:PIpp16sc;pOutDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIRLMSMRGetDlyVal32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;pOutVal:PIpp16sc;index:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSMRPutVal
//   Purpose:     put one value to the delay line
//   Parameters:
//      val       the source signal last value to update delay line
//      pState    pointer to the state structure
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsContextMatchErr  wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSMRPutVal32s_16s: function(val:Ipp16s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;stdcall;
  ippsFIRLMSMRPutVal32sc_16sc: function(val:Ipp16sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSMRSetMu
//   Purpose:     set new adaptation step
//   Parameters:
//      pState    pointer to the state structure
//      mu        new adaptation step
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsContextMatchErr  wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSMRSetMu32s_16s: function(pState:PIppsFIRLMSMRState32s_16s;mu:longint):IppStatus;stdcall;
  ippsFIRLMSMRSetMu32sc_16sc: function(pState:PIppsFIRLMSMRState32sc_16sc;mu:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSMRUpdateTaps
//   Purpose:     recalculation of taps using Least Mean Square alg
//   Parameters:
//      ErrVal    difference between output and reference signal
//      pState    pointer to the state structure
//   Return:
//      ippStsNullPtrErr       pointer to the data is null
//      ippStsContextMatchErr  wrong state identifier
//      ippStsNoErr            otherwise
*)

  ippsFIRLMSMRUpdateTaps32s_16s: function(ErrVal:Ipp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;stdcall;
  ippsFIRLMSMRUpdateTaps32sc_16sc: function(ErrVal:Ipp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//                     FIR filters (direct version)
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//   Names:      ippsFIROne_Direct
//   Purpose:    Directly filters a single sample through a FIR filter.
//   Parameters:
//      src            input sample
//      pDstVal        pointer to the output sample
//      pSrcDstVal     pointer to the input and output sample for in-place operation.
//      pTaps          pointer to the array containing the taps values,
//                       the number of elements in the array is tapsLen
//      tapsLen        number of elements in the array containing the taps values.
//      tapsFactor     scale factor for the taps of Ipp32s data type
//                               (for integer versions only).
//      pDlyLine       pointer to the array containing the delay line values,
//                        the number of elements in the array is 2*tapsLen
//      pDlyLineIndex  pointer to the current delay line index
//      scaleFactor    integer scaling factor value
//   Return:
//      ippStsNullPtrErr       pointer(s) to data arrays is(are) NULL
//      ippStsFIRLenErr        tapsLen is less than or equal to 0
//      ippStsNoErr            otherwise
*)

  ippsFIROne_Direct_32f: function(src:Ipp32f;pDstVal:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIROne_Direct_32fc: function(src:Ipp32fc;pDstVal:PIpp32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIROne_Direct_32f_I: function(pSrcDstVal:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIROne_Direct_32fc_I: function(pSrcDstVal:PIpp32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIROne32f_Direct_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne32fc_Direct_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne32f_Direct_16s_ISfs: function(pSrcDstVal:PIpp16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne32fc_Direct_16sc_ISfs: function(pSrcDstVal:PIpp16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne_Direct_64f: function(src:Ipp64f;pDstVal:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIROne_Direct_64fc: function(src:Ipp64fc;pDstVal:PIpp64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIROne_Direct_64f_I: function(pSrcDstVal:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIROne_Direct_64fc_I: function(pSrcDstVal:PIpp64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIROne64f_Direct_32f: function(src:Ipp32f;pDstVal:PIpp32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIROne64fc_Direct_32fc: function(src:Ipp32fc;pDstVal:PIpp32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIROne64f_Direct_32f_I: function(pSrcDstVal:PIpp32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIROne64fc_Direct_32fc_I: function(pSrcDstVal:PIpp32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIROne64f_Direct_32s_Sfs: function(src:Ipp32s;pDstVal:PIpp32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne64fc_Direct_32sc_Sfs: function(src:Ipp32sc;pDstVal:PIpp32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne64f_Direct_32s_ISfs: function(pSrcDstVal:PIpp32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne64fc_Direct_32sc_ISfs: function(pSrcDstVal:PIpp32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne64f_Direct_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne64fc_Direct_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne64f_Direct_16s_ISfs: function(pSrcDstVal:PIpp16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne64fc_Direct_16sc_ISfs: function(pSrcDstVal:PIpp16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne32s_Direct_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne32sc_Direct_16sc_Sfs: function(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne32s_Direct_16s_ISfs: function(pSrcDstVal:PIpp16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIROne32sc_Direct_16sc_ISfs: function(pSrcDstVal:PIpp16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////////////////////
//   Names:      ippsFIR_Direct
//   Purpose:    Directly filters a block of samples through a single-rate FIR filter.
//   Parameters:
//      pSrc           pointer to the input array
//      pDst           pointer to the output array
//      pSrcDst        pointer to the input and output array for in-place operation.
//      numIters       number of samples in the input array
//      pTaps          pointer to the array containing the taps values,
//                       the number of elements in the array is tapsLen
//      tapsLen        number of elements in the array containing the taps values.
//      tapsFactor     scale factor for the taps of Ipp32s data type
//                               (for integer versions only).
//      pDlyLine       pointer to the array containing the delay line values,
//                        the number of elements in the array is 2*tapsLen
//      pDlyLineIndex  pointer to the current delay line index
//      scaleFactor    integer scaling factor value
//   Return:
//      ippStsNullPtrErr       pointer(s) to data arrays is(are) NULL
//      ippStsFIRLenErr        tapsLen is less than or equal to 0
//      ippStsSizeErr          numIters is less than or equal to 0
//      ippStsNoErr            otherwise
*)

  ippsFIR_Direct_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIR_Direct_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIR_Direct_32f_I: function(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIR_Direct_32fc_I: function(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIR32f_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32fc_Direct_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR32f_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32fc_Direct_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR_Direct_64f: function(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIR_Direct_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIR_Direct_64f_I: function(pSrcDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIR_Direct_64fc_I: function(pSrcDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIR64f_Direct_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIR64fc_Direct_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIR64f_Direct_32f_I: function(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIR64fc_Direct_32fc_I: function(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIR64f_Direct_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_Direct_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR64f_Direct_32s_ISfs: function(pSrcDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_Direct_32sc_ISfs: function(pSrcDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR64f_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_Direct_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR64f_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR64fc_Direct_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR32s_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32sc_Direct_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR32s_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;
  ippsFIR32sc_Direct_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////////////////////
//   Names:      ippsFIRMR_Direct
//   Purpose:    Directly filters a block of samples through a multi-rate FIR filter.
//   Parameters:
//      pSrc           pointer to the input array
//      pDst           pointer to the output array
//      pSrcDst        pointer to the input and output array for in-place operation.
//      numIters       number of iterations in the input array
//      pTaps          pointer to the array containing the taps values,
//                       the number of elements in the array is tapsLen
//      tapsLen        number of elements in the array containing the taps values.
//      tapsFactor     scale factor for the taps of Ipp32s data type
//                               (for integer versions only).
//      pDlyLine       pointer to the array containing the delay line values
//      upFactor       up-sampling factor
//      downFactor     down-sampling factor
//      upPhase        up-sampling phase
//      downPhase      down-sampling phase
//      scaleFactor    integer scaling factor value
//   Return:
//      ippStsNullPtrErr       pointer(s) to data arrays is(are) NULL
//      ippStsFIRLenErr        tapsLen is less than or equal to 0
//      ippStsSizeErr          numIters is less than or equal to 0
//      ippStsFIRMRFactorErr   upFactor (downFactor) is less than or equal to 0
//      ippStsFIRMRPhaseErr    upPhase (downPhase) is negative,
//                                       or less than or equal to upFactor (downFactor).
//      ippStsNoErr            otherwise
*)


  ippsFIRMR_Direct_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRMR_Direct_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRMR_Direct_32f_I: function(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRMR_Direct_32fc_I: function(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRMR32f_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR32fc_Direct_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR32f_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR32fc_Direct_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR_Direct_64f: function(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsFIRMR_Direct_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsFIRMR_Direct_64f_I: function(pSrcDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsFIRMR_Direct_64fc_I: function(pSrcDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsFIRMR64f_Direct_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRMR64fc_Direct_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRMR64f_Direct_32f_I: function(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRMR64fc_Direct_32fc_I: function(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;stdcall;

  ippsFIRMR64f_Direct_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR64fc_Direct_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR64f_Direct_32s_ISfs: function(pSrcDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR64fc_Direct_32sc_ISfs: function(pSrcDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR64f_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR64fc_Direct_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR64f_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR64fc_Direct_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR32s_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR32sc_Direct_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;

  ippsFIRMR32s_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsFIRMR32sc_Direct_16sc_ISfs: function(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFIR_Direct_16s_Sfs,
//              ippsFIR_Direct_16s_ISfs,
//              ippsFIROne_Direct_16s_Sfs,
//              ippsFIROne_Direct_16s_ISfs.
//  Purpose:    Directly filters a block of samples (or one sample in 'One'
//              case) through a single-rate FIR filter with fixed point taps
//              ( Q15 ).
//   Parameters:
//      pSrc            pointer to the input array.
//      src             input sample in 'One' case.
//      pDst            pointer to the output array.
//      pDstVal         pointer to the output sample in 'One' case.
//      pSrcDst         pointer to the input and output array for in-place
//                      operation.
//      pSrcDstVal      pointer to the input and output sample for in-place
//                      operation in 'One' case.
//      numIters        number of samples in the input array.
//      pTapsQ15        pointer to the array containing the taps values,
//                      the number of elements in the array is tapsLen.
//      tapsLen         number of elements in the array containing the taps
//                      values.
//      pDlyLine        pointer to the array containing the delay line values,
//                      the number of elements in the array is 2 * tapsLen.
//      pDlyLineIndex   pointer to the current delay line index.
//      scaleFactor     integer scaling factor value.
//   Return:
//      ippStsNullPtrErr       pointer(s) to data arrays is(are) NULL.
//      ippStsFIRLenErr        tapsLen is less than or equal to 0.
//      ippStsSizeErr          sampLen is less than or equal to 0.
//      ippStsDlyLineIndexErr  current delay line index is greater or equal
//                             tapsLen, or less than 0.
//      ippStsNoErr            otherwise.
*)

  ippsFIR_Direct_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIR_Direct_16s_ISfs: function(pSrcDst:PIpp16s;numIters:longint;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne_Direct_16s_Sfs: function(src:Ipp16s;pDstVal:PIpp16s;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

  ippsFIROne_Direct_16s_ISfs: function(pSrcDstVal:PIpp16s;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFIRGenLowpass_64f, ippsFIRGenHighpass_64f, ippsFIRGenBandpass_64f
//              ippsFIRGenBandstop_64f

//  Purpose:    This function computes the lowpass FIR filter coefficientsstdcall;
//              by windowing of ideal (infinite) filter coefficients segment
//
//  Parameters:
//      rfreq             cut off frequency (0 < rfreq < 0.5)
//
//      taps              pointer to the array which specifies
//                        the filter coefficients;
//
//      tapsLen           the number of taps in taps[] array (tapsLen>=5);
//
//      winType           the ippWindowType switch variable,
//                        which specifies the smoothing window type;
//
//      doNormal          if doNormal=0 the functions calculatesstdcall;
//                        non-normalized sequence of filter coefficients,
//                        in other cases the sequence of coefficients
//                        will be normalized.
//  Return:
//   ippStsNullPtrErr     the null pointer to taps[] array pass to functionstdcall;
//   ippStsSizeErr        the length of coefficient's array is less then five
//   ippStsSizeErr        the low or high frequency isn’t satisfy
//                                    the condition 0 < rLowFreq < 0.5
//   ippStsNoErr          otherwise
//
*)

  ippsFIRGenLowpass_64f: function(rfreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;stdcall;


  ippsFIRGenHighpass_64f: function(rfreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;stdcall;


  ippsFIRGenBandpass_64f: function(rLowFreq:Ipp64f;rHighFreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;stdcall;


  ippsFIRGenBandstop_64f: function(rLowFreq:Ipp64f;rHighFreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Windowing functionsstdcall;
//  Note: to create the window coefficients you have to make two calls
//        Set(1,x,n) and Win(x,n)
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinBartlett
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 3
//   ippStsNoErr         otherwise
*)

  ippsWinBartlett_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBartlett_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBartlett_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinHann
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 3
//   ippStsNoErr         otherwise
//  Functionality:    0.5*(1-cos(2*pi*n/(N-1)))stdcall;
*)

  ippsWinHann_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHann_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHann_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHann_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinHann_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHann_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHann_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHann_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;

  ippsWinHann_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHann_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsWinHann_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHann_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinHamming
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 3
//   ippStsNoErr         otherwise
*)

  ippsWinHamming_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHamming_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHamming_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHamming_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;

  ippsWinHamming_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHamming_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHamming_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHamming_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;

  ippsWinHamming_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHamming_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinHamming_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHamming_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinBlackman
//  Purpose:          multiply vector by Blackman windowing functionstdcall;
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//   alpha            adjustable parameter associated with the
//                    Blackman windowing equation
//   alphaQ15         scaled (scale factor 15) version of the alpha
//   scaleFactor      scale factor of the output signal
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 3, for Opt it's 4
//   ippStsNoErr         otherwise
//  Notes:
//     parameter alpha value
//         WinBlackmaStd   : -0.16
//         WinBlackmaOpt   : -0.5 / (1+cos(2*pi/(len-1)))
*)

  ippsWinBlackmanQ15_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;alphaQ15:longint;scaleFactor:longint):IppStatus;stdcall;

  ippsWinBlackmanQ15_16s_I: function(pSrcDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinBlackmanQ15_16sc_I: function(pSrcDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinBlackman_16s_I: function(pSrcDst:PIpp16s;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinBlackman_16sc_I: function(pSrcDst:PIpp16sc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinBlackman_32f_I: function(pSrcDst:PIpp32f;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinBlackman_32fc_I: function(pSrcDst:PIpp32fc;len:longint;alpha:single):IppStatus;stdcall;

  ippsWinBlackmanQ15_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinBlackmanQ15_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinBlackman_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinBlackman_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinBlackman_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinBlackman_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:single):IppStatus;stdcall;

  ippsWinBlackmanStd_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;

  ippsWinBlackmanStd_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;

  ippsWinBlackman_64f_I: function(pSrcDst:PIpp64f;len:longint;alpha:double):IppStatus;stdcall;
  ippsWinBlackman_64fc_I: function(pSrcDst:PIpp64fc;len:longint;alpha:double):IppStatus;stdcall;

  ippsWinBlackman_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:double):IppStatus;stdcall;
  ippsWinBlackman_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:double):IppStatus;stdcall;

  ippsWinBlackmanStd_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsWinBlackmanOpt_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinKaiser
//  Purpose:          multiply vector by Kaiser windowing functionstdcall;
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//   alpha            adjustable parameter associated with the
//                    Kaiser windowing equation
//   alphaQ15         scaled (scale factor 15) version of the alpha
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 1
//   ippStsHugeWinErr    window in function is hugestdcall;
//   ippStsNoErr         otherwise
*)

  ippsWinKaiser_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_16s_I: function(pSrcDst:PIpp16s;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiserQ15_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinKaiserQ15_16s_I: function(pSrcDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinKaiser_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_16sc_I: function(pSrcDst:PIpp16sc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiserQ15_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinKaiserQ15_16sc_I: function(pSrcDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;stdcall;
  ippsWinKaiser_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_32f_I: function(pSrcDst:PIpp32f;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_32fc_I: function(pSrcDst:PIpp32fc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_64f_I: function(pSrcDst:PIpp64f;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_64fc_I: function(pSrcDst:PIpp64fc;len:longint;alpha:single):IppStatus;stdcall;
  ippsWinKaiser_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:single):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Median filter
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFilterMedian
//  Purpose:    filter source data by the Median Filter
//  Parameters:
//   pSrcDst             pointer to the source vector
//   pSrc                pointer to the source vector
//   pDst                pointer to the destination vector
//   len                 length of the vector(s)
//   maskSize            median mask size (odd)
//  Return:
//   ippStsNullPtrErr              pointer(s) to the data is NULL
//   ippStsSizeErr                 length of the vector(s) is less or equal zero
//   ippStsEvenMedianMaskSize      median mask size is even warning
//   ippStsNoErr                   otherwise
//  Notes:
//      - if len is even then len=len-1
//      - value of not existed point equals to the last point value,
//        for example, x[-1]=x[0] or x[len]=x[len-1]
*)
  ippsFilterMedian_32f_I: function(pSrcDst:PIpp32f;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_64f_I: function(pSrcDst:PIpp64f;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_16s_I: function(pSrcDst:PIpp16s;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_8u_I: function(pSrcDst:PIpp8u;len:longint;maskSize:longint):IppStatus;stdcall;

  ippsFilterMedian_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint;maskSize:longint):IppStatus;stdcall;

  ippsFilterMedian_32s_I: function(pSrcDst:PIpp32s;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsFilterMedian_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;maskSize:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Statistic functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:            ippsNorm
//  Purpose:         calculate norm of vector
//     Inf - calculate C-norm of vector: n = MAX |src1|
//     L1  - calculate L1-norm of vector: n = SUM |src1|
//     L2  - calculate L2-norm of vector: n = SQRT(SUM |src1|^2)
//  Context:
//  Returns:         IppStatus
//    ippStsNoErr       Ok
//    ippStsNullPtrErr  Some of pointers to input or output data are NULL
//    ippStsSizeErr     The length of vector is less or equal zero
//  Parameters:
//    pSrc           The sourses data pointer.
//    len            The length of vector
//    pNorm          The pointer to result
//  Notes:
*)
  ippsNorm_Inf_16s32f: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_Inf_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_Inf_32f: function(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_Inf_64f: function(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNorm_L1_16s32f: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L1_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_L1_32f: function(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L1_64f: function(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNorm_L2_16s32f: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L2_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_L2_32f: function(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L2_64f: function(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:            ippsNormDiff
//  Purpose:         calculate norm of vectors
//     Inf - calculate C-norm of vectors: n = MAX |src1-src2|
//     L1  - calculate L1-norm of vectors: n = SUM |src1-src2|
//     L2  - calculate L2-norm of vectors: n = SQRT(SUM |src1-src2|^2)
//  Context:
//  Returns:         IppStatus
//    ippStsNoErr       Ok
//    ippStsNullPtrErr  Some of pointers to input or output data are NULL
//    ippStsSizeErr     The length of vector is less or equal zero
//  Parameters:
//    pSrc1, pSrc2   The sourses data pointer.
//    len            The length of vector
//    pNorm          The pointer to result
//  Notes:
*)
  ippsNormDiff_Inf_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_Inf_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_Inf_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_Inf_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L1_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L1_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_L1_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L1_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L2_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L2_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_L2_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L2_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_Inf_32fc32f: function(pSrc:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L1_32fc64f: function(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L2_32fc64f: function(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNormDiff_Inf_32fc32f: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L1_32fc64f: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L2_32fc64f: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_Inf_64fc64f: function(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L1_64fc64f: function(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L2_64fc64f: function(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_Inf_64fc64f: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L1_64fc64f: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L2_64fc64f: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
(* /////////////////////////////////////////////////////////////////////////////
//                Cross Correlation Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCrossCorr_32f,  ippsCrossCorr_64f,
//              ippsCrossCorr_32fc, ippsCrossCorr_64fc
//
//  Purpose:    Calculate Cross Correlation
//
//  Arguments:
//     pSrc1  - pointer to the vector_1 source
//     len1   - vector_1 source length
//     pSrc2  - pointer to the vector_2 source
//     len    - vector_2 source length
//     pDst   - pointer to the cross correlation
//     dstLen  - length of cross-correlation
//     lowLag  - cross-correlation lowest lag
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  either pSrc1 or(and) pSrc2 are NULL
//   ippStsSizeErr     vector's length is not positive
//                  roi problem
*)
  ippsCrossCorr_32f: function(pSrc1:PIpp32f;len1:longint;pSrc2:PIpp32f;len2:longint;pDst:PIpp32f;dstLen:longint;lowLag:longint):IppStatus;stdcall;
  ippsCrossCorr_64f: function(pSrc1:PIpp64f;len1:longint;pSrc2:PIpp64f;len2:longint;pDst:PIpp64f;dstLen:longint;lowLag:longint):IppStatus;stdcall;
  ippsCrossCorr_32fc: function(pSrc1:PIpp32fc;len1:longint;pSrc2:PIpp32fc;len2:longint;pDst:PIpp32fc;dstLen:longint;lowLag:longint):IppStatus;stdcall;
  ippsCrossCorr_64fc: function(pSrc1:PIpp64fc;len1:longint;pSrc2:PIpp64fc;len2:longint;pDst:PIpp64fc;dstLen:longint;lowLag:longint):IppStatus;stdcall;
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCrossCorr_16s_Sfs
//
//  Purpose:    Calculate Cross Correlation and Scale Result (with saturate)
//
//  Arguments:
//     pSrc1   - pointer to the vector_1 source
//     len1    - vector_1 source length
//     pSrc2   - pointer to the vector_2 source
//     len     - vector_2 source length
//     pDst    - pointer to the cross correlation
//     dstLen -
//     lowLag -
//     scaleFactor - scale factor value
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  either pSrc1 or(and) pSrc2 are NULL
//   ippStsSizeErr     vector's length is not positive
//                  roi problem
*)
  ippsCrossCorr_16s_Sfs: function(pSrc1:PIpp16s;len1:longint;pSrc2:PIpp16s;len2:longint;pDst:PIpp16s;dstLen:longint;lowLag:longint;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                AutoCorrelation Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippsAutoCorr_32f,  ippsAutoCorr_NormA_32f,  ippsAutoCorr_NormB_32f,
//          ippsAutoCorr_64f,  ippsAutoCorr_NormA_64f,  ippsAutoCorr_NormB_64f,
//          ippsAutoCorr_32fc, ippsAutoCorr_NormA_32fc, ippsAutoCorr_NormB_32fc,
//          ippsAutoCorr_64fc, ippsAutoCorr_NormA_64fc, ippsAutoCorr_NormB_64fc,
//
//  Purpose:    Calculate the autocorrelation,
//              without suffix NormX specifies that the normal autocorrelation to be
//              computed;
//              suffix NormA specifies that the biased autocorrelation to be
//              computed (the resulting values are to be divided on srcLen);
//              suffix NormB specifies that the unbiased autocorrelation to be
//              computed (the resulting values are to be divided on ( srcLen - n ),
//              where "n" means current iteration).
//
//  Arguments:
//     pSrc   - pointer to the source vector
//     srcLen - source vector length
//     pDst   - pointer to the auto-correlation result vector
//     dstLen - length of auto-correlation
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  either pSrc or(and) pDst are NULL
//   ippStsSizeErr     vector's length is not positive
*)

  ippsAutoCorr_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormA_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormB_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormA_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormB_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormA_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormB_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormA_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;stdcall;
  ippsAutoCorr_NormB_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippsAutoCorr_16s_Sfs,
//          ippsAutoCorr_NormA_16s_Sfs,
//          ippsAutoCorr_NormB_16s_Sfs
//
//  Purpose:    Calculate the autocorrelation,
//              without suffix NormX specifies that the normal autocorrelation to be
//              computed;
//              suffix NormA specifies that the biased autocorrelation to be
//              computed (the resulting values are to be divided on srcLen);
//              suffix NormB specifies that the unbiased autocorrelation to be
//              computed (the resulting values are to be divided on ( srcLen - n ),
//              where n means current iteration).
//
//  Arguments:
//     pSrc   - pointer to the source vector
//     srcLen - source vector length
//     pDst   - pointer to the auto-correlation result vector
//     dstLen - length of auto-correlation
//     scaleFactor - scale factor value
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  either pSrc or(and) pDst are NULL
//   ippStsSizeErr     vector's length is not positive
*)

  ippsAutoCorr_16s_Sfs: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAutoCorr_NormA_16s_Sfs: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAutoCorr_NormB_16s_Sfs: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                  Sampling functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSampleUp
//  Purpose:    upsampling, i.e. expansion of input vector to get output vector
//              by simple adding zeroes between input elements
//  Parameters:
//   pSrc   (in)   pointer to the input vector
//   pDst   (in)   pointer to the output vector
//   srcLen (in)   length of input vector
//   dstLen (out)  pointer to the length of output vector
//   factor (in)   the number of output elements, corresponding to one element
//                 of input vector.
//   phase(in-out) pointer to value, that is the position (0, ..., factor-1) of
//                 element from input vector in the group of factor elements of
//                 output vector. Out value is ready to continue upsampling with
//                 the same factor (out = in).
//
//  Return:
//   ippStsNullPtrErr        one or several pointers pSrc, pDst, dstLen or phase
//                         is NULL
//   ippStsSizeErr           length of input vector is less or equal zero
//   ippStsSampleFactorErr   factor <= 0
//   ippStsSamplePhaseErr    *phase < 0 or *phase >= factor
//   ippStsNoErr             otherwise
*)
  ippsSampleUp_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleUp_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleUp_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleUp_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleUp_16s: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleUp_16sc: function(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSampleDown
//  Purpose:    subsampling, i.e. only one of "factor" elements of input vector
//              are placed to output vector
//  Parameters:
//   pSrc   (in)   pointer to the input vector
//   pDst   (in)   pointer to the output vector
//   srcLen (in)   length of input vector
//   dstLen (out)  pointer to the length of output vector
//   factor (in)   the number of input elements, corresponding to one element
//                 of output vector.
//   phase(in-out) pointer to value, that is the position (0, ..., factor-1) of
//                 choosen element in the group of "factor" elements. Out value
//                 of *phase is ready to continue subsampling with the same
//                 factor.
//
//  Return:
//   ippStsNullPtrErr        one or several pointers pSrc, pDst, dstLen or phase
//                        is NULL
//   ippStsSizeErr           length of input vector is less or equal zero
//   ippStsSampleFactorErr   factor <= 0
//   ippStsSamplePhaseErr    *phase < 0 or *phase >=factor
//   ippStsNoErr             otherwise
*)
  ippsSampleDown_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleDown_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleDown_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleDown_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleDown_16s: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;
  ippsSampleDown_16sc: function(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;stdcall;



(* ///////////////////////////////////////////////////////////////////////////
//  Names:      ippsGetVarPointDV_16sc
//  Purpose:    Fills the array VariantPoint with information about 8
//              (if State = 32,64) or 4 (if State = 16) closest to the
//              refPoint complex points (stores the indexes in the
//              offset table and errors between refPoint and the
//              current point)
//  Return:
//  ippStsNoErr         Ok
//  ippStsNullPtrErr    Any of the specified pointers is NULL
//  Parameters:
//  pSrc            pointer to the reference point in format 9:7
//  pDst            pointer to the closest to the reference point left
//                  and bottom comlexpoint in format 9:7
//  pVariantPoint   pointer to the array where the information is stored
//  pLabel          pointer to the labels table
//  state           number of states of the convolution coder
*)
  ippsGetVarPointDV_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;pVariantPoint:PIpp16sc;pLabel:PIpp8u;state:longint):IppStatus;stdcall;


(* ///////////////////////////////////////////////////////////////////////////
//  Names:      ippsCalcStatesDV_16sc
//  Purpose:    Computes possible states of the Viterbi decoder
//  Return:
//  ippStsNoErr         OK
//  ippStsNullPtrErr    Any of the specified pointers is NULL
//  Parameters:
//  pPathError          pointer to the table of path error metrics
//  pNextState          pointer to the next state table
//  pBranchError        pointer to the branch error table
//  pCurrentSubsetPoint pointer to the current 4D subset
//  pPathTable          pointer to the Viterbi path table
//  state               number of states of the convolution coder
//  presentIndex        start index in Viterbi Path table
*)
  ippsCalcStatesDV_16sc: function(pathError:PIpp16u;pNextState:PIpp8u;pBranchError:PIpp16u;pCurrentSubsetPoint:PIpp16s;pPathTable:PIpp16s;state:longint;presentIndex:longint):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////
//  Names:      ippsBuildSymblTableDV4D_16s
//  Purpose:    Fills the array with an information of possible 4D symbols
//  Return:
//  ippStsNoErr         OK
//  ippStsNullPtrErr    Any of the specified pointers is NULL
//  Parameters:
//  pVariantPoint       pointer to the array of possible 2D symbols
//  pCurrentSubsetPoint pointer to the current array of 4D symbols
//  state               number of states of the convolution coder
//  bitInversion        bit Inversion
*)
  ippsBuildSymblTableDV4D_16sc: function(pVariantPoint:PIpp16sc;pCurrentSubsetPoint:PIpp16sc;state:longint;bitInversion:longint):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////
//  Names:      ippsUpdatePathMetricsDV_16u
//  Purpose:    Searches for the minimum path metric and updates states of the decoder
//  Return:
//  ippStsNoErr         OK
//  ippStsNullPtrErr    Any of the specified pointers is NULL
//  Parameters:
//  pBranchError        pointer to the branch error table
//  pMinPathError       pointer to the current minimum path error metric
//  pMinSost            pointer to the state with minimum path metric
//  pPathError          pointer to table of path error metrics
//  state               number of states of the convolution coder
*)
  ippsUpdatePathMetricsDV_16u: function(pBranchError:PIpp16u;pMinPathError:PIpp16u;pMinSost:PIpp8u;pPathError:PIpp16u;state:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for Hilbert Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)

type

IppsHilbertSpec_32f32fc = pointer;
PIppsHilbertSpec_32f32fc =^IppsHilbertSpec_32f32fc;

IppsHilbertSpec_16s32fc = pointer;
PIppsHilbertSpec_16s32fc =^IppsHilbertSpec_16s32fc;

IppsHilbertSpec_16s16sc = pointer;
PIppsHilbertSpec_16s16sc =^IppsHilbertSpec_16s16sc;


var
(* /////////////////////////////////////////////////////////////////////////////
//                  Hilbert Context Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsHilbertInitAlloc_32f32fc, ippsHilbertFree_32f32fc,
//              ippsHilbertInitAlloc_16s32fc, ippsHilbertFree_16s32fc,
//              ippsHilbertInitAlloc_16s16sc, ippsHilbertFree_16s16sc
//  Purpose:    create, initialize and delete Hilbert context
//  Arguments:
//     pSpec    - where write pointer to new context
//     length   - number of samples in Hilbert
//     hint     - code specific use hints (DFT)
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pSpec == NULL
//     ippStsSizeErr          bad the length value
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsHilbertInitAlloc_32f32fc: function(var pSpec:PIppsHilbertSpec_32f32fc;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsHilbertInitAlloc_16s32fc: function(var pSpec:PIppsHilbertSpec_16s32fc;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsHilbertInitAlloc_16s16sc: function(var pSpec:PIppsHilbertSpec_16s16sc;length:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsHilbertFree_32f32fc: function(pSpec:PIppsHilbertSpec_32f32fc):IppStatus;stdcall;
  ippsHilbertFree_16s32fc: function(pSpec:PIppsHilbertSpec_16s32fc):IppStatus;stdcall;
  ippsHilbertFree_16s16sc: function(pSpec:PIppsHilbertSpec_16s16sc):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Hilbert Transform Functionsstdcall;
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsHilbert_32f32fc,
//              ippsHilbert_16s32fc,
//              ippsHilbert_16s16sc_Sfs
//  Purpose:    compute Hilbert transform of the real signal
//  Arguments:
//     pSrc     - pointer to source real signal
//     pDst     - pointer to destination complex signal
//     pSpec    - pointer to Hilbert context
//     scaleFactor - scale factor for output signal
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pointer(s) to the data is NULL
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippsHilbert_32f32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;pSpec:PIppsHilbertSpec_32f32fc):IppStatus;stdcall;
  ippsHilbert_16s32fc: function(pSrc:PIpp16s;pDst:PIpp32fc;pSpec:PIppsHilbertSpec_16s32fc):IppStatus;stdcall;
  ippsHilbert_16s16sc_Sfs: function(pSrc:PIpp16s;pDst:PIpp16sc;pSpec:PIppsHilbertSpec_16s16sc;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////// End of file "ipps.h" ////////////////////////// *)


IMPLEMENTATION



uses windows,math,util1,ncdef2;

var
  hh:intG;

  //ff: TfileStream;

function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,PAnsichar(st));
  //if result=nil then messageCentral(st+'=nil');
  {
  begin
    st:= st+#10;
    ff.write(st[1], length(st));
  end;
  }
end;


{  Pour XE, il est nécessaire de décomposer InitIpps en trois parties sinon:
   error: too many local constants.
}
procedure InitIpps1;
begin
  ippGetStatusString:=getProc(hh,'ippGetStatusString');
  ippGetCpuType:=getProc(hh,'ippGetCpuType');
  ippGetCpuClocks:=getProc(hh,'ippGetCpuClocks');
  ippSetFlushToZero:=getProc(hh,'ippSetFlushToZero');
  ippSetDenormAreZeros:=getProc(hh,'ippSetDenormAreZeros');
  ippsGetLibVersion:=getProc(hh,'ippsGetLibVersion');
  ippsMalloc_8u:=getProc(hh,'ippsMalloc_8u');
  ippsMalloc_16u:=getProc(hh,'ippsMalloc_16u');
  ippsMalloc_32u:=getProc(hh,'ippsMalloc_32u');
  ippsMalloc_8s:=getProc(hh,'ippsMalloc_8s');
  ippsMalloc_16s:=getProc(hh,'ippsMalloc_16s');
  ippsMalloc_32s:=getProc(hh,'ippsMalloc_32s');
  ippsMalloc_64s:=getProc(hh,'ippsMalloc_64s');
  ippsMalloc_32f:=getProc(hh,'ippsMalloc_32f');
  ippsMalloc_64f:=getProc(hh,'ippsMalloc_64f');
  ippsMalloc_8sc:=getProc(hh,'ippsMalloc_8sc');
  ippsMalloc_16sc:=getProc(hh,'ippsMalloc_16sc');
  ippsMalloc_32sc:=getProc(hh,'ippsMalloc_32sc');
  ippsMalloc_64sc:=getProc(hh,'ippsMalloc_64sc');
  ippsMalloc_32fc:=getProc(hh,'ippsMalloc_32fc');
  ippsMalloc_64fc:=getProc(hh,'ippsMalloc_64fc');
  ippsFree:=getProc(hh,'ippsFree');
  ippsCopy_8u:=getProc(hh,'ippsCopy_8u');
  ippsCopy_16s:=getProc(hh,'ippsCopy_16s');
  ippsCopy_16sc:=getProc(hh,'ippsCopy_16sc');
  ippsCopy_32f:=getProc(hh,'ippsCopy_32f');
  ippsCopy_32fc:=getProc(hh,'ippsCopy_32fc');
  ippsCopy_64f:=getProc(hh,'ippsCopy_64f');
  ippsCopy_64fc:=getProc(hh,'ippsCopy_64fc');
  ippsMove_8u:=getProc(hh,'ippsMove_8u');
  ippsMove_16s:=getProc(hh,'ippsMove_16s');
  ippsMove_16sc:=getProc(hh,'ippsMove_16sc');
  ippsMove_32f:=getProc(hh,'ippsMove_32f');
  ippsMove_32fc:=getProc(hh,'ippsMove_32fc');
  ippsMove_64f:=getProc(hh,'ippsMove_64f');
  ippsMove_64fc:=getProc(hh,'ippsMove_64fc');
  ippsZero_8u:=getProc(hh,'ippsZero_8u');
  ippsZero_16s:=getProc(hh,'ippsZero_16s');
  ippsZero_16sc:=getProc(hh,'ippsZero_16sc');
  ippsZero_32f:=getProc(hh,'ippsZero_32f');
  ippsZero_32fc:=getProc(hh,'ippsZero_32fc');
  ippsZero_64f:=getProc(hh,'ippsZero_64f');
  ippsZero_64fc:=getProc(hh,'ippsZero_64fc');
  ippsSet_8u:=getProc(hh,'ippsSet_8u');
  ippsSet_16s:=getProc(hh,'ippsSet_16s');
  ippsSet_16sc:=getProc(hh,'ippsSet_16sc');
  ippsSet_32s:=getProc(hh,'ippsSet_32s');
  ippsSet_32sc:=getProc(hh,'ippsSet_32sc');
  ippsSet_32f:=getProc(hh,'ippsSet_32f');
  ippsSet_32fc:=getProc(hh,'ippsSet_32fc');
  ippsSet_64s:=getProc(hh,'ippsSet_64s');
  ippsSet_64sc:=getProc(hh,'ippsSet_64sc');
  ippsSet_64f:=getProc(hh,'ippsSet_64f');
  ippsSet_64fc:=getProc(hh,'ippsSet_64fc');
  ippsRandUniform_Direct_16s:=getProc(hh,'ippsRandUniform_Direct_16s');
  ippsRandUniform_Direct_32f:=getProc(hh,'ippsRandUniform_Direct_32f');
  ippsRandUniform_Direct_64f:=getProc(hh,'ippsRandUniform_Direct_64f');
  ippsRandGauss_Direct_16s:=getProc(hh,'ippsRandGauss_Direct_16s');
  ippsRandGauss_Direct_32f:=getProc(hh,'ippsRandGauss_Direct_32f');
  ippsRandGauss_Direct_64f:=getProc(hh,'ippsRandGauss_Direct_64f');
  ippsRandUniformInitAlloc_8u:=getProc(hh,'ippsRandUniformInitAlloc_8u');
  ippsRandUniformInitAlloc_16s:=getProc(hh,'ippsRandUniformInitAlloc_16s');
  ippsRandUniformInitAlloc_32f:=getProc(hh,'ippsRandUniformInitAlloc_32f');
  ippsRandUniform_8u:=getProc(hh,'ippsRandUniform_8u');
  ippsRandUniform_16s:=getProc(hh,'ippsRandUniform_16s');
  ippsRandUniform_32f:=getProc(hh,'ippsRandUniform_32f');
  ippsRandUniformFree_8u:=getProc(hh,'ippsRandUniformFree_8u');
  ippsRandUniformFree_16s:=getProc(hh,'ippsRandUniformFree_16s');
  ippsRandUniformFree_32f:=getProc(hh,'ippsRandUniformFree_32f');
  ippsRandGaussInitAlloc_8u:=getProc(hh,'ippsRandGaussInitAlloc_8u');
  ippsRandGaussInitAlloc_16s:=getProc(hh,'ippsRandGaussInitAlloc_16s');
  ippsRandGaussInitAlloc_32f:=getProc(hh,'ippsRandGaussInitAlloc_32f');
  ippsRandGauss_8u:=getProc(hh,'ippsRandGauss_8u');
  ippsRandGauss_16s:=getProc(hh,'ippsRandGauss_16s');
  ippsRandGauss_32f:=getProc(hh,'ippsRandGauss_32f');
  ippsRandGaussFree_8u:=getProc(hh,'ippsRandGaussFree_8u');
  ippsRandGaussFree_16s:=getProc(hh,'ippsRandGaussFree_16s');
  ippsRandGaussFree_32f:=getProc(hh,'ippsRandGaussFree_32f');
  ippsRandGaussGetSize_16s:=getProc(hh,'ippsRandGaussGetSize_16s');
  ippsRandGaussInit_16s:=getProc(hh,'ippsRandGaussInit_16s');
  ippsRandUniformGetSize_16s:=getProc(hh,'ippsRandUniformGetSize_16s');
  ippsRandUniformInit_16s:=getProc(hh,'ippsRandUniformInit_16s');
  ippsVectorJaehne_8u:=getProc(hh,'ippsVectorJaehne_8u');
  ippsVectorJaehne_8s:=getProc(hh,'ippsVectorJaehne_8s');
  ippsVectorJaehne_16u:=getProc(hh,'ippsVectorJaehne_16u');
  ippsVectorJaehne_16s:=getProc(hh,'ippsVectorJaehne_16s');
  ippsVectorJaehne_32u:=getProc(hh,'ippsVectorJaehne_32u');
  ippsVectorJaehne_32s:=getProc(hh,'ippsVectorJaehne_32s');
  ippsVectorJaehne_32f:=getProc(hh,'ippsVectorJaehne_32f');
  ippsVectorJaehne_64f:=getProc(hh,'ippsVectorJaehne_64f');
  ippsTone_Direct_32f:=getProc(hh,'ippsTone_Direct_32f');
  ippsTone_Direct_32fc:=getProc(hh,'ippsTone_Direct_32fc');
  ippsTone_Direct_64f:=getProc(hh,'ippsTone_Direct_64f');
  ippsTone_Direct_64fc:=getProc(hh,'ippsTone_Direct_64fc');
  ippsTone_Direct_16s:=getProc(hh,'ippsTone_Direct_16s');
  ippsTone_Direct_16sc:=getProc(hh,'ippsTone_Direct_16sc');
  ippsToneInitAllocQ15_16s:=getProc(hh,'ippsToneInitAllocQ15_16s');
  ippsToneFree:=getProc(hh,'ippsToneFree');
  ippsToneGetStateSizeQ15_16s:=getProc(hh,'ippsToneGetStateSizeQ15_16s');
  ippsToneInitQ15_16s:=getProc(hh,'ippsToneInitQ15_16s');
  ippsToneQ15_16s:=getProc(hh,'ippsToneQ15_16s');
  ippsTriangle_Direct_64f:=getProc(hh,'ippsTriangle_Direct_64f');
  ippsTriangle_Direct_64fc:=getProc(hh,'ippsTriangle_Direct_64fc');
  ippsTriangle_Direct_32f:=getProc(hh,'ippsTriangle_Direct_32f');
  ippsTriangle_Direct_32fc:=getProc(hh,'ippsTriangle_Direct_32fc');
  ippsTriangle_Direct_16s:=getProc(hh,'ippsTriangle_Direct_16s');
  ippsTriangle_Direct_16sc:=getProc(hh,'ippsTriangle_Direct_16sc');
  ippsTriangleInitAllocQ15_16s:=getProc(hh,'ippsTriangleInitAllocQ15_16s');
  ippsTriangleFree:=getProc(hh,'ippsTriangleFree');
  ippsTriangleGetStateSizeQ15_16s:=getProc(hh,'ippsTriangleGetStateSizeQ15_16s');
  ippsTriangleInitQ15_16s:=getProc(hh,'ippsTriangleInitQ15_16s');
  ippsTriangleQ15_16s:=getProc(hh,'ippsTriangleQ15_16s');
  ippsToneQ15_Direct_16s:=getProc(hh,'ippsToneQ15_Direct_16s');
  ippsTriangleQ15_Direct_16s:=getProc(hh,'ippsTriangleQ15_Direct_16s');
  ippsVectorRamp_8u:=getProc(hh,'ippsVectorRamp_8u');
  ippsVectorRamp_8s:=getProc(hh,'ippsVectorRamp_8s');
  ippsVectorRamp_16u:=getProc(hh,'ippsVectorRamp_16u');
  ippsVectorRamp_16s:=getProc(hh,'ippsVectorRamp_16s');
  ippsVectorRamp_32u:=getProc(hh,'ippsVectorRamp_32u');
  ippsVectorRamp_32s:=getProc(hh,'ippsVectorRamp_32s');
  ippsVectorRamp_32f:=getProc(hh,'ippsVectorRamp_32f');
  ippsVectorRamp_64f:=getProc(hh,'ippsVectorRamp_64f');
  ippsReal_64fc:=getProc(hh,'ippsReal_64fc');
  ippsReal_32fc:=getProc(hh,'ippsReal_32fc');
  ippsReal_16sc:=getProc(hh,'ippsReal_16sc');
  ippsImag_64fc:=getProc(hh,'ippsImag_64fc');
  ippsImag_32fc:=getProc(hh,'ippsImag_32fc');
  ippsImag_16sc:=getProc(hh,'ippsImag_16sc');
  ippsCplxToReal_64fc:=getProc(hh,'ippsCplxToReal_64fc');
  ippsCplxToReal_32fc:=getProc(hh,'ippsCplxToReal_32fc');
  ippsCplxToReal_16sc:=getProc(hh,'ippsCplxToReal_16sc');
  ippsRealToCplx_64f:=getProc(hh,'ippsRealToCplx_64f');
  ippsRealToCplx_32f:=getProc(hh,'ippsRealToCplx_32f');
  ippsRealToCplx_16s:=getProc(hh,'ippsRealToCplx_16s');
  ippsConj_64fc_I:=getProc(hh,'ippsConj_64fc_I');
  ippsConj_32fc_I:=getProc(hh,'ippsConj_32fc_I');
  ippsConj_16sc_I:=getProc(hh,'ippsConj_16sc_I');
  ippsConj_64fc:=getProc(hh,'ippsConj_64fc');
  ippsConj_32fc:=getProc(hh,'ippsConj_32fc');
  ippsConj_16sc:=getProc(hh,'ippsConj_16sc');
  ippsConjFlip_64fc:=getProc(hh,'ippsConjFlip_64fc');
  ippsConjFlip_32fc:=getProc(hh,'ippsConjFlip_32fc');
  ippsConjFlip_16sc:=getProc(hh,'ippsConjFlip_16sc');
  ippsConjCcs_64fc_I:=getProc(hh,'ippsConjCcs_64fc_I');
  ippsConjCcs_32fc_I:=getProc(hh,'ippsConjCcs_32fc_I');
  ippsConjCcs_16sc_I:=getProc(hh,'ippsConjCcs_16sc_I');
  ippsConjCcs_64fc:=getProc(hh,'ippsConjCcs_64fc');
  ippsConjCcs_32fc:=getProc(hh,'ippsConjCcs_32fc');
  ippsConjCcs_16sc:=getProc(hh,'ippsConjCcs_16sc');
  ippsConjPack_64fc_I:=getProc(hh,'ippsConjPack_64fc_I');
  ippsConjPack_32fc_I:=getProc(hh,'ippsConjPack_32fc_I');
  ippsConjPack_16sc_I:=getProc(hh,'ippsConjPack_16sc_I');
  ippsConjPack_64fc:=getProc(hh,'ippsConjPack_64fc');
  ippsConjPack_32fc:=getProc(hh,'ippsConjPack_32fc');
  ippsConjPack_16sc:=getProc(hh,'ippsConjPack_16sc');
  ippsConjPerm_64fc_I:=getProc(hh,'ippsConjPerm_64fc_I');
  ippsConjPerm_32fc_I:=getProc(hh,'ippsConjPerm_32fc_I');
  ippsConjPerm_16sc_I:=getProc(hh,'ippsConjPerm_16sc_I');
  ippsConjPerm_64fc:=getProc(hh,'ippsConjPerm_64fc');
  ippsConjPerm_32fc:=getProc(hh,'ippsConjPerm_32fc');
  ippsConjPerm_16sc:=getProc(hh,'ippsConjPerm_16sc');
  ippsConvert_8s16s:=getProc(hh,'ippsConvert_8s16s');
  ippsConvert_16s32s:=getProc(hh,'ippsConvert_16s32s');
  ippsConvert_32s16s:=getProc(hh,'ippsConvert_32s16s');
  ippsConvert_8s32f:=getProc(hh,'ippsConvert_8s32f');
  ippsConvert_8u32f:=getProc(hh,'ippsConvert_8u32f');
  ippsConvert_16s32f:=getProc(hh,'ippsConvert_16s32f');
  ippsConvert_16u32f:=getProc(hh,'ippsConvert_16u32f');
  ippsConvert_32s64f:=getProc(hh,'ippsConvert_32s64f');
  ippsConvert_32s32f:=getProc(hh,'ippsConvert_32s32f');
  ippsConvert_32f8s_Sfs:=getProc(hh,'ippsConvert_32f8s_Sfs');
  ippsConvert_32f8u_Sfs:=getProc(hh,'ippsConvert_32f8u_Sfs');
  ippsConvert_32f16s_Sfs:=getProc(hh,'ippsConvert_32f16s_Sfs');
  ippsConvert_32f16u_Sfs:=getProc(hh,'ippsConvert_32f16u_Sfs');
  ippsConvert_64f32s_Sfs:=getProc(hh,'ippsConvert_64f32s_Sfs');
  ippsConvert_32f32s_Sfs:=getProc(hh,'ippsConvert_32f32s_Sfs');
  ippsConvert_32f64f:=getProc(hh,'ippsConvert_32f64f');
  ippsConvert_64f32f:=getProc(hh,'ippsConvert_64f32f');
  ippsConvert_16s32f_Sfs:=getProc(hh,'ippsConvert_16s32f_Sfs');
  ippsConvert_16s64f_Sfs:=getProc(hh,'ippsConvert_16s64f_Sfs');
  ippsConvert_32s32f_Sfs:=getProc(hh,'ippsConvert_32s32f_Sfs');
  ippsConvert_32s64f_Sfs:=getProc(hh,'ippsConvert_32s64f_Sfs');
  ippsConvert_32s16s_Sfs:=getProc(hh,'ippsConvert_32s16s_Sfs');
  ippsConvert_24u32u:=getProc(hh,'ippsConvert_24u32u');
  ippsConvert_32u24u_Sfs:=getProc(hh,'ippsConvert_32u24u_Sfs');
  ippsConvert_24u32f:=getProc(hh,'ippsConvert_24u32f');
  ippsConvert_32f24u_Sfs:=getProc(hh,'ippsConvert_32f24u_Sfs');
  ippsConvert_24s32s:=getProc(hh,'ippsConvert_24s32s');
  ippsConvert_32s24s_Sfs:=getProc(hh,'ippsConvert_32s24s_Sfs');
  ippsConvert_24s32f:=getProc(hh,'ippsConvert_24s32f');
  ippsConvert_32f24s_Sfs:=getProc(hh,'ippsConvert_32f24s_Sfs');
  ippsConvert_16s16f:=getProc(hh,'ippsConvert_16s16f');
  ippsConvert_16f16s_Sfs:=getProc(hh,'ippsConvert_16f16s_Sfs');
  ippsConvert_32f16f:=getProc(hh,'ippsConvert_32f16f');
  ippsConvert_16f32f:=getProc(hh,'ippsConvert_16f32f');
  ippsThreshold_32f_I:=getProc(hh,'ippsThreshold_32f_I');
  ippsThreshold_32fc_I:=getProc(hh,'ippsThreshold_32fc_I');
  ippsThreshold_64f_I:=getProc(hh,'ippsThreshold_64f_I');
  ippsThreshold_64fc_I:=getProc(hh,'ippsThreshold_64fc_I');
  ippsThreshold_16s_I:=getProc(hh,'ippsThreshold_16s_I');
  ippsThreshold_16sc_I:=getProc(hh,'ippsThreshold_16sc_I');
  ippsThreshold_32f:=getProc(hh,'ippsThreshold_32f');
  ippsThreshold_32fc:=getProc(hh,'ippsThreshold_32fc');
  ippsThreshold_64f:=getProc(hh,'ippsThreshold_64f');
  ippsThreshold_64fc:=getProc(hh,'ippsThreshold_64fc');
  ippsThreshold_16s:=getProc(hh,'ippsThreshold_16s');
  ippsThreshold_16sc:=getProc(hh,'ippsThreshold_16sc');
  ippsThreshold_LT_32f_I:=getProc(hh,'ippsThreshold_LT_32f_I');
  ippsThreshold_LT_32fc_I:=getProc(hh,'ippsThreshold_LT_32fc_I');
  ippsThreshold_LT_64f_I:=getProc(hh,'ippsThreshold_LT_64f_I');
  ippsThreshold_LT_64fc_I:=getProc(hh,'ippsThreshold_LT_64fc_I');
  ippsThreshold_LT_16s_I:=getProc(hh,'ippsThreshold_LT_16s_I');
  ippsThreshold_LT_16sc_I:=getProc(hh,'ippsThreshold_LT_16sc_I');
  ippsThreshold_LT_32f:=getProc(hh,'ippsThreshold_LT_32f');
  ippsThreshold_LT_32fc:=getProc(hh,'ippsThreshold_LT_32fc');
  ippsThreshold_LT_64f:=getProc(hh,'ippsThreshold_LT_64f');
  ippsThreshold_LT_64fc:=getProc(hh,'ippsThreshold_LT_64fc');
  ippsThreshold_LT_16s:=getProc(hh,'ippsThreshold_LT_16s');
  ippsThreshold_LT_16sc:=getProc(hh,'ippsThreshold_LT_16sc');
  ippsThreshold_LT_32s_I:=getProc(hh,'ippsThreshold_LT_32s_I');
  ippsThreshold_LT_32s:=getProc(hh,'ippsThreshold_LT_32s');
  ippsThreshold_GT_32f_I:=getProc(hh,'ippsThreshold_GT_32f_I');
  ippsThreshold_GT_32fc_I:=getProc(hh,'ippsThreshold_GT_32fc_I');
  ippsThreshold_GT_64f_I:=getProc(hh,'ippsThreshold_GT_64f_I');
  ippsThreshold_GT_64fc_I:=getProc(hh,'ippsThreshold_GT_64fc_I');
  ippsThreshold_GT_16s_I:=getProc(hh,'ippsThreshold_GT_16s_I');
  ippsThreshold_GT_16sc_I:=getProc(hh,'ippsThreshold_GT_16sc_I');
  ippsThreshold_GT_32f:=getProc(hh,'ippsThreshold_GT_32f');
  ippsThreshold_GT_32fc:=getProc(hh,'ippsThreshold_GT_32fc');
  ippsThreshold_GT_64f:=getProc(hh,'ippsThreshold_GT_64f');
  ippsThreshold_GT_64fc:=getProc(hh,'ippsThreshold_GT_64fc');
  ippsThreshold_GT_16s:=getProc(hh,'ippsThreshold_GT_16s');
  ippsThreshold_GT_16sc:=getProc(hh,'ippsThreshold_GT_16sc');
  ippsThreshold_LTVal_32f_I:=getProc(hh,'ippsThreshold_LTVal_32f_I');
  ippsThreshold_LTVal_32fc_I:=getProc(hh,'ippsThreshold_LTVal_32fc_I');
  ippsThreshold_LTVal_64f_I:=getProc(hh,'ippsThreshold_LTVal_64f_I');
  ippsThreshold_LTVal_64fc_I:=getProc(hh,'ippsThreshold_LTVal_64fc_I');
  ippsThreshold_LTVal_16s_I:=getProc(hh,'ippsThreshold_LTVal_16s_I');
  ippsThreshold_LTVal_16sc_I:=getProc(hh,'ippsThreshold_LTVal_16sc_I');
  ippsThreshold_LTVal_32f:=getProc(hh,'ippsThreshold_LTVal_32f');
  ippsThreshold_LTVal_32fc:=getProc(hh,'ippsThreshold_LTVal_32fc');
  ippsThreshold_LTVal_64f:=getProc(hh,'ippsThreshold_LTVal_64f');
  ippsThreshold_LTVal_64fc:=getProc(hh,'ippsThreshold_LTVal_64fc');
  ippsThreshold_LTVal_16s:=getProc(hh,'ippsThreshold_LTVal_16s');
  ippsThreshold_LTVal_16sc:=getProc(hh,'ippsThreshold_LTVal_16sc');
  ippsThreshold_GTVal_32f_I:=getProc(hh,'ippsThreshold_GTVal_32f_I');
  ippsThreshold_GTVal_32fc_I:=getProc(hh,'ippsThreshold_GTVal_32fc_I');
  ippsThreshold_GTVal_64f_I:=getProc(hh,'ippsThreshold_GTVal_64f_I');
  ippsThreshold_GTVal_64fc_I:=getProc(hh,'ippsThreshold_GTVal_64fc_I');
  ippsThreshold_GTVal_16s_I:=getProc(hh,'ippsThreshold_GTVal_16s_I');
  ippsThreshold_GTVal_16sc_I:=getProc(hh,'ippsThreshold_GTVal_16sc_I');
  ippsThreshold_GTVal_32f:=getProc(hh,'ippsThreshold_GTVal_32f');
  ippsThreshold_GTVal_32fc:=getProc(hh,'ippsThreshold_GTVal_32fc');
  ippsThreshold_GTVal_64f:=getProc(hh,'ippsThreshold_GTVal_64f');
  ippsThreshold_GTVal_64fc:=getProc(hh,'ippsThreshold_GTVal_64fc');
  ippsThreshold_GTVal_16s:=getProc(hh,'ippsThreshold_GTVal_16s');
  ippsThreshold_GTVal_16sc:=getProc(hh,'ippsThreshold_GTVal_16sc');
  ippsThreshold_LTInv_32f_I:=getProc(hh,'ippsThreshold_LTInv_32f_I');
  ippsThreshold_LTInv_32fc_I:=getProc(hh,'ippsThreshold_LTInv_32fc_I');
  ippsThreshold_LTInv_64f_I:=getProc(hh,'ippsThreshold_LTInv_64f_I');
  ippsThreshold_LTInv_64fc_I:=getProc(hh,'ippsThreshold_LTInv_64fc_I');
  ippsThreshold_LTInv_32f:=getProc(hh,'ippsThreshold_LTInv_32f');
  ippsThreshold_LTInv_32fc:=getProc(hh,'ippsThreshold_LTInv_32fc');
  ippsThreshold_LTInv_64f:=getProc(hh,'ippsThreshold_LTInv_64f');
  ippsThreshold_LTInv_64fc:=getProc(hh,'ippsThreshold_LTInv_64fc');
  ippsThreshold_LTValGTVal_32f_I:=getProc(hh,'ippsThreshold_LTValGTVal_32f_I');
  ippsThreshold_LTValGTVal_64f_I:=getProc(hh,'ippsThreshold_LTValGTVal_64f_I');
  ippsThreshold_LTValGTVal_32f:=getProc(hh,'ippsThreshold_LTValGTVal_32f');
  ippsThreshold_LTValGTVal_64f:=getProc(hh,'ippsThreshold_LTValGTVal_64f');
  ippsThreshold_LTValGTVal_16s_I:=getProc(hh,'ippsThreshold_LTValGTVal_16s_I');
  ippsThreshold_LTValGTVal_16s:=getProc(hh,'ippsThreshold_LTValGTVal_16s');
  ippsCartToPolar_32fc:=getProc(hh,'ippsCartToPolar_32fc');
  ippsCartToPolar_64fc:=getProc(hh,'ippsCartToPolar_64fc');
  ippsCartToPolar_32f:=getProc(hh,'ippsCartToPolar_32f');
  ippsCartToPolar_64f:=getProc(hh,'ippsCartToPolar_64f');
  ippsPolarToCart_32fc:=getProc(hh,'ippsPolarToCart_32fc');
  ippsPolarToCart_64fc:=getProc(hh,'ippsPolarToCart_64fc');
  ippsPolarToCart_32f:=getProc(hh,'ippsPolarToCart_32f');
  ippsPolarToCart_64f:=getProc(hh,'ippsPolarToCart_64f');
  ippsALawToLin_8u32f:=getProc(hh,'ippsALawToLin_8u32f');
  ippsALawToLin_8u16s:=getProc(hh,'ippsALawToLin_8u16s');
  ippsMuLawToLin_8u32f:=getProc(hh,'ippsMuLawToLin_8u32f');
  ippsMuLawToLin_8u16s:=getProc(hh,'ippsMuLawToLin_8u16s');
  ippsLinToALaw_32f8u:=getProc(hh,'ippsLinToALaw_32f8u');
  ippsLinToALaw_16s8u:=getProc(hh,'ippsLinToALaw_16s8u');
  ippsLinToMuLaw_32f8u:=getProc(hh,'ippsLinToMuLaw_32f8u');
  ippsLinToMuLaw_16s8u:=getProc(hh,'ippsLinToMuLaw_16s8u');
  ippsALawToMuLaw_8u:=getProc(hh,'ippsALawToMuLaw_8u');
  ippsMuLawToALaw_8u:=getProc(hh,'ippsMuLawToALaw_8u');
  ippsPreemphasize_32f:=getProc(hh,'ippsPreemphasize_32f');
  ippsPreemphasize_16s:=getProc(hh,'ippsPreemphasize_16s');
  ippsFlip_8u:=getProc(hh,'ippsFlip_8u');
  ippsFlip_8u_I:=getProc(hh,'ippsFlip_8u_I');
  ippsFlip_16u:=getProc(hh,'ippsFlip_16u');
  ippsFlip_16u_I:=getProc(hh,'ippsFlip_16u_I');
  ippsFlip_32f:=getProc(hh,'ippsFlip_32f');
  ippsFlip_32f_I:=getProc(hh,'ippsFlip_32f_I');
  ippsFlip_64f:=getProc(hh,'ippsFlip_64f');
  ippsFlip_64f_I:=getProc(hh,'ippsFlip_64f_I');
  ippsUpdateLinear_16s32s_I:=getProc(hh,'ippsUpdateLinear_16s32s_I');
  ippsUpdatePower_16s32s_I:=getProc(hh,'ippsUpdatePower_16s32s_I');
  ippsJoin_32f16s_D2L:=getProc(hh,'ippsJoin_32f16s_D2L');
  ippsSwapBytes_16u_I:=getProc(hh,'ippsSwapBytes_16u_I');
  ippsSwapBytes_24u_I:=getProc(hh,'ippsSwapBytes_24u_I');
  ippsSwapBytes_32u_I:=getProc(hh,'ippsSwapBytes_32u_I');
  ippsSwapBytes_16u:=getProc(hh,'ippsSwapBytes_16u');
  ippsSwapBytes_24u:=getProc(hh,'ippsSwapBytes_24u');
  ippsSwapBytes_32u:=getProc(hh,'ippsSwapBytes_32u');
  ippsAddC_16s_I:=getProc(hh,'ippsAddC_16s_I');
  ippsSubC_16s_I:=getProc(hh,'ippsSubC_16s_I');
  ippsMulC_16s_I:=getProc(hh,'ippsMulC_16s_I');
  ippsAddC_32f_I:=getProc(hh,'ippsAddC_32f_I');
  ippsAddC_32fc_I:=getProc(hh,'ippsAddC_32fc_I');
  ippsSubC_32f_I:=getProc(hh,'ippsSubC_32f_I');
  ippsSubC_32fc_I:=getProc(hh,'ippsSubC_32fc_I');
  ippsSubCRev_32f_I:=getProc(hh,'ippsSubCRev_32f_I');
  ippsSubCRev_32fc_I:=getProc(hh,'ippsSubCRev_32fc_I');
  ippsMulC_32f_I:=getProc(hh,'ippsMulC_32f_I');
  ippsMulC_32fc_I:=getProc(hh,'ippsMulC_32fc_I');
  ippsAddC_64f_I:=getProc(hh,'ippsAddC_64f_I');
  ippsAddC_64fc_I:=getProc(hh,'ippsAddC_64fc_I');
  ippsSubC_64f_I:=getProc(hh,'ippsSubC_64f_I');
  ippsSubC_64fc_I:=getProc(hh,'ippsSubC_64fc_I');
  ippsSubCRev_64f_I:=getProc(hh,'ippsSubCRev_64f_I');
  ippsSubCRev_64fc_I:=getProc(hh,'ippsSubCRev_64fc_I');
  ippsMulC_64f_I:=getProc(hh,'ippsMulC_64f_I');
  ippsMulC_64fc_I:=getProc(hh,'ippsMulC_64fc_I');
  ippsMulC_32f16s_Sfs:=getProc(hh,'ippsMulC_32f16s_Sfs');
  ippsMulC_Low_32f16s:=getProc(hh,'ippsMulC_Low_32f16s');
  ippsAddC_8u_ISfs:=getProc(hh,'ippsAddC_8u_ISfs');
  ippsSubC_8u_ISfs:=getProc(hh,'ippsSubC_8u_ISfs');
  ippsSubCRev_8u_ISfs:=getProc(hh,'ippsSubCRev_8u_ISfs');
  ippsMulC_8u_ISfs:=getProc(hh,'ippsMulC_8u_ISfs');
  ippsAddC_16s_ISfs:=getProc(hh,'ippsAddC_16s_ISfs');
  ippsSubC_16s_ISfs:=getProc(hh,'ippsSubC_16s_ISfs');
  ippsMulC_16s_ISfs:=getProc(hh,'ippsMulC_16s_ISfs');
  ippsAddC_16sc_ISfs:=getProc(hh,'ippsAddC_16sc_ISfs');
  ippsSubC_16sc_ISfs:=getProc(hh,'ippsSubC_16sc_ISfs');
  ippsMulC_16sc_ISfs:=getProc(hh,'ippsMulC_16sc_ISfs');
  ippsSubCRev_16s_ISfs:=getProc(hh,'ippsSubCRev_16s_ISfs');
  ippsSubCRev_16sc_ISfs:=getProc(hh,'ippsSubCRev_16sc_ISfs');
  ippsAddC_32s_ISfs:=getProc(hh,'ippsAddC_32s_ISfs');
  ippsAddC_32sc_ISfs:=getProc(hh,'ippsAddC_32sc_ISfs');
  ippsSubC_32s_ISfs:=getProc(hh,'ippsSubC_32s_ISfs');
  ippsSubC_32sc_ISfs:=getProc(hh,'ippsSubC_32sc_ISfs');
  ippsSubCRev_32s_ISfs:=getProc(hh,'ippsSubCRev_32s_ISfs');
  ippsSubCRev_32sc_ISfs:=getProc(hh,'ippsSubCRev_32sc_ISfs');
  ippsMulC_32s_ISfs:=getProc(hh,'ippsMulC_32s_ISfs');
  ippsMulC_32sc_ISfs:=getProc(hh,'ippsMulC_32sc_ISfs');
  ippsAddC_32f:=getProc(hh,'ippsAddC_32f');
  ippsAddC_32fc:=getProc(hh,'ippsAddC_32fc');
  ippsSubC_32f:=getProc(hh,'ippsSubC_32f');
  ippsSubC_32fc:=getProc(hh,'ippsSubC_32fc');
  ippsSubCRev_32f:=getProc(hh,'ippsSubCRev_32f');
  ippsSubCRev_32fc:=getProc(hh,'ippsSubCRev_32fc');
  ippsMulC_32f:=getProc(hh,'ippsMulC_32f');
  ippsMulC_32fc:=getProc(hh,'ippsMulC_32fc');
  ippsAddC_64f:=getProc(hh,'ippsAddC_64f');
  ippsAddC_64fc:=getProc(hh,'ippsAddC_64fc');
  ippsSubC_64f:=getProc(hh,'ippsSubC_64f');
  ippsSubC_64fc:=getProc(hh,'ippsSubC_64fc');
  ippsSubCRev_64f:=getProc(hh,'ippsSubCRev_64f');
  ippsSubCRev_64fc:=getProc(hh,'ippsSubCRev_64fc');
  ippsMulC_64f:=getProc(hh,'ippsMulC_64f');
  ippsMulC_64fc:=getProc(hh,'ippsMulC_64fc');
  ippsAddC_8u_Sfs:=getProc(hh,'ippsAddC_8u_Sfs');
  ippsSubC_8u_Sfs:=getProc(hh,'ippsSubC_8u_Sfs');
  ippsSubCRev_8u_Sfs:=getProc(hh,'ippsSubCRev_8u_Sfs');
  ippsMulC_8u_Sfs:=getProc(hh,'ippsMulC_8u_Sfs');
  ippsAddC_16s_Sfs:=getProc(hh,'ippsAddC_16s_Sfs');
  ippsAddC_16sc_Sfs:=getProc(hh,'ippsAddC_16sc_Sfs');
  ippsSubC_16s_Sfs:=getProc(hh,'ippsSubC_16s_Sfs');
  ippsSubC_16sc_Sfs:=getProc(hh,'ippsSubC_16sc_Sfs');
  ippsSubCRev_16s_Sfs:=getProc(hh,'ippsSubCRev_16s_Sfs');
  ippsSubCRev_16sc_Sfs:=getProc(hh,'ippsSubCRev_16sc_Sfs');
  ippsMulC_16s_Sfs:=getProc(hh,'ippsMulC_16s_Sfs');
  ippsMulC_16sc_Sfs:=getProc(hh,'ippsMulC_16sc_Sfs');
  ippsAddC_32s_Sfs:=getProc(hh,'ippsAddC_32s_Sfs');
  ippsAddC_32sc_Sfs:=getProc(hh,'ippsAddC_32sc_Sfs');
  ippsSubC_32s_Sfs:=getProc(hh,'ippsSubC_32s_Sfs');
  ippsSubC_32sc_Sfs:=getProc(hh,'ippsSubC_32sc_Sfs');
  ippsSubCRev_32s_Sfs:=getProc(hh,'ippsSubCRev_32s_Sfs');
  ippsSubCRev_32sc_Sfs:=getProc(hh,'ippsSubCRev_32sc_Sfs');
  ippsMulC_32s_Sfs:=getProc(hh,'ippsMulC_32s_Sfs');
  ippsMulC_32sc_Sfs:=getProc(hh,'ippsMulC_32sc_Sfs');
  ippsAdd_16s_I:=getProc(hh,'ippsAdd_16s_I');
  ippsSub_16s_I:=getProc(hh,'ippsSub_16s_I');
  ippsMul_16s_I:=getProc(hh,'ippsMul_16s_I');
  ippsAdd_32f_I:=getProc(hh,'ippsAdd_32f_I');
  ippsAdd_32fc_I:=getProc(hh,'ippsAdd_32fc_I');
  ippsSub_32f_I:=getProc(hh,'ippsSub_32f_I');
  ippsSub_32fc_I:=getProc(hh,'ippsSub_32fc_I');
  ippsMul_32f_I:=getProc(hh,'ippsMul_32f_I');
  ippsMul_32fc_I:=getProc(hh,'ippsMul_32fc_I');
  ippsAdd_64f_I:=getProc(hh,'ippsAdd_64f_I');
  ippsAdd_64fc_I:=getProc(hh,'ippsAdd_64fc_I');
  ippsSub_64f_I:=getProc(hh,'ippsSub_64f_I');
  ippsSub_64fc_I:=getProc(hh,'ippsSub_64fc_I');
  ippsMul_64f_I:=getProc(hh,'ippsMul_64f_I');
  ippsMul_64fc_I:=getProc(hh,'ippsMul_64fc_I');
  ippsAdd_8u_ISfs:=getProc(hh,'ippsAdd_8u_ISfs');
  ippsSub_8u_ISfs:=getProc(hh,'ippsSub_8u_ISfs');
  ippsMul_8u_ISfs:=getProc(hh,'ippsMul_8u_ISfs');
  ippsAdd_16s_ISfs:=getProc(hh,'ippsAdd_16s_ISfs');
  ippsAdd_16sc_ISfs:=getProc(hh,'ippsAdd_16sc_ISfs');
  ippsSub_16s_ISfs:=getProc(hh,'ippsSub_16s_ISfs');
  ippsSub_16sc_ISfs:=getProc(hh,'ippsSub_16sc_ISfs');
  ippsMul_16s_ISfs:=getProc(hh,'ippsMul_16s_ISfs');
  ippsMul_16sc_ISfs:=getProc(hh,'ippsMul_16sc_ISfs');
  ippsAdd_32s_ISfs:=getProc(hh,'ippsAdd_32s_ISfs');
  ippsAdd_32sc_ISfs:=getProc(hh,'ippsAdd_32sc_ISfs');
  ippsSub_32s_ISfs:=getProc(hh,'ippsSub_32s_ISfs');
  ippsSub_32sc_ISfs:=getProc(hh,'ippsSub_32sc_ISfs');
  ippsMul_32s_ISfs:=getProc(hh,'ippsMul_32s_ISfs');
  ippsMul_32sc_ISfs:=getProc(hh,'ippsMul_32sc_ISfs');
  ippsAdd_8u16u:=getProc(hh,'ippsAdd_8u16u');
  ippsMul_8u16u:=getProc(hh,'ippsMul_8u16u');
  ippsAdd_16s:=getProc(hh,'ippsAdd_16s');
  ippsSub_16s:=getProc(hh,'ippsSub_16s');
  ippsMul_16s:=getProc(hh,'ippsMul_16s');
  ippsAdd_16u:=getProc(hh,'ippsAdd_16u');
  ippsAdd_32u:=getProc(hh,'ippsAdd_32u');
  ippsAdd_16s32f:=getProc(hh,'ippsAdd_16s32f');
  ippsSub_16s32f:=getProc(hh,'ippsSub_16s32f');
  ippsMul_16s32f:=getProc(hh,'ippsMul_16s32f');
  ippsAdd_32f:=getProc(hh,'ippsAdd_32f');
  ippsAdd_32fc:=getProc(hh,'ippsAdd_32fc');
  ippsSub_32f:=getProc(hh,'ippsSub_32f');
  ippsSub_32fc:=getProc(hh,'ippsSub_32fc');
  ippsMul_32f:=getProc(hh,'ippsMul_32f');
  ippsMul_32fc:=getProc(hh,'ippsMul_32fc');
  ippsAdd_64f:=getProc(hh,'ippsAdd_64f');
  ippsAdd_64fc:=getProc(hh,'ippsAdd_64fc');
  ippsSub_64f:=getProc(hh,'ippsSub_64f');
  ippsSub_64fc:=getProc(hh,'ippsSub_64fc');
  ippsMul_64f:=getProc(hh,'ippsMul_64f');
  ippsMul_64fc:=getProc(hh,'ippsMul_64fc');
  ippsAdd_8u_Sfs:=getProc(hh,'ippsAdd_8u_Sfs');
  ippsSub_8u_Sfs:=getProc(hh,'ippsSub_8u_Sfs');
  ippsMul_8u_Sfs:=getProc(hh,'ippsMul_8u_Sfs');
  ippsAdd_16s_Sfs:=getProc(hh,'ippsAdd_16s_Sfs');
  ippsAdd_16sc_Sfs:=getProc(hh,'ippsAdd_16sc_Sfs');
  ippsSub_16s_Sfs:=getProc(hh,'ippsSub_16s_Sfs');
  ippsSub_16sc_Sfs:=getProc(hh,'ippsSub_16sc_Sfs');
  ippsMul_16s_Sfs:=getProc(hh,'ippsMul_16s_Sfs');
  ippsMul_16sc_Sfs:=getProc(hh,'ippsMul_16sc_Sfs');
  ippsMul_16s32s_Sfs:=getProc(hh,'ippsMul_16s32s_Sfs');
  ippsAdd_32s_Sfs:=getProc(hh,'ippsAdd_32s_Sfs');
  ippsAdd_32sc_Sfs:=getProc(hh,'ippsAdd_32sc_Sfs');
  ippsSub_32s_Sfs:=getProc(hh,'ippsSub_32s_Sfs');
  ippsSub_32sc_Sfs:=getProc(hh,'ippsSub_32sc_Sfs');
  ippsMul_32s_Sfs:=getProc(hh,'ippsMul_32s_Sfs');
  ippsMul_32sc_Sfs:=getProc(hh,'ippsMul_32sc_Sfs');
  ippsMul_16u16s_Sfs:=getProc(hh,'ippsMul_16u16s_Sfs');
  ippsMul_32s32sc_ISfs:=getProc(hh,'ippsMul_32s32sc_ISfs');
  ippsMul_32s32sc_Sfs:=getProc(hh,'ippsMul_32s32sc_Sfs');
  ippsAddProduct_16s_Sfs:=getProc(hh,'ippsAddProduct_16s_Sfs');
  ippsAddProduct_16s32s_Sfs:=getProc(hh,'ippsAddProduct_16s32s_Sfs');
  ippsAddProduct_32s_Sfs:=getProc(hh,'ippsAddProduct_32s_Sfs');
  ippsAddProduct_32f:=getProc(hh,'ippsAddProduct_32f');
  ippsAddProduct_64f:=getProc(hh,'ippsAddProduct_64f');
  ippsAddProduct_32fc:=getProc(hh,'ippsAddProduct_32fc');
  ippsAddProduct_64fc:=getProc(hh,'ippsAddProduct_64fc');
  ippsSqr_32f_I:=getProc(hh,'ippsSqr_32f_I');
  ippsSqr_32fc_I:=getProc(hh,'ippsSqr_32fc_I');
  ippsSqr_64f_I:=getProc(hh,'ippsSqr_64f_I');
  ippsSqr_64fc_I:=getProc(hh,'ippsSqr_64fc_I');
  ippsSqr_32f:=getProc(hh,'ippsSqr_32f');
  ippsSqr_32fc:=getProc(hh,'ippsSqr_32fc');
  ippsSqr_64f:=getProc(hh,'ippsSqr_64f');
  ippsSqr_64fc:=getProc(hh,'ippsSqr_64fc');
  ippsSqr_16s_ISfs:=getProc(hh,'ippsSqr_16s_ISfs');
  ippsSqr_16sc_ISfs:=getProc(hh,'ippsSqr_16sc_ISfs');
  ippsSqr_16s_Sfs:=getProc(hh,'ippsSqr_16s_Sfs');
  ippsSqr_16sc_Sfs:=getProc(hh,'ippsSqr_16sc_Sfs');
  ippsSqr_8u_ISfs:=getProc(hh,'ippsSqr_8u_ISfs');
  ippsSqr_8u_Sfs:=getProc(hh,'ippsSqr_8u_Sfs');
  ippsSqr_16u_ISfs:=getProc(hh,'ippsSqr_16u_ISfs');
  ippsSqr_16u_Sfs:=getProc(hh,'ippsSqr_16u_Sfs');
  ippsDiv_32f:=getProc(hh,'ippsDiv_32f');
  ippsDiv_32fc:=getProc(hh,'ippsDiv_32fc');
  ippsDiv_64f:=getProc(hh,'ippsDiv_64f');
  ippsDiv_64fc:=getProc(hh,'ippsDiv_64fc');
  ippsDiv_16s_Sfs:=getProc(hh,'ippsDiv_16s_Sfs');
  ippsDiv_8u_Sfs:=getProc(hh,'ippsDiv_8u_Sfs');
  ippsDiv_16sc_Sfs:=getProc(hh,'ippsDiv_16sc_Sfs');
  ippsDivC_32f:=getProc(hh,'ippsDivC_32f');
  ippsDivC_32fc:=getProc(hh,'ippsDivC_32fc');
  ippsDivC_64f:=getProc(hh,'ippsDivC_64f');
  ippsDivC_64fc:=getProc(hh,'ippsDivC_64fc');
  ippsDivC_16s_Sfs:=getProc(hh,'ippsDivC_16s_Sfs');
  ippsDivC_8u_Sfs:=getProc(hh,'ippsDivC_8u_Sfs');
  ippsDivC_16sc_Sfs:=getProc(hh,'ippsDivC_16sc_Sfs');
  ippsDiv_32f_I:=getProc(hh,'ippsDiv_32f_I');
  ippsDiv_32fc_I:=getProc(hh,'ippsDiv_32fc_I');
  ippsDiv_64f_I:=getProc(hh,'ippsDiv_64f_I');
  ippsDiv_64fc_I:=getProc(hh,'ippsDiv_64fc_I');
  ippsDiv_16s_ISfs:=getProc(hh,'ippsDiv_16s_ISfs');
  ippsDiv_8u_ISfs:=getProc(hh,'ippsDiv_8u_ISfs');
  ippsDiv_16sc_ISfs:=getProc(hh,'ippsDiv_16sc_ISfs');
  ippsDiv_32s_Sfs:=getProc(hh,'ippsDiv_32s_Sfs');
  ippsDiv_32s_ISfs:=getProc(hh,'ippsDiv_32s_ISfs');
  ippsDivC_32f_I:=getProc(hh,'ippsDivC_32f_I');
  ippsDivC_32fc_I:=getProc(hh,'ippsDivC_32fc_I');
  ippsDivC_64f_I:=getProc(hh,'ippsDivC_64f_I');
  ippsDivC_64fc_I:=getProc(hh,'ippsDivC_64fc_I');
  ippsDivC_16s_ISfs:=getProc(hh,'ippsDivC_16s_ISfs');
  ippsDivC_8u_ISfs:=getProc(hh,'ippsDivC_8u_ISfs');
  ippsDivC_16sc_ISfs:=getProc(hh,'ippsDivC_16sc_ISfs');
  ippsDivCRev_16u:=getProc(hh,'ippsDivCRev_16u');
  ippsDivCRev_32f:=getProc(hh,'ippsDivCRev_32f');
  ippsDivCRev_16u_I:=getProc(hh,'ippsDivCRev_16u_I');
  ippsDivCRev_32f_I:=getProc(hh,'ippsDivCRev_32f_I');
  ippsSqrt_32f_I:=getProc(hh,'ippsSqrt_32f_I');
  ippsSqrt_32fc_I:=getProc(hh,'ippsSqrt_32fc_I');
  ippsSqrt_64f_I:=getProc(hh,'ippsSqrt_64f_I');
  ippsSqrt_64fc_I:=getProc(hh,'ippsSqrt_64fc_I');
  ippsSqrt_32f:=getProc(hh,'ippsSqrt_32f');
  ippsSqrt_32fc:=getProc(hh,'ippsSqrt_32fc');
  ippsSqrt_64f:=getProc(hh,'ippsSqrt_64f');
  ippsSqrt_64fc:=getProc(hh,'ippsSqrt_64fc');
  ippsSqrt_16s_ISfs:=getProc(hh,'ippsSqrt_16s_ISfs');
  ippsSqrt_16sc_ISfs:=getProc(hh,'ippsSqrt_16sc_ISfs');
  ippsSqrt_16s_Sfs:=getProc(hh,'ippsSqrt_16s_Sfs');
  ippsSqrt_16sc_Sfs:=getProc(hh,'ippsSqrt_16sc_Sfs');
  ippsSqrt_64s_ISfs:=getProc(hh,'ippsSqrt_64s_ISfs');
  ippsSqrt_64s_Sfs:=getProc(hh,'ippsSqrt_64s_Sfs');
  ippsSqrt_8u_ISfs:=getProc(hh,'ippsSqrt_8u_ISfs');
  ippsSqrt_8u_Sfs:=getProc(hh,'ippsSqrt_8u_Sfs');
  ippsSqrt_16u_ISfs:=getProc(hh,'ippsSqrt_16u_ISfs');
  ippsSqrt_16u_Sfs:=getProc(hh,'ippsSqrt_16u_Sfs');
  ippsCubrt_32s16s_Sfs:=getProc(hh,'ippsCubrt_32s16s_Sfs');
  ippsCubrt_32f:=getProc(hh,'ippsCubrt_32f');
  ippsAbs_32f_I:=getProc(hh,'ippsAbs_32f_I');
  ippsAbs_64f_I:=getProc(hh,'ippsAbs_64f_I');
  ippsAbs_16s_I:=getProc(hh,'ippsAbs_16s_I');
  ippsAbs_32f:=getProc(hh,'ippsAbs_32f');
  ippsAbs_64f:=getProc(hh,'ippsAbs_64f');
end;

procedure InitIpps2;
begin
  ippsAbs_16s:=getProc(hh,'ippsAbs_16s');
  ippsAbs_32s_I:=getProc(hh,'ippsAbs_32s_I');
  ippsAbs_32s:=getProc(hh,'ippsAbs_32s');
  ippsMagnitude_32fc:=getProc(hh,'ippsMagnitude_32fc');
  ippsMagnitude_64fc:=getProc(hh,'ippsMagnitude_64fc');
  ippsMagnitude_16sc32f:=getProc(hh,'ippsMagnitude_16sc32f');
  ippsMagnitude_16sc_Sfs:=getProc(hh,'ippsMagnitude_16sc_Sfs');
  ippsMagnitude_32f:=getProc(hh,'ippsMagnitude_32f');
  ippsMagnitude_64f:=getProc(hh,'ippsMagnitude_64f');
  ippsMagnitude_16s_Sfs:=getProc(hh,'ippsMagnitude_16s_Sfs');
  ippsMagnitude_32sc_Sfs:=getProc(hh,'ippsMagnitude_32sc_Sfs');
  ippsMagnitude_16s32f:=getProc(hh,'ippsMagnitude_16s32f');
  ippsMagSquared_32sc32s_Sfs:=getProc(hh,'ippsMagSquared_32sc32s_Sfs');
  ippsExp_32f_I:=getProc(hh,'ippsExp_32f_I');
  ippsExp_64f_I:=getProc(hh,'ippsExp_64f_I');
  ippsExp_16s_ISfs:=getProc(hh,'ippsExp_16s_ISfs');
  ippsExp_32s_ISfs:=getProc(hh,'ippsExp_32s_ISfs');
  ippsExp_64s_ISfs:=getProc(hh,'ippsExp_64s_ISfs');
  ippsExp_32f:=getProc(hh,'ippsExp_32f');
  ippsExp_64f:=getProc(hh,'ippsExp_64f');
  ippsExp_16s_Sfs:=getProc(hh,'ippsExp_16s_Sfs');
  ippsExp_32s_Sfs:=getProc(hh,'ippsExp_32s_Sfs');
  ippsExp_64s_Sfs:=getProc(hh,'ippsExp_64s_Sfs');
  ippsExp_32f64f:=getProc(hh,'ippsExp_32f64f');
  ippsLn_32f_I:=getProc(hh,'ippsLn_32f_I');
  ippsLn_64f_I:=getProc(hh,'ippsLn_64f_I');
  ippsLn_32f:=getProc(hh,'ippsLn_32f');
  ippsLn_64f:=getProc(hh,'ippsLn_64f');
  ippsLn_64f32f:=getProc(hh,'ippsLn_64f32f');
  ippsLn_16s_ISfs:=getProc(hh,'ippsLn_16s_ISfs');
  ippsLn_16s_Sfs:=getProc(hh,'ippsLn_16s_Sfs');
  ippsLn_32s16s_Sfs:=getProc(hh,'ippsLn_32s16s_Sfs');
  ippsLn_32s_ISfs:=getProc(hh,'ippsLn_32s_ISfs');
  ippsLn_32s_Sfs:=getProc(hh,'ippsLn_32s_Sfs');
  ipps10Log10_32s_ISfs:=getProc(hh,'ipps10Log10_32s_ISfs');
  ipps10Log10_32s_Sfs:=getProc(hh,'ipps10Log10_32s_Sfs');
  ippsSumLn_32f:=getProc(hh,'ippsSumLn_32f');
  ippsSumLn_64f:=getProc(hh,'ippsSumLn_64f');
  ippsSumLn_32f64f:=getProc(hh,'ippsSumLn_32f64f');
  ippsSumLn_16s32f:=getProc(hh,'ippsSumLn_16s32f');
  ippsSortAscend_8u_I:=getProc(hh,'ippsSortAscend_8u_I');
  ippsSortAscend_16s_I:=getProc(hh,'ippsSortAscend_16s_I');
  ippsSortAscend_32s_I:=getProc(hh,'ippsSortAscend_32s_I');
  ippsSortAscend_32f_I:=getProc(hh,'ippsSortAscend_32f_I');
  ippsSortAscend_64f_I:=getProc(hh,'ippsSortAscend_64f_I');
  ippsSortDescend_8u_I:=getProc(hh,'ippsSortDescend_8u_I');
  ippsSortDescend_16s_I:=getProc(hh,'ippsSortDescend_16s_I');
  ippsSortDescend_32s_I:=getProc(hh,'ippsSortDescend_32s_I');
  ippsSortDescend_32f_I:=getProc(hh,'ippsSortDescend_32f_I');
  ippsSortDescend_64f_I:=getProc(hh,'ippsSortDescend_64f_I');
  ippsSum_32f:=getProc(hh,'ippsSum_32f');
  ippsSum_64f:=getProc(hh,'ippsSum_64f');
  ippsSum_32fc:=getProc(hh,'ippsSum_32fc');
  ippsSum_16s32s_Sfs:=getProc(hh,'ippsSum_16s32s_Sfs');
  ippsSum_16sc32sc_Sfs:=getProc(hh,'ippsSum_16sc32sc_Sfs');
  ippsSum_16s_Sfs:=getProc(hh,'ippsSum_16s_Sfs');
  ippsSum_16sc_Sfs:=getProc(hh,'ippsSum_16sc_Sfs');
  ippsSum_32s_Sfs:=getProc(hh,'ippsSum_32s_Sfs');
  ippsSum_64fc:=getProc(hh,'ippsSum_64fc');
  ippsMean_32f:=getProc(hh,'ippsMean_32f');
  ippsMean_32fc:=getProc(hh,'ippsMean_32fc');
  ippsMean_64f:=getProc(hh,'ippsMean_64f');
  ippsMean_16s_Sfs:=getProc(hh,'ippsMean_16s_Sfs');
  ippsMean_16sc_Sfs:=getProc(hh,'ippsMean_16sc_Sfs');
  ippsMean_64fc:=getProc(hh,'ippsMean_64fc');
  ippsStdDev_32f:=getProc(hh,'ippsStdDev_32f');
  ippsStdDev_64f:=getProc(hh,'ippsStdDev_64f');
  ippsStdDev_16s32s_Sfs:=getProc(hh,'ippsStdDev_16s32s_Sfs');
  ippsStdDev_16s_Sfs:=getProc(hh,'ippsStdDev_16s_Sfs');
  ippsMax_32f:=getProc(hh,'ippsMax_32f');
  ippsMax_64f:=getProc(hh,'ippsMax_64f');
  ippsMax_16s:=getProc(hh,'ippsMax_16s');
  ippsMaxIndx_16s:=getProc(hh,'ippsMaxIndx_16s');
  ippsMaxIndx_32f:=getProc(hh,'ippsMaxIndx_32f');
  ippsMaxIndx_64f:=getProc(hh,'ippsMaxIndx_64f');
  ippsMin_32f:=getProc(hh,'ippsMin_32f');
  ippsMin_64f:=getProc(hh,'ippsMin_64f');
  ippsMin_16s:=getProc(hh,'ippsMin_16s');
  ippsMinIndx_16s:=getProc(hh,'ippsMinIndx_16s');
  ippsMinIndx_32f:=getProc(hh,'ippsMinIndx_32f');
  ippsMinIndx_64f:=getProc(hh,'ippsMinIndx_64f');
  ippsMinEvery_16s_I:=getProc(hh,'ippsMinEvery_16s_I');
  ippsMinEvery_32s_I:=getProc(hh,'ippsMinEvery_32s_I');
  ippsMinEvery_32f_I:=getProc(hh,'ippsMinEvery_32f_I');
  ippsMaxEvery_16s_I:=getProc(hh,'ippsMaxEvery_16s_I');
  ippsMaxEvery_32s_I:=getProc(hh,'ippsMaxEvery_32s_I');
  ippsMaxEvery_32f_I:=getProc(hh,'ippsMaxEvery_32f_I');
  ippsMinMax_64f:=getProc(hh,'ippsMinMax_64f');
  ippsMinMax_32f:=getProc(hh,'ippsMinMax_32f');
  ippsMinMax_32s:=getProc(hh,'ippsMinMax_32s');
  ippsMinMax_32u:=getProc(hh,'ippsMinMax_32u');
  ippsMinMax_16s:=getProc(hh,'ippsMinMax_16s');
  ippsMinMax_16u:=getProc(hh,'ippsMinMax_16u');
  ippsMinMax_8u:=getProc(hh,'ippsMinMax_8u');
  ippsMinMaxIndx_64f:=getProc(hh,'ippsMinMaxIndx_64f');
  ippsMinMaxIndx_32f:=getProc(hh,'ippsMinMaxIndx_32f');
  ippsMinMaxIndx_32s:=getProc(hh,'ippsMinMaxIndx_32s');
  ippsMinMaxIndx_32u:=getProc(hh,'ippsMinMaxIndx_32u');
  ippsMinMaxIndx_16s:=getProc(hh,'ippsMinMaxIndx_16s');
  ippsMinMaxIndx_16u:=getProc(hh,'ippsMinMaxIndx_16u');
  ippsMinMaxIndx_8u:=getProc(hh,'ippsMinMaxIndx_8u');
  ippsPhase_64fc:=getProc(hh,'ippsPhase_64fc');
  ippsPhase_32fc:=getProc(hh,'ippsPhase_32fc');
  ippsPhase_16sc32f:=getProc(hh,'ippsPhase_16sc32f');
  ippsPhase_16sc_Sfs:=getProc(hh,'ippsPhase_16sc_Sfs');
  ippsPhase_64f:=getProc(hh,'ippsPhase_64f');
  ippsPhase_32f:=getProc(hh,'ippsPhase_32f');
  ippsPhase_16s_Sfs:=getProc(hh,'ippsPhase_16s_Sfs');
  ippsPhase_16s32f:=getProc(hh,'ippsPhase_16s32f');
  ippsPhase_32sc_Sfs:=getProc(hh,'ippsPhase_32sc_Sfs');
  ippsMaxOrder_64f:=getProc(hh,'ippsMaxOrder_64f');
  ippsMaxOrder_32f:=getProc(hh,'ippsMaxOrder_32f');
  ippsMaxOrder_32s:=getProc(hh,'ippsMaxOrder_32s');
  ippsMaxOrder_16s:=getProc(hh,'ippsMaxOrder_16s');
  ippsArctan_32f_I:=getProc(hh,'ippsArctan_32f_I');
  ippsArctan_32f:=getProc(hh,'ippsArctan_32f');
  ippsArctan_64f_I:=getProc(hh,'ippsArctan_64f_I');
  ippsArctan_64f:=getProc(hh,'ippsArctan_64f');
  ippsFindNearestOne_16u:=getProc(hh,'ippsFindNearestOne_16u');
  ippsFindNearest_16u:=getProc(hh,'ippsFindNearest_16u');
  ippsAndC_8u_I:=getProc(hh,'ippsAndC_8u_I');
  ippsAndC_8u:=getProc(hh,'ippsAndC_8u');
  ippsAndC_16u_I:=getProc(hh,'ippsAndC_16u_I');
  ippsAndC_16u:=getProc(hh,'ippsAndC_16u');
  ippsAndC_32u_I:=getProc(hh,'ippsAndC_32u_I');
  ippsAndC_32u:=getProc(hh,'ippsAndC_32u');
  ippsAnd_8u_I:=getProc(hh,'ippsAnd_8u_I');
  ippsAnd_8u:=getProc(hh,'ippsAnd_8u');
  ippsAnd_16u_I:=getProc(hh,'ippsAnd_16u_I');
  ippsAnd_16u:=getProc(hh,'ippsAnd_16u');
  ippsAnd_32u_I:=getProc(hh,'ippsAnd_32u_I');
  ippsAnd_32u:=getProc(hh,'ippsAnd_32u');
  ippsOrC_8u_I:=getProc(hh,'ippsOrC_8u_I');
  ippsOrC_8u:=getProc(hh,'ippsOrC_8u');
  ippsOrC_16u_I:=getProc(hh,'ippsOrC_16u_I');
  ippsOrC_16u:=getProc(hh,'ippsOrC_16u');
  ippsOrC_32u_I:=getProc(hh,'ippsOrC_32u_I');
  ippsOrC_32u:=getProc(hh,'ippsOrC_32u');
  ippsOr_8u_I:=getProc(hh,'ippsOr_8u_I');
  ippsOr_8u:=getProc(hh,'ippsOr_8u');
  ippsOr_16u_I:=getProc(hh,'ippsOr_16u_I');
  ippsOr_16u:=getProc(hh,'ippsOr_16u');
  ippsOr_32u_I:=getProc(hh,'ippsOr_32u_I');
  ippsOr_32u:=getProc(hh,'ippsOr_32u');
  ippsXorC_8u_I:=getProc(hh,'ippsXorC_8u_I');
  ippsXorC_8u:=getProc(hh,'ippsXorC_8u');
  ippsXorC_16u_I:=getProc(hh,'ippsXorC_16u_I');
  ippsXorC_16u:=getProc(hh,'ippsXorC_16u');
  ippsXorC_32u_I:=getProc(hh,'ippsXorC_32u_I');
  ippsXorC_32u:=getProc(hh,'ippsXorC_32u');
  ippsXor_8u_I:=getProc(hh,'ippsXor_8u_I');
  ippsXor_8u:=getProc(hh,'ippsXor_8u');
  ippsXor_16u_I:=getProc(hh,'ippsXor_16u_I');
  ippsXor_16u:=getProc(hh,'ippsXor_16u');
  ippsXor_32u_I:=getProc(hh,'ippsXor_32u_I');
  ippsXor_32u:=getProc(hh,'ippsXor_32u');
  ippsNot_8u_I:=getProc(hh,'ippsNot_8u_I');
  ippsNot_8u:=getProc(hh,'ippsNot_8u');
  ippsNot_16u_I:=getProc(hh,'ippsNot_16u_I');
  ippsNot_16u:=getProc(hh,'ippsNot_16u');
  ippsNot_32u_I:=getProc(hh,'ippsNot_32u_I');
  ippsNot_32u:=getProc(hh,'ippsNot_32u');
  ippsLShiftC_8u_I:=getProc(hh,'ippsLShiftC_8u_I');
  ippsLShiftC_8u:=getProc(hh,'ippsLShiftC_8u');
  ippsLShiftC_16u_I:=getProc(hh,'ippsLShiftC_16u_I');
  ippsLShiftC_16u:=getProc(hh,'ippsLShiftC_16u');
  ippsLShiftC_16s_I:=getProc(hh,'ippsLShiftC_16s_I');
  ippsLShiftC_16s:=getProc(hh,'ippsLShiftC_16s');
  ippsLShiftC_32s_I:=getProc(hh,'ippsLShiftC_32s_I');
  ippsLShiftC_32s:=getProc(hh,'ippsLShiftC_32s');
  ippsRShiftC_8u_I:=getProc(hh,'ippsRShiftC_8u_I');
  ippsRShiftC_8u:=getProc(hh,'ippsRShiftC_8u');
  ippsRShiftC_16u_I:=getProc(hh,'ippsRShiftC_16u_I');
  ippsRShiftC_16u:=getProc(hh,'ippsRShiftC_16u');
  ippsRShiftC_16s_I:=getProc(hh,'ippsRShiftC_16s_I');
  ippsRShiftC_16s:=getProc(hh,'ippsRShiftC_16s');
  ippsRShiftC_32s_I:=getProc(hh,'ippsRShiftC_32s_I');
  ippsRShiftC_32s:=getProc(hh,'ippsRShiftC_32s');
  ippsDotProd_32f:=getProc(hh,'ippsDotProd_32f');
  ippsDotProd_32fc:=getProc(hh,'ippsDotProd_32fc');
  ippsDotProd_32f32fc:=getProc(hh,'ippsDotProd_32f32fc');
  ippsDotProd_64f:=getProc(hh,'ippsDotProd_64f');
  ippsDotProd_64fc:=getProc(hh,'ippsDotProd_64fc');
  ippsDotProd_64f64fc:=getProc(hh,'ippsDotProd_64f64fc');
  ippsDotProd_16s_Sfs:=getProc(hh,'ippsDotProd_16s_Sfs');
  ippsDotProd_16sc_Sfs:=getProc(hh,'ippsDotProd_16sc_Sfs');
  ippsDotProd_16s16sc_Sfs:=getProc(hh,'ippsDotProd_16s16sc_Sfs');
  ippsDotProd_16s64s:=getProc(hh,'ippsDotProd_16s64s');
  ippsDotProd_16sc64sc:=getProc(hh,'ippsDotProd_16sc64sc');
  ippsDotProd_16s16sc64sc:=getProc(hh,'ippsDotProd_16s16sc64sc');
  ippsDotProd_16s32f:=getProc(hh,'ippsDotProd_16s32f');
  ippsDotProd_16sc32fc:=getProc(hh,'ippsDotProd_16sc32fc');
  ippsDotProd_16s16sc32fc:=getProc(hh,'ippsDotProd_16s16sc32fc');
  ippsDotProd_32f64f:=getProc(hh,'ippsDotProd_32f64f');
  ippsDotProd_32fc64fc:=getProc(hh,'ippsDotProd_32fc64fc');
  ippsDotProd_32f32fc64fc:=getProc(hh,'ippsDotProd_32f32fc64fc');
  ippsDotProd_16s32s_Sfs:=getProc(hh,'ippsDotProd_16s32s_Sfs');
  ippsDotProd_16sc32sc_Sfs:=getProc(hh,'ippsDotProd_16sc32sc_Sfs');
  ippsDotProd_16s16sc32sc_Sfs:=getProc(hh,'ippsDotProd_16s16sc32sc_Sfs');
  ippsDotProd_32s_Sfs:=getProc(hh,'ippsDotProd_32s_Sfs');
  ippsDotProd_32sc_Sfs:=getProc(hh,'ippsDotProd_32sc_Sfs');
  ippsDotProd_32s32sc_Sfs:=getProc(hh,'ippsDotProd_32s32sc_Sfs');
  ippsDotProd_16s32s32s_Sfs:=getProc(hh,'ippsDotProd_16s32s32s_Sfs');
  ippsPowerSpectr_64fc:=getProc(hh,'ippsPowerSpectr_64fc');
  ippsPowerSpectr_32fc:=getProc(hh,'ippsPowerSpectr_32fc');
  ippsPowerSpectr_16sc_Sfs:=getProc(hh,'ippsPowerSpectr_16sc_Sfs');
  ippsPowerSpectr_16sc32f:=getProc(hh,'ippsPowerSpectr_16sc32f');
  ippsPowerSpectr_64f:=getProc(hh,'ippsPowerSpectr_64f');
  ippsPowerSpectr_32f:=getProc(hh,'ippsPowerSpectr_32f');
  ippsPowerSpectr_16s_Sfs:=getProc(hh,'ippsPowerSpectr_16s_Sfs');
  ippsPowerSpectr_16s32f:=getProc(hh,'ippsPowerSpectr_16s32f');
  ippsNormalize_64fc:=getProc(hh,'ippsNormalize_64fc');
  ippsNormalize_32fc:=getProc(hh,'ippsNormalize_32fc');
  ippsNormalize_16sc_Sfs:=getProc(hh,'ippsNormalize_16sc_Sfs');
  ippsNormalize_64f:=getProc(hh,'ippsNormalize_64f');
  ippsNormalize_32f:=getProc(hh,'ippsNormalize_32f');
  ippsNormalize_16s_Sfs:=getProc(hh,'ippsNormalize_16s_Sfs');
  ippsFFTInitAlloc_C_16sc:=getProc(hh,'ippsFFTInitAlloc_C_16sc');
  ippsFFTInitAlloc_C_16s:=getProc(hh,'ippsFFTInitAlloc_C_16s');
  ippsFFTInitAlloc_R_16s:=getProc(hh,'ippsFFTInitAlloc_R_16s');
  ippsFFTInitAlloc_C_32fc:=getProc(hh,'ippsFFTInitAlloc_C_32fc');
  ippsFFTInitAlloc_C_32f:=getProc(hh,'ippsFFTInitAlloc_C_32f');
  ippsFFTInitAlloc_R_32f:=getProc(hh,'ippsFFTInitAlloc_R_32f');
  ippsFFTInitAlloc_C_64fc:=getProc(hh,'ippsFFTInitAlloc_C_64fc');
  ippsFFTInitAlloc_C_64f:=getProc(hh,'ippsFFTInitAlloc_C_64f');
  ippsFFTInitAlloc_R_64f:=getProc(hh,'ippsFFTInitAlloc_R_64f');
  ippsFFTFree_C_16sc:=getProc(hh,'ippsFFTFree_C_16sc');
  ippsFFTFree_C_16s:=getProc(hh,'ippsFFTFree_C_16s');
  ippsFFTFree_R_16s:=getProc(hh,'ippsFFTFree_R_16s');
  ippsFFTFree_C_32fc:=getProc(hh,'ippsFFTFree_C_32fc');
  ippsFFTFree_C_32f:=getProc(hh,'ippsFFTFree_C_32f');
  ippsFFTFree_R_32f:=getProc(hh,'ippsFFTFree_R_32f');
  ippsFFTFree_C_64fc:=getProc(hh,'ippsFFTFree_C_64fc');
  ippsFFTFree_C_64f:=getProc(hh,'ippsFFTFree_C_64f');
  ippsFFTFree_R_64f:=getProc(hh,'ippsFFTFree_R_64f');
  ippsFFTGetBufSize_C_16sc:=getProc(hh,'ippsFFTGetBufSize_C_16sc');
  ippsFFTGetBufSize_C_16s:=getProc(hh,'ippsFFTGetBufSize_C_16s');
  ippsFFTGetBufSize_R_16s:=getProc(hh,'ippsFFTGetBufSize_R_16s');
  ippsFFTGetBufSize_C_32fc:=getProc(hh,'ippsFFTGetBufSize_C_32fc');
  ippsFFTGetBufSize_C_32f:=getProc(hh,'ippsFFTGetBufSize_C_32f');
  ippsFFTGetBufSize_R_32f:=getProc(hh,'ippsFFTGetBufSize_R_32f');
  ippsFFTGetBufSize_C_64fc:=getProc(hh,'ippsFFTGetBufSize_C_64fc');
  ippsFFTGetBufSize_C_64f:=getProc(hh,'ippsFFTGetBufSize_C_64f');
  ippsFFTGetBufSize_R_64f:=getProc(hh,'ippsFFTGetBufSize_R_64f');
  ippsFFTFwd_CToC_16sc_Sfs:=getProc(hh,'ippsFFTFwd_CToC_16sc_Sfs');
  ippsFFTInv_CToC_16sc_Sfs:=getProc(hh,'ippsFFTInv_CToC_16sc_Sfs');
  ippsFFTFwd_CToC_16s_Sfs:=getProc(hh,'ippsFFTFwd_CToC_16s_Sfs');
  ippsFFTInv_CToC_16s_Sfs:=getProc(hh,'ippsFFTInv_CToC_16s_Sfs');
  ippsFFTFwd_CToC_32fc:=getProc(hh,'ippsFFTFwd_CToC_32fc');
  ippsFFTInv_CToC_32fc:=getProc(hh,'ippsFFTInv_CToC_32fc');
  ippsFFTFwd_CToC_32f:=getProc(hh,'ippsFFTFwd_CToC_32f');
  ippsFFTInv_CToC_32f:=getProc(hh,'ippsFFTInv_CToC_32f');
  ippsFFTFwd_CToC_64fc:=getProc(hh,'ippsFFTFwd_CToC_64fc');
  ippsFFTInv_CToC_64fc:=getProc(hh,'ippsFFTInv_CToC_64fc');
  ippsFFTFwd_CToC_64f:=getProc(hh,'ippsFFTFwd_CToC_64f');
  ippsFFTInv_CToC_64f:=getProc(hh,'ippsFFTInv_CToC_64f');
  ippsFFTFwd_RToPerm_16s_Sfs:=getProc(hh,'ippsFFTFwd_RToPerm_16s_Sfs');
  ippsFFTFwd_RToPack_16s_Sfs:=getProc(hh,'ippsFFTFwd_RToPack_16s_Sfs');
  ippsFFTFwd_RToCCS_16s_Sfs:=getProc(hh,'ippsFFTFwd_RToCCS_16s_Sfs');
  ippsFFTInv_PermToR_16s_Sfs:=getProc(hh,'ippsFFTInv_PermToR_16s_Sfs');
  ippsFFTInv_PackToR_16s_Sfs:=getProc(hh,'ippsFFTInv_PackToR_16s_Sfs');
  ippsFFTInv_CCSToR_16s_Sfs:=getProc(hh,'ippsFFTInv_CCSToR_16s_Sfs');
  ippsFFTFwd_RToPerm_32f:=getProc(hh,'ippsFFTFwd_RToPerm_32f');
  ippsFFTFwd_RToPack_32f:=getProc(hh,'ippsFFTFwd_RToPack_32f');
  ippsFFTFwd_RToCCS_32f:=getProc(hh,'ippsFFTFwd_RToCCS_32f');
  ippsFFTInv_PermToR_32f:=getProc(hh,'ippsFFTInv_PermToR_32f');
  ippsFFTInv_PackToR_32f:=getProc(hh,'ippsFFTInv_PackToR_32f');
  ippsFFTInv_CCSToR_32f:=getProc(hh,'ippsFFTInv_CCSToR_32f');
  ippsFFTFwd_RToPerm_64f:=getProc(hh,'ippsFFTFwd_RToPerm_64f');
  ippsFFTFwd_RToPack_64f:=getProc(hh,'ippsFFTFwd_RToPack_64f');
  ippsFFTFwd_RToCCS_64f:=getProc(hh,'ippsFFTFwd_RToCCS_64f');
  ippsFFTInv_PermToR_64f:=getProc(hh,'ippsFFTInv_PermToR_64f');
  ippsFFTInv_PackToR_64f:=getProc(hh,'ippsFFTInv_PackToR_64f');
  ippsFFTInv_CCSToR_64f:=getProc(hh,'ippsFFTInv_CCSToR_64f');
  ippsDFTInitAlloc_C_16sc:=getProc(hh,'ippsDFTInitAlloc_C_16sc');
  ippsDFTInitAlloc_C_16s:=getProc(hh,'ippsDFTInitAlloc_C_16s');
  ippsDFTInitAlloc_R_16s:=getProc(hh,'ippsDFTInitAlloc_R_16s');
  ippsDFTInitAlloc_C_32fc:=getProc(hh,'ippsDFTInitAlloc_C_32fc');
  ippsDFTInitAlloc_C_32f:=getProc(hh,'ippsDFTInitAlloc_C_32f');
  ippsDFTInitAlloc_R_32f:=getProc(hh,'ippsDFTInitAlloc_R_32f');
  ippsDFTInitAlloc_C_64fc:=getProc(hh,'ippsDFTInitAlloc_C_64fc');
  ippsDFTInitAlloc_C_64f:=getProc(hh,'ippsDFTInitAlloc_C_64f');
  ippsDFTInitAlloc_R_64f:=getProc(hh,'ippsDFTInitAlloc_R_64f');
  ippsDFTOutOrdInitAlloc_C_32fc:=getProc(hh,'ippsDFTOutOrdInitAlloc_C_32fc');
  ippsDFTOutOrdInitAlloc_C_64fc:=getProc(hh,'ippsDFTOutOrdInitAlloc_C_64fc');
  ippsDFTFree_C_16sc:=getProc(hh,'ippsDFTFree_C_16sc');
  ippsDFTFree_C_16s:=getProc(hh,'ippsDFTFree_C_16s');
  ippsDFTFree_R_16s:=getProc(hh,'ippsDFTFree_R_16s');
  ippsDFTFree_C_32fc:=getProc(hh,'ippsDFTFree_C_32fc');
  ippsDFTFree_C_32f:=getProc(hh,'ippsDFTFree_C_32f');
  ippsDFTFree_R_32f:=getProc(hh,'ippsDFTFree_R_32f');
  ippsDFTFree_C_64fc:=getProc(hh,'ippsDFTFree_C_64fc');
  ippsDFTFree_C_64f:=getProc(hh,'ippsDFTFree_C_64f');
  ippsDFTFree_R_64f:=getProc(hh,'ippsDFTFree_R_64f');
  ippsDFTOutOrdFree_C_32fc:=getProc(hh,'ippsDFTOutOrdFree_C_32fc');
  ippsDFTOutOrdFree_C_64fc:=getProc(hh,'ippsDFTOutOrdFree_C_64fc');
  ippsDFTGetBufSize_C_16sc:=getProc(hh,'ippsDFTGetBufSize_C_16sc');
  ippsDFTGetBufSize_C_16s:=getProc(hh,'ippsDFTGetBufSize_C_16s');
  ippsDFTGetBufSize_R_16s:=getProc(hh,'ippsDFTGetBufSize_R_16s');
  ippsDFTGetBufSize_C_32fc:=getProc(hh,'ippsDFTGetBufSize_C_32fc');
  ippsDFTGetBufSize_C_32f:=getProc(hh,'ippsDFTGetBufSize_C_32f');
  ippsDFTGetBufSize_R_32f:=getProc(hh,'ippsDFTGetBufSize_R_32f');
  ippsDFTGetBufSize_C_64fc:=getProc(hh,'ippsDFTGetBufSize_C_64fc');
  ippsDFTGetBufSize_C_64f:=getProc(hh,'ippsDFTGetBufSize_C_64f');
  ippsDFTGetBufSize_R_64f:=getProc(hh,'ippsDFTGetBufSize_R_64f');
  ippsDFTOutOrdGetBufSize_C_32fc:=getProc(hh,'ippsDFTOutOrdGetBufSize_C_32fc');
  ippsDFTOutOrdGetBufSize_C_64fc:=getProc(hh,'ippsDFTOutOrdGetBufSize_C_64fc');
  ippsDFTFwd_CToC_16sc_Sfs:=getProc(hh,'ippsDFTFwd_CToC_16sc_Sfs');
  ippsDFTInv_CToC_16sc_Sfs:=getProc(hh,'ippsDFTInv_CToC_16sc_Sfs');
  ippsDFTFwd_CToC_16s_Sfs:=getProc(hh,'ippsDFTFwd_CToC_16s_Sfs');
  ippsDFTInv_CToC_16s_Sfs:=getProc(hh,'ippsDFTInv_CToC_16s_Sfs');
  ippsDFTFwd_CToC_32fc:=getProc(hh,'ippsDFTFwd_CToC_32fc');
  ippsDFTInv_CToC_32fc:=getProc(hh,'ippsDFTInv_CToC_32fc');
  ippsDFTFwd_CToC_32f:=getProc(hh,'ippsDFTFwd_CToC_32f');
  ippsDFTInv_CToC_32f:=getProc(hh,'ippsDFTInv_CToC_32f');
  ippsDFTFwd_CToC_64fc:=getProc(hh,'ippsDFTFwd_CToC_64fc');
  ippsDFTInv_CToC_64fc:=getProc(hh,'ippsDFTInv_CToC_64fc');
  ippsDFTFwd_CToC_64f:=getProc(hh,'ippsDFTFwd_CToC_64f');
  ippsDFTInv_CToC_64f:=getProc(hh,'ippsDFTInv_CToC_64f');
  ippsDFTOutOrdFwd_CToC_32fc:=getProc(hh,'ippsDFTOutOrdFwd_CToC_32fc');
  ippsDFTOutOrdInv_CToC_32fc:=getProc(hh,'ippsDFTOutOrdInv_CToC_32fc');
  ippsDFTOutOrdFwd_CToC_64fc:=getProc(hh,'ippsDFTOutOrdFwd_CToC_64fc');
  ippsDFTOutOrdInv_CToC_64fc:=getProc(hh,'ippsDFTOutOrdInv_CToC_64fc');
  ippsDFTFwd_RToPerm_16s_Sfs:=getProc(hh,'ippsDFTFwd_RToPerm_16s_Sfs');
  ippsDFTFwd_RToPack_16s_Sfs:=getProc(hh,'ippsDFTFwd_RToPack_16s_Sfs');
  ippsDFTFwd_RToCCS_16s_Sfs:=getProc(hh,'ippsDFTFwd_RToCCS_16s_Sfs');
  ippsDFTInv_PermToR_16s_Sfs:=getProc(hh,'ippsDFTInv_PermToR_16s_Sfs');
  ippsDFTInv_PackToR_16s_Sfs:=getProc(hh,'ippsDFTInv_PackToR_16s_Sfs');
  ippsDFTInv_CCSToR_16s_Sfs:=getProc(hh,'ippsDFTInv_CCSToR_16s_Sfs');
  ippsDFTFwd_RToPerm_32f:=getProc(hh,'ippsDFTFwd_RToPerm_32f');
  ippsDFTFwd_RToPack_32f:=getProc(hh,'ippsDFTFwd_RToPack_32f');
  ippsDFTFwd_RToCCS_32f:=getProc(hh,'ippsDFTFwd_RToCCS_32f');
  ippsDFTInv_PermToR_32f:=getProc(hh,'ippsDFTInv_PermToR_32f');
  ippsDFTInv_PackToR_32f:=getProc(hh,'ippsDFTInv_PackToR_32f');
  ippsDFTInv_CCSToR_32f:=getProc(hh,'ippsDFTInv_CCSToR_32f');
  ippsDFTFwd_RToPerm_64f:=getProc(hh,'ippsDFTFwd_RToPerm_64f');
  ippsDFTFwd_RToPack_64f:=getProc(hh,'ippsDFTFwd_RToPack_64f');
  ippsDFTFwd_RToCCS_64f:=getProc(hh,'ippsDFTFwd_RToCCS_64f');
  ippsDFTInv_PermToR_64f:=getProc(hh,'ippsDFTInv_PermToR_64f');
  ippsDFTInv_PackToR_64f:=getProc(hh,'ippsDFTInv_PackToR_64f');
  ippsDFTInv_CCSToR_64f:=getProc(hh,'ippsDFTInv_CCSToR_64f');
  ippsMulPack_16s_ISfs:=getProc(hh,'ippsMulPack_16s_ISfs');
  ippsMulPerm_16s_ISfs:=getProc(hh,'ippsMulPerm_16s_ISfs');
  ippsMulPack_32f_I:=getProc(hh,'ippsMulPack_32f_I');
  ippsMulPerm_32f_I:=getProc(hh,'ippsMulPerm_32f_I');
  ippsMulPack_64f_I:=getProc(hh,'ippsMulPack_64f_I');
  ippsMulPerm_64f_I:=getProc(hh,'ippsMulPerm_64f_I');
  ippsMulPack_16s_Sfs:=getProc(hh,'ippsMulPack_16s_Sfs');
  ippsMulPerm_16s_Sfs:=getProc(hh,'ippsMulPerm_16s_Sfs');
  ippsMulPack_32f:=getProc(hh,'ippsMulPack_32f');
  ippsMulPerm_32f:=getProc(hh,'ippsMulPerm_32f');
  ippsMulPack_64f:=getProc(hh,'ippsMulPack_64f');
  ippsMulPerm_64f:=getProc(hh,'ippsMulPerm_64f');
  ippsMulPackConj_32f_I:=getProc(hh,'ippsMulPackConj_32f_I');
  ippsMulPackConj_64f_I:=getProc(hh,'ippsMulPackConj_64f_I');
  ippsGoertz_32fc:=getProc(hh,'ippsGoertz_32fc');
  ippsGoertz_64fc:=getProc(hh,'ippsGoertz_64fc');
  ippsGoertz_16sc_Sfs:=getProc(hh,'ippsGoertz_16sc_Sfs');
  ippsGoertz_32f:=getProc(hh,'ippsGoertz_32f');
  ippsGoertz_16s_Sfs:=getProc(hh,'ippsGoertz_16s_Sfs');
  ippsGoertzTwo_32fc:=getProc(hh,'ippsGoertzTwo_32fc');
  ippsGoertzTwo_64fc:=getProc(hh,'ippsGoertzTwo_64fc');
  ippsGoertzTwo_16sc_Sfs:=getProc(hh,'ippsGoertzTwo_16sc_Sfs');
  ippsDCTFwdInitAlloc_16s:=getProc(hh,'ippsDCTFwdInitAlloc_16s');
  ippsDCTInvInitAlloc_16s:=getProc(hh,'ippsDCTInvInitAlloc_16s');
  ippsDCTFwdInitAlloc_32f:=getProc(hh,'ippsDCTFwdInitAlloc_32f');
  ippsDCTInvInitAlloc_32f:=getProc(hh,'ippsDCTInvInitAlloc_32f');
  ippsDCTFwdInitAlloc_64f:=getProc(hh,'ippsDCTFwdInitAlloc_64f');
  ippsDCTInvInitAlloc_64f:=getProc(hh,'ippsDCTInvInitAlloc_64f');
  ippsDCTFwdFree_16s:=getProc(hh,'ippsDCTFwdFree_16s');
  ippsDCTInvFree_16s:=getProc(hh,'ippsDCTInvFree_16s');
  ippsDCTFwdFree_32f:=getProc(hh,'ippsDCTFwdFree_32f');
  ippsDCTInvFree_32f:=getProc(hh,'ippsDCTInvFree_32f');
  ippsDCTFwdFree_64f:=getProc(hh,'ippsDCTFwdFree_64f');
  ippsDCTInvFree_64f:=getProc(hh,'ippsDCTInvFree_64f');
  ippsDCTFwdGetBufSize_16s:=getProc(hh,'ippsDCTFwdGetBufSize_16s');
  ippsDCTInvGetBufSize_16s:=getProc(hh,'ippsDCTInvGetBufSize_16s');
  ippsDCTFwdGetBufSize_32f:=getProc(hh,'ippsDCTFwdGetBufSize_32f');
  ippsDCTInvGetBufSize_32f:=getProc(hh,'ippsDCTInvGetBufSize_32f');
  ippsDCTFwdGetBufSize_64f:=getProc(hh,'ippsDCTFwdGetBufSize_64f');
  ippsDCTInvGetBufSize_64f:=getProc(hh,'ippsDCTInvGetBufSize_64f');
  ippsDCTFwd_16s_Sfs:=getProc(hh,'ippsDCTFwd_16s_Sfs');
  ippsDCTInv_16s_Sfs:=getProc(hh,'ippsDCTInv_16s_Sfs');
  ippsDCTFwd_32f:=getProc(hh,'ippsDCTFwd_32f');
  ippsDCTInv_32f:=getProc(hh,'ippsDCTInv_32f');
  ippsDCTFwd_64f:=getProc(hh,'ippsDCTFwd_64f');
  ippsDCTInv_64f:=getProc(hh,'ippsDCTInv_64f');
  ippsWTHaarFwd_8s:=getProc(hh,'ippsWTHaarFwd_8s');
  ippsWTHaarFwd_16s:=getProc(hh,'ippsWTHaarFwd_16s');
  ippsWTHaarFwd_32s:=getProc(hh,'ippsWTHaarFwd_32s');
  ippsWTHaarFwd_64s:=getProc(hh,'ippsWTHaarFwd_64s');
  ippsWTHaarFwd_32f:=getProc(hh,'ippsWTHaarFwd_32f');
  ippsWTHaarFwd_64f:=getProc(hh,'ippsWTHaarFwd_64f');
  ippsWTHaarFwd_8s_Sfs:=getProc(hh,'ippsWTHaarFwd_8s_Sfs');
  ippsWTHaarFwd_16s_Sfs:=getProc(hh,'ippsWTHaarFwd_16s_Sfs');
  ippsWTHaarFwd_32s_Sfs:=getProc(hh,'ippsWTHaarFwd_32s_Sfs');
  ippsWTHaarFwd_64s_Sfs:=getProc(hh,'ippsWTHaarFwd_64s_Sfs');
  ippsWTHaarInv_8s:=getProc(hh,'ippsWTHaarInv_8s');
  ippsWTHaarInv_16s:=getProc(hh,'ippsWTHaarInv_16s');
  ippsWTHaarInv_32s:=getProc(hh,'ippsWTHaarInv_32s');
  ippsWTHaarInv_64s:=getProc(hh,'ippsWTHaarInv_64s');
  ippsWTHaarInv_32f:=getProc(hh,'ippsWTHaarInv_32f');
  ippsWTHaarInv_64f:=getProc(hh,'ippsWTHaarInv_64f');
  ippsWTHaarInv_8s_Sfs:=getProc(hh,'ippsWTHaarInv_8s_Sfs');
  ippsWTHaarInv_16s_Sfs:=getProc(hh,'ippsWTHaarInv_16s_Sfs');
  ippsWTHaarInv_32s_Sfs:=getProc(hh,'ippsWTHaarInv_32s_Sfs');
  ippsWTHaarInv_64s_Sfs:=getProc(hh,'ippsWTHaarInv_64s_Sfs');
  ippsWTFwdInitAlloc_32f:=getProc(hh,'ippsWTFwdInitAlloc_32f');
  ippsWTFwdInitAlloc_8s32f:=getProc(hh,'ippsWTFwdInitAlloc_8s32f');
  ippsWTFwdInitAlloc_8u32f:=getProc(hh,'ippsWTFwdInitAlloc_8u32f');
  ippsWTFwdInitAlloc_16s32f:=getProc(hh,'ippsWTFwdInitAlloc_16s32f');
  ippsWTFwdInitAlloc_16u32f:=getProc(hh,'ippsWTFwdInitAlloc_16u32f');
  ippsWTFwdSetDlyLine_32f:=getProc(hh,'ippsWTFwdSetDlyLine_32f');
  ippsWTFwdSetDlyLine_8s32f:=getProc(hh,'ippsWTFwdSetDlyLine_8s32f');
  ippsWTFwdSetDlyLine_8u32f:=getProc(hh,'ippsWTFwdSetDlyLine_8u32f');
  ippsWTFwdSetDlyLine_16s32f:=getProc(hh,'ippsWTFwdSetDlyLine_16s32f');
  ippsWTFwdSetDlyLine_16u32f:=getProc(hh,'ippsWTFwdSetDlyLine_16u32f');
  ippsWTFwdGetDlyLine_32f:=getProc(hh,'ippsWTFwdGetDlyLine_32f');
  ippsWTFwdGetDlyLine_8s32f:=getProc(hh,'ippsWTFwdGetDlyLine_8s32f');
  ippsWTFwdGetDlyLine_8u32f:=getProc(hh,'ippsWTFwdGetDlyLine_8u32f');
  ippsWTFwdGetDlyLine_16s32f:=getProc(hh,'ippsWTFwdGetDlyLine_16s32f');
  ippsWTFwdGetDlyLine_16u32f:=getProc(hh,'ippsWTFwdGetDlyLine_16u32f');
  ippsWTFwd_32f:=getProc(hh,'ippsWTFwd_32f');
  ippsWTFwd_8s32f:=getProc(hh,'ippsWTFwd_8s32f');
  ippsWTFwd_8u32f:=getProc(hh,'ippsWTFwd_8u32f');
  ippsWTFwd_16s32f:=getProc(hh,'ippsWTFwd_16s32f');
  ippsWTFwd_16u32f:=getProc(hh,'ippsWTFwd_16u32f');
  ippsWTFwdFree_32f:=getProc(hh,'ippsWTFwdFree_32f');
  ippsWTFwdFree_8s32f:=getProc(hh,'ippsWTFwdFree_8s32f');
  ippsWTFwdFree_8u32f:=getProc(hh,'ippsWTFwdFree_8u32f');
  ippsWTFwdFree_16s32f:=getProc(hh,'ippsWTFwdFree_16s32f');
  ippsWTFwdFree_16u32f:=getProc(hh,'ippsWTFwdFree_16u32f');
  ippsWTInvInitAlloc_32f:=getProc(hh,'ippsWTInvInitAlloc_32f');
  ippsWTInvInitAlloc_32f8s:=getProc(hh,'ippsWTInvInitAlloc_32f8s');
  ippsWTInvInitAlloc_32f8u:=getProc(hh,'ippsWTInvInitAlloc_32f8u');
  ippsWTInvInitAlloc_32f16s:=getProc(hh,'ippsWTInvInitAlloc_32f16s');
  ippsWTInvInitAlloc_32f16u:=getProc(hh,'ippsWTInvInitAlloc_32f16u');
  ippsWTInvSetDlyLine_32f:=getProc(hh,'ippsWTInvSetDlyLine_32f');
  ippsWTInvSetDlyLine_32f8s:=getProc(hh,'ippsWTInvSetDlyLine_32f8s');
  ippsWTInvSetDlyLine_32f8u:=getProc(hh,'ippsWTInvSetDlyLine_32f8u');
  ippsWTInvSetDlyLine_32f16s:=getProc(hh,'ippsWTInvSetDlyLine_32f16s');
  ippsWTInvSetDlyLine_32f16u:=getProc(hh,'ippsWTInvSetDlyLine_32f16u');
  ippsWTInvGetDlyLine_32f:=getProc(hh,'ippsWTInvGetDlyLine_32f');
  ippsWTInvGetDlyLine_32f8s:=getProc(hh,'ippsWTInvGetDlyLine_32f8s');
  ippsWTInvGetDlyLine_32f8u:=getProc(hh,'ippsWTInvGetDlyLine_32f8u');
  ippsWTInvGetDlyLine_32f16s:=getProc(hh,'ippsWTInvGetDlyLine_32f16s');
  ippsWTInvGetDlyLine_32f16u:=getProc(hh,'ippsWTInvGetDlyLine_32f16u');
  ippsWTInv_32f:=getProc(hh,'ippsWTInv_32f');
  ippsWTInv_32f8s:=getProc(hh,'ippsWTInv_32f8s');
  ippsWTInv_32f8u:=getProc(hh,'ippsWTInv_32f8u');
  ippsWTInv_32f16s:=getProc(hh,'ippsWTInv_32f16s');
  ippsWTInv_32f16u:=getProc(hh,'ippsWTInv_32f16u');
  ippsWTInvFree_32f:=getProc(hh,'ippsWTInvFree_32f');
  ippsWTInvFree_32f8s:=getProc(hh,'ippsWTInvFree_32f8s');
  ippsWTInvFree_32f8u:=getProc(hh,'ippsWTInvFree_32f8u');
  ippsWTInvFree_32f16s:=getProc(hh,'ippsWTInvFree_32f16s');
  ippsWTInvFree_32f16u:=getProc(hh,'ippsWTInvFree_32f16u');
  ippsConv_32f:=getProc(hh,'ippsConv_32f');
  ippsConv_16s_Sfs:=getProc(hh,'ippsConv_16s_Sfs');
  ippsConv_64f:=getProc(hh,'ippsConv_64f');
  ippsConvCyclic8x8_32f:=getProc(hh,'ippsConvCyclic8x8_32f');
  ippsConvCyclic8x8_16s_Sfs:=getProc(hh,'ippsConvCyclic8x8_16s_Sfs');
  ippsConvCyclic4x4_32f32fc:=getProc(hh,'ippsConvCyclic4x4_32f32fc');
  ippsIIRInitAlloc_32f:=getProc(hh,'ippsIIRInitAlloc_32f');
  ippsIIRInitAlloc_32fc:=getProc(hh,'ippsIIRInitAlloc_32fc');
  ippsIIRInitAlloc32f_16s:=getProc(hh,'ippsIIRInitAlloc32f_16s');
  ippsIIRInitAlloc32fc_16sc:=getProc(hh,'ippsIIRInitAlloc32fc_16sc');
  ippsIIRInitAlloc_64f:=getProc(hh,'ippsIIRInitAlloc_64f');
  ippsIIRInitAlloc_64fc:=getProc(hh,'ippsIIRInitAlloc_64fc');
  ippsIIRInitAlloc64f_32f:=getProc(hh,'ippsIIRInitAlloc64f_32f');
  ippsIIRInitAlloc64fc_32fc:=getProc(hh,'ippsIIRInitAlloc64fc_32fc');
  ippsIIRInitAlloc64f_32s:=getProc(hh,'ippsIIRInitAlloc64f_32s');
  ippsIIRInitAlloc64fc_32sc:=getProc(hh,'ippsIIRInitAlloc64fc_32sc');
  ippsIIRInitAlloc64f_16s:=getProc(hh,'ippsIIRInitAlloc64f_16s');
  ippsIIRInitAlloc64fc_16sc:=getProc(hh,'ippsIIRInitAlloc64fc_16sc');
  ippsIIRFree_32f:=getProc(hh,'ippsIIRFree_32f');
  ippsIIRFree_32fc:=getProc(hh,'ippsIIRFree_32fc');
  ippsIIRFree32f_16s:=getProc(hh,'ippsIIRFree32f_16s');
  ippsIIRFree32fc_16sc:=getProc(hh,'ippsIIRFree32fc_16sc');
  ippsIIRFree_64f:=getProc(hh,'ippsIIRFree_64f');
  ippsIIRFree_64fc:=getProc(hh,'ippsIIRFree_64fc');
  ippsIIRFree64f_32f:=getProc(hh,'ippsIIRFree64f_32f');
  ippsIIRFree64fc_32fc:=getProc(hh,'ippsIIRFree64fc_32fc');
  ippsIIRFree64f_32s:=getProc(hh,'ippsIIRFree64f_32s');
  ippsIIRFree64fc_32sc:=getProc(hh,'ippsIIRFree64fc_32sc');
  ippsIIRFree64f_16s:=getProc(hh,'ippsIIRFree64f_16s');
  ippsIIRFree64fc_16sc:=getProc(hh,'ippsIIRFree64fc_16sc');
  ippsIIRInitAlloc_BiQuad_32f:=getProc(hh,'ippsIIRInitAlloc_BiQuad_32f');
  ippsIIRInitAlloc_BiQuad_32fc:=getProc(hh,'ippsIIRInitAlloc_BiQuad_32fc');
  ippsIIRInitAlloc32f_BiQuad_16s:=getProc(hh,'ippsIIRInitAlloc32f_BiQuad_16s');
  ippsIIRInitAlloc32fc_BiQuad_16sc:=getProc(hh,'ippsIIRInitAlloc32fc_BiQuad_16sc');
  ippsIIRInitAlloc_BiQuad_64f:=getProc(hh,'ippsIIRInitAlloc_BiQuad_64f');
  ippsIIRInitAlloc_BiQuad_64fc:=getProc(hh,'ippsIIRInitAlloc_BiQuad_64fc');
  ippsIIRInitAlloc64f_BiQuad_32f:=getProc(hh,'ippsIIRInitAlloc64f_BiQuad_32f');
  ippsIIRInitAlloc64fc_BiQuad_32fc:=getProc(hh,'ippsIIRInitAlloc64fc_BiQuad_32fc');
  ippsIIRInitAlloc64f_BiQuad_32s:=getProc(hh,'ippsIIRInitAlloc64f_BiQuad_32s');
  ippsIIRInitAlloc64fc_BiQuad_32sc:=getProc(hh,'ippsIIRInitAlloc64fc_BiQuad_32sc');
  ippsIIRInitAlloc64f_BiQuad_16s:=getProc(hh,'ippsIIRInitAlloc64f_BiQuad_16s');
  ippsIIRInitAlloc64fc_BiQuad_16sc:=getProc(hh,'ippsIIRInitAlloc64fc_BiQuad_16sc');
  ippsIIRGetDlyLine_32f:=getProc(hh,'ippsIIRGetDlyLine_32f');
  ippsIIRSetDlyLine_32f:=getProc(hh,'ippsIIRSetDlyLine_32f');
  ippsIIRGetDlyLine_32fc:=getProc(hh,'ippsIIRGetDlyLine_32fc');
  ippsIIRSetDlyLine_32fc:=getProc(hh,'ippsIIRSetDlyLine_32fc');
  ippsIIRGetDlyLine32f_16s:=getProc(hh,'ippsIIRGetDlyLine32f_16s');
  ippsIIRSetDlyLine32f_16s:=getProc(hh,'ippsIIRSetDlyLine32f_16s');
  ippsIIRGetDlyLine32fc_16sc:=getProc(hh,'ippsIIRGetDlyLine32fc_16sc');
  ippsIIRSetDlyLine32fc_16sc:=getProc(hh,'ippsIIRSetDlyLine32fc_16sc');
  ippsIIRGetDlyLine_64f:=getProc(hh,'ippsIIRGetDlyLine_64f');
  ippsIIRSetDlyLine_64f:=getProc(hh,'ippsIIRSetDlyLine_64f');
  ippsIIRGetDlyLine_64fc:=getProc(hh,'ippsIIRGetDlyLine_64fc');
  ippsIIRSetDlyLine_64fc:=getProc(hh,'ippsIIRSetDlyLine_64fc');
  ippsIIRGetDlyLine64f_32f:=getProc(hh,'ippsIIRGetDlyLine64f_32f');
  ippsIIRSetDlyLine64f_32f:=getProc(hh,'ippsIIRSetDlyLine64f_32f');
  ippsIIRGetDlyLine64fc_32fc:=getProc(hh,'ippsIIRGetDlyLine64fc_32fc');
  ippsIIRSetDlyLine64fc_32fc:=getProc(hh,'ippsIIRSetDlyLine64fc_32fc');
  ippsIIRGetDlyLine64f_32s:=getProc(hh,'ippsIIRGetDlyLine64f_32s');
  ippsIIRSetDlyLine64f_32s:=getProc(hh,'ippsIIRSetDlyLine64f_32s');
  ippsIIRGetDlyLine64fc_32sc:=getProc(hh,'ippsIIRGetDlyLine64fc_32sc');
  ippsIIRSetDlyLine64fc_32sc:=getProc(hh,'ippsIIRSetDlyLine64fc_32sc');
  ippsIIRGetDlyLine64f_16s:=getProc(hh,'ippsIIRGetDlyLine64f_16s');
  ippsIIRSetDlyLine64f_16s:=getProc(hh,'ippsIIRSetDlyLine64f_16s');
  ippsIIRGetDlyLine64fc_16sc:=getProc(hh,'ippsIIRGetDlyLine64fc_16sc');
  ippsIIRSetDlyLine64fc_16sc:=getProc(hh,'ippsIIRSetDlyLine64fc_16sc');
  ippsIIROne_32f:=getProc(hh,'ippsIIROne_32f');
  ippsIIROne_32fc:=getProc(hh,'ippsIIROne_32fc');
  ippsIIROne32f_16s_Sfs:=getProc(hh,'ippsIIROne32f_16s_Sfs');
  ippsIIROne32fc_16sc_Sfs:=getProc(hh,'ippsIIROne32fc_16sc_Sfs');
  ippsIIROne_64f:=getProc(hh,'ippsIIROne_64f');
  ippsIIROne_64fc:=getProc(hh,'ippsIIROne_64fc');
  ippsIIROne64f_32f:=getProc(hh,'ippsIIROne64f_32f');
  ippsIIROne64fc_32fc:=getProc(hh,'ippsIIROne64fc_32fc');
  ippsIIROne64f_32s_Sfs:=getProc(hh,'ippsIIROne64f_32s_Sfs');
  ippsIIROne64fc_32sc_Sfs:=getProc(hh,'ippsIIROne64fc_32sc_Sfs');
  ippsIIROne64f_16s_Sfs:=getProc(hh,'ippsIIROne64f_16s_Sfs');
  ippsIIROne64fc_16sc_Sfs:=getProc(hh,'ippsIIROne64fc_16sc_Sfs');
  ippsIIR_32f:=getProc(hh,'ippsIIR_32f');
  ippsIIR_32f_I:=getProc(hh,'ippsIIR_32f_I');
  ippsIIR_32fc:=getProc(hh,'ippsIIR_32fc');
  ippsIIR_32fc_I:=getProc(hh,'ippsIIR_32fc_I');
  ippsIIR32f_16s_Sfs:=getProc(hh,'ippsIIR32f_16s_Sfs');
  ippsIIR32f_16s_ISfs:=getProc(hh,'ippsIIR32f_16s_ISfs');
  ippsIIR32fc_16sc_Sfs:=getProc(hh,'ippsIIR32fc_16sc_Sfs');
  ippsIIR32fc_16sc_ISfs:=getProc(hh,'ippsIIR32fc_16sc_ISfs');
  ippsIIR_64f:=getProc(hh,'ippsIIR_64f');
  ippsIIR_64f_I:=getProc(hh,'ippsIIR_64f_I');
  ippsIIR_64fc:=getProc(hh,'ippsIIR_64fc');
  ippsIIR_64fc_I:=getProc(hh,'ippsIIR_64fc_I');
  ippsIIR64f_32f:=getProc(hh,'ippsIIR64f_32f');
  ippsIIR64f_32f_I:=getProc(hh,'ippsIIR64f_32f_I');
  ippsIIR64fc_32fc:=getProc(hh,'ippsIIR64fc_32fc');
  ippsIIR64fc_32fc_I:=getProc(hh,'ippsIIR64fc_32fc_I');
  ippsIIR64f_32s_Sfs:=getProc(hh,'ippsIIR64f_32s_Sfs');
  ippsIIR64f_32s_ISfs:=getProc(hh,'ippsIIR64f_32s_ISfs');
  ippsIIR64fc_32sc_Sfs:=getProc(hh,'ippsIIR64fc_32sc_Sfs');
  ippsIIR64fc_32sc_ISfs:=getProc(hh,'ippsIIR64fc_32sc_ISfs');
  ippsIIR64f_16s_Sfs:=getProc(hh,'ippsIIR64f_16s_Sfs');
  ippsIIR64f_16s_ISfs:=getProc(hh,'ippsIIR64f_16s_ISfs');
  ippsIIR64fc_16sc_Sfs:=getProc(hh,'ippsIIR64fc_16sc_Sfs');
  ippsIIR64fc_16sc_ISfs:=getProc(hh,'ippsIIR64fc_16sc_ISfs');
  ippsIIRInitAlloc32s_16s:=getProc(hh,'ippsIIRInitAlloc32s_16s');
  ippsIIRInitAlloc32s_16s32f:=getProc(hh,'ippsIIRInitAlloc32s_16s32f');
  ippsIIRInitAlloc32sc_16sc:=getProc(hh,'ippsIIRInitAlloc32sc_16sc');
  ippsIIRInitAlloc32sc_16sc32fc:=getProc(hh,'ippsIIRInitAlloc32sc_16sc32fc');
  ippsIIRInitAlloc32s_BiQuad_16s:=getProc(hh,'ippsIIRInitAlloc32s_BiQuad_16s');
  ippsIIRInitAlloc32s_BiQuad_16s32f:=getProc(hh,'ippsIIRInitAlloc32s_BiQuad_16s32f');
  ippsIIRInitAlloc32sc_BiQuad_16sc:=getProc(hh,'ippsIIRInitAlloc32sc_BiQuad_16sc');
  ippsIIRInitAlloc32sc_BiQuad_16sc32fc:=getProc(hh,'ippsIIRInitAlloc32sc_BiQuad_16sc32fc');
  ippsIIRFree32s_16s:=getProc(hh,'ippsIIRFree32s_16s');
  ippsIIRFree32sc_16sc:=getProc(hh,'ippsIIRFree32sc_16sc');
  ippsIIRGetDlyLine32s_16s:=getProc(hh,'ippsIIRGetDlyLine32s_16s');
  ippsIIRSetDlyLine32s_16s:=getProc(hh,'ippsIIRSetDlyLine32s_16s');
  ippsIIRGetDlyLine32sc_16sc:=getProc(hh,'ippsIIRGetDlyLine32sc_16sc');
  ippsIIRSetDlyLine32sc_16sc:=getProc(hh,'ippsIIRSetDlyLine32sc_16sc');
  ippsIIROne32s_16s_Sfs:=getProc(hh,'ippsIIROne32s_16s_Sfs');
  ippsIIROne32sc_16sc_Sfs:=getProc(hh,'ippsIIROne32sc_16sc_Sfs');
  ippsIIR32s_16s_Sfs:=getProc(hh,'ippsIIR32s_16s_Sfs');
  ippsIIR32sc_16sc_Sfs:=getProc(hh,'ippsIIR32sc_16sc_Sfs');
  ippsIIR32s_16s_ISfs:=getProc(hh,'ippsIIR32s_16s_ISfs');
  ippsIIR32sc_16sc_ISfs:=getProc(hh,'ippsIIR32sc_16sc_ISfs');
  ippsIIR_Direct_16s:=getProc(hh,'ippsIIR_Direct_16s');
  ippsIIR_Direct_16s_I:=getProc(hh,'ippsIIR_Direct_16s_I');
  ippsIIROne_Direct_16s:=getProc(hh,'ippsIIROne_Direct_16s');
  ippsIIROne_Direct_16s_I:=getProc(hh,'ippsIIROne_Direct_16s_I');
  ippsIIR_BiQuadDirect_16s:=getProc(hh,'ippsIIR_BiQuadDirect_16s');
  ippsIIR_BiQuadDirect_16s_I:=getProc(hh,'ippsIIR_BiQuadDirect_16s_I');
  ippsIIROne_BiQuadDirect_16s:=getProc(hh,'ippsIIROne_BiQuadDirect_16s');
  ippsIIROne_BiQuadDirect_16s_I:=getProc(hh,'ippsIIROne_BiQuadDirect_16s_I');
  ippsIIRGetStateSize32s_16s:=getProc(hh,'ippsIIRGetStateSize32s_16s');
  ippsIIRGetStateSize32sc_16sc:=getProc(hh,'ippsIIRGetStateSize32sc_16sc');
  ippsIIRGetStateSize32s_BiQuad_16s:=getProc(hh,'ippsIIRGetStateSize32s_BiQuad_16s');
  ippsIIRGetStateSize32sc_BiQuad_16sc:=getProc(hh,'ippsIIRGetStateSize32sc_BiQuad_16sc');
  ippsIIRInit32s_16s:=getProc(hh,'ippsIIRInit32s_16s');
  ippsIIRInit32sc_16sc:=getProc(hh,'ippsIIRInit32sc_16sc');
  ippsIIRInit32s_BiQuad_16s:=getProc(hh,'ippsIIRInit32s_BiQuad_16s');
  ippsIIRInit32sc_BiQuad_16sc:=getProc(hh,'ippsIIRInit32sc_BiQuad_16sc');
  ippsIIRGetStateSize32s_16s32f:=getProc(hh,'ippsIIRGetStateSize32s_16s32f');
  ippsIIRGetStateSize32sc_16sc32fc:=getProc(hh,'ippsIIRGetStateSize32sc_16sc32fc');
  ippsIIRGetStateSize32s_BiQuad_16s32f:=getProc(hh,'ippsIIRGetStateSize32s_BiQuad_16s32f');
  ippsIIRGetStateSize32sc_BiQuad_16sc32fc:=getProc(hh,'ippsIIRGetStateSize32sc_BiQuad_16sc32fc');
  ippsIIRInit32s_16s32f:=getProc(hh,'ippsIIRInit32s_16s32f');
  ippsIIRInit32sc_16sc32fc:=getProc(hh,'ippsIIRInit32sc_16sc32fc');
  ippsIIRInit32s_BiQuad_16s32f:=getProc(hh,'ippsIIRInit32s_BiQuad_16s32f');
  ippsIIRInit32sc_BiQuad_16sc32fc:=getProc(hh,'ippsIIRInit32sc_BiQuad_16sc32fc');
  ippsIIRGetStateSize_32f:=getProc(hh,'ippsIIRGetStateSize_32f');
  ippsIIRGetStateSize_32fc:=getProc(hh,'ippsIIRGetStateSize_32fc');
  ippsIIRGetStateSize_BiQuad_32f:=getProc(hh,'ippsIIRGetStateSize_BiQuad_32f');
  ippsIIRGetStateSize_BiQuad_32fc:=getProc(hh,'ippsIIRGetStateSize_BiQuad_32fc');
  ippsIIRInit_32f:=getProc(hh,'ippsIIRInit_32f');
  ippsIIRInit_32fc:=getProc(hh,'ippsIIRInit_32fc');
  ippsIIRInit_BiQuad_32f:=getProc(hh,'ippsIIRInit_BiQuad_32f');
  ippsIIRInit_BiQuad_32fc:=getProc(hh,'ippsIIRInit_BiQuad_32fc');
  ippsIIRGetStateSize32f_16s:=getProc(hh,'ippsIIRGetStateSize32f_16s');
  ippsIIRGetStateSize32fc_16sc:=getProc(hh,'ippsIIRGetStateSize32fc_16sc');
  ippsIIRGetStateSize32f_BiQuad_16s:=getProc(hh,'ippsIIRGetStateSize32f_BiQuad_16s');
  ippsIIRGetStateSize32fc_BiQuad_16sc:=getProc(hh,'ippsIIRGetStateSize32fc_BiQuad_16sc');
  ippsIIRInit32f_16s:=getProc(hh,'ippsIIRInit32f_16s');
  ippsIIRInit32fc_16sc:=getProc(hh,'ippsIIRInit32fc_16sc');
  ippsIIRInit32f_BiQuad_16s:=getProc(hh,'ippsIIRInit32f_BiQuad_16s');
  ippsIIRInit32fc_BiQuad_16sc:=getProc(hh,'ippsIIRInit32fc_BiQuad_16sc');
  ippsIIRGetStateSize_64f:=getProc(hh,'ippsIIRGetStateSize_64f');
  ippsIIRGetStateSize_64fc:=getProc(hh,'ippsIIRGetStateSize_64fc');
  ippsIIRGetStateSize_BiQuad_64f:=getProc(hh,'ippsIIRGetStateSize_BiQuad_64f');
  ippsIIRGetStateSize_BiQuad_64fc:=getProc(hh,'ippsIIRGetStateSize_BiQuad_64fc');
  ippsIIRInit_64f:=getProc(hh,'ippsIIRInit_64f');
  ippsIIRInit_64fc:=getProc(hh,'ippsIIRInit_64fc');
  ippsIIRInit_BiQuad_64f:=getProc(hh,'ippsIIRInit_BiQuad_64f');
  ippsIIRInit_BiQuad_64fc:=getProc(hh,'ippsIIRInit_BiQuad_64fc');
  ippsIIRGetStateSize64f_16s:=getProc(hh,'ippsIIRGetStateSize64f_16s');
  ippsIIRGetStateSize64fc_16sc:=getProc(hh,'ippsIIRGetStateSize64fc_16sc');
  ippsIIRGetStateSize64f_BiQuad_16s:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_16s');
  ippsIIRGetStateSize64fc_BiQuad_16sc:=getProc(hh,'ippsIIRGetStateSize64fc_BiQuad_16sc');
  ippsIIRInit64f_16s:=getProc(hh,'ippsIIRInit64f_16s');
  ippsIIRInit64fc_16sc:=getProc(hh,'ippsIIRInit64fc_16sc');
  ippsIIRInit64f_BiQuad_16s:=getProc(hh,'ippsIIRInit64f_BiQuad_16s');
  ippsIIRInit64fc_BiQuad_16sc:=getProc(hh,'ippsIIRInit64fc_BiQuad_16sc');
  ippsIIRGetStateSize64f_32s:=getProc(hh,'ippsIIRGetStateSize64f_32s');
  ippsIIRGetStateSize64fc_32sc:=getProc(hh,'ippsIIRGetStateSize64fc_32sc');
  ippsIIRGetStateSize64f_BiQuad_32s:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_32s');
  ippsIIRGetStateSize64fc_BiQuad_32sc:=getProc(hh,'ippsIIRGetStateSize64fc_BiQuad_32sc');
  ippsIIRInit64f_32s:=getProc(hh,'ippsIIRInit64f_32s');
  ippsIIRInit64fc_32sc:=getProc(hh,'ippsIIRInit64fc_32sc');
  ippsIIRInit64f_BiQuad_32s:=getProc(hh,'ippsIIRInit64f_BiQuad_32s');
  ippsIIRInit64fc_BiQuad_32sc:=getProc(hh,'ippsIIRInit64fc_BiQuad_32sc');
  ippsIIRGetStateSize64f_32f:=getProc(hh,'ippsIIRGetStateSize64f_32f');
  ippsIIRGetStateSize64fc_32fc:=getProc(hh,'ippsIIRGetStateSize64fc_32fc');
  ippsIIRGetStateSize64f_BiQuad_32f:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_32f');
  ippsIIRGetStateSize64fc_BiQuad_32fc:=getProc(hh,'ippsIIRGetStateSize64fc_BiQuad_32fc');
  ippsIIRInit64f_32f:=getProc(hh,'ippsIIRInit64f_32f');
  ippsIIRInit64fc_32fc:=getProc(hh,'ippsIIRInit64fc_32fc');
  ippsIIRInit64f_BiQuad_32f:=getProc(hh,'ippsIIRInit64f_BiQuad_32f');
  ippsIIRInit64fc_BiQuad_32fc:=getProc(hh,'ippsIIRInit64fc_BiQuad_32fc');
  ippsIIRSetTaps_32f:=getProc(hh,'ippsIIRSetTaps_32f');
  ippsIIRSetTaps_32fc:=getProc(hh,'ippsIIRSetTaps_32fc');
  ippsIIRSetTaps32f_16s:=getProc(hh,'ippsIIRSetTaps32f_16s');
  ippsIIRSetTaps32fc_16sc:=getProc(hh,'ippsIIRSetTaps32fc_16sc');
  ippsIIRSetTaps32s_16s:=getProc(hh,'ippsIIRSetTaps32s_16s');
  ippsIIRSetTaps32sc_16sc:=getProc(hh,'ippsIIRSetTaps32sc_16sc');
  ippsIIRSetTaps32s_16s32f:=getProc(hh,'ippsIIRSetTaps32s_16s32f');
  ippsIIRSetTaps32sc_16sc32fc:=getProc(hh,'ippsIIRSetTaps32sc_16sc32fc');
  ippsIIRSetTaps_64f:=getProc(hh,'ippsIIRSetTaps_64f');
  ippsIIRSetTaps_64fc:=getProc(hh,'ippsIIRSetTaps_64fc');
  ippsIIRSetTaps64f_32f:=getProc(hh,'ippsIIRSetTaps64f_32f');
  ippsIIRSetTaps64fc_32fc:=getProc(hh,'ippsIIRSetTaps64fc_32fc');
  ippsIIRSetTaps64f_32s:=getProc(hh,'ippsIIRSetTaps64f_32s');
  ippsIIRSetTaps64fc_32sc:=getProc(hh,'ippsIIRSetTaps64fc_32sc');
  ippsIIRSetTaps64f_16s:=getProc(hh,'ippsIIRSetTaps64f_16s');
  ippsIIRSetTaps64fc_16sc:=getProc(hh,'ippsIIRSetTaps64fc_16sc');
  ippsFIRInitAlloc_32f:=getProc(hh,'ippsFIRInitAlloc_32f');
  ippsFIRMRInitAlloc_32f:=getProc(hh,'ippsFIRMRInitAlloc_32f');
  ippsFIRInitAlloc_32fc:=getProc(hh,'ippsFIRInitAlloc_32fc');
  ippsFIRMRInitAlloc_32fc:=getProc(hh,'ippsFIRMRInitAlloc_32fc');
  ippsFIRInitAlloc32f_16s:=getProc(hh,'ippsFIRInitAlloc32f_16s');
  ippsFIRMRInitAlloc32f_16s:=getProc(hh,'ippsFIRMRInitAlloc32f_16s');
  ippsFIRInitAlloc32fc_16sc:=getProc(hh,'ippsFIRInitAlloc32fc_16sc');
  ippsFIRMRInitAlloc32fc_16sc:=getProc(hh,'ippsFIRMRInitAlloc32fc_16sc');
  ippsFIRInitAlloc_64f:=getProc(hh,'ippsFIRInitAlloc_64f');
  ippsFIRMRInitAlloc_64f:=getProc(hh,'ippsFIRMRInitAlloc_64f');
  ippsFIRInitAlloc_64fc:=getProc(hh,'ippsFIRInitAlloc_64fc');
  ippsFIRMRInitAlloc_64fc:=getProc(hh,'ippsFIRMRInitAlloc_64fc');
  ippsFIRInitAlloc64f_32f:=getProc(hh,'ippsFIRInitAlloc64f_32f');
  ippsFIRMRInitAlloc64f_32f:=getProc(hh,'ippsFIRMRInitAlloc64f_32f');
  ippsFIRInitAlloc64fc_32fc:=getProc(hh,'ippsFIRInitAlloc64fc_32fc');
  ippsFIRMRInitAlloc64fc_32fc:=getProc(hh,'ippsFIRMRInitAlloc64fc_32fc');
  ippsFIRInitAlloc64f_32s:=getProc(hh,'ippsFIRInitAlloc64f_32s');
  ippsFIRMRInitAlloc64f_32s:=getProc(hh,'ippsFIRMRInitAlloc64f_32s');
  ippsFIRInitAlloc64fc_32sc:=getProc(hh,'ippsFIRInitAlloc64fc_32sc');
  ippsFIRMRInitAlloc64fc_32sc:=getProc(hh,'ippsFIRMRInitAlloc64fc_32sc');
  ippsFIRInitAlloc64f_16s:=getProc(hh,'ippsFIRInitAlloc64f_16s');
  ippsFIRMRInitAlloc64f_16s:=getProc(hh,'ippsFIRMRInitAlloc64f_16s');
  ippsFIRInitAlloc64fc_16sc:=getProc(hh,'ippsFIRInitAlloc64fc_16sc');
  ippsFIRMRInitAlloc64fc_16sc:=getProc(hh,'ippsFIRMRInitAlloc64fc_16sc');
  ippsFIRFree_32f:=getProc(hh,'ippsFIRFree_32f');
  ippsFIRFree_32fc:=getProc(hh,'ippsFIRFree_32fc');
  ippsFIRFree32f_16s:=getProc(hh,'ippsFIRFree32f_16s');
  ippsFIRFree32fc_16sc:=getProc(hh,'ippsFIRFree32fc_16sc');
  ippsFIRFree_64f:=getProc(hh,'ippsFIRFree_64f');
  ippsFIRFree_64fc:=getProc(hh,'ippsFIRFree_64fc');
  ippsFIRFree64f_32f:=getProc(hh,'ippsFIRFree64f_32f');
  ippsFIRFree64fc_32fc:=getProc(hh,'ippsFIRFree64fc_32fc');
  ippsFIRFree64f_32s:=getProc(hh,'ippsFIRFree64f_32s');
  ippsFIRFree64fc_32sc:=getProc(hh,'ippsFIRFree64fc_32sc');
  ippsFIRFree64f_16s:=getProc(hh,'ippsFIRFree64f_16s');
  ippsFIRFree64fc_16sc:=getProc(hh,'ippsFIRFree64fc_16sc');
  ippsFIRGetStateSize32s_16s:=getProc(hh,'ippsFIRGetStateSize32s_16s');
  ippsFIRInit32s_16s:=getProc(hh,'ippsFIRInit32s_16s');
  ippsFIRMRGetStateSize32s_16s:=getProc(hh,'ippsFIRMRGetStateSize32s_16s');
  ippsFIRMRInit32s_16s:=getProc(hh,'ippsFIRMRInit32s_16s');
  ippsFIRInit32sc_16sc:=getProc(hh,'ippsFIRInit32sc_16sc');
  ippsFIRMRGetStateSize32sc_16sc:=getProc(hh,'ippsFIRMRGetStateSize32sc_16sc');
  ippsFIRMRInit32sc_16sc:=getProc(hh,'ippsFIRMRInit32sc_16sc');
  ippsFIRGetStateSize32sc_16sc32fc:=getProc(hh,'ippsFIRGetStateSize32sc_16sc32fc');
  ippsFIRGetStateSize32s_16s32f:=getProc(hh,'ippsFIRGetStateSize32s_16s32f');
  ippsFIRInit32s_16s32f:=getProc(hh,'ippsFIRInit32s_16s32f');
  ippsFIRMRGetStateSize32s_16s32f:=getProc(hh,'ippsFIRMRGetStateSize32s_16s32f');
  ippsFIRMRInit32s_16s32f:=getProc(hh,'ippsFIRMRInit32s_16s32f');
  ippsFIRGetStateSize32sc_16sc:=getProc(hh,'ippsFIRGetStateSize32sc_16sc');
  ippsFIRInit32sc_16sc32fc:=getProc(hh,'ippsFIRInit32sc_16sc32fc');
  ippsFIRMRGetStateSize32sc_16sc32fc:=getProc(hh,'ippsFIRMRGetStateSize32sc_16sc32fc');
  ippsFIRMRInit32sc_16sc32fc:=getProc(hh,'ippsFIRMRInit32sc_16sc32fc');
  ippsFIRInit_32f:=getProc(hh,'ippsFIRInit_32f');
  ippsFIRInit_32fc:=getProc(hh,'ippsFIRInit_32fc');
  ippsFIRGetStateSize_32f:=getProc(hh,'ippsFIRGetStateSize_32f');
  ippsFIRGetStateSize_32fc:=getProc(hh,'ippsFIRGetStateSize_32fc');
  ippsFIRMRInit_32f:=getProc(hh,'ippsFIRMRInit_32f');
  ippsFIRMRGetStateSize_32f:=getProc(hh,'ippsFIRMRGetStateSize_32f');
  ippsFIRMRGetStateSize_32fc:=getProc(hh,'ippsFIRMRGetStateSize_32fc');
  ippsFIRMRInit_32fc:=getProc(hh,'ippsFIRMRInit_32fc');
  ippsFIRGetStateSize32f_16s:=getProc(hh,'ippsFIRGetStateSize32f_16s');
  ippsFIRInit32f_16s:=getProc(hh,'ippsFIRInit32f_16s');
  ippsFIRGetStateSize32fc_16sc:=getProc(hh,'ippsFIRGetStateSize32fc_16sc');
  ippsFIRInit32fc_16sc:=getProc(hh,'ippsFIRInit32fc_16sc');
  ippsFIRMRGetStateSize32f_16s:=getProc(hh,'ippsFIRMRGetStateSize32f_16s');
  ippsFIRMRInit32f_16s:=getProc(hh,'ippsFIRMRInit32f_16s');
  ippsFIRMRGetStateSize32fc_16sc:=getProc(hh,'ippsFIRMRGetStateSize32fc_16sc');
  ippsFIRMRInit32fc_16sc:=getProc(hh,'ippsFIRMRInit32fc_16sc');
  ippsFIRInit_64f:=getProc(hh,'ippsFIRInit_64f');
  ippsFIRInit_64fc:=getProc(hh,'ippsFIRInit_64fc');
  ippsFIRGetStateSize_64f:=getProc(hh,'ippsFIRGetStateSize_64f');
  ippsFIRGetStateSize_64fc:=getProc(hh,'ippsFIRGetStateSize_64fc');
  ippsFIRMRInit_64f:=getProc(hh,'ippsFIRMRInit_64f');
  ippsFIRMRGetStateSize_64f:=getProc(hh,'ippsFIRMRGetStateSize_64f');
  ippsFIRMRGetStateSize_64fc:=getProc(hh,'ippsFIRMRGetStateSize_64fc');
  ippsFIRMRInit_64fc:=getProc(hh,'ippsFIRMRInit_64fc');
  ippsFIRGetStateSize64f_16s:=getProc(hh,'ippsFIRGetStateSize64f_16s');
  ippsFIRInit64f_16s:=getProc(hh,'ippsFIRInit64f_16s');
  ippsFIRGetStateSize64fc_16sc:=getProc(hh,'ippsFIRGetStateSize64fc_16sc');
  ippsFIRInit64fc_16sc:=getProc(hh,'ippsFIRInit64fc_16sc');
  ippsFIRMRGetStateSize64f_16s:=getProc(hh,'ippsFIRMRGetStateSize64f_16s');
  ippsFIRMRInit64f_16s:=getProc(hh,'ippsFIRMRInit64f_16s');
  ippsFIRMRGetStateSize64fc_16sc:=getProc(hh,'ippsFIRMRGetStateSize64fc_16sc');
  ippsFIRMRInit64fc_16sc:=getProc(hh,'ippsFIRMRInit64fc_16sc');
  ippsFIRGetStateSize64f_32s:=getProc(hh,'ippsFIRGetStateSize64f_32s');
  ippsFIRInit64f_32s:=getProc(hh,'ippsFIRInit64f_32s');
  ippsFIRGetStateSize64fc_32sc:=getProc(hh,'ippsFIRGetStateSize64fc_32sc');
  ippsFIRInit64fc_32sc:=getProc(hh,'ippsFIRInit64fc_32sc');
  ippsFIRMRGetStateSize64f_32s:=getProc(hh,'ippsFIRMRGetStateSize64f_32s');
  ippsFIRMRInit64f_32s:=getProc(hh,'ippsFIRMRInit64f_32s');
  ippsFIRMRGetStateSize64fc_32sc:=getProc(hh,'ippsFIRMRGetStateSize64fc_32sc');
  ippsFIRMRInit64fc_32sc:=getProc(hh,'ippsFIRMRInit64fc_32sc');
  ippsFIRGetStateSize64f_32f:=getProc(hh,'ippsFIRGetStateSize64f_32f');
  ippsFIRInit64f_32f:=getProc(hh,'ippsFIRInit64f_32f');
  ippsFIRGetStateSize64fc_32fc:=getProc(hh,'ippsFIRGetStateSize64fc_32fc');
  ippsFIRInit64fc_32fc:=getProc(hh,'ippsFIRInit64fc_32fc');
  ippsFIRMRGetStateSize64f_32f:=getProc(hh,'ippsFIRMRGetStateSize64f_32f');
  ippsFIRMRInit64f_32f:=getProc(hh,'ippsFIRMRInit64f_32f');
  ippsFIRMRGetStateSize64fc_32fc:=getProc(hh,'ippsFIRMRGetStateSize64fc_32fc');
  ippsFIRMRInit64fc_32fc:=getProc(hh,'ippsFIRMRInit64fc_32fc');
  ippsFIRGetTaps_32f:=getProc(hh,'ippsFIRGetTaps_32f');
  ippsFIRGetTaps_32fc:=getProc(hh,'ippsFIRGetTaps_32fc');
  ippsFIRGetTaps32f_16s:=getProc(hh,'ippsFIRGetTaps32f_16s');
  ippsFIRGetTaps32fc_16sc:=getProc(hh,'ippsFIRGetTaps32fc_16sc');
  ippsFIRGetTaps_64f:=getProc(hh,'ippsFIRGetTaps_64f');
  ippsFIRGetTaps_64fc:=getProc(hh,'ippsFIRGetTaps_64fc');
  ippsFIRGetTaps64f_32f:=getProc(hh,'ippsFIRGetTaps64f_32f');
  ippsFIRGetTaps64fc_32fc:=getProc(hh,'ippsFIRGetTaps64fc_32fc');
  ippsFIRGetTaps64f_32s:=getProc(hh,'ippsFIRGetTaps64f_32s');
  ippsFIRGetTaps64fc_32sc:=getProc(hh,'ippsFIRGetTaps64fc_32sc');
  ippsFIRGetTaps64f_16s:=getProc(hh,'ippsFIRGetTaps64f_16s');
  ippsFIRGetTaps64fc_16sc:=getProc(hh,'ippsFIRGetTaps64fc_16sc');
  ippsFIRSetTaps_32f:=getProc(hh,'ippsFIRSetTaps_32f');
  ippsFIRSetTaps_32fc:=getProc(hh,'ippsFIRSetTaps_32fc');
  ippsFIRSetTaps32f_16s:=getProc(hh,'ippsFIRSetTaps32f_16s');
  ippsFIRSetTaps32fc_16sc:=getProc(hh,'ippsFIRSetTaps32fc_16sc');
  ippsFIRSetTaps32s_16s:=getProc(hh,'ippsFIRSetTaps32s_16s');
  ippsFIRSetTaps32sc_16sc:=getProc(hh,'ippsFIRSetTaps32sc_16sc');
  ippsFIRSetTaps32s_16s32f:=getProc(hh,'ippsFIRSetTaps32s_16s32f');
  ippsFIRSetTaps32sc_16sc32fc:=getProc(hh,'ippsFIRSetTaps32sc_16sc32fc');
  ippsFIRSetTaps_64f:=getProc(hh,'ippsFIRSetTaps_64f');
  ippsFIRSetTaps_64fc:=getProc(hh,'ippsFIRSetTaps_64fc');
  ippsFIRSetTaps64f_32f:=getProc(hh,'ippsFIRSetTaps64f_32f');
  ippsFIRSetTaps64fc_32fc:=getProc(hh,'ippsFIRSetTaps64fc_32fc');
  ippsFIRSetTaps64f_32s:=getProc(hh,'ippsFIRSetTaps64f_32s');
  ippsFIRSetTaps64fc_32sc:=getProc(hh,'ippsFIRSetTaps64fc_32sc');
  ippsFIRSetTaps64f_16s:=getProc(hh,'ippsFIRSetTaps64f_16s');
  ippsFIRSetTaps64fc_16sc:=getProc(hh,'ippsFIRSetTaps64fc_16sc');
  ippsFIRGetDlyLine_32f:=getProc(hh,'ippsFIRGetDlyLine_32f');
end;

procedure InitIpps3;
begin
  ippsFIRSetDlyLine_32f:=getProc(hh,'ippsFIRSetDlyLine_32f');
  ippsFIRGetDlyLine_32fc:=getProc(hh,'ippsFIRGetDlyLine_32fc');
  ippsFIRSetDlyLine_32fc:=getProc(hh,'ippsFIRSetDlyLine_32fc');
  ippsFIRGetDlyLine32f_16s:=getProc(hh,'ippsFIRGetDlyLine32f_16s');
  ippsFIRSetDlyLine32f_16s:=getProc(hh,'ippsFIRSetDlyLine32f_16s');
  ippsFIRGetDlyLine32fc_16sc:=getProc(hh,'ippsFIRGetDlyLine32fc_16sc');
  ippsFIRSetDlyLine32fc_16sc:=getProc(hh,'ippsFIRSetDlyLine32fc_16sc');
  ippsFIRGetDlyLine_64f:=getProc(hh,'ippsFIRGetDlyLine_64f');
  ippsFIRSetDlyLine_64f:=getProc(hh,'ippsFIRSetDlyLine_64f');
  ippsFIRGetDlyLine_64fc:=getProc(hh,'ippsFIRGetDlyLine_64fc');
  ippsFIRSetDlyLine_64fc:=getProc(hh,'ippsFIRSetDlyLine_64fc');
  ippsFIRGetDlyLine64f_32f:=getProc(hh,'ippsFIRGetDlyLine64f_32f');
  ippsFIRSetDlyLine64f_32f:=getProc(hh,'ippsFIRSetDlyLine64f_32f');
  ippsFIRGetDlyLine64fc_32fc:=getProc(hh,'ippsFIRGetDlyLine64fc_32fc');
  ippsFIRSetDlyLine64fc_32fc:=getProc(hh,'ippsFIRSetDlyLine64fc_32fc');
  ippsFIRGetDlyLine64f_32s:=getProc(hh,'ippsFIRGetDlyLine64f_32s');
  ippsFIRSetDlyLine64f_32s:=getProc(hh,'ippsFIRSetDlyLine64f_32s');
  ippsFIRGetDlyLine64fc_32sc:=getProc(hh,'ippsFIRGetDlyLine64fc_32sc');
  ippsFIRSetDlyLine64fc_32sc:=getProc(hh,'ippsFIRSetDlyLine64fc_32sc');
  ippsFIRGetDlyLine64f_16s:=getProc(hh,'ippsFIRGetDlyLine64f_16s');
  ippsFIRSetDlyLine64f_16s:=getProc(hh,'ippsFIRSetDlyLine64f_16s');
  ippsFIRGetDlyLine64fc_16sc:=getProc(hh,'ippsFIRGetDlyLine64fc_16sc');
  ippsFIRSetDlyLine64fc_16sc:=getProc(hh,'ippsFIRSetDlyLine64fc_16sc');
  ippsFIROne_32f:=getProc(hh,'ippsFIROne_32f');
  ippsFIROne_32fc:=getProc(hh,'ippsFIROne_32fc');
  ippsFIROne32f_16s_Sfs:=getProc(hh,'ippsFIROne32f_16s_Sfs');
  ippsFIROne32fc_16sc_Sfs:=getProc(hh,'ippsFIROne32fc_16sc_Sfs');
  ippsFIROne_64f:=getProc(hh,'ippsFIROne_64f');
  ippsFIROne_64fc:=getProc(hh,'ippsFIROne_64fc');
  ippsFIROne64f_32f:=getProc(hh,'ippsFIROne64f_32f');
  ippsFIROne64fc_32fc:=getProc(hh,'ippsFIROne64fc_32fc');
  ippsFIROne64f_32s_Sfs:=getProc(hh,'ippsFIROne64f_32s_Sfs');
  ippsFIROne64fc_32sc_Sfs:=getProc(hh,'ippsFIROne64fc_32sc_Sfs');
  ippsFIROne64f_16s_Sfs:=getProc(hh,'ippsFIROne64f_16s_Sfs');
  ippsFIROne64fc_16sc_Sfs:=getProc(hh,'ippsFIROne64fc_16sc_Sfs');
  ippsFIR_32f:=getProc(hh,'ippsFIR_32f');
  ippsFIR_32fc:=getProc(hh,'ippsFIR_32fc');
  ippsFIR32f_16s_Sfs:=getProc(hh,'ippsFIR32f_16s_Sfs');
  ippsFIR32fc_16sc_Sfs:=getProc(hh,'ippsFIR32fc_16sc_Sfs');
  ippsFIR_32f_I:=getProc(hh,'ippsFIR_32f_I');
  ippsFIR_32fc_I:=getProc(hh,'ippsFIR_32fc_I');
  ippsFIR32f_16s_ISfs:=getProc(hh,'ippsFIR32f_16s_ISfs');
  ippsFIR32fc_16sc_ISfs:=getProc(hh,'ippsFIR32fc_16sc_ISfs');
  ippsFIR_64f:=getProc(hh,'ippsFIR_64f');
  ippsFIR_64fc:=getProc(hh,'ippsFIR_64fc');
  ippsFIR_64f_I:=getProc(hh,'ippsFIR_64f_I');
  ippsFIR_64fc_I:=getProc(hh,'ippsFIR_64fc_I');
  ippsFIR64f_32f:=getProc(hh,'ippsFIR64f_32f');
  ippsFIR64fc_32fc:=getProc(hh,'ippsFIR64fc_32fc');
  ippsFIR64f_32f_I:=getProc(hh,'ippsFIR64f_32f_I');
  ippsFIR64fc_32fc_I:=getProc(hh,'ippsFIR64fc_32fc_I');
  ippsFIR64f_32s_Sfs:=getProc(hh,'ippsFIR64f_32s_Sfs');
  ippsFIR64fc_32sc_Sfs:=getProc(hh,'ippsFIR64fc_32sc_Sfs');
  ippsFIR64f_32s_ISfs:=getProc(hh,'ippsFIR64f_32s_ISfs');
  ippsFIR64fc_32sc_ISfs:=getProc(hh,'ippsFIR64fc_32sc_ISfs');
  ippsFIR64f_16s_Sfs:=getProc(hh,'ippsFIR64f_16s_Sfs');
  ippsFIR64fc_16sc_Sfs:=getProc(hh,'ippsFIR64fc_16sc_Sfs');
  ippsFIR64f_16s_ISfs:=getProc(hh,'ippsFIR64f_16s_ISfs');
  ippsFIR64fc_16sc_ISfs:=getProc(hh,'ippsFIR64fc_16sc_ISfs');
  ippsFIRInitAlloc32s_16s:=getProc(hh,'ippsFIRInitAlloc32s_16s');
  ippsFIRMRInitAlloc32s_16s:=getProc(hh,'ippsFIRMRInitAlloc32s_16s');
  ippsFIRInitAlloc32s_16s32f:=getProc(hh,'ippsFIRInitAlloc32s_16s32f');
  ippsFIRMRInitAlloc32s_16s32f:=getProc(hh,'ippsFIRMRInitAlloc32s_16s32f');
  ippsFIRInitAlloc32sc_16sc:=getProc(hh,'ippsFIRInitAlloc32sc_16sc');
  ippsFIRMRInitAlloc32sc_16sc:=getProc(hh,'ippsFIRMRInitAlloc32sc_16sc');
  ippsFIRInitAlloc32sc_16sc32fc:=getProc(hh,'ippsFIRInitAlloc32sc_16sc32fc');
  ippsFIRMRInitAlloc32sc_16sc32fc:=getProc(hh,'ippsFIRMRInitAlloc32sc_16sc32fc');
  ippsFIRFree32s_16s:=getProc(hh,'ippsFIRFree32s_16s');
  ippsFIRFree32sc_16sc:=getProc(hh,'ippsFIRFree32sc_16sc');
  ippsFIRGetTaps32s_16s:=getProc(hh,'ippsFIRGetTaps32s_16s');
  ippsFIRGetTaps32sc_16sc:=getProc(hh,'ippsFIRGetTaps32sc_16sc');
  ippsFIRGetTaps32s_16s32f:=getProc(hh,'ippsFIRGetTaps32s_16s32f');
  ippsFIRGetTaps32sc_16sc32fc:=getProc(hh,'ippsFIRGetTaps32sc_16sc32fc');
  ippsFIRGetDlyLine32s_16s:=getProc(hh,'ippsFIRGetDlyLine32s_16s');
  ippsFIRSetDlyLine32s_16s:=getProc(hh,'ippsFIRSetDlyLine32s_16s');
  ippsFIRGetDlyLine32sc_16sc:=getProc(hh,'ippsFIRGetDlyLine32sc_16sc');
  ippsFIRSetDlyLine32sc_16sc:=getProc(hh,'ippsFIRSetDlyLine32sc_16sc');
  ippsFIROne32s_16s_Sfs:=getProc(hh,'ippsFIROne32s_16s_Sfs');
  ippsFIROne32sc_16sc_Sfs:=getProc(hh,'ippsFIROne32sc_16sc_Sfs');
  ippsFIR32s_16s_Sfs:=getProc(hh,'ippsFIR32s_16s_Sfs');
  ippsFIR32sc_16sc_Sfs:=getProc(hh,'ippsFIR32sc_16sc_Sfs');
  ippsFIR32s_16s_ISfs:=getProc(hh,'ippsFIR32s_16s_ISfs');
  ippsFIR32sc_16sc_ISfs:=getProc(hh,'ippsFIR32sc_16sc_ISfs');
  ippsFIRLMSOne_Direct_32f:=getProc(hh,'ippsFIRLMSOne_Direct_32f');
  ippsFIRLMSOne_Direct32f_16s:=getProc(hh,'ippsFIRLMSOne_Direct32f_16s');
  ippsFIRLMSOne_DirectQ15_16s:=getProc(hh,'ippsFIRLMSOne_DirectQ15_16s');
  ippsFIRLMS_32f:=getProc(hh,'ippsFIRLMS_32f');
  ippsFIRLMS32f_16s:=getProc(hh,'ippsFIRLMS32f_16s');
  ippsFIRLMSInitAlloc_32f:=getProc(hh,'ippsFIRLMSInitAlloc_32f');
  ippsFIRLMSInitAlloc32f_16s:=getProc(hh,'ippsFIRLMSInitAlloc32f_16s');
  ippsFIRLMSFree_32f:=getProc(hh,'ippsFIRLMSFree_32f');
  ippsFIRLMSFree32f_16s:=getProc(hh,'ippsFIRLMSFree32f_16s');
  ippsFIRLMSGetTaps_32f:=getProc(hh,'ippsFIRLMSGetTaps_32f');
  ippsFIRLMSGetTaps32f_16s:=getProc(hh,'ippsFIRLMSGetTaps32f_16s');
  ippsFIRLMSGetDlyLine_32f:=getProc(hh,'ippsFIRLMSGetDlyLine_32f');
  ippsFIRLMSGetDlyLine32f_16s:=getProc(hh,'ippsFIRLMSGetDlyLine32f_16s');
  ippsFIRLMSSetDlyLine_32f:=getProc(hh,'ippsFIRLMSSetDlyLine_32f');
  ippsFIRLMSSetDlyLine32f_16s:=getProc(hh,'ippsFIRLMSSetDlyLine32f_16s');
  ippsFIRLMSMROne32s_16s:=getProc(hh,'ippsFIRLMSMROne32s_16s');
  ippsFIRLMSMROneVal32s_16s:=getProc(hh,'ippsFIRLMSMROneVal32s_16s');
  ippsFIRLMSMROne32sc_16sc:=getProc(hh,'ippsFIRLMSMROne32sc_16sc');
  ippsFIRLMSMROneVal32sc_16sc:=getProc(hh,'ippsFIRLMSMROneVal32sc_16sc');
  ippsFIRLMSMRInitAlloc32s_16s:=getProc(hh,'ippsFIRLMSMRInitAlloc32s_16s');
  ippsFIRLMSMRFree32s_16s:=getProc(hh,'ippsFIRLMSMRFree32s_16s');
  ippsFIRLMSMRInitAlloc32sc_16sc:=getProc(hh,'ippsFIRLMSMRInitAlloc32sc_16sc');
  ippsFIRLMSMRFree32sc_16sc:=getProc(hh,'ippsFIRLMSMRFree32sc_16sc');
  ippsFIRLMSMRSetTaps32s_16s:=getProc(hh,'ippsFIRLMSMRSetTaps32s_16s');
  ippsFIRLMSMRGetTaps32s_16s:=getProc(hh,'ippsFIRLMSMRGetTaps32s_16s');
  ippsFIRLMSMRGetTapsPointer32s_16s:=getProc(hh,'ippsFIRLMSMRGetTapsPointer32s_16s');
  ippsFIRLMSMRSetTaps32sc_16sc:=getProc(hh,'ippsFIRLMSMRSetTaps32sc_16sc');
  ippsFIRLMSMRGetTaps32sc_16sc:=getProc(hh,'ippsFIRLMSMRGetTaps32sc_16sc');
  ippsFIRLMSMRGetTapsPointer32sc_16sc:=getProc(hh,'ippsFIRLMSMRGetTapsPointer32sc_16sc');
  ippsFIRLMSMRSetDlyLine32s_16s:=getProc(hh,'ippsFIRLMSMRSetDlyLine32s_16s');
  ippsFIRLMSMRGetDlyLine32s_16s:=getProc(hh,'ippsFIRLMSMRGetDlyLine32s_16s');
  ippsFIRLMSMRGetDlyVal32s_16s:=getProc(hh,'ippsFIRLMSMRGetDlyVal32s_16s');
  ippsFIRLMSMRSetDlyLine32sc_16sc:=getProc(hh,'ippsFIRLMSMRSetDlyLine32sc_16sc');
  ippsFIRLMSMRGetDlyLine32sc_16sc:=getProc(hh,'ippsFIRLMSMRGetDlyLine32sc_16sc');
  ippsFIRLMSMRGetDlyVal32sc_16sc:=getProc(hh,'ippsFIRLMSMRGetDlyVal32sc_16sc');
  ippsFIRLMSMRPutVal32s_16s:=getProc(hh,'ippsFIRLMSMRPutVal32s_16s');
  ippsFIRLMSMRPutVal32sc_16sc:=getProc(hh,'ippsFIRLMSMRPutVal32sc_16sc');
  ippsFIRLMSMRSetMu32s_16s:=getProc(hh,'ippsFIRLMSMRSetMu32s_16s');
  ippsFIRLMSMRSetMu32sc_16sc:=getProc(hh,'ippsFIRLMSMRSetMu32sc_16sc');
  ippsFIRLMSMRUpdateTaps32s_16s:=getProc(hh,'ippsFIRLMSMRUpdateTaps32s_16s');
  ippsFIRLMSMRUpdateTaps32sc_16sc:=getProc(hh,'ippsFIRLMSMRUpdateTaps32sc_16sc');
  ippsFIROne_Direct_32f:=getProc(hh,'ippsFIROne_Direct_32f');
  ippsFIROne_Direct_32fc:=getProc(hh,'ippsFIROne_Direct_32fc');
  ippsFIROne_Direct_32f_I:=getProc(hh,'ippsFIROne_Direct_32f_I');
  ippsFIROne_Direct_32fc_I:=getProc(hh,'ippsFIROne_Direct_32fc_I');
  ippsFIROne32f_Direct_16s_Sfs:=getProc(hh,'ippsFIROne32f_Direct_16s_Sfs');
  ippsFIROne32fc_Direct_16sc_Sfs:=getProc(hh,'ippsFIROne32fc_Direct_16sc_Sfs');
  ippsFIROne32f_Direct_16s_ISfs:=getProc(hh,'ippsFIROne32f_Direct_16s_ISfs');
  ippsFIROne32fc_Direct_16sc_ISfs:=getProc(hh,'ippsFIROne32fc_Direct_16sc_ISfs');
  ippsFIROne_Direct_64f:=getProc(hh,'ippsFIROne_Direct_64f');
  ippsFIROne_Direct_64fc:=getProc(hh,'ippsFIROne_Direct_64fc');
  ippsFIROne_Direct_64f_I:=getProc(hh,'ippsFIROne_Direct_64f_I');
  ippsFIROne_Direct_64fc_I:=getProc(hh,'ippsFIROne_Direct_64fc_I');
  ippsFIROne64f_Direct_32f:=getProc(hh,'ippsFIROne64f_Direct_32f');
  ippsFIROne64fc_Direct_32fc:=getProc(hh,'ippsFIROne64fc_Direct_32fc');
  ippsFIROne64f_Direct_32f_I:=getProc(hh,'ippsFIROne64f_Direct_32f_I');
  ippsFIROne64fc_Direct_32fc_I:=getProc(hh,'ippsFIROne64fc_Direct_32fc_I');
  ippsFIROne64f_Direct_32s_Sfs:=getProc(hh,'ippsFIROne64f_Direct_32s_Sfs');
  ippsFIROne64fc_Direct_32sc_Sfs:=getProc(hh,'ippsFIROne64fc_Direct_32sc_Sfs');
  ippsFIROne64f_Direct_32s_ISfs:=getProc(hh,'ippsFIROne64f_Direct_32s_ISfs');
  ippsFIROne64fc_Direct_32sc_ISfs:=getProc(hh,'ippsFIROne64fc_Direct_32sc_ISfs');
  ippsFIROne64f_Direct_16s_Sfs:=getProc(hh,'ippsFIROne64f_Direct_16s_Sfs');
  ippsFIROne64fc_Direct_16sc_Sfs:=getProc(hh,'ippsFIROne64fc_Direct_16sc_Sfs');
  ippsFIROne64f_Direct_16s_ISfs:=getProc(hh,'ippsFIROne64f_Direct_16s_ISfs');
  ippsFIROne64fc_Direct_16sc_ISfs:=getProc(hh,'ippsFIROne64fc_Direct_16sc_ISfs');
  ippsFIROne32s_Direct_16s_Sfs:=getProc(hh,'ippsFIROne32s_Direct_16s_Sfs');
  ippsFIROne32sc_Direct_16sc_Sfs:=getProc(hh,'ippsFIROne32sc_Direct_16sc_Sfs');
  ippsFIROne32s_Direct_16s_ISfs:=getProc(hh,'ippsFIROne32s_Direct_16s_ISfs');
  ippsFIROne32sc_Direct_16sc_ISfs:=getProc(hh,'ippsFIROne32sc_Direct_16sc_ISfs');
  ippsFIR_Direct_32f:=getProc(hh,'ippsFIR_Direct_32f');
  ippsFIR_Direct_32fc:=getProc(hh,'ippsFIR_Direct_32fc');
  ippsFIR_Direct_32f_I:=getProc(hh,'ippsFIR_Direct_32f_I');
  ippsFIR_Direct_32fc_I:=getProc(hh,'ippsFIR_Direct_32fc_I');
  ippsFIR32f_Direct_16s_Sfs:=getProc(hh,'ippsFIR32f_Direct_16s_Sfs');
  ippsFIR32fc_Direct_16sc_Sfs:=getProc(hh,'ippsFIR32fc_Direct_16sc_Sfs');
  ippsFIR32f_Direct_16s_ISfs:=getProc(hh,'ippsFIR32f_Direct_16s_ISfs');
  ippsFIR32fc_Direct_16sc_ISfs:=getProc(hh,'ippsFIR32fc_Direct_16sc_ISfs');
  ippsFIR_Direct_64f:=getProc(hh,'ippsFIR_Direct_64f');
  ippsFIR_Direct_64fc:=getProc(hh,'ippsFIR_Direct_64fc');
  ippsFIR_Direct_64f_I:=getProc(hh,'ippsFIR_Direct_64f_I');
  ippsFIR_Direct_64fc_I:=getProc(hh,'ippsFIR_Direct_64fc_I');
  ippsFIR64f_Direct_32f:=getProc(hh,'ippsFIR64f_Direct_32f');
  ippsFIR64fc_Direct_32fc:=getProc(hh,'ippsFIR64fc_Direct_32fc');
  ippsFIR64f_Direct_32f_I:=getProc(hh,'ippsFIR64f_Direct_32f_I');
  ippsFIR64fc_Direct_32fc_I:=getProc(hh,'ippsFIR64fc_Direct_32fc_I');
  ippsFIR64f_Direct_32s_Sfs:=getProc(hh,'ippsFIR64f_Direct_32s_Sfs');
  ippsFIR64fc_Direct_32sc_Sfs:=getProc(hh,'ippsFIR64fc_Direct_32sc_Sfs');
  ippsFIR64f_Direct_32s_ISfs:=getProc(hh,'ippsFIR64f_Direct_32s_ISfs');
  ippsFIR64fc_Direct_32sc_ISfs:=getProc(hh,'ippsFIR64fc_Direct_32sc_ISfs');
  ippsFIR64f_Direct_16s_Sfs:=getProc(hh,'ippsFIR64f_Direct_16s_Sfs');
  ippsFIR64fc_Direct_16sc_Sfs:=getProc(hh,'ippsFIR64fc_Direct_16sc_Sfs');
  ippsFIR64f_Direct_16s_ISfs:=getProc(hh,'ippsFIR64f_Direct_16s_ISfs');
  ippsFIR64fc_Direct_16sc_ISfs:=getProc(hh,'ippsFIR64fc_Direct_16sc_ISfs');
  ippsFIR32s_Direct_16s_Sfs:=getProc(hh,'ippsFIR32s_Direct_16s_Sfs');
  ippsFIR32sc_Direct_16sc_Sfs:=getProc(hh,'ippsFIR32sc_Direct_16sc_Sfs');
  ippsFIR32s_Direct_16s_ISfs:=getProc(hh,'ippsFIR32s_Direct_16s_ISfs');
  ippsFIR32sc_Direct_16sc_ISfs:=getProc(hh,'ippsFIR32sc_Direct_16sc_ISfs');
  ippsFIRMR_Direct_32f:=getProc(hh,'ippsFIRMR_Direct_32f');
  ippsFIRMR_Direct_32fc:=getProc(hh,'ippsFIRMR_Direct_32fc');
  ippsFIRMR_Direct_32f_I:=getProc(hh,'ippsFIRMR_Direct_32f_I');
  ippsFIRMR_Direct_32fc_I:=getProc(hh,'ippsFIRMR_Direct_32fc_I');
  ippsFIRMR32f_Direct_16s_Sfs:=getProc(hh,'ippsFIRMR32f_Direct_16s_Sfs');
  ippsFIRMR32fc_Direct_16sc_Sfs:=getProc(hh,'ippsFIRMR32fc_Direct_16sc_Sfs');
  ippsFIRMR32f_Direct_16s_ISfs:=getProc(hh,'ippsFIRMR32f_Direct_16s_ISfs');
  ippsFIRMR32fc_Direct_16sc_ISfs:=getProc(hh,'ippsFIRMR32fc_Direct_16sc_ISfs');
  ippsFIRMR_Direct_64f:=getProc(hh,'ippsFIRMR_Direct_64f');
  ippsFIRMR_Direct_64fc:=getProc(hh,'ippsFIRMR_Direct_64fc');
  ippsFIRMR_Direct_64f_I:=getProc(hh,'ippsFIRMR_Direct_64f_I');
  ippsFIRMR_Direct_64fc_I:=getProc(hh,'ippsFIRMR_Direct_64fc_I');
  ippsFIRMR64f_Direct_32f:=getProc(hh,'ippsFIRMR64f_Direct_32f');
  ippsFIRMR64fc_Direct_32fc:=getProc(hh,'ippsFIRMR64fc_Direct_32fc');
  ippsFIRMR64f_Direct_32f_I:=getProc(hh,'ippsFIRMR64f_Direct_32f_I');
  ippsFIRMR64fc_Direct_32fc_I:=getProc(hh,'ippsFIRMR64fc_Direct_32fc_I');
  ippsFIRMR64f_Direct_32s_Sfs:=getProc(hh,'ippsFIRMR64f_Direct_32s_Sfs');
  ippsFIRMR64fc_Direct_32sc_Sfs:=getProc(hh,'ippsFIRMR64fc_Direct_32sc_Sfs');
  ippsFIRMR64f_Direct_32s_ISfs:=getProc(hh,'ippsFIRMR64f_Direct_32s_ISfs');
  ippsFIRMR64fc_Direct_32sc_ISfs:=getProc(hh,'ippsFIRMR64fc_Direct_32sc_ISfs');
  ippsFIRMR64f_Direct_16s_Sfs:=getProc(hh,'ippsFIRMR64f_Direct_16s_Sfs');
  ippsFIRMR64fc_Direct_16sc_Sfs:=getProc(hh,'ippsFIRMR64fc_Direct_16sc_Sfs');
  ippsFIRMR64f_Direct_16s_ISfs:=getProc(hh,'ippsFIRMR64f_Direct_16s_ISfs');
  ippsFIRMR64fc_Direct_16sc_ISfs:=getProc(hh,'ippsFIRMR64fc_Direct_16sc_ISfs');
  ippsFIRMR32s_Direct_16s_Sfs:=getProc(hh,'ippsFIRMR32s_Direct_16s_Sfs');
  ippsFIRMR32sc_Direct_16sc_Sfs:=getProc(hh,'ippsFIRMR32sc_Direct_16sc_Sfs');
  ippsFIRMR32s_Direct_16s_ISfs:=getProc(hh,'ippsFIRMR32s_Direct_16s_ISfs');
  ippsFIRMR32sc_Direct_16sc_ISfs:=getProc(hh,'ippsFIRMR32sc_Direct_16sc_ISfs');
  ippsFIR_Direct_16s_Sfs:=getProc(hh,'ippsFIR_Direct_16s_Sfs');
  ippsFIR_Direct_16s_ISfs:=getProc(hh,'ippsFIR_Direct_16s_ISfs');
  ippsFIROne_Direct_16s_Sfs:=getProc(hh,'ippsFIROne_Direct_16s_Sfs');
  ippsFIROne_Direct_16s_ISfs:=getProc(hh,'ippsFIROne_Direct_16s_ISfs');
  ippsFIRGenLowpass_64f:=getProc(hh,'ippsFIRGenLowpass_64f');
  ippsFIRGenHighpass_64f:=getProc(hh,'ippsFIRGenHighpass_64f');
  ippsFIRGenBandpass_64f:=getProc(hh,'ippsFIRGenBandpass_64f');
  ippsFIRGenBandstop_64f:=getProc(hh,'ippsFIRGenBandstop_64f');
  ippsWinBartlett_16s_I:=getProc(hh,'ippsWinBartlett_16s_I');
  ippsWinBartlett_16sc_I:=getProc(hh,'ippsWinBartlett_16sc_I');
  ippsWinBartlett_32f_I:=getProc(hh,'ippsWinBartlett_32f_I');
  ippsWinBartlett_32fc_I:=getProc(hh,'ippsWinBartlett_32fc_I');
  ippsWinBartlett_16s:=getProc(hh,'ippsWinBartlett_16s');
  ippsWinBartlett_16sc:=getProc(hh,'ippsWinBartlett_16sc');
  ippsWinBartlett_32f:=getProc(hh,'ippsWinBartlett_32f');
  ippsWinBartlett_32fc:=getProc(hh,'ippsWinBartlett_32fc');
  ippsWinBartlett_64f:=getProc(hh,'ippsWinBartlett_64f');
  ippsWinBartlett_64fc:=getProc(hh,'ippsWinBartlett_64fc');
  ippsWinBartlett_64f_I:=getProc(hh,'ippsWinBartlett_64f_I');
  ippsWinBartlett_64fc_I:=getProc(hh,'ippsWinBartlett_64fc_I');
  ippsWinHann_16s_I:=getProc(hh,'ippsWinHann_16s_I');
  ippsWinHann_16sc_I:=getProc(hh,'ippsWinHann_16sc_I');
  ippsWinHann_32f_I:=getProc(hh,'ippsWinHann_32f_I');
  ippsWinHann_32fc_I:=getProc(hh,'ippsWinHann_32fc_I');
  ippsWinHann_16s:=getProc(hh,'ippsWinHann_16s');
  ippsWinHann_16sc:=getProc(hh,'ippsWinHann_16sc');
  ippsWinHann_32f:=getProc(hh,'ippsWinHann_32f');
  ippsWinHann_32fc:=getProc(hh,'ippsWinHann_32fc');
  ippsWinHann_64f_I:=getProc(hh,'ippsWinHann_64f_I');
  ippsWinHann_64fc_I:=getProc(hh,'ippsWinHann_64fc_I');
  ippsWinHann_64f:=getProc(hh,'ippsWinHann_64f');
  ippsWinHann_64fc:=getProc(hh,'ippsWinHann_64fc');
  ippsWinHamming_16s_I:=getProc(hh,'ippsWinHamming_16s_I');
  ippsWinHamming_16sc_I:=getProc(hh,'ippsWinHamming_16sc_I');
  ippsWinHamming_32f_I:=getProc(hh,'ippsWinHamming_32f_I');
  ippsWinHamming_32fc_I:=getProc(hh,'ippsWinHamming_32fc_I');
  ippsWinHamming_16s:=getProc(hh,'ippsWinHamming_16s');
  ippsWinHamming_16sc:=getProc(hh,'ippsWinHamming_16sc');
  ippsWinHamming_32f:=getProc(hh,'ippsWinHamming_32f');
  ippsWinHamming_32fc:=getProc(hh,'ippsWinHamming_32fc');
  ippsWinHamming_64f:=getProc(hh,'ippsWinHamming_64f');
  ippsWinHamming_64fc:=getProc(hh,'ippsWinHamming_64fc');
  ippsWinHamming_64f_I:=getProc(hh,'ippsWinHamming_64f_I');
  ippsWinHamming_64fc_I:=getProc(hh,'ippsWinHamming_64fc_I');
  ippsWinBlackmanQ15_16s_ISfs:=getProc(hh,'ippsWinBlackmanQ15_16s_ISfs');
  ippsWinBlackmanQ15_16s_I:=getProc(hh,'ippsWinBlackmanQ15_16s_I');
  ippsWinBlackmanQ15_16sc_I:=getProc(hh,'ippsWinBlackmanQ15_16sc_I');
  ippsWinBlackman_16s_I:=getProc(hh,'ippsWinBlackman_16s_I');
  ippsWinBlackman_16sc_I:=getProc(hh,'ippsWinBlackman_16sc_I');
  ippsWinBlackman_32f_I:=getProc(hh,'ippsWinBlackman_32f_I');
  ippsWinBlackman_32fc_I:=getProc(hh,'ippsWinBlackman_32fc_I');
  ippsWinBlackmanQ15_16s:=getProc(hh,'ippsWinBlackmanQ15_16s');
  ippsWinBlackmanQ15_16sc:=getProc(hh,'ippsWinBlackmanQ15_16sc');
  ippsWinBlackman_16s:=getProc(hh,'ippsWinBlackman_16s');
  ippsWinBlackman_16sc:=getProc(hh,'ippsWinBlackman_16sc');
  ippsWinBlackman_32f:=getProc(hh,'ippsWinBlackman_32f');
  ippsWinBlackman_32fc:=getProc(hh,'ippsWinBlackman_32fc');
  ippsWinBlackmanStd_16s_I:=getProc(hh,'ippsWinBlackmanStd_16s_I');
  ippsWinBlackmanStd_16sc_I:=getProc(hh,'ippsWinBlackmanStd_16sc_I');
  ippsWinBlackmanStd_32f_I:=getProc(hh,'ippsWinBlackmanStd_32f_I');
  ippsWinBlackmanStd_32fc_I:=getProc(hh,'ippsWinBlackmanStd_32fc_I');
  ippsWinBlackmanOpt_16s_I:=getProc(hh,'ippsWinBlackmanOpt_16s_I');
  ippsWinBlackmanOpt_16sc_I:=getProc(hh,'ippsWinBlackmanOpt_16sc_I');
  ippsWinBlackmanOpt_32f_I:=getProc(hh,'ippsWinBlackmanOpt_32f_I');
  ippsWinBlackmanOpt_32fc_I:=getProc(hh,'ippsWinBlackmanOpt_32fc_I');
  ippsWinBlackmanStd_16s:=getProc(hh,'ippsWinBlackmanStd_16s');
  ippsWinBlackmanStd_16sc:=getProc(hh,'ippsWinBlackmanStd_16sc');
  ippsWinBlackmanStd_32f:=getProc(hh,'ippsWinBlackmanStd_32f');
  ippsWinBlackmanStd_32fc:=getProc(hh,'ippsWinBlackmanStd_32fc');
  ippsWinBlackmanOpt_16s:=getProc(hh,'ippsWinBlackmanOpt_16s');
  ippsWinBlackmanOpt_16sc:=getProc(hh,'ippsWinBlackmanOpt_16sc');
  ippsWinBlackmanOpt_32f:=getProc(hh,'ippsWinBlackmanOpt_32f');
  ippsWinBlackmanOpt_32fc:=getProc(hh,'ippsWinBlackmanOpt_32fc');
  ippsWinBlackman_64f_I:=getProc(hh,'ippsWinBlackman_64f_I');
  ippsWinBlackman_64fc_I:=getProc(hh,'ippsWinBlackman_64fc_I');
  ippsWinBlackman_64f:=getProc(hh,'ippsWinBlackman_64f');
  ippsWinBlackman_64fc:=getProc(hh,'ippsWinBlackman_64fc');
  ippsWinBlackmanStd_64f_I:=getProc(hh,'ippsWinBlackmanStd_64f_I');
  ippsWinBlackmanStd_64fc_I:=getProc(hh,'ippsWinBlackmanStd_64fc_I');
  ippsWinBlackmanStd_64f:=getProc(hh,'ippsWinBlackmanStd_64f');
  ippsWinBlackmanStd_64fc:=getProc(hh,'ippsWinBlackmanStd_64fc');
  ippsWinBlackmanOpt_64f_I:=getProc(hh,'ippsWinBlackmanOpt_64f_I');
  ippsWinBlackmanOpt_64fc_I:=getProc(hh,'ippsWinBlackmanOpt_64fc_I');
  ippsWinBlackmanOpt_64f:=getProc(hh,'ippsWinBlackmanOpt_64f');
  ippsWinBlackmanOpt_64fc:=getProc(hh,'ippsWinBlackmanOpt_64fc');
  ippsWinKaiser_16s:=getProc(hh,'ippsWinKaiser_16s');
  ippsWinKaiser_16s_I:=getProc(hh,'ippsWinKaiser_16s_I');
  ippsWinKaiserQ15_16s:=getProc(hh,'ippsWinKaiserQ15_16s');
  ippsWinKaiserQ15_16s_I:=getProc(hh,'ippsWinKaiserQ15_16s_I');
  ippsWinKaiser_16sc:=getProc(hh,'ippsWinKaiser_16sc');
  ippsWinKaiser_16sc_I:=getProc(hh,'ippsWinKaiser_16sc_I');
  ippsWinKaiserQ15_16sc:=getProc(hh,'ippsWinKaiserQ15_16sc');
  ippsWinKaiserQ15_16sc_I:=getProc(hh,'ippsWinKaiserQ15_16sc_I');
  ippsWinKaiser_32f:=getProc(hh,'ippsWinKaiser_32f');
  ippsWinKaiser_32f_I:=getProc(hh,'ippsWinKaiser_32f_I');
  ippsWinKaiser_32fc:=getProc(hh,'ippsWinKaiser_32fc');
  ippsWinKaiser_32fc_I:=getProc(hh,'ippsWinKaiser_32fc_I');
  ippsWinKaiser_64f:=getProc(hh,'ippsWinKaiser_64f');
  ippsWinKaiser_64f_I:=getProc(hh,'ippsWinKaiser_64f_I');
  ippsWinKaiser_64fc_I:=getProc(hh,'ippsWinKaiser_64fc_I');
  ippsWinKaiser_64fc:=getProc(hh,'ippsWinKaiser_64fc');
  ippsFilterMedian_32f_I:=getProc(hh,'ippsFilterMedian_32f_I');
  ippsFilterMedian_64f_I:=getProc(hh,'ippsFilterMedian_64f_I');
  ippsFilterMedian_16s_I:=getProc(hh,'ippsFilterMedian_16s_I');
  ippsFilterMedian_8u_I:=getProc(hh,'ippsFilterMedian_8u_I');
  ippsFilterMedian_32f:=getProc(hh,'ippsFilterMedian_32f');
  ippsFilterMedian_64f:=getProc(hh,'ippsFilterMedian_64f');
  ippsFilterMedian_16s:=getProc(hh,'ippsFilterMedian_16s');
  ippsFilterMedian_8u:=getProc(hh,'ippsFilterMedian_8u');
  ippsFilterMedian_32s_I:=getProc(hh,'ippsFilterMedian_32s_I');
  ippsFilterMedian_32s:=getProc(hh,'ippsFilterMedian_32s');
  ippsNorm_Inf_16s32f:=getProc(hh,'ippsNorm_Inf_16s32f');
  ippsNorm_Inf_16s32s_Sfs:=getProc(hh,'ippsNorm_Inf_16s32s_Sfs');
  ippsNorm_Inf_32f:=getProc(hh,'ippsNorm_Inf_32f');
  ippsNorm_Inf_64f:=getProc(hh,'ippsNorm_Inf_64f');
  ippsNorm_L1_16s32f:=getProc(hh,'ippsNorm_L1_16s32f');
  ippsNorm_L1_16s32s_Sfs:=getProc(hh,'ippsNorm_L1_16s32s_Sfs');
  ippsNorm_L1_32f:=getProc(hh,'ippsNorm_L1_32f');
  ippsNorm_L1_64f:=getProc(hh,'ippsNorm_L1_64f');
  ippsNorm_L2_16s32f:=getProc(hh,'ippsNorm_L2_16s32f');
  ippsNorm_L2_16s32s_Sfs:=getProc(hh,'ippsNorm_L2_16s32s_Sfs');
  ippsNorm_L2_32f:=getProc(hh,'ippsNorm_L2_32f');
  ippsNorm_L2_64f:=getProc(hh,'ippsNorm_L2_64f');
  ippsNormDiff_Inf_16s32f:=getProc(hh,'ippsNormDiff_Inf_16s32f');
  ippsNormDiff_Inf_16s32s_Sfs:=getProc(hh,'ippsNormDiff_Inf_16s32s_Sfs');
  ippsNormDiff_Inf_32f:=getProc(hh,'ippsNormDiff_Inf_32f');
  ippsNormDiff_Inf_64f:=getProc(hh,'ippsNormDiff_Inf_64f');
  ippsNormDiff_L1_16s32f:=getProc(hh,'ippsNormDiff_L1_16s32f');
  ippsNormDiff_L1_16s32s_Sfs:=getProc(hh,'ippsNormDiff_L1_16s32s_Sfs');
  ippsNormDiff_L1_32f:=getProc(hh,'ippsNormDiff_L1_32f');
  ippsNormDiff_L1_64f:=getProc(hh,'ippsNormDiff_L1_64f');
  ippsNormDiff_L2_16s32f:=getProc(hh,'ippsNormDiff_L2_16s32f');
  ippsNormDiff_L2_16s32s_Sfs:=getProc(hh,'ippsNormDiff_L2_16s32s_Sfs');
  ippsNormDiff_L2_32f:=getProc(hh,'ippsNormDiff_L2_32f');
  ippsNormDiff_L2_64f:=getProc(hh,'ippsNormDiff_L2_64f');
  ippsNorm_Inf_32fc32f:=getProc(hh,'ippsNorm_Inf_32fc32f');
  ippsNorm_L1_32fc64f:=getProc(hh,'ippsNorm_L1_32fc64f');
  ippsNorm_L2_32fc64f:=getProc(hh,'ippsNorm_L2_32fc64f');
  ippsNormDiff_Inf_32fc32f:=getProc(hh,'ippsNormDiff_Inf_32fc32f');
  ippsNormDiff_L1_32fc64f:=getProc(hh,'ippsNormDiff_L1_32fc64f');
  ippsNormDiff_L2_32fc64f:=getProc(hh,'ippsNormDiff_L2_32fc64f');
  ippsNorm_Inf_64fc64f:=getProc(hh,'ippsNorm_Inf_64fc64f');
  ippsNorm_L1_64fc64f:=getProc(hh,'ippsNorm_L1_64fc64f');
  ippsNorm_L2_64fc64f:=getProc(hh,'ippsNorm_L2_64fc64f');
  ippsNormDiff_Inf_64fc64f:=getProc(hh,'ippsNormDiff_Inf_64fc64f');
  ippsNormDiff_L1_64fc64f:=getProc(hh,'ippsNormDiff_L1_64fc64f');
  ippsNormDiff_L2_64fc64f:=getProc(hh,'ippsNormDiff_L2_64fc64f');
  ippsCrossCorr_32f:=getProc(hh,'ippsCrossCorr_32f');
  ippsCrossCorr_64f:=getProc(hh,'ippsCrossCorr_64f');
  ippsCrossCorr_32fc:=getProc(hh,'ippsCrossCorr_32fc');
  ippsCrossCorr_64fc:=getProc(hh,'ippsCrossCorr_64fc');
  ippsCrossCorr_16s_Sfs:=getProc(hh,'ippsCrossCorr_16s_Sfs');
  ippsAutoCorr_32f:=getProc(hh,'ippsAutoCorr_32f');
  ippsAutoCorr_NormA_32f:=getProc(hh,'ippsAutoCorr_NormA_32f');
  ippsAutoCorr_NormB_32f:=getProc(hh,'ippsAutoCorr_NormB_32f');
  ippsAutoCorr_64f:=getProc(hh,'ippsAutoCorr_64f');
  ippsAutoCorr_NormA_64f:=getProc(hh,'ippsAutoCorr_NormA_64f');
  ippsAutoCorr_NormB_64f:=getProc(hh,'ippsAutoCorr_NormB_64f');
  ippsAutoCorr_32fc:=getProc(hh,'ippsAutoCorr_32fc');
  ippsAutoCorr_NormA_32fc:=getProc(hh,'ippsAutoCorr_NormA_32fc');
  ippsAutoCorr_NormB_32fc:=getProc(hh,'ippsAutoCorr_NormB_32fc');
  ippsAutoCorr_64fc:=getProc(hh,'ippsAutoCorr_64fc');
  ippsAutoCorr_NormA_64fc:=getProc(hh,'ippsAutoCorr_NormA_64fc');
  ippsAutoCorr_NormB_64fc:=getProc(hh,'ippsAutoCorr_NormB_64fc');
  ippsAutoCorr_16s_Sfs:=getProc(hh,'ippsAutoCorr_16s_Sfs');
  ippsAutoCorr_NormA_16s_Sfs:=getProc(hh,'ippsAutoCorr_NormA_16s_Sfs');
  ippsAutoCorr_NormB_16s_Sfs:=getProc(hh,'ippsAutoCorr_NormB_16s_Sfs');
  ippsSampleUp_32f:=getProc(hh,'ippsSampleUp_32f');
  ippsSampleUp_32fc:=getProc(hh,'ippsSampleUp_32fc');
  ippsSampleUp_64f:=getProc(hh,'ippsSampleUp_64f');
  ippsSampleUp_64fc:=getProc(hh,'ippsSampleUp_64fc');
  ippsSampleUp_16s:=getProc(hh,'ippsSampleUp_16s');
  ippsSampleUp_16sc:=getProc(hh,'ippsSampleUp_16sc');
  ippsSampleDown_32f:=getProc(hh,'ippsSampleDown_32f');
  ippsSampleDown_32fc:=getProc(hh,'ippsSampleDown_32fc');
  ippsSampleDown_64f:=getProc(hh,'ippsSampleDown_64f');
  ippsSampleDown_64fc:=getProc(hh,'ippsSampleDown_64fc');
  ippsSampleDown_16s:=getProc(hh,'ippsSampleDown_16s');
  ippsSampleDown_16sc:=getProc(hh,'ippsSampleDown_16sc');
  ippsGetVarPointDV_16sc:=getProc(hh,'ippsGetVarPointDV_16sc');
  ippsCalcStatesDV_16sc:=getProc(hh,'ippsCalcStatesDV_16sc');
  ippsBuildSymblTableDV4D_16sc:=getProc(hh,'ippsBuildSymblTableDV4D_16sc');
  ippsUpdatePathMetricsDV_16u:=getProc(hh,'ippsUpdatePathMetricsDV_16u');
  ippsHilbertInitAlloc_32f32fc:=getProc(hh,'ippsHilbertInitAlloc_32f32fc');
  ippsHilbertInitAlloc_16s32fc:=getProc(hh,'ippsHilbertInitAlloc_16s32fc');
  ippsHilbertInitAlloc_16s16sc:=getProc(hh,'ippsHilbertInitAlloc_16s16sc');
  ippsHilbertFree_32f32fc:=getProc(hh,'ippsHilbertFree_32f32fc');
  ippsHilbertFree_16s32fc:=getProc(hh,'ippsHilbertFree_16s32fc');
  ippsHilbertFree_16s16sc:=getProc(hh,'ippsHilbertFree_16s16sc');
  ippsHilbert_32f32fc:=getProc(hh,'ippsHilbert_32f32fc');
  ippsHilbert_16s32fc:=getProc(hh,'ippsHilbert_16s32fc');
  ippsHilbert_16s16sc_Sfs:=getProc(hh,'ippsHilbert_16s16sc_Sfs');

end;

function InitIPPS:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(AppDir+'IPP\'+DLLname1);
  {$IFNDEF WIN64}
  if hh=0 then hh:=GloadLibrary(DLLname2);
  {$ENDIF}

  result:=(hh<>0);
  if not result then exit;
  messageCentral('IPPS loaded');

  //ff:=TfileStream.create( 'D:\IppDebug.txt',fmCreate);
  InitIpps1;
  InitIpps2;
  InitIpps3;
  //ff.free;
end;


procedure freeIPPS;
begin
  if hh<>0 then freeLibrary(hh);
  hh:=0;
end;

var
  FPUmask:TFPUexceptionMask;

procedure IPPStest;
Const
  First:boolean=true;
begin
 // FPUmask:=getExceptionMask;

  if not initIPPS then
  begin
    if First then
    begin
      messageCentral('Unable to initialize IPP library');
      First:=false;
    end;
    sortieErreur('Unable to initialize IPP library');
  end;
end;

procedure IPPSend;
begin
  setPrecisionMode(pmExtended);
  //SetExceptionMask([exInvalidOp, exDenormalized, exUnderflow])
end;


end.
