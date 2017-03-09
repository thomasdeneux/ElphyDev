unit ctrlDSP;

{  Traduction en Pascal de ii_iostr.h de M6x
                           mailbox.h  de M6x
                           cardinfo.h de M6x

                           ctrldsp.c  de Bruno Foutry
}

interface

uses windows,sysUtils,
     M62call,
     util1,Gdos, stmDef;



//
//      ii_iostr.h   --   Useful structures for communicating from
//                           drivers to dlls to applications
//
//================================================
//   Hardware Description Structures
//
//------------------------------------------------------------------------
//   struct MemoryBlock -- Memory Area description
//------------------------------------------------------------------------

type
  TMemoryBlock=
    record
      Addr:integer;       // Mapped Address of Block Base
      DriverAddr:integer; // Linear Address of Block Base
      PhysAddr: integer;  // Physical Address of Block Base
      Size:integer ;       // Block Size in bytes
      MemoryType:integer; // Port or Memory Mapped
      WasMapped:integer;  // Was Mapped or not
    end;
  PMemoryBlock=^TMemoryBlock;

//------------------------------------------------------------------------
//   struct IoPortBlock -- IO Port block description
//------------------------------------------------------------------------

 TIoPortBlock=
   record
     Base: integer;       // Base Port of Block
     Size: integer;       // Block Size in bytes
     MemoryType: integer; // Port or Memory Mapped
     WasMapped: integer;  // Was Mapped or not
   end;
  PIoPortBlock=^TIoPortBlock;


//
//     mailbox.h       --   mailbox i/o definitions
//
//     This version defines mailbox layouts, etc., for HPI-based machines
//
//
//    Mailboxes are memory mapped in the data memory region of Target memory
//
const
  Rcv =			0;
  Ack =			2;
  Xmt =			1;
  Req =			3;

//
//  MAILBOX structure --
//  NOTE:  Not used, as PCI mailboxes are I/O mapped.
//

type
  Tmailbox=
    record
      RCV: Longword;  // RCV contains data transmitted from target to PC    */
      ACK: Longword;  // ACK signals that target has transmitted to PC (-1) */
      XMT: Longword;  // XMT contains data transmitted from PC to target    */
      REQ: Longword;  // REQ signals that PC has transmitted to target (-1) */
    end;
  PMAILBOX=^Tmailbox;



//
//    cardinfo.h   --   definition of CARDINFO structure
//

//
//  BoardInfo structure
//

 TBoardInfo=
    record
      ProcessorCount: integer;
      DLL_Version: integer;            // Version ID numbers
      DrvVersion: integer;
      TalkerVersion: integer;
      CellSize: integer;               // Targ memory cell size, in bytes
      CtlReg: integer;                 // Shadow of control register
      FlashSectorSize: integer;       // Size of flash sectors, in bytes
      FlashDeviceId: integer;		  // Flash device ID
      QuietMode: integer;              // Don't Display Messages if true
    end;

//
//  InterruptInfo structure
//
  TInterruptInfo=
    record
      IRQ: integer;                 // IRQ of attached interrupt
      Ring0Event:Thandle;           // Ring 0 event handle
      Ring3Event: Thandle;          // Ring 3 event handle
      Vector: TvirtualISR;          // Virtual ISR function pointer
      context: pointer;	            // Virtual ISR context pointer
   end;


