unit Windriver0;

interface

uses
    Windows, SysUtils,
    WinDrvr, status_strings, PCI_Regs, Windrvr_Int_Thread, Bits,
    util1,Dgraphic,

    stmDef;


{Notes:
   Si la  carte est installée avec Instacal, le premier appel à la librairie CB
   active l'accès aux registres de la carte en modifiant le registre Command
   de la zone de configuration. Elle installe aussi, sans doute, une routine d'int
   qui provoque un plantage à retardement, si jamais Windriver installe sa
   propre routine d'int.

   On initialise la carte avec PCIcommand:=$107

   Les timers tournent si TrigCtrl bit0<>0 ou bit1<>0


}



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


const
  MaxDataPCIdriver=65536;

type
  TPCIdriver=class;

  T_ADDR_DESC= record
                    dwLocalBase: DWORD ;
                    dwMask:      DWORD ;
                    dwBytes:     DWORD ;
                    dwAddr:      DWORD ;
                    dwAddrDirect:DWORD ;
                    fIsMemory:   BOOL  ;
                  end;


  TPCIdriver=class
  private
    hWD:      THANDLE;
    cardLock: WD_CARD;
    pciSlot:  WD_PCI_SLOT ;
    cardReg:  WD_CARD_REGISTER ;
    addrDesc: array[0..AD_PCI_BARS-1] of T_ADDR_DESC;

    Int:      WD_INTERRUPT ;
    hThread:  HANDLE ;
    Trans:    array[0..5] of SWD_TRANSFER ;


    function DetectCardElements:boolean;

    procedure IOWriteDWord(addrSpace: integer ; dwLocalAddr: DWORD ; data: DWORD );
    function IOReadDWord(addrSpace: integer ; dwLocalAddr: DWORD ):Dword;
    procedure IOWriteWord(addrSpace: integer ; dwLocalAddr: DWORD ; data: WORD );
    function IOReadWord(addrSpace: integer ; dwLocalAddr: DWORD ):word;
    procedure IOWriteByte(addrSpace: integer ; dwLocalAddr: DWORD ; data: byte );
    function IOReadByte(addrSpace: integer ; dwLocalAddr: DWORD ):byte;

    procedure setADCfifo(w:word);
    function getADCfifo:word;

    procedure setADCmux(w:word);
    function getADCmux:word;

    procedure setTrigCtrl(w:word);
    function getTrigCtrl:word;

    procedure setCalib(w:word);
    function getCalib:word;

    procedure setDacCtrl(w:word);
    function getDacCtrl:word;

    procedure setADCdata(w:word);
    function getADCdata:word;

    procedure setADCfifoClear(w:word);
    function getADCfifoClear:word;

    procedure setTimerACnt0(w:byte);
    function getTimerACnt0:byte;

    procedure setTimerACnt1(w:byte);
    function getTimerACnt1:byte;

    procedure setTimerACnt2(w:byte);
    function getTimerACnt2:byte;

    procedure setTimerACtrl(w:byte);
    function getTimerACtrl:byte;


    procedure setTimerBCnt0(w:byte);
    function getTimerBCnt0:byte;

    procedure setTimerBCnt1(w:byte);
    function getTimerBCnt1:byte;

    procedure setTimerBCnt2(w:byte);
    function getTimerBCnt2:byte;

    procedure setTimerBCtrl(w:byte);
    function getTimerBCtrl:byte;

    procedure setDIOportA(w:byte);
    function getDIOportA:byte;

    procedure setDIOportB(w:byte);
    function getDIOportB:byte;

    procedure setDIOportC(w:byte);
    function getDIOportC:byte;

    procedure setDIOCtrl(w:byte);
    function getDIOCtrl:byte;

    procedure setDacData(w:word);
    function getDacData:word;

    procedure setDacFifoClear(w:word);
    function getDacFifoClear:word;

    procedure setIntCSR(w:Dword);
    function getIntCSR:Dword;

    function getDwordReg(dwReg: DWORD ):Dword;
    procedure setDwordReg(dwReg: DWORD;dwData:Dword );
    function getWordReg(dwReg: DWORD ):word;
    procedure setWordReg(dwReg: DWORD;dwData:word );

    function getPCIcommand:word;
    procedure setPCIcommand(Data:word );
    function getPCIstatus:word;
    procedure setPCIstatus(Data:word );


  Public
    cntData:integer;
    LastData:array of smallint;
    cntLost:integer;

    constructor create;
    
    property IntCSR:Dword read getINTCSR write setIntCSR;

    {Accès aux PCI configuration registers}
    property DwordReg[dwreg:Dword]:Dword read getDwordReg write setDwordReg;
    property WordReg[dwreg:Dword]:word read getWordReg write setWordReg;

    property PCIstatus:word read getPCIstatus write setPCIstatus;
    property PCIcommand:word read getPCIcommand write setPCIcommand;

    {Accès aux plages IO addrSpace de 0 à 5}
    property IOWord[addrSpace: integer; dwLocalAddr: DWORD]:word read IOreadword write IOwriteword;
    property IODWord[addrSpace: integer; dwLocalAddr: DWORD]:Dword read IOreadDword write IOwriteDword;

    {Accès aux registres de la PCI-DAS1600}
    property ADCfifo:word read getADCfifo write setADCfifo ;
    property ADCmux:word read getADCmux write setADCmux;
    property TrigCtrl:word read getTrigCtrl write setTrigCtrl;
    property Calib:word read getCalib write setCalib;
    property DacCtrl:word read getDacCtrl write setDacCtrl;
    property ADCdata:word read getADCdata write setADCdata;
    property ADCfifoClear:word read getADCfifoClear write setADCfifoClear;

    property TimerACnt0:byte read getTimerACnt0 write setTimerACnt0;
    property TimerACnt1:byte read getTimerACnt1 write setTimerACnt1;
    property TimerACnt2:byte read getTimerACnt2 write setTimerACnt2;
    property TimerACtrl:byte read getTimerACtrl write setTimerACtrl;

    property TimerBCnt0:byte read getTimerBCnt0 write setTimerBCnt0;
    property TimerBCnt1:byte read getTimerBCnt1 write setTimerBCnt1;
    property TimerBCnt2:byte read getTimerBCnt2 write setTimerBCnt2;
    property TimerBCtrl:byte read getTimerBCtrl write setTimerBCtrl;

    property DIOportA:byte read getDIOportA write setDIOportA;
    property DIOportB:byte read getDIOportB write setDIOportB;
    property DIOportC:byte read getDIOportC write setDIOportC;
    property DIOCtrl:byte read getDIOCtrl write setDIOCtrl;

    property DacData:word read getDacData write setDacData;
    property DacFifoClear:word read getDacFifoClear write setDacFifoClear;

    property IntInfo:WD_interrupt read int;
    {Lecture des timers}

    function getTimerA0:integer;
    function getTimerA1:integer;
    function getTimerA2:integer;

    function getTimerB0:integer;
    function getTimerB1:integer;
    function getTimerB2:integer;

    {Essais }
    procedure ProgTimer0;
    procedure SetAcq(sampInt:integer);
    procedure DoneAcq;
    procedure Interruption;

    procedure Dump;

    {Ouverture et fermeture du driver}

    function Open(dwVendorID, dwDeviceID, nCardNum:integer):boolean;
    procedure Close;


    Destructor destroy;override;

  end;


