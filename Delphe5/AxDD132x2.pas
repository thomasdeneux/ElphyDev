
//***********************************************************************************************
//
//    Copyright (c) 1998 Axon Instruments.
//    All rights reserved.
//
//***********************************************************************************************
// MODULE:  AXDD132X.HPP
// PURPOSE: Interface definition for AXDD132X.DLL
// AUTHOR:  BHI  Aug 1998
//
// Interface Delphi Gérard Sadoc aout 2001
// Modification en 2002: la nouvelle version fournie par Axon porte la même date mais
// a été profondément modifiée. Elle est adaptée à Axoscope 9.
//
// Pour charger la DLL AXDD132X sous Windows98, il faut que la DLL AXOUTILS32 soit
// accessible. Nous la copions donc dans le rep de Elphy
// Sous Windows 2000, plusieurs DLL sont nécessaires. Lesquelles? Dans le doute, on
// copie toutes les DLL Axon dans le répertoire de Elphy



{ $A-}

unit AxDD132X2;

Interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,
     util1, debug0;

{$DEFINE INC_AXDD132X_HPP}

{
#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
}

type
  Pinteger=^integer;

const DD132X_MAXAICHANNELS = 16;
const DD132X_MAXAOCHANNELS = 16;          {8 auparavant}
const DD132X_SCANLIST_SIZE = 64;

type
  TDD132X_Info=                           {idem}
    record
      uLength:     integer;
      byAdaptor:   byte;
      byTarget:    byte;
      byImageType: byte;
      byResetType: byte;
      szManufacturer:array[1..16] of char;
      szName:        array[1..32] of char;
      szProductVersion: array[1..8] of char;
      szFirmwareVersion: array [1..16] of char;
      uInputBufferSize: Dword;
      uOutputBufferSize: Dword;
      uSerialNumber: Dword;
      uClockResolution: Dword;
      uMinClockTicks: Dword;
      uMaxClockTicks: Dword;
      byUnused: array[1..280] of byte;
    end;

procedure initDD132X_Info(var w:TDD132X_Info);

//========================================================================================
// Constants for the protocol.

// Values used in the dwFlags field
Const
  DD132X_PROTOCOL_STOPONTC= 1;

// DD1320 special cases for Analog output sequence.
  DD132X_PROTOCOL_DIGITALOUTPUT= $0040;
  DD132X_PROTOCOL_NULLOUTPUT=    $0050;

Const
{TDD132X_Triggering }
  DD132X_StartImmediately=0;
  DD132X_ExternalStart=1;
  DD132X_LineTrigger=2;


{TDD132X_AIDataBits }
  DD132X_Bit0Data=0;
  DD132X_Bit0ExtStart=1;
  DD132X_Bit0Line=2;
  DD132X_Bit0Tag=3;
  DD132X_Bit0Tag_Bit1ExtStart=4;
  DD132X_Bit0Tag_Bit1Line=5;


{TDD132X_OutputPulseType}

  DD132X_NoOutputPulse=0;
  DD132X_ADC_level_Triggered=1;
  DD132X_DAC_bit0_Triggered=2;


//==============================================================================================
// STRUCTURE: DD132X_Protocol
// PURPOSE:   Describes acquisition settings.
//
type

//
// Define a linked list structure for holding acquisition buffers.
// Provient de ADCDAC.H
//
  TDATABUFFER=record
    uNumSamples: Dword;         // Number of samples in this buffer.
    uFlags: Dword;              // Flags discribing the data buffer.
    pnData:PtabEntier;          // The buffer containing the data.
    psDataFlags:Pbyte;          // Flags split out from the data buffer.
    pNextBuffer:PtabEntier;     // Next buffer in the list.
    pPrevBuffer:PtabEntier;     // Previous buffer in the list.
  end;

  PDATABUFFER=^TDATABUFFER;

