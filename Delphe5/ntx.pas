unit ntx;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, util1, debug0;
(*
 * Copyright 1997, 1998 by RadiSys Corporation.  All rights reserved.
 * Copyright 2002 by TenAsys Corporation.  All rights reserved.
 *)

(*
 * ntx.h
 *
 * Used by NT applications to operate on objects in the
 * INtime realtime kernel.
 *
 * $Revision: 1.12 $
 *
 *)


//static char* ntxh_header = "$Header: x:/engineer/intime.303/nt/include/rcs/ntx.h 1.12 2006/02/07 21:51:03Z CMain Engineer $";

(*
 * Warn about mixing RT anbd RTE subsystems
 *)


(*
 * Calling convention
 *)
//#define NTXAPI __cdecl

(*
 * LITERALS
 *)

Const
   NTX_DATA_MESSAGE_SIZE = 128;

(*
 * NTX errors passed from RT layer
 *)

(* Nucleus exceptions *)
  E_OK                        =0;
  E_TIME                      =1;
  E_MEM                       =2;
  E_BUSY                      =3;
  E_LIMIT                     =4;
  E_CONTEXT                   =5;
  E_EXIST                     =6;
  E_STATE                     =7;
  E_SLOT                      =$C;

(* Nucleus programmer errors *)
  E_TYPE                      =$8002;
  E_PARAM                     =$8004;
  E_BAD_CALL                  =$8005;
  E_PROTECTION                =$800d;
  E_BAD_ADDR                  =$800f;

  E_STRING                    =$8084;

  E_PROTOCOL	              =$80e0;
  E_PORT_ID_USED	      =$80e1;
  E_NUC_BAD_BUF		      =$80e2;
  E_SEND_NOT_COMPLETE	      =$80e3;

  E_ALIGNMENT                 =$80f1;

  E_LOCATION                  =$8f02;

(*
 * NTX unique exceptions
 *)
  E_NTX_INTERNAL_ERROR        = $1001;
  E_NTX_COMM_FAILURE          = $1002;
  E_NTX_KERNEL_FAILURE        = $1003;
  E_NTX_DSM_INTERNAL_ERROR    = $1004;

(*
 * Error codes defined in previous releases which will not
 * be returned by NTX calls.  These are all defined as the
 * same value now.
 *)
  E_NOT_AN_NTX_ERROR          =$1100;
  E_NOT_CONFIGURED            =E_NOT_AN_NTX_ERROR;
  E_INTERRUPT_SATURATION      =E_NOT_AN_NTX_ERROR;
  E_INTERRUPT_OVERFLOW        =E_NOT_AN_NTX_ERROR;
  E_DATA_CHAIN                =E_NOT_AN_NTX_ERROR;
  E_ZERO_DIVIDE               =E_NOT_AN_NTX_ERROR;
  E_OVERFLOW                  =E_NOT_AN_NTX_ERROR;
  E_BOUNDS                    =E_NOT_AN_NTX_ERROR;
  E_ARRAY_BOUNDS              =E_NOT_AN_NTX_ERROR;
  E_NDP_ERROR                 =E_NOT_AN_NTX_ERROR;
  E_ILLEGAL_OPCODE            =E_NOT_AN_NTX_ERROR;
  E_EMULATOR_TRAP             =E_NOT_AN_NTX_ERROR;
  E_CHECK_EXCEPTION           =E_NOT_AN_NTX_ERROR;
  E_NOT_PRESENT               =E_NOT_AN_NTX_ERROR;
  E_CPU_XFER_DATA_LIMIT       =E_NOT_AN_NTX_ERROR;
  E_TRANSMISSION              =E_NOT_AN_NTX_ERROR;

(*
 * Message index for message announcing an unknown error code.
 * This must not collide with any defined error codes (E_* )
 *)
 NTX_UNKNOWN_ERROR_CODE_MESSAGE = $1101;

(*
 * Mapping options
 *)
  NTX_MAP_WRITE		=$4 ;		(* Same as PAGE_READWRITE *)
  NTX_MAP_UNALIGNED	=$10000	;	(* Beyond PAGE_* flags *)

(*
 * TYPES
 *)
type
  NTXHANDLE = pointer;
  NTXLOCATION = pointer;
  RTHANDLE = WORD;
  NTXSTATUS = WORD;
  NTXXID = WORD;

  NTXPROCATTRIBS =record
                    dwPoolMin : DWORD;
                    dwPoolMax : DWORD;
                    dwVsegSize: DWORD;
                    dwObjDirSize: DWORD;
                  end;
  PNTXPROCATTRIBS =^NTXPROCATTRIBS;

  NTXPROCATTRIBSEX =
      record
	dwPoolMin: DWORD;
	dwPoolMax: DWORD;
	dwVsegSize: DWORD;
	dwObjDirSize: DWORD;
	dwWaitForInit: DWORD;
      end;
  PNTXPROCATTRIBSEX = ^NTXPROCATTRIBSEX;

