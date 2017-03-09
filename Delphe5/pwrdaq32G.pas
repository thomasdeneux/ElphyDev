unit pwrdaq32G;

//===========================================================================
//
// NAME:    pwrdaq32.h
//
// DESCRIPTION:
//
//          PowerDAQ Win32 DLL header file
//
//          Definitions for PowerDAQ DLL driver interface functions.
//
//
// DATE:    5-MAY-97
//
// REV:     0.6
//
// R DATE:  22-DEC-99
//
// HISTORY:
//
//      Rev 0.1,     5-MAY-97,  A.S.,   Initial version.
//      Rev 0.2,     5-JAN-98,  B.S.,   Revised to final PD Firmware.
//      Rev 0.3,     8-FEB-98,  A.S.,   Added overlapped I/O.
//      Rev 0.4,    01-JUN-98,  B.S.,   Updated to revised firmware.
//      Rev 0.5,     7-MAY-99,  A.I.,   PD DIO support added
//      Rev 0.51,   21-JUL-99,  A.I.,   SSH gain control added
//      Rev 0.52,   13-SEP-99,  A.I.,   AO board added
//      Rev 0.53    06-DEC-99,  A.I.,   Separate private events into subsystems
//      Rev 0.6     22-DEC-99,  A.I.,   Capabilities functions added
//      Rev 2.2     30-MAR-01,  A.I.,   A lot of new commands added
//      Rev 3.0,    29-JUN-2000,A.I.,   Async ops are rewritten
//      Rev 3.01,   21-JAN-2002,d.k.,   Sync header files C++, VB, Delphi
//
//---------------------------------------------------------------------------
//
//      Copyright (C) 1997-2002 United Electronic Industries, Inc.
//      All rights reserved.
//      United Electronic Industries Confidential Information.
//
//===========================================================================


//#include "pd_tmock.h"               //*** TO FOOL INTO USING MAPDSP.SYS ***

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  windows, pwrdaqG, debug0;

const
  DLLName = 'pwrdaq32.dll';

{$IFNDEF _INC_PWRDAQ32}
{$DEFINE _INC_PWRDAQ32}
{$ALIGN OFF}

//---------------------------------------------------------------------------
//
// Data Structure Definitions.
//

//
// EEPROM data structure
//
//
const
  PD_EEPROM_SIZE = 256;// EEPROM size in 16-bit words
  PD_SERIALNUMBER_SIZE = 10;// serial number length in bytes
  PD_DATE_SIZE = 12;// date string length in bytes
  PD_CAL_AREA_SIZE = 32;// EEPROM calibration area size in 16-bit words
  PD_SST_AREA_SIZE = 96;// Startup-state area size in 16-bit words

  PXI_LINES =  5 ; // total number of available lines

  DIO_REGS_NUM = 8 ;


type
  PWRDAQ_EEPROM_HDR = record
    ADCFifoSize : byte;       // Size of data FIFOs in kS blocks = 1 for standard
    CLFifoSize  : byte;       // Size of Channel list FIFO in 256 channel blocks = 1 for standard
    SerialNumber : array [0..PD_SERIALNUMBER_SIZE-1] of char;
    ManufactureDate : array [0..PD_DATE_SIZE-1] of  char;
    CalibrationDate : array [0..PD_DATE_SIZE-1] of char;
    Revision  : longint;
    FirstUseDate : word;
    CalibrArea : array [0..PD_CAL_AREA_SIZE-1] of word;
    FWModeSelect : word;
    StartupArea : array [0..PD_SST_AREA_SIZE-1] of word;
    PXI_State : array [0..PXI_LINES-1] of word;
    DACFifoSize : byte;      // Size of internal/external memory in kS blocks
  end;
  PPWRDAQ_EEPROM  = ^PWRDAQ_EEPROM;
  PWRDAQ_EEPROM = record
    Header : PWRDAQ_EEPROM_HDR;
    WordValues : array[1..1] of word;
  end;
//
//-----------------------------------------------------------------------
// Data Structure Definitions.
//-----------------------------------------------------------------------
type
  DWORD=Cardinal;
  PPWORD = ^PWORD;
type
  PPWRDAQ_PCI_CONFIG = ^PWRDAQ_PCI_CONFIG;
  PWRDAQ_PCI_CONFIG = record
    VendorID : WORD;
    DeviceID : WORD;
    Command : WORD;
    Status : WORD;
    RevisionID : BYTE;
    CacheLineSize : BYTE;
    LatencyTimer : BYTE;
    BaseAddress0 : DWORD;
    SubsystemVendorID : WORD;
    SubsystemID : WORD;
    InterruptLine : BYTE;
    InterruptPin : BYTE;
    MinimumGrant : BYTE;
    MaximumLatency : BYTE;
  end;
var
  _PWRDAQ_PCI_CONFIG : PWRDAQ_PCI_CONFIG;

//
// Driver version and timestamp, along with some system facts
//
type
  PPWRDAQ_VERSION = ^PWRDAQ_VERSION;
  PWRDAQ_VERSION = record
    SystemSize : DWORD;
    NtServerSystem : BOOL;
    NumberProcessors : ULONG;
    MajorVersion : DWORD;
    MinorVersion : DWORD;
    BuildType : char;
    BuildTimeStamp : array[0..40-1] of    char;
  end;
var
  _PWRDAQ_VERSION : PWRDAQ_VERSION;

type
// Event Callback Function
  PD_EVENT_PROC = procedure(pEvents : PPD_EVENTS); stdcall;
  PPD_EVENT_PROC = ^PD_EVENT_PROC;
  int = smallint;

const
  PD_BRD = 0;
  PD_BRD_BASEID = $101;

const
  MAXRANGES = 8;
  MAXGAINS = 4;
  MAXSS = PD_MAX_SUBSYSTEMS;

// Hardware properties definition --------------------------------------
const
  PDHCAPS_BITS = 1;
  PDHCAPS_FIRSTCHAN = 2;
  PDHCAPS_LASTCHAN = 3;
  PDHCAPS_CHANNELS = 4;

// Capabilities structure and table -------------------------------------
type

  PDAQ_Information = ^DAQ_Information;
  DAQ_Information = record
    iBoardID : WORD;           // board ID
    lpBoardName : LPSTR;       // Name of the specified board
    lpBusType : LPSTR;         // Bus type
    lpDSPRAM : LPSTR;          // Type of DSP and volume of RAM
    lpChannels : LPSTR;        // Number of channels of the all types, main string
    lpTrigCaps : LPSTR;        // AIn triggering capabilities
    lpAInRanges : LPSTR;       // AIn ranges
    lpAInGains : LPSTR;        // AIn gains
    lpTransferTypes : LPSTR;   // Types of suported transfer methods
    iMaxAInRate : DWORD;       // Max AIn rate (pacer clock)
    lpAOutRanges : LPSTR;      // AOut ranges
    iMaxAOutRate : DWORD;      // Max AOut rate (pacer clock)
    lpUCTType : LPSTR;         // Type of used UCT
    iMaxUCTRate : DWORD;       // Max UCT rate
    iMaxDIORate : DWORD;       // Max DIO rate
    wXorMask : WORD;           // Xor mask
    wAndMask : WORD;           // And mask
  end;

var
  DAQ_Info: DAQ_Information;

// information structure ----------------------------------------------------
type

  PSUBSYS_INFO_STRUCT = ^TSUBSYS_INFO_STRUCT;
  TSUBSYS_INFO_STRUCT = record
    dwChannels : DWORD;                          // Number of channels of the subsystem type, main string
    dwChBits : DWORD;                            //*NEW* how wide is the channel
    dwRate : DWORD;                              // Maximum output rate
    dwMaxGains : DWORD;                          // = MAXGAINS
    fGains : array[0..MAXGAINS-1] of Single;     // Array of gains
    // Information to convert values
    dwMaxRanges : DWORD;                         // = MAXRANGES
    fRangeLow : array[0..MAXRANGES-1] of Single; // Low part of range
    fRangeHigh : array[0..MAXRANGES-1] of Single;// High part of the range
    fFactor : array[0..MAXRANGES-1] of Single;   // What to mult value to
    fOffset : array[0..MAXRANGES-1] of Single;   // What to substruct from value
    wXorMask : WORD;                             // Xor mask
    wAndMask : WORD;                             // And mask
    dwFifoSize : DWORD;                          // FIFO Size (in samples) for subsystem
    dwChListSize : DWORD;                        // Max number of entries in channel list
     // Variable filled from application side for proper conversion
    dwMode : DWORD;                              // Input/Output Mode
    pdwChGainList : PDWORD;                      // Pointer to Active Channel Gain List
    dwChGainListSize : DWORD;                    // Size of channel list
  end;

const
    atPD2MF  = 1 shl 0;
    atPD2MFS = 1 shl 1;
    atPDMF   = 1 shl 2;
    atPDMFS  = 1 shl 3;
    atPD2AO  = 1 shl 4;
    atPD2DIO = 1 shl 5;
    atPXI    = 1 shl 6;
    atPDLMF  = 1 shl 7;
    atMF     = atPD2MF + atPD2MFS + atPDMF + atPDMFS + atPDLMF;

type
  PADAPTER_INFO_STRUCT = ^TADAPTER_INFO_STRUCT;
  TADAPTER_INFO_STRUCT = record
    dwBoardID: DWORD;                               // board ID
    atType: DWORD;                                  // Adapter type
    lpBoardName: array[0..19] of Char;              // Name of the specified board
    lpSerialNum: array[0..19] of Char;              // Serial Number
    SSI: array[0..MAXSS-1] of TSUBSYS_INFO_STRUCT;  // Subsystem description array
    PXI_Config: array[0..4] of Char;                // PXI line config
  end;

