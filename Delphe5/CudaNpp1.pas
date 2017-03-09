unit CudaNpp1;

interface

uses math,util1, Ncdef2;

type
  Npp8u  = byte;
  Npp16u = word;
  Npp32u = longword;

  Npp8s  = shortint;
  Npp16s = smallint;
  Npp32s = longint;

  Npp32f = single;
  Npp64s = int64;
  Npp64u = int64;          { uint64 n'existe pas }
  Npp64f = double;

  Npp8sc = record
             re: Npp8s;
             Im: Npp8s;
           end;

  Npp16sc =record
             re: Npp16s;
             Im: Npp16s;
           end;

  Npp32sc =record
             re: Npp32s;
             Im: Npp32s;
           end;

  Npp32fc = TsingleComp;
           {
           record
             re: Npp32f;
             Im: Npp32f;
           end;
           }
  Npp64sc =record
             re: Npp64s;
             Im: Npp64s;
           end;

  Npp64fc = TdoubleComp;
           {
           record
             re: Npp64f;
             Im: Npp64f;
           end;
           }
  PNpp8u =  Pbyte; {^Npp8u;}
  PNpp16u = Pword; {^Npp16u;}
  PNpp32u = Plongword; {^Npp32u;}

  PNpp8s =  Pshortint; {^Npp8s;}
  PNpp16s = Psmallint; { ^Npp16s;}
  PNpp32s = Plongint; {^Npp32s;}

  PNpp32f = {^Npp32f;}Psingle;
  PNpp64s = ^Npp64s;
  PNpp64u = ^Npp64u;
  PNpp64f = {^Npp64f}Pdouble;

  PNpp8sc = ^Npp8sc;

  PNpp16sc = ^Npp16sc;

  PNpp32sc = ^Npp32sc;

  PNpp32fc = {^Npp32fc;}PsingleComp;

  PNpp64sc = ^Npp64sc;

  PNpp64fc = {^Npp64fc;}PdoubleComp;

  NppStatus =  integer;   (* errors *)

var

//  NppsAddC_16s_I: function(val:Npp16s;pSrcDst:PNpp16s;len:longint):Nppstatus;stdcall;
//  NppsSubC_16s_I: function(val:Npp16s;pSrcDst:PNpp16s;len:longint):Nppstatus;stdcall;
//  NppsMulC_16s_I: function(val:Npp16s;pSrcDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsAddC_32f_I: function(val:Npp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsAddC_32fc_I: function(val:Npp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsSubC_32f_I: function(val:Npp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSubC_32fc_I: function(val:Npp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsSubCRev_32f_I: function(val:Npp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSubCRev_32fc_I: function(val:Npp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsMulC_32f_I: function(val:Npp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsMulC_32fc_I: function(val:Npp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsAddC_64f_I: function(val:Npp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsAddC_64fc_I: function(val:Npp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsSubC_64f_I: function(val:Npp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsSubC_64fc_I: function(val:Npp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsSubCRev_64f_I: function(val:Npp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsSubCRev_64fc_I: function(val:Npp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsMulC_64f_I: function(val:Npp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsMulC_64fc_I: function(val:Npp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;

  NppsMulC_32f16s_Sfs: function(pSrc:PNpp32f;val:Npp32f;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_Low_32f16s: function(pSrc:PNpp32f;val:Npp32f;pDst:PNpp16s;len:longint):Nppstatus;stdcall;


  NppsAddC_8u_ISfs: function(val:Npp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_8u_ISfs: function(val:Npp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_8u_ISfs: function(val:Npp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_8u_ISfs: function(val:Npp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_16s_ISfs: function(val:Npp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_16s_ISfs: function(val:Npp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_16s_ISfs: function(val:Npp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_16sc_ISfs: function(val:Npp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_16sc_ISfs: function(val:Npp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_16sc_ISfs: function(val:Npp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_16s_ISfs: function(val:Npp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_16sc_ISfs: function(val:Npp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_32s_ISfs: function(val:Npp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_32sc_ISfs: function(val:Npp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_32s_ISfs: function(val:Npp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_32sc_ISfs: function(val:Npp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_32s_ISfs: function(val:Npp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_32sc_ISfs: function(val:Npp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_32s_ISfs: function(val:Npp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_32sc_ISfs: function(val:Npp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;

  NppsAddC_32f: function(pSrc:PNpp32f;val:Npp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsAddC_32fc: function(pSrc:PNpp32fc;val:Npp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsSubC_32f: function(pSrc:PNpp32f;val:Npp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSubC_32fc: function(pSrc:PNpp32fc;val:Npp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsSubCRev_32f: function(pSrc:PNpp32f;val:Npp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSubCRev_32fc: function(pSrc:PNpp32fc;val:Npp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsMulC_32f: function(pSrc:PNpp32f;val:Npp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsMulC_32fc: function(pSrc:PNpp32fc;val:Npp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsAddC_64f: function(pSrc:PNpp64f;val:Npp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsAddC_64fc: function(pSrc:PNpp64fc;val:Npp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsSubC_64f: function(pSrc:PNpp64f;val:Npp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsSubC_64fc: function(pSrc:PNpp64fc;val:Npp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsSubCRev_64f: function(pSrc:PNpp64f;val:Npp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsSubCRev_64fc: function(pSrc:PNpp64fc;val:Npp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsMulC_64f: function(pSrc:PNpp64f;val:Npp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsMulC_64fc: function(pSrc:PNpp64fc;val:Npp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;

  NppsAddC_8u_Sfs: function(pSrc:PNpp8u;val:Npp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_8u_Sfs: function(pSrc:PNpp8u;val:Npp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_8u_Sfs: function(pSrc:PNpp8u;val:Npp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_8u_Sfs: function(pSrc:PNpp8u;val:Npp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_16s_Sfs: function(pSrc:PNpp16s;val:Npp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_16sc_Sfs: function(pSrc:PNpp16sc;val:Npp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_16s_Sfs: function(pSrc:PNpp16s;val:Npp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_16sc_Sfs: function(pSrc:PNpp16sc;val:Npp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_16s_Sfs: function(pSrc:PNpp16s;val:Npp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_16sc_Sfs: function(pSrc:PNpp16sc;val:Npp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_16s_Sfs: function(pSrc:PNpp16s;val:Npp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_16sc_Sfs: function(pSrc:PNpp16sc;val:Npp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_32s_Sfs: function(pSrc:PNpp32s;val:Npp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAddC_32sc_Sfs: function(pSrc:PNpp32sc;val:Npp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_32s_Sfs: function(pSrc:PNpp32s;val:Npp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubC_32sc_Sfs: function(pSrc:PNpp32sc;val:Npp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_32s_Sfs: function(pSrc:PNpp32s;val:Npp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSubCRev_32sc_Sfs: function(pSrc:PNpp32sc;val:Npp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_32s_Sfs: function(pSrc:PNpp32s;val:Npp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMulC_32sc_Sfs: function(pSrc:PNpp32sc;val:Npp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;

  NppsAdd_16s_I: function(pSrc:PNpp16s;pSrcDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsSub_16s_I: function(pSrc:PNpp16s;pSrcDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsMul_16s_I: function(pSrc:PNpp16s;pSrcDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsAdd_32f_I: function(pSrc:PNpp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsAdd_32fc_I: function(pSrc:PNpp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsSub_32f_I: function(pSrc:PNpp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSub_32fc_I: function(pSrc:PNpp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsMul_32f_I: function(pSrc:PNpp32f;pSrcDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsMul_32fc_I: function(pSrc:PNpp32fc;pSrcDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsAdd_64f_I: function(pSrc:PNpp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsAdd_64fc_I: function(pSrc:PNpp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsSub_64f_I: function(pSrc:PNpp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsSub_64fc_I: function(pSrc:PNpp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsMul_64f_I: function(pSrc:PNpp64f;pSrcDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsMul_64fc_I: function(pSrc:PNpp64fc;pSrcDst:PNpp64fc;len:longint):Nppstatus;stdcall;


  NppsAdd_8u_ISfs: function(pSrc:PNpp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_8u_ISfs: function(pSrc:PNpp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_8u_ISfs: function(pSrc:PNpp8u;pSrcDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_16s_ISfs: function(pSrc:PNpp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_16sc_ISfs: function(pSrc:PNpp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_16s_ISfs: function(pSrc:PNpp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_16sc_ISfs: function(pSrc:PNpp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_16s_ISfs: function(pSrc:PNpp16s;pSrcDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_16sc_ISfs: function(pSrc:PNpp16sc;pSrcDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_32s_ISfs: function(pSrc:PNpp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_32sc_ISfs: function(pSrc:PNpp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_32s_ISfs: function(pSrc:PNpp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_32sc_ISfs: function(pSrc:PNpp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_32s_ISfs: function(pSrc:PNpp32s;pSrcDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_32sc_ISfs: function(pSrc:PNpp32sc;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_8u16u: function(pSrc1:PNpp8u;pSrc2:PNpp8u;pDst:PNpp16u;len:longint):Nppstatus;stdcall;
  NppsMul_8u16u: function(pSrc1:PNpp8u;pSrc2:PNpp8u;pDst:PNpp16u;len:longint):Nppstatus;stdcall;
  NppsAdd_16s: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsSub_16s: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsMul_16s: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp16s;len:longint):Nppstatus;stdcall;
  NppsAdd_16u: function(pSrc1:PNpp16u;pSrc2:PNpp16u;pDst:PNpp16u;len:longint):Nppstatus;stdcall;
  NppsAdd_32u: function(pSrc1:PNpp32u;pSrc2:PNpp32u;pDst:PNpp32u;len:longint):Nppstatus;stdcall;
  NppsAdd_16s32f: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSub_16s32f: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsMul_16s32f: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsAdd_32f: function(pSrc1:PNpp32f;pSrc2:PNpp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsAdd_32fc: function(pSrc1:PNpp32fc;pSrc2:PNpp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsSub_32f: function(pSrc1:PNpp32f;pSrc2:PNpp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsSub_32fc: function(pSrc1:PNpp32fc;pSrc2:PNpp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsMul_32f: function(pSrc1:PNpp32f;pSrc2:PNpp32f;pDst:PNpp32f;len:longint):Nppstatus;stdcall;
  NppsMul_32fc: function(pSrc1:PNpp32fc;pSrc2:PNpp32fc;pDst:PNpp32fc;len:longint):Nppstatus;stdcall;
  NppsAdd_64f: function(pSrc1:PNpp64f;pSrc2:PNpp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsAdd_64fc: function(pSrc1:PNpp64fc;pSrc2:PNpp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsSub_64f: function(pSrc1:PNpp64f;pSrc2:PNpp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsSub_64fc: function(pSrc1:PNpp64fc;pSrc2:PNpp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;
  NppsMul_64f: function(pSrc1:PNpp64f;pSrc2:PNpp64f;pDst:PNpp64f;len:longint):Nppstatus;stdcall;
  NppsMul_64fc: function(pSrc1:PNpp64fc;pSrc2:PNpp64fc;pDst:PNpp64fc;len:longint):Nppstatus;stdcall;

  NppsAdd_8u_Sfs: function(pSrc1:PNpp8u;pSrc2:PNpp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_8u_Sfs: function(pSrc1:PNpp8u;pSrc2:PNpp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_8u_Sfs: function(pSrc1:PNpp8u;pSrc2:PNpp8u;pDst:PNpp8u;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_16s_Sfs: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_16sc_Sfs: function(pSrc1:PNpp16sc;pSrc2:PNpp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_16s_Sfs: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_16sc_Sfs: function(pSrc1:PNpp16sc;pSrc2:PNpp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_16s_Sfs: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_16sc_Sfs: function(pSrc1:PNpp16sc;pSrc2:PNpp16sc;pDst:PNpp16sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_16s32s_Sfs: function(pSrc1:PNpp16s;pSrc2:PNpp16s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_32s_Sfs: function(pSrc1:PNpp32s;pSrc2:PNpp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsAdd_32sc_Sfs: function(pSrc1:PNpp32sc;pSrc2:PNpp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_32s_Sfs: function(pSrc1:PNpp32s;pSrc2:PNpp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsSub_32sc_Sfs: function(pSrc1:PNpp32sc;pSrc2:PNpp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_32s_Sfs: function(pSrc1:PNpp32s;pSrc2:PNpp32s;pDst:PNpp32s;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_32sc_Sfs: function(pSrc1:PNpp32sc;pSrc2:PNpp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_16u16s_Sfs: function(pSrc1:PNpp16u;pSrc2:PNpp16s;pDst:PNpp16s;len:longint;scaleFactor:longint):Nppstatus;stdcall;


  NppsMul_32s32sc_ISfs: function(pSrc:PNpp32s;pSrcDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;
  NppsMul_32s32sc_Sfs: function(pSrc1:PNpp32s;pSrc2:PNpp32sc;pDst:PNpp32sc;len:longint;scaleFactor:longint):Nppstatus;stdcall;


function InitNPPS:boolean;
procedure NPPSend;

implementation

uses cudaRT1;

var
  hh:intG;

Const
  {$IFDEF Win64}
  DLLname1='npp64_50_35.dll';
  {$ELSE}
  DLLname1='npp32_50_35.dll';
  {$ENDIF}

procedure InitNpps1;
begin


//  nppsAddC_16s_I:=getProc(hh,'nppsAddC_16s_I',true);
//  nppsSubC_16s_I:=getProc(hh,'nppsSubC_16s_I',true);
//  nppsMulC_16s_I:=getProc(hh,'nppsMulC_16s_I',true);

  nppsAddC_32f_I:=getProc(hh,'nppsAddC_32f_I',true);
  nppsAddC_32fc_I:=getProc(hh,'nppsAddC_32fc_I',true);
  nppsSubC_32f_I:=getProc(hh,'nppsSubC_32f_I',true);
  nppsSubC_32fc_I:=getProc(hh,'nppsSubC_32fc_I',true);
  nppsSubCRev_32f_I:=getProc(hh,'nppsSubCRev_32f_I',true);
  nppsSubCRev_32fc_I:=getProc(hh,'nppsSubCRev_32fc_I',true);
  nppsMulC_32f_I:=getProc(hh,'nppsMulC_32f_I',true);
  nppsMulC_32fc_I:=getProc(hh,'nppsMulC_32fc_I',true);
  nppsAddC_64f_I:=getProc(hh,'nppsAddC_64f_I',true);
  nppsAddC_64fc_I:=getProc(hh,'nppsAddC_64fc_I',true);
  nppsSubC_64f_I:=getProc(hh,'nppsSubC_64f_I',true);
  nppsSubC_64fc_I:=getProc(hh,'nppsSubC_64fc_I',true);
  nppsSubCRev_64f_I:=getProc(hh,'nppsSubCRev_64f_I',true);
  nppsSubCRev_64fc_I:=getProc(hh,'nppsSubCRev_64fc_I',true);
  nppsMulC_64f_I:=getProc(hh,'nppsMulC_64f_I',true);
  nppsMulC_64fc_I:=getProc(hh,'nppsMulC_64fc_I',true);
  nppsMulC_32f16s_Sfs:=getProc(hh,'nppsMulC_32f16s_Sfs',true);
  nppsMulC_Low_32f16s:=getProc(hh,'nppsMulC_Low_32f16s',true);
  nppsAddC_8u_ISfs:=getProc(hh,'nppsAddC_8u_ISfs',true);
  nppsSubC_8u_ISfs:=getProc(hh,'nppsSubC_8u_ISfs',true);
  nppsSubCRev_8u_ISfs:=getProc(hh,'nppsSubCRev_8u_ISfs',true);
  nppsMulC_8u_ISfs:=getProc(hh,'nppsMulC_8u_ISfs',true);
  nppsAddC_16s_ISfs:=getProc(hh,'nppsAddC_16s_ISfs',true);
  nppsSubC_16s_ISfs:=getProc(hh,'nppsSubC_16s_ISfs',true);
  nppsMulC_16s_ISfs:=getProc(hh,'nppsMulC_16s_ISfs',true);
  nppsAddC_16sc_ISfs:=getProc(hh,'nppsAddC_16sc_ISfs',true);
  nppsSubC_16sc_ISfs:=getProc(hh,'nppsSubC_16sc_ISfs',true);
  nppsMulC_16sc_ISfs:=getProc(hh,'nppsMulC_16sc_ISfs',true);
  nppsSubCRev_16s_ISfs:=getProc(hh,'nppsSubCRev_16s_ISfs',true);
  nppsSubCRev_16sc_ISfs:=getProc(hh,'nppsSubCRev_16sc_ISfs',true);
  nppsAddC_32s_ISfs:=getProc(hh,'nppsAddC_32s_ISfs',true);
  nppsAddC_32sc_ISfs:=getProc(hh,'nppsAddC_32sc_ISfs',true);
  nppsSubC_32s_ISfs:=getProc(hh,'nppsSubC_32s_ISfs',true);
  nppsSubC_32sc_ISfs:=getProc(hh,'nppsSubC_32sc_ISfs',true);
  nppsSubCRev_32s_ISfs:=getProc(hh,'nppsSubCRev_32s_ISfs',true);
  nppsSubCRev_32sc_ISfs:=getProc(hh,'nppsSubCRev_32sc_ISfs',true);
  nppsMulC_32s_ISfs:=getProc(hh,'nppsMulC_32s_ISfs',true);
  nppsMulC_32sc_ISfs:=getProc(hh,'nppsMulC_32sc_ISfs',true);
  nppsAddC_32f:=getProc(hh,'nppsAddC_32f',true);
  nppsAddC_32fc:=getProc(hh,'nppsAddC_32fc',true);
  nppsSubC_32f:=getProc(hh,'nppsSubC_32f',true);
  nppsSubC_32fc:=getProc(hh,'nppsSubC_32fc',true);
  nppsSubCRev_32f:=getProc(hh,'nppsSubCRev_32f',true);
  nppsSubCRev_32fc:=getProc(hh,'nppsSubCRev_32fc',true);
  nppsMulC_32f:=getProc(hh,'nppsMulC_32f',true);
  nppsMulC_32fc:=getProc(hh,'nppsMulC_32fc',true);
  nppsAddC_64f:=getProc(hh,'nppsAddC_64f',true);
  nppsAddC_64fc:=getProc(hh,'nppsAddC_64fc',true);
  nppsSubC_64f:=getProc(hh,'nppsSubC_64f',true);
  nppsSubC_64fc:=getProc(hh,'nppsSubC_64fc',true);
  nppsSubCRev_64f:=getProc(hh,'nppsSubCRev_64f',true);
  nppsSubCRev_64fc:=getProc(hh,'nppsSubCRev_64fc',true);
  nppsMulC_64f:=getProc(hh,'nppsMulC_64f',true);
  nppsMulC_64fc:=getProc(hh,'nppsMulC_64fc',true);
  nppsAddC_8u_Sfs:=getProc(hh,'nppsAddC_8u_Sfs',true);
  nppsSubC_8u_Sfs:=getProc(hh,'nppsSubC_8u_Sfs',true);
  nppsSubCRev_8u_Sfs:=getProc(hh,'nppsSubCRev_8u_Sfs',true);
  nppsMulC_8u_Sfs:=getProc(hh,'nppsMulC_8u_Sfs',true);
  nppsAddC_16s_Sfs:=getProc(hh,'nppsAddC_16s_Sfs',true);
  nppsAddC_16sc_Sfs:=getProc(hh,'nppsAddC_16sc_Sfs',true);
  nppsSubC_16s_Sfs:=getProc(hh,'nppsSubC_16s_Sfs',true);
  nppsSubC_16sc_Sfs:=getProc(hh,'nppsSubC_16sc_Sfs',true);
  nppsSubCRev_16s_Sfs:=getProc(hh,'nppsSubCRev_16s_Sfs',true);
  nppsSubCRev_16sc_Sfs:=getProc(hh,'nppsSubCRev_16sc_Sfs',true);
  nppsMulC_16s_Sfs:=getProc(hh,'nppsMulC_16s_Sfs',true);
  nppsMulC_16sc_Sfs:=getProc(hh,'nppsMulC_16sc_Sfs',true);
  nppsAddC_32s_Sfs:=getProc(hh,'nppsAddC_32s_Sfs',true);
  nppsAddC_32sc_Sfs:=getProc(hh,'nppsAddC_32sc_Sfs',true);
  nppsSubC_32s_Sfs:=getProc(hh,'nppsSubC_32s_Sfs',true);
  nppsSubC_32sc_Sfs:=getProc(hh,'nppsSubC_32sc_Sfs',true);
  nppsSubCRev_32s_Sfs:=getProc(hh,'nppsSubCRev_32s_Sfs',true);
  nppsSubCRev_32sc_Sfs:=getProc(hh,'nppsSubCRev_32sc_Sfs',true);
  nppsMulC_32s_Sfs:=getProc(hh,'nppsMulC_32s_Sfs',true);
  nppsMulC_32sc_Sfs:=getProc(hh,'nppsMulC_32sc_Sfs',true);
  nppsAdd_16s_I:=getProc(hh,'nppsAdd_16s_I',true);
  nppsSub_16s_I:=getProc(hh,'nppsSub_16s_I',true);
  nppsMul_16s_I:=getProc(hh,'nppsMul_16s_I',true);
  nppsAdd_32f_I:=getProc(hh,'nppsAdd_32f_I',true);
  nppsAdd_32fc_I:=getProc(hh,'nppsAdd_32fc_I',true);
  nppsSub_32f_I:=getProc(hh,'nppsSub_32f_I',true);
  nppsSub_32fc_I:=getProc(hh,'nppsSub_32fc_I',true);
  nppsMul_32f_I:=getProc(hh,'nppsMul_32f_I',true);
  nppsMul_32fc_I:=getProc(hh,'nppsMul_32fc_I',true);
  nppsAdd_64f_I:=getProc(hh,'nppsAdd_64f_I',true);
  nppsAdd_64fc_I:=getProc(hh,'nppsAdd_64fc_I',true);
  nppsSub_64f_I:=getProc(hh,'nppsSub_64f_I',true);
  nppsSub_64fc_I:=getProc(hh,'nppsSub_64fc_I',true);
  nppsMul_64f_I:=getProc(hh,'nppsMul_64f_I',true);
  nppsMul_64fc_I:=getProc(hh,'nppsMul_64fc_I',true);
  nppsAdd_8u_ISfs:=getProc(hh,'nppsAdd_8u_ISfs',true);
  nppsSub_8u_ISfs:=getProc(hh,'nppsSub_8u_ISfs',true);
  nppsMul_8u_ISfs:=getProc(hh,'nppsMul_8u_ISfs',true);
  nppsAdd_16s_ISfs:=getProc(hh,'nppsAdd_16s_ISfs',true);
  nppsAdd_16sc_ISfs:=getProc(hh,'nppsAdd_16sc_ISfs',true);
  nppsSub_16s_ISfs:=getProc(hh,'nppsSub_16s_ISfs',true);
  nppsSub_16sc_ISfs:=getProc(hh,'nppsSub_16sc_ISfs',true);
  nppsMul_16s_ISfs:=getProc(hh,'nppsMul_16s_ISfs',true);
  nppsMul_16sc_ISfs:=getProc(hh,'nppsMul_16sc_ISfs',true);
  nppsAdd_32s_ISfs:=getProc(hh,'nppsAdd_32s_ISfs',true);
  nppsAdd_32sc_ISfs:=getProc(hh,'nppsAdd_32sc_ISfs',true);
  nppsSub_32s_ISfs:=getProc(hh,'nppsSub_32s_ISfs',true);
  nppsSub_32sc_ISfs:=getProc(hh,'nppsSub_32sc_ISfs',true);
  nppsMul_32s_ISfs:=getProc(hh,'nppsMul_32s_ISfs',true);
  nppsMul_32sc_ISfs:=getProc(hh,'nppsMul_32sc_ISfs',true);
  nppsAdd_8u16u:=getProc(hh,'nppsAdd_8u16u',true);
  nppsMul_8u16u:=getProc(hh,'nppsMul_8u16u',true);
  nppsAdd_16s:=getProc(hh,'nppsAdd_16s',true);
  nppsSub_16s:=getProc(hh,'nppsSub_16s',true);
  nppsMul_16s:=getProc(hh,'nppsMul_16s',true);
  nppsAdd_16u:=getProc(hh,'nppsAdd_16u',true);
  nppsAdd_32u:=getProc(hh,'nppsAdd_32u',true);
  nppsAdd_16s32f:=getProc(hh,'nppsAdd_16s32f',true);
  nppsSub_16s32f:=getProc(hh,'nppsSub_16s32f',true);
  nppsMul_16s32f:=getProc(hh,'nppsMul_16s32f',true);
  nppsAdd_32f:=getProc(hh,'nppsAdd_32f',true);
  nppsAdd_32fc:=getProc(hh,'nppsAdd_32fc',true);
  nppsSub_32f:=getProc(hh,'nppsSub_32f',true);
  nppsSub_32fc:=getProc(hh,'nppsSub_32fc',true);
  nppsMul_32f:=getProc(hh,'nppsMul_32f',true);
  nppsMul_32fc:=getProc(hh,'nppsMul_32fc',true);
  nppsAdd_64f:=getProc(hh,'nppsAdd_64f',true);
  nppsAdd_64fc:=getProc(hh,'nppsAdd_64fc',true);
  nppsSub_64f:=getProc(hh,'nppsSub_64f',true);
  nppsSub_64fc:=getProc(hh,'nppsSub_64fc',true);
  nppsMul_64f:=getProc(hh,'nppsMul_64f',true);
  nppsMul_64fc:=getProc(hh,'nppsMul_64fc',true);
  nppsAdd_8u_Sfs:=getProc(hh,'nppsAdd_8u_Sfs',true);
  nppsSub_8u_Sfs:=getProc(hh,'nppsSub_8u_Sfs',true);
  nppsMul_8u_Sfs:=getProc(hh,'nppsMul_8u_Sfs',true);
  nppsAdd_16s_Sfs:=getProc(hh,'nppsAdd_16s_Sfs',true);
  nppsAdd_16sc_Sfs:=getProc(hh,'nppsAdd_16sc_Sfs',true);
  nppsSub_16s_Sfs:=getProc(hh,'nppsSub_16s_Sfs',true);
  nppsSub_16sc_Sfs:=getProc(hh,'nppsSub_16sc_Sfs',true);
  nppsMul_16s_Sfs:=getProc(hh,'nppsMul_16s_Sfs',true);
  nppsMul_16sc_Sfs:=getProc(hh,'nppsMul_16sc_Sfs',true);
  nppsMul_16s32s_Sfs:=getProc(hh,'nppsMul_16s32s_Sfs',true);
  nppsAdd_32s_Sfs:=getProc(hh,'nppsAdd_32s_Sfs',true);
  nppsAdd_32sc_Sfs:=getProc(hh,'nppsAdd_32sc_Sfs',true);
  nppsSub_32s_Sfs:=getProc(hh,'nppsSub_32s_Sfs',true);
  nppsSub_32sc_Sfs:=getProc(hh,'nppsSub_32sc_Sfs',true);
  nppsMul_32s_Sfs:=getProc(hh,'nppsMul_32s_Sfs',true);
  nppsMul_32sc_Sfs:=getProc(hh,'nppsMul_32sc_Sfs',true);
  nppsMul_16u16s_Sfs:=getProc(hh,'nppsMul_16u16s_Sfs',true);
  nppsMul_32s32sc_ISfs:=getProc(hh,'nppsMul_32s32sc_ISfs',true);
  nppsMul_32s32sc_Sfs:=getProc(hh,'nppsMul_32s32sc_Sfs');
end;


function InitNPPS:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  result:= initCudaRT;
  if not result then exit;

  hh:=GloadLibrary(AppDir+'Cuda\'+DLLname1);

  result:=(hh<>0);
  if not result then exit;

  InitNpps1;
end;


procedure NPPSend;
begin
  setPrecisionMode(pmExtended);
end;




end.