procedure testPCIdriver;

implementation




{ TPCIdriver }


constructor TPCIdriver.create;
begin
  setLength(lastData,maxDataPCIdriver);
end;

procedure TPCIdriver.Close;
begin
  if (cardReg.hCard<>0) then WD_CardUnregister(hWD, cardReg);
  cardReg.hCard:=0;
  if hWD<>0 then WD_close(hWD);
  hWD:=0;
end;

destructor TPCIdriver.destroy;
begin
  close;
end;

function TPCIdriver.DetectCardElements: boolean;
var
  i, ad_sp: integer;
  pItem:^WD_ITEMS;
begin
  result:=false;

  for i:=0 to cardReg.Card.dwItems-1 do
  begin
     pItem := @cardReg.Card.Item[i];

     case pItem^.item of
        ITEM_MEMORY:
        begin
          ad_sp := pItem^.Memory.dwBar;
          addrDesc[ad_sp].fIsMemory := TRUE;
          addrDesc[ad_sp].dwBytes := pItem^.Memory.dwMBytes;
          addrDesc[ad_sp].dwAddr := pItem^.Memory.dwTransAddr;
          addrDesc[ad_sp].dwAddrDirect := pItem^.Memory.dwUserDirectAddr;
          addrDesc[ad_sp].dwMask := Not addrDesc[ad_sp].dwBytes;
        end;

        ITEM_IO:
        begin
          ad_sp := pItem^.IO.dwBar;
          addrDesc[ad_sp].fIsMemory := FALSE;
          addrDesc[ad_sp].dwBytes := pItem^.Memory.dwMBytes;
          addrDesc[ad_sp].dwAddr := pItem^.IO.dwAddr;
          addrDesc[ad_sp].dwMask := Not addrDesc[ad_sp].dwBytes;
        end;

        ITEM_INTERRUPT:
        begin
          if (Int.hInterrupt<>0)
            then exit
            else Int.hInterrupt := pItem^.Interrupt.hInterrupt;
        end;
      end;
  end;

  // check that the registers space was found
  if addrDesc[AD_PCI_BAR0].dwAddr=0 then exit;

  result:= TRUE;