(*
 * Flags for ntxCreateRtProcess()
 *)
Const
  NTX_PROC_DEBUG		        =$1;
  NTX_PROC_EXECUTABLE_DS		=$2;
  NTX_PROC_SHOW_PROGRESS		=$4;
  NTX_PROC_WAIT_FOR_INIT                =$8;
  NTX_PROC_WAIT_FOR_INIT_PARAM          =$10;


(*
 * Object types returned by ntxGetType()
 *)
  NTX_TYPE_RT_PROCESS         =1;
  NTX_TYPE_RT_THREAD          =2;
  NTX_TYPE_MAILBOX            =3;
  NTX_TYPE_RT_SEMAPHORE       =4;
  NTX_TYPE_REGION             =5;
  NTX_TYPE_RT_SHARED_MEMORY   =6;
  NTX_TYPE_EXTENSION          =7;
  NTX_TYPE_PORT               =9;
  NTX_TYPE_POOL               =10;
  NTX_TYPE_HEAP               =10;
  NTX_TYPE_SERVICE            =11;


(*
 * METAVALUES
 *)

(*
 * NTX_LOCAL is an NTXLOCATION referring to the RT subsystem sharing a
 * single processor with the NTX application.
 *
 * Using this in an MP system (assuming one is supported) will give
 * E_LOCATION if there is more than one instance of the RT layer.
 *)
  NTX_LOCAL                   =nil;

(*
 * NTX_UNDEFINED_LOCATION is an NTXLOCATION referring to no known location.
 * Used to indicate an error from things returning an NTXLOCATION.
 *)
  NTX_UNDEFINED_LOCATION      = NTXLOCATION (-1);

(*
 * NTX_NULL_NTXHANDLE is the value supplied to NTX calls when specifying
 * an NTX handle of "none"
 *)
  NTX_NULL_NTXHANDLE          = NTXHANDLE (0);

(*
 * NTX_BAD_NTXHANDLE is the value returned by NTX calls returning an
 * NTXHANDLE when the call fails.  Call ntxGetLastRtError() to find the
 * reason for the failure.
 *)
  NTX_BAD_NTXHANDLE           = NTXHANDLE(-1);

(*
 * NTX_ERROR may be returned by a call returning a WORD count
 * of some kind to indicate an error condition.
 *)
  NTX_ERROR                   = WORD(-1);

(*
 * NTX_BAD_SIZE may be returned from calls returning a DWORD size
 * of some kind to indicate an error condition.
 *)
  NTX_BAD_SIZE                = DWORD(-1);

(*
 * NTX_BAD_NTXSTATUS may be specified to calls taking an NTXSTATUS
 * to specify an undefined status code.
 *)
  NTX_BAD_NTXSTATUS            =NTXSTATUS(-1);

(*
 * Useful macros
 *)
// define ntxExportRtHandle(handle)		(RTHANDLE)((DWORD)handle & 0xffff)
// define MAILBOX_DEPTH(n)				(((n)>>1)&0x1e)

(*
 * NTX Creation Flags
 *)
  NTX_DATA_MAILBOX 			=$20;
  NTX_OBJECT_MAILBOX      		=0;
  NTX_FIFO_QUEUING			=0;
  NTX_PRIORITY_QUEUING			=1;

(*
 * ntxNotifyEvent Flags specifying what event notification are desired
 *)
  NTX_SPONSOR_NOTIFICATIONS 		=1;
  NTX_CLIENT_NOTIFICATIONS		=2;
  NTX_DEPENDENT_NOTIFICATIONS		=2;
  NTX_SYSTEM_EVENT_NOTIFICATIONS 	=4;

(*
 * Event Notification Types
 *)
  TERMINATE	 			  =255;
  DEPENDENT_REGISTERED 	                  =7;
  DEPENDENT_UNREGISTERED 		  =2;
  DEPENDENT_TERMINATED 			  =3;
  SPONSOR_TERMINATED			  =4;
  SPONSOR_UNREGISTERED			  =5;
  RT_CLIENT_DOWN			  =6;
  RT_CLIENT_UP				  =9;

(*
 * Port Related Constants
 *)
  NO_FRAGMENTATION				=2;
  CREATE_UNBOUND				=4;
  CONTIGUOUS_BUFFER 				=0;
  DATA_LIST_BUFFER 				=2;
  PHYS_ADDRESS 					=8;
  PHYS_LIST 					=10;
  SYNC_MODE 					=0;
  ASYNC_MODE 					=$10;
  USE_RECEIVE_REPLY 				=0;
  USE_RECEIVE 					=$100;
  NTX_COPY_DATA_BACK				=$8000;
  BAD_TRANSACTION_ID				=$FFFF;
  BAD_POINTER					=pointer($FFFFFFFF);
  WAIT_FOREVER					=INFINITE;
  NO_WAIT				      	=0;
  MESSAGE_TYPE_MASK 				=$00f0;
  BUFFER_TYPE_MASK 				=$000f;
  NORMAL_MESSAGE 			       	=$0000;
  STATUS_MESSAGE 				=$0010;
  REQUEST_MESSAGE 				=$0020;
  RESPONSE_MESSAGE 				=$0040;