PPDWORD = ^PDWORD;

var
  AdapterInfo: TADAPTER_INFO_STRUCT;

{$ALIGN ON}

//-----------------------------------------------------------------------
// Function Prototypes:
//-----------------------------------------------------------------------
var
// Functions defined in pwrdaq.c:
  PdDriverOpen: function(phDriver : PHANDLE;pError : PDWORD;pNumAdapters : PDWORD) : BOOL; stdcall;
  PdDriverClose: function(hDriver : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAdapterOpen: function(dwAdapter : DWORD;pError : PDWORD;phAdapter : PHANDLE) : BOOL; stdcall;
  _PdAdapterClose: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
//----------------------------------
  PdGetVersion: function(hDriver : THANDLE;pError : PDWORD;pVersion : PPWRDAQ_VERSION) : BOOL; stdcall;
  PdGetPciConfiguration: function(hDriver : THANDLE;pError : PDWORD;pPciConfig : PPWRDAQ_PCI_CONFIG) : BOOL; stdcall;
  PdAdapterAcquireSubsystem: function(hAdapter : THANDLE;pError : PDWORD;dwSubsystem : DWORD;dwAcquire : DWORD) : BOOL; stdcall;
//----------------------------------

//
// Asynchronous operations
//
// Subsystem-independent
//
//
// Windows events
  _PdSetPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;
  _PdClearPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;

// SDK events
  _PdSetUserEvents: function(hAdapter : THANDLE;pError : PDWORD;Subsystem : PD_SUBSYSTEM;dwEvents : DWORD) : BOOL; stdcall;
  _PdClearUserEvents: function(hAdapter : THANDLE;pError : PDWORD;Subsystem : PD_SUBSYSTEM;dwEvents : DWORD) : BOOL; stdcall;
  _PdGetUserEvents: function(hAdapter : THANDLE;pError : PDWORD;Subsystem : PD_SUBSYSTEM;pdwEvents : PDWORD) : BOOL; stdcall;
  _PdImmediateUpdate: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;


// Buffering
  _PdAcquireBuffer: function(hAdapter : THANDLE; pError : PDWORD; pBuffer : PPDWORD; dwFrames : DWORD; dwFrameScans : DWORD; dwScanSamples : DWORD; dwSubsystem : DWORD; dwMode : DWORD) : BOOL; stdcall;
  _PdReleaseBuffer: function(hAdapter : THANDLE; pError : PDWORD; dwSubsystem : DWORD; pBuffer : PDWORD) : BOOL; stdcall;

  _PdGetDaqBufStatus: function(hAdapter : THANDLE;pError : PDWORD;pDaqBufStatus : PPD_DAQBUF_STATUS_INFO) : BOOL; stdcall;
  _PdClearDaqBuf: function(hAdapter : THANDLE;pError : PDWORD;Subsystem : PD_SUBSYSTEM) : BOOL; stdcall;
  _PdAInGetScans: function(hAdapter : THANDLE;pError : PDWORD;NumScans : DWORD;pScanIndex : PDWORD;pNumValidScans : PDWORD) : BOOL; stdcall;

// Start input and output subsystem simultaneously
  _PdSyncStart: function(hAdapter : THANDLE; pError : PDWORD; dwSubsystem : DWORD): BOOL; stdcall;


// Analog Input
//
  PdAInAsyncInit: function(hAdapter : THANDLE;pError : PDWORD;dwAInCfg : ULONG;
                 {$IFDEF WithFIFOSIZE} dwAInFIFOSize : ULONG;  {$ENDIF}                   // < New! FIFO size
                 dwAInPreTrigCount : ULONG;dwAInPostTrigCount : ULONG;dwAInCvClkDiv : ULONG;
                 dwAInClClkDiv : ULONG;dwEventsNotify : ULONG;dwChListChan : ULONG;pdwChList : PULONG) : BOOL; stdcall;
  _PdAInAsyncTerm: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInAsyncStart: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInAsyncStop: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInGetBufState: function(hAdapter : THANDLE; pError : PDWORD; NumScans : DWORD; pScanIndex : PDWORD; pNumValidScans : PDWORD) : BOOL; stdcall;
  _PdAInSetPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;
  _PdAInClearPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;

// Analog output
//
  _PdAOutAsyncInit : function(hAdapter : THANDLE; pError : PDWORD; dwAOutCfg : DWORD; dwAOutCvClkDiv : DWORD; dwEventNotify : DWORD) : BOOL; stdcall;
  _PdAOutAsyncTerm: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdAOutAsyncStart: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdAOutAsyncStop: function(hAdapter : THANDLE; pError : PDWORD) : BOOL;
  _PdAOutGetBufState: function(hAdapter : THANDLE; pError : PDWORD; NumScans : DWORD; pScanIndex : PDWORD; pNumValidScans : PDWORD) : BOOL; stdcall;

  _PdAOutSetPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE) : BOOL; stdcall;
  _PdAOutClearPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE) : BOOL; stdcall;

// PD2-AO AOut
//
  _PdAOAsyncInit: function(hAdapter : THANDLE; pError : PDWORD; dwAOutCfg : DWORD; dwAOutCvClkDiv : DWORD; dwEventNotify : DWORD; dwChListSize : DWORD; pdwChList : PDWORD): BOOL; stdcall;
  _PdAOAsyncTerm: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdAOAsyncStart: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdAOAsyncStop: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdAOGetBufState: function(hAdapter : THANDLE; pError : PDWORD; NumScans : DWORD; pScanIndex : PDWORD; pNumValidScans : PDWORD): BOOL; stdcall;
  _PdAOSetPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE) : BOOL; stdcall;
  _PdAOClearPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent :  PHANDLE) : BOOL; stdcall;
  _PdAODMASet: function(hAdapter : THANDLE; pError : PDWORD; dwOffset : DWORD; dwCount : DWORD; dwSource : DWORD): BOOL; stdcall;

// PD2-DIO DIn
//
  _PdDIAsyncInit: function(hAdapter : THANDLE; pError : PDWORD; dwDInCfg : DWORD; dwDInCvClkDiv : DWORD; dwEventsNotify : DWORD; dwChListChan : DWORD; dwFirstChannel : DWORD): BOOL; stdcall;
  _PdDIAsyncTerm: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdDIAsyncStart: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdDIAsyncStop: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdDIGetBufState: function(hAdapter : THANDLE; pError : PDWORD; NumScans : DWORD; pScanIndex : PDWORD; pNumValidScans : PDWORD): BOOL; stdcall;
  _PdDISetPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE): BOOL; stdcall;
  _PdDIClearPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE): BOOL; stdcall;

// PD2-DIO DOut
//
  _PdDOAsyncInit: function(hAdapter : THANDLE; pError : PDWORD; dwDOutCfg : DWORD; dwDOutCvClkDiv : DWORD; dwEventNotify : DWORD; dwChListSize : DWORD; pdwChList : PDWORD): BOOL; stdcall;
  _PdDOAsyncTerm: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdDOAsyncStart: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdDOAsyncStop: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdDOGetBufState: function(hAdapter : THANDLE; pError : PDWORD; NumScans : DWORD; pScanIndex : PDWORD; pNumValidScans : PDWORD): BOOL; stdcall;
  _PdDOSetPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE): BOOL; stdcall;
  _PdDOClearPrivateEvent: function(hAdapter : THANDLE; phNotifyEvent : PHANDLE): BOOL; stdcall;
  //: PD2-
//
  _PdCTAsyncInit: function(hAdapter : THANDLE; pError : PDWORD; dwCTCfg : ULONG; dwCTCvClkDiv : ULONG; dwEventsNotify : ULONG; dwChListChan : ULONG): BOOL; stdcall;
  _PdCTAsyncTerm: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdCTAsyncStart: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdCTAsyncStop: function(hAdapter : THANDLE; pError : PDWORD): BOOL; stdcall;
  _PdCTGetBufState: function(hAdapter : THANDLE; pError : PDWORD; NumScans : DWORD; pScanIndex : PDWORD; pNumValidScans : PDWORD): BOOL; stdcall;
  _PdCTSetPrivateEvent: function(hAdapter : THANDLE; pError : PDWORD; phNotifyEvent : PHANDLE ): BOOL; stdcall;
  _PdCTClearPrivateEvent: function(hAdapter : THANDLE;  phNotifyEvent : PHANDLE ): BOOL; stdcall;

  _PdDspCtLoad: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD;  dwLoad : DWORD; dwCompare : DWORD; dwMode : DWORD; bReload : BOOL; bInverted : BOOL; bUsePrescaler : BOOL): BOOL; stdcall;

// Enable(1)/Disable(x) counting for the selected counter
  _PdDspCtEnableCounter: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; bEnable : BOOL) : BOOL; stdcall;

// Enable(1)/Disable(x) interrupts for the selected events for the selected
// counter (HANDLE hAdapter,only one event can be enabled at the time)
  _PdDspCtEnableInterrupts: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; bCompare : BOOL; bOverflow : BOOL) : BOOL; stdcall;

// Get count register value from the selected counter
  _PdDspCtGetCount: function (hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; dwCount : PDWORD): BOOL; stdcall;

// Get compare register value from the selected counter
  _PdDspCtGetCompare: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; dwCompare : PDWORD): BOOL; stdcall;

// Get control/status register value from the selected counter
  _PdDspCtGetStatus: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; dwStatus : PDWORD): BOOL; stdcall;

// Set compare register value from the selected counter
  _PdDspCtSetCompare: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD ; dwCompare : DWORD): BOOL; stdcall;

