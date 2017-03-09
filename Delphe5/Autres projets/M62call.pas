unit M62call;

interface


uses windows,
     debug0,util1;


type
  TvirtualISR=procedure(p:pointer);cdecl;
var

M62_open: function (instance:integer ):integer;stdCall;
M62_close: function (target:integer ):integer;stdCall;
M62_cardinfo: function (target:integer ):pointer ;stdCall;
M62_iicoffld: function (ch:Pchar; target:integer; hParent:HWND ):integer    ;stdCall;
//
//     dsputil.c
//
M62_from_ieee: function (x: single):integer;stdCall;
M62_to_ieee: function (i:longword):single  ;stdCall;
//
//     intrpt.c
//
M62_host_interrupt_install: procedure  (target:integer; p:TvirtualISR; context:pointer);stdCall;
M62_host_interrupt_deinstall: procedure  (target:integer );stdCall;
M62_host_interrupt_enable: function (target:integer ):BOOL   ;stdCall;
M62_host_interrupt_disable: function (target:integer ):BOOL   ;stdCall;
//
//     io.c
//
M62_outport: procedure  (target:integer; port:integer; value:integer );stdCall;
M62_inport: function (target:integer ; port:integer ):integer ;stdCall;
M62_opreg_outport: procedure   (target:integer; port:integer; value:integer );stdCall;
M62_opreg_inport: function (target:integer; port:integer ):integer    ;stdCall;
M62_control: procedure (target:integer; bit:integer; state:integer );stdCall;
//
//     mbox.c
//
M62_read_mailbox: function (target:integer; x:integer):integer    ;stdCall;
M62_write_mailbox: procedure  (target:integer; x:integer; y:integer);stdCall;
M62_check_outbox: function (target:integer; x:integer):BOOL   ;stdCall;
M62_check_inbox: function (target:integer; x:integer):BOOL   ;stdCall;
M62_read_mb_terminate: function (target:integer; x:integer; var y:integer ; wide:integer):integer    ;stdCall;
M62_write_mb_terminate: function (target:integer; x:integer; value:integer; wide:integer):integer    ;stdCall;
M62_clear_mailboxes: procedure (target:integer );stdCall;
M62_key: function (target:integer ):integer    ;stdCall;
M62_emit: procedure (target:integer; value:integer );stdCall;
M62_Tx: procedure (target:integer; value:integer );stdCall;
M62_Rx: function (target:integer ):integer    ;stdCall;
M62_get_semaphore: procedure (target:integer; semaphore:integer );stdCall;
//
//     special.c
//
M62_reset: procedure  (target:integer );stdCall;
M62_run: procedure  (target:integer );stdCall;
M62_interrupt: procedure  (target:integer );stdCall;
M62_request_semaphore: procedure  (target:integer; semaphore:integer );stdCall;
M62_own_semaphore: function (target:integer ; semaphore:integer ):BOOL         ;stdCall;
M62_release_semaphore: procedure  (target:integer; semaphore:integer );stdCall;
M62_mailbox_interrupt: procedure  (target:integer; value:longword);stdCall;
M62_mailbox_interrupt_ack: function (target:integer ):longword ;stdCall;
M62_set_baudrate: function (target:integer; baudrate:integer ):BOOL         ;stdCall;
M62_get_baudrate: function (target:integer ):integer          ;stdCall;

//
//     talker.c
//
M62_check: function (target:integer ):integer    ;stdCall;
M62_start_app: procedure  (target:integer );stdCall;
M62_start_talker: function (target:integer ):integer    ;stdCall;
M62_talker_revision: function (target:integer ):integer    ;stdCall;
M62_talker_read_memory: function (target:integer; page:integer; address:integer ):integer    ;stdCall;
M62_talker_write_memory: procedure  (target:integer; page:integer; address:integer; value:integer );stdCall;
M62_talker_fetch: function (target:integer ;address:integer ):integer    ;stdCall;
M62_talker_store: procedure  (target:integer; address:integer; value:integer );stdCall;
M62_talker_section: procedure  (target:integer; page:integer; address:integer; count:integer );stdCall;
M62_talker_download: procedure  (target:integer; address:integer; count:integer );stdCall;
M62_talker_launch: procedure  (target:integer; address:integer );stdCall;
M62_talker_resume: procedure  (target:integer );stdCall;
M62_talker_registers: function (target:integer ):integer    ;stdCall;
M62_slow: procedure (target:integer );stdCall;
M62_fast: procedure (target:integer );stdCall;
M62_talker_sector_erase: procedure (target:integer; sector:integer );stdCall;
M62_flash_sector_erase: procedure (target:integer; sector:integer );stdCall;
M62_flash_init: procedure (target:integer );stdCall;
M62_flash_offset: procedure (target:integer; offset:integer );stdCall;

