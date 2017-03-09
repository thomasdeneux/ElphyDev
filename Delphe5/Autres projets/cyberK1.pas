unit CyberK1;

Interface

uses Windows, messages;

{$A1 }

(* =STS=> cbhwlib.h[1687].aa28   submit   SMID:29 *)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// (c) Copyright 2002-2007 Cyberkinetics, Inc.
//
// $Workfile: cbhwlib.h $
// $Archive: /Cerebus/Human/LinuxApps/player/cbhwlib.h $
// $Revision: 50 $
// $Date: 5/17/05 10:07a $
// $Author: Dsebald $
//
// $NoKeywords: $
//
//////////////////////////////////////////////////////////////////////////////////////////////////

//
// PURPOSE:
//
// This code libary defines an standardized control and data acess interface for microelectrode
// neurophysiology equipment.  The interface allows several applications to simultaneously access
// the control and data stream for the equipment through a central control application.  This
// central application governs the flow of information to the user interface applications and
// performs hardware specific data processing for the instruments.  This is diagrammed as follows:
//
//   Instruments <---> Central Control App <--+--> Cerebus Library <---> User Application
//                                            +--> Cerebus Library <---> User Application
//                                            +--> Cerebus Library <---> User Application
//
// The Central Control Application can also exchange window/application configuration data so that
// the Central Application can save and restore instrument and application window settings.
//
// All hardware configuration, hardware acknowledgement, and data information are passed on the
// system in packet form.  Cerebus user applications interact with the hardware in the system by
// sending and receiving configuration and data packets through the Central Control Application.
// In order to aid efficiency, the Central Control App caches information regarding hardware
// configuration so that multiple applications do not need to request hardware configuration
// packets from the system.  The Neuromatic Library provides high-level functions for retreiving
// data from this cache and high-level functions for transmitting configuration packets to the
// hardware.  Neuromatic applications must provide a callback function for receiving data and
// configuration acknowledgement packets.
//
// The data stream from the hardware is composed of "neural data" to be saved in experiment files
// and "preview data" that provides information such as compressed real-time channel data for
// scrolling displays and Line Noise Cancellation waveforms to update the user.
//
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Special Notes:
//
// - In Win32 applications include <windows.h> before declaring this header
//
///////////////////////////////////////////////////////////////////////////////////////////////////


Const

  cbVERSION_MAJOR  = 3;
  cbVERSION_MINOR  = 5;

// Version history:
//  3.5 -  1 Aug 2007 hls - Added env min/max for threshold preview
//  3.4 - 12 Jun 2007 mko - Change Spike Sort Override Circles to Ellipses
//        31 May 2007 hls - Added cbPKTTYPE_REFELECFILTSET
//        19 Jun 2007 hls - Added cbPKT_SS_RESET_MODEL
//  3.3 - 27 Mar 2007 mko - Include angle of rotation with Noise Boundary variables
//  3.2 - 7  Dec 2006 mko - Make spike width variable - to max length of 128 samples
//        20 Dec 2006 hls - move wave to end of spike packet
//  3.1 - 25 Sep 2006 hls - Added unit mapping functionality
//        17 Sep 2006 djs - Changed from noise line to noise ellipse and renamed
//                          variables with NOISE_LINE to NOISE_BOUNDARY for
//                          better generalization context
//        15 Aug 2006 djs - Changed exponential measure to histogram correlation
//                          measure and added histogram peak count algorithm
//        21 Jul 2006 djs/hls - Added exponential measure autoalg
//                    djs/hls - Changed exponential measure to histogram correlation
//                              measure and added histogram peak count algorithm
//                    mko     - Added protocol checking to procinfo system
//  3.0 - 15 May 2006 hls - Merged the Manual & Auto Sort protocols
//  2.5 - 18 Nov 2005 hls - Added cbPKT_SS_STATUS
//  2.4 - 10 Nov 2005 kfk - Added cbPKT_SET_DOUT
//  2.3 - 02 Nov 2005 kfk - Added cbPKT_SS_RESET
//  2.2 - 27 Oct 2005 kfk - Updated cbPKT_SS_STATISTICS to include params to affect
//                          spike sorting rates
//
//  2.1 - 22 Jun 2005 kfk - added all packets associated with spike sorting options
//                          cbPKTDLEN_SS_DETECT
//                          cbPKT_SS_ARTIF_REJECT
//                          cbPKT_SS_NOISE_LINE
//                          cbPKT_SS_STATISTICS
//
//  2.0 - 11 Apr 2005 kfk - Redifined the Spike packet to include classificaiton data
//
//  1.8 - 27 Mar 2006 ab  - Added cbPKT_SS_STATUS
//  1.7 -  7 Feb 2006 hls - Added anagain to cbSCALING structure
//                          to support different external gain
//  1.6 - 25 Feb 2005 kfk - Added cbPKTTYPE_ADAPTFILTSET and
//                          cbGetAdaptFilter() and cbSGetAdaptFilter()
//  1.5 - 30 Dec 2003 kfk - Added cbPKTTYPE_REPCONFIGALL and cbPKTTYPE_PREVREP
//                          redefined cbPKTTYPE_REQCONFIGALL
//  1.4 - 15 Dec 2003 kfk - Added "last_valid_index" to the send buffer
//                          Added cbDOUT_TRACK
//


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Fixed storage size definitions for delcared variables
// (includes conditional testing so that there is no clash with win32 headers)
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type
  INT8 = shortint;
  UINT8 = byte;

  INT16 = smallint;
  UINT16 =word;

  INT32 = integer;
  UINT32 = longword;

  PINT8 = ^shortint;
  PUINT8 = ^byte;

  PINT16 = ^smallint;
  PUINT16 =^word;

  PINT32 = ^integer;
  PUINT32 = ^longword;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Maximum entity ranges for static declarations using this version of the library
//
///////////////////////////////////////////////////////////////////////////////////////////////////
Const
  cbNSP1      = 1;

  cbMAXPROCS  = 1;
  cbMAXBANKS  = 16;
  cbMAXGROUPS = 8;
  cbMAXFILTS  = 32;
  cbMAXCHANS  = 160;
  cbNUM_ANALOG_CHANS    = 144;
  cbMAXUNITS  = 5;
  cbMAXHOOPS  = 4;
  cbMAXNTRODES = cbNUM_ANALOG_CHANS div 2;     // minimum is stereotrode so max n-trodes is max chans / 2
  cbMAXSITES  = 4;               // maximum number of electrodes that can be included in an n-trode group

// Special unit classification values
type
  UnitClassification=(
    UC_UNIT_UNCLASSIFIED    = 0,        // This unit is not classified
    UC_UNIT_NOISE           = 255      // This unit is really noise
  );

///////////////////////////////////////////////////////////////////////////////////////////////////
//  Some of the string length constants
Const
  cbLEN_STR_UNIT       = 8;
  cbLEN_STR_LABEL     = 16;
  cbLEN_STR_IDENT     = 64;
///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Library Result defintions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type
  cbRESULT = longword;

Const
  cbRESULT_OK                 = 0;   // Function executed normally
  cbRESULT_NOLIBRARY          = 1;   // The library was not properly initialized
  cbRESULT_NOCENTRALAPP       = 2;   // Unable to access the central application
  cbRESULT_LIBINITERROR       = 3;   // Error attempting to initialize library error
  cbRESULT_MEMORYUNAVAIL      = 4;   // Not enough memory available to complete the operation
  cbRESULT_INVALIDADDRESS     = 5;   // Invalid Processor or Bank address
  cbRESULT_INVALIDCHANNEL     = 6;   // Invalid channel ID passed to function
  cbRESULT_INVALIDFUNCTION    = 7;   // Channel exists, but requested function is not available
  cbRESULT_NOINTERNALCHAN     = 8;   // No internal channels available to connect hardware stream
  cbRESULT_HARDWAREOFFLINE    = 9;   // Hardware is offline or unavailable
  cbRESULT_DATASTREAMING     = 10;   // Hardware is streaming data and cannot be configured
  cbRESULT_NONEWDATA         = 11;   // There is no new data to be read in
  cbRESULT_DATALOST          = 12;   // The Central App incoming data buffer has wrapped
  cbRESULT_INVALIDNTRODE     = 13;   // Invalid NTrode number passed to function



///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Library Initialization Functions
//
// The standard procedure for intializing and using this library is to:
//   1) Intialize the library with cbOpen().
//   2) Obtain system and channel configuration info with cbGet* commands.
//   3) Configure the system channels with appropriate cbSet* commands.
//   4) Receive data through the callback function
//   5) Repeat steps 2/3/4 as needed until the application closes.
//   6) call cbDone() to de-allocate and free the library
//
///////////////////////////////////////////////////////////////////////////////////////////////////

var
  cbVersion: function: UINT32;cdecl;
// Returns the major/minor revision of the current library in the upper/lower UINT16 fields.


  cbOpen: function: cbRESULT;cdecl;
// Initializes the Neuromatic library and establishes a link to the Central Control Application.
// This function must be called before any other functions are called from this library.
// Returns OK, NOCENTRALAPP, LIBINITERROR, MEMORYUNVAIL, or HARDWAREOFFLINE


  cbClose: function: cbRESULT;cdecl;
// Shuts down the programming library and frees any resources linked in cbOpen()
// Returns cbRESULT_OK if successful, cbRESULT_NOLIBRARY if library was never initialized.


// Updates the read pointers in the memory area so that
// all of the un-read packets are ignored. In other words, it
// initializes all of the pointers so that the begging of read time is NOW.
  cbMakePacketReadingBeginNow: function: cbRESULT;cdecl;



///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Detailed Processor and Bank Inquiry Functions
//
// Instrumentation equipment is organized into three levels within this library:
//   1) Signal Processors - Signal processing and data distribution layer
//   2) Signal Banks      - Groups of channels with similar properties and physical locations
//   3) Signal Channels   - Individual physical channels with one or more functions
//
//   Computer --+-- Signal Processor ----- Signal Bank --+-- Channel
//              |                      |                 +-- Channel
//              |                      |                 +-- Channel
//              |                      |
//              |                      +-- Signal Bank --+-- Channel
//              |                                        +-- Channel
//              |                                        +-- Channel
//              |
//              +-- Signal Processor ----- Signal Bank --+-- Channel
//                                     |                 +-- Channel
//                                     |                 +-- Channel
//                                     |
//                                     +-- Signal Bank --+-- Channel
//                                                       +-- Channel
//                                                       +-- Channel
//
// In this implementation, Signal Channels are numbered from 1-32767 across the entire system and
// are associated to Signal Banks and Signal Processors by the hardware.
//
// Signal Processors are numbered 1-8 and Signal Banks are numbered from 1-16 within specific
// a specific Signal Processor.  Processor and Bank numbers are NOT required to be continuous and
// are a function of the hardware configuration.  For example, an instrumentation set-up could
// include Processors at addresses 1, 2, and 7.  Configuration packets given to the computer to
// describe the hardware also report the channel enumeration.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
  cbSORTMETHOD_MANUAL     = 0;
  cbSORTMETHOD_AUTO       = 1;

// Signal Processor Configuration Structure
type
  cbPROCINFO = record
    idcode: UINT32;      // manufacturer part and rom ID code of the Signal Processor
    ident: array[0..cbLEN_STR_IDENT-1] of char;   // ID string with the equipment name of the Signal Processor
    chanbase: UINT32;    // lowest channel identifier claimed by this processor
    chancount: UINT32;   // number of channel identifiers claimed by this processor
    bankcount: UINT32;   // number of signal banks supported by the processor
    groupcount: UINT32;  // number of sample groups supported by the processor
    filtcount: UINT32;   // number of digital filters supported by the processor
    sortcount: UINT32;   // number of channels supported for spike sorting (reserved for future)
    unitcount: UINT32;   // number of supported units for spike sorting    (reserved for future)
    hoopcount: UINT32;   // number of supported hoops for spike sorting    (reserved for future)
    sortmethod: UINT32;  // sort method  (0=manual, 1=automatic spike sorting)
    version: UINT32;     // current version of libraries
  end;
  PcbPROCINFO=^cbPROCINFO;

var
  cbGetProcInfo: function( proc: UINT32; procinfo: PcbPROCINFO ): cbRESULT;cdecl;
// Retreives information for a the Signal Processor module located at procid
// The function requires an allocated but uninitialized cbPROCINFO structure.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDADDRESS if no hardware at the specified Proc and Bank address
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


// Signal Bank Configuration Structure

