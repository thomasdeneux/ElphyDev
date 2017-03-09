{
  W i n D r i v e r
  =================

  FOR DETAILS ON THE WinDriver FUNCTIONS, PLEASE SEE THE WinDriver MANUAL
  OR INCLUDED HELP FILES.

  This file may not be distributed -- it may only be used for development 
  or evalution purposes (See \WinDriver\docs\license.txt for details).
 
  Web site: http://www.jungo.com
  Email:    support@jungo.com

  Copyright (C) 1999 - 2003 Jungo Ltd.
}

unit WinDrvr;
interface
uses
  Windows, Dialogs, SysUtils;

const
  WD_VER = 602;
  WD_VER_STR = 'WinDriver V6.02 Jungo (c) 1999 - 2003';

type WD_TRANSFER_CMD = DWORD;
const
  CMD_NONE = 0;       { No command }
  CMD_END = 1;        { End command }

  RP_BYTE = 10;       { Read port byte }
  RP_WORD = 11;       { Read port word }
  RP_DWORD = 12;      { Read port dword }
  WP_BYTE = 13;       { Write port byte }
  WP_WORD = 14;       { Write port word }
  WP_DWORD = 15;      { Write port dword }

  RP_SBYTE = 20;      { Read port string byte }
  RP_SWORD = 21;      { Read port string word }
  RP_SDWORD = 22;     { Read port string dword }
  WP_SBYTE = 23;      { Write port string byte }
  WP_SWORD = 24;      { Write port string word }
  WP_SDWORD = 25;     { Write port string dword }

  RM_BYTE = 30;       { Read memory byte }
  RM_WORD = 31;       { Read memory word }
  RM_DWORD = 32;      { Read memory dword }
  WM_BYTE = 33;       { Write memory byte }
  WM_WORD = 34;       { Write memory word }
  WM_DWORD = 35;      { Write memory dword }

  RM_SBYTE = 40;      { Read memory string byte }
  RM_SWORD = 41;      { Read memory string word }
  RM_SDWORD = 42;     { Read memory string dword }
  WM_SBYTE = 43;      { Write memory string byte }
  WM_SWORD = 44;      { Write memory string word }
  WM_SDWORD = 45;     { Write memory string dword }

const
  WD_DMA_PAGES = 256;

  DMA_KERNEL_BUFFER_ALLOC = 1; { the system allocates a contiguous buffer }
                               { the user does not need to supply linear_address }
  DMA_KBUF_BELOW_16M = 2;      { if DMA_KERNEL_BUFFER_ALLOC if used, }
                               { this will make sure it is under 16M }
  DMA_LARGE_BUFFER   = 4;      { if DMA_LARGE_BUFFER if used, }
                               { the maximum number of pages are dwPages, and not }
                               { WD_DMA_PAGES. if you lock a user buffer (not a kernel }
                               { allocated buffer) that is larger than 1MB, then use this }
                               { option, and allocate memory for pages. }
  DMA_ALLOW_CACHE = 8;         { allow caching of the memory for contiguous memory }
                               {  allocation on Windows NT/2k/XP (not recommended!) }

type

  PVOID = Pointer;
  HANDLE = THandle;
  USHORT = Word;

  WD_DMA_PAGE = record
    pPhysicalAddr: PVOID; { physical address of page }
    dwBytes: DWORD { size of page }
  end;

  WD_DMA = record
    hDMA: DWORD; { handle of DMA buffer }
    pUserAddr: PVOID; { beginning of buffer }
    pKernelAddr: DWORD; {  Kernel mapping of kernel allocated buffer }
    dwBytes: DWORD; { size of buffer }
    dwOptions: DWORD; { allocation options: }
    dwPages: DWORD; { number of pages in buffer }
    dwPad1: DWORD; { Reserved for internal use }
    Page: array [0 .. WD_DMA_PAGES - 1] of WD_DMA_PAGE
  end;

  SWD_TRANSFER = record { replaces WD_TRANSFER structure to avoid conflict }
                        { with WD_Transfer() function }
    dwPort: DWORD;   { IO port for transfer or user memory address }
    cmdTrans: DWORD; { Transfer command SWD_TRANSFER_CMD  }
    dwBytes: DWORD;  { For string transfer }
    fAutoInc: DWORD; { Transfer from one port/address or }
                     { use incremental range of addresses   }
    dwOptions: DWORD; { Must be 0 }
    case Integer of
      0: (AByte: BYTE); { Byte transfer }
      1: (AWord: WORD); { Word transfer }
      2: (ADword: DWORD); { Dword transfer }
      3: (pBuffer: PVOID); { String transfer }
      4: (reserved: array[1..8] of byte);
  end;
    PWD_TRANSFER = ^ SWD_TRANSFER;

const
  INTERRUPT_LEVEL_SENSITIVE = 1;
  INTERRUPT_CMD_COPY = 2;

type
  WD_KERNEL_PLUGIN_CALL = record
    hKernelPlugIn: DWORD;
    dwMessage:  DWORD;
    pData: PVOID;
    dwResult: DWORD
  end;

  WD_INTERRUPT = record
    hInterrupt:  DWORD; { handle of interrupt }
    dwOptions: DWORD; { interrupt options: INTERRUPT_CMD_COPY }
    Cmd:  PWD_TRANSFER; { commands to do on interrupt }
    dwCmds: DWORD; { number of commands for WD_IntEnable() }
    kpCall: WD_KERNEL_PLUGIN_CALL; { kernel plugin call }
    fEnableOk:  DWORD; { did WD_IntEnable() succeed }
                       { For WD_IntWait() and WD_IntCount() }
    dwCounter:  DWORD; { number of interrupts received }
    dwLost: DWORD; { number of interrupts not yet dealt with }
    fStopped: DWORD { was interrupt disabled during wait }
  end;

  SWD_VERSION = record  { replaces WD_VERSION structure to avoid conflict }
                        {   with WD_Version() function }
    dwVer: DWORD;
    cVer: array [0 .. 128-1] of CHAR
  end;

const
  LICENSE_DEMO=$1;   LICENSE_WD=$4;
  LICENSE_IO  =$8;   LICENSE_MEM =$10; LICENSE_INT =$20;
  LICENSE_PCI =$40;  LICENSE_DMA =$80; LICENSE_NT  =$100;
  LICENSE_95  =$200; LICENSE_ISAPNP=$400;  LICENSE_PCMCIA=$800;
  LICENSE_PCI_DUMP=$1000; LICENSE_MSG_GEN=$2000; LICENSE_MSG_EDU=$4000;
  LICENSE_MSG_INT=$8000;  LICENSE_KER_PLUG=$10000;
  LICENSE_LINUX   = $20000;     LICENSE_CE      = $80000; 
  LICENSE_VXWORKS = $10000000;  LICENSE_THIS_PC = $100000;
  LICENSE_WIZARD  = $200000;    LICENSE_KD      = $400000;
  LICENSE_SOLARIS = $800000;    LICENSE_CPU0    = $40000;
  LICENSE_CPU1    = $1000000;   LICENSE_CPU2    = $2000000;
  LICENSE_CPU3    = $4000000;   LICENSE_USB     = $8000000;
  LICENSE2_CPCI=$1; LICENSE2_REMOTE=$2;  LICENSE2_USBD=$4; LICENSE2_EVENT=$8;
  LICENSE2_WDLIB=$10;
  
const
    WD_BUS_USB = -2;
    WD_BUS_ISA = 1;
    WD_BUS_EISA = 2;
    WD_BUS_PCI = 5;
    WD_BUS_PCMCIA = 8;

type
  SWD_LICENSE = record  { replaces WD_LICENSE structure to avoid conflict }
                        { with WD_License() function }
  cLicense: array [0 .. 128-1] of CHAR; { buffer with license string to }
                          { put. If empty string then get }
                          { current license setting into  }
                          { dwLicense }
  dwLicense:  DWORD;    { Returns license settings: }
  dwLicense2: DWORD     {   LICENSE_DEMO, LICENSE_WD etc... }
                        { If put license was unsuccessful }
                        { (i.e. invalid license) then dwLicense }
                        { will return 0. }
  end;

type ITEM_TYPE = DWORD;
const
  ITEM_NONE=0; ITEM_INTERRUPT=1; ITEM_MEMORY=2; ITEM_IO=3; ITEM_BUS=5;

