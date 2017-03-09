unit AmccLib;

Interface

////////////////////////////////////////////////////////////////
// File - AMCCLIB.C
//
// Library for 'WinDriver for AMCC 5933' API.
// The basic idea is to get a handle for the board
// with AMCC_Open() and use it in the rest of the program
// when calling WD functions.  Call AMCC_Close() when done.
//
// Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com
// Delphi Translation Gérard Sadoc 15-05-03
//
////////////////////////////////////////////////////////////////


uses windows,util1,
     windrvr,
     pci_regs,bits,
     windrvr_int_thread,
     status_strings;


type
  AMCC_MODE=integer;
Const
  AMCC_MODE_BYTE=0;
  AMCC_MODE_WORD=1;
  AMCC_MODE_DWORD=2;

type
  AMCC_ADDR=integer;
Const
  AMCC_ADDR_REG      = AD_PCI_BAR0;
  AMCC_ADDR_SPACE0   = AD_PCI_BAR1;
  AMCC_ADDR_SPACE1   = AD_PCI_BAR2;
  AMCC_ADDR_SPACE2   = AD_PCI_BAR3;
  AMCC_ADDR_SPACE3   = AD_PCI_BAR4;
  AMCC_ADDR_NOT_USED = AD_PCI_BAR5;


type
  AMCC_INT_RESULT=record
    dwCounter:   DWORD ;   // number of interrupts received
    dwLost:      DWORD ;   // number of interrupts not yet dealt with
    fStopped:    BOOL ;    // was interrupt disabled during wait
    dwStatusReg: DWORD ;   // value of status register when interrupt occurred
  end;



  AMCC_ADDR_DESC=record
    dwLocalBase: DWORD ;
    dwMask:      DWORD ;
    dwBytes:     DWORD ;
    dwAddr:      DWORD ;
    dwAddrDirect:DWORD ;
    fIsMemory:   BOOL  ;
  end;

 AMCCHANDLE=^AMCC_STRUCT ;
 AMCC_INT_HANDLER= procedure ( hAmcc:AMCCHANDLE ; var intResult: AMCC_INT_RESULT );stdCall;

 AMCC_INTERRUPT=record
    Int:            WD_INTERRUPT ;
    hThread:        HANDLE ;
    Trans:          array[0..1] of SWD_TRANSFER ;
    funcIntHandler: AMCC_INT_HANDLER ;
  end;

 AMCC_STRUCT= record
    hWD:      THANDLE;
    cardLock: WD_CARD;
    pciSlot:  WD_PCI_SLOT ;
    cardReg:  WD_CARD_REGISTER ;
    addrDesc: array[0..AD_PCI_BARS-1] of AMCC_ADDR_DESC;
    Int:      AMCC_INTERRUPT;
  end;



function AMCC_CountCards (dwVendorID:Dword; dwDeviceID:Dword):Dword;
function AMCC_Open (var phAmcc: AMCCHANDLE; dwVendorID, dwDeviceID, nCardNum:Dword):Bool;
procedure AMCC_Close (hAmcc: AMCCHANDLE );

function AMCC_IsAddrSpaceActive(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ):Bool;

procedure AMCC_WriteRegDWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ; data: DWORD );
function AMCC_ReadRegDWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ):Dword;
procedure AMCC_WriteRegWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ; data: WORD );
function AMCC_ReadRegWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ):word;
procedure AMCC_WriteRegByte (hAmcc: AMCCHANDLE ; dwReg: DWORD ; data: BYTE );
function AMCC_ReadRegByte (hAmcc: AMCCHANDLE ; dwReg: DWORD ):byte;

procedure AMCC_WriteDWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ; data: DWORD );
function AMCC_ReadDWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ):Dword;
procedure  AMCC_WriteWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ; data: WORD );
function AMCC_ReadWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ):Word;
procedure AMCC_WriteByte(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ; data: BYTE );
function AMCC_ReadByte(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ):byte;

procedure AMCC_ReadWriteSpaceBlock (hAmcc: AMCCHANDLE ; dwOffset: DWORD ; buf:pointer; dwBytes: DWORD;
                                    fIsRead: BOOL; addrSpace: AMCC_ADDR ; mode: AMCC_MODE );
