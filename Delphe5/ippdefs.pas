NE PAS UTILISER

unit ippdefs;

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
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1;

Const

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
  IPP_MIN_8S     =      128 ;
  IPP_MAX_8S     =      127 ;
  IPP_MIN_16S    =      32768 ;
  IPP_MAX_16S    =      32767 ;
  IPP_MIN_32S    =      2147483647 - 1 ;
  IPP_MAX_32S    =      2147483647 ;

  IPP_MAX_64S  =      9223372036854775807 ;
  IPP_MIN_64S  =      9223372036854775807 - 1 ;

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

  PIpp8sc = ^Ipp8sc;

  PIpp16sc = ^Ipp16sc;

  PIpp32sc = ^Ipp32sc;

  PIpp32fc = {^Ipp32fc;}PsingleComp;

  PIpp64sc = ^Ipp64sc;

  PIpp64fc = {^Ipp64fc;}PdoubleComp;


  IppRoundMode = ( ippRndZero, ippRndNear );

  IppHintAlgorithm = ( ippAlgHintNone, ippAlgHintFast, ippAlgHintAccurate );

  IppCmpOp = ( ippCmpLess, ippCmpLessEq, ippCmpEq, ippCmpGreaterEq, ippCmpGreater );


Const
  IPP_FFT_DIV_FWD_BY_N = 1;
  IPP_FFT_DIV_INV_BY_N = 2;
  IPP_FFT_DIV_BY_SQRTN = 4;
  IPP_FFT_NODIV_BY_ANY = 8;

type
  IppDataType= (
   _ipp1u,
   _ipp8u,  _ipp8s,
   _ipp16u, _ipp16s, _ipp16sc,
   _ipp32u, _ipp32s, _ipp32sc,
   _ipp32f, _ipp32fc,
   _ipp64u, _ipp64s, _ipp64sc,
   _ipp64f, _ipp64fc
   );

  IppiRect = record
               x : integer;
               y : integer;
               width : integer;
               height : integer;
             end;

  IppiPoint = record
                x,y: integer;
              end;

  IppiSize = record
               width, height: integer;
             end;


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
  IppBool = ( ippFalse = 0, ippTrue = 1 );

  IppWinType= (ippWinBartlett,ippWinBlackman,ippWinHamming,ippWinHann,ippWinRect);



(* /////////////////////////////////////////////////////////////////////////////
//        The following enumerator defines a status of IPP operations
//                     negative value means error
*)
  IppStatus =  integer;   (* errors *)

