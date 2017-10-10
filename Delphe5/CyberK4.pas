unit CyberK4;

{ 28 avril 2010

  CyberK2 remplace cyberK1 pour tenir compte de l'évolution de cbwhlib.h
  La dll porte toujours le même nom mais correspond à la version 3.6 au lieu de 3.5

  cbwlib se trouve dans D:\I2S C++ utility\Headers 27-04-10
  Au lieu de tout traduire en pascal comme pour CyberK1, on se limite aux seules fonctions
  et structures utilisées par Elphy.

 5 aout 2011
  Dans la version cbhwlib 3.7 , rien n'a changé dans la partie utilisée par Elphy.
  Donc CyberK2 ne change pas.
  Cependant, la DLL doit être recompilée avec la nouvelle version de cbwhlib.h

 Mars 2015
  La nouvelle version est la 3.10
  Tous les fichiers utiles sont dans D:\VSprojects10\CerebusSDKSample605\
  Dans le sous dossier cbsdk 605, on trouve cbhwlib.h et cbsdk.h, ainsi que la dll cbsdk.dll (ou cbsdkx64.dll pour le 64 bits)
  cbsdk.dll est une couche de logiciel supplémentaire qui oblige à utiliser une callback function

  Ci-dessous, on trouvera
    - la partie de cbhwlib qui est utile pour Elphy
    + les déclarations de cbdk permettant l'accès à la dll

  A priori, les fonctions de cbhwlib ne sont pas utilisées. Donc on ne déclare pas ici. On ne garde que les
  structures des paquets utiles.


 Octobre 2017
 CyberK4 gère également la version 3.11

 Comme les modifications sont mineures, on détecte la version au chargement de la dll cbSdk
 Ensuite, on tient compte de la valeur de CbLibVersion ( 310 ou 311 )
 Cette variable est accessible dans cyberKbrd2

 La seule fonction modifiée est cbSdkGetSampleGroupList
}

Interface


uses Windows, messages, util1;

{$A1 }
{$MINENUMSIZE 4}
const
  cbVERSION_MAJOR = 3;
  cbVERSION_MINOR = 10;


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

  cbRESULT_SOCKERR           = 21;   // Generic socket creation error
  cbRESULT_SOCKOPTERR        = 22;   // Socket option error (possibly permission issue)
  cbRESULT_SOCKMEMERR        = 23;   // Socket memory assignment error
  cbRESULT_INSTINVALID       = 24;   // Invalid range or instrument address
  cbRESULT_SOCKBIND          = 25;   // Cannot bind to any address (possibly no Instrument network)
  cbRESULT_SYSLOCK           = 26;   // Cannot (un)lock the system resources (possiblly resource busy)


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
   cbDINP_STRBANY      = $00080000;  // Capture packets using 8-bit strobe/8-bit any Input
   cbDINP_STRBRIS      = $00100000;  // Capture packets using 8-bit strobe/8-bit rising edge Input
   cbDINP_STRBFAL      = $00200000;  // Capture packets using 8-bit strobe/8-bit falling edge Input
   cbDINP_MASK         = cbDINP_ANYBIT OR cbDINP_WRDSTRB OR cbDINP_PKTCHAR OR cbDINP_PKTSTRB OR
                         cbDINP_MONITOR OR cbDINP_REDGE OR cbDINP_FEDGE OR cbDINP_STRBANY OR
                         cbDINP_STRBRIS OR cbDINP_STRBFAL;


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Digital Output Inquiry and Configuration Functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

Const
  cbDOUT_SERIALMASK =          $000000FF;  // Port operates as an RS232 Serial Connection
  cbDOUT_BAUD2400 =            $00000001;  // Serial Port operates at 2400   (n-8-1)
  cbDOUT_BAUD9600 =            $00000002;  // Serial Port operates at 9600   (n-8-1)
  cbDOUT_BAUD19200 =           $00000004;  // Serial Port operates at 19200  (n-8-1)
  cbDOUT_BAUD38400 =           $00000008;  // Serial Port operates at 38400  (n-8-1)
  cbDOUT_BAUD57600 =           $00000010;  // Serial Port operates at 57600  (n-8-1)
  cbDOUT_BAUD115200 =          $00000020;  // Serial Port operates at 115200 (n-8-1)
  cbDOUT_1BIT =                $00000100;  // Port has a single output bit (eg single BNC output)
  cbDOUT_8BIT =                $00000200;  // Port has 8 output bits
  cbDOUT_16BIT =               $00000400;  // Port has 16 output bits
  cbDOUT_32BIT =               $00000800;  // Port has 32 output bits
  cbDOUT_VALUE =               $00010000;  // Port can be manually configured
  cbDOUT_TRACK =               $00020000;  // Port should track the most recently selected channel
  cbDOUT_FREQUENCY =           $00040000;  // Port can output a frequency
  cbDOUT_TRIGGERED =           $00080000;  // Port can be triggered
  cbDOUT_MONITOR_UNIT0 =       $01000000;  // Can monitor unit 0 = UNCLASSIFIED
  cbDOUT_MONITOR_UNIT1 =       $02000000;  // Can monitor unit 1
  cbDOUT_MONITOR_UNIT2 =       $04000000;  // Can monitor unit 2
  cbDOUT_MONITOR_UNIT3 =       $08000000;  // Can monitor unit 3
  cbDOUT_MONITOR_UNIT4 =       $10000000;  // Can monitor unit 4
  cbDOUT_MONITOR_UNIT5 =       $20000000;  // Can monitor unit 5
  cbDOUT_MONITOR_UNIT_ALL =    $3F000000;  // Can monitor ALL units
  cbDOUT_MONITOR_SHIFT_TO_FIRST_UNIT = 24;  // This tells us how many bit places to get to unit 1
// Trigger types for Digital Output channels
  cbDOUT_TRIGGER_NONE =         0;   // instant software trigger
  cbDOUT_TRIGGER_DINPRISING =   1;   // digital input rising edge trigger
  cbDOUT_TRIGGER_DINPFALLING =  2;   // digital input falling edge trigger
  cbDOUT_TRIGGER_SPIKEUNIT =    3;   // spike unit
  cbDOUT_TRIGGER_NM =	        4;   // comment RGBA color (A being big byte)
  cbDOUT_TRIGGER_SOFTRESET =    5;   // soft-reset trigger
  cbDOUT_TRIGGER_EXTENSION =    6;   // extension trigger


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Analog Input Inquiry and Configuration Functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

  cbAINP_RAWPREVIEW =          $00000001;      // Generate scrolling preview data for the raw channel
  cbAINP_LNC =                 $00000002;      // Line Noise Cancellation
  cbAINP_LNCPREVIEW =          $00000004;      // Retrieve the LNC correction waveform
  cbAINP_SMPSTREAM =           $00000010;      // stream the analog input stream directly to disk
  cbAINP_SMPFILTER =           $00000020;      // Digitally filter the analog input stream
  cbAINP_RAWSTREAM =           $00000040;      // Raw data stream available
  cbAINP_SPKSTREAM =           $00000100;      // Spike Stream is available
  cbAINP_SPKFILTER =           $00000200;      // Selectable Filters
  cbAINP_SPKPREVIEW =          $00000400;      // Generate scrolling preview of the spike channel
  cbAINP_SPKPROC =             $00000800;      // Channel is able to do online spike processing
  cbAINP_OFFSET_CORRECT_CAP =  $00001000;      // Offset correction mode (0-disabled 1-enabled)


  cbAINP_LNC_OFF =             $00000000;      // Line Noise Cancellation disabled
  cbAINP_LNC_RUN_HARD =        $00000001;      // Hardware-based LNC running and adapting according to the adaptation const
  cbAINP_LNC_RUN_SOFT =        $00000002;      // Software-based LNC running and adapting according to the adaptation const
  cbAINP_LNC_HOLD =            $00000004;      // LNC running, but not adapting
  cbAINP_LNC_MASK =            $00000007;      // Mask for LNC Flags
  cbAINP_REFELEC_LFPSPK =      $00000010;      // Apply reference electrode to LFP & Spike
  cbAINP_REFELEC_SPK =         $00000020;      // Apply reference electrode to Spikes only
  cbAINP_REFELEC_MASK =        $00000030;      // Mask for Reference Electrode flags
  cbAINP_RAWSTREAM_ENABLED =   $00000040;      // Raw data stream enabled
  cbAINP_OFFSET_CORRECT =      $00000100;      // Offset correction mode (0-disabled 1-enabled)


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Default Cerebus networking connection parameters
//
//  All connections should be defined here
//
///////////////////////////////////////////////////////////////////////////////////////////////////
Const
  cbNET_UDP_ADDR_INST =        '192.168.137.1';   // Cerebus default address
  cbNET_UDP_ADDR_CNT =         '192.168.137.128'; // NSP default control address
  cbNET_UDP_ADDR_BCAST =       '192.168.137.255'; // NSP default broadcast address
  cbNET_UDP_PORT_BCAST =       51002;             // Neuroflow Data Port
  cbNET_UDP_PORT_CNT =         51001;             // Neuroflow Control Port
// maximum udp datagram size used to transport cerebus packets, taken from MTU size
  cbCER_UDP_SIZE_MAX =         1452; // Note that multiple packets may reside in one udp datagram as aggregate

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Maximum entity ranges for static declarations using this version of the library
//
///////////////////////////////////////////////////////////////////////////////////////////////////
  cbNSP1 =      1;

