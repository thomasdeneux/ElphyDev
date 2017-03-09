unit LCR1;

interface

uses util1,stmObj,stmPG, ncdef2, LCR_api;


type
  TLCR = class(typeUO)
           ok:boolean;
           constructor create;override;
           destructor destroy;override;
           class function stmClassName: AnsiString; override;
         end;

procedure proTLCR_create(var pu:typeUO);pascal;

function fonctionTLCR_SetLedCurrents(Red, Green, Blue: byte; var pu:typeUO): integer;pascal;
function fonctionTLCR_GetLedCurrents(var Red, Green, Blue: byte;var pu:typeUO): integer;pascal;
function fonctionTLCR_GetMode(var Mode: boolean;var pu:typeUO): integer;pascal;
function fonctionTLCR_SetMode(mode: boolean;var pu:typeUO): integer;pascal;

function fonctionTLCR_SetInputSource (source: longword ; portWidth: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetInputSource (var pSource: longword ; var portWidth: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPixelFormat (format: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPixelFormat (var pFormat: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPortClock (clock: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPortClock (var pClock: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetDataChannelSwap (port: longword ; swap: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetDataChannelSwap (var pPort: longword ; var pSwap: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetFPD_Mode_Field (PixelMappingMode: longword ; SwapPolarity: boolean ; FieldSignalSelect: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetFPD_Mode_Field (var pPixelMappingMode: longword ; var pSwapPolarity: boolean ; var pFieldSignalSelect: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPowerMode (w:boolean;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetLongAxisImageFlip (w:boolean;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetLongAxisImageFlip (var pu: typeUO): boolean;pascal;
function fonctionTLCR_SetShortAxisImageFlip (w:boolean;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetShortAxisImageFlip (var pu: typeUO): boolean;pascal;
function fonctionTLCR_SetTPGSelect (pattern: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetTPGSelect (var pPattern: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetLEDPWMInvert (invert: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetLEDPWMInvert (var inverted: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetLedEnables (SeqCtrl: boolean ; Red: boolean ; Green: boolean ; Blue: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetLedEnables (var pSeqCtrl: boolean ; var pRed: boolean ; var pGreen: boolean ; var pBlue: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetVersion (var pApp_ver: longword ; var pAPI_ver: longword ; var pSWConfig_ver: longword ; var pSeqConfig_ver: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SoftwareReset (var pu: typeUO): integer;pascal;
function fonctionTLCR_GetStatus (var pHWStatus: byte ; var pSysStatus: byte ; var pMainStatus: byte ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPWMEnable (channel: longword ; Enable: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPWMEnable (channel: longword ; var pEnable: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPWMConfig (channel: longword ; pulsePeriod: longword ; dutyCycle: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPWMConfig (channel: longword ; var pPulsePeriod: longword ; var pDutyCycle: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPWMCaptureConfig (channel: longword ; enable: boolean ; sampleRate: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPWMCaptureConfig (channel: longword ; var pEnabled: boolean ; var pSampleRate: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetGPIOConfig (pinNum: longword ; enAltFunc: boolean ; altFunc1: boolean ; dirOutput: boolean ; outTypeOpenDrain: boolean ; pinState: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetGPIOConfig (pinNum: longword ; var pEnAltFunc: boolean ; var pAltFunc1: boolean ; var pDirOutput: boolean ; var pOutTypeOpenDrain: boolean ; var pState: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetDisplay (croppedArea: TLCRrectangle ; displayArea: TLCRrectangle ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetDisplay (var pCroppedArea: TLCRrectangle ; var pDisplayArea: TLCRrectangle ;var pu: typeUO): integer;pascal;
function fonctionTLCR_MemRead (addr: longword ; var readWord: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_MemWrite (addr: longword ; data: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_ValidatePatLutData (var pStatus: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPatternDisplayMode ( w:boolean;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPatternDisplayMode (var w: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetTrigOutConfig (trigOutNum: longword ; invert: boolean ; rising: longword ; falling: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetTrigOutConfig (trigOutNum: longword ; var pInvert: boolean ;var pRising: longword ; var pFalling: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetRedLEDStrobeDelay (rising: byte ; falling: byte ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetGreenLEDStrobeDelay (rising: byte ; falling: byte ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetBlueLEDStrobeDelay (rising: byte ; falling: byte ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetRedLEDStrobeDelay (var rising, falling: byte ;var pu: typeUO): integer ;pascal;
function fonctionTLCR_GetGreenLEDStrobeDelay (var rising, falling: byte ;var pu: typeUO): integer ;pascal;
function fonctionTLCR_GetBlueLEDStrobeDelay (var rising, falling: byte ;var pu: typeUO): integer ;pascal;
function fonctionTLCR_EnterProgrammingMode (var pu: typeUO): integer;pascal;
function fonctionTLCR_ExitProgrammingMode (var pu: typeUO): integer;pascal;
//  LCR_GetProgrammingMode: function(var ProgMode: boolean ;var pu: typeUO): integer;cdecl;
function fonctionTLCR_GetFlashManID ( var manID: word ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetFlashDevID (var devID: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetBLStatus (var BL_Status: byte ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetFlashAddr (Addr: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_FlashSectorErase (var pu: typeUO): integer;pascal;
function fonctionTLCR_SetDownloadSize (dataLen: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_DownloadData (var pByteArray: byte ; dataLen: longword ;var pu: typeUO): integer;pascal;
procedure proTLCR_WaitForFlashReady(var pu:typeUO)  ;pascal;
function fonctionTLCR_SetFlashType (tp: byte;var pu: typeUO): integer;pascal;
function fonctionTLCR_CalculateFlashChecksum (var pu: typeUO): integer;pascal;
function fonctionTLCR_GetFlashChecksum (var checksum: longword;var pu: typeUO): integer;pascal;
function fonctionTLCR_LoadSplash (index: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetSplashIndex (var pIndex: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetTPGColor (redFG: word ; greenFG: word ; blueFG: word ; redBG: word ; greenBG: word ; blueBG: word ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetTPGColor (var pRedFG: word ; var pGreenFG: word ; var pBlueFG: word ; var pRedBG: word ; var pGreenBG: word ; var pBlueBG: word ;var pu: typeUO): integer;pascal;
function fonctionTLCR_ClearPatLut (var pu: typeUO): integer;pascal;
function fonctionTLCR_AddToPatLut (TrigType: integer ; PatNum: integer ;BitDepth: integer ;LEDSelect: integer ;InvertPat: boolean ; InsertBlack: boolean ;BufSwap: boolean ; trigOutPrev: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPatLutItem (index: integer ; var pTrigType: integer ; var pPatNum: integer ;var pBitDepth: integer ;var pLEDSelect: integer ;var pInvertPat: boolean ; var pInsertBlack: boolean ;var pBufSwap: boolean ; var pTrigOutPrev: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SendPatLut (var pu: typeUO): integer;pascal;
function fonctionTLCR_SendSplashLut ( var lutEntries: byte ; numEntries: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPatLut (numEntries: integer ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetSplashLut (var pLut: byte ; numEntries: integer ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPatternTriggerMode (w:boolean;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPatternTriggerMode (var w:boolean;var pu: typeUO): integer;pascal;
function fonctionTLCR_PatternDisplay (Action: integer ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetPatternConfig (numLutEntries: longword ; rep: boolean ; numPatsForTrigOut2: longword ; numSplash: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetPatternConfig (var pNumLutEntries: longword ; var pRepeat: boolean ; var pNumPatsForTrigOut2: longword ; var pNumSplash: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetExposure_FramePeriod (exposurePeriod: longword ; framePeriod: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetExposure_FramePeriod (var pExposure: longword ; var pFramePeriod: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetTrigIn1Delay (Delay: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetTrigIn1Delay (var pDelay: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetInvertData (invert: boolean ;var pu: typeUO): integer;pascal;
function fonctionTLCR_PWMCaptureRead (channel: longword ; var pLowPeriod: longword ; var pHighPeriod: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_SetGeneralPurposeClockOutFreq (clkId: longword ; enable: boolean ; clkDivider: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_GetGeneralPurposeClockOutFreq (clkId: longword ; var pEnabled: boolean ; var pClkDivider: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_MeasureSplashLoadTiming (startIndex: longword ; numSplash: longword ;var pu: typeUO): integer;pascal;
function fonctionTLCR_ReadSplashLoadTiming (var pTimingData: longword ;var pu: typeUO): integer;pascal;


implementation

{ TLCR }

constructor TLCR.create;
begin
  inherited;
  if not InitLCRlib then sortieErreur('Unable to initialize LCR library');

  if USB_Init()<>0 then  sortieErreur('Unable to initialize USB');

  if USB_IsConnected() then USB_Close();

  if USB_Open()<>0 then  sortieErreur('Unable to Open USB');
  if  not USB_IsConnected() then sortieErreur('LCR : USB not connected');

  ok:=true;
end;

destructor TLCR.destroy;
begin
  if ok then
  begin
    if USB_IsConnected() then USB_Close();
    USB_exit;
  end;

  inherited;
end;


class function TLCR.stmClassName: AnsiString;
begin
  result:= 'LCR';
end;

{ Méthodes stm }
procedure proTLCR_create(var pu:typeUO);
begin
  createPgObject('',pu,TLCR);
end;


function fonctionTLCR_SetLedCurrents(Red, Green, Blue: byte; var pu:typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetLedCurrents(Red, Green, Blue);
end;

function fonctionTLCR_GetLedCurrents(var Red, Green, Blue: byte;var pu:typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetLedCurrents(Red, Green, Blue);
end;

function fonctionTLCR_GetMode(var Mode: boolean;var pu:typeUO): integer;
var
  Lmode: boolean;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then
  begin
    result:=LCR_GetMode(Lmode);
    mode:=Lmode;
  end;
end;

function fonctionTLCR_SetMode(mode: boolean;var pu:typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:= LCR_SetMode(mode);
end;

function fonctionTLCR_SetInputSource (source: longword ; portWidth: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetInputSource (source,portWidth );
end;

function fonctionTLCR_GetInputSource (var pSource: longword ; var portWidth: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetInputSource (pSource , portWidth );
end;

function fonctionTLCR_SetPixelFormat (format: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPixelFormat (format );
end;

function fonctionTLCR_GetPixelFormat (var pFormat: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPixelFormat (pFormat );
end;

function fonctionTLCR_SetPortClock (clock: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPortClock (clock );
end;

function fonctionTLCR_GetPortClock (var pClock: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPortClock ( pClock );
end;

function fonctionTLCR_SetDataChannelSwap (port: longword ; swap: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetDataChannelSwap (port ,swap );
end;

function fonctionTLCR_GetDataChannelSwap (var pPort: longword ; var pSwap: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetDataChannelSwap ( pPort, pSwap );
end;

function fonctionTLCR_SetFPD_Mode_Field (PixelMappingMode: longword ; SwapPolarity: boolean ; FieldSignalSelect: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetFPD_Mode_Field (PixelMappingMode, SwapPolarity, FieldSignalSelect);
end;

function fonctionTLCR_GetFPD_Mode_Field (var pPixelMappingMode: longword ; var pSwapPolarity: boolean ; var pFieldSignalSelect: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetFPD_Mode_Field ( pPixelMappingMode, pSwapPolarity, pFieldSignalSelect);
end;

function fonctionTLCR_SetPowerMode (w:boolean;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPowerMode (w);
end;

function fonctionTLCR_SetLongAxisImageFlip (w:boolean;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetLongAxisImageFlip (w);
end;

function fonctionTLCR_GetLongAxisImageFlip (var pu: typeUO): boolean;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetLongAxisImageFlip();
end;

function fonctionTLCR_SetShortAxisImageFlip (w:boolean;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetShortAxisImageFlip (w);
end;

function fonctionTLCR_GetShortAxisImageFlip (var pu: typeUO): boolean;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetShortAxisImageFlip();
end;

function fonctionTLCR_SetTPGSelect (pattern: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetTPGSelect (pattern);
end;

function fonctionTLCR_GetTPGSelect (var pPattern: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetTPGSelect (pPattern);
end;

function fonctionTLCR_SetLEDPWMInvert (invert: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetLEDPWMInvert (invert);
end;

function fonctionTLCR_GetLEDPWMInvert (var inverted: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetLEDPWMInvert ( inverted);
end;

function fonctionTLCR_SetLedEnables (SeqCtrl: boolean ; Red: boolean ; Green: boolean ; Blue: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetLedEnables (SeqCtrl, Red, Green, Blue);
end;

function fonctionTLCR_GetLedEnables (var pSeqCtrl: boolean ; var pRed: boolean ; var pGreen: boolean ; var pBlue: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetLedEnables (pSeqCtrl, pRed, pGreen, pBlue);
end;

function fonctionTLCR_GetVersion (var pApp_ver: longword ; var pAPI_ver: longword ; var pSWConfig_ver: longword ; var pSeqConfig_ver: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetVersion (pApp_ver, pAPI_ver, pSWConfig_ver, pSeqConfig_ver);
end;

function fonctionTLCR_SoftwareReset (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SoftwareReset;
end;

function fonctionTLCR_GetStatus (var pHWStatus: byte ; var pSysStatus: byte ; var pMainStatus: byte ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetStatus ( pHWStatus, pSysStatus, pMainStatus);
end;

function fonctionTLCR_SetPWMEnable (channel: longword ; Enable: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPWMEnable (channel, Enable);
end;

function fonctionTLCR_GetPWMEnable (channel: longword ; var pEnable: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPWMEnable (channel,pEnable);
end;

function fonctionTLCR_SetPWMConfig (channel: longword ; pulsePeriod: longword ; dutyCycle: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPWMConfig (channel, pulsePeriod, dutyCycle);
end;

function fonctionTLCR_GetPWMConfig (channel: longword ; var pPulsePeriod: longword ; var pDutyCycle: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPWMConfig (channel,pPulsePeriod, pDutyCycle);
end;

function fonctionTLCR_SetPWMCaptureConfig (channel: longword ; enable: boolean ; sampleRate: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPWMCaptureConfig (channel, enable, sampleRate);
end;

function fonctionTLCR_GetPWMCaptureConfig (channel: longword ; var pEnabled: boolean ; var pSampleRate: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPWMCaptureConfig (channel, pEnabled,pSampleRate);
end;

function fonctionTLCR_SetGPIOConfig (pinNum: longword ; enAltFunc: boolean ; altFunc1: boolean ; dirOutput: boolean ; outTypeOpenDrain: boolean ; pinState: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetGPIOConfig (pinNum,enAltFunc, altFunc1, dirOutput, outTypeOpenDrain, pinState);
end;

function fonctionTLCR_GetGPIOConfig (pinNum: longword ; var pEnAltFunc: boolean ; var pAltFunc1: boolean ; var pDirOutput: boolean ; var pOutTypeOpenDrain: boolean ; var pState: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetGPIOConfig (pinNum,pEnAltFunc, pAltFunc1,pDirOutput, pOutTypeOpenDrain, pState);
end;

function fonctionTLCR_SetDisplay (croppedArea: TLCRrectangle ; displayArea: TLCRrectangle ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetDisplay (croppedArea, displayArea);
end;

function fonctionTLCR_GetDisplay (var pCroppedArea: TLCRrectangle ; var pDisplayArea: TLCRrectangle ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetDisplay ( pCroppedArea, pDisplayArea);
end;

function fonctionTLCR_MemRead (addr: longword ; var readWord: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_MemRead (addr, readWord);
end;

function fonctionTLCR_MemWrite (addr: longword ; data: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_MemWrite (addr, data);
end;

function fonctionTLCR_ValidatePatLutData (var pStatus: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_ValidatePatLutData (pStatus);
end;

function fonctionTLCR_SetPatternDisplayMode ( w:boolean;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPatternDisplayMode ( w);
end;

function fonctionTLCR_GetPatternDisplayMode (var w: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPatternDisplayMode ( w);
end;

function fonctionTLCR_SetTrigOutConfig (trigOutNum: longword ; invert: boolean ; rising: longword ; falling: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetTrigOutConfig (trigOutNum, invert, rising, falling);
end;

function fonctionTLCR_GetTrigOutConfig (trigOutNum: longword ; var pInvert: boolean ;var pRising: longword ; var pFalling: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetTrigOutConfig (trigOutNum, pInvert, pRising, pFalling);
end;

function fonctionTLCR_SetRedLEDStrobeDelay (rising: byte ; falling: byte ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetRedLEDStrobeDelay (rising, falling);
end;

function fonctionTLCR_SetGreenLEDStrobeDelay (rising: byte ; falling: byte ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetGreenLEDStrobeDelay (rising, falling);
end;

function fonctionTLCR_SetBlueLEDStrobeDelay (rising: byte ; falling: byte ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetBlueLEDStrobeDelay (rising,falling);
end;

function fonctionTLCR_GetRedLEDStrobeDelay (var rising, falling: byte ;var pu: typeUO): integer ;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetRedLEDStrobeDelay ( rising, falling);
end;

function fonctionTLCR_GetGreenLEDStrobeDelay (var rising, falling: byte ;var pu: typeUO): integer ;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetGreenLEDStrobeDelay (rising, falling);
end;

function fonctionTLCR_GetBlueLEDStrobeDelay (var rising, falling: byte ;var pu: typeUO): integer ;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetBlueLEDStrobeDelay (rising, falling);
end;

function fonctionTLCR_EnterProgrammingMode (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_EnterProgrammingMode;
end;

function fonctionTLCR_ExitProgrammingMode (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_ExitProgrammingMode;
end;


function fonctionTLCR_GetFlashManID ( var manID: word ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:= LCR_GetFlashManID (manID);
end;

function fonctionTLCR_GetFlashDevID (var devID: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetFlashDevID (devID);
end;

function fonctionTLCR_GetBLStatus (var BL_Status: byte ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetBLStatus (BL_Status);
end;

function fonctionTLCR_SetFlashAddr (Addr: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetFlashAddr (Addr);
end;

function fonctionTLCR_FlashSectorErase (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_FlashSectorErase;
end;

function fonctionTLCR_SetDownloadSize (dataLen: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetDownloadSize (dataLen);
end;

function fonctionTLCR_DownloadData (var pByteArray: byte ; dataLen: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_DownloadData ( pByteArray, dataLen);
end;

procedure proTLCR_WaitForFlashReady(var pu:typeUO) ;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then LCR_WaitForFlashReady;
end;

function fonctionTLCR_SetFlashType (tp: byte;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetFlashType (tp);
end;

function fonctionTLCR_CalculateFlashChecksum (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_CalculateFlashChecksum;
end;

function fonctionTLCR_GetFlashChecksum (var checksum: longword;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetFlashChecksum (checksum);
end;

function fonctionTLCR_LoadSplash (index: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_LoadSplash (index);
end;

function fonctionTLCR_GetSplashIndex (var pIndex: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetSplashIndex ( pIndex);
end;

function fonctionTLCR_SetTPGColor (redFG: word ; greenFG: word ; blueFG: word ; redBG: word ; greenBG: word ; blueBG: word ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetTPGColor (redFG, greenFG, blueFG, redBG, greenBG, blueBG);
end;

function fonctionTLCR_GetTPGColor (var pRedFG: word ; var pGreenFG: word ; var pBlueFG: word ; var pRedBG: word ; var pGreenBG: word ; var pBlueBG: word ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetTPGColor ( pRedFG, pGreenFG, pBlueFG, pRedBG, pGreenBG, pBlueBG);
end;

function fonctionTLCR_ClearPatLut (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_ClearPatLut;
end;

function fonctionTLCR_AddToPatLut (TrigType: integer ; PatNum: integer ;BitDepth: integer ;LEDSelect: integer ;InvertPat: boolean ; InsertBlack: boolean ;BufSwap: boolean ; trigOutPrev: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_AddToPatLut (TrigType, PatNum, BitDepth, LEDSelect, InvertPat, InsertBlack, BufSwap, trigOutPrev);
end;

function fonctionTLCR_GetPatLutItem (index: integer ; var pTrigType: integer ; var pPatNum: integer ;var pBitDepth: integer ;var pLEDSelect: integer ;var pInvertPat: boolean ; var pInsertBlack: boolean ;var pBufSwap: boolean ; var pTrigOutPrev: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPatLutItem (index, pTrigType, pPatNum, pBitDepth, pLEDSelect, pInvertPat, pInsertBlack, pBufSwap, pTrigOutPrev);
end;

function fonctionTLCR_SendPatLut (var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SendPatLut;
end;

function fonctionTLCR_SendSplashLut ( var lutEntries: byte ; numEntries: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SendSplashLut ( lutEntries, numEntries);
end;

function fonctionTLCR_GetPatLut (numEntries: integer ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPatLut (numEntries);
end;

function fonctionTLCR_GetSplashLut (var pLut: byte ; numEntries: integer ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetSplashLut ( pLut, numEntries);
end;

function fonctionTLCR_SetPatternTriggerMode (w:boolean;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPatternTriggerMode (w);
end;

function fonctionTLCR_GetPatternTriggerMode (var w:boolean;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPatternTriggerMode ( w);
end;

function fonctionTLCR_PatternDisplay (Action: integer ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_PatternDisplay (Action);
end;

function fonctionTLCR_SetPatternConfig (numLutEntries: longword ; rep: boolean ; numPatsForTrigOut2: longword ; numSplash: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetPatternConfig (numLutEntries, rep, numPatsForTrigOut2, numSplash);
end;

function fonctionTLCR_GetPatternConfig (var pNumLutEntries: longword ; var pRepeat: boolean ; var pNumPatsForTrigOut2: longword ; var pNumSplash: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetPatternConfig ( pNumLutEntries, pRepeat, pNumPatsForTrigOut2, pNumSplash);
end;

function fonctionTLCR_SetExposure_FramePeriod (exposurePeriod: longword ; framePeriod: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetExposure_FramePeriod (exposurePeriod, framePeriod);
end;

function fonctionTLCR_GetExposure_FramePeriod (var pExposure: longword ; var pFramePeriod: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetExposure_FramePeriod (pExposure, pFramePeriod);
end;

function fonctionTLCR_SetTrigIn1Delay (Delay: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetTrigIn1Delay (Delay);
end;

function fonctionTLCR_GetTrigIn1Delay (var pDelay: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetTrigIn1Delay ( pDelay);
end;

function fonctionTLCR_SetInvertData (invert: boolean ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetInvertData (invert);
end;

function fonctionTLCR_PWMCaptureRead (channel: longword ; var pLowPeriod: longword ; var pHighPeriod: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_PWMCaptureRead (channel, pLowPeriod, pHighPeriod);
end;

function fonctionTLCR_SetGeneralPurposeClockOutFreq (clkId: longword ; enable: boolean ; clkDivider: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_SetGeneralPurposeClockOutFreq (clkId, enable, clkDivider);
end;

function fonctionTLCR_GetGeneralPurposeClockOutFreq (clkId: longword ; var pEnabled: boolean ; var pClkDivider: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_GetGeneralPurposeClockOutFreq (clkId, pEnabled, pClkDivider);
end;

function fonctionTLCR_MeasureSplashLoadTiming (startIndex: longword ; numSplash: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_MeasureSplashLoadTiming (startIndex, numSplash);
end;

function fonctionTLCR_ReadSplashLoadTiming (var pTimingData: longword ;var pu: typeUO): integer;
begin
  verifierObjet(pu);
  if TLCR(pu).ok then result:=LCR_ReadSplashLoadTiming ( pTimingData);
end;


end.