//
// Define a linked list structure for holding floating point acquisition buffers.
// Provient de ADCDAC.H
//
  TFLOATBUFFER=
    record
      uNumSamples:Dword;   // Number of samples in this buffer.
      uFlags:Dword;        // Flags discribing the data buffer.
      pfData:Pfloat;       // The buffer containing the data.
      pNextBuffer:Pfloat;  // Next buffer in the list.
      pPrevBuffer:Pfloat;  // Previous buffer in the list.
    end;

  PFLOATBUFFER=^TFLOATBUFFER;


  TDD132X_Protocol=record

    uLength: integer;                    // Size of this structure in bytes.
    dSampleInterval: double;             // Sample interval in us.
    dwFlags: Dword;                      // Boolean flags that control options.
    eTriggering: integer;
    eAIDataBits: integer;

    uAIChannels: Dword;
    anAIChannels: array[1..DD132X_SCANLIST_SIZE] of integer;
    pAIBuffers: PdataBuffer;
    uAIBuffers: Dword;

    uAOChannels: Dword;
    anAOChannels: array[1..DD132X_SCANLIST_SIZE] of integer;
    pAOBuffers: PdataBuffer;
    uAOBuffers: Dword;

    uTerminalCount: int64;

    eOutputPulseType: integer;
    bOutputPulsePolarity:smallint;   // TRUE = positive.
    nOutputPulseChannel:smallint;
    wOutputPulseThreshold:word;
    wOutputPulseHystDelta:word;

    uChunksPerSecond:Dword;

    byUnused: Array[1..248] of byte;
  end;


//==============================================================================================
// STRUCTURE: DD132X_PowerOnData
// PURPOSE:   Contains items that are set in the EEPROM of the DD1320 as power-on defaults.
//

  TDD132X_PowerOnData=record
    uLength:Dword;
    dwDigitalOuts:Dword;
    anAnalogOuts:array[1..DD132X_MAXAOCHANNELS] of smallint;
  end;


// constants for the uEquipmentStatus field.
const
  DD132X_STATUS_TERMINATOR      = $00000001;
  DD132X_STATUS_DRAM            = $00000002;
  DD132X_STATUS_EEPROM          = $00000004;
  DD132X_STATUS_INSCANLIST      = $00000008;
  DD132X_STATUS_OUTSCANLIST     = $00000010;
  DD132X_STATUS_CALIBRATION_MUX = $00000020;
  DD132X_STATUS_INPUT_FIFO      = $00000040;
  DD132X_STATUS_OUTPUT_FIFO     = $00000080;
  DD132X_STATUS_LINEFREQ_GEN    = $00000100;
  DD132X_STATUS_FPGA            = $00000200;
  DD132X_STATUS_ADC0            = $00000400;
  DD132X_STATUS_DAC0            = $00000800;
  DD132X_STATUS_DAC1            = $00001000;
  DD132X_STATUS_DAC2            = $00002000;
  DD132X_STATUS_DAC3            = $00003000;
  DD132X_STATUS_DAC4            = $00004000;
  DD132X_STATUS_DAC5            = $00010000;
  DD132X_STATUS_DAC6            = $00020000;
  DD132X_STATUS_DAC7            = $00040000;
  DD132X_STATUS_DAC8            = $00080000;
  DD132X_STATUS_DAC9            = $00100000;
  DD132X_STATUS_DACA            = $00200000;
  DD132X_STATUS_DACB            = $00400000;
  DD132X_STATUS_DACC            = $00800000;
  DD132X_STATUS_DACD            = $01000000;
  DD132X_STATUS_DACE            = $02000000;
  DD132X_STATUS_DACF            = $04000000;


//==============================================================================================
// STRUCTURE: Diagnostic data
// PURPOSE:   Configuration data returned through DriverLINX.
// NOTE:      The size of diagnostic data must be even.
//
type
  TDD132X_CalibrationData=record

    uLength: Dword;                  // Size of this structure in bytes.
    uEquipmentStatus: Dword;         // Bit mask of equipment status flags.
    dADCGainRatio: double;           // ADC 0 gain-ratio
    nADCOffset: smallint;            // ADC 0  zero offset
    byUnused1:array[1..46] of byte;  // Unused space for more ADCs

    wNumberOfDACs: word;             // total number of DACs on board
    byUnused2:array[1..6] of byte;   // Alignment bytes.
    anDACOffset:array[1..DD132X_MAXAOCHANNELS] of smallint; // DAC 0 zero offset
    adDACGainRatio:array[1..DD132X_MAXAOCHANNELS] of double;// DAC 0 gain-ratio
    byUnused4:array[1..24] of byte;
  end;