// Set load register value from the selected counter
  _PdDspCtSetLoad: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; dwLoad : DWORD): BOOL; stdcall;

// Set control/status register value from the selected counter
  _PdDspCtSetStatus: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; dwStatus : DWORD): BOOL; stdcall;

// Load prescaler
  _PdDspPSLoad: function(hAdapter : THANDLE; pError : PDWORD; dwLoad : DWORD; dwSource : DWORD): BOOL; stdcall;

// Get prescaler count register value
  _PdDspPSGetCount: function(hAdapter : THANDLE; pError : PDWORD; dwCount : PDWORD): BOOL; stdcall;

// Get address of the count register of the selected counter
  PdDspCtGetCountAddr: function(dwCounter : DWORD): DWORD; stdcall;

// Get address of the load register of the selected counter
  PdDspCtGetLoadAddr: function(dwCounter : DWORD): DWORD; stdcall;

// Get address of the control/status register of the selected counter
  PdDspCtGetStatusAddr: function(dwCounter : DWORD): DWORD; stdcall;

// Get address of the compare register of the selected counter
  PdDspCtGetCompareAddr: function(dwCounter : DWORD): DWORD; stdcall;


// Functions defined in pwrdaqll.c:
// Board Level Commands:
  _PdAdapterEepromRead: function(hAdapter : THANDLE;pError : PDWORD;dwMaxSize : DWORD;pwReadBuf : PWORD;pdwWords : PDWORD) : BOOL; stdcall;
  _PdAdapterEnableInterrupt: function(hAdapter : THANDLE;pError : PDWORD;dwEnable : DWORD) : BOOL; stdcall;

// AIn Subsystem Commands:
  _PdAInSetCfg: function(hAdapter : THANDLE;pError : PDWORD;dwAInCfg : DWORD;dwAInPreTrig : DWORD;dwAInPostTrig : DWORD) : BOOL; stdcall;
  _PdAInSetCvClk: function(hAdapter : THANDLE;pError : PDWORD;dwClkDiv : DWORD) : BOOL; stdcall;
  _PdAInSetClClk: function(hAdapter : THANDLE;pError : PDWORD;dwClkDiv : DWORD) : BOOL; stdcall;
  _PdAInSetChList: function(hAdapter : THANDLE;pError : PDWORD;dwCh : DWORD;pdwChList : PDWORD) : BOOL; stdcall;

  _PdAInGetStatus: function(hAdapter : THANDLE;pError : PDWORD;pdwStatus : PDWORD) : BOOL; stdcall;
  _PdAInEnableConv: function(hAdapter : THANDLE;pError : PDWORD;dwEnable : DWORD) : BOOL; stdcall;
  _PdAInSwStartTrig: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInSwStopTrig: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInSwCvStart: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInSwClStart: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInResetCl: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInClearData: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInReset: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAInGetValue: function(hAdapter : THANDLE;pError : PDWORD;pwSample : PWORD) : BOOL; stdcall;
  _PdAInGetSamples: function(hAdapter : THANDLE;pError : PDWORD;dwMaxBufSize : DWORD;pwBuf : PWORD;pdwSamples : PDWORD) : BOOL; stdcall;
  _PdAInGetDataCount: function(hAdapter : THANDLE;pError : PDWORD;pdwSamples : PDWORD) : BOOL; stdcall;


// AOut Subsystem Commands:
  _PdAOutSetCfg: function(hAdapter : THANDLE;pError : PDWORD;dwAOutCfg : DWORD;dwAOutPostTrig : DWORD) : BOOL; stdcall;
  _PdAOutSetCvClk: function(hAdapter : THANDLE;pError : PDWORD;dwClkDiv : DWORD) : BOOL; stdcall;

  _PdAOutGetStatus: function(hAdapter : THANDLE;pError : PDWORD;pdwStatus : PDWORD) : BOOL; stdcall;
  _PdAOutEnableConv: function(hAdapter : THANDLE;pError : PDWORD;dwEnable : DWORD) : BOOL; stdcall;
  _PdAOutSwStartTrig: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAOutSwStopTrig: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAOutSwCvStart: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAOutClearData: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAOutReset: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAOutPutValue: function(hAdapter : THANDLE;pError : PDWORD;dwValue : DWORD) : BOOL; stdcall;
  _PdAOutPutBlock: function(hAdapter : THANDLE;pError : PDWORD;dwValues : DWORD;pdwBuf : PDWORD;pdwCount : PDWORD) : BOOL; stdcall;


// DIn Subsystem Commands:
  _PdDInSetCfg: function(hAdapter : THANDLE;pError : PDWORD;dwDInCfg : DWORD) : BOOL; stdcall;
  _PdDInGetStatus: function(hAdapter : THANDLE;pError : PDWORD;pdwEvents : PDWORD) : BOOL; stdcall;
  _PdDInRead: function(hAdapter : THANDLE;pError : PDWORD;pdwValue : PDWORD) : BOOL; stdcall;
  _PdDInClearData: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdDInReset: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdDInSetPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;
  _PdDInClearPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;

// DOut Subsystem Commands:
  _PdDOutWrite: function(hAdapter : THANDLE;pError : PDWORD;dwValue : DWORD) : BOOL; stdcall;
  _PdDOutReset: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;

// DIO256 Subsystem Commands:
  _PdDIOReset: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdDIOEnableOutput: function(hAdapter : THANDLE; pError : PDWORD; dwRegMask : DWORD) : BOOL; stdcall;
  _PdDIOLatchAll: function(hAdapter : THANDLE; pError : PDWORD; dwRegister : DWORD) : BOOL; stdcall;
  _PdDIOSimpleRead: function(hAdapter : THANDLE; pError : PDWORD; dwRegister : DWORD; pdwValue : PDWORD) : BOOL; stdcall;
  _PdDIORead: function(hAdapter : THANDLE; pError : PDWORD; dwRegister : DWORD; pdwValue : PDWORD) : BOOL; stdcall;
  _PdDIOWrite: function(hAdapter : THANDLE; pError : PDWORD; dwRegister : DWORD; dwValue : DWORD) : BOOL; stdcall;
  _PdDIOPropEnable: function(hAdapter : THANDLE; pError : PDWORD; dwRegMask : DWORD) : BOOL; stdcall;
  _PdDIOExtLatchEnable: function(hAdapter : THANDLE; pError : PDWORD; dwRegister :  DWORD; bEnable : BOOL) : BOOL; stdcall;
  _PdDIOExtLatchRead: function(hAdapter : THANDLE; pError : PDWORD; dwRegister : DWORD; bLatch : PBOOL) : BOOL; stdcall;

  _PdDIOSetIntrMask: function(hAdapter : THANDLE; pError : PDWORD; dwIntMask : PDWORD) : BOOL; stdcall;
  _PdDIOGetIntrData: function(hAdapter : PHANDLE; pError : PDWORD; dwIntData : PDWORD; dwEdgeData : PDWORD) : BOOL; stdcall;
  _PdDIOIntrEnable: function(hAdapter : PHANDLE; pError : PDWORD; dwEnable : PDWORD) : BOOL; stdcall;
  _PdDIOSetIntCh: function(hAdapter : PHANDLE; pError : PDWORD; dwChannels :  PDWORD) : BOOL; stdcall;
  _PdDIODMASet: function(hAdapter : PHANDLE; pError : PDWORD; dwOffset : PDWORD; dwCount : PDWORD; dwSource : PDWORD) : BOOL; stdcall;

  _PdDIO256CmdWrite: function(hAdapter : THANDLE;pError : PDWORD;dwCmd : DWORD;dwValue : DWORD) : BOOL; stdcall;
  _PdDIO256CmdRead: function(hAdapter : THANDLE;pError : PDWORD;dwCmd : DWORD;pdwValue : PDWORD) : BOOL; stdcall;
  _PdDspRegWrite: function(hAdapter : THANDLE;pError : PDWORD;dwReg : DWORD;dwValue : DWORD) : BOOL; stdcall;
  _PdDspRegRead: function(hAdapter : THANDLE;pError : PDWORD;dwReg : DWORD;pdwValue : PDWORD) : BOOL; stdcall;

// AO32 Subsystem Commands
  _PdAO32Reset: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdAO96Reset: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdAO32Write: function(hAdapter : THANDLE; pError : PDWORD; wChannel : WORD; wValue : WORD) : BOOL; stdcall;
  _PdAO96Write: function(hAdapter : THANDLE; pError : PDWORD; wChannel : WORD; wValue : WORD) : BOOL; stdcall;
  _PdAO32WriteX: function(hAdapter : THANDLE; pError : PDWORD; dwDACNum : DWORD; dwDACValue : DWORD; dwHold : BOOL; dwAll : BOOL): BOOL; stdcall;
  _PdAO96WriteX: function(hAdapter : THANDLE; pError : PDWORD; dwDACNum : DWORD; dwDACValue : DWORD; dwHold : BOOL; dwAll : BOOL): BOOL; stdcall;
  _PdAO32WriteHold: function(hAdapter : THANDLE; pError : PDWORD; wChannel : WORD; wValue : WORD) : BOOL; stdcall;
  _PdAO96WriteHold: function(hAdapter : THANDLE; pError : PDWORD; wChannel : WORD; wValue : WORD) : BOOL; stdcall;
  _PdAO32Update: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdAO96Update: function(hAdapter : THANDLE; pError : PDWORD) : BOOL; stdcall;
  _PdAO32SetUpdateChannel: function(hAdapter : THANDLE; pError : PDWORD; wChannel : WORD; bEnable : BOOL) : BOOL; stdcall;
  _PdAO96SetUpdateChannel: function(hAdapter : THANDLE; pError : PDWORD; wChannel : WORD; Mode : DWORD) : BOOL; stdcall;