type
  WD_ITEM_MEMORY = record
    dwPhysicalAddr: DWORD; { Physical address on card }
    dwMBytes: DWORD; { Address range }
    dwTransAddr: DWORD; { Returns the address to pass }
                        { on to transfer commands }
    dwUserDirectAddr: DWORD; { Returns the address for}
                             { direct user read/write }
    dwCpuPhysicalAddr: DWORD; { returns the CPU physical address of card }
    dwBar: DWORD { Base Address Register number of PCI card }
  end;

  WD_ITEM_IO = record
    dwAddr: DWORD; { Beginning of IO address }
    dwBytes: DWORD; { IO range }
    dwBar: DWORD { Base Address Register number of PCI card }
  end;

  WD_ITEM_INTERRUPT = record
    dwInterrupt: DWORD; { Number of interrupt to }
                        { install }
    dwOptions: DWORD; { Interrupt options: }
                      { INTERRUPT_LEVEL_SENSITIVE   }
    hInterrupt: DWORD { Returns the handle of the }
                      { interrupt installed }
  end;

  WD_BUS = record
    dwBusType: DWORD;    { Bus type: ISA, EISA, PCI, PCMCIA }
    dwBusNum: DWORD;     { Bus number }
    dwSlotFunc: DWORD    { Slot number on Bus }
  end;

  WD_ITEM_VALUE = record
    dw1: DWORD;
    dw2: DWORD;
    dw3: DWORD;
    dw4: DWORD;
    dw5: DWORD;
    dw6: DWORD
  end;

  WD_ITEMS = record
    Item: DWORD; { ITEM_TYPE }
    fNotSharable: DWORD;
    dwContext: DWORD; { Reserved for internal use }
    dwPad1: DWORD;
    case Integer of
      0 { ITEM_MEMORY }:
        (
          Memory: WD_ITEM_MEMORY
        );
      1 { ITEM_IO }:
        (
          IO: WD_ITEM_IO
        );
      2 { ITEM_INTERRUPT }:
        (
          Interrupt: WD_ITEM_INTERRUPT
        );
      3 { ITEM_BUS }:
        (
          Bus: WD_BUS
        );
      4 { ITEM_VALUE }:
        (
          Value: WD_ITEM_VALUE
        )
    end;

  PWD_ITEMS = ^WD_ITEMS;

const
  WD_CARD_ITEMS = 20;

type
  WD_CARD = record
    dwItems: DWORD;
    Item: array [0 .. WD_CARD_ITEMS - 1] of WD_ITEMS
  end;

  PWD_CARD = ^WD_CARD;

  WD_CARD_REGISTER = record
    Card: WD_CARD; { card to register }
    fCheckLockOnly: DWORD   ; { only check if card is lockable, return hCard=1 if OK }
    hCard: DWORD; { handle of card }
    dwOptions: DWORD; { should be zero }
    cName:  array[0 .. 32-1] of CHAR; { name of card }
    cDescription: array [0 .. 100-1] of CHAR { description }
  end;

const
  WD_PCI_CARDS = 100;

type
  WD_PCI_SLOT = record
    dwBus: DWORD;
    dwSlot: DWORD;
    dwFunction: DWORD
  end;

  PWD_PCI_SLOT = ^WD_PCI_SLOT;

  WD_PCI_ID = record
    dwVendorId: DWORD;
    dwDeviceId: DWORD
  end;

  WD_PCI_SCAN_CARDS = record
    searchId: WD_PCI_ID; { if dwVendorId = 0, scan all vendor Ids }
                         { if dwDeviceId = 0, scan all device Ids }
    dwCards: DWORD; { Number of cards found }
    cardId: array [0 .. WD_PCI_CARDS - 1] of WD_PCI_ID;
                     { VendorID & DeviceID of cards found  }
    cardSlot: array [0 .. WD_PCI_CARDS - 1] of WD_PCI_SLOT
                     { PCI slot info of cards found }
  end;

  WD_PCI_CARD_INFO = record
    pciSlot: WD_PCI_SLOT; { PCI slot }
    Card: WD_CARD { Get card parameters for PCI slot }
  end;

type PCI_ACCESS_RESULT = DWORD;
const
  PCI_ACCESS_OK=0; PCI_ACCESS_ERROR=1; PCI_BAD_BUS=2; PCI_BAD_SLOT=3;

