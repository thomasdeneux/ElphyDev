unit IPPI0      Ne plus utiliser , voir IPPI.pas IPPS.pas ;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows, sysutils,util1,Ncdef2,math;

{ Tiré de 'c:\Program Files\intel\ipp40\include\ippi.h'

  Data types:

    • 8u 8-bit, unsigned data
    • 8s 8-bit, signed data
    • 16u 16-bit, unsigned data
    • 16s 16-bit, signed data
    • 16sc 16-bit, complex short data
    Intel Integrated Performance Primitives Reference Manual: Volume 2 IPP Concepts 2
    • 32u 32-bit, unsigned data
    • 32s 32-bit, signed data
    • 32sc 32-bit, complex int data
    • 32f 32-bit, single-precision real floating point data
    • 32fc 32-bit, single-precision complex floating point data
    • 64s 64-bit, quadword signed data
    • 64f 64-bit, double-precision real floating point data

   Descriptors:

    The following descriptors are used in image and video processing functions:
    • A Data contains an alpha channel (always the last channel, requires C4,
    not processed)
    • Cn Data is made up of n discrete interleaved channels (1, 2, 3, 4)
    • C Channel of interest (COI) is used in the operation
    • D2 Image is two-dimensional
    • I Operation is in-place
    • M Uses mask ROI for source and destination images
    • Pn Data is made up of n discrete planar (non-interleaved) channels, with a
    separate pointer to each plane
    • R Uses region of interest (ROI)
    • Sfs Saturation and fixed scaling mode is used
}

type
  IppLibraryVersion = record
    major: integer;                     //* e.g. 1                               */
    minor: integer;                     //* e.g. 2                               */
    majorBuild: integer;                //* e.g. 3                               */
    build: integer;                     //* e.g. 10, always >= majorBuild        */
    targetCpu: array[0..3] of char;     //* corresponding to Intel(R) processor  */
    Name: Pansichar;                        //* e.g. "ippsw7"                        */
    Version:Pansichar;                      //* e.g. "v1.2 Beta"                     */
    BuildDate:Pansichar;                    //* e.g. "Jul 20 99"                     */
  end;


  Ipp8u  = byte;
  Ipp16u = word;
  Ipp32u = longword;

  Ipp8s  = shortint;
  Ipp16s = smallint;
  Ipp32s = longint;
  Ipp32f = single;
  Ipp64s = int64;
  Ipp64u = int64;
  Ipp64f = double;

  Ipp8sc = record
             re,im: Ipp8s;
           end;

  Ipp16sc= record
             re,im: Ipp16s;
           end;

  Ipp32sc= record
             re,im: Ipp32s;
           end;

  Ipp32fc= record
             re,im: Ipp32f;
           end;

  Ipp64sc= record
             re,im: Ipp64s;
           end;

  Ipp64fc= record
             re,im: Ipp64f;
           end;


  IppiPoint = Tpoint;
  IppiSize = record
               width,height:integer;
             end;

  IppiRect = record
               x,y,width,height:integer;
             end;

const
  ippMskSize1x3 = 13;
  ippMskSize1x5 = 15;
  ippMskSize3x1 = 31;
  ippMskSize3x3 = 33;
  ippMskSize5x1 = 51;
  ippMskSize5x5 = 55;
type
  IppiMaskSize=integer;

{
    Horizontal Prewitt operator                 3x3
    Vertical Prewitt operator                   3x3
    Horizontal Scharr operator                  3x3
    Vertical Scharr operator                    3x3
    Horizontal Sobel operator                   3x3 or 5x5
    Vertical Sobel operator                     3x3 or 5x5
    Second derivative horizontal Sobel operator 3x3 or 5x5
    Second derivative vertical Sobel operator   3x3 or 5x5
    Second cross derivative Sobel operator      3x3 or 5x5
    Horizontal Roberts operator                 3x3
    Vertical Roberts operator                   3x3
    Laplacian highpass filter                   3x3 or 5x5
    Gaussian lowpass filter                     3x3 or 5x5
    Highpass filter                             3x3 or 5x5
    Lowpass filter                              3x3 or 5x5
    Sharpening filter                           3x3
}