// UCT Subsystem Commands:
  _PdUctSetMode: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD;dwSource : DWORD; dwMode : DWORD): BOOL; stdcall;
  _PdUctWriteValue: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; wValue : WORD): BOOL; stdcall;
  _PdUctReadValue: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; wValue : WORD): BOOL; stdcall;
  _PdUctFrqCounter: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; fTime : single): BOOL; stdcall;
  _PdUctFrqGetValue: function(hAdapter : THANDLE; pError : PDWORD; dwCounter : DWORD; nFrequency : PINT): BOOL; stdcall;

  _PdUctSetCfg: function(hAdapter : THANDLE;pError : PDWORD;dwUctCfg : DWORD) : BOOL; stdcall;
  _PdUctGetStatus: function(hAdapter : THANDLE; pError : PDWORD; pdwStatus : PDWORD) : BOOL; stdcall;
  _PdUctSwSetGate: function(hAdapter : THANDLE; pError : PDWORD;dwGateLevels : DWORD) : BOOL; stdcall;
  _PdUctSwClkStrobe: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdUctReset: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdUctSetPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;
  _PdUctClearPrivateEvent: function(hAdapter : THANDLE;phNotifyEvent : PHANDLE) : BOOL; stdcall;

// UCT Direct access commands:
  _PdUctWrite: function(hAdapter : THANDLE;pError : PDWORD;dwUctWord : DWORD) : BOOL; stdcall;
  _PdUctRead: function(hAdapter : THANDLE;pError : PDWORD;dwUctReadCfg : DWORD;pdwUctWord : PDWORD) : BOOL; stdcall;

// Calibration Commands:
  _PdCalSet: function(hAdapter : THANDLE;pError : PDWORD;dwCalCfg : DWORD) : BOOL; stdcall;
  _PdCalDACWrite: function(hAdapter : THANDLE;pError : PDWORD;dwCalDACValue : DWORD) : BOOL; stdcall;
  _CalDACSet: function(hAdapter : THANDLE;pError : PDWORD;nDAC : int;nOut : int;nValue : int) : int; stdcall;
  _PdAdapterEepromWrite: function(hAdapter : THANDLE;pError : PDWORD;pwWriteBuf : PWORD;dwSize : DWORD) : BOOL; stdcall;

// Functions defined in pddrvmem.c:
  _PdAllocateBuffer: function(pBuffer : PPWORD;dwFrames : DWORD;dwScans : DWORD;dwScanSize : DWORD;pError : PDWORD) : BOOL; stdcall;
  _PdFreeBuffer: function(pBuffer : PWORD;pError : PDWORD) : BOOL; stdcall;
  _PdRegisterBuffer: function(hAdapter : THANDLE;pError : PDWORD;pBuffer : PWORD;dwSubsystem : DWORD;bWrapAround : DWORD) : BOOL; stdcall;
  _PdUnregisterBuffer: function(hAdapter : THANDLE;pError : PDWORD;pBuffer : PWORD) : BOOL; stdcall;

  _PdDspIrqA: function(hAdapter:THANDLE; pError:PDWORD): BOOL; stdcall;

// Single-point (one scan) acquisition
  PdAInAcqScan: function(hAdapter : THANDLE; pError : PDWORD; dwMode : DWORD; dwChListSize : DWORD;  dwChList : PDWORD; pfVolts : pdouble) : BOOL; stdcall;

{$ENDIF}

// function prototypes
//
//=======================================================================
// Function fills up Adapter_Info structure distributed by application
//
// dwBoardNum : Number of boards
// dwError:     Error if any
// Adp_Info:    Pointer to the structure to
//
// Returns
//
  _PdGetAdapterInfo: function(dwBoardNum: DWORD; pdwError: PDWORD; Adp_Info: PADAPTER_INFO_STRUCT): BOOL stdcall;

// The function is similar to previopus but takes data directly from EEPROM and Primary Boot
// instead of structures stored in DLL
  __PdGetAdapterInfo: function(dwBoardNum: DWORD; pdwError: PDWORD; Adp_Info: PADAPTER_INFO_STRUCT): BOOL stdcall;

//=======================================================================
// Function returns pointer to DAQ_Information structure for dwBoardID
// board (stored in PCI Configuration Space) using handle to adapter
//
// Returns TRUE if success and FALSE if failure
//
  _PdGetCapsPtrA: function(hAdapter: THANDLE; pdwError: PDWORD; pDaqInf: PDAQ_Information) : BOOL; stdcall;

//=======================================================================
// Function returns pointer to DAQ_information structure for dwBoardID
// board (stored in PCI Configuration Space
//
// If dwBoardID is incorrect function returns NULL
//
  _PdGetCapsPtr: function(dwBoardID: DWORD): PDAQ_Information; stdcall;

//=======================================================================
// Function parses channel definition string in DAQ_Information structure
//
// Parameters:  dwBoardID -- board ID from PCI Config.Space
//              dwSubsystem -- subsystem enum from pwrdaq.h
//              dwProperty -- property of subsystem to retrieve:
//                  PDHCAPS_BITS       -- subsystem bit width
//                  PDHCAPS_FIRSTCHAN  -- first channel available
//                  PDHCAPS_LASTCHAN   -- last channel available
//                  PDHCAPS_CHANNELS   -- number of channels available
//
  _PdParseCaps: function(dwBoardID: DWORD; dwSubsystem : DWORD; dwProperty : DWORD) : DWORD; stdcall;

// Function convers raw values to volts
  PdAInRawToVolts: function( hAdapter: THANDLE;
                          dwMode: DWORD;              // Mode used
                          pwRawData: PWORD;           // Raw data
                          pfVoltage: PDouble;         // Engineering unit
                          dwCount: DWORD              // Number of samples to convert
                         ): BOOL; stdcall;

// Function convers raw values to volts
  PdAOutVoltsToRaw: function( hAdapter: THANDLE;
                           dwMode: DWORD;             // Mode used
                           pfVoltage: PDouble;        // Engineering unit
                           pdwRawData: PDWORD;        // Raw data
                           dwCount: DWORD             // Number of samples to convert
                         ): BOOL; stdcall;

// Function converts raw values to volts with gains
// Note: minimal conversion amount is one scan = dwChListSize samples
  PdAInScanToVolts: function( hAdapter: THANDLE;       // Handle to adapter
                            dwAInCfg :  DWORD;       // Mode used
                            dwChListSize : DWORD;    // Channel list size
                            dwChList :  PDWORD;      // Pointer to the channel list
                            wRawData : PWORD;        // Raw data
                            fVoltage : PDouble;      // Engineering unit
                            dwScans :  DWORD         // Number of scans to convert
                         ): BOOL; stdcall; //r3

//========================================================================
// Function converts volts to raw values - into WORD format
//
  PdAOVoltsToRaw16: function(hAdapter: THANDLE;        // Handle to adapter
                          fVoltage : PDouble;       // Engineering unit
                          wRawData : PWORD;         // Raw data
                          dwCount : PDWORD          // Number of samples to convert
                       ): BOOL; stdcall;  //r3

//========================================================================
//
// Function converts volts to raw values - into DWORD format
//
  PdAOVoltsToRaw32: function(hAdapter : THANDLE;       // Handle to adapter
                          fVoltage : PDouble;       // Engineering unit
                          dwRawData : PDWORD;       // Raw data
                          dwScans : DWORD           // Number of samples to convert
                       ): BOOL; stdcall;  //r3

//========================================================================
//
// Function converts volts to raw values - into DWORD format
// and combines them with with channel list entries
//
  PdAOVoltsToRawCl: function(hAdapter : THANDLE;       // Handle to adapter
                         dwChListSize : DWORD;      // Channel list size
                         dwChList : PDWORD;         // Pointer to the channel list
                         fVoltage : PDouble;        // Engineering unit
                         dwRawData : PDWORD;        // Raw data
                         dwScans : DWORD            // Number of scans to convert
                         ): BOOL; stdcall;  //r3


//-----------------------------------------------------------------------
// 12-bit multifunction medium speed (330 kHz)
const
    PD_MF_16_330_12L = (PD_BRD + $101);
    PD_MF_16_330_12H = (PD_BRD + $102);
    PD_MF_64_330_12L = (PD_BRD + $103);
    PD_MF_64_330_12H = (PD_BRD + $104);

// 12-bit multifunction high speed (1 MHz)
const
    PD_MF_16_1M_12L = (PD_BRD + $105);
    PD_MF_16_1M_12H = (PD_BRD + $106);
    PD_MF_64_1M_12L = (PD_BRD + $107);
    PD_MF_64_1M_12H = (PD_BRD + $108);

// 16-bit multifunction (250 kHz)
const
    PD_MF_16_250_16L = (PD_BRD + $109);
    PD_MF_16_250_16H = (PD_BRD + $10A);
    PD_MF_64_250_16L = (PD_BRD + $10B);
    PD_MF_64_250_16H = (PD_BRD + $10C);

// 16-bit multifunction (50 kHz)
const
    PD_MF_16_50_16L = (PD_BRD + $10D);
    PD_MF_16_50_16H = (PD_BRD + $10E);

// 12-bit, 6-ch 1M SSH
const
    PD_MFS_6_1M_12  = (PD_BRD + $10F);
    PD_Nothing      = (PD_BRD + $110);
  
  
// PowerDAQ II series -------------------------

