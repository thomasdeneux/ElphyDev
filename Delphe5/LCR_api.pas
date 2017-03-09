unit LCR_api;

interface

uses util1;
(*
 * API.h
 *
 * This module provides C callable APIs for each of the command supported by LightCrafter4500 platform and detailed in the programmer's guide.
 *
 * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 *
*)


Const
  STAT_BIT_FLASH_BUSY  =   $8;
  HID_MESSAGE_MAX_SIZE =   512;


type

  TLCRrectangle= record
                   firstPixel,firstLine,pixelsPerLine,linesPerFrame: smallint;
                 end;

  TLCRcmd=(
    SOURCE_SEL,
    PIXEL_FORMAT,
    CLK_SEL,
    CHANNEL_SWAP,
    FPD_MODE,
    CURTAIN_COLOR,
    POWER_CONTROL,
    FLIP_LONG,
    FLIP_SHORT,
    TPG_SEL,
    PWM_INVERT,
    LED_ENABLE,
    GET_VERSION,
    SW_RESET,
    DMD_PARK,
    BUFFER_FREEZE,
    STATUS_HW,
    STATUS_SYS,
    STATUS_MAIN,
    CSC_DATA,
    GAMMA_CTL,
    BC_CTL,
    PWM_ENABLE,
    PWM_SETUP,
    PWM_CAPTURE_CONFIG,
    GPIO_CONFIG,
    LED_CURRENT,
    DISP_CONFIG,
    TEMP_CONFIG,
    TEMP_READ,
    MEM_CONTROL,
    I2C_CONTROL,
    LUT_VALID,
    DISP_MODE,
    TRIG_OUT1_CTL,
    TRIG_OUT2_CTL,
    RED_STROBE_DLY,
    GRN_STROBE_DLY,
    BLU_STROBE_DLY,
    PAT_DISP_MODE,
    PAT_TRIG_MODE,
    PAT_START_STOP,
    BUFFER_SWAP,
    BUFFER_WR_DISABLE,
    CURRENT_RD_BUFFER,
    PAT_EXPO_PRD,
    INVERT_DATA,
    PAT_CONFIG,
    MBOX_ADDRESS,
    MBOX_CONTROL,
    MBOX_DATA,
    TRIG_IN1_DELAY,
    TRIG_IN2_CONTROL,
    SPLASH_LOAD,
    SPLASH_LOAD_TIMING,
    GPCLK_CONFIG,
    PULSE_GPIO_23,
    ENABLE_LCR_DEBUG,
    TPG_COLOR,
    PWM_CAPTURE_READ,
    PROG_MODE,
    BL_STATUS,
    BL_SPL_MODE,
    BL_GET_MANID,
    BL_GET_DEVID,
    BL_GET_CHKSUM,
    BL_SET_SECTADDR,
    BL_SECT_ERASE,
    BL_SET_DNLDSIZE,
    BL_DNLD_DATA,
    BL_FLASH_TYPE,
    BL_CALC_CHKSUM,
    BL_PROG_MODE);


