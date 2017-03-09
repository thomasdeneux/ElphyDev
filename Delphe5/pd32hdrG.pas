unit pd32hdrG;

// --------------------------------------------------------
// converted from D:\Work\Delphi\headerconvertor\pd32hdr.h
// 4/13/00 1:29:44 PM
// --------------------------------------------------------
//===========================================================================
//
// NAME:    pd32hdr.h
//
// DESCRIPTION:
//
//          PowerDAQ Win32 DLL header file
//
//          Definitions for PowerDAQ DLL driver interface functions.
//
// AUTHOR:  Alex Ivchenko
//
// DATE:    22-DEC-99
//
// REV:     0.11
//
// R DATE:  12-MAR-2000
//
// HISTORY:
//
//      Rev 0.1,     26-DEC-99,  A.I.,   Initial version.
//      Rev 0.11,    12-MAR-2000,A.I.,   DSP reghister r/w added
//
//
//---------------------------------------------------------------------------
//
//      Copyright (C) 1999,2000 United Electronic Industries, Inc.
//      All rights reserved.
//      United Electronic Industries Confidential Information.
//
//===========================================================================

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{$IFNDEF _INC_PWRDAQ32HDR}
  {$DEFINE _INC_PWRDAQ32HDR}
{$ENDIF}

uses
  windows,pwrdaqG;

  // move this constant below uses clause
const
  DLLName = 'pwrdaq32.dll';


// Adapter information structure ---------------------------------------
type
  DWORD = Cardinal;

  EVENT_PROC = procedure(pAllEvents : PPD_ALL_EVENTS); stdcall;
  PD_EVENT_PROC = ^EVENT_PROC;

  PPD_ADAPTER_INFO = ^PD_ADAPTER_INFO;
  PD_ADAPTER_INFO = record
    dwAdapterId : DWORD;
    hAdapter : THANDLE;
    bTerminate : BOOL;
    hTerminateEvent : THANDLE;
    hEventThread : THANDLE;
    dwProcessId : DWORD;
    pfn_EventProc : PD_EVENT_PROC;
    csAdapter : THANDLE;
  end;
var
  _PD_ADAPTER_INFO : PD_ADAPTER_INFO;

//
// Private functions
//
  _PdFreeBufferList:procedure; stdcall;

  _PdDevCmd: function(hDevice : THANDLE;pError : PDWORD;dwIoControlCode : DWORD;
  lpInBuffer : POINTER;nInBufferSize : DWORD;lpOutBuffer : POINTER;
  nOutBufferSize : DWORD;bOverlapped : BOOL) : BOOL; stdcall;

  _PdDevCmdEx: function(hDevice : THANDLE;pError : PDWORD;dwIoControlCode : DWORD;
  lpInBuffer : POINTER;nInBufferSize : DWORD;
  lpOutBuffer : POINTER;nOutBufferSize : DWORD;
  pdwRetBytes : PDWORD;bOverlapped : BOOL) : DWORD; stdcall;

//?CHECK THIS:
  _PdAInEnableClCount: function(hAdapter : THANDLE;pError : PDWORD;bEnable : BOOL) : BOOL; stdcall;
  _PdAInEnableTimer: function(hAdapter : THANDLE;pError : PDWORD;bEnable : BOOL;dwMilliSeconds : DWORD) : BOOL; stdcall;
  PdEventThreadProc: function(lpParameter : POINTER) : DWORD; stdcall;

  _PdDIO256CmdWrite: function(hAdapter : THANDLE;pError : PDWORD;dwCmd : DWORD;dwValue : DWORD) : BOOL; stdcall;
  _PdDIO256CmdRead: function(hAdapter : THANDLE;pError : PDWORD;dwCmd : DWORD;pdwValue : PDWORD) : BOOL; stdcall;
  _PdDspRegWrite: function(hAdapter : THANDLE;pError : PDWORD;dwReg : DWORD;dwValue : DWORD) : BOOL; stdcall;
  _PdDspRegRead: function(hAdapter : THANDLE;pError : PDWORD;dwReg : DWORD;pdwValue : PDWORD) : BOOL; stdcall;

//----------------------------------
  PdRegisterForEvents: function(dwAdapter : DWORD;pError : PDWORD;pEventProc : PD_EVENT_PROC) : BOOL; stdcall;
  PdUnregisterForEvents: function(dwAdapter : DWORD;pError : PDWORD) : BOOL; stdcall;
  _PdAdapterTestInterrupt: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAdapterBoardReset: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;
  _PdAdapterEepromWriteOnDate: function(hAdapter : THANDLE;pError : PDWORD;wValue : WORD) : BOOL; stdcall;

//AIN
  _PdAInFlushFifo: function(hAdapter : THANDLE;pError : PDWORD;pdwSamples : PDWORD) : BOOL; stdcall;
  _PdAInSetXferSize: function(hAdapter : THANDLE;pError : PDWORD;dwSize : DWORD) : BOOL; stdcall;

// Events
  _PdAdapterGetBoardStatus: function(hAdapter : THANDLE;pError : PDWORD;pdwStatusBuf : PDWORD) : BOOL; stdcall;
  _PdAdapterSetBoardEvents1: function(hAdapter : THANDLE;pError : PDWORD;dwEvents : DWORD) : BOOL; stdcall;
  _PdAdapterSetBoardEvents2: function(hAdapter : THANDLE;pError : PDWORD;dwEvents : DWORD) : BOOL; stdcall;
  _PdAInSetEvents: function(hAdapter : THANDLE;pError : PDWORD;dwEvents : DWORD) : BOOL; stdcall;

// SSH
  _PdAInSetSSHGain: function(hAdapter : THANDLE;pError : PDWORD;dwCfg : DWORD) : BOOL; stdcall;
  _PdAOutSetEvents: function(hAdapter : THANDLE;pError : PDWORD;dwEvents : DWORD) : BOOL; stdcall;

// Diag
  _PdDiagPCIEcho: function(hAdapter : THANDLE;pError : PDWORD;dwValue : DWORD;pdwReply : PDWORD) : BOOL; stdcall;
  _PdDiagPCIInt: function(hAdapter : THANDLE;pError : PDWORD) : BOOL; stdcall;

implementation
begin
end.