(*
 * Structures
 *)

// GENADDR Structure
type
   GENADDR=record
	     byAddressLen: byte;
	     byNotUsed: byte;
	     wPortId: word;
	     Address: array[0..27] of byte;
           end;

   LPGENADDR= ^GENADDR;

// NTXEVENTINFO Structure
type
  NTXEVENTINFO =record
                  dwNotifyType: DWORD;
	          hClient: NTXLOCATION;
	          dwProcessId: NTXHANDLE ;
                end;


// PORTINFO Structure
  PORTINFO= record
              wPortID:      WORD;
              byType:       BYTE;
              _reserved_a:  BYTE;
              wNumTransactions: WORD;
              wControlMsgSize:  WORD;
              hService:         RTHANDLE;
              hSinkPort:        RTHANDLE;
              _reserved_b:      DWORD;
              hHeap:            RTHANDLE;
              wFlags:           WORD;
              LocalAddress:     GENADDR;
              RemoteAddress:    GENADDR;
              cName: array[0..13]of char;
            end;
  LPPORTINFO =^PORTINFO;

// SERVICEATTRIBUTES Structure
  SERVICEATTRIBUTES = record
                 	wOpCode: word;
                        wLength: word;
                      end;
  LPSERVICEATTRIBUTES = ^SERVICEATTRIBUTES;

// RECEIVEINFO Structure
  RECEIVEINFO = record
                  wFlags:    WORD;
                  wStatus:   WORD;
                  wTransID:  WORD;
                  dwDataSize:DWORD;
                  pData: pointer;
                  _reserved: word;
                  hForwPort: RTHANDLE;
                  LocalAddress: GENADDR;
                  RemoteAddress: GENADDR;
                  wControlMsgLength: WORD;
                  byControlMessage: array[0..0] of BYTE;
                end;
  LPRECEIVEINFO = ^RECEIVEINFO;

// Address list for ntxMapRtPhysicalMemoryList()
  CHDESC= record
            reserved1: array [0..1] of DWORD;
            dwFlags: DWORD;
            reserved2: array[0..2] of DWORD;
            cbByteCount: DWORD;
            reserved3: DWORD;
            paBlock: array[0..1] of DWORD;
          end;
  LPCHDESC = ^CHDESC;

(*
 * MODULE GLOBALS
 *)


var
(*
 * Returns handle to named location
 *)

ntxGetLocationByName: function(const LocationName:Pchar):NTXLOCATION ;cdecl;


(*
 * Returns handle to first known location.
 *
 * Locations are ordered in the sequence in which they are discovered by NTX
 *)

ntxGetFirstLocation: function:NTXLOCATION ;cdecl;


(*
 * Returns handle to the location following the one returned by
 * the last call to ntxGetFirstLocation or ntxGetNextLocation in
 * the current thread.
 *)

ntxGetNextLocation: function( LastLocation: NTXLOCATION):NTXLOCATION ;cdecl;


(*
 * Returns the name by which the specified location handle is known to NTX
 *
 * If the client writes to the returned pointer, results are unpredictable
 * (but almost certainly BAD).
 *)

ntxGetNameOfLocation: function(Location:NTXLOCATION):Pansichar;cdecl;


(*
 * Returns the NTXLOCATION corresponding to the RT node on which the
 * specified object (was last known to) exist(s).
 *
 * Returns NTX_UNDEFINED_LOCATION if the specified object handle seems
 * to be bad.
 *)

ntxGetLocationOfRtObject: function(hObject:NTXHANDLE):NTXLOCATION ;cdecl;


(*
 * Returns E_OK if RT system running at specified location
 *)

ntxGetRtStatus: function(hLoc:NTXLOCATION):NTXSTATUS ;cdecl;


(*
 * Returns the error code from the last NTX call
 * to fail in this NT thread.
 *)

ntxGetLastRtError: function:NTXSTATUS ;cdecl;


(*
 * ntxGetRtErrorName() returns a pointer to a constant string.
 * This string will contain the name of the status code passed
 * (i.e. "E_TIME") or "undefined status code" if the status code
 * passed is not defined in ntx.h.
 *
 * NTX_BAD_NTXSTATUS is always an undefined status code.
 *)

ntxGetRtErrorName: function(status:NTXSTATUS): Pansichar;cdecl;


(*
 * ntxLoadRtErrorString() copies a short sentence (no punctuation)
 * describing "Status" into the buffer at lpBuffer.
 *
 * If UNICODE is defined, the lpBuffer is an LPWSTR which will contain
 * the sentence in UNICODE.
 *
 * The return value is the length of the string, or 0 if the buffer was too small.
 *)

ntxLoadRtErrorString: function(status:NTXSTATUS; lpBuffer: LPSTR; nBufferMax:integer ):integer ;cdecl;