end;

function TPCIdriver.Open(dwVendorID, dwDeviceID,nCardNum: integer): boolean;
const
  licenseString:string='0af68c0b90ac.UNIC-CNRS';
var
  ver:SWD_VERSION ;
  pciScan: WD_PCI_SCAN_CARDS ;
  pciCardInfo: WD_PCI_CARD_INFO ;
  dwStatus: DWORD ;
  license:SWD_license;
begin
  result:=false;
  hWD := WD_Open;

  if hWD=INVALID_HANDLE_VALUE then exit;

  fillchar(license,sizeof(license),0);
  move(licenseString[1],license.cLicense,length(licenseString));
  wd_license(hWD,license);

  fillchar(ver,sizeof(ver),0);
  WD_Version(hWD,ver);
  if (ver.dwVer<WD_VER) then exit;

  fillchar(pciScan,sizeof(pciScan),0);
  pciScan.searchId.dwVendorId := dwVendorID;
  pciScan.searchId.dwDeviceId := dwDeviceID;
  dwStatus := WD_PciScanCards (hWD, pciScan);

  if dwStatus<>0 then messageCentral(stat2str(dwStatus));

  if (dwStatus<>0) OR (pciScan.dwCards=0) OR (pciScan.dwCards<=nCardNum) then exit;

  fillchar(pciCardInfo,sizeof(pciCardInfo),0);
  pciCardInfo.pciSlot := pciScan.cardSlot[nCardNum];
  WD_PciGetCardInfo (hWD, pciCardInfo);
  pciSlot := pciCardInfo.pciSlot;
  cardReg.Card := pciCardInfo.Card;

  cardReg.fCheckLockOnly := 0;
  dwStatus := WD_CardRegister(hWD, cardReg);
  if (dwStatus<>0) OR (cardReg.hCard=0) OR  not DetectCardElements then exit;

  result:=true;
end;

procedure TPCIdriver.IOWriteDWord(addrSpace: integer ; dwLocalAddr: DWORD ; data: DWORD );
var
  dwAddr: DWORD ;
  trans: SWD_TRANSFER ;
begin
  dwAddr := addrDesc[addrSpace].dwAddr + dwLocalAddr;
  fillchar(trans,sizeof(trans),0);
  trans.cmdTrans := WP_DWORD;
  trans.dwPort := dwAddr;
  trans.ADword := data;
  WD_Transfer (hWD, trans);
end;

function TPCIdriver.IOReadDWord(addrSpace: integer ; dwLocalAddr: DWORD ):Dword;
var
  dwAddr: DWORD;
  trans: SWD_TRANSFER ;
begin
  dwAddr := addrDesc[addrSpace].dwAddr + dwLocalAddr;
  fillchar(trans,sizeof(trans),0);
  trans.cmdTrans := RP_DWORD;
  trans.dwPort := dwAddr;
  WD_Transfer (hWD, trans);
  result:= trans.ADword;
end;



procedure TPCIdriver.IOWriteByte(addrSpace: integer;dwLocalAddr: DWORD;data: byte);
var
  trans: SWD_TRANSFER ;
begin
  fillchar(trans,sizeof(trans),0);
  trans.cmdTrans := WP_BYTE;
  trans.dwPort := addrDesc[addrSpace].dwAddr + dwLocalAddr;
  trans.Abyte := data;
  WD_Transfer (hWD, trans);