var
  LCR_SetInputSource: function(source: longword ; portWidth: longword ): integer;cdecl;
  LCR_GetInputSource: function(var pSource: longword ; var portWidth: longword ): integer;cdecl;
  LCR_SetPixelFormat: function(format: longword ): integer;cdecl;
  LCR_GetPixelFormat: function(var pFormat: longword ): integer;cdecl;
  LCR_SetPortClock: function(clock: longword ): integer;cdecl;
  LCR_GetPortClock: function(var pClock: longword ): integer;cdecl;
  LCR_SetDataChannelSwap: function(port: longword ; swap: longword ): integer;cdecl;
  LCR_GetDataChannelSwap: function(var pPort: longword ; var pSwap: longword ): integer;cdecl;
  LCR_SetFPD_Mode_Field: function(PixelMappingMode: longword ; SwapPolarity: boolean ; FieldSignalSelect: longword ): integer;cdecl;
  LCR_GetFPD_Mode_Field: function(var pPixelMappingMode: longword ; var pSwapPolarity: boolean ; var pFieldSignalSelect: longword ): integer;cdecl;
  LCR_SetPowerMode: function(w:boolean): integer;cdecl;
  LCR_SetLongAxisImageFlip: function(w:boolean): integer;cdecl;
  LCR_GetLongAxisImageFlip: function(): boolean;cdecl;
  LCR_SetShortAxisImageFlip: function(w:boolean): integer;cdecl;
  LCR_GetShortAxisImageFlip: function(): boolean;cdecl;
  LCR_SetTPGSelect: function(pattern: longword ): integer;cdecl;
  LCR_GetTPGSelect: function(var pPattern: longword ): integer;cdecl;
  LCR_SetLEDPWMInvert: function(invert: boolean ): integer;cdecl;
  LCR_GetLEDPWMInvert: function(var inverted: boolean ): integer;cdecl;
  LCR_SetLedEnables: function(SeqCtrl: boolean ; Red: boolean ; Green: boolean ; Blue: boolean ): integer;cdecl;
  LCR_GetLedEnables: function(var pSeqCtrl: boolean ; var pRed: boolean ; var pGreen: boolean ; var pBlue: boolean ): integer;cdecl;
  LCR_GetVersion: function(var pApp_ver: longword ; var pAPI_ver: longword ; var pSWConfig_ver: longword ; var pSeqConfig_ver: longword ): integer;cdecl;
  LCR_SoftwareReset: function(): integer;cdecl;
  LCR_GetStatus: function(var pHWStatus: byte ; var pSysStatus: byte ; var pMainStatus: byte ): integer;cdecl;
  LCR_SetPWMEnable: function(channel: longword ; Enable: boolean ): integer;cdecl;
  LCR_GetPWMEnable: function(channel: longword ; var pEnable: boolean ): integer;cdecl;
  LCR_SetPWMConfig: function(channel: longword ; pulsePeriod: longword ; dutyCycle: longword ): integer;cdecl;
  LCR_GetPWMConfig: function(channel: longword ; var pPulsePeriod: longword ; var pDutyCycle: longword ): integer;cdecl;
  LCR_SetPWMCaptureConfig: function(channel: longword ; enable: boolean ; sampleRate: longword ): integer;cdecl;
  LCR_GetPWMCaptureConfig: function(channel: longword ; var pEnabled: boolean ; var pSampleRate: longword ): integer;cdecl;
  LCR_SetGPIOConfig: function(pinNum: longword ; enAltFunc: boolean ; altFunc1: boolean ; dirOutput: boolean ; outTypeOpenDrain: boolean ; pinState: boolean ): integer;cdecl;
  LCR_GetGPIOConfig: function(pinNum: longword ; var pEnAltFunc: boolean ; var pAltFunc1: boolean ; var pDirOutput: boolean ; var pOutTypeOpenDrain: boolean ; var pState: boolean ): integer;cdecl;
  LCR_GetLedCurrents: function(var pRed: byte ; var pGreen: byte ; var pBlue: byte ): integer;cdecl;
  LCR_SetLedCurrents: function(RedCurrent:byte; GreenCurrent: byte ; BlueCurrent: byte ): integer;cdecl;
  LCR_SetDisplay: function(croppedArea: TLCRrectangle ; displayArea: TLCRrectangle ): integer;cdecl;
  LCR_GetDisplay: function(var pCroppedArea: TLCRrectangle ; var pDisplayArea: TLCRrectangle ): integer;cdecl;
  LCR_MemRead: function(addr: longword ; var readWord: longword ): integer;cdecl;
  LCR_MemWrite: function(addr: longword ; data: longword ): integer;cdecl;
  LCR_ValidatePatLutData: function(var pStatus: longword ): integer;cdecl;
  LCR_SetPatternDisplayMode: function( w:boolean): integer;cdecl;
  LCR_GetPatternDisplayMode: function(var w: boolean ): integer;cdecl;
  LCR_SetTrigOutConfig: function(trigOutNum: longword ; invert: boolean ; rising: longword ; falling: longword ): integer;cdecl;
  LCR_GetTrigOutConfig: function(trigOutNum: longword ; var pInvert: boolean ;var pRising: longword ; var pFalling: longword ): integer;cdecl;
  LCR_SetRedLEDStrobeDelay: function(rising: byte ; falling: byte ): integer;cdecl;
  LCR_SetGreenLEDStrobeDelay: function(rising: byte ; falling: byte ): integer;cdecl;
  LCR_SetBlueLEDStrobeDelay: function(rising: byte ; falling: byte ): integer;cdecl;
  LCR_GetRedLEDStrobeDelay: function(var rising, falling: byte ): integer ;cdecl;
  LCR_GetGreenLEDStrobeDelay: function(var rising, falling: byte ): integer ;cdecl;
  LCR_GetBlueLEDStrobeDelay: function(var rising, falling: byte ): integer ;cdecl;
  LCR_EnterProgrammingMode: function(): integer;cdecl;
  LCR_ExitProgrammingMode: function(): integer;cdecl;