procedure AMCC_ReadSpaceBlock (hAmcc: AMCCHANDLE ; dwOffset: DWORD ; buf:pointer; dwBytes: DWORD; addrSpace: AMCC_ADDR );
procedure AMCC_WriteSpaceBlock (hAmcc: AMCCHANDLE ; dwOffset: DWORD ; buf:pointer; dwBytes: DWORD; addrSpace: AMCC_ADDR );

function AMCC_ReadNVByte(hAmcc: AMCCHANDLE ; dwAddr: DWORD ; var pbData:byte):Bool;

// interrupt functions
function AMCC_IntIsEnabled (hAmcc: AMCCHANDLE ):BOOL;
function AMCC_IntEnable (hAmcc: AMCCHANDLE ; funcIntHandler: AMCC_INT_HANDLER ):BOOL;
procedure AMCC_IntDisable (hAmcc: AMCCHANDLE );

// access pci configuration registers
function AMCC_ReadPCIReg(hAmcc: AMCCHANDLE ; dwReg: DWORD ):Dword;
procedure AMCC_WritePCIReg(hAmcc: AMCCHANDLE ; dwReg: DWORD ; dwData: DWORD );

// DMA functions
function AMCC_DMAOpen(hAmcc: AMCCHANDLE ; var pDMA: WD_DMA ; dwBytes: DWORD ):BOOL;
procedure AMCC_DMAClose(hAmcc: AMCCHANDLE ; var pDMA: WD_DMA );
function AMCC_DMAStart(hAmcc: AMCCHANDLE ;var pDMA: WD_DMA ; fRead: BOOL ;
    fBlocking: BOOL ; dwBytes: DWORD ; dwOffset: DWORD ):BOOL;
function AMCC_DMAIsDone(hAmcc: AMCCHANDLE ; fRead: BOOL ):BOOL;

// this string is set to an error message, if one occurs
var
  AMCC_ErrorString:string;

// Operation register offsets
Const

    OMB1_ADDR   = $00;
    OMB2_ADDR   = $04;
    OMB3_ADDR   = $08;
    OMB4_ADDR   = $0c;
    IMB1_ADDR   = $10;
    IMB2_ADDR   = $14;
    IMB3_ADDR   = $18;
    IMB4_ADDR   = $1c;
    FIFO_ADDR   = $20;
    MWAR_ADDR   = $24;
    MWTC_ADDR   = $28;
    MRAR_ADDR   = $2c;
    MRTC_ADDR   = $30;
    MBEF_ADDR   = $34;
    INTCSR_ADDR = $38;
    BMCSR_ADDR  = $3c;


    BMCSR_NVDATA_ADDR = BMCSR_ADDR + 2;
    BMCSR_NVCMD_ADDR = BMCSR_ADDR + 3;


    NVRAM_BUSY_BITS        = BIT7 ;    //* Bit 31 indicates if device busy


    NVCMD_LOAD_LOW_BITS    = BIT7;                 // nvRAM Load Low command
    NVCMD_LOAD_HIGH_BITS   = BIT5 OR BIT7;         // nvRAM Load High command
    NVCMD_BEGIN_WRITE_BITS = BIT6 OR BIT7;         // nvRAM Begin Write command
    NVCMD_BEGIN_READ_BITS  = BIT5 OR BIT6 OR BIT7; // nvRAM Begin Read command

    AMCC_NVRAM_SIZE = $80 ; // size in bytes of nvRAM


    AIMB1    = $00;
    AIMB2    = $04;
    AIMB3    = $08;
    AIMB4    = $0c;
    AOMB1    = $10;
    AOMB2    = $14;
    AOMB3    = $18;
    AOMB4    = $1c;
    AFIFO    = $20;
    AMWAR    = $24;
    APTA     = $28;
    APTD     = $2c;
    AMRAR    = $30;
    AMBEF    = $34;
    AINT     = $38;
    AGCSTS   = $3c;


Implementation

const
  WD_PROD_NAME='WinDriver';


// internal function used by AMCC_Open()
function AMCC_DetectCardElements(hAmcc: AMCCHANDLE ):BOOL;forward;

function AMCC_CountCards (dwVendorID:Dword; dwDeviceID:Dword):Dword;
var
  ver: SWD_VERSION ;
  pciScan: WD_PCI_SCAN_CARDS ;
const
  hWD: HANDLE  = INVALID_HANDLE_VALUE;
var
  dwStatus: DWORD ;