///////////////////////////////////////////////////////////
  cbRAWGROUP = 6;   // group number for raw data feed
///////////////////////////////////////////////////////////

// Front End Channels   (128)   ->  (256)
// Analog Input         (16)    ->  (32)
// Analog Output        (4)     ->  (8)
// Audio Output         (2)     ->  (4)
// Digital Output       (4)     ->  (8)
// Digital Input        (1)     ->  (2)
// Serial Input         (1)     ->  (2)
//---------------------------------------
// Total (actually 156) (160)   ->  (320)
//
  cbMAXOPEN =   4;                               // Maximum number of open cbhwlib's (nsp's)
  cbMAXPROCS =  1;                               // Number of NSP's
  cbMAXGROUPS = 8;                               // number of sample rate groups
  cbMAXFILTS =  32;
  cbMAXVIDEOSOURCE = 1;                          // maximum number of video sources
  cbMAXTRACKOBJ = 20;                            // maximum number of trackable objects
  cbMAXHOOPS =  4;
  cbMAX_AOUT_TRIGGER = 5;                        // maximum number of per-channel (analog output, or digital output) triggers

// N-Trode definitions
  cbMAXSITES =  4;                               //*** maximum number of electrodes that can be included in an n-trode group  -- eventually want to support octrodes
  cbMAXSITEPLOTS = ((cbMAXSITES - 1) * cbMAXSITES / 2);  // combination of 2 out of n is n!/((n-2)!2!) -- the only issue is the display

// Channel Definitions
  cbNUM_FE_CHANS =        128;                                       // #Front end channels
  cbNUM_ANAIN_CHANS =     16;                                        // #Analog Input channels
  cbNUM_ANALOG_CHANS =    (cbNUM_FE_CHANS + cbNUM_ANAIN_CHANS);      // Total Analog Inputs
  cbNUM_ANAOUT_CHANS =    4;                                         // #Analog Output channels
  cbNUM_AUDOUT_CHANS =    2;                                         // #Audio Output channels
  cbNUM_ANALOGOUT_CHANS = (cbNUM_ANAOUT_CHANS + cbNUM_AUDOUT_CHANS); // Total Analog Output
  cbNUM_DIGIN_CHANS =     1;                                         // #Digital Input channels
  cbNUM_SERIAL_CHANS =    1;                                         // #Serial Input channels
  cbNUM_DIGOUT_CHANS =    4;                                         // #Digital Output channels

// Total of all channels = 156
  cbMAXCHANS =            (cbNUM_ANALOG_CHANS +  cbNUM_ANALOGOUT_CHANS + cbNUM_DIGIN_CHANS + cbNUM_SERIAL_CHANS + cbNUM_DIGOUT_CHANS);

  cbFIRST_FE_CHAN =       0;                                          // 0   First Front end channel
  cbFIRST_ANAIN_CHAN =    cbNUM_FE_CHANS;                             // 256 First Analog Input channel
  cbFIRST_ANAOUT_CHAN =   (cbFIRST_ANAIN_CHAN + cbNUM_ANAIN_CHANS);   // 288 First Analog Output channel
  cbFIRST_AUDOUT_CHAN =   (cbFIRST_ANAOUT_CHAN + cbNUM_ANAOUT_CHANS); // 296 First Audio Output channel
  cbFIRST_DIGIN_CHAN  =   (cbFIRST_AUDOUT_CHAN + cbNUM_AUDOUT_CHANS); // 300 First Digital Input channel
  cbFIRST_SERIAL_CHAN =   (cbFIRST_DIGIN_CHAN + cbNUM_DIGIN_CHANS);   // 302 First Serial Input channel
   cbFIRST_DIGOUT_CHAN =  (cbFIRST_SERIAL_CHAN + cbNUM_SERIAL_CHANS); // 304 First Digital Output channel

// Bank definitions - NOTE: If any of the channel types have more than cbCHAN_PER_BANK channels, the banks must be increased accordingly
  cbCHAN_PER_BANK =       32;                                         // number of 32 channel banks == 1024
  cbNUM_FE_BANKS =        (cbNUM_FE_CHANS / cbCHAN_PER_BANK);         // number of Front end banks
  cbNUM_ANAIN_BANKS =     1;                                          // number of Analog Input banks
  cbNUM_ANAOUT_BANKS =    1;                                          // number of Analog Output banks
  cbNUM_AUDOUT_BANKS =    1;                                          // number of Audio Output banks
  cbNUM_DIGIN_BANKS =     1;                                          // number of Digital Input banks
  cbNUM_SERIAL_BANKS =    1;                                          // number of Serial Input banks
  cbNUM_DIGOUT_BANKS =    1;                                          // number of Digital Output banks

// Custom digital filters
  cbFIRST_DIGITAL_FILTER =  13;  // (0-based) filter number, must be less than cbMAXFILTS
  cbNUM_DIGITAL_FILTERS =   4;

// This is the number of aout chans with gain. Conveniently, the
// 4 Analog Outputs and the 2 Audio Outputs are right next to each other
// in the channel numbering sequence.
  AOUT_NUM_GAIN_CHANS =             (cbNUM_ANAOUT_CHANS + cbNUM_AUDOUT_CHANS);

// Total number of banks
  cbMAXBANKS =            (cbNUM_FE_BANKS + cbNUM_ANAIN_BANKS + cbNUM_ANAOUT_BANKS + cbNUM_AUDOUT_BANKS + cbNUM_DIGIN_BANKS + cbNUM_SERIAL_BANKS + cbNUM_DIGOUT_BANKS);

  cbMAXUNITS =            5;                                         // hard coded to 5 in some places
  cbMAXNTRODES =          (cbNUM_ANALOG_CHANS / 2);                  // minimum is stereotrode so max n-trodes is max chans / 2

// These defines moved from cbHwlibHi to have a central place
  MAX_CHANS_FRONT_END =    cbNUM_FE_CHANS;
  MIN_CHANS_ANALOG_IN =    (MAX_CHANS_FRONT_END + 1);
  MAX_CHANS_ANALOG_IN =    (MAX_CHANS_FRONT_END + cbNUM_ANAIN_CHANS);
  MIN_CHANS_ANALOG_OUT =   (MAX_CHANS_ANALOG_IN + 1);
  MAX_CHANS_ANALOG_OUT =  (MAX_CHANS_ANALOG_IN + cbNUM_ANAOUT_CHANS);
  MIN_CHANS_AUDIO      =  (MAX_CHANS_ANALOG_OUT + 1);
  MAX_CHANS_AUDIO      =  (MAX_CHANS_ANALOG_OUT + cbNUM_AUDOUT_CHANS);
  MIN_CHANS_DIGITAL_IN =  (MAX_CHANS_AUDIO + 1);
  MAX_CHANS_DIGITAL_IN =  (MAX_CHANS_AUDIO + cbNUM_DIGIN_CHANS);
  MIN_CHANS_SERIAL     =  (MAX_CHANS_DIGITAL_IN + 1);
  MAX_CHANS_SERIAL     =  (MAX_CHANS_DIGITAL_IN + cbNUM_SERIAL_CHANS);
  MIN_CHANS_DIGITAL_OUT=  (MAX_CHANS_SERIAL + 1);
  MAX_CHANS_DIGITAL_OUT=  (MAX_CHANS_SERIAL + cbNUM_DIGOUT_CHANS);
  SCALE_LNC_COUNT      =  17;
  SCALE_CONTINUOUS_COUNT= 17;
  SCALE_SPIKE_COUNT     = 23;

type
  cbPKT_HEADER = record
                    time: UINT32;        // system clock timestamp
                    chid: UINT16;        // channel identifier
                    type1: UINT8;        // packet type
                    dlen: UINT8;        // length of data field in 32-bit chunks
                 end;
Const
  cbPKT_HEADER_SIZE   =    sizeof(cbPKT_HEADER);     // define the size of the packet header in bytes
  cbPKT_HEADER_32SIZE =    (cbPKT_HEADER_SIZE div 4);  // define the size of the packet header in UINT32's

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

// System Heartbeat Packet (sent every 10ms)
type
  cbPKT_SYSHEARTBEAT=
    record
      time: UINT32;        // system clock timestamp
      chid: UINT16;        // 0x8000
      type1: UINT8;       // 0
      dlen: UINT8;        // cbPKTDLEN_SYSHEARTBEAT
    end;


type
  cbSCALING =record
       digmin:INT16;     // digital value that cooresponds with the anamin value
       digmax:INT16;     // digital value that cooresponds with the anamax value
       anamin:INT32;     // the minimum analog value present in the signal
       anamax:INT32;     // the maximum analog value present in the signal
       anagain:INT32;    // the gain applied to the default analog values to get the analog values
       anaunit: array[0..cbLEN_STR_UNIT-1] of AnsiChar; // the unit for the analog signal (eg, "uV" or "MPa")
  end;

Const
  cbFILTTYPE_PHYSICAL     = $0001;
  cbFILTTYPE_DIGITAL      = $0002;
  cbFILTTYPE_ADAPTIVE     = $0004;
  cbFILTTYPE_NONLINEAR    = $0008;
  cbFILTTYPE_BUTTERWORTH  = $0100;
  cbFILTTYPE_CHEBYCHEV    = $0200;
  cbFILTTYPE_BESSEL       = $0400;
  cbFILTTYPE_ELLIPTICAL   = $0800;