type
  cbBANKINFO = record
    idcode: UINT32;     // manufacturer part and rom ID code of the module addressed to this bank
    ident: array[0..cbLEN_STR_IDENT-1] of char;  // ID string with the equipment name of the Signal Bank hardware module
    label1: array[0..cbLEN_STR_LABEL-1] of char;  // Label on the instrument for the signal bank, eg "Analog In"
    chanbase: UINT32;   // lowest channel identifier claimed by this bank
    chancount: UINT32;  // number of channel identifiers claimed by this bank
  end;
  PcbBANKINFO = ^cbBANKINFO;

var
  cbGetBankInfo: function( proc: UINT32; bank: UINT32; bankinfo: PcbBANKINFO ): cbRESULT;cdecl;
// Retreives information for the Signal bank located at bankaddr on Proc procaddr.
// The function requires an allocated but uninitialized cbBANKINFO structure.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDADDRESS if no hardware at the specified Proc and Bank address
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetChanCount: function( count: PUINT32): cbRESULT;cdecl;
// Retreives the total number of channels in the system
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Systemwide Inquiry and Configuration Functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
  cbRUNLEVEL_STARTUP      = $10;
  cbRUNLEVEL_HARDRESET    = $20;
  cbRUNLEVEL_STANDBY      = $30;
  cbRUNLEVEL_RESET        = $40;
  cbRUNLEVEL_RUNNING      = $50;
  cbRUNLEVEL_STRESSED     = 60;
  cbRUNLEVEL_ERROR        = 70;
  cbRUNLEVEL_SHUTDOWN     = 80;

var
  cbGetSystemRunLevel: function( runlevel: PUINT32;  locked: PUINT32;  resetque: PUINT32 ): cbRESULT;cdecl;
  cbSetSystemRunLevel: function(  runlevel: UINT32;  locked: UINT32;  resetque: UINT32 ): cbRESULT;cdecl;
// Get Set the System Condition
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_NOLIBRARY if the library was not properly initialized


  cbGetSystemClockFreq: function(  freq: PUINT32 ): cbRESULT;cdecl;
// Retreives the system timestamp/sample clock frequency (in Hz) from the Central App cache.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_NOLIBRARY if the library was not properly initialized


  cbGetSystemClockTime: function(  time: PUINT32 ): cbRESULT;cdecl;
// Retreives the last 32-bit timestamp from the Central App cache.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_NOLIBRARY if the library was not properly initialized


  cbGetSpikeLength: function( length: PUINT32;  pretrig: PUINT32;  pSysfreq: PUINT32): cbRESULT;cdecl;
  cbSetSpikeLength: function( length: UINT32;  pretrig: UINT32): cbRESULT;cdecl;
// Get/Set the system-wide spike length.  Lengths should be specified in multiples of 2 and
// within the range of 16 to 128 samples long.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if invalid flag combinations are passed.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


Const
   cbFILTTYPE_PHYSICAL       = $0001;
   cbFILTTYPE_DIGITAL        = $0002;
   cbFILTTYPE_ADAPTIVE       = $0004;
   cbFILTTYPE_NONLINEAR      = $0008;
   cbFILTTYPE_BUTTERWORTH    = $0100;
   cbFILTTYPE_CHEBYCHEV      = $0200;
   cbFILTTYPE_BESSEL         = $0400;
   cbFILTTYPE_ELLIPTICAL     = $0800;
type
  cbFILTDESC = record
    label1: array[0..cbLEN_STR_LABEL-1] of char ;
    hpfreq: UINT32;     // high-pass corner frequency in milliHertz
    hporder: UINT32;    // high-pass filter order
    hptype: UINT32;     // high-pass filter type
    lpfreq: UINT32;     // low-pass frequency in milliHertz
    lporder: UINT32;    // low-pass filter order
    lptype: UINT32;     // low-pass filter type
  end;
  PcbFILTDESC=^cbFILTDESC;

var
  cbGetFilterDesc: function(  proc: UINT32;  filt: UINT32; filtdesc: PcbFILTDESC ): cbRESULT;cdecl;
// Retreives the user filter definitions from a specific processor
// filter = 1 to cbNFILTS, 0 is reserved for the null filter case
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDADDRESS if no hardware at the specified Proc and Bank address
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


///////////////////////////////////////////////////////////////////////////////////////////////////
// Adaptive filtering

// Tell me about the current adaptive filter settings
  cbGetAdaptFilter: function(  proc: UINT32;             // which NSP processor?
                               pnMode: PUINT32;         // 0=disabled, 1=filter continuous & spikes, 2=filter spikes
                               pdLearningRate: Psingle; // speed at which adaptation happens. Very small. e.g. 5e-12
                               pnRefChan1: PUINT32;     // The first reference channel (1 based)
                               pnRefChan2: PUINT32): cbRESULT;cdecl;    // The second reference channel (1 based).


// Update the adaptive filter settings
  cbSetAdaptFilter: function(  proc: UINT32;             // which NSP processor?
                               pnMode: PUINT32;         // 0=disabled, 1=filter continuous & spikes, 2=filter spikes
                               pdLearningRate: Psingle; // speed at which adaptation happens. Very small. e.g. 5e-12
                               pnRefChan1: PUINT32;     // The first reference channel (1 based.
                               pnRefChan2: PUINT32): cbRESULT;cdecl;    // The second reference channel (1 based.


///////////////////////////////////////////////////////////////////////////////////////////////////
// Reference Electrode filtering

// Tell me about the current reference electrode filter settings
  cbGetRefElecFilter: function(  proc: UINT32;           // which NSP processor?
                              pnMode: PUINT32;       // 0=disabled, 1=filter continuous & spikes, 2=filter spikes
                              pnRefChan: PUINT32): cbRESULT;cdecl;   // The reference channel (1 based)


// Update the reference electrode filter settings
  cbSetRefElecFilter: function(  proc: UINT32;           // which NSP processor?
                                 pnMode: PUINT32;       // 0=disabled, 1=filter continuous & spikes, 2=filter spikes
                                 pnRefChan: PUINT32): cbRESULT;cdecl;   // The reference channel (1 based).



///////////////////////////////////////////////////////////////////////////////////////////////////



  cbGetSampleGroupInfo: function(  proc: UINT32;  group: UINT32; label1:Pchar;  period: PUINT32;  length: PUINT32 ): cbRESULT;cdecl;
  cbGetSampleGroupList: function(  proc: UINT32;  group: UINT32; length: PUINT32;  list: PUINT32 ): cbRESULT;cdecl;

// N'existe pas.
// cbSetSampleGroupOptions: function(  proc: UINT32;  group: UINT32;  period: UINT32; label1:Pchar ): cbRESULT;cdecl;
// Retreives the Sample Group information in a processor and their definitions
// Labels are 16-characters maximum.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDADDRESS if no hardware at the specified Proc and Bank address
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Individual Channel Inquiry and Configuration Options
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
  cbCHAN_EXISTS        = $00000001;  // Channel id is allocated
  cbCHAN_CONNECTED     = $00000002;  // Channel is connected and mapped and ready to use
  cbCHAN_ISOLATED      = $00000004;  // Channel is electrically isolated
  cbCHAN_AINP          = $00000100;  // Channel has analog input capabilities
  cbCHAN_AOUT          = $00000200;  // Channel has analog output capabilities
  cbCHAN_DINP          = $00000400;  // Channel has digital input capabilities
  cbCHAN_DOUT          = $00000800;  // Channel has digital output capabilities

var
  cbGetChanCaps: function(  chan: UINT32;  chancaps: PUINT32 ): cbRESULT;cdecl;
// Retreives the channel capabilities from the Central App Cache.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetChanLoc: function(  chan: UINT32; proc: PUINT32; bank: PUINT32;  banklabel: Pchar; term: PUINT32 ): cbRESULT;cdecl;
// Gives the physical processor number, bank label, and terminal number of the specified channel
// by reading the configuration data in the Central App Cache.  Bank Labels are the name of the
// bank that is written on the instrument and they are null-terminated, up to 16 char long.
//
// Returns: cbRESULT_OK if all is ok
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


// flags for user flags...no effect on the cerebus
//  cbUSER_DISABLED      = $00000001;  // Channel should be electrically disabled
//  cbUSER_EXPERIMENT    = $00000100;  // Channel used for experiment environment information
//  cbUSER_NEURAL        = $00000200;  // Channel connected to neural electrode or signal

  cbGetChanLabel: function(  chan: UINT32; label1: Pchar; userflags: PUINT32;  position: PINT32): cbRESULT;cdecl;
  cbSetChanLabel: function(  chan: UINT32; label1: Pchar;  userflags: UINT32;  position: PINT32): cbRESULT;cdecl;
// Get and Set the user-assigned label for the channel.  Channel Names may be up to 16 chars long
// and should be null terminated if shorter.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetChanNTrodeGroup: function(  chan: UINT32; NTrodeGroup: PUINT32): cbRESULT;cdecl;
  cbSetChanNTrodeGroup: function(  chan: UINT32;  NTrodeGroup: PUINT32): cbRESULT;cdecl;
// Get and Set the user-assigned label for the N-Trode.  N-Trode Names may be up to 16 chars long
// and should be null terminated if shorter.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


type
  cbMANUALUNITMAPPING = record
    nOverride: UINT32;
    afOrigin: array [0..1] of single;
    afShape: array [0..1,0..1] of single;
    aPhi: single;
    bValid: UINT32; // is this unit in use at this time?
                        // BOOL implemented as UINT32 - for structure alignment at paragraph boundary
  end;
  PcbMANUALUNITMAPPING= ^cbMANUALUNITMAPPING;

var
  cbGetChanUnitMapping: function(  chan: UINT32; unitmapping: PcbMANUALUNITMAPPING): cbRESULT;cdecl;
  cbSetChanUnitMapping: function(  chan: UINT32;  unitmapping: PcbMANUALUNITMAPPING): cbRESULT;cdecl;
// Get and Set the user-assigned unit override for the channel.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Digital Input Inquiry and Configuration Functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
   cbDINP_SERIALMASK   = $000000FF;  // Bit mask used to detect RS232 Serial Baud Rates
   cbDINP_BAUD2400     = $00000001;  // RS232 Serial Port operates at 2400   (n-8-1)
   cbDINP_BAUD9600     = $00000002;  // RS232 Serial Port operates at 9600   (n-8-1)
   cbDINP_BAUD19200    = $00000004;  // RS232 Serial Port operates at 19200  (n-8-1)
   cbDINP_BAUD38400    = $00000008;  // RS232 Serial Port operates at 38400  (n-8-1)
   cbDINP_BAUD57600    = $00000010;  // RS232 Serial Port operates at 57600  (n-8-1)
   cbDINP_BAUD115200   = $00000020;  // RS232 Serial Port operates at 115200 (n-8-1)
   cbDINP_1BIT         = $00000100;  // Port has a single input bit (eg single BNC input)
   cbDINP_8BIT         = $00000200;  // Port has 8 input bits
   cbDINP_16BIT        = $00000400;  // Port has 16 input bits
   cbDINP_32BIT        = $00000800;  // Port has 32 input bits
   cbDINP_ANYBIT       = $00001000;  // Capture the port value when any bit changes.
   cbDINP_WRDSTRB      = $00002000;  // Capture the port when a word-write line is strobed
   cbDINP_PKTCHAR      = $00004000;  // Capture packets using an End of Packet Character
   cbDINP_PKTSTRB      = $00008000;  // Capture packets using an End of Packet Logic Input
   cbDINP_MONITOR      = $00010000;  // Port controls other ports or system events
   cbDINP_REDGE	       = $00020000;  // Capture the port value when any bit changes lo-2-hi (rising edge)
   cbDINP_FEDGE	       = $00040000;  // Capture the port value when any bit changes hi-2-lo (falling edge)

var
  cbGetDinpCaps: function(  chan: UINT32;  dinpcaps: PUINT32 ): cbRESULT;cdecl;
// Retreives the channel's digital input capabilities from the Central App Cache.
// Port Capabilities are reported as compbined cbDINPOPT_* flags.  Zero = no DINP capabilities.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetDinpOptions: function(  chan: UINT32; options: PUINT32; eopchar: PUINT32 ): cbRESULT;cdecl;
  cbSetDinpOptions: function(  chan: UINT32;  options: UINT32;  eopchar: UINT32 ): cbRESULT;cdecl;
