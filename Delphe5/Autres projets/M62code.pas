unit M62code;

interface

uses windows,
     debug0,util1;

function M62_open(instance:integer ):integer;stdCall;
function M62_close(target:integer ):integer;stdCall;
function M62_cardinfo(target:integer ):pointer ;stdCall;
function M62_iicoffld(ch:Pchar; target:integer; hParent:HWND ):integer    ;stdCall;
//
//     dsputil.c
//
function M62_from_ieee(x: single):integer;stdCall;
function M62_to_ieee(i:longword):single  ;stdCall;
//
//     intrpt.c
//
procedure  M62_host_interrupt_install(target:integer; p:pointer; context:pointer);stdCall;
procedure  M62_host_interrupt_deinstall(target:integer );stdCall;
function M62_host_interrupt_enable(target:integer ):BOOL   ;stdCall;
function M62_host_interrupt_disable(target:integer ):BOOL   ;stdCall;
//
//     io.c
//
procedure  M62_outport(target:integer; port:integer; value:integer );stdCall;
function M62_inport(target:integer ; port:integer ):integer ;stdCall;
procedure   M62_opreg_outport(target:integer; port:integer; value:integer );stdCall;
function M62_opreg_inport(target:integer; port:integer ):integer    ;stdCall;
procedure M62_control(target:integer; bit:integer; state:integer );stdCall;
//
//     mbox.c
//
function M62_read_mailbox(target:integer; x:integer):integer    ;stdCall;
procedure  M62_write_mailbox(target:integer; x:integer; y:integer);stdCall;
function M62_check_outbox(target:integer; x:integer):BOOL   ;stdCall;
function M62_check_inbox(target:integer; x:integer):BOOL   ;stdCall;
function M62_read_mb_terminate(target:integer; x:integer; var y:integer ; wide:integer):integer    ;stdCall;
function M62_write_mb_terminate(target:integer; x:integer; value:integer; wide:integer):integer    ;stdCall;
procedure M62_clear_mailboxes(target:integer );stdCall;
function M62_key(target:integer ):integer    ;stdCall;
procedure M62_emit(target:integer; value:integer );stdCall;
procedure M62_Tx(target:integer; value:integer );stdCall;
function M62_Rx(target:integer ):integer    ;stdCall;
procedure M62_get_semaphore(target:integer; semaphore:integer );stdCall;
//
//     special.c
//
procedure  M62_reset(target:integer );stdCall;
procedure  M62_run(target:integer );stdCall;
procedure  M62_interrupt(target:integer );stdCall;
procedure  M62_request_semaphore(target:integer; semaphore:integer );stdCall;
function M62_own_semaphore(target:integer ; semaphore:integer ):BOOL         ;stdCall;
procedure  M62_release_semaphore(target:integer; semaphore:integer );stdCall;
procedure  M62_mailbox_interrupt(target:integer; value:longword);stdCall;
function M62_mailbox_interrupt_ack(target:integer ):longword ;stdCall;
function M62_set_baudrate(target:integer; baudrate:integer ):BOOL         ;stdCall;
function M62_get_baudrate(target:integer ):integer          ;stdCall;

//
//     talker.c
//
function M62_check(target:integer ):integer    ;stdCall;
procedure  M62_start_app(target:integer );stdCall;
function M62_start_talker(target:integer ):integer    ;stdCall;
function M62_talker_revision(target:integer ):integer    ;stdCall;
function M62_talker_read_memory(target:integer; page:integer; address:integer ):integer    ;stdCall;
procedure  M62_talker_write_memory(target:integer; page:integer; address:integer; value:integer );stdCall;
function M62_talker_fetch(target:integer ;address:integer ):integer    ;stdCall;
procedure  M62_talker_store(target:integer; address:integer; value:integer );stdCall;
procedure  M62_talker_section(target:integer; page:integer; address:integer; count:integer );stdCall;
procedure  M62_talker_download(target:integer; address:integer; count:integer );stdCall;
procedure  M62_talker_launch(target:integer; address:integer );stdCall;
procedure  M62_talker_resume(target:integer );stdCall;
function M62_talker_registers(target:integer ):integer    ;stdCall;
procedure M62_slow(target:integer );stdCall;
procedure M62_fast(target:integer );stdCall;
procedure M62_talker_sector_erase(target:integer; sector:integer );stdCall;
procedure M62_flash_sector_erase(target:integer; sector:integer );stdCall;
procedure M62_flash_init(target:integer );stdCall;
procedure M62_flash_offset(target:integer; offset:integer );stdCall;