type
  cbFILTDESC =record
      label1: array[0..cbLEN_STR_FILT_LABEL-1] of AnsiChar;
      hpfreq: UINT32;     // high-pass corner frequency in milliHertz
      hporder:UINT32;    // high-pass filter order
      hptype: UINT32;     // high-pass filter type
      lpfreq: UINT32;     // low-pass frequency in milliHertz
      lporder:UINT32;    // low-pass filter order
      lptype: UINT32;     // low-pass filter type
  end;

  cbAMPLITUDEREJECT = record
     bEnabled: UINT32;    // BOOL implemented as UINT32 - for structure alignment at paragraph boundary
     nAmplPos: INT16;
     nAmplNeg: INT16;
  end;

  cbMANUALUNITMAPPING = record
     nOverride: INT16;
     afOrigin:  array[0..2] of INT16;
     afShape:   array[0..2,0..2] of INT16;
     aPhi:      INT16;
     bValid:    UINT32; // is this unit in use at this time?
                        // BOOL implemented as UINT32 - for structure alignment at paragraph boundary
  end;

  cbHOOP = record
    valid:   UINT16; // 0=undefined, 1 for valid
    time:    INT16;  // time offset into spike window
    min:     INT16;   // minimum value for the hoop window
    max:     INT16;   // maximum value for the hoop window
  end;




// Analog Input (AINP) Information Packets

type
  ChanInfo_Union = record
    case integer of
      1:(   monsource:     UINT32;      // address of channel to monitor
            outvalue:      INT32;       // output value
        );
      2:(   lowsamples:    UINT16;     // address of channel to monitor
            highsamples:   UINT16;     // address of channel to monitor
            offset:        INT32;      // output value
        );
  end;

  cbPKT_CHANINFO = record
       time:   UINT32;           // system clock timestamp
       chid:   UINT16;           // 0x8000
       type1:  UINT8;           // cbPKTTYPE_AINP*
       dlen:   UINT8;           // cbPKT_DLENCHANINFO

       chan:         UINT32;           // actual channel id of the channel being configured
       proc:         UINT32;           // the address of the processor on which the channel resides
       bank:         UINT32;           // the address of the bank on which the channel resides
       term:         UINT32;           // the terminal number of the channel within it's bank
       chancaps:     UINT32;       // general channel capablities (given by cbCHAN_* flags)
       doutcaps:     UINT32;       // digital output capablities (composed of cbDOUT_* flags)
       dinpcaps:     UINT32;       // digital input capablities (composed of cbDINP_* flags)
       aoutcaps:     UINT32;       // analog output capablities (composed of cbAOUT_* flags)
       ainpcaps:     UINT32;       // analog input capablities (composed of cbAINP_* flags)
       spkcaps:      UINT32;        // spike processing capabilities
       physcalin:    cbSCALING;      // physical channel scaling information
       phyfiltin:    cbFILTDESC;      // physical channel filter definition
       physcalout:   cbSCALING;     // physical channel scaling information
       phyfiltout:   cbFILTDESC;     // physical channel filter definition
       label1:       array[0..cbLEN_STR_LABEL-1] of AnsiChar;   // Label of the channel (null terminated if <16 characters)
       userflags:    UINT32;      // User flags for the channel state
       position:     array[0..3] of INT32;    // reserved for future position information
       scalin:       cbSCALING;         // user-defined scaling information for AINP
       scalout:      cbSCALING;        // user-defined scaling information for AOUT
       doutopts:     UINT32;       // digital output options (composed of cbDOUT_* flags)
       dinpopts:     UINT32;       // digital input options (composed of cbDINP_* flags)
       aoutopts:     UINT32;       // analog output options
       eopchar:      UINT32;        // digital input capablities (given by cbDINP_* flags)

       union :       ChanInfo_Union;

       trigtype:     UINT8;		// trigger type (see cbDOUT_TRIGGER_*)
       trigchan:     UINT16;		// trigger channel
       trigval:      UINT16;		// trigger value
       ainpopts:     UINT32;       // analog input options (composed of cbAINP* flags)   ²
       lncrate:      UINT32;          // line noise cancellation filter adaptation rate
       smpfilter:    UINT32;        // continuous-time pathway filter id
       smpgroup:     UINT32;         // continuous-time pathway sample group
       smpdispmin:   INT32;       // continuous-time pathway display factor
       smpdispmax:   INT32;       // continuous-time pathway display factor
       spkfilter:    UINT32;        // spike pathway filter id
       spkdispmax:   INT32;       // spike pathway display factor
       lncdispmax:   INT32;       // Line Noise pathway display factor
       spkopts:      UINT32;          // spike processing options
       spkthrlevel:  INT32;      // spike threshold level
       spkthrlimit:  INT32;      //
       spkgroup:     UINT32;         // NTrodeGroup this electrode belongs to - 0 is single unit, non-0 indicates a multi-trode grouping
       amplrejpos:   INT16;       // Amplitude rejection positive value
       amplrejneg:   INT16;       // Amplitude rejection negative value
       refelecchan:  UINT32;      // Software reference electrode channel
       unitmapping:  array[0..cbMAXUNITS] of cbMANUALUNITMAPPING;            // manual unit mapping
       spkhoops:     array[0..cbMAXUNITS,0..cbMAXHOOPS] of  cbHOOP;   // spike hoop sorting set
  end;

Const
  cbPKTTYPE_CHANREP                 =  $40;
  cbPKTTYPE_CHANREPLABEL            =  $41;
  cbPKTTYPE_CHANREPSCALE            =  $42;
  cbPKTTYPE_CHANREPDOUT             =  $43;
  cbPKTTYPE_CHANREPDINP             =  $44;
  cbPKTTYPE_CHANREPAOUT             =  $45;
  cbPKTTYPE_CHANREPDISP             =  $46;
  cbPKTTYPE_CHANREPAINP             =  $47;
  cbPKTTYPE_CHANREPSMP              =  $48;
  cbPKTTYPE_CHANREPSPK              =  $49;
  cbPKTTYPE_CHANREPSPKTHR           =  $4A;
  cbPKTTYPE_CHANREPSPKHPS           =  $4B;
  cbPKTTYPE_CHANREPUNITOVERRIDES    =  $4C;
  cbPKTTYPE_CHANREPNTRODEGROUP      =  $4D;
  cbPKTTYPE_CHANREPREJECTAMPLITUDE  =  $4E;
  cbPKTTYPE_CHANREPAUTOTHRESHOLD    =  $4F;
  cbPKTTYPE_CHANSET                 =  $C0;
  cbPKTTYPE_CHANSETLABEL            =  $C1;
  cbPKTTYPE_CHANSETSCALE            =  $C2;
  cbPKTTYPE_CHANSETDOUT             =  $C3;
  cbPKTTYPE_CHANSETDINP             =  $C4;
  cbPKTTYPE_CHANSETAOUT             =  $C5;
  cbPKTTYPE_CHANSETDISP             =  $C6;
  cbPKTTYPE_CHANSETAINP             =  $C7;
  cbPKTTYPE_CHANSETSMP              =  $C8;
  cbPKTTYPE_CHANSETSPK              =  $C9;
  cbPKTTYPE_CHANSETSPKTHR           =  $CA;
  cbPKTTYPE_CHANSETSPKHPS           =  $CB;
  cbPKTTYPE_CHANSETUNITOVERRIDES    =  $CC;
  cbPKTTYPE_CHANSETNTRODEGROUP      =  $CD;
  cbPKTTYPE_CHANSETREJECTAMPLITUDE  =  $CE;
  cbPKTTYPE_CHANSETAUTOTHRESHOLD    =  $CF;
  cbPKTDLEN_CHANINFO                = ((sizeof(cbPKT_CHANINFO)/4) - cbPKT_HEADER_32SIZE);
  cbPKTDLEN_CHANINFOSHORT           = (cbPKTDLEN_CHANINFO - ((sizeof(cbHOOP)*cbMAXUNITS*cbMAXHOOPS)/4));

type
// Latest CCF structure
  cbCCF = record
    dumdumdum:integer;   // A compléter si nécessaire
  end;

// CCF processing state
  cbStateCCF =
  (
    CCFSTATE_READ = 0,     // Reading in progress
    CCFSTATE_WRITE,        // Writing in progress
    CCFSTATE_SEND ,        // Sendign in progress
    CCFSTATE_CONVERT,      // Conversion in progress
    CCFSTATE_THREADREAD,   // Total threaded read progress
    CCFSTATE_THREADWRITE,  // Total threaded write progress
    CCFSTATE_UNKNOWN // (Always the last) unknown state
  );

Const
  cbPKT_SPKCACHEPKTCNT = 400;
  cbPKT_SPKCACHELINECNT = cbNUM_ANALOG_CHANS;

type
  cbSPKCACHE = record
    chid: UINT32;            // ID of the Channel
    pktcnt: UINT32;          // # of packets which can be saved
    pktsize: UINT32;         // Size of an individual packet
    head: UINT32;            // Where (0 based index) in the circular buffer to place the NEXT packet.
    valid: UINT32;           // How many packets have come in since the last configuration
    spkpkt: array [0..cbPKT_SPKCACHEPKTCNT-1] of cbPKT_SPK;     // Circular buffer of the cached spikes
  end;

  cbSPKBUFF= record
    flags: UINT32;
    chidmax: UINT32;
    linesize: UINT32;
    spkcount: UINT32 ;
    cache: array[0..cbPKT_SPKCACHELINECNT-1] of cbSPKCACHE;
  end;