// Get/Set the Digital Input Port options for the specified channel.
//
// Port options are expressed as a combined set of cbDINP_* option flags, for example:
// a) cbDINP_SERIAL + cbDINP_BAUDxx = capture single 8-bit RS232 serial values.
// b) cbDINP_SERIAL + cbDINP_BAUDxx + cbDINP_PKTCHAR = capture serial packets that are terminated
//      with an end of packet character (only the lower 8 bits are used).
// c) cbDINP_1BIT + cbDINP_ANYBIT = capture the changes of a single digital input line.
// d) cbDINP_xxBIT + cbDINP_ANYBIT = capture the xx-bit input word when any bit changes.
// e) cbDINP_xxBIT + cbDINP_WRDSTRB = capture the xx-bit input based on a word-strobe line.
// f) cbDINP_xxBIT + cbDINP_WRDSTRB + cbDINP_PKTCHAR = capture packets composed of xx-bit words
//      in which the packet is terminated with the specified end-of-packet character.
// g) cbDINP_xxBIT + cbDINP_WRDSTRB + cbDINP_PKTLINE = capture packets composed of xx-bit words
//      in which the last character of a packet is accompanyied with an end-of-pkt logic signal.
// h) cbDINP_xxBIT + cbDINP_REDGE = capture the xx-bit input word when any bit goes from low to hi.
// i) cbDINP_xxBIT + dbDINP_FEDGE = capture the xx-bit input word when any bit goes from hi to low.
//
// NOTE: If the end-of-packet character value (eopchar) is not used in the options, it is ignored.
//
// Add cbDINP_PREVIEW to the option set to get preview updates (cbPKT_PREVDINP) at each word,
// not only when complete packets are sent.
//
// The Get function returns values from the Central Control App cache.  The Set function validates
// that the specified options are available and then queues a cbPKT_SETDINPOPT packet.  The system
// acknowledges this change with a cbPKT_ACKDINPOPT packet.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDFUNCTION a requested option is not available on that channel.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.



///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Digital Output Inquiry and Configuration Functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
   cbDOUT_SERIALMASK          = $000000FF;  // Port operates as an RS232 Serial Connection
   cbDOUT_BAUD2400            = $00000001;  // Serial Port operates at 2400   (n-8-1)
   cbDOUT_BAUD9600            = $00000002;  // Serial Port operates at 9600   (n-8-1)
   cbDOUT_BAUD19200           = $00000004;  // Serial Port operates at 19200  (n-8-1)
   cbDOUT_BAUD38400           = $00000008;  // Serial Port operates at 38400  (n-8-1)
   cbDOUT_BAUD57600           = $00000010;  // Serial Port operates at 57600  (n-8-1)
   cbDOUT_BAUD115200          = $00000020;  // Serial Port operates at 115200 (n-8-1)
   cbDOUT_1BIT                = $00000100;  // Port has a single output bit (eg single BNC output)
   cbDOUT_8BIT                = $00000200;  // Port has 8 output bits
   cbDOUT_16BIT               = $00000400;  // Port has 16 output bits
   cbDOUT_32BIT               = $00000800;  // Port has 32 output bits
   cbDOUT_VALUE               = $00010000;  // Port can be manually configured
   cbDOUT_TRACK               = $00020000;  // Port should track the most recently selected channel
   cbDOUT_MONITOR_UNIT0       = $01000000;  // Can monitor unit 0 = UNCLASSIFIED
   cbDOUT_MONITOR_UNIT1       = $02000000;  // Can monitor unit 1
   cbDOUT_MONITOR_UNIT2       = $04000000;  // Can monitor unit 2
   cbDOUT_MONITOR_UNIT3       = $08000000;  // Can monitor unit 3
   cbDOUT_MONITOR_UNIT4       = $10000000;  // Can monitor unit 4
   cbDOUT_MONITOR_UNIT5       = $20000000;  // Can monitor unit 5
   cbDOUT_MONITOR_UNIT_ALL    = $3F000000;  // Can monitor ALL units
   cbDOUT_MONITOR_SHIFT_TO_FIRST_UNIT=  24;  // This tells us how many bit places to get to unit 1

var
  cbGetDoutCaps: function(  chan: UINT32;  doutcaps: PUINT32 ): cbRESULT;cdecl;
// Retreives the channel's digital output capabilities from the Central Control App Cache.
// Port Capabilities are reported as compbined cbDOUTOPT_* flags.  Zero = no DINP capabilities.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetDoutOptions: function( chan: UINT32;  options: PUINT32;  monchan: PUINT32; doutval: PUINT32): cbRESULT;cdecl;
  cbSetDoutOptions: function( chan: UINT32;  options: UINT32;  monchan: UINT32;  doutval: UINT32): cbRESULT;cdecl;
// Get/Set the Digital Output Port options for the specified channel.
//
// The only changable DOUT options in this version of the interface libraries are baud rates for
// serial output ports.  These are set with the cbDOUTOPT_BAUDxx options.
//
// The Get function returns values from the Central Control App cache.  The Set function validates
// that the specified options are available and then queues a cbPKT_SETDOUTOPT packet.  The system
// acknowledges this change with a cbPKT_REPDOUTOPT packet.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOINTERNALCHAN if there is no internal channel for mapping the in->out chan
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Analog Input Inquiry and Configuration Functions
//
// The analog input processing in this library assumes the following signal flow structure:
//
//   Input with  --+-- Adaptive LNC filter -- Adaptive Filter --+-- Sampling Stream Filter -- Sample Group
//    physical     |                                            |
//     filter      +-- Raw Preview                              |
//                                                              +-- Adaptive Filter -- Spike Stream Filter --+-- Spike Processing
//                                                              |                         |
//                                                              |                         +-- Spike Preview
//                                                              +-- LNC Preview
//
// Adaptive Filter (above) is one or the other depending on settings, never both!
//
// This system forks the signal into 2 separate streams: a continuous stream and a spike stream.
// All simpler systems are derived from this structure and unincluded elements are bypassed or
// ommitted, for example the structure of the NSAS neural channels would be:
//
//   Input with --------+-- Spike Processing       ( NOTE: the physical filter is tuned )
//    physical          |                          (   for spikes and spike processing  )
//     filter           +-- Spike Preview
//
///////////////////////////////////////////////////////////////////////////////////////////////////


// In this system, analog values are represented by 16-bit signed integers.  The cbSCALING
// structure gives the mapping between the signal's analog space and the converted digital values.
//
//                (anamax) ---
//                          |
//                          |
//                          |                      \      --- (digmax)
//                        analog   === Analog to ===\      |
//                        range    ===  Digital  ===/   digital
//                          |                      /     range
//                          |                              |
//                          |                             --- (digmin)
//                (anamin) ---
//
// The analog range extent values are reported in 32-bit integers, along with a unit description.
// Units should be given with traditional metric scales such as P, M, K, m, u(for micro), n, p,
// etc and they are limited to 8 ASCII characters for description.
//
// The anamin and anamax represent the min and max values of the analog signal.  The digmin and
// digmax values are their cooresponding converted digital values.  If the signal is inverted in
// the scaling conversion, the digmin value will be greater than the digmax value.
//
// For example if a +/-5V signal is mapped into a +/-1024 digital value, the preferred unit
// would be "mV", anamin/max = +/- 5000, and digmin/max= +/-1024.

type
  cbSCALING = record
    digmin: INT16;     // digital value that cooresponds with the anamin value
    digmax: INT16;     // digital value that cooresponds with the anamax value
    anamin: INT32;     // the minimum analog value present in the signal
    anamax: INT32;     // the maximum analog value present in the signal
    anagain: INT32;    // the gain applied to the default analog values to get the analog values
    anaunit: array[0..cbLEN_STR_UNIT-1] of char; // the unit for the analog signal (eg, "uV" or "MPa")
  end;
  PcbSCALING= ^cbSCALING;

Const
   cbAINP_RAWPREVIEW  = $00000001;      // Generate scrolling preview data for the raw channel
   cbAINP_LNC         = $00000002;      // Line Noise Cancellation
   cbAINP_LNCPREVIEW  = $00000004;      // Retrieve the LNC correction waveform
   cbAINP_SMPSTREAM   = $00000010;      // stream the analog input stream directly to disk
   cbAINP_SMPFILTER   = $00000020;      // Digitally filter the analog input stream
   cbAINP_SPKSTREAM   = $00000100;      // Spike Stream is available
   cbAINP_SPKFILTER   = $00000200;      // Selectable Filters
   cbAINP_SPKPREVIEW  = $00000400;      // Generate scrolling preview of the spike channel
   cbAINP_SPKPROC     = $00000800;      // Channel is able to do online spike processing

var
  cbGetAinpCaps: function(  chan: UINT32;  ainpcaps: PUINT32; physcalin: PcbSCALING; phyfiltin: PcbFILTDESC ): cbRESULT;cdecl;
// Retreives the channel's analog input capabilities from the Central Control App Cache.
// Capabilities are reported as combined cbAINP_* flags.  Zero = no AINP capabilities.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetAinpScaling: function( chan: UINT32;  scaling: PcbSCALING): cbRESULT;cdecl;
  cbSetAinpScaling: function( chan: UINT32;  scaling: PcbSCALING): cbRESULT;cdecl;
// Get/Set the user-specified scaling for the channel.  The digmin and digmax values of the user
// specified scaling must be within the digmin and digmax values for the physical channel mapping.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.

  cbGetAinpDisplay: function(  chan: UINT32; smpdispmin: PINT32;  smpdispmax: PINT32; spkdispmax: PINT32 ): cbRESULT;cdecl;
  cbSetAinpDisplay: function(  chan: UINT32;   smpdispmin: INT32;   smpdispmax: INT32;   spkdispmax: INT32 ): cbRESULT;cdecl;
// Get and Set the display ranges used by User applications.  smpdispmin/max set the digital value
// range that should be displayed for the sampled analog stream.  Spike streams are assumed to be
// symmetric about zero so that spikes should be plotted from -spkdispmax to +spkdispmax.  Passing
// zero as a scale instructs the Central app to send the cached value.  Fields with NULL pointers
// are ignored by the library.
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.

Const
  cbAINPLNC_OFF  =  0;       // Line Noise Cancellation disabled
  cbAINPLNC_RUN   = $01;    // LNC running and adapting according to the adaptation const
  cbAINPLNC_HOLD  = $02;    // LNC running, but not adapting

var
  cbGetAinpLnc: function( chan: UINT32;  LNCmode: PUINT32; LNCrate: PUINT32): cbRESULT;cdecl;
  cbSetAinpLnc: function( chan: UINT32;  LNCmode: UINT32;   LNCrate: UINT32): cbRESULT;cdecl;
// Get/Set the Line Noise Cancellation configuration for one or more analog input channel.
// The configuration is composed of an adaptation rate and a mode variable.  The rate sets the
// first order decay of the filter according to:
//
//    newLNCvalue = (LNCrate/65536)*(oldLNCvalue) + ((65536-LNCrate)/65536)*LNCsample
//
// The relationships between the adaptation time constant in sec, line frequency in Hz and the
// the LNCrate variable are given below:
//
//         time_constant = 1 / ln[ (LNCrate/65536)^(-line_freq) ]
//
//         LNCrate = 65536 * e^[-1/(time_constant*line_freq)]
//
// The LNCmode sets whether the channel LNC block is disabled, running, or on hold.
//
// To set multiple channels on hold or run, pass channel=0.  In this case, the LNCrate is ignored
// and the run or hold value passed to the LNCmode variable is applied to all LNC enabled channels.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.

// <<NOTE: these constants are based on the preview request packet identifier>>
Const
  cbAINPPREV_LNC    = $81;
  cbAINPPREV_STREAM = $82;
  cbAINPPREV_ALL    = $83;

var
  cbSetAinpPreview: function( chan: UINT32;  prevopts: UINT32): cbRESULT;cdecl;
// Requests preview packets for a specific channel.
// Setting the AINPPREV_LNC option gets a single LNC update waveform.
// Setting the AINPPREV_STREAMS enables compressed preview information.
//
// A channel ID of zero requests the specified preview packets from all active ainp channels.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


//////////////////////////////////////////////////////////////
// AINP Continuous Stream Functions


  cbGetAinpSampling: function( chan: UINT32;  filter: PUINT32; group: PUINT32): cbRESULT;cdecl;
  cbSetAinpSampling: function( chan: UINT32;  filter: UINT32;   group: UINT32): cbRESULT;cdecl;
// Get/Set the periodic sample group for the channel.  Continuous sampling is performed in
// groups with each Neural Signal Processor.  There are up to 4 groups for each processor.
// A group number of zero signifies that the channel is not part of a continuous sample group.
// filter = 1 to cbNFILTS, 0 is reserved for the null filter case
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if the group number is not valid.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


//////////////////////////////////////////////////////////////
// AINP Spike Stream Functions