//==============================================================================================
// STRUCTURE: Start acquisition info.
// PURPOSE:   To store the start acquisition time and precission,
//            by querying a high resolution timer before and after
//            the start acquisition SCSI command.
//
  TDD132X_StartAcqInfo=record
    uLength:Dword;            // Size of this structure in bytes.
    m_StartTime:TSYSTEMTIME;  // Stores the time and date of the begginning of the acquisition.
    m_n64PreStartAcq: int64;  // Stores the high resolution counter before the acquisition start.
    m_n64PostStartAcq:int64;  // Stores the high resolution counter after the acquisition start.

  end;
  PDD132X_StartAcqInfo=^TDD132X_StartAcqInfo;

// constants for SetDebugMsgLevel()
const
  DD132X_MSG_SHOWALL  = 0;
  DD132X_MSG_SHOWLESS = 1;
  DD132X_MSG_SHOWNONE = 2;

// The handle type declaration.
type
  HDD132X=Thandle;

// Error codes
const  DD132X_ERROR_ASPINOTFOUND  = 1;
const  DD132X_ERROR_OUTOFMEMORY   = 2;
const  DD132X_ERROR_NOTDD132X     = 3;
const  DD132X_ERROR_RAMWAREOPEN   = 4;
const  DD132X_ERROR_RAMWAREREAD   = 5;
const  DD132X_ERROR_RAMWAREWRITE  = 6;
const  DD132X_ERROR_RAMWARESTART  = 7;
const  DD132X_ERROR_SETAIPROTOCOL = 8;
const  DD132X_ERROR_SETAOPROTOCOL = 9;
const  DD132X_ERROR_STARTACQ      = 10;
const  DD132X_ERROR_STOPACQ       = 11;
const  DD132X_ERROR_PAUSEACQ      = 12;
const  DD132X_ERROR_READDATA      = 13;
const  DD132X_ERROR_WRITEDATA     = 14;
const  DD132X_ERROR_CALIBRATION   = 15;
const  DD132X_ERROR_DIAGNOSTICS   = 16;
const  DD132X_ERROR_DTERM_READ    = 17;
const  DD132X_ERROR_DTERM_WRITE   = 18;
const  DD132X_ERROR_DTERM_BUSY    = 19;
const  DD132X_ERROR_DTERM_SETBAUD = 20;

const  DD132X_ERROR_ASPIERROR     = 1000;

// Internal error numbers.
const  DD132X_ERROR_CANTCOMPLETE  = 9999;



var
// Find, Open & close device.
DD132X_RescanSCSIBus:
  function(var error:integer):BOOL;stdCall;
DD132X_FindDevices:
  function(var info:TDD132X_Info;uMaxDevices:Dword;var Error:integer ):Dword;
  stdCall;
DD132X_OpenDevice:
  function (byAdaptor:byte;byTarget:byte;var error:integer):HDD132X;
  stdCall;
DD132X_OpenDeviceEx:
  function (byAdaptor:byte;byTarget:byte;var ramware:byte;
            uImageSize:Dword;var error:integer):HDD132X;stdCall;
DD132X_CloseDevice:
  function ( hDevice:HDD132X; var error:integer ):BOOL;stdCall;
DD132X_GetDeviceInfo:
  function (hDevice:HDD132X;var info: TDD132X_Info;var error: integer):BOOL;
  stdCall;

DD132X_Reset:
  function(hdevice:HDD132X;var error: integer):BOOL;stdCall;
DD132X_DownloadRAMware:
  function(hdevice:HDD132X;var pRAMware:byte;uImageSize:Dword;var error:integer):BOOL;
  stdCall;

// Get/set acquisition protocol information.
DD132X_SetProtocol:
  function(hdevice:HDD132X; var Protocol:TDD132X_Protocol; var error:integer):BOOL;
  stdCall;