begin
  result:=0;
  AMCC_ErrorString:= '';

  hWD := WD_Open();
  // check if handle valid & version OK
  if (hWD=INVALID_HANDLE_VALUE) then
    begin
        AMCC_ErrorString:= 'Failed opening '+ WD_PROD_NAME +' device';
        exit;
    end;

  fillchar(ver,sizeof(ver),0);
  WD_Version(hWD,ver);
  if (ver.dwVer<WD_VER) then
    begin
      AMCC_ErrorString:= 'Incorrect '+ WD_PROD_NAME +' version';
      WD_Close (hWD);
      exit;
    end;

    fillchar(pciScan,sizeof(pciScan),0);
    pciScan.searchId.dwVendorId := dwVendorID;
    pciScan.searchId.dwDeviceId := dwDeviceID;
    dwStatus := WD_PciScanCards(hWD, pciScan);
    WD_Close(hWD);
    if dwStatus<>0 then
       AMCC_ErrorString:='WD_PciScanCards failed with status ='+Istr(dwStatus)
    else
    if (pciScan.dwCards=0) then
      AMCC_ErrorString:='no cards found';

    result:= pciScan.dwCards;
end;

function AMCC_Open (var phAmcc: AMCCHANDLE; dwVendorID, dwDeviceID, nCardNum:Dword):Bool;
var
  hAmcc:AMCCHANDLE;
  ver:SWD_VERSION ;
  pciScan: WD_PCI_SCAN_CARDS ;
  pciCardInfo: WD_PCI_CARD_INFO ;
  dwStatus: DWORD ;
  label exit0;
begin
  new(hAmcc);
  phAmcc:=nil;
  AMCC_ErrorString:= '';

  hAmcc^.hWD := WD_Open();

  // check if handle valid & version OK
  if (hAmcc^.hWD=INVALID_HANDLE_VALUE) then
    begin
       AMCC_ErrorString:='Failed opening  '+ WD_PROD_NAME +' device';
       goto Exit0;
    end;


  fillchar(ver,sizeof(ver),0);
  WD_Version(hAmcc^.hWD,ver);
  if (ver.dwVer<WD_VER) then
    begin
        AMCC_ErrorString:='Incorrect '+ WD_PROD_NAME +' version';
        goto Exit0;
    end;

    fillchar(pciScan,sizeof(pciScan),0);
    pciScan.searchId.dwVendorId := dwVendorID;
    pciScan.searchId.dwDeviceId := dwDeviceID;
    dwStatus := WD_PciScanCards (hAmcc^.hWD, pciScan);
    if (dwStatus<>0) then
    begin
        AMCC_ErrorString:='WD_PciScanCards() failed with status '+Istr(dwStatus);
        goto Exit0;
    end;
    if (pciScan.dwCards=0) then// Found at least one card
    begin
        AMCC_ErrorString:='Could not find PCI card';
        goto Exit0;
    end;
    if (pciScan.dwCards<=nCardNum) then
    begin
        AMCC_ErrorString:='Card out of range of available cards';
        goto Exit0;
    end;

    fillchar(pciCardInfo,sizeof(pciCardInfo),0);
    pciCardInfo.pciSlot := pciScan.cardSlot[nCardNum];
    WD_PciGetCardInfo (hAmcc^.hWD, pciCardInfo);
    hAmcc^.pciSlot := pciCardInfo.pciSlot;
    hAmcc^.cardReg.Card := pciCardInfo.Card;

    hAmcc^.cardReg.fCheckLockOnly := 0;
    dwStatus := WD_CardRegister(hAmcc^.hWD, hAmcc^.cardReg);
    if (dwStatus<>0) then
    begin
        AMCC_ErrorString:='WD_CardRegister() failed with status '+Istr(dwStatus);
    end;
    if (hAmcc^.cardReg.hCard=0) then
    begin
        AMCC_ErrorString:='Failed locking device';
        goto Exit0;
    end;

    if not AMCC_DetectCardElements(hAmcc) then
    begin
        AMCC_ErrorString:='Card does not have all items expected for AMCC';
        goto Exit0;
    end;

    // Open finished OK
    phAmcc := hAmcc;
    result:=true;
    exit;

  Exit0:
    // Error during Open
    if (hAmcc^.cardReg.hCard<>0) then
        WD_CardUnregister(hAmcc^.hWD, hAmcc^.cardReg);
    if (hAmcc^.hWD <>INVALID_HANDLE_VALUE) then
        WD_Close(hAmcc^.hWD);
    dispose(hAmcc);
    result:= FALSE;