// 14-bit multifunction low speed (400 kHz)
const
     PD2_MF_16_400_14L        = (PD_BRD + $111);
     PD2_MF_16_400_14H        = (PD_BRD + $112);
     PD2_MF_64_400_14L        = (PD_BRD + $113);
     PD2_MF_64_400_14H        = (PD_BRD + $114);

// 14-bit multifunction medium speed (800 kHz)
const
     PD2_MF_16_800_14L        = (PD_BRD + $115);
     PD2_MF_16_800_14H        = (PD_BRD + $116);
     PD2_MF_64_800_14L        = (PD_BRD + $117);
     PD2_MF_64_800_14H        = (PD_BRD + $118);

// 12-bit multifunction high speed (1.25 MHz)
const
     PD2_MF_16_1M_12L         = (PD_BRD + $119);
     PD2_MF_16_1M_12H         = (PD_BRD + $11A);
     PD2_MF_64_1M_12L         = (PD_BRD + $11B);
     PD2_MF_64_1M_12H         = (PD_BRD + $11C);

// 16-bit multifunction (50 kHz)
const
     PD2_MF_16_50_16L        = (PD_BRD + $11D);
     PD2_MF_16_50_16H        = (PD_BRD + $11E);
     PD2_MF_64_50_16L        = (PD_BRD + $11F);
     PD2_MF_64_50_16H        = (PD_BRD + $120);

// 16-bit multifunction (333 kHz)
const
     PD2_MF_16_333_16L        = (PD_BRD + $121);
     PD2_MF_16_333_16H        = (PD_BRD + $122);
     PD2_MF_64_333_16L        = (PD_BRD + $123);
     PD2_MF_64_333_16H        = (PD_BRD + $124);

// 14-bit multifunction high speed (2.2 MHz)
const
     PD2_MF_16_2M_14L         = (PD_BRD + $125);
     PD2_MF_16_2M_14H         = (PD_BRD + $126);
     PD2_MF_64_2M_14L         = (PD_BRD + $127);
     PD2_MF_64_2M_14H         = (PD_BRD + $128);

// 16-bit multifunction high speed (500 kHz)
const
     PD2_MF_16_500_16L        = (PD_BRD + $129);
     PD2_MF_16_500_16H        = (PD_BRD + $12A);
     PD2_MF_64_500_16L        = (PD_BRD + $12B);
     PD2_MF_64_500_16H        = (PD_BRD + $12C);


// 12-bit multifunction high speed (3 MHz)
const
     PD2_MF_16_3M_12L         = (PD_BRD + $129);
     PD2_MF_16_3M_12H         = (PD_BRD + $12A);
     PD2_MF_64_3M_12L         = (PD_BRD + $12B);
     PD2_MF_64_3M_12H         = (PD_BRD + $12C);

// PowerDAQ II SSH section ---------------------
// 14-bit multifunction SSH low speed (500 kHz)
const
     PD2_MFS_4_500_14         = (PD_BRD + $12D);
     PD2_MFS_8_500_14         = (PD_BRD + $12E);
     PD2_MFS_4_500_14DG       = (PD_BRD + $12F);
     PD2_MFS_4_500_14H        = (PD_BRD + $130);
     PD2_MFS_8_500_14DG       = (PD_BRD + $131);
     PD2_MFS_8_500_14H        = (PD_BRD + $132);

// 14-bit multifunction SSH medium speed (800 kHz)
const
     PD2_MFS_4_800_14         = (PD_BRD + $133);
     PD2_MFS_8_800_14         = (PD_BRD + $134);
     PD2_MFS_4_800_14DG       = (PD_BRD + $135);
     PD2_MFS_4_800_14H        = (PD_BRD + $136);
     PD2_MFS_8_800_14DG       = (PD_BRD + $137);
     PD2_MFS_8_800_14H        = (PD_BRD + $138);

// 12-bit multifunction SSH high speed (1.25 MHz)
const
     PD2_MFS_4_1M_12          = (PD_BRD + $139);
     PD2_MFS_8_1M_12          = (PD_BRD + $13A);
     PD2_MFS_4_1M_12DG        = (PD_BRD + $13B);
     PD2_MFS_4_1M_12H         = (PD_BRD + $13C);
     PD2_MFS_8_1M_12DG        = (PD_BRD + $13D);
     PD2_MFS_8_1M_12H         = (PD_BRD + $13E);

// 14-bit multifunction SSH high speed (2.2 MHz)
const
     PD2_MFS_4_2M_14          = (PD_BRD + $13F);
     PD2_MFS_8_2M_14          = (PD_BRD + $140);
     PD2_MFS_4_2M_14DG        = (PD_BRD + $141);
     PD2_MFS_4_2M_14H         = (PD_BRD + $142);
     PD2_MFS_8_2M_14DG        = (PD_BRD + $143);
     PD2_MFS_8_2M_14H         = (PD_BRD + $144);

// 16-bit multifunction SSH high speed (333 kHz)
const
     PD2_MFS_4_300_16         = (PD_BRD + $145);
     PD2_MFS_8_300_16         = (PD_BRD + $146);
     PD2_MFS_4_300_16DG       = (PD_BRD + $147);
     PD2_MFS_4_300_16H        = (PD_BRD + $148);
     PD2_MFS_8_300_16DG       = (PD_BRD + $149);
     PD2_MFS_8_300_16H        = (PD_BRD + $14A);

// DIO series
const
     PD2_DIO_64                = (PD_BRD + $14B);
     PD2_DIO_128               = (PD_BRD + $14C);
     PD2_DIO_256               = (PD_BRD + $14D);

// AO series
const
     PD2_AO_8_16               = (PD_BRD + $14E);
     PD2_AO_16_16              = (PD_BRD + $14F);
     PD2_AO_32_16              = (PD_BRD + $150);
const
     PD2_AO_96_16              = (PD_BRD + $151);
     PD2_AO_32_16HC            = (PD_BRD + $152);
     PD2_AO_32_16H             = (PD_BRD + $153);
     PD2_AO_96_16HS            = (PD_BRD + $154);
     PD2_AO_R4                 = (PD_BRD + $155);
     PD2_AO_R5                 = (PD_BRD + $156);
     PD2_AO_R6                 = (PD_BRD + $157);
     PD2_AO_R7                 = (PD_BRD + $158);

// extended DIO series
const
     PD2_DIO_64CE             = (PD_BRD + $159);
     PD2_DIO_128CE            = (PD_BRD + $15A);

const
     PD2_DIO_64ST             = (PD_BRD + $15B);
     PD2_DIO_128ST            = (PD_BRD + $15C);

const
     PD2_DIO_64HS             = (PD_BRD + $15D);
     PD2_DIO_128HS            = (PD_BRD + $15E);

const
     PD2_DIO_64CT             = (PD_BRD + $15F);
     PD2_DIO_128CT            = (PD_BRD + $160);

const                         
     PD2_DIO_64TS            = (PD_BRD + $161);
     PD2_DIO_128TS           = (PD_BRD + $162);
     PD2_DIO_R2              = (PD_BRD + $163);
     PD2_DIO_R3              = (PD_BRD + $164);
     PD2_DIO_R4              = (PD_BRD + $165);
     PD2_DIO_R5              = (PD_BRD + $166);
     PD2_DIO_R6              = (PD_BRD + $167);
     PD2_DIO_R7              = (PD_BRD + $168);

// 16-bit multifunction SSH high speed (500 kHz)
const
     PD2_MFS_4_500_16        = (PD_BRD + $169);
     PD2_MFS_8_500_16        = (PD_BRD + $16A);
     PD2_MFS_4_500_16DG      = (PD_BRD + $16B);
     PD2_MFS_4_500_16H       = (PD_BRD + $16C);
     PD2_MFS_8_500_16DG      = (PD_BRD + $16D);
     PD2_MFS_8_500_16H       = (PD_BRD + $16E);

// 16-bit multifunction (150 kHz)
const
     PD2_MF_16_150_16L       = (PD_BRD + $16F);
     PD2_MF_16_150_16H       = (PD_BRD + $170);
     PD2_MF_64_150_16L       = (PD_BRD + $171);
     PD2_MF_64_150_16H       = (PD_BRD + $172);

// reserved for MF/MFS boards
const
     PD2_MF_R0               = (PD_BRD + $173);
     PD2_MF_R1               = (PD_BRD + $174);
     PD2_MF_R2               = (PD_BRD + $175);
     PD2_MF_R3               = (PD_BRD + $176);
     PD2_MF_R4               = (PD_BRD + $177);
     PD2_MF_R5               = (PD_BRD + $178);
     PD2_MF_R6               = (PD_BRD + $179);
     PD2_MF_R7               = (PD_BRD + $17A);
     PD2_MF_R8               = (PD_BRD + $17B);
     PD2_MF_R9               = (PD_BRD + $17C);
     PD2_MF_RA               = (PD_BRD + $17D);
     PD2_MF_RB               = (PD_BRD + $17E);
     PD2_MF_RC               = (PD_BRD + $17F);
     PD2_MF_RD               = (PD_BRD + $180);
     PD2_MF_RE               = (PD_BRD + $181);
     PD2_MF_RF               = (PD_BRD + $182);

// reserved for LAB board
const
     PDL_MF_16               = (PD_BRD + $183);
     PDL_MF_16_1             = (PD_BRD + $184);
     PDL_MF_16_2             = (PD_BRD + $185);
     PDL_MF_16_3             = (PD_BRD + $186);

const
     PDL_DIO_64              = (PD_BRD + $187);
     PDL_DIO_64_1            = (PD_BRD + $188);
     PDL_DIO_64_2            = (PD_BRD + $189);
     PDL_DIO_64_3            = (PD_BRD + $18A);