type
  BULK_HANDLE=pointer;
  HANDLE=integer;

var
// Generic operations:
BULK_GetNumDevices: function :integer ;stdCall;

// Device operations:
BULK_OpenDevice: function (iDevice:integer; var phDevice: HANDLE ):BOOL ;stdCall;
BULK_CloseDevice: function (var hDevice:HANDLE):BOOL ;stdCall;
BULK_GetNumChannels: function (var hDevice:HANDLE ):integer  ;stdCall;


// Pipe operations:
BULK_OpenChannel : function( iDevice:integer ;
                             wChannel:WORD ;
                             fOverlapped:BOOL ;
                             var pHandle:BULK_HANDLE):BOOL;stdCall;
BULK_CloseChannel: function (Handle:BULK_HANDLE ):BOOL ;stdCall;
BULK_Read: function (     Handle:BULK_HANDLE    ;           // handle of file to read
                         lpBuffer:pointer ;             // pointer to buffer that receives data
                         dwNumberOfBytesToRead:DWORD ;     // number of bytes to read
                         var NumberOfBytesRead:DWORD ;    // pointer to number of bytes read
                         lpOverlapped:pointer    // pointer to structure for data);
                         ):BOOL;stdCall;
BULK_Write: function (
                          Handle:BULK_HANDLE ;             // handle of file to read
                          lpBuffer:pointer;                // pointer to data to write to file
                          dwNumberOfBytesToWrite:DWORD;    // number of bytes to write
                          var lpNumberOfBytesWritten:LPDWORD; // pointer to number of bytes written
                          lpOverlapped:pointer    // pointer to structure for overlapped I/O);
                          ):BOOL;stdCall;
BULK_GetOverlappedReadResult: function (
                                        Handle:BULK_HANDLE  ;              // handle of file to read
                                        lpOverlapped:pointer;       // address of overlapped structure
                                        var lpNumberOfBytesTransferred:DWORD;
                                        bWait:BOOL    ):BOOL;stdCall;

BULK_GetOverlappedWriteResult: function (
                                         Handle:BULK_HANDLE ;            // handle of file to read
                                         lpOverlapped:pointer;       // address of overlapped structure
                                         var lpNumberOfBytesTransferred:DWORD;
                                         bWait:BOOL    ):BOOL;stdCall;

BULK_CancelIo: function ( Handle:BULK_HANDLE  ):BOOL ;stdCall;


STREAM_Open: function (
                             iDevice:integer;
                             wChannel:WORD ;
                             wBufferSize:WORD ;
                             wBlockSize:WORD ;
                             var pHandle:BULK_HANDLE  ):BOOL;stdCall;

STREAM_Close : function ( handle:BULK_HANDLE  ):BOOL ;stdCall;

STREAM_ReadAvailable : function ( handle:BULK_HANDLE  ):WORD ;stdCall;
STREAM_WriteAvailable: function ( handle:BULK_HANDLE  ):WORD ;stdCall;
STREAM_Write: function ( handle:BULK_HANDLE; pBuffer:pointer; wElementCount:WORD  ):WORD ;stdCall;
STREAM_Read: procedure ( handle:BULK_HANDLE ; pBuffer:pointer; wElementCount:WORD  );stdCall;
STREAM_Flush: procedure ( handle:BULK_HANDLE  );stdCall;

