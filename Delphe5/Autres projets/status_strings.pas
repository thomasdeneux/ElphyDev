{
 ----------------------------------------------------------------
  File - STATUS_STRINGS.PAS
 
  Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com 
 ----------------------------------------------------------------
}

unit status_strings;
interface
uses
    Windows, windrvr;

function Stat2Str(dwStatus : DWORD) : String;

implementation
function Stat2Str(dwStatus : DWORD) : String;
begin
  if dwStatus=WD_STATUS_SUCCESS then begin Stat2Str:='Success'; Exit; end;
  if dwStatus=WD_STATUS_INVALID_WD_HANDLE then begin Stat2Str:='Invalid WinDriver handle'; Exit; end;
  if dwStatus=WD_WINDRIVER_STATUS_ERROR then begin Stat2Str:='Error'; Exit; end;
  if dwStatus=WD_INVALID_HANDLE then begin Stat2Str:='Invalid handle'; Exit; end;
  if dwStatus=WD_INVALID_PIPE_NUMBER then begin Stat2Str:='Invalid pipe number'; Exit; end;
  if dwStatus=WD_READ_WRITE_CONFLICT then begin Stat2Str:='Conflict between read and write operations'; Exit; end;
  if dwStatus=WD_ZERO_PACKET_SIZE then begin Stat2Str:='Packet size is zero'; Exit; end;
  if dwStatus=WD_INSUFFICIENT_RESOURCES then begin Stat2Str:='Insufficient resources'; Exit; end;
  if dwStatus=WD_UNKNOWN_PIPE_TYPE then begin Stat2Str:='Unknown pipe type'; Exit; end;
  if dwStatus=WD_SYSTEM_INTERNAL_ERROR then begin Stat2Str:='Intenal system error'; Exit; end;
  if dwStatus=WD_DATA_MISMATCH then begin Stat2Str:='Data mismatch'; Exit; end;
  if dwStatus=WD_NO_LICENSE then begin Stat2Str:='No valid license'; Exit; end;
  if dwStatus=WD_INVALID_PARAMETER then begin Stat2Str:='Invalid parameter'; Exit; end;
  if dwStatus=WD_NOT_IMPLEMENTED then begin Stat2Str:='Function not implemented'; Exit; end;
  if dwStatus=WD_KERPLUG_FAILURE then begin Stat2Str:='KernelPlugin failure'; Exit; end;
  if dwStatus=WD_FAILED_ENABLING_INTERRUPT then begin Stat2Str:='Failed enabling interrupt'; Exit; end;
  if dwStatus=WD_INTERRUPT_NOT_ENABLED then begin Stat2Str:='Interrupt not enabled'; Exit; end;
  if dwStatus=WD_RESOURCE_OVERLAP then begin Stat2Str:='Resource overlap'; Exit; end;
  if dwStatus=WD_DEVICE_NOT_FOUND then begin Stat2Str:='Device not found'; Exit; end;
  if dwStatus=WD_WRONG_UNIQUE_ID then begin Stat2Str:='Wrong unique ID'; Exit; end;
  if dwStatus=WD_OPERATION_ALREADY_DONE then begin Stat2Str:='Operation already done'; Exit; end;
  if dwStatus=WD_INTERFACE_DESCRIPTOR_ERROR then begin Stat2Str:='Interface descriptor error'; Exit; end;
  if dwStatus=WD_SET_CONFIGURATION_FAILED then begin Stat2Str:='Set configuration operation failed'; Exit; end;
  if dwStatus=WD_CANT_OBTAIN_PDO then begin Stat2Str:='Cannot obtain PDO'; Exit; end;
  if dwStatus=WD_TIME_OUT_EXPIRED then begin Stat2Str:='TimeOut expired'; Exit; end;
  if dwStatus=WD_IRP_CANCELED then begin Stat2Str:='IRP operation cancelled'; Exit; end;
  if dwStatus=WD_FAILED_USER_MAPPING then begin Stat2Str:='Failed to map in user space'; Exit; end;
  if dwStatus=WD_FAILED_KERNEL_MAPPING then begin Stat2Str:='Failed to map in kernel space'; Exit; end;
  if dwStatus=WD_NO_RESOURCES_ON_DEVICE then begin Stat2Str:='No resources on the device'; Exit; end;
  if dwStatus=WD_NO_EVENTS then begin Stat2Str:='No events'; Exit; end;
  if dwStatus=WD_USBD_STATUS_SUCCESS then begin Stat2Str:='USBD: Success'; Exit; end;
  if dwStatus=WD_USBD_STATUS_PENDING then begin Stat2Str:='USBD: Operation pending'; Exit; end;
  if dwStatus=WD_USBD_STATUS_ERROR then begin Stat2Str:='USBD: Error'; Exit; end;
  if dwStatus=WD_USBD_STATUS_HALTED then begin Stat2Str:='USBD: Halted'; Exit; end;
  if dwStatus=WD_USBD_STATUS_CRC then begin Stat2Str:='HC status: CRC'; Exit; end;
  if dwStatus=WD_USBD_STATUS_BTSTUFF then begin Stat2Str:='HC status: Bit stuffing '; Exit; end;
  if dwStatus=WD_USBD_STATUS_DATA_TOGGLE_MISMATCH then begin Stat2Str:='HC status: Data toggle mismatch'; Exit; end;
  if dwStatus=WD_USBD_STATUS_STALL_PID then begin Stat2Str:='HC status: PID stall'; Exit; end;
  if dwStatus=WD_USBD_STATUS_DEV_NOT_RESPONDING then begin Stat2Str:='HC status: Device not responding'; Exit; end;
  if dwStatus=WD_USBD_STATUS_PID_CHECK_FAILURE then begin Stat2Str:='HC status: PID check failed'; Exit; end;
  if dwStatus=WD_USBD_STATUS_UNEXPECTED_PID then begin Stat2Str:='HC status: Unexpected PID'; Exit; end;
  if dwStatus=WD_USBD_STATUS_DATA_OVERRUN then begin Stat2Str:='HC status: Data overrun'; Exit; end;
  if dwStatus=WD_USBD_STATUS_DATA_UNDERRUN then begin Stat2Str:='HC status: Data underrun'; Exit; end;
  if dwStatus=WD_USBD_STATUS_RESERVED1 then begin Stat2Str:='HC status: Reserved1'; Exit; end;
  if dwStatus=WD_USBD_STATUS_RESERVED2 then begin Stat2Str:='HC status: Reserved2'; Exit; end;
  if dwStatus=WD_USBD_STATUS_BUFFER_OVERRUN then begin Stat2Str:='HC status: Buffer overrun'; Exit; end;
  if dwStatus=WD_USBD_STATUS_BUFFER_UNDERRUN then begin Stat2Str:='HC status: Buffer Underrun'; Exit; end;
  if dwStatus=WD_USBD_STATUS_NOT_ACCESSED then begin Stat2Str:='HC status: Not accessed'; Exit; end;
  if dwStatus=WD_USBD_STATUS_FIFO then begin Stat2Str:='HC status: Fifo'; Exit; end;
  if dwStatus=WD_USBD_STATUS_ENDPOINT_HALTED then begin Stat2Str:='HCD: Trasnfer submitted to stalled endpoint'; Exit; end;
  if dwStatus=WD_USBD_STATUS_NO_MEMORY then begin Stat2Str:='USBD: Out of memory'; Exit; end;
  if dwStatus=WD_USBD_STATUS_INVALID_URB_FUNCTION then begin Stat2Str:='USBD: Invalid URB function'; Exit; end;
  if dwStatus=WD_USBD_STATUS_INVALID_PARAMETER then begin Stat2Str:='USBD: Invalid parameter'; Exit; end;
  if dwStatus=WD_USBD_STATUS_ERROR_BUSY then begin Stat2Str:='USBD: Attempted to close enpoint/interface/configuration with outstanding transfer'; Exit; end;
  if dwStatus=WD_USBD_STATUS_REQUEST_FAILED then begin Stat2Str:='USBD: URB request failed'; Exit; end;
  if dwStatus=WD_USBD_STATUS_INVALID_PIPE_HANDLE then begin Stat2Str:='USBD: Invalid pipe handle'; Exit; end;
  if dwStatus=WD_USBD_STATUS_NO_BANDWIDTH then begin Stat2Str:='USBD: Not enough bandwidth for endpoint'; Exit; end;
  if dwStatus=WD_USBD_STATUS_INTERNAL_HC_ERROR then begin Stat2Str:='USBD: Host controller error'; Exit; end;
  if dwStatus=WD_USBD_STATUS_ERROR_SHORT_TRANSFER then begin Stat2Str:='USBD: Trasnfer terminated with short packet'; Exit; end;
  if dwStatus=WD_USBD_STATUS_BAD_START_FRAME then begin Stat2Str:='USBD: Start frame outside range'; Exit; end;
  if dwStatus=WD_USBD_STATUS_ISOCH_REQUEST_FAILED then begin Stat2Str:='HCD: Isochronous transfer completed with error'; Exit; end;
  if dwStatus=WD_USBD_STATUS_FRAME_CONTROL_OWNED then begin Stat2Str:='USBD: Frame length control already taken'; Exit; end;
  if dwStatus=WD_USBD_STATUS_FRAME_CONTROL_NOT_OWNED then begin Stat2Str:='USBD: Attemped operation on frame length control not owned by caller'; Exit; end;
  if dwStatus=WD_INCORRECT_VERSION then begin Stat2Str:='Incorrect version'; Exit; end;
  if dwStatus=WD_TRY_AGAIN then begin Stat2Str:='Try again'; Exit; end;
  if dwStatus=WD_WINDRIVER_NOT_FOUND then begin Stat2Str:='Failed open WinDriver'; Exit; end;
  Stat2Str := 'Unrecognized error code'
end;

end.