Const
   cbAINPSPK_EXTRACT   = $00000001;  // Time-stamp and packet to first superthreshold peak
   cbAINPSPK_REJART    = $00000002;  // Reject around clipped signals on multiple channels
   cbAINPSPK_REJCLIP   = $00000004;  // Reject clipped signals on the channel
   cbAINPSPK_ALIGNPK   = $00000008;  //
   cbAINPSPK_THRLEVEL  = $00000100;  // Analog level threshold detection
   cbAINPSPK_THRENERGY = $00000200;  // Energy threshold detection
   cbAINPSPK_HOOPSORT  = $00010000;  // Enbable Hoop Sorting

var
  cbGetAinpSpikeCaps: function( chan: UINT32; flags: PUINT32): cbRESULT;cdecl;
  cbGetAinpSpikeOptions: function(chan: UINT32; flags: PUINT32; filter: PUINT32): cbRESULT;cdecl;
  cbSetAinpSpikeOptions: function( chan: UINT32;  flags: UINT32;   filter: UINT32): cbRESULT;cdecl;
// Get/Set spike capabilities and options.  The EXTRACT flag must be set for a channel to perform
// spike extraction and processing.  The HOOPS and TEMPLATE flags are exclusive, only one can be
// used at a time.
// filter = 1 to cbNFILTS, 0 is reserved for the null filter case
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if invalid flag combinations are passed.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.
//


  cbGetAinpSpikeThreshold: function( chan: UINT32; level: PINT32): cbRESULT;cdecl;
  cbSetAinpSpikeThreshold: function( chan: UINT32; level: INT32): cbRESULT;cdecl;
// Get/Set the spike detection threshold and threshold detection mode.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if invalid flag combinations are passed.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


type
  cbHOOP = record
    valid: UINT16; // 0=undefined, 1 for valid
    time: INT16;  // time offset into spike window
    min: INT16;   // minimum value for the hoop window
    max: INT16;   // maximum value for the hoop window
  end;
  PcbHOOP=^cbHOOP;

var
  cbGetAinpSpikeHoops: function( chan: UINT32; hoops: PcbHOOP): cbRESULT;cdecl;
  cbSetAinpSpikeHoops: function( chan: UINT32; hoops: PcbHOOP): cbRESULT;cdecl;
// Get/Set the spike hoop set.  The hoops parameter points to an array of hoops declared as
// cbHOOP hoops[cbMAXUNITS][cbMAXHOOPS].
//
// Empty hoop definitions have zeros for the cbHOOP structure members.  Hoop definitions can be
// cleared by passing a NULL cbHOOP pointer to the Set function or by calling the Set function
// with an all-zero cbHOOP structure.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if an invalid unit or hoop number is passed.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Analog Output Inquiry and Configuration Functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
   cbAOUT_AUDIO        = $00000001;  // Channel is physically optimized for audio output
   cbAOUT_SCALE        = $00000002;  // Output a static value
   cbAOUT_TRACK        = $00000004;  // Output a static value
   cbAOUT_STATIC       = $00000008;  // Output a static value
   cbAOUT_MONITORRAW   = $00000010;  // Monitor an analog signal line
   cbAOUT_MONITORLNC   = $00000020;  // Monitor an analog signal line
   cbAOUT_MONITORSMP   = $00000040;  // Monitor an analog signal line
   cbAOUT_MONITORSPK   = $00000080;  // Monitor an analog signal line
   cbAOUT_STIMULATE    = $00000100;  // Stimulation waveform functions are available.

var
  cbGetAoutCaps: function(  chan: UINT32; aoutcaps: PUINT32; physcalout: PcbSCALING; phyfiltout: PcbFILTDESC ): cbRESULT;cdecl;
// Get/Set the spike template capabilities and options.  The nunits and nhoops values detail the
// number of units that the channel supports.
//
// Empty template definitions have zeros for the cbSPIKETEMPLATE structure members.  Spike
// Template definitions can be cleared by passing a NULL cbSPIKETEMPLATE pointer to the Set
// function or by calling the Set function with an all-zero cbSPIKETEMPLATE structure.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if an invalid unit number is passed.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetAoutScaling: function( chan: UINT32; scaling: PcbSCALING): cbRESULT;cdecl;
  cbSetAoutScaling: function( chan: UINT32; scaling: PcbSCALING): cbRESULT;cdecl;
// Get/Set the user-specified scaling for the channel.  The digmin and digmax values of the user
// specified scaling must be within the digmin and digmax values for the physical channel mapping.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


  cbGetAoutOptions: function( chan: UINT32; options: PUINT32; monchan: PUINT32;  value: PUINT32): cbRESULT;cdecl;
  cbSetAoutOptions: function( chan: UINT32;  options: UINT32;  monchan: UINT32;  value: UINT32): cbRESULT;cdecl;
// Get/Set the Monitored channel for a Analog Output Port.  Setting zero for the monitored channel
// stops the monitoring and frees any instrument monitor resources.  The factor ranges
//
// Returns: cbRESULT_OK if data successfully retreived or packet successfully queued to be sent.
//          cbRESULT_NOINTERNALCHAN if there is no internal channel for mapping the in->out chan
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.


// Request that the sorting model be updated
  cbGetSortingModel: function: cbRESULT;cdecl;

type
  TsingleArray2=array[0..1] of single;
  PsingleArray2 = ^TsingleArray2;

  TsingleArray22=array[0..1,0..1] of single;
  PsingleArray22 = ^TsingleArray22;

// Getting and setting the noise boundary
var
  cbSSGetNoiseBoundary: function( chanIdx: integer; afc:PsingleArray2; afS:PsingleArray22; theta: Psingle): cbRESULT;cdecl;
  cbSSSetNoiseBoundary: function( chanIdx: integer; afc:PsingleArray2; afS:PsingleArray22; theta: single): cbRESULT;cdecl;

// Getting and settings statistics
  cbSSGetStatistics: function( pnUpdateSpikes: PUINT32; pnAutoalg: PUINT32;
                               pfMinClusterPairSpreadFactor: Psingle;
                               pfMaxSubclusterSpreadFactor: Psingle;
                               pfMinClusterHistCorrMajMeasure: Psingle;
                               pfMaxClusterPairHistCorrMajMeasure: Psingle;
                               pfClusterHistValleyPercentage: Psingle;
                               pfClusterHistClosePeakPercentage: Psingle;
                               pfClusterHistMinPeakPercentage: Psingle): cbRESULT;cdecl;

  cbSSSetStatistics: function( nUpdateSpikes: UINT32;  nAutoalg: UINT32;
                            fMinClusterPairSpreadFactor: single;
                            fMaxSubclusterSpreadFactor: single;
                            fMinClusterHistCorrMajMeasure: single;
                            fMaxClusterPairHistCorrMajMeasure: single;
                            fClusterHistValleyPercentage: single;
                            fClusterHistClosePeakPercentage: single;
                            fClusterHistMinPeakPercentage: single): cbRESULT;cdecl;


// Spike sorting artifact rejecting
  cbSSGetArtifactReject: function( pnMaxChans: PUINT32;  pnRefractorySamples: PUINT32): cbRESULT;cdecl;
  cbSSSetArtifactReject: function( nMaxChans: UINT32;  nRefractorySamples: UINT32): cbRESULT;cdecl;

// Spike detection parameters
  cbSSGetDetect: function( pfThreshold: Psingle; pfScaling: Psingle): cbRESULT;cdecl;
  cbSSSetDetect: function( fThreshold: single;  fScaling: single): cbRESULT;cdecl;

// To control and keep track of how long an element of spike sorting has been adapting.
//
type
  ADAPT_TYPE= ( ADAPT_NEVER, ADAPT_ALWAYS, ADAPT_TIMED );

type
  cbAdaptControl= record
    nMode: UINT32;           // 0-do not adapt at all, 1-always adapt, 2-adapt if timer not timed out
    fTimeOutMinutes: single;  // how many minutes until time out
    fElapsedMinutes: single;  // the amount of time that has elapsed
  end;
  PcbAdaptControl = ^cbAdaptControl;

// Getting and setting spike sorting status parameters
var
  cbSSGetStatus: function( pcntlUnitStats: PcbAdaptControl;  pcntlNumUnits: PcbAdaptControl): cbRESULT;cdecl;
  cbSSSetStatus: function( cntlUnitStats: cbAdaptControl;  cntlNumUnits: cbAdaptControl): cbRESULT;cdecl;



///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Data checking and processing functions
//
// To get data from the shared memory buffers used in the Central App, the user can:
// 1) periodically poll for new data using a multimedia or windows timer
// 2) create a thread that uses a Win32 Event synchronization object to que the data polling
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type
  cbLevelOfConcern=
    (
    LOC_LOW,                // Time for sippen lemonaide
    LOC_MEDIUM,             // Step up to the plate
    LOC_HIGH,               // Put yer glass down
    LOC_CRITICAL,           // Get yer but in gear
    LOC_COUNT               // How many level of concerns are there
    );
  PcbLevelOfConcern = ^cbLevelOfConcern;

var
  cbCheckforData: function( nLevelOfConcern: PcbLevelOfConcern;  pktstogo: PUINT32 =nil): cbRESULT;cdecl;
// The pktstogo and timetogo are optional fields (NULL if not used) that returns the number of new
// packets and timestamps that need to be read to catch up to the buffer.
//
// Returns: cbRESULT_OK    if there is new data in the buffer
//          cbRESULT_NONEWDATA if there is no new data available
//          cbRESULT_DATALOST if the Central App incoming data buffer has wrapped the read buffer


  cbWaitforData: function: cbRESULT;cdecl;
// Executes a WaitForSingleObject command to wait for the Central App event signal
//
// Returns: cbRESULT_OK    if there is new data in the buffer
//          cbRESULT_NONEWDATA if the function timed out after 250ms
//          cbRESULT_DATALOST if the Central App incoming data buffer has wrapped the read buffer



//Pseudo Generic
type
  TGENERIC = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // channel identifier
    type1: UINT8;        // packet type
    dlen: UINT8;        // length of data field in 32-bit chunks
    bb: array[0..1015] of byte;   // data buffer (up to 1016 bytes)
  end;
  PGENERIC = ^TGENERIC;

// Generic Cerebus packet data structure
type
  cbPKT_GENERIC = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // channel identifier
    type1: UINT8;        // packet type
    dlen: UINT8;        // length of data field in 32-bit chunks
    data: array[0..253] of UINT32;   // data buffer (up to 1016 bytes)
  end;
  PcbPKT_GENERIC = ^cbPKT_GENERIC;

var
  cbGetNextPacketPtr: function: PcbPKT_GENERIC;cdecl;
// Returns pointer to next packet in the shared memory space.  If no packet available, returns NULL


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Data Packet Structures (chid<$8000)
//
///////////////////////////////////////////////////////////////////////////////////////////////////
Const
  cbPKT_HEADER_SIZE=  8;  // define the size of the packet header in bytes

// Sample Group data packet
type
  cbPKT_GROUP = record
    time: UINT32;       // system clock timestamp
    chid: UINT16;       // $0000
    type1: UINT8;       // sample group ID (1-127)
    dlen: UINT8;       // packet length equal
    data: array[0..251] of INT16;  // variable length address list
  end;
  PcbPKT_GROUP = ^cbPKT_GROUP;

// DINP digital value data
type
  cbPKT_DINP = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // channel identifier
    unit1: UINT8;        // reserved
    dlen: UINT8;        // length of waveform in 32-bit chunks
    data: array[0..253] of UINT32;   // data buffer (up to 1016 bytes)
  end;
  PcbPKT_DINP = ^cbPKT_DINP;

Const
// AINP spike waveform data
// cbMAX_PNTS must be an even number
  cbMAX_PNTS =  128; // make large enough to track longest possible - spike width in samples


type
  cbPKT_SPK = record
    time: UINT32;                // system clock timestamp
    chid: UINT16;                // channel identifier
    unit1: UINT8;                // unit identification (0=unclassified, 31=artifact, 30=background)
    dlen: UINT8;                // length of what follows ... always  cbPKTDLEN_SPK
    fPattern: array[0..1] of single;          // values of the pattern space: 0 = higher frequency, 1 = lower frequency
    nPeak: INT16;
    nValley: INT16;
    // wave must be the last item in the structure because it can be variable length to a max of cbMAX_PNTS
    wave: array[0..cbMAX_PNTS-1] of INT16;    // Room for all possible points collected
  end;
  PcbPKT_SPK = ^cbPKT_SPK;

  TElphySpkPacket = record
                      ElphyTime:UINT32;            // champ supplémentaire
                      time: UINT32;                // id
                      chid: UINT16;                // id
                      unit1: UINT8;                // id
                      dlen: UINT8;                 //  devient le nombre de points dans la waveform
                      fPattern: array[0..1] of single;          // id
                      nPeak: INT16;                             // id
                      nValley: INT16;                           // id
                      wave: array[0..cbMAX_PNTS-1] of INT16;    // dlen points
                    end;
  PElphySpkPacket=^TElphySpkPacket;