type
  WD_PCI_CONFIG_DUMP = record
    pciSlot: WD_PCI_SLOT; { PCI bus, slot and function number }
    pBuffer: PVOID; { buffer for read/write }
    dwOffset: DWORD; { offset in pci configuration space  }
                     { to read/write from }
    dwBytes: DWORD; { bytes to read/write from/to buffer  }
                    { returns the # of bytes read/written }
    fIsRead: DWORD; { if 1 then read pci config, 0 write  }
                    { pci config }
    dwResult: DWORD { PCI_ACCESS_RESULT }
  end;

const
  WD_ISAPNP_CARDS = 16 ;

const
  WD_ISAPNP_COMPATIBLE_IDS = 10 ;

const
  WD_ISAPNP_COMP_ID_LENGTH = 7 ; { ISA compressed ID is 7 chars long }

const
  WD_ISAPNP_ANSI_LENGTH = 32 ; { ISA ANSI ID is limited to 32 chars long }

type
  WD_ISAPNP_COMP_ID = array[0 .. WD_ISAPNP_COMP_ID_LENGTH] of CHAR;
  WD_ISAPNP_ANSI = array[0 .. WD_ISAPNP_ANSI_LENGTH+3] of CHAR; { add 3 bytes for DWORD alignment }

  WD_ISAPNP_CARD_ID = record
    cVendor: WD_ISAPNP_COMP_ID;  { Vendor ID }
    dwSerial: DWORD { Serial number of card }
  end;

  WD_ISAPNP_CARD = record
    cardId:  WD_ISAPNP_CARD_ID; { VendorID & serial number of cards found }
    dcLogicalDevices:  DWORD;   { Logical devices on the card }
    bPnPVersionMajor:  BYTE; { ISA PnP version Major }
    bPnPVersionMinor:  BYTE; { ISA PnP version Minor }
    bVendorVersionMajor:  BYTE; { Vendor version Major }
    bVendorVersionMinor:  BYTE; { Vendor version Minor }
    cIdent:  WD_ISAPNP_ANSI ;{ Device identifier }
  end;

  WD_ISAPNP_SCAN_CARDS = record
    searchId: WD_ISAPNP_CARD_ID; { if searchId.cVendor[0]==0 - scan all vendor IDs
                                   if searchId.dwSerial==0 - scan all serial numbers }
    dwCards:  DWORD; { number of cards found }
    Card: array[0 .. WD_ISAPNP_CARDS-1] of WD_ISAPNP_CARD  { cards found }
  end;


  WD_ISAPNP_CARD_INFO = record
    cardId:  WD_ISAPNP_CARD_ID; { VendorID and serial number of card }
    dwLogicalDevice: DWORD; { logical device in card }
    cLogicalDeviceId:  WD_ISAPNP_COMP_ID; { logical device ID }
    dwCompatibleDevices: DWORD; { number of compatible device IDs }
    CompatibleDevice: array[0 .. WD_ISAPNP_COMPATIBLE_IDS-1] of WD_ISAPNP_COMP_ID; { Compatible device IDs }
    cIdent: WD_ISAPNP_ANSI;  { Device identifier }
    Card: WD_CARD  { get card parameters for the ISA PnP card }
  end;

type ISAPNP_ACCESS_RESULT = DWORD;
const
  ISAPNP_ACCESS_OK = 0; ISAPNP_ACCESS_ERROR = 1; ISAPNP_BAD_ID = 2;

type
  WD_ISAPNP_CONFIG_DUMP = record
    cardId: WD_ISAPNP_CARD_ID;  { VendorID and serial number of card }
    dwOffset: DWORD; { offset in ISA PnP configuration space to read/write from }
    fIsRead: DWORD; { if 1 then read ISA PnP config, 0 write I/A PnP config }
    bData:  BYTE;  { result data of byte read/write }
    dwResult: DWORD { ISAPNP_ACCESS_RESULT }
  end;

{ PCMCIA Card Services }

const
    WD_PCMCIA_CARDS = 8;

const
    WD_PCMCIA_VERSION_LEN = 4;

const
    WD_PCMCIA_MANUFACTURER_LEN = 48;

const
    WD_PCMCIA_PRODUCTNAME_LEN = 48;

const
    WD_PCMCIA_MAX_SOCKET = 2;

const
    WD_PCMCIA_MAX_FUNCTION = 2;

type
  WD_PCMCIA_SLOT = record
    uSocket: BYTE;      {Specifies the socket number (first socket is 0)}
    uFunction: BYTE;    {Specifies the function number (first function is 0)}
    uPadding0: BYTE;    {2 bytes padding so structure will be 4 bytes aligned}
    uPadding1: BYTE
   end;

  WD_PCMCIA_ID = record
    dwManufacturerId: DWORD; {card manufacturer}
    dwCardId: DWORD          {card type and model}
  end;

  WD_PCMCIA_SCAN_CARDS = record
   searchId: WD_PCMCIA_ID;  {device ID to search for}
   dwCards: DWORD;          {number of cards found}
   cardId: array [0..WD_PCMCIA_CARDS-1] of WD_PCMCIA_ID;      {device IDs of cards found}
   cardSlot: array [0..WD_PCMCIA_CARDS-1] of WD_PCMCIA_SLOT  {pcmcia slot info of cards found}
  end;

  WD_PCMCIA_CARD_INFO = record
    pcmciaSlot: WD_PCMCIA_SLOT; {pcmcia slot}
    Card: WD_CARD;              {get card parameters for pcmcia slot}
    cVersion: array [0..WD_PCMCIA_VERSION_LEN-1] of CHAR;
    cManufacturer: array [0..WD_PCMCIA_MANUFACTURER_LEN-1] of CHAR;
    cProductName: array [0..WD_PCMCIA_PRODUCTNAME_LEN-1] of CHAR;
    dwManufacturerId: DWORD;   {card manufacturer}
    dwCardId: DWORD;           {card type and model}
    dwFuncId: DWORD            {card function code}
  end;

  WD_PCMCIA_CONFIG_DUMP = record
    pcmciaSlot: WD_PCMCIA_SLOT;
    pBuffer: PVOID;    {buffer for read/write}
    dwOffset: DWORD;   {offset in pcmcia configuration space to}
                       {read/write from}
    dwBytes: DWORD;    {bytes to read/write from/to buffer}
                       {returns the number of bytes read/wrote}
    fIsRead: DWORD;    {if 1 then read pci config, 0 write pci config}
    dwResult: DWORD   {PCMCIA_ACCESS_RESULT}
   end;

const
  SLEEP_NON_BUSY = 1;

type
  SWD_SLEEP = record    { replaces WD_SLEEP structure to avoid conflict }
                        { with WD_Sleep() function }
    dwMicroSeconds: DWORD; { Sleep time in Micro Seconds (1/1,000,000 Second) }
    dwOptions: DWORD  { can be:
                        SLEEP_NON_BUSY this is accurate only for times above 10000 uSec }
  end;

type DEBUG_LEVEL = DWORD;
const
  D_OFF = 0; D_ERROR=1; D_WARN=2; D_INFO=3; D_TRACE=4;

type  DEBUG_SECTION = DWORD;
const
  S_ALL =$ffffffff;
  S_IO  =$8; S_MEM =$10; S_INT=$20; S_PCI=$40; S_DMA=$80; S_MISC=$100; S_LICENSE=$200;
  S_ISAPNP=$400; S_PCMCIA=$800; S_KER_PLUG=$10000; S_CARD_REG=$2000; 
  S_USB=$8000; S_EVENT=$20000;

type DEBUG_COMMAND = DWORD;
const
  DEBUG_STATUS = 1;
  DEBUG_SET_FILTER = 2;
  DEBUG_SET_BUFFER = 3;
  DEBUG_CLEAR_BUFFER = 4;
  DEBUG_DUMP_SEC_ON = 5;
  DEBUG_DUMP_SEC_OFF = 6;
  KERNEL_DEBUGGER_ON = 7;
  KERNEL_DEBUGGER_OFF = 8;

const
    METHOD_BUFFERED   = 0;
    METHOD_IN_DIRECT  = 1;
    METHOD_OUT_DIRECT = 2;
    METHOD_NEITHER    = 3;

const
    FILE_ANY_ACCESS   = $0;
    FILE_READ_ACCESS  = $1;    { file & pipe }
    FILE_WRITE_ACCESS = $2;    { file & pipe }


type
  SWD_DEBUG = record    { replaces WD_DEBUG structure to avoid conflict }
                        { with WD_Debug() function }
    dwCmd: DWORD;  { DEBUG_COMMAND: DEBUG_STATUS, DEBUG_SET_FILTER, DEBUG_SET_BUFFER,
                     DEBUG_CLEAR_BUFFER, KERNEL_DEBUGGER_ON, KERNEL_DEBUGGER_OFF used
                     for DEBUG_SET_FILTER }
    dwLevel: DWORD;   { DEBUG_LEVEL: D_ERROR, D_WARN..., or D_OFF to turn debugging off }
    dwSection: DWORD; { DEBUG_SECTION: for all sections in driver: S_ALL
                        for partial sections: S_IO, S_MEM... }
    dwLevelMessageBox: DWORD; { DEBUG_LEVEL to print in a message box
                                used for DEBUG_SET_BUFFER }
    dwBufferSize: DWORD { size of buffer in kernel }
  end;

  WD_DEBUG_DUMP = record
    pcBuffer: PCHAR; { buffer to receive debug messages }
    dwSize: DWORD { size of buffer in bytes }
  end;

  WD_KERNEL_PLUGIN = record
    hKernelPlugIn: DWORD;
    pcDriverName: PCHAR;
    pcDriverPath: PCHAR; { if NULL the driver will be searched in the windows system directory  }
    pOpenData: PVOID
  end;

type EVENT_STATUS = DWORD;
const EVENT_STATUS_OK = 0;

type USB_PIPE_TYPE = DWORD;
const
    PIPE_TYPE_CONTROL     = 0;
    PIPE_TYPE_ISOCHRONOUS = 1;
    PIPE_TYPE_BULK        = 2;
    PIPE_TYPE_INTERRUPT   = 3;

{ Old API (until v6.00): }
{ taken from usbdi.h }
type USBD_PIPE_TYPE = DWORD;
const
    UsbdPipeTypeControl     = 0;
    UsbdPipeTypeIsochronous = 1;
    UsbdPipeTypeBulk        = 2;
    UsbdPipeTypeInterrupt   = 3;

var { Pseudo constants }
    IOCTL_WD_USB_RESET_PIPE        : DWORD;
    IOCTL_WD_USB_RESET_DEVICE      : DWORD;
    IOCTL_WD_USB_RESET_DEVICE_EX   : DWORD;
    IOCTL_WD_USB_SCAN_DEVICES      : DWORD;
    IOCTL_WD_USB_TRANSFER          : DWORD;
    IOCTL_WD_USB_DEVICE_REGISTER   : DWORD;
    IOCTL_WD_USB_DEVICE_UNREGISTER : DWORD;
    IOCTL_WD_USB_GET_CONFIGURATION : DWORD;

const
    WD_USB_MAX_PIPE_NUMBER   = 32;
    WD_USB_MAX_ENDPOINTS     = 32;
    WD_USB_MAX_INTERFACES    = 30;
    WD_USB_MAX_DEVICE_NUMBER = 30;

type
    WD_USB_ID = record
        dwVendorId : DWORD;
        dwProductId : DWORD;
end;

    PWD_USB_ID = ^WD_USB_ID;

type WDU_DIR = DWORD;
const
    WDU_DIR_IN     = 1;
    WDU_DIR_OUT    = 2;
    WDU_DIR_IN_OUT = 3;
{ Old API (until v6.00): }
const
    WduDirIn    = 1;
    WduDirOut   = 2;
    WduDirInOot = 3;

type
    WD_USB_PIPE_INFO = record
        dwNumber : DWORD;  {Pipe 0 is the default pipe}
        MaximumPacketSize : DWORD;
        PipeType : DWORD;  { USBD_PIPE_TYPE }
        direction : DWORD; {WDU_DIR
                            Isochronous, Bulk, Interrupt are either WduDirIn
                            or WduDirOut Control are WduDirInOot}
        dwInterval : DWORD {interval in ms relevant to Interrupt pipes}
end;

    PWD_USB_PIPE_INFO = ^WD_USB_PIPE_INFO;

type
    WD_USB_CONFIG_DESC = record
        dwNumInterfaces : DWORD;
        dwValue : DWORD;
        dwAttributes : DWORD;
        MaxPower : DWORD;
end;

    PWD_USB_CONFIG_DESC = ^WD_USB_CONFIG_DESC;

type
    WD_USB_INTERFACE_DESC = record
        dwNumber : DWORD;
        dwAlternateSetting : DWORD;
        dwNumEndpoints : DWORD;
        dwClass : DWORD;
        dwSubClass : DWORD;
        dwProtocol : DWORD;
        dwIndex : DWORD;
end;

    PWD_USB_INTERFACE_DESC = ^WD_USB_INTERFACE_DESC;

type
    WD_USB_ENDPOINT_DESC = record
        dwEndpointAddress : DWORD;
        dwAttributes : DWORD;
        dwMaxPacketSize : DWORD;
        dwInterval : DWORD;
end;

    PWD_USB_ENDPOINT_DESC = ^WD_USB_ENDPOINT_DESC;

type
    WD_USB_INTERFACE = record
        InterfaceDesc : WD_USB_INTERFACE_DESC;
        Endpoints : array[0..WD_USB_MAX_ENDPOINTS-1] of WD_USB_ENDPOINT_DESC;
end;

    PWD_USB_INTERFACE = ^WD_USB_INTERFACE;

type
    WD_USB_CONFIGURATION = record
        uniqueId : DWORD;
        dwConfigurationIndex : DWORD;
        configuration : WD_USB_CONFIG_DESC;
        dwInterfaceAlternatives : DWORD;
        UsbInterface : array[0..WD_USB_MAX_INTERFACES-1] of WD_USB_INTERFACE;
        dwStatus : DWORD;  {Configuration status code - see WD_USB_ERROR_CODES enum definition.
                        WD_USBD_STATUS_SUCCESS for a successful configuration.}
end;

    PWD_USB_CONFIGURATION = ^WD_USB_CONFIGURATION;

type
    WD_USB_HUB_GENERAL_INFO = record
        fBusPowered : DWORD;
        dwPorts : DWORD;              {number of ports on this hub}
        dwCharacteristics : DWORD;    {Hub Characteristics}
        dwPowerOnToPowerGood : DWORD; {port power on till power good in 2ms}
        dwHubControlCurrent : DWORD;  {max current in mA}
end;

    PWD_USB_HUB_GENERAL_INFO = ^WD_USB_HUB_GENERAL_INFO;

const
    WD_SINGLE_INTERFACE = $FFFFFFFF;

type
    WD_USB_DEVICE_GENERAL_INFO = record
        deviceId : WD_USB_ID;
        dwHubNum : DWORD; {Unused}
        dwPortNum : DWORD; {Unused}
        fHub : DWORD; {Unused}
        fFullSpeed : DWORD; {Unused}
        dwConfigurationsNum : DWORD;
        deviceAddress : DWORD; {Unused}
        hubInfo : WD_USB_HUB_GENERAL_INFO;
        deviceClass : DWORD;
        deviceSubClass : DWORD;
        dwInterfaceNum : DWORD; {For a single device WinDriver sets this}
                               {value to WD_SINGLE_INTERFACE}
end;

    PWD_USB_DEVICE_GENERAL_INFO = ^WD_USB_DEVICE_GENERAL_INFO;

type
    WD_USB_DEVICE_INFO = record
        dwPipes : DWORD;
        Pipe : array[0..WD_USB_MAX_PIPE_NUMBER-1] of WD_USB_PIPE_INFO;
end;

    PWD_USB_DEVICE_INFO = ^WD_USB_DEVICE_INFO;

{ IOCTL Structures }
type
    WD_USB_SCAN_DEVICES = record
        searchId : WD_USB_ID;  {if dwVendorId==0 - scan all vendor IDs
                                if dwProductId==0 - scan all product IDs}
        dwDevices : DWORD;
        uniqueId : array[0..WD_USB_MAX_DEVICE_NUMBER-1] of DWORD; { a unique id to identify the device}
        deviceGeneralInfo : array[0..WD_USB_MAX_DEVICE_NUMBER] of WD_USB_DEVICE_GENERAL_INFO;
        dwStatus : DWORD;  {Configuration status code - see WD_USB_ERROR_CODES enum definition.
                        WD_USBD_STATUS_SUCCESS for a successful configuration.}
end;

    PWD_USB_SCAN_DEVICES = ^WD_USB_SCAN_DEVICES;

{ USB TRANSFER options }
const
    USB_TRANSFER_HALT = 1;
    USB_SHORT_TRANSFER = 2;
    USB_FULL_TRANSFER = 4;


{ new USB API definitions:}

type WDU_REGISTER_DEVICES_HANDLE = PVOID;

const
    WDU_ENDPOINT_TYPE_MASK = $3;
    WDU_ENDPOINT_DIRECTION_MASK = $80;
    { test direction bit in the bEndpointAddress field of
      an endpoint descriptor. }

type
    WDU_INTERFACE_dESCRIPTOR = record
        bLength: UCHAR;
        bDescriptorType: UCHAR;
        bInterfaceNumber: UCHAR;
        bAlternateSetting: UCHAR;
        bNumEndpoints: UCHAR;
        bInterfaceClass: UCHAR;
        bInterfaceSubClass: UCHAR;
        bInterfaceProtocol: UCHAR;
        iInterface: UCHAR;
end;

type
    WDU_ENDPOINT_DESCRIPTOR = record
        bLength: UCHAR;
        bDescriptorType: UCHAR;
        bEndpointAddress: UCHAR;
        bmAttributes: UCHAR;
        wMaxPacketSize: USHORT;
        bInterval: UCHAR;
end;
type PWDU_ENDPOINT_DESCRIPTOR = ^WDU_ENDPOINT_DESCRIPTOR;

type
    WDU_PIPE_INFO = record
        dwNumber : DWORD;  {Pipe 0 is the default pipe}
        dwMaximumPacketSize : DWORD;
        PipeType : DWORD;  { USB_PIPE_TYPE } 
        direction : DWORD; {WDU_DIR
                            Isochronous, Bulk, Interrupt are either WduDirIn
                            or WduDirOut Control are WduDirInOot}
        dwInterval : DWORD {interval in ms relevant to Interrupt pipes}
end;
type PWDU_PIPE_INFO = ^WDU_PIPE_INFO;

type
    WDU_CONFIGURATION_DESCRIPTOR = record
        bLength: UCHAR;
        bDescriptorType: UCHAR;
        wTotalLength: USHORT;
        bNumInterfaces: UCHAR;
        bConfigurationValue: UCHAR;
        iConfiguration: UCHAR;
        bmAttributes: UCHAR;
        MaxPower: UCHAR;
end;

type
    WDU_DEVICE_DESCRIPTOR = record
        bLength: UCHAR;
        bDescriptorType: UCHAR;
        bcdUSB: USHORT;
        bDeviceClass: UCHAR;
        bDeviceSubClass: UCHAR;
        bDeviceProtocol: UCHAR;
        bMaxPacketSize0: UCHAR;

        idVendor: USHORT;
        idProduct: USHORT;
        bcdDevice: USHORT;
        iManufacturer: UCHAR;
        iProduct: UCHAR;
        iSerialNumber: UCHAR;
        bNumConfigurations: UCHAR;
end;

type
    WDU_ALTERNATE_SETTING = record
        Descriptor: WDU_INTERFACE_DESCRIPTOR;
        pEndpointDescriptors: PWDU_ENDPOINT_DESCRIPTOR;
        pPipes: PWDU_PIPE_INFO;
end;
type PWDU_ALTERNATE_SETTING = ^WDU_ALTERNATE_SETTING;

type
    WDU_INTERFACE = record
        pAlternateSettings: PWDU_ALTERNATE_SETTING;
        dwNumAltSettings: DWORD;
        pActiveAltSetting: PWDU_ALTERNATE_SETTING;
end;
type PWDU_INTERFACE = ^WDU_INTERFACE;

type
    WDU_CONFIGURATION = record
        Descriptor: WDU_CONFIGURATION_DESCRIPTOR;
        dwNumInterfaces: DWORD;
        pInterfaces: PWDU_INTERFACE;
end;
type PWDU_CONFIGURATION = ^WDU_CONFIGURATION;

type
    WDU_DEVICE = record
        Descriptor: WDU_DEVICE_DESCRIPTOR;
        Pipe0: WDU_PIPE_INFO;
        pConfigs: PWDU_CONFIGURATION;
        pActiveConfig: PWDU_CONFIGURATION;
        pActiveInterface: PWDU_INTERFACE;
end;
type PWDU_DEVICE = ^WDU_DEVICE;
type PPWDU_DEVICE = ^PWDU_DEVICE;

{ NOTE: Any devices found matching this table will be controlled by WD: }
type
    WDU_MATCH_TABLE = record
        wVendorId: WORD;
        wProductId: WORD;
        bDeviceClass: BYTE;
        bDeviceSubClass: BYTE;
        bInterfaceClass: BYTE;
        bInterfaceSubClass: BYTE;
        bInterfaceProtocol: BYTE;
end;
type PWDU_MATCH_TABLE = ^WDU_MATCH_TABLE;

type
    WDU_GET_DEVICE_DATA = record
        dwUniqueID: DWORD;
        pBuf: PVOID;
        dwBytes: DWORD;
        dwOptions: DWORD;
end;

type
    WDU_SET_INTERFACE = record
        dwUniqueID: DWORD;
        dwInterfaceNum: DWORD;
        dwAlternateSetting: DWORD;
        dwOptions: DWORD;
end;

type
    WDU_RESET_PIPE = record
        dwUniqueID: DWORD;
        dwPipeNum: DWORD;
        dwOptions: DWORD;
end;

type
    WDU_HALT_TRANSFER = record
        dwUniqueID: DWORD;
        dwPipeNum: DWORD;
        dwOptions: DWORD;
end;

type
   WDU_TRANSFER  = record
       dwUniqueID: DWORD;
       dwPipeNum: DWORD;  { Pipe number on device. }
       fRead: DWORD;      { TRUE for read (IN) transfers;
                            FALSE for write (OUT) transfers. }
       dwOptions: DWORD;  { USB_TRANSFER options:
                            USB_ISOCH_FULL_PACKETS_ONLY - For isochronous
                            transfers only. If set, only full packets will be
                            transmitted and the transfer function will return
                            when the amount of bytes left to transfer is less
                            than the maximum packet size for the pipe (the
                            function will return without transmitting the
                            remaining bytes). }
        pBuffer: PVOID;        { Pointer to buffer to read/write. }
        dwBufferSize: DWORD;   { Amount of bytes to transfer. }
        dwBytesTransferred: DWORD; { Returns the number of bytes actually
                                     read/written }
        SetupPacket: array [0 .. 7] of BYTE;  { Setup packet for control pipe
                                             transfer. }
        dwTimeout: DWORD;   { Timeout for the transfer in milliseconds.
                              Set to 0 for infinite wait. }
end;

type
    WDU_GET_DESCRIPTOR = record
        dwUniqueID: DWORD;
        bType: UCHAR;
        bIndex: UCHAR;
        wLength: WORD;
        pBuffer: PVOID;
        wLanguage: WORD;
end;


{ WD_ERROR_CODES options }
type WD_ERROR_CODES = DWORD;
const
    WD_STATUS_SUCCESS = $0;
    WD_STATUS_INVALID_WD_HANDLE = $ffffffff;
    WD_WINDRIVER_STATUS_ERROR = $20000000;

    WD_INVALID_HANDLE = $20000001;
    WD_INVALID_PIPE_NUMBER = $20000002;
    WD_READ_WRITE_CONFLICT = $20000003; { request to read from an OUT (write) 
                                 pipe or request to write to an IN (read) pipe }
    WD_ZERO_PACKET_SIZE = $20000004; { maximum packet size is zero }
    WD_INSUFFICIENT_RESOURCES = $20000005;
    WD_UNKNOWN_PIPE_TYPE = $20000006;
    WD_SYSTEM_INTERNAL_ERROR = $20000007;
    WD_DATA_MISMATCH = $20000008;
    WD_NO_LICENSE = $20000009;
    WD_NOT_IMPLEMENTED = $2000000a;
    WD_KERPLUG_FAILURE = $2000000b;
    WD_FAILED_ENABLING_INTERRUPT = $2000000c;
    WD_INTERRUPT_NOT_ENABLED = $2000000d;
    WD_RESOURCE_OVERLAP = $2000000e;
    WD_DEVICE_NOT_FOUND = $2000000f;
    WD_WRONG_UNIQUE_ID = $20000010;
    WD_OPERATION_ALREADY_DONE = $20000011;
    WD_USB_DESCRIPTOR_ERROR = $20000012;
    WD_INTERFACE_DESCRIPTOR_ERROR = $20000012;
    WD_SET_CONFIGURATION_FAILED = $20000013;
    WD_CANT_OBTAIN_PDO = $20000014;
    WD_TIME_OUT_EXPIRED = $20000015;
    WD_IRP_CANCELED = $20000016;
    WD_FAILED_USER_MAPPING = $20000017;
    WD_FAILED_KERNEL_MAPPING = $20000018;
    WD_NO_RESOURCES_ON_DEVICE = $20000019;
    WD_NO_EVENTS = $2000001a;
    WD_INVALID_PARAMETER = $2000001b;
    WD_INCORRECT_VERSION = $2000001c;
    WD_TRY_AGAIN = $2000001d;
    WD_WINDRIVER_NOT_FOUND = $2000001e;

{ The following statuses are returned by USBD: }
    { USBD status types: }
    WD_USBD_STATUS_SUCCESS = $00000000;
    WD_USBD_STATUS_PENDING = $40000000;
    WD_USBD_STATUS_ERROR = $80000000;
    WD_USBD_STATUS_HALTED = $C0000000;

    { USBD status codes:
      NOTE: The following status codes are comprised of one of the status types above and an
      error code [i.e. $XYYYYYYYL - where: X = status type; YYYYYYY = error code].
      The same error codes may also appear with one of the other status types as well. }

    { HC (Host Controller) status codes.
     [NOTE: These status codes use the WD_USBD_STATUS_HALTED status type]: }
    WD_USBD_STATUS_CRC = $C0000001;
    WD_USBD_STATUS_BTSTUFF = $C0000002;
    WD_USBD_STATUS_DATA_TOGGLE_MISMATCH = $C0000003;
    WD_USBD_STATUS_STALL_PID = $C0000004;
    WD_USBD_STATUS_DEV_NOT_RESPONDING = $C0000005;
    WD_USBD_STATUS_PID_CHECK_FAILURE = $C0000006;
    WD_USBD_STATUS_UNEXPECTED_PID = $C0000007;
    WD_USBD_STATUS_DATA_OVERRUN = $C0000008;
    WD_USBD_STATUS_DATA_UNDERRUN = $C0000009;
    WD_USBD_STATUS_RESERVED1 = $C000000A;
    WD_USBD_STATUS_RESERVED2 = $C000000B;
    WD_USBD_STATUS_BUFFER_OVERRUN = $C000000C;
    WD_USBD_STATUS_BUFFER_UNDERRUN = $C000000D;
    WD_USBD_STATUS_NOT_ACCESSED = $C000000F;
    WD_USBD_STATUS_FIFO = $C0000010;

    { Returned by HCD (Host Controller Driver) if a transfer is submitted to 
      an endpoint that is stalled: }
    WD_USBD_STATUS_ENDPOINT_HALTED = $C0000030;

    { Software status codes
      [NOTE: The following status codes have only the error bit set]: }
    WD_USBD_STATUS_NO_MEMORY = $80000100;
    WD_USBD_STATUS_INVALID_URB_FUNCTION = $80000200;
    WD_USBD_STATUS_INVALID_PARAMETER = $80000300;

    { Returned if client driver attempts to close an endpoint/interface
      or configuration with outstanding transfers: }
    WD_USBD_STATUS_ERROR_BUSY = $80000400;

    { Returned by USBD if it cannot complete a URB request. Typically this
      will be returned in the URB status field when the Irp is completed
      with a more specific NT error code. [The Irp statuses are indicated in
      WinDriver's Monitor Debug Messages (wddebug_gui) tool]: }
    WD_USBD_STATUS_REQUEST_FAILED = $80000500;

    WD_USBD_STATUS_INVALID_PIPE_HANDLE = $80000600;

    { Returned when there is not enough bandwidth available
      to open a requested endpoint: }
    WD_USBD_STATUS_NO_BANDWIDTH = $80000700;

    { Generic HC (Host Controller) error: }
    WD_USBD_STATUS_INTERNAL_HC_ERROR = $80000800;

    { Returned when a short packet terminates the transfer
      i.e. USBD_SHORT_TRANSFER_OK bit not set: }
    WD_USBD_STATUS_ERROR_SHORT_TRANSFER = $80000900;

    { Returned if the requested start frame is not within
      USBD_ISO_START_FRAME_RANGE of the current USB frame,
      NOTE: that the stall bit is set: }
    WD_USBD_STATUS_BAD_START_FRAME = $C0000A00;

    { Returned by HCD (Host Controller Driver) if all packets in an iso transfer complete with
      an error: }
    WD_USBD_STATUS_ISOCH_REQUEST_FAILED = $C0000B00;

    { Returned by USBD if the frame length control for a given
      HC (Host Controller) is already taken by another driver: }
    WD_USBD_STATUS_FRAME_CONTROL_OWNED = $C0000C00;

    { Returned by USBD if the caller does not own frame length control and
      attempts to release or modify the HC frame length: }
    WD_USBD_STATUS_FRAME_CONTROL_NOT_OWNED = $C0000D00;

type
    WD_USB_TRANSFER = record
        hDevice : DWORD;    {handle of USB device to read from or write to}
        dwPipe : DWORD;     {pipe number on device}
        fRead : DWORD;
        dwOptions : DWORD;  {USB_TRANSFER options:
                             USB_TRANSFER_HALT - halts the pervious transfer.
                             USB_SHORT_TRANSFER - the transfer will be completed if
                             the device sent a short packet of data.
                             USB_FULL_TRANSFER - the transfer will normally be completed
                             if all the requested data was transferred.}
        pBuffer : PVOID;     {pointer to buffer to read/write}
        dwBytes : DWORD;
        dwTimeout : DWORD;   {timeout for the transfer in milliseconds. 0==>no timeout.}
        dwBytesTransfered : DWORD; {returns the number of bytes actually read/written}
        SetupPacket : array[0..7] of BYTE; {setup packet for control pipe transfer}
        fOK : DWORD;
        dwStatus : DWORD; {Configuration status code - see WD_USB_ERROR_CODES enum definition.
                           WD_USBD_STATUS_SUCCESS for a successful configuration.}
end;

    PWD_USB_TRANSFER = ^WD_USB_TRANSFER;

type
    WD_USB_DEVICE_REGISTER = record
        uniqueId : DWORD;                   {the device unique ID}
        dwConfigurationIndex : DWORD;       {the index of the configuration to register}
        dwInterfaceNum : DWORD;             {interface to register}
        dwInterfaceAlternate : DWORD;
        hDevice : DWORD;                    {handle of device}
        Device : WD_USB_DEVICE_INFO;        {description of the device}
        dwOptions : DWORD;                  {should be zero}
        cName : array[0..31] of CHAR ;      {name of card}
        cDescription: array[0..99] of CHAR; {description}
        dwStatus : DWORD;                   {Configuration status code - see WD_USB_ERROR_CODES
                                             enum definition.   WD_USBD_STATUS_SUCCESS for a
                                             successful configuration.}
end;

    PWD_USB_DEVICE_REGISTER = ^WD_USB_DEVICE_REGISTER;

type
    WD_USB_RESET_PIPE = record
        hDevice : DWORD;
        dwPipe : DWORD;
        dwStatus : DWORD; {Configuration status code - see WD_USB_ERROR_CODES enum definition.
                           WD_USBD_STATUS_SUCCESS for a successful configuration.}
end;

    PWD_USB_RESET_PIPE = ^WD_USB_RESET_PIPE;

const
    WD_USB_HARD_RESET = 1;

type
    WD_USB_RESET_DEVICE = record
        hDevice : DWORD;
        dwOptions : DWORD; {USB_RESET options:
                            WD_USB_HARD_RESET - will reset the device even if it is not disabled.
                            After using this option it is advised to un-register the device
                            (WD_UsbDeviceUnregister()) and register it again - to make sure that
                            the device has all its resources.}
        dwStatus : DWORD;  {Configuration status code - see WD_USB_ERROR_CODES enum definition.
                            WD_USBD_STATUS_SUCCESS for a successful configuration.}
end;

    PWD_USB_RESET_DEVICE = ^WD_USB_RESET_DEVICE;

type WD_EVENT_ACTION = DWORD;
const
    WD_INSERT = $1;
    WD_REMOVE = $2;
    WD_POWER_CHANGED_D0 = $10;  {power states for the power management.}
    WD_POWER_CHANGED_D1 = $20;
    WD_POWER_CHANGED_D2 = $40;
    WD_POWER_CHANGED_D3 = $80;
    WD_POWER_SYSTEM_WORKING = $100;
    WD_POWER_SYSTEM_SLEEPING1 = $200;
    WD_POWER_SYSTEM_SLEEPING2 = $400;
    WD_POWER_SYSTEM_SLEEPING3 = $800;
    WD_POWER_SYSTEM_HIBERNATE = $1000;
    WD_POWER_SYSTEM_SHUTDOWN = $2000;
const
    WD_ACTIONS_POWER = $3ff0;
    WD_ACTIONS_ALL = $3ff3;

type WD_EVENT_OPTION = DWORD;
const
    WD_ACKNOWLEDGE = $1;
    WD_REENUM = $2;

type WD_CARD_TYPE = DWORD;

    PCI_CARD_WD_EVENT = record
        cardId : WD_PCI_ID;
        pciSlot : WD_PCI_SLOT;
    end;

    USB_CARD_WD_EVENT = record
        deviceId : WD_USB_ID;
        dwUniqueID : DWORD;
    end;

    WD_EVENT = record
        handle     : DWORD;
        dwAction   : DWORD; {WD_EVENT_ACTION}
        dwStatus   : DWORD; {EVENT_STATUS}
        dwEventId  : DWORD;
        dwCardType : Integer; {WD_BUS_PCI or WD_BUS_USB}
        hKernelPlugIn : DWORD;
        dwOptions  : DWORD; {WD_EVENT_OPTION}
        dwVendorId : DWORD;
        dwProductId : DWORD; { dwDeviceId for PCI cards }
        { for PCI card
            dw1 - dwBus
            dw2 - dwSlot
            dw3 - dwFunction
          for USB device
            dw1 - dwUniqueID }
        dw1 : DWORD;
        dw2 : DWORD;
        dw3 : DWORD;
    end;

    PWD_EVENT = ^WD_EVENT;

type
    WD_USAGE = record
        applications_num: DWORD;
        devices_num: DWORD;
end;


function WD_Open : HANDLE;
procedure WD_Close(hWD: HANDLE);
function WD_Debug(hWD: HANDLE;var  Debug: SWD_DEBUG) : DWORD;
function WD_DebugDump(hWD: HANDLE; var DebugDump: WD_DEBUG_DUMP) : DWORD;
function WD_Transfer(hWD: HANDLE; var Transfer: SWD_TRANSFER) : DWORD;
function WD_MultiTransfer(hWD: HANDLE; var TransferArray: array of SWD_TRANSFER; dwNumTransfers: DWORD) : DWORD;
function WD_DMALock(hWD: HANDLE; var Dma: WD_DMA) : DWORD;
function WD_DMAUnlock(hWD: HANDLE; var Dma: WD_DMA) : DWORD;
function WD_IntEnable(hWD: HANDLE; var TheInterrupt: WD_INTERRUPT) : DWORD;
function WD_IntDisable(hWD: HANDLE; var TheInterrupt: WD_INTERRUPT) : DWORD;
function WD_IntCount(hWD: HANDLE; var TheInterrupt: WD_INTERRUPT) : DWORD;
function WD_IntWait(hWD: HANDLE; var TheInterrupt: WD_INTERRUPT) : DWORD;
function WD_IsapnpScanCards(hWD: HANDLE; var IsapnpScanCards: WD_ISAPNP_SCAN_CARDS) : DWORD;
function WD_IsapnpGetCardInfo(hWD: HANDLE; var IsapnpGetCardInfo: WD_ISAPNP_CARD_INFO) : DWORD;
function WD_IsapnpConfigDump(hWD: HANDLE; var IsapnpConfigDump: WD_ISAPNP_CONFIG_DUMP) : DWORD;
function WD_PcmciaScanCards(hWD: HANDLE; var PcmciaScanCards: WD_PCMCIA_SCAN_CARDS) : DWORD;
function WD_PcmciaGetCardInfo(hWD: HANDLE; var PcmciaGetCardInfo: WD_PCMCIA_CARD_INFO) : DWORD;
function WD_PcmciaConfigDump(hWD: HANDLE; var PcmciaConfigDump: WD_PCMCIA_CONFIG_DUMP) : DWORD;
function WD_Sleep(hWD: HANDLE; var Sleep: SWD_SLEEP) : DWORD;
function WD_CardRegister(hWD: HANDLE; var Card: WD_CARD_REGISTER) : DWORD;
function WD_CardUnregister(hWD: HANDLE; var Card: WD_CARD_REGISTER) : DWORD;
function WD_PciScanCards(hWD: HANDLE; var PciScan: WD_PCI_SCAN_CARDS) : DWORD;
function WD_PciGetCardInfo(hWD: HANDLE; var PciCard: WD_PCI_CARD_INFO) : DWORD;
function WD_Version(hWD: HANDLE; var VerInfo: SWD_VERSION) : DWORD;
function WD_License(hWD: HANDLE; var License: SWD_LICENSE) : DWORD;
function WD_KernelPlugInOpen(hWD: HANDLE; var KernelPlugInOpen: WD_KERNEL_PLUGIN) : DWORD;
function WD_KernelPlugInClose(hWD: HANDLE; var KernelPlugInClose: WD_KERNEL_PLUGIN) : DWORD;
function WD_KernelPlugInCall(hWD: HANDLE; var KernelPlugInCall: WD_KERNEL_PLUGIN_CALL) : DWORD;
function WD_PciConfigDump(hWD: HANDLE; var PciConfigDump: WD_PCI_CONFIG_DUMP) : DWORD;
function WD_UsbScanDevice(h : HANDLE; pUsbScan : PWD_USB_SCAN_DEVICES) : DWORD;
function WD_UsbGetConfiguration(h : HANDLE; pUsbConfiguration : PWD_USB_CONFIGURATION) : DWORD;
function WD_UsbDeviceRegister(h : HANDLE; pRegister : PWD_USB_DEVICE_REGISTER) : DWORD;
function WD_UsbTransfer(h : HANDLE; pTrans : PWD_USB_TRANSFER) : DWORD;
function WD_UsbDeviceUnregister(h : HANDLE; pTrans : PWD_USB_DEVICE_REGISTER) : DWORD;
function WD_UsbResetPipe(h : HANDLE; pResetPipe : PWD_USB_RESET_PIPE) : DWORD;
function WD_UsbResetDevice(h : HANDLE; hDevice : DWORD) : DWORD;
function WD_UsbResetDeviceEx(h : HANDLE; pResetDevice : PWD_USB_RESET_DEVICE) : DWORD;
function WD_EventRegister(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
function WD_EventUnregister(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
function WD_EventPull(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
function WD_EventSend(h : HANDLE; pEvent : PWD_EVENT) : DWORD;


var
  WinDriverGlobalDW: DWORD;
  { Pseudo constants }
  IOCTL_WD_DMA_LOCK: DWORD;
  IOCTL_WD_DMA_UNLOCK: DWORD;
  IOCTL_WD_TRANSFER: DWORD;
  IOCTL_WD_MULTI_TRANSFER: DWORD;
  IOCTL_WD_PCI_SCAN_CARDS: DWORD;
  IOCTL_WD_PCI_GET_CARD_INFO: DWORD;
  IOCTL_WD_VERSION: DWORD;
  IOCTL_WD_LICENSE: DWORD;
  IOCTL_WD_PCI_CONFIG_DUMP: DWORD;
  IOCTL_WD_KERNEL_PLUGIN_OPEN: DWORD;
  IOCTL_WD_KERNEL_PLUGIN_CLOSE: DWORD;
  IOCTL_WD_KERNEL_PLUGIN_CALL: DWORD;
  IOCTL_WD_INT_ENABLE: DWORD;
  IOCTL_WD_INT_DISABLE: DWORD;
  IOCTL_WD_INT_COUNT: DWORD;
  IOCTL_WD_INT_WAIT: DWORD;
  IOCTL_WD_ISAPNP_SCAN_CARDS: DWORD;
  IOCTL_WD_ISAPNP_GET_CARD_INFO: DWORD;
  IOCTL_WD_ISAPNP_CONFIG_DUMP: DWORD;
  IOCTL_WD_SLEEP: DWORD;
  IOCTL_WD_DEBUG: DWORD;
  IOCTL_WD_DEBUG_DUMP: DWORD;
  IOCTL_WD_CARD_UNREGISTER: DWORD;
  IOCTL_WD_CARD_REGISTER: DWORD;
  IOCTL_WD_PCMCIA_SCAN_CARDS: DWORD;
  IOCTL_WD_PCMCIA_GET_CARD_INFO: DWORD;
  IOCTL_WD_PCMCIA_CONFIG_DUMP: DWORD;
  IOCTL_WD_EVENT_REGISTER: DWORD;
  IOCTL_WD_EVENT_UNREGISTER: DWORD;
  IOCTL_WD_EVENT_PULL: DWORD;
  IOCTL_WD_EVENT_SEND: DWORD;
  IOCTL_WD_WATCH_START: DWORD;
  IOCTL_WD_WATCH_STOP: DWORD;

function Get_Ctl_Code(Nr: Integer): DWORD;

implementation
const
  WD_TYPE = 38200;

{This is an implementation of a WinIOCTL macro (CTL_CODE) }
function Get_Ctl_Code(Nr: Integer): DWORD;
var
  r1: DWORD;
  res: DWORD;
begin
  r1:=WD_TYPE ;
  r1:=r1 shl 16;
  res:=r1;
  r1:=FILE_ANY_ACCESS;
  r1:=r1 shl 14;
  res:=res or r1;
  res:=res or (Nr shl 2) or METHOD_NEITHER;
  Result:=res;
end;

function WD_Open: HANDLE;
begin
  WD_Open := CreateFile(PChar('\\.\WINDRVR6'), GENERIC_READ,
                          FILE_SHARE_READ or FILE_SHARE_WRITE,
                          nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
end;

procedure WD_Close(hWD: HANDLE);
begin
  CloseHandle(hWD);
end;

function WD_Debug(hWD: HANDLE ;var Debug: SWD_DEBUG) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_DEBUG, @Debug,
                  SizeOf(SWD_DEBUG), @rc, 4, WinDriverGlobalDW, nil);
  WD_Debug := rc
end;

function WD_DebugDump(hWD: HANDLE ;var DebugDump: WD_DEBUG_DUMP) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_DEBUG_DUMP, @DebugDump,
                  SizeOf(WD_DEBUG_DUMP), @rc, 4, WinDriverGlobalDW, nil);
  WD_DebugDump := rc
end;

function WD_Transfer(hWD: HANDLE ;var Transfer: SWD_TRANSFER) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_TRANSFER, @Transfer,
                  SizeOf(SWD_TRANSFER), @rc, 4, WinDriverGlobalDW, nil);
  WD_Transfer := rc
end;

function WD_MultiTransfer(hWD: HANDLE ; var TransferArray: array of SWD_TRANSFER; dwNumTransfers: DWORD) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_MULTI_TRANSFER, @TransferArray,
                  SizeOf(SWD_TRANSFER) * dwNumTransfers, @rc, 4,
                  WinDriverGlobalDW, nil);
  WD_MultiTransfer := rc
end;

function WD_DMALock(hWD: HANDLE ;var Dma: WD_DMA) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_DMA_LOCK, @Dma, SizeOf(WD_DMA), @rc, 4,
                  WinDriverGlobalDW, nil);
  WD_DMALock := rc
end;

function WD_DMAUnlock(hWD: HANDLE ;var Dma: WD_DMA) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_DMA_UNLOCK, @Dma, SizeOf(WD_DMA), @rc, 4,
                  WinDriverGlobalDW, nil);
  WD_DMAUnlock := rc
end;

function WD_IntEnable(hWD: HANDLE ;var TheInterrupt: WD_INTERRUPT) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_INT_ENABLE, @TheInterrupt,
                  SizeOf(WD_INTERRUPT), @rc, 4, WinDriverGlobalDW, nil);
  WD_IntEnable := rc