end;


function AMCC_ReadPCIReg(hAmcc: AMCCHANDLE ; dwReg: DWORD ):Dword;
var
  pciCnf: WD_PCI_CONFIG_DUMP ;
  dwVal: DWORD ;
begin
  fillchar(pciCnf,sizeof(pciCnf),0);
  pciCnf.pciSlot := hAmcc^.pciSlot;
  pciCnf.pBuffer := @dwVal;
  pciCnf.dwOffset := dwReg;
  pciCnf.dwBytes := 4;
  pciCnf.fIsRead := 1;
  WD_PciConfigDump(hAmcc^.hWD,pciCnf);
  result:= dwVal;
end;

procedure AMCC_WritePCIReg(hAmcc: AMCCHANDLE ; dwReg: DWORD ; dwData: DWORD );
var
  pciCnf: WD_PCI_CONFIG_DUMP ;
begin
  fillchar (pciCnf,sizeof(pciCnf),0);
  pciCnf.pciSlot := hAmcc^.pciSlot;
  pciCnf.pBuffer := @dwData;
  pciCnf.dwOffset := dwReg;
  pciCnf.dwBytes := 4;
  pciCnf.fIsRead := 0;
  WD_PciConfigDump(hAmcc^.hWD,pciCnf);
end;

function AMCC_DetectCardElements(hAmcc: AMCCHANDLE ):BOOL;
var
  i: DWORD ;
  ad_sp: DWORD ;
  pItem:^WD_ITEMS;
begin
  fillchar(hAmcc^.Int,sizeof(hAmcc^.Int),0);
  fillchar(hAmcc^.addrDesc,sizeof(hAmcc^.addrDesc),0);

  for i:=0 to hAmcc^.cardReg.Card.dwItems-1 do
  begin
      pItem := @hAmcc^.cardReg.Card.Item[i];

      case pItem^.item of
        ITEM_MEMORY:
        begin
          ad_sp := pItem^.Memory.dwBar;
          hAmcc^.addrDesc[ad_sp].fIsMemory := TRUE;
          hAmcc^.addrDesc[ad_sp].dwBytes := pItem^.Memory.dwMBytes;
          hAmcc^.addrDesc[ad_sp].dwAddr := pItem^.Memory.dwTransAddr;
          hAmcc^.addrDesc[ad_sp].dwAddrDirect := pItem^.Memory.dwUserDirectAddr;
          hAmcc^.addrDesc[ad_sp].dwMask := Not hAmcc^.addrDesc[ad_sp].dwBytes;        {Tilde avant hAmcc}
        end;

        ITEM_IO:
        begin
          ad_sp := pItem^.IO.dwBar;
          hAmcc^.addrDesc[ad_sp].fIsMemory := FALSE;
          hAmcc^.addrDesc[ad_sp].dwBytes := pItem^.Memory.dwMBytes;
          hAmcc^.addrDesc[ad_sp].dwAddr := pItem^.IO.dwAddr;
          hAmcc^.addrDesc[ad_sp].dwMask := Not hAmcc^.addrDesc[ad_sp].dwBytes;        {Tilde avant hAmcc}
        end;

        ITEM_INTERRUPT:
        begin
          if (hAmcc^.Int.Int.hInterrupt<>0) then
          begin
            result:= FALSE;
            exit;
          end;
          hAmcc^.Int.Int.hInterrupt := pItem^.Interrupt.hInterrupt;
        end;
      end;
  end;

  // check that the registers space was found
  if not AMCC_IsAddrSpaceActive(hAmcc, AMCC_ADDR_REG) then
    begin
      result:= FALSE;
      exit;
    end;

  // check that at least one memory space was found
  //for (i = AMCC_ADDR_SPACE0; i<=AMCC_ADDR_NOT_USED; i++)
  //    if (AMCC_IsAddrSpaceActive(hAmcc, i)) break;
  //if (i>AMCC_ADDR_NOT_USED) return FALSE;

  result:= TRUE;
end;

