Unit ipps17;

INTERFACE

uses windows, math,util1,ippdefs17;



var
  ippsBuffer1: pointer;
  ippsBufferSize1: integer;

procedure IPPStest;
procedure IPPSend;
function InitIPPS:boolean;
procedure freeIPPS;


procedure UpdateIppsBuffer1(size:integer);
procedure resetIppsBuffer1;


(*
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
*)

(*
//              Intel(R) Integrated Performance Primitives (Intel(R) IPP)
//              Signal Processing (ippSP)
//
//
*)

(*   #if !defined( __IPPS_H__ ) || defined( _OWN_BLDPCS )
#define __IPPS_H__

(*   #ifndef __IPPDEFS_H__
#include "ippdefs.h"
#endif  *)

//#include "ipps_l.h"

(*   #ifdef __cplusplus
extern "C" {
#endif  *)

//(*   #if !defined( _IPP_NO_DEFAULT_LIB )
(*   #if defined( _IPP_SEQUENTIAL_DYNAMIC )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ipps" )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippcore" )
#elif defined( _IPP_SEQUENTIAL_STATIC )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippsmt" )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippvmmt" )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippcoremt" )
#elif defined( _IPP_PARALLEL_DYNAMIC )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ipps" )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippcore" )
#elif defined( _IPP_PARALLEL_STATIC )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippsmt" )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippvmmt" )
#pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippcoremt" )
#endif  *)
//#endif  *)

var
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsGetLibVersion
//  Purpose:    Get library version
//  Parameters:
//  Returns:    pointer to structure describing version of ipps library
//      typedef struct {
//         int    major;                      e.g. 1
//         int    minor;                      e.g. 2
//         int    majorBuild;                 e.g. 3
//         int    build;                      e.g. 10, always >= majorBuild
//         char  targetCpu[4];                corresponding to Intel(R) processor
//         const char* Name;                  e.g. "ippsw7"
//         const char* Version;               e.g. "v1.2 Beta"
//         const char* BuildDate;             e.g. "Jul 20 99"
//      } IppLibraryVersion;
//
//  Notes:      don't free pointer!
*)
  ippsGetLibVersion: function:PIppLibraryVersion; stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                   Functions to allocate and free memory
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMalloc
//  Purpose:    Aligned memory allocation (alignment depends on
//              CPU-architecture, 64-byte (cache line size) in most cases)
//  Parameter:
//    len       Number of elements (according to their type)
//  Returns:    Pointer to allocated memory, NULL in case of failure or len < 1
//
//  Notes:      Memory allocated by ippsMalloc must be freed by ippsFree
//              function only.
*)
  ippsMalloc:   function(len:longint): pointer;stdcall;  // Ajout GS : identique à ippsMalloc_8u

  ippsMalloc_8u: function(len:longint):PIpp8u;  stdcall;
  ippsMalloc_16u: function(len:longint):PIpp16u;stdcall;
  ippsMalloc_32u: function(len:longint):PIpp32u;stdcall;
  ippsMalloc_8s: function(len:longint):PIpp8s;  stdcall;
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
//  Purpose:    Free memory allocated by ippsMalloc function
//  Parameter:
//    ptr       Pointer to memory allocated by ippsMalloc function
//
//  Notes:      Use this function to free memory allocated by ippsMalloc_* only
*)
  ippsFree: procedure(ptr:pointer);stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                   Vector Initialization functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCopy
//  Purpose:    Copy data from source to destination vector
//  Parameters:
//    pSrc        Pointer to input vector
//    pDst        Pointer to output vector
//    len         Length of vectors in elements
//  Returns:
//    ippStsNullPtrErr        One of the pointers is NULL
//    ippStsSizeErr           Vector length is less than 1
//    ippStsNoErr             Otherwise
*)
  ippsCopy_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsCopy_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsCopy_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsCopy_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCopy_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsCopy_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsCopy_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsCopy_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsCopy_32sc: function(pSrc:PIpp32sc;pDst:PIpp32sc;len:longint):IppStatus;stdcall;
  ippsCopy_64s: function(pSrc:PIpp64s;pDst:PIpp64s;len:longint):IppStatus;stdcall;
  ippsCopy_64sc: function(pSrc:PIpp64sc;pDst:PIpp64sc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCopyLE_1u
//              ippsCopyBE_1u
//  Purpose:    Copy bits data from source to destination vector
//  Parameters:
//    pSrc          Pointer to input vector
//    srcBitOffset  Bit offset in the first byte of source vector
//    pDst          Pointer to output vector
//    dstBitOffset  Bit offset in the first byte of destination vector
//    len           Vectors' length in bits
//  Return:
//    ippStsNullPtrErr        One of the pointers is NULL
//    ippStsSizeErr           Vectors' length is less than 1
//    ippStsNoErr             otherwise
*)
  ippsCopyLE_1u: function(pSrc:PIpp8u;srcBitOffset:longint;pDst:PIpp8u;dstBitOffset:longint;len:longint):IppStatus;stdcall;
  ippsCopyBE_1u: function(pSrc:PIpp8u;srcBitOffset:longint;pDst:PIpp8u;dstBitOffset:longint;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsMove
//  Purpose:    ippsMove function copies "len" elements from src to dst.
//              If some regions of source and destination areas overlap,
//              ippsMove ensures that original source bytes in overlapping
//              region are copied before being overwritten.
//
//  Parameters:
//    pSrc        Pointer to input vector
//    pDst        Pointer to output vector
//    len         Vectors' length in elements
//  Return:
//    ippStsNullPtrErr        One of pointers is NULL
//    ippStsSizeErr           Vectors' length is less than 1
//    ippStsNoErr             Otherwise
*)
  ippsMove_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsMove_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMove_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsMove_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMove_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMove_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMove_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMove_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsMove_32sc: function(pSrc:PIpp32sc;pDst:PIpp32sc;len:longint):IppStatus;stdcall;
  ippsMove_64s: function(pSrc:PIpp64s;pDst:PIpp64s;len:longint):IppStatus;stdcall;
  ippsMove_64sc: function(pSrc:PIpp64sc;pDst:PIpp64sc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSet
//  Purpose:    Set elements of destination vector to defined value
//  Parameters:
//    val        Value to set for all vector's elements
//    pDst       Pointer to destination vector
//    len        Vectors' length
//  Return:
//    ippStsNullPtrErr        Pointer to vector is NULL
//    ippStsSizeErr           Vector length is less than 1
//    ippStsNoErr             Otherwise
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

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsZero
//  Purpose:    Reset all vector elements
//  Parameters:
//    pDst       Pointer to destination vector
//    len        Vector length
//  Return:
//    ippStsNullPtrErr        Pointer to vector is NULL
//    ippStsSizeErr           Vector length is less than 1
//    ippStsNoErr             Otherwise
*)
  ippsZero_8u: function(pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsZero_16s: function(pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsZero_16sc: function(pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsZero_32f: function(pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsZero_32fc: function(pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsZero_64f: function(pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsZero_64fc: function(pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsZero_32s: function(pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsZero_32sc: function(pDst:PIpp32sc;len:longint):IppStatus;stdcall;
  ippsZero_64s: function(pDst:PIpp64s;len:longint):IppStatus;stdcall;
  ippsZero_64sc: function(pDst:PIpp64sc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsTone
//  Purpose:        Generates tone with given frequency, phase and magnitude
//  Parameters:
//    pDst        - Pointer to destination vector
//    len         - Vector length
//    magn        - Magnitude of tone (maximum value attained by wave)
//    rFreq       - Frequency of tone relative to sampling frequency
//                  It must be in range [0.0, 0.5) for real, and [0.0, 1.0) for complex tone
//    pPhase      - Phase of tone relative to cosinewave. It must be in range [0.0, 2*PI)
//    hint        - Fast or accurate algorithm
//  Returns:
//    ippStsNullPtrErr   - One of pointers is NULL
//    ippStsSizeErr      - Vector length is less than 1
//    ippStsToneMagnErr  - magn value is less than or equal to zero.
//    ippStsToneFreqErr  - rFreq is less than 0 or greater than or equal to 0.5 for real tone and 1.0 for complex tone.
//    ippStsTonePhaseErr - phase is less than 0 or greater or equal 2*PI.
//    ippStsNoErr        - No error
//  Notes:
//    for real:  pDst[i] = magn * cos(IPP_2PI * rfreq * i + phase);
//    for cplx:  pDst[i].re = magn * cos(IPP_2PI * rfreq * i + phase);
//               pDst[i].im = magn * sin(IPP_2PI * rfreq * i + phase);
*)
  ippsTone_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:Ipp32f;pPhase:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_16sc: function(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:Ipp32f;pPhase:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_32f: function(pDst:PIpp32f;len:longint;magn:Ipp32f;rFreq:Ipp32f;pPhase:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_32fc: function(pDst:PIpp32fc;len:longint;magn:Ipp32f;rFreq:Ipp32f;pPhase:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_64f: function(pDst:PIpp64f;len:longint;magn:Ipp64f;rFreq:Ipp64f;pPhase:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsTone_64fc: function(pDst:PIpp64fc;len:longint;magn:Ipp64f;rFreq:Ipp64f;pPhase:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsTriangle
//  Purpose:        Generate triangle with given frequency, phase and magnitude
//  Parameters:
//    pDst        - Pointer to destination vector
//    len         - Vector length
//    magn        - Magnitude of Triangle
//    rFreq       - Frequency of Triangle relative to sampling frequency (must be in range [0.0, 0.5))
//    pPhase      - Pointer to phase of Triangle relative to acosinewave (must be in range [0.0, 2*PI))
//                  Returned value can be used to compute the next continuous data block
//    asym        - Asymmetry of Triangle (must be in range [-PI,PI))
//  Returns:
//    ippStsNullPtrErr    - Any of specified pointers is NULL
//    ippStsSizeErr       - Vector length is less than 1
//    ippStsTrnglMagnErr  - magn value is less or equal to zero
//    ippStsTrnglFreqErr  - rFreq value is out of range [0, 0.5)
//    ippStsTrnglPhaseErr - phase value is out of range [0, 2*PI)
//    ippStsTrnglAsymErr  - asym value is out of range [-PI, PI)
//    ippStsNoErr         - No error
*)
  ippsTriangle_64f: function(pDst:PIpp64f;len:longint;magn:Ipp64f;rFreq:Ipp64f;asym:Ipp64f;pPhase:PIpp64f):IppStatus;stdcall;
  ippsTriangle_64fc: function(pDst:PIpp64fc;len:longint;magn:Ipp64f;rFreq:Ipp64f;asym:Ipp64f;pPhase:PIpp64f):IppStatus;stdcall;
  ippsTriangle_32f: function(pDst:PIpp32f;len:longint;magn:Ipp32f;rFreq:Ipp32f;asym:Ipp32f;pPhase:PIpp32f):IppStatus;stdcall;
  ippsTriangle_32fc: function(pDst:PIpp32fc;len:longint;magn:Ipp32f;rFreq:Ipp32f;asym:Ipp32f;pPhase:PIpp32f):IppStatus;stdcall;
  ippsTriangle_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s;rFreq:Ipp32f;asym:Ipp32f;pPhase:PIpp32f):IppStatus;stdcall;
  ippsTriangle_16sc: function(pDst:PIpp16sc;len:longint;magn:Ipp16s;rFreq:Ipp32f;asym:Ipp32f;pPhase:PIpp32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
// Name:            ippsRandUniform
// Purpose:         Initialize vector with uniformly distributed values
// Parameters:
//    pDst          Pointer to vector
//    len           Vector length
//    pRandUniState Pointer to RandUniState structure
// Returns:
//    ippStsNullPtrErr       One of pointers is NULL
//    ippStsContextMatchErr  State structure has invalid content 
//    ippStsNoErr            No errors
*)
  ippsRandUniform_8u: function(pDst:PIpp8u;len:longint;pRandUniState:PIppsRandUniState_8u):IppStatus;stdcall;
  ippsRandUniform_16s: function(pDst:PIpp16s;len:longint;pRandUniState:PIppsRandUniState_16s):IppStatus;stdcall;
  ippsRandUniform_32f: function(pDst:PIpp32f;len:longint;pRandUniState:PIppsRandUniState_32f):IppStatus;stdcall;
  ippsRandUniform_64f: function(pDst:PIpp64f;len:longint;pRandUniState:PIppsRandUniState_64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
// Name:            ippsRandGauss
// Purpose:         Makes pseudo-random samples with a normal distribution
//                  and places them in the vector.
// Parameters:
//    pDst          The pointer to vector
//    len           Vector's length
//    pRandUniState A pointer to the structure containing parameters
//                  for the generator of noise
// Returns:
//    ippStsNullPtrErr       Pointer to the state structure is NULL
//    ippStsContextMatchErr  State structure has invalid content 
//    ippStsSizeErr          Vector length is less than 1
//    ippStsNoErr            No errors
*)
  ippsRandGauss_8u: function(pDst:PIpp8u;len:longint;pRandGaussState:PIppsRandGaussState_8u):IppStatus;stdcall;
  ippsRandGauss_16s: function(pDst:PIpp16s;len:longint;pRandGaussState:PIppsRandGaussState_16s):IppStatus;stdcall;
  ippsRandGauss_32f: function(pDst:PIpp32f;len:longint;pRandGaussState:PIppsRandGaussState_32f):IppStatus;stdcall;
  ippsRandGauss_64f: function(pDst:PIpp64f;len:longint;pRandGaussState:PIppsRandGaussState_64f):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRandGaussGetSize
//
//  Purpose:    Calculate size of memory buffer required for RandGaussState
//              structure
//  Arguments:
//    pRandGaussStateSize      Pointer where to store computed size of 
//                             memory buffer required for RandGaussState
//  Return:
//    ippStsNullPtrErr         Pointer is NULL
//    ippStsNoErr              No errors
*)
  ippsRandGaussGetSize_8u: function(pRandGaussStateSize:Plongint):IppStatus;stdcall;
  ippsRandGaussGetSize_16s: function(pRandGaussStateSize:Plongint):IppStatus;stdcall;
  ippsRandGaussGetSize_32f: function(pRandGaussStateSize:Plongint):IppStatus;stdcall;
  ippsRandGaussGetSize_64f: function(pRandGaussStateSize:Plongint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////
// Name:                ippsRandGaussInit
// Purpose:             Initializes RandGaussState structure
// Parameters:
//    pRandGaussState   Pointer to RandGaussState structure
//    mean              Mean of normal distribution.
//    stdDev            Standard deviation of normal distribution.
//    seed              Initial seed value for pseudo-random number generator
// Returns:
//    ippStsNullPtrErr  Pointer to state structure is NULL
//    ippStsNoErr       No errors
//
*)
  ippsRandGaussInit_8u: function(pRandGaussState:PIppsRandGaussState_8u;mean:Ipp8u;stdDev:Ipp8u;seed:longWord):IppStatus;stdcall;
  ippsRandGaussInit_16s: function(pRandGaussState:PIppsRandGaussState_16s;mean:Ipp16s;stdDev:Ipp16s;seed:longWord):IppStatus;stdcall;
  ippsRandGaussInit_32f: function(pRandGaussState:PIppsRandGaussState_32f;mean:Ipp32f;stdDev:Ipp32f;seed:longWord):IppStatus;stdcall;
  ippsRandGaussInit_64f: function(pRandGaussState:PIppsRandGaussState_64f;mean:Ipp64f;stdDev:Ipp64f;seed:longWord):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRandUniformGetSize
//  Purpose:    Calculates size of memory buffer required for 
//              RandUniformState structure
//  Arguments:
//    pRandUniformStateSize Pointer where to store computed size of 
//                          memory buffer required for RandUniformState
//  Return:
//    ippStsNullPtrErr  Pointer is NULL
//    ippStsNoErr       No errors
*)
  ippsRandUniformGetSize_8u: function(pRandUniformStateSize:Plongint):IppStatus;stdcall;
  ippsRandUniformGetSize_16s: function(pRandUniformStateSize:Plongint):IppStatus;stdcall;
  ippsRandUniformGetSize_32f: function(pRandUniformStateSize:Plongint):IppStatus;stdcall;
  ippsRandUniformGetSize_64f: function(pRandUniformStateSize:Plongint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////
// Name:                ippsRandUniformInit
// Purpose:             Initializes RandUniformState structure
// Parameters:
//    pRandUniState     Pointer to RandUniformState structure
//    low               Lower bound of uniform distribution range
//    high              Upper bounds of uniform distribution range
//    seed              Initial seed value for pseudo-random number generator
// Returns:
//    ippStsNullPtrErr  Pointer is NULL
//    ippStsNoErr       No errors
//
*)
  ippsRandUniformInit_8u: function(pRandUniState:PIppsRandUniState_8u;low:Ipp8u;high:Ipp8u;seed:longWord):IppStatus;stdcall;
  ippsRandUniformInit_16s: function(pRandUniState:PIppsRandUniState_16s;low:Ipp16s;high:Ipp16s;seed:longWord):IppStatus;stdcall;
  ippsRandUniformInit_32f: function(pRandUniState:PIppsRandUniState_32f;low:Ipp32f;high:Ipp32f;seed:longWord):IppStatus;stdcall;
  ippsRandUniformInit_64f: function(pRandUniState:PIppsRandUniState_64f;low:Ipp64f;high:Ipp64f;seed:longWord):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////
//  Name:               ippsVectorJaehne
//  Purpose:            Create Jaehne vector
//
//  Parameters:
//    pDst              Pointer to destination vector
//    len               Length of vector
//    magn              Magnitude of signal
//
//  Return:
//    ippStsNullPtrErr  Pointer is NULL
//    ippStsBadSizeErr  Vector length is less than 1
//    ippStsJaehneErr   Magnitude value is negative
//    ippStsNoErr       No error
//
//  Notes:              pDst[n] = magn*sin(0.5*pi*n^2/len), n=0,1,2,..len-1.
//
*)
  ippsVectorJaehne_8u: function(pDst:PIpp8u;len:longint;magn:Ipp8u):IppStatus;stdcall;
  ippsVectorJaehne_16u: function(pDst:PIpp16u;len:longint;magn:Ipp16u):IppStatus;stdcall;
  ippsVectorJaehne_16s: function(pDst:PIpp16s;len:longint;magn:Ipp16s):IppStatus;stdcall;
  ippsVectorJaehne_32s: function(pDst:PIpp32s;len:longint;magn:Ipp32s):IppStatus;stdcall;
  ippsVectorJaehne_32f: function(pDst:PIpp32f;len:longint;magn:Ipp32f):IppStatus;stdcall;
  ippsVectorJaehne_64f: function(pDst:PIpp64f;len:longint;magn:Ipp64f):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:               ippsVectorSlope
//  Purpose:            Creates ramp vector
//  Parameters:
//    pDst              A pointer to the destination vector
//    len               Vector's length
//    offset            Offset value
//    slope             Slope coefficient
//
//  Return:
//    ippStsNullPtrErr  pDst pointer is NULL
//    ippStsBadSizeErr  Vector's length is less or equal zero
//    ippStsNoErr       No error
//
//  Notes:              Dst[n] = offset + slope * n
//
*)
  ippsVectorSlope_8u: function(pDst:PIpp8u;len:longint;offset:Ipp32f;slope:Ipp32f):IppStatus;stdcall;
  ippsVectorSlope_16u: function(pDst:PIpp16u;len:longint;offset:Ipp32f;slope:Ipp32f):IppStatus;stdcall;
  ippsVectorSlope_16s: function(pDst:PIpp16s;len:longint;offset:Ipp32f;slope:Ipp32f):IppStatus;stdcall;
  ippsVectorSlope_32u: function(pDst:PIpp32u;len:longint;offset:Ipp64f;slope:Ipp64f):IppStatus;stdcall;
  ippsVectorSlope_32s: function(pDst:PIpp32s;len:longint;offset:Ipp64f;slope:Ipp64f):IppStatus;stdcall;
  ippsVectorSlope_32f: function(pDst:PIpp32f;len:longint;offset:Ipp32f;slope:Ipp32f):IppStatus;stdcall;
  ippsVectorSlope_64f: function(pDst:PIpp64f;len:longint;offset:Ipp64f;slope:Ipp64f):IppStatus;stdcall;

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
//   len                vector's length
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
//                  Arithmetic functions
///////////////////////////////////////////////////////////////////////////// *)

(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippsAddC
//  Purpose:    Adds constant value to each element of vector
//  Arguments:
//    pSrc                 Pointer to source vector
//    pSrcDst              Pointer to source and destination vector for in-place operation
//    pDst                 Pointer to destination vector
//    val                  Scalar value used to increment each element of source vector
//    len                  Number of elements in vector
//    scaleFactor          Scale factor
//    rndMode              Rounding mode, following values are possible:
//                         ippRndZero - floating-point values are truncated to zero
//                         ippRndNear - floating-point values are rounded to the nearest even integer
//                         when fractional part equals 0.5; otherwise they are rounded to the nearest integer
//                         ippRndFinancial - floating-point values are rounded down to the nearest
//                         integer when fractional part is less than 0.5, or rounded up to the
//                         nearest integer if the fractional part is equal or greater than 0.5
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vectors' length is less than 1
//    ippStsNoErr          No error
//  Note:
//    AddC(X,v,Y)    :  Y[n] = X[n] + v
*)
  ippsAddC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16s_I: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAddC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16u_ISfs: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_16u_Sfs: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddC_64u_Sfs: function(pSrc:PIpp64u;val:Ipp64u;pDst:PIpp64u;len:Ipp32u;scaleFactor:longint;rndMode:IppRoundMode):IppStatus;stdcall;
  ippsAddC_64s_Sfs: function(pSrc:PIpp64s;val:Ipp64s;pDst:PIpp64s;len:Ipp32u;scaleFactor:longint;rndMode:IppRoundMode):IppStatus;stdcall;
  ippsAddC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAddC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAddC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAddC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAddC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAddC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAddC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsAddC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsAdd
//  Purpose:    Adds elements of two vectors
//  Arguments:
//    pSrc1, pSrc2         Pointers to source vectors
//    pSrc                 Pointer to source vector for in-place operations
//    pSrcDst              Pointer to source and destination vector for in-place operation
//    pDst                 Pointer to destination vector
//    len                  Number of elements in vector
//    scaleFactor          Scale factor
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vectors' length is less than 1
//    ippStsNoErr          No error
//  Note:
//    Add(X,Y)       :  Y[n] = Y[n] + X[n]
//    Add(X,Y,Z)     :  Z[n] = Y[n] + X[n]
*)
  ippsAdd_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_8u16u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAdd_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAdd_16s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAdd_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16s32s_I: function(pSrc:PIpp16s;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsAdd_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAdd_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16u_ISfs: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16u_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsAdd_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32sc_ISfs: function(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32u: function(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsAdd_64s_Sfs: function(pSrc1:PIpp64s;pSrc2:PIpp64s;pDst:PIpp64s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAdd_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAdd_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAdd_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAdd_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAdd_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAdd_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAdd_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsAdd_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsAddProductC
//  Purpose:    multiplies elements of of a vector by a constant and adds product to
//              the accumulator vector
//  Parameters:
//    pSrc                 pointer to the source vector
//    val                  constant value
//    pSrcDst              pointer to the source/destination (accumulator) vector
//    len                  length of the vectors
//  Return:
//    ippStsNullPtrErr     pointer to the vector is NULL
//    ippStsSizeErr        length of the vectors is less or equal zero
//    ippStsNoErr          otherwise
//
//  Notes:                 pSrcDst[n] = pSrcDst[n] + pSrc[n] * val, n=0,1,2,..len-1.
*)
  ippsAddProductC_32f: function(pSrc:PIpp32f;val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsAddProduct
//  Purpose:    multiplies elements of two source vectors and adds product to
//              the accumulator vector
//  Parameters:
//    pSrc1, pSrc2         Pointers to source vectors
//    pSrcDst              Pointer to destination accumulator vector
//    len                  Number of elements in  vectors
//    scaleFactor          scale factor value
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vectors' length is less than 1
//    ippStsNoErr          No error
//  Notes:                 pSrcDst[n] = pSrcDst[n] + pSrc1[n] * pSrc2[n], n=0,1,2,..len-1.
*)
  ippsAddProduct_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddProduct_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddProduct_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsAddProduct_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAddProduct_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsAddProduct_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAddProduct_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippsMulC
//  Purpose:     Multiplies each element of a vector by a constant value 
//  Arguments:
//    pSrc             Pointer to source vector
//    pSrcDst          Pointer to source and destination vector for in-place operation
//    pDst             Pointer to destination vector
//    val              The scalar value used to multiply each element of source vector
//    len              Number of elements in vector
//    scaleFactor      Scale factor
//  Return:
//    ippStsNullPtrErr At least one of the pointers is NULL
//    ippStsSizeErr    Vectors' length is less than 1
//    ippStsNoErr      No error
//  Note:
//    MulC(X,v,Y)    :  Y[n] = X[n] * v
*)
  ippsMulC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16s_I: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMulC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16u_ISfs: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_16u_Sfs: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_64s_ISfs: function(val:Ipp64s;pSrcDst:PIpp64s;len:Ipp32u;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMulC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMulC_32f16s_Sfs: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMulC_Low_32f16s: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMulC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMulC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMulC_64f64s_ISfs: function(val:Ipp64f;pSrcDst:PIpp64s;len:Ipp32u;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsMul
//  Purpose:    Multiplies elements of two vectors
//  Arguments:
//    pSrc1, pSrc2         Pointers to source vectors
//    pSrc                 Pointer to source vector for in-place operations
//    pSrcDst              Pointer to source and destination vector for in-place operation
//    pDst                 Pointer to destination vector
//    len                  Number of elements in vector
//    scaleFactor          Scale factor
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vectors' length is less than 1
//    ippStsNoErr          No error
//  Note:
//    Mul(X,Y)       :  Y[n] = Y[n] * X[n]
//    Mul(X,Y,Z)     :  Z[n] = Y[n] * X[n]
*)
  ippsMul_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_8u16u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsMul_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMul_16s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMul_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMul_16u_ISfs: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16u_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_16u16s_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32sc_ISfs: function(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMul_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMul_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMul_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMul_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMul_32f32fc_I: function(pSrc:PIpp32f;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMul_32f32fc: function(pSrc1:PIpp32f;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsMul_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMul_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMul_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsMul_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippsSubC
//  Purpose:     Subtracts constant value from each element of vector
//  Arguments:
//    pSrc             Pointer to source vector
//    pSrcDst          Pointer to source and destination vector for in-place operation
//    pDst             Pointer to destination vector
//    val              Scalar value used to decrement each element of the source vector
//    len              Number of elements in vector
//    scaleFactor      Scale factor
//  Return:
//    ippStsNullPtrErr At least one of the pointers is NULL
//    ippStsSizeErr    Vectors' length is less than 1
//    ippStsNoErr      No error
//  Note:
//    SubC(X,v,Y)    :  Y[n] = X[n] - v
*)
  ippsSubC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16s_I: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSubC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16u_ISfs: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_16u_Sfs: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSubC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippsSubCRev
//  Purpose:     Subtracts each element of vector from constant value
//  Arguments:
//    pSrc             Pointer to source vector
//    pSrcDst          Pointer to source and destination vector for in-place operation
//    pDst             Pointer to destination vector
//    val              Scalar value from which vector elements are subtracted
//    len              Number of elements in vector
//    scaleFactor      Scale factor
//  Return:
//    ippStsNullPtrErr At least one of the pointers is NULL
//    ippStsSizeErr    Vectors' length is less than 1
//    ippStsNoErr      No error
//  Note:
//    SubCRev(X,v,Y) :  Y[n] = v - X[n]
*)
  ippsSubCRev_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16u_ISfs: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_16u_Sfs: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32s_ISfs: function(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32s_Sfs: function(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32sc_ISfs: function(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32sc_Sfs: function(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSubCRev_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubCRev_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSubCRev_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubCRev_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSubCRev_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSubCRev_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSub
//  Purpose:    Subtracts elements of two vectors
//  Arguments:
//    pSrc1, pSrc2         Pointers to source vectors
//    pSrc                 Pointer to source vector for in-place operations
//    pSrcDst              Pointer to source and destination vector for in-place operation
//    pDst                 Pointer to destination vector
//    len                  Number of elements in vector
//    scaleFactor          Scale factor
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vectors' length is less than 1
//    ippStsNoErr          No error
//  Note:
//    Sub(X,Y)       :  Y[n] = Y[n] - X[n]
//    Sub(X,Y,Z)     :  Z[n] = Y[n] - X[n]
*)
  ippsSub_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSub_16s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSub_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSub_16u_ISfs: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_16u_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32sc_ISfs: function(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32sc_Sfs: function(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSub_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSub_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSub_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSub_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSub_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSub_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSub_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSub_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDivC
//  Purpose:    Divides each element of a vector by a constant value
//  Arguments:
//    val               Scalar value used as a divisor
//    pSrc              Pointer to the source vector
//    pDst              Pointer to the destination vector
//    pSrcDst           Pointer to the source and destination vector for in-place operation
//    len               Number of elements in the vector
//    scaleFactor       Scale factor
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vector length is less than 1
//    ippStsDivByZeroErr   Indicates an error when val is equal to 0
//    ippStsNoErr          No error
//  Note:
//    DivC(v,X,Y)  :    Y[n] = X[n] / v
//    DivC(v,X)    :    X[n] = X[n] / v
*)
  ippsDivC_8u_ISfs: function(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_8u_Sfs: function(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16s_ISfs: function(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16s_Sfs: function(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16sc_ISfs: function(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16sc_Sfs: function(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16u_ISfs: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_16u_Sfs: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_64s_ISfs: function(val:Ipp64s;pSrcDst:PIpp64s;len:Ipp32u;scaleFactor:longint):IppStatus;stdcall;
  ippsDivC_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDivC_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDivC_32fc_I: function(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDivC_32fc: function(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDivC_64f_I: function(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDivC_64f: function(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDivC_64fc_I: function(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsDivC_64fc: function(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDivCRev
//  Purpose:    Divides a constant value by each element of a vector
//  Arguments:
//    val               Constant value used as a dividend in the operation
//    pSrc              Pointer to the source vector whose elements are used as divisors
//    pDst              Pointer to the destination vector
//    pSrcDst           Pointer to the source and destination vector for in-place operation
//    len               Number of elements in the vector
//    scaleFactor       Scale factor
//  Return:
//    ippStsNullPtrErr  At least one of the pointers is NULL
//    ippStsSizeErr     Vector length is less than 1
//    ippStsDivByZero   Warning status if any element of vector is zero. IF the dividend is zero
//                      than result is NaN, if the dividend is not zero than result is Infinity 
//                      with correspondent sign. Execution is not aborted. 
//                      For the integer operation zero instead of NaN and the corresponding 
//                      bound values instead of Infinity
//    ippStsNoErr       No error
//  Note:
//    DivCRev(v,X,Y)  :    Y[n] = v / X[n]
//    DivCRev(v,X)    :    X[n] = v / X[n]
*)
  ippsDivCRev_16u_I: function(val:Ipp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsDivCRev_16u: function(pSrc:PIpp16u;val:Ipp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsDivCRev_32f_I: function(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDivCRev_32f: function(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDiv
//  Purpose:    Divides the elements of two vectors
//  Arguments:
//    pSrc1             Pointer to the divisor vector. 
//    pSrc2             Pointer to the dividend vector. 
//    pDst              Pointer to the destination vector
//    pSrc              Pointer to the divisor vector for in-place operations
//    pSrcDst           Pointer to the source and destination vector for in-place operation
//    len               Number of elements in the vector
//    scaleFactor       Scale factor
//  Return:
//    ippStsNullPtrErr  At least one of the pointers is NULL
//    ippStsSizeErr     Vector length is less than 1
//    ippStsDivByZero   Warning status if any element of vector is zero. IF the dividend is zero
//                      than result is NaN, if the dividend is not zero than result is Infinity 
//                      with correspondent sign. Execution is not aborted. 
//                      For the integer operation zero instead of NaN and the corresponding 
//                      bound values instead of Infinity
//    ippStsNoErr       No error
//  Note:
//    Div(X,Y)     :    Y[n] = Y[n] / X[n]
//    Div(X,Y,Z)   :    Z[n] = Y[n] / X[n]
*)
  ippsDiv_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16sc_ISfs: function(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16sc_Sfs: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_32s_ISfs: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_32s16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp32s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16u_ISfs: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_16u_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDiv_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsDiv_32fc_I: function(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDiv_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsDiv_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDiv_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsDiv_64fc_I: function(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsDiv_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDiv_Round
//  Purpose:    Divides the elements of two vectors with defined rounding
//  Arguments:
//    pSrc1        Pointer to the divisor vector. 
//    pSrc2        Pointer to the dividend vector. 
//    pDst         Pointer to the destination vector
//    pSrc         Pointer to the divisor vector for in-place operations
//    pSrcDst      Pointer to the source and destination vector for in-place operation
//    len          Number of elements in the vector
//    rndMode      Rounding mode, the following values are possible:
//                 ippRndZero- specifies that floating-point values are truncated toward zero,
//                 ippRndNear- specifies that floating-point values are rounded to the
//                             nearest even integer when the fractional part equals 0.5;
//                             otherwise they are rounded to the nearest integer,
//                 ippRndFinancial- specifies that floating-point values are rounded down
//                             to the nearest integer when the fractional part is less than 0.5,
//                             or rounded up to the nearest integer if the fractional part is 
//                             equal or greater than 0.5.
//    scaleFactor       Scale factor
//  Return:
//    ippStsNullPtrErr  At least one of the pointers is NULL
//    ippStsSizeErr     Vector length is less than 1
//    ippStsDivByZero   Warning status if any element of vector is zero. IF the dividend is zero
//                      than result is NaN, if the dividend is not zero than result is Infinity 
//                      with correspondent sign. Execution is not aborted. 
//                      For the integer operation zero instead of NaN and the corresponding 
//                      bound values instead of Infinity
//    ippStsNoErr       No error
//  Note:
//    Div(X,Y)     :    Y[n] = Y[n] / X[n]
//    Div(X,Y,Z)   :    Z[n] = Y[n] / X[n]
*)
  ippsDiv_Round_8u_ISfs: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_Round_8u_Sfs: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_Round_16s_ISfs: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_Round_16s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_Round_16u_ISfs: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsDiv_Round_16u_Sfs: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;

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
  ippsAbs_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAbs_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsAbs_32s_I: function(pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsAbs_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsAbs_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAbs_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsAbs_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsAbs_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSqr
//  Purpose:    Computes square of each element of source vector
//  Parameters:
//    pSrcDst          Pointer to the source and destination vector for in-place operations
//    pSrc             Pointer to the source vector
//    pDst             Pointer to the destination vector
//    len              Number of elements in the vector
//   scaleFactor       Scale factor
//  Return:
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vectors' length is less than 1
//    ippStsNoErr          No error
*)
  ippsSqr_8u_ISfs: function(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_8u_Sfs: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16u_ISfs: function(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_16u_Sfs: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqr_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqr_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqr_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqr_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqr_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqr_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqr_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSqr_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

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
  ippsSqrt_8u_ISfs: function(pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_8u_Sfs: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16u_ISfs: function(pSrcDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_16u_Sfs: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_32s16s_Sfs: function(pSrc:PIpp32s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsSqrt_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqrt_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSqrt_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqrt_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsSqrt_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqrt_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsSqrt_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsSqrt_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsCubrt
//  Purpose:    Compute cube root of every elements of the source vector
//  Parameters:
//   pSrc                 pointer to the source vector
//   pDst                 pointer to the destination vector
//   len                  length of the vector(s)
//   scaleFactor          scale factor value
//  Return:
//   ippStsNullPtrErr        pointer(s) to the data vector is NULL
//   ippStsSizeErr           length of the vector(s) is less or equal 0
//   ippStsNoErr             otherwise
*)
  ippsCubrt_32s16s_Sfs: function(pSrc:PIpp32s;pDst:PIpp16s;Len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsCubrt_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;

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
  ippsExp_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_32s_ISfs: function(pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsExp_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsExp_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsExp_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsExp_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

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
  ippsLn_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsLn_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsLn_32s_ISfs: function(pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsLn_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsLn_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsLn_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsLn_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsLn_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

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


  ippsSumLn_16s32f: function(pSrc:PIpp16s;len:longint;pSum:PIpp32f):IppStatus;stdcall;
  ippsSumLn_32f: function(pSrc:PIpp32f;len:longint;pSum:PIpp32f):IppStatus;stdcall;
  ippsSumLn_32f64f: function(pSrc:PIpp32f;len:longint;pSum:PIpp64f):IppStatus;stdcall;
  ippsSumLn_64f: function(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;stdcall;

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
//  Names:   ippsNormalize
//  Purpose: Normalizes elements of a real or complex vector using offset and division operations
//  Parameters:
//    pSrcDst     - Pointer to the source and destination vector for the in-place operation
//    pSrc        - Pointer to the source vector
//    pDst        - Pointer to the destination vector
//    len         - Number of elements in the vector
//    vSub        - Subtrahend value
//    vDiv        - Denominator value
//    scaleFactor - Scale factor
//  Return:
//    ippStsNoErr          No error
//    ippStsNullPtrErr     At least one of the pointers is NULL
//    ippStsSizeErr        Vector length is less than 1
//    ippStsDivByZeroErr   Indicates an error when vDivis equal to 0 or less than the
//                         minimum floating-point positive number
//  Note:
//      pDst[n] = (pSrc[n] - vSub)/vDiv
*)
  ippsNormalize_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;vSub:Ipp16s;vDiv:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsNormalize_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;vSub:Ipp16s;vDiv:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsNormalize_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;vSub:Ipp16sc;vDiv:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsNormalize_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;vSub:Ipp16sc;vDiv:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsNormalize_32f_I: function(pSrcDst:PIpp32f;len:longint;vSub:Ipp32f;vDiv:Ipp32f):IppStatus;stdcall;
  ippsNormalize_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;vSub:Ipp32f;vDiv:Ipp32f):IppStatus;stdcall;
  ippsNormalize_32fc_I: function(pSrcDst:PIpp32fc;len:longint;vSub:Ipp32fc;vDiv:Ipp32f):IppStatus;stdcall;
  ippsNormalize_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;vSub:Ipp32fc;vDiv:Ipp32f):IppStatus;stdcall;
  ippsNormalize_64f_I: function(pSrcDst:PIpp64f;len:longint;vSub:Ipp64f;vDiv:Ipp64f):IppStatus;stdcall;
  ippsNormalize_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;vSub:Ipp64f;vDiv:Ipp64f):IppStatus;stdcall;
  ippsNormalize_64fc_I: function(pSrcDst:PIpp64fc;len:longint;vSub:Ipp64fc;vDiv:Ipp64f):IppStatus;stdcall;
  ippsNormalize_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;vSub:Ipp64fc;vDiv:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                   Convert functions
///////////////////////////////////////////////////////////////////////////// *)

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
  ippsSortAscend_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsSortAscend_32s_I: function(pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsSortAscend_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSortAscend_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsSortDescend_8u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSortDescend_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsSortDescend_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsSortDescend_32s_I: function(pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsSortDescend_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsSortDescend_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsSortIndexAscend_8u_I: function(pSrcDst:PIpp8u;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexAscend_16s_I: function(pSrcDst:PIpp16s;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexAscend_16u_I: function(pSrcDst:PIpp16u;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexAscend_32s_I: function(pSrcDst:PIpp32s;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexAscend_32f_I: function(pSrcDst:PIpp32f;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexAscend_64f_I: function(pSrcDst:PIpp64f;pDstIdx:Plongint;len:longint):IppStatus;stdcall;

  ippsSortIndexDescend_8u_I: function(pSrcDst:PIpp8u;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexDescend_16s_I: function(pSrcDst:PIpp16s;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexDescend_16u_I: function(pSrcDst:PIpp16u;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexDescend_32s_I: function(pSrcDst:PIpp32s;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexDescend_32f_I: function(pSrcDst:PIpp32f;pDstIdx:Plongint;len:longint):IppStatus;stdcall;
  ippsSortIndexDescend_64f_I: function(pSrcDst:PIpp64f;pDstIdx:Plongint;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSortRadixGetBufferSize, ippsSortRadixIndexGetBufferSize
//  Purpose:     : Get the size (in bytes) of the buffer for ippsSortRadix internal calculations.
//  Arguments:
//    len           length of the vectors
//    dataType      data type of the vector.
//    pBufferSize   pointer to the calculated buffer size (in bytes).
//  Return:
//   ippStsNoErr        OK
//   ippStsNullPtrErr   pBufferSize is NULL
//   ippStsSizeErr      vector's length is not positive
//   ippStsDataTypeErr  unsupported data type
*)
  ippsSortRadixGetBufferSize: function(len:longint;dataType:IppDataType;pBufferSize:Plongint):IppStatus;stdcall;
  ippsSortRadixIndexGetBufferSize: function(len:longint;dataType:IppDataType;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSortRadixAscend, ippsSortRadixDescend
//
//  Purpose:    Rearrange elements of input vector using radix sort algorithm.
//              ippsSortRadixAscend  - sorts input array in increasing order
//              ippsSortRadixDescend - sorts input array in decreasing order
//
//  Arguments:
//    pSrcDst   pointer to the source/destination vector
//    len       length of the vectors
//    pBuffer   pointer to the work buffer
//  Return:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  pointer to the data or work buffer is NULL
//    ippStsSizeErr     length of the vector is less or equal zero
*)
  ippsSortRadixAscend_8u_I: function(pSrcDst:PIpp8u;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixAscend_16u_I: function(pSrcDst:PIpp16u;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixAscend_16s_I: function(pSrcDst:PIpp16s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixAscend_32u_I: function(pSrcDst:PIpp32u;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixAscend_32s_I: function(pSrcDst:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixAscend_32f_I: function(pSrcDst:PIpp32f;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixAscend_64f_I: function(pSrcDst:PIpp64f;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsSortRadixDescend_8u_I: function(pSrcDst:PIpp8u;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixDescend_16u_I: function(pSrcDst:PIpp16u;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixDescend_16s_I: function(pSrcDst:PIpp16s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixDescend_32u_I: function(pSrcDst:PIpp32u;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixDescend_32s_I: function(pSrcDst:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixDescend_32f_I: function(pSrcDst:PIpp32f;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixDescend_64f_I: function(pSrcDst:PIpp64f;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////////
//  Names:      ippsSortRadixIndexAscend, ippsSortRadixIndexDescend
//
//  Purpose:    Indirectly sorts possibly sparse input vector, using indexes.
//              For a dense input array the following will be true:
//
//              ippsSortRadixIndexAscend  - pSrc[pDstIndx[i-1]] <= pSrc[pDstIndx[i]];
//              ippsSortRadixIndexDescend - pSrc[pDstIndx[i]] <= pSrc[pDstIndx[i-1]];
//
//  Arguments:
//    pSrc              pointer to the first element of a sparse input vector;
//    srcStrideBytes    step between two consecutive elements of input vector in bytes;
//    pDstIndx          pointer to the output indexes vector;
//    len               length of the vectors
//    pBuffer           pointer to the work buffer
//  Return:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  pointers to the vectors or poiter to work buffer is NULL
//    ippStsSizeErr     length of the vector is less or equal zero
*)
  ippsSortRadixIndexAscend_8u: function(pSrc:PIpp8u;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexAscend_16s: function(pSrc:PIpp16s;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexAscend_16u: function(pSrc:PIpp16u;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexAscend_32s: function(pSrc:PIpp32s;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexAscend_32u: function(pSrc:PIpp32u;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexAscend_32f: function(pSrc:PIpp32f;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsSortRadixIndexDescend_8u: function(pSrc:PIpp8u;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexDescend_16s: function(pSrc:PIpp16s;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexDescend_16u: function(pSrc:PIpp16u;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexDescend_32s: function(pSrc:PIpp32s;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexDescend_32u: function(pSrc:PIpp32u;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsSortRadixIndexDescend_32f: function(pSrc:PIpp32f;srcStrideBytes:Ipp32s;pDstIndx:PIpp32s;len:longint;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSwapBytes
//  Purpose:    Reverses the byte order of vector
//  Parameters:
//    pSrc      Pointer to input vector
//    pSrcDst   Pointer to source and destination vector for in-place operation
//    pDst      Pointer to output vector
//    len       Vectors' length in elements
//  Return:
//    ippStsNullPtrErr        At least one pointer is NULL
//    ippStsSizeErr           Vectors' length is less than 1
//    ippStsNoErr             Otherwise
*)
  ippsSwapBytes_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_16u: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_24u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_24u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_32u_I: function(pSrcDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_32u: function(pSrc:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_64u_I: function(pSrcDst:PIpp64u;len:longint):IppStatus;stdcall;
  ippsSwapBytes_64u: function(pSrc:PIpp64u;pDst:PIpp64u;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvert
//  Purpose:    Converts vector data type
//  Parameters:
//    pSrc        Pointer to input vector
//    pDst        Pointer to output vector
//    len         Vectors' length in elements
//    rndMode     Round mode - ippRndZero, ippRndNear or ippRndFinancial
//    scaleFactor Scale factor (for some integer outputs)
//  Return:
//    ippStsNullPtrErr               One of pointers is NULL
//    ippStsSizeErr                  Vectors' length is less than 1
//    ippStsRoundModeNotSupportedErr Specified round mode is not supported
//    ippStsNoErr                    No error
//  Note:
//    all out-of-range result are saturated
*)
  ippsConvert_8s16s: function(pSrc:PIpp8s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsConvert_8s32f: function(pSrc:PIpp8s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_8u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_16s8s_Sfs: function(pSrc:PIpp16s;pDst:PIpp8s;len:Ipp32u;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_16s32s: function(pSrc:PIpp16s;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsConvert_16s16f: function(pSrc:PIpp16s;pDst:PIpp16f;len:longint;rndMode:IppRoundMode):IppStatus;stdcall;
  ippsConvert_16s32f: function(pSrc:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_16s32f_Sfs: function(pSrc:PIpp16s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_16s64f_Sfs: function(pSrc:PIpp16s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_16u32f: function(pSrc:PIpp16u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_24s32s: function(pSrc:PIpp8u;pDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsConvert_24s32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_24u32u: function(pSrc:PIpp8u;pDst:PIpp32u;len:longint):IppStatus;stdcall;
  ippsConvert_24u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_32s16s: function(pSrc:PIpp32s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsConvert_32s16s_Sfs: function(pSrc:PIpp32s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32s24s_Sfs: function(pSrc:PIpp32s;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32s32f: function(pSrc:PIpp32s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_32s32f_Sfs: function(pSrc:PIpp32s;pDst:PIpp32f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32s64f: function(pSrc:PIpp32s;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsConvert_32s64f_Sfs: function(pSrc:PIpp32s;pDst:PIpp64f;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32u24u_Sfs: function(pSrc:PIpp32u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64s32s_Sfs: function(pSrc:PIpp64s;pDst:PIpp32s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64s64f: function(pSrc:PIpp64s;pDst:PIpp64f;len:Ipp32u):IppStatus;stdcall;
  ippsConvert_16f16s_Sfs: function(pSrc:PIpp16f;pDst:PIpp16s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_16f32f: function(pSrc:PIpp16f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_32f8s_Sfs: function(pSrc:PIpp32f;pDst:PIpp8s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f8u_Sfs: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f16s_Sfs: function(pSrc:PIpp32f;pDst:PIpp16s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f16u_Sfs: function(pSrc:PIpp32f;pDst:PIpp16u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f24s_Sfs: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f24u_Sfs: function(pSrc:PIpp32f;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f32s_Sfs: function(pSrc:PIpp32f;pDst:PIpp32s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_32f16f: function(pSrc:PIpp32f;pDst:PIpp16f;len:longint;rndMode:IppRoundMode):IppStatus;stdcall;
  ippsConvert_32f64f: function(pSrc:PIpp32f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsConvert_64f16s_Sfs: function(pSrc:PIpp64f;pDst:PIpp16s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f32s_Sfs: function(pSrc:PIpp64f;pDst:PIpp32s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f64s_Sfs: function(pSrc:PIpp64f;pDst:PIpp64s;len:Ipp32u;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f32f: function(pSrc:PIpp64f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsConvert_8s8u: function(pSrc:PIpp8s;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsConvert_8u8s_Sfs: function(pSrc:PIpp8u;pDst:PIpp8s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f8s_Sfs: function(pSrc:PIpp64f;pDst:PIpp8s;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f8u_Sfs: function(pSrc:PIpp64f;pDst:PIpp8u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;
  ippsConvert_64f16u_Sfs: function(pSrc:PIpp64f;pDst:PIpp16u;len:longint;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:       ippsConj, ippsConjFlip, ippsConjCcs, ippsConjPerm, ippsConjPack
//  Purpose:     Complex conjugate input vector; 
//               Ccs, Perm and Pack versions - in corresponding packed format
//  Parameters:
//    pSrc               Pointer to input complex vector
//    pDst               Pointer to output complex vector
//    len                Vectors' length in elements
//  Return:
//    ippStsNullPtrErr      One of pointers is NULL
//    ippStsSizeErr         Vectors' length is less than 1
//    ippStsNoErr           Otherwise
//  Notes:
//    ConjFlip version conjugates and stores result in reverse order
*)
  ippsConj_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsConj_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsConj_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsConj_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsConj_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsConj_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsConjFlip_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsConjFlip_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsConjFlip_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsConjCcs_32fc_I: function(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_64fc_I: function(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjCcs_64fc: function(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_32fc_I: function(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_64fc_I: function(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPack_64fc: function(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_32fc_I: function(pSrcDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_64fc_I: function(pSrcDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;
  ippsConjPerm_64fc: function(pSrc:PIpp64f;pDst:PIpp64fc;lenDst:longint):IppStatus;stdcall;

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
  ippsMagnitude_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMagnitude_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMagnitude_16s32f: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_16sc32f: function(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsMagnitude_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_32fc: function(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMagnitude_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMagnitude_64fc: function(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippsPhase
//  Purpose:
//    Compute the phase (in radians) of complex vector elements.
//  Parameters:
//    pSrcRe    - an input complex vector
//    pDst      - an output vector to store the phase components;
//    len       - a length of the arrays.
//    scaleFactor   - a scale factor of output results (only for integer data)
//  Return:
//    ippStsNoErr               Ok
//    ippStsNullPtrErr          Some of pointers to input or output data are NULL
//    ippStsBadSizeErr          The length of the arrays is less or equal zero
*)
  ippsPhase_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsPhase_16sc32f: function(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPhase_64fc: function(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsPhase_32fc: function(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;stdcall;

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
//    scaleFactor   - a scale factor of output results (only for integer data)
//  Return:
//    ippStsNoErr               Ok
//    ippStsNullPtrErr          Some of pointers to input or output data are NULL
//    ippStsBadSizeErr          The length of the arrays is less or equal zero
*)
  ippsPhase_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsPhase_16s32f: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPhase_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsPhase_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:        ippsPowerSpectr
//  Purpose:      Compute the power spectrum of complex vector
//  Parameters:
//    pSr       - pointer to the complex input vector.
//    pSrcIm    - pointer to the image part of input vector.
//    pDst      - pointer to the result.
//    len       - vector length.
//    scaleFactor   - scale factor for rezult (only for integer data).
//  Return:
//   ippStsNullPtrErr  indicates that one or more pointers to the data is NULL.
//   ippStsSizeErr     indicates that vector length is less or equal zero.
//   ippStsNoErr       otherwise.
*)
  ippsPowerSpectr_16s_Sfs: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsPowerSpectr_16s32f: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPowerSpectr_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPowerSpectr_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

  ippsPowerSpectr_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsPowerSpectr_16sc32f: function(pSrc:PIpp16sc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPowerSpectr_32fc: function(pSrc:PIpp32fc;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPowerSpectr_64fc: function(pSrc:PIpp64fc;pDst:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsReal
//  Purpose:    Extract real part of input complex vector
//  Parameters:
//    pSrc       Pointer to input complex vector
//    pDstRe     Pointer to output real vector
//    len        Vectors' length in elements
//  Return:
//    ippStsNullPtrErr       One of pointers is NULL
//    ippStsSizeErr          Vectors' length is less than 1
//    ippStsNoErr            Otherwise
*)
  ippsReal_64fc: function(pSrc:PIpp64fc;pDstRe:PIpp64f;len:longint):IppStatus;stdcall;
  ippsReal_32fc: function(pSrc:PIpp32fc;pDstRe:PIpp32f;len:longint):IppStatus;stdcall;
  ippsReal_16sc: function(pSrc:PIpp16sc;pDstRe:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsImag
//  Purpose:    Extract imaginary part of input complex vector
//  Parameters:
//    pSrc       Pointer to input complex vector
//    pDstRe     Pointer to output imaginary vector
//    len        Vectors' length in elements
//  Return:
//    ippStsNullPtrErr       One of pointers is NULL
//    ippStsSizeErr          Vectors' length is less than 1
//    ippStsNoErr            Otherwise
*)
  ippsImag_64fc: function(pSrc:PIpp64fc;pDstIm:PIpp64f;len:longint):IppStatus;stdcall;
  ippsImag_32fc: function(pSrc:PIpp32fc;pDstIm:PIpp32f;len:longint):IppStatus;stdcall;
  ippsImag_16sc: function(pSrc:PIpp16sc;pDstIm:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsRealToCplx
//  Purpose:    Compose complex vector from real and imaginary parts
//  Parameters:
//    pSrcRe     Pointer to input real vector, may be NULL
//    pSrcIm     Pointer to input imaginary vector, may be NULL
//    pDst       Pointer to output complex vector
//    len        Vectors' length in elements
//  Return:
//    ippStsNullPtrErr        Pointer to output vector is NULL, or both pointers
//                            to real and imaginary parts are NULL
//    ippStsSizeErr           Vectors' length is less than 1
//    ippStsNoErr             Otherwise
//
//  Notes:      One of two input pointers may be NULL. In this case
//              corresponding values of output complex elements are 0
*)
  ippsRealToCplx_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsRealToCplx_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsRealToCplx_16s: function(pSrcRe:PIpp16s;pSrcIm:PIpp16s;pDst:PIpp16sc;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCplxToReal
//  Purpose:    Extract real and imaginary parts of input complex vector
//  Parameters:
//    pSrc       Pointer to input complex vector
//    pDstRe     Pointer to output real vector
//    pDstIm     Pointer to output imaginary vector
//    len        Vectors' length in elements
//  Return:
//    ippStsNullPtrErr        One of pointers is NULL
//    ippStsSizeErr           Vectors' length is less than 1
//    ippStsNoErr             Otherwise
*)
  ippsCplxToReal_64fc: function(pSrc:PIpp64fc;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;stdcall;
  ippsCplxToReal_32fc: function(pSrc:PIpp32fc;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCplxToReal_16sc: function(pSrc:PIpp16sc;pDstRe:PIpp16s;pDstIm:PIpp16s;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold
//  Purpose:    Performs threshold operation on vector's elements by limiting 
//              element values by specified value. 
//  Parameters:
//    level      Value used to limit each element of pSrc or pSrcDst.
//               This parameter must always be real. For complex versions, 
//               it must be positive and represent magnitude
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//    relOp      Values of this argument specify which relational operator 
//               to use and whether level is an upper or lower bound for input.
//               relOp must have one of the following values: 
//               - ippCmpLess specifies "less than" operator and level is lower bound
                 - ippCmpGreater specifies "greater than" operator and level is upper bound. 
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThreshNegLevelErr   Negative level value for complex operation
//    ippStsBadArgErr           relOp has invalid value
//    ippStsNoErr               No error
//  Notes:
//  real data
//    cmpLess    : pDst[n] = pSrc[n] < level ? level : pSrc[n];
//    cmpGreater : pDst[n] = pSrc[n] > level ? level : pSrc[n];
//  complex data
//    cmpLess    : pDst[n] = abs(pSrc[n]) < level ? pSrc[n]*k : pSrc[n];
//    cmpGreater : pDst[n] = abs(pSrc[n]) > level ? pSrc[n]*k : pSrc[n];
//    where k = level / abs(pSrc[n]);
*)

  ippsThreshold_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;
  ippsThreshold_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;relOp:IppCmpOp):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold_LT, ippsThreshold_GT
//  Purpose:    Performs threshold operation on elements of vector by limiting
//              element values by specified value
//  Parameters:
//    level      Value used to limit each element of pSrc or pSrcDst.
//               This parameter must always be real. For complex versions, 
//               it must be positive and represent magnitude
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThreshNegLevelErr   Negative level value for complex operation
//    ippStsNoErr               No error
*)
  ippsThreshold_LT_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_32s_I: function(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LT_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LT_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LT_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LT_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LT_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_32s_I: function(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_GT_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GT_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_GT_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GT_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GT_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold_LTAbs
//  Purpose:    Performs threshold operation on absolute values of elements of vector
//  Parameters:
//    level      Value used to limit each element of pSrc or pSrcDst.
//               This parameter must be positive
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThreshNegLevelErr   Negative level value
//    ippStsNoErr               No error
*)
  ippsThreshold_LTAbs_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTAbs_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LTAbs_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTAbs_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTAbs_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTAbs_32s_I: function(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LTAbs_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTAbs_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GTAbs_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GTAbs_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_GTAbs_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GTAbs_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GTAbs_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GTAbs_32s_I: function(pSrcDst:PIpp32s;len:longint;level:Ipp32s):IppStatus;stdcall;
  ippsThreshold_GTAbs_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GTAbs_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold_LTAbsVal
//  Purpose:    Performs threshold operation on absolute values of elements
//              of vector by limiting element values by specified level and 
//              substituting with specified value:
//              if( ABS(x[i]) < level ) y[i] = value;
//              else y[i] = x[i];
//  Parameters:
//    level      Value used to limit each element of pSrc or pSrcDst. This argument
//               must always be positive
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//    value      Value to be assigned to vector elements which are "less than" 
//               by absolute value than level
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThreshNegLevelErr   Negative level value
//    ippStsNoErr               No error
*)
  ippsThreshold_LTAbsVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;level:Ipp32s;value:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_32s_I: function(pSrcDst:PIpp32s;len:longint;level:Ipp32s;value:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTAbsVal_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold_LTVal, ippsThreshold_GTVal
//  Purpose:    Performs threshold operation on elements of vector by limiting
//              element values by specified level and substituting with 
//              specified value
//  Parameters:
//    level      Value used to limit each element of pSrc or pSrcDst. This argument
//               must always be real. For complex versions, it must be positive and
//               represent magnitude
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//    value      Value to be assigned to vector elements which are "less than" or
//               "greater than" level.
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThreshNegLevelErr   Negative level value for complex operation
//    ippStsNoErr               No error
*)
  ippsThreshold_LTVal_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTVal_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_LTVal_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTVal_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_LTVal_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTVal_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_LTVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTVal_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_LTVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTVal_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_LTVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTVal_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_GTVal_16s_I: function(pSrcDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GTVal_16sc_I: function(pSrcDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_GTVal_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GTVal_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_GTVal_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GTVal_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;
  ippsThreshold_GTVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;level:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippsThreshold_GTVal_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;level:Ipp16s;value:Ipp16sc):IppStatus;stdcall;
  ippsThreshold_GTVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippsThreshold_GTVal_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f;value:Ipp32fc):IppStatus;stdcall;
  ippsThreshold_GTVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f;value:Ipp64f):IppStatus;stdcall;
  ippsThreshold_GTVal_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f;value:Ipp64fc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsThreshold_LTValGTVal
//  Purpose:    Performs threshold operation on elements of vector by limiting
//              element values by specified level and substituting with 
//              specified values for LT and GT cases respectively
//  Parameters:
//    levelLT    Value used to limit each element of pSrc or pSrcDst for "less than" 
//    levelGT    Value used to limit each element of pSrc or pSrcDst for "greater than" 
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//    valueLT    Value to be assigned to vector elements which are "less than" levelLT
//    valueGT    Value to be assigned to vector elements which are "greater than" levelGT
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThresholdErr        levelGT < levelLT
//    ippStsNoErr               No error
*)
  ippsThreshold_LTValGTVal_16s_I: function(pSrcDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;levelLT:Ipp16s;valueLT:Ipp16s;levelGT:Ipp16s;valueGT:Ipp16s):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_32s_I: function(pSrcDst:PIpp32s;len:longint;levelLT:Ipp32s;valueLT:Ipp32s;levelGT:Ipp32s;valueGT:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;levelLT:Ipp32s;valueLT:Ipp32s;levelGT:Ipp32s;valueGT:Ipp32s):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_32f_I: function(pSrcDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;levelLT:Ipp32f;valueLT:Ipp32f;levelGT:Ipp32f;valueGT:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_64f_I: function(pSrcDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTValGTVal_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;levelLT:Ipp64f;valueLT:Ipp64f;levelGT:Ipp64f;valueGT:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsThresholdLTInv
//  Purpose:    Computes inverse of vector elements after limiting
//              their magnitudes by given lower bound
//    level      Value used to limit each element of pSrc or pSrcDst
//    pSrcDst    Pointer to source and destination vector for in-place operation
//    pSrc       Pointer to input vector
//    pDst       Pointer to output vector
//    len        Number of elements in the vector
//  Return:
//    ippStsNullPtrErr          One of pointers is NULL
//    ippStsSizeErr             Vectors' length is less than 1
//    ippStsThreshNegLevelErr   Negative level value
//    ippStsInvZero             level and source element values are zero
//    ippStsNoErr               No error
*)
  ippsThreshold_LTInv_32f_I: function(pSrcDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_32fc_I: function(pSrcDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_64f_I: function(pSrcDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTInv_64fc_I: function(pSrcDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTInv_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;level:Ipp32f):IppStatus;stdcall;
  ippsThreshold_LTInv_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;level:Ipp64f):IppStatus;stdcall;
  ippsThreshold_LTInv_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;level:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsCartToPolar
//  Purpose:    Converts elements of complex vector to polar coordinate form
//  Parameters:
//    pSrc             Pointer to source vector
//    pSrcRe           Pointer to source vector which stores real components of
//                     Cartesian X,Y pairs
//    pSrcIm           Pointer to source vector which stores imaginary components
//                     of Cartesian X,Y pairs
//    pDstMagn         Pointer to vector which stores magnitude (radius)
//                     component of elements of vector pSrc
//    pDstPhase        Pointer to vector which stores phase (angle) component of
//                     elements of vector pSrc in radians. Phase values are in
//                     range (-Pi, Pi]
//    len              Number of elements in vector
//    magnScaleFactor  Integer scale factor for magnitude component
//    phaseScaleFactor Integer scale factor for phase component
//  Return:
//   ippStsNoErr           Indicates no error
//   ippStsNullPtrErr      At least one of specified pointers is NULL
//   ippStsSizeErr         Vectors' length is less than 1
*)
  ippsCartToPolar_32fc: function(pSrc:PIpp32fc;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCartToPolar_64fc: function(pSrc:PIpp64fc;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;stdcall;
  ippsCartToPolar_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstMagn:PIpp32f;pDstPhase:PIpp32f;len:longint):IppStatus;stdcall;
  ippsCartToPolar_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstMagn:PIpp64f;pDstPhase:PIpp64f;len:longint):IppStatus;stdcall;

(*  Additional parameters for integer version:
//   magnScaleFactor   Scale factor for magnitude companents
//   phaseScaleFactor  Scale factor for phase companents
*)
  ippsCartToPolar_16sc_Sfs: function(pSrc:PIpp16sc;pDstMagn:PIpp16s;pDstPhase:PIpp16s;len:longint;magnScaleFactor:longint;phaseScaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsPolarToCart
//  Purpose:    Converts polar form magnitude/phase pairs stored
//              in input vectors to Cartesian coordinate form
//  Parameters:
//    pSrcMagn  Pointer to source vector which stores magnitude (radius)
//              components of elements in polar coordinate form
//    pSrcPhase Pointer to vector which stores phase (angle) components of
//              elements in polar coordinate form in radians
//    pDst      Pointer to  resulting vector which stores complex pairs in
//              Cartesian coordinates (X + iY)
//    pDstRe    Pointer to resulting vector which stores real components of
//              Cartesian X,Y pairs
//    pDstIm    Pointer to resulting vector which stores imaginary
//              components of Cartesian X,Y pairs
//    len       Number of elements in vectors
//  Return:
//   ippStsNoErr           Indicates no error
//   ippStsNullPtrErr      At least one of specified pointers is NULL
//   ippStsSizeErr         Vectors' length is less than 1
*)

  ippsPolarToCart_32fc: function(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsPolarToCart_64fc: function(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsPolarToCart_32f: function(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;len:longint):IppStatus;stdcall;
  ippsPolarToCart_64f: function(pSrcMagn:PIpp64f;pSrcPhase:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;len:longint):IppStatus;stdcall;

(*  Additional parameters for integer version:
//   magnScaleFactor   Scale factor for magnitude companents
//   phaseScaleFactor  Scale factor for phase companents
*)
  ippsPolarToCart_16sc_Sfs: function(pSrcMagn:PIpp16s;pSrcPhase:PIpp16s;pDst:PIpp16sc;len:longint;magnScaleFactor:longint;phaseScaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFlip
//  Purpose:    dst[i] = src[len-i-1], i=0..len-1
//  Parameters:
//    pSrc      Pointer to input vector
//    pDst      Pointer to the output vector
//    pSrcDst   Pointer to source and destination vector for in-place operation
//    len       Vectors' length in elements
//  Return:
//    ippStsNullPtrErr        At least one pointer is NULL
//    ippStsSizeErr           Vectors' length is less than 1
//    ippStsNoErr             Otherwise
*)
  ippsFlip_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsFlip_8u_I: function(pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsFlip_16u: function(pSrc:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsFlip_16u_I: function(pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsFlip_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsFlip_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsFlip_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsFlip_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsFlip_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsFlip_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsFlip_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsFlip_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;

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
  ippsWinBartlett_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBartlett_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBartlett_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinBartlett_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

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
  ippsWinHann_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHann_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHann_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHann_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHann_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHann_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHann_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinHann_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinHann_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHann_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHann_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
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
  ippsWinHamming_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinHamming_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHamming_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinHamming_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHamming_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinHamming_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinHamming_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinHamming_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHamming_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinHamming_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinHamming_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

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
  ippsWinBlackman_16s_I: function(pSrcDst:PIpp16s;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_16sc_I: function(pSrcDst:PIpp16sc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_32f_I: function(pSrcDst:PIpp32f;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_32fc_I: function(pSrcDst:PIpp32fc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinBlackman_64f_I: function(pSrcDst:PIpp64f;len:longint;alpha:Ipp64f):IppStatus;stdcall;
  ippsWinBlackman_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:Ipp64f):IppStatus;stdcall;
  ippsWinBlackman_64fc_I: function(pSrcDst:PIpp64fc;len:longint;alpha:Ipp64f):IppStatus;stdcall;
  ippsWinBlackman_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:Ipp64f):IppStatus;stdcall;

  ippsWinBlackmanStd_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanStd_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

  ippsWinBlackmanOpt_16s_I: function(pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16sc_I: function(pSrcDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32f_I: function(pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32fc_I: function(pSrcDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64f_I: function(pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64fc_I: function(pSrcDst:PIpp64fc;len:longint):IppStatus;stdcall;
  ippsWinBlackmanOpt_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;stdcall;

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
  ippsWinKaiser_16s_I: function(pSrcDst:PIpp16s;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_16sc_I: function(pSrcDst:PIpp16sc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_32f_I: function(pSrcDst:PIpp32f;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_32fc_I: function(pSrcDst:PIpp32fc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;alpha:Ipp32f):IppStatus;stdcall;
  ippsWinKaiser_64f_I: function(pSrcDst:PIpp64f;len:longint;alpha:Ipp64f):IppStatus;stdcall;
  ippsWinKaiser_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;alpha:Ipp64f):IppStatus;stdcall;
  ippsWinKaiser_64fc_I: function(pSrcDst:PIpp64fc;len:longint;alpha:Ipp64f):IppStatus;stdcall;
  ippsWinKaiser_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;alpha:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Statistical functions
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
  ippsSum_16s_Sfs: function(pSrc:PIpp16s;len:longint;pSum:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;pSum:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_16sc32sc_Sfs: function(pSrc:PIpp16sc;len:longint;pSum:PIpp32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_32s_Sfs: function(pSrc:PIpp32s;len:longint;pSum:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsSum_32f: function(pSrc:PIpp32f;len:longint;pSum:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsSum_32fc: function(pSrc:PIpp32fc;len:longint;pSum:PIpp32fc;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsSum_64f: function(pSrc:PIpp64f;len:longint;pSum:PIpp64f):IppStatus;stdcall;
  ippsSum_64fc: function(pSrc:PIpp64fc;len:longint;pSum:PIpp64fc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Names:      ippsMin, ippsMax, ippsMinMax
// Purpose:    Find minimum/maximum value among all elements of the source vector
// Parameters:
//    pSrc     - Pointer to the source vector.
//    len      - Length of the vector.
//    pMax     - Pointer to the result.
//    pMin     - Pointer to the result.
// Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length of the vector is less or equal 0.
*)
  ippsMin_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s):IppStatus;stdcall;
  ippsMin_32s: function(pSrc:PIpp32s;len:longint;pMin:PIpp32s):IppStatus;stdcall;
  ippsMin_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f):IppStatus;stdcall;
  ippsMin_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f):IppStatus;stdcall;

  ippsMax_16s: function(pSrc:PIpp16s;len:longint;pMax:PIpp16s):IppStatus;stdcall;
  ippsMax_32s: function(pSrc:PIpp32s;len:longint;pMax:PIpp32s):IppStatus;stdcall;
  ippsMax_32f: function(pSrc:PIpp32f;len:longint;pMax:PIpp32f):IppStatus;stdcall;
  ippsMax_64f: function(pSrc:PIpp64f;len:longint;pMax:PIpp64f):IppStatus;stdcall;

  ippsMinMax_8u: function(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMax:PIpp8u):IppStatus;stdcall;
  ippsMinMax_16u: function(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMax:PIpp16u):IppStatus;stdcall;
  ippsMinMax_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMax:PIpp16s):IppStatus;stdcall;
  ippsMinMax_32u: function(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMax:PIpp32u):IppStatus;stdcall;
  ippsMinMax_32s: function(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMax:PIpp32s):IppStatus;stdcall;
  ippsMinMax_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMax:PIpp32f):IppStatus;stdcall;
  ippsMinMax_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMax:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Names:      ippsMinAbs, ippsMaxAbs
// Purpose:    Returns the minimum/maximum absolute value of a vector.
// Parameters:
//    pSrc     - Pointer to the source vector.
//    len      - Length of the vector.
//    pMinAbs  - Pointer to the result.
//    pMaxAbs  - Pointer to the result.
// Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length of the vector is less or equal 0.
*)
  ippsMinAbs_16s: function(pSrc:PIpp16s;len:longint;pMinAbs:PIpp16s):IppStatus;stdcall;
  ippsMinAbs_32s: function(pSrc:PIpp32s;len:longint;pMinAbs:PIpp32s):IppStatus;stdcall;
  ippsMinAbs_32f: function(pSrc:PIpp32f;len:longint;pMinAbs:PIpp32f):IppStatus;stdcall;
  ippsMinAbs_64f: function(pSrc:PIpp64f;len:longint;pMinAbs:PIpp64f):IppStatus;stdcall;

  ippsMaxAbs_16s: function(pSrc:PIpp16s;len:longint;pMaxAbs:PIpp16s):IppStatus;stdcall;
  ippsMaxAbs_32s: function(pSrc:PIpp32s;len:longint;pMaxAbs:PIpp32s):IppStatus;stdcall;
  ippsMaxAbs_32f: function(pSrc:PIpp32f;len:longint;pMaxAbs:PIpp32f):IppStatus;stdcall;
  ippsMaxAbs_64f: function(pSrc:PIpp64f;len:longint;pMaxAbs:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Names:      ippsMinIndx, ippsMaxIndx
// Purpose:    Find element with min/max value and return the value and the index.
// Parameters:
//    pSrc     - Pointer to the input vector.
//    len      - Length of the vector.
//    pMin     - Pointer to min value found.
//    pMax     - Pointer to max value found.
//    pIndx    - Pointer to index of the first min/max value, may be NULL.
//    pMinIndx - Pointer to index of the first minimum value.
//    pMaxIndx - Pointer to index of the first maximum value.
// Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length of the vector is less or equal 0.
*)
  ippsMinIndx_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pIndx:Plongint):IppStatus;stdcall;
  ippsMinIndx_32s: function(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pIndx:Plongint):IppStatus;stdcall;
  ippsMinIndx_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pIndx:Plongint):IppStatus;stdcall;
  ippsMinIndx_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pIndx:Plongint):IppStatus;stdcall;

  ippsMaxIndx_16s: function(pSrc:PIpp16s;len:longint;pMax:PIpp16s;pIndx:Plongint):IppStatus;stdcall;
  ippsMaxIndx_32s: function(pSrc:PIpp32s;len:longint;pMax:PIpp32s;pIndx:Plongint):IppStatus;stdcall;
  ippsMaxIndx_32f: function(pSrc:PIpp32f;len:longint;pMax:PIpp32f;pIndx:Plongint):IppStatus;stdcall;
  ippsMaxIndx_64f: function(pSrc:PIpp64f;len:longint;pMax:PIpp64f;pIndx:Plongint):IppStatus;stdcall;

  ippsMinMaxIndx_8u: function(pSrc:PIpp8u;len:longint;pMin:PIpp8u;pMinIndx:Plongint;pMax:PIpp8u;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_16u: function(pSrc:PIpp16u;len:longint;pMin:PIpp16u;pMinIndx:Plongint;pMax:PIpp16u;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_16s: function(pSrc:PIpp16s;len:longint;pMin:PIpp16s;pMinIndx:Plongint;pMax:PIpp16s;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_32u: function(pSrc:PIpp32u;len:longint;pMin:PIpp32u;pMinIndx:Plongint;pMax:PIpp32u;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_32s: function(pSrc:PIpp32s;len:longint;pMin:PIpp32s;pMinIndx:Plongint;pMax:PIpp32s;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_32f: function(pSrc:PIpp32f;len:longint;pMin:PIpp32f;pMinIndx:Plongint;pMax:PIpp32f;pMaxIndx:Plongint):IppStatus;stdcall;
  ippsMinMaxIndx_64f: function(pSrc:PIpp64f;len:longint;pMin:PIpp64f;pMinIndx:Plongint;pMax:PIpp64f;pMaxIndx:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Names:      ippsMinAbsIndx, ippsMaxAbsIndx
// Purpose:    Returns the min/max absolute value of a vector and the index of the corresponding element.
// Parameters:
//    pSrc     - Pointer to the input vector.
//    len      - Length of the vector.
//    pMinAbs  - Pointer to the min absolute value found.
//    pMaxAbs  - Pointer to the max absolute value found.
//    pMinIndx - Pointer to index of the first minimum absolute value.
//    pMaxIndx - Pointer to index of the first maximum absolute value.
// Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length of the vector is less or equal 0.
*)
  ippsMinAbsIndx_16s: function(pSrc:PIpp16s;len:longint;pMinAbs:PIpp16s;pIndx:Plongint):IppStatus;stdcall;
  ippsMinAbsIndx_32s: function(pSrc:PIpp32s;len:longint;pMinAbs:PIpp32s;pIndx:Plongint):IppStatus;stdcall;

  ippsMaxAbsIndx_16s: function(pSrc:PIpp16s;len:longint;pMaxAbs:PIpp16s;pIndx:Plongint):IppStatus;stdcall;
  ippsMaxAbsIndx_32s: function(pSrc:PIpp32s;len:longint;pMaxAbs:PIpp32s;pIndx:Plongint):IppStatus;stdcall;

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
  ippsMean_16s_Sfs: function(pSrc:PIpp16s;len:longint;pMean:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsMean_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;pMean:PIpp16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsMean_32s_Sfs: function(pSrc:PIpp32s;len:longint;pMean:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsMean_32f: function(pSrc:PIpp32f;len:longint;pMean:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsMean_32fc: function(pSrc:PIpp32fc;len:longint;pMean:PIpp32fc;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsMean_64f: function(pSrc:PIpp64f;len:longint;pMean:PIpp64f):IppStatus;stdcall;
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
//  Functionality:
//         std = sqrt( sum( (x[n] - mean(x))^2, n=0..len-1 ) / (len-1) )
*)
  ippsStdDev_16s_Sfs: function(pSrc:PIpp16s;len:longint;pStdDev:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsStdDev_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pStdDev:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsStdDev_32f: function(pSrc:PIpp32f;len:longint;pStdDev:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsStdDev_64f: function(pSrc:PIpp64f;len:longint;pStdDev:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsMeanStdDev
//  Purpose:    compute standard deviation value and mean value
//              of all elements of the vector
//  Parameters:
//   pSrc               pointer to the vector
//   len                length of the vector
//   pStdDev            pointer to the result
//   pMean              pointer to the result
//   scaleFactor        scale factor value
//  Return:
//   ippStsNoErr           Ok
//   ippStsNullPtrErr      pointer to the vector or the result is NULL
//   ippStsSizeErr         length of the vector is less than 2
//  Functionality:
//         std = sqrt( sum( (x[n] - mean(x))^2, n=0..len-1 ) / (len-1) )
*)
  ippsMeanStdDev_16s_Sfs: function(pSrc:PIpp16s;len:longint;pMean:PIpp16s;pStdDev:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsMeanStdDev_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pMean:PIpp32s;pStdDev:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsMeanStdDev_32f: function(pSrc:PIpp32f;len:longint;pMean:PIpp32f;pStdDev:PIpp32f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsMeanStdDev_64f: function(pSrc:PIpp64f;len:longint;pMean:PIpp64f;pStdDev:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:            ippsNorm
//  Purpose:         calculate norm of vector
//     Inf   - calculate C-norm of vector:  n = MAX |src1|
//     L1    - calculate L1-norm of vector: n = SUM |src1|
//     L2    - calculate L2-norm of vector: n = SQRT(SUM |src1|^2)
//     L2Sqr - calculate L2-norm of vector: n = SUM |src1|^2
//  Parameters:
//    pSrc           source data pointer
//    len            length of vector
//    pNorm          pointer to result
//    scaleFactor    scale factor value
//  Returns:
//    ippStsNoErr       Ok
//    ippStsNullPtrErr  Some of pointers to input or output data are NULL
//    ippStsSizeErr     The length of vector is less or equal zero
//  Notes:
*)
  ippsNorm_Inf_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_Inf_16s32f: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_Inf_32f: function(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_Inf_32fc32f: function(pSrc:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_Inf_64f: function(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_Inf_64fc64f: function(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNorm_L1_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_L1_16s64s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp64s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_L1_16s32f: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L1_32f: function(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L1_32fc64f: function(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L1_64f: function(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L1_64fc64f: function(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNorm_L2_16s32s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNorm_L2_16s32f: function(pSrc:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L2_32f: function(pSrc:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNorm_L2_32fc64f: function(pSrc:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L2_64f: function(pSrc:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L2_64fc64f: function(pSrc:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNorm_L2Sqr_16s64s_Sfs: function(pSrc:PIpp16s;len:longint;pNorm:PIpp64s;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:            ippsNormDiff
//  Purpose:         calculate norm of vectors
//     Inf   - calculate C-norm of vectors:  n = MAX |src1-src2|
//     L1    - calculate L1-norm of vectors: n = SUM |src1-src2|
//     L2    - calculate L2-norm of vectors: n = SQRT(SUM |src1-src2|^2)
//     L2Sqr - calculate L2-norm of vectors: n = SUM |src1-src2|^2
//  Parameters:
//    pSrc1, pSrc2   source data pointers
//    len            length of vector
//    pNorm          pointer to result
//    scaleFactor    scale factor value
//  Returns:
//    ippStsNoErr       Ok
//    ippStsNullPtrErr  Some of pointers to input or output data are NULL
//    ippStsSizeErr     The length of vector is less or equal zero
//  Notes:
*)
  ippsNormDiff_Inf_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_Inf_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_Inf_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_Inf_32fc32f: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_Inf_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_Inf_64fc64f: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNormDiff_L1_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_L1_16s64s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp64s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_L1_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L1_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L1_32fc64f: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L1_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L1_64fc64f: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;

  ippsNormDiff_L2_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsNormDiff_L2_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L2_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pNorm:PIpp32f):IppStatus;stdcall;
  ippsNormDiff_L2_32fc64f: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L2_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L2_64fc64f: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pNorm:PIpp64f):IppStatus;stdcall;
  ippsNormDiff_L2Sqr_16s64s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pNorm:PIpp64s;scaleFactor:longint):IppStatus;stdcall;

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
  ippsDotProd_16s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16s64s: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp64s):IppStatus;stdcall;
  ippsDotProd_16sc64sc: function(pSrc1:PIpp16sc;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;stdcall;
  ippsDotProd_16s16sc64sc: function(pSrc1:PIpp16s;pSrc2:PIpp16sc;len:longint;pDp:PIpp64sc):IppStatus;stdcall;
  ippsDotProd_16s32s32s_Sfs: function(pSrc1:PIpp16s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_16s32f: function(pSrc1:PIpp16s;pSrc2:PIpp16s;len:longint;pDp:PIpp32f):IppStatus;stdcall;
  ippsDotProd_32s_Sfs: function(pSrc1:PIpp32s;pSrc2:PIpp32s;len:longint;pDp:PIpp32s;scaleFactor:longint):IppStatus;stdcall;
  ippsDotProd_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp32f):IppStatus;stdcall;
  ippsDotProd_32fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;stdcall;
  ippsDotProd_32f32fc: function(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp32fc):IppStatus;stdcall;
  ippsDotProd_32f32fc64fc: function(pSrc1:PIpp32f;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;
  ippsDotProd_32f64f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;len:longint;pDp:PIpp64f):IppStatus;stdcall;
  ippsDotProd_32fc64fc: function(pSrc1:PIpp32fc;pSrc2:PIpp32fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;
  ippsDotProd_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;len:longint;pDp:PIpp64f):IppStatus;stdcall;
  ippsDotProd_64fc: function(pSrc1:PIpp64fc;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;
  ippsDotProd_64f64fc: function(pSrc1:PIpp64f;pSrc2:PIpp64fc;len:longint;pDp:PIpp64fc):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
// Names:      ippsMinEvery, ippsMaxEvery
// Purpose:    Calculation min/max value for every element of two vectors.
// Parameters:
//    pSrc     - Pointer to the first input vector.
//    pSrcDst  - Pointer to the second input vector which stores the result.
//    pSrc1    - Pointer to the first input vector.
//    pSrc2    - Pointer to the second input vector.
//    pDst     - Pointer to the destination vector.
//    len      - Length of the vector.
// Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length of the vector is less or equal 0.
*)
  ippsMinEvery_8u_I: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsMinEvery_16u_I: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsMinEvery_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMinEvery_32s_I: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsMinEvery_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMinEvery_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:Ipp32u):IppStatus;stdcall;

  ippsMinEvery_8u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:Ipp32u):IppStatus;stdcall;
  ippsMinEvery_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:Ipp32u):IppStatus;stdcall;
  ippsMinEvery_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:Ipp32u):IppStatus;stdcall;
  ippsMinEvery_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:Ipp32u):IppStatus;stdcall;

  ippsMaxEvery_8u_I: function(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint):IppStatus;stdcall;
  ippsMaxEvery_16u_I: function(pSrc:PIpp16u;pSrcDst:PIpp16u;len:longint):IppStatus;stdcall;
  ippsMaxEvery_16s_I: function(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;stdcall;
  ippsMaxEvery_32s_I: function(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint):IppStatus;stdcall;
  ippsMaxEvery_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMaxEvery_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:Ipp32u):IppStatus;stdcall;

  ippsMaxEvery_8u: function(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:Ipp32u):IppStatus;stdcall;
  ippsMaxEvery_16u: function(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:Ipp32u):IppStatus;stdcall;
  ippsMaxEvery_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:Ipp32u):IppStatus;stdcall;
  ippsMaxEvery_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:Ipp32u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippsMaxOrder
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
  ippsMaxOrder_16s: function(pSrc:PIpp16s;len:longint;pOrder:Plongint):IppStatus;stdcall;
  ippsMaxOrder_32s: function(pSrc:PIpp32s;len:longint;pOrder:Plongint):IppStatus;stdcall;
  ippsMaxOrder_32f: function(pSrc:PIpp32f;len:longint;pOrder:Plongint):IppStatus;stdcall;
  ippsMaxOrder_64f: function(pSrc:PIpp64f;len:longint;pOrder:Plongint):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Name:  ippsCountInRange_32s
//  Purpose: Computes the number of vector elements falling within the specified range.
//  Return:
//     ippStsNoErr       No errors, it's OK
//     ippStsNullPtrErr  Either pSrc or pCounts equals to zero.
//     ippStsLengthErr   The vector's length is less than or equals to zero.
//  Arguments:
//     pSrc              A pointer to the source vector.
//     len               Number of the vector elements.
//     pCounts           A pointer to the output result.
//     lowerBound        The upper boundary of the range.
//     uppreBound        The lower boundary of the range.
*)
  ippsCountInRange_32s: function(pSrc:PIpp32s;len:longint;pCounts:Plongint;lowerBound:Ipp32s;upperBound:Ipp32s):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////
//  Name:              ippsZeroCrossing
//  Purpose:           Counts the zero-cross measure for the input signal.
//
//  Parameters:
//    pSrc             Pointer to the input signal [len].
//    len              Number of elements in the input signal.
//    pValZCR          Pointer to the result value.
//    zcType           Zero crossing measure type.
//  Return:
//    ippStsNoErr      Indicates no error.
//    ippStsNullPtrErr Indicates an error when the pSrc or pRes pointer is null.
//    ippStsRangeErr   Indicates an error when zcType is not equal to
//                     ippZCR, ippZCXor or ippZCC
*)
  ippsZeroCrossing_16s32f: function(pSrc:PIpp16s;len:Ipp32u;pValZCR:PIpp32f;zcType:IppsZCType):IppStatus;stdcall;
  ippsZeroCrossing_32f: function(pSrc:PIpp32f;len:Ipp32u;pValZCR:PIpp32f;zcType:IppsZCType):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Sampling functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSampleUp
//  Purpose:    upsampling, i.e. expansion of input vector to get output vector
//              by simple adding zeroes between input elements
//  Parameters:
//   pSrc   (in)    pointer to the input vector
//   pDst   (in)    pointer to the output vector
//   srcLen (in)    length of input vector
//   pDstLen (out)  pointer to the length of output vector
//   factor (in)    the number of output elements, corresponding to one element
//                  of input vector.
//   pPhase(in-out) pointer to value, that is the position (0, ..., factor-1) of
//                  element from input vector in the group of factor elements of
//                  output vector. Out value is ready to continue upsampling with
//                  the same factor (out = in).
//
//  Return:
//   ippStsNullPtrErr        one or several pointers pSrc, pDst, pDstLen or pPhase
//                           is NULL
//   ippStsSizeErr           length of input vector is less or equal zero
//   ippStsSampleFactorErr   factor <= 0
//   ippStsSamplePhaseErr    *pPhase < 0 or *pPhase >= factor
//   ippStsNoErr             otherwise
*)
  ippsSampleUp_16s: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleUp_16sc: function(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleUp_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleUp_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleUp_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleUp_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsSampleDown
//  Purpose:    subsampling, i.e. only one of "factor" elements of input vector
//              are placed to output vector
//  Parameters:
//   pSrc   (in)    pointer to the input vector
//   pDst   (in)    pointer to the output vector
//   srcLen (in)    length of input vector
//   pDstLen (out)  pointer to the length of output vector
//   factor (in)    the number of input elements, corresponding to one element
//                  of output vector.
//   pPhase(in-out) pointer to value, that is the position (0, ..., factor-1) of
//                  chosen element in the group of "factor" elements. Out value
//                  of *pPhase is ready to continue subsampling with the same
//                  factor.
//
//  Return:
//   ippStsNullPtrErr        one or several pointers pSrc, pDst, pDstLen or pPhase
//                        is NULL
//   ippStsSizeErr           length of input vector is less or equal zero
//   ippStsSampleFactorErr   factor <= 0
//   ippStsSamplePhaseErr    *pPhase < 0 or *pPhase >=factor
//   ippStsNoErr             otherwise
*)
  ippsSampleDown_16s: function(pSrc:PIpp16s;srcLen:longint;pDst:PIpp16s;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleDown_16sc: function(pSrc:PIpp16sc;srcLen:longint;pDst:PIpp16sc;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleDown_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleDown_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleDown_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;
  ippsSampleDown_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;pDstLen:Plongint;factor:longint;pPhase:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Filtering
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                AutoCorrelation Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippsAutoCorrNormGetBufferSize
//
//  Purpose:     : Get the size (in bytes) of the buffer for ippsAutoCorrNorm's internal calculations.
//
//  Parameters:
//     srcLen      - Source vector length.
//     dstLen      - Length of auto-correlation.
//     dataType    - Data type for auto corelation {Ipp32f|Ipp32fc|Ipp64f|Ipp64fc}.
//     algType     - Selector for the algorithm type.  Possible values are the results of
//                   composition of the IppAlgType and IppsNormOp values.
//     pBufferSize - Pointer to the calculated buffer size (in bytes).
//  Return:
//   ippStsNoErr       - OK.
//   ippStsNullPtrErr  - pBufferSize is NULL.
//   ippStsSizeErr     - Vector's length is not positive.
//   ippStsDataTypeErr - Unsupported data type.
//   ippStsAlgTypeErr  - Unsupported algorithm or normalization type.
*)
  ippsAutoCorrNormGetBufferSize: function(srcLen:longint;dstLen:longint;dataType:IppDataType;algType:IppEnum;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsAutoCorrNorm
//  Purpose:    Calculate the auto-correlation,
//              ippNormNone specifies the normal auto-correlation.
//              ippNormA specifies the biased auto-correlation
//              (the resulting values are divided by srcLen).
//              ippNormB specifies the unbiased auto-correlation
//              (the resulting values are divided by ( srcLen - n ),
//              where "n" indicates current iteration).
//  Parameters:
//     pSrc    - Pointer to the source vector.
//     srcLen  - Source vector length.
//     pDst    - Pointer to the auto-correlation result vector.
//     dstLen  - Length of auto-correlation.
//     algType - Selector for the algorithm type. Possible values are the results
//               of composition of the  IppAlgType and IppsNormOp values.
//     pBuffer - Pointer to the buffer for internal calculations.
//  Return:
//   ippStsNoErr      - OK.
//   ippStsNullPtrErr - One of the pointers is NULL.
//   ippStsSizeErr    - Vector's length is not positive.
//   ippStsAlgTypeErr - Unsupported algorithm or normalization type.
*)
  ippsAutoCorrNorm_32f: function(pSrc:PIpp32f;srcLen:longint;pDst:PIpp32f;dstLen:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsAutoCorrNorm_64f: function(pSrc:PIpp64f;srcLen:longint;pDst:PIpp64f;dstLen:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsAutoCorrNorm_32fc: function(pSrc:PIpp32fc;srcLen:longint;pDst:PIpp32fc;dstLen:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsAutoCorrNorm_64fc: function(pSrc:PIpp64fc;srcLen:longint;pDst:PIpp64fc;dstLen:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                Cross-correlation Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippsCrossCorrNormGetBufferSize
//
//  Purpose:     Get the size (in bytes) of the buffer for ippsCrossCorrNorm's internal calculations.
//
//  Parameters:
//    src1Len     - Length of the first source vector.
//    src2Len     - Length of the second source vector.
//    dstLen      - Length of cross-correlation.
//    lowLag      - Cross-correlation lowest lag.
//    dataType    - Data type for correlation {Ipp32f|Ipp32fc|Ipp64f|Ipp64fc}.
//    algType     - Selector for the algorithm type. Possible values are the results of composition
//                  of the  IppAlgType and IppsNormOp values.
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//  Return:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - pBufferSize is NULL.
//    ippStsSizeErr     - Vector's length is not positive.
//    ippStsDataTypeErr - Unsupported data type.
//    ippStsAlgTypeErr  - Unsupported algorithm or normalization type.
*)
  ippsCrossCorrNormGetBufferSize: function(src1Len:longint;src2Len:longint;dstLen:longint;lowLag:longint;dataType:IppDataType;algType:IppEnum;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsCrossCorrNorm
//  Purpose:    Calculate the cross-correlation of two vectors.
//
//  Parameters:
//     pSrc1   - Pointer to the first source vector.
//     src1Len - Length of the first source vector.
//     pSrc2   - Pointer to the second source vector.
//     src2Len - Length of the second source vector.
//     pDst    - Pointer to the cross correlation.
//     dstLen  - Length of the cross-correlation.
//     lowLag  - Cross-correlation lowest lag.
//     algType - Selector for the algorithm type. Possible values are the results of composition
//               of the  IppAlgType and IppsNormOp values.
//     pBuffer - Pointer to the buffer for internal calculations.
//  Return:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - One of the pointers is NULL.
//    ippStsSizeErr    - Vector's length is not positive.
//    ippStsAlgTypeErr - Unsupported algorithm or normalization type.
*)
  ippsCrossCorrNorm_32f: function(pSrc1:PIpp32f;src1Len:longint;pSrc2:PIpp32f;src2Len:longint;pDst:PIpp32f;dstLen:longint;lowLag:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsCrossCorrNorm_64f: function(pSrc1:PIpp64f;src1Len:longint;pSrc2:PIpp64f;src2Len:longint;pDst:PIpp64f;dstLen:longint;lowLag:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsCrossCorrNorm_32fc: function(pSrc1:PIpp32fc;src1Len:longint;pSrc2:PIpp32fc;src2Len:longint;pDst:PIpp32fc;dstLen:longint;lowLag:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsCrossCorrNorm_64fc: function(pSrc1:PIpp64fc;src1Len:longint;pSrc2:PIpp64fc;src2Len:longint;pDst:PIpp64fc;dstLen:longint;lowLag:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Convolution functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippsConvolveGetBufferSize
//
//  Purpose:     Get the size (in bytes) of the buffer for ippsConvolve's internal calculations.
//
//  Parameters:
//    src1Len     - Length of the first source vector.
//    src2Len     - Length of the second source vector.
//    dataType    - Data type for convolution {Ipp32f|Ipp64f}.
//    algType     - Selector for the algorithm type. Contains IppAlgType values.
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//  Return:
//   ippStsNoErr       - OK
//   ippStsNullPtrErr  - pBufferSize is NULL.
//   ippStsSizeErr     - Vector's length is not positive.
//   ippStsDataTypeErr - Unsupported data type.
//   ippStsAlgTypeErr - Unsupported algorithm type.
*)
  ippsConvolveGetBufferSize: function(src1Len:longint;src2Len:longint;dataType:IppDataType;algType:IppEnum;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Name:       ippsConvolve_32f, ippsConvolve_64f
// Purpose:    Perform a linear convolution of 1D signals.
// Parameters:
//    pSrc1   - Pointer to the first source vector.
//    src1Len - Length of the first source vector.
//    pSrc2   - Pointer to the second source vector.
//    src2Len - Length of the second source vector.
//    pDst    - Pointer to the destination vector.
//    algType - Selector for the algorithm type. Contains IppAlgType values.
//    pBuffer - Pointer to the buffer for internal calculations.
// Returns:    IppStatus
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - One of the pointers is NULL.
//    ippStsSizeErr     - Vector's length is not positive.
//    ippStsAlgTypeErr  - Unsupported algorithm type.
//  Notes:
//          Length of the destination data vector is src1Len+src2Len-1.
//          The input signals are exchangeable because of the commutative
//          property of convolution.
//          Some other values may be returned the by FFT transform functions.
*)
  ippsConvolve_32f: function(pSrc1:PIpp32f;src1Len:longint;pSrc2:PIpp32f;src2Len:longint;pDst:PIpp32f;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsConvolve_64f: function(pSrc1:PIpp64f;src1Len:longint;pSrc2:PIpp64f;src2Len:longint;pDst:PIpp64f;algType:IppEnum;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsConvBiased_32f
//  Purpose:    Linear Convolution of 1D signals whith a bias.
//  Parameters:
//      pSrc1               pointer to the first source vector
//      pSrc2               pointer to the second source vector
//      src1Len             length of the first source vector
//      src2Len             length of the second source vector
//      pDst                pointer to the destination vector
//      dstLen              length of the destination vector
//      bias
//  Returns:    IppStatus
//      ippStsNullPtrErr        pointer(s) to the data is NULL
//      ippStsSizeErr           length of the vectors is less or equal zero
//      ippStsNoErr             otherwise
*)
  ippsConvBiased_32f: function(pSrc1:PIpp32f;src1Len:longint;pSrc2:PIpp32f;src2Len:longint;pDst:PIpp32f;dstLen:longint;bias:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Filtering
///////////////////////////////////////////////////////////////////////////// *)

(* ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Name:  ippsSumWindow_8u32f      ippsSumWindow_16s32f
//  Purpose:
//  Return:
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   one or more pointers are NULL
//    ippStsMaskSizeErr  maskSize has a field with zero, or negative value
//  Arguments:
//   pSrc        Pointer to the source vector
//   pDst        Pointer to the destination vector
//   maskSize    Size of the mask in pixels
*)
  ippsSumWindow_8u32f: function(pSrc:PIpp8u;pDst:PIpp32f;len:longint;maskSize:longint):IppStatus;stdcall;
  ippsSumWindow_16s32f: function(pSrc:PIpp16s;pDst:PIpp32f;len:longint;maskSize:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:         ippsFIRSRGetSize, ippsFIRSRInit, ippsFIRSR
//  Purpose:      Get sizes of the FIR spec structure and temporary buffer
//                initialize FIR spec structure - set taps and delay line
//                perform FIR filtering
//  Parameters:
//      pTaps       - pointer to the filter coefficients
//      tapsLen     - number of coefficients
//      tapsType    - type of coefficients (ipp32f or ipp64f)
//      pSpecSize   - pointer to the size of FIR spec
//      pBufSize    - pointer to the size of temporal buffer
//      algType     - mask for the algorithm type definition (direct, fft, auto)
//      pDlySrc     - pointer to the input  delay line values, can be NULL
//      pDlyDst     - pointer to the output delay line values, can be NULL
//      pSpec       - pointer to the constant internal structure
//      pSrc        - pointer to the source vector.
//      pDst        - pointer to the destination vector
//      numIters    - length  of the destination vector
//      pBuf        - pointer to the work buffer
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - one of the specified pointer is NULL
//         ippStsFIRLenErr        - tapsLen <= 0
//         ippStsContextMatchErr  - wrong state identifier
//         ippStsNoErr            - OK
//         ippStsSizeErr          - numIters is not positive
//         ippStsAlgTypeErr       - unsupported algorithm type
//         ippStsMismatch         - not effective algorithm.
*)
  ippsFIRSRGetSize: function(tapsLen:longint;tapsType:IppDataType;pSpecSize:Plongint;pBufSize:Plongint):IppStatus;stdcall;

  ippsFIRSRInit_32f: function(pTaps:PIpp32f;tapsLen:longint;algType:IppAlgType;pSpec:PIppsFIRSpec_32f):IppStatus;stdcall;
  ippsFIRSRInit_64f: function(pTaps:PIpp64f;tapsLen:longint;algType:IppAlgType;pSpec:PIppsFIRSpec_64f):IppStatus;stdcall;
  ippsFIRSRInit_32fc: function(pTaps:PIpp32fc;tapsLen:longint;algType:IppAlgType;pSpec:PIppsFIRSpec_32fc):IppStatus;stdcall;
  ippsFIRSRInit_64fc: function(pTaps:PIpp64fc;tapsLen:longint;algType:IppAlgType;pSpec:PIppsFIRSpec_64fc):IppStatus;stdcall;

  ippsFIRSR_16s: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pSpec:PIppsFIRSpec_32f;pDlySrc:PIpp16s;pDlyDst:PIpp16s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRSR_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pSpec:PIppsFIRSpec_32fc;pDlySrc:PIpp16sc;pDlyDst:PIpp16sc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRSR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pSpec:PIppsFIRSpec_32f;pDlySrc:PIpp32f;pDlyDst:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRSR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pSpec:PIppsFIRSpec_64f;pDlySrc:PIpp64f;pDlyDst:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRSR_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pSpec:PIppsFIRSpec_32fc;pDlySrc:PIpp32fc;pDlyDst:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRSR_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pSpec:PIppsFIRSpec_64fc;pDlySrc:PIpp64fc;pDlyDst:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:         ippsFIRMRGetSize, ippsFIRMRInit, ippsFIRMR
//  Purpose:      Get sizes of the FIR spec structure and temporary buffer,
//                initialize FIR spec structure - set taps and delay line,
//                perform multi rate FIR filtering
//  Parameters:
//      pTaps       - pointer to the filter coefficients
//      tapsLen     - number of coefficients
//      tapsType    - type of coefficients (ipp32f or ipp64f)
//      pSpecSize   - pointer to the size of FIR spec
//      pBufSize    - pointer to the size of temporal buffer
//      pDlySrc     - pointer to the input  delay line values, can be NULL
//      pDlyDst     - pointer to the output delay line values, can be NULL
//      upFactor    - multi-rate up factor;
//      upPhase     - multi-rate up phase;
//      downFactor  - multi-rate down factor;
//      downPhase   - multi-rate down phase;
//      pSpec       - pointer to the constant internal structure
//      pSrc        - pointer to the source vector.
//      pDst        - pointer to the destination vector
//      numIters    - length  of the destination vector
//      pBuf        - pointer to the work buffer
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - one of the specified pointer is NULL
//         ippStsFIRLenErr        - tapsLen <= 0
//         ippStsFIRMRFactorErr   - factor <= 0
//         ippStsFIRMRPhaseErr    - phase < 0 || factor <= phase
//         ippStsContextMatchErr  - wrong state identifier
//         ippStsNoErr            - OK
//         ippStsSizeErr          - numIters is not positive
*)
  ippsFIRMRGetSize: function(tapsLen:longint;upFactor:longint;downFactor:longint;tapsType:IppDataType;pSpecSize:Plongint;pBufSize:Plongint):IppStatus;stdcall;

  ippsFIRMRInit_32f: function(pTaps:PIpp32f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pSpec:PIppsFIRSpec_32f):IppStatus;stdcall;
  ippsFIRMRInit_64f: function(pTaps:PIpp64f;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pSpec:PIppsFIRSpec_64f):IppStatus;stdcall;
  ippsFIRMRInit_32fc: function(pTaps:PIpp32fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pSpec:PIppsFIRSpec_32fc):IppStatus;stdcall;
  ippsFIRMRInit_64fc: function(pTaps:PIpp64fc;tapsLen:longint;upFactor:longint;upPhase:longint;downFactor:longint;downPhase:longint;pSpec:PIppsFIRSpec_64fc):IppStatus;stdcall;

  ippsFIRMR_16s: function(pSrc:PIpp16s;pDst:PIpp16s;numIters:longint;pSpec:PIppsFIRSpec_32f;pDlySrc:PIpp16s;pDlyDst:PIpp16s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRMR_16sc: function(pSrc:PIpp16sc;pDst:PIpp16sc;numIters:longint;pSpec:PIppsFIRSpec_32fc;pDlySrc:PIpp16sc;pDlyDst:PIpp16sc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRMR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;numIters:longint;pSpec:PIppsFIRSpec_32f;pDlySrc:PIpp32f;pDlyDst:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRMR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;numIters:longint;pSpec:PIppsFIRSpec_64f;pDlySrc:PIpp64f;pDlyDst:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRMR_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;numIters:longint;pSpec:PIppsFIRSpec_32fc;pDlySrc:PIpp32fc;pDlyDst:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsFIRMR_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;numIters:longint;pSpec:PIppsFIRSpec_64fc;pDlySrc:PIpp64fc;pDlyDst:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsFIRSparseGetStateSize,
//                ippsFIRSparseInit
//  Purpose:      ippsFIRSparseGetStateSize - calculates the size of the FIRSparse
//                                            State  structure;
//                ippsFIRSparseInit - initialize FIRSparse state - set non-zero taps,
//                their positions and delay line using external memory buffer;
//  Parameters:
//      pNZTaps     - pointer to the non-zero filter coefficients;
//      pNZTapPos   - pointer to the positions of non-zero filter coefficients;
//      nzTapsLen   - number of non-zero coefficients;
//      pDlyLine    - pointer to the delay line values, can be NULL;
//      ppState     - pointer to the FIRSparse state created or NULL;
//      order       - order of FIRSparse filter
//      pStateSize  - pointer where to store the calculated FIRSparse State
//                    structuresize (in bytes);
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsFIRLenErr        - nzTapsLen <= 0
//         ippStsSparseErr        - non-zero tap positions are not in ascending order,
//                                  negative or repeated.
//         ippStsNoErr            - otherwise
*)
  ippsFIRSparseGetStateSize_32f: function(nzTapsLen:longint;order:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsFIRSparseInit_32f: function(var ppState:PIppsFIRSparseState_32f;pNZTaps:PIpp32f;pNZTapPos:PIpp32s;nzTapsLen:longint;pDlyLine:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsFIRSparse
//  Purpose:       FIRSparse filter with float taps. Vector filtering
//  Parameters:
//      pSrc        - pointer to the input vector
//      pDst        - pointer to the output vector
//      len         - length data vector
//      pState      - pointer to the filter state
//  Return:
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsSizeErr          - length of the vectors <= 0
//      ippStsNoErr            - otherwise
*)
  ippsFIRSparse_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsFIRSparseState_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsFIRSparseSetDlyLine_32f
//                 ippsFIRSparseGetDlyLine_32f
//  Purpose:       Get(set) delay line
//  Parameters:
//      pState      - pointer to the filter state
//      pDlyLine    - pointer to the delay line values, can be NULL;
//  Return:
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
*)
  ippsFIRSparseSetDlyLine_32f: function(pState:PIppsFIRSparseState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsFIRSparseGetDlyLine_32f: function(pState:PIppsFIRSparseState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFIRGenGetBufferSize
//
//  Purpose:    Gets the size (in bytes) of the buffer for ippsFIRGen internal calculations.
//
//  Parameters:
//    tapsLen     - The number of taps.
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when the length of coefficient's array is less than 5.
*)
  ippsFIRGenGetBufferSize: function(tapsLen:longint;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:     ippsFIRGen
//  Purpose:   This function computes the lowpass FIR filter coefficients
//              by windowing of ideal (infinite) filter coefficients segment.
//
// Parameters:
//    rFreq    - Cut off frequency (0 < rfreq < 0.5).
//    pTaps    - Pointer to the array which specifies the filter coefficients.
//    tapsLen  - The number of taps in pTaps[] array (tapsLen>=5).
//    winType  - The ippWindowType switch variable, which specifies the smoothing window type.
//    doNormal - If doNormal=0 the functions calculates non-normalized sequence of filter coefficients,
//               in other cases the sequence of coefficients will be normalized.
//    pBuffer  - Pointer to the buffer for internal calculations. The size calculates by ippsFIRGenGetBufferSize.
// Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when the length of coefficient's array is less than 5.
//    ippStsSizeErr    - Error when the low or high frequency isn't satisfy the condition 0 < rLowFreq < 0.5.
*)
  ippsFIRGenLowpass_64f: function(rFreq:Ipp64f;pTaps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGenHighpass_64f: function(rFreq:Ipp64f;pTaps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFIRGenBandpass_64f: function(rLowFreq:Ipp64f;rHighFreq:Ipp64f;pTaps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRGenBandstop_64f: function(rLowFreq:Ipp64f;rHighFreq:Ipp64f;pTaps:PIpp64f;tapsLen:longint;winType:IppWinType;doNormal:IppBool;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  FIR LMS filters
///////////////////////////////////////////////////////////////////////////// *)

(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsFIRLMSGetStateSize, ippsFIRLMSInit
//  Purpose:      ippsFIRLMSGetStateSize - calculates the size of the FIR State
//                                                                   structure;
//                ippsFIRLMSInit - initialize FIR state - set taps and delay line
//                using external memory buffer;
//  Parameters:
//      pTaps       - pointer to the filter coefficients;
//      tapsLen     - number of coefficients;
//      dlyIndex      current index value for the delay line
//      pDlyLine    - pointer to the delay line values, can be NULL;
//      ppState     - pointer to the FIR state created or NULL;
//      pStateSize  - pointer where to store the calculated FIR State structure
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsFIRLenErr        - tapsLen <= 0
//         ippStsNoErr            - otherwise
*)
  ippsFIRLMSGetStateSize32f_16s: function(tapsLen:longint;dlyIndex:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFIRLMSGetStateSize_32f: function(tapsLen:longint;dlyIndex:longint;pBufferSize:Plongint):IppStatus;stdcall;

  ippsFIRLMSInit32f_16s: function(var ppState:PIppsFIRLMSState32f_16s;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp16s;dlyIndex:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFIRLMSInit_32f: function(var ppState:PIppsFIRLMSState_32f;pTaps:PIpp32f;tapsLen:longint;pDlyLine:PIpp32f;dlyIndex:longint;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//   Names:      ippsFIRLMS
//   Purpose:    LMS filtering
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
  ippsFIRLMS32f_16s: function(pSrc:PIpp16s;pRef:PIpp16s;pDst:PIpp16s;len:longint;mu:single;pState:PIppsFIRLMSState32f_16s):IppStatus;stdcall;
  ippsFIRLMS_32f: function(pSrc:PIpp32f;pRef:PIpp32f;pDst:PIpp32f;len:longint;mu:single;pState:PIppsFIRLMSState_32f):IppStatus;stdcall;

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
  ippsFIRLMSGetTaps32f_16s: function(pState:PIppsFIRLMSState32f_16s;pOutTaps:PIpp32f):IppStatus;stdcall;
  ippsFIRLMSGetTaps_32f: function(pState:PIppsFIRLMSState_32f;pOutTaps:PIpp32f):IppStatus;stdcall;

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
  ippsFIRLMSGetDlyLine32f_16s: function(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;pDlyLineIndex:Plongint):IppStatus;stdcall;
  ippsFIRLMSGetDlyLine_32f: function(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;pDlyLineIndex:Plongint):IppStatus;stdcall;

  ippsFIRLMSSetDlyLine32f_16s: function(pState:PIppsFIRLMSState32f_16s;pDlyLine:PIpp16s;dlyLineIndex:longint):IppStatus;stdcall;
  ippsFIRLMSSetDlyLine_32f: function(pState:PIppsFIRLMSState_32f;pDlyLine:PIpp32f;dlyLineIndex:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                     IIR filters (float and double taps versions)
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                          Work with Delay Line
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
  ippsIIRGetDlyLine32f_16s: function(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRGetDlyLine32fc_16sc: function(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRGetDlyLine_32f: function(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRGetDlyLine_32fc: function(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRGetDlyLine64f_16s: function(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRGetDlyLine64fc_16sc: function(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRGetDlyLine64f_32s: function(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRGetDlyLine64fc_32sc: function(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRGetDlyLine64f_DF1_32s: function(pState:PIppsIIRState64f_32s;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIRGetDlyLine64f_32f: function(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRGetDlyLine64fc_32fc: function(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRGetDlyLine_64f: function(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRGetDlyLine_64fc: function(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;stdcall;

  ippsIIRSetDlyLine32f_16s: function(pState:PIppsIIRState32f_16s;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRSetDlyLine32fc_16sc: function(pState:PIppsIIRState32fc_16sc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRSetDlyLine_32f: function(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRSetDlyLine_32fc: function(pState:PIppsIIRState_32fc;pDlyLine:PIpp32fc):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_16s: function(pState:PIppsIIRState64f_16s;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine64fc_16sc: function(pState:PIppsIIRState64fc_16sc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_32s: function(pState:PIppsIIRState64f_32s;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine64fc_32sc: function(pState:PIppsIIRState64fc_32sc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_DF1_32s: function(pState:PIppsIIRState64f_32s;pDlyLine:PIpp32s):IppStatus;stdcall;
  ippsIIRSetDlyLine64f_32f: function(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine64fc_32fc: function(pState:PIppsIIRState64fc_32fc;pDlyLine:PIpp64fc):IppStatus;stdcall;
  ippsIIRSetDlyLine_64f: function(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRSetDlyLine_64fc: function(pState:PIppsIIRState_64fc;pDlyLine:PIpp64fc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  IIR Filtering
///////////////////////////////////////////////////////////////////////////// *)

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

  ippsIIR32f_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32f_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState32f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32fc_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR32fc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState32fc_16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR_32f_I: function(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIR_32fc_I: function(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;stdcall;
  ippsIIR_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState_32fc):IppStatus;stdcall;
  ippsIIR64f_16s_ISfs: function(pSrcDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64f_16s_Sfs: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;pState:PIppsIIRState64f_16s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_16sc_ISfs: function(pSrcDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_16sc_Sfs: function(pSrc:PIpp16sc;pDst:PIpp16sc;len:longint;pState:PIppsIIRState64fc_16sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64f_32s_ISfs: function(pSrcDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64f_32s_Sfs: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;pState:PIppsIIRState64f_32s;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_32sc_ISfs: function(pSrcDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64fc_32sc_Sfs: function(pSrc:PIpp32sc;pDst:PIpp32sc;len:longint;pState:PIppsIIRState64fc_32sc;scaleFactor:longint):IppStatus;stdcall;
  ippsIIR64f_32f_I: function(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIR64f_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIR64fc_32fc_I: function(pSrcDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;
  ippsIIR64fc_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;len:longint;pState:PIppsIIRState64fc_32fc):IppStatus;stdcall;
  ippsIIR_64f_I: function(pSrcDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIR_64fc_I: function(pSrcDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;stdcall;
  ippsIIR_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;len:longint;pState:PIppsIIRState_64fc):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsIIR_32f_P, ippsIIR64f_32s_P
//  Purpose:       IIR filter for multi-channel data. Vector filtering.
//  Parameters:
//      ppSrc               - pointer to array of pointers to source vectors
//      ppDst               - pointer to array of pointers to destination vectors
//      ppSrcDst            - pointer to array of source/destination vectors in in-place ops
//      len                 - length of the vectors
//      nChannels           - number of processing channels
//      ppState             - pointer to array of filter contexts
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsSizeErr          - length of the vectors <= 0
//      ippStsChannelErr       - number of processing channels <= 0
//      ippStsNoErr            - otherwise
//
*)
  ippsIIR_32f_IP: function(var ppSrcDst:PIpp32f;len:longint;nChannels:longint;var ppState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIR_32f_P: function(var ppSrc:PIpp32f;var ppDst:PIpp32f;len:longint;nChannels:longint;var ppState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIR64f_32s_IPSfs: function(var ppSrcDst:PIpp32s;len:longint;nChannels:longint;var ppState:PIppsIIRState64f_32s;pScaleFactor:Plongint):IppStatus;stdcall;
  ippsIIR64f_32s_PSfs: function(var ppSrc:PIpp32s;var ppDst:PIpp32s;len:longint;nChannels:longint;var ppState:PIppsIIRState64f_32s;pScaleFactor:Plongint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//          Initialize IIR state with external memory buffer
//////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsIIRGetStateSize, ippsIIRInit
//  Purpose:      ippsIIRGetStateSize - calculates the size of the IIR State structure;
//                ippsIIRInit - initialize IIR state - set taps and delay line
//                using external memory buffer;
//  Parameters:
//      pTaps       - pointer to the filter coefficients;
//      order       - order of the filter;
//      numBq       - order of the filter;
//      pDlyLine    - pointer to the delay line values, can be NULL;
//      ppState     - double pointer to the IIR state created or NULL;
//      tapsFactor  - scaleFactor for taps (integer version);
//      pBufferSize - pointer where to store the calculated IIR State structure
//                                                             size (in bytes);
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsIIROrderErr      - order <= 0 or numBq < 1
//         ippStsNoErr            - otherwise
*)
  ippsIIRGetStateSize32f_16s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32fc_16sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_32fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_16s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_16sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_32s: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_32sc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_32fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_64f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_64fc: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;

  ippsIIRGetStateSize32f_BiQuad_16s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize32fc_BiQuad_16sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_32f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_DF1_32f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_32fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_16s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_BiQuad_16sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_32s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_DF1_32s: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_BiQuad_32sc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64f_BiQuad_32f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize64fc_BiQuad_32fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_64f: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRGetStateSize_BiQuad_64fc: function(numBq:longint;pBufferSize:Plongint):IppStatus;stdcall;

  ippsIIRInit32f_16s: function(var ppState:PIppsIIRState32f_16s;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32fc_16sc: function(var ppState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_32f: function(var ppState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_32fc: function(var ppState:PIppsIIRState_32fc;pTaps:PIpp32fc;order:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_16s: function(var ppState:PIppsIIRState64f_16s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_16sc: function(var ppState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_32s: function(var ppState:PIppsIIRState64f_32s;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_32sc: function(var ppState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_32f: function(var ppState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_32fc: function(var ppState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_64f: function(var ppState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_64fc: function(var ppState:PIppsIIRState_64fc;pTaps:PIpp64fc;order:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;

  ippsIIRInit32f_BiQuad_16s: function(var ppState:PIppsIIRState32f_16s;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit32fc_BiQuad_16sc: function(var ppState:PIppsIIRState32fc_16sc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_32f: function(var ppState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_DF1_32f: function(var ppState:PIppsIIRState_32f;pTaps:PIpp32f;numBq:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_32fc: function(var ppState:PIppsIIRState_32fc;pTaps:PIpp32fc;numBq:longint;pDlyLine:PIpp32fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_16s: function(var ppState:PIppsIIRState64f_16s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_BiQuad_16sc: function(var ppState:PIppsIIRState64fc_16sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_32s: function(var ppState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_DF1_32s: function(var ppState:PIppsIIRState64f_32s;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp32s;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_BiQuad_32sc: function(var ppState:PIppsIIRState64fc_32sc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64f_BiQuad_32f: function(var ppState:PIppsIIRState64f_32f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit64fc_BiQuad_32fc: function(var ppState:PIppsIIRState64fc_32fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_64f: function(var ppState:PIppsIIRState_64f;pTaps:PIpp64f;numBq:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRInit_BiQuad_64fc: function(var ppState:PIppsIIRState_64fc;pTaps:PIpp64fc;numBq:longint;pDlyLine:PIpp64fc;pBuf:PIpp8u):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsIIRSparseGetStateSize,
//                ippsIIRSparseInit
//  Purpose:      ippsIIRSparseGetStateSize - calculates the size of the
//                                            IIRSparse State structure;
//                ippsIIRSparseInit - initialize IIRSparse state - set non-zero taps,
//                their positions and delay line using external memory buffer;
//  Parameters:
//      pNZTaps     - pointer to the non-zero filter coefficients;
//      pNZTapPos   - pointer to the positions of non-zero filter coefficients;
//      nzTapsLen1,
//      nzTapsLen2  - number of non-zero coefficients according to the IIRSparseformula;
//      pDlyLine    - pointer to the delay line values, can be NULL;
//      ppState     - pointer to the IIR state created or NULL;
//      pStateSize  - pointer where to store the calculated IIR State structure
//                                                             size (in bytes);
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr       - pointer(s) to the data is NULL
//         ippStsIIROrderErr      - nzTapsLen1 <= 0 or nzTapsLen2 < 0
//         ippStsSparseErr        - non-zero tap positions are not in ascending order,
//                                  negative or repeated.
//         ippStsNoErr            - otherwise
*)
  ippsIIRSparseGetStateSize_32f: function(nzTapsLen1:longint;nzTapsLen2:longint;order1:longint;order2:longint;pStateSize:Plongint):IppStatus;stdcall;
  ippsIIRSparseInit_32f: function(var ppState:PIppsIIRSparseState_32f;pNZTaps:PIpp32f;pNZTapPos:PIpp32s;nzTapsLen1:longint;nzTapsLen2:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsIIRSparse
//  Purpose:       IIRSparse filter with float taps. Vector filtering
//  Parameters:
//      pSrc                - pointer to input vector
//      pDst                - pointer to output vector
//      len                 - length of the vectors
//      pState              - pointer to the filter state
//  Return:
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsSizeErr          - length of the vectors <= 0
//      ippStsNoErr            - otherwise
*)
  ippsIIRSparse_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRSparseState_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsIIRGenLowpass_64f, ippsIIRGenHighpass_64f
//
//  Purpose:    This function computes the highpass and lowpass IIR filter coefficients
//
//  Parameters:
//    rFreq       - Cut off frequency (0 < rFreq < 0.5).
//    ripple      - Possible ripple in pass band for ippChebyshev1 type of filter.
//    order       - The order of future filter (1 <= order <= 12).
//    pTaps       - Pointer to the array which specifies the filter coefficients.
//    filterType  - Type of required filter (ippButterworth or ippChebyshev1).
//    pBuffer     - Pointer to the buffer for internal calculations. The size calculates by ippsIIRGenGetBufferSize.
//
//  Returns:
//    ippStsNoErr                - OK.
//    ippStsNullPtrErr           - Error when any of the specified pointers is NULL.
//    ippStsIIRPassbandRippleErr - Error when the ripple in passband for Chebyshev1 design is less zero, equal to zero or greater than 29.
//    ippStsFilterFrequencyErr   - Error when the cut of frequency of filter is less zero, equal to zero or greater than 0.5.
//    ippStsIIRGenOrderErr       - Error when the order of an IIR filter for design them is less than one or greater than 12.
*)
  ippsIIRGenLowpass_64f: function(rFreq:Ipp64f;ripple:Ipp64f;order:longint;pTaps:PIpp64f;filterType:IppsIIRFilterType;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsIIRGenHighpass_64f: function(rFreq:Ipp64f;ripple:Ipp64f;order:longint;pTaps:PIpp64f;filterType:IppsIIRFilterType;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsIIRGenGetBufferSize
//
//  Purpose:    Gets the size (in bytes) of the buffer for ippsIIRGen internal calculations.
//
//  Parameters:
//    order       - The order of future filter (1 <= order <= 12).
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//
//  Returns:
//    ippStsNoErr                - OK.
//    ippStsNullPtrErr           - Error when any of the specified pointers is NULL.
//    ippStsIIRGenOrderErr       - Error when the order of an IIR filter for design them is less than one or greater than 12.
*)
  ippsIIRGenGetBufferSize: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Median filter
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFilterMedianGetBufferSize
//  Purpose:    Get sizes of working buffer for functions ipsFilterMedian
//  Parameters:
//   maskSize           median mask size (odd)
//   dataType           data type
//   pBufferSize        pointer to buffer size
//  Return:
//   ippStsNullPtrErr              pointer to pBufferSize is NULL
//   ippStsMaskSizeErr             maskSize is is less or equal zero
//   ippStsDataTypeErr             data type is incorrect or not supported.
//   ippStsNoErr                   otherwise
*)
  ippsFilterMedianGetBufferSize: function(maskSize:longint;dataType:IppDataType;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsFilterMedian
//  Purpose:    filter source data by the Median Filter
//  Parameters:
//   pSrcDst            pointer to the source and destinaton vector
//   pSrc               pointer to the source vector
//   pDst               pointer to the destination vector
//   len                length of the vector(s)
//   maskSize           median mask size (odd)
//   pDlySrc            pointer to the input  delay line values (length is (maskSize-1)), can be NULL
//   pDlyDst            pointer to the output delay line values (length is (maskSize-1)), can be NULL
//   pBuffer            pointer to the work buffer
//  Return:
//   ippStsNullPtrErr              pointer(s) to the data is NULL
//   ippStsSizeErr                 length of the vector(s) is less or equal zero
//   ippStsMaskSizeErr             maskSize is is less or equal zero
//   ippStsEvenMedianMaskSize      median mask size is even warning
//   ippStsNoErr                   otherwise
//  Notes:
//   if pDlySrc is NULL for all i < 0 pSrc[i] = pSrc[0]
*)
  ippsFilterMedian_8u_I: function(pSrcDst:PIpp8u;len:longint;maskSize:longint;pDlySrc:PIpp8u;pDlyDst:PIpp8u;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_8u: function(pSrc:PIpp8u;pDst:PIpp8u;len:longint;maskSize:longint;pDlySrc:PIpp8u;pDlyDst:PIpp8u;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_16s_I: function(pSrcDst:PIpp16s;len:longint;maskSize:longint;pDlySrc:PIpp16s;pDlyDst:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_16s: function(pSrc:PIpp16s;pDst:PIpp16s;len:longint;maskSize:longint;pDlySrc:PIpp16s;pDlyDst:PIpp16s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_32s_I: function(pSrcDst:PIpp32s;len:longint;maskSize:longint;pDlySrc:PIpp32s;pDlyDst:PIpp32s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_32s: function(pSrc:PIpp32s;pDst:PIpp32s;len:longint;maskSize:longint;pDlySrc:PIpp32s;pDlyDst:PIpp32s;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_32f_I: function(pSrcDst:PIpp32f;len:longint;maskSize:longint;pDlySrc:PIpp32f;pDlyDst:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;maskSize:longint;pDlySrc:PIpp32f;pDlyDst:PIpp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_64f_I: function(pSrcDst:PIpp64f;len:longint;maskSize:longint;pDlySrc:PIpp64f;pDlyDst:PIpp64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFilterMedian_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;maskSize:longint;pDlySrc:PIpp64f;pDlyDst:PIpp64f;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsResamplePolyphase, ippsResamplePolyphaseFixed
//  Purpose:        Resample input data.
//   Arguments:
//      pSrc      The pointer to the input vector.
//      pDst      The pointer to the output vector.
//      len       The number of input vector elements to resample.
//      norm      The norming factor for output samples.
//      factor    The resampling factor.
//      pTime     The pointer to the start time of resampling (in input vector elements).
//      pOutlen   The number of calculated output vector elements
//      pSpec     The pointer to the resampling specification structure.
//   Return Value
//      ippStsNoErr        Indicates no error.
//      ippStsNullPtrErr   Indicates an error when pSpec, pSrc, pDst, pTime or pOutlen is NULL.
//      ippStsSizeErr      Indicates an error when len is less than or equal to 0.
//      ippStsBadArgErr    Indicates an error when factor is less than or equal to.
*)
  ippsResamplePolyphase_16s: function(pSrc:PIpp16s;len:longint;pDst:PIpp16s;factor:Ipp64f;norm:Ipp32f;pTime:PIpp64f;pOutlen:Plongint;pSpec:PIppsResamplingPolyphase_16s):IppStatus;stdcall;
  ippsResamplePolyphase_32f: function(pSrc:PIpp32f;len:longint;pDst:PIpp32f;factor:Ipp64f;norm:Ipp32f;pTime:PIpp64f;pOutlen:Plongint;pSpec:PIppsResamplingPolyphase_32f):IppStatus;stdcall;

  ippsResamplePolyphaseFixed_16s: function(pSrc:PIpp16s;len:longint;pDst:PIpp16s;norm:Ipp32f;pTime:PIpp64f;pOutlen:Plongint;pSpec:PIppsResamplingPolyphaseFixed_16s):IppStatus;stdcall;
  ippsResamplePolyphaseFixed_32f: function(pSrc:PIpp32f;len:longint;pDst:PIpp32f;norm:Ipp32f;pTime:PIpp64f;pOutlen:Plongint;pSpec:PIppsResamplingPolyphaseFixed_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsResamplePolyphaseGetSize, ippsResamplePolyphaseFixedGetSize
//  Purpose:        Determines the size required for the ResamplePolyphase or ResamplePolyphaseFixed.
//   Arguments:
//      window          The size of the ideal lowpass filter window.
//      nStep           The discretization step for filter coefficients
//      inRate          The input rate for resampling with fixed factor.
//      outRate         The output rate for resampling with fixed factor.
//      len             The filter length for resampling with fixed factor.
//      pSize           Required size in bytes
//      pLen            Filter len
//      pHeight         Number of filter
//      hint            Suggests using specific code. The values for the hint argument are described in "Flag and Hint Arguments"
//
//   Return Value
//      ippStsNoErr       Indicates no error.
//      ippStsNullPtrErr  Indicates an error when pSize, pLen or pHeight are NULL.
//      ippStsSizeErr     Indicates an error when inRate, outRate or len is less than or equal to 0.
*)
  ippsResamplePolyphaseGetSize_16s: function(window:Ipp32f;nStep:longint;pSize:Plongint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsResamplePolyphaseGetSize_32f: function(window:Ipp32f;nStep:longint;pSize:Plongint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsResamplePolyphaseFixedGetSize_16s: function(inRate:longint;outRate:longint;len:longint;pSize:Plongint;pLen:Plongint;pHeight:Plongint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsResamplePolyphaseFixedGetSize_32f: function(inRate:longint;outRate:longint;len:longint;pSize:Plongint;pLen:Plongint;pHeight:Plongint;hint:IppHintAlgorithm):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsResamplePolyphaseInit, ippsResamplePolyphaseFixedInit
//  Purpose:        Initializes ResamplePolyphase of ResamplePolyphaseFixed structures
//   Arguments:
//      window          The size of the ideal lowpass filter window.
//      nStep           The discretization step for filter coefficients
//      inRate          The input rate for resampling with fixed factor.
//      outRate         The output rate for resampling with fixed factor.
//      len             The filter length for resampling with fixed factor.
//      rollf           The roll-off frequency of the filter.
//      alpha           The parameter of the Kaiser window.
//      pSpec           The pointer to the resampling specification structure to be created.
//      hint            Suggests using specific code. The values for the hint argument are described in "Flag and Hint Arguments"
//   Return Value
//      ippStsNoErr       Indicates no error.
//      ippStsNullPtrErr  Indicates an error when pSpec is NULL.
//      ippStsSizeErr     Indicates an error when inRate, outRate or len is less than or equal to 0.
//
*)
  ippsResamplePolyphaseInit_16s: function(window:Ipp32f;nStep:longint;rollf:Ipp32f;alpha:Ipp32f;pSpec:PIppsResamplingPolyphase_16s;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsResamplePolyphaseInit_32f: function(window:Ipp32f;nStep:longint;rollf:Ipp32f;alpha:Ipp32f;pSpec:PIppsResamplingPolyphase_32f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippsResamplePolyphaseFixedInit_16s: function(inRate:longint;outRate:longint;len:longint;rollf:Ipp32f;alpha:Ipp32f;pSpec:PIppsResamplingPolyphaseFixed_16s;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippsResamplePolyphaseFixedInit_32f: function(inRate:longint;outRate:longint;len:longint;rollf:Ipp32f;alpha:Ipp32f;pSpec:PIppsResamplingPolyphaseFixed_32f;hint:IppHintAlgorithm):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsResamplePolyphaseSetFixedFilter
//  Purpose:        Set filter coefficient
//   Arguments:
//      pSpec           The pointer to the resampling specification structure to be created.
//      pSrc            Input vector of filter coefficients [height][step]
//      step            Lenght of filter
//      height          Number of filter
//   Return Value
//      ippStsNoErr       Indicates no error.
//      ippStsNullPtrErr  Indicates an error when pSpec or pSrc are NULL.
//      ippStsSizeErr     Indicates an error when step or height is less than or equal to 0.
*)
  ippsResamplePolyphaseSetFixedFilter_16s: function(pSrc:PIpp16s;step:longint;height:longint;pSpec:PIppsResamplingPolyphaseFixed_16s):IppStatus;stdcall;
  ippsResamplePolyphaseSetFixedFilter_32f: function(pSrc:PIpp32f;step:longint;height:longint;pSpec:PIppsResamplingPolyphaseFixed_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippsResamplePolyphaseGetFixedFilter
//  Purpose:        Get filter coefficient
//   Arguments:
//      pSpec           The pointer to the resampling specification structure to be created.
//      pDst            Input vector of filter coefficients [height][step]
//      step            Lenght of filter
//      height          Number of filter
//   Return Value
//      ippStsNoErr       Indicates no error.
//      ippStsNullPtrErr  Indicates an error when pSpec or pSrc are NULL.
//      ippStsSizeErr     Indicates an error when step or height is less than or equal to 0.
*)
  ippsResamplePolyphaseGetFixedFilter_16s: function(pDst:PIpp16s;step:longint;height:longint;pSpec:PIppsResamplingPolyphaseFixed_16s):IppStatus;stdcall;
  ippsResamplePolyphaseGetFixedFilter_32f: function(pDst:PIpp32f;step:longint;height:longint;pSpec:PIppsResamplingPolyphaseFixed_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  IIRIIR filters (analogue of FILTFILT)
///////////////////////////////////////////////////////////////////////////// *)

(* ////////////////////////////////////////////////////////////////////////////
//          Initialize IIRIIR state, calculate required memory buffer size
//////////////////////////////////////////////////////////////////////////// *)

(* ////////////////////////////////////////////////////////////////////////////
//  Name:         ippsIIRIIRGetStateSize,
//                ippsIIRIIRInit
//  Purpose:      ippsIIRIIRGetStateSize - calculates the size of the IIRIIR State structure;
//                ippsIIRIIRInit         - initializes IIRIIR state structure
//                and delay line using external memory buffer;
//  Parameters:
//      pTaps       - pointer to the filter coefficients;
//      order       - order of the filter;
//      pDlyLine    - pointer to the delay line, can be NULL;
//      ppState     - double pointer to the IIRIIR state;
//      tapsFactor  - scaleFactor for taps (integer version);
//      pBufferSize - pointer where to store the calculated IIRIIR
//                                 State structure size (in bytes);
//   Return:
//      status      - status value returned, its value are
//         ippStsNullPtrErr   - pointer(s) ppState or pTaps is NULL;
//                              if IIRIIRInit is called with pDlyLine==NULL then
//                              it forms delay line itself that minimizes start-up
//                              and ending transients by matching initial
//                              conditions to remove DC offset at beginning
//                              and end of input vector.
//         ippStsIIROrderErr  - order <= 0
//         ippStsDivByZeroErr - a0 == 0.0 ( pTaps[order+1] == 0.0 )
//         ippStsNoErr        - otherwise
//  Note: 
//    Order of taps = b0,b1,...,bN,a0,a1,...,aN
//    N = order
//    Delay line is in the Direct Form II format
//
*)
  ippsIIRIIRGetStateSize_32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRIIRGetStateSize64f_32f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsIIRIIRGetStateSize_64f: function(order:longint;pBufferSize:Plongint):IppStatus;stdcall;

  ippsIIRIIRInit64f_32f: function(var ppState:PIppsIIRState64f_32f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRIIRInit_32f: function(var ppState:PIppsIIRState_32f;pTaps:PIpp32f;order:longint;pDlyLine:PIpp32f;pBuf:PIpp8u):IppStatus;stdcall;
  ippsIIRIIRInit_64f: function(var ppState:PIppsIIRState_64f;pTaps:PIpp64f;order:longint;pDlyLine:PIpp64f;pBuf:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  IIRIIR Filtering
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:         ippsIIRIIR
//  Purpose:       performs zero-phase digital IIR filtering by processing
//   the input vector in both the forward and reverse directions. After filtering
//   the data in the forward direction, IIRIIR runs the filtered sequence in the
//   reverse (flipped) order back through the filter. The result has the following
//   characteristics:
//       - Zero-phase distortion
//       - A filter transfer function is equal to the squared magnitude of the
//         original IIR transfer function
//       - A filter order that is double the specified IIR order
//  Parameters:
//      pState              - pointer to filter context
//      pSrcDst             - pointer to input/output vector in in-place ops
//      pSrc                - pointer to input vector
//      pDst                - pointer to output vector
//      len                 - length of the vectors
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) to the data is NULL
//      ippStsLengthErr        - length of the vectors < 3*(IIR order)
//      ippStsNoErr            - otherwise
//
*)
  ippsIIRIIR_32f_I: function(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIRIIR_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState_32f):IppStatus;stdcall;
  ippsIIRIIR64f_32f_I: function(pSrcDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIRIIR64f_32f: function(pSrc:PIpp32f;pDst:PIpp32f;len:longint;pState:PIppsIIRState64f_32f):IppStatus;stdcall;
  ippsIIRIIR_64f_I: function(pSrcDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;stdcall;
  ippsIIRIIR_64f: function(pSrc:PIpp64f;pDst:PIpp64f;len:longint;pState:PIppsIIRState_64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  IIRIIR - Work with Delay Line
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsIIRIIRGetDlyLine, ippsIIRIIRSetDlyLine
//  Purpose:    set or get delay line
//  Parameters:
//      pState              - pointer to IIR filter context
//      pDlyLine            - pointer where from load or where to store delay line
//  Return:
//      ippStsContextMatchErr  - wrong context identifier
//      ippStsNullPtrErr       - pointer(s) pState or pDelay is NULL
//                               if IIRIIRSet is called with pDlyLine==NULL then
//                               the function forms delay line itself that minimizes
//                               start-up and ending transients by matching initial
//                               conditions to remove DC offset at beginning
//                               and end of input vector.
//      ippStsNoErr            - otherwise
*)
  ippsIIRIIRGetDlyLine64f_32f: function(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRIIRSetDlyLine64f_32f: function(pState:PIppsIIRState64f_32f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRIIRGetDlyLine_32f: function(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRIIRSetDlyLine_32f: function(pState:PIppsIIRState_32f;pDlyLine:PIpp32f):IppStatus;stdcall;
  ippsIIRIIRGetDlyLine_64f: function(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;
  ippsIIRIIRSetDlyLine_64f: function(pState:PIppsIIRState_64f;pDlyLine:PIpp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Linear Transform
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for FFT Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Get Size Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTGetSize_C, ippsFFTGetSize_R
//  Purpose:    Computes the size of the FFT context structure and the size
of the required work buffer (in bytes)
//  Arguments:
//     order      Base-2 logarithm of the number of samples in FFT
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pSizeSpec  Pointer to the size value of FFT specification structure
//     pSizeInit  Pointer to the size value of the buffer for FFT initialization function
//     pSizeBuf   Pointer to the size value of the FFT external work buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsFftOrderErr      FFT order value is illegal
//     ippStsFFTFlagErr       Incorrect normalization flag value
*)
  ippsFFTGetSize_C_32f: function(order:longint;flag:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFFTGetSize_R_32f: function(order:longint;flag:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFFTGetSize_C_32fc: function(order:longint;flag:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFFTGetSize_C_64f: function(order:longint;flag:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFFTGetSize_R_64f: function(order:longint;flag:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsFFTGetSize_C_64fc: function(order:longint;flag:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTInit_C, ippsFFTInit_R
//  Purpose:    Initializes the FFT context structure
//  Arguments:
//     order        Base-2 logarithm of the number of samples in FFT
//     flag         Flag to choose the results normalization factors
//     hint         Option to select the algorithmic implementation of the transform
//                  function
//     ppFFTSpec    Double pointer to the FFT specification structure to be created
//     pSpec        Pointer to the FFT specification structure
//     pSpecBuffer  Pointer to the temporary work buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsFftOrderErr      FFT order value is illegal
//     ippStsFFTFlagErr       Incorrect normalization flag value
*)

  ippsFFTInit_C_32f: function(var ppFFTSpec:PIppsFFTSpec_C_32f;order:longint;flag:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInit_R_32f: function(var ppFFTSpec:PIppsFFTSpec_R_32f;order:longint;flag:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInit_C_32fc: function(var ppFFTSpec:PIppsFFTSpec_C_32fc;order:longint;flag:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInit_C_64f: function(var ppFFTSpec:PIppsFFTSpec_C_64f;order:longint;flag:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInit_R_64f: function(var ppFFTSpec:PIppsFFTSpec_R_64f;order:longint;flag:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInit_C_64fc: function(var ppFFTSpec:PIppsFFTSpec_C_64fc;order:longint;flag:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Complex Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTFwd_CToC, ippsFFTInv_CToC
//  Purpose:    Computes forward and inverse FFT of a complex signal
//  Arguments:
//     pFFTSpec     Pointer to the FFT context
//     pSrc         Pointer to the source complex signal
//     pDst         Pointer to the destination complex signal
//     pSrcRe       Pointer to the real      part of source signal
//     pSrcIm       Pointer to the imaginary part of source signal
//     pDstRe       Pointer to the real      part of destination signal
//     pDstIm       Pointer to the imaginary part of destination signal
//     pSrcDst      Pointer to the complex signal
//     pSrcDstRe    Pointer to the real      part of signal
//     pSrcDstIm    Pointer to the imaginary part of signal
//     pBuffer      Pointer to the work buffer
//     scaleFactor  Scale factor for output result
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation fails
*)
  ippsFFTFwd_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_CToC_32fc_I: function(pSrcDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_32fc_I: function(pSrcDst:PIpp32fc;pFFTSpec:PIppsFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_64fc_I: function(pSrcDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_64fc_I: function(pSrcDst:PIpp64fc;pFFTSpec:PIppsFFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_CToC_32f_I: function(pSrcDstRe:PIpp32f;pSrcDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_32f_I: function(pSrcDstRe:PIpp32f;pSrcDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_64f_I: function(pSrcDstRe:PIpp64f;pSrcDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_64f_I: function(pSrcDstRe:PIpp64f;pSrcDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsFFTFwd_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pFFTSpec:PIppsFFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pFFTSpec:PIppsFFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Real Packed Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsFFTFwd_RToPerm, ippsFFTFwd_RToPack, ippsFFTFwd_RToCCS
//              ippsFFTInv_PermToR, ippsFFTInv_PackToR, ippsFFTInv_CCSToR
//  Purpose:    Computes forward and inverse FFT of a real signal
//              using Perm, Pack or Ccs packed format
//  Arguments:
//     pFFTSpec       Pointer to the FFT context
//     pSrc           Pointer to the source signal
//     pDst           Pointer to thedestination signal
//     pSrcDst        Pointer to the source/destination signal (in-place)
//     pBuffer        Pointer to the work buffer
//     scaleFactor    Scale factor for output result
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation fails
*)
  ippsFFTFwd_RToPerm_32f_I: function(pSrcDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToPack_32f_I: function(pSrcDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToCCS_32f_I: function(pSrcDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PermToR_32f_I: function(pSrcDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PackToR_32f_I: function(pSrcDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CCSToR_32f_I: function(pSrcDst:PIpp32f;pFFTSpec:PIppsFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToPerm_64f_I: function(pSrcDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToPack_64f_I: function(pSrcDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTFwd_RToCCS_64f_I: function(pSrcDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PermToR_64f_I: function(pSrcDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_PackToR_64f_I: function(pSrcDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsFFTInv_CCSToR_64f_I: function(pSrcDst:PIpp64f;pFFTSpec:PIppsFFTSpec_R_64f;pBuffer:PIpp8u):IppStatus;stdcall;

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
//                  Definitions for DFT Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTGetSize_C, ippsDFTGetSize_R
//  Purpose:    Computes the size of the DFT context structure and the size
of the required work buffer (in bytes)
//  Arguments:
//     length     Length of the DFT transform
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pSizeSpec  Pointer to the size value of DFT specification structure
//     pSizeInit  Pointer to the size value of the buffer for DFT initialization function
//     pSizeBuf   Pointer to the size value of the DFT external work buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsOrderErr         Invalid length value
//     ippStsFFTFlagErr       Incorrect normalization flag value
//     ippStsSizeErr          Indicates an error when length is less than or equal to 0
*)
  ippsDFTGetSize_C_32f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;stdcall;
  ippsDFTGetSize_R_32f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;stdcall;
  ippsDFTGetSize_C_32fc: function(length:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;stdcall;
  ippsDFTGetSize_C_64f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;stdcall;
  ippsDFTGetSize_R_64f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;stdcall;
  ippsDFTGetSize_C_64fc: function(length:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Init Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTInit_C, ippsDFTInit_R
//  Purpose:    initialize of DFT context
//  Arguments:
//     length     Length of the DFT transform
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pDFTSpec   Double pointer to the DFT context structure
//     pMemInit   Pointer to initialization buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsOrderErr         Invalid length value
//     ippStsFFTFlagErr       Incorrect normalization flag value
//     ippStsSizeErr          Indicates an error when length is less than or equal to 0
*)
  ippsDFTInit_C_32f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppsDFTSpec_C_32f;pMemInit:PIpp8u):IppStatus;stdcall;
  ippsDFTInit_R_32f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppsDFTSpec_R_32f;pMemInit:PIpp8u):IppStatus;stdcall;
  ippsDFTInit_C_32fc: function(length:longint;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppsDFTSpec_C_32fc;pMemInit:PIpp8u):IppStatus;stdcall;
  ippsDFTInit_C_64f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppsDFTSpec_C_64f;pMemInit:PIpp8u):IppStatus;stdcall;
  ippsDFTInit_R_64f: function(length:longint;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppsDFTSpec_R_64f;pMemInit:PIpp8u):IppStatus;stdcall;
  ippsDFTInit_C_64fc: function(length:longint;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppsDFTSpec_C_64fc;pMemInit:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Complex Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTFwd_CToC, ippsDFTInv_CToC
//  Purpose:    Computes forward and inverse DFT of a complex signal
//  Arguments:
//     pDFTSpec     Pointer to the DFT context
//     pSrc         Pointer to the source complex signal
//     pDst         Pointer to the destination complex signal
//     pSrcRe       Pointer to the real      part of source signal
//     pSrcIm       Pointer to the imaginary part of source signal
//     pDstRe       Pointer to the real      part of destination signal
//     pDstIm       Pointer to the imaginary part of destination signal
//     pBuffer      Pointer to the work buffer
//     scaleFactor  Scale factor for output result
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation fails
*)
  ippsDFTFwd_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_32fc: function(pSrc:PIpp32fc;pDst:PIpp32fc;pDFTSpec:PIppsDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_64fc: function(pSrc:PIpp64fc;pDst:PIpp64fc;pDFTSpec:PIppsDFTSpec_C_64fc;pBuffer:PIpp8u):IppStatus;stdcall;

  ippsDFTFwd_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_32f: function(pSrcRe:PIpp32f;pSrcIm:PIpp32f;pDstRe:PIpp32f;pDstIm:PIpp32f;pDFTSpec:PIppsDFTSpec_C_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTFwd_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDFTInv_CToC_64f: function(pSrcRe:PIpp64f;pSrcIm:PIpp64f;pDstRe:PIpp64f;pDstIm:PIpp64f;pDFTSpec:PIppsDFTSpec_C_64f;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Real Packed Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDFTFwd_RToPerm, ippsDFTFwd_RToPack, ippsDFTFwd_RToCCS
//              ippsDFTInv_PermToR, ippsDFTInv_PackToR, ippsDFTInv_CCSToR
//  Purpose:    Compute forward and inverse DFT of a real signal
//              using Perm, Pack or Ccs packed format
//  Arguments:
//     pFFTSpec       Pointer to the DFT context
//     pSrc           Pointer to the source signal
//     pDst           Pointer to the destination signal
//     pSrcDst        Pointer to the source/destination signal (in-place)
//     pBuffer        Pointer to the work buffer
//     scaleFactor    Scale factor for output result
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       At least one of pointers is NULL
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation fails
*)
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
//   len                vector's length
//   scaleFactor        scale factor
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data is NULL
//   ippStsSizeErr         vector`s length is less or equal zero
//   ippStsNoErr           otherwise
*)
  ippsMulPack_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulPerm_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulPack_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulPerm_32f: function(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulPack_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulPerm_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulPack_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;
  ippsMulPerm_64f: function(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:              ippsMulPackConj
//  Purpose:            multiply on a complex conjugate vector and store in RCPack format
//  Parameters:
//   pSrc               pointer to input vector (in-place case)
//   pSrcDst            pointer to output vector (in-place case)
//   len                vector's length
//  Return:
//   ippStsNullPtrErr      pointer(s) to the data is NULL
//   ippStsSizeErr         vector`s length is less or equal zero
//   ippStsNoErr           otherwise
*)
  ippsMulPackConj_32f_I: function(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsMulPackConj_64f_I: function(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;stdcall;

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
  ippsGoertz_16s_Sfs: function(pSrc:PIpp16s;len:longint;pVal:PIpp16sc;rFreq:Ipp32f;scaleFactor:longint):IppStatus;stdcall;
  ippsGoertz_16sc_Sfs: function(pSrc:PIpp16sc;len:longint;pVal:PIpp16sc;rFreq:Ipp32f;scaleFactor:longint):IppStatus;stdcall;
  ippsGoertz_32f: function(pSrc:PIpp32f;len:longint;pVal:PIpp32fc;rFreq:Ipp32f):IppStatus;stdcall;
  ippsGoertz_32fc: function(pSrc:PIpp32fc;len:longint;pVal:PIpp32fc;rFreq:Ipp32f):IppStatus;stdcall;
  ippsGoertz_64f: function(pSrc:PIpp64f;len:longint;pVal:PIpp64fc;rFreq:Ipp64f):IppStatus;stdcall;
  ippsGoertz_64fc: function(pSrc:PIpp64fc;len:longint;pVal:PIpp64fc;rFreq:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DCT Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Get Size Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDCTFwdGetSize, ippsDCTInvGetSize
//  Purpose:    get sizes of the DCTSpec and buffers (in bytes)
//  Arguments:
//     len             - number of samples in DCT
//     hint            - code specific use hints
//     pSpecSize       - where write size of DCTSpec
//     pSpecBufferSize - where write size of buffer for DCTInit functions
//     pBufferSize     - where write size of buffer for DCT calculation
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pSpecSize == NULL or pSpecBufferSize == NULL or
//                            pBufferSize == NULL
//     ippStsSizeErr          bad the len value
*)
  ippsDCTFwdGetSize_32f: function(len:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsDCTInvGetSize_32f: function(len:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsDCTFwdGetSize_64f: function(len:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;
  ippsDCTInvGetSize_64f: function(len:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pSpecBufferSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDCTFwdInit, ippsDCTInvInit
//  Purpose:    initialize of DCT context
//  Arguments:
//     len         - number of samples in DCT
//     hint        - code specific use hints
//     ppDCTSpec   - where write pointer to new context
//     pSpec       - pointer to area for DCTSpec
//     pSpecBuffer - pointer to work buffer
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       ppDCTSpec == NULL or
//                            pSpec == NULL or pMemInit == NULL
//     ippStsSizeErr          bad the len value
*)
  ippsDCTFwdInit_32f: function(var ppDCTSpec:PIppsDCTFwdSpec_32f;len:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInvInit_32f: function(var ppDCTSpec:PIppsDCTInvSpec_32f;len:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTFwdInit_64f: function(var ppDCTSpec:PIppsDCTFwdSpec_64f;len:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInvInit_64f: function(var ppDCTSpec:PIppsDCTInvSpec_64f;len:longint;hint:IppHintAlgorithm;pSpec:PIpp8u;pSpecBuffer:PIpp8u):IppStatus;stdcall;

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
//     pSrcDst  - pointer to signal
//     pBuffer  - pointer to work buffer
//     scaleFactor
//              - scale factor for output result
//  Return:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL or
//                            pSrc == NULL or pDst == NULL or pSrcDst == NULL
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)
  ippsDCTFwd_32f_I: function(pSrcDst:PIpp32f;pDCTSpec:PIppsDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_32f_I: function(pSrcDst:PIpp32f;pDCTSpec:PIppsDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTFwd_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_32f: function(pSrc:PIpp32f;pDst:PIpp32f;pDCTSpec:PIppsDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTFwd_64f_I: function(pSrcDst:PIpp64f;pDCTSpec:PIppsDCTFwdSpec_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_64f_I: function(pSrcDst:PIpp64f;pDCTSpec:PIppsDCTInvSpec_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTFwd_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTFwdSpec_64f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippsDCTInv_64f: function(pSrc:PIpp64f;pDst:PIpp64f;pDCTSpec:PIppsDCTInvSpec_64f;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for Hilbert Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
// Name:       ippsHilbertGetSize
// Purpose:    Get sizes (in bytes) of the IppsHilbertSpec spec structure and temporary buffer.
// Parameters:
//    length      - Number of samples in Hilbert.
//    hint        - Option to select the algorithmic implementation of the transform function (DFT).
//    pSpecSize   - Pointer to the calculated spec size (in bytes).
//    pSizeBuf    - Pointer to the calculated size of the external work buffer.
//  Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length is less than 1.
*)
  ippsHilbertGetSize_32f32fc: function(length:longint;hint:IppHintAlgorithm;pSpecSize:Plongint;pBufferSize:Plongint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Name:       ippsHilbertInit
// Purpose:    initializes Hilbert context structure.
// Parameters:
//    length      - Number of samples in Hilbert.
//    hint        - Option to select the algorithmic implementation of the transform function (DFT).
//    pSpec       - Pointer to Hilbert context.
//    pBuffer     - Pointer to the buffer for internal calculations.
//  Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when length is less than 1.
*)
  ippsHilbertInit_32f32fc: function(length:longint;hint:IppHintAlgorithm;pSpec:PIppsHilbertSpec;pBuffer:PIpp8u):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
// Name:       ippsHilbert
// Purpose:    Computes Hilbert transform of the real signal.
// Arguments:
//    pSrc         - Pointer to source real signal
//    pDst         - Pointer to destination complex signal
//    pSpec        - Pointer to Hilbert context.
//    pBuffer      - Pointer to the buffer for internal calculations.
//    scaleFactor  - Scale factor for output signal.
// Return:
//    ippStsNoErr           - OK.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsContextMatchErr - Error when pSpec initialized incorect.
*)
  ippsHilbert_32f32fc: function(pSrc:PIpp32f;pDst:PIpp32fc;pSpec:PIppsHilbertSpec;pBuffer:PIpp8u):IppStatus;stdcall;

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
  ippsWTHaarFwd_16s_Sfs: function(pSrc:PIpp16s;len:longint;pDstLow:PIpp16s;pDstHigh:PIpp16s;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarFwd_32f: function(pSrc:PIpp32f;len:longint;pDstLow:PIpp32f;pDstHigh:PIpp32f):IppStatus;stdcall;
  ippsWTHaarFwd_64f: function(pSrc:PIpp64f;len:longint;pDstLow:PIpp64f;pDstHigh:PIpp64f):IppStatus;stdcall;

  ippsWTHaarInv_16s_Sfs: function(pSrcLow:PIpp16s;pSrcHigh:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;stdcall;
  ippsWTHaarInv_32f: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;stdcall;
  ippsWTHaarInv_64f: function(pSrcLow:PIpp64f;pSrcHigh:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Fucntions for User Filter Banks
///////////////////////////////////////////////////////////////////////////// *)

(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdGetSize
//
// Purpose:      Get sizes, in bytes, of the ippsWTFwd state structure.
//
// Parameters:
//   srcType   - Data type of the source vector.
//   lenLow    - Length of lowpass filter.
//   offsLow   - Input delay of lowpass filter.
//   lenHigh   - Length of highpass filter.
//   offsHigh  - Input delay of highpass filter.
//   pStateSize- Pointer to the size of the ippsWTFwd state structure (in bytes).
//
// Returns:
//   ippStsNoErr        - Ok.
//   ippStsNullPtrErr   - Error when any of the specified pointers is NULL.
//   ippStsSizeErr      - Error when filters length is negative, or equal to zero.
//   ippStsWtOffsetErr  - Error when filter delay is less than (-1).
*)
  ippsWTFwdGetSize: function(srcType:IppDataType;lenLow:longint;offsLow:longint;lenHigh:longint;offsHigh:longint;pStateSize:Plongint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTFwdInit
//
// Purpose:     Initialize forward wavelet transform state structure.
//
// Parameters:
//   pState    - Pointer to allocated ippsWTFwd state structure.
//   pTapsLow  - Pointer to lowpass filter taps.
//   lenLow    - Length of lowpass filter.
//   offsLow   - Input delay of lowpass filter.
//   pTapsHigh - Pointer to highpass filter taps.
//   lenHigh   - Length of highpass filter.
//   offsHigh  - Input delay of highpass filter.
//
// Returns:
//   ippStsNoErr        - Ok.
//   ippStsNullPtrErr   - Error when any of the specified pointers is NULL.
//   ippStsSizeErr      - Error when filters length is negative, or equal to zero.
//   ippStsWtOffsetErr  - Error when filter delay is less than (-1).
*)
  ippsWTFwdInit_8u32f: function(pState:PIppsWTFwdState_8u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;
  ippsWTFwdInit_16s32f: function(pState:PIppsWTFwdState_16s32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;
  ippsWTFwdInit_16u32f: function(pState:PIppsWTFwdState_16u32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;
  ippsWTFwdInit_32f: function(pState:PIppsWTFwdState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

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
  ippsWTFwdSetDlyLine_8u32f: function(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTFwdSetDlyLine_16s32f: function(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTFwdSetDlyLine_16u32f: function(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTFwdSetDlyLine_32f: function(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

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
  ippsWTFwdGetDlyLine_8u32f: function(pState:PIppsWTFwdState_8u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTFwdGetDlyLine_16s32f: function(pState:PIppsWTFwdState_16s32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTFwdGetDlyLine_16u32f: function(pState:PIppsWTFwdState_16u32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTFwdGetDlyLine_32f: function(pState:PIppsWTFwdState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

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
  ippsWTFwd_8u32f: function(pSrc:PIpp8u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_8u32f):IppStatus;stdcall;
  ippsWTFwd_16s32f: function(pSrc:PIpp16s;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16s32f):IppStatus;stdcall;
  ippsWTFwd_16u32f: function(pSrc:PIpp16u;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_16u32f):IppStatus;stdcall;
  ippsWTFwd_32f: function(pSrc:PIpp32f;pDstLow:PIpp32f;pDstHigh:PIpp32f;dstLen:longint;pState:PIppsWTFwdState_32f):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvGetSize
//
// Purpose:      Get sizes, in bytes, of the ippsWTInv state structure.
//
// Parameters:
//   dstType   - Data type of the destination vector.
//   lenLow    - Length of lowpass filter.
//   offsLow   - Input delay of lowpass filter.
//   lenHigh   - Length of highpass filter.
//   offsHigh  - Input delay of highpass filter.
//   pStateSize- Pointer to the size of the ippsWTInv state structure (in bytes).
//
// Returns:
//   ippStsNoErr        - Ok.
//   ippStsNullPtrErr   - Error when any of the specified pointers is NULL.
//   ippStsSizeErr      - Error when filters length is negative, or equal to zero.
//   ippStsWtOffsetErr  - Error when filter delay is less than (-1).
*)
  ippsWTInvGetSize: function(dstType:IppDataType;lenLow:longint;offsLow:longint;lenHigh:longint;offsHigh:longint;pStateSize:Plongint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInvInit
//
// Purpose:     Initialize inverse wavelet transform state structure.
//
// Parameters:
//   pState    - Pointer to allocated ippsWTInv state structure.
//   pTapsLow  - Pointer to lowpass filter taps.
//   lenLow    - Length of lowpass filter.
//   offsLow   - Input delay of lowpass filter.
//   pTapsHigh - Pointer to highpass filter taps.
//   lenHigh   - Length of highpass filter.
//   offsHigh  - Input delay of highpass filter.
//
// Returns:
//   ippStsNoErr        - Ok.
//   ippStsNullPtrErr   - Error when any of the specified pointers is NULL.
//   ippStsSizeErr      - Error when filters length is negative, or equal to zero.
//   ippStsWtOffsetErr  - Error when filter delay is less than (-1).
*)
  ippsWTInvInit_32f8u: function(pState:PIppsWTInvState_32f8u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;
  ippsWTInvInit_32f16u: function(pState:PIppsWTInvState_32f16u;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;
  ippsWTInvInit_32f16s: function(pState:PIppsWTInvState_32f16s;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;
  ippsWTInvInit_32f: function(pState:PIppsWTInvState_32f;pTapsLow:PIpp32f;lenLow:longint;offsLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;offsHigh:longint):IppStatus;stdcall;

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
  ippsWTInvSetDlyLine_32f8u: function(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTInvSetDlyLine_32f16s: function(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTInvSetDlyLine_32f16u: function(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTInvSetDlyLine_32f: function(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

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
  ippsWTInvGetDlyLine_32f8u: function(pState:PIppsWTInvState_32f8u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTInvGetDlyLine_32f16s: function(pState:PIppsWTInvState_32f16s;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTInvGetDlyLine_32f16u: function(pState:PIppsWTInvState_32f16u;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;
  ippsWTInvGetDlyLine_32f: function(pState:PIppsWTInvState_32f;pDlyLow:PIpp32f;pDlyHigh:PIpp32f):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippsWTInv_32f, ippsWTInv_32f16s, ippsWTInv_32f16u,
//              ippsWTInv_32f8u
//
// Purpose:     Inverse wavelet transform.
//
// Parameters:
//   srcLow  - pointer to source block of "low-frequency" component;
//   srcHigh - pointer to source block of "high-frequency" component;
//   dstLen  - length of components.
//   dst     - pointer to destination block of reconstructed data;
//   pState  - pointer to pState structure;
//
//  Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers to pDst pSrcLow or pSrcHigh vectors are NULL;
//   ippStsSizeErr          - the length is less or equal zero;
//   ippStspStateMatchErr   - mismatch pState structure.
//
// Notes:      destination block length must be 2 * srcLen.
*)
  ippsWTInv_32f8u: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp8u;pState:PIppsWTInvState_32f8u):IppStatus;stdcall;
  ippsWTInv_32f16s: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16s;pState:PIppsWTInvState_32f16s):IppStatus;stdcall;
  ippsWTInv_32f16u: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp16u;pState:PIppsWTInvState_32f16u):IppStatus;stdcall;
  ippsWTInv_32f: function(pSrcLow:PIpp32f;pSrcHigh:PIpp32f;srcLen:longint;pDst:PIpp32f;pState:PIppsWTInvState_32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippsReplaceNAN
//  Purpose:    replaces the vector elements with NAN value by6 constant value
//  Parameters:
//   pSrcDst            pointer to the source/destination vector
//   len                length of the vector(s), number of items
//   value              value to be assigned to vector elements which are NAN
//  Return:
//   ippStsNullPtrErr      pointer to source/destination vector is NULL
//   ippStsSizeErr         length of a vector is less or equal 0
//   ippStsNoErr           otherwise
*)
  ippsReplaceNAN_32f_I: function(pSrcDst:PIpp32f;len:longint;value:Ipp32f):IppStatus;stdcall;
  ippsReplaceNAN_64f_I: function(pSrcDst:PIpp64f;len:longint;value:Ipp64f):IppStatus;stdcall;


(*   #if defined (_IPP_STDCALL_CDECL)
#undef  _IPP_STDCALL_CDECL
#define __stdcall __cdecl
#endif  *)


(*   #ifdef __cplusplus
}
#endif  *)



IMPLEMENTATION

var
  hh:Thandle;


function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
end;

procedure InitIPPS1;
begin
  ippsGetLibVersion:=getProc(hh,'ippsGetLibVersion');

  ippsMalloc:=   getProc(hh,'ippsMalloc_8u');
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
  ippsCopy_32s:=getProc(hh,'ippsCopy_32s');
  ippsCopy_32sc:=getProc(hh,'ippsCopy_32sc');
  ippsCopy_64s:=getProc(hh,'ippsCopy_64s');
  ippsCopy_64sc:=getProc(hh,'ippsCopy_64sc');
  ippsCopyLE_1u:=getProc(hh,'ippsCopyLE_1u');
  ippsCopyBE_1u:=getProc(hh,'ippsCopyBE_1u');
  ippsMove_8u:=getProc(hh,'ippsMove_8u');
  ippsMove_16s:=getProc(hh,'ippsMove_16s');
  ippsMove_16sc:=getProc(hh,'ippsMove_16sc');
  ippsMove_32f:=getProc(hh,'ippsMove_32f');
  ippsMove_32fc:=getProc(hh,'ippsMove_32fc');
  ippsMove_64f:=getProc(hh,'ippsMove_64f');
  ippsMove_64fc:=getProc(hh,'ippsMove_64fc');
  ippsMove_32s:=getProc(hh,'ippsMove_32s');
  ippsMove_32sc:=getProc(hh,'ippsMove_32sc');
  ippsMove_64s:=getProc(hh,'ippsMove_64s');
  ippsMove_64sc:=getProc(hh,'ippsMove_64sc');
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
  ippsZero_8u:=getProc(hh,'ippsZero_8u');
  ippsZero_16s:=getProc(hh,'ippsZero_16s');
  ippsZero_16sc:=getProc(hh,'ippsZero_16sc');
  ippsZero_32f:=getProc(hh,'ippsZero_32f');
  ippsZero_32fc:=getProc(hh,'ippsZero_32fc');
  ippsZero_64f:=getProc(hh,'ippsZero_64f');
  ippsZero_64fc:=getProc(hh,'ippsZero_64fc');
  ippsZero_32s:=getProc(hh,'ippsZero_32s');
  ippsZero_32sc:=getProc(hh,'ippsZero_32sc');
  ippsZero_64s:=getProc(hh,'ippsZero_64s');
  ippsZero_64sc:=getProc(hh,'ippsZero_64sc');
  ippsTone_16s:=getProc(hh,'ippsTone_16s');
  ippsTone_16sc:=getProc(hh,'ippsTone_16sc');
  ippsTone_32f:=getProc(hh,'ippsTone_32f');
  ippsTone_32fc:=getProc(hh,'ippsTone_32fc');
  ippsTone_64f:=getProc(hh,'ippsTone_64f');
  ippsTone_64fc:=getProc(hh,'ippsTone_64fc');
  ippsTriangle_64f:=getProc(hh,'ippsTriangle_64f');
  ippsTriangle_64fc:=getProc(hh,'ippsTriangle_64fc');
  ippsTriangle_32f:=getProc(hh,'ippsTriangle_32f');
  ippsTriangle_32fc:=getProc(hh,'ippsTriangle_32fc');
  ippsTriangle_16s:=getProc(hh,'ippsTriangle_16s');
  ippsTriangle_16sc:=getProc(hh,'ippsTriangle_16sc');
  ippsRandUniform_8u:=getProc(hh,'ippsRandUniform_8u');
  ippsRandUniform_16s:=getProc(hh,'ippsRandUniform_16s');
  ippsRandUniform_32f:=getProc(hh,'ippsRandUniform_32f');
  ippsRandUniform_64f:=getProc(hh,'ippsRandUniform_64f');
  ippsRandGauss_8u:=getProc(hh,'ippsRandGauss_8u');
  ippsRandGauss_16s:=getProc(hh,'ippsRandGauss_16s');
  ippsRandGauss_32f:=getProc(hh,'ippsRandGauss_32f');
  ippsRandGauss_64f:=getProc(hh,'ippsRandGauss_64f');
  ippsRandGaussGetSize_8u:=getProc(hh,'ippsRandGaussGetSize_8u');
  ippsRandGaussGetSize_16s:=getProc(hh,'ippsRandGaussGetSize_16s');
  ippsRandGaussGetSize_32f:=getProc(hh,'ippsRandGaussGetSize_32f');
  ippsRandGaussGetSize_64f:=getProc(hh,'ippsRandGaussGetSize_64f');
  ippsRandGaussInit_8u:=getProc(hh,'ippsRandGaussInit_8u');
  ippsRandGaussInit_16s:=getProc(hh,'ippsRandGaussInit_16s');
  ippsRandGaussInit_32f:=getProc(hh,'ippsRandGaussInit_32f');
  ippsRandGaussInit_64f:=getProc(hh,'ippsRandGaussInit_64f');
  ippsRandUniformGetSize_8u:=getProc(hh,'ippsRandUniformGetSize_8u');
  ippsRandUniformGetSize_16s:=getProc(hh,'ippsRandUniformGetSize_16s');
  ippsRandUniformGetSize_32f:=getProc(hh,'ippsRandUniformGetSize_32f');
  ippsRandUniformGetSize_64f:=getProc(hh,'ippsRandUniformGetSize_64f');
  ippsRandUniformInit_8u:=getProc(hh,'ippsRandUniformInit_8u');
  ippsRandUniformInit_16s:=getProc(hh,'ippsRandUniformInit_16s');
  ippsRandUniformInit_32f:=getProc(hh,'ippsRandUniformInit_32f');
  ippsRandUniformInit_64f:=getProc(hh,'ippsRandUniformInit_64f');
  ippsVectorJaehne_8u:=getProc(hh,'ippsVectorJaehne_8u');
  ippsVectorJaehne_16u:=getProc(hh,'ippsVectorJaehne_16u');
  ippsVectorJaehne_16s:=getProc(hh,'ippsVectorJaehne_16s');
  ippsVectorJaehne_32s:=getProc(hh,'ippsVectorJaehne_32s');
  ippsVectorJaehne_32f:=getProc(hh,'ippsVectorJaehne_32f');
  ippsVectorJaehne_64f:=getProc(hh,'ippsVectorJaehne_64f');
  ippsVectorSlope_8u:=getProc(hh,'ippsVectorSlope_8u');
  ippsVectorSlope_16u:=getProc(hh,'ippsVectorSlope_16u');
  ippsVectorSlope_16s:=getProc(hh,'ippsVectorSlope_16s');
  ippsVectorSlope_32u:=getProc(hh,'ippsVectorSlope_32u');
  ippsVectorSlope_32s:=getProc(hh,'ippsVectorSlope_32s');
  ippsVectorSlope_32f:=getProc(hh,'ippsVectorSlope_32f');
  ippsVectorSlope_64f:=getProc(hh,'ippsVectorSlope_64f');
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
  ippsAddC_8u_ISfs:=getProc(hh,'ippsAddC_8u_ISfs');
  ippsAddC_8u_Sfs:=getProc(hh,'ippsAddC_8u_Sfs');
  ippsAddC_16s_I:=getProc(hh,'ippsAddC_16s_I');
  ippsAddC_16s_ISfs:=getProc(hh,'ippsAddC_16s_ISfs');
  ippsAddC_16s_Sfs:=getProc(hh,'ippsAddC_16s_Sfs');
  ippsAddC_16sc_ISfs:=getProc(hh,'ippsAddC_16sc_ISfs');
  ippsAddC_16sc_Sfs:=getProc(hh,'ippsAddC_16sc_Sfs');
  ippsAddC_16u_ISfs:=getProc(hh,'ippsAddC_16u_ISfs');
  ippsAddC_16u_Sfs:=getProc(hh,'ippsAddC_16u_Sfs');
  ippsAddC_32s_ISfs:=getProc(hh,'ippsAddC_32s_ISfs');
  ippsAddC_32s_Sfs:=getProc(hh,'ippsAddC_32s_Sfs');
  ippsAddC_32sc_ISfs:=getProc(hh,'ippsAddC_32sc_ISfs');
  ippsAddC_32sc_Sfs:=getProc(hh,'ippsAddC_32sc_Sfs');
  ippsAddC_64u_Sfs:=getProc(hh,'ippsAddC_64u_Sfs');
  ippsAddC_64s_Sfs:=getProc(hh,'ippsAddC_64s_Sfs');
  ippsAddC_32f_I:=getProc(hh,'ippsAddC_32f_I');
  ippsAddC_32f:=getProc(hh,'ippsAddC_32f');
  ippsAddC_32fc_I:=getProc(hh,'ippsAddC_32fc_I');
  ippsAddC_32fc:=getProc(hh,'ippsAddC_32fc');
  ippsAddC_64f_I:=getProc(hh,'ippsAddC_64f_I');
  ippsAddC_64f:=getProc(hh,'ippsAddC_64f');
  ippsAddC_64fc_I:=getProc(hh,'ippsAddC_64fc_I');
  ippsAddC_64fc:=getProc(hh,'ippsAddC_64fc');
  ippsAdd_8u_ISfs:=getProc(hh,'ippsAdd_8u_ISfs');
  ippsAdd_8u_Sfs:=getProc(hh,'ippsAdd_8u_Sfs');
  ippsAdd_8u16u:=getProc(hh,'ippsAdd_8u16u');
  ippsAdd_16s_I:=getProc(hh,'ippsAdd_16s_I');
  ippsAdd_16s:=getProc(hh,'ippsAdd_16s');
  ippsAdd_16s_ISfs:=getProc(hh,'ippsAdd_16s_ISfs');
  ippsAdd_16s_Sfs:=getProc(hh,'ippsAdd_16s_Sfs');
  ippsAdd_16s32s_I:=getProc(hh,'ippsAdd_16s32s_I');
  ippsAdd_16s32f:=getProc(hh,'ippsAdd_16s32f');
  ippsAdd_16sc_ISfs:=getProc(hh,'ippsAdd_16sc_ISfs');
  ippsAdd_16sc_Sfs:=getProc(hh,'ippsAdd_16sc_Sfs');
  ippsAdd_16u_ISfs:=getProc(hh,'ippsAdd_16u_ISfs');
  ippsAdd_16u_Sfs:=getProc(hh,'ippsAdd_16u_Sfs');
  ippsAdd_16u:=getProc(hh,'ippsAdd_16u');
  ippsAdd_32s_ISfs:=getProc(hh,'ippsAdd_32s_ISfs');
  ippsAdd_32s_Sfs:=getProc(hh,'ippsAdd_32s_Sfs');
  ippsAdd_32sc_ISfs:=getProc(hh,'ippsAdd_32sc_ISfs');
  ippsAdd_32sc_Sfs:=getProc(hh,'ippsAdd_32sc_Sfs');
  ippsAdd_32u:=getProc(hh,'ippsAdd_32u');
  ippsAdd_64s_Sfs:=getProc(hh,'ippsAdd_64s_Sfs');
  ippsAdd_32f_I:=getProc(hh,'ippsAdd_32f_I');
  ippsAdd_32f:=getProc(hh,'ippsAdd_32f');
  ippsAdd_32fc_I:=getProc(hh,'ippsAdd_32fc_I');
  ippsAdd_32fc:=getProc(hh,'ippsAdd_32fc');
  ippsAdd_64f_I:=getProc(hh,'ippsAdd_64f_I');
  ippsAdd_64f:=getProc(hh,'ippsAdd_64f');
  ippsAdd_64fc_I:=getProc(hh,'ippsAdd_64fc_I');
  ippsAdd_64fc:=getProc(hh,'ippsAdd_64fc');
  ippsAddProductC_32f:=getProc(hh,'ippsAddProductC_32f');
  ippsAddProduct_16s_Sfs:=getProc(hh,'ippsAddProduct_16s_Sfs');
  ippsAddProduct_16s32s_Sfs:=getProc(hh,'ippsAddProduct_16s32s_Sfs');
  ippsAddProduct_32s_Sfs:=getProc(hh,'ippsAddProduct_32s_Sfs');
  ippsAddProduct_32f:=getProc(hh,'ippsAddProduct_32f');
  ippsAddProduct_32fc:=getProc(hh,'ippsAddProduct_32fc');
  ippsAddProduct_64f:=getProc(hh,'ippsAddProduct_64f');
  ippsAddProduct_64fc:=getProc(hh,'ippsAddProduct_64fc');
  ippsMulC_8u_ISfs:=getProc(hh,'ippsMulC_8u_ISfs');
  ippsMulC_8u_Sfs:=getProc(hh,'ippsMulC_8u_Sfs');
  ippsMulC_16s_I:=getProc(hh,'ippsMulC_16s_I');
  ippsMulC_16s_ISfs:=getProc(hh,'ippsMulC_16s_ISfs');
  ippsMulC_16s_Sfs:=getProc(hh,'ippsMulC_16s_Sfs');
  ippsMulC_16sc_ISfs:=getProc(hh,'ippsMulC_16sc_ISfs');
  ippsMulC_16sc_Sfs:=getProc(hh,'ippsMulC_16sc_Sfs');
  ippsMulC_16u_ISfs:=getProc(hh,'ippsMulC_16u_ISfs');
  ippsMulC_16u_Sfs:=getProc(hh,'ippsMulC_16u_Sfs');
  ippsMulC_32s_ISfs:=getProc(hh,'ippsMulC_32s_ISfs');
  ippsMulC_32s_Sfs:=getProc(hh,'ippsMulC_32s_Sfs');
  ippsMulC_32sc_ISfs:=getProc(hh,'ippsMulC_32sc_ISfs');
  ippsMulC_32sc_Sfs:=getProc(hh,'ippsMulC_32sc_Sfs');
  ippsMulC_64s_ISfs:=getProc(hh,'ippsMulC_64s_ISfs');
  ippsMulC_32f_I:=getProc(hh,'ippsMulC_32f_I');
  ippsMulC_32f:=getProc(hh,'ippsMulC_32f');
  ippsMulC_32fc_I:=getProc(hh,'ippsMulC_32fc_I');
  ippsMulC_32fc:=getProc(hh,'ippsMulC_32fc');
  ippsMulC_32f16s_Sfs:=getProc(hh,'ippsMulC_32f16s_Sfs');
  ippsMulC_Low_32f16s:=getProc(hh,'ippsMulC_Low_32f16s');
  ippsMulC_64f_I:=getProc(hh,'ippsMulC_64f_I');
  ippsMulC_64f:=getProc(hh,'ippsMulC_64f');
  ippsMulC_64fc_I:=getProc(hh,'ippsMulC_64fc_I');
  ippsMulC_64fc:=getProc(hh,'ippsMulC_64fc');
  ippsMulC_64f64s_ISfs:=getProc(hh,'ippsMulC_64f64s_ISfs');
  ippsMul_8u_ISfs:=getProc(hh,'ippsMul_8u_ISfs');
  ippsMul_8u_Sfs:=getProc(hh,'ippsMul_8u_Sfs');
  ippsMul_8u16u:=getProc(hh,'ippsMul_8u16u');
  ippsMul_16s_I:=getProc(hh,'ippsMul_16s_I');
  ippsMul_16s:=getProc(hh,'ippsMul_16s');
  ippsMul_16s_ISfs:=getProc(hh,'ippsMul_16s_ISfs');
  ippsMul_16s_Sfs:=getProc(hh,'ippsMul_16s_Sfs');
  ippsMul_16sc_ISfs:=getProc(hh,'ippsMul_16sc_ISfs');
  ippsMul_16sc_Sfs:=getProc(hh,'ippsMul_16sc_Sfs');
  ippsMul_16s32s_Sfs:=getProc(hh,'ippsMul_16s32s_Sfs');
  ippsMul_16s32f:=getProc(hh,'ippsMul_16s32f');
  ippsMul_16u_ISfs:=getProc(hh,'ippsMul_16u_ISfs');
  ippsMul_16u_Sfs:=getProc(hh,'ippsMul_16u_Sfs');
  ippsMul_16u16s_Sfs:=getProc(hh,'ippsMul_16u16s_Sfs');
  ippsMul_32s_ISfs:=getProc(hh,'ippsMul_32s_ISfs');
  ippsMul_32s_Sfs:=getProc(hh,'ippsMul_32s_Sfs');
  ippsMul_32sc_ISfs:=getProc(hh,'ippsMul_32sc_ISfs');
  ippsMul_32sc_Sfs:=getProc(hh,'ippsMul_32sc_Sfs');
  ippsMul_32f_I:=getProc(hh,'ippsMul_32f_I');
  ippsMul_32f:=getProc(hh,'ippsMul_32f');
  ippsMul_32fc_I:=getProc(hh,'ippsMul_32fc_I');
  ippsMul_32fc:=getProc(hh,'ippsMul_32fc');
  ippsMul_32f32fc_I:=getProc(hh,'ippsMul_32f32fc_I');
  ippsMul_32f32fc:=getProc(hh,'ippsMul_32f32fc');
  ippsMul_64f_I:=getProc(hh,'ippsMul_64f_I');
  ippsMul_64f:=getProc(hh,'ippsMul_64f');
  ippsMul_64fc_I:=getProc(hh,'ippsMul_64fc_I');
  ippsMul_64fc:=getProc(hh,'ippsMul_64fc');
  ippsSubC_8u_ISfs:=getProc(hh,'ippsSubC_8u_ISfs');
  ippsSubC_8u_Sfs:=getProc(hh,'ippsSubC_8u_Sfs');
  ippsSubC_16s_I:=getProc(hh,'ippsSubC_16s_I');
  ippsSubC_16s_ISfs:=getProc(hh,'ippsSubC_16s_ISfs');
  ippsSubC_16s_Sfs:=getProc(hh,'ippsSubC_16s_Sfs');
  ippsSubC_16sc_ISfs:=getProc(hh,'ippsSubC_16sc_ISfs');
  ippsSubC_16sc_Sfs:=getProc(hh,'ippsSubC_16sc_Sfs');
  ippsSubC_16u_ISfs:=getProc(hh,'ippsSubC_16u_ISfs');
  ippsSubC_16u_Sfs:=getProc(hh,'ippsSubC_16u_Sfs');
  ippsSubC_32s_ISfs:=getProc(hh,'ippsSubC_32s_ISfs');
  ippsSubC_32s_Sfs:=getProc(hh,'ippsSubC_32s_Sfs');
  ippsSubC_32sc_ISfs:=getProc(hh,'ippsSubC_32sc_ISfs');
  ippsSubC_32sc_Sfs:=getProc(hh,'ippsSubC_32sc_Sfs');
  ippsSubC_32f_I:=getProc(hh,'ippsSubC_32f_I');
  ippsSubC_32f:=getProc(hh,'ippsSubC_32f');
  ippsSubC_32fc_I:=getProc(hh,'ippsSubC_32fc_I');
  ippsSubC_32fc:=getProc(hh,'ippsSubC_32fc');
  ippsSubC_64f_I:=getProc(hh,'ippsSubC_64f_I');
  ippsSubC_64f:=getProc(hh,'ippsSubC_64f');
  ippsSubC_64fc_I:=getProc(hh,'ippsSubC_64fc_I');
  ippsSubC_64fc:=getProc(hh,'ippsSubC_64fc');
  ippsSubCRev_8u_ISfs:=getProc(hh,'ippsSubCRev_8u_ISfs');
  ippsSubCRev_8u_Sfs:=getProc(hh,'ippsSubCRev_8u_Sfs');
  ippsSubCRev_16s_ISfs:=getProc(hh,'ippsSubCRev_16s_ISfs');
  ippsSubCRev_16s_Sfs:=getProc(hh,'ippsSubCRev_16s_Sfs');
  ippsSubCRev_16sc_ISfs:=getProc(hh,'ippsSubCRev_16sc_ISfs');
  ippsSubCRev_16sc_Sfs:=getProc(hh,'ippsSubCRev_16sc_Sfs');
  ippsSubCRev_16u_ISfs:=getProc(hh,'ippsSubCRev_16u_ISfs');
  ippsSubCRev_16u_Sfs:=getProc(hh,'ippsSubCRev_16u_Sfs');
  ippsSubCRev_32s_ISfs:=getProc(hh,'ippsSubCRev_32s_ISfs');
  ippsSubCRev_32s_Sfs:=getProc(hh,'ippsSubCRev_32s_Sfs');
  ippsSubCRev_32sc_ISfs:=getProc(hh,'ippsSubCRev_32sc_ISfs');
  ippsSubCRev_32sc_Sfs:=getProc(hh,'ippsSubCRev_32sc_Sfs');
  ippsSubCRev_32f_I:=getProc(hh,'ippsSubCRev_32f_I');
  ippsSubCRev_32f:=getProc(hh,'ippsSubCRev_32f');
  ippsSubCRev_32fc_I:=getProc(hh,'ippsSubCRev_32fc_I');
  ippsSubCRev_32fc:=getProc(hh,'ippsSubCRev_32fc');
  ippsSubCRev_64f_I:=getProc(hh,'ippsSubCRev_64f_I');
  ippsSubCRev_64f:=getProc(hh,'ippsSubCRev_64f');
  ippsSubCRev_64fc_I:=getProc(hh,'ippsSubCRev_64fc_I');
  ippsSubCRev_64fc:=getProc(hh,'ippsSubCRev_64fc');
  ippsSub_8u_ISfs:=getProc(hh,'ippsSub_8u_ISfs');
  ippsSub_8u_Sfs:=getProc(hh,'ippsSub_8u_Sfs');
  ippsSub_16s_I:=getProc(hh,'ippsSub_16s_I');
  ippsSub_16s:=getProc(hh,'ippsSub_16s');
  ippsSub_16s_ISfs:=getProc(hh,'ippsSub_16s_ISfs');
  ippsSub_16s_Sfs:=getProc(hh,'ippsSub_16s_Sfs');
  ippsSub_16sc_ISfs:=getProc(hh,'ippsSub_16sc_ISfs');
  ippsSub_16sc_Sfs:=getProc(hh,'ippsSub_16sc_Sfs');
  ippsSub_16s32f:=getProc(hh,'ippsSub_16s32f');
  ippsSub_16u_ISfs:=getProc(hh,'ippsSub_16u_ISfs');
  ippsSub_16u_Sfs:=getProc(hh,'ippsSub_16u_Sfs');
  ippsSub_32s_ISfs:=getProc(hh,'ippsSub_32s_ISfs');
  ippsSub_32s_Sfs:=getProc(hh,'ippsSub_32s_Sfs');
  ippsSub_32sc_ISfs:=getProc(hh,'ippsSub_32sc_ISfs');
  ippsSub_32sc_Sfs:=getProc(hh,'ippsSub_32sc_Sfs');
  ippsSub_32f_I:=getProc(hh,'ippsSub_32f_I');
  ippsSub_32f:=getProc(hh,'ippsSub_32f');
  ippsSub_32fc_I:=getProc(hh,'ippsSub_32fc_I');
  ippsSub_32fc:=getProc(hh,'ippsSub_32fc');
  ippsSub_64f_I:=getProc(hh,'ippsSub_64f_I');
  ippsSub_64f:=getProc(hh,'ippsSub_64f');
  ippsSub_64fc_I:=getProc(hh,'ippsSub_64fc_I');
  ippsSub_64fc:=getProc(hh,'ippsSub_64fc');
  ippsDivC_8u_ISfs:=getProc(hh,'ippsDivC_8u_ISfs');
  ippsDivC_8u_Sfs:=getProc(hh,'ippsDivC_8u_Sfs');
  ippsDivC_16s_ISfs:=getProc(hh,'ippsDivC_16s_ISfs');
  ippsDivC_16s_Sfs:=getProc(hh,'ippsDivC_16s_Sfs');
  ippsDivC_16sc_ISfs:=getProc(hh,'ippsDivC_16sc_ISfs');
  ippsDivC_16sc_Sfs:=getProc(hh,'ippsDivC_16sc_Sfs');
  ippsDivC_16u_ISfs:=getProc(hh,'ippsDivC_16u_ISfs');
  ippsDivC_16u_Sfs:=getProc(hh,'ippsDivC_16u_Sfs');
  ippsDivC_64s_ISfs:=getProc(hh,'ippsDivC_64s_ISfs');
  ippsDivC_32f_I:=getProc(hh,'ippsDivC_32f_I');
  ippsDivC_32f:=getProc(hh,'ippsDivC_32f');
  ippsDivC_32fc_I:=getProc(hh,'ippsDivC_32fc_I');
  ippsDivC_32fc:=getProc(hh,'ippsDivC_32fc');
  ippsDivC_64f_I:=getProc(hh,'ippsDivC_64f_I');
  ippsDivC_64f:=getProc(hh,'ippsDivC_64f');
  ippsDivC_64fc_I:=getProc(hh,'ippsDivC_64fc_I');
  ippsDivC_64fc:=getProc(hh,'ippsDivC_64fc');
  ippsDivCRev_16u_I:=getProc(hh,'ippsDivCRev_16u_I');
  ippsDivCRev_16u:=getProc(hh,'ippsDivCRev_16u');
  ippsDivCRev_32f_I:=getProc(hh,'ippsDivCRev_32f_I');
  ippsDivCRev_32f:=getProc(hh,'ippsDivCRev_32f');
  ippsDiv_8u_ISfs:=getProc(hh,'ippsDiv_8u_ISfs');
  ippsDiv_8u_Sfs:=getProc(hh,'ippsDiv_8u_Sfs');
  ippsDiv_16s_ISfs:=getProc(hh,'ippsDiv_16s_ISfs');
  ippsDiv_16s_Sfs:=getProc(hh,'ippsDiv_16s_Sfs');
  ippsDiv_16sc_ISfs:=getProc(hh,'ippsDiv_16sc_ISfs');
  ippsDiv_16sc_Sfs:=getProc(hh,'ippsDiv_16sc_Sfs');
  ippsDiv_32s_ISfs:=getProc(hh,'ippsDiv_32s_ISfs');
  ippsDiv_32s_Sfs:=getProc(hh,'ippsDiv_32s_Sfs');
  ippsDiv_32s16s_Sfs:=getProc(hh,'ippsDiv_32s16s_Sfs');
  ippsDiv_16u_ISfs:=getProc(hh,'ippsDiv_16u_ISfs');
  ippsDiv_16u_Sfs:=getProc(hh,'ippsDiv_16u_Sfs');
  ippsDiv_32f_I:=getProc(hh,'ippsDiv_32f_I');
  ippsDiv_32f:=getProc(hh,'ippsDiv_32f');
  ippsDiv_32fc_I:=getProc(hh,'ippsDiv_32fc_I');
  ippsDiv_32fc:=getProc(hh,'ippsDiv_32fc');
  ippsDiv_64f_I:=getProc(hh,'ippsDiv_64f_I');
  ippsDiv_64f:=getProc(hh,'ippsDiv_64f');
  ippsDiv_64fc_I:=getProc(hh,'ippsDiv_64fc_I');
  ippsDiv_64fc:=getProc(hh,'ippsDiv_64fc');
  ippsDiv_Round_8u_ISfs:=getProc(hh,'ippsDiv_Round_8u_ISfs');
  ippsDiv_Round_8u_Sfs:=getProc(hh,'ippsDiv_Round_8u_Sfs');
  ippsDiv_Round_16s_ISfs:=getProc(hh,'ippsDiv_Round_16s_ISfs');
  ippsDiv_Round_16s_Sfs:=getProc(hh,'ippsDiv_Round_16s_Sfs');
  ippsDiv_Round_16u_ISfs:=getProc(hh,'ippsDiv_Round_16u_ISfs');
  ippsDiv_Round_16u_Sfs:=getProc(hh,'ippsDiv_Round_16u_Sfs');
  ippsAbs_16s_I:=getProc(hh,'ippsAbs_16s_I');
  ippsAbs_16s:=getProc(hh,'ippsAbs_16s');
  ippsAbs_32s_I:=getProc(hh,'ippsAbs_32s_I');
  ippsAbs_32s:=getProc(hh,'ippsAbs_32s');
  ippsAbs_32f_I:=getProc(hh,'ippsAbs_32f_I');
  ippsAbs_32f:=getProc(hh,'ippsAbs_32f');
  ippsAbs_64f_I:=getProc(hh,'ippsAbs_64f_I');
  ippsAbs_64f:=getProc(hh,'ippsAbs_64f');
  ippsSqr_8u_ISfs:=getProc(hh,'ippsSqr_8u_ISfs');
  ippsSqr_8u_Sfs:=getProc(hh,'ippsSqr_8u_Sfs');
  ippsSqr_16s_ISfs:=getProc(hh,'ippsSqr_16s_ISfs');
  ippsSqr_16s_Sfs:=getProc(hh,'ippsSqr_16s_Sfs');
  ippsSqr_16sc_ISfs:=getProc(hh,'ippsSqr_16sc_ISfs');
  ippsSqr_16sc_Sfs:=getProc(hh,'ippsSqr_16sc_Sfs');
  ippsSqr_16u_ISfs:=getProc(hh,'ippsSqr_16u_ISfs');
  ippsSqr_16u_Sfs:=getProc(hh,'ippsSqr_16u_Sfs');
  ippsSqr_32f_I:=getProc(hh,'ippsSqr_32f_I');
  ippsSqr_32f:=getProc(hh,'ippsSqr_32f');
  ippsSqr_32fc_I:=getProc(hh,'ippsSqr_32fc_I');
  ippsSqr_32fc:=getProc(hh,'ippsSqr_32fc');
  ippsSqr_64f_I:=getProc(hh,'ippsSqr_64f_I');
  ippsSqr_64f:=getProc(hh,'ippsSqr_64f');
  ippsSqr_64fc_I:=getProc(hh,'ippsSqr_64fc_I');
  ippsSqr_64fc:=getProc(hh,'ippsSqr_64fc');
  ippsSqrt_8u_ISfs:=getProc(hh,'ippsSqrt_8u_ISfs');
  ippsSqrt_8u_Sfs:=getProc(hh,'ippsSqrt_8u_Sfs');
  ippsSqrt_16s_ISfs:=getProc(hh,'ippsSqrt_16s_ISfs');
  ippsSqrt_16s_Sfs:=getProc(hh,'ippsSqrt_16s_Sfs');
  ippsSqrt_16sc_ISfs:=getProc(hh,'ippsSqrt_16sc_ISfs');
  ippsSqrt_16sc_Sfs:=getProc(hh,'ippsSqrt_16sc_Sfs');
  ippsSqrt_16u_ISfs:=getProc(hh,'ippsSqrt_16u_ISfs');
  ippsSqrt_16u_Sfs:=getProc(hh,'ippsSqrt_16u_Sfs');
  ippsSqrt_32s16s_Sfs:=getProc(hh,'ippsSqrt_32s16s_Sfs');
  ippsSqrt_32f_I:=getProc(hh,'ippsSqrt_32f_I');
  ippsSqrt_32f:=getProc(hh,'ippsSqrt_32f');
  ippsSqrt_32fc_I:=getProc(hh,'ippsSqrt_32fc_I');
  ippsSqrt_32fc:=getProc(hh,'ippsSqrt_32fc');
  ippsSqrt_64f_I:=getProc(hh,'ippsSqrt_64f_I');
  ippsSqrt_64f:=getProc(hh,'ippsSqrt_64f');
  ippsSqrt_64fc_I:=getProc(hh,'ippsSqrt_64fc_I');
  ippsSqrt_64fc:=getProc(hh,'ippsSqrt_64fc');
  ippsCubrt_32s16s_Sfs:=getProc(hh,'ippsCubrt_32s16s_Sfs');
  ippsCubrt_32f:=getProc(hh,'ippsCubrt_32f');
  ippsExp_16s_ISfs:=getProc(hh,'ippsExp_16s_ISfs');
  ippsExp_16s_Sfs:=getProc(hh,'ippsExp_16s_Sfs');
  ippsExp_32s_ISfs:=getProc(hh,'ippsExp_32s_ISfs');
  ippsExp_32s_Sfs:=getProc(hh,'ippsExp_32s_Sfs');
  ippsExp_32f_I:=getProc(hh,'ippsExp_32f_I');
  ippsExp_32f:=getProc(hh,'ippsExp_32f');
  ippsExp_64f_I:=getProc(hh,'ippsExp_64f_I');
  ippsExp_64f:=getProc(hh,'ippsExp_64f');
  ippsLn_16s_ISfs:=getProc(hh,'ippsLn_16s_ISfs');
  ippsLn_16s_Sfs:=getProc(hh,'ippsLn_16s_Sfs');
  ippsLn_32s_ISfs:=getProc(hh,'ippsLn_32s_ISfs');
  ippsLn_32s_Sfs:=getProc(hh,'ippsLn_32s_Sfs');
  ippsLn_32f_I:=getProc(hh,'ippsLn_32f_I');
  ippsLn_32f:=getProc(hh,'ippsLn_32f');
  ippsLn_64f_I:=getProc(hh,'ippsLn_64f_I');
  ippsLn_64f:=getProc(hh,'ippsLn_64f');
  ippsSumLn_16s32f:=getProc(hh,'ippsSumLn_16s32f');
  ippsSumLn_32f:=getProc(hh,'ippsSumLn_32f');
  ippsSumLn_32f64f:=getProc(hh,'ippsSumLn_32f64f');
  ippsSumLn_64f:=getProc(hh,'ippsSumLn_64f');
  ippsArctan_32f_I:=getProc(hh,'ippsArctan_32f_I');
  ippsArctan_32f:=getProc(hh,'ippsArctan_32f');
  ippsArctan_64f_I:=getProc(hh,'ippsArctan_64f_I');
  ippsArctan_64f:=getProc(hh,'ippsArctan_64f');
  ippsNormalize_16s_ISfs:=getProc(hh,'ippsNormalize_16s_ISfs');
  ippsNormalize_16s_Sfs:=getProc(hh,'ippsNormalize_16s_Sfs');
  ippsNormalize_16sc_ISfs:=getProc(hh,'ippsNormalize_16sc_ISfs');
  ippsNormalize_16sc_Sfs:=getProc(hh,'ippsNormalize_16sc_Sfs');
  ippsNormalize_32f_I:=getProc(hh,'ippsNormalize_32f_I');
  ippsNormalize_32f:=getProc(hh,'ippsNormalize_32f');
  ippsNormalize_32fc_I:=getProc(hh,'ippsNormalize_32fc_I');
  ippsNormalize_32fc:=getProc(hh,'ippsNormalize_32fc');
  ippsNormalize_64f_I:=getProc(hh,'ippsNormalize_64f_I');
  ippsNormalize_64f:=getProc(hh,'ippsNormalize_64f');
  ippsNormalize_64fc_I:=getProc(hh,'ippsNormalize_64fc_I');
end;

procedure InitIPPS2;
begin
  ippsNormalize_64fc:=getProc(hh,'ippsNormalize_64fc');
  ippsSortAscend_8u_I:=getProc(hh,'ippsSortAscend_8u_I');
  ippsSortAscend_16s_I:=getProc(hh,'ippsSortAscend_16s_I');
  ippsSortAscend_16u_I:=getProc(hh,'ippsSortAscend_16u_I');
  ippsSortAscend_32s_I:=getProc(hh,'ippsSortAscend_32s_I');
  ippsSortAscend_32f_I:=getProc(hh,'ippsSortAscend_32f_I');
  ippsSortAscend_64f_I:=getProc(hh,'ippsSortAscend_64f_I');
  ippsSortDescend_8u_I:=getProc(hh,'ippsSortDescend_8u_I');
  ippsSortDescend_16s_I:=getProc(hh,'ippsSortDescend_16s_I');
  ippsSortDescend_16u_I:=getProc(hh,'ippsSortDescend_16u_I');
  ippsSortDescend_32s_I:=getProc(hh,'ippsSortDescend_32s_I');
  ippsSortDescend_32f_I:=getProc(hh,'ippsSortDescend_32f_I');
  ippsSortDescend_64f_I:=getProc(hh,'ippsSortDescend_64f_I');
  ippsSortIndexAscend_8u_I:=getProc(hh,'ippsSortIndexAscend_8u_I');
  ippsSortIndexAscend_16s_I:=getProc(hh,'ippsSortIndexAscend_16s_I');
  ippsSortIndexAscend_16u_I:=getProc(hh,'ippsSortIndexAscend_16u_I');
  ippsSortIndexAscend_32s_I:=getProc(hh,'ippsSortIndexAscend_32s_I');
  ippsSortIndexAscend_32f_I:=getProc(hh,'ippsSortIndexAscend_32f_I');
  ippsSortIndexAscend_64f_I:=getProc(hh,'ippsSortIndexAscend_64f_I');
  ippsSortIndexDescend_8u_I:=getProc(hh,'ippsSortIndexDescend_8u_I');
  ippsSortIndexDescend_16s_I:=getProc(hh,'ippsSortIndexDescend_16s_I');
  ippsSortIndexDescend_16u_I:=getProc(hh,'ippsSortIndexDescend_16u_I');
  ippsSortIndexDescend_32s_I:=getProc(hh,'ippsSortIndexDescend_32s_I');
  ippsSortIndexDescend_32f_I:=getProc(hh,'ippsSortIndexDescend_32f_I');
  ippsSortIndexDescend_64f_I:=getProc(hh,'ippsSortIndexDescend_64f_I');
  ippsSortRadixGetBufferSize:=getProc(hh,'ippsSortRadixGetBufferSize');
  ippsSortRadixIndexGetBufferSize:=getProc(hh,'ippsSortRadixIndexGetBufferSize');
  ippsSortRadixAscend_8u_I:=getProc(hh,'ippsSortRadixAscend_8u_I');
  ippsSortRadixAscend_16u_I:=getProc(hh,'ippsSortRadixAscend_16u_I');
  ippsSortRadixAscend_16s_I:=getProc(hh,'ippsSortRadixAscend_16s_I');
  ippsSortRadixAscend_32u_I:=getProc(hh,'ippsSortRadixAscend_32u_I');
  ippsSortRadixAscend_32s_I:=getProc(hh,'ippsSortRadixAscend_32s_I');
  ippsSortRadixAscend_32f_I:=getProc(hh,'ippsSortRadixAscend_32f_I');
  ippsSortRadixAscend_64f_I:=getProc(hh,'ippsSortRadixAscend_64f_I');
  ippsSortRadixDescend_8u_I:=getProc(hh,'ippsSortRadixDescend_8u_I');
  ippsSortRadixDescend_16u_I:=getProc(hh,'ippsSortRadixDescend_16u_I');
  ippsSortRadixDescend_16s_I:=getProc(hh,'ippsSortRadixDescend_16s_I');
  ippsSortRadixDescend_32u_I:=getProc(hh,'ippsSortRadixDescend_32u_I');
  ippsSortRadixDescend_32s_I:=getProc(hh,'ippsSortRadixDescend_32s_I');
  ippsSortRadixDescend_32f_I:=getProc(hh,'ippsSortRadixDescend_32f_I');
  ippsSortRadixDescend_64f_I:=getProc(hh,'ippsSortRadixDescend_64f_I');
  ippsSortRadixIndexAscend_8u:=getProc(hh,'ippsSortRadixIndexAscend_8u');
  ippsSortRadixIndexAscend_16s:=getProc(hh,'ippsSortRadixIndexAscend_16s');
  ippsSortRadixIndexAscend_16u:=getProc(hh,'ippsSortRadixIndexAscend_16u');
  ippsSortRadixIndexAscend_32s:=getProc(hh,'ippsSortRadixIndexAscend_32s');
  ippsSortRadixIndexAscend_32u:=getProc(hh,'ippsSortRadixIndexAscend_32u');
  ippsSortRadixIndexAscend_32f:=getProc(hh,'ippsSortRadixIndexAscend_32f');
  ippsSortRadixIndexDescend_8u:=getProc(hh,'ippsSortRadixIndexDescend_8u');
  ippsSortRadixIndexDescend_16s:=getProc(hh,'ippsSortRadixIndexDescend_16s');
  ippsSortRadixIndexDescend_16u:=getProc(hh,'ippsSortRadixIndexDescend_16u');
  ippsSortRadixIndexDescend_32s:=getProc(hh,'ippsSortRadixIndexDescend_32s');
  ippsSortRadixIndexDescend_32u:=getProc(hh,'ippsSortRadixIndexDescend_32u');
  ippsSortRadixIndexDescend_32f:=getProc(hh,'ippsSortRadixIndexDescend_32f');
  ippsSwapBytes_16u_I:=getProc(hh,'ippsSwapBytes_16u_I');
  ippsSwapBytes_16u:=getProc(hh,'ippsSwapBytes_16u');
  ippsSwapBytes_24u_I:=getProc(hh,'ippsSwapBytes_24u_I');
  ippsSwapBytes_24u:=getProc(hh,'ippsSwapBytes_24u');
  ippsSwapBytes_32u_I:=getProc(hh,'ippsSwapBytes_32u_I');
  ippsSwapBytes_32u:=getProc(hh,'ippsSwapBytes_32u');
  ippsSwapBytes_64u_I:=getProc(hh,'ippsSwapBytes_64u_I');
  ippsSwapBytes_64u:=getProc(hh,'ippsSwapBytes_64u');
  ippsConvert_8s16s:=getProc(hh,'ippsConvert_8s16s');
  ippsConvert_8s32f:=getProc(hh,'ippsConvert_8s32f');
  ippsConvert_8u32f:=getProc(hh,'ippsConvert_8u32f');
  ippsConvert_16s8s_Sfs:=getProc(hh,'ippsConvert_16s8s_Sfs');
  ippsConvert_16s32s:=getProc(hh,'ippsConvert_16s32s');
  ippsConvert_16s16f:=getProc(hh,'ippsConvert_16s16f');
  ippsConvert_16s32f:=getProc(hh,'ippsConvert_16s32f');
  ippsConvert_16s32f_Sfs:=getProc(hh,'ippsConvert_16s32f_Sfs');
  ippsConvert_16s64f_Sfs:=getProc(hh,'ippsConvert_16s64f_Sfs');
  ippsConvert_16u32f:=getProc(hh,'ippsConvert_16u32f');
  ippsConvert_24s32s:=getProc(hh,'ippsConvert_24s32s');
  ippsConvert_24s32f:=getProc(hh,'ippsConvert_24s32f');
  ippsConvert_24u32u:=getProc(hh,'ippsConvert_24u32u');
  ippsConvert_24u32f:=getProc(hh,'ippsConvert_24u32f');
  ippsConvert_32s16s:=getProc(hh,'ippsConvert_32s16s');
  ippsConvert_32s16s_Sfs:=getProc(hh,'ippsConvert_32s16s_Sfs');
  ippsConvert_32s24s_Sfs:=getProc(hh,'ippsConvert_32s24s_Sfs');
  ippsConvert_32s32f:=getProc(hh,'ippsConvert_32s32f');
  ippsConvert_32s32f_Sfs:=getProc(hh,'ippsConvert_32s32f_Sfs');
  ippsConvert_32s64f:=getProc(hh,'ippsConvert_32s64f');
  ippsConvert_32s64f_Sfs:=getProc(hh,'ippsConvert_32s64f_Sfs');
  ippsConvert_32u24u_Sfs:=getProc(hh,'ippsConvert_32u24u_Sfs');
  ippsConvert_64s32s_Sfs:=getProc(hh,'ippsConvert_64s32s_Sfs');
  ippsConvert_64s64f:=getProc(hh,'ippsConvert_64s64f');
  ippsConvert_16f16s_Sfs:=getProc(hh,'ippsConvert_16f16s_Sfs');
  ippsConvert_16f32f:=getProc(hh,'ippsConvert_16f32f');
  ippsConvert_32f8s_Sfs:=getProc(hh,'ippsConvert_32f8s_Sfs');
  ippsConvert_32f8u_Sfs:=getProc(hh,'ippsConvert_32f8u_Sfs');
  ippsConvert_32f16s_Sfs:=getProc(hh,'ippsConvert_32f16s_Sfs');
  ippsConvert_32f16u_Sfs:=getProc(hh,'ippsConvert_32f16u_Sfs');
  ippsConvert_32f24s_Sfs:=getProc(hh,'ippsConvert_32f24s_Sfs');
  ippsConvert_32f24u_Sfs:=getProc(hh,'ippsConvert_32f24u_Sfs');
  ippsConvert_32f32s_Sfs:=getProc(hh,'ippsConvert_32f32s_Sfs');
  ippsConvert_32f16f:=getProc(hh,'ippsConvert_32f16f');
  ippsConvert_32f64f:=getProc(hh,'ippsConvert_32f64f');
  ippsConvert_64f16s_Sfs:=getProc(hh,'ippsConvert_64f16s_Sfs');
  ippsConvert_64f32s_Sfs:=getProc(hh,'ippsConvert_64f32s_Sfs');
  ippsConvert_64f64s_Sfs:=getProc(hh,'ippsConvert_64f64s_Sfs');
  ippsConvert_64f32f:=getProc(hh,'ippsConvert_64f32f');
  ippsConvert_8s8u:=getProc(hh,'ippsConvert_8s8u');
  ippsConvert_8u8s_Sfs:=getProc(hh,'ippsConvert_8u8s_Sfs');
  ippsConvert_64f8s_Sfs:=getProc(hh,'ippsConvert_64f8s_Sfs');
  ippsConvert_64f8u_Sfs:=getProc(hh,'ippsConvert_64f8u_Sfs');
  ippsConvert_64f16u_Sfs:=getProc(hh,'ippsConvert_64f16u_Sfs');
  ippsConj_16sc_I:=getProc(hh,'ippsConj_16sc_I');
  ippsConj_16sc:=getProc(hh,'ippsConj_16sc');
  ippsConj_32fc_I:=getProc(hh,'ippsConj_32fc_I');
  ippsConj_32fc:=getProc(hh,'ippsConj_32fc');
  ippsConj_64fc_I:=getProc(hh,'ippsConj_64fc_I');
  ippsConj_64fc:=getProc(hh,'ippsConj_64fc');
  ippsConjFlip_16sc:=getProc(hh,'ippsConjFlip_16sc');
  ippsConjFlip_32fc:=getProc(hh,'ippsConjFlip_32fc');
  ippsConjFlip_64fc:=getProc(hh,'ippsConjFlip_64fc');
  ippsConjCcs_32fc_I:=getProc(hh,'ippsConjCcs_32fc_I');
  ippsConjCcs_32fc:=getProc(hh,'ippsConjCcs_32fc');
  ippsConjCcs_64fc_I:=getProc(hh,'ippsConjCcs_64fc_I');
  ippsConjCcs_64fc:=getProc(hh,'ippsConjCcs_64fc');
  ippsConjPack_32fc_I:=getProc(hh,'ippsConjPack_32fc_I');
  ippsConjPack_32fc:=getProc(hh,'ippsConjPack_32fc');
  ippsConjPack_64fc_I:=getProc(hh,'ippsConjPack_64fc_I');
  ippsConjPack_64fc:=getProc(hh,'ippsConjPack_64fc');
  ippsConjPerm_32fc_I:=getProc(hh,'ippsConjPerm_32fc_I');
  ippsConjPerm_32fc:=getProc(hh,'ippsConjPerm_32fc');
  ippsConjPerm_64fc_I:=getProc(hh,'ippsConjPerm_64fc_I');
  ippsConjPerm_64fc:=getProc(hh,'ippsConjPerm_64fc');
  ippsMagnitude_16s_Sfs:=getProc(hh,'ippsMagnitude_16s_Sfs');
  ippsMagnitude_16sc_Sfs:=getProc(hh,'ippsMagnitude_16sc_Sfs');
  ippsMagnitude_16s32f:=getProc(hh,'ippsMagnitude_16s32f');
  ippsMagnitude_16sc32f:=getProc(hh,'ippsMagnitude_16sc32f');
  ippsMagnitude_32sc_Sfs:=getProc(hh,'ippsMagnitude_32sc_Sfs');
  ippsMagnitude_32f:=getProc(hh,'ippsMagnitude_32f');
  ippsMagnitude_32fc:=getProc(hh,'ippsMagnitude_32fc');
  ippsMagnitude_64f:=getProc(hh,'ippsMagnitude_64f');
  ippsMagnitude_64fc:=getProc(hh,'ippsMagnitude_64fc');
  ippsPhase_16sc_Sfs:=getProc(hh,'ippsPhase_16sc_Sfs');
  ippsPhase_16sc32f:=getProc(hh,'ippsPhase_16sc32f');
  ippsPhase_64fc:=getProc(hh,'ippsPhase_64fc');
  ippsPhase_32fc:=getProc(hh,'ippsPhase_32fc');
  ippsPhase_16s_Sfs:=getProc(hh,'ippsPhase_16s_Sfs');
  ippsPhase_16s32f:=getProc(hh,'ippsPhase_16s32f');
  ippsPhase_64f:=getProc(hh,'ippsPhase_64f');
  ippsPhase_32f:=getProc(hh,'ippsPhase_32f');
  ippsPowerSpectr_16s_Sfs:=getProc(hh,'ippsPowerSpectr_16s_Sfs');
  ippsPowerSpectr_16s32f:=getProc(hh,'ippsPowerSpectr_16s32f');
  ippsPowerSpectr_32f:=getProc(hh,'ippsPowerSpectr_32f');
  ippsPowerSpectr_64f:=getProc(hh,'ippsPowerSpectr_64f');
  ippsPowerSpectr_16sc_Sfs:=getProc(hh,'ippsPowerSpectr_16sc_Sfs');
  ippsPowerSpectr_16sc32f:=getProc(hh,'ippsPowerSpectr_16sc32f');
  ippsPowerSpectr_32fc:=getProc(hh,'ippsPowerSpectr_32fc');
  ippsPowerSpectr_64fc:=getProc(hh,'ippsPowerSpectr_64fc');
  ippsReal_64fc:=getProc(hh,'ippsReal_64fc');
  ippsReal_32fc:=getProc(hh,'ippsReal_32fc');
  ippsReal_16sc:=getProc(hh,'ippsReal_16sc');
  ippsImag_64fc:=getProc(hh,'ippsImag_64fc');
  ippsImag_32fc:=getProc(hh,'ippsImag_32fc');
  ippsImag_16sc:=getProc(hh,'ippsImag_16sc');
  ippsRealToCplx_64f:=getProc(hh,'ippsRealToCplx_64f');
  ippsRealToCplx_32f:=getProc(hh,'ippsRealToCplx_32f');
  ippsRealToCplx_16s:=getProc(hh,'ippsRealToCplx_16s');
  ippsCplxToReal_64fc:=getProc(hh,'ippsCplxToReal_64fc');
  ippsCplxToReal_32fc:=getProc(hh,'ippsCplxToReal_32fc');
  ippsCplxToReal_16sc:=getProc(hh,'ippsCplxToReal_16sc');
  ippsThreshold_16s_I:=getProc(hh,'ippsThreshold_16s_I');
  ippsThreshold_16sc_I:=getProc(hh,'ippsThreshold_16sc_I');
  ippsThreshold_32f_I:=getProc(hh,'ippsThreshold_32f_I');
  ippsThreshold_32fc_I:=getProc(hh,'ippsThreshold_32fc_I');
  ippsThreshold_64f_I:=getProc(hh,'ippsThreshold_64f_I');
  ippsThreshold_64fc_I:=getProc(hh,'ippsThreshold_64fc_I');
  ippsThreshold_16s:=getProc(hh,'ippsThreshold_16s');
  ippsThreshold_16sc:=getProc(hh,'ippsThreshold_16sc');
  ippsThreshold_32f:=getProc(hh,'ippsThreshold_32f');
  ippsThreshold_32fc:=getProc(hh,'ippsThreshold_32fc');
  ippsThreshold_64f:=getProc(hh,'ippsThreshold_64f');
  ippsThreshold_64fc:=getProc(hh,'ippsThreshold_64fc');
  ippsThreshold_LT_16s_I:=getProc(hh,'ippsThreshold_LT_16s_I');
  ippsThreshold_LT_16sc_I:=getProc(hh,'ippsThreshold_LT_16sc_I');
  ippsThreshold_LT_32s_I:=getProc(hh,'ippsThreshold_LT_32s_I');
  ippsThreshold_LT_32f_I:=getProc(hh,'ippsThreshold_LT_32f_I');
  ippsThreshold_LT_32fc_I:=getProc(hh,'ippsThreshold_LT_32fc_I');
  ippsThreshold_LT_64f_I:=getProc(hh,'ippsThreshold_LT_64f_I');
  ippsThreshold_LT_64fc_I:=getProc(hh,'ippsThreshold_LT_64fc_I');
  ippsThreshold_LT_16s:=getProc(hh,'ippsThreshold_LT_16s');
  ippsThreshold_LT_16sc:=getProc(hh,'ippsThreshold_LT_16sc');
  ippsThreshold_LT_32s:=getProc(hh,'ippsThreshold_LT_32s');
  ippsThreshold_LT_32f:=getProc(hh,'ippsThreshold_LT_32f');
  ippsThreshold_LT_32fc:=getProc(hh,'ippsThreshold_LT_32fc');
  ippsThreshold_LT_64f:=getProc(hh,'ippsThreshold_LT_64f');
  ippsThreshold_LT_64fc:=getProc(hh,'ippsThreshold_LT_64fc');
  ippsThreshold_GT_16s_I:=getProc(hh,'ippsThreshold_GT_16s_I');
  ippsThreshold_GT_16sc_I:=getProc(hh,'ippsThreshold_GT_16sc_I');
  ippsThreshold_GT_32s_I:=getProc(hh,'ippsThreshold_GT_32s_I');
  ippsThreshold_GT_32f_I:=getProc(hh,'ippsThreshold_GT_32f_I');
  ippsThreshold_GT_32fc_I:=getProc(hh,'ippsThreshold_GT_32fc_I');
  ippsThreshold_GT_64f_I:=getProc(hh,'ippsThreshold_GT_64f_I');
  ippsThreshold_GT_64fc_I:=getProc(hh,'ippsThreshold_GT_64fc_I');
  ippsThreshold_GT_16s:=getProc(hh,'ippsThreshold_GT_16s');
  ippsThreshold_GT_16sc:=getProc(hh,'ippsThreshold_GT_16sc');
  ippsThreshold_GT_32s:=getProc(hh,'ippsThreshold_GT_32s');
  ippsThreshold_GT_32f:=getProc(hh,'ippsThreshold_GT_32f');
  ippsThreshold_GT_32fc:=getProc(hh,'ippsThreshold_GT_32fc');
  ippsThreshold_GT_64f:=getProc(hh,'ippsThreshold_GT_64f');
  ippsThreshold_GT_64fc:=getProc(hh,'ippsThreshold_GT_64fc');
  ippsThreshold_LTAbs_16s:=getProc(hh,'ippsThreshold_LTAbs_16s');
  ippsThreshold_LTAbs_32s:=getProc(hh,'ippsThreshold_LTAbs_32s');
  ippsThreshold_LTAbs_32f:=getProc(hh,'ippsThreshold_LTAbs_32f');
  ippsThreshold_LTAbs_64f:=getProc(hh,'ippsThreshold_LTAbs_64f');
  ippsThreshold_LTAbs_16s_I:=getProc(hh,'ippsThreshold_LTAbs_16s_I');
  ippsThreshold_LTAbs_32s_I:=getProc(hh,'ippsThreshold_LTAbs_32s_I');
  ippsThreshold_LTAbs_32f_I:=getProc(hh,'ippsThreshold_LTAbs_32f_I');
  ippsThreshold_LTAbs_64f_I:=getProc(hh,'ippsThreshold_LTAbs_64f_I');
  ippsThreshold_GTAbs_16s:=getProc(hh,'ippsThreshold_GTAbs_16s');
  ippsThreshold_GTAbs_32s:=getProc(hh,'ippsThreshold_GTAbs_32s');
  ippsThreshold_GTAbs_32f:=getProc(hh,'ippsThreshold_GTAbs_32f');
  ippsThreshold_GTAbs_64f:=getProc(hh,'ippsThreshold_GTAbs_64f');
  ippsThreshold_GTAbs_16s_I:=getProc(hh,'ippsThreshold_GTAbs_16s_I');
  ippsThreshold_GTAbs_32s_I:=getProc(hh,'ippsThreshold_GTAbs_32s_I');
  ippsThreshold_GTAbs_32f_I:=getProc(hh,'ippsThreshold_GTAbs_32f_I');
  ippsThreshold_GTAbs_64f_I:=getProc(hh,'ippsThreshold_GTAbs_64f_I');
  ippsThreshold_LTAbsVal_16s:=getProc(hh,'ippsThreshold_LTAbsVal_16s');
  ippsThreshold_LTAbsVal_32s:=getProc(hh,'ippsThreshold_LTAbsVal_32s');
  ippsThreshold_LTAbsVal_32f:=getProc(hh,'ippsThreshold_LTAbsVal_32f');
  ippsThreshold_LTAbsVal_64f:=getProc(hh,'ippsThreshold_LTAbsVal_64f');
  ippsThreshold_LTAbsVal_16s_I:=getProc(hh,'ippsThreshold_LTAbsVal_16s_I');
  ippsThreshold_LTAbsVal_32s_I:=getProc(hh,'ippsThreshold_LTAbsVal_32s_I');
  ippsThreshold_LTAbsVal_32f_I:=getProc(hh,'ippsThreshold_LTAbsVal_32f_I');
  ippsThreshold_LTAbsVal_64f_I:=getProc(hh,'ippsThreshold_LTAbsVal_64f_I');
  ippsThreshold_LTVal_16s_I:=getProc(hh,'ippsThreshold_LTVal_16s_I');
  ippsThreshold_LTVal_16sc_I:=getProc(hh,'ippsThreshold_LTVal_16sc_I');
  ippsThreshold_LTVal_32f_I:=getProc(hh,'ippsThreshold_LTVal_32f_I');
  ippsThreshold_LTVal_32fc_I:=getProc(hh,'ippsThreshold_LTVal_32fc_I');
  ippsThreshold_LTVal_64f_I:=getProc(hh,'ippsThreshold_LTVal_64f_I');
  ippsThreshold_LTVal_64fc_I:=getProc(hh,'ippsThreshold_LTVal_64fc_I');
  ippsThreshold_LTVal_16s:=getProc(hh,'ippsThreshold_LTVal_16s');
  ippsThreshold_LTVal_16sc:=getProc(hh,'ippsThreshold_LTVal_16sc');
  ippsThreshold_LTVal_32f:=getProc(hh,'ippsThreshold_LTVal_32f');
  ippsThreshold_LTVal_32fc:=getProc(hh,'ippsThreshold_LTVal_32fc');
  ippsThreshold_LTVal_64f:=getProc(hh,'ippsThreshold_LTVal_64f');
  ippsThreshold_LTVal_64fc:=getProc(hh,'ippsThreshold_LTVal_64fc');
  ippsThreshold_GTVal_16s_I:=getProc(hh,'ippsThreshold_GTVal_16s_I');
  ippsThreshold_GTVal_16sc_I:=getProc(hh,'ippsThreshold_GTVal_16sc_I');
  ippsThreshold_GTVal_32f_I:=getProc(hh,'ippsThreshold_GTVal_32f_I');
  ippsThreshold_GTVal_32fc_I:=getProc(hh,'ippsThreshold_GTVal_32fc_I');
  ippsThreshold_GTVal_64f_I:=getProc(hh,'ippsThreshold_GTVal_64f_I');
  ippsThreshold_GTVal_64fc_I:=getProc(hh,'ippsThreshold_GTVal_64fc_I');
  ippsThreshold_GTVal_16s:=getProc(hh,'ippsThreshold_GTVal_16s');
  ippsThreshold_GTVal_16sc:=getProc(hh,'ippsThreshold_GTVal_16sc');
  ippsThreshold_GTVal_32f:=getProc(hh,'ippsThreshold_GTVal_32f');
  ippsThreshold_GTVal_32fc:=getProc(hh,'ippsThreshold_GTVal_32fc');
  ippsThreshold_GTVal_64f:=getProc(hh,'ippsThreshold_GTVal_64f');
  ippsThreshold_GTVal_64fc:=getProc(hh,'ippsThreshold_GTVal_64fc');
  ippsThreshold_LTValGTVal_16s_I:=getProc(hh,'ippsThreshold_LTValGTVal_16s_I');
  ippsThreshold_LTValGTVal_16s:=getProc(hh,'ippsThreshold_LTValGTVal_16s');
  ippsThreshold_LTValGTVal_32s_I:=getProc(hh,'ippsThreshold_LTValGTVal_32s_I');
  ippsThreshold_LTValGTVal_32s:=getProc(hh,'ippsThreshold_LTValGTVal_32s');
  ippsThreshold_LTValGTVal_32f_I:=getProc(hh,'ippsThreshold_LTValGTVal_32f_I');
  ippsThreshold_LTValGTVal_32f:=getProc(hh,'ippsThreshold_LTValGTVal_32f');
  ippsThreshold_LTValGTVal_64f_I:=getProc(hh,'ippsThreshold_LTValGTVal_64f_I');
  ippsThreshold_LTValGTVal_64f:=getProc(hh,'ippsThreshold_LTValGTVal_64f');
  ippsThreshold_LTInv_32f_I:=getProc(hh,'ippsThreshold_LTInv_32f_I');
  ippsThreshold_LTInv_32fc_I:=getProc(hh,'ippsThreshold_LTInv_32fc_I');
  ippsThreshold_LTInv_64f_I:=getProc(hh,'ippsThreshold_LTInv_64f_I');
  ippsThreshold_LTInv_64fc_I:=getProc(hh,'ippsThreshold_LTInv_64fc_I');
  ippsThreshold_LTInv_32f:=getProc(hh,'ippsThreshold_LTInv_32f');
  ippsThreshold_LTInv_32fc:=getProc(hh,'ippsThreshold_LTInv_32fc');
  ippsThreshold_LTInv_64f:=getProc(hh,'ippsThreshold_LTInv_64f');
  ippsThreshold_LTInv_64fc:=getProc(hh,'ippsThreshold_LTInv_64fc');
  ippsCartToPolar_32fc:=getProc(hh,'ippsCartToPolar_32fc');
  ippsCartToPolar_64fc:=getProc(hh,'ippsCartToPolar_64fc');
  ippsCartToPolar_32f:=getProc(hh,'ippsCartToPolar_32f');
  ippsCartToPolar_64f:=getProc(hh,'ippsCartToPolar_64f');
  ippsCartToPolar_16sc_Sfs:=getProc(hh,'ippsCartToPolar_16sc_Sfs');
  ippsPolarToCart_32fc:=getProc(hh,'ippsPolarToCart_32fc');
  ippsPolarToCart_64fc:=getProc(hh,'ippsPolarToCart_64fc');
  ippsPolarToCart_32f:=getProc(hh,'ippsPolarToCart_32f');
  ippsPolarToCart_64f:=getProc(hh,'ippsPolarToCart_64f');
  ippsPolarToCart_16sc_Sfs:=getProc(hh,'ippsPolarToCart_16sc_Sfs');
  ippsFlip_8u:=getProc(hh,'ippsFlip_8u');
  ippsFlip_8u_I:=getProc(hh,'ippsFlip_8u_I');
  ippsFlip_16u:=getProc(hh,'ippsFlip_16u');
  ippsFlip_16u_I:=getProc(hh,'ippsFlip_16u_I');
  ippsFlip_32f:=getProc(hh,'ippsFlip_32f');
  ippsFlip_32f_I:=getProc(hh,'ippsFlip_32f_I');
  ippsFlip_32fc:=getProc(hh,'ippsFlip_32fc');
  ippsFlip_32fc_I:=getProc(hh,'ippsFlip_32fc_I');
  ippsFlip_64f:=getProc(hh,'ippsFlip_64f');
  ippsFlip_64f_I:=getProc(hh,'ippsFlip_64f_I');
  ippsFlip_64fc:=getProc(hh,'ippsFlip_64fc');
  ippsFlip_64fc_I:=getProc(hh,'ippsFlip_64fc_I');
  ippsFindNearestOne_16u:=getProc(hh,'ippsFindNearestOne_16u');
  ippsFindNearest_16u:=getProc(hh,'ippsFindNearest_16u');
  ippsWinBartlett_16s_I:=getProc(hh,'ippsWinBartlett_16s_I');
  ippsWinBartlett_16s:=getProc(hh,'ippsWinBartlett_16s');
  ippsWinBartlett_16sc_I:=getProc(hh,'ippsWinBartlett_16sc_I');
  ippsWinBartlett_16sc:=getProc(hh,'ippsWinBartlett_16sc');
  ippsWinBartlett_32f_I:=getProc(hh,'ippsWinBartlett_32f_I');
  ippsWinBartlett_32f:=getProc(hh,'ippsWinBartlett_32f');
  ippsWinBartlett_32fc_I:=getProc(hh,'ippsWinBartlett_32fc_I');
  ippsWinBartlett_32fc:=getProc(hh,'ippsWinBartlett_32fc');
  ippsWinBartlett_64f_I:=getProc(hh,'ippsWinBartlett_64f_I');
  ippsWinBartlett_64f:=getProc(hh,'ippsWinBartlett_64f');
  ippsWinBartlett_64fc_I:=getProc(hh,'ippsWinBartlett_64fc_I');
  ippsWinBartlett_64fc:=getProc(hh,'ippsWinBartlett_64fc');
  ippsWinHann_16s_I:=getProc(hh,'ippsWinHann_16s_I');
  ippsWinHann_16s:=getProc(hh,'ippsWinHann_16s');
  ippsWinHann_16sc_I:=getProc(hh,'ippsWinHann_16sc_I');
  ippsWinHann_16sc:=getProc(hh,'ippsWinHann_16sc');
  ippsWinHann_32f_I:=getProc(hh,'ippsWinHann_32f_I');
  ippsWinHann_32f:=getProc(hh,'ippsWinHann_32f');
  ippsWinHann_32fc_I:=getProc(hh,'ippsWinHann_32fc_I');
  ippsWinHann_32fc:=getProc(hh,'ippsWinHann_32fc');
  ippsWinHann_64f_I:=getProc(hh,'ippsWinHann_64f_I');
  ippsWinHann_64f:=getProc(hh,'ippsWinHann_64f');
  ippsWinHann_64fc_I:=getProc(hh,'ippsWinHann_64fc_I');
  ippsWinHann_64fc:=getProc(hh,'ippsWinHann_64fc');
  ippsWinHamming_16s_I:=getProc(hh,'ippsWinHamming_16s_I');
  ippsWinHamming_16s:=getProc(hh,'ippsWinHamming_16s');
  ippsWinHamming_16sc_I:=getProc(hh,'ippsWinHamming_16sc_I');
  ippsWinHamming_16sc:=getProc(hh,'ippsWinHamming_16sc');
  ippsWinHamming_32f_I:=getProc(hh,'ippsWinHamming_32f_I');
  ippsWinHamming_32f:=getProc(hh,'ippsWinHamming_32f');
  ippsWinHamming_32fc_I:=getProc(hh,'ippsWinHamming_32fc_I');
  ippsWinHamming_32fc:=getProc(hh,'ippsWinHamming_32fc');
  ippsWinHamming_64f_I:=getProc(hh,'ippsWinHamming_64f_I');
  ippsWinHamming_64f:=getProc(hh,'ippsWinHamming_64f');
  ippsWinHamming_64fc_I:=getProc(hh,'ippsWinHamming_64fc_I');
  ippsWinHamming_64fc:=getProc(hh,'ippsWinHamming_64fc');
  ippsWinBlackman_16s_I:=getProc(hh,'ippsWinBlackman_16s_I');
  ippsWinBlackman_16s:=getProc(hh,'ippsWinBlackman_16s');
  ippsWinBlackman_16sc_I:=getProc(hh,'ippsWinBlackman_16sc_I');
  ippsWinBlackman_16sc:=getProc(hh,'ippsWinBlackman_16sc');
  ippsWinBlackman_32f_I:=getProc(hh,'ippsWinBlackman_32f_I');
  ippsWinBlackman_32f:=getProc(hh,'ippsWinBlackman_32f');
  ippsWinBlackman_32fc_I:=getProc(hh,'ippsWinBlackman_32fc_I');
  ippsWinBlackman_32fc:=getProc(hh,'ippsWinBlackman_32fc');
  ippsWinBlackman_64f_I:=getProc(hh,'ippsWinBlackman_64f_I');
  ippsWinBlackman_64f:=getProc(hh,'ippsWinBlackman_64f');
  ippsWinBlackman_64fc_I:=getProc(hh,'ippsWinBlackman_64fc_I');
  ippsWinBlackman_64fc:=getProc(hh,'ippsWinBlackman_64fc');
  ippsWinBlackmanStd_16s_I:=getProc(hh,'ippsWinBlackmanStd_16s_I');
  ippsWinBlackmanStd_16s:=getProc(hh,'ippsWinBlackmanStd_16s');
  ippsWinBlackmanStd_16sc_I:=getProc(hh,'ippsWinBlackmanStd_16sc_I');
  ippsWinBlackmanStd_16sc:=getProc(hh,'ippsWinBlackmanStd_16sc');
  ippsWinBlackmanStd_32f_I:=getProc(hh,'ippsWinBlackmanStd_32f_I');
  ippsWinBlackmanStd_32f:=getProc(hh,'ippsWinBlackmanStd_32f');
  ippsWinBlackmanStd_32fc_I:=getProc(hh,'ippsWinBlackmanStd_32fc_I');
  ippsWinBlackmanStd_32fc:=getProc(hh,'ippsWinBlackmanStd_32fc');
  ippsWinBlackmanStd_64f_I:=getProc(hh,'ippsWinBlackmanStd_64f_I');
  ippsWinBlackmanStd_64f:=getProc(hh,'ippsWinBlackmanStd_64f');
  ippsWinBlackmanStd_64fc_I:=getProc(hh,'ippsWinBlackmanStd_64fc_I');
  ippsWinBlackmanStd_64fc:=getProc(hh,'ippsWinBlackmanStd_64fc');
  ippsWinBlackmanOpt_16s_I:=getProc(hh,'ippsWinBlackmanOpt_16s_I');
  ippsWinBlackmanOpt_16s:=getProc(hh,'ippsWinBlackmanOpt_16s');
  ippsWinBlackmanOpt_16sc_I:=getProc(hh,'ippsWinBlackmanOpt_16sc_I');
  ippsWinBlackmanOpt_16sc:=getProc(hh,'ippsWinBlackmanOpt_16sc');
  ippsWinBlackmanOpt_32f_I:=getProc(hh,'ippsWinBlackmanOpt_32f_I');
  ippsWinBlackmanOpt_32f:=getProc(hh,'ippsWinBlackmanOpt_32f');
  ippsWinBlackmanOpt_32fc_I:=getProc(hh,'ippsWinBlackmanOpt_32fc_I');
  ippsWinBlackmanOpt_32fc:=getProc(hh,'ippsWinBlackmanOpt_32fc');
  ippsWinBlackmanOpt_64f_I:=getProc(hh,'ippsWinBlackmanOpt_64f_I');
  ippsWinBlackmanOpt_64f:=getProc(hh,'ippsWinBlackmanOpt_64f');
  ippsWinBlackmanOpt_64fc_I:=getProc(hh,'ippsWinBlackmanOpt_64fc_I');
  ippsWinBlackmanOpt_64fc:=getProc(hh,'ippsWinBlackmanOpt_64fc');
  ippsWinKaiser_16s_I:=getProc(hh,'ippsWinKaiser_16s_I');
  ippsWinKaiser_16s:=getProc(hh,'ippsWinKaiser_16s');
  ippsWinKaiser_16sc_I:=getProc(hh,'ippsWinKaiser_16sc_I');
  ippsWinKaiser_16sc:=getProc(hh,'ippsWinKaiser_16sc');
  ippsWinKaiser_32f_I:=getProc(hh,'ippsWinKaiser_32f_I');
  ippsWinKaiser_32f:=getProc(hh,'ippsWinKaiser_32f');
  ippsWinKaiser_32fc_I:=getProc(hh,'ippsWinKaiser_32fc_I');
  ippsWinKaiser_32fc:=getProc(hh,'ippsWinKaiser_32fc');
  ippsWinKaiser_64f_I:=getProc(hh,'ippsWinKaiser_64f_I');
  ippsWinKaiser_64f:=getProc(hh,'ippsWinKaiser_64f');
  ippsWinKaiser_64fc_I:=getProc(hh,'ippsWinKaiser_64fc_I');
  ippsWinKaiser_64fc:=getProc(hh,'ippsWinKaiser_64fc');
  ippsSum_16s_Sfs:=getProc(hh,'ippsSum_16s_Sfs');
  ippsSum_16sc_Sfs:=getProc(hh,'ippsSum_16sc_Sfs');
  ippsSum_16s32s_Sfs:=getProc(hh,'ippsSum_16s32s_Sfs');
  ippsSum_16sc32sc_Sfs:=getProc(hh,'ippsSum_16sc32sc_Sfs');
  ippsSum_32s_Sfs:=getProc(hh,'ippsSum_32s_Sfs');
  ippsSum_32f:=getProc(hh,'ippsSum_32f');
  ippsSum_32fc:=getProc(hh,'ippsSum_32fc');
  ippsSum_64f:=getProc(hh,'ippsSum_64f');
  ippsSum_64fc:=getProc(hh,'ippsSum_64fc');
  ippsMin_16s:=getProc(hh,'ippsMin_16s');
  ippsMin_32s:=getProc(hh,'ippsMin_32s');
  ippsMin_32f:=getProc(hh,'ippsMin_32f');
  ippsMin_64f:=getProc(hh,'ippsMin_64f');
  ippsMax_16s:=getProc(hh,'ippsMax_16s');
  ippsMax_32s:=getProc(hh,'ippsMax_32s');
  ippsMax_32f:=getProc(hh,'ippsMax_32f');
  ippsMax_64f:=getProc(hh,'ippsMax_64f');
  ippsMinMax_8u:=getProc(hh,'ippsMinMax_8u');
  ippsMinMax_16u:=getProc(hh,'ippsMinMax_16u');
  ippsMinMax_16s:=getProc(hh,'ippsMinMax_16s');
  ippsMinMax_32u:=getProc(hh,'ippsMinMax_32u');
  ippsMinMax_32s:=getProc(hh,'ippsMinMax_32s');
  ippsMinMax_32f:=getProc(hh,'ippsMinMax_32f');
  ippsMinMax_64f:=getProc(hh,'ippsMinMax_64f');
  ippsMinAbs_16s:=getProc(hh,'ippsMinAbs_16s');
  ippsMinAbs_32s:=getProc(hh,'ippsMinAbs_32s');
  ippsMinAbs_32f:=getProc(hh,'ippsMinAbs_32f');
  ippsMinAbs_64f:=getProc(hh,'ippsMinAbs_64f');
  ippsMaxAbs_16s:=getProc(hh,'ippsMaxAbs_16s');
  ippsMaxAbs_32s:=getProc(hh,'ippsMaxAbs_32s');
  ippsMaxAbs_32f:=getProc(hh,'ippsMaxAbs_32f');
  ippsMaxAbs_64f:=getProc(hh,'ippsMaxAbs_64f');
  ippsMinIndx_16s:=getProc(hh,'ippsMinIndx_16s');
  ippsMinIndx_32s:=getProc(hh,'ippsMinIndx_32s');
  ippsMinIndx_32f:=getProc(hh,'ippsMinIndx_32f');
  ippsMinIndx_64f:=getProc(hh,'ippsMinIndx_64f');
  ippsMaxIndx_16s:=getProc(hh,'ippsMaxIndx_16s');
  ippsMaxIndx_32s:=getProc(hh,'ippsMaxIndx_32s');
  ippsMaxIndx_32f:=getProc(hh,'ippsMaxIndx_32f');
  ippsMaxIndx_64f:=getProc(hh,'ippsMaxIndx_64f');
  ippsMinMaxIndx_8u:=getProc(hh,'ippsMinMaxIndx_8u');
  ippsMinMaxIndx_16u:=getProc(hh,'ippsMinMaxIndx_16u');
  ippsMinMaxIndx_16s:=getProc(hh,'ippsMinMaxIndx_16s');
  ippsMinMaxIndx_32u:=getProc(hh,'ippsMinMaxIndx_32u');
  ippsMinMaxIndx_32s:=getProc(hh,'ippsMinMaxIndx_32s');
  ippsMinMaxIndx_32f:=getProc(hh,'ippsMinMaxIndx_32f');
  ippsMinMaxIndx_64f:=getProc(hh,'ippsMinMaxIndx_64f');
  ippsMinAbsIndx_16s:=getProc(hh,'ippsMinAbsIndx_16s');
  ippsMinAbsIndx_32s:=getProc(hh,'ippsMinAbsIndx_32s');
  ippsMaxAbsIndx_16s:=getProc(hh,'ippsMaxAbsIndx_16s');
  ippsMaxAbsIndx_32s:=getProc(hh,'ippsMaxAbsIndx_32s');
  ippsMean_16s_Sfs:=getProc(hh,'ippsMean_16s_Sfs');
  ippsMean_16sc_Sfs:=getProc(hh,'ippsMean_16sc_Sfs');
  ippsMean_32s_Sfs:=getProc(hh,'ippsMean_32s_Sfs');
  ippsMean_32f:=getProc(hh,'ippsMean_32f');
  ippsMean_32fc:=getProc(hh,'ippsMean_32fc');
  ippsMean_64f:=getProc(hh,'ippsMean_64f');
  ippsMean_64fc:=getProc(hh,'ippsMean_64fc');
  ippsStdDev_16s_Sfs:=getProc(hh,'ippsStdDev_16s_Sfs');
  ippsStdDev_16s32s_Sfs:=getProc(hh,'ippsStdDev_16s32s_Sfs');
  ippsStdDev_32f:=getProc(hh,'ippsStdDev_32f');
  ippsStdDev_64f:=getProc(hh,'ippsStdDev_64f');
  ippsMeanStdDev_16s_Sfs:=getProc(hh,'ippsMeanStdDev_16s_Sfs');
  ippsMeanStdDev_16s32s_Sfs:=getProc(hh,'ippsMeanStdDev_16s32s_Sfs');
  ippsMeanStdDev_32f:=getProc(hh,'ippsMeanStdDev_32f');
  ippsMeanStdDev_64f:=getProc(hh,'ippsMeanStdDev_64f');
  ippsNorm_Inf_16s32s_Sfs:=getProc(hh,'ippsNorm_Inf_16s32s_Sfs');
  ippsNorm_Inf_16s32f:=getProc(hh,'ippsNorm_Inf_16s32f');
  ippsNorm_Inf_32f:=getProc(hh,'ippsNorm_Inf_32f');
  ippsNorm_Inf_32fc32f:=getProc(hh,'ippsNorm_Inf_32fc32f');
  ippsNorm_Inf_64f:=getProc(hh,'ippsNorm_Inf_64f');
  ippsNorm_Inf_64fc64f:=getProc(hh,'ippsNorm_Inf_64fc64f');
  ippsNorm_L1_16s32s_Sfs:=getProc(hh,'ippsNorm_L1_16s32s_Sfs');
  ippsNorm_L1_16s64s_Sfs:=getProc(hh,'ippsNorm_L1_16s64s_Sfs');
  ippsNorm_L1_16s32f:=getProc(hh,'ippsNorm_L1_16s32f');
  ippsNorm_L1_32f:=getProc(hh,'ippsNorm_L1_32f');
  ippsNorm_L1_32fc64f:=getProc(hh,'ippsNorm_L1_32fc64f');
  ippsNorm_L1_64f:=getProc(hh,'ippsNorm_L1_64f');
  ippsNorm_L1_64fc64f:=getProc(hh,'ippsNorm_L1_64fc64f');
  ippsNorm_L2_16s32s_Sfs:=getProc(hh,'ippsNorm_L2_16s32s_Sfs');
  ippsNorm_L2_16s32f:=getProc(hh,'ippsNorm_L2_16s32f');
  ippsNorm_L2_32f:=getProc(hh,'ippsNorm_L2_32f');
  ippsNorm_L2_32fc64f:=getProc(hh,'ippsNorm_L2_32fc64f');
  ippsNorm_L2_64f:=getProc(hh,'ippsNorm_L2_64f');
  ippsNorm_L2_64fc64f:=getProc(hh,'ippsNorm_L2_64fc64f');
  ippsNorm_L2Sqr_16s64s_Sfs:=getProc(hh,'ippsNorm_L2Sqr_16s64s_Sfs');
end;

procedure InitIPPS3;
begin
  ippsNormDiff_Inf_16s32s_Sfs:=getProc(hh,'ippsNormDiff_Inf_16s32s_Sfs');
  ippsNormDiff_Inf_16s32f:=getProc(hh,'ippsNormDiff_Inf_16s32f');
  ippsNormDiff_Inf_32f:=getProc(hh,'ippsNormDiff_Inf_32f');
  ippsNormDiff_Inf_32fc32f:=getProc(hh,'ippsNormDiff_Inf_32fc32f');
  ippsNormDiff_Inf_64f:=getProc(hh,'ippsNormDiff_Inf_64f');
  ippsNormDiff_Inf_64fc64f:=getProc(hh,'ippsNormDiff_Inf_64fc64f');
  ippsNormDiff_L1_16s32s_Sfs:=getProc(hh,'ippsNormDiff_L1_16s32s_Sfs');
  ippsNormDiff_L1_16s64s_Sfs:=getProc(hh,'ippsNormDiff_L1_16s64s_Sfs');
  ippsNormDiff_L1_16s32f:=getProc(hh,'ippsNormDiff_L1_16s32f');
  ippsNormDiff_L1_32f:=getProc(hh,'ippsNormDiff_L1_32f');
  ippsNormDiff_L1_32fc64f:=getProc(hh,'ippsNormDiff_L1_32fc64f');
  ippsNormDiff_L1_64f:=getProc(hh,'ippsNormDiff_L1_64f');
  ippsNormDiff_L1_64fc64f:=getProc(hh,'ippsNormDiff_L1_64fc64f');
  ippsNormDiff_L2_16s32s_Sfs:=getProc(hh,'ippsNormDiff_L2_16s32s_Sfs');
  ippsNormDiff_L2_16s32f:=getProc(hh,'ippsNormDiff_L2_16s32f');
  ippsNormDiff_L2_32f:=getProc(hh,'ippsNormDiff_L2_32f');
  ippsNormDiff_L2_32fc64f:=getProc(hh,'ippsNormDiff_L2_32fc64f');
  ippsNormDiff_L2_64f:=getProc(hh,'ippsNormDiff_L2_64f');
  ippsNormDiff_L2_64fc64f:=getProc(hh,'ippsNormDiff_L2_64fc64f');
  ippsNormDiff_L2Sqr_16s64s_Sfs:=getProc(hh,'ippsNormDiff_L2Sqr_16s64s_Sfs');
  ippsDotProd_16s32s_Sfs:=getProc(hh,'ippsDotProd_16s32s_Sfs');
  ippsDotProd_16s64s:=getProc(hh,'ippsDotProd_16s64s');
  ippsDotProd_16sc64sc:=getProc(hh,'ippsDotProd_16sc64sc');
  ippsDotProd_16s16sc64sc:=getProc(hh,'ippsDotProd_16s16sc64sc');
  ippsDotProd_16s32s32s_Sfs:=getProc(hh,'ippsDotProd_16s32s32s_Sfs');
  ippsDotProd_16s32f:=getProc(hh,'ippsDotProd_16s32f');
  ippsDotProd_32s_Sfs:=getProc(hh,'ippsDotProd_32s_Sfs');
  ippsDotProd_32f:=getProc(hh,'ippsDotProd_32f');
  ippsDotProd_32fc:=getProc(hh,'ippsDotProd_32fc');
  ippsDotProd_32f32fc:=getProc(hh,'ippsDotProd_32f32fc');
  ippsDotProd_32f32fc64fc:=getProc(hh,'ippsDotProd_32f32fc64fc');
  ippsDotProd_32f64f:=getProc(hh,'ippsDotProd_32f64f');
  ippsDotProd_32fc64fc:=getProc(hh,'ippsDotProd_32fc64fc');
  ippsDotProd_64f:=getProc(hh,'ippsDotProd_64f');
  ippsDotProd_64fc:=getProc(hh,'ippsDotProd_64fc');
  ippsDotProd_64f64fc:=getProc(hh,'ippsDotProd_64f64fc');
  ippsMinEvery_8u_I:=getProc(hh,'ippsMinEvery_8u_I');
  ippsMinEvery_16u_I:=getProc(hh,'ippsMinEvery_16u_I');
  ippsMinEvery_16s_I:=getProc(hh,'ippsMinEvery_16s_I');
  ippsMinEvery_32s_I:=getProc(hh,'ippsMinEvery_32s_I');
  ippsMinEvery_32f_I:=getProc(hh,'ippsMinEvery_32f_I');
  ippsMinEvery_64f_I:=getProc(hh,'ippsMinEvery_64f_I');
  ippsMinEvery_8u:=getProc(hh,'ippsMinEvery_8u');
  ippsMinEvery_16u:=getProc(hh,'ippsMinEvery_16u');
  ippsMinEvery_32f:=getProc(hh,'ippsMinEvery_32f');
  ippsMinEvery_64f:=getProc(hh,'ippsMinEvery_64f');
  ippsMaxEvery_8u_I:=getProc(hh,'ippsMaxEvery_8u_I');
  ippsMaxEvery_16u_I:=getProc(hh,'ippsMaxEvery_16u_I');
  ippsMaxEvery_16s_I:=getProc(hh,'ippsMaxEvery_16s_I');
  ippsMaxEvery_32s_I:=getProc(hh,'ippsMaxEvery_32s_I');
  ippsMaxEvery_32f_I:=getProc(hh,'ippsMaxEvery_32f_I');
  ippsMaxEvery_64f_I:=getProc(hh,'ippsMaxEvery_64f_I');
  ippsMaxEvery_8u:=getProc(hh,'ippsMaxEvery_8u');
  ippsMaxEvery_16u:=getProc(hh,'ippsMaxEvery_16u');
  ippsMaxEvery_32f:=getProc(hh,'ippsMaxEvery_32f');
  ippsMaxEvery_64f:=getProc(hh,'ippsMaxEvery_64f');
  ippsMaxOrder_16s:=getProc(hh,'ippsMaxOrder_16s');
  ippsMaxOrder_32s:=getProc(hh,'ippsMaxOrder_32s');
  ippsMaxOrder_32f:=getProc(hh,'ippsMaxOrder_32f');
  ippsMaxOrder_64f:=getProc(hh,'ippsMaxOrder_64f');
  ippsCountInRange_32s:=getProc(hh,'ippsCountInRange_32s');
  ippsZeroCrossing_16s32f:=getProc(hh,'ippsZeroCrossing_16s32f');
  ippsZeroCrossing_32f:=getProc(hh,'ippsZeroCrossing_32f');
  ippsSampleUp_16s:=getProc(hh,'ippsSampleUp_16s');
  ippsSampleUp_16sc:=getProc(hh,'ippsSampleUp_16sc');
  ippsSampleUp_32f:=getProc(hh,'ippsSampleUp_32f');
  ippsSampleUp_32fc:=getProc(hh,'ippsSampleUp_32fc');
  ippsSampleUp_64f:=getProc(hh,'ippsSampleUp_64f');
  ippsSampleUp_64fc:=getProc(hh,'ippsSampleUp_64fc');
  ippsSampleDown_16s:=getProc(hh,'ippsSampleDown_16s');
  ippsSampleDown_16sc:=getProc(hh,'ippsSampleDown_16sc');
  ippsSampleDown_32f:=getProc(hh,'ippsSampleDown_32f');
  ippsSampleDown_32fc:=getProc(hh,'ippsSampleDown_32fc');
  ippsSampleDown_64f:=getProc(hh,'ippsSampleDown_64f');
  ippsSampleDown_64fc:=getProc(hh,'ippsSampleDown_64fc');
  ippsAutoCorrNormGetBufferSize:=getProc(hh,'ippsAutoCorrNormGetBufferSize');
  ippsAutoCorrNorm_32f:=getProc(hh,'ippsAutoCorrNorm_32f');
  ippsAutoCorrNorm_64f:=getProc(hh,'ippsAutoCorrNorm_64f');
  ippsAutoCorrNorm_32fc:=getProc(hh,'ippsAutoCorrNorm_32fc');
  ippsAutoCorrNorm_64fc:=getProc(hh,'ippsAutoCorrNorm_64fc');
  ippsCrossCorrNormGetBufferSize:=getProc(hh,'ippsCrossCorrNormGetBufferSize');
  ippsCrossCorrNorm_32f:=getProc(hh,'ippsCrossCorrNorm_32f');
  ippsCrossCorrNorm_64f:=getProc(hh,'ippsCrossCorrNorm_64f');
  ippsCrossCorrNorm_32fc:=getProc(hh,'ippsCrossCorrNorm_32fc');
  ippsCrossCorrNorm_64fc:=getProc(hh,'ippsCrossCorrNorm_64fc');
  ippsConvolveGetBufferSize:=getProc(hh,'ippsConvolveGetBufferSize');
  ippsConvolve_32f:=getProc(hh,'ippsConvolve_32f');
  ippsConvolve_64f:=getProc(hh,'ippsConvolve_64f');
  ippsConvBiased_32f:=getProc(hh,'ippsConvBiased_32f');
  ippsSumWindow_8u32f:=getProc(hh,'ippsSumWindow_8u32f');
  ippsSumWindow_16s32f:=getProc(hh,'ippsSumWindow_16s32f');
  ippsFIRSRGetSize:=getProc(hh,'ippsFIRSRGetSize');
  ippsFIRSRInit_32f:=getProc(hh,'ippsFIRSRInit_32f');
  ippsFIRSRInit_64f:=getProc(hh,'ippsFIRSRInit_64f');
  ippsFIRSRInit_32fc:=getProc(hh,'ippsFIRSRInit_32fc');
  ippsFIRSRInit_64fc:=getProc(hh,'ippsFIRSRInit_64fc');
  ippsFIRSR_16s:=getProc(hh,'ippsFIRSR_16s');
  ippsFIRSR_16sc:=getProc(hh,'ippsFIRSR_16sc');
  ippsFIRSR_32f:=getProc(hh,'ippsFIRSR_32f');
  ippsFIRSR_64f:=getProc(hh,'ippsFIRSR_64f');
  ippsFIRSR_32fc:=getProc(hh,'ippsFIRSR_32fc');
  ippsFIRSR_64fc:=getProc(hh,'ippsFIRSR_64fc');
  ippsFIRMRGetSize:=getProc(hh,'ippsFIRMRGetSize');
  ippsFIRMRInit_32f:=getProc(hh,'ippsFIRMRInit_32f');
  ippsFIRMRInit_64f:=getProc(hh,'ippsFIRMRInit_64f');
  ippsFIRMRInit_32fc:=getProc(hh,'ippsFIRMRInit_32fc');
  ippsFIRMRInit_64fc:=getProc(hh,'ippsFIRMRInit_64fc');
  ippsFIRMR_16s:=getProc(hh,'ippsFIRMR_16s');
  ippsFIRMR_16sc:=getProc(hh,'ippsFIRMR_16sc');
  ippsFIRMR_32f:=getProc(hh,'ippsFIRMR_32f');
  ippsFIRMR_64f:=getProc(hh,'ippsFIRMR_64f');
  ippsFIRMR_32fc:=getProc(hh,'ippsFIRMR_32fc');
  ippsFIRMR_64fc:=getProc(hh,'ippsFIRMR_64fc');
  ippsFIRSparseGetStateSize_32f:=getProc(hh,'ippsFIRSparseGetStateSize_32f');
  ippsFIRSparseInit_32f:=getProc(hh,'ippsFIRSparseInit_32f');
  ippsFIRSparse_32f:=getProc(hh,'ippsFIRSparse_32f');
  ippsFIRSparseSetDlyLine_32f:=getProc(hh,'ippsFIRSparseSetDlyLine_32f');
  ippsFIRSparseGetDlyLine_32f:=getProc(hh,'ippsFIRSparseGetDlyLine_32f');
  ippsFIRGenGetBufferSize:=getProc(hh,'ippsFIRGenGetBufferSize');
  ippsFIRGenLowpass_64f:=getProc(hh,'ippsFIRGenLowpass_64f');
  ippsFIRGenHighpass_64f:=getProc(hh,'ippsFIRGenHighpass_64f');
  ippsFIRGenBandpass_64f:=getProc(hh,'ippsFIRGenBandpass_64f');
  ippsFIRGenBandstop_64f:=getProc(hh,'ippsFIRGenBandstop_64f');
  ippsFIRLMSGetStateSize32f_16s:=getProc(hh,'ippsFIRLMSGetStateSize32f_16s');
  ippsFIRLMSGetStateSize_32f:=getProc(hh,'ippsFIRLMSGetStateSize_32f');
  ippsFIRLMSInit32f_16s:=getProc(hh,'ippsFIRLMSInit32f_16s');
  ippsFIRLMSInit_32f:=getProc(hh,'ippsFIRLMSInit_32f');
  ippsFIRLMS32f_16s:=getProc(hh,'ippsFIRLMS32f_16s');
  ippsFIRLMS_32f:=getProc(hh,'ippsFIRLMS_32f');
  ippsFIRLMSGetTaps32f_16s:=getProc(hh,'ippsFIRLMSGetTaps32f_16s');
  ippsFIRLMSGetTaps_32f:=getProc(hh,'ippsFIRLMSGetTaps_32f');
  ippsFIRLMSGetDlyLine32f_16s:=getProc(hh,'ippsFIRLMSGetDlyLine32f_16s');
  ippsFIRLMSGetDlyLine_32f:=getProc(hh,'ippsFIRLMSGetDlyLine_32f');
  ippsFIRLMSSetDlyLine32f_16s:=getProc(hh,'ippsFIRLMSSetDlyLine32f_16s');
  ippsFIRLMSSetDlyLine_32f:=getProc(hh,'ippsFIRLMSSetDlyLine_32f');
  ippsIIRGetDlyLine32f_16s:=getProc(hh,'ippsIIRGetDlyLine32f_16s');
  ippsIIRGetDlyLine32fc_16sc:=getProc(hh,'ippsIIRGetDlyLine32fc_16sc');
  ippsIIRGetDlyLine_32f:=getProc(hh,'ippsIIRGetDlyLine_32f');
  ippsIIRGetDlyLine_32fc:=getProc(hh,'ippsIIRGetDlyLine_32fc');
  ippsIIRGetDlyLine64f_16s:=getProc(hh,'ippsIIRGetDlyLine64f_16s');
  ippsIIRGetDlyLine64fc_16sc:=getProc(hh,'ippsIIRGetDlyLine64fc_16sc');
  ippsIIRGetDlyLine64f_32s:=getProc(hh,'ippsIIRGetDlyLine64f_32s');
  ippsIIRGetDlyLine64fc_32sc:=getProc(hh,'ippsIIRGetDlyLine64fc_32sc');
  ippsIIRGetDlyLine64f_DF1_32s:=getProc(hh,'ippsIIRGetDlyLine64f_DF1_32s');
  ippsIIRGetDlyLine64f_32f:=getProc(hh,'ippsIIRGetDlyLine64f_32f');
  ippsIIRGetDlyLine64fc_32fc:=getProc(hh,'ippsIIRGetDlyLine64fc_32fc');
  ippsIIRGetDlyLine_64f:=getProc(hh,'ippsIIRGetDlyLine_64f');
  ippsIIRGetDlyLine_64fc:=getProc(hh,'ippsIIRGetDlyLine_64fc');
  ippsIIRSetDlyLine32f_16s:=getProc(hh,'ippsIIRSetDlyLine32f_16s');
  ippsIIRSetDlyLine32fc_16sc:=getProc(hh,'ippsIIRSetDlyLine32fc_16sc');
  ippsIIRSetDlyLine_32f:=getProc(hh,'ippsIIRSetDlyLine_32f');
  ippsIIRSetDlyLine_32fc:=getProc(hh,'ippsIIRSetDlyLine_32fc');
  ippsIIRSetDlyLine64f_16s:=getProc(hh,'ippsIIRSetDlyLine64f_16s');
  ippsIIRSetDlyLine64fc_16sc:=getProc(hh,'ippsIIRSetDlyLine64fc_16sc');
  ippsIIRSetDlyLine64f_32s:=getProc(hh,'ippsIIRSetDlyLine64f_32s');
  ippsIIRSetDlyLine64fc_32sc:=getProc(hh,'ippsIIRSetDlyLine64fc_32sc');
  ippsIIRSetDlyLine64f_DF1_32s:=getProc(hh,'ippsIIRSetDlyLine64f_DF1_32s');
  ippsIIRSetDlyLine64f_32f:=getProc(hh,'ippsIIRSetDlyLine64f_32f');
  ippsIIRSetDlyLine64fc_32fc:=getProc(hh,'ippsIIRSetDlyLine64fc_32fc');
  ippsIIRSetDlyLine_64f:=getProc(hh,'ippsIIRSetDlyLine_64f');
  ippsIIRSetDlyLine_64fc:=getProc(hh,'ippsIIRSetDlyLine_64fc');
  ippsIIR32f_16s_ISfs:=getProc(hh,'ippsIIR32f_16s_ISfs');
  ippsIIR32f_16s_Sfs:=getProc(hh,'ippsIIR32f_16s_Sfs');
  ippsIIR32fc_16sc_ISfs:=getProc(hh,'ippsIIR32fc_16sc_ISfs');
  ippsIIR32fc_16sc_Sfs:=getProc(hh,'ippsIIR32fc_16sc_Sfs');
  ippsIIR_32f_I:=getProc(hh,'ippsIIR_32f_I');
  ippsIIR_32f:=getProc(hh,'ippsIIR_32f');
  ippsIIR_32fc_I:=getProc(hh,'ippsIIR_32fc_I');
  ippsIIR_32fc:=getProc(hh,'ippsIIR_32fc');
  ippsIIR64f_16s_ISfs:=getProc(hh,'ippsIIR64f_16s_ISfs');
  ippsIIR64f_16s_Sfs:=getProc(hh,'ippsIIR64f_16s_Sfs');
  ippsIIR64fc_16sc_ISfs:=getProc(hh,'ippsIIR64fc_16sc_ISfs');
  ippsIIR64fc_16sc_Sfs:=getProc(hh,'ippsIIR64fc_16sc_Sfs');
  ippsIIR64f_32s_ISfs:=getProc(hh,'ippsIIR64f_32s_ISfs');
  ippsIIR64f_32s_Sfs:=getProc(hh,'ippsIIR64f_32s_Sfs');
  ippsIIR64fc_32sc_ISfs:=getProc(hh,'ippsIIR64fc_32sc_ISfs');
  ippsIIR64fc_32sc_Sfs:=getProc(hh,'ippsIIR64fc_32sc_Sfs');
  ippsIIR64f_32f_I:=getProc(hh,'ippsIIR64f_32f_I');
  ippsIIR64f_32f:=getProc(hh,'ippsIIR64f_32f');
  ippsIIR64fc_32fc_I:=getProc(hh,'ippsIIR64fc_32fc_I');
  ippsIIR64fc_32fc:=getProc(hh,'ippsIIR64fc_32fc');
  ippsIIR_64f_I:=getProc(hh,'ippsIIR_64f_I');
  ippsIIR_64f:=getProc(hh,'ippsIIR_64f');
  ippsIIR_64fc_I:=getProc(hh,'ippsIIR_64fc_I');
  ippsIIR_64fc:=getProc(hh,'ippsIIR_64fc');
  ippsIIR_32f_IP:=getProc(hh,'ippsIIR_32f_IP');
  ippsIIR_32f_P:=getProc(hh,'ippsIIR_32f_P');
  ippsIIR64f_32s_IPSfs:=getProc(hh,'ippsIIR64f_32s_IPSfs');
  ippsIIR64f_32s_PSfs:=getProc(hh,'ippsIIR64f_32s_PSfs');
  ippsIIRGetStateSize32f_16s:=getProc(hh,'ippsIIRGetStateSize32f_16s');
  ippsIIRGetStateSize32fc_16sc:=getProc(hh,'ippsIIRGetStateSize32fc_16sc');
  ippsIIRGetStateSize_32f:=getProc(hh,'ippsIIRGetStateSize_32f');
  ippsIIRGetStateSize_32fc:=getProc(hh,'ippsIIRGetStateSize_32fc');
  ippsIIRGetStateSize64f_16s:=getProc(hh,'ippsIIRGetStateSize64f_16s');
  ippsIIRGetStateSize64fc_16sc:=getProc(hh,'ippsIIRGetStateSize64fc_16sc');
  ippsIIRGetStateSize64f_32s:=getProc(hh,'ippsIIRGetStateSize64f_32s');
  ippsIIRGetStateSize64fc_32sc:=getProc(hh,'ippsIIRGetStateSize64fc_32sc');
  ippsIIRGetStateSize64f_32f:=getProc(hh,'ippsIIRGetStateSize64f_32f');
  ippsIIRGetStateSize64fc_32fc:=getProc(hh,'ippsIIRGetStateSize64fc_32fc');
  ippsIIRGetStateSize_64f:=getProc(hh,'ippsIIRGetStateSize_64f');
  ippsIIRGetStateSize_64fc:=getProc(hh,'ippsIIRGetStateSize_64fc');
  ippsIIRGetStateSize32f_BiQuad_16s:=getProc(hh,'ippsIIRGetStateSize32f_BiQuad_16s');
  ippsIIRGetStateSize32fc_BiQuad_16sc:=getProc(hh,'ippsIIRGetStateSize32fc_BiQuad_16sc');
  ippsIIRGetStateSize_BiQuad_32f:=getProc(hh,'ippsIIRGetStateSize_BiQuad_32f');
  ippsIIRGetStateSize_BiQuad_DF1_32f:=getProc(hh,'ippsIIRGetStateSize_BiQuad_DF1_32f');
  ippsIIRGetStateSize_BiQuad_32fc:=getProc(hh,'ippsIIRGetStateSize_BiQuad_32fc');
  ippsIIRGetStateSize64f_BiQuad_16s:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_16s');
  ippsIIRGetStateSize64fc_BiQuad_16sc:=getProc(hh,'ippsIIRGetStateSize64fc_BiQuad_16sc');
  ippsIIRGetStateSize64f_BiQuad_32s:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_32s');
  ippsIIRGetStateSize64f_BiQuad_DF1_32s:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_DF1_32s');
  ippsIIRGetStateSize64fc_BiQuad_32sc:=getProc(hh,'ippsIIRGetStateSize64fc_BiQuad_32sc');
  ippsIIRGetStateSize64f_BiQuad_32f:=getProc(hh,'ippsIIRGetStateSize64f_BiQuad_32f');
  ippsIIRGetStateSize64fc_BiQuad_32fc:=getProc(hh,'ippsIIRGetStateSize64fc_BiQuad_32fc');
  ippsIIRGetStateSize_BiQuad_64f:=getProc(hh,'ippsIIRGetStateSize_BiQuad_64f');
  ippsIIRGetStateSize_BiQuad_64fc:=getProc(hh,'ippsIIRGetStateSize_BiQuad_64fc');
  ippsIIRInit32f_16s:=getProc(hh,'ippsIIRInit32f_16s');
  ippsIIRInit32fc_16sc:=getProc(hh,'ippsIIRInit32fc_16sc');
  ippsIIRInit_32f:=getProc(hh,'ippsIIRInit_32f');
  ippsIIRInit_32fc:=getProc(hh,'ippsIIRInit_32fc');
  ippsIIRInit64f_16s:=getProc(hh,'ippsIIRInit64f_16s');
  ippsIIRInit64fc_16sc:=getProc(hh,'ippsIIRInit64fc_16sc');
  ippsIIRInit64f_32s:=getProc(hh,'ippsIIRInit64f_32s');
  ippsIIRInit64fc_32sc:=getProc(hh,'ippsIIRInit64fc_32sc');
  ippsIIRInit64f_32f:=getProc(hh,'ippsIIRInit64f_32f');
  ippsIIRInit64fc_32fc:=getProc(hh,'ippsIIRInit64fc_32fc');
  ippsIIRInit_64f:=getProc(hh,'ippsIIRInit_64f');
  ippsIIRInit_64fc:=getProc(hh,'ippsIIRInit_64fc');
  ippsIIRInit32f_BiQuad_16s:=getProc(hh,'ippsIIRInit32f_BiQuad_16s');
  ippsIIRInit32fc_BiQuad_16sc:=getProc(hh,'ippsIIRInit32fc_BiQuad_16sc');
  ippsIIRInit_BiQuad_32f:=getProc(hh,'ippsIIRInit_BiQuad_32f');
  ippsIIRInit_BiQuad_DF1_32f:=getProc(hh,'ippsIIRInit_BiQuad_DF1_32f');
  ippsIIRInit_BiQuad_32fc:=getProc(hh,'ippsIIRInit_BiQuad_32fc');
  ippsIIRInit64f_BiQuad_16s:=getProc(hh,'ippsIIRInit64f_BiQuad_16s');
  ippsIIRInit64fc_BiQuad_16sc:=getProc(hh,'ippsIIRInit64fc_BiQuad_16sc');
  ippsIIRInit64f_BiQuad_32s:=getProc(hh,'ippsIIRInit64f_BiQuad_32s');
  ippsIIRInit64f_BiQuad_DF1_32s:=getProc(hh,'ippsIIRInit64f_BiQuad_DF1_32s');
  ippsIIRInit64fc_BiQuad_32sc:=getProc(hh,'ippsIIRInit64fc_BiQuad_32sc');
  ippsIIRInit64f_BiQuad_32f:=getProc(hh,'ippsIIRInit64f_BiQuad_32f');
  ippsIIRInit64fc_BiQuad_32fc:=getProc(hh,'ippsIIRInit64fc_BiQuad_32fc');
  ippsIIRInit_BiQuad_64f:=getProc(hh,'ippsIIRInit_BiQuad_64f');
  ippsIIRInit_BiQuad_64fc:=getProc(hh,'ippsIIRInit_BiQuad_64fc');
  ippsIIRSparseGetStateSize_32f:=getProc(hh,'ippsIIRSparseGetStateSize_32f');
  ippsIIRSparseInit_32f:=getProc(hh,'ippsIIRSparseInit_32f');
  ippsIIRSparse_32f:=getProc(hh,'ippsIIRSparse_32f');
  ippsIIRGenLowpass_64f:=getProc(hh,'ippsIIRGenLowpass_64f');
  ippsIIRGenHighpass_64f:=getProc(hh,'ippsIIRGenHighpass_64f');
  ippsIIRGenGetBufferSize:=getProc(hh,'ippsIIRGenGetBufferSize');
  ippsFilterMedianGetBufferSize:=getProc(hh,'ippsFilterMedianGetBufferSize');
  ippsFilterMedian_8u_I:=getProc(hh,'ippsFilterMedian_8u_I');
  ippsFilterMedian_8u:=getProc(hh,'ippsFilterMedian_8u');
  ippsFilterMedian_16s_I:=getProc(hh,'ippsFilterMedian_16s_I');
  ippsFilterMedian_16s:=getProc(hh,'ippsFilterMedian_16s');
  ippsFilterMedian_32s_I:=getProc(hh,'ippsFilterMedian_32s_I');
  ippsFilterMedian_32s:=getProc(hh,'ippsFilterMedian_32s');
  ippsFilterMedian_32f_I:=getProc(hh,'ippsFilterMedian_32f_I');
  ippsFilterMedian_32f:=getProc(hh,'ippsFilterMedian_32f');
  ippsFilterMedian_64f_I:=getProc(hh,'ippsFilterMedian_64f_I');
  ippsFilterMedian_64f:=getProc(hh,'ippsFilterMedian_64f');
  ippsResamplePolyphase_16s:=getProc(hh,'ippsResamplePolyphase_16s');
  ippsResamplePolyphase_32f:=getProc(hh,'ippsResamplePolyphase_32f');
  ippsResamplePolyphaseFixed_16s:=getProc(hh,'ippsResamplePolyphaseFixed_16s');
  ippsResamplePolyphaseFixed_32f:=getProc(hh,'ippsResamplePolyphaseFixed_32f');
  ippsResamplePolyphaseGetSize_16s:=getProc(hh,'ippsResamplePolyphaseGetSize_16s');
  ippsResamplePolyphaseGetSize_32f:=getProc(hh,'ippsResamplePolyphaseGetSize_32f');
  ippsResamplePolyphaseFixedGetSize_16s:=getProc(hh,'ippsResamplePolyphaseFixedGetSize_16s');
  ippsResamplePolyphaseFixedGetSize_32f:=getProc(hh,'ippsResamplePolyphaseFixedGetSize_32f');
  ippsResamplePolyphaseInit_16s:=getProc(hh,'ippsResamplePolyphaseInit_16s');
  ippsResamplePolyphaseInit_32f:=getProc(hh,'ippsResamplePolyphaseInit_32f');
  ippsResamplePolyphaseFixedInit_16s:=getProc(hh,'ippsResamplePolyphaseFixedInit_16s');
  ippsResamplePolyphaseFixedInit_32f:=getProc(hh,'ippsResamplePolyphaseFixedInit_32f');
  ippsResamplePolyphaseSetFixedFilter_16s:=getProc(hh,'ippsResamplePolyphaseSetFixedFilter_16s');
  ippsResamplePolyphaseSetFixedFilter_32f:=getProc(hh,'ippsResamplePolyphaseSetFixedFilter_32f');
  ippsResamplePolyphaseGetFixedFilter_16s:=getProc(hh,'ippsResamplePolyphaseGetFixedFilter_16s');
  ippsResamplePolyphaseGetFixedFilter_32f:=getProc(hh,'ippsResamplePolyphaseGetFixedFilter_32f');
  ippsIIRIIRGetStateSize_32f:=getProc(hh,'ippsIIRIIRGetStateSize_32f');
  ippsIIRIIRGetStateSize64f_32f:=getProc(hh,'ippsIIRIIRGetStateSize64f_32f');
  ippsIIRIIRGetStateSize_64f:=getProc(hh,'ippsIIRIIRGetStateSize_64f');
  ippsIIRIIRInit64f_32f:=getProc(hh,'ippsIIRIIRInit64f_32f');
  ippsIIRIIRInit_32f:=getProc(hh,'ippsIIRIIRInit_32f');
  ippsIIRIIRInit_64f:=getProc(hh,'ippsIIRIIRInit_64f');
  ippsIIRIIR_32f_I:=getProc(hh,'ippsIIRIIR_32f_I');
  ippsIIRIIR_32f:=getProc(hh,'ippsIIRIIR_32f');
  ippsIIRIIR64f_32f_I:=getProc(hh,'ippsIIRIIR64f_32f_I');
  ippsIIRIIR64f_32f:=getProc(hh,'ippsIIRIIR64f_32f');
  ippsIIRIIR_64f_I:=getProc(hh,'ippsIIRIIR_64f_I');
  ippsIIRIIR_64f:=getProc(hh,'ippsIIRIIR_64f');
  ippsIIRIIRGetDlyLine64f_32f:=getProc(hh,'ippsIIRIIRGetDlyLine64f_32f');
  ippsIIRIIRSetDlyLine64f_32f:=getProc(hh,'ippsIIRIIRSetDlyLine64f_32f');
  ippsIIRIIRGetDlyLine_32f:=getProc(hh,'ippsIIRIIRGetDlyLine_32f');
  ippsIIRIIRSetDlyLine_32f:=getProc(hh,'ippsIIRIIRSetDlyLine_32f');
  ippsIIRIIRGetDlyLine_64f:=getProc(hh,'ippsIIRIIRGetDlyLine_64f');
  ippsIIRIIRSetDlyLine_64f:=getProc(hh,'ippsIIRIIRSetDlyLine_64f');
  ippsFFTGetSize_C_32f:=getProc(hh,'ippsFFTGetSize_C_32f');
  ippsFFTGetSize_R_32f:=getProc(hh,'ippsFFTGetSize_R_32f');
  ippsFFTGetSize_C_32fc:=getProc(hh,'ippsFFTGetSize_C_32fc');
  ippsFFTGetSize_C_64f:=getProc(hh,'ippsFFTGetSize_C_64f');
  ippsFFTGetSize_R_64f:=getProc(hh,'ippsFFTGetSize_R_64f');
  ippsFFTGetSize_C_64fc:=getProc(hh,'ippsFFTGetSize_C_64fc');
  ippsFFTInit_C_32f:=getProc(hh,'ippsFFTInit_C_32f');
  ippsFFTInit_R_32f:=getProc(hh,'ippsFFTInit_R_32f');
  ippsFFTInit_C_32fc:=getProc(hh,'ippsFFTInit_C_32fc');
  ippsFFTInit_C_64f:=getProc(hh,'ippsFFTInit_C_64f');
  ippsFFTInit_R_64f:=getProc(hh,'ippsFFTInit_R_64f');
  ippsFFTInit_C_64fc:=getProc(hh,'ippsFFTInit_C_64fc');
  ippsFFTFwd_CToC_32fc:=getProc(hh,'ippsFFTFwd_CToC_32fc');
  ippsFFTInv_CToC_32fc:=getProc(hh,'ippsFFTInv_CToC_32fc');
  ippsFFTFwd_CToC_64fc:=getProc(hh,'ippsFFTFwd_CToC_64fc');
  ippsFFTInv_CToC_64fc:=getProc(hh,'ippsFFTInv_CToC_64fc');
  ippsFFTFwd_CToC_32fc_I:=getProc(hh,'ippsFFTFwd_CToC_32fc_I');
  ippsFFTInv_CToC_32fc_I:=getProc(hh,'ippsFFTInv_CToC_32fc_I');
  ippsFFTFwd_CToC_64fc_I:=getProc(hh,'ippsFFTFwd_CToC_64fc_I');
  ippsFFTInv_CToC_64fc_I:=getProc(hh,'ippsFFTInv_CToC_64fc_I');
  ippsFFTFwd_CToC_32f_I:=getProc(hh,'ippsFFTFwd_CToC_32f_I');
  ippsFFTInv_CToC_32f_I:=getProc(hh,'ippsFFTInv_CToC_32f_I');
  ippsFFTFwd_CToC_64f_I:=getProc(hh,'ippsFFTFwd_CToC_64f_I');
  ippsFFTInv_CToC_64f_I:=getProc(hh,'ippsFFTInv_CToC_64f_I');
  ippsFFTFwd_CToC_32f:=getProc(hh,'ippsFFTFwd_CToC_32f');
  ippsFFTInv_CToC_32f:=getProc(hh,'ippsFFTInv_CToC_32f');
  ippsFFTFwd_CToC_64f:=getProc(hh,'ippsFFTFwd_CToC_64f');
  ippsFFTInv_CToC_64f:=getProc(hh,'ippsFFTInv_CToC_64f');
  ippsFFTFwd_RToPerm_32f_I:=getProc(hh,'ippsFFTFwd_RToPerm_32f_I');
  ippsFFTFwd_RToPack_32f_I:=getProc(hh,'ippsFFTFwd_RToPack_32f_I');
  ippsFFTFwd_RToCCS_32f_I:=getProc(hh,'ippsFFTFwd_RToCCS_32f_I');
  ippsFFTInv_PermToR_32f_I:=getProc(hh,'ippsFFTInv_PermToR_32f_I');
  ippsFFTInv_PackToR_32f_I:=getProc(hh,'ippsFFTInv_PackToR_32f_I');
  ippsFFTInv_CCSToR_32f_I:=getProc(hh,'ippsFFTInv_CCSToR_32f_I');
  ippsFFTFwd_RToPerm_64f_I:=getProc(hh,'ippsFFTFwd_RToPerm_64f_I');
  ippsFFTFwd_RToPack_64f_I:=getProc(hh,'ippsFFTFwd_RToPack_64f_I');
  ippsFFTFwd_RToCCS_64f_I:=getProc(hh,'ippsFFTFwd_RToCCS_64f_I');
  ippsFFTInv_PermToR_64f_I:=getProc(hh,'ippsFFTInv_PermToR_64f_I');
  ippsFFTInv_PackToR_64f_I:=getProc(hh,'ippsFFTInv_PackToR_64f_I');
  ippsFFTInv_CCSToR_64f_I:=getProc(hh,'ippsFFTInv_CCSToR_64f_I');
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
  ippsDFTGetSize_C_32f:=getProc(hh,'ippsDFTGetSize_C_32f');
  ippsDFTGetSize_R_32f:=getProc(hh,'ippsDFTGetSize_R_32f');
  ippsDFTGetSize_C_32fc:=getProc(hh,'ippsDFTGetSize_C_32fc');
  ippsDFTGetSize_C_64f:=getProc(hh,'ippsDFTGetSize_C_64f');
  ippsDFTGetSize_R_64f:=getProc(hh,'ippsDFTGetSize_R_64f');
  ippsDFTGetSize_C_64fc:=getProc(hh,'ippsDFTGetSize_C_64fc');
  ippsDFTInit_C_32f:=getProc(hh,'ippsDFTInit_C_32f');
  ippsDFTInit_R_32f:=getProc(hh,'ippsDFTInit_R_32f');
  ippsDFTInit_C_32fc:=getProc(hh,'ippsDFTInit_C_32fc');
  ippsDFTInit_C_64f:=getProc(hh,'ippsDFTInit_C_64f');
  ippsDFTInit_R_64f:=getProc(hh,'ippsDFTInit_R_64f');
  ippsDFTInit_C_64fc:=getProc(hh,'ippsDFTInit_C_64fc');
  ippsDFTFwd_CToC_32fc:=getProc(hh,'ippsDFTFwd_CToC_32fc');
  ippsDFTInv_CToC_32fc:=getProc(hh,'ippsDFTInv_CToC_32fc');
  ippsDFTFwd_CToC_64fc:=getProc(hh,'ippsDFTFwd_CToC_64fc');
  ippsDFTInv_CToC_64fc:=getProc(hh,'ippsDFTInv_CToC_64fc');
  ippsDFTFwd_CToC_32f:=getProc(hh,'ippsDFTFwd_CToC_32f');
  ippsDFTInv_CToC_32f:=getProc(hh,'ippsDFTInv_CToC_32f');
  ippsDFTFwd_CToC_64f:=getProc(hh,'ippsDFTFwd_CToC_64f');
  ippsDFTInv_CToC_64f:=getProc(hh,'ippsDFTInv_CToC_64f');
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
  ippsMulPack_32f_I:=getProc(hh,'ippsMulPack_32f_I');
  ippsMulPerm_32f_I:=getProc(hh,'ippsMulPerm_32f_I');
  ippsMulPack_32f:=getProc(hh,'ippsMulPack_32f');
  ippsMulPerm_32f:=getProc(hh,'ippsMulPerm_32f');
  ippsMulPack_64f_I:=getProc(hh,'ippsMulPack_64f_I');
  ippsMulPerm_64f_I:=getProc(hh,'ippsMulPerm_64f_I');
  ippsMulPack_64f:=getProc(hh,'ippsMulPack_64f');
  ippsMulPerm_64f:=getProc(hh,'ippsMulPerm_64f');
  ippsMulPackConj_32f_I:=getProc(hh,'ippsMulPackConj_32f_I');
  ippsMulPackConj_64f_I:=getProc(hh,'ippsMulPackConj_64f_I');
  ippsGoertz_16s_Sfs:=getProc(hh,'ippsGoertz_16s_Sfs');
  ippsGoertz_16sc_Sfs:=getProc(hh,'ippsGoertz_16sc_Sfs');
  ippsGoertz_32f:=getProc(hh,'ippsGoertz_32f');
  ippsGoertz_32fc:=getProc(hh,'ippsGoertz_32fc');
  ippsGoertz_64f:=getProc(hh,'ippsGoertz_64f');
  ippsGoertz_64fc:=getProc(hh,'ippsGoertz_64fc');
  ippsDCTFwdGetSize_32f:=getProc(hh,'ippsDCTFwdGetSize_32f');
  ippsDCTInvGetSize_32f:=getProc(hh,'ippsDCTInvGetSize_32f');
  ippsDCTFwdGetSize_64f:=getProc(hh,'ippsDCTFwdGetSize_64f');
  ippsDCTInvGetSize_64f:=getProc(hh,'ippsDCTInvGetSize_64f');
  ippsDCTFwdInit_32f:=getProc(hh,'ippsDCTFwdInit_32f');
  ippsDCTInvInit_32f:=getProc(hh,'ippsDCTInvInit_32f');
  ippsDCTFwdInit_64f:=getProc(hh,'ippsDCTFwdInit_64f');
  ippsDCTInvInit_64f:=getProc(hh,'ippsDCTInvInit_64f');
  ippsDCTFwd_32f_I:=getProc(hh,'ippsDCTFwd_32f_I');
  ippsDCTInv_32f_I:=getProc(hh,'ippsDCTInv_32f_I');
  ippsDCTFwd_32f:=getProc(hh,'ippsDCTFwd_32f');
  ippsDCTInv_32f:=getProc(hh,'ippsDCTInv_32f');
  ippsDCTFwd_64f_I:=getProc(hh,'ippsDCTFwd_64f_I');
  ippsDCTInv_64f_I:=getProc(hh,'ippsDCTInv_64f_I');
  ippsDCTFwd_64f:=getProc(hh,'ippsDCTFwd_64f');
  ippsDCTInv_64f:=getProc(hh,'ippsDCTInv_64f');
  ippsHilbertGetSize_32f32fc:=getProc(hh,'ippsHilbertGetSize_32f32fc');
  ippsHilbertInit_32f32fc:=getProc(hh,'ippsHilbertInit_32f32fc');
  ippsHilbert_32f32fc:=getProc(hh,'ippsHilbert_32f32fc');
  ippsWTHaarFwd_16s_Sfs:=getProc(hh,'ippsWTHaarFwd_16s_Sfs');
  ippsWTHaarFwd_32f:=getProc(hh,'ippsWTHaarFwd_32f');
  ippsWTHaarFwd_64f:=getProc(hh,'ippsWTHaarFwd_64f');
  ippsWTHaarInv_16s_Sfs:=getProc(hh,'ippsWTHaarInv_16s_Sfs');
  ippsWTHaarInv_32f:=getProc(hh,'ippsWTHaarInv_32f');
  ippsWTHaarInv_64f:=getProc(hh,'ippsWTHaarInv_64f');
  ippsWTFwdGetSize:=getProc(hh,'ippsWTFwdGetSize');
  ippsWTFwdInit_8u32f:=getProc(hh,'ippsWTFwdInit_8u32f');
  ippsWTFwdInit_16s32f:=getProc(hh,'ippsWTFwdInit_16s32f');
  ippsWTFwdInit_16u32f:=getProc(hh,'ippsWTFwdInit_16u32f');
  ippsWTFwdInit_32f:=getProc(hh,'ippsWTFwdInit_32f');
  ippsWTFwdSetDlyLine_8u32f:=getProc(hh,'ippsWTFwdSetDlyLine_8u32f');
  ippsWTFwdSetDlyLine_16s32f:=getProc(hh,'ippsWTFwdSetDlyLine_16s32f');
  ippsWTFwdSetDlyLine_16u32f:=getProc(hh,'ippsWTFwdSetDlyLine_16u32f');
  ippsWTFwdSetDlyLine_32f:=getProc(hh,'ippsWTFwdSetDlyLine_32f');
  ippsWTFwdGetDlyLine_8u32f:=getProc(hh,'ippsWTFwdGetDlyLine_8u32f');
  ippsWTFwdGetDlyLine_16s32f:=getProc(hh,'ippsWTFwdGetDlyLine_16s32f');
  ippsWTFwdGetDlyLine_16u32f:=getProc(hh,'ippsWTFwdGetDlyLine_16u32f');
  ippsWTFwdGetDlyLine_32f:=getProc(hh,'ippsWTFwdGetDlyLine_32f');
  ippsWTFwd_8u32f:=getProc(hh,'ippsWTFwd_8u32f');
  ippsWTFwd_16s32f:=getProc(hh,'ippsWTFwd_16s32f');
  ippsWTFwd_16u32f:=getProc(hh,'ippsWTFwd_16u32f');
  ippsWTFwd_32f:=getProc(hh,'ippsWTFwd_32f');
  ippsWTInvGetSize:=getProc(hh,'ippsWTInvGetSize');
  ippsWTInvInit_32f8u:=getProc(hh,'ippsWTInvInit_32f8u');
  ippsWTInvInit_32f16u:=getProc(hh,'ippsWTInvInit_32f16u');
  ippsWTInvInit_32f16s:=getProc(hh,'ippsWTInvInit_32f16s');
  ippsWTInvInit_32f:=getProc(hh,'ippsWTInvInit_32f');
  ippsWTInvSetDlyLine_32f8u:=getProc(hh,'ippsWTInvSetDlyLine_32f8u');
  ippsWTInvSetDlyLine_32f16s:=getProc(hh,'ippsWTInvSetDlyLine_32f16s');
  ippsWTInvSetDlyLine_32f16u:=getProc(hh,'ippsWTInvSetDlyLine_32f16u');
  ippsWTInvSetDlyLine_32f:=getProc(hh,'ippsWTInvSetDlyLine_32f');
  ippsWTInvGetDlyLine_32f8u:=getProc(hh,'ippsWTInvGetDlyLine_32f8u');
  ippsWTInvGetDlyLine_32f16s:=getProc(hh,'ippsWTInvGetDlyLine_32f16s');
  ippsWTInvGetDlyLine_32f16u:=getProc(hh,'ippsWTInvGetDlyLine_32f16u');
  ippsWTInvGetDlyLine_32f:=getProc(hh,'ippsWTInvGetDlyLine_32f');
  ippsWTInv_32f8u:=getProc(hh,'ippsWTInv_32f8u');
  ippsWTInv_32f16s:=getProc(hh,'ippsWTInv_32f16s');
  ippsWTInv_32f16u:=getProc(hh,'ippsWTInv_32f16u');
  ippsWTInv_32f:=getProc(hh,'ippsWTInv_32f');
  ippsReplaceNAN_32f_I:=getProc(hh,'ippsReplaceNAN_32f_I');
  ippsReplaceNAN_64f_I:=getProc(hh,'ippsReplaceNAN_64f_I');
end;


function InitIPPS:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(AppDir+'IPP\ipps.dll');

  result:=(hh<>0);
  if not result then exit;
  //messageCentral('IPPS17 loaded');
  InitIpps1;
  InitIpps2;
  InitIpps3;

  ippsBufferSize1:=10000000;
  ippsBuffer1:= ippsMalloc(ippsBufferSize1);
end;


procedure freeIPPS;
begin
  if hh<>0 then freeLibrary(hh);
  hh:=0;
end;

//var
//  FPUmask:TFPUexceptionMask;

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
    //sortieErreur('Unable to initialize IPP library');
  end;
end;

procedure IPPSend;
begin
  setPrecisionMode(pmExtended);
  //SetExceptionMask([exInvalidOp, exDenormalized, exUnderflow])
end;

procedure UpdateIppsBuffer1(size:integer);
begin
  if size>ippsBufferSize1 then
  begin
    ippsFree(ippsBuffer1);
    ippsBufferSize1:= size;
    ippsBuffer1:= ippsMalloc(ippsBufferSize1);
  end;
end;

procedure resetIppsBuffer1;
begin
  UpdateIppsBuffer1(10000000);
end;

end.