// ntxLoadRtErrorStringW: function(status: NTXSTATUS; lpBuffer:LPWSTR;nbuffermax:integer ):integer;cdecl;



(*
 * ntxImportRtHandle
 *
 * Import an RTHANDLE from another RT object and make an NTXHANDLE
 *)


ntxImportRthandle: function(IncomingObject: RTHANDLE ;hObjectSource: NTXHANDLE):NTXHANDLE;cdecl;


(*
 * Map an RT shared memory object into the NTX application's
 * address space.
 *
 * If the RT memory object is sparse or not physically contiguous,
 * results are unpredictable.
 *
 * Returns NULL on failure (check ntxGetLastRtError)
 *)

ntxMapRtSharedMemory: function(hsegment:NTXHANDLE ):pointer ;cdecl;


(*
 * Map an RT shared memory object into the NTX application's
 * address space.
 *
 * If the RT memory object is sparse or not physically contiguous,
 * results are unpredictable.
 *
 * Returns NULL on failure (check ntxGetLastRtError)
 *
 * Like ntxMapRtSharedMemory, but allows options according to
 * dwFlags:
 *
 * NTX_MAP_WRITE		Makes a read/write mapping.  If this
 *                      is omitted, the mapping is read-only
 *
 * NTX_MAP_UNALIGNED	Allows the mapping of non page-aligned
 *                      segments.  If this is omitted, and either
 *                      segment boundary is not page-aligned,
 *                      E_ALIGNMENT is returned.
 *)

ntxMapRtSharedMemoryEx: function(hsegment:NTXHANDLE; dwFlags: DWORD ):pointer;cdecl;



(*
 * Returns system resources used by ntxMapRtSharedMemory().
 *
 * Fails if NTXHANDLE is not local (E_LOCATION), or not mappable
 * (E_ALIGNMENT), or not mapped (E_STATE).
 *
 * Returns E_OK on success.
 *)

ntxUnmapRtSharedMemory: function(hsegment:NTXHANDLE):NTXSTATUS ;cdecl;


(*
 * Map a list of physical memory pages into the NTX application's
 * address space.
 *
 * Returns NULL on failure (check ntxGetLastRtError)
 *
 *)

ntxMapRtPhysicalMemoryList: function(pAddrList:LPCHDESC; cbsize:DWORD; dwFlags:DWORD ):pointer ;cdecl;

(*
 * Returns system resources used by ntxMapRtPhysicalMemoryList().
 *
 * Fails if memory not previously mapped (E_STATE).
 *
 * Returns E_OK on success.
 *)

ntxUnmapRtPhysicalMemoryList: function(pMappedMemory:pointer):NTXSTATUS ;cdecl;


(*
 * Copy <length> bytes from <src_seg>:<src_offset> to
 * <dest_seg>:<dest_offset>. A NULL is placed in the Seg
 * NTXHANDLE whose Offset is an NT pointer.
 *
 * Fails (E_LOCATION) unless exactly one NTXHANDLE is NULL.
 *
 * Returns E_OK on success.
 *)

ntxCopyRtData: function(hSrcSeg: NTXHANDLE  ; dwSrcOffset: DWORD ;  hDestSeg: NTXHANDLE  ; dwDestOffset: DWORD ; dwLength: DWORD ):NTXSTATUS;cdecl;


(*
 * Get the handle for the root RT process
 *
 * Fails if RTLOCATION invalid, not defined, or
 * not reachable (E_LOCATION).
 *
 * Returns NTX_BAD_NTXHANDLE on failure (check ntxGetLastRtError)
 *)
ntxGetRootRtProcess: function(hLoc: NTXLOCATION     ):NTXHANDLE;cdecl;


(*
 * Get the type of an RT object
 *
 * Return value is NTX_TYPE_*
 *
 * Returns NTX_ERROR on failure (check ntxGetLastRtError)
 *)
ntxGetType: function(hObject: NTXHANDLE  ):WORD;cdecl;


(*
 * Get the size of an RT memory segment
 *
 * Fails is hObject is not a segment
 *
 * Failure is indicated by a size of NTX_BAD_SIZE
 *)
ntxGetRtSize: function(hObject: NTXHANDLE  ):DWORD;cdecl;