const
  ElphySpkPacketFixedSize=sizeof(TElphySpkPacket)-128*2;


const
  cbPKTDLEN_SPK =   ((sizeof(cbPKT_SPK) div 4)-2);
  cbPKTDLEN_SPKSHORT = (cbPKTDLEN_SPK - ((sizeof(INT16)*cbMAX_PNTS) div 4));


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Configuration/Report Packet Definitions (chid = $8000)
//
///////////////////////////////////////////////////////////////////////////////////////////////////

  cbPKTCHAN_CONFIGURATION         = $8000;          // Channel # to mean configuration


var
// Cerebus Library function to send packets via the Central Application Queue
  cbSendPacket: function(pPacket: pointer): cbRESULT;cdecl;
  cbSendLoopbackPacket: function( pPacket: pointer): cbRESULT;cdecl;


// System Heartbeat Packet (sent every 10ms)
type
  cbPKT_SYSHEARTBEAT = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000
    type1: UINT8;        // 0
    dlen: UINT8;        // cbPKTDLEN_SYSHEARTBEAT
  end;

Const
  cbPKTTYPE_SYSHEARTBEAT    = $00;
  cbPKTDLEN_SYSHEARTBEAT    =((sizeof(cbPKT_SYSHEARTBEAT) div 4)-2);



// Protocol Monitoring packet (sent periodically about every second)
type
  cbPKT_SYSPROTOCOLMONITOR = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000
    type1: UINT8;        // 1
    dlen: UINT8;        // cbPKTDLEN_SYSPROTOCOLMONITOR
    sentpkts: UINT32;    // Packets sent since last cbPKT_SYSPROTOCOLMONITOR (or 0 if timestamp=0);
                        //  the cbPKT_SYSPROTOCOLMONITOR packets are counted as well so this must
                        //  be equal to at least 1
  end;

Const
  cbPKTTYPE_SYSPROTOCOLMONITOR    = $01;
  cbPKTDLEN_SYSPROTOCOLMONITOR    =((sizeof(cbPKT_SYSPROTOCOLMONITOR) div 4)-2);


  cbPKTTYPE_REQCONFIGALL  = $88;            // request for ALL configuration information
  cbPKTTYPE_REPCONFIGALL  = $08;            // response that NSP got your request



type
  cbPKT_SYSINFO = record
     time: UINT32;        // system clock timestamp
     chid: UINT16;        // $8000
     type1: UINT8;        // PKTTYPE_SYS*
     dlen: UINT8;        // cbPKT_SYSINFODLEN
     sysfreq: UINT32;     // System clock frequency in Hz
     spikelen: UINT32;    // The length of the spike events
     spikepre: UINT32;    // Spike pre-trigger samples
     resetque: UINT32;    // The channel for the reset to que on
     runlevel: UINT32;    // System runlevel
     runflags: UINT32;
  end;

Const
// System Condition Report Packet
  cbPKTTYPE_SYSREP        = $10;
  cbPKTTYPE_SYSREPSPKLEN  = $11;
  cbPKTTYPE_SYSREPRUNLEV  = $12;
  cbPKTTYPE_SYSSET        = $90;
  cbPKTTYPE_SYSSETSPKLEN  = $91;
  cbPKTTYPE_SYSSETRUNLEV  = $92;
  cbPKTDLEN_SYSINFO       = ((sizeof(cbPKT_SYSINFO) div 4)-2);


// Report Processor Information (duplicates the cbPROCINFO structure)

type
  cbPKT_PROCINFO = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000
    type1: UINT8;        // cbPKTTYPE_PROC*
    dlen: UINT8;        // cbPKT_PROCINFODLEN
    proc: UINT32;        // index of the bank
    idcode: UINT32;      // manufacturer part and rom ID code of the Signal Processor
    ident: array[0..cbLEN_STR_IDENT-1] of char;   // ID string with the equipment name of the Signal Processor
    chanbase: UINT32;    // lowest channel number of channel id range claimed by this processor
    chancount: UINT32;   // number of channel identifiers claimed by this processor
    bankcount: UINT32;   // number of signal banks supported by the processor
    groupcount: UINT32;  // number of sample groups supported by the processor
    filtcount: UINT32;   // number of digital filters supported by the processor
    sortcount: UINT32;   // number of channels supported for spike sorting (reserved for future)
    unitcount: UINT32;   // number of supported units for spike sorting    (reserved for future)
    hoopcount: UINT32;   // number of supported units for spike sorting    (reserved for future)
    sortmethod: UINT32;  // sort method  (0=manual, 1=automatic spike sorting)
    version: UINT32;     // current version of libraries
  end;

Const
  cbPKTTYPE_PROCREP   = $21;
  cbPKTDLEN_PROCINFO  =((sizeof(cbPKT_PROCINFO) div 4)-2);



// Report Bank Information (duplicates the cbBANKINFO structure)

type
  cbPKT_BANKINFO = record
    time: UINT32;         // system clock timestamp
    chid: UINT16;         // $8000
    type1: UINT8;          // cbPKTTYPE_BANK*
    dlen: UINT8;          // cbPKT_BANKINFODLEN
    proc: UINT32;         // the address of the processor on which the bank resides
    bank: UINT32;         // the address of the bank reported by the packet
    idcode: UINT32;       // manufacturer part and rom ID code of the module addressed to this bank
    ident: array[0..cbLEN_STR_IDENT-1] of char;   // ID string with the equipment name of the Signal Bank hardware module
    label1: array[0..cbLEN_STR_LABEL-1] of char;   // Label on the instrument for the signal bank, eg "Analog In"
    chanbase: UINT32;     // lowest channel number of channel id range claimed by this bank
    chancount: UINT32;    // number of channel identifiers claimed by this bank
  end;

Const
  cbPKTTYPE_BANKREP   = $22;
  cbPKTDLEN_BANKINFO  =((sizeof(cbPKT_BANKINFO) div 4)-2);


// Filter (FILT) Information Packets

type
  cbPKT_FILTINFO = record
    time: UINT32;       // system clock timestamp
    chid: UINT16;       // $8000
    type1: UINT8;       // cbPKTTYPE_GROUP*
    dlen: UINT8;       // packet length equal to length of list + 6 quadlets
    proc: UINT32;       //
    filt: UINT32;       //
    label1: array[0..cbLEN_STR_LABEL-1] of char;  //
    hpfreq: UINT32;     // high-pass corner frequency in milliHertz
    hporder: UINT32;    // high-pass filter order
    hptype: UINT32;     // high-pass filter type
    lpfreq: UINT32;     // low-pass frequency in milliHertz
    lporder: UINT32;    // low-pass filter order
    lptype: UINT32;     // low-pass filter type
  end;

Const
  cbPKTTYPE_FILTREP  = $23;
  cbPKTDLEN_FILTINFO = ((sizeof(cbPKT_FILTINFO) div 4)-2);


// Factory Default settings request packet

type
  cbPKT_CHANRESET = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_AINP*
    dlen: UINT8;           // cbPKT_DLENCHANINFO
    chan: UINT32;           // actual channel id of the channel being configured

    // For all of the values that follow
    // 0 = NOT change value; nonzero = reset to factory defaults

    label1: UINT8;          // Channel label
    userflags: UINT8;      // User flags for the channel state
    position: UINT8;       // reserved for future position information
    scalin: UINT8;         // user-defined scaling information
    scalout: UINT8;        // user-defined scaling information
    doutopts: UINT8;       // digital output options (composed of cbDOUT_* flags)
    dinpopts: UINT8;       // digital input options (composed of cbDINP_* flags)
    aoutopts: UINT8;       // analog output options
    eopchar: UINT8;        // the end of packet character
    monsource: UINT8;      // address of channel to monitor
    outvalue: UINT8;       // output value
    lncmode: UINT8;        // line noise cancellation filter mode
    lncrate: UINT8;        // line noise cancellation filter adaptation rate
    smpfilter: UINT8;      // continuous-time pathway filter id
    smpgroup: UINT8;       // continuous-time pathway sample group
    smpdispmin: UINT8;     // continuous-time pathway display factor
    smpdispmax: UINT8;     // continuous-time pathway display factor
    spkfilter: UINT8;      // spike pathway filter id
    spkdispmax: UINT8;     // spike pathway display factor
    spkopts: UINT8;        // spike processing options
    spkthrlevel: UINT8;    // spike threshold level
    spkthrlimit: UINT8;    //
    spkgroup: UINT8;       // NTrodeGroup this electrode belongs to - 0 is single unit, non-0 indicates a multi-trode grouping
    spkhoops: UINT8;       // spike hoop sorting set
  end;

Const
  cbPKTTYPE_CHANRESETREP  = $24;        (* NSP->PC response...ignore all values *)
  cbPKTTYPE_CHANRESET     = $A4;        (* PC->NSP request *)
  cbPKTDLEN_CHANRESET = ((sizeof(cbPKT_CHANRESET) div 4) - 2);



// These are the adaptive filter settings

type
  cbPKT_ADAPTFILTINFO = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_ADAPTFILTSET or cbPKTTYPE_ADAPTFILTREP
    dlen: UINT8;           // cbPKTDLEN_ADAPTFILTINFO
    chan: UINT32;           // Ignored

    nMode: UINT32;          // 0=disabled, 1=filter continuous & spikes, 2=filter spikes
    dLearningRate: single;  // speed at which adaptation happens. Very small. e.g. 5e-12
    nRefChan1: UINT32;      // The first reference channel (1 based).
    nRefChan2: UINT32;      // The second reference channel (1 based).
  end;     // The packet....look below vvvvvvvv

Const
  cbPKTTYPE_ADAPTFILTREP  = $25;        (* NSP->PC response...*)
  cbPKTTYPE_ADAPTFILTSET  = $A5;        (* PC->NSP request *)
  cbPKTDLEN_ADAPTFILTINFO = ((sizeof(cbPKT_ADAPTFILTINFO) div 4) - 2);
  ADAPT_FILT_DISABLED	       = 0;
  ADAPT_FILT_ALL	       = 1;
  ADAPT_FILT_SPIKES	       = 2;



// These are the reference electrode filter settings

type
  cbPKT_REFELECFILTINFO = record     // The packet
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;            // cbPKTTYPE_REFELECFILTSET or cbPKTTYPE_REFELECFILTREP
    dlen: UINT8;            // cbPKTDLEN_REFELECFILTINFO
    chan: UINT32;           // Ignored

    nMode: UINT32;          // 0=disabled, 1=filter continuous & spikes, 2=filter spikes
    nRefChan: UINT32;       // The reference channel (1 based).
  end;

Const
  cbPKTTYPE_REFELECFILTREP  = $26;        (* NSP->PC response... *)
  cbPKTTYPE_REFELECFILTSET  = $A6;        (* PC->NSP request *)
  cbPKTDLEN_REFELECFILTINFO = ((sizeof(cbPKT_REFELECFILTINFO) div 4) - 2);
  REFELEC_FILT_DISABLED= 	0;
  REFELEC_FILT_ALL	       = 	1;
  REFELEC_FILT_SPIKES	       = 	2;

var
  cbGetNTrodeInfo: function(  ntrode: UINT32; label1: Pchar): cbRESULT;cdecl;
  cbSetNTrodeInfo: function(   ntrode: UINT32; label1: Pchar): cbRESULT;cdecl;

// NTrode Information Packets

type
  cbPKT_NTRODEINFO = record  // ntrode information packet
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_NTRODEGRPREP or cbPKTTYPE_NTRODEGRPSET
    dlen: UINT8;           // cbPKTDLEN_NTRODEGRPINFO
    ntrode: UINT32;         // ntrode with which we are working
    label1: array[0..cbLEN_STR_LABEL-1] of char;   // Label of the Ntrode (null terminated if < 16 characters)
  end;

Const
  cbPKTTYPE_REPNTRODEINFO      = $27;        (* NSP->PC response... *)
  cbPKTTYPE_SETNTRODEINFO      = $A7;        (* PC->NSP request *)
  cbPKTDLEN_NTRODEINFO = ((sizeof(cbPKT_NTRODEINFO) div 4) - 2);

// Sample Group (GROUP) Information Packets
Const
  cbPKTTYPE_GROUPREP      = $30;    // (lower 7bits=ppppggg)
  cbPKTTYPE_GROUPSET      = $B0;
  cbPKTDLEN_GROUPINFOEMP =  8;       // basic length without list