//
//  LoaderInfo structure
//
  TDisplayLoadMsg=procedure(p:Pchar);cdecl; { A vérifier la convention d'appel}
  TLoaderInfo=
    record
      DisplayLoadMsg: TDisplayLoadMsg; // Virtual loader display function pointer
      Parent:Hwnd;                    // Handle to parent window during load
    end;


//
//  SerialInfo structure
//
  TSerialInfo=
    record
      InB:LongWord;          // Buffer for last character received
      ReadFlag:LongWord;    // True when character received
      MbValue: LongWord;     // Multi-byte value
      MbCtr:LongWord;       // Multi-byte read state
      RTS_state: integer;   // Current state of the RTS output
      Bcr: LOngWord;		  // Bus control register value for Flash access
      Reading: LongWord;     // TRUE if currently reading a character
      RxOverlap:TOVERLAPPED;   // Info used in asynch input
      TxOverlap:TOVERLAPPED;   // Info used in asynch output
      Timeouts: TCOMMTIMEOUTS;    // Info for set/query time-out parameters
      Dcb: TDCB;         // Device control block
    end;

//
//  CARDINFO  structure
//
//  DO NOT RE-ARRANGE!  Additions are OK
//
  Tcardinfo=
    record
      Target: integer;                  // Number of current target
      Device:THANDLE;                   // Handle to Driver for device
      Info: TBoardInfo         ;        // Board Info
      Mail:PmailBox;                    // Talker Mailbox Array
      Port: TIoPortBlock       ;        // Primary Port Block Information
      OpReg: TIoPortBlock       ;       // Secondary Port Block Information
      DualPort: TMemoryBlock       ;    // Shared Memory Area Information
      BusMaster: TMemoryBlock       ;   // BusMaster Memory Information
      Interrupt: TInterruptInfo     ;   // Interrupt Information
      Serial: TSerialInfo        ;      // Serial Port I/O (SBC's)
      Loader: TLoaderInfo        ;
      Hpi: TMemoryBlock;                // HPI Memory Block (used on 'C62 for HPI interface access)

      HwDevice:pointer;
      pDmaBuffer:pointer;
    end;
  Pcardinfo=^Tcardinfo;

//
//  M62ioctl.h   --  M62 IO Control Definitions
//
//==================================================
//   Structures for M62 IOCTL Commands
//
//
//
// Macro definition for defining IOCTL and FSCTL function control codes.  Note
// that function codes 0-2047 are reserved for Microsoft Corporation, and
// 2048-4095 are reserved for customers.
//


//devioctl.h

type
  DEVICE_TYPE= ULONG;

Const
  FILE_DEVICE_BEEP                = $00000001;
  FILE_DEVICE_CD_ROM              = $00000002;
  FILE_DEVICE_CD_ROM_FILE_SYSTEM  = $00000003;
  FILE_DEVICE_CONTROLLER          = $00000004;
  FILE_DEVICE_DATALINK            = $00000005;
  FILE_DEVICE_DFS                 = $00000006;
  FILE_DEVICE_DISK                = $00000007;
  FILE_DEVICE_DISK_FILE_SYSTEM    = $00000008;
  FILE_DEVICE_FILE_SYSTEM         = $00000009;
  FILE_DEVICE_INPORT_PORT         = $0000000a;
  FILE_DEVICE_KEYBOARD            = $0000000b;
  FILE_DEVICE_MAILSLOT            = $0000000c;
  FILE_DEVICE_MIDI_IN             = $0000000d;
  FILE_DEVICE_MIDI_OUT            = $0000000e;
  FILE_DEVICE_MOUSE               = $0000000f;
  FILE_DEVICE_MULTI_UNC_PROVIDER  = $00000010;
  FILE_DEVICE_NAMED_PIPE          = $00000011;
  FILE_DEVICE_NETWORK             = $00000012;
  FILE_DEVICE_NETWORK_BROWSER     = $00000013;
  FILE_DEVICE_NETWORK_FILE_SYSTEM = $00000014;
  FILE_DEVICE_NULL                = $00000015;
  FILE_DEVICE_PARALLEL_PORT       = $00000016;
  FILE_DEVICE_PHYSICAL_NETCARD    = $00000017;
  FILE_DEVICE_PRINTER             = $00000018;
  FILE_DEVICE_SCANNER             = $00000019;
  FILE_DEVICE_SERIAL_MOUSE_PORT   = $0000001a;
  FILE_DEVICE_SERIAL_PORT         = $0000001b;
  FILE_DEVICE_SCREEN              = $0000001c;
  FILE_DEVICE_SOUND               = $0000001d;
  FILE_DEVICE_STREAMS             = $0000001e;
  FILE_DEVICE_TAPE                = $0000001f;
  FILE_DEVICE_TAPE_FILE_SYSTEM    = $00000020;
  FILE_DEVICE_TRANSPORT           = $00000021;
  FILE_DEVICE_UNKNOWN             = $00000022;
  FILE_DEVICE_VIDEO               = $00000023;
  FILE_DEVICE_VIRTUAL_DISK        = $00000024;
  FILE_DEVICE_WAVE_IN             = $00000025;
  FILE_DEVICE_WAVE_OUT            = $00000026;
  FILE_DEVICE_8042_PORT           = $00000027;
  FILE_DEVICE_NETWORK_REDIRECTOR  = $00000028;
  FILE_DEVICE_BATTERY             = $00000029;
  FILE_DEVICE_BUS_EXTENDER        = $0000002a;
  FILE_DEVICE_MODEM               = $0000002b;
  FILE_DEVICE_VDM                 = $0000002c;
  FILE_DEVICE_MASS_STORAGE        = $0000002d;


  METHOD_BUFFERED        =        0;
  METHOD_IN_DIRECT       =        1;
  METHOD_OUT_DIRECT      =        2;
  METHOD_NEITHER         =        3;

 
  FILE_ANY_ACCESS        =        0;
  FILE_READ_ACCESS       =        1;
  FILE_WRITE_ACCESS      =        2;



//
// CTL_CODE( DeviceType, Function, Method, Access )=
//    (DeviceType shl 16 OR Func SHL 2 OR Method OR Access shl 14


Const
  M62_IOCTL_MAP_BUSMASTER =
    FILE_DEVICE_UNKNOWN shl 16 + $AC0 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_UNMAP_BUSMASTER =
    FILE_DEVICE_UNKNOWN shl 16 + $AC1 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_OPREG_READ =
    FILE_DEVICE_UNKNOWN shl 16 + $AC2 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_OPREG_WRITE =
    FILE_DEVICE_UNKNOWN shl 16 + $AC3 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_BUSMASTER_READ =
    FILE_DEVICE_UNKNOWN shl 16 + $AC4 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_BUSMASTER_WRITE =
    FILE_DEVICE_UNKNOWN shl 16 + $AC5 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_RESET =
    FILE_DEVICE_UNKNOWN shl 16 + $AC6 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_RUN =
    FILE_DEVICE_UNKNOWN shl 16 + $AC7 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_ENABLE_INT =
    FILE_DEVICE_UNKNOWN shl 16 + $AC8 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_DISABLE_INT =
    FILE_DEVICE_UNKNOWN shl 16 + $AC9 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_GET_BD_RESOURCES =
    FILE_DEVICE_UNKNOWN shl 16 + $ACA shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_GET_RESOURCE_DUMP =
    FILE_DEVICE_UNKNOWN shl 16 + $ACB shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_LOAD_IRQ =
    FILE_DEVICE_UNKNOWN shl 16 + $ACC shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_LOAD_IRQEVENT =
    FILE_DEVICE_UNKNOWN shl 16 + $ACD shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_REALLOC_BUSMASTER =
    FILE_DEVICE_UNKNOWN shl 16 + $ACE shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_GETLASTERROR =
    FILE_DEVICE_UNKNOWN shl 16 + $ACF shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_MAP_DUALPORT =
    FILE_DEVICE_UNKNOWN shl 16 + $AD0 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_UNMAP_DUALPORT =
    FILE_DEVICE_UNKNOWN shl 16 + $AD1 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_PORT_READ =
    FILE_DEVICE_UNKNOWN shl 16 + $AD2 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_PORT_WRITE =
    FILE_DEVICE_UNKNOWN shl 16 + $AD3 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_LOAD_TARGET =
    FILE_DEVICE_UNKNOWN shl 16 + $AD4 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_MAP_HPI =
    FILE_DEVICE_UNKNOWN shl 16 + $AD5 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;

  M62_IOCTL_UNMAP_HPI =
    FILE_DEVICE_UNKNOWN shl 16 + $AD6 shl 2 + METHOD_BUFFERED + FILE_ANY_ACCESS shl 14;


type
  TM62_PORTIO=
    record
      Offset,Data:integer;
    end;

  PM62_PORTIO=^TM62_PORTIO;

  TM62_MEMIO=
    record
      Offset,data:integer;
    end;
  PM62_MEMIO=^TM62_MEMIO;

  TM62_BOARD_DESC=
    record
         Hpi: TMemoryBlock;
         DualPort: TMemoryBlock;
         BusMaster: TMemoryBlock;
         OpReg: TIoPortBlock;
         IRQ : integer;
         Version: integer;
    end;
  PM62_BOARD_DESC=^TM62_BOARD_DESC;

  TM62_LOAD_EVENT=
    record
      Ring0Handle: HANDLE;
    end;
  PM62_LOAD_EVENT=^TM62_LOAD_EVENT;

  TM62_LOAD_TARGET=
    record
      Target:integer;
    end;
  PM62_LOAD_TARGET=^TM62_LOAD_TARGET;


//--------------------------------------------
// Command constants
//--------------------------------------------

Const
  MAILBOX_COMMAND  =	0;
  MAILBOX_SYNCHRO  =	0;
  MAILBOX_VALUE	   =    1;
  MAILBOX_HOST	   =	2;

  QUIT		   =	0;
  INIT_VOLTAGE	   =    1;
  RUN		   =    2;
  SET_CELSIUS	   =	3;
  SET_DT	   =	4;
  RECORD_V	   =   	5;
  RECORD_R	   =	6;
  GET_RECORD	   =	7;
  PLAY		   =	8;
  SET_V		   =	9;
  GET_V		   =  	10;
  SET_R		   =	11;
  GET_R		   =  	12;
  SET_G		   =  	13;
  GET_G		   =  	14;
  INIT_E_S	   =  	15;
  STOP		   =  	16;
  EVALUATE_DT	   =	17;
  FIN_EVALUATE_DT  =	18;
  OK_TRANSFER_DATA =	19;
  TRANSFERING_DATA =	20;
  RECORD_DATA	   =	21;
  STOP_TRANSFER	   =    22;
  SWITCH_DOUTPUT   =	23;
  EVALUATE_TIME_IT =	24;

  IDM_EXIT         =  100;
  IDM_TEST         =  200;
  IDM_ABOUT        =  301;
  TITLE_LENGTH	   =  100;


  DMA_PCI_ADDR1=	$90;
  DMA_LOCAL_ADDR1=      $94;



//-------------------------------------------
// Communication constants
//-------------------------------------------
  TARGET_NOT_RESPONDING	  =	100;
  LOAD_FAILED		  =	101;
  SYNCHRONISATION_FAILED  =	102;
  COMMUNICATION_OK 	  =	103;
//-------------------------------------------


  TARGET_NUMBER= 0;


  OUTFILE= 'E_S_dsp.out';


//Data exchange structures
type
  TSignalInfo=
    record
      name:array[1..100] of char;
      Val:Pdouble;  //store address of signal choosen
    end;

//Buffer struct
  TSignalBuffer=
    record
	FlagBufferChoosen: BOOL;
	FlagStartTransfer: BOOL;
	FlagBufferFull: BOOL;
        OnRecord: BOOL;
        name:array[1..100] of char;
	m_nValToStore: integer;
	m_nVal: integer;
	m_nBuffer: integer;
	m_dt: single;
	val: Pdouble;
	m_DataBuffer: array[1..10000000] of single;
      end;

//Memory shared file struct
  TShareDataStruct=
    record
      dt:double;
      m_nSignalInList:integer;
      Signal:array[1..10] of TsignalInfo;
      BufferSignalList: array[1..4] of TSignalBuffer;
    end;


{ctrlDsp.c}
function DspInit(target:integer):boolean;
procedure DspReset(target:integer);
function DspDownload(target:integer;OutFile:string):integer;
function DspSynchronisation(target:integer):integer;
procedure DspSendCommand(target,code:integer);
procedure SendValue(target, box, value: integer);
procedure DspSetDt(target:integer;dt:single);
procedure DspRun(target: integer);
procedure DspQuit(target:integer);
procedure DspClearMailboxes(target:integer);
procedure SetInterrupt(target:integer; p: TvirtualISR);
procedure DeinstallInterrupt(target:integer);
function DspInterruptAck(target: integer):longWord;
procedure outbox1(target:integer;value:integer);
procedure outbox0(target:integer;value:integer);
function inbox0(target:integer):integer;
function inbox1(target:integer):integer;
procedure write_mb_float(target,mailbox:integer; f: single);


procedure TestDSP;
procedure Xstop;

implementation



//----------------------------------------------------------
// DspInit() open Dsp driver for the target number specified
// return false if failed true otherwise
//----------------------------------------------------------

function DspInit(target:integer):boolean;
begin
  result:= (M62_open(target)<>0);
end;

//----------------------------------------------------------
// DspReset()  perform a target reset no return value
//----------------------------------------------------------

procedure DspReset(target:integer);
begin
  M62_reset(target);
  M62_clear_mailboxes(target);
  M62_run(target);
end;

//----------------------------------------------------------
// DspDownload download COFF file on targeted dsp card
// return TARGET_NOT_RESPONDING if talker init failed
// return LOAD_FAILED if download failed
// return TRUE if DspDownload succeed
//----------------------------------------------------------

function DspDownload(target:integer;OutFile:string):integer;
begin
  M62_reset(target);
  M62_clear_mailboxes(target);
  M62_run(target);
  if M62_start_talker(target)=0
    then result:= TARGET_NOT_RESPONDING
  else
  if M62_iicoffld(@OutFile[1],target,0)<>0
    then result:=LOAD_FAILED
  else
    begin
      M62_start_app(target);
      result:=0;
    end;
end;

//--------------------------------------------------
// DspSynchronisation() Test sync with dsp
//--------------------------------------------------

function DspSynchronisation(target:integer):integer;
var
  count,read_value:integer;
begin
   count:=0;
   read_value:=0;

   repeat
     inc(count);
     M62_read_mb_terminate(target,MAILBOX_SYNCHRO,read_value,0);
     Sleep(100);

   until (count>=50) or (read_value=$a5a5);

   if (count>=50)
     then result:= SYNCHRONISATION_FAILED
     else result:= COMMUNICATION_OK;
end;

//-----------------------------------------------------
// DspSendCommand() Send command code to Dsp application
//-----------------------------------------------------
procedure DspSendCommand(target,code:integer);
begin
  M62_write_mailbox(target, MAILBOX_COMMAND, code);
end;

//------------------------------------------------------
// SendValue() Send a value to Dsp for output
//------------------------------------------------------

procedure SendValue(target, box, value: integer);
begin
  M62_write_mailbox(target,box,value);
end;


//-----------------------------------------------------
//  DspSetDt() Send dt to Dsp application to fix interrupt t step
//-----------------------------------------------------

procedure DspSetDt(target:integer;dt: single);
begin
  M62_write_mailbox(target, MAILBOX_COMMAND, SET_DT);
  write_mb_float(target, MAILBOX_COMMAND, dt);
end;


//-----------------------------------------------------
// DspRun() Run Dsp application
//-----------------------------------------------------

procedure DspRun(target: integer);
begin
  M62_write_mailbox(target, MAILBOX_COMMAND, RUN);
end;



//-----------------------------------------------------
// DspQuit() Quit Dsp Application
//-----------------------------------------------------

procedure DspQuit(target:integer);
begin
  M62_write_mailbox(target, MAILBOX_COMMAND, QUIT);
end;




procedure DspClearMailboxes(target:integer);
begin
  M62_clear_mailboxes(target);
end;

//-----------------------------------------------------
// SetInterrupt() Set and enable host interrupt
//-----------------------------------------------------

procedure SetInterrupt(target:integer; p: TvirtualISR);
begin
  M62_host_interrupt_install(target,p,nil);
  M62_host_interrupt_enable(target);
end;


//-----------------------------------------------------
// DeinstallInterrupt() Deinstall host interrupt vector
//-----------------------------------------------------

procedure DeinstallInterrupt(target:integer);
begin
  M62_host_interrupt_disable(target);
  M62_host_interrupt_deinstall(target);
end;


//-----------------------------------------------------
//  DspInterruptAck() Acknowledge Dsp interruption
//-----------------------------------------------------

function DspInterruptAck(target: integer):longWord;
begin
  result:=M62_mailbox_interrupt_ack(target);
end;

//-----------------------------------------------------
//  inBox0 and inBox1 read value on mailbox 0/1 without any checking
//  outBox0 and outbox1 write value on  mailbox 0/1 without checking if empty
//-----------------------------------------------------
function inbox0(target:integer):integer;
begin
  result:=M62_inPort(target,192);
end;

function inbox1(target:integer):integer;
begin
  result:=M62_inPort(target,200);
end;

procedure outbox1(target:integer;value:integer);
begin
  M62_outPort(target,204,value);
end;

procedure outbox0(target:integer;value:integer);
begin
  M62_outPort(target,196,value);
end;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Internal functions
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

procedure write_mb_float(target,mailbox:integer; f: single);
var
  i:integer absolute f;
begin
  M62_write_mailbox(target, mailbox, i);
end;



{******************** Test de la carte DSP ************************************}

var
  Fcommand,Frunning:boolean;
  nbInter:integer;
  vin1,Vin2:integer;


procedure setdt(dt:single);
begin
  Fcommand:=TRUE;   //to avoid command to be overloaded in the loop
  DspClearMailboxes(TARGET_NUMBER);
  DspSetDt(TARGET_NUMBER,dt);
  Fcommand:=FALSE;
end;


Procedure Xrun;
begin
  if not FRunning then
  begin
    DspClearMailboxes(TARGET_NUMBER);
    DspSendCommand(TARGET_NUMBER,RUN);
    FRunning:=true;
  end
  else messageCentral('Dsp Simulation is still running');
end;

Procedure Xstop;
begin
  Fcommand:=TRUE;
  DspClearMailboxes(TARGET_NUMBER);
  if FRunning then
  begin
    DspSendCommand(TARGET_NUMBER,STOP);
    FRunning:=false;
  end
  else messageCentral('Dsp Simulation not running');
  Fcommand:=FALSE;
end;


procedure isr_step(context:pointer);cdecl;
var
  vout:integer;
begin
  inc(nbInter);
  vout:=0;

  Vin2:=inbox0(TARGET_NUMBER);
  Vin1:=DspInterruptAck(TARGET_NUMBER);

  { Vin2:  bits 0 et 1 :entrées numériques
                2..15:  entrée analogique  I3
                16..31: entrée analogique  I4
    Vin1:  bits  0..15:  entrée analogique  I1
                16..31:  entrée analogique  I2
  }

  //On calcule un pas supplémentaire
  {nrn_fixed_step();}

  //Les sorties 1 et 2 sont rangées dans la boite aux lettres 0
  vout:=Vin1;
  if not Fcommand then outbox0(TARGET_NUMBER,vout);

  //Les sorties 3 et 4 sont rangées dans la boite aux lettres 1
  vout:=Vin2;
  outbox1(TARGET_NUMBER,vout);
end;


procedure TestDSP;
var
  state:integer;
  dsp:PcardInfo;
begin
  if not initM62lib then
  begin
    messageCentral('InitLib failed');
    exit;
  end;

  if not DspInit(0) then
  begin
    messageCentral('DspInit failed');
    exit;
  end;

  SetInterrupt(0,isr_step);

  state:=DspDownload(0, AppData +'E_S_dsp.out');
  case state of
    TARGET_NOT_RESPONDING : messageCentral('talker failed');
    LOAD_FAILED : messageCEntral('iicoffld failed');
  end;

  if DspSynchronisation(0)=SYNCHRONISATION_FAILED
    then messageCentral('Communication failed')
    else messageCentral('Dsp Board ready for requests');

  dsp := M62_cardinfo(0);
  messageCentral(Istr(dsp^.device));

  setDt(1);
  XRun;

  statusLineTxt('DSP running');
  {
  Repeat
    statusLineTxt(Istr1(nbInter,6)+Istr1(smallint(Vin1 and $FFFF),6)+Istr1(smallint(Vin1 shr 16),6)
                                  +Istr1(smallint(Vin2 and $FFFF),6)+Istr1(smallint(Vin2 shr 16),6)
                 );
  until testEscape;
  XStop;

  messageCentral('OK');
  }
end;



end.