DD132X_GetProtocol:
  function(hdevice:HDD132X; var protocol:TDD132X_Protocol; var error:integer):BOOL;
  stdCall;

// Start/stop acquisition.
DD132X_StartAcquisition:
  function(hdevice:HDD132X; var error:integer):BOOL;stdCall;
DD132X_StopAcquisition:
  function(hdevice:HDD132X; var error:integer):BOOL;stdCall;
DD132X_PauseAcquisition:
  function(hdevice:HDD132X; bPause:BOOL;var error:integer):BOOL;stdCall;
DD132X_IsAcquiring:
  function(hDevice:HDD132X ):BOOL;stdCall;
DD132X_IsPaused:
  function(hdevice:HDD132X):BOOL;stdCall;
DD132X_GetTimeAtStartOfAcquisition:
  function(hdevice:HDD132X;var inf: TDD132X_StartAcqInfo):BOOL;stdCall;

// Start/read ReadLast acquisition.
DD132X_StartReadLast:
  function( hDevice:HDD132X; var Error:integer):BOOL;stdCall;
DD132X_ReadLast:
  function( hDevice:HDD132X;pnBuffer:pointer;uNumSamples:Dword;var Error:integer):BOOL;stdCall;


// Monitor progress of the acquisition.
DD132X_GetAcquisitionPosition:
  function(hdevice:HDD132X; var SampleCount:int64; var error:integer):BOOL;stdCall;
DD132X_GetNumSamplesOutput:
  function(hdevice:HDD132X; var SampleCount:int64; var error:integer):BOOL;stdCall;

// Single read/write operations.
DD132X_GetAIValue:
  function(hdevice:HDD132X; channel:Dword;var Value:smallint; var error:integer):BOOL;
  stdCall;
DD132X_GetDIValues:
  function(hdevice:HDD132X; var dwValues:DWORD; var error:integer):BOOL;stdCall;
DD132X_PutAOValue:
  function(hdevice:HDD132X; channel:Dword;value:smallint; var error:integer):BOOL;
  stdCall;
DD132X_PutDOValues:
  function(hdevice:HDD132X; dwValues:DWORD ; var error:integer):BOOL;stdCall;
DD132X_GetTelegraphs:
  function(hdevice:HDD132X; FirstChannel:Dword;var Value:smallint;Values:Dword;
           var error:integer):BOOL;stdCall;

// Calibration & EEPROM interraction.
DD132X_SetPowerOnOutputs:
  function(hdevice:HDD132X; var PowerOnData:TDD132X_PowerOnData; var error:integer):BOOL;
  stdCall;
DD132X_GetPowerOnOutputs:
  function(hdevice:HDD132X; var PowerOnData:TDD132X_PowerOnData; var error:integer):BOOL;
  stdCall;

DD132X_Calibrate:
  function(hdevice:HDD132X; var CalibrationData:TDD132X_CalibrationData; var error:integer):BOOL;
  stdCall;
DD132X_GetCalibrationData:
  function(hdevice:HDD132X; var CalibrationData:TDD132X_CalibrationData; var error:integer):BOOL;
  stdCall;

DD132X_GetScsiTermStatus:
  function(hDevice:HDD132X ;var pbyStatus:byte;var Error:integer):BOOL;stdCall;

DD132X_DTermRead:
  function(hDevice: HDD132X;pszBuf:pointer;uMaxLen:Dword;var Error:integer):BOOL;stdCall;
DD132X_DTermWrite:
  function(hDevice:HDD132X;pszBuf:pointer;var Error:integer):BOOL;stdCall;
DD132X_DTermSetBaudRate:
  function(hdevice:HDD132X; uBaudRate:Dword;var Error:integer):BOOL;stdCall;


// Diagnostic functions.
DD132X_GetLastErrorText:
  function(hdevice:HDD132X; msg:Pchar; MsgLen:Dword; var error:integer):BOOL;
  stdCall;
DD132X_SetDebugMsgLevel:
  function(hdevice:HDD132X; level:Dword; var error:integer):BOOL;
  stdCall;

DD132X_UpdateThresholdLevel:
  function(hDevice:HDD132X ;var OutputPulseThreshold,OutputPulseHystDelta:word):BOOL;stdCall;