//********************************************* cbsdk.h *************************************************

type
  //Library version information.

  cbSdkVersion =
    record
      // Library version
       major: UINT32;
       minor: UINT32;
       release: UINT32;
       beta: UINT32;
      // Protocol version
       majorp: UINT32;
       minorp: UINT32;
      // NSP version
       nspmajor: UINT32;
       nspminor: UINT32;
       nsprelease: UINT32;
       nspbeta: UINT32;
    end;

// cbSdk return values
  cbSdkResult = integer;
const
    CBSDKRESULT_WARNCONVERT            =     3; ///< If file conversion is needed
    CBSDKRESULT_WARNCLOSED             =     2; ///< Library is already closed
    CBSDKRESULT_WARNOPEN               =     1; ///< Library is already opened
    CBSDKRESULT_SUCCESS                =     0; ///< Successful operation
    CBSDKRESULT_NOTIMPLEMENTED         =    -1; ///< Not implemented
    CBSDKRESULT_UNKNOWN                =    -2; ///< Unknown error
    CBSDKRESULT_INVALIDPARAM           =    -3; ///< Invalid parameter
    CBSDKRESULT_CLOSED                 =    -4; ///< Interface is closed cannot do this operation
    CBSDKRESULT_OPEN                   =    -5; ///< Interface is open cannot do this operation
    CBSDKRESULT_NULLPTR                =    -6; ///< Null pointer
    CBSDKRESULT_ERROPENCENTRAL         =    -7; ///< Unable to open Central interface
    CBSDKRESULT_ERROPENUDP             =    -8; ///< Unable to open UDP interface (might happen if default)
    CBSDKRESULT_ERROPENUDPPORT         =    -9; ///< Unable to open UDP port
    CBSDKRESULT_ERRMEMORYTRIAL         =   -10; ///< Unable to allocate RAM for trial cache data
    CBSDKRESULT_ERROPENUDPTHREAD       =   -11; ///< Unable to open UDP timer thread
    CBSDKRESULT_ERROPENCENTRALTHREAD   =   -12; ///< Unable to open Central communication thread
    CBSDKRESULT_INVALIDCHANNEL         =   -13; ///< Invalid channel number
    CBSDKRESULT_INVALIDCOMMENT         =   -14; ///< Comment too long or invalid
    CBSDKRESULT_INVALIDFILENAME        =   -15; ///< Filename too long or invalid
    CBSDKRESULT_INVALIDCALLBACKTYPE    =   -16; ///< Invalid callback type
    CBSDKRESULT_CALLBACKREGFAILED      =   -17; ///< Callback register/unregister failed
    CBSDKRESULT_ERRCONFIG              =   -18; ///< Trying to run an unconfigured method
    CBSDKRESULT_INVALIDTRACKABLE       =   -19; ///< Invalid trackable id; or trackable not present
    CBSDKRESULT_INVALIDVIDEOSRC        =   -20; ///< Invalid video source id; or video source not present
    CBSDKRESULT_ERROPENFILE            =   -21; ///< Cannot open file
    CBSDKRESULT_ERRFORMATFILE          =   -22; ///< Wrong file format
    CBSDKRESULT_OPTERRUDP              =   -23; ///< Socket option error (possibly permission issue)
    CBSDKRESULT_MEMERRUDP              =   -24; ///< Socket memory assignment error
    CBSDKRESULT_INVALIDINST            =   -25; ///< Invalid range or instrument address
    CBSDKRESULT_ERRMEMORY              =   -26; ///< library memory allocation error
    CBSDKRESULT_ERRINIT                =   -27; ///< Library initialization error
    CBSDKRESULT_TIMEOUT                =   -28; ///< Conection timeout error
    CBSDKRESULT_BUSY                   =   -29; ///< Resource is busy
    CBSDKRESULT_ERROFFLINE             =   -30; ///< Instrument is offline

type
// cbSdk Connection Type (Central, UDP, other)
  cbSdkConnectionType=
  (
    CBSDKCONNECTION_DEFAULT, ///< Try Central then UDP
    CBSDKCONNECTION_CENTRAL,     ///< Use Central
    CBSDKCONNECTION_UDP,         ///< Use UDP
    CBSDKCONNECTION_CLOSED,      ///< Closed
    CBSDKCONNECTION_COUNT ///< Allways the last value (Unknown)
  );

// Instrument Type
  cbSdkInstrumentType =
  (
    CBSDKINSTRUMENT_NSP,       ///< NSP
    CBSDKINSTRUMENT_NPLAY,         ///< Local nPlay
    CBSDKINSTRUMENT_LOCALNSP,      ///< Local NSP
    CBSDKINSTRUMENT_REMOTENPLAY,   ///< Remote nPlay
    CBSDKINSTRUMENT_COUNT ///< Allways the last value (Invalid)
  );

/// CCF operation progress and status
  cbSdkCCFEvent = record
    state : cbStateCCF;           ///< CCF state
    result: cbSdkResult;          ///< Last result
    szFileName: PansiChar;        ///< CCF filename under operation
    progress: UINT8;              ///< Progress (in percent)
  end;

/// Reason for packet loss
  cbSdkPktLostEventType =
  (
    CBSDKPKTLOSTEVENT_UNKNOWN = 0,       ///< Unknown packet lost
    CBSDKPKTLOSTEVENT_LINKFAILURE,       ///< Link failure
    CBSDKPKTLOSTEVENT_PC2NSP,            ///< PC to NSP connection lost
    CBSDKPKTLOSTEVENT_NET                ///< Network error
  );

/// Packet lost event
  cbSdkPktLostEvent =
  record
    type1: cbSdkPktLostEventType;        ///< packet lost event type
  end;

/// Instrument information
  cbSdkInstInfo = record
    instInfo: UINT32;     ///< bitfield of cbINSTINFO_* (0 means closed)
  end;

/// Packet type information
  cbSdkPktType=
  (
    cbSdkPkt_PACKETLOST = 0, ///< will be received only by the first registered callback
                             ///< data points to cbSdkPktLostEvent
    cbSdkPkt_INSTINFO,       ///< data points to cbSdkInstInfo
    cbSdkPkt_SPIKE,          ///< data points to cbPKT_SPK
    cbSdkPkt_DIGITAL,        ///< data points to cbPKT_DINP
    cbSdkPkt_SERIAL,         ///< data points to cbPKT_DINP
    cbSdkPkt_CONTINUOUS,     ///< data points to cbPKT_GROUP
    cbSdkPkt_TRACKING,       ///< data points to cbPKT_VIDEOTRACK
    cbSdkPkt_COMMENT,        ///< data points to cbPKT_COMMENT
    cbSdkPkt_GROUPINFO,      ///< data points to cbPKT_GROUPINFO
    cbSdkPkt_CHANINFO,       ///< data points to cbPKT_CHANINFO
    cbSdkPkt_FILECFG,        ///< data points to cbPKT_FILECFG
    cbSdkPkt_POLL,           ///< data points to cbPKT_POLL
    cbSdkPkt_SYNCH,          ///< data points to cbPKT_VIDEOSYNCH
    cbSdkPkt_NM,             ///< data points to cbPKT_NM
    cbSdkPkt_CCF,            ///< data points to cbSdkCCFEvent
    cbSdkPkt_IMPEDANCE,      ///< data points to cbPKT_IMPEDANCE
    cbSdkPkt_SYSHEARTBEAT,   ///< data points to cbPKT_SYSHEARTBEAT
    cbSdkPkt_LOG,		     ///< data points to cbPKT_LOG
    cbSdkPkt_COUNT ///< Always the last value
  );

/// Type of events to monitor
  cbSdkCallbackType =
  (
    CBSDKCALLBACK_ALL = 0,      ///< Monitor all events
    CBSDKCALLBACK_INSTINFO,     ///< Monitor instrument connection information
    CBSDKCALLBACK_SPIKE,        ///< Monitor spike events
    CBSDKCALLBACK_DIGITAL,      ///< Monitor digital input events
    CBSDKCALLBACK_SERIAL,       ///< Monitor serial input events
    CBSDKCALLBACK_CONTINUOUS,   ///< Monitor continuous events
    CBSDKCALLBACK_TRACKING,     ///< Monitor video tracking events
    CBSDKCALLBACK_COMMENT,      ///< Monitor comment or custom events
    CBSDKCALLBACK_GROUPINFO,    ///< Monitor channel group info events
    CBSDKCALLBACK_CHANINFO,     ///< Monitor channel info events
    CBSDKCALLBACK_FILECFG,      ///< Monitor file config events
    CBSDKCALLBACK_POLL,         ///< respond to poll
    CBSDKCALLBACK_SYNCH,        ///< Monitor video synchronizarion events
    CBSDKCALLBACK_NM,           ///< Monitor NeuroMotive events
    CBSDKCALLBACK_CCF,          ///< Monitor CCF events
    CBSDKCALLBACK_IMPEDENCE,    ///< Monitor impedence events
    CBSDKCALLBACK_SYSHEARTBEAT, ///< Monitor system heartbeats (100 times a second)
    CBSDKCALLBACK_LOG,		    ///< Monitor system heartbeats (100 times a second)
    CBSDKCALLBACK_COUNT  ///< Always the last value
  );

