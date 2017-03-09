unit cyberK3;         NON UTILISEE

{ 28 avril 2010

  CyberK2 remplace cyberK1 pour tenir compte de l'évolution de cbwhlib.h
  La dll porte toujours le même nom mais correspond à la version 3.6 au lieu de 3.5

  cbwlib se trouve dans D:\I2S C++ utility\Headers 27-04-10
  Au lieu de tout traduire en pascal comme pour CyberK1, on se limite aux seules fonctions
  et structures utilisées par Elphy.


  5 aout 2011
  CyberK3 remplace cyberK2
  Ce qui correspond à la version cbhwlib 3.7

}

Interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows, messages, util1;

{$A1 }

const
  cbVERSION_MAJOR = 3;
  cbVERSION_MINOR = 7;


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


//  Some of the string length constants
Const
  cbLEN_STR_UNIT      = 8;
  cbLEN_STR_LABEL     = 16;
  cbLEN_STR_FILT_LABEL= 16;
  cbLEN_STR_IDENT     = 64;


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

  cbRESULT_BUFRECALLOCERR    = 14;   // Receive buffer could not be allocated
  cbRESULT_BUFGXMTALLOCERR   = 15;   // Global transmit buffer could not be allocated
  cbRESULT_BUFLXMTALLOCERR   = 16;   // Local transmit buffer could not be allocated
  cbRESULT_BUFCFGALLOCERR    = 17;   // Configuration buffer could not be allocated
  cbRESULT_BUFPCSTATALLOCERR = 18;   // PC status buffer could not be allocated
  cbRESULT_BUFSPKALLOCERR    = 19;   // Spike cache buffer could not be allocated
  cbRESULT_EVSIGERR          = 20;   // Couldn't create shared event signal


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




  cbGetSpikeLength: function( length: PUINT32;  pretrig: PUINT32;  pSysfreq: PUINT32): cbRESULT;cdecl;
  cbSetSpikeLength: function( length: UINT32;  pretrig: UINT32): cbRESULT;cdecl;
// Get/Set the system-wide spike length.  Lengths should be specified in multiples of 2 and
// within the range of 16 to 128 samples long.
//
// Returns: cbRESULT_OK if data successfully retreived.
//          cbRESULT_INVALIDCHANNEL if the specified channel is not mapped or does not exist.
//          cbRESULT_INVALIDFUNCTION if invalid flag combinations are passed.
//          cbRESULT_NOLIBRARY if the library was not properly initialized.



  cbGetSampleGroupInfo: function(  proc: UINT32;  group: UINT32; label1:Pansichar;  period: PUINT32;  length: PUINT32 ): cbRESULT;cdecl;
  cbGetSampleGroupList: function(  proc: UINT32;  group: UINT32; length: PUINT32;  list: PUINT32 ): cbRESULT;cdecl;




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

   // New in 3.7
   cbDINP_STRBANY      = $00080000;  // Capture packets using 8-bit strobe/8-bit any Input
   cbDINP_STRBRIS      = $00100000;  // Capture packets using 8-bit strobe/8-bit rising edge Input
   cbDINP_STRBFAL      = $00200000;  // Capture packets using 8-bit strobe/8-bit falling edge Input

var
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



type
// Generic Cerebus packet data structure (1024 bytes total)
  cbPKT_GENERIC = record
                    time: UINT32;        // system clock timestamp
                    chid: UINT16;        // channel identifier
                    type1: UINT8;        // packet type
                    dlen: UINT8;        // length of data field in 32-bit chunks
                    data: array[0..253] of UINT32;   // data buffer (up to 1016 bytes)
                   end;
  PcbPKT_GENERIC=^cbPKT_GENERIC;

var
  cbGetNextPacketPtr: function: PcbPKT_GENERIC;cdecl;
// Returns pointer to next packet in the shared memory space.  If no packet available, returns NULL


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Data Packet Structures (chid<0x8000)
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type

//Pseudo Generic (GS)
  TGENERIC = record
    time: UINT32;        // system clock timestamp
    chid: UINT16;        // channel identifier
    type1: UINT8;        // packet type
    dlen: UINT8;        // length of data field in 32-bit chunks
    bb: array[0..1015] of byte;   // data buffer (up to 1016 bytes)
  end;
  PGENERIC = ^TGENERIC;


// Sample Group data packet
  cbPKT_GROUP =
    record
      time: UINT32;       // system clock timestamp
      chid: UINT16;       // 0x0000
      type1: UINT8;       // sample group ID (1-127)
      dlen: UINT8;       // packet length equal
      data: array[0..251] of INT16;  // variable length address list
    end;


