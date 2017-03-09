Unit ippsovr;

{ ippsovr devrait rendre plus facile l'utilisation de ipps.pas en utilisant les overload

  Exemple: ippsAddC_16s_I, ippsAddC_32f_I, ippsAddC_64f_I, ... deviennent ippsAddC

  Toutefois, toutes les déclarations de ce genre n'ont pas pu être mises en overload
  (listes de paramètres identiques)
}

INTERFACE

uses ippdefs,ipps;


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

(*   #if !defined( __IPPS_H__ ) || defined( _OWN_BLDPCS )
#define __IPPS_H__

(*   #ifndef __IPPDEFS_H__
#include "ippdefs.h"
#endif  *)

(*   #ifdef __cplusplus
extern "C" {
#endif  *)

(*   #if !defined( _OWN_BLDPCS )
typedef struct {
    int left;
    int right;
} IppsROI;
#endif /* _OWN_BLDPCS */  *)


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetStatusString
//  Purpose:    convert the library status code to a readable string
//  Parameters:
//    StsCode   IPP status code
//  Returns:    pointer to string describing the library status code
//
//  Notes:      don't free the pointer
*)
{ function ippGetStatusString(StsCode:IppStatus):Pansichar; }

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetCpuType
//  Purpose:    detects CPU type
//  Parameter:  none
//  Return:     IppCpuType
//
*)

{ function ippGetCpuType:IppCpuType; }

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippGetCpuClocks
//  Purpose:    reading of time stamp counter (TSC) register value
//  Returns:    TSC value
//
//  Note:      An hardware exception is possible if TSC reading is not supported by
/              the current chipset
*)

{ function ippGetCpuClocks:Ipp64u; }


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

{ function ippSetFlushToZero(value:longint;pUMask:PlongWord):IppStatus; }
{ function ippSetDenormAreZeros(value:longint):IppStatus; }



(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsGetLibVersion
//  Purpose:    get the library version
//  Parameters:
//  Returns:    pointer to structure describing version of the ipps library
//
//  Notes:      don't free the pointer
*)
{ function ippsGetLibVersion:PIppLibraryVersion; }

(* /////////////////////////////////////////////////////////////////////////////
//                   Functions to allocate and free memory
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMalloc
//  Purpose:    32-byte aligned memory allocation
//  Parameter:
//    len       number of elements (according to their type)
//  Returns:    pointer to allocated memory
//
//  Notes:      the memory allocated by ippsMalloc has to be free by ippsFree
//              function only.
*)

function ippsMalloc(len:int64):pointer;overload;
{ function ippsMalloc_16u(len:longint):PIpp16u; }
{ function ippsMalloc_32u(len:longint):PIpp32u; }
{ function ippsMalloc_8s(len:longint):PIpp8s; }
{ function ippsMalloc_16s(len:longint):PIpp16s; }
{ function ippsMalloc_32s(len:longint):PIpp32s; }
{ function ippsMalloc_64s(len:longint):PIpp64s; }

{ function ippsMalloc_32f(len:longint):PIpp32f; }
{ function ippsMalloc_64f(len:longint):PIpp64f; }

{ function ippsMalloc_8sc(len:longint):PIpp8sc; }
{ function ippsMalloc_16sc(len:longint):PIpp16sc; }
{ function ippsMalloc_32sc(len:longint):PIpp32sc; }
{ function ippsMalloc_64sc(len:longint):PIpp64sc; }
{ function ippsMalloc_32fc(len:longint):PIpp32fc; }
{ function ippsMalloc_64fc(len:longint):PIpp64fc; }


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFree
//  Purpose:    free memory allocated by the ippsMalloc functions
//  Parameter:
//    ptr       pointer to the memory allocated by the ippsMalloc functions
//
//  Notes:      use the function to free memory allocated by ippsMalloc_*
*)
{ procedure ippsFree(ptr:pointer); }



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

function ippsCopy(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsCopy(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsCopy(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsCopy(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsCopy(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsCopy(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsCopy(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;


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

function ippsMove(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsMove(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsMove(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsMove(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMove(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsMove(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMove(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;



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

function ippsZero(pDst: pointer;len: int64):IppStatus;overload;

function ippsZero(pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsZero(pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsZero(pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsZero(pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsZero(pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsZero(pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsZero(pDst:PIpp64fc;len:longint):IppStatus;overload;

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

function ippsSet(val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsSet(val:Ipp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsSet(val:Ipp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsSet(val:Ipp32s;pDst:PIpp32s;len:longint):IppStatus;overload;
function ippsSet(val:Ipp32sc;pDst:PIpp32sc;len:longint):IppStatus;overload;
function ippsSet(val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSet(val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSet(val:Ipp64s;pDst:PIpp64s;len:longint):IppStatus;overload;
function ippsSet(val:Ipp64sc;pDst:PIpp64sc;len:longint):IppStatus;overload;
function ippsSet(val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSet(val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

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

function ippsRandUniform_Direct(pDst:PIpp16s;len:longint;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;overload;
function ippsRandUniform_Direct(pDst:PIpp32f;len:longint;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;overload;
function ippsRandUniform_Direct(pDst:PIpp64f;len:longint;low:Ipp64f;high:Ipp64f;pSeed:PlongWord):IppStatus;overload;

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

function ippsRandGauss_Direct(pDst:PIpp16s;len:longint;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;overload;
function ippsRandGauss_Direct(pDst:PIpp32f;len:longint;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;overload;
function ippsRandGauss_Direct(pDst:PIpp64f;len:longint;mean:Ipp64f;stdev:Ipp64f;pSeed:PlongWord):IppStatus;overload;

(* ///////////////////////////////////////////////////////////////////////// *)
(*   #if !defined( _OWN_BLDPCS )

struct RandUniState_8u;
struct RandUniState_16s;
struct RandUniState_32f;

typedef struct RandUniState_8u IppsRandUniState_8u;
typedef struct RandUniState_16s IppsRandUniState_16s;
typedef struct RandUniState_32f IppsRandUniState_32f;

struct RandGaussState_8u;
struct RandGaussState_16s;
struct RandGaussState_32f;

typedef struct RandGaussState_8u IppsRandGaussState_8u;
typedef struct RandGaussState_16s IppsRandGaussState_16s;
typedef struct RandGaussState_32f IppsRandGaussState_32f;

#endif  *)

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
function ippsRandUniformInitAlloc(var pRandUniState:PIppsRandUniState_8u;low:Ipp8u;high:Ipp8u;seed:longWord):IppStatus;overload;

function ippsRandUniformInitAlloc(var pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;overload;

function ippsRandUniformInitAlloc(var pRandUniState:PIppsRandUniState_32f;low:Ipp32f;high:Ipp32f;seed:longWord):IppStatus;overload;

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

function ippsRandUniform(pDst:PIpp8u;len:longint;pRandUniState:PIppsRandUniState_8u):IppStatus;overload;
function ippsRandUniform(pDst:PIpp16s;len:longint;pRandUniState:PIppsRandUniState_16s):IppStatus;overload;
function ippsRandUniform(pDst:PIpp32f;len:longint;pRandUniState:PIppsRandUniState_32f):IppStatus;overload;

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

function ippsRandUniformFree(pRandUniState:PIppsRandUniState_8u):IppStatus;overload;
function ippsRandUniformFree(pRandUniState:PIppsRandUniState_16s):IppStatus;overload;
function ippsRandUniformFree(pRandUniState:PIppsRandUniState_32f):IppStatus;overload;


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
function ippsRandGaussInitAlloc(var pRandGaussState:PIppsRandGaussState_8u;mean:Ipp8u;stdDev:Ipp8u;seed:longWord):IppStatus;overload;

function ippsRandGaussInitAlloc(var pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;overload;

function ippsRandGaussInitAlloc(var pRandGaussState:PIppsRandGaussState_32f;mean:Ipp32f;stdDev:Ipp32f;seed:longWord):IppStatus;overload;

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

function ippsRandGauss(pDst:PIpp8u;len:longint;pRandGaussState:PIppsRandGaussState_8u):IppStatus;overload;
function ippsRandGauss(pDst:PIpp16s;len:longint;pRandGaussState:PIppsRandGaussState_16s):IppStatus;overload;
function ippsRandGauss(pDst:PIpp32f;len:longint;pRandGaussState:PIppsRandGaussState_32f):IppStatus;overload;

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

function ippsRandGaussFree(pRandGaussState:PIppsRandGaussState_8u):IppStatus;overload;
function ippsRandGaussFree(pRandGaussState:PIppsRandGaussState_16s):IppStatus;overload;
function ippsRandGaussFree(pRandGaussState:PIppsRandGaussState_32f):IppStatus;overload;

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
function ippsRandGaussGetSize(pRandGaussStateSize:Plongint):IppStatus;overload;

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
function ippsRandGaussInit(pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;overload;


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
function ippsRandUniformGetSize(pRandUniformStateSize:Plongint):IppStatus;overload;


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
function ippsRandUniformInit(pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;overload;




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
function ippsVectorJaehne(pDst:PIpp8u;len:longint;magn:Ipp8u):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp8s;len:longint;magn:Ipp8s):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp16u;len:longint;magn:Ipp16u):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp16s;len:longint;magn:Ipp16s):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp32u;len:longint;magn:Ipp32u):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp32s;len:longint;magn:Ipp32s):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp32f;len:longint;magn:Ipp32f):IppStatus;overload;
function ippsVectorJaehne(pDst:PIpp64f;len:longint;magn:Ipp64f):IppStatus;overload;


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


function ippsTone_Direct(pDst:PIpp32f;len:longint;magn:single;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;overload;
function ippsTone_Direct(pDst:PIpp32fc;len:longint;magn:single;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;overload;
function ippsTone_Direct(pDst:PIpp64f;len:longint;magn:double;rFreq:double;pPhase:Pdouble;hint:IppHintAlgorithm):IppStatus;overload;
function ippsTone_Direct(pDst:PIpp64fc;len:longint;magn:double;rFreq:double;pPhase:Pdouble;hint:IppHintAlgorithm):IppStatus;overload;
function ippsTone_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;overload;
function ippsTone_Direct(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;overload;

(*   #if !defined ( _OWN_BLDPCS )
struct ToneState_16s;
typedef struct ToneState_16s IppToneState_16s;
#endif  *)


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
function ippsToneInitAllocQ15(var pToneState:PIppToneState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;overload;

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
{ function ippsToneFree(pToneState:PIppToneState_16s):IppStatus; }

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
function ippsToneGetStateSizeQ15(pToneStateSize:Plongint):IppStatus;overload;

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
function ippsToneInitQ15(pToneState:PIppToneState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;overload;

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

function ippsToneQ15(pDst:PIpp16s;len:longint;pToneState:PIppToneState_16s):IppStatus;overload;


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


function ippsTriangle_Direct(pDst:PIpp64f;len:longint;magn:double;rFreq:double;asym:double;pPhase:Pdouble):IppStatus;overload;
function ippsTriangle_Direct(pDst:PIpp64fc;len:longint;magn:double;rFreq:double;asym:double;pPhase:Pdouble):IppStatus;overload;
function ippsTriangle_Direct(pDst:PIpp32f;len:longint;magn:single;rFreq:single;asym:single;pPhase:Psingle):IppStatus;overload;
function ippsTriangle_Direct(pDst:PIpp32fc;len:longint;magn:single;rFreq:single;asym:single;pPhase:Psingle):IppStatus;overload;
function ippsTriangle_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:single;asym:single;pPhase:Psingle):IppStatus;overload;
function ippsTriangle_Direct(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:single;asym:single;pPhase:Psingle):IppStatus;overload;

(*   #if !defined ( _OWN_BLDPCS )
// IPP Context triangle identification
struct TriangleState_16s;
typedef struct TriangleState_16s IppTriangleState_16s;
#endif  *)

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
function ippsTriangleInitAllocQ15(var pTriangleState:PIppTriangleState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;overload;



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
{ function ippsTriangleFree(pTriangleState:PIppTriangleState_16s):IppStatus; }



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
function ippsTriangleGetStateSizeQ15(pTriangleStateSize:Plongint):IppStatus;overload;

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
function ippsTriangleInitQ15(pTriangleState:PIppTriangleState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;overload;


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
function ippsTriangleQ15(pDst:PIpp16s;len:longint;pTriangleState:PIppTriangleState_16s):IppStatus;overload;

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
function ippsToneQ15_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;overload;


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
function ippsTriangleQ15_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;overload;



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
function ippsVectorRamp(pDst:PIpp8u;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp8s;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp16u;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp16s;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp32u;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp32s;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp32f;len:longint;offset:single;slope:single):IppStatus;overload;
function ippsVectorRamp(pDst:PIpp64f;len:longint;offset:single;slope:single):IppStatus;overload;



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

function ippsReal(pSrc:PIpp64fc;pDstRe:PIpp64f;len:longint):IppStatus;overload;
function ippsReal(pSrc:PIpp32fc;pDstRe:PIpp32f;len:longint):IppStatus;overload;
function ippsReal(pSrc:PIpp16sc;pDstRe:PIpp16s;len:longint):IppStatus;overload;

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

function ippsImag(pSrc:PIpp64fc;pDstIm:PIpp64f;len:longint):IppStatus;overload;
function ippsImag(pSrc:PIpp32fc;pDstIm:PIpp32f;len:longint):IppStatus;overload;
function ippsImag(pSrc:PIpp16sc;pDstIm:PIpp16s;len:longint):IppStatus;overload;

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

function ippsCplxToReal(pSrc:PIpp64fc;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;overload;
function ippsCplxToReal(pSrc:PIpp32fc;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;overload;
function ippsCplxToReal(pSrc:PIpp16sc;pDstRe:PIpp16s;pDstIm:PIpp16s;len:longint):IppStatus;overload;

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

function ippsRealToCplx(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsRealToCplx(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsRealToCplx(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16sc;len:longint):IppStatus;overload;




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

function ippsConj(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsConj(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsConj(pSrcDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsConj(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsConj(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsConj(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsConjFlip(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsConjFlip(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsConjFlip(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsConjCcs(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;overload;
function ippsConjCcs(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;overload;
function ippsConjCcs(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;overload;
function ippsConjCcs(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;overload;
function ippsConjCcs(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;overload;
function ippsConjCcs(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;overload;
function ippsConjPack(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;overload;
function ippsConjPack(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;overload;
function ippsConjPack(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;overload;
function ippsConjPack(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;overload;
function ippsConjPack(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;overload;
function ippsConjPack(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;overload;
function ippsConjPerm(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;overload;
function ippsConjPerm(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;overload;
function ippsConjPerm(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;overload;
function ippsConjPerm(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;overload;
function ippsConjPerm(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;overload;
function ippsConjPerm(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;overload;

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
function ippsConvert(pSrc:PIpp8s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp16s;pDst:PIpp32s;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp8s;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp16u;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp32f;len:longint):IppStatus;overload;

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

function ippsConvert(pSrc:PIpp32f;pDst:PIpp8s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32f;pDst:PIpp8u;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32f;pDst:PIpp16s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32f;pDst:PIpp16u;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp64f;pDst:PIpp32s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32f;pDst:PIpp32s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;


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

function ippsConvert(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;overload;


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

function ippsConvert(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;overload;

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

function ippsConvert(pSrc:PIpp16s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp16s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;

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

function ippsConvert(pSrc:PIpp8u;pDst:PIpp32u;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
{ function ippsConvert_24u32f(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus; }
function ippsConvert(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp8u;pDst:PIpp32s;len:longint):IppStatus;overload;
function ippsConvert(pSrc:PIpp32s;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
{ function ippsConvert_24s32f(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus; }
{ function ippsConvert_32f24s_Sfs(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus; }


(*   #if !defined( _OWN_BLDPCS )
typedef Ipp16s Ipp16f;
#endif  *)

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

function ippsConvert(pSrc:PIpp16s;pDst:PIpp16f;len:longint;rndmode:IppRoundMode):IppStatus;overload;

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
function ippsConvert(pSrc:PIpp16f;pDst:PIpp16s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;overload;

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
function ippsConvert(pSrc:PIpp32f;pDst:PIpp16f;len:longint;rndmode:IppRoundMode):IppStatus;overload;

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
function ippsConvert(pSrc:PIpp16f;pDst:PIpp32f;len:longint):IppStatus;overload;




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

function ippsThreshold(pSrcDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrcDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrcDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;overload;

function ippsThreshold(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;overload;
function ippsThreshold(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;overload;

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
function ippsThreshold_LT(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LT(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LT(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_LT(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_LT(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;overload;
function ippsThreshold_LT(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;overload;

function ippsThreshold_LT(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;overload;
function ippsThreshold_LT(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;overload;

function ippsThreshold_GT(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_GT(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_GT(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_GT(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_GT(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;overload;
function ippsThreshold_GT(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;overload;
function ippsThreshold_GT(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_GT(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_GT(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_GT(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_GT(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;overload;
function ippsThreshold_GT(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;overload;

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
function ippsThreshold_LTVal(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;overload;
function ippsThreshold_LTVal(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;overload;
function ippsThreshold_LTVal(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;overload;
function ippsThreshold_LTVal(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;overload;
function ippsThreshold_LTVal(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;overload;
function ippsThreshold_LTVal(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;overload;
function ippsThreshold_LTVal(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;overload;
function ippsThreshold_LTVal(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;overload;
function ippsThreshold_LTVal(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;overload;
function ippsThreshold_LTVal(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;overload;
function ippsThreshold_LTVal(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;overload;
function ippsThreshold_LTVal(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;overload;
function ippsThreshold_GTVal(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;overload;
function ippsThreshold_GTVal(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;overload;
function ippsThreshold_GTVal(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;overload;
function ippsThreshold_GTVal(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;overload;
function ippsThreshold_GTVal(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;overload;
function ippsThreshold_GTVal(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;overload;
function ippsThreshold_GTVal(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;overload;
function ippsThreshold_GTVal(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;overload;
function ippsThreshold_GTVal(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;overload;
function ippsThreshold_GTVal(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;overload;
function ippsThreshold_GTVal(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;overload;
function ippsThreshold_GTVal(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;overload;


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

function ippsThreshold_LTInv(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LTInv(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LTInv(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_LTInv(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;overload;

function ippsThreshold_LTInv(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LTInv(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;overload;
function ippsThreshold_LTInv(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;overload;
function ippsThreshold_LTInv(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;overload;

(* ///////////////////////////////////////////////////////////////////////////// *)


function ippsThreshold_LTValGTVal(pSrcDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;overload;
function ippsThreshold_LTValGTVal(pSrcDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;overload;
function ippsThreshold_LTValGTVal(pSrc:PIpp32f;pDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;overload;
function ippsThreshold_LTValGTVal(pSrc:PIpp64f;pDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;overload;

function ippsThreshold_LTValGTVal(pSrcDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;overload;
function ippsThreshold_LTValGTVal(pSrc:PIpp16s;pDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;overload;




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

function ippsCartToPolar(pSrc:PIpp32fc;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;overload;
function ippsCartToPolar(pSrc:PIpp64fc;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;overload;

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

function ippsCartToPolar(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;overload;
function ippsCartToPolar(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;overload;

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

function ippsPolarToCart(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsPolarToCart(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;overload;

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

function ippsPolarToCart(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;overload;
function ippsPolarToCart(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;overload;

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
function ippsALawToLin(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsALawToLin(pSrc:PIpp8u;pDst:PIpp16s;len:longint):IppStatus;overload;

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
function ippsMuLawToLin(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMuLawToLin(pSrc:PIpp8u;pDst:PIpp16s;len:longint):IppStatus;overload;

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
function ippsLinToALaw(pSrc:PIpp32f;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsLinToALaw(pSrc:PIpp16s;pDst:PIpp8u;len:longint):IppStatus;overload;

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
function ippsLinToMuLaw(pSrc:PIpp32f;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsLinToMuLaw(pSrc:PIpp16s;pDst:PIpp8u;len:longint):IppStatus;overload;

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
function ippsALawToMuLaw(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsMuLawToALaw(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;

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
function ippsPreemphasize(pSrcDst:PIpp32f;len:longint;val:Ipp32f):IppStatus;overload;
function ippsPreemphasize(pSrcDst:PIpp16s;len:longint;val:Ipp32f):IppStatus;overload;



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

function ippsFlip(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsFlip(pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsFlip(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsFlip(pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsFlip(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsFlip(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsFlip(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsFlip(pSrcDst:PIpp64f;len:longint):IppStatus;overload;


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
function ippsUpdateLinear(pSrc:PIpp16s;len:longint;pSrcDst:PIpp32s;srcShiftRight:longint;alpha:Ipp16s;hint:IppHintAlgorithm):IppStatus;overload;

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
function ippsUpdatePower(pSrc:PIpp16s;len:longint;pSrcDst:PIpp32s;srcShiftRight:longint;alpha:Ipp16s;hint:IppHintAlgorithm):IppStatus;overload;

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

function ippsJoin(var pSrc:PIpp32f;nChannels:longint;chanLen:longint;pDst:PIpp16s):IppStatus;overload;

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

function ippsSwapBytes(pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsSwapBytes(pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsSwapBytes(pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsSwapBytes(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsSwapBytes(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsSwapBytes(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  Arithmetic functions
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

function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsAddC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAddC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSubC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSubC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsMulC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMulC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsAddC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsAddC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsSubC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSubC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsMulC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMulC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC_Low(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint):IppStatus;overload;


function ippsAddC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsAddC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsAddC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSubCRev(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;


function ippsAdd(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAdd(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSub(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp16u;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;


function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;

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

function ippsAddProduct(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddProduct(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddProduct(pSrc1:PIpp32s;pSrc2:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsAddProduct(pSrc1:PIpp32f;pSrc2:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAddProduct(pSrc1:PIpp64f;pSrc2:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;

function ippsAddProduct(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsAddProduct(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;


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
function ippsSqr(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSqr(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSqr(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSqr(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsSqr(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSqr(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSqr(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSqr(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsSqr(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqr(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsSqr(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqr(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqr(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqr(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqr(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqr(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;overload;


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

function ippsDiv(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsDiv(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsDiv(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsDiv(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsDiv(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDiv(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDiv(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsDivC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsDivC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsDivC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsDivC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsDivC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDivC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDivC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsDiv(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsDiv(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsDiv(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsDiv(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsDiv(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDiv(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDiv(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsDiv(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsDiv(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;ScaleFactor:longint):IppStatus;overload;


function ippsDivC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsDivC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsDivC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsDivC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsDivC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDivC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsDivC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsDivCRev(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsDivCRev(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsDivCRev(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsDivCRev(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;


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
function ippsSqrt(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSqrt(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSqrt(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSqrt(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsSqrt(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsSqrt(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqrt(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsSqrt(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsSqrt(pSrcDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsSqrt(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqrt(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsSqrt(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;overload;

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

function ippsCubrt(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;sFactor:longint):IppStatus;overload;
function ippsCubrt(pSrc:PIpp32f;pDst:PIpp32f;Len:longint):IppStatus;overload;

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
function ippsAbs(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAbs(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsAbs(pSrcDst:PIpp16s;len:longint):IppStatus;overload;

function ippsAbs(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsAbs(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsAbs(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;

function ippsAbs(pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsAbs(pSrc:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;overload;



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
function ippsMagnitude(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMagnitude(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMagnitude(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMagnitude(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMagnitude(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMagnitude(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsMagnitude(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsMagnitude(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsMagnitude(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;

function ippsMagSquared(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;


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
function ippsExp(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsExp(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsExp(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsExp(pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsExp(pSrcDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsExp(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsExp(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsExp(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsExp(pSrc:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsExp(pSrc:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsExp(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;overload;


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

function ippsLn(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsLn(pSrcDst:PIpp64f;len:longint):IppStatus;overload;

function ippsLn(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsLn(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsLn(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;overload;

function ippsLn(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsLn(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsLn(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;scaleFactor:longint):IppStatus;overload;

function ippsLn(pSrcDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;overload;
function ippsLn(pSrc:PIpp32s;pDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;overload;

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
function ipps10Log10(pSrcDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;overload;
function ipps10Log10(pSrc:PIpp32s;pDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;overload;


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


function ippsSumLn(pSrc:PIpp32f;len:longint;pSum:PIpp32f):IppStatus;overload;
function ippsSumLn(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;overload;
function ippsSumLn(pSrc:PIpp32f;len:longint;pSum:PIpp64f):IppStatus;overload;
function ippsSumLn(pSrc:PIpp16s;len:longint;pSum:PIpp32f):IppStatus;overload;

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

function ippsSortAscend(pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsSortAscend(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsSortAscend(pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsSortAscend(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSortAscend(pSrcDst:PIpp64f;len:longint):IppStatus;overload;

function ippsSortDescend(pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsSortDescend(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsSortDescend(pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsSortDescend(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsSortDescend(pSrcDst:PIpp64f;len:longint):IppStatus;overload;





(* /////////////////////////////////////////////////////////////////////////////
//                  Vector Measures Functions
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
function ippsSum(pSrc:PIpp32f;len:longint;pSum:PIpp32f; Const hint:IppHintAlgorithm=ippAlgHintNone):IppStatus;overload;
function ippsSum(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;overload;
function ippsSum(pSrc:PIpp32fc;len:longint;pSum:PIpp32fc; Const hint:IppHintAlgorithm=ippAlgHintNone):IppStatus;overload;
function ippsSum(pSrc:PIpp16s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsSum(pSrc:PIpp16sc;len:longint;pSum:PIpp32sc;scaleFactor:longint):IppStatus;overload;
function ippsSum(pSrc:PIpp16s;len:longint;pSum:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsSum(pSrc:PIpp16sc;len:longint;pSum:PIpp16sc;scaleFactor:longint):IppStatus;overload;
function ippsSum(pSrc:PIpp32s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;overload;

function ippsSum(pSrc:PIpp64fc;len:longint;pSum:PIpp64fc):IppStatus;overload;



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
function ippsMean(pSrc:PIpp32f;len:longint;pMean:PIpp32f;hint:IppHintAlgorithm):IppStatus;overload;
function ippsMean(pSrc:PIpp32fc;len:longint;pMean:PIpp32fc;hint:IppHintAlgorithm):IppStatus;overload;
function ippsMean(pSrc:PIpp64f;len:longint;pMean:PIpp64f):IppStatus;overload;
function ippsMean(pSrc:PIpp16s;len:longint;pMean:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsMean(pSrc:PIpp16sc;len:longint;pMean:PIpp16sc;scaleFactor:longint):IppStatus;overload;
function ippsMean(pSrc:PIpp64fc;len:longint;pMean:PIpp64fc):IppStatus;overload;



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
//  Functionality:
//         std = sqrt( sum( (x[n] - mean(x))^2, n=0..len-1 ) / (len-1) )
*)
function ippsStdDev(pSrc:PIpp32f;len:longint;pStdDev:PIpp32f;hint:IppHintAlgorithm):IppStatus;overload;
function ippsStdDev(pSrc:PIpp64f;len:longint;pStdDev:PIpp64f):IppStatus;overload;

function ippsStdDev(pSrc:PIpp16s;len:longint;pStdDev:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsStdDev(pSrc:PIpp16s;len:longint;pStdDev:PIpp16s;scaleFactor:longint):IppStatus;overload;


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
function ippsMax(pSrc:PIpp32f;len:longint;pMax:PIpp32f):IppStatus;overload;
function ippsMax(pSrc:PIpp64f;len:longint;pMax:PIpp64f):IppStatus;overload;
function ippsMax(pSrc:PIpp16s;len:longint;pMax:PIpp16s):IppStatus;overload;

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

function ippsMaxIndx(pSrc:PIpp16s;len:longint;pMax:PIpp16s;pIndx:Plongint):IppStatus;overload;
function ippsMaxIndx(pSrc:PIpp32f;len:longint;pMax:PIpp32f;pIndx:Plongint):IppStatus;overload;
function ippsMaxIndx(pSrc:PIpp64f;len:longint;pMax:PIpp64f;pIndx:Plongint):IppStatus;overload;

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
function ippsMin(pSrc:PIpp32f;len:longint;pMin:PIpp32f):IppStatus;overload;
function ippsMin(pSrc:PIpp64f;len:longint;pMin:PIpp64f):IppStatus;overload;
function ippsMin(pSrc:PIpp16s;len:longint;pMin:PIpp16s):IppStatus;overload;

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
function ippsMinIndx(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pIndx:Plongint):IppStatus;overload;
function ippsMinIndx(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pIndx:Plongint):IppStatus;overload;
function ippsMinIndx(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pIndx:Plongint):IppStatus;overload;

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

function ippsMinEvery(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsMinEvery(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsMinEvery(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsMaxEvery(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsMaxEvery(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsMaxEvery(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;


function ippsMinMax(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMax:PIpp64f):IppStatus;overload;
function ippsMinMax(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMax:PIpp32f):IppStatus;overload;
function ippsMinMax(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMax:PIpp32s):IppStatus;overload;
function ippsMinMax(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMax:PIpp32u):IppStatus;overload;
function ippsMinMax(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMax:PIpp16s):IppStatus;overload;
function ippsMinMax(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMax:PIpp16u):IppStatus;overload;
function ippsMinMax(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMax:PIpp8u):IppStatus;overload;


function ippsMinMaxIndx(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMinIndx:Plongint;pMax:PIpp64f;pMaxIndx:Plongint):IppStatus;overload;
function ippsMinMaxIndx(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMinIndx:Plongint;pMax:PIpp32f;pMaxIndx:Plongint):IppStatus;overload;
function ippsMinMaxIndx(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMinIndx:Plongint;pMax:PIpp32s;pMaxIndx:Plongint):IppStatus;overload;
function ippsMinMaxIndx(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMinIndx:Plongint;pMax:PIpp32u;pMaxIndx:Plongint):IppStatus;overload;
function ippsMinMaxIndx(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMinIndx:Plongint;pMax:PIpp16s;pMaxIndx:Plongint):IppStatus;overload;
function ippsMinMaxIndx(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMinIndx:Plongint;pMax:PIpp16u;pMaxIndx:Plongint):IppStatus;overload;
function ippsMinMaxIndx(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMinIndx:Plongint;pMax:PIpp8u;pMaxIndx:Plongint):IppStatus;overload;



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
function ippsPhase(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsPhase(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsPhase(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsPhase(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;

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
function ippsPhase(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsPhase(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsPhase(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsPhase(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;

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
function ippsPhase(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;

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

function ippsMaxOrder(pSrc:PIpp64f;len:longint;pOrder:Plongint):IppStatus;overload;
function ippsMaxOrder(pSrc:PIpp32f;len:longint;pOrder:Plongint):IppStatus;overload;
function ippsMaxOrder(pSrc:PIpp32s;len:longint;pOrder:Plongint):IppStatus;overload;
function ippsMaxOrder(pSrc:PIpp16s;len:longint;pOrder:Plongint):IppStatus;overload;

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

function ippsArctan(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsArctan(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsArctan(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsArctan(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;




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

function ippsFindNearestOne(inpVal:Ipp16u;pOutVal:PIpp16u;pOutIndex:Plongint;pTable:PIpp16u;tblLen:longint):IppStatus;overload;


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


function ippsFindNearest(pVals:PIpp16u;pOutVals:PIpp16u;pOutIndexes:Plongint;len:longint;pTable:PIpp16u;tblLen:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                      Vector logical functions
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

function ippsAndC(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsAndC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsAndC(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsAndC(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsAndC(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsAndC(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;overload;
function ippsAnd(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsAnd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsAnd(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsAnd(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsAnd(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsAnd(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;

function ippsOrC(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsOrC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsOrC(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsOrC(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsOrC(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsOrC(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;overload;
function ippsOr(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsOr(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsOr(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsOr(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsOr(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsOr(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;

function ippsXorC(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsXorC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsXorC(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsXorC(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsXorC(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsXorC(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;overload;
function ippsXor(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsXor(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsXor(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsXor(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsXor(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsXor(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;

function ippsNot(pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsNot(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsNot(pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsNot(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsNot(pSrcDst:PIpp32u;len:longint):IppStatus;overload;
function ippsNot(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;

function ippsLShiftC(val:longint;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsLShiftC(pSrc:PIpp8u;val:longint;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsLShiftC(val:longint;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsLShiftC(pSrc:PIpp16u;val:longint;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsLShiftC(val:longint;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsLShiftC(pSrc:PIpp16s;val:longint;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsLShiftC(val:longint;pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsLShiftC(pSrc:PIpp32s;val:longint;pDst:PIpp32s;len:longint):IppStatus;overload;

function ippsRShiftC(val:longint;pSrcDst:PIpp8u;len:longint):IppStatus;overload;
function ippsRShiftC(pSrc:PIpp8u;val:longint;pDst:PIpp8u;len:longint):IppStatus;overload;
function ippsRShiftC(val:longint;pSrcDst:PIpp16u;len:longint):IppStatus;overload;
function ippsRShiftC(pSrc:PIpp16u;val:longint;pDst:PIpp16u;len:longint):IppStatus;overload;
function ippsRShiftC(val:longint;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsRShiftC(pSrc:PIpp16s;val:longint;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsRShiftC(val:longint;pSrcDst:PIpp32s;len:longint):IppStatus;overload;
function ippsRShiftC(pSrc:PIpp32s;val:longint;pDst:PIpp32s;len:longint):IppStatus;overload;



(* /////////////////////////////////////////////////////////////////////////////
//                  Dot Product Functions
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
//     the functions don't conjugate one of the source vectors
*)

function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp32f):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;overload;

function ippsDotProd(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pDp:PIpp64f):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp64f;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;overload;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp16sc;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp16sc;scaleFactor:longint):IppStatus;overload;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp64s):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;overload;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32f):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp32fc):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp32fc):IppStatus;overload;

function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp64f):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;overload;


function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;overload;

function ippsDotProd(pSrc1:PIpp32s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp32sc;pSrc2:PIpp32sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp32s;pSrc2:PIpp32sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;overload;
function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;overload;

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



function ippsPowerSpectr(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsPowerSpectr(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsPowerSpectr(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsPowerSpectr(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;overload;

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

function ippsPowerSpectr(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;

function ippsPowerSpectr(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;

function ippsPowerSpectr(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;

function ippsPowerSpectr(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;

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
function ippsNormalize(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;vsub:Ipp64fc;vdiv:Ipp64f):IppStatus;overload;
function ippsNormalize(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;vsub:Ipp32fc;vdiv:Ipp32f):IppStatus;overload;
function ippsNormalize(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;vsub:Ipp16sc;vdiv:longint;scaleFactor:longint):IppStatus;overload;

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
function ippsNormalize(pSrc:PIpp64f;pDst:PIpp64f;len:longint;vsub:Ipp64f;vdiv:Ipp64f):IppStatus;overload;
function ippsNormalize(pSrc:PIpp32f;pDst:PIpp32f;len:longint;vsub:Ipp32f;vdiv:Ipp32f):IppStatus;overload;
function ippsNormalize(pSrc:PIpp16s;pDst:PIpp16s;len:longint;vsub:Ipp16s;vdiv:longint;scaleFactor:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for FFT Functions
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct FFTSpec_C_16sc;
typedef struct FFTSpec_C_16sc IppsFFTSpec_C_16sc;
struct FFTSpec_C_16s;
typedef struct FFTSpec_C_16s  IppsFFTSpec_C_16s;
struct FFTSpec_R_16s;
typedef struct FFTSpec_R_16s  IppsFFTSpec_R_16s;

struct FFTSpec_C_32fc;
typedef struct FFTSpec_C_32fc IppsFFTSpec_C_32fc;
struct FFTSpec_C_32f;
typedef struct FFTSpec_C_32f  IppsFFTSpec_C_32f;
struct FFTSpec_R_32f;
typedef struct FFTSpec_R_32f  IppsFFTSpec_R_32f;

struct FFTSpec_C_64fc;
typedef struct FFTSpec_C_64fc IppsFFTSpec_C_64fc;
struct FFTSpec_C_64f;
typedef struct FFTSpec_C_64f  IppsFFTSpec_C_64f;
struct FFTSpec_R_64f;
typedef struct FFTSpec_R_64f  IppsFFTSpec_R_64f;

#endif /* _OWN_BLDPCS */  *)


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Context Functions
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

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_16sc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_16s;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsFFTInitAlloc_R(var pFFTSpec:PIppsFFTSpec_R_16s;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_32fc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_32f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsFFTInitAlloc_R(var pFFTSpec:PIppsFFTSpec_R_32f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_64fc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_64f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsFFTInitAlloc_R(var pFFTSpec:PIppsFFTSpec_R_64f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;


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

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_16sc):IppStatus;overload;
function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_16s):IppStatus;overload;
function ippsFFTFree_R(pFFTSpec:PIppsFFTSpec_R_16s):IppStatus;overload;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_32fc):IppStatus;overload;
function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_32f):IppStatus;overload;
function ippsFFTFree_R(pFFTSpec:PIppsFFTSpec_R_32f):IppStatus;overload;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_64fc):IppStatus;overload;
function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_64f):IppStatus;overload;
function ippsFFTFree_R(pFFTSpec:PIppsFFTSpec_R_64f):IppStatus;overload;


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

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_16sc;pSize:Plongint):IppStatus;overload;
function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_16s;pSize:Plongint):IppStatus;overload;
function ippsFFTGetBufSize_R(pFFTSpec:PIppsFFTSpec_R_16s;pSize:Plongint):IppStatus;overload;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_32fc;pSize:Plongint):IppStatus;overload;
function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_32f;pSize:Plongint):IppStatus;overload;
function ippsFFTGetBufSize_R(pFFTSpec:PIppsFFTSpec_R_32f;pSize:Plongint):IppStatus;overload;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_64fc;pSize:Plongint):IppStatus;overload;
function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_64f;pSize:Plongint):IppStatus;overload;
function ippsFFTGetBufSize_R(pFFTSpec:PIppsFFTSpec_R_64f;pSize:Plongint):IppStatus;overload;


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

function ippsFFTFwd_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pFFTSpec:PIppsFFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pFFTSpec:PIppsFFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pFFTSpec:PIppsFFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pFFTSpec:PIppsFFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;

function ippsFFTFwd_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;overload;

function ippsFFTFwd_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;overload;


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

function ippsFFTFwd_RToPerm(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_RToPack(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_RToCCS(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_PermToR(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_PackToR(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CCSToR(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;

function ippsFFTFwd_RToPerm(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_RToPack(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_RToCCS(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_PermToR(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_PackToR(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CCSToR(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;

function ippsFFTFwd_RToPerm(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_RToPack(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTFwd_RToCCS(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_PermToR(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_PackToR(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFFTInv_CCSToR(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DFT Functions
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct DFTSpec_C_16sc;
typedef struct DFTSpec_C_16sc       IppsDFTSpec_C_16sc;
struct DFTSpec_C_16s;
typedef struct DFTSpec_C_16s        IppsDFTSpec_C_16s;
struct DFTSpec_R_16s;
typedef struct DFTSpec_R_16s        IppsDFTSpec_R_16s;

struct DFTSpec_C_32fc;
typedef struct DFTSpec_C_32fc       IppsDFTSpec_C_32fc;
struct DFTSpec_C_32f;
typedef struct DFTSpec_C_32f        IppsDFTSpec_C_32f;
struct DFTSpec_R_32f;
typedef struct DFTSpec_R_32f        IppsDFTSpec_R_32f;

struct DFTSpec_C_64fc;
typedef struct DFTSpec_C_64fc       IppsDFTSpec_C_64fc;
struct DFTSpec_C_64f;
typedef struct DFTSpec_C_64f        IppsDFTSpec_C_64f;
struct DFTSpec_R_64f;
typedef struct DFTSpec_R_64f        IppsDFTSpec_R_64f;

struct DFTOutOrdSpec_C_32fc;
typedef struct DFTOutOrdSpec_C_32fc IppsDFTOutOrdSpec_C_32fc;

struct DFTOutOrdSpec_C_64fc;
typedef struct DFTOutOrdSpec_C_64fc IppsDFTOutOrdSpec_C_64fc;

#endif /* _OWN_BLDPCS */  *)


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Context Functions
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

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_16sc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_16s;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDFTInitAlloc_R(var pDFTSpec:PIppsDFTSpec_R_16s;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_32fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_32f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDFTInitAlloc_R(var pDFTSpec:PIppsDFTSpec_R_32f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_64fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_64f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDFTInitAlloc_R(var pDFTSpec:PIppsDFTSpec_R_64f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsDFTOutOrdInitAlloc_C(var pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsDFTOutOrdInitAlloc_C(var pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;overload;


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

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_16sc):IppStatus;overload;
function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_16s):IppStatus;overload;
function ippsDFTFree_R(pDFTSpec:PIppsDFTSpec_R_16s):IppStatus;overload;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_32fc):IppStatus;overload;
function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_32f):IppStatus;overload;
function ippsDFTFree_R(pDFTSpec:PIppsDFTSpec_R_32f):IppStatus;overload;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_64fc):IppStatus;overload;
function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_64f):IppStatus;overload;
function ippsDFTFree_R(pDFTSpec:PIppsDFTSpec_R_64f):IppStatus;overload;

function ippsDFTOutOrdFree_C(pDFTSpec:PIppsDFTOutOrdSpec_C_32fc):IppStatus;overload;

function ippsDFTOutOrdFree_C(pDFTSpec:PIppsDFTOutOrdSpec_C_64fc):IppStatus;overload;


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

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_16sc;pSize:Plongint):IppStatus;overload;
function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_16s;pSize:Plongint):IppStatus;overload;
function ippsDFTGetBufSize_R(pDFTSpec:PIppsDFTSpec_R_16s;pSize:Plongint):IppStatus;overload;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_32fc;pSize:Plongint):IppStatus;overload;
function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_32f;pSize:Plongint):IppStatus;overload;
function ippsDFTGetBufSize_R(pDFTSpec:PIppsDFTSpec_R_32f;pSize:Plongint):IppStatus;overload;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_64fc;pSize:Plongint):IppStatus;overload;
function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_64f;pSize:Plongint):IppStatus;overload;
function ippsDFTGetBufSize_R(pDFTSpec:PIppsDFTSpec_R_64f;pSize:Plongint):IppStatus;overload;

function ippsDFTOutOrdGetBufSize_C(pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;size:Plongint):IppStatus;overload;

function ippsDFTOutOrdGetBufSize_C(pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;size:Plongint):IppStatus;overload;


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

function ippsDFTFwd_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pDFTSpec:PIppsDFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pDFTSpec:PIppsDFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pDFTSpec:PIppsDFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pDFTSpec:PIppsDFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;

function ippsDFTFwd_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;overload;

function ippsDFTFwd_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;overload;

function ippsDFTOutOrdFwd_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTOutOrdInv_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;pBuffer:PIpp8u):IppStatus;overload;

function ippsDFTOutOrdFwd_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTOutOrdInv_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;pBuffer:PIpp8u):IppStatus;overload;


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

function ippsDFTFwd_RToPerm(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_RToPack(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_RToCCS(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_PermToR(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_PackToR(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CCSToR(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;

function ippsDFTFwd_RToPerm(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_RToPack(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_RToCCS(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_PermToR(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_PackToR(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CCSToR(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;overload;

function ippsDFTFwd_RToPerm(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_RToPack(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTFwd_RToCCS(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_PermToR(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_PackToR(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDFTInv_CCSToR(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;overload;


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

function ippsMulPack(pSrc:PIpp16s;pSrcDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulPerm(pSrc:PIpp16s;pSrcDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulPack(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;overload;
function ippsMulPerm(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;overload;
function ippsMulPack(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;overload;
function ippsMulPerm(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;overload;
function ippsMulPack(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulPerm(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;overload;
function ippsMulPack(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;length:longint):IppStatus;overload;
function ippsMulPerm(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;length:longint):IppStatus;overload;
function ippsMulPack(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;length:longint):IppStatus;overload;
function ippsMulPerm(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;length:longint):IppStatus;overload;

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

function ippsMulPackConj(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;overload;
function ippsMulPackConj(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;overload;


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

function ippsGoertz(pSrc:PIpp32fc;len:longint;pVal:PIpp32fc;freq:Ipp32f):IppStatus;overload;
function ippsGoertz(pSrc:PIpp64fc;len:longint;pVal:PIpp64fc;freq:Ipp64f):IppStatus;overload;

function ippsGoertz(pSrc:PIpp16sc;len:longint;pVal:PIpp16sc;freq:Ipp32f;scaleFactor:longint):IppStatus;overload;

function ippsGoertz(pSrc:PIpp32f;len:longint;pVal:PIpp32fc;freq:Ipp32f):IppStatus;overload;
function ippsGoertz(pSrc:PIpp16s;len:longint;pVal:PIpp16sc;freq:Ipp32f;scaleFactor:longint):IppStatus;overload;



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

function ippsGoertzTwo(pSrc:PIpp32fc;len:longint;var pVal:Ipp32fc;var freq:Ipp32f):IppStatus;overload;
function ippsGoertzTwo(pSrc:PIpp64fc;len:longint;var pVal:Ipp64fc;var freq:Ipp64f):IppStatus;overload;
function ippsGoertzTwo(pSrc:PIpp16sc;len:longint;var pVal:Ipp16sc;var freq:Ipp32f;scaleFactor:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DCT Functions
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct DCTFwdSpec_16s;
typedef struct DCTFwdSpec_16s IppsDCTFwdSpec_16s;
struct DCTInvSpec_16s;
typedef struct DCTInvSpec_16s IppsDCTInvSpec_16s;

struct DCTFwdSpec_32f;
typedef struct DCTFwdSpec_32f IppsDCTFwdSpec_32f;
struct DCTInvSpec_32f;
typedef struct DCTInvSpec_32f IppsDCTInvSpec_32f;

struct DCTFwdSpec_64f;
typedef struct DCTFwdSpec_64f IppsDCTFwdSpec_64f;
struct DCTInvSpec_64f;
typedef struct DCTInvSpec_64f IppsDCTInvSpec_64f;

#endif /* _OWN_BLDPCS */  *)


(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Context Functions
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

function ippsDCTFwdInitAlloc(var pDCTSpec:PIppsDCTFwdSpec_16s;length:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDCTInvInitAlloc(var pDCTSpec:PIppsDCTInvSpec_16s;length:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsDCTFwdInitAlloc(var pDCTSpec:PIppsDCTFwdSpec_32f;length:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDCTInvInitAlloc(var pDCTSpec:PIppsDCTInvSpec_32f;length:longint;hint:IppHintAlgorithm):IppStatus;overload;

function ippsDCTFwdInitAlloc(var pDCTSpec:PIppsDCTFwdSpec_64f;length:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsDCTInvInitAlloc(var pDCTSpec:PIppsDCTInvSpec_64f;length:longint;hint:IppHintAlgorithm):IppStatus;overload;


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

function ippsDCTFwdFree(pDCTSpec:PIppsDCTFwdSpec_16s):IppStatus;overload;
function ippsDCTInvFree(pDCTSpec:PIppsDCTInvSpec_16s):IppStatus;overload;

function ippsDCTFwdFree(pDCTSpec:PIppsDCTFwdSpec_32f):IppStatus;overload;
function ippsDCTInvFree(pDCTSpec:PIppsDCTInvSpec_32f):IppStatus;overload;

function ippsDCTFwdFree(pDCTSpec:PIppsDCTFwdSpec_64f):IppStatus;overload;
function ippsDCTInvFree(pDCTSpec:PIppsDCTInvSpec_64f):IppStatus;overload;


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

function ippsDCTFwdGetBufSize(pDCTSpec:PIppsDCTFwdSpec_16s;pSize:Plongint):IppStatus;overload;
function ippsDCTInvGetBufSize(pDCTSpec:PIppsDCTInvSpec_16s;pSize:Plongint):IppStatus;overload;

function ippsDCTFwdGetBufSize(pDCTSpec:PIppsDCTFwdSpec_32f;pSize:Plongint):IppStatus;overload;
function ippsDCTInvGetBufSize(pDCTSpec:PIppsDCTInvSpec_32f;pSize:Plongint):IppStatus;overload;

function ippsDCTFwdGetBufSize(pDCTSpec:PIppsDCTFwdSpec_64f;pSize:Plongint):IppStatus;overload;
function ippsDCTInvGetBufSize(pDCTSpec:PIppsDCTInvSpec_64f;pSize:Plongint):IppStatus;overload;


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

function ippsDCTFwd(pSrc:PIpp16s;pDst:PIpp16s;pDCTSpec:PIppsDCTFwdSpec_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;
function ippsDCTInv(pSrc:PIpp16s;pDst:PIpp16s;pDCTSpec:PIppsDCTInvSpec_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;overload;

function ippsDCTFwd(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDCTInv(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;overload;

function ippsDCTFwd(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTFwdSpec_64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsDCTInv(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTInvSpec_64f;pBuffer:PIpp8u):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Functions for Fixed Filter Banks
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

function ippsWTHaarFwd(pSrc:PIpp8s;len:longint;pDstLow:PIpp8s;pDstHigh:PIpp8s):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp32s;len:longint;pDstLow:PIpp32s;pDstHigh:PIpp32s):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp64s;len:longint;pDstLow:PIpp64s;pDstHigh:PIpp64s):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp32f;len:longint;pDstLow:PIpp32f;pDstHigh:PIpp32f):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp64f;len:longint;pDstLow:PIpp64f;pDstHigh:PIpp64f):IppStatus;overload;

function ippsWTHaarFwd(pSrc:PIpp8s;len:longint;pDstLow:PIpp8s;pDstHigh:PIpp8s;scaleFactor:longint):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp32s;len:longint;pDstLow:PIpp32s;pDstHigh:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsWTHaarFwd(pSrc:PIpp64s;len:longint;pDstLow:PIpp64s;pDstHigh:PIpp64s;scaleFactor:longint):IppStatus;overload;

function ippsWTHaarInv(pSrcLow:PIpp8s;pSrcHigh:PIpp8s;pDst:PIpp8s;len:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp32s;pSrcHigh:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp64s;pSrcHigh:PIpp64s;pDst:PIpp64s;len:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp64f;pSrcHigh:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;

function ippsWTHaarInv(pSrcLow:PIpp8s;pSrcHigh:PIpp8s;pDst:PIpp8s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp32s;pSrcHigh:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
function ippsWTHaarInv(pSrcLow:PIpp64s;pSrcHigh:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Fucntions for User Filter Banks
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct sWTFwdState_32f;
typedef struct sWTFwdState_32f IppsWTFwdState_32f;

struct sWTFwdState_8s32f;
typedef struct sWTFwdState_8s32f  IppsWTFwdState_8s32f;

struct sWTFwdState_8u32f;
typedef struct sWTFwdState_8u32f  IppsWTFwdState_8u32f;

struct sWTFwdState_16s32f;
typedef struct sWTFwdState_16s32f IppsWTFwdState_16s32f;

struct sWTFwdState_16u32f;
typedef struct sWTFwdState_16u32f IppsWTFwdState_16u32f;

struct sWTInvState_32f;
typedef struct sWTInvState_32f    IppsWTInvState_32f;

struct sWTInvState_32f8s;
typedef struct sWTInvState_32f8s  IppsWTInvState_32f8s;

struct sWTInvState_32f8u;
typedef struct sWTInvState_32f8u  IppsWTInvState_32f8u;

struct sWTInvState_32f16s;
typedef struct sWTInvState_32f16s IppsWTInvState_32f16s;

struct sWTInvState_32f16u;
typedef struct sWTInvState_32f16u IppsWTInvState_32f16u;

#endif /* _OWN_BLDPCS */  *)


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
function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_8s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_8u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_16s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_16u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdSetDlyLine_32f, ippsWTFwdSetDlyLine_8s32f,
//              ippsWTFwdSetDlyLine_8u32f, ippsWTFwdSetDlyLine_16s32f,
//              ippsWTFwdSetDlyLine_16u32f
//
// Purpose:     The function copies the pointed vectors to internal delay lines.
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
//    for ippsWTFwdInitAlloc function.
*)
function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_8s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdGetDlyLine_32f, ippsWTFwdGetDlyLine_8s32f,
//              ippsWTFwdGetDlyLine_8u32f, ippsWTFwdGetDlyLine_16s32f,
//              ippsWTFwdGetDlyLine_16u32f
//
// Purpose:     The function copies data from interanl delay lines
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
//    for ippsWTFwdInitAlloc function.
*)
function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_8s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;


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
function ippsWTFwd(pSrc:PIpp32f;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_32f):IppStatus;overload;

function ippsWTFwd(pSrc:PIpp8s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8s32f):IppStatus;overload;

function ippsWTFwd(pSrc:PIpp8u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8u32f):IppStatus;overload;

function ippsWTFwd(pSrc:PIpp16s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16s32f):IppStatus;overload;

function ippsWTFwd(pSrc:PIpp16u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16u32f):IppStatus;overload;


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
function ippsWTFwdFree(pState:PIppsWTFwdState_32f):IppStatus;overload;

function ippsWTFwdFree(pState:PIppsWTFwdState_8s32f):IppStatus;overload;

function ippsWTFwdFree(pState:PIppsWTFwdState_8u32f):IppStatus;overload;

function ippsWTFwdFree(pState:PIppsWTFwdState_16s32f):IppStatus;overload;

function ippsWTFwdFree(pState:PIppsWTFwdState_16u32f):IppStatus;overload;


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
function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f8s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f8u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f16s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f16u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;overload;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvSetDlyLine_32f, ippsWTInvSetDlyLine_32f8s,
//              ippsWTInvSetDlyLine_32f8u, ippsWTInvSetDlyLine_32f16s,
//              ippsWTInvSetDlyLine_32f16u
//
// Purpose:     The function copies the pointed vectors to internal delay lines.
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
//    for ippsWTInvInitAlloc function.
*)
function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f8s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvGetDlyLine_32f, ippsWTInvGetDlyLine_32f8s,
//              ippsWTInvGetDlyLine_32f8u, ippsWTInvGetDlyLine_32f16s,
//              ippsWTInvGetDlyLine_32f16u
//
// Purpose:     The function copies data from interanl delay lines
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
//    for ippsWTInvInitAlloc function.
*)
function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f8s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;overload;


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

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp32f;pState:PIppsWTInvState_32f):IppStatus;overload;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8s;pState:PIppsWTInvState_32f8s):IppStatus;overload;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8u;pState:PIppsWTInvState_32f8u):IppStatus;overload;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16s;pState:PIppsWTInvState_32f16s):IppStatus;overload;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16u;pState:PIppsWTInvState_32f16u):IppStatus;overload;


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
function ippsWTInvFree(pState:PIppsWTInvState_32f):IppStatus;overload;

function ippsWTInvFree(pState:PIppsWTInvState_32f8s):IppStatus;overload;

function ippsWTInvFree(pState:PIppsWTInvState_32f8u):IppStatus;overload;

function ippsWTInvFree(pState:PIppsWTInvState_32f16s):IppStatus;overload;

function ippsWTInvFree(pState:PIppsWTInvState_32f16u):IppStatus;overload;



(* /////////////////////////////////////////////////////////////////////////////
//                  Filtering
///////////////////////////////////////////////////////////////////////////// *)


(* /////////////////////////////////////////////////////////////////////////////
//                  Convolution functions
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
//          Some other values may be returned by FFT transform functions
*)

function ippsConv(pSrc1:PIpp32f;lenSrc1:longint;pSrc2:PIpp32f;lenSrc2:longint;pDst:PIpp32f):IppStatus;overload;
function ippsConv(pSrc1:PIpp16s;lenSrc1:longint;pSrc2:PIpp16s;lenSrc2:longint;pDst:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsConv(pSrc1:PIpp64f;lenSrc1:longint;pSrc2:PIpp64f;lenSrc2:longint;pDst:PIpp64f):IppStatus;overload;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsConvCyclic
//  Purpose:    Cyclic Convolution of 1D signals of fixed size
//  Parameters: the pointers to data of fixed size
//  Returns:    IppStatus
//                ippStsNoErr    parameters are not checked
//  Notes:
//          The length of the convolution is given in the function name.
*)

function ippsConvCyclic8x8(x:PIpp32f;h:PIpp32f;y:PIpp32f):IppStatus;overload;
function ippsConvCyclic8x8(x:PIpp16s;h:PIpp16s;y:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsConvCyclic4x4(x:PIpp32f;h:PIpp32fc;y:PIpp32fc):IppStatus;overload;



(* /////////////////////////////////////////////////////////////////////////////
//                     IIR filters (float and double taps versions)
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct IIRState_32f;
typedef struct IIRState_32f IppsIIRState_32f;

struct IIRState_32fc;
typedef struct IIRState_32fc IppsIIRState_32fc;

struct IIRState32f_16s;
typedef struct IIRState32f_16s IppsIIRState32f_16s;

struct IIRState32fc_16sc;
typedef struct IIRState32fc_16sc IppsIIRState32fc_16sc;

struct IIRState_64f;
typedef struct IIRState_64f IppsIIRState_64f;

struct IIRState_64fc;
typedef struct IIRState_64fc IppsIIRState_64fc;

struct IIRState64f_32f;
typedef struct IIRState64f_32f IppsIIRState64f_32f;

struct IIRState64fc_32fc;
typedef struct IIRState64fc_32fc IppsIIRState64fc_32fc;

struct IIRState64f_32s;
typedef struct IIRState64f_32s IppsIIRState64f_32s;

struct IIRState64fc_32sc;
typedef struct IIRState64fc_32sc IppsIIRState64fc_32sc;

struct IIRState64f_16s;
typedef struct IIRState64f_16s IppsIIRState64f_16s;

struct IIRState64fc_16sc;
typedef struct IIRState64fc_16sc IppsIIRState64fc_16sc;

struct IIRState32s_16s;
typedef struct IIRState32s_16s IppsIIRState32s_16s;

struct IIRState32sc_16sc;
typedef struct IIRState32sc_16sc IppsIIRState32sc_16sc;


#endif /* _OWN_BLDPCS */  *)

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
//      ippsIIRClose function works for both AR and BQ contexts
*)

function ippsIIRInitAlloc(var pState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsIIRInitAlloc(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsIIRInitAlloc32f(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsIIRInitAlloc32fc(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsIIRInitAlloc(var pState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRInitAlloc64f(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc64fc(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRInitAlloc64f(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc64fc(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRInitAlloc64f(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc64fc(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsIIRFree(pState:PIppsIIRState_32f):IppStatus;overload;
function ippsIIRFree(pState:PIppsIIRState_32fc):IppStatus;overload;
function ippsIIRFree32f(pState:PIppsIIRState32f_16s):IppStatus;overload;
function ippsIIRFree32fc(pState:PIppsIIRState32fc_16sc):IppStatus;overload;

function ippsIIRFree(pState:PIppsIIRState_64f):IppStatus;overload;
function ippsIIRFree(pState:PIppsIIRState_64fc):IppStatus;overload;
function ippsIIRFree64f(pState:PIppsIIRState64f_32f):IppStatus;overload;
function ippsIIRFree64fc(pState:PIppsIIRState64fc_32fc):IppStatus;overload;
function ippsIIRFree64f(pState:PIppsIIRState64f_32s):IppStatus;overload;
function ippsIIRFree64fc(pState:PIppsIIRState64fc_32sc):IppStatus;overload;
function ippsIIRFree64f(pState:PIppsIIRState64f_16s):IppStatus;overload;
function ippsIIRFree64fc(pState:PIppsIIRState64fc_16sc):IppStatus;overload;

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

function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsIIRInitAlloc32f_BiQuad(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsIIRInitAlloc32fc_BiQuad(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRInitAlloc64f_BiQuad(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc64fc_BiQuad(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRInitAlloc64f_BiQuad(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc64fc_BiQuad(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRInitAlloc64f_BiQuad(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRInitAlloc64fc_BiQuad(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;overload;

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

function ippsIIRGetDlyLine(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;overload;
function ippsIIRSetDlyLine(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;overload;

function ippsIIRGetDlyLine(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsIIRSetDlyLine(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsIIRGetDlyLine32f(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;overload;
function ippsIIRSetDlyLine32f(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;overload;

function ippsIIRGetDlyLine32fc(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsIIRSetDlyLine32fc(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsIIRGetDlyLine(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRSetDlyLine(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;overload;

function ippsIIRGetDlyLine(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRSetDlyLine(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsIIRGetDlyLine64f(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRSetDlyLine64f(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;overload;

function ippsIIRGetDlyLine64fc(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRSetDlyLine64fc(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsIIRGetDlyLine64f(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRSetDlyLine64f(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;overload;

function ippsIIRGetDlyLine64fc(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRSetDlyLine64fc(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsIIRGetDlyLine64f(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;overload;
function ippsIIRSetDlyLine64f(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;overload;

function ippsIIRGetDlyLine64fc(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsIIRSetDlyLine64fc(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;overload;



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

function ippsIIROne(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsIIRState_32f):IppStatus;overload;
function ippsIIROne(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsIIRState_32fc):IppStatus;overload;

function ippsIIROne32f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIROne32fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsIIROne(src:Ipp64f;pDstVal:PIpp64f;pState:PIppsIIRState_64f):IppStatus;overload;
function ippsIIROne(src:Ipp64fc;pDstVal:PIpp64fc;pState:PIppsIIRState_64fc):IppStatus;overload;

function ippsIIROne64f(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsIIRState64f_32f):IppStatus;overload;
function ippsIIROne64fc(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsIIRState64fc_32fc):IppStatus;overload;

function ippsIIROne64f(src:Ipp32s;pDstVal:PIpp32s;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;overload;
function ippsIIROne64fc(src:Ipp32sc;pDstVal:PIpp32sc;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;overload;

function ippsIIROne64f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIROne64fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;overload;

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

function ippsIIR(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;overload;
function ippsIIR(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;overload;
function ippsIIR(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;overload;
function ippsIIR(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;overload;

function ippsIIR32f(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIR32f(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIR32fc(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;overload;
function ippsIIR32fc(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsIIR(pSrc:PIpp64f;pDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;overload;
function ippsIIR(pSrcDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;overload;
function ippsIIR(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;overload;
function ippsIIR(pSrcDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;overload;

function ippsIIR64f(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;overload;
function ippsIIR64f(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;overload;
function ippsIIR64fc(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;overload;
function ippsIIR64fc(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;overload;

function ippsIIR64f(pSrc:PIpp32s;pDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;overload;
function ippsIIR64f(pSrcDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;overload;
function ippsIIR64fc(pSrc:PIpp32sc;pDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;overload;
function ippsIIR64fc(pSrcDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;overload;

function ippsIIR64f(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIR64f(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIR64fc(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;overload;
function ippsIIR64fc(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;overload;

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

function ippsIIRInitAlloc32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;order:longint;tapsFactor:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIRInitAlloc32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32s):IppStatus;overload;

function ippsIIRInitAlloc32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;order:longint;tapsFactor:longint;pDlyLine:PIpp32sc):IppStatus;overload;
function ippsIIRInitAlloc32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32sc):IppStatus;overload;

function ippsIIRInitAlloc32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIRInitAlloc32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32s):IppStatus;overload;

function ippsIIRInitAlloc32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32sc):IppStatus;overload;
function ippsIIRInitAlloc32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32sc):IppStatus;overload;

function ippsIIRFree32s(pState:PIppsIIRState32s_16s):IppStatus;overload;
function ippsIIRFree32sc(pState:PIppsIIRState32sc_16sc):IppStatus;overload;


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

function ippsIIRGetDlyLine32s(pState:PIppsIIRState32s_16s;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIRSetDlyLine32s(pState:PIppsIIRState32s_16s;pDlyLine:PIpp32s):IppStatus;overload;

function ippsIIRGetDlyLine32sc(pState:PIppsIIRState32sc_16sc;pDlyLine:PIpp32sc):IppStatus;overload;
function ippsIIRSetDlyLine32sc(pState:PIppsIIRState32sc_16sc;pDlyLine:PIpp32sc):IppStatus;overload;

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

function ippsIIROne32s(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIROne32sc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;overload;

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

function ippsIIR32s(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIR32sc(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsIIR32s(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;overload;
function ippsIIR32sc(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;overload;

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

function ippsIIR_Direct(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIR_Direct(pSrcDst:PIpp16s;len:longint;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIROne_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIROne_Direct(pSrcDst:PIpp16s;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;overload;

function ippsIIR_BiQuadDirect(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIR_BiQuadDirect(pSrcDst:PIpp16s;len:longint;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIROne_BiQuadDirect(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsIIROne_BiQuadDirect(pSrcDstVal:PIpp16s;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;overload;



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
function ippsIIRGetStateSize32s(order:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize32sc(order:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize32s_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize32sc_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRInit32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;order:longint;tapsFactor:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;order:longint;tapsFactor:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;overload;

(* ****************************** 32s_16s32f ******************************* *)
{ function ippsIIRGetStateSize32s_16s32f(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize32sc_16sc32fc(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize32s_BiQuad_16s32f(numBq:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize32sc_BiQuad_16sc32fc(numBq:longint;pBufferSize:Plongint):IppStatus; }
function ippsIIRInit32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;overload;
(* ********************************** 32f ********************************** *)
function ippsIIRGetStateSize(order:longint;pBufferSize:Plongint):IppStatus;overload;
{ function ippsIIRGetStateSize_32fc(order:longint;pBufferSize:Plongint):IppStatus; }
function ippsIIRGetStateSize_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
{ function ippsIIRGetStateSize_BiQuad_32fc(numBq:longint;pBufferSize:Plongint):IppStatus; }
function ippsIIRInit(var pState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit_BiQuad(var pState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit_BiQuad(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;overload;
(* ******************************** 32f_16s ******************************** *)
function ippsIIRGetStateSize32f(order:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize32fc(order:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize32f_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize32fc_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRInit32f(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32fc(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32f_BiQuad(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit32fc_BiQuad(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;overload;
(* ********************************** 64f ********************************** *)
{ function ippsIIRGetStateSize_64f(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize_64fc(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize_BiQuad_64f(numBq:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize_BiQuad_64fc(numBq:longint;pBufferSize:Plongint):IppStatus; }
function ippsIIRInit(var pState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit_BiQuad(var pState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit_BiQuad(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
(* ******************************** 64f_16s ******************************** *)
function ippsIIRGetStateSize64f(order:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize64fc(order:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize64f_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRGetStateSize64fc_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsIIRInit64f(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64fc(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64f_BiQuad(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64fc_BiQuad(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
(* ******************************** 64f_32s ******************************** *)
{ function ippsIIRGetStateSize64f_32s(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize64fc_32sc(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize64f_BiQuad_32s(numBq:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize64fc_BiQuad_32sc(numBq:longint;pBufferSize:Plongint):IppStatus; }
function ippsIIRInit64f(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64fc(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64f_BiQuad(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64fc_BiQuad(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
(* ******************************** 64f_32f ******************************** *)
{ function ippsIIRGetStateSize64f_32f(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize64fc_32fc(order:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize64f_BiQuad_32f(numBq:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsIIRGetStateSize64fc_BiQuad_32fc(numBq:longint;pBufferSize:Plongint):IppStatus; }
function ippsIIRInit64f(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64fc(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64f_BiQuad(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;overload;
function ippsIIRInit64fc_BiQuad(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;overload;

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
function ippsIIRSetTaps(pTaps:PIpp32f;pState:PIppsIIRState_32f):IppStatus;overload;
function ippsIIRSetTaps(pTaps:PIpp32fc;pState:PIppsIIRState_32fc):IppStatus;overload;
function ippsIIRSetTaps32f(pTaps:PIpp32f;pState:PIppsIIRState32f_16s):IppStatus;overload;
function ippsIIRSetTaps32fc(pTaps:PIpp32fc;pState:PIppsIIRState32fc_16sc):IppStatus;overload;
function ippsIIRSetTaps32s(pTaps:PIpp32s;pState:PIppsIIRState32s_16s;tapsFactor:longint):IppStatus;overload;
function ippsIIRSetTaps32sc(pTaps:PIpp32sc;pState:PIppsIIRState32sc_16sc;tapsFactor:longint):IppStatus;overload;
function ippsIIRSetTaps32s(pTaps:PIpp32f;pState:PIppsIIRState32s_16s):IppStatus;overload;
function ippsIIRSetTaps32sc(pTaps:PIpp32fc;pState:PIppsIIRState32sc_16sc):IppStatus;overload;
function ippsIIRSetTaps(pTaps:PIpp64f;pState:PIppsIIRState_64f):IppStatus;overload;
function ippsIIRSetTaps(pTaps:PIpp64fc;pState:PIppsIIRState_64fc):IppStatus;overload;
function ippsIIRSetTaps64f(pTaps:PIpp64f;pState:PIppsIIRState64f_32f):IppStatus;overload;
function ippsIIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsIIRState64fc_32fc):IppStatus;overload;
function ippsIIRSetTaps64f(pTaps:PIpp64f;pState:PIppsIIRState64f_32s):IppStatus;overload;
function ippsIIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsIIRState64fc_32sc):IppStatus;overload;
function ippsIIRSetTaps64f(pTaps:PIpp64f;pState:PIppsIIRState64f_16s):IppStatus;overload;
function ippsIIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsIIRState64fc_16sc):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                     FIR filters (float and double taps versions)
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct FIRState_32f;
typedef struct FIRState_32f IppsFIRState_32f;

struct FIRState_32fc;
typedef struct FIRState_32fc IppsFIRState_32fc;

struct FIRState32f_16s;
typedef struct FIRState32f_16s IppsFIRState32f_16s;

struct FIRState32fc_16sc;
typedef struct FIRState32fc_16sc IppsFIRState32fc_16sc;

struct FIRState_64f;
typedef struct FIRState_64f IppsFIRState_64f;

struct FIRState_64fc;
typedef struct FIRState_64fc IppsFIRState_64fc;

struct FIRState64f_32f;
typedef struct FIRState64f_32f IppsFIRState64f_32f;

struct FIRState64fc_32fc;
typedef struct FIRState64fc_32fc IppsFIRState64fc_32fc;

struct FIRState64f_32s;
typedef struct FIRState64f_32s IppsFIRState64f_32s;

struct FIRState64fc_32sc;
typedef struct FIRState64fc_32sc IppsFIRState64fc_32sc;

struct FIRState64f_16s;
typedef struct FIRState64f_16s IppsFIRState64f_16s;

struct FIRState64fc_16sc;
typedef struct FIRState64fc_16sc IppsFIRState64fc_16sc;

struct FIRState32s_16s;
typedef struct FIRState32s_16s IppsFIRState32s_16s;

struct FIRState32sc_16sc;
typedef struct FIRState32sc_16sc IppsFIRState32sc_16sc;


#endif /* _OWN_BLDPCS */  *)

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

function ippsFIRInitAlloc(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRMRInitAlloc(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRInitAlloc(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsFIRMRInitAlloc(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRInitAlloc32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRMRInitAlloc32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRInitAlloc32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRMRInitAlloc32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;overload;

function ippsFIRInitAlloc(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsFIRMRInitAlloc(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsFIRInitAlloc(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsFIRMRInitAlloc(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsFIRInitAlloc64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRMRInitAlloc64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRInitAlloc64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsFIRMRInitAlloc64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRInitAlloc64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsFIRMRInitAlloc64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s):IppStatus;overload;
function ippsFIRInitAlloc64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc):IppStatus;overload;
function ippsFIRMRInitAlloc64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc):IppStatus;overload;

function ippsFIRInitAlloc64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRMRInitAlloc64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRInitAlloc64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRMRInitAlloc64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;overload;

function ippsFIRFree(pState:PIppsFIRState_32f):IppStatus;overload;

function ippsFIRFree(pState:PIppsFIRState_32fc):IppStatus;overload;

function ippsFIRFree32f(pState:PIppsFIRState32f_16s):IppStatus;overload;

function ippsFIRFree32fc(pState:PIppsFIRState32fc_16sc):IppStatus;overload;

function ippsFIRFree(pState:PIppsFIRState_64f):IppStatus;overload;

function ippsFIRFree(pState:PIppsFIRState_64fc):IppStatus;overload;

function ippsFIRFree64f(pState:PIppsFIRState64f_32f):IppStatus;overload;

function ippsFIRFree64fc(pState:PIppsFIRState64fc_32fc):IppStatus;overload;

function ippsFIRFree64f(pState:PIppsFIRState64f_32s):IppStatus;overload;

function ippsFIRFree64fc(pState:PIppsFIRState64fc_32sc):IppStatus;overload;

function ippsFIRFree64f(pState:PIppsFIRState64f_16s):IppStatus;overload;

function ippsFIRFree64fc(pState:PIppsFIRState64fc_16sc):IppStatus;overload;

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
function ippsFIRGetStateSize32s(tapsLen:longint;pStateSize:Plongint):IppStatus;overload;
function ippsFIRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize32s(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;overload;
function ippsFIRMRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize32sc(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;overload;
function ippsFIRMRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRGetStateSize32sc(tapsLen:longint;pStateSize:Plongint):IppStatus;overload;
(* ****************************** 32s_16s32f ******************************* *)
{ function ippsFIRGetStateSize32s_16s32f(tapsLen:longint;pStateSize:Plongint):IppStatus; }
function ippsFIRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize32s_16s32f(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus; }
function ippsFIRMRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRGetStateSize32sc_16sc(tapsLen:longint;pStateSize:Plongint):IppStatus; }
function ippsFIRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize32sc_16sc32fc(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus; }
function ippsFIRMRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
(* ********************************** 32f ********************************** *)
function ippsFIRInit(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRInit(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRGetStateSize(tapsLen:longint;pBufferSize:Plongint):IppStatus;overload;
{ function ippsFIRGetStateSize_32fc(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;overload;
{ function ippsFIRMRGetStateSize_32fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;overload;
(* ******************************** 32f_16s ******************************** *)
function ippsFIRGetStateSize32f(tapsLen:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRInit32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRGetStateSize32fc(tapsLen:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRInit32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize32f(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRMRInit32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize32fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRMRInit32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
(* ********************************** 64f ********************************** *)
function ippsFIRInit(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRInit(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRGetStateSize_64f(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsFIRGetStateSize_64fc(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize_64f(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
{ function ippsFIRMRGetStateSize_64fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc;pBuffer:PIpp8u):IppStatus;overload;
(* ******************************** 64f_16s ******************************** *)
function ippsFIRGetStateSize64f(tapsLen:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRInit64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRGetStateSize64fc(tapsLen:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRInit64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize64f(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRMRInit64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;overload;
function ippsFIRMRGetStateSize64fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;overload;
function ippsFIRMRInit64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;overload;
(* ******************************** 64f_32s ******************************** *)
{ function ippsFIRGetStateSize64f_32s(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRInit64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRGetStateSize64fc_32sc(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRInit64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize64f_32s(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize64fc_32sc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;pBuffer:PIpp8u):IppStatus;overload;
(* ******************************** 64f_32f ******************************** *)
{ function ippsFIRGetStateSize64f_32f(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRInit64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRGetStateSize64fc_32fc(tapsLen:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRInit64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize64f_32f(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;overload;
{ function ippsFIRMRGetStateSize64fc_32fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus; }
function ippsFIRMRInit64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;overload;


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

function ippsFIRGetTaps(pState:PIppsFIRState_32f;pTaps:PIpp32f):IppStatus;overload;
function ippsFIRGetTaps(pState:PIppsFIRState_32fc;pTaps:PIpp32fc):IppStatus;overload;

function ippsFIRGetTaps32f(pState:PIppsFIRState32f_16s;pTaps:PIpp32f):IppStatus;overload;
function ippsFIRGetTaps32fc(pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc):IppStatus;overload;

function ippsFIRGetTaps(pState:PIppsFIRState_64f;pTaps:PIpp64f):IppStatus;overload;
function ippsFIRGetTaps(pState:PIppsFIRState_64fc;pTaps:PIpp64fc):IppStatus;overload;

function ippsFIRGetTaps64f(pState:PIppsFIRState64f_32f;pTaps:PIpp64f):IppStatus;overload;
function ippsFIRGetTaps64fc(pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc):IppStatus;overload;

function ippsFIRGetTaps64f(pState:PIppsFIRState64f_32s;pTaps:PIpp64f):IppStatus;overload;
function ippsFIRGetTaps64fc(pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc):IppStatus;overload;

function ippsFIRGetTaps64f(pState:PIppsFIRState64f_16s;pTaps:PIpp64f):IppStatus;overload;
function ippsFIRGetTaps64fc(pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc):IppStatus;overload;


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

function ippsFIRSetTaps(pTaps:PIpp32f;pState:PIppsFIRState_32f):IppStatus;overload;
function ippsFIRSetTaps(pTaps:PIpp32fc;pState:PIppsFIRState_32fc):IppStatus;overload;
function ippsFIRSetTaps32f(pTaps:PIpp32f;pState:PIppsFIRState32f_16s):IppStatus;overload;
function ippsFIRSetTaps32fc(pTaps:PIpp32fc;pState:PIppsFIRState32fc_16sc):IppStatus;overload;
function ippsFIRSetTaps32s(pTaps:PIpp32s;pState:PIppsFIRState32s_16s;tapsFactor:longint):IppStatus;overload;
function ippsFIRSetTaps32sc(pTaps:PIpp32sc;pState:PIppsFIRState32sc_16sc;tapsFactor:longint):IppStatus;overload;
function ippsFIRSetTaps32s(pTaps:PIpp32f;pState:PIppsFIRState32s_16s):IppStatus;overload;
function ippsFIRSetTaps32sc(pTaps:PIpp32fc;pState:PIppsFIRState32sc_16sc):IppStatus;overload;
function ippsFIRSetTaps(pTaps:PIpp64f;pState:PIppsFIRState_64f):IppStatus;overload;
function ippsFIRSetTaps(pTaps:PIpp64fc;pState:PIppsFIRState_64fc):IppStatus;overload;
function ippsFIRSetTaps64f(pTaps:PIpp64f;pState:PIppsFIRState64f_32f):IppStatus;overload;
function ippsFIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsFIRState64fc_32fc):IppStatus;overload;
function ippsFIRSetTaps64f(pTaps:PIpp64f;pState:PIppsFIRState64f_32s):IppStatus;overload;
function ippsFIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsFIRState64fc_32sc):IppStatus;overload;
function ippsFIRSetTaps64f(pTaps:PIpp64f;pState:PIppsFIRState64f_16s):IppStatus;overload;
function ippsFIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsFIRState64fc_16sc):IppStatus;overload;



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

function ippsFIRGetDlyLine(pState:PIppsFIRState_32f;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRSetDlyLine(pState:PIppsFIRState_32f;pDlyLine:PIpp32f):IppStatus;overload;

function ippsFIRGetDlyLine(pState:PIppsFIRState_32fc;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsFIRSetDlyLine(pState:PIppsFIRState_32fc;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRGetDlyLine32f(pState:PIppsFIRState32f_16s;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRSetDlyLine32f(pState:PIppsFIRState32f_16s;pDlyLine:PIpp16s):IppStatus;overload;

function ippsFIRGetDlyLine32fc(pState:PIppsFIRState32fc_16sc;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRSetDlyLine32fc(pState:PIppsFIRState32fc_16sc;pDlyLine:PIpp16sc):IppStatus;overload;

function ippsFIRGetDlyLine(pState:PIppsFIRState_64f;pDlyLine:PIpp64f):IppStatus;overload;
function ippsFIRSetDlyLine(pState:PIppsFIRState_64f;pDlyLine:PIpp64f):IppStatus;overload;

function ippsFIRGetDlyLine(pState:PIppsFIRState_64fc;pDlyLine:PIpp64fc):IppStatus;overload;
function ippsFIRSetDlyLine(pState:PIppsFIRState_64fc;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsFIRGetDlyLine64f(pState:PIppsFIRState64f_32f;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRSetDlyLine64f(pState:PIppsFIRState64f_32f;pDlyLine:PIpp32f):IppStatus;overload;

function ippsFIRGetDlyLine64fc(pState:PIppsFIRState64fc_32fc;pDlyLine:PIpp32fc):IppStatus;overload;
function ippsFIRSetDlyLine64fc(pState:PIppsFIRState64fc_32fc;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRGetDlyLine64f(pState:PIppsFIRState64f_32s;pDlyLine:PIpp32s):IppStatus;overload;
function ippsFIRSetDlyLine64f(pState:PIppsFIRState64f_32s;pDlyLine:PIpp32s):IppStatus;overload;

function ippsFIRGetDlyLine64fc(pState:PIppsFIRState64fc_32sc;pDlyLine:PIpp32sc):IppStatus;overload;
function ippsFIRSetDlyLine64fc(pState:PIppsFIRState64fc_32sc;pDlyLine:PIpp32sc):IppStatus;overload;

function ippsFIRGetDlyLine64f(pState:PIppsFIRState64f_16s;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRSetDlyLine64f(pState:PIppsFIRState64f_16s;pDlyLine:PIpp16s):IppStatus;overload;

function ippsFIRGetDlyLine64fc(pState:PIppsFIRState64fc_16sc;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRSetDlyLine64fc(pState:PIppsFIRState64fc_16sc;pDlyLine:PIpp16sc):IppStatus;overload;

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

function ippsFIROne(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsFIRState_32f):IppStatus;overload;
function ippsFIROne(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsFIRState_32fc):IppStatus;overload;

function ippsFIROne32f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIROne32fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIROne(src:Ipp64f;pDstVal:PIpp64f;pState:PIppsFIRState_64f):IppStatus;overload;
function ippsFIROne(src:Ipp64fc;pDstVal:PIpp64fc;pState:PIppsFIRState_64fc):IppStatus;overload;

function ippsFIROne64f(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsFIRState64f_32f):IppStatus;overload;
function ippsFIROne64fc(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsFIRState64fc_32fc):IppStatus;overload;

function ippsFIROne64f(src:Ipp32s;pDstVal:PIpp32s;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;overload;
function ippsFIROne64fc(src:Ipp32sc;pDstVal:PIpp32sc;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;overload;

function ippsFIROne64f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIROne64fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;overload;

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
//          for inplace functions max this values
*)

function ippsFIR(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pState:PIppsFIRState_32f):IppStatus;overload;
function ippsFIR(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pState:PIppsFIRState_32fc):IppStatus;overload;

function ippsFIR32f(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIR32fc(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIR(pSrcDst:PIpp32f;numIters:longint;pState:PIppsFIRState_32f):IppStatus;overload;
function ippsFIR(pSrcDst:PIpp32fc;numIters:longint;pState:PIppsFIRState_32fc):IppStatus;overload;

function ippsFIR32f(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIR32fc(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIR(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pState:PIppsFIRState_64f):IppStatus;overload;
function ippsFIR(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pState:PIppsFIRState_64fc):IppStatus;overload;

function ippsFIR(pSrcDst:PIpp64f;numIters:longint;pState:PIppsFIRState_64f):IppStatus;overload;
function ippsFIR(pSrcDst:PIpp64fc;numIters:longint;pState:PIppsFIRState_64fc):IppStatus;overload;

function ippsFIR64f(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pState:PIppsFIRState64f_32f):IppStatus;overload;
function ippsFIR64fc(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pState:PIppsFIRState64fc_32fc):IppStatus;overload;

function ippsFIR64f(pSrcDst:PIpp32f;numIters:longint;pState:PIppsFIRState64f_32f):IppStatus;overload;
function ippsFIR64fc(pSrcDst:PIpp32fc;numIters:longint;pState:PIppsFIRState64fc_32fc):IppStatus;overload;

function ippsFIR64f(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;overload;

function ippsFIR64f(pSrcDst:PIpp32s;numIters:longint;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc(pSrcDst:PIpp32sc;numIters:longint;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;overload;

function ippsFIR64f(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIR64f(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;overload;

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
function ippsFIRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRMRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRMRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRMRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRMRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;overload;

function ippsFIRFree32s(pState:PIppsFIRState32s_16s):IppStatus;overload;

function ippsFIRFree32sc(pState:PIppsFIRState32sc_16sc):IppStatus;overload;

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

function ippsFIRGetTaps32s(pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsFactor:Plongint):IppStatus;overload;
function ippsFIRGetTaps32sc(pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsFactor:Plongint):IppStatus;overload;
function ippsFIRGetTaps32s(pState:PIppsFIRState32s_16s;pTaps:PIpp32f):IppStatus;overload;
function ippsFIRGetTaps32sc(pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc):IppStatus;overload;


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

function ippsFIRGetDlyLine32s(pState:PIppsFIRState32s_16s;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRSetDlyLine32s(pState:PIppsFIRState32s_16s;pDlyLine:PIpp16s):IppStatus;overload;
function ippsFIRGetDlyLine32sc(pState:PIppsFIRState32sc_16sc;pDlyLine:PIpp16sc):IppStatus;overload;
function ippsFIRSetDlyLine32sc(pState:PIppsFIRState32sc_16sc;pDlyLine:PIpp16sc):IppStatus;overload;

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
function ippsFIROne32s(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIROne32sc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;overload;


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
//          for inplace functions max this values
*)

function ippsFIR32s(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIR32sc(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIR32s(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;overload;
function ippsFIR32sc(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;overload;



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
function ippsFIRLMSOne_Direct(src:Ipp32f;refval:Ipp32f;pDstVal:PIpp32f;pTapsInv:PIpp32f;tapsLen:longint;mu:single;pDlyLine:PIpp32f;pDlyIndex:Plongint):IppStatus;overload;

function ippsFIRLMSOne_Direct32f(src:Ipp16s;refval:Ipp16s;pDstVal:PIpp16s;pTapsInv:PIpp32f;tapsLen:longint;mu:single;pDlyLine:PIpp16s;pDlyIndex:Plongint):IppStatus;overload;

function ippsFIRLMSOne_DirectQ15(src:Ipp16s;refval:Ipp16s;pDstVal:PIpp16s;pTapsInv:PIpp32s;tapsLen:longint;muQ15:longint;pDlyLine:PIpp16s;pDlyIndex:Plongint):IppStatus;overload;


(* context oriented functions *)
(*   #if !defined( _OWN_BLDPCS )

  struct FIRLMSState_32f;
  typedef struct FIRLMSState_32f IppsFIRLMSState_32f;

  struct FIRLMSState32f_16s;
  typedef struct FIRLMSState32f_16s IppsFIRLMSState32f_16s;

#endif /* _OWN_BLDPCS */  *)


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
function ippsFIRLMS(pSrc:PIpp32f;pRef:PIpp32f;pDst:PIpp32f;len:longint;mu:single;pState:PIppsFIRLMSState_32f):IppStatus;overload;

function ippsFIRLMS32f(pSrc:PIpp16s;pRef:PIpp16s;pDst:PIpp16s;len:longint;mu:single;pStatel:PIppsFIRLMSState32f_16s):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSInitAlloc, ippsFIRLMSFree
//   Purpose:     LMS initialization functions
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

function ippsFIRLMSInitAlloc(var pState:PIppsFIRLMSState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;overload;

function ippsFIRLMSInitAlloc32f(var pState:PIppsFIRLMSState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;overload;

function ippsFIRLMSFree(pState:PIppsFIRLMSState_32f):IppStatus;overload;
function ippsFIRLMSFree32f(pState:PIppsFIRLMSState32f_16s):IppStatus;overload;

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

function ippsFIRLMSGetTaps(pState:PIppsFIRLMSState_32f;pOutTaps:PIpp32f):IppStatus;overload;
function ippsFIRLMSGetTaps32f(pState:PIppsFIRLMSState32f_16s;pOutTaps:PIpp32f):IppStatus;overload;

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

function ippsFIRLMSGetDlyLine(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIRLMSGetDlyLine32f(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIRLMSSetDlyLine(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;overload;
function ippsFIRLMSSetDlyLine32f(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  FIR LMS MR filters
///////////////////////////////////////////////////////////////////////////// *)

(* context oriented functions *)
(*   #if !defined( _OWN_BLDPCS )

  struct FIRLMSMRState32s_16s;
  typedef struct FIRLMSMRState32s_16s IppsFIRLMSMRState32s_16s;

  struct FIRLMSMRState32sc_16sc;
  typedef struct FIRLMSMRState32sc_16sc IppsFIRLMSMRState32sc_16sc;

#endif /* _OWN_BLDPCS */  *)

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
function ippsFIRLMSMROne32s(pDstVal:PIpp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;overload;
function ippsFIRLMSMROneVal32s(val:Ipp16s;pDstVal:PIpp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;overload;

function ippsFIRLMSMROne32sc(pDstVal:PIpp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;overload;
function ippsFIRLMSMROneVal32sc(val:Ipp16sc;pDstVal:PIpp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;overload;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:       ippsFIRLMSMRInitAlloc, ippsFIRLMSMRFree
//   Purpose:     LMS MR initialization functions
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

function ippsFIRLMSMRInitAlloc32s(var pState:PIppsFIRLMSMRState32s_16s;pTaps:PIpp32s;tapsLen:longint;pDlyLine:PIpp16s;dlyLineIndex:longint;dlyStep:longint;updateDly:longint;mu:longint):IppStatus;overload;
function ippsFIRLMSMRFree32s(pState:PIppsFIRLMSMRState32s_16s):IppStatus;overload;

function ippsFIRLMSMRInitAlloc32sc(var pState:PIppsFIRLMSMRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;pDlyLine:PIpp16sc;dlyLineIndex:longint;dlyStep:longint;updateDly:longint;mu:longint):IppStatus;overload;
function ippsFIRLMSMRFree32sc(pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;overload;

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

function ippsFIRLMSMRSetTaps32s(pState:PIppsFIRLMSMRState32s_16s;pInTaps:PIpp32s):IppStatus;overload;
function ippsFIRLMSMRGetTaps32s(pState:PIppsFIRLMSMRState32s_16s;pOutTaps:PIpp32s):IppStatus;overload;
function ippsFIRLMSMRGetTapsPointer32s(pState:PIppsFIRLMSMRState32s_16s;var pTaps:PIpp32s):IppStatus;overload;

function ippsFIRLMSMRSetTaps32sc(pState:PIppsFIRLMSMRState32sc_16sc;pInTaps:PIpp32sc):IppStatus;overload;
function ippsFIRLMSMRGetTaps32sc(pState:PIppsFIRLMSMRState32sc_16sc;pOutTaps:PIpp32sc):IppStatus;overload;
function ippsFIRLMSMRGetTapsPointer32sc(pState:PIppsFIRLMSMRState32sc_16sc;var pTaps:PIpp32sc):IppStatus;overload;

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

function ippsFIRLMSMRSetDlyLine32s(pState:PIppsFIRLMSMRState32s_16s;pInDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;overload;
function ippsFIRLMSMRGetDlyLine32s(pState:PIppsFIRLMSMRState32s_16s;pOutDlyLine:PIpp16s;pOutDlyIndex:Plongint):IppStatus;overload;
function ippsFIRLMSMRGetDlyVal32s(pState:PIppsFIRLMSMRState32s_16s;pOutVal:PIpp16s;index:longint):IppStatus;overload;
function ippsFIRLMSMRSetDlyLine32sc(pState:PIppsFIRLMSMRState32sc_16sc;pInDlyLine:PIpp16sc;dlyLineIndex:longint):IppStatus;overload;
function ippsFIRLMSMRGetDlyLine32sc(pState:PIppsFIRLMSMRState32sc_16sc;pOutDlyLine:PIpp16sc;pOutDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIRLMSMRGetDlyVal32sc(pState:PIppsFIRLMSMRState32sc_16sc;pOutVal:PIpp16sc;index:longint):IppStatus;overload;

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

function ippsFIRLMSMRPutVal32s(val:Ipp16s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;overload;
function ippsFIRLMSMRPutVal32sc(val:Ipp16sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;overload;

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

function ippsFIRLMSMRSetMu32s(pState:PIppsFIRLMSMRState32s_16s;mu:longint):IppStatus;overload;
function ippsFIRLMSMRSetMu32sc(pState:PIppsFIRLMSMRState32sc_16sc;mu:longint):IppStatus;overload;

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

function ippsFIRLMSMRUpdateTaps32s(ErrVal:Ipp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;overload;
function ippsFIRLMSMRUpdateTaps32sc(ErrVal:Ipp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;overload;




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

function ippsFIROne_Direct(src:Ipp32f;pDstVal:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIROne_Direct(src:Ipp32fc;pDstVal:PIpp32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIROne_Direct(pSrcDstVal:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIROne_Direct(pSrcDstVal:PIpp32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIROne32f_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne32fc_Direct(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne32f_Direct(pSrcDstVal:PIpp16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne32fc_Direct(pSrcDstVal:PIpp16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne_Direct(src:Ipp64f;pDstVal:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIROne_Direct(src:Ipp64fc;pDstVal:PIpp64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIROne_Direct(pSrcDstVal:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIROne_Direct(pSrcDstVal:PIpp64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIROne64f_Direct(src:Ipp32f;pDstVal:PIpp32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIROne64fc_Direct(src:Ipp32fc;pDstVal:PIpp32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIROne64f_Direct(pSrcDstVal:PIpp32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIROne64fc_Direct(pSrcDstVal:PIpp32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIROne64f_Direct(src:Ipp32s;pDstVal:PIpp32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne64fc_Direct(src:Ipp32sc;pDstVal:PIpp32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne64f_Direct(pSrcDstVal:PIpp32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne64fc_Direct(pSrcDstVal:PIpp32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne64f_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne64fc_Direct(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne64f_Direct(pSrcDstVal:PIpp16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne64fc_Direct(pSrcDstVal:PIpp16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne32s_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne32sc_Direct(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne32s_Direct(pSrcDstVal:PIpp16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIROne32sc_Direct(pSrcDstVal:PIpp16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

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

function ippsFIR_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIR_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIR_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIR_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIR32f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR32fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR32f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR32fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR_Direct(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIR_Direct(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIR_Direct(pSrcDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIR_Direct(pSrcDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIR64f_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIR64fc_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIR64f_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;overload;
function ippsFIR64fc_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;overload;

function ippsFIR64f_Direct(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc_Direct(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR64f_Direct(pSrcDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc_Direct(pSrcDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR64f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR64f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR64fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR32s_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR32sc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR32s_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;
function ippsFIR32sc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

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


function ippsFIRMR_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRMR_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRMR_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRMR_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRMR32f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR32fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR32f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR32fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR_Direct(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsFIRMR_Direct(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsFIRMR_Direct(pSrcDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;overload;
function ippsFIRMR_Direct(pSrcDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;overload;

function ippsFIRMR64f_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRMR64fc_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRMR64f_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;overload;
function ippsFIRMR64fc_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;overload;

function ippsFIRMR64f_Direct(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR64fc_Direct(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR64f_Direct(pSrcDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR64fc_Direct(pSrcDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR64f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR64fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR64f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR64fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR32s_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR32sc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;overload;

function ippsFIRMR32s_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;overload;
function ippsFIRMR32sc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;overload;


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

function ippsFIR_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIR_Direct(pSrcDst:PIpp16s;numIters:longint;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne_Direct(src:Ipp16s;pDstVal:PIpp16s;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

function ippsFIROne_Direct(pSrcDstVal:PIpp16s;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;overload;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFIRGenLowpass_64f, ippsFIRGenHighpass_64f, ippsFIRGenBandpass_64f
//              ippsFIRGenBandstop_64f

//  Purpose:    This function computes the lowpass FIR filter coefficients
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
//      doNormal          if doNormal=0 the functions calculates
//                        non-normalized sequence of filter coefficients,
//                        in other cases the sequence of coefficients
//                        will be normalized.
//  Return:
//   ippStsNullPtrErr     the null pointer to taps[] array pass to function
//   ippStsSizeErr        the length of coefficient's array is less then five
//   ippStsSizeErr        the low or high frequency isn’t satisfy
//                                    the condition 0 < rLowFreq < 0.5
//   ippStsNoErr          otherwise
//
*)

function ippsFIRGenLowpass(rfreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;overload;


function ippsFIRGenHighpass(rfreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;overload;


function ippsFIRGenBandpass(rLowFreq:Ipp64f;rHighFreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;overload;


function ippsFIRGenBandstop(rLowFreq:Ipp64f;rHighFreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;overload;

(* /////////////////////////////////////////////////////////////////////////////
//                  Windowing functions
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

function ippsWinBartlett(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrcDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinBartlett(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinHann
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 3
//   ippStsNoErr         otherwise
//  Functionality:    0.5*(1-cos(2*pi*n/(N-1)))
*)

function ippsWinHann(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinHann(pSrcDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinHann(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinHann(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsWinHann(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinHann(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinHann(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinHann(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;

function ippsWinHann(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinHann(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsWinHann(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinHann(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;



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

function ippsWinHamming(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinHamming(pSrcDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinHamming(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinHamming(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;

function ippsWinHamming(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinHamming(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinHamming(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinHamming(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;

function ippsWinHamming(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinHamming(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsWinHamming(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinHamming(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinBlackman
//  Purpose:          multiply vector by Blackman windowing function
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

function ippsWinBlackmanQ15(pSrcDst:PIpp16s;len:longint;alphaQ15:longint;scaleFactor:longint):IppStatus;overload;

function ippsWinBlackmanQ15(pSrcDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinBlackmanQ15(pSrcDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinBlackman(pSrcDst:PIpp16s;len:longint;alpha:single):IppStatus;overload;
function ippsWinBlackman(pSrcDst:PIpp16sc;len:longint;alpha:single):IppStatus;overload;
function ippsWinBlackman(pSrcDst:PIpp32f;len:longint;alpha:single):IppStatus;overload;
function ippsWinBlackman(pSrcDst:PIpp32fc;len:longint;alpha:single):IppStatus;overload;

function ippsWinBlackmanQ15(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinBlackmanQ15(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinBlackman(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:single):IppStatus;overload;
function ippsWinBlackman(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:single):IppStatus;overload;
function ippsWinBlackman(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:single):IppStatus;overload;
function ippsWinBlackman(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:single):IppStatus;overload;

function ippsWinBlackmanStd(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrcDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrcDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrcDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrcDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrcDst:PIpp32fc;len:longint):IppStatus;overload;

function ippsWinBlackmanStd(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;

function ippsWinBlackman(pSrcDst:PIpp64f;len:longint;alpha:double):IppStatus;overload;
function ippsWinBlackman(pSrcDst:PIpp64fc;len:longint;alpha:double):IppStatus;overload;

function ippsWinBlackman(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:double):IppStatus;overload;
function ippsWinBlackman(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:double):IppStatus;overload;

function ippsWinBlackmanStd(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinBlackmanStd(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

function ippsWinBlackmanOpt(pSrcDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
function ippsWinBlackmanOpt(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippsWinKaiser
//  Purpose:          multiply vector by Kaiser windowing function
//  Parameters:
//   pSrcDst          pointer to the vector
//   len              length of the vector, window size
//   alpha            adjustable parameter associated with the
//                    Kaiser windowing equation
//   alphaQ15         scaled (scale factor 15) version of the alpha
//  Return:
//   ippStsNullPtrErr    pointer to the vector is NULL
//   ippStsSizeErr       length of the vector is less 1
//   ippStsHugeWinErr    window in function is huge
//   ippStsNoErr         otherwise
*)

function ippsWinKaiser(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrcDst:PIpp16s;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiserQ15(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinKaiserQ15(pSrcDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinKaiser(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrcDst:PIpp16sc;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiserQ15(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinKaiserQ15(pSrcDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;overload;
function ippsWinKaiser(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrcDst:PIpp32f;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrcDst:PIpp32fc;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrcDst:PIpp64f;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrcDst:PIpp64fc;len:longint;alpha:single):IppStatus;overload;
function ippsWinKaiser(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:single):IppStatus;overload;

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
function ippsFilterMedian(pSrcDst:PIpp32f;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrcDst:PIpp64f;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrcDst:PIpp16s;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrcDst:PIpp8u;len:longint;maskSize:longint):IppStatus;overload;

function ippsFilterMedian(pSrc:PIpp32f;pDst:PIpp32f;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrc:PIpp64f;pDst:PIpp64f;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrc:PIpp16s;pDst:PIpp16s;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrc:PIpp8u;pDst:PIpp8u;len:longint;maskSize:longint):IppStatus;overload;

function ippsFilterMedian(pSrcDst:PIpp32s;len:longint;maskSize:longint):IppStatus;overload;
function ippsFilterMedian(pSrc:PIpp32s;pDst:PIpp32s;len:longint;maskSize:longint):IppStatus;overload;


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
function ippsNorm_Inf(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_Inf(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsNorm_Inf(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_Inf(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNorm_L1(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_L1(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsNorm_L1(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_L1(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNorm_L2(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_L2(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsNorm_L2(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_L2(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;overload;


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
function ippsNormDiff_Inf(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_Inf(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsNormDiff_Inf(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_Inf(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNormDiff_L1(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_L1(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsNormDiff_L1(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_L1(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNormDiff_L2(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_L2(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;overload;
function ippsNormDiff_L2(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_L2(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;overload;

function ippsNorm_Inf(pSrc:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNorm_L1(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNorm_L2(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;overload;

function ippsNormDiff_Inf(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;overload;
function ippsNormDiff_L1(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNormDiff_L2(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNorm_Inf(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNorm_L1(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNorm_L2(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNormDiff_Inf(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNormDiff_L1(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
function ippsNormDiff_L2(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;overload;
(* /////////////////////////////////////////////////////////////////////////////
//                Cross Correlation Functions
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
function ippsCrossCorr(pSrc1:PIpp32f;len1:longint;pSrc2:PIpp32f;len2:longint;pDst:PIpp32f;dstLen:longint;lowLag:longint):IppStatus;overload;
function ippsCrossCorr(pSrc1:PIpp64f;len1:longint;pSrc2:PIpp64f;len2:longint;pDst:PIpp64f;dstLen:longint;lowLag:longint):IppStatus;overload;
function ippsCrossCorr(pSrc1:PIpp32fc;len1:longint;pSrc2:PIpp32fc;len2:longint;pDst:PIpp32fc;dstLen:longint;lowLag:longint):IppStatus;overload;
function ippsCrossCorr(pSrc1:PIpp64fc;len1:longint;pSrc2:PIpp64fc;len2:longint;pDst:PIpp64fc;dstLen:longint;lowLag:longint):IppStatus;overload;
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
function ippsCrossCorr(pSrc1:PIpp16s;len1:longint;pSrc2:PIpp16s;len2:longint;pDst:PIpp16s;dstLen:longint;lowLag:longint;scaleFactor:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                AutoCorrelation Functions
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

function ippsAutoCorr(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormA(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormB(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;overload;
function ippsAutoCorr(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormA(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormB(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;overload;
function ippsAutoCorr(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormA(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormB(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;overload;
function ippsAutoCorr(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormA(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;overload;
function ippsAutoCorr_NormB(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;overload;

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

function ippsAutoCorr(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;overload;
function ippsAutoCorr_NormA(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;overload;
function ippsAutoCorr_NormB(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;overload;



(* /////////////////////////////////////////////////////////////////////////////
//                  Sampling functions
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
function ippsSampleUp(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleUp(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleUp(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleUp(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleUp(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleUp(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;

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
function ippsSampleDown(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleDown(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleDown(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleDown(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleDown(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;
function ippsSampleDown(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;overload;



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
function ippsGetVarPointDV(pSrc:PIpp16sc;pDst:PIpp16sc;pVariantPoint:PIpp16sc;pLabel:PIpp8u;state:longint):IppStatus;overload;


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
function ippsCalcStatesDV(pathError:PIpp16u;pNextState:PIpp8u;pBranchError:PIpp16u;pCurrentSubsetPoint:PIpp16s;pPathTable:PIpp16s;state:longint;presentIndex:longint):IppStatus;overload;

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
function ippsBuildSymblTableDV4D(pVariantPoint:PIpp16sc;pCurrentSubsetPoint:PIpp16sc;state:longint;bitInversion:longint):IppStatus;overload;

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
function ippsUpdatePathMetricsDV(pBranchError:PIpp16u;pMinPathError:PIpp16u;pMinSost:PIpp8u;pPathError:PIpp16u;state:longint):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for Hilbert Functions
///////////////////////////////////////////////////////////////////////////// *)

(*   #if !defined( _OWN_BLDPCS )

struct HilbertSpec_32f32fc;
typedef struct HilbertSpec_32f32fc IppsHilbertSpec_32f32fc;

struct HilbertSpec_16s32fc;
typedef struct HilbertSpec_16s32fc IppsHilbertSpec_16s32fc;

struct HilbertSpec_16s16sc;
typedef struct HilbertSpec_16s16sc IppsHilbertSpec_16s16sc;

#endif /* _OWN_BLDPCS */  *)


(* /////////////////////////////////////////////////////////////////////////////
//                  Hilbert Context Functions
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

function ippsHilbertInitAlloc(var pSpec:PIppsHilbertSpec_32f32fc;length:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsHilbertInitAlloc(var pSpec:PIppsHilbertSpec_16s32fc;length:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsHilbertInitAlloc(var pSpec:PIppsHilbertSpec_16s16sc;length:longint;hint:IppHintAlgorithm):IppStatus;overload;
function ippsHilbertFree(pSpec:PIppsHilbertSpec_32f32fc):IppStatus;overload;
function ippsHilbertFree(pSpec:PIppsHilbertSpec_16s32fc):IppStatus;overload;
function ippsHilbertFree(pSpec:PIppsHilbertSpec_16s16sc):IppStatus;overload;


(* /////////////////////////////////////////////////////////////////////////////
//                  Hilbert Transform Functions
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

function ippsHilbert(pSrc:PIpp32f;pDst:PIpp32fc;pSpec:PIppsHilbertSpec_32f32fc):IppStatus;overload;
function ippsHilbert(pSrc:PIpp16s;pDst:PIpp32fc;pSpec:PIppsHilbertSpec_16s32fc):IppStatus;overload;
function ippsHilbert(pSrc:PIpp16s;pDst:PIpp16sc;pSpec:PIppsHilbertSpec_16s16sc;scaleFactor:longint):IppStatus;overload;


(*   #ifdef __cplusplus
}
#endif  *)

(* ////////////////////////// End of file "ipps.h" ////////////////////////// *)

IMPLEMENTATION

function ippsMalloc(len: int64):pointer;
begin
  if len mod 8=0 then result:=ippsMalloc_64f(len div 8)
  else
  if len mod 4=0 then result:=ippsMalloc_32f(len div 4)
  else
  result:=ippsMalloc_8u(len);
end;

function ippsCopy(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsCopy_8u(pSrc,pDst,len);
end;

function ippsCopy(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsCopy_16s(pSrc,pDst,len);
end;

function ippsCopy(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsCopy_16sc(pSrc,pDst,len);
end;

function ippsCopy(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsCopy_32f(pSrc,pDst,len);
end;

function ippsCopy(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsCopy_32fc(pSrc,pDst,len);
end;

function ippsCopy(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsCopy_64f(pSrc,pDst,len);
end;

function ippsCopy(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsCopy_64fc(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsMove_8u(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMove_16s(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsMove_16sc(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMove_32f(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMove_32fc(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMove_64f(pSrc,pDst,len);
end;

function ippsMove(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMove_64fc(pSrc,pDst,len);
end;

function ippsZero(pDst: pointer;len: int64):IppStatus;
begin
  if len mod 8=0 then result:=ippsZero_64f(PIpp64f(pDst), len div 8)
  else
  if len mod 4=0 then result:=ippsZero_32f(PIpp32f(pDst), len div 4)
  else
  if len mod 2=0 then result:=ippsZero_16s(PIpp16s(pDst), len div 2)
  else
  result:=ippsZero_8u(PIpp8u(pDst), len);
end;

function ippsZero(pDst:PIpp8u;len:longint):IppStatus;
begin
  if assigned(ippsZero_8u) then result:=ippsZero_8u(pDst,len)
  else
  begin
    fillchar(pDst^,len,0);
    result:=0;
  end;
end;

function ippsZero(pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsZero_16s(pDst,len);
end;

function ippsZero(pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsZero_16sc(pDst,len);
end;

function ippsZero(pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsZero_32f(pDst,len);
end;

function ippsZero(pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsZero_32fc(pDst,len);
end;

function ippsZero(pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsZero_64f(pDst,len);
end;

function ippsZero(pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsZero_64fc(pDst,len);
end;

function ippsSet(val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsSet_8u(val,pDst,len);
end;

function ippsSet(val:Ipp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSet_16s(val,pDst,len);
end;

function ippsSet(val:Ipp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsSet_16sc(val,pDst,len);
end;

function ippsSet(val:Ipp32s;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsSet_32s(val,pDst,len);
end;

function ippsSet(val:Ipp32sc;pDst:PIpp32sc;len:longint):IppStatus;
begin
  result:=ippsSet_32sc(val,pDst,len);
end;

function ippsSet(val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSet_32f(val,pDst,len);
end;

function ippsSet(val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSet_32fc(val,pDst,len);
end;

function ippsSet(val:Ipp64s;pDst:PIpp64s;len:longint):IppStatus;
begin
  result:=ippsSet_64s(val,pDst,len);
end;

function ippsSet(val:Ipp64sc;pDst:PIpp64sc;len:longint):IppStatus;
begin
  result:=ippsSet_64sc(val,pDst,len);
end;

function ippsSet(val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSet_64f(val,pDst,len);
end;

function ippsSet(val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSet_64fc(val,pDst,len);
end;

function ippsRandUniform_Direct(pDst:PIpp16s;len:longint;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;
begin
  result:=ippsRandUniform_Direct_16s(pDst,len,low,high,pSeed);
end;

function ippsRandUniform_Direct(pDst:PIpp32f;len:longint;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;
begin
  result:=ippsRandUniform_Direct_32f(pDst,len,low,high,pSeed);
end;

function ippsRandUniform_Direct(pDst:PIpp64f;len:longint;low:Ipp64f;high:Ipp64f;pSeed:PlongWord):IppStatus;
begin
  result:=ippsRandUniform_Direct_64f(pDst,len,low,high,pSeed);
end;

function ippsRandGauss_Direct(pDst:PIpp16s;len:longint;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;
begin
  result:=ippsRandGauss_Direct_16s(pDst,len,mean,stdev,pSeed);
end;

function ippsRandGauss_Direct(pDst:PIpp32f;len:longint;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;
begin
  result:=ippsRandGauss_Direct_32f(pDst,len,mean,stdev,pSeed);
end;

function ippsRandGauss_Direct(pDst:PIpp64f;len:longint;mean:Ipp64f;stdev:Ipp64f;pSeed:PlongWord):IppStatus;
begin
  result:=ippsRandGauss_Direct_64f(pDst,len,mean,stdev,pSeed);
end;

function ippsRandUniformInitAlloc(var pRandUniState:PIppsRandUniState_8u;low:Ipp8u;high:Ipp8u;seed:longWord):IppStatus;
begin
  result:=ippsRandUniformInitAlloc_8u(pRandUniState,low,high,seed);
end;

function ippsRandUniformInitAlloc(var pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;
begin
  result:=ippsRandUniformInitAlloc_16s(pRandUniState,low,high,seed);
end;

function ippsRandUniformInitAlloc(var pRandUniState:PIppsRandUniState_32f;low:Ipp32f;high:Ipp32f;seed:longWord):IppStatus;
begin
  result:=ippsRandUniformInitAlloc_32f(pRandUniState,low,high,seed);
end;

function ippsRandUniform(pDst:PIpp8u;len:longint;pRandUniState:PIppsRandUniState_8u):IppStatus;
begin
  result:=ippsRandUniform_8u(pDst,len,pRandUniState);
end;

function ippsRandUniform(pDst:PIpp16s;len:longint;pRandUniState:PIppsRandUniState_16s):IppStatus;
begin
  result:=ippsRandUniform_16s(pDst,len,pRandUniState);
end;

function ippsRandUniform(pDst:PIpp32f;len:longint;pRandUniState:PIppsRandUniState_32f):IppStatus;
begin
  result:=ippsRandUniform_32f(pDst,len,pRandUniState);
end;

function ippsRandUniformFree(pRandUniState:PIppsRandUniState_8u):IppStatus;
begin
  result:=ippsRandUniformFree_8u(pRandUniState);
end;

function ippsRandUniformFree(pRandUniState:PIppsRandUniState_16s):IppStatus;
begin
  result:=ippsRandUniformFree_16s(pRandUniState);
end;

function ippsRandUniformFree(pRandUniState:PIppsRandUniState_32f):IppStatus;
begin
  result:=ippsRandUniformFree_32f(pRandUniState);
end;

function ippsRandGaussInitAlloc(var pRandGaussState:PIppsRandGaussState_8u;mean:Ipp8u;stdDev:Ipp8u;seed:longWord):IppStatus;
begin
  result:=ippsRandGaussInitAlloc_8u(pRandGaussState,mean,stdDev,seed);
end;

function ippsRandGaussInitAlloc(var pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;
begin
  result:=ippsRandGaussInitAlloc_16s(pRandGaussState,mean,stdDev,seed);
end;

function ippsRandGaussInitAlloc(var pRandGaussState:PIppsRandGaussState_32f;mean:Ipp32f;stdDev:Ipp32f;seed:longWord):IppStatus;
begin
  result:=ippsRandGaussInitAlloc_32f(pRandGaussState,mean,stdDev,seed);
end;

function ippsRandGauss(pDst:PIpp8u;len:longint;pRandGaussState:PIppsRandGaussState_8u):IppStatus;
begin
  result:=ippsRandGauss_8u(pDst,len,pRandGaussState);
end;

function ippsRandGauss(pDst:PIpp16s;len:longint;pRandGaussState:PIppsRandGaussState_16s):IppStatus;
begin
  result:=ippsRandGauss_16s(pDst,len,pRandGaussState);
end;

function ippsRandGauss(pDst:PIpp32f;len:longint;pRandGaussState:PIppsRandGaussState_32f):IppStatus;
begin
  result:=ippsRandGauss_32f(pDst,len,pRandGaussState);
end;

function ippsRandGaussFree(pRandGaussState:PIppsRandGaussState_8u):IppStatus;
begin
  result:=ippsRandGaussFree_8u(pRandGaussState);
end;

function ippsRandGaussFree(pRandGaussState:PIppsRandGaussState_16s):IppStatus;
begin
  result:=ippsRandGaussFree_16s(pRandGaussState);
end;

function ippsRandGaussFree(pRandGaussState:PIppsRandGaussState_32f):IppStatus;
begin
  result:=ippsRandGaussFree_32f(pRandGaussState);
end;

function ippsRandGaussGetSize(pRandGaussStateSize:Plongint):IppStatus;
begin
  result:=ippsRandGaussGetSize_16s(pRandGaussStateSize);
end;

function ippsRandGaussInit(pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;
begin
  result:=ippsRandGaussInit_16s(pRandGaussState,mean,stdDev,seed);
end;

function ippsRandUniformGetSize(pRandUniformStateSize:Plongint):IppStatus;
begin
  result:=ippsRandUniformGetSize_16s(pRandUniformStateSize);
end;

function ippsRandUniformInit(pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;
begin
  result:=ippsRandUniformInit_16s(pRandUniState,low,high,seed);
end;

function ippsVectorJaehne(pDst:PIpp8u;len:longint;magn:Ipp8u):IppStatus;
begin
  result:=ippsVectorJaehne_8u(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp8s;len:longint;magn:Ipp8s):IppStatus;
begin
  result:=ippsVectorJaehne_8s(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp16u;len:longint;magn:Ipp16u):IppStatus;
begin
  result:=ippsVectorJaehne_16u(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp16s;len:longint;magn:Ipp16s):IppStatus;
begin
  result:=ippsVectorJaehne_16s(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp32u;len:longint;magn:Ipp32u):IppStatus;
begin
  result:=ippsVectorJaehne_32u(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp32s;len:longint;magn:Ipp32s):IppStatus;
begin
  result:=ippsVectorJaehne_32s(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp32f;len:longint;magn:Ipp32f):IppStatus;
begin
  result:=ippsVectorJaehne_32f(pDst,len,magn);
end;

function ippsVectorJaehne(pDst:PIpp64f;len:longint;magn:Ipp64f):IppStatus;
begin
  result:=ippsVectorJaehne_64f(pDst,len,magn);
end;

function ippsTone_Direct(pDst:PIpp32f;len:longint;magn:single;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsTone_Direct_32f(pDst,len,magn,rFreq,pPhase,hint);
end;

function ippsTone_Direct(pDst:PIpp32fc;len:longint;magn:single;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsTone_Direct_32fc(pDst,len,magn,rFreq,pPhase,hint);
end;

function ippsTone_Direct(pDst:PIpp64f;len:longint;magn:double;rFreq:double;pPhase:Pdouble;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsTone_Direct_64f(pDst,len,magn,rFreq,pPhase,hint);
end;

function ippsTone_Direct(pDst:PIpp64fc;len:longint;magn:double;rFreq:double;pPhase:Pdouble;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsTone_Direct_64fc(pDst,len,magn,rFreq,pPhase,hint);
end;

function ippsTone_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsTone_Direct_16s(pDst,len,magn,rFreq,pPhase,hint);
end;

function ippsTone_Direct(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:single;pPhase:Psingle;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsTone_Direct_16sc(pDst,len,magn,rFreq,pPhase,hint);
end;

function ippsToneInitAllocQ15(var pToneState:PIppToneState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;
begin
  result:=ippsToneInitAllocQ15_16s(pToneState,magn,rFreqQ15,phaseQ15);
end;

function ippsToneGetStateSizeQ15(pToneStateSize:Plongint):IppStatus;
begin
  result:=ippsToneGetStateSizeQ15_16s(pToneStateSize);
end;

function ippsToneInitQ15(pToneState:PIppToneState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;
begin
  result:=ippsToneInitQ15_16s(pToneState,magn,rFreqQ15,phaseQ15);
end;

function ippsToneQ15(pDst:PIpp16s;len:longint;pToneState:PIppToneState_16s):IppStatus;
begin
  result:=ippsToneQ15_16s(pDst,len,pToneState);
end;

function ippsTriangle_Direct(pDst:PIpp64f;len:longint;magn:double;rFreq:double;asym:double;pPhase:Pdouble):IppStatus;
begin
  result:=ippsTriangle_Direct_64f(pDst,len,magn,rFreq,asym,pPhase);
end;

function ippsTriangle_Direct(pDst:PIpp64fc;len:longint;magn:double;rFreq:double;asym:double;pPhase:Pdouble):IppStatus;
begin
  result:=ippsTriangle_Direct_64fc(pDst,len,magn,rFreq,asym,pPhase);
end;

function ippsTriangle_Direct(pDst:PIpp32f;len:longint;magn:single;rFreq:single;asym:single;pPhase:Psingle):IppStatus;
begin
  result:=ippsTriangle_Direct_32f(pDst,len,magn,rFreq,asym,pPhase);
end;

function ippsTriangle_Direct(pDst:PIpp32fc;len:longint;magn:single;rFreq:single;asym:single;pPhase:Psingle):IppStatus;
begin
  result:=ippsTriangle_Direct_32fc(pDst,len,magn,rFreq,asym,pPhase);
end;

function ippsTriangle_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:single;asym:single;pPhase:Psingle):IppStatus;
begin
  result:=ippsTriangle_Direct_16s(pDst,len,magn,rFreq,asym,pPhase);
end;

function ippsTriangle_Direct(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:single;asym:single;pPhase:Psingle):IppStatus;
begin
  result:=ippsTriangle_Direct_16sc(pDst,len,magn,rFreq,asym,pPhase);
end;

function ippsTriangleInitAllocQ15(var pTriangleState:PIppTriangleState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;
begin
  result:=ippsTriangleInitAllocQ15_16s(pTriangleState,magn,rFreqQ15,phaseQ15,asymQ15);
end;

function ippsTriangleGetStateSizeQ15(pTriangleStateSize:Plongint):IppStatus;
begin
  result:=ippsTriangleGetStateSizeQ15_16s(pTriangleStateSize);
end;

function ippsTriangleInitQ15(pTriangleState:PIppTriangleState_16s;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;
begin
  result:=ippsTriangleInitQ15_16s(pTriangleState,magn,rFreqQ15,phaseQ15,asymQ15);
end;

function ippsTriangleQ15(pDst:PIpp16s;len:longint;pTriangleState:PIppTriangleState_16s):IppStatus;
begin
  result:=ippsTriangleQ15_16s(pDst,len,pTriangleState);
end;

function ippsToneQ15_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s):IppStatus;
begin
  result:=ippsToneQ15_Direct_16s(pDst,len,magn,rFreqQ15,phaseQ15);
end;

function ippsTriangleQ15_Direct(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreqQ15:Ipp16s;phaseQ15:Ipp32s;asymQ15:Ipp32s):IppStatus;
begin
  result:=ippsTriangleQ15_Direct_16s(pDst,len,magn,rFreqQ15,phaseQ15,asymQ15);
end;

function ippsVectorRamp(pDst:PIpp8u;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_8u(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp8s;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_8s(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp16u;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_16u(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp16s;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_16s(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp32u;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_32u(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp32s;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_32s(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp32f;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_32f(pDst,len,offset,slope);
end;

function ippsVectorRamp(pDst:PIpp64f;len:longint;offset:single;slope:single):IppStatus;
begin
  result:=ippsVectorRamp_64f(pDst,len,offset,slope);
end;

function ippsReal(pSrc:PIpp64fc;pDstRe:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsReal_64fc(pSrc,pDstRe,len);
end;

function ippsReal(pSrc:PIpp32fc;pDstRe:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsReal_32fc(pSrc,pDstRe,len);
end;

function ippsReal(pSrc:PIpp16sc;pDstRe:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsReal_16sc(pSrc,pDstRe,len);
end;

function ippsImag(pSrc:PIpp64fc;pDstIm:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsImag_64fc(pSrc,pDstIm,len);
end;

function ippsImag(pSrc:PIpp32fc;pDstIm:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsImag_32fc(pSrc,pDstIm,len);
end;

function ippsImag(pSrc:PIpp16sc;pDstIm:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsImag_16sc(pSrc,pDstIm,len);
end;

function ippsCplxToReal(pSrc:PIpp64fc;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsCplxToReal_64fc(pSrc,pDstRe,pDstIm,len);
end;

function ippsCplxToReal(pSrc:PIpp32fc;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsCplxToReal_32fc(pSrc,pDstRe,pDstIm,len);
end;

function ippsCplxToReal(pSrc:PIpp16sc;pDstRe:PIpp16s;pDstIm:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsCplxToReal_16sc(pSrc,pDstRe,pDstIm,len);
end;

function ippsRealToCplx(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsRealToCplx_64f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsRealToCplx(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsRealToCplx_32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsRealToCplx(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsRealToCplx_16s(pSrcRe,pSrcIm,pDst,len);
end;

function ippsConj(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsConj_64fc_I(pSrcDst,len);
end;

function ippsConj(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsConj_32fc_I(pSrcDst,len);
end;

function ippsConj(pSrcDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsConj_16sc_I(pSrcDst,len);
end;

function ippsConj(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsConj_64fc(pSrc,pDst,len);
end;

function ippsConj(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsConj_32fc(pSrc,pDst,len);
end;

function ippsConj(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsConj_16sc(pSrc,pDst,len);
end;

function ippsConjFlip(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsConjFlip_64fc(pSrc,pDst,len);
end;

function ippsConjFlip(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsConjFlip_32fc(pSrc,pDst,len);
end;

function ippsConjFlip(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsConjFlip_16sc(pSrc,pDst,len);
end;

function ippsConjCcs(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjCcs_64fc_I(pSrcDst,lenDst);
end;

function ippsConjCcs(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjCcs_32fc_I(pSrcDst,lenDst);
end;

function ippsConjCcs(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;
begin
  result:=ippsConjCcs_16sc_I(pSrcDst,lenDst);
end;

function ippsConjCcs(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjCcs_64fc(pSrc,pDst,lenDst);
end;

function ippsConjCcs(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjCcs_32fc(pSrc,pDst,lenDst);
end;

function ippsConjCcs(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;
begin
  result:=ippsConjCcs_16sc(pSrc,pDst,lenDst);
end;

function ippsConjPack(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPack_64fc_I(pSrcDst,lenDst);
end;

function ippsConjPack(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPack_32fc_I(pSrcDst,lenDst);
end;

function ippsConjPack(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPack_16sc_I(pSrcDst,lenDst);
end;

function ippsConjPack(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPack_64fc(pSrc,pDst,lenDst);
end;

function ippsConjPack(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPack_32fc(pSrc,pDst,lenDst);
end;

function ippsConjPack(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPack_16sc(pSrc,pDst,lenDst);
end;

function ippsConjPerm(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPerm_64fc_I(pSrcDst,lenDst);
end;

function ippsConjPerm(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPerm_32fc_I(pSrcDst,lenDst);
end;

function ippsConjPerm(pSrcDst:PIpp16sc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPerm_16sc_I(pSrcDst,lenDst);
end;

function ippsConjPerm(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPerm_64fc(pSrc,pDst,lenDst);
end;

function ippsConjPerm(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPerm_32fc(pSrc,pDst,lenDst);
end;

function ippsConjPerm(pSrc:PIpp16s;pDst:PIpp16sc;lenDst:longint):IppStatus;
begin
  result:=ippsConjPerm_16sc(pSrc,pDst,lenDst);
end;

function ippsConvert(pSrc:PIpp8s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsConvert_8s16s(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp16s;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsConvert_16s32s(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsConvert_32s16s(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp8s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_8s32f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_8u32f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_16s32f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp16u;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_16u32f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsConvert_32s64f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_32s32f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp8s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32f8s_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp8u;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32f8u_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp16s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32f16s_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp16u;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32f16u_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp64f;pDst:PIpp32s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_64f32s_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp32s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32f32s_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsConvert_32f64f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_64f32f(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp16s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_16s32f_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp16s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_16s64f_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32s32f_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32s64f_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32s16s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp8u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsConvert_24u32u(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp32u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32u24u_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32f24u_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp8u;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsConvert_24s32s(pSrc,pDst,len);
end;

function ippsConvert(pSrc:PIpp32s;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_32s24s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsConvert(pSrc:PIpp16s;pDst:PIpp16f;len:longint;rndmode:IppRoundMode):IppStatus;
begin
  result:=ippsConvert_16s16f(pSrc,pDst,len,rndmode);
end;

function ippsConvert(pSrc:PIpp16f;pDst:PIpp16s;len:longint;rndmode:IppRoundMode;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvert_16f16s_Sfs(pSrc,pDst,len,rndmode,scaleFactor);
end;

function ippsConvert(pSrc:PIpp32f;pDst:PIpp16f;len:longint;rndmode:IppRoundMode):IppStatus;
begin
  result:=ippsConvert_32f16f(pSrc,pDst,len,rndmode);
end;

function ippsConvert(pSrc:PIpp16f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsConvert_16f32f(pSrc,pDst,len);
end;

function ippsThreshold(pSrcDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_32f_I(pSrcDst,len,level,relOp);
end;

function ippsThreshold(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_32fc_I(pSrcDst,len,level,relOp);
end;

function ippsThreshold(pSrcDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_64f_I(pSrcDst,len,level,relOp);
end;

function ippsThreshold(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_64fc_I(pSrcDst,len,level,relOp);
end;

function ippsThreshold(pSrcDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_16s_I(pSrcDst,len,level,relOp);
end;

function ippsThreshold(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_16sc_I(pSrcDst,len,level,relOp);
end;

function ippsThreshold(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_32f(pSrc,pDst,len,level,relOp);
end;

function ippsThreshold(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_32fc(pSrc,pDst,len,level,relOp);
end;

function ippsThreshold(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_64f(pSrc,pDst,len,level,relOp);
end;

function ippsThreshold(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_64fc(pSrc,pDst,len,level,relOp);
end;

function ippsThreshold(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_16s(pSrc,pDst,len,level,relOp);
end;

function ippsThreshold(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;
begin
  result:=ippsThreshold_16sc(pSrc,pDst,len,level,relOp);
end;

function ippsThreshold_LT(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LT_32f_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LT_32fc_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LT_64f_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LT_64fc_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LT_16s_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LT_16sc_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LT_32f(pSrc,pDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LT_32fc(pSrc,pDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LT_64f(pSrc,pDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LT_64fc(pSrc,pDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LT_16s(pSrc,pDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LT_16sc(pSrc,pDst,len,level);
end;

function ippsThreshold_LT(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;
begin
  result:=ippsThreshold_LT_32s_I(pSrcDst,len,level);
end;

function ippsThreshold_LT(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;
begin
  result:=ippsThreshold_LT_32s(pSrc,pDst,len,level);
end;

function ippsThreshold_GT(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_GT_32f_I(pSrcDst,len,level);
end;

function ippsThreshold_GT(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_GT_32fc_I(pSrcDst,len,level);
end;

function ippsThreshold_GT(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_GT_64f_I(pSrcDst,len,level);
end;

function ippsThreshold_GT(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_GT_64fc_I(pSrcDst,len,level);
end;

function ippsThreshold_GT(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_GT_16s_I(pSrcDst,len,level);
end;

function ippsThreshold_GT(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_GT_16sc_I(pSrcDst,len,level);
end;

function ippsThreshold_GT(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_GT_32f(pSrc,pDst,len,level);
end;

function ippsThreshold_GT(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_GT_32fc(pSrc,pDst,len,level);
end;

function ippsThreshold_GT(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_GT_64f(pSrc,pDst,len,level);
end;

function ippsThreshold_GT(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_GT_64fc(pSrc,pDst,len,level);
end;

function ippsThreshold_GT(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_GT_16s(pSrc,pDst,len,level);
end;

function ippsThreshold_GT(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_GT_16sc(pSrc,pDst,len,level);
end;

function ippsThreshold_LTVal(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTVal_32f_I(pSrcDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;
begin
  result:=ippsThreshold_LTVal_32fc_I(pSrcDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTVal_64f_I(pSrcDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;
begin
  result:=ippsThreshold_LTVal_64fc_I(pSrcDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LTVal_16s_I(pSrcDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;
begin
  result:=ippsThreshold_LTVal_16sc_I(pSrcDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTVal_32f(pSrc,pDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;
begin
  result:=ippsThreshold_LTVal_32fc(pSrc,pDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTVal_64f(pSrc,pDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;
begin
  result:=ippsThreshold_LTVal_64fc(pSrc,pDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LTVal_16s(pSrc,pDst,len,level,value);
end;

function ippsThreshold_LTVal(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;
begin
  result:=ippsThreshold_LTVal_16sc(pSrc,pDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_GTVal_32f_I(pSrcDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;
begin
  result:=ippsThreshold_GTVal_32fc_I(pSrcDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_GTVal_64f_I(pSrcDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;
begin
  result:=ippsThreshold_GTVal_64fc_I(pSrcDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_GTVal_16s_I(pSrcDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;
begin
  result:=ippsThreshold_GTVal_16sc_I(pSrcDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_GTVal_32f(pSrc,pDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;
begin
  result:=ippsThreshold_GTVal_32fc(pSrc,pDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_GTVal_64f(pSrc,pDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;
begin
  result:=ippsThreshold_GTVal_64fc(pSrc,pDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_GTVal_16s(pSrc,pDst,len,level,value);
end;

function ippsThreshold_GTVal(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;
begin
  result:=ippsThreshold_GTVal_16sc(pSrc,pDst,len,level,value);
end;

function ippsThreshold_LTInv(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTInv_32f_I(pSrcDst,len,level);
end;

function ippsThreshold_LTInv(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTInv_32fc_I(pSrcDst,len,level);
end;

function ippsThreshold_LTInv(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTInv_64f_I(pSrcDst,len,level);
end;

function ippsThreshold_LTInv(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTInv_64fc_I(pSrcDst,len,level);
end;

function ippsThreshold_LTInv(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTInv_32f(pSrc,pDst,len,level);
end;

function ippsThreshold_LTInv(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTInv_32fc(pSrc,pDst,len,level);
end;

function ippsThreshold_LTInv(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTInv_64f(pSrc,pDst,len,level);
end;

function ippsThreshold_LTInv(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTInv_64fc(pSrc,pDst,len,level);
end;

function ippsThreshold_LTValGTVal(pSrcDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTValGTVal_32f_I(pSrcDst,len,levelLT,valueLT,levelGT,valueGT);
end;

function ippsThreshold_LTValGTVal(pSrcDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTValGTVal_64f_I(pSrcDst,len,levelLT,valueLT,levelGT,valueGT);
end;

function ippsThreshold_LTValGTVal(pSrc:PIpp32f;pDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;
begin
  result:=ippsThreshold_LTValGTVal_32f(pSrc,pDst,len,levelLT,valueLT,levelGT,valueGT);
end;

function ippsThreshold_LTValGTVal(pSrc:PIpp64f;pDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;
begin
  result:=ippsThreshold_LTValGTVal_64f(pSrc,pDst,len,levelLT,valueLT,levelGT,valueGT);
end;

function ippsThreshold_LTValGTVal(pSrcDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LTValGTVal_16s_I(pSrcDst,len,levelLT,valueLT,levelGT,valueGT);
end;

function ippsThreshold_LTValGTVal(pSrc:PIpp16s;pDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;
begin
  result:=ippsThreshold_LTValGTVal_16s(pSrc,pDst,len,levelLT,valueLT,levelGT,valueGT);
end;

function ippsCartToPolar(pSrc:PIpp32fc;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsCartToPolar_32fc(pSrc,pDstMagn,pDstPhase,len);
end;

function ippsCartToPolar(pSrc:PIpp64fc;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsCartToPolar_64fc(pSrc,pDstMagn,pDstPhase,len);
end;

function ippsCartToPolar(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsCartToPolar_32f(pSrcRe,pSrcIm,pDstMagn,pDstPhase,len);
end;

function ippsCartToPolar(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsCartToPolar_64f(pSrcRe,pSrcIm,pDstMagn,pDstPhase,len);
end;

function ippsPolarToCart(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsPolarToCart_32fc(pSrcMagn,pSrcPhase,pDst,len);
end;

function ippsPolarToCart(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsPolarToCart_64fc(pSrcMagn,pSrcPhase,pDst,len);
end;

function ippsPolarToCart(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPolarToCart_32f(pSrcMagn,pSrcPhase,pDstRe,pDstIm,len);
end;

function ippsPolarToCart(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsPolarToCart_64f(pSrcMagn,pSrcPhase,pDstRe,pDstIm,len);
end;

function ippsALawToLin(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsALawToLin_8u32f(pSrc,pDst,len);
end;

function ippsALawToLin(pSrc:PIpp8u;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsALawToLin_8u16s(pSrc,pDst,len);
end;

function ippsMuLawToLin(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMuLawToLin_8u32f(pSrc,pDst,len);
end;

function ippsMuLawToLin(pSrc:PIpp8u;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMuLawToLin_8u16s(pSrc,pDst,len);
end;

function ippsLinToALaw(pSrc:PIpp32f;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsLinToALaw_32f8u(pSrc,pDst,len);
end;

function ippsLinToALaw(pSrc:PIpp16s;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsLinToALaw_16s8u(pSrc,pDst,len);
end;

function ippsLinToMuLaw(pSrc:PIpp32f;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsLinToMuLaw_32f8u(pSrc,pDst,len);
end;

function ippsLinToMuLaw(pSrc:PIpp16s;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsLinToMuLaw_16s8u(pSrc,pDst,len);
end;

function ippsALawToMuLaw(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsALawToMuLaw_8u(pSrc,pDst,len);
end;

function ippsMuLawToALaw(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsMuLawToALaw_8u(pSrc,pDst,len);
end;

function ippsPreemphasize(pSrcDst:PIpp32f;len:longint;val:Ipp32f):IppStatus;
begin
  result:=ippsPreemphasize_32f(pSrcDst,len,val);
end;

function ippsPreemphasize(pSrcDst:PIpp16s;len:longint;val:Ipp32f):IppStatus;
begin
  result:=ippsPreemphasize_16s(pSrcDst,len,val);
end;

function ippsFlip(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsFlip_8u(pSrc,pDst,len);
end;

function ippsFlip(pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsFlip_8u_I(pSrcDst,len);
end;

function ippsFlip(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsFlip_16u(pSrc,pDst,len);
end;

function ippsFlip(pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsFlip_16u_I(pSrcDst,len);
end;

function ippsFlip(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsFlip_32f(pSrc,pDst,len);
end;

function ippsFlip(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsFlip_32f_I(pSrcDst,len);
end;

function ippsFlip(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsFlip_64f(pSrc,pDst,len);
end;

function ippsFlip(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsFlip_64f_I(pSrcDst,len);
end;

function ippsUpdateLinear(pSrc:PIpp16s;len:longint;pSrcDst:PIpp32s;srcShiftRight:longint;alpha:Ipp16s;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsUpdateLinear_16s32s_I(pSrc,len,pSrcDst,srcShiftRight,alpha,hint);
end;

function ippsUpdatePower(pSrc:PIpp16s;len:longint;pSrcDst:PIpp32s;srcShiftRight:longint;alpha:Ipp16s;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsUpdatePower_16s32s_I(pSrc,len,pSrcDst,srcShiftRight,alpha,hint);
end;

function ippsJoin(var pSrc:PIpp32f;nChannels:longint;chanLen:longint;pDst:PIpp16s):IppStatus;
begin
  result:=ippsJoin_32f16s_D2L(pSrc,nChannels,chanLen,pDst);
end;

function ippsSwapBytes(pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsSwapBytes_16u_I(pSrcDst,len);
end;

function ippsSwapBytes(pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsSwapBytes_24u_I(pSrcDst,len);
end;

function ippsSwapBytes(pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsSwapBytes_32u_I(pSrcDst,len);
end;

function ippsSwapBytes(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsSwapBytes_16u(pSrc,pDst,len);
end;

function ippsSwapBytes(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsSwapBytes_24u(pSrc,pDst,len);
end;

function ippsSwapBytes(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsSwapBytes_32u(pSrc,pDst,len);
end;

function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAddC_16s_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSubC_16s_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMulC_16s_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAddC_32f_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAddC_32fc_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubC_32f_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubC_32fc_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32f_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32fc_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMulC_32f_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMulC_32fc_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAddC_64f_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAddC_64fc_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubC_64f_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubC_64fc_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64f_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64fc_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMulC_64f_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMulC_64fc_I(val,pSrcDst,len);
end;

function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32f16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC_Low(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMulC_Low_32f16s(pSrc,val,pDst,len);
end;

function ippsAddC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAddC_32f(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAddC_32fc(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubC_32f(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubC_32fc(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32f(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32fc(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMulC_32f(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMulC_32fc(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAddC_64f(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAddC_64fc(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubC_64f(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubC_64fc(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64f(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64fc(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMulC_64f(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMulC_64fc(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAdd_16s_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSub_16s_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMul_16s_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAdd_32f_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAdd_32fc_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSub_32f_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSub_32fc_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMul_32f_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMul_32fc_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAdd_64f_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAdd_64fc_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSub_64f_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSub_64fc_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMul_64f_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMul_64fc_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAdd_8u16u(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsMul_8u16u(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAdd_16s(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSub_16s(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMul_16s(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAdd_16u(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsAdd_32u(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAdd_16s32f(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSub_16s32f(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMul_16s32f(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAdd_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAdd_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSub_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSub_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMul_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMul_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAdd_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAdd_64fc(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSub_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSub_64fc(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMul_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMul_64fc(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16s32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16u;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16u16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAddProduct(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddProduct_16s_Sfs(pSrc1,pSrc2,pSrcDst,len,scaleFactor);
end;

function ippsAddProduct(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddProduct_16s32s_Sfs(pSrc1,pSrc2,pSrcDst,len,scaleFactor);
end;

function ippsAddProduct(pSrc1:PIpp32s;pSrc2:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddProduct_32s_Sfs(pSrc1,pSrc2,pSrcDst,len,scaleFactor);
end;

function ippsAddProduct(pSrc1:PIpp32f;pSrc2:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAddProduct_32f(pSrc1,pSrc2,pSrcDst,len);
end;

function ippsAddProduct(pSrc1:PIpp64f;pSrc2:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAddProduct_64f(pSrc1,pSrc2,pSrcDst,len);
end;

function ippsAddProduct(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAddProduct_32fc(pSrc1,pSrc2,pSrcDst,len);
end;

function ippsAddProduct(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAddProduct_64fc(pSrc1,pSrc2,pSrcDst,len);
end;

function ippsSqr(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSqr_32f_I(pSrcDst,len);
end;

function ippsSqr(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSqr_32fc_I(pSrcDst,len);
end;

function ippsSqr(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSqr_64f_I(pSrcDst,len);
end;

function ippsSqr(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSqr_64fc_I(pSrcDst,len);
end;

function ippsSqr(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSqr_32f(pSrc,pDst,len);
end;

function ippsSqr(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSqr_32fc(pSrc,pDst,len);
end;

function ippsSqr(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSqr_64f(pSrc,pDst,len);
end;

function ippsSqr(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSqr_64fc(pSrc,pDst,len);
end;

function ippsSqr(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_16s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqr(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_16sc_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqr(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_16s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqr(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_16sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqr(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_8u_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqr(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_8u_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqr(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_16u_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqr(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqr_16u_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsDiv(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsDiv_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsDiv(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsDiv_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsDiv(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsDiv_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsDiv(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsDiv_64fc(pSrc1,pSrc2,pDst,len);
end;

function ippsDiv(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsDiv(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsDiv(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsDivC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsDivC_32f(pSrc,val,pDst,len);
end;

function ippsDivC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsDivC_32fc(pSrc,val,pDst,len);
end;

function ippsDivC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsDivC_64f(pSrc,val,pDst,len);
end;

function ippsDivC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsDivC_64fc(pSrc,val,pDst,len);
end;

function ippsDivC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDivC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsDivC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDivC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsDivC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDivC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsDiv(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsDiv_32f_I(pSrc,pSrcDst,len);
end;

function ippsDiv(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsDiv_32fc_I(pSrc,pSrcDst,len);
end;

function ippsDiv(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsDiv_64f_I(pSrc,pSrcDst,len);
end;

function ippsDiv(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsDiv_64fc_I(pSrc,pSrcDst,len);
end;

function ippsDiv(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsDiv(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsDiv(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsDiv(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsDiv(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;ScaleFactor:longint):IppStatus;
begin
  result:=ippsDiv_32s_ISfs(pSrc,pSrcDst,len,ScaleFactor);
end;

function ippsDivC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsDivC_32f_I(val,pSrcDst,len);
end;

function ippsDivC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsDivC_32fc_I(val,pSrcDst,len);
end;

function ippsDivC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsDivC_64f_I(val,pSrcDst,len);
end;

function ippsDivC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsDivC_64fc_I(val,pSrcDst,len);
end;

function ippsDivC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDivC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsDivC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDivC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsDivC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsDivC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsDivCRev(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsDivCRev_16u(pSrc,val,pDst,len);
end;

function ippsDivCRev(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsDivCRev_32f(pSrc,val,pDst,len);
end;

function ippsDivCRev(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsDivCRev_16u_I(val,pSrcDst,len);
end;

function ippsDivCRev(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsDivCRev_32f_I(val,pSrcDst,len);
end;

function ippsSqrt(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSqrt_32f_I(pSrcDst,len);
end;

function ippsSqrt(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSqrt_32fc_I(pSrcDst,len);
end;

function ippsSqrt(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSqrt_64f_I(pSrcDst,len);
end;

function ippsSqrt(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSqrt_64fc_I(pSrcDst,len);
end;

function ippsSqrt(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSqrt_32f(pSrc,pDst,len);
end;

function ippsSqrt(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSqrt_32fc(pSrc,pDst,len);
end;

function ippsSqrt(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSqrt_64f(pSrc,pDst,len);
end;

function ippsSqrt(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSqrt_64fc(pSrc,pDst,len);
end;

function ippsSqrt(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_16s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqrt(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_16sc_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqrt(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_16s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqrt(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_16sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqrt(pSrcDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_64s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqrt(pSrc:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_64s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqrt(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_8u_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqrt(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_8u_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsSqrt(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_16u_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsSqrt(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSqrt_16u_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsCubrt(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;sFactor:longint):IppStatus;
begin
  result:=ippsCubrt_32s16s_Sfs(pSrc,pDst,Len,sFactor);
end;

function ippsCubrt(pSrc:PIpp32f;pDst:PIpp32f;Len:longint):IppStatus;
begin
  result:=ippsCubrt_32f(pSrc,pDst,Len);
end;

function ippsAbs(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAbs_32f_I(pSrcDst,len);
end;

function ippsAbs(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAbs_64f_I(pSrcDst,len);
end;

function ippsAbs(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAbs_16s_I(pSrcDst,len);
end;

function ippsAbs(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAbs_32f(pSrc,pDst,len);
end;

function ippsAbs(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAbs_64f(pSrc,pDst,len);
end;

function ippsAbs(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAbs_16s(pSrc,pDst,len);
end;

function ippsAbs(pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsAbs_32s_I(pSrcDst,len);
end;

function ippsAbs(pSrc:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsAbs_32s(pSrc,pDst,len);
end;

function ippsMagnitude(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMagnitude_32fc(pSrc,pDst,len);
end;

function ippsMagnitude(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMagnitude_64fc(pSrc,pDst,len);
end;

function ippsMagnitude(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMagnitude_16sc32f(pSrc,pDst,len);
end;

function ippsMagnitude(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMagnitude_16sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsMagnitude(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMagnitude_32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsMagnitude(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMagnitude_64f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsMagnitude(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMagnitude_16s_Sfs(pSrcRe,pSrcIm,pDst,len,scaleFactor);
end;

function ippsMagnitude(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMagnitude_32sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsMagnitude(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMagnitude_16s32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsMagSquared(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMagSquared_32sc32s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsExp(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsExp_32f_I(pSrcDst,len);
end;

function ippsExp(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsExp_64f_I(pSrcDst,len);
end;

function ippsExp(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsExp_16s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsExp(pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsExp_32s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsExp(pSrcDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsExp_64s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsExp(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsExp_32f(pSrc,pDst,len);
end;

function ippsExp(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsExp_64f(pSrc,pDst,len);
end;

function ippsExp(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsExp_16s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsExp(pSrc:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsExp_32s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsExp(pSrc:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsExp_64s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsExp(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsExp_32f64f(pSrc,pDst,len);
end;

function ippsLn(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsLn_32f_I(pSrcDst,len);
end;

function ippsLn(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsLn_64f_I(pSrcDst,len);
end;

function ippsLn(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsLn_32f(pSrc,pDst,len);
end;

function ippsLn(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsLn_64f(pSrc,pDst,len);
end;

function ippsLn(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsLn_64f32f(pSrc,pDst,len);
end;

function ippsLn(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsLn_16s_ISfs(pSrcDst,len,scaleFactor);
end;

function ippsLn(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsLn_16s_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsLn(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsLn_32s16s_Sfs(pSrc,pDst,Len,scaleFactor);
end;

function ippsLn(pSrcDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsLn_32s_ISfs(pSrcDst,Len,scaleFactor);
end;

function ippsLn(pSrc:PIpp32s;pDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsLn_32s_Sfs(pSrc,pDst,Len,scaleFactor);
end;

function ipps10Log10(pSrcDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ipps10Log10_32s_ISfs(pSrcDst,Len,scaleFactor);
end;

function ipps10Log10(pSrc:PIpp32s;pDst:PIpp32s;Len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ipps10Log10_32s_Sfs(pSrc,pDst,Len,scaleFactor);
end;

function ippsSumLn(pSrc:PIpp32f;len:longint;pSum:PIpp32f):IppStatus;
begin
  result:=ippsSumLn_32f(pSrc,len,pSum);
end;

function ippsSumLn(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;
begin
  result:=ippsSumLn_64f(pSrc,len,pSum);
end;

function ippsSumLn(pSrc:PIpp32f;len:longint;pSum:PIpp64f):IppStatus;
begin
  result:=ippsSumLn_32f64f(pSrc,len,pSum);
end;

function ippsSumLn(pSrc:PIpp16s;len:longint;pSum:PIpp32f):IppStatus;
begin
  result:=ippsSumLn_16s32f(pSrc,len,pSum);
end;

function ippsSortAscend(pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsSortAscend_8u_I(pSrcDst,len);
end;

function ippsSortAscend(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSortAscend_16s_I(pSrcDst,len);
end;

function ippsSortAscend(pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsSortAscend_32s_I(pSrcDst,len);
end;

function ippsSortAscend(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSortAscend_32f_I(pSrcDst,len);
end;

function ippsSortAscend(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSortAscend_64f_I(pSrcDst,len);
end;

function ippsSortDescend(pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsSortDescend_8u_I(pSrcDst,len);
end;

function ippsSortDescend(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSortDescend_16s_I(pSrcDst,len);
end;

function ippsSortDescend(pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsSortDescend_32s_I(pSrcDst,len);
end;

function ippsSortDescend(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSortDescend_32f_I(pSrcDst,len);
end;

function ippsSortDescend(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSortDescend_64f_I(pSrcDst,len);
end;

function ippsSum(pSrc:PIpp32f;len:longint;pSum:PIpp32f;Const hint:IppHintAlgorithm=ippAlgHintNone):IppStatus;
begin
  result:=ippsSum_32f(pSrc,len,pSum,hint);
end;

function ippsSum(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;
begin
  result:=ippsSum_64f(pSrc,len,pSum);
end;

function ippsSum(pSrc:PIpp32fc;len:longint;pSum:PIpp32fc; Const hint:IppHintAlgorithm=ippAlgHintNone):IppStatus;
begin
  result:=ippsSum_32fc(pSrc,len,pSum,hint);
end;

function ippsSum(pSrc:PIpp16s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsSum_16s32s_Sfs(pSrc,len,pSum,scaleFactor);
end;

function ippsSum(pSrc:PIpp16sc;len:longint;pSum:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsSum_16sc32sc_Sfs(pSrc,len,pSum,scaleFactor);
end;

function ippsSum(pSrc:PIpp16s;len:longint;pSum:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsSum_16s_Sfs(pSrc,len,pSum,scaleFactor);
end;

function ippsSum(pSrc:PIpp16sc;len:longint;pSum:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsSum_16sc_Sfs(pSrc,len,pSum,scaleFactor);
end;

function ippsSum(pSrc:PIpp32s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsSum_32s_Sfs(pSrc,len,pSum,scaleFactor);
end;

function ippsSum(pSrc:PIpp64fc;len:longint;pSum:PIpp64fc):IppStatus;
begin
  result:=ippsSum_64fc(pSrc,len,pSum);
end;

function ippsMean(pSrc:PIpp32f;len:longint;pMean:PIpp32f;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsMean_32f(pSrc,len,pMean,hint);
end;

function ippsMean(pSrc:PIpp32fc;len:longint;pMean:PIpp32fc;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsMean_32fc(pSrc,len,pMean,hint);
end;

function ippsMean(pSrc:PIpp64f;len:longint;pMean:PIpp64f):IppStatus;
begin
  result:=ippsMean_64f(pSrc,len,pMean);
end;

function ippsMean(pSrc:PIpp16s;len:longint;pMean:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsMean_16s_Sfs(pSrc,len,pMean,scaleFactor);
end;

function ippsMean(pSrc:PIpp16sc;len:longint;pMean:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsMean_16sc_Sfs(pSrc,len,pMean,scaleFactor);
end;

function ippsMean(pSrc:PIpp64fc;len:longint;pMean:PIpp64fc):IppStatus;
begin
  result:=ippsMean_64fc(pSrc,len,pMean);
end;

function ippsStdDev(pSrc:PIpp32f;len:longint;pStdDev:PIpp32f;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsStdDev_32f(pSrc,len,pStdDev,hint);
end;

function ippsStdDev(pSrc:PIpp64f;len:longint;pStdDev:PIpp64f):IppStatus;
begin
  result:=ippsStdDev_64f(pSrc,len,pStdDev);
end;

function ippsStdDev(pSrc:PIpp16s;len:longint;pStdDev:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsStdDev_16s32s_Sfs(pSrc,len,pStdDev,scaleFactor);
end;

function ippsStdDev(pSrc:PIpp16s;len:longint;pStdDev:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsStdDev_16s_Sfs(pSrc,len,pStdDev,scaleFactor);
end;

function ippsMax(pSrc:PIpp32f;len:longint;pMax:PIpp32f):IppStatus;
begin
  result:=ippsMax_32f(pSrc,len,pMax);
end;

function ippsMax(pSrc:PIpp64f;len:longint;pMax:PIpp64f):IppStatus;
begin
  result:=ippsMax_64f(pSrc,len,pMax);
end;

function ippsMax(pSrc:PIpp16s;len:longint;pMax:PIpp16s):IppStatus;
begin
  result:=ippsMax_16s(pSrc,len,pMax);
end;

function ippsMaxIndx(pSrc:PIpp16s;len:longint;pMax:PIpp16s;pIndx:Plongint):IppStatus;
begin
  result:=ippsMaxIndx_16s(pSrc,len,pMax,pIndx);
end;

function ippsMaxIndx(pSrc:PIpp32f;len:longint;pMax:PIpp32f;pIndx:Plongint):IppStatus;
begin
  result:=ippsMaxIndx_32f(pSrc,len,pMax,pIndx);
end;

function ippsMaxIndx(pSrc:PIpp64f;len:longint;pMax:PIpp64f;pIndx:Plongint):IppStatus;
begin
  result:=ippsMaxIndx_64f(pSrc,len,pMax,pIndx);
end;

function ippsMin(pSrc:PIpp32f;len:longint;pMin:PIpp32f):IppStatus;
begin
  result:=ippsMin_32f(pSrc,len,pMin);
end;

function ippsMin(pSrc:PIpp64f;len:longint;pMin:PIpp64f):IppStatus;
begin
  result:=ippsMin_64f(pSrc,len,pMin);
end;

function ippsMin(pSrc:PIpp16s;len:longint;pMin:PIpp16s):IppStatus;
begin
  result:=ippsMin_16s(pSrc,len,pMin);
end;

function ippsMinIndx(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pIndx:Plongint):IppStatus;
begin
  result:=ippsMinIndx_16s(pSrc,len,pMin,pIndx);
end;

function ippsMinIndx(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pIndx:Plongint):IppStatus;
begin
  result:=ippsMinIndx_32f(pSrc,len,pMin,pIndx);
end;

function ippsMinIndx(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pIndx:Plongint):IppStatus;
begin
  result:=ippsMinIndx_64f(pSrc,len,pMin,pIndx);
end;

function ippsMinEvery(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMinEvery_16s_I(pSrc,pSrcDst,len);
end;

function ippsMinEvery(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsMinEvery_32s_I(pSrc,pSrcDst,len);
end;

function ippsMinEvery(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMinEvery_32f_I(pSrc,pSrcDst,len);
end;

function ippsMaxEvery(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMaxEvery_16s_I(pSrc,pSrcDst,len);
end;

function ippsMaxEvery(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsMaxEvery_32s_I(pSrc,pSrcDst,len);
end;

function ippsMaxEvery(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMaxEvery_32f_I(pSrc,pSrcDst,len);
end;

function ippsMinMax(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMax:PIpp64f):IppStatus;
begin
  result:=ippsMinMax_64f(pSrc,len,pMin,pMax);
end;

function ippsMinMax(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMax:PIpp32f):IppStatus;
begin
  result:=ippsMinMax_32f(pSrc,len,pMin,pMax);
end;

function ippsMinMax(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMax:PIpp32s):IppStatus;
begin
  result:=ippsMinMax_32s(pSrc,len,pMin,pMax);
end;

function ippsMinMax(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMax:PIpp32u):IppStatus;
begin
  result:=ippsMinMax_32u(pSrc,len,pMin,pMax);
end;

function ippsMinMax(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMax:PIpp16s):IppStatus;
begin
  result:=ippsMinMax_16s(pSrc,len,pMin,pMax);
end;

function ippsMinMax(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMax:PIpp16u):IppStatus;
begin
  result:=ippsMinMax_16u(pSrc,len,pMin,pMax);
end;

function ippsMinMax(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMax:PIpp8u):IppStatus;
begin
  result:=ippsMinMax_8u(pSrc,len,pMin,pMax);
end;

function ippsMinMaxIndx(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMinIndx:Plongint;pMax:PIpp64f;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_64f(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsMinMaxIndx(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMinIndx:Plongint;pMax:PIpp32f;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_32f(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsMinMaxIndx(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMinIndx:Plongint;pMax:PIpp32s;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_32s(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsMinMaxIndx(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMinIndx:Plongint;pMax:PIpp32u;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_32u(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsMinMaxIndx(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMinIndx:Plongint;pMax:PIpp16s;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_16s(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsMinMaxIndx(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMinIndx:Plongint;pMax:PIpp16u;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_16u(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsMinMaxIndx(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMinIndx:Plongint;pMax:PIpp8u;pMaxIndx:Plongint):IppStatus;
begin
  result:=ippsMinMaxIndx_8u(pSrc,len,pMin,pMinIndx,pMax,pMaxIndx);
end;

function ippsPhase(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsPhase_64fc(pSrc,pDst,len);
end;

function ippsPhase(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPhase_32fc(pSrc,pDst,len);
end;

function ippsPhase(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPhase_16sc32f(pSrc,pDst,len);
end;

function ippsPhase(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsPhase_16sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsPhase(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsPhase_64f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsPhase(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPhase_32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsPhase(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsPhase_16s_Sfs(pSrcRe,pSrcIm,pDst,len,scaleFactor);
end;

function ippsPhase(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPhase_16s32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsPhase(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsPhase_32sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsMaxOrder(pSrc:PIpp64f;len:longint;pOrder:Plongint):IppStatus;
begin
  result:=ippsMaxOrder_64f(pSrc,len,pOrder);
end;

function ippsMaxOrder(pSrc:PIpp32f;len:longint;pOrder:Plongint):IppStatus;
begin
  result:=ippsMaxOrder_32f(pSrc,len,pOrder);
end;

function ippsMaxOrder(pSrc:PIpp32s;len:longint;pOrder:Plongint):IppStatus;
begin
  result:=ippsMaxOrder_32s(pSrc,len,pOrder);
end;

function ippsMaxOrder(pSrc:PIpp16s;len:longint;pOrder:Plongint):IppStatus;
begin
  result:=ippsMaxOrder_16s(pSrc,len,pOrder);
end;

function ippsArctan(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsArctan_32f_I(pSrcDst,len);
end;

function ippsArctan(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsArctan_32f(pSrc,pDst,len);
end;

function ippsArctan(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsArctan_64f_I(pSrcDst,len);
end;

function ippsArctan(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsArctan_64f(pSrc,pDst,len);
end;

function ippsFindNearestOne(inpVal:Ipp16u;pOutVal:PIpp16u;pOutIndex:Plongint;pTable:PIpp16u;tblLen:longint):IppStatus;
begin
  result:=ippsFindNearestOne_16u(inpVal,pOutVal,pOutIndex,pTable,tblLen);
end;

function ippsFindNearest(pVals:PIpp16u;pOutVals:PIpp16u;pOutIndexes:Plongint;len:longint;pTable:PIpp16u;tblLen:longint):IppStatus;
begin
  result:=ippsFindNearest_16u(pVals,pOutVals,pOutIndexes,len,pTable,tblLen);
end;

function ippsAndC(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsAndC_8u_I(val,pSrcDst,len);
end;

function ippsAndC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsAndC_8u(pSrc,val,pDst,len);
end;

function ippsAndC(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAndC_16u_I(val,pSrcDst,len);
end;

function ippsAndC(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAndC_16u(pSrc,val,pDst,len);
end;

function ippsAndC(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsAndC_32u_I(val,pSrcDst,len);
end;

function ippsAndC(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsAndC_32u(pSrc,val,pDst,len);
end;

function ippsAnd(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsAnd_8u_I(pSrc,pSrcDst,len);
end;

function ippsAnd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsAnd_8u(pSrc1,pSrc2,pDst,len);
end;

function ippsAnd(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAnd_16u_I(pSrc,pSrcDst,len);
end;

function ippsAnd(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAnd_16u(pSrc1,pSrc2,pDst,len);
end;

function ippsAnd(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsAnd_32u_I(pSrc,pSrcDst,len);
end;

function ippsAnd(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsAnd_32u(pSrc1,pSrc2,pDst,len);
end;

function ippsOrC(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsOrC_8u_I(val,pSrcDst,len);
end;

function ippsOrC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsOrC_8u(pSrc,val,pDst,len);
end;

function ippsOrC(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsOrC_16u_I(val,pSrcDst,len);
end;

function ippsOrC(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsOrC_16u(pSrc,val,pDst,len);
end;

function ippsOrC(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsOrC_32u_I(val,pSrcDst,len);
end;

function ippsOrC(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsOrC_32u(pSrc,val,pDst,len);
end;

function ippsOr(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsOr_8u_I(pSrc,pSrcDst,len);
end;

function ippsOr(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsOr_8u(pSrc1,pSrc2,pDst,len);
end;

function ippsOr(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsOr_16u_I(pSrc,pSrcDst,len);
end;

function ippsOr(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsOr_16u(pSrc1,pSrc2,pDst,len);
end;

function ippsOr(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsOr_32u_I(pSrc,pSrcDst,len);
end;

function ippsOr(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsOr_32u(pSrc1,pSrc2,pDst,len);
end;

function ippsXorC(val:Ipp8u;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsXorC_8u_I(val,pSrcDst,len);
end;

function ippsXorC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsXorC_8u(pSrc,val,pDst,len);
end;

function ippsXorC(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsXorC_16u_I(val,pSrcDst,len);
end;

function ippsXorC(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsXorC_16u(pSrc,val,pDst,len);
end;

function ippsXorC(val:Ipp32u;pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsXorC_32u_I(val,pSrcDst,len);
end;

function ippsXorC(pSrc:PIpp32u;val:Ipp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsXorC_32u(pSrc,val,pDst,len);
end;

function ippsXor(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsXor_8u_I(pSrc,pSrcDst,len);
end;

function ippsXor(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsXor_8u(pSrc1,pSrc2,pDst,len);
end;

function ippsXor(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsXor_16u_I(pSrc,pSrcDst,len);
end;

function ippsXor(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsXor_16u(pSrc1,pSrc2,pDst,len);
end;

function ippsXor(pSrc:PIpp32u;pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsXor_32u_I(pSrc,pSrcDst,len);
end;

function ippsXor(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsXor_32u(pSrc1,pSrc2,pDst,len);
end;

function ippsNot(pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsNot_8u_I(pSrcDst,len);
end;

function ippsNot(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsNot_8u(pSrc,pDst,len);
end;

function ippsNot(pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsNot_16u_I(pSrcDst,len);
end;

function ippsNot(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsNot_16u(pSrc,pDst,len);
end;

function ippsNot(pSrcDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsNot_32u_I(pSrcDst,len);
end;

function ippsNot(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsNot_32u(pSrc,pDst,len);
end;

function ippsLShiftC(val:longint;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsLShiftC_8u_I(val,pSrcDst,len);
end;

function ippsLShiftC(pSrc:PIpp8u;val:longint;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsLShiftC_8u(pSrc,val,pDst,len);
end;

function ippsLShiftC(val:longint;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsLShiftC_16u_I(val,pSrcDst,len);
end;

function ippsLShiftC(pSrc:PIpp16u;val:longint;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsLShiftC_16u(pSrc,val,pDst,len);
end;

function ippsLShiftC(val:longint;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsLShiftC_16s_I(val,pSrcDst,len);
end;

function ippsLShiftC(pSrc:PIpp16s;val:longint;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsLShiftC_16s(pSrc,val,pDst,len);
end;

function ippsLShiftC(val:longint;pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsLShiftC_32s_I(val,pSrcDst,len);
end;

function ippsLShiftC(pSrc:PIpp32s;val:longint;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsLShiftC_32s(pSrc,val,pDst,len);
end;

function ippsRShiftC(val:longint;pSrcDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsRShiftC_8u_I(val,pSrcDst,len);
end;

function ippsRShiftC(pSrc:PIpp8u;val:longint;pDst:PIpp8u;len:longint):IppStatus;
begin
  result:=ippsRShiftC_8u(pSrc,val,pDst,len);
end;

function ippsRShiftC(val:longint;pSrcDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsRShiftC_16u_I(val,pSrcDst,len);
end;

function ippsRShiftC(pSrc:PIpp16u;val:longint;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsRShiftC_16u(pSrc,val,pDst,len);
end;

function ippsRShiftC(val:longint;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsRShiftC_16s_I(val,pSrcDst,len);
end;

function ippsRShiftC(pSrc:PIpp16s;val:longint;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsRShiftC_16s(pSrc,val,pDst,len);
end;

function ippsRShiftC(val:longint;pSrcDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsRShiftC_32s_I(val,pSrcDst,len);
end;

function ippsRShiftC(pSrc:PIpp32s;val:longint;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsRShiftC_32s(pSrc,val,pDst,len);
end;

function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp32f):IppStatus;
begin
  result:=ippsDotProd_32f(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;
begin
  result:=ippsDotProd_32fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;
begin
  result:=ippsDotProd_32f32fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pDp:PIpp64f):IppStatus;
begin
  result:=ippsDotProd_64f(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;
begin
  result:=ippsDotProd_64fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp64f;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;
begin
  result:=ippsDotProd_64f64fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16s_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16sc_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16s16sc_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp64s):IppStatus;
begin
  result:=ippsDotProd_16s64s(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;
begin
  result:=ippsDotProd_16sc64sc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;
begin
  result:=ippsDotProd_16s16sc64sc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32f):IppStatus;
begin
  result:=ippsDotProd_16s32f(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp32fc):IppStatus;
begin
  result:=ippsDotProd_16sc32fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp32fc):IppStatus;
begin
  result:=ippsDotProd_16s16sc32fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp64f):IppStatus;
begin
  result:=ippsDotProd_32f64f(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;
begin
  result:=ippsDotProd_32fc64fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;
begin
  result:=ippsDotProd_32f32fc64fc(pSrc1,pSrc2,len,pDp);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16s32s_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16sc32sc_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16s16sc32sc_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp32s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_32s_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp32sc;pSrc2:PIpp32sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_32sc_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp32s;pSrc2:PIpp32sc;len:longint;pDp:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_32s32sc_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsDotProd(pSrc1:PIpp16s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsDotProd_16s32s32s_Sfs(pSrc1,pSrc2,len,pDp,scaleFactor);
end;

function ippsPowerSpectr(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsPowerSpectr_64fc(pSrc,pDst,len);
end;

function ippsPowerSpectr(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPowerSpectr_32fc(pSrc,pDst,len);
end;

function ippsPowerSpectr(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsPowerSpectr_16sc_Sfs(pSrc,pDst,len,scaleFactor);
end;

function ippsPowerSpectr(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPowerSpectr_16sc32f(pSrc,pDst,len);
end;

function ippsPowerSpectr(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsPowerSpectr_64f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsPowerSpectr(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPowerSpectr_32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsPowerSpectr(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsPowerSpectr_16s_Sfs(pSrcRe,pSrcIm,pDst,len,scaleFactor);
end;

function ippsPowerSpectr(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsPowerSpectr_16s32f(pSrcRe,pSrcIm,pDst,len);
end;

function ippsNormalize(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;vsub:Ipp64fc;vdiv:Ipp64f):IppStatus;
begin
  result:=ippsNormalize_64fc(pSrc,pDst,len,vsub,vdiv);
end;

function ippsNormalize(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;vsub:Ipp32fc;vdiv:Ipp32f):IppStatus;
begin
  result:=ippsNormalize_32fc(pSrc,pDst,len,vsub,vdiv);
end;

function ippsNormalize(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;vsub:Ipp16sc;vdiv:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsNormalize_16sc_Sfs(pSrc,pDst,len,vsub,vdiv,scaleFactor);
end;

function ippsNormalize(pSrc:PIpp64f;pDst:PIpp64f;len:longint;vsub:Ipp64f;vdiv:Ipp64f):IppStatus;
begin
  result:=ippsNormalize_64f(pSrc,pDst,len,vsub,vdiv);
end;

function ippsNormalize(pSrc:PIpp32f;pDst:PIpp32f;len:longint;vsub:Ipp32f;vdiv:Ipp32f):IppStatus;
begin
  result:=ippsNormalize_32f(pSrc,pDst,len,vsub,vdiv);
end;

function ippsNormalize(pSrc:PIpp16s;pDst:PIpp16s;len:longint;vsub:Ipp16s;vdiv:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsNormalize_16s_Sfs(pSrc,pDst,len,vsub,vdiv,scaleFactor);
end;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_16sc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_C_16sc(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_16s;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_C_16s(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_R(var pFFTSpec:PIppsFFTSpec_R_16s;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_R_16s(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_32fc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_C_32fc(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_32f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_C_32f(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_R(var pFFTSpec:PIppsFFTSpec_R_32f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_R_32f(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_64fc;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_C_64fc(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_C(var pFFTSpec:PIppsFFTSpec_C_64f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_C_64f(pFFTSpec,order,flag,hint);
end;

function ippsFFTInitAlloc_R(var pFFTSpec:PIppsFFTSpec_R_64f;order:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsFFTInitAlloc_R_64f(pFFTSpec,order,flag,hint);
end;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_16sc):IppStatus;
begin
  result:=ippsFFTFree_C_16sc(pFFTSpec);
end;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_16s):IppStatus;
begin
  result:=ippsFFTFree_C_16s(pFFTSpec);
end;

function ippsFFTFree_R(pFFTSpec:PIppsFFTSpec_R_16s):IppStatus;
begin
  result:=ippsFFTFree_R_16s(pFFTSpec);
end;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_32fc):IppStatus;
begin
  result:=ippsFFTFree_C_32fc(pFFTSpec);
end;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_32f):IppStatus;
begin
  result:=ippsFFTFree_C_32f(pFFTSpec);
end;

function ippsFFTFree_R(pFFTSpec:PIppsFFTSpec_R_32f):IppStatus;
begin
  result:=ippsFFTFree_R_32f(pFFTSpec);
end;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_64fc):IppStatus;
begin
  result:=ippsFFTFree_C_64fc(pFFTSpec);
end;

function ippsFFTFree_C(pFFTSpec:PIppsFFTSpec_C_64f):IppStatus;
begin
  result:=ippsFFTFree_C_64f(pFFTSpec);
end;

function ippsFFTFree_R(pFFTSpec:PIppsFFTSpec_R_64f):IppStatus;
begin
  result:=ippsFFTFree_R_64f(pFFTSpec);
end;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_16sc;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_C_16sc(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_16s;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_C_16s(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_R(pFFTSpec:PIppsFFTSpec_R_16s;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_R_16s(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_32fc;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_C_32fc(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_32f;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_C_32f(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_R(pFFTSpec:PIppsFFTSpec_R_32f;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_R_32f(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_64fc;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_C_64fc(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_C(pFFTSpec:PIppsFFTSpec_C_64f;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_C_64f(pFFTSpec,pSize);
end;

function ippsFFTGetBufSize_R(pFFTSpec:PIppsFFTSpec_R_64f;pSize:Plongint):IppStatus;
begin
  result:=ippsFFTGetBufSize_R_64f(pFFTSpec,pSize);
end;

function ippsFFTFwd_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pFFTSpec:PIppsFFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_CToC_16sc_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTInv_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pFFTSpec:PIppsFFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CToC_16sc_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTFwd_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pFFTSpec:PIppsFFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_CToC_16s_Sfs(pSrcRe,pSrcIm,pDstRe,pDstIm,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTInv_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pFFTSpec:PIppsFFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CToC_16s_Sfs(pSrcRe,pSrcIm,pDstRe,pDstIm,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTFwd_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_CToC_32fc(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CToC_32fc(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_CToC_32f(pSrcRe,pSrcIm,pDstRe,pDstIm,pFFTSpec,pBuffer);
end;

function ippsFFTInv_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CToC_32f(pSrcRe,pSrcIm,pDstRe,pDstIm,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_CToC_64fc(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CToC_64fc(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_CToC_64f(pSrcRe,pSrcIm,pDstRe,pDstIm,pFFTSpec,pBuffer);
end;

function ippsFFTInv_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CToC_64f(pSrcRe,pSrcIm,pDstRe,pDstIm,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_RToPerm(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToPerm_16s_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTFwd_RToPack(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToPack_16s_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTFwd_RToCCS(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToCCS_16s_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTInv_PermToR(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_PermToR_16s_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTInv_PackToR(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_PackToR_16s_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTInv_CCSToR(pSrc:PIpp16s;pDst:PIpp16s;pFFTSpec:PIppsFFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CCSToR_16s_Sfs(pSrc,pDst,pFFTSpec,scaleFactor,pBuffer);
end;

function ippsFFTFwd_RToPerm(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToPerm_32f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_RToPack(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToPack_32f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_RToCCS(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToCCS_32f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_PermToR(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_PermToR_32f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_PackToR(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_PackToR_32f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_CCSToR(pSrc:PIpp32f;pDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CCSToR_32f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_RToPerm(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToPerm_64f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_RToPack(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToPack_64f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTFwd_RToCCS(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTFwd_RToCCS_64f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_PermToR(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_PermToR_64f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_PackToR(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_PackToR_64f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsFFTInv_CCSToR(pSrc:PIpp64f;pDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFFTInv_CCSToR_64f(pSrc,pDst,pFFTSpec,pBuffer);
end;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_16sc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_C_16sc(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_16s;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_C_16s(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_R(var pDFTSpec:PIppsDFTSpec_R_16s;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_R_16s(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_32fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_C_32fc(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_32f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_C_32f(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_R(var pDFTSpec:PIppsDFTSpec_R_32f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_R_32f(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_64fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_C_64fc(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_C(var pDFTSpec:PIppsDFTSpec_C_64f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_C_64f(pDFTSpec,length,flag,hint);
end;

function ippsDFTInitAlloc_R(var pDFTSpec:PIppsDFTSpec_R_64f;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTInitAlloc_R_64f(pDFTSpec,length,flag,hint);
end;

function ippsDFTOutOrdInitAlloc_C(var pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTOutOrdInitAlloc_C_32fc(pDFTSpec,length,flag,hint);
end;

function ippsDFTOutOrdInitAlloc_C(var pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;length:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDFTOutOrdInitAlloc_C_64fc(pDFTSpec,length,flag,hint);
end;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_16sc):IppStatus;
begin
  result:=ippsDFTFree_C_16sc(pDFTSpec);
end;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_16s):IppStatus;
begin
  result:=ippsDFTFree_C_16s(pDFTSpec);
end;

function ippsDFTFree_R(pDFTSpec:PIppsDFTSpec_R_16s):IppStatus;
begin
  result:=ippsDFTFree_R_16s(pDFTSpec);
end;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_32fc):IppStatus;
begin
  result:=ippsDFTFree_C_32fc(pDFTSpec);
end;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_32f):IppStatus;
begin
  result:=ippsDFTFree_C_32f(pDFTSpec);
end;

function ippsDFTFree_R(pDFTSpec:PIppsDFTSpec_R_32f):IppStatus;
begin
  result:=ippsDFTFree_R_32f(pDFTSpec);
end;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_64fc):IppStatus;
begin
  result:=ippsDFTFree_C_64fc(pDFTSpec);
end;

function ippsDFTFree_C(pDFTSpec:PIppsDFTSpec_C_64f):IppStatus;
begin
  result:=ippsDFTFree_C_64f(pDFTSpec);
end;

function ippsDFTFree_R(pDFTSpec:PIppsDFTSpec_R_64f):IppStatus;
begin
  result:=ippsDFTFree_R_64f(pDFTSpec);
end;

function ippsDFTOutOrdFree_C(pDFTSpec:PIppsDFTOutOrdSpec_C_32fc):IppStatus;
begin
  result:=ippsDFTOutOrdFree_C_32fc(pDFTSpec);
end;

function ippsDFTOutOrdFree_C(pDFTSpec:PIppsDFTOutOrdSpec_C_64fc):IppStatus;
begin
  result:=ippsDFTOutOrdFree_C_64fc(pDFTSpec);
end;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_16sc;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_C_16sc(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_16s;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_C_16s(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_R(pDFTSpec:PIppsDFTSpec_R_16s;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_R_16s(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_32fc;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_C_32fc(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_32f;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_C_32f(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_R(pDFTSpec:PIppsDFTSpec_R_32f;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_R_32f(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_64fc;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_C_64fc(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_C(pDFTSpec:PIppsDFTSpec_C_64f;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_C_64f(pDFTSpec,pSize);
end;

function ippsDFTGetBufSize_R(pDFTSpec:PIppsDFTSpec_R_64f;pSize:Plongint):IppStatus;
begin
  result:=ippsDFTGetBufSize_R_64f(pDFTSpec,pSize);
end;

function ippsDFTOutOrdGetBufSize_C(pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;size:Plongint):IppStatus;
begin
  result:=ippsDFTOutOrdGetBufSize_C_32fc(pDFTSpec,size);
end;

function ippsDFTOutOrdGetBufSize_C(pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;size:Plongint):IppStatus;
begin
  result:=ippsDFTOutOrdGetBufSize_C_64fc(pDFTSpec,size);
end;

function ippsDFTFwd_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pDFTSpec:PIppsDFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_CToC_16sc_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTInv_CToC(pSrc:PIpp16sc;pDst:PIpp16sc;pDFTSpec:PIppsDFTSpec_C_16sc;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CToC_16sc_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTFwd_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pDFTSpec:PIppsDFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_CToC_16s_Sfs(pSrcRe,pSrcIm,pDstRe,pDstIm,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTInv_CToC(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDstRe:PIpp16s;pDstIm:PIpp16s;pDFTSpec:PIppsDFTSpec_C_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CToC_16s_Sfs(pSrcRe,pSrcIm,pDstRe,pDstIm,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTFwd_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_CToC_32fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CToC_32fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_CToC_32f(pSrcRe,pSrcIm,pDstRe,pDstIm,pDFTSpec,pBuffer);
end;

function ippsDFTInv_CToC(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CToC_32f(pSrcRe,pSrcIm,pDstRe,pDstIm,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_CToC_64fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CToC_64fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_CToC_64f(pSrcRe,pSrcIm,pDstRe,pDstIm,pDFTSpec,pBuffer);
end;

function ippsDFTInv_CToC(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CToC_64f(pSrcRe,pSrcIm,pDstRe,pDstIm,pDFTSpec,pBuffer);
end;

function ippsDFTOutOrdFwd_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTOutOrdFwd_CToC_32fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTOutOrdInv_CToC(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTOutOrdSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTOutOrdInv_CToC_32fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTOutOrdFwd_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTOutOrdFwd_CToC_64fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTOutOrdInv_CToC(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTOutOrdSpec_C_64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTOutOrdInv_CToC_64fc(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_RToPerm(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToPerm_16s_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTFwd_RToPack(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToPack_16s_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTFwd_RToCCS(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToCCS_16s_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTInv_PermToR(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_PermToR_16s_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTInv_PackToR(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_PackToR_16s_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTInv_CCSToR(pSrc:PIpp16s;pDst:PIpp16s;pDFTSpec:PIppsDFTSpec_R_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CCSToR_16s_Sfs(pSrc,pDst,pDFTSpec,scaleFactor,pBuffer);
end;

function ippsDFTFwd_RToPerm(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToPerm_32f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_RToPack(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToPack_32f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_RToCCS(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToCCS_32f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_PermToR(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_PermToR_32f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_PackToR(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_PackToR_32f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_CCSToR(pSrc:PIpp32f;pDst:PIpp32f;pDFTSpec:PIppsDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CCSToR_32f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_RToPerm(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToPerm_64f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_RToPack(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToPack_64f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTFwd_RToCCS(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTFwd_RToCCS_64f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_PermToR(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_PermToR_64f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_PackToR(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_PackToR_64f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsDFTInv_CCSToR(pSrc:PIpp64f;pDst:PIpp64f;pDFTSpec:PIppsDFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDFTInv_CCSToR_64f(pSrc,pDst,pDFTSpec,pBuffer);
end;

function ippsMulPack(pSrc:PIpp16s;pSrcDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulPack_16s_ISfs(pSrc,pSrcDst,length,scaleFactor);
end;

function ippsMulPerm(pSrc:PIpp16s;pSrcDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulPerm_16s_ISfs(pSrc,pSrcDst,length,scaleFactor);
end;

function ippsMulPack(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;
begin
  result:=ippsMulPack_32f_I(pSrc,pSrcDst,length);
end;

function ippsMulPerm(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;
begin
  result:=ippsMulPerm_32f_I(pSrc,pSrcDst,length);
end;

function ippsMulPack(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;
begin
  result:=ippsMulPack_64f_I(pSrc,pSrcDst,length);
end;

function ippsMulPerm(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;
begin
  result:=ippsMulPerm_64f_I(pSrc,pSrcDst,length);
end;

function ippsMulPack(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulPack_16s_Sfs(pSrc1,pSrc2,pDst,length,scaleFactor);
end;

function ippsMulPerm(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;length:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulPerm_16s_Sfs(pSrc1,pSrc2,pDst,length,scaleFactor);
end;

function ippsMulPack(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;length:longint):IppStatus;
begin
  result:=ippsMulPack_32f(pSrc1,pSrc2,pDst,length);
end;

function ippsMulPerm(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;length:longint):IppStatus;
begin
  result:=ippsMulPerm_32f(pSrc1,pSrc2,pDst,length);
end;

function ippsMulPack(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;length:longint):IppStatus;
begin
  result:=ippsMulPack_64f(pSrc1,pSrc2,pDst,length);
end;

function ippsMulPerm(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;length:longint):IppStatus;
begin
  result:=ippsMulPerm_64f(pSrc1,pSrc2,pDst,length);
end;

function ippsMulPackConj(pSrc:PIpp32f;pSrcDst:PIpp32f;length:longint):IppStatus;
begin
  result:=ippsMulPackConj_32f_I(pSrc,pSrcDst,length);
end;

function ippsMulPackConj(pSrc:PIpp64f;pSrcDst:PIpp64f;length:longint):IppStatus;
begin
  result:=ippsMulPackConj_64f_I(pSrc,pSrcDst,length);
end;

function ippsGoertz(pSrc:PIpp32fc;len:longint;pVal:PIpp32fc;freq:Ipp32f):IppStatus;
begin
  result:=ippsGoertz_32fc(pSrc,len,pVal,freq);
end;

function ippsGoertz(pSrc:PIpp64fc;len:longint;pVal:PIpp64fc;freq:Ipp64f):IppStatus;
begin
  result:=ippsGoertz_64fc(pSrc,len,pVal,freq);
end;

function ippsGoertz(pSrc:PIpp16sc;len:longint;pVal:PIpp16sc;freq:Ipp32f;scaleFactor:longint):IppStatus;
begin
  result:=ippsGoertz_16sc_Sfs(pSrc,len,pVal,freq,scaleFactor);
end;

function ippsGoertz(pSrc:PIpp32f;len:longint;pVal:PIpp32fc;freq:Ipp32f):IppStatus;
begin
  result:=ippsGoertz_32f(pSrc,len,pVal,freq);
end;

function ippsGoertz(pSrc:PIpp16s;len:longint;pVal:PIpp16sc;freq:Ipp32f;scaleFactor:longint):IppStatus;
begin
  result:=ippsGoertz_16s_Sfs(pSrc,len,pVal,freq,scaleFactor);
end;

function ippsGoertzTwo(pSrc:PIpp32fc;len:longint;var pVal:Ipp32fc;var freq:Ipp32f):IppStatus;
begin
  result:=ippsGoertzTwo_32fc(pSrc,len,pVal,freq);
end;

function ippsGoertzTwo(pSrc:PIpp64fc;len:longint;var pVal:Ipp64fc;var freq:Ipp64f):IppStatus;
begin
  result:=ippsGoertzTwo_64fc(pSrc,len,pVal,freq);
end;

function ippsGoertzTwo(pSrc:PIpp16sc;len:longint;var pVal:Ipp16sc;var freq:Ipp32f;scaleFactor:longint):IppStatus;
begin
  result:=ippsGoertzTwo_16sc_Sfs(pSrc,len,pVal,freq,scaleFactor);
end;

function ippsDCTFwdInitAlloc(var pDCTSpec:PIppsDCTFwdSpec_16s;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDCTFwdInitAlloc_16s(pDCTSpec,length,hint);
end;

function ippsDCTInvInitAlloc(var pDCTSpec:PIppsDCTInvSpec_16s;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDCTInvInitAlloc_16s(pDCTSpec,length,hint);
end;

function ippsDCTFwdInitAlloc(var pDCTSpec:PIppsDCTFwdSpec_32f;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDCTFwdInitAlloc_32f(pDCTSpec,length,hint);
end;

function ippsDCTInvInitAlloc(var pDCTSpec:PIppsDCTInvSpec_32f;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDCTInvInitAlloc_32f(pDCTSpec,length,hint);
end;

function ippsDCTFwdInitAlloc(var pDCTSpec:PIppsDCTFwdSpec_64f;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDCTFwdInitAlloc_64f(pDCTSpec,length,hint);
end;

function ippsDCTInvInitAlloc(var pDCTSpec:PIppsDCTInvSpec_64f;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsDCTInvInitAlloc_64f(pDCTSpec,length,hint);
end;

function ippsDCTFwdFree(pDCTSpec:PIppsDCTFwdSpec_16s):IppStatus;
begin
  result:=ippsDCTFwdFree_16s(pDCTSpec);
end;

function ippsDCTInvFree(pDCTSpec:PIppsDCTInvSpec_16s):IppStatus;
begin
  result:=ippsDCTInvFree_16s(pDCTSpec);
end;

function ippsDCTFwdFree(pDCTSpec:PIppsDCTFwdSpec_32f):IppStatus;
begin
  result:=ippsDCTFwdFree_32f(pDCTSpec);
end;

function ippsDCTInvFree(pDCTSpec:PIppsDCTInvSpec_32f):IppStatus;
begin
  result:=ippsDCTInvFree_32f(pDCTSpec);
end;

function ippsDCTFwdFree(pDCTSpec:PIppsDCTFwdSpec_64f):IppStatus;
begin
  result:=ippsDCTFwdFree_64f(pDCTSpec);
end;

function ippsDCTInvFree(pDCTSpec:PIppsDCTInvSpec_64f):IppStatus;
begin
  result:=ippsDCTInvFree_64f(pDCTSpec);
end;

function ippsDCTFwdGetBufSize(pDCTSpec:PIppsDCTFwdSpec_16s;pSize:Plongint):IppStatus;
begin
  result:=ippsDCTFwdGetBufSize_16s(pDCTSpec,pSize);
end;

function ippsDCTInvGetBufSize(pDCTSpec:PIppsDCTInvSpec_16s;pSize:Plongint):IppStatus;
begin
  result:=ippsDCTInvGetBufSize_16s(pDCTSpec,pSize);
end;

function ippsDCTFwdGetBufSize(pDCTSpec:PIppsDCTFwdSpec_32f;pSize:Plongint):IppStatus;
begin
  result:=ippsDCTFwdGetBufSize_32f(pDCTSpec,pSize);
end;

function ippsDCTInvGetBufSize(pDCTSpec:PIppsDCTInvSpec_32f;pSize:Plongint):IppStatus;
begin
  result:=ippsDCTInvGetBufSize_32f(pDCTSpec,pSize);
end;

function ippsDCTFwdGetBufSize(pDCTSpec:PIppsDCTFwdSpec_64f;pSize:Plongint):IppStatus;
begin
  result:=ippsDCTFwdGetBufSize_64f(pDCTSpec,pSize);
end;

function ippsDCTInvGetBufSize(pDCTSpec:PIppsDCTInvSpec_64f;pSize:Plongint):IppStatus;
begin
  result:=ippsDCTInvGetBufSize_64f(pDCTSpec,pSize);
end;

function ippsDCTFwd(pSrc:PIpp16s;pDst:PIpp16s;pDCTSpec:PIppsDCTFwdSpec_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDCTFwd_16s_Sfs(pSrc,pDst,pDCTSpec,scaleFactor,pBuffer);
end;

function ippsDCTInv(pSrc:PIpp16s;pDst:PIpp16s;pDCTSpec:PIppsDCTInvSpec_16s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDCTInv_16s_Sfs(pSrc,pDst,pDCTSpec,scaleFactor,pBuffer);
end;

function ippsDCTFwd(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDCTFwd_32f(pSrc,pDst,pDCTSpec,pBuffer);
end;

function ippsDCTInv(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDCTInv_32f(pSrc,pDst,pDCTSpec,pBuffer);
end;

function ippsDCTFwd(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTFwdSpec_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDCTFwd_64f(pSrc,pDst,pDCTSpec,pBuffer);
end;

function ippsDCTInv(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTInvSpec_64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsDCTInv_64f(pSrc,pDst,pDCTSpec,pBuffer);
end;

function ippsWTHaarFwd(pSrc:PIpp8s;len:longint;pDstLow:PIpp8s;pDstHigh:PIpp8s):IppStatus;
begin
  result:=ippsWTHaarFwd_8s(pSrc,len,pDstLow,pDstHigh);
end;

function ippsWTHaarFwd(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s):IppStatus;
begin
  result:=ippsWTHaarFwd_16s(pSrc,len,pDstLow,pDstHigh);
end;

function ippsWTHaarFwd(pSrc:PIpp32s;len:longint;pDstLow:PIpp32s;pDstHigh:PIpp32s):IppStatus;
begin
  result:=ippsWTHaarFwd_32s(pSrc,len,pDstLow,pDstHigh);
end;

function ippsWTHaarFwd(pSrc:PIpp64s;len:longint;pDstLow:PIpp64s;pDstHigh:PIpp64s):IppStatus;
begin
  result:=ippsWTHaarFwd_64s(pSrc,len,pDstLow,pDstHigh);
end;

function ippsWTHaarFwd(pSrc:PIpp32f;len:longint;pDstLow:PIpp32f;pDstHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTHaarFwd_32f(pSrc,len,pDstLow,pDstHigh);
end;

function ippsWTHaarFwd(pSrc:PIpp64f;len:longint;pDstLow:PIpp64f;pDstHigh:PIpp64f):IppStatus;
begin
  result:=ippsWTHaarFwd_64f(pSrc,len,pDstLow,pDstHigh);
end;

function ippsWTHaarFwd(pSrc:PIpp8s;len:longint;pDstLow:PIpp8s;pDstHigh:PIpp8s;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarFwd_8s_Sfs(pSrc,len,pDstLow,pDstHigh,scaleFactor);
end;

function ippsWTHaarFwd(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarFwd_16s_Sfs(pSrc,len,pDstLow,pDstHigh,scaleFactor);
end;

function ippsWTHaarFwd(pSrc:PIpp32s;len:longint;pDstLow:PIpp32s;pDstHigh:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarFwd_32s_Sfs(pSrc,len,pDstLow,pDstHigh,scaleFactor);
end;

function ippsWTHaarFwd(pSrc:PIpp64s;len:longint;pDstLow:PIpp64s;pDstHigh:PIpp64s;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarFwd_64s_Sfs(pSrc,len,pDstLow,pDstHigh,scaleFactor);
end;

function ippsWTHaarInv(pSrcLow:PIpp8s;pSrcHigh:PIpp8s;pDst:PIpp8s;len:longint):IppStatus;
begin
  result:=ippsWTHaarInv_8s(pSrcLow,pSrcHigh,pDst,len);
end;

function ippsWTHaarInv(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWTHaarInv_16s(pSrcLow,pSrcHigh,pDst,len);
end;

function ippsWTHaarInv(pSrcLow:PIpp32s;pSrcHigh:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;
begin
  result:=ippsWTHaarInv_32s(pSrcLow,pSrcHigh,pDst,len);
end;

function ippsWTHaarInv(pSrcLow:PIpp64s;pSrcHigh:PIpp64s;pDst:PIpp64s;len:longint):IppStatus;
begin
  result:=ippsWTHaarInv_64s(pSrcLow,pSrcHigh,pDst,len);
end;

function ippsWTHaarInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWTHaarInv_32f(pSrcLow,pSrcHigh,pDst,len);
end;

function ippsWTHaarInv(pSrcLow:PIpp64f;pSrcHigh:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWTHaarInv_64f(pSrcLow,pSrcHigh,pDst,len);
end;

function ippsWTHaarInv(pSrcLow:PIpp8s;pSrcHigh:PIpp8s;pDst:PIpp8s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarInv_8s_Sfs(pSrcLow,pSrcHigh,pDst,len,scaleFactor);
end;

function ippsWTHaarInv(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarInv_16s_Sfs(pSrcLow,pSrcHigh,pDst,len,scaleFactor);
end;

function ippsWTHaarInv(pSrcLow:PIpp32s;pSrcHigh:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarInv_32s_Sfs(pSrcLow,pSrcHigh,pDst,len,scaleFactor);
end;

function ippsWTHaarInv(pSrcLow:PIpp64s;pSrcHigh:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsWTHaarInv_64s_Sfs(pSrcLow,pSrcHigh,pDst,len,scaleFactor);
end;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTFwdInitAlloc_32f(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_8s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTFwdInitAlloc_8s32f(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_8u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTFwdInitAlloc_8u32f(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_16s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTFwdInitAlloc_16s32f(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTFwdInitAlloc(var pState:PIppsWTFwdState_16u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTFwdInitAlloc_16u32f(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdSetDlyLine_32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_8s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdSetDlyLine_8s32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdSetDlyLine_8u32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdSetDlyLine_16s32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdSetDlyLine(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdSetDlyLine_16u32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdGetDlyLine_32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_8s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdGetDlyLine_8s32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdGetDlyLine_8u32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdGetDlyLine_16s32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwdGetDlyLine(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTFwdGetDlyLine_16u32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTFwd(pSrc:PIpp32f;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_32f):IppStatus;
begin
  result:=ippsWTFwd_32f(pSrc,pDstLow,pDstHigh,dstLen,pState);
end;

function ippsWTFwd(pSrc:PIpp8s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8s32f):IppStatus;
begin
  result:=ippsWTFwd_8s32f(pSrc,pDstLow,pDstHigh,dstLen,pState);
end;

function ippsWTFwd(pSrc:PIpp8u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8u32f):IppStatus;
begin
  result:=ippsWTFwd_8u32f(pSrc,pDstLow,pDstHigh,dstLen,pState);
end;

function ippsWTFwd(pSrc:PIpp16s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16s32f):IppStatus;
begin
  result:=ippsWTFwd_16s32f(pSrc,pDstLow,pDstHigh,dstLen,pState);
end;

function ippsWTFwd(pSrc:PIpp16u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16u32f):IppStatus;
begin
  result:=ippsWTFwd_16u32f(pSrc,pDstLow,pDstHigh,dstLen,pState);
end;

function ippsWTFwdFree(pState:PIppsWTFwdState_32f):IppStatus;
begin
  result:=ippsWTFwdFree_32f(pState);
end;

function ippsWTFwdFree(pState:PIppsWTFwdState_8s32f):IppStatus;
begin
  result:=ippsWTFwdFree_8s32f(pState);
end;

function ippsWTFwdFree(pState:PIppsWTFwdState_8u32f):IppStatus;
begin
  result:=ippsWTFwdFree_8u32f(pState);
end;

function ippsWTFwdFree(pState:PIppsWTFwdState_16s32f):IppStatus;
begin
  result:=ippsWTFwdFree_16s32f(pState);
end;

function ippsWTFwdFree(pState:PIppsWTFwdState_16u32f):IppStatus;
begin
  result:=ippsWTFwdFree_16u32f(pState);
end;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTInvInitAlloc_32f(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f8s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTInvInitAlloc_32f8s(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f8u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTInvInitAlloc_32f8u(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f16s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTInvInitAlloc_32f16s(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTInvInitAlloc(var pState:PIppsWTInvState_32f16u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;
begin
  result:=ippsWTInvInitAlloc_32f16u(pState,pTapsLow,lenLow,offsLow,pTapsHigh,lenHigh,offsHigh);
end;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvSetDlyLine_32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f8s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvSetDlyLine_32f8s(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvSetDlyLine_32f8u(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvSetDlyLine_32f16s(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvSetDlyLine(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvSetDlyLine_32f16u(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvGetDlyLine_32f(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f8s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvGetDlyLine_32f8s(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvGetDlyLine_32f8u(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvGetDlyLine_32f16s(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInvGetDlyLine(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;
begin
  result:=ippsWTInvGetDlyLine_32f16u(pState,pDlyLow,pDlyHigh);
end;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp32f;pState:PIppsWTInvState_32f):IppStatus;
begin
  result:=ippsWTInv_32f(pSrcLow,pSrcHigh,srcLen,pDst,pState);
end;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8s;pState:PIppsWTInvState_32f8s):IppStatus;
begin
  result:=ippsWTInv_32f8s(pSrcLow,pSrcHigh,srcLen,pDst,pState);
end;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8u;pState:PIppsWTInvState_32f8u):IppStatus;
begin
  result:=ippsWTInv_32f8u(pSrcLow,pSrcHigh,srcLen,pDst,pState);
end;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16s;pState:PIppsWTInvState_32f16s):IppStatus;
begin
  result:=ippsWTInv_32f16s(pSrcLow,pSrcHigh,srcLen,pDst,pState);
end;

function ippsWTInv(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16u;pState:PIppsWTInvState_32f16u):IppStatus;
begin
  result:=ippsWTInv_32f16u(pSrcLow,pSrcHigh,srcLen,pDst,pState);
end;

function ippsWTInvFree(pState:PIppsWTInvState_32f):IppStatus;
begin
  result:=ippsWTInvFree_32f(pState);
end;

function ippsWTInvFree(pState:PIppsWTInvState_32f8s):IppStatus;
begin
  result:=ippsWTInvFree_32f8s(pState);
end;

function ippsWTInvFree(pState:PIppsWTInvState_32f8u):IppStatus;
begin
  result:=ippsWTInvFree_32f8u(pState);
end;

function ippsWTInvFree(pState:PIppsWTInvState_32f16s):IppStatus;
begin
  result:=ippsWTInvFree_32f16s(pState);
end;

function ippsWTInvFree(pState:PIppsWTInvState_32f16u):IppStatus;
begin
  result:=ippsWTInvFree_32f16u(pState);
end;

function ippsConv(pSrc1:PIpp32f;lenSrc1:longint;pSrc2:PIpp32f;lenSrc2:longint;pDst:PIpp32f):IppStatus;
begin
  result:=ippsConv_32f(pSrc1,lenSrc1,pSrc2,lenSrc2,pDst);
end;

function ippsConv(pSrc1:PIpp16s;lenSrc1:longint;pSrc2:PIpp16s;lenSrc2:longint;pDst:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsConv_16s_Sfs(pSrc1,lenSrc1,pSrc2,lenSrc2,pDst,scaleFactor);
end;

function ippsConv(pSrc1:PIpp64f;lenSrc1:longint;pSrc2:PIpp64f;lenSrc2:longint;pDst:PIpp64f):IppStatus;
begin
  result:=ippsConv_64f(pSrc1,lenSrc1,pSrc2,lenSrc2,pDst);
end;

function ippsConvCyclic8x8(x:PIpp32f;h:PIpp32f;y:PIpp32f):IppStatus;
begin
  result:=ippsConvCyclic8x8_32f(x,h,y);
end;

function ippsConvCyclic8x8(x:PIpp16s;h:PIpp16s;y:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsConvCyclic8x8_16s_Sfs(x,h,y,scaleFactor);
end;

function ippsConvCyclic4x4(x:PIpp32f;h:PIpp32fc;y:PIpp32fc):IppStatus;
begin
  result:=ippsConvCyclic4x4_32f32fc(x,h,y);
end;

function ippsIIRInitAlloc(var pState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRInitAlloc_32f(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRInitAlloc_32fc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc32f(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRInitAlloc32f_16s(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc32fc(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRInitAlloc32fc_16sc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc(var pState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc_64f(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc_64fc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc64f(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc64f_32f(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc64fc(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc64fc_32fc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc64f(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc64f_32s(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc64fc(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc64fc_32sc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc64f(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc64f_16s(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc64fc(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc64fc_16sc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRFree(pState:PIppsIIRState_32f):IppStatus;
begin
  result:=ippsIIRFree_32f(pState);
end;

function ippsIIRFree(pState:PIppsIIRState_32fc):IppStatus;
begin
  result:=ippsIIRFree_32fc(pState);
end;

function ippsIIRFree32f(pState:PIppsIIRState32f_16s):IppStatus;
begin
  result:=ippsIIRFree32f_16s(pState);
end;

function ippsIIRFree32fc(pState:PIppsIIRState32fc_16sc):IppStatus;
begin
  result:=ippsIIRFree32fc_16sc(pState);
end;

function ippsIIRFree(pState:PIppsIIRState_64f):IppStatus;
begin
  result:=ippsIIRFree_64f(pState);
end;

function ippsIIRFree(pState:PIppsIIRState_64fc):IppStatus;
begin
  result:=ippsIIRFree_64fc(pState);
end;

function ippsIIRFree64f(pState:PIppsIIRState64f_32f):IppStatus;
begin
  result:=ippsIIRFree64f_32f(pState);
end;

function ippsIIRFree64fc(pState:PIppsIIRState64fc_32fc):IppStatus;
begin
  result:=ippsIIRFree64fc_32fc(pState);
end;

function ippsIIRFree64f(pState:PIppsIIRState64f_32s):IppStatus;
begin
  result:=ippsIIRFree64f_32s(pState);
end;

function ippsIIRFree64fc(pState:PIppsIIRState64fc_32sc):IppStatus;
begin
  result:=ippsIIRFree64fc_32sc(pState);
end;

function ippsIIRFree64f(pState:PIppsIIRState64f_16s):IppStatus;
begin
  result:=ippsIIRFree64f_16s(pState);
end;

function ippsIIRFree64fc(pState:PIppsIIRState64fc_16sc):IppStatus;
begin
  result:=ippsIIRFree64fc_16sc(pState);
end;

function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRInitAlloc_BiQuad_32f(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRInitAlloc_BiQuad_32fc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc32f_BiQuad(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRInitAlloc32f_BiQuad_16s(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc32fc_BiQuad(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRInitAlloc32fc_BiQuad_16sc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc_BiQuad_64f(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc_BiQuad(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc_BiQuad_64fc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc64f_BiQuad(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc64f_BiQuad_32f(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc64fc_BiQuad(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc64fc_BiQuad_32fc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc64f_BiQuad(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc64f_BiQuad_32s(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc64fc_BiQuad(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc64fc_BiQuad_32sc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc64f_BiQuad(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRInitAlloc64f_BiQuad_16s(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc64fc_BiQuad(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRInitAlloc64fc_BiQuad_16sc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRGetDlyLine(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRGetDlyLine_32f(pState,pDlyLine);
end;

function ippsIIRSetDlyLine(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRSetDlyLine_32f(pState,pDlyLine);
end;

function ippsIIRGetDlyLine(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRGetDlyLine_32fc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRSetDlyLine_32fc(pState,pDlyLine);
end;

function ippsIIRGetDlyLine32f(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRGetDlyLine32f_16s(pState,pDlyLine);
end;

function ippsIIRSetDlyLine32f(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsIIRSetDlyLine32f_16s(pState,pDlyLine);
end;

function ippsIIRGetDlyLine32fc(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRGetDlyLine32fc_16sc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine32fc(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsIIRSetDlyLine32fc_16sc(pState,pDlyLine);
end;

function ippsIIRGetDlyLine(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRGetDlyLine_64f(pState,pDlyLine);
end;

function ippsIIRSetDlyLine(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRSetDlyLine_64f(pState,pDlyLine);
end;

function ippsIIRGetDlyLine(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRGetDlyLine_64fc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRSetDlyLine_64fc(pState,pDlyLine);
end;

function ippsIIRGetDlyLine64f(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRGetDlyLine64f_32f(pState,pDlyLine);
end;

function ippsIIRSetDlyLine64f(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRSetDlyLine64f_32f(pState,pDlyLine);
end;

function ippsIIRGetDlyLine64fc(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRGetDlyLine64fc_32fc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine64fc(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRSetDlyLine64fc_32fc(pState,pDlyLine);
end;

function ippsIIRGetDlyLine64f(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRGetDlyLine64f_32s(pState,pDlyLine);
end;

function ippsIIRSetDlyLine64f(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRSetDlyLine64f_32s(pState,pDlyLine);
end;

function ippsIIRGetDlyLine64fc(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRGetDlyLine64fc_32sc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine64fc(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRSetDlyLine64fc_32sc(pState,pDlyLine);
end;

function ippsIIRGetDlyLine64f(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRGetDlyLine64f_16s(pState,pDlyLine);
end;

function ippsIIRSetDlyLine64f(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsIIRSetDlyLine64f_16s(pState,pDlyLine);
end;

function ippsIIRGetDlyLine64fc(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRGetDlyLine64fc_16sc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine64fc(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsIIRSetDlyLine64fc_16sc(pState,pDlyLine);
end;

function ippsIIROne(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsIIRState_32f):IppStatus;
begin
  result:=ippsIIROne_32f(src,pDstVal,pState);
end;

function ippsIIROne(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsIIRState_32fc):IppStatus;
begin
  result:=ippsIIROne_32fc(src,pDstVal,pState);
end;

function ippsIIROne32f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne32f_16s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIROne32fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne32fc_16sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIROne(src:Ipp64f;pDstVal:PIpp64f;pState:PIppsIIRState_64f):IppStatus;
begin
  result:=ippsIIROne_64f(src,pDstVal,pState);
end;

function ippsIIROne(src:Ipp64fc;pDstVal:PIpp64fc;pState:PIppsIIRState_64fc):IppStatus;
begin
  result:=ippsIIROne_64fc(src,pDstVal,pState);
end;

function ippsIIROne64f(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsIIRState64f_32f):IppStatus;
begin
  result:=ippsIIROne64f_32f(src,pDstVal,pState);
end;

function ippsIIROne64fc(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsIIRState64fc_32fc):IppStatus;
begin
  result:=ippsIIROne64fc_32fc(src,pDstVal,pState);
end;

function ippsIIROne64f(src:Ipp32s;pDstVal:PIpp32s;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne64f_32s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIROne64fc(src:Ipp32sc;pDstVal:PIpp32sc;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne64fc_32sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIROne64f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne64f_16s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIROne64fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne64fc_16sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIR(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;
begin
  result:=ippsIIR_32f(pSrc,pDst,len,pState);
end;

function ippsIIR(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;
begin
  result:=ippsIIR_32f_I(pSrcDst,len,pState);
end;

function ippsIIR(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;
begin
  result:=ippsIIR_32fc(pSrc,pDst,len,pState);
end;

function ippsIIR(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;
begin
  result:=ippsIIR_32fc_I(pSrcDst,len,pState);
end;

function ippsIIR32f(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32f_16s_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR32f(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32f_16s_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR32fc(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32fc_16sc_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR32fc(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32fc_16sc_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR(pSrc:PIpp64f;pDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;
begin
  result:=ippsIIR_64f(pSrc,pDst,len,pState);
end;

function ippsIIR(pSrcDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;
begin
  result:=ippsIIR_64f_I(pSrcDst,len,pState);
end;

function ippsIIR(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;
begin
  result:=ippsIIR_64fc(pSrc,pDst,len,pState);
end;

function ippsIIR(pSrcDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;
begin
  result:=ippsIIR_64fc_I(pSrcDst,len,pState);
end;

function ippsIIR64f(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;
begin
  result:=ippsIIR64f_32f(pSrc,pDst,len,pState);
end;

function ippsIIR64f(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;
begin
  result:=ippsIIR64f_32f_I(pSrcDst,len,pState);
end;

function ippsIIR64fc(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;
begin
  result:=ippsIIR64fc_32fc(pSrc,pDst,len,pState);
end;

function ippsIIR64fc(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;
begin
  result:=ippsIIR64fc_32fc_I(pSrcDst,len,pState);
end;

function ippsIIR64f(pSrc:PIpp32s;pDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64f_32s_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR64f(pSrcDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64f_32s_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR64fc(pSrc:PIpp32sc;pDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64fc_32sc_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR64fc(pSrcDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64fc_32sc_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR64f(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64f_16s_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR64f(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64f_16s_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR64fc(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64fc_16sc_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR64fc(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR64fc_16sc_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIRInitAlloc32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;order:longint;tapsFactor:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIRInitAlloc32s_16s(pState,pTaps,order,tapsFactor,pDlyLine);
end;

function ippsIIRInitAlloc32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIRInitAlloc32s_16s32f(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;order:longint;tapsFactor:longint;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsIIRInitAlloc32sc_16sc(pState,pTaps,order,tapsFactor,pDlyLine);
end;

function ippsIIRInitAlloc32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsIIRInitAlloc32sc_16sc32fc(pState,pTaps,order,pDlyLine);
end;

function ippsIIRInitAlloc32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIRInitAlloc32s_BiQuad_16s(pState,pTaps,numBq,tapsFactor,pDlyLine);
end;

function ippsIIRInitAlloc32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIRInitAlloc32s_BiQuad_16s32f(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRInitAlloc32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsIIRInitAlloc32sc_BiQuad_16sc(pState,pTaps,numBq,tapsFactor,pDlyLine);
end;

function ippsIIRInitAlloc32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsIIRInitAlloc32sc_BiQuad_16sc32fc(pState,pTaps,numBq,pDlyLine);
end;

function ippsIIRFree32s(pState:PIppsIIRState32s_16s):IppStatus;
begin
  result:=ippsIIRFree32s_16s(pState);
end;

function ippsIIRFree32sc(pState:PIppsIIRState32sc_16sc):IppStatus;
begin
  result:=ippsIIRFree32sc_16sc(pState);
end;

function ippsIIRGetDlyLine32s(pState:PIppsIIRState32s_16s;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIRGetDlyLine32s_16s(pState,pDlyLine);
end;

function ippsIIRSetDlyLine32s(pState:PIppsIIRState32s_16s;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIRSetDlyLine32s_16s(pState,pDlyLine);
end;

function ippsIIRGetDlyLine32sc(pState:PIppsIIRState32sc_16sc;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsIIRGetDlyLine32sc_16sc(pState,pDlyLine);
end;

function ippsIIRSetDlyLine32sc(pState:PIppsIIRState32sc_16sc;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsIIRSetDlyLine32sc_16sc(pState,pDlyLine);
end;

function ippsIIROne32s(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne32s_16s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIROne32sc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIROne32sc_16sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsIIR32s(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32s_16s_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR32sc(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32sc_16sc_Sfs(pSrc,pDst,len,pState,scaleFactor);
end;

function ippsIIR32s(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32s_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32s_16s_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR32sc(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32sc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsIIR32sc_16sc_ISfs(pSrcDst,len,pState,scaleFactor);
end;

function ippsIIR_Direct(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIR_Direct_16s(pSrc,pDst,len,pTaps,order,pDlyLine);
end;

function ippsIIR_Direct(pSrcDst:PIpp16s;len:longint;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIR_Direct_16s_I(pSrcDst,len,pTaps,order,pDlyLine);
end;

function ippsIIROne_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIROne_Direct_16s(src,pDstVal,pTaps,order,pDlyLine);
end;

function ippsIIROne_Direct(pSrcDst:PIpp16s;pTaps:PIpp16s;order:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIROne_Direct_16s_I(pSrcDst,pTaps,order,pDlyLine);
end;

function ippsIIR_BiQuadDirect(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIR_BiQuadDirect_16s(pSrc,pDst,len,pTaps,numBq,pDlyLine);
end;

function ippsIIR_BiQuadDirect(pSrcDst:PIpp16s;len:longint;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIR_BiQuadDirect_16s_I(pSrcDst,len,pTaps,numBq,pDlyLine);
end;

function ippsIIROne_BiQuadDirect(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIROne_BiQuadDirect_16s(src,pDstVal,pTaps,numBq,pDlyLine);
end;

function ippsIIROne_BiQuadDirect(pSrcDstVal:PIpp16s;pTaps:PIpp16s;numBq:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsIIROne_BiQuadDirect_16s_I(pSrcDstVal,pTaps,numBq,pDlyLine);
end;

function ippsIIRGetStateSize32s(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32s_16s(order,pBufferSize);
end;

function ippsIIRGetStateSize32sc(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32sc_16sc(order,pBufferSize);
end;

function ippsIIRGetStateSize32s_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32s_BiQuad_16s(numBq,pBufferSize);
end;

function ippsIIRGetStateSize32sc_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32sc_BiQuad_16sc(numBq,pBufferSize);
end;

function ippsIIRInit32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;order:longint;tapsFactor:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32s_16s(pState,pTaps,order,tapsFactor,pDlyLine,pBuf);
end;

function ippsIIRInit32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;order:longint;tapsFactor:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32sc_16sc(pState,pTaps,order,tapsFactor,pDlyLine,pBuf);
end;

function ippsIIRInit32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32s;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32s_BiQuad_16s(pState,pTaps,numBq,tapsFactor,pDlyLine,pBuf);
end;

function ippsIIRInit32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32sc;numBq:longint;tapsFactor:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32sc_BiQuad_16sc(pState,pTaps,numBq,tapsFactor,pDlyLine,pBuf);
end;

function ippsIIRInit32s(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32s_16s32f(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit32sc(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32sc_16sc32fc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit32s_BiQuad(var pState:PIppsIIRState32s_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32s_BiQuad_16s32f(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit32sc_BiQuad(var pState:PIppsIIRState32sc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32sc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32sc_BiQuad_16sc32fc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRGetStateSize(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize_32f(order,pBufferSize);
end;

function ippsIIRGetStateSize_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize_BiQuad_32f(numBq,pBufferSize);
end;

function ippsIIRInit(var pState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_32f(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_32fc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit_BiQuad(var pState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_BiQuad_32f(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit_BiQuad(var pState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_BiQuad_32fc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRGetStateSize32f(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32f_16s(order,pBufferSize);
end;

function ippsIIRGetStateSize32fc(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32fc_16sc(order,pBufferSize);
end;

function ippsIIRGetStateSize32f_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32f_BiQuad_16s(numBq,pBufferSize);
end;

function ippsIIRGetStateSize32fc_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize32fc_BiQuad_16sc(numBq,pBufferSize);
end;

function ippsIIRInit32f(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32f_16s(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit32fc(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32fc_16sc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit32f_BiQuad(var pState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32f_BiQuad_16s(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit32fc_BiQuad(var pState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit32fc_BiQuad_16sc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit(var pState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_64f(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_64fc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit_BiQuad(var pState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_BiQuad_64f(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit_BiQuad(var pState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit_BiQuad_64fc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRGetStateSize64f(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize64f_16s(order,pBufferSize);
end;

function ippsIIRGetStateSize64fc(order:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize64fc_16sc(order,pBufferSize);
end;

function ippsIIRGetStateSize64f_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize64f_BiQuad_16s(numBq,pBufferSize);
end;

function ippsIIRGetStateSize64fc_BiQuad(numBq:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsIIRGetStateSize64fc_BiQuad_16sc(numBq,pBufferSize);
end;

function ippsIIRInit64f(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64f_16s(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit64fc(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64fc_16sc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit64f_BiQuad(var pState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64f_BiQuad_16s(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit64fc_BiQuad(var pState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64fc_BiQuad_16sc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit64f(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64f_32s(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit64fc(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64fc_32sc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit64f_BiQuad(var pState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64f_BiQuad_32s(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit64fc_BiQuad(var pState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64fc_BiQuad_32sc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit64f(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64f_32f(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit64fc(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64fc_32fc(pState,pTaps,order,pDlyLine,pBuf);
end;

function ippsIIRInit64f_BiQuad(var pState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64f_BiQuad_32f(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRInit64fc_BiQuad(var pState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;
begin
  result:=ippsIIRInit64fc_BiQuad_32fc(pState,pTaps,numBq,pDlyLine,pBuf);
end;

function ippsIIRSetTaps(pTaps:PIpp32f;pState:PIppsIIRState_32f):IppStatus;
begin
  result:=ippsIIRSetTaps_32f(pTaps,pState);
end;

function ippsIIRSetTaps(pTaps:PIpp32fc;pState:PIppsIIRState_32fc):IppStatus;
begin
  result:=ippsIIRSetTaps_32fc(pTaps,pState);
end;

function ippsIIRSetTaps32f(pTaps:PIpp32f;pState:PIppsIIRState32f_16s):IppStatus;
begin
  result:=ippsIIRSetTaps32f_16s(pTaps,pState);
end;

function ippsIIRSetTaps32fc(pTaps:PIpp32fc;pState:PIppsIIRState32fc_16sc):IppStatus;
begin
  result:=ippsIIRSetTaps32fc_16sc(pTaps,pState);
end;

function ippsIIRSetTaps32s(pTaps:PIpp32s;pState:PIppsIIRState32s_16s;tapsFactor:longint):IppStatus;
begin
  result:=ippsIIRSetTaps32s_16s(pTaps,pState,tapsFactor);
end;

function ippsIIRSetTaps32sc(pTaps:PIpp32sc;pState:PIppsIIRState32sc_16sc;tapsFactor:longint):IppStatus;
begin
  result:=ippsIIRSetTaps32sc_16sc(pTaps,pState,tapsFactor);
end;

function ippsIIRSetTaps32s(pTaps:PIpp32f;pState:PIppsIIRState32s_16s):IppStatus;
begin
  result:=ippsIIRSetTaps32s_16s32f(pTaps,pState);
end;

function ippsIIRSetTaps32sc(pTaps:PIpp32fc;pState:PIppsIIRState32sc_16sc):IppStatus;
begin
  result:=ippsIIRSetTaps32sc_16sc32fc(pTaps,pState);
end;

function ippsIIRSetTaps(pTaps:PIpp64f;pState:PIppsIIRState_64f):IppStatus;
begin
  result:=ippsIIRSetTaps_64f(pTaps,pState);
end;

function ippsIIRSetTaps(pTaps:PIpp64fc;pState:PIppsIIRState_64fc):IppStatus;
begin
  result:=ippsIIRSetTaps_64fc(pTaps,pState);
end;

function ippsIIRSetTaps64f(pTaps:PIpp64f;pState:PIppsIIRState64f_32f):IppStatus;
begin
  result:=ippsIIRSetTaps64f_32f(pTaps,pState);
end;

function ippsIIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsIIRState64fc_32fc):IppStatus;
begin
  result:=ippsIIRSetTaps64fc_32fc(pTaps,pState);
end;

function ippsIIRSetTaps64f(pTaps:PIpp64f;pState:PIppsIIRState64f_32s):IppStatus;
begin
  result:=ippsIIRSetTaps64f_32s(pTaps,pState);
end;

function ippsIIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsIIRState64fc_32sc):IppStatus;
begin
  result:=ippsIIRSetTaps64fc_32sc(pTaps,pState);
end;

function ippsIIRSetTaps64f(pTaps:PIpp64f;pState:PIppsIIRState64f_16s):IppStatus;
begin
  result:=ippsIIRSetTaps64f_16s(pTaps,pState);
end;

function ippsIIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsIIRState64fc_16sc):IppStatus;
begin
  result:=ippsIIRSetTaps64fc_16sc(pTaps,pState);
end;

function ippsFIRInitAlloc(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRInitAlloc_32f(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRMRInitAlloc_32f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRInitAlloc_32fc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc_32fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRInitAlloc32f_16s(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRMRInitAlloc32f_16s(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRInitAlloc32fc_16sc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc32fc_16sc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsFIRInitAlloc_64f(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsFIRMRInitAlloc_64f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsFIRInitAlloc_64fc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc_64fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRInitAlloc64f_32f(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRMRInitAlloc64f_32f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRInitAlloc64fc_32fc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc64fc_32fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsFIRInitAlloc64f_32s(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsFIRMRInitAlloc64f_32s(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsFIRInitAlloc64fc_32sc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc64fc_32sc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRInitAlloc64f_16s(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRMRInitAlloc64f_16s(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRInitAlloc64fc_16sc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc64fc_16sc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRFree(pState:PIppsFIRState_32f):IppStatus;
begin
  result:=ippsFIRFree_32f(pState);
end;

function ippsFIRFree(pState:PIppsFIRState_32fc):IppStatus;
begin
  result:=ippsFIRFree_32fc(pState);
end;

function ippsFIRFree32f(pState:PIppsFIRState32f_16s):IppStatus;
begin
  result:=ippsFIRFree32f_16s(pState);
end;

function ippsFIRFree32fc(pState:PIppsFIRState32fc_16sc):IppStatus;
begin
  result:=ippsFIRFree32fc_16sc(pState);
end;

function ippsFIRFree(pState:PIppsFIRState_64f):IppStatus;
begin
  result:=ippsFIRFree_64f(pState);
end;

function ippsFIRFree(pState:PIppsFIRState_64fc):IppStatus;
begin
  result:=ippsFIRFree_64fc(pState);
end;

function ippsFIRFree64f(pState:PIppsFIRState64f_32f):IppStatus;
begin
  result:=ippsFIRFree64f_32f(pState);
end;

function ippsFIRFree64fc(pState:PIppsFIRState64fc_32fc):IppStatus;
begin
  result:=ippsFIRFree64fc_32fc(pState);
end;

function ippsFIRFree64f(pState:PIppsFIRState64f_32s):IppStatus;
begin
  result:=ippsFIRFree64f_32s(pState);
end;

function ippsFIRFree64fc(pState:PIppsFIRState64fc_32sc):IppStatus;
begin
  result:=ippsFIRFree64fc_32sc(pState);
end;

function ippsFIRFree64f(pState:PIppsFIRState64f_16s):IppStatus;
begin
  result:=ippsFIRFree64f_16s(pState);
end;

function ippsFIRFree64fc(pState:PIppsFIRState64fc_16sc):IppStatus;
begin
  result:=ippsFIRFree64fc_16sc(pState);
end;

function ippsFIRGetStateSize32s(tapsLen:longint;pStateSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize32s_16s(tapsLen,pStateSize);
end;

function ippsFIRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit32s_16s(pState,pTaps,tapsLen,tapsFactor,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize32s(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize32s_16s(tapsLen,upFactor,downFactor,pStateSize);
end;

function ippsFIRMRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit32s_16s(pState,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit32sc_16sc(pState,pTaps,tapsLen,tapsFactor,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize32sc(tapsLen:longint;upFactor:longint;downFactor:longint;pStateSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize32sc_16sc(tapsLen,upFactor,downFactor,pStateSize);
end;

function ippsFIRMRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit32sc_16sc(pState,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRGetStateSize32sc(tapsLen:longint;pStateSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize32sc_16sc32fc(tapsLen,pStateSize);
end;

function ippsFIRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit32s_16s32f(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRInit32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit32s_16s32f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit32sc_16sc32fc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRInit32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit32sc_16sc32fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRInit(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit_32f(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRInit(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit_32fc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRGetStateSize(tapsLen:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize_32f(tapsLen,pBufferSize);
end;

function ippsFIRMRInit(var pState:PIppsFIRState_32f;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit_32f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize_32f(tapsLen,upFactor,downFactor,pBufferSize);
end;

function ippsFIRMRInit(var pState:PIppsFIRState_32fc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit_32fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRGetStateSize32f(tapsLen:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize32f_16s(tapsLen,pBufferSize);
end;

function ippsFIRInit32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit32f_16s(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRGetStateSize32fc(tapsLen:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize32fc_16sc(tapsLen,pBufferSize);
end;

function ippsFIRInit32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit32fc_16sc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize32f(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize32f_16s(tapsLen,upFactor,downFactor,pBufferSize);
end;

function ippsFIRMRInit32f(var pState:PIppsFIRState32f_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit32f_16s(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize32fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize32fc_16sc(tapsLen,upFactor,downFactor,pBufferSize);
end;

function ippsFIRMRInit32fc(var pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit32fc_16sc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRInit(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit_64f(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRInit(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit_64fc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRInit(var pState:PIppsFIRState_64f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit_64f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRMRInit(var pState:PIppsFIRState_64fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit_64fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRGetStateSize64f(tapsLen:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize64f_16s(tapsLen,pBufferSize);
end;

function ippsFIRInit64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit64f_16s(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRGetStateSize64fc(tapsLen:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRGetStateSize64fc_16sc(tapsLen,pBufferSize);
end;

function ippsFIRInit64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit64fc_16sc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize64f(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize64f_16s(tapsLen,upFactor,downFactor,pBufferSize);
end;

function ippsFIRMRInit64f(var pState:PIppsFIRState64f_16s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit64f_16s(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRMRGetStateSize64fc(tapsLen:longint;upFactor:longint;downFactor:longint;pBufferSize:Plongint):IppStatus;
begin
  result:=ippsFIRMRGetStateSize64fc_16sc(tapsLen,upFactor,downFactor,pBufferSize);
end;

function ippsFIRMRInit64fc(var pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit64fc_16sc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRInit64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit64f_32s(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRInit64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit64fc_32sc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRInit64f(var pState:PIppsFIRState64f_32s;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit64f_32s(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRMRInit64fc(var pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit64fc_32sc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRInit64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit64f_32f(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRInit64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRInit64fc_32fc(pState,pTaps,tapsLen,pDlyLine,pBuffer);
end;

function ippsFIRMRInit64f(var pState:PIppsFIRState64f_32f;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit64f_32f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRMRInit64fc(var pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc;pBuffer:PIpp8u):IppStatus;
begin
  result:=ippsFIRMRInit64fc_32fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,pBuffer);
end;

function ippsFIRGetTaps(pState:PIppsFIRState_32f;pTaps:PIpp32f):IppStatus;
begin
  result:=ippsFIRGetTaps_32f(pState,pTaps);
end;

function ippsFIRGetTaps(pState:PIppsFIRState_32fc;pTaps:PIpp32fc):IppStatus;
begin
  result:=ippsFIRGetTaps_32fc(pState,pTaps);
end;

function ippsFIRGetTaps32f(pState:PIppsFIRState32f_16s;pTaps:PIpp32f):IppStatus;
begin
  result:=ippsFIRGetTaps32f_16s(pState,pTaps);
end;

function ippsFIRGetTaps32fc(pState:PIppsFIRState32fc_16sc;pTaps:PIpp32fc):IppStatus;
begin
  result:=ippsFIRGetTaps32fc_16sc(pState,pTaps);
end;

function ippsFIRGetTaps(pState:PIppsFIRState_64f;pTaps:PIpp64f):IppStatus;
begin
  result:=ippsFIRGetTaps_64f(pState,pTaps);
end;

function ippsFIRGetTaps(pState:PIppsFIRState_64fc;pTaps:PIpp64fc):IppStatus;
begin
  result:=ippsFIRGetTaps_64fc(pState,pTaps);
end;

function ippsFIRGetTaps64f(pState:PIppsFIRState64f_32f;pTaps:PIpp64f):IppStatus;
begin
  result:=ippsFIRGetTaps64f_32f(pState,pTaps);
end;

function ippsFIRGetTaps64fc(pState:PIppsFIRState64fc_32fc;pTaps:PIpp64fc):IppStatus;
begin
  result:=ippsFIRGetTaps64fc_32fc(pState,pTaps);
end;

function ippsFIRGetTaps64f(pState:PIppsFIRState64f_32s;pTaps:PIpp64f):IppStatus;
begin
  result:=ippsFIRGetTaps64f_32s(pState,pTaps);
end;

function ippsFIRGetTaps64fc(pState:PIppsFIRState64fc_32sc;pTaps:PIpp64fc):IppStatus;
begin
  result:=ippsFIRGetTaps64fc_32sc(pState,pTaps);
end;

function ippsFIRGetTaps64f(pState:PIppsFIRState64f_16s;pTaps:PIpp64f):IppStatus;
begin
  result:=ippsFIRGetTaps64f_16s(pState,pTaps);
end;

function ippsFIRGetTaps64fc(pState:PIppsFIRState64fc_16sc;pTaps:PIpp64fc):IppStatus;
begin
  result:=ippsFIRGetTaps64fc_16sc(pState,pTaps);
end;

function ippsFIRSetTaps(pTaps:PIpp32f;pState:PIppsFIRState_32f):IppStatus;
begin
  result:=ippsFIRSetTaps_32f(pTaps,pState);
end;

function ippsFIRSetTaps(pTaps:PIpp32fc;pState:PIppsFIRState_32fc):IppStatus;
begin
  result:=ippsFIRSetTaps_32fc(pTaps,pState);
end;

function ippsFIRSetTaps32f(pTaps:PIpp32f;pState:PIppsFIRState32f_16s):IppStatus;
begin
  result:=ippsFIRSetTaps32f_16s(pTaps,pState);
end;

function ippsFIRSetTaps32fc(pTaps:PIpp32fc;pState:PIppsFIRState32fc_16sc):IppStatus;
begin
  result:=ippsFIRSetTaps32fc_16sc(pTaps,pState);
end;

function ippsFIRSetTaps32s(pTaps:PIpp32s;pState:PIppsFIRState32s_16s;tapsFactor:longint):IppStatus;
begin
  result:=ippsFIRSetTaps32s_16s(pTaps,pState,tapsFactor);
end;

function ippsFIRSetTaps32sc(pTaps:PIpp32sc;pState:PIppsFIRState32sc_16sc;tapsFactor:longint):IppStatus;
begin
  result:=ippsFIRSetTaps32sc_16sc(pTaps,pState,tapsFactor);
end;

function ippsFIRSetTaps32s(pTaps:PIpp32f;pState:PIppsFIRState32s_16s):IppStatus;
begin
  result:=ippsFIRSetTaps32s_16s32f(pTaps,pState);
end;

function ippsFIRSetTaps32sc(pTaps:PIpp32fc;pState:PIppsFIRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRSetTaps32sc_16sc32fc(pTaps,pState);
end;

function ippsFIRSetTaps(pTaps:PIpp64f;pState:PIppsFIRState_64f):IppStatus;
begin
  result:=ippsFIRSetTaps_64f(pTaps,pState);
end;

function ippsFIRSetTaps(pTaps:PIpp64fc;pState:PIppsFIRState_64fc):IppStatus;
begin
  result:=ippsFIRSetTaps_64fc(pTaps,pState);
end;

function ippsFIRSetTaps64f(pTaps:PIpp64f;pState:PIppsFIRState64f_32f):IppStatus;
begin
  result:=ippsFIRSetTaps64f_32f(pTaps,pState);
end;

function ippsFIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsFIRState64fc_32fc):IppStatus;
begin
  result:=ippsFIRSetTaps64fc_32fc(pTaps,pState);
end;

function ippsFIRSetTaps64f(pTaps:PIpp64f;pState:PIppsFIRState64f_32s):IppStatus;
begin
  result:=ippsFIRSetTaps64f_32s(pTaps,pState);
end;

function ippsFIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsFIRState64fc_32sc):IppStatus;
begin
  result:=ippsFIRSetTaps64fc_32sc(pTaps,pState);
end;

function ippsFIRSetTaps64f(pTaps:PIpp64f;pState:PIppsFIRState64f_16s):IppStatus;
begin
  result:=ippsFIRSetTaps64f_16s(pTaps,pState);
end;

function ippsFIRSetTaps64fc(pTaps:PIpp64fc;pState:PIppsFIRState64fc_16sc):IppStatus;
begin
  result:=ippsFIRSetTaps64fc_16sc(pTaps,pState);
end;

function ippsFIRGetDlyLine(pState:PIppsFIRState_32f;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRGetDlyLine_32f(pState,pDlyLine);
end;

function ippsFIRSetDlyLine(pState:PIppsFIRState_32f;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRSetDlyLine_32f(pState,pDlyLine);
end;

function ippsFIRGetDlyLine(pState:PIppsFIRState_32fc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRGetDlyLine_32fc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine(pState:PIppsFIRState_32fc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRSetDlyLine_32fc(pState,pDlyLine);
end;

function ippsFIRGetDlyLine32f(pState:PIppsFIRState32f_16s;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRGetDlyLine32f_16s(pState,pDlyLine);
end;

function ippsFIRSetDlyLine32f(pState:PIppsFIRState32f_16s;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRSetDlyLine32f_16s(pState,pDlyLine);
end;

function ippsFIRGetDlyLine32fc(pState:PIppsFIRState32fc_16sc;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRGetDlyLine32fc_16sc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine32fc(pState:PIppsFIRState32fc_16sc;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRSetDlyLine32fc_16sc(pState,pDlyLine);
end;

function ippsFIRGetDlyLine(pState:PIppsFIRState_64f;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsFIRGetDlyLine_64f(pState,pDlyLine);
end;

function ippsFIRSetDlyLine(pState:PIppsFIRState_64f;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsFIRSetDlyLine_64f(pState,pDlyLine);
end;

function ippsFIRGetDlyLine(pState:PIppsFIRState_64fc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsFIRGetDlyLine_64fc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine(pState:PIppsFIRState_64fc;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsFIRSetDlyLine_64fc(pState,pDlyLine);
end;

function ippsFIRGetDlyLine64f(pState:PIppsFIRState64f_32f;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRGetDlyLine64f_32f(pState,pDlyLine);
end;

function ippsFIRSetDlyLine64f(pState:PIppsFIRState64f_32f;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRSetDlyLine64f_32f(pState,pDlyLine);
end;

function ippsFIRGetDlyLine64fc(pState:PIppsFIRState64fc_32fc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRGetDlyLine64fc_32fc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine64fc(pState:PIppsFIRState64fc_32fc;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRSetDlyLine64fc_32fc(pState,pDlyLine);
end;

function ippsFIRGetDlyLine64f(pState:PIppsFIRState64f_32s;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsFIRGetDlyLine64f_32s(pState,pDlyLine);
end;

function ippsFIRSetDlyLine64f(pState:PIppsFIRState64f_32s;pDlyLine:PIpp32s):IppStatus;
begin
  result:=ippsFIRSetDlyLine64f_32s(pState,pDlyLine);
end;

function ippsFIRGetDlyLine64fc(pState:PIppsFIRState64fc_32sc;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsFIRGetDlyLine64fc_32sc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine64fc(pState:PIppsFIRState64fc_32sc;pDlyLine:PIpp32sc):IppStatus;
begin
  result:=ippsFIRSetDlyLine64fc_32sc(pState,pDlyLine);
end;

function ippsFIRGetDlyLine64f(pState:PIppsFIRState64f_16s;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRGetDlyLine64f_16s(pState,pDlyLine);
end;

function ippsFIRSetDlyLine64f(pState:PIppsFIRState64f_16s;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRSetDlyLine64f_16s(pState,pDlyLine);
end;

function ippsFIRGetDlyLine64fc(pState:PIppsFIRState64fc_16sc;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRGetDlyLine64fc_16sc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine64fc(pState:PIppsFIRState64fc_16sc;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRSetDlyLine64fc_16sc(pState,pDlyLine);
end;

function ippsFIROne(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsFIRState_32f):IppStatus;
begin
  result:=ippsFIROne_32f(src,pDstVal,pState);
end;

function ippsFIROne(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsFIRState_32fc):IppStatus;
begin
  result:=ippsFIROne_32fc(src,pDstVal,pState);
end;

function ippsFIROne32f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32f_16s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIROne32fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32fc_16sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIROne(src:Ipp64f;pDstVal:PIpp64f;pState:PIppsFIRState_64f):IppStatus;
begin
  result:=ippsFIROne_64f(src,pDstVal,pState);
end;

function ippsFIROne(src:Ipp64fc;pDstVal:PIpp64fc;pState:PIppsFIRState_64fc):IppStatus;
begin
  result:=ippsFIROne_64fc(src,pDstVal,pState);
end;

function ippsFIROne64f(src:Ipp32f;pDstVal:PIpp32f;pState:PIppsFIRState64f_32f):IppStatus;
begin
  result:=ippsFIROne64f_32f(src,pDstVal,pState);
end;

function ippsFIROne64fc(src:Ipp32fc;pDstVal:PIpp32fc;pState:PIppsFIRState64fc_32fc):IppStatus;
begin
  result:=ippsFIROne64fc_32fc(src,pDstVal,pState);
end;

function ippsFIROne64f(src:Ipp32s;pDstVal:PIpp32s;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64f_32s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIROne64fc(src:Ipp32sc;pDstVal:PIpp32sc;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64fc_32sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIROne64f(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64f_16s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIROne64fc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64fc_16sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIR(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pState:PIppsFIRState_32f):IppStatus;
begin
  result:=ippsFIR_32f(pSrc,pDst,numIters,pState);
end;

function ippsFIR(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pState:PIppsFIRState_32fc):IppStatus;
begin
  result:=ippsFIR_32fc(pSrc,pDst,numIters,pState);
end;

function ippsFIR32f(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32f_16s_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR32fc(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32fc_16sc_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR(pSrcDst:PIpp32f;numIters:longint;pState:PIppsFIRState_32f):IppStatus;
begin
  result:=ippsFIR_32f_I(pSrcDst,numIters,pState);
end;

function ippsFIR(pSrcDst:PIpp32fc;numIters:longint;pState:PIppsFIRState_32fc):IppStatus;
begin
  result:=ippsFIR_32fc_I(pSrcDst,numIters,pState);
end;

function ippsFIR32f(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState32f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32f_16s_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIR32fc(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32fc_16sc_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIR(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pState:PIppsFIRState_64f):IppStatus;
begin
  result:=ippsFIR_64f(pSrc,pDst,numIters,pState);
end;

function ippsFIR(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pState:PIppsFIRState_64fc):IppStatus;
begin
  result:=ippsFIR_64fc(pSrc,pDst,numIters,pState);
end;

function ippsFIR(pSrcDst:PIpp64f;numIters:longint;pState:PIppsFIRState_64f):IppStatus;
begin
  result:=ippsFIR_64f_I(pSrcDst,numIters,pState);
end;

function ippsFIR(pSrcDst:PIpp64fc;numIters:longint;pState:PIppsFIRState_64fc):IppStatus;
begin
  result:=ippsFIR_64fc_I(pSrcDst,numIters,pState);
end;

function ippsFIR64f(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pState:PIppsFIRState64f_32f):IppStatus;
begin
  result:=ippsFIR64f_32f(pSrc,pDst,numIters,pState);
end;

function ippsFIR64fc(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pState:PIppsFIRState64fc_32fc):IppStatus;
begin
  result:=ippsFIR64fc_32fc(pSrc,pDst,numIters,pState);
end;

function ippsFIR64f(pSrcDst:PIpp32f;numIters:longint;pState:PIppsFIRState64f_32f):IppStatus;
begin
  result:=ippsFIR64f_32f_I(pSrcDst,numIters,pState);
end;

function ippsFIR64fc(pSrcDst:PIpp32fc;numIters:longint;pState:PIppsFIRState64fc_32fc):IppStatus;
begin
  result:=ippsFIR64fc_32fc_I(pSrcDst,numIters,pState);
end;

function ippsFIR64f(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_32s_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR64fc(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_32sc_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR64f(pSrcDst:PIpp32s;numIters:longint;pState:PIppsFIRState64f_32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_32s_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIR64fc(pSrcDst:PIpp32sc;numIters:longint;pState:PIppsFIRState64fc_32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_32sc_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIR64f(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_16s_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR64fc(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_16sc_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR64f(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState64f_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_16s_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIR64fc(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState64fc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_16sc_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRInitAlloc32s_16s(pState,pTaps,tapsLen,tapsFactor,pDlyLine);
end;

function ippsFIRMRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRMRInitAlloc32s_16s(pState,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRInitAlloc32s_16s32f(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc32s(var pState:PIppsFIRState32s_16s;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRMRInitAlloc32s_16s32f(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRInitAlloc32sc_16sc(pState,pTaps,tapsLen,tapsFactor,pDlyLine);
end;

function ippsFIRMRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc32sc_16sc(pState,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRInitAlloc32sc_16sc32fc(pState,pTaps,tapsLen,pDlyLine);
end;

function ippsFIRMRInitAlloc32sc(var pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRMRInitAlloc32sc_16sc32fc(pState,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRFree32s(pState:PIppsFIRState32s_16s):IppStatus;
begin
  result:=ippsFIRFree32s_16s(pState);
end;

function ippsFIRFree32sc(pState:PIppsFIRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRFree32sc_16sc(pState);
end;

function ippsFIRGetTaps32s(pState:PIppsFIRState32s_16s;pTaps:PIpp32s;tapsFactor:Plongint):IppStatus;
begin
  result:=ippsFIRGetTaps32s_16s(pState,pTaps,tapsFactor);
end;

function ippsFIRGetTaps32sc(pState:PIppsFIRState32sc_16sc;pTaps:PIpp32sc;tapsFactor:Plongint):IppStatus;
begin
  result:=ippsFIRGetTaps32sc_16sc(pState,pTaps,tapsFactor);
end;

function ippsFIRGetTaps32s(pState:PIppsFIRState32s_16s;pTaps:PIpp32f):IppStatus;
begin
  result:=ippsFIRGetTaps32s_16s32f(pState,pTaps);
end;

function ippsFIRGetTaps32sc(pState:PIppsFIRState32sc_16sc;pTaps:PIpp32fc):IppStatus;
begin
  result:=ippsFIRGetTaps32sc_16sc32fc(pState,pTaps);
end;

function ippsFIRGetDlyLine32s(pState:PIppsFIRState32s_16s;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRGetDlyLine32s_16s(pState,pDlyLine);
end;

function ippsFIRSetDlyLine32s(pState:PIppsFIRState32s_16s;pDlyLine:PIpp16s):IppStatus;
begin
  result:=ippsFIRSetDlyLine32s_16s(pState,pDlyLine);
end;

function ippsFIRGetDlyLine32sc(pState:PIppsFIRState32sc_16sc;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRGetDlyLine32sc_16sc(pState,pDlyLine);
end;

function ippsFIRSetDlyLine32sc(pState:PIppsFIRState32sc_16sc;pDlyLine:PIpp16sc):IppStatus;
begin
  result:=ippsFIRSetDlyLine32sc_16sc(pState,pDlyLine);
end;

function ippsFIROne32s(src:Ipp16s;pDstVal:PIpp16s;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32s_16s_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIROne32sc(src:Ipp16sc;pDstVal:PIpp16sc;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32sc_16sc_Sfs(src,pDstVal,pState,scaleFactor);
end;

function ippsFIR32s(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32s_16s_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR32sc(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32sc_16sc_Sfs(pSrc,pDst,numIters,pState,scaleFactor);
end;

function ippsFIR32s(pSrcDst:PIpp16s;numIters:longint;pState:PIppsFIRState32s_16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32s_16s_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIR32sc(pSrcDst:PIpp16sc;numIters:longint;pState:PIppsFIRState32sc_16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32sc_16sc_ISfs(pSrcDst,numIters,pState,scaleFactor);
end;

function ippsFIRLMSOne_Direct(src:Ipp32f;refval:Ipp32f;pDstVal:PIpp32f;pTapsInv:PIpp32f;tapsLen:longint;mu:single;pDlyLine:PIpp32f;pDlyIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSOne_Direct_32f(src,refval,pDstVal,pTapsInv,tapsLen,mu,pDlyLine,pDlyIndex);
end;

function ippsFIRLMSOne_Direct32f(src:Ipp16s;refval:Ipp16s;pDstVal:PIpp16s;pTapsInv:PIpp32f;tapsLen:longint;mu:single;pDlyLine:PIpp16s;pDlyIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSOne_Direct32f_16s(src,refval,pDstVal,pTapsInv,tapsLen,mu,pDlyLine,pDlyIndex);
end;

function ippsFIRLMSOne_DirectQ15(src:Ipp16s;refval:Ipp16s;pDstVal:PIpp16s;pTapsInv:PIpp32s;tapsLen:longint;muQ15:longint;pDlyLine:PIpp16s;pDlyIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSOne_DirectQ15_16s(src,refval,pDstVal,pTapsInv,tapsLen,muQ15,pDlyLine,pDlyIndex);
end;

function ippsFIRLMS(pSrc:PIpp32f;pRef:PIpp32f;pDst:PIpp32f;len:longint;mu:single;pState:PIppsFIRLMSState_32f):IppStatus;
begin
  result:=ippsFIRLMS_32f(pSrc,pRef,pDst,len,mu,pState);
end;

function ippsFIRLMS32f(pSrc:PIpp16s;pRef:PIpp16s;pDst:PIpp16s;len:longint;mu:single;pStatel:PIppsFIRLMSState32f_16s):IppStatus;
begin
  result:=ippsFIRLMS32f_16s(pSrc,pRef,pDst,len,mu,pStatel);
end;

function ippsFIRLMSInitAlloc(var pState:PIppsFIRLMSState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;
begin
  result:=ippsFIRLMSInitAlloc_32f(pState,pTaps,tapsLen,pDlyLine,dlyLineIndex);
end;

function ippsFIRLMSInitAlloc32f(var pState:PIppsFIRLMSState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;
begin
  result:=ippsFIRLMSInitAlloc32f_16s(pState,pTaps,tapsLen,pDlyLine,dlyLineIndex);
end;

function ippsFIRLMSFree(pState:PIppsFIRLMSState_32f):IppStatus;
begin
  result:=ippsFIRLMSFree_32f(pState);
end;

function ippsFIRLMSFree32f(pState:PIppsFIRLMSState32f_16s):IppStatus;
begin
  result:=ippsFIRLMSFree32f_16s(pState);
end;

function ippsFIRLMSGetTaps(pState:PIppsFIRLMSState_32f;pOutTaps:PIpp32f):IppStatus;
begin
  result:=ippsFIRLMSGetTaps_32f(pState,pOutTaps);
end;

function ippsFIRLMSGetTaps32f(pState:PIppsFIRLMSState32f_16s;pOutTaps:PIpp32f):IppStatus;
begin
  result:=ippsFIRLMSGetTaps32f_16s(pState,pOutTaps);
end;

function ippsFIRLMSGetDlyLine(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSGetDlyLine_32f(pState,pDlyLine,pDlyLineIndex);
end;

function ippsFIRLMSGetDlyLine32f(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSGetDlyLine32f_16s(pState,pDlyLine,pDlyLineIndex);
end;

function ippsFIRLMSSetDlyLine(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;
begin
  result:=ippsFIRLMSSetDlyLine_32f(pState,pDlyLine,dlyLineIndex);
end;

function ippsFIRLMSSetDlyLine32f(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;
begin
  result:=ippsFIRLMSSetDlyLine32f_16s(pState,pDlyLine,dlyLineIndex);
end;

function ippsFIRLMSMROne32s(pDstVal:PIpp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;
begin
  result:=ippsFIRLMSMROne32s_16s(pDstVal,pState);
end;

function ippsFIRLMSMROneVal32s(val:Ipp16s;pDstVal:PIpp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;
begin
  result:=ippsFIRLMSMROneVal32s_16s(val,pDstVal,pState);
end;

function ippsFIRLMSMROne32sc(pDstVal:PIpp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRLMSMROne32sc_16sc(pDstVal,pState);
end;

function ippsFIRLMSMROneVal32sc(val:Ipp16sc;pDstVal:PIpp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRLMSMROneVal32sc_16sc(val,pDstVal,pState);
end;

function ippsFIRLMSMRInitAlloc32s(var pState:PIppsFIRLMSMRState32s_16s;pTaps:PIpp32s;tapsLen:longint;pDlyLine:PIpp16s;dlyLineIndex:longint;dlyStep:longint;updateDly:longint;mu:longint):IppStatus;
begin
  result:=ippsFIRLMSMRInitAlloc32s_16s(pState,pTaps,tapsLen,pDlyLine,dlyLineIndex,dlyStep,updateDly,mu);
end;

function ippsFIRLMSMRFree32s(pState:PIppsFIRLMSMRState32s_16s):IppStatus;
begin
  result:=ippsFIRLMSMRFree32s_16s(pState);
end;

function ippsFIRLMSMRInitAlloc32sc(var pState:PIppsFIRLMSMRState32sc_16sc;pTaps:PIpp32sc;tapsLen:longint;pDlyLine:PIpp16sc;dlyLineIndex:longint;dlyStep:longint;updateDly:longint;mu:longint):IppStatus;
begin
  result:=ippsFIRLMSMRInitAlloc32sc_16sc(pState,pTaps,tapsLen,pDlyLine,dlyLineIndex,dlyStep,updateDly,mu);
end;

function ippsFIRLMSMRFree32sc(pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRLMSMRFree32sc_16sc(pState);
end;

function ippsFIRLMSMRSetTaps32s(pState:PIppsFIRLMSMRState32s_16s;pInTaps:PIpp32s):IppStatus;
begin
  result:=ippsFIRLMSMRSetTaps32s_16s(pState,pInTaps);
end;

function ippsFIRLMSMRGetTaps32s(pState:PIppsFIRLMSMRState32s_16s;pOutTaps:PIpp32s):IppStatus;
begin
  result:=ippsFIRLMSMRGetTaps32s_16s(pState,pOutTaps);
end;

function ippsFIRLMSMRGetTapsPointer32s(pState:PIppsFIRLMSMRState32s_16s;var pTaps:PIpp32s):IppStatus;
begin
  result:=ippsFIRLMSMRGetTapsPointer32s_16s(pState,pTaps);
end;

function ippsFIRLMSMRSetTaps32sc(pState:PIppsFIRLMSMRState32sc_16sc;pInTaps:PIpp32sc):IppStatus;
begin
  result:=ippsFIRLMSMRSetTaps32sc_16sc(pState,pInTaps);
end;

function ippsFIRLMSMRGetTaps32sc(pState:PIppsFIRLMSMRState32sc_16sc;pOutTaps:PIpp32sc):IppStatus;
begin
  result:=ippsFIRLMSMRGetTaps32sc_16sc(pState,pOutTaps);
end;

function ippsFIRLMSMRGetTapsPointer32sc(pState:PIppsFIRLMSMRState32sc_16sc;var pTaps:PIpp32sc):IppStatus;
begin
  result:=ippsFIRLMSMRGetTapsPointer32sc_16sc(pState,pTaps);
end;

function ippsFIRLMSMRSetDlyLine32s(pState:PIppsFIRLMSMRState32s_16s;pInDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;
begin
  result:=ippsFIRLMSMRSetDlyLine32s_16s(pState,pInDlyLine,dlyLineIndex);
end;

function ippsFIRLMSMRGetDlyLine32s(pState:PIppsFIRLMSMRState32s_16s;pOutDlyLine:PIpp16s;pOutDlyIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSMRGetDlyLine32s_16s(pState,pOutDlyLine,pOutDlyIndex);
end;

function ippsFIRLMSMRGetDlyVal32s(pState:PIppsFIRLMSMRState32s_16s;pOutVal:PIpp16s;index:longint):IppStatus;
begin
  result:=ippsFIRLMSMRGetDlyVal32s_16s(pState,pOutVal,index);
end;

function ippsFIRLMSMRSetDlyLine32sc(pState:PIppsFIRLMSMRState32sc_16sc;pInDlyLine:PIpp16sc;dlyLineIndex:longint):IppStatus;
begin
  result:=ippsFIRLMSMRSetDlyLine32sc_16sc(pState,pInDlyLine,dlyLineIndex);
end;

function ippsFIRLMSMRGetDlyLine32sc(pState:PIppsFIRLMSMRState32sc_16sc;pOutDlyLine:PIpp16sc;pOutDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIRLMSMRGetDlyLine32sc_16sc(pState,pOutDlyLine,pOutDlyLineIndex);
end;

function ippsFIRLMSMRGetDlyVal32sc(pState:PIppsFIRLMSMRState32sc_16sc;pOutVal:PIpp16sc;index:longint):IppStatus;
begin
  result:=ippsFIRLMSMRGetDlyVal32sc_16sc(pState,pOutVal,index);
end;

function ippsFIRLMSMRPutVal32s(val:Ipp16s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;
begin
  result:=ippsFIRLMSMRPutVal32s_16s(val,pState);
end;

function ippsFIRLMSMRPutVal32sc(val:Ipp16sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRLMSMRPutVal32sc_16sc(val,pState);
end;

function ippsFIRLMSMRSetMu32s(pState:PIppsFIRLMSMRState32s_16s;mu:longint):IppStatus;
begin
  result:=ippsFIRLMSMRSetMu32s_16s(pState,mu);
end;

function ippsFIRLMSMRSetMu32sc(pState:PIppsFIRLMSMRState32sc_16sc;mu:longint):IppStatus;
begin
  result:=ippsFIRLMSMRSetMu32sc_16sc(pState,mu);
end;

function ippsFIRLMSMRUpdateTaps32s(ErrVal:Ipp32s;pState:PIppsFIRLMSMRState32s_16s):IppStatus;
begin
  result:=ippsFIRLMSMRUpdateTaps32s_16s(ErrVal,pState);
end;

function ippsFIRLMSMRUpdateTaps32sc(ErrVal:Ipp32sc;pState:PIppsFIRLMSMRState32sc_16sc):IppStatus;
begin
  result:=ippsFIRLMSMRUpdateTaps32sc_16sc(ErrVal,pState);
end;

function ippsFIROne_Direct(src:Ipp32f;pDstVal:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_32f(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne_Direct(src:Ipp32fc;pDstVal:PIpp32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_32fc(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne_Direct(pSrcDstVal:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_32f_I(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne_Direct(pSrcDstVal:PIpp32fc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_32fc_I(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne32f_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32f_Direct_16s_Sfs(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32fc_Direct(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32fc_Direct_16sc_Sfs(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32f_Direct(pSrcDstVal:PIpp16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32f_Direct_16s_ISfs(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32fc_Direct(pSrcDstVal:PIpp16sc;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32fc_Direct_16sc_ISfs(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne_Direct(src:Ipp64f;pDstVal:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_64f(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne_Direct(src:Ipp64fc;pDstVal:PIpp64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_64fc(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne_Direct(pSrcDstVal:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_64f_I(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne_Direct(pSrcDstVal:PIpp64fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne_Direct_64fc_I(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne64f_Direct(src:Ipp32f;pDstVal:PIpp32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne64f_Direct_32f(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne64fc_Direct(src:Ipp32fc;pDstVal:PIpp32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne64fc_Direct_32fc(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne64f_Direct(pSrcDstVal:PIpp32f;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne64f_Direct_32f_I(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne64fc_Direct(pSrcDstVal:PIpp32fc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIROne64fc_Direct_32fc_I(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIROne64f_Direct(src:Ipp32s;pDstVal:PIpp32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64f_Direct_32s_Sfs(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64fc_Direct(src:Ipp32sc;pDstVal:PIpp32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64fc_Direct_32sc_Sfs(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64f_Direct(pSrcDstVal:PIpp32s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64f_Direct_32s_ISfs(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64fc_Direct(pSrcDstVal:PIpp32sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64fc_Direct_32sc_ISfs(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64f_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64f_Direct_16s_Sfs(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64fc_Direct(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64fc_Direct_16sc_Sfs(src,pDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64f_Direct(pSrcDstVal:PIpp16s;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64f_Direct_16s_ISfs(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne64fc_Direct(pSrcDstVal:PIpp16sc;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne64fc_Direct_16sc_ISfs(pSrcDstVal,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32s_Direct(src:Ipp16s;pDstVal:PIpp16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32s_Direct_16s_Sfs(src,pDstVal,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32sc_Direct(src:Ipp16sc;pDstVal:PIpp16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32sc_Direct_16sc_Sfs(src,pDstVal,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32s_Direct(pSrcDstVal:PIpp16s;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32s_Direct_16s_ISfs(pSrcDstVal,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne32sc_Direct(pSrcDstVal:PIpp16sc;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne32sc_Direct_16sc_ISfs(pSrcDstVal,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_32f(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_32fc(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_32f_I(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_32fc_I(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR32f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32f_Direct_16s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32fc_Direct_16sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32f_Direct_16s_ISfs(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32fc_Direct_16sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR_Direct(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_64f(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR_Direct(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_64fc(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR_Direct(pSrcDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp64f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_64f_I(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR_Direct(pSrcDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp64fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR_Direct_64fc_I(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR64f_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR64f_Direct_32f(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR64fc_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR64fc_Direct_32fc(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR64f_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR64f_Direct_32f_I(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR64fc_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32fc;pDlyLineIndex:Plongint):IppStatus;
begin
  result:=ippsFIR64fc_Direct_32fc_I(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex);
end;

function ippsFIR64f_Direct(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_Direct_32s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64fc_Direct(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_Direct_32sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64f_Direct(pSrcDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp32s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_Direct_32s_ISfs(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64fc_Direct(pSrcDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp32sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_Direct_32sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_Direct_16s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_Direct_16sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64f_Direct_16s_ISfs(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR64fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR64fc_Direct_16sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32s_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32s_Direct_16s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32sc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32sc_Direct_16sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32s_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32s_Direct_16s_ISfs(pSrcDst,numIters,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR32sc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;pDlyLine:PIpp16sc;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR32sc_Direct_16sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,tapsFactor,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIRMR_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRMR_Direct_32f(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRMR_Direct_32fc(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRMR_Direct_32f_I(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRMR_Direct_32fc_I(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR32f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32f_Direct_16s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32fc_Direct_16sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32f_Direct_16s_ISfs(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32fc_Direct_16sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR_Direct(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsFIRMR_Direct_64f(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR_Direct(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsFIRMR_Direct_64fc(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR_Direct(pSrcDst:PIpp64f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64f):IppStatus;
begin
  result:=ippsFIRMR_Direct_64f_I(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR_Direct(pSrcDst:PIpp64fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp64fc):IppStatus;
begin
  result:=ippsFIRMR_Direct_64fc_I(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR64f_Direct(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRMR64f_Direct_32f(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR64fc_Direct(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRMR64fc_Direct_32fc(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR64f_Direct(pSrcDst:PIpp32f;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32f):IppStatus;
begin
  result:=ippsFIRMR64f_Direct_32f_I(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR64fc_Direct(pSrcDst:PIpp32fc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32fc):IppStatus;
begin
  result:=ippsFIRMR64fc_Direct_32fc_I(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine);
end;

function ippsFIRMR64f_Direct(pSrc:PIpp32s;pDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64f_Direct_32s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64fc_Direct(pSrc:PIpp32sc;pDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64fc_Direct_32sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64f_Direct(pSrcDst:PIpp32s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64f_Direct_32s_ISfs(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64fc_Direct(pSrcDst:PIpp32sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp32sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64fc_Direct_32sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64f_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64f_Direct_16s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64fc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64fc_Direct_16sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64f_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64f_Direct_16s_ISfs(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR64fc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR64fc_Direct_16sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32s_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32s_Direct_16s_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32sc_Direct(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32sc_Direct_16sc_Sfs(pSrc,pDst,numIters,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32s_Direct(pSrcDst:PIpp16s;numIters:longint;pTaps:PIpp32s;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16s;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32s_Direct_16s_ISfs(pSrcDst,numIters,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIRMR32sc_Direct(pSrcDst:PIpp16sc;numIters:longint;pTaps:PIpp32sc;tapsLen:longint;tapsFactor:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pDlyLine:PIpp16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIRMR32sc_Direct_16sc_ISfs(pSrcDst,numIters,pTaps,tapsLen,tapsFactor,upFactor,upPhase,downFactor,downPhase,pDlyLine,scaleFactor);
end;

function ippsFIR_Direct(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR_Direct_16s_Sfs(pSrc,pDst,numIters,pTapsQ15,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIR_Direct(pSrcDst:PIpp16s;numIters:longint;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIR_Direct_16s_ISfs(pSrcDst,numIters,pTapsQ15,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne_Direct(src:Ipp16s;pDstVal:PIpp16s;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne_Direct_16s_Sfs(src,pDstVal,pTapsQ15,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIROne_Direct(pSrcDstVal:PIpp16s;pTapsQ15:PIpp16s;tapsLen:longint;pDlyLine:PIpp16s;pDlyLineIndex:Plongint;scaleFactor:longint):IppStatus;
begin
  result:=ippsFIROne_Direct_16s_ISfs(pSrcDstVal,pTapsQ15,tapsLen,pDlyLine,pDlyLineIndex,scaleFactor);
end;

function ippsFIRGenLowpass(rfreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;
begin
  result:=ippsFIRGenLowpass_64f(rfreq,taps,tapsLen,winType,doNormal);
end;

function ippsFIRGenHighpass(rfreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;
begin
  result:=ippsFIRGenHighpass_64f(rfreq,taps,tapsLen,winType,doNormal);
end;

function ippsFIRGenBandpass(rLowFreq:Ipp64f;rHighFreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;
begin
  result:=ippsFIRGenBandpass_64f(rLowFreq,rHighFreq,taps,tapsLen,winType,doNormal);
end;

function ippsFIRGenBandstop(rLowFreq:Ipp64f;rHighFreq:Ipp64f;taps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool):IppStatus;
begin
  result:=ippsFIRGenBandstop_64f(rLowFreq,rHighFreq,taps,tapsLen,winType,doNormal);
end;

function ippsWinBartlett(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_16s_I(pSrcDst,len);
end;

function ippsWinBartlett(pSrcDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_16sc_I(pSrcDst,len);
end;

function ippsWinBartlett(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_32f_I(pSrcDst,len);
end;

function ippsWinBartlett(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_32fc_I(pSrcDst,len);
end;

function ippsWinBartlett(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_16s(pSrc,pDst,len);
end;

function ippsWinBartlett(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_16sc(pSrc,pDst,len);
end;

function ippsWinBartlett(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_32f(pSrc,pDst,len);
end;

function ippsWinBartlett(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_32fc(pSrc,pDst,len);
end;

function ippsWinBartlett(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_64f(pSrc,pDst,len);
end;

function ippsWinBartlett(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_64fc(pSrc,pDst,len);
end;

function ippsWinBartlett(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_64f_I(pSrcDst,len);
end;

function ippsWinBartlett(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinBartlett_64fc_I(pSrcDst,len);
end;

function ippsWinHann(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinHann_16s_I(pSrcDst,len);
end;

function ippsWinHann(pSrcDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinHann_16sc_I(pSrcDst,len);
end;

function ippsWinHann(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinHann_32f_I(pSrcDst,len);
end;

function ippsWinHann(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinHann_32fc_I(pSrcDst,len);
end;

function ippsWinHann(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinHann_16s(pSrc,pDst,len);
end;

function ippsWinHann(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinHann_16sc(pSrc,pDst,len);
end;

function ippsWinHann(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinHann_32f(pSrc,pDst,len);
end;

function ippsWinHann(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinHann_32fc(pSrc,pDst,len);
end;

function ippsWinHann(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinHann_64f_I(pSrcDst,len);
end;

function ippsWinHann(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinHann_64fc_I(pSrcDst,len);
end;

function ippsWinHann(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinHann_64f(pSrc,pDst,len);
end;

function ippsWinHann(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinHann_64fc(pSrc,pDst,len);
end;

function ippsWinHamming(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinHamming_16s_I(pSrcDst,len);
end;

function ippsWinHamming(pSrcDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinHamming_16sc_I(pSrcDst,len);
end;

function ippsWinHamming(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinHamming_32f_I(pSrcDst,len);
end;

function ippsWinHamming(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinHamming_32fc_I(pSrcDst,len);
end;

function ippsWinHamming(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinHamming_16s(pSrc,pDst,len);
end;

function ippsWinHamming(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinHamming_16sc(pSrc,pDst,len);
end;

function ippsWinHamming(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinHamming_32f(pSrc,pDst,len);
end;

function ippsWinHamming(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinHamming_32fc(pSrc,pDst,len);
end;

function ippsWinHamming(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinHamming_64f(pSrc,pDst,len);
end;

function ippsWinHamming(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinHamming_64fc(pSrc,pDst,len);
end;

function ippsWinHamming(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinHamming_64f_I(pSrcDst,len);
end;

function ippsWinHamming(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinHamming_64fc_I(pSrcDst,len);
end;

function ippsWinBlackmanQ15(pSrcDst:PIpp16s;len:longint;alphaQ15:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsWinBlackmanQ15_16s_ISfs(pSrcDst,len,alphaQ15,scaleFactor);
end;

function ippsWinBlackmanQ15(pSrcDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinBlackmanQ15_16s_I(pSrcDst,len,alphaQ15);
end;

function ippsWinBlackmanQ15(pSrcDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinBlackmanQ15_16sc_I(pSrcDst,len,alphaQ15);
end;

function ippsWinBlackman(pSrcDst:PIpp16s;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_16s_I(pSrcDst,len,alpha);
end;

function ippsWinBlackman(pSrcDst:PIpp16sc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_16sc_I(pSrcDst,len,alpha);
end;

function ippsWinBlackman(pSrcDst:PIpp32f;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_32f_I(pSrcDst,len,alpha);
end;

function ippsWinBlackman(pSrcDst:PIpp32fc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_32fc_I(pSrcDst,len,alpha);
end;

function ippsWinBlackmanQ15(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinBlackmanQ15_16s(pSrc,pDst,len,alphaQ15);
end;

function ippsWinBlackmanQ15(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinBlackmanQ15_16sc(pSrc,pDst,len,alphaQ15);
end;

function ippsWinBlackman(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_16s(pSrc,pDst,len,alpha);
end;

function ippsWinBlackman(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_16sc(pSrc,pDst,len,alpha);
end;

function ippsWinBlackman(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_32f(pSrc,pDst,len,alpha);
end;

function ippsWinBlackman(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinBlackman_32fc(pSrc,pDst,len,alpha);
end;

function ippsWinBlackmanStd(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_16s_I(pSrcDst,len);
end;

function ippsWinBlackmanStd(pSrcDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_16sc_I(pSrcDst,len);
end;

function ippsWinBlackmanStd(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_32f_I(pSrcDst,len);
end;

function ippsWinBlackmanStd(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_32fc_I(pSrcDst,len);
end;

function ippsWinBlackmanOpt(pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_16s_I(pSrcDst,len);
end;

function ippsWinBlackmanOpt(pSrcDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_16sc_I(pSrcDst,len);
end;

function ippsWinBlackmanOpt(pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_32f_I(pSrcDst,len);
end;

function ippsWinBlackmanOpt(pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_32fc_I(pSrcDst,len);
end;

function ippsWinBlackmanStd(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_16s(pSrc,pDst,len);
end;

function ippsWinBlackmanStd(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_16sc(pSrc,pDst,len);
end;

function ippsWinBlackmanStd(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_32f(pSrc,pDst,len);
end;

function ippsWinBlackmanStd(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_32fc(pSrc,pDst,len);
end;

function ippsWinBlackmanOpt(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_16s(pSrc,pDst,len);
end;

function ippsWinBlackmanOpt(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_16sc(pSrc,pDst,len);
end;

function ippsWinBlackmanOpt(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_32f(pSrc,pDst,len);
end;

function ippsWinBlackmanOpt(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_32fc(pSrc,pDst,len);
end;

function ippsWinBlackman(pSrcDst:PIpp64f;len:longint;alpha:double):IppStatus;
begin
  result:=ippsWinBlackman_64f_I(pSrcDst,len,alpha);
end;

function ippsWinBlackman(pSrcDst:PIpp64fc;len:longint;alpha:double):IppStatus;
begin
  result:=ippsWinBlackman_64fc_I(pSrcDst,len,alpha);
end;

function ippsWinBlackman(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:double):IppStatus;
begin
  result:=ippsWinBlackman_64f(pSrc,pDst,len,alpha);
end;

function ippsWinBlackman(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:double):IppStatus;
begin
  result:=ippsWinBlackman_64fc(pSrc,pDst,len,alpha);
end;

function ippsWinBlackmanStd(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_64f_I(pSrcDst,len);
end;

function ippsWinBlackmanStd(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_64fc_I(pSrcDst,len);
end;

function ippsWinBlackmanStd(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_64f(pSrc,pDst,len);
end;

function ippsWinBlackmanStd(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanStd_64fc(pSrc,pDst,len);
end;

function ippsWinBlackmanOpt(pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_64f_I(pSrcDst,len);
end;

function ippsWinBlackmanOpt(pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_64fc_I(pSrcDst,len);
end;

function ippsWinBlackmanOpt(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_64f(pSrc,pDst,len);
end;

function ippsWinBlackmanOpt(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsWinBlackmanOpt_64fc(pSrc,pDst,len);
end;

function ippsWinKaiser(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_16s(pSrc,pDst,len,alpha);
end;

function ippsWinKaiser(pSrcDst:PIpp16s;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_16s_I(pSrcDst,len,alpha);
end;

function ippsWinKaiserQ15(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinKaiserQ15_16s(pSrc,pDst,len,alphaQ15);
end;

function ippsWinKaiserQ15(pSrcDst:PIpp16s;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinKaiserQ15_16s_I(pSrcDst,len,alphaQ15);
end;

function ippsWinKaiser(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_16sc(pSrc,pDst,len,alpha);
end;

function ippsWinKaiser(pSrcDst:PIpp16sc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_16sc_I(pSrcDst,len,alpha);
end;

function ippsWinKaiserQ15(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinKaiserQ15_16sc(pSrc,pDst,len,alphaQ15);
end;

function ippsWinKaiserQ15(pSrcDst:PIpp16sc;len:longint;alphaQ15:longint):IppStatus;
begin
  result:=ippsWinKaiserQ15_16sc_I(pSrcDst,len,alphaQ15);
end;

function ippsWinKaiser(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_32f(pSrc,pDst,len,alpha);
end;

function ippsWinKaiser(pSrcDst:PIpp32f;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_32f_I(pSrcDst,len,alpha);
end;

function ippsWinKaiser(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_32fc(pSrc,pDst,len,alpha);
end;

function ippsWinKaiser(pSrcDst:PIpp32fc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_32fc_I(pSrcDst,len,alpha);
end;

function ippsWinKaiser(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_64f(pSrc,pDst,len,alpha);
end;

function ippsWinKaiser(pSrcDst:PIpp64f;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_64f_I(pSrcDst,len,alpha);
end;

function ippsWinKaiser(pSrcDst:PIpp64fc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_64fc_I(pSrcDst,len,alpha);
end;

function ippsWinKaiser(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:single):IppStatus;
begin
  result:=ippsWinKaiser_64fc(pSrc,pDst,len,alpha);
end;

function ippsFilterMedian(pSrcDst:PIpp32f;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_32f_I(pSrcDst,len,maskSize);
end;

function ippsFilterMedian(pSrcDst:PIpp64f;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_64f_I(pSrcDst,len,maskSize);
end;

function ippsFilterMedian(pSrcDst:PIpp16s;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_16s_I(pSrcDst,len,maskSize);
end;

function ippsFilterMedian(pSrcDst:PIpp8u;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_8u_I(pSrcDst,len,maskSize);
end;

function ippsFilterMedian(pSrc:PIpp32f;pDst:PIpp32f;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_32f(pSrc,pDst,len,maskSize);
end;

function ippsFilterMedian(pSrc:PIpp64f;pDst:PIpp64f;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_64f(pSrc,pDst,len,maskSize);
end;

function ippsFilterMedian(pSrc:PIpp16s;pDst:PIpp16s;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_16s(pSrc,pDst,len,maskSize);
end;

function ippsFilterMedian(pSrc:PIpp8u;pDst:PIpp8u;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_8u(pSrc,pDst,len,maskSize);
end;

function ippsFilterMedian(pSrcDst:PIpp32s;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_32s_I(pSrcDst,len,maskSize);
end;

function ippsFilterMedian(pSrc:PIpp32s;pDst:PIpp32s;len:longint;maskSize:longint):IppStatus;
begin
  result:=ippsFilterMedian_32s(pSrc,pDst,len,maskSize);
end;

function ippsNorm_Inf(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_Inf_16s32f(pSrc,len,pNorm);
end;

function ippsNorm_Inf(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsNorm_Inf_16s32s_Sfs(pSrc,len,pNorm,scaleFactor);
end;

function ippsNorm_Inf(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_Inf_32f(pSrc,len,pNorm);
end;

function ippsNorm_Inf(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_Inf_64f(pSrc,len,pNorm);
end;

function ippsNorm_L1(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_L1_16s32f(pSrc,len,pNorm);
end;

function ippsNorm_L1(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsNorm_L1_16s32s_Sfs(pSrc,len,pNorm,scaleFactor);
end;

function ippsNorm_L1(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_L1_32f(pSrc,len,pNorm);
end;

function ippsNorm_L1(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_L1_64f(pSrc,len,pNorm);
end;

function ippsNorm_L2(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_L2_16s32f(pSrc,len,pNorm);
end;

function ippsNorm_L2(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsNorm_L2_16s32s_Sfs(pSrc,len,pNorm,scaleFactor);
end;

function ippsNorm_L2(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_L2_32f(pSrc,len,pNorm);
end;

function ippsNorm_L2(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_L2_64f(pSrc,len,pNorm);
end;

function ippsNormDiff_Inf(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_Inf_16s32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_Inf(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsNormDiff_Inf_16s32s_Sfs(pSrc1,pSrc2,len,pNorm,scaleFactor);
end;

function ippsNormDiff_Inf(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_Inf_32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_Inf(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_Inf_64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L1(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_L1_16s32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L1(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsNormDiff_L1_16s32s_Sfs(pSrc1,pSrc2,len,pNorm,scaleFactor);
end;

function ippsNormDiff_L1(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_L1_32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L1(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_L1_64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L2(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_L2_16s32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L2(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;
begin
  result:=ippsNormDiff_L2_16s32s_Sfs(pSrc1,pSrc2,len,pNorm,scaleFactor);
end;

function ippsNormDiff_L2(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_L2_32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L2(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_L2_64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNorm_Inf(pSrc:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNorm_Inf_32fc32f(pSrc,len,pNorm);
end;

function ippsNorm_L1(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_L1_32fc64f(pSrc,len,pNorm);
end;

function ippsNorm_L2(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_L2_32fc64f(pSrc,len,pNorm);
end;

function ippsNormDiff_Inf(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;
begin
  result:=ippsNormDiff_Inf_32fc32f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L1(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_L1_32fc64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L2(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_L2_32fc64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNorm_Inf(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_Inf_64fc64f(pSrc,len,pNorm);
end;

function ippsNorm_L1(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_L1_64fc64f(pSrc,len,pNorm);
end;

function ippsNorm_L2(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNorm_L2_64fc64f(pSrc,len,pNorm);
end;

function ippsNormDiff_Inf(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_Inf_64fc64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L1(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_L1_64fc64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsNormDiff_L2(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;
begin
  result:=ippsNormDiff_L2_64fc64f(pSrc1,pSrc2,len,pNorm);
end;

function ippsCrossCorr(pSrc1:PIpp32f;len1:longint;pSrc2:PIpp32f;len2:longint;pDst:PIpp32f;dstLen:longint;lowLag:longint):IppStatus;
begin
  result:=ippsCrossCorr_32f(pSrc1,len1,pSrc2,len2,pDst,dstLen,lowLag);
end;

function ippsCrossCorr(pSrc1:PIpp64f;len1:longint;pSrc2:PIpp64f;len2:longint;pDst:PIpp64f;dstLen:longint;lowLag:longint):IppStatus;
begin
  result:=ippsCrossCorr_64f(pSrc1,len1,pSrc2,len2,pDst,dstLen,lowLag);
end;

function ippsCrossCorr(pSrc1:PIpp32fc;len1:longint;pSrc2:PIpp32fc;len2:longint;pDst:PIpp32fc;dstLen:longint;lowLag:longint):IppStatus;
begin
  result:=ippsCrossCorr_32fc(pSrc1,len1,pSrc2,len2,pDst,dstLen,lowLag);
end;

function ippsCrossCorr(pSrc1:PIpp64fc;len1:longint;pSrc2:PIpp64fc;len2:longint;pDst:PIpp64fc;dstLen:longint;lowLag:longint):IppStatus;
begin
  result:=ippsCrossCorr_64fc(pSrc1,len1,pSrc2,len2,pDst,dstLen,lowLag);
end;

function ippsCrossCorr(pSrc1:PIpp16s;len1:longint;pSrc2:PIpp16s;len2:longint;pDst:PIpp16s;dstLen:longint;lowLag:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsCrossCorr_16s_Sfs(pSrc1,len1,pSrc2,len2,pDst,dstLen,lowLag,scaleFactor);
end;

function ippsAutoCorr(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_32f(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormA(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormA_32f(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormB(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormB_32f(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_64f(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormA(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormA_64f(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormB(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormB_64f(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_32fc(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormA(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormA_32fc(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormB(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormB_32fc(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_64fc(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormA(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormA_64fc(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr_NormB(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormB_64fc(pSrc,srcLen,pDst,dstLen);
end;

function ippsAutoCorr(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAutoCorr_16s_Sfs(pSrc,srcLen,pDst,dstLen,scaleFactor);
end;

function ippsAutoCorr_NormA(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormA_16s_Sfs(pSrc,srcLen,pDst,dstLen,scaleFactor);
end;

function ippsAutoCorr_NormB(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAutoCorr_NormB_16s_Sfs(pSrc,srcLen,pDst,dstLen,scaleFactor);
end;

function ippsSampleUp(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleUp_32f(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleUp(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleUp_32fc(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleUp(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleUp_64f(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleUp(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleUp_64fc(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleUp(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleUp_16s(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleUp(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleUp_16sc(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleDown(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleDown_32f(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleDown(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleDown_32fc(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleDown(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleDown_64f(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleDown(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleDown_64fc(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleDown(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleDown_16s(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsSampleDown(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;dstLen:Plongint;factor:longint;phase:Plongint):IppStatus;
begin
  result:=ippsSampleDown_16sc(pSrc,srcLen,pDst,dstLen,factor,phase);
end;

function ippsGetVarPointDV(pSrc:PIpp16sc;pDst:PIpp16sc;pVariantPoint:PIpp16sc;pLabel:PIpp8u;state:longint):IppStatus;
begin
  result:=ippsGetVarPointDV_16sc(pSrc,pDst,pVariantPoint,pLabel,state);
end;

function ippsCalcStatesDV(pathError:PIpp16u;pNextState:PIpp8u;pBranchError:PIpp16u;pCurrentSubsetPoint:PIpp16s;pPathTable:PIpp16s;state:longint;presentIndex:longint):IppStatus;
begin
  result:=ippsCalcStatesDV_16sc(pathError,pNextState,pBranchError,pCurrentSubsetPoint,pPathTable,state,presentIndex);
end;

function ippsBuildSymblTableDV4D(pVariantPoint:PIpp16sc;pCurrentSubsetPoint:PIpp16sc;state:longint;bitInversion:longint):IppStatus;
begin
  result:=ippsBuildSymblTableDV4D_16sc(pVariantPoint,pCurrentSubsetPoint,state,bitInversion);
end;

function ippsUpdatePathMetricsDV(pBranchError:PIpp16u;pMinPathError:PIpp16u;pMinSost:PIpp8u;pPathError:PIpp16u;state:longint):IppStatus;
begin
  result:=ippsUpdatePathMetricsDV_16u(pBranchError,pMinPathError,pMinSost,pPathError,state);
end;

function ippsHilbertInitAlloc(var pSpec:PIppsHilbertSpec_32f32fc;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsHilbertInitAlloc_32f32fc(pSpec,length,hint);
end;

function ippsHilbertInitAlloc(var pSpec:PIppsHilbertSpec_16s32fc;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsHilbertInitAlloc_16s32fc(pSpec,length,hint);
end;

function ippsHilbertInitAlloc(var pSpec:PIppsHilbertSpec_16s16sc;length:longint;hint:IppHintAlgorithm):IppStatus;
begin
  result:=ippsHilbertInitAlloc_16s16sc(pSpec,length,hint);
end;

function ippsHilbertFree(pSpec:PIppsHilbertSpec_32f32fc):IppStatus;
begin
  result:=ippsHilbertFree_32f32fc(pSpec);
end;

function ippsHilbertFree(pSpec:PIppsHilbertSpec_16s32fc):IppStatus;
begin
  result:=ippsHilbertFree_16s32fc(pSpec);
end;

function ippsHilbertFree(pSpec:PIppsHilbertSpec_16s16sc):IppStatus;
begin
  result:=ippsHilbertFree_16s16sc(pSpec);
end;

function ippsHilbert(pSrc:PIpp32f;pDst:PIpp32fc;pSpec:PIppsHilbertSpec_32f32fc):IppStatus;
begin
  result:=ippsHilbert_32f32fc(pSrc,pDst,pSpec);
end;

function ippsHilbert(pSrc:PIpp16s;pDst:PIpp32fc;pSpec:PIppsHilbertSpec_16s32fc):IppStatus;
begin
  result:=ippsHilbert_16s32fc(pSrc,pDst,pSpec);
end;

function ippsHilbert(pSrc:PIpp16s;pDst:PIpp16sc;pSpec:PIppsHilbertSpec_16s16sc;scaleFactor:longint):IppStatus;
begin
  result:=ippsHilbert_16s16sc_Sfs(pSrc,pDst,pSpec,scaleFactor);
end;

end.