/// Trial type
  cbSdkTrialType =
  (
    CBSDKTRIAL_CONTINUOUS,
    CBSDKTRIAL_EVENTS,
    CBSDKTRIAL_COMMETNS,
    CBSDKTRIAL_TRACKING
  );

// Callback details.
// pEventData points to a cbPkt_* structure depending on the type
// pCallbackData is what is used to register the callback

  cbSdkCallback = procedure (nInstance: UINT32; var type1: cbSdkPktType; pEventData:pointer; pCallbackData:pointer);cdecl;


Const
/// The default number of continuous samples that will be stored per channel in the trial buffer
  cbSdk_CONTINUOUS_DATA_SAMPLES =102400; // multiple of 4096
/// The default number of events that will be stored per channel in the trial buffer
  cbSdk_EVENT_DATA_SAMPLES = 2 * 8192; // multiple of 4096

/// Maximum file size (in bytes) that is allowed to upload to NSP
  cbSdk_MAX_UPOLOAD_SIZE = 1024 * 1024 * 1024;

/// \todo these should become functions as we may introduce different instruments
  cbSdk_TICKS_PER_SECOND = 30000.0;
/// The number of seconds corresponding to one cb clock tick
  cbSdk_SECONDS_PER_TICK = (1.0 / cbSdk_TICKS_PER_SECOND);

type
/// Trial spike events
  cbSdkTrialEvent =
  record
    count: UINT16; ///< Number of valid channels in this trial (up to cbNUM_ANALOG_CHANS+2)
    chan: array[0..cbNUM_ANALOG_CHANS + 1] of UINT16; ///< channel numbers (1-based)
    num_samples: array[0..cbNUM_ANALOG_CHANS + 1,0..cbMAXUNITS ] of UINT32; ///< number of samples
    timestamps:array[0..cbNUM_ANALOG_CHANS + 1,0..cbMAXUNITS] of pointer;   ///< Buffer to hold time stamps
    waveforms: array[0..cbNUM_ANALOG_CHANS + 1] of pointer; ///< Buffer to hold waveforms or digital values
  end;

/// Connection information
  cbSdkConnection =
  record
    nInPort: integer;     ///< Client port number
    nOutPort: integer;    ///< Instrument port number
    nRecBufSize: integer; ///< Receive buffer size (0 to ignore altogether)
    szInIP: PansiChar;    ///< Client IPv4 address
    szOutIP: PansiChar;   ///< Instrument IPv4 address
  end;

  procedure InitcbSdkConnection( var w:cbSdkConnection) ;
    {
        nInPort = cbNET_UDP_PORT_BCAST;
        nOutPort = cbNET_UDP_PORT_CNT;
        nRecBufSize = (4096 * 2048); // 8MB default needed for best performance
        szInIP = "";
        szOutIP = "";
    }
type
/// Trial continuous data
  cbSdkTrialCont =
  record
    count: UINT16; ///< Number of valid channels in this trial (up to cbNUM_ANALOG_CHANS)
    chan: array[0..cbNUM_ANALOG_CHANS-1] of UINT16;        ///< Channel numbers (1-based)
    sample_rates:array[0..cbNUM_ANALOG_CHANS-1] of UINT16; ///< Current sample rate (samples per second)
    num_samples: array[0..cbNUM_ANALOG_CHANS-1] of UINT32;                ///< Number of samples
    time: UINT32;                                          ///< Start time for trial continuous data
    samples: array[0..cbNUM_ANALOG_CHANS-1] of pointer;    ///< Buffer to hold sample vectors
  end;

/// Trial comment data
  cbSdkTrialComment= record

    num_samples: UINT16; ///< Number of comments
    charsets: PUINT8;    ///< Buffer to hold character sets
    rgbas: PUINT32;      ///< Buffer to hold rgba values
    comments:pointer;    ///< Pointer to comments
    timestamps:pointer;  ///< Buffer to hold time stamps
  end;

/// Trial video tracking data
  cbSdkTrialTracking = record
    count: UINT16;						    ///< Number of valid trackable objects (up to cbMAXTRACKOBJ)
    ids:array[0..cbMAXTRACKOBJ-1] of UINT16;					///< Node IDs (holds count elements)
    max_point_counts: array[0..cbMAXTRACKOBJ-1] of UINT16;	    ///< Maximum point counts (holds count elements)
    types: array[0..cbMAXTRACKOBJ-1] of UINT16;			    ///< Node types (can be cbTRACKOBJ_TYPE_* and determines coordinate counts) (holds count elements)
    names: array[0..cbMAXTRACKOBJ-1,0..cbLEN_STR_LABEL] of UINT8;   ///< Node names (holds count elements)
    num_samples: array[0..cbMAXTRACKOBJ-1] of UINT16 ;			///< Number of samples
    point_counts: array[0..cbMAXTRACKOBJ-1] of PUINT16;		    ///< Buffer to hold number of valid points (up to max_point_counts) (holds count*num_samples elements)
    coords: array[0..cbMAXTRACKOBJ-1] of pointer ;			///< Buffer to hold tracking points (holds count*num_samples tarackables, each of max_point_counts points
    synch_frame_numbers:array[0..cbMAXTRACKOBJ-1] of PUINT32;       ///< Buffer to hold synch frame numbers (holds count*num_samples elements)
    synch_timestamps:array[0..cbMAXTRACKOBJ-1] of PUINT32;          ///< Buffer to hold synchronized tracking time stamps (in milliseconds) (holds count*num_samples elements)
    timestamps: array[0..cbMAXTRACKOBJ-1] of pointer;               ///< Buffer to hold tracking time stamps (holds count*num_samples elements)
  end;

/// Output waveform type
  cbSdkWaveformType =
  (
    cbSdkWaveform_NONE = 0,
    cbSdkWaveform_PARAMETERS,     ///< Parameters
    cbSdkWaveform_SINE,           ///< Sinusoid
    cbSdkWaveform_COUNT           ///< Always the last value
  );

/// Trigger type
  cbSdkWaveformTriggerType =
  (
    cbSdkWaveformTrigger_NONE = 0, ///< Instant software trigger
    cbSdkWaveformTrigger_DINPREG,      ///< Digital input rising edge trigger
    cbSdkWaveformTrigger_DINPFEG,      ///< Digital input falling edge trigger
    cbSdkWaveformTrigger_SPIKEUNIT,    ///< Spike unit
    cbSdkWaveformTrigger_COMMENTCOLOR, ///< Custom colored event (e.g. NeuroMotive event)
    cbSdkWaveformTrigger_SOFTRESET,    ///< Soft-reset trigger (e.g. file recording start)
    cbSdkWaveformTrigger_EXTENSION,    ///< Extension trigger
    cbSdkWaveformTrigger_COUNT ///< Always the last value
  );

/// Extended pointer-form of cbWaveformData
  cbSdkWaveformData = record
    type1: cbSdkWaveformType;
    repeats: UINT32;
    trig: cbSdkWaveformTriggerType;
    trigChan: UINT16;
    trigValue: UINT16;
    trigNum: UINT8;
    offset: INT16;
    case integer of
    1:(   sineFrequency: UINT16;
          sineAmplitude:  INT16;
      );
    2:(   phases: UINT16;
          duration: PUINT16;
          amplitude: PINT16;
      );
  end;

/// Analog output monitor
  cbSdkAoutMon = record
    chan: UINT16; ///< (1-based) channel to monitor
    bTrack: BOOL; ///< If should monitor last tracked channel
    bSpike: BOOL; ///< If spike or continuous should be monitored
  end;

/// CCF data
  cbSdkCCF = record
    ccfver: integer; ///< CCF internal version
    data: cbCCF;
  end;

  cbSdkSystemType = (
    cbSdkSystem_RESET = 0,
    cbSdkSystem_SHUTDOWN,
    cbSdkSystem_STANDBY
  );

/// Extension command type
  cbSdkExtCmdType =
  (
    cbSdkExtCmd_RPC = 0,    // RPC command
    cbSdkExtCmd_UPLOAD,     // Upload the file
    cbSdkExtCmd_TERMINATE,  // Signal last RPC command to terminate
    cbSdkExtCmd_INPUT,		// Input to RPC command
    cbSdkExtCmd_END_PLUGIN, // Signal to end plugin
    cbSdkExtCmd_NSP_REBOOT // Restart the NSP
  );

Const
  cbMAX_LOG = 128;

type
/// Extension command
  cbSdkExtCmd = record
    cmd: cbSdkExtCmdType;
    szCmd: array[0..cbMAX_LOG-1] of AnsiChar;
  end;

Var
// Can call this even with closed library to get library information
// Get the library version (and nsp version if library is open)

     cbSdkGetVersion: function( nInstance:UINT32; var version: cbSdkVersion):cbSdkResult;cdecl;

// Read configuration file. */
     cbSdkReadCCF: function( nInstance: UINT32;var data: cbSdkCCF; szFileName: Pansichar; bConvert: bool; bSend:bool; bThreaded:bool): cbSdkResult;cdecl;
     // Read batch config from CCF (or nsp if filename is null)
// Write configuration file. */
     cbSdkWriteCCF: function( nInstance: UINT32;var data: cbSdkCCF; szFileName: PansiChar; bThreaded:bool):cbSdkResult;cdecl;
    // Write batch config to CCF (or nsp if filename is null)