end;

function WD_IntDisable(hWD: HANDLE ;var TheInterrupt: WD_INTERRUPT) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_INT_DISABLE, @TheInterrupt,
                  SizeOf(WD_INTERRUPT), @rc, 4, WinDriverGlobalDW, nil);
  WD_IntDisable := rc
end;

function WD_IntCount(hWD: HANDLE ;var TheInterrupt: WD_INTERRUPT) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_INT_COUNT, @TheInterrupt,
                  SizeOf(WD_INTERRUPT), @rc, 4, WinDriverGlobalDW, nil);
  WD_IntCount := rc
end;

function WD_IntWait(hWD: HANDLE ;var TheInterrupt: WD_INTERRUPT) : DWORD;
var
    rc : DWORD;
var
  h: HANDLE;
begin
  h:=WD_Open();
  DeviceIOControl(h, IOCTL_WD_INT_WAIT, @TheInterrupt,
                  SizeOf(WD_INTERRUPT), @rc, 4, WinDriverGlobalDW, nil);
  WD_Close(h);
  WD_IntWait := rc
end;

function WD_IsapnpScanCards(hWD: HANDLE ;var IsapnpScanCards: WD_ISAPNP_SCAN_CARDS) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_ISAPNP_SCAN_CARDS, @IsapnpScanCards,
                  SizeOf(WD_ISAPNP_SCAN_CARDS), @rc, 4, WinDriverGlobalDW, nil);
  WD_IsapnpScanCards := rc;