type
  cbPKT_GROUPINFO = record
    time: UINT32;       // system clock timestamp
    chid: UINT16;       // $8000
    type1: UINT8;       // cbPKTTYPE_GROUP*
    dlen: UINT8;       // packet length equal to length of list + 6 quadlets
    proc: UINT32;       //
    group: UINT32;      //
    label1: array[0..cbLEN_STR_LABEL-1] of char;  // sampling group label
    period: UINT32;     // sampling period for the group
    length: UINT32;     //
    list: array[0..cbNUM_ANALOG_CHANS-1] of UINT32;   // variable length list. The max size is
                                        // the total number of analog channels
  end;


// Analog Input (AINP) Information Packets

type
  cbPKT_CHANINFO = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000
    type1: UINT8;        // cbPKTTYPE_AINP*
    dlen: UINT8;        // cbPKT_DLENCHANINFO
    chan: UINT32;	    // actual channel id of the channel being configured
    proc: UINT32;        // the address of the processor on which the channel resides
    bank: UINT32;        // the address of the bank on which the channel resides
    term: UINT32;        // the terminal number of the channel within it's bank
    chancaps: UINT32;    // general channel capablities (given by cbCHAN_* flags)
    doutcaps: UINT32;    // digital output capablities (composed of cbDOUT_* flags)
    dinpcaps: UINT32;    // digital input capablities (composed of cbDINP_* flags)
    aoutcaps: UINT32;    // analog input capablities (composed of cbAOUT_* flags)
    ainpcaps: UINT32;    // analog input capablities (composed of cbAINP_* flags)
    spkcaps: UINT32;     // spike processing capabilities
    physcalin: cbSCALING;   // physical channel scaling information
    phyfiltin: cbFILTDESC;   // physical channel filter definition
    physcalout: cbSCALING;  // physical channel scaling information
    phyfiltout: cbFILTDESC;  // physical channel filter definition
    label1: array[0..cbLEN_STR_LABEL-1] of char;   // Label of the channel (null terminated if <16 characters)
    userflags: UINT32;   // User flags for the channel state
    position: array[0..3] of INT32; // reserved for future position information
    scalin: cbSCALING;      // user-defined scaling information
    scalout: cbSCALING;     // user-defined scaling information
    doutopts: UINT32;    // digital output options (composed of cbDOUT_* flags)
    dinpopts: UINT32;    // digital input options (composed of cbDINP_* flags)
    aoutopts: UINT32;    // analog output options
    eopchar: UINT32;     // digital input capablities (given by cbDINP_* flags)
    monsource: UINT32;   // address of channel to monitor
    outvalue: INT32;    // output value
    lncmode: UINT32;     // line noise cancellation filter mode
    lncrate: UINT32;     // line noise cancellation filter adaptation rate
    smpfilter: UINT32;   // continuous-time pathway filter id
    smpgroup: UINT32;    // continuous-time pathway sample group
    smpdispmin: INT32;  // continuous-time pathway display factor
    smpdispmax: INT32;  // continuous-time pathway display factor
    spkfilter: UINT32;   // spike pathway filter id
    spkdispmax: INT32;  // spike pathway display factor
    spkopts: UINT32;     // spike processing options
    spkthrlevel: INT32; // spike threshold level
    spkthrlimit: INT32; //
    spkgroup: UINT32;    // NTrodeGroup this electrode belongs to - 0 is single unit, non-0 indicates a multi-trode grouping
    unitmapping: array[0..cbMAXUNITS-1] of cbMANUALUNITMAPPING;            // manual unit mapping
    spkhoops: array[0..cbMAXUNITS-1,0..cbMAXHOOPS-1] of cbHOOP;   // spike hoop sorting set
    dumdum:UINT32;
  end;

Const
  cbPKTTYPE_CHANREP               = $40;
  cbPKTTYPE_CHANREPLABEL          = $41;
  cbPKTTYPE_CHANREPSCALE          = $42;
  cbPKTTYPE_CHANREPDOUT           = $43;
  cbPKTTYPE_CHANREPDINP           = $44;
  cbPKTTYPE_CHANREPAOUT           = $45;
  cbPKTTYPE_CHANREPDISP           = $46;
  cbPKTTYPE_CHANREPLNC            = $47;
  cbPKTTYPE_CHANREPSMP            = $48;
  cbPKTTYPE_CHANREPSPK            = $49;
  cbPKTTYPE_CHANREPSPKTHR         = $4A;
  cbPKTTYPE_CHANREPSPKHPS         = $4B;
  cbPKTTYPE_CHANREPUNITOVERRIDES  = $4C;
  cbPKTTYPE_CHANREPNTRODEGROUP    = $4D;
  cbPKTTYPE_CHANSET               = $C0;
  cbPKTTYPE_CHANSETLABEL          = $C1;
  cbPKTTYPE_CHANSETSCALE          = $C2;
  cbPKTTYPE_CHANSETDOUT           = $C3;
  cbPKTTYPE_CHANSETDINP           = $C4;
  cbPKTTYPE_CHANSETAOUT           = $C5;
  cbPKTTYPE_CHANSETDISP           = $C6;
  cbPKTTYPE_CHANSETLNC            = $C7;
  cbPKTTYPE_CHANSETSMP            = $C8;
  cbPKTTYPE_CHANSETSPK            = $C9;
  cbPKTTYPE_CHANSETSPKTHR         = $CA;
  cbPKTTYPE_CHANSETSPKHPS         = $CB;
  cbPKTTYPE_CHANSETUNITOVERRIDES  = $CC;
  cbPKTTYPE_CHANSETNTRODEGROUP    = $CD;
  cbPKTDLEN_CHANINFO  =    ((sizeof(cbPKT_CHANINFO) div 4)-2);
  cbPKTDLEN_CHANINFOSHORT =(cbPKTDLEN_CHANINFO - ((sizeof(cbHOOP)*cbMAXUNITS*cbMAXHOOPS) div 4));


// TODO: separate out these definitions so that there are no conditional compiles
// #if !defined (__GNUC__)

/////////////////////////////////////////////////////////////////////////////////
// These are part of the "reflected" mechanism. They go out as type 0xE? and come
// Back in as type 0x6?
Const
  cbPKTTYPE_MASKED_REFLECTED              = $E0;
  cbPKTTYPE_COMPARE_MASK_REFLECTED        = $F0;
  cbPKTTYPE_REFLECTED_CONVERSION_MASK     = $7F;


// file save configuration packet

type
  cbPKT_FILECFG = record
    time: UINT32;            // system clock timestamp
    chid: UINT16;            // $8000
    type1: UINT8;
    dlen: UINT8;
    filename: array[0..255] of  char;
    comment: array[0..255] of char;
    options: UINT32;
    duration: UINT32;
    recording: BOOL;
    extctrl: UINT32;
  end;

Const
  cbPKTTYPE_REPFILECFG = $61;
  cbPKTTYPE_SETFILECFG = $E1;
  cbPKTDLEN_FILECFG = ((sizeof(cbPKT_FILECFG) div 4)-2);


Const
    // These are the packet type constants
    TYPE_OUTGOING = $E2 ;          // Goes out like this
    TYPE_INCOMING = $62 ;          // Comes back in like this after "reflection"

    // These are the masks for use with   abyUnitSelections
    UNIT_UNCLASS_MASK = $01;       // mask to use to say unclassified units are selected
    UNIT_1_MASK       = $02;       // mask to use to say unit 1 is selected
    UNIT_2_MASK       = $04;       // mask to use to say unit 2 is selected
    UNIT_3_MASK       = $08;       // mask to use to say unit 3 is selected
    UNIT_4_MASK       = $10;       // mask to use to say unit 4 is selected
    UNIT_5_MASK       = $20;       // mask to use to say unit 5 is selected
    CONTINUOUS_MASK   = $40;       // mask to use to say the continuous signal is selected

    UNIT_ALL_MASK = UNIT_UNCLASS_MASK or
                    UNIT_1_MASK or   // This means the channel is completely selected
                    UNIT_2_MASK or
                    UNIT_3_MASK or
                    UNIT_4_MASK or
                    UNIT_5_MASK or
                    CONTINUOUS_MASK;


// Packet which says that these channels are now selected
type
  cbPKT_UNIT_SELECTION = object

    time: UINT32;            // system clock timestamp
    chid: UINT16;            // $8000
    type1: UINT8;            //
    dlen: UINT8;            // How many dwords follow......end of standard header
    lastchan: INT32;         // Which channel was clicked last.
    abyUnitSelections: array[0..cbMAXCHANS-1] of BYTE;     // one for each channel, channels are 0 based here

    // ctor...sending packet ensures time is set
    // Inputs:
    //  ulastchan = 0 based channel that was most recently selected
    // Notes:
    //  We don't have to worry about the "time" field as that will be set by cbSendPacket()
    //  as well as cbSendLoopbackPacket()
    procedure Init( iLastchan:INT16 );
    function UnitToUnitmask(nUnit:integer):integer;
  end;

  PcbPKT_UNIT_SELECTION = ^cbPKT_UNIT_SELECTION;


// future allocations spk templates = 0x5X, control data = 0x6X
//

///// Packets to tell me about the spike sorting model


// This packet says, "Give me all of the model". In response, you will get a series of cbPKTTYPE_MODELREP
//
type
  cbPKT_SS_MODELALLSET = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;            // cbPKTTYPE_MODELALLSET or cbPKTTYPE_MODELALLREP depending on the direction
    dlen: UINT8;            // 0
  end;

Const
  cbPKTTYPE_SS_MODELALLREP   = $50;        (* NSP->PC response *)
  cbPKTTYPE_SS_MODELALLSET   = $D0;        (* PC->NSP request  *)
  cbPKTDLEN_SS_MODELALLSET = ((sizeof(cbPKT_SS_MODELALLSET) div 4) - 2);




type
  cbPKT_SS_MODELSET = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_SS_MODELREP or cbPKTTYPE_SS_MODELSET depending on the direction
    dlen: UINT8;           // cbPKTDLEN_SS_MODELSET

    chan: UINT32;           // actual channel id of the channel being configured (0 based)
    unit_number: UINT32;    // unit label (0 based, 0 is noise cluster)
    valid: UINT32;          // 1 = valid unit, 0 = not a unit, in other words just deleted when NSP -> PC
    inverted: UINT32;       // 0 = not inverted, 1 = inverted

    // Block statistics (change from block to block)
    num_samples: INT32;    // non-zero value means that the block stats are valid
    mu_x: array[0..1] of single;
    Sigma_x: array[0..1,0..1] of  single;
    determinant_Sigma_x: single;
    ///// Only needed if we are using a Bayesian classification model
    Sigma_x_inv: array[0..1,0..1] of single;
    log_determinant_Sigma_x: single;
    /////
    subcluster_spread_factor_numerator: single;
    subcluster_spread_factor_denominator: single;
    mu_e: single;
    sigma_e_squared: single;
  end;

Const
  cbPKTTYPE_SS_MODELREP      = $51;        (* NSP->PC response *)
  cbPKTTYPE_SS_MODELSET      = $D1;        (* PC->NSP request  *)
  cbPKTDLEN_SS_MODELSET =((sizeof(cbPKT_SS_MODELSET) div 4) - 2);
  MAX_REPEL_POINTS = 3;



// This packet contains the options for the automatic spike sorting.

type
  cbPKT_SS_DETECT = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_SS_DETECTREP or cbPKTTYPE_SS_DETECTSET depending on the direction
    dlen: UINT8;           // cbPKTDLEN_SS_DETECT

    fThreshold: single;     // current detection threshold
    fMultiplier: single;    // multiplier
  end;

Const
  cbPKTTYPE_SS_DETECTREP  = $52;        (* NSP->PC response *)
  cbPKTTYPE_SS_DETECTSET  = $D2;        (* PC->NSP request  *)
  cbPKTDLEN_SS_DETECT = ((sizeof(cbPKT_SS_DETECT) div 4) - 2);


// Options for artifact rejecting

type
  cbPKT_SS_ARTIF_REJECT = record
    time: UINT32;               // system clock timestamp
    chid: UINT16;               // $8000
    type1: UINT8;               // cbPKTTYPE_SS_ARTIF_REJECTREP or cbPKTTYPE_SS_ARTIF_REJECTSET depending on the direction
    dlen: UINT8;               // cbPKTDLEN_SS_ARTIF_REJECT

    nMaxSimulChans: UINT32;     // how many channels can fire exactly at the same time???
    nRefractoryCount: UINT32;   // for how many samples (30 kHz) is a neuron refractory, so can't re-trigger
  end;