type
  BULK_HANDLE=pointer;
  HANDLE=integer;

// Generic operations:
function BULK_GetNumDevices:integer ;stdCall;

// Device operations:
function BULK_OpenDevice(iDevice:integer; var phDevice: HANDLE ):BOOL ;stdCall;
function BULK_CloseDevice(var hDevice:HANDLE):BOOL ;stdCall;
function BULK_GetNumChannels(var hDevice:HANDLE ):integer  ;stdCall;


// Pipe operations:
function BULK_OpenChannel(   iDevice:integer ;
                             wChannel:WORD ;
                             fOverlapped:BOOL ;
                             var pHandle:BULK_HANDLE):BOOL;stdCall;
function BULK_CloseChannel(Handle:BULK_HANDLE ):BOOL ;stdCall;
function BULK_Read(      Handle:BULK_HANDLE    ;           // handle of file to read
                         lpBuffer:pointer ;             // pointer to buffer that receives data
                         dwNumberOfBytesToRead:DWORD ;     // number of bytes to read
                         var NumberOfBytesRead:DWORD ;    // pointer to number of bytes read
                         lpOverlapped:pointer    // pointer to structure for data);
                         ):BOOL;stdCall;
function BULK_Write(
                          Handle:BULK_HANDLE ;             // handle of file to read
                          lpBuffer:pointer;                // pointer to data to write to file
                          dwNumberOfBytesToWrite:DWORD;    // number of bytes to write
                          var lpNumberOfBytesWritten:LPDWORD; // pointer to number of bytes written
                          lpOverlapped:pointer    // pointer to structure for overlapped I/O);
                          ):BOOL;stdCall;
function BULK_GetOverlappedReadResult(
                                        Handle:BULK_HANDLE  ;              // handle of file to read
                                        lpOverlapped:pointer;       // address of overlapped structure
                                        var lpNumberOfBytesTransferred:DWORD;
                                        bWait:BOOL    ):BOOL;stdCall;

function BULK_GetOverlappedWriteResult(
                                         Handle:BULK_HANDLE ;            // handle of file to read
                                         lpOverlapped:pointer;       // address of overlapped structure
                                         var lpNumberOfBytesTransferred:DWORD;
                                         bWait:BOOL    ):BOOL;stdCall;

function BULK_CancelIo( Handle:BULK_HANDLE  ):BOOL ;stdCall;


function STREAM_Open(
                             iDevice:integer;
                             wChannel:WORD ;
                             wBufferSize:WORD ;
                             wBlockSize:WORD ;
                             var pHandle:BULK_HANDLE  ):BOOL;stdCall;

function STREAM_Close(  handle:BULK_HANDLE  ):BOOL ;stdCall;

function STREAM_ReadAvailable(  handle:BULK_HANDLE  ):WORD ;stdCall;
function STREAM_WriteAvailable( handle:BULK_HANDLE  ):WORD ;stdCall;
function STREAM_Write( handle:BULK_HANDLE; pBuffer:pointer; wElementCount:WORD  ):WORD ;stdCall;
procedure STREAM_Read( handle:BULK_HANDLE ; pBuffer:pointer; wElementCount:WORD  );stdCall;
procedure STREAM_Flush( handle:BULK_HANDLE  );stdCall;

function USB_VendorCommand(   hDevice:HANDLE   ;
                              bRequest:BYTE    ;
                              wIndex:WORD     ;
                              wValue:WORD     ;
                              lpBuffer:pointer ;
                              wLength:WORD     ;
                              fTransferDirectionIN:BOOL ;
                              var pNumberOfBytesTransferred:DWORD   ;
                              var pdwUSBD_Status:DWORD ):BOOL;stdCall;