procedure AMCC_Close (hAmcc: AMCCHANDLE );
begin
    // disable interrupts
    if (AMCC_IntIsEnabled(hAmcc))
      then  AMCC_IntDisable(hAmcc);

    // unregister card
    if (hAmcc^.cardReg.hCard<>0)
      then  WD_CardUnregister(hAmcc^.hWD, hAmcc^.cardReg);

    // close WinDriver
    WD_Close(hAmcc^.hWD);

    dispose (hAmcc);
end;

function AMCC_IsAddrSpaceActive(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ):Bool;
begin
    result:= (hAmcc^.addrDesc[addrSpace].dwAddr<>0);
end;

procedure AMCC_WriteRegDWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ; data: DWORD );
begin
    AMCC_WriteDWord (hAmcc, AMCC_ADDR_REG, dwReg, data);
end;

function AMCC_ReadRegDWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ):Dword;
begin
    result:= AMCC_ReadDWord (hAmcc, AMCC_ADDR_REG, dwReg);
end;

procedure AMCC_WriteRegWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ; data: WORD );
begin
    AMCC_WriteWord (hAmcc, AMCC_ADDR_REG, dwReg, data);
end;

function AMCC_ReadRegWord (hAmcc: AMCCHANDLE ; dwReg: DWORD ):word;
begin
    result:= AMCC_ReadWord (hAmcc, AMCC_ADDR_REG, dwReg);
end;

procedure AMCC_WriteRegByte (hAmcc: AMCCHANDLE ;dwReg: DWORD ; data: BYTE );
begin
    AMCC_WriteByte (hAmcc, AMCC_ADDR_REG, dwReg, data);
end;

function AMCC_ReadRegByte (hAmcc: AMCCHANDLE ; dwReg: DWORD ):byte;
begin
    result:= AMCC_ReadByte (hAmcc, AMCC_ADDR_REG, dwReg);
end;

// performs a single 32 bit write from address space
procedure AMCC_WriteDWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ; data: DWORD );
var
  dwAddr: DWORD ;
  trans: SWD_TRANSFER ;
begin
    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddrDirect + dwLocalAddr;
        PDword(dwAddr)^:=data;
    end
    else
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr + dwLocalAddr;
        fillchar(trans,sizeof(trans),0);
        trans.cmdTrans := WP_DWORD;
        trans.dwPort := dwAddr;
        trans.ADword := data;
        WD_Transfer (hAmcc^.hWD, trans);
    end;
end;

// performs a single 32 bit read from address space
function AMCC_ReadDWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ):Dword;
var
  dwAddr: DWORD;
  trans: SWD_TRANSFER ;
begin
    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddrDirect + dwLocalAddr;
        result:=PDword(dwAddr)^;
    end
    else
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr + dwLocalAddr;
        fillchar(trans,sizeof(trans),0);
        trans.cmdTrans := RP_DWORD;
        trans.dwPort := dwAddr;
        WD_Transfer (hAmcc^.hWD, trans);
        result:= trans.ADword;
    end;
end;


// performs a single 16 bit write from address space
procedure AMCC_WriteWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ; data: WORD );
var
  dwAddr: DWORD ;
  trans: SWD_TRANSFER ;
begin
    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddrDirect + dwLocalAddr;
        Pword(dwAddr)^:=data;
    end
    else
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr + dwLocalAddr;
        fillchar(trans,sizeof(trans),0);
        trans.cmdTrans := WP_WORD;
        trans.dwPort := dwAddr;
        trans.ADword := data;
        WD_Transfer (hAmcc^.hWD, trans);
    end;
end;

// performs a single 16 bit read from address space
function AMCC_ReadWord(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ):word;
var
  dwAddr: DWORD;
  trans: SWD_TRANSFER ;
begin
    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddrDirect + dwLocalAddr;
        result:=Pword(dwAddr)^;
    end
    else
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr + dwLocalAddr;
        fillchar(trans,sizeof(trans),0);
        trans.cmdTrans := RP_WORD;
        trans.dwPort := dwAddr;
        WD_Transfer (hAmcc^.hWD, trans);
        result:= trans.Aword;
    end;
end;


// performs a single 8 bit write from address space
procedure AMCC_WriteByte(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ; data: BYTE );
var
  dwAddr: DWORD ;
  trans: SWD_TRANSFER ;