function InitDD132Xlib:boolean;

Implementation

procedure initDD132X_Info(var w:TDD132X_Info);
begin
  fillchar(w,sizeof(w), 0);
  w.uLength   := sizeof(w);
  w.byAdaptor := 255;
  w.byTarget  := 255;
end;

function getProc(hh:Thandle;st:string):pointer;
begin
  result:=GetProcAddress(hh,Pchar(st));
  if result=nil then messageCentral(st+'=nil');
                 {else messageCentral(st+' OK');}
end;

var
  hh:integer;


function InitDD132Xlib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=loadLibrary('axdd132x.dll');
  result:=(hh<>0);
  if not result then exit;

  DD132X_FindDevices:=getProc(hh,'DD132X_FindDevices');
  DD132X_OpenDevice:=getProc(hh,'DD132X_OpenDevice');
  DD132X_OpenDeviceEx:=getProc(hh,'DD132X_OpenDeviceEx');
  DD132X_CloseDevice:=getProc(hh,'DD132X_CloseDevice');
  DD132X_GetDeviceInfo:=getProc(hh,'DD132X_GetDeviceInfo');
  DD132X_Reset:=getProc(hh,'DD132X_Reset');
  DD132X_DownloadRAMware:=getProc(hh,'DD132X_DownloadRAMware');
  DD132X_SetProtocol:=getProc(hh,'DD132X_SetProtocol');
  DD132X_GetProtocol:=getProc(hh,'DD132X_GetProtocol');
  DD132X_StartAcquisition:=getProc(hh,'DD132X_StartAcquisition');
  DD132X_StopAcquisition:=getProc(hh,'DD132X_StopAcquisition');

  DD132X_PauseAcquisition:=getProc(hh,'DD132X_PauseAcquisition');

  DD132X_IsAcquiring:=getProc(hh,'DD132X_IsAcquiring');

  DD132X_IsPaused:=getProc(hh,'DD132X_IsPaused');
  DD132X_GetTimeAtStartOfAcquisition:=getProc(hh,'DD132X_GetTimeAtStartOfAcquisition');
  DD132X_StartReadLast:=getProc(hh,'DD132X_StartReadLast');
  DD132X_ReadLast:=getProc(hh,'DD132X_ReadLast');

  DD132X_GetAcquisitionPosition:=getProc(hh,'DD132X_GetAcquisitionPosition');
  DD132X_GetNumSamplesOutput:=getProc(hh,'DD132X_GetNumSamplesOutput');
  DD132X_GetAIValue:=getProc(hh,'DD132X_GetAIValue');
  DD132X_GetDIValues:=getProc(hh,'DD132X_GetDIValues');
  DD132X_PutAOValue:=getProc(hh,'DD132X_PutAOValue');
  DD132X_PutDOValues:=getProc(hh,'DD132X_PutDOValues');
  DD132X_GetTelegraphs:=getProc(hh,'DD132X_GetTelegraphs');
  DD132X_SetPowerOnOutputs:=getProc(hh,'DD132X_SetPowerOnOutputs');
  DD132X_GetPowerOnOutputs:=getProc(hh,'DD132X_GetPowerOnOutputs');
  DD132X_Calibrate:=getProc(hh,'DD132X_Calibrate');
  DD132X_GetCalibrationData:=getProc(hh,'DD132X_GetCalibrationData');

  DD132X_DtermRead:=getProc(hh,'DD132X_DTermRead');
  DD132X_DtermWrite:=getProc(hh,'DD132X_DTermWrite');
  DD132X_DtermSetBaudRate:=getProc(hh,'DD132X_DTermSetBaudRate');

  DD132X_GetLastErrorText:=getProc(hh,'DD132X_GetLastErrorText');
  DD132X_SetDebugMsgLevel:=getProc(hh,'DD132X_SetDebugMsgLevel');

  DD132X_UpdateThresholdLevel:=getProc(hh,'DD132X_UpdateThresholdLevel');

end;


Initialization
AffDebug('Initialization AxDD132X2',0);

finalization
  if hh<>0 then freeLibrary(hh);
end.