end;

function TPCIdriver.IOReadByte(addrSpace: integer;dwLocalAddr: DWORD): byte;
var
  dwAddr: DWORD;
  trans: SWD_TRANSFER ;
  res:Dword;
begin
  dwAddr := addrDesc[addrSpace].dwAddr + dwLocalAddr;
  fillchar(trans,sizeof(trans),0);
  trans.cmdTrans := RP_BYTE;
  trans.dwPort := dwAddr;
  res:=WD_Transfer (hWD, trans);
  if res<>0 then messageCentral(stat2str(res));
  result:= trans.Abyte;
end;

procedure TPCIdriver.IOWriteWord(addrSpace: integer; dwLocalAddr: DWORD;data: WORD);
var
  dwAddr: DWORD ;
  trans: SWD_TRANSFER ;
begin
  dwAddr := addrDesc[addrSpace].dwAddr + dwLocalAddr;
  fillchar(trans,sizeof(trans),0);
  trans.cmdTrans := WP_WORD;
  trans.dwPort := dwAddr;
  trans.Aword := data;
  WD_Transfer (hWD, trans);
end;


function TPCIdriver.IOReadWord(addrSpace: integer;dwLocalAddr: DWORD): word;
var
  dwAddr: DWORD;
  trans: SWD_TRANSFER ;
begin
  dwAddr := addrDesc[addrSpace].dwAddr + dwLocalAddr;
  fillchar(trans,sizeof(trans),0);
  trans.cmdTrans := RP_WORD;
  trans.dwPort := dwAddr;
  WD_Transfer (hWD, trans);
  result:= trans.Aword;
end;



function TPCIdriver.getADCfifo: word;
begin
  result:=IOreadWord(1,0);
end;

procedure TPCIdriver.setADCfifo(w: word);
begin
  IOwriteWord(1,0,w);
end;

function TPCIdriver.getADCMux: word;
begin
  result:=IOreadWord(1,2);
end;

procedure TPCIdriver.setADCMux(w: word);
begin
  IOwriteWord(1,2,w);
end;

function TPCIdriver.getTrigCtrl: word;
begin
  result:=IOreadWord(1,4);
end;

procedure TPCIdriver.setTrigCtrl(w: word);
begin
  IOwriteWord(1,4,w);
end;

function TPCIdriver.getCalib: word;
begin
  result:=IOreadWord(1,6);
end;

procedure TPCIdriver.setCalib(w: word);
begin
  IOwriteWord(1,6,w);
end;

function TPCIdriver.getDacCtrl: word;
begin
  result:=IOreadWord(1,8);
end;

procedure TPCIdriver.setDacCtrl(w: word);
begin
  IOwriteWord(1,8,w);
end;


function TPCIdriver.getADCdata: word;
begin
  result:=IOreadWord(2,0);
end;

procedure TPCIdriver.setADCdata(w: word);
begin
  IOwriteWord(2,0,w);
end;


function TPCIdriver.getADCfifoClear: word;
begin
  result:=IOreadWord(2,2);
end;

procedure TPCIdriver.setADCfifoClear(w: word);
begin
  IOwriteWord(2,2,w);
end;


function TPCIdriver.getDacData: word;
begin
  result:=IOreadWord(4,0);
end;

procedure TPCIdriver.setDacData(w: word);
begin
  IOwriteWord(4,0,w);
end;


function TPCIdriver.getDacFifoClear: word;
begin
  result:=IOreadWord(4,2);
end;

procedure TPCIdriver.setDacFifoClear(w: word);
begin
  IOwriteWord(4,2,w);
end;


function TPCIdriver.getDIOCtrl: byte;
begin
  result:=IOreadbyte(3,7);
end;

function TPCIdriver.getDIOportA: byte;
begin
  result:=IOreadbyte(3,4);
end;

function TPCIdriver.getDIOportB: byte;
begin
  result:=IOreadbyte(3,5);
end;

function TPCIdriver.getDIOportC: byte;
begin
  result:=IOreadbyte(3,6);
end;

function TPCIdriver.getTimerACnt0: byte;
begin
  result:=IOreadbyte(3,0);
end;

function TPCIdriver.getTimerACnt1: byte;
begin
  result:=IOreadbyte(3,1);
end;