implementation



function M62_open(instance:integer ):integer;
begin
  result:=1;
  affdebug('M62_open instance='+IStr(instance),1);
end;

function M62_close(target:integer ):integer;
begin
  result:=1;
  affdebug('M62_close',1);
end;

function M62_cardinfo(target:integer ):pointer ;
begin
  result:=nil;
  affdebug('M62_cardinfo',1);
end;

function M62_iicoffld(ch:Pchar; target:integer; hParent:HWND ):integer    ;
var
  st:string[255];
begin
  result:=0;
  st:=ch;
  affdebug('M62_iicoffld  File='+st,1);
end;

//
//     dsputil.c
//
function M62_from_ieee(x: single):integer;
begin
  affdebug('M62_from_ieee',1);
end;

function M62_to_ieee(i:longword):single  ;
begin
  affdebug('M62_to_ieee',1);
end;

//
//     intrpt.c
//
procedure  M62_host_interrupt_install(target:integer; p:pointer; context:pointer);
begin
  affdebug('M62_host_interrupt_install target='+Istr(target)+'  p='+chainehexa(p)+'  context='+chaineHexa(context),1);
end;

procedure  M62_host_interrupt_deinstall(target:integer );
begin
  affdebug('M62_host_interrupt_deinstall',1);
end;

function M62_host_interrupt_enable(target:integer ):BOOL   ;
begin
  result:=true;
  affdebug('M62_host_interrupt_enable',1);
end;

function M62_host_interrupt_disable(target:integer ):BOOL   ;
begin
  result:=true;
  affdebug('M62_host_interrupt_disable',1);
end;

//
//     io.c
//
procedure  M62_outport(target:integer; port:integer; value:integer );
begin
  affdebug('M62_outport',1);
end;

function M62_inport(target:integer ; port:integer ):integer ;
begin
  affdebug('M62_inport',1);
end;

procedure   M62_opreg_outport(target:integer; port:integer; value:integer );
begin
  affdebug('M62_opreg_outport',1);
end;

function M62_opreg_inport(target:integer; port:integer ):integer    ;
begin
  affdebug('M62_opreg_inport',1);
end;

procedure M62_control(target:integer; bit:integer; state:integer );
begin
  affdebug('M62_control',1);
end;

//
//     mbox.c
//
function M62_read_mailbox(target:integer; x:integer):integer    ;
begin
  affdebug('M62_read_mailbox',1);
end;

procedure  M62_write_mailbox(target:integer; x:integer; y:integer);
begin
  affdebug('M62_write_mailbox '+Istr(x)+'  '+Istr(y),1);
end;

function M62_check_outbox(target:integer; x:integer):BOOL   ;
begin
  affdebug('M62_check_outbox',1);
end;

function M62_check_inbox(target:integer; x:integer):BOOL   ;
begin
  affdebug('M62_check_inbox',1);
end;

function M62_read_mb_terminate(target:integer; x:integer; var y: integer ; wide:integer):integer    ;
var
  yb:byte absolute y;
begin
  case wide of
    1: yb:=1;
    4: y:=1;
  end;
  y:=$0a5a5;
  result:=0;
  affdebug('M62_read_mb_terminate',1);
end;

function M62_write_mb_terminate(target:integer; x:integer; value:integer; wide:integer):integer    ;
begin
  affdebug('M62_write_mb_terminate',1);
end;

procedure M62_clear_mailboxes(target:integer );
begin
  affdebug('M62_clear_mailboxes',1);
end;

function M62_key(target:integer ):integer    ;
begin
  affdebug('M62_key',1);
end;

procedure M62_emit(target:integer; value:integer );
begin
  affdebug('M62_emit',1);
end;

procedure M62_Tx(target:integer; value:integer );
begin
  affdebug('M62_Tx',1);
end;

function M62_Rx(target:integer ):integer    ;
begin
  affdebug('M62_Rx',1);
end;

procedure M62_get_semaphore(target:integer; semaphore:integer );
begin
  affdebug('M62_get_semaphore',1);
end;

