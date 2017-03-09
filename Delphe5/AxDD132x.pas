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
//
// Pour charger la DLL AXDD132X sous Windows98, il faut que la DLL AXOUTILS32 soit
// accessible. Nous la copions donc dans le rep de Elphy
// Sous Windows 2000, plusieurs DLL sont nécessaires. Lesquelles? Dans le doute, on
// copie toutes les DLL Axon dans le répertoire de Elphy

{ $A-}

unit AxDD132X;

Interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,
     util1;

{$DEFINE INC_AXDD132X_HPP}

{
#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000
}

type
  Pinteger=^integer;

const DD132X_MAXAOCHANNELS = 8;
const DD132X_SCANLIST_SIZE = 64;

type
  TDD132X_Info=
    record
      uLength:     integer;
      byAdaptor:   byte;
      byTarget:    byte;
      byImageType: byte;
      byResetType: byte;
      szManufacturer:array[1..16] of AnsiChar;
      szName:        array[1..32] of AnsiChar;
      szProductVersion: array[1..8] of AnsiChar;
      szFirmwareVersion: array [1..16] of AnsiChar;
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


//==============================================================================================
// STRUCTURE: DD132X_Protocol
// PURPOSE:   Describes acquisition settings.
//
type

//
// Define a linked list structure for holding acquisition buffers.
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
    byUnused: Array[1..264] of byte;
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
  DD132X_STATUS_TERMINATOR      = $0001;
  DD132X_STATUS_DRAM            = $0002;
  DD132X_STATUS_EEPROM          = $0004;
  DD132X_STATUS_INSCANLIST      = $0008;
  DD132X_STATUS_OUTSCANLIST     = $0010;
  DD132X_STATUS_CALIBRATION_MUX = $0020;
  DD132X_STATUS_INPUT_FIFO      = $0040;
  DD132X_STATUS_OUTPUT_FIFO     = $0080;
  DD132X_STATUS_LINEFREQ_GEN    = $0100;
  DD132X_STATUS_FPGA            = $0200;
  DD132X_STATUS_ADC0            = $0400;
  DD132X_STATUS_DAC0            = $0800;
  DD132X_STATUS_DAC1            = $1000;

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
    byUnused4:array[1..104] of byte;
  end;



// constants for SetDebugMsgLevel()
const
  DD132X_MSG_SHOWALL  = 0;
  DD132X_MSG_SHOWLESS = 1;
  DD132X_MSG_SHOWNONE = 2;

// The handle type declaration.
type
  HDD132X=Thandle;

// Error codes
const
  DD132X_ERROR_ASPINOTFOUND  = 1;
  DD132X_ERROR_OUTOFMEMORY   = 2;
  DD132X_ERROR_NOTDD132X     = 3;
  DD132X_ERROR_RAMWAREOPEN   = 4;
  DD132X_ERROR_RAMWAREREAD   = 5;
  DD132X_ERROR_RAMWAREWRITE  = 6;
  DD132X_ERROR_RAMWARESTART  = 7;
  DD132X_ERROR_SETAIPROTOCOL = 8;
  DD132X_ERROR_SETAOPROTOCOL = 9;
  DD132X_ERROR_STARTACQ      = 10;
  DD132X_ERROR_STOPACQ       = 11;
  DD132X_ERROR_READDATA      = 12;
  DD132X_ERROR_WRITEDATA     = 13;
  DD132X_ERROR_CALIBRATION   = 14;

  DD132X_ERROR_ASPIERROR     = 1000;

// Internal error numbers.
  DD132X_ERROR_CANTCOMPLETE  = 9999;



var
// Find, Open & close device.
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
DD132X_IsAcquiring:
  function(hDevice:HDD132X ):BOOL;stdCall;

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

// Diagnostic functions.
DD132X_GetLastErrorText:
  function(hdevice:HDD132X; msg:Pansichar; MsgLen:Dword; var error:integer):BOOL;
  stdCall;
DD132X_SetDebugMsgLevel:
  function(hdevice:HDD132X; level:Dword; var error:integer):BOOL;
  stdCall;

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
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
                 {else messageCentral(st+' OK');}
end;

var
  hh:intG;


function InitDD132Xlib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('axdd132x.dll');
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
  DD132X_IsAcquiring:=getProc(hh,'DD132X_IsAcquiring');
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
  DD132X_GetLastErrorText:=getProc(hh,'DD132X_GetLastErrorText');
  DD132X_SetDebugMsgLevel:=getProc(hh,'DD132X_SetDebugMsgLevel');

end;


Initialization
AffDebug('Initialization AxDD132x',0);

finalization
  if hh<>0 then freeLibrary(hh);
end.