end;

function WD_IsapnpGetCardInfo(hWD: HANDLE ;var IsapnpGetCardInfo: WD_ISAPNP_CARD_INFO) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_ISAPNP_GET_CARD_INFO, @IsapnpGetCardInfo,
                  SizeOf(WD_ISAPNP_CARD_INFO), @rc, 4, WinDriverGlobalDW, nil);
  WD_IsapnpGetCardInfo := rc
end;

function WD_IsapnpConfigDump(hWD: HANDLE ;var IsapnpConfigDump: WD_ISAPNP_CONFIG_DUMP) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_ISAPNP_CONFIG_DUMP, @IsapnpConfigDump,
                  SizeOf(WD_ISAPNP_CONFIG_DUMP), @rc, 4, WinDriverGlobalDW, nil);
  WD_IsapnpConfigDump := rc
end;

function WD_PcmciaScanCards(hWD: HANDLE ;var PcmciaScanCards: WD_PCMCIA_SCAN_CARDS) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_PCMCIA_SCAN_CARDS, @PcmciaScanCards,
                  SizeOf(WD_PCMCIA_SCAN_CARDS), @rc, 4, WinDriverGlobalDW, nil);
  WD_PcmciaScanCards := rc
end;

function WD_PcmciaGetCardInfo(hWD: HANDLE ;var PcmciaGetCardInfo: WD_PCMCIA_CARD_INFO) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_PCMCIA_GET_CARD_INFO, @PcmciaGetCardInfo,
                  SizeOf(WD_PCMCIA_CARD_INFO), @rc, 4, WinDriverGlobalDW, nil);
  WD_PcmciaGetCardInfo := rc
