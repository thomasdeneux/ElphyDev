(******************************************************************************)
(*                                                                            *)
(*  Copyright (C) 1994-1999 Microsoft Corporation.  All Rights Reserved.      *)
(*                                                                            *)
(*  Content:	DirectX Header file                                           *)
(*                                                                            *)
(*  DirectX 6 Delphi adaptation by Erik Unger                                 *)
(*  (Version 2.1 by Christian Iversen)                                        *)
(*                                                                            *)
(*  Modyfied: 22.Mar.99                                                       *)
(*                                                                            *)
(*  Download: http://www.bigfoot.com/~ungerik/                                *)
(*                                                                            *)
(*  E-Mail:                                                                   *)
(*  Erik Unger: ungerik@bigfoot.com                                           *)
(*  Christian Iversen: Christian.Iversen@DADLNet.DK                           *)
(*                                                                            *)
(******************************************************************************)
Unit DirectX;

{$MINENUMSIZE 4}
{$ALIGN ON}

{
If you want to use Unicode as default stringtype,
define the compiler-symbol UNICODE:
}
// {$DEFINE UNICODE}

Interface

Uses
  Windows, MMSystem;

(******************************************************************************)
(**                                                                          **)
(** General Stuff                                                            **)
(**                                                                          **)
(******************************************************************************)

Var
  DDrawDLL  : HMODULE;
  D3DRMDLL  : HMODULE;
  DPlayDLL  : HMODULE;
  DInputDLL : HMODULE;
  DSoundDLL : HMODULE;
  DXFileDLL : HMODULE;

Function DFErrorString(Value: HResult) : string;
Function DSErrorString(Value: HResult) : string;
Function DPErrorString(Value: HResult) : string;
Function DIErrorString(Value: HResult) : string;
Function DDErrorString(Value: HResult) : String;
Function D3DErrorString(Value: HResult) : String; //Full description not available yet
Function D3DRMErrorString(Value: HResult) : String;

(******************************************************************************)
(**                                                                          **)
(** DDraw.Pas                                                                **)
(**                                                                          **)
(******************************************************************************)

function MAKEFOURCC(ch0, ch1, ch2, ch3: Char) : DWORD;

(*
 * FOURCC codes for DX compressed-texture pixel formats
 *)
const
  FOURCC_DXT1 = 'DXT1';
  FOURCC_DXT2 = 'DXT2';
  FOURCC_DXT3 = 'DXT3';
  FOURCC_DXT4 = 'DXT4';
  FOURCC_DXT5 = 'DXT5';

(*
 * GUIDS used by DirectDraw objects
 *)
const
  CLSID_DirectDraw            : TGUID = (D1:$D7B70EE0;D2:$4340;D3:$11CF;D4:($B0,$63,$00,$20,$AF,$C2,$CD,$35));
  CLSID_DirectDrawClipper     : TGUID = (D1:$593817A0;D2:$7DB3;D3:$11CF;D4:($A2,$DE,$00,$AA,$00,$b9,$33,$56));
  IID_IDirectDraw             : TGUID = (D1:$6C14DB80;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDraw2            : TGUID = (D1:$B3A6F3E0;D2:$2B43;D3:$11CF;D4:($A2,$DE,$00,$AA,$00,$B9,$33,$56));
  IID_IDirectDraw4            : TGUID = (D1:$9c59509a;D2:$39bd;D3:$11d1;D4:($8c,$4a,$00,$c0,$4f,$d9,$30,$c5));
  IID_IDirectDrawSurface      : TGUID = (D1:$6C14DB81;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawSurface2     : TGUID = (D1:$57805885;D2:$6eec;D3:$11cf;D4:($94,$41,$a8,$23,$03,$c1,$0e,$27));
  IID_IDirectDrawSurface3     : TGUID = (D1:$DA044E00;D2:$69B2;D3:$11D0;D4:($A1,$D5,$00,$AA,$00,$B8,$DF,$BB));
  IID_IDirectDrawSurface4     : TGUID = (D1:$0B2B8630;D2:$AD35;D3:$11D0;D4:($8E,$A6,$00,$60,$97,$97,$EA,$5B));
  IID_IDirectDrawPalette      : TGUID = (D1:$6C14DB84;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawClipper      : TGUID = (D1:$6C14DB85;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawColorControl : TGUID = (D1:$4B9F0EE0;D2:$0D7E;D3:$11D0;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  IID_IDirectDrawGammaControl : TGUID = (D1:$69C11C3E;D2:$B46B;D3:$11D1;D4:($AD,$7A,$00,$C0,$4F,$C2,$9B,$4E));

const
  DD_ROP_SPACE = (256 div 32);       // space required to store ROP array

  MAX_DDDEVICEID_STRING	= 512;

(*
 * Flags for the IDirectDraw4::GetDeviceIdentifier method
 *)

(*
 * This flag causes GetDeviceIdentifier to return information about the host (typically 2D) adapter in a system equipped
 * with a stacked secondary 3D adapter. Such an adapter appears to the application as if it were part of the
 * host adapter, but is typically physcially located on a separate card. The stacked secondary's information is
 * returned when GetDeviceIdentifier's dwFlags field is zero, since this most accurately reflects the qualities
 * of the DirectDraw object involved.
 *)
  DDGDI_GETHOSTIDENTIFIER         = $00000001;

(*============================================================================
 *
 * DirectDraw Structures
 *
 * Various structures used to invoke DirectDraw.
 *
 *==========================================================================*)

type
  TRefGUID =
  packed record
  case integer of
    1: (guid : PGUID);
    2: (dwFlags : DWORD);
  end;

  IDirectDraw = Interface;
  IDirectDraw2 = Interface;
  IDirectDraw4 = Interface;
  IDirectDrawSurface = Interface;
  IDirectDrawSurface2 = Interface;
  IDirectDrawSurface3 = Interface;
  IDirectDrawSurface4 = Interface;

  IDirectDrawPalette = Interface;
  IDirectDrawClipper = Interface;
  IDirectDrawColorControl = Interface;
  IDirectDrawGammaControl = Interface;

(*
 * Generic pixel format with 8-bit RGB and alpha components
 *)
  PDDRGBA = ^TDDRGBA;
  TDDRGBA = packed record
    red   : BYTE;
    green : BYTE;
    blue  : BYTE;
    alpha : BYTE;
  end;

(*
 * TDDColorKey
 *)
  PDDColorKey = ^TDDColorKey;
  TDDColorKey =
  packed record
    dwColorSpaceLowValue: DWORD;   // low  boundary of color space that is to be treated as Color Key, inclusive
    dwColorSpaceHighValue: DWORD;  // high boundary of color space that is to be treated as Color Key, inclusive
  end;

(*
 * TDDBltFX
 * Used to pass override information to the DIRECTDRAWSURFACE callback Blt.
 *)
  PDDBltFX = ^TDDBltFX;
  TDDBltFX = packed record
    dwSize                        : DWORD;     // size of structure
    dwDDFX                        : DWORD;     // FX operations
    dwROP                         : DWORD;     // Win32 raster operations
    dwDDROP                       : DWORD;     // Raster operations new for DirectDraw
    dwRotationAngle               : DWORD;     // Rotation angle for blt
    dwZBufferOpCode               : DWORD;     // ZBuffer compares
    dwZBufferLow                  : DWORD;     // Low limit of Z buffer
    dwZBufferHigh                 : DWORD;     // High limit of Z buffer
    dwZBufferBaseDest             : DWORD;     // Destination base value
    dwZDestConstBitDepth          : DWORD;     // Bit depth used to specify Z constant for destination
    case integer of
    0: (
      dwZDestConst                : DWORD      // Constant to use as Z buffer for dest
     );
    1: (
      lpDDSZBufferDest            : DWORD{IDirectDrawSurface}; // Surface to use as Z buffer for dest
      dwZSrcConstBitDepth         : DWORD;     // Bit depth used to specify Z constant for source
      case integer of
      0: (
        dwZSrcConst               : DWORD;     // Constant to use as Z buffer for src
       );
      1: (
        lpDDSZBufferSrc           : DWORD{IDirectDrawSurface}; // Surface to use as Z buffer for src
        dwAlphaEdgeBlendBitDepth  : DWORD;     // Bit depth used to specify constant for alpha edge blend
        dwAlphaEdgeBlend          : DWORD;     // Alpha for edge blending
        dwReserved                : DWORD;
        dwAlphaDestConstBitDepth  : DWORD;     // Bit depth used to specify alpha constant for destination
        case integer of
        0: (
          dwAlphaDestConst        : DWORD;     // Constant to use as Alpha Channel
         );
        1: (
          lpDDSAlphaDest          : DWORD{IDirectDrawSurface}; // Surface to use as Alpha Channel
          dwAlphaSrcConstBitDepth : DWORD;     // Bit depth used to specify alpha constant for source
          case integer of
          0: (
            dwAlphaSrcConst       : DWORD;     // Constant to use as Alpha Channel
          );
          1: (
            lpDDSAlphaSrc         : DWORD{IDirectDrawSurface}; // Surface to use as Alpha Channel
            case integer of
            0: (
              dwFillColor         : DWORD;     // color in RGB or Palettized
            );
            1: (
              dwFillDepth         : DWORD;     // depth value for z-buffer
            );
            2: (
              dwFillPixel         : DWORD;     // pixel value
            );
            3: (
              lpDDSPattern        : DWORD{IDirectDrawSurface}; // Surface to use as pattern
              ddckDestColorkey    : TDDColorKey; // DestColorkey override
              ddckSrcColorkey     : TDDColorKey; // SrcColorkey override
            )
        )
      )
    )
  )
  end;

(*
 * TDDSCaps
 *)
  PDDSCaps = ^TDDSCaps;
  TDDSCaps = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
  end;

(*
 * TDDOSCaps
 *)
  PDDOSCaps = ^TDDOSCaps;
  TDDOSCaps = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
  end;

(*
 * This structure is used internally by DirectDraw.
 *)
  PDDSCapsEx = ^TDDSCapsEx;
  TDDSCapsEx = packed record
    dwCaps2 : DWORD;
    dwCaps3 : DWORD;
    dwCaps4 : DWORD;
  end;

(*
 * TDDSCaps2
 *)
  PDDSCaps2 = ^TDDSCaps2;
  TDDSCaps2 = packed record
    dwCaps: DWORD;         // capabilities of surface wanted
    dwCaps2 : DWORD;
    dwCaps3 : DWORD;
    dwCaps4 : DWORD;
  end;

(*
 * TDDCaps
 *)
(*
 * This structure is the TDDCaps structure as it was in version 2 and 3 of Direct X.
 * It is present for back compatability.
 *)
  PDDCaps_DX3 = ^TDDCaps_DX3;
  TDDCaps_DX3 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsCaps: TDDSCaps;             // TDDSCaps structure has all the general capabilities
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->System blts
    dwReserved4 : DWORD;
    dwReserved5 : DWORD;
    dwReserved6 : DWORD;
  end;

(*
 * This structure is the TDDCaps structure as it was in version 5 of Direct X.
 * It is present for back compatability.
 *)
  PDDCaps_DX5 = ^TDDCaps_DX5;
  TDDCaps_DX5 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsCaps: TDDSCaps;             // TDDSCaps structure has all the general capabilities
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->System blts
    // Members added for DX5:
    dwMaxVideoPorts: DWORD;	   // maximum number of usable video ports
    dwCurrVideoPorts: DWORD;	   // current number of video ports used
    dwSVBCaps2: DWORD;		   // more driver specific capabilities for System->Vmem blts
    dwNLVBCaps: DWORD;		   // driver specific capabilities for non-local->local vidmem blts
    dwNLVBCaps2: DWORD;		   // more driver specific capabilities non-local->local vidmem blts
    dwNLVBCKeyCaps: DWORD;	   // driver color key capabilities for non-local->local vidmem blts
    dwNLVBFXCaps: DWORD;	   // driver FX capabilities for non-local->local blts
    dwNLVBRops: Array [0..DD_ROP_SPACE-1] of DWORD; // ROPS supported for non-local->local blts
  end;

  PDDCaps_DX6 = ^TDDCaps_DX6;
  TDDCaps_DX6 = packed record
    dwSize: DWORD;                 // size of the DDDRIVERCAPS structure
    dwCaps: DWORD;                 // driver specific capabilities
    dwCaps2: DWORD;                // more driver specific capabilites
    dwCKeyCaps: DWORD;             // color key capabilities of the surface
    dwFXCaps: DWORD;               // driver specific stretching and effects capabilites
    dwFXAlphaCaps: DWORD;          // alpha driver specific capabilities
    dwPalCaps: DWORD;              // palette capabilities
    dwSVCaps: DWORD;               // stereo vision capabilities
    dwAlphaBltConstBitDepths: DWORD;       // DDBD_2,4,8
    dwAlphaBltPixelBitDepths: DWORD;       // DDBD_1,2,4,8
    dwAlphaBltSurfaceBitDepths: DWORD;     // DDBD_1,2,4,8
    dwAlphaOverlayConstBitDepths: DWORD;   // DDBD_2,4,8
    dwAlphaOverlayPixelBitDepths: DWORD;   // DDBD_1,2,4,8
    dwAlphaOverlaySurfaceBitDepths: DWORD; // DDBD_1,2,4,8
    dwZBufferBitDepths: DWORD;             // DDBD_8,16,24,32
    dwVidMemTotal: DWORD;          // total amount of video memory
    dwVidMemFree: DWORD;           // amount of free video memory
    dwMaxVisibleOverlays: DWORD;   // maximum number of visible overlays
    dwCurrVisibleOverlays: DWORD;  // current number of visible overlays
    dwNumFourCCCodes: DWORD;       // number of four cc codes
    dwAlignBoundarySrc: DWORD;     // source rectangle alignment
    dwAlignSizeSrc: DWORD;         // source rectangle byte size
    dwAlignBoundaryDest: DWORD;    // dest rectangle alignment
    dwAlignSizeDest: DWORD;        // dest rectangle byte size
    dwAlignStrideAlign: DWORD;     // stride alignment
    dwRops: Array [0..DD_ROP_SPACE-1] of DWORD;   // ROPS supported
    ddsOldCaps: TDDSCaps;          // Was dssCaps: TDDSCaps. ddsCaps is of type TDDScaps2 for DX6
    dwMinOverlayStretch: DWORD;    // minimum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxOverlayStretch: DWORD;    // maximum overlay stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinLiveVideoStretch: DWORD;  // minimum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxLiveVideoStretch: DWORD;  // maximum live video stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMinHwCodecStretch: DWORD;    // minimum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwMaxHwCodecStretch: DWORD;    // maximum hardware codec stretch factor multiplied by 1000, eg 1000 == 1.0, 1300 == 1.3
    dwReserved1: DWORD;            // reserved
    dwReserved2: DWORD;            // reserved
    dwReserved3: DWORD;            // reserved
    dwSVBCaps: DWORD;              // driver specific capabilities for System->Vmem blts
    dwSVBCKeyCaps: DWORD;          // driver color key capabilities for System->Vmem blts
    dwSVBFXCaps: DWORD;            // driver FX capabilities for System->Vmem blts
    dwSVBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->Vmem blts
    dwVSBCaps: DWORD;              // driver specific capabilities for Vmem->System blts
    dwVSBCKeyCaps: DWORD;          // driver color key capabilities for Vmem->System blts
    dwVSBFXCaps: DWORD;            // driver FX capabilities for Vmem->System blts
    dwVSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for Vmem->System blts
    dwSSBCaps: DWORD;              // driver specific capabilities for System->System blts
    dwSSBCKeyCaps: DWORD;          // driver color key capabilities for System->System blts
    dwSSBFXCaps: DWORD;            // driver FX capabilities for System->System blts
    dwSSBRops: Array [0..DD_ROP_SPACE-1] of DWORD;// ROPS supported for System->System blts
    // Members added for DX5:
    dwMaxVideoPorts: DWORD;	   // maximum number of usable video ports
    dwCurrVideoPorts: DWORD;	   // current number of video ports used
    dwSVBCaps2: DWORD;		   // more driver specific capabilities for System->Vmem blts
    dwNLVBCaps: DWORD;		   // driver specific capabilities for non-local->local vidmem blts
    dwNLVBCaps2: DWORD;		   // more driver specific capabilities non-local->local vidmem blts
    dwNLVBCKeyCaps: DWORD;	   // driver color key capabilities for non-local->local vidmem blts
    dwNLVBFXCaps: DWORD;	   // driver FX capabilities for non-local->local blts
    dwNLVBRops: Array [0..DD_ROP_SPACE-1] of DWORD; // ROPS supported for non-local->local blts
    // Members added for DX6 release
    ddsCaps : TDDSCaps2 ;          // Surface Caps
  end;

  PDDCaps = ^TDDCaps;
{$IFDEF DIRECTX5}
  TDDCaps = TDDCaps_DX5
{$ELSE}
  TDDCaps = TDDCaps_DX6;
{$ENDIF}



(*
 * TDDPixelFormat
 *)
  PDDPixelFormat_DX5 = ^TDDPixelFormat_DX5;
  TDDPixelFormat_DX5 = packed record
    dwSize: DWORD;                 // size of structure
    dwFlags: DWORD;                // pixel format flags
    dwFourCC: DWORD;               // (FOURCC code)
    case Integer of
    0: (
      dwZBufferBitDepth: DWORD;      // how many bits for z buffers
     );
    1: (
      dwAlphaBitDepth: DWORD;        // how many bits for alpha channels
     );
    2: (
      dwRGBBitCount: DWORD;          // how many bits per pixel
      dwRBitMask: DWORD;             // mask for red bit
      dwGBitMask: DWORD;             // mask for green bits
      dwBBitMask: DWORD;             // mask for blue bits
      dwRGBAlphaBitMask: DWORD;      // mask for alpha channel
     );
    3: (
      dwYUVBitCount: DWORD;          // how many bits per pixel
      dwYBitMask: DWORD;             // mask for Y bits
      dwUBitMask: DWORD;             // mask for U bits
      dwVBitMask: DWORD;             // mask for V bits
      case Integer of
      0: (
        dwYUVAlphaBitMask: DWORD;      // mask for alpha channel
       );
      1: (
        dwRGBZBitMask: DWORD;
       );
      2: (
        dwYUVZBitMask: DWORD;
       );
     );
  end;

  PDDPixelFormat_DX6 = ^TDDPixelFormat_DX6;
  TDDPixelFormat_DX6 = packed record
    dwSize: DWORD;                 // size of structure
    dwFlags: DWORD;                // pixel format flags
    dwFourCC: DWORD;               // (FOURCC code)
    case Integer of
      1: (
          dwRGBBitCount : DWORD;  // how many bits per pixel
          dwRBitMask : DWORD;  // mask for red bit
          dwGBitMask : DWORD;  // mask for green bits
          dwBBitMask : DWORD;  // mask for blue bits
          dwRGBAlphaBitMask : DWORD; // mask for alpha channel
          );
      2: (
          dwYUVBitCount : DWORD;  // how many bits per pixel
          dwYBitMask : DWORD;  // mask for Y bits
          dwUBitMask : DWORD;  // mask for U bits
          dwVBitMask : DWORD;  // mask for V bits
          dwYUVAlphaBitMask : DWORD; // mask for alpha channel
          );
      3: (
          dwZBufferBitDepth : DWORD; // how many total bits/pixel in z buffer (including any stencil bits)
          dwStencilBitDepth : DWORD; // how many stencil bits (note: dwZBufferBitDepth-dwStencilBitDepth is total Z-only bits)
          dwZBitMask : DWORD;  // mask for Z bits
          dwStencilBitMask : DWORD; // mask for stencil bits
          dwLuminanceAlphaBitMask : DWORD;// mask for alpha channel
          );
      4: (
          dwAlphaBitDepth : DWORD; // how many bits for alpha channels
          dwLuminanceBitMask : DWORD; // mask for luminance bits
          dwBumpDvBitMask : DWORD;        // mask for bump map V delta bits
          dwBumpLuminanceBitMask : DWORD; // mask for luminance in bump map
          dwRGBZBitMask : DWORD;  // mask for Z channel
          );
      5: (
           dwLuminanceBitCount : DWORD; // how many bits per pixel
           dwBumpDuBitMask : DWORD;       // mask for bump map U delta bits
           Fill1, Fill2    : DWORD;
           dwYUVZBitMask   : DWORD;  // mask for Z channel
         );
      6: ( dwBumpBitCount  : DWORD;         // how many bits per "buxel", total
         );
  end;

  PDDPixelFormat = ^TDDPixelFormat;
{$IFDEF DIRECTX5}
  TDDPixelFormat = TDDPixelFormat_DX5;
{$ELSE}
  TDDPixelFormat = TDDPixelFormat_DX6;
{$ENDIF}

(*
 * TDDOverlayFX
 *)
  PDDOverlayFX = ^TDDOverlayFX;
  TDDOverlayFX = packed record
    dwSize: DWORD;                         // size of structure
    dwAlphaEdgeBlendBitDepth: DWORD;       // Bit depth used to specify constant for alpha edge blend
    dwAlphaEdgeBlend: DWORD;               // Constant to use as alpha for edge blend
    dwReserved: DWORD;
    dwAlphaDestConstBitDepth: DWORD;       // Bit depth used to specify alpha constant for destination
    case Integer of
    0: (
      dwAlphaDestConst: DWORD;               // Constant to use as alpha channel for dest
      dwAlphaSrcConstBitDepth: DWORD;        // Bit depth used to specify alpha constant for source
      dwAlphaSrcConst: DWORD;                // Constant to use as alpha channel for src
      dckDestColorkey: TDDColorKey;                // DestColorkey override
      dckSrcColorkey: TDDColorKey;                 // DestColorkey override
      dwDDFX: DWORD;                         // Overlay FX
      dwFlags: DWORD;                        // flags
     );
    1: (
      lpDDSAlphaDest: pointer{IDirectDrawSurface};     // Surface to use as alpha channel for dest
      filler: DWORD;
      lpDDSAlphaSrc: pointer{IDirectDrawSurface};      // Surface to use as alpha channel for src
     );
  end;

(*
 * TDDBltBatch: BltBatch entry structure
 *)
  PDDBltBatch = ^TDDBltBatch;
  TDDBltBatch = packed record
    lprDest: PRect;
    lpDDSSrc: IDirectDrawSurface;
    lprSrc: PRect;
    dwFlags: DWORD;
    lpDDBltFx: TDDBltFX;
  end;

(*
 * TDDGammaRamp
 *)
  PDDGammaRamp = ^TDDGammaRamp;
  TDDGammaRamp = packed record
    red   : array[0..255] of WORD;
    green : array[0..255] of WORD;
    blue  : array[0..255] of WORD;
  end;

(*
 *  This is the structure within which DirectDraw returns data about the current graphics driver and chipset
 *)

  PDDDeviceIdentifier = ^TDDDeviceIdentifier;
  TDDDeviceIdentifier = packed record
    //
    // These elements are for presentation to the user only. They should not be used to identify particular
    // drivers, since this is unreliable and many different strings may be associated with the same
    // device, and the same driver from different vendors.
    //
    szDriver: array[0..MAX_DDDEVICEID_STRING-1] of Char;
    szDescription: array[0..MAX_DDDEVICEID_STRING-1] of Char;

    //
    // This element is the version of the DirectDraw/3D driver. It is legal to do <, > comparisons
    // on the whole 64 bits. Caution should be exercised if you use this element to identify problematic
    // drivers. It is recommended that guidDeviceIdentifier is used for this purpose.
    //
    // This version has the form:
    //  wProduct = HIWORD(liDriverVersion.HighPart)
    //  wVersion = LOWORD(liDriverVersion.HighPart)
    //  wSubVersion = HIWORD(liDriverVersion.LowPart)
    //  wBuild = LOWORD(liDriverVersion.LowPart)
    //
    liDriverVersion: TLargeInteger;     // Defined for applications and other 32 bit components

    //
    // These elements can be used to identify particular chipsets. Use with extreme caution.
    //   dwVendorId     Identifies the manufacturer. May be zero if unknown.
    //   dwDeviceId     Identifies the type of chipset. May be zero if unknown.
    //   dwSubSysId     Identifies the subsystem, typically this means the particular board. May be zero if unknown.
    //   dwRevision     Identifies the revision level of the chipset. May be zero if unknown.
    //
    dwVendorId: DWORD;
    dwDeviceId: DWORD;
    dwSubSysId: DWORD;
    dwRevision: DWORD;

    //
    // This element can be used to check changes in driver/chipset. This GUID is a unique identifier for the
    // driver/chipset pair. Use this element if you wish to track changes to the driver/chipset in order to
    // reprofile the graphics subsystem.
    // This element can also be used to identify particular problematic drivers.
    //
    guidDeviceIdentifier: TGUID;
  end;

(*
 * callbacks
 *)
  TClipperCallback = function(lpDDClipper: IDirectDrawClipper; hWnd: HWND;
      Code: DWORD; lpContext: Pointer): HResult; StdCall;
  TSurfacesStreamingCallback = function(Arg: DWORD): HResult; StdCall;

(*
 * TDDSurfaceDesc
 *)
  PDDSurfaceDesc_DX5 = ^TDDSurfaceDesc_DX5;
  TDDSurfaceDesc_DX5 = packed record
    dwSize: DWORD;                 // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                // determines what fields are valid
    dwHeight: DWORD;               // height of surface to be created
    dwWidth: DWORD;                // width of input surface
    case Integer of
    0: (
      dwLinearSize : DWORD;       // unused at the moment
     );
    1: (
      lPitch: LongInt;                 // distance to start of next line (return value only)
      dwBackBufferCount: DWORD;      // number of back buffers requested
      case Integer of
      0: (
        dwMipMapCount: DWORD;          // number of mip-map levels requested
        dwAlphaBitDepth: DWORD;        // depth of alpha buffer requested
        dwReserved: DWORD;             // reserved
        lpSurface: Pointer;              // pointer to the associated surface memory
        ddckCKDestOverlay: TDDColorKey;      // color key for destination overlay use
        ddckCKDestBlt: TDDColorKey;          // color key for destination blt use
        ddckCKSrcOverlay: TDDColorKey;       // color key for source overlay use
        ddckCKSrcBlt: TDDColorKey;           // color key for source blt use
        ddpfPixelFormat: TDDPixelFormat_DX5; // pixel format description of the surface
        ddsCaps: TDDSCaps;                // direct draw surface capabilities
       );
      1: (
        dwZBufferBitDepth: DWORD;      // depth of Z buffer requested
       );
      2: (
        dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
       );
     );
  end;

  PDDSurfaceDesc_DX6 = ^TDDSurfaceDesc_DX6;
  TDDSurfaceDesc_DX6 = packed record
    dwSize: DWORD;                 // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                // determines what fields are valid
    dwHeight: DWORD;               // height of surface to be created
    dwWidth: DWORD;                // width of input surface
    case Integer of
    0: (
      dwLinearSize : DWORD;       // unused at the moment
     );
    1: (
      lPitch: LongInt;                 // distance to start of next line (return value only)
      dwBackBufferCount: DWORD;      // number of back buffers requested
      case Integer of
      0: (
        dwMipMapCount: DWORD;          // number of mip-map levels requested
        dwAlphaBitDepth: DWORD;        // depth of alpha buffer requested
        dwReserved: DWORD;             // reserved
        lpSurface: Pointer;              // pointer to the associated surface memory
        ddckCKDestOverlay: TDDColorKey;      // color key for destination overlay use
        ddckCKDestBlt: TDDColorKey;          // color key for destination blt use
        ddckCKSrcOverlay: TDDColorKey;       // color key for source overlay use
        ddckCKSrcBlt: TDDColorKey;           // color key for source blt use
        ddpfPixelFormat: TDDPixelFormat_DX6; // pixel format description of the surface
        ddsCaps: TDDSCaps;                // direct draw surface capabilities
       );
      1: (
        dwZBufferBitDepth: DWORD;      // depth of Z buffer requested
       );
      2: (
        dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
       );
     );
  end;

  PDDSurfaceDesc = ^TDDSurfaceDesc;
{$IFDEF DIRECTX5}
  TDDSurfaceDesc = TDDSurfaceDesc_DX5;
{$ELSE}
  TDDSurfaceDesc = TDDSurfaceDesc_DX6;
{$ENDIF}


(*
 * TDDSurfaceDesc2
 *)
  PDDSurfaceDesc2 = ^TDDSurfaceDesc2;
  TDDSurfaceDesc2 = packed record
    dwSize: DWORD;                 // size of the TDDSurfaceDesc structure
    dwFlags: DWORD;                // determines what fields are valid
    dwHeight: DWORD;               // height of surface to be created
    dwWidth: DWORD;                // width of input surface
    case Integer of
    0: (
      lPitch : LongInt;                  // distance to start of next line (return value only)
     );
    1: (
      dwLinearSize : DWORD;              // Formless late-allocated optimized surface size
      dwBackBufferCount: DWORD;          // number of back buffers requested
      case Integer of
      0: (
        dwMipMapCount: DWORD;            // number of mip-map levels requested
        dwAlphaBitDepth: DWORD;          // depth of alpha buffer requested
        dwReserved: DWORD;               // reserved
        lpSurface: Pointer;              // pointer to the associated surface memory
        ddckCKDestOverlay: TDDColorKey;  // color key for destination overlay use
        ddckCKDestBlt: TDDColorKey;      // color key for destination blt use
        ddckCKSrcOverlay: TDDColorKey;   // color key for source overlay use
        ddckCKSrcBlt: TDDColorKey;       // color key for source blt use
        ddpfPixelFormat: TDDPixelFormat; // pixel format description of the surface
        ddsCaps: TDDSCaps2;              // direct draw surface capabilities
        dwTextureStage: DWORD;           // stage in multitexture cascade
       );
      1: (
        dwRefreshRate: DWORD;          // refresh rate (used when display mode is described)
       );
     );
  end;

(*
 * TDDOptSurfaceDesc
 *)

  PDDOptSurfaceDesc = ^TDDOptSurfaceDesc;
  TDDOptSurfaceDesc = packed record
    dwSize : DWORD;             // size of the DDOPTSURFACEDESC structure
    dwFlags : DWORD;            // determines what fields are valid
    ddSCaps : TDDSCaps2;        // Common caps like: Memory type
    ddOSCaps : TDDOSCaps;       // Common caps like: Memory type
    guid : TGUID;               // Compression technique GUID
    dwCompressionRatio : DWORD; // Compression ratio
  end;

(*
 * DDCOLORCONTROL
 *)
  PDDColorControl = ^TDDColorControl;
  TDDColorControl = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    lBrightness: LongInt;
    lContrast: LongInt;
    lHue: LongInt;
    lSaturation: LongInt;
    lSharpness: LongInt;
    lGamma: LongInt;
    lColorEnable: LongInt;
    dwReserved1: DWORD;
  end;

(*
 * callbacks
 *)

{$IFNDEF WINNT}
  TDDEnumModesCallback = function (const lpDDSurfaceDesc: TDDSurfaceDesc; lpContext: Pointer) : HResult; StdCall;
  TDDEnumModesCallback2 = function (const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer) : HResult; StdCall;
  TDDEnumSurfacesCallback = function (lpDDSurface: IDirectDrawSurface; const lpDDSurfaceDesc: TDDSurfaceDesc; lpContext: Pointer) : HResult; StdCall;
  TDDEnumSurfacesCallback2 = function (lpDDSurface: IDirectDrawSurface4; const lpDDSurfaceDesc: TDDSurfaceDesc2; lpContext: Pointer) : HResult; StdCall;
{$ENDIF}

(*
 * INTERACES FOLLOW:
 *      IDirectDraw
 *      IDirectDrawClipper
 *      IDirectDrawPalette
 *      IDirectDrawSurface
 *)

(*
 * IDirectDraw
 *)

  IDirectDraw = Interface (IUnknown)
    ['{6C14DB80-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; StdCall;
    function CreateClipper(dwFlags: DWORD; Out lplpDDClipper: IDirectDrawClipper; pUnkOuter: IUnknown) : HResult; StdCall; 
    function CreatePalette(dwFlags: DWORD; lpColorTable: pointer; Out lplpDDPalette: IDirectDrawPalette; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateSurface(var lpDDSurfaceDesc: TDDSurfaceDesc; Out lplpDDSurface: IDirectDrawSurface; pUnkOuter: IUnknown) : HResult; StdCall;
    function DuplicateSurface (lpDDSurface: IDirectDrawSurface; Out lplpDupDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function EnumDisplayModes (dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback) : HResult; StdCall;
    function EnumSurfaces (dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function FlipToGDISurface: HResult; StdCall;
    function GetCaps (Out lpDDDriverCaps: TDDCaps; Out lpDDHELCaps: TDDCaps) : HResult; StdCall;
    function GetDisplayMode (Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function GetFourCCCodes (var lpNumCodes: DWORD; lpCodes: PDWORD) : HResult; StdCall;
    function GetGDISurface (Out lplpGDIDDSSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetMonitorFrequency (Out lpdwFrequency: DWORD) : HResult; StdCall;
    function GetScanLine (Out lpdwScanLine: DWORD) : HResult; StdCall;
    function GetVerticalBlankStatus (Out lpbIsInVB: BOOL) : HResult; StdCall;
    function Initialize (const lpGUID: TGUID) : HResult; StdCall;
    function RestoreDisplayMode: HResult; StdCall;
    function SetCooperativeLevel (hWnd: HWND; dwFlags: DWORD) : HResult; StdCall;
    (*** Warning!  SetDisplayMode differs between DirectDraw 1 and DirectDraw 2 ***)
    function SetDisplayMode (dwWidth: DWORD; dwHeight: DWORD; dwBpp: DWORD) : HResult; StdCall;
    function WaitForVerticalBlank (dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
  end;

  IDirectDraw2 = Interface (IUnknown)
    ['{B3A6F3E0-2B43-11CF-A2DE-00AA00B93356}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; StdCall;
    function CreateClipper (dwFlags: DWORD; Out lplpDDClipper: IDirectDrawClipper; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreatePalette (dwFlags: DWORD; lpColorTable: pointer;  Out lplpDDPalette: IDirectDrawPalette; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateSurface (var lpDDSurfaceDesc: TDDSurfaceDesc; Out lplpDDSurface: IDirectDrawSurface; pUnkOuter: IUnknown) : HResult; StdCall;
    function DuplicateSurface (lpDDSurface: IDirectDrawSurface; Out lplpDupDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function EnumDisplayModes (dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback) : HResult; StdCall;
    function EnumSurfaces (dwFlags: DWORD; var lpDDSD: TDDSurfaceDesc; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function FlipToGDISurface: HResult; StdCall;
    function GetCaps (Out lpDDDriverCaps: TDDCaps; Out lpDDHELCaps: TDDCaps) : HResult; StdCall;
    function GetDisplayMode (Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function GetFourCCCodes (var lpNumCodes: DWORD; lpCodes: PDWORD) : HResult; StdCall;
    function GetGDISurface (Out lplpGDIDDSSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetMonitorFrequency (Out lpdwFrequency: DWORD) : HResult; StdCall;
    function GetScanLine (Out lpdwScanLine: DWORD) : HResult; StdCall;
    function GetVerticalBlankStatus (Out lpbIsInVB: BOOL) : HResult; StdCall;
    function Initialize (lpGUID: PGUID) : HResult; StdCall;
    function RestoreDisplayMode: HResult; StdCall;
    function SetCooperativeLevel (hWnd: HWND; dwFlags: DWORD) : HResult; StdCall;
    (*** Warning!  SetDisplayMode differs between DirectDraw 1 and DirectDraw 2 ***)
    function SetDisplayMode (dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD; dwRefreshRate: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function WaitForVerticalBlank (dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
    (*** Added in the v2 Interface ***)
    function GetAvailableVidMem (var lpDDSCaps: TDDSCaps; Out lpdwTotal, lpdwFree: DWORD) : HResult; StdCall;
  end;

  IDirectDraw4 = Interface (IUnknown)
    ['{B3A6F3E0-2B43-11CF-A2DE-00AA00B93356}']
    (*** IDirectDraw methods ***)
    function Compact: HResult; StdCall;
    function CreateClipper (dwFlags: DWORD; Out lplpDDClipper:IDirectDrawClipper;
              pUnkOuter: IUnknown) : HResult; StdCall;
    function CreatePalette (dwFlags: DWORD; lpColorTable: pointer; Out lplpDDPalette: IDirectDrawPalette; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateSurface (const lpDDSurfaceDesc: TDDSurfaceDesc2;
            Out lplpDDSurface: IDirectDrawSurface4; pUnkOuter: IUnknown) : HResult; StdCall;
    function DuplicateSurface (lpDDSurface: IDirectDrawSurface4; Out lplpDupDDSurface: IDirectDrawSurface4) : HResult; StdCall;
    function EnumDisplayModes (dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc2; lpContext: Pointer; lpEnumModesCallback: TDDEnumModesCallback2) : HResult; StdCall;
    function EnumSurfaces (dwFlags: DWORD; const lpDDSD: TDDSurfaceDesc2; lpContext: Pointer; lpEnumCallback: TDDEnumSurfacesCallback2) : HResult; StdCall;
    function FlipToGDISurface: HResult; StdCall;
    function GetCaps (Out lpDDDriverCaps: TDDCaps; Out lpDDHELCaps: TDDCaps) : HResult; StdCall;
    function GetDisplayMode (Out lpDDSurfaceDesc: TDDSurfaceDesc2) : HResult; StdCall;
    function GetFourCCCodes (var lpNumCodes: DWORD; lpCodes: PDWORD) : HResult; StdCall;
    function GetGDISurface (Out lplpGDIDDSSurface: IDirectDrawSurface4) : HResult; StdCall;
    function GetMonitorFrequency (Out lpdwFrequency: DWORD) : HResult; StdCall;
    function GetScanLine (Out lpdwScanLine: DWORD) : HResult; StdCall;
    function GetVerticalBlankStatus (Out lpbIsInVB: BOOL) : HResult; StdCall;
    function Initialize (const lpGUID: TGUID) : HResult; StdCall;
    function RestoreDisplayMode: HResult; StdCall;
    function SetCooperativeLevel (hWnd: HWND; dwFlags: DWORD) : HResult; StdCall;
    (*** Warning!  SetDisplayMode differs between DirectDraw 1 and DirectDraw 2 ***)
    function SetDisplayMode (dwWidth: DWORD; dwHeight: DWORD; dwBPP: DWORD; dwRefreshRate: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function WaitForVerticalBlank (dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
    (*** Added in the v2 Interface ***)
    function GetAvailableVidMem (const lpDDSCaps: TDDSCaps2; Out lpdwTotal, lpdwFree: DWORD) : HResult; StdCall;
    (*** Added in the V4 Interface ***)
    function GetSurfaceFromDC (hdc : Windows.HDC; Out lpDDS4: IDirectDrawSurface4) : HResult; StdCall;
    function RestoreAllSurfaces : HResult; StdCall;
    function TestCooperativeLevel : HResult; StdCall;
    function GetDeviceIdentifier (Out lpdddi: TDDDeviceIdentifier; dwFlags: DWORD) : HResult; StdCall;
  end;

(*
 * IDirectDrawPalette
 *)

  IDirectDrawPalette = Interface (IUnknown)
    ['{6C14DB84-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDrawPalette methods ***)
    function GetCaps (Out lpdwCaps: DWORD) : HResult; StdCall;
    function GetEntries (dwFlags: DWORD; dwBase: DWORD; dwNumEntries: DWORD; lpEntries: pointer) : HResult; StdCall;
    function Initialize (lpDD: IDirectDraw; dwFlags: DWORD; lpDDColorTable: pointer) : HResult; StdCall;
    function SetEntries (dwFlags: DWORD; dwStartingEntry: DWORD; dwCount: DWORD; lpEntries: pointer) : HResult; StdCall;
  end;

(*
 * IDirectDrawClipper
 *)

  IDirectDrawClipper = Interface (IUnknown)
    ['{6C14DB85-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDrawClipper methods ***)
    function GetClipList (lpRect: PRect; lpClipList: PRgnData; var lpdwSize: DWORD) : HResult; StdCall;
    function GetHWnd (Out lphWnd: HWND) : HResult; StdCall;
    function Initialize (lpDD: IDirectDraw; dwFlags: DWORD) : HResult; StdCall;
    function IsClipListChanged (Out lpbChanged: BOOL) : HResult; StdCall;
    function SetClipList (lpClipList: PRgnData; dwFlags: DWORD) : HResult; StdCall;
    function SetHWnd (dwFlags: DWORD; hWnd: HWND) : HResult; StdCall;
  end;

(*
 * IDirectDrawSurface and related Interfaces
 *)

  IDirectDrawSurface = Interface (IUnknown)
    ['{6C14DB81-A733-11CE-A521-0020AF0BE560}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface (lpDDSAttachedSurface: IDirectDrawSurface) : HResult; StdCall;
    function AddOverlayDirtyRect (const lpRect: TRect) : HResult; StdCall;
    function Blt (lpDestRect: PRect; lpDDSrcSurface: IDirectDrawSurface; lpSrcRect: PRect;
            dwFlags: DWORD; lpDDBltFx: PDDBltFX) : HResult; StdCall;
    function BltBatch (const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function BltFast (dwX: DWORD; dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface; const lpSrcRect: TRect; dwTrans: DWORD) : HResult; StdCall;
    function DeleteAttachedSurface (dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface) : HResult; StdCall;
    function EnumAttachedSurfaces (lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function EnumOverlayZOrders (dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function Flip (lpDDSurfaceTargetOverride: IDirectDrawSurface; dwFlags: DWORD) : HResult; StdCall;
    function GetAttachedSurface (var lpDDSCaps: TDDSCaps; var lplpDDAttachedSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetBltStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetCaps (Out lpDDSCaps: TDDSCaps) : HResult; StdCall;
    function GetClipper (Out lplpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function GetColorKey (dwFlags: DWORD; Out lpDDColorKey: TDDColorKey) : HResult; StdCall;
    function GetDC (Out lphDC: HDC) : HResult; StdCall;
    function GetFlipStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetOverlayPosition (Out lplX, lplY: LongInt) : HResult; StdCall;
    function GetPalette (Out lplpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function GetPixelFormat (Out lpDDPixelFormat: TDDPixelFormat) : HResult; StdCall;
    function GetSurfaceDesc (Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function Initialize (lpDD: IDirectDraw; Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function IsLost: HResult; StdCall;
    function Lock (lpDestRect: PRect; Out lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
    function ReleaseDC (hDC: Windows.HDC) : HResult; StdCall;
    function _Restore: HResult; StdCall;
    function SetClipper (lpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function SetColorKey (dwFlags: DWORD; lpDDColorKey: PDDColorKey) : HResult; StdCall;
    function SetOverlayPosition (lX, lY: LongInt) : HResult; StdCall;
    function SetPalette (lpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function Unlock (lpSurfaceData: Pointer) : HResult; StdCall;
    function UpdateOverlay (lpSrcRect: PRect; lpDDDestSurface: IDirectDrawSurface; lpDestRect: PRect; dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX) : HResult; StdCall;
    function UpdateOverlayDisplay (dwFlags: DWORD) : HResult; StdCall;
    function UpdateOverlayZOrder (dwFlags: DWORD;  lpDDSReference: IDirectDrawSurface) : HResult; StdCall;
  end;

(*
 * IDirectDrawSurface2 and related Interfaces
 *)

  IDirectDrawSurface2 = Interface (IUnknown)
    ['{57805885-6eec-11cf-9441-a82303c10e27}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface (lpDDSAttachedSurface: IDirectDrawSurface2) : HResult; StdCall;
    function AddOverlayDirtyRect (const lpRect: TRect) : HResult; StdCall;
    function Blt (lpDestRect: PRect; lpDDSrcSurface: IDirectDrawSurface2; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX) : HResult; StdCall;
    function BltBatch (const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function BltFast (dwX: DWORD; dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface2; const lpSrcRect: TRect; dwTrans: DWORD) : HResult; StdCall; 
    function DeleteAttachedSurface (dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface2) : HResult; StdCall;
    function EnumAttachedSurfaces (lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function EnumOverlayZOrders (dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function Flip (lpDDSurfaceTargetOverride: IDirectDrawSurface2; dwFlags: DWORD) : HResult; StdCall;
    function GetAttachedSurface (var lpDDSCaps: TDDSCaps; Out lplpDDAttachedSurface: IDirectDrawSurface2) : HResult; StdCall;
    function GetBltStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetCaps (Out lpDDSCaps: TDDSCaps) : HResult; StdCall;
    function GetClipper (Out lplpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function GetColorKey (dwFlags: DWORD; Out lpDDColorKey: TDDColorKey) : HResult; StdCall;
    function GetDC (Out lphDC: HDC) : HResult; StdCall;
    function GetFlipStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetOverlayPosition (Out lplX, lplY: LongInt) : HResult; StdCall;
    function GetPalette (Out lplpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function GetPixelFormat (Out lpDDPixelFormat: TDDPixelFormat) : HResult; StdCall;
    function GetSurfaceDesc (Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function Initialize (lpDD: IDirectDraw; Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function IsLost: HResult; StdCall;
    function Lock (lpDestRect: PRect; Out lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
    function ReleaseDC (hDC: Windows.HDC) : HResult; StdCall;
    function _Restore: HResult; StdCall;
    function SetClipper (lpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function SetColorKey (dwFlags: DWORD; lpDDColorKey: PDDColorKey) : HResult; StdCall;
    function SetOverlayPosition (lX, lY: LongInt) : HResult; StdCall;
    function SetPalette (lpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function Unlock (lpSurfaceData: Pointer) : HResult; StdCall;
    function UpdateOverlay (lpSrcRect: PRect; lpDDDestSurface: IDirectDrawSurface2; lpDestRect: PRect; dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX) : HResult; StdCall;
    function UpdateOverlayDisplay (dwFlags: DWORD) : HResult; StdCall;
    function UpdateOverlayZOrder (dwFlags: DWORD;
        lpDDSReference: IDirectDrawSurface2) : HResult; StdCall;
    (*** Added in the v2 Interface ***)
    function GetDDInterface (var lplpDD: IDirectDraw) : HResult; StdCall;
    function PageLock (dwFlags: DWORD) : HResult; StdCall;
    function PageUnlock (dwFlags: DWORD) : HResult; StdCall;
  end;

  IDirectDrawSurface3 = Interface (IUnknown)
    ['{DA044E00-69B2-11D0-A1D5-00AA00B8DFBB}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface (lpDDSAttachedSurface: IDirectDrawSurface3) : HResult; StdCall;
    function AddOverlayDirtyRect (const lpRect: TRect) : HResult; StdCall;
    function Blt (lpDestRect: PRect; lpDDSrcSurface: IDirectDrawSurface3; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX) : HResult; StdCall;
    function BltBatch (const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function BltFast (dwX: DWORD; dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface3; const lpSrcRect: TRect; dwTrans: DWORD) : HResult; StdCall;
    function DeleteAttachedSurface (dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface3) : HResult; StdCall;
    function EnumAttachedSurfaces (lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function EnumOverlayZOrders (dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback) : HResult; StdCall;
    function Flip (lpDDSurfaceTargetOverride: IDirectDrawSurface3; dwFlags: DWORD) : HResult; StdCall;
    function GetAttachedSurface (var lpDDSCaps: TDDSCaps; Out lplpDDAttachedSurface: IDirectDrawSurface3) : HResult; StdCall;
    function GetBltStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetCaps (Out lpDDSCaps: TDDSCaps) : HResult; StdCall;
    function GetClipper (Out lplpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function GetColorKey (dwFlags: DWORD; Out lpDDColorKey: TDDColorKey) : HResult; StdCall;
    function GetDC (Out lphDC: HDC) : HResult; StdCall;
    function GetFlipStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetOverlayPosition (Out lplX, lplY: LongInt) : HResult; StdCall;
    function GetPalette (Out lplpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function GetPixelFormat (Out lpDDPixelFormat: TDDPixelFormat) : HResult; StdCall;
    function GetSurfaceDesc (Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function Initialize (lpDD: IDirectDraw; Out lpDDSurfaceDesc: TDDSurfaceDesc) : HResult; StdCall;
    function IsLost: HResult; StdCall;
    function Lock (lpDestRect: PRect; Out lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
    function ReleaseDC (hDC: Windows.HDC) : HResult; StdCall;
    function _Restore: HResult; StdCall;
    function SetClipper (lpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function SetColorKey (dwFlags: DWORD; lpDDColorKey: PDDColorKey) : HResult; StdCall;
    function SetOverlayPosition (lX, lY: LongInt) : HResult; StdCall;
    function SetPalette (lpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function Unlock (lpSurfaceData: Pointer) : HResult; StdCall;
    function UpdateOverlay (lpSrcRect: PRect; lpDDDestSurface: IDirectDrawSurface3; lpDestRect: PRect; dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX) : HResult; StdCall;
    function UpdateOverlayDisplay (dwFlags: DWORD) : HResult; StdCall;
    function UpdateOverlayZOrder (dwFlags: DWORD; lpDDSReference: IDirectDrawSurface3) : HResult; StdCall;
    (*** Added in the v2 Interface ***)
    function GetDDInterface (Out lplpDD: IDirectDraw) : HResult; StdCall;
    function PageLock (dwFlags: DWORD) : HResult; StdCall;
    function PageUnlock (dwFlags: DWORD) : HResult; StdCall;
    (*** Added in the V3 Interface ***)
    function SetSurfaceDesc(const lpddsd: TDDSurfaceDesc; dwFlags: DWORD) : HResult; StdCall;
  end;

(*
 * IDirectDrawSurface4 and related Interfaces
 *)
  IDirectDrawSurface4 = Interface (IUnknown)
    ['{0B2B8630-AD35-11D0-8EA6-00609797EA5B}']
    (*** IDirectDrawSurface methods ***)
    function AddAttachedSurface (lpDDSAttachedSurface: IDirectDrawSurface4) : HResult; StdCall;
    function AddOverlayDirtyRect (const lpRect: TRect) : HResult; StdCall;
    function Blt (lpDestRect: PRect; lpDDSrcSurface: IDirectDrawSurface4; lpSrcRect: PRect; dwFlags: DWORD; lpDDBltFx: PDDBltFX) : HResult; StdCall;
    function BltBatch (const lpDDBltBatch: TDDBltBatch; dwCount: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function BltFast (dwX: DWORD; dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface4; const lpSrcRect: TRect; dwTrans: DWORD) : HResult; StdCall;
    function DeleteAttachedSurface (dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface4) : HResult; StdCall;
    function EnumAttachedSurfaces (lpContext: Pointer; lpEnumSurfacesCallback: TDDEnumSurfacesCallback2) : HResult; StdCall;
    function EnumOverlayZOrders (dwFlags: DWORD; lpContext: Pointer; lpfnCallback: TDDEnumSurfacesCallback2) : HResult; StdCall;
    function Flip (lpDDSurfaceTargetOverride: IDirectDrawSurface4; dwFlags: DWORD) : HResult; StdCall;
    function GetAttachedSurface (const lpDDSCaps: TDDSCaps2; Out lplpDDAttachedSurface: IDirectDrawSurface4) : HResult; StdCall;
    function GetBltStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetCaps (Out lpDDSCaps: TDDSCaps2) : HResult; StdCall;
    function GetClipper (Out lplpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function GetColorKey (dwFlags: DWORD; Out lpDDColorKey: TDDColorKey) : HResult; StdCall;
    function GetDC (Out lphDC: HDC) : HResult; StdCall;
    function GetFlipStatus (dwFlags: DWORD) : HResult; StdCall;
    function GetOverlayPosition (Out lplX, lplY: LongInt) : HResult; StdCall;
    function GetPalette (Out lplpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function GetPixelFormat (Out lpDDPixelFormat: TDDPixelFormat) : HResult; StdCall;
    function GetSurfaceDesc (Out lpDDSurfaceDesc: TDDSurfaceDesc2) : HResult; StdCall;
    function Initialize (lpDD: IDirectDraw; Out lpDDSurfaceDesc: TDDSurfaceDesc2) : HResult; StdCall;
    function IsLost: HResult; StdCall;
    function Lock (lpDestRect: PRect; Out lpDDSurfaceDesc: TDDSurfaceDesc2; dwFlags: DWORD; hEvent: THandle) : HResult; StdCall;
    function ReleaseDC (hDC: Windows.HDC) : HResult; StdCall;
    function _Restore: HResult; StdCall;
    function SetClipper (lpDDClipper: IDirectDrawClipper) : HResult; StdCall;
    function SetColorKey (dwFlags: DWORD; lpDDColorKey: PDDColorKey) : HResult; StdCall;
    function SetOverlayPosition (lX, lY: LongInt) : HResult; StdCall;
    function SetPalette (lpDDPalette: IDirectDrawPalette) : HResult; StdCall;
    function Unlock (lpRect: PRect) : HResult; StdCall;
    function UpdateOverlay (lpSrcRect: PRect; lpDDDestSurface: IDirectDrawSurface4; lpDestRect: PRect; dwFlags: DWORD; lpDDOverlayFx: PDDOverlayFX) : HResult; StdCall;
    function UpdateOverlayDisplay (dwFlags: DWORD) : HResult; StdCall;
    function UpdateOverlayZOrder (dwFlags: DWORD; lpDDSReference: IDirectDrawSurface4) : HResult; StdCall;
    (*** Added in the v2 Interface ***)
    function GetDDInterface (Out lplpDD: IUnknown) : HResult; StdCall;
    function PageLock (dwFlags: DWORD) : HResult; StdCall;
    function PageUnlock (dwFlags: DWORD) : HResult; StdCall;
    (*** Added in the V3 Interface ***)
    function SetSurfaceDesc(const lpddsd2: TDDSurfaceDesc2; dwFlags: DWORD) : HResult; StdCall;
    (*** Added in the v4 Interface ***)
    function SetPrivateData(const guidTag: TGUID; lpData: pointer; cbSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function GetPrivateData(const guidTag: TGUID; lpBuffer: pointer; var lpcbBufferSize: DWORD) : HResult; StdCall;
    function FreePrivateData(const guidTag: TGUID) : HResult; StdCall;
    function GetUniquenessValue(Out lpValue: DWORD) : HResult; StdCall;
    function ChangeUniquenessValue : HResult; StdCall;
  end;

  IDirectDrawColorControl = Interface (IUnknown)
    ['{4B9F0EE0-0D7E-11D0-9B06-00A0C903A3B8}']
    function GetColorControls(Out lpColorControl: TDDColorControl) : HResult; StdCall;
    function SetColorControls(const lpColorControl: TDDColorControl) : HResult; StdCall;
  end;

(*
 * IDirectDrawGammaControl
 *)
  IDirectDrawGammaControl = Interface (IUnknown)
    ['{69C11C3E-B46B-11D1-AD7A-00C04FC29B4E}']
    function GetGammaRamp (dwFlags: DWORD; Out lpRampData: TDDGammaRamp) : HResult; StdCall;
    function SetGammaRamp (dwFlags: DWORD; const lpRampData: TDDGammaRamp) : HResult; StdCall;
  end;

const

(*
 * ddsCaps field is valid.
 *)
  DDSD_CAPS               = $00000001;     // default

(*
 * dwHeight field is valid.
 *)
  DDSD_HEIGHT             = $00000002;

(*
 * dwWidth field is valid.
 *)
  DDSD_WIDTH              = $00000004;

(*
 * lPitch is valid.
 *)
  DDSD_PITCH              = $00000008;

(*
 * dwBackBufferCount is valid.
 *)
  DDSD_BACKBUFFERCOUNT    = $00000020;

(*
 * dwZBufferBitDepth is valid.  (shouldnt be used in DDSURFACEDESC2)
 *)
  DDSD_ZBUFFERBITDEPTH    = $00000040;

(*
 * dwAlphaBitDepth is valid.
 *)
   DDSD_ALPHABITDEPTH      = $00000080;

(*
 * lpSurface is valid.
 *)
  DDSD_LPSURFACE	   = $00000800;

(*
 * ddpfPixelFormat is valid.
 *)
  DDSD_PIXELFORMAT        = $00001000;

(*
 * ddckCKDestOverlay is valid.
 *)
  DDSD_CKDESTOVERLAY      = $00002000;

(*
 * ddckCKDestBlt is valid.
 *)
  DDSD_CKDESTBLT          = $00004000;

(*
 * ddckCKSrcOverlay is valid.
 *)
  DDSD_CKSRCOVERLAY       = $00008000;

(*
 * ddckCKSrcBlt is valid.
 *)
  DDSD_CKSRCBLT           = $00010000;

(*
 * dwMipMapCount is valid.
 *)
  DDSD_MIPMAPCOUNT        = $00020000;

 (*
  * dwRefreshRate is valid
  *)
  DDSD_REFRESHRATE        = $00040000;

(*
 * dwLinearSize is valid
 *)
  DDSD_LINEARSIZE	  = $00080000;

(*
 * dwTextureStage is valid
 *)
  DDSD_TEXTURESTAGE       = $00100000;

(*
 * All input fields are valid.
 *)
  DDSD_ALL		  = $001ff9ee;


(*
 * guid field is valid.
 *)
  DDOSD_GUID                  = $00000001;

(*
 * dwCompressionRatio field is valid.
 *)
  DDOSD_COMPRESSION_RATIO     = $00000002;

(*
 * ddSCaps field is valid.
 *)
  DDOSD_SCAPS                 = $00000004;

(*
 * ddOSCaps field is valid.
 *)
  DDOSD_OSCAPS                = $00000008;

(*
 * All input fields are valid.
 *)
  DDOSD_ALL                   = $0000000f;

(*
 * The surface's optimized pixelformat is compressed
 *)
  DDOSDCAPS_OPTCOMPRESSED			= $00000001;

(*
 * The surface's optimized pixelformat is reordered
 *)
  DDOSDCAPS_OPTREORDERED			= $00000002;

(*
 * The opt surface is a monolithic mipmap
 *)
  DDOSDCAPS_MONOLITHICMIPMAP		= $00000004;

(*
 * The valid Surf caps:
 *   DDSCAPS_SYSTEMMEMORY  	= $00000800;
 *   DDSCAPS_VIDEOMEMORY        = $00004000;
 *   DDSCAPS_LOCALVIDMEM        = $10000000;
 *   DDSCAPS_NONLOCALVIDMEM     = $20000000;
 *)
  DDOSDCAPS_VALIDSCAPS         	= $30004800;

(*
 * The valid OptSurf caps
 *)
  DDOSDCAPS_VALIDOSCAPS         	= $00000007;


(*
 * DDCOLORCONTROL
 *)

(*
 * lBrightness field is valid.
 *)
  DDCOLOR_BRIGHTNESS		= $00000001;

(*
 * lContrast field is valid.
 *)
  DDCOLOR_CONTRAST		= $00000002;

(*
 * lHue field is valid.
 *)
  DDCOLOR_HUE			= $00000004;

(*
 * lSaturation field is valid.
 *)
  DDCOLOR_SATURATION		= $00000008;

(*
 * lSharpness field is valid.
 *)
  DDCOLOR_SHARPNESS		= $00000010;

(*
 * lGamma field is valid.
 *)
  DDCOLOR_GAMMA			= $00000020;

(*
 * lColorEnable field is valid.
 *)
  DDCOLOR_COLORENABLE		= $00000040;



(*============================================================================
 *
 * Direct Draw Capability Flags
 *
 * These flags are used to describe the capabilities of a given Surface.
 * All flags are bit flags.
 *
 *==========================================================================*)

(****************************************************************************
 *
 * DIRECTDRAWSURFACE CAPABILITY FLAGS
 *
 ****************************************************************************)
(*
 * This bit currently has no meaning.
 *)
  DDSCAPS_RESERVED1                       = $00000001;

(*
 * Indicates that this surface contains alpha information.  The pixel
 * format must be interrogated to determine whether this surface
 * contains only alpha information or alpha information interlaced
 * with pixel color data (e.g. RGBA or YUVA).
 *)
  DDSCAPS_ALPHA                           = $00000002;

(*
 * Indicates that this surface is a backbuffer.  It is generally
 * set by CreateSurface when the DDSCAPS_FLIP capability bit is set.
 * It indicates that this surface is THE back buffer of a surface
 * flipping structure.  DirectDraw supports N surfaces in a
 * surface flipping structure.  Only the surface that immediately
 * precedeces the DDSCAPS_FRONTBUFFER has this capability bit set.
 * The other surfaces are identified as back buffers by the presence
 * of the DDSCAPS_FLIP capability, their attachment order, and the
 * absence of the DDSCAPS_FRONTBUFFER and DDSCAPS_BACKBUFFER
 * capabilities.  The bit is sent to CreateSurface when a standalone
 * back buffer is being created.  This surface could be attached to
 * a front buffer and/or back buffers to form a flipping surface
 * structure after the CreateSurface call.  See AddAttachments for
 * a detailed description of the behaviors in this case.
 *)
  DDSCAPS_BACKBUFFER                      = $00000004;

(*
 * Indicates a complex surface structure is being described.  A
 * complex surface structure results in the creation of more than
 * one surface.  The additional surfaces are attached to the root
 * surface.  The complex structure can only be destroyed by
 * destroying the root.
 *)
  DDSCAPS_COMPLEX                         = $00000008;

(*
 * Indicates that this surface is a part of a surface flipping structure.
 * When it is passed to CreateSurface the DDSCAPS_FRONTBUFFER and
 * DDSCAP_BACKBUFFER bits are not set.  They are set by CreateSurface
 * on the resulting creations.  The dwBackBufferCount field in the
 * TDDSurfaceDesc structure must be set to at least 1 in order for
 * the CreateSurface call to succeed.  The DDSCAPS_COMPLEX capability
 * must always be set with creating multiple surfaces through CreateSurface.
 *)
  DDSCAPS_FLIP                            = $00000010;

(*
 * Indicates that this surface is THE front buffer of a surface flipping
 * structure.  It is generally set by CreateSurface when the DDSCAPS_FLIP
 * capability bit is set.
 * If this capability is sent to CreateSurface then a standalonw front buffer
 * is created.  This surface will not have the DDSCAPS_FLIP capability.
 * It can be attached to other back buffers to form a flipping structure.
 * See AddAttachments for a detailed description of the behaviors in this
 * case.
 *)
  DDSCAPS_FRONTBUFFER                     = $00000020;

(*
 * Indicates that this surface is any offscreen surface that is not an overlay,
 * texture, zbuffer, front buffer, back buffer, or alpha surface.  It is used
 * to identify plain vanilla surfaces.
 *)
  DDSCAPS_OFFSCREENPLAIN                  = $00000040;

(*
 * Indicates that this surface is an overlay.  It may or may not be directly visible
 * depending on whether or not it is currently being overlayed onto the primary
 * surface.  DDSCAPS_VISIBLE can be used to determine whether or not it is being
 * overlayed at the moment.
 *)
  DDSCAPS_OVERLAY                         = $00000080;

(*
 * Indicates that unique DirectDrawPalette objects can be created and
 * attached to this surface.
 *)
  DDSCAPS_PALETTE                         = $00000100;

(*
 * Indicates that this surface is the primary surface.  The primary
 * surface represents what the user is seeing at the moment.
 *)
  DDSCAPS_PRIMARYSURFACE                  = $00000200;

(*
 * Indicates that this surface is the primary surface for the left eye.
 * The primary surface for the left eye represents what the user is seeing
 * at the moment with the users left eye.  When this surface is created the
 * DDSCAPS_PRIMARYSURFACE represents what the user is seeing with the users
 * right eye.
 *)
  DDSCAPS_PRIMARYSURFACELEFT              = $00000400;

(*
 * Indicates that this surface memory was allocated in system memory
 *)
  DDSCAPS_SYSTEMMEMORY                    = $00000800;

(*
 * Indicates that this surface can be used as a 3D texture.  It does not
 * indicate whether or not the surface is being used for that purpose.
 *)
  DDSCAPS_TEXTURE                         = $00001000;

(*
 * Indicates that a surface may be a destination for 3D rendering.  This
 * bit must be set in order to query for a Direct3D Device Interface
 * from this surface.
 *)
  DDSCAPS_3DDEVICE                        = $00002000;

(*
 * Indicates that this surface exists in video memory.
 *)
  DDSCAPS_VIDEOMEMORY                     = $00004000;

(*
 * Indicates that changes made to this surface are immediately visible.
 * It is always set for the primary surface and is set for overlays while
 * they are being overlayed and texture maps while they are being textured.
 *)
  DDSCAPS_VISIBLE                         = $00008000;

(*
 * Indicates that only writes are permitted to the surface.  Read accesses
 * from the surface may or may not generate a protection fault, but the
 * results of a read from this surface will not be meaningful.  READ ONLY.
 *)
  DDSCAPS_WRITEONLY                       = $00010000;

(*
 * Indicates that this surface is a z buffer. A z buffer does not contain
 * displayable information.  Instead it contains bit depth information that is
 * used to determine which pixels are visible and which are obscured.
 *)
  DDSCAPS_ZBUFFER                         = $00020000;

(*
 * Indicates surface will have a DC associated long term
 *)
  DDSCAPS_OWNDC                           = $00040000;

(*
 * Indicates surface should be able to receive live video
 *)
  DDSCAPS_LIVEVIDEO                       = $00080000;

(*
 * Indicates surface should be able to have a stream decompressed
 * to it by the hardware.
 *)
  DDSCAPS_HWCODEC                         = $00100000;

(*
 * Surface is a ModeX surface.
 *
 *)
  DDSCAPS_MODEX                           = $00200000;

(*
 * Indicates surface is one level of a mip-map. This surface will
 * be attached to other DDSCAPS_MIPMAP surfaces to form the mip-map.
 * This can be done explicitly, by creating a number of surfaces and
 * attaching them with AddAttachedSurface or by implicitly by CreateSurface.
 * If this bit is set then DDSCAPS_TEXTURE must also be set.
 *)
  DDSCAPS_MIPMAP                          = $00400000;

(*
 * This bit is reserved. It should not be specified.
 *)
  DDSCAPS_RESERVED2                       = $00800000;

(*
 * Indicates that memory for the surface is not allocated until the surface
 * is loaded (via the Direct3D texture Load() function).
 *)
  DDSCAPS_ALLOCONLOAD                     = $04000000;

(*
 * Indicates that the surface will recieve data from a video port.
 *)
  DDSCAPS_VIDEOPORT		          = $08000000;

(*
 * Indicates that a video memory surface is resident in true, local video
 * memory rather than non-local video memory. If this flag is specified then
 * so must DDSCAPS_VIDEOMEMORY. This flag is mutually exclusive with
 * DDSCAPS_NONLOCALVIDMEM.
 *)
  DDSCAPS_LOCALVIDMEM                     = $10000000;

(*
 * Indicates that a video memory surface is resident in non-local video
 * memory rather than true, local video memory. If this flag is specified
 * then so must DDSCAPS_VIDEOMEMORY. This flag is mutually exclusive with
 * DDSCAPS_LOCALVIDMEM.
 *)
  DDSCAPS_NONLOCALVIDMEM                  = $20000000;

(*
 * Indicates that this surface is a standard VGA mode surface, and not a
 * ModeX surface. (This flag will never be set in combination with the
 * DDSCAPS_MODEX flag).
 *)
  DDSCAPS_STANDARDVGAMODE                 = $40000000;

(*
 * Indicates that this surface will be an optimized surface. This flag is
 * currently only valid in conjunction with the DDSCAPS_TEXTURE flag. The surface
 * will be created without any underlying video memory until loaded.
 *)
  DDSCAPS_OPTIMIZED                       = $80000000;



(*
 * Indicates that this surface will receive data from a video port using
 * the de-interlacing hardware.  This allows the driver to allocate memory
 * for any extra buffers that may be required.  The DDSCAPS_VIDEOPORT and
 * DDSCAPS_OVERLAY flags must also be set.
 *)
  DDSCAPS2_HARDWAREDEINTERLACE            = $00000002;

(*
 * Indicates to the driver that this surface will be locked very frequently
 * (for procedural textures, dynamic lightmaps, etc). Surfaces with this cap
 * set must also have DDSCAPS_TEXTURE. This cap cannot be used with
 * DDSCAPS2_HINTSTATIC and DDSCAPS2_OPAQUE.
 *)
  DDSCAPS2_HINTDYNAMIC 			= $00000004;

(*
 * Indicates to the driver that this surface can be re-ordered/retiled on
 * load. This operation will not change the size of the texture. It is
 * relatively fast and symmetrical, since the application may lock these
 * bits (although it will take a performance hit when doing so). Surfaces
 * with this cap set must also have DDSCAPS_TEXTURE. This cap cannot be
 * used with DDSCAPS2_HINTDYNAMIC and DDSCAPS2_OPAQUE.
 *)
  DDSCAPS2_HINTSTATIC 			= $00000008;

(*
 * Indicates that the client would like this texture surface to be managed by the
 * DirectDraw/Direct3D runtime. Surfaces with this cap set must also have
 * DDSCAPS_TEXTURE and DDSCAPS_SYSTEMMEMORY.
 *)
  DDSCAPS2_TEXTUREMANAGE                  = $00000010;

(*
 * These bits are reserved for internal use *)
  DDSCAPS2_RESERVED1                      = $00000020;
  DDSCAPS2_RESERVED2                      = $00000040;

(*
 * Indicates to the driver that this surface will never be locked again.
 * The driver is free to optimize this surface via retiling and actual compression.
 * All calls to Lock() or Blts from this surface will fail. Surfaces with this
 * cap set must also have DDSCAPS_TEXTURE. This cap cannot be used with
 * DDSCAPS2_HINTDYNAMIC and DDSCAPS2_HINTSTATIC.
 *)
  DDSCAPS2_OPAQUE                         = $00000080;

(*
 * Applications should set this bit at CreateSurface time to indicate that they
 * intend to use antialiasing. Only valid if DDSCAPS_3DDEVICE is also set.
 *)
  DDSCAPS2_HINTANTIALIASING               = $00000100;




 (****************************************************************************
 *
 * DIRECTDRAW DRIVER CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Display hardware has 3D acceleration.
 *)
  DDCAPS_3D                       = $00000001;

(*
 * Indicates that DirectDraw will support only dest rectangles that are aligned
 * on DIRECTDRAWCAPS.dwAlignBoundaryDest boundaries of the surface, respectively.
 * READ ONLY.
 *)
  DDCAPS_ALIGNBOUNDARYDEST        = $00000002;

(*
 * Indicates that DirectDraw will support only source rectangles  whose sizes in
 * BYTEs are DIRECTDRAWCAPS.dwAlignSizeDest multiples, respectively.  READ ONLY.
 *)
  DDCAPS_ALIGNSIZEDEST            = $00000004;
(*
 * Indicates that DirectDraw will support only source rectangles that are aligned
 * on DIRECTDRAWCAPS.dwAlignBoundarySrc boundaries of the surface, respectively.
 * READ ONLY.
 *)
  DDCAPS_ALIGNBOUNDARYSRC         = $00000008;

(*
 * Indicates that DirectDraw will support only source rectangles  whose sizes in
 * BYTEs are DIRECTDRAWCAPS.dwAlignSizeSrc multiples, respectively.  READ ONLY.
 *)
  DDCAPS_ALIGNSIZESRC             = $00000010;

(*
 * Indicates that DirectDraw will create video memory surfaces that have a stride
 * alignment equal to DIRECTDRAWCAPS.dwAlignStride.  READ ONLY.
 *)
  DDCAPS_ALIGNSTRIDE              = $00000020;

(*
 * Display hardware is capable of blt operations.
 *)
  DDCAPS_BLT                      = $00000040;

(*
 * Display hardware is capable of asynchronous blt operations.
 *)
  DDCAPS_BLTQUEUE                 = $00000080;

(*
 * Display hardware is capable of color space conversions during the blt operation.
 *)
  DDCAPS_BLTFOURCC                = $00000100;

(*
 * Display hardware is capable of stretching during blt operations.
 *)
  DDCAPS_BLTSTRETCH               = $00000200;

(*
 * Display hardware is shared with GDI.
 *)
  DDCAPS_GDI                      = $00000400;

(*
 * Display hardware can overlay.
 *)
  DDCAPS_OVERLAY                  = $00000800;

(*
 * Set if display hardware supports overlays but can not clip them.
 *)
  DDCAPS_OVERLAYCANTCLIP          = $00001000;

(*
 * Indicates that overlay hardware is capable of color space conversions during
 * the overlay operation.
 *)
  DDCAPS_OVERLAYFOURCC            = $00002000;

(*
 * Indicates that stretching can be done by the overlay hardware.
 *)
  DDCAPS_OVERLAYSTRETCH           = $00004000;

(*
 * Indicates that unique DirectDrawPalettes can be created for DirectDrawSurfaces
 * other than the primary surface.
 *)
  DDCAPS_PALETTE                  = $00008000;

(*
 * Indicates that palette changes can be syncd with the veritcal refresh.
 *)
  DDCAPS_PALETTEVSYNC             = $00010000;

(*
 * Display hardware can return the current scan line.
 *)
  DDCAPS_READSCANLINE             = $00020000;

(*
 * Display hardware has stereo vision capabilities.  DDSCAPS_PRIMARYSURFACELEFT
 * can be created.
 *)
  DDCAPS_STEREOVIEW               = $00040000;

(*
 * Display hardware is capable of generating a vertical blank interrupt.
 *)
  DDCAPS_VBI                      = $00080000;

(*
 * Supports the use of z buffers with blt operations.
 *)
  DDCAPS_ZBLTS                    = $00100000;

(*
 * Supports Z Ordering of overlays.
 *)
  DDCAPS_ZOVERLAYS                = $00200000;

(*
 * Supports color key
 *)
  DDCAPS_COLORKEY                 = $00400000;

(*
 * Supports alpha surfaces
 *)
  DDCAPS_ALPHA                    = $00800000;

(*
 * colorkey is hardware assisted(DDCAPS_COLORKEY will also be set)
 *)
  DDCAPS_COLORKEYHWASSIST         = $01000000;

(*
 * no hardware support at all
 *)
  DDCAPS_NOHARDWARE               = $02000000;

(*
 * Display hardware is capable of color fill with bltter
 *)
  DDCAPS_BLTCOLORFILL             = $04000000;

(*
 * Display hardware is bank switched, and potentially very slow at
 * random access to VRAM.
 *)
  DDCAPS_BANKSWITCHED             = $08000000;

(*
 * Display hardware is capable of depth filling Z-buffers with bltter
 *)
  DDCAPS_BLTDEPTHFILL             = $10000000;

(*
 * Display hardware is capable of clipping while bltting.
 *)
  DDCAPS_CANCLIP                  = $20000000;

(*
 * Display hardware is capable of clipping while stretch bltting.
 *)
  DDCAPS_CANCLIPSTRETCHED         = $40000000;

(*
 * Display hardware is capable of bltting to or from system memory
 *)
  DDCAPS_CANBLTSYSMEM             = $80000000;


 (****************************************************************************
 *
 * MORE DIRECTDRAW DRIVER CAPABILITY FLAGS (dwCaps2)
 *
 ****************************************************************************)

(*
 * Display hardware is certified
 *)
  DDCAPS2_CERTIFIED               = $00000001;

(*
 * Driver cannot interleave 2D operations (lock and blt) to surfaces with
 * Direct3D rendering operations between calls to BeginScene() and EndScene()
 *)
  DDCAPS2_NO2DDURING3DSCENE       = $00000002;

(*
 * Display hardware contains a video port
 *)
  DDCAPS2_VIDEOPORT	          = $00000004;

(*
 * The overlay can be automatically flipped according to the video port
 * VSYNCs, providing automatic doubled buffered display of video port
 * data using an overlay
 *)
  DDCAPS2_AUTOFLIPOVERLAY	  = $00000008;

(*
 * Overlay can display each field of interlaced data individually while
 * it is interleaved in memory without causing jittery artifacts.
 *)
  DDCAPS2_CANBOBINTERLEAVED	= $00000010;

(*
 * Overlay can display each field of interlaced data individually while
 * it is not interleaved in memory without causing jittery artifacts.
 *)
  DDCAPS2_CANBOBNONINTERLEAVED	= $00000020;

(*
 * The overlay surface contains color controls (brightness, sharpness, etc.)
 *)
  DDCAPS2_COLORCONTROLOVERLAY	= $00000040;

(*
 * The primary surface contains color controls (gamma, etc.)
 *)
  DDCAPS2_COLORCONTROLPRIMARY	= $00000080;

(*
 * RGBZ -> RGB supported for 16:16 RGB:Z
 *)
  DDCAPS2_CANDROPZ16BIT		= $00000100;

(*
 * Driver supports non-local video memory.
 *)
  DDCAPS2_NONLOCALVIDMEM          = $00000200;

(*
 * Dirver supports non-local video memory but has different capabilities for
 * non-local video memory surfaces. If this bit is set then so must
 * DDCAPS2_NONLOCALVIDMEM.
 *)
  DDCAPS2_NONLOCALVIDMEMCAPS      = $00000400;

(*
 * Driver neither requires nor prefers surfaces to be pagelocked when performing
 * blts involving system memory surfaces
 *)
  DDCAPS2_NOPAGELOCKREQUIRED      = $00000800;

(*
 * Driver can create surfaces which are wider than the primary surface
 *)
  DDCAPS2_WIDESURFACES            = $00001000;

(*
 * Driver supports bob without using a video port by handling the
 * DDFLIP_ODD and DDFLIP_EVEN flags specified in Flip.
 *)
  DDCAPS2_CANFLIPODDEVEN          = $00002000;

(*
 * Driver supports bob using hardware
 *)
  DDCAPS2_CANBOBHARDWARE          = $00004000;

(*
 * Driver supports bltting any FOURCC surface to another surface of the same FOURCC
 *)
  DDCAPS2_COPYFOURCC              = $00008000;


(*
 * Driver supports loadable gamma ramps for the primary surface
 *)
  DDCAPS2_PRIMARYGAMMA            = $00020000;

(*
 * Driver can render in windowed mode.
 *)
  DDCAPS2_CANRENDERWINDOWED       = $00080000;

(*
 * A calibrator is available to adjust the gamma ramp according to the
 * physical display properties so that the result will be identical on
 * all calibrated systems.
 *)
  DDCAPS2_CANCALIBRATEGAMMA       = $00100000;

(*
 * Indicates that the driver will respond to DDFLIP_INTERVALn flags
 *)
  DDCAPS2_FLIPINTERVAL            = $00200000;

(*
 * Indicates that the driver will respond to DDFLIP_NOVSYNC
 *)
   DDCAPS2_FLIPNOVSYNC             = $00400000;

(****************************************************************************
 *
 * DIRECTDRAW FX ALPHA CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Supports alpha blending around the edge of a source color keyed surface.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAEDGEBLEND         = $00000001;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value becomes
 * more opaque as the alpha value increases.  (0 is transparent.)
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAPIXELS            = $00000002;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha 
 * information in the pixel format can be 1,2,4, or 8.  The alpha value 
 * becomes more transparent as the alpha value increases.  (0 is opaque.) 
 * This flag can only be set if DDCAPS_ALPHA is set.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHAPIXELSNEG         = $00000004;

(*
 * Supports alpha only surfaces.  The bit depth of an alpha only surface can be
 * 1,2,4, or 8.  The alpha value becomes more opaque as the alpha value increases.
 * (0 is transparent.)
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHASURFACES          = $00000008;

(*
 * The depth of the alpha channel data can range can be 1,2,4, or 8.
 * The NEG suffix indicates that this alpha channel becomes more transparent
 * as the alpha value increases. (0 is opaque.)  This flag can only be set if
 * DDCAPS_ALPHA is set.
 * For Blt.
 *)
  DDFXALPHACAPS_BLTALPHASURFACESNEG       = $00000010;

(*
 * Supports alpha blending around the edge of a source color keyed surface.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAEDGEBLEND     = $00000020;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha
 * information in the pixel format can be 1,2,4, or 8.  The alpha value becomes
 * more opaque as the alpha value increases.  (0 is transparent.)
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAPIXELS        = $00000040;

(*
 * Supports alpha information in the pixel format.  The bit depth of alpha 
 * information in the pixel format can be 1,2,4, or 8.  The alpha value 
 * becomes more transparent as the alpha value increases.  (0 is opaque.) 
 * This flag can only be set if DDCAPS_ALPHA is set.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHAPIXELSNEG     = $00000080;

(*
 * Supports alpha only surfaces.  The bit depth of an alpha only surface can be
 * 1,2,4, or 8.  The alpha value becomes more opaque as the alpha value increases.
 * (0 is transparent.)
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHASURFACES      = $00000100;

(*
 * The depth of the alpha channel data can range can be 1,2,4, or 8.  
 * The NEG suffix indicates that this alpha channel becomes more transparent
 * as the alpha value increases. (0 is opaque.)  This flag can only be set if
 * DDCAPS_ALPHA is set.
 * For Overlays.
 *)
  DDFXALPHACAPS_OVERLAYALPHASURFACESNEG   = $00000200;

(****************************************************************************
 *
 * DIRECTDRAW FX CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Uses arithmetic operations to stretch and shrink surfaces during blt
 * rather than pixel doubling techniques.  Along the Y axis.
 *)
  DDFXCAPS_BLTARITHSTRETCHY       = $00000020;

(*
 * Uses arithmetic operations to stretch during blt
 * rather than pixel doubling techniques.  Along the Y axis. Only
 * works for x1, x2, etc.
 *)
  DDFXCAPS_BLTARITHSTRETCHYN      = $00000010;

(*
 * Supports mirroring left to right in blt.
 *)
  DDFXCAPS_BLTMIRRORLEFTRIGHT     = $00000040;

(*
 * Supports mirroring top to bottom in blt.
 *)
  DDFXCAPS_BLTMIRRORUPDOWN        = $00000080;

(*
 * Supports arbitrary rotation for blts.
 *)
  DDFXCAPS_BLTROTATION            = $00000100;

(*
 * Supports 90 degree rotations for blts.
 *)
   DDFXCAPS_BLTROTATION90          = $00000200;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKX             = $00000400;

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKXN            = $00000800;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * y axis (horizontal direction) for blts.  
 *)
  DDFXCAPS_BLTSHRINKY             = $00001000;

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the y axis (vertical direction) for blts.
 *)
  DDFXCAPS_BLTSHRINKYN            = $00002000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHX            = $00004000;

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the x axis (horizontal direction) for blts.
 *)
  DDFXCAPS_BLTSTRETCHXN           = $00008000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * y axis (horizontal direction) for blts.  
 *)
  DDFXCAPS_BLTSTRETCHY            = $00010000;

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the y axis (vertical direction) for blts.  
 *)
  DDFXCAPS_BLTSTRETCHYN           = $00020000;

(*
 * Uses arithmetic operations to stretch and shrink surfaces during 
 * overlay rather than pixel doubling techniques.  Along the Y axis 
 * for overlays.
 *)
  DDFXCAPS_OVERLAYARITHSTRETCHY   = $00040000;

(*
 * Uses arithmetic operations to stretch surfaces during 
 * overlay rather than pixel doubling techniques.  Along the Y axis
 * for overlays. Only works for x1, x2, etc.
 *)
  DDFXCAPS_OVERLAYARITHSTRETCHYN  = $00000008;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKX         = $00080000;

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSHRINKXN        = $00100000;

(*
 * DirectDraw supports arbitrary shrinking of a surface along the
 * y axis (horizontal direction) for overlays.  
 *)
  DDFXCAPS_OVERLAYSHRINKY         = $00200000;

(*
 * DirectDraw supports integer shrinking (1x,2x,) of a surface
 * along the y axis (vertical direction) for overlays.  
 *)
  DDFXCAPS_OVERLAYSHRINKYN        = $00400000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHX        = $00800000;

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the x axis (horizontal direction) for overlays.
 *)
  DDFXCAPS_OVERLAYSTRETCHXN       = $01000000;

(*
 * DirectDraw supports arbitrary stretching of a surface along the
 * y axis (horizontal direction) for overlays.  
 *)
  DDFXCAPS_OVERLAYSTRETCHY        = $02000000;

(*
 * DirectDraw supports integer stretching (1x,2x,) of a surface
 * along the y axis (vertical direction) for overlays.  
 *)
  DDFXCAPS_OVERLAYSTRETCHYN       = $04000000;

(*
 * DirectDraw supports mirroring of overlays across the vertical axis
 *)
  DDFXCAPS_OVERLAYMIRRORLEFTRIGHT = $08000000;

(*
 * DirectDraw supports mirroring of overlays across the horizontal axis
 *)
  DDFXCAPS_OVERLAYMIRRORUPDOWN    = $10000000;

(*
 * Driver can do alpha blending for blits.
 *)
  DDFXCAPS_BLTALPHA 		= $00000001;

(*
 * Driver can do geometric transformations (or warps) for blits.
 *)
  DDFXCAPS_BLTTRANSFORM		= $00000002;

(*
 * Driver can do surface-reconstruction filtering for warped blits.
 *)
  DDFXCAPS_BLTFILTER 	       = DDFXCAPS_BLTARITHSTRETCHY;

(*
 * Driver can do alpha blending for overlays.
 *)
  DDFXCAPS_OVERLAYALPHA 		= $00000004;

(*
 * Driver can do geometric transformations (or warps) for overlays.
 *)
  DDFXCAPS_OVERLAYTRANSFORM 	= $20000000;

(*
 * Driver can do surface-reconstruction filtering for warped overlays.
 *)
  DDFXCAPS_OVERLAYFILTER 	      = DDFXCAPS_OVERLAYARITHSTRETCHY;

(****************************************************************************
 *
 * DIRECTDRAW STEREO VIEW CAPABILITIES
 *
 ****************************************************************************)

(*
 * The stereo view is accomplished via enigma encoding.
 *)
  DDSVCAPS_ENIGMA                 = $00000001;

(*
 * The stereo view is accomplished via high frequency flickering.
 *)
  DDSVCAPS_FLICKER                = $00000002;

(*
 * The stereo view is accomplished via red and blue filters applied
 * to the left and right eyes.  All images must adapt their colorspaces
 * for this process.
 *)
  DDSVCAPS_REDBLUE                = $00000004;

(*
 * The stereo view is accomplished with split screen technology.
 *)
  DDSVCAPS_SPLIT                  = $00000008;

(****************************************************************************
 *
 * DIRECTDRAWPALETTE CAPABILITIES
 *
 ****************************************************************************)

(*
 * Index is 4 bits.  There are sixteen color entries in the palette table.
 *)
  DDPCAPS_4BIT                    = $00000001;

(*
 * Index is onto a 8 bit color index.  This field is only valid with the
 * DDPCAPS_1BIT, DDPCAPS_2BIT or DDPCAPS_4BIT capability and the target
 * surface is in 8bpp. Each color entry is one byte long and is an index
 * into destination surface's 8bpp palette.
 *)
  DDPCAPS_8BITENTRIES             = $00000002;

(*
 * Index is 8 bits.  There are 256 color entries in the palette table.
 *)
  DDPCAPS_8BIT                    = $00000004;

(*
 * Indicates that this DIRECTDRAWPALETTE should use the palette color array
 * passed into the lpDDColorArray parameter to initialize the DIRECTDRAWPALETTE
 * object.
 *)
  DDPCAPS_INITIALIZE              = $00000008;

(*
 * This palette is the one attached to the primary surface.  Changing this
 * table has immediate effect on the display unless DDPSETPAL_VSYNC is specified
 * and supported.
 *)
  DDPCAPS_PRIMARYSURFACE          = $00000010;

(*
 * This palette is the one attached to the primary surface left.  Changing
 * this table has immediate effect on the display for the left eye unless
 * DDPSETPAL_VSYNC is specified and supported.
 *)
  DDPCAPS_PRIMARYSURFACELEFT      = $00000020;

(*
 * This palette can have all 256 entries defined
 *)
  DDPCAPS_ALLOW256                = $00000040;

(*
 * This palette can have modifications to it synced with the monitors
 * refresh rate.
 *)
  DDPCAPS_VSYNC                   = $00000080;

(*
 * Index is 1 bit.  There are two color entries in the palette table.
 *)
  DDPCAPS_1BIT                    = $00000100;

(*
 * Index is 2 bit.  There are four color entries in the palette table.
 *)
  DDPCAPS_2BIT                    = $00000200;

(*
 * The peFlags member of PALETTEENTRY denotes an 8 bit alpha value
 *)
  DDPCAPS_ALPHA			= $00000400;

(****************************************************************************
 *
 * DIRECTDRAWPALETTE SETENTRY CONSTANTS
 *
 ****************************************************************************)


(****************************************************************************
 *
 * DIRECTDRAWPALETTE GETENTRY CONSTANTS
 *
 ****************************************************************************)

(* 0 is the only legal value *)

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SETPALETTE CONSTANTS
 *
 ****************************************************************************)

(*
 * The passed pointer is an IUnknown ptr. The cbData argument to SetPrivateData
 * must be set to sizeof(IUnknown^). DirectDraw will call AddRef through this
 * pointer and Release when the private data is destroyed. This includes when
 * the surface or palette is destroyed before such priovate data is destroyed.
 *)
  DDSPD_IUNKNOWNPOINTER           = $00000001;

(*
 * Private data is only valid for the current state of the object,
 * as determined by the uniqueness value.
 *)
  DDSPD_VOLATILE                  = $00000002;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SETPALETTE CONSTANTS
 *
 ****************************************************************************)


(****************************************************************************
 *
 * DIRECTDRAW BITDEPTH CONSTANTS
 *
 * NOTE:  These are only used to indicate supported bit depths.   These
 * are flags only, they are not to be used as an actual bit depth.   The
 * absolute numbers 1, 2, 4, 8, 16, 24 and 32 are used to indicate actual
 * bit depths in a surface or for changing the display mode.
 *
 ****************************************************************************)

(*
 * 1 bit per pixel.
 *)
  DDBD_1                  = $00004000;

(*
 * 2 bits per pixel.
 *)
  DDBD_2                  = $00002000;

(*
 * 4 bits per pixel.
 *)
  DDBD_4                  = $00001000;

(*
 * 8 bits per pixel.
 *)
  DDBD_8                  = $00000800;

(*
 * 16 bits per pixel.
 *)
  DDBD_16                 = $00000400;

(*
 * 24 bits per pixel.
 *)
  DDBD_24                 = $00000200;

(*
 * 32 bits per pixel.
 *)
  DDBD_32                 = $00000100;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE SET/GET COLOR KEY FLAGS
 *
 ****************************************************************************)

(*
 * Set if the structure contains a color space.  Not set if the structure
 * contains a single color key.
 *)
  DDCKEY_COLORSPACE       = $00000001;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a destination color key for blt operations.
 *)
  DDCKEY_DESTBLT          = $00000002;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a destination color key for overlay operations.
 *)
  DDCKEY_DESTOVERLAY      = $00000004;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a source color key for blt operations.
 *)
  DDCKEY_SRCBLT           = $00000008;

(*
 * Set if the structure specifies a color key or color space which is to be
 * used as a source color key for overlay operations.
 *)
  DDCKEY_SRCOVERLAY       = $00000010;


(****************************************************************************
 *
 * DIRECTDRAW COLOR KEY CAPABILITY FLAGS
 *
 ****************************************************************************)

(*
 * Supports transparent blting using a color key to identify the replaceable 
 * bits of the destination surface for RGB colors.
 *)
  DDCKEYCAPS_DESTBLT                      = $00000001;

(*
 * Supports transparent blting using a color space to identify the replaceable
 * bits of the destination surface for RGB colors.
 *)
  DDCKEYCAPS_DESTBLTCLRSPACE              = $00000002;

(*
 * Supports transparent blting using a color space to identify the replaceable
 * bits of the destination surface for YUV colors.
 *)
  DDCKEYCAPS_DESTBLTCLRSPACEYUV           = $00000004;

(*
 * Supports transparent blting using a color key to identify the replaceable
 * bits of the destination surface for YUV colors.
 *)
  DDCKEYCAPS_DESTBLTYUV                   = $00000008;

(*
 * Supports overlaying using colorkeying of the replaceable bits of the surface
 * being overlayed for RGB colors.
 *)
  DDCKEYCAPS_DESTOVERLAY                  = $00000010;

(*
 * Supports a color space as the color key for the destination for RGB colors.
 *)
  DDCKEYCAPS_DESTOVERLAYCLRSPACE          = $00000020;

(*
 * Supports a color space as the color key for the destination for YUV colors.
 *)
  DDCKEYCAPS_DESTOVERLAYCLRSPACEYUV       = $00000040;

(*
 * Supports only one active destination color key value for visible overlay
 * surfaces.
 *)
  DDCKEYCAPS_DESTOVERLAYONEACTIVE         = $00000080;

(*
 * Supports overlaying using colorkeying of the replaceable bits of the
 * surface being overlayed for YUV colors.
 *)
  DDCKEYCAPS_DESTOVERLAYYUV               = $00000100;

(*
 * Supports transparent blting using the color key for the source with
 * this surface for RGB colors.
 *)
  DDCKEYCAPS_SRCBLT                       = $00000200;

(*
 * Supports transparent blting using a color space for the source with
 * this surface for RGB colors.
 *)
  DDCKEYCAPS_SRCBLTCLRSPACE               = $00000400;

(*
 * Supports transparent blting using a color space for the source with
 * this surface for YUV colors.
 *)
  DDCKEYCAPS_SRCBLTCLRSPACEYUV            = $00000800;

(*
 * Supports transparent blting using the color key for the source with
 * this surface for YUV colors.
 *)
  DDCKEYCAPS_SRCBLTYUV                    = $00001000;

(*
 * Supports overlays using the color key for the source with this
 * overlay surface for RGB colors.
 *)
  DDCKEYCAPS_SRCOVERLAY                   = $00002000;

(*
 * Supports overlays using a color space as the source color key for
 * the overlay surface for RGB colors.
 *)
  DDCKEYCAPS_SRCOVERLAYCLRSPACE           = $00004000;

(*
 * Supports overlays using a color space as the source color key for
 * the overlay surface for YUV colors.
 *)
  DDCKEYCAPS_SRCOVERLAYCLRSPACEYUV        = $00008000;

(*
 * Supports only one active source color key value for visible
 * overlay surfaces.
 *)
  DDCKEYCAPS_SRCOVERLAYONEACTIVE          = $00010000;

(*
 * Supports overlays using the color key for the source with this
 * overlay surface for YUV colors.
 *)
  DDCKEYCAPS_SRCOVERLAYYUV                = $00020000;

(*
 * there are no bandwidth trade-offs for using colorkey with an overlay
 *)
  DDCKEYCAPS_NOCOSTOVERLAY                = $00040000;


(****************************************************************************
 *
 * DIRECTDRAW PIXELFORMAT FLAGS
 *
 ****************************************************************************)

(*
 * The surface has alpha channel information in the pixel format.
 *)
  DDPF_ALPHAPIXELS                        = $00000001;

(*
 * The pixel format contains alpha only information
 *)
  DDPF_ALPHA                              = $00000002;

(*
 * The FourCC code is valid.
 *)
  DDPF_FOURCC                             = $00000004;

(*
 * The surface is 4-bit color indexed.
 *)
  DDPF_PALETTEINDEXED4                    = $00000008;

(*
 * The surface is indexed into a palette which stores indices
 * into the destination surface's 8-bit palette.
 *)
  DDPF_PALETTEINDEXEDTO8                  = $00000010;

(*
 * The surface is 8-bit color indexed.
 *)
  DDPF_PALETTEINDEXED8                    = $00000020;

(*
 * The RGB data in the pixel format structure is valid.
 *)
  DDPF_RGB                                = $00000040;

(*
 * The surface will accept pixel data in the format specified
 * and compress it during the write.
 *)
  DDPF_COMPRESSED                         = $00000080;

(*
 * The surface will accept RGB data and translate it during
 * the write to YUV data.  The format of the data to be written
 * will be contained in the pixel format structure.  The DDPF_RGB
 * flag will be set.
 *)
  DDPF_RGBTOYUV                           = $00000100;

(*
 * pixel format is YUV - YUV data in pixel format struct is valid
 *)
  DDPF_YUV                                = $00000200;

(*
 * pixel format is a z buffer only surface
 *)
  DDPF_ZBUFFER                            = $00000400;

(*
 * The surface is 1-bit color indexed.
 *)
  DDPF_PALETTEINDEXED1                    = $00000800;

(*
 * The surface is 2-bit color indexed.
 *)
  DDPF_PALETTEINDEXED2                    = $00001000;

(*
 * The surface contains Z information in the pixels
 *)
  DDPF_ZPIXELS				= $00002000;

(*
 * The surface contains stencil information along with Z
 *)
  DDPF_STENCILBUFFER			= $00004000;

(*
 * Premultiplied alpha format -- the color components have been
 * premultiplied by the alpha component.
 *)
  DDPF_ALPHAPREMULT 			= $00008000;


(*
 * Luminance data in the pixel format is valid.
 * Use this flag for luminance-only or luminance+alpha surfaces,
 * the bit depth is then ddpf.dwLuminanceBitCount.
 *)
  DDPF_LUMINANCE                          = $00020000;

(*
 * Luminance data in the pixel format is valid.
 * Use this flag when hanging luminance off bumpmap surfaces,
 * the bit mask for the luminance portion of the pixel is then
 * ddpf.dwBumpLuminanceBitMask
 *)
  DDPF_BUMPLUMINANCE                      = $00040000;

(*
 * Bump map dUdV data in the pixel format is valid.
 *)
  DDPF_BUMPDUDV                           = $00080000;

(*===========================================================================
 *
 *
 * DIRECTDRAW CALLBACK FLAGS
 *
 *
 *==========================================================================*)

(****************************************************************************
 *
 * DIRECTDRAW ENUMSURFACES FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate all of the surfaces that meet the search criterion.
 *)
  DDENUMSURFACES_ALL                      = $00000001;

(*
 * A search hit is a surface that matches the surface description.
 *)
  DDENUMSURFACES_MATCH                    = $00000002;

(*
 * A search hit is a surface that does not match the surface description.
 *)
  DDENUMSURFACES_NOMATCH                  = $00000004;

(*
 * Enumerate the first surface that can be created which meets the search criterion.
 *)
  DDENUMSURFACES_CANBECREATED             = $00000008;

(*
 * Enumerate the surfaces that already exist that meet the search criterion.
 *)
  DDENUMSURFACES_DOESEXIST                = $00000010;

(****************************************************************************
 *
 * DIRECTDRAW SETDISPLAYMODE FLAGS
 *
 ****************************************************************************)

(*
 * The desired mode is a standard VGA mode
 *)
  DDSDM_STANDARDVGAMODE                   = $00000001;

(****************************************************************************
 *
 * DIRECTDRAW ENUMDISPLAYMODES FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate Modes with different refresh rates.  EnumDisplayModes guarantees
 * that a particular mode will be enumerated only once.  This flag specifies whether
 * the refresh rate is taken into account when determining if a mode is unique.
 *)
  DDEDM_REFRESHRATES                      = $00000001;

(*
 * Enumerate VGA modes. Specify this flag if you wish to enumerate supported VGA
 * modes such as mode 0x13 in addition to the usual ModeX modes (which are always
 * enumerated if the application has previously called SetCooperativeLevel with the
 * DDSCL_ALLOWMODEX flag set).
 *)
  DDEDM_STANDARDVGAMODES                  = $00000002;


(****************************************************************************
 *
 * DIRECTDRAW SETCOOPERATIVELEVEL FLAGS
 *
 ****************************************************************************)

(*
 * Exclusive mode owner will be responsible for the entire primary surface.
 * GDI can be ignored. used with DD
 *)
  DDSCL_FULLSCREEN                        = $00000001;

(*
 * allow CTRL_ALT_DEL to work while in fullscreen exclusive mode
 *)
  DDSCL_ALLOWREBOOT                       = $00000002;

(*
 * prevents DDRAW from modifying the application window.
 * prevents DDRAW from minimize/restore the application window on activation.
 *)
  DDSCL_NOWINDOWCHANGES                   = $00000004;

(*
 * app wants to work as a regular Windows application
 *)
  DDSCL_NORMAL                            = $00000008;

(*
 * app wants exclusive access
 *)
  DDSCL_EXCLUSIVE                         = $00000010;


(*
 * app can deal with non-windows display modes
 *)
  DDSCL_ALLOWMODEX                        = $00000040;

(*
 * this window will receive the focus messages
 *)
  DDSCL_SETFOCUSWINDOW                    = $00000080;

(*
 * this window is associated with the DDRAW object and will
 * cover the screen in fullscreen mode
 *)
  DDSCL_SETDEVICEWINDOW                   = $00000100;

(*
 * app wants DDRAW to create a window to be associated with the
 * DDRAW object
 *)
  DDSCL_CREATEDEVICEWINDOW                = $00000200;

(*
 * App explicitly asks DDRAW/D3D to be multithread safe. This makes D3D
 * take the global crtisec more frequently.
 *)
  DDSCL_MULTITHREADED                     = $00000400;

(*
 * App hints that it would like to keep the FPU set up for optimal Direct3D
 * performance (single precision and exceptions disabled) so Direct3D
 * does not need to explicitly set the FPU each time
 *)
  DDSCL_FPUSETUP                          = $00000800;

(****************************************************************************
 *
 * DIRECTDRAW BLT FLAGS
 *
 ****************************************************************************)

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the destination surface as the alpha channel for this blt.
 *)
  DDBLT_ALPHADEST                         = $00000001;

(*
 * Use the dwConstAlphaDest field in the TDDBltFX structure as the alpha channel
 * for the destination surface for this blt.
 *)
  DDBLT_ALPHADESTCONSTOVERRIDE            = $00000002;

(*
 * The NEG suffix indicates that the destination surface becomes more
 * transparent as the alpha value increases. (0 is opaque)
 *)
  DDBLT_ALPHADESTNEG                      = $00000004;

(*
 * Use the lpDDSAlphaDest field in the TDDBltFX structure as the alpha
 * channel for the destination for this blt.
 *)
  DDBLT_ALPHADESTSURFACEOVERRIDE          = $00000008;

(*
 * Use the dwAlphaEdgeBlend field in the TDDBltFX structure as the alpha channel
 * for the edges of the image that border the color key colors.
 *)
  DDBLT_ALPHAEDGEBLEND                    = $00000010;

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the source surface as the alpha channel for this blt.
 *)
  DDBLT_ALPHASRC                          = $00000020;

(*
 * Use the dwConstAlphaSrc field in the TDDBltFX structure as the alpha channel
 * for the source for this blt.
 *)
  DDBLT_ALPHASRCCONSTOVERRIDE             = $00000040;

(*
 * The NEG suffix indicates that the source surface becomes more transparent
 * as the alpha value increases. (0 is opaque)
 *)
  DDBLT_ALPHASRCNEG                       = $00000080;

(*
 * Use the lpDDSAlphaSrc field in the TDDBltFX structure as the alpha channel
 * for the source for this blt. 
 *)
  DDBLT_ALPHASRCSURFACEOVERRIDE           = $00000100;

(*
 * Do this blt asynchronously through the FIFO in the order received.  If
 * there is no room in the hardware FIFO fail the call.
 *)
  DDBLT_ASYNC                             = $00000200;

(*
 * Uses the dwFillColor field in the TDDBltFX structure as the RGB color
 * to fill the destination rectangle on the destination surface with.
 *)
  DDBLT_COLORFILL                         = $00000400;

(*
 * Uses the dwDDFX field in the TDDBltFX structure to specify the effects
 * to use for the blt.
 *)
  DDBLT_DDFX                              = $00000800;

(*
 * Uses the dwDDROPS field in the TDDBltFX structure to specify the ROPS
 * that are not part of the Win32 API.
 *)
  DDBLT_DDROPS                            = $00001000;

(*
 * Use the color key associated with the destination surface.
 *)
  DDBLT_KEYDEST                           = $00002000;

(*
 * Use the dckDestColorkey field in the TDDBltFX structure as the color key
 * for the destination surface.
 *)
  DDBLT_KEYDESTOVERRIDE                   = $00004000;

(*
 * Use the color key associated with the source surface.
 *)
  DDBLT_KEYSRC                            = $00008000;

(*
 * Use the dckSrcColorkey field in the TDDBltFX structure as the color key
 * for the source surface.
 *)
  DDBLT_KEYSRCOVERRIDE                    = $00010000;

(*
 * Use the dwROP field in the TDDBltFX structure for the raster operation
 * for this blt.  These ROPs are the same as the ones defined in the Win32 API.
 *)
  DDBLT_ROP                               = $00020000;

(*
 * Use the dwRotationAngle field in the TDDBltFX structure as the angle
 * (specified in 1/100th of a degree) to rotate the surface.
 *)
  DDBLT_ROTATIONANGLE                     = $00040000;

(*
 * Z-buffered blt using the z-buffers attached to the source and destination
 * surfaces and the dwZBufferOpCode field in the TDDBltFX structure as the
 * z-buffer opcode.
 *)
  DDBLT_ZBUFFER                           = $00080000;

(*
 * Z-buffered blt using the dwConstDest Zfield and the dwZBufferOpCode field
 * in the TDDBltFX structure as the z-buffer and z-buffer opcode respectively
 * for the destination.
 *)
  DDBLT_ZBUFFERDESTCONSTOVERRIDE          = $00100000;

(*
 * Z-buffered blt using the lpDDSDestZBuffer field and the dwZBufferOpCode
 * field in the TDDBltFX structure as the z-buffer and z-buffer opcode
 * respectively for the destination.
 *)
  DDBLT_ZBUFFERDESTOVERRIDE               = $00200000;

(*
 * Z-buffered blt using the dwConstSrcZ field and the dwZBufferOpCode field
 * in the TDDBltFX structure as the z-buffer and z-buffer opcode respectively
 * for the source.
 *)
  DDBLT_ZBUFFERSRCCONSTOVERRIDE           = $00400000;

(*
 * Z-buffered blt using the lpDDSSrcZBuffer field and the dwZBufferOpCode
 * field in the TDDBltFX structure as the z-buffer and z-buffer opcode
 * respectively for the source.
 *)
   DDBLT_ZBUFFERSRCOVERRIDE                = $00800000;

(*
 * wait until the device is ready to handle the blt
 * this will cause blt to not return DDERR_WASSTILLDRAWING
 *)
  DDBLT_WAIT                              = $01000000;

(*
 * Uses the dwFillDepth field in the TDDBltFX structure as the depth value
 * to fill the destination rectangle on the destination Z-buffer surface
 * with.
 *)
  DDBLT_DEPTHFILL                         = $02000000;


(****************************************************************************
 *
 * BLTFAST FLAGS
 *
 ****************************************************************************)

  DDBLTFAST_NOCOLORKEY                    = $00000000;
  DDBLTFAST_SRCCOLORKEY                   = $00000001;
  DDBLTFAST_DESTCOLORKEY                  = $00000002;
  DDBLTFAST_WAIT                          = $00000010;

(****************************************************************************
 *
 * FLIP FLAGS
 *
 ****************************************************************************)


  DDFLIP_WAIT                          = $00000001;

(*
 * Indicates that the target surface contains the even field of video data.
 * This flag is only valid with an overlay surface.
 *)
  DDFLIP_EVEN                          = $00000002;

(*
 * Indicates that the target surface contains the odd field of video data.
 * This flag is only valid with an overlay surface.
 *)
  DDFLIP_ODD                           = $00000004;

(*
 * Causes DirectDraw to perform the physical flip immediately and return
 * to the application. Typically, what was the front buffer but is now the back
 * buffer will still be visible (depending on timing) until the next vertical
 * retrace. Subsequent operations involving the two flipped surfaces will
 * not check to see if the physical flip has finished (i.e. will not return
 * DDERR_WASSTILLDRAWING for that reason (but may for other reasons)).
 * This allows an application to perform Flips at a higher frequency than the
 * monitor refresh rate, but may introduce visible artifacts.
 * Only effective if DDCAPS2_FLIPNOVSYNC is set. If that bit is not set,
 * DDFLIP_NOVSYNC has no effect.
 *)
  DDFLIP_NOVSYNC                       = $00000008;


(*
 * Flip Interval Flags. These flags indicate how many vertical retraces to wait between
 * each flip. The default is one. DirectDraw will return DDERR_WASSTILLDRAWING for each
 * surface involved in the flip until the specified number of vertical retraces has
 * ocurred. Only effective if DDCAPS2_FLIPINTERVAL is set. If that bit is not set,
 * DDFLIP_INTERVALn has no effect.
 *)

(*
 * DirectDraw will flip on every other vertical sync
 *)
  DDFLIP_INTERVAL2                     = $02000000;


(*
 * DirectDraw will flip on every third vertical sync
 *)
  DDFLIP_INTERVAL3                     = $03000000;


(*
 * DirectDraw will flip on every fourth vertical sync
 *)
  DDFLIP_INTERVAL4                     = $04000000;

(****************************************************************************
 *
 * DIRECTDRAW SURFACE OVERLAY FLAGS
 *
 ****************************************************************************)

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the destination surface as the alpha channel for the
 * destination overlay.
 *)
  DDOVER_ALPHADEST                        = $00000001;

(*
 * Use the dwConstAlphaDest field in the TDDOverlayFX structure as the
 * destination alpha channel for this overlay.
 *)
  DDOVER_ALPHADESTCONSTOVERRIDE           = $00000002;

(*
 * The NEG suffix indicates that the destination surface becomes more
 * transparent as the alpha value increases.
 *)
  DDOVER_ALPHADESTNEG                     = $00000004;

(*
 * Use the lpDDSAlphaDest field in the TDDOverlayFX structure as the alpha
 * channel destination for this overlay.
 *)
  DDOVER_ALPHADESTSURFACEOVERRIDE         = $00000008;

(*
 * Use the dwAlphaEdgeBlend field in the TDDOverlayFX structure as the alpha
 * channel for the edges of the image that border the color key colors.
 *)
  DDOVER_ALPHAEDGEBLEND                   = $00000010;

(*
 * Use the alpha information in the pixel format or the alpha channel surface
 * attached to the source surface as the source alpha channel for this overlay.
 *)
  DDOVER_ALPHASRC                         = $00000020;

(*
 * Use the dwConstAlphaSrc field in the TDDOverlayFX structure as the source
 * alpha channel for this overlay.
 *)
  DDOVER_ALPHASRCCONSTOVERRIDE            = $00000040;

(*
 * The NEG suffix indicates that the source surface becomes more transparent
 * as the alpha value increases.
 *)
  DDOVER_ALPHASRCNEG                      = $00000080;

(*
 * Use the lpDDSAlphaSrc field in the TDDOverlayFX structure as the alpha channel
 * source for this overlay.
 *)
  DDOVER_ALPHASRCSURFACEOVERRIDE          = $00000100;

(*
 * Turn this overlay off.
 *)
  DDOVER_HIDE                             = $00000200;

(*
 * Use the color key associated with the destination surface.
 *)
  DDOVER_KEYDEST                          = $00000400;

(*
 * Use the dckDestColorkey field in the TDDOverlayFX structure as the color key
 * for the destination surface
 *)
  DDOVER_KEYDESTOVERRIDE                  = $00000800;

(*
 * Use the color key associated with the source surface.
 *)
  DDOVER_KEYSRC                           = $00001000;

(*
 * Use the dckSrcColorkey field in the TDDOverlayFX structure as the color key
 * for the source surface.
 *)
  DDOVER_KEYSRCOVERRIDE                   = $00002000;

(*
 * Turn this overlay on.
 *)
  DDOVER_SHOW                             = $00004000;

(*
 * Add a dirty rect to an emulated overlayed surface.
 *)
  DDOVER_ADDDIRTYRECT                     = $00008000;

(*
 * Redraw all dirty rects on an emulated overlayed surface.
 *)
  DDOVER_REFRESHDIRTYRECTS                = $00010000;

(*
 * Redraw the entire surface on an emulated overlayed surface.
 *)
  DDOVER_REFRESHALL                      = $00020000;

(*
 * Use the overlay FX flags to define special overlay FX
 *)
  DDOVER_DDFX                             = $00080000;

(*
 * Autoflip the overlay when ever the video port autoflips
 *)
  DDOVER_AUTOFLIP                      	  = $00100000;

(*
 * Display each field of video port data individually without
 * causing any jittery artifacts
 *)
  DDOVER_BOB                       	  = $00200000;

(*
 * Indicates that bob/weave decisions should not be overridden by other
 * Interfaces.
 *)
  DDOVER_OVERRIDEBOBWEAVE		  = $00400000;

(*
 * Indicates that the surface memory is composed of interleaved fields.
 *)
  DDOVER_INTERLEAVED			  = $00800000;

(*
 * Indicates that bob will be performed using hardware rather than
 * software or emulated.
 *)
  DDOVER_BOBHARDWARE		       	= $01000000;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE LOCK FLAGS
 *
 ****************************************************************************)

(*
 * The default.  Set to indicate that Lock should return a valid memory pointer
 * to the top of the specified rectangle.  If no rectangle is specified then a
 * pointer to the top of the surface is returned.
 *)
  DDLOCK_SURFACEMEMORYPTR                 = $00000000;    // = default

(*
 * Set to indicate that Lock should wait until it can obtain a valid memory
 * pointer before returning.  If this bit is set, Lock will never return
 * DDERR_WASSTILLDRAWING.
 *)
  DDLOCK_WAIT                             = $00000001;

(*
 * Set if an event handle is being passed to Lock.  Lock will trigger the event
 * when it can return the surface memory pointer requested.
 *)
  DDLOCK_EVENT                            = $00000002;

(*
 * Indicates that the surface being locked will only be read from.
 *)
  DDLOCK_READONLY                         = $00000010;

(*
 * Indicates that the surface being locked will only be written to
 *)
  DDLOCK_WRITEONLY                        = $00000020;

(*
 * Indicates that a system wide lock should not be taken when this surface
 * is locked. This has several advantages (cursor responsiveness, ability
 * to call more Windows functions, easier debugging) when locking video
 * memory surfaces. However, an application specifying this flag must
 * comply with a number of conditions documented in the help file.
 * Furthermore, this flag cannot be specified when locking the primary.
 *)
  DDLOCK_NOSYSLOCK                        = $00000800;


(****************************************************************************
 *
 * DIRECTDRAWSURFACE PAGELOCK FLAGS
 *
 ****************************************************************************)

(*
 * No flags defined at present
 *)


(****************************************************************************
 *
 * DIRECTDRAWSURFACE PAGEUNLOCK FLAGS
 *
 ****************************************************************************)

(*
 * No flags defined at present
 *)


(****************************************************************************
 *
 * DIRECTDRAWSURFACE BLT FX FLAGS
 *
 ****************************************************************************)

(*
 * If stretching, use arithmetic stretching along the Y axis for this blt.
 *)
  DDBLTFX_ARITHSTRETCHY                   = $00000001;

(*
 * Do this blt mirroring the surface left to right.  Spin the
 * surface around its y-axis.
 *)
  DDBLTFX_MIRRORLEFTRIGHT                 = $00000002;

(*
 * Do this blt mirroring the surface up and down.  Spin the surface
 * around its x-axis.
 *)
  DDBLTFX_MIRRORUPDOWN                    = $00000004;

(*
 * Schedule this blt to avoid tearing.
 *)
  DDBLTFX_NOTEARING                       = $00000008;

(*
 * Do this blt rotating the surface one hundred and eighty degrees.
 *)
  DDBLTFX_ROTATE180                       = $00000010;

(*
 * Do this blt rotating the surface two hundred and seventy degrees.
 *)
  DDBLTFX_ROTATE270                       = $00000020;

(*
 * Do this blt rotating the surface ninety degrees.
 *)
  DDBLTFX_ROTATE90                        = $00000040;

(*
 * Do this z blt using dwZBufferLow and dwZBufferHigh as  range values
 * specified to limit the bits copied from the source surface.
 *)
  DDBLTFX_ZBUFFERRANGE                    = $00000080;

(*
 * Do this z blt adding the dwZBufferBaseDest to each of the sources z values
 * before comparing it with the desting z values.
 *)
  DDBLTFX_ZBUFFERBASEDEST                 = $00000100;

(****************************************************************************
 *
 * DIRECTDRAWSURFACE OVERLAY FX FLAGS
 *
 ****************************************************************************)

(*
 * If stretching, use arithmetic stretching along the Y axis for this overlay.
 *)
  DDOVERFX_ARITHSTRETCHY                  = $00000001;

(*
 * Mirror the overlay across the vertical axis
 *)
  DDOVERFX_MIRRORLEFTRIGHT                = $00000002;

(*
 * Mirror the overlay across the horizontal axis
 *)
  DDOVERFX_MIRRORUPDOWN                   = $00000004;

(****************************************************************************
 *
 * Flags for dwDDFX member of DDSPRITEFX structure
 *
 ****************************************************************************)
(*
 * Use affine transformation matrix in fTransform member.
 *)
  DDSPRITEFX_AFFINETRANSFORM		= $00000001;

(*
 * Use RGBA scaling factors in ddrgbaScaleFactors member.
 *)
  DDSPRITEFX_RGBASCALING			= $00000002;

(*
 * Degrade RGBA scaling factors to accommodate driver's capabilities.
 *)
  DDSPRITEFX_DEGRADERGBASCALING		= $00000004;

(*
 * Do bilinear filtering of stretched or warped sprite.
 *)
  DDSPRITEFX_BILINEARFILTER     	  	= $00000008;

(*
 * Do "blur" filtering of stretched or warped sprite.
 *)
  DDSPRITEFX_BLURFILTER 	      	 	= $00000010;

(*
 * Do "flat" filtering of stretched or warped sprite.
 *)
  DDSPRITEFX_FLATFILTER 	      		= $00000020;

(*
 * Degrade filtering operation to accommodate driver's capabilities.
 *)
  DDSPRITEFX_DEGRADEFILTER 	      	= $00000040;

(****************************************************************************
 *
 * DIRECTDRAW WAITFORVERTICALBLANK FLAGS
 *
 ****************************************************************************)

(*
 * return when the vertical blank interval begins
 *)
  DDWAITVB_BLOCKBEGIN                     = $00000001;

(*
 * set up an event to trigger when the vertical blank begins
 *)
  DDWAITVB_BLOCKBEGINEVENT                = $00000002;

(*
 * return when the vertical blank interval ends and display begins
 *)
  DDWAITVB_BLOCKEND                       = $00000004;

(****************************************************************************
 *
 * DIRECTDRAW GETFLIPSTATUS FLAGS
 *
 ****************************************************************************)

(*
 * is it OK to flip now?
 *)
  DDGFS_CANFLIP                   = $00000001;

(*
 * is the last flip finished?
 *)
  DDGFS_ISFLIPDONE                = $00000002;

(****************************************************************************
 *
 * DIRECTDRAW GETBLTSTATUS FLAGS
 *
 ****************************************************************************)

(*
 * is it OK to blt now?
 *)
  DDGBS_CANBLT                    = $00000001;

(*
 * is the blt to the surface finished?
 *)
  DDGBS_ISBLTDONE                 = $00000002;


(****************************************************************************
 *
 * DIRECTDRAW ENUMOVERLAYZORDER FLAGS
 *
 ****************************************************************************)

(*
 * Enumerate overlays back to front.
 *)
  DDENUMOVERLAYZ_BACKTOFRONT      = $00000000;

(*
 * Enumerate overlays front to back
 *)
  DDENUMOVERLAYZ_FRONTTOBACK      = $00000001;

(****************************************************************************
 *
 * DIRECTDRAW UPDATEOVERLAYZORDER FLAGS
 *
 ****************************************************************************)

(*
 * Send overlay to front
 *)
  DDOVERZ_SENDTOFRONT             = $00000000;

(*
 * Send overlay to back
 *)
  DDOVERZ_SENDTOBACK              = $00000001;

(*
 * Move Overlay forward
 *)
  DDOVERZ_MOVEFORWARD             = $00000002;

(*
 * Move Overlay backward
 *)
  DDOVERZ_MOVEBACKWARD            = $00000003;

(*
 * Move Overlay in front of relative surface
 *)
  DDOVERZ_INSERTINFRONTOF         = $00000004;

(*
 * Move Overlay in back of relative surface
 *)
  DDOVERZ_INSERTINBACKOF          = $00000005;

(****************************************************************************
 *
 * DIRECTDRAW SETGAMMARAMP FLAGS
 *
 ****************************************************************************)

(*
 * Request calibrator to adjust the gamma ramp according to the physical
 * properties of the display so that the result should appear identical
 * on all systems.
 *)
  DDSGR_CALIBRATE                        = $00000001;

(*===========================================================================
 *
 *
 * DIRECTDRAW RETURN CODES
 *
 * The return values from DirectDraw Commands and Surface that return an HResult
 * are codes from DirectDraw concerning the results of the action
 * requested by DirectDraw.
 *
 *==========================================================================*)

(*
 * Status is OK
 *
 * Issued by: DirectDraw Commands and all callbacks
 *)
  DD_OK                                   = 0;
  DD_FALSE                                = S_FALSE;

(****************************************************************************
 *
 * DIRECTDRAW ENUMCALLBACK RETURN VALUES
 *
 * EnumCallback returns are used to control the flow of the DIRECTDRAW and
 * DIRECTDRAWSURFACE object enumerations.   They can only be returned by
 * enumeration callback routines.
 *
 ****************************************************************************)

(*
 * stop the enumeration
 *)
  DDENUMRET_CANCEL                        = 0;

(*
 * continue the enumeration
 *)
  DDENUMRET_OK                            = 1;

(****************************************************************************
 *
 * DIRECTDRAW ERRORS
 *
 * Errors are represented by negative values and cannot be combined.
 *
 ****************************************************************************)

  MAKE_DDHRESULT = $88760000;
  
(*
 * This object is already initialized
 *)
  DDERR_ALREADYINITIALIZED                = MAKE_DDHRESULT + 5;

(*
 * This surface can not be attached to the requested surface.
 *)
  DDERR_CANNOTATTACHSURFACE               = MAKE_DDHRESULT + 10;

(*
 * This surface can not be detached from the requested surface.
 *)
  DDERR_CANNOTDETACHSURFACE               = MAKE_DDHRESULT + 20;

(*
 * Support is currently not available.
 *)
  DDERR_CURRENTLYNOTAVAIL                 = MAKE_DDHRESULT + 40;

(*
 * An exception was encountered while performing the requested operation
 *)
  DDERR_EXCEPTION                         = MAKE_DDHRESULT + 55;

(*
 * Generic failure.
 *)
  DDERR_GENERIC                           = E_FAIL;

(*
 * Height of rectangle provided is not a multiple of reqd alignment
 *)
  DDERR_HEIGHTALIGN                       = MAKE_DDHRESULT + 90;

(*
 * Unable to match primary surface creation request with existing
 * primary surface.
 *)
  DDERR_INCOMPATIBLEPRIMARY               = MAKE_DDHRESULT + 95;

(*
 * One or more of the caps bits passed to the callback are incorrect.
 *)
  DDERR_INVALIDCAPS                       = MAKE_DDHRESULT + 100;

(*
 * DirectDraw does not support provided Cliplist.
 *)
  DDERR_INVALIDCLIPLIST                   = MAKE_DDHRESULT + 110;

(*
 * DirectDraw does not support the requested mode
 *)
  DDERR_INVALIDMODE                       = MAKE_DDHRESULT + 120;

(*
 * DirectDraw received a pointer that was an invalid DIRECTDRAW object.
 *)
  DDERR_INVALIDOBJECT                     = MAKE_DDHRESULT + 130;

(*
 * One or more of the parameters passed to the callback function are
 * incorrect.
 *)
  DDERR_INVALIDPARAMS                     = E_INVALIDARG;

(*
 * pixel format was invalid as specified
 *)
  DDERR_INVALIDPIXELFORMAT                = MAKE_DDHRESULT + 145;

(*
 * Rectangle provided was invalid.
 *)
  DDERR_INVALIDRECT                       = MAKE_DDHRESULT + 150;

(*
 * Operation could not be carried out because one or more surfaces are locked
 *)
  DDERR_LOCKEDSURFACES                    = MAKE_DDHRESULT + 160;

(*
 * There is no 3D present.
 *)
  DDERR_NO3D                              = MAKE_DDHRESULT + 170;

(*
 * Operation could not be carried out because there is no alpha accleration
 * hardware present or available.
 *)
  DDERR_NOALPHAHW                         = MAKE_DDHRESULT + 180;


(*
 * no clip list available
 *)
  DDERR_NOCLIPLIST                        = MAKE_DDHRESULT + 205;

(*
 * Operation could not be carried out because there is no color conversion
 * hardware present or available.
 *)
  DDERR_NOCOLORCONVHW                     = MAKE_DDHRESULT + 210;

(*
 * Create function called without DirectDraw object method SetCooperativeLevel
 * being called.
 *)
  DDERR_NOCOOPERATIVELEVELSET             = MAKE_DDHRESULT + 212;

(*
 * Surface doesn't currently have a color key
 *)
  DDERR_NOCOLORKEY                        = MAKE_DDHRESULT + 215;

(*
 * Operation could not be carried out because there is no hardware support
 * of the dest color key.
 *)
  DDERR_NOCOLORKEYHW                      = MAKE_DDHRESULT + 220;

(*
 * No DirectDraw support possible with current display driver
 *)
  DDERR_NODIRECTDRAWSUPPORT               = MAKE_DDHRESULT + 222;

(*
 * Operation requires the application to have exclusive mode but the
 * application does not have exclusive mode.
 *)
  DDERR_NOEXCLUSIVEMODE                   = MAKE_DDHRESULT + 225;

(*
 * Flipping visible surfaces is not supported.
 *)
  DDERR_NOFLIPHW                          = MAKE_DDHRESULT + 230;

(*
 * There is no GDI present.
 *)
  DDERR_NOGDI                             = MAKE_DDHRESULT + 240;

(*
 * Operation could not be carried out because there is no hardware present
 * or available.
 *)
  DDERR_NOMIRRORHW                        = MAKE_DDHRESULT + 250;

(*
 * Requested item was not found
 *)
  DDERR_NOTFOUND                          = MAKE_DDHRESULT + 255;

(*
 * Operation could not be carried out because there is no overlay hardware
 * present or available.
 *)
  DDERR_NOOVERLAYHW                       = MAKE_DDHRESULT + 260;

(*
 * Operation could not be carried out because the source and destination
 * rectangles are on the same surface and overlap each other.
 *)
  DDERR_OVERLAPPINGRECTS       		= MAKE_DDHRESULT + 270;

(*
 * Operation could not be carried out because there is no appropriate raster
 * op hardware present or available.
 *)
  DDERR_NORASTEROPHW                      = MAKE_DDHRESULT + 280;

(*
 * Operation could not be carried out because there is no rotation hardware
 * present or available.
 *)
  DDERR_NOROTATIONHW                      = MAKE_DDHRESULT + 290;

(*
 * Operation could not be carried out because there is no hardware support
 * for stretching
 *)
  DDERR_NOSTRETCHHW                       = MAKE_DDHRESULT + 310;

(*
 * DirectDrawSurface is not in 4 bit color palette and the requested operation
 * requires 4 bit color palette.
 *)
  DDERR_NOT4BITCOLOR                      = MAKE_DDHRESULT + 316;

(*
 * DirectDrawSurface is not in 4 bit color index palette and the requested
 * operation requires 4 bit color index palette.
 *)
  DDERR_NOT4BITCOLORINDEX                 = MAKE_DDHRESULT + 317;

(*
 * DirectDraw Surface is not in 8 bit color mode and the requested operation
 * requires 8 bit color.
 *)
  DDERR_NOT8BITCOLOR                      = MAKE_DDHRESULT + 320;

(*
 * Operation could not be carried out because there is no texture mapping
 * hardware present or available.
 *)
  DDERR_NOTEXTUREHW                       = MAKE_DDHRESULT + 330;

(*
 * Operation could not be carried out because there is no hardware support
 * for vertical blank synchronized operations.
 *)
  DDERR_NOVSYNCHW                         = MAKE_DDHRESULT + 335;

(*
 * Operation could not be carried out because there is no hardware support
 * for zbuffer blting.
 *)
  DDERR_NOZBUFFERHW                       = MAKE_DDHRESULT + 340;

(*
 * Overlay surfaces could not be z layered based on their BltOrder because
 * the hardware does not support z layering of overlays.
 *)
  DDERR_NOZOVERLAYHW                      = MAKE_DDHRESULT + 350;

(*
 * The hardware needed for the requested operation has already been
 * allocated.
 *)
  DDERR_OUTOFCAPS                         = MAKE_DDHRESULT + 360;

(*
 * DirectDraw does not have enough memory to perform the operation.
 *)
  DDERR_OUTOFMEMORY                       = E_OUTOFMEMORY;

(*
 * DirectDraw does not have enough memory to perform the operation.
 *)
  DDERR_OUTOFVIDEOMEMORY                  = MAKE_DDHRESULT + 380;

(*
 * hardware does not support clipped overlays
 *)
  DDERR_OVERLAYCANTCLIP                   = MAKE_DDHRESULT + 382;

(*
 * Can only have ony color key active at one time for overlays
 *)
  DDERR_OVERLAYCOLORKEYONLYONEACTIVE      = MAKE_DDHRESULT + 384;

(*
 * Access to this palette is being refused because the palette is already
 * locked by another thread.
 *)
  DDERR_PALETTEBUSY                       = MAKE_DDHRESULT + 387;

(*
 * No src color key specified for this operation.
 *)
  DDERR_COLORKEYNOTSET                    = MAKE_DDHRESULT + 400;

(*
 * This surface is already attached to the surface it is being attached to.
 *)
  DDERR_SURFACEALREADYATTACHED            = MAKE_DDHRESULT + 410;

(*
 * This surface is already a dependency of the surface it is being made a
 * dependency of.
 *)
  DDERR_SURFACEALREADYDEPENDENT           = MAKE_DDHRESULT + 420;

(*
 * Access to this surface is being refused because the surface is already
 * locked by another thread.
 *)
  DDERR_SURFACEBUSY                       = MAKE_DDHRESULT + 430;

(*
 * Access to this surface is being refused because no driver exists
 * which can supply a pointer to the surface.
 * This is most likely to happen when attempting to lock the primary
 * surface when no DCI provider is present.
 * Will also happen on attempts to lock an optimized surface.
 *)
  DDERR_CANTLOCKSURFACE                   = MAKE_DDHRESULT + 435;

(*
 * Access to Surface refused because Surface is obscured.
 *)
  DDERR_SURFACEISOBSCURED                 = MAKE_DDHRESULT + 440;

(*
 * Access to this surface is being refused because the surface is gone.
 * The DIRECTDRAWSURFACE object representing this surface should
 * have Restore called on it.
 *)
  DDERR_SURFACELOST                       = MAKE_DDHRESULT + 450;

(*
 * The requested surface is not attached.
 *)
  DDERR_SURFACENOTATTACHED                = MAKE_DDHRESULT + 460;

(*
 * Height requested by DirectDraw is too large.
 *)
  DDERR_TOOBIGHEIGHT                      = MAKE_DDHRESULT + 470;

(*
 * Size requested by DirectDraw is too large --  The individual height and
 * width are OK.
 *)
  DDERR_TOOBIGSIZE                        = MAKE_DDHRESULT + 480;

(*
 * Width requested by DirectDraw is too large.
 *)
  DDERR_TOOBIGWIDTH                       = MAKE_DDHRESULT + 490;

(*
 * Action not supported.
 *)
  DDERR_UNSUPPORTED                       = E_NOTIMPL;

(*
 * FOURCC format requested is unsupported by DirectDraw
 *)
  DDERR_UNSUPPORTEDFORMAT                 = MAKE_DDHRESULT + 510;

(*
 * Bitmask in the pixel format requested is unsupported by DirectDraw
 *)
  DDERR_UNSUPPORTEDMASK                   = MAKE_DDHRESULT + 520;

(*
 * The specified stream contains invalid data
 *)
  DDERR_INVALIDSTREAM                     = MAKE_DDHRESULT + 521;

(*
 * vertical blank is in progress
 *)
  DDERR_VERTICALBLANKINPROGRESS           = MAKE_DDHRESULT + 537;

(*
 * Informs DirectDraw that the previous Blt which is transfering information
 * to or from this Surface is incomplete.
 *)
  DDERR_WASSTILLDRAWING                   = MAKE_DDHRESULT + 540;

(*
 * Rectangle provided was not horizontally aligned on reqd. boundary
 *)
  DDERR_XALIGN                            = MAKE_DDHRESULT + 560;

(*
 * The GUID passed to DirectDrawCreate is not a valid DirectDraw driver
 * identifier.
 *)
  DDERR_INVALIDDIRECTDRAWGUID             = MAKE_DDHRESULT + 561;

(*
 * A DirectDraw object representing this driver has already been created
 * for this process.
 *)
  DDERR_DIRECTDRAWALREADYCREATED          = MAKE_DDHRESULT + 562;

(*
 * A hardware only DirectDraw object creation was attempted but the driver
 * did not support any hardware.
 *)
  DDERR_NODIRECTDRAWHW                    = MAKE_DDHRESULT + 563;

(*
 * this process already has created a primary surface
 *)
  DDERR_PRIMARYSURFACEALREADYEXISTS       = MAKE_DDHRESULT + 564;

(*
 * software emulation not available.
 *)
  DDERR_NOEMULATION                       = MAKE_DDHRESULT + 565;

(*
 * region passed to Clipper::GetClipList is too small.
 *)
  DDERR_REGIONTOOSMALL                    = MAKE_DDHRESULT + 566;

(*
 * an attempt was made to set a clip list for a clipper objec that
 * is already monitoring an hwnd.
 *)
  DDERR_CLIPPERISUSINGHWND                = MAKE_DDHRESULT + 567;

(*
 * No clipper object attached to surface object
 *)
  DDERR_NOCLIPPERATTACHED                 = MAKE_DDHRESULT + 568;

(*
 * Clipper notification requires an HWND or
 * no HWND has previously been set as the CooperativeLevel HWND.
 *)
  DDERR_NOHWND                            = MAKE_DDHRESULT + 569;

(*
 * HWND used by DirectDraw CooperativeLevel has been subclassed,
 * this prevents DirectDraw from restoring state.
 *)
  DDERR_HWNDSUBCLASSED                    = MAKE_DDHRESULT + 570;

(*
 * The CooperativeLevel HWND has already been set.
 * It can not be reset while the process has surfaces or palettes created.
 *)
  DDERR_HWNDALREADYSET                    = MAKE_DDHRESULT + 571;

(*
 * No palette object attached to this surface.
 *)
  DDERR_NOPALETTEATTACHED                 = MAKE_DDHRESULT + 572;

(*
 * No hardware support for 16 or 256 color palettes.
 *)
  DDERR_NOPALETTEHW                       = MAKE_DDHRESULT + 573;

(*
 * If a clipper object is attached to the source surface passed into a
 * BltFast call.
 *)
  DDERR_BLTFASTCANTCLIP                   = MAKE_DDHRESULT + 574;

(*
 * No blter.
 *)
  DDERR_NOBLTHW                           = MAKE_DDHRESULT + 575;

(*
 * No DirectDraw ROP hardware.
 *)
  DDERR_NODDROPSHW                        = MAKE_DDHRESULT + 576;

(*
 * returned when GetOverlayPosition is called on a hidden overlay
 *)
  DDERR_OVERLAYNOTVISIBLE                 = MAKE_DDHRESULT + 577;

(*
 * returned when GetOverlayPosition is called on a overlay that UpdateOverlay
 * has never been called on to establish a destionation.
 *)
  DDERR_NOOVERLAYDEST                     = MAKE_DDHRESULT + 578;

(*
 * returned when the position of the overlay on the destionation is no longer
 * legal for that destionation.
 *)
  DDERR_INVALIDPOSITION                   = MAKE_DDHRESULT + 579;

(*
 * returned when an overlay member is called for a non-overlay surface
 *)
  DDERR_NOTAOVERLAYSURFACE                = MAKE_DDHRESULT + 580;

(*
 * An attempt was made to set the cooperative level when it was already
 * set to exclusive.
 *)
  DDERR_EXCLUSIVEMODEALREADYSET           = MAKE_DDHRESULT + 581;

(*
 * An attempt has been made to flip a surface that is not flippable.
 *)
  DDERR_NOTFLIPPABLE                      = MAKE_DDHRESULT + 582;

(*
 * Can't duplicate primary & 3D surfaces, or surfaces that are implicitly
 * created.
 *)
  DDERR_CANTDUPLICATE                     = MAKE_DDHRESULT + 583;

(*
 * Surface was not locked.  An attempt to unlock a surface that was not
 * locked at all, or by this process, has been attempted.
 *)
  DDERR_NOTLOCKED                         = MAKE_DDHRESULT + 584;

(*
 * Windows can not create any more DCs, or a DC was requested for a paltte-indexed
 * surface when the surface had no palette AND the display mode was not palette-indexed
 * (in this case DirectDraw cannot select a proper palette into the DC)
 *)
  DDERR_CANTCREATEDC                      = MAKE_DDHRESULT + 585;

(*
 * No DC was ever created for this surface.
 *)
  DDERR_NODC                              = MAKE_DDHRESULT + 586;

(*
 * This surface can not be restored because it was created in a different
 * mode.
 *)
  DDERR_WRONGMODE                         = MAKE_DDHRESULT + 587;

(*
 * This surface can not be restored because it is an implicitly created
 * surface.
 *)
  DDERR_IMPLICITLYCREATED                 = MAKE_DDHRESULT + 588;

(*
 * The surface being used is not a palette-based surface
 *)
  DDERR_NOTPALETTIZED                     = MAKE_DDHRESULT + 589;

(*
 * The display is currently in an unsupported mode
 *)
  DDERR_UNSUPPORTEDMODE                   = MAKE_DDHRESULT + 590;

(*
 * Operation could not be carried out because there is no mip-map
 * texture mapping hardware present or available.
 *)
  DDERR_NOMIPMAPHW                        = MAKE_DDHRESULT + 591;

(*
 * The requested action could not be performed because the surface was of
 * the wrong type.
 *)
  DDERR_INVALIDSURFACETYPE                = MAKE_DDHRESULT + 592;

(*
 * Device does not support optimized surfaces, therefore no video memory optimized surfaces
 *)
  DDERR_NOOPTIMIZEHW                      = MAKE_DDHRESULT + 600;

(*
 * Surface is an optimized surface, but has not yet been allocated any memory
 *)
  DDERR_NOTLOADED                         = MAKE_DDHRESULT + 601;

(*
 * Attempt was made to create or set a device window without first setting
 * the focus window
 *)
  DDERR_NOFOCUSWINDOW                     = MAKE_DDHRESULT + 602;

(*
 * A DC has already been returned for this surface. Only one DC can be
 * retrieved per surface.
 *)
  DDERR_DCALREADYCREATED                  = MAKE_DDHRESULT + 620;

(*
 * An attempt was made to allocate non-local video memory from a device
 * that does not support non-local video memory.
 *)
  DDERR_NONONLOCALVIDMEM                  = MAKE_DDHRESULT + 630;

(*
 * The attempt to page lock a surface failed.
 *)
  DDERR_CANTPAGELOCK                      = MAKE_DDHRESULT + 640;

(*
 * The attempt to page unlock a surface failed.
 *)
  DDERR_CANTPAGEUNLOCK                    = MAKE_DDHRESULT + 660;

(*
 * An attempt was made to page unlock a surface with no outstanding page locks.
 *)
  DDERR_NOTPAGELOCKED                     = MAKE_DDHRESULT + 680;

(*
 * There is more data available than the specified buffer size could hold
 *)
  DDERR_MOREDATA         			= MAKE_DDHRESULT + 690;

(*
 * The data has expired and is therefore no longer valid.
 *)
  DDERR_EXPIRED                           = MAKE_DDHRESULT + 691;

(*
 * The video port is not active
 *)
  DDERR_VIDEONOTACTIVE   			= MAKE_DDHRESULT + 695;

(*
 * Surfaces created by one direct draw device cannot be used directly by
 * another direct draw device.
 *)
  DDERR_DEVICEDOESNTOWNSURFACE   		= MAKE_DDHRESULT + 699;

(*
 * An attempt was made to invoke an Interface member of a DirectDraw object
 * created by CoCreateInstance() before it was initialized.
 *)
  DDERR_NOTINITIALIZED                    = CO_E_NOTINITIALIZED;

(* Alpha bit depth constants *)

type
  HMonitor = THandle;

  TDDEnumCallbackA = function (lpGUID: PGUID; lpDriverDescription: PAnsiChar; lpDriverName: PAnsiChar; lpContext: Pointer) : BOOL; stdcall;
  TDDEnumCallbackW = function (lpGUID: PGUID; lpDriverDescription: PWideChar; lpDriverName: PWideChar; lpContext: Pointer) : BOOL; stdcall;

{$IFDEF UNICODE}
  TDDEnumCallback = TDDEnumCallbackW;
{$ELSE}
  TDDEnumCallback = TDDEnumCallbackA;
{$ENDIF}

  TDDEnumCallbackExA = function (lpGUID: PGUID; lpDriverDescription: PAnsiChar; lpDriverName: PAnsiChar; lpContext: Pointer; Monitor: HMonitor) : BOOL; stdcall;
  TDDEnumCallbackExW = function (lpGUID: PGUID; lpDriverDescription: PWideChar; lpDriverName: PWideChar; lpContext: Pointer; Monitor: HMonitor) : BOOL; stdcall;
      
{$IFDEF UNICODE}
  TDDEnumCallbackEx = TDDEnumCallbackExW;
{$ELSE}
  TDDEnumCallbackEx = TDDEnumCallbackExA;
{$ENDIF}

var
  DirectDrawEnumerateA : function (lpCallback: TDDEnumCallbackA; lpContext: Pointer) : HResult; StdCall;
  DirectDrawEnumerateW : function (lpCallback: TDDEnumCallbackW; lpContext: Pointer) : HResult; StdCall;
  DirectDrawEnumerate : function (lpCallback: TDDEnumCallback; lpContext: Pointer) : HResult; StdCall;

  DirectDrawEnumerateExA : function (lpCallback: TDDEnumCallbackExA; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
  DirectDrawEnumerateExW : function (lpCallback: TDDEnumCallbackExW; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
  DirectDrawEnumerateEx : function (lpCallback: TDDEnumCallbackEx; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;

  DirectDrawCreate : function (lpGUID: PGUID; Out lplpDD: IDirectDraw; pUnkOuter: IUnknown) : HResult; StdCall;
  DirectDrawCreateClipper : function (dwFlags: DWORD; Out lplpDDClipper: IDirectDrawClipper; pUnkOuter: IUnknown) : HResult; StdCall;

const
(*
 * Flags for DirectDrawEnumerateEx
 * DirectDrawEnumerateEx supercedes DirectDrawEnumerate. You must use GetProcAddress to
 * obtain a function pointer (of type LPDIRECTDRAWENUMERATEEX) to DirectDrawEnumerateEx.
 * By default, only the primary display device is enumerated.
 * DirectDrawEnumerate is equivalent to DirectDrawEnumerate(,,DDENUM_NONDISPLAYDEVICES)
 *)

(*
 * This flag causes enumeration of any GDI display devices which are part of
 * the Windows Desktop
 *)
  DDENUM_ATTACHEDSECONDARYDEVICES     = $00000001;

(*
 * This flag causes enumeration of any GDI display devices which are not
 * part of the Windows Desktop
 *)
  DDENUM_DETACHEDSECONDARYDEVICES     = $00000002;

(*
 * This flag causes enumeration of non-display devices
 *)
  DDENUM_NONDISPLAYDEVICES            = $00000004;

  REGSTR_KEY_DDHW_DESCRIPTION = 'Description';
  REGSTR_KEY_DDHW_DRIVERNAME  = 'DriverName';
  REGSTR_PATH_DDHW            = 'Hardware\DirectDrawDrivers';

  DDCREATE_HARDWAREONLY       = $00000001;
  DDCREATE_EMULATIONONLY      = $00000002;

(******************************************************************************)
(**                                                                          **)
(** D3DTypes.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(* TD3DValue is the fundamental Direct3D fractional data type *)

type
  TD3DValue = single;
  TD3DFixed = LongInt;
  float = TD3DValue;
  PD3DColor = ^TD3DColor;
  TD3DColor = DWORD;

function D3DVal(val: variant) : float;
function D3DDivide(a,b: double) : float;
function D3DMultiply(a,b: double) : float;

(*
 * Format of CI colors is
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  |    alpha      |         color index           |   fraction    |
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *)

function CI_GETALPHA(ci: DWORD) : DWORD;
function CI_GETINDEX(ci: DWORD) : DWORD;
function CI_GETFRACTION(ci: DWORD) : DWORD;
function CI_ROUNDINDEX(ci: DWORD) : DWORD;
function CI_MASKALPHA(ci: DWORD) : DWORD;
function CI_MAKE(a,i,f: DWORD) : DWORD;

(*
 * Format of RGBA colors is
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  |    alpha      |      red      |     green     |     blue      |
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *)

function RGBA_GETALPHA(rgb: TD3DColor) : DWORD;
function RGBA_GETRED(rgb: TD3DColor) : DWORD;
function RGBA_GETGREEN(rgb: TD3DColor) : DWORD;
function RGBA_GETBLUE(rgb: TD3DColor) : DWORD;
function RGBA_MAKE(r, g, b, a: DWORD) : TD3DColor;

(* D3DRGB and D3DRGBA may be used as initialisers for D3DCOLORs
 * The float values must be in the range 0..1
 *)

function D3DRGB(r, g, b: float) : TD3DColor;
function D3DRGBA(r, g, b, a: float) : TD3DColor;

(*
 * Format of RGB colors is
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *  |    ignored    |      red      |     green     |     blue      |
 *  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 *)

function RGB_GETRED(rgb: TD3DColor) : DWORD;
function RGB_GETGREEN(rgb: TD3DColor) : DWORD;
function RGB_GETBLUE(rgb: TD3DColor) : DWORD;
function RGBA_SETALPHA(rgba: TD3DColor; x: DWORD) : TD3DColor;
function RGB_MAKE(r, g, b: DWORD) : TD3DColor;
function RGBA_TORGB(rgba: TD3DColor) : TD3DColor;
function RGB_TORGBA(rgb: TD3DColor) : TD3DColor;

(*
 * Flags for Enumerate functions
 *)
const

(*
 * Stop the enumeration
 *)

  D3DENUMRET_CANCEL                        = DDENUMRET_CANCEL;

(*
 * Continue the enumeration
 *)

  D3DENUMRET_OK                            = DDENUMRET_OK;

type
  TD3DValidateCallback = function (lpUserArg: Pointer;
      dwOffset: DWORD): HResult; stdcall;
  TD3DEnumTextureFormatsCallback = function (var lpDdsd: TDDSurfaceDesc;
      lpContext: Pointer): HResult; stdcall;
  TD3DEnumPixelFormatsCallback = function (var lpDDPixFmt: TDDPixelFormat;
      lpContext: Pointer): HResult; stdcall;


  PD3DMaterialHandle = ^TD3DMaterialHandle;
  TD3DMaterialHandle = DWORD;

  PD3DTextureHandle = ^TD3DTextureHandle;
  TD3DTextureHandle = DWORD;

  PD3DMatrixHandle = ^TD3DMatrixHandle;
  TD3DMatrixHandle = DWORD;

  PD3DColorValue = ^TD3DColorValue;
  TD3DColorValue = packed record
    case Integer of
    0: (
      r: TD3DValue;
      g: TD3DValue;
      b: TD3DValue;
      a: TD3DValue;
     );
    1: (
      dvR: TD3DValue;
      dvG: TD3DValue;
      dvB: TD3DValue;
      dvA: TD3DValue;
     );
  end;

  PD3DRect = ^TD3DRect;
  TD3DRect = packed record
    case Integer of
    0: (
      x1: LongInt;
      y1: LongInt;
      x2: LongInt;
      y2: LongInt;
     );
    1: (
      lX1: LongInt;
      lY1: LongInt;
      lX2: LongInt;
      lY2: LongInt;
     );
     2: (
       a: array[0..3] of LongInt;
     );
  end;

  PD3DVector = ^TD3DVector;
  TD3DVector = packed record
    case Integer of
    0: (
      x: TD3DValue;
      y: TD3DValue;
      z: TD3DValue;
     );
    1: (
      dvX: TD3DValue;
      dvY: TD3DValue;
      dvZ: TD3DValue;
     );
  end;

    // Addition and subtraction
  function VectorAdd(const v1, v2: TD3DVector) : TD3DVector;
  function VectorSub(const v1, v2: TD3DVector) : TD3DVector;
    // Scalar multiplication and division
  function VectorMulS(const v: TD3DVector; s: TD3DValue) : TD3DVector;
  function VectorDivS(const v: TD3DVector; s: TD3DValue) : TD3DVector;
    // Memberwise multiplication and division
  function VectorMul(const v1, v2: TD3DVector) : TD3DVector;
  function VectorDiv(const v1, v2: TD3DVector) : TD3DVector;
    // Vector dominance
  function VectorSmaller(v1, v2: TD3DVector) : boolean;
  function VectorSmallerEquel(v1, v2: TD3DVector) : boolean;
    // Bitwise equality
  function VectorEquel(v1, v2: TD3DVector) : boolean;
    // Length-related functions
  function VectorSquareMagnitude(v: TD3DVector) : TD3DValue;
  function VectorMagnitude(v: TD3DVector) : TD3DValue;
    // Returns vector with same direction and unit length
  function VectorNormalize(const v: TD3DVector) : TD3DVector;
    // Return min/max component of the input vector
  function VectorMin(v: TD3DVector) : TD3DValue;
  function VectorMax(v: TD3DVector) : TD3DValue;
    // Return memberwise min/max of input vectors
  function VectorMinimize(const v1, v2: TD3DVector) : TD3DVector;
  function VectorMaximize(const v1, v2: TD3DVector) : TD3DVector;
    // Dot and cross product
  function VectorDotProduct(v1, v2: TD3DVector) : TD3DValue;
  function VectorCrossProduct(const v1, v2: TD3DVector) : TD3DVector;

type
(*
 * Vertex data types supported in an ExecuteBuffer.
 *)

(*
 * Homogeneous vertices
 *)

  TD3DHVertex = packed record
    dwFlags: DWORD;        (* Homogeneous clipping flags *)
    case Integer of
    0: (
      hx: TD3DValue;
      hy: TD3DValue;
      hz: TD3DValue;
     );
    1: (
      dvHX: TD3DValue;
      dvHY: TD3DValue;
      dvHZ: TD3DValue;
     );
  end;

(*
 * Transformed/lit vertices
 *)

  TD3DTLVertex = packed record
    case Integer of
    0: (
      sx: TD3DValue;             (* Screen coordinates *)
      sy: TD3DValue;
      sz: TD3DValue;
      rhw: TD3DValue;            (* Reciprocal of homogeneous w *)
      color: TD3DColor;          (* Vertex color *)
      specular: TD3DColor;       (* Specular component of vertex *)
      tu: TD3DValue;             (* Texture coordinates *)
      tv: TD3DValue;
     );
    1: (
      dvSX: TD3DValue;
      dvSY: TD3DValue;
      dvSZ: TD3DValue;
      dvRHW: TD3DValue;
      dcColor: TD3DColor;
      dcSpecular: TD3DColor;
      dvTU: TD3DValue;
      dvTV: TD3DValue;
     );
  end;

(*
 * Untransformed/lit vertices
 *)

  TD3DLVertex = packed record
    case Integer of
    0: (
      x: TD3DValue;             (* Homogeneous coordinates *)
      y: TD3DValue;
      z: TD3DValue;
      dwReserved: DWORD;
      color: TD3DColor;         (* Vertex color *)
      specular: TD3DColor;      (* Specular component of vertex *)
      tu: TD3DValue;            (* Texture coordinates *)
      tv: TD3DValue;
     );
    1: (
      dvX: TD3DValue;
      dvY: TD3DValue;
      dvZ: TD3DValue;
      UNIONFILLER1d: DWORD;
      dcColor: TD3DColor;
      dcSpecular: TD3DColor;
      dvTU: TD3DValue;
      dvTV: TD3DValue;
     );
  end;

(*
 * Untransformed/unlit vertices
 *)

  TD3DVertex = packed record
    case Integer of
    0: (
      x: TD3DValue;             (* Homogeneous coordinates *)
      y: TD3DValue;
      z: TD3DValue;
      nx: TD3DValue;            (* Normal *)
      ny: TD3DValue;
      nz: TD3DValue;
      tu: TD3DValue;            (* Texture coordinates *)
      tv: TD3DValue;
     );
    1: (
      dvX: TD3DValue;
      dvY: TD3DValue;
      dvZ: TD3DValue;
      dvNX: TD3DValue;
      dvNY: TD3DValue;
      dvNZ: TD3DValue;
      dvTU: TD3DValue;
      dvTV: TD3DValue;
     );
  end;

(*
 * Matrix, viewport, and tranformation structures and definitions.
 *)

  TD3DMatrix = packed record
    case integer of
      0 : (_11, _12, _13, _14: TD3DValue;
           _21, _22, _23, _24: TD3DValue;
           _31, _32, _33, _34: TD3DValue;
           _41, _42, _43, _44: TD3DValue);
      1 : (m : array [0..3, 0..3] of TD3DValue);
  end;

  TD3DViewport = packed record
    dwSize: DWORD;
    dwX: DWORD;
    dwY: DWORD;                (* Top left *)
    dwWidth: DWORD;
    dwHeight: DWORD;           (* Dimensions *)
    dvScaleX: TD3DValue;       (* Scale homogeneous to screen *)
    dvScaleY: TD3DValue;       (* Scale homogeneous to screen *)
    dvMaxX: TD3DValue;         (* Min/max homogeneous x coord *)
    dvMaxY: TD3DValue;         (* Min/max homogeneous y coord *)
    dvMinZ: TD3DValue;
    dvMaxZ: TD3DValue;         (* Min/max homogeneous z coord *)
  end;

  TD3DViewport2 = packed record
    dwSize: DWORD;
    dwX: DWORD;
    dwY: DWORD;                (* Viewport Top left *)
    dwWidth: DWORD;
    dwHeight: DWORD;           (* Viewport Dimensions *)
    dvClipX: TD3DValue;	       (* Top left of clip volume *)
    dvClipY: TD3DValue;
    dvClipWidth: TD3DValue;    (* Clip Volume Dimensions *)
    dvClipHeight: TD3DValue;
    dvMinZ: TD3DValue;         (* Min/max of clip Volume *)
    dvMaxZ: TD3DValue;
  end;

(*
 * Values for clip fields.
 *)

const
  D3DCLIP_LEFT                            = $00000001;
  D3DCLIP_RIGHT                           = $00000002;
  D3DCLIP_TOP                             = $00000004;
  D3DCLIP_BOTTOM                          = $00000008;
  D3DCLIP_FRONT                           = $00000010;
  D3DCLIP_BACK                            = $00000020;
  D3DCLIP_GEN0                            = $00000040;
  D3DCLIP_GEN1                            = $00000080;
  D3DCLIP_GEN2                            = $00000100;
  D3DCLIP_GEN3                            = $00000200;
  D3DCLIP_GEN4                            = $00000400;
  D3DCLIP_GEN5                            = $00000800;

(*
 * Values for d3d status.
 *)

  D3DSTATUS_CLIPUNIONLEFT                 = D3DCLIP_LEFT;
  D3DSTATUS_CLIPUNIONRIGHT                = D3DCLIP_RIGHT;
  D3DSTATUS_CLIPUNIONTOP                  = D3DCLIP_TOP;
  D3DSTATUS_CLIPUNIONBOTTOM               = D3DCLIP_BOTTOM;
  D3DSTATUS_CLIPUNIONFRONT                = D3DCLIP_FRONT;
  D3DSTATUS_CLIPUNIONBACK                 = D3DCLIP_BACK;
  D3DSTATUS_CLIPUNIONGEN0                 = D3DCLIP_GEN0;
  D3DSTATUS_CLIPUNIONGEN1                 = D3DCLIP_GEN1;
  D3DSTATUS_CLIPUNIONGEN2                 = D3DCLIP_GEN2;
  D3DSTATUS_CLIPUNIONGEN3                 = D3DCLIP_GEN3;
  D3DSTATUS_CLIPUNIONGEN4                 = D3DCLIP_GEN4;
  D3DSTATUS_CLIPUNIONGEN5                 = D3DCLIP_GEN5;

  D3DSTATUS_CLIPINTERSECTIONLEFT          = $00001000;
  D3DSTATUS_CLIPINTERSECTIONRIGHT         = $00002000;
  D3DSTATUS_CLIPINTERSECTIONTOP           = $00004000;
  D3DSTATUS_CLIPINTERSECTIONBOTTOM        = $00008000;
  D3DSTATUS_CLIPINTERSECTIONFRONT         = $00010000;
  D3DSTATUS_CLIPINTERSECTIONBACK          = $00020000;
  D3DSTATUS_CLIPINTERSECTIONGEN0          = $00040000;
  D3DSTATUS_CLIPINTERSECTIONGEN1          = $00080000;
  D3DSTATUS_CLIPINTERSECTIONGEN2          = $00100000;
  D3DSTATUS_CLIPINTERSECTIONGEN3          = $00200000;
  D3DSTATUS_CLIPINTERSECTIONGEN4          = $00400000;
  D3DSTATUS_CLIPINTERSECTIONGEN5          = $00800000;
  D3DSTATUS_ZNOTVISIBLE                   = $01000000;
(* Do not use 0x80000000 for any status flags in future as it is reserved *)

  D3DSTATUS_CLIPUNIONALL = (
            D3DSTATUS_CLIPUNIONLEFT or
            D3DSTATUS_CLIPUNIONRIGHT or
            D3DSTATUS_CLIPUNIONTOP or
            D3DSTATUS_CLIPUNIONBOTTOM or
            D3DSTATUS_CLIPUNIONFRONT or
            D3DSTATUS_CLIPUNIONBACK or
            D3DSTATUS_CLIPUNIONGEN0 or
            D3DSTATUS_CLIPUNIONGEN1 or
            D3DSTATUS_CLIPUNIONGEN2 or
            D3DSTATUS_CLIPUNIONGEN3 or
            D3DSTATUS_CLIPUNIONGEN4 or
            D3DSTATUS_CLIPUNIONGEN5);

  D3DSTATUS_CLIPINTERSECTIONALL = (
            D3DSTATUS_CLIPINTERSECTIONLEFT or
            D3DSTATUS_CLIPINTERSECTIONRIGHT or
            D3DSTATUS_CLIPINTERSECTIONTOP or
            D3DSTATUS_CLIPINTERSECTIONBOTTOM or
            D3DSTATUS_CLIPINTERSECTIONFRONT or
            D3DSTATUS_CLIPINTERSECTIONBACK or
            D3DSTATUS_CLIPINTERSECTIONGEN0 or
            D3DSTATUS_CLIPINTERSECTIONGEN1 or
            D3DSTATUS_CLIPINTERSECTIONGEN2 or
            D3DSTATUS_CLIPINTERSECTIONGEN3 or
            D3DSTATUS_CLIPINTERSECTIONGEN4 or
            D3DSTATUS_CLIPINTERSECTIONGEN5);

  D3DSTATUS_DEFAULT = (
            D3DSTATUS_CLIPINTERSECTIONALL or
            D3DSTATUS_ZNOTVISIBLE);

(*
 * Options for direct transform calls
 *)

  D3DTRANSFORM_CLIPPED       = $00000001;
  D3DTRANSFORM_UNCLIPPED     = $00000002;

type
  TD3DTransformData = packed record
    dwSize: DWORD;
    lpIn: Pointer;             (* Input vertices *)
    dwInSize: DWORD;           (* Stride of input vertices *)
    lpOut: Pointer;            (* Output vertices *)
    dwOutSize: DWORD;          (* Stride of output vertices *)
    lpHOut: ^TD3DHVertex;       (* Output homogeneous vertices *)
    dwClip: DWORD;             (* Clipping hint *)
    dwClipIntersection: DWORD;
    dwClipUnion: DWORD;        (* Union of all clip flags *)
    drExtent: TD3DRect;         (* Extent of transformed vertices *)
  end;

(*
 * Structure defining position and direction properties for lighting.
 *)

  TD3DLightingElement = packed record
    dvPosition: TD3DVector;           (* Lightable point in model space *)
    dvNormal: TD3DVector;             (* Normalised unit vector *)
  end;

(*
 * Structure defining material properties for lighting.
 *)

  TD3DMaterial = packed record
    dwSize: DWORD;
    case Integer of
    0: (
      diffuse: TD3DColorValue;        (* Diffuse color RGBA *)
      ambient: TD3DColorValue;        (* Ambient color RGB *)
      specular: TD3DColorValue;       (* Specular 'shininess' *)
      emissive: TD3DColorValue;       (* Emissive color RGB *)
      power: TD3DValue;               (* Sharpness if specular highlight *)
      hTexture: TD3DTextureHandle;    (* Handle to texture map *)
      dwRampSize: DWORD;
     );
    1: (
      dcvDiffuse: TD3DColorValue;
      dcvAmbient: TD3DColorValue;
      dcvSpecular: TD3DColorValue;
      dcvEmissive: TD3DColorValue;
      dvPower: TD3DValue;
     );
  end;

  TD3DLightType = (
    D3DLIGHT_INVALID_0,
    D3DLIGHT_POINT,
    D3DLIGHT_SPOT,
    D3DLIGHT_DIRECTIONAL,
    D3DLIGHT_PARALLELPOINT,
    D3DLIGHT_GLSPOT);

(*
 * Structure defining a light source and its properties.
 *)

  TD3DLight = packed record
    dwSize: DWORD;
    dltType: TD3DLightType;     (* Type of light source *)
    dcvColor: TD3DColorValue;   (* Color of light *)
    dvPosition: TD3DVector;     (* Position in world space *)
    dvDirection: TD3DVector;    (* Direction in world space *)
    dvRange: TD3DValue;         (* Cutoff range *)
    dvFalloff: TD3DValue;       (* Falloff *)
    dvAttenuation0: TD3DValue;  (* Constant attenuation *)
    dvAttenuation1: TD3DValue;  (* Linear attenuation *)
    dvAttenuation2: TD3DValue;  (* Quadratic attenuation *)
    dvTheta: TD3DValue;         (* Inner angle of spotlight cone *)
    dvPhi: TD3DValue;           (* Outer angle of spotlight cone *)
  end;

(*
 * Structure defining a light source and its properties.
 *)

(* flags bits *)
const
  D3DLIGHT_ACTIVE			= $00000001;
  D3DLIGHT_NO_SPECULAR	                = $00000002;

(* maximum valid light range *)
  D3DLIGHT_RANGE_MAX		= 1.8439088915e+18; //sqrt(FLT_MAX);

type
  TD3DLight2 = packed record
    dwSize: DWORD;
    dltType: TD3DLightType;     (* Type of light source *)
    dcvColor: TD3DColorValue;   (* Color of light *)
    dvPosition: TD3DVector;     (* Position in world space *)
    dvDirection: TD3DVector;    (* Direction in world space *)
    dvRange: TD3DValue;         (* Cutoff range *)
    dvFalloff: TD3DValue;       (* Falloff *)
    dvAttenuation0: TD3DValue;  (* Constant attenuation *)
    dvAttenuation1: TD3DValue;  (* Linear attenuation *)
    dvAttenuation2: TD3DValue;  (* Quadratic attenuation *)
    dvTheta: TD3DValue;         (* Inner angle of spotlight cone *)
    dvPhi: TD3DValue;           (* Outer angle of spotlight cone *)
    dwFlags: DWORD;
  end;

  TD3DLightData = packed record
    dwSize: DWORD;
    lpIn: ^TD3DLightingElement;   (* Input positions and normals *)
    dwInSize: DWORD;             (* Stride of input elements *)
    lpOut: ^TD3DTLVertex;         (* Output colors *)
    dwOutSize: DWORD;            (* Stride of output colors *)
  end;

(*
 * Before DX5, these values were in an enum called
 * TD3DColorModel. This was not correct, since they are
 * bit flags. A driver can surface either or both flags
 * in the dcmColorModel member of D3DDEVICEDESC.
 *)

type
  TD3DColorModel = DWORD;
 
const
  D3DCOLOR_MONO = 1;
  D3DCOLOR_RGB  = 2;

(*
 * Options for clearing
 *)

const
  D3DCLEAR_TARGET            = $00000001; (* Clear target surface *)
  D3DCLEAR_ZBUFFER           = $00000002; (* Clear target z buffer *)
  D3DCLEAR_STENCIL           = $00000004; (* Clear stencil planes *)

(*
 * Execute buffers are allocated via Direct3D.  These buffers may then
 * be filled by the application with instructions to execute along with
 * vertex data.
 *)

(*
 * Supported op codes for execute instructions.
 *)

type
  TD3DOpcode = (
    D3DOP_INVALID_0,
    D3DOP_POINT,
    D3DOP_LINE,
    D3DOP_TRIANGLE,
    D3DOP_MATRIXLOAD,
    D3DOP_MATRIXMULTIPLY,
    D3DOP_STATETRANSFORM,
    D3DOP_STATELIGHT,
    D3DOP_STATERENDER,
    D3DOP_PROCESSVERTICES,
    D3DOP_TEXTURELOAD,
    D3DOP_EXIT,
    D3DOP_BRANCHFORWARD,
    D3DOP_SPAN,
    D3DOP_SETSTATUS);

  TD3DInstruction = packed record
    bOpcode: BYTE;   (* Instruction opcode *)
    bSize: BYTE;     (* Size of each instruction data unit *)
    wCount: WORD;    (* Count of instruction data units to follow *)
  end;

(*
 * Structure for texture loads
 *)

  TD3DTextureLoad = packed record
    hDestTexture: TD3DTextureHandle;
    hSrcTexture: TD3DTextureHandle;
  end;

(*
 * Structure for picking
 *)

  TD3DPickRecord = packed record
    bOpcode: BYTE;
    bPad: BYTE;
    dwOffset: DWORD;
    dvZ: TD3DValue;
  end;

(*
 * The following defines the rendering states which can be set in the
 * execute buffer.
 *)

  TD3DShadeMode = (
    D3DSHADE_INVALID_0,
    D3DSHADE_FLAT,
    D3DSHADE_GOURAUD,
    D3DSHADE_PHONG);

  TD3DFillMode = (
    D3DFILL_INVALID_0,
    D3DFILL_POINT,
    D3DFILL_WIREFRAME,
    D3DFILL_SOLID);

  TD3DLinePattern = packed record
    wRepeatFactor: WORD;
    wLinePattern: WORD;
  end;

  TD3DTextureFilter = (
    D3DFILTER_INVALID_0,
    D3DFILTER_NEAREST,
    D3DFILTER_LINEAR,
    D3DFILTER_MIPNEAREST,
    D3DFILTER_MIPLINEAR,
    D3DFILTER_LINEARMIPNEAREST,
    D3DFILTER_LINEARMIPLINEAR);

  TD3DBlend = (
    D3DBLEND_INVALID_0,
    D3DBLEND_ZERO,
    D3DBLEND_ONE,
    D3DBLEND_SRCCOLOR,
    D3DBLEND_INVSRCCOLOR,
    D3DBLEND_SRCALPHA,
    D3DBLEND_INVSRCALPHA,
    D3DBLEND_DESTALPHA,
    D3DBLEND_INVDESTALPHA,
    D3DBLEND_DESTCOLOR,
    D3DBLEND_INVDESTCOLOR,
    D3DBLEND_SRCALPHASAT,
    D3DBLEND_BOTHSRCALPHA,
    D3DBLEND_BOTHINVSRCALPHA);

  TD3DTextureBlend = (
    D3DTBLEND_INVALID_0,
    D3DTBLEND_DECAL,
    D3DTBLEND_MODULATE,
    D3DTBLEND_DECALALPHA,
    D3DTBLEND_MODULATEALPHA,
    D3DTBLEND_DECALMASK,
    D3DTBLEND_MODULATEMASK,
    D3DTBLEND_COPY,
    D3DTBLEND_ADD);

  TD3DTextureAddress = (
    D3DTADDRESS_INVALID_0,
    D3DTADDRESS_WRAP,
    D3DTADDRESS_MIRROR,
    D3DTADDRESS_CLAMP,
    D3DTADDRESS_BORDER);

  TD3DCull = (
    D3DCULL_INVALID_0,
    D3DCULL_NONE,
    D3DCULL_CW,
    D3DCULL_CCW);

  TD3DCmpFunc = (
    D3DCMP_INVALID_0,
    D3DCMP_NEVER,
    D3DCMP_LESS,
    D3DCMP_EQUAL,
    D3DCMP_LESSEQUAL,
    D3DCMP_GREATER,
    D3DCMP_NOTEQUAL,
    D3DCMP_GREATEREQUAL,
    D3DCMP_ALWAYS);

  TD3DStencilOp = (
    D3DSTENCILOP_INVALID_0,
    D3DSTENCILOP_KEEP,
    D3DSTENCILOP_ZERO,
    D3DSTENCILOP_REPLACE,
    D3DSTENCILOP_INCRSAT,
    D3DSTENCILOP_DECRSAT,
    D3DSTENCILOP_INVERT,
    D3DSTENCILOP_INCR,
    D3DSTENCILOP_DECR);
    
  TD3DFogMode = (
    D3DFOG_NONE,
    D3DFOG_EXP,
    D3DFOG_EXP2,
    D3DFOG_LINEAR);

  TD3DZBufferType = (
    D3DZB_FALSE,
    D3DZB_TRUE,   // Z buffering
    D3DZB_USEW);  // W buffering

  TD3DAntialiasMode = (
    D3DANTIALIAS_NONE,
    D3DANTIALIAS_SORTDEPENDENT,
    D3DANTIALIAS_SORTINDEPENDENT);

// Vertex types supported by Direct3D
  TD3DVertexType = (
    D3DVT_INVALID_0,
    D3DVT_VERTEX,
    D3DVT_LVERTEX,
    D3DVT_TLVERTEX);

// Primitives supported by draw-primitive API
  TD3DPrimitiveType = (
    D3DPT_INVALID_0,
    D3DPT_POINTLIST,
    D3DPT_LINELIST,
    D3DPT_LINESTRIP,
    D3DPT_TRIANGLELIST,
    D3DPT_TRIANGLESTRIP,
    D3DPT_TRIANGLEFAN);

(*
 * Amount to add to a state to generate the override for that state.
 *)

const
  D3DSTATE_OVERRIDE_BIAS          = 256;

(*
 * A state which sets the override flag for the specified state type.
 *)

function D3DSTATE_OVERRIDE(StateType: DWORD) : DWORD;

type
  TD3DTransformStateType = (
    D3DTRANSFORMSTATE_INVALID_0,
    D3DTRANSFORMSTATE_WORLD,
    D3DTRANSFORMSTATE_VIEW,
    D3DTRANSFORMSTATE_PROJECTION);

  TD3DLightStateType = (
    D3DLIGHTSTATE_INVALID_0,
    D3DLIGHTSTATE_MATERIAL,
    D3DLIGHTSTATE_AMBIENT,
    D3DLIGHTSTATE_COLORMODEL,
    D3DLIGHTSTATE_FOGMODE,
    D3DLIGHTSTATE_FOGSTART,
    D3DLIGHTSTATE_FOGEND,
    D3DLIGHTSTATE_FOGDENSITY,
    D3DLIGHTSTATE_COLORVERTEX);

  TD3DRenderStateType = (
    D3DRENDERSTATE_INVALID_0,
    D3DRENDERSTATE_TEXTUREHANDLE,       (* Texture handle for legacy interfaces (Texture,Texture2) *)
    D3DRENDERSTATE_ANTIALIAS,           (* TD3DAntiAliasMode *)
    D3DRENDERSTATE_TEXTUREADDRESS,      (* TD3DTextureAddress  *)
    D3DRENDERSTATE_TEXTUREPERSPECTIVE,  (* TRUE for perspective correction *)
    D3DRENDERSTATE_WRAPU,               (* TRUE for wrapping in u *)
    D3DRENDERSTATE_WRAPV,               (* TRUE for wrapping in v *)
    D3DRENDERSTATE_ZENABLE,             (* TD3DZBufferType (or TRUE/FALSE for legacy) *)
    D3DRENDERSTATE_FILLMODE,            (* D3DFILL_MODE            *)
    D3DRENDERSTATE_SHADEMODE,           (* TD3DShadeMode *)
    D3DRENDERSTATE_LINEPATTERN,         (* TD3DLinePattern *)
    D3DRENDERSTATE_MONOENABLE,          (* TRUE to enable mono rasterization *)
    D3DRENDERSTATE_ROP2,                (* ROP2 *)
    D3DRENDERSTATE_PLANEMASK,           (* DWORD physical plane mask *)
    D3DRENDERSTATE_ZWRITEENABLE,        (* TRUE to enable z writes *)
    D3DRENDERSTATE_ALPHATESTENABLE,     (* TRUE to enable alpha tests *)
    D3DRENDERSTATE_LASTPIXEL,           (* TRUE for last-pixel on lines *)
    D3DRENDERSTATE_TEXTUREMAG,          (* TD3DTextureFilter *)
    D3DRENDERSTATE_TEXTUREMIN,          (* TD3DTextureFilter *)
    D3DRENDERSTATE_SRCBLEND,            (* TD3DBlend *)
    D3DRENDERSTATE_DESTBLEND,           (* TD3DBlend *)
    D3DRENDERSTATE_TEXTUREMAPBLEND,     (* TD3DTextureBlend *)
    D3DRENDERSTATE_CULLMODE,            (* TD3DCull *)
    D3DRENDERSTATE_ZFUNC,               (* TD3DCmpFunc *)
    D3DRENDERSTATE_ALPHAREF,            (* TD3DFixed *)
    D3DRENDERSTATE_ALPHAFUNC,           (* TD3DCmpFunc *)
    D3DRENDERSTATE_DITHERENABLE,        (* TRUE to enable dithering *)
    D3DRENDERSTATE_ALPHABLENDENABLE,         (* TRUE to enable alpha blending *)
    D3DRENDERSTATE_FOGENABLE,           (* TRUE to enable fog *)
    D3DRENDERSTATE_SPECULARENABLE,      (* TRUE to enable specular *)
    D3DRENDERSTATE_ZVISIBLE,            (* TRUE to enable z checking *)
    D3DRENDERSTATE_SUBPIXEL,            (* TRUE to enable subpixel correction *)
    D3DRENDERSTATE_SUBPIXELX,           (* TRUE to enable correction in X only *)
    D3DRENDERSTATE_STIPPLEDALPHA,       (* TRUE to enable stippled alpha *)
    D3DRENDERSTATE_FOGCOLOR,            (* TD3DColor *)
    D3DRENDERSTATE_FOGTABLEMODE,        (* TD3DFogMode *)
    D3DRENDERSTATE_FOGTABLESTART,       (* Fog table start        *)
    D3DRENDERSTATE_FOGTABLEEND,         (* Fog table end          *)
    D3DRENDERSTATE_FOGTABLEDENSITY,     (* Fog table density      *)
    D3DRENDERSTATE_STIPPLEENABLE,       (* TRUE to enable stippling *)
    D3DRENDERSTATE_EDGEANTIALIAS,       (* TRUE to enable edge antialiasing *)
    D3DRENDERSTATE_COLORKEYENABLE,      (* TRUE to enable source colorkeyed textures *)
    D3DRENDERSTATE_BORDERCOLOR,         (* Border color for texturing w/border *)
    D3DRENDERSTATE_TEXTUREADDRESSU,     (* Texture addressing mode for U coordinate *)
    D3DRENDERSTATE_TEXTUREADDRESSV,     (* Texture addressing mode for V coordinate *)
    D3DRENDERSTATE_MIPMAPLODBIAS,       (* TD3DValue Mipmap LOD bias *)
    D3DRENDERSTATE_ZBIAS,               (* LONG Z bias *)
    D3DRENDERSTATE_RANGEFOGENABLE,      (* Enables range-based fog *)
    D3DRENDERSTATE_ANISOTROPY,          (* Max. anisotropy. 1 = no anisotropy *)
    D3DRENDERSTATE_FLUSHBATCH,          (* Explicit flush for DP batching (DX5 Only) *)
    D3DRENDERSTATE_TRANSLUCENTSORTINDEPENDENT, (* BOOL enable sort-independent transparency *)
    D3DRENDERSTATE_STENCILENABLE,       (* BOOL enable(disable stenciling *)
    D3DRENDERSTATE_STENCILFAIL,         (* TD3DStencilOp to do if stencil test fails *)
    D3DRENDERSTATE_STENCILZFAIL,        (* TD3DSTENCILOP to do if stencil test passes and Z test fails *)
    D3DRENDERSTATE_STENCILPASS,         (* TD3DStencilOp to do if both stencil and Z tests pass *)
    D3DRENDERSTATE_STENCILFUNC,         (* TD3DCmpFunc fn.  Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
    D3DRENDERSTATE_STENCILREF,          (* Reference value used in stencil test *)
    D3DRENDERSTATE_STENCILMASK,         (* Mask value used in stencil test *)
    D3DRENDERSTATE_STENCILWRITEMASK,    (* Write mask applied to values written to stencil buffer *)
    D3DRENDERSTATE_TEXTUREFACTOR,       (* TD3DColor used for multi-texture blend *)
    D3DRENDERSTATE_INVALID_61,
    D3DRENDERSTATE_INVALID_62,
    D3DRENDERSTATE_INVALID_63,
    D3DRENDERSTATE_STIPPLEPATTERN00,    (* Stipple pattern 01...  *)
    D3DRENDERSTATE_STIPPLEPATTERN01,
    D3DRENDERSTATE_STIPPLEPATTERN02,
    D3DRENDERSTATE_STIPPLEPATTERN03,
    D3DRENDERSTATE_STIPPLEPATTERN04,
    D3DRENDERSTATE_STIPPLEPATTERN05,
    D3DRENDERSTATE_STIPPLEPATTERN06,
    D3DRENDERSTATE_STIPPLEPATTERN07,
    D3DRENDERSTATE_STIPPLEPATTERN08,
    D3DRENDERSTATE_STIPPLEPATTERN09,
    D3DRENDERSTATE_STIPPLEPATTERN10,
    D3DRENDERSTATE_STIPPLEPATTERN11,
    D3DRENDERSTATE_STIPPLEPATTERN12,
    D3DRENDERSTATE_STIPPLEPATTERN13,
    D3DRENDERSTATE_STIPPLEPATTERN14,
    D3DRENDERSTATE_STIPPLEPATTERN15,
    D3DRENDERSTATE_STIPPLEPATTERN16,
    D3DRENDERSTATE_STIPPLEPATTERN17,
    D3DRENDERSTATE_STIPPLEPATTERN18,
    D3DRENDERSTATE_STIPPLEPATTERN19,
    D3DRENDERSTATE_STIPPLEPATTERN20,
    D3DRENDERSTATE_STIPPLEPATTERN21,
    D3DRENDERSTATE_STIPPLEPATTERN22,
    D3DRENDERSTATE_STIPPLEPATTERN23,
    D3DRENDERSTATE_STIPPLEPATTERN24,
    D3DRENDERSTATE_STIPPLEPATTERN25,
    D3DRENDERSTATE_STIPPLEPATTERN26,
    D3DRENDERSTATE_STIPPLEPATTERN27,
    D3DRENDERSTATE_STIPPLEPATTERN28,
    D3DRENDERSTATE_STIPPLEPATTERN29,
    D3DRENDERSTATE_STIPPLEPATTERN30,
    D3DRENDERSTATE_STIPPLEPATTERN31,
    D3DRENDERSTATE_INVALID_96,
    D3DRENDERSTATE_INVALID_97,
    D3DRENDERSTATE_INVALID_98,
    D3DRENDERSTATE_INVALID_99,
    D3DRENDERSTATE_INVALID_100,
    D3DRENDERSTATE_INVALID_101,
    D3DRENDERSTATE_INVALID_102,
    D3DRENDERSTATE_INVALID_103,
    D3DRENDERSTATE_INVALID_104,
    D3DRENDERSTATE_INVALID_105,
    D3DRENDERSTATE_INVALID_106,
    D3DRENDERSTATE_INVALID_107,
    D3DRENDERSTATE_INVALID_108,
    D3DRENDERSTATE_INVALID_109,
    D3DRENDERSTATE_INVALID_110,
    D3DRENDERSTATE_INVALID_111,
    D3DRENDERSTATE_INVALID_112,
    D3DRENDERSTATE_INVALID_113,
    D3DRENDERSTATE_INVALID_114,
    D3DRENDERSTATE_INVALID_115,
    D3DRENDERSTATE_INVALID_116,
    D3DRENDERSTATE_INVALID_117,
    D3DRENDERSTATE_INVALID_118,
    D3DRENDERSTATE_INVALID_119,
    D3DRENDERSTATE_INVALID_120,
    D3DRENDERSTATE_INVALID_121,
    D3DRENDERSTATE_INVALID_122,
    D3DRENDERSTATE_INVALID_123,
    D3DRENDERSTATE_INVALID_124,
    D3DRENDERSTATE_INVALID_125,
    D3DRENDERSTATE_INVALID_126,
    D3DRENDERSTATE_INVALID_127,

    (*
     * 128 values [128, 255] are reserved for texture coordinate wrap flags.
     * These are constructed with the D3DWRAP_U and D3DWRAP_V macros. Using
     * a flags word preserves forward compatibility with texture coordinates
     * that are >2D.
     *)
    D3DRENDERSTATE_WRAP0,  (* wrap for 1st texture coord. set *)
    D3DRENDERSTATE_WRAP1,  (* wrap for 2nd texture coord. set *)
    D3DRENDERSTATE_WRAP2,  (* wrap for 3rd texture coord. set *)
    D3DRENDERSTATE_WRAP3,  (* wrap for 4th texture coord. set *)
    D3DRENDERSTATE_WRAP4,  (* wrap for 5th texture coord. set *)
    D3DRENDERSTATE_WRAP5,  (* wrap for 6th texture coord. set *)
    D3DRENDERSTATE_WRAP6,  (* wrap for 7th texture coord. set *)
    D3DRENDERSTATE_WRAP7); (* wrap for 8th texture coord. set *)

const
  // For back-compatibility with legacy compilations
  D3DRENDERSTATE_BLENDENABLE = D3DRENDERSTATE_ALPHABLENDENABLE;


// Bias to apply to the texture coordinate set to apply a wrap to.
   D3DRENDERSTATE_WRAPBIAS                = 128;

(* Flags to construct the WRAP render states *)
  D3DWRAP_U   = $00000001;
  D3DWRAP_V   = $00000002;

function D3DRENDERSTATE_STIPPLEPATTERN(y: integer) : TD3DRenderStateType;

type
  TD3DState = packed record
    case Integer of
    0: (
      dtstTransformStateType: TD3DTransformStateType;
      dwArg: Array [ 0..0 ] of DWORD;
     );
    1: (
      dlstLightStateType: TD3DLightStateType;
      dvArg: Array [ 0..0 ] of TD3DValue;
     );
    2: (
      drstRenderStateType: TD3DRenderStateType;
     );
  end;

(*
 * Operation used to load matrices
 * hDstMat = hSrcMat
 *)
  TD3DMatrixLoad = packed record
    hDestMatrix: TD3DMatrixHandle;   (* Destination matrix *)
    hSrcMatrix: TD3DMatrixHandle;    (* Source matrix *)
  end;

(*
 * Operation used to multiply matrices
 * hDstMat = hSrcMat1 * hSrcMat2
 *)
  TD3DMatrixMultiply = packed record
    hDestMatrix: TD3DMatrixHandle;   (* Destination matrix *)
    hSrcMatrix1: TD3DMatrixHandle;   (* First source matrix *)
    hSrcMatrix2: TD3DMatrixHandle;   (* Second source matrix *)
  end;

(*
 * Operation used to transform and light vertices.
 *)
  TD3DProcessVertices = packed record
    dwFlags: DWORD;           (* Do we transform or light or just copy? *)
    wStart: WORD;             (* Index to first vertex in source *)
    wDest: WORD;              (* Index to first vertex in local buffer *)
    dwCount: DWORD;           (* Number of vertices to be processed *)
    dwReserved: DWORD;        (* Must be zero *)
  end;

const
  D3DPROCESSVERTICES_TRANSFORMLIGHT       = $00000000;
  D3DPROCESSVERTICES_TRANSFORM            = $00000001;
  D3DPROCESSVERTICES_COPY                 = $00000002;
  D3DPROCESSVERTICES_OPMASK               = $00000007;

  D3DPROCESSVERTICES_UPDATEEXTENTS        = $00000008;
  D3DPROCESSVERTICES_NOCOLOR              = $00000010;


(*
 * State enumerants for per-stage texture processing.
 *)
type
  TD3DTextureStageStateType = (
    D3DTSS_INVALID_0,
    D3DTSS_COLOROP        , (* D3DTEXTUREOP - per-stage blending controls for color channels *)
    D3DTSS_COLORARG1      , (* D3DTA_* (texture arg) *)
    D3DTSS_COLORARG2      , (* D3DTA_* (texture arg) *)
    D3DTSS_ALPHAOP        , (* D3DTEXTUREOP - per-stage blending controls for alpha channel *)
    D3DTSS_ALPHAARG1      , (* D3DTA_* (texture arg) *)
    D3DTSS_ALPHAARG2      , (* D3DTA_* (texture arg) *)
    D3DTSS_BUMPENVMAT00   , (* D3DVALUE (bump mapping matrix) *)
    D3DTSS_BUMPENVMAT01   , (* D3DVALUE (bump mapping matrix) *)
    D3DTSS_BUMPENVMAT10   , (* D3DVALUE (bump mapping matrix) *)
    D3DTSS_BUMPENVMAT11   , (* D3DVALUE (bump mapping matrix) *)
    D3DTSS_TEXCOORDINDEX  , (* identifies which set of texture coordinates index this texture *)
    D3DTSS_ADDRESS        , (* D3DTEXTUREADDRESS for both coordinates *)
    D3DTSS_ADDRESSU       , (* D3DTEXTUREADDRESS for U coordinate *)
    D3DTSS_ADDRESSV       , (* D3DTEXTUREADDRESS for V coordinate *)
    D3DTSS_BORDERCOLOR    , (* D3DCOLOR *)
    D3DTSS_MAGFILTER      , (* D3DTEXTUREMAGFILTER filter to use for magnification *)
    D3DTSS_MINFILTER      , (* D3DTEXTUREMINFILTER filter to use for minification *)
    D3DTSS_MIPFILTER      , (* D3DTEXTUREMIPFILTER filter to use between mipmaps during minification *)
    D3DTSS_MIPMAPLODBIAS  , (* D3DVALUE Mipmap LOD bias *)
    D3DTSS_MAXMIPLEVEL    , (* DWORD 0..(n-1) LOD index of largest map to use (0 == largest) *)
    D3DTSS_MAXANISOTROPY  , (* DWORD maximum anisotropy *)
    D3DTSS_BUMPENVLSCALE  , (* D3DVALUE scale for bump map luminance *)
    D3DTSS_BUMPENVLOFFSET); (* D3DVALUE offset for bump map luminance *)

(*
 * Enumerations for COLOROP and ALPHAOP texture blending operations set in
 * texture processing stage controls in D3DRENDERSTATE.
 *)
  TD3DTextureOp = (
    D3DTOP_INVALID_0,
// Control
    D3DTOP_DISABLE   ,      // disables stage
    D3DTOP_SELECTARG1,      // the default
    D3DTOP_SELECTARG2,

// Modulate
    D3DTOP_MODULATE  ,      // multiply args together
    D3DTOP_MODULATE2X,      // multiply and  1 bit
    D3DTOP_MODULATE4X,      // multiply and  2 bits

// Add
    D3DTOP_ADD        ,   // add arguments together
    D3DTOP_ADDSIGNED  ,   // add with -0.5 bias
    D3DTOP_ADDSIGNED2X,   // as above but left  1 bit
    D3DTOP_SUBTRACT   ,   // Arg1 - Arg2, with no saturation
    D3DTOP_ADDSMOOTH  ,   // add 2 args, subtract product
                          // Arg1 + Arg2 - Arg1*Arg2
                          // = Arg1 + (1-Arg1)*Arg2

// Linear alpha blend: Arg1*(Alpha) + Arg2*(1-Alpha)
    D3DTOP_BLENDDIFFUSEALPHA  , // iterated alpha
    D3DTOP_BLENDTEXTUREALPHA  , // texture alpha
    D3DTOP_BLENDFACTORALPHA   , // alpha from D3DRENDERSTATE_TEXTUREFACTOR
    // Linear alpha blend with pre-multiplied arg1 input: Arg1 + Arg2*(1-Alpha)
    D3DTOP_BLENDTEXTUREALPHAPM, // texture alpha
    D3DTOP_BLENDCURRENTALPHA  , // by alpha of current color

// Specular mapping
    D3DTOP_PREMODULATE           ,     // modulate with next texture before use
    D3DTOP_MODULATEALPHA_ADDCOLOR,     // Arg1.RGB + Arg1.A*Arg2.RGB
                                       // COLOROP only
    D3DTOP_MODULATECOLOR_ADDALPHA,     // Arg1.RGB*Arg2.RGB + Arg1.A
                                            // COLOROP only
    D3DTOP_MODULATEINVALPHA_ADDCOLOR,  // (1-Arg1.A)*Arg2.RGB + Arg1.RGB
                                       // COLOROP only
    D3DTOP_MODULATEINVCOLOR_ADDALPHA,  // (1-Arg1.RGB)*Arg2.RGB + Arg1.A
                                            // COLOROP only

// Bump mapping
    D3DTOP_BUMPENVMAP         , // per pixel env map perturbation
    D3DTOP_BUMPENVMAPLUMINANCE, // with luminance channel
    // This can do either diffuse or specular bump mapping with correct input.
    // Performs the function (Arg1.R*Arg2.R + Arg1.G*Arg2.G + Arg1.B*Arg2.B)
    // where each component has been scaled and offset to make it signed.
    // The result is replicated into all four (including alpha) channels.
    // This is a valid COLOROP only.
    D3DTOP_DOTPRODUCT3);

(*
 * Values for COLORARG1,2 and ALPHAARG1,2 texture blending operations
 * set in texture processing stage controls in D3DRENDERSTATE.
 *)
const
  D3DTA_SELECTMASK        = $0000000f;  // mask for arg selector
  D3DTA_DIFFUSE           = $00000000;  // select diffuse color
  D3DTA_CURRENT           = $00000001;  // select result of previous stage
  D3DTA_TEXTURE           = $00000002;  // select texture color
  D3DTA_TFACTOR           = $00000003;  // select RENDERSTATE_TEXTUREFACTOR

  D3DTA_COMPLEMENT        = $00000010;  // take 1.0 - x
  D3DTA_ALPHAREPLICATE    = $00000020;  // replicate alpha to color components

(*
 *  IDirect3DTexture2 State Filter Types
 *)
type
  TD3DTextureMagFilter = (
    D3DTFG_INVALID_0,
    D3DTFG_POINT        ,    // nearest
    D3DTFG_LINEAR       ,    // linear interpolation
    D3DTFG_FLATCUBIC    ,    // cubic
    D3DTFG_GAUSSIANCUBIC,    // different cubic kernel
    D3DTFG_ANISOTROPIC);

  TD3DTextureMinFilter = (
    D3DTFN_INVALID_0,
    D3DTFN_POINT      ,    // nearest
    D3DTFN_LINEAR     ,    // linear interpolation
    D3DTFN_ANISOTROPIC);

  TD3DTextureMipFilter = (
    D3DTFP_INVALID_0,
    D3DTFP_NONE   ,    // mipmapping disabled (use MAG filter)
    D3DTFP_POINT  ,    // nearest
    D3DTFP_LINEAR);    // linear interpolation


(*
 * Triangle flags
 *)

(*
 * Tri strip and fan flags.
 * START loads all three vertices
 * EVEN and ODD load just v3 with even or odd culling
 * START_FLAT contains a count from 0 to 29 that allows the
 * whole strip or fan to be culled in one hit.
 * e.g. for a quad len = 1
 *)
const
  D3DTRIFLAG_START                        = $00000000;
// #define D3DTRIFLAG_STARTFLAT(len) (len)         (* 0 < len < 30 *)
function D3DTRIFLAG_STARTFLAT(len: DWORD) : DWORD;

const
  D3DTRIFLAG_ODD                          = $0000001e;
  D3DTRIFLAG_EVEN                         = $0000001f;

(*
 * Triangle edge flags
 * enable edges for wireframe or antialiasing
 *)
  D3DTRIFLAG_EDGEENABLE1                  = $00000100; (* v0-v1 edge *)
  D3DTRIFLAG_EDGEENABLE2                  = $00000200; (* v1-v2 edge *)
  D3DTRIFLAG_EDGEENABLE3                  = $00000400; (* v2-v0 edge *)
  D3DTRIFLAG_EDGEENABLETRIANGLE = (
      D3DTRIFLAG_EDGEENABLE1 or D3DTRIFLAG_EDGEENABLE2 or D3DTRIFLAG_EDGEENABLE3);

(*
 * Primitive structures and related defines.  Vertex offsets are to types
 * TD3DVertex, TD3DLVertex, or TD3DTLVertex.
 *)

(*
 * Triangle list primitive structure
 *)
type
  TD3DTriangle = packed record
    case Integer of
    0: (
      v1: WORD;            (* Vertex indices *)
      v2: WORD;
      v3: WORD;
      wFlags: WORD;        (* Edge (and other) flags *)
     );
    1: (
      wV1: WORD;
      wV2: WORD;
      wV3: WORD;
     );
  end;

(*
 * Line strip structure.
 * The instruction count - 1 defines the number of line segments.
 *)
  TD3DLine = packed record
    case Integer of
    0: (
      v1: WORD;            (* Vertex indices *)
      v2: WORD;
     );
    1: (
      wV1: WORD;
      wV2: WORD;
     );
  end;

(*
 * Span structure
 * Spans join a list of points with the same y value.
 * If the y value changes, a new span is started.
 *)
  TD3DSpan = packed record
    wCount: WORD;        (* Number of spans *)
    wFirst: WORD;        (* Index to first vertex *)
  end;

(*
 * Point structure
 *)
  TD3DPoint = packed record
    wCount: WORD;        (* number of points         *)
    wFirst: WORD;        (* index to first vertex    *)
  end;

(*
 * Forward branch structure.
 * Mask is logically anded with the driver status mask
 * if the result equals 'value', the branch is taken.
 *)
  TD3DBranch = packed record
    dwMask: DWORD;         (* Bitmask against D3D status *)
    dwValue: DWORD;
    bNegate: BOOL;         (* TRUE to negate comparison *)
    dwOffset: DWORD;       (* How far to branch forward (0 for exit)*)
  end;

(*
 * Status used for set status instruction.
 * The D3D status is initialised on device creation
 * and is modified by all execute calls.
 *)
  TD3DStatus = packed record
    dwFlags: DWORD;        (* Do we set extents or status *)
    dwStatus: DWORD;       (* D3D status *)
    drExtent: TD3DRect;
  end;

const
  D3DSETSTATUS_STATUS   = $00000001;
  D3DSETSTATUS_EXTENTS  = $00000002;
  D3DSETSTATUS_ALL      = (D3DSETSTATUS_STATUS or D3DSETSTATUS_EXTENTS);

type
  TD3DClipStatus = packed record
    dwFlags : DWORD; (* Do we set 2d extents, 3D extents or status *)
    dwStatus : DWORD; (* Clip status *)
    minx, maxx : float; (* X extents *)
    miny, maxy : float; (* Y extents *)
    minz, maxz : float; (* Z extents *)
  end;

const
  D3DCLIPSTATUS_STATUS        = $00000001;
  D3DCLIPSTATUS_EXTENTS2      = $00000002;
  D3DCLIPSTATUS_EXTENTS3      = $00000004;

(*
 * Statistics structure
 *)
type
  TD3DStats = packed record
    dwSize: DWORD;
    dwTrianglesDrawn: DWORD;
    dwLinesDrawn: DWORD;
    dwPointsDrawn: DWORD;
    dwSpansDrawn: DWORD;
    dwVerticesProcessed: DWORD;
  end;

(*
 * Execute options.
 * When calling using D3DEXECUTE_UNCLIPPED all the primitives
 * inside the buffer must be contained within the viewport.
 *)
const
  D3DEXECUTE_CLIPPED       = $00000001;
  D3DEXECUTE_UNCLIPPED     = $00000002;

type
  TD3DExecuteData = packed record
    dwSize: DWORD;
    dwVertexOffset: DWORD;
    dwVertexCount: DWORD;
    dwInstructionOffset: DWORD;
    dwInstructionLength: DWORD;
    dwHVertexOffset: DWORD;
    dsStatus: TD3DStatus;       (* Status after execute *)
  end;

(*
 * Palette flags.
 * This are or'ed with the peFlags in the PALETTEENTRYs passed to DirectDraw.
 *)

const
  D3DPAL_FREE     = $00;    (* Renderer may use this entry freely *)
  D3DPAL_READONLY = $40;    (* Renderer may not set this entry *)
  D3DPAL_RESERVED = $80;    (* Renderer may not use this entry *)


type
  PD3DVertexBufferDesc = ^TD3DVertexBufferDesc;
  TD3DVertexBufferDesc = packed record
    dwSize : DWORD;
    dwCaps : DWORD;
    dwFVF : DWORD;
    dwNumVertices : DWORD;
  end;

const
(* These correspond to DDSCAPS_* flags *)
  D3DVBCAPS_SYSTEMMEMORY      = $00000800;
  D3DVBCAPS_WRITEONLY         = $00010000;
  D3DVBCAPS_OPTIMIZED         = $80000000;

(* Vertex Operations for ProcessVertices *)
  D3DVOP_LIGHT      = (1 shl 10);
  D3DVOP_TRANSFORM  = (1 shl 0);
  D3DVOP_CLIP       = (1 shl 2);
  D3DVOP_EXTENTS    = (1 shl 3);

//-------------------------------------------------------------------

// Flexible vertex format bits
//
  D3DFVF_RESERVED0        = $001;
  D3DFVF_POSITION_MASK    = $00E;
  D3DFVF_XYZ              = $002;
  D3DFVF_XYZRHW           = $004;
  D3DFVF_NORMAL           = $010;
  D3DFVF_RESERVED1        = $020;
  D3DFVF_DIFFUSE          = $040;
  D3DFVF_SPECULAR         = $080;

  D3DFVF_TEXCOUNT_MASK    = $f00;
  D3DFVF_TEXCOUNT_SHIFT   = 8;
  D3DFVF_TEX0             = $000;
  D3DFVF_TEX1             = $100;
  D3DFVF_TEX2             = $200;
  D3DFVF_TEX3             = $300;
  D3DFVF_TEX4             = $400;
  D3DFVF_TEX5             = $500;
  D3DFVF_TEX6             = $600;
  D3DFVF_TEX7             = $700;
  D3DFVF_TEX8             = $800;

  D3DFVF_RESERVED2        = $f000;  // 4 reserved bits

  D3DFVF_VERTEX = ( D3DFVF_XYZ or D3DFVF_NORMAL or D3DFVF_TEX1 );
  D3DFVF_LVERTEX = ( D3DFVF_XYZ or D3DFVF_RESERVED1 or D3DFVF_DIFFUSE or
                         D3DFVF_SPECULAR or D3DFVF_TEX1 );
  D3DFVF_TLVERTEX = ( D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_SPECULAR or
                          D3DFVF_TEX1 );

type
  TD3DDP_PtrStride = packed record
    lpvData : pointer;
    dwStride : DWORD;
  end;

const
  D3DDP_MAXTEXCOORD = 8;

type
  PD3DDrawPrimitiveStridedData = ^TD3DDrawPrimitiveStridedData;
  TD3DDrawPrimitiveStridedData = packed record
    position : TD3DDP_PtrStride;
    normal : TD3DDP_PtrStride;
    diffuse : TD3DDP_PtrStride;
    specular : TD3DDP_PtrStride;
    textureCoords : array [0..D3DDP_MAXTEXCOORD-1] of TD3DDP_PtrStride;
  end;

//---------------------------------------------------------------------
// ComputeSphereVisibility return values
//
const
  D3DVIS_INSIDE_FRUSTUM      = 0;
  D3DVIS_INTERSECT_FRUSTUM   = 1;
  D3DVIS_OUTSIDE_FRUSTUM     = 2;
  D3DVIS_INSIDE_LEFT         = 0;
  D3DVIS_INTERSECT_LEFT      = (1 shl 2);
  D3DVIS_OUTSIDE_LEFT        = (2 shl 2);
  D3DVIS_INSIDE_RIGHT        = 0;
  D3DVIS_INTERSECT_RIGHT     = (1 shl 4);
  D3DVIS_OUTSIDE_RIGHT       = (2 shl 4);
  D3DVIS_INSIDE_TOP          = 0;
  D3DVIS_INTERSECT_TOP       = (1 shl 6);
  D3DVIS_OUTSIDE_TOP         = (2 shl 6);
  D3DVIS_INSIDE_BOTTOM       = 0;
  D3DVIS_INTERSECT_BOTTOM    = (1 shl 8);
  D3DVIS_OUTSIDE_BOTTOM      = (2 shl 8);
  D3DVIS_INSIDE_NEAR         = 0;
  D3DVIS_INTERSECT_NEAR      = (1 shl 10);
  D3DVIS_OUTSIDE_NEAR        = (2 shl 10);
  D3DVIS_INSIDE_FAR          = 0;
  D3DVIS_INTERSECT_FAR       = (1 shl 12);
  D3DVIS_OUTSIDE_FAR         = (2 shl 12);

  D3DVIS_MASK_FRUSTUM        = (3 shl 0);
  D3DVIS_MASK_LEFT           = (3 shl 2);
  D3DVIS_MASK_RIGHT          = (3 shl 4);
  D3DVIS_MASK_TOP            = (3 shl 6);
  D3DVIS_MASK_BOTTOM         = (3 shl 8);
  D3DVIS_MASK_NEAR           = (3 shl 10);
  D3DVIS_MASK_FAR            = (3 shl 12);
  
(******************************************************************************)
(**                                                                          **)
(** D3DCaps.Pas                                                              **)
(**                                                                          **)
(******************************************************************************)

type
  TD3DTransformCaps = packed record
    dwSize: DWORD;
    dwCaps: DWORD;
  end;

const
  D3DTRANSFORMCAPS_CLIP         = $00000001; (* Will clip whilst transforming *)

(* Description of capabilities of lighting *)

type
  TD3DLightingCaps = packed record
    dwSize: DWORD;
    dwCaps: DWORD;                   (* Lighting caps *)
    dwLightingModel: DWORD;          (* Lighting model - RGB or mono *)
    dwNumLights: DWORD;              (* Number of lights that can be handled *)
  end;

const
  D3DLIGHTINGMODEL_RGB            = $00000001;
  D3DLIGHTINGMODEL_MONO           = $00000002;

  D3DLIGHTCAPS_POINT              = $00000001; (* Point lights supported *)
  D3DLIGHTCAPS_SPOT               = $00000002; (* Spot lights supported *)
  D3DLIGHTCAPS_DIRECTIONAL        = $00000004; (* Directional lights supported *)
  D3DLIGHTCAPS_PARALLELPOINT      = $00000008; (* Parallel point lights supported *)
  D3DLIGHTCAPS_GLSPOT             = $00000010; (* GL syle spot lights supported *)

(* Description of capabilities for each primitive type *)

type
  TD3DPrimCaps = packed record
    dwSize: DWORD;
    dwMiscCaps: DWORD;                 (* Capability flags *)
    dwRasterCaps: DWORD;
    dwZCmpCaps: DWORD;
    dwSrcBlendCaps: DWORD;
    dwDestBlendCaps: DWORD;
    dwAlphaCmpCaps: DWORD;
    dwShadeCaps: DWORD;
    dwTextureCaps: DWORD;
    dwTextureFilterCaps: DWORD;
    dwTextureBlendCaps: DWORD;
    dwTextureAddressCaps: DWORD;
    dwStippleWidth: DWORD;             (* maximum width and height of *)
    dwStippleHeight: DWORD;            (* of supported stipple (up to 32x32) *)
  end;

const
(* TD3DPrimCaps dwMiscCaps *)

  D3DPMISCCAPS_MASKPLANES         = $00000001;
  D3DPMISCCAPS_MASKZ              = $00000002;
  D3DPMISCCAPS_LINEPATTERNREP     = $00000004;
  D3DPMISCCAPS_CONFORMANT         = $00000008;
  D3DPMISCCAPS_CULLNONE           = $00000010;
  D3DPMISCCAPS_CULLCW             = $00000020;
  D3DPMISCCAPS_CULLCCW            = $00000040;

(* TD3DPrimCaps dwRasterCaps *)

  D3DPRASTERCAPS_DITHER           = $00000001;
  D3DPRASTERCAPS_ROP2             = $00000002;
  D3DPRASTERCAPS_XOR              = $00000004;
  D3DPRASTERCAPS_PAT              = $00000008;
  D3DPRASTERCAPS_ZTEST            = $00000010;
  D3DPRASTERCAPS_SUBPIXEL         = $00000020;
  D3DPRASTERCAPS_SUBPIXELX        = $00000040;
  D3DPRASTERCAPS_FOGVERTEX        = $00000080;
  D3DPRASTERCAPS_FOGTABLE         = $00000100;
  D3DPRASTERCAPS_STIPPLE          = $00000200;
  D3DPRASTERCAPS_ANTIALIASSORTDEPENDENT   = $00000400;
  D3DPRASTERCAPS_ANTIALIASSORTINDEPENDENT = $00000800;
  D3DPRASTERCAPS_ANTIALIASEDGES           = $00001000;
  D3DPRASTERCAPS_MIPMAPLODBIAS            = $00002000;
  D3DPRASTERCAPS_ZBIAS                    = $00004000;
  D3DPRASTERCAPS_ZBUFFERLESSHSR           = $00008000;
  D3DPRASTERCAPS_FOGRANGE                 = $00010000;
  D3DPRASTERCAPS_ANISOTROPY               = $00020000;
  D3DPRASTERCAPS_WBUFFER                      = $00040000;
  D3DPRASTERCAPS_TRANSLUCENTSORTINDEPENDENT   = $00080000;
  D3DPRASTERCAPS_WFOG                         = $00100000;

(* TD3DPrimCaps dwZCmpCaps, dwAlphaCmpCaps *)

const
  D3DPCMPCAPS_NEVER               = $00000001;
  D3DPCMPCAPS_LESS                = $00000002;
  D3DPCMPCAPS_EQUAL               = $00000004;
  D3DPCMPCAPS_LESSEQUAL           = $00000008;
  D3DPCMPCAPS_GREATER             = $00000010;
  D3DPCMPCAPS_NOTEQUAL            = $00000020;
  D3DPCMPCAPS_GREATEREQUAL        = $00000040;
  D3DPCMPCAPS_ALWAYS              = $00000080;

(* TD3DPrimCaps dwSourceBlendCaps, dwDestBlendCaps *)

  D3DPBLENDCAPS_ZERO              = $00000001;
  D3DPBLENDCAPS_ONE               = $00000002;
  D3DPBLENDCAPS_SRCCOLOR          = $00000004;
  D3DPBLENDCAPS_INVSRCCOLOR       = $00000008;
  D3DPBLENDCAPS_SRCALPHA          = $00000010;
  D3DPBLENDCAPS_INVSRCALPHA       = $00000020;
  D3DPBLENDCAPS_DESTALPHA         = $00000040;
  D3DPBLENDCAPS_INVDESTALPHA      = $00000080;
  D3DPBLENDCAPS_DESTCOLOR         = $00000100;
  D3DPBLENDCAPS_INVDESTCOLOR      = $00000200;
  D3DPBLENDCAPS_SRCALPHASAT       = $00000400;
  D3DPBLENDCAPS_BOTHSRCALPHA      = $00000800;
  D3DPBLENDCAPS_BOTHINVSRCALPHA   = $00001000;

(* TD3DPrimCaps dwShadeCaps *)

  D3DPSHADECAPS_COLORFLATMONO             = $00000001;
  D3DPSHADECAPS_COLORFLATRGB              = $00000002;
  D3DPSHADECAPS_COLORGOURAUDMONO          = $00000004;
  D3DPSHADECAPS_COLORGOURAUDRGB           = $00000008;
  D3DPSHADECAPS_COLORPHONGMONO            = $00000010;
  D3DPSHADECAPS_COLORPHONGRGB             = $00000020;

  D3DPSHADECAPS_SPECULARFLATMONO          = $00000040;
  D3DPSHADECAPS_SPECULARFLATRGB           = $00000080;
  D3DPSHADECAPS_SPECULARGOURAUDMONO       = $00000100;
  D3DPSHADECAPS_SPECULARGOURAUDRGB        = $00000200;
  D3DPSHADECAPS_SPECULARPHONGMONO         = $00000400;
  D3DPSHADECAPS_SPECULARPHONGRGB          = $00000800;

  D3DPSHADECAPS_ALPHAFLATBLEND            = $00001000;
  D3DPSHADECAPS_ALPHAFLATSTIPPLED         = $00002000;
  D3DPSHADECAPS_ALPHAGOURAUDBLEND         = $00004000;
  D3DPSHADECAPS_ALPHAGOURAUDSTIPPLED      = $00008000;
  D3DPSHADECAPS_ALPHAPHONGBLEND           = $00010000;
  D3DPSHADECAPS_ALPHAPHONGSTIPPLED        = $00020000;

  D3DPSHADECAPS_FOGFLAT                   = $00040000;
  D3DPSHADECAPS_FOGGOURAUD                = $00080000;
  D3DPSHADECAPS_FOGPHONG                  = $00100000;

(* TD3DPrimCaps dwTextureCaps *)

(*
 * Perspective-correct texturing is supported
 *)
  D3DPTEXTURECAPS_PERSPECTIVE     = $00000001;

(*
 * Power-of-2 texture dimensions are required
 *)
  D3DPTEXTURECAPS_POW2            = $00000002;

(*
 * Alpha in texture pixels is supported
 *)
  D3DPTEXTURECAPS_ALPHA           = $00000004;

(*
 * Color-keyed textures are supported
 *)
  D3DPTEXTURECAPS_TRANSPARENCY    = $00000008;

(*
 * obsolete, see D3DPTADDRESSCAPS_BORDER
 *)
  D3DPTEXTURECAPS_BORDER          = $00000010;

(*
 * Only square textures are supported
 *)
  D3DPTEXTURECAPS_SQUAREONLY      = $00000020;

(*
 * Texture indices are not scaled by the texture size prior
 * to interpolation.
 *)
  D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE = $00000040;

(*
 * Device can draw alpha from texture palettes
 *)
  D3DPTEXTURECAPS_ALPHAPALETTE    = $00000080;

(* TD3DPrimCaps dwTextureFilterCaps *)

  D3DPTFILTERCAPS_NEAREST         = $00000001;
  D3DPTFILTERCAPS_LINEAR          = $00000002;
  D3DPTFILTERCAPS_MIPNEAREST      = $00000004;
  D3DPTFILTERCAPS_MIPLINEAR       = $00000008;
  D3DPTFILTERCAPS_LINEARMIPNEAREST = $00000010;
  D3DPTFILTERCAPS_LINEARMIPLINEAR = $00000020;

(* Device3 Min Filter *)
  D3DPTFILTERCAPS_MINFPOINT       = $00000100;
  D3DPTFILTERCAPS_MINFLINEAR      = $00000200;
  D3DPTFILTERCAPS_MINFANISOTROPIC = $00000400;

(* Device3 Mip Filter *)
  D3DPTFILTERCAPS_MIPFPOINT       = $00010000;
  D3DPTFILTERCAPS_MIPFLINEAR      = $00020000;

(* Device3 Mag Filter *)
  D3DPTFILTERCAPS_MAGFPOINT         = $01000000;
  D3DPTFILTERCAPS_MAGFLINEAR        = $02000000;
  D3DPTFILTERCAPS_MAGFANISOTROPIC   = $04000000;
  D3DPTFILTERCAPS_MAGFAFLATCUBIC    = $08000000;
  D3DPTFILTERCAPS_MAGFGAUSSIANCUBIC = $10000000;

(* TD3DPrimCaps dwTextureBlendCaps *)

  D3DPTBLENDCAPS_DECAL            = $00000001;
  D3DPTBLENDCAPS_MODULATE         = $00000002;
  D3DPTBLENDCAPS_DECALALPHA       = $00000004;
  D3DPTBLENDCAPS_MODULATEALPHA    = $00000008;
  D3DPTBLENDCAPS_DECALMASK        = $00000010;
  D3DPTBLENDCAPS_MODULATEMASK     = $00000020;
  D3DPTBLENDCAPS_COPY             = $00000040;
  D3DPTBLENDCAPS_ADD		  = $00000080;

(* TD3DPrimCaps dwTextureAddressCaps *)
  D3DPTADDRESSCAPS_WRAP           = $00000001;
  D3DPTADDRESSCAPS_MIRROR         = $00000002;
  D3DPTADDRESSCAPS_CLAMP          = $00000004;
  D3DPTADDRESSCAPS_BORDER         = $00000008;
  D3DPTADDRESSCAPS_INDEPENDENTUV  = $00000010;

(* D3DDEVICEDESC dwStencilCaps *)

  D3DSTENCILCAPS_KEEP     = $00000001;
  D3DSTENCILCAPS_ZERO     = $00000002;
  D3DSTENCILCAPS_REPLACE  = $00000004;
  D3DSTENCILCAPS_INCRSAT  = $00000008;
  D3DSTENCILCAPS_DECRSAT  = $00000010;
  D3DSTENCILCAPS_INVERT   = $00000020;
  D3DSTENCILCAPS_INCR     = $00000040;
  D3DSTENCILCAPS_DECR     = $00000080;

(* D3DDEVICEDESC dwTextureOpCaps *)

  D3DTEXOPCAPS_DISABLE                    = $00000001;
  D3DTEXOPCAPS_SELECTARG1                 = $00000002;
  D3DTEXOPCAPS_SELECTARG2                 = $00000004;
  D3DTEXOPCAPS_MODULATE                   = $00000008;
  D3DTEXOPCAPS_MODULATE2X                 = $00000010;
  D3DTEXOPCAPS_MODULATE4X                 = $00000020;
  D3DTEXOPCAPS_ADD                        = $00000040;
  D3DTEXOPCAPS_ADDSIGNED                  = $00000080;
  D3DTEXOPCAPS_ADDSIGNED2X                = $00000100;
  D3DTEXOPCAPS_SUBTRACT                   = $00000200;
  D3DTEXOPCAPS_ADDSMOOTH                  = $00000400;
  D3DTEXOPCAPS_BLENDDIFFUSEALPHA          = $00000800;
  D3DTEXOPCAPS_BLENDTEXTUREALPHA          = $00001000;
  D3DTEXOPCAPS_BLENDFACTORALPHA           = $00002000;
  D3DTEXOPCAPS_BLENDTEXTUREALPHAPM        = $00004000;
  D3DTEXOPCAPS_BLENDCURRENTALPHA          = $00008000;
  D3DTEXOPCAPS_PREMODULATE                = $00010000;
  D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR     = $00020000;
  D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA     = $00040000;
  D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR  = $00080000;
  D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA  = $00100000;
  D3DTEXOPCAPS_BUMPENVMAP                 = $00200000;
  D3DTEXOPCAPS_BUMPENVMAPLUMINANCE        = $00400000;
  D3DTEXOPCAPS_DOTPRODUCT3                = $00800000;

(* D3DDEVICEDESC dwFVFCaps flags *)

  D3DFVFCAPS_TEXCOORDCOUNTMASK    = $0000ffff; (* mask for texture coordinate count field *)
  D3DFVFCAPS_DONOTSTRIPELEMENTS   = $00080000; (* Device prefers that vertex elements not be stripped *)

(*
 * Description for a device.
 * This is used to describe a device that is to be created or to query
 * the current device.
 *)

type
  PD3DDeviceDesc = ^TD3DDeviceDesc;
  TD3DDeviceDesc = packed record
    dwSize: DWORD;                       (* Size of TD3DDeviceDesc structure *)
    dwFlags: DWORD;                      (* Indicates which fields have valid data *)
    dcmColorModel: TD3DColorModel;        (* Color model of device *)
    dwDevCaps: DWORD;                    (* Capabilities of device *)
    dtcTransformCaps: TD3DTransformCaps;  (* Capabilities of transform *)
    bClipping: BOOL;                     (* Device can do 3D clipping *)
    dlcLightingCaps: TD3DLightingCaps;    (* Capabilities of lighting *)
    dpcLineCaps: TD3DPrimCaps;
    dpcTriCaps: TD3DPrimCaps;
    dwDeviceRenderBitDepth: DWORD;       (* One of DDBB_8, 16, etc.. *)
    dwDeviceZBufferBitDepth: DWORD;      (* One of DDBD_16, 32, etc.. *)
    dwMaxBufferSize: DWORD;              (* Maximum execute buffer size *)
    dwMaxVertexCount: DWORD;             (* Maximum vertex count *)
    // *** New fields for DX5 *** //

    // Width and height caps are 0 for legacy HALs.
    dwMinTextureWidth, dwMinTextureHeight  : DWORD;
    dwMaxTextureWidth, dwMaxTextureHeight  : DWORD;
    dwMinStippleWidth, dwMaxStippleWidth   : DWORD;
    dwMinStippleHeight, dwMaxStippleHeight : DWORD;

    // New fields for DX6
    dwMaxTextureRepeat : DWORD;
    dwMaxTextureAspectRatio : DWORD;
    dwMaxAnisotropy : DWORD;

    // Guard band that the rasterizer can accommodate
    // Screen-space vertices inside this space but outside the viewport
    // will get clipped properly.
    dvGuardBandLeft : TD3DValue;
    dvGuardBandTop : TD3DValue;
    dvGuardBandRight : TD3DValue;
    dvGuardBandBottom : TD3DValue;

    dvExtentsAdjust : TD3DValue;
    dwStencilCaps : DWORD;

    dwFVFCaps : DWORD;  (* low 4 bits: 0 implies TLVERTEX only, 1..8 imply FVF aware *)
    dwTextureOpCaps : DWORD;
    wMaxTextureBlendStages : WORD;
    wMaxSimultaneousTextures : WORD;

  end;

const
  D3DDEVICEDESCSIZE = sizeof(TD3DDeviceDesc);

type
  TD3DEnumDevicesCallbackA = function (var lpGuid: TGUID;
      lpDeviceDescription: PAnsiChar; lpDeviceName: PAnsiChar;
      var lpD3DHWDeviceDesc: TD3DDeviceDesc;
      var lpD3DHELDeviceDesc: TD3DDeviceDesc;
      lpContext : pointer) : HResult; StdCall;
  TD3DEnumDevicesCallback = TD3DEnumDevicesCallbackA;

(* TD3DDeviceDesc dwFlags indicating valid fields *)

const
  D3DDD_COLORMODEL            = $00000001; (* dcmColorModel is valid *)
  D3DDD_DEVCAPS               = $00000002; (* dwDevCaps is valid *)
  D3DDD_TRANSFORMCAPS         = $00000004; (* dtcTransformCaps is valid *)
  D3DDD_LIGHTINGCAPS          = $00000008; (* dlcLightingCaps is valid *)
  D3DDD_BCLIPPING             = $00000010; (* bClipping is valid *)
  D3DDD_LINECAPS              = $00000020; (* dpcLineCaps is valid *)
  D3DDD_TRICAPS               = $00000040; (* dpcTriCaps is valid *)
  D3DDD_DEVICERENDERBITDEPTH  = $00000080; (* dwDeviceRenderBitDepth is valid *)
  D3DDD_DEVICEZBUFFERBITDEPTH = $00000100; (* dwDeviceZBufferBitDepth is valid *)
  D3DDD_MAXBUFFERSIZE         = $00000200; (* dwMaxBufferSize is valid *)
  D3DDD_MAXVERTEXCOUNT        = $00000400; (* dwMaxVertexCount is valid *)

(* TD3DDeviceDesc dwDevCaps flags *)

  D3DDEVCAPS_FLOATTLVERTEX        = $00000001; (* Device accepts floating point *)
                                                    (* for post-transform vertex data *)
  D3DDEVCAPS_SORTINCREASINGZ      = $00000002; (* Device needs data sorted for increasing Z*)
  D3DDEVCAPS_SORTDECREASINGZ      = $00000004; (* Device needs data sorted for decreasing Z*)
  D3DDEVCAPS_SORTEXACT            = $00000008; (* Device needs data sorted exactly *)

  D3DDEVCAPS_EXECUTESYSTEMMEMORY  = $00000010; (* Device can use execute buffers from system memory *)
  D3DDEVCAPS_EXECUTEVIDEOMEMORY   = $00000020; (* Device can use execute buffers from video memory *)
  D3DDEVCAPS_TLVERTEXSYSTEMMEMORY = $00000040; (* Device can use TL buffers from system memory *)
  D3DDEVCAPS_TLVERTEXVIDEOMEMORY  = $00000080; (* Device can use TL buffers from video memory *)
  D3DDEVCAPS_TEXTURESYSTEMMEMORY  = $00000100; (* Device can texture from system memory *)
  D3DDEVCAPS_TEXTUREVIDEOMEMORY   = $00000200; (* Device can texture from device memory *)
  D3DDEVCAPS_DRAWPRIMTLVERTEX     = $00000400; (* Device can draw TLVERTEX primitives *)
  D3DDEVCAPS_CANRENDERAFTERFLIP	  = $00000800; (* Device can render without waiting for flip to complete *)
  D3DDEVCAPS_TEXTURENONLOCALVIDMEM = $00001000; (* Device can texture from nonlocal video memory *)
  D3DDEVCAPS_DRAWPRIMITIVES2 = $00002000; (* Device can support DrawPrimitives2 *)
  D3DDEVCAPS_SEPARATETEXTUREMEMORIES = $00004000; (* Device is texturing from separate memory pools *)

  D3DFDS_COLORMODEL        = $00000001; (* Match color model *)
  D3DFDS_GUID              = $00000002; (* Match guid *)
  D3DFDS_HARDWARE          = $00000004; (* Match hardware/software *)
  D3DFDS_TRIANGLES         = $00000008; (* Match in triCaps *)
  D3DFDS_LINES             = $00000010; (* Match in lineCaps  *)
  D3DFDS_MISCCAPS          = $00000020; (* Match primCaps.dwMiscCaps *)
  D3DFDS_RASTERCAPS        = $00000040; (* Match primCaps.dwRasterCaps *)
  D3DFDS_ZCMPCAPS          = $00000080; (* Match primCaps.dwZCmpCaps *)
  D3DFDS_ALPHACMPCAPS      = $00000100; (* Match primCaps.dwAlphaCmpCaps *)
  D3DFDS_SRCBLENDCAPS      = $00000200; (* Match primCaps.dwSourceBlendCaps *)
  D3DFDS_DSTBLENDCAPS      = $00000400; (* Match primCaps.dwDestBlendCaps *)
  D3DFDS_SHADECAPS         = $00000800; (* Match primCaps.dwShadeCaps *)
  D3DFDS_TEXTURECAPS       = $00001000; (* Match primCaps.dwTextureCaps *)
  D3DFDS_TEXTUREFILTERCAPS = $00002000; (* Match primCaps.dwTextureFilterCaps *)
  D3DFDS_TEXTUREBLENDCAPS  = $00004000; (* Match primCaps.dwTextureBlendCaps *)
  D3DFDS_TEXTUREADDRESSCAPS  = $00008000; (* Match primCaps.dwTextureBlendCaps *)

(*
 * FindDevice arguments
 *)
type
  TD3DFindDeviceSearch = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    bHardware: BOOL;
    dcmColorModel: TD3DColorModel;
    guid: TGUID;
    dwCaps: DWORD;
    dpcPrimCaps: TD3DPrimCaps;
  end;

  TD3DFindDeviceResult = packed record
    dwSize: DWORD;
    guid: TGUID;               (* guid which matched *)
    ddHwDesc: TD3DDeviceDesc;   (* hardware TD3DDeviceDesc *)
    ddSwDesc: TD3DDeviceDesc;   (* software TD3DDeviceDesc *)
  end;

(*
 * Description of execute buffer.
 *)
  TD3DExecuteBufferDesc = packed record
    dwSize: DWORD;         (* size of this structure *)
    dwFlags: DWORD;        (* flags indicating which fields are valid *)
    dwCaps: DWORD;         (* capabilities of execute buffer *)
    dwBufferSize: DWORD;   (* size of execute buffer data *)
    lpData: Pointer;       (* pointer to actual data *)
  end;

(* D3DEXECUTEBUFFER dwFlags indicating valid fields *)

const
  D3DDEB_BUFSIZE          = $00000001;     (* buffer size valid *)
  D3DDEB_CAPS             = $00000002;     (* caps valid *)
  D3DDEB_LPDATA           = $00000004;     (* lpData valid *)

(* D3DEXECUTEBUFFER dwCaps *)

  D3DDEBCAPS_SYSTEMMEMORY = $00000001;     (* buffer in system memory *)
  D3DDEBCAPS_VIDEOMEMORY  = $00000002;     (* buffer in device memory *)
  D3DDEBCAPS_MEM          = (D3DDEBCAPS_SYSTEMMEMORY or D3DDEBCAPS_VIDEOMEMORY);

(******************************************************************************)
(**                                                                          **)
(** D3D.Pas                                                                  **)
(**                                                                          **)
(******************************************************************************)

{
 The methods Begin and End from the Interface IDirect3DDevice2
 have been renamed to Begin_ and End_ to fit the Pascal-Syntax !
 use IDirect3DDevice2.Begin_
 and IDirect3DDevice2.End_
}

(*
 * Interface IID's
 *)

const
  IID_IDirect3D           : TGUID = (D1:$3BBA0080;D2:$2421;D3:$11CF;D4:($A3,$1A,$00,$AA,$00,$B9,$33,$56));
  IID_IDirect3D2          : TGUID = (D1:$6aae1ec1;D2:$662a;D3:$11d0;D4:($88,$9d,$00,$aa,$00,$bb,$b7,$6a));
  IID_IDirect3D3          : TGUID = (D1:$bb223240;D2:$e72b;D3:$11d0;D4:($a9,$b4,$00,$aa,$00,$c0,$99,$3e));
  IID_IDirect3DRampDevice : TGUID = (D1:$F2086B20;D2:$259F;D3:$11CF;D4:($A3,$1A,$00,$AA,$00,$B9,$33,$56));
  IID_IDirect3DRGBDevice  : TGUID = (D1:$A4665C60;D2:$2673;D3:$11CF;D4:($A3,$1A,$00,$AA,$00,$B9,$33,$56));
  IID_IDirect3DHALDevice  : TGUID = (D1:$84E63dE0;D2:$46AA;D3:$11CF;D4:($81,$6F,$00,$00,$C0,$20,$15,$6E));
  IID_IDirect3DMMXDevice  : TGUID = (D1:$881949a1;D2:$d6f3;D3:$11d0;D4:($89,$ab,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DRefDevice  : TGUID = (D1:$50936643;D2:$13e9;D3:$11d1;D4:($89,$aa,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DNullDevice : TGUID = (D1:$8767df22;D2:$bacc;D3:$11d1;D4:($89,$69,$00,$a0,$c9,$06,$29,$a8));

(*
 * Internal Guid to distinguish requested MMX from MMX being used as an RGB rasterizer
 *)

  IID_IDirect3DDevice   : TGUID =      (D1:$64108800;D2:$957d;D3:$11d0;D4:($89,$ab,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DDevice2  : TGUID =      (D1:$93281501;D2:$8cf8;D3:$11d0;D4:($89,$ab,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DDevice3       : TGUID =      (D1:$b0ab3b60;D2:$33d7;D3:$11d1;D4:($a9,$81,$00,$c0,$4f,$d7,$b1,$74));

  IID_IDirect3DTexture: TGUID =      (D1:$2CDCD9E0;D2:$25A0;D3:$11CF;D4:($A3,$1A,$00,$AA,$00,$B9,$33,$56));
  IID_IDirect3DTexture2: TGUID =      (D1:$93281502;D2:$8cf8;D3:$11d0;D4:($89,$ab,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DLight: TGUID =      (D1:$4417C142;D2:$33AD;D3:$11CF;D4:($81,$6F,$00,$00,$C0,$20,$15,$6E));
  IID_IDirect3DMaterial: TGUID =      (D1:$4417C144;D2:$33AD;D3:$11CF;D4:($81,$6F,$00,$00,$C0,$20,$15,$6E));
  IID_IDirect3DMaterial2: TGUID =      (D1:$93281503;D2:$8cf8;D3:$11d0;D4:($89,$ab,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DMaterial3: TGUID =      (D1:$ca9c46f4;D2:$d3c5;D3:$11d1;D4:($b7,$5a,$00,$60,$08,$52,$b3,$12));
  IID_IDirect3DExecuteBuffer : TGUID =        (D1:$4417C145;D2:$33AD;D3:$11CF;D4:($81,$6F,$00,$00,$C0,$20,$15,$6E));
  IID_IDirect3DViewport      : TGUID =             (D1:$4417C146;D2:$33AD;D3:$11CF;D4:($81,$6F,$00,$00,$C0,$20,$15,$6E));
  IID_IDirect3DViewport2     : TGUID =            (D1:$93281500;D2:$8cf8;D3:$11d0;D4:($89,$ab,$00,$a0,$c9,$05,$41,$29));
  IID_IDirect3DViewport3     : TGUID =            (D1:$b0ab3b61;D2:$33d7;D3:$11d1;D4:($a9,$81,$00,$c0,$4f,$d7,$b1,$74));
  IID_IDirect3DVertexBuffer  : TGUID =         (D1:$7a503555;D2:$4a83;D3:$11d1;D4:($a5,$db,$00,$a0,$c9,$03,$67,$f8));


type
  IDirect3D = interface;
  IDirect3D2 = interface;
  IDirect3D3 = interface;
  IDirect3DDevice = interface;
  IDirect3DDevice2 = interface;
  IDirect3DDevice3 = interface;
  IDirect3DExecuteBuffer = interface;
  IDirect3DLight = interface;
  IDirect3DMaterial = interface;
  IDirect3DMaterial2 = interface;
  IDirect3DMaterial3 = interface;
  IDirect3DTexture = interface;
  IDirect3DTexture2 = interface;
  IDirect3DViewport = interface;
  IDirect3DViewport2 = interface;
  IDirect3DViewport3 = interface;
  IDirect3DVertexBuffer = interface;

(*
 * Direct3D interfaces
 *)

  IDirect3D = interface (IUnknown)
    ['{3BBA0080-2421-11CF-A31A-00AA00B93356}']
    (*** IDirect3D methods ***)
    function Initialize (lpREFIID: {REFIID} PGUID) : HResult; StdCall;
    function EnumDevices (lpEnumDevicesCallback: TD3DEnumDevicesCallback; lpUserArg: Pointer) : HResult; StdCall;
    function CreateLight (var lplpDirect3Dlight: IDirect3DLight; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateMaterial (var lplpDirect3DMaterial: IDirect3DMaterial; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateViewport (var lplpD3DViewport: IDirect3DViewport; pUnkOuter: IUnknown) : HResult; StdCall;
    function FindDevice (var lpD3DFDS: TD3DFindDeviceSearch; var lpD3DFDR: TD3DFindDeviceResult) : HResult; StdCall;
  end;

  IDirect3D2 = interface (IUnknown)
    ['{6aae1ec1-662a-11d0-889d-00aa00bbb76a}']
    (*** IDirect3D2 methods ***)
    function EnumDevices(lpEnumDevicesCallback: TD3DEnumDevicesCallback; lpUserArg: pointer) : HResult; StdCall;
    function CreateLight (var lplpDirect3Dlight: IDirect3DLight; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateMaterial (var lplpDirect3DMaterial2: IDirect3DMaterial2; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateViewport (var lplpD3DViewport2: IDirect3DViewport2; pUnkOuter: IUnknown) : HResult; StdCall;
    function FindDevice (var lpD3DFDS: TD3DFindDeviceSearch; var lpD3DFDR: TD3DFindDeviceResult) : HResult; StdCall;
    function CreateDevice (const rclsid: TGuid; lpDDS: IDirectDrawSurface; Out lplpD3DDevice2: IDirect3DDevice2) : HResult; StdCall;
  end;

  IDirect3D3 = interface (IUnknown)
    ['{bb223240-e72b-11d0-a9b4-00aa00c0993e}']
    (*** IDirect3D3 methods ***)
    function EnumDevices(lpEnumDevicesCallback: TD3DEnumDevicesCallback; lpUserArg: pointer) : HResult; StdCall;
    function CreateLight (var lplpDirect3Dlight: IDirect3DLight; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateMaterial (var lplpDirect3DMaterial3: IDirect3DMaterial3; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateViewport (var lplpD3DViewport3: IDirect3DViewport3; pUnkOuter: IUnknown) : HResult; StdCall;
    function FindDevice (var lpD3DFDS: TD3DFindDeviceSearch; var lpD3DFDR: TD3DFindDeviceResult) : HResult; StdCall;
    function CreateDevice (const rclsid: TGuid; lpDDS: IDirectDrawSurface4; Out lplpD3DDevice: IDirect3DDevice3; pUnkOuter: IUnknown) : HResult; StdCall;
    function CreateVertexBuffer (var lpVBDesc: TD3DVertexBufferDesc; var lpD3DVertexBuffer: IDirect3DVertexBuffer; dwFlags: DWORD; pUnkOuter: IUnknown) : HResult; StdCall;
    function EnumZBufferFormats (const riidDevice: TGuid; lpEnumCallback: TD3DEnumPixelFormatsCallback; lpContext: pointer) : HResult; StdCall;
    function EvictManagedTextures : HResult; StdCall;
  end;

(*
 * Direct3D Device interfaces
 *)

  IDirect3DDevice = interface (IUnknown)
    ['{64108800-957d-11d0-89ab-00a0c9054129}']
    (*** IDirect3DDevice methods ***)
    function Initialize (lpd3d: IDirect3D; lpGUID: PGUID; var lpd3ddvdesc: TD3DDeviceDesc) : HResult; StdCall;
    function GetCaps (var lpD3DHWDevDesc: TD3DDeviceDesc; var lpD3DHELDevDesc: TD3DDeviceDesc) : HResult; StdCall;
    function SwapTextureHandles (lpD3DTex1: IDirect3DTexture; lpD3DTex2: IDirect3DTexture) : HResult; StdCall;
    function CreateExecuteBuffer (var lpDesc: TD3DExecuteBufferDesc; var lplpDirect3DExecuteBuffer: IDirect3DExecuteBuffer; pUnkOuter: IUnknown) : HResult; StdCall;
    function GetStats (var lpD3DStats: TD3DStats) : HResult; StdCall;
    function Execute (lpDirect3DExecuteBuffer: IDirect3DExecuteBuffer; lpDirect3DViewport: IDirect3DViewport; dwFlags: DWORD) : HResult; StdCall;
    function AddViewport (lpDirect3DViewport: IDirect3DViewport) : HResult; StdCall;
    function DeleteViewport (lpDirect3DViewport: IDirect3DViewport) : HResult; StdCall;
    function NextViewport (lpDirect3DViewport: IDirect3DViewport; var lplpDirect3DViewport: IDirect3DViewport; dwFlags: DWORD) : HResult; StdCall;
    function Pick (lpDirect3DExecuteBuffer: IDirect3DExecuteBuffer; lpDirect3DViewport: IDirect3DViewport; dwFlags: DWORD; var lpRect: TD3DRect) : HResult; StdCall;
    function GetPickRecords (var lpCount: DWORD; var lpD3DPickRec: TD3DPickRecord) : HResult; StdCall;
    function EnumTextureFormats (lpd3dEnumTextureProc: TD3DEnumTextureFormatsCallback; lpArg: Pointer) : HResult; StdCall;
    function CreateMatrix (var lpD3DMatHandle: TD3DMatrixHandle) : HResult; StdCall;
    function SetMatrix (d3dMatHandle: TD3DMatrixHandle; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function GetMatrix (var lpD3DMatHandle: TD3DMatrixHandle; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function DeleteMatrix (d3dMatHandle: TD3DMatrixHandle) : HResult; StdCall;
    function BeginScene: HResult;
    function EndScene: HResult;
    function GetDirect3D (var lpD3D: IDirect3D) : HResult; StdCall;
  end;

  IDirect3DDevice2 = interface (IUnknown)
    ['{93281501-8cf8-11d0-89ab-00a0c9054129}']
    (*** IDirect3DDevice2 methods ***)
    function GetCaps (var lpD3DHWDevDesc: TD3DDeviceDesc; var lpD3DHELDevDesc: TD3DDeviceDesc) : HResult; StdCall;
    function SwapTextureHandles (lpD3DTex1: IDirect3DTexture2; lpD3DTex2: IDirect3DTexture2) : HResult; StdCall;
    function GetStats (var lpD3DStats: TD3DStats) : HResult; StdCall;
    function AddViewport (lpDirect3DViewport2: IDirect3DViewport2) : HResult; StdCall;
    function DeleteViewport (lpDirect3DViewport: IDirect3DViewport2) : HResult; StdCall;
    function NextViewport (lpDirect3DViewport: IDirect3DViewport2; var lplpDirect3DViewport: IDirect3DViewport2; dwFlags: DWORD) : HResult; StdCall;
    function EnumTextureFormats (lpd3dEnumTextureProc: TD3DEnumTextureFormatsCallback; lpArg: Pointer) : HResult; StdCall;
    function BeginScene: HResult;
    function EndScene: HResult;
    function GetDirect3D (var lpD3D: IDirect3D2) : HResult; StdCall;
    (*** DrawPrimitive API ***)
    function SetCurrentViewport (lpd3dViewport2: IDirect3DViewport2) : HResult; StdCall;
    function GetCurrentViewport (var lplpd3dViewport2: IDirect3DViewport2) : HResult; StdCall;
    function SetRenderTarget (lpNewRenderTarget: IDirectDrawSurface) : HResult; StdCall;
    function GetRenderTarget (var lplpNewRenderTarget: IDirectDrawSurface) : HResult; StdCall;
    function Begin_ (d3dpt: TD3DPrimitiveType; d3dvt: TD3DVertexType; dwFlags: DWORD) : HResult; StdCall;
    function BeginIndexed (dptPrimitiveType: TD3DPrimitiveType; dvtVertexType: TD3DVertexType; lpvVertices: pointer; dwNumVertices: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function Vertex (lpVertexType: pointer) : HResult; StdCall;
    function Index (wVertexIndex: WORD) : HResult; StdCall;
    function End_ (dwFlags: DWORD) : HResult; StdCall;
    function GetRenderState (dwRenderStateType: TD3DRenderStateType; var lpdwRenderState) : HResult; StdCall;
    function SetRenderState (dwRenderStateType: TD3DRenderStateType; dwRenderState: DWORD) : HResult; StdCall;
    function GetLightState (dwLightStateType: TD3DLightStateType; var lpdwLightState) : HResult; StdCall;
    function SetLightState (dwLightStateType: TD3DLightStateType; dwLightState: DWORD) : HResult; StdCall;
    function SetTransform (dtstTransformStateType: TD3DTransformStateType; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function GetTransform (dtstTransformStateType: TD3DTransformStateType; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function MultiplyTransform (dtstTransformStateType: TD3DTransformStateType; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function DrawPrimitive (dptPrimitiveType: TD3DPrimitiveType; dvtVertexType: TD3DVertexType; var lpvVertices; dwVertexCount, dwFlags: DWORD) : HResult; StdCall;
    function DrawIndexedPrimitive (dptPrimitiveType: TD3DPrimitiveType; dwVertexTypeDesc: DWORD; lpvVertices: pointer; dwVertexCount: DWORD; var lpwIndices: WORD; dwIndexCount, dwFlags: DWORD) : HResult; StdCall;
    function SetClipStatus (var lpD3DClipStatus: TD3DClipStatus) : HResult; StdCall;
    function GetClipStatus (var lpD3DClipStatus: TD3DClipStatus) : HResult; StdCall;
  end;

  IDirect3DDevice3 = interface (IUnknown)
    ['{b0ab3b60-33d7-11d1-a981-00c04fd7b174}']
    (*** IDirect3DDevice2 methods ***)
    function GetCaps (var lpD3DHWDevDesc: TD3DDeviceDesc; var lpD3DHELDevDesc: TD3DDeviceDesc) : HResult; StdCall;
    function GetStats (var lpD3DStats: TD3DStats) : HResult; StdCall;
    function AddViewport (lpDirect3DViewport: IDirect3DViewport3) : HResult; StdCall;
    function DeleteViewport (lpDirect3DViewport: IDirect3DViewport3) : HResult; StdCall;
    function NextViewport (lpDirect3DViewport: IDirect3DViewport3; var lplpAnotherViewport: IDirect3DViewport3; dwFlags: DWORD) : HResult; StdCall;
    function EnumTextureFormats (lpd3dEnumPixelProc: TD3DEnumPixelFormatsCallback; lpArg: Pointer) : HResult; StdCall;
    function BeginScene: HResult;
    function EndScene: HResult;
    function GetDirect3D (var lpD3D: IDirect3D3) : HResult; StdCall;
    function SetCurrentViewport (lpd3dViewport: IDirect3DViewport3) : HResult; StdCall;
    function GetCurrentViewport (var lplpd3dViewport: IDirect3DViewport3) : HResult; StdCall;
    function SetRenderTarget (lpNewRenderTarget: IDirectDrawSurface4) : HResult; StdCall;
    function GetRenderTarget (var lplpNewRenderTarget: IDirectDrawSurface4) : HResult; StdCall;
    function Begin_ (d3dpt: TD3DPrimitiveType; dwVertexTypeDesc: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function BeginIndexed (dptPrimitiveType: TD3DPrimitiveType; dwVertexTypeDesc: DWORD; lpvVertices: pointer; dwNumVertices: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function Vertex (lpVertex: pointer) : HResult; StdCall;
    function Index (wVertexIndex: WORD) : HResult; StdCall;
    function End_ (dwFlags: DWORD) : HResult; StdCall;
    function GetRenderState (dwRenderStateType: TD3DRenderStateType; var lpdwRenderState) : HResult; StdCall;
    function SetRenderState (dwRenderStateType: TD3DRenderStateType; dwRenderState: DWORD) : HResult; StdCall;
    function GetLightState (dwLightStateType: TD3DLightStateType; var lpdwLightState) : HResult; StdCall;
    function SetLightState (dwLightStateType: TD3DLightStateType; dwLightState: DWORD) : HResult; StdCall;
    function SetTransform (dtstTransformStateType: TD3DTransformStateType; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function GetTransform (dtstTransformStateType: TD3DTransformStateType; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function MultiplyTransform (dtstTransformStateType: TD3DTransformStateType; var lpD3DMatrix: TD3DMatrix) : HResult; StdCall;
    function DrawPrimitive (dptPrimitiveType: TD3DPrimitiveType; dwVertexTypeDesc: DWORD; const lpvVertices; dwVertexCount, dwFlags: DWORD) : HResult; StdCall;
    function DrawIndexedPrimitive (dptPrimitiveType: TD3DPrimitiveType; dwVertexTypeDesc: DWORD; const lpvVertices; dwVertexCount: DWORD; var lpwIndices: WORD; dwIndexCount, dwFlags: DWORD) : HResult; StdCall;
    function SetClipStatus (var lpD3DClipStatus: TD3DClipStatus) : HResult; StdCall;
    function GetClipStatus (var lpD3DClipStatus: TD3DClipStatus) : HResult; StdCall;
    function DrawPrimitiveStrided (dptPrimitiveType: TD3DPrimitiveType; dwVertexTypeDesc : DWORD; var lpVertexArray: TD3DDrawPrimitiveStridedData; dwVertexCount, dwFlags: DWORD) : HResult; StdCall;
    function DrawIndexedPrimitiveStrided (dptPrimitiveType: TD3DPrimitiveType; dwVertexTypeDesc : DWORD; var lpVertexArray: TD3DDrawPrimitiveStridedData; dwVertexCount: DWORD; var lpwIndices: WORD; dwIndexCount, dwFlags: DWORD) : HResult; StdCall;
    function DrawPrimitiveVB (dptPrimitiveType: TD3DPrimitiveType; lpd3dVertexBuffer: IDirect3DVertexBuffer; dwStartVertex, dwNumVertices, dwFlags: DWORD) : HResult; StdCall;
    function DrawIndexedPrimitiveVB (dptPrimitiveType: TD3DPrimitiveType; lpd3dVertexBuffer: IDirect3DVertexBuffer; var lpwIndices: WORD; dwIndexCount, dwFlags: DWORD) : HResult; StdCall;
    function ComputeSphereVisibility (var lpCenters: TD3DVector; var lpRadii: TD3DValue; dwNumSpheres, dwFlags: DWORD; var lpdwReturnValues: DWORD) : HResult; StdCall;
    function GetTexture (dwStage: DWORD; var lplpTexture: IDirect3DTexture2) : HResult; StdCall;
    function SetTexture (dwStage: DWORD; lplpTexture: IDirect3DTexture2) : HResult; StdCall;
    function GetTextureStageState (dwStage: DWORD; dwState: TD3DTextureStageStateType; var lpdwValue: DWORD) : HResult; StdCall;
    function SetTextureStageState (dwStage: DWORD; dwState: TD3DTextureStageStateType; lpdwValue: DWORD) : HResult; StdCall;
    function ValidateDevice (var lpdwExtraPasses: DWORD) : HResult; StdCall;
  end;

(*
 * Execute Buffer interface
 *)

  IDirect3DExecuteBuffer = interface (IUnknown)
    ['{4417C145-33AD-11CF-816F-0000C020156E}']
    (*** IDirect3DExecuteBuffer methods ***)
    function Initialize (lpDirect3DDevice: IDirect3DDevice; var lpDesc: TD3DExecuteBufferDesc) : HResult; StdCall;
    function Lock (var lpDesc: TD3DExecuteBufferDesc) : HResult; StdCall;
    function Unlock: HResult;
    function SetExecuteData (var lpData: TD3DExecuteData) : HResult; StdCall;
    function GetExecuteData (var lpData: TD3DExecuteData) : HResult; StdCall;
    function Validate (var lpdwOffset: DWORD; lpFunc: TD3DValidateCallback; lpUserArg: Pointer; dwReserved: DWORD) : HResult; StdCall;
    (*** Warning!  Optimize is defined differently in the header files
         and the online documentation ***)
    function Optimize (dwFlags: DWORD) : HResult; StdCall;
  end;

(*
 * Light interfaces
 *)

  IDirect3DLight = interface (IUnknown)
    ['{4417C142-33AD-11CF-816F-0000C020156E}']
    (*** IDirect3DLight methods ***)
    function Initialize (lpDirect3D: IDirect3D) : HResult; StdCall;
    function SetLight (var lpLight: TD3DLight2) : HResult; StdCall;
    function GetLight (var lpLight: TD3DLight2) : HResult; StdCall;
  end;

(*
 * Material interfaces
 *)

  IDirect3DMaterial = interface (IUnknown)
    ['{4417C144-33AD-11CF-816F-0000C020156E}']
    (*** IDirect3DMaterial methods ***)
    function Initialize (lpDirect3D: IDirect3D) : HResult; StdCall;
    function SetMaterial (var lpMat: TD3DMaterial) : HResult; StdCall;
    function GetMaterial (var lpMat: TD3DMaterial) : HResult; StdCall;
    function GetHandle (lpDirect3DDevice: IDirect3DDevice; var lpHandle: TD3DMaterialHandle) : HResult; StdCall;
    function Reserve: HResult;
    function Unreserve: HResult;
  end;

  IDirect3DMaterial2 = interface (IUnknown)
    ['{93281503-8cf8-11d0-89ab-00a0c9054129}']
    (*** IDirect3DMaterial2 methods ***)
    function SetMaterial (var lpMat: TD3DMaterial) : HResult; StdCall;
    function GetMaterial (var lpMat: TD3DMaterial) : HResult; StdCall;
    function GetHandle (lpDirect3DDevice: IDirect3DDevice2; var lpHandle: TD3DMaterialHandle) : HResult; StdCall;
  end;

  IDirect3DMaterial3 = interface (IUnknown)
    ['{ca9c46f4-d3c5-11d1-b75a-00600852b312}']
    (*** IDirect3DMaterial2 methods ***)
    function SetMaterial (var lpMat: TD3DMaterial) : HResult; StdCall;
    function GetMaterial (var lpMat: TD3DMaterial) : HResult; StdCall;
    function GetHandle (lpDirect3DDevice: IDirect3DDevice3; var lpHandle: TD3DMaterialHandle) : HResult; StdCall;
  end;

(*
 * Texture interfaces
 *)

  IDirect3DTexture = interface (IUnknown)
    ['{2CDCD9E0-25A0-11CF-A31A-00AA00B93356}']
    (*** IDirect3DTexture methods ***)
    function Initialize (lpD3DDevice: IDirect3DDevice; lpDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetHandle (lpDirect3DDevice: IDirect3DDevice; var lpHandle: TD3DTextureHandle) : HResult; StdCall;
    function PaletteChanged (dwStart: DWORD; dwCount: DWORD) : HResult; StdCall;
    function Load (lpD3DTexture: IDirect3DTexture) : HResult; StdCall;
    function Unload: HResult;
  end;

  IDirect3DTexture2 = interface (IUnknown)
    ['{93281502-8cf8-11d0-89ab-00a0c9054129}']
    (*** IDirect3DTexture2 methods ***)
    function GetHandle (lpDirect3DDevice: IDirect3DDevice2; var lpHandle: TD3DTextureHandle) : HResult; StdCall;
    function PaletteChanged (dwStart: DWORD; dwCount: DWORD) : HResult; StdCall;
    function Load (lpD3DTexture: IDirect3DTexture2) : HResult; StdCall;
  end;

(*
 * Viewport interfaces
 *)

  IDirect3DViewport = interface (IUnknown)
    ['{4417C146-33AD-11CF-816F-0000C020156E}']
    (*** IDirect3DViewport methods ***)
    function Initialize (lpDirect3D: IDirect3D) : HResult; StdCall;
    function GetViewport (Out lpData: TD3DViewport) : HResult; StdCall;
    function SetViewport (const lpData: TD3DViewport) : HResult; StdCall;
    function TransformVertices (dwVertexCount: DWORD; const lpData: TD3DTransformData; dwFlags: DWORD; Out lpOffscreen: DWORD) : HResult; StdCall;
    function LightElements (dwElementCount: DWORD; var lpData: TD3DLightData) : HResult; StdCall;
    function SetBackground (hMat: TD3DMaterialHandle) : HResult; StdCall;
    function GetBackground (OuthMat: TD3DMaterialHandle) : HResult; StdCall;
    function SetBackgroundDepth (lpDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetBackgroundDepth (Out lplpDDSurface: IDirectDrawSurface; Out lpValid: BOOL) : HResult; StdCall;
    function Clear (dwCount: DWORD; const lpRects: TD3DRect; dwFlags: DWORD) : HResult; StdCall;
    function AddLight (lpDirect3DLight: IDirect3DLight) : HResult; StdCall;
    function DeleteLight (lpDirect3DLight: IDirect3DLight) : HResult; StdCall;
    function NextLight (lpDirect3DLight: IDirect3DLight; Out lplpDirect3DLight: IDirect3DLight; dwFlags: DWORD) : HResult; StdCall;
  end;

  IDirect3DViewport2 = interface (IUnknown)
    ['{93281500-8cf8-11d0-89ab-00a0c9054129}']
    (*** IDirect3DViewport2 methods ***)
    function Initialize (lpDirect3D: IDirect3D) : HResult; StdCall;
    function GetViewport (Out lpData: TD3DViewport) : HResult; StdCall;
    function SetViewport (const lpData: TD3DViewport) : HResult; StdCall;
    function TransformVertices (dwVertexCount: DWORD; const lpData: TD3DTransformData; dwFlags: DWORD; Out lpOffscreen: DWORD) : HResult; StdCall;
    function LightElements (dwElementCount: DWORD; var lpData: TD3DLightData) : HResult; StdCall;
    function SetBackground (hMat: TD3DMaterialHandle) : HResult; StdCall;
    function GetBackground (OuthMat: TD3DMaterialHandle) : HResult; StdCall;
    function SetBackgroundDepth (lpDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetBackgroundDepth (Out lplpDDSurface: IDirectDrawSurface; Out lpValid: BOOL) : HResult; StdCall;
    function Clear (dwCount: DWORD; const lpRects: TD3DRect; dwFlags: DWORD) : HResult; StdCall;
    function AddLight (lpDirect3DLight: IDirect3DLight) : HResult; StdCall;
    function DeleteLight (lpDirect3DLight: IDirect3DLight) : HResult; StdCall;
    function NextLight (lpDirect3DLight: IDirect3DLight; Out lplpDirect3DLight: IDirect3DLight; dwFlags: DWORD) : HResult; StdCall;
    (*** IDirect3DViewport2 methods ***)
    function GetViewport2 (Out lpData: TD3DViewport2) : HResult; StdCall;
    function SetViewport2 (const lpData: TD3DViewport2) : HResult; StdCall;
  end;

  IDirect3DViewport3 = interface (IUnknown)
    ['{b0ab3b61-33d7-11d1-a981-00c04fd7b174}']
    (*** IDirect3DViewport3 methods ***)
    function Initialize (lpDirect3D: IDirect3D) : HResult; StdCall;
    function GetViewport (Out lpData: TD3DViewport) : HResult; StdCall;
    function SetViewport (const lpData: TD3DViewport) : HResult; StdCall;
    function TransformVertices (dwVertexCount: DWORD; const lpData: TD3DTransformData; dwFlags: DWORD; Out lpOffscreen: DWORD) : HResult; StdCall;
    function LightElements (dwElementCount: DWORD; var lpData: TD3DLightData) : HResult; StdCall;
    function SetBackground (hMat: TD3DMaterialHandle) : HResult; StdCall;
    function GetBackground (var hMat: TD3DMaterialHandle) : HResult; StdCall;
    function SetBackgroundDepth (lpDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetBackgroundDepth (Out lplpDDSurface: IDirectDrawSurface; Out lpValid: BOOL) : HResult; StdCall;
    function Clear (dwCount: DWORD; const lpRects: TD3DRect; dwFlags: DWORD) : HResult; StdCall;
    function AddLight (lpDirect3DLight: IDirect3DLight) : HResult; StdCall;
    function DeleteLight (lpDirect3DLight: IDirect3DLight) : HResult; StdCall;
    function NextLight (lpDirect3DLight: IDirect3DLight; Out lplpDirect3DLight: IDirect3DLight; dwFlags: DWORD) : HResult; StdCall;
    function GetViewport2 (Out lpData: TD3DViewport2) : HResult; StdCall;
    function SetViewport2 (const lpData: TD3DViewport2) : HResult; StdCall;
    function SetBackgroundDepth2 (lpDDSurface: IDirectDrawSurface4) : HResult; StdCall;
    function GetBackgroundDepth2 (Out lplpDDSurface: IDirectDrawSurface4; Out lpValid: BOOL) : HResult; StdCall;
    function Clear2 (dwCount: DWORD; const lpRects: TD3DRect; dwFlags: DWORD; dwColor: DWORD; dvZ: TD3DValue; dwStencil: DWORD) : HResult; StdCall;
  end;

  IDirect3DVertexBuffer = interface (IUnknown)
    ['{7a503555-4a83-11d1-a5db-00a0c90367f8}']
    (*** IDirect3DVertexBuffer methods ***)
    function Lock (dwFlags: DWORD; var lplpData: pointer; var lpdwSize: DWORD) : HResult; StdCall;
    function Unlock : HResult; StdCall;
    function ProcessVertices (dwVertexOp, dwDestIndex, dwCount: DWORD; lpSrcBuffer: IDirect3DVertexBuffer; dwSrcIndex: DWORD; lpD3DDevice: IDirect3DDevice3; dwFlags: DWORD) : HResult; StdCall;
    function GetVertexBufferDesc (var lpVBDesc: TD3DVertexBufferDesc) : HResult; StdCall;
    function Optimize(lpD3DDevice: IDirect3DDevice3; dwFlags: DWORD) : HResult; StdCall;
  end;



const
(****************************************************************************
 *
 * Flags for IDirect3DDevice::NextViewport
 *
 ****************************************************************************)

(*
 * Return the next viewport
 *)
  D3DNEXT_NEXT =	$00000001;

(*
 * Return the first viewport
 *)
  D3DNEXT_HEAD =	$00000002;

(*
 * Return the last viewport
 *)
  D3DNEXT_TAIL =	$00000004;


(****************************************************************************
 *
 * Flags for DrawPrimitive/DrawIndexedPrimitive
 *   Also valid for Begin/BeginIndexed
 *   Also valid for VertexBuffer::CreateVertexBuffer
 ****************************************************************************)

(*
 * Wait until the device is ready to draw the primitive
 * This will cause DP to not return DDERR_WASSTILLDRAWING
 *)
  D3DDP_WAIT =					$00000001;

(*
 * Hint that it is acceptable to render the primitive out of order.
 *)
  D3DDP_OUTOFORDER            = $00000002;

(*
 * Hint that the primitives have been clipped by the application.
 *)
  D3DDP_DONOTCLIP =				$00000004;

(*
 * Hint that the extents need not be updated.
 *)
  D3DDP_DONOTUPDATEEXTENTS =	$00000008;

(*
 * Hint that the lighting should not be applied on vertices.
 *)

  D3DDP_DONOTLIGHT            = $00000010;


(*
 * Direct3D Errors
 * DirectDraw error codes are used when errors not specified here.
 *)

const
  D3D_OK                          = DD_OK;
  D3DERR_BADMAJORVERSION          = MAKE_DDHRESULT + 700;
  D3DERR_BADMINORVERSION          = MAKE_DDHRESULT + 701;

(*
 * An invalid device was requested by the application.
 *)
  D3DERR_INVALID_DEVICE   = MAKE_DDHRESULT + 705;
  D3DERR_INITFAILED       = MAKE_DDHRESULT + 706;

(*
 * SetRenderTarget attempted on a device that was
 * QI'd off the render target.
 *)
  D3DERR_DEVICEAGGREGATED = MAKE_DDHRESULT + 707;

  D3DERR_EXECUTE_CREATE_FAILED    = MAKE_DDHRESULT + 710;
  D3DERR_EXECUTE_DESTROY_FAILED   = MAKE_DDHRESULT + 711;
  D3DERR_EXECUTE_LOCK_FAILED      = MAKE_DDHRESULT + 712;
  D3DERR_EXECUTE_UNLOCK_FAILED    = MAKE_DDHRESULT + 713;
  D3DERR_EXECUTE_LOCKED           = MAKE_DDHRESULT + 714;
  D3DERR_EXECUTE_NOT_LOCKED       = MAKE_DDHRESULT + 715;

  D3DERR_EXECUTE_FAILED           = MAKE_DDHRESULT + 716;
  D3DERR_EXECUTE_CLIPPED_FAILED   = MAKE_DDHRESULT + 717;

  D3DERR_TEXTURE_NO_SUPPORT       = MAKE_DDHRESULT + 720;
  D3DERR_TEXTURE_CREATE_FAILED    = MAKE_DDHRESULT + 721;
  D3DERR_TEXTURE_DESTROY_FAILED   = MAKE_DDHRESULT + 722;
  D3DERR_TEXTURE_LOCK_FAILED      = MAKE_DDHRESULT + 723;
  D3DERR_TEXTURE_UNLOCK_FAILED    = MAKE_DDHRESULT + 724;
  D3DERR_TEXTURE_LOAD_FAILED      = MAKE_DDHRESULT + 725;
  D3DERR_TEXTURE_SWAP_FAILED      = MAKE_DDHRESULT + 726;
  D3DERR_TEXTURE_LOCKED           = MAKE_DDHRESULT + 727;
  D3DERR_TEXTURE_NOT_LOCKED       = MAKE_DDHRESULT + 728;
  D3DERR_TEXTURE_GETSURF_FAILED   = MAKE_DDHRESULT + 729;

  D3DERR_MATRIX_CREATE_FAILED     = MAKE_DDHRESULT + 730;
  D3DERR_MATRIX_DESTROY_FAILED    = MAKE_DDHRESULT + 731;
  D3DERR_MATRIX_SETDATA_FAILED    = MAKE_DDHRESULT + 732;
  D3DERR_MATRIX_GETDATA_FAILED    = MAKE_DDHRESULT + 733;
  D3DERR_SETVIEWPORTDATA_FAILED   = MAKE_DDHRESULT + 734;

  D3DERR_INVALIDCURRENTVIEWPORT   = MAKE_DDHRESULT + 735;
  D3DERR_INVALIDPRIMITIVETYPE     = MAKE_DDHRESULT + 736;
  D3DERR_INVALIDVERTEXTYPE        = MAKE_DDHRESULT + 737;
  D3DERR_TEXTURE_BADSIZE          = MAKE_DDHRESULT + 738;
  D3DERR_INVALIDRAMPTEXTURE	  = MAKE_DDHRESULT + 739;

  D3DERR_MATERIAL_CREATE_FAILED   = MAKE_DDHRESULT + 740;
  D3DERR_MATERIAL_DESTROY_FAILED  = MAKE_DDHRESULT + 741;
  D3DERR_MATERIAL_SETDATA_FAILED  = MAKE_DDHRESULT + 742;
  D3DERR_MATERIAL_GETDATA_FAILED  = MAKE_DDHRESULT + 743;

  D3DERR_INVALIDPALETTE	          = MAKE_DDHRESULT + 744;

  D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY = MAKE_DDHRESULT + 745;
  D3DERR_ZBUFF_NEEDS_VIDEOMEMORY  = MAKE_DDHRESULT + 746;
  D3DERR_SURFACENOTINVIDMEM       = MAKE_DDHRESULT + 747;

  D3DERR_LIGHT_SET_FAILED         = MAKE_DDHRESULT + 750;
  D3DERR_LIGHTHASVIEWPORT	  = MAKE_DDHRESULT + 751;
  D3DERR_LIGHTNOTINTHISVIEWPORT   = MAKE_DDHRESULT + 752;

  D3DERR_SCENE_IN_SCENE           = MAKE_DDHRESULT + 760;
  D3DERR_SCENE_NOT_IN_SCENE       = MAKE_DDHRESULT + 761;
  D3DERR_SCENE_BEGIN_FAILED       = MAKE_DDHRESULT + 762;
  D3DERR_SCENE_END_FAILED         = MAKE_DDHRESULT + 763;

  D3DERR_INBEGIN                  = MAKE_DDHRESULT + 770;
  D3DERR_NOTINBEGIN               = MAKE_DDHRESULT + 771;
  D3DERR_NOVIEWPORTS              = MAKE_DDHRESULT + 772;
  D3DERR_VIEWPORTDATANOTSET       = MAKE_DDHRESULT + 773;
  D3DERR_VIEWPORTHASNODEVICE      = MAKE_DDHRESULT + 774;
  D3DERR_NOCURRENTVIEWPORT        = MAKE_DDHRESULT + 775;

  D3DERR_INVALIDVERTEXFORMAT      = MAKE_DDHRESULT + 2048;

(*
 * Attempted to CreateTexture on a surface that had a color key
 *)
  D3DERR_COLORKEYATTACHED                 = MAKE_DDHRESULT + 2050;

  D3DERR_VERTEXBUFFEROPTIMIZED            = MAKE_DDHRESULT + 2060;
  D3DERR_VBUF_CREATE_FAILED               = MAKE_DDHRESULT + 2061;
  D3DERR_VERTEXBUFFERLOCKED               = MAKE_DDHRESULT + 2062;

  D3DERR_ZBUFFER_NOTPRESENT               = MAKE_DDHRESULT + 2070;
  D3DERR_STENCILBUFFER_NOTPRESENT         = MAKE_DDHRESULT + 2071;

  D3DERR_WRONGTEXTUREFORMAT               = MAKE_DDHRESULT + 2072;
  D3DERR_UNSUPPORTEDCOLOROPERATION        = MAKE_DDHRESULT + 2073;
  D3DERR_UNSUPPORTEDCOLORARG              = MAKE_DDHRESULT + 2074;
  D3DERR_UNSUPPORTEDALPHAOPERATION        = MAKE_DDHRESULT + 2075;
  D3DERR_UNSUPPORTEDALPHAARG              = MAKE_DDHRESULT + 2076;
  D3DERR_TOOMANYOPERATIONS                = MAKE_DDHRESULT + 2077;
  D3DERR_CONFLICTINGTEXTUREFILTER         = MAKE_DDHRESULT + 2078;
  D3DERR_UNSUPPORTEDFACTORVALUE           = MAKE_DDHRESULT + 2079;
  D3DERR_CONFLICTINGRENDERSTATE           = MAKE_DDHRESULT + 2081;
  D3DERR_UNSUPPORTEDTEXTUREFILTER         = MAKE_DDHRESULT + 2082;
  D3DERR_TOOMANYPRIMITIVES                = MAKE_DDHRESULT + 2083;
  D3DERR_INVALIDMATRIX                    = MAKE_DDHRESULT + 2084;
  D3DERR_TOOMANYVERTICES                  = MAKE_DDHRESULT + 2085;
  D3DERR_CONFLICTINGTEXTUREPALETTE        = MAKE_DDHRESULT + 2086;

procedure DisableFPUExceptions;
procedure EnableFPUExceptions;

(******************************************************************************)
(**                                                                          **)
(** D3DRMDef.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

type
  PD3DRMVector4D = ^TD3DRMVector4D;
  TD3DRMVector4D = packed record
    x, y, z, w: TD3DValue;
  end;

  PD3DRMMatrix4D = ^TD3DRMMatrix4D;
  TD3DRMMatrix4D = array [0..3, 0..3] of TD3DValue;

  PD3DRMQuaternion = ^TD3DRMQuaternion;
  TD3DRMQuaternion = packed record
    s: TD3DValue;
    v: TD3DVector;
  end;

  PD3DRMRay = ^TD3DRMRay;
  TD3DRMRay = packed record
    dvDir: TD3DVector;
    dvPos: TD3DVector;
  end;

  PD3DRMBox = ^TD3DRMBox;
  TD3DRMBox = packed record
    min, max: TD3DVector;
  end;

  TD3DRMWrapCallback = procedure (var lpD3DVector: TD3DVector;
      var lpU, lpV: Integer; var lpD3DRMVA, lpD3DRMVB: TD3DVector; lpArg:
      Pointer); stdcall; // unused ?

  PD3DRMLightType = ^TD3DRMLightType; // is it 16 or 32 bit ?
  TD3DRMLightType = (
    D3DRMLIGHT_AMBIENT,
    D3DRMLIGHT_POINT,
    D3DRMLIGHT_SPOT,
    D3DRMLIGHT_DIRECTIONAL,
    D3DRMLIGHT_PARALLELPOINT
  );

  PD3DRMShadeMode = ^TD3DRMShadeMode;
  TD3DRMShadeMode = WORD;

const
  D3DRMSHADE_FLAT = 0;
  D3DRMSHADE_GOURAUD = 1;
  D3DRMSHADE_PHONG = 2;
  D3DRMSHADE_MASK = 7;
  D3DRMSHADE_MAX = 8;

type
  PD3DRMLightMode = ^TD3DRMLightMode;
  TD3DRMLightMode = WORD;

const
  D3DRMLIGHT_OFF  = 0 * D3DRMSHADE_MAX;
  D3DRMLIGHT_ON   = 1 * D3DRMSHADE_MAX;
  D3DRMLIGHT_MASK = 7 * D3DRMSHADE_MAX;
  D3DRMLIGHT_MAX  = 8 * D3DRMSHADE_MAX;

type
  PD3DRMFillMode = ^TD3DRMFillMode;
  TD3DRMFillMode = WORD;

const
  D3DRMFILL_POINTS    = 0 * D3DRMLIGHT_MAX;
  D3DRMFILL_WIREFRAME = 1 * D3DRMLIGHT_MAX;
  D3DRMFILL_SOLID     = 2 * D3DRMLIGHT_MAX;
  D3DRMFILL_MASK      = 7 * D3DRMLIGHT_MAX;
  D3DRMFILL_MAX       = 8 * D3DRMLIGHT_MAX;

type
  PD3DRMRenderQuality = ^TD3DRMRenderQuality;
  TD3DRMRenderQuality = DWORD;

const
  D3DRMRENDER_WIREFRAME   =
      (D3DRMSHADE_FLAT + D3DRMLIGHT_OFF + D3DRMFILL_WIREFRAME);
  D3DRMRENDER_UNLITFLAT   =
      (D3DRMSHADE_FLAT + D3DRMLIGHT_OFF + D3DRMFILL_SOLID);
  D3DRMRENDER_FLAT        =
      (D3DRMSHADE_FLAT + D3DRMLIGHT_ON + D3DRMFILL_SOLID);
  D3DRMRENDER_GOURAUD     =
      (D3DRMSHADE_GOURAUD + D3DRMLIGHT_ON + D3DRMFILL_SOLID);
  D3DRMRENDER_PHONG       =
      (D3DRMSHADE_PHONG + D3DRMLIGHT_ON + D3DRMFILL_SOLID);

  D3DRMRENDERMODE_BLENDEDTRANSPARENCY	=  1;
  D3DRMRENDERMODE_SORTEDTRANSPARENCY	=  2;
  D3DRMRENDERMODE_LIGHTINMODELSPACE     =  8;
  D3DRMRENDERMODE_VIEWDEPENDENTSPECULAR = 16;

type
  PD3DRMTextureQuality = ^TD3DRMTextureQuality;
  TD3DRMTextureQuality = (
    D3DRMTEXTURE_NEAREST,               (* choose nearest texel *)
    D3DRMTEXTURE_LINEAR,                (* interpolate 4 texels *)
    D3DRMTEXTURE_MIPNEAREST,            (* nearest texel in nearest mipmap  *)
    D3DRMTEXTURE_MIPLINEAR,             (* interpolate 2 texels from 2 mipmaps *)
    D3DRMTEXTURE_LINEARMIPNEAREST,      (* interpolate 4 texels in nearest mipmap *)
    D3DRMTEXTURE_LINEARMIPLINEAR        (* interpolate 8 texels from 2 mipmaps *)
  );

const
(*
 * Texture flags
 *)
  D3DRMTEXTURE_FORCERESIDENT          = $00000001; (* texture should be kept in video memory *)
  D3DRMTEXTURE_STATIC                 = $00000002; (* texture will not change *)
  D3DRMTEXTURE_DOWNSAMPLEPOINT        = $00000004; (* point filtering should be used when downsampling *)
  D3DRMTEXTURE_DOWNSAMPLEBILINEAR     = $00000008; (* bilinear filtering should be used when downsampling *)
  D3DRMTEXTURE_DOWNSAMPLEREDUCEDEPTH  = $00000010; (* reduce bit depth when downsampling *)
  D3DRMTEXTURE_DOWNSAMPLENONE         = $00000020; (* texture should never be downsampled *)
  D3DRMTEXTURE_CHANGEDPIXELS          = $00000040; (* pixels have changed *)
  D3DRMTEXTURE_CHANGEDPALETTE         = $00000080; (* palette has changed *)
  D3DRMTEXTURE_INVALIDATEONLY         = $00000100; (* dirty regions are invalid *)

(*
 * Shadow flags
 *)
   D3DRMSHADOW_TRUEALPHA               = $00000001; (* shadow should render without artifacts when true alpha is on *)

type
  PD3DRMCombineType = ^TD3DRMCombineType;
  TD3DRMCombineType = (
    D3DRMCOMBINE_REPLACE,
    D3DRMCOMBINE_BEFORE,
    D3DRMCOMBINE_AFTER
  );

  PD3DRMColorModel = ^TD3DRMColorModel;
  TD3DRMColorModel = TD3DColorModel;

  PD3DRMPaletteFlags = ^TD3DRMPaletteFlags;
  TD3DRMPaletteFlags = (
    D3DRMPALETTE_FREE,                  (* renderer may use this entry freely *)
    D3DRMPALETTE_READONLY,              (* fixed but may be used by renderer *)
    D3DRMPALETTE_RESERVED               (* may not be used by renderer *)
  );

  PD3DRMPaletteEntry = ^TD3DRMPaletteEntry;
  TD3DRMPaletteEntry = packed record
    red: Byte;          (* 0 .. 255 *)
    green: Byte;        (* 0 .. 255 *)
    blue: Byte;         (* 0 .. 255 *)
    flags: Byte;        (* one of D3DRMPALETTEFLAGS *)
  end;

  PD3DRMImage = ^TD3DRMImage;
  TD3DRMImage = packed record
    width, height: Integer;    (* width and height in pixels *)
    aspectx, aspecty: Integer; (* aspect ratio for non-square pixels *)
    depth: Integer;            (* bits per pixel *)
    rgb: Integer;              (* if false, pixels are indices into a
                                   palette otherwise, pixels encode
                                   RGB values. *)
    bytes_per_line: Integer;   (* number of bytes of memory for a
                                   scanline. This must be a multiple
                                   of 4. *)
    buffer1: Pointer;          (* memory to render into (first buffer). *)
    buffer2: Pointer;          (* second rendering buffer for double
                                   buffering, set to NULL for single
                                   buffering. *)
    red_mask: DWORD;
    green_mask: DWORD;
    blue_mask: DWORD;
    alpha_mask: DWORD;        (* if rgb is true, these are masks for
                                   the red, green and blue parts of a
                                   pixel.  Otherwise, these are masks
                                   for the significant bits of the
                                   red, green and blue elements in the
                                   palette.  For instance, most SVGA
                                   displays use 64 intensities of red,
                                   green and blue, so the masks should
                                   all be set to = $fc. *)
    palette_size: Integer;     (* number of entries in palette *)
    palette: PD3DRMPaletteEntry; (* description of the palette (only if
                                   rgb is false).  Must be (1<<depth)
                                   elements. *)
  end;

  PD3DRMWrapType = ^TD3DRMWrapType;
  TD3DRMWrapType = (
    D3DRMWRAP_FLAT,
    D3DRMWRAP_CYLINDER,
    D3DRMWRAP_SPHERE,
    D3DRMWRAP_CHROME,
    D3DRMWRAP_SHEET,
    D3DRMWRAP_BOX
  );

const
  D3DRMWIREFRAME_CULL             = 1; (* cull backfaces *)
  D3DRMWIREFRAME_HIDDENLINE       = 2; (* lines are obscured by closer objects *)

type
(*
 * Do not use righthanded perspective in Viewport2::SetProjection().
 * Set up righthanded mode by using IDirect3DRM3::SetOptions().
 *)
  PD3DRMProjectionType = ^TD3DRMProjectionType;
  TD3DRMProjectionType = (
    D3DRMPROJECT_PERSPECTIVE,
    D3DRMPROJECT_ORTHOGRAPHIC,
    D3DRMPROJECT_RIGHTHANDPERSPECTIVE, (* Only valid pre-DX6 *)
    D3DRMPROJECT_RIGHTHANDORTHOGRAPHIC (* Only valid pre-DX6 *)
  );

const
  D3DRMOPTIONS_LEFTHANDED  = 00000001; (* Default *)
  D3DRMOPTIONS_RIGHTHANDED = 00000002;

type
  PD3DRMXOFFormat = ^TD3DRMXOFFormat;
  TD3DRMXOFFormat = (
    D3DRMXOF_BINARY,
    D3DRMXOF_COMPRESSED,
    D3DRMXOF_TEXT
  );

  TD3DRMSaveOptions = DWORD;
const
  D3DRMXOFSAVE_NORMALS = 1;
  D3DRMXOFSAVE_TEXTURECOORDINATES = 2;
  D3DRMXOFSAVE_MATERIALS = 4;
  D3DRMXOFSAVE_TEXTURENAMES = 8;
  D3DRMXOFSAVE_ALL = 15;
  D3DRMXOFSAVE_TEMPLATES = 16;
  D3DRMXOFSAVE_TEXTURETOPOLOGY = 32;

type
  PD3DRMColorSource = ^TD3DRMColorSource;
  TD3DRMColorSource = (
    D3DRMCOLOR_FROMFACE,
    D3DRMCOLOR_FROMVERTEX
  );

  PD3DRMFrameConstraint = ^TD3DRMFrameConstraint;
  TD3DRMFrameConstraint = (
    D3DRMCONSTRAIN_Z,           (* use only X and Y rotations *)
    D3DRMCONSTRAIN_Y,           (* use only X and Z rotations *)
    D3DRMCONSTRAIN_X            (* use only Y and Z rotations *)
  );

  PD3DRMMaterialMode = ^TD3DRMMaterialMode;
  TD3DRMMaterialMode = (
    D3DRMMATERIAL_FROMMESH,
    D3DRMMATERIAL_FROMPARENT,
    D3DRMMATERIAL_FROMFRAME
  );

  PD3DRMFogMode = ^TD3DRMFogMode;
  TD3DRMFogMode = (
    D3DRMFOG_LINEAR,            (* linear between start and end *)
    D3DRMFOG_EXPONENTIAL,       (* density * exp(-distance) *)
    D3DRMFOG_EXPONENTIALSQUARED (* density * exp(-distance*distance) *)
  );

  PD3DRMZBufferMode = ^TD3DRMZBufferMode;
  TD3DRMZBufferMode = (
    D3DRMZBUFFER_FROMPARENT,    (* default *)
    D3DRMZBUFFER_ENABLE,        (* enable zbuffering *)
    D3DRMZBUFFER_DISABLE        (* disable zbuffering *)
  );

  PD3DRMSortMode = ^TD3DRMSortMode;
  TD3DRMSortMode = (
    D3DRMSORT_FROMPARENT,       (* default *)
    D3DRMSORT_NONE,             (* don't sort child frames *)
    D3DRMSORT_FRONTTOBACK,      (* sort child frames front-to-back *)
    D3DRMSORT_BACKTOFRONT       (* sort child frames back-to-front *)
  );

  TD3DRMMaterialOverride = packed record
    dwSize : DWORD;       (* Size of this structure *)
    dwFlags : DWORD;      (* Indicate which fields are valid *)
    dcDiffuse : TD3DColorValue;    (* RGBA *)
    dcAmbient : TD3DColorValue;    (* RGB *)
    dcEmissive : TD3DColorValue;   (* RGB *)
    dcSpecular : TD3DColorValue;   (* RGB *)
    dvPower : TD3DValue;
    lpD3DRMTex : IUnknown;
  end;

const
  D3DRMMATERIALOVERRIDE_DIFFUSE_ALPHAONLY     = $00000001;
  D3DRMMATERIALOVERRIDE_DIFFUSE_RGBONLY       = $00000002;
  D3DRMMATERIALOVERRIDE_DIFFUSE               = $00000003;
  D3DRMMATERIALOVERRIDE_AMBIENT               = $00000004;
  D3DRMMATERIALOVERRIDE_EMISSIVE              = $00000008;
  D3DRMMATERIALOVERRIDE_SPECULAR              = $00000010;
  D3DRMMATERIALOVERRIDE_POWER                 = $00000020;
  D3DRMMATERIALOVERRIDE_TEXTURE               = $00000040;
  D3DRMMATERIALOVERRIDE_DIFFUSE_ALPHAMULTIPLY = $00000080;
  D3DRMMATERIALOVERRIDE_ALL                   = $000000FF;

  D3DRMFPTF_ALPHA                           = $00000001;
  D3DRMFPTF_NOALPHA                         = $00000002;
  D3DRMFPTF_PALETTIZED                      = $00000004;
  D3DRMFPTF_NOTPALETTIZED                   = $00000008;

  D3DRMSTATECHANGE_UPDATEONLY               = $000000001;
  D3DRMSTATECHANGE_VOLATILE                 = $000000002;
  D3DRMSTATECHANGE_NONVOLATILE              = $000000004;
  D3DRMSTATECHANGE_RENDER                   = $000000020;
  D3DRMSTATECHANGE_LIGHT                    = $000000040;

(*
 * Values for flags in RM3::CreateDeviceFromSurface
 *)
  D3DRMDEVICE_NOZBUFFER           = $00000001;

(*
 * Values for flags in Object2::SetClientData
 *)
  D3DRMCLIENTDATA_NONE            = $00000001;
  D3DRMCLIENTDATA_LOCALFREE       = $00000002;
  D3DRMCLIENTDATA_IUNKNOWN        = $00000004;

(*
 * Values for flags in Frame2::AddMoveCallback.
 *)
  D3DRMCALLBACK_PREORDER		= 0;
  D3DRMCALLBACK_POSTORDER		= 1;

(*
 * Values for flags in MeshBuilder2::RayPick.
 *)
  D3DRMRAYPICK_ONLYBOUNDINGBOXES	= 1;
  D3DRMRAYPICK_IGNOREFURTHERPRIMITIVES	= 2;
  D3DRMRAYPICK_INTERPOLATEUV		= 4;
  D3DRMRAYPICK_INTERPOLATECOLOR		= 8;
  D3DRMRAYPICK_INTERPOLATENORMAL        = $10;

(*
 * Values for flags in MeshBuilder3::AddFacesIndexed.
 *)
  D3DRMADDFACES_VERTICESONLY             = 1;

(*
 * Values for flags in MeshBuilder2::GenerateNormals.
 *)
  D3DRMGENERATENORMALS_PRECOMPACT	= 1;
  D3DRMGENERATENORMALS_USECREASEANGLE	= 2;

(*
 * Values for MeshBuilder3::GetParentMesh
 *)
  D3DRMMESHBUILDER_DIRECTPARENT          = 1;
  D3DRMMESHBUILDER_ROOTMESH              = 2;

(*
 * Flags for MeshBuilder3::Enable
 *)
  D3DRMMESHBUILDER_RENDERENABLE   = $00000001;
  D3DRMMESHBUILDER_PICKENABLE     = $00000002;

(*
 * Flags for Object2::GetAge when used with MeshBuilders
 *)
  D3DRMMESHBUILDERAGE_GEOMETRY    = $00000001;
  D3DRMMESHBUILDERAGE_MATERIALS   = $00000002;
  D3DRMMESHBUILDERAGE_TEXTURES    = $00000004;

(*
 * Format flags for MeshBuilder3::AddTriangles.
 *)
  D3DRMFVF_TYPE                   = $00000001;
  D3DRMFVF_NORMAL                 = $00000002;
  D3DRMFVF_COLOR                  = $00000004;
  D3DRMFVF_TEXTURECOORDS          = $00000008;

  D3DRMVERTEX_STRIP               = $00000001;
  D3DRMVERTEX_FAN                 = $00000002;
  D3DRMVERTEX_LIST                = $00000004;

(*
 * Values for flags in Viewport2::Clear2
 *)
  D3DRMCLEAR_TARGET               = $00000001;
  D3DRMCLEAR_ZBUFFER              = $00000002;
  D3DRMCLEAR_DIRTYRECTS           = $00000004;
  D3DRMCLEAR_ALL                  = (D3DRMCLEAR_TARGET or
                                         D3DRMCLEAR_ZBUFFER or
                                         D3DRMCLEAR_DIRTYRECTS);

(*
 * Values for flags in Frame3::SetSceneFogMethod
 *)
  D3DRMFOGMETHOD_VERTEX          = $00000001;
  D3DRMFOGMETHOD_TABLE           = $00000002;
  D3DRMFOGMETHOD_ANY             = $00000004;

(*
 * Values for flags in Frame3::SetTraversalOptions
 *)
  D3DRMFRAME_RENDERENABLE        = $00000001;
  D3DRMFRAME_PICKENABLE          = $00000002;

type
  TD3DRMAnimationOptions = DWORD;

const
  D3DRMANIMATION_OPEN = $01;
  D3DRMANIMATION_CLOSED = $02;
  D3DRMANIMATION_LINEARPOSITION = $04;
  D3DRMANIMATION_SPLINEPOSITION = $08;
  D3DRMANIMATION_SCALEANDROTATION = $00000010;
  D3DRMANIMATION_POSITION = $00000020;

type
  TD3DRMInterpolationOptions = DWORD;
const
  D3DRMINTERPOLATION_OPEN = $01;
  D3DRMINTERPOLATION_CLOSED = $02;
  D3DRMINTERPOLATION_NEAREST = $0100;
  D3DRMINTERPOLATION_LINEAR = $04;
  D3DRMINTERPOLATION_SPLINE = $08;
  D3DRMINTERPOLATION_VERTEXCOLOR = $40;
  D3DRMINTERPOLATION_SLERPNORMALS = $80;

type
  TD3DRMLoadOptions = DWORD;

const
  D3DRMLOAD_FROMFILE  = $00;
  D3DRMLOAD_FROMRESOURCE = $01;
  D3DRMLOAD_FROMMEMORY = $02;
  D3DRMLOAD_FROMSTREAM = $04;
  D3DRMLOAD_FROMURL = $08;

  D3DRMLOAD_BYNAME = $10;
  D3DRMLOAD_BYPOSITION = $20;
  D3DRMLOAD_BYGUID = $40;
  D3DRMLOAD_FIRST = $80;

  D3DRMLOAD_INSTANCEBYREFERENCE = $100;
  D3DRMLOAD_INSTANCEBYCOPYING = $200;

  D3DRMLOAD_ASYNCHRONOUS = $400;

type
  PD3DRMLoadResource = ^TD3DRMLoadResource;
  TD3DRMLoadResource = packed record
    hModule: HMODULE;
    lpName: PAnsiChar;
    lpType: PAnsiChar;
  end;

  PD3DRMLoadMemory = ^TD3DRMLoadMemory;
  TD3DRMLoadMemory = packed record
    lpMemory: Pointer;
    dwSize: DWORD;
  end;

const
  D3DRMPMESHSTATUS_VALID = $01;
  D3DRMPMESHSTATUS_INTERRUPTED = $02;
  D3DRMPMESHSTATUS_BASEMESHCOMPLETE = $04;
  D3DRMPMESHSTATUS_COMPLETE = $08;
  D3DRMPMESHSTATUS_RENDERABLE = $10;

  D3DRMPMESHEVENT_BASEMESH = $01;
  D3DRMPMESHEVENT_COMPLETE = $02;

type
  PD3DRMPMeshLoadStatus = ^TD3DRMPMeshLoadStatus;
  TD3DRMPMeshLoadStatus = packed record
    dwSize,            // Size of this structure
    dwPMeshSize,       // Total Size (bytes)
    dwBaseMeshSize,    // Total Size of the Base Mesh
    dwBytesLoaded,     // Total bytes loaded
    dwVerticesLoaded,  // Number of vertices loaded
    dwFacesLoaded : DWORD;     // Number of faces loaded
    dwLoadResult : HResult;     // Result of the load operation
    dwFlags : DWORD;
  end;

  PD3DRMUserVisualReason = ^TD3DRMUserVisualReason;
  TD3DRMUserVisualReason = (
    D3DRMUSERVISUAL_CANSEE,
    D3DRMUSERVISUAL_RENDER
  );

  PD3DRMAnimationKey = ^TD3DRMAnimationKey;
  TD3DRMAnimationKey = packed record
    dwSize : DWORD;
    dwKeyType : DWORD;
    dvTime : TD3DValue;
    dwID : DWORD;
    case integer of
      0 : (dqRotateKey : TD3DRMQuaternion);
      1 : (dvScaleKey : TD3DVector);
      2 : (dvPositionKey : TD3DVector);
      3 : (dvK : array [0..3] of TD3DValue);
    end;

procedure D3DRMAnimationGetRotateKey(var rmKey: TD3DRMAnimationKey; var rmQuat: TD3DRMQuaternion);

procedure D3DRMAnimationGetScaleKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);

procedure D3DRMAnimationGetPositionKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);

procedure D3DRMAnimatioSetRotateKey(var rmKey: TD3DRMAnimationKey; var rmQuat: TD3DRMQuaternion);

procedure D3DRMAnimationSetScaleKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);

procedure D3DRMAnimationSetPositionKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);

const
  D3DRMANIMATION_ROTATEKEY = 01;
  D3DRMANIMATION_SCALEKEY = 02;
  D3DRMANIMATION_POSITIONKEY = 03;

type
  TD3DRMMapping = DWORD;
  PD3DRMMappingFlag = ^TD3DRMMappingFlag;
  TD3DRMMappingFlag = DWORD;

const
  D3DRMMAP_WRAPU = 1;
  D3DRMMAP_WRAPV = 2;
  D3DRMMAP_PERSPCORRECT = 4;

type
  PD3DRMVertex = ^TD3DRMVertex;
  TD3DRMVertex = packed record
    position: TD3DVector;
    normal: TD3DVector;
    tu, tv: TD3DValue;
    color: TD3DColor;
  end;

  TD3DRMGroupIndex = LongInt; (* group indexes begin a 0 *)

const
  D3DRMGROUP_ALLGROUPS = -1;

var
(*
 * Create a color from three components in the range 0-1 inclusive.
 *)
  D3DRMCreateColorRGB : function (red, green, blue: TD3DValue) : TD3DColor;
      stdcall;

(*
 * Create a color from four components in the range 0-1 inclusive.
 *)
  D3DRMCreateColorRGBA : function (red, green, blue, alpha: TD3DValue) : TD3DColor; stdcall;

(*
 * Get the red component of a color.
 *)
  D3DRMColorGetRed : function (d3drmc: TD3DColor) : TD3DValue; stdcall;

(*
 * Get the green component of a color.
 *)
  D3DRMColorGetGreen : function (d3drmc: TD3DColor) : TD3DValue; stdcall;

(*
 * Get the blue component of a color.
 *)
  D3DRMColorGetBlue : function (d3drmc: TD3DColor) : TD3DValue; stdcall;

(*
 * Get the alpha component of a color.
 *)
  D3DRMColorGetAlpha : function (d3drmc: TD3DColor) : TD3DValue; stdcall;

(*
 * Add two vectors.  Returns its first argument.
 *)
  D3DRMVectorAdd : function (var d, s1, s2: TD3DVector) : PD3DVector; stdcall;

(*
 * Subtract two vectors.  Returns its first argument.
 *)
  D3DRMVectorSubtract : function (var d, s1, s2: TD3DVector) : PD3DVector;
      stdcall;

(*
 * Reflect a ray about a given normal.  Returns its first argument.
 *)
  D3DRMVectorReflect : function (var d, ray, norm: TD3DVector) : PD3DVector;
      stdcall;

(*
 * Calculate the vector cross product.  Returns its first argument.
 *)
  D3DRMVectorCrossProduct : function (var d, s1, s2: TD3DVector) : PD3DVector;
      stdcall;

(*
 * Return the vector dot product.
 *)
  D3DRMVectorDotProduct : function (var s1, s2: TD3DVector) : TD3DValue;
      stdcall;

(*
 * Scale a vector so that its modulus is 1.  Returns its argument or
 * NULL if there was an error (e.g. a zero vector was passed).
 *)
  D3DRMVectorNormalize : function (var lpv: TD3DVector) : PD3DVector; stdcall;

(*
 * Return the length of a vector (e.g. sqrt(x*x + y*y + z*z)).
 *)
  D3DRMVectorModulus : function (var v: TD3DVector) : TD3DValue; stdcall;

(*
 * Set the rotation part of a matrix to be a rotation of theta radians
 * around the given axis.
 *)
  D3DRMVectorRotate : function (var r, v, axis: TD3DVector; theta: TD3DValue) :
      PD3DVector; stdcall;

(*
 * Scale a vector uniformly in all three axes
 *)
  D3DRMVectorScale : function (var d, s: TD3DVector; factor: TD3DValue) :
      PD3DVector; stdcall;

(*
 * Return a random unit vector
 *)
  D3DRMVectorRandom : function (var d: TD3DVector) : PD3DVector; stdcall;

(*
 * Returns a unit quaternion that represents a rotation of theta radians
 * around the given axis.
 *)

  D3DRMQuaternionFromRotation : function (var quat: TD3DRMQuaternion;
      var v: TD3DVector; theta: TD3DValue) : PD3DRMQuaternion; stdcall;

(*
 * Calculate the product of two quaternions
 *)
  D3DRMQuaternionMultiply : function (var q, a, b: TD3DRMQuaternion) :
      PD3DRMQuaternion; stdcall;

(*
 * Interpolate between two quaternions
 *)
  D3DRMQuaternionSlerp : function (var q, a, b: TD3DRMQuaternion;
      alpha: TD3DValue) : PD3DRMQuaternion; stdcall;

(*
 * Calculate the matrix for the rotation that a unit quaternion represents
 *)
  D3DRMMatrixFromQuaternion : procedure (dmMat: TD3DRMMatrix4D; var lpDqQuat:
      TD3DRMQuaternion);

(*
 * Calculate the quaternion that corresponds to a rotation matrix
 *)
  D3DRMQuaternionFromMatrix : function (var lpQuat: TD3DRMQuaternion;
      Mat: TD3DRMMatrix4D) : PD3DRMQuaternion;

(******************************************************************************)
(**                                                                          **)
(** D3DRMObj.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(*
 * Direct3DRM Object classes
 *)

const
  CLSID_CDirect3DRMDevice: TGUID =      (D1:$4fa3568e;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMViewport: TGUID =      (D1:$4fa3568f;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMFrame: TGUID =      (D1:$4fa35690;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMMesh: TGUID =      (D1:$4fa35691;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMMeshBuilder: TGUID =      (D1:$4fa35692;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMFace: TGUID =      (D1:$4fa35693;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMLight: TGUID =      (D1:$4fa35694;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMTexture: TGUID =      (D1:$4fa35695;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMWrap: TGUID =      (D1:$4fa35696;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMMaterial: TGUID =      (D1:$4fa35697;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMAnimation: TGUID =      (D1:$4fa35698;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMAnimationSet: TGUID =      (D1:$4fa35699;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMUserVisual: TGUID =      (D1:$4fa3569a;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMShadow: TGUID =      (D1:$4fa3569b;D2:$623f;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  CLSID_CDirect3DRMViewportInterpolator: TGUID =      (D1:$0de9eaa1;D2:$3b84;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMFrameInterpolator: TGUID =      (D1:$0de9eaa2;D2:$3b84;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMMeshInterpolator: TGUID =      (D1:$0de9eaa3;D2:$3b84;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMLightInterpolator: TGUID =      (D1:$0de9eaa6;D2:$3b84;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMMaterialInterpolator: TGUID =      (D1:$0de9eaa7;D2:$3b84;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMTextureInterpolator: TGUID =      (D1:$0de9eaa8;D2:$3b84;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMProgressiveMesh: TGUID =      (D1:$4516ec40;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  CLSID_CDirect3DRMClippedVisual: TGUID =      (D1:$5434e72d;D2:$6d66;D3:$11d1;D4:($bb,$0b,$00,$00,$f8,$75,$86,$5a));

(*
 * Direct3DRM Object interfaces
 *)
  IID_IDirect3DRMObject: TGUID =      (D1:$eb16cb00;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMObject2: TGUID =      (D1:$4516ec7c;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMDevice: TGUID =      (D1:$e9e19280;D2:$6e05;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMDevice2: TGUID =      (D1:$4516ec78;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMDevice3: TGUID =      (D1:$549f498b;D2:$bfeb;D3:$11d1;D4:($8e,$d8,$00,$a0,$c9,$67,$a4,$82));
  IID_IDirect3DRMViewport: TGUID =      (D1:$eb16cb02;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMViewport2: TGUID =      (D1:$4a1b1be6;D2:$bfed;D3:$11d1;D4:($8e,$d8,$00,$a0,$c9,$67,$a4,$82));
  IID_IDirect3DRMFrame: TGUID =      (D1:$eb16cb03;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMFrame2: TGUID =      (D1:$c3dfbd60;D2:$3988;D3:$11d0;D4:($9e,$c2,$00,$00,$c0,$29,$1a,$c3));
  IID_IDirect3DRMFrame3: TGUID =      (D1:$ff6b7f70;D2:$a40e;D3:$11d1;D4:($91,$f9,$00,$00,$f8,$75,$8e,$66));
  IID_IDirect3DRMVisual: TGUID =      (D1:$eb16cb04;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMMesh: TGUID =      (D1:$a3a80d01;D2:$6e12;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMMeshBuilder: TGUID =      (D1:$a3a80d02;D2:$6e12;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMMeshBuilder2: TGUID =      (D1:$4516ec77;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMMeshBuilder3: TGUID =      (D1:$ff6b7f71;D2:$a40e;D3:$11d1;D4:($91,$f9,$00,$00,$f8,$75,$8e,$66));
  IID_IDirect3DRMFace: TGUID =      (D1:$eb16cb07;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMFace2: TGUID =      (D1:$4516ec81;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMLight: TGUID =      (D1:$eb16cb08;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMTexture: TGUID =      (D1:$eb16cb09;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMTexture2: TGUID =      (D1:$120f30c0;D2:$1629;D3:$11d0;D4:($94,$1c,$00,$80,$c8,$0c,$fa,$7b));
  IID_IDirect3DRMTexture3: TGUID =      (D1:$ff6b7f73;D2:$a40e;D3:$11d1;D4:($91,$f9,$00,$00,$f8,$75,$8e,$66));
  IID_IDirect3DRMWrap: TGUID =      (D1:$eb16cb0a;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMMaterial: TGUID =      (D1:$eb16cb0b;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMMaterial2: TGUID =      (D1:$ff6b7f75;D2:$a40e;D3:$11d1;D4:($91,$f9,$00,$00,$f8,$75,$8e,$66));
  IID_IDirect3DRMAnimation: TGUID =      (D1:$eb16cb0d;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMAnimation2: TGUID =      (D1:$ff6b7f77;D2:$a40e;D3:$11d1;D4:($91,$f9,$00,$00,$f8,$75,$8e,$66));
  IID_IDirect3DRMAnimationSet: TGUID =      (D1:$eb16cb0e;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMAnimationSet2: TGUID =      (D1:$ff6b7f79;D2:$a40e;D3:$11d1;D4:($91,$f9,$00,$00,$f8,$75,$8e,$66));
  IID_IDirect3DRMObjectArray: TGUID =      (D1:$242f6bc2;D2:$3849;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMDeviceArray: TGUID =      (D1:$eb16cb10;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMViewportArray: TGUID =      (D1:$eb16cb11;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMFrameArray: TGUID =      (D1:$eb16cb12;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMVisualArray: TGUID =      (D1:$eb16cb13;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMLightArray: TGUID =      (D1:$eb16cb14;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMPickedArray: TGUID =      (D1:$eb16cb16;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMFaceArray: TGUID =      (D1:$eb16cb17;D2:$d271;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMAnimationArray: TGUID =      (D1:$d5f1cae0;D2:$4bd7;D3:$11d1;D4:($b9,$74,$00,$60,$08,$3e,$45,$f3));
  IID_IDirect3DRMUserVisual: TGUID =      (D1:$59163de0;D2:$6d43;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMShadow: TGUID =      (D1:$af359780;D2:$6ba3;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRMShadow2: TGUID =      (D1:$86b44e25;D2:$9c82;D3:$11d1;D4:($bb,$0b,$00,$a0,$c9,$81,$a0,$a6));
  IID_IDirect3DRMInterpolator: TGUID =      (D1:$242f6bc1;D2:$3849;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMProgressiveMesh: TGUID =      (D1:$4516ec79;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMPicked2Array: TGUID =      (D1:$4516ec7b;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRMClippedVisual: TGUID =      (D1:$5434e733;D2:$6d66;D3:$11d1;D4:($bb,$0b,$00,$00,$f8,$75,$86,$5a));

type
  IDirect3DRMObject = interface;
//  IDirect3DRMObject2 = interface; moved to D3DRM, to avoid circular unit reference
  IDirect3DRMDevice = interface;
  IDirect3DRMDevice2 = interface;
  IDirect3DRMDevice3 = interface;
  IDirect3DRMViewport = interface;
  IDirect3DRMViewport2 = interface;
  IDirect3DRMFrame = interface;
  IDirect3DRMFrame2 = interface;
  IDirect3DRMFrame3 = interface;
  IDirect3DRMVisual = interface;
  IDirect3DRMMesh = interface;
  IDirect3DRMMeshBuilder = interface;
  IDirect3DRMMeshBuilder2 = interface;
  IDirect3DRMMeshBuilder3 = interface;
  IDirect3DRMFace = interface;
  IDirect3DRMFace2 = interface;
  IDirect3DRMLight = interface;
  IDirect3DRMTexture = interface;
  IDirect3DRMTexture2 = interface;
  IDirect3DRMTexture3 = interface;
  IDirect3DRMWrap = interface;
  IDirect3DRMMaterial = interface;
  IDirect3DRMMaterial2 = interface;
  IDirect3DRMAnimation = interface;
  IDirect3DRMAnimation2 = interface;
  IDirect3DRMAnimationSet = interface;
  IDirect3DRMArray = interface;
  IDirect3DRMObjectArray = interface;
  IDirect3DRMDeviceArray = interface;
  IDirect3DRMViewportArray = interface;
  IDirect3DRMFrameArray = interface;
  IDirect3DRMVisualArray = interface;
  IDirect3DRMLightArray = interface;
  IDirect3DRMPickedArray = interface;
  IDirect3DRMFaceArray = interface;
  IDirect3DRMAnimationArray = interface;
  IDirect3DRMUserVisual = interface;
  IDirect3DRMShadow = interface;
  IDirect3DRMShadow2 = interface;
  IDirect3DRMInterpolator = interface;
  IDirect3DRMProgressiveMesh = interface;
  IDirect3DRMPicked2Array = interface;
  IDirect3DRMClippedVisual = interface;

  PIDirect3DRMFaceArray = ^IDirect3DRMFaceArray;

  TD3DRMObjectCallback        = procedure (lpD3DRMobj: IDirect3DRMObject; lpArg: Pointer); cdecl;
  TD3DRMFrameMoveCallback     = procedure (lpD3DRMFrame: IDirect3DRMFrame; lpArg: Pointer; delta: TD3DValue); cdecl;
  TD3DRMFrame3MoveCallback    = procedure (lpD3DRMFrame: IDirect3DRMFrame3; lpArg: Pointer; delta: TD3DValue); cdecl;
  TD3DRMUpdateCallback        = procedure (lpobj: IDirect3DRMDevice; lpArg: Pointer; iRectCount: Integer; const d3dRectUpdate: TD3DRect); cdecl;
  TD3DRMDevice3UpdateCallback = procedure (lpobj: IDirect3DRMDevice3; lpArg: Pointer; iRectCount: Integer; const d3dRectUpdate: TD3DRect);cdecl;
  TD3DRMUserVisualCallback    = function (lpD3DRMUV: IDirect3DRMUserVisual; lpArg: Pointer; lpD3DRMUVreason: TD3DRMUserVisualReason; lpD3DRMDev: IDirect3DRMDevice; lpD3DRMview: IDirect3DRMViewport) : Integer; cdecl;
  TD3DRMLoadTextureCallback   = function (tex_name: PAnsiChar; lpArg: Pointer; lpD3DRMTex: IDirect3DRMTexture) : HResult; cdecl;
  TD3DRMLoadTexture3Callback  = function (tex_name: PAnsiChar; lpArg: Pointer; lpD3DRMTex: IDirect3DRMTexture3) : HResult;cdecl;
  TD3DRMLoadCallback          = procedure (lpObject: IDirect3DRMObject; const ObjectGuid: TGUID; lpArg: Pointer); cdecl;
  TD3DRMDownSampleCallback    = function (lpDirect3DRMTexture: IDirect3DRMTexture3; pArg: pointer; pDDSSrc, pDDSDst: IDirectDrawSurface) : HResult; 
  TD3DRMValidationCallback    = function (lpDirect3DRMTexture: IDirect3DRMTexture3; pArg: pointer; dwFlags, DWcRects: DWORD; const pRects: TRect) : HResult;

  PD3DRMPickDesc = ^TD3DRMPickDesc;
  TD3DRMPickDesc = packed record
    ulFaceIdx: DWORD;
    lGroupIdx: LongInt;
    vPosition: TD3DVector;
  end;

  PD3DRMPickDesc2 = ^TD3DRMPickDesc2;
  TD3DRMPickDesc2 = packed record
    ulFaceIdx: DWORD;
    lGroupIdx: LongInt;
    dvPosition: TD3DVector;
    tu, tv: TD3DValue;
    dvNormal: TD3DVector;
    dcColor: TD3DColor;
  end;

(*
 * Base class
 *)
  IDirect3DRMObject = interface (IUnknown)
    ['{eb16cb00-d271-11ce-ac48-0000c03825a1}']
    (*
     * The methods for IDirect3DRMObject
     *)
    function Clone (pUnkOuter: IUnknown; riid: TGUID; var ppvObj: Pointer) : HResult; StdCall;
    function AddDestroyCallback (lpCallback: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function DeleteDestroyCallback (d3drmObjProc: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function SetAppData (ulData: DWORD) : HResult; StdCall;
    function GetAppData: DWORD;
    function SetName (lpName: PAnsiChar) : HResult; StdCall;
    function GetName (var lpdwSize: DWORD; lpName: PAnsiChar) : HResult; StdCall;
    function GetClassName (var lpdwSize: DWORD; lpName: PAnsiChar) : HResult; StdCall;
  end;

// IDirect3DRMObject2 moved to D3DRM, to avoid circular unit reference

  IDirect3DRMVisual = interface (IDirect3DRMObject)
  end;

  IDirect3DRMDevice = interface (IDirect3DRMObject)
    ['{e9e19280-6e05-11cf-ac4a-0000c03825a1}']
    (*
     * IDirect3DRMDevice methods
     *)
    function Init (width: LongInt; height: LongInt) : HResult; StdCall;
    function InitFromD3D (lpD3D: IDirect3D; lpD3DIMDev: IDirect3DDevice) : HResult; StdCall;
    function InitFromClipper (lpDDClipper: IDirectDrawClipper; lpGUID: PGUID; width: Integer; height: Integer) : HResult; StdCall;
    function Update: HResult; StdCall;
    function AddUpdateCallback (d3drmUpdateProc: TD3DRMUpdateCallback; arg: Pointer) : HResult; StdCall;
    function DeleteUpdateCallback (d3drmUpdateProc: TD3DRMUpdateCallback; arg: Pointer) : HResult; StdCall;
    function SetBufferCount (dwCount: DWORD) : HResult; StdCall;
    function GetBufferCount: DWORD; StdCall;
    function SetDither (bDither: BOOL) : HResult; StdCall;
    function SetShades (ulShades: DWORD) : HResult; StdCall;
    function SetQuality (rqQuality: TD3DRMRenderQuality) : HResult; StdCall;
    function SetTextureQuality (tqTextureQuality: TD3DRMTextureQuality) : HResult; StdCall;
    function GetViewports (var lplpViewports: IDirect3DRMViewportArray) : HResult; StdCall;
    function GetDither: BOOL; StdCall;
    function GetShades: DWORD; StdCall;
    function GetHeight: DWORD; StdCall;
    function GetWidth: DWORD; StdCall;
    function GetTrianglesDrawn: DWORD; StdCall;
    function GetWireframeOptions: DWORD; StdCall;
    function GetQuality: TD3DRMRenderQuality; StdCall;
    function GetColorModel: TD3DColorModel; StdCall;
    function GetTextureQuality: TD3DRMTextureQuality; StdCall;
    function GetDirect3DDevice (var lplpD3DDevice: IDirect3DDevice) : HResult; StdCall;
  end;

  IDirect3DRMDevice2 = interface (IDirect3DRMDevice)
    ['{4516ec78-8f20-11d0-9b6d-0000c0781bc3}']
    (*
     * IDirect3DRMDevice2 methods
     *)
    function InitFromD3D2(lpD3D: IDirect3D2; lpD3DIMDev: IDirect3DDevice2) : HResult; StdCall;
    function InitFromSurface(var lpGUID: TGUID; lpDD: IDirectDraw; lpDDSBack: IDirectDrawSurface) : HResult; StdCall;
    function SetRenderMode(dwFlags: DWORD ) : HResult; StdCall;
    function GetRenderMode : DWORD; StdCall;
    function GetDirect3DDevice2(var lplpD3DDevice: IDirect3DDevice2) : HResult; StdCall;
  end;

  IDirect3DRMDevice3 = interface (IDirect3DRMObject)
    ['{549f498b-bfeb-11d1-8ed8-00a0c967a482}']
    (*
     * IDirect3DRMDevice methods
     *)
    function Init (width: LongInt; height: LongInt) : HResult; StdCall;
    function InitFromD3D (lpD3D: IDirect3D2; lpD3DIMDev: IDirect3DDevice2) : HResult; StdCall;
    function InitFromClipper (lpDDClipper: IDirectDrawClipper; lpGUID: PGUID; width: Integer; height: Integer) : HResult; StdCall;
    function Update: HResult; StdCall;
    function AddUpdateCallback (d3drmUpdateProc: TD3DRMDevice3UpdateCallback; arg: Pointer) : HResult; StdCall;
    function DeleteUpdateCallback (d3drmUpdateProc: TD3DRMDevice3UpdateCallback; arg: Pointer) : HResult; StdCall;
    function SetBufferCount (dwCount: DWORD) : HResult; StdCall;
    function GetBufferCount: DWORD; StdCall;
    function SetDither (bDither: BOOL) : HResult; StdCall;
    function SetShades (ulShades: DWORD) : HResult; StdCall;
    function SetQuality (rqQuality: TD3DRMRenderQuality) : HResult; StdCall;
    function SetTextureQuality (tqTextureQuality: TD3DRMTextureQuality) : HResult; StdCall;
    function GetViewports (var lplpViewports: IDirect3DRMViewportArray) : HResult; StdCall;
    function GetDither: BOOL; StdCall;
    function GetShades: DWORD; StdCall;
    function GetHeight: DWORD; StdCall;
    function GetWidth: DWORD; StdCall;
    function GetTrianglesDrawn: DWORD; StdCall;
    function GetWireframeOptions: DWORD; StdCall;
    function GetQuality: TD3DRMRenderQuality; StdCall;
    function GetColorModel: TD3DColorModel; StdCall;
    function GetTextureQuality: TD3DRMTextureQuality; StdCall;
    function GetDirect3DDevice (var lplpD3DDevice: IDirect3DDevice) : HResult; StdCall;
    (*
     * IDirect3DRMDevice2 methods
     *)
    function InitFromD3D2(lpD3D: IDirect3D2; lpD3DIMDev: IDirect3DDevice2) : HResult; StdCall;
    function InitFromSurface(var lpGUID: TGUID; lpDD: IDirectDraw; lpDDSBack: IDirectDrawSurface) : HResult; StdCall;
    function SetRenderMode(dwFlags: DWORD ) : HResult; StdCall;
    function GetRenderMode : DWORD; StdCall;
    function GetDirect3DDevice2(var lplpD3DDevice: IDirect3DDevice2) : HResult; StdCall;
    (*
     * IDirect3DRMDevice3 methods
     *)
    function FindPreferredTextureFormat (dwBitDepths, dwFlags: DWORD; var lpDDPF: TDDPixelFormat) : HResult; StdCall;
    function RenderStateChange (dwStateNum, dwVal, dwFlags: DWORD) : HResult; StdCall;
    {!! LightStateChange is defined different in header and help !!}
    function LightStateChange (drsType: TD3DLightStateType; dwVal, dwFlags: DWORD) : HResult; StdCall;
    function GetStateChangeOptions (dwStateClass, dwStateNum: DWORD; var pdwFlags: DWORD) : HResult; StdCall;
    function SetStateChangeOptions ( dwStateClass, dwStateNum, dwFlags: DWORD) : HResult; StdCall;
  end;

  IDirect3DRMViewport = interface (IDirect3DRMObject)
    ['{eb16cb02-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMViewport methods
     *)
    function Init (lpD3DRMDevice: IDirect3DRMDevice; lpD3DRMFrameCamera: IDirect3DRMFrame; xpos, ypos, width, height: DWORD) : HResult; StdCall;
    function Clear: HResult;
    function Render (lpD3DRMFrame: IDirect3DRMFrame) : HResult; StdCall;
    function SetFront (rvFront: TD3DValue) : HResult; StdCall;
    function SetBack (rvBack: TD3DValue) : HResult; StdCall;
    function SetField (rvField: TD3DValue) : HResult; StdCall;
    function SetUniformScaling (bScale: BOOL) : HResult; StdCall;
    function SetCamera (lpCamera: IDirect3DRMFrame) : HResult; StdCall;
    function SetProjection (rptType: TD3DRMProjectionType) : HResult; StdCall;
    function Transform (var lprvDst: TD3DRMVector4D; var lprvSrc: TD3DVector) : HResult; StdCall;
    function InverseTransform (var lprvDst: TD3DVector; var lprvSrc: TD3DRMVector4D) : HResult; StdCall;
    function Configure (lX, lY: LongInt; dwWidth, dwHeight: DWORD) : HResult; StdCall;
    function ForceUpdate (dwX1, dwY1, dwX2, dwY2: DWORD) : HResult; StdCall;
    function SetPlane (rvLeft, rvRight, rvBottom, rvTop: TD3DValue) : HResult; StdCall;
    function GetCamera (var lpCamera: IDirect3DRMFrame) : HResult; StdCall;
    function GetDevice (var lpD3DRMDevice: IDirect3DRMDevice) : HResult; StdCall;
    function GetPlane (var lpd3dvLeft, lpd3dvRight, lpd3dvBottom, lpd3dvTop: TD3DValue) : HResult; StdCall;
    function Pick (lX, lY: LongInt; var lplpVisuals: IDirect3DRMPickedArray) : HResult; StdCall;
    function GetUniformScaling: BOOL;
    function GetX: LongInt;
    function GetY: LongInt;
    function GetWidth: DWORD;
    function GetHeight: DWORD;
    function GetField: TD3DValue;
    function GetBack: TD3DValue;
    function GetFront: TD3DValue;
    function GetProjection: TD3DRMProjectionType;
    function GetDirect3DViewport (var lplpD3DViewport: IDirect3DViewport) : HResult; StdCall;
  end;

  IDirect3DRMViewport2 = interface (IDirect3DRMObject)
    ['{4a1b1be6-bfed-11d1-8ed8-00a0c967a482}']
    (*
     * IDirect3DRMViewport2 methods
     *)
    function Init (lpD3DRMDevice: IDirect3DRMDevice3; lpD3DRMFrameCamera: IDirect3DRMFrame3; xpos, ypos, width, height: DWORD) : HResult; StdCall;
    function Clear (dwFlags: DWORD): HResult;
    function Render (lpD3DRMFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function SetFront (rvFront: TD3DValue) : HResult; StdCall;
    function SetBack (rvBack: TD3DValue) : HResult; StdCall;
    function SetField (rvField: TD3DValue) : HResult; StdCall;
    function SetUniformScaling (bScale: BOOL) : HResult; StdCall;
    function SetCamera (lpCamera: IDirect3DRMFrame3) : HResult; StdCall;
    function SetProjection (rptType: TD3DRMProjectionType) : HResult; StdCall;
    function Transform (var lprvDst: TD3DRMVector4D; var lprvSrc: TD3DVector) : HResult; StdCall;
    function InverseTransform (var lprvDst: TD3DVector; var lprvSrc: TD3DRMVector4D) : HResult; StdCall;
    function Configure (lX, lY: LongInt; dwWidth, dwHeight: DWORD) : HResult; StdCall;
    function ForceUpdate (dwX1, dwY1, dwX2, dwY2: DWORD) : HResult; StdCall;
    function SetPlane (rvLeft, rvRight, rvBottom, rvTop: TD3DValue) : HResult; StdCall;
    function GetCamera (var lpCamera: IDirect3DRMFrame3) : HResult; StdCall;
    function GetDevice (var lpD3DRMDevice: IDirect3DRMDevice3) : HResult; StdCall;
    function GetPlane (var lpd3dvLeft, lpd3dvRight, lpd3dvBottom, lpd3dvTop: TD3DValue) : HResult; StdCall;
    function Pick (lX, lY: LongInt; var lplpVisuals: IDirect3DRMPickedArray) : HResult; StdCall;
    function GetUniformScaling: BOOL;
    function GetX: LongInt;
    function GetY: LongInt;
    function GetWidth: DWORD;
    function GetHeight: DWORD;
    function GetField: TD3DValue;
    function GetBack: TD3DValue;
    function GetFront: TD3DValue;
    function GetProjection: TD3DRMProjectionType;
    function GetDirect3DViewport (var lplpD3DViewport: IDirect3DViewport) : HResult; StdCall;
    function TransformVectors (dwNumVectors: DWORD; var lpDstVectors: TD3DRMVector4D; var lpSrcVectors: TD3DVector) : HResult; StdCall;
    function InverseTransformVectors (dwNumVectors: DWORD; var lpDstVectors: TD3DRMVector4D; var lpSrcVectors: TD3DVector) : HResult; StdCall;
  end;

  IDirect3DRMFrame = interface (IDirect3DRMVisual)
    ['{eb16cb03-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMFrame methods
     *)
    function AddChild (lpD3DRMFrameChild: IDirect3DRMFrame) : HResult; StdCall;
    function AddLight (lpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function AddMoveCallback (d3drmFMC: TD3DRMFrameMoveCallback; lpArg: Pointer) : HResult; StdCall;
    function AddTransform (rctCombine: TD3DRMCombineType; rmMatrix: TD3DRMMatrix4D) : HResult; StdCall;
    function AddTranslation (rctCombine: TD3DRMCombineType; rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function AddScale (rctCombine: TD3DRMCombineType; rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function AddRotation (rctCombine: TD3DRMCombineType; rvX, rvY, rvZ, rvTheta: TD3DValue) : HResult; StdCall;
    function AddVisual (lpD3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
    function GetChildren (var lplpChildren: IDirect3DRMFrameArray) : HResult; StdCall;
    function GetColor: TD3DColor; StdCall;
    function GetLights (var lplpLights: IDirect3DRMLightArray) : HResult; StdCall;
    function GetMaterialMode: TD3DRMMaterialMode;
    function GetParent (var lplpParent: IDirect3DRMFrame) : HResult; StdCall;
    function GetPosition (lpRef: IDirect3DRMFrame; var lprvPos: TD3DVector) : HResult; StdCall;
    function GetRotation (lpRef: IDirect3DRMFrame; var lprvAxis: TD3DVector; var lprvTheta: TD3DValue) : HResult; StdCall;
    function GetScene (var lplpRoot: IDirect3DRMFrame) : HResult; StdCall;
    function GetSortMode: TD3DRMSortMode;
    function GetTexture (var lplpTexture: IDirect3DRMTexture) : HResult; StdCall;
    function GetTransform (var rmMatrix: TD3DRMMatrix4D) : HResult; StdCall;
    function GetVelocity (lpRef: IDirect3DRMFrame; var lprvVel: TD3DVector; fRotVel: BOOL) : HResult; StdCall;
    function GetOrientation (lpRef: IDirect3DRMFrame; var lprvDir: TD3DVector; var lprvUp: TD3DVector) : HResult; StdCall;
    function GetVisuals (var lplpVisuals: IDirect3DRMVisualArray) : HResult; StdCall;
    function GetTextureTopology (var lpU, lpV: BOOL) : HResult; StdCall;
    function InverseTransform (var lprvDst, lprvSrc: TD3DVector) : HResult; StdCall;
    function Load (lpvObjSource: Pointer; lpvObjID: Pointer; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadTextureProc: TD3DRMLoadTextureCallback; lpArgLTP: Pointer) : HResult; StdCall;
    function LookAt (lpTarget, lpRef: IDirect3DRMFrame; rfcConstraint: TD3DRMFrameConstraint ) : HResult; StdCall;
    function Move (delta: TD3DValue) : HResult; StdCall;
    function DeleteChild (lpChild: IDirect3DRMFrame) : HResult; StdCall;
    function DeleteLight (lpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function DeleteMoveCallback (d3drmFMC: TD3DRMFrameMoveCallback; lpArg: Pointer) : HResult; StdCall;
    function DeleteVisual (lpD3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
    function GetSceneBackground: TD3DColor;
    function GetSceneBackgroundDepth (var lplpDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetSceneFogColor: TD3DColor;
    function GetSceneFogEnable: BOOL;
    function GetSceneFogMode: TD3DRMFogMode;
    function GetSceneFogParams (var lprvStart, lprvEnd, lprvDensity: TD3DValue) : HResult; StdCall;
    function SetSceneBackground (rcColor: TD3DColor) : HResult; StdCall;
    function SetSceneBackgroundRGB (rvRed, rvGreen, rvBlue: TD3DValue) : HResult; StdCall;
    function SetSceneBackgroundDepth (lpImage: IDirectDrawSurface) : HResult; StdCall;
    function SetSceneBackgroundImage (lpTexture: IDirect3DRMTexture) : HResult; StdCall;
    function SetSceneFogEnable (bEnable: BOOL) : HResult; StdCall;
    function SetSceneFogColor (rcColor: TD3DColor) : HResult; StdCall;
    function SetSceneFogMode (rfMode: TD3DRMFogMode) : HResult; StdCall;
    function SetSceneFogParams (rvStart, rvEnd, rvDensity: TD3DValue) : HResult; StdCall;
    function SetColor (rcColor: TD3DColor) : HResult; StdCall;
    function SetColorRGB (rvRed, rvGreen, rvBlue: TD3DValue) : HResult; StdCall;
    function GetZbufferMode: TD3DRMZBufferMode;
    function SetMaterialMode (rmmMode: TD3DRMMaterialMode) : HResult; StdCall;
    function SetOrientation (lpRef: IDirect3DRMFrame; rvDx, rvDy, rvDz, rvUx, rvUy, rvUz: TD3DValue) : HResult; StdCall;
    function SetPosition (lpRef: IDirect3DRMFrame; rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function SetRotation (lpRef: IDirect3DRMFrame; rvX, rvY, rvZ, rvTheta: TD3DValue) : HResult; StdCall;
    function SetSortMode (d3drmSM: TD3DRMSortMode) : HResult; StdCall;
    function SetTexture (lpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function SetTextureTopology (cylU, cylV: BOOL) : HResult; StdCall;
    function SetVelocity (lpRef: IDirect3DRMFrame; rvX, rvY, rvZ: TD3DValue; fRotVel: BOOL) : HResult; StdCall;
    function SetZbufferMode (d3drmZBM: TD3DRMZBufferMode) : HResult; StdCall;
    function Transform (var lpd3dVDst, lpd3dVSrc: TD3DVector) : HResult; StdCall;
  end;

  IDirect3DRMFrame2 = interface (IDirect3DRMFrame)
    ['{c3dfbd60-3988-11d0-9ec2-0000c0291ac3}']
    (*
     * IDirect3DRMFrame2 methods
     *)
    function AddMoveCallback2 (d3drmFMC: TD3DRMFrameMoveCallback; lpArg: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function GetBoxEnable : boolean; StdCall;
    function GetAxes (var dir, up: TD3DVector) : HResult; StdCall;
    function GetMaterial (var lplpMaterial: IDirect3DRMMaterial) : HResult; StdCall;
    function GetInheritAxes : boolean; StdCall;
    function GetHierarchyBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function SetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function SetBoxEnable (bEnableFlag: BOOL) : HResult; StdCall;
    function SetAxes (dx, dy, dz, ux, uy, uz: TD3DValue) : HResult; StdCall;
    function SetInheritAxes (inherit_from_parent: BOOL) : HResult; StdCall;
    function SetMaterial (var lplpMaterial: IDirect3DRMMaterial) : HResult; StdCall;
    function SetQuaternion (lpRef: IDirect3DRMFrame; var quat: TD3DRMQuaternion) : HResult; StdCall;
    function RayPick (lpRefFrame: IDirect3DRMFrame; var ray: TD3DRMRay; dwFlags: DWORD; var lplpPicked2Array: IDirect3DRMPicked2Array) : HResult; StdCall;
    function Save (lpFilename: PAnsiChar; d3dFormat: TD3DRMXOFFormat; d3dSaveFlags: TD3DRMSaveOptions) : HResult; StdCall;
  end;

  IDirect3DRMFrame3 = interface (IDirect3DRMVisual)
    ['{ff6b7f70-a40e-11d1-91f9-0000f8758e66}']
    (*
     * IDirect3DRMFrame3 methods
     *)
    function AddChild (lpD3DRMFrameChild: IDirect3DRMFrame3) : HResult; StdCall;
    function AddLight (lpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function AddMoveCallback (d3drmFMC: TD3DRMFrame3MoveCallback; lpArg: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function AddTransform (rctCombine: TD3DRMCombineType; rmMatrix: TD3DRMMatrix4D) : HResult; StdCall;
    function AddTranslation (rctCombine: TD3DRMCombineType; rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function AddScale (rctCombine: TD3DRMCombineType; rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function AddRotation (rctCombine: TD3DRMCombineType; rvX, rvY, rvZ, rvTheta: TD3DValue) : HResult; StdCall;
    function AddVisual (lpD3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
    function GetChildren (var lplpChildren: IDirect3DRMFrameArray) : HResult; StdCall;
    function GetColor: TD3DColor; StdCall;
    function GetLights (var lplpLights: IDirect3DRMLightArray) : HResult; StdCall;
    function GetMaterialMode: TD3DRMMaterialMode; StdCall;
    function GetParent (var lplpParent: IDirect3DRMFrame3) : HResult; StdCall;
    function GetPosition (lpRef: IDirect3DRMFrame3; var lprvPos: TD3DVector) : HResult; StdCall;
    function GetRotation (lpRef: IDirect3DRMFrame3; var lprvAxis: TD3DVector; var lprvTheta: TD3DValue) : HResult; StdCall;
    function GetScene (var lplpRoot: IDirect3DRMFrame3) : HResult; StdCall;
    function GetSortMode: TD3DRMSortMode; StdCall;
    function GetTexture (var lplpTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function GetTransform (lpRefFrame: IDirect3DRMFrame3; var rmMatrix: TD3DRMMatrix4D) : HResult; StdCall;
    function GetVelocity (lpRef: IDirect3DRMFrame3; var lprvVel: TD3DVector; fRotVel: BOOL) : HResult; StdCall;
    function GetOrientation (lpRef: IDirect3DRMFrame3; var lprvDir: TD3DVector; var lprvUp: TD3DVector) : HResult; StdCall;
    function GetVisuals (var lplpVisuals: IDirect3DRMVisualArray) : HResult; StdCall;
    function InverseTransform (var lprvDst, lprvSrc: TD3DVector) : HResult; StdCall;
    function Load (lpvObjSource: Pointer; lpvObjID: Pointer; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadTextureProc: TD3DRMLoadTexture3Callback; lpArgLTP: Pointer) : HResult; StdCall;
    function LookAt (lpTarget, lpRef: IDirect3DRMFrame3; rfcConstraint: TD3DRMFrameConstraint ) : HResult; StdCall;
    function Move (delta: TD3DValue) : HResult; StdCall;
    function DeleteChild (lpChild: IDirect3DRMFrame3) : HResult; StdCall;
    function DeleteLight (lpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function DeleteMoveCallback (d3drmFMC: TD3DRMFrame3MoveCallback; lpArg: Pointer) : HResult; StdCall;
    function DeleteVisual (lpD3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
    function GetSceneBackground: TD3DColor; StdCall;
    function GetSceneBackgroundDepth (var lplpDDSurface: IDirectDrawSurface) : HResult; StdCall;
    function GetSceneFogColor: TD3DColor; StdCall;
    function GetSceneFogEnable: BOOL; StdCall;
    function GetSceneFogMode: TD3DRMFogMode; StdCall;
    function GetSceneFogParams (var lprvStart, lprvEnd, lprvDensity: TD3DValue) : HResult; StdCall;
    function SetSceneBackground (rcColor: TD3DColor) : HResult; StdCall;
    function SetSceneBackgroundRGB (rvRed, rvGreen, rvBlue: TD3DValue) : HResult; StdCall;
    function SetSceneBackgroundDepth (lpImage: IDirectDrawSurface) : HResult; StdCall;
    function SetSceneBackgroundImage (lpTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function SetSceneFogEnable (bEnable: BOOL) : HResult; StdCall;
    function SetSceneFogColor (rcColor: TD3DColor) : HResult; StdCall;
    function SetSceneFogMode (rfMode: TD3DRMFogMode) : HResult; StdCall;
    function SetSceneFogParams (rvStart, rvEnd, rvDensity: TD3DValue) : HResult; StdCall;
    function SetColor (rcColor: TD3DColor) : HResult; StdCall;
    function SetColorRGB (rvRed, rvGreen, rvBlue: TD3DValue) : HResult; StdCall;
    function GetZbufferMode: TD3DRMZBufferMode; StdCall;
    function SetMaterialMode (rmmMode: TD3DRMMaterialMode) : HResult; StdCall;
    function SetOrientation (lpRef: IDirect3DRMFrame3; rvDx, rvDy, rvDz, rvUx, rvUy, rvUz: TD3DValue) : HResult; StdCall;
    function SetPosition (lpRef: IDirect3DRMFrame3; rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function SetRotation (lpRef: IDirect3DRMFrame3; rvX, rvY, rvZ, rvTheta: TD3DValue) : HResult; StdCall;
    function SetSortMode (d3drmSM: TD3DRMSortMode) : HResult; StdCall;
    function SetTexture (lpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function SetVelocity (lpRef: IDirect3DRMFrame3; rvX, rvY, rvZ: TD3DValue; fRotVel: BOOL) : HResult; StdCall;
    function SetZbufferMode (d3drmZBM: TD3DRMZBufferMode) : HResult; StdCall;
    function Transform (var lpd3dVDst, lpd3dVSrc: TD3DVector) : HResult; StdCall;
    function GetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function GetBoxEnable : boolean; StdCall;
    function GetAxes (var dir, up: TD3DVector) : HResult; StdCall;
    function GetMaterial (var lplpMaterial: IDirect3DRMMaterial2) : HResult; StdCall;
    function GetInheritAxes : boolean; StdCall;
    function GetHierarchyBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function SetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function SetBoxEnable (bEnableFlag: BOOL) : HResult; StdCall;
    function SetAxes (dx, dy, dz, ux, uy, uz: TD3DValue) : HResult; StdCall;
    function SetInheritAxes (inherit_from_parent: BOOL) : HResult; StdCall;
    function SetMaterial (var lplpMaterial: IDirect3DRMMaterial2) : HResult; StdCall;
    function SetQuaternion (lpRef: IDirect3DRMFrame3; var quat: TD3DRMQuaternion) : HResult; StdCall;
    function RayPick (lpRefFrame: IDirect3DRMFrame3; var ray: TD3DRMRay; dwFlags: DWORD; var lplpPicked2Array: IDirect3DRMPicked2Array) : HResult; StdCall;
    function Save (lpFilename: PAnsiChar; d3dFormat: TD3DRMXOFFormat; d3dSaveFlags: TD3DRMSaveOptions) : HResult; StdCall;
    function TransformVectors (lpRefFrame: IDirect3DRMFrame3; dwNumVectors: DWORD; var lpDstVectors: TD3DVector; var lpSrcVectors: TD3DVector) : HResult; StdCall;
    function InverseTransformVectors (lpRefFrame: IDirect3DRMFrame3; dwNumVectors: DWORD; var lpDstVectors: TD3DVector; var lpSrcVectors: TD3DVector) : HResult; StdCall;
    function SetTraversalOptions (dwFlags: DWORD) : HResult; StdCall;
    function GetTraversalOptions (var lpdwFlags: DWORD) : HResult; StdCall;
    function SetSceneFogMethod (dwFlags: DWORD) : HResult; StdCall;
    function GetSceneFogMethod (var lpdwFlags: DWORD) : HResult; StdCall;
    function SetMaterialOverride (var lpdmOverride: TD3DRMMaterialOverride) : HResult; StdCall;
    function GetMaterialOverride (var lpdmOverride: TD3DRMMaterialOverride) : HResult; StdCall;
  end;

  IDirect3DRMMesh = interface (IDirect3DRMVisual)
    ['{a3a80d01-6e12-11cf-ac4a-0000c03825a1}']
    (*
     * IDirect3DRMMesh methods
     *)
    function Scale (sx, sy, sz: TD3DValue) : HResult; StdCall;
    function Translate (tx, ty, tz: TD3DValue) : HResult; StdCall;
    function GetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function AddGroup (vCount, fCount, vPerFace: DWORD; var fData: DWORD; var returnId: TD3DRMGroupIndex) : HResult; StdCall;
    function SetVertices (id: TD3DRMGroupIndex; index, count: DWORD; var values: TD3DRMVertex) : HResult; StdCall;
    function SetGroupColor (id: TD3DRMGroupIndex; value: TD3DColor) : HResult; StdCall;
    function SetGroupColorRGB (id: TD3DRMGroupIndex; red, green, blue: TD3DValue) : HResult; StdCall;
    function SetGroupMapping (id: TD3DRMGroupIndex; value: TD3DRMMapping) : HResult; StdCall;
    function SetGroupQuality (id: TD3DRMGroupIndex; value: TD3DRMRenderQuality) : HResult; StdCall;
    function SetGroupMaterial (id: TD3DRMGroupIndex; value: IDirect3DRMMaterial) : HResult; StdCall;
    function SetGroupTexture (id: TD3DRMGroupIndex; value: IDirect3DRMTexture) :HResult;
    function GetGroupCount: DWORD; StdCall;
    function GetGroup (id: TD3DRMGroupIndex; var vCount, fCount, vPerFace, fDataSize, fData: DWORD) : HResult; StdCall;
    function GetVertices (id: TD3DRMGroupIndex; index, count : DWORD; var returnPtr : TD3DRMVertex) : HResult; StdCall;
    function GetGroupColor (id: TD3DRMGroupIndex) : TD3DColor; StdCall;
    function GetGroupMapping (id: TD3DRMGroupIndex) : TD3DRMMapping; StdCall;
    function GetGroupQuality (id: TD3DRMGroupIndex) : TD3DRMRenderQuality; StdCall;
    function GetGroupMaterial (id: TD3DRMGroupIndex; var returnPtr: IDirect3DRMMaterial) : HResult; StdCall;
    function GetGroupTexture (id: TD3DRMGroupIndex; var returnPtr: IDirect3DRMTexture) : HResult; StdCall;
  end;

  IDirect3DRMProgressiveMesh = interface (IDirect3DRMVisual)
    ['{4516ec79-8f20-11d0-9b6d-0000c0781bc3}']
    (*
     * IDirect3DRMProgressiveMesh methods
     *)
    function Load (lpSource, lpObjID: pointer; dloLoadflags : TD3DRMLoadOptions; lpCallback: TD3DRMLoadTextureCallback; lpArg: pointer) : HResult; StdCall;
    function GetLoadStatus (var lpStatus: TD3DRMPMeshLoadStatus) : HResult; StdCall;
    function SetMinRenderDetail (d3dVal: TD3DValue) : HResult; StdCall;
    function Abort (dwFlags: DWORD) : HResult; StdCall;
    function GetFaceDetail (var lpdwCount: DWORD) : HResult; StdCall;
    function GetVertexDetail (var lpdwCount: DWORD) : HResult; StdCall;
    function SetFaceDetail (dwCount: DWORD) : HResult; StdCall;
    function SetVertexDetail (dwCount: DWORD) : HResult; StdCall;
    function GetFaceDetailRange (var lpdwMin, lpdwMax: DWORD) : HResult; StdCall;
    function GetVertexDetailRange (var lpdwMin, lpdwMax: DWORD) : HResult; StdCall;
    function GetDetail (var lpdvVal: TD3DValue) : HResult; StdCall;
    function SetDetail (lpdvVal: TD3DValue) : HResult; StdCall;
    function RegisterEvents (hEvent: THANDLE; dwFlags, dwReserved: DWORD) : HResult; StdCall;
    function CreateMesh (var lplpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function Duplicate (var lplpD3DRMPMesh: IDirect3DRMProgressiveMesh) : HResult; StdCall;
    function GetBox (var lpBBox: TD3DRMBox) : HResult; StdCall;
    function SetQuality (quality: TD3DRMRenderQuality) : HResult; StdCall;
    function GetQuality (var lpdwquality: TD3DRMRenderQuality) : HResult; StdCall;
  end;

  IDirect3DRMShadow = interface (IDirect3DRMVisual)
    ['{af359780-6ba3-11cf-ac4a-0000c03825a1}']
    (*
     * IDirect3DRMShadow methods
     *)
    function Init (lpD3DRMVisual: IDirect3DRMVisual; lpD3DRMLight: IDirect3DRMLight; px, py, pz, nx, ny, nz: TD3DValue) : HResult; StdCall;
  end;

  IDirect3DRMShadow2 = interface (IDirect3DRMShadow)
    ['{86b44e25-9c82-11d1-bb0b-00a0c981a0a6}']
    (*
     * IDirect3DRMShadow2 methods
     *)
    function GetVisual (var lplpDirect3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
    function SetVisual (lpDirect3DRMVisual: IDirect3DRMVisual; dwFlags: DWORD) : HResult; StdCall;
    function GetLight (var lplpDirect3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function SetLight (lplpDirect3DRMLight: IDirect3DRMLight; dwFlags: DWORD) : HResult; StdCall;
    function GetPlane (var pdvPX, pdvPY, pdvPZ, pdvNX, pdvNY, pdvNZ: TD3DValue) : HResult; StdCall;
    function SetPlane (px, py, pz, nx, ny, nz: TD3DValue; dwFlags: DWORD) : HResult; StdCall;
    function GetOptions (var pdwOptions: DWORD) : HResult; StdCall;
    function SetOptions (dwOptions: DWORD) : HResult; StdCall;
  end;

  IDirect3DRMFace = interface (IDirect3DRMObject)
    ['{eb16cb07-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMFace methods
     *)
    function AddVertex (x, y, z: TD3DValue) : HResult; StdCall;
    function AddVertexAndNormalIndexed (vertex: DWORD; normal: DWORD) : HResult; StdCall;
    function SetColorRGB (red, green, blue: TD3DValue) : HResult; StdCall;
    function SetColor (color: TD3DColor) : HResult; StdCall;
    function SetTexture (lpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function SetTextureCoordinates (vertex: DWORD; u, v: TD3DValue) : HResult; StdCall;
    function SetMaterial (lpMat: IDirect3DRMMaterial) : HResult; StdCall;
    function SetTextureTopology (cylU, cylV: BOOL) : HResult; StdCall;
    function GetVertex (index: DWORD; var lpPosition: TD3DVector; var lpNormal: TD3DVector) : HResult; StdCall;
    function GetVertices (var lpdwVertexCount: DWORD; var lpPosition, lpNormal: TD3DVector) : HResult; StdCall;
    function GetTextureCoordinates (index: DWORD; var lpU, lpV: TD3DValue) : HResult; StdCall;
    function GetTextureTopology (var lpU, lpV: BOOL) : HResult; StdCall;
    function GetNormal (var lpNormal: TD3DVector) : HResult; StdCall;
    function GetTexture (var lplpTexture: IDirect3DRMTexture) : HResult; StdCall;
    function GetMaterial (var lpMat: IDirect3DRMMaterial) : HResult; StdCall;
    function GetVertexCount: Integer;
    function GetVertexIndex (dwIndex: DWORD) : Integer;
    function GetTextureCoordinateIndex (dwIndex: DWORD) : Integer;
    function GetColor: TD3DColor;
  end;

  IDirect3DRMFace2 = interface (IDirect3DRMObject)
    ['{4516ec81-8f20-11d0-9b6d-0000c0781bc3}']
    (*
     * IDirect3DRMFace2 methods
     *)
    function AddVertex (x, y, z: TD3DValue) : HResult; StdCall;
    function AddVertexAndNormalIndexed (vertex: DWORD; normal: DWORD) : HResult; StdCall;
    function SetColorRGB (red, green, blue: TD3DValue) : HResult; StdCall;
    function SetColor (color: TD3DColor) : HResult; StdCall;
    function SetTexture (lpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function SetTextureCoordinates (vertex: DWORD; u, v: TD3DValue) : HResult; StdCall;
    function SetMaterial (lpMat: IDirect3DRMMaterial2) : HResult; StdCall;
    function SetTextureTopology (cylU, cylV: BOOL) : HResult; StdCall;
    function GetVertex (index: DWORD; var lpPosition: TD3DVector; var lpNormal: TD3DVector) : HResult; StdCall;
    function GetVertices (var lpdwVertexCount: DWORD; var lpPosition, lpNormal: TD3DVector) : HResult; StdCall;
    function GetTextureCoordinates (index: DWORD; var lpU, lpV: TD3DValue) : HResult; StdCall;
    function GetTextureTopology (var lpU, lpV: BOOL) : HResult; StdCall;
    function GetNormal (var lpNormal: TD3DVector) : HResult; StdCall;
    function GetTexture (var lplpTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function GetMaterial (var lpMat: IDirect3DRMMaterial2) : HResult; StdCall;
    function GetVertexCount: Integer;
    function GetVertexIndex (dwIndex: DWORD) : Integer;
    function GetTextureCoordinateIndex (dwIndex: DWORD) : Integer;
    function GetColor: TD3DColor;
  end;

  IDirect3DRMMeshBuilder = interface (IDirect3DRMVisual)
    ['{a3a80d02-6e12-11cf-ac4a-0000c03825a1}']
    (*
     * IDirect3DRMMeshBuilder methods
     *)
    function Load (lpvObjSource, lpvObjID: Pointer; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadTextureProc: TD3DRMLoadTextureCallback; lpvArg: Pointer) : HResult; StdCall;
    function Save (lpFilename: PChar; TD3DRMXOFFormat: TD3DRMXOFFormat; d3drmSOContents: TD3DRMSaveOptions) : HResult; StdCall;
    function Scale (sx, sy, sz: TD3DValue) : HResult; StdCall;
    function Translate (tx, ty, tz: TD3DValue) : HResult; StdCall;
    function SetColorSource (source: TD3DRMColorSource) : HResult; StdCall;
    function GetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function GenerateNormals : HResult; StdCall;
    function GetColorSource: TD3DRMColorSource;
    function AddMesh (lpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function AddMeshBuilder (lpD3DRMMeshBuild: IDirect3DRMMeshBuilder) : HResult; StdCall;
    function AddFrame (lpD3DRMFrame: IDirect3DRMFrame) : HResult; StdCall;
    function AddFace (lpD3DRMFace: IDirect3DRMFace) : HResult; StdCall;
    function AddFaces (dwVertexCount: DWORD; var lpD3DVertices: TD3DVector; normalCount: DWORD; lpNormals: PD3DVector; var lpFaceData: DWORD; lplpD3DRMFaceArray: PIDirect3DRMFaceArray) : HResult; StdCall;
    function ReserveSpace (vertexCount, normalCount, faceCount: DWORD) : HResult; StdCall;
    function SetColorRGB (red, green, blue: TD3DValue) : HResult; StdCall;
    function SetColor (color: TD3DColor) : HResult; StdCall;
    function SetTexture (lpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function SetMaterial (lpIDirect3DRMmaterial: IDirect3DRMMaterial) : HResult; StdCall;
    function SetTextureTopology (cylU, cylV: BOOL) : HResult; StdCall;
    function SetQuality (quality: TD3DRMRenderQuality) : HResult; StdCall;
    function SetPerspective (perspective: BOOL) : HResult; StdCall;
    function SetVertex (index: DWORD; x, y, z: TD3DValue) : HResult; StdCall;
    function SetNormal (index: DWORD; x, y, z: TD3DValue) : HResult; StdCall;
    function SetTextureCoordinates (index: DWORD; u, v: TD3DValue) : HResult; StdCall;
    function SetVertexColor (index: DWORD; color: TD3DColor) : HResult; StdCall;
    function SetVertexColorRGB (index: DWORD; red, green, blue: TD3DValue) : HResult; StdCall;
    function GetFaces (var lplpD3DRMFaceArray: IDirect3DRMFaceArray) : HResult; StdCall;
    function GetVertices (var vcount: DWORD; var vertices : TD3DVector; var ncount : DWORD; var normals : TD3DVector; var face_data_size, face_data : DWORD) : HResult; StdCall;
    function GetTextureCoordinates(index : DWORD; var u, v : TD3DValue) : HResult; StdCall;
    function AddVertex (x, y, z: TD3DValue) : Integer; StdCall;
    function AddNormal (x, y, z: TD3DValue) : Integer; StdCall;
    function CreateFace (var lplpd3drmFace: IDirect3DRMFace) : HResult; StdCall;
    function GetQuality: TD3DRMRenderQuality; StdCall;
    function GetPerspective: BOOL; StdCall;
    function GetFaceCount: Integer;
    function GetVertexCount: Integer;
    function GetVertexColor (index: DWORD) : TD3DColor; StdCall;
    function CreateMesh (var lplpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
  end;

  IDirect3DRMMeshBuilder2 = interface (IDirect3DRMMeshBuilder)
    ['{4516ec77-8f20-11d0-9b6d-0000c0781bc3}']
    (*
     * IDirect3DRMMeshBuilder2 methods
     *)
    function GenerateNormals2 (dvCreaseAngle: TD3DValue; dwFlags: DWORD) : HResult; StdCall;
    function GetFace (dwIndex: DWORD; lplpD3DRMFace: IDirect3DRMFace) : HResult; StdCall;
  end;

  IDirect3DRMMeshBuilder3 = interface (IDirect3DRMVisual)
    ['{ff6b7f71-a40e-11d1-91f9-0000f8758e66}']
    (*
     * IDirect3DRMMeshBuilder3 methods
     *)
    function Load (lpvObjSource, lpvObjID: Pointer; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadTextureProc: TD3DRMLoadTexture3Callback; lpvArg: Pointer) : HResult; StdCall;
    function Save (lpFilename: PAnsiChar; TD3DRMXOFFormat: TD3DRMXOFFormat; d3drmSOContents: TD3DRMSaveOptions) : HResult; StdCall;
    function Scale (sx, sy, sz: TD3DValue) : HResult; StdCall;
    function Translate (tx, ty, tz: TD3DValue) : HResult; StdCall;
    function SetColorSource (source: TD3DRMColorSource) : HResult; StdCall;
    function GetBox (var lpTD3DRMBox: TD3DRMBox) : HResult; StdCall;
    function GenerateNormals (dvCreaseAngle: TD3DValue; dwFlags: DWORD): HResult;
    function GetColorSource: TD3DRMColorSource;
    function AddMesh (lpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function AddMeshBuilder (lpD3DRMMeshBuild: IDirect3DRMMeshBuilder3) : HResult; StdCall;
    function AddFrame (lpD3DRMFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function AddFace (lpD3DRMFace: IDirect3DRMFace2) : HResult; StdCall;
    function AddFaces (dwVertexCount: DWORD; var lpD3DVertices: TD3DVector; normalCount: DWORD; lpNormals: PD3DVector; var lpFaceData: DWORD; lplpD3DRMFaceArray: PIDirect3DRMFaceArray) : HResult; StdCall;
    function ReserveSpace (vertexCount, normalCount, faceCount: DWORD) : HResult; StdCall;
    function SetColorRGB (red, green, blue: TD3DValue) : HResult; StdCall;
    function SetColor (color: TD3DColor) : HResult; StdCall;
    function SetTexture (lpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function SetMaterial (lpIDirect3DRMmaterial: IDirect3DRMMaterial2) : HResult; StdCall;
    function SetTextureTopology (cylU, cylV: BOOL) : HResult; StdCall;
    function SetQuality (quality: TD3DRMRenderQuality) : HResult; StdCall;
    function SetPerspective (perspective: BOOL) : HResult; StdCall;
    function SetVertex (index: DWORD; x, y, z: TD3DValue) : HResult; StdCall;
    function SetNormal (index: DWORD; x, y, z: TD3DValue) : HResult; StdCall;
    function SetTextureCoordinates (index: DWORD; u, v: TD3DValue) : HResult; StdCall;
    function SetVertexColor (index: DWORD; color: TD3DColor) : HResult; StdCall;
    function SetVertexColorRGB (index: DWORD; red, green, blue: TD3DValue) : HResult; StdCall;
    function GetFaces (var lplpD3DRMFaceArray: IDirect3DRMFaceArray) : HResult; StdCall;
    function GetGeometry (var vcount: DWORD; var vertices : TD3DVector; var ncount : DWORD; var normals : TD3DVector; var face_data_size, face_data : DWORD) : HResult; StdCall;
    function GetTextureCoordinates(index : DWORD; var u, v : TD3DValue) : HResult; StdCall;
    function AddVertex (x, y, z: TD3DValue) : Integer;
    function AddNormal (x, y, z: TD3DValue) : Integer;
    function CreateFace (var lplpd3drmFace: IDirect3DRMFace2) : HResult; StdCall;
    function GetQuality: TD3DRMRenderQuality;
    function GetPerspective: BOOL;
    function GetFaceCount: Integer;
    function GetVertexCount: Integer;
    function GetVertexColor (index: DWORD) : TD3DColor; StdCall;
    function CreateMesh (var lplpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function GetFace(dwIndex: DWORD; lplpD3DRMFace: IDirect3DRMFace) : HResult; StdCall;
    function GetVertex (dwIndex: DWORD; var lpVector: TD3DVector) : HResult; StdCall;
    function GetNormal (dwIndex: DWORD; var lpVector: TD3DVector) : HResult; StdCall;
    function DeleteVertices (dwFirstIndex, dwCount: DWORD) : HResult; StdCall;
    function DeleteNormals (dwFirstIndex, dwCount: DWORD) : HResult; StdCall;
    function DeleteFace (lpFace: IDirect3DRMFace2) : HResult; StdCall;
    function Empty (dwFlags: DWORD) : HResult; StdCall;
    function Optimize (dwFlags: DWORD) : HResult; StdCall;
    function AddFacesIndexed (dwFlags: DWORD; var lpdwvIndices: DWORD; lpdwIndexFirst, lpdwCount: PDWORD) : HResult; StdCall;
    function CreateSubMesh (var lplpUnk: IUnknown) : HResult; StdCall;
    function GetParentMesh (dwFlags: DWORD; var lplpUnk: IUnknown) : HResult; StdCall;
    function GetSubMeshes (lpdwCount: PDWORD; var lpUnk: IUnknown) : HResult; StdCall;
    function DeleteSubMesh (lplpUnk: IUnknown) : HResult; StdCall;
    function Enable (dwFlags: DWORD) : HResult; StdCall;
    function GetEnable (var lpdwFlags: DWORD) : HResult; StdCall;
    function AddTriangles (dwFlags, dwFormat, dwVertexCount:  DWORD; lpData: pointer) : HResult; StdCall;
    function SetVertices (dwFirst, dwCount: DWORD; var lpdvVector: TD3DVector) : HResult; StdCall;
    function GetVertices (dwFirst: DWORD; var lpdwCount: DWORD; lpdvVector: PD3DVector) : HResult; StdCall;
    function SetNormals (dwFirst, dwCount: DWORD; var lpdvVector: TD3DVector) : HResult; StdCall;
    function GetNormals (dwFirst: DWORD; lpdwCount: PDWORD; var lpdvVector: TD3DVector) : HResult; StdCall;
    function GetNormalCount : integer;
  end;

  IDirect3DRMLight = interface (IDirect3DRMObject)
    ['{eb16cb08-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMLight methods
     *)
    function SetType (d3drmtType: TD3DRMLightType) : HResult; StdCall;
    function SetColor (rcColor: TD3DColor) : HResult; StdCall;
    function SetColorRGB (rvRed, rvGreen, rvBlue: TD3DValue) : HResult; StdCall;
    function SetRange (rvRange: TD3DValue) : HResult; StdCall;
    function SetUmbra (rvAngle: TD3DValue) : HResult; StdCall;
    function SetPenumbra (rvAngle: TD3DValue) : HResult; StdCall;
    function SetConstantAttenuation (rvAtt: TD3DValue) : HResult; StdCall;
    function SetLinearAttenuation (rvAtt: TD3DValue) : HResult; StdCall;
    function SetQuadraticAttenuation (rvAtt: TD3DValue) : HResult; StdCall;
    function GetRange: TD3DValue;
    function GetUmbra: TD3DValue;
    function GetPenumbra: TD3DValue;
    function GetConstantAttenuation: TD3DValue;
    function GetLinearAttenuation: TD3DValue;
    function GetQuadraticAttenuation: TD3DValue;
    function GetColor: TD3DColor;
    function GetType: TD3DRMLightType;
    function SetEnableFrame (lpEnableFrame: IDirect3DRMFrame) : HResult; StdCall;
    function GetEnableFrame (var lplpEnableFrame: IDirect3DRMFrame) : HResult; StdCall;
  end;

  IDirect3DRMTexture = interface (IDirect3DRMVisual)
    ['{eb16cb09-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMTexture methods
     *)
    function InitFromFile (filename: PAnsiChar) : HResult; StdCall;
    function InitFromSurface (lpDDS: IDirectDrawSurface) : HResult; StdCall;
    function InitFromResource (rs: HRSRC) : HResult; StdCall;
    function Changed (bPixels, bPalette: BOOL) : HResult; StdCall;
    function SetColors (ulColors: DWORD) : HResult; StdCall;
    function SetShades (ulShades: DWORD) : HResult; StdCall;
    function SetDecalSize (rvWidth, rvHeight: TD3DValue) : HResult; StdCall;
    function SetDecalOrigin (lX, lY: LongInt) : HResult; StdCall;
    function SetDecalScale (dwScale: DWORD) : HResult; StdCall;
    function SetDecalTransparency (bTransp: BOOL) : HResult; StdCall;
    function SetDecalTransparentColor (rcTransp: TD3DColor) : HResult; StdCall;
    function GetDecalSize (var lprvWidth, lprvHeight: TD3DValue) : HResult; StdCall;
    function GetDecalOrigin (var lplX, lplY: LongInt) : HResult; StdCall;
    function GetImage: PD3DRMImage;
    function GetShades: DWORD;
    function GetColors: DWORD;
    function GetDecalScale: DWORD;
    function GetDecalTransparency: BOOL;
    function GetDecalTransparentColor: TD3DColor;
  end;

  IDirect3DRMTexture2 = interface (IDirect3DRMTexture)
    ['{120f30c0-1629-11d0-941c-0080c80cfa7b}']
    (*
     * IDirect3DRMTexture2 methods
     *)
    function InitFromImage (var lpImage: TD3DRMImage) : HResult; StdCall;
    function InitFromResource2 (hModule: HModule; strName, strType: PAnsiChar) : HResult; StdCall;
    function GenerateMIPMap (dwFlags: DWORD) : HResult; StdCall;
  end;

  IDirect3DRMTexture3 = interface (IDirect3DRMTexture2)
    ['{ff6b7f73-a40e-11d1-91f9-0000f8758e66}']
    (*
     * IDirect3DRMTexture3 methods
     *)
    function GetSurface(dwFlags: DWORD; var lplpDDS: IDirectDrawSurface) : HResult; StdCall;
    function SetCacheOptions (lImportance: integer; dwFlags: DWORD) : HResult; StdCall;
    function GetCacheOptions (var lplImportance: integer; var lpdwFlags: DWORD) : HResult; StdCall;
    function SetDownsampleCallback (pCallback: TD3DRMDownSampleCallback; pArg: pointer) : HResult; StdCall;
    function SetValidationCallback (pCallback: TD3DRMValidationCallback; pArg: pointer) : HResult; StdCall;
  end;

  IDirect3DRMWrap = interface (IDirect3DRMObject)
    ['{eb16cb0a-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMWrap methods
     *)
    function Init (d3drmwt: TD3DRMWrapType; lpd3drmfRef: IDirect3DRMFrame; ox, oy, oz, dx, dy, dz, ux, uy, uz, ou, ov, su, sv: TD3DValue) : HResult; StdCall;
    function Apply (lpObject: IDirect3DRMObject) : HResult; StdCall;
    function ApplyRelative(frame: IDirect3DRMFrame; mesh: IDirect3DRMObject) : HResult; StdCall;
  end;

  IDirect3DRMMaterial = interface (IDirect3DRMObject)
    ['{eb16cb0b-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMMaterial methods
     *)
    function SetPower (rvPower: TD3DValue) : HResult; StdCall;
    function SetSpecular (r, g, b: TD3DValue) : HResult; StdCall;
    function SetEmissive (r, g, b: TD3DValue) : HResult; StdCall;
    function GetPower: TD3DValue;
    function GetSpecular (var lpr, lpg, lpb: TD3DValue) : HResult; StdCall;
    function GetEmissive (var lpr, lpg, lpb: TD3DValue) : HResult; StdCall;
  end;

  IDirect3DRMMaterial2 = interface (IDirect3DRMMaterial)
    ['{ff6b7f75-a40e-11d1-91f9-0000f8758e66}']
    (*
     * IDirect3DRMMaterial2 methods
     *)
    function GetAmbient(var r,g,b: TD3DValue) : HResult; StdCall;
    function SetAmbient(r,g,b: TD3DValue) : HResult; StdCall;
  end;

  IDirect3DRMAnimation = interface (IDirect3DRMObject)
    ['{eb16cb0d-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMAnimation methods
     *)
    function SetOptions (d3drmanimFlags: TD3DRMAnimationOptions) : HResult; StdCall;
    function AddRotateKey (rvTime: TD3DValue; var rqQuat: TD3DRMQuaternion) : HResult; StdCall;
    function AddPositionKey (rvTime, rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function AddScaleKey (time, x, y, z: TD3DValue) : HResult; StdCall;
    function DeleteKey (time: TD3DValue) : HResult; StdCall;
    function SetFrame (lpD3DRMFrame: IDirect3DRMFrame) : HResult; StdCall;
    function SetTime (rvTime: TD3DValue) : HResult; StdCall;
    function GetOptions: TD3DRMAnimationOptions;
  end;

  IDirect3DRMAnimation2 = interface (IDirect3DRMObject)
    ['{ff6b7f77-a40e-11d1-91f9-0000f8758e66}']
    (*
     * IDirect3DRMAnimation methods
     *)
    function SetOptions (d3drmanimFlags: TD3DRMAnimationOptions) : HResult; StdCall;
    function AddRotateKey (rvTime: TD3DValue; var rqQuat: TD3DRMQuaternion) : HResult; StdCall;
    function AddPositionKey (rvTime, rvX, rvY, rvZ: TD3DValue) : HResult; StdCall;
    function AddScaleKey (time, x, y, z: TD3DValue) : HResult; StdCall;
    function DeleteKey (time: TD3DValue) : HResult; StdCall;
    function SetFrame (lpD3DRMFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function SetTime (rvTime: TD3DValue) : HResult; StdCall;
    function GetOptions: TD3DRMAnimationOptions;
    function GetFrame (var lpD3DFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function DeleteKeyByID (dwID: DWORD) : HResult; StdCall;
    function AddKey (var lpKey: TD3DRMAnimationKey) : HResult; StdCall;
    function ModifyKey (var lpKey: TD3DRMAnimationKey) : HResult; StdCall;
    function GetKeys (dvTimeMin, dvTimeMax: TD3DValue; var lpdwNumKeys: DWORD; lpKey: PD3DRMAnimationKey) : HResult; StdCall;
  end;

  IDirect3DRMAnimationSet = interface (IDirect3DRMObject)
    ['{eb16cb0e-d271-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMAnimationSet methods
     *)
    function AddAnimation (lpD3DRMAnimation: IDirect3DRMAnimation) : HResult; StdCall;
    function Load (lpvObjSource, lpvObjID: Pointer; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadTextureProc: TD3DRMLoadTextureCallback; lpArgLTP: Pointer; lpParentFrame: IDirect3DRMFrame) : HResult; StdCall;
    function DeleteAnimation (lpD3DRMAnimation: IDirect3DRMAnimation) : HResult; StdCall;
    function SetTime (rvTime: TD3DValue) : HResult; StdCall;
  end;

  IDirect3DRMAnimationSet2 = interface (IDirect3DRMObject)
    ['{ff6b7f79-a40e-11d1-91f9-0000f8758e66}']
    (*
     * IDirect3DRMAnimationSet methods
     *)
    function AddAnimation (lpD3DRMAnimation: IDirect3DRMAnimation2) : HResult; StdCall;
    function Load (lpvObjSource, lpvObjID: Pointer; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadTextureProc: TD3DRMLoadTexture3Callback; lpArgLTP: Pointer; lpParentFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function DeleteAnimation (lpD3DRMAnimation: IDirect3DRMAnimation2) : HResult; StdCall;
    function SetTime (rvTime: TD3DValue) : HResult; StdCall;
    function GetAnimations(Out lplpArray: IDirect3DRMAnimationArray) : HResult; StdCall;
  end;

  IDirect3DRMUserVisual = interface (IDirect3DRMVisual)
    ['{59163de0-6d43-11cf-ac4a-0000c03825a1}']
    (*
     * IDirect3DRMUserVisual methods
     *)
    function Init (d3drmUVProc: TD3DRMUserVisualCallback; lpArg: Pointer) : HResult; StdCall;
  end;

  IDirect3DRMArray = interface (IUnknown)
    function GetSize: DWORD;
    (* No GetElement method as it would get overloaded
     * in derived classes, and overloading is
     * a no-no in COM
     *)
  end;

  IDirect3DRMObjectArray = interface (IDirect3DRMArray)
  	['{242f6bc2-3849-11d0-9b6d-0000c0781bc3}']
    function GetElement (index: DWORD; var lplpD3DRMObject: IDirect3DRMObject) : HResult; StdCall;
  end;

  IDirect3DRMDeviceArray = interface (IDirect3DRMArray)
    ['{eb16cb0e-d271-11ce-ac48-0000c03825a1}']
    function GetElement (index: DWORD; var lplpD3DRMDevice: IDirect3DRMDevice) : HResult; StdCall;
  end;

  IDirect3DRMFrameArray = interface (IDirect3DRMArray)
    ['{eb16cb12-d271-11ce-ac48-0000c03825a1}']
    function GetElement (index: DWORD; var lplpD3DRMFrame: IDirect3DRMFrame) : HResult; StdCall;
  end;

  IDirect3DRMViewportArray = interface (IDirect3DRMArray)
    ['{eb16cb11-d271-11ce-ac48-0000c03825a1}']
    function GetElement (index: DWORD; var lplpD3DRMViewport: IDirect3DRMViewport) : HResult; StdCall;
  end;

  IDirect3DRMVisualArray = interface (IDirect3DRMArray)
    ['{eb16cb13-d271-11ce-ac48-0000c03825a1}']
    function GetElement (index: DWORD; var lplpD3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
  end;

  IDirect3DRMAnimationArray = interface (IDirect3DRMArray)
    ['{d5f1cae0-4bd7-11d1-b974-0060083e45f3}']
    function GetElement (index: DWORD; var lplpD3DRMAnimation2: IDirect3DRMAnimation2) : HResult; StdCall;
  end;

  IDirect3DRMPickedArray = interface (IDirect3DRMArray)
    ['{eb16cb16-d271-11ce-ac48-0000c03825a1}']
    function GetPick (index: DWORD; var lplpVisual: IDirect3DRMVisual; var lplpFrameArray: IDirect3DRMFrameArray; var lpD3DRMPickDesc: TD3DRMPickDesc) : HResult; StdCall;
  end;

  IDirect3DRMLightArray = interface (IDirect3DRMArray)
    ['{eb16cb14-d271-11ce-ac48-0000c03825a1}']
    function GetElement (index: DWORD; var lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
  end;


  IDirect3DRMFaceArray = interface (IDirect3DRMArray)
    ['{eb16cb17-d271-11ce-ac48-0000c03825a1}']
    function GetElement (index: DWORD; var lplpD3DRMFace: IDirect3DRMFace) : HResult; StdCall;
  end;

  IDirect3DRMPicked2Array = interface (IDirect3DRMArray)
    ['{4516ec7b-8f20-11d0-9b6d-0000c0781bc3}']
    function GetPick (index: DWORD; lplpVisual: IDirect3DRMVisual; lplpFrameArray: IDirect3DRMFrameArray; var lpD3DRMPickDesc2: TD3DRMPickDesc2) : HResult; StdCall;
  end;

  IDirect3DRMInterpolator = interface (IDirect3DRMObject)
    ['{242f6bc1-3849-11d0-9b6d-0000c0781bc3}']
    (*
     * IDirect3DRMInterpolator methods
     *)
    function AttachObject (lpD3DRMObject: IDirect3DRMObject) : HResult; StdCall;
    function GetAttachedObjects (lpD3DRMObjectArray: IDirect3DRMObjectArray) : HResult; StdCall;
    function DetachObject (lpD3DRMObject: IDirect3DRMObject) : HResult; StdCall;
    function SetIndex (d3dVal: TD3DValue) : HResult; StdCall;
    function GetIndex : TD3DValue; StdCall;
    function Interpolate (d3dVal: TD3DValue; lpD3DRMObject: IDirect3DRMObject; d3drmInterpFlags: TD3DRMInterpolationOptions) : HResult; StdCall;
  end;

  IDirect3DRMClippedVisual = interface (IDirect3DRMObject)
    ['{5434e733-6d66-11d1-bb0b-0000f875865a}']
    (*
     * IDirect3DRMClippedVisual methods
     *)
    function Init (lpD3DRMVisual: IDirect3DRMVisual) : HResult; StdCall;
    function AddPlane (lpRef: IDirect3DRMFrame3; var lpdvPoint, lpdvNormal: TD3DVector; dwFlags: DWORD; var lpdwReturnID: DWORD) : HResult; StdCall;
    function DeletePlane (dwID, dwFlags: DWORD) : HResult; StdCall;
    function GetPlaneIDs (var lpdwCount, lpdwID: DWORD;dwFlags: DWORD) : HResult; StdCall;
    function GetPlane (dwID: DWORD; lpRef: IDirect3DRMFrame3; var lpdvPoint, lpdvNormal: TD3DVector; dwFlags: DWORD) : HResult; StdCall;
    function SetPlane (dwID: DWORD; lpRef: IDirect3DRMFrame3; var lpdvPoint, lpdvNormal: TD3DVector; dwFlags: DWORD) : HResult; StdCall;
  end;

(******************************************************************************)
(**                                                                          **)
(** D3DRM.Pas                                                                **)
(**                                                                          **)
(******************************************************************************)

type
  TD3DRMDevicePaletteCallback = procedure (lpDirect3DRMDev: IDirect3DRMDevice; lpArg: Pointer; dwIndex: DWORD; red, green, blue: LongInt); cdecl;

const
  IID_IDirect3DRM  : TGUID = (D1:$2bc49361;D2:$8327;D3:$11cf;D4:($ac,$4a,$00,$00,$c0,$38,$25,$a1));
  IID_IDirect3DRM2 : TGUID = (D1:$4516ecc8;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
  IID_IDirect3DRM3 : TGUID = (D1:$4516ec83;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));
(*
 * Direct3DRM Object Class (for CoCreateInstance())
 *)
  CLSID_CDirect3DRM: TGUID = (D1:$4516ec41;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));

type
  IDirect3DRM = interface (IUnknown)
    ['{2bc49361-8327-11cf-ac4a-0000c03825a1}']
    function CreateObject (const rclsid: TGuid; pUnkOuter: IUnknown; const riid: TGUID; Out ppv) : HResult; StdCall;
    function CreateFrame (lpD3DRMFrame: IDirect3DRMFrame; var lplpD3DRMFrame: IDirect3DRMFrame) : HResult; StdCall;
    function CreateMesh (var lplpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function CreateMeshBuilder (var lplpD3DRMMeshBuilder: IDirect3DRMMeshBuilder) : HResult; StdCall;
    function CreateFace (var lplpd3drmFace: IDirect3DRMFace) : HResult; StdCall;
    function CreateAnimation (var lplpD3DRMAnimation: IDirect3DRMAnimation) : HResult; StdCall;
    function CreateAnimationSet (var lplpD3DRMAnimationSet: IDirect3DRMAnimationSet) : HResult; StdCall;
    function CreateTexture (var lpImage: TD3DRMImage; var lplpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function CreateLight (d3drmltLightType: TD3DRMLightType; cColor: TD3DColor; var lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function CreateLightRGB (ltLightType: TD3DRMLightType; vRed, vGreen, vBlue: TD3DValue; var lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function CreateMaterial (vPower: TD3DValue; var lplpD3DRMMaterial: IDirect3DRMMaterial) : HResult; StdCall;
    function CreateDevice (dwWidth, dwHeight: DWORD; var lplpD3DRMDevice: IDirect3DRMDevice) : HResult; StdCall;
    (* Create a Windows Device using DirectDraw surfaces *)
    function CreateDeviceFromSurface (lpGUID: PGUID; lpDD: IDirectDraw; lpDDSBack: IDirectDrawSurface; var lplpD3DRMDevice: IDirect3DRMDevice) : HResult; StdCall;
    (* Create a Windows Device using D3D objects *)
    function CreateDeviceFromD3D (lpD3D: IDirect3D; lpD3DDev: IDirect3DDevice; var lplpD3DRMDevice: IDirect3DRMDevice) : HResult; StdCall;
    function CreateDeviceFromClipper (lpDDClipper: IDirectDrawClipper; lpGUID: PGUID; width, height: Integer; var lplpD3DRMDevice: IDirect3DRMDevice) : HResult; StdCall;
    function CreateTextureFromSurface ( lpDDS: IDirectDrawSurface; var lplpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function CreateShadow (lpVisual: IDirect3DRMVisual; lpLight: IDirect3DRMLight; px, py, pz, nx, ny, nz: TD3DValue; var lplpShadow: IDirect3DRMVisual) : HResult; StdCall;
    function CreateViewport (lpDev: IDirect3DRMDevice; lpCamera: IDirect3DRMFrame; dwXPos, dwYPos, dwWidth, dwHeight: DWORD; var lplpD3DRMViewport: IDirect3DRMViewport) : HResult; StdCall;
    function CreateWrap (wraptype: TD3DRMWrapType; lpRef: IDirect3DRMFrame; ox, oy, oz, dx, dy, dz, ux, uy, uz, ou, ov, su, sv: TD3DValue; var lplpD3DRMWrap: IDirect3DRMWrap) : HResult; StdCall;
    function CreateUserVisual (fn: TD3DRMUserVisualCallback; lpArg: Pointer; var lplpD3DRMUV: IDirect3DRMUserVisual) : HResult; StdCall;
    function LoadTexture (lpFileName: PAnsiChar; var lplpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function LoadTextureFromResource (rs: HRSRC; var lplpD3DRMTexture: IDirect3DRMTexture) : HResult; StdCall;
    function SetSearchPath (lpPath: PAnsiChar) : HResult; StdCall;
    function AddSearchPath (lpPath: PAnsiChar) : HResult; StdCall;
    function GetSearchPath (var lpdwSize: DWORD; lpszPath: PAnsiChar) : HResult; StdCall;
    function SetDefaultTextureColors (dwColors: DWORD) : HResult; StdCall;
    function SetDefaultTextureShades (dwShades: DWORD) : HResult; StdCall;
    function GetDevices (var lplpDevArray: IDirect3DRMDeviceArray) : HResult; StdCall;
    function GetNamedObject (lpName: PAnsiChar; var lplpD3DRMObject: IDirect3DRMObject) : HResult; StdCall;
    function EnumerateObjects (func: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function Load (lpvObjSource, lpvObjID: Pointer; var lplpGUIDs: PGUID; dwcGUIDs: DWORD; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadProc: TD3DRMLoadCallback; lpArgLP: Pointer; d3drmLoadTextureProc: TD3DRMLoadTextureCallback; lpArgLTP: Pointer; lpParentFrame: IDirect3DRMFrame) : HResult; StdCall;
    function Tick (d3dvalTick: TD3DValue) : HResult; StdCall;
  end;

// Moved from D3DRMObj, to avoid circular unit reference:

  IDirect3DRMObject2 = interface (IUnknown)
    ['{4516ec7c-8f20-11d0-9b6d-0000c0781bc3}']
    (*
     * IDirect3DRMObject2 methods
     *)
    function AddDestroyCallback (lpCallback: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function Clone (pUnkOuter: IUnknown; riid: TGUID; var ppvObj: Pointer) : HResult; StdCall;
    function DeleteDestroyCallback (d3drmObjProc: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function GetClientData (dwID: DWORD; var lplpvData: pointer) : HResult; StdCall;
    function GetDirect3DRM (var lplpDirect3DRM: IDirect3DRM) : HResult; StdCall;
    function GetName (var lpdwSize: DWORD; lpName: PAnsiChar) : HResult; StdCall;
    function SetClientData (dwID: DWORD; lpvData: pointer; dwFlags: DWORD) : HResult; StdCall;
    function SetName (lpName: PAnsiChar) : HResult; StdCall;
    function GetAge (dwFlags: DWORD; var pdwAge: DWORD) : HResult; StdCall;
  end;

  IDirect3DRM2 = interface (IUnknown)
    ['{4516ecc8-8f20-11d0-9b6d-0000c0781bc3}']
    function CreateObject (const rclsid: TGuid; pUnkOuter: IUnknown; const riid: TGUID; Out ppv) : HResult; StdCall;
    function CreateFrame (lpD3DRMFrame: IDirect3DRMFrame2; var lplpD3DRMFrame: IDirect3DRMFrame2) : HResult; StdCall;
    function CreateMesh (var lplpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function CreateMeshBuilder (var lplpD3DRMMeshBuilder: IDirect3DRMMeshBuilder2) : HResult; StdCall;
    function CreateFace (var lplpd3drmFace: IDirect3DRMFace) : HResult; StdCall;
    function CreateAnimation (var lplpD3DRMAnimation: IDirect3DRMAnimation) : HResult; StdCall;
    function CreateAnimationSet (var lplpD3DRMAnimationSet: IDirect3DRMAnimationSet) : HResult; StdCall;
    function CreateTexture (var lpImage: TD3DRMImage; var lplpD3DRMTexture: IDirect3DRMTexture2) : HResult; StdCall;
    function CreateLight (d3drmltLightType: TD3DRMLightType; cColor: TD3DColor; var lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function CreateLightRGB (ltLightType: TD3DRMLightType; vRed, vGreen, vBlue: TD3DValue; var lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function CreateMaterial (vPower: TD3DValue; var lplpD3DRMMaterial: IDirect3DRMMaterial) : HResult; StdCall;
    function CreateDevice (dwWidth, dwHeight: DWORD; var lplpD3DRMDevice: IDirect3DRMDevice2) : HResult; StdCall;
    (* Create a Windows Device using DirectDraw surfaces *)
    function CreateDeviceFromSurface (lpGUID: PGUID; lpDD: IDirectDraw; lpDDSBack: IDirectDrawSurface; var lplpD3DRMDevice: IDirect3DRMDevice2) : HResult; StdCall;
    (* Create a Windows Device using D3D objects *)
    function CreateDeviceFromD3D (lpD3D: IDirect3D2; lpD3DDev: IDirect3DDevice2; var lplpD3DRMDevice: IDirect3DRMDevice2) : HResult; StdCall;
    function CreateDeviceFromClipper (lpDDClipper: IDirectDrawClipper; lpGUID: PGUID; width, height: Integer; var lplpD3DRMDevice: IDirect3DRMDevice2) : HResult; StdCall;
    function CreateTextureFromSurface ( lpDDS: IDirectDrawSurface; var lplpD3DRMTexture: IDirect3DRMTexture2) : HResult; StdCall;
    function CreateShadow (lpVisual: IDirect3DRMVisual; lpLight: IDirect3DRMLight; px, py, pz, nx, ny, nz: TD3DValue; var lplpShadow: IDirect3DRMVisual) : HResult; StdCall;
    function CreateViewport (lpDev: IDirect3DRMDevice; lpCamera: IDirect3DRMFrame; dwXPos, dwYPos, dwWidth, dwHeight: DWORD; var lplpD3DRMViewport: IDirect3DRMViewport) : HResult; StdCall;
    function CreateWrap (wraptype: TD3DRMWrapType; lpRef: IDirect3DRMFrame; ox, oy, oz, dx, dy, dz, ux, uy, uz, ou, ov, su, sv: TD3DValue; var lplpD3DRMWrap: IDirect3DRMWrap) : HResult; StdCall;
    function CreateUserVisual (fn: TD3DRMUserVisualCallback; lpArg: Pointer; var lplpD3DRMUV: IDirect3DRMUserVisual) : HResult; StdCall;
    function LoadTexture (lpFileName: PAnsiChar; var lplpD3DRMTexture: IDirect3DRMTexture2) : HResult; StdCall;
    function LoadTextureFromResource (rs: HRSRC; var lplpD3DRMTexture: IDirect3DRMTexture2) : HResult; StdCall;
    function SetSearchPath (lpPath: PAnsiChar) : HResult; StdCall;
    function AddSearchPath (lpPath: PAnsiChar) : HResult; StdCall;
    function GetSearchPath (var lpdwSize: DWORD; lpszPath: PAnsiChar) : HResult; StdCall;
    function SetDefaultTextureColors (dwColors: DWORD) : HResult; StdCall;
    function SetDefaultTextureShades (dwShades: DWORD) : HResult; StdCall;
    function GetDevices (var lplpDevArray: IDirect3DRMDeviceArray) : HResult; StdCall;
    function GetNamedObject (lpName: PAnsiChar; var lplpD3DRMObject: IDirect3DRMObject) : HResult; StdCall;
    function EnumerateObjects (func: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function Load (lpvObjSource, lpvObjID: Pointer; var lplpGUIDs: PGUID; dwcGUIDs: DWORD; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadProc: TD3DRMLoadCallback; lpArgLP: Pointer; d3drmLoadTextureProc: TD3DRMLoadTextureCallback; lpArgLTP: Pointer; lpParentFrame: IDirect3DRMFrame) : HResult; StdCall;
    function Tick (d3dvalTick: TD3DValue) : HResult; StdCall;
    function CreateProgressiveMesh (var lplpD3DRMProgressiveMesh: IDirect3DRMProgressiveMesh) : HResult; StdCall;
  end;

  IDirect3DRM3 = interface (IUnknown)
    ['{4516ec83-8f20-11d0-9b6d-0000c0781bc3}']
    function CreateObject (const rclsid: TGuid; pUnkOuter: IUnknown; const riid: TGUID; Out ppv) : HResult; StdCall;
    function CreateFrame (lpD3DRMFrame: IDirect3DRMFrame3; Out lplpD3DRMFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function CreateMesh (Out lplpD3DRMMesh: IDirect3DRMMesh) : HResult; StdCall;
    function CreateMeshBuilder (Out lplpD3DRMMeshBuilder: IDirect3DRMMeshBuilder3) : HResult; StdCall;
    function CreateFace (Out lplpd3drmFace: IDirect3DRMFace2) : HResult; StdCall;
    function CreateAnimation (Out lplpD3DRMAnimation: IDirect3DRMAnimation2) : HResult; StdCall;
    function CreateAnimationSet (Out lplpD3DRMAnimationSet: IDirect3DRMAnimationSet2) : HResult; StdCall;
    function CreateTexture (const lpImage: TD3DRMImage; Out lplpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function CreateLight (d3drmltLightType: TD3DRMLightType; cColor: TD3DColor; Out lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function CreateLightRGB (ltLightType: TD3DRMLightType; vRed, vGreen, vBlue: TD3DValue; Out lplpD3DRMLight: IDirect3DRMLight) : HResult; StdCall;
    function CreateMaterial (vPower: TD3DValue; Out lplpD3DRMMaterial: IDirect3DRMMaterial2) : HResult; StdCall;
    function CreateDevice (dwWidth, dwHeight: DWORD; Out lplpD3DRMDevice: IDirect3DRMDevice3) : HResult; StdCall;
    (* Create a Windows Device using DirectDraw surfaces *)
    function CreateDeviceFromSurface (lpGUID: PGUID; lpDD: IDirectDraw; lpDDSBack: IDirectDrawSurface; dwFlags: DWORD; Out lplpD3DRMDevice: IDirect3DRMDevice3) : HResult; StdCall;
    (* Create a Windows Device using D3D objects *)
    function CreateDeviceFromD3D (lpD3D: IDirect3D2; lpD3DDev: IDirect3DDevice2; Out lplpD3DRMDevice: IDirect3DRMDevice3) : HResult; StdCall;
    function CreateDeviceFromClipper (lpDDClipper: IDirectDrawClipper; lpGUID: PGUID; width, height: Integer; Out lplpD3DRMDevice: IDirect3DRMDevice3) : HResult; StdCall;
    function CreateTextureFromSurface ( lpDDS: IDirectDrawSurface; Out lplpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function CreateShadow (pUnk: IUnknown; lpLight: IDirect3DRMLight; px, py, pz, nx, ny, nz: TD3DValue; Out lplpShadow: IDirect3DRMShadow2) : HResult; StdCall;
    function CreateViewport (lpDev: IDirect3DRMDevice3; lpCamera: IDirect3DRMFrame3; dwXPos, dwYPos, dwWidth, dwHeight: DWORD; Out lplpD3DRMViewport: IDirect3DRMViewport2) : HResult; StdCall;
    function CreateWrap (wraptype: TD3DRMWrapType; lpRef: IDirect3DRMFrame3; ox, oy, oz, dx, dy, dz, ux, uy, uz, ou, ov, su, sv: TD3DValue; Out lplpD3DRMWrap: IDirect3DRMWrap) : HResult; StdCall;
    function CreateUserVisual (fn: TD3DRMUserVisualCallback; lpArg: Pointer; Out lplpD3DRMUV: IDirect3DRMUserVisual) : HResult; StdCall;
    function LoadTexture (lpFileName: PAnsiChar; Out lplpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function LoadTextureFromResource (hModule: HMODULE; strName, strType: PAnsiChar; Out lplpD3DRMTexture: IDirect3DRMTexture3) : HResult; StdCall;
    function SetSearchPath (lpPath: PAnsiChar) : HResult; StdCall;
    function AddSearchPath (lpPath: PAnsiChar) : HResult; StdCall;
    function GetSearchPath (var lpdwSize: DWORD; lpszPath: PAnsiChar) : HResult; StdCall;
    function SetDefaultTextureColors (dwColors: DWORD) : HResult; StdCall;
    function SetDefaultTextureShades (dwShades: DWORD) : HResult; StdCall;
    function GetDevices (Out lplpDevArray: IDirect3DRMDeviceArray) : HResult; StdCall;
    function GetNamedObject (lpName: PAnsiChar; Out lplpD3DRMObject: IDirect3DRMObject) : HResult; StdCall;
    function EnumerateObjects (func: TD3DRMObjectCallback; lpArg: Pointer) : HResult; StdCall;
    function Load (lpvObjSource, lpvObjID: Pointer; var lplpGUIDs: PGUID; dwcGUIDs: DWORD; d3drmLOFlags: TD3DRMLoadOptions; d3drmLoadProc: TD3DRMLoadCallback; lpArgLP: Pointer; d3drmLoadTextureProc: TD3DRMLoadTexture3Callback; lpArgLTP: Pointer; lpParentFrame: IDirect3DRMFrame3) : HResult; StdCall;
    function Tick (d3dvalTick: TD3DValue) : HResult; StdCall;
    function CreateProgressiveMesh (var lplpD3DRMProgressiveMesh: IDirect3DRMProgressiveMesh) : HResult; StdCall;
    (* Used with IDirect3DRMObject2 *)
    function RegisterClient (const rguid: TGUID; var lpdwID: DWORD) : HResult; StdCall;
    function UnregisterClient (const rguid: TGUID) : HResult; StdCall;
    function CreateClippedVisual (lpVisual: IDirect3DRMVisual; lpClippedVisual: IDirect3DRMClippedVisual) : HResult; StdCall;
    function SetOptions (dwOptions: DWORD) : HResult; StdCall;
    function GetOptions (var lpdwOptions: DWORD) : HResult; StdCall;
  end;

const
  D3DRM_OK                        = DD_OK;
  D3DRMERR_BADOBJECT              = $88760000 + 781;
  D3DRMERR_BADTYPE                = $88760000 + 782;
  D3DRMERR_BADALLOC               = $88760000 + 783;
  D3DRMERR_FACEUSED               = $88760000 + 784;
  D3DRMERR_NOTFOUND               = $88760000 + 785;
  D3DRMERR_NOTDONEYET             = $88760000 + 786;
  D3DRMERR_FILENOTFOUND           = $88760000 + 787;
  D3DRMERR_BADFILE                = $88760000 + 788;
  D3DRMERR_BADDEVICE              = $88760000 + 789;
  D3DRMERR_BADVALUE               = $88760000 + 790;
  D3DRMERR_BADMAJORVERSION        = $88760000 + 791;
  D3DRMERR_BADMINORVERSION        = $88760000 + 792;
  D3DRMERR_UNABLETOEXECUTE        = $88760000 + 793;
  D3DRMERR_LIBRARYNOTFOUND        = $88760000 + 794;
  D3DRMERR_INVALIDLIBRARY         = $88760000 + 795;
  D3DRMERR_PENDING                = $88760000 + 796;
  D3DRMERR_NOTENOUGHDATA          = $88760000 + 797;
  D3DRMERR_REQUESTTOOLARGE        = $88760000 + 798;
  D3DRMERR_REQUESTTOOSMALL        = $88760000 + 799;
  D3DRMERR_CONNECTIONLOST         = $88760000 + 800;
  D3DRMERR_LOADABORTED            = $88760000 + 801;
  D3DRMERR_NOINTERNET             = $88760000 + 802;
  D3DRMERR_BADCACHEFILE           = $88760000 + 803;
  D3DRMERR_BOXNOTSET	          = $88760000 + 804;
  D3DRMERR_BADPMDATA              = $88760000 + 805;
  D3DRMERR_CLIENTNOTREGISTERED    = $88760000 + 806;
  D3DRMERR_NOTCREATEDFROMDDS      = $88760000 + 807;
  D3DRMERR_NOSUCHKEY              = $88760000 + 808;
  D3DRMERR_INCOMPATABLEKEY        = $88760000 + 809;
  D3DRMERR_ELEMENTINUSE           = $88760000 + 810;
  D3DRMERR_TEXTUREFORMATNOTFOUND  = $88760000 + 811;

(* Create a Direct3DRM API *)
var
  Direct3DRMCreate : function (Out lplpDirect3DRM: IDirect3DRM) : HResult; StdCall;

(******************************************************************************)
(**                                                                          **)
(** D3DRMWin.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(*
 * GUIDS used by Direct3DRM Windows interface
 *)
const
  IID_IDirect3DRMWinDevice: TGUID = (D1:$c5016cc0;D2:$d273;D3:$11ce;D4:($ac,$48,$00,$00,$c0,$38,$25,$a1));

type
  IDirect3DRMWinDevice = interface (IDirect3DRMObject)
    ['{c5016cc0-d273-11ce-ac48-0000c03825a1}']
    (*
     * IDirect3DRMWinDevice methods
     *)
    (* Repaint the window with the last frame which was rendered. *)
    function HandlePaint (hDC: HDC) : HResult; StdCall;
    (* Respond to a WM_ACTIVATE message. *)
    function HandleActivate (wparam: WORD) : HResult; StdCall;
  end;

(******************************************************************************)
(**                                                                          **)
(** DInput.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

const
{$IFDEF DIRECTX3}
  DIRECTINPUT_VERSION = $0300;
{$ELSE}
  DIRECTINPUT_VERSION = $0500;
{$ENDIF}

(****************************************************************************
 *
 *      Class IDs
 *
 ****************************************************************************)

  CLSID_DirectInput: TGUID =      (D1:$25E609E0;D2:$B259;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  CLSID_DirectInputDevice: TGUID =      (D1:$25E609E1;D2:$B259;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

(****************************************************************************
 *
 *      Interfaces
 *
 ****************************************************************************)

  IID_IDirectInputW: TGUID =      (D1:$89521361;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputA: TGUID =      (D1:$89521360;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$IFDEF UNICODE}
  IID_IDirectInput: TGUID =       (D1:$89521361;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ELSE}
  IID_IDirectInput: TGUID =       (D1:$89521360;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ENDIF}

  IID_IDirectInput2W: TGUID =      (D1:$5944E663;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInput2A: TGUID =      (D1:$5944E662;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$IFDEF UNICODE}
  IID_IDirectInput2: TGUID =       (D1:$5944E663;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ELSE}
  IID_IDirectInput2: TGUID =       (D1:$5944E662;D2:$AA8A;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ENDIF}


  IID_IDirectInputDeviceW: TGUID =      (D1:$5944E681;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputDeviceA: TGUID =      (D1:$5944E680;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$IFDEF UNICODE}
  IID_IDirectInputDevice: TGUID =       (D1:$5944E681;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ELSE}
  IID_IDirectInputDevice: TGUID =       (D1:$5944E680;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ENDIF}

  IID_IDirectInputDevice2W: TGUID =      (D1:$5944E683;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  IID_IDirectInputDevice2A: TGUID =      (D1:$5944E682;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$IFDEF UNICODE}
  IID_IDirectInputDevice2: TGUID =       (D1:$5944E683;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ELSE}
  IID_IDirectInputDevice2: TGUID =       (D1:$5944E682;D2:$C92E;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
{$ENDIF}

  IID_IDirectInputEffect: TGUID =        (D1:$E7E1F7C0;D2:$88D2;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));

(****************************************************************************
 *
 *      Predefined object types
 *
 ****************************************************************************)

  GUID_XAxis: TGUID =          (D1:$A36D02E0;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_YAxis: TGUID =          (D1:$A36D02E1;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_ZAxis: TGUID =          (D1:$A36D02E2;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_RxAxis: TGUID =         (D1:$A36D02F4;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_RyAxis: TGUID =         (D1:$A36D02F5;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_RzAxis: TGUID =         (D1:$A36D02E3;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Slider: TGUID =         (D1:$A36D02E4;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Button: TGUID =         (D1:$A36D02F0;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Key: TGUID =            (D1:$55728220;D2:$D33C;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_POV: TGUID =            (D1:$A36D02F2;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Unknown: TGUID =        (D1:$A36D02F3;D2:$C9F3;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

(****************************************************************************
 *
 *      Predefined product GUIDs
 *
 ****************************************************************************)

  GUID_SysMouse: TGUID =     (D1:$6F1D2B60;D2:$D5A0;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_SysKeyboard: TGUID =      (D1:$6F1D2B61;D2:$D5A0;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
  GUID_Joystick: TGUID =         (D1:$6F1D2B70;D2:$D5A0;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

(****************************************************************************
 *
 *      Predefined force feedback effects
 *
 ****************************************************************************)

  GUID_ConstantForce: TGUID =      (D1:$13541C20;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_RampForce: TGUID =          (D1:$13541C21;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Square: TGUID =             (D1:$13541C22;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Sine: TGUID =               (D1:$13541C23;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Triangle: TGUID =           (D1:$13541C24;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_SawtoothUp: TGUID =         (D1:$13541C25;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_SawtoothDown: TGUID =       (D1:$13541C26;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Spring: TGUID =             (D1:$13541C27;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Damper: TGUID =             (D1:$13541C28;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Inertia: TGUID =            (D1:$13541C29;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_Friction: TGUID =           (D1:$13541C2A;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
  GUID_CustomForce: TGUID =        (D1:$13541C2B;D2:$8E33;D3:$11D0;D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));



(****************************************************************************
 *
 *      Interfaces and Structures...
 *
 ****************************************************************************)

(****************************************************************************
 *
 *      IDirectInputEffect
 *
 ****************************************************************************)

const
  DIEFT_ALL                   = $00000000;

  DIEFT_CONSTANTFORCE         = $00000001;
  DIEFT_RAMPFORCE             = $00000002;
  DIEFT_PERIODIC              = $00000003;
  DIEFT_CONDITION             = $00000004;
  DIEFT_CUSTOMFORCE           = $00000005;
  DIEFT_HARDWARE              = $000000FF;

  DIEFT_FFATTACK              = $00000200;
  DIEFT_FFFADE                = $00000400;
  DIEFT_SATURATION            = $00000800;
  DIEFT_POSNEGCOEFFICIENTS    = $00001000;
  DIEFT_POSNEGSATURATION      = $00002000;
  DIEFT_DEADBAND              = $00004000;

function DIEFT_GETTYPE(n: variant) : byte;

const
  DI_DEGREES                  =     100;
  DI_FFNOMINALMAX             =   10000;
  DI_SECONDS                  = 1000000;

type
  PDIConstantForce = ^TDIConstantForce;
  TDIConstantForce = packed record
    lMagnitude : LongInt;
  end;

  PDIRampForce = ^TDIRampForce;
  TDIRampForce = packed record
    lSart : LongInt;
    lEnd : LongInt;
  end;

  PDIPeriodic = ^TDIPeriodic;
  TDIPeriodic = packed record
    dwMagnitude : DWORD;
    lOffset : LongInt;
    dwPhase : DWORD;
    dwPeriod : DWORD;
  end;

  PDICondition = ^TDICondition;
  TDICondition = packed record
    lOffset : LongInt;
    lPositiveCoefficient : LongInt;
    lNegativeCoefficient : LongInt;
    dwPositiveSaturation : DWORD;
    dwNegativeSaturation : DWORD;
    lDeadBand : LongInt;
  end;

  PDICustomForce = ^TDICustomForce;
  TDICustomForce = packed record
    cChannels : DWORD;
    dwSamplePeriod : DWORD;
    cSamples : DWORD;
    rglForceData : PLongInt;
  end;

  PDIEnvelope = ^TDIEnvelope;
  TDIEnvelope = packed record
    dwSize : DWORD;                   (* sizeof(DIENVELOPE)   *)
    dwAttackLevel : DWORD;
    dwAttackTime : DWORD;             (* Microseconds         *)
    dwFadeLevel : DWORD;
    dwFadeTime : DWORD;               (* Microseconds         *)
  end;

  PDIEffect = ^TDIEffect;
  TDIEffect = packed record
    dwSize : DWORD;                   (* sizeof(DIEFFECT)     *)
    dwFlags : DWORD;                  (* DIEFF_*              *)
    dwDuration : DWORD;               (* Microseconds         *)
    dwSamplePeriod : DWORD;           (* Microseconds         *)
    dwGain : DWORD;
    dwTriggerButton : DWORD;          (* or DIEB_NOTRIGGER    *)
    dwTriggerRepeatInterval : DWORD;  (* Microseconds         *)
    cAxes : DWORD;                    (* Number of axes       *)
    rgdwAxes : PDWORD;                (* Array of axes        *)
    rglDirection : PLongInt;          (* Array of directions  *)
    lpEnvelope : PDIEnvelope;         (* Optional             *)
    cbTypeSpecificParams : DWORD;     (* Size of params       *)
    lpvTypeSpecificParams : pointer;  (* Pointer to params    *)
  end;

const
  DIEFF_OBJECTIDS             = $00000001;
  DIEFF_OBJECTOFFSETS         = $00000002;
  DIEFF_CARTESIAN             = $00000010;
  DIEFF_POLAR                 = $00000020;
  DIEFF_SPHERICAL             = $00000040;

  DIEP_DURATION               = $00000001;
  DIEP_SAMPLEPERIOD           = $00000002;
  DIEP_GAIN                   = $00000004;
  DIEP_TRIGGERBUTTON          = $00000008;
  DIEP_TRIGGERREPEATINTERVAL  = $00000010;
  DIEP_AXES                   = $00000020;
  DIEP_DIRECTION              = $00000040;
  DIEP_ENVELOPE               = $00000080;
  DIEP_TYPESPECIFICPARAMS     = $00000100;
  DIEP_ALLPARAMS              = $000001FF;
  DIEP_START                  = $20000000;
  DIEP_NORESTART              = $40000000;
  DIEP_NODOWNLOAD             = $80000000;
  DIEB_NOTRIGGER              = $FFFFFFFF;

  DIES_SOLO                   = $00000001;
  DIES_NODOWNLOAD             = $80000000;

  DIEGES_PLAYING              = $00000001;
  DIEGES_EMULATED             = $00000002;


type
  PDIEffEscape = ^TDIEffEscape;
  TDIEffEscape = packed record
    dwSize : DWORD;
    dwCommand : DWORD;
    lpvInBuffer : pointer;
    cbInBuffer : DWORD;
    lpvOutBuffer : pointer;
    cbOutBuffer : DWORD;
  end;


//
// IDirectSoundCapture
//
  IDirectInputEffect = interface (IUnknown)
    ['{E7E1F7C0-88D2-11D0-9AD0-00A0C9A06E35}']
    (** IDirectInputEffect methods ***)
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID) : HResult; StdCall;
    function GetEffectGuid(var pguid: TGUID) : HResult; StdCall;
    function GetParameters(var peff: TDIEffect; dwFlags: DWORD) : HResult; StdCall;
    function SetParameters(var peff: TDIEffect; dwFlags: DWORD) : HResult; StdCall;
    function Start(dwIterations: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function Stop : HResult; StdCall;
    function GetEffectStatus(var pdwFlags : DWORD) : HResult; StdCall;
    function Download : HResult; StdCall;
    function Unload : HResult; StdCall;
    function Escape(var pesc: TDIEffEscape) : HResult; StdCall;
  end;

(****************************************************************************
 *
 *      IDirectInputDevice
 *
 ****************************************************************************)

const
  DIDEVTYPE_DEVICE = 1;
  DIDEVTYPE_MOUSE = 2;
  DIDEVTYPE_KEYBOARD = 3;
  DIDEVTYPE_JOYSTICK = 4;
  DIDEVTYPE_HID = $00010000;

  DIDEVTYPEMOUSE_UNKNOWN = 1;
  DIDEVTYPEMOUSE_TRADITIONAL = 2;
  DIDEVTYPEMOUSE_FINGERSTICK = 3;
  DIDEVTYPEMOUSE_TOUCHPAD = 4;
  DIDEVTYPEMOUSE_TRACKBALL = 5;

  DIDEVTYPEKEYBOARD_UNKNOWN = 0;
  DIDEVTYPEKEYBOARD_PCXT = 1;
  DIDEVTYPEKEYBOARD_OLIVETTI = 2;
  DIDEVTYPEKEYBOARD_PCAT = 3;
  DIDEVTYPEKEYBOARD_PCENH = 4;
  DIDEVTYPEKEYBOARD_NOKIA1050 = 5;
  DIDEVTYPEKEYBOARD_NOKIA9140 = 6;
  DIDEVTYPEKEYBOARD_NEC98 = 7;
  DIDEVTYPEKEYBOARD_NEC98LAPTOP = 8;
  DIDEVTYPEKEYBOARD_NEC98106 = 9;
  DIDEVTYPEKEYBOARD_JAPAN106 = 10;
  DIDEVTYPEKEYBOARD_JAPANAX = 11;
  DIDEVTYPEKEYBOARD_J3100 = 12;

  DIDEVTYPEJOYSTICK_UNKNOWN = 1;
  DIDEVTYPEJOYSTICK_TRADITIONAL = 2;
  DIDEVTYPEJOYSTICK_FLIGHTSTICK = 3;
  DIDEVTYPEJOYSTICK_GAMEPAD = 4;
  DIDEVTYPEJOYSTICK_RUDDER = 5;
  DIDEVTYPEJOYSTICK_WHEEL = 6;
  DIDEVTYPEJOYSTICK_HEADTRACKER = 7;

function GET_DIDEVICE_TYPE(dwDevType: variant) : byte;
function GET_DIDEVICE_SUBTYPE(dwDevType: variant) : byte;

type
  PDIDevCaps_DX3 = ^TDIDevCaps_DX3;
  TDIDevCaps_DX3 = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDevType: DWORD;
    dwAxes: DWORD;
    dwButtons: DWORD;
    dwPOVs: DWORD;
  end;

  PDIDevCaps_DX5 = ^TDIDevCaps_DX5;
  TDIDevCaps_DX5 = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDevType: DWORD;
    dwAxes: DWORD;
    dwButtons: DWORD;
    dwPOVs: DWORD;
    dwFFSamplePeriod: DWORD;
    dwFFMinTimeResolution: DWORD;
    dwFirmwareRevision: DWORD;
    dwHardwareRevision: DWORD;
    dwFFDriverVersion: DWORD;
  end;

  PDIDevCaps = ^TDIDevCaps;
  TDIDevCaps = TDIDevCaps_DX5;

const
  DIDC_ATTACHED = $00000001;
  DIDC_POLLEDDEVICE = $00000002;
  DIDC_EMULATED = $00000004;
  DIDC_POLLEDDATAFORMAT = $00000008;
  DIDC_FORCEFEEDBACK      = $00000100;
  DIDC_FFATTACK           = $00000200;
  DIDC_FFFADE             = $00000400;
  DIDC_SATURATION         = $00000800;
  DIDC_POSNEGCOEFFICIENTS = $00001000;
  DIDC_POSNEGSATURATION   = $00002000;
  DIDC_DEADBAND           = $00004000;

  DIDFT_ALL = $00000000;

  DIDFT_RELAXIS = $00000001;
  DIDFT_ABSAXIS = $00000002;
  DIDFT_AXIS = $00000003;

  DIDFT_PSHBUTTON = $00000004;
  DIDFT_TGLBUTTON = $00000008;
  DIDFT_BUTTON = $0000000C;

  DIDFT_POV = $00000010;

  DIDFT_COLLECTION = $00000040;
  DIDFT_NODATA = $00000080;

  DIDFT_ANYINSTANCE = $00FFFF00;
  DIDFT_INSTANCEMASK = DIDFT_ANYINSTANCE;
function DIDFT_MAKEINSTANCE(n: variant) : DWORD;
function DIDFT_GETTYPE(n: variant) : byte;
function DIDFT_GETINSTANCE(n: variant) : DWORD;
const
  DIDFT_FFACTUATOR = $01000000;
  DIDFT_FFEFFECTTRIGGER = $02000000;

function DIDFT_ENUMCOLLECTION(n: variant) : DWORD;
const
  DIDFT_NOCOLLECTION = $00FFFF00;



type
  PDIObjectDataFormat = ^TDIObjectDataFormat;
  TDIObjectDataFormat = packed record
    pguid: PGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
  end;

  PDIDataFormat = ^TDIDataFormat;
  TDIDataFormat = packed record
    dwSize: DWORD;   
    dwObjSize: DWORD;   
    dwFlags: DWORD;   
    dwDataSize: DWORD;   
    dwNumObjs: DWORD;   
    rgodf: PDIObjectDataFormat;
  end;

const
  DIDF_ABSAXIS = $00000001;
  DIDF_RELAXIS = $00000002;

type
  PDIDeviceObjectInstance_DX3A = ^TDIDeviceObjectInstance_DX3A;
  TDIDeviceObjectInstance_DX3A = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: Array [0..MAX_PATH-1] of CHAR;
  end;

  PDIDeviceObjectInstance_DX3W = ^TDIDeviceObjectInstance_DX3W;
  TDIDeviceObjectInstance_DX3W = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: Array [0..MAX_PATH-1] of WCHAR;
  end;

  PDIDeviceObjectInstance_DX3 = ^TDIDeviceObjectInstance_DX3;
{$IFDEF UNICODE}
  TDIDeviceObjectInstance_DX3 = TDIDeviceObjectInstance_DX3W;
{$ELSE}
  TDIDeviceObjectInstance_DX3 = TDIDeviceObjectInstance_DX3A;
{$ENDIF}

  PDIDeviceObjectInstance_DX5A = ^TDIDeviceObjectInstance_DX5A;
  TDIDeviceObjectInstance_DX5A = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: Array [0..MAX_PATH-1] of CHAR;
    dwFFMaxForce: DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber: WORD;
    wDesignatorIndex: WORD;
    wUsagePage: WORD;
    wUsage: WORD;
    dwDimension: DWORD;
    wExponent: WORD;
    wReserved: WORD;
  end;

  PDIDeviceObjectInstance_DX5W = ^TDIDeviceObjectInstance_DX5W;
  TDIDeviceObjectInstance_DX5W = packed record
    dwSize: DWORD;
    guidType: TGUID;
    dwOfs: DWORD;
    dwType: DWORD;
    dwFlags: DWORD;
    tszName: Array [0..MAX_PATH-1] of WCHAR;
    dwFFMaxForce: DWORD;
    dwFFForceResolution: DWORD;
    wCollectionNumber: WORD;
    wDesignatorIndex: WORD;
    wUsagePage: WORD;
    wUsage: WORD;
    dwDimension: DWORD;
    wExponent: WORD;
    wReserved: WORD;
  end;

  PDIDeviceObjectInstance_DX5 = ^TDIDeviceObjectInstance_DX5;
{$IFDEF UNICODE}
  TDIDeviceObjectInstance_DX5 = TDIDeviceObjectInstance_DX5W;
{$ELSE}
  TDIDeviceObjectInstance_DX5 = TDIDeviceObjectInstance_DX5A;
{$ENDIF}

  PDIDeviceObjectInstanceA = ^TDIDeviceObjectInstanceA;
  TDIDeviceObjectInstanceA = TDIDeviceObjectInstance_DX5A;

  PDIDeviceObjectInstanceW = ^TDIDeviceObjectInstanceA;
  TDIDeviceObjectInstanceW = TDIDeviceObjectInstance_DX5W;

  PDIDeviceObjectInstance = ^TDIDeviceObjectInstance;
  TDIDeviceObjectInstance = TDIDeviceObjectInstance_DX5;

  TDIEnumDeviceObjectsCallbackA = function (var lpddoi: TDIDeviceObjectInstanceA; pvRef: Pointer) : BOOL; stdcall;
  TDIEnumDeviceObjectsCallbackW = function (var lpddoi: TDIDeviceObjectInstanceW; pvRef: Pointer) : BOOL; stdcall;
  TDIEnumDeviceObjectsCallback = function (var lpddoi: TDIDeviceObjectInstance; pvRef: Pointer) : BOOL; stdcall;
  TDIEnumDeviceObjectsProc = function (var lpddoi: TDIDeviceObjectInstance; pvRef: Pointer): BOOL; stdcall;

const
  DIDOI_FFACTUATOR        = $00000001;
  DIDOI_FFEFFECTTRIGGER   = $00000002;
  DIDOI_POLLED            = $00008000;
  DIDOI_ASPECTPOSITION    = $00000100;
  DIDOI_ASPECTVELOCITY    = $00000200;
  DIDOI_ASPECTACCEL       = $00000300;
  DIDOI_ASPECTFORCE       = $00000400;
  DIDOI_ASPECTMASK        = $00000F00;

type
  PDIPropHeader = ^TDIPropHeader;
  TDIPropHeader = packed record
    dwSize: DWORD;
    dwHeaderSize: DWORD;
    dwObj: DWORD;
    dwHow: DWORD;
  end;

const
  DIPH_DEVICE = 0;
  DIPH_BYOFFSET = 1;
  DIPH_BYID = 2;

type
  PDIPropDWord = ^TDIPropDWord;
  TDIPropDWord = packed record
    diph: TDIPropHeader;
    dwData: DWORD;
  end;

  PDIPropRange = ^TDIPropRange;
  TDIPropRange = packed record
    diph: TDIPropHeader;
    lMin: Longint;
    lMax: Longint;
  end;

const
  DIPROPRANGE_NOMIN = $80000000;
  DIPROPRANGE_NOMAX = $7FFFFFFF;

type
  MAKEDIPROP = PGUID;

const
  DIPROP_BUFFERSIZE = MAKEDIPROP(1);

  DIPROP_AXISMODE = MAKEDIPROP(2);

  DIPROPAXISMODE_ABS = 0;
  DIPROPAXISMODE_REL = 1;

  DIPROP_GRANULARITY = MAKEDIPROP(3);

  DIPROP_RANGE = MAKEDIPROP(4);

  DIPROP_DEADZONE = MAKEDIPROP(5);

  DIPROP_SATURATION = MAKEDIPROP(6);

  DIPROP_FFGAIN = MAKEDIPROP(7);

  DIPROP_FFLOAD = MAKEDIPROP(8);

  DIPROP_AUTOCENTER = MAKEDIPROP(9);

  DIPROPAUTOCENTER_OFF = 0;
  DIPROPAUTOCENTER_ON = 1;

  DIPROP_CALIBRATIONMODE = MAKEDIPROP(10);

  DIPROPCALIBRATIONMODE_COOKED = 0;
  DIPROPCALIBRATIONMODE_RAW = 1;

type
  PDIDeviceObjectData = ^TDIDeviceObjectData;
  TDIDeviceObjectData = packed record
    dwOfs: DWORD;
    dwData: DWORD;
    dwTimeStamp: DWORD;
    dwSequence: DWORD;
  end;

const
  DIGDD_PEEK = $00000001;
{
#define DISEQUENCE_COMPARE(dwSequence1, cmp, dwSequence2) \
                         (int) ((dwSequence1) - (dwSequence2))  cmp 0
}

  DISCL_EXCLUSIVE = $00000001;
  DISCL_NONEXCLUSIVE = $00000002;
  DISCL_FOREGROUND = $00000004;
  DISCL_BACKGROUND = $00000008;


type

  PDIDeviceInstance_DX3A = ^TDIDeviceInstance_DX3A;
  TDIDeviceInstance_DX3A = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: Array [0..MAX_PATH-1] of AnsiChar;
    tszProductName: Array [0..MAX_PATH-1] of AnsiChar;
  end;

  PDIDeviceInstance_DX3W = ^TDIDeviceInstance_DX3W;
  TDIDeviceInstance_DX3W = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: Array [0..MAX_PATH-1] of WideChar;
    tszProductName: Array [0..MAX_PATH-1] of WideChar;
  end;

  PDIDeviceInstance_DX3 = ^TDIDeviceInstance_DX3;
{$IFDEF UNICODE}
  TDIDeviceInstance_DX3 = TDIDeviceInstance_DX3W;
{$ELSE}
  TDIDeviceInstance_DX3 = TDIDeviceInstance_DX3A;
{$ENDIF}

  PDIDeviceInstance_DX5A = ^TDIDeviceInstance_DX5A;
  TDIDeviceInstance_DX5A = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: Array [0..MAX_PATH-1] of AnsiChar;
    tszProductName: Array [0..MAX_PATH-1] of AnsiChar;
    guidFFDriver: TGUID;
    wUsagePage: WORD;
    wUsage: WORD;
  end;

  PDIDeviceInstance_DX5W = ^TDIDeviceInstance_DX5W;
  TDIDeviceInstance_DX5W = packed record
    dwSize: DWORD;
    guidInstance: TGUID;
    guidProduct: TGUID;
    dwDevType: DWORD;
    tszInstanceName: Array [0..MAX_PATH-1] of WideChar;
    tszProductName: Array [0..MAX_PATH-1] of WideChar;
    guidFFDriver: TGUID;
    wUsagePage: WORD;
    wUsage: WORD;
  end;

  PDIDeviceInstance_DX5 = ^TDIDeviceInstance_DX5;
{$IFDEF UNICODE}
  TDIDeviceInstance_DX5 = TDIDeviceInstance_DX5W;
{$ELSE}
  TDIDeviceInstance_DX5 = TDIDeviceInstance_DX5A;
{$ENDIF}

  PDIDeviceInstanceA = ^TDIDeviceInstanceA;
  TDIDeviceInstanceA = TDIDeviceInstance_DX5A;

  PDIDeviceInstanceW = ^TDIDeviceInstanceW;
  TDIDeviceInstanceW = TDIDeviceInstance_DX5W;
  
  PDIDeviceInstance = ^TDIDeviceInstance;
  TDIDeviceInstance = TDIDeviceInstance_DX5;


  IDirectInputDeviceA = interface (IUnknown)
    ['{5944E680-C92E-11CF-BFC7-444553540000}']
    (*** IDirectInputDeviceA methods ***)
    function GetCapabilities(var lpDIDevCaps: TDIDevCaps) : HResult; StdCall;
    function EnumObjects(lpCallback: TDIEnumDeviceObjectsCallbackA; pvRef: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetProperty(rguidProp: PGUID; var pdiph: TDIPropHeader) : HResult; StdCall;
    function SetProperty(rguidProp: PGUID; const pdiph: TDIPropHeader) : HResult; StdCall;
    function Acquire : HResult; StdCall;
    function Unacquire : HResult; StdCall;
    function GetDeviceState(cbData: DWORD; lpvData: Pointer) : HResult; StdCall;
    function GetDeviceData(cbObjectData: DWORD; rgdod: PDIDeviceObjectData; var pdwInOut: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function SetDataFormat(var lpdf: TDIDataFormat) : HResult; StdCall;
    function SetEventNotification(hEvent: THandle) : HResult; StdCall;
    function SetCooperativeLevel(hwnd: HWND; dwFlags: DWORD) : HResult; StdCall;
    function GetObjectInfo(var pdidoi: TDIDeviceObjectInstanceA; dwObj: DWORD; dwHow: DWORD) : HResult; StdCall;
    function GetDeviceInfo(var pdidi: TDIDeviceInstanceA) : HResult; StdCall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD) : HResult; StdCall;
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID) : HResult; StdCall;
  end;

  IDirectInputDeviceW = interface (IUnknown)
    ['{5944E681-C92E-11CF-BFC7-444553540000}']
    (*** IDirectInputDeviceW methods ***)
    function GetCapabilities(var lpDIDevCaps: TDIDevCaps) : HResult; StdCall;
    function EnumObjects(lpCallback: TDIEnumDeviceObjectsCallbackW; pvRef: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetProperty(rguidProp: PGUID; var pdiph: TDIPropHeader) : HResult; StdCall;
    function SetProperty(rguidProp: PGUID; var pdiph: TDIPropHeader) : HResult; StdCall;
    function Acquire : HResult; StdCall;
    function Unacquire : HResult; StdCall;
    function GetDeviceState(cbData: DWORD; lpvData: Pointer) : HResult; StdCall;
    function GetDeviceData(cbObjectData: DWORD; rgdod: PDIDeviceObjectData; var pdwInOut: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function SetDataFormat(var lpdf: TDIDataFormat) : HResult; StdCall;
    function SetEventNotification(hEvent: THandle) : HResult; StdCall;
    function SetCooperativeLevel(hwnd: HWND; dwFlags: DWORD) : HResult; StdCall;
    function GetObjectInfo(var pdidoi: TDIDeviceObjectInstanceW; dwObj: DWORD; dwHow: DWORD) : HResult; StdCall;
    function GetDeviceInfo(var pdidi: TDIDeviceInstanceW) : HResult; StdCall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD) : HResult; StdCall;
    function Initialize(hinst: THandle; dwVersion: DWORD; const rguid: TGUID) : HResult; StdCall;
  end;

{$IFDEF UNICODE}
  IDirectInputDevice = IDirectInputDeviceW;
{$ELSE}
  IDirectInputDevice = IDirectInputDeviceA;
{$ENDIF}

const
  DISFFC_RESET            = $00000001;
  DISFFC_STOPALL          = $00000002;
  DISFFC_PAUSE            = $00000004;
  DISFFC_CONTINUE         = $00000008;
  DISFFC_SETACTUATORSON   = $00000010;
  DISFFC_SETACTUATORSOFF  = $00000020;

  DIGFFS_EMPTY            = $00000001;
  DIGFFS_STOPPED          = $00000002;
  DIGFFS_PAUSED           = $00000004;
  DIGFFS_ACTUATORSON      = $00000010;
  DIGFFS_ACTUATORSOFF     = $00000020;
  DIGFFS_POWERON          = $00000040;
  DIGFFS_POWEROFF         = $00000080;
  DIGFFS_SAFETYSWITCHON   = $00000100;
  DIGFFS_SAFETYSWITCHOFF  = $00000200;
  DIGFFS_USERFFSWITCHON   = $00000400;
  DIGFFS_USERFFSWITCHOFF  = $00000800;
  DIGFFS_DEVICELOST       = $80000000;

type
  PDIEffectInfoA = ^TDIEffectInfoA;
  TDIEffectInfoA = packed record
    dwSize : DWORD;
    guid : TGUID;
    dwEffType : DWORD;
    dwStaticParams : DWORD;
    dwDynamicParams : DWORD;
    tszName : array [0..MAX_PATH-1] of CHAR;
  end;

  PDIEffectInfoW = ^TDIEffectInfoW;
  TDIEffectInfoW = packed record
    dwSize : DWORD;
    guid : TGUID;
    dwEffType : DWORD;
    dwStaticParams : DWORD;
    dwDynamicParams : DWORD;
    tszName : array [0..MAX_PATH-1] of WCHAR;
  end;

  PDIEffectInfo = ^TDIEffectInfo;
{$IFDEF UNICODE}
  TDIEffectInfo = TDIEffectInfoW;
{$ELSE}
  TDIEffectInfo = TDIEffectInfoA;
{$ENDIF}

  TDIEnumEffectsCallbackA = function(var pdei: TDIEffectInfoA; pvRef: pointer) : BOOL; stdcall;
  TDIEnumEffectsCallbackW = function(var pdei: TDIEffectInfoW; pvRef: pointer) : BOOL; stdcall;
  TDIEnumEffectsCallback  = function(var pdei: TDIEffectInfo; pvRef: pointer) : BOOL; stdcall;
  TDIEnumEffectsProc      = TDIEnumEffectsCallback;


  TDIEnumCreatedEffectObjectsCallback = function(peff: IDirectInputEffect; pvRev: pointer) : BOOL; stdcall;
  TDIEnumCreatedEffectObjectsProc = TDIEnumCreatedEffectObjectsCallback;

  IDirectInputDevice2A = interface (IDirectInputDeviceA)
    ['{5944E682-C92E-11CF-BFC7-444553540000}']
    (*** IDirectInputDevice2A methods ***)
    function CreateEffect(const rguid: TGUID; lpeff: PDIEffect; var ppdeff: IDirectInputEffect; punkOuter: IUnknown) : HResult; StdCall;
    function EnumEffects(lpCallback: TDIEnumEffectsCallbackA; pvRef: pointer; dwEffType: DWORD) : HResult; StdCall;
    function GetEffectInfo(pdei: TDIEffectInfoA; const rguid: TGUID) : HResult; StdCall;
    function GetForceFeedbackState(var pdwOut: DWORD) : HResult; StdCall;
    function SendForceFeedbackCommand(dwFlags: DWORD) : HResult; StdCall;
    function EnumCreatedEffectObjects(lpCallback: TDIEnumCreatedEffectObjectsCallback; pvRef: pointer; fl: DWORD) : HResult; StdCall;
    function Escape(var pesc: TDIEffEscape) : HResult; StdCall;
    function Poll : HResult; StdCall;
    function SendDeviceData(cbObjectData: DWORD; var rgdod: TDIDeviceObjectData; var pdwInOut: DWORD; fl: DWORD) : HResult; StdCall;
  end;

  IDirectInputDevice2W = interface (IDirectInputDeviceW)
    ['{5944E683-C92E-11CF-BFC7-444553540000}']
    (*** IDirectInputDevice2W methods ***)
    function CreateEffect(const rguid: TGUID; lpeff: PDIEffect; var ppdeff: IDirectInputEffect; punkOuter: IUnknown) : HResult; StdCall;
    function EnumEffects(lpCallback: TDIEnumEffectsCallbackW; pvRef: pointer; dwEffType: DWORD) : HResult; StdCall;
    function GetEffectInfo(pdei: TDIEffectInfoW; const rguid: TGUID) : HResult; StdCall;
    function GetForceFeedbackState(var pdwOut: DWORD) : HResult; StdCall;
    function SendForceFeedbackCommand(dwFlags: DWORD) : HResult; StdCall;
    function EnumCreatedEffectObjects(lpCallback: TDIEnumCreatedEffectObjectsCallback; pvRef: pointer; fl: DWORD) : HResult; StdCall;
    function Escape(var pesc: TDIEffEscape) : HResult; StdCall;
    function Poll : HResult; StdCall;
    function SendDeviceData(cbObjectData: DWORD; var rgdod: TDIDeviceObjectData; var pdwInOut: DWORD; fl: DWORD) : HResult; StdCall;
  end;

{$IFDEF UNICODE}
  IDirectInputDevice2 = IDirectInputDevice2W;
{$ELSE}
  IDirectInputDevice2 = IDirectInputDevice2A;
{$ENDIF}


(****************************************************************************
 *
 *      Mouse
 *
 ****************************************************************************)


  PDIMouseState = ^TDIMouseState;
  TDIMouseState = packed record
    lX: Longint;
    lY: Longint;
    lZ: Longint;
    rgbButtons: Array [0..3] of BYTE;
  end;

const
  DIMOFS_X       = 0;
  DIMOFS_Y       = 4;
  DIMOFS_Z       = 8;
  DIMOFS_BUTTON0 = 12;
  DIMOFS_BUTTON1 = 13;
  DIMOFS_BUTTON2 = 14;
  DIMOFS_BUTTON3 = 15;

const
  _c_dfDIMouse_Objects: array[0..3] of TDIObjectDataFormat = (
    (  pguid: @GUID_XAxis;
       dwOfs: DIMOFS_X;
       dwType: DIDFT_RELAXIS or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_YAxis;
       dwOfs: DIMOFS_Y;
       dwType: DIDFT_RELAXIS or DIDFT_ANYINSTANCE;
       dwFlags: 0),
{
    (  pguid: @GUID_ZAxis;
       dwOfs: DIMOFS_Z;
       dwType: DIDFT_RELAXIS or DIDFT_ANYINSTANCE;
       dwFlags: 0),
}
    (  pguid: @GUID_Button;
       dwOfs: DIMOFS_BUTTON0;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Button;
       dwOfs: DIMOFS_BUTTON1;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0)
{
    (  pguid: @GUID_Button;
       dwOfs: DIMOFS_BUTTON2;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Button;
       dwOfs: DIMOFS_BUTTON3;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0)
}
    );

  c_dfDIMouse: TDIDataFormat = (
    dwSize: Sizeof(c_dfDIMouse);
    dwObjSize: Sizeof(TDIObjectDataFormat);
    dwFlags: DIDF_RELAXIS;
    dwDataSize: Sizeof(TDIMouseState);
    dwNumObjs: High(_c_dfDIMouse_Objects)+1;
    rgodf: @_c_dfDIMouse_Objects[Low(_c_dfDIMouse_Objects)]
  );


(****************************************************************************
 *
 *      Keyboard
 *
 ****************************************************************************)

type
  TDIKeyboardState = array[0..255] of Byte;

const
  _c_dfDIKeyboard_Objects: array[0..103] of TDIObjectDataFormat = (
    (  pguid: @GUID_Key;
       dwOfs: 1;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 2;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 3;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 4;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 5;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 6;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 7;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 8;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: 9;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $A;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $B;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $C;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $D;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $E;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $F;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $10;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $11;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $12;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $13;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $14;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $15;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $16;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $17;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $18;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $19;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $1A;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $1B;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $1C;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $1D;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $1E;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $1F;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $20;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $21;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $22;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $23;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $24;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $25;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $26;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $27;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $28;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $29;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $2A;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $2B;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $2C;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $2D;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $2E;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $2F;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $30;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $31;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $32;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $33;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $34;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $35;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $36;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $37;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $38;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $39;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $3A;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $3B;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $3C;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $3D;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $3E;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $3F;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $40;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $41;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $42;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $43;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $44;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $45;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $46;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $47;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $48;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $49;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $4A;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $4B;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $4C;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $4D;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $4E;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $4F;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $50;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $51;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $52;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $53;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $57;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $58;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $9C;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $9D;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $B3;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $B5;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $B7;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $B8;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $C7;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $C8;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $C9;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $CB;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $CD;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $CF;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $D0;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $D1;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $D2;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $D3;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $DB;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $DC;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: @GUID_Key;
       dwOfs: $DD;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0)
  );


  c_dfDIKeyboard: TDIDataFormat = (
    dwSize: Sizeof(c_dfDIKeyboard);
    dwObjSize: Sizeof(TDIObjectDataFormat);
    dwFlags: DIDF_RELAXIS;
    dwDataSize: Sizeof(TDIKeyboardState);
    dwNumObjs: High(_c_dfDIKeyboard_Objects)+1;
    rgodf: @_c_dfDIKeyboard_Objects[Low(_c_dfDIKeyboard_Objects)]
  );

(****************************************************************************
 *
 *      DirectInput keyboard scan codes
 *
 ****************************************************************************)

const
  DIK_ESCAPE          = $01;
  DIK_1               = $02;
  DIK_2               = $03;
  DIK_3               = $04;
  DIK_4               = $05;
  DIK_5               = $06;
  DIK_6               = $07;
  DIK_7               = $08;
  DIK_8               = $09;
  DIK_9               = $0A;
  DIK_0               = $0B;
  DIK_MINUS           = $0C;    (* - on main keyboard *)
  DIK_EQUALS          = $0D;
  DIK_BACK            = $0E;    (* backspace *)
  DIK_TAB             = $0F;
  DIK_Q               = $10;
  DIK_W               = $11;
  DIK_E               = $12;
  DIK_R               = $13;
  DIK_T               = $14;
  DIK_Y               = $15;
  DIK_U               = $16;
  DIK_I               = $17;
  DIK_O               = $18;
  DIK_P               = $19;
  DIK_LBRACKET        = $1A;
  DIK_RBRACKET        = $1B;
  DIK_RETURN          = $1C;    (* Enter on main keyboard *)
  DIK_LCONTROL        = $1D;
  DIK_A               = $1E;
  DIK_S               = $1F;
  DIK_D               = $20;
  DIK_F               = $21;
  DIK_G               = $22;
  DIK_H               = $23;
  DIK_J               = $24;
  DIK_K               = $25;
  DIK_L               = $26;
  DIK_SEMICOLON       = $27;
  DIK_APOSTROPHE      = $28;
  DIK_GRAVE           = $29;    (* accent grave *)
  DIK_LSHIFT          = $2A;
  DIK_BACKSLASH       = $2B;
  DIK_Z               = $2C;
  DIK_X               = $2D;
  DIK_C               = $2E;
  DIK_V               = $2F;
  DIK_B               = $30;
  DIK_N               = $31;
  DIK_M               = $32;
  DIK_COMMA           = $33;
  DIK_PERIOD          = $34;    (* . on main keyboard *)
  DIK_SLASH           = $35;    (* / on main keyboard *)
  DIK_RSHIFT          = $36;
  DIK_MULTIPLY        = $37;    (* * on numeric keypad *)
  DIK_LMENU           = $38;    (* left Alt *)
  DIK_SPACE           = $39;
  DIK_CAPITAL         = $3A;
  DIK_F1              = $3B;
  DIK_F2              = $3C;
  DIK_F3              = $3D;
  DIK_F4              = $3E;
  DIK_F5              = $3F;
  DIK_F6              = $40;
  DIK_F7              = $41;
  DIK_F8              = $42;
  DIK_F9              = $43;
  DIK_F10             = $44;
  DIK_NUMLOCK         = $45;
  DIK_SCROLL          = $46;    (* Scroll Lock *)
  DIK_NUMPAD7         = $47;
  DIK_NUMPAD8         = $48;
  DIK_NUMPAD9         = $49;
  DIK_SUBTRACT        = $4A;    (* - on numeric keypad *)
  DIK_NUMPAD4         = $4B;
  DIK_NUMPAD5         = $4C;
  DIK_NUMPAD6         = $4D;
  DIK_ADD             = $4E;    (* + on numeric keypad *)
  DIK_NUMPAD1         = $4F;
  DIK_NUMPAD2         = $50;
  DIK_NUMPAD3         = $51;
  DIK_NUMPAD0         = $52;
  DIK_DECIMAL         = $53;    (* . on numeric keypad *)
  DIK_F11             = $57;
  DIK_F12             = $58;

  DIK_F13             = $64;    (*                     (NEC PC98) *)
  DIK_F14             = $65;    (*                     (NEC PC98) *)
  DIK_F15             = $66;    (*                     (NEC PC98) *)

  DIK_KANA            = $70;    (* (Japanese keyboard)            *)
  DIK_CONVERT         = $79;    (* (Japanese keyboard)            *)
  DIK_NOCONVERT       = $7B;    (* (Japanese keyboard)            *)
  DIK_YEN             = $7D;    (* (Japanese keyboard)            *)
  DIK_NUMPADEQUALS    = $8D;    (* = on numeric keypad (NEC PC98) *)
  DIK_CIRCUMFLEX      = $90;    (* (Japanese keyboard)            *)
  DIK_AT              = $91;    (*                     (NEC PC98) *)
  DIK_COLON           = $92;    (*                     (NEC PC98) *)
  DIK_UNDERLINE       = $93;    (*                     (NEC PC98) *)
  DIK_KANJI           = $94;    (* (Japanese keyboard)            *)
  DIK_STOP            = $95;    (*                     (NEC PC98) *)
  DIK_AX              = $96;    (*                     (Japan AX) *)
  DIK_UNLABELED       = $97;    (*                        (J3100) *)
  DIK_NUMPADENTER     = $9C;    (* Enter on numeric keypad *)
  DIK_RCONTROL        = $9D;
  DIK_NUMPADCOMMA     = $B3;    (* , on numeric keypad (NEC PC98) *)
  DIK_DIVIDE          = $B5;    (* / on numeric keypad *)
  DIK_SYSRQ           = $B7;
  DIK_RMENU           = $B8;    (* right Alt *)
  DIK_HOME            = $C7;    (* Home on arrow keypad *)
  DIK_UP              = $C8;    (* UpArrow on arrow keypad *)
  DIK_PRIOR           = $C9;    (* PgUp on arrow keypad *)
  DIK_LEFT            = $CB;    (* LeftArrow on arrow keypad *)
  DIK_RIGHT           = $CD;    (* RightArrow on arrow keypad *)
  DIK_END             = $CF;    (* End on arrow keypad *)
  DIK_DOWN            = $D0;    (* DownArrow on arrow keypad *)
  DIK_NEXT            = $D1;    (* PgDn on arrow keypad *)
  DIK_INSERT          = $D2;    (* Insert on arrow keypad *)
  DIK_DELETE          = $D3;    (* Delete on arrow keypad *)
  DIK_LWIN            = $DB;    (* Left Windows key *)
  DIK_RWIN            = $DC;    (* Right Windows key *)
  DIK_APPS            = $DD;    (* AppMenu key *)

(*
 *  Alternate names for keys, to facilitate transition from DOS.
 *)
  DIK_BACKSPACE      = DIK_BACK    ;        (* backspace *)
  DIK_NUMPADSTAR     = DIK_MULTIPLY;        (* * on numeric keypad *)
  DIK_LALT           = DIK_LMENU   ;        (* left Alt *)
  DIK_CAPSLOCK       = DIK_CAPITAL ;        (* CapsLock *)
  DIK_NUMPADMINUS    = DIK_SUBTRACT;        (* - on numeric keypad *)
  DIK_NUMPADPLUS     = DIK_ADD     ;        (* + on numeric keypad *)
  DIK_NUMPADPERIOD   = DIK_DECIMAL ;        (* . on numeric keypad *)
  DIK_NUMPADSLASH    = DIK_DIVIDE  ;        (* / on numeric keypad *)
  DIK_RALT           = DIK_RMENU   ;        (* right Alt *)
  DIK_UPARROW        = DIK_UP      ;        (* UpArrow on arrow keypad *)
  DIK_PGUP           = DIK_PRIOR   ;        (* PgUp on arrow keypad *)
  DIK_LEFTARROW      = DIK_LEFT    ;        (* LeftArrow on arrow keypad *)
  DIK_RIGHTARROW     = DIK_RIGHT   ;        (* RightArrow on arrow keypad *)
  DIK_DOWNARROW      = DIK_DOWN    ;        (* DownArrow on arrow keypad *)
  DIK_PGDN           = DIK_NEXT    ;        (* PgDn on arrow keypad *)


(****************************************************************************
 *
 *      Joystick
 *
 ****************************************************************************)


type
  PDIJoyState = ^TDIJoyState;
  TDIJoyState = packed record
    lX: Longint;   (* x-axis position              *)
    lY: Longint;   (* y-axis position              *)
    lZ: Longint;   (* z-axis position              *)
    lRx: Longint;   (* x-axis rotation              *)
    lRy: Longint;   (* y-axis rotation              *)
    lRz: Longint;   (* z-axis rotation              *)
    rglSlider: Array [0..1] of Longint;   (* extra axes positions         *)
    rgdwPOV: Array [0..3] of DWORD;   (* POV directions               *)
    rgbButtons: Array [0..31] of BYTE;   (* 32 buttons                   *)
  end;

  PDIJoyState2 = ^TDIJoyState2;
  TDIJoyState2 = packed record
    lX: Longint;   (* x-axis position              *)
    lY: Longint;   (* y-axis position              *)
    lZ: Longint;   (* z-axis position              *)
    lRx: Longint;   (* x-axis rotation              *)
    lRy: Longint;   (* y-axis rotation              *)
    lRz: Longint;   (* z-axis rotation              *)
    rglSlider: Array [0..1] of Longint;   (* extra axes positions         *)
    rgdwPOV: Array [0..3] of DWORD;   (* POV directions               *)
    rgbButtons: Array [0..127] of BYTE;   (* 128 buttons                  *)
    lVX: Longint;   (* x-axis velocity              *)
    lVY: Longint;   (* y-axis velocity              *)
    lVZ: Longint;   (* z-axis velocity              *)
    lVRx: Longint;   (* x-axis angular velocity      *)
    lVRy: Longint;   (* y-axis angular velocity      *)
    lVRz: Longint;   (* z-axis angular velocity      *)
    rglVSlider: Array [0..1] of Longint;   (* extra axes velocities        *)
    lAX: Longint;   (* x-axis acceleration          *)
    lAY: Longint;   (* y-axis acceleration          *)
    lAZ: Longint;   (* z-axis acceleration          *)
    lARx: Longint;   (* x-axis angular acceleration  *)
    lARy: Longint;   (* y-axis angular acceleration  *)
    lARz: Longint;   (* z-axis angular acceleration  *)
    rglASlider: Array [0..1] of Longint;   (* extra axes accelerations     *)
    lFX: Longint;   (* x-axis force                 *)
    lFY: Longint;   (* y-axis force                 *)
    lFZ: Longint;   (* z-axis force                 *)
    lFRx: Longint;   (* x-axis torque                *)
    lFRy: Longint;   (* y-axis torque                *)
    lFRz: Longint;   (* z-axis torque                *)
    rglFSlider: Array [0..1] of Longint;   (* extra axes forces            *)
  end;

const
  DIJOFS_X  =0;
  DIJOFS_Y  =4;
  DIJOFS_Z  =8;
  DIJOFS_RX =12;
  DIJOFS_RY =16;
  DIJOFS_RZ =20;

function DIJOFS_SLIDER(n: variant) : variant;

function DIJOFS_POV(n: variant) : variant;

function DIJOFS_BUTTON(n: variant) : variant;
const
  DIJOFS_BUTTON_ = 48;

const
  DIJOFS_BUTTON0 = DIJOFS_BUTTON_ + 0;
  DIJOFS_BUTTON1 = DIJOFS_BUTTON_ + 1;
  DIJOFS_BUTTON2 = DIJOFS_BUTTON_ + 2;
  DIJOFS_BUTTON3 = DIJOFS_BUTTON_ + 3;
  DIJOFS_BUTTON4 = DIJOFS_BUTTON_ + 4;
  DIJOFS_BUTTON5 = DIJOFS_BUTTON_ + 5;
  DIJOFS_BUTTON6 = DIJOFS_BUTTON_ + 6;
  DIJOFS_BUTTON7 = DIJOFS_BUTTON_ + 7;
  DIJOFS_BUTTON8 = DIJOFS_BUTTON_ + 8;
  DIJOFS_BUTTON9 = DIJOFS_BUTTON_ + 9;
  DIJOFS_BUTTON10 = DIJOFS_BUTTON_ + 10;
  DIJOFS_BUTTON11 = DIJOFS_BUTTON_ + 11;
  DIJOFS_BUTTON12 = DIJOFS_BUTTON_ + 12;
  DIJOFS_BUTTON13 = DIJOFS_BUTTON_ + 13;
  DIJOFS_BUTTON14 = DIJOFS_BUTTON_ + 14;
  DIJOFS_BUTTON15 = DIJOFS_BUTTON_ + 15;
  DIJOFS_BUTTON16 = DIJOFS_BUTTON_ + 16;
  DIJOFS_BUTTON17 = DIJOFS_BUTTON_ + 17;
  DIJOFS_BUTTON18 = DIJOFS_BUTTON_ + 18;
  DIJOFS_BUTTON19 = DIJOFS_BUTTON_ + 19;
  DIJOFS_BUTTON20 = DIJOFS_BUTTON_ + 20;
  DIJOFS_BUTTON21 = DIJOFS_BUTTON_ + 21;
  DIJOFS_BUTTON22 = DIJOFS_BUTTON_ + 22;
  DIJOFS_BUTTON23 = DIJOFS_BUTTON_ + 23;
  DIJOFS_BUTTON24 = DIJOFS_BUTTON_ + 24;
  DIJOFS_BUTTON25 = DIJOFS_BUTTON_ + 25;
  DIJOFS_BUTTON26 = DIJOFS_BUTTON_ + 26;
  DIJOFS_BUTTON27 = DIJOFS_BUTTON_ + 27;
  DIJOFS_BUTTON28 = DIJOFS_BUTTON_ + 28;
  DIJOFS_BUTTON29 = DIJOFS_BUTTON_ + 29;
  DIJOFS_BUTTON30 = DIJOFS_BUTTON_ + 30;
  DIJOFS_BUTTON31 = DIJOFS_BUTTON_ + 31;


const
  _c_dfDIJoystick_Objects: array[0..1] of TDIObjectDataFormat = (
    (  pguid: nil;
       dwOfs: 0;
       dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: 48;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0)
  );

  c_dfDIJoystick: TDIDataFormat = (
    dwSize: Sizeof(c_dfDIJoystick);
    dwObjSize: Sizeof(TDIObjectDataFormat);
    dwFlags: DIDF_ABSAXIS;
    dwDataSize: SizeOf(TDIJoyState);
    dwNumObjs: High(_c_dfDIJoystick_Objects)+1;
    rgodf: @_c_dfDIJoystick_Objects[Low(_c_dfDIJoystick_Objects)]
  );

  _c_dfDIJoystick2_Objects: array[0..1] of TDIObjectDataFormat = (
    (  pguid: nil;
       dwOfs: 0;
       dwType: DIDFT_AXIS or DIDFT_ANYINSTANCE;
       dwFlags: 0),
    (  pguid: nil;
       dwOfs: 48;
       dwType: DIDFT_BUTTON or DIDFT_ANYINSTANCE;
       dwFlags: 0)
  );

  c_dfDIJoystick2: TDIDataFormat = (
    dwSize: Sizeof(c_dfDIJoystick2);
    dwObjSize: Sizeof(TDIObjectDataFormat);
    dwFlags: DIDF_ABSAXIS;
    dwDataSize: SizeOf(TDIJoyState);
    dwNumObjs: High(_c_dfDIJoystick2_Objects)+1;
    rgodf: @_c_dfDIJoystick2_Objects[Low(_c_dfDIJoystick2_Objects)]
  );

(****************************************************************************
 *
 *  IDirectInput
 *
 ****************************************************************************)


  DIENUM_STOP = 0;
  DIENUM_CONTINUE = 1;

type
  TDIEnumDevicesCallbackA = function (var lpddi: TDIDeviceInstanceA; pvRef: Pointer): BOOL; stdcall;
  TDIEnumDevicesCallbackW = function (var lpddi: TDIDeviceInstanceW; pvRef: Pointer): BOOL; stdcall;
  TDIEnumDevicesCallback = function (var lpddi: TDIDeviceInstance; pvRef: Pointer): BOOL; stdcall;
  TDIEnumDevicesProc = TDIEnumDevicesCallback;

const
  DIEDFL_ALLDEVICES       = $00000000;
  DIEDFL_ATTACHEDONLY     = $00000001;
  DIEDFL_FORCEFEEDBACK    = $00000100;

type

  IDirectInputW = interface (IUnknown)
    ['{89521361-AA8A-11CF-BFC7-444553540000}']
    (*** IDirectInputW methods ***)
    function CreateDevice(const rguid: TGUID; var lplpDirectInputDevice: IDirectInputDeviceW; pUnkOuter: IUnknown) : HResult; StdCall;
    function EnumDevices(dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackW; pvRef: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetDeviceStatus(const rguidInstance: TGUID) : HResult; StdCall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD) : HResult; StdCall;
    function Initialize(hinst: THandle; dwVersion: DWORD) : HResult; StdCall;
  end;

  IDirectInputA = interface (IUnknown)
    ['{89521360-AA8A-11CF-BFC7-444553540000}']
    (*** IDirectInputA methods ***)
    function CreateDevice(const rguid: TGUID; var lplpDirectInputDevice: IDirectInputDeviceA; pUnkOuter: IUnknown) : HResult; StdCall;
    function EnumDevices(dwDevType: DWORD; lpCallback: TDIEnumDevicesCallbackA; pvRef: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetDeviceStatus(const rguidInstance: TGUID) : HResult; StdCall;
    function RunControlPanel(hwndOwner: HWND; dwFlags: DWORD) : HResult; StdCall;
    function Initialize(hinst: THandle; dwVersion: DWORD) : HResult; StdCall;
  end;

{$IFDEF UNICODE}
  IDirectInput = IDirectInputW;
{$ELSE}
  IDirectInput = IDirectInputA;
{$ENDIF}


  IDirectInput2W = interface (IDirectInputW)
    ['{5944E663-AA8A-11CF-BFC7-444553540000}']
    (*** IDirectInput2W methods ***)
    function FindDevice(Arg1: PGUID; Arg2: PWideChar; Arg3: PGUID): HRESULT;
  end;

  IDirectInput2A = interface (IDirectInputA)
    ['{5944E662-AA8A-11CF-BFC7-444553540000}']
    (*** IDirectInput2A methods ***)
    function FindDevice(Arg1: PGUID; Arg2: PAnsiChar; Arg3: PGUID): HRESULT;
  end;

{$IFDEF UNICODE}
  IDirectInput2 = IDirectInput2W;
{$ELSE}
  IDirectInput2 = IDirectInput2A;
{$ENDIF}

var
  DirectInputCreateA : function (hinst: THandle; dwVersion: DWORD; Out ppDI: IDirectInputA; punkOuter: IUnknown) : HResult; StdCall;
  DirectInputCreateW : function (hinst: THandle; dwVersion: DWORD; Out ppDI: IDirectInputW; punkOuter: IUnknown) : HResult; StdCall;
  DirectInputCreate : function (hinst: THandle; dwVersion: DWORD; Out ppDI: IDirectInput; punkOuter: IUnknown) : HResult; StdCall;


(****************************************************************************
 *
 *  Return Codes
 *
 ****************************************************************************)

(*
 *  The operation completed successfully.
 *)
const
  DI_OK = S_OK;

(*
 *  The device exists but is not currently attached.
 *)
  DI_NOTATTACHED = S_FALSE;

(*
 *  The device buffer overflowed.  Some input was lost.
 *)
  DI_BUFFEROVERFLOW = S_FALSE;

(*
 *  The change in device properties had no effect.
 *)
  DI_PROPNOEFFECT = S_FALSE;

(*
 *  The operation had no effect.
 *)
  DI_NOEFFECT = S_FALSE;

(*
 *  The device is a polled device.  As a result, device buffering
 *  will not collect any data and event notifications will not be
 *  signalled until GetDeviceState is called.
 *)
  DI_POLLEDDEVICE = $00000002;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but the effect was not
 *  downloaded because the device is not exclusively acquired
 *  or because the DIEP_NODOWNLOAD flag was passed.
 *)
  DI_DOWNLOADSKIPPED = $00000003;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but in order to change
 *  the parameters, the effect needed to be restarted.
 *)
  DI_EFFECTRESTARTED = $00000004;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but some of them were
 *  beyond the capabilities of the device and were truncated.
 *)
  DI_TRUNCATED = $00000008;

(*
 *  Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.
 *)
  DI_TRUNCATEDANDRESTARTED = $0000000C;

  SEVERITY_ERROR_FACILITY_WIN32 =
      DWORD(SEVERITY_ERROR shl 31) or DWORD(FACILITY_WIN32 shl 16);

(*
 *  The application requires a newer version of DirectInput.
 *)

  DIERR_OLDDIRECTINPUTVERSION = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_OLD_WIN_VERSION;

(*
 *  The application was written for an unsupported prerelease version
 *  of DirectInput.
 *)
  DIERR_BETADIRECTINPUTVERSION = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_RMODE_APP;

(*
 *  The object could not be created due to an incompatible driver version
 *  or mismatched or incomplete driver components.
 *)
  DIERR_BADDRIVERVER = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_BAD_DRIVER_LEVEL;

(*
 * The device or device instance or effect is not registered with DirectInput.
 *)
  DIERR_DEVICENOTREG = REGDB_E_CLASSNOTREG;

(*
 * The requested object does not exist.
 *)
  DIERR_NOTFOUND = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_FILE_NOT_FOUND;

(*
 * The requested object does not exist.
 *)
  DIERR_OBJECTNOTFOUND = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_FILE_NOT_FOUND;

(*
 * An invalid parameter was passed to the returning function,
 * or the object was not in a state that admitted the function
 * to be called.
 *)
  DIERR_INVALIDPARAM = E_INVALIDARG;

(*
 * The specified interface is not supported by the object
 *)
  DIERR_NOINTERFACE = E_NOINTERFACE;

(*
 * An undetermined error occured inside the DInput subsystem
 *)
  DIERR_GENERIC = E_FAIL;

(*
 * The DInput subsystem couldn't allocate sufficient memory to complete the
 * caller's request.
 *)
  DIERR_OUTOFMEMORY = E_OUTOFMEMORY;

(*
 * The function called is not supported at this time
 *)
  DIERR_UNSUPPORTED = E_NOTIMPL;

(*
 * This object has not been initialized
 *)
  DIERR_NOTINITIALIZED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_NOT_READY;

(*
 * This object is already initialized
 *)
  DIERR_ALREADYINITIALIZED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_ALREADY_INITIALIZED;

(*
 * This object does not support aggregation
 *)
  DIERR_NOAGGREGATION = CLASS_E_NOAGGREGATION;

(*
 * Another app has a higher priority level, preventing this call from
 * succeeding.
 *)
  DIERR_OTHERAPPHASPRIO = E_ACCESSDENIED;

(*
 * Access to the device has been lost.  It must be re-acquired.
 *)
  DIERR_INPUTLOST = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_READ_FAULT;

(*
 * The operation cannot be performed while the device is acquired.
 *)
  DIERR_ACQUIRED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_BUSY;

(*
 * The operation cannot be performed unless the device is acquired.
 *)
  DIERR_NOTACQUIRED = SEVERITY_ERROR_FACILITY_WIN32
      or ERROR_INVALID_ACCESS;

(*
 * The specified property cannot be changed.
 *)
  DIERR_READONLY = E_ACCESSDENIED;

(*
 * The device already has an event notification associated with it.
 *)
  DIERR_HANDLEEXISTS = E_ACCESSDENIED;

(*
 * Data is not yet available.
 *)
  E_PENDING = $80070007;

(*
 * Unable to IDirectInputJoyConfig_Acquire because the user
 * does not have sufficient privileges to change the joystick
 * configuration.
 *)
  DIERR_INSUFFICIENTPRIVS = $80040200;

(*
 * The device is full.
 *)
  DIERR_DEVICEFULL = $80040201;

(*
 * Not all the requested information fit into the buffer.
 *)
  DIERR_MOREDATA = $80040202;

(*
 * The effect is not downloaded.
 *)
  DIERR_NOTDOWNLOADED = $80040203;

(*
 *  The device cannot be reinitialized because there are still effects
 *  attached to it.
 *)
  DIERR_HASEFFECTS = $80040204;

(*
 *  The operation cannot be performed unless the device is acquired
 *  in DISCL_EXCLUSIVE mode.
 *)
  DIERR_NOTEXCLUSIVEACQUIRED = $80040205;

(*
 *  The effect could not be downloaded because essential information
 *  is missing.  For example, no axes have been associated with the
 *  effect, or no type-specific information has been created.
 *)
  DIERR_INCOMPLETEEFFECT = $80040206;

(*
 *  Attempted to read buffered device data from a device that is
 *  not buffered.
 *)
  DIERR_NOTBUFFERED = $80040207;

(*
 *  An attempt was made to modify parameters of an effect while it is
 *  playing.  Not all hardware devices support altering the parameters
 *  of an effect while it is playing.
 *)
  DIERR_EFFECTPLAYING = $80040208;


(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current sdk files
 *
 ****************************************************************************)

(*
 * Flag to indicate that the dwReserved2 field of the JOYINFOEX structure
 * contains mini-driver specific data to be passed by VJoyD to the mini-
 * driver instead of doing a poll.
 *)
  JOY_PASSDRIVERDATA          = $10000000;

(*
 * Informs the joystick driver that the configuration has been changed
 * and should be reloaded from the registery.
 * dwFlags is reserved and should be set to zero
 *)

function joyConfigChanged(dwFlags: DWORD) : MMRESULT; stdcall;

const
(*
 * Hardware Setting indicating that the device is a headtracker
 *)
  JOY_HWS_ISHEADTRACKER       = $02000000;

(*
 * Hardware Setting indicating that the VxD is used to replace
 * the standard analog polling
 *)
  JOY_HWS_ISGAMEPORTDRIVER    = $04000000;

(*
 * Hardware Setting indicating that the driver needs a standard
 * gameport in order to communicate with the device.
 *)
  JOY_HWS_ISANALOGPORTDRIVER  = $08000000;

(*
 * Hardware Setting indicating that VJoyD should not load this
 * driver, it will be loaded externally and will register with
 * VJoyD of it's own accord.
 *)
  JOY_HWS_AUTOLOAD            = $10000000;

(*
 * Hardware Setting indicating that the driver acquires any 
 * resources needed without needing a devnode through VJoyD.
 *)
  JOY_HWS_NODEVNODE           = $20000000;

(*
 * Hardware Setting indicating that the VxD can be used as
 * a port 201h emulator.
 *)
  JOY_HWS_ISGAMEPORTEMULATOR  = $40000000;


(*
 * Usage Setting indicating that the settings are volatile and
 * should be removed if still present on a reboot.
 *)
  JOY_US_VOLATILE             = $00000008;

(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current ddk files
 *
 ****************************************************************************)

(*
 * Poll type in which the do_other field of the JOYOEMPOLLDATA
 * structure contains mini-driver specific data passed from an app.
 *)
  JOY_OEMPOLL_PASSDRIVERDATA  = 7;

(******************************************************************************)
(**                                                                          **)
(** DPlay.Pas                                                                **)
(**                                                                          **)
(******************************************************************************)

type
{$IFDEF UNICODE}
  PCharAW = PWideChar;
{$ELSE}
  PCharAW = PAnsiChar;
{$ENDIF}

const
(*
 * GUIDS used by DirectPlay objects
 *)
  IID_IDirectPlay2W: TGUID =
      (D1:$2b74f7c0;D2:$9154;D3:$11cf;D4:($a9,$cd,$00,$aa,$00,$68,$86,$e3));
  IID_IDirectPlay2A: TGUID =
      (D1:$9d460580;D2:$a822;D3:$11cf;D4:($96,$0c,$00,$80,$c7,$53,$4e,$82));
{$IFDEF UNICODE}
  IID_IDirectPlay2: TGUID =
      (D1:$2b74f7c0;D2:$9154;D3:$11cf;D4:($a9,$cd,$00,$aa,$00,$68,$86,$e3));
{$ELSE}
  IID_IDirectPlay2: TGUID =
      (D1:$9d460580;D2:$a822;D3:$11cf;D4:($96,$0c,$00,$80,$c7,$53,$4e,$82));
{$ENDIF}

  IID_IDirectPlay3W: TGUID =
      (D1:$133efe40;D2:$32dc;D3:$11d0;D4:($9c,$fb,$00,$a0,$c9,$0a,$43,$cb));
  IID_IDirectPlay3A: TGUID =
      (D1:$133efe41;D2:$32dc;D3:$11d0;D4:($9c,$fb,$00,$a0,$c9,$0a,$43,$cb));
{$IFDEF UNICODE}
  IID_IDirectPlay3: TGUID =
      (D1:$133efe40;D2:$32dc;D3:$11d0;D4:($9c,$fb,$00,$a0,$c9,$0a,$43,$cb));
{$ELSE}
  IID_IDirectPlay3: TGUID =
      (D1:$133efe41;D2:$32dc;D3:$11d0;D4:($9c,$fb,$00,$a0,$c9,$0a,$43,$cb));
{$ENDIF}

  IID_IDirectPlay4W: TGUID =
      (D1:$0ab1c530;D2:$4745;D3:$11d1;D4:($a7,$a1,$00,$00,$f8,$03,$ab,$fc));
  IID_IDirectPlay4A: TGUID =
      (D1:$0ab1c531;D2:$4745;D3:$11d1;D4:($a7,$a1,$00,$00,$f8,$03,$ab,$fc));
{$IFDEF UNICODE}
  IID_IDirectPlay4: TGUID =
      (D1:$0ab1c530;D2:$4745;D3:$11d1;D4:($a7,$a1,$00,$00,$f8,$03,$ab,$fc));
{$ELSE}
  IID_IDirectPlay4: TGUID =
      (D1:$0ab1c531;D2:$4745;D3:$11d1;D4:($a7,$a1,$00,$00,$f8,$03,$ab,$fc));
{$ENDIF}

// {D1EB6D20-8923-11d0-9D97-00A0C90A43CB}
  CLSID_DirectPlay: TGUID =
      (D1:$d1eb6d20;D2:$8923;D3:$11d0;D4:($9d,$97,$00,$a0,$c9,$a,$43,$cb));
  IID_IDirectPlay: TGUID =
      (D1:$5454e9a0;D2:$db65;D3:$11ce;D4:($92,$1c,$00,$aa,$00,$6c,$49,$72));

(*
 * GUIDS used by Service Providers shipped with DirectPlay
 * Use these to identify Service Provider returned by EnumConnections
 *)

// GUID for IPX service provider
// {685BC400-9D2C-11cf-A9CD-00AA006886E3}
  DPSPGUID_IPX: TGUID =
      (D1:$685bc400;D2:$9d2c;D3:$11cf;D4:($a9,$cd,$00,$aa,$00,$68,$86,$e3));

// GUID for TCP/IP service provider
// 36E95EE0-8577-11cf-960C-0080C7534E82
  DPSPGUID_TCPIP: TGUID =
      (D1:$36E95EE0;D2:$8577;D3:$11cf;D4:($96,$0c,$00,$80,$c7,$53,$4e,$82));

// GUID for Serial service provider
// {0F1D6860-88D9-11cf-9C4E-00A0C905425E}
  DPSPGUID_SERIAL: TGUID =
      (D1:$f1d6860;D2:$88d9;D3:$11cf;D4:($9c,$4e,$00,$a0,$c9,$05,$42,$5e));

// GUID for Modem service provider
// {44EAA760-CB68-11cf-9C4E-00A0C905425E}
  DPSPGUID_MODEM: TGUID =
      (D1:$44eaa760;D2:$cb68;D3:$11cf;D4:($9c,$4e,$00,$a0,$c9,$05,$42,$5e));


(****************************************************************************
 *
 * DirectPlay Structures
 *
 * Various structures used to invoke DirectPlay.
 *
 ****************************************************************************)

type
(*
 * TDPID
 * DirectPlay player and group ID
 *)
  TDPID = DWORD;
  PDPID = ^TDPID;


const
(*
 * DPID that system messages come from
 *)
  DPID_SYSMSG = 0;

(*
 * DPID representing all players in the session
 *)
  DPID_ALLPLAYERS = 0;

(*
 * DPID representing the server player
 *)
  DPID_SERVERPLAYER = 1;

(*
 * DPID representing the maximum ID in the range of DPID's reserved for
 * use by DirectPlay.
 *)
  DPID_RESERVEDRANGE = 100;

(*
 * The player ID is unknown (used with e.g. DPSESSION_NOMESSAGEID)
 *)
  DPID_UNKNOWN = $FFFFFFFF;

type
(*
 * DPCAPS
 * Used to obtain the capabilities of a DirectPlay object
 *)
  PDPCaps = ^TDPCaps;
  TDPCaps = packed record
    dwSize: DWORD;              // Size of structure, in bytes
    dwFlags: DWORD;             // DPCAPS_xxx flags
    dwMaxBufferSize: DWORD;     // Maximum message size, in bytes,  for this service provider
    dwMaxQueueSize: DWORD;      // Obsolete.
    dwMaxPlayers: DWORD;        // Maximum players/groups (local + remote)
    dwHundredBaud: DWORD;       // Bandwidth in 100 bits per second units;
                                // i.e. 24 is 2400, 96 is 9600, etc.
    dwLatency: DWORD;           // Estimated latency; 0 = unknown
    dwMaxLocalPlayers: DWORD;   // Maximum # of locally created players allowed
    dwHeaderLength: DWORD;      // Maximum header length, in bytes, on messages
                                // added by the service provider
    dwTimeout: DWORD;           // Service provider's suggested timeout value
                                // This is how long DirectPlay will wait for
                                // responses to system messages
  end;

const
(*
 * This DirectPlay object is the session host.  If the host exits the
 * session, another application will become the host and receive a
 * DPSYS_HOST system message.
 *)
  DPCAPS_ISHOST = $00000002;

(*
 * The service provider bound to this DirectPlay object can optimize
 * group messaging.
 *)
  DPCAPS_GROUPOPTIMIZED = $00000008;

(*
 * The service provider bound to this DirectPlay object can optimize
 * keep alives (see DPSESSION_KEEPALIVE)
 *)
  DPCAPS_KEEPALIVEOPTIMIZED = $00000010;

(*
 * The service provider bound to this DirectPlay object can optimize
 * guaranteed message delivery.
 *)
  DPCAPS_GUARANTEEDOPTIMIZED = $00000020;

(*
 * This DirectPlay object supports guaranteed message delivery.
 *)
  DPCAPS_GUARANTEEDSUPPORTED = $00000040;

(*
 * This DirectPlay object supports digital signing of messages.
 *)
  DPCAPS_SIGNINGSUPPORTED = $00000080;

(*
 * This DirectPlay object supports encryption of messages.
 *)
  DPCAPS_ENCRYPTIONSUPPORTED = $00000100;

(*
 * This DirectPlay player was created on this machine
 *)
  DPPLAYERCAPS_LOCAL = $00000800;

(*
 * Current Open settings supports all forms of Cancel
 *)
  DPCAPS_ASYNCCANCELSUPPORTED = $00001000;

(*
 * Current Open settings supports CancelAll, but not Cancel
 *)
  DPCAPS_ASYNCCANCELALLSUPPORTED = $00002000;

(*
 * Current Open settings supports Send Timeouts for sends
 *)
  DPCAPS_SENDTIMEOUTSUPPORTED = $00004000;

(*
 * Current Open settings supports send priority
 *)
  DPCAPS_SENDPRIORITYSUPPORTED = $00008000;

(*
 * Current Open settings supports DPSEND_ASYNC flag
 *)
  DPCAPS_ASYNCSUPPORTED = $00010000;

type
(*
 * TDPSessionDesc2
 * Used to describe the properties of a DirectPlay
 * session instance
 *)
  PDPSessionDesc2 = ^TDPSessionDesc2;
  TDPSessionDesc2 = packed record
    dwSize: DWORD;             // Size of structure
    dwFlags: DWORD;            // DPSESSION_xxx flags
    guidInstance: TGUID;       // ID for the session instance
    guidApplication: TGUID;    // GUID of the DirectPlay application.
                               // GUID_NULL for all applications.
    dwMaxPlayers: DWORD;       // Maximum # players allowed in session
    dwCurrentPlayers: DWORD;   // Current # players in session (read only)
    case integer of
      0 : (
    lpszSessionName: PCharAW;  // Name of the session
    lpszPassword: PCharAW;     // Password of the session (optional)
    dwReserved1: DWORD;        // Reserved for future MS use.
    dwReserved2: DWORD;
    dwUser1: DWORD;            // For use by the application
    dwUser2: DWORD;
    dwUser3: DWORD;
    dwUser4: DWORD;
      );
      1 : (
    lpszSessionNameA: PAnsiChar;   // Name of the session
    lpszPasswordA: PAnsiChar       // Password of the session (optional)
      );
      2 : (
    lpszSessionNameW: PWideChar;
    lpszPasswordW: PWideChar
      );
  end;

const
(*
 * Applications cannot create new players in this session.
 *)
  DPSESSION_NEWPLAYERSDISABLED = $00000001;

(*
 * If the DirectPlay object that created the session, the host,
 * quits, then the host will attempt to migrate to another
 * DirectPlay object so that new players can continue to be created
 * and new applications can join the session.
 *)
  DPSESSION_MIGRATEHOST = $00000004;

(*
 * This flag tells DirectPlay not to set the idPlayerTo and idPlayerFrom
 * fields in player messages.  This cuts two DWORD's off the message
 * overhead.
 *)
  DPSESSION_NOMESSAGEID = $00000008;

(*
 * This flag tells DirectPlay to not allow any new applications to
 * join the session.  Applications already in the session can still
 * create new players.
 *)
  DPSESSION_JOINDISABLED = $00000020;

(*
 * This flag tells DirectPlay to detect when remote players 
 * exit abnormally (e.g. their computer or modem gets unplugged)
 *)
  DPSESSION_KEEPALIVE = $00000040;

(*
 * This flag tells DirectPlay not to send a message to all players
 * when a players remote data changes
 *)
  DPSESSION_NODATAMESSAGES = $00000080;

(*
 * This flag indicates that the session belongs to a secure server
 * and needs user authentication
 *)
  DPSESSION_SECURESERVER = $00000100;

(*
 * This flag indicates that the session is private and requirs a password
 * for EnumSessions as well as Open.
 *)
  DPSESSION_PRIVATE = $00000200;

(*
 * This flag indicates that the session requires a password for joining.
 *)
  DPSESSION_PASSWORDREQUIRED = $00000400;

(*
 * This flag tells DirectPlay to route all messages through the server
 *)
  DPSESSION_MULTICASTSERVER = $00000800;

(*
 * This flag tells DirectPlay to only download information about the
 * DPPLAYER_SERVERPLAYER.
 *)
  DPSESSION_CLIENTSERVER = $00001000;

(*
 * This flag tells DirectPlay to use the protocol built into dplay
 * for reliability and statistics all the time.  When this bit is
 * set, only other sessions with this bit set can join or be joined.
 *)
  DPSESSION_DIRECTPLAYPROTOCOL = $00002000;

(*
 * This flag tells DirectPlay that preserving order of received
 * packets is not important, when using reliable delivery.  This
 * will allow messages to be indicated out of order if preceding
 * messages have not yet arrived.  Otherwise DPLAY will wait for
 * earlier messages before delivering later reliable messages.
 *)
  DPSESSION_NOPRESERVEORDER = $00004000;

  
(*
 * This flag tells DirectPlay to optimize communication for latency
 *)
  DPSESSION_OPTIMIZELATENCY = $00008000;

type
(*
 * TDPName
 * Used to hold the name of a DirectPlay entity
 * like a player or a group
 *)
  PDPName = ^TDPName;
  TDPName = packed record
    dwSize: DWORD;    // Size of structure
    dwFlags: DWORD;   // Not used. Must be zero.
    case Integer of
      0 : (
    lpszShortName : PCharAW; // The short or friendly name
    lpszLongName : PCharAW;  // The long or formal name
      );
      1 : (
    lpszShortNameA : PAnsiChar;
    lpszLongNameA : PAnsiChar;
      );
      2 : (
    lpszShortNameW : PWideChar;
    lpszLongNameW : PWideChar;
      );
  end;

(*
 * TDPCredentials
 * Used to hold the user name and password of a DirectPlay user
 *)

  PDPCredentials = ^TDPCredentials;
  TDPCredentials = packed record
    dwSize: DWORD;    // Size of structure
    dwFlags: DWORD;   // Not used. Must be zero.
    case Integer of
      0 : (
    lpszUsername: PCharAW;   // User name of the account
    lpszPassword: PCharAW;   // Password of the account
    lpszDomain:   PCharAW;   // Domain name of the account
      );
      1 : (
    lpszUsernameA: PAnsiChar;   // User name of the account
    lpszPasswordA: PAnsiChar;   // Password of the account
    lpszDomainA:   PAnsiChar;   // Domain name of the account
      );
      2 : (
    lpszUsernameW: PWideChar;   // User name of the account
    lpszPasswordW: PWideChar;   // Password of the account
    lpszDomainW:   PWideChar;   // Domain name of the account
      );
  end;

(*
 * TDPSecurityDesc
 * Used to describe the security properties of a DirectPlay
 * session instance
 *)
  PDPSecurityDesc = ^TDPSecurityDesc;
  TDPSecurityDesc = packed record
    dwSize: DWORD;                  // Size of structure
    dwFlags: DWORD;                 // Not used. Must be zero.
    case Integer of
      0 : (
    lpszSSPIProvider : PCharAW;  // SSPI provider name
    lpszCAPIProvider : PCharAW;  // CAPI provider name
    dwCAPIProviderType: DWORD;      // Crypto Service Provider type
    dwEncryptionAlgorithm: DWORD;   // Encryption Algorithm type
      );
      1 : (
    lpszSSPIProviderA : PAnsiChar;  // SSPI provider name
    lpszCAPIProviderA : PAnsiChar;  // CAPI provider name
      );
      2 : (
    lpszSSPIProviderW : PWideChar;  // SSPI provider name
    lpszCAPIProviderW : PWideChar;  // CAPI provider name
      );
  end;

(*
 * DPACCOUNTDESC
 * Used to describe a user membership account
 *)

  PDPAccountDesc = ^TDPAccountDesc;
  TDPAccountDesc = packed record
    dwSize: DWORD;    // Size of structure
    dwFlags: DWORD;   // Not used. Must be zero.
    case Integer of
      0 : (lpszAccountID : PCharAW);  // Account identifier
      1 : (lpszAccountIDA : PAnsiChar); 
      2 : (lpszAccountIDW : PWideChar);
  end;

(*
 * TDPLConnection
 * Used to hold all in the informaion needed to connect
 * an application to a session or create a session
 *)
  PDPLConnection = ^TDPLConnection;
  TDPLConnection = packed record
    dwSize: DWORD;                     // Size of this structure
    dwFlags: DWORD;                    // Flags specific to this structure
    lpSessionDesc: PDPSessionDesc2;    // Pointer to session desc to use on connect
    lpPlayerName: PDPName;             // Pointer to Player name structure
    guidSP: TGUID;                     // GUID of the DPlay SP to use
    lpAddress: Pointer;                // Address for service provider
    dwAddressSize: DWORD;              // Size of address data
  end;

(*
 * TDPChat
 * Used to hold the a DirectPlay chat message
 *)
  PDPChat = ^TDPChat;
  TDPChat = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    case Integer of
      0 : (lpszMessage : PCharAW);  // Message string
      1 : (lpszMessageA : PAnsiChar);
      2 : (lpszMessageW : PWideChar);  
  end;

(*
 * TSGBuffer
 * Scatter Gather Buffer used for SendEx
 *)
  PSGBuffer = ^TSGBuffer;
  TSGBuffer = packed record
    len: UINT;
    pData: PUCHAR;
  end;

(****************************************************************************
 *
 * Prototypes for DirectPlay callback functions
 *
 ****************************************************************************)

(*
 * Callback for IDirectPlay2::EnumSessions
 *)
  TDPEnumSessionsCallback2 = function(var lpThisSD: TDPSessionDesc2;
      var lpdwTimeOut: DWORD; dwFlags: DWORD; lpContext: Pointer) : BOOL;
      stdcall;

const
(*
 * This flag is set on the EnumSessions callback dwFlags parameter when
 * the time out has occurred. There will be no session data for this
 * callback. If *lpdwTimeOut is set to a non-zero value and the
 * EnumSessionsCallback function returns TRUE then EnumSessions will
 * continue waiting until the next timeout occurs. Timeouts are in
 * milliseconds.
 *)
  DPESC_TIMEDOUT = $00000001;

type
(*
 * Callback for IDirectPlay2.EnumPlayers
 *              IDirectPlay2.EnumGroups
 *              IDirectPlay2.EnumGroupPlayers
 *)
  TDPEnumPlayersCallback2 = function(DPID: TDPID; dwPlayerType: DWORD;
      var lpName: TDPName; dwFlags: DWORD; lpContext: Pointer) : BOOL;
      stdcall;


(*
 * ANSI callback for DirectPlayEnumerate
 * This callback prototype will be used if compiling
 * for ANSI strings
 *)
  TDPEnumDPCallbackA = function(var lpguidSP: TGUID; lpSPName: PAnsiChar;
      dwMajorVersion: DWORD; dwMinorVersion: DWORD; lpContext: Pointer) :
      BOOL; stdcall;

(*
 * Unicode callback for DirectPlayEnumerate
 * This callback prototype will be used if compiling
 * for Unicode strings
 *)
  TDPEnumDPCallbackW = function(var lpguidSP: TGUID; lpSPName: PWideChar;
      dwMajorVersion: DWORD; dwMinorVersion: DWORD; lpContext: Pointer) :
      BOOL; stdcall;

(*
 * Callback for DirectPlayEnumerate
 *)
{$IFDEF UNICODE}
  TDPEnumDPCallback = TDPEnumDPCallbackW;
{$ELSE}
  TDPEnumDPCallback = TDPEnumDPCallbackA;
{$ENDIF}

(*
 * Callback for IDirectPlay3(A/W).EnumConnections
 *)
  TDPEnumConnectionsCallback = function(var lpguidSP: TGUID;
      lpConnection: Pointer; dwConnectionSize: DWORD; var lpName: TDPName;
      dwFlags: DWORD; lpContext: Pointer) : BOOL; stdcall;

(*
 * API's
 *)

var
  DirectPlayEnumerate : function (lpEnumDPCallback: TDPEnumDPCallback;
      lpContext: Pointer) : HResult; StdCall;
  DirectPlayEnumerateA : function (lpEnumDPCallback: TDPEnumDPCallbackA;
      lpContext: Pointer) : HResult; StdCall;
  DirectPlayEnumerateW : function (lpEnumDPCallback: TDPEnumDPCallbackW;
      lpContext: Pointer) : HResult; StdCall;


(****************************************************************************
 *
 * IDirectPlay2 (and IDirectPlay2A) Interface
 *
 ****************************************************************************)

type
  IDirectPlay2AW = interface (IUnknown)
    (*** IDirectPlay2 methods ***)
    function AddPlayerToGroup(idGroup: TDPID; idPlayer: TDPID) : HResult; StdCall;
    function Close: HResult;
    function CreateGroup(var lpidGroup: TDPID; lpGroupName: PDPName; lpData: Pointer; dwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function CreatePlayer(var lpidPlayer: TDPID; pPlayerName: PDPName; hEvent: THandle; lpData: Pointer; dwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function DeletePlayerFromGroup(idGroup: TDPID; idPlayer: TDPID) : HResult; StdCall;
    function DestroyGroup(idGroup: TDPID) : HResult; StdCall;
    function DestroyPlayer(idPlayer: TDPID) : HResult; StdCall;
    function EnumGroupPlayers(idGroup: TDPID; lpguidInstance: PGUID; lpEnumPlayersCallback2: TDPEnumPlayersCallback2; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumGroups(lpguidInstance: PGUID; lpEnumPlayersCallback2: TDPEnumPlayersCallback2; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumPlayers(lpguidInstance: PGUID; lpEnumPlayersCallback2: TDPEnumPlayersCallback2; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumSessions(var lpsd: TDPSessionDesc2; dwTimeout: DWORD; lpEnumSessionsCallback2: TDPEnumSessionsCallback2; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetCaps(var lpDPCaps: TDPCaps; dwFlags: DWORD) : HResult; StdCall;
    function GetGroupData(idGroup: TDPID; lpData: Pointer; var lpdwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function GetGroupName(idGroup: TDPID; lpData: Pointer; var lpdwDataSize: DWORD) : HResult; StdCall;
    function GetMessageCount(idPlayer: TDPID; var lpdwCount: DWORD) : HResult; StdCall;
    function GetPlayerAddress(idPlayer: TDPID; lpAddress: Pointer; var lpdwAddressSize: DWORD) : HResult; StdCall;
    function GetPlayerCaps(idPlayer: TDPID; var lpPlayerCaps: TDPCaps; dwFlags: DWORD) : HResult; StdCall;
    function GetPlayerData(idPlayer: TDPID; lpData: Pointer; var lpdwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function GetPlayerName(idPlayer: TDPID; lpData: Pointer; var lpdwDataSize: DWORD) : HResult; StdCall;
    function GetSessionDesc(lpData: Pointer; var lpdwDataSize: DWORD) : HResult; StdCall;
    function Initialize(const lpGUID: TGUID) : HResult; StdCall;
    function Open(var lpsd: TDPSessionDesc2; dwFlags: DWORD) : HResult; StdCall;
    function Receive(var lpidFrom: TDPID; var lpidTo: TDPID; dwFlags: DWORD; lpData: Pointer; var lpdwDataSize: DWORD) : HResult; StdCall;
    function Send(idFrom: TDPID; lpidTo: TDPID; dwFlags: DWORD; var lpData; lpdwDataSize: DWORD) : HResult; StdCall;
    function SetGroupData(idGroup: TDPID; lpData: Pointer; dwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function SetGroupName(idGroup: TDPID; lpGroupName: PDPName; dwFlags: DWORD) : HResult; StdCall;
    function SetPlayerData(idPlayer: TDPID; lpData: Pointer; dwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function SetPlayerName(idPlayer: TDPID; lpPlayerName: PDPName; dwFlags: DWORD) : HResult; StdCall;
    function SetSessionDesc(var lpSessDesc: TDPSessionDesc2; dwFlags: DWORD) : HResult; StdCall;
  end;

  IDirectPlay2W = interface (IDirectPlay2AW)
    ['{2B74F7C0-9154-11CF-A9CD-00AA006886E3}']
  end;
  IDirectPlay2A = interface (IDirectPlay2AW)
    ['{9d460580-a822-11cf-960c-0080c7534e82}']
  end;

{$IFDEF UNICODE}
  IDirectPlay2 = IDirectPlay2W;
{$ELSE}
  IDirectPlay2 = IDirectPlay2A;
{$ENDIF}

(****************************************************************************
 *
 * IDirectPlay3 (and IDirectPlay3A) Interface
 *
 ****************************************************************************)

  IDirectPlay3AW = interface (IDirectPlay2AW)
    (*** IDirectPlay3 methods ***)
    function AddGroupToGroup(idParentGroup: TDPID; idGroup: TDPID) : HResult; StdCall;
    function CreateGroupInGroup(idParentGroup: TDPID; var lpidGroup: TDPID; lpGroupName: PDPName; lpData: Pointer; dwDataSize: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function DeleteGroupFromGroup(idParentGroup: TDPID; idGroup: TDPID) : HResult; StdCall;
    function EnumConnections(lpguidApplication: PGUID; lpEnumCallback: TDPEnumConnectionsCallback; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumGroupsInGroup(idGroup: TDPID; lpguidInstance: PGUID; lpEnumPlayersCallback2: TDPEnumPlayersCallback2; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetGroupConnectionSettings(dwFlags: DWORD; idGroup: TDPID; lpData: Pointer; var lpdwDataSize: DWORD) : HResult; StdCall;
    function InitializeConnection(var lpConnection; dwFlags: DWORD) : HResult; StdCall;
    function SecureOpen(var lpsd: TDPSessionDesc2; dwFlags: DWORD; var lpSecurity: TDPSecurityDesc; var lpCredentials: TDPCredentials) : HResult; StdCall;
    function SendChatMessage(idFrom: TDPID; idTo: TDPID; dwFlags: DWORD; var lpChatMessage: TDPChat) : HResult; StdCall;
    function SetGroupConnectionSettings(dwFlags: DWORD; idGroup: TDPID; var lpConnection: TDPLConnection) : HResult; StdCall;
    function StartSession(dwFlags: DWORD; idGroup: TDPID) : HResult; StdCall;
    function GetGroupFlags(idGroup: TDPID; var lpdwFlags: DWORD) : HResult; StdCall;
    function GetGroupParent(idGroup: TDPID; var lpidParent: TDPID) : HResult; StdCall;
    function GetPlayerAccount(idPlayer: TDPID; dwFlags: DWORD; var lpData; var lpdwDataSize: DWORD) : HResult; StdCall;
    function GetPlayerFlags(idPlayer: TDPID; var lpdwFlags: DWORD) : HResult; StdCall;
  end;


  IDirectPlay3W = interface (IDirectPlay3AW)
    ['{133EFE40-32DC-11D0-9CFB-00A0C90A43CB}']
  end;
  IDirectPlay3A = interface (IDirectPlay3AW)
    ['{133efe41-32dc-11d0-9cfb-00a0c90a43cb}']
  end;

{$IFDEF UNICODE}
  IDirectPlay3 = IDirectPlay3W;
{$ELSE}
  IDirectPlay3 = IDirectPlay3A;
{$ENDIF}


(****************************************************************************
 *
 * IDirectPlay4 (and IDirectPlay4A) Interface
 *
 ****************************************************************************)

  IDirectPlay4AW = interface (IDirectPlay3AW)
    (*** IDirectPlay4 methods ***)
    function GetGroupOwner(idGroup: TDPID; var idOwner: TDPID) : HResult; StdCall;
    function SetGroupOwner(idGroup: TDPID; idOwner: TDPID) : HResult; StdCall;
    function SendEx(idFrom: TDPID; idTo: TDPID; dwFlags: DWORD; lpData: Pointer; dwDataSize: DWORD; dwPriority: DWORD; dwTimeout: DWORD; lpContext: Pointer; lpdwMsgId: PDWORD) : HResult; StdCall;
    function GetMessageQueue(idFrom: TDPID; idTo: TDPID; dwFlags: DWORD; lpdwNumMsgs: PDWORD; lpdwNumBytes: PDWORD) : HResult; StdCall;
    function CancelMessage(dwMessageID: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function CancelPriority(dwMinPriority: DWORD; dwMaxPriority: DWORD; dwFlags: DWORD) : HResult; StdCall;
  end;


  IDirectPlay4W = interface (IDirectPlay4AW)
    ['{0ab1c530-4745-11D1-a7a1-0000f803abfc}']
  end;
  IDirectPlay4A = interface (IDirectPlay4AW)
    ['{0ab1c531-4745-11D1-a7a1-0000f803abfc}']
  end;

{$IFDEF UNICODE}
  IDirectPlay4 = IDirectPlay4W;
{$ELSE}
  IDirectPlay4 = IDirectPlay4A;
{$ENDIF}


const
(****************************************************************************
 *
 * EnumConnections API flags
 *
 ****************************************************************************)

(*
 * Enumerate Service Providers
 *)
  DPCONNECTION_DIRECTPLAY = $00000001;

(*
 * Enumerate Lobby Providers
 *)
  DPCONNECTION_DIRECTPLAYLOBBY = $00000002;

(****************************************************************************
 *
 * EnumPlayers API flags
 *
 ****************************************************************************)

(*
 * Enumerate all players in the current session
 *)
  DPENUMPLAYERS_ALL = $00000000;
  DPENUMGROUPS_ALL = DPENUMPLAYERS_ALL;

(*
 * Enumerate only local (created by this application) players
 * or groups
 *)
  DPENUMPLAYERS_LOCAL = $00000008;
  DPENUMGROUPS_LOCAL = DPENUMPLAYERS_LOCAL;

(*
 * Enumerate only remote (non-local) players
 * or groups
 *)
  DPENUMPLAYERS_REMOTE = $00000010;
  DPENUMGROUPS_REMOTE = DPENUMPLAYERS_REMOTE;

(*
 * Enumerate groups along with the players
 *)
  DPENUMPLAYERS_GROUP = $00000020;

(*
 * Enumerate players or groups in another session 
 * (must supply lpguidInstance)
 *)
  DPENUMPLAYERS_SESSION = $00000080;
  DPENUMGROUPS_SESSION = DPENUMPLAYERS_SESSION;

(*
 * Enumerate server players
 *)
  DPENUMPLAYERS_SERVERPLAYER = $00000100;

(*
 * Enumerate spectator players
 *)
  DPENUMPLAYERS_SPECTATOR = $00000200;

(*
 * Enumerate shortcut groups
 *)
  DPENUMGROUPS_SHORTCUT = $00000400;

(*
 * Enumerate staging area groups
 *)
  DPENUMGROUPS_STAGINGAREA = $00000800;

(*
 * Enumerate hidden groups
 *)
  DPENUMGROUPS_HIDDEN = $00001000;

(*
 * Enumerate the group's owner
 *)
  DPENUMPLAYERS_OWNER = $00002000;

(****************************************************************************
 *
 * CreatePlayer API flags
 *
 ****************************************************************************)

(*
 * This flag indicates that this player should be designated
 * the server player. The app should specify this at CreatePlayer.
 *)
  DPPLAYER_SERVERPLAYER = DPENUMPLAYERS_SERVERPLAYER;

(*
 * This flag indicates that this player should be designated
 * a spectator. The app should specify this at CreatePlayer.
 *)
  DPPLAYER_SPECTATOR = DPENUMPLAYERS_SPECTATOR;

(*
 * This flag indicates that this player was created locally.
 * (returned from GetPlayerFlags)
 *)
  DPPLAYER_LOCAL = DPENUMPLAYERS_LOCAL;

(*
 * This flag indicates that this player is the group's owner
 * (Only returned in EnumGroupPlayers)
 *)
  DPPLAYER_OWNER = DPENUMPLAYERS_OWNER;

(****************************************************************************
 *
 * CreateGroup API flags
 *
 ****************************************************************************)

(*
 * This flag indicates that the StartSession can be called on the group.
 * The app should specify this at CreateGroup, or CreateGroupInGroup.
 *)
  DPGROUP_STAGINGAREA = DPENUMGROUPS_STAGINGAREA;

(*
 * This flag indicates that this group was created locally.
 * (returned from GetGroupFlags)
 *)
  DPGROUP_LOCAL = DPENUMGROUPS_LOCAL;

(*
 * This flag indicates that this group was created hidden.
 *)
  DPGROUP_HIDDEN = DPENUMGROUPS_HIDDEN;

(****************************************************************************
 *
 * EnumSessions API flags
 *
 ****************************************************************************)

(*
 * Enumerate sessions which can be joined
 *)
  DPENUMSESSIONS_AVAILABLE = $00000001;

(*
 * Enumerate all sessions even if they can't be joined.
 *)
  DPENUMSESSIONS_ALL = $00000002;

(*
 * Start an asynchronous enum sessions
 *)
  DPENUMSESSIONS_ASYNC = $00000010;

(*
 * Stop an asynchronous enum sessions
 *)
  DPENUMSESSIONS_STOPASYNC = $00000020;

(*
 * Enumerate sessions even if they require a password
 *)
  DPENUMSESSIONS_PASSWORDREQUIRED = $00000040;

(*
 * Return status about progress of enumeration instead of
 * showing any status dialogs.
 *)
  DPENUMSESSIONS_RETURNSTATUS = $00000080;

(****************************************************************************
 *
 * GetCaps and GetPlayerCaps API flags
 *
 ****************************************************************************)

(*
 * The latency returned should be for guaranteed message sending.
 * Default is non-guaranteed messaging.
 *)
  DPGETCAPS_GUARANTEED = $00000001;

(****************************************************************************
 *
 * GetGroupData, GetPlayerData API flags
 * Remote and local Group/Player data is maintained separately. 
 * Default is DPGET_REMOTE.
 *
 ****************************************************************************)

(*
 * Get the remote data (set by any DirectPlay object in
 * the session using DPSET_REMOTE)
 *)
  DPGET_REMOTE = $00000000;

(*
 * Get the local data (set by this DirectPlay object 
 * using DPSET_LOCAL)
 *)
  DPGET_LOCAL = $00000001;

(****************************************************************************
 *
 * Open API flags
 *
 ****************************************************************************)

(*
 * Join the session that is described by the DPSESSIONDESC2 structure
 *)
  DPOPEN_JOIN = $00000001;

(*
 * Create a new session as described by the DPSESSIONDESC2 structure
 *)
  DPOPEN_CREATE = $00000002;

(*
 * Return status about progress of open instead of showing
 * any status dialogs.
 *)
  DPOPEN_RETURNSTATUS = DPENUMSESSIONS_RETURNSTATUS;

(****************************************************************************
 *
 * DPLCONNECTION flags
 *
 ****************************************************************************)

(*
 * This application should create a new session as
 * described by the DPSESIONDESC structure
 *)
  DPLCONNECTION_CREATESESSION = DPOPEN_CREATE;

(*
 * This application should join the session described by
 * the DPSESIONDESC structure with the lpAddress data
 *)
  DPLCONNECTION_JOINSESSION = DPOPEN_JOIN;

(****************************************************************************
 *
 * Receive API flags
 * Default is DPRECEIVE_ALL
 *
 ****************************************************************************)

(*
 * Get the first message in the queue
 *)
  DPRECEIVE_ALL = $00000001;

(*
 * Get the first message in the queue directed to a specific player 
 *)
  DPRECEIVE_TOPLAYER = $00000002;

(*
 * Get the first message in the queue from a specific player
 *)
  DPRECEIVE_FROMPLAYER = $00000004;

(*
 * Get the message but don't remove it from the queue
 *)
  DPRECEIVE_PEEK = $00000008;

(****************************************************************************
 *
 * Send API flags
 *
 ****************************************************************************)

(*
 * Send the message using a guaranteed send method.
 * Default is non-guaranteed.
 *)
  DPSEND_GUARANTEED = $00000001;

(*
 * This flag is obsolete. It is ignored by DirectPlay
 *)
  DPSEND_HIGHPRIORITY = $00000002;

(*
 * This flag is obsolete. It is ignored by DirectPlay
 *)
  DPSEND_OPENSTREAM = $00000008;

(*
 * This flag is obsolete. It is ignored by DirectPlay
 *)
  DPSEND_CLOSESTREAM = $00000010;

(*
 * Send the message digitally signed to ensure authenticity.
 *)
  DPSEND_SIGNED = $00000020;

(*
 * Send the message with encryption to ensure privacy.
 *)
  DPSEND_ENCRYPTED = $00000040;

(*
 * The message is a lobby system message
 *)
  DPSEND_LOBBYSYSTEMMESSAGE = $00000080;

(*
 * andyco - added this so we can make addforward async.
 * needs to be sanitized when we add / expose full async
 * support.  8/3/97.
 *)
  DPSEND_ASYNC = $00000200;

(*
 * When a message is completed, don't tell me.
 * by default the application is notified with a system message.
 *)
  DPSEND_NOSENDCOMPLETEMSG = $00000400;


(*
 * Maximum priority for sends available to applications
 *)
  DPSEND_MAX_PRI = $0000FFFF;
  DPSEND_MAX_PRIORITY = DPSEND_MAX_PRI;

(****************************************************************************
 *
 * SetGroupData, SetGroupName, SetPlayerData, SetPlayerName,
 * SetSessionDesc API flags.
 * Default is DPSET_REMOTE.
 *
 ****************************************************************************)

(* 
 * Propagate the data to all players in the session
 *)
  DPSET_REMOTE = $00000000;

(*
 * Do not propagate the data to other players
 *)
  DPSET_LOCAL = $00000001;

(*
 * Used with DPSET_REMOTE, use guaranteed message send to
 * propagate the data
 *)
  DPSET_GUARANTEED = $00000002;

(****************************************************************************
 *
 * GetMessageQueue API flags.
 * Default is DPMESSAGEQUEUE_SEND
 *
 ****************************************************************************)

(*
 * Get Send Queue - requires Service Provider Support
 *)
  DPMESSAGEQUEUE_SEND = $00000001;

(*
 * Get Receive Queue
 *)
  DPMESSAGEQUEUE_RECEIVE = $00000002;

(****************************************************************************
 *
 * Connect API flags
 *
 ****************************************************************************)

(*
 * Start an asynchronous connect which returns status codes
 *)
  DPCONNECT_RETURNSTATUS = DPENUMSESSIONS_RETURNSTATUS;

(****************************************************************************
 *
 * DirectPlay system messages and message data structures
 *
 * All system message come 'From' player DPID_SYSMSG.  To determine what type 
 * of message it is, cast the lpData from Receive to TDPMsg_Generic and check
 * the dwType member against one of the following DPSYS_xxx constants. Once
 * a match is found, cast the lpData to the corresponding of the DPMSG_xxx
 * structures to access the data of the message.
 *
 ****************************************************************************)

(*
 * A new player or group has been created in the session
 * Use TDPMsg_CreatePlayerOrGroup.  Check dwPlayerType to see if it
 * is a player or a group.
 *)
  DPSYS_CREATEPLAYERORGROUP = $0003;

(*
 * A player has been deleted from the session
 * Use TDPMsg_DestroyPlayerOrGroup
 *)
  DPSYS_DESTROYPLAYERORGROUP = $0005;

(*
 * A player has been added to a group
 * Use DPMSG_ADDPLAYERTOGROUP
 *)
  DPSYS_ADDPLAYERTOGROUP = $0007;

(*
 * A player has been removed from a group
 * Use DPMSG_DELETEPLAYERFROMGROUP
 *)
  DPSYS_DELETEPLAYERFROMGROUP = $0021;

(*
 * This DirectPlay object lost its connection with all the
 * other players in the session.
 * Use DPMSG_SESSIONLOST.
 *)
  DPSYS_SESSIONLOST = $0031;

(*
 * The current host has left the session.
 * This DirectPlay object is now the host.
 * Use DPMSG_HOST.
 *)
  DPSYS_HOST = $0101;

(*
 * The remote data associated with a player or
 * group has changed. Check dwPlayerType to see
 * if it is a player or a group
 * Use DPMSG_SETPLAYERORGROUPDATA
 *)
  DPSYS_SETPLAYERORGROUPDATA = $0102;

(*
 * The name of a player or group has changed.
 * Check dwPlayerType to see if it is a player
 * or a group.
 * Use TDPMsg_SetPlayerOrGroupName
 *)
  DPSYS_SETPLAYERORGROUPNAME = $0103;

(*
 * The session description has changed.
 * Use DPMSG_SETSESSIONDESC
 *)
  DPSYS_SETSESSIONDESC = $0104;

(*
 * A group has been added to a group
 * Use TDPMsg_AddGroupToGroup
 *)
  DPSYS_ADDGROUPTOGROUP = $0105;

(*
 * A group has been removed from a group
 * Use DPMsg_DeleteGroupFromGroup
 *)
  DPSYS_DELETEGROUPFROMGROUP = $0106;

(*
 * A secure player-player message has arrived.
 * Use DPMSG_SECUREMESSAGE
 *)
  DPSYS_SECUREMESSAGE = $0107;

(*
 * Start a new session.
 * Use DPMSG_STARTSESSION
 *)
  DPSYS_STARTSESSION = $0108;

(*
 * A chat message has arrived
 * Use DPMSG_CHAT
 *)
  DPSYS_CHAT = $0109;

(*
 * The owner of a group has changed
 * Use DPMSG_SETGROUPOWNER
 *)
  DPSYS_SETGROUPOWNER = $010A;

(*
 * An async send has finished, failed or been cancelled
 * Use DPMSG_SENDCOMPLETE
 *)
  DPSYS_SENDCOMPLETE = $010D;

(*
 * Used in the dwPlayerType field to indicate if it applies to a group
 * or a player
 *)
  DPPLAYERTYPE_GROUP = $00000000;
  DPPLAYERTYPE_PLAYER = $00000001;

type
(*
 * TDPMsg_Generic
 * Generic message structure used to identify the message type.
 *)
  PDPMsg_Generic = ^TDPMsg_Generic;
  TDPMsg_Generic = packed record
    dwType: DWORD;   // Message type
  end;

(*
 * TDPMsg_CreatePlayerOrGroup
 * System message generated when a new player or group
 * created in the session with information about it.
 *)
  PDPMsg_CreatePlayerOrGroup = ^TDPMsg_CreatePlayerOrGroup;
  TDPMsg_CreatePlayerOrGroup = packed record
    dwType: DWORD;             // Message type
    dwPlayerType: DWORD;       // Is it a player or group
    DPID: TDPID;               // ID of the player or group
    dwCurrentPlayers: DWORD;   // current # players & groups in session
    lpData: Pointer;           // pointer to remote data
    dwDataSize: DWORD;         // size of remote data
    dpnName: TDPName;           // structure with name info
                               // the following fields are only available when using
                               // the IDirectPlay3 interface or greater
    dpIdParent: TDPID;         // id of parent group
    dwFlags: DWORD;            // player or group flags
  end;

(*
 * TDPMsg_DestroyPlayerOrGroup
 * System message generated when a player or group is being
 * destroyed in the session with information about it.
 *)
  PDPMsg_DestroyPlayerOrGroup= ^TDPMsg_DestroyPlayerOrGroup;
  TDPMsg_DestroyPlayerOrGroup = packed record
    dwType: DWORD;             // Message type
    dwPlayerType: DWORD;       // Is it a player or group
    DPID: TDPID;                // player ID being deleted
    lpLocalData: Pointer;      // copy of players local data
    dwLocalDataSize: DWORD;    // sizeof local data
    lpRemoteData: Pointer;     // copy of players remote data
    dwRemoteDataSize: DWORD;   // sizeof remote data
                               // the following fields are only available when using
                               // the IDirectPlay3 interface or greater
    dpnName: TDPName;           // structure with name info
    dpIdParent: TDPID;          // id of parent group
    dwFlags: DWORD;            // player or group flags
  end;

(*
 * DPMSG_ADDPLAYERTOGROUP
 * System message generated when a player is being added
 * to a group.
 *)
  PDPMsg_AddPlayerToGroup = ^TDPMsg_AddPlayerToGroup;
  TDPMsg_AddPlayerToGroup = packed record
    dwType: DWORD;      // Message type
    dpIdGroup: TDPID;    // group ID being added to
    dpIdPlayer: TDPID;   // player ID being added
  end;

(*
 * DPMSG_DELETEPLAYERFROMGROUP
 * System message generated when a player is being
 * removed from a group
 *)
  PDPMsg_DeletePlayerFromGroup = ^TDPMsg_DeletePlayerFromGroup;
  TDPMsg_DeletePlayerFromGroup = TDPMsg_AddPlayerToGroup;

(*
 * TDPMsg_AddGroupToGroup
 * System message generated when a group is being added
 * to a group.
 *)
  PDPMsg_AddGroupToGroup = ^TDPMsg_AddGroupToGroup;
  TDPMsg_AddGroupToGroup = packed record
    dwType: DWORD;           // Message type
    dpIdParentGroup: TDPID;   // group ID being added to
    dpIdGroup: TDPID;         // group ID being added
  end;

(*
 * DPMsg_DeleteGroupFromGroup
 * System message generated when a GROUP is being
 * removed from a group
 *)
  PDPMsg_DeleteGroupFromGroup = ^TDPMsg_DeleteGroupFromGroup;
  TDPMsg_DeleteGroupFromGroup = TDPMsg_AddGroupToGroup;

(*
 * DPMSG_SETPLAYERORGROUPDATA
 * System message generated when remote data for a player or
 * group has changed.
 *)
  PDPMsg_SetPlayerOrGroupData = ^TDPMsg_SetPlayerOrGroupData;
  TDPMsg_SetPlayerOrGroupData = packed record
    dwType: DWORD;         // Message type
    dwPlayerType: DWORD;   // Is it a player or group
    DPID: TDPID;           // ID of player or group
    lpData: Pointer;       // pointer to remote data
    dwDataSize: DWORD;     // size of remote data
  end;

(*
 * DPMSG_SETPLAYERORGROUPNAME
 * System message generated when the name of a player or
 * group has changed.
 *)
  PDPMsg_SetPlayerOrGroupName = ^TDPMsg_SetPlayerOrGroupName;
  TDPMsg_SetPlayerOrGroupName = packed record
    dwType: DWORD;         // Message type
    dwPlayerType: DWORD;   // Is it a player or group
    DPID: TDPID;           // ID of player or group
    dpnName: TDPName;      // structure with new name info
  end;

(*
 * DPMSG_SETSESSIONDESC
 * System message generated when session desc has changed
 *)
  PDPMsg_SetSessionDesc = ^TDPMsg_SetSessionDesc;
  TDPMsg_SetSessionDesc = packed record
    dwType: DWORD;            // Message type
    dpDesc: TDPSessionDesc2;   // Session desc
  end;

(*
 * DPMSG_HOST
 * System message generated when the host has migrated to this
 * DirectPlay object.
 *
 *)
  PDPMsg_Host = ^TDPMsg_Host;
  TDPMsg_Host = TDPMsg_Generic;

(*
 * DPMSG_SESSIONLOST
 * System message generated when the connection to the session is lost.
 *
 *)
  PDPMsg_SessionLost = ^TDPMsg_SessionLost;
  TDPMsg_SessionLost = TDPMsg_Generic;

(*
 * DPMSG_SECUREMESSAGE
 * System message generated when a player requests a secure send
 *)
  PDPMsg_SecureMessage = ^TDPMsg_SecureMessage;
  TDPMsg_SecureMessage = packed record
    dwType: DWORD;       // Message Type
    dwFlags: DWORD;      // Signed/Encrypted
    dpIdFrom: TDPID;      // ID of Sending Player
    lpData: Pointer;     // Player message
    dwDataSize: DWORD;   // Size of player message
  end;

(*
 * DPMSG_STARTSESSION
 * System message containing all information required to
 * start a new session
 *)
  PDPMsg_StartSession = ^TDPMsg_StartSession;
  TDPMsg_StartSession = packed record
    dwType: DWORD;             // Message type
    lpConn: PDPLConnection;   // TDPLConnection structure
  end;

(*
 * DPMSG_CHAT
 * System message containing a chat message
 *)
  PDPMsg_Chat = ^TDPMsg_Chat;
  TDPMsg_Chat = packed record
    dwType: DWORD;        // Message type
    dwFlags: DWORD;       // Message flags
    idFromPlayer: TDPID;  // ID of the Sending Player
    idToPlayer: TDPID;    // ID of the To Player
    idToGroup: TDPID;     // ID of the To Group
    lpChat: PDPChat;      // Pointer to a structure containing the chat message
  end;

(*
 * DPMSG_SETGROUPOWNER
 * System message generated when the owner of a group has changed
 *)
  PDPMsg_SetGroupOwner = ^TDPMsg_SetGroupOwner;
  TDPMsg_SetGroupOwner = packed record
    dwType: DWORD;        // Message type
    idGroup: TDPID;       // ID of the group
    idNewOwner: TDPID;    // ID of the player that is the new owner
    idOldOwner: TDPID;    // ID of the player that used to be the owner
  end;

(*
 * DPMSG_SENDCOMPLETE
 * System message generated when finished with an Async Send message
 *
 * NOTE SENDPARMS has an overlay for DPMSG_SENDCOMPLETE, don't
 *                change this message w/o changing SENDPARMS.
 *)
  PDPMsg_SendComplete = ^TDPMsg_SendComplete;
  TDPMsg_SendComplete = packed record
    dwType: DWORD;        // Message type
    idFrom: TDPID;
    idTo: TDPID;
    dwFlags: DWORD;
    dwPriority: DWORD;
    dwTimeout: DWORD;
    lpvContext: Pointer;
    dwMsgID: DWORD;
    hr: HRESULT;
    dwSendTime: DWORD;
  end;

(****************************************************************************
 *
 * DIRECTPLAY ERRORS
 *
 * Errors are represented by negative values and cannot be combined.
 *
 ****************************************************************************)
const
  MAKE_DPHRESULT = $88770000;

  DP_OK = S_OK;
  DPERR_ALREADYINITIALIZED = MAKE_DPHRESULT + 5;
  DPERR_ACCESSDENIED = MAKE_DPHRESULT + 10;
  DPERR_ACTIVEPLAYERS = MAKE_DPHRESULT + 20;
  DPERR_BUFFERTOOSMALL = MAKE_DPHRESULT + 30;
  DPERR_CANTADDPLAYER = MAKE_DPHRESULT + 40;
  DPERR_CANTCREATEGROUP = MAKE_DPHRESULT + 50;
  DPERR_CANTCREATEPLAYER = MAKE_DPHRESULT + 60;
  DPERR_CANTCREATESESSION = MAKE_DPHRESULT + 70;
  DPERR_CAPSNOTAVAILABLEYET = MAKE_DPHRESULT + 80;
  DPERR_EXCEPTION = MAKE_DPHRESULT + 90;
  DPERR_GENERIC = E_FAIL;
  DPERR_INVALIDFLAGS = MAKE_DPHRESULT + 120;
  DPERR_INVALIDOBJECT = MAKE_DPHRESULT + 130;
  DPERR_INVALIDPARAM = E_INVALIDARG;
  DPERR_INVALIDPARAMS = DPERR_INVALIDPARAM;
  DPERR_INVALIDPLAYER = MAKE_DPHRESULT + 150;
  DPERR_INVALIDGROUP = MAKE_DPHRESULT + 155;
  DPERR_NOCAPS = MAKE_DPHRESULT + 160;
  DPERR_NOCONNECTION = MAKE_DPHRESULT + 170;
  DPERR_NOMEMORY = E_OUTOFMEMORY;
  DPERR_OUTOFMEMORY = DPERR_NOMEMORY;
  DPERR_NOMESSAGES = MAKE_DPHRESULT + 190;
  DPERR_NONAMESERVERFOUND = MAKE_DPHRESULT + 200;
  DPERR_NOPLAYERS = MAKE_DPHRESULT + 210;
  DPERR_NOSESSIONS = MAKE_DPHRESULT + 220;
  DPERR_PENDING = E_PENDING;
  DPERR_SENDTOOBIG = MAKE_DPHRESULT + 230;
  DPERR_TIMEOUT = MAKE_DPHRESULT + 240;
  DPERR_UNAVAILABLE = MAKE_DPHRESULT + 250;
  DPERR_UNSUPPORTED = E_NOTIMPL;
  DPERR_BUSY = MAKE_DPHRESULT + 270;
  DPERR_USERCANCEL = MAKE_DPHRESULT + 280;
  DPERR_NOINTERFACE = E_NOINTERFACE;
  DPERR_CANNOTCREATESERVER = MAKE_DPHRESULT + 290;
  DPERR_PLAYERLOST = MAKE_DPHRESULT + 300;
  DPERR_SESSIONLOST = MAKE_DPHRESULT + 310;
  DPERR_UNINITIALIZED = MAKE_DPHRESULT + 320;
  DPERR_NONEWPLAYERS = MAKE_DPHRESULT + 330;
  DPERR_INVALIDPASSWORD = MAKE_DPHRESULT + 340;
  DPERR_CONNECTING = MAKE_DPHRESULT + 350;
  DPERR_CONNECTIONLOST = MAKE_DPHRESULT + 360;
  DPERR_UNKNOWNMESSAGE = MAKE_DPHRESULT + 370;
  DPERR_CANCELFAILED = MAKE_DPHRESULT + 380;
  DPERR_INVALIDPRIORITY = MAKE_DPHRESULT + 390;
  DPERR_NOTHANDLED = MAKE_DPHRESULT + 400;
  DPERR_CANCELLED = MAKE_DPHRESULT + 410;
  DPERR_ABORTED = MAKE_DPHRESULT + 420;


  DPERR_BUFFERTOOLARGE = MAKE_DPHRESULT + 1000;
  DPERR_CANTCREATEPROCESS = MAKE_DPHRESULT + 1010;
  DPERR_APPNOTSTARTED = MAKE_DPHRESULT + 1020;
  DPERR_INVALIDINTERFACE = MAKE_DPHRESULT + 1030;
  DPERR_NOSERVICEPROVIDER = MAKE_DPHRESULT + 1040;
  DPERR_UNKNOWNAPPLICATION = MAKE_DPHRESULT + 1050;
  DPERR_NOTLOBBIED = MAKE_DPHRESULT + 1070;
  DPERR_SERVICEPROVIDERLOADED = MAKE_DPHRESULT + 1080;
  DPERR_ALREADYREGISTERED = MAKE_DPHRESULT + 1090;
  DPERR_NOTREGISTERED = MAKE_DPHRESULT + 1100;

//
// Security related errors
//
  DPERR_AUTHENTICATIONFAILED = MAKE_DPHRESULT + 2000;
  DPERR_CANTLOADSSPI = MAKE_DPHRESULT + 2010;
  DPERR_ENCRYPTIONFAILED = MAKE_DPHRESULT + 2020;
  DPERR_SIGNFAILED = MAKE_DPHRESULT + 2030;
  DPERR_CANTLOADSECURITYPACKAGE = MAKE_DPHRESULT + 2040;
  DPERR_ENCRYPTIONNOTSUPPORTED = MAKE_DPHRESULT + 2050;
  DPERR_CANTLOADCAPI = MAKE_DPHRESULT + 2060;
  DPERR_NOTLOGGEDIN = MAKE_DPHRESULT + 2070;
  DPERR_LOGONDENIED = MAKE_DPHRESULT + 2080;

(****************************************************************************
 *
 * 	dplay 1.0 obsolete structures + interfaces
 *	Included for compatibility only. New apps should
 *	use IDirectPlay2
 *
 ****************************************************************************)

  DPOPEN_OPENSESSION = DPOPEN_JOIN;
  DPOPEN_CREATESESSION = DPOPEN_CREATE;

  DPENUMSESSIONS_PREVIOUS = $00000004;

  DPENUMPLAYERS_PREVIOUS = $00000004;

  DPSEND_GUARANTEE = DPSEND_GUARANTEED;
  DPSEND_TRYONCE = $00000004;

  DPCAPS_NAMESERVICE = $00000001;
  DPCAPS_NAMESERVER = DPCAPS_ISHOST;
  DPCAPS_GUARANTEED = $00000004;

  DPLONGNAMELEN = 52;
  DPSHORTNAMELEN = 20;
  DPSESSIONNAMELEN = 32;
  DPPASSWORDLEN = 16;
  DPUSERRESERVED = 16;

  DPSYS_ADDPLAYER = $0003;
  DPSYS_DELETEPLAYER = $0005;

  DPSYS_DELETEGROUP = $0020;
  DPSYS_DELETEPLAYERFROMGRP = $0021;
  DPSYS_CONNECT = $484b;

type
  PDPMsg_AddPlayer = ^TDPMsg_AddPlayer;
  TDPMsg_AddPlayer = packed record
    dwType: DWORD;
    dwPlayerType: DWORD;
    DPID: TDPID;
    szLongName: array[0..DPLONGNAMELEN-1] of Char;
    szShortName: array[0..DPSHORTNAMELEN-1] of Char;
    dwCurrentPlayers: DWORD;
  end;

  PDPMsg_AddGroup = ^TDPMsg_AddGroup;
  TDPMsg_AddGroup = TDPMsg_AddPlayer;

  PDPMsg_GroupAdd = ^TDPMsg_GroupAdd;
  TDPMsg_GroupAdd = packed record
    dwType: DWORD;
    dpIdGroup: TDPID;
    dpIdPlayer: TDPID;
  end;

  PDPMsg_GroupDelete = ^TDPMsg_GroupDelete;
  TDPMsg_GroupDelete = TDPMsg_GroupAdd;

  PDPMsg_DeletePlayer = ^TDPMsg_DeletePlayer;
  TDPMsg_DeletePlayer = packed record
    dwType: DWORD;
    DPID: TDPID;
  end;

  TDPEnumPlayersCallback = function(dpId: TDPID; lpFriendlyName: PChar;
      lpFormalName: PChar; dwFlags: DWORD; lpContext: Pointer) : BOOL; stdcall;

  PDPSessionDesc = ^TDPSessionDesc;
  TDPSessionDesc = packed record
    dwSize: DWORD;
    guidSession: TGUID;
    dwSession: DWORD;
    dwMaxPlayers: DWORD;
    dwCurrentPlayers: DWORD;
    dwFlags: DWORD;
    szSessionName: Array [0..DPSESSIONNAMELEN-1] of char;
    szUserField: Array [0..DPUSERRESERVED-1] of char;
    dwReserved1: DWORD;
    szPassword: Array [0..DPPASSWORDLEN-1] of char;
    dwReserved2: DWORD;
    dwUser1: DWORD;
    dwUser2: DWORD;
    dwUser3: DWORD;
    dwUser4: DWORD;
  end;

  TDPEnumSessionsCallback = function(var lpDPSessionDesc: TDPSessionDesc;
      lpContext: Pointer; var lpdwTimeOut: DWORD; dwFlags: DWORD) : BOOL;
      stdcall;

type
(*
 * IDirectPlay
 *)
  IDirectPlay = interface (IUnknown)
    ['{5454e9a0-db65-11ce-921c-00aa006c4972}']
    (*** IDirectPlay methods ***)
    function AddPlayerToGroup(pidGroup: TDPID; pidPlayer: TDPID) : HResult; StdCall;
    function Close: HResult;
    function CreatePlayer(var lppidID: TDPID; lpPlayerFriendlyName: PChar; lpPlayerFormalName: PChar; lpEvent: PHandle) : HResult; StdCall;
    function CreateGroup(var lppidID: TDPID; lpGroupFriendlyName: PChar; lpGroupFormalName: PChar) : HResult; StdCall;
    function DeletePlayerFromGroup(pidGroup: TDPID; pidPlayer: TDPID) : HResult; StdCall;
    function DestroyPlayer(pidID: TDPID) : HResult; StdCall;
    function DestroyGroup(pidID: TDPID) : HResult; StdCall;
    function EnableNewPlayers(bEnable: BOOL) : HResult; StdCall;
    function EnumGroupPlayers(pidGroupPID: TDPID; lpEnumPlayersCallback: TDPEnumPlayersCallback; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumGroups(dwSessionID: DWORD; lpEnumPlayersCallback: TDPEnumPlayersCallback; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumPlayers(dwSessionId: DWORD; lpEnumPlayersCallback: TDPEnumPlayersCallback; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumSessions(var lpSDesc: TDPSessionDesc; dwTimeout: DWORD; lpEnumSessionsCallback: TDPEnumSessionsCallback; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetCaps(var lpDPCaps: TDPCaps) : HResult; StdCall;
    function GetMessageCount(pidID: TDPID; var lpdwCount: DWORD) : HResult; StdCall;
    function GetPlayerCaps(pidID: TDPID; var lpDPPlayerCaps: TDPCaps) : HResult; StdCall;
    function GetPlayerName(pidID: TDPID; lpPlayerFriendlyName: PChar; var lpdwFriendlyNameLength: DWORD; lpPlayerFormalName: PChar; var lpdwFormalNameLength: DWORD) : HResult; StdCall;
    function Initialize(var lpGUID: TGUID) : HResult; StdCall;
    function Open(var lpSDesc: TDPSessionDesc) : HResult; StdCall;
    function Receive(var lppidFrom, lppidTo: TDPID; dwFlags: DWORD; var lpvBuffer; var lpdwSize: DWORD) : HResult; StdCall;
    function SaveSession(lpSessionName: PChar) : HResult; StdCall;
    function Send(pidFrom: TDPID; pidTo: TDPID; dwFlags: DWORD; var lpvBuffer; dwBuffSize: DWORD) : HResult; StdCall;
    function SetPlayerName(pidID: TDPID; lpPlayerFriendlyName: PChar; lpPlayerFormalName: PChar) : HResult; StdCall;
  end;

var
  DirectPlayCreate : function (var lpGUID: TGUID; Out lplpDP: IDirectPlay; pUnk: IUnknown) : HResult; StdCall;

(******************************************************************************)
(**                                                                          **)
(** DPLobby.Pas                                                              **)
(**                                                                          **)
(******************************************************************************)

const
(* {AF465C71-9588-11cf-A020-00AA006157AC} *)
  IID_IDirectPlayLobbyW: TGUID =      (D1:$af465c71;D2:$9588;D3:$11cf;D4:($a0,$20,$00,$aa,$00,$61,$57,$ac));
(* {26C66A70-B367-11cf-A024-00AA006157AC} *)
  IID_IDirectPlayLobbyA: TGUID =      (D1:$26c66a70;D2:$b367;D3:$11cf;D4:($a0,$24,$00,$aa,$00,$61,$57,$ac));
{$IFDEF UNICODE}
  IID_IDirectPlayLobby: TGUID =       (D1:$af465c71;D2:$9588;D3:$11cf;D4:($a0,$20,$00,$aa,$00,$61,$57,$ac));
{$ELSE}
  IID_IDirectPlayLobby: TGUID =       (D1:$26c66a70;D2:$b367;D3:$11cf;D4:($a0,$24,$00,$aa,$00,$61,$57,$ac));
{$ENDIF}


(* {0194C220-A303-11d0-9C4F-00A0C905425E} *)
  IID_IDirectPlayLobby2W: TGUID =      (D1:$194c220;D2:$a303;D3:$11d0;D4:($9c,$4f,$00,$a0,$c9,$5,$42,$5e));
(* {1BB4AF80-A303-11d0-9C4F-00A0C905425E} *)
  IID_IDirectPlayLobby2A: TGUID =      (D1:$1bb4af80;D2:$a303;D3:$11d0;D4:($9c,$4f,$00,$a0,$c9,$5,$42,$5e));
{$IFDEF UNICODE}
  IID_IDirectPlayLobby2: TGUID =        (D1:$194c220;D2:$a303;D3:$11d0;D4:($9c,$4f,$00,$a0,$c9,$5,$42,$5e));
{$ELSE}
  IID_IDirectPlayLobby2: TGUID =        (D1:$1bb4af80;D2:$a303;D3:$11d0;D4:($9c,$4f,$00,$a0,$c9,$5,$42,$5e));
{$ENDIF}

(* {2DB72490-652C-11d1-A7A8-0000F803ABFC} *)
  IID_IDirectPlayLobby3W: TGUID =       (D1:$2db72490;D2:$652c;D3:$11d1;D4:($a7,$a8,$00,$00,$f8,$3,$ab,$fc));
(* {2DB72491-652C-11d1-A7A8-0000F803ABFC} *)
  IID_IDirectPlayLobby3A: TGUID =       (D1:$2db72491;D2:$652c;D3:$11d1;D4:($a7,$a8,$00,$00,$f8,$3,$ab,$fc));
{$IFDEF UNICODE}
  IID_IDirectPlayLobby3: TGUID =        (D1:$2db72490;D2:$652c;D3:$11d1;D4:($a7,$a8,$00,$00,$f8,$3,$ab,$fc));
{$ELSE}
  IID_IDirectPlayLobby3: TGUID =        (D1:$2db72491;D2:$652c;D3:$11d1;D4:($a7,$a8,$00,$00,$f8,$3,$ab,$fc));
{$ENDIF}

(* {2FE8F810-B2A5-11d0-A787-0000F803ABFC} *)
  CLSID_DirectPlayLobby: TGUID =        (D1:$2fe8f810;D2:$b2a5;D3:$11d0;D4:($a7,$87,$00,$00,$f8,$3,$ab,$fc));

(****************************************************************************
 *
 * IDirectPlayLobby Structures
 *
 * Various structures used to invoke DirectPlayLobby.
 *
 ****************************************************************************)

type
(*
 * TDPLAppInfo
 * Used to hold information about a registered DirectPlay
 * application
 *)
  PDPLAppInfo = ^TDPLAppInfo;
  TDPLAppInfo = packed record
    dwSize: DWORD;            // Size of this structure
    guidApplication: TGUID;   // GUID of the Application
    case Integer of           // Pointer to the Application Name
      0: (lpszAppName: PCharAW);
      1: (lpszAppNameW: PWideChar);
      3: (lpszAppNameA: PChar);
  end;

(*
 * TDPCompoundAddressElement
 *
 * An array of these is passed to CreateCompoundAddresses()
 *)
  PDPCompoundAddressElement = ^TDPCompoundAddressElement;
  TDPCompoundAddressElement = packed record
    guidDataType: TGUID;
    dwDataSize: DWORD;
    lpData: Pointer;
  end;

(*
 * TDPApplicationDesc
 * Used to register a DirectPlay application
 *)
  PDPApplicationDesc = ^TDPApplicationDesc;
  TDPApplicationDesc = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    case integer of
      0 : (lpszApplicationName: PCharAW;
           guidApplication: TGUID;
           lpszFilename: PCharAW;
           lpszCommandLine: PCharAW;
           lpszPath: PCharAW;
           lpszCurrentDirectory: PCharAW;
           lpszDescriptionA: PAnsiChar;
           lpszDescriptionW: PWideChar);
      1 : (lpszApplicationNameA: PAnsiChar;
           filler1: TGUID;
           lpszFilenameA: PAnsiChar;
           lpszCommandLineA: PAnsiChar;
           lpszPathA: PAnsiChar;
           lpszCurrentDirectoryA: PAnsiChar);
      2 : (lpszApplicationNameW: PWideChar;
           filler2: TGUID;
           lpszFilenameW: PWideChar;
           lpszCommandLineW: PWideChar;
           lpszPathW: PWideChar;
           lpszCurrentDirectoryW: PWideChar);
  end;

(****************************************************************************
 *
 * Enumeration Method Callback Prototypes
 *
 ****************************************************************************)

(*
 * Callback for EnumAddress()
 *)
  TDPEnumAdressCallback = function(var guidDataType: TGUID; dwDataSize: DWORD; lpData: Pointer; lpContext: Pointer) : BOOL; stdcall;

(*
 * Callback for EnumAddressTypes()
 *)
  TDPLEnumAddressTypesCallback = function(var guidDataType: TGUID; lpContext: Pointer; dwFlags: DWORD) : BOOL; stdcall;

(*
 * Callback for EnumLocalApplications()
 *)
  TDPLEnumLocalApplicationsCallback = function(var lpAppInfo: TDPLAppInfo; lpContext: Pointer; dwFlags: DWORD) : BOOL; stdcall;

(****************************************************************************
 *
 * IDirectPlayLobby (and IDirectPlayLobbyA) Interface
 *
 ****************************************************************************)

type
  IDirectPlayLobbyAW = interface (IUnknown)
    (*** IDirectPlayLobby methods ***)
    function Connect(dwFlags: DWORD; var lplpDP: IDirectPlay2; pUnk: IUnknown) : HResult; StdCall;
    function CreateAddress(const guidSP, guidDataType: TGUID; var lpData; dwDataSize: DWORD; var lpAddress; var lpdwAddressSize: DWORD) : HResult; StdCall;
    function EnumAddress(lpEnumAddressCallback: TDPEnumAdressCallback; var lpAddress; dwAddressSize: DWORD; lpContext : Pointer) : HResult; StdCall;
    function EnumAddressTypes(lpEnumAddressTypeCallback: TDPLEnumAddressTypesCallback; const guidSP: TGUID; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function EnumLocalApplications(lpEnumLocalAppCallback: TDPLEnumLocalApplicationsCallback; lpContext: Pointer; dwFlags: DWORD) : HResult; StdCall;
    function GetConnectionSettings(dwAppID: DWORD; lpData: PDPLConnection; var lpdwDataSize: DWORD) : HResult; StdCall;
    function ReceiveLobbyMessage(dwFlags: DWORD; dwAppID: DWORD; var lpdwMessageFlags: DWORD; lpData: Pointer; var lpdwDataSize: DWORD) : HResult; StdCall;
    function RunApplication(dwFlags: DWORD; var lpdwAppId: DWORD; var lpConn: TDPLConnection; hReceiveEvent: THandle) : HResult; StdCall;
    function SendLobbyMessage(dwFlags: DWORD; dwAppID: DWORD; var lpData; dwDataSize: DWORD) : HResult; StdCall;
    function SetConnectionSettings(dwFlags: DWORD; dwAppID: DWORD; var lpConn: TDPLConnection) : HResult; StdCall;
    function SetLobbyMessageEvent(dwFlags: DWORD; dwAppID: DWORD; hReceiveEvent: THandle) : HResult; StdCall;
  end;

  IDirectPlayLobbyW = interface (IDirectPlayLobbyAW)
    ['{AF465C71-9588-11CF-A020-00AA006157AC}']
  end;
  IDirectPlayLobbyA = interface (IDirectPlayLobbyAW)
    ['{26C66A70-B367-11cf-A024-00AA006157AC}']
  end;

{$IFDEF UNICODE}
  IDirectPlayLobby = IDirectPlayLobbyW;
{$ELSE}
  IDirectPlayLobby = IDirectPlayLobbyA;
{$ENDIF}


(****************************************************************************
 *
 * IDirectPlayLobby2 (and IDirectPlayLobby2A) Interface
 *
 ****************************************************************************)

  IDirectPlayLobby2AW = interface(IDirectPlayLobbyAW)
    (*** IDirectPlayLobby2 methods ***)
    function CreateCompoundAddress(var lpElements: TDPCompoundAddressElement; dwElementCount: DWORD; lpAddress: Pointer; var lpdwAddressSize: DWORD) : HResult; StdCall;
  end;

  IDirectPlayLobby2W = interface (IDirectPlayLobby2AW)
    ['{0194C220-A303-11D0-9C4F-00A0C905425E}']
  end;
  IDirectPlayLobby2A = interface (IDirectPlayLobby2AW)
    ['{1BB4AF80-A303-11d0-9C4F-00A0C905425E}']
  end;

{$IFDEF UNICODE}
  IDirectPlayLobby2 = IDirectPlayLobby2W;
{$ELSE}
  IDirectPlayLobby2 = IDirectPlayLobby2A;
{$ENDIF}

(****************************************************************************
 *
 * IDirectPlayLobby3 (and IDirectPlayLobby3A) Interface
 *
 ****************************************************************************)

  IDirectPlayLobby3AW = interface(IDirectPlayLobby2AW)
    (*** IDirectPlayLobby3 methods ***)
    function ConnectEx(dwFlags: DWORD; const riid: TGUID; Out lplpDP; pUnk: IUnknown) : HResult; StdCall;
    function RegisterApplication(dwFlags: DWORD; var lpAppDesc: TDPApplicationDesc) : HResult; StdCall;
    function UnregisterApplication(dwFlags: DWORD; const guidApplication: TGUID) : HResult; StdCall;
    function WaitForConnectionSettings(dwFlags: DWORD) : HResult; StdCall;
  end;

  IDirectPlayLobby3W = interface (IDirectPlayLobby3AW)
    ['{2DB72490-652C-11d1-A7A8-0000F803ABFC}']
  end;
  IDirectPlayLobby3A = interface (IDirectPlayLobby3AW)
    ['{2DB72491-652C-11d1-A7A8-0000F803ABFC}']
  end;

{$IFDEF UNICODE}
  IDirectPlayLobby3 = IDirectPlayLobby3W;
{$ELSE}
  IDirectPlayLobby3 = IDirectPlayLobby3A;
{$ENDIF}

(****************************************************************************
 *
 * DirectPlayLobby API Prototypes
 *
 ****************************************************************************)

var
  DirectPlayLobbyCreateW : function (lpguidSP: PGUID; var lplpDPL: IDirectPlayLobbyW; lpUnk: IUnknown; lpData: Pointer; dwDataSize: DWORD) : HResult; StdCall;
  DirectPlayLobbyCreateA : function (lpguidSP: PGUID; var lplpDPL: IDirectPlayLobbyA; lpUnk: IUnknown; lpData: Pointer; dwDataSize: DWORD) : HResult; StdCall;
  DirectPlayLobbyCreate : function (lpguidSP: PGUID; var lplpDPL: IDirectPlayLobby; lpUnk: IUnknown; lpData: Pointer; dwDataSize: DWORD) : HResult; StdCall;

const
(****************************************************************************
 *
 * DirectPlayLobby Flags
 *
 ****************************************************************************)

(*
 *  This flag is used by IDirectPlayLobby.WaitForConnectionSettings to
 *  cancel a current wait that is in progress.
 *)
 DPLWAIT_CANCEL = $00000001;

(*
 *	This is a message flag used by ReceiveLobbyMessage.  It can be
 *	returned in the dwMessageFlags parameter to indicate a message from
 *	the system.
 *)
  DPLMSG_SYSTEM = $00000001;

(*
 *	This is a message flag used by ReceiveLobbyMessage and SendLobbyMessage.
 *  It is used to indicate that the message is a standard lobby message.
 *  TDPLMsg_SetProperty, TDPLMsg_SetPropertyResponse, TDPLMsg_GetProperty,
 *	TDPLMsg_GetPropertyResponse
 *)
  DPLMSG_STANDARD = $00000002;

type
(****************************************************************************
 *
 * DirectPlayLobby messages and message data structures
 *
 * All system messages have a dwMessageFlags value of DPLMSG_SYSTEM returned
 * from a call to ReceiveLobbyMessage.
 *
 * All standard messages have a dwMessageFlags value of DPLMSG_STANDARD returned
 * from a call to ReceiveLobbyMessage.
 *
 ****************************************************************************)

(*
 * TDPLMsg_Generic
 * Generic message structure used to identify the message type.
 *)
  PDPLMsg_Generic = ^TDPLMsg_Generic;
  TDPLMsg_Generic = packed record
    dwType: DWORD;   // Message type
  end;

(*
 * TDPLMsg_SystemMessage
 * Generic message format for all system messages --
 * DPLSYS_CONNECTIONSETTINGSREAD, DPLSYS_DPLYCONNECTSUCCEEDED,
 * DPLSYS_DPLAYCONNECTFAILED, DPLSYS_APPTERMINATED, DPLSYS_NEWCONNECTIONSETTINGS
 *)
  PDPLMsg_SystemMessage = ^TDPLMsg_SystemMessage;
  TDPLMsg_SystemMessage = packed record
    dwType: DWORD;         // Message type
    guidInstance: TGUID;    // Instance GUID of the dplay session the message corresponds to
  end;

(*
 *  TDPLMsg_SetProperty
 *  Standard message sent by an application to a lobby to set a
 *  property
 *)
  PDPLMsg_SetProperty = ^TDPLMsg_SetProperty;
  TDPLMsg_SetProperty = packed record
    dwType: DWORD;                           // Message type
    dwRequestID: DWORD;                      // Request ID (DPL_NOCONFIRMATION if no confirmation desired)
    guidPlayer: TGUID;                       // Player GUID
    guidPropertyTag: TGUID;                  // Property GUID
    dwDataSize: DWORD;                       // Size of data
    dwPropertyData: array[0..0] of DWORD;    // Buffer containing data
  end;

const
  DPL_NOCONFIRMATION = 0;

type
(*
 *  TDPLMsg_SetPropertyResponse
 *  Standard message returned by a lobby to confirm a
 *  TDPLMsg_SetProperty message.
 *)
  PDPLMsg_SetPropertyResponse = ^TDPLMsg_SetPropertyResponse;
  TDPLMsg_SetPropertyResponse = packed record
    dwType: DWORD;            // Message type
    dwRequestID: DWORD;       // Request ID
    guidPlayer: TGUID;        // Player GUID
    guidPropertyTag: TGUID;   // Property GUID
    hr: HResult;              // Return Code
  end;

(*
 *  TDPLMsg_GetProperty
 *  Standard message sent by an application to a lobby to request
 *	the current value of a property
 *)
  PDPLMsg_GetProperty = ^TDPLMsg_GetProperty;
  TDPLMsg_GetProperty = packed record
    dwType: DWORD;            // Message type
    dwRequestID: DWORD;       // Request ID
    guidPlayer: TGUID;        // Player GUID
    guidPropertyTag: TGUID;   // Property GUID
  end;
  LPDPLMSG_GETPROPERTY = ^TDPLMsg_GetProperty;

(*
 *  TDPLMsg_GetPropertyResponse
 *  Standard message returned by a lobby in response to a
 *	TDPLMsg_GetProperty message.
 *)
  PDPLMsg_GetPropertyResponse = ^TDPLMsg_GetPropertyResponse;
  TDPLMsg_GetPropertyResponse = packed record
    dwType: DWORD;                           // Message type
    dwRequestID: DWORD;                      // Request ID
    guidPlayer: TGUID;                       // Player GUID
    guidPropertyTag: TGUID;                  // Property GUID
    hr: HResult;                             // Return Code
    dwDataSize: DWORD;                       // Size of data
    dwPropertyData: array[0..0] of DWORD;    // Buffer containing data
  end;

(*
 *  TDPLMsg_NewSessionHost
 *  Standard message returned by a lobby in response to a
 *  the session host migrating to a new client
 *)
  PDPLMsg_NewSessionHost = ^TDPLMsg_NewSessionHost;
  TDPLMsg_NewSessionHost = packed record
    dwType: DWORD;            // Message type
    guidInstance: TGUID;      // Property GUID
  end;

const
(******************************************
 *
 *	DirectPlay Lobby message dwType values
 *
 *****************************************)

(*
 *  The application has read the connection settings.
 *  It is now O.K. for the lobby client to release
 *  its IDirectPlayLobby interface.
 *)
  DPLSYS_CONNECTIONSETTINGSREAD = $00000001;

(*
 *  The application's call to DirectPlayConnect failed
 *)
  DPLSYS_DPLAYCONNECTFAILED = $00000002;

(*
 *  The application has created a DirectPlay session.
 *)
  DPLSYS_DPLAYCONNECTSUCCEEDED = $00000003;

(*
 *  The application has terminated.
 *)
  DPLSYS_APPTERMINATED = $00000004;

(*
 *  The message is a TDPLMsg_SetProperty message.
 *)
  DPLSYS_SETPROPERTY = $00000005;

(*
 *  The message is a TDPLMsg_SetPropertyResponse message.
 *)
  DPLSYS_SETPROPERTYRESPONSE = $00000006;

(*
 *  The message is a TDPLMsg_GetProperty message.
 *)
  DPLSYS_GETPROPERTY = $00000007;

(*
 *  The message is a TDPLMsg_GetPropertyResponse message.
 *)
  DPLSYS_GETPROPERTYRESPONSE = $00000008;

(*
 *  The message is a TDPLMsg_NewSessionHost message.
 *)
  DPLSYS_NEWSESSIONHOST = $00000009;

(*
 *  New connection settings are available.
 *)
  DPLSYS_NEWCONNECTIONSETTINGS = $0000000A;

(****************************************************************************
 *
 * DirectPlay defined property GUIDs and associated data structures
 *
 ****************************************************************************)

(*
 * DPLPROPERTY_MessagesSupported
 *
 * Request whether the lobby supports standard.  Lobby with respond with either
 * TRUE or FALSE or may not respond at all.
 * 
 * Property data is a single BOOL with TRUE or FALSE
 *)
// {762CCDA1-D916-11d0-BA39-00C04FD7ED67}
  DPLPROPERTY_MessagesSupported: TGUID =
      (D1:$762ccda1;D2:$d916;D3:$11d0;D4:($ba,$39,$00,$c0,$4f,$d7,$ed,$67));

(*
 * DPLPROPERTY_LobbyGuid
 *
 * Request the GUID that identifies the lobby software that the application
 * is communicating with.
 *
 * Property data is a single GUID.
 *)
// {F56920A0-D218-11d0-BA39-00C04FD7ED67}
  DPLPROPERTY_LobbyGuid: TGUID =
      (D1:$F56920A0;D2:$D218;D3:$11d0;D4:($ba,$39,$00,$c0,$4f,$d7,$ed,$67));

(*
 * DPLPROPERTY_PlayerGuid
 *
 * Request the GUID that identifies the player on this machine for sending
 * property data back to the lobby.
 *
 * Property data is the DPLDATA_PLAYERDATA structure
 *)
// {B4319322-D20D-11d0-BA39-00C04FD7ED67}
  DPLPROPERTY_PlayerGuid: TGUID =
      (D1:$b4319322;D2:$d20d;D3:$11d0;D4:($ba,$39,$00,$c0,$4f,$d7,$ed,$67));

type
(*
 * TDPLData_PlayerGUID
 *
 * Data structure to hold the GUID of the player and player creation flags
 * from the lobby.
 *)
  PDPLData_PlayerGUID = ^TDPLData_PlayerGUID;
  TDPLData_PlayerGUID = packed record
    guidPlayer: TGUID;
    dwPlayerFlags: DWORD;
  end;

const
(*
 * DPLPROPERTY_PlayerScore
 *
 * Used to send an array of long integers to the lobby indicating the 
 * score of a player.
 *
 * Property data is the TDPLData_PlayerScore structure.
 *)
// {48784000-D219-11d0-BA39-00C04FD7ED67}
  DPLPROPERTY_PlayerScore: TGUID =
      (D1:$48784000;D2:$d219;D3:$11d0;D4:($ba,$39,$00,$c0,$4f,$d7,$ed,$67));

type
(*
 * TDPLData_PlayerScore
 *
 * Data structure to hold an array of long integers representing a player score.
 * Application must allocate enough memory to hold all the scores.
 *)
  PDPLData_PlayerScore = ^TDPLData_PlayerScore;
  TDPLData_PlayerScore = packed record
    dwScoreCount: DWORD;
    Score: array[0..0] of LongInt;
  end;

(****************************************************************************
 *
 * DirectPlay Address ID's
 *
 ****************************************************************************)

(* DirectPlay Address
 *
 * A DirectPlay address consists of multiple chunks of data, each tagged
 * with a GUID signifying the type of data in the chunk. The chunk also
 * has a length so that unknown chunk types can be skipped.
 *
 * The EnumAddress() function is used to parse these address data chunks.
 *)

(*
 * TDPAddress
 *
 * Header for block of address data elements
 *)
  PDPAddress = ^TDPAddress;
  TDPAddress = packed record
    guidDataType: TGUID;
    dwDataSize: DWORD;
  end;

const
(*
 * DPAID_TotalSize
 *
 * Chunk is a DWORD containing size of entire TDPAddress structure
 *)

// {1318F560-912C-11d0-9DAA-00A0C90A43CB}
  DPAID_TotalSize: TGUID =
      (D1:$1318f560;D2:$912c;D3:$11d0;D4:($9d,$aa,$00,$a0,$c9,$a,$43,$cb));

(*
 * DPAID_ServiceProvider
 *
 * Chunk is a GUID describing the service provider that created the chunk.
 * All addresses must contain this chunk.
 *)

// {07D916C0-E0AF-11cf-9C4E-00A0C905425E}
  DPAID_ServiceProvider: TGUID =
      (D1:$7d916c0;D2:$e0af;D3:$11cf;D4:($9c,$4e,$00,$a0,$c9,$5,$42,$5e));

(*
 * DPAID_LobbyProvider
 *
 * Chunk is a GUID describing the lobby provider that created the chunk.
 * All addresses must contain this chunk.
 *)

// {59B95640-9667-11d0-A77D-0000F803ABFC}
  DPAID_LobbyProvider: TGUID =
      (D1:$59b95640;D2:$9667;D3:$11d0;D4:($a7,$7d,$00,$00,$f8,$3,$ab,$fc));

(*
 * DPAID_Phone and DPAID_PhoneW
 *
 * Chunk is a string containing a phone number (i.e. "1-800-555-1212")
 * in ANSI or UNICODE format
 *)

// {78EC89A0-E0AF-11cf-9C4E-00A0C905425E}
  DPAID_Phone: TGUID =
      (D1:$78ec89a0;D2:$e0af;D3:$11cf;D4:($9c,$4e,$00,$a0,$c9,$5,$42,$5e));

// {BA5A7A70-9DBF-11d0-9CC1-00A0C905425E}
  DPAID_PhoneW: TGUID =
      (D1:$ba5a7a70;D2:$9dbf;D3:$11d0;D4:($9c,$c1,$00,$a0,$c9,$5,$42,$5e));

(*
 * DPAID_Modem and DPAID_ModemW
 *
 * Chunk is a string containing a modem name registered with TAPI
 * in ANSI or UNICODE format
 *)

// {F6DCC200-A2FE-11d0-9C4F-00A0C905425E}
  DPAID_Modem: TGUID =
      (D1:$f6dcc200;D2:$a2fe;D3:$11d0;D4:($9c,$4f,$00,$a0,$c9,$5,$42,$5e));

// {01FD92E0-A2FF-11d0-9C4F-00A0C905425E}
  DPAID_ModemW: TGUID =
      (D1:$1fd92e0;D2:$a2ff;D3:$11d0;D4:($9c,$4f,$00,$a0,$c9,$5,$42,$5e));

(*
 * DPAID_Inet and DPAID_InetW
 *
 * Chunk is a string containing a TCP/IP host name or an IP address
 * (i.e. "dplay.microsoft.com" or "137.55.100.173") in ANSI or UNICODE format
 *)

// {C4A54DA0-E0AF-11cf-9C4E-00A0C905425E}
  DPAID_INet: TGUID =
      (D1:$c4a54da0;D2:$e0af;D3:$11cf;D4:($9c,$4e,$00,$a0,$c9,$5,$42,$5e));

// {E63232A0-9DBF-11d0-9CC1-00A0C905425E}
  DPAID_INetW: TGUID =
      (D1:$e63232a0;D2:$9dbf;D3:$11d0;D4:($9c,$c1,$00,$a0,$c9,$5,$42,$5e));

(*
 * DPAID_InetPort
 *
 * Chunk is the port number used for creating the apps TCP and UDP sockets.
 * WORD value (i.e. 47624)
 *)

// {E4524541-8EA5-11d1-8A96-006097B01411}
  DPAID_INetPort: TGUID =
      (D1:$e4524541;D2:$8ea5;D3:$11d1;D4:($8a,$96,$00,$60,$97,$b0,$14,$11));

(*
 * DPAID_MaxMessageSize
 *
 * Tells DPLAY what the maximum allowed message size is.  Enables SPs to
 *	combat Denial of Service attacks
 *)

 // this terrible hack is needed so the SP can work with the Elmer build.
 // it can be removed when the MSINTERNAL stuff is removed

// {F5D09980-F0C4-11d1-8326-006097B01411}
  DPAID_MaxMessageSize: TGUID =
      (D1:$f5d09980;D2:$f0c4;D3:$11d1;D4:($83,$26,$00,$60,$97,$b0,$14,$11));

(*
 * TDPComPortAddress
 *
 * Used to specify com port settings. The constants that define baud rate,
 * stop bits and parity are defined in WINBASE.H. The constants for flow
 * control are given below.
 *)

  DPCPA_NOFLOW       = 0;           // no flow control
  DPCPA_XONXOFFFLOW  = 1;           // software flow control
  DPCPA_RTSFLOW      = 2;           // hardware flow control with RTS
  DPCPA_DTRFLOW      = 3;           // hardware flow control with DTR
  DPCPA_RTSDTRFLOW   = 4;           // hardware flow control with RTS and DTR

type
  PDPComPortAddress = ^TDPComPortAddress;
  TDPComPortAddress = packed record
    dwComPort: DWORD;       // COM port to use (1-4)
    dwBaudRate: DWORD;      // baud rate (100-256k)
    dwStopBits: DWORD;      // no. stop bits (1-2)
    dwParity: DWORD;        // parity (none, odd, even, mark)
    dwFlowControl: DWORD;   // flow control (none, xon/xoff, rts, dtr)
  end;

const
(*
 * DPAID_ComPort
 *
 * Chunk contains a TDPComPortAddress structure defining the serial port.
 *)

// {F2F0CE00-E0AF-11cf-9C4E-00A0C905425E}
  DPAID_ComPort: TGUID =
      (D1:$f2f0ce00;D2:$e0af;D3:$11cf;D4:($9c,$4e,$00,$a0,$c9,$5,$42,$5e));

(****************************************************************************
 *
 * 	dplobby 1.0 obsolete definitions
 *	Included for compatibility only.
 *
 ****************************************************************************)

  DPLAD_SYSTEM = DPLMSG_SYSTEM;

(******************************************************************************)
(**                                                                          **)
(** DSound.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

const
  _FACDS = $878;
function MAKE_DSHResult(code: DWORD) : HResult; StdCall;

const
// Direct Sound Component GUID {47D4D946-62E8-11cf-93BC-444553540000}
  CLSID_DirectSound: TGUID =      (D1:$47d4d946;D2:$62e8;D3:$11cf;D4:($93,$bc,$44,$45,$53,$54,$00,$0));

// DirectSound Capture Component GUID {B0210780-89CD-11d0-AF08-00A0C925CD16}
  CLSID_DirectSoundCapture: TGUID =      (D1:$b0210780;D2:$89cd;D3:$11d0;D4:($af,$8,$00,$a0,$c9,$25,$cd,$16));

//
// GUID's for all the objects
//
const
  IID_IDirectSound: TGUID =      (D1:$279AFA83;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSoundBuffer: TGUID =      (D1:$279AFA85;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSound3DListener: TGUID =      (D1:$279AFA84;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSound3DBuffer: TGUID =      (D1:$279AFA86;D2:$4981;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectSoundCapture: TGUID =      (D1:$b0210781;D2:$89cd;D3:$11d0;D4:($af,$08,$00,$a0,$c9,$25,$cd,$16));
  IID_IDirectSoundCaptureBuffer: TGUID =      (D1:$b0210782;D2:$89cd;D3:$11d0;D4:($af,$08,$00,$a0,$c9,$25,$cd,$16));
  IID_IDirectSoundNotify: TGUID =      (D1:$b0210783;D2:$89cd;D3:$11d0;D4:($af,$08,$00,$a0,$c9,$25,$cd,$16));
  IID_IKsPropertySet: TGUID =      (D1:$31efac30;D2:$515c;D3:$11d0;D4:($a9,$aa,$00,$aa,$00,$61,$be,$93));



//
// Structures
//
type
  IDirectSound = interface;
  IDirectSoundBuffer = interface;
  IDirectSound3DListener = interface;
  IDirectSound3DBuffer = interface;
  IDirectSoundCapture = interface;
  IDirectSoundCaptureBuffer = interface;
  IDirectSoundNotify = interface;
  IKsPropertySet = interface;

  PDSCaps = ^TDSCaps;
  TDSCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwMinSecondarySampleRate: DWORD;
    dwMaxSecondarySampleRate: DWORD;
    dwPrimaryBuffers: DWORD;
    dwMaxHwMixingAllBuffers: DWORD;
    dwMaxHwMixingStaticBuffers: DWORD;
    dwMaxHwMixingStreamingBuffers: DWORD;
    dwFreeHwMixingAllBuffers: DWORD;
    dwFreeHwMixingStaticBuffers: DWORD;
    dwFreeHwMixingStreamingBuffers: DWORD;
    dwMaxHw3DAllBuffers: DWORD;
    dwMaxHw3DStaticBuffers: DWORD;
    dwMaxHw3DStreamingBuffers: DWORD;
    dwFreeHw3DAllBuffers: DWORD;
    dwFreeHw3DStaticBuffers: DWORD;
    dwFreeHw3DStreamingBuffers: DWORD;
    dwTotalHwMemBytes: DWORD;
    dwFreeHwMemBytes: DWORD;
    dwMaxContigFreeHwMemBytes: DWORD;
    dwUnlockTransferRateHwBuffers: DWORD;
    dwPlayCpuOverheadSwBuffers: DWORD;
    dwReserved1: DWORD;
    dwReserved2: DWORD;
  end;
  PCDSCaps = ^TDSCaps;

  PDSBCaps = ^TDSBCaps;
  TDSBCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwUnlockTransferRate: DWORD;
    dwPlayCpuOverhead: DWORD;
  end;
  PCDSBCaps = ^TDSBCaps;

  PDSBufferDesc = ^TDSBufferDesc;
  TDSBufferDesc = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
    lpwfxFormat: PWaveFormatEx;
  end;
  PCDSBufferDesc = ^TDSBufferDesc;

  PDS3DBuffer = ^TDS3DBuffer;
  TDS3DBuffer = packed record
    dwSize: DWORD;
    vPosition: TD3DVector;
    vVelocity: TD3DVector;
    dwInsideConeAngle: DWORD;
    dwOutsideConeAngle: DWORD;
    vConeOrientation: TD3DVector;
    lConeOutsideVolume: Longint;
    flMinDistance: TD3DValue;
    flMaxDistance: TD3DValue;
    dwMode: DWORD;
  end;
  TCDS3DBuffer = ^TDS3DBuffer;

  PDS3DListener = ^TDS3DListener;
  TDS3DListener = packed record
    dwSize: DWORD;
    vPosition: TD3DVector;
    vVelocity: TD3DVector;
    vOrientFront: TD3DVector;
    vOrientTop: TD3DVector;
    flDistanceFactor: TD3DValue;
    flRolloffFactor: TD3DValue;
    flDopplerFactor: TD3DValue;
  end;
  PCDS3DListener = ^TDS3DListener;

  PDSCCaps = ^TDSCCaps;
  TDSCCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwFormats: DWORD;
    dwChannels: DWORD;
  end;
  PCDSCCaps = ^TDSCCaps;

  PDSCBufferDesc = ^TDSCBufferDesc;
  TDSCBufferDesc = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
    lpwfxFormat: PWaveFormatEx;
  end;
  PCDSCBufferDesc = ^TDSCBufferDesc;

  PDSCBCaps = ^TDSCBCaps;
  TDSCBCaps = packed record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwBufferBytes: DWORD;
    dwReserved: DWORD;
  end;
  PCDSCBCaps = ^TDSCBCaps;

  PDSBPositionNotify = ^TDSBPositionNotify;
  TDSBPositionNotify = packed record
    dwOffset: DWORD;
    hEventNotify: THandle;
  end;
  PCDSBPositionNotify = ^TDSBPositionNotify;

//
// DirectSound API
//
  TDSEnumCallbackW = function (lpGuid: PGUID; lpstrDescription: PWideChar;
      lpstrModule: PWideChar; lpContext: Pointer) : BOOL; stdcall;
  TDSEnumCallbackA = function (lpGuid: PGUID; lpstrDescription: PAnsiChar;
      lpstrModule: PAnsiChar; lpContext: Pointer) : BOOL; stdcall;
{$IFDEF UNICODE}
  TDSEnumCallback = TDSEnumCallbackW;
{$ELSE}
  TDSEnumCallback = TDSEnumCallbackA;
{$ENDIF}

//
// IDirectSound
//
  IDirectSound = interface (IUnknown)
    ['{279AFA83-4981-11CE-A521-0020AF0BE560}']
    // IDirectSound methods
    function CreateSoundBuffer(const lpDSBufferDesc: TDSBufferDesc; var lpIDirectSoundBuffer: IDirectSoundBuffer; pUnkOuter: IUnknown) : HResult; StdCall;
    function GetCaps(var lpDSCaps: TDSCaps) : HResult; StdCall;
    function DuplicateSoundBuffer(lpDsbOriginal: IDirectSoundBuffer; var lpDsbDuplicate: IDirectSoundBuffer) : HResult; StdCall;
    function SetCooperativeLevel(hwnd: HWND; dwLevel: DWORD) : HResult; StdCall;
    function Compact: HResult;
    function GetSpeakerConfig(var lpdwSpeakerConfig: DWORD) : HResult; StdCall;
    function SetSpeakerConfig(dwSpeakerConfig: DWORD) : HResult; StdCall;
    function Initialize(lpGuid: PGUID) : HResult; StdCall;
  end;

//
// IDirectSoundBuffer
//
  IDirectSoundBuffer = interface (IUnknown)
    ['{279AFA85-4981-11CE-A521-0020AF0BE560}']
    // IDirectSoundBuffer methods
    function GetCaps(var lpDSCaps: TDSBCaps) : HResult; StdCall; 
    function GetCurrentPosition(lpdwCapturePosition, lpdwReadPosition : PDWORD) : HResult; StdCall;
    function GetFormat(lpwfxFormat: PWaveFormatEx; dwSizeAllocated: DWORD; lpdwSizeWritten: PWORD) : HResult; StdCall;
    function GetVolume(var lplVolume: integer) : HResult; StdCall;
    function GetPan(var lplPan: integer) : HResult; StdCall;
    function GetFrequency(var lpdwFrequency: DWORD) : HResult; StdCall;
    function GetStatus(var lpdwStatus: DWORD) : HResult; StdCall;
    function Initialize(lpDirectSound: IDirectSound; var lpcDSBufferDesc: TDSBufferDesc) : HResult; StdCall;
    function Lock(dwWriteCursor, dwWriteBytes: DWORD; var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: DWORD; var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function Play(dwReserved1,dwReserved2,dwFlags: DWORD) : HResult; StdCall;
    function SetCurrentPosition(dwPosition: DWORD) : HResult; StdCall;
    function SetFormat(const lpcfxFormat: TWaveFormatEx) : HResult; StdCall;
    function SetVolume(lVolume: integer) : HResult; StdCall;
    function SetPan(lPan: integer) : HResult; StdCall;
    function SetFrequency(dwFrequency: DWORD) : HResult; StdCall;
    function Stop: HResult;
    function Unlock(lpvAudioPtr1: Pointer; dwAudioBytes1: DWORD; lpvAudioPtr2: Pointer; dwAudioBytes2: DWORD) : HResult; StdCall;
    function Restore: HResult;
  end;

//
// IDirectSound3DListener
//
  IDirectSound3DListener = interface (IUnknown)
    ['{279AFA84-4981-11CE-A521-0020AF0BE560}']
    // IDirectSound3D methods
    function GetAllParameters(var lpListener: TDS3DListener) : HResult; StdCall; 
    function GetDistanceFactor(var lpflDistanceFactor: TD3DValue) : HResult; StdCall;
    function GetDopplerFactor(var lpflDopplerFactor: TD3DValue) : HResult; StdCall;
    function GetOrientation(var lpvOrientFront, lpvOrientTop: TD3DVector) : HResult; StdCall;
    function GetPosition(var lpvPosition: TD3DVector) : HResult; StdCall;
    function GetRolloffFactor(var lpflRolloffFactor: TD3DValue) : HResult; StdCall;
    function GetVelocity(var lpvVelocity: TD3DVector) : HResult; StdCall;
    function SetAllParameters(var lpcListener: TDS3DListener; dwApply: DWORD) : HResult; StdCall;
    function SetDistanceFactor(flDistanceFactor: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetDopplerFactor(flDopplerFactor: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetOrientation(xFront, yFront, zFront, xTop, yTop, zTop: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetPosition(x, y, z: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetRolloffFactor(flRolloffFactor: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetVelocity(x, y, z: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function CommitDeferredSettings: HResult;
  end;


//
// IDirectSound3DBuffer
//
  IDirectSound3DBuffer = interface (IUnknown)
    ['{279AFA86-4981-11CE-A521-0020AF0BE560}']
    // IDirectSoundBuffer3D methods
    function GetAllParameters(var lpDs3dBuffer: TDS3DBuffer) : HResult; StdCall;  
    function GetConeAngles(var lpdwInsideConeAngle, lpdwOutsideConeAngle: DWORD) : HResult; StdCall;
    function GetConeOrientation(var lpvOrientation: TD3DVector) : HResult; StdCall;
    function GetConeOutsideVolume(var lplConeOutsideVolume: integer) : HResult; StdCall;
    function GetMaxDistance(var lpflMaxDistance: TD3DValue) : HResult; StdCall;
    function GetMinDistance(var lpflMinDistance: TD3DValue) : HResult; StdCall;
    function GetMode(var lpdwMode: DWORD) : HResult; StdCall;
    function GetPosition(var lpvPosition: TD3DVector) : HResult; StdCall;
    function GetVelocity(var lpvVelocity: TD3DVector) : HResult; StdCall;
    function SetAllParameters(var lpcDs3dBuffer: TDS3DBuffer; dwApply: DWORD) : HResult; StdCall;
    function SetConeAngles(dwInsideConeAngle, dwOutsideConeAngle, dwApply: DWORD) : HResult; StdCall;
    function SetConeOrientation(x, y, z: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetConeOutsideVolume(lConeOutsideVolume: integer; dwApply: DWORD) : HResult; StdCall;
    function SetMaxDistance(flMaxDistance: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetMinDistance(flMinDistance: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetMode(dwMode: DWORD; dwApply: DWORD) : HResult; StdCall;
    function SetPosition(x, y, z: TD3DValue; dwApply: DWORD) : HResult; StdCall;
    function SetVelocity(x, y, z: TD3DValue; dwApply: DWORD) : HResult; StdCall;
  end;


//
// IDirectSoundCapture
//
  IDirectSoundCapture = interface (IUnknown)
    ['{b0210781-89cd-11d0-af08-00a0c925cd16}']
    // IDirectSoundCapture methods
    function CreateCaptureBuffer(const lpDSCBufferDesc: TDSCBufferDesc; var lplpDirectSoundCaptureBuffer: IDirectSoundCaptureBuffer; pUnkOuter: IUnknown) : HResult; StdCall;
    function GetCaps(var lpdwCaps: TDSCCaps) : HResult; StdCall;
    function Initialize(lpGuid: PGUID) : HResult; StdCall;
  end;


//
// IDirectSoundCaptureBuffer
//
  IDirectSoundCaptureBuffer = interface (IUnknown)
    ['{b0210782-89cd-11d0-af08-00a0c925cd16}']
    // IDirectSoundCaptureBuffer methods
    function GetCaps(var lpdwCaps: TDSCBCaps) : HResult; StdCall; 
    function GetCurrentPosition(lpdwCapturePosition, lpdwReadPosition: PDWORD) : HResult; StdCall;
    function GetFormat(lpwfxFormat: PWaveFormatEx; dwSizeAllocated: DWORD; lpdwSizeWritten : PDWORD) : HResult; StdCall;
    function GetStatus(var lpdwStatus: DWORD) : HResult; StdCall;
    function Initialize(lpDirectSoundCapture: IDirectSoundCapture; var lpcDSBufferDesc: TDSCBufferDesc) : HResult; StdCall;
    function Lock(dwReadCursor, dwReadBytes: DWORD; var lplpvAudioPtr1: Pointer; var lpdwAudioBytes1: DWORD; var lplpvAudioPtr2: Pointer; var lpdwAudioBytes2: DWORD; dwFlags: DWORD) : HResult; StdCall;
    function Start(dwFlags: DWORD) : HResult; StdCall;
    function Stop: HResult;
    function Unlock(lpvAudioPtr1: Pointer; dwAudioBytes1: DWORD; lpvAudioPtr2: Pointer; dwAudioBytes2: DWORD) : HResult; StdCall;
  end;

//
// IDirectSoundNotify
//
  IDirectSoundNotify = interface (IUnknown)
    ['{b0210783-89cd-11d0-af08-00a0c925cd16}']
    // IDirectSoundNotify methods
    function SetNotificationPositions(cPositionNotifies: DWORD; var lpcPositionNotifies: TDSBPositionNotify) : HResult; StdCall;
  end;

//
// IKsPropertySet
//
  IKsPropertySet = interface (IUnknown)
    ['{31efac30-515c-11d0-a9aa-00aa0061be93}']
    // IKsPropertySet methods
    function Get(const rguidPropSet: TGUID; ulId: DWORD; var pInstanceData; ulInstanceLength: DWORD; var pPropertyData; ulDataLength: DWORD; var pulBytesReturned: DWORD) : HResult; StdCall; 
    // Warning: The following method is defined as Set() in DirectX
    //          which is a reserved word in Delphi!
    function SetProperty(const rguidPropSet: TGUID; ulId: DWORD; var pInstanceData; ulInstanceLength: DWORD; var pPropertyData; pulDataLength: DWORD) : HResult; StdCall;
    function QuerySupport(const rguidPropSet: TGUID; ulId: DWORD; var pulTypeSupport: DWORD) : HResult; StdCall;
  end;


const
  KSPROPERTY_SUPPORT_GET = $00000001;
  KSPROPERTY_SUPPORT_SET = $00000002;

//
// Creation Routines
//
var
   DirectSoundCreate : function ( lpGuid: PGUID;
      OutppDS: IDirectSound;
      pUnkOuter: IUnknown) : HResult; StdCall;

   DirectSoundEnumerateW : function (lpDSEnumCallback: TDSEnumCallbackW; lpContext: Pointer) : HResult; StdCall;
   DirectSoundEnumerateA : function (lpDSEnumCallback: TDSEnumCallbackA; lpContext: Pointer) : HResult; StdCall;
   DirectSoundEnumerate : function (lpDSEnumCallback: TDSEnumCallback; lpContext: Pointer) : HResult; StdCall;

   DirectSoundCaptureCreate : function (lpGUID: PGUID; Out lplpDSC: IDirectSoundCapture; pUnkOuter: IUnknown) : HResult; StdCall;

   DirectSoundCaptureEnumerateW : function (lpDSEnumCallback: TDSEnumCallbackW; lpContext: Pointer) : HResult; StdCall;
   DirectSoundCaptureEnumerateA : function (lpDSEnumCallback: TDSEnumCallbackA; lpContext: Pointer) : HResult; StdCall;
   DirectSoundCaptureEnumerate  : function (lpDSEnumCallback: TDSEnumCallback; lpContext: Pointer) : HResult; StdCall;


//
// Return Codes
//

const
  DS_OK = 0;

// The call failed because resources (such as a priority level)
// were already being used by another caller.
  DSERR_ALLOCATED = $88780000 + 10;

// The control (vol,pan,etc.) requested by the caller is not available.
  DSERR_CONTROLUNAVAIL = $88780000 + 30;

// An invalid parameter was passed to the returning function
  DSERR_INVALIDPARAM = E_INVALIDARG;

// This call is not valid for the current state of this object
  DSERR_INVALIDCALL = $88780000 + 50;

// An undetermined error occured inside the DirectSound subsystem
  DSERR_GENERIC = E_FAIL;

// The caller does not have the priority level required for the function to
// succeed.
  DSERR_PRIOLEVELNEEDED = $88780000 + 70;

// Not enough free memory is available to complete the operation
  DSERR_OUTOFMEMORY = E_OUTOFMEMORY;

// The specified WAVE format is not supported
  DSERR_BADFORMAT = $88780000 + 100;

// The function called is not supported at this time
  DSERR_UNSUPPORTED = E_NOTIMPL;

// No sound driver is available for use
  DSERR_NODRIVER = $88780000 + 120;

// This object is already initialized
  DSERR_ALREADYINITIALIZED = $88780000 + 130;

// This object does not support aggregation
  DSERR_NOAGGREGATION = CLASS_E_NOAGGREGATION;

// The buffer memory has been lost, and must be restored.
  DSERR_BUFFERLOST = $88780000 + 150;

// Another app has a higher priority level, preventing this call from
// succeeding.
  DSERR_OTHERAPPHASPRIO = $88780000 + 160;

// This object has not been initialized
  DSERR_UNINITIALIZED = $88780000 + 170;

// The requested COM interface is not available
  DSERR_NOINTERFACE = E_NOINTERFACE;

//
// Flags
//

  DSCAPS_PRIMARYMONO = $00000001;
  DSCAPS_PRIMARYSTEREO = $00000002;
  DSCAPS_PRIMARY8BIT = $00000004;
  DSCAPS_PRIMARY16BIT = $00000008;
  DSCAPS_CONTINUOUSRATE = $00000010;
  DSCAPS_EMULDRIVER = $00000020;
  DSCAPS_CERTIFIED = $00000040;
  DSCAPS_SECONDARYMONO = $00000100;
  DSCAPS_SECONDARYSTEREO = $00000200;
  DSCAPS_SECONDARY8BIT = $00000400;
  DSCAPS_SECONDARY16BIT = $00000800;

  DSBPLAY_LOOPING = $00000001;
      
  DSBSTATUS_PLAYING = $00000001;
  DSBSTATUS_BUFFERLOST = $00000002;
  DSBSTATUS_LOOPING = $00000004;

  DSBLOCK_FROMWRITECURSOR = $00000001;
  DSBLOCK_ENTIREBUFFER = $00000002;

  DSSCL_NORMAL = $00000001;
  DSSCL_PRIORITY = $00000002;
  DSSCL_EXCLUSIVE = $00000003;
  DSSCL_WRITEPRIMARY = $00000004;

  DS3DMODE_NORMAL = $00000000;
  DS3DMODE_HEADRELATIVE = $00000001;
  DS3DMODE_DISABLE = $00000002;

  DS3D_IMMEDIATE = $00000000;
  DS3D_DEFERRED = $00000001;

  DS3D_MINDISTANCEFACTOR = 0.0;
  DS3D_MAXDISTANCEFACTOR = 10.0;
  DS3D_DEFAULTDISTANCEFACTOR = 1.0;

  DS3D_MINROLLOFFFACTOR = 0.0;
  DS3D_MAXROLLOFFFACTOR = 10.0;
  DS3D_DEFAULTROLLOFFFACTOR = 1.0;

  DS3D_MINDOPPLERFACTOR = 0.0;
  DS3D_MAXDOPPLERFACTOR = 10.0;
  DS3D_DEFAULTDOPPLERFACTOR = 1.0;

  DS3D_DEFAULTMINDISTANCE = 1.0;
  DS3D_DEFAULTMAXDISTANCE = 1000000000.0;

  DS3D_MINCONEANGLE = 0;
  DS3D_MAXCONEANGLE = 360;
  DS3D_DEFAULTCONEANGLE = 360;

  DS3D_DEFAULTCONEOUTSIDEVOLUME = 0;

  DSBCAPS_PRIMARYBUFFER = $00000001;
  DSBCAPS_STATIC = $00000002;
  DSBCAPS_LOCHARDWARE = $00000004;
  DSBCAPS_LOCSOFTWARE = $00000008;
  DSBCAPS_CTRL3D = $00000010;
  DSBCAPS_CTRLFREQUENCY = $00000020;
  DSBCAPS_CTRLPAN = $00000040;
  DSBCAPS_CTRLVOLUME = $00000080;
  DSBCAPS_CTRLPOSITIONNOTIFY = $00000100;
  DSBCAPS_CTRLDEFAULT = $000000E0;
  DSBCAPS_CTRLALL = $000001F0;
  DSBCAPS_STICKYFOCUS = $00004000;
  DSBCAPS_GLOBALFOCUS = $00008000;
  DSBCAPS_GETCURRENTPOSITION2 = $00010000;
  DSBCAPS_MUTE3DATMAXDISTANCE = $00020000;

  DSCBCAPS_WAVEMAPPED = $80000000;

  DSSPEAKER_HEADPHONE = $00000001;
  DSSPEAKER_MONO = $00000002;
  DSSPEAKER_QUAD = $00000003;
  DSSPEAKER_STEREO = $00000004;
  DSSPEAKER_SURROUND = $00000005;

  DSSPEAKER_GEOMETRY_MIN     = $00000005;  //   5 degrees
  DSSPEAKER_GEOMETRY_NARROW  = $0000000A;  //  10 degrees
  DSSPEAKER_GEOMETRY_WIDE    = $00000014;  //  20 degrees
  DSSPEAKER_GEOMETRY_MAX     = $000000B4;  // 180 degrees

function DSSPEAKER_COMBINED(c, g: variant) : DWORD;
function DSSPEAKER_CONFIG(a: variant) : byte;
function DSSPEAKER_GEOMETRY(a: variant) : byte;

const
  DSCCAPS_EMULDRIVER = $00000020;

  DSCBLOCK_ENTIREBUFFER = $00000001;

  DSCBSTATUS_CAPTURING = $00000001;
  DSCBSTATUS_LOOPING = $00000002;

  DSCBSTART_LOOPING = $00000001;

  DSBFREQUENCY_MIN = 100;
  DSBFREQUENCY_MAX = 100000;
  DSBFREQUENCY_ORIGINAL = 0;

  DSBPAN_LEFT = -10000;
  DSBPAN_CENTER = 0;
  DSBPAN_RIGHT = 10000;

  DSBVOLUME_MIN = -10000;
  DSBVOLUME_MAX = 0;

  DSBSIZE_MIN = 4;
  DSBSIZE_MAX = $0FFFFFFF;

  DSBPN_OFFSETSTOP = DWORD(-1);

(******************************************************************************)
(**                                                                          **)
(** DSetup.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** DVP.Pas                                                                  **)
(**                                                                          **)
(******************************************************************************)

const
(*
 * GUIDS used by DirectDrawVideoPort objects
 *)
  IID_IDDVideoPortContainer: TGUID =      (D1:$6C142760;D2:$A733;D3:$11CE;D4:($A5,$21,$00,$20,$AF,$0B,$E5,$60));
  IID_IDirectDrawVideoPort: TGUID =      (D1:$B36D93E0;D2:$2B43;D3:$11CF;D4:($A2,$DE,$00,$AA,$00,$B9,$33,$56));

  DDVPTYPE_E_HREFH_VREFH: TGUID =      (D1:$54F39980;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_E_HREFH_VREFL: TGUID =      (D1:$92783220;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_E_HREFL_VREFH: TGUID =      (D1:$A07A02E0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_E_HREFL_VREFL: TGUID =      (D1:$E09C77E0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_CCIR656: TGUID =      (D1:$FCA326A0;D2:$DA60;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_BROOKTREE: TGUID =      (D1:$1352A560;D2:$DA61;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));
  DDVPTYPE_PHILIPS: TGUID =      (D1:$332CF160;D2:$DA61;D3:$11CF;D4:($9B,$06,$00,$A0,$C9,$03,$A3,$B8));

(*
 * GUIDS used to describe connections
 *)

(*============================================================================
 *
 * DirectDraw Structures
 *
 * Various structures used to invoke DirectDraw.
 *
 *==========================================================================*)

type

(*
 * TDDVideoPortConnect
 *)
  PDDVideoPortConnect = ^TDDVideoPortConnect;
  TDDVideoPortConnect = packed record
    dwSize: DWORD;        // size of the TDDVideoPortConnect structure
    dwPortWidth: DWORD;   // Width of the video port
    guidTypeID: TGUID;    // Description of video port connection
    dwFlags: DWORD;       // Connection flags
    dwReserved1: DWORD;   // Reserved, set to zero.
  end;

(*
 * TDDVideoPortCaps
 *)
  PDDVideoPortCaps = ^TDDVideoPortCaps;
  TDDVideoPortCaps = packed record
    dwSize: DWORD;                          // size of the TDDVideoPortCaps structure
    dwFlags: DWORD;                         // indicates which fields contain data
    dwMaxWidth: DWORD;                      // max width of the video port field
    dwMaxVBIWidth: DWORD;                   // max width of the VBI data
    dwMaxHeight: DWORD;                     // max height of the video port field
    dwVideoPortID: DWORD;                   // Video port ID (0 - (dwMaxVideoPorts -1))
    dwCaps: DWORD;                          // Video port capabilities
    dwFX: DWORD;                            // More video port capabilities
    dwNumAutoFlipSurfaces: DWORD;           // Number of autoflippable surfaces
    dwAlignVideoPortBoundary: DWORD;        // Byte restriction of placement within the surface
    dwAlignVideoPortPrescaleWidth: DWORD;   // Byte restriction of width after prescaling
    dwAlignVideoPortCropBoundary: DWORD;    // Byte restriction of left cropping
    dwAlignVideoPortCropWidth: DWORD;       // Byte restriction of cropping width
    dwPreshrinkXStep: DWORD;                // Width can be shrunk in steps of 1/x
    dwPreshrinkYStep: DWORD;                // Height can be shrunk in steps of 1/x
    dwNumVBIAutoFlipSurfaces: DWORD;        // Number of VBI autoflippable surfaces
    dwNumPreferredAutoflip: DWORD;	// Optimal number of autoflippable surfaces for hardware
    wNumFilterTapsX: WORD;              // Number of taps the prescaler uses in the X direction (0 - no prescale, 1 - replication, etc.)
    wNumFilterTapsY: WORD;              // Number of taps the prescaler uses in the Y direction (0 - no prescale, 1 - replication, etc.)
  end;

const
(*
 * The dwMaxWidth and dwMaxVBIWidth members are valid
 *)
  DDVPD_WIDTH = $00000001;

(*
 * The dwMaxHeight member is valid
 *)
  DDVPD_HEIGHT = $00000002;

(*
 * The dwVideoPortID member is valid
 *)
  DDVPD_ID = $00000004;

(*
 * The dwCaps member is valid
 *)
  DDVPD_CAPS = $00000008;

(*
 * The dwFX member is valid
 *)
  DDVPD_FX = $00000010;

(*
 * The dwNumAutoFlipSurfaces member is valid
 *)
  DDVPD_AUTOFLIP = $00000020;

(*
 * All of the alignment members are valid
 *)
  DDVPD_ALIGN = $00000040;

(*
 * The dwNumPreferredAutoflip member is valid
 *)
  DDVPD_PREFERREDAUTOFLIP = $00000080;

(*
 * The wNumFilterTapsX and wNumFilterTapsY fields are valid
 *)
  DDVPD_FILTERQUALITY     = $00000100;

type
(*
 * TDDVideoPortDesc
 *)
  PDDVideoPortDesc = ^TDDVideoPortDesc;
  TDDVideoPortDesc = packed record
    dwSize: DWORD;                       // size of the TDDVideoPortDesc structure
    dwFieldWidth: DWORD;                 // width of the video port field
    dwVBIWidth: DWORD;                   // width of the VBI data
    dwFieldHeight: DWORD;                // height of the video port field
    dwMicrosecondsPerField: DWORD;       // Microseconds per video field
    dwMaxPixelsPerSecond: DWORD;         // Maximum pixel rate per second
    dwVideoPortID: DWORD;                // Video port ID (0 - (dwMaxVideoPorts -1))
    dwReserved1: DWORD;                  // Reserved for future use - set to zero
    VideoPortType: TDDVideoPortConnect;  // Description of video port connection
    dwReserved2: DWORD;                  // Reserved for future use - set to zero
    dwReserved3: DWORD;                  // Reserved for future use - set to zero
  end;

(*
 * TDDVideoPortInfo
 *)
  PDDVideoPortInfo = ^TDDVideoPortInfo;
  TDDVideoPortInfo = packed record
    dwSize: DWORD;                            // Size of the structure
    dwOriginX: DWORD;                         // Placement of the video data within the surface.
    dwOriginY: DWORD;                         // Placement of the video data within the surface.
    dwVPFlags: DWORD;                         // Video port options
    rCrop: TRect;                             // Cropping rectangle (optional).
    dwPrescaleWidth: DWORD;                   // Determines pre-scaling/zooming in the X direction (optional).
    dwPrescaleHeight: DWORD;                  // Determines pre-scaling/zooming in the Y direction (optional).
    lpddpfInputFormat: PDDPixelFormat;       // Video format written to the video port
    lpddpfVBIInputFormat: PDDPixelFormat;    // Input format of the VBI data
    lpddpfVBIOutputFormat: PDDPixelFormat;   // Output format of the data
    dwVBIHeight: DWORD;                       // Specifies the number of lines of data within the vertical blanking interval.
    dwReserved1: DWORD;                       // Reserved for future use - set to zero
    dwReserved2: DWORD;                       // Reserved for future use - set to zero
  end;

(*
 * TDDVideoPortBandWidth
 *)
  PDDVideoPortBandWidth = ^TDDVideoPortBandWidth;
  TDDVideoPortBandWidth = packed record
    dwSize: DWORD;                 // Size of the structure
    dwCaps: DWORD;
    dwOverlay: DWORD;              // Zoom factor at which overlay is supported
    dwColorkey: DWORD;             // Zoom factor at which overlay w/ colorkey is supported
    dwYInterpolate: DWORD;         // Zoom factor at which overlay w/ Y interpolation is supported
    dwYInterpAndColorkey: DWORD;   // Zoom factor at which ovelray w/ Y interpolation and colorkeying is supported
    dwReserved1: DWORD;            // Reserved for future use - set to zero
    dwReserved2: DWORD;            // Reserved for future use - set to zero
  end;

(*
 * TDDVideoPortStatus
 *)
  PDDVideoPortStatus = ^TDDVideoPortStatus;
  TDDVideoPortStatus = record
    dwSize: DWORD;                       // Size of the structure
    bInUse: BOOL;                        // TRUE if video port is currently being used
    dwFlags: DWORD;                      // Currently not used
    dwReserved1: DWORD;                  // Reserved for future use
    VideoPortType: TDDVideoPortConnect;  // Information about the connection
    dwReserved2: DWORD;                  // Reserved for future use
    dwReserved3: DWORD;                  // Reserved for future use
  end;

const
(*============================================================================
 *
 * Video Port Flags
 *
 * All flags are bit flags.
 *
 *==========================================================================*)

(****************************************************************************
 *
 * VIDEOPORT TDDVideoPortConnect FLAGS
 *
 ****************************************************************************)

(*
 * When this is set by the driver and passed to the client, this
 * indicates that the video port is capable of double clocking the data.
 * When this is set by the client, this indicates that the video port
 * should enable double clocking.  This flag is only valid with external
 * syncs.
 *)
  DDVPCONNECT_DOUBLECLOCK = $00000001;

(*
 * When this is set by the driver and passed to the client, this
 * indicates that the video port is capable of using an external VACT
 * signal. When this is set by the client, this indicates that the
 * video port should use the external VACT signal.
 *)
  DDVPCONNECT_VACT = $00000002;

(*
 * When this is set by the driver and passed to the client, this
 * indicates that the video port is capable of treating even fields
 * like odd fields and visa versa.  When this is set by the client,
 * this indicates that the video port should treat even fields like odd
 * fields.
 *)
  DDVPCONNECT_INVERTPOLARITY = $00000004;

(*
 * Indicates that any data written to the video port during the VREF
 * period will not be written into the frame buffer. This flag is read only.
 *)
  DDVPCONNECT_DISCARDSVREFDATA = $00000008;

(*
 * When this is set be the driver and passed to the client, this
 * indicates that the device will write half lines into the frame buffer
 * if half lines are provided by the decoder.  If this is set by the client,
 * this indicates that the decoder will be supplying half lines.
 *)
  DDVPCONNECT_HALFLINE = $00000010;

(*
 * Indicates that the signal is interlaced. This flag is only
 * set by the client.
 *)
  DDVPCONNECT_INTERLACED = $00000020;

(*
 * Indicates that video port is shareable and that this video port
 * will use the even fields.  This flag is only set by the client.
 *)
  DDVPCONNECT_SHAREEVEN = $00000040;

(*
 * Indicates that video port is shareable and that this video port
 * will use the odd fields.  This flag is only set by the client.
 *)
  DDVPCONNECT_SHAREODD = $00000080;

(****************************************************************************
 *
 * VIDEOPORT TDDVideoPortDesc CAPS
 *
 ****************************************************************************)

(*
 * Flip can be performed automatically to avoid tearing.
 *)
  DDVPCAPS_AUTOFLIP = $00000001;

(*
 * Supports interlaced video
 *)
  DDVPCAPS_INTERLACED = $00000002;

(*
 * Supports non-interlaced video
 *)
  DDVPCAPS_NONINTERLACED = $00000004;

(*
 * Indicates that the device can return whether the current field
 * of an interlaced signal is even or odd.
 *)
  DDVPCAPS_READBACKFIELD = $00000008;

(*
 * Indicates that the device can return the current line of video
 * being written into the frame buffer.
 *)
  DDVPCAPS_READBACKLINE = $00000010;

(*
 * Allows two gen-locked video streams to share a single video port,
 * where one stream uses the even fields and the other uses the odd
 * fields. Separate parameters (including address, scaling,
 * cropping, etc.) are maintained for both fields.)
 *)
  DDVPCAPS_SHAREABLE = $00000020;

(*
 * Even fields of video can be automatically discarded.
 *)
  DDVPCAPS_SKIPEVENFIELDS = $00000040;

(*
 * Odd fields of video can be automatically discarded.
 *)
  DDVPCAPS_SKIPODDFIELDS = $00000080;

(*
 * Indicates that the device is capable of driving the graphics
 * VSYNC with the video port VSYNC.
 *)
  DDVPCAPS_SYNCMASTER = $00000100;

(*
 * Indicates that data within the vertical blanking interval can
 * be written to a different surface.
 *)
  DDVPCAPS_VBISURFACE = $00000200;

(*
 * Indicates that the video port can perform color operations
 * on the incoming data before it is written to the frame buffer.
 *)
  DDVPCAPS_COLORCONTROL = $00000400;

(*
 * Indicates that the video port can accept VBI data in a different
 * width or format than the regular video data.
 *)
  DDVPCAPS_OVERSAMPLEDVBI = $00000800;

(*
 * Indicates that the video port can write data directly to system memory
 *)
  DDVPCAPS_SYSTEMMEMORY = $00001000;

(*
 * Indicates that the VBI and video portions of the video stream can
 * be controlled by an independent processes.
 *)
  DDVPCAPS_VBIANDVIDEOINDEPENDENT	= $00002000;

(*
 * Indicates that the video port contains high quality hardware
 * de-interlacing hardware that should be used instead of the
 * bob/weave algorithms.
 *)
  DDVPCAPS_HARDWAREDEINTERLACE		= $00004000;

(****************************************************************************
 *
 * VIDEOPORT TDDVideoPortDesc FX
 *
 ****************************************************************************)

(*
 * Limited cropping is available to crop out the vertical interval data.
 *)
  DDVPFX_CROPTOPDATA = $00000001;

(*
 * Incoming data can be cropped in the X direction before it is written
 * to the surface.
 *)
  DDVPFX_CROPX = $00000002;

(*
 * Incoming data can be cropped in the Y direction before it is written
 * to the surface.
 *)
  DDVPFX_CROPY = $00000004;

(*
 * Supports interleaving interlaced fields in memory.
 *)
  DDVPFX_INTERLEAVE = $00000008;

(*
 * Supports mirroring left to right as the video data is written
 * into the frame buffer.
 *)
  DDVPFX_MIRRORLEFTRIGHT = $00000010;

(*
 * Supports mirroring top to bottom as the video data is written
 * into the frame buffer.
 *)
  DDVPFX_MIRRORUPDOWN = $00000020;

(*
 * Data can be arbitrarily shrunk in the X direction before it
 * is written to the surface.
 *)
  DDVPFX_PRESHRINKX = $00000040;

(*
 * Data can be arbitrarily shrunk in the Y direction before it
 * is written to the surface.
 *)
  DDVPFX_PRESHRINKY = $00000080;

(*
 * Data can be binary shrunk (1/2, 1/4, 1/8, etc.) in the X
 * direction before it is written to the surface.
 *)
  DDVPFX_PRESHRINKXB = $00000100;

(*
 * Data can be binary shrunk (1/2, 1/4, 1/8, etc.) in the Y
 * direction before it is written to the surface.
 *)
  DDVPFX_PRESHRINKYB = $00000200;

(*
 * Data can be shrunk in increments of 1/x in the X direction
 * (where X is specified in the TDDVideoPortCaps.dwPreshrinkXStep)
 * before it is written to the surface.
 *)
  DDVPFX_PRESHRINKXS = $00000400;

(*
 * Data can be shrunk in increments of 1/x in the Y direction
 * (where X is specified in the TDDVideoPortCaps.dwPreshrinkYStep)
 * before it is written to the surface.
 *)
  DDVPFX_PRESHRINKYS = $00000800;

(*
 * Data can be arbitrarily stretched in the X direction before
 * it is written to the surface.
 *)
  DDVPFX_PRESTRETCHX = $00001000;

(*
 * Data can be arbitrarily stretched in the Y direction before
 * it is written to the surface.
 *)
  DDVPFX_PRESTRETCHY = $00002000;

(*
 * Data can be integer stretched in the X direction before it is
 * written to the surface.
 *)
  DDVPFX_PRESTRETCHXN = $00004000;

(*
 * Data can be integer stretched in the Y direction before it is
 * written to the surface.
 *)
  DDVPFX_PRESTRETCHYN = $00008000;

(*
 * Indicates that data within the vertical blanking interval can
 * be converted independently of the remaining video data.
 *)
  DDVPFX_VBICONVERT = $00010000;

(*
 * Indicates that scaling can be disabled for data within the
 * vertical blanking interval.
 *)
  DDVPFX_VBINOSCALE = $00020000;

(*
 * Indicates that the video data can ignore the left and right
 * cropping coordinates when cropping oversampled VBI data.
 *)
  DDVPFX_IGNOREVBIXCROP = $00040000;

(*
 * Indicates that interleaving can be disabled for data within the
 * vertical blanking interval.
 *)
  DDVPFX_VBINOINTERLEAVE     = $00080000;

(****************************************************************************
 *
 * VIDEOPORT TDDVideoPortInfo FLAGS
 *
 ****************************************************************************)

(*
 * Perform automatic flipping.   Auto-flipping is performed between
 * the overlay surface that was attached to the video port using
 * IDirectDrawVideoPort::AttachSurface and the overlay surfaces that
 * are attached to the surface via the IDirectDrawSurface::AttachSurface
 * method.  The flip order is the order in which the overlay surfaces
 * were. attached.
 *)
  DDVP_AUTOFLIP = $00000001;

(*
 * Perform conversion using the ddpfOutputFormat information.
 *)
  DDVP_CONVERT = $00000002;

(*
 * Perform cropping using the specified rectangle.
 *)
  DDVP_CROP = $00000004;

(*
 * Indicates that interlaced fields should be interleaved in memory.
 *)
  DDVP_INTERLEAVE = $00000008;

(*
 * Indicates that the data should be mirrored left to right as it's
 * written into the frame buffer.
 *)
  DDVP_MIRRORLEFTRIGHT = $00000010;

(*
 * Indicates that the data should be mirrored top to bottom as it's
 * written into the frame buffer.
 *)
  DDVP_MIRRORUPDOWN = $00000020;

(*
 * Perform pre-scaling/zooming based on the pre-scale parameters.
 *)
  DDVP_PRESCALE = $00000040;

(*
 * Ignore input of even fields.
 *)
  DDVP_SKIPEVENFIELDS = $00000080;

(*
 * Ignore input of odd fields.
 *)
  DDVP_SKIPODDFIELDS = $00000100;

(*
 * Drive the graphics VSYNCs using the video port VYSNCs.
 *)
  DDVP_SYNCMASTER = $00000200;

(*
 * The ddpfVBIOutputFormatFormat member contains data that should be used
 * to convert the data within the vertical blanking interval.
 *)
  DDVP_VBICONVERT = $00000400;

(*
 * Indicates that data within the vertical blanking interval
 * should not be scaled.
 *)
  DDVP_VBINOSCALE = $00000800;

(*
 * Indicates that these bob/weave decisions should not be
 * overriden by other interfaces.
 *)
  DDVP_OVERRIDEBOBWEAVE = $00001000;

(*
 * Indicates that the video data should ignore the left and right
 * cropping coordinates when cropping the VBI data.
 *)
  DDVP_IGNOREVBIXCROP = $00002000;

(*
 * Indicates that interleaving can be disabled for data within the
 * vertical blanking interval.
 *)
  DDVP_VBINOINTERLEAVE			= $00004000;

(*
 * Indicates that the video port should use the hardware
 * de-interlacing hardware.
 *)
  DDVP_HARDWAREDEINTERLACE		= $00008000;

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT GETINPUTFORMAT/GETOUTPUTFORMAT FLAGS
 *
 ****************************************************************************)

(*
 * Return formats for the video data
 *)
  DDVPFORMAT_VIDEO = $00000001;

(*
 * Return formats for the VBI data
 *)
  DDVPFORMAT_VBI = $00000002;

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT SETTARGETSURFACE FLAGS
 *
 ****************************************************************************)

(*
 * Surface should receive video data (and VBI data if a surface
 * is not explicitly attached for that purpose)
 *)
  DDVPTARGET_VIDEO = $00000001;

(*
 * Surface should receive VBI data
 *)
  DDVPTARGET_VBI = $00000002;

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT WAITFORSYNC FLAGS
 *
 ****************************************************************************)

(*
 * Waits until the beginning of the next VSYNC
 *)
  DDVPWAIT_BEGIN = $00000001;

(*
 * Waits until the end of the next/current VSYNC
 *)
  DDVPWAIT_END = $00000002;

(*
 * Waits until the beginning of the specified line
 *)
  DDVPWAIT_LINE = $00000003;

(****************************************************************************
 *
 * DIRECTDRAWVIDEOPORT FLIP FLAGS
 *
 ****************************************************************************)

(*
 * Flips the normal video surface
 *)
  DDVPFLIP_VIDEO = $00000001;

(*
 * Flips the VBI surface
 *)
  DDVPFLIP_VBI = $00000002;

(****************************************************************************
 *
 * DIRIRECTDRAWVIDEOPORT GETVIDEOSIGNALSTATUS VALUES
 *
 ****************************************************************************)

(*
 * No video signal is present at the video port
 *)
  DDVPSQ_NOSIGNAL = $00000001;

(*
 * A valid video signal is present at the video port
 *)
  DDVPSQ_SIGNALOK = $00000002;

(****************************************************************************
 *
 * VIDEOPORTBANDWIDTH Flags
 *
 ****************************************************************************)

(*
 * The specified height/width refer to the size of the video port data
 * written into memory, after prescaling has occured.
 *)
  DDVPB_VIDEOPORT = $00000001;

(*
 * The specified height/width refer to the source size of the overlay.
 *)
  DDVPB_OVERLAY = $00000002;

(*
 * This is a query for the device to return which caps this device requires.
 *)
  DDVPB_TYPE = $00000004;

(****************************************************************************
 *
 * VIDEOPORTBANDWIDTH Caps
 *
 ****************************************************************************)

(*
 * The bandwidth for this device is dependant on the overlay source size.
 *)
  DDVPBCAPS_SOURCE = $00000001;

(*
 * The bandwidth for this device is dependant on the overlay destination
 * size.
 *)
  DDVPBCAPS_DESTINATION = $00000002;

(****************************************************************************
 *
 * DDVIDEOPORTCONTAINER CreateVideoPort flags
 *
 ****************************************************************************)

(*
 * The process only wants to control the VBI portion of the video stream.
 *)
  DDVPCREATE_VBIONLY			= $00000001;

(*
 * The process only wants to control the non-VBI (video) portion of
 * the video stream.
 *)
  DDVPCREATE_VIDEOONLY			= $00000002;

(****************************************************************************
 *
 * DDVIDEOPORTSTATUS flags
 *
 ****************************************************************************)

(*
 * The video port interface is only controlling the VBI portion of the
 * video stream
 *)
  DDVPSTATUS_VBIONLY			= $00000001;

(*
 * The video port interface is only controlling the video portion of the
 * video stream
 *)
  DDVPSTATUS_VIDEOONLY			= $00000002;


type
(*
 * API's
 *)

  TDDEnumVideoCallback = function (lpTDDVideoPortCaps: TDDVideoPortCaps;
      lpContext: Pointer) : HResult; StdCall;

(*
 * INTERACES FOLLOW:
 *	IDirectDrawVideoPort
 *	IVideoPort
 *)


(*
 * IDirectDrawVideoPort
 *)
  IDirectDrawVideoPort = interface (IUnknown)
    ['{B36D93E0-2B43-11CF-A2DE-00AA00B93356}']
    (*** IDirectDrawVideoPort methods ***)
    function Flip(lpDDSurface: IDirectDrawSurface; dwFlags: DWORD) : HResult; StdCall;
    function GetBandwidthInfo(var lpddpfFormat: TDDPixelFormat; dwWidth: DWORD; dwHeight: DWORD; dwFlags: DWORD; var lpBandwidth: TDDVideoPortBandWidth) : HResult; StdCall;
    function GetColorControls(var lpColorControl: TDDColorControl) : HResult; StdCall;
    function GetInputFormats(var lpNumFormats: DWORD; var lpFormats: TDDPixelFormat; dwFlags: DWORD) : HResult; StdCall;
    function GetOutputFormats(var lpInputFormat: TDDPixelFormat; var lpNumFormats: DWORD; var lpFormats: TDDPixelFormat; dwFlags: DWORD) : HResult; StdCall;
    function GetFieldPolarity(var lpbVideoField: BOOL) : HResult; StdCall;
    function GetVideoLine(var lpdwLine: DWORD) : HResult; StdCall;
    function GetVideoSignalStatus(varlpdwStatus: DWORD) : HResult; StdCall;
    function SetColorControls(var lpColorControl: TDDColorControl) : HResult; StdCall;
    function SetTargetSurface(lpDDSurface: IDirectDrawSurface; dwFlags: DWORD) : HResult; StdCall;
    function StartVideo(var lpVideoInfo: TDDVideoPortInfo) : HResult; StdCall;
    function StopVideo: HResult;
    function UpdateVideo(var lpVideoInfo: TDDVideoPortInfo) : HResult; StdCall;
    function WaitForSync(dwFlags: DWORD; dwLine: DWORD; dwTimeout: DWORD) : HResult; StdCall;
  end;

(*
 * IDirectDrawVideoPortContainer
 *)
  IDDVideoPortContainer = interface (IUnknown)
    ['{6C142760-A733-11CE-A521-0020AF0BE560}']
    (*** IDDVideoPortContainer methods ***)
    function CreateVideoPort(dwFlags: DWORD; var lpTDDVideoPortDesc: TDDVideoPortDesc; var lplpDDVideoPort: IDirectDrawVideoPort; pUnkOuter: IUnknown) : HResult; StdCall;
    function EnumVideoPorts(dwFlags: DWORD; var lpTDDVideoPortCaps: TDDVideoPortCaps; lpContext: Pointer; lpEnumVideoCallback: TDDEnumVideoCallback) : HResult; StdCall;
    function GetVideoPortConnectInfo(dwPortId: DWORD; var lpNumEntries: DWORD; var lpConnectInfo: TDDVideoPortConnect) : HResult; StdCall;
    function QueryVideoPortStatus(dwPortId: DWORD; var lpVPStatus: TDDVideoPortStatus) : HResult; StdCall;
  end;

(******************************************************************************)
(**                                                                          **)
(** DXFile.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

type
  TDXFileFormat = (
    DXFILEFORMAT_BINARY,
    DXFILEFORMAT_TEXT,
    DXFILEFORMAT_COMPRESSED
  );

  TDXFileLoadOptions = (
    DXFILELOAD_FROMFILE,
    DXFILELOAD_FROMRESOURCE,
    DXFILELOAD_FROMMEMORY,
    DXFILELOAD_INVALID_3,
    DXFILELOAD_FROMSTREAM,
    DXFILELOAD_INVALID_5,
    DXFILELOAD_INVALID_6,
    DXFILELOAD_INVALID_7,
    DXFILELOAD_FROMURL
  );

  PDXFileLoadResource = ^TDXFileLoadResource;
  TDXFileLoadResource = packed record
    hModule: HModule;
    lpName: PAnsiChar;
    lpType: PAnsiChar;
  end;

  PDXFileLoadMemory = ^TDXFileLoadMemory;
  TDXFileLoadMemory = packed record
    lpMemory: Pointer;
    dSize: DWORD;
  end;

(*
 * DirectX File object types.
 *)

  IDirectXFile = interface;
  IDirectXFileEnumObject = interface;
  IDirectXFileSaveObject = interface;
  IDirectXFileObject = interface;
  IDirectXFileData = interface;
  IDirectXFileDataReference = interface;
  IDirectXFileBinary = interface;

(*
 * DirectX File interfaces.
 *)

  IDirectXFile = interface (IUnknown)
    ['{3d82ab40-62da-11cf-ab39-0020af71e433}']
    function CreateEnumObject (pvSource: Pointer; dwLoadOptions: TDXFileLoadOptions; var ppEnumObj: IDirectXFileEnumObject) : HResult; StdCall;
    function CreateSaveObject (szFileName: PChar; dwFileFormat: TDXFileFormat; var ppSaveObj: IDirectXFileSaveObject) : HResult; StdCall;
    function RegisterTemplates (pvData: Pointer; cbSize: DWORD) : HResult; StdCall;
  end;

  IDirectXFileEnumObject = interface (IUnknown)
    ['{3d82ab41-62da-11cf-ab39-0020af71e433}']
    function GetNextDataObject (var ppDataObj: IDirectXFileData) : HResult; StdCall;
    function GetDataObjectById(const rguid: TGUID; var ppDataObj: IDirectXFileData) : HResult; StdCall;
    function GetDataObjectByName(szName: PChar; var ppDataObj: IDirectXFileData) : HResult; StdCall;
  end;

  IDirectXFileSaveObject = interface (IUnknown)
    ['{3d82ab42-62da-11cf-ab39-0020af71e433}']
    function SaveTemplates(cTemplates: DWORD; var ppguidTemplates: PGUID) : HResult; StdCall;
    function CreateDataObject (const rguidTemplate: TGUID; szName: PChar; pguid: PGUID; cbSize: DWORD; pvData: Pointer; var ppDataObj: IDirectXFileData) : HResult; StdCall;
    function SaveData (pDataObj: IDirectXFileData) : HResult; StdCall;
  end;

  IDirectXFileObject = interface (IUnknown)
    ['{3d82ab43-62da-11cf-ab39-0020af71e433}']
    function GetName (pstrNameBuf: PChar; var dwBufLen: DWORD) : HResult; StdCall;
    function GetId (var pGuidBuf: TGUID) : HResult; StdCall;
  end;

  IDirectXFileData = interface (IDirectXFileObject)
    ['{3d82ab44-62da-11cf-ab39-0020af71e433}']
    function GetData(szMember: PChar; var pcbSize: DWORD; var ppvData: Pointer) : HResult; StdCall;
    function GetType (var ppguid: PGUID) : HResult; StdCall;
    function GetNextObject (var ppChildObj: IDirectXFileObject) : HResult; StdCall;
    function AddDataObject (pDataObj: IDirectXFileData) : HResult; StdCall;
    function AddDataReference (szRef: PChar; pguidRef: PGUID) : HResult; StdCall;
    function AddBinaryObject (szName: PChar; pguid: PGUID; szMimeType: PChar; pvData: Pointer; cbSize: DWORD) : HResult; StdCall;
  end;

  IDirectXFileDataReference = interface (IDirectXFileObject)
    ['{3d82ab45-62da-11cf-ab39-0020af71e433}']
    function Resolve (var ppDataObj: IDirectXFileData) : HResult; StdCall;
  end;

  IDirectXFileBinary = interface (IDirectXFileObject)
    ['{3d82ab46-62da-11cf-ab39-0020af71e433}']
    function GetSize (var pcbSize: DWORD) : HResult; StdCall;
    function GetMimeType (var pszMimeType: PChar) : HResult; StdCall;
    function Read(pvData: Pointer; cbSize: DWORD; pcbRead: PDWORD{?}) : HResult; StdCall;
  end;

const

(*
 * DirectXFile Object Class Id (for CoCreateInstance())
 *)

   CLSID_CDirectXFile: TGUID = (D1:$4516ec43;D2:$8f20;D3:$11d0;D4:($9b,$6d,$00,$00,$c0,$78,$1b,$c3));

(*
 * DirectX File Interface GUIDs.
 *)

  IID_IDirectXFile: TGUID =      (D1:$3d82ab40;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
  IID_IDirectXFileEnumObject: TGUID =      (D1:$3d82ab41;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
  IID_IDirectXFileSaveObject: TGUID =      (D1:$3d82ab42;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
  IID_IDirectXFileObject: TGUID =      (D1:$3d82ab43;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
  IID_IDirectXFileData: TGUID =       (D1:$3d82ab44;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
  IID_IDirectXFileDataReference: TGUID =      (D1:$3d82ab45;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
  IID_IDirectXFileBinary: TGUID =      (D1:$3d82ab46;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));

(*
 * DirectX File Header template's GUID.
 *)

  TID_DXFILEHeader: TGUID =
      (D1:$3d82ab43;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));

(*
 * DirectX File errors.
 *)

const
  DXFILE_OK = 0;

  DXFILEERR_BADOBJECT                 = MAKE_DDHRESULT or 850;
  DXFILEERR_BADVALUE                  = MAKE_DDHRESULT or 851;
  DXFILEERR_BADTYPE                   = MAKE_DDHRESULT or 852;
  DXFILEERR_BADSTREAMHANDLE           = MAKE_DDHRESULT or 853;
  DXFILEERR_BADALLOC                  = MAKE_DDHRESULT or 854;
  DXFILEERR_NOTFOUND                  = MAKE_DDHRESULT or 855;
  DXFILEERR_NOTDONEYET                = MAKE_DDHRESULT or 856;
  DXFILEERR_FILENOTFOUND              = MAKE_DDHRESULT or 857;
  DXFILEERR_RESOURCENOTFOUND          = MAKE_DDHRESULT or 858;
  DXFILEERR_URLNOTFOUND               = MAKE_DDHRESULT or 859;
  DXFILEERR_BADRESOURCE               = MAKE_DDHRESULT or 860;
  DXFILEERR_BADFILETYPE               = MAKE_DDHRESULT or 861;
  DXFILEERR_BADFILEVERSION            = MAKE_DDHRESULT or 862;
  DXFILEERR_BADFILEFLOATSIZE          = MAKE_DDHRESULT or 863;
  DXFILEERR_BADFILECOMPRESSIONTYPE    = MAKE_DDHRESULT or 864;
  DXFILEERR_BADFILE                   = MAKE_DDHRESULT or 865;
  DXFILEERR_PARSEERROR                = MAKE_DDHRESULT or 866;
  DXFILEERR_NOTEMPLATE                = MAKE_DDHRESULT or 867;
  DXFILEERR_BADARRAYSIZE              = MAKE_DDHRESULT or 868;
  DXFILEERR_BADDATAREFERENCE          = MAKE_DDHRESULT or 869;
  DXFILEERR_INTERNALERROR             = MAKE_DDHRESULT or 870;
  DXFILEERR_NOMOREOBJECTS             = MAKE_DDHRESULT or 871;
  DXFILEERR_BADINTRINSICS             = MAKE_DDHRESULT or 872;
  DXFILEERR_NOMORESTREAMHANDLES       = MAKE_DDHRESULT or 873;
  DXFILEERR_NOMOREDATA                = MAKE_DDHRESULT or 874;
  DXFILEERR_BADCACHEFILE              = MAKE_DDHRESULT or 875;
  DXFILEERR_NOINTERNET                = MAKE_DDHRESULT or 876;


(*
 * API for creating IDirectXFile interface.
 *)

var
  DirectXFileCreate : function
    (Out lplpDirectXFile: IDirectXFile) : HResult; StdCall;

(******************************************************************************)
(**                                                                          **)
(** RMXFGUID.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

const
(* {2B957100-9E9A-11cf-AB39-0020AF71E433} *)  TID_D3DRMInfo                  : TGUID = (D1:$2b957100;D2:$9e9a;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3D82AB44-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMMesh                  : TGUID = (D1:$3d82ab44;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3D82AB5E-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMVector                : TGUID = (D1:$3d82ab5e;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3D82AB5F-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMMeshFace              : TGUID = (D1:$3d82ab5f;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3D82AB4D-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMMaterial              : TGUID = (D1:$3d82ab4d;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {35FF44E1-6C7C-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialArray         : TGUID = (D1:$35ff44e1;D2:$6c7c;D3:$11cf;D4:($8F,$52,$00,$40,$33,$35,$94,$a3));
(* {3D82AB46-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMFrame                 : TGUID = (D1:$3d82ab46;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {F6F23F41-7686-11cf-8F52-0040333594A3} *)  TID_D3DRMFrameTransformMatrix  : TGUID = (D1:$f6f23f41;D2:$7686;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {F6F23F42-7686-11cf-8F52-0040333594A3} *)  TID_D3DRMMeshMaterialList      : TGUID = (D1:$f6f23f42;D2:$7686;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {F6F23F40-7686-11cf-8F52-0040333594A3} *)  TID_D3DRMMeshTextureCoords     : TGUID = (D1:$f6f23f40;D2:$7686;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {F6F23F43-7686-11cf-8F52-0040333594A3} *)  TID_D3DRMMeshNormals           : TGUID = (D1:$f6f23f43;D2:$7686;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {F6F23F44-7686-11cf-8F52-0040333594A3} *)  TID_D3DRMCoords2d              : TGUID = (D1:$f6f23f44;D2:$7686;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {F6F23F45-7686-11cf-8F52-0040333594A3} *)  TID_D3DRMMatrix4x4             : TGUID = (D1:$f6f23f45;D2:$7686;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {3D82AB4F-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMAnimation             : TGUID = (D1:$3d82ab4f;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3D82AB50-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMAnimationSet          : TGUID = (D1:$3d82ab50;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {10DD46A8-775B-11cf-8F52-0040333594A3} *)  TID_D3DRMAnimationKey          : TGUID = (D1:$10dd46a8;D2:$775b;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {10DD46A9-775B-11cf-8F52-0040333594A3} *)  TID_D3DRMFloatKeys             : TGUID = (D1:$10dd46a9;D2:$775b;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {01411840-7786-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialAmbientColor  : TGUID = (D1:$01411840;D2:$7786;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {01411841-7786-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialDiffuseColor  : TGUID = (D1:$01411841;D2:$7786;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {01411842-7786-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialSpecularColor : TGUID = (D1:$01411842;D2:$7786;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {D3E16E80-7835-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialEmissiveColor : TGUID = (D1:$d3e16e80;D2:$7835;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {01411843-7786-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialPower         : TGUID = (D1:$01411843;D2:$7786;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {35FF44E0-6C7C-11cf-8F52-0040333594A3} *)  TID_D3DRMColorRGBA             : TGUID = (D1:$35ff44e0;D2:$6c7c;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$A3));
(* {D3E16E81-7835-11cf-8F52-0040333594A3} *)  TID_D3DRMColorRGB              : TGUID = (D1:$d3e16e81;D2:$7835;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {A42790E0-7810-11cf-8F52-0040333594A3} *)  TID_D3DRMGuid                  : TGUID = (D1:$a42790e0;D2:$7810;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {A42790E1-7810-11cf-8F52-0040333594A3} *)  TID_D3DRMTextureFilename       : TGUID = (D1:$a42790e1;D2:$7810;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {A42790E2-7810-11cf-8F52-0040333594A3} *)  TID_D3DRMTextureReference      : TGUID = (D1:$a42790e2;D2:$7810;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {1630B820-7842-11cf-8F52-0040333594A3} *)  TID_D3DRMIndexedColor          : TGUID = (D1:$1630b820;D2:$7842;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {1630B821-7842-11cf-8F52-0040333594A3} *)  TID_D3DRMMeshVertexColors      : TGUID = (D1:$1630b821;D2:$7842;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {4885AE60-78E8-11cf-8F52-0040333594A3} *)  TID_D3DRMMaterialWrap          : TGUID = (D1:$4885ae60;D2:$78e8;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {537DA6A0-CA37-11d0-941C-0080C80CFA7B} *)  TID_D3DRMBoolean               : TGUID = (D1:$537da6a0;D2:$ca37;D3:$11d0;D4:($94,$1c,$00,$80,$c8,$0c,$fa,$7b));
(* {ED1EC5C0-C0A8-11d0-941C-0080C80CFA7B} *)  TID_D3DRMMeshFaceWraps         : TGUID = (D1:$ed1ec5c0;D2:$c0a8;D3:$11d0;D4:($94,$1c,$00,$80,$c8,$0c,$fa,$7b));
(* {4885AE63-78E8-11cf-8F52-0040333594A3} *)  TID_D3DRMBoolean2d             : TGUID = (D1:$4885ae63;D2:$78e8;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {F406B180-7B3B-11cf-8F52-0040333594A3} *)  TID_D3DRMTimedFloatKeys        : TGUID = (D1:$f406b180;D2:$7b3b;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {E2BF56C0-840F-11cf-8F52-0040333594A3} *)  TID_D3DRMAnimationOptions      : TGUID = (D1:$e2bf56c0;D2:$840f;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {E2BF56C1-840F-11cf-8F52-0040333594A3} *)  TID_D3DRMFramePosition         : TGUID = (D1:$e2bf56c1;D2:$840f;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {E2BF56C2-840F-11cf-8F52-0040333594A3} *)  TID_D3DRMFrameVelocity         : TGUID = (D1:$e2bf56c2;D2:$840f;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {E2BF56C3-840F-11cf-8F52-0040333594A3} *)  TID_D3DRMFrameRotation         : TGUID = (D1:$e2bf56c3;D2:$840f;D3:$11cf;D4:($8f,$52,$00,$40,$33,$35,$94,$a3));
(* {3D82AB4A-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMLight                 : TGUID = (D1:$3d82ab4a;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3D82AB51-62DA-11cf-AB39-0020AF71E433} *)  TID_D3DRMCamera                : TGUID = (D1:$3d82ab51;D2:$62da;D3:$11cf;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {E5745280-B24F-11cf-9DD5-00AA00A71A2F} *)  TID_D3DRMAppData               : TGUID = (D1:$e5745280;D2:$b24f;D3:$11cf;D4:($9d,$d5,$00,$aa,$00,$a7,$1a,$2f));
(* {AED22740-B31F-11cf-9DD5-00AA00A71A2F} *)  TID_D3DRMLightUmbra            : TGUID = (D1:$aed22740;D2:$b31f;D3:$11cf;D4:($9d,$d5,$00,$aa,$00,$a7,$1a,$2f));
(* {AED22742-B31F-11cf-9DD5-00AA00A71A2F} *)  TID_D3DRMLightRange            : TGUID = (D1:$aed22742;D2:$b31f;D3:$11cf;D4:($9d,$d5,$00,$aa,$00,$a7,$1a,$2f));
(* {AED22741-B31F-11cf-9DD5-00AA00A71A2F} *)  TID_D3DRMLightPenumbra         : TGUID = (D1:$aed22741;D2:$b31f;D3:$11cf;D4:($9d,$d5,$00,$aa,$00,$a7,$1a,$2f));
(* {A8A98BA0-C5E5-11cf-B941-0080C80CFA7B} *)  TID_D3DRMLightAttenuation      : TGUID = (D1:$a8a98ba0;D2:$c5e5;D3:$11cf;D4:($b9,$41,$00,$80,$c8,$0c,$fa,$7b));
(* {3A23EEA0-94B1-11d0-AB39-0020AF71E433} *)  TID_D3DRMInlineData            : TGUID = (D1:$3a23eea0;D2:$94b1;D3:$11d0;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {3A23EEA1-94B1-11d0-AB39-0020AF71E433} *)  TID_D3DRMUrl                   : TGUID = (D1:$3a23eea1;D2:$94b1;D3:$11d0;D4:($ab,$39,$00,$20,$af,$71,$e4,$33));
(* {8A63C360-997D-11d0-941C-0080C80CFA7B} *)  TID_D3DRMProgressiveMesh       : TGUID = (D1:$8A63C360;D2:$997D;D3:$11d0;D4:($94,$1C,$00,$80,$C8,$0C,$FA,$7B));
(* {98116AA0-BDBA-11d1-82C0-00A0C9697271} *)  TID_D3DRMExternalVisual        : TGUID = (D1:$98116AA0;D2:$BDBA;D3:$11d1;D4:($82,$C0,$00,$A0,$C9,$69,$72,$71));
(* {7F0F21E0-BFE1-11d1-82C0-00A0C9697271} *)  TID_D3DRMStringProperty        : TGUID = (D1:$7f0f21e0;D2:$bfe1;D3:$11d1;D4:($82,$c0,$00,$a0,$c9,$69,$72,$71));
(* {7F0F21E1-BFE1-11d1-82C0-00A0C9697271} *)  TID_D3DRMPropertyBag           : TGUID = (D1:$7f0f21e1;D2:$bfe1;D3:$11d1;D4:($82,$c0,$00,$a0,$c9,$69,$72,$71));
(* {7F5D5EA0-D53A-11d1-82C0-00A0C9697271} *)  TID_D3DRMRightHanded           : TGUID = (D1:$7f5d5ea0;D2:$d53a;D3:$11d1;D4:($82,$c0,$00,$a0,$c9,$69,$72,$71));

(******************************************************************************)
(**                                                                          **)
(** RMXFTmpl.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(* D3DRM XFile templates in binary form *)
const
  D3DRM_XTEMPLATE_BYTES  = 3278;

  D3DRM_XTEMPLATES: array [0..D3DRM_XTEMPLATE_BYTES-1] of byte = (
        $78, $6f, $66, $20, $30, $33, $30, $32, $62, 
        $69, $6e, $20, $30, $30, $36, $34, $1f, 0, $1, 
        0, $6, 0, 0, 0, $48, $65, $61, $64, $65, 
        $72, $a, 0, $5, 0, $43, $ab, $82, $3d, $da, 
        $62, $cf, $11, $ab, $39, 0, $20, $af, $71, $e4, 
        $33, $28, 0, $1, 0, $5, 0, 0, 0, $6d, 
        $61, $6a, $6f, $72, $14, 0, $28, 0, $1, 0, 
        $5, 0, 0, 0, $6d, $69, $6e, $6f, $72, $14, 
        0, $29, 0, $1, 0, $5, 0, 0, 0, $66, 
        $6c, $61, $67, $73, $14, 0, $b, 0, $1f, 0, 
        $1, 0, $6, 0, 0, 0, $56, $65, $63, $74, 
        $6f, $72, $a, 0, $5, 0, $5e, $ab, $82, $3d, 
        $da, $62, $cf, $11, $ab, $39, 0, $20, $af, $71, 
        $e4, $33, $2a, 0, $1, 0, $1, 0, 0, 0, 
        $78, $14, 0, $2a, 0, $1, 0, $1, 0, 0, 
        0, $79, $14, 0, $2a, 0, $1, 0, $1, 0, 
        0, 0, $7a, $14, 0, $b, 0, $1f, 0, $1, 
        0, $8, 0, 0, 0, $43, $6f, $6f, $72, $64, 
        $73, $32, $64, $a, 0, $5, 0, $44, $3f, $f2,
        $f6, $86, $76, $cf, $11, $8f, $52, 0, $40, $33, 
        $35, $94, $a3, $2a, 0, $1, 0, $1, 0, 0, 
        0, $75, $14, 0, $2a, 0, $1, 0, $1, 0, 
        0, 0, $76, $14, 0, $b, 0, $1f, 0, $1, 
        0, $9, 0, 0, 0, $4d, $61, $74, $72, $69, 
        $78, $34, $78, $34, $a, 0, $5, 0, $45, $3f, 
        $f2, $f6, $86, $76, $cf, $11, $8f, $52, 0, $40, 
        $33, $35, $94, $a3, $34, 0, $2a, 0, $1, 0, 
        $6, 0, 0, 0, $6d, $61, $74, $72, $69, $78, 
        $e, 0, $3, 0, $10, 0, 0, 0, $f, 0, 
        $14, 0, $b, 0, $1f, 0, $1, 0, $9, 0, 
        0, 0, $43, $6f, $6c, $6f, $72, $52, $47, $42, 
        $41, $a, 0, $5, 0, $e0, $44, $ff, $35, $7c, 
        $6c, $cf, $11, $8f, $52, 0, $40, $33, $35, $94,
        $a3, $2a, 0, $1, 0, $3, 0, 0, 0, $72, 
        $65, $64, $14, 0, $2a, 0, $1, 0, $5, 0, 
        0, 0, $67, $72, $65, $65, $6e, $14, 0, $2a, 
        0, $1, 0, $4, 0, 0, 0, $62, $6c, $75, 
        $65, $14, 0, $2a, 0, $1, 0, $5, 0, 0, 
        0, $61, $6c, $70, $68, $61, $14, 0, $b, 0, 
        $1f, 0, $1, 0, $8, 0, 0, 0, $43, $6f, 
        $6c, $6f, $72, $52, $47, $42, $a, 0, $5, 0, 
        $81, $6e, $e1, $d3, $35, $78, $cf, $11, $8f, $52, 
        0, $40, $33, $35, $94, $a3, $2a, 0, $1, 0, 
        $3, 0, 0, 0, $72, $65, $64, $14, 0, $2a, 
        0, $1, 0, $5, 0, 0, 0, $67, $72, $65, 
        $65, $6e, $14, 0, $2a, 0, $1, 0, $4, 0, 
        0, 0, $62, $6c, $75, $65, $14, 0, $b, 0, 
        $1f, 0, $1, 0, $c, 0, 0, 0, $49, $6e, 
        $64, $65, $78, $65, $64, $43, $6f, $6c, $6f, $72, 
        $a, 0, $5, 0, $20, $b8, $30, $16, $42, $78,
        $cf, $11, $8f, $52, 0, $40, $33, $35, $94, $a3, 
        $29, 0, $1, 0, $5, 0, 0, 0, $69, $6e, 
        $64, $65, $78, $14, 0, $1, 0, $9, 0, 0, 
        0, $43, $6f, $6c, $6f, $72, $52, $47, $42, $41, 
        $1, 0, $a, 0, 0, 0, $69, $6e, $64, $65, 
        $78, $43, $6f, $6c, $6f, $72, $14, 0, $b, 0, 
        $1f, 0, $1, 0, $7, 0, 0, 0, $42, $6f, 
        $6f, $6c, $65, $61, $6e, $a, 0, $5, 0, $a0, 
        $a6, $7d, $53, $37, $ca, $d0, $11, $94, $1c, 0, 
        $80, $c8, $c, $fa, $7b, $29, 0, $1, 0, $9, 
        0, 0, 0, $74, $72, $75, $65, $66, $61, $6c, 
        $73, $65, $14, 0, $b, 0, $1f, 0, $1, 0, 
        $9, 0, 0, 0, $42, $6f, $6f, $6c, $65, $61, 
        $6e, $32, $64, $a, 0, $5, 0, $63, $ae, $85,
        $48, $e8, $78, $cf, $11, $8f, $52, 0, $40, $33, 
        $35, $94, $a3, $1, 0, $7, 0, 0, 0, $42, 
        $6f, $6f, $6c, $65, $61, $6e, $1, 0, $1, 0, 
        0, 0, $75, $14, 0, $1, 0, $7, 0, 0, 
        0, $42, $6f, $6f, $6c, $65, $61, $6e, $1, 0, 
        $1, 0, 0, 0, $76, $14, 0, $b, 0, $1f, 
        0, $1, 0, $c, 0, 0, 0, $4d, $61, $74, 
        $65, $72, $69, $61, $6c, $57, $72, $61, $70, $a, 
        0, $5, 0, $60, $ae, $85, $48, $e8, $78, $cf, 
        $11, $8f, $52, 0, $40, $33, $35, $94, $a3, $1, 
        0, $7, 0, 0, 0, $42, $6f, $6f, $6c, $65, 
        $61, $6e, $1, 0, $1, 0, 0, 0, $75, $14, 
        0, $1, 0, $7, 0, 0, 0, $42, $6f, $6f, 
        $6c, $65, $61, $6e, $1, 0, $1, 0, 0, 0, 
        $76, $14, 0, $b, 0, $1f, 0, $1, 0, $f, 
        0, 0, 0, $54, $65, $78, $74, $75, $72, $65, 
        $46, $69, $6c, $65, $6e, $61, $6d, $65, $a, 0,
        $5, 0, $e1, $90, $27, $a4, $10, $78, $cf, $11, 
        $8f, $52, 0, $40, $33, $35, $94, $a3, $31, 0, 
        $1, 0, $8, 0, 0, 0, $66, $69, $6c, $65, 
        $6e, $61, $6d, $65, $14, 0, $b, 0, $1f, 0, 
        $1, 0, $8, 0, 0, 0, $4d, $61, $74, $65, 
        $72, $69, $61, $6c, $a, 0, $5, 0, $4d, $ab, 
        $82, $3d, $da, $62, $cf, $11, $ab, $39, 0, $20, 
        $af, $71, $e4, $33, $1, 0, $9, 0, 0, 0, 
        $43, $6f, $6c, $6f, $72, $52, $47, $42, $41, $1, 
        0, $9, 0, 0, 0, $66, $61, $63, $65, $43, 
        $6f, $6c, $6f, $72, $14, 0, $2a, 0, $1, 0, 
        $5, 0, 0, 0, $70, $6f, $77, $65, $72, $14, 
        0, $1, 0, $8, 0, 0, 0, $43, $6f, $6c, 
        $6f, $72, $52, $47, $42, $1, 0, $d, 0, 0, 
        0, $73, $70, $65, $63, $75, $6c, $61, $72, $43, 
        $6f, $6c, $6f, $72, $14, 0, $1, 0, $8, 0, 
        0, 0, $43, $6f, $6c, $6f, $72, $52, $47, $42, 
        $1, 0, $d, 0, 0, 0, $65, $6d, $69, $73, 
        $73, $69, $76, $65, $43, $6f, $6c, $6f, $72, $14, 
        0, $e, 0, $12, 0, $12, 0, $12, 0, $f, 
        0, $b, 0, $1f, 0, $1, 0, $8, 0, 0, 
        0, $4d, $65, $73, $68, $46, $61, $63, $65, $a, 
        0, $5, 0, $5f, $ab, $82, $3d, $da, $62, $cf, 
        $11, $ab, $39, 0, $20, $af, $71, $e4, $33, $29, 
        0, $1, 0, $12, 0, 0, 0, $6e, $46, $61, 
        $63, $65, $56, $65, $72, $74, $65, $78, $49, $6e, 
        $64, $69, $63, $65, $73, $14, 0, $34, 0, $29, 
        0, $1, 0, $11, 0, 0, 0, $66, $61, $63, 
        $65, $56, $65, $72, $74, $65, $78, $49, $6e, $64, 
        $69, $63, $65, $73, $e, 0, $1, 0, $12, 0, 
        0, 0, $6e, $46, $61, $63, $65, $56, $65, $72,
        $74, $65, $78, $49, $6e, $64, $69, $63, $65, $73, 
        $f, 0, $14, 0, $b, 0, $1f, 0, $1, 0, 
        $d, 0, 0, 0, $4d, $65, $73, $68, $46, $61, 
        $63, $65, $57, $72, $61, $70, $73, $a, 0, $5, 
        0, $c0, $c5, $1e, $ed, $a8, $c0, $d0, $11, $94,
        $1c, 0, $80, $c8, $c, $fa, $7b, $29, 0, $1, 
        0, $f, 0, 0, 0, $6e, $46, $61, $63, $65, 
        $57, $72, $61, $70, $56, $61, $6c, $75, $65, $73, 
        $14, 0, $34, 0, $1, 0, $9, 0, 0, 0, 
        $42, $6f, $6f, $6c, $65, $61, $6e, $32, $64, $1, 
        0, $e, 0, 0, 0, $66, $61, $63, $65, $57, 
        $72, $61, $70, $56, $61, $6c, $75, $65, $73, $e, 
        0, $1, 0, $f, 0, 0, 0, $6e, $46, $61, 
        $63, $65, $57, $72, $61, $70, $56, $61, $6c, $75, 
        $65, $73, $f, 0, $14, 0, $b, 0, $1f, 0, 
        $1, 0, $11, 0, 0, 0, $4d, $65, $73, $68, 
        $54, $65, $78, $74, $75, $72, $65, $43, $6f, $6f, 
        $72, $64, $73, $a, 0, $5, 0, $40, $3f, $f2, 
        $f6, $86, $76, $cf, $11, $8f, $52, 0, $40, $33, 
        $35, $94, $a3, $29, 0, $1, 0, $e, 0, 0, 
        0, $6e, $54, $65, $78, $74, $75, $72, $65, $43, 
        $6f, $6f, $72, $64, $73, $14, 0, $34, 0, $1, 
        0, $8, 0, 0, 0, $43, $6f, $6f, $72, $64, 
        $73, $32, $64, $1, 0, $d, 0, 0, 0, $74, 
        $65, $78, $74, $75, $72, $65, $43, $6f, $6f, $72, 
        $64, $73, $e, 0, $1, 0, $e, 0, 0, 0, 
        $6e, $54, $65, $78, $74, $75, $72, $65, $43, $6f, 
        $6f, $72, $64, $73, $f, 0, $14, 0, $b, 0, 
        $1f, 0, $1, 0, $10, 0, 0, 0, $4d, $65, 
        $73, $68, $4d, $61, $74, $65, $72, $69, $61, $6c, 
        $4c, $69, $73, $74, $a, 0, $5, 0, $42, $3f,
        $f2, $f6, $86, $76, $cf, $11, $8f, $52, 0, $40, 
        $33, $35, $94, $a3, $29, 0, $1, 0, $a, 0, 
        0, 0, $6e, $4d, $61, $74, $65, $72, $69, $61, 
        $6c, $73, $14, 0, $29, 0, $1, 0, $c, 0, 
        0, 0, $6e, $46, $61, $63, $65, $49, $6e, $64, 
        $65, $78, $65, $73, $14, 0, $34, 0, $29, 0, 
        $1, 0, $b, 0, 0, 0, $66, $61, $63, $65, 
        $49, $6e, $64, $65, $78, $65, $73, $e, 0, $1, 
        0, $c, 0, 0, 0, $6e, $46, $61, $63, $65, 
        $49, $6e, $64, $65, $78, $65, $73, $f, 0, $14, 
        0, $e, 0, $1, 0, $8, 0, 0, 0, $4d, 
        $61, $74, $65, $72, $69, $61, $6c, $f, 0, $b, 
        0, $1f, 0, $1, 0, $b, 0, 0, 0, $4d, 
        $65, $73, $68, $4e, $6f, $72, $6d, $61, $6c, $73, 
        $a, 0, $5, 0, $43, $3f, $f2, $f6, $86, $76, 
        $cf, $11, $8f, $52, 0, $40, $33, $35, $94, $a3, 
        $29, 0, $1, 0, $8, 0, 0, 0, $6e, $4e, 
        $6f, $72, $6d, $61, $6c, $73, $14, 0, $34, 0, 
        $1, 0, $6, 0, 0, 0, $56, $65, $63, $74, 
        $6f, $72, $1, 0, $7, 0, 0, 0, $6e, $6f, 
        $72, $6d, $61, $6c, $73, $e, 0, $1, 0, $8, 
        0, 0, 0, $6e, $4e, $6f, $72, $6d, $61, $6c, 
        $73, $f, 0, $14, 0, $29, 0, $1, 0, $c, 
        0, 0, 0, $6e, $46, $61, $63, $65, $4e, $6f, 
        $72, $6d, $61, $6c, $73, $14, 0, $34, 0, $1, 
        0, $8, 0, 0, 0, $4d, $65, $73, $68, $46, 
        $61, $63, $65, $1, 0, $b, 0, 0, 0, $66,
        $61, $63, $65, $4e, $6f, $72, $6d, $61, $6c, $73, 
        $e, 0, $1, 0, $c, 0, 0, 0, $6e, $46, 
        $61, $63, $65, $4e, $6f, $72, $6d, $61, $6c, $73, 
        $f, 0, $14, 0, $b, 0, $1f, 0, $1, 0,
        $10, 0, 0, 0, $4d, $65, $73, $68, $56, $65, 
        $72, $74, $65, $78, $43, $6f, $6c, $6f, $72, $73, 
        $a, 0, $5, 0, $21, $b8, $30, $16, $42, $78, 
        $cf, $11, $8f, $52, 0, $40, $33, $35, $94, $a3, 
        $29, 0, $1, 0, $d, 0, 0, 0, $6e, $56, 
        $65, $72, $74, $65, $78, $43, $6f, $6c, $6f, $72, 
        $73, $14, 0, $34, 0, $1, 0, $c, 0, 0, 
        0, $49, $6e, $64, $65, $78, $65, $64, $43, $6f, 
        $6c, $6f, $72, $1, 0, $c, 0, 0, 0, $76, 
        $65, $72, $74, $65, $78, $43, $6f, $6c, $6f, $72, 
        $73, $e, 0, $1, 0, $d, 0, 0, 0, $6e, 
        $56, $65, $72, $74, $65, $78, $43, $6f, $6c, $6f, 
        $72, $73, $f, 0, $14, 0, $b, 0, $1f, 0, 
        $1, 0, $4, 0, 0, 0, $4d, $65, $73, $68, 
        $a, 0, $5, 0, $44, $ab, $82, $3d, $da, $62, 
        $cf, $11, $ab, $39, 0, $20, $af, $71, $e4, $33, 
        $29, 0, $1, 0, $9, 0, 0, 0, $6e, $56, 
        $65, $72, $74, $69, $63, $65, $73, $14, 0, $34, 
        0, $1, 0, $6, 0, 0, 0, $56, $65, $63, 
        $74, $6f, $72, $1, 0, $8, 0, 0, 0, $76, 
        $65, $72, $74, $69, $63, $65, $73, $e, 0, $1, 
        0, $9, 0, 0, 0, $6e, $56, $65, $72, $74, 
        $69, $63, $65, $73, $f, 0, $14, 0, $29, 0, 
        $1, 0, $6, 0, 0, 0, $6e, $46, $61, $63, 
        $65, $73, $14, 0, $34, 0, $1, 0, $8, 0, 
        0, 0, $4d, $65, $73, $68, $46, $61, $63, $65, 
        $1, 0, $5, 0, 0, 0, $66, $61, $63, $65, 
        $73, $e, 0, $1, 0, $6, 0, 0, 0, $6e, 
        $46, $61, $63, $65, $73, $f, 0, $14, 0, $e, 
        0, $12, 0, $12, 0, $12, 0, $f, 0, $b, 
        0, $1f, 0, $1, 0, $14, 0, 0, 0, $46,
        $72, $61, $6d, $65, $54, $72, $61, $6e, $73, $66, 
        $6f, $72, $6d, $4d, $61, $74, $72, $69, $78, $a, 
        0, $5, 0, $41, $3f, $f2, $f6, $86, $76, $cf, 
        $11, $8f, $52, 0, $40, $33, $35, $94, $a3, $1, 
        0, $9, 0, 0, 0, $4d, $61, $74, $72, $69, 
        $78, $34, $78, $34, $1, 0, $b, 0, 0, 0, 
        $66, $72, $61, $6d, $65, $4d, $61, $74, $72, $69, 
        $78, $14, 0, $b, 0, $1f, 0, $1, 0, $5, 
        0, 0, 0, $46, $72, $61, $6d, $65, $a, 0, 
        $5, 0, $46, $ab, $82, $3d, $da, $62, $cf, $11, 
        $ab, $39, 0, $20, $af, $71, $e4, $33, $e, 0, 
        $12, 0, $12, 0, $12, 0, $f, 0, $b, 0, 
        $1f, 0, $1, 0, $9, 0, 0, 0, $46, $6c, 
        $6f, $61, $74, $4b, $65, $79, $73, $a, 0, $5, 
        0, $a9, $46, $dd, $10, $5b, $77, $cf, $11, $8f, 
        $52, 0, $40, $33, $35, $94, $a3, $29, 0, $1, 
        0, $7, 0, 0, 0, $6e, $56, $61, $6c, $75, 
        $65, $73, $14, 0, $34, 0, $2a, 0, $1, 0,
        $6, 0, 0, 0, $76, $61, $6c, $75, $65, $73, 
        $e, 0, $1, 0, $7, 0, 0, 0, $6e, $56, 
        $61, $6c, $75, $65, $73, $f, 0, $14, 0, $b, 
        0, $1f, 0, $1, 0, $e, 0, 0, 0, $54, 
        $69, $6d, $65, $64, $46, $6c, $6f, $61, $74, $4b, 
        $65, $79, $73, $a, 0, $5, 0, $80, $b1, $6, 
        $f4, $3b, $7b, $cf, $11, $8f, $52, 0, $40, $33, 
        $35, $94, $a3, $29, 0, $1, 0, $4, 0, 0, 
        0, $74, $69, $6d, $65, $14, 0, $1, 0, $9, 
        0, 0, 0, $46, $6c, $6f, $61, $74, $4b, $65, 
        $79, $73, $1, 0, $6, 0, 0, 0, $74, $66, 
        $6b, $65, $79, $73, $14, 0, $b, 0, $1f, 0, 
        $1, 0, $c, 0, 0, 0, $41, $6e, $69, $6d,
        $61, $74, $69, $6f, $6e, $4b, $65, $79, $a, 0, 
        $5, 0, $a8, $46, $dd, $10, $5b, $77, $cf, $11, 
        $8f, $52, 0, $40, $33, $35, $94, $a3, $29, 0, 
        $1, 0, $7, 0, 0, 0, $6b, $65, $79, $54, 
        $79, $70, $65, $14, 0, $29, 0, $1, 0, $5, 
        0, 0, 0, $6e, $4b, $65, $79, $73, $14, 0, 
        $34, 0, $1, 0, $e, 0, 0, 0, $54, $69, 
        $6d, $65, $64, $46, $6c, $6f, $61, $74, $4b, $65, 
        $79, $73, $1, 0, $4, 0, 0, 0, $6b, $65, 
        $79, $73, $e, 0, $1, 0, $5, 0, 0, 0, 
        $6e, $4b, $65, $79, $73, $f, 0, $14, 0, $b, 
        0, $1f, 0, $1, 0, $10, 0, 0, 0, $41, 
        $6e, $69, $6d, $61, $74, $69, $6f, $6e, $4f, $70, 
        $74, $69, $6f, $6e, $73, $a, 0, $5, 0, $c0, 
        $56, $bf, $e2, $f, $84, $cf, $11, $8f, $52, 0, 
        $40, $33, $35, $94, $a3, $29, 0, $1, 0, $a, 
        0, 0, 0, $6f, $70, $65, $6e, $63, $6c, $6f, 
        $73, $65, $64, $14, 0, $29, 0, $1, 0, $f, 
        0, 0, 0, $70, $6f, $73, $69, $74, $69, $6f, 
        $6e, $71, $75, $61, $6c, $69, $74, $79, $14, 0, 
        $b, 0, $1f, 0, $1, 0, $9, 0, 0, 0, 
        $41, $6e, $69, $6d, $61, $74, $69, $6f, $6e, $a, 
        0, $5, 0, $4f, $ab, $82, $3d, $da, $62, $cf, 
        $11, $ab, $39, 0, $20, $af, $71, $e4, $33, $e, 
        0, $12, 0, $12, 0, $12, 0, $f, 0, $b, 
        0, $1f, 0, $1, 0, $c, 0, 0, 0, $41, 
        $6e, $69, $6d, $61, $74, $69, $6f, $6e, $53, $65, 
        $74, $a, 0, $5, 0, $50, $ab, $82, $3d, $da, 
        $62, $cf, $11, $ab, $39, 0, $20, $af, $71, $e4, 
        $33, $e, 0, $1, 0, $9, 0, 0, 0, $41, 
        $6e, $69, $6d, $61, $74, $69, $6f, $6e, $f, 0,
        $b, 0, $1f, 0, $1, 0, $a, 0, 0, 0, 
        $49, $6e, $6c, $69, $6e, $65, $44, $61, $74, $61, 
        $a, 0, $5, 0, $a0, $ee, $23, $3a, $b1, $94, 
        $d0, $11, $ab, $39, 0, $20, $af, $71, $e4, $33, 
        $e, 0, $1, 0, $6, 0, 0, 0, $42, $49, 
        $4e, $41, $52, $59, $f, 0, $b, 0, $1f, 0, 
        $1, 0, $3, 0, 0, 0, $55, $72, $6c, $a, 
        0, $5, 0, $a1, $ee, $23, $3a, $b1, $94, $d0, 
        $11, $ab, $39, 0, $20, $af, $71, $e4, $33, $29,
        0, $1, 0, $5, 0, 0, 0, $6e, $55, $72, 
        $6c, $73, $14, 0, $34, 0, $31, 0, $1, 0, 
        $4, 0, 0, 0, $75, $72, $6c, $73, $e, 0, 
        $1, 0, $5, 0, 0, 0, $6e, $55, $72, $6c, 
        $73, $f, 0, $14, 0, $b, 0, $1f, 0, $1, 
        0, $f, 0, 0, 0, $50, $72, $6f, $67, $72, 
        $65, $73, $73, $69, $76, $65, $4d, $65, $73, $68, 
        $a, 0, $5, 0, $60, $c3, $63, $8a, $7d, $99, 
        $d0, $11, $94, $1c, 0, $80, $c8, $c, $fa, $7b, 
        $e, 0, $1, 0, $3, 0, 0, 0, $55, $72, 
        $6c, $13, 0, $1, 0, $a, 0, 0, 0, $49, 
        $6e, $6c, $69, $6e, $65, $44, $61, $74, $61, $f, 
        0, $b, 0, $1f, 0, $1, 0, $4, 0, 0, 
        0, $47, $75, $69, $64, $a, 0, $5, 0, $e0, 
        $90, $27, $a4, $10, $78, $cf, $11, $8f, $52, 0, 
        $40, $33, $35, $94, $a3, $29, 0, $1, 0, $5, 
        0, 0, 0, $64, $61, $74, $61, $31, $14, 0, 
        $28, 0, $1, 0, $5, 0, 0, 0, $64, $61, 
        $74, $61, $32, $14, 0, $28, 0, $1, 0, $5, 
        0, 0, 0, $64, $61, $74, $61, $33, $14, 0, 
        $34, 0, $2d, 0, $1, 0, $5, 0, 0, 0, 
        $64, $61, $74, $61, $34, $e, 0, $3, 0, $8,
        0, 0, 0, $f, 0, $14, 0, $b, 0, $1f, 
        0, $1, 0, $e, 0, 0, 0, $53, $74, $72, 
        $69, $6e, $67, $50, $72, $6f, $70, $65, $72, $74, 
        $79, $a, 0, $5, 0, $e0, $21, $f, $7f, $e1, 
        $bf, $d1, $11, $82, $c0, 0, $a0, $c9, $69, $72, 
        $71, $31, 0, $1, 0, $3, 0, 0, 0, $6b, 
        $65, $79, $14, 0, $31, 0, $1, 0, $5, 0, 
        0, 0, $76, $61, $6c, $75, $65, $14, 0, $b, 
        0, $1f, 0, $1, 0, $b, 0, 0, 0, $50, 
        $72, $6f, $70, $65, $72, $74, $79, $42, $61, $67, 
        $a, 0, $5, 0, $e1, $21, $f, $7f, $e1, $bf, 
        $d1, $11, $82, $c0, 0, $a0, $c9, $69, $72, $71, 
        $e, 0, $1, 0, $e, 0, 0, 0, $53, $74, 
        $72, $69, $6e, $67, $50, $72, $6f, $70, $65, $72, 
        $74, $79, $f, 0, $b, 0, $1f, 0, $1, 0, 
        $e, 0, 0, 0, $45, $78, $74, $65, $72, $6e, 
        $61, $6c, $56, $69, $73, $75, $61, $6c, $a, 0, 
        $5, 0, $a0, $6a, $11, $98, $ba, $bd, $d1, $11, 
        $82, $c0, 0, $a0, $c9, $69, $72, $71, $1, 0, 
        $4, 0, 0, 0, $47, $75, $69, $64, $1, 0, 
        $12, 0, 0, 0, $67, $75, $69, $64, $45, $78, 
        $74, $65, $72, $6e, $61, $6c, $56, $69, $73, $75, 
        $61, $6c, $14, 0, $e, 0, $12, 0, $12, 0, 
        $12, 0, $f, 0, $b, 0, $1f, 0, $1, 0, 
        $b, 0, 0, 0, $52, $69, $67, $68, $74, $48, 
        $61, $6e, $64, $65, $64, $a, 0, $5, 0, $a0, 
        $5e, $5d, $7f, $3a, $d5, $d1, $11, $82, $c0, 0, 
        $a0, $c9, $69, $72, $71, $29, 0, $1, 0, $c, 
        0, 0, 0, $62, $52, $69, $67, $68, $74, $48, 
        $61, $6e, $64, $65, $64, $14, 0, $b, 0);

implementation

Uses
  SysUtils, Forms;

(******************************************************************************)
(**                                                                          **)
(** General Stuff                                                            **)
(**                                                                          **)
(******************************************************************************)

function IsNTandDelphiRunning : boolean;
var
  OSVersion  : TOSVersionInfo;
begin
  OSVersion.dwOsVersionInfoSize := sizeof(OSVersion);
  GetVersionEx(OSVersion);
  // Not running in NT or program is not Delphi itself ?
  result := ( (OSVersion.dwPlatformID = VER_PLATFORM_WIN32_NT) and
     (Uppercase(ExtractFileName(Application.ExeName)) = 'DELPHI32.EXE') );
end;

function DDErrorString(Value: HResult) : string;
begin
  case Value of
    DD_OK                              : Result := 'The request completed successfully.';
    DDERR_ALREADYINITIALIZED           : Result := 'This object is already initialized.';
    DDERR_BLTFASTCANTCLIP              : Result := 'BltFast cannot blt if a clipper object is attached to the source surface passed into a BltFast call.';
    DDERR_CANNOTATTACHSURFACE          : Result := 'This surface can not be attached to the requested surface.';
    DDERR_CANNOTDETACHSURFACE          : Result := 'This surface can not be detached from the requested surface.';
    DDERR_CANTCREATEDC                 : Result := 'Windows can not create any more DCs.';
    DDERR_CANTDUPLICATE                : Result := 'Cannot duplicate primary & 3D surfaces, or surfaces that are implicitly created.';
    DDERR_CLIPPERISUSINGHWND           : Result := 'An attempt was made to set a cliplist for a clipper object that is already monitoring an hwnd.';
    DDERR_COLORKEYNOTSET               : Result := 'No src color key specified for this operation.';
    DDERR_CURRENTLYNOTAVAIL            : Result := 'Support is currently not available.';
    DDERR_DIRECTDRAWALREADYCREATED     : Result := 'A DirectDraw object representing this driver has already been created for this process.';
    DDERR_EXCEPTION                    : Result := 'An exception was encountered while performing the requested operation.';
    DDERR_EXCLUSIVEMODEALREADYSET      : Result := 'An attempt was made to set the cooperative level when it was already set to exclusive.';
    DDERR_GENERIC                      : Result := 'Generic failure.';
    DDERR_HEIGHTALIGN                  : Result := 'Height of rectangle provided is not a multiple of reqd alignment.';
    DDERR_HWNDALREADYSET               : Result := 'The CooperativeLevel HWND has already been set. It can not be reset while the process has surfaces or palettes created.';
    DDERR_HWNDSUBCLASSED               : Result := 'HWND used by DirectDraw CooperativeLevel has been subclassed, this prevents DirectDraw from restoring state.';
    DDERR_IMPLICITLYCREATED            : Result := 'This surface can not be restored because it is an implicitly created surface.';
    DDERR_INCOMPATIBLEPRIMARY          : Result := 'Unable to match primary surface creation request with existing primary surface.';
    DDERR_INVALIDCAPS                  : Result := 'One or more of the caps bits passed to the callback are incorrect.';
    DDERR_INVALIDCLIPLIST              : Result := 'DirectDraw does not support the provided cliplist.';
    DDERR_INVALIDDIRECTDRAWGUID        : Result := 'The GUID passed to DirectDrawCreate is not a valid DirectDraw driver identifier.';
    DDERR_INVALIDMODE                  : Result := 'DirectDraw does not support the requested mode.';
    DDERR_INVALIDOBJECT                : Result := 'DirectDraw received a pointer that was an invalid DIRECTDRAW object.';
    DDERR_INVALIDPARAMS                : Result := 'One or more of the parameters passed to the function are incorrect.';
    DDERR_INVALIDPIXELFORMAT           : Result := 'The pixel format was invalid as specified.';
    DDERR_INVALIDPOSITION              : Result := 'Returned when the position of the overlay on the destination is no longer legal for that destination.';
    DDERR_INVALIDRECT                  : Result := 'Rectangle provided was invalid.';
    DDERR_LOCKEDSURFACES               : Result := 'Operation could not be carried out because one or more surfaces are locked.';
    DDERR_NO3D                         : Result := 'There is no 3D present.';
    DDERR_NOALPHAHW                    : Result := 'Operation could not be carried out because there is no alpha accleration hardware present or available.';
    DDERR_NOBLTHW                      : Result := 'No blitter hardware present.';
    DDERR_NOCLIPLIST                   : Result := 'No cliplist available.';
    DDERR_NOCLIPPERATTACHED            : Result := 'No clipper object attached to surface object.';
    DDERR_NOCOLORCONVHW                : Result := 'Operation could not be carried out because there is no color conversion hardware present or available.';
    DDERR_NOCOLORKEY                   : Result := 'Surface does not currently have a color key';
    DDERR_NOCOLORKEYHW                 : Result := 'Operation could not be carried out because there is no hardware support of the destination color key.';
    DDERR_NOCOOPERATIVELEVELSET        : Result := 'Create function called without DirectDraw object method SetCooperativeLevel being called.';
    DDERR_NODC                         : Result := 'No DC was ever created for this surface.';
    DDERR_NODDROPSHW                   : Result := 'No DirectDraw ROP hardware.';
    DDERR_NODIRECTDRAWHW               : Result := 'A hardware-only DirectDraw object creation was attempted but the driver did not support any hardware.';
    DDERR_NOEMULATION                  : Result := 'Software emulation not available.';
    DDERR_NOEXCLUSIVEMODE              : Result := 'Operation requires the application to have exclusive mode but the application does not have exclusive mode.';
    DDERR_NOFLIPHW                     : Result := 'Flipping visible surfaces is not supported.';
    DDERR_NOGDI                        : Result := 'There is no GDI present.';
    DDERR_NOHWND                       : Result := 'Clipper notification requires an HWND or no HWND has previously been set as the CooperativeLevel HWND.';
    DDERR_NOMIRRORHW                   : Result := 'Operation could not be carried out because there is no hardware present or available.';
    DDERR_NOOVERLAYDEST                : Result := 'Returned when GetOverlayPosition is called on an overlay that UpdateOverlay has never been called on to establish a destination.';
    DDERR_NOOVERLAYHW                  : Result := 'Operation could not be carried out because there is no overlay hardware present or available.';
    DDERR_NOPALETTEATTACHED            : Result := 'No palette object attached to this surface.';
    DDERR_NOPALETTEHW                  : Result := 'No hardware support for 16 or 256 color palettes.';
    DDERR_NORASTEROPHW                 : Result := 'Operation could not be carried out because there is no appropriate raster op hardware present or available.';
    DDERR_NOROTATIONHW                 : Result := 'Operation could not be carried out because there is no rotation hardware present or available.';
    DDERR_NOSTRETCHHW                  : Result := 'Operation could not be carried out because there is no hardware support for stretching.';
    DDERR_NOT4BITCOLOR                 : Result := 'DirectDrawSurface is not in 4 bit color palette and the requested operation requires 4 bit color palette.';
    DDERR_NOT4BITCOLORINDEX            : Result := 'DirectDrawSurface is not in 4 bit color index palette and the requested operation requires 4 bit color index palette.';
    DDERR_NOT8BITCOLOR                 : Result := 'DirectDrawSurface is not in 8 bit color mode and the requested operation requires 8 bit color.';
    DDERR_NOTAOVERLAYSURFACE           : Result := 'Returned when an overlay member is called for a non-overlay surface.';
    DDERR_NOTEXTUREHW                  : Result := 'Operation could not be carried out because there is no texture mapping hardware present or available.';
    DDERR_NOTFLIPPABLE                 : Result := 'An attempt has been made to flip a surface that is not flippable.';
    DDERR_NOTFOUND                     : Result := 'Requested item was not found.';
    DDERR_NOTLOCKED                    : Result := 'Surface was not locked.  An attempt to unlock a surface that was not locked at all, or by this process, has been attempted.';
    DDERR_NOTPALETTIZED                : Result := 'The surface being used is not a palette-based surface.';
    DDERR_NOVSYNCHW                    : Result := 'Operation could not be carried out because there is no hardware support for vertical blank synchronized operations.';
    DDERR_NOZBUFFERHW                  : Result := 'Operation could not be carried out because there is no hardware support for zbuffer blitting.';
    DDERR_NOZOVERLAYHW                 : Result := 'Overlay surfaces could not be z layered based on their BltOrder because the hardware does not support z layering of overlays.';
    DDERR_OUTOFCAPS                    : Result := 'The hardware needed for the requested operation has already been allocated.';
    DDERR_OUTOFMEMORY                  : Result := 'DirectDraw does not have enough memory to perform the operation.';
    DDERR_OUTOFVIDEOMEMORY             : Result := 'DirectDraw does not have enough memory to perform the operation.';
    DDERR_OVERLAYCANTCLIP              : Result := 'The hardware does not support clipped overlays.';
    DDERR_OVERLAYCOLORKEYONLYONEACTIVE : Result := 'Can only have ony color key active at one time for overlays.';
    DDERR_OVERLAYNOTVISIBLE            : Result := 'Returned when GetOverlayPosition is called on a hidden overlay.';
    DDERR_PALETTEBUSY                  : Result := 'Access to this palette is being refused because the palette is already locked by another thread.';
    DDERR_PRIMARYSURFACEALREADYEXISTS  : Result := 'This process already has created a primary surface.';
    DDERR_REGIONTOOSMALL               : Result := 'Region passed to Clipper::GetClipList is too small.';
    DDERR_SURFACEALREADYATTACHED       : Result := 'This surface is already attached to the surface it is being attached to.';
    DDERR_SURFACEALREADYDEPENDENT      : Result := 'This surface is already a dependency of the surface it is being made a dependency of.';
    DDERR_SURFACEBUSY                  : Result := 'Access to this surface is being refused because the surface is already locked by another thread.';
    DDERR_SURFACEISOBSCURED            : Result := 'Access to surface refused because the surface is obscured.';
    DDERR_SURFACELOST                  : Result := 'Access to this surface is being refused because the surface memory is gone. The DirectDrawSurface object representing this surface should have Restore called on it.';
    DDERR_SURFACENOTATTACHED           : Result := 'The requested surface is not attached.';
    DDERR_TOOBIGHEIGHT                 : Result := 'Height requested by DirectDraw is too large.';
    DDERR_TOOBIGSIZE                   : Result := 'Size requested by DirectDraw is too large, but the individual height and width are OK.';
    DDERR_TOOBIGWIDTH                  : Result := 'Width requested by DirectDraw is too large.';
    DDERR_UNSUPPORTED                  : Result := 'Action not supported.';
    DDERR_UNSUPPORTEDFORMAT            : Result := 'FOURCC format requested is unsupported by DirectDraw.';
    DDERR_UNSUPPORTEDMASK              : Result := 'Bitmask in the pixel format requested is unsupported by DirectDraw.';
    DDERR_VERTICALBLANKINPROGRESS      : Result := 'Vertical blank is in progress.';
    DDERR_WASSTILLDRAWING              : Result := 'Informs DirectDraw that the previous Blt which is transfering information to or from this Surface is incomplete.';
    DDERR_WRONGMODE                    : Result := 'This surface can not be restored because it was created in a different mode.';
    DDERR_XALIGN                       : Result := 'Rectangle provided was not horizontally aligned on required boundary.';
    // new:
    DDERR_OVERLAPPINGRECTS             : Result := 'Operation could not be carried out because the source and destination rectangles are on the same surface and overlap each other.';
    DDERR_INVALIDSTREAM                : Result := 'The specified stream contains invalid data';
    DDERR_UNSUPPORTEDMODE              : Result := 'The display is currently in an unsupported mode';
    DDERR_NOMIPMAPHW                   : Result := 'Operation could not be carried out because there is no mip-map texture mapping hardware present or available.';
    DDERR_INVALIDSURFACETYPE           : Result := 'The requested action could not be performed because the surface was of the wrong type.';
    DDERR_NOOPTIMIZEHW                 : Result := 'Device does not support optimized surfaces, therefore no video memory optimized surfaces';
    DDERR_NOTLOADED                    : Result := 'Surface is an optimized surface, but has not yet been allocated any memory';
    DDERR_NOFOCUSWINDOW                : Result := 'Attempt was made to create or set a device window without first setting the focus window';
    DDERR_DCALREADYCREATED             : Result := 'A DC has already been returned for this surface. Only one DC can be retrieved per surface.';
    DDERR_NONONLOCALVIDMEM             : Result := 'An attempt was made to allocate non-local video memory from a device that does not support non-local video memory.';
    DDERR_CANTPAGELOCK                 : Result := 'The attempt to page lock a surface failed.';
    DDERR_CANTPAGEUNLOCK               : Result := 'The attempt to page unlock a surface failed.';
    DDERR_NOTPAGELOCKED                : Result := 'An attempt was made to page unlock a surface with no outstanding page locks.';
    DDERR_MOREDATA                     : Result := 'There is more data available than the specified buffer size could hold';
    DDERR_EXPIRED                      : Result := 'The data has expired and is therefore no longer valid.';
    DDERR_VIDEONOTACTIVE               : Result := 'The video port is not active';
    DDERR_DEVICEDOESNTOWNSURFACE       : Result := 'Surfaces created by one direct draw device cannot be used directly by another direct draw device.';
    DDERR_NOTINITIALIZED               : Result := 'An attempt was made to invoke an Interface member of a DirectDraw object created by CoCreateInstance() before it was initialized.';
    else                                 Result := 'Unrecognized Error';
  end;
end;

function D3DErrorString(Value: HResult) : string; //Full description not available yet
begin
  case Value of
    D3D_OK                           : Result := 'No error occurred.';
    D3DERR_BADMAJORVERSION           : Result := 'The service you requested is unavailable in this major version of DirectX. (A "major version" denotes a primary release, such as DirectX 6.0.)';
    D3DERR_BADMINORVERSION           : Result := 'The service you requested is available in this major version of DirectX, but not in this minor version. Get the latest version of the component runtime from Microsoft. (A "minor version" denotes a secondary release, such as DirectX 6.1.)';
    D3DERR_COLORKEYATTACHED          : Result := 'The application attempted to create a texture with a surface that uses a color key for transparency.';
    D3DERR_CONFLICTINGTEXTUREFILTER  : Result := 'The current texture filters cannot be used together.';
    D3DERR_CONFLICTINGTEXTUREPALETTE : Result := 'The current textures cannot be used simultaneously. This generally occurs when a multi-texture device requires that all palettized textures simultaneously enabled also share the same palette.';
    D3DERR_CONFLICTINGRENDERSTATE    : Result := 'The currently set render states cannot be used together.';
    D3DERR_DEVICEAGGREGATED          : Result := 'The IDirect3DDevice3::SetRenderTarget method was called on a device that was retrieved from the render target surface.';
    D3DERR_EXECUTE_CLIPPED_FAILED    : Result := 'The execute buffer could not be clipped during execution.';
    D3DERR_EXECUTE_CREATE_FAILED     : Result := 'The execute buffer could not be created. This typically occurs when no memory is available to allocate the execute buffer.';
    D3DERR_EXECUTE_DESTROY_FAILED    : Result := 'The memory for the execute buffer could not be deallocated.';
    D3DERR_EXECUTE_FAILED            : Result := 'The contents of the execute buffer are invalid and cannot be executed.';
    D3DERR_EXECUTE_LOCK_FAILED       : Result := 'The execute buffer could not be locked.';
    D3DERR_EXECUTE_LOCKED            : Result := 'The operation requested by the application could not be completed because the execute buffer is locked.';
    D3DERR_EXECUTE_NOT_LOCKED        : Result := 'The execute buffer could not be unlocked because it is not currently locked.';
    D3DERR_EXECUTE_UNLOCK_FAILED     : Result := 'The execute buffer could not be unlocked.';
    D3DERR_INITFAILED                : Result := 'A rendering device could not be created because the new device could not be initialized.';
    D3DERR_INBEGIN                   : Result := 'The requested operation cannot be completed while scene rendering is taking place. Try again after the scene is completed and the IDirect3DDevice::EndScene method (or equivalent method) is called.';
    D3DERR_INVALID_DEVICE            : Result := 'The requested device type is not valid.';
    D3DERR_INVALIDCURRENTVIEWPORT    : Result := 'The currently selected viewport is not valid.';
    D3DERR_INVALIDMATRIX             : Result := 'The requested operation could not be completed because the combination of the currently set world, view, and projection matrices is invalid (the determinant of the combined matrix is zero).';
    D3DERR_INVALIDPALETTE            : Result := 'The palette associated with a surface is invalid.';
    D3DERR_INVALIDPRIMITIVETYPE      : Result := 'The primitive type specified by the application is invalid.';
    D3DERR_INVALIDRAMPTEXTURE        : Result := 'Ramp mode is being used and the texture handle in the current material does not match the current texture handle that is set as a render state.';
    D3DERR_INVALIDVERTEXFORMAT       : Result := 'The combination of flexible vertex format flags specified by the application is not valid.';
    D3DERR_INVALIDVERTEXTYPE         : Result := 'The vertex type specified by the application is invalid.';
    D3DERR_LIGHT_SET_FAILED          : Result := 'The attempt to set lighting parameters for a light object failed.';
    D3DERR_LIGHTHASVIEWPORT          : Result := 'The requested operation failed because the light object is associated with another viewport.';
    D3DERR_LIGHTNOTINTHISVIEWPORT    : Result := 'The requested operation failed because the light object has not been associated with this viewport.';
    D3DERR_MATERIAL_CREATE_FAILED    : Result := 'The material could not be created. This typically occurs when no memory is available to allocate for the material.';
    D3DERR_MATERIAL_DESTROY_FAILED   : Result := 'The memory for the material could not be deallocated.';
    D3DERR_MATERIAL_GETDATA_FAILED   : Result := 'The material parameters could not be retrieved.';
    D3DERR_MATERIAL_SETDATA_FAILED   : Result := 'The material parameters could not be set.';
    D3DERR_MATRIX_CREATE_FAILED      : Result := 'The matrix could not be created. This can occur when no memory is available to allocate for the matrix.';
    D3DERR_MATRIX_DESTROY_FAILED     : Result := 'The memory for the matrix could not be deallocated.';
    D3DERR_MATRIX_GETDATA_FAILED     : Result := 'The matrix data could not be retrieved. This can occur when the matrix was not created by the current device.';
    D3DERR_MATRIX_SETDATA_FAILED     : Result := 'The matrix data could not be set. This can occur when the matrix was not created by the current device.';
    D3DERR_NOCURRENTVIEWPORT         : Result := 'The viewport parameters could not be retrieved because none have been set.';
    D3DERR_NOTINBEGIN                : Result := 'The requested rendering operation could not be completed because scene rendering has not begun. Call IDirect3DDevice3::BeginScene to begin rendering then try again.';
    D3DERR_NOVIEWPORTS               : Result := 'The requested operation failed because the device currently has no viewports associated with it.';
    D3DERR_SCENE_BEGIN_FAILED        : Result := 'Scene rendering could not begin.';
    D3DERR_SCENE_END_FAILED          : Result := 'Scene rendering could not be completed.';
    D3DERR_SCENE_IN_SCENE            : Result := 'Scene rendering could not begin because a previous scene was not completed by a call to the IDirect3DDevice3::EndScene method.';
    D3DERR_SCENE_NOT_IN_SCENE        : Result := 'Scene rendering could not be completed because a scene was not started by a previous call to the IDirect3DDevice3::BeginScene method.';
    D3DERR_SETVIEWPORTDATA_FAILED    : Result := 'The viewport parameters could not be set.';
    D3DERR_STENCILBUFFER_NOTPRESENT  : Result := 'The requested stencil buffer operation could not be completed because there is no stencil buffer attached to the render target surface.';
    D3DERR_SURFACENOTINVIDMEM        : Result := 'The device could not be created because the render target surface is not located in video-memory. (Hardware-accelerated devices require video-memory render target surfaces.)';
    D3DERR_TEXTURE_BADSIZE           : Result := 'The dimensions of a current texture are invalid. This can occur when an application attempts to use a texture that has non-power-of-two dimensions with a device that requires them.';
    D3DERR_TEXTURE_CREATE_FAILED     : Result := 'The texture handle for the texture could not be retrieved from the driver.';
    D3DERR_TEXTURE_DESTROY_FAILED    : Result := 'The device was unable to deallocate the texture memory.';
    D3DERR_TEXTURE_GETSURF_FAILED    : Result := 'The DirectDraw surface used to create the texture could not be retrieved.';
    D3DERR_TEXTURE_LOAD_FAILED       : Result := 'The texture could not be loaded.';
    D3DERR_TEXTURE_LOCK_FAILED       : Result := 'The texture could not be locked.';
    D3DERR_TEXTURE_LOCKED            : Result := 'The requested operation could not be completed because the texture surface is currently locked.';
    D3DERR_TEXTURE_NO_SUPPORT        : Result := 'The device does not support texture mapping.';
    D3DERR_TEXTURE_NOT_LOCKED        : Result := 'The requested operation could not be completed because the texture surface is not locked.';
    D3DERR_TEXTURE_SWAP_FAILED       : Result := 'The texture handles could not be swapped.';
    D3DERR_TEXTURE_UNLOCK_FAILED     : Result := 'The texture surface could not be unlocked.';
    D3DERR_TOOMANYOPERATIONS         : Result := 'The application is requesting more texture filtering operations than the device supports.';
    D3DERR_TOOMANYPRIMITIVES         : Result := 'The device is unable to render the provided quantity of primitives in a single pass.';
    D3DERR_UNSUPPORTEDALPHAARG       : Result := 'The device does not support one of the specified texture blending arguments for the alpha channel.';
    D3DERR_UNSUPPORTEDALPHAOPERATION : Result := 'The device does not support one of the specified texture blending operations for the alpha channel.';
    D3DERR_UNSUPPORTEDCOLORARG       : Result := 'The device does not support the one of the specified texture blending arguments for color values.';
    D3DERR_UNSUPPORTEDCOLOROPERATION : Result := 'The device does not support the one of the specified texture blending operations for color values.';
    D3DERR_UNSUPPORTEDFACTORVALUE    : Result := 'The specified texture factor value is not supported by the device.';
    D3DERR_UNSUPPORTEDTEXTUREFILTER  : Result := 'The specified texture filter is not supported by the device.';
    D3DERR_VBUF_CREATE_FAILED        : Result := 'The vertex buffer could not be created. This can happen when there is insufficient memory to allocate a vertex buffer.';
    D3DERR_VERTEXBUFFERLOCKED        : Result := 'The requested operation could not be completed because the vertex buffer is locked.';
    D3DERR_VERTEXBUFFEROPTIMIZED     : Result := 'The requested operation could not be completed because the vertex buffer is optimized. (The contents of optimized vertex buffers are driver specific, and considered private.)';
    D3DERR_VIEWPORTDATANOTSET        : Result := 'The requested operation could not be completed because viewport parameters have not yet been set. Set the viewport parameters by calling IDirect3DViewport3::SetViewport method and try again.';
    D3DERR_VIEWPORTHASNODEVICE       : Result := 'The requested operation could not be completed because the viewport has not yet been associated with a device. Associate the viewport with a rendering device by calling IDirect3DDevice3::AddViewport and try again.';
    D3DERR_WRONGTEXTUREFORMAT        : Result := 'The pixel format of the texture surface is not valid.';
    D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY  : Result := 'The requested operation could not be completed because the specified device requires system-memory depth-buffer surfaces. (Software rendering devices require system-memory depth buffers.)';
    D3DERR_ZBUFF_NEEDS_VIDEOMEMORY   : Result := 'The requested operation could not be completed because the specified device requires video-memory depth-buffer surfaces. (Hardware-accelerated devices require video-memory depth buffers.)';
    D3DERR_ZBUFFER_NOTPRESENT        : Result := 'The requested operation could not be completed because the render target surface does not have an attached depth buffer.';
    Else                               Result := 'Unrecognized Error';
  End;
end;

function D3DRMErrorString(Value: HResult) : string;
begin
  case Value of
    D3DRM_OK                       : Result := 'No error. Equivalent to DD_OK.';
    D3DRMERR_BADALLOC              : Result := 'Out of memory.';
    D3DRMERR_BADDEVICE             : Result := 'Device is not compatible with renderer.';
    D3DRMERR_BADFILE               : Result := 'Data file is corrupt.';
    D3DRMERR_BADMAJORVERSION       : Result := 'Bad DLL major version.';
    D3DRMERR_BADMINORVERSION       : Result := 'Bad DLL minor version.';
    D3DRMERR_BADOBJECT             : Result := 'Object expected in argument.';
    D3DRMERR_BADPMDATA             : Result := 'The data in the .x file is corrupted. The conversion to a progressive mesh succeeded but produced an invalid progressive mesh in the .x file.';
    D3DRMERR_BADTYPE               : Result := 'Bad argument type passed.';
    D3DRMERR_BADVALUE              : Result := 'Bad argument value passed.';
    D3DRMERR_BOXNOTSET             : Result := 'An attempt was made to access a bounding box (for example, with IDirect3DRMFrame3::GetBox) when no bounding box was set on the frame.';
    D3DRMERR_CLIENTNOTREGISTERED   : Result := 'Client has not been registered. Call IDirect3DRM3::RegisterClient.';
    D3DRMERR_CONNECTIONLOST        : Result := 'Data connection was lost during a load, clone, or duplicate.';
    D3DRMERR_ELEMENTINUSE          : Result := 'Element can´t be modified or deleted while in use. To empty a submesh, call Empty() against its parent.';
//  D3DRMERR_ENTRYINUSE            : Result := 'Vertex or normal entries are currently in use by a face and cannot be deleted.';
    D3DRMERR_FACEUSED              : Result := 'Face already used in a mesh.';
    D3DRMERR_FILENOTFOUND          : Result := 'File cannot be opened.';
//  D3DRMERR_INCOMPATIBLEKEY       : Result := 'Specified animation key is incompatible. The key cannot be modified.';
    D3DRMERR_INVALIDLIBRARY        : Result := 'Specified libary is invalid.';
//  D3DRMERR_INVALIDOBJECT         : Result := 'Method received a pointer to an object that is invalid.';
//  D3DRMERR_INVALIDPARAMS         : Result := 'One of the parameters passed to the method is invalid.';
    D3DRMERR_LIBRARYNOTFOUND       : Result := 'Specified libary not found.';
    D3DRMERR_LOADABORTED           : Result := 'Load aborted by user.';
    D3DRMERR_NOSUCHKEY             : Result := 'Specified animation key does not exist.';
    D3DRMERR_NOTCREATEDFROMDDS     : Result := 'Specified texture was not created from a DirectDraw Surface.';
    D3DRMERR_NOTDONEYET            : Result := 'Unimplemented.';
    D3DRMERR_NOTENOUGHDATA         : Result := 'Not enough data has been loaded to perform the requested operation.';
    D3DRMERR_NOTFOUND              : Result := 'Object not found in specified place.';
//  D3DRMERR_OUTOFRANGE            : Result := 'Specified value is out of range.';
    D3DRMERR_PENDING               : Result := 'Data required to supply the requested information has not finished loading.';
    D3DRMERR_REQUESTTOOLARGE       : Result := 'Attempt was made to set a level of detail in a progressive mesh greater than the maximum available.';
    D3DRMERR_REQUESTTOOSMALL       : Result := 'Attempt was made to set the minimum rendering detail of a progressive mesh smaller than the detail in the base mesh (the minimum for rendering).';
    D3DRMERR_TEXTUREFORMATNOTFOUND : Result := 'Texture format could not be found that meets the specified criteria and that the underlying Immediate Mode device supports.';
    D3DRMERR_UNABLETOEXECUTE       : Result := 'Unable to carry out procedure.';
    DDERR_INVALIDOBJECT            : Result := 'Received pointer that was an invalid object.';
    DDERR_INVALIDPARAMS            : Result := 'One or more of the parameters passed to the method are incorrect.';
    DDERR_NOTFOUND                 : Result := 'The requested item was not found.';
    DDERR_NOTINITIALIZED           : Result := 'An attempt was made to call an interface method of an object created by CoCreateInstance before the object was initialized.';
    DDERR_OUTOFMEMORY              : Result := 'DirectDraw does not have enough memory to perform the operation.';
    else                             Result := 'Unrecognized Error';
  end;
end;

function DIErrorString(Value: HResult) : string;
begin
  case Value of
    DI_OK                        : Result := 'The operation completed successfully.';
    S_FALSE                      : Result := '"The operation had no effect." or "The device buffer overflowed and some input was lost." or "The device exists but is not currently attached." or "The change in device properties had no effect."';
//  DI_BUFFEROVERFLOW            : Result := 'The device buffer overflowed and some input was lost. This value is equal to the S_FALSE standard COM return value.';
    DI_DOWNLOADSKIPPED           : Result := 'The parameters of the effect were successfully updated, but the effect could not be downloaded because the associated device was not acquired in exclusive mode.';
    DI_EFFECTRESTARTED           : Result := 'The effect was stopped, the parameters were updated, and the effect was restarted.';
//  DI_NOEFFECT                  : Result := 'The operation had no effect. This value is equal to the S_FALSE standard COM return value.';
//  DI_NOTATTACHED               : Result := 'The device exists but is not currently attached. This value is equal to the S_FALSE standard COM return value.';
    DI_POLLEDDEVICE              : Result := 'The device is a polled device. As a result, device buffering will not collect any data and event notifications will not be signaled until the IDirectInputDevice2::Poll method is called.';
//  DI_PROPNOEFFECT              : Result := 'The change in device properties had no effect. This value is equal to the S_FALSE standard COM return value.';
    DI_TRUNCATED                 : Result := 'The parameters of the effect were successfully updated, but some of them were beyond the capabilities of the device and were truncated to the nearest supported value.';
    DI_TRUNCATEDANDRESTARTED     : Result := 'Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.';
    DIERR_ACQUIRED               : Result := 'The operation cannot be performed while the device is acquired.';
    DIERR_ALREADYINITIALIZED     : Result := 'This object is already initialized';
    DIERR_BADDRIVERVER           : Result := 'The object could not be created due to an incompatible driver version or mismatched or incomplete driver components.';
    DIERR_BETADIRECTINPUTVERSION : Result := 'The application was written for an unsupported prerelease version of DirectInput.';
    DIERR_DEVICEFULL             : Result := 'The device is full.';
    DIERR_DEVICENOTREG           : Result := 'The device or device instance is not registered with DirectInput. This value is equal to the REGDB_E_CLASSNOTREG standard COM return value.';
    DIERR_EFFECTPLAYING          : Result := 'The parameters were updated in memory but were not downloaded to the device because the device does not support updating an effect while it is still playing.';
    DIERR_HASEFFECTS             : Result := 'The device cannot be reinitialized because there are still effects attached to it.';
    DIERR_GENERIC                : Result := 'An undetermined error occurred inside the DirectInput subsystem. This value is equal to the E_FAIL standard COM return value.';
//  DIERR_HANDLEEXISTS           : Result := 'The device already has an event notification associated with it. This value is equal to the E_ACCESSDENIED standard COM return value.';
    DIERR_INCOMPLETEEFFECT       : Result := 'The effect could not be downloaded because essential information is missing. For example, no axes have been associated with the effect, or no type-specific information has been supplied.';
    DIERR_INPUTLOST              : Result := 'Access to the input device has been lost. It must be reacquired.';
    DIERR_INVALIDPARAM           : Result := 'An invalid parameter was passed to the returning function, or the object was not in a state that permitted the function to be called. This value is equal to the E_INVALIDARG standard COM return value.';
    DIERR_MOREDATA               : Result := 'Not all the requested information fitted into the buffer.';
    DIERR_NOAGGREGATION          : Result := 'This object does not support aggregation.';
    DIERR_NOINTERFACE            : Result := 'The specified interface is not supported by the object. This value is equal to the E_NOINTERFACE standard COM return value.';
    DIERR_NOTACQUIRED            : Result := 'The operation cannot be performed unless the device is acquired.';
    DIERR_NOTBUFFERED            : Result := 'The device is not buffered. Set the DIPROP_BUFFERSIZE property to enable buffering.';
    DIERR_NOTDOWNLOADED          : Result := 'The effect is not downloaded.';
    DIERR_NOTEXCLUSIVEACQUIRED   : Result := 'The operation cannot be performed unless the device is acquired in DISCL_EXCLUSIVE mode.';
    DIERR_NOTFOUND               : Result := 'The requested object does not exist.';
    DIERR_NOTINITIALIZED         : Result := 'This object has not been initialized.';
//  DIERR_OBJECTNOTFOUND         : Result := 'The requested object does not exist.';
    DIERR_OLDDIRECTINPUTVERSION  : Result := 'The application requires a newer version of DirectInput.';
    DIERR_OTHERAPPHASPRIO        : Result := '"The device already has an event notification associated with it." or "The specified property cannot be changed." or "Another application has a higher priority level, preventing this call from succeeding. "';
    DIERR_OUTOFMEMORY            : Result := 'The DirectInput subsystem could not allocate sufficient memory to complete the call. This value is equal to the E_OUTOFMEMORY standard COM return value.';
//  DIERR_READONLY               : Result := 'The specified property cannot be changed. This value is equal to the E_ACCESSDENIED standard COM return value.';
    DIERR_UNSUPPORTED            : Result := 'The function called is not supported at this time. This value is equal to the E_NOTIMPL standard COM return value.';
    E_PENDING                    : Result := 'Data is not yet available.';
    else                           Result := 'Unrecognized Error';
  end;
end;

function DPErrorString(Value: HResult) : string;
begin
  case Value of
    CLASS_E_NOAGGREGATION         : Result := 'A non-NIL value was passed for the pUnkOuter parameter in DirectPlayCreate, DirectPlayLobbyCreate, or IDirectPlayLobby2::Connect.';
    DPERR_ACCESSDENIED            : Result := 'The session is full or an incorrect password was supplied.';
    DPERR_ACTIVEPLAYERS           : Result := 'The requested operation cannot be performed because there are existing active players.';
    DPERR_ALREADYINITIALIZED      : Result := 'This object is already initialized.';
    DPERR_APPNOTSTARTED           : Result := 'The application has not been started yet.';
    DPERR_AUTHENTICATIONFAILED    : Result := 'The password or credentials supplied could not be authenticated.';
    DPERR_BUFFERTOOLARGE          : Result := 'The data buffer is too large to store.';
    DPERR_BUSY                    : Result := 'A message cannot be sent because the transmission medium is busy.';
    DPERR_BUFFERTOOSMALL          : Result := 'The supplied buffer is not large enough to contain the requested data.';
    DPERR_CANTADDPLAYER           : Result := 'The player cannot be added to the session.';
    DPERR_CANTCREATEGROUP         : Result := 'A new group cannot be created.';
    DPERR_CANTCREATEPLAYER        : Result := 'A new player cannot be created.';
    DPERR_CANTCREATEPROCESS       : Result := 'Cannot start the application.';
    DPERR_CANTCREATESESSION       : Result := 'A new session cannot be created.';
    DPERR_CANTLOADCAPI            : Result := 'No credentials were supplied and the CryptoAPI package (CAPI) to use for cryptography services cannot be loaded.';
    DPERR_CANTLOADSECURITYPACKAGE : Result := 'The software security package cannot be loaded.';
    DPERR_CANTLOADSSPI            : Result := 'No credentials were supplied and the software security package (SSPI) that will prompt for credentials cannot be loaded.';
    DPERR_CAPSNOTAVAILABLEYET     : Result := 'The capabilities of the DirectPlay object have not been determined yet. This error will occur if the DirectPlay object is implemented on a connectivity solution that requires polling to determine available bandwidth and latency.';
    DPERR_CONNECTING              : Result := 'The method is in the process of connecting to the network. The application should keep calling the method until it returns DP_OK, indicating successful completion, or it returns a different error.';
    DPERR_ENCRYPTIONFAILED        : Result := 'The requested information could not be digitally encrypted. Encryption is used for message privacy. This error is only relevant in a secure session.';
    DPERR_EXCEPTION               : Result := 'An exception occurred when processing the request.';
    DPERR_GENERIC                 : Result := 'An undefined error condition occurred.';
//  DPERR_INVALIDCREDENTIALS      : Result := 'The credentials supplied (as to IDirectPlay3::SecureOpen) were not valid.';
    DPERR_INVALIDFLAGS            : Result := 'The flags passed to this method are invalid.';
    DPERR_INVALIDGROUP            : Result := 'The group ID is not recognized as a valid group ID for this game session.';
    DPERR_INVALIDINTERFACE        : Result := 'The interface parameter is invalid.';
    DPERR_INVALIDOBJECT           : Result := 'The DirectPlay object pointer is invalid.';
    DPERR_INVALIDPARAMS           : Result := 'One or more of the parameters passed to the method are invalid.';
    DPERR_INVALIDPASSWORD         : Result := 'An invalid password was supplied when attempting to join a session that requires a password.';
    DPERR_INVALIDPLAYER           : Result := 'The player ID is not recognized as a valid player ID for this game session.';
    DPERR_LOGONDENIED             : Result := 'The session could not be opened because credentials are required and either no credentials were supplied or the credentials were invalid.';
    DPERR_NOCAPS                  : Result := 'The communication link that DirectPlay is attempting to use is not capable of this function.';
    DPERR_NOCONNECTION            : Result := 'No communication link was established.';
    DPERR_NOINTERFACE             : Result := 'The interface is not supported.';
    DPERR_NOMESSAGES              : Result := 'There are no messages in the receive queue.';
    DPERR_NONAMESERVERFOUND       : Result := 'No name server (host) could be found or created. A host must exist to create a player.';
    DPERR_NONEWPLAYERS            : Result := 'The session is not accepting any new players.';
    DPERR_NOPLAYERS               : Result := 'There are no active players in the session.';
    DPERR_NOSESSIONS              : Result := 'There are no existing sessions for this game.';
    DPERR_NOTLOBBIED              : Result := 'Returned by the IDirectPlayLobby2::Connect method if the application was not started by using the IDirectPlayLobby2::RunApplication method or if there is no DPLCONNECTION structure currently initialized for this DirectPlayLobby object.';
    DPERR_NOTLOGGEDIN             : Result := 'An action cannot be performed because a player or client application is not logged in. Returned by the IDirectPlay3::Send method when the client application tries to send a secure message without being logged in.';
    DPERR_OUTOFMEMORY             : Result := 'There is insufficient memory to perform the requested operation.';
    DPERR_PLAYERLOST              : Result := 'A player has lost the connection to the session.';
    DPERR_SENDTOOBIG              : Result := 'The message being sent by the IDirectPlay3::Send method is too large.';
    DPERR_SESSIONLOST             : Result := 'The connection to the session has been lost.';
    DPERR_SIGNFAILED              : Result := 'The requested information could not be digitally signed. Digital signatures are used to establish the authenticity of messages.';
    DPERR_TIMEOUT                 : Result := 'The operation could not be completed in the specified time.';
    DPERR_UNAVAILABLE             : Result := 'The requested function is not available at this time.';
    DPERR_UNINITIALIZED           : Result := 'The requested object has not been initialized.';
    DPERR_UNKNOWNAPPLICATION      : Result := 'An unknown application was specified.';
    DPERR_UNSUPPORTED             : Result := 'The function is not available in this implementation. Returned from IDirectPlay3::GetGroupConnectionSettings and IDirectPlay3::SetGroupConnectionSettings if they are called from a session that is not a lobby session.';
    DPERR_USERCANCEL              : Result := 'Can be returned in two ways. 1) The user canceled the connection process during a call to the IDirectPlay3::Open method. 2) The user clicked Cancel in one of the DirectPlay service provider dialog boxes during a call to IDirectPlay3::EnumSessions.';
    else                            Result := 'Unrecognized Error';
  end;
end;

function DSErrorString(Value: HResult) : string;
begin
  case Value of
    DS_OK                    : Result := 'The request completed successfully.';
    DSERR_ALLOCATED          : Result := 'The request failed because resources, such as a priority level, were already in use by another caller.';
    DSERR_ALREADYINITIALIZED : Result := 'The object is already initialized.';
    DSERR_BADFORMAT          : Result := 'The specified wave format is not supported.';
    DSERR_BUFFERLOST         : Result := 'The buffer memory has been lost and must be restored.';
    DSERR_CONTROLUNAVAIL     : Result := 'The control (volume, pan, and so forth) requested by the caller is not available.';
    DSERR_GENERIC            : Result := 'An undetermined error occurred inside the DirectSound subsystem.';
    DSERR_INVALIDCALL        : Result := 'This function is not valid for the current state of this object.';
    DSERR_INVALIDPARAM       : Result := 'An invalid parameter was passed to the returning function.';
    DSERR_NOAGGREGATION      : Result := 'The object does not support aggregation.';
    DSERR_NODRIVER           : Result := 'No sound driver is available for use.';
    DSERR_NOINTERFACE        : Result := 'The requested COM interface is not available.';
    DSERR_OTHERAPPHASPRIO    : Result := 'Another application has a higher priority level, preventing this call from succeeding.';
    DSERR_OUTOFMEMORY        : Result := 'The DirectSound subsystem could not allocate sufficient memory to complete the caller´s request.';
    DSERR_PRIOLEVELNEEDED    : Result := 'The caller does not have the priority level required for the function to succeed.';
    DSERR_UNINITIALIZED      : Result := 'The IDirectSound::Initialize method has not been called or has not been called successfully before other methods were called.';
    DSERR_UNSUPPORTED        : Result := 'The function called is not supported at this time.';
    else                       Result := 'Unrecognized Error';
  end;
end;

function DFErrorString(Value: HResult) : string;
begin
  case Value of
    DXFILE_OK                  : Result := 'Command completed successfully. Equivalent to DD_OK.';
    DXFILEERR_BADVALUE         : Result := 'Parameter is invalid.';
    DXFILEERR_BADTYPE          : Result := 'Object type is invalid.';
    DXFILEERR_BADALLOC         : Result := 'Memory allocation failed.';
    DXFILEERR_NOTFOUND         : Result := 'Object could not be found.';
    DXFILEERR_FILENOTFOUND     : Result := 'File could not be found.';
    DXFILEERR_RESOURCENOTFOUND : Result := 'Resource could not be found.';
    DXFILEERR_URLNOTFOUND      : Result := 'URL could not be found.';
    DXFILEERR_BADRESOURCE      : Result := 'Resource is invalid.';
    DXFILEERR_BADFILETYPE      : Result := 'File is not a DirectX file.';
    DXFILEERR_BADFILEVERSION   : Result := 'File version is not valid.';
    DXFILEERR_BADFILEFLOATSIZE : Result := 'Floating-point size is invalid.';
    DXFILEERR_BADFILE          : Result := 'File is invalid.';
    DXFILEERR_PARSEERROR       : Result := 'File could not be parsed.';
    DXFILEERR_BADARRAYSIZE     : Result := 'Array size is invalid.';
    DXFILEERR_BADDATAREFERENCE : Result := 'Data reference is invalid.';
    DXFILEERR_NOMOREOBJECTS    : Result := 'All objects have been enumerated.';
    DXFILEERR_NOMOREDATA       : Result := 'No further data is available.';
    else                         Result := 'Unrecognized Error';
  end;
end;

(******************************************************************************)
(**                                                                          **)
(** D3D.Pas                                                                  **)
(**                                                                          **)
(******************************************************************************)

procedure DisableFPUExceptions;
var
  FPUControlWord: WORD;
asm
  FSTCW   FPUControlWord;
  OR      FPUControlWord, $4 + $1; { Divide by zero + invalid operation }
  FLDCW   FPUControlWord;
end;

procedure EnableFPUExceptions;
var
  FPUControlWord: WORD;
asm
  FSTCW   FPUControlWord;
  AND     FPUControlWord, $FFFF - $4 - $1; { Divide by zero + invalid operation }
  FLDCW   FPUControlWord;
end;

(******************************************************************************)
(**                                                                          **)
(** D3DCaps.Pas                                                              **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** D3DTypes.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

function D3DVal(val: variant) : float;
begin
  Result := val;
end;

function D3DDivide(a,b: double) : float;
begin
  Result := a / b;
end;

function D3DMultiply(a,b: double) : float;
begin
  Result := a * b;
end;

// #define CI_GETALPHA(ci)    ((ci) >> 24)
function CI_GETALPHA(ci: DWORD) : DWORD;
begin
  Result := ci shr 24;
end;

// #define CI_GETINDEX(ci)    (((ci) >> 8) & 0xffff)
function CI_GETINDEX(ci: DWORD) : DWORD;
begin
  Result := (ci shr 8) and $ffff;
end;

// #define CI_GETFRACTION(ci) ((ci) & 0xff)
function CI_GETFRACTION(ci: DWORD) : DWORD;
begin
  Result := ci and $ff;
end;

// #define CI_ROUNDINDEX(ci)  CI_GETINDEX((ci) + 0x80)
function CI_ROUNDINDEX(ci: DWORD) : DWORD;
begin
  Result := CI_GETINDEX(ci + $80);
end;

// #define CI_MASKALPHA(ci)   ((ci) & 0xffffff)
function CI_MASKALPHA(ci: DWORD) : DWORD;
begin
  Result := ci and $ffffff;
end;

// #define CI_MAKE(a, i, f)    (((a) << 24) | ((i) << 8) | (f))
function CI_MAKE(a,i,f: DWORD) : DWORD;
begin
  Result := (a shl 24) or (i shl 8) or f;
end;

// #define RGBA_GETALPHA(rgb)      ((rgb) >> 24)
function RGBA_GETALPHA(rgb: TD3DColor) : DWORD;
begin
  Result := rgb shr 24;
end;

// #define RGBA_GETRED(rgb)        (((rgb) >> 16) & 0xff)
function RGBA_GETRED(rgb: TD3DColor) : DWORD;
begin
  Result := (rgb shr 16) and $ff;
end;

// #define RGBA_GETGREEN(rgb)      (((rgb) >> 8) & 0xff)
function RGBA_GETGREEN(rgb: TD3DColor) : DWORD;
begin
  Result := (rgb shr 8) and $ff;
end;

// #define RGBA_GETBLUE(rgb)       ((rgb) & 0xff)
function RGBA_GETBLUE(rgb: TD3DColor) : DWORD;
begin
  Result := rgb and $ff;
end;

// #define RGBA_MAKE(r, g, b, a)   ((TD3DColor) (((a) << 24) | ((r) << 16) | ((g) << 8) | (b)))
function RGBA_MAKE(r, g, b, a: DWORD) : TD3DColor;
begin
  Result := (a shl 24) or (r shl 16) or (g shl 8) or b;
end;

// #define D3DRGB(r, g, b) \
//     (0xff000000L | (((long)((r) * 255)) << 16) | (((long)((g) * 255)) << 8) | (long)((b) * 255))
function D3DRGB(r, g, b: float) : TD3DColor;
begin
  Result := $ff000000 or (round(r * 255) shl 16)
                      or (round(g * 255) shl 8)
                      or round(b * 255);
end;

// #define D3DRGBA(r, g, b, a) \
//     (  (((long)((a) * 255)) << 24) | (((long)((r) * 255)) << 16) \
//     |   (((long)((g) * 255)) << 8) | (long)((b) * 255) \
//    )
function D3DRGBA(r, g, b, a: float) : TD3DColor;
begin
  Result := (round(a * 255) shl 24) or (round(r * 255) shl 16)
                                    or (round(g * 255) shl 8)
                                    or round(b * 255);
end;

// #define RGB_GETRED(rgb)         (((rgb) >> 16) & 0xff)
function RGB_GETRED(rgb: TD3DColor) : DWORD;
begin
  Result := (rgb shr 16) and $ff;
end;

// #define RGB_GETGREEN(rgb)       (((rgb) >> 8) & 0xff)
function RGB_GETGREEN(rgb: TD3DColor) : DWORD;
begin
  Result := (rgb shr 8) and $ff;
end;

// #define RGB_GETBLUE(rgb)        ((rgb) & 0xff)
function RGB_GETBLUE(rgb: TD3DColor) : DWORD;
begin
  Result := rgb and $ff;
end;

// #define RGBA_SETALPHA(rgba, x) (((x) << 24) | ((rgba) & 0x00ffffff))
function RGBA_SETALPHA(rgba: TD3DColor; x: DWORD) : TD3DColor;
begin
  Result := (x shl 24) or (rgba and $00ffffff);
end;

// #define RGB_MAKE(r, g, b)       ((TD3DColor) (((r) << 16) | ((g) << 8) | (b)))
function RGB_MAKE(r, g, b: DWORD) : TD3DColor;
begin
  Result := (r shl 16) or (g shl 8) or b;
end;

// #define RGBA_TORGB(rgba)       ((TD3DColor) ((rgba) & 0xffffff))
function RGBA_TORGB(rgba: TD3DColor) : TD3DColor;
begin
  Result := rgba and $00ffffff;
end;

// #define RGB_TORGBA(rgb)        ((TD3DColor) ((rgb) | 0xff000000))
function RGB_TORGBA(rgb: TD3DColor) : TD3DColor;
begin
  Result := rgb or $ff000000;
end;


function D3DSTATE_OVERRIDE(StateType: DWORD) : DWORD;
begin
  Result := StateType + D3DSTATE_OVERRIDE_BIAS;
end;

function D3DTRIFLAG_STARTFLAT(len: DWORD) : DWORD;
begin
  if not (len in [1..29]) then len := 0;
  result := len;
end;

// #define D3DRENDERSTATE_STIPPLEPATTERN(y) (D3DRENDERSTATE_STIPPLEPATTERN00 + (y))
function D3DRENDERSTATE_STIPPLEPATTERN(y: integer) : TD3DRenderStateType;
begin
  Result := TD3DRenderStateType(Ord(D3DRENDERSTATE_STIPPLEPATTERN00) + y);
end;

// Addition and subtraction
function VectorAdd(const v1, v2: TD3DVector) : TD3DVector;
begin
  result.x := v1.x+v2.x;
  result.y := v1.y+v2.y;
  result.z := v1.z+v2.z;
end;

function VectorSub(const v1, v2: TD3DVector) : TD3DVector;
begin
  result.x := v1.x-v2.x;
  result.y := v1.y-v2.y;
  result.z := v1.z-v2.z;
end;

    // Scalar multiplication and division
function VectorMulS(const v: TD3DVector; s: TD3DValue) : TD3DVector;
begin
  result.x := v.x*s;
  result.y := v.y*s;
  result.z := v.z*s;
end;

function VectorDivS(const v: TD3DVector; s: TD3DValue) : TD3DVector;
begin
  result.x := v.x/s;
  result.y := v.y/s;
  result.z := v.z/s;
end;

    // Memberwise multiplication and division
function VectorMul(const v1, v2: TD3DVector) : TD3DVector;
begin
  result.x := v1.x*v2.x;
  result.y := v1.y*v2.y;
  result.z := v1.z*v2.z;
end;

function VectorDiv(const v1, v2: TD3DVector) : TD3DVector;
begin
  result.x := v1.x/v2.x;
  result.y := v1.y/v2.y;
  result.z := v1.z/v2.z;
end;

    // Vector dominance
function VectorSmaller(v1, v2: TD3DVector) : boolean;
begin
  result := (v1.x < v2.x) and (v1.y < v2.y) and (v1.z < v2.z);
end;

function VectorSmallerEquel(v1, v2: TD3DVector) : boolean;
begin
  result := (v1.x <= v2.x) and (v1.y <= v2.y) and (v1.z <= v2.z);
end;

    // Bitwise equality
function VectorEquel(v1, v2: TD3DVector) : boolean;
begin
  result := (v1.x = v2.x) and (v1.y = v2.y) and (v1.z = v2.z);
end;

    // Length-related functions
function VectorSquareMagnitude(v: TD3DVector) : TD3DValue;
begin
  result := (v.x*v.x) + (v.y*v.y) + (v.z*v.z);
end;

function VectorMagnitude(v: TD3DVector) : TD3DValue;
begin
  result := sqrt((v.x*v.x) + (v.y*v.y) + (v.z*v.z));
end;

    // Returns vector with same direction and unit length
function VectorNormalize(const v: TD3DVector) : TD3DVector;
begin
  result := VectorDivS(v,VectorMagnitude(v));
end;

    // Return min/max component of the input vector
function VectorMin(v: TD3DVector) : TD3DValue;
var
  ret : TD3DValue;
begin
  ret := v.x;
  if (v.y < ret) then ret := v.y;
  if (v.z < ret) then ret := v.z;
  result := ret;
end;

function VectorMax(v: TD3DVector) : TD3DValue;
var
  ret : TD3DValue;
begin
  ret := v.x;
  if (ret < v.y) then ret := v.y;
  if (ret < v.z) then ret := v.z;
  result := ret;
end;

    // Return memberwise min/max of input vectors
function VectorMinimize(const v1, v2: TD3DVector) : TD3DVector;
begin
  if v1.x < v2.x then result.x := v1.x else result.x := v2.x;
  if v1.y < v2.y then result.y := v1.y else result.y := v2.y;
  if v1.z < v2.z then result.z := v1.z else result.z := v2.z;
end;

function VectorMaximize(const v1, v2: TD3DVector) : TD3DVector;
begin
  if v1.x > v2.x then result.x := v1.x else result.x := v2.x;
  if v1.y > v2.y then result.y := v1.y else result.y := v2.y;
  if v1.z > v2.z then result.z := v1.z else result.z := v2.z;
end;

    // Dot and cross product
function VectorDotProduct(v1, v2: TD3DVector) : TD3DValue;
begin
  result := (v1.x*v2.x) + (v1.y * v2.y) + (v1.z*v2.z);
end;

function VectorCrossProduct(const v1, v2: TD3DVector) : TD3DVector;
begin
  result.x := (v1.y*v2.z) - (v1.z*v2.y);
  result.y := (v1.z*v2.x) - (v1.x*v2.z);
  result.z := (v1.x*v2.y) - (v1.y*v2.x);
end;

(******************************************************************************)
(**                                                                          **)
(** D3DRM.Pas                                                                **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** D3DRMDef.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

procedure D3DRMAnimationGetRotateKey(var rmKey: TD3DRMAnimationKey; var rmQuat: TD3DRMQuaternion);
begin
  rmQuat := rmKey.dqRotateKey;
end;

procedure D3DRMAnimationGetScaleKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);
begin
  dvVec := rmKey.dvScaleKey;
end;

procedure D3DRMAnimationGetPositionKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);
begin
  dvVec := rmKey.dvPositionKey;
end;

procedure D3DRMAnimatioSetRotateKey(var rmKey: TD3DRMAnimationKey; var rmQuat: TD3DRMQuaternion);
begin
  rmKey.dqRotateKey := rmQuat;
end;

procedure D3DRMAnimationSetScaleKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);
begin
  rmKey.dvScaleKey := dvVec;
end;

procedure D3DRMAnimationSetPositionKey(var rmKey: TD3DRMAnimationKey; var dvVec: TD3DVector);
begin
  rmKey.dvPositionKey := dvVec;
end;

(******************************************************************************)
(**                                                                          **)
(** D3DRMObj.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** D3DRMWin.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** DDraw.Pas                                                                **)
(**                                                                          **)
(******************************************************************************)

function MAKEFOURCC(ch0, ch1, ch2, ch3: Char) : DWORD;
begin
  Result := DWORD(byte(ch0) shl 0) or
            DWORD(byte(ch1) shl 8) or
            DWORD(byte(ch2) shl 16) or
            DWORD(byte(ch3) shl 24);
end;

(******************************************************************************)
(**                                                                          **)
(** DInput.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

function DIEFT_GETTYPE(n: variant) : byte;
begin
  Result := byte(n);
end;

function GET_DIDEVICE_TYPE(dwDevType: variant) : byte;
begin
  Result := byte(dwDevType);
end;

function GET_DIDEVICE_SUBTYPE(dwDevType: variant) : byte;
begin
  Result := hi(word(dwDevType));
end;

function DIDFT_MAKEINSTANCE(n: variant) : DWORD;
begin
  Result := word(n) shl 8;
end;

function DIDFT_GETTYPE(n: variant) : byte;
begin
  Result := byte(n);
end;

function DIDFT_GETINSTANCE(n: variant) : DWORD;
begin
  Result := word(n) shr 8;
end;

function DIDFT_ENUMCOLLECTION(n: variant) : DWORD;
begin
  Result := word(n) shl 8;
end;

function DIJOFS_SLIDER(n: variant) : variant;
begin
  Result := n * 4 + 24;
end;

function DIJOFS_POV(n: variant) : variant;
begin
  Result := n * 4 + 32;
end;

function DIJOFS_BUTTON(n: variant) : variant;
begin
  Result := 48 + n;
end;

function joyConfigChanged(dwFlags: DWORD) : MMRESULT; external 'WinMM.dll';

(******************************************************************************)
(**                                                                          **)
(** DPlay.Pas                                                                **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** DPLobby.Pas                                                              **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** DSound.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

function MAKE_DSHResult(code: DWORD) : HResult; 
begin
  Result := HResult(1 shl 31) or HResult(_FACDS shl 16)
      or HResult(code);
end;

function DSSPEAKER_COMBINED(c, g: variant) : DWORD;
begin
  Result := byte(c) or (byte(g) shl 16)
end;

function DSSPEAKER_CONFIG(a: variant) : byte;
begin
  Result := byte(a);
end;

function DSSPEAKER_GEOMETRY(a: variant) : byte;
begin
  Result := byte(a shr 16 and $FF);
end;

(******************************************************************************)
(**                                                                          **)
(** DSetup.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** DVP.Pas                                                                  **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** DXFile.Pas                                                               **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** RMXFGUID.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** RMXFTmpl.Pas                                                             **)
(**                                                                          **)
(******************************************************************************)

(******************************************************************************)
(**                                                                          **)
(** Library Loading                                                          **)
(**                                                                          **)
(******************************************************************************)

Procedure LoadD3DRMDLL;
Begin
    D3DRMDLL := GLoadLibrary('D3DRM.dll');
    Direct3DRMCreate := GetProcAddress(D3DRMDLL,'Direct3DRMCreate');
    D3DRMCreateColorRGB := GetProcAddress(D3DRMDLL,'D3DRMCreateColorRGB');
    D3DRMCreateColorRGBA := GetProcAddress(D3DRMDLL,'D3DRMCreateColorRGBA');
    D3DRMColorGetRed := GetProcAddress(D3DRMDLL,'D3DRMColorGetRed');
    D3DRMColorGetGreen := GetProcAddress(D3DRMDLL,'D3DRMColorGetGreen');
    D3DRMColorGetBlue := GetProcAddress(D3DRMDLL,'D3DRMColorGetBlue');
    D3DRMColorGetAlpha := GetProcAddress(D3DRMDLL,'D3DRMColorGetAlpha');
    D3DRMVectorAdd := GetProcAddress(D3DRMDLL,'D3DRMVectorAdd');
    D3DRMVectorSubtract := GetProcAddress(D3DRMDLL,'D3DRMVectorSubtract');
    D3DRMVectorReflect := GetProcAddress(D3DRMDLL,'D3DRMVectorReflect');
    D3DRMVectorCrossProduct := GetProcAddress(D3DRMDLL,'D3DRMVectorCrossProduct');
    D3DRMVectorDotProduct := GetProcAddress(D3DRMDLL,'D3DRMVectorDotProduct');
    D3DRMVectorNormalize := GetProcAddress(D3DRMDLL,'D3DRMVectorNormalize');
    D3DRMVectorModulus := GetProcAddress(D3DRMDLL,'D3DRMVectorModulus');
    D3DRMVectorRotate := GetProcAddress(D3DRMDLL,'D3DRMVectorRotate');
    D3DRMVectorScale := GetProcAddress(D3DRMDLL,'D3DRMVectorScale');
    D3DRMVectorRandom := GetProcAddress(D3DRMDLL,'D3DRMVectorRandom');
    D3DRMQuaternionFromRotation := GetProcAddress(D3DRMDLL,'D3DRMQuaternionFromRotation');
    D3DRMQuaternionMultiply := GetProcAddress(D3DRMDLL,'D3DRMQuaternionMultiply');
    D3DRMQuaternionSlerp := GetProcAddress(D3DRMDLL,'D3DRMQuaternionSlerp');
    D3DRMMatrixFromQuaternion := GetProcAddress(D3DRMDLL,'D3DRMMatrixFromQuaternion');
    D3DRMQuaternionFromMatrix := GetProcAddress(D3DRMDLL,'D3DRMQuaternionFromMatrix');
End;

Procedure LoadDDrawDLL;
Begin
    DDrawDLL := GLoadLibrary('DDraw.dll');
    DirectDrawEnumerateA := GetProcAddress(DDrawDLL,'DirectDrawEnumerateA');
    DirectDrawEnumerateW := GetProcAddress(DDrawDLL,'DirectDrawEnumerateW');
{$IFDEF UNICODE}
    DirectDrawEnumerate := DirectDrawEnumerateW;
{$ELSE}
    DirectDrawEnumerate := DirectDrawEnumerateA;
{$ENDIF}

    DirectDrawEnumerateExA := GetProcAddress(DDrawDLL,'DirectDrawEnumerateExA');
    DirectDrawEnumerateExW := GetProcAddress(DDrawDLL,'DirectDrawEnumerateExW');
{$IFDEF UNICODE}
    DirectDrawEnumerateEx := DirectDrawEnumerateExW;
{$ELSE}
    DirectDrawEnumerateEx := DirectDrawEnumerateExA;
{$ENDIF}
    DirectDrawCreate := GetProcAddress(DDrawDLL,'DirectDrawCreate');
    DirectDrawCreateClipper := GetProcAddress(DDrawDLL,'DirectDrawCreateClipper');
{$IFDEF WINNT}
    NtDirectDrawCreate := GetProcAddress(DDrawDLL,'NtDirectDrawCreate');
{$ENDIF}
End;

Procedure LoadDInputDLL;
Begin
    DInputDLL := GLoadLibrary('DInput.dll');

    DirectInputCreateA := GetProcAddress(DInputDLL,'DirectInputCreateA');
    DirectInputCreateW := GetProcAddress(DInputDLL,'DirectInputCreateW');
{$IFDEF UNICODE}
    DirectInputCreate := DirectInputCreateW;
{$ELSE}
    DirectInputCreate := DirectInputCreateA;
{$ENDIF}
End;

Procedure LoadDPlayDLL;
Begin
  DPlayDLL := GLoadLibrary('DPlayX.dll');

  DirectPlayEnumerateA := GetProcAddress(DPlayDLL,'DirectPlayEnumerateA');
  DirectPlayEnumerateW := GetProcAddress(DPlayDLL,'DirectPlayEnumerateW');
{$IFDEF UNICODE}
  DirectPlayEnumerate := DirectPlayEnumerateW;
{$ELSE}
  DirectPlayEnumerate := DirectPlayEnumerateA;
{$ENDIF}

  DirectPlayCreate := GetProcAddress(DPlayDLL,'DirectPlayCreate');
  DirectPlayLobbyCreateW := GetProcAddress(DPlayDLL,'DirectPlayLobbyCreateW');
  DirectPlayLobbyCreateA := GetProcAddress(DPlayDLL,'DirectPlayLobbyCreateA');
{$IFDEF UNICODE}
  DirectPlayLobbyCreate := DirectPlayLobbyCreateW;
{$ELSE}
  DirectPlayLobbyCreate := DirectPlayLobbyCreateA;
{$ENDIF}
End;

Procedure LoadDSoundDLL;
Begin
  DSoundDLL := GLoadLibrary('DSound.dll');
  DirectSoundCreate := GetProcAddress(DSoundDLL,'DirectSoundCreate');

  DirectSoundEnumerateW := GetProcAddress(DSoundDLL,'DirectSoundEnumerateW');
  DirectSoundEnumerateA := GetProcAddress(DSoundDLL,'DirectSoundEnumerateA');
{$IFDEF UNICODE}
  DirectSoundEnumerate := DirectSoundEnumerateW;
{$ELSE}
  DirectSoundEnumerate := DirectSoundEnumerateA;
{$ENDIF}

  DirectSoundCaptureCreate := GetProcAddress(DSoundDLL,'DirectSoundCaptureCreate');

  DirectSoundCaptureEnumerateW := GetProcAddress(DSoundDLL,'DirectSoundCaptureEnumerateW');
  DirectSoundCaptureEnumerateA := GetProcAddress(DSoundDLL,'DirectSoundCaptureEnumerateA');
{$IFDEF UNICODE}
  DirectSoundCaptureEnumerate := DirectSoundCaptureEnumerateW;
{$ELSE}
  DirectSoundCaptureEnumerate := DirectSoundCaptureEnumerateA;
{$ENDIF}
End;

Procedure LoadDXFileDLL;
Begin
DXFileDLL := GLoadLibrary('D3DXOF.DLL');
DirectXFileCreate := GetProcAddress(DXFileDLL,'DirectXFileCreate');
End;

Initialization
Begin
If Not IsNTandDelphiRunning Then
Begin
  LoadD3DRMDLL;
  LoadDDrawDLL;
  LoadDInputDLL;
  LoadDPlayDLL;
  LoadDSoundDLL;
  LoadDXFileDLL;
End;
DisableFPUExceptions;
End;

Finalization
Begin
  FreeLibrary(DDrawDLL);
  FreeLibrary(D3DRMDLL);
  FreeLibrary(DPlayDLL);
  FreeLibrary(DInputDLL);
  FreeLibrary(DSoundDLL);
  FreeLibrary(DXFileDLL);
End;

end.