function TPCIdriver.getTimerACnt2: byte;
begin
  result:=IOreadbyte(3,2);
end;

function TPCIdriver.getTimerACtrl: byte;
begin
  result:=IOreadbyte(3,3);
end;

function TPCIdriver.getTimerBCnt0: byte;
begin
  result:=IOreadbyte(3,8);
end;

function TPCIdriver.getTimerBCnt1: byte;
begin
  result:=IOreadbyte(3,9);
end;

function TPCIdriver.getTimerBCnt2: byte;
begin
  result:=IOreadbyte(3,10);
end;

function TPCIdriver.getTimerBCtrl: byte;
begin
  result:=IOreadbyte(3,11);
end;


procedure TPCIdriver.setDIOCtrl(w: byte);
begin
  IOwriteByte(3,7,w);
end;

procedure TPCIdriver.setDIOportA(w: byte);
begin
  IOwriteByte(3,4,w);
end;

procedure TPCIdriver.setDIOportB(w: byte);
begin
  IOwriteByte(3,5,w);
end;

procedure TPCIdriver.setDIOportC(w: byte);
begin
  IOwriteByte(3,6,w);
end;

procedure TPCIdriver.setTimerACnt0(w: byte);
begin
  IOwriteByte(3,0,w);
end;

procedure TPCIdriver.setTimerACnt1(w: byte);
begin
  IOwriteByte(3,1,w);
end;

procedure TPCIdriver.setTimerACnt2(w: byte);
begin
  IOwriteByte(3,2,w);
end;

procedure TPCIdriver.setTimerACtrl(w: byte);
begin
  IOwriteByte(3,3,w);
end;

procedure TPCIdriver.setTimerBCnt0(w: byte);
begin
  IOwriteByte(3,8,w);
end;

procedure TPCIdriver.setTimerBCnt1(w: byte);
begin
  IOwriteByte(3,9,w);
end;

procedure TPCIdriver.setTimerBCnt2(w: byte);
begin
  IOwriteByte(3,10,w);
end;

procedure TPCIdriver.setTimerBCtrl(w: byte);
begin
  IOwriteByte(3,11,w);
end;

function TPCIdriver.getIntCSR: Dword;
begin
  result:=IOreadDWord(0,INTCSR_ADDR);
end;

procedure TPCIdriver.setINTCSR(w: Dword);
begin
  IOwriteDWord(0,INTCSR_ADDR,w);
end;



function TPCIdriver.getDwordReg(dwReg: DWORD): Dword;
var
  pciCnf: WD_PCI_CONFIG_DUMP ;
  dwVal: DWORD ;
begin
  fillchar(pciCnf,sizeof(pciCnf),0);
  pciCnf.pciSlot := pciSlot;
  pciCnf.pBuffer := @dwVal;
  pciCnf.dwOffset := dwReg;
  pciCnf.dwBytes := 4;
  pciCnf.fIsRead := 1;
  WD_PciConfigDump(hWD,pciCnf);
  result:= dwVal;
end;


procedure TPCIdriver.setDwordReg(dwReg: DWORD;dwData:Dword);
var
  pciCnf: WD_PCI_CONFIG_DUMP ;
begin
  fillchar (pciCnf,sizeof(pciCnf),0);
  pciCnf.pciSlot := pciSlot;
  pciCnf.pBuffer := @dwData;
  pciCnf.dwOffset := dwReg;
  pciCnf.dwBytes := 4;
  pciCnf.fIsRead := 0;
  WD_PciConfigDump(hWD,pciCnf);
end;



function TPCIdriver.getWordReg(dwReg: DWORD): word;
var
  pciCnf: WD_PCI_CONFIG_DUMP ;
  dwVal: WORD ;
begin
  fillchar(pciCnf,sizeof(pciCnf),0);
  pciCnf.pciSlot := pciSlot;
  pciCnf.pBuffer := @dwVal;
  pciCnf.dwOffset := dwReg;
  pciCnf.dwBytes := 2;
  pciCnf.fIsRead := 1;
  WD_PciConfigDump(hWD,pciCnf);
  result:= dwVal;
end;


procedure TPCIdriver.setWordReg(dwReg: DWORD;dwData:word);
var
  pciCnf: WD_PCI_CONFIG_DUMP ;
