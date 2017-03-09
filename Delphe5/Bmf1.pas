unit bmf1;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1;

TYPE
  DATESTRING = STRING[8];
  TIMESTRING = STRING[8];
  TYPESTRING = STRING[10];
  MODULEIDENTSTRING = STRING[12];
  TITLESTRING = STRING[25];

CONST
  BMFIdent =         'BIO-LOGIC MODULAR FILE' + #26;
  Module =           'MODULE';
  PatchConfigType =  'PATCH_CFG ';
  SignalType  =      'SIGNAL    ';
  XYSignalType  =    'XYSIGNAL  ';
  StimType  =        'STIM      ';
  MATType  =         'MAT       ';
  CommentType  =     'COMMENTS  ';

  BMFFileHeaderSize = 52;
  BMFModuleHeaderSize = 57;
  BMFMATSize = 43;
  BMFSignal_HeaderSize = 146;
  BMFXYSignal_HeaderSize = 89;
  BMFStimHeaderSize = 5;
  BMFStimPulseSize = 66;
  BMFPatchConfigSize = 77;

  DOUBLE_DATA = 0;
  SINGLE_DATA = 1;
  LONGINT_DATA = 2;
  INTEGER_DATA = 3;
  BYTE_DATA = 4;
  INTEGER_GAIN_DATA = 5;
  REAL_DATA = 6;

TYPE

{ Configuration relative à un amplificateur de patch (RK300, RK400 et Visual-Patch)
dépend de la manip mais sans se soucier de l'acquisition.
Ce module peut être sauvé avec chaque module d'acquisition, ou sauvé indépendamment
et récupéré par le logiciel }
  BmfPatch_Config =
        RECORD { 77 octets }
          ViMode : BYTE;	       { 0 : Vc  1 : Io  2 : Ic  3 : VTrack }
          TimeCstLoop : SINGLE; { Cste de temps de la boucle en modes Io ou Ic in sec }
	  CFast : SINGLE;
	  TauFast : SINGLE;
	  CSlow : SINGLE;
	  TauSlow : SINGLE;
	  Cm : SINGLE;
	  Taum : SINGLE;
	  PercentRes : SINGLE;
	  PercentBoost : SINGLE;
	  LagPercentRes : SINGLE;
	  Leak : SINGLE;
	  Junction : SINGLE;
	  VIHold : SINGLE;
	  PRBSAmpl : SINGLE;
          TimeCstCommand : SINGLE; { valeur du round en ms. 0 si pas de round }
          GainTete : SINGLE;	   { en ohms }
          ZapLong : SINGLE;        { durée du zap en µs }
          ResRatio : SINGLE;
          ResEq : SINGLE;
        END;

  BmfFileHeader =
               RECORD                                { 52 octets }
		 ident : ARRAY[1..23] of char;
                 title : ARRAY[1..25] of char;
                 MATOffset : LONGINT;
               END;
  BmfModuleHeader =
               RECORD                              { 57 octets }
		   KeyWord : ARRAY[1..6] of CHAR;
                   ident : ARRAY[1..10] of CHAR;
                   title : ARRAY[1..25] of CHAR;
                   size : LONGINT;
                   ref	: LONGINT;
                   date : ARRAY[1..8] of char;
               END;
  BMFMATModule = RECORD
		  ModuleType : ARRAY[1..10] of CHAR;
                  ModuleTitle : ARRAY[1..25] of CHAR;
                  Offset : LONGINT;
                  Ref : LONGINT;
                 END;
  BmfSignal =  RECORD                      { 146 octets }
                 StartTime : ARRAY[1..8] of char;
                 NbPointsEp : LONGINT;
                 NbEpisodes : WORD;
                 Interval_uS : DOUBLE;		{ en us }
                 Offset_uS : DOUBLE;
                 DataType : smallint;
                 UnitX : ARRAY[1..30] of CHAR;
                 UnitY : ARRAY[1..30] of CHAR;
                 Gain : DOUBLE;    { mv/pA (Iout)  ou  mv/mv (Vm) }
                 CutOffRate_Hz : DOUBLE;   { en Hz }
                 ADCMaxScale_mV : LONGINT; { mv    }
                 ADCNbBits : BYTE;
                 epStart : BOOLEAN;
                 epStartUnit : ARRAY[1..30] of CHAR;
                 nbObjects : smallint;
               END;
  BmfXYSignal =RECORD                      { 89 octets }
                 StartTime : ARRAY[1..8] of char;
                 NbPoints : LONGINT;
                 DataType : smallint;
                 UnitX : ARRAY[1..30] of CHAR;
                 UnitY : ARRAY[1..30] of CHAR;
                 Gain : DOUBLE;
                 ADCMaxScale_mV : LONGINT; { mv }
                 ADCNbBits : BYTE;
                 nbObjects : smallint;
               END;
  BMFStimPulse = RECORD { 66 bytes }
                   Ramp		: Boolean;		{ TRUE : Ramp, FALSE : Pulse }
                   AmplFirst	: Longint;	{ Amplitude at the first episode }
                   AmplLast	: Longint;	{ Amplitude at the last episode }
                   AmplIncr	: Longint;	{ Amplitude increment }
                   AmplUnit	: Byte;			{ 0 : voltage	1 : current ... }
                   AmplScale	: Byte;
                   AmplStep	: Byte;			{ Stay  "AmplStep" times on each amplitude }
                   AmplRep	: smallint;		{ Repeat : see #1 }
                   AmplRet	: Boolean;		{ Return : see # 2 }
                   DurFirst	: Longint;	{ Duration at the first episode }
                   DurLast	: Longint;	{ Duration at the last episode }
                   DurIncr	: Longint;	{ Duration increment }
                   DurScale	: Byte;			{ 0 : second  1 : ms  2 : µs }
                   DurStep	: Byte;			{ Stay "DurStep" on each duration }
                   DurRep	: smallint;		{ Repeat : see #1 }
                   DurRet	: Boolean;		{ Return : see #2 }
                   Sync		: Boolean;		{ TRUE : A synchronization trigger is generated }
                   SyncValue	: Longint;	{ Time at which the synchro trigger is generated }
                   AmplLastTime : Longint;	{ Amplitude at the last time development }
                   AmplIncrTime : Longint;	{ Amplitude increment of time development }
                   AmplStepTime : Byte;		{ Stay "AmplStepTime" on each time amplitude }
                   AmplRepTime : smallint;
                   AmplRetTime : Boolean;
                   DurLastTime : Longint;	{ Duration at the last time development }
                   DurIncrTime	: Longint;	{ Duration increment of time development }
                   DurStepTime : Byte;			{ Stay "DurStepTime" on each time duration }
                   DurRepTime : smallint;
                   DurRetTime : Boolean;
                   SyncTime	: Boolean;			{ Synchro in time }
               	 END;
  BMFStimHeader = RECORD        { 5 bytes }
		    NbWords : Word;
                    NbEpisodes : Word;
                    TimeDev : Boolean;
                  END;

IMPLEMENTATION

end.