end;

function WD_PcmciaConfigDump(hWD: HANDLE ;var PcmciaConfigDump: WD_PCMCIA_CONFIG_DUMP) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_PCMCIA_CONFIG_DUMP, @PcmciaConfigDump,
                  SizeOf(WD_PCMCIA_CONFIG_DUMP), @rc, 4, WinDriverGlobalDW, nil);
  WD_PcmciaConfigDump := rc
end;

function WD_Sleep(hWD: HANDLE ;var Sleep: SWD_SLEEP) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_SLEEP, @Sleep,
                  SizeOf(SWD_SLEEP), @rc, 4, WinDriverGlobalDW, nil);
  WD_Sleep := rc
end;

function WD_CardRegister(hWD: HANDLE ;var Card: WD_CARD_REGISTER) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_CARD_REGISTER, @Card,
                  SizeOf(WD_CARD_REGISTER), @rc, 4, WinDriverGlobalDW, nil);
  WD_CardRegister := rc
end;

function WD_CardUnregister(hWD: HANDLE ;var Card: WD_CARD_REGISTER) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_CARD_UNREGISTER, @Card,
                  SizeOf(WD_CARD_REGISTER), @rc, 4, WinDriverGlobalDW, nil);
  WD_CardUnregister := rc
end;

function WD_PciScanCards(hWD: HANDLE ;var PciScan: WD_PCI_SCAN_CARDS) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_PCI_SCAN_CARDS, @PciScan,
                  SizeOf(WD_PCI_SCAN_CARDS), @rc, 4, WinDriverGlobalDW, nil);
  WD_PciScanCards := rc