var
  ippiFilterPrewittHoriz_8u_C1R,
  ippiFilterPrewittHoriz_16s_C1R,
  ippiFilterPrewittHoriz_32f_C1R,
  ippiFilterPrewittHoriz_8u_C3R,
  ippiFilterPrewittHoriz_16s_C3R,
  ippiFilterPrewittHoriz_32f_C3R,
  ippiFilterPrewittHoriz_8u_C4R,
  ippiFilterPrewittHoriz_16s_C4R,
  ippiFilterPrewittHoriz_32f_C4R,
  ippiFilterPrewittHoriz_8u_AC4R,
  ippiFilterPrewittHoriz_16s_AC4R,
  ippiFilterPrewittHoriz_32f_AC4R: function( pSrc:pointer; srcStep: integer;
                                             pDst: pointer; dstStep: integer;
                                             dstROIsize: IppiSize): integer;stdCall;

  ippiFilterPrewittVert_8u_C1R,
  ippiFilterPrewittVert_16s_C1R,
  ippiFilterPrewittVert_32f_C1R,
  ippiFilterPrewittVert_8u_C3R,
  ippiFilterPrewittVert_16s_C3R,
  ippiFilterPrewittVert_32f_C3R,
  ippiFilterPrewittVert_8u_C4R,
  ippiFilterPrewittVert_16s_C4R,
  ippiFilterPrewittVert_32f_C4R,
  ippiFilterPrewittVert_8u_AC4R,
  ippiFilterPrewittVert_16s_AC4R,
  ippiFilterPrewittVert_32f_AC4R: function( pSrc:pointer; srcStep: integer;
                                             pDst: pointer; dstStep: integer;
                                             dstROIsize: IppiSize): integer;stdCall;


  ippiFilterScharrHoriz_8u16s_C1R,
  ippiFilterScharrHoriz_8s16s_C1R,
  ippiFilterScharrHoriz_32f_C1R: function( pSrc:pointer; srcStep: integer;
                                             pDst: pointer; dstStep: integer;
                                             dstROIsize: IppiSize): integer;stdCall;

  ippiFilterScharrVert_8u16s_C1R,
  ippiFilterScharrVert_8s16s_C1R,
  ippiFilterScharrVert_32f_C1R: function( pSrc:pointer; srcStep: integer;
                                             pDst: pointer; dstStep: integer;
                                             dstROIsize: IppiSize): integer;stdCall;


  ippiFilterSobelHoriz_8u_C1R,
  ippiFilterSobelHoriz_16s_C1R,
  ippiFilterSobelHoriz_32f_C1R,
  ippiFilterSobelHoriz_8u_C3R,
  ippiFilterSobelHoriz_16s_C3R,
  ippiFilterSobelHoriz_32f_C3R,
  ippiFilterSobelHoriz_8u_C4R,
  ippiFilterSobelHoriz_16s_C4R,
  ippiFilterSobelHoriz_32f_C4R,
  ippiFilterSobelHoriz_8u_AC4R,
  ippiFilterSobelHoriz_16s_AC4R,
  ippiFilterSobelHoriz_32f_AC4R: function( pSrc:pointer; srcStep: integer;
                                           pDst: pointer; dstStep: integer;
                                           dstROIsize: IppiSize): integer;stdCall;

  ippiFilterSobelHoriz_8u16s_C1R,
  ippiFilterSobelHoriz_8s16s_C1R,
  ippiFilterSobelHorizMask_32f_C1R: function( pSrc:pointer ; srcStep: integer;
                                              pDst:pointer;  dstStep: integer;
                                              dstRoiSize: IppiSize;
                                              mask: IppiMaskSize): integer;stdCall;

  ippiFilterSobelVert_8u_C1R,
  ippiFilterSobelVert_16s_C1R,
  ippiFilterSobelVert_32f_C1R,
  ippiFilterSobelVert_8u_C3R,
  ippiFilterSobelVert_16s_C3R,
  ippiFilterSobelVert_32f_C3R,
  ippiFilterSobelVert_8u_C4R,
  ippiFilterSobelVert_16s_C4R,
  ippiFilterSobelVert_32f_C4R,
  ippiFilterSobelVert_8u_AC4R,
  ippiFilterSobelVert_16s_AC4R,
  ippiFilterSobelVert_32f_AC4R: function( pSrc:pointer; srcStep: integer;
                                           pDst: pointer; dstStep: integer;
                                           dstROIsize: IppiSize): integer;stdCall;

  ippiFilterSobelVert_8u16s_C1R,
  ippiFilterSobelVert_8s16s_C1R,
  ippiFilterSobelVertMask_32f_C1R: function( pSrc:pointer ; srcStep: integer;
                                              pDst:pointer;  dstStep: integer;
                                              dstRoiSize: IppiSize;
                                              mask: IppiMaskSize): integer;stdCall;

  ippiFilterSobelHorizSecond_8u16s_C1R,
  ippiFilterSobelHorizSecond_8s16s_C1R,
  ippiFilterSobelHorizSecond_32f_C1R: function( pSrc:pointer ; srcStep: integer;
                                              pDst:pointer;  dstStep: integer;
                                              dstRoiSize: IppiSize;
                                              mask: IppiMaskSize): integer;stdCall;

  ippiFilterSobelVertSecond_8u16s_C1R,
  ippiFilterSobelVertSecond_8s16s_C1R,
  ippiFilterSobelVertSecond_32f_C1R: function( pSrc:pointer ; srcStep: integer;
                                              pDst:pointer;  dstStep: integer;
                                              dstRoiSize: IppiSize;
                                              mask: IppiMaskSize): integer;stdCall;


  ippiFilterSobelCross_8u16s_C1R,
  ippiFilterSobelCross_8s16s_C1R,
  ippiFilterSobelCross_32f_C1R: function( pSrc:pointer ; srcStep: integer;
                                          pDst:pointer;  dstStep: integer;
                                          dstRoiSize: IppiSize;
                                          mask: IppiMaskSize): integer;stdCall;

  ippiFilterRobertsDown_8u_C1R,
  ippiFilterRobertsDown_16s_C1R,
  ippiFilterRobertsDown_32f_C1R,
  ippiFilterRobertsDown_8u_C3R,
  ippiFilterRobertsDown_16s_C3R,
  ippiFilterRobertsDown_32f_C3R,
  ippiFilterRobertsDown_8u_AC4R,
  ippiFilterRobertsDown_16s_AC4R,
  ippiFilterRobertsDown_32f_AC4R: function( pSrc:pointer; srcStep: integer;
                                            pDst: pointer; dstStep: integer;
                                            dstROIsize: IppiSize): integer;stdCall;

  ippiFilterRobertsUp_8u_C1R,
  ippiFilterRobertsUp_16s_C1R,
  ippiFilterRobertsUp_32f_C1R,
  ippiFilterRobertsUp_8u_C3R,
  ippiFilterRobertsUp_16s_C3R,
  ippiFilterRobertsUp_32f_C3R,
  ippiFilterRobertsUp_8u_AC4R,
  ippiFilterRobertsUp_16s_AC4R,
  ippiFilterRobertsUp_32f_AC4R: function( pSrc:pointer; srcStep: integer;
                                            pDst: pointer; dstStep: integer;
                                            dstROIsize: IppiSize): integer;stdCall;


  ippiFilterLaplace_8u_C1R,
  ippiFilterLaplace_16s_C1R,
  ippiFilterLaplace_32f_C1R,
  ippiFilterLaplace_8u_C3R,
  ippiFilterLaplace_16s_C3R,
  ippiFilterLaplace_32f_C3R,
  ippiFilterLaplace_8u_C4R,
  ippiFilterLaplace_16s_C4R,
  ippiFilterLaplace_32f_C4R,
  ippiFilterLaplace_8u_AC4R,
  ippiFilterLaplace_16s_AC4R,
  ippiFilterLaplace_32f_AC4R,
  ippiFilterLaplace_8u16s_C1R,
  ippiFilterLaplace_8s16s_C1R: function( pSrc:pointer ; srcStep: integer;
                                      pDst:pointer;  dstStep: integer;
                                      dstRoiSize: IppiSize;
                                      mask: IppiMaskSize): integer;stdCall;

  ippiFilterGauss_8u_C1R,
  ippiFilterGauss_16s_C1R,
  ippiFilterGauss_32f_C1R,
  ippiFilterGauss_8u_C3R,
  ippiFilterGauss_16s_C3R,
  ippiFilterGauss_32f_C3R,
  ippiFilterGauss_8u_C4R,
  ippiFilterGauss_16s_C4R,
  ippiFilterGauss_32f_C4R,
  ippiFilterGauss_8u_AC4R,
  ippiFilterGauss_16s_AC4R,
  ippiFilterGauss_32f_AC4R: function( pSrc:pointer ; srcStep: integer;
                                      pDst:pointer;  dstStep: integer;
                                      dstRoiSize: IppiSize;
                                      mask: IppiMaskSize): integer;stdCall;

  ippiFilterHipass_8u_C1R,
  ippiFilterHipass_16s_C1R,
  ippiFilterHipass_32f_C1R,
  ippiFilterHipass_8u_C3R,
  ippiFilterHipass_16s_C3R,
  ippiFilterHipass_32f_C3R,
  ippiFilterHipass_8u_C4R,
  ippiFilterHipass_16s_C4R,
  ippiFilterHipass_32f_C4R,
  ippiFilterHipass_8u_AC4R,
  ippiFilterHipass_16s_AC4R,
  ippiFilterHipass_32f_AC4R: function( pSrc:pointer ; srcStep: integer;
                                      pDst:pointer;  dstStep: integer;
                                      dstRoiSize: IppiSize;
                                      mask: IppiMaskSize): integer;stdCall;

  ippiFilterLowpass_8u_C1R,
  ippiFilterLowpass_16s_C1R,
  ippiFilterLowpass_32f_C1R,
  ippiFilterLowpass_8u_C3R,
  ippiFilterLowpass_16s_C3R,
  ippiFilterLowpass_32f_C3R,
  ippiFilterLowpass_8u_AC4R,
  ippiFilterLowpass_16s_AC4R,
  ippiFilterLowpass_32f_AC4R: function( pSrc:pointer ; srcStep: integer;
                                      pDst:pointer;  dstStep: integer;
                                      dstRoiSize: IppiSize;
                                      mask: IppiMaskSize): integer;stdCall;

  ippiFilterSharpen_8u_C1R,
  ippiFilterSharpen_16s_C1R,
  ippiFilterSharpen_32f_C1R,
  ippiFilterSharpen_8u_C3R,
  ippiFilterSharpen_16s_C3R,
  ippiFilterSharpen_32f_C3R,
  ippiFilterSharpen_8u_C4R,
  ippiFilterSharpen_16s_C4R,
  ippiFilterSharpen_32f_C4R,
  ippiFilterSharpen_8u_AC4R,
  ippiFilterSharpen_16s_AC4R,
  ippiFilterSharpen_32f_AC4R: function( pSrc:pointer ; srcStep: integer;
                                      pDst:pointer;  dstStep: integer;
                                      dstRoiSize: IppiSize): integer;stdCall;