Const
    ippStsNotSupportedModeErr   = -9999;  (* The requested mode is currently not supported  *)
    ippStsCpuNotSupportedErr    = -9998;  (* The target cpu is not supported *)

    ippStsEphemeralKeyErr        = -178; (* ECC: Bad ephemeral key   *)
    ippStsMessageErr             = -177; (* ECC: Bad message digest  *)
    ippStsShareKeyErr            = -176; (* ECC: Invalid share key   *)
    ippStsIvalidPublicKey        = -175; (* ECC: Invalid public key  *)
    ippStsIvalidPrivateKey       = -174; (* ECC: Invalid private key *)
    ippStsOutOfECErr             = -173; (* ECC: Point out of EC     *)
    ippStsECCInvalidFlagErr      = -172; (* ECC: Invalid Flag        *)

    ippStsMP3FrameHeaderErr      = -171;  (* Error in fields IppMP3FrameHeader structure *)
    ippStsMP3SideInfoErr         = -170;  (* Error in fields IppMP3SideInfo structure *)

    ippStsBlockStepErr           = -169;  (* Step for Block less than 8 *)
    ippStsMBStepErr              = -168;  (* Step for MB less than 16 *)

    ippStsAacPrgNumErr           = -167;  (* AAC: Invalid number of elements for one program   *)
    ippStsAacSectCbErr           = -166;  (* AAC: Invalid section codebook                     *)
    ippStsAacSfValErr            = -164;  (* AAC: Invalid scalefactor value                    *)
    ippStsAacCoefValErr          = -163;  (* AAC: Invalid quantized coefficient value          *)
    ippStsAacMaxSfbErr           = -162;  (* AAC: Invalid coefficient index  *)
    ippStsAacPredSfbErr          = -161;  (* AAC: Invalid predicted coefficient index  *)
    ippStsAacPlsDataErr          = -160;  (* AAC: Invalid pulse data attributes  *)
    ippStsAacGainCtrErr          = -159;  (* AAC: Gain control not supported  *)
    ippStsAacSectErr             = -158;  (* AAC: Invalid number of sections  *)
    ippStsAacTnsNumFiltErr       = -157;  (* AAC: Invalid number of TNS filters  *)
    ippStsAacTnsLenErr           = -156;  (* AAC: Invalid TNS region length  *)
    ippStsAacTnsOrderErr         = -155;  (* AAC: Invalid order of TNS filter  *)
    ippStsAacTnsCoefResErr       = -154;  (* AAC: Invalid bit-resolution for TNS filter coefficients  *)
    ippStsAacTnsCoefErr          = -153;  (* AAC: Invalid TNS filter coefficients  *)
    ippStsAacTnsDirectErr        = -152;  (* AAC: Invalid TNS filter direction  *)
    ippStsAacTnsProfileErr       = -151;  (* AAC: Invalid TNS profile  *)
    ippStsAacErr                 = -150;  (* AAC: Internal error  *)
    ippStsAacBitOffsetErr        = -149;  (* AAC: Invalid current bit offset in bitstream  *)
    ippStsAacAdtsSyncWordErr     = -148;  (* AAC: Invalid ADTS syncword  *)
    ippStsAacSmplRateIdxErr      = -147;  (* AAC: Invalid sample rate index  *)
    ippStsAacWinLenErr           = -146;  (* AAC: Invalid window length (not short or long)  *)
    ippStsAacWinGrpErr           = -145;  (* AAC: Invalid number of groups for current window length  *)
    ippStsAacWinSeqErr           = -144;  (* AAC: Invalid window sequence range  *)
    ippStsAacComWinErr           = -143;  (* AAC: Invalid common window flag  *)
    ippStsAacStereoMaskErr       = -142;  (* AAC: Invalid stereo mask  *)
    ippStsAacChanErr             = -141;  (* AAC: Invalid channel number  *)
    ippStsAacMonoStereoErr       = -140;  (* AAC: Invalid mono-stereo flag  *)
    ippStsAacStereoLayerErr      = -139;  (* AAC: Invalid this Stereo Layer flag  *)
    ippStsAacMonoLayerErr        = -138;  (* AAC: Invalid this Mono Layer flag  *)
    ippStsAacScalableErr         = -137;  (* AAC: Invalid scalable object flag  *)
    ippStsAacObjTypeErr          = -136;  (* AAC: Invalid audio object type  *)
    ippStsAacWinShapeErr         = -135;  (* AAC: Invalid window shape  *)
    ippStsAacPcmModeErr          = -134;  (* AAC: Invalid PCM output interleaving indicator  *)
    ippStsVLCUsrTblHeaderErr          = -133;  (* VLC: Invalid header inside table *)
    ippStsVLCUsrTblUnsupportedFmtErr  = -132;  (* VLC: Unsupported table format *)
    ippStsVLCUsrTblEscAlgTypeErr      = -131;  (* VLC: Unsupported Ecs-algorithm *)
    ippStsVLCUsrTblEscCodeLengthErr   = -130;  (* VLC: Incorrect Esc-code length inside table header *)
    ippStsVLCUsrTblCodeLengthErr      = -129;  (* VLC: Unsupported code length inside table *)
    ippStsVLCInternalTblErr           = -128;  (* VLC: Invalid internal table *)
    ippStsVLCInputDataErr             = -127;  (* VLC: Invalid input data *)
    ippStsVLCAACEscCodeLengthErr      = -126;  (* VLC: Invalid AAC-Esc code length *)
    ippStsNoiseRangeErr         = -125;  (* Noise value for Wiener Filter is out range. *)
    ippStsUnderRunErr           = -124;  (* Data under run error *)
    ippStsPaddingErr            = -123;  (* Detected padding error shows the possible data corruption *)
    ippStsCFBSizeErr            = -122;  (* Wrong value for crypto CFB block size *)
    ippStsPaddingSchemeErr      = -121;  (* Invalid padding scheme  *)
    ippStsInvalidCryptoKeyErr   = -120;  (* A compromised key causes suspansion of requested cryptographic operation  *)
    ippStsLengthErr             = -119;  (* Wrong value of string length *)
    ippStsBadModulusErr         = -118;  (* Bad modulus caused a module inversion failure *)
    ippStsLPCCalcErr            = -117;  (* Linear prediction could not be evaluated *)
    ippStsRCCalcErr             = -116;  (* Reflection coefficients could not be computed *)
    ippStsIncorrectLSPErr       = -115;  (* Incorrect Linear Spectral Pair values *)
    ippStsNoRootFoundErr        = -114;  (* No roots are found for equation *)
    ippStsJPEG2KBadPassNumber   = -113;  (* Pass number exceeds allowed limits [0;nOfPasses-1] *)
    ippStsJPEG2KDamagedCodeBlock= -112;  (* Codeblock for decoding is damaged *)
    ippStsH263CBPYCodeErr       = -111;  (* Illegal Huffman code during CBPY stream processing *)
    ippStsH263MCBPCInterCodeErr = -110;  (* Illegal Huffman code during MCBPC Inter stream processing *)
    ippStsH263MCBPCIntraCodeErr = -109;  (* Illegal Huffman code during MCBPC Intra stream processing *)
    ippStsNotEvenStepErr        = -108;  (* Step value is not pixel multiple *)
    ippStsHistoNofLevelsErr     = -107;  (* Number of levels for histogram is less than 2 *)
    ippStsLUTNofLevelsErr       = -106;  (* Number of levels for LUT is less than 2 *)
    ippStsMP4BitOffsetErr       = -105;  (* Incorrect bit offset value *)
    ippStsMP4QPErr              = -104;  (* Incorrect quantization parameter *)
    ippStsMP4BlockIdxErr        = -103;  (* Incorrect block index *)
    ippStsMP4BlockTypeErr       = -102;  (* Incorrect block type *)
    ippStsMP4MVCodeErr          = -101;  (* Illegal Huffman code during MV stream processing *)
    ippStsMP4VLCCodeErr         = -100;  (* Illegal Huffman code during VLC stream processing *)
    ippStsMP4DCCodeErr          = -99;   (* Illegal code during DC stream processing *)
    ippStsMP4FcodeErr           = -98;   (* Incorrect fcode value *)
    ippStsMP4AlignErr           = -97;   (* Incorrect buffer alignment            *)
    ippStsMP4TempDiffErr        = -96;   (* Incorrect temporal difference         *)
    ippStsMP4BlockSizeErr       = -95;   (* Incorrect size of block or macroblock *)
    ippStsMP4ZeroBABErr         = -94;   (* All BAB values are zero             *)
    ippStsMP4PredDirErr         = -93;   (* Incorrect prediction direction        *)
    ippStsMP4BitsPerPixelErr    = -92;   (* Incorrect number of bits per pixel    *)
    ippStsMP4VideoCompModeErr   = -91;   (* Incorrect video component mode        *)
    ippStsMP4LinearModeErr      = -90;   (* Incorrect DC linear mode *)
    ippStsH263PredModeErr       = -83;   (* Prediction Mode value error                                       *)
    ippStsH263BlockStepErr      = -82;   (* Step value is less than 8                                         *)
    ippStsH263MBStepErr         = -81;   (* Step value is less than 16                                        *)
    ippStsH263FrameWidthErr     = -80;   (* Frame width is less then 8                                        *)
    ippStsH263FrameHeightErr    = -79;   (* Frame height is less than or equal to zero                        *)
    ippStsH263ExpandPelsErr     = -78;   (* Expand pixels number is less than 8                               *)
    ippStsH263PlaneStepErr      = -77;   (* Step value is less than the plane width                           *)
    ippStsH263QuantErr          = -76;   (* Quantizer value is less than or equal to zero; or greater than 31 *)
    ippStsH263MVCodeErr         = -75;   (* Illegal Huffman code during MV stream processing                  *)
    ippStsH263VLCCodeErr        = -74;   (* Illegal Huffman code during VLC stream processing                 *)
    ippStsH263DCCodeErr         = -73;   (* Illegal code during DC stream processing                          *)
    ippStsH263ZigzagLenErr      = -72;   (* Zigzag compact length is more than 64                             *)
    ippStsFBankFreqErr          = -71;   (* Incorrect value of the filter bank frequency parameter *)
    ippStsFBankFlagErr          = -70;   (* Incorrect value of the filter bank parameter           *)
    ippStsFBankErr              = -69;   (* Filter bank is not correctly initialized"              *)
    ippStsNegOccErr             = -67;   (* Negative occupation count                      *)
    ippStsCdbkFlagErr           = -66;   (* Incorrect value of the codebook flag parameter *)
    ippStsSVDCnvgErr            = -65;   (* No convergence of SVD algorithm"               *)
    ippStsJPEGHuffTableErr      = -64;   (* JPEG Huffman table is destroyed        *)
    ippStsJPEGDCTRangeErr       = -63;   (* JPEG DCT coefficient is out of the range *)
    ippStsJPEGOutOfBufErr       = -62;   (* Attempt to access out of the buffer    *)
    ippStsDrawTextErr           = -61;   (* System error in the draw text operation *)
    ippStsChannelOrderErr       = -60;   (* Wrong order of the destination channels *)
    ippStsZeroMaskValuesErr     = -59;   (* All values of the mask are zero *)
    ippStsQuadErr               = -58;   (* The quadrangle degenerates into triangle; line or point *)
    ippStsRectErr               = -57;   (* Size of the rectangle region is less than or equal to 1 *)
    ippStsCoeffErr              = -56;   (* Unallowable values of the transformation coefficients   *)
    ippStsNoiseValErr           = -55;   (* Bad value of noise amplitude for dithering"             *)
    ippStsDitherLevelsErr       = -54;   (* Number of dithering levels is out of range"             *)
    ippStsNumChannelsErr        = -53;   (* Bad or unsupported number of channels                   *)
    ippStsCOIErr                = -52;   (* COI is out of range *)
    ippStsDivisorErr            = -51;   (* Divisor is equal to zero; function is aborted *)
    ippStsAlphaTypeErr          = -50;   (* Illegal type of image compositing operation                           *)
    ippStsGammaRangeErr         = -49;   (* Gamma range bounds is less than or equal to zero                      *)
    ippStsGrayCoefSumErr        = -48;   (* Sum of the conversion coefficients must be less than or equal to 1    *)
    ippStsChannelErr            = -47;   (* Illegal channel number                                                *)
    ippStsToneMagnErr           = -46;   (* Tone magnitude is less than or equal to zero                          *)
    ippStsToneFreqErr           = -45;   (* Tone frequency is negative; or greater than or equal to 0.5           *)
    ippStsTonePhaseErr          = -44;   (* Tone phase is negative; or greater than or equal to 2*PI              *)
    ippStsTrnglMagnErr          = -43;   (* Triangle magnitude is less than or equal to zero                      *)
    ippStsTrnglFreqErr          = -42;   (* Triangle frequency is negative; or greater than or equal to 0.5       *)
    ippStsTrnglPhaseErr         = -41;   (* Triangle phase is negative; or greater than or equal to 2*PI          *)
    ippStsTrnglAsymErr          = -40;   (* Triangle asymmetry is less than -PI; or greater than or equal to PI   *)
    ippStsHugeWinErr            = -39;   (* Kaiser window is too huge                                             *)
    ippStsJaehneErr             = -38;   (* Magnitude value is negative                                           *)
    ippStsStrideErr             = -37;   (* Stride value is less than the row length *)
    ippStsEpsValErr             = -36;   (* Negative epsilon value error"            *)
    ippStsWtOffsetErr           = -35;   (* Invalid offset value of wavelet filter                                       *)
    ippStsAnchorErr             = -34;   (* Anchor point is outside the mask                                             *)
    ippStsMaskSizeErr           = -33;   (* Invalid mask size                                                           *)
    ippStsShiftErr              = -32;   (* Shift value is less than zero                                                *)
    ippStsSampleFactorErr       = -31;   (* Sampling factor is less than or equal to zero                                *)
    ippStsSamplePhaseErr        = -30;   (* Phase value is out of range: 0 <= phase < factor                             *)
    ippStsFIRMRFactorErr        = -29;   (* MR FIR sampling factor is less than or equal to zero                         *)
    ippStsFIRMRPhaseErr         = -28;   (* MR FIR sampling phase is negative; or greater than or equal to the sampling factor *)
    ippStsRelFreqErr            = -27;   (* Relative frequency value is out of range                                     *)
    ippStsFIRLenErr             = -26;   (* Length of a FIR filter is less than or equal to zero                         *)
    ippStsIIROrderErr           = -25;   (* Order of an IIR filter is less than or equal to zero                         *)
    ippStsDlyLineIndexErr       = -24;   (* Invalid value of the delay line sample index *)
    ippStsResizeFactorErr       = -23;   (* Resize factor(s) is less than or equal to zero *)
    ippStsInterpolationErr      = -22;   (* Invalid interpolation mode *)
    ippStsMirrorFlipErr         = -21;   (* Invalid flip mode                                         *)
    ippStsMoment00ZeroErr       = -20;   (* Moment value M(0;0) is too small to continue calculations *)
    ippStsThreshNegLevelErr     = -19;   (* Negative value of the level in the threshold operation    *)
    ippStsThresholdErr          = -18;   (* Invalid threshold bounds *)
    ippStsContextMatchErr       = -17;   (* Context parameter doesn't match the operation *)
    ippStsFftFlagErr            = -16;   (* Invalid value of the FFT flag parameter *)
    ippStsFftOrderErr           = -15;   (* Invalid value of the FFT order parameter *)
    ippStsStepErr               = -14;   (* Step value is less than or equal to zero *)
    ippStsScaleRangeErr         = -13;   (* Scale bounds are out of the range *)
    ippStsDataTypeErr           = -12;   (* Bad or unsupported data type *)
    ippStsOutOfRangeErr         = -11;   (* Argument is out of range or point is outside the image *)
    ippStsDivByZeroErr          = -10;   (* An attempt to divide by zero *)
    ippStsMemAllocErr           = -9;    (* Not enough memory allocated for the operation *)
    ippStsNullPtrErr            = -8;    (* Null pointer error *)
    ippStsRangeErr              = -7;    (* Bad values of bounds: the lower bound is greater than the upper bound *)
    ippStsSizeErr               = -6;    (* Wrong value of data size *)
    ippStsBadArgErr             = -5;    (* Function arg/param is bad *)
    ippStsNoMemErr              = -4;    (* Not enough memory for the operation *)
    ippStsSAReservedErr3        = -3;    (*  *)
    ippStsErr                   = -2;    (* Unknown/unspecified error *)
    ippStsSAReservedErr1        = -1;    (*  *)
                                         (*  *)
     (* no errors *)                     (*  *)
    ippStsNoErr                 =   0;   (* No error; it's OK *)
                                         (*  *)
     (* warnings *)                      (*  *)
    ippStsNoOperation       =   1;       (* No operation has been executed *)
    ippStsMisalignedBuf     =   2;       (* Misaligned pointer in operation in which it must be aligned *)
    ippStsSqrtNegArg        =   3;       (* Negative value(s) of the argument in the function Sqrt *)
    ippStsInvZero           =   4;       (* INF result. Zero value was met by InvThresh with zero level *)
    ippStsEvenMedianMaskSize=   5;       (* Even size of the Median Filter mask was replaced by the odd one *)
    ippStsDivByZero         =   6;       (* Zero value(s) of the divisor in the function Div *)
    ippStsLnZeroArg         =   7;       (* Zero value(s) of the argument in the function Ln     *)
    ippStsLnNegArg          =   8;       (* Negative value(s) of the argument in the function Ln *)
    ippStsNanArg            =   9;       (* Not a Number argument value warning                  *)
    ippStsJPEGMarker        =   10;      (* JPEG marker was met in the bitstream                 *)
    ippStsResFloor          =   11;      (* All result values are floored                        *)
    ippStsOverflow          =   12;      (* Overflow occurred in the operation                   *)
    ippStsLSFLow            =   13;      (* Quantized LP syntethis filter stability check is applied at the low boundary of [0;pi] *)
    ippStsLSFHigh           =   14;      (* Quantized LP syntethis filter stability check is applied at the high boundary of [0;pi] *)
    ippStsLSFLowAndHigh     =   15;      (* Quantized LP syntethis filter stability check is applied at both boundaries of [0;pi] *)
    ippStsZeroOcc           =   16;      (* Zero occupation count *)
    ippStsUnderflow         =   17;      (* Underflow occurred in the operation *)
    ippStsSingularity       =   18;      (* Singularity occurred in the operation                                       *)
    ippStsDomain            =   19;      (* Argument is out of the function domain                                      *)
    ippStsNonIntelCpu       =   20;      (* The target cpu is not Genuine Intel                                         *)
    ippStsCpuMismatch       =   21;      (* The library for given cpu cannot be set                                     *)
    ippStsNoIppFunctionFound =  22;      (* Application does not contain IPP functions calls                            *)
    ippStsDllNotFoundBestUsed = 23;      (* The newest version of IPP dll's not found by dispatcher                     *)
    ippStsNoOperationInDll  =   24;      (* The function does nothing in the dynamic version of the library             *)
    ippStsInsufficientEntropy=  25;      (* Insufficient entropy in the random seed and stimulus bit string caused the prime/key generation to fail *)
    ippStsOvermuchStrings   =   26;      (* Number of destination strings is more than expected                         *)
    ippStsOverlongString    =   27;      (* Length of one of the destination strings is more than expected              *)
    ippStsAffineQuadChanged =   28;      (* 4th vertex of destination quad is not equal to customer's one               *)


Const
  ippStsOk = ippStsNoErr;


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

(* ///////////////////////// End of file "ippdefs.h" //////////////////////// *)