(*
 * Catalog the handle associated with a name in an RT object directory
 *
 * Note that pName below is a null-terminated string
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxCatalogNtxHandle: function(hProcess: NTXHANDLE  ; hObject: NTXHANDLE ; pName: LPSTR ):NTXSTATUS;cdecl;


(*
 * Look up the handle associated with a name in an RT object directory
 *
 * Note that pName below is a null-terminated string
 *
 * Check ntxGetLastRtError if returned value is NTX_BAD_NTXHANDLE
 *)
ntxLookupNtxhandle: function(hRtProcess: NTXHANDLE ; pName: LPSTR ; dwMilliseconds: DWORD ):NTXHANDLE;cdecl;


(*
 * Remove the handle associated with a name from an RT object directory
 *
 * Note that pName below is a null-terminated string
 *
 * Check ntxGetLastRtError if returned value is NTX_BAD_NTXHANDLE
 *)
ntxUncatalogNtxHandle: function(hProcess: NTXHANDLE ; hObject: NTXHANDLE ; pName: LPSTR 	):NTXSTATUS;cdecl;


(*
 * Create an RT semaphore.
 *
 * Returns the handle of the semaphore on success or NTX_BAD_NTXHANDLE
 * (check ntxGetLastRtError)
 *)
ntxCreateRtSemaphore: function(hLoc: NTXLOCATION ; dwInitCount: DWORD ; dwMaxCount: DWORD ; dwFlags: DWORD ):NTXHANDLE;cdecl;

(*
 * Release control of an RT semaphore.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxReleaseRtSemaphore: function(hSemaphore: NTXHANDLE     ; wUnits: WORD  ):NTXSTATUS;cdecl;


(*
 * Wait for an RT semaphore
 *
 * Returns number of units remaining, or NTX_ERROR on
 * failure (check ntxGetLastRtError)
 *)
ntxWaitForRtSemaphore: function(hSemaphore: NTXHANDLE ;  wUnits: WORD  ; dwMilliseconds: DWORD  ):WORD;cdecl;


(*
 * Delete an RT semaphore
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxDeleteRtSemaphore: function(hSemaphore: NTXHANDLE ):NTXSTATUS;cdecl;


(*
 * Create an RT mailbox.
 *
 * Returns the handle of the mailbox on success or NTX_BAD_NTXHANDLE
 * (check ntxGetLastRtError)
 *)
ntxCreateRtMailbox: function(hLoc: NTXLOCATION 	;  dwFlags: DWORD  ):NTXHANDLE;cdecl;

(*
 * Copy a short message into an RT data mailbox
 *
 * Returns E_OK on success
 *)
ntxSendRtData: function(hMailbox: NTXHANDLE ; pMessage: pointer; wActualLength: WORD ):NTXSTATUS;cdecl;


(*
 * Wait for a message at an RT data mailbox, and copy it
 * out into a buffer in this NTX application's address space.
 *
 * Returns number of bytes received, or NTX_ERROR on
 * failure (check ntxGetLastRtError)
 *
 * The buffer must be able to hold the largest possible message
 * (NTX_DATA_MESSAGE_SIZE).
 *)
ntxReceiveRtData: function(hMailbox: NTXHANDLE ; pMessage: pointer ; dwMilliseconds: DWORD ):WORD;cdecl;


(*
 * Send an object handle to an RT object mailbox.
 *
 * Handles are transformed from NTXHANDLEs into RTHANDLEs
 * by the NTX DLL.
 *
 * Fails if the locations of all the NTXHANDLEs is not the
 * same (E_LOCATION).
 *
 * Returns E_OK on success.
 *)
ntxSendRtHandle: function(hMailbox: NTXHANDLE ; hObject: NTXHANDLE ; hResponse: NTXHANDLE ):NTXSTATUS;cdecl;


(*
 * Receive an object handle from an RT object mailbox.
 *
 * Handles will be transformed into NTXHANDLEs by the NTX DLL
 *)
ntxReceiveRtHandle: function(hMailbox: NTXHANDLE ; dwMilliseconds: DWORD  ; var phResponse: NTXHANDLE ):NTXHANDLE;cdecl;


(*
 * Delete an RT mailbox
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxDeleteRtMailbox: function(hMailbox: NTXHANDLE ):NTXSTATUS;cdecl;


(*
 * Create an RT port.
 *
 * Returns the handle of the port on success or NTX_BAD_NTXHANDLE
 * (check ntxGetLastRtError)
 *)
ntxCreateRtPort: function(hLoc: NTXLOCATION; lpszName: LPSTR; wPortNumber: WORD; wMaxTransactions: WORD ;	wFlags: WORD ; dwHeapSize: DWORD ):NTXHANDLE;cdecl;

(*
 * Get the attribute data for a service.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxGetRtServiceAttributes: function(hPort: NTXHANDLE ; lpAttributes: LPSERVICEATTRIBUTES ):NTXSTATUS;cdecl;


(*
 * Set the attribute data for a service.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxSetRtServiceAttributes: function(hPort: NTXHANDLE ; lpAttributes: LPSERVICEATTRIBUTES ):NTXSTATUS;cdecl;


(*
 * Receive the reply part of a transaction from the specified port.
 *
 * Returns a pointer the reply buffer or NULL (check ntxGetLastRtError)
 *)
ntxReceiveRtReply: function(hPort: NTXHANDLE ; TransId: NTXXID ; dwMilliseconds: DWORD ; pReceiveInfo: pointer ):pointer;cdecl;


(*
 * Receive a message from the specified port.
 *
 * If the message is NOT a reply to a previous transaction, the pointer
 * returned from the call must be passed in a call to ntxReleaseBuffer
 * to return the memory to the system.
 *
 * Returns a pointer to the data part of the message or NULL
 * (check ntxGetLastRtError)
 *)
ntxReceiveRtMessage: function(hPort: NTXHANDLE ; dwMilliseconds: DWORD ;  pReceiveInfo: pointer ):pointer;cdecl;


(*
 * Send a message to the service and request a response.
 *
 * Returns a valid transaction ID on success, BAD_TRANSACTION_ID
 * otherwise (check ntxGetLastRtError)
 *)

ntxSendRtMessageRSVP:function(hPort: NTXHANDLE; var pAddress: GENADDR ;
             			 	 var pControl: BYTE  ;
					 dwControlLength: WORD;
	 				 pData: pointer 	;
					 dwDataSize: DWORD ;
					 pReply: pointer  ;
					 dwReplySize: DWORD;
					 dwTransmissionFlags: WORD ):NTXXID;cdecl;


(*
 * Send a message to the service.
 *
 * Returns a valid transaction ID on success, BAD_TRANSACTION_ID
 * otherwise (check ntxGetLastRtError)
 *)

ntxSendRtMessage: function(hPort: NTXHANDLE ;
				 var pAddress: GENADDR;
				 var pControl: BYTE ;
				 dwControlLength: WORD;
				 pData: pointer ;
				 dwDataSize: DWORD ;
				 dwTransmissionFlags: WORD ):NTXXID;cdecl;


(*
 * Detach a sinkport from a port.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)

ntxDetachRtPort: function(hPort: NTXHANDLE ):NTXSTATUS;cdecl;


(*
 * Attach a port to a port as a sinkport.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxAttachRtPort: function(hPort: NTXHANDLE  ;hSinkPort: NTXHANDLE	):NTXSTATUS;cdecl;

(*
 * Bind an address to a port.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxBindRtPort: function(hPort: NTXHANDLE ; lpAddress: LPGENADDR ):NTXSTATUS;cdecl;


(*
 * Cancel a transaction currently in progress.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxCancelRtTransaction: function(hPort: NTXHANDLE ; TransId: NTXXID ):NTXSTATUS;cdecl;


(*
 * Connect a port to the specified address.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxConnectRtPort: function(hPort: NTXHANDLE ;var pAddress: GENADDR ):NTXSTATUS;cdecl;


(*
 * Get the attribute data for a port.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxGetRtPortAttributes: function(hPort: NTXHANDLE ; pInfo: LPPORTINFO ):NTXSTATUS;cdecl;

(*
 * Delete an RT port
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxDeleteRtPort: function(hPort: NTXHANDLE ):NTXSTATUS;cdecl;

(*
 * Request an RT buffer
 *
 * Returns a pointer to the buffer on success; NULL otherwise
 *		(check ntxGetLastRtError)
 *)
ntxRequestRtBuffer: function(hPort: NTXHANDLE ; dwBufferSize: DWORD ):pointer;cdecl;

(*
 * Release an RT buffer
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxReleaseRtBuffer: function(hPort: NTXHANDLE ;lpBuffer: pointer ):NTXSTATUS;cdecl;

(*
 * Loads and starts an "RTA" file; and returns the process handle
 *)

ntxCreateRtProcess: function(hLoc: NTXLOCATION      ;
                   pExecutableFile: LPSTR            ;
                   pProcessArguments: LPSTR            ;
                   pProcessAttributes: PNTXPROCATTRIBS  ;
                   dwFlags: DWORD            ):NTXHANDLE;cdecl;

(*
 * Loads and starts an "RTA" from a binary resource; and returns the
 * process handle
 *)

ntxCreateRtProcessFromResource: function(hLoc: NTXLOCATION;
                               hResource: HRSRC ;
                               dwRtaSize: DWORD			;
                               pProcessArguments: LPSTR            ;
                               pProcessAttributes: PNTXPROCATTRIBS  ;
                               dwFlags: DWORD ):NTXHANDLE;cdecl;

(*
 * Register the calling process as a sponsor.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxRegisterSponsor: function(lpszSponsorName: LPSTR ):NTXSTATUS;cdecl;


(*
 * Unregister the calling process as a sponsor.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxUnregisterSponsor: function(lpszSponsorName: LPSTR ):NTXSTATUS;cdecl;


(*
 * Register the calling process as a dependent.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxRegisterDependency: function(lpszSponsorName: LPSTR  ; dwMilliseconds: DWORD ):NTXSTATUS;cdecl;

(*
 * Unregister the calling process as a dependent.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxUnregisterDependency: function(lpszSponsorName: LPSTR ):NTXSTATUS;cdecl;


(*
 * Request notifications for the calling process.
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxNotifyEvent: function(dwEventFlags: DWORD ; dwMilliseconds: DWORD ; var lpProcess: NTXEVENTINFO ):NTXSTATUS;cdecl;


(*
 * Get the name of an NTX node connected to an RT node
 *
 * Returns
 * E_OK on success
 * E_TIME if request times out
 * E_EXIST if target node does not exist
 * E_NTX_COMM_FAILURE if the target does not support this call or other error
 *)

ntxGetRtNodeController: function( RtNodeName: Pansichar  ;
                                  NodeTag: DWORD ;
                                  NtxNodeName: LPSTR ;
                                  NtxNodeNameLen: DWORD ):NTXSTATUS;cdecl;

(*
 * Set the controlling NTX node for an RT node
 *
 * Returns
 * E_OK on success
 * E_TIME if request times out
 * E_EXIST if target node does not exist
 * E_LIMIT if control cannot be taken due to resource limit
 * E_NTX_COMM_FAILURE if the target does not support this call
 *)

ntxSetRtNodeController: function( RtNodeName: Pansichar  ;
                                  NtxNodeName: Pansichar  ;
                                  PreviousController: Pansichar ;
                                  PreviousControllerLen: DWORD ):NTXSTATUS;cdecl;



ntxGetRtNodeByName: function( RtNodeName: Pansichar ;RtNodeAddr: LPSTR ; RtNodeAddrLen: DWORD ):NTXSTATUS ;cdecl;


ntxGetRtNodeByAddress: function( RtNodeAddr: Pansichar; RtNodeName: LPSTR ; RtNodeNameLen: DWORD ):NTXSTATUS;cdecl;


(*
 * Refresh the list of Dynamically advertised INtime nodes
 *)
ntxRefreshRtNodeList: procedure;cdecl;

(*
 *	Aliases for old calls to provide backward compatability
 *)
//#define ntxLookupNtxHandle	ntxLookupNtxhandle
//#define ntxCatalogRtObject	ntxCatalogNtxHandle
//#define ntxUncatalogRtObject 	ntxUncatalogNtxHandle

(*
 * Create an RT segment.
 *
 * Returns the handle of the segment on success or NTX_BAD_NTXHANDLE
 * (check ntxGetLastRtError)
 *)
ntxCreateRtSegment: function(hLoc: NTXLOCATION ;dwSize: DWORD ):NTXHANDLE;cdecl;

(*
 * Delete an RT segment
 *
 * Returns E_OK on success, else check ntxGetLastRtError
 *)
ntxDeleteRtSegment: function(hSegment: NTXHANDLE ):NTXSTATUS;cdecl;

(* Aliases for the Create/Delete segment calls *)
//#define ntxAllocateRtMemory ntxCreateRtSegment
//#define ntxFreeRtMemory ntxDeleteRtSegment


ntxTerminateRtProcess: function( hRtProcess: NTXHANDLE): NTXSTATUS;cdecl;


function ntxAllocateRtMemory(hLoc: NTXLOCATION ;dwSize: DWORD ):NTXHANDLE;
function ntxFreeRTmemory(hSegment: NTXHANDLE ):NTXSTATUS;


function InitNtxDLL:boolean;
function InitNtxExDLL:boolean;

implementation

function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil')
                {else messageCentral(st+' OK')};
end;

var
  hh:intG;
  hhex:intG;

function InitNtxDLL:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('ntx.dll');
  result:=(hh<>0);
  if not result then exit;

  ntxGetLocationByName:=getProc(hh,'ntxGetLocationByName');
  ntxGetFirstLocation:=getProc(hh,'ntxGetFirstLocation');
  ntxGetNextLocation:=getProc(hh,'ntxGetNextLocation');
  ntxGetNameOfLocation:=getProc(hh,'ntxGetNameOfLocation');
  ntxGetLocationOfRtObject:=getProc(hh,'ntxGetLocationOfRtObject');
  ntxGetRtStatus:=getProc(hh,'ntxGetRtStatus');
  ntxGetLastRtError:=getProc(hh,'ntxGetLastRtError');
  ntxGetRtErrorName:=getProc(hh,'ntxGetRtErrorName');
  ntxLoadRtErrorString:=getProc(hh,'ntxLoadRtErrorStringA');     { A for char }
  ntxImportRthandle:=getProc(hh,'ntxImportRthandle');
  ntxMapRtSharedMemory:=getProc(hh,'ntxMapRtSharedMemory');
  ntxMapRtSharedMemoryEx:=getProc(hh,'ntxMapRtSharedMemoryEx');
  ntxUnmapRtSharedMemory:=getProc(hh,'ntxUnmapRtSharedMemory');
  ntxMapRtPhysicalMemoryList:=getProc(hh,'ntxMapRtPhysicalMemoryList');
  ntxUnmapRtPhysicalMemoryList:=getProc(hh,'ntxUnmapRtPhysicalMemoryList');
  ntxCopyRtData:=getProc(hh,'ntxCopyRtData');
  ntxGetRootRtProcess:=getProc(hh,'ntxGetRootRtProcess');
  ntxGetType:=getProc(hh,'ntxGetType');
  ntxGetRtSize:=getProc(hh,'ntxGetRtSize');

  ntxLookupNtxhandle:=getProc(hh,'ntxLookupNtxhandle');

  ntxReleaseRtSemaphore:=getProc(hh,'ntxReleaseRtSemaphore');
  ntxWaitForRtSemaphore:=getProc(hh,'ntxWaitForRtSemaphore');

  ntxSendRtData:=getProc(hh,'ntxSendRtData');
  ntxReceiveRtData:=getProc(hh,'ntxReceiveRtData');
  ntxSendRtHandle:=getProc(hh,'ntxSendRtHandle');
  ntxReceiveRtHandle:=getProc(hh,'ntxReceiveRtHandle');

  ntxCreateRtProcess:=getProc(hh,'ntxCreateRtProcess');

  ntxGetRtNodeController:=getProc(hh,'ntxGetRtNodeController');
  ntxSetRtNodeController:=getProc(hh,'ntxSetRtNodeController');
  ntxGetRtNodeByName:=getProc(hh,'ntxGetRtNodeByName');
  ntxGetRtNodeByAddress:=getProc(hh,'ntxGetRtNodeByAddress');
  ntxRefreshRtNodeList:=getProc(hh,'ntxRefreshRtNodeList');

  ntxTerminateRtProcess:=getProc(hh,'ntxTerminateRtProcess');
end;


function InitNtxExDLL:boolean;
begin
  result:=true;
  if hhEx<>0 then exit;

  hhEx:=GloadLibrary('ntxext.dll');
  result:=(hhEx<>0);
  if not result then exit;


  ntxCatalogNtxHandle:=getProc(hhex,'ntxCatalogNtxHandle');
  ntxUncatalogNtxHandle:=getProc(hhex,'ntxUncatalogNtxHandle');
  ntxCreateRtSemaphore:=getProc(hhex,'ntxCreateRtSemaphore');
  ntxDeleteRtSemaphore:=getProc(hhex,'ntxDeleteRtSemaphore');
  ntxCreateRtMailbox:=getProc(hhex,'ntxCreateRtMailbox');
  ntxDeleteRtMailbox:=getProc(hhex,'ntxDeleteRtMailbox');
  ntxCreateRtPort:=getProc(hhex,'ntxCreateRtPort');
  ntxDeleteRtPort:=getProc(hhex,'ntxDeleteRtPort');

  ntxGetRtServiceAttributes:=getProc(hhex,'ntxGetRtServiceAttributes');
  ntxSetRtServiceAttributes:=getProc(hhex,'ntxSetRtServiceAttributes');

  ntxReceiveRtReply:=getProc(hhex,'ntxReceiveRtReply');
  ntxReceiveRtMessage:=getProc(hhex,'ntxReceiveRtMessage');

  ntxSendRtMessage:=getProc(hhex,'ntxSendRtMessage');
  ntxSendRtMessageRSVP:=getProc(hhex,'ntxSendRtMessageRSVP');

  ntxDetachRtPort:=getProc(hhex,'ntxDetachRtPort');
  ntxAttachRtPort:=getProc(hhex,'ntxAttachRtPort');
  ntxBindRtPort:=getProc(hhex,'ntxBindRtPort');
  ntxCancelRtTransaction:=getProc(hhex,'ntxCancelRtTransaction');
  ntxConnectRtPort:=getProc(hhex,'ntxConnectRtPort');
  ntxGetRtPortAttributes:=getProc(hhex,'ntxGetRtPortAttributes');

  ntxRequestRtBuffer:=getProc(hhex,'ntxRequestRtBuffer');
  ntxReleaseRtBuffer:=getProc(hhex,'ntxReleaseRtBuffer');

  {ntxCreateRtProcessFromResource:=getProc(hhex,'ntxCreateRtProcessFromResource');}
  ntxRegisterSponsor:=getProc(hhex,'ntxRegisterSponsor');
  ntxUnregisterSponsor:=getProc(hhex,'ntxUnregisterSponsor');
  ntxRegisterDependency:=getProc(hhex,'ntxRegisterDependency');
  ntxUnregisterDependency:=getProc(hhex,'ntxUnregisterDependency');
  ntxNotifyEvent:=getProc(hhex,'ntxNotifyEvent');

  ntxCreateRtSegment:=getProc(hhex,'ntxCreateRtSegment');
  ntxDeleteRtSegment:=getProc(hhex,'ntxDeleteRtSegment');

end;

function ntxAllocateRtMemory(hLoc: NTXLOCATION ;dwSize: DWORD ):NTXHANDLE;
begin
  result:= ntxCreateRtSegment(hLoc,dwSize);
end;

function ntxFreeRTmemory(hSegment: NTXHANDLE ):NTXSTATUS;
begin
  result:= ntxDeleteRTsegment(hSegment);
end;

initialization
Affdebug('Initialization ntx',0);

finalization
  if hh<>0 then freeLibrary(hh);
  if hhex<>0 then freeLibrary(hhex);


end.