begin
  fillchar (pciCnf,sizeof(pciCnf),0);
  pciCnf.pciSlot := pciSlot;
  pciCnf.pBuffer := @dwData;
  pciCnf.dwOffset := dwReg;
  pciCnf.dwBytes := 2;
  pciCnf.fIsRead := 0;
  WD_PciConfigDump(hWD,pciCnf);
end;


function TPCIdriver.getPCIcommand: word;
begin
  result:=wordReg[4];
end;

procedure TPCIdriver.setPCIcommand(Data: word);
begin
  wordReg[4]:=data;
end;

function TPCIdriver.getPCIstatus: word;
begin
  result:=wordReg[6];
end;

procedure TPCIdriver.setPCIstatus(Data: word);
begin
  wordReg[6]:=data;
end;

procedure TPCIdriver.ProgTimer0;
begin
  TimerActrl:=$34;
  TimerAcnt0:=128;
  TimerAcnt0:=0;

  TimerActrl:=$B4;
  TimerAcnt2:=100;
  TimerAcnt2:=0;

  TimerActrl:=$74;
  TimerAcnt1:=0;
  TimerAcnt1:=0;

  TimerBctrl:=$34;
  TimerBcnt0:=128;
  TimerBcnt0:=0;

  TimerBctrl:=$B4;
  TimerBcnt2:=100;
  TimerBcnt2:=0;

  TimerBctrl:=$74;
  TimerBcnt1:=0;
  TimerBcnt1:=0;

  TrigCtrl:=bit1;
  ADCmux:=bit12;
end;

function TPCIdriver.getTimerA0:integer;
begin
  TimerActrl:=0;
  result:= TimerAcnt0 + TimerAcnt0 shl 8;
end;

function TPCIdriver.getTimerA1:integer;
begin
  TimerActrl:=$40;
  result:= TimerAcnt1 + TimerAcnt1 shl 8;
end;

function TPCIdriver.getTimerA2:integer;
begin
  TimerActrl:=$80;
  result:= TimerAcnt2 + TimerAcnt2 shl 8;
end;


function TPCIdriver.getTimerB0: integer;
begin
  TimerBctrl:=0;
  result:= TimerBcnt0 + TimerBcnt0 shl 8;
end;

function TPCIdriver.getTimerB1: integer;
begin
  TimerBctrl:=$40;
  result:= TimerBcnt1 + TimerBcnt1 shl 8;
end;

function TPCIdriver.getTimerB2: integer;
begin
  TimerBctrl:=$80;
  result:= TimerBcnt2 + TimerBcnt2 shl 8;
end;

procedure TPCIdriver.Interruption;
var
  x:word;
  i:integer;
begin
  LastData[cntData mod maxDataPCIdriver]:=trans[0].AWord;

  DacFifoClear:=1;
  DacCtrl:=bit0+bit1+bit2+bit5+bit8;
  DacData:=LastData[cntData mod maxDataPCIdriver];
  inc(cntData);

  cntLost:=cntLost+int.dwlost;
end;

procedure Interrupt(data:pointer);
begin
  TPCIdriver(data).Interruption;
end;

procedure TPCIdriver.SetAcq(sampInt:integer);
var
  cnt1,cnt2:integer;{La période est cnt1*cnt2*E-7 secondes}
  res:Dword;
  i:integer;
const
  vv:array[1..10] of integer=(2,3,5,7,11,13,17,19,23,29);
