{
 ---------------------------------------------------------------------
 File - wd_utils.pas

 WDUTILS.DLL function declarations for Delphi applications

 Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com
 ---------------------------------------------------------------------
}

unit wd_utils;

interface

uses 
  Windows, Dialogs, SysUtils,
  WinDrvr;

{ Type definitions }

{ From wdu_lib.h }
type
  WDU_DEVICE_HANDLE  = THandle;
  WDU_DRIVER_HANDLE  = THandle;
  PWDU_DRIVER_HANDLE = ^WDU_DRIVER_HANDLE;
  PHANDLE            = ^HANDLE;

{ User Callbacks }
type WDU_ATTACH_CALLBACK = function (hDevice: WDU_DEVICE_HANDLE;
    pDeviceInfo: PWDU_DEVICE; pUserData: PVOID) : Boolean; stdcall;
type WDU_DETACH_CALLBACK = procedure (hDevice: WDU_DEVICE_HANDLE;
    pUserData: PVOID); stdcall;
type WDU_POWER_CHANGE_CALLBACK = function (hDevice: WDU_DEVICE_HANDLE;
    dwPowerState: DWORD; pUserData: PVOID) : Boolean; stdcall;

type
    WDU_EVENT_TABLE = record
        pfDeviceAttach : WDU_ATTACH_CALLBACK;
        pfDeviceDetach : WDU_DETACH_CALLBACK;
        pfPowerChange  : WDU_POWER_CHANGE_CALLBACK;
        pUserData      : PVOID; { pointer to pass in each callback }
end;
type PWDU_EVENT_TABLE = ^WDU_EVENT_TABLE;

{ From wdu_lib.c }

type
    DRIVER_CTX = record
        hWD: HANDLE; { old API WinDriver handle }
        EventTable: WDU_EVENT_TABLE;
        hEvents: HANDLE;
end;
type PDRIVER_CTX = ^DRIVER_CTX;

type
    DEVICE_CTX = record
        pDriverCtx: PDRIVER_CTX;
        pDevice:    PWDU_DEVICE; { not fixed size => pointer }
        dwUniqueID: DWORD;
end;

{ From windrvr_events.h }
type EVENT_HANDLER = procedure (pEvent: PWD_EVENT; pData: PVOID); stdcall;

{ From utils.h }
type HANDLER_FUNC = procedure (pData: PVOID); stdcall;

{ API Functions }

{ From status_strings.h }
function Stat2Str(dwStatus: DWORD) : PCHAR; stdcall; external 'WD_UTILS.DLL';

{ From windrvr_events.h }
function EventRegister(phEvent: PHANDLE; hWD: HANDLE;
    pEvent: PWD_EVENT; pFunc: EVENT_HANDLER; pData: PVOID) : DWORD;
     stdcall; external 'WDUTILS';
function EventUnregister(hEvent: HANDLE) : DWORD; stdcall;
    external 'WD_UTILS.DLL'
function EventAlloc(dwNumMatchTables: DWORD) : PWD_EVENT; stdcall;
    external 'WD_UTILS.DLL'
procedure EventFree(pe: PWD_EVENT); stdcall; external 'WD_UTILS.DLL';
function  EventDup(peSrc: PWD_EVENT) : PWD_EVENT; stdcall;
    external 'WDUTILS';
function UsbEventCreate(pMatchTables: PWDU_MATCH_TABLE;
    dwNumMatchTables: DWORD; dwOptions: DWORD; dwAction: DWORD) : PWD_EVENT;
    stdcall; external 'WD_UTILS.DLL';
function PciEventCreate(cardId: WD_PCI_ID; pciSlot: WD_PCI_SLOT;
    dwOptions: DWORD; dwAction: DWORD) : PWD_EVENT; stdcall;
    external 'WD_UTILS.DLL';

{ From windrvr_int_thread.h: -> add later if needed }

{ From wdu_lib.h }
function WDU_Init(phDriver: PWDU_DRIVER_HANDLE;
    pMatchTables: PWDU_MATCH_TABLE; dwNumMatchTables: DWORD;
    pEventTable: PWDU_EVENT_TABLE; sLicense: string; dwOptions: DWORD) :
        DWORD; stdcall; external 'WD_UTILS.DLL';