begin
    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddrDirect + dwLocalAddr;
        Pbyte(dwAddr)^:=data;
    end
    else
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr + dwLocalAddr;
        fillchar(trans,sizeof(trans),0);
        trans.cmdTrans := WP_BYTE;
        trans.dwPort := dwAddr;
        trans.ADword := data;
        WD_Transfer (hAmcc^.hWD, trans);
    end;
end;

// performs a single 8 bit read from address space
function AMCC_ReadByte(hAmcc: AMCCHANDLE ; addrSpace: AMCC_ADDR ; dwLocalAddr: DWORD ):BYTE;
var
  dwAddr: DWORD;
  trans: SWD_TRANSFER ;
begin
    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddrDirect + dwLocalAddr;
        result:=Pbyte(dwAddr)^;
    end
    else
    begin
        dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr + dwLocalAddr;
        fillchar(trans,sizeof(trans),0);
        trans.cmdTrans := RP_BYTE;
        trans.dwPort := dwAddr;
        WD_Transfer (hAmcc^.hWD, trans);
        result:= trans.Abyte;
    end;
end;



procedure AMCC_ReadWriteSpaceBlock (hAmcc: AMCCHANDLE ; dwOffset: DWORD; buf: Pointer ;
                    dwBytes: DWORD ; fIsRead: BOOL; addrSpace: AMCC_ADDR; mode: AMCC_MODE );
var
  trans: SWD_TRANSFER ;
  dwAddr: DWORD;
begin

    dwAddr := hAmcc^.addrDesc[addrSpace].dwAddr +
            (hAmcc^.addrDesc[addrSpace].dwMask AND dwOffset);

    fillchar(trans,sizeof(trans),0);

    if (hAmcc^.addrDesc[addrSpace].fIsMemory) then
    begin
        if fIsRead then
        begin
            if (mode=AMCC_MODE_BYTE)
              then trans.cmdTrans := RM_SBYTE
            else
            if (mode=AMCC_MODE_WORD)
              then trans.cmdTrans := RM_SWORD
            else trans.cmdTrans := RM_SDWORD;
        end
        else
        begin
            if (mode=AMCC_MODE_BYTE)
              then trans.cmdTrans := WM_SBYTE
            else
            if (mode=AMCC_MODE_WORD)
              then trans.cmdTrans := WM_SWORD
            else trans.cmdTrans := WM_SDWORD;
        end
    end
    else
    begin
        if (fIsRead) then
        begin
            if (mode=AMCC_MODE_BYTE)
              then trans.cmdTrans := RP_SBYTE
            else
            if (mode=AMCC_MODE_WORD)
              then trans.cmdTrans := RP_SWORD
            else trans.cmdTrans := RP_SDWORD;
        end
        else
        begin
            if (mode=AMCC_MODE_BYTE)
              then trans.cmdTrans := WP_SBYTE
            else
            if (mode=AMCC_MODE_WORD)
              then trans.cmdTrans := WP_SWORD
            else trans.cmdTrans := WP_SDWORD;
        end;
    end;
    trans.dwPort := dwAddr;
    trans.fAutoinc := 1;
    trans.dwBytes := dwBytes;
    trans.dwOptions := 0;
    trans.pBuffer := buf;
    WD_Transfer (hAmcc^.hWD, trans);
end;

procedure AMCC_ReadSpaceBlock (hAmcc: AMCCHANDLE ; dwOffset: DWORD ; buf: Pointer ;
                    dwBytes: DWORD ; addrSpace: AMCC_ADDR );
begin
    AMCC_ReadWriteSpaceBlock (hAmcc, dwOffset, buf, dwBytes, TRUE, addrSpace, AMCC_MODE_DWORD);
end;

procedure AMCC_WriteSpaceBlock (hAmcc: AMCCHANDLE ; dwOffset: DWORD ; buf: Pointer ;
                     dwBytes: DWORD ; addrSpace: AMCC_ADDR );
begin
    AMCC_ReadWriteSpaceBlock (hAmcc, dwOffset, buf, dwBytes, FALSE, addrSpace, AMCC_MODE_DWORD);
end;

//////////////////////////////////////////////////////////////////////////////
// Interrupts
//////////////////////////////////////////////////////////////////////////////

function AMCC_IntIsEnabled (hAmcc: AMCCHANDLE ):BOOL;
begin
    result:=hAmcc^.Int.hThread<>0;
end;

procedure AMCC_IntHandler (pData: Pointer );
var
  hAmcc: AMCCHANDLE;
  intResult: AMCC_INT_RESULT ;