// Open the library */
    cbSdkOpen: function(nInstance:UINT32; conType:cbSdkConnectionType ; con: cbSdkConnection):cbSdkResult;cdecl;

    cbSdkGetType: function(nInstance: UINT32; var conType: cbSdkConnectionType; var instType: cbSdkInstrumentType ):cbSdkResult;cdecl;
     // Get connection and instrument type

// Close the library */
     cbSdkClose: function(nInstance: UINT32):cbSdkResult;cdecl;

// Get the instrument sample clock time */
     cbSdkGetTime: function(nInstance: UINT32;var cbTime: UINT32):cbSdkResult;cdecl;

// Get direct access to internal spike cache shared memory */
     cbSdkGetSpkCache: function(nInstance: UINT32;  channel: UINT16; var cache: cbSPKCACHE):cbSdkResult;cdecl;
// Note that spike cache is volatile, thus should not be used for critical operations such as recording

// Get trial setup configuration */
    cbSdkGetTrialConfig: function(nInstance: UINT32;
                                  var pbActive: UINT32; var pBegchan: UINT16; var pBegmask: UINT32; var pBegval:UINT32;
                                  var  pEndchan: UINT16;var pEndmask: UINT32; var pEndval:UINT32;var  pbDouble: bool;
                                  var puWaveforms:UINT32;var puConts: UINT32; var  puEvents: UINT32 ;
                                  var puComments:UINT32 ; var puTrackings:UINT32 ; var pbAbsolute:bool ): cbSdkResult;cdecl;
// Setup a trial */
    cbSdkSetTrialConfig: function(nInstance: UINT32;
                                  bActive: UINT32; Begchan: UINT16; Begmask: UINT32; pBegval:UINT32;
                                  Endchan: UINT16; Endmask: UINT32; Endval:UINT32; pbDouble: bool;
                                  uWaveforms:UINT32; uConts: UINT32;  uEvents: UINT32 ;
                                  uComments:UINT32 ; uTrackings:UINT32 ;  bAbsolute:bool ): cbSdkResult;cdecl;

// begchan - first channel number (1-based), zero means all
// endchan - last channel number (1-based), zero means all

// Close given trial if configured */
   cbSdkUnsetTrialConfig: function(nInstance: UINT32;  type1:cbSdkTrialType): cbSdkResult;cdecl;

// Get channel label */
// Pass NULL or allocate bValid[6] label[cbLEN_STR_LABEL] position[4]
    cbSdkGetChannelLabel: function(nInstance: UINT32;  channel:UINT16; var bValid:UINT32; label1:PansiChar; var userflags:UINT32; var position:INT32): cbSdkResult;cdecl; // Get channel label
// Set channel label */
    cbSdkSetChannelLabel: function(nInstance: UINT32;  channel:UINT16; label1:PansiChar;  userflags:UINT32;  var position:INT32): cbSdkResult;cdecl; // Set channel label

// Retrieve data of a trial (NULL means ignore), user should allocate enough buffers beforehand; and trial should not be closed during this call */
    cbSdkGetTrialData: function(nInstance: UINT32;
                                 bActive:UINT32; var trialevent:cbSdkTrialEvent; var trialcont:cbSdkTrialCont;
                                 trialcomment:cbSdkTrialComment; trialtracking:cbSdkTrialTracking): cbSdkResult;cdecl;

// Initialize the structures (and fill with information about active channels; comment pointers and samples in the buffer) */
    cbSdkInitTrialData: function(nInstance: UINT32;  bActive:UINT32;
                                            var trialevent:cbSdkTrialEvent;  var trialcont:cbSdkTrialCont;
                                            var trialcomment:cbSdkTrialComment; var trialtracking:cbSdkTrialTracking): cbSdkResult;cdecl;

// Start/stop/open/close file recording */
    cbSdkSetFileConfig: function(nInstance: UINT32; filename: PansiChar; comment: PansiChar;  bStart:UINT32;  options:UINT32): cbSdkResult;cdecl;

// Get the state of file recording */
    cbSdkGetFileConfig: function(nInstance: UINT32; filename:Pansichar; username: PansiChar;  var pbRecording:bool): cbSdkResult;cdecl;

    cbSdkSetPatientInfo: function(nInstance: UINT32;  ID: PansiChar; firstname:PansiChar; lastname:PansiChar;  DOBMonth:UINT32;  DOBDay:UINT32;  DOBYear:UINT32): cbSdkResult;cdecl;

    cbSdkInitiateImpedance: function(nInstance: UINT32): cbSdkResult;cdecl;

    cbSdkSendPoll: function(nInstance: UINT32; appname:PansiChar;  mode:UINT32;  flags:UINT32;  extra:UINT32): cbSdkResult;cdecl;

// This sends an arbitrary packet without any validation. Please use with care or it might break the system */
    cbSdkSendPacket: function(nInstance: UINT32;   ppckt: pointer): cbSdkResult;cdecl;

// Get/Set the runlevel of the instrument */
    cbSdkSetSystemRunLevel: function(nInstance: UINT32;  runlevel:UINT32;  locked:UINT32;  resetque:UINT32): cbSdkResult;cdecl;

    cbSdkGetSystemRunLevel: function(nInstance: UINT32;  var runlevel:UINT32;  var runflags:UINT32;  var resetque:UINT32): cbSdkResult;cdecl;

// Send a digital output command */
    cbSdkSetDigitalOutput: function(nInstance: UINT32;  channel:UINT16;  value:UINT16): cbSdkResult;cdecl;

// Send a synch output waveform */
    cbSdkSetSynchOutput: function(nInstance: UINT32;  channel:UINT16;  nFreq:UINT32;  nRepeats:UINT32): cbSdkResult;cdecl;

// Send an extension command */
    cbSdkExtDoCommand: function(nInstance: UINT32; var extCmd:cbSdkExtCmd): cbSdkResult;cdecl;

// Send a analog output waveform or monitor a given channel; disable channel if both are null */
    cbSdkSetAnalogOutput: function(nInstance: UINT32;  channel:UINT16; var wf:cbSdkWaveformData; var mon:cbSdkAoutMon): cbSdkResult;cdecl;

// * Mask channels (for both trial and callback)
// @param[in] channel channel number (1-based); zero means all channels

    cbSdkSetChannelMask: function(nInstance: UINT32;  channel:UINT16;  bActive:UINT32): cbSdkResult;cdecl;

// Send a comment or custom event */
    cbSdkSetComment: function(nInstance: UINT32;  rgba:UINT32;  charset:UINT8; comment: PansiChar): cbSdkResult;cdecl;

// Send a full channel configuration packet */
    cbSdkSetChannelConfig: function(nInstance: UINT32;  channel:UINT16;  var chaninfo:cbPKT_CHANINFO): cbSdkResult;cdecl;
// Get a full channel configuration packet */
    cbSdkGetChannelConfig: function(nInstance: UINT32;  channel:UINT16;  var chaninfo:cbPKT_CHANINFO): cbSdkResult;cdecl;

// Get filter description (proc = 1 for now) */
    cbSdkGetFilterDesc: function(nInstance: UINT32;  proc:UINT32;  filt:UINT32; var filtdesc:cbFILTDESC): cbSdkResult;cdecl;

// Get sample group list (proc = 1 for now) */
    cbSdkGetSampleGroupList: function(nInstance: UINT32;  proc:UINT32;  group:UINT32; var length:UINT32;  var list): cbSdkResult;cdecl;
                                                                                                         // ver 310 :  list: array[] of UINT32
                                                                                                         // ver 311 :  list: array[] of UINT16
    cbSdkGetSampleGroupInfo: function(nInstance: UINT32;  proc:UINT32;  group:UINT32; label1:PansiChar; var period:UINT32; var length:UINT32): cbSdkResult;cdecl;

//
// Get information about given trackable object
// @param[in] id		trackable ID (1 to cbMAXTRACKOBJ)
// @param[in] name	string of length cbLEN_STR_LABEL
//
    cbSdkGetTrackObj: function(nInstance: UINT32; name: PansiChar; var type1: UINT16; var pointCount:UINT16;  id:UINT32): cbSdkResult;cdecl;

// Get video source information */
// id     video source ID (1 to cbMAXVIDEOSOURCE)
// name   string of length cbLEN_STR_LABEL
    cbSdkGetVideoSource: function(nInstance: UINT32; name: PansiChar; var fps:single;  id:UINT32): cbSdkResult;cdecl;

/// Send global spike configuration
    cbSdkSetSpikeConfig: function(nInstance: UINT32;  spklength:UINT32;  spkpretrig:UINT32): cbSdkResult;cdecl;
/// Get global system configuration
    cbSdkGetSysConfig: function(nInstance: UINT32; var spklength:UINT32; var spkpretrig:UINT32; var sysfreq:UINT32): cbSdkResult;cdecl;
/// Perform given system command
    cbSdkSystem: function(nInstance: UINT32;  cmd:cbSdkSystemType): cbSdkResult;cdecl;

    cbSdkRegisterCallback: function(nInstance: UINT32;  callbacktype:cbSdkCallbackType;  pCallbackFn:cbSdkCallback; pCallbackData:pointer): cbSdkResult;cdecl;
    cbSdkUnRegisterCallback: function(nInstance: UINT32;  callbacktype:cbSdkCallbackType): cbSdkResult;cdecl;
// At most one callback per each callback type per each connection

/// Convert volts string (e.g. '5V'; '-65mV'; ...) to its raw digital value equivalent for given channel
    cbSdkAnalogToDigital: function(nInstance: UINT32;  channel:UINT16; szVoltsUnitString: PansiChar; var digital:INT32): cbSdkResult;cdecl;