const
     PDL_AO_64               = (PD_BRD + $18B);
     PDL_AO_64_1             = (PD_BRD + $18C);
     PDL_AO_64_2             = (PD_BRD + $18D);
     PDL_AO_64_3             = (PD_BRD + $18E);

// new PCI model goes from $18B to $1FF
//
//.....
//
// PDXI series -------------------------
//
// 14-bit multifunction low speed (400 kHz)
const
     PDXI_MF_16_400_14L       = (PD_BRD + $211);
     PDXI_MF_16_400_14H       = (PD_BRD + $212);
     PDXI_MF_64_400_14L       = (PD_BRD + $213);
     PDXI_MF_64_400_14H       = (PD_BRD + $214);

// 14-bit multifunction medium speed (800 kHz)
const
     PDXI_MF_16_800_14L       = (PD_BRD + $215);
     PDXI_MF_16_800_14H       = (PD_BRD + $216);
     PDXI_MF_64_800_14L       = (PD_BRD + $217);
     PDXI_MF_64_800_14H       = (PD_BRD + $218);

// 12-bit multifunction high speed (1.25 MHz)
const
     PDXI_MF_16_1M_12L        = (PD_BRD + $219);
     PDXI_MF_16_1M_12H        = (PD_BRD + $21A);
     PDXI_MF_64_1M_12L        = (PD_BRD + $21B);
     PDXI_MF_64_1M_12H        = (PD_BRD + $21C);

// 16-bit multifunction (50 kHz)
const
     PDXI_MF_16_50_16L       = (PD_BRD + $21D);
     PDXI_MF_16_50_16H       = (PD_BRD + $21E);
     PDXI_MF_64_50_16L       = (PD_BRD + $21F);
     PDXI_MF_64_50_16H       = (PD_BRD + $220);

// 16-bit multifunction (333 kHz)
const
     PDXI_MF_16_333_16L       = (PD_BRD + $221);
     PDXI_MF_16_333_16H       = (PD_BRD + $222);
     PDXI_MF_64_333_16L       = (PD_BRD + $223);
     PDXI_MF_64_333_16H       = (PD_BRD + $224);

// 14-bit multifunction high speed (2.2 MHz)
const
     PDXI_MF_16_2M_14L       = (PD_BRD + $225);
     PDXI_MF_16_2M_14H       = (PD_BRD + $226);
     PDXI_MF_64_2M_14L       = (PD_BRD + $227);
     PDXI_MF_64_2M_14H       = (PD_BRD + $228);

// 16-bit multifunction high speed (500 kHz)
const
     PDXI_MF_16_500_16L        = (PD_BRD + $229);
     PDXI_MF_16_500_16H        = (PD_BRD + $22A);
     PDXI_MF_64_500_16L        = (PD_BRD + $22B);
     PDXI_MF_64_500_16H        = (PD_BRD + $22C);

// PowerDAQ II SSH section ---------------------
// 14-bit multifunction SSH low speed (500 kHz)
const
     PDXI_MFS_4_500_14        = (PD_BRD + $22D);
     PDXI_MFS_8_500_14        = (PD_BRD + $22E);
     PDXI_MFS_4_500_14DG      = (PD_BRD + $22F);
     PDXI_MFS_4_500_14H       = (PD_BRD + $230);
     PDXI_MFS_8_500_14DG      = (PD_BRD + $231);
     PDXI_MFS_8_500_14H       = (PD_BRD + $232);

// 14-bit multifunction SSH medium speed (800 kHz)
const
     PDXI_MFS_4_800_14        = (PD_BRD + $233);
     PDXI_MFS_8_800_14        = (PD_BRD + $234);
     PDXI_MFS_4_800_14DG      = (PD_BRD + $235);
     PDXI_MFS_4_800_14H       = (PD_BRD + $236);
     PDXI_MFS_8_800_14DG      = (PD_BRD + $237);
     PDXI_MFS_8_800_14H       = (PD_BRD + $238);

// 12-bit multifunction SSH high speed (1.25 MHz)
const
     PDXI_MFS_4_1M_12         = (PD_BRD + $239);
     PDXI_MFS_8_1M_12         = (PD_BRD + $23A);
     PDXI_MFS_4_1M_12DG       = (PD_BRD + $23B);
     PDXI_MFS_4_1M_12H        = (PD_BRD + $23C);
     PDXI_MFS_8_1M_12DG       = (PD_BRD + $23D);
     PDXI_MFS_8_1M_12H        = (PD_BRD + $23E);

// 14-bit multifunction SSH high speed (2.2 MHz)
const
     PDXI_MFS_4_2M_14         = (PD_BRD + $23F);
     PDXI_MFS_8_2M_14         = (PD_BRD + $240);
     PDXI_MFS_4_2M_14DG       = (PD_BRD + $241);
     PDXI_MFS_4_2M_14H        = (PD_BRD + $242);
     PDXI_MFS_8_2M_14DG       = (PD_BRD + $243);
     PDXI_MFS_8_2M_14H        = (PD_BRD + $244);

// 16-bit multifunction SSH high speed (333 kHz)
const
     PDXI_MFS_4_300_16        = (PD_BRD + $245);
     PDXI_MFS_8_300_16        = (PD_BRD + $246);
     PDXI_MFS_4_300_16DG      = (PD_BRD + $247);
     PDXI_MFS_4_300_16H       = (PD_BRD + $248);
     PDXI_MFS_8_300_16DG      = (PD_BRD + $249);
     PDXI_MFS_8_300_16H       = (PD_BRD + $24A);

// DIO series
const
     PDXI_DIO_64              = (PD_BRD + $24B);
     PDXI_DIO_128             = (PD_BRD + $24C);
     PDXI_DIO_256             = (PD_BRD + $24D);
                                              
// AO series
const
     PDXI_AO_8_16             = (PD_BRD + $24E);
     PDXI_AO_16_16            = (PD_BRD + $24F);
     PDXI_AO_32_16            = (PD_BRD + $250);
     PDXI_AO_96_16            = (PD_BRD + $251);

const
     PDXI_AO_R1               = (PD_BRD + $252);
     PDXI_AO_R2               = (PD_BRD + $253);
     PDXI_AO_R3               = (PD_BRD + $254);
     PDXI_AO_R4               = (PD_BRD + $255);
     PDXI_AO_R5               = (PD_BRD + $256);
     PDXI_AO_R6               = (PD_BRD + $257);
     PDXI_AO_R7               = (PD_BRD + $258);
                                              
// extended DIO series
const
     PDXI_DIO_64CE            = (PD_BRD + $259);
     PDXI_DIO_128CE           = (PD_BRD + $25A);

const
     PDXI_DIO_64ST            = (PD_BRD + $25B);
     PDXI_DIO_128ST           = (PD_BRD + $25C);

const
     PDXI_DIO_64HS            = (PD_BRD + $25D);
     PDXI_DIO_128HS           = (PD_BRD + $25E);

const
     PDXI_DIO_64CT            = (PD_BRD + $25F);
     PDXI_DIO_128CT           = (PD_BRD + $260);

const
     PDXI_DIO_64TS            = (PD_BRD + $261);
     PDXI_DIO_128TS           = (PD_BRD + $262);
     PDXI_DIO_R2              = (PD_BRD + $263);
     PDXI_DIO_R3              = (PD_BRD + $264);
     PDXI_DIO_R4              = (PD_BRD + $265);
     PDXI_DIO_R5              = (PD_BRD + $266);
     PDXI_DIO_R6              = (PD_BRD + $267);
     PDXI_DIO_R7              = (PD_BRD + $268);

// 16-bit multifunction SSH high speed (500 kHz)
const
     PDXI_MFS_4_500_16        = (PD_BRD + $269);
     PDXI_MFS_8_500_16        = (PD_BRD + $26A);
     PDXI_MFS_4_500_16DG      = (PD_BRD + $26B);
     PDXI_MFS_4_500_16H       = (PD_BRD + $26C);
     PDXI_MFS_8_500_16DG      = (PD_BRD + $26D);
     PDXI_MFS_8_500_16H       = (PD_BRD + $26E);

// 16-bit multifunction (200 kHz)
const
     PDXI_MF_16_100_16L       = (PD_BRD + $26F);
     PDXI_MF_16_100_16H       = (PD_BRD + $270);
     PDXI_MF_64_100_16L       = (PD_BRD + $271);
     PDXI_MF_64_100_16H       = (PD_BRD + $272);

// reserved for MF/MFS boards
const
     PDXI_MF_R0               = (PD_BRD + $273);
     PDXI_MF_R1               = (PD_BRD + $274);
     PDXI_MF_R2               = (PD_BRD + $275);
     PDXI_MF_R3               = (PD_BRD + $276);
     PDXI_MF_R4               = (PD_BRD + $277);
     PDXI_MF_R5               = (PD_BRD + $278);
     PDXI_MF_R6               = (PD_BRD + $279);
     PDXI_MF_R7               = (PD_BRD + $27A);
     PDXI_MF_R8               = (PD_BRD + $27B);
     PDXI_MF_R9               = (PD_BRD + $27C);
     PDXI_MF_RA               = (PD_BRD + $27D);
     PDXI_MF_RB               = (PD_BRD + $27E);
     PDXI_MF_RC               = (PD_BRD + $27F);
     PDXI_MF_RD               = (PD_BRD + $280);
     PDXI_MF_RE               = (PD_BRD + $281);
     PDXI_MF_RF               = (PD_BRD + $282);