// DINP digital value data
  cbPKT_DINP =
    record
      time: UINT32;        // system clock timestamp
      chid: UINT16;        // channel identifier
      unit1: UINT8;        // reserved
      dlen: UINT8;        // length of waveform in 32-bit chunks
      data: array[0..253] of  UINT32;   // data buffer (up to 1016 bytes)
    end;
  PcbPKT_DINP=^cbPKT_DINP;

  cbPKT_SPK =
    record
      time: UINT32;                // system clock timestamp
      chid: UINT16;                // channel identifier
      unit1: UINT8;                // unit identification (0=unclassified, 31=artifact, 30=background)
      dlen1: UINT8;                // length of what follows ... always  cbPKTDLEN_SPK
      fPattern: array[0..2] of single;   // values of the pattern space (Normal uses only 2, PCA uses third)
      nPeak: INT16;
      nValley: INT16;
      wave: array[0..127] of INT16;    // Room for all possible points collected
    end;
  PcbPKT_SPK = ^cbPKT_SPK;

// Send this packet to force the digital output to this value
const
  cbPKTTYPE_SET_DOUTREP =  $5D;        // NSP->PC response
  cbPKTTYPE_SET_DOUTSET =  $DD;        // PC->NSP request
type
  cbPKT_SET_DOUT =
    record
      time: UINT32;        // system clock timestamp
      chid: UINT16;        // 0x8000
      type1: UINT8;        // cbPKTTYPE_SET_DOUTREP or cbPKTTYPE_SET_DOUTSET depending on direction
      dlen: UINT8;         // length of waveform in 32-bit chunks
      chan: UINT16;        // which digital output channel (1 based, will equal chan from GetDoutCaps)
      value: UINT16;       // Which value to set? zero = 0; non-zero = 1 (output is 1 bit)
    end;

  PcbPKT_SET_DOUT= ^cbPKT_SET_DOUT;


{ Cette structure est utilisée par Elphy pour stocker les spikes
  Dans les premières versions de cbwhlib, on copiait directement cbPKT_SPK après ElphyTime
  Avec le changement des champs fpattern, on copie champ par champ
  dumdum pourrait être utilisé pour ranger des infos spécifiques
}
type
  TElphySpkPacket = record
                      ElphyTime:UINT32;            // champ supplémentaire
                      time: UINT32;                // id
                      chid: UINT16;                // id
                      unit1: UINT8;                // id
                      dumdum:array[1..13] of byte;
                      wave: array[0..127] of INT16;    // dlen points
                    end;
  PElphySpkPacket=^TElphySpkPacket;
const
  ElphySpkPacketFixedSize=sizeof(TElphySpkPacket)-128*2;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Configuration/Report Packet Definitions (chid = 0x8000)
//
///////////////////////////////////////////////////////////////////////////////////////////////////


var
// Cerebus Library function to send packets via the Central Application Queue
  cbSendPacket: function(pPacket: pointer): cbRESULT;cdecl;
  cbSendLoopbackPacket: function(pPacket: pointer): cbRESULT; cdecl;


// System Heartbeat Packet (sent every 10ms)
type
  cbPKT_SYSHEARTBEAT=
    record
      time: UINT32;        // system clock timestamp
      chid: UINT16;        // 0x8000
      type1: UINT8;       // 0
      dlen: UINT8;        // cbPKTDLEN_SYSHEARTBEAT
    end;

function InitCyberKDLL:boolean;
procedure FreeCyberKdll;

implementation

function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then
  begin
    messageCentral(st+'=nil');
    DisplayLastError;
  end;
end;

var
  hh:intG;

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

  cbGetSampleGroupInfo:= getProc(hh,'cbGetSampleGroupInfo');
  cbGetSampleGroupList:= getProc(hh,'cbGetSampleGroupList');

  cbGetDinpOptions:= getProc(hh,'cbGetDinpOptions');
  cbSetDinpOptions:= getProc(hh,'cbSetDinpOptions');

  cbGetAinpSampling:= getProc(hh,'cbGetAinpSampling');
  cbSetAinpSampling:= getProc(hh,'cbSetAinpSampling');

  cbGetNextPacketPtr:= getProc(hh,'cbGetNextPacketPtr');
  cbSendPacket:= getProc(hh,'cbSendPacket');
  cbSendLoopbackPacket:= getProc(hh,'cbSendLoopbackPacket');

  cbGetSpikeLength:=getProc(hh,'cbGetSpikeLength');
  cbSetSpikeLength:=getProc(hh,'cbSetSpikeLength');

end;

procedure FreeCyberKdll;
begin
  FreeLibrary(hh);
  hh:=0;
end;


end.
