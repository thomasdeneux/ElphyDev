Unit ippi17;

INTERFACE

uses windows,math,util1,ippdefs17;

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
//              Image Processing
//
//
*)


(*   #if !defined( __IPPI_H__ ) || defined( _OWN_BLDPCS )
#define __IPPI_H__

(*   #if defined (_WIN32_WCE) && defined (_M_IX86) && defined (__stdcall)
  #define _IPP_STDCALL_CDECL
  #undef __stdcall
#endif  *)

(*   #ifndef __IPPDEFS_H__
  #include "ippdefs.h"
#endif  *)

// #include "ippi_l.h"

(*   #ifdef __cplusplus
extern "C" {
#endif  *)

(*   #if !defined( _IPP_NO_DEFAULT_LIB )
  #if defined( _IPP_SEQUENTIAL_DYNAMIC )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippi" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippcore" )
  #elif defined( _IPP_SEQUENTIAL_STATIC )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippimt" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippsmt" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippvmmt" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "ippcoremt" )
  #elif defined( _IPP_PARALLEL_DYNAMIC )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippi" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippcore" )
  #elif defined( _IPP_PARALLEL_STATIC )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippimt" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippsmt" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippvmmt" )
    #pragma comment( lib, __FILE__ "/../../lib/" _INTEL_PLATFORM "threaded/ippcoremt" )
  #endif
#endif  *)



(* /////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                   Functions declarations
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////// *)

var

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiGetLibVersion
//  Purpose:    gets the version of the library
//  Returns:    structure containing information about the current version of
//  the Intel(R) IPP library for image processing
//  Parameters:
//
//  Notes:      there is no need to release the returned structure
*)
  ippiGetLibVersion: function:PIppLibraryVersion;


(* /////////////////////////////////////////////////////////////////////////////
//                   Memory Allocation Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiMalloc
//  Purpose:    allocates memory with 32-byte aligned pointer for ippIP images,
//              every line of the image is aligned due to the padding characterized
//              by pStepBytes
//  Parameter:
//    widthPixels   width of image in pixels
//    heightPixels  height of image in pixels
//    pStepBytes    pointer to the image step, it is an output parameter
//                  calculated by the function
//
//  Returns:    pointer to the allocated memory or NULL if out of memory or wrong parameters
//  Notes:      free the allocated memory using the function ippiFree only
*)

  ippiMalloc_8u_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;
  ippiMalloc_16u_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;
  ippiMalloc_16s_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;
  ippiMalloc_32s_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;
  ippiMalloc_32f_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;
  ippiMalloc_32sc_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;
  ippiMalloc_32fc_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;

  ippiMalloc_8u_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;
  ippiMalloc_16u_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;
  ippiMalloc_16s_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;
  ippiMalloc_32s_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;
  ippiMalloc_32f_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;
  ippiMalloc_32sc_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;
  ippiMalloc_32fc_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;

  ippiMalloc_8u_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;
  ippiMalloc_16u_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;
  ippiMalloc_16s_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;
  ippiMalloc_32s_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;
  ippiMalloc_32f_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;
  ippiMalloc_32sc_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;
  ippiMalloc_32fc_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;

  ippiMalloc_8u_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;
  ippiMalloc_16u_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;
  ippiMalloc_16s_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;
  ippiMalloc_32s_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;
  ippiMalloc_32f_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;
  ippiMalloc_32sc_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;
  ippiMalloc_32fc_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;

  ippiMalloc_8u_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;
  ippiMalloc_16u_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;
  ippiMalloc_16s_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;
  ippiMalloc_32s_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;
  ippiMalloc_32f_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;
  ippiMalloc_32sc_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;
  ippiMalloc_32fc_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFree
//  Purpose:    frees memory allocated by the ippiMalloc functions
//  Parameter:
//    ptr       pointer to the memory allocated by the ippiMalloc functions
//
//  Notes:      use this function to free memory allocated by ippiMalloc
*)
  ippiFree: procedure(ptr:pointer);


(* ///////////////////////////////////////////////////////////////////////////////////////
//                  Arithmetic Functions
///////////////////////////////////////////////////////////////////////////// *)
(* ///////////////////////////////////////////////////////////////////////////////////////
//  Name:  ippiAdd_8u_C1RSfs,  ippiAdd_8u_C3RSfs,  ippiAdd_8u_C4RSfs,  ippiAdd_8u_AC4RSfs,
//         ippiAdd_16s_C1RSfs, ippiAdd_16s_C3RSfs, ippiAdd_16s_C4RSfs, ippiAdd_16s_AC4RSfs,
//         ippiAdd_16u_C1RSfs, ippiAdd_16u_C3RSfs, ippiAdd_16u_C4RSfs, ippiAdd_16u_AC4RSfs,
//         ippiSub_8u_C1RSfs,  ippiSub_8u_C3RSfs,  ippiSub_8u_C4RSfs,  ippiSub_8u_AC4RSfs,
//         ippiSub_16s_C1RSfs, ippiSub_16s_C3RSfs, ippiSub_16s_C4RSfs, ippiSub_16s_AC4RSfs,
//         ippiSub_16u_C1RSfs, ippiSub_16u_C3RSfs, ippiSub_16u_C4RSfs, ippiSub_16u_AC4RSfs,
//         ippiMul_8u_C1RSfs,  ippiMul_8u_C3RSfs,  ippiMul_8u_C4RSfs,  ippiMul_8u_AC4RSfs,
//         ippiMul_16s_C1RSfs, ippiMul_16s_C3RSfs, ippiMul_16s_C4RSfs, ippiMul_16s_AC4RSfs
//         ippiMul_16u_C1RSfs, ippiMul_16u_C3RSfs, ippiMul_16u_C4RSfs, ippiMul_16u_AC4RSfs
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of two
//              source images and places the scaled result in the destination image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            Width or height of images is less than or equal to zero
//
//  Parameters:
//    pSrc1, pSrc2             Pointers to the source images
//    src1Step, src2Step       Steps through the source images
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_C1RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_C3RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_C4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_AC4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_C1RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_C3RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_C4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_AC4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_C1RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_C3RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_C4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_AC4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

(* //////////////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_8u_C1IRSfs,  ippiAddC_8u_C3IRSfs,  ippiAddC_8u_C4IRSfs,   ippiAddC_8u_AC4IRSfs,
//        ippiAddC_16s_C1IRSfs, ippiAddC_16s_C3IRSfs, ippiAddC_16s_C4IRSfs,  ippiAddC_16s_AC4IRSfs,
//        ippiAddC_16u_C1IRSfs, ippiAddC_16u_C3IRSfs, ippiAddC_16u_C4IRSfs,  ippiAddC_16u_AC4IRSfs,
//        ippiSubC_8u_C1IRSfs,  ippiSubC_8u_C3IRSfs,  ippiSubC_8u_C4IRSfs,   ippiSubC_8u_AC4IRSfs,
//        ippiSubC_16s_C1IRSfs, ippiSubC_16s_C3IRSfs, ippiSubC_16s_C4IRSfs,  ippiSubC_16s_AC4IRSfs,
//        ippiSubC_16u_C1IRSfs, ippiSubC_16u_C3IRSfs, ippiSubC_16u_C4IRSfs,  ippiSubC_16u_AC4IRSfs,
//        ippiMulC_8u_C1IRSfs,  ippiMulC_8u_C3IRSfs,  ippiMulC_8u_C4IRSfs,   ippiMulC_8u_AC4IRSfs,
//        ippiMulC_16s_C1IRSfs, ippiMulC_16s_C3IRSfs, ippiMulC_16s_C4IRSfs,  ippiMulC_16s_AC4IRSfs
//        ippiMulC_16u_C1IRSfs, ippiMulC_16u_C3IRSfs, ippiMulC_16u_C4IRSfs,  ippiMulC_16u_AC4IRSfs
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of an image and a constant
//              and places the scaled results in the same image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         Pointer is NULL
//    ippStsSizeErr            Width or height of an image is less than or equal to zero
//
//  Parameters:
//    value                    Constant value (constant vector for multi-channel images)
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAddC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_8u_C4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_8u_AC4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_C4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_AC4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_C1IRSfs: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_C3IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_C4IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_AC4IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_C4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_AC4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_C4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_AC4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_C1IRSfs: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_C3IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_C4IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_AC4IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_C4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_AC4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_C4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_AC4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_C1IRSfs: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_C3IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_C4IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_AC4IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_8u_C1RSfs,  ippiAddC_8u_C3RSfs,  ippiAddC_8u_C4RSfs   ippiAddC_8u_AC4RSfs,
//        ippiAddC_16s_C1RSfs, ippiAddC_16s_C3RSfs, ippiAddC_16s_C4RSfs, ippiAddC_16s_AC4RSfs,
//        ippiAddC_16u_C1RSfs, ippiAddC_16u_C3RSfs, ippiAddC_16u_C4RSfs, ippiAddC_16u_AC4RSfs,
//        ippiSubC_8u_C1RSfs,  ippiSubC_8u_C3RSfs,  ippiSubC_8u_C4RSfs,  ippiSubC_8u_AC4RSfs,
//        ippiSubC_16s_C1RSfs, ippiSubC_16s_C3RSfs, ippiSubC_16s_C4RSfs, ippiSubC_16s_AC4RSfs,
//        ippiSubC_16u_C1RSfs, ippiSubC_16u_C3RSfs, ippiSubC_16u_C4RSfs, ippiSubC_16u_AC4RSfs,
//        ippiMulC_8u_C1RSfs,  ippiMulC_8u_C3RSfs,  ippiMulC_8u_C4RSfs,  ippiMulC_8u_AC4RSfs,
//        ippiMulC_16s_C1RSfs, ippiMulC_16s_C3RSfs, ippiMulC_16s_C4RSfs, ippiMulC_16s_AC4RSfs
//        ippiMulC_16u_C1RSfs, ippiMulC_16u_C3RSfs, ippiMulC_16u_C4RSfs, ippiMulC_16u_AC4RSfs
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of a source image
//              and a constant, and places the scaled results in the destination image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            Width or height of images is less than or equal to zero
//
//  Parameters:
//    value                    Constant value (constant vector for multi-channel images)
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAddC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_C4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAddC_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_C4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSubC_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_C4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMulC_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAdd_8u_C1IRSfs,  ippiAdd_8u_C3IRSfs,  ippiAdd_8u_C4IRSfs,  ippiAdd_8u_AC4IRSfs,
//        ippiAdd_16s_C1IRSfs, ippiAdd_16s_C3IRSfs, ippiAdd_16s_C4IRSfs, ippiAdd_16s_AC4IRSfs,
//        ippiAdd_16u_C1IRSfs, ippiAdd_16u_C3IRSfs, ippiAdd_16u_C4IRSfs, ippiAdd_16u_AC4IRSfs,
//        ippiSub_8u_C1IRSfs,  ippiSub_8u_C3IRSfs,  ippiSub_8u_C4IRSfs,  ippiSub_8u_AC4IRSfs,
//        ippiSub_16s_C1IRSfs, ippiSub_16s_C3IRSfs, ippiSub_16s_C4IRSfs  ippiSub_16s_AC4IRSfs,
//        ippiSub_16u_C1IRSfs, ippiSub_16u_C3IRSfs, ippiSub_16u_C4IRSfs  ippiSub_16u_AC4IRSfs,
//        ippiMul_8u_C1IRSfs,  ippiMul_8u_C3IRSfs,  ippiMul_8u_C4IRSfs,  ippiMul_8u_AC4IRSfs,
//        ippiMul_16s_C1IRSfs, ippiMul_16s_C3IRSfs, ippiMul_16s_C4IRSfs, ippiMul_16s_AC4IRSfs
//        ippiMul_16u_C1IRSfs, ippiMul_16u_C3IRSfs, ippiMul_16u_C4IRSfs, ippiMul_16u_AC4IRSfs
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of two source images
//              and places the scaled results in the first source image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            Width or height of images is less than or equal to zero
//
//  Parameters:
//    pSrc                     Pointer to the second source image
//    srcStep                  Step through the second source image
//    pSrcDst                  Pointer to the first source/destination image
//    srcDstStep               Step through the first source/destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

  ippiAdd_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_C1IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_C3IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_C4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiAdd_16u_AC4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_C1IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_C3IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_C4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSub_16u_AC4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_C1IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_C3IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_C4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiMul_16u_AC4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_32f_C1R, ippiAddC_32f_C3R, ippiAddC_32f_C4R,  ippiAddC_32f_AC4R,
//        ippiSubC_32f_C1R, ippiSubC_32f_C3R, ippiSubC_32f_C4R,  ippiSubC_32f_AC4R,
//        ippiMulC_32f_C1R, ippiMulC_32f_C3R, ippiMulC_32f_C4R,  ippiMulC_32f_AC4R
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of a source image
//              and a constant, and places the results in a destination image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            Width or height of images is less than or equal to zero
//
//  Parameters:
//    value                    The constant value for the specified operation
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
*)

  ippiAddC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAddC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAddC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAddC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

(* ///////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_32f_C1IR, ippiAddC_32f_C3IR, ippiAddC_32f_C4IR, ippiAddC_32f_AC4IR,
//        ippiSubC_32f_C1IR, ippiSubC_32f_C3IR, ippiSubC_32f_C4IR, ippiSubC_32f_AC4IR,
//        ippiMulC_32f_C1IR, ippiMulC_32f_C3IR, ippiMulC_32f_C4IR, ippiMulC_32f_AC4IR
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of an image
//              and a constant, and places the results in the same image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         Pointer is NULL
//    ippStsSizeErr            Width or height of an image is less than or equal to zero
//
//  Parameters:
//    value                    The constant value for the specified operation
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
*)

  ippiAddC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAddC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAddC_32f_C4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAddC_32f_AC4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_C4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSubC_32f_AC4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_C4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulC_32f_AC4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAdd_32f_C1IR, ippiAdd_32f_C3IR, ippiAdd_32f_C4IR, ippiAdd_32f_AC4IR,
//        ippiSub_32f_C1IR, ippiSub_32f_C3IR, ippiSub_32f_C4IR, ippiSub_32f_AC4IR,
//        ippiMul_32f_C1IR, ippiMul_32f_C3IR, ippiMul_32f_C4IR, ippiMul_32f_AC4IR
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of two source images
//              and places the results in the first image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            Width or height of images is less than or equal to zero
//
//  Parameters:
//    pSrc                     Pointer to the second source image
//    srcStep                  Step through the second source image
//    pSrcDst                  Pointer to the  first source/destination image
//    srcDstStep               Step through the first source/destination image
//    roiSize                  Size of the ROI
*)

  ippiAdd_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAdd_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAdd_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAdd_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name: ippiAdd_32f_C1R, ippiAdd_32f_C3R, ippiAdd_32f_C4R, ippiAdd_32f_AC4R,
//        ippiSub_32f_C1R, ippiSub_32f_C3R, ippiSub_32f_C4R, ippiSub_32f_AC4R,
//        ippiMul_32f_C1R, ippiMul_32f_C3R, ippiMul_32f_C4R, ippiMul_32f_AC4R
//
//  Purpose:    Adds, subtracts, or multiplies pixel values of two
//              source images and places the results in a destination image.
//
//  Returns:
//    ippStsNoErr            OK
//    ippStsNullPtrErr       One of the pointers is NULL
//    ippStsSizeErr          Width or height of images is less than or equal to zero
//
//  Parameters:
//    pSrc1, pSrc2           Pointers to the source images
//    src1Step, src2Step     Steps through the source images
//    pDst                   Pointer to the destination image
//    dstStep                Step through the destination image

//    roiSize                Size of the ROI
*)

  ippiAdd_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAdd_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAdd_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAdd_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSub_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMul_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

(* //////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_32f_C1R, ippiDiv_32f_C3R ippiDiv_32f_C4R ippiDiv_32f_AC4R
//
//  Purpose:    Divides pixel values of an image by pixel values of another image
//              and places the results in a destination image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            At least one step value is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the function
//                             execution is continued.
//                             If a dividend is equal to zero, then the result is NAN_32F;
//                             if it is greater than zero, then the result is INF_32F,
//                             if it is less than zero, then the result is INF_NEG_32F
//
//  Parameters:
//    pSrc1                    Pointer to the divisor source image
//    src1Step                 Step through the divisor source image
//    pSrc2                    Pointer to the dividend source image
//    src2Step                 Step through the dividend source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
*)

  ippiDiv_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDiv_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDiv_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDiv_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_16s_C1RSfs, ippiDiv_8u_C1RSfs, ippiDiv_16u_C1RSfs,
//              ippiDiv_16s_C3RSfs, ippiDiv_8u_C3RSfs, ippiDiv_16u_C3RSfs,
//              ippiDiv_16s_C4RSfs, ippiDiv_8u_C4RSfs, ippiDiv_16u_C4RSfs,
//              ippiDiv_16s_AC4RSfs,ippiDiv_8u_AC4RSfs,ippiDiv_16u_AC4RSfs
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the scaled results in a destination
//              image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            At least one step value is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the function
//                             execution is continued.
//                    If a dividend is equal to zero, then the result is zero;
//                    if it is greater than zero, then the result is IPP_MAX_16S, or IPP_MAX_8U, or IPP_MAX_16U
//                    if it is less than zero (for 16s), then the result is IPP_MIN_16S
//
//  Parameters:
//    pSrc1                    Pointer to the divisor source image
//    src1Step                 Step through the divisor source image
//    pSrc2                    Pointer to the dividend source image
//    src2Step                 Step through the dividend source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDiv_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_16u_C1RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16u_C3RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16u_C4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_16u_AC4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDivC_32f_C1R, ippiDivC_32f_C3R
//              ippiDivC_32f_C4R, ippiDivC_32f_AC4R
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the results in a destination image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal to zero
//
//  Parameters:
//    value                    The constant divisor
//    pSrc                     Pointer to the source image
//    pDst                     Pointer to the destination image
//    roiSize                  Size of the ROI
*)

  ippiDivC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDivC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDivC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var val:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDivC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var val:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDivC_16s_C1RSfs, ippiDivC_8u_C1RSfs, ippiDivC_16u_C1RSfs,
//              ippiDivC_16s_C3RSfs, ippiDivC_8u_C3RSfs, ippiDivC_16u_C3RSfs,
//              ippiDivC_16s_C4RSfs, ippiDivC_8u_C4RSfs, ippiDivC_16u_C4RSfs,
//              ippiDivC_16s_AC4RSfs,ippiDivC_8u_AC4RSfs,ippiDivC_16u_AC4RSfs
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the scaled results in a destination image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            Step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal to zero
//
//  Parameters:
//    value                    Constant divisor
//    pSrc                     Pointer to the source image
//    pDst                     Pointer to the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDivC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16u_C4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_32f_C1IR, ippiDiv_32f_C3IR ippiDiv_32f_C4IR ippiDiv_32f_AC4IR
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the results in the dividend source
//              image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            At least one step value is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the function
//                             execution is continued.
//                             If a dividend is equal to zero, then the result is NAN_32F;
//                             if it is greater than zero, then the result is INF_32F,
//                             if it is less than zero, then the result is INF_NEG_32F
//
//  Parameters:
//    pSrc                     Pointer to the divisor source image
//    srcStep                  Step through the divisor source image
//    pSrcDst                  Pointer to the dividend source/destination image
//    srcDstStep               Step through the dividend source/destination image
//    roiSize                  Size of the ROI
*)

  ippiDiv_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDiv_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDiv_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDiv_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_16s_C1IRSfs, ippiDiv_8u_C1IRSfs, ippiDiv_16u_C1IRSfs,
//              ippiDiv_16s_C3IRSfs, ippiDiv_8u_C3IRSfs, ippiDiv_16u_C3IRSfs,
//              ippiDiv_16s_C4IRSfs, ippiDiv_8u_C4IRSfs, ippiDiv_16u_C4IRSfs,
//              ippiDiv_16s_AC4IRSfs,ippiDiv_8u_AC4IRSfs,ippiDiv_16u_AC4IRSfs
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the scaled results in the dividend
//              source image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            At least one step value is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the function
//                             execution is continued.
//                    If a dividend is equal to zero, then the result is zero;
//                    if it is greater than zero, then the result is IPP_MAX_16S, or IPP_MAX_8U, or IPP_MAX_16U
//                    if it is less than zero (for 16s), then the result is IPP_MIN_16S
//
//  Parameters:
//    pSrc                     Pointer to the divisor source image
//    srcStep                  Step through the divisor source image
//    pSrcDst                  Pointer to the dividend source/destination image
//    srcDstStep               Step through the dividend source/destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDiv_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_16u_C1IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16u_C3IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDiv_16u_C4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDiv_16u_AC4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDivC_32f_C1IR, ippiDivC_32f_C3IR,
//              ippiDivC_32f_C4IR, ippiDivC_32f_AC4IR
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the results in the same image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            The step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal to zero
//
//  Parameters:
//    value                    The constant divisor
//    pSrcDst                  Pointer to the source/destination image
//    srcDstStep               Step through the source/destination image
//    roiSize                  Size of the ROI
*)

  ippiDivC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDivC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDivC_32f_C4IR: function(var val:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDivC_32f_AC4IR: function(var val:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDivC_16s_C1IRSfs, ippiDivC_8u_C1IRSfs, ippiDivC_16u_C1IRSfs,
//              ippiDivC_16s_C3IRSfs, ippiDivC_8u_C3IRSfs, ippiDivC_16u_C3IRSfs,
//              ippiDivC_16s_C4IRSfs, ippiDivC_8u_C4IRSfs, ippiDivC_16u_C4IRSfs,
//              ippiDivC_16s_AC4IRSfs,ippiDivC_8u_AC4IRSfs,ippiDivC_16u_AC4IRSfs
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the scaled results in the same image.
//
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            The step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal to zero
//
//  Parameters:
//    value                    The constant divisor
//    pSrcDst                  Pointer to the source/destination image
//    srcDstStep               Step through the source/destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDivC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16s_C4IRSfs: function(var val:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDivC_16s_AC4IRSfs: function(var val:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDivC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_8u_C4IRSfs: function(var val:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDivC_8u_AC4IRSfs: function(var val:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDivC_16u_C1IRSfs: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16u_C3IRSfs: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiDivC_16u_C4IRSfs: function(var val:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;
  ippiDivC_16u_AC4IRSfs: function(var val:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;ScaleFactor:longint):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiAbs_16s_C1R
//              ippiAbs_16s_C3R
//              ippiAbs_16s_C4R
//              ippiAbs_16s_AC4R
//              ippiAbs_32f_C1R
//              ippiAbs_32f_C3R
//              ippiAbs_32f_C4R
//              ippiAbs_32f_AC4R
//
//              ippiAbs_16s_C1IR
//              ippiAbs_16s_C3IR
//              ippiAbs_16s_C4IR
//              ippiAbs_16s_AC4IR
//              ippiAbs_32f_C1IR
//              ippiAbs_32f_C3IR
//              ippiAbs_32f_C4IR
//              ippiAbs_32f_AC4IR
//
//  Purpose:    computes absolute value of each pixel of a source image and
//              places results in the destination image;
//              for in-place flavors - in the same source image
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     The roiSize has a field with negative or zero value
//
//  Parameters:
//   pSrc       pointer to the source image
//   srcStep    step through the source image
//   pDst       pointer to the destination image
//   dstStep    step through the destination image
//   pSrcDst    pointer to the source/destination image (for in-place function)
//   srcDstStep step through the source/destination image (for in-place function)
//   roiSize    size of the ROI
*)
  ippiAbs_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAbs_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiSqr_8u_C1RSfs
//              ippiSqr_8u_C3RSfs
//              ippiSqr_8u_AC4RSfs
//              ippiSqr_8u_C4RSfs
//              ippiSqr_16u_C1RSfs
//              ippiSqr_16u_C3RSfs
//              ippiSqr_16u_AC4RSfs
//              ippiSqr_16u_C4RSfs
//              ippiSqr_16s_C1RSfs
//              ippiSqr_16s_C3RSfs
//              ippiSqr_16s_AC4RSfs
//              ippiSqr_16s_C4RSfs
//              ippiSqr_32f_C1R
//              ippiSqr_32f_C3R
//              ippiSqr_32f_AC4R
//              ippiSqr_32f_C4R
//
//              ippiSqr_8u_C1IRSfs
//              ippiSqr_8u_C3IRSfs
//              ippiSqr_8u_AC4IRSfs
//              ippiSqr_8u_C4IRSfs
//              ippiSqr_16u_C1IRSfs
//              ippiSqr_16u_C3IRSfs
//              ippiSqr_16u_AC4IRSfs
//              ippiSqr_16u_C4IRSfs
//              ippiSqr_16s_C1IRSfs
//              ippiSqr_16s_C3IRSfs
//              ippiSqr_16s_AC4IRSfs
//              ippiSqr_16s_C4IRSfs
//              ippiSqr_32f_C1IR
//              ippiSqr_32f_C3IR
//              ippiSqr_32f_AC4IR
//              ippiSqr_32f_C4IR
//
//  Purpose:    squares pixel values of an image and
//              places results in the destination image;
//              for in-place flavors - in  the same image
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     The roiSize has a field with negative or zero value
//
//  Parameters:
//   pSrc       pointer to the source image
//   srcStep    step through the source image
//   pDst       pointer to the destination image
//   dstStep    step through the destination image
//   pSrcDst    pointer to the source/destination image (for in-place function)
//   srcDstStep step through the source/destination image (for in-place function)
//   roiSize    size of the ROI
//   scaleFactor scale factor
*)

  ippiSqr_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_C4RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_8u_AC4IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_8u_C4IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_C1IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_C3IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_AC4IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16u_C4IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_AC4IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_16s_C4IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqr_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqr_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiSqrt_8u_C1RSfs
//              ippiSqrt_8u_C3RSfs
//              ippiSqrt_8u_AC4RSfs
//              ippiSqrt_16u_C1RSfs
//              ippiSqrt_16u_C3RSfs
//              ippiSqrt_16u_AC4RSfs
//              ippiSqrt_16s_C1RSfs
//              ippiSqrt_16s_C3RSfs
//              ippiSqrt_16s_AC4RSfs
//              ippiSqrt_32f_C1R
//              ippiSqrt_32f_C3R
//              ippiSqrt_32f_AC4R
//
//              ippiSqrt_8u_C1IRSfs
//              ippiSqrt_8u_C3IRSfs
//              ippiSqrt_8u_AC4IRSfs
//              ippiSqrt_16u_C1IRSfs
//              ippiSqrt_16u_C3IRSfs
//              ippiSqrt_16u_AC4IRSfs
//              ippiSqrt_16s_C1IRSfs
//              ippiSqrt_16s_C3IRSfs
//              ippiSqrt_16s_AC4IRSfs
//              ippiSqrt_32f_C1IR
//              ippiSqrt_32f_C3IR
//              ippiSqrt_32f_AC4IR
//              ippiSqrt_32f_C4IR
//  Purpose:    computes square roots of pixel values of a source image and
//              places results in the destination image;
//              for in-place flavors - in the same image
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of pointers is NULL
//   ippStsSizeErr     The roiSize has a field with negative or zero value
//   ippStsSqrtNegArg  Source image pixel has a negative value
//
//  Parameters:
//   pSrc       pointer to the source image
//   srcStep    step through the source image
//   pDst       pointer to the destination image
//   dstStep    step through the destination image
//   pSrcDst    pointer to the source/destination image (for in-place function)
//   srcDstStep step through the source/destination image (for in-place function)
//   roiSize    size of the ROI
//   scaleFactor scale factor
*)
  ippiSqrt_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqrt_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqrt_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqrt_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_8u_AC4IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16u_C1IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16u_C3IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16u_AC4IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_16s_AC4IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiSqrt_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqrt_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSqrt_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiSqrt_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//  ippiLn_32f_C1IR   ippiLn_16s_C1IRSfs  ippiLn_8u_C1IRSfs ippiLn_16u_C1IRSfs
//  ippiLn_32f_C3IR   ippiLn_16s_C3IRSfs  ippiLn_8u_C3IRSfs ippiLn_16u_C3IRSfs
//  ippiLn_32f_C1R    ippiLn_16s_C1RSfs   ippiLn_8u_C1RSfs  ippiLn_16u_C1RSfs
//  ippiLn_32f_C3R    ippiLn_16s_C3RSfs   ippiLn_8u_C3RSfs  ippiLn_16u_C3RSfs
//  Purpose:
//     computes the natural logarithm of each pixel values of a source image
//     and places the results in the destination image;
//     for in-place flavors - in the same image
//  Parameters:
//    pSrc         Pointer to the source image.
//    pDst         Pointer to the destination image.
//    pSrcDst      Pointer to the source/destination image for in-place functions.
//    srcStep      Step through the source image.
//    dstStep      Step through the destination image.
//    srcDstStep   Step through the source/destination image for in-place functions.
//    roiSize      Size of the ROI.
//    scaleFactor  Scale factor for integer data.
//  Returns:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       The roiSize has a field with negative or zero value
//    ippStsStepErr       One of the step values is less than or equal to zero
//    ippStsLnZeroArg     The source pixel has a zero value
//    ippStsLnNegArg      The source pixel has a negative value
//    ippStsNoErr         otherwise
*)

  ippiLn_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLn_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLn_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLn_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiLn_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiLn_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiLn_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiLn_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

  ippiLn_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;
  ippiLn_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;


  ippiLn_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiLn_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiLn_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiLn_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

  ippiLn_16u_C1IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;
  ippiLn_16u_C3IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//  ippiExp_32f_C1IR   ippiExp_16s_C1IRSfs  ippiExp_8u_C1IRSfs ippiExp_16u_C1IRSfs
//  ippiExp_32f_C3IR   ippiExp_16s_C3IRSfs  ippiExp_8u_C3IRSfs ippiExp_16u_C3IRSfs
//  ippiExp_32f_C1R    ippiExp_16s_C1RSfs   ippiExp_8u_C1RSfs  ippiExp_16u_C1RSfs
//  ippiExp_32f_C3R    ippiExp_16s_C3RSfs   ippiExp_8u_C3RSfs  ippiExp_16u_C3RSfs
//  Purpose:
//     computes the exponential of pixel values in a source image
//  Parameters:
//    pSrc         Pointer to the source image.
//    pDst         Pointer to the destination image.
//    pSrcDst      Pointer to the source/destination image for in-place functions.
//    srcStep      Step through the source image.
//    dstStep      Step through the in destination image.
//    srcDstStep   Step through the source/destination image for in-place functions.
//    roiSize      Size of the ROI.
//    scaleFactor  Scale factor for integer data.

//  Returns:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       The roiSize has a field with negative or zero value
//    ippStsStepErr       One of the step values is less than or equal to zero
//    ippStsNoErr         otherwise
*)


  ippiExp_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiExp_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiExp_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiExp_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiExp_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiExp_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiExp_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiExp_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

  ippiExp_16u_C1IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;sFact:longint):IppStatus;
  ippiExp_16u_C3IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;sFact:longint):IppStatus;


  ippiExp_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiExp_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiExp_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;
  ippiExp_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;

  ippiExp_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;sFact:longint):IppStatus;
  ippiExp_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;sFact:longint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                      Multiplication with Scaling
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(*
//  Names:              ippiMulScale, ippiMulCScale
//
//  Purpose:            Multiplies pixel values of two images (MulScale),
//                      or pixel values of an image by a constant (MulScaleC) and scales the products
//
//  Parameters:
//   value              The constant value (constant vector for multi-channel images)
//   pSrc               Pointer to the source image
//   srcStep            Step through the source image
//   pSrcDst            Pointer to the source/destination image (in-place operations)
//   srcDstStep         Step through the source/destination image (in-place operations)
//   pSrc1              Pointer to the first source image
//   src1Step           Step through the first source image
//   pSrc2              Pointer to the second source image
//   src2Step           Step through the second source image
//   pDst               Pointer to the destination image
//   dstStep            Step through the destination image
//   roiSize            Size of the image ROI
//
//  Returns:
//   ippStsNullPtrErr   One of the pointers is NULL
//   ippStsStepErr      One of the step values is less than or equal to zero
//   ippStsSizeErr      The roiSize has a field with negative or zero value
//   ippStsNoErr        otherwise
*)

  ippiMulScale_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMulScale_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulScale_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulCScale_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//              Dot product of two images
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiDotProd
//  Purpose:        Computes the dot product of two images
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsStepErr      One of the step values is equal to zero
//  Parameters:
//    pSrc1       Pointer to the first source image.
//    src1Step    Step in bytes through the first source image
//    pSrc2       Pointer to the second source image.
//    src2Step    Step in bytes through the  source image
//    roiSize     Size of the source image ROI.
//    pDp         Pointer to the result (one-channel data) or array (multi-channel data) containing computed dot products of channel values of pixels in the source images.
//    hint        Option to select the algorithmic implementation of the function
//  Notes:
*)
  ippiDotProd_8u64f_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pDp:PIpp64f):IppStatus;
  ippiDotProd_16u64f_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pDp:PIpp64f):IppStatus;
  ippiDotProd_16s64f_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pDp:PIpp64f):IppStatus;
  ippiDotProd_32u64f_C1R: function(pSrc1:PIpp32u;src1Step:longint;pSrc2:PIpp32u;src2Step:longint;roiSize:IppiSize;pDp:PIpp64f):IppStatus;
  ippiDotProd_32s64f_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;roiSize:IppiSize;pDp:PIpp64f):IppStatus;
  ippiDotProd_32f64f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pDp:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiDotProd_8u64f_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_16u64f_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_16s64f_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32u64f_C3R: function(pSrc1:PIpp32u;src1Step:longint;pSrc2:PIpp32u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32s64f_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32f64f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiDotProd_8u64f_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_16u64f_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_16s64f_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32u64f_C4R: function(pSrc1:PIpp32u;src1Step:longint;pSrc2:PIpp32u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32s64f_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32f64f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiDotProd_8u64f_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_16u64f_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_16s64f_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32u64f_AC4R: function(pSrc1:PIpp32u;src1Step:longint;pSrc2:PIpp32u;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32s64f_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f):IppStatus;
  ippiDotProd_32f64f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pDp:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//              Dot product of taps vector and columns,
//                  which are placed in stripe of rows
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDotProdCol_32f_L2
//              ippiDotProdCol_64f_L2
//
//  Purpose:    Calculates the dot product of taps vector and columns,
//      which are placed in stripe of rows; useful for external vertical
//      filtering pipeline implementation.
//
//  Parameters:
//    ppSrcRow              pointer to set of rows
//    pTaps                 pointer to taps vector
//    tapsLen               taps length and (equal to number of rows)
//    pDst                  pointer where to store the result row
//    width                 width of source and destination rows
//
//  Returns:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      one of the pointers is NULL
//    ippStsSizeErr         width is less than or equal to zero
*)
  ippiDotProdCol_32f_L2: function(var ppSrcRow:PIpp32f;pTaps:PIpp32f;tapsLen:longint;pDst:PIpp32f;width:longint):IppStatus;
  ippiDotProdCol_64f_L2: function(var ppSrcRow:PIpp64f;pTaps:PIpp64f;tapsLen:longint;pDst:PIpp64f;width:longint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//              Vector Multiplication of Images in RCPack2D Format
///////////////////////////////////////////////////////////////////////////// *)
(*  Name:               ippiMulPack, ippiMulPackConj
//
//  Purpose:            Multiplies pixel values of two images in RCPack2D format
//                      and store the result also in PCPack2D format
//
//  Returns:
//      ippStsNoErr       No errors
//      ippStsNullPtrErr  One of the pointers is NULL
//      ippStsStepErr     One of the step values is zero or negative
//      ippStsSizeErr     The roiSize has a field with negative or zero value
//
//  Parameters:
//      pSrc            Pointer to the source image for in-place operation
//      pSrcDst         Pointer to the source/destination image for in-place operation
//      srcStep         Step through the source image for in-place operation
//      srcDstStep      Step through the source/destination image for in-place operation
//      pSrc1           Pointer to the first source image
//      src1Step        Step through the first source image
//      pSrc2           Pointer to the second source image
//      src1Step        Step through the second source image
//      pDst            Pointer to the destination image
//      dstStep         Step through the destination image
//      roiSize         Size of the source and destination ROI
//      scaleFactor     Scale factor
//
//  Notes:              Both in-place and not-in-place operations are supported
//                      ippiMulPackConj functions are only for float data
*)
  ippiMulPack_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPack_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPack_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPack_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMulPack_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPack_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPack_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPack_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMulPackConj_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPackConj_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPackConj_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPackConj_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMulPackConj_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPackConj_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPackConj_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMulPackConj_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiPackToCplxExtend
//
//  Purpose:        Converts an image in RCPack2D format to a complex data image.
//
//  Returns:
//      ippStsNoErr            No errors
//      ippStsNullPtrErr       pSrc == NULL, or pDst == NULL
//      ippStsStepErr          One of the step values is less zero or negative
//      ippStsSizeErr          The srcSize has a field with zero or negative value
//
//  Parameters:
//    pSrc        Pointer to the source image data (point to pixel (0,0))
//    srcSize     Size of the source image
//    srcStep     Step through  the source image
//    pDst        Pointer to the destination image
//    dstStep     Step through the destination image
//  Notes:
*)
  ippiPackToCplxExtend_32f32fc_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;pDst:PIpp32fc;dstStep:longint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiCplxExtendToPack
//
//  Purpose:        Converts an image in complex data format to RCPack2D image.
//
//  Returns:
//      ippStsNoErr            No errors
//      ippStsNullPtrErr       pSrc == NULL, or pDst == NULL
//      ippStsStepErr          One of the step values is less zero or negative
//      ippStsSizeErr          The srcSize has a field with zero or negative value
//
//  Parameters:
//    pSrc        Pointer to the source image data (point to pixel (0,0))
//    srcSize     Size of the source image
//    srcStep     Step through  the source image
//    pDst        Pointer to the destination image
//    dstStep     Step through the destination image
//  Notes:
*)
  ippiCplxExtendToPack_32fc32f_C1R: function(pSrc:PIpp32fc;srcStep:longint;srcSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;
  ippiCplxExtendToPack_32fc32f_C3R: function(pSrc:PIpp32fc;srcStep:longint;srcSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
// Names:         ippiPhasePack
// Purpose:       Computes the phase (in radians) of elements of an image in RCPack2D packed format.
// Parameters:
//    pSrc        - Pointer to the source image.
//    srcStep     - Distances, in bytes, between the starting points of consecutive lines in the source images.
//    pDst        - Pointer to the destination image.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    dstRoiSize  - Size, in pixels, of the destination ROI.
//    pBuffer     - Pointer to the buffer for internal calculations. Size of the buffer is calculated by ippiPhasePackGetBufferSize_32f.
//    scaleFactor - Scale factor (only for integer data).
// Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when dstRoiSize has a field with value less than 1.
//    ippStsStepErr    - Error when srcStep or dstStep has a zero or negative value.
*)
  ippiPhasePack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiPhasePack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Names:         ippiPhasePackGetBufferSize_32f
// Purpose:       Gets the size (in bytes) of the buffer for ippiPhasePack internal calculations.
// Parameters:
//    numChannels - Number of image channels. Possible values are 1 and 3.
//    dstRoiSize  - Size, in pixels, of the destination ROI.
//    pSize       - Pointer to the calculated buffer size (in bytes).
// Return:
//    ippStsNoErr          - OK.
//    ippStsNullPtrErr     - Error when pSize pointer is NULL.
//    ippStsSizeErr        - Error when dstRoiSize has a field with value less than 1.
//    ippStsNumChannelsErr - Error when the numChannels value differs from 1 or 3.
*)
  ippiPhasePackGetBufferSize_32f: function(numChannels:longint;dstRoiSize:IppiSize;pSize:Plongint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
// Names:         ippiMagnitudePack
// Purpose:       Computes magnitude of elements of an image in RCPack2D packed format.
// Parameters:
//    pSrc        - Pointer to the source image.
//    srcStep     - Distances, in bytes, between the starting points of consecutive lines in the source images.
//    pDst        - Pointer to the destination image.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    dstRoiSize  - Size, in pixels, of the destination ROI.
//    pBuffer     - Pointer to the buffer for internal calculations. Size of the buffer is calculated by ippiMagnitudePackGetBufferSize_32f.
//    scaleFactor - Scale factor (only for integer data).
// Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when dstRoiSize has a field with value less than 1.
//    ippStsStepErr    - Error when srcStep or dstStep has a zero or negative value.
*)
  ippiMagnitudePack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiMagnitudePack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Names:         ippiMagnitudePackGetBufferSize_32f
// Purpose:       Gets the size (in bytes) of the buffer for ippiMagnitudePack internal calculations.
// Parameters:
//    numChannels - Number of image channels. Possible values are 1 and 3.
//    dstRoiSize  - Size, in pixels, of the destination ROI.
//    pSize       - Pointer to the calculated buffer size (in bytes).
// Return:
//    ippStsNoErr          - OK.
//    ippStsNullPtrErr     - Error when pSize pointer is NULL.
//    ippStsSizeErr        - Error when dstRoiSize has a field with value less than 1.
//    ippStsNumChannelsErr - Error when the numChannels value differs from 1 or 3.
*)
  ippiMagnitudePackGetBufferSize_32f: function(numChannels:longint;dstRoiSize:IppiSize;pSize:Plongint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippiMagnitude_32fc32f_C1R
//          ippiMagnitude_32fc32f_C3R
//          ippiMagnitude_32sc32s_C1RSfs
//          ippiMagnitude_32sc32s_C3RSfs
//          ippiMagnitude_16sc16s_C1RSfs
//          ippiMagnitude_16sc16s_C3RSfs
//          ippiMagnitude_16uc16u_C1RSfs
//          ippiMagnitude_16uc16u_C3RSfs
//  Purpose:
//    Computes magnitude of elements of a complex data image.
//  Parameters:
//    pSrc        Pointer to the source image in common complex data format
//    srcStep     Step through the source image
//    pDst        Pointer to the destination image to store magnitude components
//    dstStep     Step through the destination image
//    roiSize     Size of the ROI
//    scaleFactor Scale factor (only for integer data)
//  Returns:
//    ippStsNullPtrErr    pSrc or pDst is NULL
//    ippStsSizeErr       The width or height of images is less than or equal to zero
//    ippStsStepErr       srcStep or dstStep is less than or equal to zero
//    ippStsNoErr         Otherwise
*)
  ippiMagnitude_32fc32f_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMagnitude_32fc32f_C3R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:   ippiPhase_32fc32f_C1R
//           ippiPhase_32fc32f_C3R
//           ippiPhase_16sc16s_C1RSfs
//           ippiPhase_16sc16s_C3RSfs
//           ippiPhase_16uc16u_C1RSfs
//           ippiPhase_16uc16u_C3RSfs
//  Purpose:
//    Computes the phase (in radians) of elements of a complex data image
//  Parameters:
//    pSrc         Pointer to the source image in common complex data format
//    srcStep      Step through the source image
//    pDst         Pointer to the destination image to store the phase components
//    dstStep      Step through the destination image
//    roiSize      Size of the ROI
//    scaleFactor  Scale factor (only for integer data)
//  Returns:
//    ippStsNullPtrErr    pSrc or pDst is NULL
//    ippStsSizeErr       The width or height of images is less than or equal to zero
//    ippStsStepErr       srcStep or dstStep is less than or equal to zero
//    ippStsNoErr         Otherwise
*)
  ippiPhase_32fc32f_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiPhase_32fc32f_C3R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                  Alpha Compositing Operations
///////////////////////////////////////////////////////////////////////////// *)
(*
//  Contents:
//      ippiAlphaPremul_8u_AC4R,  ippiAlphaPremul_16u_AC4R
//      ippiAlphaPremul_8u_AC4IR, ippiAlphaPremul_16u_AC4IR
//      ippiAlphaPremul_8u_AP4R,  ippiAlphaPremul_16u_AP4R
//      ippiAlphaPremul_8u_AP4IR, ippiAlphaPremul_16u_AP4IR
//   Pre-multiplies pixel values of an image by its alpha values.

//      ippiAlphaPremulC_8u_AC4R,  ippiAlphaPremulC_16u_AC4R
//      ippiAlphaPremulC_8u_AC4IR, ippiAlphaPremulC_16u_AC4IR
//      ippiAlphaPremulC_8u_AP4R,  ippiAlphaPremulC_16u_AP4R
//      ippiAlphaPremulC_8u_AP4IR, ippiAlphaPremulC_16u_AP4IR
//      ippiAlphaPremulC_8u_C4R,   ippiAlphaPremulC_16u_C4R
//      ippiAlphaPremulC_8u_C4IR,  ippiAlphaPremulC_16u_C4IR
//      ippiAlphaPremulC_8u_C3R,   ippiAlphaPremulC_16u_C3R
//      ippiAlphaPremulC_8u_C3IR,  ippiAlphaPremulC_16u_C3IR
//      ippiAlphaPremulC_8u_C1R,   ippiAlphaPremulC_16u_C1R
//      ippiAlphaPremulC_8u_C1IR,  ippiAlphaPremulC_16u_C1IR
//   Pre-multiplies pixel values of an image by constant alpha values.
//
//      ippiAlphaComp_8u_AC4R, ippiAlphaComp_16u_AC4R
//      ippiAlphaComp_8u_AC1R, ippiAlphaComp_16u_AC1R
//   Combines two images using alpha values of both images
//
//      ippiAlphaCompC_8u_AC4R, ippiAlphaCompC_16u_AC4R
//      ippiAlphaCompC_8u_AP4R, ippiAlphaCompC_16u_AP4R
//      ippiAlphaCompC_8u_C4R,  ippiAlphaCompC_16u_C4R
//      ippiAlphaCompC_8u_C3R,  ippiAlphaCompC_16u_C3R
//      ippiAlphaCompC_8u_C1R,  ippiAlphaCompC_16u_C1R
//   Combines two images using constant alpha values
//
//  Types of compositing operation (alphaType)
//      OVER   ippAlphaOver   ippAlphaOverPremul
//      IN     ippAlphaIn     ippAlphaInPremul
//      OUT    ippAlphaOut    ippAlphaOutPremul
//      ATOP   ippAlphaATop   ippAlphaATopPremul
//      XOR    ippAlphaXor    ippAlphaXorPremul
//      PLUS   ippAlphaPlus   ippAlphaPlusPremul
//
//  Type  result pixel           result pixel (Premul)    result alpha
//  OVER  aA*A+(1-aA)*aB*B         A+(1-aA)*B             aA+(1-aA)*aB
//  IN    aA*A*aB                  A*aB                   aA*aB
//  OUT   aA*A*(1-aB)              A*(1-aB)               aA*(1-aB)
//  ATOP  aA*A*aB+(1-aA)*aB*B      A*aB+(1-aA)*B          aA*aB+(1-aA)*aB
//  XOR   aA*A*(1-aB)+(1-aA)*aB*B  A*(1-aB)+(1-aA)*B      aA*(1-aB)+(1-aA)*aB
//  PLUS  aA*A+aB*B                A+B                    aA+aB
//      Here 1 corresponds significance VAL_MAX, multiplication is performed
//      with scaling
//          X * Y => (X * Y) / VAL_MAX
//      and VAL_MAX is the maximum presentable pixel value:
//          VAL_MAX == IPP_MAX_8U  for 8u
//          VAL_MAX == IPP_MAX_16U for 16u
*)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremul_8u_AC4R,  ippiAlphaPremul_16u_AC4R
//                  ippiAlphaPremul_8u_AC4IR, ippiAlphaPremul_16u_AC4IR
//                  ippiAlphaPremul_8u_AP4R,  ippiAlphaPremul_16u_AP4R
//                  ippiAlphaPremul_8u_AP4IR, ippiAlphaPremul_16u_AP4IR
//
//  Purpose:        Pre-multiplies pixel values of an image by its alpha values
//                  for 4-channel images
//               For channels 1-3
//                      dst_pixel = (src_pixel * src_alpha) / VAL_MAX
//               For alpha-channel (channel 4)
//                      dst_alpha = src_alpha
//  Parameters:
//     pSrc         Pointer to the source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     srcStep      Step through the source image
//     pDst         Pointer to the destination image for pixel-order data,
//                  array of pointers to separate destination color planes for planar data
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to the source/destination image, or array of pointers
//                  to separate source/destination color planes for in-place functions
//     srcDstStep   Step through the source/destination image for in-place functions
//     roiSize      Size of the source and destination ROI
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc == NULL, or pDst == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
*)

  ippiAlphaPremul_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremul_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremul_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremul_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;


  ippiAlphaPremul_8u_AP4R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremul_16u_AP4R: function(var pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremul_8u_AP4IR: function(var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremul_16u_AP4IR: function(var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_AC4R,  ippiAlphaPremulC_16u_AC4R
//                  ippiAlphaPremulC_8u_AC4IR, ippiAlphaPremulC_16u_ACI4R
//                  ippiAlphaPremulC_8u_AP4R,  ippiAlphaPremulC_16u_AP4R
//                  ippiAlphaPremulC_8u_AP4IR, ippiAlphaPremulC_16u_API4R
//
//  Purpose:        Pre-multiplies pixel values of an image by constant alpha values
//                  for 4-channel images
//               For channels 1-3
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//               For alpha-channel (channel 4)
//                      dst_alpha = const_alpha
//  Parameters:
//     pSrc         Pointer to the source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     srcStep      Step through the source image
//     pDst         Pointer to the destination image for pixel-order data,
//                  array of pointers to separate destination color planes for planar data
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to the source/destination image, or array of pointers
//                  to separate source/destination color planes for in-place functions
//     srcDstStep   Step through the source/destination image for in-place functions
//     alpha        The constant alpha value
//     roiSize      Size of the source and destination ROI
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pSrc == NULL, or pDst == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremulC_8u_AC4IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_AC4IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremulC_8u_AP4R: function(var pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_AP4R: function(var pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremulC_8u_AP4IR: function(alpha:Ipp8u;var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_AP4IR: function(alpha:Ipp16u;var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_C4R,  ippiAlphaPremulC_16u_C4R
//                  ippiAlphaPremulC_8u_C4IR, ippiAlphaPremulC_16u_C4IR
//
//  Purpose:        Pre-multiplies pixel values of an image by constant alpha values
//                  for 4-channel images:
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//  Parameters:
//     pSrc         Pointer to the source image
//     srcStep      Step through the source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to the source/destination image for in-place functions
//     srcDstStep   Step through the source/destination image for in-place functions
//     alpha        The constant alpha value
//     roiSize      Size of the source and destination ROI
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pSrc == NULL, or pDst == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremulC_8u_C4IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_C4IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_C3R,  ippiAlphaPremulC_16u_C3R
//                  ippiAlphaPremulC_8u_C3IR, ippiAlphaPremulC_16u_C3IR
//  Purpose:        Pre-multiplies pixel values of an image by constant alpha values
//                  for 3-channel images:
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//  Parameters:
//     pSrc         Pointer to the source image
//     srcStep      Step through the source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to the source/destination image for in-place functions
//     srcDstStep   Step through the source/destination image for in-place functions
//     alpha        The constant alpha value
//     roiSize      Size of the source and destination ROI
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pSrc == NULL, or pDst == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremulC_8u_C3IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_C3IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_C1R,  ippiAlphaPremulC_16u_C1R
//                  ippiAlphaPremulC_8u_C1IR, ippiAlphaPremulC_16u_C1IR
//  Purpose:        Pre-multiplies pixel values of an image by constant alpha values
//                  for 1-channel images:
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//  Parameters:
//     pSrc         Pointer to the source image
//     srcStep      Step through the source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to the source/destination image for in-place functions
//     srcDstStep   Step through the source/destination image for in-place functions
//     alpha        The constant alpha value
//     roiSize      Size of the source and destination ROI
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pSrc == NULL, or pDst == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)


  ippiAlphaPremulC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiAlphaPremulC_8u_C1IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAlphaPremulC_16u_C1IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaComp_8u_AC4R, ippiAlphaComp_16u_AC4R
//                  ippiAlphaComp_8s_AC4R, ippiAlphaComp_16s_AC4R
//                  ippiAlphaComp_32s_AC4R,ippiAlphaComp_32u_AC4R
//                  ippiAlphaComp_8u_AP4R, ippiAlphaComp_16u_AP4R
//
//  Purpose:        Combines two 4-channel images using alpha values of both images
//
//  Parameters:
//     pSrc1        Pointer to the first source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     src1Step     Step through the first source image
//     pSrc2        Pointer to the second source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     src2Step     Step through the second source image
//     pDst         Pointer to the destination image for pixel-order data,
//                  array of pointers to separate destination color planes for planar data
//     dstStep      Step through the destination image
//     roiSize      Size of the source and destination ROI
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc1== NULL, or pSrc2== NULL, or pDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//     Note:                  Result is wrong, if Alpha < 0 for signed types
*)

  ippiAlphaComp_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaComp_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;


  ippiAlphaComp_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32u_AC4R: function(pSrc1:PIpp32u;src1Step:longint;pSrc2:PIpp32u;src2Step:longint;pDst:PIpp32u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_8u_AP4R: function(var pSrc1:PIpp8u;src1Step:longint;var pSrc2:PIpp8u;src2Step:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_16u_AP4R: function(var pSrc1:PIpp16u;src1Step:longint;var pSrc2:PIpp16u;src2Step:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaComp_8u_AC1R, ippiAlphaComp_16u_AC1R
//                  ippiAlphaComp_8s_AC1R, ippiAlphaComp_16s_AC1R
//                  ippiAlphaComp_32s_AC1R, ippiAlphaComp_32u_AC1R
//  Purpose:        Combines two 1-channel images using alpha values of both images
//
//  Parameters:
//     pSrc1        Pointer to the first source image
//     src1Step     Step through the first source image
//     pSrc2        Pointer to the second source image
//     src2Step     Step through the second source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the source and destination ROI
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc1== NULL, or pSrc2== NULL, or pDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//     Note:                  Result is wrong, if Alpha < 0 for signed types
*)

  ippiAlphaComp_8u_AC1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaComp_16u_AC1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_16s_AC1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32s_AC1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32u_AC1R: function(pSrc1:PIpp32u;src1Step:longint;pSrc2:PIpp32u;src2Step:longint;pDst:PIpp32u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32f_AC1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_AC4R, ippiAlphaCompC_16u_AC4R
//                  ippiAlphaCompC_8u_AP4R, ippiAlphaCompC_16u_AP4R
//
//  Purpose:        Combines two 4-channel images using constant alpha values
//
//  Parameters:
//     pSrc1        Pointer to the first source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     src1Step     Step through the first source image
//     pSrc2        Pointer to the second source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     src2Step     Step through the second source image
//     pDst         Pointer to the destination image for pixel-order data,
//                  array of pointers to separate destination color planes for planar data
//     dstStep      Step through the destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the first source image
//     alpha2       The constant alpha value for the second source image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc1== NULL, or pSrc2== NULL, or pDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Alpha-channel values (channel 4) remain without modifications
//                  Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_8u_AP4R: function(var pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;var pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_AP4R: function(var pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;var pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C4R, ippiAlphaCompC_16u_C4R
//
//  Purpose:        Combines two 4-channel images using constant alpha values
//
//  Parameters:
//     pSrc1        Pointer to the first source image
//     src1Step     Step through the first source image
//     pSrc2        Pointer to the second source image
//     src2Step     Step through the second source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the first source image
//     alpha2       The constant alpha value for the second source image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc1== NULL, or pSrc2== NULL, or pDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C3R, ippiAlphaCompC_16u_C3R
//  Purpose:        Combines two 3-channel images using constant alpha values
//  Parameters:
//     pSrc1        Pointer to the first source image
//     src1Step     Step through the first source image
//     pSrc2        Pointer to the second source image
//     src2Step     Step through the second source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the first source image
//     alpha2       The constant alpha value for the second source image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc1== NULL, or pSrc2== NULL, or pDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C1R, ippiAlphaCompC_16u_C1R
//                  ippiAlphaCompC_8s_C1R, ippiAlphaCompC_16s_C1R
//                  ippiAlphaCompC_32s_C1R, ippiAlphaCompC_32u_C1R
//  Purpose:        Combines two 1-channel images using constant alpha values
//  Parameters:
//     pSrc1        Pointer to the first source image
//     src1Step     Step through the first source image
//     pSrc2        Pointer to the second source image
//     src2Step     Step through the second source image
//     pDst         Pointer to the destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the first source image
//     alpha2       The constant alpha value for the second source image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc1== NULL, or pSrc2== NULL, or pDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;alpha1:Ipp16s;pSrc2:PIpp16s;src2Step:longint;alpha2:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;


  ippiAlphaCompC_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;alpha1:Ipp32s;pSrc2:PIpp32s;src2Step:longint;alpha2:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_32u_C1R: function(pSrc1:PIpp32u;src1Step:longint;alpha1:Ipp32u;pSrc2:PIpp32u;src2Step:longint;alpha2:Ipp32u;pDst:PIpp32u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;alpha1:Ipp32f;pSrc2:PIpp32f;src2Step:longint;alpha2:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaComp_8u_AC4IR, ippiAlphaComp_16u_AC4IR
//                  ippiAlphaComp_8s_AC4IR, ippiAlphaComp_16s_AC4IR
//                  ippiAlphaComp_32s_AC4IR,ippiAlphaComp_32u_AC4IR
//                  ippiAlphaComp_8u_AP4IR, ippiAlphaComp_16u_AP4IR
//
//  Purpose:        Combines two 4-channel images using alpha values of both images
//
//  Parameters:
//     pSrc         Pointer to the source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     srcStep      Step through the source image
//     pSrcDst      Pointer to the source/destination image for pixel-order data,
//                  array of pointers to separate source/destination color planes for planar data
//     srcDstStep   Step through the source/destination image
//     roiSize      Size of the source and destination ROI
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//     Note:                  Result is wrong, if Alpha < 0 for signed types
*)

  ippiAlphaComp_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_16s_AC4IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32u_AC4IR: function(pSrc:PIpp32u;srcStep:longint;pSrcDst:PIpp32u;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_8u_AP4IR: function(var pSrc:PIpp8u;srcStep:longint;var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaComp_16u_AP4IR: function(var pSrc:PIpp16u;srcStep:longint;var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_AC4IR, ippiAlphaCompC_16u_AC4IR
//                  ippiAlphaCompC_8u_AP4IR, ippiAlphaCompC_16u_AP4IR
//
//  Purpose:        Combines two 4-channel images using constant alpha values
//
//  Parameters:
//     pSrc         Pointer to the source image for pixel-order data,
//                  array of pointers to separate source color planes for planar data
//     srcStep      Step through the source image
//     pSrcDst      Pointer to the source/destination image for pixel-order data,
//                  array of pointers to separate source/destination color planes for planar data
//     srcDstStep   Step through the source/destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the source image
//     alpha2       The constant alpha value for the source/destination image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Alpha-channel values (channel 4) remain without modifications
//                  Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;alpha1:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;alpha2:Ipp8u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;alpha1:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;alpha2:Ipp16u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_8u_AP4IR: function(var pSrc:PIpp8u;srcStep:longint;alpha1:Ipp8u;var pSrcDst:PIpp8u;srcDstStep:longint;alpha2:Ipp8u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_AP4IR: function(var pSrc:PIpp16u;srcStep:longint;alpha1:Ipp16u;var pSrcDst:PIpp16u;srcDstStep:longint;alpha2:Ipp16u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C4IR, ippiAlphaCompC_16u_C4IR
//
//  Purpose:        Combines two 4-channel images using constant alpha values
//
//  Parameters:
//     pSrc         Pointer to the source image
//     srcStep      Step through the source image
//     pSrcDst      Pointer to the source/destination image
//     srcDstStep   Step through the source/destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the source image
//     alpha2       The constant alpha value for the source/destination image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;alpha1:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;alpha2:Ipp8u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;alpha1:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;alpha2:Ipp16u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C3IR, ippiAlphaCompC_16u_C3IR
//  Purpose:        Combines two 3-channel images using constant alpha values
//  Parameters:
//     pSrc         Pointer to the source image
//     srcStep      Step through the source image
//     pSrcDst      Pointer to the source/destination image
//     srcDstStep   Step through the source/destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the source image
//     alpha2       The constant alpha value for the source/destination image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;alpha1:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;alpha2:Ipp8u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;alpha1:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;alpha2:Ipp16u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C1IR, ippiAlphaCompC_16u_C1IR
//                  ippiAlphaCompC_8s_C1IR, ippiAlphaCompC_16s_C1IR
//                  ippiAlphaCompC_32s_C1IR, ippiAlphaCompC_32u_C1IR
//  Purpose:        Combines two 1-channel images using constant alpha values
//  Parameters:
//     pSrc         Pointer to the source image
//     srcStep      Step through the source image
//     pSrcDst      Pointer to the source/destination image
//     srcDstStep   Step through the source/destination image
//     roiSize      Size of the source and destination ROI
//     alpha1       The constant alpha value for the source image
//     alpha2       The constant alpha value for the source/destination image
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pSrc == NULL, or pSrcDst == NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsAlphaTypeErr     The alphaType is incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;alpha1:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;alpha2:Ipp8u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;
  ippiAlphaCompC_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;alpha1:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;alpha2:Ipp16u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_16s_C1IR: function(pSrc:PIpp16s;srcStep:longint;alpha1:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;alpha2:Ipp16s;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;


  ippiAlphaCompC_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;alpha1:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;alpha2:Ipp32s;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_32u_C1IR: function(pSrc:PIpp32u;srcStep:longint;alpha1:Ipp32u;pSrcDst:PIpp32u;srcDstStep:longint;alpha2:Ipp32u;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;

  ippiAlphaCompC_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;alpha1:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;alpha2:Ipp32f;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                  Linear Transform Operations
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for FFT Functions
///////////////////////////////////////////////////////////////////////////// *)


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTInit
//  Purpose:    Initializes the FFT context structure
//  Arguments:
//     orderX     Base-2 logarithm of the number of samples in FFT (width)
//     orderY     Base-2 logarithm of the number of samples in FFT (height)
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pFFTSpec   Pointer to the FFT context structure
//     pMemInit   Pointer to the temporary work buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//     ippStsFftOrderErr      FFT order value is illegal
//     ippStsFFTFlagErr       Incorrect normalization flag value
*)

  ippiFFTInit_C_32fc: function(orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm;pFFTSpec:PIppiFFTSpec_C_32fc;pMemInit:PIpp8u):IppStatus;
  ippiFFTInit_R_32f: function(orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm;pFFTSpec:PIppiFFTSpec_R_32f;pMemInit:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTGetSize
//  Purpose:    Computes the size of the FFT context structure and the size
                of the required work buffer (in bytes)
//  Arguments:
//     orderX     Base-2 logarithm of the number of samples in FFT (width)
//     orderY     Base-2 logarithm of the number of samples in FFT (height)
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pSizeSpec  Pointer to the size value of FFT specification structure
//     pSizeInit  Pointer to the size value of the buffer for FFT initialization function
//     pSizeBuf   Pointer to the size value of the FFT external work buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//     ippStsFftOrderErr      FFT order value is illegal
//     ippStsFFTFlagErr       Incorrect normalization flag value
*)

  ippiFFTGetSize_C_32fc: function(orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;
  ippiFFTGetSize_R_32f: function(orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTFwd, ippiFFTInv
//  Purpose:    Performs forward or inverse FFT of an image
//  Parameters:
//     pFFTSpec   Pointer to the FFT context structure
//     pSrc       Pointer to the source image
//     srcStep    Step through the source image
//     pDst       Pointer to the destination image
//     dstStep    Step through the destination image
//     pSrcDst    Pointer to the source/destination image (in-place)
//     srcDstStep Step through the source/destination image (in-place)
//     pBuffer    Pointer to the external work buffer
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers with the exception of
                              pBuffer is NULL
//     ippStsStepErr          srcStep or dstStep value is zero or negative
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation error
*)

  ippiFFTFwd_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pFFTSpec:PIppiFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pFFTSpec:PIppiFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;

  ippiFFTFwd_RToPack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTFwd_RToPack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTFwd_RToPack_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTFwd_RToPack_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

  ippiFFTInv_PackToR_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_PackToR_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_PackToR_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_PackToR_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

  ippiFFTFwd_CToC_32fc_C1IR: function(pSrcDst:PIpp32fc;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_CToC_32fc_C1IR: function(pSrcDst:PIpp32fc;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;

  ippiFFTFwd_RToPack_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTFwd_RToPack_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTFwd_RToPack_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTFwd_RToPack_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

  ippiFFTInv_PackToR_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_PackToR_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_PackToR_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiFFTInv_PackToR_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DFT Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:         ippiDFTInit
//  Purpose:      Initializes the DFT context structure
//  Parameters:
//     roiSize    Size of the ROI
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pDFTSpec   Double pointer to the DFT context structure
//     pMemInit   Pointer to initialization buffer
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//     ippStsFftOrderErr      Invalid roiSize
//     ippStsSizeErr          roiSize has a field with zero or negative value
//     ippStsFFTFlagErr       Incorrect normalization flag value
*)

  ippiDFTInit_C_32fc: function(roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppiDFTSpec_C_32fc;pMemInit:PIpp8u):IppStatus;
  ippiDFTInit_R_32f: function(roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm;pDFTSpec:PIppiDFTSpec_R_32f;pMemInit:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDFTGetSize
//  Purpose:    Computes the size of the DFT context structure and the size
                of the required work buffer (in bytes)
//  Parameters:
//     roiSize    Size of the ROI
//     flag       Flag to choose the results normalization factors
//     hint       Option to select the algorithmic implementation of the transform
//                function
//     pSizeSpec  Pointer to the size value of DFT specification structure
//     pSizeInit  Pointer to the size value of the buffer for DFT initialization function
//     pSizeBuf   Pointer to the size value of the DFT external work buffer
//  Return:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//     ippStsFftOrderErr      Invalid roiSize
//     ippStsSizeErr          roiSize has a field with zero or negative value
//     ippStsFFTFlagErr       Incorrect normalization flag value
*)

  ippiDFTGetSize_C_32fc: function(roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;
  ippiDFTGetSize_R_32f: function(roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDFTFwd, ippiDFTInv
//  Purpose:    Performs forward or inverse DFT of an image
//  Parameters:
//     pDFTSpec    Pointer to the DFT context structure
//     pSrc        Pointer to source image
//     srcStep     Step through the source image
//     pDst        Pointer to the destination image
//     dstStep     Step through the destination image
//     pSrcDst     Pointer to the source/destination image (in-place)
//     srcDstStep  Step through the source/destination image (in-place)
//     pBuffer     Pointer to the external work buffer
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers with the exception of
                              pBuffer is NULL
//     ippStsStepErr          srcStep or dstStep value is zero or negative
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation error
*)

  ippiDFTFwd_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pDFTSpec:PIppiDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pDFTSpec:PIppiDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;

  ippiDFTFwd_RToPack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTFwd_RToPack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTFwd_RToPack_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTFwd_RToPack_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

  ippiDFTInv_PackToR_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_PackToR_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_PackToR_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_PackToR_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

  ippiDFTFwd_CToC_32fc_C1IR: function(pSrcDst:PIpp32fc;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_CToC_32fc_C1IR: function(pSrcDst:PIpp32fc;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;

  ippiDFTFwd_RToPack_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTFwd_RToPack_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTFwd_RToPack_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTFwd_RToPack_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

  ippiDFTInv_PackToR_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_PackToR_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_PackToR_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;
  ippiDFTInv_PackToR_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DCT Functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwdInit, ippiDCTInvInit
//  Purpose:    Initializes the forward/inverse DCT context structure
//  Parameters:
//     pDCTSpec   Pointer to the DCT context structure
//     roiSize    Size of the ROI
//     pMemInit   Pointer to the temporary work buffer
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       pDCTSpec == NULL
//     ippStsSizeErr          roiSize has a field with zero or negative value
*)

  ippiDCTFwdInit_32f: function(pDCTSpec:PIppiDCTFwdSpec_32f;roiSize:IppiSize;pMemInit:PIpp8u):IppStatus;
  ippiDCTInvInit_32f: function(pDCTSpec:PIppiDCTInvSpec_32f;roiSize:IppiSize;pMemInit:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwdGetSize, ippiDCTInvGetSize
//  Purpose:    Computes the size of the forward/inverse DCT context structure and the size
//              of the required work buffer (in bytes)
//  Parameters:
//     roiSize    Size of the ROI
//     pSizeSpec  Pointer to the size value of DCT context structure
//     pSizeInit  Pointer to the size value of the buffer for DCT initialization function
//     pSizeBuf   Pointer to the size value of the DCT external work buffer
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//     ippStsSizeErr          roiSize has a field with zero or negative value
*)

  ippiDCTFwdGetSize_32f: function(roiSize:IppiSize;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;
  ippiDCTInvGetSize_32f: function(roiSize:IppiSize;pSizeSpec:Plongint;pSizeInit:Plongint;pSizeBuf:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwd, ippiDCTInv
//  Purpose:    Performs forward or inverse DCT of an image
//  Parameters:
//     pDCTSpec   Pointer to the DCT context structure
//     pSrc       Pointer to the source image
//     srcStep    Step through the source image
//     pDst       Pointer to the destination image
//     dstStep    Step through the destination image
//     pBuffer    Pointer to the work buffer
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers with the exception of
                              pBuffer is NULL
//     ippStsStepErr          srcStep or dstStep value is zero or negative
//     ippStsContextMatchErr  Invalid context structure
//     ippStsMemAllocErr      Memory allocation error
*)

  ippiDCTFwd_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiDCTFwd_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiDCTFwd_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiDCTFwd_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;

  ippiDCTInv_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiDCTInv_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiDCTInv_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiDCTInv_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                  8x8 DCT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Fwd_16s_C1, ippiDCT8x8Fwd_16s_C1I
//             ippiDCT8x8Inv_16s_C1, ippiDCT8x8Inv_16s_C1I
//             ippiDCT8x8Fwd_16s_C1R
//             ippiDCT8x8Inv_16s_C1R
//  Purpose:   Performs forward or inverse DCT in the 8x8 buffer for 16s data
//
//  Parameters:
//     pSrc       Pointer to the source buffer
//     pDst       Pointer to the destination buffer
//     pSrcDst    Pointer to the source and destination buffer (in-place operations)
//     srcStep    Step through the source image (operations with ROI)
//     dstStep    Step through the destination image (operations with ROI)
//  Returns:
//     ippStsNoErr         No errors
//     ippStsNullPtrErr    One of the specified pointers is NULL
//     ippStsStepErr       srcStep or dstStep value is zero or negative
//  Notes:
//     Source data for inverse DCT functions must be the result of the forward DCT
//     of data from the range [-256,255]
*)

  ippiDCT8x8Fwd_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;
  ippiDCT8x8Inv_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;

  ippiDCT8x8Fwd_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;
  ippiDCT8x8Inv_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;

  ippiDCT8x8Fwd_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s):IppStatus;
  ippiDCT8x8Inv_16s_C1R: function(pSrc:PIpp16s;pDst:PIpp16s;dstStep:longint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Inv_2x2_16s_C1, ippiDCT8x8Inv_2x2_16s_C1I
//             ippiDCT8x8Inv_4x4_16s_C1, ippiDCT8x8Inv_4x4_16s_C1I
//  Purpose:   Performs inverse DCT of nonzero elements in the top left quadrant
//             of size 2x2 or 4x4 in the 8x8 buffer
//  Parameters:
//     pSrc       Pointer to the source buffer
//     pDst       Pointer to the destination buffer
//     pSrcDst    Pointer to the source/destination buffer (in-place operations)
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//  Notes:
//     Source data for these functions must be the result of the forward DCT
//     of data from the range [-256,255]
*)

  ippiDCT8x8Inv_2x2_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;
  ippiDCT8x8Inv_4x4_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;

  ippiDCT8x8Inv_2x2_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;
  ippiDCT8x8Inv_4x4_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8To2x2Inv_16s_C1, ippiDCT8x8To2x2Inv_16s_C1I
//             ippiDCT8x8To4x4Inv_16s_C1, ippiDCT8x8To4x4Inv_16s_C1I
//  Purpose:   Inverse Discrete Cosine Transform 8x8 for 16s data and
//             downsampling of the result from 8x8 to 2x2 or 4x4 by averaging
//  Arguments:
//     pSrc       Pointer to the source buffer
//     pDst       Pointer to the destination buffer
//     pSrcDst    Pointer to the source/destination buffer (in-place operations)
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
//  Notes:
//     Source data for these functions must be the result of the forward DCT
//     of data from the range [-256,255]
*)

  ippiDCT8x8To2x2Inv_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;
  ippiDCT8x8To4x4Inv_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;

  ippiDCT8x8To2x2Inv_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;
  ippiDCT8x8To4x4Inv_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Inv_A10_16s_C1, ippiDCT8x8Inv_A10_16s_C1I
//  Purpose:   Performs inverse DCT in the 8x8 buffer for 10 bits 16s data
//
//  Parameters:
//     pSrc       Pointer to the source buffer
//     pDst       Pointer to the destination buffer
//  Returns:
//     ippStsNoErr         No errors
//     ippStsNullPtrErr    One of the specified pointers is NULL
//  Notes:
//     Source data for these functions must be the result of the forward DCT
//     of data from the range [-512,511]
*)

  ippiDCT8x8Inv_A10_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;
  ippiDCT8x8Inv_A10_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Fwd_8u16s_C1R
//             ippiDCT8x8Inv_16s8u_C1R
//  Purpose:   Performs forward and inverse DCT in 8x8 buffer
//             for 16s data with conversion from/to 8u
//  Parameters:
//     pSrc      Pointer to the source buffer
//     pDst      Pointer to the destination buffer
//     srcStep   Step through the source image
//     dstStep   Step through the destination image
//  Returns:
//     ippStsNoErr        No errors
//     ippStsNullPtrErr   One of the specified pointers is NULL
//     ippStsStepErr      srcStep or dstStep value is zero or negative
*)

  ippiDCT8x8Fwd_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s):IppStatus;

  ippiDCT8x8Inv_16s8u_C1R: function(pSrc:PIpp16s;pDst:PIpp8u;dstStep:longint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8FwdLS_8u16s_C1R
//  Purpose:   Performs forward DCT in 8x8 buffer for 16s data
//             with conversion from 8u and level shift
//  Parameters:
//     pSrc      Pointer to start of source buffer
//     pDst      Pointer to start of destination buffer
//     srcStep   Step the source buffer
//     addVal    Constant value adding before DCT (level shift)
//  Returns:
//     ippStsNoErr         No errors
//     ippStsNullPtrErr    One of the specified pointers is NULL
//     ippStsStepErr       srcStep value is zero or negative
*)

  ippiDCT8x8FwdLS_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;addVal:Ipp16s):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8InvLSClip_16s8u_C1R
//  Purpose:   Performs inverse DCT in 8x8 buffer for 16s data
//             with level shift, clipping and conversion to 8u
//  Parameters:
//     pSrc      Pointer to the source buffer
//     pDst      Pointer to the destination buffer
//     dstStep   Step through the destination image
//     addVal    Constant value adding after DCT (level shift)
//     clipDown  Constant value for clipping (MIN)
//     clipUp    Constant value for clipping (MAX)
//  Returns:
//     ippStsNoErr           No errors
//     ippStsNullPtrErr      One of the pointers is NULL
//     ippStsStepErr         dstStep value is zero or negative
*)

  ippiDCT8x8InvLSClip_16s8u_C1R: function(pSrc:PIpp16s;pDst:PIpp8u;dstStep:longint;addVal:Ipp16s;clipDown:Ipp8u;clipUp:Ipp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Fwd_32f_C1, ippiDCT8x8Fwd_32f_C1I
//             ippiDCT8x8Inv_32f_C1, ippiDCT8x8Inv_32f_C1I
//  Purpose:   Performs forward or inverse DCT in the 8x8 buffer for 32f data
//
//  Parameters:
//     pSrc       Pointer to the source buffer
//     pDst       Pointer to the destination buffer
//     pSrcDst    Pointer to the source and destination buffer (in-place operations)
//  Returns:
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the specified pointers is NULL
*)

  ippiDCT8x8Fwd_32f_C1: function(pSrc:PIpp32f;pDst:PIpp32f):IppStatus;
  ippiDCT8x8Inv_32f_C1: function(pSrc:PIpp32f;pDst:PIpp32f):IppStatus;

  ippiDCT8x8Fwd_32f_C1I: function(pSrcDst:PIpp32f):IppStatus;
  ippiDCT8x8Inv_32f_C1I: function(pSrcDst:PIpp32f):IppStatus;




(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Functions for User Filter Banks
///////////////////////////////////////////////////////////////////////////// *)

(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTFwdGetSize_32f
//
// Purpose:     Get sizes, in bytes, of the ippiWTFwd spec structure and the work buffer.
//
// Parameters:
//    numChannels - Number of image channels. Possible values are 1 and 3.
//    lenLow      - Length of the lowpass filter.
//    anchorLow   - Anchor position of the lowpass filter.
//    lenHigh     - Length of the highpass filter.
//    anchorHigh  - Anchor position of the highpass filter.
//    pSpecSize   - Pointer to the size of the ippiWTFwd spec structure (in bytes).
//    pBufSize    - Pointer to the size of the work buffer (in bytes).
//
// Returns:
//    ippStsNoErr           - Ok.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr  - Error when the numChannels value differs from 1 or 3.
//    ippStsSizeErr         - Error when lenLow or lenHigh is less than 2.
//    ippStsAnchorErr       - Error when anchorLow or anchorHigh is less than zero.
*)
  ippiWTFwdGetSize_32f: function(numChannels:longint;lenLow:longint;anchorLow:longint;lenHigh:longint;anchorHigh:longint;pSpecSize:Plongint;pBufSize:Plongint):IppStatus;

(* //////////////////////////////////////////////////////////////////////
// Name:       ippiWTFwdInit_
//
// Purpose:    Initialize forward wavelet transform spec structure.
//
// Parameters:
//   pSpec        - Pointer to pointer to allocated ippiWTFwd spec structure.
//   pTapsLow     - Pointer to lowpass filter taps.
//   lenLow       - Length of lowpass filter.
//   anchorLow    - Anchor position of lowpass filter.
//   pTapsHigh    - Pointer to highpass filter taps.
//   lenHigh      - Length of highpass filter.
//   anchorHigh   - Anchor position of highpass filter.
//
// Returns:
//    ippStsNoErr           - Ok.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr  - Error when the numChannels value differs from 1 or 3.
//    ippStsSizeErr         - Error when lenLow or lenHigh is less than 2.
//    ippStsAnchorErr       - Error when anchorLow or anchorHigh is less than zero.
*)
  ippiWTFwdInit_32f_C1R: function(pSpec:PIppiWTFwdSpec_32f_C1R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;
  ippiWTFwdInit_32f_C3R: function(pSpec:PIppiWTFwdSpec_32f_C3R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;



(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTFwd_32f_C1R
//              ippiWTFwd_32f_C3R
//
// Purpose:     Performs wavelet decomposition of an image.
//
// Parameters:
//   pSrc         Pointer to source image ROI;
//   srcStep      Step in bytes through the source image;
//   pApproxDst   Pointer to destination "approximation" image ROI;
//   approxStep   Step in bytes through the destination approximation image;
//   pDetailXDst  Pointer to the destination "horizontal details" image ROI;
//   detailXStep  Step in bytes through the destination horizontal detail image;
//   pDetailYDst  Pointer to the destination "vertical details" image ROI;
//   detailYStep  Step in bytes through the destination "vertical details" image;
//   pDetailXYDst Pointer to the destination "diagonal details" image ROI;
//   detailXYStep Step in bytes through the destination "diagonal details" image;
//   dstRoiSize   ROI size for all destination images.
//   pSpec        Pointer to the context structure.
//
// Returns:
//   ippStsNoErr            OK;
//   ippStsNullPtrErr       One of pointers is NULL;
//   ippStsSizeErr          dstRoiSize has a field with zero or negative value;
//   ippStsContextMatchErr  Invalid context structure.
//
// Notes:
//   No any fixed borders extension (wrap, symm.) will be applied!
//   Source image must have valid and accessible border data outside of ROI.
//
//   Only the same ROI sizes for destination images are supported.
//
//   Source ROI size should be calculated by the following rule:
//          srcRoiSize.width  = 2 * dstRoiSize.width;
//          srcRoiSize.height = 2 * dstRoiSize.height.
//
//   Conventional tokens for destination images have next meaning:
//    "Approximation"     - image obtained by vertical
//                              and horizontal lowpass filtering.
//    "Horizontal detail" - image obtained by vertical highpass
//                              and horizontal lowpass filtering.
//    "Vertical detail"   - image obtained by vertical lowpass
//                              and horizontal highpass filtering.
//    "Diagonal detail"   - image obtained by vertical
//                              and horizontal highpass filtering.
//   These tokens are used only for identification convenience.
//
//
*)
  ippiWTFwd_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pApproxDst:PIpp32f;approxStep:longint;pDetailXDst:PIpp32f;detailXStep:longint;pDetailYDst:PIpp32f;detailYStep:longint;pDetailXYDst:PIpp32f;detailXYStep:longint;dstRoiSize:IppiSize;pSpec:PIppiWTFwdSpec_32f_C1R;pBuffer:PIpp8u):IppStatus;

  ippiWTFwd_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pApproxDst:PIpp32f;approxStep:longint;pDetailXDst:PIpp32f;detailXStep:longint;pDetailYDst:PIpp32f;detailYStep:longint;pDetailXYDst:PIpp32f;detailXYStep:longint;dstRoiSize:IppiSize;pSpec:PIppiWTFwdSpec_32f_C3R;pBuffer:PIpp8u):IppStatus;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTInvGetSize_32f
//
// Purpose:     Get sizes, in bytes, of the WTInv spec structure and the work buffer.
//
// Parameters:
//    numChannels - Number of image channels. Possible values are 1 and 3.
//    lenLow      - Length of the lowpass filter.
//    anchorLow   - Anchor position of the lowpass filter.
//    lenHigh     - Length of the highpass filter.
//    anchorHigh  - Anchor position of the highpass filter.
//    pSpecSize   - Pointer to the size of the ippiWTInv spec structure (in bytes).
//    pBufSize    - Pointer to the size of the work buffer (in bytes).
//
// Returns:
//    ippStsNoErr           - Ok.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr  - Error when the numChannels value differs from 1 or 3.
//    ippStsSizeErr         - Error when lenLow or lenHigh is less than 2.
//    ippStsAnchorErr       - Error when anchorLow or anchorHigh is less than zero.
*)
  ippiWTInvGetSize_32f: function(numChannels:longint;lenLow:longint;anchorLow:longint;lenHigh:longint;anchorHigh:longint;pSpecSize:Plongint;pBufSize:Plongint):IppStatus;


(* //////////////////////////////////////////////////////////////////////
// Name:       ippiWTInvInit_
//
// Purpose:    Initialize inverse wavelet transform spec structure.
//
// Parameters:
//   pSpec        - Pointer to pointer to allocated ippiWTInv spec structure.
//   pTapsLow     - Pointer to lowpass filter taps.
//   lenLow       - Length of lowpass filter.
//   anchorLow    - Anchor position of lowpass filter.
//   pTapsHigh    - Pointer to highpass filter taps.
//   lenHigh      - Length of highpass filter.
//   anchorHigh   - Anchor position of highpass filter.
//
// Returns:
//    ippStsNoErr           - Ok.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr  - Error when the numChannels value differs from 1 or 3.
//    ippStsSizeErr         - Error when lenLow or lenHigh is less than 2.
//    ippStsAnchorErr       - Error when anchorLow or anchorHigh is less than zero.
*)
  ippiWTInvInit_32f_C1R: function(pSpec:PIppiWTInvSpec_32f_C1R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;
  ippiWTInvInit_32f_C3R: function(pSpec:PIppiWTInvSpec_32f_C3R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;




(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTInv_32f_C1R
//              ippiWTInv_32f_C3R
//
// Purpose:     Performs wavelet reconstruction of an image.
//
// Parameters:
//   pApproxSrc    Pointer to the source "approximation" image ROI;
//   approxStep    Step in bytes through the source approximation image;
//   pDetailXSrc   Pointer to the source "horizontal details" image ROI;
//   detailXStep   Step in bytes through the source horizontal detail image;
//   pDetailYSrc   Pointer to the source "vertical details" image ROI;
//   detailYStep   Step in bytes through the source "vertical details" image;
//   pDetailXYSrc  Pointer to the source "diagonal details" image ROI;
//   detailXYStep  Step in bytes through the source "diagonal details" image;
//   srcRoiSize    ROI size for all source images.
//   pDst          Pointer to the destination image ROI;
//   dstStep       Step in bytes through the destination image;
//   pSpec         Pointer to the context structure;
//   pBuffer       Pointer to the allocated buffer for intermediate operations.
//
// Returns:
//   ippStsNoErr            OK;
//   ippStsNullPtrErr       One of the pointers is NULL;
//   ippStsSizeErr          srcRoiSize has a field with zero or negative value;
//   ippStsContextMatchErr  Invalid context structure.
//
// Notes:
//   No any fixed borders extension (wrap, symm.) will be applied! Source
//    images must have valid and accessible border data outside of ROI.
//
//   Only the same ROI size for source images supported. Destination ROI size
//     should be calculated by next rule:
//          dstRoiSize.width  = 2 * srcRoiSize.width;
//          dstRoiSize.height = 2 * srcRoiSize.height.
//
//
//   Monikers for the source images are in accordance with decomposition destination.
//
//
*)
  ippiWTInv_32f_C1R: function(pApproxSrc:PIpp32f;approxStep:longint;pDetailXSrc:PIpp32f;detailXStep:longint;pDetailYSrc:PIpp32f;detailYStep:longint;pDetailXYSrc:PIpp32f;detailXYStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;pSpec:PIppiWTInvSpec_32f_C1R;pBuffer:PIpp8u):IppStatus;
  ippiWTInv_32f_C3R: function(pApproxSrc:PIpp32f;approxStep:longint;pDetailXSrc:PIpp32f;detailXStep:longint;pDetailYSrc:PIpp32f;detailYStep:longint;pDetailXYSrc:PIpp32f;detailXYStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;pSpec:PIppiWTInvSpec_32f_C3R;pBuffer:PIpp8u):IppStatus;




(* /////////////////////////////////////////////////////////////////////////////
//                   Image resampling functions
///////////////////////////////////////////////////////////////////////////// *)


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiDecimateFilterRow_8u_C1R,
//                      ippiDecimateFilterColumn_8u_C1R
//  Purpose:            Decimate the image with specified filters
//                      in horizontal or vertical directions
//  Parameters:
//    pSrc              source image data
//    srcStep           step in source image
//    srcRoiSize        region of interest of source image
//    pDst              resultant image data
//    dstStep           step in destination image
//    fraction          they specify fractions of decimating
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  one of the pointers is NULL
//    ippStsStepErr     one of the step values is zero or negative
//    ippStsSizeErr     srcRoiSize has a field with negative or zero value
//    ippStsDecimateFractionErr (fraction != ippPolyphase_1_2) &&
//                              (fraction != ippPolyphase_3_5) &&
//                              (fraction != ippPolyphase_2_3) &&
//                              (fraction != ippPolyphase_7_10) &&
//                              (fraction != ippPolyphase_3_4)
*)

  ippiDecimateFilterRow_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;fraction:IppiFraction):IppStatus;
  ippiDecimateFilterColumn_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;fraction:IppiFraction):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                   Geometric Transform functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:        ippiMirror
//
//  Purpose:     Mirrors an image about a horizontal
//               or vertical axis, or both
//
//  Context:
//
//  Returns:     IppStatus
//    ippStsNoErr         No errors
//    ippStsNullPtrErr    pSrc == NULL, or pDst == NULL
//    ippStsSizeErr,      roiSize has a field with zero or negative value
//    ippStsMirrorFlipErr (flip != ippAxsHorizontal) &&
//                        (flip != ippAxsVertical) &&
//                        (flip != ippAxsBoth)
//
//  Parameters:
//    pSrc       Pointer to the source image
//    srcStep    Step through the source image
//    pDst       Pointer to the destination image
//    dstStep    Step through the destination image
//    pSrcDst    Pointer to the source/destination image (in-place flavors)
//    srcDstStep Step through the source/destination image (in-place flavors)
//    roiSize    Size of the ROI
//    flip       Specifies the axis to mirror the image about:
//                 ippAxsHorizontal     horizontal axis,
//                 ippAxsVertical       vertical axis,
//                 ippAxsBoth           both horizontal and vertical axes
//
//  Notes:
//
*)

  ippiMirror_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;

  ippiMirror_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;

  ippiMirror_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;

  ippiMirror_32s_C1IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32s_C3IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32s_AC4IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32s_C4IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;

  ippiMirror_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;

  ippiMirror_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;
  ippiMirror_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiRemap
//  Purpose:            Transforms the source image by remapping its pixels
//                          dst[i,j] = src[xMap[i,j], yMap[i,j]]
//  Parameters:
//    pSrc              Pointer to the source image (point to pixel (0,0)). An array
//                      of pointers to each plane of the source image for planar data
//    srcSize           Size of the source image
//    srcStep           Step through the source image
//    srcROI            Region if interest in the source image
//    pxMap             Pointer to image with x coordinates of map
//    xMapStep          The step in xMap image
//    pyMap             The pointer to image with y coordinates of map
//    yMapStep          The step in yMap image
//    pDst              Pointer to the destination image. An array of pointers
//                      to each plane of the destination image for planar data
//    dstStep           Step through the destination image
//    dstRoiSize        Size of the destination ROI
//    interpolation     The type of interpolation to perform for image resampling
//                      The following types are currently supported:
//                        IPPI_INTER_NN       Nearest neighbor interpolation
//                        IPPI_INTER_LINEAR   Linear interpolation
//                        IPPI_INTER_CUBIC    Cubic interpolation
//                        IPPI_INTER_CUBIC2P_CATMULLROM  Catmull-Rom cubic filter
//                        IPPI_INTER_LANCZOS  Interpolation by Lanczos3-windowed sinc function
//                      The special feature in addition to one of general methods:
//                        IPPI_SMOOTH_EDGE    Edges smoothing
//  Returns:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  One of the pointers is NULL
//    ippStsSizeErr     srcROI or dstRoiSize has a field with zero or negative value
//    ippStsStepErr     One of the step values is zero or negative
//    ippStsInterpolateErr  interpolation has an illegal value
*)

  ippiRemap_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16u_AC4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16s_C1R: function(pSrc:PIpp16s;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16s_C3R: function(pSrc:PIpp16s;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16s_C4R: function(pSrc:PIpp16s;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_16s_AC4R: function(pSrc:PIpp16s;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_64f_C1R: function(pSrc:PIpp64f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp64f;xMapStep:longint;pyMap:PIpp64f;yMapStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_64f_C3R: function(pSrc:PIpp64f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp64f;xMapStep:longint;pyMap:PIpp64f;yMapStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_64f_C4R: function(pSrc:PIpp64f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp64f;xMapStep:longint;pyMap:PIpp64f;yMapStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;
  ippiRemap_64f_AC4R: function(pSrc:PIpp64f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp64f;xMapStep:longint;pyMap:PIpp64f;yMapStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                     Resize functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:               ippiResizeFilterGetSize_8u_C1R
//  Purpose:            Computes pState size for resize filter (in bytes)
//  Parameters:
//    srcRoiSize        region of interest of source image
//    dstRoiSize        region of interest of destination image
//    filter            type of resize filter
//    pSize             pointer to State size
//  Returns:
//    ippStsNoErr       no errors
//    ippStsSizeErr     width or height of images is less or equal to zero
//    ippStsNotSupportedModeErr filter type is not supported
//    ippStsNullPtrErr  pointer to buffer size is NULL
*)

  ippiResizeFilterGetSize_8u_C1R: function(srcRoiSize:IppiSize;dstRoiSize:IppiSize;filter:IppiResizeFilterType;pSize:PIpp32u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeFilterInit_8u_C1R
//  Purpose:            Initialization of State for resize filter
//  Parameters:
//    pState            pointer to State
//    srcRoiSize        region of interest of source image
//    dstRoiSize        region of interest of destination image
//    filter            type of resize filter
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  pointer to Spec is NULL
//    ippStsSizeErr     width or height of images is less or equal to zero
//    ippStsNotSupportedModeErr filter type is not supported
*)

  ippiResizeFilterInit_8u_C1R: function(pState:PIppiResizeFilterState;srcRoiSize:IppiSize;dstRoiSize:IppiSize;filter:IppiResizeFilterType):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeFilter_8u_C1R
//  Purpose:            Performs RESIZE transform using generic filter
//  Parameters:
//    pSrc              source image data
//    srcStep           step in source image
//    srcRoiSize        region of interest of source image
//    pDst              resultant image data
//    dstStep           step in destination image
//    dstRoiSize        region of interest of destination image
//    pState            pointer to filter state
//  Return:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  pSrc == NULL or pDst == NULL or pState == NULL
//    ippStsStepErr     srcStep or dstStep is less than or equal to zero
//    ippStsSizeErr     width or height of images is less or equal to zero
//    ippStsContextMatchErr invalid context structure
*)

  ippiResizeFilter_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pState:PIppiResizeFilterState):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                     Resize functions. YUY2 pixel format
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYCbCr422GetBufSize
//  Purpose:            Computes the size of an external work buffer (in bytes)
//  Parameters:
//    srcROI            region of interest of source image
//    dstRoiSize        region of interest of destination image
//    interpolation     type of interpolation to perform for resizing the input image:
//                        IPPI_INTER_NN      Nearest Neighbor interpolation
//                        IPPI_INTER_LINEAR  Linear interpolation
//                        IPPI_INTER_CUBIC   Cubic interpolation
//                        IPPI_INTER_CUBIC2P_CATMULLROM Catmull-Rom cubic filter
//                        IPPI_INTER_LANCZOS Lanczos3 filter
//    pSize             pointer to the external buffer`s size
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  pSize == NULL
//    ippStsSizeErr     width of src or dst image is less than two, or
//                      height of src or dst image is less than one
//    ippStsDoubleSize  width of src or dst image doesn't multiple of two (indicates warning)
//    ippStsInterpolationErr  interpolation has an illegal value
*)

  ippiResizeYCbCr422GetBufSize: function(srcROI:IppiRect;dstRoiSize:IppiSize;interpolation:longint;pSize:Plongint):IppStatus;

(*
//  Name:               ippiResizeYCbCr422_8u_C2R
//  Purpose:            Performs RESIZE transform for image with YCbCr422 pixel format
//  Parameters:
//    pSrc              source image data
//    srcSize           size of source image
//    srcStep           step in source image
//    srcROI            region of interest of source image
//    pDst              resultant image data
//    dstStep           step in destination image
//    dstRoiSize        region of interest of destination image
//    interpolation     type of interpolation to perform for resizing the input image:
//                        IPPI_INTER_NN      Nearest Neighbor interpolation
//                        IPPI_INTER_LINEAR  Linear interpolation
//                        IPPI_INTER_CUBIC   Cubic interpolation
//                        IPPI_INTER_CUBIC2P_CATMULLROM Catmull-Rom cubic filter
//                        IPPI_INTER_LANCZOS Lanczos3 filter
//    pBuffer           pointer to work buffer
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  pSrc == NULL or pDst == NULL or pBuffer == NULL
//    ippStsSizeErr     width of src or dst image is less than two, or
//                      height of src or dst image is less than one
//    ippStsDoubleSize  width of src or dst image doesn't multiple of two (indicates warning)
//    ippStsWrongIntersectROI srcROI has not intersection with the source image, no operation
//    ippStsInterpolationErr  interpolation has an illegal value
//  Note:
//    YUY2 pixel format (Y0U0Y1V0,Y2U1Y3V1,.. or Y0Cb0Y1Cr0,Y2Cb1Y3Cr1,..)
*)

  ippiResizeYCbCr422_8u_C2R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                     Affine Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineBound
//  Purpose:            Computes the bounding rectangle of the transformed image ROI
//  Parameters:
//    srcROI            Source image ROI
//    coeffs            The affine transform matrix
//                        |X'|   |a11 a12| |X| |a13|
//                        |  | = |       |*| |+|   |
//                        |Y'|   |a21 a22| |Y| |a23|
//    bound             Resultant bounding rectangle
//  Returns:
//    ippStsNoErr       OK
*)

  ippiGetAffineBound: function(srcROI:IppiRect;var bound:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineQuad
//  Purpose:            Computes coordinates of the quadrangle to which a source ROI is mapped
//  Parameters:
//    srcROI            Source image ROI
//    coeffs            The affine transform matrix
//                        |X'|   |a11 a12| |X| |a13|
//                        |  | = |       |*| |+|   |
//                        |Y'|   |a21 a22| |Y| |a23|
//    quad              Resultant quadrangle
//  Returns:
//    ippStsNoErr       OK
*)

  ippiGetAffineQuad: function(srcROI:IppiRect;var quad:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineTransform
//  Purpose:            Computes coefficients to transform a source ROI to a given quadrangle
//  Parameters:
//      srcROI          Source image ROI.
//      coeffs          The resultant affine transform matrix
//                        |X'|   |a11 a12| |X| |a13|
//                        |  | = |       |*| |+|   |
//                        |Y'|   |a21 a22| |Y| |a23|
//      quad            Vertex coordinates of the quadrangle
//  Returns:
//    ippStsNoErr       OK
//  Notes: The function computes the coordinates of the 4th vertex of the quadrangle
//         that uniquely depends on the three other (specified) vertices.
//         If the computed coordinates are not equal to the ones specified in quad,
//         the function returns the warning message and continues operation with the computed values
*)

  ippiGetAffineTransform: function(srcROI:IppiRect;var quad:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetAffineSrcRoi
//  Purpose:            Computes the ROI of input image for affine transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    coeffs            The affine transform coefficients
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    dstRoiOffset      Offset of the destination image ROI
//    dstRoiSize        Size of the ROI of destination image
//    srcROI            Pointer to the computed region of interest in the source image
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsSizeErr             Indicates an error in the following cases:
//                               -  if width or height of the source image is negative or equal to 0
//                               -  if width or height of the destination ROI is negative or equal to 0
//    ippStsOutOfRangeErr           Indicates an error if the destination image offset has negative values
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsCoeffErr            Indicates an error condition, if affine transformation is singular.
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed, if the transformed
//                              source image has no intersection with the destination ROI.
*)
  ippiGetAffineSrcRoi: function(srcSize:IppiSize;var coeffs:double;direction:IppiWarpDirection;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoi:PIppiRect):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGetRotateShift
//  Purpose:            Calculates shifts for ippiGetRotateTransform function to rotate an image
//                      around the specified center (xCenter, yCenter)
//  Parameters:
//    xCenter, yCenter  Coordinates of the center of rotation
//    angle             The angle of clockwise rotation, degrees
//    xShift, yShift    Pointers to the shift values
//  Returns:
//    ippStsNoErr       OK
//    ippStsNullPtrErr  One of the pointers to the output data is NULL
*)
  ippiGetRotateShift: function(xCenter:double;yCenter:double;angle:double;xShift:Pdouble;yShift:Pdouble):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:                  ippiGetRotateTransform
//  Purpose:               Computes the affine coefficients for the transform that
//                         rotates an image around (0, 0) by specified angle + shifts it
//                         | cos(angle)  sin(angle)  xShift|
//                         |                               |
//                         |-sin(angle)  cos(angle)  yShift|
//  Parameters:
//    srcROI               Source image ROI
//    angle                The angle of rotation in degrees
//    xShift, yShift       The shift along the corresponding axis
//    coeffs               Output array with the affine transform coefficients
//  Returns:
//    ippStsNoErr          OK
//    ippStsOutOfRangeErr  Indicates an error if the angle is NaN or Infinity
*)

  ippiGetRotateTransform: function(angle:double;xShift:double;yShift:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetPerspectiveBound
//  Purpose:  Computes the bounding rectangle for the transformed image ROI
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   OK
//  Parameters:
//      srcROI  Source image ROI.
//      coeffs  The perspective transform matrix
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//      bound   Output array with vertex coordinates of the bounding rectangle
//  Notes:
*)

  ippiGetPerspectiveBound: function(srcROI:IppiRect;var bound:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetPerspectiveQuad
//  Purpose:    Computes the quadrangle to which the source ROI would be mapped
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr   OK
//  Parameters:
//      srcROI    Source image ROI
//      coeffs    The perspective transform matrix
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//      quadr     Output array with vertex coordinates of the quadrangle
//  Notes:
*)

  ippiGetPerspectiveQuad: function(srcROI:IppiRect;var quad:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetPerspectiveTransform
//  Purpose:  Computes perspective transform matrix to transform the source ROI
//            to the given quadrangle
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   OK
//  Parameters:
//      srcROI   Source image ROI.
//      coeffs   The resultant perspective transform matrix
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//      quad     Vertex coordinates of the quadrangle
//  Notes:
*)

  ippiGetPerspectiveTransform: function(srcROI:IppiRect;var quad:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetBilinearBound
//  Purpose:  Computes the bounding rectangle for the transformed image ROI
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   OK
//  Parameters:
//      srcROI  Source image ROI.
//      coeffs  The bilinear transform matrix
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//      bound   Output array with vertex coordinates of the bounding rectangle
//  Notes:
*)

  ippiGetBilinearBound: function(srcROI:IppiRect;var bound:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetBilinearQuad
//  Purpose:   Computes the quadrangle to which the source ROI would be mapped
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   OK
//  Parameters:
//      srcROI   Source image ROI.
//      coeffs   The bilinear transform matrix
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//      quadr    Output array with vertex coordinates of the quadrangle
//  Notes:
*)

  ippiGetBilinearQuad: function(srcROI:IppiRect;var quad:double;var coeffs:double):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetBilinearTransform
//  Purpose:  Computes bilinear transform matrix to transform the source ROI
//            to the given quadrangle
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr        OK
//  Parameters:
//      srcROI         Source image ROI.
//      coeffs      The resultant bilinear transform matrix
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//      quad        Vertex coordinates of the quadrangle
//  Notes:
*)

  ippiGetBilinearTransform: function(srcROI:IppiRect;var quad:double;var coeffs:double):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpBilinearGetBufferSize
//  Purpose:            Computes the size of external buffer for Bilinear transform
//
//  Context:
//    ippStsNoErr             Indicates no error
//    ippStsNullPtrErr        Indicates an error condition, if one of the specified pointers is NULL
//    ippStsSizeErr           Indicates an error condition, if one of the image dimensions has zero or negative value
//    ippStsWarpDirectionErr  Indicates an error when the direction value is illegal.
//    ippStsCoeffErr          Indicates an error condition, if the bilinear transformation is singular.
//    ippStsInterpolationErr  Indicates an error condition, the interpolation has an illegal value
//    ippStsWrongIntersectROI Indicates a warning that no operation is performed,
//                            if the ROI has no intersection with the source or destination ROI. No operation.
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed, if the transformed
//                              source image has no intersection with the destination image.
//
//  Parameters:
//    srcSize           Size of the source image
//    srcROI            Region of interest in the source image
//    dstROI            Region of interest in the destination image
//    coeffs            The bilinear transform matrix
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    coeffs            The bilinear transform matrix
//    interpolation     The type of interpolation to perform for resampling
//                      the input image. Possible values:
//                          IPPI_INTER_NN       Nearest neighbor interpolation
//                          IPPI_INTER_LINEAR   Linear interpolation
//                          IPPI_INTER_CUBIC    Cubic convolution interpolation
//                          IPPI_SMOOTH_EDGE    Edges smoothing in addition to one of the
//                                              above methods
//    pBufSize          Pointer to the size (in bytes) of the external buffer
*)
  ippiWarpBilinearGetBufferSize: function(srcSize:IppiSize;srcROI:IppiRect;dstROI:IppiRect;direction:IppiWarpDirection;var coeffs:double;interpolation:longint;pBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpBilinear
//  Purpose:  Performs bilinear warping of an image
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//  Context:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      pSrc or pDst is NULL
//    ippStsSizeErr         One of the image dimensions has zero or negative value
//    ippStsStepErr         srcStep or dstStep has a zero or negative value
//    ippStsInterpolateErr  interpolation has an illegal value
//  Parameters:
//      pSrc        Pointer to the source image data (point to pixel (0,0))
//      srcSize     Size of the source image
//      srcStep     Step through the source image
//      srcROI      Region of interest in the source image
//      pDst        Pointer to  the destination image (point to pixel (0,0))
//      dstStep     Step through the destination image
//      dstROI      Region of interest in the destination image
//      coeffs      The bilinear transform matrix
//      interpolation  The type of interpolation to perform for resampling
//                  the input image. Possible values:
//                  IPPI_INTER_NN       Nearest neighbor interpolation
//                  IPPI_INTER_LINEAR   Linear interpolation
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation
//                  IPPI_SMOOTH_EDGE    Edges smoothing in addition to one of the
//                                      above methods
//      pBuffer     Pointer to the external work buffer
//  Notes:
*)

  ippiWarpBilinear_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinear_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpBilinearBack
//  Purpose:  Performs an inverse bilinear warping of an image
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//  Context:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      pSrc or pDst is NULL
//    ippStsSizeErr         One of the image dimensions has zero or negative value
//    ippStsStepErr         srcStep or dstStep has a zero or negative value
//    ippStsInterpolateErr  interpolation has an illegal value
//  Parameters:
//      pSrc        Pointer to the source image data (point to pixel (0,0))
//      srcSize     Size of the source image
//      srcStep     Step through the source image
//      srcROI      Region of interest in the source image
//      pDst        Pointer to  the destination image (point to pixel (0,0))
//      dstStep     Step through the destination image
//      dstROI      Region of interest in the destination image
//      coeffs      The bilinear transform matrix
//      interpolation  The type of interpolation to perform for resampling
//                     the input image. Possible values:
//                  IPPI_INTER_NN       Nearest neighbor interpolation
//                  IPPI_INTER_LINEAR   Linear interpolation
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation
//      pBuffer     Pointer to the external work buffer
//  Notes:
*)

  ippiWarpBilinearBack_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearBack_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiWarpBilinearQuadGetBufferSize
//  Purpose:    Computes the size of external buffer for Bilinear warping of
//              an arbitrary quadrangle in the source image to the quadrangle
//              in the destination image
//
//  Context:
//    ippStsNoErr             Indicates no error
//    ippStsNullPtrErr        Indicates an error condition, if pBufSize is NULL
//    ippStsSizeErr           Indicates an error condition in the following cases:
//                              if one of images ROI x,y has negative value
//                              if one of images ROI dimension has zero or negative value
//    ippStsQuadErr           Indicates an error if either of the given quadrangles is nonconvex
//                            or degenerates into triangle, line, or point.
//    ippStsInterpolateErr    Indicates an error condition, the interpolation has an illegal value.
//
//  Parameters:
//    srcSize     Size of the source image
//    srcROI      Region of interest in the source image
//    srcQuad     A given quadrangle in the source image
//    dstROI      Region of interest in the destination image
//    dstQuad     A given quadrangle in the destination image
//    pBufSize    Pointer to the size (in bytes) of the external buffer
*)

  ippiWarpBilinearQuadGetBufferSize: function(srcSize:IppiSize;srcROI:IppiRect;var srcQuad:double;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpBilinearQuad
//  Purpose:  Performs bilinear warping of an arbitrary quadrangle in the source
//            image to the quadrangle in the destination image
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//  Context:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      pSrc or pDst is NULL
//    ippStsSizeErr         One of the image dimensions has zero or negative value
//    ippStsStepErr         srcStep or dstStep has a zero or negative value
//    ippStsInterpolateErr  interpolation has an illegal value
//  Parameters:
//      pSrc        Pointer to the source image data (point to pixel (0,0))
//      srcSize     Size of the source image
//      srcStep     Step through the source image
//      srcROI      Region of interest in the source image
//      srcQuad     A given quadrangle in the source image
//      pDst        Pointer to  the destination image (point to pixel (0,0))
//      dstStep     Step through the destination image
//      dstROI      Region of interest in the destination image
//      dstQuad     A given quadrangle in the destination image
//      interpolation  The type of interpolation to perform for resampling
//                  the input image. Possible values:
//                  IPPI_INTER_NN       Nearest neighbor interpolation
//                  IPPI_INTER_LINEAR   Linear interpolation
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation
//                  IPPI_SMOOTH_EDGE    Edges smoothing in addition to one of the
//                                      above methods
//      pBuffer     Pointer to the external work buffer
//  Notes:
*)

  ippiWarpBilinearQuad_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ippiWarpBilinearQuad_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                     Warp Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpGetBufferSize
//  Purpose:            Computes the size of external buffer for Warp transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for warp transform
//    dstRoiSize        Size of the output image (in pixels)
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    pBufSize          Pointer to the size (in bytes) of the external buffer
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation     Indicates a warning if width or height of output image is zero
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNumChannelsErr  Indicates an error if numChannels has illegal value
//    ippStsSizeErr         Indicates an error condition in the following cases:
//                          - if width or height of the source image is negative,
//                          - if the calculated buffer size exceeds maximum 32 bit signed integer
//                            positive value (the processed image ROIs are too large ).
//    ippStsSizeWrn         Indicates a warning if the destination image size is more than
//                          the destination image origin size
*)
  ippiWarpGetBufferSize: function(pSpec:PIppiWarpSpec;dstRoiSize:IppiSize;pBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpQuadGetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer
//                      for warping of an arbitrary quadrangle in the source
//                      image to the quadrangle in the destination image
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstQuad           Given quadrangle in the source image
//    dstSize           Size of the output image (in pixels)
//    dstQuad           Given quadrangle in the destination image
//    transform         Warp transform type. Supported values: ippWarpAffine, and ippWarpPerspective.
//    dataType          Data type of the source and destination images. Possible values
//                      are ipp8u, ipp16u, ipp16s, ipp32f and ipp64f.
//    interpolation     Interpolation method. Supported values: ippNearest, ippLinear and ippCubic.
//    border            Type of the border
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr                Indicates no error
//    ippStsNullPtrErr           Indicates an error if one of the specified pointers is NULL
//    ippStsSizeErr              Indicates an error in the following cases:
//                               -  if width or height of the source or destination image is negative,
//                                  or equal to zero
//                               -  if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                  positive value (the size of the one of the processed images is too large).
//    ippStsDataTypeErr          Indicates an error when dataType has an illegal value.
//    ippStsInterpolationErr     Indicates an error if interpolation has an illegal value
//    ippStsNotSupportedModeErr  Indicates an error if the requested mode is not supported.
//    ippStsBorderErr            Indicates an error if border type has an illegal value
//    ippStsQuadErr              Indicates an error if either of the given quadrangles is nonconvex
//                               or degenerates into triangle, line, or point
//    ippStsWarpTransformTypeErr Indicates an error when the transform value is illegal.
//    ippStsWrongIntersectQuad   Indicates a warning that no operation is performed in the following cases:
//                               -  if the transformed source image has no intersection with the destination image.
//                               -  if either of the source quadrangle or destination quadrangle has no intersection
//                                   with the source or destination image correspondingly
//
*)
  ippiWarpQuadGetSize: function(srcSize:IppiSize;var srcQuad:double;dstSize:IppiSize;var dstQuad:double;transform:IppiWarpTransformType;dataType:IppDataType;interpolation:IppiInterpolationType;borderType:IppiBorderType;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpQuadNearestInit
//                      ippiWarpQuadLinearInit
//                      ippiWarpQuadCubicInit
//
//  Purpose:            Initializes the Spec structure for warping of
//                      an arbitrary quadrangle in the source image to the quadrangle
//                      in the destination image
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    srcQuad           Given quadrangle in the source image
//    dstSize           Size of the output image (in pixels)
//    dstQuad           Given quadrangle in the destination image
//    transform         Warp transform type. Supported values: ippWarpAffine, and ippWarpPerspective.
//    dataType          Data type of the source and destination images. Possible values
//                      are ipp8u, ipp16u, ipp16s, ipp32f and ipp64f.
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    smoothEdge        The smooth edge flag. Supported values:
//                          0 - transform without edge smoothing
//                          1 - transform with edge smoothing
//    pSpec             Pointer to the Spec structure for resize filter
//    pInitBuf          Pointer to the temporal buffer for several initialization cases
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsSizeErr             Indicates an error if width or height of the source or destination
//                              image is negative, or equal to zero
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpTransformErr    Indicates an error when the transform value is illegal.
//    ippStsNumChannelsErr      Indicates an error if numChannels has illegal value
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsQuadErr             Indicates an error if either of the given quadrangles is nonconvex
//                               or degenerates into triangle, line, or point
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed, if the transformed
//                              source image has no intersection with the destination image.
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C); / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Supported border types are ippBorderTransp and ippBorderInMem
*)
  ippiWarpQuadNearestInit: function(srcSize:IppiSize;var srcQuad:double;dstSize:IppiSize;var dstQuad:double;transform:IppiWarpTransformType;dataType:IppDataType;numChannels:longint;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec):IppStatus;

  ippiWarpQuadLinearInit: function(srcSize:IppiSize;var srcQuad:double;dstSize:IppiSize;var dstQuad:double;transform:IppiWarpTransformType;dataType:IppDataType;numChannels:longint;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec):IppStatus;

  ippiWarpQuadCubicInit: function(srcSize:IppiSize;var srcQuad:double;dstSize:IppiSize;var dstQuad:double;transform:IppiWarpTransformType;dataType:IppDataType;numChannels:longint;valueB:Ipp64f;valueC:Ipp64f;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec;pInitBuf:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                     Warp Affine Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpAffineGetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer for Affine transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    dataType          Data type of the source and destination images. Possible values
//                      are ipp8u, ipp16u, ipp16s, ipp32f and ipp64f.
//    coeffs            The affine transform coefficients
//    interpolation     Interpolation method. Supported values: ippNearest, ippLinear and ippCubic.
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    border            Type of the border
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if width or height of the source or destination image is negative,
//                              -  if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                 positive value (the size of the one of the processed images is too large).
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//    ippStsCoeffErr            Indicates an error condition, if affine transformation is singular.
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//
*)
  ippiWarpAffineGetSize: function(srcSize:IppiSize;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;interpolation:IppiInterpolationType;direction:IppiWarpDirection;borderType:IppiBorderType;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpAffineNearestInit
//                      ippiWarpAffineLinearInit
//                      ippiWarpAffineCubicInit
//
//  Purpose:            Initializes the Spec structure for the Warp affine transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    dataType          Data type of the source and destination images. Possible values are:
//                      ipp8u, ipp16u, ipp16s, ipp32f, ipp64f.
//    coeffs            The affine transform coefficients
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    smoothEdge        The smooth edge flag. Supported values:
//                          0 - transform without edge smoothing
//                          1 - transform with edge smoothing
//    pSpec             Pointer to the Spec structure for resize filter
//    pInitBuf          Pointer to the temporal buffer for several initialization cases
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error if width or height of the source or destination
//                              image is negative
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsCoeffErr            Indicates an error condition, if the affine transformation is singular.
//    ippStsNumChannelsErr      Indicates an error if numChannels has illegal value
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed, if the transformed
//                              source image has no intersection with the destination image.
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C); / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Supported border types are ippBorderRepl, ippBorderConst, ippBorderTransp and ippBorderInMem
*)
  ippiWarpAffineNearestInit: function(srcSize:IppiSize;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;direction:IppiWarpDirection;numChannels:longint;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec):IppStatus;
  ippiWarpAffineLinearInit: function(srcSize:IppiSize;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;direction:IppiWarpDirection;numChannels:longint;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec):IppStatus;
  ippiWarpAffineCubicInit: function(srcSize:IppiSize;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;direction:IppiWarpDirection;numChannels:longint;valueB:Ipp64f;valueC:Ipp64f;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec;pInitBuf:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpAffineNearest
//                      ippiWarpAffineLinear
//                      ippiWarpAffineCubic
//
//  Purpose:            Performs affine transform of an image with using different interpolation methods
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstRoiOffset      Offset of tiled image respectively destination image origin
//    dstRoiSize        Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of output image is zero
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//    ippStsSizeErr             Indicates an error if width or height of the destination image
//                              is negative
//    ippStsStepErr             Indicates an error if the step value is not data type multiple
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside the
//                              destination image origin
//    ippStsSizeWrn             Indicates a warning if the destination image size is more than
//                              the destination image origin size
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed if the destination
//                              ROI has no intersection with the transformed source image origin.
//
//  Notes:
//    1. Supported border types are ippBorderRepl, ippBorderConst, ippBorderTransp and ippBorderRepl
*)
  ippiWarpAffineNearest_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_64f_C3R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineNearest_64f_C4R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;

  ippiWarpAffineLinear_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_64f_C3R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineLinear_64f_C4R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;

  ippiWarpAffineCubic_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_64f_C3R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpAffineCubic_64f_C4R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                     Warp Perspective Transform functions
// ////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpGetRectInfinite
//  Purpose:            Returns the constant value ippRectInfinite
//
//                      ippRectInfinite = {IPP_MIN_32S/2, IPP_MIN_32S/2,
//                                         IPP_MAX_32S,   IPP_MAX_32S};
//
//  Return Values:
//    ippRectInfinite constant value of IppiRect type
//
*)
  ippiWarpGetRectInfinite: function:IppiRect;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpPerspectiveGetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer
//                      for Perspective transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    srcRoi            Region of interest in the source image
//    dstSize           Size of the output image (in pixels)
//    dataType          Data type of the source and destination images. Possible values
//                      are ipp8u, ipp16u, ipp16s, ipp32f and ipp64f.
//    coeffs            The perspective transform coefficients
//    interpolation     Interpolation method. Supported values: ippNearest, ippLinear and ippCubic.
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    border            Type of the border
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if width or height of the source or destination image is negative,
//                              -  if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                 positive value (the size of the one of the processed images is too large).
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//    ippStsCoeffErr            Indicates an error condition, if perspective transformation is singular.
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//
*)
  ippiWarpPerspectiveGetSize: function(srcSize:IppiSize;srcRoi:IppiRect;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;interpolation:IppiInterpolationType;direction:IppiWarpDirection;borderType:IppiBorderType;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpPerspectiveNearestInit
//                      ippiWarpPerspectiveLinearInit
//                      ippiWarpPerspectiveCubicInit
//
//  Purpose:            Initializes the Spec structure for the Warp perspective transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    srcRoi            Region of interest in the source image
//    dstSize           Size of the output image (in pixels)
//    dataType          Data type of the source and destination images. Possible values are:
//                      ipp8u, ipp16u, ipp16s, ipp32f, ipp64f.
//    coeffs            The perspective transform coefficients
//    direction         Transformation direction. Possible values are:
//                          ippWarpForward  - Forward transformation.
//                          ippWarpBackward - Backward transformation.
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    smoothEdge        The smooth edge flag. Supported values:
//                          0 - transform without edge smoothing
//                          1 - transform with edge smoothing
//    pSpec             Pointer to the Spec structure for resize filter
//    pInitBuf          Pointer to the temporal buffer for several initialization cases
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error if width or height of the source or destination
//                              image is negative
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsWarpDirectionErr    Indicates an error when the direction value is illegal.
//    ippStsCoeffErr            Indicates an error condition, if the perspective transformation is singular.
//    ippStsNumChannelsErr      Indicates an error if numChannels has illegal value
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed, if the transformed
//                              source image has no intersection with the destination image.
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C); / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Supported border types are ippBorderRepl, ippBorderConst, ippBorderTransp and ippBorderRepl
*)
  ippiWarpPerspectiveNearestInit: function(srcSize:IppiSize;srcRoi:IppiRect;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;direction:IppiWarpDirection;numChannels:longint;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec):IppStatus;
  ippiWarpPerspectiveLinearInit: function(srcSize:IppiSize;srcRoi:IppiRect;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;direction:IppiWarpDirection;numChannels:longint;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec):IppStatus;
  ippiWarpPerspectiveCubicInit: function(srcSize:IppiSize;srcRoi:IppiRect;dstSize:IppiSize;dataType:IppDataType;var coeffs:double;direction:IppiWarpDirection;numChannels:longint;valueB:Ipp64f;valueC:Ipp64f;borderType:IppiBorderType;pBorderValue:PIpp64f;smoothEdge:longint;pSpec:PIppiWarpSpec;pInitBuf:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiWarpPerspectiveNearest
//                      ippiWarpPerspectiveLinear
//                      ippiWarpPerspectiveCubic
//
//  Purpose:            Performs perspective transform of an image with using
//                      different interpolation methods
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstRoiOffset      Offset of tiled image respectively destination image origin
//    dstRoiSize        Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of output image is zero
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//    ippStsSizeErr             Indicates an error if width or height of the destination image
//                              is negative
//    ippStsStepErr             Indicates an error if the step value is not data type multiple
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside the
//                              destination image origin
//    ippStsSizeWrn             Indicates a warning if the destination image size is more than
//                              the destination image origin size
//    ippStsWrongIntersectQuad  Indicates a warning that no operation is performed if the destination
//                              ROI has no intersection with the transformed source image origin.
//
//  Notes:
//    1. Supported border types are ippBorderRepl, ippBorderConst, ippBorderTransp and ippBorderRepl
*)
  ippiWarpPerspectiveNearest_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveNearest_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;

  ippiWarpPerspectiveLinear_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveLinear_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;

  ippiWarpPerspectiveCubic_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;
  ippiWarpPerspectiveCubic_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;pSpec:PIppiWarpSpec;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                   Statistic functions
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiMomentGetStateSize_64s
//             ippiMomentGetStateSize_64f
//
//  Purpose:   Computes the size of the external buffer for the state
//             structure ippiMomentsState_64s in bytes
//
//  Returns:
//    ippStsNoErr         OK
//    ippStsNullPtrErr    pSize==NULL
//  Parameters:
//    hint                Option to specify the computation algorithm
//    pSize               Pointer to the value of the buffer size
//                        of the structure ippiMomentState_64s.
*)
  ippiMomentGetStateSize_64f: function(hint:IppHintAlgorithm;pSize:Plongint):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMomentInit64s
//                  ippiMomentInit64f
//
//  Purpose:        Initializes ippiMomentState_64s structure (without memory allocation)
//
//  Returns:
//    ippStsNoErr   No errors
//
//  Parameters:
//    pState        Pointer to the MomentState structure
//    hint          Option to specify the computation algorithm
*)
  ippiMomentInit_64f: function(pState:PIppiMomentState_64f;hint:IppHintAlgorithm):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiMoments
//
//  Purpose:   Computes statistical moments of an image
//
//  Returns:
//    ippStsContextMatchErr   pState->idCtx != idCtxMoment
//    ippStsNullPtrErr        (pSrc == NULL) or (pState == NULL)
//    ippStsStepErr           pSrcStep <0
//    ippStsSizeErr           (roiSize.width  <1) or (roiSize.height <1)
//    ippStsNoErr             No errors
//
//  Parameters:
//    pSrc     Pointer to the source image
//    srcStep  Step in bytes through the source image
//    roiSize  Size of the source ROI
//    pState   Pointer to the MomentState structure
//
//  Notes:
//    These functions compute moments of order 0 to 3 only
//
*)
  ippiMoments64f_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;
  ippiMoments64f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;
  ippiMoments64f_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;

  ippiMoments64f_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;
  ippiMoments64f_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;
  ippiMoments64f_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;

  ippiMoments64f_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;
  ippiMoments64f_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;
  ippiMoments64f_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiGetSpatialMoment()
//             ippiGetCentralMoment()
//
//  Purpose:   Retrieves the value of the image spatial/central moment.
//
//  Returns:
//    ippStsNullPtrErr      (pState == NULL) or (pValue == NULL)
//    ippStsContextMatchErr pState->idCtx != idCtxMoment
//    ippStsSizeErr         (mOrd+nOrd) >3 or
//                          (nChannel<0) or (nChannel>=pState->nChannelInUse)
//    ippStsNoErr           No errors
//
//  Parameters:
//    pState      Pointer to the MomentState structure
//    mOrd        m- Order (X direction)
//    nOrd        n- Order (Y direction)
//    nChannel    Channel number
//    roiOffset   Offset of the ROI origin (ippiGetSpatialMoment ONLY!)
//    pValue      Pointer to the retrieved moment value
//    scaleFactor Factor to scale the moment value (for integer data)
//
//  NOTE:
//    ippiGetSpatialMoment uses Absolute Coordinates (left-top image has 0,0).
//
*)
  ippiGetSpatialMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;roiOffset:IppiPoint;pValue:PIpp64f):IppStatus;
  ippiGetCentralMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;pValue:PIpp64f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiGetNormalizedSpatialMoment()
//             ippiGetNormalizedCentralMoment()
//
//  Purpose:   Retrieves the normalized value of the image spatial/central moment.
//
//  Returns:
//    ippStsNullPtrErr      (pState == NULL) or (pValue == NULL)
//    ippStsContextMatchErr pState->idCtx != idCtxMoment
//    ippStsSizeErr         (mOrd+nOrd) >3 or
//                          (nChannel<0) or (nChannel>=pState->nChannelInUse)
//    ippStsMoment00ZeroErr mm[0][0] < IPP_EPS52
//    ippStsNoErr           No errors
//
//  Parameters:
//    pState      Pointer to the MomentState structure
//    mOrd        m- Order (X direction)
//    nOrd        n- Order (Y direction)
//    nChannel    Channel number
//    roiOffset   Offset of the ROI origin (ippiGetSpatialMoment ONLY!)
//    pValue      Pointer to the normalized moment value
//    scaleFactor Factor to scale the moment value (for integer data)
//
*)
  ippiGetNormalizedSpatialMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;roiOffset:IppiPoint;pValue:PIpp64f):IppStatus;
  ippiGetNormalizedCentralMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;pValue:PIpp64f):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiGetHuMoments()
//
//  Purpose:   Retrieves image Hu moment invariants.
//
//  Returns:
//    ippStsNullPtrErr      (pState == NULL) or (pHu == NULL)
//    ippStsContextMatchErr pState->idCtx != idCtxMoment
//    ippStsSizeErr         (nChannel<0) or (nChannel>=pState->nChannelInUse)
//    ippStsMoment00ZeroErr mm[0][0] < IPP_EPS52
//    ippStsNoErr           No errors
//
//  Parameters:
//    pState      Pointer to the MomentState structure
//    nChannel    Channel number
//    pHm         Pointer to the array of the Hu moment invariants
//    scaleFactor Factor to scale the moment value (for integer data)
//
//  Notes:
//    We consider Hu moments up to the 7-th order only
*)
  ippiGetHuMoments_64f: function(pState:PIppiMomentState_64f;nChannel:longint;pHm:IppiHuMoment_64f):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNorm_Inf
//  Purpose:        computes the C-norm of pixel values of the image: n = MAX |src1|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step through the source image
//    roiSize     Size of the source ROI.
//    pValue      Pointer to the computed norm (one-channel data)
//    value       Array of the computed norms for each channel (multi-channel data)
//  Notes:
*)

  ippiNorm_Inf_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_Inf_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_Inf_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_Inf_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_Inf_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_Inf_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNorm_L1
//  Purpose:        computes the L1-norm of pixel values of the image: n = SUM |src1|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step through the source image
//    roiSize     Size of the source ROI.
//    pValue      Pointer to the computed norm (one-channel data)
//    value       Array of the computed norms for each channel (multi-channel data)
//    hint        Option to specify the computation algorithm
//  Notes:
*)

  ippiNorm_L1_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_L1_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L1_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L1_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_L1_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L1_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L1_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_L1_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L1_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L1_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNorm_L1_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNorm_L1_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNorm_L2
//  Purpose:        computes the L2-norm of pixel values of the image: n = SQRT(SUM |src1|^2)
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step through the source image
//    roiSize     Size of the source ROI.
//    pValue      Pointer to the computed norm (one-channel data)
//    value       Array of the computed norms for each channel (multi-channel data)
//    hint        Option to specify the computation algorithm
//  Notes:
//    simple mul is better than table for P6 family
*)

  ippiNorm_L2_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_L2_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L2_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L2_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_L2_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L2_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L2_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNorm_L2_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L2_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNorm_L2_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNorm_L2_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNorm_L2_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormDiff_Inf
//  Purpose:        computes the C-norm of pixel values of two images: n = MAX |src1 - src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         OK
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//  Notes:
*)

  ippiNormDiff_Inf_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_Inf_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_Inf_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_Inf_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_Inf_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_Inf_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormDiff_L1
//  Purpose:        computes the L1-norm of pixel values of two images: n = SUM |src1 - src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         OK
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//    hint                Option to specify the computation algorithm
//  Notes:
*)

  ippiNormDiff_L1_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_L1_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L1_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L1_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_L1_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L1_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L1_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_L1_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L1_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L1_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormDiff_L1_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormDiff_L1_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormDiff_L2
//  Purpose:        computes the L2-norm of pixel values of two images:
//                    n = SQRT(SUM |src1 - src2|^2)
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         OK
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//    hint                Option to specify the computation algorithm
//  Notes:
*)

  ippiNormDiff_L2_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_L2_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L2_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L2_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_L2_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L2_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L2_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormDiff_L2_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L2_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormDiff_L2_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormDiff_L2_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormDiff_L2_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* //////////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormRel_Inf
//  Purpose:        computes the relative error for the C-norm of pixel values of two images:
//                      n = MAX |src1 - src2| / MAX |src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         OK
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//    ippStsDivByZero     MAX |src2| == 0
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//  Notes:
*)

  ippiNormRel_Inf_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_Inf_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_Inf_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_Inf_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_Inf_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_Inf_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormRel_L1
//  Purpose:        computes the relative error for the 1-norm of pixel values of two images:
//                      n = SUM |src1 - src2| / SUM |src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         OK
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//    ippStsDivByZero     SUM |src2| == 0
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//    hint                Option to specify the computation algorithm
//  Notes:
*)

  ippiNormRel_L1_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_L1_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L1_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L1_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_L1_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L1_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L1_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_L1_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L1_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L1_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormRel_L1_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormRel_L1_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* //////////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormRel_L2
//  Purpose:        computes the relative error for the L2-norm of pixel values of two images:
//                      n = SQRT(SUM |src1 - src2|^2 / SUM |src2|^2)
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         OK
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//    ippStsDivByZero     SUM |src2|^2 == 0
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//    hint                Option to specify the computation algorithm
//  Notes:
*)

  ippiNormRel_L2_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_L2_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L2_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L2_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_L2_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L2_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L2_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;

  ippiNormRel_L2_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L2_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;

  ippiNormRel_L2_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormRel_L2_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiNormRel_L2_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiSum
//  Purpose:        computes the sum of image pixel values
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pSum        Pointer to the result (one-channel data)
//    sum         Array containing the results (multi-channel data)
//    hint        Option to select the algorithmic implementation of the function
//  Notes:
*)

  ippiSum_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f):IppStatus;

  ippiSum_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;

  ippiSum_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;

  ippiSum_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f):IppStatus;

  ippiSum_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;

  ippiSum_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;

  ippiSum_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f):IppStatus;

  ippiSum_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;

  ippiSum_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;

  ippiSum_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiSum_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiSum_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f;hint:IppHintAlgorithm):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMean
//  Purpose:        computes the mean of image pixel values
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value.
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source ROI.
//    pMean       Pointer to the result (one-channel data)
//    mean        Array containing the results (multi-channel data)
//    hint        Option to select the algorithmic implementation of the function
//  Notes:
*)

  ippiMean_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f):IppStatus;

  ippiMean_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;

  ippiMean_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;

  ippiMean_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f):IppStatus;

  ippiMean_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;

  ippiMean_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;

  ippiMean_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f):IppStatus;

  ippiMean_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;

  ippiMean_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;

  ippiMean_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f;hint:IppHintAlgorithm):IppStatus;

  ippiMean_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f;hint:IppHintAlgorithm):IppStatus;

  ippiMean_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f;hint:IppHintAlgorithm):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:   ippiQualityIndex
//
//  Purpose: ippiQualityIndex() function calculates the Universal Image Quality
//           Index. Instead of traditional error summation methods, the
//           proposed index is designed by modeling any image distortion as a
//           combination of three factors: loss of correlation, luminance
//           distortion, and contrast distortion. The dynamic range of the index
//           is [-1.0, 1.0].
//
//  Parameters:
//    pSrc1          - Pointer to the first source image ROI.
//    src1Step       - Distance, in bytes, between the starting points of consecutive lines in the first source image.
//    pSrc2          - Pointer to the second source image ROI.
//    src2Step       - Distance, in bytes, between the starting points of consecutive lines in the second source image.
//    roiSize        - Size, in pixels, of the 1st and 2nd source images.
//    pQualityIndex  - Pointer where to store the calculated Universal Image Quality Index.
//    pBuffer        - Pointer to the buffer for internal calculations. Size of the buffer is calculated by ippiQualityIndexGetBufferSize.
//
//  Returns:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when the roiSize has a zero or negative value.
//    ippStsStepErr     - Error when the src1Step or src2Step is less than or equal to zero.
*)
  ippiQualityIndex_8u32f_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiQualityIndex_8u32f_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiQualityIndex_8u32f_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiQualityIndex_16u32f_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiQualityIndex_16u32f_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiQualityIndex_16u32f_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiQualityIndex_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiQualityIndex_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiQualityIndex_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:     ippiQualityIndexGetBufferSize
//  Purpose:   Get the size (in bytes) of the buffer for ippiQualityIndex.
//  Parameters:
//    srcType     - Intel(R) IPP data type name of the source images. Possible values are ipp8u, ipp16u or ipp32f.
//    ippChan     - Intel(R) IPP channels name of of the source images. Possible values are ippC1, ippC3 or ippAC4.
//    roiSize     - Size, in pixels, of the source images.
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//  Return:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when any of the specified pointers is NULL.
//    ippStsSizeErr     - Error when the roiSize has a zero or negative value.
//    ippStsDataTypeErr - Error when the srcType has an illegal value.
//    ippStsChannelErr  - Error when the ippChan has an illegal value.
*)
  ippiQualityIndexGetBufferSize: function(srcType:IppDataType;ippChan:IppChannels;roiSize:IppiSize;pBufferSize:Plongint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:     ippiHistogramGetBufferSize
//  Purpose:   Get the sizes (in bytes) of the spec and the buffer for ippiHistogram_.
//  Parameters:
//    dataType    - Data type for source image. Possible values are ipp8u, ipp16u, ipp16s or ipp32f.
//    roiSize     - Size, in pixels, of the source image.
//    nLevels     - Number of levels values, separate for each channel.
//    numChannels - Number of image channels. Possible values are 1, 3, or 4.
//    uniform     - Type of levels distribution: 0 - with random step, 1 - with uniform step.
//    pSpecSize   - Pointer to the calculated spec size (in bytes).
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//  Return:
//    ippStsNoErr             - OK.
//    ippStsNullPtrErr        - Error when any of the specified pointers is NULL.
//    ippStsSizeErr           - Error when the roiSize has a zero or negative value.
//    ippStsHistoNofLevelsErr - Error when the number of levels is less than 2.
//    ippStsNumChannelsErr    - Error when the numChannels value differs from 1, 3, or 4.
//    ippStsDataTypeErr       - Error when the dataType value differs from the ipp8u, ipp16u, ipp16s or ipp32f.
*)
  ippiHistogramGetBufferSize: function(dataType:IppDataType;roiSize:IppiSize;var nLevels:longint;numChannels:longint;uniform:longint;pSpecSize:Plongint;pBufferSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:     ippiHistogramInit, ippiHistogramUniformInit
//  Purpose:   Initializes the Spec for ippiHistogram.
//  Parameters:
//    dataType    - Data type for source image. Possible values are ipp8u, ipp16u, ipp16s or ipp32f.
//    pLevels     - Pointer to the array of level values. In case of multi-channel data, pLevels is an array of pointers to the level values array for each channel.
//    lowerLevel  - The lower levels for uniform histogram, separate for each channel.
//    upperLevel  - The upper levels for uniform histogram, separate for each channel.
//    nLevels     - Number of levels values, separate for each channel.
//    numChannels - Number of image channels. Possible values are 1, 3, or 4.
//    pSpec       - Pointer to the spec object.
//  Return:
//    ippStsNoErr             - OK.
//    ippStsNullPtrErr        - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr    - Error when the numChannels value differs from 1, 3, or 4.
//    ippStsHistoNofLevelsErr - Error when the number of levels is less than 2.
//    ippStsRangeErr          - Error when consecutive pLevels values don't satisfy the condition: pLevel[i] < pLevel[i+1].
//    ippStsDataTypeErr       - Error when the dataType value differs from the ipp8u, ipp16u, ipp16s or ipp32f.
//    ippStsSizeWrn           - Warning ( in case of uniform histogram of integer data type) when rated level step is less than 1.
*)
  ippiHistogramInit: function(dataType:IppDataType;var pLevels:PIpp32f;var nLevels:longint;numChannels:longint;pSpec:PIppiHistogramSpec):IppStatus;
  ippiHistogramUniformInit: function(dataType:IppDataType;var lowerLevel:Ipp32f;var upperLevel:Ipp32f;var nLevels:longint;numChannels:longint;pSpec:PIppiHistogramSpec):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiHistogramGetLevels
//  Purpose:   Returns levels arrays stored in the pSpec object.
//  Parameters:
//    pSpec       - Pointer to the spec object.
//    pLevels     - Pointer to the array of level values. In case of multi-channel data, pLevels is an array of pointers to the level values array for each channel.
//  Return:
//    ippStsNoErr             - OK.
//    ippStsNullPtrErr        - Error when any of the specified pointers is NULL.
//    ippStsBadArgErr         - Error when pSpec object doesn`t initialized.
*)
  ippiHistogramGetLevels: function(pSpec:PIppiHistogramSpec;var pLevels:PIpp32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:         ippiHistogram
//  Purpose:      Computes the intensity histogram of an image.
//  Parameters:
//    pSrc        - Pointer to the source image ROI.
//    srcStep     - Distance, in bytes, between the starting points of consecutive lines in the source image.
//    roiSize     - Size, in pixels, of the source image.
//    pHist       - Pointer to the computed histogram. In case of multi-channel data, pHist is an array of pointers to the histogram for each channel.
//    pSpec       - Pointer to the spec.
//    pBuffer     - Pointer to the buffer for internal calculations.
//  Returns:
//    ippStsNoErr             - OK.
//    ippStsNullPtrErr        - Error when any of the specified pointers is NULL.
//    ippStsSizeErr           - Error when the roiSize has a zero or negative value.
//    ippStsStepErr           - Error when the srcStep is less than roiSize.width*sizeof(*pSrc)*nChannels.
//    ippStsBadArgErr         - Error when pSpec object doesn`t initialized.
*)
  ippiHistogram_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;
  ippiHistogram_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32u;pSpec:PIppiHistogramSpec;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Name:          ippiLUT
// Purpose:       Performs intensity transformation of an image
//                using lookup table (LUT) without interpolation or
//                using lookup table (LUT) with linear interpolation or
//                using lookup table (LUT) with cubic interpolation
//  Parameters:
//    pSrc        - Pointer to the source image.
//    srcStep     - Distances, in bytes, between the starting points of consecutive lines in the source images.
//    pDst        - Pointer to the destination image.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    pSrcDst     - Pointer to the source/destination image (inplace case).
//    srcDstStep  - Distance, in bytes, between the starting points of consecutive lines in the source/destination image (inplace case).
//    roiSize     - Size, in pixels, of the ROI.
//    pSpec       - Pointer to the LUT spec structure.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when roiSize has a field with value less than 1.
//    ippStsStepErr    - Error when srcStep, dstStep  or srcDstStep has a zero or negative value.
//    ippStsBadArgErr  - Error when pSpec initialized incorect.
*)
  ippiLUT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;

  ippiLUT_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pSpec:PIppiLUT_Spec):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Name:          ippiLUT_GetSize
// Purpose:       Gets the size (in bytes) of the spec buffer for ippiLUT.
//  Parameters:
//    interp         - Interpolation type (ippCubic or ippLinear or ippNearest).
//    dataType       - Intel(R) IPP data type name of the images. Possible values are ipp8u, ipp16u, ipp16s or ipp32f.
//    numChannels    - Intel(R) IPP channels name of of the images. Possible values are ippC1, ippC3, ippC4 or ippAC4.
//    roiSize        - Size, in pixels, of the destination ROI.
//    nLevels        - Number of levels, separate for each channel.
//    pSpecSize      - Pointer to the calculated spec size (in bytes).
//  Returns:
//    ippStsNoErr            - OK.
//    ippStsNullPtrErr       - Error when any of the specified pointers is NULL.
//    ippStsSizeErr          - Error when roiSize has a field with value less than 1.
//    ippStsDataTypeErr      - Error when the srcType has an illegal value.
//    ippStsChannelErr       - Error when the ippChan has an illegal value.
//    ippStsInterpolationErr - Error when the interpolationType has an illegal value.
*)
  ippiLUT_GetSize: function(interp:IppiInterpolationType;dataType:IppDataType;ippChan:IppChannels;roiSize:IppiSize;var nLevels:longint;pSpecSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name:          ippiLUT_Init
// Purpose:       Initializes the spec for ippiLUT.
//  Parameters:
//    interp         - Interpolation type (ippCubic or ippLinear or ippNearest).
//    numChannels    - Intel(R) IPP channels name of of the images. Possible values are ippC1, ippC3, ippC4 or ippAC4.
//    roiSize        - Size, in pixels, of the destination ROI.
//    pValues        - Ppointer to the array of intensity values, separate for each channel.
//    pLevels        - Pointer to the array of level values, separate for each channel.
//    nLevels        - Number of levels, separate for each channel.
//    pSpec          - Pointer to the LUT spec structure.
//  Returns:
//    ippStsNoErr            - OK.
//    ippStsNullPtrErr       - Error when any of the specified pointers is NULL.
//    ippStsSizeErr          - Error when roiSize has a field with value less than 1.
//    ippStsChannelErr       - Error when the ippChan has an illegal value.
//    ippStsLUTNofLevelsErr  - Error when the number of levels is less 2.
//    ippStsInterpolationErr - Error when the interpolationType has an illegal value.
*)
  ippiLUT_Init_8u: function(interp:IppiInterpolationType;ippChan:IppChannels;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_Init_16u: function(interp:IppiInterpolationType;ippChan:IppChannels;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_Init_16s: function(interp:IppiInterpolationType;ippChan:IppChannels;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;pSpec:PIppiLUT_Spec):IppStatus;
  ippiLUT_Init_32f: function(interp:IppiInterpolationType;ippChan:IppChannels;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint;pSpec:PIppiLUT_Spec):IppStatus;



(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippiLUTPalette
//  Purpose:     intensity transformation of image using the palette lookup table pTable
//  Parameters:
//    pSrc       pointer to the source image
//    srcStep    line offset in input data in bytes
//    alphaValue constant alpha channel
//    pDst       pointer to the destination image
//    dstStep    line offset in output data in bytes
//    roiSize    size of source ROI in pixels
//    pTable     pointer to palette table of size 2^nBitSize or
//               array of pointers to each channel
//    nBitSize   number of valid bits in the source image
//               (range [1,8] for 8u source images and range [1,16] for 16u source images)
//  Returns:
//    ippStsNoErr         no errors
//    ippStsNullPtrErr    pSrc == NULL or pDst == NULL or pTable == NULL
//    ippStsSizeErr       width or height of ROI is less or equal zero
//    ippStsOutOfRangeErr nBitSize is out of range
//  Notes:
*)
  ippiLUTPalette_16u32u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32u;dstStep:longint;roiSize:IppiSize;pTable:PIpp32u;nBitSize:longint):IppStatus;
  ippiLUTPalette_16u24u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_8u32u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32u;dstStep:longint;roiSize:IppiSize;pTable:PIpp32u;nBitSize:longint):IppStatus;
  ippiLUTPalette_8u24u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pTable:PIpp16u;nBitSize:longint):IppStatus;
  ippiLUTPalette_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var pTable:PIpp16u;nBitSize:longint):IppStatus;
  ippiLUTPalette_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var pTable:PIpp16u;nBitSize:longint):IppStatus;
  ippiLUTPalette_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pTable:PIpp8u;nBitSize:longint):IppStatus;
  ippiLUTPalette_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var pTable:PIpp16u;nBitSize:longint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:                ippiCountInRange
//
//  Purpose:  Computes the number of pixels with intensity values within the given range
//
//  Returns:             IppStatus
//      ippStsNoErr       No errors
//      ippStsNullPtrErr  pSrc == NULL
//      ippStsStepErr     srcStep is less than or equal to zero
//      ippStsSizeErr     roiSize has a field with zero or negative value
//      ippStsRangeErr    lowerBound is greater than upperBound
//
//  Parameters:
//      pSrc             Pointer to the source buffer
//      roiSize          Size of the source ROI
//      srcStep          Step through the source image buffer
//      counts           Number of pixels within the given intensity range
//      lowerBound       Lower limit of the range
//      upperBound       Upper limit of the range
*)

  ippiCountInRange_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;counts:Plongint;lowerBound:Ipp8u;upperBound:Ipp8u):IppStatus;
  ippiCountInRange_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp8u;var upperBound:Ipp8u):IppStatus;
  ippiCountInRange_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp8u;var upperBound:Ipp8u):IppStatus;
  ippiCountInRange_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;counts:Plongint;lowerBound:Ipp32f;upperBound:Ipp32f):IppStatus;
  ippiCountInRange_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp32f;var upperBound:Ipp32f):IppStatus;
  ippiCountInRange_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp32f;var upperBound:Ipp32f):IppStatus;


(* ///////////////////////////////////////////////////////////////////////////
//             Non-linear Filters
/////////////////////////////////////////////////////////////////////////// *)



(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianGetBufferSize_32f

//  Purpose:  Get size of internal buffer for median filter
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  bufferSize is NULL
//   ippStsSizeErr     dstRoiSize has a field with zero or negative value
//   ippStsMaskSizeErr maskSize has a field with zero, negative, or even value
//   ippStsNumChannelsErr number of channels is not 3 or 4
//  Parameters:
//   dstRoiSize   Size of the destination ROI
//   maskSize     Size of the mask in pixels
//   nChannels     Number of channels
//   bufferSize  reference to size buffer
*)
  ippiFilterMedianGetBufferSize_32f: function(dstRoiSize:IppiSize;maskSize:IppiSize;nChannels:Ipp32u;bufferSize:PIpp32u):IppStatus;
  ippiFilterMedianGetBufferSize_64f: function(dstRoiSize:IppiSize;maskSize:IppiSize;nChannels:Ipp32u;bufferSize:PIpp32u):IppStatus;
(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedian_32f_C3R
//              ippiFilterMedian_32f_C4R
//              ippiFilterMedian_64f_C1R

//  Purpose:  Filters an image using a box median filter
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  pSrc or pDst is NULL
//   ippStsSizeErr     dstRoiSize has a field with zero or negative value
//   ippStsStepErr     srcStep or dstStep has zero or negative value
//   ippStsMaskSizeErr maskSize has a field with zero, negative, or even value
//   ippStsAnchorErr   anchor is outside the mask
//
//  Parameters:
//   pSrc        Pointer to the source image
//   srcStep     Step through the source image
//   pDst        Pointer to the destination image
//   dstStep     Step through the destination image
//   dstRoiSize  Size of the destination ROI
//   maskSize    Size of the mask in pixels
//   anchor      Anchor cell specifying the mask alignment with respect to
//               the position of input pixel
*)

  ippiFilterMedian_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedian_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedian_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;pBuffer:PIpp8u):IppStatus;
(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianCross_8u_C1R
//              ippiFilterMedianCross_8u_C3R
//              ippiFilterMedianCross_8u_AC4R
//              ippiFilterMedianCross_16s_C1R
//              ippiFilterMedianCross_16s_C3R
//              ippiFilterMedianCross_16s_AC4R
//              ippiFilterMedianCross_16u_C1R
//              ippiFilterMedianCross_16u_C3R
//              ippiFilterMedianCross_16u_AC4R
//  Purpose:  Filters an image using a cross median filter
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  pSrc or pDst is NULL
//   ippStsSizeErr     dstRoiSize has a field with zero or negative value
//   ippStsStepErr     srcStep or dstStep has zero or negative value
//   ippStsMaskSizeErr Illegal value of mask
//
//  Parameters:
//   pSrc        Pointer to the source image
//   srcStep     Step through the source image
//   pDst        Pointer to the destination image
//   dstStep     Step through the destination image
//   dstRoiSize  Size of the destination ROI
//   mask        Type of the filter mask
*)
  ippiFilterMedianCross_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianCross_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianColor_8u_C3R
//              ippiFilterMedianColor_8u_AC4R
//              ippiFilterMedianColor_16s_C3R
//              ippiFilterMedianColor_16s_AC4R
//              ippiFilterMedianColor_32f_C3R
//              ippiFilterMedianColor_32f_AC4R
//  Purpose:  Filters an image using a box color median filter
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  pSrc or pDst is NULL
//   ippStsSizeErr     dstRoiSize has a field with zero or negative value
//   ippStsStepErr     srcStep or dstStep has zero or negative value
//   ippStsMaskSizeErr Illegal value of mask
//
//  Parameters:
//   pSrc        Pointer to the source image
//   srcStep     Step through the source image
//   pDst        Pointer to the destination image
//   dstStep     Step through the destination image
//   dstRoiSize  Size of the destination ROI
//   mask        Type of the filter mask
*)
  ippiFilterMedianColor_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianColor_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianColor_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianColor_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianColor_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;
  ippiFilterMedianColor_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianWeightedCenter3x3_8u_C1R

//  Purpose:  Filter an image using a median filter with kernel size 3x3 and
//            enlarged weight of central pixel
//  Returns:
//   ippStsNoErr            OK
//   ippStsNullPtrErr       pSrc or pDst is NULL
//   ippStsSizeErr          dstRoiSize has a field with zero or negative value
//   ippStsStepErr          srcStep or dstStep has zero or negative value
//   ippStsWeightErr        weight of central Pixel has zero or negative value
//   ippStsEvenMedianWeight weight of central Pixel has even value
//
//  Parameters:
//   pSrc        Pointer to the source image
//   srcStep     Step through the source image
//   pDst        Pointer to the destination image
//   dstStep     Step through the destination image
//   dstRoiSize  Size of the destination ROI
//   weight      Weight of central pixel
*)
  ippiFilterMedianWeightedCenter3x3_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;weight:longint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterMedianBorderGetBufferSize
//
//  Purpose:            Computes the size of the external buffer for median filter with border
//
//  Parameters:
//   roiSize            Size of destination ROI in pixels.
//   maskSize           Size of filter mask.
//   dataType           Data type of the source an desination images.
//   numChannels        Number of channels in the images. Possible values are 1, 3 or 4.
//   pBufferSize        Pointer to the size (in bytes) of the external work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error when roiSize has a field with negative or zero value.
//   ippStsMaskSizeErr  Indicates an error when maskSize has a field with negative, zero or even value.
//   ippStsDataTypeErr  Indicates an error when dataType has an illegal value.
//   ippStsNumChannelsErr Indicates an error when numChannels has an illegal value.
*)
  ippiFilterMedianBorderGetBufferSize: function(dstRoiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterMedianBorder_8u_C1R
//                      ippiFilterMedianBorder_16s_C1R
//                      ippiFilterMedianBorder_16u_C1R
//                      ippiFilterMedianBorder_32f_C1R
//  Purpose:            Perform median filtering of an image with border
//
//  Parameters:
//   pSrc               Pointer to the source image ROI.
//   srcStep            Distance in bytes between starting points of consecutive lines in the sorce image.
//   pDst               Pointer to the destination image ROI.
//   dstStep            Distance in bytes between starting points of consecutive lines in the destination image.
//   dstRoiSize         Size of destination ROI in pixels.
//   maskSize           Size of filter mask.
//   borderType         Type of border.
//   borderValue        Constant value to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBorderValue       Pointer to constant value to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBuffer            Pointer to the work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pSrc, pDst or pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error when roiSize has a field with negative or zero value.
//   ippStsMaskSizeErr  Indicates an error when maskSize has a field with negative, zero or even value.
//   ippStsNotEvenStepErr Indicated an error when one of the step values is not divisible by 4
//                      for floating-point images, or by 2 for short-integer images.
//   ippStsBorderErr    Indicates an error when borderType has illegal value.
*)

  ippiFilterMedianBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterMedianBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;

  ippiFilterMedianBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;

  ippiFilterMedianBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMedianBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterMaxBorderGetBufferSize
//                      ippiFilterMinBorderGetBufferSize
//
//  Purpose:            Computes the size of the external buffer for median filter with border
//
//  Parameters:
//   roiSize            Size of destination ROI in pixels.
//   maskSize           Size of mask.
//   dataType           data type of source and destination images.
//   numChannels        Number of channels in the images. Possible values is 1.
//   pBufferSize        Pointer to the size (in bytes) of the external work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error when roiSize is negative, or equal to zero.
//   ippStsMaskSizeErr  Indicates an error when maskSize is negative, or equal to zero.
//   ippStsDataTypeErr  Indicates an error when dataType has an illegal value.
//   ippStsNumChannelsErr Indicates an error when numChannels has an illegal value.
*)
  ippiFilterMaxBorderGetBufferSize: function(dstRoiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterMinBorderGetBufferSize: function(dstRoiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMaxBorder_8u_C1R
//              ippiFilterMaxBorder_8u_C3R
//              ippiFilterMaxBorder_8u_AC4R
//              ippiFilterMaxBorder_8u_C4R
//              ippiFilterMaxBorder_16s_C1R
//              ippiFilterMaxBorder_16s_C3R
//              ippiFilterMaxBorder_16s_AC4R
//              ippiFilterMaxBorder_16s_C4R
//              ippiFilterMaxBorder_16u_C1R
//              ippiFilterMaxBorder_16u_C3R
//              ippiFilterMaxBorder_16u_AC4R
//              ippiFilterMaxBorder_16u_C4R
//              ippiFilterMaxBorder_32f_C1R
//              ippiFilterMaxBorder_32f_C3R
//              ippiFilterMaxBorder_32f_AC4R
//              ippiFilterMaxBorder_32f_C4R
//              ippiFilterMinBorder_8u_C1R
//              ippiFilterMinBorder_8u_C3R
//              ippiFilterMinBorder_8u_AC4R
//              ippiFilterMinBorder_8u_C4R
//              ippiFilterMinBorder_16s_C1R
//              ippiFilterMinBorder_16s_C3R
//              ippiFilterMinBorder_16s_AC4R
//              ippiFilterMinBorder_16s_C4R
//              ippiFilterMinBorder_16u_C1R
//              ippiFilterMinBorder_16u_C3R
//              ippiFilterMinBorder_16u_AC4R
//              ippiFilterMinBorder_16u_C4R
//              ippiFilterMinBorder_32f_C1R
//              ippiFilterMinBorder_32f_C3R
//              ippiFilterMinBorder_32f_AC4R
//              ippiFilterMinBorder_32f_C4R
//
// Purpose:    Max and Min Filter with Border
// Parameters:
//   pSrc               Pointer to the source image ROI.
//   srcStep            Distance in bytes between starting points of consecutive lines in the sorce image.
//   pDst               Pointer to the destination image ROI.
//   dstStep            Distance in bytes between starting points of consecutive lines in the destination image.
//   dstRoiSize         Size of destination ROI in pixels.
//   maskSize           Size of mask.
//   borderType         Type of border.
//   borderValue        Constant value to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBorderValue       Pointer to constant value to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBuffer            Pointer to the work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pBuffer is NULL while it must be no NULL.
//   ippStsSizeErr      Indicates an error when roiSize is negative, or equal to zero.
//   ippStsStepErr      Indicates an error when srcStep or dstStep is negative, or equal to zero.
//   ippStsBorderErr    Indicates an error when borderType has illegal value.
*)
  ippiFilterMaxBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterMaxBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterMinBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterMinBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

(* ///////////////////////////////////////////////////////////////////////////
//             Linear Filters
/////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterBoxBorderGetBufferSize
//  Purpose:            Computes the size of external buffer for FilterBoxBorder
//
//  Parameters:
//    roiSize      Maximum size of the destination image ROI.
//    maskSize     Size of the mask in pixels.
//    dataType     Data type of the image. Possible values are ipp8u, ipp16u, ipp16s, or ipp32f.
//    numChannels  Number of channels in the image. Possible values are 1, 3, or 4.
//    pBufferSize  Pointer to the size of the external work buffer.
//
//  Return Values:
//    ippStsNoErr Indicates no error.
//    ippStsSizeErr Indicates an error when roiSize is negative, or equal to zero.
//    ippStsMaskSizeErr Indicates an error when mask has an illegal value.
//    ippStsDataTypeErr Indicates an error when dataType has an illegal value.
//    ippStsNumChannelsError Indicates an error when numChannels has an illegal value.
*)
  ippiFilterBoxBorderGetBufferSize: function(roiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;

(* ///////////////////////////////////////////////////////////////////////////
//  Name: ippiFilterBoxBorder_32f_<desc>R / ippiFilterBoxBorder_16u_<desc>R / ippiFilterBoxBorder_8u_<desc>R / ippiFilterBoxBorder_16s_<desc>R
//               <desc>  C1|C3|C4|AC4   (descriptor)
// Purpose:             Blurs an image using a simple box filter
// Parameters:
//   pSrc           Pointer to the source image.
//   srcStep        Distance in bytes between starting points of consecutive lines in the source image.
//   pDst           Pointer to the destination image.
//   dstStep        Distance in bytes between starting points of consecutive lines in the destination image.
//   dstRoiSize     Size of the destination ROI in pixels.
//   maskSize       Size of the mask in pixels.
//   border         Type of border. Possible values are:
//                     ippBorderConst Values of all border pixels are set to constant.
//                     ippBorderRepl Border is replicated from the edge pixels.
//                     ippBorderInMem Border is obtained from the source image pixels in memory.
//                     Mixed borders are also supported. They can be obtained by the bitwise operation OR between ippBorderRepl and ippBorderInMemTop, ippBorderInMemBottom, ippBorderInMemLeft, ippBorderInMemRight.
//   borderValue    Constant value to assign to pixels of the constant border. This parameter is applicable only to the ippBorderConst border type.
//   pBuffer        Pointer to the work buffer.
// Returns:
//   ippStsNoErr       Indicates no error.
//   ippStsNullPtrErr  Indicates an error when pSrc or pDst is NULL.
//   ippStsSizeErr     Indicates an error if roiSize has a field with zero or negative value.
//   ippStsMaskSizeErr Indicates an error if mask has an illegal value.
//   ippStsBorderErr   Indicates an error when border has an illegal value.
*)

  ippiFilterBoxBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;borderValue:PIpp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;borderValue:PIpp16u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;borderValue:PIpp16s;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;borderValue:PIpp8u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;

  ippiFilterBoxBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;border:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;

(* ///////////////////////////////////////////////////////////////////////////
// Name:   ippiFilterBox_64f_C1R
// Purpose:             Blurs an image using a simple box filter
// Parameters:
//   pSrc               pointer to the source image
//   srcStep            step in the source image
//   pDst               pointer to the destination image
//   dstStep            step in the destination image
//   pSrcDst            pointer to the source/destination image (in-place flavors)
//   srcDstStep         step in the source/destination image (in-place flavors)
//   dstRoiSize         size of the destination ROI
//   roiSize            size of the source/destination ROI (in-place flavors)
//   maskSize           size of the mask in pixels
//   anchor             the [x,y] coordinates of the anchor cell in the kernel
// Returns:
//   ippStsNoErr        No errors
//   ippStsNullPtrErr   pSrc == NULL or pDst == NULL or pSrcDst == NULL
//   ippStsStepErr      one of the step values is zero or negative
//   ippStsSizeErr      dstRoiSize or roiSize has a field with zero or negative value
//   ippStsMaskSizeErr  maskSize has a field with zero or negative value
//   ippStsAnchorErr    anchor is outside the mask
//   ippStsMemAllocErr  memory allocation error
*)


  ippiFilterBox_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;
(* ///////////////////////////////////////////////////////////////////////////
// Name:   ippiSumWindowRow_8u32f_<desc>R,  ippiSumWindowColumn_8u32f_<desc>R
//         ippiSumWindowRow_16u32f_<desc>R, ippiSumWindowColumn_16u32f_<desc>R
//         ippiSumWindowRow_16s32f_<desc>R, ippiSumWindowColumn_16s32f_<desc>R
//           <desc>  C1|C3|C4   (descriptor)
// Purpose:             Sums pixel values in the row or column mask applied to the image
// Parameters:
//   pSrc               pointer to the source image
//   srcStep            step in the source image
//   pDst               pointer to the destination image
//   dstStep            step in the destination image
//   dstRoiSize         size of the destination ROI
//   maskSize           size of the horizontal or vertical mask in pixels
//   anchor             the anchor cell
// Returns:
//   ippStsNoErr        No errors
//   ippStsNullPtrErr   pSrc == NULL or pDst == NULL or pSrcDst == NULL
//   ippStsSizeErr      dstRoiSize has a field with zero or negative value
//   ippStsMaskSizeErr  maskSize is zero or negative value
//   ippStsAnchorErr    anchor is outside the mask
//   ippStsMemAllocErr  memory allocation error (ippiSumWindowColumn only)
*)

  ippiSumWindowRow_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_16u32f_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_16u32f_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_16s32f_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowRow_16s32f_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;

  ippiSumWindowColumn_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_16u32f_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_16u32f_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_16s32f_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;
  ippiSumWindowColumn_16s32f_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:longint;anchor:longint):IppStatus;


(* ///////////////////////////////////////////////////////////////////////////
//             Filters with Fixed Kernel
/////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//              Kernels:
//
//                                1  1  1
//              PrewittHoriz      0  0  0
//                               -1 -1 -1
//
//
//                               -1  0  1
//              PrewittVert      -1  0  1
//                               -1  0  1
//
//
//                                1  2  1
//              SobelHoriz        0  0  0
//                               -1 -2 -1
//
//
//                               -1  0  1
//              SobelVert        -2  0  2
//                               -1  0  1
//
//
//                                0  0  0
//              RobetsDown        0  1  0
//                                0  0 -1
//
//
//                                0  0  0
//              RobertsUp         0  1  0
//                               -1  0  0
//
//
//                               -1 -1 -1
//              Sharpen          -1 16 -1  X  1/8
//                               -1 -1 -1
//
//
//                                3  0  -3
//              ScharrVert       10  0 -10
//                                3  0  -3
//
//
//                                3  10  3
//              ScharrHoriz       0   0  0
//                               -3 -10 -3
//
//
//                               -1 -1 -1
//              Laplace (3x3)    -1  8 -1
//                               -1 -1 -1
//
//
//                                1  2  1
//              Gauss (3x3)       2  4  2  X  1/16
//                                1  2  1
//
//
//                                1  1  1
//              Lowpass (3x3)     1  1  1  X  1/9
//                                1  1  1
//
//
//                               -1 -1 -1
//              Hipass (3x3 )    -1  8 -1
//                               -1 -1 -1
//
//
//                               -1  0  1
//              SobelVert (3x3)  -2  0  2
//                               -1  0  1
//
//
//                                1  2  1
//              SobelHoriz (3x3)  0  0  0
//                               -1 -2 -1
//
//
//                                       1 -2  1
//              SobelVertSecond (3x3)    2 -4  2
//                                       1 -2  1
//
//
//                                       1  2  1
//              SobelHorizSecond (3x3)  -2 -4 -2
//                                       1  2  1
//
//
//                               -1  0  1
//              SobelCross (3x3)  0  0  0
//                                1  0 -1
//
//
//                               -1 -3 -4 -3 -1
//                               -3  0  6  0 -3
//              Laplace (5x5)    -4  6 20  6 -4
//                               -3  0  6  0 -3
//                               -1 -3 -4 -3 -1
//
//                                2   7  12   7   2
//                                7  31  52  31   7
//              Gauss (5x5)      12  52 127  52  12  X  1/571
//                                7  31  52  31   7
//                                2   7  12   7   2
//
//                                1 1 1 1 1
//                                1 1 1 1 1
//              Lowpass (5x5)     1 1 1 1 1  X  1/25
//                                1 1 1 1 1
//                                1 1 1 1 1
//
//
//                               -1 -1 -1 -1 -1
//                               -1 -1 -1 -1 -1
//              Hipass (5x5)     -1 -1 24 -1 -1
//                               -1 -1 -1 -1 -1
//                               -1 -1 -1 -1 -1
//
//                               -1  -2   0   2   1
//                               -4  -8   0   8   4
//              SobelVert (5x5)  -6 -12   0  12   6
//                               -4  -8   0   8   4
//                               -1  -2   0   2   1
//
//                                1   4   6   4   1
//                                2   8  12   8   2
//              SobelHoriz (5x5)  0   0   0   0   0
//                               -2  -8 -12  -8  -2
//                               -1  -4  -6  -4  -1
//
//                                       1   0  -2   0   1
//                                       4   0  -8   0   4
//              SobelVertSecond (5x5)    6   0 -12   0   6
//                                       4   0  -8   0   4
//                                       1   0  -2   0   1
//
//                                       1   4   6   4   1
//                                       0   0   0   0   0
//              SobelHorizSecond (5x5)  -2  -8 -12  -8  -2
//                                       0   0   0   0   0
//                                       1   4   6   4   1
//
//                               -1  -2   0   2   1
//                               -2  -4   0   4   2
//              SobelCross (5x5)  0   0   0   0   0
//                                2   4   0  -4  -2
//                                1   2   0  -2  -1
//
*)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterSobelHorizBorderGetBufferSize
//                      ippiFilterSobelVertBorderGetBufferSize
//                      ippiFilterScharrHorizMaskBorderGetBufferSize
//                      ippiFilterScharrVertMaskBorderGetBufferSize
//                      ippiFilterPrewittHorizBorderGetBufferSize
//                      ippiFilterPrewittVertBorderGetBufferSize
//                      ippiFilterRobertsDownBorderGetBufferSize
//                      ippiFilterRobertsUpBorderGetBufferSize
//                      ippiFilterSobelHorizSecondBorderGetBufferSize
//                      ippiFilterSobelVertSecondBorderGetBufferSize
//                      ippiFilterSobelNegVertBorderGetBufferSize
//
//  Purpose:            Computes the size of the external buffer for fixed filter with border
//
//  Parameters:
//   roiSize            Size of destination ROI in pixels.
//   mask               Predefined mask of IppiMaskSize type.
//   srcDataType        Data type of the source image.
//   dstDataType        Data type of the destination image.
//   numChannels        Number of channels in the images.
//   pBufferSize        Pointer to the size (in bytes) of the external work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error when roiSize is negative, or equal to zero.
//   ippStsMaskSizeErr  Indicates an error condition if mask has a wrong value.
//   ippStsDataTypeErr  Indicates an error when srcDataType or dstDataType has an illegal value.
//   ippStsNumChannelsErr Indicates an error when numChannels has an illegal value.
*)
  ippiFilterSobelHorizBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterSobelVertBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterScharrHorizMaskBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterScharrVertMaskBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterPrewittHorizBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterPrewittVertBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterRobertsDownBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterRobertsUpBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterSobelHorizSecondBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterSobelVertSecondBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterSobelNegVertBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterLaplaceBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterHipassBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterSharpenBorderGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterSobelVertBorder_8u16s_C1R
//                      ippiFilterSobelHorizBorder_8u16s_C1R
//                      ippiFilterScharrVertMaskBorder_8u16s_C1R
//                      ippiFilterScharrHorizMaskBorder_8u16s_C1R
//                      ippiFilterPrewittVertBorder_8u16s_C1R
//                      ippiFilterPrewittHorizBorder_8u16s_C1R
//                      ippiFilterRobertsDownBorder_8u16s_C1R
//                      ippiFilterRobertsUpBorder_8u16s_C1R
//                      ippiFilterSobelVertSecondBorder_8u16s_C1R
//                      ippiFilterSobelHorizSecondBorder_8u16s_C1R
//                      ippiFilterSobelNegVertBorder_8u16s_C1R
//                      ippiFilterSobelVertBorder_16s_C1R
//                      ippiFilterSobelHorizBorder_16s_C1R
//                      ippiFilterScharrVertMaskBorder_16s_C1R
//                      ippiFilterScharrHorizMaskBorder_16s_C1R
//                      ippiFilterPrewittVertBorder_16s_C1R
//                      ippiFilterPrewittHorizBorder_16s_C1R
//                      ippiFilterRobertsDownBorder_16s_C1R
//                      ippiFilterRobertsUpBorder_16s_C1R
//                      ippiFilterSobelVertBorder_32f_C1R
//                      ippiFilterSobelHorizBorder_32f_C1R
//                      ippiFilterScharrVertMaskBorder_32f_C1R
//                      ippiFilterScharrHorizMaskBorder_32f_C1R
//                      ippiFilterPrewittVertBorder_32f_C1R
//                      ippiFilterPrewittHorizBorder_32f_C1R
//                      ippiFilterRobertsDownBorder_32f_C1R
//                      ippiFilterRobertsUpBorder_32f_C1R
//                      ippiFilterSobelVertSecondBorder_32f_C1R
//                      ippiFilterSobelHorizSecondBorder_32f_C1R
//                      ippiFilterSobelNegVertBorder_32f_C1R
//                      ippiFilterLaplaceBorder_8u_C1R
//                      ippiFilterLaplaceBorder_8u_C3R
//                      ippiFilterLaplaceBorder_8u_C4R
//                      ippiFilterLaplaceBorder_8u_AC4R
//                      ippiFilterLaplaceBorder_16s_C1R
//                      ippiFilterLaplaceBorder_16s_C3R
//                      ippiFilterLaplaceBorder_16s_C4R
//                      ippiFilterLaplaceBorder_16s_AC4R
//                      ippiFilterLaplaceBorder_32f_C1R
//                      ippiFilterLaplaceBorder_32f_C3R
//                      ippiFilterLaplaceBorder_32f_C4R
//                      ippiFilterLaplaceBorder_32f_AC4R
//                      ippiFilterHipassBorder_8u_C1R
//                      ippiFilterHipassBorder_8u_C3R
//                      ippiFilterHipassBorder_8u_C4R
//                      ippiFilterHipassBorder_8u_AC4R
//                      ippiFilterHipassBorder_16s_C1R
//                      ippiFilterHipassBorder_16s_C3R
//                      ippiFilterHipassBorder_16s_C4R
//                      ippiFilterHipassBorder_16s_AC4R
//                      ippiFilterHipassBorder_32f_C1R
//                      ippiFilterHipassBorder_32f_C3R
//                      ippiFilterHipassBorder_32f_C4R
//                      ippiFilterHipassBorder_32f_AC4R
//                      ippiFilterSharpenBorder_8u_C1R
//                      ippiFilterSharpenBorder_8u_C3R
//                      ippiFilterSharpenBorder_8u_C4R
//                      ippiFilterSharpenBorder_8u_AC4R
//                      ippiFilterSharpenBorder_16s_C1R
//                      ippiFilterSharpenBorder_16s_C3R
//                      ippiFilterSharpenBorder_16s_C4R
//                      ippiFilterSharpenBorder_16s_AC4R
//                      ippiFilterSharpenBorder_32f_C1R
//                      ippiFilterSharpenBorder_32f_C3R
//                      ippiFilterSharpenBorder_32f_C4R
//                      ippiFilterSharpenBorder_32f_AC4R

//
//  Purpose:            Perform linear filtering of an image using one of
//                      predefined convolution kernels.
//
//  Parameters:
//   pSrc               Pointer to the source image ROI.
//   srcStep            Distance in bytes between starting points of consecutive lines in the sorce image.
//   pDst               Pointer to the destination image ROI.
//   dstStep            Distance in bytes between starting points of consecutive lines in the destination image.
//   dstRoiSize         Size of destination ROI in pixels.
//   mask               Predefined mask of IppiMaskSize type.
//   borderType         Type of border.
//   borderValue        Constant value to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBorderValue       The pointer to constant values to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBuffer            Pointer to the work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error when roiSize is negative, or equal to zero.
//   ippStsNotEvenStepErr Indicated an error when one of the step values is not divisible by 4
//                      for floating-point images, or by 2 for short-integer images.
//   ippStsBorderErr    Indicates an error when borderType has illegal value.
*)
  ippiFilterSobelVertBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelHorizBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterScharrVertMaskBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterScharrHorizMaskBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterPrewittVertBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterPrewittHorizBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterRobertsDownBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterRobertsUpBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelVertSecondBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelHorizSecondBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelNegVertBorder_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;

  ippiFilterSobelVertBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelHorizBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterScharrVertMaskBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterScharrHorizMaskBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterPrewittVertBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterPrewittHorizBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterRobertsDownBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterRobertsUpBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelVertSecondBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelHorizSecondBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelNegVertBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterSobelVertBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobelHorizBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterScharrVertMaskBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterScharrHorizMaskBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterPrewittVertBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterPrewittHorizBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterRobertsDownBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterRobertsUpBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;

  ippiFilterLaplaceBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterLaplaceBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterHipassBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterHipassBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiFilterSharpenBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterSharpenBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize;borderType:IppiBorderType;var pBorderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterSobelGetBufferSize
//
//  Purpose:            Computes the size of the external buffer for sobel operator
//
//  Parameters:
//   roiSize            Size of destination ROI in pixels.
//   mask               Predefined mask of IppiMaskSize type.
//   normTypre          Normalization mode if IppNormTYpe type.
//   srcDataType        Data type of the source image.
//   dstDataType        Data type of the destination image.
//   numChannels        Number of channels in the images. Possible values is 1.
//   pBufferSize        Pointer to the size (in bytes) of the external work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error when pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error when roiSize is negative, or equal to zero.
//   ippStsMaskSizeErr  Indicates an error condition if mask has a wrong value.
//   ippStsBadArgErr    Indicates an error condition if normType has an illegal value.
//   ippStsDataTypeErr  Indicates an error when srcDataType or dstDataType has an illegal value.
//   ippStsNumChannelsErr Indicates an error when numChannels has an illegal value.
*)
  ippiFilterSobelGetBufferSize: function(dstRoiSize:IppiSize;mask:IppiMaskSize;normType:IppNormType;srcDataType:IppDataType;dstDataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiFilterSobel_8u16s_C1R
//                      ippiFilterSobel_16s32f_C1R
//                      ippiFilterSobel_16u32f_C1R
//                      ippiFilterSobel_32f_C1R
//
//  Purpose:            Perform Sobel operation of an image using pair of
//                      predefined convolution kernels.
//
//  Parameters:
//   pSrc               Pointer to the source image ROI.
//   srcStep            Distance in bytes between starting points of consecutive lines in the sorce image.
//   pDst               Pointer to the destination image ROI.
//   dstStep            Distance in bytes between starting points of consecutive lines in the destination image.
//   dstRoiSize         Size of destination ROI in pixels.
//   mask               Predefined mask of IppiMaskSize type.
//   normType           Normalization mode of IppNoremType type
//   borderType         Type of border.
//   borderValue        Constant value to assign to pixels of the constant border. This parameter is applicable
//                      only to the ippBorderConst border type.
//   pBuffer            Pointer to the work buffer.
//
//  Return Values:
//   ippStsNoErr        Indicates no error.
//   ippStsNullPtrErr   Indicates an error condition if pSrc, pDst or pBufferSize is NULL.
//   ippStsSizeErr      Indicates an error condition if dstRoiSize has a fild with zero or negative value.
//   ippStsMaskSizeErr  Indicates an error condition if mask has an illegal value.
//   ippStsBadArgErr    Indicates an error condition if normType has an illegal value.
//   ippStsNotEvenStepErr Indicated an error when one of the step values is not divisible by 4
//                      for floating-point images, or by 2 for short-integer images.
//   ippStsBorderErr    Indicates an error when borderType has illegal value.
*)
  ippiFilterSobel_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobel_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobel_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiFilterSobel_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;






(* /////////////////////////////////////////////////////////////////////////////
//                  Wiener Filters
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippiFilterWienerGetBufferSize,
//  Purpose: Computes the size of the external buffer for Wiener filter
//
//      ippiFilterWiener_8u_C1R,  ippiFilterWiener_16s_C1R,
//      ippiFilterWiener_8u_C3R,  ippiFilterWiener_16s_C3R,
//      ippiFilterWiener_8u_C4R,  ippiFilterWiener_16s_C4R,
//      ippiFilterWiener_8u_AC4R, ippiFilterWiener_16s_AC4R,
//      ippiFilterWiener_32f_C1R,
//      ippiFilterWiener_32f_C3R,
//      ippiFilterWiener_32f_C4R,
//      ippiFilterWiener_32f_AC4R.
//
//  Purpose: Performs two-dimensional adaptive noise-removal
//           filtering of an image using Wiener filter.
//
//  Parameters:
//      pSrc        Pointer to the source image ROI;
//      srcStep     Step in bytes through the source image buffer;
//      pDst        Pointer to the destination image ROI;
//      dstStep     Step in bytes through the destination image buffer;
//      dstRoiSize  Size of the destination ROI in pixels;
//      maskSize    Size of the rectangular local pixel neighborhood (mask);
//      anchor      Anchor cell specifying the mask alignment
//                           with respect to the position of the input pixel;
//      noise       Noise level value or array of the noise level values for
//                                                       multi-channel image;
//      pBuffer     Pointer to the external work buffer;
//      pBufferSize Pointer to the computed value of the external buffer size;
//      channels    Number of channels in the image ( 1, 3, or 4 ).
//
//  Returns:
//   ippStsNoErr           OK
//   ippStsNumChannelsErr  channels is not 1, 3, or 4
//   ippStsNullPtrErr      One of the pointers is NULL;
//   ippStsSizeErr         dstRoiSize has a field with zero or negative value
//   ippStsMaskSizeErr     maskSize has a field with zero or negative value
//   ippStsNoiseRangeErr   One of the noise values is less than 0
//                                                         or greater than 1.0;
*)

  ippiFilterWienerGetBufferSize: function(dstRoiSize:IppiSize;maskSize:IppiSize;channels:longint;pBufferSize:Plongint):IppStatus;
  ippiFilterWiener_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;
  ippiFilterWiener_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippiConvGetBufferSize
//
//  Purpose:     Get the size (in bytes) of the buffer for ippiConv internal calculations.
//
//  Parameters:
//    src1Size    - Size, in pixels, of the first source image.
//    src2Size    - Size, in pixels, of the second source image.
//    dataType    - Data type for convolution. Possible values are ipp32f, ipp16s, or ipp8u.
//    numChannels - Number of image channels. Possible values are 1, 3, or 4.
//    algType     - Bit-field mask for the algorithm type definition.
//                  Possible values are the results of composition of the IppAlgType and IppiROIShape values.
//                  Example: (ippiROIFull|ippAlgFFT) - full-shaped convolution will be calculated using 2D FFT.
//    pBufferSize - Pointer to the calculated buffer size (in bytes).
//
//  Return:
//   ippStsNoErr          - OK.
//   ippStsSizeErr        - Error when the src1Size or src2Size is negative, or equal to zero.
//   ippStsNumChannelsErr - Error when the numChannels value differs from 1, 3, or 4.
//   ippStsDataTypeErr    - Error when the dataType value differs from the ipp32f, ipp16s, or ipp8u.
//   ippStsAlgTypeErr     - Error when :
//                            The result of the bitwise AND operation between algType and ippAlgMask differs from the ippAlgAuto, ippAlgDirect, or ippAlgFFT values.
//                            The result of the bitwise AND operation between algType and ippiROIMask differs from the ippiROIFull or ippiROIValid values.
//   ippStsNullPtrErr     - Error when the pBufferSize is NULL.
*)
  ippiConvGetBufferSize: function(src1Size:IppiSize;src2Size:IppiSize;dataType:IppDataType;numChannels:longint;algType:IppEnum;pBufferSize:Plongint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//   Names: ippiConv_32f_C1R, ippiConv_32f_C3R, ippiConv_32f_C4R
//          ippiConv_16s_C1R, ippiConv_16s_C3R, ippiConv_16s_C4R
//          ippiConv_8u_C1R,  ippiConv_8u_C3R,  ippiConv_8u_C4R
//  Purpose: Performs full or valid 2-D convolution of two images.
//           The result image size depends on operation shape selected in algType mask as follows:
//             (Wa+Wb-1)*(Ha+Hb-1) for ippiROIFull mask
//             (Wa-Wb+1)*(Ha-Hb+1) for ippiROIValid mask,
//           where Wa*Ha and Wb*Hb are the sizes of the image and template, respectively.
//          If the IppAlgMask value in algType is equal to ippAlgAuto, the optimal algorithm is selected
//          automatically. For big data size, the function uses 2D FFT algorithm.
//  Parameters:
//    pSrc1, pSrc2       - Pointers to the source images ROI.
//    src1Step, src2Step - Distances, in bytes, between the starting points of consecutive lines in the source images.
//    src1Size, src2Size - Size, in pixels, of the source images.
//    pDst               - Pointer to the destination image ROI.
//    dstStep            - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    divisor            - The integer value by which the computed result is divided (for operations on integer data only).
//    algType            - Bit-field mask for the algorithm type definition. Possible values are the results of composition of the IppAlgType and IppiROIShape values.
//                          Usage example: algType=(ippiROIFull|ippAlgFFT); - full-shaped convolution will be calculated using 2D FFT.
//    pBuffer            - Pointer to the buffer for internal calculations.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsStepErr    - Error when src1Step, src2Step, or dstStep has a zero or negative value.
//    ippStsSizeErr    - Error when src1Size or src2Size has a zero or negative value.
//    ippStsDivisorErr - Error when divisor has the zero value.
//    ippStsAlgTypeErr - Error when :
//                         The result of the bitwise AND operation between algType and ippAlgMask differs from the ippAlgAuto, ippAlgDirect, or ippAlgFFT values.
//                         The result of the bitwise AND operation between algType and ippiROIMask differs from the ippiROIFull or ippiROIValid values.
*)
  ippiConv_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;src2Size:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;src2Size:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;src2Size:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiConv_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;



(* //////////////////////////////////////////////////////////////////////////////////////
//                   Image Proximity Measures
////////////////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippiCrossCorrNormGetBufferSize
//
//  Purpose:     Computes the size (in bytes) of the work buffer for the ippiCrossCorrNorm functions.
//
//  Parameters:
//    srcRoiSize  - Size of the source ROI in pixels.
//    tplRoiSize  - Size of the template ROI in pixels.
//    algType     - Bit-field mask for the algorithm type definition. Possible values are the results of composition of the IppAlgType, IppiROIShape, and IppiNormOp values.
//                  Usage example: algType=(ippiROIFull|ippAlgFFT|ippiNorm); - full-shaped cross-correlation will be calculated
//                      using 2D FFT and normalization applied to result image.
//    pBufferSize - Pointer to the size of the work buffer (in bytes).
//  Return:
//    ippStsNoErr       - OK.
//    ippStsSizeErr     - Error when:
//                            srcRoiSize or tplRoiSize is negative, or equal to zero.
//                            The value of srcRoiSize is less than the corresponding value of the tplRoiSize.
//    ippStsAlgTypeErr  - Error when :
//                            The result of the bitwise AND operation between the algType and ippAlgMask differs from the ippAlgAuto, ippAlgDirect, or ippAlgFFT values.
//                            The result of the bitwise AND operation between the algType and ippiROIMask differs from the ippiROIFull, ippiROISame, or ippiROIValid values.
//                            The result of the bitwise AND operation between the algType and ippiNormMask differs from the ippiNormNone, ippiNorm, or ippiNormCoefficient values.
//    ippStsNullPtrErr  - Error when the pBufferSize is NULL.
*)
  ippiCrossCorrNormGetBufferSize: function(srcRoiSize:IppiSize;tplRoiSize:IppiSize;algType:IppEnum;pBufferSize:Plongint):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////
//  Names: ippiCrossCorrNorm_32f_C1R
//         ippiCrossCorrNorm_16u32f_C1R
//         ippiCrossCorrNorm_8u32f_C1R
//         ippiCrossCorrNorm_8u_C1RSfs
//  Purpose: Computes normalized cross-correlation between an image and a template.
//           The result image size depends on operation shape selected in algType mask as follows :
//             (Wa+Wb-1)*(Ha+Hb-1) for ippiROIFull mask,
//             (Wa)*(Ha)           for ippiROISame mask,
//             (Wa-Wb+1)*(Ha-Hb+1) for ippiROIValid mask,
//           where Wa*Ha and Wb*Hb are the sizes of the image and template correspondingly.
//           Support of normalization operations (set in the algType mask) is set by selecting the following masks:
//             ippiNormNone   - the cross-correlation without normalization.
//             ippiNorm - the normalized cross-correlation.
//             ippiNormCoefficient  - the normalized correlation coefficients.
//           If the IppAlgMask value in algType is equal to ippAlgAuto, the optimal algorithm is selected automatically.
//           For big data size, the function uses 2D FFT algorithm.
//  Parameters:
//    pSrc        - Pointer to the source image ROI.
//    srcStep     - Distance, in bytes, between the starting points of consecutive lines in the source image.
//    srcRoiSize  - Size of the source ROI in pixels.
//    pTpl        - Pointer to the template image.
//    tplStep     - Distance, in bytes, between the starting points of consecutive lines in the template image.
//    tplRoiSize  - Size of the template ROI in pixels.
//    pDst        - Pointer to the destination image ROI.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    scaleFactor - Scale factor.
//    algType     - Bit-field mask for the algorithm type definition. Possible values are the results of composition of the IppAlgType, IppiROIShape, and IppiNormOp values.
//                  Usage example: algType=(ippiROIFull|ippAlgFFT|ippiNormNone); - full-shaped cross-correlation will be calculated using 2D FFT without result normalization.
//    pBuffer     - Pointer to the work buffer.
//  Returns:
//    ippStsNoErr      OK.
//    ippStsNullPtrErr Error when any of the specified pointers is NULL.
//    ippStsStepErr    Error when the value of srcStep, tplStep, or dstStep is negative, or equal to zero.
//    ippStsSizeErr    Error when :
//                         srcRoiSize or tplRoiSize is negative, or equal to zero.
//                         The value of srcRoiSize is less than the corresponding value of tplRoiSize.
//    ippStsAlgTypeErr Error when :
//                         The result of the bitwise AND operation between the algType and ippAlgMask differs from the ippAlgAuto, ippAlgDirect, or ippAlgFFT values.
//                         The result of the bitwise AND operation between the algType and ippiROIMask differs from the ippiROIFull, ippiROISame, or ippiROIValid values.
//                         The result of the bitwise AND operation between the algType and ippiNormMask differs from the ippiNormNone, ippiNorm, or ippiNormCoefficient values.
*)
  ippiCrossCorrNorm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiCrossCorrNorm_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp16u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiCrossCorrNorm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiCrossCorrNorm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:  ippiSqrDistanceNormGetBufferSize
//
//  Purpose:     Computes the size of the work buffer for the ippiSqrDistanceNorm functions.
//
//  Parameters:
//    srcRoiSize  - Size of the source ROI, in pixels.
//    tplRoiSize  - Size of the template ROI, in pixels.
//    algType     - Bit-field mask for the algorithm type definition. Possible values are the results of composition of the IppAlgType, IppiROIShape, and IppiNormOp values.
//                  Usage example: algType=(ippiROIFull|ippAlgFFT|ippiNorm); - result image will be calculated for full-shaped ROI
//                  using 2D FFT and normalization applied.
//    pBufferSize - Pointer where to store the calculated buffer size (in bytes)
//  Return:
//    ippStsNoErr      - Ok.
//    ippStsSizeErr    - Error when :
//                           srcRoiSize or tplRoiSize is negative, or equal to zero.
//                           The value of srcRoiSize is less than the corresponding value of tplRoiSize.
//    ippStsAlgTypeErr - Error when :
//                           The result of the bitwise AND operation between the algType and ippAlgMask differs from the ippAlgAuto, ippAlgDirect, or ippAlgFFT values.
//                           The result of the bitwise AND operation between the algType and ippiROIMask differs from the ippiROIFull, ippiROISame, or ippiROIValid values.
//                           The result of the bitwise AND operation between the algType and ippiNormMask differs from the ippiNormNone or ippiNorm values.
//    ippStsNullPtrErr - Error when the pBufferSize is NULL.
*)
  ippiSqrDistanceNormGetBufferSize: function(srcRoiSize:IppiSize;tplRoiSize:IppiSize;algType:IppEnum;pBufferSize:Plongint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names: ippiSqrDistanceNorm_32f_C1R
//         ippiSqrDistanceNorm_16u32f_C1R
//         ippiSqrDistanceNorm_8u32f_C1R
//         ippiSqrDistanceNorm_8u_C1RSfs
//  Purpose: Computes Euclidean distance between an image and a template.
//           The result image size depends on operation shape selected in algType mask as follows :
//             (Wa+Wb-1)*(Ha+Hb-1) for ippiROIFull mask,
//             (Wa)*(Ha)           for ippiROISame mask,
//             (Wa-Wb+1)*(Ha-Hb+1) for ippiROIValid mask,
//           where Wa*Ha and Wb*Hb are the sizes of the image and template , respectively.
//           Support of normalization operations (set the algType mask) :
//             ippiNormNone   - the squared Euclidean distances.
//             ippiNorm - the normalized squared Euclidean distances.
//           If the IppAlgMask value in algType is equal to ippAlgAuto, the optimal algorithm is selected
//           automatically. For big data size, the function uses 2D FFT algorithm.
//  Parameters:
//    pSrc        - Pointer to the source image ROI.
//    srcStep     - Distance, in bytes, between the starting points of consecutive lines in the source image.
//    srcRoiSize  - Size of the source ROI, in pixels.
//    pTpl        - Pointer to the template image.
//    tplStep     - Distance, in bytes, between the starting points of consecutive lines in the template image.
//    tplRoiSize  - Size of the template ROI, in pixels.
//    pDst        - Pointer to the destination image ROI.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    scaleFactor - Scale factor.
//    algType     - Bit-field mask for the algorithm type definition. Possible values are the results of composition of the IppAlgType, IppiROIShape, and IppiNormOp values.
//                  Usage example: algType=(ippiROIFull|ippiNormNone|ippAlgFFT); - result will be calculated for full-shaped ROI using 2D FFT without normalization.
//    pBuffer     - Pointer to the buffer for internal calculation.
//  Returns:
//    ippStsNoErr      OK.
//    ippStsNullPtrErr Error when any of the specified pointers is NULL.
//    ippStsStepErr    Error when the value of srcStep, tplStep, or dstStep is negative, or equal to zero.
//    ippStsSizeErr    Error when :
//                         srcRoiSize or tplRoiSize is negative, or equal to zero.
//                         The value of srcRoiSize is less than the corresponding value of the tplRoiSize.
//    ippStsAlgTypeErr Error when :
//                         The result of the bitwise AND operation between the algType and ippAlgMask differs from the ippAlgAuto, ippAlgDirect, or ippAlgFFT values.
//                         The result of the bitwise AND operation between the algType and ippiROIMask differs from the ippiROIFull, ippiROISame, or ippiROIValid values.
//                         The result of the bitwise AND operation between the algType and ippiNormMask differs from the ippiNormNone or ippiNorm values.
*)
  ippiSqrDistanceNorm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiSqrDistanceNorm_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp16u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiSqrDistanceNorm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;
  ippiSqrDistanceNorm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint;algType:IppEnum;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                   Threshold operations
///////////////////////////////////////////////////////////////////////////// *)

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_8u_C1R
//              ippiThreshold_8u_C3R
//              ippiThreshold_8u_AC4R
//              ippiThreshold_16s_C1R
//              ippiThreshold_16s_C3R
//              ippiThreshold_16s_AC4R
//              ippiThreshold_32f_C1R
//              ippiThreshold_32f_C3R
//              ippiThreshold_32f_AC4R
//              ippiThreshold_8u_C1IR
//              ippiThreshold_8u_C3IR
//              ippiThreshold_8u_AC4IR
//              ippiThreshold_16s_C1IR
//              ippiThreshold_16s_C3IR
//              ippiThreshold_16s_AC4IR
//              ippiThreshold_32f_C1IR
//              ippiThreshold_32f_C3IR
//              ippiThreshold_32f_AC4IR
//              ippiThreshold_16u_C1R
//              ippiThreshold_16u_C3R
//              ippiThreshold_16u_AC4R
//              ippiThreshold_16u_C1IR
//              ippiThreshold_16u_C3IR
//              ippiThreshold_16u_AC4IR
//
//  Purpose:    Performs thresholding of an image using the specified level

//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     roiSize has a field with zero or negative value
//   ippStsStepErr     One of the step values is zero or negative
//
//  Parameters:
//   pSrc       Pointer to the source image
//   srcStep    Step through the source image
//   pDst       Pointer to the destination image
//   dstStep    Step through the destination image
//   pSrcDst    Pointer to the source/destination image (in-place flavors)
//   srcDstStep Step through the source/destination image (in-place flavors)
//   roiSize    Size of the ROI
//   threshold  Threshold level value (array of values for multi-channel data)
//   ippCmpOp   Comparison mode, possible values:
//                ippCmpLess     - less than,
//                ippCmpGreater  - greater than
*)
  ippiThreshold_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;threshold:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_GT_8u_C1R
//              ippiThreshold_GT_8u_C3R
//              ippiThreshold_GT_8u_AC4R
//              ippiThreshold_GT_16s_C1R
//              ippiThreshold_GT_16s_C3R
//              ippiThreshold_GT_16s_AC4R
//              ippiThreshold_GT_32f_C1R
//              ippiThreshold_GT_32f_C3R
//              ippiThreshold_GT_32f_AC4R
//              ippiThreshold_GT_8u_C1IR
//              ippiThreshold_GT_8u_C3IR
//              ippiThreshold_GT_8u_AC4IR
//              ippiThreshold_GT_16s_C1IR
//              ippiThreshold_GT_16s_C3IR
//              ippiThreshold_GT_16s_AC4IR
//              ippiThreshold_GT_32f_C1IR
//              ippiThreshold_GT_32f_C3IR
//              ippiThreshold_GT_32f_AC4IR
//              ippiThreshold_GT_16u_C1R
//              ippiThreshold_GT_16u_C3R
//              ippiThreshold_GT_16u_AC4R
//              ippiThreshold_GT_16u_C1IR
//              ippiThreshold_GT_16u_C3IR
//              ippiThreshold_GT_16u_AC4IR
//
//  Purpose:   Performs threshold operation using the comparison "greater than"
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     roiSize has a field with zero or negative value
//   ippStsStepErr     One of the step values is zero or negative
//
//  Parameters:
//   pSrc       Pointer to the source image
//   srcStep    Step through the source image
//   pDst       Pointer to the destination image
//   dstStep    Step through the destination image
//   pSrcDst    Pointer to the source/destination image (in-place flavors)
//   srcDstStep Step through the source/destination image (in-place flavors)
//   roiSize    Size of the ROI
//   threshold  Threshold level value (array of values for multi-channel data)
*)
  ippiThreshold_GT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;
  ippiThreshold_GT_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;
  ippiThreshold_GT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;
  ippiThreshold_GT_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_GT_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_GT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_GT_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_GT_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_GT_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_GT_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;
  ippiThreshold_GT_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;
  ippiThreshold_GT_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;
  ippiThreshold_GT_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_GT_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_GT_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_GT_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_GT_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_GT_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_GT_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;threshold:Ipp16u):IppStatus;
  ippiThreshold_GT_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;
  ippiThreshold_GT_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;
  ippiThreshold_GT_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16u):IppStatus;
  ippiThreshold_GT_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;
  ippiThreshold_GT_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_LT_8u_C1R
//              ippiThreshold_LT_8u_C3R
//              ippiThreshold_LT_8u_AC4R
//              ippiThreshold_LT_16s_C1R
//              ippiThreshold_LT_16s_C3R
//              ippiThreshold_LT_16s_AC4R
//              ippiThreshold_LT_32f_C1R
//              ippiThreshold_LT_32f_C3R
//              ippiThreshold_LT_32f_AC4R
//              ippiThreshold_LT_8u_C1IR
//              ippiThreshold_LT_8u_C3IR
//              ippiThreshold_LT_8u_AC4IR
//              ippiThreshold_LT_16s_C1IR
//              ippiThreshold_LT_16s_C3IR
//              ippiThreshold_LT_16s_AC4IR
//              ippiThreshold_LT_32f_C1IR
//              ippiThreshold_LT_32f_C3IR
//              ippiThreshold_LT_32f_AC4IR
//              ippiThreshold_LT_16u_C1R
//              ippiThreshold_LT_16u_C3R
//              ippiThreshold_LT_16u_AC4R
//              ippiThreshold_LT_16u_C1IR
//              ippiThreshold_LT_16u_C3IR
//              ippiThreshold_LT_16u_AC4IR
//
//  Purpose:  Performs threshold operation using the comparison "less than"
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     roiSize has a field with zero or negative value
//   ippStsStepErr     One of the step values is zero or negative
//
//  Parameters:
//   pSrc       Pointer to the source image
//   srcStep    Step through the source image
//   pDst       Pointer to the destination image
//   dstStep    Step through the destination image
//   pSrcDst    Pointer to the source/destination image (in-place flavors)
//   srcDstStep Step through the source/destination image (in-place flavors)
//   roiSize    Size of the ROI
//   threshold  Threshold level value (array of values for multi-channel data)
//   ippCmpOp   Comparison mode, possible values:
//                ippCmpLess     - less than
//                ippCmpGreater  - greater than
*)
  ippiThreshold_LT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;
  ippiThreshold_LT_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;
  ippiThreshold_LT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;
  ippiThreshold_LT_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_LT_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_LT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_LT_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_LT_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_LT_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_LT_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;
  ippiThreshold_LT_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;
  ippiThreshold_LT_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;
  ippiThreshold_LT_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_LT_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_LT_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_LT_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;
  ippiThreshold_LT_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;
  ippiThreshold_LT_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;
  ippiThreshold_LT_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;threshold:Ipp16u):IppStatus;
  ippiThreshold_LT_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;
  ippiThreshold_LT_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;
  ippiThreshold_LT_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16u):IppStatus;
  ippiThreshold_LT_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;
  ippiThreshold_LT_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_Val_8u_C1R
//              ippiThreshold_Val_8u_C3R
//              ippiThreshold_Val_8u_AC4R
//              ippiThreshold_Val_16s_C1R
//              ippiThreshold_Val_16s_C3R
//              ippiThreshold_Val_16s_AC4R
//              ippiThreshold_Val_32f_C1R
//              ippiThreshold_Val_32f_C3R
//              ippiThreshold_Val_32f_AC4R
//              ippiThreshold_Val_8u_C1IR
//              ippiThreshold_Val_8u_C3IR
//              ippiThreshold_Val_8u_AC4IR
//              ippiThreshold_Val_16s_C1IR
//              ippiThreshold_Val_16s_C3IR
//              ippiThreshold_Val_16s_AC4IR
//              ippiThreshold_Val_32f_C1IR
//              ippiThreshold_Val_32f_C3IR
//              ippiThreshold_Val_32f_AC4IR
//              ippiThreshold_Val_16u_C1R
//              ippiThreshold_Val_16u_C3R
//              ippiThreshold_Val_16u_AC4R
//              ippiThreshold_Val_16u_C1IR
//              ippiThreshold_Val_16u_C3IR
//              ippiThreshold_Val_16u_AC4IR
//
//  Purpose:  Performs thresholding of pixel values: pixels that satisfy
//            the compare conditions are set to a specified value
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     roiSize has a field with zero or negative value
//   ippStsStepErr     One of the step values is zero or negative
//
//  Parameters:
//   pSrc       Pointer to the source image
//   srcStep    Step through the source image
//   pDst       Pointer to the destination image
//   dstStep    Step through the destination image
//   pSrcDst    Pointer to the source/destination image (in-place flavors)
//   srcDstStep Step through the source/destination image (in-place flavors)
//   roiSize    Size of the ROI
//   threshold  Threshold level value (array of values for multi-channel data)
//   value      The output value (array or values for multi-channel data)
//   ippCmpOp      comparison mode, ippCmpLess or ippCmpGreater
*)
  ippiThreshold_Val_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;threshold:Ipp16u;value:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16u;value:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;
  ippiThreshold_Val_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u;ippCmpOp:IppCmpOp):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_GTVal_8u_C1R
//              ippiThreshold_GTVal_8u_C3R
//              ippiThreshold_GTVal_8u_AC4R
//              ippiThreshold_GTVal_16s_C1R
//              ippiThreshold_GTVal_16s_C3R
//              ippiThreshold_GTVal_16s_AC4R
//              ippiThreshold_GTVal_32f_C1R
//              ippiThreshold_GTVal_32f_C3R
//              ippiThreshold_GTVal_32f_AC4R
//              ippiThreshold_GTVal_8u_C1IR
//              ippiThreshold_GTVal_8u_C3IR
//              ippiThreshold_GTVal_8u_AC4IR
//              ippiThreshold_GTVal_16s_C1IR
//              ippiThreshold_GTVal_16s_C3IR
//              ippiThreshold_GTVal_16s_AC4IR
//              ippiThreshold_GTVal_32f_C1IR
//              ippiThreshold_GTVal_32f_C3IR
//              ippiThreshold_GTVal_32f_AC4IR
//              ippiThreshold_GTVal_8u_C4R
//              ippiThreshold_GTVal_16s_C4R
//              ippiThreshold_GTVal_32f_C4R
//              ippiThreshold_GTVal_8u_C4IR
//              ippiThreshold_GTVal_16s_C4IR
//              ippiThreshold_GTVal_32f_C4IR
//              ippiThreshold_GTVal_16u_C1R
//              ippiThreshold_GTVal_16u_C3R
//              ippiThreshold_GTVal_16u_AC4R
//              ippiThreshold_GTVal_16u_C1IR
//              ippiThreshold_GTVal_16u_C3IR
//              ippiThreshold_GTVal_16u_AC4IR
//              ippiThreshold_GTVal_16u_C4R
//              ippiThreshold_GTVal_16u_C4IR
//
//  Purpose:  Performs thresholding of pixel values: pixels that are
//            greater than threshold, are set to a specified value
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     roiSize has a field with zero or negative value
//   ippStsStepErr     One of the step values is zero or negative
//
//  Parameters:
//   pSrc       Pointer to the source image
//   srcStep    Step through the source image
//   pDst       Pointer to the destination image
//   dstStep    Step through the destination image
//   pSrcDst    Pointer to the source/destination image (in-place flavors)
//   srcDstStep Step through the source/destination image (in-place flavors)
//   roiSize    Size of the ROI
//   threshold  Threshold level value (array of values for multi-channel data)
//   value      The output value (array or values for multi-channel data)
*)
  ippiThreshold_GTVal_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_GTVal_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_GTVal_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_GTVal_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;threshold:Ipp16u;value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16u;value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_GTVal_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_LTVal_8u_C1R
//              ippiThreshold_LTVal_8u_C3R
//              ippiThreshold_LTVal_8u_AC4R
//              ippiThreshold_LTVal_16s_C1R
//              ippiThreshold_LTVal_16s_C3R
//              ippiThreshold_LTVal_16s_AC4R
//              ippiThreshold_LTVal_32f_C1R
//              ippiThreshold_LTVal_32f_C3R
//              ippiThreshold_LTVal_32f_AC4R
//              ippiThreshold_LTVal_8u_C1IR
//              ippiThreshold_LTVal_8u_C3IR
//              ippiThreshold_LTVal_8u_AC4IR
//              ippiThreshold_LTVal_16s_C1IR
//              ippiThreshold_LTVal_16s_C3IR
//              ippiThreshold_LTVal_16s_AC4IR
//              ippiThreshold_LTVal_32f_C1IR
//              ippiThreshold_LTVal_32f_C3IR
//              ippiThreshold_LTVal_32f_AC4IR
//              ippiThreshold_LTVal_8u_C4R
//              ippiThreshold_LTVal_16s_C4R
//              ippiThreshold_LTVal_32f_C4R
//              ippiThreshold_LTVal_8u_C4IR
//              ippiThreshold_LTVal_16s_C4IR
//              ippiThreshold_LTVal_32f_C4IR
//              ippiThreshold_LTVal_16u_C1R
//              ippiThreshold_LTVal_16u_C3R
//              ippiThreshold_LTVal_16u_AC4R
//              ippiThreshold_LTVal_16u_C1IR
//              ippiThreshold_LTVal_16u_C3IR
//              ippiThreshold_LTVal_16u_AC4IR
//              ippiThreshold_LTVal_16u_C4R
//              ippiThreshold_LTVal_16u_C4IR
//
//  Purpose:  Performs thresholding of pixel values: pixels that are
//            less than threshold, are set to a specified value
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     roiSize has a field with zero or negative value
//   ippStsStepErr     One of the step values is zero or negative
//
//  Parameters:
//   pSrc       Pointer to the source image
//   srcStep    Step through the source image
//   pDst       Pointer to the destination image
//   dstStep    Step through the destination image
//   pSrcDst    Pointer to the source/destination image (in-place flavors)
//   srcDstStep Step through the source/destination image (in-place flavors)
//   roiSize    Size of the ROI
//   threshold  Threshold level value (array of values for multi-channel data)
//   value      The output value (array or values for multi-channel data)
*)
  ippiThreshold_LTVal_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;
  ippiThreshold_LTVal_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;
  ippiThreshold_LTVal_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;
  ippiThreshold_LTVal_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;threshold:Ipp16u;value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16u;value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;
  ippiThreshold_LTVal_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16u;var value:Ipp16u):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiThreshold_LTValGTVal_8u_C1R
//              ippiThreshold_LTValGTVal_8u_C3R
//              ippiThreshold_LTValGTVal_8u_AC4R
//              ippiThreshold_LTValGTVal_16s_C1R
//              ippiThreshold_LTValGTVal_16s_C3R
//              ippiThreshold_LTValGTVal_16s_AC4R
//              ippiThreshold_LTValGTVal_32f_C1R
//              ippiThreshold_LTValGTVal_32f_C3R
//              ippiThreshold_LTValGTVal_32f_AC4R
//              ippiThreshold_LTValGTVal_16u_C1R
//              ippiThreshold_LTValGTVal_16u_C3R
//              ippiThreshold_LTValGTVal_16u_AC4R
//
//  Purpose:    Performs double thresholding of pixel values
//  Returns:
//   ippStsNoErr        OK
//   ippStsNullPtrErr   One of the pointers is NULL
//   ippStsSizeErr      roiSize has a field with zero or negative value
//   ippStsThresholdErr thresholdLT > thresholdGT
//   ippStsStepErr      One of the step values is zero or negative
//
//  Parameters:
///  Parameters:
//   pSrc        Pointer to the source image
//   srcStep     Step through the source image
//   pDst        Pointer to the destination image
//   dstStep     Step through the destination image
//   pSrcDst     Pointer to the source/destination image (in-place flavors)
//   srcDstStep  Step through the source/destination image (in-place flavors)
//   roiSize     Size of the ROI
//   thresholdLT Lower threshold value (array of values for multi-channel data)
//   valueLT     Lower output value (array or values for multi-channel data)
//   thresholdGT Upper threshold value (array of values for multi-channel data)
//   valueGT     Upper output value (array or values for multi-channel data)
*)
  ippiThreshold_LTValGTVal_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp8u;valueLT:Ipp8u;thresholdGT:Ipp8u;valueGT:Ipp8u):IppStatus;
  ippiThreshold_LTValGTVal_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp16s;valueLT:Ipp16s;thresholdGT:Ipp16s;valueGT:Ipp16s):IppStatus;
  ippiThreshold_LTValGTVal_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp32f;valueLT:Ipp32f;thresholdGT:Ipp32f;valueGT:Ipp32f):IppStatus;
  ippiThreshold_LTValGTVal_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;
  ippiThreshold_LTValGTVal_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;
  ippiThreshold_LTValGTVal_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;
  ippiThreshold_LTValGTVal_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;
  ippiThreshold_LTValGTVal_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;
  ippiThreshold_LTValGTVal_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;
  ippiThreshold_LTValGTVal_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp8u;valueLT:Ipp8u;thresholdGT:Ipp8u;valueGT:Ipp8u):IppStatus;
  ippiThreshold_LTValGTVal_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp16s;valueLT:Ipp16s;thresholdGT:Ipp16s;valueGT:Ipp16s):IppStatus;
  ippiThreshold_LTValGTVal_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp32f;valueLT:Ipp32f;thresholdGT:Ipp32f;valueGT:Ipp32f):IppStatus;
  ippiThreshold_LTValGTVal_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;
  ippiThreshold_LTValGTVal_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;
  ippiThreshold_LTValGTVal_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;
  ippiThreshold_LTValGTVal_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;
  ippiThreshold_LTValGTVal_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;
  ippiThreshold_LTValGTVal_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;

  ippiThreshold_LTValGTVal_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp16u;valueLT:Ipp16u;thresholdGT:Ipp16u;valueGT:Ipp16u):IppStatus;
  ippiThreshold_LTValGTVal_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16u;var valueLT:Ipp16u;var thresholdGT:Ipp16u;var valueGT:Ipp16u):IppStatus;
  ippiThreshold_LTValGTVal_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16u;var valueLT:Ipp16u;var thresholdGT:Ipp16u;var valueGT:Ipp16u):IppStatus;
  ippiThreshold_LTValGTVal_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp16u;valueLT:Ipp16u;thresholdGT:Ipp16u;valueGT:Ipp16u):IppStatus;
  ippiThreshold_LTValGTVal_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16u;var valueLT:Ipp16u;var thresholdGT:Ipp16u;var valueGT:Ipp16u):IppStatus;
  ippiThreshold_LTValGTVal_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16u;var valueLT:Ipp16u;var thresholdGT:Ipp16u;var valueGT:Ipp16u):IppStatus;

(*F/////////////////////////////////////////////////////////////////////////////////
//  Name: ippiComputeThreshold_Otsu_8u_C1R
//
//  Purpose: Calculate Otsu theshold value of images
//    Return:
//      ippStsNoErr              Ok
//      ippStsNullPtrErr         One of pointers is NULL
//      ippStsSizeErr            The width or height of images is less or equal zero
//      ippStsStepErr            The steps in images is less ROI
//    Parameters:
//      pSrc                     Pointer to image
//      srcStep                  Image step
//      roiSize                  Size of image ROI
//      pThreshold               Returned Otsu theshold value
//
//F*)

  ippiComputeThreshold_Otsu_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pThreshold:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                     Adaptive threshold functions
// /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiThresholdAdaptiveBoxGetBufferSize
//              ippiThresholdAdaptiveGaussGetBufferSize
//  Purpose:    to define spec and buffer sizes for adaptive threshold
//  Parameters:
//   roiSize       Size of the destination ROI in pixels.
//   maskSize      Size of kernel for calculation of threshold level.
//                 Width and height of maskSize must be equal and odd.
//   dataType      Data type of the source and destination images. Possible value is ipp8u.
//   numChannels   Number of channels in the images. Possible value is 1.
//   pSpecSize     Pointer to the computed value of the spec size.
//   pBufferSize   Pointer to the computed value of the external buffer size.
//  Return:
//    ippStsNoErr               OK
//    ippStsNullPtrErr          any pointer is NULL
//    ippStsSizeErr             size of dstRoiSize is less or equal 0
//    ippStsMaskSizeErr         fields of maskSize are not equak or ones are less or equal 0
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsNumChannelsErr      Indicates an error when numChannels has an illegal value.
*)
  ippiThresholdAdaptiveBoxGetBufferSize: function(roiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;
  ippiThresholdAdaptiveGaussGetBufferSize: function(roiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;pSpecSize:Plongint;pBufferSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFilterThresholdGaussAdaptiveInit
//  Purpose:    initialization of Spec for adaptive threshold
//  Parameters:
//   roiSize       Size of the destination ROI in pixels.
//   maskSize      Size of kernel for calculation of threshold level.
//                 Width and height of maskSize must be equal and odd.
//   dataType      Data type of the source and destination images. Possible value is ipp8u.
//   numChannels   Number of channels in the images. Possible value is 1.
//   sigma         value of sigma for calculation of threshold level for Gauss-method,
//                 if sigma value is less or equal zero than sigma is set automatically
//                 in compliance with kernel size, in this cases
//                 sigma = 0.3*(maskSize.width-1)*0.5-1)+0.8;
//   pSpec         pointer to Spec
//  Return:
//    ippStsNoErr               OK
//    ippStsNullPtrErr          pointer to Spec is NULL
//    ippStsSizeErr             size of dstRoiSize is less or equal 0
//    ippStsMaskSizeErr         size of kernel for calculation of threshold level.
//                              Width and height of maskSize must be equal and odd.
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsNumChannelsErr      Indicates an error when numChannels has an illegal value.
*)
  ippiThresholdAdaptiveGaussInit: function(roiSize:IppiSize;maskSize:IppiSize;dataType:IppDataType;numChannels:longint;sigma:Ipp32f;pSpec:PIppiThresholdAdaptiveSpec):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiThresholdAdaptiveBox_8u_C1R
//              ippiThresholdAdaptiveThreshold_8u_C1R
//  Purpose:    to executes adaptive threshold operation
//  Parameters:
//   pSrc          Pointer to the source image ROI.
//   srcStep       Distance in bytes between starts of consecutive lines in the source image.
//   pDst          Pointer to the destination image ROI.
//   dstStep       Distance in bytes between starts of consecutive lines in the destination image.
//   dstRoiSize    Size of the destination ROI in pixels.
//   maskSize      Size of kernel for calculation of threshold level.
//                 Width and height of maskSize must be equal and odd.
//   delta         value for calculation of threshold (subtrahend).
//   valGT         output pixel if source pixel is great then threshold.
//   valLE         output pixel if source pixel is less or equal threshold.
/    borderType    Type of border.
//   borderValue   Constant value to assign to pixels of the constant border. This parameter is applicable
//                 only to the ippBorderConst border type.
//   pSpecSize     Pointer to the computed value of the spec size.
//   pBufferSize   Pointer to the computed value of the external buffer size.
//  Return:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      any pointer is NULL
//    ippStsSizeErr         size of dstRoiSize is less or equal 0
//    ippStsMaskSizeErr     one of the fields of maskSize has a negative or zero value or
//                          if the fields of maskSize are not equal
//    ippStsContextMatchErr spec is not match
//    ippStsBorderErr       Indicates an error when borderType has illegal value.
//
//     Output pixels are calculated such:
//     pDst(x,y) = valGT if (pSrc(x,y) > T(x,y))
//     and
//     pDst(x,y) = valLE if (pSrc(x,y) <= T(x,y))

//     For ippiThresholdAdaptiveBox_8u_C1R:
//     T(x,y) is a mean of the kernelSize.width*kernelSize.height neighborhood of (x,y)-pixel
//     minus delta.
//
//     For ippiThresholdAdaptiveGauss_8u_C1R:
//     T(x,y) is a weighted sum (cross-correlation with a Gaussian window) of
//     the kernelSize.width*kernelSize.height neighborhood of (x,y)-pixel minus delta.
//     Coefficients of Gaussian window is separable.
//     Coefficients for row of separable Gaussian window:
//     Gi = A * exp(-(i-(kernelSize.width-1)/2)^2/(0.5 * sigma^2),
//     A is scale factor for
//     SUM(Gi) = 1 (i = 0,...,maskSize.width-1).
*)
  ippiThresholdAdaptiveBox_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;maskSize:IppiSize;delta:Ipp32f;valGT:Ipp8u;valLE:Ipp8u;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiThresholdAdaptiveGauss_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;delta:Ipp32f;valGT:Ipp8u;valLE:Ipp8u;borderType:IppiBorderType;borderValue:Ipp8u;pSpec:PIppiThresholdAdaptiveSpec;pBuffer:PIpp8u):IppStatus;
  ippiThresholdAdaptiveBox_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;delta:Ipp32f;valGT:Ipp8u;valLE:Ipp8u;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiThresholdAdaptiveGauss_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;delta:Ipp32f;valGT:Ipp8u;valLE:Ipp8u;borderType:IppiBorderType;borderValue:Ipp8u;pSpec:PIppiThresholdAdaptiveSpec;pBuffer:PIpp8u):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//                   Convert and Initialization functions
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyManaged
//
//  Purpose:  copy pixel values from the source image to the destination  image
//
//
//  Returns:
//    ippStsNullPtrErr  One of the pointers is NULL
//    ippStsSizeErr     roiSize has a field with zero or negative value
//    ippStsNoErr       OK
//
//  Parameters:
//    pSrc              Pointer  to the source image buffer
//    srcStep           Step in bytes through the source image buffer
//    pDst              Pointer to the  destination image buffer
//    dstStep           Step in bytes through the destination image buffer
//    roiSize           Size of the ROI
//    flags             The logic sum of tags sets type of copying.
//                      (IPP_TEMPORAL_COPY,IPP_NONTEMPORAL_STORE etc.)
*)

  ippiCopyManaged_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flags:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopy
//
//  Purpose:  copy pixel values from the source image to the destination  image
//
//
//  Returns:
//    ippStsNullPtrErr  One of the pointers is NULL
//    ippStsSizeErr     roiSize has a field with zero or negative value
//    ippStsNoErr       OK
//
//  Parameters:
//    pSrc              Pointer  to the source image buffer
//    srcStep           Step in bytes through the source image buffer
//    pDst              Pointer to the  destination image buffer
//    dstStep           Step in bytes through the destination image buffer
//    roiSize           Size of the ROI
//    pMask             Pointer to the mask image buffer
//    maskStep          Step in bytes through the mask image buffer
*)

  ippiCopy_8u_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C1C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C4C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C1C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C3CR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C4CR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_AC4C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C3AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C1MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_8u_C3MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_8u_C4MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_8u_AC4MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16s_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C1C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C4C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C1C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C3CR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C4CR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_AC4C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C3AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C1MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16s_C3MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16s_C4MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16s_AC4MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C1C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C4C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C1C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C3CR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C4CR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_AC4C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C3AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C1MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32f_C3MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32f_C4MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32f_AC4MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_C4P4R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_8u_P4C4R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C3P3R: function(pSrc:PIpp16s;srcStep:longint;var pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_P3C3R: function(var pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_C4P4R: function(pSrc:PIpp16s;srcStep:longint;var pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16s_P4C4R: function(var pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C3P3R: function(pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_P3C3R: function(var pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_C4P4R: function(pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32f_P4C4R: function(var pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C3C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C1C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C4C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C1C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C3CR: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C4CR: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_AC4C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C3AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C1MR: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32s_C3MR: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32s_C4MR: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32s_AC4MR: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_32s_C3P3R: function(pSrc:PIpp32s;srcStep:longint;var pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_P3C3R: function(var pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_C4P4R: function(pSrc:PIpp32s;srcStep:longint;var pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_32s_P4C4R: function(var pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiCopy_16u_C3C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C1C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C4C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C1C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C3CR: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C4CR: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_AC4C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C3AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C1MR: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16u_C3MR: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16u_C4MR: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiCopy_16u_AC4MR: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;

  ippiCopy_16u_C3P3R: function(pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_P3C3R: function(var pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_C4P4R: function(pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiCopy_16u_P4C4R: function(var pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyReplicateBorder
//
//  Purpose:   Copies pixel values between two buffers and adds
//             the replicated border pixels.
//
//  Returns:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                        2). topBorderHeight or leftBorderWidth is less than zero
//                        3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                        4). dstRoiSize.height < srcRoiSize.height + topBorderHeight
//    ippStsStepErr       srcStep or dstStep is less than or equal to zero
//    ippStsNoErr         OK
//
//  Parameters:
//    pSrc                Pointer  to the source image buffer
//    srcStep             Step in bytes through the source image
//    pDst                Pointer to the  destination image buffer
//    dstStep             Step in bytes through the destination image
//    scrRoiSize          Size of the source ROI in pixels
//    dstRoiSize          Size of the destination ROI in pixels
//    topBorderHeight     Height of the top border in pixels
//    leftBorderWidth     Width of the left border in pixels
*)

  ippiCopyReplicateBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;

  ippiCopyReplicateBorder_8u_C1IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_8u_C3IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_8u_AC4IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_8u_C4IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyReplicateBorder_16s_C1IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_C3IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_AC4IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_16s_C4IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyReplicateBorder_32s_C1IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_C3IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_AC4IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_32s_C4IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyReplicateBorder_16u_C1IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_16u_C3IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_16u_AC4IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_16u_C4IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyReplicateBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;

  ippiCopyReplicateBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyReplicateBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;

  ippiCopyReplicateBorder_32f_C1IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_32f_C3IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_32f_AC4IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyReplicateBorder_32f_C4IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyConstBorder
//
//  Purpose:    Copies pixel values between two buffers and adds
//              the border pixels with constant value.
//
//  Returns:
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                       2). topBorderHeight or leftBorderWidth is less than zero
//                       3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                       4). dstRoiSize.height < srcRoiSize.height + topBorderHeight
//    ippStsStepErr      srcStep or dstStep is less than or equal to zero
//    ippStsNoErr        OK
//
//  Parameters:
//    pSrc               Pointer  to the source image buffer
//    srcStep            Step in bytes through the source image
//    pDst               Pointer to the  destination image buffer
//    dstStep            Step in bytes through the destination image
//    srcRoiSize         Size of the source ROI in pixels
//    dstRoiSize         Size of the destination ROI in pixels
//    topBorderHeight    Height of the top border in pixels
//    leftBorderWidth    Width of the left border in pixels
//    value              Constant value to assign to the border pixels
*)

  ippiCopyConstBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;value:Ipp8u):IppStatus;
  ippiCopyConstBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp8u):IppStatus;
  ippiCopyConstBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp8u):IppStatus;
  ippiCopyConstBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp8u):IppStatus;
  ippiCopyConstBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;value:Ipp16s):IppStatus;
  ippiCopyConstBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp16s):IppStatus;
  ippiCopyConstBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp16s):IppStatus;
  ippiCopyConstBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp16s):IppStatus;
  ippiCopyConstBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;value:Ipp32s):IppStatus;
  ippiCopyConstBorder_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp32s):IppStatus;
  ippiCopyConstBorder_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp32s):IppStatus;
  ippiCopyConstBorder_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp32s):IppStatus;

  ippiCopyConstBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;value:Ipp16u):IppStatus;
  ippiCopyConstBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp16u):IppStatus;
  ippiCopyConstBorder_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp16u):IppStatus;
  ippiCopyConstBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp16u):IppStatus;

  ippiCopyConstBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;value:Ipp32f):IppStatus;
  ippiCopyConstBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp32f):IppStatus;
  ippiCopyConstBorder_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp32f):IppStatus;
  ippiCopyConstBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint;var value:Ipp32f):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyMirrorBorder
//
//  Purpose:   Copies pixel values between two buffers and adds
//             the mirror border pixels.
//
//  Returns:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                        2). topBorderHeight or leftBorderWidth is less than zero
//                        3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                        4). dstRoiSize.height < srcRoiSize.height + topBorderHeight
//    ippStsStepErr       srcStep or dstStep is less than or equal to zero
//    ippStsNoErr         OK
//
//  Parameters:
//    pSrc                Pointer  to the source image buffer
//    srcStep             Step in bytes through the source image
//    pDst                Pointer to the  destination image buffer
//    dstStep             Step in bytes through the destination image
//    scrRoiSize          Size of the source ROI in pixels
//    dstRoiSize          Size of the destination ROI in pixels
//    topBorderHeight     Height of the top border in pixels
//    leftBorderWidth     Width of the left border in pixels
*)

  ippiCopyMirrorBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;

  ippiCopyMirrorBorder_8u_C1IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_8u_C3IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_8u_C4IR: function(pSrc:PIpp8u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyMirrorBorder_16s_C1IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_16s_C3IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_16s_C4IR: function(pSrc:PIpp16s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyMirrorBorder_32s_C1IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_32s_C3IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_32s_C4IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyMirrorBorder_16u_C1IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_16u_C3IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_16u_C4IR: function(pSrc:PIpp16u;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyMirrorBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;

  ippiCopyMirrorBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyMirrorBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;

  ippiCopyMirrorBorder_32f_C1IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_32f_C3IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;
  ippiCopyMirrorBorder_32f_C4IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyWrapBorder
//
//  Purpose:    Copies pixel values between two buffers and adds the border pixels.
//
//  Returns:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                        2). topBorderHeight or leftBorderWidth is less than zero
//                        3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                        4). dstRoiSize.height < srcRoiSize.height + topBorderHeight
//    ippStsStepErr       srcStep or dstStep is less than or equal to zero
//    ippStsNoErr         OK
//
//  Parameters:
//    pSrc                Pointer  to the source image buffer
//    srcStep             Step in bytes through the source image
//    pDst                Pointer to the  destination image buffer
//    dstStep             Step in bytes through the destination image
//    scrRoiSize          Size of the source ROI in pixels
//    dstRoiSize          Size of the destination ROI in pixels
//    topBorderHeight     Height of the top border in pixels
//    leftBorderWidth     Width of the left border in pixels
*)

  ippiCopyWrapBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyWrapBorder_32s_C1IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

  ippiCopyWrapBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;topBorderHeight:longint;leftBorderWidth:longint):IppStatus;
  ippiCopyWrapBorder_32f_C1IR: function(pSrc:PIpp32f;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topBorderHeight:longint;leftborderwidth:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDup
//
//  Purpose:  Duplication pixel values from the source image
//            to the correspondent pixels in all channels
//            of the destination  image.
//
//  Returns:
//    ippStsNullPtrErr  One of the pointers is NULL
//    ippStsSizeErr     roiSize has a field with zero or negative value
//    ippStsNoErr       OK
//
//  Parameters:
//    pSrc              Pointer  to the source image buffer
//    srcStep           Step in bytes through the source image buffer
//    pDst              Pointer to the  destination image buffer
//    dstStep           Step in bytes through the destination image buffer
//    roiSize           Size of the ROI
*)

  ippiDup_8u_C1C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiDup_8u_C1C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiSet
//
//  Purpose:    Sets pixels in the image buffer to a constant value
//
//  Returns:
//    ippStsNullPtrErr  One of pointers is NULL
//    ippStsSizeErr     roiSize has a field with negative or zero value
//    ippStsNoErr       OK
//
//  Parameters:
//    value      Constant value assigned to each pixel in the image buffer
//    pDst       Pointer to the destination image buffer
//    dstStep    Step in bytes through the destination image buffer
//    roiSize    Size of the ROI
//    pMask      Pointer to the mask image buffer
//    maskStep   Step in bytes through the mask image buffer
*)

  ippiSet_8u_C1R: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_8u_C3CR: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_8u_C4CR: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_8u_C3R: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_8u_C4R: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_8u_AC4R: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_8u_C1MR: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_8u_C3MR: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;

  ippiSet_8u_C4MR: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_8u_AC4MR: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16s_C1R: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16s_C3CR: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16s_C4CR: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16s_C3R: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16s_C4R: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16s_AC4R: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16s_C1MR: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16s_C3MR: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16s_C4MR: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16s_AC4MR: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32f_C1R: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiSet_32f_C3CR: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32f_C4CR: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32f_C3R: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32f_C4R: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32f_AC4R: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32f_C1MR: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32f_C3MR: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32f_C4MR: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32f_AC4MR: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32s_C1R: function(value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiSet_32s_C3CR: function(value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32s_C4CR: function(value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32s_C3R: function(var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32s_C4R: function(var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32s_AC4R: function(var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_32s_C1MR: function(value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32s_C3MR: function(var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32s_C4MR: function(var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_32s_AC4MR: function(var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;

  ippiSet_16u_C1R: function(value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16u_C3CR: function(value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16u_C4CR: function(value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16u_C3R: function(var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16u_C4R: function(var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16u_AC4R: function(var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiSet_16u_C1MR: function(value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16u_C3MR: function(var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16u_C4MR: function(var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;
  ippiSet_16u_AC4MR: function(var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;

(* //////////////////////////////////////////////////////////////////////////////////
//  Name:  ippiAddRandUniform_8u_C1IR,  ippiAddRandUniform_8u_C3IR,
//         ippiAddRandUniform_8u_C4IR,  ippiAddRandUniform_8u_AC4IR,
//         ippiAddRandUniform_16s_C1IR, ippiAddRandUniform_16s_C3IR,
//         ippiAddRandUniform_16s_C4IR, ippiAddRandUniform_16s_AC4IR,
//         ippiAddRandUniform_32f_C1IR, ippiAddRandUniform_32f_C3IR,
//         ippiAddRandUniform_32f_C4IR, ippiAddRandUniform_32f_AC4IR
//         ippiAddRandUniform_16u_C1IR, ippiAddRandUniform_16u_C3IR,
//         ippiAddRandUniform_16u_C4IR, ippiAddRandUniform_16u_AC4IR,
//
//  Purpose:    Generates pseudo-random samples with uniform distribution and adds them
//              to an image.
//
//  Returns:
//    ippStsNoErr          OK
//    ippStsNullPtrErr     One of the pointers is NULL
//    ippStsSizeErr        roiSize has a field with zero or negative value
//    ippStsStepErr        The step in image is less than or equal to zero
//
//  Parameters:
//    pSrcDst              Pointer to the image
//    srcDstStep           Step in bytes through the image
//    roiSize              ROI size
//    low                  The lower bounds of the uniform distributions range
//    high                 The upper bounds of the uniform distributions range
//    pSeed                Pointer to the seed value for the pseudo-random number
//                          generator
*)

  ippiAddRandUniform_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;

  ippiAddRandUniform_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;low:Ipp16u;high:Ipp16u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;low:Ipp16u;high:Ipp16u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;low:Ipp16u;high:Ipp16u;pSeed:PlongWord):IppStatus;
  ippiAddRandUniform_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;low:Ipp16u;high:Ipp16u;pSeed:PlongWord):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddRandGauss_8u_C1IR,  ippiAddRandGauss_8u_C3IR,
//              ippiAddRandGauss_8u_C4IR,  ippiAddRandGauss_8u_AC4IR
//              ippiAddRandGauss_16s_C1IR, ippiAddRandGauss_16s_C3IR,
//              ippiAddRandGauss_16s_C4IR, ippiAddRandGauss_16s_AC4IR,
//              ippiAddRandGauss_32f_C1IR, ippiAddRandGauss_32f_C3IR,
//              ippiAddRandGauss_32f_C4IR, ippiAddRandGauss_32f_AC4IR
//              ippiAddRandGauss_16u_C1IR, ippiAddRandGauss_16u_C3IR,
//              ippiAddRandGauss_16u_C4IR, ippiAddRandGauss_16u_AC4IR,
//
//  Purpose:    Generates pseudo-random samples with normal distribution and adds them
//              to an image.
//
//  Returns:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         roiSize has a field with zero or negative value
//    ippStsStepErr         The step value is less than or equal to zero
//
//  Parameters:
//    pSrcDst               Pointer to the image
//    srcDstStep            Step in bytes through the image
//    roiSize               ROI size
//    mean                  The mean of the normal distribution
//    stdev                 The standard deviation of the normal distribution
//    pSeed                 Pointer to the seed value for the pseudo-random number
//                             generator
*)


  ippiAddRandGauss_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;

  ippiAddRandGauss_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16u;stdev:Ipp16u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16u;stdev:Ipp16u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16u;stdev:Ipp16u;pSeed:PlongWord):IppStatus;
  ippiAddRandGauss_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16u;stdev:Ipp16u;pSeed:PlongWord):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////////////
//  Name:               ippiImageJaehne
//  Purpose:            Creates Jaenne's test image
//  Returns:
//    ippStsNoErr       No error
//    ippStsNullPtrErr  pDst pointer is NULL
//    ippStsSizeErr     roiSize has a field with zero or negative value, or
//                      srcDstStep has a zero or negative value
//  Parameters:
//    pDst              Pointer to the destination buffer
//    DstStep           Step in bytes through the destination buffer
//    roiSize           Size of the destination image ROI in pixels
//  Notes:
//                      Dst(x,y,) = A*Sin(0.5*IPP_PI* (x2^2 + y2^2) / roiSize.height),
//                      x variables from 0 to roi.width-1,
//                      y variables from 0 to roi.height-1,
//                      x2 = (x-roi.width+1)/2.0 ,   y2 = (y-roi.height+1)/2.0 .
//                      A is the constant value depends on the image type being created.
*)
  ippiImageJaehne_8u_C1R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_8u_C3R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_8u_C4R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_8u_AC4R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;

  ippiImageJaehne_16u_C1R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_16u_C3R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_16u_C4R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_16u_AC4R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;

  ippiImageJaehne_16s_C1R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_16s_C3R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_16s_C4R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_16s_AC4R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;

  ippiImageJaehne_32f_C1R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_32f_C3R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_32f_C4R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;
  ippiImageJaehne_32f_AC4R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;



(* /////////////////////////////////////////////////////////////////////////
// Name:          ippiImageRamp
// Purpose:       Creates an ippi test image with an intensity ramp.
// Parameters:
//    pDst        - Pointer to the destination buffer.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    roiSize     - Size, in pixels, of the destination image ROI.
//    offset      - Offset value.
//    slope       - Slope coefficient.
//    axis        - Specifies the direction of the image intensity ramp, possible values:
//                      ippAxsHorizontal   in X-direction,
//                      ippAxsVertical     in Y-direction,
//                      ippAxsBoth         in both X and Y-directions.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsStepErr    - Error when dstStep has a zero or negative value.
//    ippStsSizeErr    - Error when roiSize has a field with value less than 1.
//
// Notes:  Dst(x,y) = offset + slope * x   (if ramp for X-direction)
//         Dst(x,y) = offset + slope * y   (if ramp for Y-direction)
//         Dst(x,y) = offset + slope * x*y (if ramp for X,Y-direction)
*)
  ippiImageRamp_8u_C1R: function(pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_8u_C3R: function(pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_8u_C4R: function(pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_8u_AC4R: function(pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;

  ippiImageRamp_16u_C1R: function(pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_16u_C3R: function(pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_16u_C4R: function(pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_16u_AC4R: function(pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;

  ippiImageRamp_16s_C1R: function(pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_16s_C3R: function(pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_16s_C4R: function(pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_16s_AC4R: function(pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;

  ippiImageRamp_32f_C1R: function(pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_32f_C3R: function(pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_32f_C4R: function(pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;
  ippiImageRamp_32f_AC4R: function(pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;



(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiConvert
//
//  Purpose:    Converts pixel values of an image from one bit depth to another
//
//  Returns:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         roiSize has a field with zero or negative value
//    ippStsStepErr         srcStep or dstStep has zero or negative value
//    ippStsNoErr           OK
//
//  Parameters:
//    pSrc                  Pointer  to the source image
//    srcStep               Step through the source image
//    pDst                  Pointer to the  destination image
//    dstStep               Step in bytes through the destination image
//    roiSize               Size of the ROI
//    roundMode             Rounding mode, ippRndZero or ippRndNear
*)
  ippiConvert_8u8s_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_8u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u16u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u16u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u16s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u16s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u16s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_8u32s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u32s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u32s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u32s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;


  ippiConvert_8s8u_C1Rs: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roi:IppiSize):IppStatus;
  ippiConvert_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roi:IppiSize):IppStatus;
  ippiConvert_8s16u_C1Rs: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16u;dstStep:longint;roi:IppiSize):IppStatus;
  ippiConvert_8s32u_C1Rs: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32u;dstStep:longint;roi:IppiSize):IppStatus;

  ippiConvert_8s32s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8s32s_C3R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8s32s_AC4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8s32s_C4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;


  ippiConvert_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u8u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u8u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u8u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_16u8s_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_16u16s_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_16u32u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32u;dstStep:longint;roi:IppiSize):IppStatus;

  ippiConvert_16u32s_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u32s_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u32s_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u32s_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u32f_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u32f_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16u32f_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;


  ippiConvert_16s8s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_16s8u_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s8u_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s8u_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s8u_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_16s16u_C1Rs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16u;dstStep:longint;roi:IppiSize):IppStatus;
  ippiConvert_16s32u_C1Rs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32u;dstStep:longint;roi:IppiSize):IppStatus;

  ippiConvert_16s32s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s32s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s32s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s32s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s32f_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s32f_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_16s32f_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;


  ippiConvert_32u8u_C1RSfs: function(pSrc:PIpp32u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32u8s_C1RSfs: function(pSrc:PIpp32u;srcStep:longint;pDst:PIpp8s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32u16u_C1RSfs: function(pSrc:PIpp32u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32u16s_C1RSfs: function(pSrc:PIpp32u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32u32s_C1RSfs: function(pSrc:PIpp32u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32u32f_C1R: function(pSrc:PIpp32u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roi:IppiSize):IppStatus;


  ippiConvert_32s8u_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_32s8u_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_32s8u_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_32s8u_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_32s8s_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_32s8s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_32s8s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiConvert_32s8s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiConvert_32s16u_C1RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp16u;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32s16s_C1RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32s32u_C1Rs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32u;dstStep:longint;roi:IppiSize):IppStatus;
  ippiConvert_32s32f_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roi:IppiSize):IppStatus;


  ippiConvert_32f8u_C1RSfs: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roi:IppiSize;round:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f8u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f8u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f8u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;

  ippiConvert_32f8s_C1RSfs: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roi:IppiSize;round:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_32f8s_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f8s_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f8s_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f8s_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;

  ippiConvert_32f16u_C1RSfs: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roi:IppiSize;round:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_32f16u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f16u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f16u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f16u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;

  ippiConvert_32f16s_C1RSfs: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roi:IppiSize;round:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_32f16s_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f16s_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f16s_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;
  ippiConvert_32f16s_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;

  ippiConvert_32f32u_C1RSfs: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32u;dstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_32f32u_C1IRSfs: function(pSrcDst:PIpp32u;srcDstStep:longint;roi:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_32f32s_C1RSfs: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32s;dstStep:longint;roi:IppiSize;round:IppRoundMode;scaleFactor:longint):IppStatus;

  ippiConvert_64f8u_C1RSfs: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_64f8s_C1RSfs: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_64f16u_C1RSfs: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_64f16s_C1RSfs: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiConvert_8s64f_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize):IppStatus;


(* ////////////////////////////////////////////////////////////////////////////
// Name:          ippiScaleC
//
// Purpose:       Converts data with scaling by formula: dst = src*Val + aVal
//
// Parameters:
//    pSrc    - Pointer to the source image ROI.
//    srcStep - Distance, in bytes, between the starting points of consecutive lines in the source image.
//    mVal    - Multiply value for scaling.
//    aVal    - Add value for scaling.
//    pDst    - Pointer to the destination image ROI.
//    dstStep - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    roiSize - Size of the ROI.
//    hint    - Option to specify the computation algorithm: ippAlgHintFast(default) or ippAlgHintAccurate.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsStepErr    - Error when srcStep or dstStep has a zero or negative value.
//    ippStsSizeErr    - Error when roiSize has a zero or negative value.
*)
  ippiScaleC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8u8s_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8u32s_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8u64f_C1R: function(pSrc:PIpp8u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_8s8u_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s16u_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s32s_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s64f_C1R: function(pSrc:PIpp8s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u8s_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u16s_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u32s_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u64f_C1R: function(pSrc:PIpp16u;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_16s8u_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s8s_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s16u_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s32s_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s64f_C1R: function(pSrc:PIpp16s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_32s8u_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s8s_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s16u_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s16s_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s32f_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s64f_C1R: function(pSrc:PIpp32s;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f8s_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f16u_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f16s_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f32s_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f64f_C1R: function(pSrc:PIpp32f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_64f8u_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f8s_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f16u_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f16s_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f32s_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f32f_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;mVal:Ipp64f;aVal:Ipp64f;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScaleC_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_8s_C1IR: function(pSrcDst:PIpp8s;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32s_C1IR: function(pSrcDst:PIpp32s;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScaleC_64f_C1IR: function(pSrcDst:PIpp64f;srcDstStep:longint;mVal:Ipp64f;aVal:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
// Name:       ippiBinToGray_1u{8u|16u|16s|32f}_C1R,
//             ippiGrayToBin_{8u|16u|16s|32f}1u_C1R
// Purpose:    Converts a bitonal image to an 8u,16u,16s, or 32f grayscale image and vice versa.
//
// Parameters:
//    pSrc         - Pointer to the source image ROI.
//    srcStep      - Distance, in bytes, between the starting points of consecutive lines in the source image.
//    srcBitOffset - Offset (in bits) from the first byte of the source image row.
//    pDst         - Pointer to the destination image ROI.
//    dstStep      - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    dstBitOffset - Offset (in bits) from the first byte of the destination image row.
//    roiSize      - Size of the ROI.
//    loVal        - Destination value that corresponds to the "0" value of the corresponding source element.
//    hiVal        - Destination value that corresponds to the "1" value of the corresponding source element.
//    threahold    - Threshold level.
// Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when :
//                         roiSize has a zero or negative value.
//                         srcBitOffset or dstBitOffset is less than zero.
//    ippStsStepErr    - Error when srcStep or dstStep has a zero or negative value.
*)
  ippiBinToGray_1u8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcBitOffset:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;loVal:Ipp8u;hiVal:Ipp8u):IppStatus;
  ippiBinToGray_1u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcBitOffset:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;loVal:Ipp16u;hiVal:Ipp16u):IppStatus;
  ippiBinToGray_1u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;srcBitOffset:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;loVal:Ipp16s;hiVal:Ipp16s):IppStatus;
  ippiBinToGray_1u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcBitOffset:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;loVal:Ipp32f;hiVal:Ipp32f):IppStatus;

  ippiGrayToBin_8u1u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstBitOffset:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;
  ippiGrayToBin_16u1u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstBitOffset:longint;roiSize:IppiSize;threshold:Ipp16u):IppStatus;
  ippiGrayToBin_16s1u_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstBitOffset:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;
  ippiGrayToBin_32f1u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstBitOffset:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:            ippiPolarToCart
//
//  Purpose:     Converts an image in the polar coordinate form to Cartesian
//               coordinate form
//  Parameters:
//   pSrcMagn            Pointer to the source image plane containing magnitudes
//   pSrcPhase           Pointer to the source image plane containing phase values
//   srcStep             Step through the source image
//   pDst                Pointer to the destination image
//   dstStep             Step through the destination image
//   roiSize             Size of the ROI
//  Return:
//   ippStsNullPtrErr    One of the pointers is NULL
//   ippStsSizeErr       height or width of the image is less than 1
//   ippStsStepErr,      if srcStep <= 0 or
//                          dstStep <= 0
//   ippStsNoErr         No errors
*)
  ippiPolarToCart_32fc_C1R: function(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;srcStep:longint;roiSize:IppiSize;pDst:PIpp32fc;dstStep:longint):IppStatus;
  ippiPolarToCart_32fc_C3R: function(pSrcMagn:PIpp32f;pSrcPhase:PIpp32f;srcStep:longint;roiSize:IppiSize;pDst:PIpp32fc;dstStep:longint):IppStatus;



(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiSwapChannels
//
//  Purpose:    Changes the order of channels of the image
//              The function performs operation for each pixel:
//                  pDst[0] = pSrc[ dstOrder[0] ]
//                  pDst[1] = pSrc[ dstOrder[1] ]
//                  pDst[2] = pSrc[ dstOrder[2] ]
//                  pDst[3] = pSrc[ dstOrder[3] ]
//
//  Returns:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         roiSize has a field with zero or negative value
//    ippStsStepErr         One of the step values is less than or equal to zero
//    ippStsChannelOrderErr dstOrder is out of the range,
//                           it should be: dstOrder[3] = { 0..2, 0..2, 0..2 } for C3R, AC4R image
//                           and dstOrder[4] = { 0..3, 0..3, 0..3 } for C4R image
//    ippStsNoErr           OK
//
//  Parameters:
//    pSrc           Pointer  to the source image
//    srcStep        Step in bytes through the source image
//    pDst           Pointer to the  destination image
//    dstStep        Step in bytes through the destination image
//    pSrcDst        Pointer to the source/destination image (in-place flavors)
//    srcDstStep     Step through the source/destination image (in-place flavors)
//    roiSize        Size of the ROI
//    dstOrder       The order of channels in the destination image
*)
  ippiSwapChannels_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;

  ippiSwapChannels_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;

  ippiSwapChannels_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiSwapChannels C3C4R,C4C3R
//
//  Purpose:    Changes the order of channels of the image
//              The function performs operation for each pixel:
//  a) C3C4R.
//    if(dstOrder[i] < 3) dst[i] = src[dstOrder[i]];
//    if(dstOrder[i] == 3) dst[i] = val;
//    if(dstOrder[i] > 3) dst[i] does not change;
//    i = 0,1,2,3
//  b) C4C3R.
//    dst[0] = src [dstOrder[0]];
//    dst[1] = src [dstOrder[1]];
//    dst[2] = src [dstOrder[2]];
//
//  Returns:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         roiSize has a field with zero or negative value
//    ippStsChannelOrderErr dstOrder is out of the range, it should be:
//                            a) C3C4R.
//                              dstOrder[i] => 0, i = 0,1,2,3.
//                            b) C4C3R.
//                              0 <= dstOrder[i] <= 3, i = 0,1,2.
//    ippStsNoErr     OK
//
//  Parameters:
//    pSrc           Pointer  to the source image
//    srcStep        Step in bytes through the source image
//    pDst           Pointer to the  destination image
//    dstStep        Step in bytes through the destination image
//    roiSize        Size of the ROI
//    dstOrder       The order of channels in the destination image
//    val            Constant value for C3C4R
*)
  ippiSwapChannels_8u_C3C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint;val:Ipp8u):IppStatus;
  ippiSwapChannels_8u_C4C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16s_C3C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint;val:Ipp16s):IppStatus;
  ippiSwapChannels_16s_C4C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_16u_C3C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint;val:Ipp16u):IppStatus;
  ippiSwapChannels_16u_C4C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32s_C3C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint;val:Ipp32s):IppStatus;
  ippiSwapChannels_32s_C4C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;
  ippiSwapChannels_32f_C3C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint;val:Ipp32f):IppStatus;
  ippiSwapChannels_32f_C4C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////////
//  Name:       ippiScale
//
//  Purpose:   Scales pixel values of an image and converts them to another bit depth
//              dst = a + b * src;
//              a = type_min_dst - b * type_min_src;
//              b = (type_max_dst - type_min_dst) / (type_max_src - type_min_src).
//
//  Returns:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         roiSize has a field with zero or negative value
//    ippStsStepErr         One of the step values is less than or equal to zero
//    ippStsScaleRangeErr   Input data bounds are incorrect (vMax - vMin <= 0)
//    ippStsNoErr           OK
//
//  Parameters:
//    pSrc            Pointer  to the source image
//    srcStep         Step through the source image
//    pDst            Pointer to the  destination image
//    dstStep         Step through the destination image
//    roiSize         Size of the ROI
//    vMin, vMax      Minimum and maximum values of the input data (32f).
//    hint            Option to select the algorithmic implementation:
//                        1). hint == ippAlgHintAccurate
//                                  - accuracy e-8, but slowly;
//                        2). hint == ippAlgHintFast,
//                                 or ippAlgHintNone
//                                  - accuracy e-3, but quickly.
*)
  ippiScale_8u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u16u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u16u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiScale_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u16s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u16s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u16s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiScale_8u32s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u32s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u32s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiScale_8u32s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;

  ippiScale_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;
  ippiScale_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;
  ippiScale_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;
  ippiScale_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;

  ippiScale_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_16u8u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_16u8u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_16u8u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScale_16s8u_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_16s8u_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_16s8u_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_16s8u_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScale_32s8u_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_32s8u_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_32s8u_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;
  ippiScale_32s8u_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;

  ippiScale_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;
  ippiScale_32f8u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;
  ippiScale_32f8u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;
  ippiScale_32f8u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMin
//  Purpose:        computes the minimum of image pixel values
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step through the source image
//    roiSize     Size of the source image ROI.
//    pMin        Pointer to the result (C1)
//    min         Array containing results (C3, AC4, C4)
*)

  ippiMin_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMin:PIpp8u):IppStatus;
  ippiMin_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u):IppStatus;
  ippiMin_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u):IppStatus;
  ippiMin_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u):IppStatus;

  ippiMin_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMin:PIpp16s):IppStatus;
  ippiMin_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s):IppStatus;
  ippiMin_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s):IppStatus;
  ippiMin_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s):IppStatus;

  ippiMin_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pMin:PIpp16u):IppStatus;
  ippiMin_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u):IppStatus;
  ippiMin_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u):IppStatus;
  ippiMin_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u):IppStatus;

  ippiMin_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMin:PIpp32f):IppStatus;
  ippiMin_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f):IppStatus;
  ippiMin_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f):IppStatus;
  ippiMin_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMinIndx
//  Purpose:        computes the minimum of image pixel values and retrieves
//                  the x and y coordinates of pixels with this value
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pMin        Pointer to the result (C1)
//    min         Array of the results (C3, AC4, C4)
//    pIndexX     Pointer to the x coordinate of the pixel with min value (C1)
//    pIndexY     Pointer to the y coordinate of the pixel with min value (C1)
//    indexX      Array containing the x coordinates of the pixel with min value (C3, AC4, C4)
//    indexY      Array containing the y coordinates of the pixel with min value (C3, AC4, C4)
*)

  ippiMinIndx_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMin:PIpp8u;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMinIndx_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;

  ippiMinIndx_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMin:PIpp16s;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMinIndx_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;

  ippiMinIndx_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pMin:PIpp16u;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMinIndx_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u;var indexX:longint;var indexY:longint):IppStatus;

  ippiMinIndx_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMin:PIpp32f;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMinIndx_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;
  ippiMinIndx_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMax
//  Purpose:        computes the maximum of image pixel values
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pMax        Pointer to the result (C1)
//    max         Array containing the results (C3, AC4, C4)
*)

  ippiMax_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMax:PIpp8u):IppStatus;
  ippiMax_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u):IppStatus;
  ippiMax_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u):IppStatus;
  ippiMax_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u):IppStatus;

  ippiMax_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMax:PIpp16s):IppStatus;
  ippiMax_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s):IppStatus;
  ippiMax_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s):IppStatus;
  ippiMax_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s):IppStatus;

  ippiMax_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pMax:PIpp16u):IppStatus;
  ippiMax_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var max:Ipp16u):IppStatus;
  ippiMax_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var max:Ipp16u):IppStatus;
  ippiMax_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var max:Ipp16u):IppStatus;

  ippiMax_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMax:PIpp32f):IppStatus;
  ippiMax_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f):IppStatus;
  ippiMax_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f):IppStatus;
  ippiMax_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMaxIndx
//  Purpose:        computes the maximum of image pixel values and retrieves
//                  the x and y coordinates of pixels with this value
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pMax        Pointer to the result (C1)
//    max         Array of the results (C3, AC4, C4)
//    pIndexX     Pointer to the x coordinate of the pixel with max value (C1)
//    pIndexY     Pointer to the y coordinate of the pixel with max value (C1)
//    indexX      Array containing the x coordinates of the pixel with max value (C3, AC4, C4)
//    indexY      Array containing the y coordinates of the pixel with max value (C3, AC4, C4)
*)

  ippiMaxIndx_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMax:PIpp8u;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMaxIndx_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;

  ippiMaxIndx_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMax:PIpp16s;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMaxIndx_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;

  ippiMaxIndx_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pMax:PIpp16u;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMaxIndx_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var max:Ipp16u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var max:Ipp16u;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var max:Ipp16u;var indexX:longint;var indexY:longint):IppStatus;

  ippiMaxIndx_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMax:PIpp32f;pIndexX:Plongint;pIndexY:Plongint):IppStatus;
  ippiMaxIndx_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;
  ippiMaxIndx_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMinMax
//  Purpose:        computes the minimum and maximum of image pixel value
//  Returns:        IppStatus
//    ippStsNoErr        OK
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pMin, pMax  Pointers to the results (C1)
//    min, max    Arrays containing the results (C3, AC4, C4)
*)

  ippiMinMax_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMin:PIpp8u;pMax:PIpp8u):IppStatus;
  ippiMinMax_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var max:Ipp8u):IppStatus;
  ippiMinMax_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var max:Ipp8u):IppStatus;
  ippiMinMax_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var max:Ipp8u):IppStatus;

  ippiMinMax_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMin:PIpp16s;pMax:PIpp16s):IppStatus;
  ippiMinMax_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var max:Ipp16s):IppStatus;
  ippiMinMax_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var max:Ipp16s):IppStatus;
  ippiMinMax_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var max:Ipp16s):IppStatus;

  ippiMinMax_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pMin:PIpp16u;pMax:PIpp16u):IppStatus;
  ippiMinMax_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u;var max:Ipp16u):IppStatus;
  ippiMinMax_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u;var max:Ipp16u):IppStatus;
  ippiMinMax_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;var min:Ipp16u;var max:Ipp16u):IppStatus;

  ippiMinMax_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMin:PIpp32f;pMax:PIpp32f):IppStatus;
  ippiMinMax_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var max:Ipp32f):IppStatus;
  ippiMinMax_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var max:Ipp32f):IppStatus;
  ippiMinMax_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var max:Ipp32f):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiBlockMinMax_32f_C1R, ippiBlockMinMax_16s_C1R,
//              ippiBlockMinMax_16u_C1R, ippiBlockMinMax_8u_C1R .
//
//  Purpose:    Finds minimum and maximum values for blocks of the source image.
//
//  Parameters:
//    pSrc                Pointer to the source image ROI.
//    srcStep             Distance, in bytes, between the starting points of consecutive lines in the source image.
//    srcSize             Size, in pixels, of the source image.
//    pDstMin             Pointer to the destination image to store minimum values per block.
//    dstMinStep          Distance, in bytes, between the starting points of consecutive lines in the pDstMin image.
//    pDstMax             Pointer to the destination image to store maximum values per block.
//    dstMaxStep          Distance, in bytes, between the starting points of consecutive lines in the pDstMax image.
//    blockSize           Size, in pixels, of the block.
//    pDstGlobalMin       The destination pointer to store minimum value for the entire source image.
//    pDstGlobalMax       The destination pointer to store maximum value for the entire source image.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsStepErr    - Error when :
//                         srcStep is less than srcSize.width*sizeof(*pSrc).
//                         dstMinStep, or dstMaxStep is less than dstSize.width*sizeof(*pDst).
//    ippStsSizeErr    - Error when srcSize or blockSize has a zero or negative value.
*)
  ippiBlockMinMax_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcSize:IppiSize;pDstMin:PIpp32f;dstMinStep:longint;pDstMax:PIpp32f;dstMaxStep:longint;blockSize:IppiSize;pDstGlobalMin:PIpp32f;pDstGlobalMax:PIpp32f):IppStatus;
  ippiBlockMinMax_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;srcSize:IppiSize;pDstMin:PIpp16s;dstMinStep:longint;pDstMax:PIpp16s;dstMaxStep:longint;blockSize:IppiSize;pDstGlobalMin:PIpp16s;pDstGlobalMax:PIpp16s):IppStatus;
  ippiBlockMinMax_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;srcSize:IppiSize;pDstMin:PIpp16u;dstMinStep:longint;pDstMax:PIpp16u;dstMaxStep:longint;blockSize:IppiSize;pDstGlobalMin:PIpp16u;pDstGlobalMax:PIpp16u):IppStatus;
  ippiBlockMinMax_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcSize:IppiSize;pDstMin:PIpp8u;dstMinStep:longint;pDstMax:PIpp8u;dstMaxStep:longint;blockSize:IppiSize;pDstGlobalMin:PIpp8u;pDstGlobalMax:PIpp8u):IppStatus;



(* ////////////////////////////////////////////////////////////////////////////
//  Names:              ippiMinEvery, ippiMaxEvery
//  Purpose:            calculation min/max value for every element of two images
//  Parameters:
//   pSrc               pointer to input image
//   pSrcDst            pointer to input/output image
//    srcStep           Step in bytes through the source image
//    roiSize           Size of the source image ROI.
//  Return:
//   ippStsNullPtrErr   pointer(s) to the data is NULL
//   ippStsSizeErr      roiSize has a field with zero or negative value
//   ippStsNoErr        otherwise
*)

  ippiMaxEvery_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16s_C1IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16s_C1IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMaxEvery_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16s_C3IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16s_C3IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMaxEvery_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16s_C4IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16s_C4IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiMaxEvery_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16s_AC4IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16s_AC4IR: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMinEvery_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiMaxEvery_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                      Logical Operations and Shift Functions
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(*
//  Names:          ippiAnd, ippiAndC, ippiOr, ippiOrC, ippiXor, ippiXorC, ippiNot,
//  Purpose:        Performs corresponding bitwise logical operation between pixels of two image
//                  (AndC/OrC/XorC  - between pixel of the source image and a constant)
//
//  Names:          ippiLShiftC, ippiRShiftC
//  Purpose:        Shifts bits in each pixel value to the left and right
//  Parameters:
//   value         1) The constant value to be ANDed/ORed/XORed with each pixel of the source,
//                     constant vector for multi-channel images;
//                 2) The number of bits to shift, constant vector for multi-channel images.
//   pSrc          Pointer to the source image
//   srcStep       Step through the source image
//   pSrcDst       Pointer to the source/destination image (in-place flavors)
//   srcDstStep    Step through the source/destination image (in-place flavors)
//   pSrc1         Pointer to first source image
//   src1Step      Step through first source image
//   pSrc2         Pointer to second source image
//   src2Step      Step through second source image
//   pDst          Pointer to the destination image
//   dstStep       Step in destination image
//   roiSize       Size of the ROI
//
//  Returns:
//   ippStsNullPtrErr   One of the pointers is NULL
//   ippStsStepErr      One of the step values is less than or equal to zero
//   ippStsSizeErr      roiSize has a field with zero or negative value
//   ippStsShiftErr     Shift's value is less than zero
//   ippStsNoErr        No errors
*)

  ippiAnd_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_C3IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_C4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAnd_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_C1IR: function(value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_C3IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_C4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiAndC_32s_AC4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiOr_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_C3IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_C4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOr_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_C1IR: function(value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_C3IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_C4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiOrC_32s_AC4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiXor_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_C3IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_C4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXor_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_C1IR: function(value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_C3IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_C4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiXorC_32s_AC4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiNot_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiNot_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiLShiftC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_C1IR: function(value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_8u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_C1IR: function(value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_16u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_C1IR: function(value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiLShiftC_32s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiRShiftC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_C1IR: function(value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_8u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_C1IR: function(value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_C1IR: function(value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_16s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_C1IR: function(value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiRShiftC_32s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                              Compare Operations
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiCompare
//                  ippiCompareC
//  Purpose:  Compares pixel values of two images, or pixel values of an image to a constant
//            value using the following compare conditions: <, <=, ==, >, >= ;
//  Names:          ippiCompareEqualEps
//                  ippiCompareEqualEpsC
//  Purpose:  Compares 32f images for being equal, or equal to a given value within given tolerance
//  Context:
//
//  Returns:        IppStatus
//    ippStsNoErr        No errors
//    ippStsNullPtrErr   One of the pointers is NULL
//    ippStsStepErr      One of the step values is less than or equal to zero
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsEpsValErr    eps is negative
//
//  Parameters:
//    pSrc1         Pointer to the first source image;
//    src1Step      Step through the first source image;
//    pSrc2         Pointer to the second source image data;
//    src2Step      Step through the second source image;
//    pDst          Pointer to destination image data;
//    dstStep       Step in destination image;
//    roiSize       Size of the ROI;
//    ippCmpOp      Compare operation to be used
//    value         Value (array of values for multi-channel image) to compare
//                  each pixel to
//    eps           The tolerance value
//
//  Notes:
*)

  ippiCompare_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompareC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompare_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompareC_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompare_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompareC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompare_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompare_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompareC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;
  ippiCompareC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;

  ippiCompareEqualEps_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;
  ippiCompareEqualEps_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;
  ippiCompareEqualEps_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;
  ippiCompareEqualEps_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;

  ippiCompareEqualEpsC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;
  ippiCompareEqualEpsC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;
  ippiCompareEqualEpsC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;
  ippiCompareEqualEpsC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                 Morphological Operations
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiErode3x3_8u_C1R()    ippiDilate3x3_8u_C1R()
//             ippiErode3x3_8u_C3R()    ippiDilate3x3_8u_C3R()
//             ippiErode3x3_8u_AC4R()   ippiDilate3x3_8u_AC4R()
//             ippiErode3x3_8u_C4R()    ippiDilate3x3_8u_C4R()
//
//             ippiErode3x3_32f_C1R()   ippiDilate3x3_32f_C1R()
//             ippiErode3x3_32f_C3R()   ippiDilate3x3_32f_C3R()
//             ippiErode3x3_32f_AC4R()  ippiDilate3x3_32f_AC4R()
//             ippiErode3x3_32f_C4R()   ippiDilate3x3_32f_C4R()
//
//  Purpose:   Performs not in-place erosion/dilation using a 3x3 mask
//
//  Returns:
//    ippStsNullPtrErr   pSrc == NULL or pDst == NULL
//    ippStsStepErr      srcStep <= 0 or dstStep <= 0
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsStrideErr    (2+roiSize.width)*nChannels*sizeof(item) > srcStep or
//                       (2+roiSize.width)*nChannels*sizeof(item) > dstStep
//    ippStsNoErr        No errors
//
//  Parameters:
//    pSrc          Pointer to the source image ROI
//    srcStep       Step (bytes) through the source image
//    pDst          Pointer to the destination image ROI
//    dstStep       Step (bytes) through the destination image
//    roiSize       Size of the ROI
*)
  ippiErode3x3_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiDilate3x3_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;roiSize:IppiSize):IppStatus;



(* ///////////////////////////////////////////////////////////////////////////
//  Name:
//    ippiZigzagInv8x8_16s_C1
//    ippiZigzagFwd8x8_16s_C1
//
//  Purpose:
//    Converts a natural order  to zigzag in an 8x8 block (forward function),
//    converts a zigzag order to natural  in a 8x8 block (inverse function)
//
//  Parameter:
//    pSrc   Pointer to the source block
//    pDst   Pointer to the destination block
//
//  Returns:
//    ippStsNoErr      No errors
//    ippStsNullPtrErr One of the pointers is NULL
//
*)

  ippiZigzagInv8x8_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;
  ippiZigzagFwd8x8_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                         Windowing functions
//
//  Note: to obtain the window coefficients you have apply the corresponding
//        function to the image with all pixel values set to 1 (this image can
//        be created, for example, calling function ippiSet(1,x,n))
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
// Names:         ippiWinBartlett, ippiWinBartlettSep
// Purpose:       Applies Bartlett windowing function to an image.
// Parameters:
//    pSrc        - Pointer to the source image.
//    srcStep     - Distances, in bytes, between the starting points of consecutive lines in the source images.
//    pDst        - Pointer to the destination image.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    pSrcDst     - Pointer to the source/destination image (in-place flavors).
//    srcDstStep  - Distance, in bytes, between the starting points of consecutive lines in the source/destination image (in-place flavors).
//    roiSize     - Size, in pixels, of the ROI.
//    pBuffer     - Pointer to the buffer for internal calculations. Size of the buffer is calculated by ippiWinBartlett{Sep}GetBufferSize.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when roiSize has a field with value less than 3.
//    ippStsStepErr    - Error when srcStep, dstStep, or srcDstStep has a zero or negative value.
*)
  ippiWinBartlett_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlett_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlett_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;

  ippiWinBartlett_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlett_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlett_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;

  ippiWinBartlettSep_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlettSep_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlettSep_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;

  ippiWinBartlettSep_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlettSep_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinBartlettSep_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Names:      ippiWinBartlettGetSize, ippiWinBartlettSepGetSize
//
// Purpose:    Get the size (in bytes) of the buffer for ippiWinBartlett{Sep} internal calculations.
//
// Parameters:
//    dataType    - Data type for windowing function. Possible values are ipp32f, ipp16u, or ipp8u.
//    roiSize     - Size, in pixels, of the ROI.
//    pSize       - Pointer to the calculated buffer size (in bytes).
//
// Return:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when pSize pointer is NULL.
//    ippStsSizeErr     - Error when roiSize has a field with value less than 3.
//    ippStsDataTypeErr - Error when the dataType value differs from the ipp32f, ipp16u, or ipp8u.
*)
  ippiWinBartlettGetBufferSize: function(dataType:IppDataType;roiSize:IppiSize;pSize:Plongint):IppStatus;
  ippiWinBartlettSepGetBufferSize: function(dataType:IppDataType;roiSize:IppiSize;pSize:Plongint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
// Names:         ippiWinHamming, ippiWinHammingSep
// Purpose:       Applies Hamming window function to the image.
// Parameters:
//    pSrc        - Pointer to the source image.
//    srcStep     - Distances, in bytes, between the starting points of consecutive lines in the source images.
//    pDst        - Pointer to the destination image.
//    dstStep     - Distance, in bytes, between the starting points of consecutive lines in the destination image.
//    pSrcDst     - Pointer to the source/destination image (in-place flavors).
//    srcDstStep  - Distance, in bytes, between the starting points of consecutive lines in the source/destination image (in-place flavors).
//    roiSize     - Size, in pixels, of the ROI.
//    pBuffer     - Pointer to the buffer for internal calculations. Size of the buffer is calculated by ippiWinHamming{Sep}GetBufferSize.
//  Returns:
//    ippStsNoErr      - OK.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when roiSize has a field with value less than 3.
//    ippStsStepErr    - Error when srcStep, dstStep, or srcDstStep has a zero or negative value.
*)
  ippiWinHamming_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHamming_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHamming_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;

  ippiWinHamming_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHamming_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHamming_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;

  ippiWinHammingSep_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHammingSep_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHammingSep_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;

  ippiWinHammingSep_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHammingSep_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;
  ippiWinHammingSep_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Names:      ippiWinHammingGetBufferSize, ippiWinHammingSepGetBufferSize
//
// Purpose:    Get the size (in bytes) of the buffer for ippiWinHamming{Sep} internal calculations.
//
// Parameters:
//    dataType    - Data type for windowing function. Possible values are ipp32f, ipp16u, or ipp8u.
//    roiSize     - Size, in pixels, of the ROI.
//    pSize       - Pointer to the calculated buffer size (in bytes).
//
// Return:
//    ippStsNoErr       - OK.
//    ippStsNullPtrErr  - Error when pSize pointer is NULL.
//    ippStsSizeErr     - Error when roiSize has a field with value less than 3.
//    ippStsDataTypeErr - Error when the dataType value differs from the ipp32f, ipp16u, or ipp8u.
*)
  ippiWinHammingGetBufferSize: function(dataType:IppDataType;roiSize:IppiSize;pSize:Plongint):IppStatus;
  ippiWinHammingSepGetBufferSize: function(dataType:IppDataType;roiSize:IppiSize;pSize:Plongint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:        ippiTranspose
//
//  Purpose:     Transposing an image
//
//  Parameters:
//    pSrc       Pointer to the source image
//    srcStep    Step through the source image
//    pDst       Pointer to the destination image
//    dstStep    Step through the destination image
//    pSrcDst    Pointer to the source/destination image (in-place flavors)
//    srcDstStep Step through the source/destination image (in-place flavors)
//    roiSize    Size of the ROI
//
//  Returns:
//    ippStsNoErr      - Ok.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when:
//                         roiSize has a field with zero or negative value;
//                         roiSize.width != roiSize.height (in-place flavors).
//
//  Notes: Parameters roiSize.width and roiSize.height are defined for the source image.
*)
  ippiTranspose_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiTranspose_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiTranspose_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiTranspose_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32s_C1IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32s_C3IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32s_C4IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;

  ippiTranspose_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;
  ippiTranspose_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiDeconvFFTGetSize_32f
//
// Purpose:     Get sizes, in bytes, of the IppiDeconvFFTState_32f_C{1|3}R structure.
//
// Parameters:
//    numChannels - Number of image channels. Possible values are 1 and 3.
//    kernelSize  - Size of kernel.
//    FFTorder    - Order of created FFT structure.
//    pSize       - Pointer to the size of IppiDeconvFFTState_32f_C{1|3}R structure (in bytes).
//
// Returns:
//    ippStsNoErr           - Ok.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr  - Error when the numChannels value differs from 1 or 3.
//    ippStsSizeErr         - Error when:
//                               kernelSize less or equal to zero;
//                               kernelSize great than 2^FFTorder.
*)
  ippiDeconvFFTGetSize_32f: function(nChannels:longint;kernelSize:longint;FFTorder:longint;pSize:Plongint):IppStatus;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippiDeconvFFTInit_32f_C1R, ippiDeconvFFTInit_32f_C3R
//
// Purpose:     Initialize IppiDeconvFFTState structure.
//
// Parameters:
//    pDeconvFFTState - Pointer to the created deconvolution structure.
//    pKernel         - Pointer to the kernel array.
//    kernelSize      - Size of kernel.
//    FFTorder        - Order of created FFT structure.
//    threshold       - Threshold level value (for except dividing to zero).
//
// Returns:
//    ippStsNoErr      - Ok.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when:
//                          kernelSize less or equal to zero;
//                          kernelSize great than 2^FFTorder.
//    ippStsBadArgErr  - Error when threshold less or equal to zero.
*)
  ippiDeconvFFTInit_32f_C1R: function(pDeconvFFTState:PIppiDeconvFFTState_32f_C1R;pKernel:PIpp32f;kernelSize:longint;FFTorder:longint;threshold:Ipp32f):IppStatus;
  ippiDeconvFFTInit_32f_C3R: function(pDeconvFFTState:PIppiDeconvFFTState_32f_C3R;pKernel:PIpp32f;kernelSize:longint;FFTorder:longint;threshold:Ipp32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:        ippiDeconvFFT_32f_C*R
//
//  Purpose:    Perform deconvolution for source image using FFT
//
//  Parameters:
//    pSrc            - Pointer to the source image.
//    srcStep         - Step in bytes in the source image.
//    pDst            - Pointer to the destination image.
//    dstStep         - Step in bytes in the destination image.
//    roi             - Size of the image ROI in pixels.
//    pDeconvFFTState - Pointer to the Deconvolution context structure.
//
//  Returns:
//    ippStsNoErr          - Ok.
//    ippStsNullPtrErr     - Error when any of the specified pointers is NULL.
//    ippStsSizeErr        - Error when:
//                               roi.width or roi.height less or equal to zero;
//                               roi.width or roi.height great than (2^FFTorder-kernelSize).
//    ippStsStepErr        - Error when srcstep or dststep less than roi.width multiplied by type size.
//    ippStsNotEvenStepErr - Error when one of step values for floating-point images cannot be divided by 4.
*)
  ippiDeconvFFT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roi:IppiSize;pDeconvFFTState:PIppiDeconvFFTState_32f_C1R):IppStatus;
  ippiDeconvFFT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roi:IppiSize;pDeconvFFTState:PIppiDeconvFFTState_32f_C3R):IppStatus;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippiDeconvLRGetSize_32f
//
// Purpose:     Get sizes, in bytes, of the IppiDeconvLR_32f_C{1|3}R structure.
//
// Parameters:
//    numChannels - Number of image channels. Possible values are 1 and 3.
//    kernelSize  - Size of kernel.
//    maxroi      - Maximum size of the image ROI in pixels.
//    pSize       - Pointer to the size of IppiDeconvLR_32f_C{1|3}R structure (in bytes).
//
// Returns:
//    ippStsNoErr           - Ok.
//    ippStsNullPtrErr      - Error when any of the specified pointers is NULL.
//    ippStsNumChannelsErr  - Error when the numChannels value differs from 1 or 3.
//    ippStsSizeErr         - Error when:
//                               kernelSize less or equal to zero;
//                               kernelSize great than maxroi.width or maxroi.height;
//                               maxroi.height or maxroi.width less or equal to zero.
*)
  ippiDeconvLRGetSize_32f: function(numChannels:longint;kernelSize:longint;maxroi:IppiSize;pSize:Plongint):IppStatus;

(* //////////////////////////////////////////////////////////////////////
// Name:        ippiDeconvLRInit_32f_C1R, ippiDeconvLRInit_32f_C3R
//
// Purpose:     Initialize IppiDeconvLR_32f_C{1|3}R structure.
//
// Parameters:
//    pDeconvLR   - Pointer to the created Lucy-Richardson Deconvolution context structure.
//    pKernel     - Pointer to the kernel array.
//    kernelSize  - Size of kernel.
//    maxroi      - Maximum size of the image ROI in pixels.
//    threshold   - Threshold level value (for except dividing to zero).
//
// Returns:
//    ippStsNoErr      - Ok.
//    ippStsNullPtrErr - Error when any of the specified pointers is NULL.
//    ippStsSizeErr    - Error when:
//                         kernelSize less or equal to zero;
//                         kernelSize great than maxroi.width or maxroi.height,
//                         maxroi.height or maxroi.width less or equal to zero.
//    ippStsBadArgErr  - Error when threshold less or equal to zero.
*)
  ippiDeconvLRInit_32f_C1R: function(pDeconvLR:PIppiDeconvLR_32f_C1R;pKernel:PIpp32f;kernelSize:longint;maxroi:IppiSize;threshold:Ipp32f):IppStatus;
  ippiDeconvLRInit_32f_C3R: function(pDeconvLR:PIppiDeconvLR_32f_C3R;pKernel:PIpp32f;kernelSize:longint;maxroi:IppiSize;threshold:Ipp32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:        ippiDeconvLR_32f_C1R, ippiDeconvLR_32f_C3R
//
//  Purpose:    Perform deconvolution for source image using Lucy-Richardson algorithm
//
//  Parameters:
//    pSrc      - Pointer to the source image.
//    srcStep   - Step in bytes in the source image.
//    pDst      - Pointer to the destination image.
//    dstStep   - Step in bytes in the destination image.
//    roi       - Size of the image ROI in pixels.
//    numiter   - Number of algorithm iteration.
//    pDeconvLR - Pointer to the Lucy-Richardson Deconvolution context structure.
//
//  Returns:
//    ippStsNoErr          - Ok.
//    ippStsNullPtrErr     - Error when any of the specified pointers is NULL.
//    ippStsSizeErr        - Error when:
//                               roi.width or roi.height less or equal to zero;
//                               roi.width  great than (maxroi.width-kernelSize);
//                               roi.height great than (maxroi.height-kernelSize).
//    ippStsStepErr        - Error when srcstep or dststep less than roi.width multiplied by type size.
//    ippStsNotEvenStepErr - Error when one of step values for floating-point images cannot be divided by 4.
//    ippStsBadArgErr      - Error when number of iterations less or equal to zero.
*)
  ippiDeconvLR_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roi:IppiSize;numiter:longint;pDeconvLR:PIppiDeconvLR_32f_C1R):IppStatus;
  ippiDeconvLR_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roi:IppiSize;numiter:longint;pDeconvLR:PIppiDeconvLR_32f_C3R):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//
//  Names:        ippiCompColorKey_8u_C1R
//                ippiCompColorKey_8u_C3R
//                ippiCompColorKey_8u_C4R
//                ippiCompColorKey_16s_C1R
//                ippiCompColorKey_16s_C3R
//                ippiCompColorKey_16s_C4R
//                ippiCompColorKey_16u_C1R
//                ippiCompColorKey_16u_C3R
//                ippiCompColorKey_16u_C4R
//
//  Purpose:    Perform alpha blending with transparent background.
//
//  Returns:     IppStatus
//     ippStsNoErr            No errors
//     ippStsNullPtrErr       One of the pointers is NULL
//     ippStsSizeErr          The roiSize has a field with negative or zero value
//     ippStsStepErr          One of steps is less than or equal to zero
//     ippStsAlphaTypeErr     Unsupported type of composition (for ippiAlphaCompColorKey)
//
//  Parameters:
//    pSrc1, pSrc2           Pointers to the source images
//    src1Step, src2Step     Steps through the source images
//    pDst                   Pointer to the destination image
//    dstStep                Step through the destination image
//    roiSize                Size of the image ROI
//    colorKey               Color value (array of values for multi-channel data)
//    alphaType              The type of composition to perform (for ippiAlphaCompColorKey)
//
*)
  ippiCompColorKey_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;colorKey:Ipp8u):IppStatus;

  ippiCompColorKey_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var colorKey:Ipp8u):IppStatus;

  ippiCompColorKey_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var colorKey:Ipp8u):IppStatus;

  ippiCompColorKey_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;colorKey:Ipp16u):IppStatus;

  ippiCompColorKey_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var colorKey:Ipp16u):IppStatus;

  ippiCompColorKey_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var colorKey:Ipp16u):IppStatus;

  ippiCompColorKey_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;colorKey:Ipp16s):IppStatus;

  ippiCompColorKey_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var colorKey:Ipp16s):IppStatus;

  ippiCompColorKey_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var colorkey:Ipp16s):IppStatus;
  ippiAlphaCompColorKey_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var colorKey:Ipp8u;alphaType:IppiAlphaType):IppStatus;


(* ///////////////////////////////////////////////////////////////////////////
//                     Median filter function
// ///////////////////////////////////////////////////////////////////////////
// Name:
//   ippiMedian_8u_P3C1R
//
// Purpose:
//   Median of three images.
//
//   For each pixel (x, y) in the ROI:
//   pDst[x + y*dstStep] = MEDIAN(pSrc[0][x + y*srcStep],
//                                pSrc[1][x + y*srcStep],
//                                pSrc[2][x + y*srcStep]);
//
// Parameters:
//   pSrc       Pointer to three source images.
//   srcStep    Step in bytes through source images.
//   pDst       Pointer to the destination image.
//   dstStep    Step in bytes through the destination image buffer.
//   size       Size of the ROI in pixels.
//
// Returns:
//   ippStsNoErr        Indicates no error. Any other value indicates an error or a warning.
//   ippStsNullPtrErr   Indicates an error if one of the specified pointers is NULL.
//   ippStsSizeErr      Indicates an error condition if size has a field with zero or negative value.
//
*)
  ippiMedian_8u_P3C1R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;size:IppiSize):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                     De-interlacing filter function
// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
//
//  Name:               ippiDeinterlaceFilterCAVT_8u_C1R
//  Purpose:            Performs de-interlacing of two-field image
//                      using content adaptive vertical temporal (CAVT) filtering
//  Parameters:
//    pSrc              pointer to the source image (frame)
//    srcStep           step of the source pointer in bytes
//    pDst              pointer to the destination image (frame)
//    dstStep           step of the destination pointer in bytes
//    threshold         threshold level value
//    roiSize           size of the source and destination ROI
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  pSrc == NULL or pDst == NULL
//    ippStsSizeErr     width of roi is less or equal zero or
//                      height of roi is less 8 or odd
*)

  ippiDeinterlaceFilterCAVT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;threshold:Ipp16u;roiSize:IppiSize):IppStatus;




(* /////////////////////////////////////////////////////////////////////////////
//                     Bilateral filter function
*)

(* /////////////////////////////////////////////////////////////////////////////
//                     Bilateral filter functions with Border
// /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFilterBilateralBorderGetBufferSize
//  Purpose:    to define buffer size for bilateral filter
//  Parameters:
//   filter        Type of bilateral filter. Possible value is ippiFilterBilateralGauss.
//   dstRoiSize    Roi size (in pixels) of destination image what will be applied
//                 for processing.
//   radius        Radius of circular neighborhood what defines pixels for calculation.
//   dataType      Data type of the source and desination images. Possible values
//                 are ipp8u and ipp32f.
//   numChannels   Number of channels in the images. Possible values are 1 and 3.
//   distMethod    The type of method for definition of distance beetween pixel untensity.
//                 Possible value is ippDistNormL1.
//   pSpecSize     Pointer to the size (in bytes) of the spec.
//   pBufferSize   Pointer to the size (in bytes) of the external work buffer.
//  Return:
//    ippStsNoErr               OK
//    ippStsNullPtrErr          any pointer is NULL
//    ippStsSizeErr             size of dstRoiSize is less or equal 0
//    ippStsMaskSizeErr         radius is less or equal 0
//    ippStsNotSupportedModeErr filter or distMethod is not supported
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsNumChannelsErr      Indicates an error when numChannels has an illegal value.
*)
  ippiFilterBilateralBorderGetBufferSize: function(filter:IppiFilterBilateralType;dstRoiSize:IppiSize;radius:longint;dataType:IppDataType;numChannels:longint;distMethodType:IppiDistanceMethodType;pSpecSize:Plongint;pBufferSize:Plongint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFilterBilateralBorderInit
//  Purpose:    initialization of Spec for bilateral filter with border
//  Parameters:
//   filter           Type of bilateral filter. Possible value is ippiFilterBilateralGauss.
//   dstRoiSize       Roi size (in pixels) of destination image what will be applied
//                    for processing.
//   radius           Radius of circular neighborhood what defines pixels for calculation.
//   dataType      Data type of the source and desination images. Possible values
//                 are ipp8u and ipp32f.
//   numChannels   Number of channels in the images. Possible values are 1 and 3.
//   distMethodType   The type of method for definition of distance beetween pixel intensity.
//                    Possible value is ippDistNormL1.
//   valSquareSigma   square of Sigma for factor function for pixel intensity
//   posSquareSigma   square of Sigma for factor function for pixel position
//    pSpec           pointer to Spec
//  Return:
//    ippStsNoErr               OK
//    ippStsNullPtrErr          pointer ro Spec is NULL
//    ippStsSizeErr             size of dstRoiSize is less or equal 0
//    ippStsMaskSizeErr         radius is less or equal 0
//    ippStsNotSupportedModeErr filter or distMethod is not supported
//    ippStsDataTypeErr         Indicates an error when dataType has an illegal value.
//    ippStsNumChannelsErr      Indicates an error when numChannels has an illegal value.
//    ippStsBadArgErr           valSquareSigma or posSquareSigma is less or equal 0
*)
  ippiFilterBilateralBorderInit: function(filter:IppiFilterBilateralType;dstRoiSize:IppiSize;radius:longint;dataType:IppDataType;numChannels:longint;distMethod:IppiDistanceMethodType;valSquareSigma:Ipp32f;posSquareSigma:Ipp32f;pSpec:PIppiFilterBilateralSpec):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFilterBilateralBorder_8u_C1R
//              ippiFilterBilateralBorder_8u_C3R
//              ippiFilterBilateralBorder_32f_C1R
//              ippiFilterBilateralBorder_32f_C3R
//  Purpose:    bilateral filter
//  Parameters:
//    pSrc         Pointer to the source image
//    srcStep      Step through the source image
//    pDst         Pointer to the destination image
//    dstStep      Step through the destination image
//    dstRoiSize   Size of the destination ROI
//    borderType   Type of border.
//    borderValue  Pointer to constant value to assign to pixels of the constant border. This parameter is applicable
//                 only to the ippBorderConst border type. If this pointer is NULL than the constant value is equal 0.
//    pSpec        Pointer to filter spec
//    pBuffer      Pointer ro work buffer
//  Return:
//    ippStsNoErr           OK
//    ippStsNullPtrErr      pointer to Src, Dst, Spec or Buffer is NULL
//    ippStsSizeErr         size of dstRoiSize is less or equal 0
//    ippStsContextMatchErr filter Spec is not match
//    ippStsNotEvenStepErr  Indicated an error when one of the step values is not divisible by 4
//                          for floating-point images.
//    ippStsBorderErr       Indicates an error when borderType has illegal value.
*)
  ippiFilterBilateralBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;borderType:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiFilterBilateralSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBilateralBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;borderType:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiFilterBilateralSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBilateralBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;borderType:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiFilterBilateralSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBilateralBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;borderType:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiFilterBilateralSpec;pBuffer:PIpp8u):IppStatus;



(* ////////////////////////////////////////////////////////////////////////////
//  Name:      ippiFilterGetBufSize_64f_C1R
//  Purpose:   Get size of temporal buffer
//  Parameters:
//      kernelSize      Size of the rectangular kernel in pixels.
//      roiWidth        Width of ROI
//      pSize           Pointer to the size of work buffer
//  Returns:
//   ippStsNoErr        Ok
//   ippStsNullPtrErr   pSize is NULL
//   ippStsSizeErr      Some size of kernelSize or roiWidth less or equal zero
//  Remark:             Function may return zero size of buffer.
*)
  ippiFilterGetBufSize_64f_C1R: function(kernelSize:IppiSize;roiWidth:longint;pSize:Plongint):IppStatus;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFilter_64f_C1R
//  Purpose:    Filters an image using a general float rectangular kernel
//  Parameters:
//      pSrc            Pointer to the source buffer
//      srcStep         Step in bytes through the source image buffer
//      pDst            Pointer to the destination buffer
//      dstStep         Step in bytes through the destination image buffer
//      dstRoiSize      Size of the source and destination ROI in pixels
//      pKernel         Pointer to the kernel values ( 64f kernel )
//      kernelSize      Size of the rectangular kernel in pixels.
//      anchor          Anchor cell specifying the rectangular kernel alignment
//                      with respect to the position of the input pixel
//      pBuffer         Pointer to work buffer
//  Returns:
//   ippStsNoErr        Ok
//   ippStsNullPtrErr   Some of pointers to pSrc, pDst or pKernel are NULL or
//                      pBuffer is null but GetBufSize returned non zero size
//   ippStsSizeErr      Some size of dstRoiSize or kernalSize less or equal zero
//   ippStsStepErr      srcStep is less than (roiWidth + kernelWidth - 1) * sizeof(Ipp64f) or
//                      dstStep is less than  roiWidth * sizeof(Ipp64f)
*)

  ippiFilter_64f_C1R: function(pSrc:PIpp64f;srcStep:longint;pDst:PIpp64f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp64f;kernelSize:IppiSize;anchor:IppiPoint;pBuffer:PIpp8u):IppStatus;


(*
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image with three rounding modes (ippRndZero,ippRndNear,ippRndFinancial)
//              and places the scaled results in a destination
//              image.
//  Name:       ippiDiv_Round_16s_C1RSfs, ippiDiv_Round_8u_C1RSfs, ippiDiv_Round_16u_C1RSfs,
//              ippiDiv_Round_16s_C3RSfs, ippiDiv_Round_8u_C3RSfs, ippiDiv_Round_16u_C3RSfs,
//              ippiDiv_Round_16s_C4RSfs, ippiDiv_Round_8u_C4RSfs, ippiDiv_Round_16u_C4RSfs,
//              ippiDiv_Round_16s_AC4RSfs, ippiDiv_Round_8u_AC4RSfs, ippiDiv_Round_16u_AC4RSfs,
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            At least one step value is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the function
//                             execution is continued.
//                    If a dividend is equal to zero, then the result is zero;
//                    if it is greater than zero, then the result is IPP_MAX_16S, or IPP_MAX_8U, or IPP_MAX_16U
//                    if it is less than zero (for 16s), then the result is IPP_MIN_16S
//   ippStsRoundModeNotSupportedErr Unsupported round mode
//
//
//  Parameters:
//    pSrc1                    Pointer to the divisor source image
//    src1Step                 Step through the divisor source image
//    pSrc2                    Pointer to the dividend source image
//    src2Step                 Step through the dividend source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    rndMode           Rounding mode (ippRndZero, ippRndNear or ippRndFinancial)
//    scaleFactor              Scale factor
*)

  ippiDiv_Round_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_C1RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_C3RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_C4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_AC4RSfs: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
(*
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image with three rounding modes (ippRndZero,ippRndNear,ippRndFinancial)
//              and places the scaled results in a destination
//              image.
//  Name:       ippiDiv_Round_16s_C1IRSfs, ippiDiv_Round_8u_C1IRSfs, ippiDiv_Round_16u_C1IRSfs,
//              ippiDiv_Round_16s_C3IRSfs, ippiDiv_Round_8u_C3IRSfs, ippiDiv_Round_16u_C3IRSfs,
//              ippiDiv_Round_16s_C4IRSfs, ippiDiv_Round_8u_C4IRSfs, ippiDiv_Round_16u_C4IRSfs,
//              ippiDiv_Round_16s_AC4IRSfs, ippiDiv_Round_8u_AC4IRSfs, ippiDiv_Round_16u_AC4IRSfs,
//  Parameters:
//    pSrc                     Pointer to the divisor source image
//    srcStep                  Step through the divisor source image
//    pSrcDst                  Pointer to the dividend source/destination image
//    srcDstStep               Step through the dividend source/destination image
//    roiSize                  Size of the ROI
//    rndMode           Rounding mode (ippRndZero, ippRndNear or ippRndFinancial)
//    scaleFactor              Scale factor
//  Returns:
//    ippStsNoErr              OK
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            roiSize has a field with zero or negative value
//    ippStsStepErr            At least one step value is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the function
//                             execution is continued.
//                    If a dividend is equal to zero, then the result is zero;
//                    if it is greater than zero, then the result is IPP_MAX_16S, or IPP_MAX_8U, or IPP_MAX_16U
//                    if it is less than zero (for 16s), then the result is IPP_MIN_16S
//   ippStsRoundModeNotSupportedErr Unsupported round mode
*)
  ippiDiv_Round_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_C1IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_C3IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;scaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_C4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;
  ippiDiv_Round_16u_AC4IRSfs: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;rndMode:IppRoundMode;ScaleFactor:longint):IppStatus;



(* /////////////////////////////////////////////////////////////////////////////
//                      Resize Transform Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer for Resize transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    interpolation     Interpolation method
//    antialiasing      Supported values: 1- resizing with antialiasing, 0 - resizing without antialiasing
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if the source image size is less than a filter size of the chosen
//                                 interpolation method (except ippSuper),
//                              -  if one of the specified dimensions of the source image is less than
//                                 the corresponding dimension of the destination image (for ippSuper method only),
//                              -  if width or height of the source or destination image is negative,
//                              -  if width or height of the source or destination image is negative.
//    ippStsExceededSizeErr     Indicates an error if one of the calculated sizes exceeds maximum 32 bit signed
//                              integer positive value (the size of the one of the processed images is too large).
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNoAntialiasing      Indicates a warning if specified interpolation does not support antialiasing
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//
//  Notes:
//    1. Supported interpolation methods are ippNearest, ippLinear, ippCubic, ippLanczos and ippSuper.
//    2. If antialiasing value is equal to 1, use the ippResizeAntialiasing<Filter>Init functions, otherwise, use ippResize<Filter>Init
//    3. The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 1x1,
//       Linear 2x2, Cubic 4x4, 2-lobed Lanczos 4x4.
*)
  ippiResizeGetSize_8u: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;
  ippiResizeGetSize_16u: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;
  ippiResizeGetSize_16s: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:Plongint;pInitBufSize:PIpp32s):IppStatus;
  ippiResizeGetSize_32f: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;
  ippiResizeGetSize_64f: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:Plongint;pInitBufSize:Plongint):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetBufferSize
//  Purpose:            Computes the size of external buffer for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstSize           Size of the output image (in pixels)
//    numChannels       Number of channels, possible values are 1 or 3 or 4
//    pBufSize          Pointer to the size (in bytes) of the external buffer
//
//  Return Values:
//    ippStsNoErr            Indicates no error
//    ippStsNullPtrErr       Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation      Indicates a warning if width or height of output image is zero
//    ippStsContextMatchErr  Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNumChannelErr    Indicates an error if numChannels has illegal value
//    ippStsSizeErr          Indicates an error condition in the following cases:
//                           - if width or height of the source image is negative,
//    ippStsExceededSizeErr  Indicates an error if one of the calculated sizes exceeds maximum 32 bit signed
//                           integer positive value (the size of the one of the processed images is too large).
//    ippStsSizeWrn          Indicates a warning if the destination image size is more than
//                           the destination image origin size
*)
  ippiResizeGetBufferSize_8u: function(pSpec:PIppiResizeSpec_32f;dstSize:IppiSize;numChannels:Ipp32u;pBufSize:Plongint):IppStatus;
  ippiResizeGetBufferSize_16u: function(pSpec:PIppiResizeSpec_32f;dstSize:IppiSize;numChannels:Ipp32u;pBufSize:Plongint):IppStatus;
  ippiResizeGetBufferSize_16s: function(pSpec:PIppiResizeSpec_32f;dstSize:IppiSize;numChannels:Ipp32u;pBufSize:Plongint):IppStatus;
  ippiResizeGetBufferSize_32f: function(pSpec:PIppiResizeSpec_32f;dstSize:IppiSize;numChannels:Ipp32u;pBufSize:Plongint):IppStatus;
  ippiResizeGetBufferSize_64f: function(pSpec:PIppiResizeSpec_64f;dstSize:IppiSize;numChannels:Ipp32u;pBufSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetBorderSize
//  Purpose:            Computes the size of possible borders for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    borderSize        Size of necessary borders (for memory allocation)
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
*)
  ippiResizeGetBorderSize_8u: function(pSpec:PIppiResizeSpec_32f;borderSize:PIppiBorderSize):IppStatus;
  ippiResizeGetBorderSize_16u: function(pSpec:PIppiResizeSpec_32f;borderSize:PIppiBorderSize):IppStatus;
  ippiResizeGetBorderSize_16s: function(pSpec:PIppiResizeSpec_32f;borderSize:PIppiBorderSize):IppStatus;
  ippiResizeGetBorderSize_32f: function(pSpec:PIppiResizeSpec_32f;borderSize:PIppiBorderSize):IppStatus;
  ippiResizeGetBorderSize_64f: function(pSpec:PIppiResizeSpec_64f;borderSize:PIppiBorderSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetSrcOffset
//  Purpose:            Computes the offset of input image for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstOffset         Offset of the tiled destination image respective
//                      to the destination image origin
//    srcOffset         Pointer to the computed offset of input image
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr   Indicates an error if the destination image offset point is outside the
//                          destination image origin
*)
  ippiResizeGetSrcOffset_8u: function(pSpec:PIppiResizeSpec_32f;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;
  ippiResizeGetSrcOffset_16u: function(pSpec:PIppiResizeSpec_32f;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;
  ippiResizeGetSrcOffset_16s: function(pSpec:PIppiResizeSpec_32f;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;
  ippiResizeGetSrcOffset_32f: function(pSpec:PIppiResizeSpec_32f;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;
  ippiResizeGetSrcOffset_64f: function(pSpec:PIppiResizeSpec_64f;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeGetSrcRoi
//  Purpose:            Computes the ROI of input image
//                      for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstRoiOffset      Offset of the destination image ROI
//    dstRoiSize        Size of the ROI of destination image
//    srcRoiOffset      Pointer to the computed offset of source image ROI
//    srcRoiSize        Pointer to the computed ROI size of source image
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr   Indicates an error if the destination image offset point is outside
//                          the destination image origin
//    ippStsSizeErr         Indicates an error in the following cases:
//                           -  if width or height of the source or destination image is negative or equal to 0,
//    IppStsSizeWrn         Indicates a warning if the destination ROI exceeds with
//                          the destination image origin
*)

  ippiResizeGetSrcRoi_8u: function(pSpec:PIppiResizeSpec_32f;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

  ippiResizeGetSrcRoi_16u: function(pSpec:PIppiResizeSpec_32f;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

  ippiResizeGetSrcRoi_16s: function(pSpec:PIppiResizeSpec_32f;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

  ippiResizeGetSrcRoi_32f: function(pSpec:PIppiResizeSpec_32f;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

  ippiResizeGetSrcRoi_64f: function(pSpec:PIppiResizeSpec_64f;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeNearestInit
//                      ippiResizeLinearInit
//                      ippiResizeCubicInit
//                      ippiResizeLanczosInit
//                      ippiResizeSuperInit
//
//  Purpose:            Initializes the Spec structure for the Resize transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    numLobes          The parameter for specifying Lanczos (2 or 3) or Hahn (3 or 4) filters
//    pInitBuf          Pointer to the temporal buffer for several filter initialization
//    pSpec             Pointer to the Spec structure for resize filter
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if width or height of the source or destination image is negative,
//                              -  if the source image size is less than a filter size of the chosen
//                                 interpolation method (except ippiResizeSuperInit).
//                              -  if one of the specified dimensions of the source image is less than
//                                 the corresponding dimension of the destination image
//                                 (for ippiResizeSuperInit only).
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C)) / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Hahn filter does not supported now.
//    3. The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 1x1,
//       Linear 2x2, Cubic 4x4, 2-lobed Lanczos 4x4, 3-lobed Lanczos 6x6.
*)
  ippiResizeNearestInit_8u: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeNearestInit_16u: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeNearestInit_16s: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeNearestInit_32f: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeLinearInit_8u: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeLinearInit_16u: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeLinearInit_16s: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeLinearInit_32f: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeLinearInit_64f: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_64f):IppStatus;
  ippiResizeCubicInit_8u: function(srcSize:IppiSize;dstSize:IppiSize;valueB:Ipp32f;valueC:Ipp32f;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeCubicInit_16u: function(srcSize:IppiSize;dstSize:IppiSize;valueB:Ipp32f;valueC:Ipp32f;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeCubicInit_16s: function(srcSize:IppiSize;dstSize:IppiSize;valueB:Ipp32f;valueC:Ipp32f;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeCubicInit_32f: function(srcSize:IppiSize;dstSize:IppiSize;valueB:Ipp32f;valueC:Ipp32f;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeLanczosInit_8u: function(srcSize:IppiSize;dstSize:IppiSize;numLobes:Ipp32u;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeLanczosInit_16u: function(srcSize:IppiSize;dstSize:IppiSize;numLobes:Ipp32u;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeLanczosInit_16s: function(srcSize:IppiSize;dstSize:IppiSize;numLobes:Ipp32u;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeLanczosInit_32f: function(srcSize:IppiSize;dstSize:IppiSize;numLobes:Ipp32u;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;
  ippiResizeSuperInit_8u: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeSuperInit_16u: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeSuperInit_16s: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;
  ippiResizeSuperInit_32f: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeNearest
//                      ippiResizeLinear
//                      ippiResizeCubic
//                      ippiResizeLanczos
//                      ippiResizeSuper
//
//  Purpose:            Changes an image size by different interpolation methods
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstOffset         Offset of tiled image respectively destination image origin
//    dstSize           Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of output image is zero
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//    ippStsSizeErr             Indicates an error if width or height of the destination image
//                              is negative
//    ippStsStepErr             Indicates an error if the step value is not data type multiple
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside the
//                              destination image origin
//    ippStsSizeWrn             Indicates a warning if the destination image size is more than
//                              the destination image origin size
//
//  Notes:
//    1. Supported border types are ippBorderInMemory and ippBorderReplicate
//       (except Nearest Neighbor and Super Sampling methods).
//    2. Hahn filter does not supported now.
*)
  ippiResizeNearest_8u_C1R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_8u_C3R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_8u_C4R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_16u_C1R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_16u_C3R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_16u_C4R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_16s_C1R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_16s_C3R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_16s_C4R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_32f_C1R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_32f_C3R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeNearest_32f_C4R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_8u_C1R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_8u_C3R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_8u_C4R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_16u_C1R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_16u_C3R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_16u_C4R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_16s_C1R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_16s_C3R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_16s_C4R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_32f_C1R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_32f_C3R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_32f_C4R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_64f_C1R: function(pSrc:PIpp64f;srcStep:Ipp32s;pDst:PIpp64f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp64f;pSpec:PIppiResizeSpec_64f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_64f_C3R: function(pSrc:PIpp64f;srcStep:Ipp32s;pDst:PIpp64f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp64f;pSpec:PIppiResizeSpec_64f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLinear_64f_C4R: function(pSrc:PIpp64f;srcStep:Ipp32s;pDst:PIpp64f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp64f;pSpec:PIppiResizeSpec_64f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_8u_C1R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_8u_C3R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_8u_C4R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_16u_C1R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_16u_C3R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_16u_C4R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_16s_C1R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_16s_C3R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_16s_C4R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_32f_C1R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_32f_C3R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeCubic_32f_C4R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_8u_C1R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_8u_C3R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_8u_C4R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_16u_C1R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_16u_C3R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_16u_C4R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_16s_C1R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_16s_C3R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_16s_C4R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_32f_C1R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_32f_C3R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeLanczos_32f_C4R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_8u_C1R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_8u_C3R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_8u_C4R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_16u_C1R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_16u_C3R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_16u_C4R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_16s_C1R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_16s_C3R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_16s_C4R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_32f_C1R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_32f_C3R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeSuper_32f_C4R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeLinearAntialiasingInit
//
//  Purpose:            Initializes the Spec structure for the Resize transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    valueB            The first parameter (B) for specifying Cubic filters
//    valueC            The second parameter (C) for specifying Cubic filters
//    numLobes          The parameter for specifying Lanczos (2 or 3) or Hahn (3 or 4) filters
//    pInitBuf          Pointer to the temporal buffer for several filter initialization
//    pSpec             Pointer to the Spec structure for resize filter
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              -  if width or height of the source or destination image is negative,
//                              -  if the source image size is less than a filter size of the chosen
//                                 interpolation method (except ippiResizeSuperInit).
//                              -  if one of the specified dimensions of the source image is less than
//                                 the corresponding dimension of the destination image
//                                 (for ippiResizeSuperInit only).
//    ippStsNotSupportedModeErr Indicates an error if the requested mode is not supported.
//
//  Notes/References:
//    1. The equation shows the family of cubic filters:
//           ((12-9B-6C)*|x|^3 + (-18+12B+6C)*|x|^2                  + (6-2B)  ) / 6   for |x| < 1
//    K(x) = ((   -B-6C)*|x|^3 + (    6B+30C)*|x|^2 + (-12B-48C)*|x| + (8B+24C)) / 6   for 1 <= |x| < 2
//           0   elsewhere
//    Some values of (B,C) correspond to known cubic splines: Catmull-Rom (B=0,C=0.5), B-Spline (B=1,C=0) and other.
//      Mitchell, Don P.; Netravali, Arun N. (Aug. 1988). "Reconstruction filters in computer graphics"
//      http://www.mentallandscape.com/Papers_siggraph88.pdf
//
//    2. Hahn filter does not supported now.
//    3. The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 1x1,
//       Linear 2x2, Cubic 4x4, 2-lobed Lanczos 4x4, 3-lobed Lanczos 6x6.
*)

  ippiResizeAntialiasingLinearInit: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;

  ippiResizeAntialiasingCubicInit: function(srcSize:IppiSize;dstSize:IppiSize;valueB:Ipp32f;valueC:Ipp32f;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;

  ippiResizeAntialiasingLanczosInit: function(srcSize:IppiSize;dstSize:IppiSize;numLobes:Ipp32u;pSpec:PIppiResizeSpec_32f;pInitBuf:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeAntialiasing
//
//  Purpose:            Changes an image size by different interpolation methods with antialiasing technique
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstOffset         Offset of tiled image respectively destination image origin
//    dstSize           Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of output image is zero
//    ippStsBorderErr           Indicates an error if border type has an illegal value
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//    ippStsSizeErr             Indicates an error if width or height of the destination image
//                              is negative
//    ippStsStepErr             Indicates an error if the step value is not data type multiple
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside the
//                              destination image origin
//    ippStsSizeWrn             Indicates a warning if the destination image size is more than
//                              the destination image origin size
//
//  Notes:
//    1. Supported border types are ippBorderInMemory and ippBorderReplicate
//    2. Hahn filter does not supported now.
*)
  ippiResizeAntialiasing_8u_C1R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_8u_C3R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_8u_C4R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;

  ippiResizeAntialiasing_16u_C1R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_16u_C3R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_16u_C4R: function(pSrc:PIpp16u;srcStep:Ipp32s;pDst:PIpp16u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16u;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;

  ippiResizeAntialiasing_16s_C1R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_16s_C3R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_16s_C4R: function(pSrc:PIpp16s;srcStep:Ipp32s;pDst:PIpp16s;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp16s;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;

  ippiResizeAntialiasing_32f_C1R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_32f_C3R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;
  ippiResizeAntialiasing_32f_C4R: function(pSrc:PIpp32f;srcStep:Ipp32s;pDst:PIpp32f;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp32f;pSpec:PIppiResizeSpec_32f;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//                      Resize Transform Functions. YUY2 pixel format
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422GetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer for Resize transform
//
//  Parameters:
//    srcSize           Size of the source image (in pixels)
//    dstSize           Size of the destination image (in pixels)
//    interpolation     Interpolation method
//    antialiasing      Antialiasing method
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              - if the source image size is less than the filter size
//                                for the chosen interpolation method,
//                              - if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                positive value (the size of one of the processed images is too large).
//    ippStsSizeWrn             Indicates a warning if width of the image is odd
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNoAntialiasing      if the specified interpolation method does not support antialiasing.
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//
//  Notes:
//    1. Supported interpolation methods are ippNearest, ippLinear.
//    2. Antialiasing feature does not supported now. The antialiasing value should be equal zero.
//    3. The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 2x1,
//       Linear 4x2.
*)
  ippiResizeYUV422GetSize: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:PIpp32s;pInitBufSize:PIpp32s):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422GetBufSize
//  Purpose:            Computes the size of external buffer for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstSize           Size of the output image (in pixels)
//    pBufSize          Pointer to the size (in bytes) of the external buffer
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation     Indicates a warning if width or height of the destination image is
//                          equal to zero.
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsSizeWrn         Indicates a warning in the following cases:
//                          - if width of the image is odd,
//                          - if the destination image size is more than the destination image origin size
//    ippStsSizeErr         Indicates an error in the following cases:
//                          - if width of the image is equal to 1,
//                          - if width or height of the source or destination image is negative,
//                          - if the calculated buffer size exceeds maximum 32 bit signed integer positive
//                          value (the processed image size is too large)
*)
  ippiResizeYUV422GetBufSize: function(pSpec:PIppiResizeYUV422Spec;dstSize:IppiSize;pBufSize:PIpp32s):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422GetBorderSize
//  Purpose:            Computes the size of possible borders for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    borderSize        Size of necessary borders
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
*)
  ippiResizeYUV422GetBorderSize: function(pSpec:PIppiResizeYUV422Spec;borderSize:PIppiBorderSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422GetSrcOffset
//  Purpose:            Computes the offset of input image for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstOffset         Offset of the tiled destination image respective to the destination image origin
//    srcOffset         Pointer to the computed offset of source image
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsMisalignedOffsetErr Indicates an error if the x field of the dstOffset parameter is odd.
//    ippStsContextMatchErr     Indicates an error if pointer to the spec structure is invalid.
*)
  ippiResizeYUV422GetSrcOffset: function(pSpec:PIppiResizeYUV422Spec;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422GetSrcRoi
//  Purpose:            Computes the ROI of input image
//                      for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstRoiOffset      Offset of the destination image ROI
//    dstRoiSize        Size of the ROI of destination image
//    srcRoiOffset      Pointer to the computed offset of source image ROI
//    srcRoiSize        Pointer to the computed ROI size of source image
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsSizeErr             Indicates an error if width of the destination ROI is less or equal to 1,
//                              or if height of the destination ROI is equal to zero or negative
//    ippStsMisalignedOffsetErr Indicates an error if the x field of the dstOffset parameter is odd.
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside
//                              the destination image origin
//    ippStsSizeWrn             Indicates a warning in the following cases:
//                               - if width of the image is odd,
//                               - if the destination image size is more than the destination image origin size.
*)
  ippiResizeYUV422GetSrcRoi: function(pSpec:PIppiResizeYUV422Spec;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422NearestInit
//                      ippiResizeYUV422LinearInit
//
//  Purpose:            Initializes the Spec structure for the Resize transform
//                      by different interpolation methods
//  Parameters:
//    srcSize           Size of the source image (in pixels)
//    dstSize           Size of the destination image (in pixels)
//    pSpec             Pointer to the Spec structure for resize filter
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation     Indicates a warning if width or height of any image is zero
//    ippStsSizeWrn         Indicates a warning if width of any image is odd
//    ippStsSizeErr         Indicates an error in the following cases:
//                          - if width of the image is equal to 1,
//                          - if width or height of the source or destination image is negative,
//                          - if the source image size is less than the chosen
//                            interpolation method filter size
//  Notes:
//    1.The implemented interpolation algorithms have the following filter sizes: Nearest Neighbor 2x1,
//      Linear 4x2.
*)
  ippiResizeYUV422NearestInit: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeYUV422Spec):IppStatus;
  ippiResizeYUV422LinearInit: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeYUV422Spec):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV422Nearest_8u_C2R
//                      ippiResizeYUV422Linear_8u_C2R
//
//  Purpose:            Changes an image size by different interpolation methods
//
//  Parameters:
//    pSrc              Pointer to the source image
//    srcStep           Distance (in bytes) between of consecutive lines in the source image
//    pDst              Pointer to the destination image
//    dstStep           Distance (in bytes) between of consecutive lines in the destination image
//    dstOffset         Offset of tiled image respectively output origin image
//    dstSize           Size of the destination image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr                Indicates no error
//    ippStsNullPtrErr           Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation          Indicates a warning if width or height of output image is zero
//    ippStsContextMatchErr      Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsSizeWrn              Indicates a warning in the following cases:
/                                - if width of the image is odd,
//                               - if the destination image size is more than the destination image origin size.
//    ippStsMisalignedOffsetErr  Indicates an error if the x field of the dstOffset parameter is odd
//    ippStsSizeErr              Indicates an error if width of the destination image is equal to 1,
//                               or if width or height of the source or destination image is negative
//    ippStsOutOfRangeErr        Indicates an error if the destination image offset point is outside
//                               the destination image origin
//    ippStsStepErr              Indicates an error if the step value is not data type multiple
//
//  Notes:
//    1. YUY2 pixel format (Y0U0Y1V0,Y2U1Y3V1,.. or Y0Cb0Y1Cr0,Y2Cb1Y3Cr1,..).
//    2. Supported border types are ippBorderInMemory and ippBorderReplicate for Linear method.
*)
  ippiResizeYUV422Nearest_8u_C2R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeYUV422Spec;pBuffer:PIpp8u):IppStatus;
  ippiResizeYUV422Linear_8u_C2R: function(pSrc:PIpp8u;srcStep:Ipp32s;pDst:PIpp8u;dstStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;pBorderValue:PIpp8u;pSpec:PIppiResizeYUV422Spec;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//                      Resize Transform Functions. NV12 planar format
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420GetSize
//  Purpose:            Computes the size of Spec structure and temporal buffer for Resize transform
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    interpolation     Interpolation method
//    antialiasing      Antialiasing method
//    pSpecSize         Pointer to the size (in bytes) of the Spec structure
//    pInitBufSize      Pointer to the size (in bytes) of the temporal buffer
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation         Indicates a warning if width or height of any image is zero
//    ippStsSizeErr             Indicates an error in the following cases:
//                              - if width or height of the image is equal to 1,
//                              - if the source image size is less than a filter size of
//                                the chosen interpolation method (except ippSuper),
//                              - if one of the specified dimensions of the source image is less than
//                                the corresponding dimension of the destination image
//                                (for ippSuper method only),
//                              - if width or height of the source or destination image is negative,
//                              - if one of the calculated sizes exceeds maximum 32 bit signed integer
//                                positive value (the size of the one of the processed images is too large).
//    ippStsSizeWrn             Indicates a warning if width or height of any image is odd
//    ippStsInterpolationErr    Indicates an error if interpolation has an illegal value
//    ippStsNoAntialiasing      Indicates a warning if the specified interpolation method does not
//                              support antialiasing
//    ippStsNotSupportedModeErr Indicates an error if requested mode is currently not supported
//
//  Notes:
//    1. Supported interpolation methods are ippLanczos and ippSuper.
//    2. Antialiasing feature does not supported now. The antialiasing value should be equal zero.
//    3. The implemented interpolation algorithms have the following filter sizes: 2-lobed Lanczos 4x4
*)
  ippiResizeYUV420GetSize: function(srcSize:IppiSize;dstSize:IppiSize;interpolation:IppiInterpolationType;antialiasing:Ipp32u;pSpecSize:PIpp32s;pInitBufSize:PIpp32s):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420GetBufferSize
//  Purpose:            Computes the size of external buffer for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstSize           Size of the output image (in pixels)
//    pBufSize          Pointer to the size (in bytes) of the external buffer
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsNoOperation     Indicates a warning if width or height of destination image is zero
//    ippStsSizeWrn         Indicates a warning in the following cases:
//                          - if width or height of the image is odd,
//                          - if the destination image size is more than the destination
/                             image origin size
//    ippStsSizeErr         Indicates an error in the following cases
//                          - if width or height of the image is equal to 1,
//                          - if width or height of the destination image is negative,
//                          - if the calculated buffer size exceeds maximum 32 bit signed integer
//                            positive value (the processed image size is too large)
*)
  ippiResizeYUV420GetBufferSize: function(pSpec:PIppiResizeYUV420Spec;dstSize:IppiSize;pBufSize:PIpp32s):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420GetBorderSize
//  Purpose:            Computes the size of possible borders for Resize transform
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    borderSize        Size of necessary borders
//
//  Return Values:
//    ippStsNoErr           Indicates no error
//    ippStsNullPtrErr      Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr Indicates an error if pointer to an invalid pSpec structure is passed
*)
  ippiResizeYUV420GetBorderSize: function(pSpec:PIppiResizeYUV420Spec;borderSize:PIppiBorderSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420GetSrcOffset
//  Purpose:            Computes the offset of input image for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstOffset         Point of offset of tiled output image
//    srcOffset         Pointer to the computed offset of input image
//
//  Return Values:
//    ippStsNoErr                Indicates no error
//    ippStsNullPtrErr           Indicates an error if one of the specified pointers is NULL
//    ippStsContextMatchErr      Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr        Indicates an error if the destination image offset
//                               point is outside the destination image origin
//    ippStsMisalignedOffsetErr  Indicates an error if one of the fields of the dstOffset parameter is odd.
*)
  ippiResizeYUV420GetSrcOffset: function(pSpec:PIppiResizeYUV420Spec;dstOffset:IppiPoint;srcOffset:PIppiPoint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420GetSrcRoi
//  Purpose:            Computes the ROI of input image
//                      for Resize transform by tile processing
//
//  Parameters:
//    pSpec             Pointer to the Spec structure for resize filter
//    dstRoiOffset      Offset of the destination image ROI
//    dstRoiSize        Size of the ROI of destination image
//    srcRoiOffset      Pointer to the computed offset of source image ROI
//    srcRoiSize        Pointer to the computed ROI size of source image
//
//  Return Values:
//    ippStsNoErr               Indicates no error
//    ippStsNullPtrErr          Indicates an error if one of the specified pointers is NULL
//    ippStsSizeErr             Indicates an error if width or height of the destination ROI is less or equal to 1,
//    ippStsMisalignedOffsetErr Indicates an error if one of the fields of the dstOffset parameter is odd.
//    ippStsContextMatchErr     Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsOutOfRangeErr       Indicates an error if the destination image offset point is outside
//                              the destination image origin
//    ippStsSizeWrn             Indicates a warning in the following cases:
//                               - if width of the image is odd,
//                               - if the destination image size is more than the destination image origin size.
*)
  ippiResizeYUV420GetSrcRoi: function(pSpec:PIppiResizeYUV420Spec;dstRoiOffset:IppiPoint;dstRoiSize:IppiSize;srcRoiOffset:PIppiPoint;srcRoiSize:PIppiSize):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420LanczosInit
//                      ippiResizeYUV420SuperInit
//
//  Purpose:            Initializes the Spec structure for the Resize transform
//                      by different interpolation methods
//
//  Parameters:
//    srcSize           Size of the input image (in pixels)
//    dstSize           Size of the output image (in pixels)
//    pSpec             Pointer to the Spec structure for resize filter
//
//  Return Values:
//    ippStsNoErr                Indicates no error
//    ippStsNullPtrErr           Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation          Indicates a warning if width or height of any image is zero
//    ippStsSizeWrn              Indicates a warning if width or height of any image is odd
//    ippStsSizeErr              Indicates an error in the following cases:
//                                - if width or height of the source or destination image is equal to 1,
//                                - if width or height of the source or destination image is negative,
//                                - if the source image size is less than the chosen interpolation
//                                  filter size (excepting ippSuper)
//                                - if one of the specified dimensions of the source image is less than
//                                  the corresponding dimension of the destination image (only for ippSuper)
//    ippStsNotSupportedModeErr  Indicates an error if the requested mode is not supported
//
//    Note.
//    The implemented interpolation algorithms have the following filter sizes:
//      2-lobed Lanczos 8x8, 3-lobed Lanczos 12x12.
*)
  ippiResizeYUV420LanczosInit: function(srcSize:IppiSize;dstSize:IppiSize;numLobes:Ipp32u;pSpec:PIppiResizeYUV420Spec;pInitBuf:PIpp8u):IppStatus;
  ippiResizeYUV420SuperInit: function(srcSize:IppiSize;dstSize:IppiSize;pSpec:PIppiResizeYUV420Spec):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiResizeYUV420Lanczos_8u_P2R
//                      ippiResizeYUV420Super_8u_P2R
//
//  Purpose:            Changes an image size by different interpolation methods
//
//  Parameters:
//    pSrcY             Pointer to the source image Y plane
//    srcYStep          Distance (in bytes) between of consecutive lines in the source image Y plane
//    pSrcUV            Pointer to the source image UV plane
//    srcUVStep         Distance (in bytes) between of consecutive lines in the source image UV plane
//    pDstY             Pointer to the destination image Y plane
//    dstYStep          Distance (in bytes) between of consecutive lines in the destination image Y plane
//    pDstUV            Pointer to the destination image UV plane
//    dstUVStep         Distance (in bytes) between of consecutive lines in the destination image UV plane
//    dstOffset         Offset of tiled image respectively output origin image
//    dstSize           Size of the output image (in pixels)
//    border            Type of the border
//    borderValue       Pointer to the constant value(s) if border type equals ippBorderConstant
//    pSpec             Pointer to the Spec structure for resize filter
//    pBuffer           Pointer to the work buffer
//
//  Return Values:
//    ippStsNoErr                Indicates no error
//    ippStsNullPtrErr           Indicates an error if one of the specified pointers is NULL
//    ippStsNoOperation          Indicates a warning if width or height of destination image is zero
//    ippStsSizeWrn              Indicates a warning in the following cases:
//                               - if width of the image is odd,
//                               - if the destination image exceeds the destination image origin
//    ippStsSizeErr              Indicates an error if width of the destination image is equal to 1,
//                               or if width or height of the source or destination image is negative
//    ippStsBorderErr            Indicates an error if border type has an illegal value
//    ippStsContextMatchErr      Indicates an error if pointer to an invalid pSpec structure is passed
//    ippStsMisalignedOffsetErr  Indicates an error if one of the fields of the dstOffset parameter is odd
//    ippStsNotSupportedModeErr  Indicates an error if the requested mode is not supported
//
//  Notes:
//    1. Source 4:2:0 two-plane image format (NV12):
//      All Y samples (pSrcY) are found first in memory as an array of unsigned char with an even number of lines memory alignment,
//      followed immediately by an array (pSrcUV) of unsigned char containing interleaved U and V samples.
//    2. Supported border types are ippBorderInMemory and ippBorderReplicate for Lanczos methods.
*)
  ippiResizeYUV420Lanczos_8u_P2R: function(pSrcY:PIpp8u;srcYStep:Ipp32s;pSrcUV:PIpp8u;srcUVStep:Ipp32s;pDstY:PIpp8u;dstYStep:Ipp32s;pDstUV:PIpp8u;dstUVStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;border:IppiBorderType;borderValue:PIpp8u;pSpec:PIppiResizeYUV420Spec;pBuffer:PIpp8u):IppStatus;
  ippiResizeYUV420Super_8u_P2R: function(pSrcY:PIpp8u;srcYStep:Ipp32s;pSrcUV:PIpp8u;srcUVStep:Ipp32s;pDstY:PIpp8u;dstYStep:Ipp32s;pDstUV:PIpp8u;dstUVStep:Ipp32s;dstOffset:IppiPoint;dstSize:IppiSize;pSpec:PIppiResizeYUV420Spec;pBuffer:PIpp8u):IppStatus;

(*****************************************************************************************************
//  Name:       ippiFilterBorderGetSize, ippiFilterBorderInit, ippiFilterBorder
//  Purpose:    Filters an image using a general integer rectangular kernel
//  Returns:
//   ippStsNoErr       OK
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     dstRoiSize or kernelSize has a field with zero or negative value
//   ippStsDivisorErr  Divisor value is zero, function execution is interrupted
//
//  Parameters:
//      pSrc        Distance, in bytes, between the starting points of consecutive lines in the source image
//      srcStep     Step in bytes through the source image buffer
//      pDst        Pointer to the destination buffer
//      dstStep     Distance, in bytes, between the starting points of consecutive lines in the destination image
//      dstRoiSize  Size of the source and destination ROI in pixels
//      pKernel     Pointer to the kernel values
//      kernelSize  Size of the rectangular kernel in pixels.
//      divisor     The integer value by which the computed result is divided.
//      kernelType  Kernel type {ipp16s|ipp32f}
//      dataType    Data type {ipp8u|ipp16u|ipp32f}
//      numChannels Number of channels, possible values are 1, 3 or 4
//      roundMode   Rounding mode (ippRndZero, ippRndNear or ippRndFinancial)
//      pSpecSize   Pointer to the size (in bytes) of the spec structure
//      pBufSize    Pointer to the size (in bytes) of the external buffer
//      pSpec       Pointer to pointer to the allocated and initialized context structure
//      borderType  Type of the border
//      borderValue Pointer to the constant value(s) if border type equals ippBorderConstant
//      pBuffer     Pointer to the work buffer. It can be equal to NULL if optimization algorithm doesn't demand a work buffer
*)

  ippiFilterBorderGetSize: function(kernelSize:IppiSize;dstRoiSize:IppiSize;dataType:IppDataType;kernelType:IppDataType;numChannels:longint;pSpecSize:Plongint;pBufferSize:Plongint):IppStatus;
  ippiFilterBorderInit_16s: function(pKernel:PIpp16s;kernelSize:IppiSize;divisor:longint;dataType:IppDataType;numChannels:longint;roundMode:IppRoundMode;pSpec:PIppiFilterBorderSpec):IppStatus;
  ippiFilterBorderInit_32f: function(pKernel:PIpp32f;kernelSize:IppiSize;dataType:IppDataType;numChannels:longint;roundMode:IppRoundMode;pSpec:PIppiFilterBorderSpec):IppStatus;
  ippiFilterBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp8u;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp8u;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp8u;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16u;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16u;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16u;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16s;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16s;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp16s;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp32f;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp32f;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;
  ippiFilterBorder_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;border:IppiBorderType;var borderValue:Ipp32f;pSpec:PIppiFilterBorderSpec;pBuffer:PIpp8u):IppStatus;

(*
//  Name:       ippiFilterBorderSetMode
//  Purpose:    Set offset value for Ipp8u and Ipp16u and roundMode (Fast or Accurate)
//                               
//  Parameters:
//    hint        ippAlgHintNone, ippAlgHintFast, ippAlgHintAccurate.  Default, fast or accurate rounding.
//                             ippAlgHintNone and ippAlgHintFast - default modes, mean that the most common rounding is performed with 
//                             roundMode passed to Init function, but function performance takes precedence over accuracy and some output
//                             pixels can differ on +-1 from exact result
//                             ippAlgHintAccurate means that all output pixels are exact and accuracy takes precedence over performance
//    offset             offset value. It is just a constant that is added to the final signed result before converting it to unsigned for Ipp8u and Ipp16u data types
//    pSpec            Pointer to the initialized ippiFilter Spec

//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  one of the pointers is NULL
//    ippStsNotSupportedModeErr     the offset value is not supported, for Ipp16s and Ipp32f data types.
//    ippStsAccurateModeNotSupported the accurate mode not supported for some data types. The result of rounding can be inexact.
*)

  ippiFilterBorderSetMode: function(hint:IppHintAlgorithm;offset:longint;pSpec:PIppiFilterBorderSpec):IppStatus;

(*****************************************************************************************************
//  Name:       ippiLBPImageMode
//  Purpose:    Calculates the LBP of the image.
//  Parameters:
//    pSrc        Pointer to the source image ROI.
//    srcStep     Distance in bytes between starting points of consecutive lines in the source image.
//    pDst        Pointer to the destination image ROI.
//    dstStep     Distance in bytes between starting points of consecutive lines in the destination image.
//    dstRoiSize  Size of the destination ROI in pixels.
//    mode        Specify how LBP is created.
//    borderType  Type of border.
//                Possible values are:
//                     ippBorderRepl Border is replicated from the edge pixels.
//                     ippBorderInMem Border is obtained from the source image pixels in memory.
//                     Mixed borders are also supported.
//                     They can be obtained by the bitwise operation OR between ippBorderRepl and ippBorderInMemTop, ippBorderInMemBottom, ippBorderInMemLeft, ippBorderInMemRight.
//    borderValue Constant value to assign to pixels of the constant border. This parameter is applicable only to the ippBorderConst border type.
//  Returns:
//    ippStsNoErr      Indicates no error.
//    ippStsNullPtrErr Indicates an error when one of the specified pointers is NULL.
//    ippStsSizeErr    Indicates an error if dstRoiSize has a field with zero or negative value.
//    ippStsBadArgErr  Indicates an error when border has an illegal value.
*)
  ippiLBPImageMode3x3_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mode:longint;borderType:IppiBorderType;borderValue:PIpp8u):IppStatus;
  ippiLBPImageMode5x5_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mode:longint;borderType:IppiBorderType;borderValue:PIpp8u):IppStatus;
  ippiLBPImageMode5x5_8u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;mode:longint;borderType:IppiBorderType;borderValue:PIpp8u):IppStatus;
  ippiLBPImageMode3x3_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mode:longint;borderType:IppiBorderType;borderValue:PIpp32f):IppStatus;
  ippiLBPImageMode5x5_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mode:longint;borderType:IppiBorderType;borderValue:PIpp32f):IppStatus;
  ippiLBPImageMode5x5_32f16u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;mode:longint;borderType:IppiBorderType;borderValue:PIpp32f):IppStatus;



(*****************************************************************************************************
//  Name:       ippiLBPImageHorizCorr_...
//  Purpose:    Calculates a correlation between two LBPs.
//  Parameters:
//    pSrc1, pSrc2       Pointers to the source images ROI.
//    srcStep1, srcStep2 Distance in bytes between starting points of consecutive lines in the source image.
//    pDst               Pointer to the destination image ROI.
//    dstStep            Distance in bytes between starting points of consecutive lines in the destination image.
//    dstRoiSize         Size of the destination ROI in pixels.
//    horShift           Horizontal shift of the pSrc2 image.
//    borderType         Type of border. Possible values are:
//                           ippBorderRepl      Border is replicated from the edge pixels.
//                           ippBorderInMem     Border is obtained from the source image pixels in memory.
//                           Mixed borders are also supported.
//                           They can be obtained by the bitwise operation OR between ippBorderRepl and ippBorderInMemTop, ippBorderInMemBottom, ippBorderInMemLeft, ippBorderInMemRight.
//    borderValue         Constant value to assign to pixels of the constant border. This parameter is applicable only to the ippBorderConst border type.
//  Returns:
//    ippStsNoErr      Indicates no error.
//    ippStsNullPtrErr Indicates an error when one of the specified pointers is NULL.
//    ippStsSizeErr    Indicates an error if dstRoiSize has a field with zero or negative value.
//    ippStsBadArgErr  Indicates an error when border has an illegal value.
*)
  ippiLBPImageHorizCorr_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;horShift:longint;borderType:IppiBorderType;borderValue:PIpp8u):IppStatus;
  ippiLBPImageHorizCorr_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;horShift:longint;borderType:IppiBorderType;borderValue:PIpp16u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Name: ippiSADGetBufferSize
//
// Purpose: Compute size of the work buffer for the ippiSAD
//
// Parameters:
//    srcRoiSize  size of the source ROI in pixels
//    tplRoiSize  size of the template ROI in pixels
//    dataType    input data specifier
//    numChannels Number of channels in the images
//    shape       enumeration, defined shape result of the following SAD operation
//    pBufferSize pointer to the computed value of the external buffer size
//
//  Return:
//   ippStsNoErr        no errors
//   ippStsNullPtrErr   pBufferSize==NULL
//   ippStsSizeErr      0>=srcRoiSize.width || 0>=srcRoiSize.height
//                      0>=tplRoiSize.width || 0>=tplRoiSize.height
//   ippStsDataTypeErr  dataType!=8u or dataType!=16u or dataType!=16s or dataType!=32f
//   ippStsNotSupportedModeErr  shape != ippiROIValid
//                              numChannels != 1
//                              dataType has an illegal value
//
*F*)
  ippiSADGetBufferSize: function(srcRoiSize:IppiSize;tplRoiSize:IppiSize;dataType:IppDataType;numChannels:longint;shape:IppiROIShape;pBufferSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name: ippiSAD_...
//
// Purpose: Sum of Absolute Differences of given image and template
//
// Parameters:
//    pSrc        pointer to source ROI
//    srcStep     step through the source image
//    srcRoiSize  size of sourse ROI (pixels)
//    pTpl        pointer to template (source) ROI
//    tplStep     step through the template image
//    tplRoiSize  size of template ROI (pixels)
//    pDst        pointer to destination ROI
//    dstStep     step through the destination image
//    shape       defined shape result of the SAD operation
//    scaleFactor scale factor
//    pBuffer     pointer to the buffer for internal computation (is currentry used)
//
// Return status:
//    ippStsNoErr                no errors
//    ippStsNullPtrErr           pSrc==NULL or pTpl==NULL or pDst==NULL
//    ippStsStepErr              srcStep/dstStep has a zero or negative value
//                               srcStep/dstStep value is not multiple to image data size
//    ippStsSizeErr              ROI has any field with zero or negative value
//    ippStsNotSupportedModeErr  intersection of source and destination ROI is detected
//                               shape!=ippiROIValid
//    ippStsBadArgErr            illegal scaleFactor value, i.e. !(0<=scalefactor<log(W*H)
*F*)
  ippiSAD_8u32s_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;shape:IppiROIShape;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
  ippiSAD_16u32s_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp16u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;shape:IppiROIShape;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
  ippiSAD_16s32s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp16s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;shape:IppiROIShape;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;
  ippiSAD_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;shape:IppiROIShape;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiGradientVectorGetBufferSize
//
//  Purpose:            Computes the size of the external buffer for
//                      Gradient() calls
//
//  Parameters:
//    roiSize           Size of destination ROI in pixels
//    mask              Predefined mask of IppiMaskSize type. Possible values are ippMask3x3 or ippMask5x5
//    dataType          Input data type specifier
//    numChannels       Number of channels of the input image
//    pBufferSize       Pointer to the size (in bytes) of the external work buffer.
//
//  Return Values:
//    ippStsNoErr        Indicates no error
//    ippStsNullPtrErr   Indicates an error when pBufferSize is NULL
//    ippStsDataTypeErr  dataType!=8u or dataType!=16u or dataType!=16s or dataType!=32f
//    ippStsSizeErr      Indicates an error when roiSize is negative, or equal to zero.
//    ippStsMaskSizeErr  Indicates an error condition if mask has a wrong value
*)
  ippiGradientVectorGetBufferSize: function(roiSize:IppiSize;mask:IppiMaskSize;dataType:IppDataType;numChannels:longint;pBufferSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name: ippiGradientVectorSobel_8u16s_C1R
//       ippiGradientVectorSobel_16u32f_C1R
//       ippiGradientVectorSobel_16s32f_C1R
//       ippiGradientVectorSobel_32f_C1R
//
//       ippiGradientVectorScharr_8u16s_C1R
//       ippiGradientVectorScharr_16u32f_C1R
//       ippiGradientVectorScharr_16s32f_C1R
//       ippiGradientVectorScharr_32f_C1R
//
//       ippiGradientVectorPrewitt_8u16s_C1R
//       ippiGradientVectorPrewitt_16u32f_C1R
//       ippiGradientVectorPrewitt_16s32f_C1R
//       ippiGradientVectorPrewitt_32f_C1R
//
//       ippiGradientVectorSobel_8u16s_C3C1R
//       ippiGradientVectorSobel_16u32f_C3C1R
//       ippiGradientVectorSobel_16s32f_C3C1R
//       ippiGradientVectorSobel_32f_C3C1R
//
//       ippiGradientVectorScharr_8u16s_C3C1R
//       ippiGradientVectorScharr_16u32f_C3C1R
//       ippiGradientVectorScharr_16s32f_C3C1R
//       ippiGradientVectorScharr_32f_C3C1R
//
//       ippiGradientVectorPrewitt_8u16s_C3C1R
//       ippiGradientVectorPrewitt_16u32f_C3C1R
//       ippiGradientVectorPrewitt_16s32f_C3C1R
//       ippiGradientVectorPrewitt_32f_C3C1R
//
// Purpose: Computes gradient vectors over an image using Sobel, Scharr or Prewitt operator
//
// Parameters:
//    pSrc        pointer to source ROI
//    srcStep     step through the source image
//    pGx         pointer to the X-component of computed gradient
//    gxStep      step through the X-component image
//    pGy         pointer to the Y-component of computed gradient
//    gyStep      step through the Y-component image
//    pMag        pointer to the magnitude of computed gradient
//    magStep     step through the magnitude image
//    pAngle      pointer to the angle of computed gradient
//    angleStep   step through the magnitude image
//    dstRoiSize  size of destination
//    mask        operator size specfier
//    normType    normalization type (L1 or L2) specfier
//    borderType  kind of border specfier
//    borderValue constant border value
//    pBuffer     pointer to the buffer for internal computation  (is currentry used)
//
// Return status:
//    ippStsNoErr          no error
//    ippStsNullPtrErr     pSrc==NULL
//    ippStsStepErr        srcStep has a zero or negative value
//                         applicable gxStep or gyStep or magStep or angleStep has a zero or negative value
//                         or is not multiple to image data size (4 for floating-point images or by 2 for short-integer images)
//    ippStsSizeErr        ROI has any field with zero or negative value
//    ippStsMaskSizeErr    illegal maskSize specfier value
//    ippStsBadArgErr      illegal normType specfier value
//    ippStsBorderErr      illegal borderType specfier value
*F*)
  ippiGradientVectorSobel_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pGx:PIpp16s;gxStep:longint;pGy:PIpp16s;gyStep:longint;pMag:PIpp16s;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorSobel_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorSobel_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorSobel_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiGradientVectorScharr_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pGx:PIpp16s;gxStep:longint;pGy:PIpp16s;gyStep:longint;pMag:PIpp16s;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorScharr_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorScharr_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorScharr_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiGradientVectorPrewitt_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pGx:PIpp16s;gxStep:longint;pGy:PIpp16s;gyStep:longint;pMag:PIpp16s;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorPrewitt_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorPrewitt_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorPrewitt_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiGradientVectorSobel_8u16s_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pGx:PIpp16s;gxStep:longint;pGy:PIpp16s;gyStep:longint;pMag:PIpp16s;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorSobel_16u32f_C3C1R: function(pSrc:PIpp16u;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorSobel_16s32f_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorSobel_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiGradientVectorScharr_8u16s_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pGx:PIpp16s;gxStep:longint;pGy:PIpp16s;gyStep:longint;pMag:PIpp16s;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorScharr_16u32f_C3C1R: function(pSrc:PIpp16u;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorScharr_16s32f_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorScharr_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiGradientVectorPrewitt_8u16s_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pGx:PIpp16s;gxStep:longint;pGy:PIpp16s;gyStep:longint;pMag:PIpp16s;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorPrewitt_16u32f_C3C1R: function(pSrc:PIpp16u;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorPrewitt_16s32f_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiGradientVectorPrewitt_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pGx:PIpp32f;gxStep:longint;pGy:PIpp32f;gyStep:longint;pMag:PIpp32f;magStep:longint;pAngle:PIpp32f;angleStep:longint;dstRoiSize:IppiSize;maskSize:IppiMaskSize;normType:IppNormType;borderType:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;


(* /////////////////////////////////////////////////////////////////////////////
// Name:                ippiHOGGetSize
//
// Purpose:             Computes size of HOG spec
//
// Parameters:
//    pConfig           pointer to HOG configure
//    pSpecSize         pointer to the size of HOG spec
//
// Return status:
//    ippStsNoErr          Indicates no error
//    ippStsNullPtrErr     Indicates an error when pConfig or pSpecSize is NULL
//    ippStsSizeErr        Indicates an error in HOG configure:
//                         size of detection window has any field with zero or negative value
//    ippStsNotSupportedModeErr Indicates an error in HOG configure:
//                         - 2>cellSize or cellSize>IPP_HOG_MAX_CELL
//                         - cellSize>blockSize or blockSize>IPP_HOG_MAX_BLOCK
//                         - blockSize is not multiple cellSize
//                         - block has not 2x2 cell geomentry
//                         - blockStride is not multiple cellSize
//                         - detection window size is not multiple blockSize
//                         - 2>nbins or nbins>IPP_HOG_MAX_BINS
//                         - sigma or l2thresh is not positive value
*F*)
  ippiHOGGetSize: function(pConfig:PIppiHOGConfig;pHOGSpecSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name:                ippiHOGInit
//
// Purpose:             Initialize the HOG spec for future use
//
// Parameters:
//    pConfig           pointer to HOG configure
//    pHOGSpec          pointer to the HOG spec
//
// Return status:
//    ippStsNoErr          Indicates no error
//    ippStsNullPtrErr     Indicates an error when pConfig or pHOGSpec is NULL
//
//    ippStsSizeErr        Indicates an error when size of detection window
//                         defined in pConfig is not match to other
//                         (blockSize and blockStride) geometric parameters
//    ippStsNotSupportedModeErr Indicates an error in HOG configure:
//                         - 2>cellSize or cellSize>IPP_HOG_MAX_CELL
//                         - cellSize>blockSize or blockSize>IPP_HOG_MAX_BLOCK
//                         - blockSize is not multiple cellSize
//                         - block has not 2x2 cell geomentry
//                         - blockStride is not multiple cellSize
//                         - 2>nbins or nbins>IPP_HOG_MAX_BINS
//                         - sigma or l2thresh is not positive value
*F*)
  ippiHOGInit: function(pConfig:PIppiHOGConfig;pHOGSpec:PIppiHOGSpec):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name:                ippiHOGGetBufferSize
//
// Purpose:             Computes size of work buffer
//
// Parameters:
//    pHOGSpec          pointer to the HOG spec
//    roiSize           max size of input ROI (pixels)
//    pBufferSize       pointer to the size of work buffer (in bytes)
//
// Return status:
//    ippStsNoErr          Indicates no error
//    ippStsNullPtrErr     Indicates an error when pHOGSpec or pBufferSizeis is NULL
//    ippStsContextMatchErr Indicates an error when undefined pHOGSpec
//    ippStsSizeErr        Indicates an error if roiSize has any field is less then pConfig->winSize
*F*)
  ippiHOGGetBufferSize: function(pHOGSpec:PIppiHOGSpec;roiSize:IppiSize;pBufferSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name:                ippiHOGGetDescriptorSize
//
// Purpose:             Computes size of HOG descriptor
//
// Parameters:
//    pHOGSpec             pointer to the HOG spec
//    pWinDescriptorSize   pointer to the size of HOG descriptor (in bytes)
//                         per each detection window
//
// Return status:
//    ippStsNoErr          Indicates no error
//    ippStsNullPtrErr     Indicates an error when pHOGSpec or pDescriptorSize is NULL
//    ippStsContextMatchErr Indicates an error when undefined pHOGSpec
*F*)
  ippiHOGGetDescriptorSize: function(pHOGSpec:PIppiHOGSpec;pWinDescriptorSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
// Name:                ippiHOG
//
// Purpose:             Computes HOG descriptor
//
// Parameters:
//    pSrc              pointer to the input detection window
//    roiSize           size of detection window
//    srcStep           input image step
//    pLocation         array of locations of interest (LOI) (detection window position)
//    nLocations        number of LOI
//    pDst              pointer to the HOG descriptor
//    pHOGSpec          pointer to the HOG spec
//    borderID          border type specifier
//    borderValue       border constant value
//    pBuffer           pointer to the work buffer
//
// Return status:
//    ippStsNoErr          Indicates no error
//    ippStsNullPtrErr     Indicates an error when pHOGSpec, pSrc, or pDst is NULL
//    ippStsContextMatchErr Indicates an error when undefined pHOGSpec
//    ippStsStepErr        Indicates an error is input image step isn't positive
//    ippStsNotEvenStepErr Indicates an error when srcStep is not multiple input data type
//    ippStsSizeErr        Indicates an error if roiSize isn't matchs to HOG context
//    ippStsBorderErr      Indicates an error when borderID is not
//                         ippBorderInMem, ippBorderRepl or ippBorderConst
//                         (or derivative from)
*F*)
  ippiHOG_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGSpec:PIppiHOGSpec;borderID:IppiBorderType;borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiHOG_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGSpec:PIppiHOGSpec;borderID:IppiBorderType;borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiHOG_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGSpec:PIppiHOGSpec;borderID:IppiBorderType;borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiHOG_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGSpec:PIppiHOGSpec;borderID:IppiBorderType;borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

  ippiHOG_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGCtx:PIppiHOGSpec;borderID:IppiBorderType;var borderValue:Ipp8u;pBuffer:PIpp8u):IppStatus;
  ippiHOG_16u32f_C3R: function(pSrc:PIpp16u;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGCtx:PIppiHOGSpec;borderID:IppiBorderType;var borderValue:Ipp16u;pBuffer:PIpp8u):IppStatus;
  ippiHOG_16s32f_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGCtx:PIppiHOGSpec;borderID:IppiBorderType;var borderValue:Ipp16s;pBuffer:PIpp8u):IppStatus;
  ippiHOG_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pLocation:PIppiPoint;nLocations:longint;pDst:PIpp32f;pHOGCtx:PIppiHOGSpec;borderID:IppiBorderType;var borderValue:Ipp32f;pBuffer:PIpp8u):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//           3D Geometric Transform Functions
//////////////////////////////////////////////////////////////////////////////// *)

(*
//  Name:               ipprResizeGetBufSize
//  Purpose:            Computes the size of an external work buffer (in bytes)
//  Parameters:
//    srcVOI            region of interest of source volume
//    dstVOI            region of interest of destination volume
//    nChannel          number of channels
//    interpolation     type of interpolation to perform for resizing the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE      B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM   Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03       special filter with parameters (1/2, 3/10)
//    pSize             pointer to the external buffer`s size
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSize == NULL
//    ippStsSizeErr           width or height or depth of volumes is less or equal zero
//    ippStsNumChannelsErr    number of channels is not one
//    ippStsInterpolationErr  (interpolation != IPPI_INTER_NN) &&
//                            (interpolation != IPPI_INTER_LINEAR) &&
//                            (interpolation != IPPI_INTER_CUBIC) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_BSPLINE) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_CATMULLROM) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_B05C03)
*)

  ipprResizeGetBufSize: function(srcVOI:IpprCuboid;dstVOI:IpprCuboid;nChannel:longint;interpolation:longint;pSize:Plongint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ipprGetResizeCuboid
//  Purpose:            Computes coordinates of the destination volume
//  Parameters:
//    srcVOI            volume of interest of source volume
//    pDstCuboid        resultant cuboid
//    xFactor           they specify fraction of resizing in X direction
//    yFactor           they specify fraction of resizing in Y direction
//    zFactor           they specify fraction of resizing in Z direction
//    xShift            they specify shifts of resizing in X direction
//    yShift            they specify shifts of resizing in Y direction
//    zShift            they specify shifts of resizing in Z direction
//    interpolation     type of interpolation
//  Returns:
//    ippStsNoErr             no errors
//    ippStsSizeErr           width or height or depth of srcVOI is less or equal zero
//    ippStsResizeFactorErr   xFactor or yFactor or zFactor is less or equal zero
//    ippStsInterpolationErr  interpolation has an illegal value
//    ippStsNullPtrErr        pDstCuboid == NULL
*)

  ipprGetResizeCuboid: function(srcVOI:IpprCuboid;pDstCuboid:PIpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint):IppStatus;

(*
//  Name:               ipprResize_<mode>
//  Purpose:            Performs RESIZE transform of the source volume
//                      by xFactor, yFactor, zFactor and xShift, yShift, zShift
//                            |X'|   |xFactor    0       0   |   |X|   |xShift|
//                            |Y'| = |        yFactor    0   | * |Y| + |yShift|
//                            |Z'|   |   0       0    zFactor|   |Z|   |zShift|
//  Parameters:
//    pSrc              pointer to source volume data (8u_C1V, 16u_C1V, 32f_C1V modes)
//                      or array of pointers to planes in source volume data
//    srcVolume         size of source volume
//    srcStep           step in every plane of source volume
//    srcPlaneStep      step between planes of source volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    srcVOI            volume of interest of source volume
//    pDst              pointer to destination volume data (8u_C1V and 16u_C1V modes)
//                      or array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstPlaneStep      step between planes of destination volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    dstVOI            volume of interest of destination volume
//    xFactor           they specify fraction of resizing in X direction
//    yFactor           they specify fraction of resizing in Y direction
//    zFactor           they specify fraction of resizing in Z direction
//    xShift            they specify shifts of resizing in X direction
//    yShift            they specify shifts of resizing in Y direction
//    zShift            they specify shifts of resizing in Z direction
//    interpolation     type of interpolation to perform for resizing the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE      B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM   Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03       special filter with parameters (1/2, 3/10)
//    pBuffer           pointer to work buffer
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSrc == NULL or pDst == NULL or pBuffer == NULL
//    ippStsSizeErr           width or height or depth of volumes is less or equal zero
//    ippStsWrongIntersectVOI VOI hasn't an intersection with the source or destination volume
//    ippStsResizeFactorErr   xFactor or yFactor or zFactor is less or equal zero
//    ippStsInterpolationErr  (interpolation != IPPI_INTER_NN) &&
//                            (interpolation != IPPI_INTER_LINEAR) &&
//                            (interpolation != IPPI_INTER_CUBIC) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_BSPLINE) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_CATMULLROM) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_B05C03)
//  Notes:
//    <mode> are 8u_C1V or 16u_C1V or 32f_C1V or 8u_C1PV or 16u_C1PV or 32f_C1PV
*)

  ipprResize_8u_C1V: function(pSrc:PIpp8u;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pDst:PIpp8u;dstStep:longint;dstPlaneStep:longint;dstVOI:IpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprResize_16u_C1V: function(pSrc:PIpp16u;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pDst:PIpp16u;dstStep:longint;dstPlaneStep:longint;dstVOI:IpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprResize_32f_C1V: function(pSrc:PIpp32f;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pDst:PIpp32f;dstStep:longint;dstPlaneStep:longint;dstVOI:IpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprResize_8u_C1PV: function(var pSrc:PIpp8u;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pDst:PIpp8u;dstStep:longint;dstVOI:IpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprResize_16u_C1PV: function(var pSrc:PIpp16u;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pDst:PIpp16u;dstStep:longint;dstVOI:IpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprResize_32f_C1PV: function(var pSrc:PIpp32f;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pDst:PIpp32f;dstStep:longint;dstVOI:IpprCuboid;xFactor:double;yFactor:double;zFactor:double;xShift:double;yShift:double;zShift:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;


(*
//  Name:               ipprWarpAffineGetBufSize
//  Purpose:            Computes the size of an external work buffer (in bytes)
//  Parameters:
//    srcVolume         size of source volume
//    srcVOI            region of interest of source volume
//    dstVOI            region of interest of destination volume
//    coeffs            affine transform matrix
//    nChannel          number of channels
//    interpolation     type of interpolation to perform for resizing the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE      B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM   Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03       special filter with parameters (1/2, 3/10)
//    pSize             pointer to the external buffer`s size
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSize == NULL or coeffs == NULL
//    ippStsSizeErr           size of source or destination volumes is less or equal zero
//    ippStsNumChannelsErr    number of channels is not one
//    ippStsInterpolationErr  (interpolation != IPPI_INTER_NN) &&
//                            (interpolation != IPPI_INTER_LINEAR) &&
//                            (interpolation != IPPI_INTER_CUBIC) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_BSPLINE) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_CATMULLROM) &&
//                            (interpolation != IPPI_INTER_CUBIC2P_B05C03)
*)

  ipprWarpAffineGetBufSize: function(srcVolume:IpprVolume;srcVOI:IpprCuboid;dstVOI:IpprCuboid;var coeffs:double;nChannel:longint;interpolation:longint;pSize:Plongint):IppStatus;

(*
//  Names:              ipprWarpAffine_<mode>
//  Purpose:            Performs AFFINE transform of the source volume by matrix a[3][4]
//                            |X'|   |a00 a01 a02|   |X|   |a03|
//                            |Y'| = |a10 a11 a12| * |Y| + |a13|
//                            |Z'|   |a20 a21 a22|   |Z|   |a23|
//  Parameters:
//    pSrc              array of pointers to planes in source volume data
//    srcVolume         size of source volume
//    srcStep           step in every plane of source volume
//    srcVOI            volume of interest of source volume
//    pDst              array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstVOI            volume of interest of destination volume
//    coeffs            affine transform matrix
//    interpolation     type of interpolation to perform for affine transform the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE      B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM   Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03       special filter with parameters (1/2, 3/10)
//    pBuffer           pointer to work buffer
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSrc == NULL or pDst == NULL or pBuffer == NULL or coeffs == NULL
//    ippStsSizeErr           width or height or depth of source volume is less or equal zero
//    ippStsWrongIntersectVOI VOI hasn't an intersection with the source or destination volume
//    ippStsCoeffErr          determinant of the transform matrix Aij is equal to zero
//    ippStsInterpolationErr  interpolation has an illegal value
//  Notes:
//    <mode> are 8u_C1PV or 16u_C1PV or 32f_C1PV
*)

  ipprWarpAffine_8u_C1PV: function(var pSrc:PIpp8u;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pDst:PIpp8u;dstStep:longint;dstVOI:IpprCuboid;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprWarpAffine_16u_C1PV: function(var pSrc:PIpp16u;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pDst:PIpp16u;dstStep:longint;dstVOI:IpprCuboid;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprWarpAffine_32f_C1PV: function(var pSrc:PIpp32f;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pDst:PIpp32f;dstStep:longint;dstVOI:IpprCuboid;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
(*
//  Names:              ipprWarpAffine_<mode>
//  Purpose:            Performs AFFINE transform of the source volume by matrix a[3][4]
//                            |X'|   |a00 a01 a02|   |X|   |a03|
//                            |Y'| = |a10 a11 a12| * |Y| + |a13|
//                            |Z'|   |a20 a21 a22|   |Z|   |a23|
//  Parameters:
//    pSrc              array of pointers to planes in source volume data
//    srcVolume         size of source volume
//    srcStep           step in every plane of source volume
//    srcPlaneStep      step between planes of source volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    srcVOI            volume of interest of source volume
//    pDst              array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstPlaneStep      step between planes of destination volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    dstVOI            volume of interest of destination volume
//    coeffs            affine transform matrix
//    interpolation     type of interpolation to perform for affine transform the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE      B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM   Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03       special filter with parameters (1/2, 3/10)
//    pBuffer           pointer to work buffer
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSrc == NULL or pDst == NULL or pBuffer == NULL or coeffs == NULL
//    ippStsSizeErr           width or height or depth of source volume is less or equal zero
//    ippStsWrongIntersectVOI VOI hasn't an intersection with the source or destination volume
//    ippStsCoeffErr          determinant of the transform matrix Aij is equal to zero
//    ippStsInterpolationErr  interpolation has an illegal value
//  Notes:
//    <mode> are 8u_C1V or 16u_C1V or 32f_C1V
*)

  ipprWarpAffine_8u_C1V: function(pSrc:PIpp8u;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pDst:PIpp8u;dstStep:longint;dstPlaneStep:longint;dstVOI:IpprCuboid;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;
  ipprWarpAffine_16u_C1V: function(pSrc:PIpp16u;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pDst:PIpp16u;dstStep:longint;dstPlaneStep:longint;dstVOI:IpprCuboid;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

  ipprWarpAffine_32f_C1V: function(pSrc:PIpp32f;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pDst:PIpp32f;dstStep:longint;dstPlaneStep:longint;dstVOI:IpprCuboid;var coeffs:double;interpolation:longint;pBuffer:PIpp8u):IppStatus;

(*
//  Names:              ipprRemap_<mode>
//  Purpose:            Performs REMAP TRANSFORM of the source volume by remapping
//                        dst[i,j,k] = src[xMap[i,j,k], yMap[i,j,k], zMap[i,j,k]]
//  Parameters:
//    pSrc              array of pointers to planes in source volume data
//    srcVolume         size of source volume
//    srcStep           step in every plane of source volume
//    srcVOI            volume of interest of source volume
//    pxMap             array of pointers to images with X coordinates of map
//    pyMap             array of pointers to images with Y coordinates of map
//    pzMap             array of pointers to images with Z coordinates of map
//    mapStep           step in every plane of each map volumes
//    pDst              array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstVolume         size of destination volume
//    interpolation     type of interpolation to perform for resizing the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE    B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03     special filter with parameters (1/2, 3/10)
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSrc == NULL or pDst == NULL or
//                            pxMap == NULL or pyMap == NULL or pzMap == NULL
//    ippStsSizeErr           width or height or depth of volumes is less or equal zero
//    ippStsInterpolationErr  interpolation has an illegal value
//    ippStsWrongIntersectVOI srcVOI hasn't intersection with the source volume, no operation
//  Notes:
//    <mode> are 8u_C1PV or 16u_C1PV or 32f_C1PV
*)

  ipprRemap_8u_C1PV: function(var pSrc:PIpp8u;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pxMap:PIpp32f;var pyMap:PIpp32f;var pzMap:PIpp32f;mapStep:longint;var pDst:PIpp8u;dstStep:longint;dstVolume:IpprVolume;interpolation:longint):IppStatus;

  ipprRemap_16u_C1PV: function(var pSrc:PIpp16u;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pxMap:PIpp32f;var pyMap:PIpp32f;var pzMap:PIpp32f;mapStep:longint;var pDst:PIpp16u;dstStep:longint;dstVolume:IpprVolume;interpolation:longint):IppStatus;

  ipprRemap_32f_C1PV: function(var pSrc:PIpp32f;srcVolume:IpprVolume;srcStep:longint;srcVOI:IpprCuboid;var pxMap:PIpp32f;var pyMap:PIpp32f;var pzMap:PIpp32f;mapStep:longint;var pDst:PIpp32f;dstStep:longint;dstVolume:IpprVolume;interpolation:longint):IppStatus;
(*
//  Names:              ipprRemap_<mode>
//  Purpose:            Performs REMAP TRANSFORM of the source volume by remapping
//                        dst[i,j,k] = src[xMap[i,j,k], yMap[i,j,k], zMap[i,j,k]]
//  Parameters:
//    pSrc              array of pointers to planes in source volume data
//    srcVolume         size of source volume
//    srcStep           step in every plane of source volume
//    srcPlaneStep      step between planes of source volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    srcVOI            volume of interest of source volume
//    pxMap             array of pointers to images with X coordinates of map
//    pyMap             array of pointers to images with Y coordinates of map
//    pzMap             array of pointers to images with Z coordinates of map
//    mapStep           step in every plane of each map volumes
//    pDst              array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstPlaneStep      step between planes of destination volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    dstVolume         size of destination volume
//    interpolation     type of interpolation to perform for resizing the input volume:
//                        IPPI_INTER_NN      nearest neighbor interpolation
//                        IPPI_INTER_LINEAR  trilinear interpolation
//                        IPPI_INTER_CUBIC   tricubic polynomial interpolation
//                      including two-parameter cubic filters:
//                        IPPI_INTER_CUBIC2P_BSPLINE    B-spline filter (1, 0)
//                        IPPI_INTER_CUBIC2P_CATMULLROM Catmull-Rom filter (0, 1/2)
//                        IPPI_INTER_CUBIC2P_B05C03     special filter with parameters (1/2, 3/10)
//  Returns:
//    ippStsNoErr             no errors
//    ippStsNullPtrErr        pSrc == NULL or pDst == NULL or
//                            pxMap == NULL or pyMap == NULL or pzMap == NULL
//    ippStsSizeErr           width or height or depth of volumes is less or equal zero
//    ippStsInterpolationErr  interpolation has an illegal value
//    ippStsWrongIntersectVOI srcVOI hasn't intersection with the source volume, no operation
//  Notes:
//    <mode> are 8u_C1V or 16u_C1V or 32f_C1V
*)

  ipprRemap_8u_C1V: function(pSrc:PIpp8u;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pxMap:PIpp32f;pyMap:PIpp32f;pzMap:PIpp32f;mapStep:longint;mapPlaneStep:longint;pDst:PIpp8u;dstStep:longint;dstPlaneStep:longint;dstVolume:IpprVolume;interpolation:longint):IppStatus;
  ipprRemap_16u_C1V: function(pSrc:PIpp16u;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pxMap:PIpp32f;pyMap:PIpp32f;pzMap:PIpp32f;mapStep:longint;mapPlaneStep:longint;pDst:PIpp16u;dstStep:longint;dstPlaneStep:longint;dstVolume:IpprVolume;interpolation:longint):IppStatus;
  ipprRemap_32f_C1V: function(pSrc:PIpp32f;srcVolume:IpprVolume;srcStep:longint;srcPlaneStep:longint;srcVOI:IpprCuboid;pxMap:PIpp32f;pyMap:PIpp32f;pzMap:PIpp32f;mapStep:longint;mapPlaneStep:longint;pDst:PIpp32f;dstStep:longint;dstPlaneStep:longint;dstVolume:IpprVolume;interpolation:longint):IppStatus;

(* /////////////////////////////////////////////////////////////////////////////
//           3D General Linear Filters
//////////////////////////////////////////////////////////////////////////////// *)

(*
//  Name:               ipprFilterGetBufSize
//  Purpose:            Computes the size of an external work buffer (in bytes)
//  Parameters:
//    dstVolume         size of the volume
//    kernelVolume      size of the kernel volume
//    nChannel          number of channels
//    pSize             pointer to the external buffer`s size
//  Returns:
//    ippStsNoErr           no errors
//    ippStsNullPtrErr      pSize == NULL
//    ippStsSizeErr         width or height or depth of volumes is less or equal zero
//    ippStsNumChannelsErr  number of channels is not one
*)

  ipprFilterGetBufSize: function(dstVolume:IpprVolume;kernelVolume:IpprVolume;nChannel:longint;pSize:Plongint):IppStatus;

(*
//  Name:               ipprFilter_16s_C1PV
//  Purpose:            Filters a volume using a general integer cuboidal kernel
//  Parameters:
//    pSrc              array of pointers to planes in source volume data
//    srcStep           step in every plane of source volume
//    pDst              array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstVolume         size of the processed volume
//    pKernel           pointer to the kernel values
//    kernelVolume      size of the kernel volume
//    anchor            anchor 3d-cell specifying the cuboidal kernel alignment
//                      with respect to the position of the input voxel
//    divisor           the integer value by which the computed result is divided
//    pBuffer           pointer to the external buffer`s size
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  one of the pointers is NULL
//    ippStsSizeErr     width or height or depth of volumes is less or equal zero
//    ippStsDivisorErr  divisor value is zero, function execution is interrupted
*)

  ipprFilter_16s_C1PV: function(var pSrc:PIpp16s;srcStep:longint;var pDst:PIpp16s;dstStep:longint;dstVolume:IpprVolume;pKernel:PIpp32s;kernelVolume:IpprVolume;anchor:IpprPoint;divisor:longint;pBuffer:PIpp8u):IppStatus;
(*
//  Name:               ipprFilter_16s_C1V
//  Purpose:            Filters a volume using a general integer cuboidal kernel
//  Parameters:
//    pSrc              array of pointers to planes in source volume data
//    srcStep           step in every plane of source volume
//    srcPlaneStep      step between planes of source volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    pDst              array of pointers to planes in destination volume data
//    dstStep           step in every plane of destination volume
//    dstPlaneStep      step between planes of destination volume (8u_C1V, 16u_C1V, 32f_C1V modes)
//    dstVolume         size of the processed volume
//    pKernel           pointer to the kernel values
//    kernelVolume      size of the kernel volume
//    anchor            anchor 3d-cell specifying the cuboidal kernel alignment
//                      with respect to the position of the input voxel
//    divisor           the integer value by which the computed result is divided
//    pBuffer           pointer to the external buffer`s size
//  Returns:
//    ippStsNoErr       no errors
//    ippStsNullPtrErr  one of the pointers is NULL
//    ippStsSizeErr     width or height or depth of volumes is less or equal zero
//    ippStsDivisorErr  divisor value is zero, function execution is interrupted
*)
  ipprFilter_16s_C1V: function(pSrc:PIpp16s;srcStep:longint;srcPlaneStep:longint;pDst:PIpp16s;dstStep:longint;dstPlaneStep:longint;dstVolume:IpprVolume;pKernel:PIpp32s;kernelVolume:IpprVolume;anchor:IpprPoint;divisor:longint;pBuffer:PIpp8u):IppStatus;

  ippiMulC64f_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp64f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp64f;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp64f;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp64f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;

  ippiMulC64f_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;
  ippiMulC64f_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;var value:Ipp64f;roiSize:IppiSize;hint:IppHintAlgorithm;rndMode:IppRoundMode):IppStatus;

(*   #ifdef __cplusplus
}
#endif  *)

(*   #if defined (_IPP_STDCALL_CDECL)
  #undef  _IPP_STDCALL_CDECL
  #define __stdcall __cdecl
#endif  *)

//#endif /* __IPPI_H__ */  *)

function InitIPPI17:boolean;
procedure IPPItest;
procedure IPPIend;


IMPLEMENTATION

var
  hh: Thandle;


function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,PansiChar(st));
  if result=nil then messageCentral(st+'=nil');
               {else messageCentral(st+' OK');}
end;


procedure InitIppi1;
begin
  ippiGetLibVersion:=getProc(hh,'ippiGetLibVersion');
  ippiMalloc_8u_C1:=getProc(hh,'ippiMalloc_8u_C1');
  ippiMalloc_16u_C1:=getProc(hh,'ippiMalloc_16u_C1');
  ippiMalloc_16s_C1:=getProc(hh,'ippiMalloc_16s_C1');
  ippiMalloc_32s_C1:=getProc(hh,'ippiMalloc_32s_C1');
  ippiMalloc_32f_C1:=getProc(hh,'ippiMalloc_32f_C1');
  ippiMalloc_32sc_C1:=getProc(hh,'ippiMalloc_32sc_C1');
  ippiMalloc_32fc_C1:=getProc(hh,'ippiMalloc_32fc_C1');
  ippiMalloc_8u_C2:=getProc(hh,'ippiMalloc_8u_C2');
  ippiMalloc_16u_C2:=getProc(hh,'ippiMalloc_16u_C2');
  ippiMalloc_16s_C2:=getProc(hh,'ippiMalloc_16s_C2');
  ippiMalloc_32s_C2:=getProc(hh,'ippiMalloc_32s_C2');
  ippiMalloc_32f_C2:=getProc(hh,'ippiMalloc_32f_C2');
  ippiMalloc_32sc_C2:=getProc(hh,'ippiMalloc_32sc_C2');
  ippiMalloc_32fc_C2:=getProc(hh,'ippiMalloc_32fc_C2');
  ippiMalloc_8u_C3:=getProc(hh,'ippiMalloc_8u_C3');
  ippiMalloc_16u_C3:=getProc(hh,'ippiMalloc_16u_C3');
  ippiMalloc_16s_C3:=getProc(hh,'ippiMalloc_16s_C3');
  ippiMalloc_32s_C3:=getProc(hh,'ippiMalloc_32s_C3');
  ippiMalloc_32f_C3:=getProc(hh,'ippiMalloc_32f_C3');
  ippiMalloc_32sc_C3:=getProc(hh,'ippiMalloc_32sc_C3');
  ippiMalloc_32fc_C3:=getProc(hh,'ippiMalloc_32fc_C3');
  ippiMalloc_8u_C4:=getProc(hh,'ippiMalloc_8u_C4');
  ippiMalloc_16u_C4:=getProc(hh,'ippiMalloc_16u_C4');
  ippiMalloc_16s_C4:=getProc(hh,'ippiMalloc_16s_C4');
  ippiMalloc_32s_C4:=getProc(hh,'ippiMalloc_32s_C4');
  ippiMalloc_32f_C4:=getProc(hh,'ippiMalloc_32f_C4');
  ippiMalloc_32sc_C4:=getProc(hh,'ippiMalloc_32sc_C4');
  ippiMalloc_32fc_C4:=getProc(hh,'ippiMalloc_32fc_C4');
  ippiMalloc_8u_AC4:=getProc(hh,'ippiMalloc_8u_AC4');
  ippiMalloc_16u_AC4:=getProc(hh,'ippiMalloc_16u_AC4');
  ippiMalloc_16s_AC4:=getProc(hh,'ippiMalloc_16s_AC4');
  ippiMalloc_32s_AC4:=getProc(hh,'ippiMalloc_32s_AC4');
  ippiMalloc_32f_AC4:=getProc(hh,'ippiMalloc_32f_AC4');
  ippiMalloc_32sc_AC4:=getProc(hh,'ippiMalloc_32sc_AC4');
  ippiMalloc_32fc_AC4:=getProc(hh,'ippiMalloc_32fc_AC4');
  ippiFree:=getProc(hh,'ippiFree');
  ippiAdd_8u_C1RSfs:=getProc(hh,'ippiAdd_8u_C1RSfs');
  ippiAdd_8u_C3RSfs:=getProc(hh,'ippiAdd_8u_C3RSfs');
  ippiAdd_8u_C4RSfs:=getProc(hh,'ippiAdd_8u_C4RSfs');
  ippiAdd_8u_AC4RSfs:=getProc(hh,'ippiAdd_8u_AC4RSfs');
  ippiAdd_16s_C1RSfs:=getProc(hh,'ippiAdd_16s_C1RSfs');
  ippiAdd_16s_C3RSfs:=getProc(hh,'ippiAdd_16s_C3RSfs');
  ippiAdd_16s_C4RSfs:=getProc(hh,'ippiAdd_16s_C4RSfs');
  ippiAdd_16s_AC4RSfs:=getProc(hh,'ippiAdd_16s_AC4RSfs');
  ippiAdd_16u_C1RSfs:=getProc(hh,'ippiAdd_16u_C1RSfs');
  ippiAdd_16u_C3RSfs:=getProc(hh,'ippiAdd_16u_C3RSfs');
  ippiAdd_16u_C4RSfs:=getProc(hh,'ippiAdd_16u_C4RSfs');
  ippiAdd_16u_AC4RSfs:=getProc(hh,'ippiAdd_16u_AC4RSfs');
  ippiSub_8u_C1RSfs:=getProc(hh,'ippiSub_8u_C1RSfs');
  ippiSub_8u_C3RSfs:=getProc(hh,'ippiSub_8u_C3RSfs');
  ippiSub_8u_C4RSfs:=getProc(hh,'ippiSub_8u_C4RSfs');
  ippiSub_8u_AC4RSfs:=getProc(hh,'ippiSub_8u_AC4RSfs');
  ippiSub_16s_C1RSfs:=getProc(hh,'ippiSub_16s_C1RSfs');
  ippiSub_16s_C3RSfs:=getProc(hh,'ippiSub_16s_C3RSfs');
  ippiSub_16s_C4RSfs:=getProc(hh,'ippiSub_16s_C4RSfs');
  ippiSub_16s_AC4RSfs:=getProc(hh,'ippiSub_16s_AC4RSfs');
  ippiSub_16u_C1RSfs:=getProc(hh,'ippiSub_16u_C1RSfs');
  ippiSub_16u_C3RSfs:=getProc(hh,'ippiSub_16u_C3RSfs');
  ippiSub_16u_C4RSfs:=getProc(hh,'ippiSub_16u_C4RSfs');
  ippiSub_16u_AC4RSfs:=getProc(hh,'ippiSub_16u_AC4RSfs');
  ippiMul_8u_C1RSfs:=getProc(hh,'ippiMul_8u_C1RSfs');
  ippiMul_8u_C3RSfs:=getProc(hh,'ippiMul_8u_C3RSfs');
  ippiMul_8u_C4RSfs:=getProc(hh,'ippiMul_8u_C4RSfs');
  ippiMul_8u_AC4RSfs:=getProc(hh,'ippiMul_8u_AC4RSfs');
  ippiMul_16s_C1RSfs:=getProc(hh,'ippiMul_16s_C1RSfs');
  ippiMul_16s_C3RSfs:=getProc(hh,'ippiMul_16s_C3RSfs');
  ippiMul_16s_C4RSfs:=getProc(hh,'ippiMul_16s_C4RSfs');
  ippiMul_16s_AC4RSfs:=getProc(hh,'ippiMul_16s_AC4RSfs');
  ippiMul_16u_C1RSfs:=getProc(hh,'ippiMul_16u_C1RSfs');
  ippiMul_16u_C3RSfs:=getProc(hh,'ippiMul_16u_C3RSfs');
  ippiMul_16u_C4RSfs:=getProc(hh,'ippiMul_16u_C4RSfs');
  ippiMul_16u_AC4RSfs:=getProc(hh,'ippiMul_16u_AC4RSfs');
  ippiAddC_8u_C1IRSfs:=getProc(hh,'ippiAddC_8u_C1IRSfs');
  ippiAddC_8u_C3IRSfs:=getProc(hh,'ippiAddC_8u_C3IRSfs');
  ippiAddC_8u_C4IRSfs:=getProc(hh,'ippiAddC_8u_C4IRSfs');
  ippiAddC_8u_AC4IRSfs:=getProc(hh,'ippiAddC_8u_AC4IRSfs');
  ippiAddC_16s_C1IRSfs:=getProc(hh,'ippiAddC_16s_C1IRSfs');
  ippiAddC_16s_C3IRSfs:=getProc(hh,'ippiAddC_16s_C3IRSfs');
  ippiAddC_16s_C4IRSfs:=getProc(hh,'ippiAddC_16s_C4IRSfs');
  ippiAddC_16s_AC4IRSfs:=getProc(hh,'ippiAddC_16s_AC4IRSfs');
  ippiAddC_16u_C1IRSfs:=getProc(hh,'ippiAddC_16u_C1IRSfs');
  ippiAddC_16u_C3IRSfs:=getProc(hh,'ippiAddC_16u_C3IRSfs');
  ippiAddC_16u_C4IRSfs:=getProc(hh,'ippiAddC_16u_C4IRSfs');
  ippiAddC_16u_AC4IRSfs:=getProc(hh,'ippiAddC_16u_AC4IRSfs');
  ippiSubC_8u_C1IRSfs:=getProc(hh,'ippiSubC_8u_C1IRSfs');
  ippiSubC_8u_C3IRSfs:=getProc(hh,'ippiSubC_8u_C3IRSfs');
  ippiSubC_8u_C4IRSfs:=getProc(hh,'ippiSubC_8u_C4IRSfs');
  ippiSubC_8u_AC4IRSfs:=getProc(hh,'ippiSubC_8u_AC4IRSfs');
  ippiSubC_16s_C1IRSfs:=getProc(hh,'ippiSubC_16s_C1IRSfs');
  ippiSubC_16s_C3IRSfs:=getProc(hh,'ippiSubC_16s_C3IRSfs');
  ippiSubC_16s_C4IRSfs:=getProc(hh,'ippiSubC_16s_C4IRSfs');
  ippiSubC_16s_AC4IRSfs:=getProc(hh,'ippiSubC_16s_AC4IRSfs');
  ippiSubC_16u_C1IRSfs:=getProc(hh,'ippiSubC_16u_C1IRSfs');
  ippiSubC_16u_C3IRSfs:=getProc(hh,'ippiSubC_16u_C3IRSfs');
  ippiSubC_16u_C4IRSfs:=getProc(hh,'ippiSubC_16u_C4IRSfs');
  ippiSubC_16u_AC4IRSfs:=getProc(hh,'ippiSubC_16u_AC4IRSfs');
  ippiMulC_8u_C1IRSfs:=getProc(hh,'ippiMulC_8u_C1IRSfs');
  ippiMulC_8u_C3IRSfs:=getProc(hh,'ippiMulC_8u_C3IRSfs');
  ippiMulC_8u_C4IRSfs:=getProc(hh,'ippiMulC_8u_C4IRSfs');
  ippiMulC_8u_AC4IRSfs:=getProc(hh,'ippiMulC_8u_AC4IRSfs');
  ippiMulC_16s_C1IRSfs:=getProc(hh,'ippiMulC_16s_C1IRSfs');
  ippiMulC_16s_C3IRSfs:=getProc(hh,'ippiMulC_16s_C3IRSfs');
  ippiMulC_16s_C4IRSfs:=getProc(hh,'ippiMulC_16s_C4IRSfs');
  ippiMulC_16s_AC4IRSfs:=getProc(hh,'ippiMulC_16s_AC4IRSfs');
  ippiMulC_16u_C1IRSfs:=getProc(hh,'ippiMulC_16u_C1IRSfs');
  ippiMulC_16u_C3IRSfs:=getProc(hh,'ippiMulC_16u_C3IRSfs');
  ippiMulC_16u_C4IRSfs:=getProc(hh,'ippiMulC_16u_C4IRSfs');
  ippiMulC_16u_AC4IRSfs:=getProc(hh,'ippiMulC_16u_AC4IRSfs');
  ippiAddC_8u_C1RSfs:=getProc(hh,'ippiAddC_8u_C1RSfs');
  ippiAddC_8u_C3RSfs:=getProc(hh,'ippiAddC_8u_C3RSfs');
  ippiAddC_8u_C4RSfs:=getProc(hh,'ippiAddC_8u_C4RSfs');
  ippiAddC_8u_AC4RSfs:=getProc(hh,'ippiAddC_8u_AC4RSfs');
  ippiAddC_16s_C1RSfs:=getProc(hh,'ippiAddC_16s_C1RSfs');
  ippiAddC_16s_C3RSfs:=getProc(hh,'ippiAddC_16s_C3RSfs');
  ippiAddC_16s_C4RSfs:=getProc(hh,'ippiAddC_16s_C4RSfs');
  ippiAddC_16s_AC4RSfs:=getProc(hh,'ippiAddC_16s_AC4RSfs');
  ippiAddC_16u_C1RSfs:=getProc(hh,'ippiAddC_16u_C1RSfs');
  ippiAddC_16u_C3RSfs:=getProc(hh,'ippiAddC_16u_C3RSfs');
  ippiAddC_16u_C4RSfs:=getProc(hh,'ippiAddC_16u_C4RSfs');
  ippiAddC_16u_AC4RSfs:=getProc(hh,'ippiAddC_16u_AC4RSfs');
  ippiSubC_8u_C1RSfs:=getProc(hh,'ippiSubC_8u_C1RSfs');
  ippiSubC_8u_C3RSfs:=getProc(hh,'ippiSubC_8u_C3RSfs');
  ippiSubC_8u_C4RSfs:=getProc(hh,'ippiSubC_8u_C4RSfs');
  ippiSubC_8u_AC4RSfs:=getProc(hh,'ippiSubC_8u_AC4RSfs');
  ippiSubC_16s_C1RSfs:=getProc(hh,'ippiSubC_16s_C1RSfs');
  ippiSubC_16s_C3RSfs:=getProc(hh,'ippiSubC_16s_C3RSfs');
  ippiSubC_16s_C4RSfs:=getProc(hh,'ippiSubC_16s_C4RSfs');
  ippiSubC_16s_AC4RSfs:=getProc(hh,'ippiSubC_16s_AC4RSfs');
  ippiSubC_16u_C1RSfs:=getProc(hh,'ippiSubC_16u_C1RSfs');
  ippiSubC_16u_C3RSfs:=getProc(hh,'ippiSubC_16u_C3RSfs');
  ippiSubC_16u_C4RSfs:=getProc(hh,'ippiSubC_16u_C4RSfs');
  ippiSubC_16u_AC4RSfs:=getProc(hh,'ippiSubC_16u_AC4RSfs');
  ippiMulC_8u_C1RSfs:=getProc(hh,'ippiMulC_8u_C1RSfs');
  ippiMulC_8u_C3RSfs:=getProc(hh,'ippiMulC_8u_C3RSfs');
  ippiMulC_8u_C4RSfs:=getProc(hh,'ippiMulC_8u_C4RSfs');
  ippiMulC_8u_AC4RSfs:=getProc(hh,'ippiMulC_8u_AC4RSfs');
  ippiMulC_16s_C1RSfs:=getProc(hh,'ippiMulC_16s_C1RSfs');
  ippiMulC_16s_C3RSfs:=getProc(hh,'ippiMulC_16s_C3RSfs');
  ippiMulC_16s_C4RSfs:=getProc(hh,'ippiMulC_16s_C4RSfs');
  ippiMulC_16s_AC4RSfs:=getProc(hh,'ippiMulC_16s_AC4RSfs');
  ippiMulC_16u_C1RSfs:=getProc(hh,'ippiMulC_16u_C1RSfs');
  ippiMulC_16u_C3RSfs:=getProc(hh,'ippiMulC_16u_C3RSfs');
  ippiMulC_16u_C4RSfs:=getProc(hh,'ippiMulC_16u_C4RSfs');
  ippiMulC_16u_AC4RSfs:=getProc(hh,'ippiMulC_16u_AC4RSfs');
  ippiAdd_8u_C1IRSfs:=getProc(hh,'ippiAdd_8u_C1IRSfs');
  ippiAdd_8u_C3IRSfs:=getProc(hh,'ippiAdd_8u_C3IRSfs');
  ippiAdd_8u_C4IRSfs:=getProc(hh,'ippiAdd_8u_C4IRSfs');
  ippiAdd_8u_AC4IRSfs:=getProc(hh,'ippiAdd_8u_AC4IRSfs');
  ippiAdd_16s_C1IRSfs:=getProc(hh,'ippiAdd_16s_C1IRSfs');
  ippiAdd_16s_C3IRSfs:=getProc(hh,'ippiAdd_16s_C3IRSfs');
  ippiAdd_16s_C4IRSfs:=getProc(hh,'ippiAdd_16s_C4IRSfs');
  ippiAdd_16s_AC4IRSfs:=getProc(hh,'ippiAdd_16s_AC4IRSfs');
  ippiAdd_16u_C1IRSfs:=getProc(hh,'ippiAdd_16u_C1IRSfs');
  ippiAdd_16u_C3IRSfs:=getProc(hh,'ippiAdd_16u_C3IRSfs');
  ippiAdd_16u_C4IRSfs:=getProc(hh,'ippiAdd_16u_C4IRSfs');
  ippiAdd_16u_AC4IRSfs:=getProc(hh,'ippiAdd_16u_AC4IRSfs');
  ippiSub_8u_C1IRSfs:=getProc(hh,'ippiSub_8u_C1IRSfs');
  ippiSub_8u_C3IRSfs:=getProc(hh,'ippiSub_8u_C3IRSfs');
  ippiSub_8u_C4IRSfs:=getProc(hh,'ippiSub_8u_C4IRSfs');
  ippiSub_8u_AC4IRSfs:=getProc(hh,'ippiSub_8u_AC4IRSfs');
  ippiSub_16s_C1IRSfs:=getProc(hh,'ippiSub_16s_C1IRSfs');
  ippiSub_16s_C3IRSfs:=getProc(hh,'ippiSub_16s_C3IRSfs');
  ippiSub_16s_C4IRSfs:=getProc(hh,'ippiSub_16s_C4IRSfs');
  ippiSub_16s_AC4IRSfs:=getProc(hh,'ippiSub_16s_AC4IRSfs');
  ippiSub_16u_C1IRSfs:=getProc(hh,'ippiSub_16u_C1IRSfs');
  ippiSub_16u_C3IRSfs:=getProc(hh,'ippiSub_16u_C3IRSfs');
  ippiSub_16u_C4IRSfs:=getProc(hh,'ippiSub_16u_C4IRSfs');
  ippiSub_16u_AC4IRSfs:=getProc(hh,'ippiSub_16u_AC4IRSfs');
  ippiMul_8u_C1IRSfs:=getProc(hh,'ippiMul_8u_C1IRSfs');
  ippiMul_8u_C3IRSfs:=getProc(hh,'ippiMul_8u_C3IRSfs');
  ippiMul_8u_C4IRSfs:=getProc(hh,'ippiMul_8u_C4IRSfs');
  ippiMul_8u_AC4IRSfs:=getProc(hh,'ippiMul_8u_AC4IRSfs');
  ippiMul_16s_C1IRSfs:=getProc(hh,'ippiMul_16s_C1IRSfs');
  ippiMul_16s_C3IRSfs:=getProc(hh,'ippiMul_16s_C3IRSfs');
  ippiMul_16s_C4IRSfs:=getProc(hh,'ippiMul_16s_C4IRSfs');
  ippiMul_16s_AC4IRSfs:=getProc(hh,'ippiMul_16s_AC4IRSfs');
  ippiMul_16u_C1IRSfs:=getProc(hh,'ippiMul_16u_C1IRSfs');
  ippiMul_16u_C3IRSfs:=getProc(hh,'ippiMul_16u_C3IRSfs');
  ippiMul_16u_C4IRSfs:=getProc(hh,'ippiMul_16u_C4IRSfs');
  ippiMul_16u_AC4IRSfs:=getProc(hh,'ippiMul_16u_AC4IRSfs');
  ippiAddC_32f_C1R:=getProc(hh,'ippiAddC_32f_C1R');
  ippiAddC_32f_C3R:=getProc(hh,'ippiAddC_32f_C3R');
  ippiAddC_32f_C4R:=getProc(hh,'ippiAddC_32f_C4R');
  ippiAddC_32f_AC4R:=getProc(hh,'ippiAddC_32f_AC4R');
  ippiSubC_32f_C1R:=getProc(hh,'ippiSubC_32f_C1R');
  ippiSubC_32f_C3R:=getProc(hh,'ippiSubC_32f_C3R');
  ippiSubC_32f_C4R:=getProc(hh,'ippiSubC_32f_C4R');
  ippiSubC_32f_AC4R:=getProc(hh,'ippiSubC_32f_AC4R');
  ippiMulC_32f_C1R:=getProc(hh,'ippiMulC_32f_C1R');
  ippiMulC_32f_C3R:=getProc(hh,'ippiMulC_32f_C3R');
  ippiMulC_32f_C4R:=getProc(hh,'ippiMulC_32f_C4R');
  ippiMulC_32f_AC4R:=getProc(hh,'ippiMulC_32f_AC4R');
  ippiAddC_32f_C1IR:=getProc(hh,'ippiAddC_32f_C1IR');
  ippiAddC_32f_C3IR:=getProc(hh,'ippiAddC_32f_C3IR');
  ippiAddC_32f_C4IR:=getProc(hh,'ippiAddC_32f_C4IR');
  ippiAddC_32f_AC4IR:=getProc(hh,'ippiAddC_32f_AC4IR');
  ippiSubC_32f_C1IR:=getProc(hh,'ippiSubC_32f_C1IR');
  ippiSubC_32f_C3IR:=getProc(hh,'ippiSubC_32f_C3IR');
  ippiSubC_32f_C4IR:=getProc(hh,'ippiSubC_32f_C4IR');
  ippiSubC_32f_AC4IR:=getProc(hh,'ippiSubC_32f_AC4IR');
  ippiMulC_32f_C1IR:=getProc(hh,'ippiMulC_32f_C1IR');
  ippiMulC_32f_C3IR:=getProc(hh,'ippiMulC_32f_C3IR');
  ippiMulC_32f_C4IR:=getProc(hh,'ippiMulC_32f_C4IR');
  ippiMulC_32f_AC4IR:=getProc(hh,'ippiMulC_32f_AC4IR');
  ippiAdd_32f_C1IR:=getProc(hh,'ippiAdd_32f_C1IR');
  ippiAdd_32f_C3IR:=getProc(hh,'ippiAdd_32f_C3IR');
  ippiAdd_32f_C4IR:=getProc(hh,'ippiAdd_32f_C4IR');
  ippiAdd_32f_AC4IR:=getProc(hh,'ippiAdd_32f_AC4IR');
  ippiSub_32f_C1IR:=getProc(hh,'ippiSub_32f_C1IR');
  ippiSub_32f_C3IR:=getProc(hh,'ippiSub_32f_C3IR');
  ippiSub_32f_C4IR:=getProc(hh,'ippiSub_32f_C4IR');
  ippiSub_32f_AC4IR:=getProc(hh,'ippiSub_32f_AC4IR');
  ippiMul_32f_C1IR:=getProc(hh,'ippiMul_32f_C1IR');
  ippiMul_32f_C3IR:=getProc(hh,'ippiMul_32f_C3IR');
  ippiMul_32f_C4IR:=getProc(hh,'ippiMul_32f_C4IR');
  ippiMul_32f_AC4IR:=getProc(hh,'ippiMul_32f_AC4IR');
  ippiAdd_32f_C1R:=getProc(hh,'ippiAdd_32f_C1R');
  ippiAdd_32f_C3R:=getProc(hh,'ippiAdd_32f_C3R');
  ippiAdd_32f_C4R:=getProc(hh,'ippiAdd_32f_C4R');
  ippiAdd_32f_AC4R:=getProc(hh,'ippiAdd_32f_AC4R');
  ippiSub_32f_C1R:=getProc(hh,'ippiSub_32f_C1R');
  ippiSub_32f_C3R:=getProc(hh,'ippiSub_32f_C3R');
  ippiSub_32f_C4R:=getProc(hh,'ippiSub_32f_C4R');
  ippiSub_32f_AC4R:=getProc(hh,'ippiSub_32f_AC4R');
  ippiMul_32f_C1R:=getProc(hh,'ippiMul_32f_C1R');
  ippiMul_32f_C3R:=getProc(hh,'ippiMul_32f_C3R');
  ippiMul_32f_C4R:=getProc(hh,'ippiMul_32f_C4R');
  ippiMul_32f_AC4R:=getProc(hh,'ippiMul_32f_AC4R');
  ippiDiv_32f_C1R:=getProc(hh,'ippiDiv_32f_C1R');
  ippiDiv_32f_C3R:=getProc(hh,'ippiDiv_32f_C3R');
  ippiDiv_32f_C4R:=getProc(hh,'ippiDiv_32f_C4R');
  ippiDiv_32f_AC4R:=getProc(hh,'ippiDiv_32f_AC4R');
  ippiDiv_16s_C1RSfs:=getProc(hh,'ippiDiv_16s_C1RSfs');
  ippiDiv_16s_C3RSfs:=getProc(hh,'ippiDiv_16s_C3RSfs');
  ippiDiv_16s_C4RSfs:=getProc(hh,'ippiDiv_16s_C4RSfs');
  ippiDiv_16s_AC4RSfs:=getProc(hh,'ippiDiv_16s_AC4RSfs');
  ippiDiv_8u_C1RSfs:=getProc(hh,'ippiDiv_8u_C1RSfs');
  ippiDiv_8u_C3RSfs:=getProc(hh,'ippiDiv_8u_C3RSfs');
  ippiDiv_8u_C4RSfs:=getProc(hh,'ippiDiv_8u_C4RSfs');
  ippiDiv_8u_AC4RSfs:=getProc(hh,'ippiDiv_8u_AC4RSfs');
  ippiDiv_16u_C1RSfs:=getProc(hh,'ippiDiv_16u_C1RSfs');
  ippiDiv_16u_C3RSfs:=getProc(hh,'ippiDiv_16u_C3RSfs');
  ippiDiv_16u_C4RSfs:=getProc(hh,'ippiDiv_16u_C4RSfs');
  ippiDiv_16u_AC4RSfs:=getProc(hh,'ippiDiv_16u_AC4RSfs');
  ippiDivC_32f_C1R:=getProc(hh,'ippiDivC_32f_C1R');
  ippiDivC_32f_C3R:=getProc(hh,'ippiDivC_32f_C3R');
  ippiDivC_32f_C4R:=getProc(hh,'ippiDivC_32f_C4R');
  ippiDivC_32f_AC4R:=getProc(hh,'ippiDivC_32f_AC4R');
  ippiDivC_16s_C1RSfs:=getProc(hh,'ippiDivC_16s_C1RSfs');
  ippiDivC_16s_C3RSfs:=getProc(hh,'ippiDivC_16s_C3RSfs');
  ippiDivC_16s_C4RSfs:=getProc(hh,'ippiDivC_16s_C4RSfs');
  ippiDivC_16s_AC4RSfs:=getProc(hh,'ippiDivC_16s_AC4RSfs');
  ippiDivC_8u_C1RSfs:=getProc(hh,'ippiDivC_8u_C1RSfs');
  ippiDivC_8u_C3RSfs:=getProc(hh,'ippiDivC_8u_C3RSfs');
  ippiDivC_8u_C4RSfs:=getProc(hh,'ippiDivC_8u_C4RSfs');
  ippiDivC_8u_AC4RSfs:=getProc(hh,'ippiDivC_8u_AC4RSfs');
  ippiDivC_16u_C1RSfs:=getProc(hh,'ippiDivC_16u_C1RSfs');
  ippiDivC_16u_C3RSfs:=getProc(hh,'ippiDivC_16u_C3RSfs');
  ippiDivC_16u_C4RSfs:=getProc(hh,'ippiDivC_16u_C4RSfs');
  ippiDivC_16u_AC4RSfs:=getProc(hh,'ippiDivC_16u_AC4RSfs');
  ippiDiv_32f_C1IR:=getProc(hh,'ippiDiv_32f_C1IR');
  ippiDiv_32f_C3IR:=getProc(hh,'ippiDiv_32f_C3IR');
  ippiDiv_32f_C4IR:=getProc(hh,'ippiDiv_32f_C4IR');
  ippiDiv_32f_AC4IR:=getProc(hh,'ippiDiv_32f_AC4IR');
  ippiDiv_16s_C1IRSfs:=getProc(hh,'ippiDiv_16s_C1IRSfs');
  ippiDiv_16s_C3IRSfs:=getProc(hh,'ippiDiv_16s_C3IRSfs');
  ippiDiv_16s_C4IRSfs:=getProc(hh,'ippiDiv_16s_C4IRSfs');
  ippiDiv_16s_AC4IRSfs:=getProc(hh,'ippiDiv_16s_AC4IRSfs');
  ippiDiv_8u_C1IRSfs:=getProc(hh,'ippiDiv_8u_C1IRSfs');
  ippiDiv_8u_C3IRSfs:=getProc(hh,'ippiDiv_8u_C3IRSfs');
  ippiDiv_8u_C4IRSfs:=getProc(hh,'ippiDiv_8u_C4IRSfs');
  ippiDiv_8u_AC4IRSfs:=getProc(hh,'ippiDiv_8u_AC4IRSfs');
  ippiDiv_16u_C1IRSfs:=getProc(hh,'ippiDiv_16u_C1IRSfs');
  ippiDiv_16u_C3IRSfs:=getProc(hh,'ippiDiv_16u_C3IRSfs');
  ippiDiv_16u_C4IRSfs:=getProc(hh,'ippiDiv_16u_C4IRSfs');
  ippiDiv_16u_AC4IRSfs:=getProc(hh,'ippiDiv_16u_AC4IRSfs');
  ippiDivC_32f_C1IR:=getProc(hh,'ippiDivC_32f_C1IR');
  ippiDivC_32f_C3IR:=getProc(hh,'ippiDivC_32f_C3IR');
  ippiDivC_32f_C4IR:=getProc(hh,'ippiDivC_32f_C4IR');
  ippiDivC_32f_AC4IR:=getProc(hh,'ippiDivC_32f_AC4IR');
  ippiDivC_16s_C1IRSfs:=getProc(hh,'ippiDivC_16s_C1IRSfs');
  ippiDivC_16s_C3IRSfs:=getProc(hh,'ippiDivC_16s_C3IRSfs');
  ippiDivC_16s_C4IRSfs:=getProc(hh,'ippiDivC_16s_C4IRSfs');
  ippiDivC_16s_AC4IRSfs:=getProc(hh,'ippiDivC_16s_AC4IRSfs');
  ippiDivC_8u_C1IRSfs:=getProc(hh,'ippiDivC_8u_C1IRSfs');
  ippiDivC_8u_C3IRSfs:=getProc(hh,'ippiDivC_8u_C3IRSfs');
  ippiDivC_8u_C4IRSfs:=getProc(hh,'ippiDivC_8u_C4IRSfs');
  ippiDivC_8u_AC4IRSfs:=getProc(hh,'ippiDivC_8u_AC4IRSfs');
  ippiDivC_16u_C1IRSfs:=getProc(hh,'ippiDivC_16u_C1IRSfs');
  ippiDivC_16u_C3IRSfs:=getProc(hh,'ippiDivC_16u_C3IRSfs');
  ippiDivC_16u_C4IRSfs:=getProc(hh,'ippiDivC_16u_C4IRSfs');
  ippiDivC_16u_AC4IRSfs:=getProc(hh,'ippiDivC_16u_AC4IRSfs');
  ippiAbs_16s_C1R:=getProc(hh,'ippiAbs_16s_C1R');
  ippiAbs_16s_C3R:=getProc(hh,'ippiAbs_16s_C3R');
  ippiAbs_16s_AC4R:=getProc(hh,'ippiAbs_16s_AC4R');
  ippiAbs_32f_C1R:=getProc(hh,'ippiAbs_32f_C1R');
  ippiAbs_32f_C3R:=getProc(hh,'ippiAbs_32f_C3R');
  ippiAbs_32f_AC4R:=getProc(hh,'ippiAbs_32f_AC4R');
  ippiAbs_16s_C1IR:=getProc(hh,'ippiAbs_16s_C1IR');
  ippiAbs_16s_C3IR:=getProc(hh,'ippiAbs_16s_C3IR');
  ippiAbs_16s_AC4IR:=getProc(hh,'ippiAbs_16s_AC4IR');
  ippiAbs_32f_C1IR:=getProc(hh,'ippiAbs_32f_C1IR');
  ippiAbs_32f_C3IR:=getProc(hh,'ippiAbs_32f_C3IR');
  ippiAbs_32f_AC4IR:=getProc(hh,'ippiAbs_32f_AC4IR');
  ippiAbs_16s_C4R:=getProc(hh,'ippiAbs_16s_C4R');
  ippiAbs_32f_C4R:=getProc(hh,'ippiAbs_32f_C4R');
  ippiAbs_16s_C4IR:=getProc(hh,'ippiAbs_16s_C4IR');
  ippiAbs_32f_C4IR:=getProc(hh,'ippiAbs_32f_C4IR');
  ippiSqr_8u_C1RSfs:=getProc(hh,'ippiSqr_8u_C1RSfs');
  ippiSqr_8u_C3RSfs:=getProc(hh,'ippiSqr_8u_C3RSfs');
  ippiSqr_8u_AC4RSfs:=getProc(hh,'ippiSqr_8u_AC4RSfs');
  ippiSqr_8u_C4RSfs:=getProc(hh,'ippiSqr_8u_C4RSfs');
  ippiSqr_16u_C1RSfs:=getProc(hh,'ippiSqr_16u_C1RSfs');
  ippiSqr_16u_C3RSfs:=getProc(hh,'ippiSqr_16u_C3RSfs');
  ippiSqr_16u_AC4RSfs:=getProc(hh,'ippiSqr_16u_AC4RSfs');
  ippiSqr_16u_C4RSfs:=getProc(hh,'ippiSqr_16u_C4RSfs');
  ippiSqr_16s_C1RSfs:=getProc(hh,'ippiSqr_16s_C1RSfs');
  ippiSqr_16s_C3RSfs:=getProc(hh,'ippiSqr_16s_C3RSfs');
  ippiSqr_16s_AC4RSfs:=getProc(hh,'ippiSqr_16s_AC4RSfs');
  ippiSqr_16s_C4RSfs:=getProc(hh,'ippiSqr_16s_C4RSfs');
  ippiSqr_32f_C1R:=getProc(hh,'ippiSqr_32f_C1R');
  ippiSqr_32f_C3R:=getProc(hh,'ippiSqr_32f_C3R');
  ippiSqr_32f_AC4R:=getProc(hh,'ippiSqr_32f_AC4R');
  ippiSqr_32f_C4R:=getProc(hh,'ippiSqr_32f_C4R');
  ippiSqr_8u_C1IRSfs:=getProc(hh,'ippiSqr_8u_C1IRSfs');
  ippiSqr_8u_C3IRSfs:=getProc(hh,'ippiSqr_8u_C3IRSfs');
  ippiSqr_8u_AC4IRSfs:=getProc(hh,'ippiSqr_8u_AC4IRSfs');
  ippiSqr_8u_C4IRSfs:=getProc(hh,'ippiSqr_8u_C4IRSfs');
  ippiSqr_16u_C1IRSfs:=getProc(hh,'ippiSqr_16u_C1IRSfs');
  ippiSqr_16u_C3IRSfs:=getProc(hh,'ippiSqr_16u_C3IRSfs');
  ippiSqr_16u_AC4IRSfs:=getProc(hh,'ippiSqr_16u_AC4IRSfs');
  ippiSqr_16u_C4IRSfs:=getProc(hh,'ippiSqr_16u_C4IRSfs');
  ippiSqr_16s_C1IRSfs:=getProc(hh,'ippiSqr_16s_C1IRSfs');
  ippiSqr_16s_C3IRSfs:=getProc(hh,'ippiSqr_16s_C3IRSfs');
  ippiSqr_16s_AC4IRSfs:=getProc(hh,'ippiSqr_16s_AC4IRSfs');
  ippiSqr_16s_C4IRSfs:=getProc(hh,'ippiSqr_16s_C4IRSfs');
  ippiSqr_32f_C1IR:=getProc(hh,'ippiSqr_32f_C1IR');
  ippiSqr_32f_C3IR:=getProc(hh,'ippiSqr_32f_C3IR');
  ippiSqr_32f_AC4IR:=getProc(hh,'ippiSqr_32f_AC4IR');
  ippiSqr_32f_C4IR:=getProc(hh,'ippiSqr_32f_C4IR');
  ippiSqrt_8u_C1RSfs:=getProc(hh,'ippiSqrt_8u_C1RSfs');
  ippiSqrt_8u_C3RSfs:=getProc(hh,'ippiSqrt_8u_C3RSfs');
  ippiSqrt_8u_AC4RSfs:=getProc(hh,'ippiSqrt_8u_AC4RSfs');
  ippiSqrt_16u_C1RSfs:=getProc(hh,'ippiSqrt_16u_C1RSfs');
  ippiSqrt_16u_C3RSfs:=getProc(hh,'ippiSqrt_16u_C3RSfs');
  ippiSqrt_16u_AC4RSfs:=getProc(hh,'ippiSqrt_16u_AC4RSfs');
  ippiSqrt_16s_C1RSfs:=getProc(hh,'ippiSqrt_16s_C1RSfs');
  ippiSqrt_16s_C3RSfs:=getProc(hh,'ippiSqrt_16s_C3RSfs');
  ippiSqrt_16s_AC4RSfs:=getProc(hh,'ippiSqrt_16s_AC4RSfs');
  ippiSqrt_32f_C1R:=getProc(hh,'ippiSqrt_32f_C1R');
  ippiSqrt_32f_C3R:=getProc(hh,'ippiSqrt_32f_C3R');
  ippiSqrt_32f_AC4R:=getProc(hh,'ippiSqrt_32f_AC4R');
  ippiSqrt_8u_C1IRSfs:=getProc(hh,'ippiSqrt_8u_C1IRSfs');
  ippiSqrt_8u_C3IRSfs:=getProc(hh,'ippiSqrt_8u_C3IRSfs');
  ippiSqrt_8u_AC4IRSfs:=getProc(hh,'ippiSqrt_8u_AC4IRSfs');
  ippiSqrt_16u_C1IRSfs:=getProc(hh,'ippiSqrt_16u_C1IRSfs');
  ippiSqrt_16u_C3IRSfs:=getProc(hh,'ippiSqrt_16u_C3IRSfs');
  ippiSqrt_16u_AC4IRSfs:=getProc(hh,'ippiSqrt_16u_AC4IRSfs');
  ippiSqrt_16s_C1IRSfs:=getProc(hh,'ippiSqrt_16s_C1IRSfs');
  ippiSqrt_16s_C3IRSfs:=getProc(hh,'ippiSqrt_16s_C3IRSfs');
  ippiSqrt_16s_AC4IRSfs:=getProc(hh,'ippiSqrt_16s_AC4IRSfs');
  ippiSqrt_32f_C1IR:=getProc(hh,'ippiSqrt_32f_C1IR');
  ippiSqrt_32f_C3IR:=getProc(hh,'ippiSqrt_32f_C3IR');
  ippiSqrt_32f_AC4IR:=getProc(hh,'ippiSqrt_32f_AC4IR');
  ippiSqrt_32f_C4IR:=getProc(hh,'ippiSqrt_32f_C4IR');
  ippiLn_32f_C1IR:=getProc(hh,'ippiLn_32f_C1IR');
  ippiLn_32f_C3IR:=getProc(hh,'ippiLn_32f_C3IR');
  ippiLn_32f_C1R:=getProc(hh,'ippiLn_32f_C1R');
  ippiLn_32f_C3R:=getProc(hh,'ippiLn_32f_C3R');
  ippiLn_16s_C1IRSfs:=getProc(hh,'ippiLn_16s_C1IRSfs');
  ippiLn_16s_C3IRSfs:=getProc(hh,'ippiLn_16s_C3IRSfs');
  ippiLn_16s_C1RSfs:=getProc(hh,'ippiLn_16s_C1RSfs');
  ippiLn_16s_C3RSfs:=getProc(hh,'ippiLn_16s_C3RSfs');
  ippiLn_16u_C1RSfs:=getProc(hh,'ippiLn_16u_C1RSfs');
  ippiLn_16u_C3RSfs:=getProc(hh,'ippiLn_16u_C3RSfs');
  ippiLn_8u_C1IRSfs:=getProc(hh,'ippiLn_8u_C1IRSfs');
  ippiLn_8u_C3IRSfs:=getProc(hh,'ippiLn_8u_C3IRSfs');
  ippiLn_8u_C1RSfs:=getProc(hh,'ippiLn_8u_C1RSfs');
  ippiLn_8u_C3RSfs:=getProc(hh,'ippiLn_8u_C3RSfs');
  ippiLn_16u_C1IRSfs:=getProc(hh,'ippiLn_16u_C1IRSfs');
  ippiLn_16u_C3IRSfs:=getProc(hh,'ippiLn_16u_C3IRSfs');
  ippiExp_32f_C1IR:=getProc(hh,'ippiExp_32f_C1IR');
  ippiExp_32f_C3IR:=getProc(hh,'ippiExp_32f_C3IR');
  ippiExp_32f_C1R:=getProc(hh,'ippiExp_32f_C1R');
  ippiExp_32f_C3R:=getProc(hh,'ippiExp_32f_C3R');
  ippiExp_16s_C1IRSfs:=getProc(hh,'ippiExp_16s_C1IRSfs');
  ippiExp_16s_C3IRSfs:=getProc(hh,'ippiExp_16s_C3IRSfs');
  ippiExp_16s_C1RSfs:=getProc(hh,'ippiExp_16s_C1RSfs');
  ippiExp_16s_C3RSfs:=getProc(hh,'ippiExp_16s_C3RSfs');
  ippiExp_16u_C1IRSfs:=getProc(hh,'ippiExp_16u_C1IRSfs');
  ippiExp_16u_C3IRSfs:=getProc(hh,'ippiExp_16u_C3IRSfs');
  ippiExp_8u_C1IRSfs:=getProc(hh,'ippiExp_8u_C1IRSfs');
  ippiExp_8u_C3IRSfs:=getProc(hh,'ippiExp_8u_C3IRSfs');
  ippiExp_8u_C1RSfs:=getProc(hh,'ippiExp_8u_C1RSfs');
  ippiExp_8u_C3RSfs:=getProc(hh,'ippiExp_8u_C3RSfs');
  ippiExp_16u_C1RSfs:=getProc(hh,'ippiExp_16u_C1RSfs');
  ippiExp_16u_C3RSfs:=getProc(hh,'ippiExp_16u_C3RSfs');
  ippiMulScale_8u_C1R:=getProc(hh,'ippiMulScale_8u_C1R');
  ippiMulScale_8u_C3R:=getProc(hh,'ippiMulScale_8u_C3R');
  ippiMulScale_8u_C4R:=getProc(hh,'ippiMulScale_8u_C4R');
  ippiMulScale_8u_AC4R:=getProc(hh,'ippiMulScale_8u_AC4R');
  ippiMulScale_8u_C1IR:=getProc(hh,'ippiMulScale_8u_C1IR');
  ippiMulScale_8u_C3IR:=getProc(hh,'ippiMulScale_8u_C3IR');
  ippiMulScale_8u_C4IR:=getProc(hh,'ippiMulScale_8u_C4IR');
  ippiMulScale_8u_AC4IR:=getProc(hh,'ippiMulScale_8u_AC4IR');
  ippiMulCScale_8u_C1R:=getProc(hh,'ippiMulCScale_8u_C1R');
  ippiMulCScale_8u_C3R:=getProc(hh,'ippiMulCScale_8u_C3R');
  ippiMulCScale_8u_C4R:=getProc(hh,'ippiMulCScale_8u_C4R');
  ippiMulCScale_8u_AC4R:=getProc(hh,'ippiMulCScale_8u_AC4R');
  ippiMulCScale_8u_C1IR:=getProc(hh,'ippiMulCScale_8u_C1IR');
  ippiMulCScale_8u_C3IR:=getProc(hh,'ippiMulCScale_8u_C3IR');
  ippiMulCScale_8u_C4IR:=getProc(hh,'ippiMulCScale_8u_C4IR');
  ippiMulCScale_8u_AC4IR:=getProc(hh,'ippiMulCScale_8u_AC4IR');
  ippiMulScale_16u_C1R:=getProc(hh,'ippiMulScale_16u_C1R');
  ippiMulScale_16u_C3R:=getProc(hh,'ippiMulScale_16u_C3R');
  ippiMulScale_16u_C4R:=getProc(hh,'ippiMulScale_16u_C4R');
  ippiMulScale_16u_AC4R:=getProc(hh,'ippiMulScale_16u_AC4R');
  ippiMulScale_16u_C1IR:=getProc(hh,'ippiMulScale_16u_C1IR');
  ippiMulScale_16u_C3IR:=getProc(hh,'ippiMulScale_16u_C3IR');
  ippiMulScale_16u_C4IR:=getProc(hh,'ippiMulScale_16u_C4IR');
  ippiMulScale_16u_AC4IR:=getProc(hh,'ippiMulScale_16u_AC4IR');
  ippiMulCScale_16u_C1R:=getProc(hh,'ippiMulCScale_16u_C1R');
  ippiMulCScale_16u_C3R:=getProc(hh,'ippiMulCScale_16u_C3R');
  ippiMulCScale_16u_C4R:=getProc(hh,'ippiMulCScale_16u_C4R');
  ippiMulCScale_16u_AC4R:=getProc(hh,'ippiMulCScale_16u_AC4R');
  ippiMulCScale_16u_C1IR:=getProc(hh,'ippiMulCScale_16u_C1IR');
  ippiMulCScale_16u_C3IR:=getProc(hh,'ippiMulCScale_16u_C3IR');
  ippiMulCScale_16u_C4IR:=getProc(hh,'ippiMulCScale_16u_C4IR');
  ippiMulCScale_16u_AC4IR:=getProc(hh,'ippiMulCScale_16u_AC4IR');
  ippiDotProd_8u64f_C1R:=getProc(hh,'ippiDotProd_8u64f_C1R');
  ippiDotProd_16u64f_C1R:=getProc(hh,'ippiDotProd_16u64f_C1R');
  ippiDotProd_16s64f_C1R:=getProc(hh,'ippiDotProd_16s64f_C1R');
  ippiDotProd_32u64f_C1R:=getProc(hh,'ippiDotProd_32u64f_C1R');
  ippiDotProd_32s64f_C1R:=getProc(hh,'ippiDotProd_32s64f_C1R');
  ippiDotProd_32f64f_C1R:=getProc(hh,'ippiDotProd_32f64f_C1R');
  ippiDotProd_8u64f_C3R:=getProc(hh,'ippiDotProd_8u64f_C3R');
  ippiDotProd_16u64f_C3R:=getProc(hh,'ippiDotProd_16u64f_C3R');
  ippiDotProd_16s64f_C3R:=getProc(hh,'ippiDotProd_16s64f_C3R');
  ippiDotProd_32u64f_C3R:=getProc(hh,'ippiDotProd_32u64f_C3R');
  ippiDotProd_32s64f_C3R:=getProc(hh,'ippiDotProd_32s64f_C3R');
  ippiDotProd_32f64f_C3R:=getProc(hh,'ippiDotProd_32f64f_C3R');
  ippiDotProd_8u64f_C4R:=getProc(hh,'ippiDotProd_8u64f_C4R');
  ippiDotProd_16u64f_C4R:=getProc(hh,'ippiDotProd_16u64f_C4R');
  ippiDotProd_16s64f_C4R:=getProc(hh,'ippiDotProd_16s64f_C4R');
  ippiDotProd_32u64f_C4R:=getProc(hh,'ippiDotProd_32u64f_C4R');
  ippiDotProd_32s64f_C4R:=getProc(hh,'ippiDotProd_32s64f_C4R');
  ippiDotProd_32f64f_C4R:=getProc(hh,'ippiDotProd_32f64f_C4R');
  ippiDotProd_8u64f_AC4R:=getProc(hh,'ippiDotProd_8u64f_AC4R');
  ippiDotProd_16u64f_AC4R:=getProc(hh,'ippiDotProd_16u64f_AC4R');
  ippiDotProd_16s64f_AC4R:=getProc(hh,'ippiDotProd_16s64f_AC4R');
  ippiDotProd_32u64f_AC4R:=getProc(hh,'ippiDotProd_32u64f_AC4R');
  ippiDotProd_32s64f_AC4R:=getProc(hh,'ippiDotProd_32s64f_AC4R');
  ippiDotProd_32f64f_AC4R:=getProc(hh,'ippiDotProd_32f64f_AC4R');
  ippiDotProdCol_32f_L2:=getProc(hh,'ippiDotProdCol_32f_L2');
  ippiDotProdCol_64f_L2:=getProc(hh,'ippiDotProdCol_64f_L2');
  ippiMulPack_32f_C1IR:=getProc(hh,'ippiMulPack_32f_C1IR');
  ippiMulPack_32f_C3IR:=getProc(hh,'ippiMulPack_32f_C3IR');
  ippiMulPack_32f_C4IR:=getProc(hh,'ippiMulPack_32f_C4IR');
  ippiMulPack_32f_AC4IR:=getProc(hh,'ippiMulPack_32f_AC4IR');
  ippiMulPack_32f_C1R:=getProc(hh,'ippiMulPack_32f_C1R');
  ippiMulPack_32f_C3R:=getProc(hh,'ippiMulPack_32f_C3R');
  ippiMulPack_32f_C4R:=getProc(hh,'ippiMulPack_32f_C4R');
  ippiMulPack_32f_AC4R:=getProc(hh,'ippiMulPack_32f_AC4R');
  ippiMulPackConj_32f_C1IR:=getProc(hh,'ippiMulPackConj_32f_C1IR');
  ippiMulPackConj_32f_C3IR:=getProc(hh,'ippiMulPackConj_32f_C3IR');
  ippiMulPackConj_32f_C4IR:=getProc(hh,'ippiMulPackConj_32f_C4IR');
  ippiMulPackConj_32f_AC4IR:=getProc(hh,'ippiMulPackConj_32f_AC4IR');
  ippiMulPackConj_32f_C1R:=getProc(hh,'ippiMulPackConj_32f_C1R');
  ippiMulPackConj_32f_C3R:=getProc(hh,'ippiMulPackConj_32f_C3R');
  ippiMulPackConj_32f_C4R:=getProc(hh,'ippiMulPackConj_32f_C4R');
  ippiMulPackConj_32f_AC4R:=getProc(hh,'ippiMulPackConj_32f_AC4R');
  ippiPackToCplxExtend_32f32fc_C1R:=getProc(hh,'ippiPackToCplxExtend_32f32fc_C1R');
  ippiCplxExtendToPack_32fc32f_C1R:=getProc(hh,'ippiCplxExtendToPack_32fc32f_C1R');
  ippiCplxExtendToPack_32fc32f_C3R:=getProc(hh,'ippiCplxExtendToPack_32fc32f_C3R');
  ippiPhasePack_32f_C1R:=getProc(hh,'ippiPhasePack_32f_C1R');
  ippiPhasePack_32f_C3R:=getProc(hh,'ippiPhasePack_32f_C3R');
  ippiPhasePackGetBufferSize_32f:=getProc(hh,'ippiPhasePackGetBufferSize_32f');
  ippiMagnitudePack_32f_C1R:=getProc(hh,'ippiMagnitudePack_32f_C1R');
  ippiMagnitudePack_32f_C3R:=getProc(hh,'ippiMagnitudePack_32f_C3R');
  ippiMagnitudePackGetBufferSize_32f:=getProc(hh,'ippiMagnitudePackGetBufferSize_32f');
  ippiMagnitude_32fc32f_C1R:=getProc(hh,'ippiMagnitude_32fc32f_C1R');
  ippiMagnitude_32fc32f_C3R:=getProc(hh,'ippiMagnitude_32fc32f_C3R');
  ippiPhase_32fc32f_C1R:=getProc(hh,'ippiPhase_32fc32f_C1R');
  ippiPhase_32fc32f_C3R:=getProc(hh,'ippiPhase_32fc32f_C3R');
  ippiAlphaPremul_8u_AC4R:=getProc(hh,'ippiAlphaPremul_8u_AC4R');
  ippiAlphaPremul_16u_AC4R:=getProc(hh,'ippiAlphaPremul_16u_AC4R');
  ippiAlphaPremul_8u_AC4IR:=getProc(hh,'ippiAlphaPremul_8u_AC4IR');
  ippiAlphaPremul_16u_AC4IR:=getProc(hh,'ippiAlphaPremul_16u_AC4IR');
  ippiAlphaPremul_8u_AP4R:=getProc(hh,'ippiAlphaPremul_8u_AP4R');
  ippiAlphaPremul_16u_AP4R:=getProc(hh,'ippiAlphaPremul_16u_AP4R');
  ippiAlphaPremul_8u_AP4IR:=getProc(hh,'ippiAlphaPremul_8u_AP4IR');
  ippiAlphaPremul_16u_AP4IR:=getProc(hh,'ippiAlphaPremul_16u_AP4IR');
  ippiAlphaPremulC_8u_AC4R:=getProc(hh,'ippiAlphaPremulC_8u_AC4R');
  ippiAlphaPremulC_16u_AC4R:=getProc(hh,'ippiAlphaPremulC_16u_AC4R');
  ippiAlphaPremulC_8u_AC4IR:=getProc(hh,'ippiAlphaPremulC_8u_AC4IR');
  ippiAlphaPremulC_16u_AC4IR:=getProc(hh,'ippiAlphaPremulC_16u_AC4IR');
  ippiAlphaPremulC_8u_AP4R:=getProc(hh,'ippiAlphaPremulC_8u_AP4R');
  ippiAlphaPremulC_16u_AP4R:=getProc(hh,'ippiAlphaPremulC_16u_AP4R');
  ippiAlphaPremulC_8u_AP4IR:=getProc(hh,'ippiAlphaPremulC_8u_AP4IR');
  ippiAlphaPremulC_16u_AP4IR:=getProc(hh,'ippiAlphaPremulC_16u_AP4IR');
  ippiAlphaPremulC_8u_C4R:=getProc(hh,'ippiAlphaPremulC_8u_C4R');
  ippiAlphaPremulC_16u_C4R:=getProc(hh,'ippiAlphaPremulC_16u_C4R');
  ippiAlphaPremulC_8u_C4IR:=getProc(hh,'ippiAlphaPremulC_8u_C4IR');
  ippiAlphaPremulC_16u_C4IR:=getProc(hh,'ippiAlphaPremulC_16u_C4IR');
  ippiAlphaPremulC_8u_C3R:=getProc(hh,'ippiAlphaPremulC_8u_C3R');
  ippiAlphaPremulC_16u_C3R:=getProc(hh,'ippiAlphaPremulC_16u_C3R');
  ippiAlphaPremulC_8u_C3IR:=getProc(hh,'ippiAlphaPremulC_8u_C3IR');
  ippiAlphaPremulC_16u_C3IR:=getProc(hh,'ippiAlphaPremulC_16u_C3IR');
  ippiAlphaPremulC_8u_C1R:=getProc(hh,'ippiAlphaPremulC_8u_C1R');
  ippiAlphaPremulC_16u_C1R:=getProc(hh,'ippiAlphaPremulC_16u_C1R');
  ippiAlphaPremulC_8u_C1IR:=getProc(hh,'ippiAlphaPremulC_8u_C1IR');
  ippiAlphaPremulC_16u_C1IR:=getProc(hh,'ippiAlphaPremulC_16u_C1IR');
  ippiAlphaComp_8u_AC4R:=getProc(hh,'ippiAlphaComp_8u_AC4R');
  ippiAlphaComp_16u_AC4R:=getProc(hh,'ippiAlphaComp_16u_AC4R');
  ippiAlphaComp_16s_AC4R:=getProc(hh,'ippiAlphaComp_16s_AC4R');
  ippiAlphaComp_32s_AC4R:=getProc(hh,'ippiAlphaComp_32s_AC4R');
  ippiAlphaComp_32u_AC4R:=getProc(hh,'ippiAlphaComp_32u_AC4R');
  ippiAlphaComp_32f_AC4R:=getProc(hh,'ippiAlphaComp_32f_AC4R');
  ippiAlphaComp_8u_AP4R:=getProc(hh,'ippiAlphaComp_8u_AP4R');
  ippiAlphaComp_16u_AP4R:=getProc(hh,'ippiAlphaComp_16u_AP4R');
  ippiAlphaComp_8u_AC1R:=getProc(hh,'ippiAlphaComp_8u_AC1R');
  ippiAlphaComp_16u_AC1R:=getProc(hh,'ippiAlphaComp_16u_AC1R');
  ippiAlphaComp_16s_AC1R:=getProc(hh,'ippiAlphaComp_16s_AC1R');
  ippiAlphaComp_32s_AC1R:=getProc(hh,'ippiAlphaComp_32s_AC1R');
  ippiAlphaComp_32u_AC1R:=getProc(hh,'ippiAlphaComp_32u_AC1R');
  ippiAlphaComp_32f_AC1R:=getProc(hh,'ippiAlphaComp_32f_AC1R');
  ippiAlphaCompC_8u_AC4R:=getProc(hh,'ippiAlphaCompC_8u_AC4R');
  ippiAlphaCompC_16u_AC4R:=getProc(hh,'ippiAlphaCompC_16u_AC4R');
  ippiAlphaCompC_8u_AP4R:=getProc(hh,'ippiAlphaCompC_8u_AP4R');
  ippiAlphaCompC_16u_AP4R:=getProc(hh,'ippiAlphaCompC_16u_AP4R');
  ippiAlphaCompC_8u_C4R:=getProc(hh,'ippiAlphaCompC_8u_C4R');
  ippiAlphaCompC_16u_C4R:=getProc(hh,'ippiAlphaCompC_16u_C4R');
  ippiAlphaCompC_8u_C3R:=getProc(hh,'ippiAlphaCompC_8u_C3R');
  ippiAlphaCompC_16u_C3R:=getProc(hh,'ippiAlphaCompC_16u_C3R');
  ippiAlphaCompC_8u_C1R:=getProc(hh,'ippiAlphaCompC_8u_C1R');
  ippiAlphaCompC_16u_C1R:=getProc(hh,'ippiAlphaCompC_16u_C1R');
  ippiAlphaCompC_16s_C1R:=getProc(hh,'ippiAlphaCompC_16s_C1R');
  ippiAlphaCompC_32s_C1R:=getProc(hh,'ippiAlphaCompC_32s_C1R');
  ippiAlphaCompC_32u_C1R:=getProc(hh,'ippiAlphaCompC_32u_C1R');
  ippiAlphaCompC_32f_C1R:=getProc(hh,'ippiAlphaCompC_32f_C1R');
  ippiAlphaComp_8u_AC4IR:=getProc(hh,'ippiAlphaComp_8u_AC4IR');
  ippiAlphaComp_16u_AC4IR:=getProc(hh,'ippiAlphaComp_16u_AC4IR');
  ippiAlphaComp_16s_AC4IR:=getProc(hh,'ippiAlphaComp_16s_AC4IR');
  ippiAlphaComp_32s_AC4IR:=getProc(hh,'ippiAlphaComp_32s_AC4IR');
  ippiAlphaComp_32u_AC4IR:=getProc(hh,'ippiAlphaComp_32u_AC4IR');
  ippiAlphaComp_32f_AC4IR:=getProc(hh,'ippiAlphaComp_32f_AC4IR');
  ippiAlphaComp_8u_AP4IR:=getProc(hh,'ippiAlphaComp_8u_AP4IR');
  ippiAlphaComp_16u_AP4IR:=getProc(hh,'ippiAlphaComp_16u_AP4IR');
  ippiAlphaCompC_8u_AC4IR:=getProc(hh,'ippiAlphaCompC_8u_AC4IR');
  ippiAlphaCompC_16u_AC4IR:=getProc(hh,'ippiAlphaCompC_16u_AC4IR');
  ippiAlphaCompC_8u_AP4IR:=getProc(hh,'ippiAlphaCompC_8u_AP4IR');
  ippiAlphaCompC_16u_AP4IR:=getProc(hh,'ippiAlphaCompC_16u_AP4IR');
  ippiAlphaCompC_8u_C4IR:=getProc(hh,'ippiAlphaCompC_8u_C4IR');
  ippiAlphaCompC_16u_C4IR:=getProc(hh,'ippiAlphaCompC_16u_C4IR');
  ippiAlphaCompC_8u_C3IR:=getProc(hh,'ippiAlphaCompC_8u_C3IR');
  ippiAlphaCompC_16u_C3IR:=getProc(hh,'ippiAlphaCompC_16u_C3IR');
  ippiAlphaCompC_8u_C1IR:=getProc(hh,'ippiAlphaCompC_8u_C1IR');
  ippiAlphaCompC_16u_C1IR:=getProc(hh,'ippiAlphaCompC_16u_C1IR');
  ippiAlphaCompC_16s_C1IR:=getProc(hh,'ippiAlphaCompC_16s_C1IR');
  ippiAlphaCompC_32s_C1IR:=getProc(hh,'ippiAlphaCompC_32s_C1IR');
  ippiAlphaCompC_32u_C1IR:=getProc(hh,'ippiAlphaCompC_32u_C1IR');
  ippiAlphaCompC_32f_C1IR:=getProc(hh,'ippiAlphaCompC_32f_C1IR');
  ippiFFTInit_C_32fc:=getProc(hh,'ippiFFTInit_C_32fc');
  ippiFFTInit_R_32f:=getProc(hh,'ippiFFTInit_R_32f');
  ippiFFTGetSize_C_32fc:=getProc(hh,'ippiFFTGetSize_C_32fc');
  ippiFFTGetSize_R_32f:=getProc(hh,'ippiFFTGetSize_R_32f');
  ippiFFTFwd_CToC_32fc_C1R:=getProc(hh,'ippiFFTFwd_CToC_32fc_C1R');
  ippiFFTInv_CToC_32fc_C1R:=getProc(hh,'ippiFFTInv_CToC_32fc_C1R');
  ippiFFTFwd_RToPack_32f_C1R:=getProc(hh,'ippiFFTFwd_RToPack_32f_C1R');
  ippiFFTFwd_RToPack_32f_C3R:=getProc(hh,'ippiFFTFwd_RToPack_32f_C3R');
  ippiFFTFwd_RToPack_32f_C4R:=getProc(hh,'ippiFFTFwd_RToPack_32f_C4R');
  ippiFFTFwd_RToPack_32f_AC4R:=getProc(hh,'ippiFFTFwd_RToPack_32f_AC4R');
  ippiFFTInv_PackToR_32f_C1R:=getProc(hh,'ippiFFTInv_PackToR_32f_C1R');
  ippiFFTInv_PackToR_32f_C3R:=getProc(hh,'ippiFFTInv_PackToR_32f_C3R');
  ippiFFTInv_PackToR_32f_C4R:=getProc(hh,'ippiFFTInv_PackToR_32f_C4R');
  ippiFFTInv_PackToR_32f_AC4R:=getProc(hh,'ippiFFTInv_PackToR_32f_AC4R');
  ippiFFTFwd_CToC_32fc_C1IR:=getProc(hh,'ippiFFTFwd_CToC_32fc_C1IR');
  ippiFFTInv_CToC_32fc_C1IR:=getProc(hh,'ippiFFTInv_CToC_32fc_C1IR');
  ippiFFTFwd_RToPack_32f_C1IR:=getProc(hh,'ippiFFTFwd_RToPack_32f_C1IR');
  ippiFFTFwd_RToPack_32f_C3IR:=getProc(hh,'ippiFFTFwd_RToPack_32f_C3IR');
  ippiFFTFwd_RToPack_32f_C4IR:=getProc(hh,'ippiFFTFwd_RToPack_32f_C4IR');
  ippiFFTFwd_RToPack_32f_AC4IR:=getProc(hh,'ippiFFTFwd_RToPack_32f_AC4IR');
  ippiFFTInv_PackToR_32f_C1IR:=getProc(hh,'ippiFFTInv_PackToR_32f_C1IR');
  ippiFFTInv_PackToR_32f_C3IR:=getProc(hh,'ippiFFTInv_PackToR_32f_C3IR');
  ippiFFTInv_PackToR_32f_C4IR:=getProc(hh,'ippiFFTInv_PackToR_32f_C4IR');
  ippiFFTInv_PackToR_32f_AC4IR:=getProc(hh,'ippiFFTInv_PackToR_32f_AC4IR');
  ippiDFTInit_C_32fc:=getProc(hh,'ippiDFTInit_C_32fc');
  ippiDFTInit_R_32f:=getProc(hh,'ippiDFTInit_R_32f');
  ippiDFTGetSize_C_32fc:=getProc(hh,'ippiDFTGetSize_C_32fc');
  ippiDFTGetSize_R_32f:=getProc(hh,'ippiDFTGetSize_R_32f');
  ippiDFTFwd_CToC_32fc_C1R:=getProc(hh,'ippiDFTFwd_CToC_32fc_C1R');
  ippiDFTInv_CToC_32fc_C1R:=getProc(hh,'ippiDFTInv_CToC_32fc_C1R');
  ippiDFTFwd_RToPack_32f_C1R:=getProc(hh,'ippiDFTFwd_RToPack_32f_C1R');
  ippiDFTFwd_RToPack_32f_C3R:=getProc(hh,'ippiDFTFwd_RToPack_32f_C3R');
  ippiDFTFwd_RToPack_32f_C4R:=getProc(hh,'ippiDFTFwd_RToPack_32f_C4R');
  ippiDFTFwd_RToPack_32f_AC4R:=getProc(hh,'ippiDFTFwd_RToPack_32f_AC4R');
  ippiDFTInv_PackToR_32f_C1R:=getProc(hh,'ippiDFTInv_PackToR_32f_C1R');
  ippiDFTInv_PackToR_32f_C3R:=getProc(hh,'ippiDFTInv_PackToR_32f_C3R');
  ippiDFTInv_PackToR_32f_C4R:=getProc(hh,'ippiDFTInv_PackToR_32f_C4R');
  ippiDFTInv_PackToR_32f_AC4R:=getProc(hh,'ippiDFTInv_PackToR_32f_AC4R');
  ippiDFTFwd_CToC_32fc_C1IR:=getProc(hh,'ippiDFTFwd_CToC_32fc_C1IR');
  ippiDFTInv_CToC_32fc_C1IR:=getProc(hh,'ippiDFTInv_CToC_32fc_C1IR');
  ippiDFTFwd_RToPack_32f_C1IR:=getProc(hh,'ippiDFTFwd_RToPack_32f_C1IR');
  ippiDFTFwd_RToPack_32f_C3IR:=getProc(hh,'ippiDFTFwd_RToPack_32f_C3IR');
  ippiDFTFwd_RToPack_32f_C4IR:=getProc(hh,'ippiDFTFwd_RToPack_32f_C4IR');
  ippiDFTFwd_RToPack_32f_AC4IR:=getProc(hh,'ippiDFTFwd_RToPack_32f_AC4IR');
  ippiDFTInv_PackToR_32f_C1IR:=getProc(hh,'ippiDFTInv_PackToR_32f_C1IR');
  ippiDFTInv_PackToR_32f_C3IR:=getProc(hh,'ippiDFTInv_PackToR_32f_C3IR');
  ippiDFTInv_PackToR_32f_C4IR:=getProc(hh,'ippiDFTInv_PackToR_32f_C4IR');
  ippiDFTInv_PackToR_32f_AC4IR:=getProc(hh,'ippiDFTInv_PackToR_32f_AC4IR');
  ippiDCTFwdInit_32f:=getProc(hh,'ippiDCTFwdInit_32f');
  ippiDCTInvInit_32f:=getProc(hh,'ippiDCTInvInit_32f');
  ippiDCTFwdGetSize_32f:=getProc(hh,'ippiDCTFwdGetSize_32f');
  ippiDCTInvGetSize_32f:=getProc(hh,'ippiDCTInvGetSize_32f');
  ippiDCTFwd_32f_C1R:=getProc(hh,'ippiDCTFwd_32f_C1R');
  ippiDCTFwd_32f_C3R:=getProc(hh,'ippiDCTFwd_32f_C3R');
  ippiDCTFwd_32f_C4R:=getProc(hh,'ippiDCTFwd_32f_C4R');
  ippiDCTFwd_32f_AC4R:=getProc(hh,'ippiDCTFwd_32f_AC4R');
  ippiDCTInv_32f_C1R:=getProc(hh,'ippiDCTInv_32f_C1R');
  ippiDCTInv_32f_C3R:=getProc(hh,'ippiDCTInv_32f_C3R');
  ippiDCTInv_32f_C4R:=getProc(hh,'ippiDCTInv_32f_C4R');
  ippiDCTInv_32f_AC4R:=getProc(hh,'ippiDCTInv_32f_AC4R');
  ippiDCT8x8Fwd_16s_C1:=getProc(hh,'ippiDCT8x8Fwd_16s_C1');
  ippiDCT8x8Inv_16s_C1:=getProc(hh,'ippiDCT8x8Inv_16s_C1');
  ippiDCT8x8Fwd_16s_C1I:=getProc(hh,'ippiDCT8x8Fwd_16s_C1I');
  ippiDCT8x8Inv_16s_C1I:=getProc(hh,'ippiDCT8x8Inv_16s_C1I');
  ippiDCT8x8Fwd_16s_C1R:=getProc(hh,'ippiDCT8x8Fwd_16s_C1R');
  ippiDCT8x8Inv_16s_C1R:=getProc(hh,'ippiDCT8x8Inv_16s_C1R');
  ippiDCT8x8Inv_2x2_16s_C1:=getProc(hh,'ippiDCT8x8Inv_2x2_16s_C1');
  ippiDCT8x8Inv_4x4_16s_C1:=getProc(hh,'ippiDCT8x8Inv_4x4_16s_C1');
  ippiDCT8x8Inv_2x2_16s_C1I:=getProc(hh,'ippiDCT8x8Inv_2x2_16s_C1I');
  ippiDCT8x8Inv_4x4_16s_C1I:=getProc(hh,'ippiDCT8x8Inv_4x4_16s_C1I');
  ippiDCT8x8To2x2Inv_16s_C1:=getProc(hh,'ippiDCT8x8To2x2Inv_16s_C1');
  ippiDCT8x8To4x4Inv_16s_C1:=getProc(hh,'ippiDCT8x8To4x4Inv_16s_C1');
  ippiDCT8x8To2x2Inv_16s_C1I:=getProc(hh,'ippiDCT8x8To2x2Inv_16s_C1I');
  ippiDCT8x8To4x4Inv_16s_C1I:=getProc(hh,'ippiDCT8x8To4x4Inv_16s_C1I');
  ippiDCT8x8Inv_A10_16s_C1:=getProc(hh,'ippiDCT8x8Inv_A10_16s_C1');
  ippiDCT8x8Inv_A10_16s_C1I:=getProc(hh,'ippiDCT8x8Inv_A10_16s_C1I');
  ippiDCT8x8Fwd_8u16s_C1R:=getProc(hh,'ippiDCT8x8Fwd_8u16s_C1R');
  ippiDCT8x8Inv_16s8u_C1R:=getProc(hh,'ippiDCT8x8Inv_16s8u_C1R');
  ippiDCT8x8FwdLS_8u16s_C1R:=getProc(hh,'ippiDCT8x8FwdLS_8u16s_C1R');
  ippiDCT8x8InvLSClip_16s8u_C1R:=getProc(hh,'ippiDCT8x8InvLSClip_16s8u_C1R');
  ippiDCT8x8Fwd_32f_C1:=getProc(hh,'ippiDCT8x8Fwd_32f_C1');
  ippiDCT8x8Inv_32f_C1:=getProc(hh,'ippiDCT8x8Inv_32f_C1');
  ippiDCT8x8Fwd_32f_C1I:=getProc(hh,'ippiDCT8x8Fwd_32f_C1I');
  ippiDCT8x8Inv_32f_C1I:=getProc(hh,'ippiDCT8x8Inv_32f_C1I');
  ippiWTFwdGetSize_32f:=getProc(hh,'ippiWTFwdGetSize_32f');
  ippiWTFwdInit_32f_C1R:=getProc(hh,'ippiWTFwdInit_32f_C1R');
  ippiWTFwdInit_32f_C3R:=getProc(hh,'ippiWTFwdInit_32f_C3R');
  ippiWTFwd_32f_C1R:=getProc(hh,'ippiWTFwd_32f_C1R');
  ippiWTFwd_32f_C3R:=getProc(hh,'ippiWTFwd_32f_C3R');
  ippiWTInvGetSize_32f:=getProc(hh,'ippiWTInvGetSize_32f');
  ippiWTInvInit_32f_C1R:=getProc(hh,'ippiWTInvInit_32f_C1R');
  ippiWTInvInit_32f_C3R:=getProc(hh,'ippiWTInvInit_32f_C3R');
  ippiWTInv_32f_C1R:=getProc(hh,'ippiWTInv_32f_C1R');
  ippiWTInv_32f_C3R:=getProc(hh,'ippiWTInv_32f_C3R');
  ippiDecimateFilterRow_8u_C1R:=getProc(hh,'ippiDecimateFilterRow_8u_C1R');
  ippiDecimateFilterColumn_8u_C1R:=getProc(hh,'ippiDecimateFilterColumn_8u_C1R');
  ippiMirror_8u_C1R:=getProc(hh,'ippiMirror_8u_C1R');
  ippiMirror_8u_C3R:=getProc(hh,'ippiMirror_8u_C3R');
  ippiMirror_8u_AC4R:=getProc(hh,'ippiMirror_8u_AC4R');
  ippiMirror_8u_C4R:=getProc(hh,'ippiMirror_8u_C4R');
  ippiMirror_8u_C1IR:=getProc(hh,'ippiMirror_8u_C1IR');
  ippiMirror_8u_C3IR:=getProc(hh,'ippiMirror_8u_C3IR');
  ippiMirror_8u_AC4IR:=getProc(hh,'ippiMirror_8u_AC4IR');
  ippiMirror_8u_C4IR:=getProc(hh,'ippiMirror_8u_C4IR');
  ippiMirror_16u_C1R:=getProc(hh,'ippiMirror_16u_C1R');
  ippiMirror_16u_C3R:=getProc(hh,'ippiMirror_16u_C3R');
  ippiMirror_16u_AC4R:=getProc(hh,'ippiMirror_16u_AC4R');
  ippiMirror_16u_C4R:=getProc(hh,'ippiMirror_16u_C4R');
  ippiMirror_16u_C1IR:=getProc(hh,'ippiMirror_16u_C1IR');
  ippiMirror_16u_C3IR:=getProc(hh,'ippiMirror_16u_C3IR');
  ippiMirror_16u_AC4IR:=getProc(hh,'ippiMirror_16u_AC4IR');
  ippiMirror_16u_C4IR:=getProc(hh,'ippiMirror_16u_C4IR');
  ippiMirror_32s_C1R:=getProc(hh,'ippiMirror_32s_C1R');
  ippiMirror_32s_C3R:=getProc(hh,'ippiMirror_32s_C3R');
  ippiMirror_32s_AC4R:=getProc(hh,'ippiMirror_32s_AC4R');
  ippiMirror_32s_C4R:=getProc(hh,'ippiMirror_32s_C4R');
  ippiMirror_32s_C1IR:=getProc(hh,'ippiMirror_32s_C1IR');
  ippiMirror_32s_C3IR:=getProc(hh,'ippiMirror_32s_C3IR');
  ippiMirror_32s_AC4IR:=getProc(hh,'ippiMirror_32s_AC4IR');
  ippiMirror_32s_C4IR:=getProc(hh,'ippiMirror_32s_C4IR');
  ippiMirror_16s_C1R:=getProc(hh,'ippiMirror_16s_C1R');
  ippiMirror_16s_C3R:=getProc(hh,'ippiMirror_16s_C3R');
  ippiMirror_16s_AC4R:=getProc(hh,'ippiMirror_16s_AC4R');
  ippiMirror_16s_C4R:=getProc(hh,'ippiMirror_16s_C4R');
  ippiMirror_16s_C1IR:=getProc(hh,'ippiMirror_16s_C1IR');
  ippiMirror_16s_C3IR:=getProc(hh,'ippiMirror_16s_C3IR');
  ippiMirror_16s_AC4IR:=getProc(hh,'ippiMirror_16s_AC4IR');
  ippiMirror_16s_C4IR:=getProc(hh,'ippiMirror_16s_C4IR');
  ippiMirror_32f_C1R:=getProc(hh,'ippiMirror_32f_C1R');
  ippiMirror_32f_C3R:=getProc(hh,'ippiMirror_32f_C3R');
  ippiMirror_32f_AC4R:=getProc(hh,'ippiMirror_32f_AC4R');
  ippiMirror_32f_C4R:=getProc(hh,'ippiMirror_32f_C4R');
  ippiMirror_32f_C1IR:=getProc(hh,'ippiMirror_32f_C1IR');
  ippiMirror_32f_C3IR:=getProc(hh,'ippiMirror_32f_C3IR');
  ippiMirror_32f_AC4IR:=getProc(hh,'ippiMirror_32f_AC4IR');
  ippiMirror_32f_C4IR:=getProc(hh,'ippiMirror_32f_C4IR');
  ippiRemap_8u_C1R:=getProc(hh,'ippiRemap_8u_C1R');
  ippiRemap_8u_C3R:=getProc(hh,'ippiRemap_8u_C3R');
  ippiRemap_8u_C4R:=getProc(hh,'ippiRemap_8u_C4R');
  ippiRemap_8u_AC4R:=getProc(hh,'ippiRemap_8u_AC4R');
  ippiRemap_16u_C1R:=getProc(hh,'ippiRemap_16u_C1R');
  ippiRemap_16u_C3R:=getProc(hh,'ippiRemap_16u_C3R');
  ippiRemap_16u_C4R:=getProc(hh,'ippiRemap_16u_C4R');
  ippiRemap_16u_AC4R:=getProc(hh,'ippiRemap_16u_AC4R');
  ippiRemap_16s_C1R:=getProc(hh,'ippiRemap_16s_C1R');
  ippiRemap_16s_C3R:=getProc(hh,'ippiRemap_16s_C3R');
  ippiRemap_16s_C4R:=getProc(hh,'ippiRemap_16s_C4R');
  ippiRemap_16s_AC4R:=getProc(hh,'ippiRemap_16s_AC4R');
  ippiRemap_32f_C1R:=getProc(hh,'ippiRemap_32f_C1R');
  ippiRemap_32f_C3R:=getProc(hh,'ippiRemap_32f_C3R');
  ippiRemap_32f_C4R:=getProc(hh,'ippiRemap_32f_C4R');
  ippiRemap_32f_AC4R:=getProc(hh,'ippiRemap_32f_AC4R');
  ippiRemap_64f_C1R:=getProc(hh,'ippiRemap_64f_C1R');
  ippiRemap_64f_C3R:=getProc(hh,'ippiRemap_64f_C3R');
  ippiRemap_64f_C4R:=getProc(hh,'ippiRemap_64f_C4R');
  ippiRemap_64f_AC4R:=getProc(hh,'ippiRemap_64f_AC4R');
  ippiResizeFilterGetSize_8u_C1R:=getProc(hh,'ippiResizeFilterGetSize_8u_C1R');
  ippiResizeFilterInit_8u_C1R:=getProc(hh,'ippiResizeFilterInit_8u_C1R');
  ippiResizeFilter_8u_C1R:=getProc(hh,'ippiResizeFilter_8u_C1R');
  ippiResizeYCbCr422GetBufSize:=getProc(hh,'ippiResizeYCbCr422GetBufSize');
  ippiResizeYCbCr422_8u_C2R:=getProc(hh,'ippiResizeYCbCr422_8u_C2R');
  ippiGetAffineBound:=getProc(hh,'ippiGetAffineBound');
  ippiGetAffineQuad:=getProc(hh,'ippiGetAffineQuad');
  ippiGetAffineTransform:=getProc(hh,'ippiGetAffineTransform');
  ippiGetAffineSrcRoi:=getProc(hh,'ippiGetAffineSrcRoi');
  ippiGetRotateShift:=getProc(hh,'ippiGetRotateShift');
  ippiGetRotateTransform:=getProc(hh,'ippiGetRotateTransform');
  ippiGetPerspectiveBound:=getProc(hh,'ippiGetPerspectiveBound');
  ippiGetPerspectiveQuad:=getProc(hh,'ippiGetPerspectiveQuad');
  ippiGetPerspectiveTransform:=getProc(hh,'ippiGetPerspectiveTransform');
  ippiGetBilinearBound:=getProc(hh,'ippiGetBilinearBound');
  ippiGetBilinearQuad:=getProc(hh,'ippiGetBilinearQuad');
  ippiGetBilinearTransform:=getProc(hh,'ippiGetBilinearTransform');
  ippiWarpBilinearGetBufferSize:=getProc(hh,'ippiWarpBilinearGetBufferSize');
  ippiWarpBilinear_8u_C1R:=getProc(hh,'ippiWarpBilinear_8u_C1R');
  ippiWarpBilinear_8u_C3R:=getProc(hh,'ippiWarpBilinear_8u_C3R');
  ippiWarpBilinear_8u_C4R:=getProc(hh,'ippiWarpBilinear_8u_C4R');
  ippiWarpBilinear_32f_C1R:=getProc(hh,'ippiWarpBilinear_32f_C1R');
  ippiWarpBilinear_32f_C3R:=getProc(hh,'ippiWarpBilinear_32f_C3R');
  ippiWarpBilinear_32f_C4R:=getProc(hh,'ippiWarpBilinear_32f_C4R');
  ippiWarpBilinear_16u_C1R:=getProc(hh,'ippiWarpBilinear_16u_C1R');
  ippiWarpBilinear_16u_C3R:=getProc(hh,'ippiWarpBilinear_16u_C3R');
  ippiWarpBilinear_16u_C4R:=getProc(hh,'ippiWarpBilinear_16u_C4R');
  ippiWarpBilinearBack_8u_C1R:=getProc(hh,'ippiWarpBilinearBack_8u_C1R');
  ippiWarpBilinearBack_8u_C3R:=getProc(hh,'ippiWarpBilinearBack_8u_C3R');
  ippiWarpBilinearBack_8u_C4R:=getProc(hh,'ippiWarpBilinearBack_8u_C4R');
  ippiWarpBilinearBack_32f_C1R:=getProc(hh,'ippiWarpBilinearBack_32f_C1R');
  ippiWarpBilinearBack_32f_C3R:=getProc(hh,'ippiWarpBilinearBack_32f_C3R');
  ippiWarpBilinearBack_32f_C4R:=getProc(hh,'ippiWarpBilinearBack_32f_C4R');
  ippiWarpBilinearBack_16u_C1R:=getProc(hh,'ippiWarpBilinearBack_16u_C1R');
  ippiWarpBilinearBack_16u_C3R:=getProc(hh,'ippiWarpBilinearBack_16u_C3R');
  ippiWarpBilinearBack_16u_C4R:=getProc(hh,'ippiWarpBilinearBack_16u_C4R');
  ippiWarpBilinearQuadGetBufferSize:=getProc(hh,'ippiWarpBilinearQuadGetBufferSize');
  ippiWarpBilinearQuad_8u_C1R:=getProc(hh,'ippiWarpBilinearQuad_8u_C1R');
  ippiWarpBilinearQuad_8u_C3R:=getProc(hh,'ippiWarpBilinearQuad_8u_C3R');
  ippiWarpBilinearQuad_8u_C4R:=getProc(hh,'ippiWarpBilinearQuad_8u_C4R');
  ippiWarpBilinearQuad_32f_C1R:=getProc(hh,'ippiWarpBilinearQuad_32f_C1R');
  ippiWarpBilinearQuad_32f_C3R:=getProc(hh,'ippiWarpBilinearQuad_32f_C3R');
  ippiWarpBilinearQuad_32f_C4R:=getProc(hh,'ippiWarpBilinearQuad_32f_C4R');
  ippiWarpBilinearQuad_16u_C1R:=getProc(hh,'ippiWarpBilinearQuad_16u_C1R');
  ippiWarpBilinearQuad_16u_C3R:=getProc(hh,'ippiWarpBilinearQuad_16u_C3R');
  ippiWarpBilinearQuad_16u_C4R:=getProc(hh,'ippiWarpBilinearQuad_16u_C4R');
  ippiWarpGetBufferSize:=getProc(hh,'ippiWarpGetBufferSize');
  ippiWarpQuadGetSize:=getProc(hh,'ippiWarpQuadGetSize');
  ippiWarpQuadNearestInit:=getProc(hh,'ippiWarpQuadNearestInit');
  ippiWarpQuadLinearInit:=getProc(hh,'ippiWarpQuadLinearInit');
  ippiWarpQuadCubicInit:=getProc(hh,'ippiWarpQuadCubicInit');
  ippiWarpAffineGetSize:=getProc(hh,'ippiWarpAffineGetSize');
  ippiWarpAffineNearestInit:=getProc(hh,'ippiWarpAffineNearestInit');
  ippiWarpAffineLinearInit:=getProc(hh,'ippiWarpAffineLinearInit');
  ippiWarpAffineCubicInit:=getProc(hh,'ippiWarpAffineCubicInit');
  ippiWarpAffineNearest_8u_C1R:=getProc(hh,'ippiWarpAffineNearest_8u_C1R');
  ippiWarpAffineNearest_8u_C3R:=getProc(hh,'ippiWarpAffineNearest_8u_C3R');
  ippiWarpAffineNearest_8u_C4R:=getProc(hh,'ippiWarpAffineNearest_8u_C4R');
  ippiWarpAffineNearest_16u_C1R:=getProc(hh,'ippiWarpAffineNearest_16u_C1R');
  ippiWarpAffineNearest_16u_C3R:=getProc(hh,'ippiWarpAffineNearest_16u_C3R');
  ippiWarpAffineNearest_16u_C4R:=getProc(hh,'ippiWarpAffineNearest_16u_C4R');
  ippiWarpAffineNearest_16s_C1R:=getProc(hh,'ippiWarpAffineNearest_16s_C1R');
  ippiWarpAffineNearest_16s_C3R:=getProc(hh,'ippiWarpAffineNearest_16s_C3R');
  ippiWarpAffineNearest_16s_C4R:=getProc(hh,'ippiWarpAffineNearest_16s_C4R');
  ippiWarpAffineNearest_32f_C1R:=getProc(hh,'ippiWarpAffineNearest_32f_C1R');
  ippiWarpAffineNearest_32f_C3R:=getProc(hh,'ippiWarpAffineNearest_32f_C3R');
  ippiWarpAffineNearest_32f_C4R:=getProc(hh,'ippiWarpAffineNearest_32f_C4R');
  ippiWarpAffineNearest_64f_C1R:=getProc(hh,'ippiWarpAffineNearest_64f_C1R');
  ippiWarpAffineNearest_64f_C3R:=getProc(hh,'ippiWarpAffineNearest_64f_C3R');
  ippiWarpAffineNearest_64f_C4R:=getProc(hh,'ippiWarpAffineNearest_64f_C4R');
  ippiWarpAffineLinear_8u_C1R:=getProc(hh,'ippiWarpAffineLinear_8u_C1R');
  ippiWarpAffineLinear_8u_C3R:=getProc(hh,'ippiWarpAffineLinear_8u_C3R');
  ippiWarpAffineLinear_8u_C4R:=getProc(hh,'ippiWarpAffineLinear_8u_C4R');
  ippiWarpAffineLinear_16u_C1R:=getProc(hh,'ippiWarpAffineLinear_16u_C1R');
  ippiWarpAffineLinear_16u_C3R:=getProc(hh,'ippiWarpAffineLinear_16u_C3R');
  ippiWarpAffineLinear_16u_C4R:=getProc(hh,'ippiWarpAffineLinear_16u_C4R');
  ippiWarpAffineLinear_16s_C1R:=getProc(hh,'ippiWarpAffineLinear_16s_C1R');
  ippiWarpAffineLinear_16s_C3R:=getProc(hh,'ippiWarpAffineLinear_16s_C3R');
  ippiWarpAffineLinear_16s_C4R:=getProc(hh,'ippiWarpAffineLinear_16s_C4R');
  ippiWarpAffineLinear_32f_C1R:=getProc(hh,'ippiWarpAffineLinear_32f_C1R');
  ippiWarpAffineLinear_32f_C3R:=getProc(hh,'ippiWarpAffineLinear_32f_C3R');
  ippiWarpAffineLinear_32f_C4R:=getProc(hh,'ippiWarpAffineLinear_32f_C4R');
  ippiWarpAffineLinear_64f_C1R:=getProc(hh,'ippiWarpAffineLinear_64f_C1R');
  ippiWarpAffineLinear_64f_C3R:=getProc(hh,'ippiWarpAffineLinear_64f_C3R');
  ippiWarpAffineLinear_64f_C4R:=getProc(hh,'ippiWarpAffineLinear_64f_C4R');
  ippiWarpAffineCubic_8u_C1R:=getProc(hh,'ippiWarpAffineCubic_8u_C1R');
  ippiWarpAffineCubic_8u_C3R:=getProc(hh,'ippiWarpAffineCubic_8u_C3R');
  ippiWarpAffineCubic_8u_C4R:=getProc(hh,'ippiWarpAffineCubic_8u_C4R');
  ippiWarpAffineCubic_16u_C1R:=getProc(hh,'ippiWarpAffineCubic_16u_C1R');
  ippiWarpAffineCubic_16u_C3R:=getProc(hh,'ippiWarpAffineCubic_16u_C3R');
  ippiWarpAffineCubic_16u_C4R:=getProc(hh,'ippiWarpAffineCubic_16u_C4R');
  ippiWarpAffineCubic_16s_C1R:=getProc(hh,'ippiWarpAffineCubic_16s_C1R');
  ippiWarpAffineCubic_16s_C3R:=getProc(hh,'ippiWarpAffineCubic_16s_C3R');
  ippiWarpAffineCubic_16s_C4R:=getProc(hh,'ippiWarpAffineCubic_16s_C4R');
  ippiWarpAffineCubic_32f_C1R:=getProc(hh,'ippiWarpAffineCubic_32f_C1R');
  ippiWarpAffineCubic_32f_C3R:=getProc(hh,'ippiWarpAffineCubic_32f_C3R');
  ippiWarpAffineCubic_32f_C4R:=getProc(hh,'ippiWarpAffineCubic_32f_C4R');
  ippiWarpAffineCubic_64f_C1R:=getProc(hh,'ippiWarpAffineCubic_64f_C1R');
  ippiWarpAffineCubic_64f_C3R:=getProc(hh,'ippiWarpAffineCubic_64f_C3R');
  ippiWarpAffineCubic_64f_C4R:=getProc(hh,'ippiWarpAffineCubic_64f_C4R');
  ippiWarpGetRectInfinite:=getProc(hh,'ippiWarpGetRectInfinite');
  ippiWarpPerspectiveGetSize:=getProc(hh,'ippiWarpPerspectiveGetSize');
  ippiWarpPerspectiveNearestInit:=getProc(hh,'ippiWarpPerspectiveNearestInit');
  ippiWarpPerspectiveLinearInit:=getProc(hh,'ippiWarpPerspectiveLinearInit');
  ippiWarpPerspectiveCubicInit:=getProc(hh,'ippiWarpPerspectiveCubicInit');
  ippiWarpPerspectiveNearest_8u_C1R:=getProc(hh,'ippiWarpPerspectiveNearest_8u_C1R');
  ippiWarpPerspectiveNearest_8u_C3R:=getProc(hh,'ippiWarpPerspectiveNearest_8u_C3R');
  ippiWarpPerspectiveNearest_8u_C4R:=getProc(hh,'ippiWarpPerspectiveNearest_8u_C4R');
  ippiWarpPerspectiveNearest_16u_C1R:=getProc(hh,'ippiWarpPerspectiveNearest_16u_C1R');
  ippiWarpPerspectiveNearest_16u_C3R:=getProc(hh,'ippiWarpPerspectiveNearest_16u_C3R');
  ippiWarpPerspectiveNearest_16u_C4R:=getProc(hh,'ippiWarpPerspectiveNearest_16u_C4R');
  ippiWarpPerspectiveNearest_16s_C1R:=getProc(hh,'ippiWarpPerspectiveNearest_16s_C1R');
  ippiWarpPerspectiveNearest_16s_C3R:=getProc(hh,'ippiWarpPerspectiveNearest_16s_C3R');
  ippiWarpPerspectiveNearest_16s_C4R:=getProc(hh,'ippiWarpPerspectiveNearest_16s_C4R');
  ippiWarpPerspectiveNearest_32f_C1R:=getProc(hh,'ippiWarpPerspectiveNearest_32f_C1R');
  ippiWarpPerspectiveNearest_32f_C3R:=getProc(hh,'ippiWarpPerspectiveNearest_32f_C3R');
  ippiWarpPerspectiveNearest_32f_C4R:=getProc(hh,'ippiWarpPerspectiveNearest_32f_C4R');
  ippiWarpPerspectiveLinear_8u_C1R:=getProc(hh,'ippiWarpPerspectiveLinear_8u_C1R');
  ippiWarpPerspectiveLinear_8u_C3R:=getProc(hh,'ippiWarpPerspectiveLinear_8u_C3R');
  ippiWarpPerspectiveLinear_8u_C4R:=getProc(hh,'ippiWarpPerspectiveLinear_8u_C4R');
  ippiWarpPerspectiveLinear_16u_C1R:=getProc(hh,'ippiWarpPerspectiveLinear_16u_C1R');
  ippiWarpPerspectiveLinear_16u_C3R:=getProc(hh,'ippiWarpPerspectiveLinear_16u_C3R');
  ippiWarpPerspectiveLinear_16u_C4R:=getProc(hh,'ippiWarpPerspectiveLinear_16u_C4R');
  ippiWarpPerspectiveLinear_16s_C1R:=getProc(hh,'ippiWarpPerspectiveLinear_16s_C1R');
  ippiWarpPerspectiveLinear_16s_C3R:=getProc(hh,'ippiWarpPerspectiveLinear_16s_C3R');
  ippiWarpPerspectiveLinear_16s_C4R:=getProc(hh,'ippiWarpPerspectiveLinear_16s_C4R');
  ippiWarpPerspectiveLinear_32f_C1R:=getProc(hh,'ippiWarpPerspectiveLinear_32f_C1R');
  ippiWarpPerspectiveLinear_32f_C3R:=getProc(hh,'ippiWarpPerspectiveLinear_32f_C3R');
  ippiWarpPerspectiveLinear_32f_C4R:=getProc(hh,'ippiWarpPerspectiveLinear_32f_C4R');
  ippiWarpPerspectiveCubic_8u_C1R:=getProc(hh,'ippiWarpPerspectiveCubic_8u_C1R');
  ippiWarpPerspectiveCubic_8u_C3R:=getProc(hh,'ippiWarpPerspectiveCubic_8u_C3R');
  ippiWarpPerspectiveCubic_8u_C4R:=getProc(hh,'ippiWarpPerspectiveCubic_8u_C4R');
  ippiWarpPerspectiveCubic_16u_C1R:=getProc(hh,'ippiWarpPerspectiveCubic_16u_C1R');
  ippiWarpPerspectiveCubic_16u_C3R:=getProc(hh,'ippiWarpPerspectiveCubic_16u_C3R');
  ippiWarpPerspectiveCubic_16u_C4R:=getProc(hh,'ippiWarpPerspectiveCubic_16u_C4R');
  ippiWarpPerspectiveCubic_16s_C1R:=getProc(hh,'ippiWarpPerspectiveCubic_16s_C1R');
  ippiWarpPerspectiveCubic_16s_C3R:=getProc(hh,'ippiWarpPerspectiveCubic_16s_C3R');
  ippiWarpPerspectiveCubic_16s_C4R:=getProc(hh,'ippiWarpPerspectiveCubic_16s_C4R');
  ippiWarpPerspectiveCubic_32f_C1R:=getProc(hh,'ippiWarpPerspectiveCubic_32f_C1R');
  ippiWarpPerspectiveCubic_32f_C3R:=getProc(hh,'ippiWarpPerspectiveCubic_32f_C3R');
  ippiWarpPerspectiveCubic_32f_C4R:=getProc(hh,'ippiWarpPerspectiveCubic_32f_C4R');
  ippiMomentGetStateSize_64f:=getProc(hh,'ippiMomentGetStateSize_64f');
  ippiMomentInit_64f:=getProc(hh,'ippiMomentInit_64f');
  ippiMoments64f_8u_C1R:=getProc(hh,'ippiMoments64f_8u_C1R');
  ippiMoments64f_8u_C3R:=getProc(hh,'ippiMoments64f_8u_C3R');
  ippiMoments64f_8u_AC4R:=getProc(hh,'ippiMoments64f_8u_AC4R');
  ippiMoments64f_32f_C1R:=getProc(hh,'ippiMoments64f_32f_C1R');
  ippiMoments64f_32f_C3R:=getProc(hh,'ippiMoments64f_32f_C3R');
  ippiMoments64f_32f_AC4R:=getProc(hh,'ippiMoments64f_32f_AC4R');
  ippiMoments64f_16u_C1R:=getProc(hh,'ippiMoments64f_16u_C1R');
  ippiMoments64f_16u_C3R:=getProc(hh,'ippiMoments64f_16u_C3R');
  ippiMoments64f_16u_AC4R:=getProc(hh,'ippiMoments64f_16u_AC4R');
  ippiGetSpatialMoment_64f:=getProc(hh,'ippiGetSpatialMoment_64f');
  ippiGetCentralMoment_64f:=getProc(hh,'ippiGetCentralMoment_64f');
  ippiGetNormalizedSpatialMoment_64f:=getProc(hh,'ippiGetNormalizedSpatialMoment_64f');
  ippiGetNormalizedCentralMoment_64f:=getProc(hh,'ippiGetNormalizedCentralMoment_64f');
  ippiGetHuMoments_64f:=getProc(hh,'ippiGetHuMoments_64f');
  ippiNorm_Inf_8u_C1R:=getProc(hh,'ippiNorm_Inf_8u_C1R');
  ippiNorm_Inf_8u_C3R:=getProc(hh,'ippiNorm_Inf_8u_C3R');
  ippiNorm_Inf_8u_C4R:=getProc(hh,'ippiNorm_Inf_8u_C4R');
  ippiNorm_Inf_16s_C1R:=getProc(hh,'ippiNorm_Inf_16s_C1R');
  ippiNorm_Inf_16s_C3R:=getProc(hh,'ippiNorm_Inf_16s_C3R');
  ippiNorm_Inf_16s_C4R:=getProc(hh,'ippiNorm_Inf_16s_C4R');
  ippiNorm_Inf_16u_C1R:=getProc(hh,'ippiNorm_Inf_16u_C1R');
  ippiNorm_Inf_16u_C3R:=getProc(hh,'ippiNorm_Inf_16u_C3R');
  ippiNorm_Inf_16u_C4R:=getProc(hh,'ippiNorm_Inf_16u_C4R');
  ippiNorm_Inf_32f_C1R:=getProc(hh,'ippiNorm_Inf_32f_C1R');
  ippiNorm_Inf_32f_C3R:=getProc(hh,'ippiNorm_Inf_32f_C3R');
  ippiNorm_Inf_32f_C4R:=getProc(hh,'ippiNorm_Inf_32f_C4R');
  ippiNorm_L1_8u_C1R:=getProc(hh,'ippiNorm_L1_8u_C1R');
  ippiNorm_L1_8u_C3R:=getProc(hh,'ippiNorm_L1_8u_C3R');
  ippiNorm_L1_8u_C4R:=getProc(hh,'ippiNorm_L1_8u_C4R');
  ippiNorm_L1_16s_C1R:=getProc(hh,'ippiNorm_L1_16s_C1R');
  ippiNorm_L1_16s_C3R:=getProc(hh,'ippiNorm_L1_16s_C3R');
  ippiNorm_L1_16s_C4R:=getProc(hh,'ippiNorm_L1_16s_C4R');
  ippiNorm_L1_16u_C1R:=getProc(hh,'ippiNorm_L1_16u_C1R');
  ippiNorm_L1_16u_C3R:=getProc(hh,'ippiNorm_L1_16u_C3R');
  ippiNorm_L1_16u_C4R:=getProc(hh,'ippiNorm_L1_16u_C4R');
  ippiNorm_L1_32f_C1R:=getProc(hh,'ippiNorm_L1_32f_C1R');
  ippiNorm_L1_32f_C3R:=getProc(hh,'ippiNorm_L1_32f_C3R');
  ippiNorm_L1_32f_C4R:=getProc(hh,'ippiNorm_L1_32f_C4R');
  ippiNorm_L2_8u_C1R:=getProc(hh,'ippiNorm_L2_8u_C1R');
  ippiNorm_L2_8u_C3R:=getProc(hh,'ippiNorm_L2_8u_C3R');
  ippiNorm_L2_8u_C4R:=getProc(hh,'ippiNorm_L2_8u_C4R');
  ippiNorm_L2_16s_C1R:=getProc(hh,'ippiNorm_L2_16s_C1R');
  ippiNorm_L2_16s_C3R:=getProc(hh,'ippiNorm_L2_16s_C3R');
  ippiNorm_L2_16s_C4R:=getProc(hh,'ippiNorm_L2_16s_C4R');
  ippiNorm_L2_16u_C1R:=getProc(hh,'ippiNorm_L2_16u_C1R');
  ippiNorm_L2_16u_C3R:=getProc(hh,'ippiNorm_L2_16u_C3R');
  ippiNorm_L2_16u_C4R:=getProc(hh,'ippiNorm_L2_16u_C4R');
  ippiNorm_L2_32f_C1R:=getProc(hh,'ippiNorm_L2_32f_C1R');
  ippiNorm_L2_32f_C3R:=getProc(hh,'ippiNorm_L2_32f_C3R');
  ippiNorm_L2_32f_C4R:=getProc(hh,'ippiNorm_L2_32f_C4R');
  ippiNormDiff_Inf_8u_C1R:=getProc(hh,'ippiNormDiff_Inf_8u_C1R');
  ippiNormDiff_Inf_8u_C3R:=getProc(hh,'ippiNormDiff_Inf_8u_C3R');
  ippiNormDiff_Inf_8u_C4R:=getProc(hh,'ippiNormDiff_Inf_8u_C4R');
  ippiNormDiff_Inf_16s_C1R:=getProc(hh,'ippiNormDiff_Inf_16s_C1R');
  ippiNormDiff_Inf_16s_C3R:=getProc(hh,'ippiNormDiff_Inf_16s_C3R');
  ippiNormDiff_Inf_16s_C4R:=getProc(hh,'ippiNormDiff_Inf_16s_C4R');
  ippiNormDiff_Inf_16u_C1R:=getProc(hh,'ippiNormDiff_Inf_16u_C1R');
  ippiNormDiff_Inf_16u_C3R:=getProc(hh,'ippiNormDiff_Inf_16u_C3R');
  ippiNormDiff_Inf_16u_C4R:=getProc(hh,'ippiNormDiff_Inf_16u_C4R');
  ippiNormDiff_Inf_32f_C1R:=getProc(hh,'ippiNormDiff_Inf_32f_C1R');
  ippiNormDiff_Inf_32f_C3R:=getProc(hh,'ippiNormDiff_Inf_32f_C3R');
  ippiNormDiff_Inf_32f_C4R:=getProc(hh,'ippiNormDiff_Inf_32f_C4R');
  ippiNormDiff_L1_8u_C1R:=getProc(hh,'ippiNormDiff_L1_8u_C1R');
end;

procedure initIppi2;
begin
  ippiNormDiff_L1_8u_C3R:=getProc(hh,'ippiNormDiff_L1_8u_C3R');
  ippiNormDiff_L1_8u_C4R:=getProc(hh,'ippiNormDiff_L1_8u_C4R');
  ippiNormDiff_L1_16s_C1R:=getProc(hh,'ippiNormDiff_L1_16s_C1R');
  ippiNormDiff_L1_16s_C3R:=getProc(hh,'ippiNormDiff_L1_16s_C3R');
  ippiNormDiff_L1_16s_C4R:=getProc(hh,'ippiNormDiff_L1_16s_C4R');
  ippiNormDiff_L1_16u_C1R:=getProc(hh,'ippiNormDiff_L1_16u_C1R');
  ippiNormDiff_L1_16u_C3R:=getProc(hh,'ippiNormDiff_L1_16u_C3R');
  ippiNormDiff_L1_16u_C4R:=getProc(hh,'ippiNormDiff_L1_16u_C4R');
  ippiNormDiff_L1_32f_C1R:=getProc(hh,'ippiNormDiff_L1_32f_C1R');
  ippiNormDiff_L1_32f_C3R:=getProc(hh,'ippiNormDiff_L1_32f_C3R');
  ippiNormDiff_L1_32f_C4R:=getProc(hh,'ippiNormDiff_L1_32f_C4R');
  ippiNormDiff_L2_8u_C1R:=getProc(hh,'ippiNormDiff_L2_8u_C1R');
  ippiNormDiff_L2_8u_C3R:=getProc(hh,'ippiNormDiff_L2_8u_C3R');
  ippiNormDiff_L2_8u_C4R:=getProc(hh,'ippiNormDiff_L2_8u_C4R');
  ippiNormDiff_L2_16s_C1R:=getProc(hh,'ippiNormDiff_L2_16s_C1R');
  ippiNormDiff_L2_16s_C3R:=getProc(hh,'ippiNormDiff_L2_16s_C3R');
  ippiNormDiff_L2_16s_C4R:=getProc(hh,'ippiNormDiff_L2_16s_C4R');
  ippiNormDiff_L2_16u_C1R:=getProc(hh,'ippiNormDiff_L2_16u_C1R');
  ippiNormDiff_L2_16u_C3R:=getProc(hh,'ippiNormDiff_L2_16u_C3R');
  ippiNormDiff_L2_16u_C4R:=getProc(hh,'ippiNormDiff_L2_16u_C4R');
  ippiNormDiff_L2_32f_C1R:=getProc(hh,'ippiNormDiff_L2_32f_C1R');
  ippiNormDiff_L2_32f_C3R:=getProc(hh,'ippiNormDiff_L2_32f_C3R');
  ippiNormDiff_L2_32f_C4R:=getProc(hh,'ippiNormDiff_L2_32f_C4R');
  ippiNormRel_Inf_8u_C1R:=getProc(hh,'ippiNormRel_Inf_8u_C1R');
  ippiNormRel_Inf_8u_C3R:=getProc(hh,'ippiNormRel_Inf_8u_C3R');
  ippiNormRel_Inf_8u_C4R:=getProc(hh,'ippiNormRel_Inf_8u_C4R');
  ippiNormRel_Inf_16s_C1R:=getProc(hh,'ippiNormRel_Inf_16s_C1R');
  ippiNormRel_Inf_16s_C3R:=getProc(hh,'ippiNormRel_Inf_16s_C3R');
  ippiNormRel_Inf_16s_C4R:=getProc(hh,'ippiNormRel_Inf_16s_C4R');
  ippiNormRel_Inf_16u_C1R:=getProc(hh,'ippiNormRel_Inf_16u_C1R');
  ippiNormRel_Inf_16u_C3R:=getProc(hh,'ippiNormRel_Inf_16u_C3R');
  ippiNormRel_Inf_16u_C4R:=getProc(hh,'ippiNormRel_Inf_16u_C4R');
  ippiNormRel_Inf_32f_C1R:=getProc(hh,'ippiNormRel_Inf_32f_C1R');
  ippiNormRel_Inf_32f_C3R:=getProc(hh,'ippiNormRel_Inf_32f_C3R');
  ippiNormRel_Inf_32f_C4R:=getProc(hh,'ippiNormRel_Inf_32f_C4R');
  ippiNormRel_L1_8u_C1R:=getProc(hh,'ippiNormRel_L1_8u_C1R');
  ippiNormRel_L1_8u_C3R:=getProc(hh,'ippiNormRel_L1_8u_C3R');
  ippiNormRel_L1_8u_C4R:=getProc(hh,'ippiNormRel_L1_8u_C4R');
  ippiNormRel_L1_16s_C1R:=getProc(hh,'ippiNormRel_L1_16s_C1R');
  ippiNormRel_L1_16s_C3R:=getProc(hh,'ippiNormRel_L1_16s_C3R');
  ippiNormRel_L1_16s_C4R:=getProc(hh,'ippiNormRel_L1_16s_C4R');
  ippiNormRel_L1_16u_C1R:=getProc(hh,'ippiNormRel_L1_16u_C1R');
  ippiNormRel_L1_16u_C3R:=getProc(hh,'ippiNormRel_L1_16u_C3R');
  ippiNormRel_L1_16u_C4R:=getProc(hh,'ippiNormRel_L1_16u_C4R');
  ippiNormRel_L1_32f_C1R:=getProc(hh,'ippiNormRel_L1_32f_C1R');
  ippiNormRel_L1_32f_C3R:=getProc(hh,'ippiNormRel_L1_32f_C3R');
  ippiNormRel_L1_32f_C4R:=getProc(hh,'ippiNormRel_L1_32f_C4R');
  ippiNormRel_L2_8u_C1R:=getProc(hh,'ippiNormRel_L2_8u_C1R');
  ippiNormRel_L2_8u_C3R:=getProc(hh,'ippiNormRel_L2_8u_C3R');
  ippiNormRel_L2_8u_C4R:=getProc(hh,'ippiNormRel_L2_8u_C4R');
  ippiNormRel_L2_16s_C1R:=getProc(hh,'ippiNormRel_L2_16s_C1R');
  ippiNormRel_L2_16s_C3R:=getProc(hh,'ippiNormRel_L2_16s_C3R');
  ippiNormRel_L2_16s_C4R:=getProc(hh,'ippiNormRel_L2_16s_C4R');
  ippiNormRel_L2_16u_C1R:=getProc(hh,'ippiNormRel_L2_16u_C1R');
  ippiNormRel_L2_16u_C3R:=getProc(hh,'ippiNormRel_L2_16u_C3R');
  ippiNormRel_L2_16u_C4R:=getProc(hh,'ippiNormRel_L2_16u_C4R');
  ippiNormRel_L2_32f_C1R:=getProc(hh,'ippiNormRel_L2_32f_C1R');
  ippiNormRel_L2_32f_C3R:=getProc(hh,'ippiNormRel_L2_32f_C3R');
  ippiNormRel_L2_32f_C4R:=getProc(hh,'ippiNormRel_L2_32f_C4R');
  ippiSum_8u_C1R:=getProc(hh,'ippiSum_8u_C1R');
  ippiSum_8u_C3R:=getProc(hh,'ippiSum_8u_C3R');
  ippiSum_8u_C4R:=getProc(hh,'ippiSum_8u_C4R');
  ippiSum_16s_C1R:=getProc(hh,'ippiSum_16s_C1R');
  ippiSum_16s_C3R:=getProc(hh,'ippiSum_16s_C3R');
  ippiSum_16s_C4R:=getProc(hh,'ippiSum_16s_C4R');
  ippiSum_16u_C1R:=getProc(hh,'ippiSum_16u_C1R');
  ippiSum_16u_C3R:=getProc(hh,'ippiSum_16u_C3R');
  ippiSum_16u_C4R:=getProc(hh,'ippiSum_16u_C4R');
  ippiSum_32f_C1R:=getProc(hh,'ippiSum_32f_C1R');
  ippiSum_32f_C3R:=getProc(hh,'ippiSum_32f_C3R');
  ippiSum_32f_C4R:=getProc(hh,'ippiSum_32f_C4R');
  ippiMean_8u_C1R:=getProc(hh,'ippiMean_8u_C1R');
  ippiMean_8u_C3R:=getProc(hh,'ippiMean_8u_C3R');
  ippiMean_8u_C4R:=getProc(hh,'ippiMean_8u_C4R');
  ippiMean_16s_C1R:=getProc(hh,'ippiMean_16s_C1R');
  ippiMean_16s_C3R:=getProc(hh,'ippiMean_16s_C3R');
  ippiMean_16s_C4R:=getProc(hh,'ippiMean_16s_C4R');
  ippiMean_16u_C1R:=getProc(hh,'ippiMean_16u_C1R');
  ippiMean_16u_C3R:=getProc(hh,'ippiMean_16u_C3R');
  ippiMean_16u_C4R:=getProc(hh,'ippiMean_16u_C4R');
  ippiMean_32f_C1R:=getProc(hh,'ippiMean_32f_C1R');
  ippiMean_32f_C3R:=getProc(hh,'ippiMean_32f_C3R');
  ippiMean_32f_C4R:=getProc(hh,'ippiMean_32f_C4R');
  ippiQualityIndex_8u32f_C1R:=getProc(hh,'ippiQualityIndex_8u32f_C1R');
  ippiQualityIndex_8u32f_C3R:=getProc(hh,'ippiQualityIndex_8u32f_C3R');
  ippiQualityIndex_8u32f_AC4R:=getProc(hh,'ippiQualityIndex_8u32f_AC4R');
  ippiQualityIndex_16u32f_C1R:=getProc(hh,'ippiQualityIndex_16u32f_C1R');
  ippiQualityIndex_16u32f_C3R:=getProc(hh,'ippiQualityIndex_16u32f_C3R');
  ippiQualityIndex_16u32f_AC4R:=getProc(hh,'ippiQualityIndex_16u32f_AC4R');
  ippiQualityIndex_32f_C1R:=getProc(hh,'ippiQualityIndex_32f_C1R');
  ippiQualityIndex_32f_C3R:=getProc(hh,'ippiQualityIndex_32f_C3R');
  ippiQualityIndex_32f_AC4R:=getProc(hh,'ippiQualityIndex_32f_AC4R');
  ippiQualityIndexGetBufferSize:=getProc(hh,'ippiQualityIndexGetBufferSize');
  ippiHistogramGetBufferSize:=getProc(hh,'ippiHistogramGetBufferSize');
  ippiHistogramInit:=getProc(hh,'ippiHistogramInit');
  ippiHistogramUniformInit:=getProc(hh,'ippiHistogramUniformInit');
  ippiHistogramGetLevels:=getProc(hh,'ippiHistogramGetLevels');
  ippiHistogram_8u_C1R:=getProc(hh,'ippiHistogram_8u_C1R');
  ippiHistogram_8u_C3R:=getProc(hh,'ippiHistogram_8u_C3R');
  ippiHistogram_8u_C4R:=getProc(hh,'ippiHistogram_8u_C4R');
  ippiHistogram_16s_C1R:=getProc(hh,'ippiHistogram_16s_C1R');
  ippiHistogram_16s_C3R:=getProc(hh,'ippiHistogram_16s_C3R');
  ippiHistogram_16s_C4R:=getProc(hh,'ippiHistogram_16s_C4R');
  ippiHistogram_16u_C1R:=getProc(hh,'ippiHistogram_16u_C1R');
  ippiHistogram_16u_C3R:=getProc(hh,'ippiHistogram_16u_C3R');
  ippiHistogram_16u_C4R:=getProc(hh,'ippiHistogram_16u_C4R');
  ippiHistogram_32f_C1R:=getProc(hh,'ippiHistogram_32f_C1R');
  ippiHistogram_32f_C3R:=getProc(hh,'ippiHistogram_32f_C3R');
  ippiHistogram_32f_C4R:=getProc(hh,'ippiHistogram_32f_C4R');
  ippiLUT_8u_C1R:=getProc(hh,'ippiLUT_8u_C1R');
  ippiLUT_8u_C3R:=getProc(hh,'ippiLUT_8u_C3R');
  ippiLUT_8u_C4R:=getProc(hh,'ippiLUT_8u_C4R');
  ippiLUT_8u_AC4R:=getProc(hh,'ippiLUT_8u_AC4R');
  ippiLUT_8u_C1IR:=getProc(hh,'ippiLUT_8u_C1IR');
  ippiLUT_8u_C3IR:=getProc(hh,'ippiLUT_8u_C3IR');
  ippiLUT_8u_C4IR:=getProc(hh,'ippiLUT_8u_C4IR');
  ippiLUT_8u_AC4IR:=getProc(hh,'ippiLUT_8u_AC4IR');
  ippiLUT_16u_C1R:=getProc(hh,'ippiLUT_16u_C1R');
  ippiLUT_16u_C3R:=getProc(hh,'ippiLUT_16u_C3R');
  ippiLUT_16u_C4R:=getProc(hh,'ippiLUT_16u_C4R');
  ippiLUT_16u_AC4R:=getProc(hh,'ippiLUT_16u_AC4R');
  ippiLUT_16u_C1IR:=getProc(hh,'ippiLUT_16u_C1IR');
  ippiLUT_16u_C3IR:=getProc(hh,'ippiLUT_16u_C3IR');
  ippiLUT_16u_C4IR:=getProc(hh,'ippiLUT_16u_C4IR');
  ippiLUT_16u_AC4IR:=getProc(hh,'ippiLUT_16u_AC4IR');
  ippiLUT_16s_C1R:=getProc(hh,'ippiLUT_16s_C1R');
  ippiLUT_16s_C3R:=getProc(hh,'ippiLUT_16s_C3R');
  ippiLUT_16s_C4R:=getProc(hh,'ippiLUT_16s_C4R');
  ippiLUT_16s_AC4R:=getProc(hh,'ippiLUT_16s_AC4R');
  ippiLUT_16s_C1IR:=getProc(hh,'ippiLUT_16s_C1IR');
  ippiLUT_16s_C3IR:=getProc(hh,'ippiLUT_16s_C3IR');
  ippiLUT_16s_C4IR:=getProc(hh,'ippiLUT_16s_C4IR');
  ippiLUT_16s_AC4IR:=getProc(hh,'ippiLUT_16s_AC4IR');
  ippiLUT_32f_C1R:=getProc(hh,'ippiLUT_32f_C1R');
  ippiLUT_32f_C3R:=getProc(hh,'ippiLUT_32f_C3R');
  ippiLUT_32f_C4R:=getProc(hh,'ippiLUT_32f_C4R');
  ippiLUT_32f_AC4R:=getProc(hh,'ippiLUT_32f_AC4R');
  ippiLUT_32f_C1IR:=getProc(hh,'ippiLUT_32f_C1IR');
  ippiLUT_32f_C3IR:=getProc(hh,'ippiLUT_32f_C3IR');
  ippiLUT_32f_C4IR:=getProc(hh,'ippiLUT_32f_C4IR');
  ippiLUT_32f_AC4IR:=getProc(hh,'ippiLUT_32f_AC4IR');
  ippiLUT_GetSize:=getProc(hh,'ippiLUT_GetSize');
  ippiLUT_Init_8u:=getProc(hh,'ippiLUT_Init_8u');
  ippiLUT_Init_16u:=getProc(hh,'ippiLUT_Init_16u');
  ippiLUT_Init_16s:=getProc(hh,'ippiLUT_Init_16s');
  ippiLUT_Init_32f:=getProc(hh,'ippiLUT_Init_32f');
  ippiLUTPalette_16u32u_C1R:=getProc(hh,'ippiLUTPalette_16u32u_C1R');
  ippiLUTPalette_16u24u_C1R:=getProc(hh,'ippiLUTPalette_16u24u_C1R');
  ippiLUTPalette_16u8u_C1R:=getProc(hh,'ippiLUTPalette_16u8u_C1R');
  ippiLUTPalette_8u32u_C1R:=getProc(hh,'ippiLUTPalette_8u32u_C1R');
  ippiLUTPalette_8u24u_C1R:=getProc(hh,'ippiLUTPalette_8u24u_C1R');
  ippiLUTPalette_8u_C1R:=getProc(hh,'ippiLUTPalette_8u_C1R');
  ippiLUTPalette_16u_C1R:=getProc(hh,'ippiLUTPalette_16u_C1R');
  ippiLUTPalette_8u_C3R:=getProc(hh,'ippiLUTPalette_8u_C3R');
  ippiLUTPalette_16u_C3R:=getProc(hh,'ippiLUTPalette_16u_C3R');
  ippiLUTPalette_8u_C4R:=getProc(hh,'ippiLUTPalette_8u_C4R');
  ippiLUTPalette_16u_C4R:=getProc(hh,'ippiLUTPalette_16u_C4R');
  ippiLUTPalette_8u_AC4R:=getProc(hh,'ippiLUTPalette_8u_AC4R');
  ippiLUTPalette_16u_AC4R:=getProc(hh,'ippiLUTPalette_16u_AC4R');
  ippiCountInRange_8u_C1R:=getProc(hh,'ippiCountInRange_8u_C1R');
  ippiCountInRange_8u_C3R:=getProc(hh,'ippiCountInRange_8u_C3R');
  ippiCountInRange_8u_AC4R:=getProc(hh,'ippiCountInRange_8u_AC4R');
  ippiCountInRange_32f_C1R:=getProc(hh,'ippiCountInRange_32f_C1R');
  ippiCountInRange_32f_C3R:=getProc(hh,'ippiCountInRange_32f_C3R');
  ippiCountInRange_32f_AC4R:=getProc(hh,'ippiCountInRange_32f_AC4R');
  ippiFilterMedianGetBufferSize_32f:=getProc(hh,'ippiFilterMedianGetBufferSize_32f');
  ippiFilterMedianGetBufferSize_64f:=getProc(hh,'ippiFilterMedianGetBufferSize_64f');
  ippiFilterMedian_32f_C3R:=getProc(hh,'ippiFilterMedian_32f_C3R');
  ippiFilterMedian_32f_C4R:=getProc(hh,'ippiFilterMedian_32f_C4R');
  ippiFilterMedian_64f_C1R:=getProc(hh,'ippiFilterMedian_64f_C1R');
  ippiFilterMedianCross_8u_C1R:=getProc(hh,'ippiFilterMedianCross_8u_C1R');
  ippiFilterMedianCross_8u_C3R:=getProc(hh,'ippiFilterMedianCross_8u_C3R');
  ippiFilterMedianCross_8u_AC4R:=getProc(hh,'ippiFilterMedianCross_8u_AC4R');
  ippiFilterMedianCross_16s_C1R:=getProc(hh,'ippiFilterMedianCross_16s_C1R');
  ippiFilterMedianCross_16s_C3R:=getProc(hh,'ippiFilterMedianCross_16s_C3R');
  ippiFilterMedianCross_16s_AC4R:=getProc(hh,'ippiFilterMedianCross_16s_AC4R');
  ippiFilterMedianCross_16u_C1R:=getProc(hh,'ippiFilterMedianCross_16u_C1R');
  ippiFilterMedianCross_16u_C3R:=getProc(hh,'ippiFilterMedianCross_16u_C3R');
  ippiFilterMedianCross_16u_AC4R:=getProc(hh,'ippiFilterMedianCross_16u_AC4R');
  ippiFilterMedianColor_8u_C3R:=getProc(hh,'ippiFilterMedianColor_8u_C3R');
  ippiFilterMedianColor_8u_AC4R:=getProc(hh,'ippiFilterMedianColor_8u_AC4R');
  ippiFilterMedianColor_16s_C3R:=getProc(hh,'ippiFilterMedianColor_16s_C3R');
  ippiFilterMedianColor_16s_AC4R:=getProc(hh,'ippiFilterMedianColor_16s_AC4R');
  ippiFilterMedianColor_32f_C3R:=getProc(hh,'ippiFilterMedianColor_32f_C3R');
  ippiFilterMedianColor_32f_AC4R:=getProc(hh,'ippiFilterMedianColor_32f_AC4R');
  ippiFilterMedianWeightedCenter3x3_8u_C1R:=getProc(hh,'ippiFilterMedianWeightedCenter3x3_8u_C1R');
  ippiFilterMedianBorderGetBufferSize:=getProc(hh,'ippiFilterMedianBorderGetBufferSize');
  ippiFilterMedianBorder_8u_C1R:=getProc(hh,'ippiFilterMedianBorder_8u_C1R');
  ippiFilterMedianBorder_16s_C1R:=getProc(hh,'ippiFilterMedianBorder_16s_C1R');
  ippiFilterMedianBorder_16u_C1R:=getProc(hh,'ippiFilterMedianBorder_16u_C1R');
  ippiFilterMedianBorder_32f_C1R:=getProc(hh,'ippiFilterMedianBorder_32f_C1R');
  ippiFilterMedianBorder_8u_C3R:=getProc(hh,'ippiFilterMedianBorder_8u_C3R');
  ippiFilterMedianBorder_16s_C3R:=getProc(hh,'ippiFilterMedianBorder_16s_C3R');
  ippiFilterMedianBorder_16u_C3R:=getProc(hh,'ippiFilterMedianBorder_16u_C3R');
  ippiFilterMedianBorder_8u_AC4R:=getProc(hh,'ippiFilterMedianBorder_8u_AC4R');
  ippiFilterMedianBorder_16s_AC4R:=getProc(hh,'ippiFilterMedianBorder_16s_AC4R');
  ippiFilterMedianBorder_16u_AC4R:=getProc(hh,'ippiFilterMedianBorder_16u_AC4R');
  ippiFilterMedianBorder_8u_C4R:=getProc(hh,'ippiFilterMedianBorder_8u_C4R');
  ippiFilterMedianBorder_16s_C4R:=getProc(hh,'ippiFilterMedianBorder_16s_C4R');
  ippiFilterMedianBorder_16u_C4R:=getProc(hh,'ippiFilterMedianBorder_16u_C4R');
  ippiFilterMaxBorderGetBufferSize:=getProc(hh,'ippiFilterMaxBorderGetBufferSize');
  ippiFilterMinBorderGetBufferSize:=getProc(hh,'ippiFilterMinBorderGetBufferSize');
  ippiFilterMaxBorder_8u_C1R:=getProc(hh,'ippiFilterMaxBorder_8u_C1R');
  ippiFilterMaxBorder_8u_C3R:=getProc(hh,'ippiFilterMaxBorder_8u_C3R');
  ippiFilterMaxBorder_8u_AC4R:=getProc(hh,'ippiFilterMaxBorder_8u_AC4R');
  ippiFilterMaxBorder_8u_C4R:=getProc(hh,'ippiFilterMaxBorder_8u_C4R');
  ippiFilterMaxBorder_16s_C1R:=getProc(hh,'ippiFilterMaxBorder_16s_C1R');
  ippiFilterMaxBorder_16s_C3R:=getProc(hh,'ippiFilterMaxBorder_16s_C3R');
  ippiFilterMaxBorder_16s_AC4R:=getProc(hh,'ippiFilterMaxBorder_16s_AC4R');
  ippiFilterMaxBorder_16s_C4R:=getProc(hh,'ippiFilterMaxBorder_16s_C4R');
  ippiFilterMaxBorder_16u_C1R:=getProc(hh,'ippiFilterMaxBorder_16u_C1R');
  ippiFilterMaxBorder_16u_C3R:=getProc(hh,'ippiFilterMaxBorder_16u_C3R');
  ippiFilterMaxBorder_16u_AC4R:=getProc(hh,'ippiFilterMaxBorder_16u_AC4R');
  ippiFilterMaxBorder_16u_C4R:=getProc(hh,'ippiFilterMaxBorder_16u_C4R');
  ippiFilterMaxBorder_32f_C1R:=getProc(hh,'ippiFilterMaxBorder_32f_C1R');
  ippiFilterMaxBorder_32f_C3R:=getProc(hh,'ippiFilterMaxBorder_32f_C3R');
  ippiFilterMaxBorder_32f_AC4R:=getProc(hh,'ippiFilterMaxBorder_32f_AC4R');
  ippiFilterMaxBorder_32f_C4R:=getProc(hh,'ippiFilterMaxBorder_32f_C4R');
  ippiFilterMinBorder_8u_C1R:=getProc(hh,'ippiFilterMinBorder_8u_C1R');
  ippiFilterMinBorder_8u_C3R:=getProc(hh,'ippiFilterMinBorder_8u_C3R');
  ippiFilterMinBorder_8u_AC4R:=getProc(hh,'ippiFilterMinBorder_8u_AC4R');
  ippiFilterMinBorder_8u_C4R:=getProc(hh,'ippiFilterMinBorder_8u_C4R');
  ippiFilterMinBorder_16s_C1R:=getProc(hh,'ippiFilterMinBorder_16s_C1R');
  ippiFilterMinBorder_16s_C3R:=getProc(hh,'ippiFilterMinBorder_16s_C3R');
  ippiFilterMinBorder_16s_AC4R:=getProc(hh,'ippiFilterMinBorder_16s_AC4R');
  ippiFilterMinBorder_16s_C4R:=getProc(hh,'ippiFilterMinBorder_16s_C4R');
  ippiFilterMinBorder_16u_C1R:=getProc(hh,'ippiFilterMinBorder_16u_C1R');
  ippiFilterMinBorder_16u_C3R:=getProc(hh,'ippiFilterMinBorder_16u_C3R');
  ippiFilterMinBorder_16u_AC4R:=getProc(hh,'ippiFilterMinBorder_16u_AC4R');
  ippiFilterMinBorder_16u_C4R:=getProc(hh,'ippiFilterMinBorder_16u_C4R');
  ippiFilterMinBorder_32f_C1R:=getProc(hh,'ippiFilterMinBorder_32f_C1R');
  ippiFilterMinBorder_32f_C3R:=getProc(hh,'ippiFilterMinBorder_32f_C3R');
  ippiFilterMinBorder_32f_AC4R:=getProc(hh,'ippiFilterMinBorder_32f_AC4R');
  ippiFilterMinBorder_32f_C4R:=getProc(hh,'ippiFilterMinBorder_32f_C4R');
  ippiFilterBoxBorderGetBufferSize:=getProc(hh,'ippiFilterBoxBorderGetBufferSize');
  ippiFilterBoxBorder_32f_C1R:=getProc(hh,'ippiFilterBoxBorder_32f_C1R');
  ippiFilterBoxBorder_32f_C3R:=getProc(hh,'ippiFilterBoxBorder_32f_C3R');
  ippiFilterBoxBorder_32f_C4R:=getProc(hh,'ippiFilterBoxBorder_32f_C4R');
  ippiFilterBoxBorder_32f_AC4R:=getProc(hh,'ippiFilterBoxBorder_32f_AC4R');
  ippiFilterBoxBorder_16u_C1R:=getProc(hh,'ippiFilterBoxBorder_16u_C1R');
  ippiFilterBoxBorder_16u_C3R:=getProc(hh,'ippiFilterBoxBorder_16u_C3R');
  ippiFilterBoxBorder_16u_C4R:=getProc(hh,'ippiFilterBoxBorder_16u_C4R');
  ippiFilterBoxBorder_16u_AC4R:=getProc(hh,'ippiFilterBoxBorder_16u_AC4R');
  ippiFilterBoxBorder_16s_C1R:=getProc(hh,'ippiFilterBoxBorder_16s_C1R');
  ippiFilterBoxBorder_16s_C3R:=getProc(hh,'ippiFilterBoxBorder_16s_C3R');
  ippiFilterBoxBorder_16s_C4R:=getProc(hh,'ippiFilterBoxBorder_16s_C4R');
  ippiFilterBoxBorder_16s_AC4R:=getProc(hh,'ippiFilterBoxBorder_16s_AC4R');
  ippiFilterBoxBorder_8u_C1R:=getProc(hh,'ippiFilterBoxBorder_8u_C1R');
  ippiFilterBoxBorder_8u_C3R:=getProc(hh,'ippiFilterBoxBorder_8u_C3R');
  ippiFilterBoxBorder_8u_C4R:=getProc(hh,'ippiFilterBoxBorder_8u_C4R');
  ippiFilterBoxBorder_8u_AC4R:=getProc(hh,'ippiFilterBoxBorder_8u_AC4R');
  ippiFilterBox_64f_C1R:=getProc(hh,'ippiFilterBox_64f_C1R');
  ippiSumWindowRow_8u32f_C1R:=getProc(hh,'ippiSumWindowRow_8u32f_C1R');
  ippiSumWindowRow_8u32f_C3R:=getProc(hh,'ippiSumWindowRow_8u32f_C3R');
  ippiSumWindowRow_8u32f_C4R:=getProc(hh,'ippiSumWindowRow_8u32f_C4R');
  ippiSumWindowRow_16u32f_C1R:=getProc(hh,'ippiSumWindowRow_16u32f_C1R');
  ippiSumWindowRow_16u32f_C3R:=getProc(hh,'ippiSumWindowRow_16u32f_C3R');
  ippiSumWindowRow_16u32f_C4R:=getProc(hh,'ippiSumWindowRow_16u32f_C4R');
  ippiSumWindowRow_16s32f_C1R:=getProc(hh,'ippiSumWindowRow_16s32f_C1R');
  ippiSumWindowRow_16s32f_C3R:=getProc(hh,'ippiSumWindowRow_16s32f_C3R');
  ippiSumWindowRow_16s32f_C4R:=getProc(hh,'ippiSumWindowRow_16s32f_C4R');
  ippiSumWindowColumn_8u32f_C1R:=getProc(hh,'ippiSumWindowColumn_8u32f_C1R');
  ippiSumWindowColumn_8u32f_C3R:=getProc(hh,'ippiSumWindowColumn_8u32f_C3R');
  ippiSumWindowColumn_8u32f_C4R:=getProc(hh,'ippiSumWindowColumn_8u32f_C4R');
  ippiSumWindowColumn_16u32f_C1R:=getProc(hh,'ippiSumWindowColumn_16u32f_C1R');
  ippiSumWindowColumn_16u32f_C3R:=getProc(hh,'ippiSumWindowColumn_16u32f_C3R');
  ippiSumWindowColumn_16u32f_C4R:=getProc(hh,'ippiSumWindowColumn_16u32f_C4R');
  ippiSumWindowColumn_16s32f_C1R:=getProc(hh,'ippiSumWindowColumn_16s32f_C1R');
  ippiSumWindowColumn_16s32f_C3R:=getProc(hh,'ippiSumWindowColumn_16s32f_C3R');
  ippiSumWindowColumn_16s32f_C4R:=getProc(hh,'ippiSumWindowColumn_16s32f_C4R');
  ippiFilterSobelHorizBorderGetBufferSize:=getProc(hh,'ippiFilterSobelHorizBorderGetBufferSize');
  ippiFilterSobelVertBorderGetBufferSize:=getProc(hh,'ippiFilterSobelVertBorderGetBufferSize');
  ippiFilterScharrHorizMaskBorderGetBufferSize:=getProc(hh,'ippiFilterScharrHorizMaskBorderGetBufferSize');
  ippiFilterScharrVertMaskBorderGetBufferSize:=getProc(hh,'ippiFilterScharrVertMaskBorderGetBufferSize');
  ippiFilterPrewittHorizBorderGetBufferSize:=getProc(hh,'ippiFilterPrewittHorizBorderGetBufferSize');
  ippiFilterPrewittVertBorderGetBufferSize:=getProc(hh,'ippiFilterPrewittVertBorderGetBufferSize');
  ippiFilterRobertsDownBorderGetBufferSize:=getProc(hh,'ippiFilterRobertsDownBorderGetBufferSize');
  ippiFilterRobertsUpBorderGetBufferSize:=getProc(hh,'ippiFilterRobertsUpBorderGetBufferSize');
  ippiFilterSobelHorizSecondBorderGetBufferSize:=getProc(hh,'ippiFilterSobelHorizSecondBorderGetBufferSize');
  ippiFilterSobelVertSecondBorderGetBufferSize:=getProc(hh,'ippiFilterSobelVertSecondBorderGetBufferSize');
  ippiFilterSobelNegVertBorderGetBufferSize:=getProc(hh,'ippiFilterSobelNegVertBorderGetBufferSize');
  ippiFilterLaplaceBorderGetBufferSize:=getProc(hh,'ippiFilterLaplaceBorderGetBufferSize');
  ippiFilterHipassBorderGetBufferSize:=getProc(hh,'ippiFilterHipassBorderGetBufferSize');
  ippiFilterSharpenBorderGetBufferSize:=getProc(hh,'ippiFilterSharpenBorderGetBufferSize');
  ippiFilterSobelVertBorder_8u16s_C1R:=getProc(hh,'ippiFilterSobelVertBorder_8u16s_C1R');
  ippiFilterSobelHorizBorder_8u16s_C1R:=getProc(hh,'ippiFilterSobelHorizBorder_8u16s_C1R');
  ippiFilterScharrVertMaskBorder_8u16s_C1R:=getProc(hh,'ippiFilterScharrVertMaskBorder_8u16s_C1R');
  ippiFilterScharrHorizMaskBorder_8u16s_C1R:=getProc(hh,'ippiFilterScharrHorizMaskBorder_8u16s_C1R');
  ippiFilterPrewittVertBorder_8u16s_C1R:=getProc(hh,'ippiFilterPrewittVertBorder_8u16s_C1R');
  ippiFilterPrewittHorizBorder_8u16s_C1R:=getProc(hh,'ippiFilterPrewittHorizBorder_8u16s_C1R');
  ippiFilterRobertsDownBorder_8u16s_C1R:=getProc(hh,'ippiFilterRobertsDownBorder_8u16s_C1R');
  ippiFilterRobertsUpBorder_8u16s_C1R:=getProc(hh,'ippiFilterRobertsUpBorder_8u16s_C1R');
  ippiFilterSobelVertSecondBorder_8u16s_C1R:=getProc(hh,'ippiFilterSobelVertSecondBorder_8u16s_C1R');
  ippiFilterSobelHorizSecondBorder_8u16s_C1R:=getProc(hh,'ippiFilterSobelHorizSecondBorder_8u16s_C1R');
  ippiFilterSobelNegVertBorder_8u16s_C1R:=getProc(hh,'ippiFilterSobelNegVertBorder_8u16s_C1R');
  ippiFilterSobelVertBorder_32f_C1R:=getProc(hh,'ippiFilterSobelVertBorder_32f_C1R');
  ippiFilterSobelHorizBorder_32f_C1R:=getProc(hh,'ippiFilterSobelHorizBorder_32f_C1R');
  ippiFilterScharrVertMaskBorder_32f_C1R:=getProc(hh,'ippiFilterScharrVertMaskBorder_32f_C1R');
  ippiFilterScharrHorizMaskBorder_32f_C1R:=getProc(hh,'ippiFilterScharrHorizMaskBorder_32f_C1R');
  ippiFilterPrewittVertBorder_32f_C1R:=getProc(hh,'ippiFilterPrewittVertBorder_32f_C1R');
  ippiFilterPrewittHorizBorder_32f_C1R:=getProc(hh,'ippiFilterPrewittHorizBorder_32f_C1R');
  ippiFilterRobertsDownBorder_32f_C1R:=getProc(hh,'ippiFilterRobertsDownBorder_32f_C1R');
  ippiFilterRobertsUpBorder_32f_C1R:=getProc(hh,'ippiFilterRobertsUpBorder_32f_C1R');
  ippiFilterSobelVertSecondBorder_32f_C1R:=getProc(hh,'ippiFilterSobelVertSecondBorder_32f_C1R');
  ippiFilterSobelHorizSecondBorder_32f_C1R:=getProc(hh,'ippiFilterSobelHorizSecondBorder_32f_C1R');
  ippiFilterSobelNegVertBorder_32f_C1R:=getProc(hh,'ippiFilterSobelNegVertBorder_32f_C1R');
  ippiFilterSobelVertBorder_16s_C1R:=getProc(hh,'ippiFilterSobelVertBorder_16s_C1R');
  ippiFilterSobelHorizBorder_16s_C1R:=getProc(hh,'ippiFilterSobelHorizBorder_16s_C1R');
  ippiFilterScharrVertMaskBorder_16s_C1R:=getProc(hh,'ippiFilterScharrVertMaskBorder_16s_C1R');
  ippiFilterScharrHorizMaskBorder_16s_C1R:=getProc(hh,'ippiFilterScharrHorizMaskBorder_16s_C1R');
  ippiFilterPrewittVertBorder_16s_C1R:=getProc(hh,'ippiFilterPrewittVertBorder_16s_C1R');
  ippiFilterPrewittHorizBorder_16s_C1R:=getProc(hh,'ippiFilterPrewittHorizBorder_16s_C1R');
  ippiFilterRobertsDownBorder_16s_C1R:=getProc(hh,'ippiFilterRobertsDownBorder_16s_C1R');
  ippiFilterRobertsUpBorder_16s_C1R:=getProc(hh,'ippiFilterRobertsUpBorder_16s_C1R');
  ippiFilterLaplaceBorder_8u_C1R:=getProc(hh,'ippiFilterLaplaceBorder_8u_C1R');
  ippiFilterLaplaceBorder_8u_C3R:=getProc(hh,'ippiFilterLaplaceBorder_8u_C3R');
  ippiFilterLaplaceBorder_8u_AC4R:=getProc(hh,'ippiFilterLaplaceBorder_8u_AC4R');
  ippiFilterLaplaceBorder_8u_C4R:=getProc(hh,'ippiFilterLaplaceBorder_8u_C4R');
  ippiFilterLaplaceBorder_16s_C1R:=getProc(hh,'ippiFilterLaplaceBorder_16s_C1R');
  ippiFilterLaplaceBorder_16s_C3R:=getProc(hh,'ippiFilterLaplaceBorder_16s_C3R');
  ippiFilterLaplaceBorder_16s_AC4R:=getProc(hh,'ippiFilterLaplaceBorder_16s_AC4R');
  ippiFilterLaplaceBorder_16s_C4R:=getProc(hh,'ippiFilterLaplaceBorder_16s_C4R');
  ippiFilterLaplaceBorder_32f_C1R:=getProc(hh,'ippiFilterLaplaceBorder_32f_C1R');
  ippiFilterLaplaceBorder_32f_C3R:=getProc(hh,'ippiFilterLaplaceBorder_32f_C3R');
  ippiFilterLaplaceBorder_32f_AC4R:=getProc(hh,'ippiFilterLaplaceBorder_32f_AC4R');
  ippiFilterLaplaceBorder_32f_C4R:=getProc(hh,'ippiFilterLaplaceBorder_32f_C4R');
  ippiFilterHipassBorder_8u_C1R:=getProc(hh,'ippiFilterHipassBorder_8u_C1R');
  ippiFilterHipassBorder_8u_C3R:=getProc(hh,'ippiFilterHipassBorder_8u_C3R');
  ippiFilterHipassBorder_8u_AC4R:=getProc(hh,'ippiFilterHipassBorder_8u_AC4R');
  ippiFilterHipassBorder_8u_C4R:=getProc(hh,'ippiFilterHipassBorder_8u_C4R');
  ippiFilterHipassBorder_16s_C1R:=getProc(hh,'ippiFilterHipassBorder_16s_C1R');
  ippiFilterHipassBorder_16s_C3R:=getProc(hh,'ippiFilterHipassBorder_16s_C3R');
  ippiFilterHipassBorder_16s_AC4R:=getProc(hh,'ippiFilterHipassBorder_16s_AC4R');
  ippiFilterHipassBorder_16s_C4R:=getProc(hh,'ippiFilterHipassBorder_16s_C4R');
  ippiFilterHipassBorder_32f_C1R:=getProc(hh,'ippiFilterHipassBorder_32f_C1R');
  ippiFilterHipassBorder_32f_C3R:=getProc(hh,'ippiFilterHipassBorder_32f_C3R');
  ippiFilterHipassBorder_32f_AC4R:=getProc(hh,'ippiFilterHipassBorder_32f_AC4R');
  ippiFilterHipassBorder_32f_C4R:=getProc(hh,'ippiFilterHipassBorder_32f_C4R');
  ippiFilterSharpenBorder_8u_C1R:=getProc(hh,'ippiFilterSharpenBorder_8u_C1R');
  ippiFilterSharpenBorder_8u_C3R:=getProc(hh,'ippiFilterSharpenBorder_8u_C3R');
  ippiFilterSharpenBorder_8u_AC4R:=getProc(hh,'ippiFilterSharpenBorder_8u_AC4R');
  ippiFilterSharpenBorder_8u_C4R:=getProc(hh,'ippiFilterSharpenBorder_8u_C4R');
  ippiFilterSharpenBorder_16s_C1R:=getProc(hh,'ippiFilterSharpenBorder_16s_C1R');
  ippiFilterSharpenBorder_16s_C3R:=getProc(hh,'ippiFilterSharpenBorder_16s_C3R');
  ippiFilterSharpenBorder_16s_AC4R:=getProc(hh,'ippiFilterSharpenBorder_16s_AC4R');
  ippiFilterSharpenBorder_16s_C4R:=getProc(hh,'ippiFilterSharpenBorder_16s_C4R');
  ippiFilterSharpenBorder_32f_C1R:=getProc(hh,'ippiFilterSharpenBorder_32f_C1R');
  ippiFilterSharpenBorder_32f_C3R:=getProc(hh,'ippiFilterSharpenBorder_32f_C3R');
  ippiFilterSharpenBorder_32f_AC4R:=getProc(hh,'ippiFilterSharpenBorder_32f_AC4R');
  ippiFilterSharpenBorder_32f_C4R:=getProc(hh,'ippiFilterSharpenBorder_32f_C4R');
  ippiFilterSobelGetBufferSize:=getProc(hh,'ippiFilterSobelGetBufferSize');
  ippiFilterSobel_8u16s_C1R:=getProc(hh,'ippiFilterSobel_8u16s_C1R');
  ippiFilterSobel_16s32f_C1R:=getProc(hh,'ippiFilterSobel_16s32f_C1R');
  ippiFilterSobel_16u32f_C1R:=getProc(hh,'ippiFilterSobel_16u32f_C1R');
  ippiFilterSobel_32f_C1R:=getProc(hh,'ippiFilterSobel_32f_C1R');
  ippiFilterWienerGetBufferSize:=getProc(hh,'ippiFilterWienerGetBufferSize');
  ippiFilterWiener_8u_C1R:=getProc(hh,'ippiFilterWiener_8u_C1R');
  ippiFilterWiener_8u_C3R:=getProc(hh,'ippiFilterWiener_8u_C3R');
  ippiFilterWiener_8u_AC4R:=getProc(hh,'ippiFilterWiener_8u_AC4R');
  ippiFilterWiener_8u_C4R:=getProc(hh,'ippiFilterWiener_8u_C4R');
  ippiFilterWiener_16s_C1R:=getProc(hh,'ippiFilterWiener_16s_C1R');
  ippiFilterWiener_16s_C3R:=getProc(hh,'ippiFilterWiener_16s_C3R');
  ippiFilterWiener_16s_AC4R:=getProc(hh,'ippiFilterWiener_16s_AC4R');
  ippiFilterWiener_16s_C4R:=getProc(hh,'ippiFilterWiener_16s_C4R');
  ippiFilterWiener_32f_C1R:=getProc(hh,'ippiFilterWiener_32f_C1R');
  ippiFilterWiener_32f_C3R:=getProc(hh,'ippiFilterWiener_32f_C3R');
  ippiFilterWiener_32f_AC4R:=getProc(hh,'ippiFilterWiener_32f_AC4R');
  ippiFilterWiener_32f_C4R:=getProc(hh,'ippiFilterWiener_32f_C4R');
  ippiConvGetBufferSize:=getProc(hh,'ippiConvGetBufferSize');
  ippiConv_32f_C1R:=getProc(hh,'ippiConv_32f_C1R');
  ippiConv_32f_C3R:=getProc(hh,'ippiConv_32f_C3R');
  ippiConv_32f_C4R:=getProc(hh,'ippiConv_32f_C4R');
  ippiConv_16s_C1R:=getProc(hh,'ippiConv_16s_C1R');
  ippiConv_16s_C3R:=getProc(hh,'ippiConv_16s_C3R');
  ippiConv_16s_C4R:=getProc(hh,'ippiConv_16s_C4R');
  ippiConv_8u_C1R:=getProc(hh,'ippiConv_8u_C1R');
  ippiConv_8u_C3R:=getProc(hh,'ippiConv_8u_C3R');
  ippiConv_8u_C4R:=getProc(hh,'ippiConv_8u_C4R');
  ippiCrossCorrNormGetBufferSize:=getProc(hh,'ippiCrossCorrNormGetBufferSize');
  ippiCrossCorrNorm_32f_C1R:=getProc(hh,'ippiCrossCorrNorm_32f_C1R');
  ippiCrossCorrNorm_16u32f_C1R:=getProc(hh,'ippiCrossCorrNorm_16u32f_C1R');
  ippiCrossCorrNorm_8u32f_C1R:=getProc(hh,'ippiCrossCorrNorm_8u32f_C1R');
  ippiCrossCorrNorm_8u_C1RSfs:=getProc(hh,'ippiCrossCorrNorm_8u_C1RSfs');
  ippiSqrDistanceNormGetBufferSize:=getProc(hh,'ippiSqrDistanceNormGetBufferSize');
  ippiSqrDistanceNorm_32f_C1R:=getProc(hh,'ippiSqrDistanceNorm_32f_C1R');
  ippiSqrDistanceNorm_16u32f_C1R:=getProc(hh,'ippiSqrDistanceNorm_16u32f_C1R');
  ippiSqrDistanceNorm_8u32f_C1R:=getProc(hh,'ippiSqrDistanceNorm_8u32f_C1R');
  ippiSqrDistanceNorm_8u_C1RSfs:=getProc(hh,'ippiSqrDistanceNorm_8u_C1RSfs');
  ippiThreshold_8u_C1R:=getProc(hh,'ippiThreshold_8u_C1R');
  ippiThreshold_16s_C1R:=getProc(hh,'ippiThreshold_16s_C1R');
  ippiThreshold_32f_C1R:=getProc(hh,'ippiThreshold_32f_C1R');
  ippiThreshold_8u_C3R:=getProc(hh,'ippiThreshold_8u_C3R');
  ippiThreshold_16s_C3R:=getProc(hh,'ippiThreshold_16s_C3R');
  ippiThreshold_32f_C3R:=getProc(hh,'ippiThreshold_32f_C3R');
  ippiThreshold_8u_AC4R:=getProc(hh,'ippiThreshold_8u_AC4R');
  ippiThreshold_16s_AC4R:=getProc(hh,'ippiThreshold_16s_AC4R');
  ippiThreshold_32f_AC4R:=getProc(hh,'ippiThreshold_32f_AC4R');
  ippiThreshold_8u_C1IR:=getProc(hh,'ippiThreshold_8u_C1IR');
  ippiThreshold_16s_C1IR:=getProc(hh,'ippiThreshold_16s_C1IR');
  ippiThreshold_32f_C1IR:=getProc(hh,'ippiThreshold_32f_C1IR');
  ippiThreshold_8u_C3IR:=getProc(hh,'ippiThreshold_8u_C3IR');
  ippiThreshold_16s_C3IR:=getProc(hh,'ippiThreshold_16s_C3IR');
  ippiThreshold_32f_C3IR:=getProc(hh,'ippiThreshold_32f_C3IR');
  ippiThreshold_8u_AC4IR:=getProc(hh,'ippiThreshold_8u_AC4IR');
  ippiThreshold_16s_AC4IR:=getProc(hh,'ippiThreshold_16s_AC4IR');
  ippiThreshold_32f_AC4IR:=getProc(hh,'ippiThreshold_32f_AC4IR');
  ippiThreshold_16u_C1R:=getProc(hh,'ippiThreshold_16u_C1R');
  ippiThreshold_16u_C3R:=getProc(hh,'ippiThreshold_16u_C3R');
  ippiThreshold_16u_AC4R:=getProc(hh,'ippiThreshold_16u_AC4R');
  ippiThreshold_16u_C1IR:=getProc(hh,'ippiThreshold_16u_C1IR');
  ippiThreshold_16u_C3IR:=getProc(hh,'ippiThreshold_16u_C3IR');
  ippiThreshold_16u_AC4IR:=getProc(hh,'ippiThreshold_16u_AC4IR');
  ippiThreshold_GT_8u_C1R:=getProc(hh,'ippiThreshold_GT_8u_C1R');
  ippiThreshold_GT_16s_C1R:=getProc(hh,'ippiThreshold_GT_16s_C1R');
  ippiThreshold_GT_32f_C1R:=getProc(hh,'ippiThreshold_GT_32f_C1R');
  ippiThreshold_GT_8u_C3R:=getProc(hh,'ippiThreshold_GT_8u_C3R');
  ippiThreshold_GT_16s_C3R:=getProc(hh,'ippiThreshold_GT_16s_C3R');
  ippiThreshold_GT_32f_C3R:=getProc(hh,'ippiThreshold_GT_32f_C3R');
  ippiThreshold_GT_8u_AC4R:=getProc(hh,'ippiThreshold_GT_8u_AC4R');
  ippiThreshold_GT_16s_AC4R:=getProc(hh,'ippiThreshold_GT_16s_AC4R');
  ippiThreshold_GT_32f_AC4R:=getProc(hh,'ippiThreshold_GT_32f_AC4R');
  ippiThreshold_GT_8u_C1IR:=getProc(hh,'ippiThreshold_GT_8u_C1IR');
  ippiThreshold_GT_16s_C1IR:=getProc(hh,'ippiThreshold_GT_16s_C1IR');
  ippiThreshold_GT_32f_C1IR:=getProc(hh,'ippiThreshold_GT_32f_C1IR');
  ippiThreshold_GT_8u_C3IR:=getProc(hh,'ippiThreshold_GT_8u_C3IR');
  ippiThreshold_GT_16s_C3IR:=getProc(hh,'ippiThreshold_GT_16s_C3IR');
  ippiThreshold_GT_32f_C3IR:=getProc(hh,'ippiThreshold_GT_32f_C3IR');
  ippiThreshold_GT_8u_AC4IR:=getProc(hh,'ippiThreshold_GT_8u_AC4IR');
  ippiThreshold_GT_16s_AC4IR:=getProc(hh,'ippiThreshold_GT_16s_AC4IR');
  ippiThreshold_GT_32f_AC4IR:=getProc(hh,'ippiThreshold_GT_32f_AC4IR');
  ippiThreshold_GT_16u_C1R:=getProc(hh,'ippiThreshold_GT_16u_C1R');
  ippiThreshold_GT_16u_C3R:=getProc(hh,'ippiThreshold_GT_16u_C3R');
  ippiThreshold_GT_16u_AC4R:=getProc(hh,'ippiThreshold_GT_16u_AC4R');
  ippiThreshold_GT_16u_C1IR:=getProc(hh,'ippiThreshold_GT_16u_C1IR');
  ippiThreshold_GT_16u_C3IR:=getProc(hh,'ippiThreshold_GT_16u_C3IR');
  ippiThreshold_GT_16u_AC4IR:=getProc(hh,'ippiThreshold_GT_16u_AC4IR');
  ippiThreshold_LT_8u_C1R:=getProc(hh,'ippiThreshold_LT_8u_C1R');
  ippiThreshold_LT_16s_C1R:=getProc(hh,'ippiThreshold_LT_16s_C1R');
  ippiThreshold_LT_32f_C1R:=getProc(hh,'ippiThreshold_LT_32f_C1R');
  ippiThreshold_LT_8u_C3R:=getProc(hh,'ippiThreshold_LT_8u_C3R');
  ippiThreshold_LT_16s_C3R:=getProc(hh,'ippiThreshold_LT_16s_C3R');
  ippiThreshold_LT_32f_C3R:=getProc(hh,'ippiThreshold_LT_32f_C3R');
  ippiThreshold_LT_8u_AC4R:=getProc(hh,'ippiThreshold_LT_8u_AC4R');
  ippiThreshold_LT_16s_AC4R:=getProc(hh,'ippiThreshold_LT_16s_AC4R');
  ippiThreshold_LT_32f_AC4R:=getProc(hh,'ippiThreshold_LT_32f_AC4R');
  ippiThreshold_LT_8u_C1IR:=getProc(hh,'ippiThreshold_LT_8u_C1IR');
  ippiThreshold_LT_16s_C1IR:=getProc(hh,'ippiThreshold_LT_16s_C1IR');
  ippiThreshold_LT_32f_C1IR:=getProc(hh,'ippiThreshold_LT_32f_C1IR');
  ippiThreshold_LT_8u_C3IR:=getProc(hh,'ippiThreshold_LT_8u_C3IR');
  ippiThreshold_LT_16s_C3IR:=getProc(hh,'ippiThreshold_LT_16s_C3IR');
  ippiThreshold_LT_32f_C3IR:=getProc(hh,'ippiThreshold_LT_32f_C3IR');
  ippiThreshold_LT_8u_AC4IR:=getProc(hh,'ippiThreshold_LT_8u_AC4IR');
  ippiThreshold_LT_16s_AC4IR:=getProc(hh,'ippiThreshold_LT_16s_AC4IR');
  ippiThreshold_LT_32f_AC4IR:=getProc(hh,'ippiThreshold_LT_32f_AC4IR');
  ippiThreshold_LT_16u_C1R:=getProc(hh,'ippiThreshold_LT_16u_C1R');
  ippiThreshold_LT_16u_C3R:=getProc(hh,'ippiThreshold_LT_16u_C3R');
  ippiThreshold_LT_16u_AC4R:=getProc(hh,'ippiThreshold_LT_16u_AC4R');
  ippiThreshold_LT_16u_C1IR:=getProc(hh,'ippiThreshold_LT_16u_C1IR');
  ippiThreshold_LT_16u_C3IR:=getProc(hh,'ippiThreshold_LT_16u_C3IR');
  ippiThreshold_LT_16u_AC4IR:=getProc(hh,'ippiThreshold_LT_16u_AC4IR');
  ippiThreshold_Val_8u_C1R:=getProc(hh,'ippiThreshold_Val_8u_C1R');
  ippiThreshold_Val_16s_C1R:=getProc(hh,'ippiThreshold_Val_16s_C1R');
  ippiThreshold_Val_32f_C1R:=getProc(hh,'ippiThreshold_Val_32f_C1R');
  ippiThreshold_Val_8u_C3R:=getProc(hh,'ippiThreshold_Val_8u_C3R');
  ippiThreshold_Val_16s_C3R:=getProc(hh,'ippiThreshold_Val_16s_C3R');
  ippiThreshold_Val_32f_C3R:=getProc(hh,'ippiThreshold_Val_32f_C3R');
  ippiThreshold_Val_8u_AC4R:=getProc(hh,'ippiThreshold_Val_8u_AC4R');
  ippiThreshold_Val_16s_AC4R:=getProc(hh,'ippiThreshold_Val_16s_AC4R');
  ippiThreshold_Val_32f_AC4R:=getProc(hh,'ippiThreshold_Val_32f_AC4R');
  ippiThreshold_Val_8u_C1IR:=getProc(hh,'ippiThreshold_Val_8u_C1IR');
  ippiThreshold_Val_16s_C1IR:=getProc(hh,'ippiThreshold_Val_16s_C1IR');
  ippiThreshold_Val_32f_C1IR:=getProc(hh,'ippiThreshold_Val_32f_C1IR');
  ippiThreshold_Val_8u_C3IR:=getProc(hh,'ippiThreshold_Val_8u_C3IR');
  ippiThreshold_Val_16s_C3IR:=getProc(hh,'ippiThreshold_Val_16s_C3IR');
  ippiThreshold_Val_32f_C3IR:=getProc(hh,'ippiThreshold_Val_32f_C3IR');
  ippiThreshold_Val_8u_AC4IR:=getProc(hh,'ippiThreshold_Val_8u_AC4IR');
  ippiThreshold_Val_16s_AC4IR:=getProc(hh,'ippiThreshold_Val_16s_AC4IR');
  ippiThreshold_Val_32f_AC4IR:=getProc(hh,'ippiThreshold_Val_32f_AC4IR');
  ippiThreshold_Val_16u_C1R:=getProc(hh,'ippiThreshold_Val_16u_C1R');
  ippiThreshold_Val_16u_C3R:=getProc(hh,'ippiThreshold_Val_16u_C3R');
  ippiThreshold_Val_16u_AC4R:=getProc(hh,'ippiThreshold_Val_16u_AC4R');
  ippiThreshold_Val_16u_C1IR:=getProc(hh,'ippiThreshold_Val_16u_C1IR');
  ippiThreshold_Val_16u_C3IR:=getProc(hh,'ippiThreshold_Val_16u_C3IR');
  ippiThreshold_Val_16u_AC4IR:=getProc(hh,'ippiThreshold_Val_16u_AC4IR');
  ippiThreshold_GTVal_8u_C1R:=getProc(hh,'ippiThreshold_GTVal_8u_C1R');
  ippiThreshold_GTVal_16s_C1R:=getProc(hh,'ippiThreshold_GTVal_16s_C1R');
  ippiThreshold_GTVal_32f_C1R:=getProc(hh,'ippiThreshold_GTVal_32f_C1R');
  ippiThreshold_GTVal_8u_C3R:=getProc(hh,'ippiThreshold_GTVal_8u_C3R');
  ippiThreshold_GTVal_16s_C3R:=getProc(hh,'ippiThreshold_GTVal_16s_C3R');
  ippiThreshold_GTVal_32f_C3R:=getProc(hh,'ippiThreshold_GTVal_32f_C3R');
  ippiThreshold_GTVal_8u_AC4R:=getProc(hh,'ippiThreshold_GTVal_8u_AC4R');
  ippiThreshold_GTVal_16s_AC4R:=getProc(hh,'ippiThreshold_GTVal_16s_AC4R');
  ippiThreshold_GTVal_32f_AC4R:=getProc(hh,'ippiThreshold_GTVal_32f_AC4R');
  ippiThreshold_GTVal_8u_C1IR:=getProc(hh,'ippiThreshold_GTVal_8u_C1IR');
  ippiThreshold_GTVal_16s_C1IR:=getProc(hh,'ippiThreshold_GTVal_16s_C1IR');
  ippiThreshold_GTVal_32f_C1IR:=getProc(hh,'ippiThreshold_GTVal_32f_C1IR');
  ippiThreshold_GTVal_8u_C3IR:=getProc(hh,'ippiThreshold_GTVal_8u_C3IR');
  ippiThreshold_GTVal_16s_C3IR:=getProc(hh,'ippiThreshold_GTVal_16s_C3IR');
  ippiThreshold_GTVal_32f_C3IR:=getProc(hh,'ippiThreshold_GTVal_32f_C3IR');
  ippiThreshold_GTVal_8u_AC4IR:=getProc(hh,'ippiThreshold_GTVal_8u_AC4IR');
  ippiThreshold_GTVal_16s_AC4IR:=getProc(hh,'ippiThreshold_GTVal_16s_AC4IR');
  ippiThreshold_GTVal_32f_AC4IR:=getProc(hh,'ippiThreshold_GTVal_32f_AC4IR');
  ippiThreshold_GTVal_8u_C4R:=getProc(hh,'ippiThreshold_GTVal_8u_C4R');
  ippiThreshold_GTVal_16s_C4R:=getProc(hh,'ippiThreshold_GTVal_16s_C4R');
  ippiThreshold_GTVal_32f_C4R:=getProc(hh,'ippiThreshold_GTVal_32f_C4R');
  ippiThreshold_GTVal_8u_C4IR:=getProc(hh,'ippiThreshold_GTVal_8u_C4IR');
  ippiThreshold_GTVal_16s_C4IR:=getProc(hh,'ippiThreshold_GTVal_16s_C4IR');
  ippiThreshold_GTVal_32f_C4IR:=getProc(hh,'ippiThreshold_GTVal_32f_C4IR');
  ippiThreshold_GTVal_16u_C1R:=getProc(hh,'ippiThreshold_GTVal_16u_C1R');
  ippiThreshold_GTVal_16u_C3R:=getProc(hh,'ippiThreshold_GTVal_16u_C3R');
  ippiThreshold_GTVal_16u_AC4R:=getProc(hh,'ippiThreshold_GTVal_16u_AC4R');
  ippiThreshold_GTVal_16u_C1IR:=getProc(hh,'ippiThreshold_GTVal_16u_C1IR');
  ippiThreshold_GTVal_16u_C3IR:=getProc(hh,'ippiThreshold_GTVal_16u_C3IR');
  ippiThreshold_GTVal_16u_AC4IR:=getProc(hh,'ippiThreshold_GTVal_16u_AC4IR');
  ippiThreshold_GTVal_16u_C4R:=getProc(hh,'ippiThreshold_GTVal_16u_C4R');
  ippiThreshold_GTVal_16u_C4IR:=getProc(hh,'ippiThreshold_GTVal_16u_C4IR');
  ippiThreshold_LTVal_8u_C1R:=getProc(hh,'ippiThreshold_LTVal_8u_C1R');
  ippiThreshold_LTVal_16s_C1R:=getProc(hh,'ippiThreshold_LTVal_16s_C1R');
  ippiThreshold_LTVal_32f_C1R:=getProc(hh,'ippiThreshold_LTVal_32f_C1R');
  ippiThreshold_LTVal_8u_C3R:=getProc(hh,'ippiThreshold_LTVal_8u_C3R');
  ippiThreshold_LTVal_16s_C3R:=getProc(hh,'ippiThreshold_LTVal_16s_C3R');
  ippiThreshold_LTVal_32f_C3R:=getProc(hh,'ippiThreshold_LTVal_32f_C3R');
  ippiThreshold_LTVal_8u_AC4R:=getProc(hh,'ippiThreshold_LTVal_8u_AC4R');
  ippiThreshold_LTVal_16s_AC4R:=getProc(hh,'ippiThreshold_LTVal_16s_AC4R');
  ippiThreshold_LTVal_32f_AC4R:=getProc(hh,'ippiThreshold_LTVal_32f_AC4R');
  ippiThreshold_LTVal_8u_C1IR:=getProc(hh,'ippiThreshold_LTVal_8u_C1IR');
  ippiThreshold_LTVal_16s_C1IR:=getProc(hh,'ippiThreshold_LTVal_16s_C1IR');
  ippiThreshold_LTVal_32f_C1IR:=getProc(hh,'ippiThreshold_LTVal_32f_C1IR');
  ippiThreshold_LTVal_8u_C3IR:=getProc(hh,'ippiThreshold_LTVal_8u_C3IR');
  ippiThreshold_LTVal_16s_C3IR:=getProc(hh,'ippiThreshold_LTVal_16s_C3IR');
  ippiThreshold_LTVal_32f_C3IR:=getProc(hh,'ippiThreshold_LTVal_32f_C3IR');
  ippiThreshold_LTVal_8u_AC4IR:=getProc(hh,'ippiThreshold_LTVal_8u_AC4IR');
  ippiThreshold_LTVal_16s_AC4IR:=getProc(hh,'ippiThreshold_LTVal_16s_AC4IR');
  ippiThreshold_LTVal_32f_AC4IR:=getProc(hh,'ippiThreshold_LTVal_32f_AC4IR');
  ippiThreshold_LTVal_8u_C4R:=getProc(hh,'ippiThreshold_LTVal_8u_C4R');
  ippiThreshold_LTVal_16s_C4R:=getProc(hh,'ippiThreshold_LTVal_16s_C4R');
  ippiThreshold_LTVal_32f_C4R:=getProc(hh,'ippiThreshold_LTVal_32f_C4R');
  ippiThreshold_LTVal_8u_C4IR:=getProc(hh,'ippiThreshold_LTVal_8u_C4IR');
  ippiThreshold_LTVal_16s_C4IR:=getProc(hh,'ippiThreshold_LTVal_16s_C4IR');
  ippiThreshold_LTVal_32f_C4IR:=getProc(hh,'ippiThreshold_LTVal_32f_C4IR');
  ippiThreshold_LTVal_16u_C1R:=getProc(hh,'ippiThreshold_LTVal_16u_C1R');
  ippiThreshold_LTVal_16u_C3R:=getProc(hh,'ippiThreshold_LTVal_16u_C3R');
  ippiThreshold_LTVal_16u_AC4R:=getProc(hh,'ippiThreshold_LTVal_16u_AC4R');
  ippiThreshold_LTVal_16u_C1IR:=getProc(hh,'ippiThreshold_LTVal_16u_C1IR');
  ippiThreshold_LTVal_16u_C3IR:=getProc(hh,'ippiThreshold_LTVal_16u_C3IR');
  ippiThreshold_LTVal_16u_AC4IR:=getProc(hh,'ippiThreshold_LTVal_16u_AC4IR');
  ippiThreshold_LTVal_16u_C4R:=getProc(hh,'ippiThreshold_LTVal_16u_C4R');
  ippiThreshold_LTVal_16u_C4IR:=getProc(hh,'ippiThreshold_LTVal_16u_C4IR');
  ippiThreshold_LTValGTVal_8u_C1R:=getProc(hh,'ippiThreshold_LTValGTVal_8u_C1R');
  ippiThreshold_LTValGTVal_16s_C1R:=getProc(hh,'ippiThreshold_LTValGTVal_16s_C1R');
  ippiThreshold_LTValGTVal_32f_C1R:=getProc(hh,'ippiThreshold_LTValGTVal_32f_C1R');
  ippiThreshold_LTValGTVal_8u_C3R:=getProc(hh,'ippiThreshold_LTValGTVal_8u_C3R');
  ippiThreshold_LTValGTVal_16s_C3R:=getProc(hh,'ippiThreshold_LTValGTVal_16s_C3R');
  ippiThreshold_LTValGTVal_32f_C3R:=getProc(hh,'ippiThreshold_LTValGTVal_32f_C3R');
  ippiThreshold_LTValGTVal_8u_AC4R:=getProc(hh,'ippiThreshold_LTValGTVal_8u_AC4R');
  ippiThreshold_LTValGTVal_16s_AC4R:=getProc(hh,'ippiThreshold_LTValGTVal_16s_AC4R');
  ippiThreshold_LTValGTVal_32f_AC4R:=getProc(hh,'ippiThreshold_LTValGTVal_32f_AC4R');
  ippiThreshold_LTValGTVal_8u_C1IR:=getProc(hh,'ippiThreshold_LTValGTVal_8u_C1IR');
  ippiThreshold_LTValGTVal_16s_C1IR:=getProc(hh,'ippiThreshold_LTValGTVal_16s_C1IR');
  ippiThreshold_LTValGTVal_32f_C1IR:=getProc(hh,'ippiThreshold_LTValGTVal_32f_C1IR');
  ippiThreshold_LTValGTVal_8u_C3IR:=getProc(hh,'ippiThreshold_LTValGTVal_8u_C3IR');
  ippiThreshold_LTValGTVal_16s_C3IR:=getProc(hh,'ippiThreshold_LTValGTVal_16s_C3IR');
  ippiThreshold_LTValGTVal_32f_C3IR:=getProc(hh,'ippiThreshold_LTValGTVal_32f_C3IR');
  ippiThreshold_LTValGTVal_8u_AC4IR:=getProc(hh,'ippiThreshold_LTValGTVal_8u_AC4IR');
  ippiThreshold_LTValGTVal_16s_AC4IR:=getProc(hh,'ippiThreshold_LTValGTVal_16s_AC4IR');
  ippiThreshold_LTValGTVal_32f_AC4IR:=getProc(hh,'ippiThreshold_LTValGTVal_32f_AC4IR');
  ippiThreshold_LTValGTVal_16u_C1R:=getProc(hh,'ippiThreshold_LTValGTVal_16u_C1R');
  ippiThreshold_LTValGTVal_16u_C3R:=getProc(hh,'ippiThreshold_LTValGTVal_16u_C3R');
  ippiThreshold_LTValGTVal_16u_AC4R:=getProc(hh,'ippiThreshold_LTValGTVal_16u_AC4R');
  ippiThreshold_LTValGTVal_16u_C1IR:=getProc(hh,'ippiThreshold_LTValGTVal_16u_C1IR');
  ippiThreshold_LTValGTVal_16u_C3IR:=getProc(hh,'ippiThreshold_LTValGTVal_16u_C3IR');
  ippiThreshold_LTValGTVal_16u_AC4IR:=getProc(hh,'ippiThreshold_LTValGTVal_16u_AC4IR');
  ippiComputeThreshold_Otsu_8u_C1R:=getProc(hh,'ippiComputeThreshold_Otsu_8u_C1R');
  ippiThresholdAdaptiveBoxGetBufferSize:=getProc(hh,'ippiThresholdAdaptiveBoxGetBufferSize');
  ippiThresholdAdaptiveGaussGetBufferSize:=getProc(hh,'ippiThresholdAdaptiveGaussGetBufferSize');
  ippiThresholdAdaptiveGaussInit:=getProc(hh,'ippiThresholdAdaptiveGaussInit');
  ippiThresholdAdaptiveBox_8u_C1R:=getProc(hh,'ippiThresholdAdaptiveBox_8u_C1R');
  ippiThresholdAdaptiveGauss_8u_C1R:=getProc(hh,'ippiThresholdAdaptiveGauss_8u_C1R');
  ippiThresholdAdaptiveBox_8u_C1IR:=getProc(hh,'ippiThresholdAdaptiveBox_8u_C1IR');
  ippiThresholdAdaptiveGauss_8u_C1IR:=getProc(hh,'ippiThresholdAdaptiveGauss_8u_C1IR');
  ippiCopyManaged_8u_C1R:=getProc(hh,'ippiCopyManaged_8u_C1R');
  ippiCopy_8u_C3C1R:=getProc(hh,'ippiCopy_8u_C3C1R');
  ippiCopy_8u_C1C3R:=getProc(hh,'ippiCopy_8u_C1C3R');
  ippiCopy_8u_C4C1R:=getProc(hh,'ippiCopy_8u_C4C1R');
  ippiCopy_8u_C1C4R:=getProc(hh,'ippiCopy_8u_C1C4R');
  ippiCopy_8u_C3CR:=getProc(hh,'ippiCopy_8u_C3CR');
  ippiCopy_8u_C4CR:=getProc(hh,'ippiCopy_8u_C4CR');
  ippiCopy_8u_AC4C3R:=getProc(hh,'ippiCopy_8u_AC4C3R');
  ippiCopy_8u_C3AC4R:=getProc(hh,'ippiCopy_8u_C3AC4R');
  ippiCopy_8u_C1R:=getProc(hh,'ippiCopy_8u_C1R');
  ippiCopy_8u_C3R:=getProc(hh,'ippiCopy_8u_C3R');
  ippiCopy_8u_C4R:=getProc(hh,'ippiCopy_8u_C4R');
  ippiCopy_8u_AC4R:=getProc(hh,'ippiCopy_8u_AC4R');
  ippiCopy_8u_C1MR:=getProc(hh,'ippiCopy_8u_C1MR');
  ippiCopy_8u_C3MR:=getProc(hh,'ippiCopy_8u_C3MR');
  ippiCopy_8u_C4MR:=getProc(hh,'ippiCopy_8u_C4MR');
  ippiCopy_8u_AC4MR:=getProc(hh,'ippiCopy_8u_AC4MR');
  ippiCopy_16s_C3C1R:=getProc(hh,'ippiCopy_16s_C3C1R');
  ippiCopy_16s_C1C3R:=getProc(hh,'ippiCopy_16s_C1C3R');
  ippiCopy_16s_C4C1R:=getProc(hh,'ippiCopy_16s_C4C1R');
  ippiCopy_16s_C1C4R:=getProc(hh,'ippiCopy_16s_C1C4R');
  ippiCopy_16s_C3CR:=getProc(hh,'ippiCopy_16s_C3CR');
  ippiCopy_16s_C4CR:=getProc(hh,'ippiCopy_16s_C4CR');
  ippiCopy_16s_AC4C3R:=getProc(hh,'ippiCopy_16s_AC4C3R');
  ippiCopy_16s_C3AC4R:=getProc(hh,'ippiCopy_16s_C3AC4R');
  ippiCopy_16s_C1R:=getProc(hh,'ippiCopy_16s_C1R');
  ippiCopy_16s_C3R:=getProc(hh,'ippiCopy_16s_C3R');
  ippiCopy_16s_C4R:=getProc(hh,'ippiCopy_16s_C4R');
  ippiCopy_16s_AC4R:=getProc(hh,'ippiCopy_16s_AC4R');
  ippiCopy_16s_C1MR:=getProc(hh,'ippiCopy_16s_C1MR');
  ippiCopy_16s_C3MR:=getProc(hh,'ippiCopy_16s_C3MR');
  ippiCopy_16s_C4MR:=getProc(hh,'ippiCopy_16s_C4MR');
  ippiCopy_16s_AC4MR:=getProc(hh,'ippiCopy_16s_AC4MR');
  ippiCopy_32f_C3C1R:=getProc(hh,'ippiCopy_32f_C3C1R');
  ippiCopy_32f_C1C3R:=getProc(hh,'ippiCopy_32f_C1C3R');
  ippiCopy_32f_C4C1R:=getProc(hh,'ippiCopy_32f_C4C1R');
  ippiCopy_32f_C1C4R:=getProc(hh,'ippiCopy_32f_C1C4R');
  ippiCopy_32f_C3CR:=getProc(hh,'ippiCopy_32f_C3CR');
  ippiCopy_32f_C4CR:=getProc(hh,'ippiCopy_32f_C4CR');
  ippiCopy_32f_AC4C3R:=getProc(hh,'ippiCopy_32f_AC4C3R');
  ippiCopy_32f_C3AC4R:=getProc(hh,'ippiCopy_32f_C3AC4R');
  ippiCopy_32f_C1R:=getProc(hh,'ippiCopy_32f_C1R');
  ippiCopy_32f_C3R:=getProc(hh,'ippiCopy_32f_C3R');
  ippiCopy_32f_C4R:=getProc(hh,'ippiCopy_32f_C4R');
  ippiCopy_32f_AC4R:=getProc(hh,'ippiCopy_32f_AC4R');
  ippiCopy_32f_C1MR:=getProc(hh,'ippiCopy_32f_C1MR');
  ippiCopy_32f_C3MR:=getProc(hh,'ippiCopy_32f_C3MR');
  ippiCopy_32f_C4MR:=getProc(hh,'ippiCopy_32f_C4MR');
  ippiCopy_32f_AC4MR:=getProc(hh,'ippiCopy_32f_AC4MR');
  ippiCopy_8u_C3P3R:=getProc(hh,'ippiCopy_8u_C3P3R');
  ippiCopy_8u_P3C3R:=getProc(hh,'ippiCopy_8u_P3C3R');
  ippiCopy_8u_C4P4R:=getProc(hh,'ippiCopy_8u_C4P4R');
  ippiCopy_8u_P4C4R:=getProc(hh,'ippiCopy_8u_P4C4R');
  ippiCopy_16s_C3P3R:=getProc(hh,'ippiCopy_16s_C3P3R');
  ippiCopy_16s_P3C3R:=getProc(hh,'ippiCopy_16s_P3C3R');
  ippiCopy_16s_C4P4R:=getProc(hh,'ippiCopy_16s_C4P4R');
  ippiCopy_16s_P4C4R:=getProc(hh,'ippiCopy_16s_P4C4R');
  ippiCopy_32f_C3P3R:=getProc(hh,'ippiCopy_32f_C3P3R');
  ippiCopy_32f_P3C3R:=getProc(hh,'ippiCopy_32f_P3C3R');
  ippiCopy_32f_C4P4R:=getProc(hh,'ippiCopy_32f_C4P4R');
  ippiCopy_32f_P4C4R:=getProc(hh,'ippiCopy_32f_P4C4R');
  ippiCopy_32s_C3C1R:=getProc(hh,'ippiCopy_32s_C3C1R');
  ippiCopy_32s_C1C3R:=getProc(hh,'ippiCopy_32s_C1C3R');
  ippiCopy_32s_C4C1R:=getProc(hh,'ippiCopy_32s_C4C1R');
  ippiCopy_32s_C1C4R:=getProc(hh,'ippiCopy_32s_C1C4R');
  ippiCopy_32s_C3CR:=getProc(hh,'ippiCopy_32s_C3CR');
  ippiCopy_32s_C4CR:=getProc(hh,'ippiCopy_32s_C4CR');
  ippiCopy_32s_AC4C3R:=getProc(hh,'ippiCopy_32s_AC4C3R');
  ippiCopy_32s_C3AC4R:=getProc(hh,'ippiCopy_32s_C3AC4R');
  ippiCopy_32s_C1R:=getProc(hh,'ippiCopy_32s_C1R');
  ippiCopy_32s_C3R:=getProc(hh,'ippiCopy_32s_C3R');
  ippiCopy_32s_C4R:=getProc(hh,'ippiCopy_32s_C4R');
  ippiCopy_32s_AC4R:=getProc(hh,'ippiCopy_32s_AC4R');
  ippiCopy_32s_C1MR:=getProc(hh,'ippiCopy_32s_C1MR');
  ippiCopy_32s_C3MR:=getProc(hh,'ippiCopy_32s_C3MR');
  ippiCopy_32s_C4MR:=getProc(hh,'ippiCopy_32s_C4MR');
  ippiCopy_32s_AC4MR:=getProc(hh,'ippiCopy_32s_AC4MR');
  ippiCopy_32s_C3P3R:=getProc(hh,'ippiCopy_32s_C3P3R');
  ippiCopy_32s_P3C3R:=getProc(hh,'ippiCopy_32s_P3C3R');
  ippiCopy_32s_C4P4R:=getProc(hh,'ippiCopy_32s_C4P4R');
  ippiCopy_32s_P4C4R:=getProc(hh,'ippiCopy_32s_P4C4R');
  ippiCopy_16u_C3C1R:=getProc(hh,'ippiCopy_16u_C3C1R');
  ippiCopy_16u_C1C3R:=getProc(hh,'ippiCopy_16u_C1C3R');
  ippiCopy_16u_C4C1R:=getProc(hh,'ippiCopy_16u_C4C1R');
  ippiCopy_16u_C1C4R:=getProc(hh,'ippiCopy_16u_C1C4R');
  ippiCopy_16u_C3CR:=getProc(hh,'ippiCopy_16u_C3CR');
  ippiCopy_16u_C4CR:=getProc(hh,'ippiCopy_16u_C4CR');
  ippiCopy_16u_AC4C3R:=getProc(hh,'ippiCopy_16u_AC4C3R');
  ippiCopy_16u_C3AC4R:=getProc(hh,'ippiCopy_16u_C3AC4R');
  ippiCopy_16u_C1R:=getProc(hh,'ippiCopy_16u_C1R');
  ippiCopy_16u_C3R:=getProc(hh,'ippiCopy_16u_C3R');
  ippiCopy_16u_C4R:=getProc(hh,'ippiCopy_16u_C4R');
  ippiCopy_16u_AC4R:=getProc(hh,'ippiCopy_16u_AC4R');
  ippiCopy_16u_C1MR:=getProc(hh,'ippiCopy_16u_C1MR');
  ippiCopy_16u_C3MR:=getProc(hh,'ippiCopy_16u_C3MR');
  ippiCopy_16u_C4MR:=getProc(hh,'ippiCopy_16u_C4MR');
  ippiCopy_16u_AC4MR:=getProc(hh,'ippiCopy_16u_AC4MR');
  ippiCopy_16u_C3P3R:=getProc(hh,'ippiCopy_16u_C3P3R');
  ippiCopy_16u_P3C3R:=getProc(hh,'ippiCopy_16u_P3C3R');
  ippiCopy_16u_C4P4R:=getProc(hh,'ippiCopy_16u_C4P4R');
  ippiCopy_16u_P4C4R:=getProc(hh,'ippiCopy_16u_P4C4R');
  ippiCopyReplicateBorder_8u_C1R:=getProc(hh,'ippiCopyReplicateBorder_8u_C1R');
  ippiCopyReplicateBorder_8u_C3R:=getProc(hh,'ippiCopyReplicateBorder_8u_C3R');
  ippiCopyReplicateBorder_8u_AC4R:=getProc(hh,'ippiCopyReplicateBorder_8u_AC4R');
  ippiCopyReplicateBorder_8u_C4R:=getProc(hh,'ippiCopyReplicateBorder_8u_C4R');
  ippiCopyReplicateBorder_16s_C1R:=getProc(hh,'ippiCopyReplicateBorder_16s_C1R');
  ippiCopyReplicateBorder_16s_C3R:=getProc(hh,'ippiCopyReplicateBorder_16s_C3R');
  ippiCopyReplicateBorder_16s_AC4R:=getProc(hh,'ippiCopyReplicateBorder_16s_AC4R');
  ippiCopyReplicateBorder_16s_C4R:=getProc(hh,'ippiCopyReplicateBorder_16s_C4R');
  ippiCopyReplicateBorder_32s_C1R:=getProc(hh,'ippiCopyReplicateBorder_32s_C1R');
  ippiCopyReplicateBorder_32s_C3R:=getProc(hh,'ippiCopyReplicateBorder_32s_C3R');
  ippiCopyReplicateBorder_32s_AC4R:=getProc(hh,'ippiCopyReplicateBorder_32s_AC4R');
  ippiCopyReplicateBorder_32s_C4R:=getProc(hh,'ippiCopyReplicateBorder_32s_C4R');
  ippiCopyReplicateBorder_8u_C1IR:=getProc(hh,'ippiCopyReplicateBorder_8u_C1IR');
  ippiCopyReplicateBorder_8u_C3IR:=getProc(hh,'ippiCopyReplicateBorder_8u_C3IR');
  ippiCopyReplicateBorder_8u_AC4IR:=getProc(hh,'ippiCopyReplicateBorder_8u_AC4IR');
  ippiCopyReplicateBorder_8u_C4IR:=getProc(hh,'ippiCopyReplicateBorder_8u_C4IR');
  ippiCopyReplicateBorder_16s_C1IR:=getProc(hh,'ippiCopyReplicateBorder_16s_C1IR');
  ippiCopyReplicateBorder_16s_C3IR:=getProc(hh,'ippiCopyReplicateBorder_16s_C3IR');
  ippiCopyReplicateBorder_16s_AC4IR:=getProc(hh,'ippiCopyReplicateBorder_16s_AC4IR');
  ippiCopyReplicateBorder_16s_C4IR:=getProc(hh,'ippiCopyReplicateBorder_16s_C4IR');
  ippiCopyReplicateBorder_32s_C1IR:=getProc(hh,'ippiCopyReplicateBorder_32s_C1IR');
  ippiCopyReplicateBorder_32s_C3IR:=getProc(hh,'ippiCopyReplicateBorder_32s_C3IR');
  ippiCopyReplicateBorder_32s_AC4IR:=getProc(hh,'ippiCopyReplicateBorder_32s_AC4IR');
  ippiCopyReplicateBorder_32s_C4IR:=getProc(hh,'ippiCopyReplicateBorder_32s_C4IR');
  ippiCopyReplicateBorder_16u_C1IR:=getProc(hh,'ippiCopyReplicateBorder_16u_C1IR');
  ippiCopyReplicateBorder_16u_C3IR:=getProc(hh,'ippiCopyReplicateBorder_16u_C3IR');
  ippiCopyReplicateBorder_16u_AC4IR:=getProc(hh,'ippiCopyReplicateBorder_16u_AC4IR');
  ippiCopyReplicateBorder_16u_C4IR:=getProc(hh,'ippiCopyReplicateBorder_16u_C4IR');
  ippiCopyReplicateBorder_16u_C1R:=getProc(hh,'ippiCopyReplicateBorder_16u_C1R');
  ippiCopyReplicateBorder_16u_C3R:=getProc(hh,'ippiCopyReplicateBorder_16u_C3R');
  ippiCopyReplicateBorder_16u_AC4R:=getProc(hh,'ippiCopyReplicateBorder_16u_AC4R');
  ippiCopyReplicateBorder_16u_C4R:=getProc(hh,'ippiCopyReplicateBorder_16u_C4R');
  ippiCopyReplicateBorder_32f_C1R:=getProc(hh,'ippiCopyReplicateBorder_32f_C1R');
  ippiCopyReplicateBorder_32f_C3R:=getProc(hh,'ippiCopyReplicateBorder_32f_C3R');
  ippiCopyReplicateBorder_32f_AC4R:=getProc(hh,'ippiCopyReplicateBorder_32f_AC4R');
  ippiCopyReplicateBorder_32f_C4R:=getProc(hh,'ippiCopyReplicateBorder_32f_C4R');
  ippiCopyReplicateBorder_32f_C1IR:=getProc(hh,'ippiCopyReplicateBorder_32f_C1IR');
  ippiCopyReplicateBorder_32f_C3IR:=getProc(hh,'ippiCopyReplicateBorder_32f_C3IR');
  ippiCopyReplicateBorder_32f_AC4IR:=getProc(hh,'ippiCopyReplicateBorder_32f_AC4IR');
  ippiCopyReplicateBorder_32f_C4IR:=getProc(hh,'ippiCopyReplicateBorder_32f_C4IR');
  ippiCopyConstBorder_8u_C1R:=getProc(hh,'ippiCopyConstBorder_8u_C1R');
  ippiCopyConstBorder_8u_C3R:=getProc(hh,'ippiCopyConstBorder_8u_C3R');
  ippiCopyConstBorder_8u_AC4R:=getProc(hh,'ippiCopyConstBorder_8u_AC4R');
  ippiCopyConstBorder_8u_C4R:=getProc(hh,'ippiCopyConstBorder_8u_C4R');
  ippiCopyConstBorder_16s_C1R:=getProc(hh,'ippiCopyConstBorder_16s_C1R');
  ippiCopyConstBorder_16s_C3R:=getProc(hh,'ippiCopyConstBorder_16s_C3R');
  ippiCopyConstBorder_16s_AC4R:=getProc(hh,'ippiCopyConstBorder_16s_AC4R');
  ippiCopyConstBorder_16s_C4R:=getProc(hh,'ippiCopyConstBorder_16s_C4R');
  ippiCopyConstBorder_32s_C1R:=getProc(hh,'ippiCopyConstBorder_32s_C1R');
  ippiCopyConstBorder_32s_C3R:=getProc(hh,'ippiCopyConstBorder_32s_C3R');
  ippiCopyConstBorder_32s_AC4R:=getProc(hh,'ippiCopyConstBorder_32s_AC4R');
  ippiCopyConstBorder_32s_C4R:=getProc(hh,'ippiCopyConstBorder_32s_C4R');
  ippiCopyConstBorder_16u_C1R:=getProc(hh,'ippiCopyConstBorder_16u_C1R');
  ippiCopyConstBorder_16u_C3R:=getProc(hh,'ippiCopyConstBorder_16u_C3R');
  ippiCopyConstBorder_16u_AC4R:=getProc(hh,'ippiCopyConstBorder_16u_AC4R');
  ippiCopyConstBorder_16u_C4R:=getProc(hh,'ippiCopyConstBorder_16u_C4R');
  ippiCopyConstBorder_32f_C1R:=getProc(hh,'ippiCopyConstBorder_32f_C1R');
  ippiCopyConstBorder_32f_C3R:=getProc(hh,'ippiCopyConstBorder_32f_C3R');
  ippiCopyConstBorder_32f_AC4R:=getProc(hh,'ippiCopyConstBorder_32f_AC4R');
  ippiCopyConstBorder_32f_C4R:=getProc(hh,'ippiCopyConstBorder_32f_C4R');
  ippiCopyMirrorBorder_8u_C1R:=getProc(hh,'ippiCopyMirrorBorder_8u_C1R');
  ippiCopyMirrorBorder_8u_C3R:=getProc(hh,'ippiCopyMirrorBorder_8u_C3R');
  ippiCopyMirrorBorder_8u_C4R:=getProc(hh,'ippiCopyMirrorBorder_8u_C4R');
  ippiCopyMirrorBorder_16s_C1R:=getProc(hh,'ippiCopyMirrorBorder_16s_C1R');
  ippiCopyMirrorBorder_16s_C3R:=getProc(hh,'ippiCopyMirrorBorder_16s_C3R');
  ippiCopyMirrorBorder_16s_C4R:=getProc(hh,'ippiCopyMirrorBorder_16s_C4R');
  ippiCopyMirrorBorder_32s_C1R:=getProc(hh,'ippiCopyMirrorBorder_32s_C1R');
  ippiCopyMirrorBorder_32s_C3R:=getProc(hh,'ippiCopyMirrorBorder_32s_C3R');
  ippiCopyMirrorBorder_32s_C4R:=getProc(hh,'ippiCopyMirrorBorder_32s_C4R');
  ippiCopyMirrorBorder_8u_C1IR:=getProc(hh,'ippiCopyMirrorBorder_8u_C1IR');
  ippiCopyMirrorBorder_8u_C3IR:=getProc(hh,'ippiCopyMirrorBorder_8u_C3IR');
  ippiCopyMirrorBorder_8u_C4IR:=getProc(hh,'ippiCopyMirrorBorder_8u_C4IR');
  ippiCopyMirrorBorder_16s_C1IR:=getProc(hh,'ippiCopyMirrorBorder_16s_C1IR');
  ippiCopyMirrorBorder_16s_C3IR:=getProc(hh,'ippiCopyMirrorBorder_16s_C3IR');
  ippiCopyMirrorBorder_16s_C4IR:=getProc(hh,'ippiCopyMirrorBorder_16s_C4IR');
  ippiCopyMirrorBorder_32s_C1IR:=getProc(hh,'ippiCopyMirrorBorder_32s_C1IR');
  ippiCopyMirrorBorder_32s_C3IR:=getProc(hh,'ippiCopyMirrorBorder_32s_C3IR');
  ippiCopyMirrorBorder_32s_C4IR:=getProc(hh,'ippiCopyMirrorBorder_32s_C4IR');
  ippiCopyMirrorBorder_16u_C1IR:=getProc(hh,'ippiCopyMirrorBorder_16u_C1IR');
  ippiCopyMirrorBorder_16u_C3IR:=getProc(hh,'ippiCopyMirrorBorder_16u_C3IR');
  ippiCopyMirrorBorder_16u_C4IR:=getProc(hh,'ippiCopyMirrorBorder_16u_C4IR');
  ippiCopyMirrorBorder_16u_C1R:=getProc(hh,'ippiCopyMirrorBorder_16u_C1R');
  ippiCopyMirrorBorder_16u_C3R:=getProc(hh,'ippiCopyMirrorBorder_16u_C3R');
  ippiCopyMirrorBorder_16u_C4R:=getProc(hh,'ippiCopyMirrorBorder_16u_C4R');
  ippiCopyMirrorBorder_32f_C1R:=getProc(hh,'ippiCopyMirrorBorder_32f_C1R');
  ippiCopyMirrorBorder_32f_C3R:=getProc(hh,'ippiCopyMirrorBorder_32f_C3R');
  ippiCopyMirrorBorder_32f_C4R:=getProc(hh,'ippiCopyMirrorBorder_32f_C4R');
  ippiCopyMirrorBorder_32f_C1IR:=getProc(hh,'ippiCopyMirrorBorder_32f_C1IR');
  ippiCopyMirrorBorder_32f_C3IR:=getProc(hh,'ippiCopyMirrorBorder_32f_C3IR');
  ippiCopyMirrorBorder_32f_C4IR:=getProc(hh,'ippiCopyMirrorBorder_32f_C4IR');
  ippiCopyWrapBorder_32s_C1R:=getProc(hh,'ippiCopyWrapBorder_32s_C1R');
  ippiCopyWrapBorder_32s_C1IR:=getProc(hh,'ippiCopyWrapBorder_32s_C1IR');
  ippiCopyWrapBorder_32f_C1R:=getProc(hh,'ippiCopyWrapBorder_32f_C1R');
  ippiCopyWrapBorder_32f_C1IR:=getProc(hh,'ippiCopyWrapBorder_32f_C1IR');
  ippiDup_8u_C1C3R:=getProc(hh,'ippiDup_8u_C1C3R');
  ippiDup_8u_C1C4R:=getProc(hh,'ippiDup_8u_C1C4R');
  ippiSet_8u_C1R:=getProc(hh,'ippiSet_8u_C1R');
  ippiSet_8u_C3CR:=getProc(hh,'ippiSet_8u_C3CR');
  ippiSet_8u_C4CR:=getProc(hh,'ippiSet_8u_C4CR');
  ippiSet_8u_C3R:=getProc(hh,'ippiSet_8u_C3R');
  ippiSet_8u_C4R:=getProc(hh,'ippiSet_8u_C4R');
  ippiSet_8u_AC4R:=getProc(hh,'ippiSet_8u_AC4R');
  ippiSet_8u_C1MR:=getProc(hh,'ippiSet_8u_C1MR');
  ippiSet_8u_C3MR:=getProc(hh,'ippiSet_8u_C3MR');
  ippiSet_8u_C4MR:=getProc(hh,'ippiSet_8u_C4MR');
  ippiSet_8u_AC4MR:=getProc(hh,'ippiSet_8u_AC4MR');
  ippiSet_16s_C1R:=getProc(hh,'ippiSet_16s_C1R');
  ippiSet_16s_C3CR:=getProc(hh,'ippiSet_16s_C3CR');
  ippiSet_16s_C4CR:=getProc(hh,'ippiSet_16s_C4CR');
  ippiSet_16s_C3R:=getProc(hh,'ippiSet_16s_C3R');
  ippiSet_16s_C4R:=getProc(hh,'ippiSet_16s_C4R');
  ippiSet_16s_AC4R:=getProc(hh,'ippiSet_16s_AC4R');
  ippiSet_16s_C1MR:=getProc(hh,'ippiSet_16s_C1MR');
  ippiSet_16s_C3MR:=getProc(hh,'ippiSet_16s_C3MR');
  ippiSet_16s_C4MR:=getProc(hh,'ippiSet_16s_C4MR');
  ippiSet_16s_AC4MR:=getProc(hh,'ippiSet_16s_AC4MR');
  ippiSet_32f_C1R:=getProc(hh,'ippiSet_32f_C1R');
  ippiSet_32f_C3CR:=getProc(hh,'ippiSet_32f_C3CR');
  ippiSet_32f_C4CR:=getProc(hh,'ippiSet_32f_C4CR');
  ippiSet_32f_C3R:=getProc(hh,'ippiSet_32f_C3R');
  ippiSet_32f_C4R:=getProc(hh,'ippiSet_32f_C4R');
  ippiSet_32f_AC4R:=getProc(hh,'ippiSet_32f_AC4R');
  ippiSet_32f_C1MR:=getProc(hh,'ippiSet_32f_C1MR');
  ippiSet_32f_C3MR:=getProc(hh,'ippiSet_32f_C3MR');
  ippiSet_32f_C4MR:=getProc(hh,'ippiSet_32f_C4MR');
  ippiSet_32f_AC4MR:=getProc(hh,'ippiSet_32f_AC4MR');
  ippiSet_32s_C1R:=getProc(hh,'ippiSet_32s_C1R');
  ippiSet_32s_C3CR:=getProc(hh,'ippiSet_32s_C3CR');
  ippiSet_32s_C4CR:=getProc(hh,'ippiSet_32s_C4CR');
  ippiSet_32s_C3R:=getProc(hh,'ippiSet_32s_C3R');
  ippiSet_32s_C4R:=getProc(hh,'ippiSet_32s_C4R');
  ippiSet_32s_AC4R:=getProc(hh,'ippiSet_32s_AC4R');
  ippiSet_32s_C1MR:=getProc(hh,'ippiSet_32s_C1MR');
  ippiSet_32s_C3MR:=getProc(hh,'ippiSet_32s_C3MR');
  ippiSet_32s_C4MR:=getProc(hh,'ippiSet_32s_C4MR');
  ippiSet_32s_AC4MR:=getProc(hh,'ippiSet_32s_AC4MR');
  ippiSet_16u_C1R:=getProc(hh,'ippiSet_16u_C1R');
  ippiSet_16u_C3CR:=getProc(hh,'ippiSet_16u_C3CR');
  ippiSet_16u_C4CR:=getProc(hh,'ippiSet_16u_C4CR');
  ippiSet_16u_C3R:=getProc(hh,'ippiSet_16u_C3R');
  ippiSet_16u_C4R:=getProc(hh,'ippiSet_16u_C4R');
  ippiSet_16u_AC4R:=getProc(hh,'ippiSet_16u_AC4R');
  ippiSet_16u_C1MR:=getProc(hh,'ippiSet_16u_C1MR');
  ippiSet_16u_C3MR:=getProc(hh,'ippiSet_16u_C3MR');
  ippiSet_16u_C4MR:=getProc(hh,'ippiSet_16u_C4MR');
  ippiSet_16u_AC4MR:=getProc(hh,'ippiSet_16u_AC4MR');
  ippiAddRandUniform_8u_C1IR:=getProc(hh,'ippiAddRandUniform_8u_C1IR');
  ippiAddRandUniform_8u_C3IR:=getProc(hh,'ippiAddRandUniform_8u_C3IR');
  ippiAddRandUniform_8u_C4IR:=getProc(hh,'ippiAddRandUniform_8u_C4IR');
  ippiAddRandUniform_8u_AC4IR:=getProc(hh,'ippiAddRandUniform_8u_AC4IR');
  ippiAddRandUniform_16s_C1IR:=getProc(hh,'ippiAddRandUniform_16s_C1IR');
  ippiAddRandUniform_16s_C3IR:=getProc(hh,'ippiAddRandUniform_16s_C3IR');
  ippiAddRandUniform_16s_C4IR:=getProc(hh,'ippiAddRandUniform_16s_C4IR');
  ippiAddRandUniform_16s_AC4IR:=getProc(hh,'ippiAddRandUniform_16s_AC4IR');
  ippiAddRandUniform_32f_C1IR:=getProc(hh,'ippiAddRandUniform_32f_C1IR');
  ippiAddRandUniform_32f_C3IR:=getProc(hh,'ippiAddRandUniform_32f_C3IR');
  ippiAddRandUniform_32f_C4IR:=getProc(hh,'ippiAddRandUniform_32f_C4IR');
  ippiAddRandUniform_32f_AC4IR:=getProc(hh,'ippiAddRandUniform_32f_AC4IR');
  ippiAddRandUniform_16u_C1IR:=getProc(hh,'ippiAddRandUniform_16u_C1IR');
  ippiAddRandUniform_16u_C3IR:=getProc(hh,'ippiAddRandUniform_16u_C3IR');
  ippiAddRandUniform_16u_C4IR:=getProc(hh,'ippiAddRandUniform_16u_C4IR');
  ippiAddRandUniform_16u_AC4IR:=getProc(hh,'ippiAddRandUniform_16u_AC4IR');
  ippiAddRandGauss_8u_C1IR:=getProc(hh,'ippiAddRandGauss_8u_C1IR');
  ippiAddRandGauss_8u_C3IR:=getProc(hh,'ippiAddRandGauss_8u_C3IR');
  ippiAddRandGauss_8u_C4IR:=getProc(hh,'ippiAddRandGauss_8u_C4IR');
  ippiAddRandGauss_8u_AC4IR:=getProc(hh,'ippiAddRandGauss_8u_AC4IR');
  ippiAddRandGauss_16s_C1IR:=getProc(hh,'ippiAddRandGauss_16s_C1IR');
  ippiAddRandGauss_16s_C3IR:=getProc(hh,'ippiAddRandGauss_16s_C3IR');
  ippiAddRandGauss_16s_C4IR:=getProc(hh,'ippiAddRandGauss_16s_C4IR');
  ippiAddRandGauss_16s_AC4IR:=getProc(hh,'ippiAddRandGauss_16s_AC4IR');
  ippiAddRandGauss_32f_C1IR:=getProc(hh,'ippiAddRandGauss_32f_C1IR');
  ippiAddRandGauss_32f_C3IR:=getProc(hh,'ippiAddRandGauss_32f_C3IR');
  ippiAddRandGauss_32f_C4IR:=getProc(hh,'ippiAddRandGauss_32f_C4IR');
  ippiAddRandGauss_32f_AC4IR:=getProc(hh,'ippiAddRandGauss_32f_AC4IR');
  ippiAddRandGauss_16u_C1IR:=getProc(hh,'ippiAddRandGauss_16u_C1IR');
  ippiAddRandGauss_16u_C3IR:=getProc(hh,'ippiAddRandGauss_16u_C3IR');
  ippiAddRandGauss_16u_C4IR:=getProc(hh,'ippiAddRandGauss_16u_C4IR');
  ippiAddRandGauss_16u_AC4IR:=getProc(hh,'ippiAddRandGauss_16u_AC4IR');
  ippiImageJaehne_8u_C1R:=getProc(hh,'ippiImageJaehne_8u_C1R');
  ippiImageJaehne_8u_C3R:=getProc(hh,'ippiImageJaehne_8u_C3R');
  ippiImageJaehne_8u_C4R:=getProc(hh,'ippiImageJaehne_8u_C4R');
  ippiImageJaehne_8u_AC4R:=getProc(hh,'ippiImageJaehne_8u_AC4R');
  ippiImageJaehne_16u_C1R:=getProc(hh,'ippiImageJaehne_16u_C1R');
  ippiImageJaehne_16u_C3R:=getProc(hh,'ippiImageJaehne_16u_C3R');
  ippiImageJaehne_16u_C4R:=getProc(hh,'ippiImageJaehne_16u_C4R');
  ippiImageJaehne_16u_AC4R:=getProc(hh,'ippiImageJaehne_16u_AC4R');
  ippiImageJaehne_16s_C1R:=getProc(hh,'ippiImageJaehne_16s_C1R');
  ippiImageJaehne_16s_C3R:=getProc(hh,'ippiImageJaehne_16s_C3R');
  ippiImageJaehne_16s_C4R:=getProc(hh,'ippiImageJaehne_16s_C4R');
  ippiImageJaehne_16s_AC4R:=getProc(hh,'ippiImageJaehne_16s_AC4R');
  ippiImageJaehne_32f_C1R:=getProc(hh,'ippiImageJaehne_32f_C1R');
  ippiImageJaehne_32f_C3R:=getProc(hh,'ippiImageJaehne_32f_C3R');
  ippiImageJaehne_32f_C4R:=getProc(hh,'ippiImageJaehne_32f_C4R');
  ippiImageJaehne_32f_AC4R:=getProc(hh,'ippiImageJaehne_32f_AC4R');
  ippiImageRamp_8u_C1R:=getProc(hh,'ippiImageRamp_8u_C1R');
  ippiImageRamp_8u_C3R:=getProc(hh,'ippiImageRamp_8u_C3R');
  ippiImageRamp_8u_C4R:=getProc(hh,'ippiImageRamp_8u_C4R');
  ippiImageRamp_8u_AC4R:=getProc(hh,'ippiImageRamp_8u_AC4R');
  ippiImageRamp_16u_C1R:=getProc(hh,'ippiImageRamp_16u_C1R');
  ippiImageRamp_16u_C3R:=getProc(hh,'ippiImageRamp_16u_C3R');
  ippiImageRamp_16u_C4R:=getProc(hh,'ippiImageRamp_16u_C4R');
  ippiImageRamp_16u_AC4R:=getProc(hh,'ippiImageRamp_16u_AC4R');
  ippiImageRamp_16s_C1R:=getProc(hh,'ippiImageRamp_16s_C1R');
  ippiImageRamp_16s_C3R:=getProc(hh,'ippiImageRamp_16s_C3R');
  ippiImageRamp_16s_C4R:=getProc(hh,'ippiImageRamp_16s_C4R');
  ippiImageRamp_16s_AC4R:=getProc(hh,'ippiImageRamp_16s_AC4R');
  ippiImageRamp_32f_C1R:=getProc(hh,'ippiImageRamp_32f_C1R');
  ippiImageRamp_32f_C3R:=getProc(hh,'ippiImageRamp_32f_C3R');
  ippiImageRamp_32f_C4R:=getProc(hh,'ippiImageRamp_32f_C4R');
  ippiImageRamp_32f_AC4R:=getProc(hh,'ippiImageRamp_32f_AC4R');
  ippiConvert_8u8s_C1RSfs:=getProc(hh,'ippiConvert_8u8s_C1RSfs');
  ippiConvert_8u16u_C1R:=getProc(hh,'ippiConvert_8u16u_C1R');
  ippiConvert_8u16u_C3R:=getProc(hh,'ippiConvert_8u16u_C3R');
  ippiConvert_8u16u_AC4R:=getProc(hh,'ippiConvert_8u16u_AC4R');
  ippiConvert_8u16u_C4R:=getProc(hh,'ippiConvert_8u16u_C4R');
  ippiConvert_8u16s_C1R:=getProc(hh,'ippiConvert_8u16s_C1R');
  ippiConvert_8u16s_C3R:=getProc(hh,'ippiConvert_8u16s_C3R');
  ippiConvert_8u16s_AC4R:=getProc(hh,'ippiConvert_8u16s_AC4R');
  ippiConvert_8u16s_C4R:=getProc(hh,'ippiConvert_8u16s_C4R');
  ippiConvert_8u32s_C1R:=getProc(hh,'ippiConvert_8u32s_C1R');
  ippiConvert_8u32s_C3R:=getProc(hh,'ippiConvert_8u32s_C3R');
  ippiConvert_8u32s_AC4R:=getProc(hh,'ippiConvert_8u32s_AC4R');
  ippiConvert_8u32s_C4R:=getProc(hh,'ippiConvert_8u32s_C4R');
  ippiConvert_8u32f_C1R:=getProc(hh,'ippiConvert_8u32f_C1R');
  ippiConvert_8u32f_C3R:=getProc(hh,'ippiConvert_8u32f_C3R');
  ippiConvert_8u32f_AC4R:=getProc(hh,'ippiConvert_8u32f_AC4R');
end;

procedure InitIppi3;
begin
  ippiConvert_8u32f_C4R:=getProc(hh,'ippiConvert_8u32f_C4R');
  ippiConvert_8s8u_C1Rs:=getProc(hh,'ippiConvert_8s8u_C1Rs');
  ippiConvert_8s16s_C1R:=getProc(hh,'ippiConvert_8s16s_C1R');
  ippiConvert_8s16u_C1Rs:=getProc(hh,'ippiConvert_8s16u_C1Rs');
  ippiConvert_8s32u_C1Rs:=getProc(hh,'ippiConvert_8s32u_C1Rs');
  ippiConvert_8s32s_C1R:=getProc(hh,'ippiConvert_8s32s_C1R');
  ippiConvert_8s32s_C3R:=getProc(hh,'ippiConvert_8s32s_C3R');
  ippiConvert_8s32s_AC4R:=getProc(hh,'ippiConvert_8s32s_AC4R');
  ippiConvert_8s32s_C4R:=getProc(hh,'ippiConvert_8s32s_C4R');
  ippiConvert_8s32f_C1R:=getProc(hh,'ippiConvert_8s32f_C1R');
  ippiConvert_8s32f_C3R:=getProc(hh,'ippiConvert_8s32f_C3R');
  ippiConvert_8s32f_AC4R:=getProc(hh,'ippiConvert_8s32f_AC4R');
  ippiConvert_8s32f_C4R:=getProc(hh,'ippiConvert_8s32f_C4R');
  ippiConvert_16u8u_C1R:=getProc(hh,'ippiConvert_16u8u_C1R');
  ippiConvert_16u8u_C3R:=getProc(hh,'ippiConvert_16u8u_C3R');
  ippiConvert_16u8u_AC4R:=getProc(hh,'ippiConvert_16u8u_AC4R');
  ippiConvert_16u8u_C4R:=getProc(hh,'ippiConvert_16u8u_C4R');
  ippiConvert_16u8s_C1RSfs:=getProc(hh,'ippiConvert_16u8s_C1RSfs');
  ippiConvert_16u16s_C1RSfs:=getProc(hh,'ippiConvert_16u16s_C1RSfs');
  ippiConvert_16u32u_C1R:=getProc(hh,'ippiConvert_16u32u_C1R');
  ippiConvert_16u32s_C1R:=getProc(hh,'ippiConvert_16u32s_C1R');
  ippiConvert_16u32s_C3R:=getProc(hh,'ippiConvert_16u32s_C3R');
  ippiConvert_16u32s_AC4R:=getProc(hh,'ippiConvert_16u32s_AC4R');
  ippiConvert_16u32s_C4R:=getProc(hh,'ippiConvert_16u32s_C4R');
  ippiConvert_16u32f_C1R:=getProc(hh,'ippiConvert_16u32f_C1R');
  ippiConvert_16u32f_C3R:=getProc(hh,'ippiConvert_16u32f_C3R');
  ippiConvert_16u32f_AC4R:=getProc(hh,'ippiConvert_16u32f_AC4R');
  ippiConvert_16u32f_C4R:=getProc(hh,'ippiConvert_16u32f_C4R');
  ippiConvert_16s8s_C1RSfs:=getProc(hh,'ippiConvert_16s8s_C1RSfs');
  ippiConvert_16s8u_C1R:=getProc(hh,'ippiConvert_16s8u_C1R');
  ippiConvert_16s8u_C3R:=getProc(hh,'ippiConvert_16s8u_C3R');
  ippiConvert_16s8u_AC4R:=getProc(hh,'ippiConvert_16s8u_AC4R');
  ippiConvert_16s8u_C4R:=getProc(hh,'ippiConvert_16s8u_C4R');
  ippiConvert_16s16u_C1Rs:=getProc(hh,'ippiConvert_16s16u_C1Rs');
  ippiConvert_16s32u_C1Rs:=getProc(hh,'ippiConvert_16s32u_C1Rs');
  ippiConvert_16s32s_C1R:=getProc(hh,'ippiConvert_16s32s_C1R');
  ippiConvert_16s32s_C3R:=getProc(hh,'ippiConvert_16s32s_C3R');
  ippiConvert_16s32s_AC4R:=getProc(hh,'ippiConvert_16s32s_AC4R');
  ippiConvert_16s32s_C4R:=getProc(hh,'ippiConvert_16s32s_C4R');
  ippiConvert_16s32f_C1R:=getProc(hh,'ippiConvert_16s32f_C1R');
  ippiConvert_16s32f_C3R:=getProc(hh,'ippiConvert_16s32f_C3R');
  ippiConvert_16s32f_AC4R:=getProc(hh,'ippiConvert_16s32f_AC4R');
  ippiConvert_16s32f_C4R:=getProc(hh,'ippiConvert_16s32f_C4R');
  ippiConvert_32u8u_C1RSfs:=getProc(hh,'ippiConvert_32u8u_C1RSfs');
  ippiConvert_32u8s_C1RSfs:=getProc(hh,'ippiConvert_32u8s_C1RSfs');
  ippiConvert_32u16u_C1RSfs:=getProc(hh,'ippiConvert_32u16u_C1RSfs');
  ippiConvert_32u16s_C1RSfs:=getProc(hh,'ippiConvert_32u16s_C1RSfs');
  ippiConvert_32u32s_C1RSfs:=getProc(hh,'ippiConvert_32u32s_C1RSfs');
  ippiConvert_32u32f_C1R:=getProc(hh,'ippiConvert_32u32f_C1R');
  ippiConvert_32s8u_C1R:=getProc(hh,'ippiConvert_32s8u_C1R');
  ippiConvert_32s8u_C3R:=getProc(hh,'ippiConvert_32s8u_C3R');
  ippiConvert_32s8u_AC4R:=getProc(hh,'ippiConvert_32s8u_AC4R');
  ippiConvert_32s8u_C4R:=getProc(hh,'ippiConvert_32s8u_C4R');
  ippiConvert_32s8s_C1R:=getProc(hh,'ippiConvert_32s8s_C1R');
  ippiConvert_32s8s_C3R:=getProc(hh,'ippiConvert_32s8s_C3R');
  ippiConvert_32s8s_AC4R:=getProc(hh,'ippiConvert_32s8s_AC4R');
  ippiConvert_32s8s_C4R:=getProc(hh,'ippiConvert_32s8s_C4R');
  ippiConvert_32s16u_C1RSfs:=getProc(hh,'ippiConvert_32s16u_C1RSfs');
  ippiConvert_32s16s_C1RSfs:=getProc(hh,'ippiConvert_32s16s_C1RSfs');
  ippiConvert_32s32u_C1Rs:=getProc(hh,'ippiConvert_32s32u_C1Rs');
  ippiConvert_32s32f_C1R:=getProc(hh,'ippiConvert_32s32f_C1R');
  ippiConvert_32f8u_C1RSfs:=getProc(hh,'ippiConvert_32f8u_C1RSfs');
  ippiConvert_32f8u_C1R:=getProc(hh,'ippiConvert_32f8u_C1R');
  ippiConvert_32f8u_C3R:=getProc(hh,'ippiConvert_32f8u_C3R');
  ippiConvert_32f8u_AC4R:=getProc(hh,'ippiConvert_32f8u_AC4R');
  ippiConvert_32f8u_C4R:=getProc(hh,'ippiConvert_32f8u_C4R');
  ippiConvert_32f8s_C1RSfs:=getProc(hh,'ippiConvert_32f8s_C1RSfs');
  ippiConvert_32f8s_C1R:=getProc(hh,'ippiConvert_32f8s_C1R');
  ippiConvert_32f8s_C3R:=getProc(hh,'ippiConvert_32f8s_C3R');
  ippiConvert_32f8s_AC4R:=getProc(hh,'ippiConvert_32f8s_AC4R');
  ippiConvert_32f8s_C4R:=getProc(hh,'ippiConvert_32f8s_C4R');
  ippiConvert_32f16u_C1RSfs:=getProc(hh,'ippiConvert_32f16u_C1RSfs');
  ippiConvert_32f16u_C1R:=getProc(hh,'ippiConvert_32f16u_C1R');
  ippiConvert_32f16u_C3R:=getProc(hh,'ippiConvert_32f16u_C3R');
  ippiConvert_32f16u_AC4R:=getProc(hh,'ippiConvert_32f16u_AC4R');
  ippiConvert_32f16u_C4R:=getProc(hh,'ippiConvert_32f16u_C4R');
  ippiConvert_32f16s_C1RSfs:=getProc(hh,'ippiConvert_32f16s_C1RSfs');
  ippiConvert_32f16s_C1R:=getProc(hh,'ippiConvert_32f16s_C1R');
  ippiConvert_32f16s_C3R:=getProc(hh,'ippiConvert_32f16s_C3R');
  ippiConvert_32f16s_AC4R:=getProc(hh,'ippiConvert_32f16s_AC4R');
  ippiConvert_32f16s_C4R:=getProc(hh,'ippiConvert_32f16s_C4R');
  ippiConvert_32f32u_C1RSfs:=getProc(hh,'ippiConvert_32f32u_C1RSfs');
  ippiConvert_32f32u_C1IRSfs:=getProc(hh,'ippiConvert_32f32u_C1IRSfs');
  ippiConvert_32f32s_C1RSfs:=getProc(hh,'ippiConvert_32f32s_C1RSfs');
  ippiConvert_64f8u_C1RSfs:=getProc(hh,'ippiConvert_64f8u_C1RSfs');
  ippiConvert_64f8s_C1RSfs:=getProc(hh,'ippiConvert_64f8s_C1RSfs');
  ippiConvert_64f16u_C1RSfs:=getProc(hh,'ippiConvert_64f16u_C1RSfs');
  ippiConvert_64f16s_C1RSfs:=getProc(hh,'ippiConvert_64f16s_C1RSfs');
  ippiConvert_8s64f_C1R:=getProc(hh,'ippiConvert_8s64f_C1R');
  ippiScaleC_8u_C1R:=getProc(hh,'ippiScaleC_8u_C1R');
  ippiScaleC_8u8s_C1R:=getProc(hh,'ippiScaleC_8u8s_C1R');
  ippiScaleC_8u16u_C1R:=getProc(hh,'ippiScaleC_8u16u_C1R');
  ippiScaleC_8u16s_C1R:=getProc(hh,'ippiScaleC_8u16s_C1R');
  ippiScaleC_8u32s_C1R:=getProc(hh,'ippiScaleC_8u32s_C1R');
  ippiScaleC_8u32f_C1R:=getProc(hh,'ippiScaleC_8u32f_C1R');
  ippiScaleC_8u64f_C1R:=getProc(hh,'ippiScaleC_8u64f_C1R');
  ippiScaleC_8s8u_C1R:=getProc(hh,'ippiScaleC_8s8u_C1R');
  ippiScaleC_8s_C1R:=getProc(hh,'ippiScaleC_8s_C1R');
  ippiScaleC_8s16u_C1R:=getProc(hh,'ippiScaleC_8s16u_C1R');
  ippiScaleC_8s16s_C1R:=getProc(hh,'ippiScaleC_8s16s_C1R');
  ippiScaleC_8s32s_C1R:=getProc(hh,'ippiScaleC_8s32s_C1R');
  ippiScaleC_8s32f_C1R:=getProc(hh,'ippiScaleC_8s32f_C1R');
  ippiScaleC_8s64f_C1R:=getProc(hh,'ippiScaleC_8s64f_C1R');
  ippiScaleC_16u8u_C1R:=getProc(hh,'ippiScaleC_16u8u_C1R');
  ippiScaleC_16u8s_C1R:=getProc(hh,'ippiScaleC_16u8s_C1R');
  ippiScaleC_16u_C1R:=getProc(hh,'ippiScaleC_16u_C1R');
  ippiScaleC_16u16s_C1R:=getProc(hh,'ippiScaleC_16u16s_C1R');
  ippiScaleC_16u32s_C1R:=getProc(hh,'ippiScaleC_16u32s_C1R');
  ippiScaleC_16u32f_C1R:=getProc(hh,'ippiScaleC_16u32f_C1R');
  ippiScaleC_16u64f_C1R:=getProc(hh,'ippiScaleC_16u64f_C1R');
  ippiScaleC_16s8u_C1R:=getProc(hh,'ippiScaleC_16s8u_C1R');
  ippiScaleC_16s8s_C1R:=getProc(hh,'ippiScaleC_16s8s_C1R');
  ippiScaleC_16s16u_C1R:=getProc(hh,'ippiScaleC_16s16u_C1R');
  ippiScaleC_16s_C1R:=getProc(hh,'ippiScaleC_16s_C1R');
  ippiScaleC_16s32s_C1R:=getProc(hh,'ippiScaleC_16s32s_C1R');
  ippiScaleC_16s32f_C1R:=getProc(hh,'ippiScaleC_16s32f_C1R');
  ippiScaleC_16s64f_C1R:=getProc(hh,'ippiScaleC_16s64f_C1R');
  ippiScaleC_32s8u_C1R:=getProc(hh,'ippiScaleC_32s8u_C1R');
  ippiScaleC_32s8s_C1R:=getProc(hh,'ippiScaleC_32s8s_C1R');
  ippiScaleC_32s16u_C1R:=getProc(hh,'ippiScaleC_32s16u_C1R');
  ippiScaleC_32s16s_C1R:=getProc(hh,'ippiScaleC_32s16s_C1R');
  ippiScaleC_32s_C1R:=getProc(hh,'ippiScaleC_32s_C1R');
  ippiScaleC_32s32f_C1R:=getProc(hh,'ippiScaleC_32s32f_C1R');
  ippiScaleC_32s64f_C1R:=getProc(hh,'ippiScaleC_32s64f_C1R');
  ippiScaleC_32f8u_C1R:=getProc(hh,'ippiScaleC_32f8u_C1R');
  ippiScaleC_32f8s_C1R:=getProc(hh,'ippiScaleC_32f8s_C1R');
  ippiScaleC_32f16u_C1R:=getProc(hh,'ippiScaleC_32f16u_C1R');
  ippiScaleC_32f16s_C1R:=getProc(hh,'ippiScaleC_32f16s_C1R');
  ippiScaleC_32f32s_C1R:=getProc(hh,'ippiScaleC_32f32s_C1R');
  ippiScaleC_32f_C1R:=getProc(hh,'ippiScaleC_32f_C1R');
  ippiScaleC_32f64f_C1R:=getProc(hh,'ippiScaleC_32f64f_C1R');
  ippiScaleC_64f8u_C1R:=getProc(hh,'ippiScaleC_64f8u_C1R');
  ippiScaleC_64f8s_C1R:=getProc(hh,'ippiScaleC_64f8s_C1R');
  ippiScaleC_64f16u_C1R:=getProc(hh,'ippiScaleC_64f16u_C1R');
  ippiScaleC_64f16s_C1R:=getProc(hh,'ippiScaleC_64f16s_C1R');
  ippiScaleC_64f32s_C1R:=getProc(hh,'ippiScaleC_64f32s_C1R');
  ippiScaleC_64f32f_C1R:=getProc(hh,'ippiScaleC_64f32f_C1R');
  ippiScaleC_64f_C1R:=getProc(hh,'ippiScaleC_64f_C1R');
  ippiScaleC_8u_C1IR:=getProc(hh,'ippiScaleC_8u_C1IR');
  ippiScaleC_8s_C1IR:=getProc(hh,'ippiScaleC_8s_C1IR');
  ippiScaleC_16u_C1IR:=getProc(hh,'ippiScaleC_16u_C1IR');
  ippiScaleC_16s_C1IR:=getProc(hh,'ippiScaleC_16s_C1IR');
  ippiScaleC_32s_C1IR:=getProc(hh,'ippiScaleC_32s_C1IR');
  ippiScaleC_32f_C1IR:=getProc(hh,'ippiScaleC_32f_C1IR');
  ippiScaleC_64f_C1IR:=getProc(hh,'ippiScaleC_64f_C1IR');
  ippiBinToGray_1u8u_C1R:=getProc(hh,'ippiBinToGray_1u8u_C1R');
  ippiBinToGray_1u16u_C1R:=getProc(hh,'ippiBinToGray_1u16u_C1R');
  ippiBinToGray_1u16s_C1R:=getProc(hh,'ippiBinToGray_1u16s_C1R');
  ippiBinToGray_1u32f_C1R:=getProc(hh,'ippiBinToGray_1u32f_C1R');
  ippiGrayToBin_8u1u_C1R:=getProc(hh,'ippiGrayToBin_8u1u_C1R');
  ippiGrayToBin_16u1u_C1R:=getProc(hh,'ippiGrayToBin_16u1u_C1R');
  ippiGrayToBin_16s1u_C1R:=getProc(hh,'ippiGrayToBin_16s1u_C1R');
  ippiGrayToBin_32f1u_C1R:=getProc(hh,'ippiGrayToBin_32f1u_C1R');
  ippiPolarToCart_32fc_C1R:=getProc(hh,'ippiPolarToCart_32fc_C1R');
  ippiPolarToCart_32fc_C3R:=getProc(hh,'ippiPolarToCart_32fc_C3R');
  ippiSwapChannels_8u_C3R:=getProc(hh,'ippiSwapChannels_8u_C3R');
  ippiSwapChannels_8u_AC4R:=getProc(hh,'ippiSwapChannels_8u_AC4R');
  ippiSwapChannels_8u_C4R:=getProc(hh,'ippiSwapChannels_8u_C4R');
  ippiSwapChannels_16u_C3R:=getProc(hh,'ippiSwapChannels_16u_C3R');
  ippiSwapChannels_16u_AC4R:=getProc(hh,'ippiSwapChannels_16u_AC4R');
  ippiSwapChannels_16u_C4R:=getProc(hh,'ippiSwapChannels_16u_C4R');
  ippiSwapChannels_16s_C3R:=getProc(hh,'ippiSwapChannels_16s_C3R');
  ippiSwapChannels_16s_AC4R:=getProc(hh,'ippiSwapChannels_16s_AC4R');
  ippiSwapChannels_16s_C4R:=getProc(hh,'ippiSwapChannels_16s_C4R');
  ippiSwapChannels_32s_C3R:=getProc(hh,'ippiSwapChannels_32s_C3R');
  ippiSwapChannels_32s_AC4R:=getProc(hh,'ippiSwapChannels_32s_AC4R');
  ippiSwapChannels_32s_C4R:=getProc(hh,'ippiSwapChannels_32s_C4R');
  ippiSwapChannels_32f_C3R:=getProc(hh,'ippiSwapChannels_32f_C3R');
  ippiSwapChannels_32f_AC4R:=getProc(hh,'ippiSwapChannels_32f_AC4R');
  ippiSwapChannels_32f_C4R:=getProc(hh,'ippiSwapChannels_32f_C4R');
  ippiSwapChannels_8u_C3IR:=getProc(hh,'ippiSwapChannels_8u_C3IR');
  ippiSwapChannels_8u_C4IR:=getProc(hh,'ippiSwapChannels_8u_C4IR');
  ippiSwapChannels_8u_C3C4R:=getProc(hh,'ippiSwapChannels_8u_C3C4R');
  ippiSwapChannels_8u_C4C3R:=getProc(hh,'ippiSwapChannels_8u_C4C3R');
  ippiSwapChannels_16s_C3C4R:=getProc(hh,'ippiSwapChannels_16s_C3C4R');
  ippiSwapChannels_16s_C4C3R:=getProc(hh,'ippiSwapChannels_16s_C4C3R');
  ippiSwapChannels_16u_C3C4R:=getProc(hh,'ippiSwapChannels_16u_C3C4R');
  ippiSwapChannels_16u_C4C3R:=getProc(hh,'ippiSwapChannels_16u_C4C3R');
  ippiSwapChannels_32s_C3C4R:=getProc(hh,'ippiSwapChannels_32s_C3C4R');
  ippiSwapChannels_32s_C4C3R:=getProc(hh,'ippiSwapChannels_32s_C4C3R');
  ippiSwapChannels_32f_C3C4R:=getProc(hh,'ippiSwapChannels_32f_C3C4R');
  ippiSwapChannels_32f_C4C3R:=getProc(hh,'ippiSwapChannels_32f_C4C3R');
  ippiScale_8u16u_C1R:=getProc(hh,'ippiScale_8u16u_C1R');
  ippiScale_8u16u_C3R:=getProc(hh,'ippiScale_8u16u_C3R');
  ippiScale_8u16u_C4R:=getProc(hh,'ippiScale_8u16u_C4R');
  ippiScale_8u16u_AC4R:=getProc(hh,'ippiScale_8u16u_AC4R');
  ippiScale_8u16s_C1R:=getProc(hh,'ippiScale_8u16s_C1R');
  ippiScale_8u16s_C3R:=getProc(hh,'ippiScale_8u16s_C3R');
  ippiScale_8u16s_C4R:=getProc(hh,'ippiScale_8u16s_C4R');
  ippiScale_8u16s_AC4R:=getProc(hh,'ippiScale_8u16s_AC4R');
  ippiScale_8u32s_C1R:=getProc(hh,'ippiScale_8u32s_C1R');
  ippiScale_8u32s_C3R:=getProc(hh,'ippiScale_8u32s_C3R');
  ippiScale_8u32s_C4R:=getProc(hh,'ippiScale_8u32s_C4R');
  ippiScale_8u32s_AC4R:=getProc(hh,'ippiScale_8u32s_AC4R');
  ippiScale_8u32f_C1R:=getProc(hh,'ippiScale_8u32f_C1R');
  ippiScale_8u32f_C3R:=getProc(hh,'ippiScale_8u32f_C3R');
  ippiScale_8u32f_C4R:=getProc(hh,'ippiScale_8u32f_C4R');
  ippiScale_8u32f_AC4R:=getProc(hh,'ippiScale_8u32f_AC4R');
  ippiScale_16u8u_C1R:=getProc(hh,'ippiScale_16u8u_C1R');
  ippiScale_16u8u_C3R:=getProc(hh,'ippiScale_16u8u_C3R');
  ippiScale_16u8u_C4R:=getProc(hh,'ippiScale_16u8u_C4R');
  ippiScale_16u8u_AC4R:=getProc(hh,'ippiScale_16u8u_AC4R');
  ippiScale_16s8u_C1R:=getProc(hh,'ippiScale_16s8u_C1R');
  ippiScale_16s8u_C3R:=getProc(hh,'ippiScale_16s8u_C3R');
  ippiScale_16s8u_C4R:=getProc(hh,'ippiScale_16s8u_C4R');
  ippiScale_16s8u_AC4R:=getProc(hh,'ippiScale_16s8u_AC4R');
  ippiScale_32s8u_C1R:=getProc(hh,'ippiScale_32s8u_C1R');
  ippiScale_32s8u_C3R:=getProc(hh,'ippiScale_32s8u_C3R');
  ippiScale_32s8u_C4R:=getProc(hh,'ippiScale_32s8u_C4R');
  ippiScale_32s8u_AC4R:=getProc(hh,'ippiScale_32s8u_AC4R');
  ippiScale_32f8u_C1R:=getProc(hh,'ippiScale_32f8u_C1R');
  ippiScale_32f8u_C3R:=getProc(hh,'ippiScale_32f8u_C3R');
  ippiScale_32f8u_C4R:=getProc(hh,'ippiScale_32f8u_C4R');
  ippiScale_32f8u_AC4R:=getProc(hh,'ippiScale_32f8u_AC4R');
  ippiMin_8u_C1R:=getProc(hh,'ippiMin_8u_C1R');
  ippiMin_8u_C3R:=getProc(hh,'ippiMin_8u_C3R');
  ippiMin_8u_AC4R:=getProc(hh,'ippiMin_8u_AC4R');
  ippiMin_8u_C4R:=getProc(hh,'ippiMin_8u_C4R');
  ippiMin_16s_C1R:=getProc(hh,'ippiMin_16s_C1R');
  ippiMin_16s_C3R:=getProc(hh,'ippiMin_16s_C3R');
  ippiMin_16s_AC4R:=getProc(hh,'ippiMin_16s_AC4R');
  ippiMin_16s_C4R:=getProc(hh,'ippiMin_16s_C4R');
  ippiMin_16u_C1R:=getProc(hh,'ippiMin_16u_C1R');
  ippiMin_16u_C3R:=getProc(hh,'ippiMin_16u_C3R');
  ippiMin_16u_AC4R:=getProc(hh,'ippiMin_16u_AC4R');
  ippiMin_16u_C4R:=getProc(hh,'ippiMin_16u_C4R');
  ippiMin_32f_C1R:=getProc(hh,'ippiMin_32f_C1R');
  ippiMin_32f_C3R:=getProc(hh,'ippiMin_32f_C3R');
  ippiMin_32f_AC4R:=getProc(hh,'ippiMin_32f_AC4R');
  ippiMin_32f_C4R:=getProc(hh,'ippiMin_32f_C4R');
  ippiMinIndx_8u_C1R:=getProc(hh,'ippiMinIndx_8u_C1R');
  ippiMinIndx_8u_C3R:=getProc(hh,'ippiMinIndx_8u_C3R');
  ippiMinIndx_8u_AC4R:=getProc(hh,'ippiMinIndx_8u_AC4R');
  ippiMinIndx_8u_C4R:=getProc(hh,'ippiMinIndx_8u_C4R');
  ippiMinIndx_16s_C1R:=getProc(hh,'ippiMinIndx_16s_C1R');
  ippiMinIndx_16s_C3R:=getProc(hh,'ippiMinIndx_16s_C3R');
  ippiMinIndx_16s_AC4R:=getProc(hh,'ippiMinIndx_16s_AC4R');
  ippiMinIndx_16s_C4R:=getProc(hh,'ippiMinIndx_16s_C4R');
  ippiMinIndx_16u_C1R:=getProc(hh,'ippiMinIndx_16u_C1R');
  ippiMinIndx_16u_C3R:=getProc(hh,'ippiMinIndx_16u_C3R');
  ippiMinIndx_16u_AC4R:=getProc(hh,'ippiMinIndx_16u_AC4R');
  ippiMinIndx_16u_C4R:=getProc(hh,'ippiMinIndx_16u_C4R');
  ippiMinIndx_32f_C1R:=getProc(hh,'ippiMinIndx_32f_C1R');
  ippiMinIndx_32f_C3R:=getProc(hh,'ippiMinIndx_32f_C3R');
  ippiMinIndx_32f_AC4R:=getProc(hh,'ippiMinIndx_32f_AC4R');
  ippiMinIndx_32f_C4R:=getProc(hh,'ippiMinIndx_32f_C4R');
  ippiMax_8u_C1R:=getProc(hh,'ippiMax_8u_C1R');
  ippiMax_8u_C3R:=getProc(hh,'ippiMax_8u_C3R');
  ippiMax_8u_AC4R:=getProc(hh,'ippiMax_8u_AC4R');
  ippiMax_8u_C4R:=getProc(hh,'ippiMax_8u_C4R');
  ippiMax_16s_C1R:=getProc(hh,'ippiMax_16s_C1R');
  ippiMax_16s_C3R:=getProc(hh,'ippiMax_16s_C3R');
  ippiMax_16s_AC4R:=getProc(hh,'ippiMax_16s_AC4R');
  ippiMax_16s_C4R:=getProc(hh,'ippiMax_16s_C4R');
  ippiMax_16u_C1R:=getProc(hh,'ippiMax_16u_C1R');
  ippiMax_16u_C3R:=getProc(hh,'ippiMax_16u_C3R');
  ippiMax_16u_AC4R:=getProc(hh,'ippiMax_16u_AC4R');
  ippiMax_16u_C4R:=getProc(hh,'ippiMax_16u_C4R');
  ippiMax_32f_C1R:=getProc(hh,'ippiMax_32f_C1R');
  ippiMax_32f_C3R:=getProc(hh,'ippiMax_32f_C3R');
  ippiMax_32f_AC4R:=getProc(hh,'ippiMax_32f_AC4R');
  ippiMax_32f_C4R:=getProc(hh,'ippiMax_32f_C4R');
  ippiMaxIndx_8u_C1R:=getProc(hh,'ippiMaxIndx_8u_C1R');
  ippiMaxIndx_8u_C3R:=getProc(hh,'ippiMaxIndx_8u_C3R');
  ippiMaxIndx_8u_AC4R:=getProc(hh,'ippiMaxIndx_8u_AC4R');
  ippiMaxIndx_8u_C4R:=getProc(hh,'ippiMaxIndx_8u_C4R');
  ippiMaxIndx_16s_C1R:=getProc(hh,'ippiMaxIndx_16s_C1R');
  ippiMaxIndx_16s_C3R:=getProc(hh,'ippiMaxIndx_16s_C3R');
  ippiMaxIndx_16s_AC4R:=getProc(hh,'ippiMaxIndx_16s_AC4R');
  ippiMaxIndx_16s_C4R:=getProc(hh,'ippiMaxIndx_16s_C4R');
  ippiMaxIndx_16u_C1R:=getProc(hh,'ippiMaxIndx_16u_C1R');
  ippiMaxIndx_16u_C3R:=getProc(hh,'ippiMaxIndx_16u_C3R');
  ippiMaxIndx_16u_AC4R:=getProc(hh,'ippiMaxIndx_16u_AC4R');
  ippiMaxIndx_16u_C4R:=getProc(hh,'ippiMaxIndx_16u_C4R');
  ippiMaxIndx_32f_C1R:=getProc(hh,'ippiMaxIndx_32f_C1R');
  ippiMaxIndx_32f_C3R:=getProc(hh,'ippiMaxIndx_32f_C3R');
  ippiMaxIndx_32f_AC4R:=getProc(hh,'ippiMaxIndx_32f_AC4R');
  ippiMaxIndx_32f_C4R:=getProc(hh,'ippiMaxIndx_32f_C4R');
  ippiMinMax_8u_C1R:=getProc(hh,'ippiMinMax_8u_C1R');
  ippiMinMax_8u_C3R:=getProc(hh,'ippiMinMax_8u_C3R');
  ippiMinMax_8u_AC4R:=getProc(hh,'ippiMinMax_8u_AC4R');
  ippiMinMax_8u_C4R:=getProc(hh,'ippiMinMax_8u_C4R');
  ippiMinMax_16s_C1R:=getProc(hh,'ippiMinMax_16s_C1R');
  ippiMinMax_16s_C3R:=getProc(hh,'ippiMinMax_16s_C3R');
  ippiMinMax_16s_AC4R:=getProc(hh,'ippiMinMax_16s_AC4R');
  ippiMinMax_16s_C4R:=getProc(hh,'ippiMinMax_16s_C4R');
  ippiMinMax_16u_C1R:=getProc(hh,'ippiMinMax_16u_C1R');
  ippiMinMax_16u_C3R:=getProc(hh,'ippiMinMax_16u_C3R');
  ippiMinMax_16u_AC4R:=getProc(hh,'ippiMinMax_16u_AC4R');
  ippiMinMax_16u_C4R:=getProc(hh,'ippiMinMax_16u_C4R');
  ippiMinMax_32f_C1R:=getProc(hh,'ippiMinMax_32f_C1R');
  ippiMinMax_32f_C3R:=getProc(hh,'ippiMinMax_32f_C3R');
  ippiMinMax_32f_AC4R:=getProc(hh,'ippiMinMax_32f_AC4R');
  ippiMinMax_32f_C4R:=getProc(hh,'ippiMinMax_32f_C4R');
  ippiBlockMinMax_32f_C1R:=getProc(hh,'ippiBlockMinMax_32f_C1R');
  ippiBlockMinMax_16s_C1R:=getProc(hh,'ippiBlockMinMax_16s_C1R');
  ippiBlockMinMax_16u_C1R:=getProc(hh,'ippiBlockMinMax_16u_C1R');
  ippiBlockMinMax_8u_C1R:=getProc(hh,'ippiBlockMinMax_8u_C1R');
  ippiMaxEvery_8u_C1IR:=getProc(hh,'ippiMaxEvery_8u_C1IR');
  ippiMinEvery_8u_C1IR:=getProc(hh,'ippiMinEvery_8u_C1IR');
  ippiMaxEvery_16s_C1IR:=getProc(hh,'ippiMaxEvery_16s_C1IR');
  ippiMinEvery_16s_C1IR:=getProc(hh,'ippiMinEvery_16s_C1IR');
  ippiMaxEvery_16u_C1IR:=getProc(hh,'ippiMaxEvery_16u_C1IR');
  ippiMinEvery_16u_C1IR:=getProc(hh,'ippiMinEvery_16u_C1IR');
  ippiMaxEvery_32f_C1IR:=getProc(hh,'ippiMaxEvery_32f_C1IR');
  ippiMinEvery_32f_C1IR:=getProc(hh,'ippiMinEvery_32f_C1IR');
  ippiMaxEvery_8u_C3IR:=getProc(hh,'ippiMaxEvery_8u_C3IR');
  ippiMinEvery_8u_C3IR:=getProc(hh,'ippiMinEvery_8u_C3IR');
  ippiMaxEvery_16s_C3IR:=getProc(hh,'ippiMaxEvery_16s_C3IR');
  ippiMinEvery_16s_C3IR:=getProc(hh,'ippiMinEvery_16s_C3IR');
  ippiMaxEvery_16u_C3IR:=getProc(hh,'ippiMaxEvery_16u_C3IR');
  ippiMinEvery_16u_C3IR:=getProc(hh,'ippiMinEvery_16u_C3IR');
  ippiMaxEvery_32f_C3IR:=getProc(hh,'ippiMaxEvery_32f_C3IR');
  ippiMinEvery_32f_C3IR:=getProc(hh,'ippiMinEvery_32f_C3IR');
  ippiMaxEvery_8u_C4IR:=getProc(hh,'ippiMaxEvery_8u_C4IR');
  ippiMinEvery_8u_C4IR:=getProc(hh,'ippiMinEvery_8u_C4IR');
  ippiMaxEvery_16s_C4IR:=getProc(hh,'ippiMaxEvery_16s_C4IR');
  ippiMinEvery_16s_C4IR:=getProc(hh,'ippiMinEvery_16s_C4IR');
  ippiMaxEvery_16u_C4IR:=getProc(hh,'ippiMaxEvery_16u_C4IR');
  ippiMinEvery_16u_C4IR:=getProc(hh,'ippiMinEvery_16u_C4IR');
  ippiMaxEvery_32f_C4IR:=getProc(hh,'ippiMaxEvery_32f_C4IR');
  ippiMinEvery_32f_C4IR:=getProc(hh,'ippiMinEvery_32f_C4IR');
  ippiMaxEvery_8u_AC4IR:=getProc(hh,'ippiMaxEvery_8u_AC4IR');
  ippiMinEvery_8u_AC4IR:=getProc(hh,'ippiMinEvery_8u_AC4IR');
  ippiMaxEvery_16s_AC4IR:=getProc(hh,'ippiMaxEvery_16s_AC4IR');
  ippiMinEvery_16s_AC4IR:=getProc(hh,'ippiMinEvery_16s_AC4IR');
  ippiMaxEvery_16u_AC4IR:=getProc(hh,'ippiMaxEvery_16u_AC4IR');
  ippiMinEvery_16u_AC4IR:=getProc(hh,'ippiMinEvery_16u_AC4IR');
  ippiMaxEvery_32f_AC4IR:=getProc(hh,'ippiMaxEvery_32f_AC4IR');
  ippiMinEvery_32f_AC4IR:=getProc(hh,'ippiMinEvery_32f_AC4IR');
  ippiMinEvery_8u_C1R:=getProc(hh,'ippiMinEvery_8u_C1R');
  ippiMinEvery_16u_C1R:=getProc(hh,'ippiMinEvery_16u_C1R');
  ippiMinEvery_32f_C1R:=getProc(hh,'ippiMinEvery_32f_C1R');
  ippiMaxEvery_8u_C1R:=getProc(hh,'ippiMaxEvery_8u_C1R');
  ippiMaxEvery_16u_C1R:=getProc(hh,'ippiMaxEvery_16u_C1R');
  ippiMaxEvery_32f_C1R:=getProc(hh,'ippiMaxEvery_32f_C1R');
  ippiAnd_8u_C1R:=getProc(hh,'ippiAnd_8u_C1R');
  ippiAnd_8u_C3R:=getProc(hh,'ippiAnd_8u_C3R');
  ippiAnd_8u_C4R:=getProc(hh,'ippiAnd_8u_C4R');
  ippiAnd_8u_AC4R:=getProc(hh,'ippiAnd_8u_AC4R');
  ippiAnd_8u_C1IR:=getProc(hh,'ippiAnd_8u_C1IR');
  ippiAnd_8u_C3IR:=getProc(hh,'ippiAnd_8u_C3IR');
  ippiAnd_8u_C4IR:=getProc(hh,'ippiAnd_8u_C4IR');
  ippiAnd_8u_AC4IR:=getProc(hh,'ippiAnd_8u_AC4IR');
  ippiAndC_8u_C1R:=getProc(hh,'ippiAndC_8u_C1R');
  ippiAndC_8u_C3R:=getProc(hh,'ippiAndC_8u_C3R');
  ippiAndC_8u_C4R:=getProc(hh,'ippiAndC_8u_C4R');
  ippiAndC_8u_AC4R:=getProc(hh,'ippiAndC_8u_AC4R');
  ippiAndC_8u_C1IR:=getProc(hh,'ippiAndC_8u_C1IR');
  ippiAndC_8u_C3IR:=getProc(hh,'ippiAndC_8u_C3IR');
  ippiAndC_8u_C4IR:=getProc(hh,'ippiAndC_8u_C4IR');
  ippiAndC_8u_AC4IR:=getProc(hh,'ippiAndC_8u_AC4IR');
  ippiAnd_16u_C1R:=getProc(hh,'ippiAnd_16u_C1R');
  ippiAnd_16u_C3R:=getProc(hh,'ippiAnd_16u_C3R');
  ippiAnd_16u_C4R:=getProc(hh,'ippiAnd_16u_C4R');
  ippiAnd_16u_AC4R:=getProc(hh,'ippiAnd_16u_AC4R');
  ippiAnd_16u_C1IR:=getProc(hh,'ippiAnd_16u_C1IR');
  ippiAnd_16u_C3IR:=getProc(hh,'ippiAnd_16u_C3IR');
  ippiAnd_16u_C4IR:=getProc(hh,'ippiAnd_16u_C4IR');
  ippiAnd_16u_AC4IR:=getProc(hh,'ippiAnd_16u_AC4IR');
  ippiAndC_16u_C1R:=getProc(hh,'ippiAndC_16u_C1R');
  ippiAndC_16u_C3R:=getProc(hh,'ippiAndC_16u_C3R');
  ippiAndC_16u_C4R:=getProc(hh,'ippiAndC_16u_C4R');
  ippiAndC_16u_AC4R:=getProc(hh,'ippiAndC_16u_AC4R');
  ippiAndC_16u_C1IR:=getProc(hh,'ippiAndC_16u_C1IR');
  ippiAndC_16u_C3IR:=getProc(hh,'ippiAndC_16u_C3IR');
  ippiAndC_16u_C4IR:=getProc(hh,'ippiAndC_16u_C4IR');
  ippiAndC_16u_AC4IR:=getProc(hh,'ippiAndC_16u_AC4IR');
  ippiAnd_32s_C1R:=getProc(hh,'ippiAnd_32s_C1R');
  ippiAnd_32s_C3R:=getProc(hh,'ippiAnd_32s_C3R');
  ippiAnd_32s_C4R:=getProc(hh,'ippiAnd_32s_C4R');
  ippiAnd_32s_AC4R:=getProc(hh,'ippiAnd_32s_AC4R');
  ippiAnd_32s_C1IR:=getProc(hh,'ippiAnd_32s_C1IR');
  ippiAnd_32s_C3IR:=getProc(hh,'ippiAnd_32s_C3IR');
  ippiAnd_32s_C4IR:=getProc(hh,'ippiAnd_32s_C4IR');
  ippiAnd_32s_AC4IR:=getProc(hh,'ippiAnd_32s_AC4IR');
  ippiAndC_32s_C1R:=getProc(hh,'ippiAndC_32s_C1R');
  ippiAndC_32s_C3R:=getProc(hh,'ippiAndC_32s_C3R');
  ippiAndC_32s_C4R:=getProc(hh,'ippiAndC_32s_C4R');
  ippiAndC_32s_AC4R:=getProc(hh,'ippiAndC_32s_AC4R');
  ippiAndC_32s_C1IR:=getProc(hh,'ippiAndC_32s_C1IR');
  ippiAndC_32s_C3IR:=getProc(hh,'ippiAndC_32s_C3IR');
  ippiAndC_32s_C4IR:=getProc(hh,'ippiAndC_32s_C4IR');
  ippiAndC_32s_AC4IR:=getProc(hh,'ippiAndC_32s_AC4IR');
  ippiOr_8u_C1R:=getProc(hh,'ippiOr_8u_C1R');
  ippiOr_8u_C3R:=getProc(hh,'ippiOr_8u_C3R');
  ippiOr_8u_C4R:=getProc(hh,'ippiOr_8u_C4R');
  ippiOr_8u_AC4R:=getProc(hh,'ippiOr_8u_AC4R');
  ippiOr_8u_C1IR:=getProc(hh,'ippiOr_8u_C1IR');
  ippiOr_8u_C3IR:=getProc(hh,'ippiOr_8u_C3IR');
  ippiOr_8u_C4IR:=getProc(hh,'ippiOr_8u_C4IR');
  ippiOr_8u_AC4IR:=getProc(hh,'ippiOr_8u_AC4IR');
  ippiOrC_8u_C1R:=getProc(hh,'ippiOrC_8u_C1R');
  ippiOrC_8u_C3R:=getProc(hh,'ippiOrC_8u_C3R');
  ippiOrC_8u_C4R:=getProc(hh,'ippiOrC_8u_C4R');
  ippiOrC_8u_AC4R:=getProc(hh,'ippiOrC_8u_AC4R');
  ippiOrC_8u_C1IR:=getProc(hh,'ippiOrC_8u_C1IR');
  ippiOrC_8u_C3IR:=getProc(hh,'ippiOrC_8u_C3IR');
  ippiOrC_8u_C4IR:=getProc(hh,'ippiOrC_8u_C4IR');
  ippiOrC_8u_AC4IR:=getProc(hh,'ippiOrC_8u_AC4IR');
  ippiOr_16u_C1R:=getProc(hh,'ippiOr_16u_C1R');
  ippiOr_16u_C3R:=getProc(hh,'ippiOr_16u_C3R');
  ippiOr_16u_C4R:=getProc(hh,'ippiOr_16u_C4R');
  ippiOr_16u_AC4R:=getProc(hh,'ippiOr_16u_AC4R');
  ippiOr_16u_C1IR:=getProc(hh,'ippiOr_16u_C1IR');
  ippiOr_16u_C3IR:=getProc(hh,'ippiOr_16u_C3IR');
  ippiOr_16u_C4IR:=getProc(hh,'ippiOr_16u_C4IR');
  ippiOr_16u_AC4IR:=getProc(hh,'ippiOr_16u_AC4IR');
  ippiOrC_16u_C1R:=getProc(hh,'ippiOrC_16u_C1R');
  ippiOrC_16u_C3R:=getProc(hh,'ippiOrC_16u_C3R');
  ippiOrC_16u_C4R:=getProc(hh,'ippiOrC_16u_C4R');
  ippiOrC_16u_AC4R:=getProc(hh,'ippiOrC_16u_AC4R');
  ippiOrC_16u_C1IR:=getProc(hh,'ippiOrC_16u_C1IR');
  ippiOrC_16u_C3IR:=getProc(hh,'ippiOrC_16u_C3IR');
  ippiOrC_16u_C4IR:=getProc(hh,'ippiOrC_16u_C4IR');
  ippiOrC_16u_AC4IR:=getProc(hh,'ippiOrC_16u_AC4IR');
  ippiOr_32s_C1R:=getProc(hh,'ippiOr_32s_C1R');
  ippiOr_32s_C3R:=getProc(hh,'ippiOr_32s_C3R');
  ippiOr_32s_C4R:=getProc(hh,'ippiOr_32s_C4R');
  ippiOr_32s_AC4R:=getProc(hh,'ippiOr_32s_AC4R');
  ippiOr_32s_C1IR:=getProc(hh,'ippiOr_32s_C1IR');
  ippiOr_32s_C3IR:=getProc(hh,'ippiOr_32s_C3IR');
  ippiOr_32s_C4IR:=getProc(hh,'ippiOr_32s_C4IR');
  ippiOr_32s_AC4IR:=getProc(hh,'ippiOr_32s_AC4IR');
  ippiOrC_32s_C1R:=getProc(hh,'ippiOrC_32s_C1R');
  ippiOrC_32s_C3R:=getProc(hh,'ippiOrC_32s_C3R');
  ippiOrC_32s_C4R:=getProc(hh,'ippiOrC_32s_C4R');
  ippiOrC_32s_AC4R:=getProc(hh,'ippiOrC_32s_AC4R');
  ippiOrC_32s_C1IR:=getProc(hh,'ippiOrC_32s_C1IR');
  ippiOrC_32s_C3IR:=getProc(hh,'ippiOrC_32s_C3IR');
  ippiOrC_32s_C4IR:=getProc(hh,'ippiOrC_32s_C4IR');
  ippiOrC_32s_AC4IR:=getProc(hh,'ippiOrC_32s_AC4IR');
  ippiXor_8u_C1R:=getProc(hh,'ippiXor_8u_C1R');
  ippiXor_8u_C3R:=getProc(hh,'ippiXor_8u_C3R');
  ippiXor_8u_C4R:=getProc(hh,'ippiXor_8u_C4R');
  ippiXor_8u_AC4R:=getProc(hh,'ippiXor_8u_AC4R');
  ippiXor_8u_C1IR:=getProc(hh,'ippiXor_8u_C1IR');
  ippiXor_8u_C3IR:=getProc(hh,'ippiXor_8u_C3IR');
  ippiXor_8u_C4IR:=getProc(hh,'ippiXor_8u_C4IR');
  ippiXor_8u_AC4IR:=getProc(hh,'ippiXor_8u_AC4IR');
  ippiXorC_8u_C1R:=getProc(hh,'ippiXorC_8u_C1R');
  ippiXorC_8u_C3R:=getProc(hh,'ippiXorC_8u_C3R');
  ippiXorC_8u_C4R:=getProc(hh,'ippiXorC_8u_C4R');
  ippiXorC_8u_AC4R:=getProc(hh,'ippiXorC_8u_AC4R');
  ippiXorC_8u_C1IR:=getProc(hh,'ippiXorC_8u_C1IR');
  ippiXorC_8u_C3IR:=getProc(hh,'ippiXorC_8u_C3IR');
  ippiXorC_8u_C4IR:=getProc(hh,'ippiXorC_8u_C4IR');
  ippiXorC_8u_AC4IR:=getProc(hh,'ippiXorC_8u_AC4IR');
  ippiXor_16u_C1R:=getProc(hh,'ippiXor_16u_C1R');
  ippiXor_16u_C3R:=getProc(hh,'ippiXor_16u_C3R');
  ippiXor_16u_C4R:=getProc(hh,'ippiXor_16u_C4R');
  ippiXor_16u_AC4R:=getProc(hh,'ippiXor_16u_AC4R');
  ippiXor_16u_C1IR:=getProc(hh,'ippiXor_16u_C1IR');
  ippiXor_16u_C3IR:=getProc(hh,'ippiXor_16u_C3IR');
  ippiXor_16u_C4IR:=getProc(hh,'ippiXor_16u_C4IR');
  ippiXor_16u_AC4IR:=getProc(hh,'ippiXor_16u_AC4IR');
  ippiXorC_16u_C1R:=getProc(hh,'ippiXorC_16u_C1R');
  ippiXorC_16u_C3R:=getProc(hh,'ippiXorC_16u_C3R');
  ippiXorC_16u_C4R:=getProc(hh,'ippiXorC_16u_C4R');
  ippiXorC_16u_AC4R:=getProc(hh,'ippiXorC_16u_AC4R');
  ippiXorC_16u_C1IR:=getProc(hh,'ippiXorC_16u_C1IR');
  ippiXorC_16u_C3IR:=getProc(hh,'ippiXorC_16u_C3IR');
  ippiXorC_16u_C4IR:=getProc(hh,'ippiXorC_16u_C4IR');
  ippiXorC_16u_AC4IR:=getProc(hh,'ippiXorC_16u_AC4IR');
  ippiXor_32s_C1R:=getProc(hh,'ippiXor_32s_C1R');
  ippiXor_32s_C3R:=getProc(hh,'ippiXor_32s_C3R');
  ippiXor_32s_C4R:=getProc(hh,'ippiXor_32s_C4R');
  ippiXor_32s_AC4R:=getProc(hh,'ippiXor_32s_AC4R');
  ippiXor_32s_C1IR:=getProc(hh,'ippiXor_32s_C1IR');
  ippiXor_32s_C3IR:=getProc(hh,'ippiXor_32s_C3IR');
  ippiXor_32s_C4IR:=getProc(hh,'ippiXor_32s_C4IR');
  ippiXor_32s_AC4IR:=getProc(hh,'ippiXor_32s_AC4IR');
  ippiXorC_32s_C1R:=getProc(hh,'ippiXorC_32s_C1R');
  ippiXorC_32s_C3R:=getProc(hh,'ippiXorC_32s_C3R');
  ippiXorC_32s_C4R:=getProc(hh,'ippiXorC_32s_C4R');
  ippiXorC_32s_AC4R:=getProc(hh,'ippiXorC_32s_AC4R');
  ippiXorC_32s_C1IR:=getProc(hh,'ippiXorC_32s_C1IR');
  ippiXorC_32s_C3IR:=getProc(hh,'ippiXorC_32s_C3IR');
  ippiXorC_32s_C4IR:=getProc(hh,'ippiXorC_32s_C4IR');
  ippiXorC_32s_AC4IR:=getProc(hh,'ippiXorC_32s_AC4IR');
  ippiNot_8u_C1R:=getProc(hh,'ippiNot_8u_C1R');
  ippiNot_8u_C3R:=getProc(hh,'ippiNot_8u_C3R');
  ippiNot_8u_C4R:=getProc(hh,'ippiNot_8u_C4R');
  ippiNot_8u_AC4R:=getProc(hh,'ippiNot_8u_AC4R');
  ippiNot_8u_C1IR:=getProc(hh,'ippiNot_8u_C1IR');
  ippiNot_8u_C3IR:=getProc(hh,'ippiNot_8u_C3IR');
  ippiNot_8u_C4IR:=getProc(hh,'ippiNot_8u_C4IR');
  ippiNot_8u_AC4IR:=getProc(hh,'ippiNot_8u_AC4IR');
  ippiLShiftC_8u_C1R:=getProc(hh,'ippiLShiftC_8u_C1R');
  ippiLShiftC_8u_C3R:=getProc(hh,'ippiLShiftC_8u_C3R');
  ippiLShiftC_8u_C4R:=getProc(hh,'ippiLShiftC_8u_C4R');
  ippiLShiftC_8u_AC4R:=getProc(hh,'ippiLShiftC_8u_AC4R');
  ippiLShiftC_8u_C1IR:=getProc(hh,'ippiLShiftC_8u_C1IR');
  ippiLShiftC_8u_C3IR:=getProc(hh,'ippiLShiftC_8u_C3IR');
  ippiLShiftC_8u_C4IR:=getProc(hh,'ippiLShiftC_8u_C4IR');
  ippiLShiftC_8u_AC4IR:=getProc(hh,'ippiLShiftC_8u_AC4IR');
  ippiLShiftC_16u_C1R:=getProc(hh,'ippiLShiftC_16u_C1R');
  ippiLShiftC_16u_C3R:=getProc(hh,'ippiLShiftC_16u_C3R');
  ippiLShiftC_16u_C4R:=getProc(hh,'ippiLShiftC_16u_C4R');
  ippiLShiftC_16u_AC4R:=getProc(hh,'ippiLShiftC_16u_AC4R');
  ippiLShiftC_16u_C1IR:=getProc(hh,'ippiLShiftC_16u_C1IR');
  ippiLShiftC_16u_C3IR:=getProc(hh,'ippiLShiftC_16u_C3IR');
  ippiLShiftC_16u_C4IR:=getProc(hh,'ippiLShiftC_16u_C4IR');
  ippiLShiftC_16u_AC4IR:=getProc(hh,'ippiLShiftC_16u_AC4IR');
  ippiLShiftC_32s_C1R:=getProc(hh,'ippiLShiftC_32s_C1R');
  ippiLShiftC_32s_C3R:=getProc(hh,'ippiLShiftC_32s_C3R');
  ippiLShiftC_32s_C4R:=getProc(hh,'ippiLShiftC_32s_C4R');
  ippiLShiftC_32s_AC4R:=getProc(hh,'ippiLShiftC_32s_AC4R');
  ippiLShiftC_32s_C1IR:=getProc(hh,'ippiLShiftC_32s_C1IR');
  ippiLShiftC_32s_C3IR:=getProc(hh,'ippiLShiftC_32s_C3IR');
  ippiLShiftC_32s_C4IR:=getProc(hh,'ippiLShiftC_32s_C4IR');
  ippiLShiftC_32s_AC4IR:=getProc(hh,'ippiLShiftC_32s_AC4IR');
  ippiRShiftC_8u_C1R:=getProc(hh,'ippiRShiftC_8u_C1R');
  ippiRShiftC_8u_C3R:=getProc(hh,'ippiRShiftC_8u_C3R');
  ippiRShiftC_8u_C4R:=getProc(hh,'ippiRShiftC_8u_C4R');
  ippiRShiftC_8u_AC4R:=getProc(hh,'ippiRShiftC_8u_AC4R');
  ippiRShiftC_8u_C1IR:=getProc(hh,'ippiRShiftC_8u_C1IR');
  ippiRShiftC_8u_C3IR:=getProc(hh,'ippiRShiftC_8u_C3IR');
  ippiRShiftC_8u_C4IR:=getProc(hh,'ippiRShiftC_8u_C4IR');
  ippiRShiftC_8u_AC4IR:=getProc(hh,'ippiRShiftC_8u_AC4IR');
  ippiRShiftC_16u_C1R:=getProc(hh,'ippiRShiftC_16u_C1R');
  ippiRShiftC_16u_C3R:=getProc(hh,'ippiRShiftC_16u_C3R');
  ippiRShiftC_16u_C4R:=getProc(hh,'ippiRShiftC_16u_C4R');
  ippiRShiftC_16u_AC4R:=getProc(hh,'ippiRShiftC_16u_AC4R');
  ippiRShiftC_16u_C1IR:=getProc(hh,'ippiRShiftC_16u_C1IR');
  ippiRShiftC_16u_C3IR:=getProc(hh,'ippiRShiftC_16u_C3IR');
  ippiRShiftC_16u_C4IR:=getProc(hh,'ippiRShiftC_16u_C4IR');
  ippiRShiftC_16u_AC4IR:=getProc(hh,'ippiRShiftC_16u_AC4IR');
  ippiRShiftC_16s_C1R:=getProc(hh,'ippiRShiftC_16s_C1R');
  ippiRShiftC_16s_C3R:=getProc(hh,'ippiRShiftC_16s_C3R');
  ippiRShiftC_16s_C4R:=getProc(hh,'ippiRShiftC_16s_C4R');
  ippiRShiftC_16s_AC4R:=getProc(hh,'ippiRShiftC_16s_AC4R');
  ippiRShiftC_16s_C1IR:=getProc(hh,'ippiRShiftC_16s_C1IR');
  ippiRShiftC_16s_C3IR:=getProc(hh,'ippiRShiftC_16s_C3IR');
  ippiRShiftC_16s_C4IR:=getProc(hh,'ippiRShiftC_16s_C4IR');
  ippiRShiftC_16s_AC4IR:=getProc(hh,'ippiRShiftC_16s_AC4IR');
  ippiRShiftC_32s_C1R:=getProc(hh,'ippiRShiftC_32s_C1R');
  ippiRShiftC_32s_C3R:=getProc(hh,'ippiRShiftC_32s_C3R');
  ippiRShiftC_32s_C4R:=getProc(hh,'ippiRShiftC_32s_C4R');
  ippiRShiftC_32s_AC4R:=getProc(hh,'ippiRShiftC_32s_AC4R');
  ippiRShiftC_32s_C1IR:=getProc(hh,'ippiRShiftC_32s_C1IR');
  ippiRShiftC_32s_C3IR:=getProc(hh,'ippiRShiftC_32s_C3IR');
  ippiRShiftC_32s_C4IR:=getProc(hh,'ippiRShiftC_32s_C4IR');
  ippiRShiftC_32s_AC4IR:=getProc(hh,'ippiRShiftC_32s_AC4IR');
  ippiCompare_8u_C1R:=getProc(hh,'ippiCompare_8u_C1R');
  ippiCompare_8u_C3R:=getProc(hh,'ippiCompare_8u_C3R');
  ippiCompare_8u_AC4R:=getProc(hh,'ippiCompare_8u_AC4R');
  ippiCompare_8u_C4R:=getProc(hh,'ippiCompare_8u_C4R');
  ippiCompareC_8u_C1R:=getProc(hh,'ippiCompareC_8u_C1R');
  ippiCompareC_8u_C3R:=getProc(hh,'ippiCompareC_8u_C3R');
  ippiCompareC_8u_AC4R:=getProc(hh,'ippiCompareC_8u_AC4R');
  ippiCompareC_8u_C4R:=getProc(hh,'ippiCompareC_8u_C4R');
  ippiCompare_16s_C1R:=getProc(hh,'ippiCompare_16s_C1R');
  ippiCompare_16s_C3R:=getProc(hh,'ippiCompare_16s_C3R');
  ippiCompare_16s_AC4R:=getProc(hh,'ippiCompare_16s_AC4R');
  ippiCompare_16s_C4R:=getProc(hh,'ippiCompare_16s_C4R');
  ippiCompareC_16s_C1R:=getProc(hh,'ippiCompareC_16s_C1R');
  ippiCompareC_16s_C3R:=getProc(hh,'ippiCompareC_16s_C3R');
  ippiCompareC_16s_AC4R:=getProc(hh,'ippiCompareC_16s_AC4R');
  ippiCompareC_16s_C4R:=getProc(hh,'ippiCompareC_16s_C4R');
  ippiCompare_16u_C1R:=getProc(hh,'ippiCompare_16u_C1R');
  ippiCompare_16u_C3R:=getProc(hh,'ippiCompare_16u_C3R');
  ippiCompare_16u_AC4R:=getProc(hh,'ippiCompare_16u_AC4R');
  ippiCompare_16u_C4R:=getProc(hh,'ippiCompare_16u_C4R');
  ippiCompareC_16u_C1R:=getProc(hh,'ippiCompareC_16u_C1R');
  ippiCompareC_16u_C3R:=getProc(hh,'ippiCompareC_16u_C3R');
  ippiCompareC_16u_AC4R:=getProc(hh,'ippiCompareC_16u_AC4R');
  ippiCompareC_16u_C4R:=getProc(hh,'ippiCompareC_16u_C4R');
  ippiCompare_32f_C1R:=getProc(hh,'ippiCompare_32f_C1R');
  ippiCompare_32f_C3R:=getProc(hh,'ippiCompare_32f_C3R');
  ippiCompare_32f_AC4R:=getProc(hh,'ippiCompare_32f_AC4R');
  ippiCompare_32f_C4R:=getProc(hh,'ippiCompare_32f_C4R');
  ippiCompareC_32f_C1R:=getProc(hh,'ippiCompareC_32f_C1R');
  ippiCompareC_32f_C3R:=getProc(hh,'ippiCompareC_32f_C3R');
  ippiCompareC_32f_AC4R:=getProc(hh,'ippiCompareC_32f_AC4R');
  ippiCompareC_32f_C4R:=getProc(hh,'ippiCompareC_32f_C4R');
  ippiCompareEqualEps_32f_C1R:=getProc(hh,'ippiCompareEqualEps_32f_C1R');
  ippiCompareEqualEps_32f_C3R:=getProc(hh,'ippiCompareEqualEps_32f_C3R');
  ippiCompareEqualEps_32f_AC4R:=getProc(hh,'ippiCompareEqualEps_32f_AC4R');
  ippiCompareEqualEps_32f_C4R:=getProc(hh,'ippiCompareEqualEps_32f_C4R');
  ippiCompareEqualEpsC_32f_C1R:=getProc(hh,'ippiCompareEqualEpsC_32f_C1R');
  ippiCompareEqualEpsC_32f_C3R:=getProc(hh,'ippiCompareEqualEpsC_32f_C3R');
  ippiCompareEqualEpsC_32f_AC4R:=getProc(hh,'ippiCompareEqualEpsC_32f_AC4R');
  ippiCompareEqualEpsC_32f_C4R:=getProc(hh,'ippiCompareEqualEpsC_32f_C4R');
  ippiErode3x3_64f_C1R:=getProc(hh,'ippiErode3x3_64f_C1R');
  ippiDilate3x3_64f_C1R:=getProc(hh,'ippiDilate3x3_64f_C1R');
  ippiZigzagInv8x8_16s_C1:=getProc(hh,'ippiZigzagInv8x8_16s_C1');
  ippiZigzagFwd8x8_16s_C1:=getProc(hh,'ippiZigzagFwd8x8_16s_C1');
  ippiWinBartlett_8u_C1R:=getProc(hh,'ippiWinBartlett_8u_C1R');
  ippiWinBartlett_16u_C1R:=getProc(hh,'ippiWinBartlett_16u_C1R');
  ippiWinBartlett_32f_C1R:=getProc(hh,'ippiWinBartlett_32f_C1R');
  ippiWinBartlett_8u_C1IR:=getProc(hh,'ippiWinBartlett_8u_C1IR');
  ippiWinBartlett_16u_C1IR:=getProc(hh,'ippiWinBartlett_16u_C1IR');
  ippiWinBartlett_32f_C1IR:=getProc(hh,'ippiWinBartlett_32f_C1IR');
  ippiWinBartlettSep_8u_C1R:=getProc(hh,'ippiWinBartlettSep_8u_C1R');
  ippiWinBartlettSep_16u_C1R:=getProc(hh,'ippiWinBartlettSep_16u_C1R');
  ippiWinBartlettSep_32f_C1R:=getProc(hh,'ippiWinBartlettSep_32f_C1R');
  ippiWinBartlettSep_8u_C1IR:=getProc(hh,'ippiWinBartlettSep_8u_C1IR');
  ippiWinBartlettSep_16u_C1IR:=getProc(hh,'ippiWinBartlettSep_16u_C1IR');
  ippiWinBartlettSep_32f_C1IR:=getProc(hh,'ippiWinBartlettSep_32f_C1IR');
  ippiWinBartlettGetBufferSize:=getProc(hh,'ippiWinBartlettGetBufferSize');
  ippiWinBartlettSepGetBufferSize:=getProc(hh,'ippiWinBartlettSepGetBufferSize');
  ippiWinHamming_8u_C1R:=getProc(hh,'ippiWinHamming_8u_C1R');
  ippiWinHamming_16u_C1R:=getProc(hh,'ippiWinHamming_16u_C1R');
  ippiWinHamming_32f_C1R:=getProc(hh,'ippiWinHamming_32f_C1R');
  ippiWinHamming_8u_C1IR:=getProc(hh,'ippiWinHamming_8u_C1IR');
  ippiWinHamming_16u_C1IR:=getProc(hh,'ippiWinHamming_16u_C1IR');
  ippiWinHamming_32f_C1IR:=getProc(hh,'ippiWinHamming_32f_C1IR');
  ippiWinHammingSep_8u_C1R:=getProc(hh,'ippiWinHammingSep_8u_C1R');
  ippiWinHammingSep_16u_C1R:=getProc(hh,'ippiWinHammingSep_16u_C1R');
  ippiWinHammingSep_32f_C1R:=getProc(hh,'ippiWinHammingSep_32f_C1R');
  ippiWinHammingSep_8u_C1IR:=getProc(hh,'ippiWinHammingSep_8u_C1IR');
  ippiWinHammingSep_16u_C1IR:=getProc(hh,'ippiWinHammingSep_16u_C1IR');
  ippiWinHammingSep_32f_C1IR:=getProc(hh,'ippiWinHammingSep_32f_C1IR');
  ippiWinHammingGetBufferSize:=getProc(hh,'ippiWinHammingGetBufferSize');
  ippiWinHammingSepGetBufferSize:=getProc(hh,'ippiWinHammingSepGetBufferSize');
  ippiTranspose_8u_C1R:=getProc(hh,'ippiTranspose_8u_C1R');
  ippiTranspose_8u_C3R:=getProc(hh,'ippiTranspose_8u_C3R');
  ippiTranspose_8u_C4R:=getProc(hh,'ippiTranspose_8u_C4R');
  ippiTranspose_8u_C1IR:=getProc(hh,'ippiTranspose_8u_C1IR');
  ippiTranspose_8u_C3IR:=getProc(hh,'ippiTranspose_8u_C3IR');
  ippiTranspose_8u_C4IR:=getProc(hh,'ippiTranspose_8u_C4IR');
  ippiTranspose_16u_C1R:=getProc(hh,'ippiTranspose_16u_C1R');
  ippiTranspose_16u_C3R:=getProc(hh,'ippiTranspose_16u_C3R');
  ippiTranspose_16u_C4R:=getProc(hh,'ippiTranspose_16u_C4R');
  ippiTranspose_16u_C1IR:=getProc(hh,'ippiTranspose_16u_C1IR');
  ippiTranspose_16u_C3IR:=getProc(hh,'ippiTranspose_16u_C3IR');
  ippiTranspose_16u_C4IR:=getProc(hh,'ippiTranspose_16u_C4IR');
  ippiTranspose_16s_C1R:=getProc(hh,'ippiTranspose_16s_C1R');
  ippiTranspose_16s_C3R:=getProc(hh,'ippiTranspose_16s_C3R');
  ippiTranspose_16s_C4R:=getProc(hh,'ippiTranspose_16s_C4R');
  ippiTranspose_16s_C1IR:=getProc(hh,'ippiTranspose_16s_C1IR');
  ippiTranspose_16s_C3IR:=getProc(hh,'ippiTranspose_16s_C3IR');
  ippiTranspose_16s_C4IR:=getProc(hh,'ippiTranspose_16s_C4IR');
  ippiTranspose_32s_C1R:=getProc(hh,'ippiTranspose_32s_C1R');
  ippiTranspose_32s_C3R:=getProc(hh,'ippiTranspose_32s_C3R');
  ippiTranspose_32s_C4R:=getProc(hh,'ippiTranspose_32s_C4R');
  ippiTranspose_32s_C1IR:=getProc(hh,'ippiTranspose_32s_C1IR');
  ippiTranspose_32s_C3IR:=getProc(hh,'ippiTranspose_32s_C3IR');
  ippiTranspose_32s_C4IR:=getProc(hh,'ippiTranspose_32s_C4IR');
  ippiTranspose_32f_C1R:=getProc(hh,'ippiTranspose_32f_C1R');
  ippiTranspose_32f_C3R:=getProc(hh,'ippiTranspose_32f_C3R');
  ippiTranspose_32f_C4R:=getProc(hh,'ippiTranspose_32f_C4R');
  ippiTranspose_32f_C1IR:=getProc(hh,'ippiTranspose_32f_C1IR');
  ippiTranspose_32f_C3IR:=getProc(hh,'ippiTranspose_32f_C3IR');
  ippiTranspose_32f_C4IR:=getProc(hh,'ippiTranspose_32f_C4IR');
  ippiDeconvFFTGetSize_32f:=getProc(hh,'ippiDeconvFFTGetSize_32f');
  ippiDeconvFFTInit_32f_C1R:=getProc(hh,'ippiDeconvFFTInit_32f_C1R');
  ippiDeconvFFTInit_32f_C3R:=getProc(hh,'ippiDeconvFFTInit_32f_C3R');
  ippiDeconvFFT_32f_C1R:=getProc(hh,'ippiDeconvFFT_32f_C1R');
  ippiDeconvFFT_32f_C3R:=getProc(hh,'ippiDeconvFFT_32f_C3R');
  ippiDeconvLRGetSize_32f:=getProc(hh,'ippiDeconvLRGetSize_32f');
  ippiDeconvLRInit_32f_C1R:=getProc(hh,'ippiDeconvLRInit_32f_C1R');
  ippiDeconvLRInit_32f_C3R:=getProc(hh,'ippiDeconvLRInit_32f_C3R');
  ippiDeconvLR_32f_C1R:=getProc(hh,'ippiDeconvLR_32f_C1R');
  ippiDeconvLR_32f_C3R:=getProc(hh,'ippiDeconvLR_32f_C3R');
  ippiCompColorKey_8u_C1R:=getProc(hh,'ippiCompColorKey_8u_C1R');
  ippiCompColorKey_8u_C3R:=getProc(hh,'ippiCompColorKey_8u_C3R');
  ippiCompColorKey_8u_C4R:=getProc(hh,'ippiCompColorKey_8u_C4R');
  ippiCompColorKey_16u_C1R:=getProc(hh,'ippiCompColorKey_16u_C1R');
  ippiCompColorKey_16u_C3R:=getProc(hh,'ippiCompColorKey_16u_C3R');
  ippiCompColorKey_16u_C4R:=getProc(hh,'ippiCompColorKey_16u_C4R');
  ippiCompColorKey_16s_C1R:=getProc(hh,'ippiCompColorKey_16s_C1R');
  ippiCompColorKey_16s_C3R:=getProc(hh,'ippiCompColorKey_16s_C3R');
  ippiCompColorKey_16s_C4R:=getProc(hh,'ippiCompColorKey_16s_C4R');
  ippiAlphaCompColorKey_8u_AC4R:=getProc(hh,'ippiAlphaCompColorKey_8u_AC4R');
  ippiMedian_8u_P3C1R:=getProc(hh,'ippiMedian_8u_P3C1R');
  ippiDeinterlaceFilterCAVT_8u_C1R:=getProc(hh,'ippiDeinterlaceFilterCAVT_8u_C1R');
  ippiFilterBilateralBorderGetBufferSize:=getProc(hh,'ippiFilterBilateralBorderGetBufferSize');
  ippiFilterBilateralBorderInit:=getProc(hh,'ippiFilterBilateralBorderInit');
  ippiFilterBilateralBorder_8u_C1R:=getProc(hh,'ippiFilterBilateralBorder_8u_C1R');
  ippiFilterBilateralBorder_8u_C3R:=getProc(hh,'ippiFilterBilateralBorder_8u_C3R');
  ippiFilterBilateralBorder_32f_C1R:=getProc(hh,'ippiFilterBilateralBorder_32f_C1R');
  ippiFilterBilateralBorder_32f_C3R:=getProc(hh,'ippiFilterBilateralBorder_32f_C3R');
  ippiFilterGetBufSize_64f_C1R:=getProc(hh,'ippiFilterGetBufSize_64f_C1R');
  ippiFilter_64f_C1R:=getProc(hh,'ippiFilter_64f_C1R');
  ippiDiv_Round_16s_C1RSfs:=getProc(hh,'ippiDiv_Round_16s_C1RSfs');
  ippiDiv_Round_16s_C3RSfs:=getProc(hh,'ippiDiv_Round_16s_C3RSfs');
  ippiDiv_Round_16s_C4RSfs:=getProc(hh,'ippiDiv_Round_16s_C4RSfs');
  ippiDiv_Round_16s_AC4RSfs:=getProc(hh,'ippiDiv_Round_16s_AC4RSfs');
  ippiDiv_Round_8u_C1RSfs:=getProc(hh,'ippiDiv_Round_8u_C1RSfs');
  ippiDiv_Round_8u_C3RSfs:=getProc(hh,'ippiDiv_Round_8u_C3RSfs');
  ippiDiv_Round_8u_C4RSfs:=getProc(hh,'ippiDiv_Round_8u_C4RSfs');
  ippiDiv_Round_8u_AC4RSfs:=getProc(hh,'ippiDiv_Round_8u_AC4RSfs');
  ippiDiv_Round_16u_C1RSfs:=getProc(hh,'ippiDiv_Round_16u_C1RSfs');
  ippiDiv_Round_16u_C3RSfs:=getProc(hh,'ippiDiv_Round_16u_C3RSfs');
  ippiDiv_Round_16u_C4RSfs:=getProc(hh,'ippiDiv_Round_16u_C4RSfs');
  ippiDiv_Round_16u_AC4RSfs:=getProc(hh,'ippiDiv_Round_16u_AC4RSfs');
  ippiDiv_Round_16s_C1IRSfs:=getProc(hh,'ippiDiv_Round_16s_C1IRSfs');
  ippiDiv_Round_16s_C3IRSfs:=getProc(hh,'ippiDiv_Round_16s_C3IRSfs');
  ippiDiv_Round_16s_C4IRSfs:=getProc(hh,'ippiDiv_Round_16s_C4IRSfs');
  ippiDiv_Round_16s_AC4IRSfs:=getProc(hh,'ippiDiv_Round_16s_AC4IRSfs');
  ippiDiv_Round_8u_C1IRSfs:=getProc(hh,'ippiDiv_Round_8u_C1IRSfs');
  ippiDiv_Round_8u_C3IRSfs:=getProc(hh,'ippiDiv_Round_8u_C3IRSfs');
  ippiDiv_Round_8u_C4IRSfs:=getProc(hh,'ippiDiv_Round_8u_C4IRSfs');
  ippiDiv_Round_8u_AC4IRSfs:=getProc(hh,'ippiDiv_Round_8u_AC4IRSfs');
  ippiDiv_Round_16u_C1IRSfs:=getProc(hh,'ippiDiv_Round_16u_C1IRSfs');
  ippiDiv_Round_16u_C3IRSfs:=getProc(hh,'ippiDiv_Round_16u_C3IRSfs');
  ippiDiv_Round_16u_C4IRSfs:=getProc(hh,'ippiDiv_Round_16u_C4IRSfs');
  ippiDiv_Round_16u_AC4IRSfs:=getProc(hh,'ippiDiv_Round_16u_AC4IRSfs');
  ippiResizeGetSize_8u:=getProc(hh,'ippiResizeGetSize_8u');
  ippiResizeGetSize_16u:=getProc(hh,'ippiResizeGetSize_16u');
  ippiResizeGetSize_16s:=getProc(hh,'ippiResizeGetSize_16s');
  ippiResizeGetSize_32f:=getProc(hh,'ippiResizeGetSize_32f');
  ippiResizeGetSize_64f:=getProc(hh,'ippiResizeGetSize_64f');
  ippiResizeGetBufferSize_8u:=getProc(hh,'ippiResizeGetBufferSize_8u');
  ippiResizeGetBufferSize_16u:=getProc(hh,'ippiResizeGetBufferSize_16u');
  ippiResizeGetBufferSize_16s:=getProc(hh,'ippiResizeGetBufferSize_16s');
  ippiResizeGetBufferSize_32f:=getProc(hh,'ippiResizeGetBufferSize_32f');
  ippiResizeGetBufferSize_64f:=getProc(hh,'ippiResizeGetBufferSize_64f');
  ippiResizeGetBorderSize_8u:=getProc(hh,'ippiResizeGetBorderSize_8u');
  ippiResizeGetBorderSize_16u:=getProc(hh,'ippiResizeGetBorderSize_16u');
  ippiResizeGetBorderSize_16s:=getProc(hh,'ippiResizeGetBorderSize_16s');
  ippiResizeGetBorderSize_32f:=getProc(hh,'ippiResizeGetBorderSize_32f');
  ippiResizeGetBorderSize_64f:=getProc(hh,'ippiResizeGetBorderSize_64f');
  ippiResizeGetSrcOffset_8u:=getProc(hh,'ippiResizeGetSrcOffset_8u');
  ippiResizeGetSrcOffset_16u:=getProc(hh,'ippiResizeGetSrcOffset_16u');
  ippiResizeGetSrcOffset_16s:=getProc(hh,'ippiResizeGetSrcOffset_16s');
  ippiResizeGetSrcOffset_32f:=getProc(hh,'ippiResizeGetSrcOffset_32f');
  ippiResizeGetSrcOffset_64f:=getProc(hh,'ippiResizeGetSrcOffset_64f');
  ippiResizeGetSrcRoi_8u:=getProc(hh,'ippiResizeGetSrcRoi_8u');
  ippiResizeGetSrcRoi_16u:=getProc(hh,'ippiResizeGetSrcRoi_16u');
  ippiResizeGetSrcRoi_16s:=getProc(hh,'ippiResizeGetSrcRoi_16s');
  ippiResizeGetSrcRoi_32f:=getProc(hh,'ippiResizeGetSrcRoi_32f');
  ippiResizeGetSrcRoi_64f:=getProc(hh,'ippiResizeGetSrcRoi_64f');
  ippiResizeNearestInit_8u:=getProc(hh,'ippiResizeNearestInit_8u');
  ippiResizeNearestInit_16u:=getProc(hh,'ippiResizeNearestInit_16u');
  ippiResizeNearestInit_16s:=getProc(hh,'ippiResizeNearestInit_16s');
  ippiResizeNearestInit_32f:=getProc(hh,'ippiResizeNearestInit_32f');
  ippiResizeLinearInit_8u:=getProc(hh,'ippiResizeLinearInit_8u');
  ippiResizeLinearInit_16u:=getProc(hh,'ippiResizeLinearInit_16u');
  ippiResizeLinearInit_16s:=getProc(hh,'ippiResizeLinearInit_16s');
  ippiResizeLinearInit_32f:=getProc(hh,'ippiResizeLinearInit_32f');
  ippiResizeLinearInit_64f:=getProc(hh,'ippiResizeLinearInit_64f');
  ippiResizeCubicInit_8u:=getProc(hh,'ippiResizeCubicInit_8u');
  ippiResizeCubicInit_16u:=getProc(hh,'ippiResizeCubicInit_16u');
  ippiResizeCubicInit_16s:=getProc(hh,'ippiResizeCubicInit_16s');
  ippiResizeCubicInit_32f:=getProc(hh,'ippiResizeCubicInit_32f');
  ippiResizeLanczosInit_8u:=getProc(hh,'ippiResizeLanczosInit_8u');
  ippiResizeLanczosInit_16u:=getProc(hh,'ippiResizeLanczosInit_16u');
  ippiResizeLanczosInit_16s:=getProc(hh,'ippiResizeLanczosInit_16s');
  ippiResizeLanczosInit_32f:=getProc(hh,'ippiResizeLanczosInit_32f');
  ippiResizeSuperInit_8u:=getProc(hh,'ippiResizeSuperInit_8u');
  ippiResizeSuperInit_16u:=getProc(hh,'ippiResizeSuperInit_16u');
  ippiResizeSuperInit_16s:=getProc(hh,'ippiResizeSuperInit_16s');
  ippiResizeSuperInit_32f:=getProc(hh,'ippiResizeSuperInit_32f');
  ippiResizeNearest_8u_C1R:=getProc(hh,'ippiResizeNearest_8u_C1R');
  ippiResizeNearest_8u_C3R:=getProc(hh,'ippiResizeNearest_8u_C3R');
  ippiResizeNearest_8u_C4R:=getProc(hh,'ippiResizeNearest_8u_C4R');
  ippiResizeNearest_16u_C1R:=getProc(hh,'ippiResizeNearest_16u_C1R');
  ippiResizeNearest_16u_C3R:=getProc(hh,'ippiResizeNearest_16u_C3R');
  ippiResizeNearest_16u_C4R:=getProc(hh,'ippiResizeNearest_16u_C4R');
  ippiResizeNearest_16s_C1R:=getProc(hh,'ippiResizeNearest_16s_C1R');
  ippiResizeNearest_16s_C3R:=getProc(hh,'ippiResizeNearest_16s_C3R');
  ippiResizeNearest_16s_C4R:=getProc(hh,'ippiResizeNearest_16s_C4R');
  ippiResizeNearest_32f_C1R:=getProc(hh,'ippiResizeNearest_32f_C1R');
  ippiResizeNearest_32f_C3R:=getProc(hh,'ippiResizeNearest_32f_C3R');
  ippiResizeNearest_32f_C4R:=getProc(hh,'ippiResizeNearest_32f_C4R');
  ippiResizeLinear_8u_C1R:=getProc(hh,'ippiResizeLinear_8u_C1R');
  ippiResizeLinear_8u_C3R:=getProc(hh,'ippiResizeLinear_8u_C3R');
  ippiResizeLinear_8u_C4R:=getProc(hh,'ippiResizeLinear_8u_C4R');
  ippiResizeLinear_16u_C1R:=getProc(hh,'ippiResizeLinear_16u_C1R');
  ippiResizeLinear_16u_C3R:=getProc(hh,'ippiResizeLinear_16u_C3R');
  ippiResizeLinear_16u_C4R:=getProc(hh,'ippiResizeLinear_16u_C4R');
  ippiResizeLinear_16s_C1R:=getProc(hh,'ippiResizeLinear_16s_C1R');
  ippiResizeLinear_16s_C3R:=getProc(hh,'ippiResizeLinear_16s_C3R');
  ippiResizeLinear_16s_C4R:=getProc(hh,'ippiResizeLinear_16s_C4R');
  ippiResizeLinear_32f_C1R:=getProc(hh,'ippiResizeLinear_32f_C1R');
  ippiResizeLinear_32f_C3R:=getProc(hh,'ippiResizeLinear_32f_C3R');
  ippiResizeLinear_32f_C4R:=getProc(hh,'ippiResizeLinear_32f_C4R');
  ippiResizeLinear_64f_C1R:=getProc(hh,'ippiResizeLinear_64f_C1R');
  ippiResizeLinear_64f_C3R:=getProc(hh,'ippiResizeLinear_64f_C3R');
  ippiResizeLinear_64f_C4R:=getProc(hh,'ippiResizeLinear_64f_C4R');
  ippiResizeCubic_8u_C1R:=getProc(hh,'ippiResizeCubic_8u_C1R');
  ippiResizeCubic_8u_C3R:=getProc(hh,'ippiResizeCubic_8u_C3R');
  ippiResizeCubic_8u_C4R:=getProc(hh,'ippiResizeCubic_8u_C4R');
  ippiResizeCubic_16u_C1R:=getProc(hh,'ippiResizeCubic_16u_C1R');
  ippiResizeCubic_16u_C3R:=getProc(hh,'ippiResizeCubic_16u_C3R');
  ippiResizeCubic_16u_C4R:=getProc(hh,'ippiResizeCubic_16u_C4R');
  ippiResizeCubic_16s_C1R:=getProc(hh,'ippiResizeCubic_16s_C1R');
  ippiResizeCubic_16s_C3R:=getProc(hh,'ippiResizeCubic_16s_C3R');
  ippiResizeCubic_16s_C4R:=getProc(hh,'ippiResizeCubic_16s_C4R');
  ippiResizeCubic_32f_C1R:=getProc(hh,'ippiResizeCubic_32f_C1R');
  ippiResizeCubic_32f_C3R:=getProc(hh,'ippiResizeCubic_32f_C3R');
  ippiResizeCubic_32f_C4R:=getProc(hh,'ippiResizeCubic_32f_C4R');
  ippiResizeLanczos_8u_C1R:=getProc(hh,'ippiResizeLanczos_8u_C1R');
  ippiResizeLanczos_8u_C3R:=getProc(hh,'ippiResizeLanczos_8u_C3R');
  ippiResizeLanczos_8u_C4R:=getProc(hh,'ippiResizeLanczos_8u_C4R');
  ippiResizeLanczos_16u_C1R:=getProc(hh,'ippiResizeLanczos_16u_C1R');
  ippiResizeLanczos_16u_C3R:=getProc(hh,'ippiResizeLanczos_16u_C3R');
  ippiResizeLanczos_16u_C4R:=getProc(hh,'ippiResizeLanczos_16u_C4R');
  ippiResizeLanczos_16s_C1R:=getProc(hh,'ippiResizeLanczos_16s_C1R');
  ippiResizeLanczos_16s_C3R:=getProc(hh,'ippiResizeLanczos_16s_C3R');
  ippiResizeLanczos_16s_C4R:=getProc(hh,'ippiResizeLanczos_16s_C4R');
  ippiResizeLanczos_32f_C1R:=getProc(hh,'ippiResizeLanczos_32f_C1R');
  ippiResizeLanczos_32f_C3R:=getProc(hh,'ippiResizeLanczos_32f_C3R');
  ippiResizeLanczos_32f_C4R:=getProc(hh,'ippiResizeLanczos_32f_C4R');
  ippiResizeSuper_8u_C1R:=getProc(hh,'ippiResizeSuper_8u_C1R');
  ippiResizeSuper_8u_C3R:=getProc(hh,'ippiResizeSuper_8u_C3R');
  ippiResizeSuper_8u_C4R:=getProc(hh,'ippiResizeSuper_8u_C4R');
  ippiResizeSuper_16u_C1R:=getProc(hh,'ippiResizeSuper_16u_C1R');
  ippiResizeSuper_16u_C3R:=getProc(hh,'ippiResizeSuper_16u_C3R');
  ippiResizeSuper_16u_C4R:=getProc(hh,'ippiResizeSuper_16u_C4R');
  ippiResizeSuper_16s_C1R:=getProc(hh,'ippiResizeSuper_16s_C1R');
  ippiResizeSuper_16s_C3R:=getProc(hh,'ippiResizeSuper_16s_C3R');
  ippiResizeSuper_16s_C4R:=getProc(hh,'ippiResizeSuper_16s_C4R');
  ippiResizeSuper_32f_C1R:=getProc(hh,'ippiResizeSuper_32f_C1R');
  ippiResizeSuper_32f_C3R:=getProc(hh,'ippiResizeSuper_32f_C3R');
  ippiResizeSuper_32f_C4R:=getProc(hh,'ippiResizeSuper_32f_C4R');
  ippiResizeAntialiasingLinearInit:=getProc(hh,'ippiResizeAntialiasingLinearInit');
  ippiResizeAntialiasingCubicInit:=getProc(hh,'ippiResizeAntialiasingCubicInit');
  ippiResizeAntialiasingLanczosInit:=getProc(hh,'ippiResizeAntialiasingLanczosInit');
  ippiResizeAntialiasing_8u_C1R:=getProc(hh,'ippiResizeAntialiasing_8u_C1R');
  ippiResizeAntialiasing_8u_C3R:=getProc(hh,'ippiResizeAntialiasing_8u_C3R');
  ippiResizeAntialiasing_8u_C4R:=getProc(hh,'ippiResizeAntialiasing_8u_C4R');
  ippiResizeAntialiasing_16u_C1R:=getProc(hh,'ippiResizeAntialiasing_16u_C1R');
  ippiResizeAntialiasing_16u_C3R:=getProc(hh,'ippiResizeAntialiasing_16u_C3R');
  ippiResizeAntialiasing_16u_C4R:=getProc(hh,'ippiResizeAntialiasing_16u_C4R');
  ippiResizeAntialiasing_16s_C1R:=getProc(hh,'ippiResizeAntialiasing_16s_C1R');
  ippiResizeAntialiasing_16s_C3R:=getProc(hh,'ippiResizeAntialiasing_16s_C3R');
  ippiResizeAntialiasing_16s_C4R:=getProc(hh,'ippiResizeAntialiasing_16s_C4R');
  ippiResizeAntialiasing_32f_C1R:=getProc(hh,'ippiResizeAntialiasing_32f_C1R');
  ippiResizeAntialiasing_32f_C3R:=getProc(hh,'ippiResizeAntialiasing_32f_C3R');
  ippiResizeAntialiasing_32f_C4R:=getProc(hh,'ippiResizeAntialiasing_32f_C4R');
  ippiResizeYUV422GetSize:=getProc(hh,'ippiResizeYUV422GetSize');
  ippiResizeYUV422GetBufSize:=getProc(hh,'ippiResizeYUV422GetBufSize');
  ippiResizeYUV422GetBorderSize:=getProc(hh,'ippiResizeYUV422GetBorderSize');
  ippiResizeYUV422GetSrcOffset:=getProc(hh,'ippiResizeYUV422GetSrcOffset');
  ippiResizeYUV422GetSrcRoi:=getProc(hh,'ippiResizeYUV422GetSrcRoi');
  ippiResizeYUV422NearestInit:=getProc(hh,'ippiResizeYUV422NearestInit');
  ippiResizeYUV422LinearInit:=getProc(hh,'ippiResizeYUV422LinearInit');
  ippiResizeYUV422Nearest_8u_C2R:=getProc(hh,'ippiResizeYUV422Nearest_8u_C2R');
  ippiResizeYUV422Linear_8u_C2R:=getProc(hh,'ippiResizeYUV422Linear_8u_C2R');
  ippiResizeYUV420GetSize:=getProc(hh,'ippiResizeYUV420GetSize');
  ippiResizeYUV420GetBufferSize:=getProc(hh,'ippiResizeYUV420GetBufferSize');
  ippiResizeYUV420GetBorderSize:=getProc(hh,'ippiResizeYUV420GetBorderSize');
  ippiResizeYUV420GetSrcOffset:=getProc(hh,'ippiResizeYUV420GetSrcOffset');
  ippiResizeYUV420GetSrcRoi:=getProc(hh,'ippiResizeYUV420GetSrcRoi');
  ippiResizeYUV420LanczosInit:=getProc(hh,'ippiResizeYUV420LanczosInit');
  ippiResizeYUV420SuperInit:=getProc(hh,'ippiResizeYUV420SuperInit');
  ippiResizeYUV420Lanczos_8u_P2R:=getProc(hh,'ippiResizeYUV420Lanczos_8u_P2R');
  ippiResizeYUV420Super_8u_P2R:=getProc(hh,'ippiResizeYUV420Super_8u_P2R');
  ippiFilterBorderGetSize:=getProc(hh,'ippiFilterBorderGetSize');
  ippiFilterBorderInit_16s:=getProc(hh,'ippiFilterBorderInit_16s');
  ippiFilterBorderInit_32f:=getProc(hh,'ippiFilterBorderInit_32f');
  ippiFilterBorder_8u_C1R:=getProc(hh,'ippiFilterBorder_8u_C1R');
  ippiFilterBorder_8u_C3R:=getProc(hh,'ippiFilterBorder_8u_C3R');
  ippiFilterBorder_8u_C4R:=getProc(hh,'ippiFilterBorder_8u_C4R');
  ippiFilterBorder_16u_C1R:=getProc(hh,'ippiFilterBorder_16u_C1R');
  ippiFilterBorder_16u_C3R:=getProc(hh,'ippiFilterBorder_16u_C3R');
  ippiFilterBorder_16u_C4R:=getProc(hh,'ippiFilterBorder_16u_C4R');
  ippiFilterBorder_16s_C1R:=getProc(hh,'ippiFilterBorder_16s_C1R');
  ippiFilterBorder_16s_C3R:=getProc(hh,'ippiFilterBorder_16s_C3R');
  ippiFilterBorder_16s_C4R:=getProc(hh,'ippiFilterBorder_16s_C4R');
  ippiFilterBorder_32f_C1R:=getProc(hh,'ippiFilterBorder_32f_C1R');
  ippiFilterBorder_32f_C3R:=getProc(hh,'ippiFilterBorder_32f_C3R');
  ippiFilterBorder_32f_C4R:=getProc(hh,'ippiFilterBorder_32f_C4R');
  ippiFilterBorderSetMode:=getProc(hh,'ippiFilterBorderSetMode');
  ippiLBPImageMode3x3_8u_C1R:=getProc(hh,'ippiLBPImageMode3x3_8u_C1R');
  ippiLBPImageMode5x5_8u_C1R:=getProc(hh,'ippiLBPImageMode5x5_8u_C1R');
  ippiLBPImageMode5x5_8u16u_C1R:=getProc(hh,'ippiLBPImageMode5x5_8u16u_C1R');
  ippiLBPImageMode3x3_32f8u_C1R:=getProc(hh,'ippiLBPImageMode3x3_32f8u_C1R');
  ippiLBPImageMode5x5_32f8u_C1R:=getProc(hh,'ippiLBPImageMode5x5_32f8u_C1R');
  ippiLBPImageMode5x5_32f16u_C1R:=getProc(hh,'ippiLBPImageMode5x5_32f16u_C1R');
  ippiLBPImageHorizCorr_8u_C1R:=getProc(hh,'ippiLBPImageHorizCorr_8u_C1R');
  ippiLBPImageHorizCorr_16u_C1R:=getProc(hh,'ippiLBPImageHorizCorr_16u_C1R');
  ippiSADGetBufferSize:=getProc(hh,'ippiSADGetBufferSize');
  ippiSAD_8u32s_C1RSfs:=getProc(hh,'ippiSAD_8u32s_C1RSfs');
  ippiSAD_16u32s_C1RSfs:=getProc(hh,'ippiSAD_16u32s_C1RSfs');
  ippiSAD_16s32s_C1RSfs:=getProc(hh,'ippiSAD_16s32s_C1RSfs');
  ippiSAD_32f_C1R:=getProc(hh,'ippiSAD_32f_C1R');
  ippiGradientVectorGetBufferSize:=getProc(hh,'ippiGradientVectorGetBufferSize');
  ippiGradientVectorSobel_8u16s_C1R:=getProc(hh,'ippiGradientVectorSobel_8u16s_C1R');
  ippiGradientVectorSobel_16u32f_C1R:=getProc(hh,'ippiGradientVectorSobel_16u32f_C1R');
  ippiGradientVectorSobel_16s32f_C1R:=getProc(hh,'ippiGradientVectorSobel_16s32f_C1R');
  ippiGradientVectorSobel_32f_C1R:=getProc(hh,'ippiGradientVectorSobel_32f_C1R');
  ippiGradientVectorScharr_8u16s_C1R:=getProc(hh,'ippiGradientVectorScharr_8u16s_C1R');
  ippiGradientVectorScharr_16u32f_C1R:=getProc(hh,'ippiGradientVectorScharr_16u32f_C1R');
  ippiGradientVectorScharr_16s32f_C1R:=getProc(hh,'ippiGradientVectorScharr_16s32f_C1R');
  ippiGradientVectorScharr_32f_C1R:=getProc(hh,'ippiGradientVectorScharr_32f_C1R');
  ippiGradientVectorPrewitt_8u16s_C1R:=getProc(hh,'ippiGradientVectorPrewitt_8u16s_C1R');
  ippiGradientVectorPrewitt_16u32f_C1R:=getProc(hh,'ippiGradientVectorPrewitt_16u32f_C1R');
  ippiGradientVectorPrewitt_16s32f_C1R:=getProc(hh,'ippiGradientVectorPrewitt_16s32f_C1R');
  ippiGradientVectorPrewitt_32f_C1R:=getProc(hh,'ippiGradientVectorPrewitt_32f_C1R');
  ippiGradientVectorSobel_8u16s_C3C1R:=getProc(hh,'ippiGradientVectorSobel_8u16s_C3C1R');
  ippiGradientVectorSobel_16u32f_C3C1R:=getProc(hh,'ippiGradientVectorSobel_16u32f_C3C1R');
  ippiGradientVectorSobel_16s32f_C3C1R:=getProc(hh,'ippiGradientVectorSobel_16s32f_C3C1R');
  ippiGradientVectorSobel_32f_C3C1R:=getProc(hh,'ippiGradientVectorSobel_32f_C3C1R');
  ippiGradientVectorScharr_8u16s_C3C1R:=getProc(hh,'ippiGradientVectorScharr_8u16s_C3C1R');
  ippiGradientVectorScharr_16u32f_C3C1R:=getProc(hh,'ippiGradientVectorScharr_16u32f_C3C1R');
  ippiGradientVectorScharr_16s32f_C3C1R:=getProc(hh,'ippiGradientVectorScharr_16s32f_C3C1R');
  ippiGradientVectorScharr_32f_C3C1R:=getProc(hh,'ippiGradientVectorScharr_32f_C3C1R');
  ippiGradientVectorPrewitt_8u16s_C3C1R:=getProc(hh,'ippiGradientVectorPrewitt_8u16s_C3C1R');
  ippiGradientVectorPrewitt_16u32f_C3C1R:=getProc(hh,'ippiGradientVectorPrewitt_16u32f_C3C1R');
  ippiGradientVectorPrewitt_16s32f_C3C1R:=getProc(hh,'ippiGradientVectorPrewitt_16s32f_C3C1R');
  ippiGradientVectorPrewitt_32f_C3C1R:=getProc(hh,'ippiGradientVectorPrewitt_32f_C3C1R');
  ippiHOGGetSize:=getProc(hh,'ippiHOGGetSize');
  ippiHOGInit:=getProc(hh,'ippiHOGInit');
  ippiHOGGetBufferSize:=getProc(hh,'ippiHOGGetBufferSize');
  ippiHOGGetDescriptorSize:=getProc(hh,'ippiHOGGetDescriptorSize');
  ippiHOG_8u32f_C1R:=getProc(hh,'ippiHOG_8u32f_C1R');
  ippiHOG_16u32f_C1R:=getProc(hh,'ippiHOG_16u32f_C1R');
  ippiHOG_16s32f_C1R:=getProc(hh,'ippiHOG_16s32f_C1R');
  ippiHOG_32f_C1R:=getProc(hh,'ippiHOG_32f_C1R');
  ippiHOG_8u32f_C3R:=getProc(hh,'ippiHOG_8u32f_C3R');
  ippiHOG_16u32f_C3R:=getProc(hh,'ippiHOG_16u32f_C3R');
  ippiHOG_16s32f_C3R:=getProc(hh,'ippiHOG_16s32f_C3R');
  ippiHOG_32f_C3R:=getProc(hh,'ippiHOG_32f_C3R');
  ipprResizeGetBufSize:=getProc(hh,'ipprResizeGetBufSize');
  ipprGetResizeCuboid:=getProc(hh,'ipprGetResizeCuboid');
  ipprResize_8u_C1V:=getProc(hh,'ipprResize_8u_C1V');
  ipprResize_16u_C1V:=getProc(hh,'ipprResize_16u_C1V');
  ipprResize_32f_C1V:=getProc(hh,'ipprResize_32f_C1V');
  ipprResize_8u_C1PV:=getProc(hh,'ipprResize_8u_C1PV');
  ipprResize_16u_C1PV:=getProc(hh,'ipprResize_16u_C1PV');
  ipprResize_32f_C1PV:=getProc(hh,'ipprResize_32f_C1PV');
  ipprWarpAffineGetBufSize:=getProc(hh,'ipprWarpAffineGetBufSize');
  ipprWarpAffine_8u_C1PV:=getProc(hh,'ipprWarpAffine_8u_C1PV');
  ipprWarpAffine_16u_C1PV:=getProc(hh,'ipprWarpAffine_16u_C1PV');
  ipprWarpAffine_32f_C1PV:=getProc(hh,'ipprWarpAffine_32f_C1PV');
  ipprWarpAffine_8u_C1V:=getProc(hh,'ipprWarpAffine_8u_C1V');
  ipprWarpAffine_16u_C1V:=getProc(hh,'ipprWarpAffine_16u_C1V');
  ipprWarpAffine_32f_C1V:=getProc(hh,'ipprWarpAffine_32f_C1V');
  ipprRemap_8u_C1PV:=getProc(hh,'ipprRemap_8u_C1PV');
  ipprRemap_16u_C1PV:=getProc(hh,'ipprRemap_16u_C1PV');
  ipprRemap_32f_C1PV:=getProc(hh,'ipprRemap_32f_C1PV');
  ipprRemap_8u_C1V:=getProc(hh,'ipprRemap_8u_C1V');
  ipprRemap_16u_C1V:=getProc(hh,'ipprRemap_16u_C1V');
  ipprRemap_32f_C1V:=getProc(hh,'ipprRemap_32f_C1V');
  ipprFilterGetBufSize:=getProc(hh,'ipprFilterGetBufSize');
  ipprFilter_16s_C1PV:=getProc(hh,'ipprFilter_16s_C1PV');
  ipprFilter_16s_C1V:=getProc(hh,'ipprFilter_16s_C1V');
  ippiMulC64f_8u_C1R:=getProc(hh,'ippiMulC64f_8u_C1R');
  ippiMulC64f_8u_C3R:=getProc(hh,'ippiMulC64f_8u_C3R');
  ippiMulC64f_8u_C4R:=getProc(hh,'ippiMulC64f_8u_C4R');
  ippiMulC64f_16u_C1R:=getProc(hh,'ippiMulC64f_16u_C1R');
  ippiMulC64f_16u_C3R:=getProc(hh,'ippiMulC64f_16u_C3R');
  ippiMulC64f_16u_C4R:=getProc(hh,'ippiMulC64f_16u_C4R');
  ippiMulC64f_16s_C1R:=getProc(hh,'ippiMulC64f_16s_C1R');
  ippiMulC64f_16s_C3R:=getProc(hh,'ippiMulC64f_16s_C3R');
  ippiMulC64f_16s_C4R:=getProc(hh,'ippiMulC64f_16s_C4R');
  ippiMulC64f_32f_C1R:=getProc(hh,'ippiMulC64f_32f_C1R');
  ippiMulC64f_32f_C3R:=getProc(hh,'ippiMulC64f_32f_C3R');
  ippiMulC64f_32f_C4R:=getProc(hh,'ippiMulC64f_32f_C4R');
  ippiMulC64f_8u_C1IR:=getProc(hh,'ippiMulC64f_8u_C1IR');
  ippiMulC64f_8u_C3IR:=getProc(hh,'ippiMulC64f_8u_C3IR');
  ippiMulC64f_8u_C4IR:=getProc(hh,'ippiMulC64f_8u_C4IR');
  ippiMulC64f_16u_C1IR:=getProc(hh,'ippiMulC64f_16u_C1IR');
  ippiMulC64f_16u_C3IR:=getProc(hh,'ippiMulC64f_16u_C3IR');
  ippiMulC64f_16u_C4IR:=getProc(hh,'ippiMulC64f_16u_C4IR');
  ippiMulC64f_16s_C1IR:=getProc(hh,'ippiMulC64f_16s_C1IR');
  ippiMulC64f_16s_C3IR:=getProc(hh,'ippiMulC64f_16s_C3IR');
  ippiMulC64f_16s_C4IR:=getProc(hh,'ippiMulC64f_16s_C4IR');
  ippiMulC64f_32f_C1IR:=getProc(hh,'ippiMulC64f_32f_C1IR');
  ippiMulC64f_32f_C3IR:=getProc(hh,'ippiMulC64f_32f_C3IR');
  ippiMulC64f_32f_C4IR:=getProc(hh,'ippiMulC64f_32f_C4IR');
end;

function InitIPPI17:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(AppDir+'IPP\ippi.dll');

  result:=(hh<>0);
  if not result then exit;

  InitIppi1;
  InitIppi2;
  InitIppi3;
end;

procedure IPPItest;
Const
  First:boolean=true;
begin
  if not initIPPI17 then
  begin
    if First then
    begin
      messageCentral('Unable to initialize IPP library');
      First:=false;
    end;
    //sortieErreur('Unable to initialize IPP library');
  end;
end;

procedure IPPIend;
begin
  setPrecisionMode(pmExtended);
  //SetExceptionMask([exInvalidOp, exDenormalized, exUnderflow])
end;


end.