//  LCR_GetProgrammingMode: function(var ProgMode: boolean ): integer;cdecl;
  LCR_GetFlashManID: function( var manID: word ): integer;cdecl;
  LCR_GetFlashDevID: function(var devID: longword ): integer;cdecl;
  LCR_GetBLStatus: function(var BL_Status: byte ): integer;cdecl;
  LCR_SetFlashAddr: function(Addr: longword ): integer;cdecl;
  LCR_FlashSectorErase: function(): integer;cdecl;
  LCR_SetDownloadSize: function(dataLen: longword ): integer;cdecl;
  LCR_DownloadData: function(var pByteArray: byte ; dataLen: longword ): integer;cdecl;
  LCR_WaitForFlashReady: procedure ;cdecl;
  LCR_SetFlashType: function(tp: byte): integer;cdecl;
  LCR_CalculateFlashChecksum: function(): integer;cdecl;
  LCR_GetFlashChecksum: function(var checksum: longword): integer;cdecl;
  LCR_SetMode: function(SLmode: boolean): integer;cdecl;
  LCR_GetMode: function(var pMode: boolean ): integer;cdecl;
  LCR_LoadSplash: function(index: longword ): integer;cdecl;
  LCR_GetSplashIndex: function(var pIndex: longword ): integer;cdecl;
  LCR_SetTPGColor: function(redFG: word ; greenFG: word ; blueFG: word ; redBG: word ; greenBG: word ; blueBG: word ): integer;cdecl;
  LCR_GetTPGColor: function(var pRedFG: word ; var pGreenFG: word ; var pBlueFG: word ; var pRedBG: word ; var pGreenBG: word ; var pBlueBG: word ): integer;cdecl;
  LCR_ClearPatLut: function(): integer;cdecl;
  LCR_AddToPatLut: function(TrigType: integer ; PatNum: integer ;BitDepth: integer ;LEDSelect: integer ;InvertPat: boolean ; InsertBlack: boolean ;BufSwap: boolean ; trigOutPrev: boolean ): integer;cdecl;
  LCR_GetPatLutItem: function(index: integer ; var pTrigType: integer ; var pPatNum: integer ;var pBitDepth: integer ;var pLEDSelect: integer ;var pInvertPat: boolean ; var pInsertBlack: boolean ;var pBufSwap: boolean ; var pTrigOutPrev: boolean ): integer;cdecl;
  LCR_SendPatLut: function(): integer;cdecl;
  LCR_SendSplashLut: function( var lutEntries: byte ; numEntries: longword ): integer;cdecl;
  LCR_GetPatLut: function(numEntries: integer ): integer;cdecl;
  LCR_GetSplashLut: function(var pLut: byte ; numEntries: integer ): integer;cdecl;
  LCR_SetPatternTriggerMode: function(w:boolean): integer;cdecl;
  LCR_GetPatternTriggerMode: function(var w:boolean): integer;cdecl;
  LCR_PatternDisplay: function(Action: integer ): integer;cdecl;
  LCR_SetPatternConfig: function(numLutEntries: longword ; rep: boolean ; numPatsForTrigOut2: longword ; numSplash: longword ): integer;cdecl;
  LCR_GetPatternConfig: function(var pNumLutEntries: longword ; var pRepeat: boolean ; var pNumPatsForTrigOut2: longword ; var pNumSplash: longword ): integer;cdecl;
  LCR_SetExposure_FramePeriod: function(exposurePeriod: longword ; framePeriod: longword ): integer;cdecl;
  LCR_GetExposure_FramePeriod: function(var pExposure: longword ; var pFramePeriod: longword ): integer;cdecl;
  LCR_SetTrigIn1Delay: function(Delay: longword ): integer;cdecl;
  LCR_GetTrigIn1Delay: function(var pDelay: longword ): integer;cdecl;
  LCR_SetInvertData: function(invert: boolean ): integer;cdecl;
  LCR_PWMCaptureRead: function(channel: longword ; var pLowPeriod: longword ; var pHighPeriod: longword ): integer;cdecl;
  LCR_SetGeneralPurposeClockOutFreq: function(clkId: longword ; enable: boolean ; clkDivider: longword ): integer;cdecl;
  LCR_GetGeneralPurposeClockOutFreq: function(clkId: longword ; var pEnabled: boolean ; var pClkDivider: longword ): integer;cdecl;
  LCR_MeasureSplashLoadTiming: function(startIndex: longword ; numSplash: longword ): integer;cdecl;
  LCR_ReadSplashLoadTiming: function(var pTimingData: longword ): integer;cdecl;