// reserved for LAB board
const
     PDXL_MF_16               = (PD_BRD + $283);
     PDXL_MF_16_1             = (PD_BRD + $284);
     PDXL_MF_16_2             = (PD_BRD + $285);
     PDXL_MF_16_3             = (PD_BRD + $286);

const
     PDXL_DIO_64              = (PD_BRD + $287);
     PDXL_DIO_64_1            = (PD_BRD + $288);
     PDXL_DIO_64_2            = (PD_BRD + $289);
     PDXL_DIO_64_3            = (PD_BRD + $28A);

const
     PDXL_AO_64               = (PD_BRD + $28B);
     PDXL_AO_64_1             = (PD_BRD + $28C);
     PDXL_AO_64_2             = (PD_BRD + $28D);
     PDXL_AO_64_3             = (PD_BRD + $28E);



const
     PD_BRD_LST = (PDXL_AO_64_3 - $101 - PD_BRD);

// end of pwrdaq32.h

function InitPowerDaq32:boolean;

implementation

uses util1, pd32hdrG;

function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  {if result=nil then messageCentral(st+'=nil');}
               {else messageCentral(st+' OK');}
end;

var
  hh:intG;


function InitPowerDaq32:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(DLLname);
  result:=(hh<>0);
  if not result then exit;


  PdDriverOpen:= getProc(hh,'PdDriverOpen');
  PdDriverClose:= getProc(hh,'PdDriverClose');
  _PdAdapterOpen:= getProc(hh,'_PdAdapterOpen');
  _PdAdapterClose:= getProc(hh,'_PdAdapterClose');
  PdGetVersion:= getProc(hh,'PdGetVersion');
  PdGetPciConfiguration:= getProc(hh,'PdGetPciConfiguration');
  PdAdapterAcquireSubsystem:= getProc(hh,'PdAdapterAcquireSubsystem');
  _PdSetPrivateEvent:= getProc(hh,'_PdSetPrivateEvent');
  _PdClearPrivateEvent:= getProc(hh,'_PdClearPrivateEvent');
  _PdSetUserEvents:= getProc(hh,'_PdSetUserEvents');
  _PdClearUserEvents:= getProc(hh,'_PdClearUserEvents');
  _PdGetUserEvents:= getProc(hh,'_PdGetUserEvents');
  _PdImmediateUpdate:= getProc(hh,'_PdImmediateUpdate');
  _PdAcquireBuffer:= getProc(hh,'_PdAcquireBuffer');
  _PdReleaseBuffer:= getProc(hh,'_PdReleaseBuffer');
  _PdGetDaqBufStatus:= getProc(hh,'_PdGetDaqBufStatus');
  _PdClearDaqBuf:= getProc(hh,'_PdClearDaqBuf');
  _PdAInGetScans:= getProc(hh,'_PdAInGetScans');
  _PdSyncStart:= getProc(hh,'_PdSyncStart');
   PdAInAsyncInit:= getProc(hh,'PdAInAsyncInit');
  _PdAInAsyncTerm:= getProc(hh,'_PdAInAsyncTerm');
  _PdAInAsyncStart:= getProc(hh,'_PdAInAsyncStart');
  _PdAInAsyncStop:= getProc(hh,'_PdAInAsyncStop');
  _PdAInGetBufState:= getProc(hh,'_PdAInGetBufState');
  _PdAInSetPrivateEvent:= getProc(hh,'_PdAInSetPrivateEvent');
  _PdAInClearPrivateEvent:= getProc(hh,'_PdAInClearPrivateEvent');
  _PdAOutAsyncInit := getProc(hh,'_PdAOutAsyncInit');
  _PdAOutAsyncTerm:= getProc(hh,'_PdAOutAsyncTerm');
  _PdAOutAsyncStart:= getProc(hh,'_PdAOutAsyncStart');
  _PdAOutAsyncStop:= getProc(hh,'_PdAOutAsyncStop');
  _PdAOutGetBufState:= getProc(hh,'_PdAOutGetBufState');
  _PdAOutSetPrivateEvent:= getProc(hh,'_PdAOutSetPrivateEvent');
  _PdAOutClearPrivateEvent:= getProc(hh,'_PdAOutClearPrivateEvent');
  _PdAOAsyncInit:= getProc(hh,'_PdAOAsyncInit');
  _PdAOAsyncTerm:= getProc(hh,'_PdAOAsyncTerm');
  _PdAOAsyncStart:= getProc(hh,'_PdAOAsyncStart');
  _PdAOAsyncStop:= getProc(hh,'_PdAOAsyncStop');
  _PdAOGetBufState:= getProc(hh,'_PdAOGetBufState');
  _PdAOSetPrivateEvent:= getProc(hh,'_PdAOSetPrivateEvent');
  _PdAOClearPrivateEvent:= getProc(hh,'_PdAOClearPrivateEvent');
  _PdAODMASet:= getProc(hh,'_PdAODMASet');
  _PdDIAsyncInit:= getProc(hh,'_PdDIAsyncInit');
  _PdDIAsyncTerm:= getProc(hh,'_PdDIAsyncTerm');
  _PdDIAsyncStart:= getProc(hh,'_PdDIAsyncStart');
  _PdDIAsyncStop:= getProc(hh,'_PdDIAsyncStop');
  _PdDIGetBufState:= getProc(hh,'_PdDIGetBufState');
  _PdDISetPrivateEvent:= getProc(hh,'_PdDISetPrivateEvent');
  _PdDIClearPrivateEvent:= getProc(hh,'_PdDIClearPrivateEvent');
  _PdDOAsyncInit:= getProc(hh,'_PdDOAsyncInit');
  _PdDOAsyncTerm:= getProc(hh,'_PdDOAsyncTerm');
  _PdDOAsyncStart:= getProc(hh,'_PdDOAsyncStart');
  _PdDOAsyncStop:= getProc(hh,'_PdDOAsyncStop');
  _PdDOGetBufState:= getProc(hh,'_PdDOGetBufState');
  _PdDOSetPrivateEvent:= getProc(hh,'_PdDOSetPrivateEvent');
  _PdDOClearPrivateEvent:= getProc(hh,'_PdDOClearPrivateEvent');
  _PdCTAsyncInit:= getProc(hh,'_PdCTAsyncInit');
  _PdCTAsyncTerm:= getProc(hh,'_PdCTAsyncTerm');
  _PdCTAsyncStart:= getProc(hh,'_PdCTAsyncStart');
  _PdCTAsyncStop:= getProc(hh,'_PdCTAsyncStop');
  _PdCTGetBufState:= getProc(hh,'_PdCTGetBufState');
  _PdCTSetPrivateEvent:= getProc(hh,'_PdCTSetPrivateEvent');
  _PdCTClearPrivateEvent:= getProc(hh,'_PdCTClearPrivateEvent');
  _PdDspCtLoad:= getProc(hh,'_PdDspCtLoad');
  _PdDspCtEnableCounter:= getProc(hh,'_PdDspCtEnableCounter');
  _PdDspCtEnableInterrupts:= getProc(hh,'_PdDspCtEnableInterrupts');
  _PdDspCtGetCount:= getProc(hh,'_PdDspCtGetCount');
  _PdDspCtGetCompare:= getProc(hh,'_PdDspCtGetCompare');
  _PdDspCtGetStatus:= getProc(hh,'_PdDspCtGetStatus');
  _PdDspCtSetCompare:= getProc(hh,'_PdDspCtSetCompare');
  _PdDspCtSetLoad:= getProc(hh,'_PdDspCtSetLoad');
  _PdDspCtSetStatus:= getProc(hh,'_PdDspCtSetStatus');
  _PdDspPSLoad:= getProc(hh,'_PdDspPSLoad');
  _PdDspPSGetCount:= getProc(hh,'_PdDspPSGetCount');
  PdDspCtGetCountAddr:= getProc(hh,'PdDspCtGetCountAddr');
  PdDspCtGetLoadAddr:= getProc(hh,'PdDspCtGetLoadAddr');
  PdDspCtGetStatusAddr:= getProc(hh,'PdDspCtGetStatusAddr');
  PdDspCtGetCompareAddr:= getProc(hh,'PdDspCtGetCompareAddr');
  _PdAdapterEepromRead:= getProc(hh,'_PdAdapterEepromRead');
  _PdAdapterEnableInterrupt:= getProc(hh,'_PdAdapterEnableInterrupt');
  _PdAInSetCfg:= getProc(hh,'_PdAInSetCfg');
  _PdAInSetCvClk:= getProc(hh,'_PdAInSetCvClk');
  _PdAInSetClClk:= getProc(hh,'_PdAInSetClClk');
  _PdAInSetChList:= getProc(hh,'_PdAInSetChList');
  _PdAInGetStatus:= getProc(hh,'_PdAInGetStatus');
  _PdAInEnableConv:= getProc(hh,'_PdAInEnableConv');
  _PdAInSwStartTrig:= getProc(hh,'_PdAInSwStartTrig');
  _PdAInSwStopTrig:= getProc(hh,'_PdAInSwStopTrig');
  _PdAInSwCvStart:= getProc(hh,'_PdAInSwCvStart');
  _PdAInSwClStart:= getProc(hh,'_PdAInSwClStart');
  _PdAInResetCl:= getProc(hh,'_PdAInResetCl');
  _PdAInClearData:= getProc(hh,'_PdAInClearData');
  _PdAInReset:= getProc(hh,'_PdAInReset');
  _PdAInGetValue:= getProc(hh,'_PdAInGetValue');
  _PdAInGetSamples:= getProc(hh,'_PdAInGetSamples');
  _PdAInGetDataCount:= getProc(hh,'_PdAInGetDataCount');
  _PdAOutSetCfg:= getProc(hh,'_PdAOutSetCfg');
  _PdAOutSetCvClk:= getProc(hh,'_PdAOutSetCvClk');
  _PdAOutGetStatus:= getProc(hh,'_PdAOutGetStatus');
  _PdAOutEnableConv:= getProc(hh,'_PdAOutEnableConv');
  _PdAOutSwStartTrig:= getProc(hh,'_PdAOutSwStartTrig');
  _PdAOutSwStopTrig:= getProc(hh,'_PdAOutSwStopTrig');
  _PdAOutSwCvStart:= getProc(hh,'_PdAOutSwCvStart');
  _PdAOutClearData:= getProc(hh,'_PdAOutClearData');
  _PdAOutReset:= getProc(hh,'_PdAOutReset');
  _PdAOutPutValue:= getProc(hh,'_PdAOutPutValue');
  _PdAOutPutBlock:= getProc(hh,'_PdAOutPutBlock');
  _PdDInSetCfg:= getProc(hh,'_PdDInSetCfg');
  _PdDInGetStatus:= getProc(hh,'_PdDInGetStatus');
  _PdDInRead:= getProc(hh,'_PdDInRead');
  _PdDInClearData:= getProc(hh,'_PdDInClearData');
  _PdDInReset:= getProc(hh,'_PdDInReset');
  _PdDInSetPrivateEvent:= getProc(hh,'_PdDInSetPrivateEvent');
  _PdDInClearPrivateEvent:= getProc(hh,'_PdDInClearPrivateEvent');
  _PdDOutWrite:= getProc(hh,'_PdDOutWrite');
  _PdDOutReset:= getProc(hh,'_PdDOutReset');
  _PdDIOReset:= getProc(hh,'_PdDIOReset');
  _PdDIOEnableOutput:= getProc(hh,'_PdDIOEnableOutput');
  _PdDIOLatchAll:= getProc(hh,'_PdDIOLatchAll');
  _PdDIOSimpleRead:= getProc(hh,'_PdDIOSimpleRead');
  _PdDIORead:= getProc(hh,'_PdDIORead');
  _PdDIOWrite:= getProc(hh,'_PdDIOWrite');
  _PdDIOPropEnable:= getProc(hh,'_PdDIOPropEnable');
  _PdDIOExtLatchEnable:= getProc(hh,'_PdDIOExtLatchEnable');
  _PdDIOExtLatchRead:= getProc(hh,'_PdDIOExtLatchRead');
  _PdDIOSetIntrMask:= getProc(hh,'_PdDIOSetIntrMask');
  _PdDIOGetIntrData:= getProc(hh,'_PdDIOGetIntrData');
  _PdDIOIntrEnable:= getProc(hh,'_PdDIOIntrEnable');
  _PdDIOSetIntCh:= getProc(hh,'_PdDIOSetIntCh');
  _PdDIODMASet:= getProc(hh,'_PdDIODMASet');
  _PdDIO256CmdWrite:= getProc(hh,'_PdDIO256CmdWrite');
  _PdDIO256CmdRead:= getProc(hh,'_PdDIO256CmdRead');
  _PdDspRegWrite:= getProc(hh,'_PdDspRegWrite');
  _PdDspRegRead:= getProc(hh,'_PdDspRegRead');
  _PdAO32Reset:= getProc(hh,'_PdAO32Reset');
  _PdAO96Reset:= getProc(hh,'_PdAO96Reset');
  _PdAO32Write:= getProc(hh,'_PdAO32Write');
  _PdAO96Write:= getProc(hh,'_PdAO96Write');
  _PdAO32WriteX:= getProc(hh,'_PdAO32WriteX');
  _PdAO96WriteX:= getProc(hh,'_PdAO96WriteX');
  _PdAO32WriteHold:= getProc(hh,'_PdAO32WriteHold');
  _PdAO96WriteHold:= getProc(hh,'_PdAO96WriteHold');
  _PdAO32Update:= getProc(hh,'_PdAO32Update');
  _PdAO96Update:= getProc(hh,'_PdAO96Update');
  _PdAO32SetUpdateChannel:= getProc(hh,'_PdAO32SetUpdateChannel');
  _PdAO96SetUpdateChannel:= getProc(hh,'_PdAO96SetUpdateChannel');
  _PdUctSetMode:= getProc(hh,'_PdUctSetMode');
  _PdUctWriteValue:= getProc(hh,'_PdUctWriteValue');
  _PdUctReadValue:= getProc(hh,'_PdUctReadValue');
  _PdUctFrqCounter:= getProc(hh,'_PdUctFrqCounter');
  _PdUctFrqGetValue:= getProc(hh,'_PdUctFrqGetValue');
  _PdUctSetCfg:= getProc(hh,'_PdUctSetCfg');
  _PdUctGetStatus:= getProc(hh,'_PdUctGetStatus');
  _PdUctSwSetGate:= getProc(hh,'_PdUctSwSetGate');
  _PdUctSwClkStrobe:= getProc(hh,'_PdUctSwClkStrobe');
  _PdUctReset:= getProc(hh,'_PdUctReset');
  _PdUctSetPrivateEvent:= getProc(hh,'_PdUctSetPrivateEvent');
  _PdUctClearPrivateEvent:= getProc(hh,'_PdUctClearPrivateEvent');
  _PdUctWrite:= getProc(hh,'_PdUctWrite');
  _PdUctRead:= getProc(hh,'_PdUctRead');
  _PdCalSet:= getProc(hh,'_PdCalSet');
  _PdCalDACWrite:= getProc(hh,'_PdCalDACWrite');
  _CalDACSet:= getProc(hh,'_CalDACSet');
  _PdAdapterEepromWrite:= getProc(hh,'_PdAdapterEepromWrite');
  _PdAllocateBuffer:= getProc(hh,'_PdAllocateBuffer');
  _PdFreeBuffer:= getProc(hh,'_PdFreeBuffer');
  _PdRegisterBuffer:= getProc(hh,'_PdRegisterBuffer');
  _PdUnregisterBuffer:= getProc(hh,'_PdUnregisterBuffer');
  _PdDspIrqA:= getProc(hh,'_PdDspIrqA');
  PdAInAcqScan:= getProc(hh,'PdAInAcqScan');
  _PdGetAdapterInfo:= getProc(hh,'_PdGetAdapterInfo');
  __PdGetAdapterInfo:= getProc(hh,'__PdGetAdapterInfo');
  _PdGetCapsPtrA:= getProc(hh,'_PdGetCapsPtrA');
  _PdGetCapsPtr:= getProc(hh,'_PdGetCapsPtr');
  _PdParseCaps:= getProc(hh,'_PdParseCaps');
  PdAInRawToVolts:= getProc(hh,'PdAInRawToVolts');
  PdAOutVoltsToRaw:= getProc(hh,'PdAOutVoltsToRaw');
  PdAInScanToVolts:= getProc(hh,'PdAInScanToVolts');
  PdAOVoltsToRaw16:= getProc(hh,'PdAOVoltsToRaw16');
  PdAOVoltsToRaw32:= getProc(hh,'PdAOVoltsToRaw32');
  PdAOVoltsToRawCl:= getProc(hh,'PdAOVoltsToRawCl');

   {Dans pd32hdrG }

  _PdFreeBufferList:=getproc(hh,'_PdFreeBufferList');
  _PdDevCmd:=getproc(hh,'_PdDevCmd');
  _PdDevCmdEx:=getproc(hh,'_PdDevCmdEx');
  _PdAInEnableClCount:=getproc(hh,'_PdAInEnableClCount');
  _PdAInEnableTimer:=getproc(hh,'_PdAInEnableTimer');
  PdEventThreadProc:=getproc(hh,'PdEventThreadProc');
  _PdDIO256CmdWrite:=getproc(hh,'_PdDIO256CmdWrite');
  _PdDIO256CmdRead:=getproc(hh,'_PdDIO256CmdRead');
  _PdDspRegWrite:=getproc(hh,'_PdDspRegWrite');
  _PdDspRegRead:=getproc(hh,'_PdDspRegRead');
  PdRegisterForEvents:=getproc(hh,'PdRegisterForEvents');
  PdUnregisterForEvents:=getproc(hh,'PdUnregisterForEvents');
  _PdAdapterTestInterrupt:=getproc(hh,'_PdAdapterTestInterrupt');
  _PdAdapterBoardReset:=getproc(hh,'_PdAdapterBoardReset');
  _PdAdapterEepromWriteOnDate:=getproc(hh,'_PdAdapterEepromWriteOnDate');
  _PdAInFlushFifo:=getproc(hh,'_PdAInFlushFifo');
  _PdAInSetXferSize:=getproc(hh,'_PdAInSetXferSize');
  _PdAdapterGetBoardStatus:=getproc(hh,'_PdAdapterGetBoardStatus');
  _PdAdapterSetBoardEvents1:=getproc(hh,'_PdAdapterSetBoardEvents1');
  _PdAdapterSetBoardEvents2:=getproc(hh,'_PdAdapterSetBoardEvents2');
  _PdAInSetEvents:=getproc(hh,'_PdAInSetEvents');
  _PdAInSetSSHGain:=getproc(hh,'_PdAInSetSSHGain');
  _PdAOutSetEvents:=getproc(hh,'_PdAOutSetEvents');
  _PdDiagPCIEcho:=getproc(hh,'_PdDiagPCIEcho');
  _PdDiagPCIInt:=getproc(hh,'_PdDiagPCIInt');

end;

Initialization
AffDebug('Initialization pwrdaq32G',0);

finalization
  if hh<>0 then freeLibrary(hh);

end.