begin
  for i:=0 to maxDataPCIdriver-1 do
    lastData[i]:=round(2048+2000*sin(2*pi/1000*i));
  DacCtrl:=bit0;
  DacFifoClear:=1;

  wordReg[4]:=$107;

  cntData:=0;
  cntLost:=0;

  cnt1:=sampInt*10;
  cnt2:=1;

  repeat
    for i:=1 to 10 do
      if cnt1 mod vv[i]=0 then
      begin
        cnt1:=cnt1 div vv[i];
        cnt2:=cnt2*vv[i];
        break;
      end;
  until cnt1<65536;

  TrigCtrl:=0;                       { Timers OFF }

  TimerActrl:=$B4;                   { Mode 2 Cnt=période }
  TimerAcnt2:=cnt2 and $FF;
  TimerAcnt2:=(cnt2 shr 8) and $FF;

  TimerActrl:=$74;
  TimerAcnt1:=cnt1 and $FF;
  TimerAcnt1:=(cnt1 shr 8) and $FF;

  ADCmux:=bit12 + bit10;                    { ADCmux }

                                    { Installer Int }
  fillchar(Trans,sizeof(Trans),0);

  Trans[0].cmdTrans :=  RP_WORD;                             { ADCdata  }
  Trans[0].dwPort := addrDesc[2].dwAddr + 0;

  Trans[1].cmdTrans :=  WP_WORD;                             { ADCfifo  }
  Trans[1].dwPort := addrDesc[1].dwAddr + 0;                 { reset status int }
  Trans[1].Aword:=bit5+bit6+bit7+bit13+bit14 +bit0 +bit1 +bit2;

  Trans[2].cmdTrans :=  WP_DWORD;
  Trans[2].dwPort := addrDesc[0].dwAddr + INTCSR_ADDR;       { INTCSR reset int bits }
  Trans[2].ADword := bit16 + bit17 + bit18 + bit19 +$1F00;

  Trans[3].cmdTrans :=  WP_WORD;                             { ADCfifoClear  }
  Trans[3].dwPort := addrDesc[2].dwAddr + 2;                 {  }
  Trans[3].Aword:=0;


  Int.dwCmds := 3;
  Int.Cmd := @Trans[0];
  Int.dwOptions := INTERRUPT_LEVEL_SENSITIVE OR INTERRUPT_CMD_COPY ;


  res := InterruptEnable1(@hThread, hWD,@Int,interrupt, self);
  if res<>0 then  messageCentral('InterruptEnable:  '+stat2str(res));


  ADCfifoClear:=0;                      {Clear FIFO }
  DACfifoClear:=0;                      {Clear DAC FIFO }

  ADCfifo:=bit5+bit6+bit7+bit13+bit14;  {Clear status flags }
  ADCfifo:=bit0 +bit1+bit2;


  IntCsr:=$1F00 +bit16 + bit17 + bit18 + bit19 ;

  TrigCtrl:=bit1;


end;

procedure TPCIdriver.DoneAcq;
var
  res:integer;
begin

  ADCfifo:=bit5+bit6+bit7+bit13+bit14;  {Clear status flags }
  ADCfifo:=0;
  TrigCtrl:=0;                       { Timers OFF }
  ADCmux:=0;                         { ADCmux }

  IntCsr:=0;
  if hThread<>0 then
  begin
    IntCSR:=bit16 + bit17 + bit18 + bit19;
    IntCSR:=0;

    res:=InterruptDisable(hThread);
    {if res<>0 then  messageCentral('InterruptDisable:  '+Istr(res));}
  end;
  hThread := 0;
  wordreg[4]:=0;
end;

procedure TPCIdriver.Dump;
var
  i:integer;
  dd:Dword;
  st:string;
begin
  st:='';

  for i:=0 to 15 do
  begin
    dd:=IOreadDWord(0,i*4);
    st:=st+LongTohexa(dd)+'    ';
    if (i>0) and (i mod 8=0) then st:=st+CRLF;
  end;

  messageCentral(st);
end;



var
  driver:TPCIdriver;

procedure TestPCIdriver;
var
  w:integer;
begin
  try
    driver:=TPCIdriver.Create;
    with driver do
    begin
      if not Open($1307,$10,0) then
      begin
        messageCentral('PCIdriver not open');
        free;
        driver:=nil;
        exit;
      end;

      {messageCentral('reg='+Hexa(wordreg[4]));}
      
      {messageCentral('reg='+Hexa(wordreg[4]));}

      setAcq(50);

      repeat
        statusLineTxt1('cnt='+Istr(cntData)
                      +'  Timers='+Istr(getTimerA1)+'   '+Istr(getTimerA2)
                      +'  ADCfifo='+hexa(ADCfifo)
                      +'  IntCsr='+LongTohexa(IntCsr)
                      +'  MB empty full='+LongTohexa(Wordreg[$34])
                      +'  fEnableOk='+Istr(int.fEnableOk)
                      +'  dwCounter='+Istr(int.dwCounter)
                      +'  dwLost='+Istr(int.dwlost)
                      +'  fStopped='+Istr(int.fStopped)

                       );


      until testEscape;

      doneAcq;

      Close;
    end;
  finally
  driver.free;
  end;
end;







end.
