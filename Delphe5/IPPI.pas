Unit ippi;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{$Z+,A+}  (*si un type énuméré est déclaré en mode $Z4 (= $Z+),
           il est stocké sous la forme d'un double mot non signé.
           En mode {$A8} ou {$A+}, les champs des types enregistrement déclarés
           sans le modificateur packed et les champs des structures classe
           sont alignés sur les frontières des quadruples mots.
          *)


uses ippdefs;


{$IFDEF WIN64}
Const
  DLLname1='ippi-7.0.dll';
{$ELSE}
Const
  DLLname1='ippi-7.0.dll';
  DLLname2='ippi20.dll';
{$ENDIF}


procedure IPPItest;
procedure IPPIend;
function InitIPPI:boolean;

(* /////////////////////////////////////////////////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//         Copyright (c) 1999-2003 Intel Corporation. All Rights Reserved.
//
//              Intel(R) Integrated Performance Primitives
//                  Image Processing (ippi)
//
*)


type
  IppiMaskSize=
    (
    ippMskSize1x3 = 13,
    ippMskSize1x5 = 15,
    ippMskSize3x1 = 31,
    ippMskSize3x3 = 33,
    ippMskSize5x1 = 51,
    ippMskSize5x5 = 55
    );

  IppiAlphaType=
    (
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
    ippAlphaPlusPremul
    );


  IppiDitherType=
    (
    ippDitherNone,
    ippDitherFS,
    ippDitherJJN,
    ippDitherStucki,
    ippDitherBayer
    );


(* /////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                   Functions declarations
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////// *)


var
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiGetLibVersion
//  Purpose:    getting of the library version
//  Returns:    the structure of information about  version of ippIP library
//  Parameters:
//
//  Notes:      not necessary to release the returned structure
*)
  ippiGetLibVersion: function:PIppLibraryVersion;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                   Functions to allocate and free images
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiMalloc
//  Purpose:    allocates memory with 32-byte aligned pointer for ippIP images,
//              every line of the image is aligned due to the padding characterized
//              by pStepBytes
//  Parameter:
//    widthPixels   width of image in pixels
//    heightPixels  height of image in pixels
//    pStepBytes    the pointer to the image step, it is an out parameter calculated
//                  by the function;
//
//  Returns:    pointer to allocated memory or 0 if out of memory or wrong parameters
//  Notes:      free the allocated memory by the function ippiFree only
*)

  ippiMalloc_8u_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;stdcall;
  ippiMalloc_16u_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;stdcall;
  ippiMalloc_16s_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;stdcall;
  ippiMalloc_32s_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;stdcall;
  ippiMalloc_32f_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;stdcall;
  ippiMalloc_32sc_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;stdcall;
  ippiMalloc_32fc_C1: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;stdcall;

  ippiMalloc_8u_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;stdcall;
  ippiMalloc_16u_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;stdcall;
  ippiMalloc_16s_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;stdcall;
  ippiMalloc_32s_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;stdcall;
  ippiMalloc_32f_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;stdcall;
  ippiMalloc_32sc_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;stdcall;
  ippiMalloc_32fc_C2: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;stdcall;

  ippiMalloc_8u_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;stdcall;
  ippiMalloc_16u_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;stdcall;
  ippiMalloc_16s_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;stdcall;
  ippiMalloc_32s_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;stdcall;
  ippiMalloc_32f_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;stdcall;
  ippiMalloc_32sc_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;stdcall;
  ippiMalloc_32fc_C3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;stdcall;

  ippiMalloc_8u_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;stdcall;
  ippiMalloc_16u_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;stdcall;
  ippiMalloc_16s_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;stdcall;
  ippiMalloc_32s_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;stdcall;
  ippiMalloc_32f_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;stdcall;
  ippiMalloc_32sc_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;stdcall;
  ippiMalloc_32fc_C4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;stdcall;

  ippiMalloc_8u_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;stdcall;
  ippiMalloc_16u_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;stdcall;
  ippiMalloc_16s_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;stdcall;
  ippiMalloc_32s_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;stdcall;
  ippiMalloc_32f_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;stdcall;
  ippiMalloc_32sc_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;stdcall;
  ippiMalloc_32fc_AC4: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;stdcall;

  ippiMalloc_8u_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp8u;stdcall;
  ippiMalloc_16u_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16u;stdcall;
  ippiMalloc_16s_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp16s;stdcall;
  ippiMalloc_32s_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32s;stdcall;
  ippiMalloc_32f_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32f;stdcall;
  ippiMalloc_32sc_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32sc;stdcall;
  ippiMalloc_32fc_P3: function(widthPixels:longint;heightPixels:longint;pStepBytes:Plongint):PIpp32fc;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFree
//  Purpose:    free memory allocated by the ippiMalloc functions
//  Parameter:
//    ptr       pointer to the memory allocated by the ippiMalloc functions
//
//  Notes:      use the function to free memory allocated by ippiMallocstdcall;
*)
  ippiFree: procedure(ptr:pointer);stdcall;



(* ///////////////////////////////////////////////////////////////////////////////////////
//                  Arithmetics functions
///////////////////////////////////////////////////////////////////////////// *)
(* ///////////////////////////////////////////////////////////////////////////////////////
//  Name:  ippiAdd_8u_C1RSfs,  ippiAdd_8u_C3RSfs,  ippiAdd_8u_C4RSfs,  ippiAdd_8u_AC4RSfs,
//         ippiAdd_16s_C1RSfs, ippiAdd_16s_C3RSfs, ippiAdd_16s_C4RSfs, ippiAdd_16s_AC4RSfs,
//         ippiSub_8u_C1RSfs,  ippiSub_8u_C3RSfs,  ippiSub_8u_C4RSfs,  ippiSub_8u_AC4RSfs,
//         ippiSub_16s_C1RSfs, ippiSub_16s_C3RSfs, ippiSub_16s_C4RSfs, ippiSub_16s_AC4RSfs,
//         ippiMul_8u_C1RSfs,  ippiMul_8u_C3RSfs,  ippiMul_8u_C4RSfs,  ippiMul_8u_AC4RSfs,
//         ippiMul_16s_C1RSfs, ippiMul_16s_C3RSfs, ippiMul_16s_C4RSfs, ippiMul_16s_AC4RSfs
//
//  Purpose:    Makes corresponding operation with pixel values of two
//              source images and places the scaled result in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc1, pSrc2             Pointers to the source images
//    src1Step, src2Step       Steps through the source images
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_C4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_AC4RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_8u_C1IRSfs,  ippiAddC_8u_C3IRSfs,  ippiAddC_8u_C4IRSfs,   ippiAddC_8u_AC4IRSfs,
//        ippiAddC_16s_C1IRSfs, ippiAddC_16s_C3IRSfs, ippiAddC_16s_C4IRSfs,  ippiAddC_16s_AC4IRSfs,
//        ippiSubC_8u_C1IRSfs,  ippiSubC_8u_C3IRSfs,  ippiSubC_8u_C4IRSfs,   ippiSubC_8u_AC4IRSfs,
//        ippiSubC_16s_C1IRSfs, ippiSubC_16s_C3IRSfs, ippiSubC_16s_C4IRSfs,  ippiSubC_16s_AC4IRSfs,
//        ippiMulC_8u_C1IRSfs,  ippiMulC_8u_C3IRSfs,  ippiMulC_8u_C4IRSfs,   ippiMulC_8u_AC4IRSfs,
//        ippiMulC_16s_C1IRSfs, ippiMulC_16s_C3IRSfs, ippiMulC_16s_C4IRSfs,  ippiMulC_16s_AC4IRSfs
//
//  Purpose:    Makes corresponding operation with a constant and pixel values of an image
//              and places the scaled results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The width or height of an image is less than or equal to zero
//    ippStsStepErr            The step value is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAddC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_8u_C4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_8u_AC4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_C4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_AC4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_C4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_AC4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_C4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_AC4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_C4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_AC4IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_C4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_AC4IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_8u_C1RSfs,  ippiAddC_8u_C3RSfs,  ippiAddC_8u_C4RSfs   ippiAddC_8u_AC4RSfs,
//        ippiAddC_16s_C1RSfs, ippiAddC_16s_C3RSfs, ippiAddC_16s_C4RSfs, ippiAddC_16s_AC4RSfs,
//        ippiSubC_8u_C1RSfs,  ippiSubC_8u_C3RSfs,  ippiSubC_8u_C4RSfs,  ippiSubC_8u_AC4RSfs,
//        ippiSubC_16s_C1RSfs, ippiSubC_16s_C3RSfs, ippiSubC_16s_C4RSfs, ippiSubC_16s_AC4RSfs,
//        ippiMulC_8u_C1RSfs,  ippiMulC_8u_C3RSfs,  ippiMulC_8u_C4RSfs,  ippiMulC_8u_AC4RSfs,
//        ippiMulC_16s_C1RSfs, ippiMulC_16s_C3RSfs, ippiMulC_16s_C4RSfs, ippiMulC_16s_AC4RSfs
//
//  Purpose:    Makes corresponding operation with a constant and pixel values of
//              a source image and places the scaled results in a destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAddC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAdd_8u_C1IRSfs,  ippiAdd_8u_C3IRSfs,  ippiAdd_8u_C4IRSfs,  ippiAdd_8u_AC4IRSfs,
//        ippiAdd_16s_C1IRSfs, ippiAdd_16s_C3IRSfs, ippiAdd_16s_C4IRSfs, ippiAdd_16s_AC4IRSfs,
//        ippiSub_8u_C1IRSfs,  ippiSub_8u_C3IRSfs,  ippiSub_8u_C4IRSfs,  ippiSub_8u_AC4IRSfs,
//        ippiSub_16s_C1IRSfs, ippiSub_16s_C3IRSfs, ippiSub_16s_C4IRSfs  ippiSub_16s_AC4IRSfs,
//        ippiMul_8u_C1IRSfs,  ippiMul_8u_C3IRSfs,  ippiMul_8u_C4IRSfs,  ippiMul_8u_AC4IRSfs,
//        ippiMul_16s_C1IRSfs, ippiMul_16s_C3IRSfs, ippiMul_16s_C4IRSfs, ippiMul_16s_AC4IRSfs
//
//  Purpose:    Makes corresponding operation with pixel values of two source images
//              and places the scaled results in a destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pSrcDst                  Pointer to the source & destination image
//    srcDstStep               Step through the source & destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_C4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_8u_AC4IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_32f_C1R, ippiAddC_32f_C3R, ippiAddC_32f_C4R,  ippiAddC_32f_AC4R,
//        ippiSubC_32f_C1R, ippiSubC_32f_C3R, ippiSubC_32f_C4R,  ippiSubC_32f_AC4R,
//        ippiMulC_32f_C1R, ippiMulC_32f_C3R, ippiMulC_32f_C4R,  ippiMulC_32f_AC4R
//
//  Purpose:    Makes corresponding operation with a constant and pixel values of
//              a source image and places the results in a destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
*)

  ippiAddC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAddC_32f_C1IR, ippiAddC_32f_C3IR, ippiAddC_32f_C4IR, ippiAddC_32f_AC4IR,
//        ippiSubC_32f_C1IR, ippiSubC_32f_C3IR, ippiSubC_32f_C4IR, ippiSubC_32f_AC4IR,
//        ippiMulC_32f_C1IR, ippiMulC_32f_C3IR, ippiMulC_32f_C4IR, ippiMulC_32f_AC4IR
//
//  Purpose:    Makes corresponding operation with a constant and pixel values of
//              an image and places the results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The width or height of an image is less than or equal to zero
//    ippStsStepErr            The step value is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
*)

  ippiAddC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32f_C4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32f_AC4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_C4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32f_AC4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_C4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32f_AC4IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////////////
//  Name: ippiAdd_32f_C1IR, ippiAdd_32f_C3IR, ippiAdd_32f_C4IR, ippiAdd_32f_AC4IR,
//        ippiSub_32f_C1IR, ippiSub_32f_C3IR, ippiSub_32f_C4IR, ippiSub_32f_AC4IR,
//        ippiMul_32f_C1IR, ippiMul_32f_C3IR, ippiMul_32f_C4IR, ippiMul_32f_AC4IR
//
//  Purpose:    Makes corresponding operation with pixel values of two source images
//              and places the results in a destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pSrcDst                  Pointer to the source & destination image
//    srcDstStep               Step through the source & destination image
//    roiSize                  Size of the ROI
*)

  ippiAdd_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name: ippiAdd_32f_C1R, ippiAdd_32f_C3R, ippiAdd_32f_C4R, ippiAdd_32f_AC4R,
//        ippiSub_32f_C1R, ippiSub_32f_C3R, ippiSub_32f_C4R, ippiSub_32f_AC4R,
//        ippiMul_32f_C1R, ippiMul_32f_C3R, ippiMul_32f_C4R, ippiMul_32f_AC4R
//
//  Purpose:    Makes corresponding operation with pixel values of two
//              source images and places the results in a destination image.
//
//  Return:
//    ippStsNoErr            Ok
//    ippStsNullPtrErr       One of the pointers is NULL
//    ippStsSizeErr          The width or height of images is less than or equal to zero
//    ippStsStepErr          Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc1, pSrc2           Pointers to the source images
//    src1Step, src2Step     Steps through the source images
//    pDst                   Pointer to the destination image
//    dstStep                Step through the destination image
//    roiSize                Size of the ROI
*)

  ippiAdd_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiComplement_32s_C1IR
//
//  Purpose:    Converts negative integer number from complement to
//              direct code reserving the sign in the upper bit.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         Pointer is NULL
//    ippStsStepErr            Step is less than or equal to zero
//    ippStsStrideErr          Step is less than the width of an image
//
//  Arguments:
//    pSrcDst                  Pointer to the source/destination image
//    srcdstStep               Step in bytes through the image
//    roiSize                  Size of ROI
*)

  ippiComplement_32s_C1IR: function(pSrcDst:PIpp32s;srcdstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_32f_C1R, ippiDiv_32f_C3R ippiDiv_32f_C4R ippiDiv_32f_AC4R
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the results in a destination
//              image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            Any of the step values is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the functionstdcall;
//                             execution is continued.
//                             If a dividend is equal to zero, then the result is zero;
//                             if it is greater than zero, then the result is IPP_ABSMAX_32F,
//                             if it is less than zero, then the result is -IPP_ABSMAX_32F
//
//  Arguments:
//    pSrc1                    Pointer to the divisor source image
//    src1Step                 Step through the divisor source image
//    pSrc2                    Pointer to the dividend source image
//    src2Step                 Step through the dividend source image
//    pDst                     Pointer to the destination vector
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
*)

  ippiDiv_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;




(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_16s_C1RSfs, ippiDiv_8u_C1RSfs,
//              ippiDiv_16s_C3RSfs, ippiDiv_8u_C3RSfs
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the scaled results in a destination
//              image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            Any of the step values is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the functionstdcall;
//                             execution is continued.
//                             If a dividend is equal to zero, then the result is zero;
//                             if it is greater than zero, then the result is IPP_ABSMAX_32F,
//                             if it is less than zero, then the result is -IPP_ABSMAX_32F
//
//  Arguments:
//    pSrc1                    Pointer to the divisor source image
//    src1Step                 Step through the divisor source image
//    pSrc2                    Pointer to the dividend source image
//    src2Step                 Step through the dividend source image
//    pDst                     Pointer to the destination vector
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDiv_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_8u_C1RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_8u_C3RSfs: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDivC_32f_C1R, ippiDivC_32f_C3R
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the results in a destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            The step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal to zero
//
//  Arguments:
//    value                    The constant divisor
//    pSrc                     Pointer to the source image
//    pDst                     Pointer to the destination image
//    roiSize                  Size of the ROI
*)

  ippiDivC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDivC_16s_C1RSfs, ippiDivC_8u_C1RSfs
//              ippiDivC_16s_C3RSfs, ippiDivC_8u_C3RSfs
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the scaled results in a destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            The step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal to zero
//
//  Arguments:
//    value                    The constant divisor
//    pSrc                     Pointer to the source image
//    pDst                     Pointer to the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDivC_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_32f_C1IR, ippiDiv_32f_C3IR ippiDiv_32f_C4IR ippiDiv_32f_AC4IR
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the results in a destination
//              image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            Any of the step values is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the functionstdcall;
//                             execution is continued.
//                             If a dividend is equal to zero, then the result is zero;
//                             if it is greater than zero, then the result is IPP_ABSMAX_32F,
//                             if it is less than zero, then the result is -IPP_ABSMAX_32F
//
//  Arguments:
//    pSrc                     Pointer to the divisor source image
//    srcStep                  Step through the divisor source image
//    pSrcDst                  Pointer to the dividend source/destination image
//    srcDstStep               Step through the dividend source/destination image
//    roiSize                  Size of the ROI
*)

  ippiDiv_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDiv_16s_C1IRSfs, ippiDiv_8u_C1IRSfs
//              ippiDiv_16s_C3IRSfs, ippiDiv_8u_C3IRSfs
//
//  Purpose:    Divides pixel values of an image by pixel values of
//              another image and places the scaled results in a destination
//              image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            Any of the step values is less than or equal to zero
//    ippStsDivByZero          A warning that a divisor value is zero, the functionstdcall;
//                             execution is continued.
//                             If a dividend is equal to zero, then the result is zero;
//                             if it is greater than zero, then the result is IPP_ABSMAX_32F,
//                             if it is less than zero, then the result is -IPP_ABSMAX_32F
//
//  Arguments:
//    pSrc                     Pointer to the divisor source image
//    srcStep                  Step through the divisor source image
//    pSrcDst                  Pointer to the dividend source/destination image
//    srcDstStep               Step through the dividend source/destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDiv_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_8u_C1IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_8u_C3IRSfs: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDivC_32f_C1IR, ippsDivC_32f_C3IR
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            The step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal zero
//
//  Arguments:
//    value                    The constant divisor
//    pSrcDst                  Pointer to the soutce/destination image
//    srcDstStep               Step through the source/destination image
//    roiSize                  Size of the ROI
*)

  ippiDivC_32f_C1IR: function(value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32f_C3IR: function(var value:Ipp32f;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippsDivC_16s_C1IRSfs, ippsDivC_8u_C1IRSfs,
//              ippsDivC_16s_C3IRSfs, ippsDivC_8u_C3IRSfs
//
//  Purpose:    Divides pixel values of a source image by a constant
//              and places the scaled results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The roiSize has a field with zero or negative value
//    ippStsStepErr            The step value is less than or equal to zero
//    ippStsDivByZeroErr       The constant is equal zero
//
//  Arguments:
//    value                    The constant divisor
//    pSrcDst                  Pointer to the soutce/destination image
//    srcDstStep               Step through the source/destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiDivC_16s_C1IRSfs: function(value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16s_C3IRSfs: function(var value:Ipp16s;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_8u_C1IRSfs: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_8u_C3IRSfs: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


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
//  Purpose:    computes absolute values of each pixel of asource image and
//              places results in the output image
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of the pointers is NULL
//   ippStsSizeErr     The roiSize has a field with negative or zero value
//
//  Parameters:
//   pSrc       pointer to the input image
//   srcStep    size of the input image scan-line
//   pDst       pointer to the output image
//   dstStep    size of the output image scan-line
//   pSrcDst    pointer to the input/output image (for in-place function)stdcall;
//   srcDstStep size of the input/output image scan-line (for in-place function)stdcall;
//   roiSize    ROI size of the output image
*)
  ippiAbs_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAbs_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


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
//  Purpose:    computes squares of pixel values of an image and
//              stores results in the output image
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  One of the pointers is NULL
//   ippStsSizeErr     The roiSize has a field with negative or zero value
//
//  Parameters:
//   pSrc       pointer to the input image
//   srcStep    size of the input image scan-line
//   pDst       pointer to the output image
//   dstStep    size of the output image scan-line
//   pSrcDst    pointer to the input/output image (for in-place function)stdcall;
//   srcDstStep size of the input/output image scan-line (for in-place function)stdcall;
//   roiSize    ROI size of the output image
//   scaleFactor scaleFactor
*)

  ippiSqr_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_C4RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_C4RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_8u_AC4IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_8u_C4IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_C1IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_C3IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_AC4IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16u_C4IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_AC4IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_16s_C4IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqr_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqr_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


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
//              stores results in the output image
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsSqrtNegArg  Negative value in source pixel
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to the input/output image (for in-place function)stdcall;
//   srcDstStep size of input/output image scan-line (for in-place function)stdcall;
//   roiSize    ROI size of output image
//   sacleFactor scaleFactor
*)
  ippiSqrt_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16u_C1RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16u_C3RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16u_AC4RSfs: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16s_AC4RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqrt_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqrt_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqrt_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_8u_AC4IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16u_C1IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16u_C3IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16u_AC4IRSfs: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_16s_AC4IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrt_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqrt_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqrt_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSqrt_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//  ippiLn_32f_C1IR   ippiLn_16s_C1IRSfs  ippiLn_8u_C1IRSfs
//  ippiLn_32f_C3IR   ippiLn_16s_C3IRSfs  ippiLn_8u_C3IRSfs
//  ippiLn_32f_C1R    ippiLn_16s_C1RSfs   ippiLn_8u_C1RSfs
//  ippiLn_32f_C3R    ippiLn_16s_C3RSfs   ippiLn_8u_C3RSfs
//  Purpose:
//     computes the natural logarithm of every pixel values in a source image
//  Parameters:
//    pSrc         Pointer to the source image.
//    pDst         Pointer to the destination image.
//    pSrcDst      Pointer to the input/output image for inplace functions.
//    srcStep      Step through the source image.
//    dstStep      Step through the destination image.
//    srcDstStep   Step through the input/output image for inplace functions.
//    roiSize      Size of the ROI.
//    scaleFactor  Scale factor for integer data.
//  Return:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       width or height of images is less than or equal to zero
//    ippStsStepErr       Any of the step values is less than or equal to zero
//    ippStsLnZeroArg     Zero value of the source pixel
//    ippStsLnNegArg      Negative value of the source pixel
//    ippStsNoErr         otherwise
*)

  ippiLn_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLn_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLn_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLn_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiLn_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiLn_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiLn_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiLn_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


  ippiLn_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiLn_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiLn_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiLn_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//  ippiExp_32f_C1IR   ippiExp_16s_C1IRSfs  ippiExp_8u_C1IRSfs
//  ippiExp_32f_C3IR   ippiExp_16s_C3IRSfs  ippiExp_8u_C3IRSfs
//  ippiExp_32f_C1R    ippiExp_16s_C1RSfs   ippiExp_8u_C1RSfs
//  ippiExp_32f_C3R    ippiExp_16s_C3RSfs   ippiExp_8u_C3RSfs
//  Purpose:
//     computes the exponent of pixel values in a source image
//  Parameters:
//    pSrc         Pointer to the source image.
//    pDst         Pointer to the destination image.
//    pSrcDst      Pointer to the input/output image for inplace functions.
//    srcStep      Step through the source image.
//    dstStep      Step through the in destination image.
//    srcDstStep   Step through the input/output image for inplace functions.
//    roiSize      Size of the ROI.
//    scaleFactor  Scale factor for integer data.
//  Return:
//    ippStsNullPtrErr    One of the pointers is NULL
//    ippStsSizeErr       width or height of images is less than or equal to zero
//    ippStsStepErr       Any the step values is less than or equal to zero
//    ippStsNoErr         otherwise
*)


  ippiExp_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiExp_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiExp_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiExp_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiExp_16s_C1IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiExp_16s_C3IRSfs: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiExp_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiExp_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


  ippiExp_8u_C1IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiExp_8u_C3IRSfs: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiExp_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiExp_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//                  Arithmetics functions with complex data
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddC_32fc_C1R, ippiAddC_32fc_C3R, ippiAddC_32fc_AC4R,
//              ippiSubC_32fc_C1R, ippiSubC_32fc_C3R, ippiSubC_32fc_AC4R,
//              ippiMulC_32fc_C1R, ippiMulC_32fc_C3R, ippiMulC_32fc_AC4R
//              ippiDivC_32fc_C1R, ippiDivC_32fc_C3R, ippiDivC_32fc_AC4R
//
//  Purpose:    Makes corresponding operations with a constant and values of each element
//              of the source image and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
*)

  ippiAddC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32fc_C3R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32fc_AC4R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32fc_C3R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32fc_AC4R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32fc_C3R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32fc_AC4R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32fc_C3R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32fc_AC4R: function(pSrc:PIpp32fc;srcStep:longint;var value:Ipp32fc;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddC_32fc_C1IR, ippiAddC_32fc_C3IR, ippiAddC_32fc_AC4IR,
//              ippiSubC_32fc_C1IR, ippiSubC_32fc_C3IR, ippiSubC_32fc_AC4IR,
//              ippiMulC_32fc_C1IR, ippiMulC_32fc_C3IR, ippiMulC_32fc_AC4IR
//              ippiDivC_32fc_C1IR, ippiDivC_32fc_C3IR, ippiDivC_32fc_AC4IR
//
//  Purpose:    Makes corresponding operations with a constant and values of each elements of
//              an image and stores results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of image is less than or equal to zero
//    ippStsStepErr            The step value is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
*)
  ippiAddC_32fc_C1IR: function(value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32fc_C3IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAddC_32fc_AC4IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32fc_C1IR: function(value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32fc_C3IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSubC_32fc_AC4IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32fc_C1IR: function(value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32fc_C3IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulC_32fc_AC4IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32fc_C1IR: function(value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32fc_C3IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDivC_32fc_AC4IR: function(var value:Ipp32fc;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAdd_32fc_C1IR, ippiAdd_32fc_C3IR, ippiAdd_32fc_AC4IR,
//              ippiSub_32fc_C1IR, ippiSub_32fc_C3IR, ippiSub_32fc_AC4IR,
//              ippiMul_32fc_C1IR, ippiMul_32fc_C3IR, ippiMul_32fc_AC4IR
//              ippiDiv_32fc_C1IR, ippiDiv_32fc_C3IR, ippiDiv_32fc_AC4IR
//
//  Purpose:    Makes corresponding operations with values of each elements of
//              two source images and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pSrcDst                  Pointer to the source and destination image
//    srcDstStep               Step through the source and destination image
//    roiSize                  Size of the ROI
*)

  ippiAdd_32fc_C1IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32fc_C3IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32fc_AC4IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32fc_C1IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32fc_C3IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32fc_AC4IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32fc_C1IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32fc_C3IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32fc_AC4IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32fc_C1IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32fc_C3IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32fc_AC4IR: function(pSrc:PIpp32fc;srcStep:longint;pSrcDst:PIpp32fc;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAdd_32fc_C1R, ippiAdd_32fc_C3R, ippiAdd_32fc_AC4R,
//              ippiSub_32fc_C1R, ippiSub_32fc_C3R, ippiSub_32fc_AC4R,
//              ippiMul_32fc_C1R, ippiMul_32fc_C3R, ippiMul_32fc_AC4R
//              ippiDiv_32fc_C1R, ippiDiv_32fc_C3R, ippiDiv_32fc_AC4R
//
//  Purpose:    Makes corresponding operation with values of each elements of two
//              source images and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc1, pSrc2             Pointers to the source images
//    src1Step, src2Step       Steps through the source images
//    pDst                     Pointer to the destination image
//    dstStep                  Steps through the destination image
//    roiSize                  Size of the ROI
*)

  ippiAdd_32fc_C1R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32fc_C3R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAdd_32fc_AC4R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32fc_C1R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32fc_C3R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSub_32fc_AC4R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32fc_C1R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32fc_C3R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMul_32fc_AC4R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32fc_C1R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32fc_C3R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiDiv_32fc_AC4R: function(pSrc1:PIpp32fc;src1Step:longint;pSrc2:PIpp32fc;src2Step:longint;pDst:PIpp32fc;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAdd_16sc_C1IRSfs, ippiAdd_16sc_C3IRSfs, ippiAdd_16sc_AC4IRSfs,
//              ippiSub_16sc_C1IRSfs, ippiSub_16sc_C3IRSfs, ippiSub_16sc_AC4IRSfs,
//              ippiMul_16sc_C1IRSfs, ippiMul_16sc_C3IRSfs, ippiMul_16sc_AC4IRSfs,
//              ippiDiv_16sc_C1IRSfs, ippiDiv_16sc_C3IRSfs, ippiDiv_16sc_AC4IRSfs
//
//  Purpose:    Makes corresponding operations with values of each elements of
//              two source images and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    iippStsNullPtrErr        One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pSrcDst                  Pointer to the source and destination image
//    srcDstStep               Step through the source and destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_16sc_C1IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16sc_C3IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16sc_AC4IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16sc_C1IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16sc_C3IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16sc_AC4IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16sc_C1IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16sc_C3IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16sc_AC4IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16sc_C1IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16sc_C3IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16sc_AC4IRSfs: function(pSrc:PIpp16sc;srcStep:longint;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAdd_16sc_C1RSfs, ippiAdd_16sc_C3RSfs, ippiAdd_16sc_AC4RSfs,
//              ippiSub_16sc_C1RSfs, ippiSub_16sc_C3RSfs, ippiSub_16sc_AC4RSfs,
//              ippiMul_16sc_C1RSfs, ippiMul_16sc_C3RSfs, ippiMul_16sc_AC4RSfs,
//              ippiDiv_16sc_C1RSfs, ippiDiv_16sc_C3RSfs, ippiDiv_16sc_AC4RSfs
//
//  Purpose:    Makes corresponding operation with values of each elements of two
//              source images and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc1, pSrc2             Pointers to source images
//    src1Step, src2Step       Steps through the source images
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_16sc_C1RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16sc_C3RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_16sc_AC4RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16sc_C1RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16sc_C3RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_16sc_AC4RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16sc_C1RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16sc_C3RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_16sc_AC4RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16sc_C1RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16sc_C3RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_16sc_AC4RSfs: function(pSrc1:PIpp16sc;src1Step:longint;pSrc2:PIpp16sc;src2Step:longint;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAdd_32sc_C1IRSfs, ippiAdd_32sc_C3IRSfs, ippiAdd_32sc_AC4IRSfs,
//              ippiSub_32sc_C1IRSfs, ippiSub_32sc_C3IRSfs, ippiSub_32sc_AC4IRSfs,
//              ippiMul_32sc_C1IRSfs, ippiMul_32sc_C3IRSfs, ippiMul_32sc_AC4IRSfs,
//              ippiDiv_32sc_C1IRSfs, ippiDiv_32sc_C3IRSfs, ippiDiv_32sc_AC4IRSfs
//
//  Purpose:    Makes corresponding operation with values of each elements of two
//              source images and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pSrcDst                  Pointer to the source and destination image
//    srcDstStep               Step through the source and destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAdd_32sc_C1IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_32sc_C3IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_32sc_AC4IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_32sc_C1IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_32sc_C3IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_32sc_AC4IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_32sc_C1IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_32sc_C3IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_32sc_AC4IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_32sc_C1IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_32sc_C3IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_32sc_AC4IRSfs: function(pSrc:PIpp32sc;srcStep:longint;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAdd_32sc_C1RSfs, ippiAdd_32sc_C3RSfs, ippiAdd_32sc_AC4RSfs,
//              ippiSub_32sc_C1RSfs, ippiSub_32sc_C3RSfs, ippiSub_32sc_AC4RSfs,
//              ippiMul_32sc_C1RSfs, ippiMul_32sc_C3RSfs, ippiMul_32sc_AC4RSfs,
//              ippiDiv_32sc_C1RSfs, ippiDiv_32sc_C3RSfs, ippiDiv_32sc_AC4RSfs
//
//  Purpose:    Makes corresponding operation with values of each elements of two
//              source images and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    pSrc1, pSrc2             Pointers to source images
//    src1Step, src2Step       The steps of the source images
//    pDst                     The pointer to destination image
//    dstStep                  The step of the destination image
//    roiSize                  ROI size
//    scaleFactor              Scale factor
*)

  ippiAdd_32sc_C1RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_32sc_C3RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAdd_32sc_AC4RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_32sc_C1RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_32sc_C3RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSub_32sc_AC4RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_32sc_C1RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_32sc_C3RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMul_32sc_AC4RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_32sc_C1RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_32sc_C3RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDiv_32sc_AC4RSfs: function(pSrc1:PIpp32sc;src1Step:longint;pSrc2:PIpp32sc;src2Step:longint;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddC_16sc_C1IRSfs, ippiAddC_16sc_C3IRSfs, ippiAddC_16sc_AC4IRSfs,
//              ippiSubC_16sc_C1IRSfs, ippiSubC_16sc_C3IRSfs, ippiSubC_16sc_AC4IRSfs,
//              ippiMulC_16sc_C1IRSfs, ippiMulC_16sc_C3IRSfs, ippiMulC_16sc_AC4IRSfs,
//              ippiDivC_16sc_C1IRSfs, ippiDivC_16sc_C3IRSfs, ippiDivC_16sc_AC4IRSfs
//
//  Purpose:    Makes corresponding operations with a constant and value of each elements of
//              an image and stores results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The width or height of image is less than or equal to zero
//    ippStsStepErr            The step value is less than or equal to zero
//
//  Arguments:
//    value                    The constant for operation
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)
  ippiAddC_16sc_C1IRSfs: function(value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16sc_C3IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16sc_AC4IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16sc_C1IRSfs: function(value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16sc_C3IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16sc_AC4IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16sc_C1IRSfs: function(value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16sc_C3IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16sc_AC4IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16sc_C1IRSfs: function(value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16sc_C3IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16sc_AC4IRSfs: function(var value:Ipp16sc;pSrcDst:PIpp16sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddC_16sc_C1RSfs, ippiAddC_16sc_C3RSfs, ippiAddC_16sc_AC4RSfs,
//              ippiSubC_16sc_C1RSfs, ippiSubC_16sc_C3RSfs, ippiSubC_16sc_AC4RSfs,
//              ippiMulC_16sc_C1RSfs, ippiMulC_16sc_C3RSfs, ippiMulC_16sc_AC4RSfs
//              ippiDivC_16sc_C1RSfs, ippiDivC_16sc_C3RSfs, ippiDivC_16sc_AC4RSfs
//
//
//  Purpose:    Makes corresponding operations with a constant and value of each elements of
//              the source image and stores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of image is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)

  ippiAddC_16sc_C1RSfs: function(pSrc:PIpp16sc;srcStep:longint;value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16sc_C3RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_16sc_AC4RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16sc_C1RSfs: function(pSrc:PIpp16sc;srcStep:longint;value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16sc_C3RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_16sc_AC4RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16sc_C1RSfs: function(pSrc:PIpp16sc;srcStep:longint;value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16sc_C3RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_16sc_AC4RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16sc_C1RSfs: function(pSrc:PIpp16sc;srcStep:longint;value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16sc_C3RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_16sc_AC4RSfs: function(pSrc:PIpp16sc;srcStep:longint;var value:Ipp16sc;pDst:PIpp16sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddC_32sc_C1IRSfs, ippiAddC_32sc_C3IRSfs, ippiAddC_32sc_AC4IRSfs,
//              ippiSubC_32sc_C1IRSfs, ippiSubC_32sc_C3IRSfs, ippiSubC_32sc_AC4IRSfs,
//              ippiMulC_32sc_C1IRSfs, ippiMulC_32sc_C3IRSfs, ippiMulC_32sc_AC4IRSfs,
//              ippiDivC_32sc_C1IRSfs, ippiDivC_32sc_C3IRSfs, ippiDivC_32sc_AC4IRSfs
//
//  Purpose:    Makes corresponding operations with a constant and value of each elements of
//              an image and stores results in the same image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         The pointer is NULL
//    ippStsSizeErr            The width or height of image is less than or equal to zero
//    ippStsStepErr            The step value is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step through the image
//    roiSize                  Size of the ROI
//    scaleFactor              Scale factor
*)
  ippiAddC_32sc_C1IRSfs: function(value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_32sc_C3IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_32sc_AC4IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_32sc_C1IRSfs: function(value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_32sc_C3IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_32sc_AC4IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_32sc_C1IRSfs: function(value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_32sc_C3IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_32sc_AC4IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_32sc_C1IRSfs: function(value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_32sc_C3IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_32sc_AC4IRSfs: function(var value:Ipp32sc;pSrcDst:PIpp32sc;srcDstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddC_32sc_C1RSfs, ippiAddC_32sc_C3RSfs, ippiAddC_32sc_AC4RSfs,
//              ippiSubC_32sc_C1RSfs, ippiSubC_32sc_C3RSfs, ippiSubC_32sc_AC4RSfs,
//              ippiMulC_32sc_C1RSfs, ippiMulC_32sc_C3RSfs, ippiMulC_32sc_AC4RSfs,
//              ippiDivC_32sc_C1RSfs, ippiDivC_32sc_C3RSfs, ippiDivC_32sc_AC4RSfs
//
//  Purpose:    Makes corresponding operations with a constant and value of each elements
//              of the source image and pstores results in the destination image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of images is less than or equal to zero
//    ippStsStepErr            Any of the step values is less than or equal to zero
//
//  Arguments:
//    value                    The constant value for the specified operation
//    pSrc                     Pointer to the source image
//    srcStep                  Step through the source image
//    pDst                     Pointer to the destination image
//    dstStep                  Step through the destination image
//    roiSize                  ROI
//    scaleFactor              Scale factor
*)

  ippiAddC_32sc_C1RSfs: function(pSrc:PIpp32sc;srcStep:longint;value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_32sc_C3RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiAddC_32sc_AC4RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_32sc_C1RSfs: function(pSrc:PIpp32sc;srcStep:longint;value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_32sc_C3RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiSubC_32sc_AC4RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_32sc_C1RSfs: function(pSrc:PIpp32sc;srcStep:longint;value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_32sc_C3RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiMulC_32sc_AC4RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_32sc_C1RSfs: function(pSrc:PIpp32sc;srcStep:longint;value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_32sc_C3RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;
  ippiDivC_32sc_AC4RSfs: function(pSrc:PIpp32sc;srcStep:longint;var value:Ipp32sc;pDst:PIpp32sc;dstStep:longint;roiSize:IppiSize;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                      Functions of multiplication with scaling
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(*
//  Names:              ippiMulScale, ippiMulCScale
//
//  Purpose:            multiplies the pixel values of two images (MulScale)
//                      or the pixel values of image by a constant (MulScaleC) with scaling
//
//  Parameters:
//   value              constant to be multiplpy with each pixel of the image
//   pSrc               source image data pointer
//   srcStep            step in source image
//   pSrcDst            source/destination image data pointer (for in-place case)
//   srcDstStep         step in source/destination image (for in-place case)
//   pSrc1              first source image data pointer
//   src1Step           step in first source image
//   pSrc2              second source image data pointer
//   src2Step           step in second source image
//   pDst               destination image data pointer
//   dstStep            step in destination image
//   roiSize            size of source image
//
//  Returns:
//   ippStsNullPtrErr   pointer(s) to the data is NULL
//   ippStsStepErr      step in any image is less or equal zero
//   ippStsSizeErr      width or height of images is less or equal zero
//   ippStsNoErr        otherwise
*)

  ippiMulScale_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiMulScale_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulScale_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulCScale_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//              Vector multiplication in RCPack for image processing
///////////////////////////////////////////////////////////////////////////// *)
(*  Name:               ippiMulPack
//
//  Purpose:            Multiply of two images and store in RCPack format
//
//  Returns:             IppStatus
//      ippStsNoErr,      if no errors
//      ippStsNullPtrErr, if some of pointers to input or output data are NULL
//      ippStsStepErr,    if step in some image is less or equal zero
//      ippStsSizeErr,    if width or height of image is less or equal zero
//
//  Parameters:
//      pSrc1           first source image data
//      src1Step        step in src1
//      pSrc2           second source image data
//      src1Step        step in src2
//      pDst            destination image data
//      dstStep         step in dst
//      roiSize         region of interest of src
//      sFactor         scale factor
//
//  Notes:              non in-place and in-pace cases done
*)

  ippiMulPack_16s_C1IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_C3IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_C4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_AC4IRSfs: function(pSrc:PIpp16s;srcStep:longint;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_C1RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_C3RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_C4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_16s_AC4RSfs: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;

  ippiMulPack_32s_C1IRSfs: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_C3IRSfs: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_C4IRSfs: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_AC4IRSfs: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_C1RSfs: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_C3RSfs: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_C4RSfs: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;
  ippiMulPack_32s_AC4RSfs: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;sFactor:longint):IppStatus;stdcall;

  ippiMulPack_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPack_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:               ippiMulPackConj
//
//  Purpose:            Multiply of two images and store in RCPack format
//
//  Returns:             IppStatus
//      ippStsNoErr,      if no errors
//      ippStsNullPtrErr, if some of pointers to input or output data are NULL
//      ippStsStepErr,    if step in some image is less or equal zero
//      ippStsSizeErr,    if width or height of image is less or equal zero
//
//  Parameters:
//      pSrc            source image data
//      srcStep         step in src
//      pSrcDst         destination image data
//      srcDstStep      step in dst
//      roiSize         region of interest of src
*)

  ippiMulPackConj_32f_C1IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPackConj_32f_C3IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPackConj_32f_C4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiMulPackConj_32f_AC4IR: function(pSrc:PIpp32f;srcStep:longint;pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiPackToCplxExtend
//  Purpose:        To convert a RCPack2D format to full complex data format.
//  Context:
//
//  Returns:             IppStatus
//      ippStsNoErr,            if no errors
//      ippStsNullPtrErr,       if pSrc == NULL or pDst == NULL
//      ippStsStepErr,          if srcStep or dstStep is less than or equal to zero
//      ippStsSizeErr           if width or height of image is less than or equal to zero
//
//  Parameters:
//    pSrc        POinter to the source image data (point to pixel (0,0)).
//    srcSize     The size of Src image.
//    srcStep     The step in Src image
//    pDst        Pointer to the destination image data.
//    dstStep     The step in Dst image
//  Notes:
*)

  ippiPackToCplxExtend_32s32sc_C1R: function(pSrc:PIpp32s;srcSize:IppiSize;srcStep:longint;pDst:PIpp32sc;dstStep:longint):IppStatus;stdcall;

  ippiPackToCplxExtend_32f32fc_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;pDst:PIpp32fc;dstStep:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippiPhasePack_32f_C1R
//    ippiPhasePack_32f_C3R
//    ippiPhasePack_16s_C1RSfs
//    ippiPhasePack_16s_C3RSfs
//  Purpose:
//    Compute the phase (in radians) of complex images elements.
//  Parameters:
//    pSrc        - an input complex image in Pack2D format
//    srcStep     - step through the source image
//    pDst        - an output image to store the phase components;
//    dstStep     - step through the destination image
//    roiSizeDst  - size of the ROI of destination image
//    scaleFactor - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNullPtrErr    Some of pointers to input or output data are NULL
//    ippStsSizeErr       The width or height of images is less than or equal to zero
//    ippStsStepErr       Any of the step values is less than or equal to zero
//    ippStsNoErr         Otherwise
*)

  ippiPhasePack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSizeDst:IppiSize):IppStatus;stdcall;

  ippiPhasePack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSizeDst:IppiSize):IppStatus;stdcall;

  ippiPhasePack_32s_C1RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiPhasePack_32s_C3RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiPhasePack_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiPhasePack_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippiMagnitudePack_32f_C1R
//    ippiMagnitudePack_32f_C3R
//    ippiMagnitudePack_32s_C1RSfs
//    ippiMagnitudePack_32s_C3RSfs
//    ippiMagnitudePack_16s_C1RSfs
//    ippiMagnitudePack_16s_C3RSfs
//  Purpose:
//    Compute the magnitude of complex images elements.
//  Parameters:
//    pSrc        - an input complex image in Pack2D format
//    srcStep     - step through the source image
//    pDst        - an output image to store the magnitude components;
//    dstStep     - step through the destination image
//    roiSizeDst  - size of the ROI of destination image
//    scaleFactor - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNullPtrErr    Some of pointers to input or output data are NULL
//    ippStsSizeErr       The width or height of images is less than or equal to zero
//    ippStsStepErr       Any of the step values is less than or equal to zero
//    ippStsNoErr         Otherwise
*)

  ippiMagnitudePack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSizeDst:IppiSize):IppStatus;stdcall;

  ippiMagnitudePack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSizeDst:IppiSize):IppStatus;stdcall;

  ippiMagnitudePack_16s_C1RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiMagnitudePack_16s_C3RSfs: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiMagnitudePack_32s_C1RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiMagnitudePack_32s_C3RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSizeDst:IppiSize;ScalFact:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippiMagnitude_32fc32f_C1R
//    ippiMagnitude_32fc32f_C3R
//    ippiMagnitude_32sc32s_C1RSfs
//    ippiMagnitude_32sc32s_C3RSfs
//    ippiMagnitude_16sc16s_C1RSfs
//    ippiMagnitude_16sc16s_C3RSfs
//  Purpose:
//    Compute the magnitude of complex images elements.
//  Parameters:
//    pSrc        - an input image in common complex format
//    srcStep     - step through the source image
//    pDst        - an output image to store the magnitude components;
//    dstStep     - step through the destination image
//    roiSize     - size of the ROI
//    scaleFactor - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNullPtrErr    Some of pointers to input or output data are NULL
//    ippStsSizeErr       The width or height of images is less than or equal to zero
//    ippStsStepErr       Any of the step values is less than or equal to zero
//    ippStsNoErr         Otherwise
*)

  ippiMagnitude_32fc32f_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiMagnitude_32fc32f_C3R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiMagnitude_16sc16s_C1RSfs: function(pSrc:PIpp16sc;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiMagnitude_16sc16s_C3RSfs: function(pSrc:PIpp16sc;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiMagnitude_32sc32s_C1RSfs: function(pSrc:PIpp32sc;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiMagnitude_32sc32s_C3RSfs: function(pSrc:PIpp32sc;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//    ippiPhase_32fc32f_C1R
//    ippiPhase_32fc32f_C3R
//    ippiPhase_16sc16s_C1RSfs
//    ippiPhase_16sc16s_C3RSfs
//  Purpose:
//    Compute the phase (in radians) of complex images elements.
//  Parameters:
//    pSrc        - an input image in common complex format
//    srcStep     - step through the source image
//    pDst        - an output image to store the phase components;
//    dstStep     - step through the destination image
//    roiSize     - size of the ROI
//    scaleFactor - a scale factor of output rezults (only for integer data)
//  Return:
//    ippStsNullPtrErr    Some of pointers to input or output data are NULL
//    ippStsSizeErr       The width or height of images is less than or equal to zero
//    ippStsStepErr       Any of the step values is less than or equal to zero
//    ippStsNoErr         Otherwise
*)

  ippiPhase_32fc32f_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiPhase_32fc32f_C3R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiPhase_32sc32s_C1RSfs: function(pSrc:PIpp32sc;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiPhase_32sc32s_C3RSfs: function(pSrc:PIpp32sc;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiPhase_16sc16s_C1RSfs: function(pSrc:PIpp16sc;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;

  ippiPhase_16sc16s_C3RSfs: function(pSrc:PIpp16sc;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;ScalFact:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Alpha Composition operations
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
//   Composites two images using alpha values of both images
//
//      ippiAlphaCompC_8u_AC4R, ippiAlphaCompC_16u_AC4R
//      ippiAlphaCompC_8u_AP4R, ippiAlphaCompC_16u_AP4R
//      ippiAlphaCompC_8u_C4R,  ippiAlphaCompC_16u_C4R
//      ippiAlphaCompC_8u_C3R,  ippiAlphaCompC_16u_C3R
//      ippiAlphaCompC_8u_C1R,  ippiAlphaCompC_16u_C1R
//   Composites two images using constant alpha values
//
//  The type of composition operation (alphaType)
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
//      Here 1 corresponds significance VAL_MAX, all multiplies execute
//      with scaling
//          X * Y => (X * Y) / VAL_MAX
//      and VAL_MAX is the maximum presentable pixel value
//          VAL_MAX == IPP_MAX_8U  for 8u
//          VAL_MAX == IPP_MAX_16U for 16u
*)

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremul_8u_AC4R,  ippiAlphaPremul_16u_AC4R
//                  ippiAlphaPremul_8u_AC4IR, ippiAlphaPremul_16u_AC4IR
//                  ippiAlphaPremul_8u_AP4R,  ippiAlphaPremul_16u_AP4R
//                  ippiAlphaPremul_8u_AP4IR, ippiAlphaPremul_16u_AP4IR
//  Purpose:        PreMultiplies on inner alpha for 4-channel images
//                  For channels 1-3
//                      dst_pixel = (src_pixel * src_alpha) / VAL_MAX
//                  For alpha-channel (channel 4)
//                      dst_alpha = src_alpha
//  Arguments:
//     pSrc         Pointer to start of source image
//     srcStep      Step through the source image
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to start input/output image (for in-place function)stdcall;
//     srcDstStep   Step through the input/output image (for in-place function)stdcall;
//     roiSize      Size of the rectangle to operate upon
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc == NULL or pDst == NULL or
//                               pSrcDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
*)

  ippiAlphaPremul_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremul_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremul_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremul_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremul_8u_AP4R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremul_16u_AP4R: function(var pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremul_8u_AP4IR: function(var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremul_16u_AP4IR: function(var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_AC4R,  ippiAlphaPremulC_16u_AC4R
//                  ippiAlphaPremulC_8u_AC4IR, ippiAlphaPremulC_16u_ACI4R
//                  ippiAlphaPremulC_8u_AP4R,  ippiAlphaPremulC_16u_AP4R
//                  ippiAlphaPremulC_8u_AP4IR, ippiAlphaPremulC_16u_API4R
//  Purpose:        PreMultiplies on constant alpha for 4-channel images
//                  For channels 1-3
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//                  For alpha-channel (channel 4)
//                      dst_alpha = const_alpha
//  Arguments:
//     pSrc         Pointer to start of source image
//     srcStep      Step through the source image
//     alpha        The constant alpha value to use
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to start input/output image (for in-place function)stdcall;
//     srcDstStep   Step through the input/output image (for in-place function)stdcall;
//     roiSize      Size of the rectangle to operate upon
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc == NULL or pDst == NULL or
//                               pSrcDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremulC_8u_AC4IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_AC4IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremulC_8u_AP4R: function(var pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_AP4R: function(var pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremulC_8u_AP4IR: function(alpha:Ipp8u;var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_AP4IR: function(alpha:Ipp16u;var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_C4R,  ippiAlphaPremulC_16u_C4R
//                  ippiAlphaPremulC_8u_C4IR, ippiAlphaPremulC_16u_C4IR
//  Purpose:        PreMultiplies on constant alpha for 4-channel images
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//  Arguments:
//     pSrc         Pointer to start of source image
//     srcStep      Step through the source image
//     alpha        The constant alpha value to use
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to start input/output image (for in-place function)stdcall;
//     srcDstStep   Step through the input/output image (for in-place function)stdcall;
//     roiSize      Size of the rectangle to operate upon
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc == NULL or pDst == NULL or
//                               pSrcDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremulC_8u_C4IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_C4IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_C3R,  ippiAlphaPremulC_16u_C3R
//                  ippiAlphaPremulC_8u_C3IR, ippiAlphaPremulC_16u_C3IR
//  Purpose:        PreMultiplies on constant alpha for 3-channel images
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//  Arguments:
//     pSrc         Pointer to start of source image
//     srcStep      Step through the source image
//     alpha        The constant alpha value to use
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to start input/output image (for in-place function)stdcall;
//     srcDstStep   Step through the input/output image (for in-place function)stdcall;
//     roiSize      Size of the rectangle to operate upon
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc == NULL or pDst == NULL or
//                               pSrcDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremulC_8u_C3IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_C3IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaPremulC_8u_C1R,  ippiAlphaPremulC_16u_C1R
//                  ippiAlphaPremulC_8u_C1IR, ippiAlphaPremulC_16u_C1IR
//  Purpose:        PreMultiplies on constant alpha for 1-channel images
//                      dst_pixel = (src_pixel * const_alpha) / VAL_MAX
//  Arguments:
//     pSrc         Pointer to start of source image
//     srcStep      Step through the source image
//     alpha        The constant alpha value to use
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     pSrcDst      Pointer to start input/output image (for in-place function)stdcall;
//     srcDstStep   Step through the input/output image (for in-place function)stdcall;
//     roiSize      Size of the rectangle to operate upon
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc == NULL or pDst == NULL or
//                               pSrcDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//
//  Notes:          Value becomes 0 <= alpha <= VAL_MAX
*)

  ippiAlphaPremulC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;alpha:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;alpha:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiAlphaPremulC_8u_C1IR: function(alpha:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAlphaPremulC_16u_C1IR: function(alpha:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaComp_8u_AC4R, ippiAlphaComp_16u_AC4R
//                  ippiAlphaComp_8u_AP4R, ippiAlphaComp_16u_AP4R
//  Purpose:        Alpha Composite in ROI of 4-channel images with
//                  inner alpha
//  Arguments:
//     pSrc1        Pointer to start of first source image
//     src1Step     Step through the first source image
//     pSrc2        Pointer to start of second source image
//     src2Step     Step through the second source image
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the rectangle to operate upon
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc1== NULL or pSrc2== NULL or pDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//     ippStsAlphaTypeErr     if alphaType incorrect
*)

  ippiAlphaComp_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaComp_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

  ippiAlphaComp_8u_AP4R: function(var pSrc1:PIpp8u;src1Step:longint;var pSrc2:PIpp8u;src2Step:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaComp_16u_AP4R: function(var pSrc1:PIpp16u;src1Step:longint;var pSrc2:PIpp16u;src2Step:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaComp_8u_AC1R, ippiAlphaComp_16u_AC1R
//  Purpose:        Alpha Composite in ROI of 1-channel images (with alpha)
//  Arguments:
//     pSrc1        Pointer to start of first source image
//     src1Step     Step through the first source image
//     pSrc2        Pointer to start of second source image
//     src2Step     Step through the second source image
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the rectangle to operate upon
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc1== NULL or pSrc2== NULL or pDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//     ippStsAlphaTypeErr     if alphaType incorrect
*)

  ippiAlphaComp_8u_AC1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaComp_16u_AC1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_AC4R, ippiAlphaCompC_16u_AC4R
//                  ippiAlphaCompC_8u_AP4R, ippiAlphaCompC_16u_AP4R
//  Purpose:        Alpha Composite in ROI of 4-channel images with
//                  constant alpha
//  Arguments:
//     pSrc1        Pointer to start of first source image
//     src1Step     Step through the first source image
//     alpha1       The constant alpha value to use for src1
//     pSrc2        Pointer to start of second source image
//     src2Step     Step through the second source image
//     alpha2       The constant alpha value to use for src2
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the rectangle to operate upon
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc1== NULL or pSrc2== NULL or pDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//     ippStsAlphaTypeErr     if alphaType incorrect
//
//  Notes:          Alpha-channel (channel 4) remains without modifications
//                  Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaCompC_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

  ippiAlphaCompC_8u_AP4R: function(var pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;var pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaCompC_16u_AP4R: function(var pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;var pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C4R, ippiAlphaCompC_16u_C4R
//  Purpose:        Alpha Composite in ROI of 4-channel images with
//                  constant alpha
//  Arguments:
//     pSrc1        Pointer to start of first source image
//     src1Step     Step through the first source image
//     alpha1       The constant alpha value to use for src1
//     pSrc2        Pointer to start of second source image
//     src2Step     Step through the second source image
//     alpha2       The constant alpha value to use for src2
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the rectangle to operate upon
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc1== NULL or pSrc2== NULL or pDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//     ippStsAlphaTypeErr     if alphaType incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaCompC_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C3R, ippiAlphaCompC_16u_C3R
//  Purpose:        Alpha Composite in ROI of 3-channel images with
//                  constant alpha
//  Arguments:
//     pSrc1        Pointer to start of first source image
//     src1Step     Step through the first source image
//     alpha1       The constant alpha value to use for src1
//     pSrc2        Pointer to start of second source image
//     src2Step     Step through the second source image
//     alpha2       The constant alpha value to use for src2
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the rectangle to operate upon
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc1== NULL or pSrc2== NULL or pDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//     ippStsAlphaTypeErr     if alphaType incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaCompC_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAlphaCompC_8u_C1R, ippiAlphaCompC_16u_C1R
//  Purpose:        Alpha Composite in ROI of 1-channel images with
//                  constant alpha
//  Arguments:
//     pSrc1        Pointer to start of first source image
//     src1Step     Step through the first source image
//     alpha1       The constant alpha value to use for src1
//     pSrc2        Pointer to start of second source image
//     src2Step     Step through the second source image
//     alpha2       The constant alpha value to use for src2
//     pDst         Pointer to start of destination image
//     dstStep      Step through the destination image
//     roiSize      Size of the rectangle to operate upon
//     alphaType    The type of composition to perform
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       if pSrc1== NULL or pSrc2== NULL or pDst == NULL
//     ippStsSizeErr          if ROI sizes are negative or zero
//     ippStsStepErr          if the steps in images are negative or zero
//     ippStsAlphaTypeErr     if alphaType incorrect
//
//  Notes:          Value becomes 0 <= alphaA <= VAL_MAX
//                                0 <= alphaB <= VAL_MAX
*)

  ippiAlphaCompC_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;alpha1:Ipp8u;pSrc2:PIpp8u;src2Step:longint;alpha2:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;
  ippiAlphaCompC_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;alpha1:Ipp16u;pSrc2:PIpp16u;src2Step:longint;alpha2:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;alphaType:IppiAlphaType):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//                  Operations of Linear Transforming
///////////////////////////////////////////////////////////////////////////// *)

(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for FFT Functions
///////////////////////////////////////////////////////////////////////////// *)

type
IppiFFTSpec_C_32fc = pointer;
PIppiFFTSpec_C_32fc =^IppiFFTSpec_C_32fc;

IppiFFTSpec_R_32f = pointer;
PIppiFFTSpec_R_32f =^IppiFFTSpec_R_32f;

IppiFFTSpec_R_32s = pointer;
PIppiFFTSpec_R_32s =^IppiFFTSpec_R_32s;


var
(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTInitAlloc
//  Purpose:    create and initialize of FFT context
//  Arguments:
//     orderX   - base-2 logarithm of the number of samples in FFT (width)
//     orderY   - base-2 logarithm of the number of samples in FFT (height)
//     flag     - normalization flag
//     hint     - code specific use hints
//     pFFTSpec - where write pointer to new context
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL
//     ippStsFftOrderErr      bad the order value
//     ippStsFFTFlagErr       bad the normalization flag value
//     ippStsMemAllocErr      memory allocation error
*)

  ippiFFTInitAlloc_C_32fc: function(var pFFTSpec:PIppiFFTSpec_C_32fc;orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiFFTInitAlloc_R_32f: function(var pFFTSpec:PIppiFFTSpec_R_32f;orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiFFTInitAlloc_R_32s: function(var pFFTSpec:PIppiFFTSpec_R_32s;orderX:longint;orderY:longint;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTFree
//  Purpose:    delete FFT context
//  Arguments:
//     pFFTSpec - pointer to FFT context to be deleted
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippiFFTFree_C_32fc: function(pFFTSpec:PIppiFFTSpec_C_32fc):IppStatus;stdcall;
  ippiFFTFree_R_32f: function(pFFTSpec:PIppiFFTSpec_R_32f):IppStatus;stdcall;

  ippiFFTFree_R_32s: function(pFFTSpec:PIppiFFTSpec_R_32s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTGetBufSize
//  Purpose:    get size of the FFT work buffer (on bytes)
//  Arguments:
//     pFFTSpec - pointer to FFT context
//     size     - where write size of buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL or size == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippiFFTGetBufSize_C_32fc: function(pFFTSpec:PIppiFFTSpec_C_32fc;size:Plongint):IppStatus;stdcall;
  ippiFFTGetBufSize_R_32f: function(pFFTSpec:PIppiFFTSpec_R_32f;size:Plongint):IppStatus;stdcall;

  ippiFFTGetBufSize_R_32s: function(pFFTSpec:PIppiFFTSpec_R_32s;size:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  FFT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiFFTFwd, ippiFFTInv
//  Purpose:    compute forward and inverse FFT of image
//  Arguments:
//     pFFTSpec - pointer to FFT context
//     pSrc     - pointer to source signal
//     srcStep  - the step in Src image
//     pDst     - pointer to destination signal
//     dstStep  - the step in Dst image
//     pBuffer  - pointer to work buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pFFTSpec == NULL or
//                            pSrc == NULL or pDst == NULL
//     ippStsStepErr          bad srcStep or dstStep value
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippiFFTFwd_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pFFTSpec:PIppiFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pFFTSpec:PIppiFFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiFFTFwd_RToPack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTFwd_RToPack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTFwd_RToPack_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTFwd_RToPack_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiFFTInv_PackToR_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_PackToR_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_PackToR_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_PackToR_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiFFTFwd_RToPack_8u32s_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTFwd_RToPack_8u32s_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTFwd_RToPack_8u32s_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTFwd_RToPack_8u32s_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiFFTInv_PackToR_32s8u_C1RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_PackToR_32s8u_C3RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_PackToR_32s8u_C4RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFFTInv_PackToR_32s8u_AC4RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pFFTSpec:PIppiFFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DFT Functions
///////////////////////////////////////////////////////////////////////////// *)

type

IppiDFTSpec_C_32fc = pointer;
PIppiDFTSpec_C_32fc =^IppiDFTSpec_C_32fc;

IppiDFTSpec_R_32f = pointer;
PIppiDFTSpec_R_32f =^IppiDFTSpec_R_32f;

IppiDFTSpec_R_32s = pointer;
PIppiDFTSpec_R_32s =^IppiDFTSpec_R_32s;


var
(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDFTInitAlloc
//  Purpose:    create and initialize of DFT context
//  Arguments:
//     roiSize  - size of ROI
//     flag     - normalization flag
//     hint     - code specific use hints
//     pDFTSpec - where write pointer to new context
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL
//     ippStsSizeErr          bad size of the ROI
//     ippStsFFTFlagErr       bad the normalization flag value
//     ippStsMemAllocErr      memory allocation error
*)

  ippiDFTInitAlloc_C_32fc: function(var pDFTSpec:PIppiDFTSpec_C_32fc;roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiDFTInitAlloc_R_32f: function(var pDFTSpec:PIppiDFTSpec_R_32f;roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiDFTInitAlloc_R_32s: function(var pDFTSpec:PIppiDFTSpec_R_32s;roiSize:IppiSize;flag:longint;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDFTFree
//  Purpose:    delete DFT context
//  Arguments:
//     pDFTSpec - pointer to DFT context to be deleted
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippiDFTFree_C_32fc: function(pDFTSpec:PIppiDFTSpec_C_32fc):IppStatus;stdcall;
  ippiDFTFree_R_32f: function(pDFTSpec:PIppiDFTSpec_R_32f):IppStatus;stdcall;

  ippiDFTFree_R_32s: function(pFFTSpec:PIppiDFTSpec_R_32s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDFTGetBufSize
//  Purpose:    get size of the DFT work buffer (on bytes)
//  Arguments:
//     pDFTSpec - pointer to DFT context
//     size     - where write size of buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL or size == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippiDFTGetBufSize_C_32fc: function(pDFTSpec:PIppiDFTSpec_C_32fc;size:Plongint):IppStatus;stdcall;
  ippiDFTGetBufSize_R_32f: function(pDFTSpec:PIppiDFTSpec_R_32f;size:Plongint):IppStatus;stdcall;

  ippiDFTGetBufSize_R_32s: function(pDFTSpec:PIppiDFTSpec_R_32s;size:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DFT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDFTFwd, ippiDFTInv
//  Purpose:    compute forward and inverse DFT of image
//  Arguments:
//     pDFTSpec - pointer to DFT context
//     pSrc     - pointer to source signal
//     srcStep  - the step in Src image
//     pDst     - pointer to destination signal
//     dstStep  - the step in Dst image
//     pBuffer  - pointer to work buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDFTSpec == NULL or
//                            pSrc == NULL or pDst == NULL
//     ippStsStepErr          bad srcStep or dstStep value
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippiDFTFwd_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pDFTSpec:PIppiDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_CToC_32fc_C1R: function(pSrc:PIpp32fc;srcStep:longint;pDst:PIpp32fc;dstStep:longint;pDFTSpec:PIppiDFTSpec_C_32fc;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiDFTFwd_RToPack_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTFwd_RToPack_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTFwd_RToPack_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTFwd_RToPack_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiDFTInv_PackToR_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_PackToR_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_PackToR_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_PackToR_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiDFTFwd_RToPack_8u32s_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTFwd_RToPack_8u32s_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTFwd_RToPack_8u32s_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTFwd_RToPack_8u32s_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiDFTInv_PackToR_32s8u_C1RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_PackToR_32s8u_C3RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_PackToR_32s8u_C4RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDFTInv_PackToR_32s8u_AC4RSfs: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;pDFTSpec:PIppiDFTSpec_R_32s;scaleFactor:longint;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  Definitions for DCT Functions
///////////////////////////////////////////////////////////////////////////// *)

type
IppiDCTFwdSpec_32f = pointer;
PIppiDCTFwdSpec_32f =^IppiDCTFwdSpec_32f;

IppiDCTInvSpec_32f = pointer;
PIppiDCTInvSpec_32f =^IppiDCTInvSpec_32f;


var
(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Context Functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwdInitAlloc, ippiDCTInvInitAlloc
//  Purpose:    create and initialize of DCT context
//  Arguments:
//     roiSize  - size of ROI
//     hint     - code specific use hints
//     pDCTSpec - where write pointer to new context
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL
//     ippStsSizeErr          bad size of the ROI
//     ippStsMemAllocErr      memory allocation error
*)

  ippiDCTFwdInitAlloc_32f: function(var pDCTSpec:PIppiDCTFwdSpec_32f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiDCTInvInitAlloc_32f: function(var pDCTSpec:PIppiDCTInvSpec_32f;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwdFree, ippiDCTInvFree
//  Purpose:    delete DCT context
//  Arguments:
//     pDCTSpec - pointer to DCT context to be deleted
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippiDCTFwdFree_32f: function(pDCTSpec:PIppiDCTFwdSpec_32f):IppStatus;stdcall;
  ippiDCTInvFree_32f: function(pDCTSpec:PIppiDCTInvSpec_32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Buffer Size
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwdGetBufSize, ippiDCTInvGetBufSize
//  Purpose:    get size of the DCT work buffer (on bytes)
//  Arguments:
//     pDCTSpec - pointer to DCT context
//     size     - where write size of buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL or size == NULL
//     ippStsContextMatchErr  bad context identifier
*)

  ippiDCTFwdGetBufSize_32f: function(pDCTSpec:PIppiDCTFwdSpec_32f;size:Plongint):IppStatus;stdcall;
  ippiDCTInvGetBufSize_32f: function(pDCTSpec:PIppiDCTInvSpec_32f;size:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DCT Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiDCTFwd, ippiDCTInv
//  Purpose:    compute forward and inverse DCT of image
//  Arguments:
//     pDCTSpec - pointer to DCT context
//     pSrc     - pointer to source signal
//     srcStep  - the step in Src image
//     pDst     - pointer to destination signal
//     dstStep  - the step in Dst image
//     pBuffer  - pointer to work buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       pDCTSpec == NULL or
//                            pSrc == NULL or pDst == NULL
//     ippStsStepErr          bad srcStep or dstStep value
//     ippStsContextMatchErr  bad context identifier
//     ippStsMemAllocErr      memory allocation error
*)

  ippiDCTFwd_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDCTFwd_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDCTFwd_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDCTFwd_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTFwdSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiDCTInv_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDCTInv_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDCTInv_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiDCTInv_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;pDCTSpec:PIppiDCTInvSpec_32f;pBuffer:PIpp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                  DCT 8x8 Transforms
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Fwd_16s_C1, ippiDCT8x8Fwd_16s_C1I
//             ippiDCT8x8Inv_16s_C1, ippiDCT8x8Inv_16s_C1I
//             ippiDCT8x8Fwd_16s_C1R
//             ippiDCT8x8Inv_16s_C1R
//  Purpose:   Forward and Inverse Discrete Cosine Transform 8x8 for 16s data
//
//  Arguments:
//     pSrc     - pointer to start of source buffer
//     pDst     - pointer to start of destination buffer
//     pSrcDst  - pointer to start of in-place buffer
//     srcStep  - the step in Src image
//     dstStep  - the step in Dst image
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       one of pointers are NULL
//     ippStsStepErr          bad srcStep or dstStep value
*)

  ippiDCT8x8Fwd_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;stdcall;
  ippiDCT8x8Inv_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;stdcall;

  ippiDCT8x8Fwd_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;stdcall;
  ippiDCT8x8Inv_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;stdcall;

  ippiDCT8x8Fwd_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s):IppStatus;stdcall;
  ippiDCT8x8Inv_16s_C1R: function(pSrc:PIpp16s;pDst:PIpp16s;dstStep:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Inv_2x2_16s_C1, ippiDCT8x8Inv_2x2_16s_C1I
//             ippiDCT8x8Inv_4x4_16s_C1, ippiDCT8x8Inv_4x4_16s_C1I
//  Purpose:   Inverse Discrete Cosine Transform 8x8 for 16s data
//             with nonzero elements only in top left quadrant 2x2 or 4x4
//  Arguments:
//     pSrc     - pointer to start of source buffer
//     pDst     - pointer to start of destination buffer
//     pSrcDst  - pointer to start of in-place buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       one of pointers are NULL
*)

  ippiDCT8x8Inv_2x2_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;stdcall;
  ippiDCT8x8Inv_4x4_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;stdcall;

  ippiDCT8x8Inv_2x2_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;stdcall;
  ippiDCT8x8Inv_4x4_16s_C1I: function(pSrcDst:PIpp16s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Fwd_8u16s_C1R
//             ippiDCT8x8Inv_16s8u_C1R
//  Purpose:   Forward and Inverse Discrete Cosine Transform 8x8 for 16s data
//             with conversion from/to 8u
//  Arguments:
//     pSrc     - pointer to start of source buffer
//     pDst     - pointer to start of destination buffer
//     srcStep  - the step in Src image
//     dstStep  - the step in Dst image
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       one of pointers are NULL
//     ippStsStepErr          bad srcStep or dstStep value
*)

  ippiDCT8x8Fwd_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s):IppStatus;stdcall;

  ippiDCT8x8Inv_16s8u_C1R: function(pSrc:PIpp16s;pDst:PIpp8u;dstStep:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8FwdLS_8u16s_C1R
//  Purpose:   Forward Discrete Cosine Transform 8x8 for 16s data
//             with conversion from 8u and level shift
//  Arguments:
//     pSrc     - pointer to start of source buffer
//     pDst     - pointer to start of destination buffer
//     srcStep  - the step in Src image
//     addVal   - constant value for ADD before DCT transform (level shift)
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       one of pointers are NULL
//     ippStsStepErr          bad srcStep value
*)

  ippiDCT8x8FwdLS_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;addVal:Ipp16s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8InvLSClip_16s8u_C1R
//  Purpose:   Inverse Discrete Cosine Transform 8x8 for 16s data
//             with level shift, clipping and conversion to 8u
//  Arguments:
//     pSrc     - pointer to start of source buffer
//     pDst     - pointer to start of destination buffer
//     dstStep  - the step in Dst image
//     addVal   - constant value for ADD after DCT transform (level shift)
//     clipDown - constant value for clipping (MIN)
//     clipUp   - constant value for clipping (MAX)
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       one of pointers are NULL
//     ippStsStepErr          bad dstStep value
*)

  ippiDCT8x8InvLSClip_16s8u_C1R: function(pSrc:PIpp16s;pDst:PIpp8u;dstStep:longint;addVal:Ipp16s;clipDown:Ipp8u;clipUp:Ipp8u):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiDCT8x8Fwd_32f_C1, ippiDCT8x8Fwd_32f_C1I
//             ippiDCT8x8Inv_32f_C1, ippiDCT8x8Inv_32f_C1I
//  Purpose:   Forward and Inverse Discrete Cosine Transform 8x8 for 32f data
//  Arguments:
//     pSrc     - pointer to start of source buffer
//     pDst     - pointer to start of destination buffer
//     pSrcDst  - pointer to start of in-place buffer
//  Returns:
//     ippStsNoErr            no errors
//     ippStsNullPtrErr       one of pointers are NULL
*)

  ippiDCT8x8Fwd_32f_C1: function(pSrc:PIpp32f;pDst:PIpp32f):IppStatus;stdcall;
  ippiDCT8x8Inv_32f_C1: function(pSrc:PIpp32f;pDst:PIpp32f):IppStatus;stdcall;

  ippiDCT8x8Fwd_32f_C1I: function(pSrcDst:PIpp32f):IppStatus;stdcall;
  ippiDCT8x8Inv_32f_C1I: function(pSrcDst:PIpp32f):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//          Wavelet Transform Fucntions for User Filter Banks
///////////////////////////////////////////////////////////////////////////// *)

type
IppiWTFwdSpec_32f_C1R = pointer;
PIppiWTFwdSpec_32f_C1R =^IppiWTFwdSpec_32f_C1R;

IppiWTInvSpec_32f_C1R = pointer;
PIppiWTInvSpec_32f_C1R =^IppiWTInvSpec_32f_C1R;

IppiWTFwdSpec_32f_C3R = pointer;
PIppiWTFwdSpec_32f_C3R =^IppiWTFwdSpec_32f_C3R;

IppiWTInvSpec_32f_C3R = pointer;
PIppiWTInvSpec_32f_C3R =^IppiWTInvSpec_32f_C3R;


var
(* //////////////////////////////////////////////////////////////////////
// Name:       ippiWTFwdInitAlloc_32f_C1R
//             ippiWTFwdInitAlloc_32f_C3R
// Purpose:    Allocate and initialize
//                forward wavelet transform context structure.
// Parameters:
//   pSpec      - pointer to pointer to allocated and initialized
//                 context structure;
//   pTapsLow   - pointer to lowpass filter taps;
//   lenLow     - length of lowpass filter;
//   anchorLow  - anchor position of lowpass filter;
//   pTapsHigh  - pointer to highpass filter taps;
//   lenHigh    - length of highpass filter;
//   anchorHigh - anchor position of highpass filter.
//
// Returns:
//   ippStsNoErr       - Ok;
//   ippStsNullPtrErr  - pointer to filter taps are NULL
//                         or pointer to pSpec structure is NULL;
//   ippStsSizeErr     - filter length is less then 2;
//   ippStsAnchorErr   - anchor is less then zero;
//   ippStsMemAllocErr - no memory to allocate context structure.
//
*)
  ippiWTFwdInitAlloc_32f_C1R: function(var pSpec:PIppiWTFwdSpec_32f_C1R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;stdcall;

  ippiWTFwdInitAlloc_32f_C3R: function(var pSpec:PIppiWTFwdSpec_32f_C3R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTFwdFree_32f_C1R
//              ippiWTFwdFree_32f_C3R
//
// Purpose:     Free and deallocate
//               forward wavelet transofrm context structure.
//
// Parameters:
//   pSpec  - pointer to context structure.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - Pointer to context structure is NULL;
//   ippStsContextMatchErr  - Mismatch context structure.
//
// Notes:      if pointer to context structure is NULL,
//                      ippStsNullPtrErr will be returned.
*)
  ippiWTFwdFree_32f_C1R: function(pSpec:PIppiWTFwdSpec_32f_C1R):IppStatus;stdcall;
  ippiWTFwdFree_32f_C3R: function(pSpec:PIppiWTFwdSpec_32f_C3R):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTFwdGetBufSize_C1R
//              ippiWTFwdGetBufSize_C3R
//
// Purpose:     Function intended to retrieve size of work buffer.stdcall;
//
// Parameters:
//   pSpec  - pointer to context structure.
//   size   - pointer to value that will receive the size of work buffer for
//              forward wavelet transform.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - Some of pointers is NULL;
//   ippStsContextMatchErr  - Mismatch context structure.
//
// Notes:      if pointer to context structure is NULL,
//                      ippStsNullPtrErr will be returned.
*)
  ippiWTFwdGetBufSize_C1R: function(pSpec:PIppiWTFwdSpec_32f_C1R;size:Plongint):IppStatus;stdcall;

  ippiWTFwdGetBufSize_C3R: function(pSpec:PIppiWTFwdSpec_32f_C3R;size:Plongint):IppStatus;stdcall;



(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTFwd_32f_C1R
//              ippiWTFwd_32f_C3R
//
// Purpose:     Forward wavelet transform.
//
// Parameters:
//   pSrc         - pointer to source image ROI;
//   srcStep      - step in bytes to each next line of source image;
//
//   pApproxDst   - pointer to destination "approximation" image ROI;
//   approxStep   - step in bytes to each next line
//                   of destination approximation image;
//   pDetailXDst  - pointer to destination "horizontal detils" image ROI;
//   detailXStep  - step in bytes to each next line
//                   of destination horizontal detil image;
//   pDetailYDst  - pointer to destination "vertical detils" image ROI;
//   detailYStep  - step in bytes to each next line
//                   of destination "vertical detils" image;
//   pDetailXYDst - pointer to destination "diagonal detils" image ROI;
//   detailXYStep - step in bytes to each next line
//                   of destination "diagonal detils" image;
//   dstRoiSize   - ROI size for all destination images.
//
//   pSpec       - pointer to context structure.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers are NULL;
//   ippStsSizeErr          - the width or height of ROI is less or equal zero;
//   ippStsContextMatchErr  - mismatch context structure.
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
//   These tokens are used only for identification convenience in this manual.
//
//
*)
  ippiWTFwd_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pApproxDst:PIpp32f;approxStep:longint;pDetailXDst:PIpp32f;detailXStep:longint;pDetailYDst:PIpp32f;detailYStep:longint;pDetailXYDst:PIpp32f;detailXYStep:longint;dstRoiSize:IppiSize;pSpec:PIppiWTFwdSpec_32f_C1R;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiWTFwd_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pApproxDst:PIpp32f;approxStep:longint;pDetailXDst:PIpp32f;detailXStep:longint;pDetailYDst:PIpp32f;detailYStep:longint;pDetailXYDst:PIpp32f;detailXYStep:longint;dstRoiSize:IppiSize;pSpec:PIppiWTFwdSpec_32f_C3R;pBuffer:PIpp8u):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:       ippiWTInvInitAlloc_32f_C1R
//             ippiWTInvInitAlloc_32f_C3R
// Purpose:    Allocate and initialize
//                inverse wavelet transform context structure.
// Parameters:
//   pSpec     - pointer to pointer to allocated and initialized
//                 context structure;
//   pTapsLow   - pointer to lowpass filter taps;
//   lenLow     - length of lowpass filter;
//   anchorLow  - anchor position of lowpass filter;
//   pTapsHigh  - pointer to highpass filter taps;
//   lenHigh    - length of highpass filter;
//   anchorHigh - anchor position of highpass filter.
//
// Returns:
//   ippStsNoErr       - Ok;
//   ippStsNullPtrErr  - pointer to filter taps are NULL
//                         or pointer to pSpec structure is NULL;
//   ippStsSizeErr     - filter length is less then 2;
//   ippStsAnchorErr   - anchor is less then zero;
//   ippStsMemAllocErr - no memory to allocate context structure.
//
// Notes:   anchor position value should be given for upsampled data.
//
*)
  ippiWTInvInitAlloc_32f_C1R: function(var pSpec:PIppiWTInvSpec_32f_C1R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;stdcall;

  ippiWTInvInitAlloc_32f_C3R: function(var pSpec:PIppiWTInvSpec_32f_C3R;pTapsLow:PIpp32f;lenLow:longint;anchorLow:longint;pTapsHigh:PIpp32f;lenHigh:longint;anchorHigh:longint):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTInvFree_32f_C1R
//              ippiWTInvFree_32f_C3R
//
// Purpose:     Free and deallocate
//                  inverse wavelet transofrm context structure.
//
// Parameters:
//   pSpec  - pointer to context structure.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - Pointer to context structure is NULL;
//   ippStsContextMatchErr  - Mismatch context structure.
//
// Notes:      if pointer to context structure is NULL,
//                      ippStsNullPtrErr will be returned.
*)
  ippiWTInvFree_32f_C1R: function(pSpec:PIppiWTInvSpec_32f_C1R):IppStatus;stdcall;
  ippiWTInvFree_32f_C3R: function(pSpec:PIppiWTInvSpec_32f_C3R):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTInvGetBufSize_C1R
//              ippiWTInvGetBufSize_C3R
//
// Purpose:     Function intended to retrieve size of work buffer forstdcall;
//                  inverse wavelet transform.
//
// Parameters:
//   pSpec  - pointer to context structure.
//   size   - pointer to value that will receive the size of work buffer.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - Some of pointers is NULL;
//   ippStsContextMatchErr  - Mismatch context structure.
//
// Notes:      if pointer to context structure is NULL,
//                      ippStsNullPtrErr will be returned.
*)
  ippiWTInvGetBufSize_C1R: function(pSpec:PIppiWTInvSpec_32f_C1R;size:Plongint):IppStatus;stdcall;

  ippiWTInvGetBufSize_C3R: function(pSpec:PIppiWTInvSpec_32f_C3R;size:Plongint):IppStatus;stdcall;


(* //////////////////////////////////////////////////////////////////////
// Name:        ippiWTInv_32f_C1R
//              ippiWTInv_32f_C3R
//
// Purpose:     Inverse wavelet transform.
//
// Parameters:
//   pApproxSrc   - pointer to source "approximation" image ROI;
//   approxStep   - step in bytes to each next line
//                   of source approximation image;
//   pDetailXSrc  - pointer to source "horizontal detils" image ROI;
//   detailXStep  - step in bytes to each next line
//                   of source horizontal detil image;
//   pDetailYSrc  - pointer to source "vertical detils" image ROI;
//   detailYStep  - step in bytes to each next line
//                   of source "vertical detils" image;
//   pDetailXYSrc - pointer to source "diagonal detils" image ROI;
//   detailXYStep - step in bytes to each next line
//                   of source "diagonal detils" image;
//   srcRoiSize   - ROI size for all source images.
//
//   pDst         - pointer to destination image ROI;
//   dstStep      - step in bytes to each next line of destination image;
//
//   pSpec        - pointer to context structure.
//
// Returns:
//   ippStsNoErr            - Ok;
//   ippStsNullPtrErr       - some of pointers are NULL;
//   ippStsSizeErr          - the width or height of ROI is less or equal zero;
//   ippStsContextMatchErr  - mismatch context structure.
//
// Notes:
//   No any fixed borders extension (wrap, symm.) will be applayed! Source
//    images must have valid and accessable border data outside of ROI.
//
//   Only the same ROI size for source images supported. Destination ROI size
//     should be calculated by next rule:
//          dstRoiSize.width  = 2 * srcRoiSize.width;
//          dstRoiSize.height = 2 * srcRoiSize.height.
//
//
//   Monikers for source images act in concert with decomposition destination.
//
//
*)
  ippiWTInv_32f_C1R: function(pApproxSrc:PIpp32f;approxStep:longint;pDetailXSrc:PIpp32f;detailXStep:longint;pDetailYSrc:PIpp32f;detailYStep:longint;pDetailXYSrc:PIpp32f;detailXYStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;pSpec:PIppiWTInvSpec_32f_C1R;pBuffer:PIpp8u):IppStatus;stdcall;

  ippiWTInv_32f_C3R: function(pApproxSrc:PIpp32f;approxStep:longint;pDetailXSrc:PIpp32f;detailXStep:longint;pDetailYSrc:PIpp32f;detailYStep:longint;pDetailXYSrc:PIpp32f;detailXYStep:longint;srcRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint;pSpec:PIppiWTInvSpec_32f_C3R;pBuffer:PIpp8u):IppStatus;stdcall;





(* /////////////////////////////////////////////////////////////////////////////
//                   Color space  conversion functions
///////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name: ippiRGBToYCbCr422_8u_C3C2R,ippiYCbCr422ToRGB_8u_C2C3R.
//        ippiRGBToYCbCr422_8u_P3C2R,ippiYCbCr422ToRGB_8u_C2P3R.
//        ippiYCbCr422ToRGB_8u_P3C3R,ippiCbYCr422ToRGB_8u_C2C3R
//        ippiRGBToCbYCr422Gamma_8u_C3C2R,ippiRGBToCbYCr422_8u_C3C2R
//  Purpose:    Convert RGB Image to and from YCbCr Image.
//  Arguments:
//     pSrc - Pointer to the source image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     pDst - Pointer to the resultant image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  Reference:
//      Jack Keith
//      Video Demystified: a handbook for the digital engineer, 2nd ed.
//      1996.pp.(42-43)
//
//  The YCbCr color space was developed as part of Recommendation ITU-R BT.601
//  (formely CCI 601). Y is defined to have a nominal range of 16 to 235;
//  Cb and Cr are defined to have a range of 16 to 240, with 128 equal to zero.
//  The function ippiRGBToYCbCr422_8u_P3C2R uses 4:2:2 sampling format.For everystdcall;
//  two  horisontal Y samples, there is one Cb and Cr sample.
//  Each pixel in the input RGB image is of 24 bit depth. Each pixel in the
//  output YCbCr image is of 16 bit depth. Sequence of bytes in the output
//  image is
//             Y0Cb0Y1Cr,Y2Cb1Y3Cr1,...
//  And for CbYCr image we have
//             Cb0Y0CrY1,Cb1Y2Cr1Y3,...
//  If the gamma-corrected RGB(R'G'B') image has a range 0 .. 255, as is commonly
//  found in computer system (and in our library), the following equations may be
//  used:
//
//       Y  =  0.257*R' + 0.504*G' + 0.098*B' + 16
//       Cb = -0.148*R' - 0.291*G' + 0.439*B' + 128
//       Cr =  0.439*R' - 0.368*G' - 0.071*B' + 128
//
//       R' = 1.164*(Y - 16) + 1.596*(Cr - 128 )
//       G' = 1.164*(Y - 16) - 0.813*(Cr - 128 )- 0.392*( Cb - 128 )
//       B' = 1.164*(Y - 16) + 2.017*(Cb - 128 )
//
//   Note that for the YCbCr-to-RGB equations, the RGB values must be saturated
//   at the 0 and 255 levels due to occasional excursions outside the nominal
//   YCbCr ranges.
//   For f.ippiRGBToCbYCr422Gamma_8u_C3C2R and ippiRGBToCbYCr422Gamma_8u_C3C2R there is
//   sample down filter(1/4,1/2,1/4).
*)

  ippiCbYCr422ToBGR_8u_C2C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;aval:Ipp8u):IppStatus;stdcall;

  ippiBGRToCbYCr422_8u_AC4C2R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr411ToBGR_8u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr411ToBGR_8u_P3C4R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;aval:Ipp8u):IppStatus;stdcall;

  ippiCbYCr422ToRGB_8u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToCbYCr422Gamma_8u_C3C2R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToCbYCr422_8u_C3C2R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr422ToRGB_8u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToYCbCr422_8u_C3C2R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB_8u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToYCbCr422_8u_P3C2R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB_8u_C2P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr420ToBGR_8u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB_8u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCbCr420_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr422ToRGB565_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR565_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr422ToRGB555_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR555_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr422ToRGB444_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR444_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCrToBGR565_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB565_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR444_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB444_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR555_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB555_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr420ToBGR565_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB565_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToBGR555_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB555_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToBGR444_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB444_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYCbCr422ToBGR565_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB565_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR555_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB555_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR444_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB444_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name: ippiYCbCrToBGR(RGB)565(555,444)Dither_8u16u_C3R
//        ippiYCbCrToBGR(RGB)565(555,444)Dither_8u16u_P3C3R
//        ippiYCbCr422ToBGR(RGB)565(555,444)Dither_8u16u_P3C3R
//        ippiYCbCr420ToBGR(RGB)565(555,444)Dither_8u16u_P3C3R
//        ippiYUV420ToBGR(RGB)565(555,444)Dither_8u16u_P3C3R
//  Purpose:    Convert RGB Image to and from YCbCr Image.
//  Arguments:
//     pSrc - Pointer to the source image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     pDst - Pointer to the resultant image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  After color conversion we have made dithering. We used Bayer's dithering algorithm
*)
  ippiYCbCrToBGR565Dither_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB565Dither_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR555Dither_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB555Dither_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR444Dither_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB444Dither_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToBGR565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToBGR555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToBGR444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr420ToRGB444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB555Dither_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR555Dither_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB565Dither_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR565Dither_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToRGB444Dither_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCr422ToBGR444Dither_8u16u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYUV420ToBGR444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToRGB444Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToBGR555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToRGB555Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToBGR565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToRGB565Dither_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiJoin422_8u_P3C2R, ippiSplit422_8u_C2P3R
//
//  Purpose:    Convert form 422 plane image format to 2-channal pixel
//              image format and vice versa.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One or more pointers are NULL
//    ippStsStepErr            One or more steps is less or equal zero
//    ippStsSizeErr            Width of first plain 422-image less then 2(4)
//                             or height equal zero
//    ippStsStrideErr          Step is less then width of image
//
//  Arguments:
//    pSrc[3]                  It is three pointers to source images
//    srcStep[3]               It is three steps for previous three images
//    pDst[3]                  It is three pointers to destination images
//    dstStep[3]               It is three steps for previous three images
//    pSrc                     The pointer to source image
//    srcStep                  The step for source image
//    pDst                     The pointer to destination image
//    dstStep                  The step for destination image
//    roiSize                  Size of ROI
*)
  ippiJoin422_8u_P3C2R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSplit422_8u_C2P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiJoin420_8u_P2C2R, ippiJoin420_Filter_8u_P2C2R
//
//  Purpose:    Convert from 420 plane image format to 2-channal pixel
//              image format.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One or more pointers are NULL
//    ippStsSizeErr            if imgSize.width < 2 || imgSize.height < 2
//
//  Arguments:
//    pSrcY                    Pointer to the source image Y plane.
//    srcYStepY                The step for source image Y plane.
//    pSrcUV                   Pointer to the source image UV plane.
//    srcUVStep                The step for source image UV plane.
//    pDst                     The pointer to destination image
//    dstStep                  The step for destination image
//    roiSize                  Size of ROI should be multiple 2.
//    layout                   the order of the slice processing with deinterlace filter.
//             The following are allowed
//                IPP_UPPER  - the first slice.
//                IPP_CENTER - the midlle slices.
//                IPP_LOWER  - the last   slice.
//                IPP_LOWER && IPP_UPPER && IPP_CENTER - the whole image.
//  Notes:
//    Sequence of bytes in the source image is( NV12 ):
//    A format in which all Y(pSrcY) samples are found first in memory as an array of
//    unsigned char with an even number of lines memory alignment),
//    followed immediately by an array(pSrcUV) of unsigned char
//    containing interleaved U and V samples (such that if addressed as a little-endian
//    WORD type, U would be in the LSBs and V would be in the MSBs).
//    This is the 4:2:0 pixel format.
//    Sequence of bytes in the destination image is(YUY2):
//    Y0U0Y1V0,Y2U1Y3V1,...   This is the 4:2:2 pixel format.
//
//    f. ippiJoin420_Filter_8u_P2C2R serves for processing the image on slice( height of slice
//    should be multiple 16).
//
*)

  ippiJoin420_8u_P2C2R: function(pSrcY:PIpp8u;srcYStep:longint;pSrcUV:PIpp8u;srcUVStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiJoin420_Filter_8u_P2C2R: function(pSrcY:PIpp8u;srcYStep:longint;pSrcUV:PIpp8u;srcUVStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;layout:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiSplit420_8u_P2P3R, ippiSplit420_Filter_8u_P2P3R
//
//  Purpose:    Convert from 420 plane image format to 3-channal plane
//              image format.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One or more pointers are NULL
//    ippStsSizeErr            if imgSize.width < 2 || imgSize.height < 2
//
//  Arguments:
//    pSrcY                    Pointer to the source image Y plane.
//    srcYStepY                The step for source image Y plane.
//    pSrcUV                   Pointer to the source image UV plane.
//    srcUVStep                The step for source image UV plane.
//    pDst[3]                  It is three pointers to destination images
//    dstStep[3]               It is three steps for previous three images
//    roiSize                  Size of ROI should be multiple 2.
//    layout                   the order of the slice processing with deinterlace filter.
//             The following are allowed
//                IPP_UPPER  - the first slice.
//                IPP_CENTER - the midlle slices.
//                IPP_LOWER  - the last   slice.
//                IPP_LOWER && IPP_UPPER && IPP_CENTER - the whole image.
//  Notes:
//    Sequence of bytes in the source image is( NV12 ):
//    A format in which all Y(pSrcY) samples are found first in memory as an array of
//    unsigned char with an even number of lines memory alignment),
//    followed immediately by an array(pSrcUV) of unsigned char
//    containing interleaved U and V samples (such that if addressed as a little-endian
//    WORD type, U would be in the LSBs and V would be in the MSBs).
//    This is the 4:2:0 pixel format.
//    Sequence of bytes in the destination image is( YV12 ):
//    the order of the pointers to destination images si Y V U.This is the 4:2:0 pixel format.
//
//    f. ippiSplit420_Filter_8u_P2P3R serves for processing the image on slice( height of slice
//    should be multiple 16).
*)

  ippiSplit420_8u_P2P3R: function(pSrcY:PIpp8u;srcYStep:longint;pSrcUV:PIpp8u;srcUVStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSplit420_Filter_8u_P2P3R: function(pSrcY:PIpp8u;srcYStep:longint;pSrcUV:PIpp8u;srcUVStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize;layout:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name: ippiRGBToYCbCr_8u_C3R, ippiYCbCrToRGB_8u_C3R.
//        ippiRGBToYCbCr_8u_AC4R,ippiYCbCrToRGB_8u_AC4R.
//        ippiRGBToYCbCr_8u_P3R, ippiYCbCrToRGB_8u_P3R.
//        ippiYCbCrToRGB_8u_P3C3R
//  Purpose:    Convert RGB Image to and from YCbCr Image.
//  Arguments:
//     pSrc - Pointer to the source image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     pDst - Pointer to the resultant image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  Reference:
//      Jack Keith
//      Video Demystified:a handbook for the digital engineer, 2nd ed.
//      1996.pp.(42-43)
//
//  The YCbCr color space was developed as part of Recommendation ITU-R BT.601
//  (formely CCI 601). Y is defined to have a nominal range of 16 to 235;
//  Cb and Cr are defined to have a range of 16 to 240, with 128 equal to zero.
//  If the gamma-corrected RGB(R'G'B') image has a range 0 .. 255, as is commonly
//  found in computer system (and in our library), the following equations may be
//  used:
//
//       Y  =  0.257*R' + 0.504*G' + 0.098*B' + 16
//       Cb = -0.148*R' - 0.291*G' + 0.439*B' + 128
//       Cr =  0.439*R' - 0.368*G' - 0.071*B' + 128
//
//       R' = 1.164*(Y - 16) + 1.596*(Cr - 128 )
//       G' = 1.164*(Y - 16) - 0.813*(Cr - 128 )- 0.392*( Cb - 128 )
//       B' = 1.164*(Y - 16) + 2.017*(Cb - 128 )
//
//   Note that for the YCbCr-to-RGB equations, the RGB values must be saturated
//   at the 0 and 255 levels due to occasional excursions outside the nominal
//   YCbCr ranges.
//
*)
  ippiRGBToYCbCr_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCbCr_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCbCr_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB_8u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR444_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB444_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR555_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB555_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToBGR565_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCbCrToRGB565_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiRGBToYUV_8u_C3R,  ippiYUVToRGB_8u_C3R.
//              ippiRGBToYUV_8u_AC4R, ippiYUVToRGB_8u_AC4R.
//              ippiRGBToYUV_8u_P3R,  ippiYUVToRGB_8u_P3R.
//              ippiRGBToYUV_8u_C3P3R,ippiYUVToRGB_8u_P3C3R.
//  Purpose:    Convert a RGB image to and from an YUV format image.
//  Arguments:
//     pSrc - Pointer to the source image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     pDst - Pointer to the resultant image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  Reference:
//      Jack Keith
//      Video Demystified: a handbook for the digital engineer, 2nd ed.
//      1996.pp.(40-41)
//
//     The YUV color space is the basic color space used by the PAL , NTSC , and
//  SECAM composite color video standarts.
//
//  The basic equations to convert between gamma-corrected RGB(R'G'B')and YUV are:
//
//       Y' =  0.299*R' + 0.587*G' + 0.114*B'
//       U  = -0.147*R' - 0.289*G' + 0.436*B' = 0.492*(B' - Y' )
//       V  =  0.615*R' - 0.515*G' - 0.100*B' = 0.877*(R' - Y' )
//
//       R' = Y' + 1.140 * V
//       G' = Y' - 0.394 * U - 0.581 * V
//       B' = Y' + 2.032 * U
//
//     For digital RGB values with the range [0 .. 255], Y has the range [0..255],
//   U the range [-112 .. +112],V the range [-157..+157].
//
//   These equations are usually scaled to simplify the implementation in an actual
//   NTSC or PAL digital encoder or decoder.
//
*)
(* Pixel to Pixel *)
  ippiRGBToYUV_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUVToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Pixel to Pixel *)
  ippiRGBToYUV_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUVToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Plane *)
  ippiRGBToYUV_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUVToRGB_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Pixel to Plane *)
  ippiRGBToYUV_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Pixel *)
  ippiYUVToRGB_8u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiRGBToYUV422_8u_C3P3R, ippiYUV422ToRGB_8u_P3C3R.
//              ippiRGBToYUV422_8u_P3R,   ippiYUV422ToRGB_8u_P3R.
//              ippiRGBToYUV420_8u_C3P3R, ippiYUV420ToRGB_8u_P3C3R.
//              ippiRGBToYUV422_8u_C3C2R,   ippiYUV422ToRGB_8u_C2C3R.
//  Purpose:    Convert a RGB image to and from an YUV format image.
//  Arguments:
//     pSrc - Pointer to the source image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     pDst - Pointer to the resultant image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line(for pixel-order data).
//               An array of step to separate source color planes (in case of plane-order data).
//     dstStep - step in bytes through destination image to jump on the next line(for pixel-order data).
//               An array of step to separate resultant color planes (in case of plane-order data).
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  Reference:
//      Jack Keith
//      Video Demystified: a handbook for the digital engineer, 2nd ed.
//      1996.pp.(40-41)
//
//     The YUV color space is the basic color space used by the PAL , NTSC , and
//  SECAM composite color video standarts.
//
//  The function ippiRGBToYUV422_ uses 4:2:2 sampling format.For everystdcall;
//  two  horisontal Y samples, there is one U and V sample.
//
//  The function ippiRGBToYUV420_ uses 4:2:0 sampling format. 4:2:0 implementsstdcall;
//  2:1 reduction of U and V in both the vertical and horizontal directions.
//
//  The basic equations to convert between gamma-corrected RGB(R'G'B')and YUV are:
//
//       Y' =  0.299*R' + 0.587*G' + 0.114*B'
//       U  = -0.147*R' - 0.289*G' + 0.436*B' = 0.492*(B' - Y' )
//       V  =  0.615*R' - 0.515*G' - 0.100*B' = 0.877*(R' - Y' )
//
//       R' = Y' + 1.140 * V
//       G' = Y' - 0.394 * U - 0.581 * V
//       B' = Y' + 2.032 * U
//
//     For digital RGB values with the range [0 .. 255], Y has the range [0..255],
//   U the range [-112 .. +112],V the range [-157..+157].
//
//   These equations are usually scaled to simplify the implementation in an actual
//   NTSC or PAL digital encoder or decoder.
//
*)
  ippiYUV420ToRGB_8u_P3AC4R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV422ToRGB_8u_P3AC4R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Pixel to Plane *)
  ippiRGBToYUV422_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Pixel *)
  ippiYUV422ToRGB_8u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Plane *)
  ippiRGBToYUV422_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Plane *)
  ippiYUV422ToRGB_8u_P3R: function(var pSrc:PIpp8u;var srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Pixel to Plane *)
  ippiRGBToYUV420_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Pixel *)
  ippiYUV420ToRGB_8u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Plane *)
  ippiRGBToYUV420_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;var dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Plane to Plane *)
  ippiYUV420ToRGB_8u_P3R: function(var pSrc:PIpp8u;var srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
(* Pixel to Pixel *)
  ippiRGBToYUV422_8u_C3C2R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV422ToRGB_8u_C2C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToBGR565_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToBGR555_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToBGR444_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiYUV420ToRGB565_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToRGB555_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToRGB444_8u16u_P3C3R: function(var pSrc:PIpp8u;var srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiRGBToYUV422_8u_P3,   ippiYUV422ToRGB_8u_P3.
//              ippiRGBToYUV422_8u_C3P3, ippiYUV422ToRGB_8u_P3C3.
//              ippiRGBToYUV420_8u_C3P3, ippiYUV420ToRGB_8u_P3C3.
//              ippiRGBToYUV420_8u_P3,   ippiYUV420ToRGB_8u_P3.
//  Purpose:    Convert a RGB image to and from an YUV format image.
//  Arguments:
//     pSrc - Pointer to the source image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     pDst - Pointer to the resultant image (for pixel-order data).An array of pointers
//            to separate source color planes (in case of plane-order data)
//     imgSize - size of the source and destination images in pixels
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  Reference:
//      Jack Keith
//      Video Demystified: a handbook for the digital engineer, 2nd ed.
//      1996.pp.(40-41)
//
//     The YUV color space is the basic color space used by the PAL , NTSC , and
//  SECAM composite color video standarts.
//
//  The function ippiRGBToYUV422_ uses 4:2:2 sampling format.For everystdcall;
//  two  horisontal Y samples, there is one U and V sample.
//
//  The function ippiRGBToYUV420_ uses 4:2:0 sampling format. 4:2:0 implementsstdcall;
//  2:1 reduction of U and V in both the vertical and horizontal directions.
//
//  The basic equations to convert between gamma-corrected RGB(R'G'B')and YUV are:
//
//       Y' =  0.299*R' + 0.587*G' + 0.114*B'
//       U  = -0.147*R' - 0.289*G' + 0.436*B' = 0.492*(B' - Y' )
//       V  =  0.615*R' - 0.515*G' - 0.100*B' = 0.877*(R' - Y' )
//
//       R' = Y' + 1.140 * V
//       G' = Y' - 0.394 * U - 0.581 * V
//       B' = Y' + 2.032 * U
//
//   For digital RGB values with the range [0 .. 255], Y has the range [0..255],
//   U the range [-112 .. +112],V the range [-157..+157].
//
//   These equations are usually scaled to simplify the implementation in an actual
//   NTSC or PAL digital encoder or decoder.
//
*)
(* Plane to Plane *)
  ippiRGBToYUV422_8u_P3: function(var pSrc:PIpp8u;var pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
  ippiYUV422ToRGB_8u_P3: function(var pSrc:PIpp8u;var pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
(* Pixel to Plane *)
  ippiRGBToYUV422_8u_C3P3: function(pSrc:PIpp8u;var pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
(* Plane to Pixel *)
  ippiYUV422ToRGB_8u_P3C3: function(var pSrc:PIpp8u;pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
(* Pixel to Plane *)
  ippiRGBToYUV420_8u_C3P3: function(pSrc:PIpp8u;var pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
(* Plane to Pixel *)
  ippiYUV420ToRGB_8u_P3C3: function(var pSrc:PIpp8u;pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
(* Plane to Plane *)
  ippiRGBToYUV420_8u_P3: function(var pSrc:PIpp8u;var pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;
  ippiYUV420ToRGB_8u_P3: function(var pSrc:PIpp8u;var pDst:PIpp8u;imgSize:IppiSize):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiRGBToGray
//  Purpose:    Convert a RGB image to the gray image
//  Arguments:
//     pSrc     - the source image , points to point(0,0)
//     pDst     - the resultant image , points to point(0,0)
//     roiSize - region of interest in pixels. Because the function does a pointstdcall;
//          operation (that's without a border) the parameter can be the size of
//          the images
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNullPtrErr       else
//  Reference:
//      Jack Keith
//      Video Demystified: a handbook for the digital engineer, 2nd ed.
//      1996.p.(82)
//
//  The coefficients of equation below correspond to the "NTSC" red, green and blue CRT
//  phosphors of 1953 are standardized in ITU-R Recommendation BT. 601-2
//  (formerly CCIR Rec. 601-2).
//
//   The basic equation to compute nonlinear video  luma(monochrome) from nonlinear
//  (gamma-corrected) RGB(R'G'B') is:
//
//  Y' = 0.299 * R' + 0.587 * G' + 0.114 * B';
//
//
*)
  ippiRGBToGray_8u_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_16u_C3C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_16s_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_8u_AC4C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_16u_AC4C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_16s_AC4C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToGray_32f_AC4C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiColorToGray
//  Purpose:    Convert a RGB image to the gray image
//  Arguments:
//     pSrc     - the source image , points to point(0,0)
//     pDst     - the resultant image , points to point(0,0)
//     roiSize - region of interest in pixels. Because the function does a pointstdcall;
//          operation (that's without a border) the parameter can be the size of
//          the images
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//     coeffs[3] - the user  defined  vector of coefficients.
//                 The sum of coefficients should be less or is equal to unit.
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNullPtrErr       else
//
//  The basic equation to convert an image from RGB color to gray ckale is:
//
//   Y = coeffs[0] * R + coeffs[1] * G + coeffs[2] * B;
//
//
*)
  ippiColorToGray_8u_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;
  ippiColorToGray_16u_C3C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;
  ippiColorToGray_16s_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;
  ippiColorToGray_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;

  ippiColorToGray_8u_AC4C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;
  ippiColorToGray_16u_AC4C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;
  ippiColorToGray_16s_AC4C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;
  ippiColorToGray_32f_AC4C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var coeffs:Ipp32f):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name: ippiRGBToHLS and ippiHLSToRGB
//  Purpose:    Convert an image from RGB to HLS format and vice versa
//  Arguments:
//     pSrc - Pointer to the source image .
//     pDst - Pointer to the resultant image .
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  RGB and HLS values for the 32f data type should be in the range [0..1]
//  Reference:
//      David F.Rogers
//      Procedural elements for computer graphics
//      1985.pp.(403-406)
//
//       H is the hue red at 0 degrees, which has range [0 .. 360 degrees],
//       L is the lightness,
//       S is the saturation,
//
//       The RGB to HLS conversion algorithm in pseudocode:
//   Lightness:
//      M1 = max(R,G,B); M2 = max(R,G,B); L = (M1+M2)/2
//   Saturation:
//      if M1 = M2 then // achromatics case
//          S = 0
//          H = 0
//      else // chromatics case
//          if L <= 0.5 then
//               S = (M1-M2) / (M1+M2)
//          else
//               S = (M1-M2) / (2-M1-M2)
//   Hue:
//      Cr = (M1-R) / (M1-M2)
//      Cg = (M1-G) / (M1-M2)
//      Cb = (M1-B) / (M1-M2)
//      if R = M2 then H = Cb - Cg
//      if G = M2 then H = 2 + Cr - Cb
//      if B = M2 then H = 4 + Cg - Cr
//      H = 60*H
//      if H < 0 then H = H + 360
//
//      The HSL to RGB conversion algorithm in pseudocode:
//      if L <= 0.5 then
//           M2 = L *(1 + S)
//      else
//           M2 = L + S - L * S
//      M1 = 2 * L - M2
//      if S = 0 then
//         R = G = B = L
//      else
//          h = H + 120
//          if h > 360 then
//              h = h - 360
//          if h  <  60 then
//              R = ( M1 + ( M2 - M1 ) * h / 60)
//          else if h < 180 then
//              R = M2
//          else if h < 240 then
//              R = M1 + ( M2 - M1 ) * ( 240 - h ) / 60
//          else
//              R = M1
//          h = H
//          if h  <  60 then
//              G = ( M1 + ( M2 - M1 ) * h / 60
//          else if h < 180 then
//              G = M2
//          else if h < 240 then
//              G = M1 + ( M2 - M1 ) * ( 240 - h ) / 60
//          else
//              G  = M1
//          h = H - 120
//          if h < 0 then
//              h += 360
//          if h  <  60 then
//              B = ( M1 + ( M2 - M1 ) * h / 60
//          else if h < 180 then
//              B = M2
//          else if h < 240 then
//              B = M1 + ( M2 - M1 ) * ( 240 - h ) / 60
//          else
//              B = M1
//
//     H,L,S,R,G,B - are scaled in the range [0..1] for the 32f depth,
//           in the range [0..IPP_MAX_8u] for the 8u depth,
//           in the range [0..IPP_MAX_16u] for the 16u depth,
//           in the range [IPP_MIN_16S..IPP_MAX_16s] for the 16s depth.
//
*)
  ippiBGRToHLS_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHLS_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHLS_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToHLS_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHLS_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToHLS_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHLS_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToHLS_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHLS_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToRGB_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiBGRToHLS_8u_AP4R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiBGRToHLS_8u_AP4C4R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiBGRToHLS_8u_AC4P4R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiBGRToHLS_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiBGRToHLS_8u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiBGRToHLS_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToBGR_8u_AP4R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToBGR_8u_AP4C4R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToBGR_8u_AC4P4R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToBGR_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToBGR_8u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHLSToBGR_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name: ippiRGBToHSV and ippiHSVToRGB
//  Purpose:    Convert an image from RGB to HSV format and vice versa
//  Arguments:
//     pSrc - Pointer to the source image .
//     pDst - Pointer to the resultant image .
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       else
//  Reference:
//      David F.Rogers
//      Procedural elements for computer graphics
//      1985.pp.(401-403)
//
//       H is the hue red at 0 degrees, which has range [0 .. 360 degrees],
//       S is the saturation,
//       V is the value
//       The RGB to HSV conversion algorithm in pseudocode:
//   Value:
//      V = max(R,G,B);
//   Saturation:
//      temp = min(R,G,B);
//      if V = 0 then // achromatics case
//          S = 0
//          H = 0
//      else // chromatics case
//          S = (V - temp)/V
//   Hue:
//      Cr = (V - R) / (V - temp)
//      Cg = (V - G) / (V - temp)
//      Cb = (V - B) / (V - temp)
//      if R = V then H = Cb - Cg
//      if G = V then H = 2 + Cr - Cb
//      if B = V then H = 4 + Cg - Cr
//      H = 60*H
//      if H < 0 then H = H + 360
//
//      The HSV to RGB conversion algorithm in pseudocode:
//      if S = 0 then
//         R = G = B = V
//      else
//          if H = 360 then
//              H = 0
//          else
//              H = H/60
//           I = floor(H)
//           F = H - I;
//           M = V * ( 1 - S);
//           N = V * ( 1 - S * F);
//           K = V * ( 1 - S * (1 - F));
//           if(I == 0)then{ R = V;G = K;B = M;}
//           if(I == 1)then{ R = N;G = V;B = M;}
//           if(I == 2)then{ R = M;G = V;B = K;}
//           if(I == 3)then{ R = M;G = N;B = V;}
//           if(I == 4)then{ R = K;G = M;B = V;}
//           if(I == 5)then{ R = V;G = M;B = N;}
//
//           in the range [0..IPP_MAX_8u ] for the 8u depth,
//           in the range [0..IPP_MAX_16u] for the 16u depth,
//
*)
  ippiRGBToHSV_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHSVToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHSV_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHSVToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToHSV_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHSVToRGB_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToHSV_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiHSVToRGB_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name: ippiRGBToYCC and ippiYCCToRGB
//  Purpose:    Convert an image from RGB to YCC format and backward.
//  Arguments:
//    pSrc          pointer to the source image ROI
//    srcStep       source image scan-line size (bytes)
//    pDst          pointer to the target image ROI
//    dstStep       target image scan-line size (bytes)
//    dstRoiSize    size of ROI
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr     if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       otherwise
//  Reference:
//      Jack Keith
//      Video Demystified: a handbook for the digital engineer, 2nd ed.
//      1996.pp.(46-47)
//
//  The basic equations to convert gamma-corrected R'G'B' to YCC are:
//
//   R’G’B’ data is transformed into PhotoYCC data:
//    Y  =  0.299*R' + 0.587*G' + 0.114*B'
//    C1 = -0.299*R' - 0.587*G' + 0.886*B' = B'- Y
//    C2 =  0.701*R' - 0.587*G' - 0.114*B' = R'- Y
//   Y,C1,C2 are quantized and limited to the range [0..1]
//    Y  = 1. / 1.402 * Y
//    C1 = 111.4 / 255. * C1 + 156. / 255.
//    C2 = 135.64 /255. * C2 + 137. / 255.
//
//  Conversion of PhotoYCC data to RGB data for CRT computer display:
//
//   normal luminance and chrominance data are recovered
//    Y  = 1.3584 * Y
//    C1 = 2.2179 * (C1 - 156./255.)
//    C2 = 1.8215 * (C2 - 137./255.)
//   PhotoYCC data is transformed into R’G’B’ data
//    R' = L + C2
//    G' = L - 0.194*C1 - 0.509*C2
//    B' = L + C1
//    Where:  Y -  luminance; and C1, C2  - two chrominance values.
//
//  Equations are given above in assumption that the Y, C1, C2, R, G, and B
//   values are in the range [0..1].
//   Y, C1, C2, R, G, B - are scaled to the range [0..1] for the 32f depth,
//   to the range [0..IPP_MAX_8u] for the 8u depth,
//   to the range [0..IPP_MAX_16u] for the 16u depth,
//   to the range [IPP_MIN_16s..IPP_MAX_16s] for the 16s depth.
*)

  ippiRGBToYCC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToYCC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToYCC_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCC_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToYCC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToYCC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiYCCToRGB_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiRGBToXYZ and ippiXYZToRGB
//  Purpose:    Convert an image from RGB to XYZ format and backward.
//  Arguments:
//    pSrc          pointer to the source image ROI
//    srcStep       source image scan-line size (bytes)
//    pDst          pointer to the target image ROI
//    dstStep       target image scan-line size (bytes)
//    roiSize    size of ROI
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr     if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       otherwise
//  Reference:
//      David F. Rogers
//      Procedupal elements for computer graphics.
//      1985.
//
//  The basic equations to convert between Rec. 709 RGB (with its D65 white point) and CIE XYZ are:
//
//       X =  0.412453 * R + 0.35758 * G + 0.180423 * B
//       Y =  0.212671 * R + 0.71516 * G + 0.072169 * B
//       Z =  0.019334 * R + 0.119193* G + 0.950227 * B
//
//       R = 3.240479 * X - 1.53715  * Y  - 0.498535 * Z
//       G =-0.969256 * X + 1.875991 * Y  + 0.041556 * Z
//       B = 0.055648 * X - 0.204043 * Y  + 1.057311 * Z
//  Equations are given above in assumption that the X,Y,Z,R,G,and B
//   values are in the range [0..1].
//   Y, C1, C2, R, G, B - are scaled to the range [0..1] for the 32f depth,
//   to the range [0..IPP_MAX_8u] for the 8u depth,
//   to the range [0..IPP_MAX_16u] for the 16u depth,
//   to the range [IPP_MIN_16s..IPP_MAX_16s] for the 16s depth.
//
*)
  ippiRGBToXYZ_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToXYZ_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXYZToRGB_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiRGBToLUV and ippiLUVToRGB
//  Purpose:    Convert an image from RGB to XYZ format and backward.
//  Arguments:
//    pSrc          pointer to the source image ROI
//    srcStep       source image scan-line size (bytes)
//    pDst          pointer to the target image ROI
//    dstStep       target image scan-line size (bytes)
//    roiSize       size of ROI
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr     if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoErr       otherwise
//  Reference:
//     Computer graphics: principles and practices. James D. Foley... [et al.]. 2nd ed.
//     Addison-Wesley, c1990.p.(584)
//
//    At first an RGB image is converted to the XYZ format image (look at the functionstdcall;
//    ippRGB2XYZ8uC3R), then to the CIELUV with the white point D65 and CIE chromaticity
//    coordinates of white point (xn,yn) = (0.312713, 0.329016) and Yn = 1.0. is the luminance of white point.
//
//       L = 116. * (Y/Yn)**1/3. - 16.
//       U = 13. * L * ( u - un )
//       V = 13. * L * ( v - vn )
//      These are quantized and limited to the 8-bit range of 0 to 255.
//       L =   L * 255. / 100.
//       U = ( U + 134. ) * 255. / 354.
//       V = ( V + 140. ) * 255. / 256.
//       where:
//       u' = 4.*X / (X + 15.*Y + 3.*Z)
//       v' = 9.*Y / (X + 15.*Y + 3.*Z)
//       un = 4.*xn / ( -2.*xn + 12.*yn + 3. )
//       vn = 9.*yn / ( -2.*xn + 12.*yn + 3. ).
//       xn, yn is the CIE chromaticity coordinates of white point.
//       Yn = 255. is the luminance of white point.
//
//       The L component values are in the range [0..100], the U component values are
//       in the range [-134..220], and the V component values are in the range [-140..122].
//
//      The CIELUV to RGB conversion is performed as following. At first
//      a LUV image is converted to the XYZ image
//       L  =   L * 100./ 255.
//       U  = ( U * 354./ 255.) - 134.
//       V  = ( V * 256./ 255.) - 140.
//       u = U / ( 13.* L ) + un
//       v = V / ( 13.* L ) + vn
//       Y = (( L + 16. ) / 116. )**3.
//       Y *= Yn
//       X =  -9.* Y * u / (( u - 4.)* v - u * v )
//       Z = ( 9.*Y - 15*v*Y - v*X ) / 3. * v
//       where:
//       un = 4.*xn / ( -2.*xn + 12.*yn + 3. )
//       vn = 9.*yn / ( -2.*xn + 12.*yn + 3. ).
//       xn, yn is the CIE chromaticity coordinates of white point.
//       Yn = 255. is the luminance of white point.
//
//     Then the XYZ image is converted to the RGB image (look at the functionstdcall;
//     ippXYZ2RGB8uC3R ).
//
*)

  ippiRGBToLUV_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToLUV_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToLUV_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToLUV_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToLUV_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToLUV_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRGBToLUV_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRGBToLUV_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLUVToRGB_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippReduceBits
//  Purpose:    Transforms Image of a higher bit resolution to a lower bit resolution.
//  Arguments:
//     pSrc - Pointer to the source image .
//     pDst - Pointer to the resultant image .
//     roiSize - region of interest in pixels.
//     srcStep - step in bytes through source image to jump on the next line
//     dstStep - step in bytes through destination image to jump on the next line
//     noise   - the number specifying the noise added,is set in percentage of a range [0..100]
//     levels  - the number of output levels for halftoning (dithering)[2.. MAX_LEVELS],
//            where  MAX_LEVELS is  0x01 << depth and depth is depth of the destination image
//     dtype  -  the type of dithering to be used. The following are allowed
//        ippDitherNone     no dithering is done
//        ippDitherStucki   Stucki's dithering algorithm
//        ippDitherFS       Floid-Steinberg's dithering algorithm
//        ippDitherJJN      Jarvice-Judice-Ninke's dithering algorithm
//        ippDitherBayer    Bayer's dithering algorithm
//      RGB  values for the 32f data type should be in the range [0..1]
//  Returns:
//           ippStsNullPtrErr  if src == NULL or dst == NULL
//           ippStsStepErr,    if srcStep or dstStep is less or equal zero
//           ippStsSizeErr     if imgSize.width <= 0 || imgSize.height <= 0
//           ippStsNoiseValErr : "Bad value of noise amplitude for dithering"
//           ippStsDitherLevelsErr : "Number of dithering levels is out of range"
//           ippStsNoErr       else
*)

  ippiReduceBits_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16u8u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16u8u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16u8u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_16s8u_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16s8u_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16s8u_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_16s8u_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f8u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f8u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f8u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_32f16u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f16u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f16u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f16u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

  ippiReduceBits_32f16s_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f16s_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f16s_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;
  ippiReduceBits_32f16s_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;noise:longint;dtype:IppiDitherType;levels:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiColorTwist
//
//  Purpose:    Applies a color-twist matrix to an image.
//              |R|   | t11 t12 t13 t14 |   |r|
//              |G| = | t21 t22 t23 t24 | * |g|
//              |B|   | t31 t32 t33 t34 |   |b|
//
//               R = t11*r + t12*g + t13*b + t14
//               G = t21*r + t22*g + t23*b + t24
//               B = t31*r + t32*g + t33*b + t34
//
//  Return:
//    ippStsNullPtrErr      One of pointers are NULL
//    ippStsSizeErr         The size of images is less or equal zero
//    ippStsStepErr         The steps of images are less or equal zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of input image scan-line
//    pDst                  pointer to the  destination image
//    dstStep               size of output image scan-line
//    roiSize               size of ROI
//    twist                 color-twist matrix
*)
  ippiColorTwist32f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_8u_IP3R: function(var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16u_P3R: function(var pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16u_IP3R: function(var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16s_P3R: function(var pSrc:PIpp16s;srcStep:longint;var pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist32f_16s_IP3R: function(var pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist_32f_P3R: function(var pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;
  ippiColorTwist_32f_IP3R: function(var pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiColorTwist_32f_C4R
//
//  Purpose:    Applies a color-twist matrix to an image.
//              |R|   | t11 t12 t13 t14 |   |r|
//              |G| = | t21 t22 t23 t24 | * |g|
//              |B|   | t31 t32 t33 t34 |   |b|
//              |W|   | t41 t42 t43 t44 |   |w|
//               R = t11*r + t12*g + t13*b + t14*w
//               G = t21*r + t22*g + t23*b + t24*w
//               B = t31*r + t32*g + t33*b + t34*w
//               W = t41*r + t42*g + t43*b + t44*w
//
//  Return:
//    ippStsNullPtrErr      One of pointers are NULL
//    ippStsSizeErr         The size of images is less or equal zero
//    ippStsStepErr         The steps of images are less or equal zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of input image scan-line
//    pDst                  pointer to the  destination image
//    dstStep               size of output image scan-line
//    roiSize               size of ROI
//    twist                 color-twist matrix
*)

  ippiColorTwist_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var twist:Ipp32f):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiGamma
//
//  Purpose:    Converting RGB image to and from gamma-corrected R'G'B' image.
//                  1). Fwd:
//                      for R,G,B < 0.018
//                          R' = 4.5 * R
//                          G' = 4.5 * G
//                          B' = 4.5 * B
//                      for R,G,B >= 0.018
//                          R' = 1.099 * (R**0.45) - 0.099
//                          G' = 1.099 * (G**0.45) - 0.099
//                          B' = 1.099 * (B**0.45) - 0.099
//
//                  2). Inv:
//                      for R',G',B' < 0.0812
//                          R = R' / 4.5
//                          G = G' / 4.5
//                          B = B' / 4.5
//                      for R',G',B' >= 0.0812
//                          R = (( R' + 0.099 ) / 1.099 )** 1 / 0.45
//                          G = (( G' + 0.099 ) / 1.099 )** 1 / 0.45
//                          B = (( B' + 0.099 ) / 1.099 )** 1 / 0.45
//
//                  Note: example for range[0,1].
//
//  Return:
//    ippStsNullPtrErr      One of pointers are NULL
//    ippStsSizeErr         The size of images is less or equal zero
//    ippStsStepErr         The steps of images are less or equal zero
//    ippStsGammaRangeErr   vMax - vMin <= 0 (for 32f)
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of input image scan-line
//    pDst                  pointer to the  destination image
//    dstStep               size of output image scan-line
//    roiSize               size of ROI
//    [vMin...vMax]         range for depth 32f.
*)
  ippiGammaFwd_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_8u_IP3R: function(var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_8u_P3R: function(var pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_8u_IP3R: function(var pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_16u_P3R: function(var pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_16u_IP3R: function(var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_16u_P3R: function(var pSrc:PIpp16u;srcStep:longint;var pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaInv_16u_IP3R: function(var pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiGammaFwd_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaFwd_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaInv_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaInv_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaFwd_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaFwd_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaInv_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaInv_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaFwd_32f_P3R: function(var pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaFwd_32f_IP3R: function(var pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaInv_32f_P3R: function(var pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiGammaInv_32f_IP3R: function(var pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//                   Geometrical functions
///////////////////////////////////////////////////////////////////////////// *)

type
  IppiAxis=
    (
    ippAxsHorizontal,
    ippAxsVertical,
    ippAxsBoth
    );


const
    IPPI_INTER_NN     = 1;
    IPPI_INTER_LINEAR = 2;
    IPPI_INTER_CUBIC  = 4;
    IPPI_INTER_SUPER  = 8;
    IPPI_SMOOTH_EDGE  = 1 shl 31;


var
(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:        ippiMirror
//
//  Purpose:     ippiMirror mirrors the source image about a horizontal
//               or vertical or both together axes into resultant image
//
//  Context:
//
//  Returns:     IppStatus
//      ippStsNoErr,         if no errors
//      ippStsNullPtrErr,    if pSrc == NULL or pDst == NULL
//      ippStsStepErr,       if srcStep or dstStep is less or equal zero
//      ippStsSizeErr,       if width or height of images is less or equal zero
//      ippStsMirrorFlipErr, if (flip != ippAxsHorizontal) &&
//                              (flip != ippAxsVertical) &&
//                              (flip != ippAxsBoth)
//
//  Parameters:
//      pSrc     source image data
//      srcStep  step in src
//      pDst     resultant image data
//      dstStep  step in pDst
//      roiSize  region of interest
//      flip     specifies the axes to mirror the image:
//               ippAxsHorizontal for the horizontal axis,
//               ippAxsVertical   for a vertical axis,
//               ippAxsBoth       for both horizontal and vertical axes
//
//  Notes:
//
*)

  ippiMirror_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;

  ippiMirror_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_C1IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_C3IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_AC4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_16u_C4IR: function(pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;

  ippiMirror_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_C1IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_C3IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_AC4IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;
  ippiMirror_32s_C4IR: function(pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize;flip:IppiAxis):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiRemap
//  Purpose:        Remap srcImage with map.
//                  dst[i,j] = src[xMap[i,j], yMap[i,j]]
//  Context:
//  Returns:             IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//
//  Parameters:
//    pSrc        The source image data pointer (point to pixel (0,0)).
//    srcSize     The size of Src image.
//    srcStep     The step in Src image
//    srcPlane    The size of plane of Src image
//    srcROI      The Region Of Interest of Src image.
//    pxMap       The pointer to image with x coords of map.
//    xMapStep    The step in xMap image
//    pyMap       The pointer to image with y coords of map.
//    yMapStep    The step in yMap image
//    pDst        The resultant image data pointer.
//    dstStep     The step in Dst image
//    dstPlane    The size of plane of Dst image
//    dstRoiSize  Size of ROI in the Dst image
//                interpolation The type of interpolation to perform for resampling
//                the input image. The following are currently supported.
//                IPPI_INTER_NN     Nearest Neighbour interpolation.
//                IPPI_INTER_LINEAR Linear interpolation.
//                IPPI_INTER_CUBIC  Cubic interpolation.
//  Notes:
*)

  ippiRemap_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;var pDst:PIpp8u;dstStep:longint;dstROI:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;var pDst:PIpp32f;dstStep:longint;dstROI:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;var pDst:PIpp8u;dstStep:longint;dstROI:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;interpolation:longint):IppStatus;stdcall;

  ippiRemap_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pxMap:PIpp32f;xMapStep:longint;pyMap:PIpp32f;yMapStep:longint;var pDst:PIpp32f;dstStep:longint;dstROI:IppiSize;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:                ippiResize
//
//  Context:             Resizes a source image by xFactor and yFactor (not in-place)
//
//  Returns:             IppStatus
//      ippStsNoErr,            if no errors
//      ippStsNullPtrErr,       if pSrc == NULL or pDst == NULL
//      ippStsStepErr,          if srcStep or dstStep is less than or equal to zero
//      ippStsSizeErr,          if width or height of images is less than or equal to zero
//      ippStsResizeFactorErr,  if xFactor or yFactor is less than or equal to zero
//      ippStsInterpolationErr, if (interpolation != IPPI_INTER_NN) &&
//                                 (interpolation != IPPI_INTER_LINEAR) &&
//                                 (interpolation != IPPI_INTER_CUBIC) &&
//                                 (interpolation != IPPI_INTER_SUPER)
//  Parameters:
//      pSrc             pointer to the source image
//      srcSize          size of the source image
//      srcStep          step in bytes through the source image
//      srcROI           region of interest of the source image
//      pDst             pointer to the destination image
//      dstStep          step in bytes through the destination image
//      dstRoiSize       region of interest of the destination image
//      xFactor, yFactor factors by which the x and y dimensions are changed
//      interpolation    type of interpolation to perform for image resampling:
//                        IPPI_INTER_NN      nearest neighbour interpolation
//                        IPPI_INTER_LINEAR  linear interpolation
//                        IPPI_INTER_CUBIC   cubic convolution interpolation
//                        IPPI_INTER_SUPER   supersampling interpolation
//
//  Notes:
//
*)

  ippiResize_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_16u_AC4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_16u_P3R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_16u_P4R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;

  ippiResize_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:                ippiResizeCenter
//
//  Purpose:             Resizes a source image by xFactor and yFactor
//                       and shifts the destination image relative to the specified
//                       point with coordinates xCenter and yCenter  (not in-place)
//
//  Returns:             IppStatus
//      ippStsNoErr,            if no errors
//      ippStsNullPtrErr,       if pSrc == NULL or pDst == NULL
//      ippStsStepErr,          if srcStep or dstStep is less than or equal to zero
//      ippStsSizeErr,          if width or height of images is less than or equal to zero
//      ippStsResizeFactorErr,  if xFactor or yFactor is less than or equal to zero
//      ippStsInterpolationErr, if (interpolation != IPPI_INTER_NN) &&
//                                 (interpolation != IPPI_INTER_LINEAR) &&
//                                 (interpolation != IPPI_INTER_CUBIC) &&
//                                 (interpolation != IPPI_INTER_SUPER)
//  Parameters:
//      pSrc             pointer to the source image
//      srcSize          size of the source image
//      srcStep          step in bytes through the source image
//      srcROI           region of interest of the source image
//      pDst             pointer to the destination image
//      dstStep          step in bytes through the destination image
//      dstRoiSize       region of interest of the destination image
//      xFactor, yFactor factors by which the x and y dimensions are changed
//      xCenter, yCenter coordinates of the point that isn't shifted after image tesizing
//      interpolation    type of interpolation to perform for resampling the input image:
//                        IPPI_INTER_NN      nearest neighbour interpolation
//                        IPPI_INTER_LINEAR  linear interpolation
//                        IPPI_INTER_CUBIC   cubic convolution interpolation
//                        IPPI_INTER_SUPER   supersampling interpolation
//
//  Notes:
//
*)

  ippiResizeCenter_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_16u_AC4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_16u_P3R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_16u_P4R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeCenter_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFactor:double;yFactor:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:                ippiGetResizeFract
//
//  Context:             Recalculate resize factors for tiled image processing
//
//  Returns:             IppStatus
//      ippStsNoErr,            if no errors
//      ippStsSizeErr,          if width or height of images is less than or equal to zero
//      ippStsResizeFactorErr,  if xFactor or yFactor is less or equal zero
//      ippStsInterpolationErr, if (interpolation != IPPI_INTER_NN) &&
//                                 (interpolation != IPPI_INTER_LINEAR) &&
//                                 (interpolation != IPPI_INTER_CUBIC)
//  Parameters:
//      srcSize          size of the source image
//      srcROI           region of interest of the source image
//      xFactor, yFactor factors by which the x and y dimensions are changed
//      xFr, yFr         pointers to the recalculated resize factors
//      interpolation    type of interpolation to perform for resampling the input image:
//                        IPPI_INTER_NN      nearest neighbour interpolation
//                        IPPI_INTER_LINEAR  linear interpolation
//                        IPPI_INTER_CUBIC   cubic convolution interpolation
// Notes:
*)

  ippiGetResizeFract: function(srcSize:IppiSize;srcROI:IppiRect;xFactor:double;yFactor:double;xFr:Pdouble;yFr:Pdouble;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//
//  Name:                ippiResizeShift
//
//  Context:             Resize an image tile by xFactor and yFactor
//
//  Returns:             IppStatus
//      ippStsNoErr,            if no errors
//      ippStsNullPtrErr,       if pSrc == NULL or pDst == NULL
//      ippStsStepErr,          if srcStep or dstStep is less than or equal to zero
//      ippStsSizeErr,          if width or height of images is less than or equal to zero
//      ippStsResizeFactorErr,  if xFactor or yFactor is less or equal zero
//      ippStsInterpolationErr, if (interpolation != IPPI_INTER_NN) &&
//                                 (interpolation != IPPI_INTER_LINEAR) &&
//                                 (interpolation != IPPI_INTER_CUBIC)
//  Parameters:
//      pSrc             pointer to the source image
//      srcSize          size of the source image
//      srcStep          step in bytes through the source image
//      srcROI           region of interest of the source image
//      pDst             pointer to the destination image
//      dstStep          step in bytes through the destination image
//      dstROI           region of interest of the destination image
//      xFr, yFr         factors by which the x and y dimensions are changed
//      xShift, yShift   offsets(double) for processing area
//      interpolation    type of interpolation to perform for image resampling:
//                        IPPI_INTER_NN      nearest neighbour interpolation
//                        IPPI_INTER_LINEAR  linear interpolation
//                        IPPI_INTER_CUBIC   cubic convolution interpolation
// Notes:
//  - not in-place
//  - without supersampling interpolation
*)

  ippiResizeShift_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_16u_AC4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_16u_P3R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_16u_P4R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;

  ippiResizeShift_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;xFr:double;yFr:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetAffineBound
//  Purpose:        calculates bounding rectangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr   Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The transform matrix
//                  |X'|   |a11 a12| |X| |a13|
//                  |  | = |       |*| |+|   |
//                  |Y'|   |a21 a22| |Y| |a23|
//      bound       resultant bounding rectangle
//  Notes:
*)

  ippiGetAffineBound: function(roi:IppiRect;var bound:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetAffineQuad
//  Purpose:        calculates coordinates of quadrangle from transformed image ROI.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The transform matrix
//                  |X'|   |a11 a12| |X| |a13|
//                  |  | = |       |*| |+|   |
//                  |Y'|   |a21 a22| |Y| |a23|
//      quadr       resultant quadrangle
//  Notes:
*)

  ippiGetAffineQuad: function(roi:IppiRect;var quad:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetAffineTransform
//  Purpose:        calculates transform matrix from vertexes of quadrangle.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The resultant transform matrix
//                  |X'|   |a11 a12| |X| |a13|
//                  |  | = |       |*| |+|   |
//                  |Y'|   |a21 a22| |Y| |a23|
//      quad        quadrangle
//  Notes:
*)

  ippiGetAffineTransform: function(roi:IppiRect;var quad:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpAffine
//  Purpose:        makes Affine transform of image.
//                  |X'|   |a11 a12| |X| |a13|
//                  |  | = |       |*| |+|   |
//                  |Y'|   |a21 a22| |Y| |a23|
//  Context:
//  Returns:                IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      coeffs      The transform matrix
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    smoothed edges
//  Notes:
*)

  ippiWarpAffine_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffine_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpAffineBack
//  Purpose:        makes Back Affine transform of image.
//                  |X'|   |a11 a12| |X| |a13|
//                  |  | = |       |*| |+|   |
//                  |Y'|   |a21 a22| |Y| |a23|
//  Context:
//  Returns:                IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      coeffs      The transform matrix
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//  Notes:
*)

  ippiWarpAffineBack_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineBack_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpAffineQuad
//  Purpose:        makes Affine transform of image from srcQuad to dstQuad.
//                  |X'|   |a11 a12| |X| |a13|
//                  |  | = |       |*| |+|   |
//                  |Y'|   |a21 a22| |Y| |a23|
//  Context:
//  Returns:                IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      srcQuad     The Quadrangle in src
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      dstQuad     The Quadrangle in dst
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    smoothed edges
//  Notes:
*)

  ippiWarpAffineQuad_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpAffineQuad_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiRotate
//  Purpose:        rotates an image around (0, 0) by specified angle + shifts it.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      At least one pointer is NULL
//    ippStsSizeErr         The width or height of images is less than or equal to zero
//    ippStsInterpolateErr  The interpolation has an illegal value
//  Parameters:
//      pSrc        Pointer to the source image origin (0,0).
//      srcSize     The size of the source image.
//      srcStep     The step in bytes through the source image.
//      srcROI      The Region Of Interest of the source image.
//      pDst        Pointer to the destination image origin (0,0).
//      dstStep     The step in bytes through the destination image.
//      dstROI      The Region Of Interest of the destination image.
//      angle       The angle of rotation in degrees
//      xShift      The shift along x direction
//      yShift      The shift along y direction
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following types are currently supported:
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    edge smoothing (addition to one of the above types)
//  Notes:
*)

  ippiRotate_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_16u_AC4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_16u_P3R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiRotate_16u_P4R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiAddRotateShift
//  Purpose:        recalculates shifts for rotation around point
//                  (xCenter, yCenter) and sums to xShift, yShift.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to output data are NULL
//  Parameters:
//                  xCenter, yCenter    center of rotation
//                  angle               the angle of rotation
//                  xShift, yShift      pointers to modified shifts
//  Notes:
*)

  ippiAddRotateShift: function(xCenter:double;yCenter:double;angle:double;xShift:Pdouble;yShift:Pdouble):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetRotateShift
//  Purpose:        recalculates shifts for rotation around point
//                  (xCenter, yCenter) and store to xShift, yShift.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to output data are NULL
//  Parameters:
//                  xCenter, yCenter    center of rotation
//                  angle               the angle of rotation
//                  xShift, yShift      pointers to new shifts
//  Notes:
*)

  ippiGetRotateShift: function(xCenter:double;yCenter:double;angle:double;xShift:Pdouble;yShift:Pdouble):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetRotateQuad
//  Purpose:        calculates quadrangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr      Ok
//  Parameters:
//      roi             The image roi.
//      angle           The angle of rotation.
//      xShift, yShift  Shifts.
//      quad            Resultant quadrangle.
//  Notes:
*)

  ippiGetRotateQuad: function(roi:IppiRect;var quad:double;angle:double;xShift:double;yShift:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetRotateBound
//  Purpose:        calculates bounding rectangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr      Ok
//  Parameters:
//      roi             The image roi.
//      angle           The angle of rotation.
//      xShift, yShift  Shifts.
//      bound           Resultant bounding rectangle.
//  Notes:
*)

  ippiGetRotateBound: function(roi:IppiRect;var bound:double;angle:double;xShift:double;yShift:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiRotateCenter
//  Purpose:        Rotates an image about an arbitrary center.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      At least one of pointers is NULL
//    ippStsSizeErr         The width or height of images is less than or equal to zero
//    ippStsInterpolateErr  The interpolation has an illegal value.
//  Parameters:
//      pSrc        Pointer to the source image origin (0,0).
//      srcSize     The size of the source image.
//      srcStep     The step in bytes through the source image.
//      srcROI      The Region Of Interest of the source image.
//      pDst        POinter to the destination image origin (0,0).
//      dstStep     The step in bytes through the destination image.
//      dstROI      The Region Of Interest of the destination image.
//      angle       The angle of rotation in degrees.
//      xCenter     x coordinate of the center of rotation.
//      yCenter     y coordinate of the center of rotation.
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following types are currently supported:
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    edge smoothing (addition to one of the above types)
//  Notes:
*)

  ippiRotateCenter_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_16u_C1R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_16u_C3R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_16u_AC4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_16u_P3R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_16u_C4R: function(pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;
  ippiRotateCenter_16u_P4R: function(var pSrc:PIpp16u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp16u;dstStep:longint;dstROI:IppiRect;angle:double;xCenter:double;yCenter:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiShear
//  Purpose:        Makes shear transform of image.
//                  |X'|   |1  Shx| |X|
//                  |  | = |      |*| |
//                  |Y'|   |Shy  1| |Y|
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      xShift      The shift along x direction
//      yShift      The shift along y direction
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    smoothed edges
//  Notes:
*)

  ippiShear_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;
  ippiShear_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;xShear:double;yShear:double;xShift:double;yShift:double;interpolation:longint):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetShearQuad
//  Purpose:        calculates quadrangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr   Ok
//  Parameters:
//      roi             The image roi.
//      xShear, yShear  The coeffs of shear.
//      xShift, yShift  Shifts.
//      quad            Resultant quadrangle.
//  Notes:
*)

  ippiGetShearQuad: function(roi:IppiRect;var quad:double;xShear:double;yShear:double;xShift:double;yShift:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetShearBound
//  Purpose:        calculates bounding rectangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr   Ok
//  Parameters:
//      roi             The image roi.
//      xShear, yShear  The coeffs of shear.
//      xShift, yShift  Shifts.
//      bound           Resultant bounding rectangle.
//  Notes:
*)

  ippiGetShearBound: function(roi:IppiRect;var bound:double;xShear:double;yShear:double;xShift:double;yShift:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetPerspectiveBound
//  Purpose:        calculates bounding rectangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The transform matrix
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//      bound       resultant bounding rectangle
//  Notes:
*)

  ippiGetPerspectiveBound: function(roi:IppiRect;var bound:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetPerspectiveQuad
//  Purpose:        calculates coordinates of quadrangle from transformed image ROI.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The transform matrix
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//      quadr       resultant quadrangle
//  Notes:
*)

  ippiGetPerspectiveQuad: function(roi:IppiRect;var quad:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetPerspectiveTransform
//  Purpose:        calculates transform matrix from vertexes of quadrangle.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr   Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The resultant transform matrix
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//      quad        quadrangle
//  Notes:
*)

  ippiGetPerspectiveTransform: function(roi:IppiRect;var quad:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpPerspective
//  Purpose:        makes Perspective transform of image.
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      coeffs      The transform matrix
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    smoothed edges
//  Notes:
*)

  ippiWarpPerspective_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspective_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpPerspectiveBack
//  Purpose:        makes Back Perspective transform of image.
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      coeffs      The transform matrix
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//  Notes:
*)

  ippiWarpPerspectiveBack_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveBack_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpPerspectiveQuad
//  Purpose:        makes Back Perspective transform of image from srcQuad to dstQuad.
//                     a11*j + a12*i + a13
//                 x = -------------------
//                     a31*j + a32*i + a33
//
//                     a21*j + a22*i + a23
//                 y = -------------------
//                     a31*j + a32*i + a33
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      srcQuad     The Quadrangle in src
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      dstQuad     The Quadrangle in dst
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//  Notes:
*)

  ippiWarpPerspectiveQuad_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpPerspectiveQuad_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetBilinearBound
//  Purpose:        calculates bounding rectangle of the transformed image ROI.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr       Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The transform matrix
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//      bound       resultant bounding rectangle
//  Notes:
*)

  ippiGetBilinearBound: function(roi:IppiRect;var bound:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetBilinearQuad
//  Purpose:        calculates coordinates of quadrangle from transformed image ROI.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr        Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The transform matrix
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//      quadr       resultant quadrangle
//  Notes:
*)

  ippiGetBilinearQuad: function(roi:IppiRect;var quad:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiGetBilinearTransform
//  Purpose:        calculates transform matrix from vertexes of quadrangle.
//  Context:
//  Returns:        IppStatus.
//    ippStsNoErr        Ok
//  Parameters:
//      roi         The image roi.
//      coeffs      The resultant transform matrix
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//      quad        quadrangle
//  Notes:
*)

  ippiGetBilinearTransform: function(roi:IppiRect;var quad:double;var coeffs:double):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpBilinear
//  Purpose:        makes Bilinear transform of image.
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      coeffs      The transform matrix
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    smoothed edges
//  Notes:
*)

  ippiWarpBilinear_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinear_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpBilinearBack
//  Purpose:        makes Back Bilinear transform of image.
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippSstsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      coeffs      The transform matrix
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//  Notes:
*)

  ippiWarpBilinearBack_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearBack_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var coeffs:double;interpolation:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiWarpBilinearQuad
//  Purpose:        makes Bilinear transform of image from srcQuad to dstQuad.
//                  |X|   |a11|      |a12 a13| |J|   |a14|
//                  | | = |   |*JI + |       |*| | + |   |
//                  |Y|   |a21|      |a22 a23| |I|   |a24|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr           Ok
//    ippStsNullPtrErr      Some of pointers to input or output data are NULL
//    ippStsSizeErr         The width or height of images is less or equal zero
//    ippStsInterpolateErr  The interpolation is bad
//  Parameters:
//      pSrc        The source image data (point to pixel (0,0)).
//      srcSize     The size of src.
//      srcStep     The step in src
//      srcROI      The Region Of Interest of src.
//      srcQuad     The Quadrangle in src
//      pDst        The resultant image data (point to pixel (0,0)).
//      dstStep     The step in dst
//      dstROI      The Region Of Interest of dst.
//      dstQuad     The Quadrangle in dst
//      interpolate The type of interpolation to perform for resampling
//                  the input image. The following are currently supported.
//                  IPPI_INTER_NN       Nearest neighbour interpolation.
//                  IPPI_INTER_LINEAR   Linear interpolation.
//                  IPPI_INTER_CUBIC    Cubic convolution interpolation.
//                 +IPPI_SMOOTH_EDGE    smoothed edges
//  Notes:
*)

  ippiWarpBilinearQuad_8u_C1R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_8u_C3R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_8u_AC4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_8u_P3R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_8u_C4R: function(pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_8u_P4R: function(var pSrc:PIpp8u;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp8u;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_32f_C1R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_32f_C3R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_32f_AC4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_32f_P3R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_32f_C4R: function(pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;
  ippiWarpBilinearQuad_32f_P4R: function(var pSrc:PIpp32f;srcSize:IppiSize;srcStep:longint;srcROI:IppiRect;var srcQuad:double;var pDst:PIpp32f;dstStep:longint;dstROI:IppiRect;var dstQuad:double;interpolation:longint):IppStatus;stdcall;




(* /////////////////////////////////////////////////////////////////////////////
//                   Statistic functions
///////////////////////////////////////////////////////////////////////////// *)
type

IppiMomentState_64f = pointer;
PIppiMomentState_64f =^IppiMomentState_64f;

IppiMomentState_64s = pointer;
PIppiMomentState_64s =^IppiMomentState_64s;

IppiHuMoment_64f = array[0..6] of Ipp64f ;
IppiHuMoment_64s = array[0..6] of Ipp64s ;


var
(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiMomentInitAlloc()
//
//  Purpose:   Initializes MomentState structure
//
//  Returns:
//    ippStsMemAllocErr memory allocation failure
//    ippStsNoErr       no errors
//
//  Parameters:
//    hint     option to specify the computation algorithm
//    pState   pointer to the MomentState structure
*)
  ippiMomentInitAlloc_64f: function(var pState:PIppiMomentState_64f;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiMomentInitAlloc_64s: function(var pState:PIppiMomentState_64s;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiMomentFree()
//
//  Purpose:   Deallocates the MomentState structure
//
//  Returns:
//    ippStsNullPtrErr       pState==NULL
//    ippStsContextMatchErr  pState->idCtx != idCtxMoment
//    ippStsNoErr,           no errors
//
//  Parameters:
//    pState   pointer to the MomentState structure
//
*)
  ippiMomentFree_64f: function(pState:PIppiMomentState_64f):IppStatus;stdcall;
  ippiMomentFree_64s: function(pState:PIppiMomentState_64s):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiMomentGetStateSize_64s
//
//  Purpose:   Get size of state structure ippiMomentsState_64s in bytes
//
//  Returns:
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    pSize==NULL
//  Parameters:
//    hint                Option to specify the computation algorithm
//    pSize               Pointer to an integer that indicates the size
//                        of the structure ippiMomentState_64s.
//  Returns:
*)
  ippiMomentGetStateSize_64s: function(hint:IppHintAlgorithm;pSize:Plongint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMomentInit64s
//
//  Purpose:        Initializes ippiMomentState_64s structure (without allocates memory)
//
//  Returns:
//    ippStsNoErr   No errors
//
//  Parameters:
//    pState        Pointer to the MomentState structure
//    hint          option to specify the computation algorithm
*)
  ippiMomentInit_64s: function(pState:PIppiMomentState_64s;hint:IppHintAlgorithm):IppStatus;stdcall;


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
//    ippStsNoErr             no errors
//
//  Parameters:
//    pSrc     pointer to the source image
//    srcStep  step in bytes through the source image
//    roiSize  size of the source ROI
//    pState   pointer to the MomentState structure
//
//  Notes:
//    We consider moments up to the 3-rd order only
//
*)
  ippiMoments64f_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;stdcall;
  ippiMoments64f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;stdcall;
  ippiMoments64f_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;stdcall;

  ippiMoments64f_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;stdcall;
  ippiMoments64f_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;stdcall;
  ippiMoments64f_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64f):IppStatus;stdcall;

  ippiMoments64s_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64s):IppStatus;stdcall;
  ippiMoments64s_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64s):IppStatus;stdcall;
  ippiMoments64s_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pCtx:PIppiMomentState_64s):IppStatus;stdcall;


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
//    ippStsNoErr           if no errors
//
//  Parameters:
//    pState      pointer to the MomentState structure
//    mOrd        m- Order (X direction)
//    nOrd        n- Order (Y direction)
//    nChannel    channel number
//    roiOffset   offset of the ROI origin (ippiGetSpatialMoment ONLY!)
//    pValue      pointer to the retrieved moment value
//    scaleFactor factor to scale the moment value (for integer data)
//
//  NOTE:
//    ippiGetSpatialMoment use Absolute Coordinates (left-top image has 0,0).
//
*)
  ippiGetSpatialMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;roiOffset:IppiPoint;pValue:PIpp64f):IppStatus;stdcall;
  ippiGetCentralMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;pValue:PIpp64f):IppStatus;stdcall;

  ippiGetSpatialMoment_64s: function(pState:PIppiMomentState_64s;mOrd:longint;nOrd:longint;nChannel:longint;roiOffset:IppiPoint;pValue:PIpp64s;scaleFactor:longint):IppStatus;stdcall;
  ippiGetCentralMoment_64s: function(pState:PIppiMomentState_64s;mOrd:longint;nOrd:longint;nChannel:longint;pValue:PIpp64s;scaleFactor:longint):IppStatus;stdcall;

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
//    ippStsNoErr           if no errors
//
//  Parameters:
//    pState      pointer to the MomentState structure
//    mOrd        m- Order (X direction)
//    nOrd        n- Order (Y direction)
//    nChannel    channel number
//    roiOffset   offset of the ROI origin (ippiGetSpatialMoment ONLY!)
//    pValue      pointer to the normalized moment value
//    scaleFactor factor to scale the moment value (for integer data)
//
*)
  ippiGetNormalizedSpatialMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;roiOffset:IppiPoint;pValue:PIpp64f):IppStatus;stdcall;
  ippiGetNormalizedCentralMoment_64f: function(pState:PIppiMomentState_64f;mOrd:longint;nOrd:longint;nChannel:longint;pValue:PIpp64f):IppStatus;stdcall;

  ippiGetNormalizedSpatialMoment_64s: function(pState:PIppiMomentState_64s;mOrd:longint;nOrd:longint;nChannel:longint;roiOffset:IppiPoint;pValue:PIpp64s;scaleFactor:longint):IppStatus;stdcall;
  ippiGetNormalizedCentralMoment_64s: function(pState:PIppiMomentState_64s;mOrd:longint;nOrd:longint;nChannel:longint;pValue:PIpp64s;scaleFactor:longint):IppStatus;stdcall;


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
//    ippStsNoErr           if no errors
//
//  Parameters:
//    pState      pointer to the MomentState structure
//    nChannel    channel number
//    pHm         pointer to the array of the Hu moment invariants
//    scaleFactor factor to scale the moment value (for integer data)
//
//  Notes:
//    We only consider Hu moments up to the 7-th order
*)
  ippiGetHuMoments_64f: function(pState:PIppiMomentState_64f;nChannel:longint;pHm:IppiHuMoment_64f):IppStatus;stdcall;
  ippiGetHuMoments_64s: function(pState:PIppiMomentState_64s;nChannel:longint;pHm:IppiHuMoment_64s;scaleFactor:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNorm_Inf
//  Purpose:        computes the C-norm of pixel values of the image: n = MAX |src1|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step through the source image
//    roiSize     Size of the source ROI.
//    pValue      Pointer to the computed norm (one-channel data)
//    value       Array of the computed norms for each channel (multi-channel data)
//  Notes:
*)

  ippiNorm_Inf_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_Inf_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_Inf_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;roiSize:IppiSize;value:PIpp64f):IppStatus;stdcall;
  ippiNorm_Inf_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_Inf_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_Inf_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNorm_L1
//  Purpose:        computes the L1-norm of pixel values of the image: n = SUM |src1|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
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

  ippiNorm_L1_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_L1_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L1_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L1_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L1_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_L1_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L1_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L1_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L1_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNorm_L1_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNorm_L1_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNorm_L1_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNorm_L2
//  Purpose:        computes the L2-norm of pixel values of the image: n = SQRT(SUM |src1|^2)
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
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

  ippiNorm_L2_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_L2_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L2_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L2_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L2_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNorm_L2_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L2_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L2_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNorm_L2_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNorm_L2_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNorm_L2_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNorm_L2_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormDiff_Inf
//  Purpose:        computes the C-norm of pixel values of two images: n = MAX |src1 - src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Any of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//  Notes:
*)

  ippiNormDiff_Inf_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_Inf_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormDiff_L1
//  Purpose:        computes the L1-norm of pixel values of two images: n = SUM |src1 - src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Any of the pointers is NULL
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

  ippiNormDiff_L1_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_L1_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L1_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L1_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L1_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_L1_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L1_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L1_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L1_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormDiff_L1_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormDiff_L1_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormDiff_L1_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormDiff_L2
//  Purpose:        computes the L2-norm of pixel values of two images:
//                    n = SQRT(SUM |src1 - src2|^2)
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Any of the pointers is NULL
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

  ippiNormDiff_L2_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_L2_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L2_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L2_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L2_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormDiff_L2_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L2_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L2_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormDiff_L2_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormDiff_L2_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormDiff_L2_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormDiff_L2_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormRel_Inf
//  Purpose:        computes the relative error for the C-norm of pixel values of two images:
//                      n = MAX |src1 - src2| / MAX |src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Any of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//    ippStsDivByZero     if MAX |src2| == 0
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//  Notes:
*)

  ippiNormRel_Inf_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_Inf_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_Inf_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_Inf_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_Inf_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormRel_L1
//  Purpose:        computes the relative error for the 1-norm of pixel values of two images:
//                      n = SUM |src1 - src2| / SUM |src2|
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Any of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//    ippStsDivByZero     if SUM |src2| == 0
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//    hint                Option to specify the computation algorithm
//  Notes:
*)

  ippiNormRel_L1_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_L1_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L1_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L1_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L1_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_L1_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L1_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L1_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L1_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormRel_L1_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormRel_L1_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormRel_L1_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

(* //////////////////////////////////////////////////////////////////////////////////////////
//  Name:           ippiNormRel_L2
//  Purpose:        computes the relative error for the L2-norm of pixel values of two images:
//                      n = SQRT(SUM |src1 - src2|^2 / SUM |src2|^2)
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr         Ok
//    ippStsNullPtrErr    Any of the pointers is NULL
//    ippStsSizeErr       roiSize has a field with zero or negative value
//    ippStsDivByZero     if SUM |src2|^2 == 0
//  Parameters:
//    pSrc1, pSrc2        Pointers to the source images.
//    src1Step, src2Step  Steps in bytes through the source images
//    roiSize             Size of the source ROI.
//    pValue              Pointer to the computed norm (one-channel data)
//    value               Array of the computed norms for each channel (multi-channel data)
//    hint                Option to specify the computation algorithm
//  Notes:
*)

  ippiNormRel_L2_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_L2_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L2_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L2_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L2_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f):IppStatus;stdcall;

  ippiNormRel_L2_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L2_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L2_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;roiSize:IppiSize;var value:Ipp64f):IppStatus;stdcall;

  ippiNormRel_L2_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pValue:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormRel_L2_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormRel_L2_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiNormRel_L2_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var value:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiSum
//  Purpose:        computes the sum of image pixel values
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsStepErr      srcStep has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pSum        POinter to the result (one-channel data)
//    sum         Array containing the results (multi-channel data)
//    hint        Option to select the algorithmic implementation of the functionstdcall;
//  Notes:
*)

  ippiSum_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f):IppStatus;stdcall;

  ippiSum_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;stdcall;

  ippiSum_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;stdcall;

  ippiSum_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;stdcall;

  ippiSum_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f):IppStatus;stdcall;

  ippiSum_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;stdcall;

  ippiSum_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;stdcall;

  ippiSum_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f):IppStatus;stdcall;

  ippiSum_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pSum:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiSum_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiSum_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiSum_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var sum:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMean
//  Purpose:        computes the mean of image pixel values
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value.
//    ippStsStepErr      srcStep is less than or equal to zero
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the soutce image
//    roiSize     Size of the source ROI.
//    pMean       Pointer to the result (one-channel data)
//    mean        Array containing the results (multi-channel data)
//    hint        Option to select the algorithmic implementation of the functionstdcall;
//  Notes:
*)

  ippiMean_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f):IppStatus;stdcall;

  ippiMean_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;stdcall;

  ippiMean_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;stdcall;

  ippiMean_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;stdcall;

  ippiMean_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f):IppStatus;stdcall;

  ippiMean_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;stdcall;

  ippiMean_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;stdcall;

  ippiMean_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f):IppStatus;stdcall;

  ippiMean_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMean:PIpp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiMean_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiMean_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;

  ippiMean_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var mean:Ipp64f;hint:IppHintAlgorithm):IppStatus;stdcall;



(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippiQualityIndex_8u_C1R,     ippiQualityIndex_32f_C1R,
//      ippiQualityIndex_8u_C3R,     ippiQualityIndex_32f_C3R,
//      ippiQualityIndex_8u_AC4R,    ippiQualityIndex_32f_AC4R.
//
//  Purpose: ippiQualityIndex() function calculates the Universal Image Qualitystdcall;
//           Index. Instead of traditional error summation methods, the
//           proposed index is designed by modeling any image distortion as a
//           combination of three factors: loss of correlation, luminance
//           distortion, and contrast distortion. The dynamic range of index
//           is [-1.0, 1.0].
//
//  Arguments:
//      pSrc1         - pointer to the source image 1 ROI;
//      src1Step      - step in bytes through the source 1 image buffer;
//      pSrc2         - pointer to the source image 2 ROI;
//      src2Step      - step in bytes through the source 2 image buffer;
//      roiSize       - size of the sources 1 and 2 ROI in pixels;
//      pQualityIndex - pointer where to store the calculated Universal
//                      Image Quality Index;
//
//  Return:
//   ippStsNoErr        - Ok
//   ippStsNullPtrErr   - at least one of the pointers to pSrc1, pSrc2 or
//                                                       pQualityIndex is NULL;
//   ippStsSizeErr      - at least one of the sizes of roiSize is less or equal
//                                                                        zero;
//   ippStsStepErr      - at least one of the src1Step or src2Step is less or
//                                                                  equal zero;
//   ippStsMemAllocErr  - an error occur during allocation memory for internal
//                                                                     buffers.
*)
  ippiQualityIndex_8u32f_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;pQualityIndex:PIpp32f):IppStatus;stdcall;
  ippiQualityIndex_8u32f_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f):IppStatus;stdcall;
  ippiQualityIndex_8u32f_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f):IppStatus;stdcall;
  ippiQualityIndex_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;pQualityIndex:PIpp32f):IppStatus;stdcall;
  ippiQualityIndex_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f):IppStatus;stdcall;
  ippiQualityIndex_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;roiSize:IppiSize;var pQualityIndex:Ipp32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiHistogramRange
//  Purpose:        computes the intensity histogram of an image
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsMemAllocErr  There is not enough memory for the inner histogram
//    ippStsHistoNofLevelsErr Number of levels is less than 2
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source ROI.
//    pHist       Pointer to the computed histogram.
//    pLevels     Pointer to the array of level values.
//    nLevels     Number of levels
//  Notes:
*)
  ippiHistogramRange_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pHist:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pHist:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pHist:PIpp32s;pLevels:PIpp32f;nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiHistogramRange_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiHistogramEven
//  Purpose:        computes the intensity histogram of an image
//                  using equal bins - even histogram
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsMemAllocErr  There is not enough memory for the inner histogram
//    ippStsHistoNofLevelsErr Number of levels is less 2
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source ROI.
//    pHist       Pointer to the computed histogram.
//    pLevels     Pointer to the array of level values.
//    nLevels     Number of levels
//    lowerLevel  Lower level boundary
//    upperLevel  Upper level boundary
//  Notes:
*)
  ippiHistogramEven_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pHist:PIpp32s;pLevels:PIpp32s;nLevels:longint;lowerLevel:Ipp32s;upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;var lowerLevel:Ipp32s;var upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;var lowerLevel:Ipp32s;var upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;var lowerLevel:Ipp32s;var upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pHist:PIpp32s;pLevels:PIpp32s;nLevels:longint;lowerLevel:Ipp32s;upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;var lowerLevel:Ipp32s;var upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;var lowerLevel:Ipp32s;var upperLevel:Ipp32s):IppStatus;stdcall;
  ippiHistogramEven_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var pHist:PIpp32s;var pLevels:PIpp32s;var nLevels:longint;var lowerLevel:Ipp32s;var upperLevel:Ipp32s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiLUT
//  Purpose:        Performs intensity transformation of an image
//                  using lookup table (LUT)
//
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsMemAllocErr  There is not enough memory for the inner histogram
//    ippStsLUTNofLevelsErr Number of levels is less 2
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    pDst        Pointer to the destination image.
//    dstStep     Step in bytes through the destination image
//    roiSize     Size of the source and destination ROI.
//    pValues     Pointer to the array of intensity values
//    pLevels     Pointer to the array of level values
//    nLevels     Number of levels
//  Notes:
*)
  ippiLUT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pValues:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiLUT_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;

  ippiLUT_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pValues:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiLUT_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;

  ippiLUT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pValues:PIpp32f;pLevels:PIpp32f;nLevels:longint):IppStatus;stdcall;
  ippiLUT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiLUT_Linear
//  Purpose:        Performs intensity transformation of an image
//                  using lookup table (LUT) with linear interpolation
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsMemAllocErr  There is not enough memory for the inner histogram
//    ippStsLUTNofLevelsErr Number of levels is less 2
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    pDst        Pointer to the destination image.
//    dstStep     Step in bytes through the destination image
//    roiSize     Size of the source and destination ROI.
//    pValues     Pointer to the array of intensity values
//    pLevels     Pointer to the array of level values
//    nLevels     Number of levels
//  Notes:
*)
  ippiLUT_Linear_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pValues:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;

  ippiLUT_Linear_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pValues:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;

  ippiLUT_Linear_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pValues:PIpp32f;pLevels:PIpp32f;nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Linear_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiLUT_Cubic
//  Purpose:        Performs intensity transformation of an image
//                  using lookup table (LUT) with cubic interpolation
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//    ippStsMemAllocErr  There is not enough memory for the inner histogram
//    ippStsLUTNofLevelsErr Number of levels is less 2
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    pDst        Pointer to the destination image.
//    dstStep     Step in bytes through the destination image
//    roiSize     Size of the source and destination ROI.
//    pValues     Pointer to the array of intensity values
//    pLevels     Pointer to the array of level values
//    nLevels     Number of levels
//  Notes:
*)
  ippiLUT_Cubic_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pValues:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;

  ippiLUT_Cubic_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pValues:PIpp32s;pLevels:PIpp32s;nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32s;var pLevels:PIpp32s;var nLevels:longint):IppStatus;stdcall;

  ippiLUT_Cubic_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pValues:PIpp32f;pLevels:PIpp32f;nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;
  ippiLUT_Cubic_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var pValues:PIpp32f;var pLevels:PIpp32f;var nLevels:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:                ippiCountInRange
//
//  Purpose:             The counter of pixels whose intensity values are in the given range
//
//  Returns:             IppStatus
//      ippStsNoErr,      if no errors
//      ippStsNullPtrErr, if pSrc == NULL
//      ippStsStepErr,    if srcStep is less than or equal to zero
//      ippStsSizeErr,    if roiSize has a field with zero or negative value
//      ippStsRangeErr,   if lowerBound is greater than upperBound
//
//  Parameters:
//      pSrc             pointer to the source buffer
//      roiSize          size of the source ROI
//      srcStep          step through the source image buffer
//      counts           number of pixels within the given intensity range
//      lowerBound       lower limit of the range
//      upperBound       upper limit of the range
*)

  ippiCountInRange_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;counts:Plongint;lowerBound:Ipp8u;upperBound:Ipp8u):IppStatus;stdcall;
  ippiCountInRange_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp8u;var upperBound:Ipp8u):IppStatus;stdcall;
  ippiCountInRange_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp8u;var upperBound:Ipp8u):IppStatus;stdcall;
  ippiCountInRange_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;counts:Plongint;lowerBound:Ipp32f;upperBound:Ipp32f):IppStatus;stdcall;
  ippiCountInRange_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp32f;var upperBound:Ipp32f):IppStatus;stdcall;
  ippiCountInRange_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var counts:longint;var lowerBound:Ipp32f;var upperBound:Ipp32f):IppStatus;stdcall;


(* ///////////////////////////////////////////////////////////////////////////
//             Non-linear Filters
/////////////////////////////////////////////////////////////////////////// *)

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianHoriz_8u_C1R
//              ippiFilterMedianHoriz_8u_C3R
//              ippiFilterMedianHoriz_8u_AC4R
//              ippiFilterMedianHoriz_16s_C1R
//              ippiFilterMedianHoriz_16s_C3R
//              ippiFilterMedianHoriz_16s_AC4R
//              ippiFilterMedianHoriz_8u_C4R
//              ippiFilterMedianHoriz_16s_C4R
//  Purpose:    Horizontal Median Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   mask       filter mask
*)
  ippiFilterMedianHoriz_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianHoriz_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianVert_8u_C1R
//              ippiFilterMedianVert_8u_C3R
//              ippiFilterMedianVert_8u_AC4R
//              ippiFilterMedianVert_16s_C1R
//              ippiFilterMedianVert_16s_C3R
//              ippiFilterMedianVert_16s_AC4R
//              ippiFilterMedianVert_8u_C4R
//              ippiFilterMedianVert_16s_C4R
//  Purpose:    Vertical Median Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   mask       filter mask
*)
  ippiFilterMedianVert_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianVert_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedian_8u_C1R
//              ippiFilterMedian_8u_C3R
//              ippiFilterMedian_8u_AC4R
//              ippiFilterMedian_16s_C1R
//              ippiFilterMedian_16s_C3R
//              ippiFilterMedian_16s_AC4R
//              ippiFilterMedian_8u_C4R
//              ippiFilterMedian_16s_C4R
//  Purpose:    Box Median Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   maskSize   size of the mask in pixels
//   anchor     anchor cell specifying thr mask alignment with respect to
//              the position of input
*)
  ippiFilterMedian_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMedian_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianCross_8u_C1R
//              ippiFilterMedianCross_8u_C3R
//              ippiFilterMedianCross_8u_AC4R
//              ippiFilterMedianCross_16s_C1R
//              ippiFilterMedianCross_16s_C3R
//              ippiFilterMedianCross_16s_AC4R
//  Purpose:    Cross Median Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   mask       filter mask
*)
  ippiFilterMedianCross_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianCross_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianCross_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianCross_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianCross_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianCross_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMedianColor_8u_C3R
//              ippiFilterMedianColor_8u_AC4R
//              ippiFilterMedianColor_16s_C3R
//              ippiFilterMedianColor_16s_AC4R
//              ippiFilterMedianColor_32f_C3R
//              ippiFilterMedianColor_32f_AC4R
//  Purpose:    Box Color Median Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   mask       filter mask
*)
  ippiFilterMedianColor_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianColor_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianColor_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianColor_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianColor_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterMedianColor_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMax_8u_C1R
//              ippiFilterMax_8u_C3R
//              ippiFilterMax_8u_AC4R
//              ippiFilterMax_16s_C1R
//              ippiFilterMax_16s_C3R
//              ippiFilterMax_16s_AC4R
//              ippiFilterMax_32f_C1R
//              ippiFilterMax_32f_C3R
//              ippiFilterMax_32f_AC4R
//              ippiFilterMax_8u_C4R
//              ippiFilterMax_16s_C4R
//              ippiFilterMax_32f_C4R
//  Purpose:    Max Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask size
//   ippStsAnchorErr   Bad anchor point
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   maskSize   mask size
//   anchor     anchor point
*)
  ippiFilterMax_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMax_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterMin_8u_C1R
//              ippiFilterMin_8u_C3R
//              ippiFilterMin_8u_AC4R
//              ippiFilterMin_16s_C1R
//              ippiFilterMin_16s_C3R
//              ippiFilterMin_16s_AC4R
//              ippiFilterMin_32f_C1R
//              ippiFilterMin_32f_C3R
//              ippiFilterMin_32f_AC4R
//              ippiFilterMin_8u_C4R
//              ippiFilterMin_16s_C4R
//              ippiFilterMin_32f_C4R
//  Purpose:    Min Filter
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of dstRoi less or equal zero
//   ippStsMaskSizeErr Bad mask size
//   ippStsAnchorErr   Bad anchor point
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   dstRoiSize ROI size of output image
//   maskSize   mask size
//   anchor     anchor point
*)
  ippiFilterMin_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterMin_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

(* ///////////////////////////////////////////////////////////////////////////
//             Linear Filters
/////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
// Name:   ippiFilterBox_8u_C1R
//         ippiFilterBox_8u_C3R
//         ippiFilterBox_8u_AC4R
//         ippiFilterBox_16s_C1R
//         ippiFilterBox_16s_C3R
//         ippiFilterBox_16s_AC4R
//         ippiFilterBox_32f_C1R
//         ippiFilterBox_32f_C3R
//         ippiFilterBox_32f_AC4R
//
// Purpose:    Applies simple neighborhood averaging filter to blur the image.
// Returns:             IppStatus
//      ippStsNoErr,       if no errors.
//      ippStsNullPtrErr,  if pSrc == NULL or pDst == NULL.
//      ippStsSizeErr,     if width or height of images is less or equal zero.
//      ippStsMemAllocErrr,  can not allocate moment buffer.
//      ippStsAnchorErr    if width or height of images is less  zero.
//      ippStsMaskSizeErr  if width or height of cell is less or equal one.
// Parameters:
//      pSrc         - source image data(point to pixel (0,0)).
//      srcStep      - step in src
//      pDst         - resultant image data.
//      dstStep      - step in dst
//      dstRoiSize   - region of interest of dst
//      pSrcDst      - pointer to input for in-place operation
//      srcDstStep   - size of image scan-line for in-place operation
//      roiSize      - region of interest of image for in-place operation
//      maskSize     - Number of columns and rows in the neighbourhood(cell)to use.
//      anchor       - The [x,y] coordinates of the anchor cell in the neighbourhood.
//
*)
  ippiFilterBox_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;


  ippiFilterBox_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiFilterBox_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiFilterBox_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiFilterBox_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_16s_AC4IR: function(pSrc:PIpp16s;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiFilterBox_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilterBox_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;


(* ///////////////////////////////////////////////////////////////////////////
//             Filters with fixed kernel
/////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterPrewittHoriz_8u_C1R
//              ippiFilterPrewittHoriz_8u_C3R
//              ippiFilterPrewittHoriz_8u_AC4R
//              ippiFilterPrewittHoriz_16s_C1R
//              ippiFilterPrewittHoriz_16s_C3R
//              ippiFilterPrewittHoriz_16s_AC4R
//              ippiFilterPrewittHoriz_32f_C1R
//              ippiFilterPrewittHoriz_32f_C3R
//              ippiFilterPrewittHoriz_32f_AC4R
//              ippiFilterPrewittVert_8u_C1R
//              ippiFilterPrewittVert_8u_C3R
//              ippiFilterPrewittVert_8u_AC4R
//              ippiFilterPrewittVert_16s_C1R
//              ippiFilterPrewittVert_16s_C3R
//              ippiFilterPrewittVert_16s_AC4R
//              ippiFilterPrewittVert_32f_C1R
//              ippiFilterPrewittVert_32f_C3R
//              ippiFilterPrewittVert_32f_AC4R
//              ippiFilterSobelHoriz_8u_C1R
//              ippiFilterSobelHoriz_8u_C3R
//              ippiFilterSobelHoriz_8u_AC4R
//              ippiFilterSobelHoriz_16s_C1R
//              ippiFilterSobelHoriz_16s_C3R
//              ippiFilterSobelHoriz_16s_AC4R
//              ippiFilterSobelHoriz_32f_C1R
//              ippiFilterSobelHoriz_32f_C3R
//              ippiFilterSobelHoriz_32f_AC4R
//              ippiFilterSobelVert_8u_C1R
//              ippiFilterSobelVert_8u_C3R
//              ippiFilterSobelVert_8u_AC4R
//              ippiFilterSobelVert_16s_C1R
//              ippiFilterSobelVert_16s_C3R
//              ippiFilterSobelVert_16s_AC4R
//              ippiFilterSobelVert_32f_C1R
//              ippiFilterSobelVert_32f_C3R
//              ippiFilterSobelVert_32f_AC4R
//              ippiFilterRobertsDown_8u_C1R
//              ippiFilterRobertsDown_8u_C3R
//              ippiFilterRobertsDown_8u_AC4R
//              ippiFilterRobertsDown_16s_C1R
//              ippiFilterRobertsDown_16s_C3R
//              ippiFilterRobertsDown_16s_AC4R
//              ippiFilterRobertsDown_32f_C1R
//              ippiFilterRobertsDown_32f_C3R
//              ippiFilterRobertsDown_32f_AC4R
//              ippiFilterRobertsUp_8u_C1R
//              ippiFilterRobertsUp_8u_C3R
//              ippiFilterRobertsUp_8u_AC4R
//              ippiFilterRobertsUp_16s_C1R
//              ippiFilterRobertsUp_16s_C3R
//              ippiFilterRobertsUp_16s_AC4R
//              ippiFilterRobertsUp_32f_C1R
//              ippiFilterRobertsUp_32f_C3R
//              ippiFilterRobertsUp_32f_AC4R
//              ippiFilterSharpen_8u_C1R
//              ippiFilterSharpen_8u_C3R
//              ippiFilterSharpen_8u_AC4R
//              ippiFilterSharpen_16s_C1R
//              ippiFilterSharpen_16s_C3R
//              ippiFilterSharpen_16s_AC4R
//              ippiFilterSharpen_32f_C1R
//              ippiFilterSharpen_32f_C3R
//              ippiFilterSharpen_32f_AC4R
//              ippiFilterScharrVert_8u16s_C1R
//              ippiFilterScharrVert_8s16s_C1R
//              ippiFilterScharrVert_32f_C1R
//              ippiFilterScharrHoriz_8u16s_C1R
//              ippiFilterScharrHoriz_8s16s_C1R
//              ippiFilterScharrHoriz_32f_C1R
//              ippiFilterPrewittHoriz_8u_C4R
//              ippiFilterPrewittHoriz_16s_C4R
//              ippiFilterPrewittHoriz_32f_C4R
//              ippiFilterPrewittVert_8u_C4R
//              ippiFilterPrewittVert_16s_C4R
//              ippiFilterPrewittVert_32f_C4R
//              ippiFilterSobelHoriz_8u_C4R
//              ippiFilterSobelHoriz_16s_C4R
//              ippiFilterSobelHoriz_32f_C4R
//              ippiFilterSobelVert_8u_C4R
//              ippiFilterSobelVert_16s_C4R
//              ippiFilterSobelVert_32f_C4R
//              ippiFilterSharpen_8u_C4R
//              ippiFilterSharpen_16s_C4R
//              ippiFilterSharpen_32f_C4R
//
//  Purpose:    Fixed Filter with Matrix
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
//                               -1 -1  1
//              Sharpen          -1 16  1  X  1/8
//                               -1 -1  1
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
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   roiSize    ROI size
*)
  ippiFilterPrewittVert_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsUp_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterRobertsDown_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterScharrVert_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterScharrHoriz_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterScharrVert_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterScharrHoriz_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterScharrVert_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterScharrHoriz_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittVert_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterPrewittHoriz_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelVert_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiFilterSharpen_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterLaplace_8u_C1R
//              ippiFilterLaplace_8u_C3R
//              ippiFilterLaplace_8u_AC4R
//              ippiFilterLaplace_16s_C1R
//              ippiFilterLaplace_16s_C3R
//              ippiFilterLaplace_16s_AC4R
//              ippiFilterLaplace_32f_C1R
//              ippiFilterLaplace_32f_C3R
//              ippiFilterLaplace_32f_AC4R
//              ippiFilterGauss_8u_C1R
//              ippiFilterGauss_8u_C3R
//              ippiFilterGauss_8u_AC4R
//              ippiFilterGauss_16s_C1R
//              ippiFilterGauss_16s_C3R
//              ippiFilterGauss_16s_AC4R
//              ippiFilterGauss_32f_C1R
//              ippiFilterGauss_32f_C3R
//              ippiFilterGauss_32f_AC4R
//              ippiFilterLowpass_8u_C1R
//              ippiFilterLowpass_8u_C3R
//              ippiFilterLowpass_8u_AC4R
//              ippiFilterLowpass_16s_C1R
//              ippiFilterLowpass_16s_C3R
//              ippiFilterLowpass_16s_AC4R
//              ippiFilterLowpass_32f_C1R
//              ippiFilterLowpass_32f_C3R
//              ippiFilterLowpass_32f_AC4R
//              ippiFilterHipass_8u_C1R
//              ippiFilterHipass_8u_C3R
//              ippiFilterHipass_8u_AC4R
//              ippiFilterHipass_16s_C1R
//              ippiFilterHipass_16s_C3R
//              ippiFilterHipass_16s_AC4R
//              ippiFilterHipass_32f_C1R
//              ippiFilterHipass_32f_C3R
//              ippiFilterHipass_32f_AC4R
//              ippiFilterSobelVert_8u16s_C1R
//              ippiFilterSobelVert_8s16s_C1R
//              ippiFilterSobelVertMask_32f_C1R
//              ippiFilterSobelHoriz_8u16s_C1R
//              ippiFilterSobelHoriz_8s16s_C1R
//              ippiFilterSobelHorizMask_32f_C1R
//              ippiFilterSobelVertSecond_8u16s_C1R
//              ippiFilterSobelVertSecond_8s16s_C1R
//              ippiFilterSobelVertSecond_32f_C1R
//              ippiFilterSobelHorizSecond_8u16s_C1R
//              ippiFilterSobelHorizSecond_8s16s_C1R
//              ippiFilterSobelHorizSecond_32f_C1R
//              ippiFilterSobelCross_8u16s_C1R
//              ippiFilterSobelCross_8s16s_C1R
//              ippiFilterSobelCross_32f_C1R
//              ippiFilterLaplace_8u_C4R
//              ippiFilterLaplace_16s_C4R
//              ippiFilterLaplace_32f_C4R
//              ippiFilterGauss_8u_C4R
//              ippiFilterGauss_16s_C4R
//              ippiFilterGauss_32f_C4R
//              ippiFilterHipass_8u_C4R
//              ippiFilterHipass_16s_C4R
//              ippiFilterHipass_32f_C4R
//
//  Purpose:    Fixed Filter with Matrix
//
//                               -1 -1  1
//              Laplace (3x3)    -1  8  1
//                               -1 -1  1
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
//                               -2  -8 -12  -8  -4
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
//              SobelVertHoriz (5x5)    -2  -8 -12  -8  -2
//                                       0   0   0   0   0
//                                       1   4   6   4   1
//
//                               -1  -2   0   2   1
//                               -2  -4   0   4   2
//              SobelCross (5x5)  0   0   0   0   0
//                                2   4   0  -4  -2
//                                1   2   0  -2  -1
//
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//   ippStsMaskSizeErr Bad mask
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   roiSize    ROI size
//   mask       filter mask
*)
  ippiFilterLaplace_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLowpass_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelVert_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelVertSecond_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelHorizSecond_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelCross_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelVert_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelHoriz_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelVertSecond_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelHorizSecond_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelCross_8s16s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelVertMask_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelHorizMask_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelVertSecond_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelHorizSecond_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterSobelCross_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterLaplace_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterGauss_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;
  ippiFilterHipass_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;mask:IppiMaskSize):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//   Names:     ippiFilter_8u_C1R
//              ippiFilter_8u_C3R
//              ippiFilter_8u_C4R
//              ippiFilter_8u_AC4R
//              ippiFilter_16s_C1R
//              ippiFilter_16s_C3R
//              ippiFilter_16s_C4R
//              ippiFilter_16s_AC4R
//
//  Purpose:    Filters an image using a general integer rectangular kernel.
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc, pDst or pKernal are NULL
//   ippStsSizeErr     Some size of dstRoiSize or kernalSize less or equal zero
//   ippStsDivisorErr  Divisor is equal zero, function is aborted.stdcall;
//
//  Parameters:
//      pSrc        Pointer to the source buffer
//      srcStep     Step in bytes through the source image buffer
//      pDst        Pointer to the destination buffer
//      dstStep     Step in bytes through the destination image buffer
//      dstRoiSize  Size of the source and destination ROI in pixels
//      pKernel     Pointer to the kernel values ( 32s kernel )
//      kernelSize  Size of the rectangular kernel in pixels.
//      anchor      Anchor cell specifying the rectangular kernel alignment
//                  with respect to the position of the input pixel
//      divisor     The integer value by which the computed result is divided.
*)

  ippiFilter_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;
  ippiFilter_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:IppiSize;anchor:IppiPoint;divisor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilter32f_8u_C1R
//              ippiFilter32f_8u_C3R
//              ippiFilter32f_8u_C4R
//              ippiFilter32f_8u_AC4R
//              ippiFilter32f_16s_C1R
//              ippiFilter32f_16s_C3R
//              ippiFilter32f_16s_C4R
//              ippiFilter32f_16s_AC4R
//              ippiFilter_32f_C1R
//              ippiFilter_32f_C3R
//              ippiFilter_32f_C4R
//              ippiFilter_32f_AC4R
//  Purpose:    Filters an image using a general float rectangular kernel.
//  Return:
//   ippStsNoErr        Ok
//   ippStsNullPtrErr   Some of pointers to pSrc, pDst or pKernal are NULL
//   ippStsSizeErr      Some size of dstRoiSize or kernalSize less or equal zero
//
//  Parameters:
//      pSrc            Pointer to the source buffer
//      srcStep         Step in bytes through the source image buffer
//      pDst            Pointer to the destination buffer
//      dstStep         Step in bytes through the destination image buffer
//      dstRoiSize      Size of the source and destination ROI in pixels
//      pKernel         Pointer to the kernel values ( 32f kernel )
//      kernelSize      Size of the rectangular kernel in pixels.
//      anchor          Anchor cell specifying the rectangular kernel alignment
//                      with respect to the position of the input pixel
*)
  ippiFilter32f_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter32f_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiFilter_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//   Names:     ippiFilterColumn_8u_C1R
//              ippiFilterColumn_8u_C3R
//              ippiFilterColumn_8u_C4R
//              ippiFilterColumn_8u_AC4R
//              ippiFilterColumn_16s_C1R
//              ippiFilterColumn_16s_C3R
//              ippiFilterColumn_16s_C4R
//              ippiFilterColumn_16s_AC4R
//
//  Purpose:    Separable filters use a spatial 32s kernel consisting of a
//              single column
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc, pDst or pKernal are NULL
//   ippStsSizeErr     Some size of dstRoiSize or kernalSize less or equal zero
//   ippStsDivisorErr  Divisor is equal zero, function is aborted.stdcall;
//
//  Parameters:
//      pSrc        Pointer to the source buffer
//      srcStep     Step in bytes through the source image buffer
//      pDst        Pointer to the destination buffer
//      dstStep     Step in bytes through the destination image buffer
//      dstRoiSize  Size of the source and destination ROI in pixels
//      pKernel     Pointer to the column kernel values ( 32s kernel )
//      kernelSize  Size of the column kernel in pixels.
//      yAnchor     Anchor cell specifying the kernel vertical alignment with
//                  respect to the position of the input pixel
//      divisor     The integer value by which the computed result is divided.
*)
  ippiFilterColumn_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterColumn_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;yAnchor:longint;divisor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterColumn32f_8u_C1R
//              ippiFilterColumn32f_8u_C3R
//              ippiFilterColumn32f_8u_C4R
//              ippiFilterColumn32f_8u_AC4R
//              ippiFilterColumn32f_16s_C1R
//              ippiFilterColumn32f_16s_C3R
//              ippiFilterColumn32f_16s_C4R
//              ippiFilterColumn32f_16s_AC4R
//              ippiFilterColumn_32f_C1R
//              ippiFilterColumn_32f_C3R
//              ippiFilterColumn_32f_C4R
//              ippiFilterColumn_32f_AC4R
//
//  Purpose:    Separable filters use a spatial 32f kernel consisting of a
//              single column
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc, pDst or pKernal are NULL
//   ippStsSizeErr     Some size of dstRoiSize or kernalSize less or equal zero
//
//  Parameters:
//      pSrc        Pointer to the source buffer
//      srcStep     Step in bytes through the source image buffer
//      pDst        Pointer to the destination buffer
//      dstStep     Step in bytes through the destination image buffer
//      dstRoiSize  Size of the source and destination ROI in pixels
//      pKernel     Pointer to the column kernel values ( 32f kernel )
//      kernelSize  Size of the column kernel in pixels.
//      yAnchor     Anchor cell specifying the kernel vertical alignment with
//                  respect to the position of the input pixel
*)
  ippiFilterColumn32f_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn32f_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;
  ippiFilterColumn_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;yAnchor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterRow_8u_C1R
//              ippiFilterRow_8u_C3R
//              ippiFilterRow_8u_C4R
//              ippiFilterRow_8u_AC4R
//              ippiFilterRow_16s_C1R
//              ippiFilterRow_16s_C3R
//              ippiFilterRow_16s_C4R
//              ippiFilterRow_16s_AC4R
//
//  Purpose:    Separable filters use a spatial 32s kernel consisting of a
//              single row
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc, pDst or pKernal are NULL
//   ippStsSizeErr     Some size of dstRoiSize or kernalSize less or equal zero
//   ippStsDivisorErr  Divisor is equal zero, function is aborted.stdcall;
//
//  Parameters:
//      pSrc        Pointer to the source buffer
//      srcStep     Step in bytes through the source image buffer
//      pDst        Pointer to the destination buffer
//      dstStep     Step in bytes through the destination image buffer
//      dstRoiSize  Size of the source and destination ROI in pixels
//      pKernel     Pointer to the row kernel values ( 32s kernel )
//      kernelSize  Size of the row kernel in pixels.
//      xAnchor     Anchor cell specifying the kernel horizontal alignment with
//                  respect to the position of the input pixel.
//      divisor     The integer value by which the computed result is divided.
*)
  ippiFilterRow_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;
  ippiFilterRow_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32s;kernelSize:longint;xAnchor:longint;divisor:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Names:      ippiFilterRow32f_8u_C1R
//              ippiFilterRow32f_8u_C3R
//              ippiFilterRow32f_8u_C4R
//              ippiFilterRow32f_8u_AC4R
//              ippiFilterRow32f_16s_C1R
//              ippiFilterRow32f_16s_C3R
//              ippiFilterRow32f_16s_C4R
//              ippiFilterRow32f_16s_AC4R
//              ippiFilterRow_32f_C1R
//              ippiFilterRow_32f_C3R
//              ippiFilterRow_32f_C4R
//              ippiFilterRow_32f_AC4R
//
//  Purpose:    Separable filters use a spatial 32f kernel consisting of a
//              single row
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc, pDst or pKernal are NULL
//   ippStsSizeErr     Some size of dstRoiSize or kernalSize less or equal zero
//
//  Parameters:
//      pSrc        Pointer to the source buffer;
//      srcStep     Step in bytes through the source image buffer;
//      pDst        Pointer to the destination buffer;
//      dstStep     Step in bytes through the destination image buffer;
//      dstRoiSize  Size of the source and destination ROI in pixels;
//      pKernel     Pointer to the row kernel values ( 32f kernel );
//      kernelSize  Size of the row kernel in pixels;
//      xAnchor     Anchor cell specifying the kernel horizontal alignment with
//                  respect to the position of the input pixel.
*)
  ippiFilterRow32f_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow32f_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;
  ippiFilterRow_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pKernel:PIpp32f;kernelSize:longint;xAnchor:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippiFilterWienerGetBufferSize,
//      ippiFilterWiener_8u_C1R,  ippiFilterWiener_16s_C1R,
//      ippiFilterWiener_8u_C3R,  ippiFilterWiener_16s_C3R,
//      ippiFilterWiener_8u_C4R,  ippiFilterWiener_16s_C4R,
//      ippiFilterWiener_8u_AC4R, ippiFilterWiener_16s_AC4R,
//      ippiFilterWiener_32f_C1R,
//      ippiFilterWiener_32f_C3R,
//      ippiFilterWiener_32f_C4R,
//      ippiFilterWiener_32f_AC4R.
//
//  Purpose: Wiener function performs two-dimensional adaptive noise-removalstdcall;
//           filtering.
//
//  Arguments:
//      pSrc        - pointer to the source image ROI;
//      srcStep     - step in bytes through the source image buffer;
//      pDst        - pointer to the destination image ROI;
//      dstStep     - step in bytes through the destination image buffer;
//      dstRoiSize  - size of the destination ROI in pixels;
//      maskSize    - size of the rectangular local pixel neighborhood;
//      anchor      - anchor cell specifying the rectangular local pixel
//                       neighborhood with respect to the position of the input
//                                                                       pixel;
//      noise[]     - array where to store the calculated noise, if the noise
//                      isn't known (zero), or noise values (value in C1R case)
//                                                         for adaptive filter;
//      pBuffer     - pointer to the external buffer of the appropriate size;
//      pBufferSize - pointer where to store the calculated buffer size;
//      numChannels - number of channels ( 1, 3, or 4 ).
//
//  Return:
//   ippStsNoErr         - Ok
//   ippStsNumChannelsErr- bad or unsupported number of channels;
//   ippStsNullPtrErr    - at least one of the pointers to pSrc, pDst, noise or
//                                                             pBuffer is NULL;
//   ippStsSizeErr       - at least one of the sizes of dstRoiSize
//                                                       is less or equal zero;
//   ippStsMaskSizeErr   - at least one of the sizes of maskSize
//                                                       is less or equal zero;
//   ippStsNoiseRangeErr - at least one of the noise values is less then zero
//                                                         or greater then 1.0;
*)

  ippiFilterWienerGetBufferSize: function(dstRoiSize:IppiSize;maskSize:IppiSize;nChannels:longint;pBufferSize:Plongint):IppStatus;stdcall;
  ippiFilterWiener_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;
  ippiFilterWiener_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;maskSize:IppiSize;anchor:IppiPoint;var noise:Ipp32f;pBuffer:PIpp8u):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//   Names:     ippiConvFull_32f_C1R
//              ippiConvFull_32f_C3R
//              ippiConvFull_32f_AC4R
//              ippiConvFull_16s_C1R
//              ippiConvFull_16s_C3R
//              ippiConvFull_16s_AC4R
//              ippiConvFull_8u_C1R
//              ippiConvFull_8u_C3R
//              ippiConvFull_8u_AC4R
//
//  Purpose: Performs the 2-D convolution of matrices (images). If IppiSize's
//           of matrices are Wa*Ha and Wb*Hb correspondingly, then the
//           IppiSize of the resulting matrice (image) will be
//              (Wa+Wb-1)*(Ha+Hb-1).
//           If the resulting IppiSize > CRITERION, then convolusion is done
//             using 2D FFT.
//
//  Return:
//      ippStsNoErr       Ok;
//      ippStsNullPtrErr  Some of pointers to pSrc1, pSrc2 or pDst are NULL;
//      ippStsSizeErr     Some size of Src1Size, Src2Size or src1Step, src2Step,
//                        dstStep less or equal zero;
//      ippStsDivisorErr  Divisor is equal zero, function is aborted;stdcall;
//      ippStsMemAllocErr Memory allocation error.
//
//  Parameters:
//      pSrc1       Pointer to the source buffer 1;
//      src1Step    Step in bytes through the source image buffer 1;
//      Src1Size    Size of the source 1 in pixels;
//      pSrc2       Pointer to the source buffer 2;
//      src2Step    Step in bytes through the source image buffer 2;
//      Src2Size    Size of the source 2 in pixels;
//      pDst        Pointer to the destination buffer;
//      dstStep     Step in bytes through the destination image buffer;
//      divisor     The integer value by which the computed result is divided
//                  (in case of 8u or 16s data).
*)

  ippiConvFull_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;Src2Size:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiConvFull_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;Src2Size:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiConvFull_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;Src2Size:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiConvFull_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;Src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvFull_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;Src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvFull_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;Src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvFull_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;Src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvFull_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;Src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvFull_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;Src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint):IppStatus;stdcall;



(* ////////////////////////////////////////////////////////////////////////////
//   Names:     ippiConvValid_32f_C1R
//              ippiConvValid_32f_C3R
//              ippiConvValid_32f_AC4R
//              ippiConvValid_16s_C1R
//              ippiConvValid_16s_C3R
//              ippiConvValid_16s_AC4R
//              ippiConvValid_8u_C1R
//              ippiConvValid_8u_C3R
//              ippiConvValid_8u_AC4R
//
//  Purpose: Performs the VALID 2-D convolution of matrices (images).
//           If IppiSize's of matrices (images) are Wa*Ha and Wb*Hb
//           correspondingly, then the IppiSize of the resulting matrice
//           (image) will be (|Wa-Wb|+1)*(|Ha-Hb|+1).
//           If the smalest image IppiSize > CRITERION, then convolusion
//           is done using 2D FFT.
//
//  Return:
//      ippStsNoErr       Ok;
//      ippStsNullPtrErr  Some of pointers to pSrc1, pSrc2 or pDst are NULL;
//      ippStsSizeErr     Some size of Src1Size, Src2Size or src1Step, src2Step,
//                        dstStep less or equal zero;
//      ippStsDivisorErr  Divisor is equal zero, function is aborted;stdcall;
//      ippStsMemAllocErr Memory allocation error.
//
//  Parameters:
//      pSrc1       Pointer to the source buffer 1;
//      src1Step    Step in bytes through the source image buffer 1;
//      Src1Size    Size of the source 1 in pixels;
//      pSrc2       Pointer to the source buffer 2;
//      src2Step    Step in bytes through the source image buffer 2;
//      Src2Size    Size of the source 2 in pixels;
//      pDst        Pointer to the destination buffer;
//      dstStep     Step in bytes through the destination image buffer;
//      divisor     The integer value by which the computed result is divided
//                  (in case of 8u or 16s data).
*)

  ippiConvValid_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;Src2Size:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiConvValid_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;Src2Size:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiConvValid_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp32f;src2Step:longint;Src2Size:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiConvValid_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;Src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvValid_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;Src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvValid_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp16s;src2Step:longint;Src2Size:IppiSize;pDst:PIpp16s;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvValid_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;Src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvValid_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;Src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint):IppStatus;stdcall;
  ippiConvValid_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;Src1Size:IppiSize;pSrc2:PIpp8u;src2Step:longint;Src2Size:IppiSize;pDst:PIpp8u;dstStep:longint;divisor:longint):IppStatus;stdcall;


                                                                

(*)////////////////////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippiCrossCorrFull_Norm_32f_C1R,         ippiCrossCorrSame_Norm_32f_C1R,
//      ippiCrossCorrFull_Norm_32f_C3R,         ippiCrossCorrSame_Norm_32f_C3R,
//      ippiCrossCorrFull_Norm_32f_AC4R,        ippiCrossCorrSame_Norm_32f_AC4R,
//      ippiCrossCorrFull_Norm_8u_C1RSfs,       ippiCrossCorrSame_Norm_8u_C1RSfs,
//      ippiCrossCorrFull_Norm_8u_C3RSfs,       ippiCrossCorrSame_Norm_8u_C3RSfs,
//      ippiCrossCorrFull_Norm_8u_AC4RSfs,      ippiCrossCorrSame_Norm_8u_AC4RSfs,
//      ippiCrossCorrFull_Norm_8u32f_C1R,       ippiCrossCorrSame_Norm_8u32f_C1R,
//      ippiCrossCorrFull_Norm_8u32f_C3R,       ippiCrossCorrSame_Norm_8u32f_C3R,
//      ippiCrossCorrFull_Norm_8u32f_AC4R,      ippiCrossCorrSame_Norm_8u32f_AC4R,
//
//      ippiCrossCorrValid_Norm_32f_C1R,
//      ippiCrossCorrValid_Norm_32f_C3R,
//      ippiCrossCorrValid_Norm_32f_AC4R,
//      ippiCrossCorrValid_Norm_8u_C1RSfs,
//      ippiCrossCorrValid_Norm_8u_C3RSfs,
//      ippiCrossCorrValid_Norm_8u_AC4RSfs,
//      ippiCrossCorrValid_Norm_8u32f_C1R,
//      ippiCrossCorrValid_Norm_8u32f_C3R,
//      ippiCrossCorrValid_Norm_8u32f_AC4R.
//
//      ippiCrossCorrFull_Norm_32f_C4R,    ippiCrossCorrSame_Norm_32f_C4R,
//      ippiCrossCorrFull_Norm_8u_C4RSfs,  ippiCrossCorrSame_Norm_8u_C4RSfs,
//      ippiCrossCorrFull_Norm_8u32f_C4R,  ippiCrossCorrSame_Norm_8u32f_C4R,
//      ippiCrossCorrFull_Norm_8s32f_C1R,  ippiCrossCorrSame_Norm_8s32f_C1R,
//      ippiCrossCorrFull_Norm_8s32f_C3R,  ippiCrossCorrSame_Norm_8s32f_C3R,
//      ippiCrossCorrFull_Norm_8s32f_C4R,  ippiCrossCorrSame_Norm_8s32f_C4R,
//      ippiCrossCorrFull_Norm_8s32f_AC4R, ippiCrossCorrSame_Norm_8s32f_AC4R,
//
//      ippiCrossCorrValid_Norm_32f_C4R,
//      ippiCrossCorrValid_Norm_8u_C4RSfs,
//      ippiCrossCorrValid_Norm_8u32f_C4R,
//      ippiCrossCorrValid_Norm_8s32f_C1R,
//      ippiCrossCorrValid_Norm_8s32f_C3R,
//      ippiCrossCorrValid_Norm_8s32f_C4R,
//      ippiCrossCorrValid_Norm_8s32f_AC4R.
//
//  Purpose: ippiCrossCorr_Norm() function allows you to compute thestdcall;
//           cross-correlation of an image and a template (another image).
//           The cross-correlation values are image similarity measures: the
//           higher cross-correlation at a particular pixel, the more
//           similarity between the template and the image in the neighborhood
//           of the pixel. If IppiSize's of image and template are Wa * Ha and
//           Wb * Hb correspondingly, then the IppiSize of the resulting
//           matrice with normalized cross-correlation coefficients will be
//           a) in case of 'Full' suffix:
//              ( Wa + Wb - 1 )*( Ha + Hb - 1 ).
//           b) in case of 'Same' suffix:
//              ( Wa )*( Ha ).
//           c) in case of 'Valid' suffix:
//              ( Wa - Wb + 1 )*( Ha - Hb + 1 ).
//  Notice:
//           suffix 'R' (ROI) means only scanline alingment (srcStep), in
//           'Same' and 'Full' cases no any requirements for data outstand
//           the ROI - it's assumes that template and src are zerro padded.
//
//  Arguments:
//      pSrc        - pointer to the source image ROI;
//      srcStep     - step in bytes through the source image buffer;
//      srcRoiSize  - size of the source ROI in pixels;
//      pTpl        - pointer to the template ( feature ) image ROI;
//      tplStep     - step in bytes through the template image buffer;
//      tplRoiSize  - size of the template ROI in pixels;
//      pDst        - pointer to the destination buffer;
//      dstStep     - step in bytes through the destination image buffer;
//      scaleFactor - scale factor value ( in case of integer output data ).
//
//  Return:
//   ippStsNoErr        - Ok
//   ippStsNullPtrErr   - at least one of the pointers to pSrc, pDst or pTpl
//                                                                   is NULL;
//   ippStsSizeErr      - at least one of the sizes of srcRoiSize or tplRoiSize
//                        is less or equal zero, or at least one of the sizes
//                        of srcRoiSize is smaller then the corresponding size
//                        of the tplRoiSize;
//   ippStsStepErr      - at least one of the srcStep, tplStep or dstStep is
//                                                          less or equal zero;
//   ippStsMemAllocErr  - an error occur during allocation memory for internal
//                                                                     buffers.
*)

  ippiCrossCorrFull_Norm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiCrossCorrValid_Norm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiCrossCorrSame_Norm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_Norm_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiCrossCorrValid_Norm_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_Norm_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiCrossCorrSame_Norm_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_Norm_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

(*)////////////////////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippiCrossCorrFull_NormLevel_32f_C1R,    ippiCrossCorrSame_NormLevel_32f_C1R,
//      ippiCrossCorrFull_NormLevel_32f_C3R,    ippiCrossCorrSame_NormLevel_32f_C3R,
//      ippiCrossCorrFull_NormLevel_32f_C4R,    ippiCrossCorrSame_NormLevel_32f_C4R,
//      ippiCrossCorrFull_NormLevel_32f_AC4R,   ippiCrossCorrSame_NormLevel_32f_AC4R,
//      ippiCrossCorrFull_NormLevel_8u_C1RSfs,  ippiCrossCorrSame_NormLevel_8u_C1RSfs,
//      ippiCrossCorrFull_NormLevel_8u_C3RSfs,  ippiCrossCorrSame_NormLevel_8u_C3RSfs,
//      ippiCrossCorrFull_NormLevel_8u_C4RSfs,  ippiCrossCorrSame_NormLevel_8u_C4RSfs,
//      ippiCrossCorrFull_NormLevel_8u_AC4RSfs, ippiCrossCorrSame_NormLevel_8u_AC4RSfs,
//      ippiCrossCorrFull_NormLevel_8u32f_C1R,  ippiCrossCorrSame_NormLevel_8u32f_C1R,
//      ippiCrossCorrFull_NormLevel_8u32f_C3R,  ippiCrossCorrSame_NormLevel_8u32f_C3R,
//      ippiCrossCorrFull_NormLevel_8u32f_C4R,  ippiCrossCorrSame_NormLevel_8u32f_C4R,
//      ippiCrossCorrFull_NormLevel_8u32f_AC4R, ippiCrossCorrSame_NormLevel_8u32f_AC4R,
//      ippiCrossCorrFull_NormLevel_8s32f_C1R,  ippiCrossCorrSame_NormLevel_8s32f_C1R,
//      ippiCrossCorrFull_NormLevel_8s32f_C3R,  ippiCrossCorrSame_NormLevel_8s32f_C3R,
//      ippiCrossCorrFull_NormLevel_8s32f_C4R,  ippiCrossCorrSame_NormLevel_8s32f_C4R,
//      ippiCrossCorrFull_NormLevel_8s32f_AC4R, ippiCrossCorrSame_NormLevel_8s32f_AC4R,
//
//      ippiCrossCorrValid_NormLevel_32f_C1R,
//      ippiCrossCorrValid_NormLevel_32f_C3R,
//      ippiCrossCorrValid_NormLevel_32f_C4R,
//      ippiCrossCorrValid_NormLevel_32f_AC4R,
//      ippiCrossCorrValid_NormLevel_8u_C1RSfs,
//      ippiCrossCorrValid_NormLevel_8u_C3RSfs,
//      ippiCrossCorrValid_NormLevel_8u_C4RSfs,
//      ippiCrossCorrValid_NormLevel_8u_AC4RSfs,
//      ippiCrossCorrValid_NormLevel_8u32f_C1R,
//      ippiCrossCorrValid_NormLevel_8u32f_C3R,
//      ippiCrossCorrValid_NormLevel_8u32f_C4R,
//      ippiCrossCorrValid_NormLevel_8u32f_AC4R,
//      ippiCrossCorrValid_NormLevel_8s32f_C1R,
//      ippiCrossCorrValid_NormLevel_8s32f_C3R,
//      ippiCrossCorrValid_NormLevel_8s32f_C4R,
//      ippiCrossCorrValid_NormLevel_8s32f_AC4R.
//
//  Purpose: ippiCrossCorr_NormLevel() function allows you to compute thestdcall;
//           cross-correlation of an image and a template (another image).
//           The cross-correlation values are image similarity measures: the
//           higher cross-correlation at a particular pixel, the more
//           similarity between the template and the image in the neighborhood
//           of the pixel. If IppiSize's of image and template are Wa * Ha and
//           Wb * Hb correspondingly, then the IppiSize of the resulting
//           matrice with normalized cross-correlation coefficients will be
//           a) in case of 'Full' suffix:
//              ( Wa + Wb - 1 )*( Ha + Hb - 1 ).
//           b) in case of 'Same' suffix:
//              ( Wa )*( Ha ).
//           c) in case of 'Valid' suffix:
//              ( Wa - Wb + 1 )*( Ha - Hb + 1 ).
//  Notice:
//           suffix 'R' (ROI) means only scanline alingment (srcStep), in
//           'Same' and 'Full' cases no any requirements for data outstand
//           the ROI - it's assumes that template and src are zerro padded.
//           The difference from ippiCrossCorr_Norm() functions is the using
//           of Zerro Mean image and Template to avoid brightness impact.
//           (Before the calculation of the cross-correlation coefficients,
//           the mean of the image in the region under the feature is subtracted
//           from every image pixel; the same for the template.)
//
//  Arguments:
//      pSrc        - pointer to the source image ROI;
//      srcStep     - step in bytes through the source image buffer;
//      srcRoiSize  - size of the source ROI in pixels;
//      pTpl        - pointer to the template ( feature ) image ROI;
//      tplStep     - step in bytes through the template image buffer;
//      tplRoiSize  - size of the template ROI in pixels;
//      pDst        - pointer to the destination buffer;
//      dstStep     - step in bytes through the destination image buffer;
//      scaleFactor - scale factor value ( in case of integer output data ).
//
//  Return:
//   ippStsNoErr        - Ok
//   ippStsNullPtrErr   - at least one of the pointers to pSrc, pDst or pTpl is NULL;
//   ippStsSizeErr      - at least one of the sizes of srcRoiSize or tplRoiSize is less or equal zero,
//                        or at least one of the sizes of srcRoiSize is smaller then the corresponding
//                        size of the tplRoiSize;
//   ippStsStepErr      - at least one of the srcStep, tplStep or dstStep is less or equal zero;
//   ippStsMemAllocErr  - an error occur during allocation memory for internal buffers.
*)

  ippiCrossCorrFull_NormLevel_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrFull_NormLevel_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiCrossCorrValid_NormLevel_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrValid_NormLevel_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiCrossCorrSame_NormLevel_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiCrossCorrSame_NormLevel_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;


(*)////////////////////////////////////////////////////////////////////////////////////////////
//  Names:
//      ippiSqrDistanceFull_Norm_32f_C1R,    ippiSqrDistanceSame_Norm_32f_C1R,
//      ippiSqrDistanceFull_Norm_32f_C3R,    ippiSqrDistanceSame_Norm_32f_C3R,
//      ippiSqrDistanceFull_Norm_32f_AC4R,   ippiSqrDistanceSame_Norm_32f_AC4R,
//      ippiSqrDistanceFull_Norm_8u_C1RSfs,  ippiSqrDistanceSame_Norm_8u_C1RSfs,
//      ippiSqrDistanceFull_Norm_8u_C3RSfs,  ippiSqrDistanceSame_Norm_8u_C3RSfs,
//      ippiSqrDistanceFull_Norm_8u_AC4RSfs, ippiSqrDistanceSame_Norm_8u_AC4RSfs,
//      ippiSqrDistanceFull_Norm_8u32f_C1R,  ippiSqrDistanceSame_Norm_8u32f_C1R,
//      ippiSqrDistanceFull_Norm_8u32f_C3R,  ippiSqrDistanceSame_Norm_8u32f_C3R,
//      ippiSqrDistanceFull_Norm_8u32f_AC4R, ippiSqrDistanceSame_Norm_8u32f_AC4R,
//
//      ippiSqrDistanceValid_Norm_32f_C1R,
//      ippiSqrDistanceValid_Norm_32f_C3R,
//      ippiSqrDistanceValid_Norm_32f_AC4R,
//      ippiSqrDistanceValid_Norm_8u_C1RSfs,
//      ippiSqrDistanceValid_Norm_8u_C3RSfs,
//      ippiSqrDistanceValid_Norm_8u_AC4RSfs,
//      ippiSqrDistanceValid_Norm_8u32f_C1R,
//      ippiSqrDistanceValid_Norm_8u32f_C3R,
//      ippiSqrDistanceValid_Norm_8u32f_AC4R.
//
//      ippiSqrDistanceFull_Norm_32f_C4R,    ippiSqrDistanceSame_Norm_32f_C4R,
//      ippiSqrDistanceFull_Norm_8u_C4RSfs,  ippiSqrDistanceSame_Norm_8u_C4RSfs,
//      ippiSqrDistanceFull_Norm_8u32f_C4R,  ippiSqrDistanceSame_Norm_8u32f_C4R,
//      ippiSqrDistanceFull_Norm_8s32f_C1R,  ippiSqrDistanceSame_Norm_8s32f_C1R,
//      ippiSqrDistanceFull_Norm_8s32f_C3R,  ippiSqrDistanceSame_Norm_8s32f_C3R,
//      ippiSqrDistanceFull_Norm_8s32f_C4R,  ippiSqrDistanceSame_Norm_8s32f_C4R,
//      ippiSqrDistanceFull_Norm_8s32f_AC4R, ippiSqrDistanceSame_Norm_8s32f_AC4R,
//
//      ippiSqrDistanceValid_Norm_32f_C4R,
//      ippiSqrDistanceValid_Norm_8u_C4RSfs,
//      ippiSqrDistanceValid_Norm_8u32f_C4R,
//      ippiSqrDistanceValid_Norm_8s32f_C1R,
//      ippiSqrDistanceValid_Norm_8s32f_C3R,
//      ippiSqrDistanceValid_Norm_8s32f_C4R,
//      ippiSqrDistanceValid_Norm_8s32f_AC4R.
//
//  Purpose: ippiSqrDistance_Norm() function allows you to compute thestdcall;
//           Euclidean Distance or Sum of Squared Distance (SSD) of an image
//           and a template (another image).
//               The SSD values are image similarity measures: the smaller
//           value of SSD at a particular pixel, the more similarity between
//           the template and the image in the neighborhood of the pixel.
//               If IppiSize's of image and template are Wa * Ha and
//           Wb * Hb correspondingly, then the IppiSize of the resulting
//           matrice with normalized SSD coefficients will be
//           a) in case of 'Full' suffix:
//              ( Wa + Wb - 1 )*( Ha + Hb - 1 ).
//           b) in case of 'Same' suffix:
//              ( Wa )*( Ha ).
//           c) in case of 'Valid' suffix:
//              ( Wa - Wb + 1 )*( Ha - Hb + 1 ).
//  Notice:
//           suffix 'R' (ROI) means only scanline alingment (srcStep), in
//           'Same' and 'Full' cases no any requirements for data outstand
//           the ROI - it's assumes that template and src are zerro padded.
//
//  Arguments:
//      pSrc        - pointer to the source image ROI;
//      srcStep     - step in bytes through the source image buffer;
//      srcRoiSize  - size of the source ROI in pixels;
//      pTpl        - pointer to the template ( feature ) image ROI;
//      tplStep     - step in bytes through the template image buffer;
//      tplRoiSize  - size of the template ROI in pixels;
//      pDst        - pointer to the destination buffer;
//      dstStep     - step in bytes through the destination image buffer;
//      scaleFactor - scale factor value ( in case of integer output data ).
//
//  Return:
//   ippStsNoErr        - Ok
//   ippStsNullPtrErr   - at least one of the pointers to pSrc, pDst or pTpl is NULL;
//   ippStsSizeErr      - at least one of the sizes of srcRoiSize or tplRoiSize is less or equal zero,
//                        or at least one of the sizes of srcRoiSize is smaller then the corresponding
//                        size of the tplRoiSize;
//   ippStsStepErr      - at least one of the srcStep, tplStep or dstStep is less or equal zero;
//   ippStsMemAllocErr  - an error occur during allocation memory for internal buffers.
*)

  ippiSqrDistanceFull_Norm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiSqrDistanceValid_Norm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiSqrDistanceSame_Norm_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u_C1RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u_C3RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u_AC4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiSqrDistanceFull_Norm_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceFull_Norm_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiSqrDistanceValid_Norm_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceValid_Norm_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;

  ippiSqrDistanceSame_Norm_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp32f;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8s;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp32f;dstStep:longint):IppStatus;stdcall;
  ippiSqrDistanceSame_Norm_8u_C4RSfs: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pTpl:PIpp8u;tplStep:longint;tplRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;scaleFactor:longint):IppStatus;stdcall;


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
//
//  Purpose:        Threshold operation
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to input for in-place operation
//   srcDstStep size of image scan-line for in-place operation
//   roiSize    ROI size
//   threshold  level (or levels) of the threshold operation
//   ippCmpOp      comparison mode, ippCmpLess or ippCmpGreater
*)
  ippiThreshold_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;

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
//
//  Purpose:        Threshold operation if Greater
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to input for in-place operation
//   srcDstStep size of image scan-line for in-place operation
//   roiSize    ROI size
//   threshold  level (or levels) of the threshold operation
*)
  ippiThreshold_GT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GT_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GT_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GT_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GT_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GT_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GT_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GT_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GT_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GT_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GT_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GT_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GT_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GT_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GT_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GT_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;

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
//
//  Purpose:        Threshold operation if Less
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to input for in-place operation
//   srcDstStep size of image scan-line for in-place operation
//   roiSize    ROI size
//   threshold  level (or levels) of the threshold operation
*)
  ippiThreshold_LT_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LT_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LT_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LT_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LT_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LT_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LT_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LT_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LT_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LT_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LT_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LT_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LT_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LT_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LT_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LT_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LT_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LT_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f):IppStatus;stdcall;

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
//
//  Purpose:        Thresold operations
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to input for in-place operation
//   srcDstStep size of image scan-line for in-place operation
//   roiSize    ROI size
//   threshold  level (or levels) of the threshold operation
//   value      replacing value (or values)
//   ippCmpOp      comparison mode, ippCmpLess or ippCmpGreater
*)
  ippiThreshold_Val_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiThreshold_Val_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f;ippCmpOp:IppCmpOp):IppStatus;stdcall;

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
//
//  Purpose:        Thresold operations. Replace if Greater.
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to input for in-place operation
//   srcDstStep size of image scan-line for in-place operation
//   roiSize    ROI size
//   threshold  level (or levels) of the threshold operation
//   value      replacing value (or values)
//   ippCmpOp      comparison mode, ippCmpLess or ippCmpGreater
*)
  ippiThreshold_GTVal_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_GTVal_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_GTVal_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_GTVal_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;

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
//
//  Purpose:        Thresold operations. Replace if Less.
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc       pointer to input image
//   srcStep    size of input image scan-line
//   pDst       pointer to output image
//   dstStep    size of output image scan-line
//   pSrcDst    pointer to input for in-place operation
//   srcDstStep size of image scan-line for in-place operation
//   roiSize    ROI size
//   threshold  level (or levels) of the threshold operation
//   value      replacing value (or values)
//   ippCmpOp      comparison mode, ippCmpLess or ippCmpGreater
*)
  ippiThreshold_LTVal_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp8u;value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp16s;value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;threshold:Ipp32f;value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTVal_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp8u;var value:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTVal_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp16s;var value:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTVal_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var threshold:Ipp32f;var value:Ipp32f):IppStatus;stdcall;

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
//
//  Purpose:        Threshold operation
//  Return:
//   ippStsNoErr       Ok
//   ippStsNullPtrErr  Some of pointers to pSrc or pDst are NULL
//   ippStsSizeErr     Some size of roi less or equal zero
//
//  Parameters:
//   pSrc           pointer to input image
//   srcStep        size of input image scan-line
//   pDst           pointer to output image
//   dstStep        size of output image scan-line
//   pSrcDst        pointer to input for in-place operation
//   srcDstStep     size of image scan-line for in-place operation
//   roiSize        ROI size
//   thresholdGT    level (or levels) of the threshold operation Greater
//   valueGT        replacing value (or values) of the threshold operation
//                  Greater
//   thresholdLT    level (or levels) of the threshold operation Less
//   valueLT        replacing value (or values) of the threshold operation
//                  Less
*)
  ippiThreshold_LTValGTVal_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp8u;valueLT:Ipp8u;thresholdGT:Ipp8u;valueGT:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp16s;valueLT:Ipp16s;thresholdGT:Ipp16s;valueGT:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;thresholdLT:Ipp32f;valueLT:Ipp32f;thresholdGT:Ipp32f;valueGT:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp8u;valueLT:Ipp8u;thresholdGT:Ipp8u;valueGT:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp16s;valueLT:Ipp16s;thresholdGT:Ipp16s;valueGT:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;thresholdLT:Ipp32f;valueLT:Ipp32f;thresholdGT:Ipp32f;valueGT:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp8u;var valueLT:Ipp8u;var thresholdGT:Ipp8u;var valueGT:Ipp8u):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp16s;var valueLT:Ipp16s;var thresholdGT:Ipp16s;var valueGT:Ipp16s):IppStatus;stdcall;
  ippiThreshold_LTValGTVal_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;var thresholdLT:Ipp32f;var valueLT:Ipp32f;var thresholdGT:Ipp32f;var valueGT:Ipp32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//                   Convert and Initialization functions
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopy
//
//  Purpose:    copy pixel values from the source image to the destination  image.
//
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         roiSize has a field with zero or negative value
//    ippStsStepErr         One of the steps is less than or equal to zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image buffer
//    srcStep               step in bytes through the source image buffer
//    pDst                  pointer to the  destination image buffer
//    dstStep               step in bytes through the destination image buffer
//    roiSize               size of ROI
//    pMask                 pointer to the mask image buffer
//    maskStep              step in bytes through the mask image buffer
*)

  ippiCopy_8u_C3C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C1C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C4C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C1C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C3CR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C4CR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_AC4C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C3AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C1MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_8u_C3MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_8u_C4MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_8u_AC4MR: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_16s_C3C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C1C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C4C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C1C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C3CR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C4CR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_AC4C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C3AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C1MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_16s_C3MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_16s_C4MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_16s_AC4MR: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_32f_C3C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C1C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C4C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C1C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C3CR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C4CR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_AC4C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C3AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C1MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_32f_C3MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_32f_C4MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_32f_AC4MR: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiCopy_8u_C3P3R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_P3C3R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_C4P4R: function(pSrc:PIpp8u;srcStep:longint;var pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_8u_P4C4R: function(var pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C3P3R: function(pSrc:PIpp16s;srcStep:longint;var pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_P3C3R: function(var pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_C4P4R: function(pSrc:PIpp16s;srcStep:longint;var pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_16s_P4C4R: function(var pSrc:PIpp16s;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C3P3R: function(pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_P3C3R: function(var pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_C4P4R: function(pSrc:PIpp32f;srcStep:longint;var pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiCopy_32f_P4C4R: function(var pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyReplicateBorder
//
//  Purpose:     Copies pixel values between two buffers and adds the border pixels.
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                          2). topBorderWidth or leftBorderWidth is less than zero
//                          3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                          4). dstRoiSize.height < srcRoiSize.height + topBorderWidth
//    ippStsStepErr         srcStep or dstStep is less than or equal to zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image buffer
//    srcStep               size of the source image scan-line in bytes
//    pDst                  pointer to the  destination image buffer
//    dstStep               size of the destination image scan-line in bytes
//    scrRoiSize            size of the source ROI in pixels
//    dstRoiSize            size of the destination ROI in pixels
//    topBorderWidth        width of the top border in pixels
//    leftBorderWidth       width of the left border in pixels
*)

  ippiCopyReplicateBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyReplicateBorder_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyConstBorder
//
//  Purpose:    Copies pixel values between two buffers and adds the border pixels with constant value.
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                          2). topBorderWidth or leftBorderWidth is less than zero
//                          3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                          4). dstRoiSize.height < srcRoiSize.height + topBorderWidth
//    ippStsStepErr         srcStep or dstStep is less than or equal to zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image buffer
//    srcStep               size of the source image scan-line in bytes
//    pDst                  pointer to the  destination image buffer
//    dstStep               size of the destination image scan-line in bytes
//    srcRoiSize            size of the source ROI in pixels
//    dstRoiSize            size of the destination ROI in pixels
//    topBorderWidth        width of the top border in pixels
//    leftBorderWidth       width of the left border in pixels
//    value                 value that is assigned to the elements of the border
*)

  ippiCopyConstBorder_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;value:Ipp8u):IppStatus;stdcall;
  ippiCopyConstBorder_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp8u):IppStatus;stdcall;
  ippiCopyConstBorder_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp8u):IppStatus;stdcall;
  ippiCopyConstBorder_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp8u):IppStatus;stdcall;
  ippiCopyConstBorder_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;value:Ipp16s):IppStatus;stdcall;
  ippiCopyConstBorder_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp16s):IppStatus;stdcall;
  ippiCopyConstBorder_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp16s):IppStatus;stdcall;
  ippiCopyConstBorder_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp16s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp16s):IppStatus;stdcall;
  ippiCopyConstBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;value:Ipp32s):IppStatus;stdcall;
  ippiCopyConstBorder_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp32s):IppStatus;stdcall;
  ippiCopyConstBorder_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp32s):IppStatus;stdcall;
  ippiCopyConstBorder_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint;var value:Ipp32s):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiCopyWrapBorder
//
//  Purpose:    Copies pixel values between two buffers and adds the border pixels.
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         1). srcRoiSize or dstRoiSize has a field with negative or zero value
//                          2). topBorderWidth or leftBorderWidth is less than zero
//                          3). dstRoiSize.width < srcRoiSize.width + leftBorderWidth
//                          4). dstRoiSize.height < srcRoiSize.height + topBorderWidth
//    ippStsStepErr         srcStep or dstStep is less than or equal to zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image buffer
//    srcStep               size of the source image scan-line in bytes
//    pDst                  pointer to the  destination image buffer
//    dstStep               size of the destination image scan-line in bytes
//    srcRoiSize            size of the source ROI in pixels
//    dstRoiSize            size of the destination ROI in pixels
//    topBorderWidth        width of the top border in pixels
//    leftBorderWidth       width of the left border in pixels
*)

  ippiCopyWrapBorder_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;srcRoiSize:IppiSize;pDst:PIpp32s;dstStep:longint;dstRoiSize:IppiSize;topBorderWidth:longint;leftBorderWidth:longint):IppStatus;stdcall;
  ippiCopyWrapBorder_32s_C1IR: function(pSrc:PIpp32s;srcDstStep:longint;srcRoiSize:IppiSize;dstRoiSize:IppiSize;topborderwidth:longint;leftborderwidth:longint):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////
//  Name:       ippiSet
//
//  Purpose:    set elements of the destination image to a constant value
//
//  Return:
//    ippStsNullPtrErr  One of pointers is NULL
//    ippStsSizeErr     The length of the vector is less or equal zero
//    ippStsStepErr     The steps in images are less or equal zero
//    ippStsNoErr       Ok
//
//  Arguments:
//    value             value to set each element of the image to
//    pDst              pointer to the destination image buffer
//    dstStep           step in bytes through the destination image buffer
//    roiSize           size of ROI
//    pMask             pointer to the mask image buffer
//    maskStep          step in bytes through the mask image buffer
*)

  ippiSet_8u_C1R: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_8u_C3CR: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_8u_C4CR: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_8u_C3R: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_8u_C4R: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_8u_AC4R: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_8u_C1MR: function(value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_8u_C3MR: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_8u_C4MR: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_8u_AC4MR: function(var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_16s_C1R: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_16s_C3CR: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_16s_C4CR: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_16s_C3R: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_16s_C4R: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_16s_AC4R: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_16s_C1MR: function(value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_16s_C3MR: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_16s_C4MR: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_16s_AC4MR: function(var value:Ipp16s;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_32f_C1R: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_32f_C3CR: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_32f_C4CR: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_32f_C3R: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_32f_C4R: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_32f_AC4R: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiSet_32f_C1MR: function(value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_32f_C3MR: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_32f_C4MR: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;
  ippiSet_32f_AC4MR: function(var value:Ipp32f;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;pMask:PIpp8u;maskStep:longint):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddRandUniform_Direct_8u_C1IR,  ippiAddRandUniform_Direct_8u_C3IR,
//  Name:       ippiAddRandUniform_Direct_8u_C4IR,  ippiAddRandUniform_Direct_8u_AC4IR,
//  Name:       ippiAddRandUniform_Direct_16s_C1IR, ippiAddRandUniform_Direct_16s_C3IR,
//  Name:       ippiAddRandUniform_Direct_16s_C4IR, ippiAddRandUniform_Direct_16s_AC4IR,
//  Name:       ippiAddRandUniform_Direct_32f_C1IR, ippiAddRandUniform_Direct_32f_C3IR,
//  Name:       ippiAddRandUniform_Direct_32f_C4IR, ippiAddRandUniform_Direct_32f_AC4IR
//
//  Purpose:    Generates pseudo-random samples with uniform distribution and adds them
//              to an image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of an image is less than or equal to zero
//    ippStsStepErr            The step in image is less than or equal to zero
//
//  Arguments:
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step in bytes through the image
//    roiSize                  ROI size
//    low                      The lower bounds of the uniform distributions range
//    high                     The upper bounds of the uniform distributions range
//    pSeed                    Pointer to the seed value for the pseudo-random number
//                             generator
*)

  ippiAddRandUniform_Direct_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;low:Ipp8u;high:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;low:Ipp16s;high:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandUniform_Direct_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;low:Ipp32f;high:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiAddRandGauss_Direct_8u_C1IR,  ippiAddRandGauss_Direct_8u_C3IR,
//              ippiAddRandGauss_Direct_8u_C4IR,  ippiAddRandGauss_Direct_8u_AC4IR
//              ippiAddRandGauss_Direct_16s_C1IR, ippiAddRandGauss_Direct_16s_C3IR,
//              ippiAddRandGauss_Direct_16s_C4IR, ippiAddRandGauss_Direct_16s_AC4IR,
//              ippiAddRandGauss_Direct_32f_C1IR, ippiAddRandGauss_Direct_32f_C3IR,
//              ippiAddRandGauss_Direct_32f_C4IR, ippiAddRandGauss_Direct_32f_AC4IR
//
//  Purpose:    Generates pseudo-random samples with normal distribution and adds them
//              to an image.
//
//  Return:
//    ippStsNoErr              Ok
//    ippStsNullPtrErr         One of the pointers is NULL
//    ippStsSizeErr            The width or height of the image is less than or equal to zero
//    ippStsStepErr            The step value is less than or equal to zero
//
//  Arguments:
//    pSrcDst                  Pointer to the image
//    srcDstStep               Step in bytes through the image
//    roiSize                  ROI size
//    mean                     The mean of the normal distribution
//    stdev                    The standard deviation of the normal distribution
//    pSeed                    Pointer to the seed value for the pseudo-random number
//                             generator
*)

  ippiAddRandGauss_Direct_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;mean:Ipp8u;stdev:Ipp8u;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_16s_C1IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_16s_C3IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_16s_C4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_16s_AC4IR: function(pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize;mean:Ipp16s;stdev:Ipp16s;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;
  ippiAddRandGauss_Direct_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;roiSize:IppiSize;mean:Ipp32f;stdev:Ipp32f;pSeed:PlongWord):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////
//  Name:               ippiImageJaehne
//  Purpose:            functions to create ippi test image (Jaehne's)
//  Returns:
//    ippStsNoErr       indicates no error, an ippi test image is created
//    ippStsNullPtrErr  indicates an error when pDst pointer is NULL
//    ippStsSizeErr     indicates an error when size of roi or DstStep is less than or equal to zero
//  Parameters:
//    pDst              pointer to the destination buffer
//    DstStep           step in bytes through the destination buffer
//    roiSize           size of the destination image roi in pixels
//  Notes:
//                      Dst(x,y,) = A*Sin(0.5*IPP_PI* (x2^2 + y2^2) / roiSize.height),
//                      x variables from 0 to roi.width-1,
//                      y variables from 0 to roi.height-1,
//                      x2 = (x-roi.width+1)/2.0 ,   y2 = (y-roi.height+1)/2.0 .
//                      A is the constant value depends on the image type being created.
*)

  ippiImageJaehne_8u_C1R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8u_C3R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8s_C1R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8s_C3R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16u_C1R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16u_C3R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16s_C1R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16s_C3R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32s_C1R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32s_C3R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32f_C1R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32f_C3R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8u_C4R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8s_C4R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16u_C4R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16s_C4R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32s_C4R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32f_C4R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8u_AC4R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_8s_AC4R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16u_AC4R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_16s_AC4R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32s_AC4R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiImageJaehne_32f_AC4R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////
//  Name:               ippiImageRamp
//  Purpose:            functions to create ippi test image (Ramp)
//  Returns:
//    ippStsNoErr       indicates no error, an ippi test image is created
//    ippStsNullPtrErr  indicates an error when pDst pointer is NULL
//    ippStsSizeErr     indicates an error, if size of roi or DstStep is less than or equal to zero
//  Parameters:
//    pDst              pointer to the destination buffer
//    DstStep           step in bytes through the destination buffer
//    roiSize           size of the destination image roi in pixels
//    offset            offset value
//    slope             slope coefficient
//    axis              specifies the direction of the image intensity ramp,
//                      one of the following:
//                        ippAxsHorizontal   in X-direction,
//                        ippAxsVertical     in Y-direction,
//                        ippAxsBoth         in both X and Y-directions.
//  Notes:              Dst(x,y) = offset + slope * x   (if ramp for X-direction)
//                      Dst(x,y) = offset + slope * y   (if ramp for Y-direction)
//                      Dst(x,y) = offset + slope * x*y (if ramp for X,Y-direction)
*)
  ippiImageRamp_8u_C1R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8u_C3R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8s_C1R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8s_C3R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16u_C1R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16u_C3R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16s_C1R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16s_C3R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32s_C1R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32s_C3R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32f_C1R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32f_C3R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8u_C4R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8s_C4R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16u_C4R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16s_C4R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32s_C4R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32f_C4R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8u_AC4R: function(pDst:PIpp8u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_8s_AC4R: function(pDst:PIpp8s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16u_AC4R: function(pDst:PIpp16u;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_16s_AC4R: function(pDst:PIpp16s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32s_AC4R: function(pDst:PIpp32s;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;
  ippiImageRamp_32f_AC4R: function(pDst:PIpp32f;DstStep:longint;roiSize:IppiSize;offset:single;slope:single;axis:IppiAxis):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiConvert
//
//  Purpose:    Convert pixel values from one bit depth to another
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         The size is less than or equal to zero
//    ippStsStepErr         The srcStep or dstStep has a field with negative or zero value
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of the source image scan-line
//    pDst                  pointer to the  destination image
//    dstStep               size of te destination image scan-line
//    roiSize               size of ROI
//    roundMode             rounding mode, ippRndZero or ippRndNear
*)
  ippiConvert_8u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u8u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u8u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u8u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u16s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s8u_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s8u_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s8u_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s8u_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f8u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f8u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f8u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_16s32f_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s32f_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s32f_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16s32f_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32f16s_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f16s_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f16s_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f16s_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_8s32f_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32f_C3R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32f_AC4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32f_C4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32f8s_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f8s_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f8s_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f8s_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_16u32f_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u32f_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u32f_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_16u32f_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32f16u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f16u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f16u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_32f16u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;roundMode:IppRoundMode):IppStatus;stdcall;
  ippiConvert_8u32s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8u32s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8u_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8u_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8u_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8u_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32s_C1R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32s_C3R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32s_AC4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_8s32s_C4R: function(pSrc:PIpp8s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8s_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiConvert_32s8s_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiConvert_1u8u_C1R
//
//  Purpose:    Convert pixel values from one bit depth to another
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         The size is less than or equal to zero
//    ippStsSizeErr         The srcBitOffset is less than to zero
//    ippStsStepErr         The srcStep or dstStep has a field with negative or zero value
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of the source image scan-line
//    srcBitOffset          offset inside byte
//    pDst                  pointer to the  destination image
//    dstStep               size of te destination image scan-line
//    roiSize               size of ROI
*)

  ippiConvert_1u8u_C1R: function(pSrc:PIpp8u;srcStep:longint;srcBitOffset:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiConvert_8u1u_C1R
//
//  Purpose:    Convert pixel values from one bit depth to another
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         The size is less than or equal to zero
//    ippStsMemAllocErr     if can not allocate memory
//    ippStsSizeErr         The dstBitOffset is less than to zero
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of the source image scan-line
//    pDst                  pointer to the  destination image
//    dstStep               size of te destination image scan-line
//    dstBitOffset          offset inside byte
//    roiSize               size of ROI
//    threshold             threshold level for the Sucki's dithering.
*)

  ippiConvert_8u1u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstBitOffset:longint;roiSize:IppiSize;threshold:Ipp8u):IppStatus;stdcall;

(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiSwapChannels
//
//  Purpose:    Changes the order of channels of the image
//              The function does it for anyone pixel:stdcall;
//                  pDst[0] = pSrc[ dstOrder[0] ]
//                  pDst[1] = pSrc[ dstOrder[1] ]
//                  pDst[2] = pSrc[ dstOrder[2] ]
//
//  Return:
//    ippStsNullPtrErr      One of the pointers is NULL
//    ippStsSizeErr         The roiSize has a field that is less than or equal to zero
//    ippStsStepErr         One of the step values is less than or equal to zero
//    ippStsChannelOrderErr dstOrder is out of the range,
//                          must be: dstOrder[3] = { 0..2, 0..2, 0..2 }
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               step in bytes through the source image
//    pDst                  pointer to the  destination image
//    dstStep               step in bytes through the destination image
//    roiSize               size of ROI
//    dstOrder              the order of channels in the destination image
*)
  ippiSwapChannels_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;
  ippiSwapChannels_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize;var dstOrder:longint):IppStatus;stdcall;


(* ////////////////////////////////////////////////////////////////////////////
//  Name:       ippiScale
//
//  Purpose:
//              dst = a + b * src;
//              a = type_min_dst - b * type_min_src;
//              b = (type_max_dst - type_min_dst) / (type_max_src - type_min_src).
//
//  Return:
//    ippStsNullPtrErr      One of pointers are NULL
//    ippStsSizeErr         The size is less or equal zero
//    ippStsStepErr         The steps in images are less or equal zero
//    ippStsScaleRangeErr   Scale bounds is out of range (vMax - vMin <= 0)
//    ippStsNoErr           Ok
//
//  Arguments:
//    pSrc                  pointer  to the source image
//    srcStep               size of input image scan-line
//    pDst                  pointer to the  destination image
//    dstStep               size of output image scan-line
//    roiSize               size of ROI
//    [vMin...vMax]         range for depth 32f.
//    hint                  utilized kind of code hint:
//                             1). hint == ippAlgHintAccurate
//                                        - accuracy e-8, but slowly;
//                             2). hint == ippAlgHintFast or ippAlgHintNone
//                                        - accuracy e-3, but quickly.
*)
  ippiScale_8u16u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u16s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32s_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32f_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_8u16u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u16s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32s_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32f_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_8u16u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u16s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32s_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32f_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_8u16u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u16s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32s_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiScale_8u32f_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp32f;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_16u8u_C1R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_16s8u_C1R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32s8u_C1R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32f8u_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_16u8u_C3R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_16s8u_C3R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32s8u_C3R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32f8u_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_16u8u_AC4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_16s8u_AC4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32s8u_AC4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32f8u_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;
  ippiScale_16u8u_C4R: function(pSrc:PIpp16u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_16s8u_C4R: function(pSrc:PIpp16s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32s8u_C4R: function(pSrc:PIpp32s;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;hint:IppHintAlgorithm):IppStatus;stdcall;
  ippiScale_32f8u_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;vMin:Ipp32f;vMax:Ipp32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMin
//  Purpose:        computes the minimum of image pixel values
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step through the source image
//    roiSize     Size of the source image ROI.
//    pMin        Pointer to the result (C1)
//    min         Array containing results (C3, AC4, C4)
//  Notes:
*)

  ippiMin_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMin:PIpp8u):IppStatus;stdcall;

  ippiMin_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u):IppStatus;stdcall;

  ippiMin_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u):IppStatus;stdcall;

  ippiMin_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u):IppStatus;stdcall;

  ippiMin_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMin:PIpp16s):IppStatus;stdcall;

  ippiMin_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s):IppStatus;stdcall;

  ippiMin_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s):IppStatus;stdcall;

  ippiMin_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s):IppStatus;stdcall;

  ippiMin_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMin:PIpp32f):IppStatus;stdcall;

  ippiMin_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f):IppStatus;stdcall;

  ippiMin_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f):IppStatus;stdcall;

  ippiMin_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMinIndx
//  Purpose:        computes the minimum of image pixel values and retrieves
//                  the x and y coordinates of pixels with this value
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
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
//  Notes:
*)

  ippiMinIndx_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMin:PIpp8u;pIndexX:Plongint;pIndexY:Plongint):IppStatus;stdcall;

  ippiMinIndx_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMin:PIpp16s;pIndexX:Plongint;pIndexY:Plongint):IppStatus;stdcall;

  ippiMinIndx_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMin:PIpp32f;pIndexX:Plongint;pIndexY:Plongint):IppStatus;stdcall;

  ippiMinIndx_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMinIndx_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMax
//  Purpose:        computes the maximum of image pixel values
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative valueo
//  Parameters:
//    pSrc        Pointer to the source image.
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pMax        Pointer to the result (C1)
//    max         Array containing the results (C3, AC4, C4)
//  Notes:
*)


  ippiMax_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMax:PIpp8u):IppStatus;stdcall;

  ippiMax_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u):IppStatus;stdcall;

  ippiMax_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u):IppStatus;stdcall;

  ippiMax_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u):IppStatus;stdcall;

  ippiMax_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMax:PIpp16s):IppStatus;stdcall;

  ippiMax_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s):IppStatus;stdcall;

  ippiMax_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s):IppStatus;stdcall;

  ippiMax_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s):IppStatus;stdcall;

  ippiMax_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMax:PIpp32f):IppStatus;stdcall;

  ippiMax_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f):IppStatus;stdcall;

  ippiMax_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f):IppStatus;stdcall;

  ippiMax_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMaxIndx
//  Purpose:        computes the maximum of image pixel values and retrieves
//                  the x and y coordinates of pixels with this value
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
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
//  Notes:
*)


  ippiMaxIndx_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMax:PIpp8u;pIndexX:Plongint;pIndexY:Plongint):IppStatus;stdcall;

  ippiMaxIndx_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var max:Ipp8u;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMax:PIpp16s;pIndexX:Plongint;pIndexY:Plongint):IppStatus;stdcall;

  ippiMaxIndx_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var max:Ipp16s;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMax:PIpp32f;pIndexX:Plongint;pIndexY:Plongint):IppStatus;stdcall;

  ippiMaxIndx_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;stdcall;

  ippiMaxIndx_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var max:Ipp32f;var indexX:longint;var indexY:longint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiMinMax
//  Purpose:        computes the minimum and maximum of image pixel value
//  Context:
//  Returns:        IppStatus
//    ippStsNoErr        Ok
//    ippStsNullPtrErr   Any of the pointers is NULL
//    ippStsSizeErr      roiSize has a field with zero or negative value
//  Parameters:
//    pSrc        Pointer to the source image
//    srcStep     Step in bytes through the source image
//    roiSize     Size of the source image ROI.
//    pMin, pMax  Pointers to the results (C1)
//    min, max    Arrays containing the results (C3, AC4, C4)
//  Notes:
*)

  ippiMinMax_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;pMin:PIpp8u;pMax:PIpp8u):IppStatus;stdcall;

  ippiMinMax_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var max:Ipp8u):IppStatus;stdcall;

  ippiMinMax_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var max:Ipp8u):IppStatus;stdcall;

  ippiMinMax_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;roiSize:IppiSize;var min:Ipp8u;var max:Ipp8u):IppStatus;stdcall;

  ippiMinMax_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;pMin:PIpp16s;pMax:PIpp16s):IppStatus;stdcall;

  ippiMinMax_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var max:Ipp16s):IppStatus;stdcall;

  ippiMinMax_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var max:Ipp16s):IppStatus;stdcall;

  ippiMinMax_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;roiSize:IppiSize;var min:Ipp16s;var max:Ipp16s):IppStatus;stdcall;

  ippiMinMax_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;pMin:PIpp32f;pMax:PIpp32f):IppStatus;stdcall;

  ippiMinMax_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var max:Ipp32f):IppStatus;stdcall;

  ippiMinMax_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var max:Ipp32f):IppStatus;stdcall;

  ippiMinMax_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;roiSize:IppiSize;var min:Ipp32f;var max:Ipp32f):IppStatus;stdcall;

(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                      Logical functions and Shift functions
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(*
//  Names:              ippiAnd, ippiOr, ippiXor, ippiAndC, ippiOrC, ippiXorC, ippiNot,
//                      ippiLShiftC, ippiRShiftC
//
//  Purpose:            performs logical operations (AndC/OrC/XorC works with constant) and
//                      shifts operations with constant (LShiftC, RShiftC)
//  Parameters:
//   value              1) constant to be ANDed/ORed/XORed with each pixel of the image (and, or, xor);
//                      2) position`s number which pixels of the image to be SHIFTed on (shift)
//   pSrc               pointer to the source image data
//   srcStep            step through the source image
//   pSrcDst            pointer to the source/destination image data (for in-place case)
//   srcDstStep         step through the source/destination image (for in-place case)
//   pSrc1              pointer to first source image data
//   src1Step           step through first source image
//   pSrc2              pointer to second source image data
//   src2Step           step through second source image
//   pDst               pointer to the destination image data
//   dstStep            step in destination image
//   roiSize            size of the ROI
//
//  Returns:
//   ippStsNullPtrErr   any of the pointers is NULL
//   ippStsStepErr      any of the step values is less than or equal to zero
//   ippStsSizeErr      width or height of images is less than or equal to zero
//   ippStsShiftErr     shift`s value is less than zero
//   ippStsNoErr        otherwise
*)

  ippiAnd_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_C3IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_C4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAnd_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_C1IR: function(value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_C3IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_C4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiAndC_32s_AC4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiOr_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_C3IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_C4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOr_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_C1IR: function(value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_C3IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_C4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiOrC_32s_AC4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiXor_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_C1IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_C3IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_C4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_8u_AC4IR: function(pSrc:PIpp8u;srcStep:longint;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_C1IR: function(value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_C3IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_C4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_8u_AC4IR: function(var value:Ipp8u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_C1R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_C3R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_C4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_AC4R: function(pSrc1:PIpp16u;src1Step:longint;pSrc2:PIpp16u;src2Step:longint;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_C1IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_C3IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_C4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_16u_AC4IR: function(pSrc:PIpp16u;srcStep:longint;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp16u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_C1IR: function(value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_C3IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_C4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_16u_AC4IR: function(var value:Ipp16u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_C1R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_C3R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_C4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_AC4R: function(pSrc1:PIpp32s;src1Step:longint;pSrc2:PIpp32s;src2Step:longint;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_C1IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_C3IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_C4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXor_32s_AC4IR: function(pSrc:PIpp32s;srcStep:longint;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32s;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_C1IR: function(value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_C3IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_C4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiXorC_32s_AC4IR: function(var value:Ipp32s;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiNot_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiNot_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiLShiftC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_C1IR: function(value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_8u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_C1IR: function(value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_16u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_C1IR: function(value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiLShiftC_32s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;

  ippiRShiftC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp32u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_C1IR: function(value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp8u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_C1R: function(pSrc:PIpp8s;srcStep:longint;value:Ipp32u;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_C3R: function(pSrc:PIpp8s;srcStep:longint;var value:Ipp32u;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_C4R: function(pSrc:PIpp8s;srcStep:longint;var value:Ipp32u;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_AC4R: function(pSrc:PIpp8s;srcStep:longint;var value:Ipp32u;pDst:PIpp8s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_C1IR: function(value:Ipp32u;pSrcDst:PIpp8s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp8s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp8s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_8s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp8s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_C1R: function(pSrc:PIpp16u;srcStep:longint;value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_C3R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_C4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_AC4R: function(pSrc:PIpp16u;srcStep:longint;var value:Ipp32u;pDst:PIpp16u;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_C1IR: function(value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_C3IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_C4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16u_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp16u;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp32u;pDst:PIpp16s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_C1IR: function(value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_16s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp16s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_C1R: function(pSrc:PIpp32s;srcStep:longint;value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_C3R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_C4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_AC4R: function(pSrc:PIpp32s;srcStep:longint;var value:Ipp32u;pDst:PIpp32s;dstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_C1IR: function(value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_C3IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_C4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;
  ippiRShiftC_32s_AC4IR: function(var value:Ipp32u;pSrcDst:PIpp32s;srcDstStep:longint;roiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                                 Compare functions
///////////////////////////////////////////////////////////////////////////////////////////////// *)
(* /////////////////////////////////////////////////////////////////////////////
//  Name:           ippiCompare
//
//  Purpose:        comparing of two arrays or array and scalar for
//                  <, <=, ==, >, >= or for equality with accuracy epsilon
//  Context:
//
//  Returns:        IppStatus
//    ippStsNoErr        Ok;
//    ippStsNullPtrErr   Some of pointers to input or output data are NULL;
//    ippStsSizeErr      The width or height of images is less or equal zero or
//                       horizontal step of some arrays in bytes is less then
//                       roiSize.width;
//    ippStsEpsValErr    accuracy to compare two floats for equality is negative.
//
//  Parameters:
//    pSrc1         Pointer to first source image data;
//    src1Step      Step in first source image;
//    pSrc2         Pointer to second source image data;
//    src2Step      Step in second source image;
//    pDst          Pointer to destination image data;
//    dstStep       Step in destination image;
//    roiSize       Size of comparing region;
//    ippCmpOp         Relation, that is tested: <, <=, ==, >=, >,
//    value         scalar or scalar[3] to compare instead of second array
//    eps           accuracy to compare two floats for equality in
//                  ippiCompareEqualEps... functions
//
//  Notes:
*)

  ippiCompare_8u_C1R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_8u_C3R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_8u_AC4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_8u_C4R: function(pSrc1:PIpp8u;src1Step:longint;pSrc2:PIpp8u;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;

  ippiCompareC_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;var value:Ipp8u;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;

  ippiCompare_16s_C1R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_16s_C3R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_16s_AC4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_16s_C4R: function(pSrc1:PIpp16s;src1Step:longint;pSrc2:PIpp16s;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;

  ippiCompareC_16s_C1R: function(pSrc:PIpp16s;srcStep:longint;value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_16s_C3R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_16s_AC4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_16s_C4R: function(pSrc:PIpp16s;srcStep:longint;var value:Ipp16s;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;

  ippiCompare_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompare_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;

  ippiCompareC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;
  ippiCompareC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;ippCmpOp:IppCmpOp):IppStatus;stdcall;

  ippiCompareEqualEps_32f_C1R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;
  ippiCompareEqualEps_32f_C3R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;
  ippiCompareEqualEps_32f_AC4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;
  ippiCompareEqualEps_32f_C4R: function(pSrc1:PIpp32f;src1Step:longint;pSrc2:PIpp32f;src2Step:longint;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;

  ippiCompareEqualEpsC_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;
  ippiCompareEqualEpsC_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;
  ippiCompareEqualEpsC_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;
  ippiCompareEqualEpsC_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;var value:Ipp32f;pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;eps:Ipp32f):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////////////////////////
//                                 Morphological functions
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
//  Purpose:   Performs not inplace Morphological Operation ERODE (DILATE)
//             using 3x3 solid mask
//
//  Returns:
//    ippStsNullPtrErr,   if pSrc == NULL or
//                           pDst == NULL
//    ippStsStepErr,      if srcStep <= 0 or
//                           dstStep <= 0
//    ippStsSizeErr,      if roiSize.width  <1 or
//                           roiSize.height <1
//    ippStsStrideErr,    if (2+roiSize.width)*nChannels*sizeof(item) > srcStep or
//                           (2+roiSize.width)*nChannels*sizeof(item) > dstStep
//    ippStsNoErr,        if no errors
//
//  Parameters:
//    pSrc          pointer to the source image ROI
//    srcStep       source image scan-line size (bytes)
//    pDst          pointer to the target image ROI
//    dstStep       target image scan-line size (bytes)
//    dstRoiSize    size of ROI
*)
  ippiErode3x3_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;

  ippiDilate3x3_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;

  ippiErode3x3_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;

  ippiDilate3x3_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiErode3x3_8u_C1IR()    ippiDilate3x3_8u_C1IR()
//             ippiErode3x3_8u_C3IR()    ippiDilate3x3_8u_C3IR()
//             ippiErode3x3_8u_AC4IR()   ippiDilate3x3_8u_AC4IR()
//             ippiErode3x3_8u_C4IR()    ippiDilate3x3_8u_C4IR()
//
//             ippiErode3x3_32f_C1IR()   ippiDilate3x3_32f_C1IR()
//             ippiErode3x3_32f_C3IR()   ippiDilate3x3_32f_C3IR()
//             ippiErode3x3_32f_AC4IR()  ippiDilate3x3_32f_AC4IR()
//             ippiErode3x3_32f_C4IR()   ippiDilate3x3_32f_C4IR()
//
//  Purpose:   Performs inplace Morphological Operation EIRODE (DILATE)
//             using 3x3 solid mask
//
//  IReturns:
//    ippStsNullPtrErr,   if pSrcDst == NULL
//    ippStsStepErr,      if srcDstStep <= 0
//    ippStsSizeErr,      if dstRoiSize.width  <1 or
//                           dstRoiSize.height <1
//    ippStsStrideErr,    if (2+dstRoiSize.width)*nChannels*sizeof(item) > srcDstStep
//    ippStsMemAllocErr,  if can not allocate memory
//    ippStsNoErr,        if no errors
//
//  Parameters:
//    pSrcDst     pointer to the source image IROI
//    srcDstStep  source image scan-line size (bytes)
//    dstRoiSize  size of ROI
*)
  ippiErode3x3_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;

  ippiDilate3x3_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_8u_C4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;

  ippiErode3x3_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiErode3x3_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;

  ippiDilate3x3_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;
  ippiDilate3x3_32f_C4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiErode_8u_C1R()   ippiDilate_8u_C1R()
//             ippiErode_8u_C3R()   ippiDilate_8u_C3R()
//             ippiErode_8u_C4R()   ippiDilate_8u_C4R()
//             ippiErode_8u_AC4R()  ippiDilate_8u_AC4R()
//
//             ippiErode_32f_C1R()  ippiDilate_32f_C1R()
//             ippiErode_32f_C3R()  ippiDilate_32f_C3R()
//             ippiErode_32f_C4R()  ippiDilate_32f_C4R()
//             ippiErode_32f_AC4R() ippiDilate_32f_AC4R()
//
//  Purpose:   Performs not inplace Morphological Operation ERODE (DILATE)
//             using arbitrary mask
//
//  Returns:
//    ippStsNullPtrErr,   if pSrc == NULL or
//                           pDst == NULL or
//                           pMask== NULL
//    ippStsStepErr,      if srcStep <= 0 or
//                           dstStep <= 0
//    ippStsSizeErr,      if dstRoiSize.width  <1 or
//                           dstRoiSize.height <1
//    ippStsSizeErr,      if maskSize.width  <1 or
//                           maskSize.height <1
//    ippStsAnchorErr,    if (0>anchor.x)||(anchor.x>=maskSize.width) or
//                           (0>anchor.y)||(anchor.y>=maskSize.height)
//    ippStsStrideErr,    if (maskSize.width-1+dstRoiSize.width)*nChannels*sizeof(item)) > srcStep or
//                           (maskSize.width-1+dstRoiSize.width)*nChannels*sizeof(item)) > dstStep
//    ippStsMemAllocErr,  if can not allocate memory
//    ippStsZeroMaskValuesErr, if all values of the mask are zero
//    ippStsNoErr,        if no errors
//
//  Parameters:
//    pSrc          pointer to the source image ROI
//    srcStep       source image scan-line size (bytes)
//    pDst          pointer to the target image ROI
//    dstStep       target image scan-line size (bytes)
//    dstRoiSize    size of ROI
//    pMask         pointer to the mask
//    maskSize      size of mask
//    anchor        position of the anchor
*)
  ippiErode_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiDilate_8u_C1R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_8u_C3R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_8u_C4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_8u_AC4R: function(pSrc:PIpp8u;srcStep:longint;pDst:PIpp8u;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiErode_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiDilate_32f_C1R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_32f_C3R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_32f_C4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_32f_AC4R: function(pSrc:PIpp32f;srcStep:longint;pDst:PIpp32f;dstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Name:      ippiErode_8u_C1IR()   ippiDilate_8u_C1IR()
//             ippiErode_8u_C3IR()   ippiDilate_8u_C3IR()
//             ippiErode_8u_AC4IR()  ippiDilate_8u_AC4IR()
//
//             ippiErode_32f_C1IR()  ippiDilate_32f_C1IR()
//             ippiErode_32f_C3IR()  ippiDilate_32f_C3IR()
//             ippiErode_32f_AC4IR() ippiDilate_32f_AC4IR()
//
//  Purpose:   Performs inplace Morphological Operation ERODE (DILATE)
//             using arbitrary mask
//
//  Returns:
//    ippstsNullPtrErr,   if pSrcDst == NULL or
//                           pMask== NULL
//    ippStsStepErr,      if srcDstStep <= 0
//    ippStsSizeErr,      if dstRoiSize.width  <1 or
//                           dstRoiSize.height <1
//    ippStsSizeErr,      if maskSize.width  <1 or
//                           maskSize.height <1
//    ippStsAnchorErr,    if (0>anchor.x)||(anchor.x>=maskSize.width) or
//                           (0>anchor.y)||(anchor.y>=maskSize.height)
//    ippStsStrideErr,    if (maskSize.width-1+dstRoiSize.width)*nChannels*sizeof(item)) > srcDstStep
//    ippStsMemAllocErr,  if can not allocate memory
//    ippStsZeroMaskValuesErr, if all values of the mask are zero
//    ippStsNoErr,        if no errors
//
//  Parameters:
//    pSrcDst       pointer to the source image ROI
//    srcDstStep    source image scan-line size (bytes)
//    dstRoiSize    size of ROI
//    pMask         pointer to the mask
//    maskSize      size of mask
//    anchor        position of the anchor
*)
  ippiErode_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiDilate_8u_C1IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_8u_C3IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_8u_AC4IR: function(pSrcDst:PIpp8u;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiErode_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiErode_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;

  ippiDilate_32f_C1IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_32f_C3IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;
  ippiDilate_32f_AC4IR: function(pSrcDst:PIpp32f;srcDstStep:longint;dstRoiSize:IppiSize;pMask:PIpp8u;maskSize:IppiSize;anchor:IppiPoint):IppStatus;stdcall;



(* ///////////////////////////////////////////////////////////////////////////
//  Name:
//    ippiZigzagInv8x8_16s_C1
//    ippiZigzagFwd8x8_16s_C1
//
//  Purpose:
//    reorder natural to zigzag 8x8 block (forward funnction) and
//    reorder zigzag to natural 8x8 block (inversion function)stdcall;
//
//  Parameter:
//    pSrc - pointer to source block
//    pDst - pointer to destination block
//
//  Returns:
//    IppStatus
//
*)

  ippiZigzagInv8x8_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;stdcall;
  ippiZigzagFwd8x8_16s_C1: function(pSrc:PIpp16s;pDst:PIpp16s):IppStatus;stdcall;


(* /////////////////////////////////////////////////////////////////////////////
//  Names:      ippiDrawText_8u_C3R
//
//  Purpose: it is a stub for backward compatibility with early versions ippIP
//
//  Return:
//    ippStsNoOperation
//
//  Arguments:
//    pDst                     The pointer to image
//    dstStep                  The step in image
//    roiSize                  ROI size
//    startText                Bottom left point of text rect
//    hight                    Hight of text
//    color                    Color of text
//
//  Notes: This function performs no operation returning correspondent status;stdcall;
//         it provides the compatibility with earlier version of Intel IPP.
*)

  ippiDrawText_8u_C3R: function(pDst:PIpp8u;dstStep:longint;roiSize:IppiSize;startText:IppiPoint;text:Pchar;hight:longint;var color:Ipp8u):IppStatus;stdcall;


(* ////////////////////////// End of file "ippi.h" ////////////////////////// *)

// Ajouts lié aux versions 2010-2011 de IPPI

  ippiResizeSqrPixel_32f_C1R: function( pSrc: pointer; srcSize:IppiSize; srcStep: integer; srcROI:IppiRect;
                                        pDst: pointer; dstStep: integer; dstROI: IppiRect;
                                        xFactor, yFactor, xShift, yShift:double; interpolation: integer; pBuffer: pointer): IppStatus;stdcall;
  ippiResizeSqrPixel_64f_C1R: function( pSrc: pointer; srcSize:IppiSize; srcStep: integer; srcROI:IppiRect;
                                        pDst: pointer; dstStep: integer; dstROI: IppiRect;
                                        xFactor, yFactor, xShift, yShift:double; interpolation: integer; pBuffer: pointer): IppStatus;stdcall;

  ippiResizeGetBufSize: function (srcROI,dstROI: IppiRect; nChannel , interpolation:integer; var Size:integer):IPPstatus;stdCall;
  ippiResizeGetBufSize_64f: function (srcROI,dstROI: IppiRect; nChannel, interpolation:integer; var Size:integer):IPPstatus;stdCall;



IMPLEMENTATION
uses windows,math,util1,ncdef2;

var
  hh:integer;


function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  {if result=nil then messageCentral(st+'=nil');}

end;


{ On coupe en deux init car trop de chaines de caractères }

procedure init1;
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
  ippiMalloc_8u_P3:=getProc(hh,'ippiMalloc_8u_P3');
  ippiMalloc_16u_P3:=getProc(hh,'ippiMalloc_16u_P3');
  ippiMalloc_16s_P3:=getProc(hh,'ippiMalloc_16s_P3');
  ippiMalloc_32s_P3:=getProc(hh,'ippiMalloc_32s_P3');
  ippiMalloc_32f_P3:=getProc(hh,'ippiMalloc_32f_P3');
  ippiMalloc_32sc_P3:=getProc(hh,'ippiMalloc_32sc_P3');
  ippiMalloc_32fc_P3:=getProc(hh,'ippiMalloc_32fc_P3');
  ippiFree:=getProc(hh,'ippiFree');
  ippiAdd_8u_C1RSfs:=getProc(hh,'ippiAdd_8u_C1RSfs');
  ippiAdd_8u_C3RSfs:=getProc(hh,'ippiAdd_8u_C3RSfs');
  ippiAdd_8u_C4RSfs:=getProc(hh,'ippiAdd_8u_C4RSfs');
  ippiAdd_8u_AC4RSfs:=getProc(hh,'ippiAdd_8u_AC4RSfs');
  ippiAdd_16s_C1RSfs:=getProc(hh,'ippiAdd_16s_C1RSfs');
  ippiAdd_16s_C3RSfs:=getProc(hh,'ippiAdd_16s_C3RSfs');
  ippiAdd_16s_C4RSfs:=getProc(hh,'ippiAdd_16s_C4RSfs');
  ippiAdd_16s_AC4RSfs:=getProc(hh,'ippiAdd_16s_AC4RSfs');
  ippiSub_8u_C1RSfs:=getProc(hh,'ippiSub_8u_C1RSfs');
  ippiSub_8u_C3RSfs:=getProc(hh,'ippiSub_8u_C3RSfs');
  ippiSub_8u_C4RSfs:=getProc(hh,'ippiSub_8u_C4RSfs');
  ippiSub_8u_AC4RSfs:=getProc(hh,'ippiSub_8u_AC4RSfs');
  ippiSub_16s_C1RSfs:=getProc(hh,'ippiSub_16s_C1RSfs');
  ippiSub_16s_C3RSfs:=getProc(hh,'ippiSub_16s_C3RSfs');
  ippiSub_16s_C4RSfs:=getProc(hh,'ippiSub_16s_C4RSfs');
  ippiSub_16s_AC4RSfs:=getProc(hh,'ippiSub_16s_AC4RSfs');
  ippiMul_8u_C1RSfs:=getProc(hh,'ippiMul_8u_C1RSfs');
  ippiMul_8u_C3RSfs:=getProc(hh,'ippiMul_8u_C3RSfs');
  ippiMul_8u_C4RSfs:=getProc(hh,'ippiMul_8u_C4RSfs');
  ippiMul_8u_AC4RSfs:=getProc(hh,'ippiMul_8u_AC4RSfs');
  ippiMul_16s_C1RSfs:=getProc(hh,'ippiMul_16s_C1RSfs');
  ippiMul_16s_C3RSfs:=getProc(hh,'ippiMul_16s_C3RSfs');
  ippiMul_16s_C4RSfs:=getProc(hh,'ippiMul_16s_C4RSfs');
  ippiMul_16s_AC4RSfs:=getProc(hh,'ippiMul_16s_AC4RSfs');
  ippiAddC_8u_C1IRSfs:=getProc(hh,'ippiAddC_8u_C1IRSfs');
  ippiAddC_8u_C3IRSfs:=getProc(hh,'ippiAddC_8u_C3IRSfs');
  ippiAddC_8u_C4IRSfs:=getProc(hh,'ippiAddC_8u_C4IRSfs');
  ippiAddC_8u_AC4IRSfs:=getProc(hh,'ippiAddC_8u_AC4IRSfs');
  ippiAddC_16s_C1IRSfs:=getProc(hh,'ippiAddC_16s_C1IRSfs');
  ippiAddC_16s_C3IRSfs:=getProc(hh,'ippiAddC_16s_C3IRSfs');
  ippiAddC_16s_C4IRSfs:=getProc(hh,'ippiAddC_16s_C4IRSfs');
  ippiAddC_16s_AC4IRSfs:=getProc(hh,'ippiAddC_16s_AC4IRSfs');
  ippiSubC_8u_C1IRSfs:=getProc(hh,'ippiSubC_8u_C1IRSfs');
  ippiSubC_8u_C3IRSfs:=getProc(hh,'ippiSubC_8u_C3IRSfs');
  ippiSubC_8u_C4IRSfs:=getProc(hh,'ippiSubC_8u_C4IRSfs');
  ippiSubC_8u_AC4IRSfs:=getProc(hh,'ippiSubC_8u_AC4IRSfs');
  ippiSubC_16s_C1IRSfs:=getProc(hh,'ippiSubC_16s_C1IRSfs');
  ippiSubC_16s_C3IRSfs:=getProc(hh,'ippiSubC_16s_C3IRSfs');
  ippiSubC_16s_C4IRSfs:=getProc(hh,'ippiSubC_16s_C4IRSfs');
  ippiSubC_16s_AC4IRSfs:=getProc(hh,'ippiSubC_16s_AC4IRSfs');
  ippiMulC_8u_C1IRSfs:=getProc(hh,'ippiMulC_8u_C1IRSfs');
  ippiMulC_8u_C3IRSfs:=getProc(hh,'ippiMulC_8u_C3IRSfs');
  ippiMulC_8u_C4IRSfs:=getProc(hh,'ippiMulC_8u_C4IRSfs');
  ippiMulC_8u_AC4IRSfs:=getProc(hh,'ippiMulC_8u_AC4IRSfs');
  ippiMulC_16s_C1IRSfs:=getProc(hh,'ippiMulC_16s_C1IRSfs');
  ippiMulC_16s_C3IRSfs:=getProc(hh,'ippiMulC_16s_C3IRSfs');
  ippiMulC_16s_C4IRSfs:=getProc(hh,'ippiMulC_16s_C4IRSfs');
  ippiMulC_16s_AC4IRSfs:=getProc(hh,'ippiMulC_16s_AC4IRSfs');
  ippiAddC_8u_C1RSfs:=getProc(hh,'ippiAddC_8u_C1RSfs');
  ippiAddC_8u_C3RSfs:=getProc(hh,'ippiAddC_8u_C3RSfs');
  ippiAddC_8u_C4RSfs:=getProc(hh,'ippiAddC_8u_C4RSfs');
  ippiAddC_8u_AC4RSfs:=getProc(hh,'ippiAddC_8u_AC4RSfs');
  ippiAddC_16s_C1RSfs:=getProc(hh,'ippiAddC_16s_C1RSfs');
  ippiAddC_16s_C3RSfs:=getProc(hh,'ippiAddC_16s_C3RSfs');
  ippiAddC_16s_C4RSfs:=getProc(hh,'ippiAddC_16s_C4RSfs');
  ippiAddC_16s_AC4RSfs:=getProc(hh,'ippiAddC_16s_AC4RSfs');
  ippiSubC_8u_C1RSfs:=getProc(hh,'ippiSubC_8u_C1RSfs');
  ippiSubC_8u_C3RSfs:=getProc(hh,'ippiSubC_8u_C3RSfs');
  ippiSubC_8u_C4RSfs:=getProc(hh,'ippiSubC_8u_C4RSfs');
  ippiSubC_8u_AC4RSfs:=getProc(hh,'ippiSubC_8u_AC4RSfs');
  ippiSubC_16s_C1RSfs:=getProc(hh,'ippiSubC_16s_C1RSfs');
  ippiSubC_16s_C3RSfs:=getProc(hh,'ippiSubC_16s_C3RSfs');
  ippiSubC_16s_C4RSfs:=getProc(hh,'ippiSubC_16s_C4RSfs');
  ippiSubC_16s_AC4RSfs:=getProc(hh,'ippiSubC_16s_AC4RSfs');
  ippiMulC_8u_C1RSfs:=getProc(hh,'ippiMulC_8u_C1RSfs');
  ippiMulC_8u_C3RSfs:=getProc(hh,'ippiMulC_8u_C3RSfs');
  ippiMulC_8u_C4RSfs:=getProc(hh,'ippiMulC_8u_C4RSfs');
  ippiMulC_8u_AC4RSfs:=getProc(hh,'ippiMulC_8u_AC4RSfs');
  ippiMulC_16s_C1RSfs:=getProc(hh,'ippiMulC_16s_C1RSfs');
  ippiMulC_16s_C3RSfs:=getProc(hh,'ippiMulC_16s_C3RSfs');
  ippiMulC_16s_C4RSfs:=getProc(hh,'ippiMulC_16s_C4RSfs');
  ippiMulC_16s_AC4RSfs:=getProc(hh,'ippiMulC_16s_AC4RSfs');
  ippiAdd_8u_C1IRSfs:=getProc(hh,'ippiAdd_8u_C1IRSfs');
  ippiAdd_8u_C3IRSfs:=getProc(hh,'ippiAdd_8u_C3IRSfs');
  ippiAdd_8u_C4IRSfs:=getProc(hh,'ippiAdd_8u_C4IRSfs');
  ippiAdd_8u_AC4IRSfs:=getProc(hh,'ippiAdd_8u_AC4IRSfs');
  ippiAdd_16s_C1IRSfs:=getProc(hh,'ippiAdd_16s_C1IRSfs');
  ippiAdd_16s_C3IRSfs:=getProc(hh,'ippiAdd_16s_C3IRSfs');
  ippiAdd_16s_C4IRSfs:=getProc(hh,'ippiAdd_16s_C4IRSfs');
  ippiAdd_16s_AC4IRSfs:=getProc(hh,'ippiAdd_16s_AC4IRSfs');
  ippiSub_8u_C1IRSfs:=getProc(hh,'ippiSub_8u_C1IRSfs');
  ippiSub_8u_C3IRSfs:=getProc(hh,'ippiSub_8u_C3IRSfs');
  ippiSub_8u_C4IRSfs:=getProc(hh,'ippiSub_8u_C4IRSfs');
  ippiSub_8u_AC4IRSfs:=getProc(hh,'ippiSub_8u_AC4IRSfs');
  ippiSub_16s_C1IRSfs:=getProc(hh,'ippiSub_16s_C1IRSfs');
  ippiSub_16s_C3IRSfs:=getProc(hh,'ippiSub_16s_C3IRSfs');
  ippiSub_16s_C4IRSfs:=getProc(hh,'ippiSub_16s_C4IRSfs');
  ippiSub_16s_AC4IRSfs:=getProc(hh,'ippiSub_16s_AC4IRSfs');
  ippiMul_8u_C1IRSfs:=getProc(hh,'ippiMul_8u_C1IRSfs');
  ippiMul_8u_C3IRSfs:=getProc(hh,'ippiMul_8u_C3IRSfs');
  ippiMul_8u_C4IRSfs:=getProc(hh,'ippiMul_8u_C4IRSfs');
  ippiMul_8u_AC4IRSfs:=getProc(hh,'ippiMul_8u_AC4IRSfs');
  ippiMul_16s_C1IRSfs:=getProc(hh,'ippiMul_16s_C1IRSfs');
  ippiMul_16s_C3IRSfs:=getProc(hh,'ippiMul_16s_C3IRSfs');
  ippiMul_16s_C4IRSfs:=getProc(hh,'ippiMul_16s_C4IRSfs');
  ippiMul_16s_AC4IRSfs:=getProc(hh,'ippiMul_16s_AC4IRSfs');
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
  ippiComplement_32s_C1IR:=getProc(hh,'ippiComplement_32s_C1IR');
  ippiDiv_32f_C1R:=getProc(hh,'ippiDiv_32f_C1R');
  ippiDiv_32f_C3R:=getProc(hh,'ippiDiv_32f_C3R');
  ippiDiv_32f_C4R:=getProc(hh,'ippiDiv_32f_C4R');
  ippiDiv_32f_AC4R:=getProc(hh,'ippiDiv_32f_AC4R');
  ippiDiv_16s_C1RSfs:=getProc(hh,'ippiDiv_16s_C1RSfs');
  ippiDiv_16s_C3RSfs:=getProc(hh,'ippiDiv_16s_C3RSfs');
  ippiDiv_8u_C1RSfs:=getProc(hh,'ippiDiv_8u_C1RSfs');
  ippiDiv_8u_C3RSfs:=getProc(hh,'ippiDiv_8u_C3RSfs');
  ippiDivC_32f_C1R:=getProc(hh,'ippiDivC_32f_C1R');
  ippiDivC_32f_C3R:=getProc(hh,'ippiDivC_32f_C3R');
  ippiDivC_16s_C1RSfs:=getProc(hh,'ippiDivC_16s_C1RSfs');
  ippiDivC_16s_C3RSfs:=getProc(hh,'ippiDivC_16s_C3RSfs');
  ippiDivC_8u_C1RSfs:=getProc(hh,'ippiDivC_8u_C1RSfs');
  ippiDivC_8u_C3RSfs:=getProc(hh,'ippiDivC_8u_C3RSfs');
  ippiDiv_32f_C1IR:=getProc(hh,'ippiDiv_32f_C1IR');
  ippiDiv_32f_C3IR:=getProc(hh,'ippiDiv_32f_C3IR');
  ippiDiv_32f_C4IR:=getProc(hh,'ippiDiv_32f_C4IR');
  ippiDiv_32f_AC4IR:=getProc(hh,'ippiDiv_32f_AC4IR');
  ippiDiv_16s_C1IRSfs:=getProc(hh,'ippiDiv_16s_C1IRSfs');
  ippiDiv_16s_C3IRSfs:=getProc(hh,'ippiDiv_16s_C3IRSfs');
  ippiDiv_8u_C1IRSfs:=getProc(hh,'ippiDiv_8u_C1IRSfs');
  ippiDiv_8u_C3IRSfs:=getProc(hh,'ippiDiv_8u_C3IRSfs');
  ippiDivC_32f_C1IR:=getProc(hh,'ippiDivC_32f_C1IR');
  ippiDivC_32f_C3IR:=getProc(hh,'ippiDivC_32f_C3IR');
  ippiDivC_16s_C1IRSfs:=getProc(hh,'ippiDivC_16s_C1IRSfs');
  ippiDivC_16s_C3IRSfs:=getProc(hh,'ippiDivC_16s_C3IRSfs');
  ippiDivC_8u_C1IRSfs:=getProc(hh,'ippiDivC_8u_C1IRSfs');
  ippiDivC_8u_C3IRSfs:=getProc(hh,'ippiDivC_8u_C3IRSfs');
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
  ippiLn_8u_C1IRSfs:=getProc(hh,'ippiLn_8u_C1IRSfs');
  ippiLn_8u_C3IRSfs:=getProc(hh,'ippiLn_8u_C3IRSfs');
  ippiLn_8u_C1RSfs:=getProc(hh,'ippiLn_8u_C1RSfs');
  ippiLn_8u_C3RSfs:=getProc(hh,'ippiLn_8u_C3RSfs');
  ippiExp_32f_C1IR:=getProc(hh,'ippiExp_32f_C1IR');
  ippiExp_32f_C3IR:=getProc(hh,'ippiExp_32f_C3IR');
  ippiExp_32f_C1R:=getProc(hh,'ippiExp_32f_C1R');
  ippiExp_32f_C3R:=getProc(hh,'ippiExp_32f_C3R');
  ippiExp_16s_C1IRSfs:=getProc(hh,'ippiExp_16s_C1IRSfs');
  ippiExp_16s_C3IRSfs:=getProc(hh,'ippiExp_16s_C3IRSfs');
  ippiExp_16s_C1RSfs:=getProc(hh,'ippiExp_16s_C1RSfs');
  ippiExp_16s_C3RSfs:=getProc(hh,'ippiExp_16s_C3RSfs');
  ippiExp_8u_C1IRSfs:=getProc(hh,'ippiExp_8u_C1IRSfs');
  ippiExp_8u_C3IRSfs:=getProc(hh,'ippiExp_8u_C3IRSfs');
  ippiExp_8u_C1RSfs:=getProc(hh,'ippiExp_8u_C1RSfs');
  ippiExp_8u_C3RSfs:=getProc(hh,'ippiExp_8u_C3RSfs');
  ippiAddC_32fc_C1R:=getProc(hh,'ippiAddC_32fc_C1R');
  ippiAddC_32fc_C3R:=getProc(hh,'ippiAddC_32fc_C3R');
  ippiAddC_32fc_AC4R:=getProc(hh,'ippiAddC_32fc_AC4R');
  ippiSubC_32fc_C1R:=getProc(hh,'ippiSubC_32fc_C1R');
  ippiSubC_32fc_C3R:=getProc(hh,'ippiSubC_32fc_C3R');
  ippiSubC_32fc_AC4R:=getProc(hh,'ippiSubC_32fc_AC4R');
  ippiMulC_32fc_C1R:=getProc(hh,'ippiMulC_32fc_C1R');
  ippiMulC_32fc_C3R:=getProc(hh,'ippiMulC_32fc_C3R');
  ippiMulC_32fc_AC4R:=getProc(hh,'ippiMulC_32fc_AC4R');
  ippiDivC_32fc_C1R:=getProc(hh,'ippiDivC_32fc_C1R');
  ippiDivC_32fc_C3R:=getProc(hh,'ippiDivC_32fc_C3R');
  ippiDivC_32fc_AC4R:=getProc(hh,'ippiDivC_32fc_AC4R');
  ippiAddC_32fc_C1IR:=getProc(hh,'ippiAddC_32fc_C1IR');
  ippiAddC_32fc_C3IR:=getProc(hh,'ippiAddC_32fc_C3IR');
  ippiAddC_32fc_AC4IR:=getProc(hh,'ippiAddC_32fc_AC4IR');
  ippiSubC_32fc_C1IR:=getProc(hh,'ippiSubC_32fc_C1IR');
  ippiSubC_32fc_C3IR:=getProc(hh,'ippiSubC_32fc_C3IR');
  ippiSubC_32fc_AC4IR:=getProc(hh,'ippiSubC_32fc_AC4IR');
  ippiMulC_32fc_C1IR:=getProc(hh,'ippiMulC_32fc_C1IR');
  ippiMulC_32fc_C3IR:=getProc(hh,'ippiMulC_32fc_C3IR');
  ippiMulC_32fc_AC4IR:=getProc(hh,'ippiMulC_32fc_AC4IR');
  ippiDivC_32fc_C1IR:=getProc(hh,'ippiDivC_32fc_C1IR');
  ippiDivC_32fc_C3IR:=getProc(hh,'ippiDivC_32fc_C3IR');
  ippiDivC_32fc_AC4IR:=getProc(hh,'ippiDivC_32fc_AC4IR');
  ippiAdd_32fc_C1IR:=getProc(hh,'ippiAdd_32fc_C1IR');
  ippiAdd_32fc_C3IR:=getProc(hh,'ippiAdd_32fc_C3IR');
  ippiAdd_32fc_AC4IR:=getProc(hh,'ippiAdd_32fc_AC4IR');
  ippiSub_32fc_C1IR:=getProc(hh,'ippiSub_32fc_C1IR');
  ippiSub_32fc_C3IR:=getProc(hh,'ippiSub_32fc_C3IR');
  ippiSub_32fc_AC4IR:=getProc(hh,'ippiSub_32fc_AC4IR');
  ippiMul_32fc_C1IR:=getProc(hh,'ippiMul_32fc_C1IR');
  ippiMul_32fc_C3IR:=getProc(hh,'ippiMul_32fc_C3IR');
  ippiMul_32fc_AC4IR:=getProc(hh,'ippiMul_32fc_AC4IR');
  ippiDiv_32fc_C1IR:=getProc(hh,'ippiDiv_32fc_C1IR');
  ippiDiv_32fc_C3IR:=getProc(hh,'ippiDiv_32fc_C3IR');
  ippiDiv_32fc_AC4IR:=getProc(hh,'ippiDiv_32fc_AC4IR');
  ippiAdd_32fc_C1R:=getProc(hh,'ippiAdd_32fc_C1R');
  ippiAdd_32fc_C3R:=getProc(hh,'ippiAdd_32fc_C3R');
  ippiAdd_32fc_AC4R:=getProc(hh,'ippiAdd_32fc_AC4R');
  ippiSub_32fc_C1R:=getProc(hh,'ippiSub_32fc_C1R');
  ippiSub_32fc_C3R:=getProc(hh,'ippiSub_32fc_C3R');
  ippiSub_32fc_AC4R:=getProc(hh,'ippiSub_32fc_AC4R');
  ippiMul_32fc_C1R:=getProc(hh,'ippiMul_32fc_C1R');
  ippiMul_32fc_C3R:=getProc(hh,'ippiMul_32fc_C3R');
  ippiMul_32fc_AC4R:=getProc(hh,'ippiMul_32fc_AC4R');
  ippiDiv_32fc_C1R:=getProc(hh,'ippiDiv_32fc_C1R');
  ippiDiv_32fc_C3R:=getProc(hh,'ippiDiv_32fc_C3R');
  ippiDiv_32fc_AC4R:=getProc(hh,'ippiDiv_32fc_AC4R');
  ippiAdd_16sc_C1IRSfs:=getProc(hh,'ippiAdd_16sc_C1IRSfs');
  ippiAdd_16sc_C3IRSfs:=getProc(hh,'ippiAdd_16sc_C3IRSfs');
  ippiAdd_16sc_AC4IRSfs:=getProc(hh,'ippiAdd_16sc_AC4IRSfs');
  ippiSub_16sc_C1IRSfs:=getProc(hh,'ippiSub_16sc_C1IRSfs');
  ippiSub_16sc_C3IRSfs:=getProc(hh,'ippiSub_16sc_C3IRSfs');
  ippiSub_16sc_AC4IRSfs:=getProc(hh,'ippiSub_16sc_AC4IRSfs');
  ippiMul_16sc_C1IRSfs:=getProc(hh,'ippiMul_16sc_C1IRSfs');
  ippiMul_16sc_C3IRSfs:=getProc(hh,'ippiMul_16sc_C3IRSfs');
  ippiMul_16sc_AC4IRSfs:=getProc(hh,'ippiMul_16sc_AC4IRSfs');
  ippiDiv_16sc_C1IRSfs:=getProc(hh,'ippiDiv_16sc_C1IRSfs');
  ippiDiv_16sc_C3IRSfs:=getProc(hh,'ippiDiv_16sc_C3IRSfs');
  ippiDiv_16sc_AC4IRSfs:=getProc(hh,'ippiDiv_16sc_AC4IRSfs');
  ippiAdd_16sc_C1RSfs:=getProc(hh,'ippiAdd_16sc_C1RSfs');
  ippiAdd_16sc_C3RSfs:=getProc(hh,'ippiAdd_16sc_C3RSfs');
  ippiAdd_16sc_AC4RSfs:=getProc(hh,'ippiAdd_16sc_AC4RSfs');
  ippiSub_16sc_C1RSfs:=getProc(hh,'ippiSub_16sc_C1RSfs');
  ippiSub_16sc_C3RSfs:=getProc(hh,'ippiSub_16sc_C3RSfs');
  ippiSub_16sc_AC4RSfs:=getProc(hh,'ippiSub_16sc_AC4RSfs');
  ippiMul_16sc_C1RSfs:=getProc(hh,'ippiMul_16sc_C1RSfs');
  ippiMul_16sc_C3RSfs:=getProc(hh,'ippiMul_16sc_C3RSfs');
  ippiMul_16sc_AC4RSfs:=getProc(hh,'ippiMul_16sc_AC4RSfs');
  ippiDiv_16sc_C1RSfs:=getProc(hh,'ippiDiv_16sc_C1RSfs');
  ippiDiv_16sc_C3RSfs:=getProc(hh,'ippiDiv_16sc_C3RSfs');
  ippiDiv_16sc_AC4RSfs:=getProc(hh,'ippiDiv_16sc_AC4RSfs');
  ippiAdd_32sc_C1IRSfs:=getProc(hh,'ippiAdd_32sc_C1IRSfs');
  ippiAdd_32sc_C3IRSfs:=getProc(hh,'ippiAdd_32sc_C3IRSfs');
  ippiAdd_32sc_AC4IRSfs:=getProc(hh,'ippiAdd_32sc_AC4IRSfs');
  ippiSub_32sc_C1IRSfs:=getProc(hh,'ippiSub_32sc_C1IRSfs');
  ippiSub_32sc_C3IRSfs:=getProc(hh,'ippiSub_32sc_C3IRSfs');
  ippiSub_32sc_AC4IRSfs:=getProc(hh,'ippiSub_32sc_AC4IRSfs');
  ippiMul_32sc_C1IRSfs:=getProc(hh,'ippiMul_32sc_C1IRSfs');
  ippiMul_32sc_C3IRSfs:=getProc(hh,'ippiMul_32sc_C3IRSfs');
  ippiMul_32sc_AC4IRSfs:=getProc(hh,'ippiMul_32sc_AC4IRSfs');
  ippiDiv_32sc_C1IRSfs:=getProc(hh,'ippiDiv_32sc_C1IRSfs');
  ippiDiv_32sc_C3IRSfs:=getProc(hh,'ippiDiv_32sc_C3IRSfs');
  ippiDiv_32sc_AC4IRSfs:=getProc(hh,'ippiDiv_32sc_AC4IRSfs');
  ippiAdd_32sc_C1RSfs:=getProc(hh,'ippiAdd_32sc_C1RSfs');
  ippiAdd_32sc_C3RSfs:=getProc(hh,'ippiAdd_32sc_C3RSfs');
  ippiAdd_32sc_AC4RSfs:=getProc(hh,'ippiAdd_32sc_AC4RSfs');
  ippiSub_32sc_C1RSfs:=getProc(hh,'ippiSub_32sc_C1RSfs');
  ippiSub_32sc_C3RSfs:=getProc(hh,'ippiSub_32sc_C3RSfs');
  ippiSub_32sc_AC4RSfs:=getProc(hh,'ippiSub_32sc_AC4RSfs');
  ippiMul_32sc_C1RSfs:=getProc(hh,'ippiMul_32sc_C1RSfs');
  ippiMul_32sc_C3RSfs:=getProc(hh,'ippiMul_32sc_C3RSfs');
  ippiMul_32sc_AC4RSfs:=getProc(hh,'ippiMul_32sc_AC4RSfs');
  ippiDiv_32sc_C1RSfs:=getProc(hh,'ippiDiv_32sc_C1RSfs');
  ippiDiv_32sc_C3RSfs:=getProc(hh,'ippiDiv_32sc_C3RSfs');
  ippiDiv_32sc_AC4RSfs:=getProc(hh,'ippiDiv_32sc_AC4RSfs');
  ippiAddC_16sc_C1IRSfs:=getProc(hh,'ippiAddC_16sc_C1IRSfs');
  ippiAddC_16sc_C3IRSfs:=getProc(hh,'ippiAddC_16sc_C3IRSfs');
  ippiAddC_16sc_AC4IRSfs:=getProc(hh,'ippiAddC_16sc_AC4IRSfs');
  ippiSubC_16sc_C1IRSfs:=getProc(hh,'ippiSubC_16sc_C1IRSfs');
  ippiSubC_16sc_C3IRSfs:=getProc(hh,'ippiSubC_16sc_C3IRSfs');
  ippiSubC_16sc_AC4IRSfs:=getProc(hh,'ippiSubC_16sc_AC4IRSfs');
  ippiMulC_16sc_C1IRSfs:=getProc(hh,'ippiMulC_16sc_C1IRSfs');
  ippiMulC_16sc_C3IRSfs:=getProc(hh,'ippiMulC_16sc_C3IRSfs');
  ippiMulC_16sc_AC4IRSfs:=getProc(hh,'ippiMulC_16sc_AC4IRSfs');
  ippiDivC_16sc_C1IRSfs:=getProc(hh,'ippiDivC_16sc_C1IRSfs');
  ippiDivC_16sc_C3IRSfs:=getProc(hh,'ippiDivC_16sc_C3IRSfs');
  ippiDivC_16sc_AC4IRSfs:=getProc(hh,'ippiDivC_16sc_AC4IRSfs');
  ippiAddC_16sc_C1RSfs:=getProc(hh,'ippiAddC_16sc_C1RSfs');
  ippiAddC_16sc_C3RSfs:=getProc(hh,'ippiAddC_16sc_C3RSfs');
  ippiAddC_16sc_AC4RSfs:=getProc(hh,'ippiAddC_16sc_AC4RSfs');
  ippiSubC_16sc_C1RSfs:=getProc(hh,'ippiSubC_16sc_C1RSfs');
  ippiSubC_16sc_C3RSfs:=getProc(hh,'ippiSubC_16sc_C3RSfs');
  ippiSubC_16sc_AC4RSfs:=getProc(hh,'ippiSubC_16sc_AC4RSfs');
  ippiMulC_16sc_C1RSfs:=getProc(hh,'ippiMulC_16sc_C1RSfs');
  ippiMulC_16sc_C3RSfs:=getProc(hh,'ippiMulC_16sc_C3RSfs');
  ippiMulC_16sc_AC4RSfs:=getProc(hh,'ippiMulC_16sc_AC4RSfs');
  ippiDivC_16sc_C1RSfs:=getProc(hh,'ippiDivC_16sc_C1RSfs');
  ippiDivC_16sc_C3RSfs:=getProc(hh,'ippiDivC_16sc_C3RSfs');
  ippiDivC_16sc_AC4RSfs:=getProc(hh,'ippiDivC_16sc_AC4RSfs');
  ippiAddC_32sc_C1IRSfs:=getProc(hh,'ippiAddC_32sc_C1IRSfs');
  ippiAddC_32sc_C3IRSfs:=getProc(hh,'ippiAddC_32sc_C3IRSfs');
  ippiAddC_32sc_AC4IRSfs:=getProc(hh,'ippiAddC_32sc_AC4IRSfs');
  ippiSubC_32sc_C1IRSfs:=getProc(hh,'ippiSubC_32sc_C1IRSfs');
  ippiSubC_32sc_C3IRSfs:=getProc(hh,'ippiSubC_32sc_C3IRSfs');
  ippiSubC_32sc_AC4IRSfs:=getProc(hh,'ippiSubC_32sc_AC4IRSfs');
  ippiMulC_32sc_C1IRSfs:=getProc(hh,'ippiMulC_32sc_C1IRSfs');
  ippiMulC_32sc_C3IRSfs:=getProc(hh,'ippiMulC_32sc_C3IRSfs');
  ippiMulC_32sc_AC4IRSfs:=getProc(hh,'ippiMulC_32sc_AC4IRSfs');
  ippiDivC_32sc_C1IRSfs:=getProc(hh,'ippiDivC_32sc_C1IRSfs');
  ippiDivC_32sc_C3IRSfs:=getProc(hh,'ippiDivC_32sc_C3IRSfs');
  ippiDivC_32sc_AC4IRSfs:=getProc(hh,'ippiDivC_32sc_AC4IRSfs');
  ippiAddC_32sc_C1RSfs:=getProc(hh,'ippiAddC_32sc_C1RSfs');
  ippiAddC_32sc_C3RSfs:=getProc(hh,'ippiAddC_32sc_C3RSfs');
  ippiAddC_32sc_AC4RSfs:=getProc(hh,'ippiAddC_32sc_AC4RSfs');
  ippiSubC_32sc_C1RSfs:=getProc(hh,'ippiSubC_32sc_C1RSfs');
  ippiSubC_32sc_C3RSfs:=getProc(hh,'ippiSubC_32sc_C3RSfs');
  ippiSubC_32sc_AC4RSfs:=getProc(hh,'ippiSubC_32sc_AC4RSfs');
  ippiMulC_32sc_C1RSfs:=getProc(hh,'ippiMulC_32sc_C1RSfs');
  ippiMulC_32sc_C3RSfs:=getProc(hh,'ippiMulC_32sc_C3RSfs');
  ippiMulC_32sc_AC4RSfs:=getProc(hh,'ippiMulC_32sc_AC4RSfs');
  ippiDivC_32sc_C1RSfs:=getProc(hh,'ippiDivC_32sc_C1RSfs');
  ippiDivC_32sc_C3RSfs:=getProc(hh,'ippiDivC_32sc_C3RSfs');
  ippiDivC_32sc_AC4RSfs:=getProc(hh,'ippiDivC_32sc_AC4RSfs');
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
  ippiMulPack_16s_C1IRSfs:=getProc(hh,'ippiMulPack_16s_C1IRSfs');
  ippiMulPack_16s_C3IRSfs:=getProc(hh,'ippiMulPack_16s_C3IRSfs');
  ippiMulPack_16s_C4IRSfs:=getProc(hh,'ippiMulPack_16s_C4IRSfs');
  ippiMulPack_16s_AC4IRSfs:=getProc(hh,'ippiMulPack_16s_AC4IRSfs');
  ippiMulPack_16s_C1RSfs:=getProc(hh,'ippiMulPack_16s_C1RSfs');
  ippiMulPack_16s_C3RSfs:=getProc(hh,'ippiMulPack_16s_C3RSfs');
  ippiMulPack_16s_C4RSfs:=getProc(hh,'ippiMulPack_16s_C4RSfs');
  ippiMulPack_16s_AC4RSfs:=getProc(hh,'ippiMulPack_16s_AC4RSfs');
  ippiMulPack_32s_C1IRSfs:=getProc(hh,'ippiMulPack_32s_C1IRSfs');
  ippiMulPack_32s_C3IRSfs:=getProc(hh,'ippiMulPack_32s_C3IRSfs');
  ippiMulPack_32s_C4IRSfs:=getProc(hh,'ippiMulPack_32s_C4IRSfs');
  ippiMulPack_32s_AC4IRSfs:=getProc(hh,'ippiMulPack_32s_AC4IRSfs');
  ippiMulPack_32s_C1RSfs:=getProc(hh,'ippiMulPack_32s_C1RSfs');
  ippiMulPack_32s_C3RSfs:=getProc(hh,'ippiMulPack_32s_C3RSfs');
  ippiMulPack_32s_C4RSfs:=getProc(hh,'ippiMulPack_32s_C4RSfs');
  ippiMulPack_32s_AC4RSfs:=getProc(hh,'ippiMulPack_32s_AC4RSfs');
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
  ippiPackToCplxExtend_32s32sc_C1R:=getProc(hh,'ippiPackToCplxExtend_32s32sc_C1R');
  ippiPackToCplxExtend_32f32fc_C1R:=getProc(hh,'ippiPackToCplxExtend_32f32fc_C1R');
  ippiPhasePack_32f_C1R:=getProc(hh,'ippiPhasePack_32f_C1R');
  ippiPhasePack_32f_C3R:=getProc(hh,'ippiPhasePack_32f_C3R');
  ippiPhasePack_32s_C1RSfs:=getProc(hh,'ippiPhasePack_32s_C1RSfs');
  ippiPhasePack_32s_C3RSfs:=getProc(hh,'ippiPhasePack_32s_C3RSfs');
  ippiPhasePack_16s_C1RSfs:=getProc(hh,'ippiPhasePack_16s_C1RSfs');
  ippiPhasePack_16s_C3RSfs:=getProc(hh,'ippiPhasePack_16s_C3RSfs');
  ippiMagnitudePack_32f_C1R:=getProc(hh,'ippiMagnitudePack_32f_C1R');
  ippiMagnitudePack_32f_C3R:=getProc(hh,'ippiMagnitudePack_32f_C3R');
  ippiMagnitudePack_16s_C1RSfs:=getProc(hh,'ippiMagnitudePack_16s_C1RSfs');
  ippiMagnitudePack_16s_C3RSfs:=getProc(hh,'ippiMagnitudePack_16s_C3RSfs');
  ippiMagnitudePack_32s_C1RSfs:=getProc(hh,'ippiMagnitudePack_32s_C1RSfs');
  ippiMagnitudePack_32s_C3RSfs:=getProc(hh,'ippiMagnitudePack_32s_C3RSfs');
  ippiMagnitude_32fc32f_C1R:=getProc(hh,'ippiMagnitude_32fc32f_C1R');
  ippiMagnitude_32fc32f_C3R:=getProc(hh,'ippiMagnitude_32fc32f_C3R');
  ippiMagnitude_16sc16s_C1RSfs:=getProc(hh,'ippiMagnitude_16sc16s_C1RSfs');
  ippiMagnitude_16sc16s_C3RSfs:=getProc(hh,'ippiMagnitude_16sc16s_C3RSfs');
  ippiMagnitude_32sc32s_C1RSfs:=getProc(hh,'ippiMagnitude_32sc32s_C1RSfs');
  ippiMagnitude_32sc32s_C3RSfs:=getProc(hh,'ippiMagnitude_32sc32s_C3RSfs');
  ippiPhase_32fc32f_C1R:=getProc(hh,'ippiPhase_32fc32f_C1R');
  ippiPhase_32fc32f_C3R:=getProc(hh,'ippiPhase_32fc32f_C3R');
  ippiPhase_32sc32s_C1RSfs:=getProc(hh,'ippiPhase_32sc32s_C1RSfs');
  ippiPhase_32sc32s_C3RSfs:=getProc(hh,'ippiPhase_32sc32s_C3RSfs');
  ippiPhase_16sc16s_C1RSfs:=getProc(hh,'ippiPhase_16sc16s_C1RSfs');
  ippiPhase_16sc16s_C3RSfs:=getProc(hh,'ippiPhase_16sc16s_C3RSfs');
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
  ippiAlphaComp_8u_AP4R:=getProc(hh,'ippiAlphaComp_8u_AP4R');
  ippiAlphaComp_16u_AP4R:=getProc(hh,'ippiAlphaComp_16u_AP4R');
  ippiAlphaComp_8u_AC1R:=getProc(hh,'ippiAlphaComp_8u_AC1R');
  ippiAlphaComp_16u_AC1R:=getProc(hh,'ippiAlphaComp_16u_AC1R');
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
  ippiFFTInitAlloc_C_32fc:=getProc(hh,'ippiFFTInitAlloc_C_32fc');
  ippiFFTInitAlloc_R_32f:=getProc(hh,'ippiFFTInitAlloc_R_32f');
  ippiFFTInitAlloc_R_32s:=getProc(hh,'ippiFFTInitAlloc_R_32s');
  ippiFFTFree_C_32fc:=getProc(hh,'ippiFFTFree_C_32fc');
  ippiFFTFree_R_32f:=getProc(hh,'ippiFFTFree_R_32f');
  ippiFFTFree_R_32s:=getProc(hh,'ippiFFTFree_R_32s');
  ippiFFTGetBufSize_C_32fc:=getProc(hh,'ippiFFTGetBufSize_C_32fc');
  ippiFFTGetBufSize_R_32f:=getProc(hh,'ippiFFTGetBufSize_R_32f');
  ippiFFTGetBufSize_R_32s:=getProc(hh,'ippiFFTGetBufSize_R_32s');
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
  ippiFFTFwd_RToPack_8u32s_C1RSfs:=getProc(hh,'ippiFFTFwd_RToPack_8u32s_C1RSfs');
  ippiFFTFwd_RToPack_8u32s_C3RSfs:=getProc(hh,'ippiFFTFwd_RToPack_8u32s_C3RSfs');
  ippiFFTFwd_RToPack_8u32s_C4RSfs:=getProc(hh,'ippiFFTFwd_RToPack_8u32s_C4RSfs');
  ippiFFTFwd_RToPack_8u32s_AC4RSfs:=getProc(hh,'ippiFFTFwd_RToPack_8u32s_AC4RSfs');
  ippiFFTInv_PackToR_32s8u_C1RSfs:=getProc(hh,'ippiFFTInv_PackToR_32s8u_C1RSfs');
  ippiFFTInv_PackToR_32s8u_C3RSfs:=getProc(hh,'ippiFFTInv_PackToR_32s8u_C3RSfs');
  ippiFFTInv_PackToR_32s8u_C4RSfs:=getProc(hh,'ippiFFTInv_PackToR_32s8u_C4RSfs');
  ippiFFTInv_PackToR_32s8u_AC4RSfs:=getProc(hh,'ippiFFTInv_PackToR_32s8u_AC4RSfs');
  ippiDFTInitAlloc_C_32fc:=getProc(hh,'ippiDFTInitAlloc_C_32fc');
  ippiDFTInitAlloc_R_32f:=getProc(hh,'ippiDFTInitAlloc_R_32f');
  ippiDFTInitAlloc_R_32s:=getProc(hh,'ippiDFTInitAlloc_R_32s');
  ippiDFTFree_C_32fc:=getProc(hh,'ippiDFTFree_C_32fc');
  ippiDFTFree_R_32f:=getProc(hh,'ippiDFTFree_R_32f');
  ippiDFTFree_R_32s:=getProc(hh,'ippiDFTFree_R_32s');
  ippiDFTGetBufSize_C_32fc:=getProc(hh,'ippiDFTGetBufSize_C_32fc');
  ippiDFTGetBufSize_R_32f:=getProc(hh,'ippiDFTGetBufSize_R_32f');
  ippiDFTGetBufSize_R_32s:=getProc(hh,'ippiDFTGetBufSize_R_32s');
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
  ippiDFTFwd_RToPack_8u32s_C1RSfs:=getProc(hh,'ippiDFTFwd_RToPack_8u32s_C1RSfs');
  ippiDFTFwd_RToPack_8u32s_C3RSfs:=getProc(hh,'ippiDFTFwd_RToPack_8u32s_C3RSfs');
  ippiDFTFwd_RToPack_8u32s_C4RSfs:=getProc(hh,'ippiDFTFwd_RToPack_8u32s_C4RSfs');
  ippiDFTFwd_RToPack_8u32s_AC4RSfs:=getProc(hh,'ippiDFTFwd_RToPack_8u32s_AC4RSfs');
  ippiDFTInv_PackToR_32s8u_C1RSfs:=getProc(hh,'ippiDFTInv_PackToR_32s8u_C1RSfs');
  ippiDFTInv_PackToR_32s8u_C3RSfs:=getProc(hh,'ippiDFTInv_PackToR_32s8u_C3RSfs');
  ippiDFTInv_PackToR_32s8u_C4RSfs:=getProc(hh,'ippiDFTInv_PackToR_32s8u_C4RSfs');
  ippiDFTInv_PackToR_32s8u_AC4RSfs:=getProc(hh,'ippiDFTInv_PackToR_32s8u_AC4RSfs');
  ippiDCTFwdInitAlloc_32f:=getProc(hh,'ippiDCTFwdInitAlloc_32f');
  ippiDCTInvInitAlloc_32f:=getProc(hh,'ippiDCTInvInitAlloc_32f');
  ippiDCTFwdFree_32f:=getProc(hh,'ippiDCTFwdFree_32f');
  ippiDCTInvFree_32f:=getProc(hh,'ippiDCTInvFree_32f');
  ippiDCTFwdGetBufSize_32f:=getProc(hh,'ippiDCTFwdGetBufSize_32f');
  ippiDCTInvGetBufSize_32f:=getProc(hh,'ippiDCTInvGetBufSize_32f');
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
  ippiDCT8x8Fwd_8u16s_C1R:=getProc(hh,'ippiDCT8x8Fwd_8u16s_C1R');
  ippiDCT8x8Inv_16s8u_C1R:=getProc(hh,'ippiDCT8x8Inv_16s8u_C1R');
  ippiDCT8x8FwdLS_8u16s_C1R:=getProc(hh,'ippiDCT8x8FwdLS_8u16s_C1R');
  ippiDCT8x8InvLSClip_16s8u_C1R:=getProc(hh,'ippiDCT8x8InvLSClip_16s8u_C1R');
  ippiDCT8x8Fwd_32f_C1:=getProc(hh,'ippiDCT8x8Fwd_32f_C1');
  ippiDCT8x8Inv_32f_C1:=getProc(hh,'ippiDCT8x8Inv_32f_C1');
  ippiDCT8x8Fwd_32f_C1I:=getProc(hh,'ippiDCT8x8Fwd_32f_C1I');
  ippiDCT8x8Inv_32f_C1I:=getProc(hh,'ippiDCT8x8Inv_32f_C1I');
end;

procedure Init2;
begin
  ippiWTFwdInitAlloc_32f_C1R:=getProc(hh,'ippiWTFwdInitAlloc_32f_C1R');
  ippiWTFwdInitAlloc_32f_C3R:=getProc(hh,'ippiWTFwdInitAlloc_32f_C3R');
  ippiWTFwdFree_32f_C1R:=getProc(hh,'ippiWTFwdFree_32f_C1R');
  ippiWTFwdFree_32f_C3R:=getProc(hh,'ippiWTFwdFree_32f_C3R');
  ippiWTFwdGetBufSize_C1R:=getProc(hh,'ippiWTFwdGetBufSize_C1R');
  ippiWTFwdGetBufSize_C3R:=getProc(hh,'ippiWTFwdGetBufSize_C3R');
  ippiWTFwd_32f_C1R:=getProc(hh,'ippiWTFwd_32f_C1R');
  ippiWTFwd_32f_C3R:=getProc(hh,'ippiWTFwd_32f_C3R');
  ippiWTInvInitAlloc_32f_C1R:=getProc(hh,'ippiWTInvInitAlloc_32f_C1R');
  ippiWTInvInitAlloc_32f_C3R:=getProc(hh,'ippiWTInvInitAlloc_32f_C3R');
  ippiWTInvFree_32f_C1R:=getProc(hh,'ippiWTInvFree_32f_C1R');
  ippiWTInvFree_32f_C3R:=getProc(hh,'ippiWTInvFree_32f_C3R');
  ippiWTInvGetBufSize_C1R:=getProc(hh,'ippiWTInvGetBufSize_C1R');
  ippiWTInvGetBufSize_C3R:=getProc(hh,'ippiWTInvGetBufSize_C3R');
  ippiWTInv_32f_C1R:=getProc(hh,'ippiWTInv_32f_C1R');
  ippiWTInv_32f_C3R:=getProc(hh,'ippiWTInv_32f_C3R');
  ippiCbYCr422ToBGR_8u_C2C4R:=getProc(hh,'ippiCbYCr422ToBGR_8u_C2C4R');
  ippiBGRToCbYCr422_8u_AC4C2R:=getProc(hh,'ippiBGRToCbYCr422_8u_AC4C2R');
  ippiYCbCr411ToBGR_8u_P3C3R:=getProc(hh,'ippiYCbCr411ToBGR_8u_P3C3R');
  ippiYCbCr411ToBGR_8u_P3C4R:=getProc(hh,'ippiYCbCr411ToBGR_8u_P3C4R');
  ippiCbYCr422ToRGB_8u_C2C3R:=getProc(hh,'ippiCbYCr422ToRGB_8u_C2C3R');
  ippiRGBToCbYCr422Gamma_8u_C3C2R:=getProc(hh,'ippiRGBToCbYCr422Gamma_8u_C3C2R');
  ippiRGBToCbYCr422_8u_C3C2R:=getProc(hh,'ippiRGBToCbYCr422_8u_C3C2R');
  ippiYCbCr422ToRGB_8u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB_8u_P3C3R');
  ippiRGBToYCbCr422_8u_C3C2R:=getProc(hh,'ippiRGBToYCbCr422_8u_C3C2R');
  ippiYCbCr422ToRGB_8u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB_8u_C2C3R');
  ippiRGBToYCbCr422_8u_P3C2R:=getProc(hh,'ippiRGBToYCbCr422_8u_P3C2R');
  ippiYCbCr422ToRGB_8u_C2P3R:=getProc(hh,'ippiYCbCr422ToRGB_8u_C2P3R');
  ippiYCbCr420ToBGR_8u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR_8u_P3C3R');
  ippiYCbCr420ToRGB_8u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB_8u_P3C3R');
  ippiRGBToYCbCr420_8u_C3P3R:=getProc(hh,'ippiRGBToYCbCr420_8u_C3P3R');
  ippiYCbCr422ToRGB565_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB565_8u16u_C2C3R');
  ippiYCbCr422ToBGR565_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToBGR565_8u16u_C2C3R');
  ippiYCbCr422ToRGB555_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB555_8u16u_C2C3R');
  ippiYCbCr422ToBGR555_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToBGR555_8u16u_C2C3R');
  ippiYCbCr422ToRGB444_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB444_8u16u_C2C3R');
  ippiYCbCr422ToBGR444_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToBGR444_8u16u_C2C3R');
  ippiYCbCrToBGR565_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToBGR565_8u16u_P3C3R');
  ippiYCbCrToRGB565_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToRGB565_8u16u_P3C3R');
  ippiYCbCrToBGR444_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToBGR444_8u16u_P3C3R');
  ippiYCbCrToRGB444_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToRGB444_8u16u_P3C3R');
  ippiYCbCrToBGR555_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToBGR555_8u16u_P3C3R');
  ippiYCbCrToRGB555_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToRGB555_8u16u_P3C3R');
  ippiYCbCr420ToBGR565_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR565_8u16u_P3C3R');
  ippiYCbCr420ToRGB565_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB565_8u16u_P3C3R');
  ippiYCbCr420ToBGR555_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR555_8u16u_P3C3R');
  ippiYCbCr420ToRGB555_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB555_8u16u_P3C3R');
  ippiYCbCr420ToBGR444_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR444_8u16u_P3C3R');
  ippiYCbCr420ToRGB444_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB444_8u16u_P3C3R');
  ippiYCbCr422ToBGR565_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToBGR565_8u16u_P3C3R');
  ippiYCbCr422ToRGB565_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB565_8u16u_P3C3R');
  ippiYCbCr422ToBGR555_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToBGR555_8u16u_P3C3R');
  ippiYCbCr422ToRGB555_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB555_8u16u_P3C3R');
  ippiYCbCr422ToBGR444_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToBGR444_8u16u_P3C3R');
  ippiYCbCr422ToRGB444_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB444_8u16u_P3C3R');
  ippiYCbCrToBGR565Dither_8u16u_C3R:=getProc(hh,'ippiYCbCrToBGR565Dither_8u16u_C3R');
  ippiYCbCrToRGB565Dither_8u16u_C3R:=getProc(hh,'ippiYCbCrToRGB565Dither_8u16u_C3R');
  ippiYCbCrToBGR555Dither_8u16u_C3R:=getProc(hh,'ippiYCbCrToBGR555Dither_8u16u_C3R');
  ippiYCbCrToRGB555Dither_8u16u_C3R:=getProc(hh,'ippiYCbCrToRGB555Dither_8u16u_C3R');
  ippiYCbCrToBGR444Dither_8u16u_C3R:=getProc(hh,'ippiYCbCrToBGR444Dither_8u16u_C3R');
  ippiYCbCrToRGB444Dither_8u16u_C3R:=getProc(hh,'ippiYCbCrToRGB444Dither_8u16u_C3R');
  ippiYCbCrToBGR565Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToBGR565Dither_8u16u_P3C3R');
  ippiYCbCrToRGB565Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToRGB565Dither_8u16u_P3C3R');
  ippiYCbCrToBGR555Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToBGR555Dither_8u16u_P3C3R');
  ippiYCbCrToRGB555Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToRGB555Dither_8u16u_P3C3R');
  ippiYCbCrToBGR444Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToBGR444Dither_8u16u_P3C3R');
  ippiYCbCrToRGB444Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCrToRGB444Dither_8u16u_P3C3R');
  ippiYCbCr420ToBGR565Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR565Dither_8u16u_P3C3R');
  ippiYCbCr420ToRGB565Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB565Dither_8u16u_P3C3R');
  ippiYCbCr420ToBGR555Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR555Dither_8u16u_P3C3R');
  ippiYCbCr420ToRGB555Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB555Dither_8u16u_P3C3R');
  ippiYCbCr420ToBGR444Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToBGR444Dither_8u16u_P3C3R');
  ippiYCbCr420ToRGB444Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr420ToRGB444Dither_8u16u_P3C3R');
  ippiYCbCr422ToBGR565Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToBGR565Dither_8u16u_P3C3R');
  ippiYCbCr422ToRGB565Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB565Dither_8u16u_P3C3R');
  ippiYCbCr422ToBGR555Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToBGR555Dither_8u16u_P3C3R');
  ippiYCbCr422ToRGB555Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB555Dither_8u16u_P3C3R');
  ippiYCbCr422ToBGR444Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToBGR444Dither_8u16u_P3C3R');
  ippiYCbCr422ToRGB444Dither_8u16u_P3C3R:=getProc(hh,'ippiYCbCr422ToRGB444Dither_8u16u_P3C3R');
  ippiYCbCr422ToRGB555Dither_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB555Dither_8u16u_C2C3R');
  ippiYCbCr422ToBGR555Dither_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToBGR555Dither_8u16u_C2C3R');
  ippiYCbCr422ToRGB565Dither_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB565Dither_8u16u_C2C3R');
  ippiYCbCr422ToBGR565Dither_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToBGR565Dither_8u16u_C2C3R');
  ippiYCbCr422ToRGB444Dither_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToRGB444Dither_8u16u_C2C3R');
  ippiYCbCr422ToBGR444Dither_8u16u_C2C3R:=getProc(hh,'ippiYCbCr422ToBGR444Dither_8u16u_C2C3R');
  ippiYUV420ToBGR444Dither_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToBGR444Dither_8u16u_P3C3R');
  ippiYUV420ToRGB444Dither_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToRGB444Dither_8u16u_P3C3R');
  ippiYUV420ToBGR555Dither_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToBGR555Dither_8u16u_P3C3R');
  ippiYUV420ToRGB555Dither_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToRGB555Dither_8u16u_P3C3R');
  ippiYUV420ToBGR565Dither_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToBGR565Dither_8u16u_P3C3R');
  ippiYUV420ToRGB565Dither_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToRGB565Dither_8u16u_P3C3R');
  ippiJoin422_8u_P3C2R:=getProc(hh,'ippiJoin422_8u_P3C2R');
  ippiSplit422_8u_C2P3R:=getProc(hh,'ippiSplit422_8u_C2P3R');
  ippiJoin420_8u_P2C2R:=getProc(hh,'ippiJoin420_8u_P2C2R');
  ippiJoin420_Filter_8u_P2C2R:=getProc(hh,'ippiJoin420_Filter_8u_P2C2R');
  ippiSplit420_8u_P2P3R:=getProc(hh,'ippiSplit420_8u_P2P3R');
  ippiSplit420_Filter_8u_P2P3R:=getProc(hh,'ippiSplit420_Filter_8u_P2P3R');
  ippiRGBToYCbCr_8u_C3R:=getProc(hh,'ippiRGBToYCbCr_8u_C3R');
  ippiRGBToYCbCr_8u_AC4R:=getProc(hh,'ippiRGBToYCbCr_8u_AC4R');
  ippiRGBToYCbCr_8u_P3R:=getProc(hh,'ippiRGBToYCbCr_8u_P3R');
  ippiYCbCrToRGB_8u_P3C3R:=getProc(hh,'ippiYCbCrToRGB_8u_P3C3R');
  ippiYCbCrToRGB_8u_C3R:=getProc(hh,'ippiYCbCrToRGB_8u_C3R');
  ippiYCbCrToRGB_8u_AC4R:=getProc(hh,'ippiYCbCrToRGB_8u_AC4R');
  ippiYCbCrToRGB_8u_P3R:=getProc(hh,'ippiYCbCrToRGB_8u_P3R');
  ippiYCbCrToBGR444_8u16u_C3R:=getProc(hh,'ippiYCbCrToBGR444_8u16u_C3R');
  ippiYCbCrToRGB444_8u16u_C3R:=getProc(hh,'ippiYCbCrToRGB444_8u16u_C3R');
  ippiYCbCrToBGR555_8u16u_C3R:=getProc(hh,'ippiYCbCrToBGR555_8u16u_C3R');
  ippiYCbCrToRGB555_8u16u_C3R:=getProc(hh,'ippiYCbCrToRGB555_8u16u_C3R');
  ippiYCbCrToBGR565_8u16u_C3R:=getProc(hh,'ippiYCbCrToBGR565_8u16u_C3R');
  ippiYCbCrToRGB565_8u16u_C3R:=getProc(hh,'ippiYCbCrToRGB565_8u16u_C3R');
  ippiRGBToYUV_8u_C3R:=getProc(hh,'ippiRGBToYUV_8u_C3R');
  ippiYUVToRGB_8u_C3R:=getProc(hh,'ippiYUVToRGB_8u_C3R');
  ippiRGBToYUV_8u_AC4R:=getProc(hh,'ippiRGBToYUV_8u_AC4R');
  ippiYUVToRGB_8u_AC4R:=getProc(hh,'ippiYUVToRGB_8u_AC4R');
  ippiRGBToYUV_8u_P3R:=getProc(hh,'ippiRGBToYUV_8u_P3R');
  ippiYUVToRGB_8u_P3R:=getProc(hh,'ippiYUVToRGB_8u_P3R');
  ippiRGBToYUV_8u_C3P3R:=getProc(hh,'ippiRGBToYUV_8u_C3P3R');
  ippiYUVToRGB_8u_P3C3R:=getProc(hh,'ippiYUVToRGB_8u_P3C3R');
  ippiYUV420ToRGB_8u_P3AC4R:=getProc(hh,'ippiYUV420ToRGB_8u_P3AC4R');
  ippiYUV422ToRGB_8u_P3AC4R:=getProc(hh,'ippiYUV422ToRGB_8u_P3AC4R');
  ippiRGBToYUV422_8u_C3P3R:=getProc(hh,'ippiRGBToYUV422_8u_C3P3R');
  ippiYUV422ToRGB_8u_P3C3R:=getProc(hh,'ippiYUV422ToRGB_8u_P3C3R');
  ippiRGBToYUV422_8u_P3R:=getProc(hh,'ippiRGBToYUV422_8u_P3R');
  ippiYUV422ToRGB_8u_P3R:=getProc(hh,'ippiYUV422ToRGB_8u_P3R');
  ippiRGBToYUV420_8u_C3P3R:=getProc(hh,'ippiRGBToYUV420_8u_C3P3R');
  ippiYUV420ToRGB_8u_P3C3R:=getProc(hh,'ippiYUV420ToRGB_8u_P3C3R');
  ippiRGBToYUV420_8u_P3R:=getProc(hh,'ippiRGBToYUV420_8u_P3R');
  ippiYUV420ToRGB_8u_P3R:=getProc(hh,'ippiYUV420ToRGB_8u_P3R');
  ippiRGBToYUV422_8u_C3C2R:=getProc(hh,'ippiRGBToYUV422_8u_C3C2R');
  ippiYUV422ToRGB_8u_C2C3R:=getProc(hh,'ippiYUV422ToRGB_8u_C2C3R');
  ippiYUV420ToBGR565_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToBGR565_8u16u_P3C3R');
  ippiYUV420ToBGR555_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToBGR555_8u16u_P3C3R');
  ippiYUV420ToBGR444_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToBGR444_8u16u_P3C3R');
  ippiYUV420ToRGB565_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToRGB565_8u16u_P3C3R');
  ippiYUV420ToRGB555_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToRGB555_8u16u_P3C3R');
  ippiYUV420ToRGB444_8u16u_P3C3R:=getProc(hh,'ippiYUV420ToRGB444_8u16u_P3C3R');
  ippiRGBToYUV422_8u_P3:=getProc(hh,'ippiRGBToYUV422_8u_P3');
  ippiYUV422ToRGB_8u_P3:=getProc(hh,'ippiYUV422ToRGB_8u_P3');
  ippiRGBToYUV422_8u_C3P3:=getProc(hh,'ippiRGBToYUV422_8u_C3P3');
  ippiYUV422ToRGB_8u_P3C3:=getProc(hh,'ippiYUV422ToRGB_8u_P3C3');
  ippiRGBToYUV420_8u_C3P3:=getProc(hh,'ippiRGBToYUV420_8u_C3P3');
  ippiYUV420ToRGB_8u_P3C3:=getProc(hh,'ippiYUV420ToRGB_8u_P3C3');
  ippiRGBToYUV420_8u_P3:=getProc(hh,'ippiRGBToYUV420_8u_P3');
  ippiYUV420ToRGB_8u_P3:=getProc(hh,'ippiYUV420ToRGB_8u_P3');
  ippiRGBToGray_8u_C3C1R:=getProc(hh,'ippiRGBToGray_8u_C3C1R');
  ippiRGBToGray_16u_C3C1R:=getProc(hh,'ippiRGBToGray_16u_C3C1R');
  ippiRGBToGray_16s_C3C1R:=getProc(hh,'ippiRGBToGray_16s_C3C1R');
  ippiRGBToGray_32f_C3C1R:=getProc(hh,'ippiRGBToGray_32f_C3C1R');
  ippiRGBToGray_8u_AC4C1R:=getProc(hh,'ippiRGBToGray_8u_AC4C1R');
  ippiRGBToGray_16u_AC4C1R:=getProc(hh,'ippiRGBToGray_16u_AC4C1R');
  ippiRGBToGray_16s_AC4C1R:=getProc(hh,'ippiRGBToGray_16s_AC4C1R');
  ippiRGBToGray_32f_AC4C1R:=getProc(hh,'ippiRGBToGray_32f_AC4C1R');
  ippiColorToGray_8u_C3C1R:=getProc(hh,'ippiColorToGray_8u_C3C1R');
  ippiColorToGray_16u_C3C1R:=getProc(hh,'ippiColorToGray_16u_C3C1R');
  ippiColorToGray_16s_C3C1R:=getProc(hh,'ippiColorToGray_16s_C3C1R');
  ippiColorToGray_32f_C3C1R:=getProc(hh,'ippiColorToGray_32f_C3C1R');
  ippiColorToGray_8u_AC4C1R:=getProc(hh,'ippiColorToGray_8u_AC4C1R');
  ippiColorToGray_16u_AC4C1R:=getProc(hh,'ippiColorToGray_16u_AC4C1R');
  ippiColorToGray_16s_AC4C1R:=getProc(hh,'ippiColorToGray_16s_AC4C1R');
  ippiColorToGray_32f_AC4C1R:=getProc(hh,'ippiColorToGray_32f_AC4C1R');
  ippiBGRToHLS_8u_AC4R:=getProc(hh,'ippiBGRToHLS_8u_AC4R');
  ippiRGBToHLS_8u_C3R:=getProc(hh,'ippiRGBToHLS_8u_C3R');
  ippiHLSToRGB_8u_C3R:=getProc(hh,'ippiHLSToRGB_8u_C3R');
  ippiRGBToHLS_8u_AC4R:=getProc(hh,'ippiRGBToHLS_8u_AC4R');
  ippiHLSToRGB_8u_AC4R:=getProc(hh,'ippiHLSToRGB_8u_AC4R');
  ippiRGBToHLS_16s_C3R:=getProc(hh,'ippiRGBToHLS_16s_C3R');
  ippiHLSToRGB_16s_C3R:=getProc(hh,'ippiHLSToRGB_16s_C3R');
  ippiRGBToHLS_16s_AC4R:=getProc(hh,'ippiRGBToHLS_16s_AC4R');
  ippiHLSToRGB_16s_AC4R:=getProc(hh,'ippiHLSToRGB_16s_AC4R');
  ippiRGBToHLS_16u_C3R:=getProc(hh,'ippiRGBToHLS_16u_C3R');
  ippiHLSToRGB_16u_C3R:=getProc(hh,'ippiHLSToRGB_16u_C3R');
  ippiRGBToHLS_16u_AC4R:=getProc(hh,'ippiRGBToHLS_16u_AC4R');
  ippiHLSToRGB_16u_AC4R:=getProc(hh,'ippiHLSToRGB_16u_AC4R');
  ippiRGBToHLS_32f_C3R:=getProc(hh,'ippiRGBToHLS_32f_C3R');
  ippiHLSToRGB_32f_C3R:=getProc(hh,'ippiHLSToRGB_32f_C3R');
  ippiRGBToHLS_32f_AC4R:=getProc(hh,'ippiRGBToHLS_32f_AC4R');
  ippiHLSToRGB_32f_AC4R:=getProc(hh,'ippiHLSToRGB_32f_AC4R');
  ippiBGRToHLS_8u_AP4R:=getProc(hh,'ippiBGRToHLS_8u_AP4R');
  ippiBGRToHLS_8u_AP4C4R:=getProc(hh,'ippiBGRToHLS_8u_AP4C4R');
  ippiBGRToHLS_8u_AC4P4R:=getProc(hh,'ippiBGRToHLS_8u_AC4P4R');
  ippiBGRToHLS_8u_P3R:=getProc(hh,'ippiBGRToHLS_8u_P3R');
  ippiBGRToHLS_8u_P3C3R:=getProc(hh,'ippiBGRToHLS_8u_P3C3R');
  ippiBGRToHLS_8u_C3P3R:=getProc(hh,'ippiBGRToHLS_8u_C3P3R');
  ippiHLSToBGR_8u_AP4R:=getProc(hh,'ippiHLSToBGR_8u_AP4R');
  ippiHLSToBGR_8u_AP4C4R:=getProc(hh,'ippiHLSToBGR_8u_AP4C4R');
  ippiHLSToBGR_8u_AC4P4R:=getProc(hh,'ippiHLSToBGR_8u_AC4P4R');
  ippiHLSToBGR_8u_P3R:=getProc(hh,'ippiHLSToBGR_8u_P3R');
  ippiHLSToBGR_8u_P3C3R:=getProc(hh,'ippiHLSToBGR_8u_P3C3R');
  ippiHLSToBGR_8u_C3P3R:=getProc(hh,'ippiHLSToBGR_8u_C3P3R');
  ippiRGBToHSV_8u_C3R:=getProc(hh,'ippiRGBToHSV_8u_C3R');
  ippiHSVToRGB_8u_C3R:=getProc(hh,'ippiHSVToRGB_8u_C3R');
  ippiRGBToHSV_8u_AC4R:=getProc(hh,'ippiRGBToHSV_8u_AC4R');
  ippiHSVToRGB_8u_AC4R:=getProc(hh,'ippiHSVToRGB_8u_AC4R');
  ippiRGBToHSV_16u_C3R:=getProc(hh,'ippiRGBToHSV_16u_C3R');
  ippiHSVToRGB_16u_C3R:=getProc(hh,'ippiHSVToRGB_16u_C3R');
  ippiRGBToHSV_16u_AC4R:=getProc(hh,'ippiRGBToHSV_16u_AC4R');
  ippiHSVToRGB_16u_AC4R:=getProc(hh,'ippiHSVToRGB_16u_AC4R');
  ippiRGBToYCC_8u_C3R:=getProc(hh,'ippiRGBToYCC_8u_C3R');
  ippiYCCToRGB_8u_C3R:=getProc(hh,'ippiYCCToRGB_8u_C3R');
  ippiRGBToYCC_8u_AC4R:=getProc(hh,'ippiRGBToYCC_8u_AC4R');
  ippiYCCToRGB_8u_AC4R:=getProc(hh,'ippiYCCToRGB_8u_AC4R');
  ippiRGBToYCC_16u_C3R:=getProc(hh,'ippiRGBToYCC_16u_C3R');
  ippiYCCToRGB_16u_C3R:=getProc(hh,'ippiYCCToRGB_16u_C3R');
  ippiRGBToYCC_16u_AC4R:=getProc(hh,'ippiRGBToYCC_16u_AC4R');
  ippiYCCToRGB_16u_AC4R:=getProc(hh,'ippiYCCToRGB_16u_AC4R');
  ippiRGBToYCC_16s_C3R:=getProc(hh,'ippiRGBToYCC_16s_C3R');
  ippiYCCToRGB_16s_C3R:=getProc(hh,'ippiYCCToRGB_16s_C3R');
  ippiRGBToYCC_16s_AC4R:=getProc(hh,'ippiRGBToYCC_16s_AC4R');
  ippiYCCToRGB_16s_AC4R:=getProc(hh,'ippiYCCToRGB_16s_AC4R');
  ippiRGBToYCC_32f_C3R:=getProc(hh,'ippiRGBToYCC_32f_C3R');
  ippiYCCToRGB_32f_C3R:=getProc(hh,'ippiYCCToRGB_32f_C3R');
  ippiRGBToYCC_32f_AC4R:=getProc(hh,'ippiRGBToYCC_32f_AC4R');
  ippiYCCToRGB_32f_AC4R:=getProc(hh,'ippiYCCToRGB_32f_AC4R');
  ippiRGBToXYZ_8u_C3R:=getProc(hh,'ippiRGBToXYZ_8u_C3R');
  ippiXYZToRGB_8u_C3R:=getProc(hh,'ippiXYZToRGB_8u_C3R');
  ippiRGBToXYZ_8u_AC4R:=getProc(hh,'ippiRGBToXYZ_8u_AC4R');
  ippiXYZToRGB_8u_AC4R:=getProc(hh,'ippiXYZToRGB_8u_AC4R');
  ippiRGBToXYZ_16u_C3R:=getProc(hh,'ippiRGBToXYZ_16u_C3R');
  ippiXYZToRGB_16u_C3R:=getProc(hh,'ippiXYZToRGB_16u_C3R');
  ippiRGBToXYZ_16u_AC4R:=getProc(hh,'ippiRGBToXYZ_16u_AC4R');
  ippiXYZToRGB_16u_AC4R:=getProc(hh,'ippiXYZToRGB_16u_AC4R');
  ippiRGBToXYZ_16s_C3R:=getProc(hh,'ippiRGBToXYZ_16s_C3R');
  ippiXYZToRGB_16s_C3R:=getProc(hh,'ippiXYZToRGB_16s_C3R');
  ippiRGBToXYZ_16s_AC4R:=getProc(hh,'ippiRGBToXYZ_16s_AC4R');
  ippiXYZToRGB_16s_AC4R:=getProc(hh,'ippiXYZToRGB_16s_AC4R');
  ippiRGBToXYZ_32f_C3R:=getProc(hh,'ippiRGBToXYZ_32f_C3R');
  ippiXYZToRGB_32f_C3R:=getProc(hh,'ippiXYZToRGB_32f_C3R');
  ippiRGBToXYZ_32f_AC4R:=getProc(hh,'ippiRGBToXYZ_32f_AC4R');
  ippiXYZToRGB_32f_AC4R:=getProc(hh,'ippiXYZToRGB_32f_AC4R');
  ippiRGBToLUV_8u_C3R:=getProc(hh,'ippiRGBToLUV_8u_C3R');
  ippiLUVToRGB_8u_C3R:=getProc(hh,'ippiLUVToRGB_8u_C3R');
  ippiRGBToLUV_8u_AC4R:=getProc(hh,'ippiRGBToLUV_8u_AC4R');
  ippiLUVToRGB_8u_AC4R:=getProc(hh,'ippiLUVToRGB_8u_AC4R');
  ippiRGBToLUV_16u_C3R:=getProc(hh,'ippiRGBToLUV_16u_C3R');
  ippiLUVToRGB_16u_C3R:=getProc(hh,'ippiLUVToRGB_16u_C3R');
  ippiRGBToLUV_16u_AC4R:=getProc(hh,'ippiRGBToLUV_16u_AC4R');
  ippiLUVToRGB_16u_AC4R:=getProc(hh,'ippiLUVToRGB_16u_AC4R');
  ippiRGBToLUV_16s_C3R:=getProc(hh,'ippiRGBToLUV_16s_C3R');
  ippiLUVToRGB_16s_C3R:=getProc(hh,'ippiLUVToRGB_16s_C3R');
  ippiRGBToLUV_16s_AC4R:=getProc(hh,'ippiRGBToLUV_16s_AC4R');
  ippiLUVToRGB_16s_AC4R:=getProc(hh,'ippiLUVToRGB_16s_AC4R');
  ippiRGBToLUV_32f_C3R:=getProc(hh,'ippiRGBToLUV_32f_C3R');
  ippiLUVToRGB_32f_C3R:=getProc(hh,'ippiLUVToRGB_32f_C3R');
  ippiRGBToLUV_32f_AC4R:=getProc(hh,'ippiRGBToLUV_32f_AC4R');
  ippiLUVToRGB_32f_AC4R:=getProc(hh,'ippiLUVToRGB_32f_AC4R');
  ippiReduceBits_8u_C1R:=getProc(hh,'ippiReduceBits_8u_C1R');
  ippiReduceBits_8u_C3R:=getProc(hh,'ippiReduceBits_8u_C3R');
  ippiReduceBits_8u_AC4R:=getProc(hh,'ippiReduceBits_8u_AC4R');
  ippiReduceBits_8u_C4R:=getProc(hh,'ippiReduceBits_8u_C4R');
  ippiReduceBits_16u_C1R:=getProc(hh,'ippiReduceBits_16u_C1R');
  ippiReduceBits_16u_C3R:=getProc(hh,'ippiReduceBits_16u_C3R');
  ippiReduceBits_16u_AC4R:=getProc(hh,'ippiReduceBits_16u_AC4R');
  ippiReduceBits_16u_C4R:=getProc(hh,'ippiReduceBits_16u_C4R');
  ippiReduceBits_16u8u_C1R:=getProc(hh,'ippiReduceBits_16u8u_C1R');
  ippiReduceBits_16u8u_C3R:=getProc(hh,'ippiReduceBits_16u8u_C3R');
  ippiReduceBits_16u8u_AC4R:=getProc(hh,'ippiReduceBits_16u8u_AC4R');
  ippiReduceBits_16u8u_C4R:=getProc(hh,'ippiReduceBits_16u8u_C4R');
  ippiReduceBits_16s_C1R:=getProc(hh,'ippiReduceBits_16s_C1R');
  ippiReduceBits_16s_C3R:=getProc(hh,'ippiReduceBits_16s_C3R');
  ippiReduceBits_16s_AC4R:=getProc(hh,'ippiReduceBits_16s_AC4R');
  ippiReduceBits_16s_C4R:=getProc(hh,'ippiReduceBits_16s_C4R');
  ippiReduceBits_16s8u_C1R:=getProc(hh,'ippiReduceBits_16s8u_C1R');
  ippiReduceBits_16s8u_C3R:=getProc(hh,'ippiReduceBits_16s8u_C3R');
  ippiReduceBits_16s8u_AC4R:=getProc(hh,'ippiReduceBits_16s8u_AC4R');
  ippiReduceBits_16s8u_C4R:=getProc(hh,'ippiReduceBits_16s8u_C4R');
  ippiReduceBits_32f8u_C1R:=getProc(hh,'ippiReduceBits_32f8u_C1R');
  ippiReduceBits_32f8u_C3R:=getProc(hh,'ippiReduceBits_32f8u_C3R');
  ippiReduceBits_32f8u_AC4R:=getProc(hh,'ippiReduceBits_32f8u_AC4R');
  ippiReduceBits_32f8u_C4R:=getProc(hh,'ippiReduceBits_32f8u_C4R');
  ippiReduceBits_32f16u_C1R:=getProc(hh,'ippiReduceBits_32f16u_C1R');
  ippiReduceBits_32f16u_C3R:=getProc(hh,'ippiReduceBits_32f16u_C3R');
  ippiReduceBits_32f16u_AC4R:=getProc(hh,'ippiReduceBits_32f16u_AC4R');
  ippiReduceBits_32f16u_C4R:=getProc(hh,'ippiReduceBits_32f16u_C4R');
  ippiReduceBits_32f16s_C1R:=getProc(hh,'ippiReduceBits_32f16s_C1R');
  ippiReduceBits_32f16s_C3R:=getProc(hh,'ippiReduceBits_32f16s_C3R');
  ippiReduceBits_32f16s_AC4R:=getProc(hh,'ippiReduceBits_32f16s_AC4R');
  ippiReduceBits_32f16s_C4R:=getProc(hh,'ippiReduceBits_32f16s_C4R');
  ippiColorTwist32f_8u_C3R:=getProc(hh,'ippiColorTwist32f_8u_C3R');
  ippiColorTwist32f_8u_C3IR:=getProc(hh,'ippiColorTwist32f_8u_C3IR');
  ippiColorTwist32f_8u_AC4R:=getProc(hh,'ippiColorTwist32f_8u_AC4R');
  ippiColorTwist32f_8u_AC4IR:=getProc(hh,'ippiColorTwist32f_8u_AC4IR');
  ippiColorTwist32f_8u_P3R:=getProc(hh,'ippiColorTwist32f_8u_P3R');
  ippiColorTwist32f_8u_IP3R:=getProc(hh,'ippiColorTwist32f_8u_IP3R');
  ippiColorTwist32f_16u_C3R:=getProc(hh,'ippiColorTwist32f_16u_C3R');
  ippiColorTwist32f_16u_C3IR:=getProc(hh,'ippiColorTwist32f_16u_C3IR');
  ippiColorTwist32f_16u_AC4R:=getProc(hh,'ippiColorTwist32f_16u_AC4R');
  ippiColorTwist32f_16u_AC4IR:=getProc(hh,'ippiColorTwist32f_16u_AC4IR');
  ippiColorTwist32f_16u_P3R:=getProc(hh,'ippiColorTwist32f_16u_P3R');
  ippiColorTwist32f_16u_IP3R:=getProc(hh,'ippiColorTwist32f_16u_IP3R');
  ippiColorTwist32f_16s_C3R:=getProc(hh,'ippiColorTwist32f_16s_C3R');
  ippiColorTwist32f_16s_C3IR:=getProc(hh,'ippiColorTwist32f_16s_C3IR');
  ippiColorTwist32f_16s_AC4R:=getProc(hh,'ippiColorTwist32f_16s_AC4R');
  ippiColorTwist32f_16s_AC4IR:=getProc(hh,'ippiColorTwist32f_16s_AC4IR');
  ippiColorTwist32f_16s_P3R:=getProc(hh,'ippiColorTwist32f_16s_P3R');
  ippiColorTwist32f_16s_IP3R:=getProc(hh,'ippiColorTwist32f_16s_IP3R');
  ippiColorTwist_32f_C3R:=getProc(hh,'ippiColorTwist_32f_C3R');
  ippiColorTwist_32f_C3IR:=getProc(hh,'ippiColorTwist_32f_C3IR');
  ippiColorTwist_32f_AC4R:=getProc(hh,'ippiColorTwist_32f_AC4R');
  ippiColorTwist_32f_AC4IR:=getProc(hh,'ippiColorTwist_32f_AC4IR');
  ippiColorTwist_32f_P3R:=getProc(hh,'ippiColorTwist_32f_P3R');
  ippiColorTwist_32f_IP3R:=getProc(hh,'ippiColorTwist_32f_IP3R');
  ippiColorTwist_32f_C4R:=getProc(hh,'ippiColorTwist_32f_C4R');
  ippiGammaFwd_8u_C3R:=getProc(hh,'ippiGammaFwd_8u_C3R');
  ippiGammaFwd_8u_C3IR:=getProc(hh,'ippiGammaFwd_8u_C3IR');
  ippiGammaInv_8u_C3R:=getProc(hh,'ippiGammaInv_8u_C3R');
  ippiGammaInv_8u_C3IR:=getProc(hh,'ippiGammaInv_8u_C3IR');
  ippiGammaFwd_8u_AC4R:=getProc(hh,'ippiGammaFwd_8u_AC4R');
  ippiGammaFwd_8u_AC4IR:=getProc(hh,'ippiGammaFwd_8u_AC4IR');
  ippiGammaInv_8u_AC4R:=getProc(hh,'ippiGammaInv_8u_AC4R');
  ippiGammaInv_8u_AC4IR:=getProc(hh,'ippiGammaInv_8u_AC4IR');
  ippiGammaFwd_8u_P3R:=getProc(hh,'ippiGammaFwd_8u_P3R');
  ippiGammaFwd_8u_IP3R:=getProc(hh,'ippiGammaFwd_8u_IP3R');
  ippiGammaInv_8u_P3R:=getProc(hh,'ippiGammaInv_8u_P3R');
  ippiGammaInv_8u_IP3R:=getProc(hh,'ippiGammaInv_8u_IP3R');
  ippiGammaFwd_16u_C3R:=getProc(hh,'ippiGammaFwd_16u_C3R');
  ippiGammaFwd_16u_C3IR:=getProc(hh,'ippiGammaFwd_16u_C3IR');
  ippiGammaInv_16u_C3R:=getProc(hh,'ippiGammaInv_16u_C3R');
  ippiGammaInv_16u_C3IR:=getProc(hh,'ippiGammaInv_16u_C3IR');
  ippiGammaFwd_16u_AC4R:=getProc(hh,'ippiGammaFwd_16u_AC4R');
  ippiGammaFwd_16u_AC4IR:=getProc(hh,'ippiGammaFwd_16u_AC4IR');
  ippiGammaInv_16u_AC4R:=getProc(hh,'ippiGammaInv_16u_AC4R');
  ippiGammaInv_16u_AC4IR:=getProc(hh,'ippiGammaInv_16u_AC4IR');
  ippiGammaFwd_16u_P3R:=getProc(hh,'ippiGammaFwd_16u_P3R');
  ippiGammaFwd_16u_IP3R:=getProc(hh,'ippiGammaFwd_16u_IP3R');
  ippiGammaInv_16u_P3R:=getProc(hh,'ippiGammaInv_16u_P3R');
  ippiGammaInv_16u_IP3R:=getProc(hh,'ippiGammaInv_16u_IP3R');
  ippiGammaFwd_32f_C3R:=getProc(hh,'ippiGammaFwd_32f_C3R');
  ippiGammaFwd_32f_C3IR:=getProc(hh,'ippiGammaFwd_32f_C3IR');
  ippiGammaInv_32f_C3R:=getProc(hh,'ippiGammaInv_32f_C3R');
  ippiGammaInv_32f_C3IR:=getProc(hh,'ippiGammaInv_32f_C3IR');
  ippiGammaFwd_32f_AC4R:=getProc(hh,'ippiGammaFwd_32f_AC4R');
  ippiGammaFwd_32f_AC4IR:=getProc(hh,'ippiGammaFwd_32f_AC4IR');
  ippiGammaInv_32f_AC4R:=getProc(hh,'ippiGammaInv_32f_AC4R');
  ippiGammaInv_32f_AC4IR:=getProc(hh,'ippiGammaInv_32f_AC4IR');
  ippiGammaFwd_32f_P3R:=getProc(hh,'ippiGammaFwd_32f_P3R');
  ippiGammaFwd_32f_IP3R:=getProc(hh,'ippiGammaFwd_32f_IP3R');
  ippiGammaInv_32f_P3R:=getProc(hh,'ippiGammaInv_32f_P3R');
  ippiGammaInv_32f_IP3R:=getProc(hh,'ippiGammaInv_32f_IP3R');
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
  ippiRemap_8u_C1R:=getProc(hh,'ippiRemap_8u_C1R');
  ippiRemap_8u_C3R:=getProc(hh,'ippiRemap_8u_C3R');
  ippiRemap_8u_AC4R:=getProc(hh,'ippiRemap_8u_AC4R');
  ippiRemap_8u_P3R:=getProc(hh,'ippiRemap_8u_P3R');
  ippiRemap_32f_C1R:=getProc(hh,'ippiRemap_32f_C1R');
  ippiRemap_32f_C3R:=getProc(hh,'ippiRemap_32f_C3R');
  ippiRemap_32f_AC4R:=getProc(hh,'ippiRemap_32f_AC4R');
  ippiRemap_32f_P3R:=getProc(hh,'ippiRemap_32f_P3R');
  ippiRemap_8u_C4R:=getProc(hh,'ippiRemap_8u_C4R');
  ippiRemap_8u_P4R:=getProc(hh,'ippiRemap_8u_P4R');
  ippiRemap_32f_C4R:=getProc(hh,'ippiRemap_32f_C4R');
  ippiRemap_32f_P4R:=getProc(hh,'ippiRemap_32f_P4R');
  ippiResize_8u_C1R:=getProc(hh,'ippiResize_8u_C1R');
  ippiResize_8u_C3R:=getProc(hh,'ippiResize_8u_C3R');
  ippiResize_8u_C4R:=getProc(hh,'ippiResize_8u_C4R');
  ippiResize_8u_AC4R:=getProc(hh,'ippiResize_8u_AC4R');
  ippiResize_8u_P3R:=getProc(hh,'ippiResize_8u_P3R');
  ippiResize_8u_P4R:=getProc(hh,'ippiResize_8u_P4R');
  ippiResize_16u_C1R:=getProc(hh,'ippiResize_16u_C1R');
  ippiResize_16u_C3R:=getProc(hh,'ippiResize_16u_C3R');
  ippiResize_16u_C4R:=getProc(hh,'ippiResize_16u_C4R');
  ippiResize_16u_AC4R:=getProc(hh,'ippiResize_16u_AC4R');
  ippiResize_16u_P3R:=getProc(hh,'ippiResize_16u_P3R');
  ippiResize_16u_P4R:=getProc(hh,'ippiResize_16u_P4R');
  ippiResize_32f_C1R:=getProc(hh,'ippiResize_32f_C1R');
  ippiResize_32f_C3R:=getProc(hh,'ippiResize_32f_C3R');
  ippiResize_32f_C4R:=getProc(hh,'ippiResize_32f_C4R');
  ippiResize_32f_AC4R:=getProc(hh,'ippiResize_32f_AC4R');
  ippiResize_32f_P3R:=getProc(hh,'ippiResize_32f_P3R');
  ippiResize_32f_P4R:=getProc(hh,'ippiResize_32f_P4R');
  ippiResizeCenter_8u_C1R:=getProc(hh,'ippiResizeCenter_8u_C1R');
  ippiResizeCenter_8u_C3R:=getProc(hh,'ippiResizeCenter_8u_C3R');
  ippiResizeCenter_8u_C4R:=getProc(hh,'ippiResizeCenter_8u_C4R');
  ippiResizeCenter_8u_AC4R:=getProc(hh,'ippiResizeCenter_8u_AC4R');
  ippiResizeCenter_8u_P3R:=getProc(hh,'ippiResizeCenter_8u_P3R');
  ippiResizeCenter_8u_P4R:=getProc(hh,'ippiResizeCenter_8u_P4R');
  ippiResizeCenter_16u_C1R:=getProc(hh,'ippiResizeCenter_16u_C1R');
  ippiResizeCenter_16u_C3R:=getProc(hh,'ippiResizeCenter_16u_C3R');
  ippiResizeCenter_16u_C4R:=getProc(hh,'ippiResizeCenter_16u_C4R');
  ippiResizeCenter_16u_AC4R:=getProc(hh,'ippiResizeCenter_16u_AC4R');
  ippiResizeCenter_16u_P3R:=getProc(hh,'ippiResizeCenter_16u_P3R');
  ippiResizeCenter_16u_P4R:=getProc(hh,'ippiResizeCenter_16u_P4R');
  ippiResizeCenter_32f_C1R:=getProc(hh,'ippiResizeCenter_32f_C1R');
  ippiResizeCenter_32f_C3R:=getProc(hh,'ippiResizeCenter_32f_C3R');
  ippiResizeCenter_32f_C4R:=getProc(hh,'ippiResizeCenter_32f_C4R');
  ippiResizeCenter_32f_AC4R:=getProc(hh,'ippiResizeCenter_32f_AC4R');
  ippiResizeCenter_32f_P3R:=getProc(hh,'ippiResizeCenter_32f_P3R');
  ippiResizeCenter_32f_P4R:=getProc(hh,'ippiResizeCenter_32f_P4R');
  ippiGetResizeFract:=getProc(hh,'ippiGetResizeFract');
  ippiResizeShift_8u_C1R:=getProc(hh,'ippiResizeShift_8u_C1R');
  ippiResizeShift_8u_C3R:=getProc(hh,'ippiResizeShift_8u_C3R');
  ippiResizeShift_8u_C4R:=getProc(hh,'ippiResizeShift_8u_C4R');
  ippiResizeShift_8u_AC4R:=getProc(hh,'ippiResizeShift_8u_AC4R');
  ippiResizeShift_8u_P3R:=getProc(hh,'ippiResizeShift_8u_P3R');
  ippiResizeShift_8u_P4R:=getProc(hh,'ippiResizeShift_8u_P4R');
  ippiResizeShift_16u_C1R:=getProc(hh,'ippiResizeShift_16u_C1R');
  ippiResizeShift_16u_C3R:=getProc(hh,'ippiResizeShift_16u_C3R');
  ippiResizeShift_16u_C4R:=getProc(hh,'ippiResizeShift_16u_C4R');
  ippiResizeShift_16u_AC4R:=getProc(hh,'ippiResizeShift_16u_AC4R');
  ippiResizeShift_16u_P3R:=getProc(hh,'ippiResizeShift_16u_P3R');
  ippiResizeShift_16u_P4R:=getProc(hh,'ippiResizeShift_16u_P4R');
  ippiResizeShift_32f_C1R:=getProc(hh,'ippiResizeShift_32f_C1R');
  ippiResizeShift_32f_C3R:=getProc(hh,'ippiResizeShift_32f_C3R');
  ippiResizeShift_32f_C4R:=getProc(hh,'ippiResizeShift_32f_C4R');
  ippiResizeShift_32f_AC4R:=getProc(hh,'ippiResizeShift_32f_AC4R');
  ippiResizeShift_32f_P3R:=getProc(hh,'ippiResizeShift_32f_P3R');
  ippiResizeShift_32f_P4R:=getProc(hh,'ippiResizeShift_32f_P4R');
  ippiGetAffineBound:=getProc(hh,'ippiGetAffineBound');
  ippiGetAffineQuad:=getProc(hh,'ippiGetAffineQuad');
  ippiGetAffineTransform:=getProc(hh,'ippiGetAffineTransform');
  ippiWarpAffine_8u_C1R:=getProc(hh,'ippiWarpAffine_8u_C1R');
  ippiWarpAffine_8u_C3R:=getProc(hh,'ippiWarpAffine_8u_C3R');
  ippiWarpAffine_8u_AC4R:=getProc(hh,'ippiWarpAffine_8u_AC4R');
  ippiWarpAffine_8u_P3R:=getProc(hh,'ippiWarpAffine_8u_P3R');
  ippiWarpAffine_32f_C1R:=getProc(hh,'ippiWarpAffine_32f_C1R');
  ippiWarpAffine_32f_C3R:=getProc(hh,'ippiWarpAffine_32f_C3R');
  ippiWarpAffine_32f_AC4R:=getProc(hh,'ippiWarpAffine_32f_AC4R');
  ippiWarpAffine_32f_P3R:=getProc(hh,'ippiWarpAffine_32f_P3R');
  ippiWarpAffine_8u_C4R:=getProc(hh,'ippiWarpAffine_8u_C4R');
  ippiWarpAffine_8u_P4R:=getProc(hh,'ippiWarpAffine_8u_P4R');
  ippiWarpAffine_32f_C4R:=getProc(hh,'ippiWarpAffine_32f_C4R');
  ippiWarpAffine_32f_P4R:=getProc(hh,'ippiWarpAffine_32f_P4R');
  ippiWarpAffineBack_8u_C1R:=getProc(hh,'ippiWarpAffineBack_8u_C1R');
  ippiWarpAffineBack_8u_C3R:=getProc(hh,'ippiWarpAffineBack_8u_C3R');
  ippiWarpAffineBack_8u_AC4R:=getProc(hh,'ippiWarpAffineBack_8u_AC4R');
  ippiWarpAffineBack_8u_P3R:=getProc(hh,'ippiWarpAffineBack_8u_P3R');
  ippiWarpAffineBack_32f_C1R:=getProc(hh,'ippiWarpAffineBack_32f_C1R');
  ippiWarpAffineBack_32f_C3R:=getProc(hh,'ippiWarpAffineBack_32f_C3R');
  ippiWarpAffineBack_32f_AC4R:=getProc(hh,'ippiWarpAffineBack_32f_AC4R');
  ippiWarpAffineBack_32f_P3R:=getProc(hh,'ippiWarpAffineBack_32f_P3R');
  ippiWarpAffineBack_8u_C4R:=getProc(hh,'ippiWarpAffineBack_8u_C4R');
  ippiWarpAffineBack_8u_P4R:=getProc(hh,'ippiWarpAffineBack_8u_P4R');
  ippiWarpAffineBack_32f_C4R:=getProc(hh,'ippiWarpAffineBack_32f_C4R');
  ippiWarpAffineBack_32f_P4R:=getProc(hh,'ippiWarpAffineBack_32f_P4R');
  ippiWarpAffineQuad_8u_C1R:=getProc(hh,'ippiWarpAffineQuad_8u_C1R');
  ippiWarpAffineQuad_8u_C3R:=getProc(hh,'ippiWarpAffineQuad_8u_C3R');
  ippiWarpAffineQuad_8u_AC4R:=getProc(hh,'ippiWarpAffineQuad_8u_AC4R');
  ippiWarpAffineQuad_8u_P3R:=getProc(hh,'ippiWarpAffineQuad_8u_P3R');
  ippiWarpAffineQuad_32f_C1R:=getProc(hh,'ippiWarpAffineQuad_32f_C1R');
  ippiWarpAffineQuad_32f_C3R:=getProc(hh,'ippiWarpAffineQuad_32f_C3R');
  ippiWarpAffineQuad_32f_AC4R:=getProc(hh,'ippiWarpAffineQuad_32f_AC4R');
  ippiWarpAffineQuad_32f_P3R:=getProc(hh,'ippiWarpAffineQuad_32f_P3R');
  ippiWarpAffineQuad_8u_C4R:=getProc(hh,'ippiWarpAffineQuad_8u_C4R');
  ippiWarpAffineQuad_8u_P4R:=getProc(hh,'ippiWarpAffineQuad_8u_P4R');
  ippiWarpAffineQuad_32f_C4R:=getProc(hh,'ippiWarpAffineQuad_32f_C4R');
  ippiWarpAffineQuad_32f_P4R:=getProc(hh,'ippiWarpAffineQuad_32f_P4R');
  ippiRotate_8u_C1R:=getProc(hh,'ippiRotate_8u_C1R');
  ippiRotate_8u_C3R:=getProc(hh,'ippiRotate_8u_C3R');
  ippiRotate_8u_AC4R:=getProc(hh,'ippiRotate_8u_AC4R');
  ippiRotate_8u_P3R:=getProc(hh,'ippiRotate_8u_P3R');
  ippiRotate_8u_C4R:=getProc(hh,'ippiRotate_8u_C4R');
  ippiRotate_8u_P4R:=getProc(hh,'ippiRotate_8u_P4R');
  ippiRotate_32f_C1R:=getProc(hh,'ippiRotate_32f_C1R');
  ippiRotate_32f_C3R:=getProc(hh,'ippiRotate_32f_C3R');
  ippiRotate_32f_AC4R:=getProc(hh,'ippiRotate_32f_AC4R');
  ippiRotate_32f_P3R:=getProc(hh,'ippiRotate_32f_P3R');
  ippiRotate_32f_C4R:=getProc(hh,'ippiRotate_32f_C4R');
  ippiRotate_32f_P4R:=getProc(hh,'ippiRotate_32f_P4R');
  ippiRotate_16u_C1R:=getProc(hh,'ippiRotate_16u_C1R');
  ippiRotate_16u_C3R:=getProc(hh,'ippiRotate_16u_C3R');
  ippiRotate_16u_AC4R:=getProc(hh,'ippiRotate_16u_AC4R');
  ippiRotate_16u_P3R:=getProc(hh,'ippiRotate_16u_P3R');
  ippiRotate_16u_C4R:=getProc(hh,'ippiRotate_16u_C4R');
  ippiRotate_16u_P4R:=getProc(hh,'ippiRotate_16u_P4R');
  ippiAddRotateShift:=getProc(hh,'ippiAddRotateShift');
  ippiGetRotateShift:=getProc(hh,'ippiGetRotateShift');
  ippiGetRotateQuad:=getProc(hh,'ippiGetRotateQuad');
  ippiGetRotateBound:=getProc(hh,'ippiGetRotateBound');
  ippiRotateCenter_8u_C1R:=getProc(hh,'ippiRotateCenter_8u_C1R');
  ippiRotateCenter_8u_C3R:=getProc(hh,'ippiRotateCenter_8u_C3R');
  ippiRotateCenter_8u_AC4R:=getProc(hh,'ippiRotateCenter_8u_AC4R');
  ippiRotateCenter_8u_P3R:=getProc(hh,'ippiRotateCenter_8u_P3R');
  ippiRotateCenter_8u_C4R:=getProc(hh,'ippiRotateCenter_8u_C4R');
  ippiRotateCenter_8u_P4R:=getProc(hh,'ippiRotateCenter_8u_P4R');
  ippiRotateCenter_32f_C1R:=getProc(hh,'ippiRotateCenter_32f_C1R');
  ippiRotateCenter_32f_C3R:=getProc(hh,'ippiRotateCenter_32f_C3R');
  ippiRotateCenter_32f_AC4R:=getProc(hh,'ippiRotateCenter_32f_AC4R');
  ippiRotateCenter_32f_P3R:=getProc(hh,'ippiRotateCenter_32f_P3R');
  ippiRotateCenter_32f_C4R:=getProc(hh,'ippiRotateCenter_32f_C4R');
  ippiRotateCenter_32f_P4R:=getProc(hh,'ippiRotateCenter_32f_P4R');
  ippiRotateCenter_16u_C1R:=getProc(hh,'ippiRotateCenter_16u_C1R');
  ippiRotateCenter_16u_C3R:=getProc(hh,'ippiRotateCenter_16u_C3R');
  ippiRotateCenter_16u_AC4R:=getProc(hh,'ippiRotateCenter_16u_AC4R');
  ippiRotateCenter_16u_P3R:=getProc(hh,'ippiRotateCenter_16u_P3R');
  ippiRotateCenter_16u_C4R:=getProc(hh,'ippiRotateCenter_16u_C4R');
  ippiRotateCenter_16u_P4R:=getProc(hh,'ippiRotateCenter_16u_P4R');
  ippiShear_8u_C1R:=getProc(hh,'ippiShear_8u_C1R');
  ippiShear_8u_C3R:=getProc(hh,'ippiShear_8u_C3R');
  ippiShear_8u_AC4R:=getProc(hh,'ippiShear_8u_AC4R');
  ippiShear_8u_P3R:=getProc(hh,'ippiShear_8u_P3R');
  ippiShear_8u_C4R:=getProc(hh,'ippiShear_8u_C4R');
  ippiShear_8u_P4R:=getProc(hh,'ippiShear_8u_P4R');
  ippiShear_32f_C1R:=getProc(hh,'ippiShear_32f_C1R');
  ippiShear_32f_C3R:=getProc(hh,'ippiShear_32f_C3R');
  ippiShear_32f_AC4R:=getProc(hh,'ippiShear_32f_AC4R');
  ippiShear_32f_P3R:=getProc(hh,'ippiShear_32f_P3R');
  ippiShear_32f_C4R:=getProc(hh,'ippiShear_32f_C4R');
  ippiShear_32f_P4R:=getProc(hh,'ippiShear_32f_P4R');
  ippiGetShearQuad:=getProc(hh,'ippiGetShearQuad');
  ippiGetShearBound:=getProc(hh,'ippiGetShearBound');
  ippiGetPerspectiveBound:=getProc(hh,'ippiGetPerspectiveBound');
  ippiGetPerspectiveQuad:=getProc(hh,'ippiGetPerspectiveQuad');
  ippiGetPerspectiveTransform:=getProc(hh,'ippiGetPerspectiveTransform');
  ippiWarpPerspective_8u_C1R:=getProc(hh,'ippiWarpPerspective_8u_C1R');
  ippiWarpPerspective_8u_C3R:=getProc(hh,'ippiWarpPerspective_8u_C3R');
  ippiWarpPerspective_8u_AC4R:=getProc(hh,'ippiWarpPerspective_8u_AC4R');
  ippiWarpPerspective_8u_P3R:=getProc(hh,'ippiWarpPerspective_8u_P3R');
  ippiWarpPerspective_8u_C4R:=getProc(hh,'ippiWarpPerspective_8u_C4R');
  ippiWarpPerspective_8u_P4R:=getProc(hh,'ippiWarpPerspective_8u_P4R');
  ippiWarpPerspective_32f_C1R:=getProc(hh,'ippiWarpPerspective_32f_C1R');
  ippiWarpPerspective_32f_C3R:=getProc(hh,'ippiWarpPerspective_32f_C3R');
  ippiWarpPerspective_32f_AC4R:=getProc(hh,'ippiWarpPerspective_32f_AC4R');
  ippiWarpPerspective_32f_P3R:=getProc(hh,'ippiWarpPerspective_32f_P3R');
  ippiWarpPerspective_32f_C4R:=getProc(hh,'ippiWarpPerspective_32f_C4R');
  ippiWarpPerspective_32f_P4R:=getProc(hh,'ippiWarpPerspective_32f_P4R');
  ippiWarpPerspectiveBack_8u_C1R:=getProc(hh,'ippiWarpPerspectiveBack_8u_C1R');
  ippiWarpPerspectiveBack_8u_C3R:=getProc(hh,'ippiWarpPerspectiveBack_8u_C3R');
  ippiWarpPerspectiveBack_8u_AC4R:=getProc(hh,'ippiWarpPerspectiveBack_8u_AC4R');
  ippiWarpPerspectiveBack_8u_P3R:=getProc(hh,'ippiWarpPerspectiveBack_8u_P3R');
  ippiWarpPerspectiveBack_8u_C4R:=getProc(hh,'ippiWarpPerspectiveBack_8u_C4R');
  ippiWarpPerspectiveBack_8u_P4R:=getProc(hh,'ippiWarpPerspectiveBack_8u_P4R');
  ippiWarpPerspectiveBack_32f_C1R:=getProc(hh,'ippiWarpPerspectiveBack_32f_C1R');
  ippiWarpPerspectiveBack_32f_C3R:=getProc(hh,'ippiWarpPerspectiveBack_32f_C3R');
  ippiWarpPerspectiveBack_32f_AC4R:=getProc(hh,'ippiWarpPerspectiveBack_32f_AC4R');
  ippiWarpPerspectiveBack_32f_P3R:=getProc(hh,'ippiWarpPerspectiveBack_32f_P3R');
  ippiWarpPerspectiveBack_32f_C4R:=getProc(hh,'ippiWarpPerspectiveBack_32f_C4R');
  ippiWarpPerspectiveBack_32f_P4R:=getProc(hh,'ippiWarpPerspectiveBack_32f_P4R');
  ippiWarpPerspectiveQuad_8u_C1R:=getProc(hh,'ippiWarpPerspectiveQuad_8u_C1R');
  ippiWarpPerspectiveQuad_8u_C3R:=getProc(hh,'ippiWarpPerspectiveQuad_8u_C3R');
  ippiWarpPerspectiveQuad_8u_AC4R:=getProc(hh,'ippiWarpPerspectiveQuad_8u_AC4R');
  ippiWarpPerspectiveQuad_8u_P3R:=getProc(hh,'ippiWarpPerspectiveQuad_8u_P3R');
  ippiWarpPerspectiveQuad_8u_C4R:=getProc(hh,'ippiWarpPerspectiveQuad_8u_C4R');
  ippiWarpPerspectiveQuad_8u_P4R:=getProc(hh,'ippiWarpPerspectiveQuad_8u_P4R');
  ippiWarpPerspectiveQuad_32f_C1R:=getProc(hh,'ippiWarpPerspectiveQuad_32f_C1R');
  ippiWarpPerspectiveQuad_32f_C3R:=getProc(hh,'ippiWarpPerspectiveQuad_32f_C3R');
  ippiWarpPerspectiveQuad_32f_AC4R:=getProc(hh,'ippiWarpPerspectiveQuad_32f_AC4R');
  ippiWarpPerspectiveQuad_32f_P3R:=getProc(hh,'ippiWarpPerspectiveQuad_32f_P3R');
  ippiWarpPerspectiveQuad_32f_C4R:=getProc(hh,'ippiWarpPerspectiveQuad_32f_C4R');
  ippiWarpPerspectiveQuad_32f_P4R:=getProc(hh,'ippiWarpPerspectiveQuad_32f_P4R');
  ippiGetBilinearBound:=getProc(hh,'ippiGetBilinearBound');
  ippiGetBilinearQuad:=getProc(hh,'ippiGetBilinearQuad');
  ippiGetBilinearTransform:=getProc(hh,'ippiGetBilinearTransform');
  ippiWarpBilinear_8u_C1R:=getProc(hh,'ippiWarpBilinear_8u_C1R');
  ippiWarpBilinear_8u_C3R:=getProc(hh,'ippiWarpBilinear_8u_C3R');
  ippiWarpBilinear_8u_AC4R:=getProc(hh,'ippiWarpBilinear_8u_AC4R');
  ippiWarpBilinear_8u_P3R:=getProc(hh,'ippiWarpBilinear_8u_P3R');
  ippiWarpBilinear_8u_C4R:=getProc(hh,'ippiWarpBilinear_8u_C4R');
  ippiWarpBilinear_8u_P4R:=getProc(hh,'ippiWarpBilinear_8u_P4R');
  ippiWarpBilinear_32f_C1R:=getProc(hh,'ippiWarpBilinear_32f_C1R');
  ippiWarpBilinear_32f_C3R:=getProc(hh,'ippiWarpBilinear_32f_C3R');
  ippiWarpBilinear_32f_AC4R:=getProc(hh,'ippiWarpBilinear_32f_AC4R');
  ippiWarpBilinear_32f_P3R:=getProc(hh,'ippiWarpBilinear_32f_P3R');
  ippiWarpBilinear_32f_C4R:=getProc(hh,'ippiWarpBilinear_32f_C4R');
  ippiWarpBilinear_32f_P4R:=getProc(hh,'ippiWarpBilinear_32f_P4R');
  ippiWarpBilinearBack_8u_C1R:=getProc(hh,'ippiWarpBilinearBack_8u_C1R');
  ippiWarpBilinearBack_8u_C3R:=getProc(hh,'ippiWarpBilinearBack_8u_C3R');
  ippiWarpBilinearBack_8u_AC4R:=getProc(hh,'ippiWarpBilinearBack_8u_AC4R');
  ippiWarpBilinearBack_8u_P3R:=getProc(hh,'ippiWarpBilinearBack_8u_P3R');
  ippiWarpBilinearBack_8u_C4R:=getProc(hh,'ippiWarpBilinearBack_8u_C4R');
  ippiWarpBilinearBack_8u_P4R:=getProc(hh,'ippiWarpBilinearBack_8u_P4R');
  ippiWarpBilinearBack_32f_C1R:=getProc(hh,'ippiWarpBilinearBack_32f_C1R');
  ippiWarpBilinearBack_32f_C3R:=getProc(hh,'ippiWarpBilinearBack_32f_C3R');
  ippiWarpBilinearBack_32f_AC4R:=getProc(hh,'ippiWarpBilinearBack_32f_AC4R');
  ippiWarpBilinearBack_32f_P3R:=getProc(hh,'ippiWarpBilinearBack_32f_P3R');
  ippiWarpBilinearBack_32f_C4R:=getProc(hh,'ippiWarpBilinearBack_32f_C4R');
  ippiWarpBilinearBack_32f_P4R:=getProc(hh,'ippiWarpBilinearBack_32f_P4R');
  ippiWarpBilinearQuad_8u_C1R:=getProc(hh,'ippiWarpBilinearQuad_8u_C1R');
  ippiWarpBilinearQuad_8u_C3R:=getProc(hh,'ippiWarpBilinearQuad_8u_C3R');
  ippiWarpBilinearQuad_8u_AC4R:=getProc(hh,'ippiWarpBilinearQuad_8u_AC4R');
  ippiWarpBilinearQuad_8u_P3R:=getProc(hh,'ippiWarpBilinearQuad_8u_P3R');
  ippiWarpBilinearQuad_8u_C4R:=getProc(hh,'ippiWarpBilinearQuad_8u_C4R');
  ippiWarpBilinearQuad_8u_P4R:=getProc(hh,'ippiWarpBilinearQuad_8u_P4R');
  ippiWarpBilinearQuad_32f_C1R:=getProc(hh,'ippiWarpBilinearQuad_32f_C1R');
  ippiWarpBilinearQuad_32f_C3R:=getProc(hh,'ippiWarpBilinearQuad_32f_C3R');
  ippiWarpBilinearQuad_32f_AC4R:=getProc(hh,'ippiWarpBilinearQuad_32f_AC4R');
  ippiWarpBilinearQuad_32f_P3R:=getProc(hh,'ippiWarpBilinearQuad_32f_P3R');
  ippiWarpBilinearQuad_32f_C4R:=getProc(hh,'ippiWarpBilinearQuad_32f_C4R');
  ippiWarpBilinearQuad_32f_P4R:=getProc(hh,'ippiWarpBilinearQuad_32f_P4R');
  ippiMomentInitAlloc_64f:=getProc(hh,'ippiMomentInitAlloc_64f');
  ippiMomentInitAlloc_64s:=getProc(hh,'ippiMomentInitAlloc_64s');
  ippiMomentFree_64f:=getProc(hh,'ippiMomentFree_64f');
  ippiMomentFree_64s:=getProc(hh,'ippiMomentFree_64s');
  ippiMomentGetStateSize_64s:=getProc(hh,'ippiMomentGetStateSize_64s');
  ippiMomentInit_64s:=getProc(hh,'ippiMomentInit_64s');
  ippiMoments64f_8u_C1R:=getProc(hh,'ippiMoments64f_8u_C1R');
  ippiMoments64f_8u_C3R:=getProc(hh,'ippiMoments64f_8u_C3R');
  ippiMoments64f_8u_AC4R:=getProc(hh,'ippiMoments64f_8u_AC4R');
  ippiMoments64f_32f_C1R:=getProc(hh,'ippiMoments64f_32f_C1R');
  ippiMoments64f_32f_C3R:=getProc(hh,'ippiMoments64f_32f_C3R');
  ippiMoments64f_32f_AC4R:=getProc(hh,'ippiMoments64f_32f_AC4R');
  ippiMoments64s_8u_C1R:=getProc(hh,'ippiMoments64s_8u_C1R');
  ippiMoments64s_8u_C3R:=getProc(hh,'ippiMoments64s_8u_C3R');
  ippiMoments64s_8u_AC4R:=getProc(hh,'ippiMoments64s_8u_AC4R');
  ippiGetSpatialMoment_64f:=getProc(hh,'ippiGetSpatialMoment_64f');
  ippiGetCentralMoment_64f:=getProc(hh,'ippiGetCentralMoment_64f');
  ippiGetSpatialMoment_64s:=getProc(hh,'ippiGetSpatialMoment_64s');
  ippiGetCentralMoment_64s:=getProc(hh,'ippiGetCentralMoment_64s');
  ippiGetNormalizedSpatialMoment_64f:=getProc(hh,'ippiGetNormalizedSpatialMoment_64f');
  ippiGetNormalizedCentralMoment_64f:=getProc(hh,'ippiGetNormalizedCentralMoment_64f');
  ippiGetNormalizedSpatialMoment_64s:=getProc(hh,'ippiGetNormalizedSpatialMoment_64s');
  ippiGetNormalizedCentralMoment_64s:=getProc(hh,'ippiGetNormalizedCentralMoment_64s');
  ippiGetHuMoments_64f:=getProc(hh,'ippiGetHuMoments_64f');
  ippiGetHuMoments_64s:=getProc(hh,'ippiGetHuMoments_64s');
end;

procedure Init3;
begin
  ippiNorm_Inf_8u_C1R:=getProc(hh,'ippiNorm_Inf_8u_C1R');
  ippiNorm_Inf_8u_C3R:=getProc(hh,'ippiNorm_Inf_8u_C3R');
  ippiNorm_Inf_8u_AC4R:=getProc(hh,'ippiNorm_Inf_8u_AC4R');
  ippiNorm_Inf_8u_C4R:=getProc(hh,'ippiNorm_Inf_8u_C4R');
  ippiNorm_Inf_16s_C1R:=getProc(hh,'ippiNorm_Inf_16s_C1R');
  ippiNorm_Inf_16s_C3R:=getProc(hh,'ippiNorm_Inf_16s_C3R');
  ippiNorm_Inf_16s_AC4R:=getProc(hh,'ippiNorm_Inf_16s_AC4R');
  ippiNorm_Inf_16s_C4R:=getProc(hh,'ippiNorm_Inf_16s_C4R');
  ippiNorm_Inf_32s_C1R:=getProc(hh,'ippiNorm_Inf_32s_C1R');
  ippiNorm_Inf_32f_C1R:=getProc(hh,'ippiNorm_Inf_32f_C1R');
  ippiNorm_Inf_32f_C3R:=getProc(hh,'ippiNorm_Inf_32f_C3R');
  ippiNorm_Inf_32f_AC4R:=getProc(hh,'ippiNorm_Inf_32f_AC4R');
  ippiNorm_Inf_32f_C4R:=getProc(hh,'ippiNorm_Inf_32f_C4R');
  ippiNorm_L1_8u_C1R:=getProc(hh,'ippiNorm_L1_8u_C1R');
  ippiNorm_L1_8u_C3R:=getProc(hh,'ippiNorm_L1_8u_C3R');
  ippiNorm_L1_8u_AC4R:=getProc(hh,'ippiNorm_L1_8u_AC4R');
  ippiNorm_L1_8u_C4R:=getProc(hh,'ippiNorm_L1_8u_C4R');
  ippiNorm_L1_16s_C1R:=getProc(hh,'ippiNorm_L1_16s_C1R');
  ippiNorm_L1_16s_C3R:=getProc(hh,'ippiNorm_L1_16s_C3R');
  ippiNorm_L1_16s_AC4R:=getProc(hh,'ippiNorm_L1_16s_AC4R');
  ippiNorm_L1_16s_C4R:=getProc(hh,'ippiNorm_L1_16s_C4R');
  ippiNorm_L1_32f_C1R:=getProc(hh,'ippiNorm_L1_32f_C1R');
  ippiNorm_L1_32f_C3R:=getProc(hh,'ippiNorm_L1_32f_C3R');
  ippiNorm_L1_32f_AC4R:=getProc(hh,'ippiNorm_L1_32f_AC4R');
  ippiNorm_L1_32f_C4R:=getProc(hh,'ippiNorm_L1_32f_C4R');
  ippiNorm_L2_8u_C1R:=getProc(hh,'ippiNorm_L2_8u_C1R');
  ippiNorm_L2_8u_C3R:=getProc(hh,'ippiNorm_L2_8u_C3R');
  ippiNorm_L2_8u_AC4R:=getProc(hh,'ippiNorm_L2_8u_AC4R');
  ippiNorm_L2_8u_C4R:=getProc(hh,'ippiNorm_L2_8u_C4R');
  ippiNorm_L2_16s_C1R:=getProc(hh,'ippiNorm_L2_16s_C1R');
  ippiNorm_L2_16s_C3R:=getProc(hh,'ippiNorm_L2_16s_C3R');
  ippiNorm_L2_16s_AC4R:=getProc(hh,'ippiNorm_L2_16s_AC4R');
  ippiNorm_L2_16s_C4R:=getProc(hh,'ippiNorm_L2_16s_C4R');
  ippiNorm_L2_32f_C1R:=getProc(hh,'ippiNorm_L2_32f_C1R');
  ippiNorm_L2_32f_C3R:=getProc(hh,'ippiNorm_L2_32f_C3R');
  ippiNorm_L2_32f_AC4R:=getProc(hh,'ippiNorm_L2_32f_AC4R');
  ippiNorm_L2_32f_C4R:=getProc(hh,'ippiNorm_L2_32f_C4R');
  ippiNormDiff_Inf_8u_C1R:=getProc(hh,'ippiNormDiff_Inf_8u_C1R');
  ippiNormDiff_Inf_8u_C3R:=getProc(hh,'ippiNormDiff_Inf_8u_C3R');
  ippiNormDiff_Inf_8u_AC4R:=getProc(hh,'ippiNormDiff_Inf_8u_AC4R');
  ippiNormDiff_Inf_8u_C4R:=getProc(hh,'ippiNormDiff_Inf_8u_C4R');
  ippiNormDiff_Inf_16s_C1R:=getProc(hh,'ippiNormDiff_Inf_16s_C1R');
  ippiNormDiff_Inf_16s_C3R:=getProc(hh,'ippiNormDiff_Inf_16s_C3R');
  ippiNormDiff_Inf_16s_AC4R:=getProc(hh,'ippiNormDiff_Inf_16s_AC4R');
  ippiNormDiff_Inf_16s_C4R:=getProc(hh,'ippiNormDiff_Inf_16s_C4R');
  ippiNormDiff_Inf_32f_C1R:=getProc(hh,'ippiNormDiff_Inf_32f_C1R');
  ippiNormDiff_Inf_32f_C3R:=getProc(hh,'ippiNormDiff_Inf_32f_C3R');
  ippiNormDiff_Inf_32f_AC4R:=getProc(hh,'ippiNormDiff_Inf_32f_AC4R');
  ippiNormDiff_Inf_32f_C4R:=getProc(hh,'ippiNormDiff_Inf_32f_C4R');
  ippiNormDiff_L1_8u_C1R:=getProc(hh,'ippiNormDiff_L1_8u_C1R');
  ippiNormDiff_L1_8u_C3R:=getProc(hh,'ippiNormDiff_L1_8u_C3R');
  ippiNormDiff_L1_8u_AC4R:=getProc(hh,'ippiNormDiff_L1_8u_AC4R');
  ippiNormDiff_L1_8u_C4R:=getProc(hh,'ippiNormDiff_L1_8u_C4R');
  ippiNormDiff_L1_16s_C1R:=getProc(hh,'ippiNormDiff_L1_16s_C1R');
  ippiNormDiff_L1_16s_C3R:=getProc(hh,'ippiNormDiff_L1_16s_C3R');
  ippiNormDiff_L1_16s_AC4R:=getProc(hh,'ippiNormDiff_L1_16s_AC4R');
  ippiNormDiff_L1_16s_C4R:=getProc(hh,'ippiNormDiff_L1_16s_C4R');
  ippiNormDiff_L1_32f_C1R:=getProc(hh,'ippiNormDiff_L1_32f_C1R');
  ippiNormDiff_L1_32f_C3R:=getProc(hh,'ippiNormDiff_L1_32f_C3R');
  ippiNormDiff_L1_32f_AC4R:=getProc(hh,'ippiNormDiff_L1_32f_AC4R');
  ippiNormDiff_L1_32f_C4R:=getProc(hh,'ippiNormDiff_L1_32f_C4R');
  ippiNormDiff_L2_8u_C1R:=getProc(hh,'ippiNormDiff_L2_8u_C1R');
  ippiNormDiff_L2_8u_C3R:=getProc(hh,'ippiNormDiff_L2_8u_C3R');
  ippiNormDiff_L2_8u_AC4R:=getProc(hh,'ippiNormDiff_L2_8u_AC4R');
  ippiNormDiff_L2_8u_C4R:=getProc(hh,'ippiNormDiff_L2_8u_C4R');
  ippiNormDiff_L2_16s_C1R:=getProc(hh,'ippiNormDiff_L2_16s_C1R');
  ippiNormDiff_L2_16s_C3R:=getProc(hh,'ippiNormDiff_L2_16s_C3R');
  ippiNormDiff_L2_16s_AC4R:=getProc(hh,'ippiNormDiff_L2_16s_AC4R');
  ippiNormDiff_L2_16s_C4R:=getProc(hh,'ippiNormDiff_L2_16s_C4R');
  ippiNormDiff_L2_32f_C1R:=getProc(hh,'ippiNormDiff_L2_32f_C1R');
  ippiNormDiff_L2_32f_C3R:=getProc(hh,'ippiNormDiff_L2_32f_C3R');
  ippiNormDiff_L2_32f_AC4R:=getProc(hh,'ippiNormDiff_L2_32f_AC4R');
  ippiNormDiff_L2_32f_C4R:=getProc(hh,'ippiNormDiff_L2_32f_C4R');
  ippiNormRel_Inf_8u_C1R:=getProc(hh,'ippiNormRel_Inf_8u_C1R');
  ippiNormRel_Inf_8u_C3R:=getProc(hh,'ippiNormRel_Inf_8u_C3R');
  ippiNormRel_Inf_8u_AC4R:=getProc(hh,'ippiNormRel_Inf_8u_AC4R');
  ippiNormRel_Inf_8u_C4R:=getProc(hh,'ippiNormRel_Inf_8u_C4R');
  ippiNormRel_Inf_16s_C1R:=getProc(hh,'ippiNormRel_Inf_16s_C1R');
  ippiNormRel_Inf_16s_C3R:=getProc(hh,'ippiNormRel_Inf_16s_C3R');
  ippiNormRel_Inf_16s_AC4R:=getProc(hh,'ippiNormRel_Inf_16s_AC4R');
  ippiNormRel_Inf_16s_C4R:=getProc(hh,'ippiNormRel_Inf_16s_C4R');
  ippiNormRel_Inf_32f_C1R:=getProc(hh,'ippiNormRel_Inf_32f_C1R');
  ippiNormRel_Inf_32f_C3R:=getProc(hh,'ippiNormRel_Inf_32f_C3R');
  ippiNormRel_Inf_32f_AC4R:=getProc(hh,'ippiNormRel_Inf_32f_AC4R');
  ippiNormRel_Inf_32f_C4R:=getProc(hh,'ippiNormRel_Inf_32f_C4R');
  ippiNormRel_L1_8u_C1R:=getProc(hh,'ippiNormRel_L1_8u_C1R');
  ippiNormRel_L1_8u_C3R:=getProc(hh,'ippiNormRel_L1_8u_C3R');
  ippiNormRel_L1_8u_AC4R:=getProc(hh,'ippiNormRel_L1_8u_AC4R');
  ippiNormRel_L1_8u_C4R:=getProc(hh,'ippiNormRel_L1_8u_C4R');
  ippiNormRel_L1_16s_C1R:=getProc(hh,'ippiNormRel_L1_16s_C1R');
  ippiNormRel_L1_16s_C3R:=getProc(hh,'ippiNormRel_L1_16s_C3R');
  ippiNormRel_L1_16s_AC4R:=getProc(hh,'ippiNormRel_L1_16s_AC4R');
  ippiNormRel_L1_16s_C4R:=getProc(hh,'ippiNormRel_L1_16s_C4R');
  ippiNormRel_L1_32f_C1R:=getProc(hh,'ippiNormRel_L1_32f_C1R');
  ippiNormRel_L1_32f_C3R:=getProc(hh,'ippiNormRel_L1_32f_C3R');
  ippiNormRel_L1_32f_AC4R:=getProc(hh,'ippiNormRel_L1_32f_AC4R');
  ippiNormRel_L1_32f_C4R:=getProc(hh,'ippiNormRel_L1_32f_C4R');
  ippiNormRel_L2_8u_C1R:=getProc(hh,'ippiNormRel_L2_8u_C1R');
  ippiNormRel_L2_8u_C3R:=getProc(hh,'ippiNormRel_L2_8u_C3R');
  ippiNormRel_L2_8u_AC4R:=getProc(hh,'ippiNormRel_L2_8u_AC4R');
  ippiNormRel_L2_8u_C4R:=getProc(hh,'ippiNormRel_L2_8u_C4R');
  ippiNormRel_L2_16s_C1R:=getProc(hh,'ippiNormRel_L2_16s_C1R');
  ippiNormRel_L2_16s_C3R:=getProc(hh,'ippiNormRel_L2_16s_C3R');
  ippiNormRel_L2_16s_AC4R:=getProc(hh,'ippiNormRel_L2_16s_AC4R');
  ippiNormRel_L2_16s_C4R:=getProc(hh,'ippiNormRel_L2_16s_C4R');
  ippiNormRel_L2_32f_C1R:=getProc(hh,'ippiNormRel_L2_32f_C1R');
  ippiNormRel_L2_32f_C3R:=getProc(hh,'ippiNormRel_L2_32f_C3R');
  ippiNormRel_L2_32f_AC4R:=getProc(hh,'ippiNormRel_L2_32f_AC4R');
  ippiNormRel_L2_32f_C4R:=getProc(hh,'ippiNormRel_L2_32f_C4R');
  ippiSum_8u_C1R:=getProc(hh,'ippiSum_8u_C1R');
  ippiSum_8u_C3R:=getProc(hh,'ippiSum_8u_C3R');
  ippiSum_8u_AC4R:=getProc(hh,'ippiSum_8u_AC4R');
  ippiSum_8u_C4R:=getProc(hh,'ippiSum_8u_C4R');
  ippiSum_16s_C1R:=getProc(hh,'ippiSum_16s_C1R');
  ippiSum_16s_C3R:=getProc(hh,'ippiSum_16s_C3R');
  ippiSum_16s_AC4R:=getProc(hh,'ippiSum_16s_AC4R');
  ippiSum_16s_C4R:=getProc(hh,'ippiSum_16s_C4R');
  ippiSum_32f_C1R:=getProc(hh,'ippiSum_32f_C1R');
  ippiSum_32f_C3R:=getProc(hh,'ippiSum_32f_C3R');
  ippiSum_32f_AC4R:=getProc(hh,'ippiSum_32f_AC4R');
  ippiSum_32f_C4R:=getProc(hh,'ippiSum_32f_C4R');
  ippiMean_8u_C1R:=getProc(hh,'ippiMean_8u_C1R');
  ippiMean_8u_C3R:=getProc(hh,'ippiMean_8u_C3R');
  ippiMean_8u_AC4R:=getProc(hh,'ippiMean_8u_AC4R');
  ippiMean_8u_C4R:=getProc(hh,'ippiMean_8u_C4R');
  ippiMean_16s_C1R:=getProc(hh,'ippiMean_16s_C1R');
  ippiMean_16s_C3R:=getProc(hh,'ippiMean_16s_C3R');
  ippiMean_16s_AC4R:=getProc(hh,'ippiMean_16s_AC4R');
  ippiMean_16s_C4R:=getProc(hh,'ippiMean_16s_C4R');
  ippiMean_32f_C1R:=getProc(hh,'ippiMean_32f_C1R');
  ippiMean_32f_C3R:=getProc(hh,'ippiMean_32f_C3R');
  ippiMean_32f_AC4R:=getProc(hh,'ippiMean_32f_AC4R');
  ippiMean_32f_C4R:=getProc(hh,'ippiMean_32f_C4R');
  ippiQualityIndex_8u32f_C1R:=getProc(hh,'ippiQualityIndex_8u32f_C1R');
  ippiQualityIndex_8u32f_C3R:=getProc(hh,'ippiQualityIndex_8u32f_C3R');
  ippiQualityIndex_8u32f_AC4R:=getProc(hh,'ippiQualityIndex_8u32f_AC4R');
  ippiQualityIndex_32f_C1R:=getProc(hh,'ippiQualityIndex_32f_C1R');
  ippiQualityIndex_32f_C3R:=getProc(hh,'ippiQualityIndex_32f_C3R');
  ippiQualityIndex_32f_AC4R:=getProc(hh,'ippiQualityIndex_32f_AC4R');
  ippiHistogramRange_8u_C1R:=getProc(hh,'ippiHistogramRange_8u_C1R');
  ippiHistogramRange_8u_C3R:=getProc(hh,'ippiHistogramRange_8u_C3R');
  ippiHistogramRange_8u_AC4R:=getProc(hh,'ippiHistogramRange_8u_AC4R');
  ippiHistogramRange_8u_C4R:=getProc(hh,'ippiHistogramRange_8u_C4R');
  ippiHistogramRange_16s_C1R:=getProc(hh,'ippiHistogramRange_16s_C1R');
  ippiHistogramRange_16s_C3R:=getProc(hh,'ippiHistogramRange_16s_C3R');
  ippiHistogramRange_16s_AC4R:=getProc(hh,'ippiHistogramRange_16s_AC4R');
  ippiHistogramRange_16s_C4R:=getProc(hh,'ippiHistogramRange_16s_C4R');
  ippiHistogramRange_32f_C1R:=getProc(hh,'ippiHistogramRange_32f_C1R');
  ippiHistogramRange_32f_C3R:=getProc(hh,'ippiHistogramRange_32f_C3R');
  ippiHistogramRange_32f_AC4R:=getProc(hh,'ippiHistogramRange_32f_AC4R');
  ippiHistogramRange_32f_C4R:=getProc(hh,'ippiHistogramRange_32f_C4R');
  ippiHistogramEven_8u_C1R:=getProc(hh,'ippiHistogramEven_8u_C1R');
  ippiHistogramEven_8u_C3R:=getProc(hh,'ippiHistogramEven_8u_C3R');
  ippiHistogramEven_8u_AC4R:=getProc(hh,'ippiHistogramEven_8u_AC4R');
  ippiHistogramEven_8u_C4R:=getProc(hh,'ippiHistogramEven_8u_C4R');
  ippiHistogramEven_16s_C1R:=getProc(hh,'ippiHistogramEven_16s_C1R');
  ippiHistogramEven_16s_C3R:=getProc(hh,'ippiHistogramEven_16s_C3R');
  ippiHistogramEven_16s_AC4R:=getProc(hh,'ippiHistogramEven_16s_AC4R');
  ippiHistogramEven_16s_C4R:=getProc(hh,'ippiHistogramEven_16s_C4R');
  ippiLUT_8u_C1R:=getProc(hh,'ippiLUT_8u_C1R');
  ippiLUT_8u_C3R:=getProc(hh,'ippiLUT_8u_C3R');
  ippiLUT_8u_AC4R:=getProc(hh,'ippiLUT_8u_AC4R');
  ippiLUT_8u_C4R:=getProc(hh,'ippiLUT_8u_C4R');
  ippiLUT_16s_C1R:=getProc(hh,'ippiLUT_16s_C1R');
  ippiLUT_16s_C3R:=getProc(hh,'ippiLUT_16s_C3R');
  ippiLUT_16s_AC4R:=getProc(hh,'ippiLUT_16s_AC4R');
  ippiLUT_16s_C4R:=getProc(hh,'ippiLUT_16s_C4R');
  ippiLUT_32f_C1R:=getProc(hh,'ippiLUT_32f_C1R');
  ippiLUT_32f_C3R:=getProc(hh,'ippiLUT_32f_C3R');
  ippiLUT_32f_AC4R:=getProc(hh,'ippiLUT_32f_AC4R');
  ippiLUT_32f_C4R:=getProc(hh,'ippiLUT_32f_C4R');
  ippiLUT_Linear_8u_C1R:=getProc(hh,'ippiLUT_Linear_8u_C1R');
  ippiLUT_Linear_8u_C3R:=getProc(hh,'ippiLUT_Linear_8u_C3R');
  ippiLUT_Linear_8u_AC4R:=getProc(hh,'ippiLUT_Linear_8u_AC4R');
  ippiLUT_Linear_8u_C4R:=getProc(hh,'ippiLUT_Linear_8u_C4R');
  ippiLUT_Linear_16s_C1R:=getProc(hh,'ippiLUT_Linear_16s_C1R');
  ippiLUT_Linear_16s_C3R:=getProc(hh,'ippiLUT_Linear_16s_C3R');
  ippiLUT_Linear_16s_AC4R:=getProc(hh,'ippiLUT_Linear_16s_AC4R');
  ippiLUT_Linear_16s_C4R:=getProc(hh,'ippiLUT_Linear_16s_C4R');
  ippiLUT_Linear_32f_C1R:=getProc(hh,'ippiLUT_Linear_32f_C1R');
  ippiLUT_Linear_32f_C3R:=getProc(hh,'ippiLUT_Linear_32f_C3R');
  ippiLUT_Linear_32f_AC4R:=getProc(hh,'ippiLUT_Linear_32f_AC4R');
  ippiLUT_Linear_32f_C4R:=getProc(hh,'ippiLUT_Linear_32f_C4R');
  ippiLUT_Cubic_8u_C1R:=getProc(hh,'ippiLUT_Cubic_8u_C1R');
  ippiLUT_Cubic_8u_C3R:=getProc(hh,'ippiLUT_Cubic_8u_C3R');
  ippiLUT_Cubic_8u_AC4R:=getProc(hh,'ippiLUT_Cubic_8u_AC4R');
  ippiLUT_Cubic_8u_C4R:=getProc(hh,'ippiLUT_Cubic_8u_C4R');
  ippiLUT_Cubic_16s_C1R:=getProc(hh,'ippiLUT_Cubic_16s_C1R');
  ippiLUT_Cubic_16s_C3R:=getProc(hh,'ippiLUT_Cubic_16s_C3R');
  ippiLUT_Cubic_16s_AC4R:=getProc(hh,'ippiLUT_Cubic_16s_AC4R');
  ippiLUT_Cubic_16s_C4R:=getProc(hh,'ippiLUT_Cubic_16s_C4R');
  ippiLUT_Cubic_32f_C1R:=getProc(hh,'ippiLUT_Cubic_32f_C1R');
  ippiLUT_Cubic_32f_C3R:=getProc(hh,'ippiLUT_Cubic_32f_C3R');
  ippiLUT_Cubic_32f_AC4R:=getProc(hh,'ippiLUT_Cubic_32f_AC4R');
  ippiLUT_Cubic_32f_C4R:=getProc(hh,'ippiLUT_Cubic_32f_C4R');
  ippiCountInRange_8u_C1R:=getProc(hh,'ippiCountInRange_8u_C1R');
  ippiCountInRange_8u_C3R:=getProc(hh,'ippiCountInRange_8u_C3R');
  ippiCountInRange_8u_AC4R:=getProc(hh,'ippiCountInRange_8u_AC4R');
  ippiCountInRange_32f_C1R:=getProc(hh,'ippiCountInRange_32f_C1R');
  ippiCountInRange_32f_C3R:=getProc(hh,'ippiCountInRange_32f_C3R');
  ippiCountInRange_32f_AC4R:=getProc(hh,'ippiCountInRange_32f_AC4R');
  ippiFilterMedianHoriz_8u_C1R:=getProc(hh,'ippiFilterMedianHoriz_8u_C1R');
  ippiFilterMedianHoriz_8u_C3R:=getProc(hh,'ippiFilterMedianHoriz_8u_C3R');
  ippiFilterMedianHoriz_8u_AC4R:=getProc(hh,'ippiFilterMedianHoriz_8u_AC4R');
  ippiFilterMedianHoriz_16s_C1R:=getProc(hh,'ippiFilterMedianHoriz_16s_C1R');
  ippiFilterMedianHoriz_16s_C3R:=getProc(hh,'ippiFilterMedianHoriz_16s_C3R');
  ippiFilterMedianHoriz_16s_AC4R:=getProc(hh,'ippiFilterMedianHoriz_16s_AC4R');
  ippiFilterMedianHoriz_8u_C4R:=getProc(hh,'ippiFilterMedianHoriz_8u_C4R');
  ippiFilterMedianHoriz_16s_C4R:=getProc(hh,'ippiFilterMedianHoriz_16s_C4R');
  ippiFilterMedianVert_8u_C1R:=getProc(hh,'ippiFilterMedianVert_8u_C1R');
  ippiFilterMedianVert_8u_C3R:=getProc(hh,'ippiFilterMedianVert_8u_C3R');
  ippiFilterMedianVert_8u_AC4R:=getProc(hh,'ippiFilterMedianVert_8u_AC4R');
  ippiFilterMedianVert_16s_C1R:=getProc(hh,'ippiFilterMedianVert_16s_C1R');
  ippiFilterMedianVert_16s_C3R:=getProc(hh,'ippiFilterMedianVert_16s_C3R');
  ippiFilterMedianVert_16s_AC4R:=getProc(hh,'ippiFilterMedianVert_16s_AC4R');
  ippiFilterMedianVert_8u_C4R:=getProc(hh,'ippiFilterMedianVert_8u_C4R');
  ippiFilterMedianVert_16s_C4R:=getProc(hh,'ippiFilterMedianVert_16s_C4R');
  ippiFilterMedian_8u_C1R:=getProc(hh,'ippiFilterMedian_8u_C1R');
  ippiFilterMedian_8u_C3R:=getProc(hh,'ippiFilterMedian_8u_C3R');
  ippiFilterMedian_8u_AC4R:=getProc(hh,'ippiFilterMedian_8u_AC4R');
  ippiFilterMedian_16s_C1R:=getProc(hh,'ippiFilterMedian_16s_C1R');
  ippiFilterMedian_16s_C3R:=getProc(hh,'ippiFilterMedian_16s_C3R');
  ippiFilterMedian_16s_AC4R:=getProc(hh,'ippiFilterMedian_16s_AC4R');
  ippiFilterMedian_8u_C4R:=getProc(hh,'ippiFilterMedian_8u_C4R');
  ippiFilterMedian_16s_C4R:=getProc(hh,'ippiFilterMedian_16s_C4R');
  ippiFilterMedianCross_8u_C1R:=getProc(hh,'ippiFilterMedianCross_8u_C1R');
  ippiFilterMedianCross_8u_C3R:=getProc(hh,'ippiFilterMedianCross_8u_C3R');
  ippiFilterMedianCross_8u_AC4R:=getProc(hh,'ippiFilterMedianCross_8u_AC4R');
  ippiFilterMedianCross_16s_C1R:=getProc(hh,'ippiFilterMedianCross_16s_C1R');
  ippiFilterMedianCross_16s_C3R:=getProc(hh,'ippiFilterMedianCross_16s_C3R');
  ippiFilterMedianCross_16s_AC4R:=getProc(hh,'ippiFilterMedianCross_16s_AC4R');
  ippiFilterMedianColor_8u_C3R:=getProc(hh,'ippiFilterMedianColor_8u_C3R');
  ippiFilterMedianColor_8u_AC4R:=getProc(hh,'ippiFilterMedianColor_8u_AC4R');
  ippiFilterMedianColor_16s_C3R:=getProc(hh,'ippiFilterMedianColor_16s_C3R');
  ippiFilterMedianColor_16s_AC4R:=getProc(hh,'ippiFilterMedianColor_16s_AC4R');
  ippiFilterMedianColor_32f_C3R:=getProc(hh,'ippiFilterMedianColor_32f_C3R');
  ippiFilterMedianColor_32f_AC4R:=getProc(hh,'ippiFilterMedianColor_32f_AC4R');
  ippiFilterMax_8u_C1R:=getProc(hh,'ippiFilterMax_8u_C1R');
  ippiFilterMax_8u_C3R:=getProc(hh,'ippiFilterMax_8u_C3R');
  ippiFilterMax_8u_AC4R:=getProc(hh,'ippiFilterMax_8u_AC4R');
  ippiFilterMax_16s_C1R:=getProc(hh,'ippiFilterMax_16s_C1R');
  ippiFilterMax_16s_C3R:=getProc(hh,'ippiFilterMax_16s_C3R');
  ippiFilterMax_16s_AC4R:=getProc(hh,'ippiFilterMax_16s_AC4R');
  ippiFilterMax_32f_C1R:=getProc(hh,'ippiFilterMax_32f_C1R');
  ippiFilterMax_32f_C3R:=getProc(hh,'ippiFilterMax_32f_C3R');
  ippiFilterMax_32f_AC4R:=getProc(hh,'ippiFilterMax_32f_AC4R');
  ippiFilterMax_8u_C4R:=getProc(hh,'ippiFilterMax_8u_C4R');
  ippiFilterMax_16s_C4R:=getProc(hh,'ippiFilterMax_16s_C4R');
  ippiFilterMax_32f_C4R:=getProc(hh,'ippiFilterMax_32f_C4R');
  ippiFilterMin_8u_C1R:=getProc(hh,'ippiFilterMin_8u_C1R');
  ippiFilterMin_8u_C3R:=getProc(hh,'ippiFilterMin_8u_C3R');
  ippiFilterMin_8u_AC4R:=getProc(hh,'ippiFilterMin_8u_AC4R');
  ippiFilterMin_16s_C1R:=getProc(hh,'ippiFilterMin_16s_C1R');
  ippiFilterMin_16s_C3R:=getProc(hh,'ippiFilterMin_16s_C3R');
  ippiFilterMin_16s_AC4R:=getProc(hh,'ippiFilterMin_16s_AC4R');
  ippiFilterMin_32f_C1R:=getProc(hh,'ippiFilterMin_32f_C1R');
  ippiFilterMin_32f_C3R:=getProc(hh,'ippiFilterMin_32f_C3R');
  ippiFilterMin_32f_AC4R:=getProc(hh,'ippiFilterMin_32f_AC4R');
  ippiFilterMin_8u_C4R:=getProc(hh,'ippiFilterMin_8u_C4R');
  ippiFilterMin_16s_C4R:=getProc(hh,'ippiFilterMin_16s_C4R');
  ippiFilterMin_32f_C4R:=getProc(hh,'ippiFilterMin_32f_C4R');
  ippiFilterBox_8u_C1R:=getProc(hh,'ippiFilterBox_8u_C1R');
  ippiFilterBox_8u_C3R:=getProc(hh,'ippiFilterBox_8u_C3R');
  ippiFilterBox_8u_AC4R:=getProc(hh,'ippiFilterBox_8u_AC4R');
  ippiFilterBox_8u_C4R:=getProc(hh,'ippiFilterBox_8u_C4R');
  ippiFilterBox_16s_C1R:=getProc(hh,'ippiFilterBox_16s_C1R');
  ippiFilterBox_16s_C3R:=getProc(hh,'ippiFilterBox_16s_C3R');
  ippiFilterBox_16s_AC4R:=getProc(hh,'ippiFilterBox_16s_AC4R');
  ippiFilterBox_16s_C4R:=getProc(hh,'ippiFilterBox_16s_C4R');
  ippiFilterBox_32f_C1R:=getProc(hh,'ippiFilterBox_32f_C1R');
  ippiFilterBox_32f_C3R:=getProc(hh,'ippiFilterBox_32f_C3R');
  ippiFilterBox_32f_AC4R:=getProc(hh,'ippiFilterBox_32f_AC4R');
  ippiFilterBox_32f_C4R:=getProc(hh,'ippiFilterBox_32f_C4R');
  ippiFilterBox_8u_C1IR:=getProc(hh,'ippiFilterBox_8u_C1IR');
  ippiFilterBox_8u_C3IR:=getProc(hh,'ippiFilterBox_8u_C3IR');
  ippiFilterBox_8u_AC4IR:=getProc(hh,'ippiFilterBox_8u_AC4IR');
  ippiFilterBox_8u_C4IR:=getProc(hh,'ippiFilterBox_8u_C4IR');
  ippiFilterBox_16s_C1IR:=getProc(hh,'ippiFilterBox_16s_C1IR');
  ippiFilterBox_16s_C3IR:=getProc(hh,'ippiFilterBox_16s_C3IR');
  ippiFilterBox_16s_AC4IR:=getProc(hh,'ippiFilterBox_16s_AC4IR');
  ippiFilterBox_16s_C4IR:=getProc(hh,'ippiFilterBox_16s_C4IR');
  ippiFilterBox_32f_C1IR:=getProc(hh,'ippiFilterBox_32f_C1IR');
  ippiFilterBox_32f_C3IR:=getProc(hh,'ippiFilterBox_32f_C3IR');
  ippiFilterBox_32f_AC4IR:=getProc(hh,'ippiFilterBox_32f_AC4IR');
  ippiFilterBox_32f_C4IR:=getProc(hh,'ippiFilterBox_32f_C4IR');
  ippiFilterPrewittVert_8u_C1R:=getProc(hh,'ippiFilterPrewittVert_8u_C1R');
  ippiFilterPrewittVert_8u_C3R:=getProc(hh,'ippiFilterPrewittVert_8u_C3R');
  ippiFilterPrewittVert_8u_AC4R:=getProc(hh,'ippiFilterPrewittVert_8u_AC4R');
  ippiFilterPrewittVert_16s_C1R:=getProc(hh,'ippiFilterPrewittVert_16s_C1R');
  ippiFilterPrewittVert_16s_C3R:=getProc(hh,'ippiFilterPrewittVert_16s_C3R');
  ippiFilterPrewittVert_16s_AC4R:=getProc(hh,'ippiFilterPrewittVert_16s_AC4R');
  ippiFilterPrewittVert_32f_C1R:=getProc(hh,'ippiFilterPrewittVert_32f_C1R');
  ippiFilterPrewittVert_32f_C3R:=getProc(hh,'ippiFilterPrewittVert_32f_C3R');
  ippiFilterPrewittVert_32f_AC4R:=getProc(hh,'ippiFilterPrewittVert_32f_AC4R');
  ippiFilterPrewittHoriz_8u_C1R:=getProc(hh,'ippiFilterPrewittHoriz_8u_C1R');
  ippiFilterPrewittHoriz_8u_C3R:=getProc(hh,'ippiFilterPrewittHoriz_8u_C3R');
  ippiFilterPrewittHoriz_8u_AC4R:=getProc(hh,'ippiFilterPrewittHoriz_8u_AC4R');
  ippiFilterPrewittHoriz_16s_C1R:=getProc(hh,'ippiFilterPrewittHoriz_16s_C1R');
  ippiFilterPrewittHoriz_16s_C3R:=getProc(hh,'ippiFilterPrewittHoriz_16s_C3R');
  ippiFilterPrewittHoriz_16s_AC4R:=getProc(hh,'ippiFilterPrewittHoriz_16s_AC4R');
  ippiFilterPrewittHoriz_32f_C1R:=getProc(hh,'ippiFilterPrewittHoriz_32f_C1R');
  ippiFilterPrewittHoriz_32f_C3R:=getProc(hh,'ippiFilterPrewittHoriz_32f_C3R');
  ippiFilterPrewittHoriz_32f_AC4R:=getProc(hh,'ippiFilterPrewittHoriz_32f_AC4R');
  ippiFilterSobelVert_8u_C1R:=getProc(hh,'ippiFilterSobelVert_8u_C1R');
  ippiFilterSobelVert_8u_C3R:=getProc(hh,'ippiFilterSobelVert_8u_C3R');
  ippiFilterSobelVert_8u_AC4R:=getProc(hh,'ippiFilterSobelVert_8u_AC4R');
  ippiFilterSobelVert_16s_C1R:=getProc(hh,'ippiFilterSobelVert_16s_C1R');
  ippiFilterSobelVert_16s_C3R:=getProc(hh,'ippiFilterSobelVert_16s_C3R');
  ippiFilterSobelVert_16s_AC4R:=getProc(hh,'ippiFilterSobelVert_16s_AC4R');
  ippiFilterSobelVert_32f_C1R:=getProc(hh,'ippiFilterSobelVert_32f_C1R');
  ippiFilterSobelVert_32f_C3R:=getProc(hh,'ippiFilterSobelVert_32f_C3R');
  ippiFilterSobelVert_32f_AC4R:=getProc(hh,'ippiFilterSobelVert_32f_AC4R');
  ippiFilterSobelHoriz_8u_C1R:=getProc(hh,'ippiFilterSobelHoriz_8u_C1R');
  ippiFilterSobelHoriz_8u_C3R:=getProc(hh,'ippiFilterSobelHoriz_8u_C3R');
  ippiFilterSobelHoriz_8u_AC4R:=getProc(hh,'ippiFilterSobelHoriz_8u_AC4R');
  ippiFilterSobelHoriz_16s_C1R:=getProc(hh,'ippiFilterSobelHoriz_16s_C1R');
  ippiFilterSobelHoriz_16s_C3R:=getProc(hh,'ippiFilterSobelHoriz_16s_C3R');
  ippiFilterSobelHoriz_16s_AC4R:=getProc(hh,'ippiFilterSobelHoriz_16s_AC4R');
  ippiFilterSobelHoriz_32f_C1R:=getProc(hh,'ippiFilterSobelHoriz_32f_C1R');
  ippiFilterSobelHoriz_32f_C3R:=getProc(hh,'ippiFilterSobelHoriz_32f_C3R');
  ippiFilterSobelHoriz_32f_AC4R:=getProc(hh,'ippiFilterSobelHoriz_32f_AC4R');
  ippiFilterRobertsUp_8u_C1R:=getProc(hh,'ippiFilterRobertsUp_8u_C1R');
  ippiFilterRobertsUp_8u_C3R:=getProc(hh,'ippiFilterRobertsUp_8u_C3R');
  ippiFilterRobertsUp_8u_AC4R:=getProc(hh,'ippiFilterRobertsUp_8u_AC4R');
  ippiFilterRobertsUp_16s_C1R:=getProc(hh,'ippiFilterRobertsUp_16s_C1R');
  ippiFilterRobertsUp_16s_C3R:=getProc(hh,'ippiFilterRobertsUp_16s_C3R');
  ippiFilterRobertsUp_16s_AC4R:=getProc(hh,'ippiFilterRobertsUp_16s_AC4R');
  ippiFilterRobertsUp_32f_C1R:=getProc(hh,'ippiFilterRobertsUp_32f_C1R');
  ippiFilterRobertsUp_32f_C3R:=getProc(hh,'ippiFilterRobertsUp_32f_C3R');
  ippiFilterRobertsUp_32f_AC4R:=getProc(hh,'ippiFilterRobertsUp_32f_AC4R');
  ippiFilterRobertsDown_8u_C1R:=getProc(hh,'ippiFilterRobertsDown_8u_C1R');
  ippiFilterRobertsDown_8u_C3R:=getProc(hh,'ippiFilterRobertsDown_8u_C3R');
  ippiFilterRobertsDown_8u_AC4R:=getProc(hh,'ippiFilterRobertsDown_8u_AC4R');
  ippiFilterRobertsDown_16s_C1R:=getProc(hh,'ippiFilterRobertsDown_16s_C1R');
  ippiFilterRobertsDown_16s_C3R:=getProc(hh,'ippiFilterRobertsDown_16s_C3R');
  ippiFilterRobertsDown_16s_AC4R:=getProc(hh,'ippiFilterRobertsDown_16s_AC4R');
  ippiFilterRobertsDown_32f_C1R:=getProc(hh,'ippiFilterRobertsDown_32f_C1R');
  ippiFilterRobertsDown_32f_C3R:=getProc(hh,'ippiFilterRobertsDown_32f_C3R');
  ippiFilterRobertsDown_32f_AC4R:=getProc(hh,'ippiFilterRobertsDown_32f_AC4R');
  ippiFilterSharpen_8u_C1R:=getProc(hh,'ippiFilterSharpen_8u_C1R');
  ippiFilterSharpen_8u_C3R:=getProc(hh,'ippiFilterSharpen_8u_C3R');
  ippiFilterSharpen_8u_AC4R:=getProc(hh,'ippiFilterSharpen_8u_AC4R');
  ippiFilterSharpen_16s_C1R:=getProc(hh,'ippiFilterSharpen_16s_C1R');
  ippiFilterSharpen_16s_C3R:=getProc(hh,'ippiFilterSharpen_16s_C3R');
  ippiFilterSharpen_16s_AC4R:=getProc(hh,'ippiFilterSharpen_16s_AC4R');
  ippiFilterSharpen_32f_C1R:=getProc(hh,'ippiFilterSharpen_32f_C1R');
  ippiFilterSharpen_32f_C3R:=getProc(hh,'ippiFilterSharpen_32f_C3R');
  ippiFilterSharpen_32f_AC4R:=getProc(hh,'ippiFilterSharpen_32f_AC4R');
  ippiFilterScharrVert_8u16s_C1R:=getProc(hh,'ippiFilterScharrVert_8u16s_C1R');
  ippiFilterScharrHoriz_8u16s_C1R:=getProc(hh,'ippiFilterScharrHoriz_8u16s_C1R');
  ippiFilterScharrVert_8s16s_C1R:=getProc(hh,'ippiFilterScharrVert_8s16s_C1R');
  ippiFilterScharrHoriz_8s16s_C1R:=getProc(hh,'ippiFilterScharrHoriz_8s16s_C1R');
  ippiFilterScharrVert_32f_C1R:=getProc(hh,'ippiFilterScharrVert_32f_C1R');
  ippiFilterScharrHoriz_32f_C1R:=getProc(hh,'ippiFilterScharrHoriz_32f_C1R');
  ippiFilterPrewittVert_8u_C4R:=getProc(hh,'ippiFilterPrewittVert_8u_C4R');
  ippiFilterPrewittVert_16s_C4R:=getProc(hh,'ippiFilterPrewittVert_16s_C4R');
  ippiFilterPrewittVert_32f_C4R:=getProc(hh,'ippiFilterPrewittVert_32f_C4R');
  ippiFilterPrewittHoriz_8u_C4R:=getProc(hh,'ippiFilterPrewittHoriz_8u_C4R');
  ippiFilterPrewittHoriz_16s_C4R:=getProc(hh,'ippiFilterPrewittHoriz_16s_C4R');
  ippiFilterPrewittHoriz_32f_C4R:=getProc(hh,'ippiFilterPrewittHoriz_32f_C4R');
  ippiFilterSobelVert_8u_C4R:=getProc(hh,'ippiFilterSobelVert_8u_C4R');
  ippiFilterSobelVert_16s_C4R:=getProc(hh,'ippiFilterSobelVert_16s_C4R');
  ippiFilterSobelVert_32f_C4R:=getProc(hh,'ippiFilterSobelVert_32f_C4R');
  ippiFilterSobelHoriz_8u_C4R:=getProc(hh,'ippiFilterSobelHoriz_8u_C4R');
  ippiFilterSobelHoriz_16s_C4R:=getProc(hh,'ippiFilterSobelHoriz_16s_C4R');
  ippiFilterSobelHoriz_32f_C4R:=getProc(hh,'ippiFilterSobelHoriz_32f_C4R');
  ippiFilterSharpen_8u_C4R:=getProc(hh,'ippiFilterSharpen_8u_C4R');
  ippiFilterSharpen_16s_C4R:=getProc(hh,'ippiFilterSharpen_16s_C4R');
  ippiFilterSharpen_32f_C4R:=getProc(hh,'ippiFilterSharpen_32f_C4R');
  ippiFilterLaplace_8u_C1R:=getProc(hh,'ippiFilterLaplace_8u_C1R');
  ippiFilterLaplace_8u_C3R:=getProc(hh,'ippiFilterLaplace_8u_C3R');
  ippiFilterLaplace_8u_AC4R:=getProc(hh,'ippiFilterLaplace_8u_AC4R');
  ippiFilterLaplace_16s_C1R:=getProc(hh,'ippiFilterLaplace_16s_C1R');
  ippiFilterLaplace_16s_C3R:=getProc(hh,'ippiFilterLaplace_16s_C3R');
  ippiFilterLaplace_16s_AC4R:=getProc(hh,'ippiFilterLaplace_16s_AC4R');
  ippiFilterLaplace_32f_C1R:=getProc(hh,'ippiFilterLaplace_32f_C1R');
  ippiFilterLaplace_32f_C3R:=getProc(hh,'ippiFilterLaplace_32f_C3R');
  ippiFilterLaplace_32f_AC4R:=getProc(hh,'ippiFilterLaplace_32f_AC4R');
  ippiFilterGauss_8u_C1R:=getProc(hh,'ippiFilterGauss_8u_C1R');
  ippiFilterGauss_8u_C3R:=getProc(hh,'ippiFilterGauss_8u_C3R');
  ippiFilterGauss_8u_AC4R:=getProc(hh,'ippiFilterGauss_8u_AC4R');
  ippiFilterGauss_16s_C1R:=getProc(hh,'ippiFilterGauss_16s_C1R');
  ippiFilterGauss_16s_C3R:=getProc(hh,'ippiFilterGauss_16s_C3R');
  ippiFilterGauss_16s_AC4R:=getProc(hh,'ippiFilterGauss_16s_AC4R');
  ippiFilterGauss_32f_C1R:=getProc(hh,'ippiFilterGauss_32f_C1R');
  ippiFilterGauss_32f_C3R:=getProc(hh,'ippiFilterGauss_32f_C3R');
  ippiFilterGauss_32f_AC4R:=getProc(hh,'ippiFilterGauss_32f_AC4R');
  ippiFilterHipass_8u_C1R:=getProc(hh,'ippiFilterHipass_8u_C1R');
  ippiFilterHipass_8u_C3R:=getProc(hh,'ippiFilterHipass_8u_C3R');
  ippiFilterHipass_8u_AC4R:=getProc(hh,'ippiFilterHipass_8u_AC4R');
  ippiFilterHipass_16s_C1R:=getProc(hh,'ippiFilterHipass_16s_C1R');
  ippiFilterHipass_16s_C3R:=getProc(hh,'ippiFilterHipass_16s_C3R');
  ippiFilterHipass_16s_AC4R:=getProc(hh,'ippiFilterHipass_16s_AC4R');
  ippiFilterHipass_32f_C1R:=getProc(hh,'ippiFilterHipass_32f_C1R');
  ippiFilterHipass_32f_C3R:=getProc(hh,'ippiFilterHipass_32f_C3R');
  ippiFilterHipass_32f_AC4R:=getProc(hh,'ippiFilterHipass_32f_AC4R');
  ippiFilterLowpass_8u_C1R:=getProc(hh,'ippiFilterLowpass_8u_C1R');
  ippiFilterLowpass_8u_C3R:=getProc(hh,'ippiFilterLowpass_8u_C3R');
  ippiFilterLowpass_8u_AC4R:=getProc(hh,'ippiFilterLowpass_8u_AC4R');
  ippiFilterLowpass_16s_C1R:=getProc(hh,'ippiFilterLowpass_16s_C1R');
  ippiFilterLowpass_16s_C3R:=getProc(hh,'ippiFilterLowpass_16s_C3R');
  ippiFilterLowpass_16s_AC4R:=getProc(hh,'ippiFilterLowpass_16s_AC4R');
  ippiFilterLowpass_32f_C1R:=getProc(hh,'ippiFilterLowpass_32f_C1R');
  ippiFilterLowpass_32f_C3R:=getProc(hh,'ippiFilterLowpass_32f_C3R');
  ippiFilterLowpass_32f_AC4R:=getProc(hh,'ippiFilterLowpass_32f_AC4R');
  ippiFilterLaplace_8u16s_C1R:=getProc(hh,'ippiFilterLaplace_8u16s_C1R');
  ippiFilterLaplace_8s16s_C1R:=getProc(hh,'ippiFilterLaplace_8s16s_C1R');
  ippiFilterSobelVert_8u16s_C1R:=getProc(hh,'ippiFilterSobelVert_8u16s_C1R');
  ippiFilterSobelHoriz_8u16s_C1R:=getProc(hh,'ippiFilterSobelHoriz_8u16s_C1R');
  ippiFilterSobelVertSecond_8u16s_C1R:=getProc(hh,'ippiFilterSobelVertSecond_8u16s_C1R');
  ippiFilterSobelHorizSecond_8u16s_C1R:=getProc(hh,'ippiFilterSobelHorizSecond_8u16s_C1R');
  ippiFilterSobelCross_8u16s_C1R:=getProc(hh,'ippiFilterSobelCross_8u16s_C1R');
  ippiFilterSobelVert_8s16s_C1R:=getProc(hh,'ippiFilterSobelVert_8s16s_C1R');
  ippiFilterSobelHoriz_8s16s_C1R:=getProc(hh,'ippiFilterSobelHoriz_8s16s_C1R');
  ippiFilterSobelVertSecond_8s16s_C1R:=getProc(hh,'ippiFilterSobelVertSecond_8s16s_C1R');
  ippiFilterSobelHorizSecond_8s16s_C1R:=getProc(hh,'ippiFilterSobelHorizSecond_8s16s_C1R');
  ippiFilterSobelCross_8s16s_C1R:=getProc(hh,'ippiFilterSobelCross_8s16s_C1R');
  ippiFilterSobelVertMask_32f_C1R:=getProc(hh,'ippiFilterSobelVertMask_32f_C1R');
  ippiFilterSobelHorizMask_32f_C1R:=getProc(hh,'ippiFilterSobelHorizMask_32f_C1R');
  ippiFilterSobelVertSecond_32f_C1R:=getProc(hh,'ippiFilterSobelVertSecond_32f_C1R');
  ippiFilterSobelHorizSecond_32f_C1R:=getProc(hh,'ippiFilterSobelHorizSecond_32f_C1R');
  ippiFilterSobelCross_32f_C1R:=getProc(hh,'ippiFilterSobelCross_32f_C1R');
  ippiFilterLaplace_8u_C4R:=getProc(hh,'ippiFilterLaplace_8u_C4R');
  ippiFilterLaplace_16s_C4R:=getProc(hh,'ippiFilterLaplace_16s_C4R');
  ippiFilterLaplace_32f_C4R:=getProc(hh,'ippiFilterLaplace_32f_C4R');
  ippiFilterGauss_8u_C4R:=getProc(hh,'ippiFilterGauss_8u_C4R');
  ippiFilterGauss_16s_C4R:=getProc(hh,'ippiFilterGauss_16s_C4R');
  ippiFilterGauss_32f_C4R:=getProc(hh,'ippiFilterGauss_32f_C4R');
  ippiFilterHipass_8u_C4R:=getProc(hh,'ippiFilterHipass_8u_C4R');
  ippiFilterHipass_16s_C4R:=getProc(hh,'ippiFilterHipass_16s_C4R');
  ippiFilterHipass_32f_C4R:=getProc(hh,'ippiFilterHipass_32f_C4R');
  ippiFilter_8u_C1R:=getProc(hh,'ippiFilter_8u_C1R');
  ippiFilter_8u_C3R:=getProc(hh,'ippiFilter_8u_C3R');
  ippiFilter_8u_C4R:=getProc(hh,'ippiFilter_8u_C4R');
  ippiFilter_8u_AC4R:=getProc(hh,'ippiFilter_8u_AC4R');
  ippiFilter_16s_C1R:=getProc(hh,'ippiFilter_16s_C1R');
  ippiFilter_16s_C3R:=getProc(hh,'ippiFilter_16s_C3R');
  ippiFilter_16s_C4R:=getProc(hh,'ippiFilter_16s_C4R');
  ippiFilter_16s_AC4R:=getProc(hh,'ippiFilter_16s_AC4R');
  ippiFilter32f_8u_C1R:=getProc(hh,'ippiFilter32f_8u_C1R');
  ippiFilter32f_8u_C3R:=getProc(hh,'ippiFilter32f_8u_C3R');
  ippiFilter32f_8u_C4R:=getProc(hh,'ippiFilter32f_8u_C4R');
  ippiFilter32f_8u_AC4R:=getProc(hh,'ippiFilter32f_8u_AC4R');
  ippiFilter32f_16s_C1R:=getProc(hh,'ippiFilter32f_16s_C1R');
  ippiFilter32f_16s_C3R:=getProc(hh,'ippiFilter32f_16s_C3R');
  ippiFilter32f_16s_C4R:=getProc(hh,'ippiFilter32f_16s_C4R');
  ippiFilter32f_16s_AC4R:=getProc(hh,'ippiFilter32f_16s_AC4R');
  ippiFilter_32f_C1R:=getProc(hh,'ippiFilter_32f_C1R');
  ippiFilter_32f_C3R:=getProc(hh,'ippiFilter_32f_C3R');
  ippiFilter_32f_C4R:=getProc(hh,'ippiFilter_32f_C4R');
  ippiFilter_32f_AC4R:=getProc(hh,'ippiFilter_32f_AC4R');
  ippiFilterColumn_8u_C1R:=getProc(hh,'ippiFilterColumn_8u_C1R');
  ippiFilterColumn_8u_C3R:=getProc(hh,'ippiFilterColumn_8u_C3R');
  ippiFilterColumn_8u_C4R:=getProc(hh,'ippiFilterColumn_8u_C4R');
  ippiFilterColumn_8u_AC4R:=getProc(hh,'ippiFilterColumn_8u_AC4R');
  ippiFilterColumn_16s_C1R:=getProc(hh,'ippiFilterColumn_16s_C1R');
  ippiFilterColumn_16s_C3R:=getProc(hh,'ippiFilterColumn_16s_C3R');
  ippiFilterColumn_16s_C4R:=getProc(hh,'ippiFilterColumn_16s_C4R');
  ippiFilterColumn_16s_AC4R:=getProc(hh,'ippiFilterColumn_16s_AC4R');
  ippiFilterColumn32f_8u_C1R:=getProc(hh,'ippiFilterColumn32f_8u_C1R');
  ippiFilterColumn32f_8u_C3R:=getProc(hh,'ippiFilterColumn32f_8u_C3R');
  ippiFilterColumn32f_8u_C4R:=getProc(hh,'ippiFilterColumn32f_8u_C4R');
  ippiFilterColumn32f_8u_AC4R:=getProc(hh,'ippiFilterColumn32f_8u_AC4R');
  ippiFilterColumn32f_16s_C1R:=getProc(hh,'ippiFilterColumn32f_16s_C1R');
  ippiFilterColumn32f_16s_C3R:=getProc(hh,'ippiFilterColumn32f_16s_C3R');
  ippiFilterColumn32f_16s_C4R:=getProc(hh,'ippiFilterColumn32f_16s_C4R');
  ippiFilterColumn32f_16s_AC4R:=getProc(hh,'ippiFilterColumn32f_16s_AC4R');
  ippiFilterColumn_32f_C1R:=getProc(hh,'ippiFilterColumn_32f_C1R');
  ippiFilterColumn_32f_C3R:=getProc(hh,'ippiFilterColumn_32f_C3R');
  ippiFilterColumn_32f_C4R:=getProc(hh,'ippiFilterColumn_32f_C4R');
  ippiFilterColumn_32f_AC4R:=getProc(hh,'ippiFilterColumn_32f_AC4R');
  ippiFilterRow_8u_C1R:=getProc(hh,'ippiFilterRow_8u_C1R');
  ippiFilterRow_8u_C3R:=getProc(hh,'ippiFilterRow_8u_C3R');
  ippiFilterRow_8u_C4R:=getProc(hh,'ippiFilterRow_8u_C4R');
  ippiFilterRow_8u_AC4R:=getProc(hh,'ippiFilterRow_8u_AC4R');
  ippiFilterRow_16s_C1R:=getProc(hh,'ippiFilterRow_16s_C1R');
  ippiFilterRow_16s_C3R:=getProc(hh,'ippiFilterRow_16s_C3R');
  ippiFilterRow_16s_C4R:=getProc(hh,'ippiFilterRow_16s_C4R');
  ippiFilterRow_16s_AC4R:=getProc(hh,'ippiFilterRow_16s_AC4R');
  ippiFilterRow32f_8u_C1R:=getProc(hh,'ippiFilterRow32f_8u_C1R');
  ippiFilterRow32f_8u_C3R:=getProc(hh,'ippiFilterRow32f_8u_C3R');
  ippiFilterRow32f_8u_C4R:=getProc(hh,'ippiFilterRow32f_8u_C4R');
  ippiFilterRow32f_8u_AC4R:=getProc(hh,'ippiFilterRow32f_8u_AC4R');
  ippiFilterRow32f_16s_C1R:=getProc(hh,'ippiFilterRow32f_16s_C1R');
  ippiFilterRow32f_16s_C3R:=getProc(hh,'ippiFilterRow32f_16s_C3R');
  ippiFilterRow32f_16s_C4R:=getProc(hh,'ippiFilterRow32f_16s_C4R');
  ippiFilterRow32f_16s_AC4R:=getProc(hh,'ippiFilterRow32f_16s_AC4R');
  ippiFilterRow_32f_C1R:=getProc(hh,'ippiFilterRow_32f_C1R');
  ippiFilterRow_32f_C3R:=getProc(hh,'ippiFilterRow_32f_C3R');
  ippiFilterRow_32f_C4R:=getProc(hh,'ippiFilterRow_32f_C4R');
  ippiFilterRow_32f_AC4R:=getProc(hh,'ippiFilterRow_32f_AC4R');
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
  ippiConvFull_32f_C1R:=getProc(hh,'ippiConvFull_32f_C1R');
  ippiConvFull_32f_C3R:=getProc(hh,'ippiConvFull_32f_C3R');
  ippiConvFull_32f_AC4R:=getProc(hh,'ippiConvFull_32f_AC4R');
  ippiConvFull_16s_C1R:=getProc(hh,'ippiConvFull_16s_C1R');
  ippiConvFull_16s_C3R:=getProc(hh,'ippiConvFull_16s_C3R');
  ippiConvFull_16s_AC4R:=getProc(hh,'ippiConvFull_16s_AC4R');
  ippiConvFull_8u_C1R:=getProc(hh,'ippiConvFull_8u_C1R');
  ippiConvFull_8u_C3R:=getProc(hh,'ippiConvFull_8u_C3R');
  ippiConvFull_8u_AC4R:=getProc(hh,'ippiConvFull_8u_AC4R');
  ippiConvValid_32f_C1R:=getProc(hh,'ippiConvValid_32f_C1R');
  ippiConvValid_32f_C3R:=getProc(hh,'ippiConvValid_32f_C3R');
  ippiConvValid_32f_AC4R:=getProc(hh,'ippiConvValid_32f_AC4R');
  ippiConvValid_16s_C1R:=getProc(hh,'ippiConvValid_16s_C1R');
  ippiConvValid_16s_C3R:=getProc(hh,'ippiConvValid_16s_C3R');
  ippiConvValid_16s_AC4R:=getProc(hh,'ippiConvValid_16s_AC4R');
  ippiConvValid_8u_C1R:=getProc(hh,'ippiConvValid_8u_C1R');
  ippiConvValid_8u_C3R:=getProc(hh,'ippiConvValid_8u_C3R');
  ippiConvValid_8u_AC4R:=getProc(hh,'ippiConvValid_8u_AC4R');
  ippiCrossCorrFull_Norm_32f_C1R:=getProc(hh,'ippiCrossCorrFull_Norm_32f_C1R');
  ippiCrossCorrFull_Norm_32f_C3R:=getProc(hh,'ippiCrossCorrFull_Norm_32f_C3R');
  ippiCrossCorrFull_Norm_32f_AC4R:=getProc(hh,'ippiCrossCorrFull_Norm_32f_AC4R');
  ippiCrossCorrFull_Norm_8u32f_C1R:=getProc(hh,'ippiCrossCorrFull_Norm_8u32f_C1R');
  ippiCrossCorrFull_Norm_8u32f_C3R:=getProc(hh,'ippiCrossCorrFull_Norm_8u32f_C3R');
  ippiCrossCorrFull_Norm_8u32f_AC4R:=getProc(hh,'ippiCrossCorrFull_Norm_8u32f_AC4R');
  ippiCrossCorrFull_Norm_8u_C1RSfs:=getProc(hh,'ippiCrossCorrFull_Norm_8u_C1RSfs');
  ippiCrossCorrFull_Norm_8u_C3RSfs:=getProc(hh,'ippiCrossCorrFull_Norm_8u_C3RSfs');
  ippiCrossCorrFull_Norm_8u_AC4RSfs:=getProc(hh,'ippiCrossCorrFull_Norm_8u_AC4RSfs');
  ippiCrossCorrValid_Norm_32f_C1R:=getProc(hh,'ippiCrossCorrValid_Norm_32f_C1R');
  ippiCrossCorrValid_Norm_32f_C3R:=getProc(hh,'ippiCrossCorrValid_Norm_32f_C3R');
  ippiCrossCorrValid_Norm_32f_AC4R:=getProc(hh,'ippiCrossCorrValid_Norm_32f_AC4R');
  ippiCrossCorrValid_Norm_8u32f_C1R:=getProc(hh,'ippiCrossCorrValid_Norm_8u32f_C1R');
  ippiCrossCorrValid_Norm_8u32f_C3R:=getProc(hh,'ippiCrossCorrValid_Norm_8u32f_C3R');
  ippiCrossCorrValid_Norm_8u32f_AC4R:=getProc(hh,'ippiCrossCorrValid_Norm_8u32f_AC4R');
  ippiCrossCorrValid_Norm_8u_C1RSfs:=getProc(hh,'ippiCrossCorrValid_Norm_8u_C1RSfs');
  ippiCrossCorrValid_Norm_8u_C3RSfs:=getProc(hh,'ippiCrossCorrValid_Norm_8u_C3RSfs');
  ippiCrossCorrValid_Norm_8u_AC4RSfs:=getProc(hh,'ippiCrossCorrValid_Norm_8u_AC4RSfs');
  ippiCrossCorrSame_Norm_32f_C1R:=getProc(hh,'ippiCrossCorrSame_Norm_32f_C1R');
  ippiCrossCorrSame_Norm_32f_C3R:=getProc(hh,'ippiCrossCorrSame_Norm_32f_C3R');
  ippiCrossCorrSame_Norm_32f_AC4R:=getProc(hh,'ippiCrossCorrSame_Norm_32f_AC4R');
  ippiCrossCorrSame_Norm_8u32f_C1R:=getProc(hh,'ippiCrossCorrSame_Norm_8u32f_C1R');
  ippiCrossCorrSame_Norm_8u32f_C3R:=getProc(hh,'ippiCrossCorrSame_Norm_8u32f_C3R');
  ippiCrossCorrSame_Norm_8u32f_AC4R:=getProc(hh,'ippiCrossCorrSame_Norm_8u32f_AC4R');
  ippiCrossCorrSame_Norm_8u_C1RSfs:=getProc(hh,'ippiCrossCorrSame_Norm_8u_C1RSfs');
  ippiCrossCorrSame_Norm_8u_C3RSfs:=getProc(hh,'ippiCrossCorrSame_Norm_8u_C3RSfs');
  ippiCrossCorrSame_Norm_8u_AC4RSfs:=getProc(hh,'ippiCrossCorrSame_Norm_8u_AC4RSfs');
  ippiCrossCorrFull_Norm_32f_C4R:=getProc(hh,'ippiCrossCorrFull_Norm_32f_C4R');
  ippiCrossCorrFull_Norm_8u32f_C4R:=getProc(hh,'ippiCrossCorrFull_Norm_8u32f_C4R');
  ippiCrossCorrFull_Norm_8s32f_C1R:=getProc(hh,'ippiCrossCorrFull_Norm_8s32f_C1R');
  ippiCrossCorrFull_Norm_8s32f_C3R:=getProc(hh,'ippiCrossCorrFull_Norm_8s32f_C3R');
  ippiCrossCorrFull_Norm_8s32f_C4R:=getProc(hh,'ippiCrossCorrFull_Norm_8s32f_C4R');
  ippiCrossCorrFull_Norm_8s32f_AC4R:=getProc(hh,'ippiCrossCorrFull_Norm_8s32f_AC4R');
  ippiCrossCorrFull_Norm_8u_C4RSfs:=getProc(hh,'ippiCrossCorrFull_Norm_8u_C4RSfs');
  ippiCrossCorrValid_Norm_32f_C4R:=getProc(hh,'ippiCrossCorrValid_Norm_32f_C4R');
  ippiCrossCorrValid_Norm_8u32f_C4R:=getProc(hh,'ippiCrossCorrValid_Norm_8u32f_C4R');
  ippiCrossCorrValid_Norm_8s32f_C1R:=getProc(hh,'ippiCrossCorrValid_Norm_8s32f_C1R');
  ippiCrossCorrValid_Norm_8s32f_C3R:=getProc(hh,'ippiCrossCorrValid_Norm_8s32f_C3R');
  ippiCrossCorrValid_Norm_8s32f_C4R:=getProc(hh,'ippiCrossCorrValid_Norm_8s32f_C4R');
  ippiCrossCorrValid_Norm_8s32f_AC4R:=getProc(hh,'ippiCrossCorrValid_Norm_8s32f_AC4R');
  ippiCrossCorrValid_Norm_8u_C4RSfs:=getProc(hh,'ippiCrossCorrValid_Norm_8u_C4RSfs');
  ippiCrossCorrSame_Norm_32f_C4R:=getProc(hh,'ippiCrossCorrSame_Norm_32f_C4R');
  ippiCrossCorrSame_Norm_8u32f_C4R:=getProc(hh,'ippiCrossCorrSame_Norm_8u32f_C4R');
  ippiCrossCorrSame_Norm_8s32f_C1R:=getProc(hh,'ippiCrossCorrSame_Norm_8s32f_C1R');
  ippiCrossCorrSame_Norm_8s32f_C3R:=getProc(hh,'ippiCrossCorrSame_Norm_8s32f_C3R');
  ippiCrossCorrSame_Norm_8s32f_C4R:=getProc(hh,'ippiCrossCorrSame_Norm_8s32f_C4R');
  ippiCrossCorrSame_Norm_8s32f_AC4R:=getProc(hh,'ippiCrossCorrSame_Norm_8s32f_AC4R');
  ippiCrossCorrSame_Norm_8u_C4RSfs:=getProc(hh,'ippiCrossCorrSame_Norm_8u_C4RSfs');
  ippiCrossCorrFull_NormLevel_32f_C1R:=getProc(hh,'ippiCrossCorrFull_NormLevel_32f_C1R');
  ippiCrossCorrFull_NormLevel_32f_C3R:=getProc(hh,'ippiCrossCorrFull_NormLevel_32f_C3R');
  ippiCrossCorrFull_NormLevel_32f_C4R:=getProc(hh,'ippiCrossCorrFull_NormLevel_32f_C4R');
  ippiCrossCorrFull_NormLevel_32f_AC4R:=getProc(hh,'ippiCrossCorrFull_NormLevel_32f_AC4R');
  ippiCrossCorrFull_NormLevel_8u32f_C1R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u32f_C1R');
  ippiCrossCorrFull_NormLevel_8u32f_C3R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u32f_C3R');
  ippiCrossCorrFull_NormLevel_8u32f_C4R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u32f_C4R');
  ippiCrossCorrFull_NormLevel_8u32f_AC4R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u32f_AC4R');
  ippiCrossCorrFull_NormLevel_8s32f_C1R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8s32f_C1R');
  ippiCrossCorrFull_NormLevel_8s32f_C3R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8s32f_C3R');
  ippiCrossCorrFull_NormLevel_8s32f_C4R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8s32f_C4R');
  ippiCrossCorrFull_NormLevel_8s32f_AC4R:=getProc(hh,'ippiCrossCorrFull_NormLevel_8s32f_AC4R');
  ippiCrossCorrFull_NormLevel_8u_C1RSfs:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u_C1RSfs');
  ippiCrossCorrFull_NormLevel_8u_C3RSfs:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u_C3RSfs');
  ippiCrossCorrFull_NormLevel_8u_C4RSfs:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u_C4RSfs');
  ippiCrossCorrFull_NormLevel_8u_AC4RSfs:=getProc(hh,'ippiCrossCorrFull_NormLevel_8u_AC4RSfs');
  ippiCrossCorrValid_NormLevel_32f_C1R:=getProc(hh,'ippiCrossCorrValid_NormLevel_32f_C1R');
  ippiCrossCorrValid_NormLevel_32f_C3R:=getProc(hh,'ippiCrossCorrValid_NormLevel_32f_C3R');
  ippiCrossCorrValid_NormLevel_32f_C4R:=getProc(hh,'ippiCrossCorrValid_NormLevel_32f_C4R');
  ippiCrossCorrValid_NormLevel_32f_AC4R:=getProc(hh,'ippiCrossCorrValid_NormLevel_32f_AC4R');
  ippiCrossCorrValid_NormLevel_8u32f_C1R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u32f_C1R');
  ippiCrossCorrValid_NormLevel_8u32f_C3R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u32f_C3R');
  ippiCrossCorrValid_NormLevel_8u32f_C4R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u32f_C4R');
  ippiCrossCorrValid_NormLevel_8u32f_AC4R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u32f_AC4R');
  ippiCrossCorrValid_NormLevel_8s32f_C1R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8s32f_C1R');
  ippiCrossCorrValid_NormLevel_8s32f_C3R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8s32f_C3R');
  ippiCrossCorrValid_NormLevel_8s32f_C4R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8s32f_C4R');
  ippiCrossCorrValid_NormLevel_8s32f_AC4R:=getProc(hh,'ippiCrossCorrValid_NormLevel_8s32f_AC4R');
  ippiCrossCorrValid_NormLevel_8u_C1RSfs:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u_C1RSfs');
  ippiCrossCorrValid_NormLevel_8u_C3RSfs:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u_C3RSfs');
  ippiCrossCorrValid_NormLevel_8u_C4RSfs:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u_C4RSfs');
  ippiCrossCorrValid_NormLevel_8u_AC4RSfs:=getProc(hh,'ippiCrossCorrValid_NormLevel_8u_AC4RSfs');
  ippiCrossCorrSame_NormLevel_32f_C1R:=getProc(hh,'ippiCrossCorrSame_NormLevel_32f_C1R');
  ippiCrossCorrSame_NormLevel_32f_C3R:=getProc(hh,'ippiCrossCorrSame_NormLevel_32f_C3R');
  ippiCrossCorrSame_NormLevel_32f_C4R:=getProc(hh,'ippiCrossCorrSame_NormLevel_32f_C4R');
  ippiCrossCorrSame_NormLevel_32f_AC4R:=getProc(hh,'ippiCrossCorrSame_NormLevel_32f_AC4R');
  ippiCrossCorrSame_NormLevel_8u32f_C1R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u32f_C1R');
  ippiCrossCorrSame_NormLevel_8u32f_C3R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u32f_C3R');
  ippiCrossCorrSame_NormLevel_8u32f_C4R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u32f_C4R');
  ippiCrossCorrSame_NormLevel_8u32f_AC4R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u32f_AC4R');
  ippiCrossCorrSame_NormLevel_8s32f_C1R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8s32f_C1R');
  ippiCrossCorrSame_NormLevel_8s32f_C3R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8s32f_C3R');
  ippiCrossCorrSame_NormLevel_8s32f_C4R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8s32f_C4R');
  ippiCrossCorrSame_NormLevel_8s32f_AC4R:=getProc(hh,'ippiCrossCorrSame_NormLevel_8s32f_AC4R');
  ippiCrossCorrSame_NormLevel_8u_C1RSfs:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u_C1RSfs');
  ippiCrossCorrSame_NormLevel_8u_C3RSfs:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u_C3RSfs');
  ippiCrossCorrSame_NormLevel_8u_C4RSfs:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u_C4RSfs');
  ippiCrossCorrSame_NormLevel_8u_AC4RSfs:=getProc(hh,'ippiCrossCorrSame_NormLevel_8u_AC4RSfs');
  ippiSqrDistanceFull_Norm_32f_C1R:=getProc(hh,'ippiSqrDistanceFull_Norm_32f_C1R');
  ippiSqrDistanceFull_Norm_32f_C3R:=getProc(hh,'ippiSqrDistanceFull_Norm_32f_C3R');
  ippiSqrDistanceFull_Norm_32f_AC4R:=getProc(hh,'ippiSqrDistanceFull_Norm_32f_AC4R');
  ippiSqrDistanceFull_Norm_8u32f_C1R:=getProc(hh,'ippiSqrDistanceFull_Norm_8u32f_C1R');
  ippiSqrDistanceFull_Norm_8u32f_C3R:=getProc(hh,'ippiSqrDistanceFull_Norm_8u32f_C3R');
  ippiSqrDistanceFull_Norm_8u32f_AC4R:=getProc(hh,'ippiSqrDistanceFull_Norm_8u32f_AC4R');
  ippiSqrDistanceFull_Norm_8u_C1RSfs:=getProc(hh,'ippiSqrDistanceFull_Norm_8u_C1RSfs');
  ippiSqrDistanceFull_Norm_8u_C3RSfs:=getProc(hh,'ippiSqrDistanceFull_Norm_8u_C3RSfs');
  ippiSqrDistanceFull_Norm_8u_AC4RSfs:=getProc(hh,'ippiSqrDistanceFull_Norm_8u_AC4RSfs');
  ippiSqrDistanceValid_Norm_32f_C1R:=getProc(hh,'ippiSqrDistanceValid_Norm_32f_C1R');
  ippiSqrDistanceValid_Norm_32f_C3R:=getProc(hh,'ippiSqrDistanceValid_Norm_32f_C3R');
  ippiSqrDistanceValid_Norm_32f_AC4R:=getProc(hh,'ippiSqrDistanceValid_Norm_32f_AC4R');
  ippiSqrDistanceValid_Norm_8u32f_C1R:=getProc(hh,'ippiSqrDistanceValid_Norm_8u32f_C1R');
  ippiSqrDistanceValid_Norm_8u32f_C3R:=getProc(hh,'ippiSqrDistanceValid_Norm_8u32f_C3R');
  ippiSqrDistanceValid_Norm_8u32f_AC4R:=getProc(hh,'ippiSqrDistanceValid_Norm_8u32f_AC4R');
  ippiSqrDistanceValid_Norm_8u_C1RSfs:=getProc(hh,'ippiSqrDistanceValid_Norm_8u_C1RSfs');
  ippiSqrDistanceValid_Norm_8u_C3RSfs:=getProc(hh,'ippiSqrDistanceValid_Norm_8u_C3RSfs');
  ippiSqrDistanceValid_Norm_8u_AC4RSfs:=getProc(hh,'ippiSqrDistanceValid_Norm_8u_AC4RSfs');
  ippiSqrDistanceSame_Norm_32f_C1R:=getProc(hh,'ippiSqrDistanceSame_Norm_32f_C1R');
  ippiSqrDistanceSame_Norm_32f_C3R:=getProc(hh,'ippiSqrDistanceSame_Norm_32f_C3R');
  ippiSqrDistanceSame_Norm_32f_AC4R:=getProc(hh,'ippiSqrDistanceSame_Norm_32f_AC4R');
  ippiSqrDistanceSame_Norm_8u32f_C1R:=getProc(hh,'ippiSqrDistanceSame_Norm_8u32f_C1R');
  ippiSqrDistanceSame_Norm_8u32f_C3R:=getProc(hh,'ippiSqrDistanceSame_Norm_8u32f_C3R');
  ippiSqrDistanceSame_Norm_8u32f_AC4R:=getProc(hh,'ippiSqrDistanceSame_Norm_8u32f_AC4R');
  ippiSqrDistanceSame_Norm_8u_C1RSfs:=getProc(hh,'ippiSqrDistanceSame_Norm_8u_C1RSfs');
  ippiSqrDistanceSame_Norm_8u_C3RSfs:=getProc(hh,'ippiSqrDistanceSame_Norm_8u_C3RSfs');
  ippiSqrDistanceSame_Norm_8u_AC4RSfs:=getProc(hh,'ippiSqrDistanceSame_Norm_8u_AC4RSfs');
  ippiSqrDistanceFull_Norm_32f_C4R:=getProc(hh,'ippiSqrDistanceFull_Norm_32f_C4R');
  ippiSqrDistanceFull_Norm_8u32f_C4R:=getProc(hh,'ippiSqrDistanceFull_Norm_8u32f_C4R');
  ippiSqrDistanceFull_Norm_8s32f_C1R:=getProc(hh,'ippiSqrDistanceFull_Norm_8s32f_C1R');
  ippiSqrDistanceFull_Norm_8s32f_C3R:=getProc(hh,'ippiSqrDistanceFull_Norm_8s32f_C3R');
  ippiSqrDistanceFull_Norm_8s32f_C4R:=getProc(hh,'ippiSqrDistanceFull_Norm_8s32f_C4R');
  ippiSqrDistanceFull_Norm_8s32f_AC4R:=getProc(hh,'ippiSqrDistanceFull_Norm_8s32f_AC4R');
  ippiSqrDistanceFull_Norm_8u_C4RSfs:=getProc(hh,'ippiSqrDistanceFull_Norm_8u_C4RSfs');
  ippiSqrDistanceValid_Norm_32f_C4R:=getProc(hh,'ippiSqrDistanceValid_Norm_32f_C4R');
  ippiSqrDistanceValid_Norm_8u32f_C4R:=getProc(hh,'ippiSqrDistanceValid_Norm_8u32f_C4R');
  ippiSqrDistanceValid_Norm_8s32f_C1R:=getProc(hh,'ippiSqrDistanceValid_Norm_8s32f_C1R');
  ippiSqrDistanceValid_Norm_8s32f_C3R:=getProc(hh,'ippiSqrDistanceValid_Norm_8s32f_C3R');
  ippiSqrDistanceValid_Norm_8s32f_C4R:=getProc(hh,'ippiSqrDistanceValid_Norm_8s32f_C4R');
  ippiSqrDistanceValid_Norm_8s32f_AC4R:=getProc(hh,'ippiSqrDistanceValid_Norm_8s32f_AC4R');
  ippiSqrDistanceValid_Norm_8u_C4RSfs:=getProc(hh,'ippiSqrDistanceValid_Norm_8u_C4RSfs');
  ippiSqrDistanceSame_Norm_32f_C4R:=getProc(hh,'ippiSqrDistanceSame_Norm_32f_C4R');
  ippiSqrDistanceSame_Norm_8u32f_C4R:=getProc(hh,'ippiSqrDistanceSame_Norm_8u32f_C4R');
  ippiSqrDistanceSame_Norm_8s32f_C1R:=getProc(hh,'ippiSqrDistanceSame_Norm_8s32f_C1R');
  ippiSqrDistanceSame_Norm_8s32f_C3R:=getProc(hh,'ippiSqrDistanceSame_Norm_8s32f_C3R');
  ippiSqrDistanceSame_Norm_8s32f_C4R:=getProc(hh,'ippiSqrDistanceSame_Norm_8s32f_C4R');
  ippiSqrDistanceSame_Norm_8s32f_AC4R:=getProc(hh,'ippiSqrDistanceSame_Norm_8s32f_AC4R');
  ippiSqrDistanceSame_Norm_8u_C4RSfs:=getProc(hh,'ippiSqrDistanceSame_Norm_8u_C4RSfs');

end;

procedure init4;
begin
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
  ippiCopyWrapBorder_32s_C1R:=getProc(hh,'ippiCopyWrapBorder_32s_C1R');
  ippiCopyWrapBorder_32s_C1IR:=getProc(hh,'ippiCopyWrapBorder_32s_C1IR');
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
  ippiAddRandUniform_Direct_8u_C1IR:=getProc(hh,'ippiAddRandUniform_Direct_8u_C1IR');
  ippiAddRandUniform_Direct_8u_C3IR:=getProc(hh,'ippiAddRandUniform_Direct_8u_C3IR');
  ippiAddRandUniform_Direct_8u_C4IR:=getProc(hh,'ippiAddRandUniform_Direct_8u_C4IR');
  ippiAddRandUniform_Direct_8u_AC4IR:=getProc(hh,'ippiAddRandUniform_Direct_8u_AC4IR');
  ippiAddRandUniform_Direct_16s_C1IR:=getProc(hh,'ippiAddRandUniform_Direct_16s_C1IR');
  ippiAddRandUniform_Direct_16s_C3IR:=getProc(hh,'ippiAddRandUniform_Direct_16s_C3IR');
  ippiAddRandUniform_Direct_16s_C4IR:=getProc(hh,'ippiAddRandUniform_Direct_16s_C4IR');
  ippiAddRandUniform_Direct_16s_AC4IR:=getProc(hh,'ippiAddRandUniform_Direct_16s_AC4IR');
  ippiAddRandUniform_Direct_32f_C1IR:=getProc(hh,'ippiAddRandUniform_Direct_32f_C1IR');
  ippiAddRandUniform_Direct_32f_C3IR:=getProc(hh,'ippiAddRandUniform_Direct_32f_C3IR');
  ippiAddRandUniform_Direct_32f_C4IR:=getProc(hh,'ippiAddRandUniform_Direct_32f_C4IR');
  ippiAddRandUniform_Direct_32f_AC4IR:=getProc(hh,'ippiAddRandUniform_Direct_32f_AC4IR');
  ippiAddRandGauss_Direct_8u_C1IR:=getProc(hh,'ippiAddRandGauss_Direct_8u_C1IR');
  ippiAddRandGauss_Direct_8u_C3IR:=getProc(hh,'ippiAddRandGauss_Direct_8u_C3IR');
  ippiAddRandGauss_Direct_8u_C4IR:=getProc(hh,'ippiAddRandGauss_Direct_8u_C4IR');
  ippiAddRandGauss_Direct_8u_AC4IR:=getProc(hh,'ippiAddRandGauss_Direct_8u_AC4IR');
  ippiAddRandGauss_Direct_16s_C1IR:=getProc(hh,'ippiAddRandGauss_Direct_16s_C1IR');
  ippiAddRandGauss_Direct_16s_C3IR:=getProc(hh,'ippiAddRandGauss_Direct_16s_C3IR');
  ippiAddRandGauss_Direct_16s_C4IR:=getProc(hh,'ippiAddRandGauss_Direct_16s_C4IR');
  ippiAddRandGauss_Direct_16s_AC4IR:=getProc(hh,'ippiAddRandGauss_Direct_16s_AC4IR');
  ippiAddRandGauss_Direct_32f_C1IR:=getProc(hh,'ippiAddRandGauss_Direct_32f_C1IR');
  ippiAddRandGauss_Direct_32f_C3IR:=getProc(hh,'ippiAddRandGauss_Direct_32f_C3IR');
  ippiAddRandGauss_Direct_32f_C4IR:=getProc(hh,'ippiAddRandGauss_Direct_32f_C4IR');
  ippiAddRandGauss_Direct_32f_AC4IR:=getProc(hh,'ippiAddRandGauss_Direct_32f_AC4IR');
  ippiImageJaehne_8u_C1R:=getProc(hh,'ippiImageJaehne_8u_C1R');
  ippiImageJaehne_8u_C3R:=getProc(hh,'ippiImageJaehne_8u_C3R');
  ippiImageJaehne_8s_C1R:=getProc(hh,'ippiImageJaehne_8s_C1R');
  ippiImageJaehne_8s_C3R:=getProc(hh,'ippiImageJaehne_8s_C3R');
  ippiImageJaehne_16u_C1R:=getProc(hh,'ippiImageJaehne_16u_C1R');
  ippiImageJaehne_16u_C3R:=getProc(hh,'ippiImageJaehne_16u_C3R');
  ippiImageJaehne_16s_C1R:=getProc(hh,'ippiImageJaehne_16s_C1R');
  ippiImageJaehne_16s_C3R:=getProc(hh,'ippiImageJaehne_16s_C3R');
  ippiImageJaehne_32s_C1R:=getProc(hh,'ippiImageJaehne_32s_C1R');
  ippiImageJaehne_32s_C3R:=getProc(hh,'ippiImageJaehne_32s_C3R');
  ippiImageJaehne_32f_C1R:=getProc(hh,'ippiImageJaehne_32f_C1R');
  ippiImageJaehne_32f_C3R:=getProc(hh,'ippiImageJaehne_32f_C3R');
  ippiImageJaehne_8u_C4R:=getProc(hh,'ippiImageJaehne_8u_C4R');
  ippiImageJaehne_8s_C4R:=getProc(hh,'ippiImageJaehne_8s_C4R');
  ippiImageJaehne_16u_C4R:=getProc(hh,'ippiImageJaehne_16u_C4R');
  ippiImageJaehne_16s_C4R:=getProc(hh,'ippiImageJaehne_16s_C4R');
  ippiImageJaehne_32s_C4R:=getProc(hh,'ippiImageJaehne_32s_C4R');
  ippiImageJaehne_32f_C4R:=getProc(hh,'ippiImageJaehne_32f_C4R');
  ippiImageJaehne_8u_AC4R:=getProc(hh,'ippiImageJaehne_8u_AC4R');
  ippiImageJaehne_8s_AC4R:=getProc(hh,'ippiImageJaehne_8s_AC4R');
  ippiImageJaehne_16u_AC4R:=getProc(hh,'ippiImageJaehne_16u_AC4R');
  ippiImageJaehne_16s_AC4R:=getProc(hh,'ippiImageJaehne_16s_AC4R');
  ippiImageJaehne_32s_AC4R:=getProc(hh,'ippiImageJaehne_32s_AC4R');
  ippiImageJaehne_32f_AC4R:=getProc(hh,'ippiImageJaehne_32f_AC4R');
  ippiImageRamp_8u_C1R:=getProc(hh,'ippiImageRamp_8u_C1R');
  ippiImageRamp_8u_C3R:=getProc(hh,'ippiImageRamp_8u_C3R');
  ippiImageRamp_8s_C1R:=getProc(hh,'ippiImageRamp_8s_C1R');
  ippiImageRamp_8s_C3R:=getProc(hh,'ippiImageRamp_8s_C3R');
  ippiImageRamp_16u_C1R:=getProc(hh,'ippiImageRamp_16u_C1R');
  ippiImageRamp_16u_C3R:=getProc(hh,'ippiImageRamp_16u_C3R');
  ippiImageRamp_16s_C1R:=getProc(hh,'ippiImageRamp_16s_C1R');
  ippiImageRamp_16s_C3R:=getProc(hh,'ippiImageRamp_16s_C3R');
  ippiImageRamp_32s_C1R:=getProc(hh,'ippiImageRamp_32s_C1R');
  ippiImageRamp_32s_C3R:=getProc(hh,'ippiImageRamp_32s_C3R');
  ippiImageRamp_32f_C1R:=getProc(hh,'ippiImageRamp_32f_C1R');
  ippiImageRamp_32f_C3R:=getProc(hh,'ippiImageRamp_32f_C3R');
  ippiImageRamp_8u_C4R:=getProc(hh,'ippiImageRamp_8u_C4R');
  ippiImageRamp_8s_C4R:=getProc(hh,'ippiImageRamp_8s_C4R');
  ippiImageRamp_16u_C4R:=getProc(hh,'ippiImageRamp_16u_C4R');
  ippiImageRamp_16s_C4R:=getProc(hh,'ippiImageRamp_16s_C4R');
  ippiImageRamp_32s_C4R:=getProc(hh,'ippiImageRamp_32s_C4R');
  ippiImageRamp_32f_C4R:=getProc(hh,'ippiImageRamp_32f_C4R');
  ippiImageRamp_8u_AC4R:=getProc(hh,'ippiImageRamp_8u_AC4R');
  ippiImageRamp_8s_AC4R:=getProc(hh,'ippiImageRamp_8s_AC4R');
  ippiImageRamp_16u_AC4R:=getProc(hh,'ippiImageRamp_16u_AC4R');
  ippiImageRamp_16s_AC4R:=getProc(hh,'ippiImageRamp_16s_AC4R');
  ippiImageRamp_32s_AC4R:=getProc(hh,'ippiImageRamp_32s_AC4R');
  ippiImageRamp_32f_AC4R:=getProc(hh,'ippiImageRamp_32f_AC4R');
  ippiConvert_8u16u_C1R:=getProc(hh,'ippiConvert_8u16u_C1R');
  ippiConvert_8u16u_C3R:=getProc(hh,'ippiConvert_8u16u_C3R');
  ippiConvert_8u16u_AC4R:=getProc(hh,'ippiConvert_8u16u_AC4R');
  ippiConvert_8u16u_C4R:=getProc(hh,'ippiConvert_8u16u_C4R');
  ippiConvert_16u8u_C1R:=getProc(hh,'ippiConvert_16u8u_C1R');
  ippiConvert_16u8u_C3R:=getProc(hh,'ippiConvert_16u8u_C3R');
  ippiConvert_16u8u_AC4R:=getProc(hh,'ippiConvert_16u8u_AC4R');
  ippiConvert_16u8u_C4R:=getProc(hh,'ippiConvert_16u8u_C4R');
  ippiConvert_8u16s_C1R:=getProc(hh,'ippiConvert_8u16s_C1R');
  ippiConvert_8u16s_C3R:=getProc(hh,'ippiConvert_8u16s_C3R');
  ippiConvert_8u16s_AC4R:=getProc(hh,'ippiConvert_8u16s_AC4R');
  ippiConvert_8u16s_C4R:=getProc(hh,'ippiConvert_8u16s_C4R');
  ippiConvert_16s8u_C1R:=getProc(hh,'ippiConvert_16s8u_C1R');
  ippiConvert_16s8u_C3R:=getProc(hh,'ippiConvert_16s8u_C3R');
  ippiConvert_16s8u_AC4R:=getProc(hh,'ippiConvert_16s8u_AC4R');
  ippiConvert_16s8u_C4R:=getProc(hh,'ippiConvert_16s8u_C4R');
  ippiConvert_8u32f_C1R:=getProc(hh,'ippiConvert_8u32f_C1R');
  ippiConvert_8u32f_C3R:=getProc(hh,'ippiConvert_8u32f_C3R');
  ippiConvert_8u32f_AC4R:=getProc(hh,'ippiConvert_8u32f_AC4R');
  ippiConvert_8u32f_C4R:=getProc(hh,'ippiConvert_8u32f_C4R');
  ippiConvert_32f8u_C1R:=getProc(hh,'ippiConvert_32f8u_C1R');
  ippiConvert_32f8u_C3R:=getProc(hh,'ippiConvert_32f8u_C3R');
  ippiConvert_32f8u_AC4R:=getProc(hh,'ippiConvert_32f8u_AC4R');
  ippiConvert_32f8u_C4R:=getProc(hh,'ippiConvert_32f8u_C4R');
  ippiConvert_16s32f_C1R:=getProc(hh,'ippiConvert_16s32f_C1R');
  ippiConvert_16s32f_C3R:=getProc(hh,'ippiConvert_16s32f_C3R');
  ippiConvert_16s32f_AC4R:=getProc(hh,'ippiConvert_16s32f_AC4R');
  ippiConvert_16s32f_C4R:=getProc(hh,'ippiConvert_16s32f_C4R');
  ippiConvert_32f16s_C1R:=getProc(hh,'ippiConvert_32f16s_C1R');
  ippiConvert_32f16s_C3R:=getProc(hh,'ippiConvert_32f16s_C3R');
  ippiConvert_32f16s_AC4R:=getProc(hh,'ippiConvert_32f16s_AC4R');
  ippiConvert_32f16s_C4R:=getProc(hh,'ippiConvert_32f16s_C4R');
  ippiConvert_8s32f_C1R:=getProc(hh,'ippiConvert_8s32f_C1R');
  ippiConvert_8s32f_C3R:=getProc(hh,'ippiConvert_8s32f_C3R');
  ippiConvert_8s32f_AC4R:=getProc(hh,'ippiConvert_8s32f_AC4R');
  ippiConvert_8s32f_C4R:=getProc(hh,'ippiConvert_8s32f_C4R');
  ippiConvert_32f8s_C1R:=getProc(hh,'ippiConvert_32f8s_C1R');
  ippiConvert_32f8s_C3R:=getProc(hh,'ippiConvert_32f8s_C3R');
  ippiConvert_32f8s_AC4R:=getProc(hh,'ippiConvert_32f8s_AC4R');
  ippiConvert_32f8s_C4R:=getProc(hh,'ippiConvert_32f8s_C4R');
  ippiConvert_16u32f_C1R:=getProc(hh,'ippiConvert_16u32f_C1R');
  ippiConvert_16u32f_C3R:=getProc(hh,'ippiConvert_16u32f_C3R');
  ippiConvert_16u32f_AC4R:=getProc(hh,'ippiConvert_16u32f_AC4R');
  ippiConvert_16u32f_C4R:=getProc(hh,'ippiConvert_16u32f_C4R');
  ippiConvert_32f16u_C1R:=getProc(hh,'ippiConvert_32f16u_C1R');
  ippiConvert_32f16u_C3R:=getProc(hh,'ippiConvert_32f16u_C3R');
  ippiConvert_32f16u_AC4R:=getProc(hh,'ippiConvert_32f16u_AC4R');
  ippiConvert_32f16u_C4R:=getProc(hh,'ippiConvert_32f16u_C4R');
  ippiConvert_8u32s_C1R:=getProc(hh,'ippiConvert_8u32s_C1R');
  ippiConvert_8u32s_C3R:=getProc(hh,'ippiConvert_8u32s_C3R');
  ippiConvert_8u32s_AC4R:=getProc(hh,'ippiConvert_8u32s_AC4R');
  ippiConvert_8u32s_C4R:=getProc(hh,'ippiConvert_8u32s_C4R');
  ippiConvert_32s8u_C1R:=getProc(hh,'ippiConvert_32s8u_C1R');
  ippiConvert_32s8u_C3R:=getProc(hh,'ippiConvert_32s8u_C3R');
  ippiConvert_32s8u_AC4R:=getProc(hh,'ippiConvert_32s8u_AC4R');
  ippiConvert_32s8u_C4R:=getProc(hh,'ippiConvert_32s8u_C4R');
  ippiConvert_8s32s_C1R:=getProc(hh,'ippiConvert_8s32s_C1R');
  ippiConvert_8s32s_C3R:=getProc(hh,'ippiConvert_8s32s_C3R');
  ippiConvert_8s32s_AC4R:=getProc(hh,'ippiConvert_8s32s_AC4R');
  ippiConvert_8s32s_C4R:=getProc(hh,'ippiConvert_8s32s_C4R');
  ippiConvert_32s8s_C1R:=getProc(hh,'ippiConvert_32s8s_C1R');
  ippiConvert_32s8s_C3R:=getProc(hh,'ippiConvert_32s8s_C3R');
  ippiConvert_32s8s_AC4R:=getProc(hh,'ippiConvert_32s8s_AC4R');
  ippiConvert_32s8s_C4R:=getProc(hh,'ippiConvert_32s8s_C4R');
  ippiConvert_1u8u_C1R:=getProc(hh,'ippiConvert_1u8u_C1R');
  ippiConvert_8u1u_C1R:=getProc(hh,'ippiConvert_8u1u_C1R');
  ippiSwapChannels_8u_C3R:=getProc(hh,'ippiSwapChannels_8u_C3R');
  ippiSwapChannels_8u_AC4R:=getProc(hh,'ippiSwapChannels_8u_AC4R');
  ippiSwapChannels_16u_C3R:=getProc(hh,'ippiSwapChannels_16u_C3R');
  ippiSwapChannels_16u_AC4R:=getProc(hh,'ippiSwapChannels_16u_AC4R');
  ippiSwapChannels_32s_C3R:=getProc(hh,'ippiSwapChannels_32s_C3R');
  ippiSwapChannels_32s_AC4R:=getProc(hh,'ippiSwapChannels_32s_AC4R');
  ippiSwapChannels_32f_C3R:=getProc(hh,'ippiSwapChannels_32f_C3R');
  ippiSwapChannels_32f_AC4R:=getProc(hh,'ippiSwapChannels_32f_AC4R');
  ippiSwapChannels_8u_C3IR:=getProc(hh,'ippiSwapChannels_8u_C3IR');
  ippiScale_8u16u_C1R:=getProc(hh,'ippiScale_8u16u_C1R');
  ippiScale_8u16s_C1R:=getProc(hh,'ippiScale_8u16s_C1R');
  ippiScale_8u32s_C1R:=getProc(hh,'ippiScale_8u32s_C1R');
  ippiScale_8u32f_C1R:=getProc(hh,'ippiScale_8u32f_C1R');
  ippiScale_8u16u_C3R:=getProc(hh,'ippiScale_8u16u_C3R');
  ippiScale_8u16s_C3R:=getProc(hh,'ippiScale_8u16s_C3R');
  ippiScale_8u32s_C3R:=getProc(hh,'ippiScale_8u32s_C3R');
  ippiScale_8u32f_C3R:=getProc(hh,'ippiScale_8u32f_C3R');
  ippiScale_8u16u_AC4R:=getProc(hh,'ippiScale_8u16u_AC4R');
  ippiScale_8u16s_AC4R:=getProc(hh,'ippiScale_8u16s_AC4R');
  ippiScale_8u32s_AC4R:=getProc(hh,'ippiScale_8u32s_AC4R');
  ippiScale_8u32f_AC4R:=getProc(hh,'ippiScale_8u32f_AC4R');
  ippiScale_8u16u_C4R:=getProc(hh,'ippiScale_8u16u_C4R');
  ippiScale_8u16s_C4R:=getProc(hh,'ippiScale_8u16s_C4R');
  ippiScale_8u32s_C4R:=getProc(hh,'ippiScale_8u32s_C4R');
  ippiScale_8u32f_C4R:=getProc(hh,'ippiScale_8u32f_C4R');
  ippiScale_16u8u_C1R:=getProc(hh,'ippiScale_16u8u_C1R');
  ippiScale_16s8u_C1R:=getProc(hh,'ippiScale_16s8u_C1R');
  ippiScale_32s8u_C1R:=getProc(hh,'ippiScale_32s8u_C1R');
  ippiScale_32f8u_C1R:=getProc(hh,'ippiScale_32f8u_C1R');
  ippiScale_16u8u_C3R:=getProc(hh,'ippiScale_16u8u_C3R');
  ippiScale_16s8u_C3R:=getProc(hh,'ippiScale_16s8u_C3R');
  ippiScale_32s8u_C3R:=getProc(hh,'ippiScale_32s8u_C3R');
  ippiScale_32f8u_C3R:=getProc(hh,'ippiScale_32f8u_C3R');
  ippiScale_16u8u_AC4R:=getProc(hh,'ippiScale_16u8u_AC4R');
  ippiScale_16s8u_AC4R:=getProc(hh,'ippiScale_16s8u_AC4R');
  ippiScale_32s8u_AC4R:=getProc(hh,'ippiScale_32s8u_AC4R');
  ippiScale_32f8u_AC4R:=getProc(hh,'ippiScale_32f8u_AC4R');
  ippiScale_16u8u_C4R:=getProc(hh,'ippiScale_16u8u_C4R');
  ippiScale_16s8u_C4R:=getProc(hh,'ippiScale_16s8u_C4R');
  ippiScale_32s8u_C4R:=getProc(hh,'ippiScale_32s8u_C4R');
  ippiScale_32f8u_C4R:=getProc(hh,'ippiScale_32f8u_C4R');
  ippiMin_8u_C1R:=getProc(hh,'ippiMin_8u_C1R');
  ippiMin_8u_C3R:=getProc(hh,'ippiMin_8u_C3R');
  ippiMin_8u_AC4R:=getProc(hh,'ippiMin_8u_AC4R');
  ippiMin_8u_C4R:=getProc(hh,'ippiMin_8u_C4R');
  ippiMin_16s_C1R:=getProc(hh,'ippiMin_16s_C1R');
  ippiMin_16s_C3R:=getProc(hh,'ippiMin_16s_C3R');
  ippiMin_16s_AC4R:=getProc(hh,'ippiMin_16s_AC4R');
  ippiMin_16s_C4R:=getProc(hh,'ippiMin_16s_C4R');
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
  ippiMinMax_32f_C1R:=getProc(hh,'ippiMinMax_32f_C1R');
  ippiMinMax_32f_C3R:=getProc(hh,'ippiMinMax_32f_C3R');
  ippiMinMax_32f_AC4R:=getProc(hh,'ippiMinMax_32f_AC4R');
  ippiMinMax_32f_C4R:=getProc(hh,'ippiMinMax_32f_C4R');
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
  ippiRShiftC_8s_C1R:=getProc(hh,'ippiRShiftC_8s_C1R');
  ippiRShiftC_8s_C3R:=getProc(hh,'ippiRShiftC_8s_C3R');
  ippiRShiftC_8s_C4R:=getProc(hh,'ippiRShiftC_8s_C4R');
  ippiRShiftC_8s_AC4R:=getProc(hh,'ippiRShiftC_8s_AC4R');
  ippiRShiftC_8s_C1IR:=getProc(hh,'ippiRShiftC_8s_C1IR');
  ippiRShiftC_8s_C3IR:=getProc(hh,'ippiRShiftC_8s_C3IR');
  ippiRShiftC_8s_C4IR:=getProc(hh,'ippiRShiftC_8s_C4IR');
  ippiRShiftC_8s_AC4IR:=getProc(hh,'ippiRShiftC_8s_AC4IR');
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
  ippiErode3x3_8u_C1R:=getProc(hh,'ippiErode3x3_8u_C1R');
  ippiErode3x3_8u_C3R:=getProc(hh,'ippiErode3x3_8u_C3R');
  ippiErode3x3_8u_AC4R:=getProc(hh,'ippiErode3x3_8u_AC4R');
  ippiErode3x3_8u_C4R:=getProc(hh,'ippiErode3x3_8u_C4R');
  ippiDilate3x3_8u_C1R:=getProc(hh,'ippiDilate3x3_8u_C1R');
  ippiDilate3x3_8u_C3R:=getProc(hh,'ippiDilate3x3_8u_C3R');
  ippiDilate3x3_8u_AC4R:=getProc(hh,'ippiDilate3x3_8u_AC4R');
  ippiDilate3x3_8u_C4R:=getProc(hh,'ippiDilate3x3_8u_C4R');
  ippiErode3x3_32f_C1R:=getProc(hh,'ippiErode3x3_32f_C1R');
  ippiErode3x3_32f_C3R:=getProc(hh,'ippiErode3x3_32f_C3R');
  ippiErode3x3_32f_AC4R:=getProc(hh,'ippiErode3x3_32f_AC4R');
  ippiErode3x3_32f_C4R:=getProc(hh,'ippiErode3x3_32f_C4R');
  ippiDilate3x3_32f_C1R:=getProc(hh,'ippiDilate3x3_32f_C1R');
  ippiDilate3x3_32f_C3R:=getProc(hh,'ippiDilate3x3_32f_C3R');
  ippiDilate3x3_32f_AC4R:=getProc(hh,'ippiDilate3x3_32f_AC4R');
  ippiDilate3x3_32f_C4R:=getProc(hh,'ippiDilate3x3_32f_C4R');
  ippiErode3x3_8u_C1IR:=getProc(hh,'ippiErode3x3_8u_C1IR');
  ippiErode3x3_8u_C3IR:=getProc(hh,'ippiErode3x3_8u_C3IR');
  ippiErode3x3_8u_AC4IR:=getProc(hh,'ippiErode3x3_8u_AC4IR');
  ippiErode3x3_8u_C4IR:=getProc(hh,'ippiErode3x3_8u_C4IR');
  ippiDilate3x3_8u_C1IR:=getProc(hh,'ippiDilate3x3_8u_C1IR');
  ippiDilate3x3_8u_C3IR:=getProc(hh,'ippiDilate3x3_8u_C3IR');
  ippiDilate3x3_8u_AC4IR:=getProc(hh,'ippiDilate3x3_8u_AC4IR');
  ippiDilate3x3_8u_C4IR:=getProc(hh,'ippiDilate3x3_8u_C4IR');
  ippiErode3x3_32f_C1IR:=getProc(hh,'ippiErode3x3_32f_C1IR');
  ippiErode3x3_32f_C3IR:=getProc(hh,'ippiErode3x3_32f_C3IR');
  ippiErode3x3_32f_AC4IR:=getProc(hh,'ippiErode3x3_32f_AC4IR');
  ippiErode3x3_32f_C4IR:=getProc(hh,'ippiErode3x3_32f_C4IR');
  ippiDilate3x3_32f_C1IR:=getProc(hh,'ippiDilate3x3_32f_C1IR');
  ippiDilate3x3_32f_C3IR:=getProc(hh,'ippiDilate3x3_32f_C3IR');
  ippiDilate3x3_32f_AC4IR:=getProc(hh,'ippiDilate3x3_32f_AC4IR');
  ippiDilate3x3_32f_C4IR:=getProc(hh,'ippiDilate3x3_32f_C4IR');
  ippiErode_8u_C1R:=getProc(hh,'ippiErode_8u_C1R');
  ippiErode_8u_C3R:=getProc(hh,'ippiErode_8u_C3R');
  ippiErode_8u_C4R:=getProc(hh,'ippiErode_8u_C4R');
  ippiErode_8u_AC4R:=getProc(hh,'ippiErode_8u_AC4R');
  ippiDilate_8u_C1R:=getProc(hh,'ippiDilate_8u_C1R');
  ippiDilate_8u_C3R:=getProc(hh,'ippiDilate_8u_C3R');
  ippiDilate_8u_C4R:=getProc(hh,'ippiDilate_8u_C4R');
  ippiDilate_8u_AC4R:=getProc(hh,'ippiDilate_8u_AC4R');
  ippiErode_32f_C1R:=getProc(hh,'ippiErode_32f_C1R');
  ippiErode_32f_C3R:=getProc(hh,'ippiErode_32f_C3R');
  ippiErode_32f_C4R:=getProc(hh,'ippiErode_32f_C4R');
  ippiErode_32f_AC4R:=getProc(hh,'ippiErode_32f_AC4R');
  ippiDilate_32f_C1R:=getProc(hh,'ippiDilate_32f_C1R');
  ippiDilate_32f_C3R:=getProc(hh,'ippiDilate_32f_C3R');
  ippiDilate_32f_C4R:=getProc(hh,'ippiDilate_32f_C4R');
  ippiDilate_32f_AC4R:=getProc(hh,'ippiDilate_32f_AC4R');
  ippiErode_8u_C1IR:=getProc(hh,'ippiErode_8u_C1IR');
  ippiErode_8u_C3IR:=getProc(hh,'ippiErode_8u_C3IR');
  ippiErode_8u_AC4IR:=getProc(hh,'ippiErode_8u_AC4IR');
  ippiDilate_8u_C1IR:=getProc(hh,'ippiDilate_8u_C1IR');
  ippiDilate_8u_C3IR:=getProc(hh,'ippiDilate_8u_C3IR');
  ippiDilate_8u_AC4IR:=getProc(hh,'ippiDilate_8u_AC4IR');
  ippiErode_32f_C1IR:=getProc(hh,'ippiErode_32f_C1IR');
  ippiErode_32f_C3IR:=getProc(hh,'ippiErode_32f_C3IR');
  ippiErode_32f_AC4IR:=getProc(hh,'ippiErode_32f_AC4IR');
  ippiDilate_32f_C1IR:=getProc(hh,'ippiDilate_32f_C1IR');
  ippiDilate_32f_C3IR:=getProc(hh,'ippiDilate_32f_C3IR');
  ippiDilate_32f_AC4IR:=getProc(hh,'ippiDilate_32f_AC4IR');
  ippiZigzagInv8x8_16s_C1:=getProc(hh,'ippiZigzagInv8x8_16s_C1');
  ippiZigzagFwd8x8_16s_C1:=getProc(hh,'ippiZigzagFwd8x8_16s_C1');
  ippiDrawText_8u_C3R:=getProc(hh,'ippiDrawText_8u_C3R');

  ippiResizeSqrPixel_32f_C1R:=getProc(hh,'ippiResizeSqrPixel_32f_C1R');
  ippiResizeSqrPixel_64f_C1R:=getProc(hh,'ippiResizeSqrPixel_64f_C1R');

  ippiResizeGetBufSize:= getProc(hh,'ippiResizeGetBufSize');
  ippiResizeGetBufSize_64f:= getProc(hh,'ippiResizeGetBufSize_64f');


end;

function InitIPPI:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(AppDir+'IPP\'+DLLname1);
  {$IFNDEF WIN64}
  if hh=0 then hh:=GloadLibrary(AppDir+'IPP\'+DLLname2);
  {$ENDIF}


  result:=(hh<>0);
  if not result then exit;

  init1;
  init2;
  init3;
  init4;
end;

procedure IPPItest;
begin
  if not initIPPI then sortieErreur('unable to initialize IPP library');
end;

procedure IPPIend;
begin
  setPrecisionMode(pmExtended);
end;


end.