//
//     special.c
//
procedure  M62_reset(target:integer );
begin
  affdebug('M62_reset',1);
end;

procedure  M62_run(target:integer );
begin
  affdebug('M62_run',1);
end;

procedure  M62_interrupt(target:integer );
begin
  affdebug('M62_interrupt',1);
end;

procedure  M62_request_semaphore(target:integer; semaphore:integer );
begin
  affdebug('M62_request_semaphore',1);
end;

function M62_own_semaphore(target:integer ; semaphore:integer ):BOOL         ;
begin
  affdebug('M62_own_semaphore',1);
end;

procedure  M62_release_semaphore(target:integer; semaphore:integer );
begin
  affdebug('M62_release_semaphore',1);
end;

procedure  M62_mailbox_interrupt(target:integer; value:longword);
begin
  affdebug('M62_mailbox_interrupt',1);
end;

function M62_mailbox_interrupt_ack(target:integer ):longword ;
begin
  affdebug('M62_mailbox_interrupt_ack',1);
end;

function M62_set_baudrate(target:integer; baudrate:integer ):BOOL         ;
begin
  affdebug('M62_set_baudrate',1);
end;

function M62_get_baudrate(target:integer ):integer          ;
begin
  affdebug('M62_get_baudrate',1);
end;


//
//     talker.c
//
function M62_check(target:integer ):integer    ;
begin
  affdebug('M62_check',1);
end;

procedure  M62_start_app(target:integer );
begin
  affdebug('M62_start_app',1);
end;

function M62_start_talker(target:integer ):integer    ;
begin
  result:=1;
  affdebug('M62_start_talker',1);
end;

function M62_talker_revision(target:integer ):integer    ;
begin
  affdebug('M62_talker_revision',1);
end;

function M62_talker_read_memory(target:integer; page:integer; address:integer ):integer    ;
begin
  affdebug('M62_talker_read_memory',1);
end;

procedure  M62_talker_write_memory(target:integer; page:integer; address:integer; value:integer );
begin
  affdebug('M62_talker_write_memory',1);
end;

function M62_talker_fetch(target:integer ;address:integer ):integer    ;
begin
  affdebug('M62_talker_fetch',1);
end;

procedure  M62_talker_store(target:integer; address:integer; value:integer );
begin
  affdebug('M62_talker_store',1);
end;

procedure  M62_talker_section(target:integer; page:integer; address:integer; count:integer );
begin
  affdebug('M62_talker_section',1);
end;

procedure  M62_talker_download(target:integer; address:integer; count:integer );
begin
  affdebug('M62_talker_download',1);
end;

procedure  M62_talker_launch(target:integer; address:integer );
begin
  affdebug('M62_talker_launch',1);
end;

procedure  M62_talker_resume(target:integer );
begin
  affdebug('M62_talker_resume',1);
end;

function M62_talker_registers(target:integer ):integer    ;
begin
  affdebug('M62_talker_registers',1);
end;

procedure M62_slow(target:integer );
begin
  affdebug('M62_slow',1);
end;

procedure M62_fast(target:integer );
begin
  affdebug('M62_fast',1);
end;

procedure M62_talker_sector_erase(target:integer; sector:integer );
begin
  affdebug('M62_talker_sector_erase',1);
end;

procedure M62_flash_sector_erase(target:integer; sector:integer );
begin
  affdebug('M62_flash_sector_erase',1);
end;

procedure M62_flash_init(target:integer );
begin
  affdebug('M62_flash_init',1);
end;

procedure M62_flash_offset(target:integer; offset:integer );
begin
  affdebug('M62_flash_offset',1);
end;


// Generic operations:
function BULK_GetNumDevices:integer ;
begin
  affdebug('Generic',1);
end;


// Device operations:
function BULK_OpenDevice(iDevice:integer; var phDevice: HANDLE ):BOOL ;
begin
  affdebug('BULK_OpenDevice',1);
end;

function BULK_CloseDevice(var hDevice:HANDLE):BOOL ;
begin
  affdebug('BULK_CloseDevice',1);
end;

function BULK_GetNumChannels(var hDevice:HANDLE ):integer  ;
begin
  affdebug('BULK_GetNumChannels',1);