//  LCR_GetGammaCorrection: function(var pTable: byte ; var pEnable: boolean ): integer;cdecl;
//  LCR_SetGammaCorrection: function(table: byte ; enable: boolean ): integer;cdecl;
//  LCR_GetColorSpaceConversion: function(var pAttr: byte ;  var pCoefficients: word ): integer;cdecl;


  USB_Open: function :integer;cdecl;
  USB_IsConnected: function:boolean;cdecl;
  USB_Write: function: integer;cdecl;
  USB_Read:  function: integer;cdecl;
  USB_Close: function: integer;cdecl;
  USB_Init:  function: integer;cdecl;
  USB_Exit:  function: integer;cdecl;

function InitLCRlib: boolean;

implementation


var
  hh:intG;

Const
  LCRdll= 'lcrDll.dll';

function InitLCRlib: boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary( Appdir + LCRdll );
  result:=(hh<>0);
  if not result then exit;


  LCR_SetInputSource:=  getProc(hh, 'LCR_SetInputSource');
  LCR_GetInputSource:=  getProc(hh, 'LCR_GetInputSource');
  LCR_SetPixelFormat:=  getProc(hh, 'LCR_SetPixelFormat');
  LCR_GetPixelFormat:=  getProc(hh, 'LCR_GetPixelFormat');
  LCR_SetPortClock:=  getProc(hh, 'LCR_SetPortClock');
  LCR_GetPortClock:=  getProc(hh, 'LCR_GetPortClock');
  LCR_SetDataChannelSwap:=  getProc(hh, 'LCR_SetDataChannelSwap');
  LCR_GetDataChannelSwap:=  getProc(hh, 'LCR_GetDataChannelSwap');
  LCR_SetFPD_Mode_Field:=  getProc(hh, 'LCR_SetFPD_Mode_Field');
  LCR_GetFPD_Mode_Field:=  getProc(hh, 'LCR_GetFPD_Mode_Field');
  LCR_SetPowerMode:=  getProc(hh, 'LCR_SetPowerMode');
  LCR_SetLongAxisImageFlip:=  getProc(hh, 'LCR_SetLongAxisImageFlip');
  LCR_GetLongAxisImageFlip:=  getProc(hh, 'LCR_GetLongAxisImageFlip');
  LCR_SetShortAxisImageFlip:=  getProc(hh, 'LCR_SetShortAxisImageFlip');
  LCR_GetShortAxisImageFlip:=  getProc(hh, 'LCR_GetShortAxisImageFlip');
  LCR_SetTPGSelect:=  getProc(hh, 'LCR_SetTPGSelect');
  LCR_GetTPGSelect:=  getProc(hh, 'LCR_GetTPGSelect');
  LCR_SetLEDPWMInvert:=  getProc(hh, 'LCR_SetLEDPWMInvert');
  LCR_GetLEDPWMInvert:=  getProc(hh, 'LCR_GetLEDPWMInvert');
  LCR_SetLedEnables:=  getProc(hh, 'LCR_SetLedEnables');
  LCR_GetLedEnables:=  getProc(hh, 'LCR_GetLedEnables');
  LCR_GetVersion:=  getProc(hh, 'LCR_GetVersion');
  LCR_SoftwareReset:=  getProc(hh, 'LCR_SoftwareReset');
  LCR_GetStatus:=  getProc(hh, 'LCR_GetStatus');
  LCR_SetPWMEnable:=  getProc(hh, 'LCR_SetPWMEnable');
  LCR_GetPWMEnable:=  getProc(hh, 'LCR_GetPWMEnable');
  LCR_SetPWMConfig:=  getProc(hh, 'LCR_SetPWMConfig');
  LCR_GetPWMConfig:=  getProc(hh, 'LCR_GetPWMConfig');
  LCR_SetPWMCaptureConfig:=  getProc(hh, 'LCR_SetPWMCaptureConfig');
  LCR_GetPWMCaptureConfig:=  getProc(hh, 'LCR_GetPWMCaptureConfig');
  LCR_SetGPIOConfig:=  getProc(hh, 'LCR_SetGPIOConfig');
  LCR_GetGPIOConfig:=  getProc(hh, 'LCR_GetGPIOConfig');
  LCR_GetLedCurrents:=  getProc(hh, 'LCR_GetLedCurrents');
  LCR_SetLedCurrents:=  getProc(hh, 'LCR_SetLedCurrents');
  LCR_SetDisplay:=  getProc(hh, 'LCR_SetDisplay');
  LCR_GetDisplay:=  getProc(hh, 'LCR_GetDisplay');
  LCR_MemRead:=  getProc(hh, 'LCR_MemRead');
  LCR_MemWrite:=  getProc(hh, 'LCR_MemWrite');
  LCR_ValidatePatLutData:=  getProc(hh, 'LCR_ValidatePatLutData');
  LCR_SetPatternDisplayMode:=  getProc(hh, 'LCR_SetPatternDisplayMode');
  LCR_GetPatternDisplayMode:=  getProc(hh, 'LCR_GetPatternDisplayMode');
  LCR_SetTrigOutConfig:=  getProc(hh, 'LCR_SetTrigOutConfig');
  LCR_GetTrigOutConfig:=  getProc(hh, 'LCR_GetTrigOutConfig');
  LCR_SetRedLEDStrobeDelay:=  getProc(hh, 'LCR_SetRedLEDStrobeDelay');
  LCR_SetGreenLEDStrobeDelay:=  getProc(hh, 'LCR_SetGreenLEDStrobeDelay');
  LCR_SetBlueLEDStrobeDelay:=  getProc(hh, 'LCR_SetBlueLEDStrobeDelay');
  LCR_GetRedLEDStrobeDelay:=  getProc(hh, 'LCR_GetRedLEDStrobeDelay');
  LCR_GetGreenLEDStrobeDelay:=  getProc(hh, 'LCR_GetGreenLEDStrobeDelay');
  LCR_GetBlueLEDStrobeDelay:=  getProc(hh, 'LCR_GetBlueLEDStrobeDelay');
  LCR_EnterProgrammingMode:=  getProc(hh, 'LCR_EnterProgrammingMode');
  LCR_ExitProgrammingMode:=  getProc(hh, 'LCR_ExitProgrammingMode');
 // LCR_GetProgrammingMode:=  getProc(hh, 'LCR_GetProgrammingMode');
  LCR_GetFlashManID:=  getProc(hh, 'LCR_GetFlashManID');
  LCR_GetFlashDevID:=  getProc(hh, 'LCR_GetFlashDevID');
  LCR_GetBLStatus:=  getProc(hh, 'LCR_GetBLStatus');
  LCR_SetFlashAddr:=  getProc(hh, 'LCR_SetFlashAddr');
  LCR_FlashSectorErase:=  getProc(hh, 'LCR_FlashSectorErase');
  LCR_SetDownloadSize:=  getProc(hh, 'LCR_SetDownloadSize');
  LCR_DownloadData:=  getProc(hh, 'LCR_DownloadData');
  LCR_WaitForFlashReady:=  getProc(hh, 'LCR_WaitForFlashReady');
  LCR_SetFlashType:=  getProc(hh, 'LCR_SetFlashType');
  LCR_CalculateFlashChecksum:=  getProc(hh, 'LCR_CalculateFlashChecksum');
  LCR_GetFlashChecksum:=  getProc(hh, 'LCR_GetFlashChecksum');
  LCR_SetMode:=  getProc(hh, 'LCR_SetMode');
  LCR_GetMode:=  getProc(hh, 'LCR_GetMode');
  LCR_LoadSplash:=  getProc(hh, 'LCR_LoadSplash');
  LCR_GetSplashIndex:=  getProc(hh, 'LCR_GetSplashIndex');
  LCR_SetTPGColor:=  getProc(hh, 'LCR_SetTPGColor');
  LCR_GetTPGColor:=  getProc(hh, 'LCR_GetTPGColor');
  LCR_ClearPatLut:=  getProc(hh, 'LCR_ClearPatLut');
  LCR_AddToPatLut:=  getProc(hh, 'LCR_AddToPatLut');
  LCR_GetPatLutItem:=  getProc(hh, 'LCR_GetPatLutItem');
  LCR_SendPatLut:=  getProc(hh, 'LCR_SendPatLut');
  LCR_SendSplashLut:=  getProc(hh, 'LCR_SendSplashLut');
  LCR_GetPatLut:=  getProc(hh, 'LCR_GetPatLut');
  LCR_GetSplashLut:=  getProc(hh, 'LCR_GetSplashLut');
  LCR_SetPatternTriggerMode:=  getProc(hh, 'LCR_SetPatternTriggerMode');
  LCR_GetPatternTriggerMode:=  getProc(hh, 'LCR_GetPatternTriggerMode');
  LCR_PatternDisplay:=  getProc(hh, 'LCR_PatternDisplay');
  LCR_SetPatternConfig:=  getProc(hh, 'LCR_SetPatternConfig');
  LCR_GetPatternConfig:=  getProc(hh, 'LCR_GetPatternConfig');
  LCR_SetExposure_FramePeriod:=  getProc(hh, 'LCR_SetExposure_FramePeriod');
  LCR_GetExposure_FramePeriod:=  getProc(hh, 'LCR_GetExposure_FramePeriod');
  LCR_SetTrigIn1Delay:=  getProc(hh, 'LCR_SetTrigIn1Delay');
  LCR_GetTrigIn1Delay:=  getProc(hh, 'LCR_GetTrigIn1Delay');
  LCR_SetInvertData:=  getProc(hh, 'LCR_SetInvertData');
  LCR_PWMCaptureRead:=  getProc(hh, 'LCR_PWMCaptureRead');
  LCR_SetGeneralPurposeClockOutFreq:=  getProc(hh, 'LCR_SetGeneralPurposeClockOutFreq');
  LCR_GetGeneralPurposeClockOutFreq:=  getProc(hh, 'LCR_GetGeneralPurposeClockOutFreq');
  LCR_MeasureSplashLoadTiming:=  getProc(hh, 'LCR_MeasureSplashLoadTiming');
  LCR_ReadSplashLoadTiming:=  getProc(hh, 'LCR_ReadSplashLoadTiming');
//  LCR_GetGammaCorrection:=  getProc(hh, 'LCR_GetGammaCorrection');
//  LCR_SetGammaCorrection:=  getProc(hh, 'LCR_SetGammaCorrection');
//  LCR_GetColorSpaceConversion:=  getProc(hh, 'LCR_GetColorSpaceConversion');

  USB_Open:=  getProc(hh, 'USB_Open');
  USB_IsConnected:=  getProc(hh, 'USB_IsConnected');
  USB_Write:=  getProc(hh, 'USB_Write');
  USB_Read:=  getProc(hh, 'USB_Read');
  USB_Close:=  getProc(hh, 'USB_Close');
  USB_Init:=  getProc(hh, 'USB_Init');
  USB_Exit:=  getProc(hh, 'USB_Exit');

end;

end.