var
  CbLibVersion: integer ;


function InitCbSdkDLL(stPath:AnsiString):boolean;
procedure FreeCbSdkdll;
procedure testcbSdk;


implementation



var
  hh:intG;
  DllName:AnsiString;
  

procedure CheckVersion;
var
  Sdkversion: cbSdkVersion;
  res: integer;
begin
  res:=  cbSdkGetVersion( 0, Sdkversion);     // ok mais ne renvoie pas 0
  //if res=0 then
  begin
    CbLibVersion:= sdkVersion.majorp*100+ sdkVersion.minorp;
    //messageCentral('Version = '+Istr(CbLibVersion));
  end;
end;


function InitCbSdkDLL(stPath:AnsiString):boolean;
begin
  if (stPath<>'') and (stPath[length(stPath)]<>'\') then stPath:=stPath+'\';

  {$IFDEF WIN64}
  DLLname:= stPath + 'cbsdkx64.dll';
  {$ELSE}
  DLLname:= stPath + 'cbsdk.dll';
  {$ENDIF}

  result:=true;
  if (hh<>0) then exit;

  hh:=GloadLibrary(DllName);
  result:=(hh<>0);
  if not result then exit;

  (* // Les noms habituels
  cbSdkGetVersion:= getProc(hh,'cbSdkGetVersion');
  cbSdkReadCCF:= getProc(hh,'cbSdkReadCCF');
  cbSdkWriteCCF:= getProc(hh,'cbSdkWriteCCF');
  cbSdkOpen:= getProc(hh,'cbSdkOpen');

  cbSdkGetType:= getProc(hh,'cbSdkGetType');
  cbSdkClose:= getProc(hh,'cbSdkClose');

  cbSdkGetTime:= getProc(hh,'cbSdkGetTime');

  cbSdkGetSpkCache:= getProc(hh,'cbSdkGetSpkCache');
  cbSdkGetTrialConfig:= getProc(hh,'cbSdkGetTrialConfig');
  cbSdkSetTrialConfig:= getProc(hh,'cbSdkSetTrialConfig');
  cbSdkUnsetTrialConfig:= getProc(hh,'cbSdkUnsetTrialConfig');

  cbSdkGetChannelLabel:= getProc(hh,'cbSdkGetChannelLabel');
  cbSdkSetChannelLabel:= getProc(hh,'cbSdkSetChannelLabel');
  cbSdkGetTrialData:= getProc(hh,'cbSdkGetTrialData');
  cbSdkInitTrialData:= getProc(hh,'cbSdkInitTrialData');
  cbSdkSetFileConfig:= getProc(hh,'cbSdkSetFileConfig');
  cbSdkGetFileConfig:= getProc(hh,'cbSdkGetFileConfig');
  cbSdkSetPatientInfo:= getProc(hh,'cbSdkSetPatientInfo');
  cbSdkInitiateImpedance:= getProc(hh,'cbSdkInitiateImpedance');
  cbSdkSendPoll:= getProc(hh,'cbSdkSendPoll');

  cbSdkSendPacket:= getProc(hh,'cbSdkSendPacket');
  cbSdkSetSystemRunLevel:= getProc(hh,'cbSdkSetSystemRunLevel');
  cbSdkGetSystemRunLevel:= getProc(hh,'cbSdkGetSystemRunLevel');
  cbSdkSetDigitalOutput:= getProc(hh,'cbSdkSetDigitalOutput');
  cbSdkSetSynchOutput:= getProc(hh,'cbSdkSetSynchOutput');
  cbSdkExtDoCommand:= getProc(hh,'cbSdkExtDoCommand');
  cbSdkSetAnalogOutput:= getProc(hh,'cbSdkSetAnalogOutput');
  cbSdkSetChannelMask:= getProc(hh,'cbSdkSetChannelMask');
  cbSdkSetComment:= getProc(hh,'cbSdkSetComment');
  cbSdkSetChannelConfig:= getProc(hh,'cbSdkSetChannelConfig');
  cbSdkGetChannelConfig:= getProc(hh,'cbSdkGetChannelConfig');
  cbSdkGetFilterDesc:= getProc(hh,'cbSdkGetFilterDesc');
  cbSdkGetSampleGroupList:= getProc(hh,'cbSdkGetSampleGroupList');
  cbSdkGetSampleGroupInfo:= getProc(hh,'cbSdkGetSampleGroupInfo');
  cbSdkGetTrackObj:= getProc(hh,'cbSdkGetTrackObj');
  cbSdkGetVideoSource:= getProc(hh,'cbSdkGetVideoSource');

  cbSdkSetSpikeConfig:= getProc(hh,'cbSdkSetSpikeConfig');
  cbSdkGetSysConfig:= getProc(hh,'cbSdkGetSysConfig');
  cbSdkSystem:= getProc(hh,'cbSdkSystem');

  cbSdkRegisterCallback:= getProc(hh,'cbSdkRegisterCallback');
  cbSdkUnRegisterCallback:= getProc(hh,'cbSdkUnRegisterCallback');
  cbSdkAnalogToDigital:= getProc(hh,'cbSdkAnalogToDigital');
  *)

    // Les noms décorés . On ne garde que ceux qui sont utilisés dans Elphy
  {$IFNDEF WIN64}
  cbSdkGetVersion:= getProc(hh,'?cbSdkGetVersion@@YA?AW4_cbSdkResult@@IPAU_cbSdkVersion@@@Z');
  CheckVersion;

  //cbSdkReadCCF:= getProc(hh,'cbSdkReadCCF');
  //cbSdkWriteCCF:= getProc(hh,'cbSdkWriteCCF');
  cbSdkOpen:= getProc(hh,'?cbSdkOpen@@YA?AW4_cbSdkResult@@IW4_cbSdkConnectionType@@U_cbSdkConnection@@@Z');

  cbSdkGetType:= getProc(hh,'?cbSdkGetType@@YA?AW4_cbSdkResult@@IPAW4_cbSdkConnectionType@@PAW4_cbSdkInstrumentType@@@Z');
  cbSdkClose:= getProc(hh,'?cbSdkClose@@YA?AW4_cbSdkResult@@I@Z');

  cbSdkGetTime:= getProc(hh,'?cbSdkGetTime@@YA?AW4_cbSdkResult@@IPAI@Z');

  //cbSdkGetSpkCache:= getProc(hh,'cbSdkGetSpkCache');
  //cbSdkGetTrialConfig:= getProc(hh,'cbSdkGetTrialConfig');
  //cbSdkSetTrialConfig:= getProc(hh,'cbSdkSetTrialConfig');
  //cbSdkUnsetTrialConfig:= getProc(hh,'cbSdkUnsetTrialConfig');

  //cbSdkGetChannelLabel:= getProc(hh,'cbSdkGetChannelLabel');
  //cbSdkSetChannelLabel:= getProc(hh,'cbSdkSetChannelLabel');
  //cbSdkGetTrialData:= getProc(hh,'cbSdkGetTrialData');
  //cbSdkInitTrialData:= getProc(hh,'cbSdkInitTrialData');
  //cbSdkSetFileConfig:= getProc(hh,'cbSdkSetFileConfig');
  //cbSdkGetFileConfig:= getProc(hh,'cbSdkGetFileConfig');
  //cbSdkSetPatientInfo:= getProc(hh,'cbSdkSetPatientInfo');
  //cbSdkInitiateImpedance:= getProc(hh,'cbSdkInitiateImpedance');
  //cbSdkSendPoll:= getProc(hh,'cbSdkSendPoll');

  //cbSdkSendPacket:= getProc(hh,'cbSdkSendPacket');
  //cbSdkSetSystemRunLevel:= getProc(hh,'cbSdkSetSystemRunLevel');
  //cbSdkGetSystemRunLevel:= getProc(hh,'cbSdkGetSystemRunLevel');
  cbSdkSetDigitalOutput:= getProc(hh,'?cbSdkSetDigitalOutput@@YA?AW4_cbSdkResult@@IGG@Z');
  cbSdkSetSynchOutput:= getProc(hh,'?cbSdkSetSynchOutput@@YA?AW4_cbSdkResult@@IGII@Z');
  cbSdkExtDoCommand:= getProc(hh,'?cbSdkExtDoCommand@@YA?AW4_cbSdkResult@@IPAU_cbSdkExtCmd@@@Z');
  cbSdkSetAnalogOutput:= getProc(hh,'?cbSdkSetAnalogOutput@@YA?AW4_cbSdkResult@@IGPAU_cbSdkWaveformData@@PAU_cbSdkAoutMon@@@Z');
  cbSdkSetChannelMask:= getProc(hh,'?cbSdkSetChannelMask@@YA?AW4_cbSdkResult@@IGI@Z');
  //cbSdkSetComment:= getProc(hh,'cbSdkSetComment');
  cbSdkSetChannelConfig:= getProc(hh,'?cbSdkSetChannelConfig@@YA?AW4_cbSdkResult@@IGPAUcbPKT_CHANINFO@@@Z');
  cbSdkGetChannelConfig:= getProc(hh,'?cbSdkGetChannelConfig@@YA?AW4_cbSdkResult@@IGPAUcbPKT_CHANINFO@@@Z');
  cbSdkGetFilterDesc:= getProc(hh,'?cbSdkGetFilterDesc@@YA?AW4_cbSdkResult@@IIIPAUcbFILTDESC@@@Z');

  if CbLibVersion=310
    then cbSdkGetSampleGroupList:= getProc(hh,'?cbSdkGetSampleGroupList@@YA?AW4_cbSdkResult@@IIIPAI0@Z')
    else cbSdkGetSampleGroupList:= getProc(hh,'?cbSdkGetSampleGroupList@@YA?AW4_cbSdkResult@@IIIPAIPAG@Z');


  cbSdkGetSampleGroupInfo:= getProc(hh,'?cbSdkGetSampleGroupInfo@@YA?AW4_cbSdkResult@@IIIPADPAI1@Z');
  //cbSdkGetTrackObj:= getProc(hh,'cbSdkGetTrackObj');
  //cbSdkGetVideoSource:= getProc(hh,'cbSdkGetVideoSource');

  cbSdkSetSpikeConfig:= getProc(hh,'?cbSdkSetSpikeConfig@@YA?AW4_cbSdkResult@@III@Z');
  cbSdkGetSysConfig:= getProc(hh,'?cbSdkGetSysConfig@@YA?AW4_cbSdkResult@@IPAI00@Z');
  //cbSdkSystem:= getProc(hh,'cbSdkSystem');

  cbSdkRegisterCallback:= getProc(hh,'?cbSdkRegisterCallback@@YA?AW4_cbSdkResult@@IW4_cbSdkCallbackType@@P6AXIW4_cbSdkPktType@@PBXPAX@Z3@Z');
  cbSdkUnRegisterCallback:= getProc(hh,'?cbSdkUnRegisterCallback@@YA?AW4_cbSdkResult@@IW4_cbSdkCallbackType@@@Z');
  //cbSdkAnalogToDigital:= getProc(hh,'cbSdkAnalogToDigital');

  {$ELSE}

  cbSdkGetVersion:= getProc(hh,'?cbSdkGetVersion@@YA?AW4_cbSdkResult@@IPEAU_cbSdkVersion@@@Z');
  CheckVersion;
  //cbSdkReadCCF:= getProc(hh,'cbSdkReadCCF');
  //cbSdkWriteCCF:= getProc(hh,'cbSdkWriteCCF');
  cbSdkOpen:= getProc(hh,'?cbSdkOpen@@YA?AW4_cbSdkResult@@IW4_cbSdkConnectionType@@U_cbSdkConnection@@@Z');

  cbSdkGetType:= getProc(hh,'?cbSdkGetType@@YA?AW4_cbSdkResult@@IPEAW4_cbSdkConnectionType@@PEAW4_cbSdkInstrumentType@@@Z');
  cbSdkClose:= getProc(hh,'?cbSdkClose@@YA?AW4_cbSdkResult@@I@Z');

  cbSdkGetTime:= getProc(hh,'?cbSdkGetTime@@YA?AW4_cbSdkResult@@IPEAI@Z');

  //cbSdkGetSpkCache:= getProc(hh,'cbSdkGetSpkCache');
  //cbSdkGetTrialConfig:= getProc(hh,'cbSdkGetTrialConfig');
  //cbSdkSetTrialConfig:= getProc(hh,'cbSdkSetTrialConfig');
  //cbSdkUnsetTrialConfig:= getProc(hh,'cbSdkUnsetTrialConfig');

  //cbSdkGetChannelLabel:= getProc(hh,'cbSdkGetChannelLabel');
  //cbSdkSetChannelLabel:= getProc(hh,'cbSdkSetChannelLabel');
  //cbSdkGetTrialData:= getProc(hh,'cbSdkGetTrialData');
  //cbSdkInitTrialData:= getProc(hh,'cbSdkInitTrialData');
  //cbSdkSetFileConfig:= getProc(hh,'cbSdkSetFileConfig');
  //cbSdkGetFileConfig:= getProc(hh,'cbSdkGetFileConfig');
  //cbSdkSetPatientInfo:= getProc(hh,'cbSdkSetPatientInfo');
  //cbSdkInitiateImpedance:= getProc(hh,'cbSdkInitiateImpedance');
  //cbSdkSendPoll:= getProc(hh,'cbSdkSendPoll');

  //cbSdkSendPacket:= getProc(hh,'cbSdkSendPacket');
  //cbSdkSetSystemRunLevel:= getProc(hh,'cbSdkSetSystemRunLevel');
  //cbSdkGetSystemRunLevel:= getProc(hh,'cbSdkGetSystemRunLevel');
  cbSdkSetDigitalOutput:= getProc(hh,'?cbSdkSetDigitalOutput@@YA?AW4_cbSdkResult@@IGG@Z');
  //cbSdkSetSynchOutput:= getProc(hh,'cbSdkSetSynchOutput');
  //cbSdkExtDoCommand:= getProc(hh,'cbSdkExtDoCommand');
  cbSdkSetAnalogOutput:= getProc(hh,'?cbSdkSetAnalogOutput@@YA?AW4_cbSdkResult@@IGPEAU_cbSdkWaveformData@@PEAU_cbSdkAoutMon@@@Z');
  //cbSdkSetChannelMask:= getProc(hh,'cbSdkSetChannelMask');
  //cbSdkSetComment:= getProc(hh,'cbSdkSetComment');
  cbSdkSetChannelConfig:= getProc(hh,'?cbSdkSetChannelConfig@@YA?AW4_cbSdkResult@@IGPEAUcbPKT_CHANINFO@@@Z');
  cbSdkGetChannelConfig:= getProc(hh,'?cbSdkGetChannelConfig@@YA?AW4_cbSdkResult@@IGPEAUcbPKT_CHANINFO@@@Z');
  //cbSdkGetFilterDesc:= getProc(hh,'cbSdkGetFilterDesc');

  if CbLibVersion=310
    then cbSdkGetSampleGroupList:= getProc(hh,'?cbSdkGetSampleGroupList@@YA?AW4_cbSdkResult@@IIIPEAI0@Z')
    else cbSdkGetSampleGroupList:= getProc(hh,'?cbSdkGetSampleGroupList@@YA?AW4_cbSdkResult@@IIIPEAIPEAG@Z');


  cbSdkGetSampleGroupInfo:= getProc(hh,'?cbSdkGetSampleGroupInfo@@YA?AW4_cbSdkResult@@IIIPEADPEAI1@Z');
  //cbSdkGetTrackObj:= getProc(hh,'cbSdkGetTrackObj');
  //cbSdkGetVideoSource:= getProc(hh,'cbSdkGetVideoSource');

  cbSdkSetSpikeConfig:= getProc(hh,'?cbSdkSetSpikeConfig@@YA?AW4_cbSdkResult@@III@Z');
  cbSdkGetSysConfig:= getProc(hh,'?cbSdkGetSysConfig@@YA?AW4_cbSdkResult@@IPEAI00@Z');
  //cbSdkSystem:= getProc(hh,'cbSdkSystem');

  cbSdkRegisterCallback:= getProc(hh,'?cbSdkRegisterCallback@@YA?AW4_cbSdkResult@@IW4_cbSdkCallbackType@@P6AXIW4_cbSdkPktType@@PEBXPEAX@Z3@Z');
  cbSdkUnRegisterCallback:= getProc(hh,'?cbSdkUnRegisterCallback@@YA?AW4_cbSdkResult@@IW4_cbSdkCallbackType@@@Z');
  //cbSdkAnalogToDigital:= getProc(hh,'cbSdkAnalogToDigital');



  {$ENDIF}

end;

procedure FreeCbSdkdll;
begin
  FreeLibrary(hh);
  hh:=0;
end;

procedure InitcbSdkConnection( var w:cbSdkConnection) ;
begin
  w.nInPort := cbNET_UDP_PORT_BCAST;
  w.nOutPort := cbNET_UDP_PORT_CNT;
  w.nRecBufSize := (4096 * 2048); // 8MB default needed for best performance
  w.szInIP := nil;
  w.szOutIP := nil;
end;

var
  SpkCounter: integer;

procedure AcallBack (nInstance: UINT32; var type1: cbSdkPktType; pEventData:pointer; pCallbackData:pointer);cdecl;
begin
  inc(SpkCounter);
end;

procedure testcbSdk;
var
  res: cbSdkResult;
  con: cbSdkConnection;
  conType: cbSdkConnectionType;
  instType: cbSdkInstrumentType;
  chanInfo: cbPKT_CHANINFO;
begin
  messageCentral('sz='+Istr(sizeof(conType))+Istr(sizeof(InstType)));

  if  not InitCbSdkDLL('') then messageCentral('DLL not loaded');

  InitcbSdkConnection(con);
  res := cbSdkOpen(0, CBSDKCONNECTION_DEFAULT, con);
  if res<>CBSDKRESULT_SUCCESS then messageCentral('Error  open');

  res := cbSdkGetType(0, conType, instType);
  if (res = CBSDKRESULT_SUCCESS) then messageCentral('con='+Istr(ord(conType))+'Inst='+Istr(ord(instType)));

  cbSdkGetChannelConfig(0, 1, chaninfo);


  SpkCounter:=0;
  res := cbSdkRegisterCallback(0, CBSDKCALLBACK_SPIKE, ACallback, nil);

  delay(1000);


  res := cbSdkClose(0);
  if res<>CBSDKRESULT_SUCCESS then messageCentral('error close');

  messageCentral('Counter='+Istr(SpkCounter));
end;


end.