Const
  cbPKTTYPE_SS_ARTIF_REJECTREP  = $53;        (* NSP->PC response *)
  cbPKTTYPE_SS_ARTIF_REJECTSET  = $D3;        (* PC->NSP request  *)
  cbPKTDLEN_SS_ARTIF_REJECT = ((sizeof(cbPKT_SS_ARTIF_REJECT) div 4) - 2);



// Options for noise boundary

type
  cbPKT_SS_NOISE_BOUNDARY = record
    time: UINT32;               // system clock timestamp
    chid: UINT16;               // $8000
    type1: UINT8;               // cbPKTTYPE_SS_NOISE_BOUNDARYREP or cbPKTTYPE_SS_NOISE_BOUNDARYSET depending on the direction
    dlen: UINT8;               // cbPKTDLEN_SS_ARTIF_REJECT

    chan: UINT32;               // which channel we belong to
    afc: array[0..1] of single;             // the center of an ellipse
    afS: array[0..1,0..1] of single;          // the shape and size of an ellipse
    aTheta: single;              // the angle of rotation for the Noise Boundary (ellipse)
  end;

Const
  cbPKTTYPE_SS_NOISE_BOUNDARYREP  = $54;        (* NSP->PC response *)
  cbPKTTYPE_SS_NOISE_BOUNDARYSET  = $D4;        (* PC->NSP request  *)
  cbPKTDLEN_SS_NOISE_BOUNDARY = ((sizeof(cbPKT_SS_NOISE_BOUNDARY) div 4) - 2);



type
  cbPKT_SS_STATISTICS = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_SS_STATISTICSREP or cbPKTTYPE_SS_STATISTICSSET depending on the direction
    dlen: UINT8;           // cbPKTDLEN_SS_STATISTICS

    nUpdateSpikes: UINT32;  // update rate in spike counts

    nAutoalg: UINT32;       // automatic sorting algorithm (0=spread, 1=hist_corr_maj, 2=hist_peak_count_maj)

    fMinClusterPairSpreadFactor: single;       // larger number = more apt to combine 2 clusters into 1
    fMaxSubclusterSpreadFactor: single;        // larger number = less apt to split because of 2 clusers

    fMinClusterHistCorrMajMeasure: single;     // larger number = more apt to split 1 cluster into 2
    fMaxClusterPairHistCorrMajMeasure: single; // larger number = less apt to combine 2 clusters into 1

    fClusterHistValleyPercentage: single;      // larger number = less apt to split nearby clusters
    fClusterHistClosePeakPercentage: single;   // larger number = less apt to split nearby clusters
    fClusterHistMinPeakPercentage: single;     // larger number = less apt to split separated clusters
  end;

Const
  cbAUTOALG_SPREAD              =  0;
  cbAUTOALG_HIST_CORR_MAJ       =  1;
  cbAUTOALG_HIST_PEAK_COUNT_MAJ =  2;
  cbAUTOALG_HIST_PEAK_COUNT_FISH=  3;

// This packet contains the options for the automatic spike sorting.
//
  cbPKTTYPE_SS_STATISTICSREP  = $55;        (* NSP->PC response *)
  cbPKTTYPE_SS_STATISTICSSET  = $D5;        (* PC->NSP request  *)
  cbPKTDLEN_SS_STATISTICS = ((sizeof(cbPKT_SS_STATISTICS) div 4) - 2);


// Send this packet to the NSP to tell it to reset all spike sorting to default values

type
  cbPKT_SS_RESET = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_SS_RESETREP or cbPKTTYPE_SS_RESETSET depending on the direction
    dlen: UINT8;           // cbPKTDLEN_SS_RESET
  end;

Const
  cbPKTTYPE_SS_RESETREP       = $56;        (* NSP->PC response *)
  cbPKTTYPE_SS_RESETSET       = $D6;        (* PC->NSP request  *)
  cbPKTDLEN_SS_RESET = ((sizeof(cbPKT_SS_RESET) div 4) - 2);


// This packet contains the status of the automatic spike sorting.

type
  cbPKT_SS_STATUS = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;           // cbPKTTYPE_SS_STATUSREP or cbPKTTYPE_SS_STATUSSET depending on the direction
    dlen: UINT8;           // cbPKTDLEN_SS_STATUS

    cntlUnitStats: cbAdaptControl;
    cntlNumUnits: cbAdaptControl;
  end;

Const
  cbPKTTYPE_SS_STATUSREP  = $57;        (* NSP->PC response *)
  cbPKTTYPE_SS_STATUSSET  = $D7;        (* PC->NSP request  *)
  cbPKTDLEN_SS_STATUS =((sizeof(cbPKT_SS_STATUS) div 4) - 2);



// Send this packet to the NSP to tell it to reset all spike sorting models

type
  cbPKT_SS_RESET_MODEL = record
    time: UINT32;           // system clock timestamp
    chid: UINT16;           // $8000
    type1: UINT8;            // cbPKTTYPE_SS_RESET_MODEL_REP or cbPKTTYPE_SS_RESET_MODEL_SET depending on the direction
    dlen: UINT8;            // cbPKTDLEN_SS_RESET_MODEL
  end;

Const
  cbPKTTYPE_SS_RESET_MODEL_REP    = $58;        (* NSP->PC response *)
  cbPKTTYPE_SS_RESET_MODEL_SET    = $D8;        (* PC->NSP request  *)
  cbPKTDLEN_SS_RESET_MODEL = ((sizeof(cbPKT_SS_RESET_MODEL) div 4) - 2);

// Send this packet to force the digital output to this value

type
  cbPKT_SET_DOUT = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000
    type1: UINT8;        // cbPKTTYPE_SET_DOUTREP or cbPKTTYPE_SET_DOUTSET depending on direction
    dlen: UINT8;        // length of waveform in 32-bit chunks
    chan: UINT16;        // which digital output channel (1 based, will equal chan from GetDoutCaps)
    value: UINT16;       // Which value to set? zero = 0; non-zero = 1 (output is 1 bit)
  end;
  PcbPKT_SET_DOUT=^cbPKT_SET_DOUT;

Const
  cbPKTTYPE_SET_DOUTREP       = $5D;        (* NSP->PC response *)
  cbPKTTYPE_SET_DOUTSET       = $DD;        (* PC->NSP request  *)
  cbPKTDLEN_SET_DOUT = ((sizeof(cbPKT_SET_DOUT) div 4) - 2);


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Preview Data Packet Definitions (chid = $8000 + channel)
//
///////////////////////////////////////////////////////////////////////////////////////////////////


// preview information requests

type
  cbPKT_LNCPREV = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000 + channel identifier
    type1: UINT8;        // cbPKT_LNCPREVLEN
    dlen: UINT8;        // length of the waveform/2
    wave: array[0..299] of INT16;   // lnc cancellation waveform (downsampled by 2)
  end;

Const
  cbPKTTYPE_PREVSETLNC    = $81;
  cbPKTTYPE_PREVSETSTREAM = $82;
  cbPKTTYPE_PREVSET       = $83;

  cbPKTTYPE_PREVREP       = $03;        // Acknowledged response from the packet above


// line noise cancellation (LNC) waveform preview packet
  cbPKTTYPE_PREVREPLNC    = $01;
  cbPKTDLEN_PREVREPLNC    =((sizeof(cbPKT_LNCPREV) div 4)-2);


// Streams preview packet

type
  cbPKT_STREAMPREV = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // $8000 + channel identifier
    type1: UINT8;        // cbPKTTYPE_PREVREPSTREAM
    dlen: UINT8;        // cbPKTDLEN_PREVREPSTREAM
    rawmin: INT16;      // minimum raw channel value over last preview period
    rawmax: INT16;      // maximum raw channel value over last preview period
    smpmin: INT16;      // minimum sample channel value over last preview period
    smpmax: INT16;      // maximum sample channel value over last preview period
    spkmin: INT16;      // minimum spike channel value over last preview period
    spkmax: INT16;      // maximum spike channel value over last preview period
    spkmos: UINT32;      // mean of squares
    eventflag: UINT32;   // flag to detail the units that happend in the last sample period
    envmin: INT16;      // minimum envelope channel value over the last preview period
    envmax: INT16;      // maximum envelope channel value over the last preview period
  end;

Const
  cbPKTTYPE_PREVREPSTREAM  = $02;
  cbPKTDLEN_PREVREPSTREAM  = ((sizeof(cbPKT_STREAMPREV) div 4)-2);

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Shared Memory Definitions used by Central App and Cerebus library functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type
  cbCOLORTABLE = record
    winrsvd: array[0..47] of COLORREF;
    dispback: COLORREF;
    dispgridmaj: COLORREF;
    dispgridmin: COLORREF;
    disptext: COLORREF;
    dispwave: COLORREF;
    dispwavewarn: COLORREF;
    dispwaveclip: COLORREF;
    dispthresh: COLORREF;
    dispmultunit: COLORREF;
    dispunit: array[0..15] of COLORREF;  // 0 = unclassified
    dispnoise: COLORREF;
    dispchansel: array[0..2] of COLORREF;
    disptemp: array[0..4] of COLORREF;
    disprsvd: array[0..13] of COLORREF;
  end;
  PcbCOLORTABLE = ^cbCOLORTABLE;

var
  cbGetColorTable: function (var colortable: PcbCOLORTABLE):cbRESULT;cdecl;



type
  cbOPTIONTABLE = record
    fRMSAutoThresholdDistance: single;    // multiplier to use for autothresholding when using
                                        // RMS to guess noise
    reserved: array[0..30] of UINT32;
  end;

var
// Get/Set the multiplier to use for autothresholdine when using RMS to guess noise
// This will adjust fAutoThresholdDistance above, but use the API instead
  cbGetRMSAutoThresholdDistance: function: single;cdecl;
  cbSetRMSAutoThresholdDistance: procedure( fRMSAutoThresholdDistance: single);cdecl;

//////////////////////////////////////////////////////////////////////////////////////////////////

Const
  cbPKT_SPKCACHEPKTCNT =  400;
  cbPKT_SPKCACHELINECNT=  cbNUM_ANALOG_CHANS;

type
  cbSPKCACHE =record
    chid: UINT32;            // ID of the Channel
    pktcnt: UINT32;          // # of packets which can be saved
    pktsize: UINT32;         // Size of an individual packet
    head: UINT32;            // Where (0 based index) in the circular buffer to place the NEXT packet.
    valid: UINT32;           // How many packets have come in since the last configuration
    spkpkt: array[0..cbPKT_SPKCACHEPKTCNT-1] of cbPKT_SPK ;     // Circular buffer of the cached spikes
  end;
  PcbSPKCACHE = ^cbSPKCACHE;

type
  cbSPKBUFF = record
    flags: UINT32;
    chidmax: UINT32;
    linesize: UINT32;
    spkcount: UINT32;
    cache: array[0..cbPKT_SPKCACHELINECNT-1] of cbSPKCACHE;
  end;

var
  cbGetSpkCache: function(  chid: UINT32; var cache: PcbSPKCACHE ): cbRESULT;cdecl;


//////////////////////////////////////////////////////////////////////////////////////////////////


// TODO: separate out these definitions so that there are no conditional compiles
type
  WM_USER_GLOBAL=(
    WM_USER_WAITEVENT = WM_USER,                // mmtimer says it is OK to continue
    WM_USER_CRITICAL_DATA_CATCHUP              // We have reached a critical data point and we have skipped
  );


Const
  cbRECBUFFLEN=  2097118;

type
  cbRECBUFF = record
    received: UINT32;
    lasttime: UINT32;
    headwrap: UINT32;
    headindex: UINT32;
    buffer: array[0..cbRECBUFFLEN-1] of UINT32;
  end;


// The following structure is used to hold Cerebus packets queued for transmission to the NSP.
// The length of the structure is set during initialization of the buffer in the Central App.
// The pragmas allow a zero-length data field entry in the structure for referencing the data.

type
  cbXMTBUFF = record
    transmitted: UINT32;     // How many packets have we sent out?

    headindex: UINT32;       // 1st empty position
                            // (moves on filling)

    tailindex: UINT32;       // 1 past last emptied position (empty when head = tail)
                            // Moves on emptying

    last_valid_index: UINT32;// index number of greatest valid starting index for a head (or tail)
    bufferlen: UINT32;       // number of indexes in buffer (units of UINT32) <------+
    buffer: array[0..0] of UINT32;       // big buffer of data...there are actually "bufferlen"--+ indices
  end;


Const
  WM_USER_SET_THOLD_SIGMA  =   (WM_USER + 100);
  WM_USER_SET_THOLD_TIME   =   (WM_USER + 101);