end;

function WD_PciGetCardInfo(hWD: HANDLE ;var PciCard: WD_PCI_CARD_INFO) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_PCI_GET_CARD_INFO, @PciCard,
                  SizeOf(WD_PCI_CARD_INFO), @rc, 4, WinDriverGlobalDW, nil);
  WD_PciGetCardInfo := rc
end;

function WD_Version(hWD: HANDLE ;var VerInfo: SWD_VERSION) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_VERSION, @VerInfo, SizeOf(SWD_VERSION),
                  @rc, 4, WinDriverGlobalDW, nil);
  WD_Version := rc
end;

function WD_License(hWD: HANDLE ;var License: SWD_LICENSE) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_LICENSE, @License, SizeOf(SWD_LICENSE),
                  @rc, 4, WinDriverGlobalDW, nil);
  WD_License := rc
end;

function WD_KernelPlugInOpen(hWD: HANDLE ;var KernelPlugInOpen: WD_KERNEL_PLUGIN) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_KERNEL_PLUGIN_OPEN, @KernelPlugInOpen, SizeOf(WD_KERNEL_PLUGIN),
                  @rc, 4, WinDriverGlobalDW, nil);
  WD_KernelPlugInOpen := rc
end;

function WD_KernelPlugInClose(hWD: HANDLE ;var KernelPlugInClose: WD_KERNEL_PLUGIN) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_KERNEL_PLUGIN_CLOSE, @KernelPlugInClose, SizeOf(WD_KERNEL_PLUGIN),
                  @rc, 4, WinDriverGlobalDW, nil);
  WD_KernelPlugInClose := rc
