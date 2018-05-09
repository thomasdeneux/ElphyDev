NE PAS UTILISER

unit ippvm;

/////////////////////////////////////////////////////////////////////////////
//
//                  INTEL CORPORATION PROPRIETARY INFORMATION
//     This software is supplied under the terms of a license agreement or
//     nondisclosure agreement with Intel Corporation and may not be copied
//     or disclosed except in accordance with the terms of that agreement.
//          Copyright(c) 2002-2011 Intel Corporation. All Rights Reserved.
//
//              Intel(R) Integrated Performance Primitives
//                          Vector Math (ippVM)
//
//


Interface
uses windows,math,
     util1, ippdefs;


//IPPAPI( const IppLibraryVersion*, ippvmGetLibVersion, (void) )

var

  ippsAbs_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAbs_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAdd_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAdd_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsSub_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSub_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsMul_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsMul_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;


  ippsInv_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInv_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInv_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInv_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsInv_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsInv_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsDiv_32f_A11: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsDiv_32f_A21: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsDiv_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsDiv_64f_A26: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsDiv_64f_A50: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsDiv_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsSqrt_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSqrt_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSqrt_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSqrt_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSqrt_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSqrt_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsInvSqrt_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInvSqrt_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInvSqrt_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInvSqrt_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsInvSqrt_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsInvSqrt_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsCbrt_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCbrt_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCbrt_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCbrt_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCbrt_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCbrt_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsInvCbrt_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInvCbrt_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInvCbrt_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsInvCbrt_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsInvCbrt_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsInvCbrt_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsPow_32f_A11: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow_32f_A21: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow_64f_A26: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPow_64f_A50: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPow_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsPow2o3_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow2o3_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow2o3_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow2o3_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPow2o3_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPow2o3_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsPow3o2_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow3o2_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow3o2_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPow3o2_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPow3o2_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPow3o2_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsSqr_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSqr_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsPowx_32f_A11: function( a: Psingle;const  b: single; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPowx_32f_A21: function( a: Psingle;const  b: single; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPowx_32f_A24: function( a: Psingle;const  b: single; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsPowx_64f_A26: function( a:Pdouble;const b: double; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPowx_64f_A50: function( a:Pdouble;const b: double; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsPowx_64f_A53: function( a:Pdouble;const b: double; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsExp_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsExp_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsExp_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsExp_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsExp_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsExp_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsExpm1_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsExpm1_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsExpm1_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsExpm1_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsExpm1_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsExpm1_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsLn_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLn_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLn_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLn_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsLn_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsLn_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsLog10_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLog10_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLog10_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLog10_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsLog10_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsLog10_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsLog1p_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLog1p_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLog1p_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsLog1p_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsLog1p_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsLog1p_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsCos_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCos_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCos_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCos_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCos_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCos_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsSin_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSin_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSin_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSin_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSin_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSin_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsSinCos_32f_A11: function( a: Psingle; r1: Psingle; r2: Psingle; n: integer): IPPstatus;cdecl;
  ippsSinCos_32f_A21: function( a: Psingle; r1: Psingle; r2: Psingle; n: integer): IPPstatus;cdecl;
  ippsSinCos_32f_A24: function( a: Psingle; r1: Psingle; r2: Psingle; n: integer): IPPstatus;cdecl;
  ippsSinCos_64f_A26: function( a:Pdouble; r1: Pdouble; r2: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSinCos_64f_A50: function( a:Pdouble; r1: Pdouble; r2: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSinCos_64f_A53: function( a:Pdouble; r1: Pdouble; r2: Pdouble; n: integer): IPPstatus;cdecl;

  ippsTan_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTan_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTan_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTan_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsTan_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsTan_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAcos_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAcos_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAcos_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAcos_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAcos_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAcos_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAsin_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAsin_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAsin_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAsin_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAsin_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAsin_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAtan_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtan_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtan_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtan_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAtan_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAtan_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAtan2_32f_A11: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtan2_32f_A21: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtan2_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtan2_64f_A26: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAtan2_64f_A50: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAtan2_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsCosh_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCosh_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCosh_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCosh_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCosh_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCosh_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsSinh_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSinh_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSinh_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsSinh_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSinh_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsSinh_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsTanh_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTanh_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTanh_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTanh_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsTanh_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsTanh_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAcosh_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAcosh_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAcosh_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAcosh_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAcosh_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAcosh_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAsinh_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAsinh_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAsinh_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAsinh_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAsinh_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAsinh_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAtanh_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtanh_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtanh_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAtanh_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAtanh_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAtanh_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsErf_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErf_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErf_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErf_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErf_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErf_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsErfInv_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfInv_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfInv_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfInv_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErfInv_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErfInv_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsErfc_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfc_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfc_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfc_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErfc_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErfc_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsErfcInv_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfcInv_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfcInv_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsErfcInv_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErfcInv_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsErfcInv_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsCdfNorm_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCdfNorm_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCdfNorm_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCdfNorm_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCdfNorm_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCdfNorm_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsCdfNormInv_32f_A11: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCdfNormInv_32f_A21: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCdfNormInv_32f_A24: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCdfNormInv_64f_A26: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCdfNormInv_64f_A50: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsCdfNormInv_64f_A53: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsHypot_32f_A11: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsHypot_32f_A21: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsHypot_32f_A24: function( a: Psingle;const  b: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsHypot_64f_A26: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsHypot_64f_A50: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsHypot_64f_A53: function( a:Pdouble;const  b: Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;



  ippsAbs_32fc_A11: function( a: PsingleComp; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAbs_32fc_A21: function( a: PsingleComp; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAbs_32fc_A24: function( a: PsingleComp; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsAbs_64fc_A26: function( a: PdoubleComp; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAbs_64fc_A50: function( a: PdoubleComp; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsAbs_64fc_A53: function( a: PdoubleComp; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsArg_32fc_A11: function( a: PsingleComp; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsArg_32fc_A21: function( a: PsingleComp; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsArg_32fc_A24: function( a: PsingleComp; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsArg_64fc_A26: function( a: PdoubleComp; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsArg_64fc_A50: function( a: PdoubleComp; r: Pdouble; n: integer): IPPstatus;cdecl;
  ippsArg_64fc_A53: function( a: PdoubleComp; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsAdd_32fc_A24: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAdd_64fc_A53: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsSub_32fc_A24: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSub_64fc_A53: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsMul_32fc_A11: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsMul_32fc_A21: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsMul_32fc_A24: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsMul_64fc_A26: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsMul_64fc_A50: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsMul_64fc_A53: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsDiv_32fc_A11: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsDiv_32fc_A21: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsDiv_32fc_A24: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsDiv_64fc_A26: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsDiv_64fc_A50: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsDiv_64fc_A53: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsCIS_32fc_A11: function( a: Psingle;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCIS_32fc_A21: function( a: Psingle;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCIS_32fc_A24: function( a: Psingle;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCIS_64fc_A26: function( a:Pdouble;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsCIS_64fc_A50: function( a:Pdouble;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsCIS_64fc_A53: function( a:Pdouble;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsConj_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsConj_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsMulByConj_32fc_A11: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsMulByConj_32fc_A21: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsMulByConj_32fc_A24: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsMulByConj_64fc_A26: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsMulByConj_64fc_A50: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsMulByConj_64fc_A53: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsCos_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCos_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCos_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCos_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsCos_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsCos_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsSin_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSin_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSin_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSin_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsSin_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsSin_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsTan_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsTan_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsTan_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsTan_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsTan_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsTan_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsCosh_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCosh_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCosh_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsCosh_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsCosh_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsCosh_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsSinh_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSinh_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSinh_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSinh_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsSinh_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsSinh_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsTanh_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsTanh_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsTanh_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsTanh_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsTanh_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsTanh_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsAcos_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAcos_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAcos_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAcos_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAcos_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAcos_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsAsin_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAsin_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAsin_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAsin_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAsin_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAsin_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsAtan_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAtan_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAtan_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAtan_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAtan_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAtan_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsAcosh_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAcosh_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAcosh_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAcosh_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAcosh_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAcosh_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsAsinh_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAsinh_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAsinh_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAsinh_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAsinh_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAsinh_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsAtanh_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAtanh_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAtanh_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsAtanh_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAtanh_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsAtanh_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsExp_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsExp_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsExp_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsExp_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsExp_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsExp_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsLn_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsLn_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsLn_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsLn_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsLn_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsLn_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsLog10_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsLog10_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsLog10_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsLog10_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsLog10_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsLog10_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsSqrt_32fc_A11: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSqrt_32fc_A21: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSqrt_32fc_A24: function( a: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsSqrt_64fc_A26: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsSqrt_64fc_A50: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsSqrt_64fc_A53: function( a: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsPow_32fc_A11: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsPow_32fc_A21: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsPow_32fc_A24: function( a: PsingleComp;const b: PsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsPow_64fc_A26: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsPow_64fc_A50: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsPow_64fc_A53: function( a: PdoubleComp;const b: PdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;

  ippsPowx_32fc_A11: function( a: PsingleComp;const  b: TsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsPowx_32fc_A21: function( a: PsingleComp;const  b: TsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsPowx_32fc_A24: function( a: PsingleComp;const  b: TsingleComp;r: PsingleComp; n: integer): IPPstatus;cdecl;
  ippsPowx_64fc_A26: function( a: PdoubleComp;const  b: TdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsPowx_64fc_A50: function( a: PdoubleComp;const  b: TdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;
  ippsPowx_64fc_A53: function( a: PdoubleComp;const  b: TdoubleComp;r: PdoubleComp; n: integer): IPPstatus;cdecl;



  ippsFloor_32f: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsFloor_64f: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsCeil_32f: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsCeil_64f: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsTrunc_32f: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsTrunc_64f: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsRound_32f: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsRound_64f: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsRint_32f: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsRint_64f: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsNearbyInt_32f: function( a: Psingle; r: Psingle; n: integer): IPPstatus;cdecl;
  ippsNearbyInt_64f: function( a:Pdouble; r: Pdouble; n: integer): IPPstatus;cdecl;

  ippsModf_32f: function( a: Psingle; r1: Psingle; r2: Psingle; n: integer): IPPstatus;cdecl;
  ippsModf_64f: function( a:Pdouble; r1: Pdouble; r2: Pdouble; n: integer): IPPstatus;cdecl;


function fonctionErf(w: double):double;pascal;
function fonctionErfc(w: double):double;pascal;

function Erf(w: double):double;
function Erfc(w: double):double;


implementation

uses ncdef2;

Const
  DLLname1='ippvm-7.0.dll';

var
  hh: intG;

function InitIPPVM:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(AppDir+'IPP\'+DLLname1);

  result:=(hh<>0);
  if not result then exit;

  ippsAbs_32f_A24:= getProc(hh, 'ippsAbs_32f_A24');
  ippsAbs_64f_A53:= getProc(hh, 'ippsAbs_64f_A53');

  ippsAdd_32f_A24:= getProc(hh, 'ippsAdd_32f_A24');
  ippsAdd_64f_A53:= getProc(hh, 'ippsAdd_64f_A53');

  ippsSub_32f_A24:= getProc(hh, 'ippsSub_32f_A24');
  ippsSub_64f_A53:= getProc(hh, 'ippsSub_64f_A53');

  ippsMul_32f_A24:= getProc(hh, 'ippsMul_32f_A24');
  ippsMul_64f_A53:= getProc(hh, 'ippsMul_64f_A53');

  ippsInv_32f_A11:= getProc(hh, 'ippsInv_32f_A11');
  ippsInv_32f_A21:= getProc(hh, 'ippsInv_32f_A21');
  ippsInv_32f_A24:= getProc(hh, 'ippsInv_32f_A24');
  ippsInv_64f_A26:= getProc(hh, 'ippsInv_64f_A26');
  ippsInv_64f_A50:= getProc(hh, 'ippsInv_64f_A50');
  ippsInv_64f_A53:= getProc(hh, 'ippsInv_64f_A53');

  ippsDiv_32f_A11:= getProc(hh, 'ippsDiv_32f_A11');
  ippsDiv_32f_A21:= getProc(hh, 'ippsDiv_32f_A21');
  ippsDiv_32f_A24:= getProc(hh, 'ippsDiv_32f_A24');
  ippsDiv_64f_A26:= getProc(hh, 'ippsDiv_64f_A26');
  ippsDiv_64f_A50:= getProc(hh, 'ippsDiv_64f_A50');
  ippsDiv_64f_A53:= getProc(hh, 'ippsDiv_64f_A53');

  ippsSqrt_32f_A11:= getProc(hh, 'ippsSqrt_32f_A11');
  ippsSqrt_32f_A21:= getProc(hh, 'ippsSqrt_32f_A21');
  ippsSqrt_32f_A24:= getProc(hh, 'ippsSqrt_32f_A24');
  ippsSqrt_64f_A26:= getProc(hh, 'ippsSqrt_64f_A26');
  ippsSqrt_64f_A50:= getProc(hh, 'ippsSqrt_64f_A50');
  ippsSqrt_64f_A53:= getProc(hh, 'ippsSqrt_64f_A53');

  ippsInvSqrt_32f_A11:= getProc(hh, 'ippsInvSqrt_32f_A11');
  ippsInvSqrt_32f_A21:= getProc(hh, 'ippsInvSqrt_32f_A21');
  ippsInvSqrt_32f_A24:= getProc(hh, 'ippsInvSqrt_32f_A24');
  ippsInvSqrt_64f_A26:= getProc(hh, 'ippsInvSqrt_64f_A26');
  ippsInvSqrt_64f_A50:= getProc(hh, 'ippsInvSqrt_64f_A50');
  ippsInvSqrt_64f_A53:= getProc(hh, 'ippsInvSqrt_64f_A53');

  ippsCbrt_32f_A11:= getProc(hh, 'ippsCbrt_32f_A11');
  ippsCbrt_32f_A21:= getProc(hh, 'ippsCbrt_32f_A21');
  ippsCbrt_32f_A24:= getProc(hh, 'ippsCbrt_32f_A24');
  ippsCbrt_64f_A26:= getProc(hh, 'ippsCbrt_64f_A26');
  ippsCbrt_64f_A50:= getProc(hh, 'ippsCbrt_64f_A50');
  ippsCbrt_64f_A53:= getProc(hh, 'ippsCbrt_64f_A53');

  ippsInvCbrt_32f_A11:= getProc(hh, 'ippsInvCbrt_32f_A11');
  ippsInvCbrt_32f_A21:= getProc(hh, 'ippsInvCbrt_32f_A21');
  ippsInvCbrt_32f_A24:= getProc(hh, 'ippsInvCbrt_32f_A24');
  ippsInvCbrt_64f_A26:= getProc(hh, 'ippsInvCbrt_64f_A26');
  ippsInvCbrt_64f_A50:= getProc(hh, 'ippsInvCbrt_64f_A50');
  ippsInvCbrt_64f_A53:= getProc(hh, 'ippsInvCbrt_64f_A53');

  ippsPow_32f_A11:= getProc(hh, 'ippsPow_32f_A11');
  ippsPow_32f_A21:= getProc(hh, 'ippsPow_32f_A21');
  ippsPow_32f_A24:= getProc(hh, 'ippsPow_32f_A24');
  ippsPow_64f_A26:= getProc(hh, 'ippsPow_64f_A26');
  ippsPow_64f_A50:= getProc(hh, 'ippsPow_64f_A50');
  ippsPow_64f_A53:= getProc(hh, 'ippsPow_64f_A53');

  ippsPow2o3_32f_A11:= getProc(hh, 'ippsPow2o3_32f_A11');
  ippsPow2o3_32f_A21:= getProc(hh, 'ippsPow2o3_32f_A21');
  ippsPow2o3_32f_A24:= getProc(hh, 'ippsPow2o3_32f_A24');
  ippsPow2o3_64f_A26:= getProc(hh, 'ippsPow2o3_64f_A26');
  ippsPow2o3_64f_A50:= getProc(hh, 'ippsPow2o3_64f_A50');
  ippsPow2o3_64f_A53:= getProc(hh, 'ippsPow2o3_64f_A53');

  ippsPow3o2_32f_A11:= getProc(hh, 'ippsPow3o2_32f_A11');
  ippsPow3o2_32f_A21:= getProc(hh, 'ippsPow3o2_32f_A21');
  ippsPow3o2_32f_A24:= getProc(hh, 'ippsPow3o2_32f_A24');
  ippsPow3o2_64f_A26:= getProc(hh, 'ippsPow3o2_64f_A26');
  ippsPow3o2_64f_A50:= getProc(hh, 'ippsPow3o2_64f_A50');
  ippsPow3o2_64f_A53:= getProc(hh, 'ippsPow3o2_64f_A53');

  ippsSqr_32f_A24:= getProc(hh, 'ippsSqr_32f_A24');
  ippsSqr_64f_A53:= getProc(hh, 'ippsSqr_64f_A53');

  ippsPowx_32f_A11:= getProc(hh, 'ippsPowx_32f_A11');
  ippsPowx_32f_A21:= getProc(hh, 'ippsPowx_32f_A21');
  ippsPowx_32f_A24:= getProc(hh, 'ippsPowx_32f_A24');
  ippsPowx_64f_A26:= getProc(hh, 'ippsPowx_64f_A26');
  ippsPowx_64f_A50:= getProc(hh, 'ippsPowx_64f_A50');
  ippsPowx_64f_A53:= getProc(hh, 'ippsPowx_64f_A53');

  ippsExp_32f_A11:= getProc(hh, 'ippsExp_32f_A11');
  ippsExp_32f_A21:= getProc(hh, 'ippsExp_32f_A21');
  ippsExp_32f_A24:= getProc(hh, 'ippsExp_32f_A24');
  ippsExp_64f_A26:= getProc(hh, 'ippsExp_64f_A26');
  ippsExp_64f_A50:= getProc(hh, 'ippsExp_64f_A50');
  ippsExp_64f_A53:= getProc(hh, 'ippsExp_64f_A53');

  ippsExpm1_32f_A11:= getProc(hh, 'ippsExpm1_32f_A11');
  ippsExpm1_32f_A21:= getProc(hh, 'ippsExpm1_32f_A21');
  ippsExpm1_32f_A24:= getProc(hh, 'ippsExpm1_32f_A24');
  ippsExpm1_64f_A26:= getProc(hh, 'ippsExpm1_64f_A26');
  ippsExpm1_64f_A50:= getProc(hh, 'ippsExpm1_64f_A50');
  ippsExpm1_64f_A53:= getProc(hh, 'ippsExpm1_64f_A53');

  ippsLn_32f_A11:= getProc(hh, 'ippsLn_32f_A11');
  ippsLn_32f_A21:= getProc(hh, 'ippsLn_32f_A21');
  ippsLn_32f_A24:= getProc(hh, 'ippsLn_32f_A24');
  ippsLn_64f_A26:= getProc(hh, 'ippsLn_64f_A26');
  ippsLn_64f_A50:= getProc(hh, 'ippsLn_64f_A50');
  ippsLn_64f_A53:= getProc(hh, 'ippsLn_64f_A53');

  ippsLog10_32f_A11:= getProc(hh, 'ippsLog10_32f_A11');
  ippsLog10_32f_A21:= getProc(hh, 'ippsLog10_32f_A21');
  ippsLog10_32f_A24:= getProc(hh, 'ippsLog10_32f_A24');
  ippsLog10_64f_A26:= getProc(hh, 'ippsLog10_64f_A26');
  ippsLog10_64f_A50:= getProc(hh, 'ippsLog10_64f_A50');
  ippsLog10_64f_A53:= getProc(hh, 'ippsLog10_64f_A53');

  ippsLog1p_32f_A11:= getProc(hh, 'ippsLog1p_32f_A11');
  ippsLog1p_32f_A21:= getProc(hh, 'ippsLog1p_32f_A21');
  ippsLog1p_32f_A24:= getProc(hh, 'ippsLog1p_32f_A24');
  ippsLog1p_64f_A26:= getProc(hh, 'ippsLog1p_64f_A26');
  ippsLog1p_64f_A50:= getProc(hh, 'ippsLog1p_64f_A50');
  ippsLog1p_64f_A53:= getProc(hh, 'ippsLog1p_64f_A53');

  ippsCos_32f_A11:= getProc(hh, 'ippsCos_32f_A11');
  ippsCos_32f_A21:= getProc(hh, 'ippsCos_32f_A21');
  ippsCos_32f_A24:= getProc(hh, 'ippsCos_32f_A24');
  ippsCos_64f_A26:= getProc(hh, 'ippsCos_64f_A26');
  ippsCos_64f_A50:= getProc(hh, 'ippsCos_64f_A50');
  ippsCos_64f_A53:= getProc(hh, 'ippsCos_64f_A53');

  ippsSin_32f_A11:= getProc(hh, 'ippsSin_32f_A11');
  ippsSin_32f_A21:= getProc(hh, 'ippsSin_32f_A21');
  ippsSin_32f_A24:= getProc(hh, 'ippsSin_32f_A24');
  ippsSin_64f_A26:= getProc(hh, 'ippsSin_64f_A26');
  ippsSin_64f_A50:= getProc(hh, 'ippsSin_64f_A50');
  ippsSin_64f_A53:= getProc(hh, 'ippsSin_64f_A53');

  ippsSinCos_32f_A11:= getProc(hh, 'ippsSinCos_32f_A11');
  ippsSinCos_32f_A21:= getProc(hh, 'ippsSinCos_32f_A21');
  ippsSinCos_32f_A24:= getProc(hh, 'ippsSinCos_32f_A24');
  ippsSinCos_64f_A26:= getProc(hh, 'ippsSinCos_64f_A26');
  ippsSinCos_64f_A50:= getProc(hh, 'ippsSinCos_64f_A50');
  ippsSinCos_64f_A53:= getProc(hh, 'ippsSinCos_64f_A53');

  ippsTan_32f_A11:= getProc(hh, 'ippsTan_32f_A11');
  ippsTan_32f_A21:= getProc(hh, 'ippsTan_32f_A21');
  ippsTan_32f_A24:= getProc(hh, 'ippsTan_32f_A24');
  ippsTan_64f_A26:= getProc(hh, 'ippsTan_64f_A26');
  ippsTan_64f_A50:= getProc(hh, 'ippsTan_64f_A50');
  ippsTan_64f_A53:= getProc(hh, 'ippsTan_64f_A53');

  ippsAcos_32f_A11:= getProc(hh, 'ippsAcos_32f_A11');
  ippsAcos_32f_A21:= getProc(hh, 'ippsAcos_32f_A21');
  ippsAcos_32f_A24:= getProc(hh, 'ippsAcos_32f_A24');
  ippsAcos_64f_A26:= getProc(hh, 'ippsAcos_64f_A26');
  ippsAcos_64f_A50:= getProc(hh, 'ippsAcos_64f_A50');
  ippsAcos_64f_A53:= getProc(hh, 'ippsAcos_64f_A53');

  ippsAsin_32f_A11:= getProc(hh, 'ippsAsin_32f_A11');
  ippsAsin_32f_A21:= getProc(hh, 'ippsAsin_32f_A21');
  ippsAsin_32f_A24:= getProc(hh, 'ippsAsin_32f_A24');
  ippsAsin_64f_A26:= getProc(hh, 'ippsAsin_64f_A26');
  ippsAsin_64f_A50:= getProc(hh, 'ippsAsin_64f_A50');
  ippsAsin_64f_A53:= getProc(hh, 'ippsAsin_64f_A53');

  ippsAtan_32f_A11:= getProc(hh, 'ippsAtan_32f_A11');
  ippsAtan_32f_A21:= getProc(hh, 'ippsAtan_32f_A21');
  ippsAtan_32f_A24:= getProc(hh, 'ippsAtan_32f_A24');
  ippsAtan_64f_A26:= getProc(hh, 'ippsAtan_64f_A26');
  ippsAtan_64f_A50:= getProc(hh, 'ippsAtan_64f_A50');
  ippsAtan_64f_A53:= getProc(hh, 'ippsAtan_64f_A53');

  ippsAtan2_32f_A11:= getProc(hh, 'ippsAtan2_32f_A11');
  ippsAtan2_32f_A21:= getProc(hh, 'ippsAtan2_32f_A21');
  ippsAtan2_32f_A24:= getProc(hh, 'ippsAtan2_32f_A24');
  ippsAtan2_64f_A26:= getProc(hh, 'ippsAtan2_64f_A26');
  ippsAtan2_64f_A50:= getProc(hh, 'ippsAtan2_64f_A50');
  ippsAtan2_64f_A53:= getProc(hh, 'ippsAtan2_64f_A53');

  ippsCosh_32f_A11:= getProc(hh, 'ippsCosh_32f_A11');
  ippsCosh_32f_A21:= getProc(hh, 'ippsCosh_32f_A21');
  ippsCosh_32f_A24:= getProc(hh, 'ippsCosh_32f_A24');
  ippsCosh_64f_A26:= getProc(hh, 'ippsCosh_64f_A26');
  ippsCosh_64f_A50:= getProc(hh, 'ippsCosh_64f_A50');
  ippsCosh_64f_A53:= getProc(hh, 'ippsCosh_64f_A53');

  ippsSinh_32f_A11:= getProc(hh, 'ippsSinh_32f_A11');
  ippsSinh_32f_A21:= getProc(hh, 'ippsSinh_32f_A21');
  ippsSinh_32f_A24:= getProc(hh, 'ippsSinh_32f_A24');
  ippsSinh_64f_A26:= getProc(hh, 'ippsSinh_64f_A26');
  ippsSinh_64f_A50:= getProc(hh, 'ippsSinh_64f_A50');
  ippsSinh_64f_A53:= getProc(hh, 'ippsSinh_64f_A53');

  ippsTanh_32f_A11:= getProc(hh, 'ippsTanh_32f_A11');
  ippsTanh_32f_A21:= getProc(hh, 'ippsTanh_32f_A21');
  ippsTanh_32f_A24:= getProc(hh, 'ippsTanh_32f_A24');
  ippsTanh_64f_A26:= getProc(hh, 'ippsTanh_64f_A26');
  ippsTanh_64f_A50:= getProc(hh, 'ippsTanh_64f_A50');
  ippsTanh_64f_A53:= getProc(hh, 'ippsTanh_64f_A53');

  ippsAcosh_32f_A11:= getProc(hh, 'ippsAcosh_32f_A11');
  ippsAcosh_32f_A21:= getProc(hh, 'ippsAcosh_32f_A21');
  ippsAcosh_32f_A24:= getProc(hh, 'ippsAcosh_32f_A24');
  ippsAcosh_64f_A26:= getProc(hh, 'ippsAcosh_64f_A26');
  ippsAcosh_64f_A50:= getProc(hh, 'ippsAcosh_64f_A50');
  ippsAcosh_64f_A53:= getProc(hh, 'ippsAcosh_64f_A53');

  ippsAsinh_32f_A11:= getProc(hh, 'ippsAsinh_32f_A11');
  ippsAsinh_32f_A21:= getProc(hh, 'ippsAsinh_32f_A21');
  ippsAsinh_32f_A24:= getProc(hh, 'ippsAsinh_32f_A24');
  ippsAsinh_64f_A26:= getProc(hh, 'ippsAsinh_64f_A26');
  ippsAsinh_64f_A50:= getProc(hh, 'ippsAsinh_64f_A50');
  ippsAsinh_64f_A53:= getProc(hh, 'ippsAsinh_64f_A53');

  ippsAtanh_32f_A11:= getProc(hh, 'ippsAtanh_32f_A11');
  ippsAtanh_32f_A21:= getProc(hh, 'ippsAtanh_32f_A21');
  ippsAtanh_32f_A24:= getProc(hh, 'ippsAtanh_32f_A24');
  ippsAtanh_64f_A26:= getProc(hh, 'ippsAtanh_64f_A26');
  ippsAtanh_64f_A50:= getProc(hh, 'ippsAtanh_64f_A50');
  ippsAtanh_64f_A53:= getProc(hh, 'ippsAtanh_64f_A53');

  ippsErf_32f_A11:= getProc(hh, 'ippsErf_32f_A11');
  ippsErf_32f_A21:= getProc(hh, 'ippsErf_32f_A21');
  ippsErf_32f_A24:= getProc(hh, 'ippsErf_32f_A24');
  ippsErf_64f_A26:= getProc(hh, 'ippsErf_64f_A26');
  ippsErf_64f_A50:= getProc(hh, 'ippsErf_64f_A50');
  ippsErf_64f_A53:= getProc(hh, 'ippsErf_64f_A53');

  ippsErfInv_32f_A11:= getProc(hh, 'ippsErfInv_32f_A11');
  ippsErfInv_32f_A21:= getProc(hh, 'ippsErfInv_32f_A21');
  ippsErfInv_32f_A24:= getProc(hh, 'ippsErfInv_32f_A24');
  ippsErfInv_64f_A26:= getProc(hh, 'ippsErfInv_64f_A26');
  ippsErfInv_64f_A50:= getProc(hh, 'ippsErfInv_64f_A50');
  ippsErfInv_64f_A53:= getProc(hh, 'ippsErfInv_64f_A53');

  ippsErfc_32f_A11:= getProc(hh, 'ippsErfc_32f_A11');
  ippsErfc_32f_A21:= getProc(hh, 'ippsErfc_32f_A21');
  ippsErfc_32f_A24:= getProc(hh, 'ippsErfc_32f_A24');
  ippsErfc_64f_A26:= getProc(hh, 'ippsErfc_64f_A26');
  ippsErfc_64f_A50:= getProc(hh, 'ippsErfc_64f_A50');
  ippsErfc_64f_A53:= getProc(hh, 'ippsErfc_64f_A53');

  ippsErfcInv_32f_A11:= getProc(hh, 'ippsErfcInv_32f_A11');
  ippsErfcInv_32f_A21:= getProc(hh, 'ippsErfcInv_32f_A21');
  ippsErfcInv_32f_A24:= getProc(hh, 'ippsErfcInv_32f_A24');
  ippsErfcInv_64f_A26:= getProc(hh, 'ippsErfcInv_64f_A26');
  ippsErfcInv_64f_A50:= getProc(hh, 'ippsErfcInv_64f_A50');
  ippsErfcInv_64f_A53:= getProc(hh, 'ippsErfcInv_64f_A53');

  ippsCdfNorm_32f_A11:= getProc(hh, 'ippsCdfNorm_32f_A11');
  ippsCdfNorm_32f_A21:= getProc(hh, 'ippsCdfNorm_32f_A21');
  ippsCdfNorm_32f_A24:= getProc(hh, 'ippsCdfNorm_32f_A24');
  ippsCdfNorm_64f_A26:= getProc(hh, 'ippsCdfNorm_64f_A26');
  ippsCdfNorm_64f_A50:= getProc(hh, 'ippsCdfNorm_64f_A50');
  ippsCdfNorm_64f_A53:= getProc(hh, 'ippsCdfNorm_64f_A53');

  ippsCdfNormInv_32f_A11:= getProc(hh, 'ippsCdfNormInv_32f_A11');
  ippsCdfNormInv_32f_A21:= getProc(hh, 'ippsCdfNormInv_32f_A21');
  ippsCdfNormInv_32f_A24:= getProc(hh, 'ippsCdfNormInv_32f_A24');
  ippsCdfNormInv_64f_A26:= getProc(hh, 'ippsCdfNormInv_64f_A26');
  ippsCdfNormInv_64f_A50:= getProc(hh, 'ippsCdfNormInv_64f_A50');
  ippsCdfNormInv_64f_A53:= getProc(hh, 'ippsCdfNormInv_64f_A53');

  ippsHypot_32f_A11:= getProc(hh, 'ippsHypot_32f_A11');
  ippsHypot_32f_A21:= getProc(hh, 'ippsHypot_32f_A21');
  ippsHypot_32f_A24:= getProc(hh, 'ippsHypot_32f_A24');
  ippsHypot_64f_A26:= getProc(hh, 'ippsHypot_64f_A26');
  ippsHypot_64f_A50:= getProc(hh, 'ippsHypot_64f_A50');
  ippsHypot_64f_A53:= getProc(hh, 'ippsHypot_64f_A53');

  ippsAbs_32fc_A11:= getProc(hh, 'ippsAbs_32fc_A11');
  ippsAbs_32fc_A21:= getProc(hh, 'ippsAbs_32fc_A21');
  ippsAbs_32fc_A24:= getProc(hh, 'ippsAbs_32fc_A24');
  ippsAbs_64fc_A26:= getProc(hh, 'ippsAbs_64fc_A26');
  ippsAbs_64fc_A50:= getProc(hh, 'ippsAbs_64fc_A50');
  ippsAbs_64fc_A53:= getProc(hh, 'ippsAbs_64fc_A53');

  ippsArg_32fc_A11:= getProc(hh, 'ippsArg_32fc_A11');
  ippsArg_32fc_A21:= getProc(hh, 'ippsArg_32fc_A21');
  ippsArg_32fc_A24:= getProc(hh, 'ippsArg_32fc_A24');
  ippsArg_64fc_A26:= getProc(hh, 'ippsArg_64fc_A26');
  ippsArg_64fc_A50:= getProc(hh, 'ippsArg_64fc_A50');
  ippsArg_64fc_A53:= getProc(hh, 'ippsArg_64fc_A53');

  ippsAdd_32fc_A24:= getProc(hh, 'ippsAdd_32fc_A24');
  ippsAdd_64fc_A53:= getProc(hh, 'ippsAdd_64fc_A53');

  ippsSub_32fc_A24:= getProc(hh, 'ippsSub_32fc_A24');
  ippsSub_64fc_A53:= getProc(hh, 'ippsSub_64fc_A53');

  ippsMul_32fc_A11:= getProc(hh, 'ippsMul_32fc_A11');
  ippsMul_32fc_A21:= getProc(hh, 'ippsMul_32fc_A21');
  ippsMul_32fc_A24:= getProc(hh, 'ippsMul_32fc_A24');
  ippsMul_64fc_A26:= getProc(hh, 'ippsMul_64fc_A26');
  ippsMul_64fc_A50:= getProc(hh, 'ippsMul_64fc_A50');
  ippsMul_64fc_A53:= getProc(hh, 'ippsMul_64fc_A53');

  ippsDiv_32fc_A11:= getProc(hh, 'ippsDiv_32fc_A11');
  ippsDiv_32fc_A21:= getProc(hh, 'ippsDiv_32fc_A21');
  ippsDiv_32fc_A24:= getProc(hh, 'ippsDiv_32fc_A24');
  ippsDiv_64fc_A26:= getProc(hh, 'ippsDiv_64fc_A26');
  ippsDiv_64fc_A50:= getProc(hh, 'ippsDiv_64fc_A50');
  ippsDiv_64fc_A53:= getProc(hh, 'ippsDiv_64fc_A53');

  ippsCIS_32fc_A11:= getProc(hh, 'ippsCIS_32fc_A11');
  ippsCIS_32fc_A21:= getProc(hh, 'ippsCIS_32fc_A21');
  ippsCIS_32fc_A24:= getProc(hh, 'ippsCIS_32fc_A24');
  ippsCIS_64fc_A26:= getProc(hh, 'ippsCIS_64fc_A26');
  ippsCIS_64fc_A50:= getProc(hh, 'ippsCIS_64fc_A50');
  ippsCIS_64fc_A53:= getProc(hh, 'ippsCIS_64fc_A53');

  ippsConj_32fc_A24:= getProc(hh, 'ippsConj_32fc_A24');
  ippsConj_64fc_A53:= getProc(hh, 'ippsConj_64fc_A53');

  ippsMulByConj_32fc_A11:= getProc(hh, 'ippsMulByConj_32fc_A11');
  ippsMulByConj_32fc_A21:= getProc(hh, 'ippsMulByConj_32fc_A21');
  ippsMulByConj_32fc_A24:= getProc(hh, 'ippsMulByConj_32fc_A24');
  ippsMulByConj_64fc_A26:= getProc(hh, 'ippsMulByConj_64fc_A26');
  ippsMulByConj_64fc_A50:= getProc(hh, 'ippsMulByConj_64fc_A50');
  ippsMulByConj_64fc_A53:= getProc(hh, 'ippsMulByConj_64fc_A53');

  ippsCos_32fc_A11:= getProc(hh, 'ippsCos_32fc_A11');
  ippsCos_32fc_A21:= getProc(hh, 'ippsCos_32fc_A21');
  ippsCos_32fc_A24:= getProc(hh, 'ippsCos_32fc_A24');
  ippsCos_64fc_A26:= getProc(hh, 'ippsCos_64fc_A26');
  ippsCos_64fc_A50:= getProc(hh, 'ippsCos_64fc_A50');
  ippsCos_64fc_A53:= getProc(hh, 'ippsCos_64fc_A53');

  ippsSin_32fc_A11:= getProc(hh, 'ippsSin_32fc_A11');
  ippsSin_32fc_A21:= getProc(hh, 'ippsSin_32fc_A21');
  ippsSin_32fc_A24:= getProc(hh, 'ippsSin_32fc_A24');
  ippsSin_64fc_A26:= getProc(hh, 'ippsSin_64fc_A26');
  ippsSin_64fc_A50:= getProc(hh, 'ippsSin_64fc_A50');
  ippsSin_64fc_A53:= getProc(hh, 'ippsSin_64fc_A53');

  ippsTan_32fc_A11:= getProc(hh, 'ippsTan_32fc_A11');
  ippsTan_32fc_A21:= getProc(hh, 'ippsTan_32fc_A21');
  ippsTan_32fc_A24:= getProc(hh, 'ippsTan_32fc_A24');
  ippsTan_64fc_A26:= getProc(hh, 'ippsTan_64fc_A26');
  ippsTan_64fc_A50:= getProc(hh, 'ippsTan_64fc_A50');
  ippsTan_64fc_A53:= getProc(hh, 'ippsTan_64fc_A53');

  ippsCosh_32fc_A11:= getProc(hh, 'ippsCosh_32fc_A11');
  ippsCosh_32fc_A21:= getProc(hh, 'ippsCosh_32fc_A21');
  ippsCosh_32fc_A24:= getProc(hh, 'ippsCosh_32fc_A24');
  ippsCosh_64fc_A26:= getProc(hh, 'ippsCosh_64fc_A26');
  ippsCosh_64fc_A50:= getProc(hh, 'ippsCosh_64fc_A50');
  ippsCosh_64fc_A53:= getProc(hh, 'ippsCosh_64fc_A53');

  ippsSinh_32fc_A11:= getProc(hh, 'ippsSinh_32fc_A11');
  ippsSinh_32fc_A21:= getProc(hh, 'ippsSinh_32fc_A21');
  ippsSinh_32fc_A24:= getProc(hh, 'ippsSinh_32fc_A24');
  ippsSinh_64fc_A26:= getProc(hh, 'ippsSinh_64fc_A26');
  ippsSinh_64fc_A50:= getProc(hh, 'ippsSinh_64fc_A50');
  ippsSinh_64fc_A53:= getProc(hh, 'ippsSinh_64fc_A53');

  ippsTanh_32fc_A11:= getProc(hh, 'ippsTanh_32fc_A11');
  ippsTanh_32fc_A21:= getProc(hh, 'ippsTanh_32fc_A21');
  ippsTanh_32fc_A24:= getProc(hh, 'ippsTanh_32fc_A24');
  ippsTanh_64fc_A26:= getProc(hh, 'ippsTanh_64fc_A26');
  ippsTanh_64fc_A50:= getProc(hh, 'ippsTanh_64fc_A50');
  ippsTanh_64fc_A53:= getProc(hh, 'ippsTanh_64fc_A53');

  ippsAcos_32fc_A11:= getProc(hh, 'ippsAcos_32fc_A11');
  ippsAcos_32fc_A21:= getProc(hh, 'ippsAcos_32fc_A21');
  ippsAcos_32fc_A24:= getProc(hh, 'ippsAcos_32fc_A24');
  ippsAcos_64fc_A26:= getProc(hh, 'ippsAcos_64fc_A26');
  ippsAcos_64fc_A50:= getProc(hh, 'ippsAcos_64fc_A50');
  ippsAcos_64fc_A53:= getProc(hh, 'ippsAcos_64fc_A53');

  ippsAsin_32fc_A11:= getProc(hh, 'ippsAsin_32fc_A11');
  ippsAsin_32fc_A21:= getProc(hh, 'ippsAsin_32fc_A21');
  ippsAsin_32fc_A24:= getProc(hh, 'ippsAsin_32fc_A24');
  ippsAsin_64fc_A26:= getProc(hh, 'ippsAsin_64fc_A26');
  ippsAsin_64fc_A50:= getProc(hh, 'ippsAsin_64fc_A50');
  ippsAsin_64fc_A53:= getProc(hh, 'ippsAsin_64fc_A53');

  ippsAtan_32fc_A11:= getProc(hh, 'ippsAtan_32fc_A11');
  ippsAtan_32fc_A21:= getProc(hh, 'ippsAtan_32fc_A21');
  ippsAtan_32fc_A24:= getProc(hh, 'ippsAtan_32fc_A24');
  ippsAtan_64fc_A26:= getProc(hh, 'ippsAtan_64fc_A26');
  ippsAtan_64fc_A50:= getProc(hh, 'ippsAtan_64fc_A50');
  ippsAtan_64fc_A53:= getProc(hh, 'ippsAtan_64fc_A53');

  ippsAcosh_32fc_A11:= getProc(hh, 'ippsAcosh_32fc_A11');
  ippsAcosh_32fc_A21:= getProc(hh, 'ippsAcosh_32fc_A21');
  ippsAcosh_32fc_A24:= getProc(hh, 'ippsAcosh_32fc_A24');
  ippsAcosh_64fc_A26:= getProc(hh, 'ippsAcosh_64fc_A26');
  ippsAcosh_64fc_A50:= getProc(hh, 'ippsAcosh_64fc_A50');
  ippsAcosh_64fc_A53:= getProc(hh, 'ippsAcosh_64fc_A53');

  ippsAsinh_32fc_A11:= getProc(hh, 'ippsAsinh_32fc_A11');
  ippsAsinh_32fc_A21:= getProc(hh, 'ippsAsinh_32fc_A21');
  ippsAsinh_32fc_A24:= getProc(hh, 'ippsAsinh_32fc_A24');
  ippsAsinh_64fc_A26:= getProc(hh, 'ippsAsinh_64fc_A26');
  ippsAsinh_64fc_A50:= getProc(hh, 'ippsAsinh_64fc_A50');
  ippsAsinh_64fc_A53:= getProc(hh, 'ippsAsinh_64fc_A53');

  ippsAtanh_32fc_A11:= getProc(hh, 'ippsAtanh_32fc_A11');
  ippsAtanh_32fc_A21:= getProc(hh, 'ippsAtanh_32fc_A21');
  ippsAtanh_32fc_A24:= getProc(hh, 'ippsAtanh_32fc_A24');
  ippsAtanh_64fc_A26:= getProc(hh, 'ippsAtanh_64fc_A26');
  ippsAtanh_64fc_A50:= getProc(hh, 'ippsAtanh_64fc_A50');
  ippsAtanh_64fc_A53:= getProc(hh, 'ippsAtanh_64fc_A53');

  ippsExp_32fc_A11:= getProc(hh, 'ippsExp_32fc_A11');
  ippsExp_32fc_A21:= getProc(hh, 'ippsExp_32fc_A21');
  ippsExp_32fc_A24:= getProc(hh, 'ippsExp_32fc_A24');
  ippsExp_64fc_A26:= getProc(hh, 'ippsExp_64fc_A26');
  ippsExp_64fc_A50:= getProc(hh, 'ippsExp_64fc_A50');
  ippsExp_64fc_A53:= getProc(hh, 'ippsExp_64fc_A53');

  ippsLn_32fc_A11:= getProc(hh, 'ippsLn_32fc_A11');
  ippsLn_32fc_A21:= getProc(hh, 'ippsLn_32fc_A21');
  ippsLn_32fc_A24:= getProc(hh, 'ippsLn_32fc_A24');
  ippsLn_64fc_A26:= getProc(hh, 'ippsLn_64fc_A26');
  ippsLn_64fc_A50:= getProc(hh, 'ippsLn_64fc_A50');
  ippsLn_64fc_A53:= getProc(hh, 'ippsLn_64fc_A53');

  ippsLog10_32fc_A11:= getProc(hh, 'ippsLog10_32fc_A11');
  ippsLog10_32fc_A21:= getProc(hh, 'ippsLog10_32fc_A21');
  ippsLog10_32fc_A24:= getProc(hh, 'ippsLog10_32fc_A24');
  ippsLog10_64fc_A26:= getProc(hh, 'ippsLog10_64fc_A26');
  ippsLog10_64fc_A50:= getProc(hh, 'ippsLog10_64fc_A50');
  ippsLog10_64fc_A53:= getProc(hh, 'ippsLog10_64fc_A53');

  ippsSqrt_32fc_A11:= getProc(hh, 'ippsSqrt_32fc_A11');
  ippsSqrt_32fc_A21:= getProc(hh, 'ippsSqrt_32fc_A21');
  ippsSqrt_32fc_A24:= getProc(hh, 'ippsSqrt_32fc_A24');
  ippsSqrt_64fc_A26:= getProc(hh, 'ippsSqrt_64fc_A26');
  ippsSqrt_64fc_A50:= getProc(hh, 'ippsSqrt_64fc_A50');
  ippsSqrt_64fc_A53:= getProc(hh, 'ippsSqrt_64fc_A53');

  ippsPow_32fc_A11:= getProc(hh, 'ippsPow_32fc_A11');
  ippsPow_32fc_A21:= getProc(hh, 'ippsPow_32fc_A21');
  ippsPow_32fc_A24:= getProc(hh, 'ippsPow_32fc_A24');
  ippsPow_64fc_A26:= getProc(hh, 'ippsPow_64fc_A26');
  ippsPow_64fc_A50:= getProc(hh, 'ippsPow_64fc_A50');
  ippsPow_64fc_A53:= getProc(hh, 'ippsPow_64fc_A53');

  ippsPowx_32fc_A11:= getProc(hh, 'ippsPowx_32fc_A11');
  ippsPowx_32fc_A21:= getProc(hh, 'ippsPowx_32fc_A21');
  ippsPowx_32fc_A24:= getProc(hh, 'ippsPowx_32fc_A24');
  ippsPowx_64fc_A26:= getProc(hh, 'ippsPowx_64fc_A26');
  ippsPowx_64fc_A50:= getProc(hh, 'ippsPowx_64fc_A50');
  ippsPowx_64fc_A53:= getProc(hh, 'ippsPowx_64fc_A53');

  ippsFloor_32f:= getProc(hh, 'ippsFloor_32f');
  ippsFloor_64f:= getProc(hh, 'ippsFloor_64f');

  ippsCeil_32f:= getProc(hh, 'ippsCeil_32f');
  ippsCeil_64f:= getProc(hh, 'ippsCeil_64f');

  ippsTrunc_32f:= getProc(hh, 'ippsTrunc_32f');
  ippsTrunc_64f:= getProc(hh, 'ippsTrunc_64f');

  ippsRound_32f:= getProc(hh, 'ippsRound_32f');
  ippsRound_64f:= getProc(hh, 'ippsRound_64f');

  ippsRint_32f:= getProc(hh, 'ippsRint_32f');
  ippsRint_64f:= getProc(hh, 'ippsRint_64f');

  ippsNearbyInt_32f:= getProc(hh, 'ippsNearbyInt_32f');
  ippsNearbyInt_64f:= getProc(hh, 'ippsNearbyInt_64f');

  ippsModf_32f:= getProc(hh, 'ippsModf_32f');
  ippsModf_64f:= getProc(hh, 'ippsModf_64f');

end;


procedure freeIPPVM;
begin
  if hh<>0 then freeLibrary(hh);
  hh:=0;
end;

//var
//  FPUmask:TFPUexceptionMask;

procedure IPPVMtest;
Const
  First:boolean=true;
begin
//  FPUmask:=getExceptionMask;

  if not initIPPVM then
  begin
    if First then
    begin
      messageCentral('Unable to initialize IPP library');
      First:=false;
    end;
    sortieErreur('Unable to initialize IPP library');
  end;
end;

procedure IPPVMend;
begin
  setPrecisionMode(pmExtended);
  //SetExceptionMask([exInvalidOp, exDenormalized, exUnderflow])
end;

//*******************************************************************************************************

function fonctionErf(w: double):double;
var
  res:double;
begin
  IPPVMtest;
  if ippsErf_64f_A53( @w, @res,1)<>0 then sortieErreur('Erf error');
  result:=res;
  IPPVMend;
end;

function fonctionErfc(w: double):double;
var
  res:double;
begin
  IPPVMtest;
  if ippsErfc_64f_A53( @w, @res,1)<>0 then sortieErreur('Erf error');
  result:=res;
  IPPVMend;
end;

function Erf(w: double):double;
begin
  result:= fonctionErf(w);
end;

function Erfc(w: double):double;
begin
  result:= fonctionErfc(w);
end;


end.