type
  cbSPIKE_SORTING = record
    // ***** THIS MUST BE 1ST IN THE STRUCTURE ***   SEE WriteCCFNoPrompt()
    asSortModel: array[0..cbMAXCHANS-1, 0..cbMAXUNITS + 1] of cbPKT_SS_MODELSET;    // All of the model (rules) for spike sorting

    //////// These are spike sorting options
    pktDetect: cbPKT_SS_DETECT;              // parameters dealing with actual detection
    pktArtifReject: cbPKT_SS_ARTIF_REJECT;   // artifact rejection
    pktNoiseBoundary: array[0..cbNUM_ANALOG_CHANS-1] of cbPKT_SS_NOISE_BOUNDARY; // where o'where are the noise boundaries
    pktStatistics: cbPKT_SS_STATISTICS;      // information about statistics
    pktStatus: cbPKT_SS_STATUS;              // Spike sorting status
   end;

type
  TcbPcStatus = object
    private
      m_bRecording: bool;
      m_iBlockRecording: INT32;
      m_pktSelection: cbPKT_UNIT_SELECTION;

    public
      procedure Init;
      function IsRecording:bool;
      procedure SetRecording(bRecording:bool);
      function IsRecordingBlocked:bool;
      procedure SetBlockRecording(bBlockRecording: bool);
      function GetChannelSelections: PcbPKT_UNIT_SELECTION;
      procedure SetChannelSelections( rPkt: PcbPKT_UNIT_SELECTION);
    end;
  PcbPcStatus = ^TcbPcStatus;


type
  cbCFGBUFF = record
    version: UINT32;
    sysflags: UINT32;
    hwndCentral: THANDLE;    // Handle to the Window in Central
    optiontable: cbOPTIONTABLE;    // Should be 32 32-bit values
    colortable: cbCOLORTABLE;     // Should be 96 32-bit values
    sysinfo: cbPKT_SYSINFO;
    procinfo: array[0..cbMAXPROCS-1] of cbPKT_PROCINFO;
    bankinfo: array[0..cbMAXPROCS-1,0..cbMAXBANKS-1] of cbPKT_BANKINFO;
    groupinfo: array[0..cbMAXPROCS-1,0..cbMAXGROUPS-1] of cbPKT_GROUPINFO; // sample group ID (1-4=proc1, 5-8=proc2, etc)
    filtinfo: array[0..cbMAXPROCS-1,0..cbMAXFILTS-1] of cbPKT_FILTINFO;
    adaptinfo: cbPKT_ADAPTFILTINFO;          //  Settings about adapting
    refelecinfo: cbPKT_REFELECFILTINFO;          //  Settings about reference electrode filtering
    chaninfo: array[0..cbMAXCHANS-1] of cbPKT_CHANINFO;
    isSortingOptions: cbSPIKE_SORTING;   // parameters dealing with spike sorting
    isNTrodeinfo: array[0..cbMAXNTRODES-1] of cbPKT_NTRODEINFO;  // allow for the max number of ntrodes (if all are stereo-trodes)
 end;
 PcbCFGBUFF = ^cbCFGBUFF;

var
 cbGetCfgBuffer: function: PcbCFGBUFF;cdecl;

// External Global Variables

var
  cb_pc_status_buffer_ptr: PcbPcStatus;       // parameters dealing with local pc status
  cb_cfg_buffer_ptr: ^cbCFGBUFF;

var
  cb_xmt_global_buffer_hnd: THANDLE;       // Transmit queues to send out of this PC
  cb_xmt_global_buffer_ptr: ^cbXMTBUFF;

  cb_xmt_local_buffer_hnd: THANDLE;        // Transmit queues only for local (this PC) use
  cb_xmt_local_buffer_ptr: ^cbXMTBUFF;


  cb_rec_buffer_hnd: THANDLE;
  cb_rec_buffer_ptr: ^cbRECBUFF;
  cb_cfg_buffer_hnd: THANDLE;

  cb_pc_status_buffer_hnd: THANDLE;

  cb_spk_buffer_hnd: THANDLE;
  cb_spk_buffer_ptr: ^cbSPKBUFF;
  cb_sig_event_hnd: THANDLE;

  cb_library_initialized: UINT32;

Const
  LOCAL_XMT_NAME = '5718BF79-9A7E-47a9-BBB1-37B464D501BC';  // GUID .. I gotta be me
  GLOBAL_XMT_NAME = '09867541-9E76-4557-8F6A-145320DB60D6'; // GUID .. I gotta be me


function InitCyberKDLL:boolean;
procedure FreeCyberKdll;

Implementation

uses util1;
{ cbPKT_UNIT_SELECTION }

procedure cbPKT_UNIT_SELECTION.Init(iLastchan: INT16);
begin

end;

function cbPKT_UNIT_SELECTION.UnitToUnitmask(nUnit: integer): integer;
begin

end;

{ TcbPcStatus }

function TcbPcStatus.GetChannelSelections: PcbPKT_UNIT_SELECTION;
begin

end;

procedure TcbPcStatus.Init;
begin

end;

function TcbPcStatus.IsRecording: bool;
begin

end;

function TcbPcStatus.IsRecordingBlocked: bool;
begin

end;

procedure TcbPcStatus.SetBlockRecording(bBlockRecording: bool);
begin

end;

procedure TcbPcStatus.SetChannelSelections(rPkt: PcbPKT_UNIT_SELECTION);
begin

end;

procedure TcbPcStatus.SetRecording(bRecording: bool);
begin

end;



function getProc(hh:Thandle;st:string):pointer;
begin
  result:=GetProcAddress(hh,Pchar(st));
  if result=nil then
  begin
    messageCentral(st+'=nil');
    DisplayLastError;
  end;
end;

var
  hh:integer;

function InitCyberKDLL:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('CyberK.dll');
  result:=(hh<>0);
  if not result then exit;

  cbVersion:= getProc(hh,'cbVersion');
  cbOpen:= getProc(hh,'cbOpen');
  cbClose:= getProc(hh,'cbClose');
  cbMakePacketReadingBeginNow:= getProc(hh,'cbMakePacketReadingBeginNow');
  cbGetProcInfo:= getProc(hh,'cbGetProcInfo');
  cbGetBankInfo:= getProc(hh,'cbGetBankInfo');
  cbGetChanCount:= getProc(hh,'cbGetChanCount');
  cbGetSystemRunLevel:= getProc(hh,'cbGetSystemRunLevel');
  cbSetSystemRunLevel:= getProc(hh,'cbSetSystemRunLevel');
  cbGetSystemClockFreq:= getProc(hh,'cbGetSystemClockFreq');
  cbGetSystemClockTime:= getProc(hh,'cbGetSystemClockTime');
  cbGetSpikeLength:= getProc(hh,'cbGetSpikeLength');
  cbSetSpikeLength:= getProc(hh,'cbSetSpikeLength');
  cbGetFilterDesc:= getProc(hh,'cbGetFilterDesc');
  cbGetAdaptFilter:= getProc(hh,'cbGetAdaptFilter');
  cbSetAdaptFilter:= getProc(hh,'cbSetAdaptFilter');
  cbGetRefElecFilter:= getProc(hh,'cbGetRefElecFilter');
  cbSetRefElecFilter:= getProc(hh,'cbSetRefElecFilter');
  cbGetSampleGroupInfo:= getProc(hh,'cbGetSampleGroupInfo');
  cbGetSampleGroupList:= getProc(hh,'cbGetSampleGroupList');
//  cbSetSampleGroupOptions:= getProc(hh,'cbSetSampleGroupOptions');
  cbGetChanCaps:= getProc(hh,'cbGetChanCaps');
  cbGetChanLoc:= getProc(hh,'cbGetChanLoc');
  cbGetChanLabel:= getProc(hh,'cbGetChanLabel');
  cbSetChanLabel:= getProc(hh,'cbSetChanLabel');
  cbGetChanNTrodeGroup:= getProc(hh,'cbGetChanNTrodeGroup');
  cbSetChanNTrodeGroup:= getProc(hh,'cbSetChanNTrodeGroup');
  cbGetChanUnitMapping:= getProc(hh,'cbGetChanUnitMapping');
  cbSetChanUnitMapping:= getProc(hh,'cbSetChanUnitMapping');
  cbGetDinpCaps:= getProc(hh,'cbGetDinpCaps');
  cbGetDinpOptions:= getProc(hh,'cbGetDinpOptions');
  cbSetDinpOptions:= getProc(hh,'cbSetDinpOptions');
  cbGetDoutCaps:= getProc(hh,'cbGetDoutCaps');
  cbGetDoutOptions:= getProc(hh,'cbGetDoutOptions');
  cbSetDoutOptions:= getProc(hh,'cbSetDoutOptions');
  cbGetAinpCaps:= getProc(hh,'cbGetAinpCaps');
  cbGetAinpScaling:= getProc(hh,'cbGetAinpScaling');
  cbSetAinpScaling:= getProc(hh,'cbSetAinpScaling');
  cbGetAinpDisplay:= getProc(hh,'cbGetAinpDisplay');
  cbSetAinpDisplay:= getProc(hh,'cbSetAinpDisplay');
  cbGetAinpLnc:= getProc(hh,'cbGetAinpLnc');
  cbSetAinpLnc:= getProc(hh,'cbSetAinpLnc');
  cbSetAinpPreview:= getProc(hh,'cbSetAinpPreview');
  cbGetAinpSampling:= getProc(hh,'cbGetAinpSampling');
  cbSetAinpSampling:= getProc(hh,'cbSetAinpSampling');
  cbGetAinpSpikeCaps:= getProc(hh,'cbGetAinpSpikeCaps');
  cbGetAinpSpikeOptions:= getProc(hh,'cbGetAinpSpikeOptions');
  cbSetAinpSpikeOptions:= getProc(hh,'cbSetAinpSpikeOptions');
  cbGetAinpSpikeThreshold:= getProc(hh,'cbGetAinpSpikeThreshold');
  cbSetAinpSpikeThreshold:= getProc(hh,'cbSetAinpSpikeThreshold');
  cbGetAinpSpikeHoops:= getProc(hh,'cbGetAinpSpikeHoops');
  cbSetAinpSpikeHoops:= getProc(hh,'cbSetAinpSpikeHoops');
  cbGetAoutCaps:= getProc(hh,'cbGetAoutCaps');
  cbGetAoutScaling:= getProc(hh,'cbGetAoutScaling');
  cbSetAoutScaling:= getProc(hh,'cbSetAoutScaling');
  cbGetAoutOptions:= getProc(hh,'cbGetAoutOptions');
  cbSetAoutOptions:= getProc(hh,'cbSetAoutOptions');
  cbGetSortingModel:= getProc(hh,'cbGetSortingModel');
  cbSSGetNoiseBoundary:= getProc(hh,'cbSSGetNoiseBoundary');
  cbSSSetNoiseBoundary:= getProc(hh,'cbSSSetNoiseBoundary');
  cbSSGetStatistics:= getProc(hh,'cbSSGetStatistics');
  cbSSSetStatistics:= getProc(hh,'cbSSSetStatistics');
  cbSSGetArtifactReject:= getProc(hh,'cbSSGetArtifactReject');
  cbSSSetArtifactReject:= getProc(hh,'cbSSSetArtifactReject');
  cbSSGetDetect:= getProc(hh,'cbSSGetDetect');
  cbSSSetDetect:= getProc(hh,'cbSSSetDetect');
  cbSSGetStatus:= getProc(hh,'cbSSGetStatus');
  cbSSSetStatus:= getProc(hh,'cbSSSetStatus');
  cbCheckforData:= getProc(hh,'cbCheckforData');
  cbWaitforData:= getProc(hh,'cbWaitforData');
  cbGetNextPacketPtr:= getProc(hh,'cbGetNextPacketPtr');
  cbSendPacket:= getProc(hh,'cbSendPacket');
  cbSendLoopbackPacket:= getProc(hh,'cbSendLoopbackPacket');
  cbGetNTrodeInfo:= getProc(hh,'cbGetNTrodeInfo');
  cbSetNTrodeInfo:= getProc(hh,'cbSetNTrodeInfo');
  cbGetColorTable:= getProc(hh,'cbGetColorTable');
  cbGetRMSAutoThresholdDistance:= getProc(hh,'cbGetRMSAutoThresholdDistance');
  cbSetRMSAutoThresholdDistance:= getProc(hh,'cbSetRMSAutoThresholdDistance');
  cbGetSpkCache:= getProc(hh,'cbGetSpkCache');
  cbGetCfgBuffer:=getProc(hh,'cbGetCfgBuffer');

end;

procedure FreeCyberKdll;
begin
  FreeLibrary(hh);
  hh:=0;
end;


end.