begin
    hAmcc := pData;

    intResult.dwCounter := hAmcc^.Int.Int.dwCounter;
    intResult.dwLost := hAmcc^.Int.Int.dwLost;
    intResult.fStopped := hAmcc^.Int.Int.fStopped<>0;
    intResult.dwStatusReg := hAmcc^.Int.Trans[0].ADword;
    hAmcc^.Int.funcIntHandler(hAmcc, intResult);
end;

function  AMCC_IntEnable (hAmcc: AMCCHANDLE ; funcIntHandler: AMCC_INT_HANDLER ):BOOL;
var
    dwAddr: DWORD ;
    dwStatus: DWORD ;
begin
    // check if interrupt is already enabled
   if (hAmcc^.Int.hThread<>0) then
   begin
      result:=FALSE;
      exit;
    end;
    fillchar(hAmcc^.Int.Trans,sizeof(hAmcc^.Int.Trans),0);
    // This is a sample of handling interrupts:
    // Two transfer commands are issued. First the value of the interrupt control/status
    // register is read. Then, a value of ZERO is written.
    // This will cancel interrupts after the first interrupt occurs.
    // When using interrupts, this section will have to change:
    // you must put transfer commands to CANCEL the source of the interrupt, otherwise, the
    // PC will hang when an interrupt occurs!
    dwAddr := hAmcc^.addrDesc[AMCC_ADDR_REG].dwAddr + INTCSR_ADDR;

    if hAmcc^.addrDesc[AMCC_ADDR_REG].fIsMemory then
    begin
      hAmcc^.Int.Trans[0].cmdTrans := RM_DWORD;
      hAmcc^.Int.Trans[1].cmdTrans := WM_DWORD;
    end
    else
    begin
      hAmcc^.Int.Trans[0].cmdTrans :=  RP_DWORD;
      hAmcc^.Int.Trans[1].cmdTrans :=  WP_DWORD;
    end;

    hAmcc^.Int.Trans[0].dwPort := dwAddr;
    hAmcc^.Int.Trans[1].dwPort := dwAddr;
    hAmcc^.Int.Trans[1].ADword := $8cc000; // put here the data to write to the control register
    hAmcc^.Int.Int.dwCmds := 2;
    hAmcc^.Int.Int.Cmd := @hAmcc^.Int.Trans;
    hAmcc^.Int.Int.dwOptions := hAmcc^.Int.Int.dwOptions OR INTERRUPT_CMD_COPY;

    // this calls WD_IntEnable() and creates an interrupt handler thread
    hAmcc^.Int.funcIntHandler := funcIntHandler;
    dwStatus := InterruptEnable(hAmcc^.Int.hThread, hAmcc^.hWD, hAmcc^.Int.Int, AMCC_IntHandler, hAmcc);
    if (dwStatus)
    {
        sprintf(AMCC_ErrorString, "WD_DMALock() failed with status 0x%x - %s\n",
            dwStatus, Stat2Str(dwStatus));
        return FALSE;
    }

    // add here code to physically enable interrupts,
    // by setting bits in the INTCSR_ADDR register

    return TRUE;
}

procedure AMCC_IntDisable (AMCCHANDLE hAmcc)
{
    if (!hAmcc^.Int.hThread)
        return;

    // add here code to physically disable interrupts,
    // by clearing bits in the INTCSR_ADDR register

    // this calls WD_IntDisable()
    InterruptDisable(hAmcc^.Int.hThread);

    hAmcc^.Int.hThread = NULL;
}

//////////////////////////////////////////////////////////////////////////////
// NVRam
//////////////////////////////////////////////////////////////////////////////

BOOL AMCC_WaitForNotBusy(AMCCHANDLE hAmcc)
{
    BOOL fReady = FALSE;
    time_t timeStart = time(NULL);

    for (; !fReady; )
    {
        if ((AMCC_ReadRegByte(hAmcc, BMCSR_NVCMD_ADDR) & NVRAM_BUSY_BITS) != NVRAM_BUSY_BITS)
        {
            fReady = TRUE;
        }
        else
        {
            if ((time(NULL) - timeStart) > 1) /* More than 1 second? */
                break;
        }
    }

    return fReady;
}