////////////////////////////////////////////////////////////////////////////
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
//      ippStsDivisorErr  Divisor is equal zero, function is aborted;
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


var
  ippiConvValid_32f_C1R,
  ippiConvValid_32f_C3R,
  ippiConvValid_32f_AC4R: function( pSrc1:pointer; src1Step:integer; Src1Size: IppiSize;
                                    pSrc2:pointer; src2Step:integer; src2Size:IppiSize;
                                    pDst:pointer; dstStep:integer): integer;stdcall;

  ippiConvValid_16s_C1R,
  ippiConvValid_16s_C3R,
  ippiConvValid_16s_AC4R,
  ippiConvValid_8u_C1R,
  ippiConvValid_8u_C3R,
  ippiConvValid_8u_AC4R: function( pSrc1:pointer; src1Step:integer; Src1Size: IppiSize;
                                    pSrc2:pointer; src2Step:integer; src2Size:IppiSize;
                                    pDst:pointer; dstStep:integer; divisor:integer): integer;stdcall;


  function InitIPPILib:boolean;
  Procedure FreeIPPI;

  procedure IPPtest;
  procedure IPPend;

implementation



function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
                {else messageCentral(st+' OK'); }
end;


var
  Ftried, FOK:boolean;
  hIPPI:integer;

function InitIPPILib:boolean;
begin
  if Ftried then
  begin
    result:=FOK;
    exit;
  end;

  Ftried:=true;
  FOK:=false;
  result:=FOK;

  hIPPI:=GloadLibrary('ippi20.dll');
  if hIPPI=0 then exit;

  FOK:=true;
  result:=FOK;

  ippiFilterPrewittHoriz_8u_C1R:= getProc(hIPPI,'ippiFilterPrewittHoriz_8u_C1R');
  ippiFilterPrewittHoriz_16s_C1R:= getProc(hIPPI,'ippiFilterPrewittHoriz_16s_C1R');
  ippiFilterPrewittHoriz_32f_C1R:= getProc(hIPPI,'ippiFilterPrewittHoriz_32f_C1R');
  ippiFilterPrewittHoriz_8u_C3R:= getProc(hIPPI,'ippiFilterPrewittHoriz_8u_C3R');
  ippiFilterPrewittHoriz_16s_C3R:= getProc(hIPPI,'ippiFilterPrewittHoriz_16s_C3R');
  ippiFilterPrewittHoriz_32f_C3R:= getProc(hIPPI,'ippiFilterPrewittHoriz_32f_C3R');
  ippiFilterPrewittHoriz_8u_C4R:= getProc(hIPPI,'ippiFilterPrewittHoriz_8u_C4R');
  ippiFilterPrewittHoriz_16s_C4R:= getProc(hIPPI,'ippiFilterPrewittHoriz_16s_C4R');
  ippiFilterPrewittHoriz_32f_C4R:= getProc(hIPPI,'ippiFilterPrewittHoriz_32f_C4R');
  ippiFilterPrewittHoriz_8u_AC4R:= getProc(hIPPI,'ippiFilterPrewittHoriz_8u_AC4R');
  ippiFilterPrewittHoriz_16s_AC4R:= getProc(hIPPI,'ippiFilterPrewittHoriz_16s_AC4R');
  ippiFilterPrewittHoriz_32f_AC4R:= getProc(hIPPI,'ippiFilterPrewittHoriz_32f_AC4R');

  ippiFilterPrewittVert_8u_C1R:= getProc(hIPPI,'ippiFilterPrewittVert_8u_C1R');
  ippiFilterPrewittVert_16s_C1R:= getProc(hIPPI,'ippiFilterPrewittVert_16s_C1R');
  ippiFilterPrewittVert_32f_C1R:= getProc(hIPPI,'ippiFilterPrewittVert_32f_C1R');
  ippiFilterPrewittVert_8u_C3R:= getProc(hIPPI,'ippiFilterPrewittVert_8u_C3R');
  ippiFilterPrewittVert_16s_C3R:= getProc(hIPPI,'ippiFilterPrewittVert_16s_C3R');
  ippiFilterPrewittVert_32f_C3R:= getProc(hIPPI,'ippiFilterPrewittVert_32f_C3R');
  ippiFilterPrewittVert_8u_C4R:= getProc(hIPPI,'ippiFilterPrewittVert_8u_C4R');
  ippiFilterPrewittVert_16s_C4R:= getProc(hIPPI,'ippiFilterPrewittVert_16s_C4R');
  ippiFilterPrewittVert_32f_C4R:= getProc(hIPPI,'ippiFilterPrewittVert_32f_C4R');
  ippiFilterPrewittVert_8u_AC4R:= getProc(hIPPI,'ippiFilterPrewittVert_8u_AC4R');
  ippiFilterPrewittVert_16s_AC4R:= getProc(hIPPI,'ippiFilterPrewittVert_16s_AC4R');
  ippiFilterPrewittVert_32f_AC4R:= getProc(hIPPI,'ippiFilterPrewittVert_32f_AC4R');

  ippiFilterScharrHoriz_8u16s_C1R:= getProc(hIPPI,'ippiFilterScharrHoriz_8u16s_C1R');
  ippiFilterScharrHoriz_8s16s_C1R:= getProc(hIPPI,'ippiFilterScharrHoriz_8s16s_C1R');
  ippiFilterScharrHoriz_32f_C1R:= getProc(hIPPI,'ippiFilterScharrHoriz_32f_C1R');

  ippiFilterScharrVert_8u16s_C1R:= getProc(hIPPI,'ippiFilterScharrVert_8u16s_C1R');
  ippiFilterScharrVert_8s16s_C1R:= getProc(hIPPI,'ippiFilterScharrVert_8s16s_C1R');
  ippiFilterScharrVert_32f_C1R:= getProc(hIPPI,'ippiFilterScharrVert_32f_C1R');

  ippiFilterSobelHoriz_8u_C1R:= getProc(hIPPI,'ippiFilterSobelHoriz_8u_C1R');
  ippiFilterSobelHoriz_16s_C1R:= getProc(hIPPI,'ippiFilterSobelHoriz_16s_C1R');
  ippiFilterSobelHoriz_32f_C1R:= getProc(hIPPI,'ippiFilterSobelHoriz_32f_C1R');
  ippiFilterSobelHoriz_8u_C3R:= getProc(hIPPI,'ippiFilterSobelHoriz_8u_C3R');
  ippiFilterSobelHoriz_16s_C3R:= getProc(hIPPI,'ippiFilterSobelHoriz_16s_C3R');
  ippiFilterSobelHoriz_32f_C3R:= getProc(hIPPI,'ippiFilterSobelHoriz_32f_C3R');
  ippiFilterSobelHoriz_8u_C4R:= getProc(hIPPI,'ippiFilterSobelHoriz_8u_C4R');
  ippiFilterSobelHoriz_16s_C4R:= getProc(hIPPI,'ippiFilterSobelHoriz_16s_C4R');
  ippiFilterSobelHoriz_32f_C4R:= getProc(hIPPI,'ippiFilterSobelHoriz_32f_C4R');
  ippiFilterSobelHoriz_8u_AC4R:= getProc(hIPPI,'ippiFilterSobelHoriz_8u_AC4R');
  ippiFilterSobelHoriz_16s_AC4R:= getProc(hIPPI,'ippiFilterSobelHoriz_16s_AC4R');
  ippiFilterSobelHoriz_32f_AC4R:= getProc(hIPPI,'ippiFilterSobelHoriz_32f_AC4R');

  ippiFilterSobelHoriz_8u16s_C1R:= getProc(hIPPI,'ippiFilterSobelHoriz_8u16s_C1R');
  ippiFilterSobelHoriz_8s16s_C1R:= getProc(hIPPI,'ippiFilterSobelHoriz_8s16s_C1R');
  ippiFilterSobelHorizMask_32f_C1R:= getProc(hIPPI,'ippiFilterSobelHorizMask_32f_C1R');

  ippiFilterSobelVert_8u_C1R:= getProc(hIPPI,'ippiFilterSobelVert_8u_C1R');
  ippiFilterSobelVert_16s_C1R:= getProc(hIPPI,'ippiFilterSobelVert_16s_C1R');
  ippiFilterSobelVert_32f_C1R:= getProc(hIPPI,'ippiFilterSobelVert_32f_C1R');
  ippiFilterSobelVert_8u_C3R:= getProc(hIPPI,'ippiFilterSobelVert_8u_C3R');
  ippiFilterSobelVert_16s_C3R:= getProc(hIPPI,'ippiFilterSobelVert_16s_C3R');
  ippiFilterSobelVert_32f_C3R:= getProc(hIPPI,'ippiFilterSobelVert_32f_C3R');
  ippiFilterSobelVert_8u_C4R:= getProc(hIPPI,'ippiFilterSobelVert_8u_C4R');
  ippiFilterSobelVert_16s_C4R:= getProc(hIPPI,'ippiFilterSobelVert_16s_C4R');
  ippiFilterSobelVert_32f_C4R:= getProc(hIPPI,'ippiFilterSobelVert_32f_C4R');
  ippiFilterSobelVert_8u_AC4R:= getProc(hIPPI,'ippiFilterSobelVert_8u_AC4R');
  ippiFilterSobelVert_16s_AC4R:= getProc(hIPPI,'ippiFilterSobelVert_16s_AC4R');
  ippiFilterSobelVert_32f_AC4R:= getProc(hIPPI,'ippiFilterSobelVert_32f_AC4R');

  ippiFilterSobelVert_8u16s_C1R:= getProc(hIPPI,'ippiFilterSobelVert_8u16s_C1R');
  ippiFilterSobelVert_8s16s_C1R:= getProc(hIPPI,'ippiFilterSobelVert_8s16s_C1R');
  ippiFilterSobelVertMask_32f_C1R:= getProc(hIPPI,'ippiFilterSobelVertMask_32f_C1R');

  ippiFilterSobelHorizSecond_8u16s_C1R:= getProc(hIPPI,'ippiFilterSobelHorizSecond_8u16s_C1R');
  ippiFilterSobelHorizSecond_8s16s_C1R:= getProc(hIPPI,'ippiFilterSobelHorizSecond_8s16s_C1R');
  ippiFilterSobelHorizSecond_32f_C1R:= getProc(hIPPI,'ippiFilterSobelHorizSecond_32f_C1R');

  ippiFilterSobelVertSecond_8u16s_C1R:= getProc(hIPPI,'ippiFilterSobelVertSecond_8u16s_C1R');
  ippiFilterSobelVertSecond_8s16s_C1R:= getProc(hIPPI,'ippiFilterSobelVertSecond_8s16s_C1R');
  ippiFilterSobelVertSecond_32f_C1R:= getProc(hIPPI,'ippiFilterSobelVertSecond_32f_C1R');

  ippiFilterSobelCross_8u16s_C1R:= getProc(hIPPI,'ippiFilterSobelCross_8u16s_C1R');
  ippiFilterSobelCross_8s16s_C1R:= getProc(hIPPI,'ippiFilterSobelCross_8s16s_C1R');
  ippiFilterSobelCross_32f_C1R:= getProc(hIPPI,'ippiFilterSobelCross_32f_C1R');

  ippiFilterRobertsDown_8u_C1R:= getProc(hIPPI,'ippiFilterRobertsDown_8u_C1R');
  ippiFilterRobertsDown_16s_C1R:= getProc(hIPPI,'ippiFilterRobertsDown_16s_C1R');
  ippiFilterRobertsDown_32f_C1R:= getProc(hIPPI,'ippiFilterRobertsDown_32f_C1R');
  ippiFilterRobertsDown_8u_C3R:= getProc(hIPPI,'ippiFilterRobertsDown_8u_C3R');
  ippiFilterRobertsDown_16s_C3R:= getProc(hIPPI,'ippiFilterRobertsDown_16s_C3R');
  ippiFilterRobertsDown_32f_C3R:= getProc(hIPPI,'ippiFilterRobertsDown_32f_C3R');
  ippiFilterRobertsDown_8u_AC4R:= getProc(hIPPI,'ippiFilterRobertsDown_8u_AC4R');
  ippiFilterRobertsDown_16s_AC4R:= getProc(hIPPI,'ippiFilterRobertsDown_16s_AC4R');
  ippiFilterRobertsDown_32f_AC4R:= getProc(hIPPI,'ippiFilterRobertsDown_32f_AC4R');

  ippiFilterRobertsUp_8u_C1R:= getProc(hIPPI,'ippiFilterRobertsUp_8u_C1R');
  ippiFilterRobertsUp_16s_C1R:= getProc(hIPPI,'ippiFilterRobertsUp_16s_C1R');
  ippiFilterRobertsUp_32f_C1R:= getProc(hIPPI,'ippiFilterRobertsUp_32f_C1R');
  ippiFilterRobertsUp_8u_C3R:= getProc(hIPPI,'ippiFilterRobertsUp_8u_C3R');
  ippiFilterRobertsUp_16s_C3R:= getProc(hIPPI,'ippiFilterRobertsUp_16s_C3R');
  ippiFilterRobertsUp_32f_C3R:= getProc(hIPPI,'ippiFilterRobertsUp_32f_C3R');
  ippiFilterRobertsUp_8u_AC4R:= getProc(hIPPI,'ippiFilterRobertsUp_8u_AC4R');
  ippiFilterRobertsUp_16s_AC4R:= getProc(hIPPI,'ippiFilterRobertsUp_16s_AC4R');
  ippiFilterRobertsUp_32f_AC4R:= getProc(hIPPI,'ippiFilterRobertsUp_32f_AC4R');

  ippiFilterLaplace_8u_C1R:= getProc(hIPPI,'ippiFilterLaplace_8u_C1R');
  ippiFilterLaplace_16s_C1R:= getProc(hIPPI,'ippiFilterLaplace_16s_C1R');
  ippiFilterLaplace_32f_C1R:= getProc(hIPPI,'ippiFilterLaplace_32f_C1R');
  ippiFilterLaplace_8u_C3R:= getProc(hIPPI,'ippiFilterLaplace_8u_C3R');
  ippiFilterLaplace_16s_C3R:= getProc(hIPPI,'ippiFilterLaplace_16s_C3R');
  ippiFilterLaplace_32f_C3R:= getProc(hIPPI,'ippiFilterLaplace_32f_C3R');
  ippiFilterLaplace_8u_C4R:= getProc(hIPPI,'ippiFilterLaplace_8u_C4R');
  ippiFilterLaplace_16s_C4R:= getProc(hIPPI,'ippiFilterLaplace_16s_C4R');
  ippiFilterLaplace_32f_C4R:= getProc(hIPPI,'ippiFilterLaplace_32f_C4R');
  ippiFilterLaplace_8u_AC4R:= getProc(hIPPI,'ippiFilterLaplace_8u_AC4R');
  ippiFilterLaplace_16s_AC4R:= getProc(hIPPI,'ippiFilterLaplace_16s_AC4R');
  ippiFilterLaplace_32f_AC4R:= getProc(hIPPI,'ippiFilterLaplace_32f_AC4R');
  ippiFilterLaplace_8u16s_C1R:= getProc(hIPPI,'ippiFilterLaplace_8u16s_C1R');
  ippiFilterLaplace_8s16s_C1R:= getProc(hIPPI,'ippiFilterLaplace_8s16s_C1R');

  ippiFilterGauss_8u_C1R:=getProc(hIPPI,'ippiFilterGauss_8u_C1R');
  ippiFilterGauss_16s_C1R:=getproc(hIPPI,'ippiFilterGauss_16s_C1R');
  ippiFilterGauss_32f_C1R:=getproc(hIPPI,'ippiFilterGauss_32f_C1R');
  ippiFilterGauss_8u_C3R:=getproc(hIPPI,'ippiFilterGauss_8u_C3R');
  ippiFilterGauss_16s_C3R:=getproc(hIPPI,'ippiFilterGauss_16s_C3R');
  ippiFilterGauss_32f_C3R:=getproc(hIPPI,'ippiFilterGauss_32f_C3R');
  ippiFilterGauss_8u_C4R:=getproc(hIPPI,'ippiFilterGauss_8u_C4R');
  ippiFilterGauss_16s_C4R:=getproc(hIPPI,'ippiFilterGauss_16s_C4R');
  ippiFilterGauss_32f_C4R:=getproc(hIPPI,'ippiFilterGauss_32f_C4R');
  ippiFilterGauss_8u_AC4R:=getproc(hIPPI,'ippiFilterGauss_8u_AC4R');
  ippiFilterGauss_16s_AC4R:=getproc(hIPPI,'ippiFilterGauss_16s_AC4R');
  ippiFilterGauss_32f_AC4R:=getproc(hIPPI,'ippiFilterGauss_32f_AC4R');

  ippiFilterHipass_8u_C1R:=getProc(hIPPI,'ippiFilterHipass_8u_C1R');
  ippiFilterHipass_16s_C1R:=getproc(hIPPI,'ippiFilterHipass_16s_C1R');
  ippiFilterHipass_32f_C1R:=getproc(hIPPI,'ippiFilterHipass_32f_C1R');
  ippiFilterHipass_8u_C3R:=getproc(hIPPI,'ippiFilterHipass_8u_C3R');
  ippiFilterHipass_16s_C3R:=getproc(hIPPI,'ippiFilterHipass_16s_C3R');
  ippiFilterHipass_32f_C3R:=getproc(hIPPI,'ippiFilterHipass_32f_C3R');
  ippiFilterHipass_8u_C4R:=getproc(hIPPI,'ippiFilterHipass_8u_C4R');
  ippiFilterHipass_16s_C4R:=getproc(hIPPI,'ippiFilterHipass_16s_C4R');
  ippiFilterHipass_32f_C4R:=getproc(hIPPI,'ippiFilterHipass_32f_C4R');
  ippiFilterHipass_8u_AC4R:=getproc(hIPPI,'ippiFilterHipass_8u_AC4R');
  ippiFilterHipass_16s_AC4R:=getproc(hIPPI,'ippiFilterHipass_16s_AC4R');
  ippiFilterHipass_32f_AC4R:=getproc(hIPPI,'ippiFilterHipass_32f_AC4R');

  ippiFilterLowpass_8u_C1R:=getProc(hIPPI,'ippiFilterLowpass_8u_C1R');
  ippiFilterLowpass_16s_C1R:=getproc(hIPPI,'ippiFilterLowpass_16s_C1R');
  ippiFilterLowpass_32f_C1R:=getproc(hIPPI,'ippiFilterLowpass_32f_C1R');
  ippiFilterLowpass_8u_C3R:=getproc(hIPPI,'ippiFilterLowpass_8u_C3R');
  ippiFilterLowpass_16s_C3R:=getproc(hIPPI,'ippiFilterLowpass_16s_C3R');
  ippiFilterLowpass_32f_C3R:=getproc(hIPPI,'ippiFilterLowpass_32f_C3R');
  ippiFilterLowpass_8u_AC4R:=getproc(hIPPI,'ippiFilterLowpass_8u_AC4R');
  ippiFilterLowpass_16s_AC4R:=getproc(hIPPI,'ippiFilterLowpass_16s_AC4R');
  ippiFilterLowpass_32f_AC4R:=getproc(hIPPI,'ippiFilterLowpass_32f_AC4R');

  ippiFilterSharpen_8u_C1R:=getProc(hIPPI,'ippiFilterSharpen_8u_C1R');
  ippiFilterSharpen_16s_C1R:=getproc(hIPPI,'ippiFilterSharpen_16s_C1R');
  ippiFilterSharpen_32f_C1R:=getproc(hIPPI,'ippiFilterSharpen_32f_C1R');
  ippiFilterSharpen_8u_C3R:=getproc(hIPPI,'ippiFilterSharpen_8u_C3R');
  ippiFilterSharpen_16s_C3R:=getproc(hIPPI,'ippiFilterSharpen_16s_C3R');
  ippiFilterSharpen_32f_C3R:=getproc(hIPPI,'ippiFilterSharpen_32f_C3R');
  ippiFilterSharpen_8u_C4R:=getproc(hIPPI,'ippiFilterSharpen_8u_C4R');
  ippiFilterSharpen_16s_C4R:=getproc(hIPPI,'ippiFilterSharpen_16s_C4R');
  ippiFilterSharpen_32f_C4R:=getproc(hIPPI,'ippiFilterSharpen_32f_C4R');
  ippiFilterSharpen_8u_AC4R:=getproc(hIPPI,'ippiFilterSharpen_8u_AC4R');
  ippiFilterSharpen_16s_AC4R:=getproc(hIPPI,'ippiFilterSharpen_16s_AC4R');
  ippiFilterSharpen_32f_AC4R:=getproc(hIPPI,'ippiFilterSharpen_32f_AC4R');

  ippiConvValid_32f_C1R:=getProc(hIPPI,'ippiConvValid_32f_C1R');
  ippiConvValid_32f_C3R:=getProc(hIPPI,'ippiConvValid_32f_C3R');
  ippiConvValid_32f_AC4R:=getProc(hIPPI,'ippiConvValid_32f_AC4R');
  ippiConvValid_16s_C1R:=getProc(hIPPI,'ippiConvValid_16s_C1R');
  ippiConvValid_16s_C3R:=getProc(hIPPI,'ippiConvValid_16s_C3R');
  ippiConvValid_16s_AC4R:=getProc(hIPPI,'ippiConvValid_16s_AC4R');
  ippiConvValid_8u_C1R:=getProc(hIPPI,'ippiConvValid_8u_C1R');
  ippiConvValid_8u_C3R:=getProc(hIPPI,'ippiConvValid_8u_C3R');
  ippiConvValid_8u_AC4R:=getProc(hIPPI,'ippiConvValid_8u_AC4R');

end;

Procedure FreeIPPI;
begin
  if hIPPI<>0 then freeLibrary(hIPPI);
  hIPPI:=0;
end;

procedure IPPtest;
begin
  if not initIPPIlib then sortieErreur('unable to initialize IPP library');
end;

procedure IPPend;
begin
  setPrecisionMode(pmExtended);
end;

Initialization
AffDebug('Initialization IPPI0',0);

finalization

freeIPPI;

end.
