unit DinputGS ;

interface

uses OLE2,Windows,
     util1,Gdos;

(*==========================================================================;
 *
 *  DirectX 6 Delphi adaptation by Gérard Sadoc
 *
 *==========================================================================;*)

 const
   DIRECTINPUT_VERSION =         $0500;

{$Z4}
{$A+}

(*
 * GUIDS used by DirectInput objects
 *)

CLSID_DirectInput: TGUID =
  ( D1:$25E609E0;D2:$B259;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
CLSID_DirectInputDevice: TGUID =
  ( D1:$25E609E1;D2:$B259;D3:$11CF;D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

(****************************************************************************
 *
 *      Interfaces
 *
 ****************************************************************************)

IID_IDirectInput:TGUID =
  ( D1: $89521360; D2:$AA8A; d3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
IID_IDirectInput2: TGUID =
  ( D1: $5944E662; D2:$AA8A; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

IID_IDirectInputDevice: TGUID =
  ( D1: $5944E680; D2:$C92E; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
IID_IDirectInputDevice2:TGUID =
  ( D1: $5944E682; D2:$C92E; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

IID_IDirectInputEffect: TGUID =
  ( D1: $E7E1F7C0; D2:$88D2; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));

(****************************************************************************
 *
 *      Predefined object types
 *
 ****************************************************************************)

GUID_XAxis: TGUID =
  ( D1: $A36D02E0; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_YAxis: TGUID =
  ( D1: $A36D02E1; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_ZAxis: TGUID =
  ( D1: $A36D02E2; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_RxAxis: TGUID =
  ( D1: $A36D02F4; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_RyAxis: TGUID =
  ( D1: $A36D02F5; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_RzAxis: TGUID =
  ( D1: $A36D02E3; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_Slider: TGUID =
  ( D1: $A36D02E4; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

GUID_Button: TGUID =
  ( D1: $A36D02F0; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_Key: TGUID =
  ( D1: $55728220; D2:$D33C; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

GUID_POV: TGUID =
  ( D1: $A36D02F2; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

GUID_Unknown: TGUID =
  ( D1: $A36D02F3; D2:$C9F3; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

(****************************************************************************
 *
 *      Predefined product GUIDs
 *
 ****************************************************************************)

GUID_SysMouse: TGUID =
  ( D1: $6F1D2B60; D2:$D5A0; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_SysKeyboard:TGUID =
  ( D1: $6F1D2B61; D2:$D5A0; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));
GUID_Joystick:TGUID =
  ( D1: $6F1D2B70; D2:$D5A0; D3:$11CF; D4:($BF,$C7,$44,$45,$53,$54,$00,$00));

(****************************************************************************
 *
 *      Predefined force feedback effects
 *
 ****************************************************************************)

GUID_ConstantForce:TGUID =
  ( D1: $13541C20; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_RampForce: TGUID =
  ( D1: $13541C21; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Square: TGUID =
  ( D1: $13541C22; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Sine: TGUID =
  ( D1: $13541C23; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Triangle: TGUID =
  ( D1: $13541C24; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_SawtoothUp: TGUID =
  ( D1: $13541C25; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_SawtoothDown: TGUID =
  ( D1: $13541C26; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Spring: TGUID =
  ( D1: $13541C27; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Damper: TGUID =
  ( D1: $13541C28; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Inertia: TGUID =
  ( D1: $13541C29; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_Friction: TGUID =
  ( D1: $13541C2A; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));
GUID_CustomForce: TGUID =
  ( D1: $13541C2B; D2:$8E33; D3:$11D0; D4:($9A,$D0,$00,$A0,$C9,$A0,$6E,$35));


(****************************************************************************
 *
 *      Interfaces and Structures...
 *
 ****************************************************************************)

(****************************************************************************
 *
 *      IDirectInputEffect
 *
 ****************************************************************************)

  DIEFT_ALL                   = $00000000;

  DIEFT_CONSTANTFORCE         = $00000001;
  DIEFT_RAMPFORCE             = $00000002;
  DIEFT_PERIODIC              = $00000003;
  DIEFT_CONDITION             = $00000004;
  DIEFT_CUSTOMFORCE           = $00000005;
  DIEFT_HARDWARE              = $000000FF;

  DIEFT_FFATTACK              = $00000200;
  DIEFT_FFFADE                = $00000400;
  DIEFT_SATURATION            = $00000800;
  DIEFT_POSNEGCOEFFICIENTS    = $00001000;
  DIEFT_POSNEGSATURATION      = $00002000;
  DIEFT_DEADBAND              = $00004000;

  {DIEFT_GETTYPE(n)            = LOBYTE(n);}

  DI_DEGREES                  = 100;
  DI_FFNOMINALMAX             = 10000;
  DI_SECONDS                  = 1000000;

type
  TDICONSTANTFORCE= record
                     lMagnitude:longint;
                   end;
  PDICONSTANTFORCE=^TDICONSTANTFORCE;

  PCDICONSTANTFORCE=^TDICONSTANTFORCE;


  TDIRAMPFORCE=record
                lStart:longint;
                lEnd:longint;
              end;
  PDIRAMPFORCE=^TDIRAMPFORCE;
  PCDIRAMPFORCE=^TDIRAMPFORCE;


  TDIPERIODIC= record
                 dwMagnitude:longint;
                 lOffset:longint;
                 dwPhase:longint;
                 dwPeriod:longint;
               end;
  PDIPERIODIC=^TDIPERIODIC;
  PCDIPERIODIC=^TDIPERIODIC;

  TDICONDITION = record
                   lOffset:longint;
                   lPositiveCoefficient:longint;
                   lNegativeCoefficient:longint;
                   dwPositiveSaturation:longint;
                   dwNegativeSaturation:longint;
                   lDeadBand:longint;
                 end;
  PDICONDITION=^TDICONDITION;
  PCDICONDITION=^TDICONDITION;


  TDICUSTOMFORCE= record
                   cChannels:longint;
                   dwSamplePeriod:longint;
                   cSamples:longint;
                   rglForceData:Pinteger;
                 end;
  PDICUSTOMFORCE =^TDICUSTOMFORCE;
  PCDICUSTOMFORCE =^TDICUSTOMFORCE;

  TDIENVELOPE= record
                 dwSize:longint;                   (* sizeof(DIENVELOPE)   *)
                 dwAttackLevel:longint;
                 dwAttackTime:longint;             (* Microseconds         *)
                 dwFadeLevel:longint;
                 dwFadeTime:longint;               (* Microseconds         *)
               end;
  PDIENVELOPE=^TDIENVELOPE;
  PCDIENVELOPE=^TDIENVELOPE;

  TDIEFFECT= record
               dwSize:longint;                   (* sizeof(DIEFFECT)     *)
               dwFlags:longint;                  (* DIEFF_*              *)
               dwDuration:longint;               (* Microseconds         *)
               dwSamplePeriod:longint;           (* Microseconds         *)
               dwGain:longint;
               dwTriggerButton:longint;          (* or DIEB_NOTRIGGER    *)
               dwTriggerRepeatInterval:longint;  (* Microseconds         *)
               cAxes:longint;                    (* Number of axes       *)
               rgdwAxes:^longint;                (* Array of axes        *)
               rglDirection:^longint;            (* Array of directions  *)
               lpEnvelope:PDIENVELOPE;           (* Optional             *)
               cbTypeSpecificParams:longint;     (* Size of params       *)
               lpvTypeSpecificParams:pointer;    (* Pointer to params    *)
             end;
  PDIEFFECT=^TDIEFFECT;
  PCDIEFFECT=^TDIEFFECT;


const
  DIEFF_OBJECTIDS             = $00000001;
  DIEFF_OBJECTOFFSETS         = $00000002;
  DIEFF_CARTESIAN             = $00000010;
  DIEFF_POLAR                 = $00000020;
  DIEFF_SPHERICAL             = $00000040;

  DIEP_DURATION               = $00000001;
  DIEP_SAMPLEPERIOD           = $00000002;
  DIEP_GAIN                   = $00000004;
  DIEP_TRIGGERBUTTON          = $00000008;
  DIEP_TRIGGERREPEATINTERVAL  = $00000010;
  DIEP_AXES                   = $00000020;
  DIEP_DIRECTION              = $00000040;
  DIEP_ENVELOPE               = $00000080;
  DIEP_TYPESPECIFICPARAMS     = $00000100;
  DIEP_ALLPARAMS              = $000001FF;
  DIEP_START                  = $20000000;
  DIEP_NORESTART              = $40000000;
  DIEP_NODOWNLOAD             = $80000000;
  DIEB_NOTRIGGER              = $FFFFFFFF;

  DIES_SOLO                   = $00000001;
  DIES_NODOWNLOAD             = $80000000;

  DIEGES_PLAYING              = $00000001;
  DIEGES_EMULATED             = $00000002;

type
  TDIEFFESCAPE= record
                  dwSize:longint;
                  dwCommand:longint;
                  lpvInBuffer:pointer;
                  cbInBuffer:longint;
                  lpvOutBuffer:pointer;
                  cbOutBuffer:longint;
                end;
  PDIEFFESCAPE=^TDIEFFESCAPE;


  IDirectInputEffect=class(IUnknown)

    (*** IDirectInputEffect methods ***)
    function Initialize(HINSTANCE:longint;dwVersion:DWORD;guid:TGUID):hresult;
                    virtual ; stdcall ; abstract ;
    function GetEffectGuid(guid:PGUID):hresult;
                    virtual ; stdcall ; abstract ;
    function GetParameters(peff:PDIEFFECT;dwFlags:DWORD):hresult;
                    virtual ; stdcall ; abstract ;
    function SetParameters(peff:PCDIEFFECT;dwFlags:DWORD):hresult;
                    virtual ; stdcall ; abstract ;
    function Start(dwIterations,dwFlags:DWORD) :hresult;
                    virtual ; stdcall ; abstract ;
    function Stop :hresult;
                    virtual ; stdcall ; abstract ;
    function GetEffectStatus(pdwFlags:PDWORD) :hresult;
                    virtual ; stdcall ; abstract ;
    function Download :hresult;
                    virtual ; stdcall ; abstract ;
    function Unload :hresult;
                    virtual ; stdcall ; abstract ;
    function Escape(effEscape:PDIEFFESCAPE) :hresult;
                    virtual ; stdcall ; abstract ;
  end;


(****************************************************************************
 *
 *      IDirectInputDevice
 *
 ****************************************************************************)

 const
  DIDEVTYPE_DEVICE    =1;
  DIDEVTYPE_MOUSE     =2;
  DIDEVTYPE_KEYBOARD  =3;
  DIDEVTYPE_JOYSTICK  =4;
  DIDEVTYPE_HID       =$00010000;

  DIDEVTYPEMOUSE_UNKNOWN          =1;
  DIDEVTYPEMOUSE_TRADITIONAL      =2;
  DIDEVTYPEMOUSE_FINGERSTICK      =3;
  DIDEVTYPEMOUSE_TOUCHPAD         =4;
  DIDEVTYPEMOUSE_TRACKBALL        =5;

  DIDEVTYPEKEYBOARD_UNKNOWN       =0;
  DIDEVTYPEKEYBOARD_PCXT          =1;
  DIDEVTYPEKEYBOARD_OLIVETTI      =2;
  DIDEVTYPEKEYBOARD_PCAT          =3;
  DIDEVTYPEKEYBOARD_PCENH         =4;
  DIDEVTYPEKEYBOARD_NOKIA1050     =5;
  DIDEVTYPEKEYBOARD_NOKIA9140     =6;
  DIDEVTYPEKEYBOARD_NEC98         =7;
  DIDEVTYPEKEYBOARD_NEC98LAPTOP   =8;
  DIDEVTYPEKEYBOARD_NEC98106      =9;
  DIDEVTYPEKEYBOARD_JAPAN106     =10;
  DIDEVTYPEKEYBOARD_JAPANAX      =11;
  DIDEVTYPEKEYBOARD_J3100        =12;

  DIDEVTYPEJOYSTICK_UNKNOWN       =1;
  DIDEVTYPEJOYSTICK_TRADITIONAL   =2;
  DIDEVTYPEJOYSTICK_FLIGHTSTICK   =3;
  DIDEVTYPEJOYSTICK_GAMEPAD       =4;
  DIDEVTYPEJOYSTICK_RUDDER        =5;
  DIDEVTYPEJOYSTICK_WHEEL         =6;
  DIDEVTYPEJOYSTICK_HEADTRACKER   =7;

  {
  GET_DIDEVICE_TYPE(dwDevType)    LOBYTE(dwDevType)
  GET_DIDEVICE_SUBTYPE(dwDevType) HIBYTE(dwDevType)
  }

type
  TDIDEVCAPS_DX3 = record
    dwSize:Dword;
    dwFlags:Dword;
    dwDevType:Dword;
    dwAxes:Dword;
    dwButtons:Dword;
    dwPOVs:Dword;
  end;
  PDIDEVCAPS_DX3=^TDIDEVCAPS_DX3;


  TDIDEVCAPS = record
     dwSize:Dword;
     dwFlags:Dword;
     dwDevType:Dword;
     dwAxes:Dword;
     dwButtons:Dword;
     dwPOVs:Dword;
     dwFFSamplePeriod:Dword;
     dwFFMinTimeResolution:Dword;
     dwFirmwareRevision:Dword;
     dwHardwareRevision:Dword;
     dwFFDriverVersion:Dword;
   end;
  PDIDEVCAPS=^TDIDEVCAPS;

const
  DIDC_ATTACHED           =$00000001;
  DIDC_POLLEDDEVICE       =$00000002;
  DIDC_EMULATED           =$00000004;
  DIDC_POLLEDDATAFORMAT   =$00000008;
  DIDC_FORCEFEEDBACK      =$00000100;
  DIDC_FFATTACK           =$00000200;
  DIDC_FFFADE             =$00000400;
  DIDC_SATURATION         =$00000800;
  DIDC_POSNEGCOEFFICIENTS =$00001000;
  DIDC_POSNEGSATURATION   =$00002000;
  DIDC_DEADBAND           =$00004000;

  DIDFT_ALL           =$00000000;

  DIDFT_RELAXIS       =$00000001;
  DIDFT_ABSAXIS       =$00000002;
  DIDFT_AXIS          =$00000003;

  DIDFT_PSHBUTTON     =$00000004;
  DIDFT_TGLBUTTON     =$00000008;
  DIDFT_BUTTON        =$0000000C;

  DIDFT_POV           =$00000010;

  DIDFT_COLLECTION    =$00000040;
  DIDFT_NODATA        =$00000080;

  DIDFT_ANYINSTANCE   =$00FFFF00;
  DIDFT_INSTANCEMASK  =DIDFT_ANYINSTANCE;
  {
  DIDFT_MAKEINSTANCE(n) ((WORD)(n) << 8)
  DIDFT_GETTYPE(n)     LOBYTE(n)
  DIDFT_GETINSTANCE(n) LOWORD((n) >> 8)
  }
  DIDFT_FFACTUATOR        =$01000000;
  DIDFT_FFEFFECTTRIGGER   =$02000000;

  {DIDFT_ENUMCOLLECTION(n) ((WORD)(n) << 8)}
  DIDFT_NOCOLLECTION      =$00FFFF00;


type
  TDIOBJECTDATAFORMAT = record
     GUID: pguid;
     dwOfs:Dword;
     dwType:Dword;
     dwFlags:Dword;
  end;

 PDIOBJECTDATAFORMAT=^TDIOBJECTDATAFORMAT;
 PCDIOBJECTDATAFORMAT=^TDIOBJECTDATAFORMAT;

 TDIDATAFORMAT = record
    dwSize:Dword;
    dwObjSize:Dword;
    dwFlags:Dword;
    dwDataSize:Dword;
    dwNumObjs:Dword;
    rgodf:PDIOBJECTDATAFORMAT ;
 end;
 PDIDATAFORMAT=^TDIDATAFORMAT;
 PCDIDATAFORMAT=^TDIDATAFORMAT;

const
  DIDF_ABSAXIS            =$00000001;
  DIDF_RELAXIS            =$00000002;


var
  c_dfDIMouse:     TDIDATAFORMAT ;
  c_dfDIKeyboard:  TDIDATAFORMAT ;
  c_dfDIJoystick:  TDIDATAFORMAT ;
  c_dfDIJoystick2: TDIDATAFORMAT ;

(* These structures are defined for DirectX 3.0 compatibility *)

type
  TDIDEVICEOBJECTINSTANCE_DX3 = record
    dwSize:Dword;
    guidType:Tguid;
    dwOfs:Dword;
    dwType:Dword;
    dwFlags:Dword;
    tszName:array[1..MAX_PATH] of char;
  end;
  PDIDEVICEOBJECTINSTANCE_DX3=^TDIDEVICEOBJECTINSTANCE_DX3;


type
  PCDIDEVICEOBJECTINSTANCE_DX3 = ^TDIDEVICEOBJECTINSTANCE_DX3;

  TDIDEVICEOBJECTINSTANCE = record
    dwSize:Dword;
    guidType:Tguid;
    dwOfs:Dword;
    dwType:Dword;
    dwFlags:Dword;
    tszName:array[1..MAX_PATH] of char;
    dwFFMaxForce:Dword;
    dwFFForceResolution:Dword;
    wCollectionNumber:word;
    wDesignatorIndex:word;
    wUsagePage:word;
    wUsage:word;
    dwDimension:Dword;
    wExponent:word;
    wReserved:word;
  end;
  PDIDEVICEOBJECTINSTANCE = ^TDIDEVICEOBJECTINSTANCE;

  PCDIDEVICEOBJECTINSTANCE= ^TDIDEVICEOBJECTINSTANCE;

  LPDIENUMDEVICEOBJECTSCALLBACK=
    function(dev:PCDIDEVICEOBJECTINSTANCE;p:pointer):bool;stdCall;

const
  DIDOI_FFACTUATOR        =$00000001;
  DIDOI_FFEFFECTTRIGGER   =$00000002;
  DIDOI_POLLED            =$00008000;
  DIDOI_ASPECTPOSITION    =$00000100;
  DIDOI_ASPECTVELOCITY    =$00000200;
  DIDOI_ASPECTACCEL       =$00000300;
  DIDOI_ASPECTFORCE       =$00000400;
  DIDOI_ASPECTMASK        =$00000F00;

type
 TDIPROPHEADER = record
    dwSize:Dword;
    dwHeaderSize:Dword;
    dwObj:Dword;
    dwHow:Dword;
 end;
 PDIPROPHEADER=^TDIPROPHEADER;

 PCDIPROPHEADER=^TDIPROPHEADER;

const
  DIPH_DEVICE             =0;
  DIPH_BYOFFSET           =1;
  DIPH_BYID               =2;

type
  TDIPROPDWORD = record
    diph: TDIPROPHEADER;
    dwData:DWORD;
  end;

  PDIPROPDWORD=^TDIPROPDWORD;
  PCDIPROPDWORD=^TDIPROPDWORD;

  TDIPROPRANGE = record
    diph: TDIPROPHEADER;
    lMin: longint;
    lMax: longint;
  end;

  PDIPROPRANGE= ^TDIPROPRANGE;
  PCDIPROPRANGE= ^TDIPROPRANGE;

const
  DIPROPRANGE_NOMIN =$80000000;
  DIPROPRANGE_NOMAX =$7FFFFFFF;


{
#ifdef __cplusplus
  MAKEDIPROP(prop)    /*(const GUID *)(prop))
#else
  MAKEDIPROP(prop)    ((REFGUID)(prop))
#endif
}
  DIPROP_BUFFERSIZE       =1;

  DIPROP_AXISMODE         =2;

  DIPROPAXISMODE_ABS      =0;
  DIPROPAXISMODE_REL      =1;

  DIPROP_GRANULARITY      =3;

  DIPROP_RANGE            =4;

  DIPROP_DEADZONE         =5;

  DIPROP_SATURATION       =6;

  DIPROP_FFGAIN           =7;

  DIPROP_FFLOAD           =8;

  DIPROP_AUTOCENTER       =9;

  DIPROPAUTOCENTER_OFF    =0;
  DIPROPAUTOCENTER_ON     =1;

  DIPROP_CALIBRATIONMODE  =10;

  DIPROPCALIBRATIONMODE_COOKED=    0;
  DIPROPCALIBRATIONMODE_RAW=       1;

type
  TDIDEVICEOBJECTDATA = record
    dwOfs:Dword;
    dwData:Dword;
    dwTimeStamp:Dword;
    dwSequence:Dword;
  end;
  PDIDEVICEOBJECTDATA=^TDIDEVICEOBJECTDATA;
  PCDIDEVICEOBJECTDATA=^TDIDEVICEOBJECTDATA;

const
  DIGDD_PEEK          =$00000001;

  {
  DISEQUENCE_COMPARE(dwSequence1, cmp, dwSequence2) \
                        ((int)((dwSequence1) - (dwSequence2)) cmp 0) }

  DISCL_EXCLUSIVE     =$00000001;
  DISCL_NONEXCLUSIVE  =$00000002;
  DISCL_FOREGROUND    =$00000004;
  DISCL_BACKGROUND    =$00000008;

(* These structures are defined for DirectX 3.0 compatibility *)

type
  TDIDEVICEINSTANCE_DX3 = record
    dwSize:dword;
    guidInstance: Tguid;
    guidProduct: Tguid ;
    dwDevType:Dword;
    tszInstanceName: array[1..MAX_PATH] of char;
    tszProductName: array[1..MAX_PATH] of char;
  end;
  PDIDEVICEINSTANCE_DX3=^TDIDEVICEINSTANCE_DX3;

  PCDIDEVICEINSTANCE_DX3 =^TDIDEVICEINSTANCE_DX3;


  TDIDEVICEINSTANCE = record
    dwSize:Dword;
    guidInstance:Tguid;
    guidProduct:Tguid;
    dwDevType:Dword;
    tszInstanceName:array[1..MAX_PATH] of char;
    tszProductName:array[1..MAX_PATH] of char;
    guidFFDriver: Tguid;
    wUsagePage:word;
    wUsage:word;
  end;
  PDIDEVICEINSTANCE=^TDIDEVICEINSTANCE;

  PCDIDEVICEINSTANCE=^TDIDEVICEINSTANCE;


  IDirectInputDevice= class (IUnknown)

    (*** IDirectInputDeviceA methods ***)
    function GetCapabilities(DIDEVCAPS:PDIDEVCAPS) :hresult;
               virtual ; stdcall ; abstract ;
    function EnumObjects( enum:LPDIENUMDEVICEOBJECTSCALLBACK;pvref:pointer;
                         dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function GetProperty( guid:TGUID;pdiph:PDIPROPHEADER) :hresult;
               virtual ; stdcall ; abstract ;
    function SetProperty(guid:TGUID;pdiph:PCDIPROPHEADER) :hresult;
               virtual ; stdcall ; abstract ;
    function Acquire :hresult;
               virtual ; stdcall ; abstract ;
    function Unacquire :hresult;
               virtual ; stdcall ; abstract ;
    function GetDeviceState(A: DWORD;B: pointer) :hresult;
               virtual ; stdcall ; abstract ;
    function GetDeviceData(cbObjectData:DWORD;rgdod:PDIDEVICEOBJECTDATA;
                           pdwInOut:PDWORD;dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function SetDataFormat(lpdf: PCDIDATAFORMAT) :hresult;
               virtual ; stdcall ; abstract ;
    function SetEventNotification(event:THANDLE) :hresult;
               virtual ; stdcall ; abstract ;
    function SetCooperativeLevel(wnd:HWND;dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function GetObjectInfo(pdidoi:PDIDEVICEOBJECTINSTANCE;dwObj:DWORD;
                           dwHow:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function GetDeviceInfo(A:PDIDEVICEINSTANCE) :hresult;
               virtual ; stdcall ; abstract ;
    function RunControlPanel(hwndOwner:HWND;dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function Initialize(INST:integer;dwVersion:DWORD;GUID:Tguid) :hresult;
               virtual ; stdcall ; abstract ;
  end;


const
  DISFFC_RESET            =$00000001;
  DISFFC_STOPALL          =$00000002;
  DISFFC_PAUSE            =$00000004;
  DISFFC_CONTINUE         =$00000008;
  DISFFC_SETACTUATORSON   =$00000010;
  DISFFC_SETACTUATORSOFF  =$00000020;

  DIGFFS_EMPTY            =$00000001;
  DIGFFS_STOPPED          =$00000002;
  DIGFFS_PAUSED           =$00000004;
  DIGFFS_ACTUATORSON      =$00000010;
  DIGFFS_ACTUATORSOFF     =$00000020;
  DIGFFS_POWERON          =$00000040;
  DIGFFS_POWEROFF         =$00000080;
  DIGFFS_SAFETYSWITCHON   =$00000100;
  DIGFFS_SAFETYSWITCHOFF  =$00000200;
  DIGFFS_USERFFSWITCHON   =$00000400;
  DIGFFS_USERFFSWITCHOFF  =$00000800;
  DIGFFS_DEVICELOST       =$80000000;

type
  TDIEFFECTINFO= record
    dwSize:Dword;
    guid: TGUID;
    dwEffType:Dword;
    dwStaticParams:Dword;
    dwDynamicParams:Dword;
    tszName: array[1..MAX_PATH] of char;
  end;
  PDIEFFECTINFO=^TDIEFFECTINFO;

  PCDIEFFECTINFO=^TDIEFFECTINFO;


  LPDIENUMEFFECTSCALLBACK= function (inf:PCDIEFFECTINFO;p:pointer):bool;
  LPDIENUMCREATEDEFFECTOBJECTSCALLBACK=
    function (eff:IDIRECTINPUTEFFECT; p:pointer):BOOL;


  IDirectInputDevice2= class (IDirectInputDevice)

    (*** IDirectInputDevice2A methods ***)
    function CreateEffect(guid:TGUID;lpeff:PCDIEFFECT;var ppdeff:IDIRECTINPUTEFFECT;
                          punkouter:pointer) :hresult;
               virtual ; stdcall ; abstract ;
    function EnumEffects(lpCallBack:LPDIENUMEFFECTSCALLBACK;pvref:pointer;
                          dwEffType:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function GetEffectInfo(pdei:PDIEFFECTINFO;guid:TGUID) :hresult;
               virtual ; stdcall ; abstract ;
    function GetForceFeedbackState(pdwOut:PDWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function SendForceFeedbackCommand(dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function EnumCreatedEffectObjects(lpCallBack:LPDIENUMCREATEDEFFECTOBJECTSCALLBACK;
                          pvRef:pointer;fl:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function Escape(pesc:PDIEFFESCAPE) :hresult;
               virtual ; stdcall ; abstract ;
    function Poll :hresult;
               virtual ; stdcall ; abstract ;
    function SendDeviceData(cbObjectData:DWORD;rgdod:PDIDEVICEOBJECTDATA;
                          pdwInOut:PDWORD;fl:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
  end;


(****************************************************************************
 *
 *      Mouse
 *
 ****************************************************************************)

type
  TDIMOUSESTATE = record
    lX, lY, lZ :longint;
    rgbButtons:array[1..4] of byte;
  end;
  PDIMOUSESTATE=^TDIMOUSESTATE;

const
  DIMOFS_X =   0;      { FIELD_OFFSET(DIMOUSESTATE, lX)}
  DIMOFS_Y =   4;      { FIELD_OFFSET(DIMOUSESTATE, lY)}
  DIMOFS_Z =   8;      { FIELD_OFFSET(DIMOUSESTATE, lZ)}
  DIMOFS_BUTTON0=12;   { FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 0)}
  DIMOFS_BUTTON1=13;   { FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 1)}
  DIMOFS_BUTTON2=14;   { FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 2)}
  DIMOFS_BUTTON3=15;   { FIELD_OFFSET(DIMOUSESTATE, rgbButtons) + 3)}


(****************************************************************************
 *
 *      Keyboard
 *
 ****************************************************************************)

(****************************************************************************
 *
 *      DirectInput keyboard scan codes
 *
 ****************************************************************************)

  DIK_ESCAPE          =$01;
  DIK_1               =$02;
  DIK_2               =$03;
  DIK_3               =$04;
  DIK_4               =$05;
  DIK_5               =$06;
  DIK_6               =$07;
  DIK_7               =$08;
  DIK_8               =$09;
  DIK_9               =$0A;
  DIK_0               =$0B;
  DIK_MINUS           =$0C;    (* - on main keyboard *)
  DIK_EQUALS          =$0D;
  DIK_BACK            =$0E;    (* backspace *)
  DIK_TAB             =$0F;
  DIK_Q               =$10;
  DIK_W               =$11;
  DIK_E               =$12;
  DIK_R               =$13;
  DIK_T               =$14;
  DIK_Y               =$15;
  DIK_U               =$16;
  DIK_I               =$17;
  DIK_O               =$18;
  DIK_P               =$19;
  DIK_LBRACKET        =$1A;
  DIK_RBRACKET        =$1B;
  DIK_RETURN          =$1C;    (* Enter on main keyboard *)
  DIK_LCONTROL        =$1D;
  DIK_A               =$1E;
  DIK_S               =$1F;
  DIK_D               =$20;
  DIK_F               =$21;
  DIK_G               =$22;
  DIK_H               =$23;
  DIK_J               =$24;
  DIK_K               =$25;
  DIK_L               =$26;
  DIK_SEMICOLON       =$27;
  DIK_APOSTROPHE      =$28;
  DIK_GRAVE           =$29;    (* accent grave *)
  DIK_LSHIFT          =$2A;
  DIK_BACKSLASH       =$2B;
  DIK_Z               =$2C;
  DIK_X               =$2D;
  DIK_C               =$2E;
  DIK_V               =$2F;
  DIK_B               =$30;
  DIK_N               =$31;
  DIK_M               =$32;
  DIK_COMMA           =$33;
  DIK_PERIOD          =$34;    (* . on main keyboard *)
  DIK_SLASH           =$35;    (* / on main keyboard *)
  DIK_RSHIFT          =$36;
  DIK_MULTIPLY        =$37;    (* * on numeric keypad *)
  DIK_LMENU           =$38;    (* left Alt *)
  DIK_SPACE           =$39;
  DIK_CAPITAL         =$3A;
  DIK_F1              =$3B;
  DIK_F2              =$3C;
  DIK_F3              =$3D;
  DIK_F4              =$3E;
  DIK_F5              =$3F;
  DIK_F6              =$40;
  DIK_F7              =$41;
  DIK_F8              =$42;
  DIK_F9              =$43;
  DIK_F10             =$44;
  DIK_NUMLOCK         =$45;
  DIK_SCROLL          =$46;    (* Scroll Lock *)
  DIK_NUMPAD7         =$47;
  DIK_NUMPAD8         =$48;
  DIK_NUMPAD9         =$49;
  DIK_SUBTRACT        =$4A;    (* - on numeric keypad *)
  DIK_NUMPAD4         =$4B;
  DIK_NUMPAD5         =$4C;
  DIK_NUMPAD6         =$4D;
  DIK_ADD             =$4E;    (* + on numeric keypad *)
  DIK_NUMPAD1         =$4F;
  DIK_NUMPAD2         =$50;
  DIK_NUMPAD3         =$51;
  DIK_NUMPAD0         =$52;
  DIK_DECIMAL         =$53;    (* . on numeric keypad *)
  DIK_F11             =$57;
  DIK_F12             =$58;

  DIK_F13             =$64;    (*                     (NEC PC98) *)
  DIK_F14             =$65;    (*                     (NEC PC98) *)
  DIK_F15             =$66;    (*                     (NEC PC98) *)

  DIK_KANA            =$70;    (* (Japanese keyboard)            *)
  DIK_CONVERT         =$79;    (* (Japanese keyboard)            *)
  DIK_NOCONVERT       =$7B;    (* (Japanese keyboard)            *)
  DIK_YEN             =$7D;    (* (Japanese keyboard)            *)
  DIK_NUMPADEQUALS    =$8D;    (* = on numeric keypad (NEC PC98) *)
  DIK_CIRCUMFLEX      =$90;    (* (Japanese keyboard)            *)
  DIK_AT              =$91;    (*                     (NEC PC98) *)
  DIK_COLON           =$92;    (*                     (NEC PC98) *)
  DIK_UNDERLINE       =$93;    (*                     (NEC PC98) *)
  DIK_KANJI           =$94;    (* (Japanese keyboard)            *)
  DIK_STOP            =$95;    (*                     (NEC PC98) *)
  DIK_AX              =$96;    (*                     (Japan AX) *)
  DIK_UNLABELED       =$97;    (*                        (J3100) *)
  DIK_NUMPADENTER     =$9C;    (* Enter on numeric keypad *)
  DIK_RCONTROL        =$9D;
  DIK_NUMPADCOMMA     =$B3;    (* , on numeric keypad (NEC PC98) *)
  DIK_DIVIDE          =$B5;    (* / on numeric keypad *)
  DIK_SYSRQ           =$B7;
  DIK_RMENU           =$B8;    (* right Alt *)
  DIK_HOME            =$C7;    (* Home on arrow keypad *)
  DIK_UP              =$C8;    (* UpArrow on arrow keypad *)
  DIK_PRIOR           =$C9;    (* PgUp on arrow keypad *)
  DIK_LEFT            =$CB;    (* LeftArrow on arrow keypad *)
  DIK_RIGHT           =$CD;    (* RightArrow on arrow keypad *)
  DIK_END             =$CF;    (* End on arrow keypad *)
  DIK_DOWN            =$D0;    (* DownArrow on arrow keypad *)
  DIK_NEXT            =$D1;    (* PgDn on arrow keypad *)
  DIK_INSERT          =$D2;    (* Insert on arrow keypad *)
  DIK_DELETE          =$D3;    (* Delete on arrow keypad *)
  DIK_LWIN            =$DB;    (* Left Windows key *)
  DIK_RWIN            =$DC;    (* Right Windows key *)
  DIK_APPS            =$DD;    (* AppMenu key *)

(*
 *  Alternate names for keys, to facilitate transition from DOS.
 *)
  DIK_BACKSPACE       =DIK_BACK;            (* backspace *)
  DIK_NUMPADSTAR      =DIK_MULTIPLY;        (* * on numeric keypad *)
  DIK_LALT            =DIK_LMENU;           (* left Alt *)
  DIK_CAPSLOCK        =DIK_CAPITAL ;        (* CapsLock *)
  DIK_NUMPADMINUS     =DIK_SUBTRACT;        (* - on numeric keypad *)
  DIK_NUMPADPLUS      =DIK_ADD ;            (* + on numeric keypad *)
  DIK_NUMPADPERIOD    =DIK_DECIMAL;         (* . on numeric keypad *)
  DIK_NUMPADSLASH     =DIK_DIVIDE;          (* / on numeric keypad *)
  DIK_RALT            =DIK_RMENU ;          (* right Alt *)
  DIK_UPARROW         =DIK_UP;              (* UpArrow on arrow keypad *)
  DIK_PGUP            =DIK_PRIOR;           (* PgUp on arrow keypad *)
  DIK_LEFTARROW       =DIK_LEFT;            (* LeftArrow on arrow keypad *)
  DIK_RIGHTARROW      =DIK_RIGHT;           (* RightArrow on arrow keypad *)
  DIK_DOWNARROW       =DIK_DOWN;            (* DownArrow on arrow keypad *)
  DIK_PGDN            =DIK_NEXT;            (* PgDn on arrow keypad *)


(****************************************************************************
 *
 *      Joystick
 *
 ****************************************************************************)

 type
   TDIJOYSTATE = record
    lX :longint;                     (* x-axis position              *)
    lY :longint;                     (* y-axis position              *)
    lZ :longint;                     (* z-axis position              *)
    lRx :longint;                    (* x-axis rotation              *)
    lRy :longint;                    (* y-axis rotation              *)
    lRz :longint;                    (* z-axis rotation              *)
    rglSlider:array[1..2] of longint;(* extra axes positions         *)
    rgdwPOV:array[1..4] of Dword;    (* POV directions               *)
    rgbButtons:array[1..32] of byte; (* 32 buttons                   *)
   end;
 PDIJOYSTATE=^TDIJOYSTATE;

  TDIJOYSTATE2 = record
    lX :longint;                      (* x-axis position              *)
    lY :longint;                      (* y-axis position              *)
    lZ :longint;                      (* z-axis position              *)
    lRx :longint;                     (* x-axis rotation              *)
    lRy :longint;                     (* y-axis rotation              *)
    lRz :longint;                     (* z-axis rotation              *)
    rglSlider:array[1..2] of longint; (* extra axes positions         *)
    rgdwPOV:array[1..4] of Dword;     (* POV directions               *)
    rgbButtons:array[1..128] of byte; (* 128 buttons                  *)
    lVX :longint;                     (* x-axis velocity              *)
    lVY :longint;                     (* y-axis velocity              *)
    lVZ :longint;                     (* z-axis velocity              *)
    lVRx :longint;                    (* x-axis angular velocity      *)
    lVRy :longint;                    (* y-axis angular velocity      *)
    lVRz :longint;                    (* z-axis angular velocity      *)
    rglVSlider:array[1..2] of longint;(* extra axes velocities        *)
    lAX :longint;                     (* x-axis acceleration          *)
    lAY :longint;                     (* y-axis acceleration          *)
    lAZ :longint;                     (* z-axis acceleration          *)
    lARx :longint;                    (* x-axis angular acceleration  *)
    lARy :longint;                    (* y-axis angular acceleration  *)
    lARz :longint;                    (* z-axis angular acceleration  *)
    rglASlider:array[1..2] of longint;(* extra axes accelerations     *)
    lFX :longint;                     (* x-axis force                 *)
    lFY :longint;                     (* y-axis force                 *)
    lFZ :longint;                     (* z-axis force                 *)
    lFRx :longint;                    (* x-axis torque                *)
    lFRy :longint;                    (* y-axis torque                *)
    lFRz :longint;                    (* z-axis torque                *)
    rglFSlider:array[1..2] of longint;(* extra axes forces            *)
  end;
  PDIJOYSTATE2=^TDIJOYSTATE2;

 {
 const
  DIJOFS_X            FIELD_OFFSET(DIJOYSTATE, lX)
  DIJOFS_Y            FIELD_OFFSET(DIJOYSTATE, lY)
  DIJOFS_Z            FIELD_OFFSET(DIJOYSTATE, lZ)
  DIJOFS_RX           FIELD_OFFSET(DIJOYSTATE, lRx)
  DIJOFS_RY           FIELD_OFFSET(DIJOYSTATE, lRy)
  DIJOFS_RZ           FIELD_OFFSET(DIJOYSTATE, lRz)
  DIJOFS_SLIDER(n)   (FIELD_OFFSET(DIJOYSTATE, rglSlider) + \
                                                        (n) * sizeof(LONG))
  DIJOFS_POV(n)      (FIELD_OFFSET(DIJOYSTATE, rgdwPOV) + \
                                                        (n) * sizeof(DWORD))
  DIJOFS_BUTTON(n)   (FIELD_OFFSET(DIJOYSTATE, rgbButtons) + (n))
  DIJOFS_BUTTON0      DIJOFS_BUTTON(0)
  DIJOFS_BUTTON1      DIJOFS_BUTTON(1)
  DIJOFS_BUTTON2      DIJOFS_BUTTON(2)
  DIJOFS_BUTTON3      DIJOFS_BUTTON(3)
  DIJOFS_BUTTON4      DIJOFS_BUTTON(4)
  DIJOFS_BUTTON5      DIJOFS_BUTTON(5)
  DIJOFS_BUTTON6      DIJOFS_BUTTON(6)
  DIJOFS_BUTTON7      DIJOFS_BUTTON(7)
  DIJOFS_BUTTON8      DIJOFS_BUTTON(8)
  DIJOFS_BUTTON9      DIJOFS_BUTTON(9)
  DIJOFS_BUTTON10     DIJOFS_BUTTON(10)
  DIJOFS_BUTTON11     DIJOFS_BUTTON(11)
  DIJOFS_BUTTON12     DIJOFS_BUTTON(12)
  DIJOFS_BUTTON13     DIJOFS_BUTTON(13)
  DIJOFS_BUTTON14     DIJOFS_BUTTON(14)
  DIJOFS_BUTTON15     DIJOFS_BUTTON(15)
  DIJOFS_BUTTON16     DIJOFS_BUTTON(16)
  DIJOFS_BUTTON17     DIJOFS_BUTTON(17)
  DIJOFS_BUTTON18     DIJOFS_BUTTON(18)
  DIJOFS_BUTTON19     DIJOFS_BUTTON(19)
  DIJOFS_BUTTON20     DIJOFS_BUTTON(20)
  DIJOFS_BUTTON21     DIJOFS_BUTTON(21)
  DIJOFS_BUTTON22     DIJOFS_BUTTON(22)
  DIJOFS_BUTTON23     DIJOFS_BUTTON(23)
  DIJOFS_BUTTON24     DIJOFS_BUTTON(24)
  DIJOFS_BUTTON25     DIJOFS_BUTTON(25)
  DIJOFS_BUTTON26     DIJOFS_BUTTON(26)
  DIJOFS_BUTTON27     DIJOFS_BUTTON(27)
  DIJOFS_BUTTON28     DIJOFS_BUTTON(28)
  DIJOFS_BUTTON29     DIJOFS_BUTTON(29)
  DIJOFS_BUTTON30     DIJOFS_BUTTON(30)
  DIJOFS_BUTTON31     DIJOFS_BUTTON(31)
}

(****************************************************************************
 *
 *  IDirectInput
 *
 ****************************************************************************)

const
  DIENUM_STOP =            0;
  DIENUM_CONTINUE =        1;

type
  LPDIENUMDEVICESCALLBACK=
    function(inst:PCDIDEVICEINSTANCE; p:pointer):bool;stdCall;

const
  DIEDFL_ALLDEVICES       =$00000000;
  DIEDFL_ATTACHEDONLY     =$00000001;
  DIEDFL_FORCEFEEDBACK    =$00000100;

type
  IDirectInput= class(IUnknown)

    (*** IDirectInputA methods ***)
    function CreateDevice(guid:PGUID;var device:IDIRECTINPUTDEVICE;
                          punkOuter:pointer) :hresult;
               virtual ; stdcall ; abstract ;
    function EnumDevices(dwDevType:DWORD;callBack:LPDIENUMDEVICESCALLBACK;
                          pvRef:pointer;dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function GetDeviceStatus(guid:TGUID) :hresult;
               virtual ; stdcall ; abstract ;
    function RunControlPanel(wnd:HWND;dwFlags:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
    function Initialize(HINSTANCE:longint;dwVersion:DWORD) :hresult;
               virtual ; stdcall ; abstract ;
  end;


(* IdirectInput2 not documented  *)
  IDirectInput2= class(IDirectInput)
    (*** IDirectInput2A methods ***)
    function FindDevice(guid:TGUID;st:Pchar;gu:PGUID) :hresult;
               virtual ; stdcall ; abstract ;
  end;


var
  DirectInputCreate: function(HINSTANCE:longint;dwVersion:Dword;
                      var ppDI:IDIRECTINPUT; punkOuter:pointer):hresult;stdCall;



(****************************************************************************
 *
 *  Return Codes
 *
 ****************************************************************************)

 Const
(*
 *  The operation completed successfully.
 *)
  DI_OK                           = S_OK;

(*
 *  The device exists but is not currently attached.
 *)
  DI_NOTATTACHED                  = S_FALSE;

(*
 *  The device buffer overflowed.  Some input was lost.
 *)
  DI_BUFFEROVERFLOW               = S_FALSE;

(*
 *  The change in device properties had no effect.
 *)
  DI_PROPNOEFFECT                 = S_FALSE;

(*
 *  The operation had no effect.
 *)
  DI_NOEFFECT                     = S_FALSE;

(*
 *  The device is a polled device.  As a result, device buffering
 *  will not collect any data and event notifications will not be
 *  signalled until GetDeviceState is called.
 *)
  DI_POLLEDDEVICE                 = $00000002;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but the effect was not
 *  downloaded because the device is not exclusively acquired
 *  or because the DIEP_NODOWNLOAD flag was passed.
 *)
  DI_DOWNLOADSKIPPED              =$00000003;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but in order to change
 *  the parameters, the effect needed to be restarted.
 *)
  DI_EFFECTRESTARTED              =$00000004;

(*
 *  The parameters of the effect were successfully updated by
 *  IDirectInputEffect::SetParameters, but some of them were
 *  beyond the capabilities of the device and were truncated.
 *)
  DI_TRUNCATED                    =$00000008;

(*
 *  Equal to DI_EFFECTRESTARTED | DI_TRUNCATED.
 *)
  DI_TRUNCATEDANDRESTARTED        =$0000000C;

(*
 *  The application requires a newer version of DirectInput.
 *)
  DIERR_OLDDIRECTINPUTVERSION     =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_OLD_WIN_VERSION;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_OLD_WIN_VERSION)}

(*
 *  The application was written for an unsupported prerelease version
 *  of DirectInput.
 *)
  DIERR_BETADIRECTINPUTVERSION    =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_RMODE_APP;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_RMODE_APP)}

(*
 *  The object could not be created due to an incompatible driver version
 *  or mismatched or incomplete driver components.
 *)
  DIERR_BADDRIVERVER              =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_BAD_DRIVER_LEVEL;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_BAD_DRIVER_LEVEL)}

(*
 * The device or device instance or effect is not registered with DirectInput.
 *)
  DIERR_DEVICENOTREG              = REGDB_E_CLASSNOTREG;

(*
 * The requested object does not exist.
 *)
  DIERR_NOTFOUND                  =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_FILE_NOT_FOUND;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_FILE_NOT_FOUND)}

(*
 * The requested object does not exist.
 *)
  DIERR_OBJECTNOTFOUND            =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_FILE_NOT_FOUND;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_FILE_NOT_FOUND)}

(*
 * An invalid parameter was passed to the returning function,
 * or the object was not in a state that admitted the function
 * to be called.
 *)
  DIERR_INVALIDPARAM              = E_INVALIDARG;

(*
 * The specified interface is not supported by the object
 *)
  DIERR_NOINTERFACE               = E_NOINTERFACE;

(*
 * An undetermined error occured inside the DInput subsystem
 *)
  DIERR_GENERIC                   = E_FAIL;

(*
 * The DInput subsystem couldn't allocate sufficient memory to complete the
 * caller's request.
 *)
  DIERR_OUTOFMEMORY               = E_OUTOFMEMORY;

(*
 * The function called is not supported at this time
 *)
  DIERR_UNSUPPORTED               = E_NOTIMPL;

(*
 * This object has not been initialized
 *)
  DIERR_NOTINITIALIZED            =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_NOT_READY;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_NOT_READY)}

(*
 * This object is already initialized
 *)
  DIERR_ALREADYINITIALIZED        =SEVERITY_ERROR or FACILITY_WIN32
                                    or ERROR_ALREADY_INITIALIZED;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_ALREADY_INITIALIZED)}

(*
 * This object does not support aggregation
 *)
  DIERR_NOAGGREGATION             = CLASS_E_NOAGGREGATION;

(*
 * Another app has a higher priority level, preventing this call from
 * succeeding.
 *)
  DIERR_OTHERAPPHASPRIO           = E_ACCESSDENIED;

(*
 * Access to the device has been lost.  It must be re-acquired.
 *)
  DIERR_INPUTLOST                 =SEVERITY_ERROR or FACILITY_WIN32
                                   or ERROR_READ_FAULT;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_READ_FAULT)}

(*
 * The operation cannot be performed while the device is acquired.
 *)
  DIERR_ACQUIRED                  =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_BUSY;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_BUSY)}

(*
 * The operation cannot be performed unless the device is acquired.
 *)
  DIERR_NOTACQUIRED               =SEVERITY_ERROR or FACILITY_WIN32 or ERROR_INVALID_ACCESS;
    {MAKE_HRESULT(SEVERITY_ERROR, FACILITY_WIN32, ERROR_INVALID_ACCESS)}

(*
 * The specified property cannot be changed.
 *)
  DIERR_READONLY                  = E_ACCESSDENIED;

(*
 * The device already has an event notification associated with it.
 *)
  DIERR_HANDLEEXISTS              = E_ACCESSDENIED;

(*
 * Data is not yet available.
 *)
  E_PENDING                       =$80070007;

(*
 * Unable to IDirectInputJoyConfig_Acquire because the user
 * does not have sufficient privileges to change the joystick
 * configuration.
 *)
  DIERR_INSUFFICIENTPRIVS         =$80040200;

(*
 * The device is full.
 *)
  DIERR_DEVICEFULL                =$80040201;

(*
 * Not all the requested information fit into the buffer.
 *)
  DIERR_MOREDATA                  =$80040202;

(*
 * The effect is not downloaded.
 *)
  DIERR_NOTDOWNLOADED             =$80040203;

(*
 *  The device cannot be reinitialized because there are still effects
 *  attached to it.
 *)
  DIERR_HASEFFECTS                =$80040204;

(*
 *  The operation cannot be performed unless the device is acquired
 *  in DISCL_EXCLUSIVE mode.
 *)
  DIERR_NOTEXCLUSIVEACQUIRED      =$80040205;

(*
 *  The effect could not be downloaded because essential information
 *  is missing.  For example, no axes have been associated with the
 *  effect, or no type-specific information has been created.
 *)
  DIERR_INCOMPLETEEFFECT          =$80040206;

(*
 *  Attempted to read buffered device data from a device that is
 *  not buffered.
 *)
  DIERR_NOTBUFFERED               =$80040207;

(*
 *  An attempt was made to modify parameters of an effect while it is
 *  playing.  Not all hardware devices support altering the parameters
 *  of an effect while it is playing.
 *)
  DIERR_EFFECTPLAYING             =$80040208;


(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current sdk files
 *
 ****************************************************************************)


(*
 * Flag to indicate that the dwReserved2 field of the JOYINFOEX structure
 * contains mini-driver specific data to be passed by VJoyD to the mini-
 * driver instead of doing a poll.
 *)
  JOY_PASSDRIVERDATA          =$10000000;

(*
 * Informs the joystick driver that the configuration has been changed
 * and should be reloaded from the registery.
 * dwFlags is reserved and should be set to zero
 *)
var
  joyConfigChanged:function(dwFlags:DWORD ):hresult;

(*
 * Hardware Setting indicating that the device is a headtracker
 *)
 const
  JOY_HWS_ISHEADTRACKER       =$02000000;

(*
 * Hardware Setting indicating that the VxD is used to replace
 * the standard analog polling
 *)
  JOY_HWS_ISGAMEPORTDRIVER    =$04000000;

(*
 * Hardware Setting indicating that the driver needs a standard
 * gameport in order to communicate with the device.
 *)
  JOY_HWS_ISANALOGPORTDRIVER  =$08000000;

(*
 * Hardware Setting indicating that VJoyD should not load this
 * driver, it will be loaded externally and will register with
 * VJoyD of it's own accord.
 *)
  JOY_HWS_AUTOLOAD            =$10000000;

(*
 * Hardware Setting indicating that the driver acquires any
 * resources needed without needing a devnode through VJoyD.
 *)
  JOY_HWS_NODEVNODE           =$20000000;

(*
 * Hardware Setting indicating that the VxD can be used as
 * a port 201h emulator.
 *)
  JOY_HWS_ISGAMEPORTEMULATOR  =$40000000;


(*
 * Usage Setting indicating that the settings are volatile and
 * should be removed if still present on a reboot.
 *)
  JOY_US_VOLATILE             =$00000008;


(****************************************************************************
 *
 *  Definitions for non-IDirectInput (VJoyD) features defined more recently
 *  than the current ddk files
 *
 ****************************************************************************)

Const
(*
 * Poll type in which the do_other field of the JOYOEMPOLLDATA
 * structure contains mini-driver specific data passed from an app.
 *)
 JOY_OEMPOLL_PASSDRIVERDATA = 7;

Implementation

var
  dioKeyBoard:PDIOBJECTDATAFORMAT;
  dioMouse:PDIOBJECTDATAFORMAT;
  dioJK1:PDIOBJECTDATAFORMAT;
  dioJK2:PDIOBJECTDATAFORMAT;

procedure aff(var t);
var
  x:array[1..256] of TDIOBJECTDATAFORMAT ABSOLUTE t;
  i:integer;
begin
  for i:=1 to 256 do
    with x[i] do messageCentral(
     Istr(longint(GUID))+'  '+
     Istr(dwOfs)+'  '+
     Istr(dwType)+'   '+
     Istr(dwFlags) );

end;

procedure initDFDI;
  var
    f:file;
    res:intG;
  begin
    assignFile(f,trouverChemin('Dinput.lib')+'Dinput.lib');
    Greset(f,1);
    if GIO<>0 then
      begin
        messageCentral('Unable to find Dinput.lib');
        exit;
      end;

    getmem(dioKeyBoard,sizeof(TDIOBJECTDATAFORMAT)*256);
    Gseek(f,$1EFA);
    Gblockread(f,dioKeyBoard^,sizeof(TDIOBJECTDATAFORMAT)*256,res);
    Gseek(f,$2EFA);
    Gblockread(f,c_dfDIKeyboard,sizeof(c_dfDIKeyboard),res);
    c_dfDIKeyboard.rgodf:=dioKeyBoard;

    getmem(dioMouse,sizeof(TDIOBJECTDATAFORMAT)*7);
    Gseek(f,$3A4A);
    Gblockread(f,dioMouse^,sizeof(TDIOBJECTDATAFORMAT)*7,res);
    Gseek(f,$3ABA);
    Gblockread(f,c_dfDIMouse,sizeof(c_dfDIMouse),res);
    c_dfDIMouse.rgodf:=dioMouse;

    getmem(dioJK1,sizeof(TDIOBJECTDATAFORMAT)*164);
    Gseek(f,$0BD4);
    Gblockread(f,dioJK1^,sizeof(TDIOBJECTDATAFORMAT)*164,res);
    Gseek(f,$1614);
    Gblockread(f,c_dfDIJoyStick,sizeof(c_dfDIjoyStick),res);
    c_dfDIJoystick.rgodf:=dioJK1;

    getmem(dioJK2,sizeof(TDIOBJECTDATAFORMAT)*44);
    Gseek(f,$19A0);
    Gblockread(f,dioJK2^,sizeof(TDIOBJECTDATAFORMAT)*44,res);
    Gseek(f,$1C60);
    Gblockread(f,c_dfDIJoyStick2,sizeof(c_dfDIjoyStick2),res);
    c_dfDIJoystick2.rgodf:=dioJK2;


    Gclose(f);

    {aff(dioKeyBoard^);}

    if GIO<>0 then messageCentral('Error reading Dinput.lib');

  end;




var
  hMod: THandle;

initialization
begin
  hMod := GLoadLibrary('dinput.dll');
  if (hMod <> 0) then
    begin
      DirectInputCreate := GetProcAddress( hMod, 'DirectInputCreateA' );
      if not assigned(DirectInputCreate) then messageCentral('DirectInputCreate not found');
    end
  else messageCentral('Dinput.dll not found');

  initDFDI;

end;

finalization

FreeLibrary( hMod );

end.