end;



// Pipe operations:
function BULK_OpenChannel(   iDevice:integer ;
                             wChannel:WORD ;
                             fOverlapped:BOOL ;
                             var pHandle:BULK_HANDLE):BOOL;
begin
  affdebug('BULK_OpenChannel',1);
end;

function BULK_CloseChannel(Handle:BULK_HANDLE ):BOOL ;
begin
  affdebug('BULK_CloseChannel',1);
end;

function BULK_Read(      Handle:BULK_HANDLE    ;           // handle of file to read
                         lpBuffer:pointer ;             // pointer to buffer that receives data
                         dwNumberOfBytesToRead:DWORD ;     // number of bytes to read
                         var NumberOfBytesRead:DWORD ;    // pointer to number of bytes read
                         lpOverlapped:pointer    // pointer to structure for data);
                         ):BOOL;
begin
  affdebug('BULK_Read',1);
end;

function BULK_Write(
                          Handle:BULK_HANDLE ;             // handle of file to read
                          lpBuffer:pointer;                // pointer to data to write to file
                          dwNumberOfBytesToWrite:DWORD;    // number of bytes to write
                          var lpNumberOfBytesWritten:LPDWORD; // pointer to number of bytes written
                          lpOverlapped:pointer    // pointer to structure for overlapped I/O);
                          ):BOOL;
begin
  affdebug('BULK_Write',1);
end;

function BULK_GetOverlappedReadResult(
                                        Handle:BULK_HANDLE  ;              // handle of file to read
                                        lpOverlapped:pointer;       // address of overlapped structure
                                        var lpNumberOfBytesTransferred:DWORD;
                                        bWait:BOOL    ):BOOL;
begin
  affdebug('BULK_GetOverlappedReadResult',1);
end;

function BULK_GetOverlappedWriteResult(
                                         Handle:BULK_HANDLE ;            // handle of file to read
                                         lpOverlapped:pointer;       // address of overlapped structure
                                         var lpNumberOfBytesTransferred:DWORD;
                                         bWait:BOOL    ):BOOL;
begin
  affdebug('BULK_GetOverlappedWriteResult',1);
end;

function BULK_CancelIo( Handle:BULK_HANDLE  ):BOOL ;
begin
  affdebug('BULK_CancelIo(',1);
end;



function STREAM_Open(
                             iDevice:integer;
                             wChannel:WORD ;
                             wBufferSize:WORD ;
                             wBlockSize:WORD ;
                             var pHandle:BULK_HANDLE  ):BOOL;
begin
  affdebug('STREAM_Open',1);
end;

function STREAM_Close(  handle:BULK_HANDLE  ):BOOL ;
begin
  affdebug('STREAM_Close(',1);
end;


function STREAM_ReadAvailable(  handle:BULK_HANDLE  ):WORD ;
begin
  affdebug('STREAM_ReadAvailable(',1);
end;

function STREAM_WriteAvailable( handle:BULK_HANDLE  ):WORD ;
begin
  affdebug('STREAM_WriteAvailable(',1);
end;

function STREAM_Write( handle:BULK_HANDLE; pBuffer:pointer; wElementCount:WORD  ):WORD ;
begin
  affdebug('STREAM_Write(',1);
end;

procedure STREAM_Read( handle:BULK_HANDLE ; pBuffer:pointer; wElementCount:WORD  );
begin
  affdebug('STREAM_Read(',1);
end;

procedure STREAM_Flush( handle:BULK_HANDLE  );
begin
  affdebug('STREAM_Flush(',1);
end;


function USB_VendorCommand(   hDevice:HANDLE   ;
                              bRequest:BYTE    ;
                              wIndex:WORD     ;
                              wValue:WORD     ;
                              lpBuffer:pointer ;
                              wLength:WORD     ;
                              fTransferDirectionIN:BOOL ;
                              var pNumberOfBytesTransferred:DWORD   ;
                              var pdwUSBD_Status:DWORD ):BOOL;
begin
  affdebug('USB_VendorCommand',1);
end;

initialization
  debugGroups:=[1];
end.