procedure WDU_Uninit (hDriver: WDU_DRIVER_HANDLE); stdcall;
    external 'WD_UTILS.DLL';

function WDU_GetDeviceInfo(hDevice: WDU_DEVICE_HANDLE;
    ppDeviceInfo: PPWDU_DEVICE) : DWORD; stdcall; external 'WD_UTILS.DLL';
function WDU_SetInterface(hDevice: WDU_DEVICE_HANDLE; dwInterfaceNum: DWORD;
    dwAlternateSetting: DWORD) : DWORD; stdcall; external 'WD_UTILS.DLL';
function WDU_ResetPipe(hDevice: WDU_DEVICE_HANDLE; dwPipeNum: DWORD): DWORD;
    stdcall; external 'WD_UTILS.DLL';
function WDU_ResetDevice(hDevice: WDU_DEVICE_HANDLE) : DWORD; stdcall;
    external 'WD_UTILS.DLL';

function WDU_Transfer(hDevice: WDU_DEVICE_HANDLE; dwPipeNum: DWORD;
    fRead : DWORD; dwOptions: DWORD; pBuffer: PVOID; dwBufferSize: DWORD;
    pdwBytesTransferred: PDWORD; pSetupPacket: PBYTE; dwTimeout: DWORD)
    : DWORD; stdcall; external 'WD_UTILS.DLL';
function WDU_HaltTransfer(hDevice: WDU_DEVICE_HANDLE; dwPipeNum: DWORD)
    : DWORD; stdcall; external 'WD_UTILS.DLL';

{ simplified transfers }
function WDU_TransferDefaultPipe(hDevice: WDU_DEVICE_HANDLE; fRead: DWORD;
    dwOptions: DWORD; pBuffer: PVOID; dwBufferSize: DWORD;
    pdwBytesTransferred: PDWORD; pSetupPacket: PBYTE; dwTimeout: DWORD)
    : DWORD; stdcall; external 'WD_UTILS.DLL';
function WDU_TransferBulk(hDevice: WDU_DEVICE_HANDLE; dwPipeNum: DWORD;
    fRead: DWORD; dwOptions: DWORD; pBuffer: PVOID; dwBufferSize: DWORD;
    pdwBytesTransferred: PDWORD; dwTimeout: DWORD) : DWORD; stdcall;
    external 'WD_UTILS.DLL';
function WDU_TransferIsoch(hDevice: WDU_DEVICE_HANDLE; dwPipeNum: DWORD;
    fRead: DWORD; dwOptions: DWORD; pBuffer: PVOID; dwBufferSize: DWORD;
    pdwBytesTransferred: PDWORD; dwTimeout: DWORD) : DWORD; stdcall;
    external 'WD_UTILS.DLL';
function WDU_TransferInterrupt(hDevice: WDU_DEVICE_HANDLE; dwPipeNum: DWORD;
    fRead: DWORD; dwOptions: DWORD; pBuffer: PVOID; dwBufferSize: DWORD;
    pdwBytesTransferred: PDWORD; dwTimeout: DWORD) : DWORD; stdcall;
    external 'WD_UTILS.DLL';

{ From utils.h }
function ThreadStart(phThread: PHANDLE; pFunc: HANDLER_FUNC; pData: PVOID)
    : DWORD; stdcall; external 'WD_UTILS.DLL';
procedure ThreadStop(hThread: HANDLE); stdcall; external 'WD_UTILS.DLL';
function OsEventCreate(phOsEvent: PHANDLE) : DWORD; stdcall; external 'WD_UTILS.DLL';
procedure OsEventClose(hOsEvent: HANDLE); stdcall; external 'WD_UTILS.DLL'
function OsEventWait(hOsEvent: HANDLE; dwSecTimeout: DWORD) : DWORD; stdcall;
    external 'WD_UTILS.DLL';
function OsEventSignal(hOsEvent: HANDLE) : DWORD; stdcall; external 'WD_UTILS.DLL';
procedure FreeDllPtr (var ptr : PVOID); stdcall; external 'WD_UTILS.DLL';

implementation
    
end.