end;

function WD_KernelPlugInCall(hWD: HANDLE ;var KernelPlugInCall: WD_KERNEL_PLUGIN_CALL) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_KERNEL_PLUGIN_CALL, @KernelPlugInCall, SizeOf(WD_KERNEL_PLUGIN_CALL),
                  @rc, 4, WinDriverGlobalDW, nil);
  WD_KernelPlugInCall := rc
end;

function WD_PciConfigDump(hWD: HANDLE ;var PciConfigDump: WD_PCI_CONFIG_DUMP) : DWORD;
var
    rc : DWORD;
begin
  DeviceIOControl(hWD, IOCTL_WD_PCI_CONFIG_DUMP, @PciConfigDump,
                  SizeOf(WD_PCI_CONFIG_DUMP), @rc, 4, WinDriverGlobalDW, nil);
  WD_PciConfigDump := rc
end;

function WD_FUNCTION(wFuncNum : DWORD; h : HANDLE; pParam : POINTER; dwSize : DWORD) : DWORD;
var
    rc : DWORD;
begin
    DeviceIoControl(h, wFuncNum, pParam, dwSize, @rc, 4, WinDriverGlobalDW, nil);
    WD_FUNCTION := rc
end;


function WD_UsbScanDevice(h : HANDLE; pUsbScan : PWD_USB_SCAN_DEVICES) : DWORD;
begin
    WD_UsbScanDevice := WD_FUNCTION(IOCTL_WD_USB_SCAN_DEVICES, h,
        POINTER(pUsbScan), DWORD(SizeOf(WD_USB_SCAN_DEVICES)));
end;


function WD_UsbGetConfiguration(h : HANDLE; pUsbConfiguration : PWD_USB_CONFIGURATION) : DWORD;
begin
    WD_UsbGetConfiguration := WD_FUNCTION(IOCTL_WD_USB_GET_CONFIGURATION, h,
        POINTER(pUsbConfiguration), DWORD(SizeOf(WD_USB_CONFIGURATION)));
end;


function WD_UsbDeviceRegister(h : HANDLE; pRegister : PWD_USB_DEVICE_REGISTER) : DWORD;
begin
    WD_UsbDeviceRegister := WD_FUNCTION(IOCTL_WD_USB_DEVICE_REGISTER, h,
        pRegister, DWORD(sizeof(WD_USB_DEVICE_REGISTER)));
end;


function WD_UsbTransfer(h : HANDLE; pTrans : PWD_USB_TRANSFER) : DWORD;
var
  lh: HANDLE;
begin
    lh:=WD_Open();
    WD_UsbTransfer := WD_FUNCTION(IOCTL_WD_USB_TRANSFER, lh,
        POINTER(pTrans), DWORD(SizeOf(WD_USB_TRANSFER)));
    WD_Close(lh);
end;


function WD_UsbDeviceUnregister(h : HANDLE; pTrans : PWD_USB_DEVICE_REGISTER) : DWORD;
begin
    WD_UsbDeviceUnregister := WD_FUNCTION(IOCTL_WD_USB_DEVICE_UNREGISTER, h,
        POINTER(pTrans), DWORD(SizeOf(WD_USB_DEVICE_REGISTER)));
end;


function WD_UsbResetPipe(h : HANDLE; pResetPipe : PWD_USB_RESET_PIPE) : DWORD;
begin
    WD_UsbResetPipe := WD_FUNCTION(IOCTL_WD_USB_RESET_PIPE, h,
        POINTER(pResetPipe), DWORD(SizeOf(WD_USB_RESET_PIPE)));
end;

function WD_UsbResetDevice(h : HANDLE; hDevice : DWORD) : DWORD;
begin
    WD_UsbResetDevice := WD_FUNCTION(IOCTL_WD_USB_RESET_DEVICE, h,
        @hDevice, DWORD(SizeOf(DWORD)));
end;

function WD_UsbResetDeviceEx(h : HANDLE; pResetDevice : PWD_USB_RESET_DEVICE) : DWORD;
begin
    WD_UsbResetDeviceEx := WD_FUNCTION(IOCTL_WD_USB_RESET_DEVICE_EX, h,
        POINTER(pResetDevice), DWORD(SizeOf(WD_USB_RESET_DEVICE)));
end;

function WD_EventRegister(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
begin
    WD_EventRegister := WD_FUNCTION(IOCTL_WD_EVENT_REGISTER, h,
        pEvent, DWORD(SizeOf(WD_EVENT)));
end;

function WD_EventUnregister(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
begin
    WD_EventUnregister := WD_FUNCTION(IOCTL_WD_EVENT_UNREGISTER, h,
        pEvent, DWORD(SizeOf(WD_EVENT)));
end;

function WD_EventPull(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
begin
    WD_EventPull := WD_FUNCTION(IOCTL_WD_EVENT_PULL, h,
        pEvent, DWORD(SizeOf(WD_EVENT)));
end;

function WD_EventSend(h : HANDLE; pEvent : PWD_EVENT) : DWORD;
begin
    WD_EventSend := WD_FUNCTION(IOCTL_WD_EVENT_SEND, h,
        pEvent, DWORD(SizeOf(WD_EVENT)));
end;

initialization
    IOCTL_WD_DMA_LOCK               := Get_Ctl_Code($901) ;
    IOCTL_WD_DMA_UNLOCK             := Get_Ctl_Code($902) ;
    IOCTL_WD_TRANSFER               := Get_Ctl_Code($903) ;
    IOCTL_WD_MULTI_TRANSFER         := Get_Ctl_Code($904) ;
    IOCTL_WD_PCI_SCAN_CARDS         := Get_Ctl_Code($90e) ;
    IOCTL_WD_PCI_GET_CARD_INFO      := Get_Ctl_Code($90f) ;
    IOCTL_WD_VERSION                := Get_Ctl_Code($910) ;
    IOCTL_WD_PCI_CONFIG_DUMP        := Get_Ctl_Code($91a) ;
    IOCTL_WD_KERNEL_PLUGIN_OPEN     := Get_Ctl_Code($91b) ;
    IOCTL_WD_KERNEL_PLUGIN_CLOSE    := Get_Ctl_Code($91c) ;
    IOCTL_WD_KERNEL_PLUGIN_CALL     := Get_Ctl_Code($91d) ;
    IOCTL_WD_INT_ENABLE             := Get_Ctl_Code($91e) ;
    IOCTL_WD_INT_DISABLE            := Get_Ctl_Code($91f) ;
    IOCTL_WD_INT_COUNT              := Get_Ctl_Code($920) ;
    IOCTL_WD_ISAPNP_SCAN_CARDS      := Get_Ctl_Code($924) ;
    IOCTL_WD_ISAPNP_CONFIG_DUMP     := Get_Ctl_Code($926) ;
    IOCTL_WD_SLEEP                  := Get_Ctl_Code($927) ;
    IOCTL_WD_DEBUG                  := Get_Ctl_Code($928) ;
    IOCTL_WD_DEBUG_DUMP             := Get_Ctl_Code($929) ;
    IOCTL_WD_CARD_UNREGISTER        := Get_Ctl_Code($92b) ;
    IOCTL_WD_ISAPNP_GET_CARD_INFO   := Get_Ctl_Code($92d) ;
    IOCTL_WD_PCMCIA_SCAN_CARDS      := Get_Ctl_Code($92f) ;
    IOCTL_WD_PCMCIA_GET_CARD_INFO   := Get_Ctl_Code($930) ;
    IOCTL_WD_PCMCIA_CONFIG_DUMP     := Get_Ctl_Code($931) ;
    IOCTL_WD_CARD_REGISTER          := Get_Ctl_Code($97d) ;
    IOCTL_WD_INT_WAIT               := Get_Ctl_Code($94b) ;
    IOCTL_WD_LICENSE                := Get_Ctl_Code($952) ;
    IOCTL_WD_USB_RESET_PIPE         := Get_Ctl_Code($971) ;
    IOCTL_WD_USB_RESET_DEVICE       := Get_Ctl_Code($93f) ;
    IOCTL_WD_USB_SCAN_DEVICES       := Get_Ctl_Code($969) ;
    IOCTL_WD_USB_TRANSFER           := Get_Ctl_Code($967) ;
    IOCTL_WD_USB_DEVICE_REGISTER    := Get_Ctl_Code($968) ;
    IOCTL_WD_USB_DEVICE_UNREGISTER  := Get_Ctl_Code($970) ;
    IOCTL_WD_USB_GET_CONFIGURATION  := Get_Ctl_Code($974) ;
    IOCTL_WD_EVENT_REGISTER         := Get_Ctl_Code($961) ;
    IOCTL_WD_EVENT_UNREGISTER       := Get_Ctl_Code($962) ;
    IOCTL_WD_EVENT_PULL             := Get_Ctl_Code($963) ;
    IOCTL_WD_EVENT_SEND             := Get_Ctl_Code($97a) ;
    IOCTL_WD_USB_RESET_DEVICE_EX    := Get_Ctl_Code($973) ;
end.