USB_VendorCommand : function( hDevice:HANDLE   ;
                              bRequest:BYTE    ;
                              wIndex:WORD     ;
                              wValue:WORD     ;
                              lpBuffer:pointer ;
                              wLength:WORD     ;
                              fTransferDirectionIN:BOOL ;
                              var pNumberOfBytesTransferred:DWORD   ;
                              var pdwUSBD_Status:DWORD ):BOOL;stdCall;


function InitM62lib:boolean;


implementation

const
  hh:integer=0;

function getProc(st:string):pointer;
begin
  result:=GetProcAddress(hh,Pchar(st));
  if result=nil then messageCentral(st+'=nil');
end;


function InitM62lib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=loadLibrary('M62dll.DLL');
  result:=(hh<>0);

  if not result then exit;

  M62_open:= getProc('M62_open');
  M62_close:= getProc('M62_close');
  M62_cardinfo:= getProc('M62_cardinfo');
  M62_reset:= getProc('M62_reset');
  M62_run:= getProc('M62_run');
  M62_read_mailbox:= getProc('M62_read_mailbox');
  M62_write_mailbox:= getProc('M62_write_mailbox');
  M62_start_app:= getProc('M62_start_app');
  M62_check_outbox:= getProc('M62_check_outbox');
  M62_check_inbox:= getProc('M62_check_inbox');
  M62_read_mb_terminate:= getProc('M62_read_mb_terminate');
  M62_write_mb_terminate:= getProc('M62_write_mb_terminate');
  M62_iicoffld:= getProc('M62_iicoffld');
  M62_clear_mailboxes:= getProc('M62_clear_mailboxes');
  M62_start_talker:= getProc('M62_start_talker');
  M62_interrupt:= getProc('M62_interrupt');
  M62_host_interrupt_enable:= getProc('M62_host_interrupt_enable');
  M62_host_interrupt_disable:= getProc('M62_host_interrupt_disable');
  M62_host_interrupt_install:= getProc('M62_host_interrupt_install');
  M62_host_interrupt_deinstall:= getProc('M62_host_interrupt_deinstall');
  M62_mailbox_interrupt:= getProc('M62_mailbox_interrupt');
  M62_mailbox_interrupt_ack:= getProc('M62_mailbox_interrupt_ack');
  M62_check:= getProc('M62_check');
  M62_talker_fetch:= getProc('M62_talker_fetch');
  M62_talker_store:= getProc('M62_talker_store');
  M62_talker_read_memory:= getProc('M62_talker_read_memory');
  M62_talker_write_memory:= getProc('M62_talker_write_memory');
  M62_talker_section:= getProc('M62_talker_section');
  M62_talker_download:= getProc('M62_talker_download');
  M62_talker_launch:= getProc('M62_talker_launch');
  M62_talker_resume:= getProc('M62_talker_resume');
  M62_talker_registers:= getProc('M62_talker_registers');
  M62_opreg_outport:= getProc('M62_opreg_outport');
  M62_opreg_inport:= getProc('M62_opreg_inport');
  M62_outport:= getProc('M62_outport');
  M62_inport:= getProc('M62_inport');
  M62_from_ieee:= getProc('M62_from_ieee');
  M62_to_ieee:= getProc('M62_to_ieee');
  M62_key:= getProc('M62_key');
  M62_emit:= getProc('M62_emit');
  M62_Tx:= getProc('M62_Tx');
  M62_Rx:= getProc('M62_Rx');
  M62_control:= getProc('M62_control');
  M62_get_semaphore:= getProc('M62_get_semaphore');
  M62_request_semaphore:= getProc('M62_request_semaphore');
  M62_own_semaphore:= getProc('M62_own_semaphore');
  M62_release_semaphore:= getProc('M62_release_semaphore');
  M62_slow:= getProc('M62_slow');
  M62_fast:= getProc('M62_fast');
  M62_talker_sector_erase:= getProc('M62_talker_sector_erase');
  M62_flash_sector_erase:= getProc('M62_flash_sector_erase');
  M62_flash_init:= getProc('M62_flash_init');
  M62_flash_offset:= getProc('M62_flash_offset');
  M62_talker_revision:= getProc('M62_talker_revision');
end;


end.