BOOL AMCC_ReadNVByte(AMCCHANDLE hAmcc, DWORD dwAddr, BYTE *pbData)
{
    if (dwAddr >= AMCC_NVRAM_SIZE) return FALSE;
    /* Access non-volatile memory */

    /* Wait for nvRAM not busy */
    if (!AMCC_WaitForNotBusy(hAmcc)) return FALSE;

    /* Load Low address */
    AMCC_WriteRegByte(hAmcc, BMCSR_NVCMD_ADDR, NVCMD_LOAD_LOW_BITS);
    AMCC_WriteRegByte(hAmcc, BMCSR_NVDATA_ADDR, (BYTE) (dwAddr & $ff));

    /* Load High address */
    AMCC_WriteRegByte(hAmcc, BMCSR_NVCMD_ADDR, NVCMD_LOAD_HIGH_BITS);
    AMCC_WriteRegByte(hAmcc, BMCSR_NVDATA_ADDR, (BYTE) (dwAddr >> 8));

    /* Send Begin Read command */
    AMCC_WriteRegByte(hAmcc, BMCSR_NVCMD_ADDR, NVCMD_BEGIN_READ_BITS);

    /* Wait for nvRAM not busy */
    if (!AMCC_WaitForNotBusy(hAmcc)) return FALSE;

    /* Get data from nvRAM Data register */
    *pbData = AMCC_ReadRegByte(hAmcc, BMCSR_NVDATA_ADDR);

    return TRUE;
}

//////////////////////////////////////////////////////////////////////////////
// DMA
//////////////////////////////////////////////////////////////////////////////

BOOL AMCC_DMAOpen(AMCCHANDLE hAmcc, WD_DMA *pDMA, DWORD dwBytes)
{
    DWORD dwStatus;
    AMCC_ErrorString[0] = '\0';
    fillchar(*pDMA);
    pDMA^.pUserAddr = NULL; // the kernel will allocate the buffer
    pDMA^.dwBytes = dwBytes; // size of buffer to allocate
    pDMA^.dwOptions = DMA_KERNEL_BUFFER_ALLOC;
    dwStatus = WD_DMALock(hAmcc^.hWD, pDMA);
    if (dwStatus)
    {
        sprintf(AMCC_ErrorString, "WD_DMALock() failed with status 0x%x - %s\n",
            dwStatus, Stat2Str(dwStatus));
        return FALSE;
    }
    return TRUE;
}

procedure AMCC_DMAClose(AMCCHANDLE hAmcc, WD_DMA *pDMA)
{
    WD_DMAUnlock (hAmcc^.hWD, pDMA);
}

BOOL AMCC_DMAStart(AMCCHANDLE hAmcc, WD_DMA *pDMA, BOOL fRead,
    BOOL fBlocking, DWORD dwBytes, DWORD dwOffset)
{
    DWORD dwBMCSR;

    // Important note:
    // fRead - if TRUE, data moved from the AMCC-card to the PC memory
    // fRead - if FALSE, data moved from the PC memory to the AMCC card
    // the terms used by AMCC are opposite!
    // in AMCC terms - read operation is from PC memory to AMCC card
    AMCC_WriteRegDWord(hAmcc, fRead ? MWAR_ADDR : MRAR_ADDR, (DWORD) pDMA^.Page[0].pPhysicalAddr + dwOffset);
    AMCC_WriteRegDWord(hAmcc, fRead ? MWTC_ADDR : MRTC_ADDR, dwBytes);
    dwBMCSR = AMCC_ReadRegDWord(hAmcc, BMCSR_ADDR);
    dwBMCSR |= fRead ? BIT10 : BIT14;
    AMCC_WriteRegDWord(hAmcc, BMCSR_ADDR, dwBMCSR);
    // if blocking then wait for transfer to complete
    if (fBlocking)
        while (!AMCC_DMAIsDone(hAmcc, fRead));

    return TRUE;
}

BOOL AMCC_DMAIsDone(AMCCHANDLE hAmcc, BOOL fRead)
{
    DWORD dwBIT = fRead ? BIT18 : BIT19;
    DWORD dwINTCSR = AMCC_ReadRegDWord(hAmcc, INTCSR_ADDR);
    if (dwINTCSR & dwBIT)
    {
        AMCC_WriteRegDWord(hAmcc, INTCSR_ADDR, dwBIT);
        return TRUE;
    }
    return FALSE;
}

