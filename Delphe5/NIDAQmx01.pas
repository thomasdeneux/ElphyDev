unit NIDAQmx01;

{ Conversion de NIDAQmx.h en Pascal

  Une astuce consiste à charger le fichier  NiDAQmx.tlb dans l'éditeur de bibliothèque de type de Delphi
  et à le resauver. On obtient alors le fichier NiDAQmxCAPI_TLB.pas

  Ce fichier contient la plupart des déclarations de types du fichier NiDaqmx.h

  Il faut encore ajouter les conversions des prototypes C de fonctions


 }
interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows;

const
  // Versions majeure et mineure de la bibliothèque de types
  NIDAQmxCAPIMajorVersion = 8;
  NIDAQmxCAPIMinorVersion = 3;

  LIBID_NIDAQmxCAPI: TGUID = '{3F91BB81-371C-4447-A3CF-110B9875D4B0}';


// *********************************************************************//
// Déclaration d'énumérations définies dans la bibliothèque de types
// *********************************************************************//
// Constantes pour enum DAQmxTaskMode
type
  DAQmxTaskMode = LongWord;
const
  DAQmx_Val_Task_Start = $00000000;
  DAQmx_Val_Task_Stop = $00000001;
  DAQmx_Val_Task_Verify = $00000002;
  DAQmx_Val_Task_Commit = $00000003;
  DAQmx_Val_Task_Reserve = $00000004;
  DAQmx_Val_Task_Unreserve = $00000005;
  DAQmx_Val_Task_Abort = $00000006;

// Constantes pour enum DAQmxWDTTaskAction
type
  DAQmxWDTTaskAction = LongWord;
const
  DAQmx_Val_ResetTimer = $00000000;
  DAQmx_Val_ClearExpiration = $00000001;

// Constantes pour enum DAQmxLineGrouping
type
  DAQmxLineGrouping = LongWord;
const
  DAQmx_Val_ChanPerLine = $00000000;
  DAQmx_Val_ChanForAllLines = $00000001;

// Constantes pour enum DAQmxFillMode
type
  DAQmxFillMode = LongWord;
const
  DAQmx_Val_GroupByChannel = $00000000;
  DAQmx_Val_GroupByScanNumber = $00000001;

// Constantes pour enum DAQmxSignalModifiers
type
  DAQmxSignalModifiers = LongWord;
const
  DAQmx_Val_DoNotInvertPolarity = $00000000;
  DAQmx_Val_InvertPolarity = $00000001;

// Constantes pour enum DAQmxAction
type
  DAQmxAction = LongWord;
const
  DAQmx_Val_Action_Commit = $00000000;
  DAQmx_Val_Action_Cancel = $00000001;

// Constantes pour enum DAQmxSoftwareTrigger
type
  DAQmxSoftwareTrigger = LongWord;
const
  DAQmx_Val_AdvanceTrigger = $000030C8;

// Constantes pour enum DAQmxEdge
type
  DAQmxEdge = LongWord;
const
  DAQmx_Val_Rising = $00002828;
  DAQmx_Val_Falling = $000027BB;

// Constantes pour enum DAQmxSwitchPathType
type
  DAQmxSwitchPathType = LongWord;
const
  DAQmx_Val_PathStatus_Available = $000028BF;
  DAQmx_Val_PathStatus_AlreadyExists = $000028C0;
  DAQmx_Val_PathStatus_Unsupported = $000028C1;
  DAQmx_Val_PathStatus_ChannelInUse = $000028C2;
  DAQmx_Val_PathStatus_SourceChannelConflict = $000028C3;
  DAQmx_Val_PathStatus_ChannelReservedForRouting = $000028C4;

// Constantes pour enum DAQmxTemperatureUnits
type
  DAQmxTemperatureUnits = LongWord;
const
  DAQmx_Val_DegC = $0000279F;
  DAQmx_Val_DegF = $000027A0;
  DAQmx_Val_Kelvins = $00002855;
  DAQmx_Val_DegR = $000027A1;

// Constantes pour enum DAQmxPowerUpStates
type
  DAQmxPowerUpStates = LongWord;
const
  DAQmx_Val_High = $000027D0;
  DAQmx_Val_Low = $000027E6;
  DAQmx_Val_Tristate = $00002846;

// Constantes pour enum DAQmxPowerUpChannelType
type
  DAQmxPowerUpChannelType = LongWord;
const
  DAQmx_Val_ChannelVoltage = $00000000;
  DAQmx_Val_ChannelCurrent = $00000001;

// Constantes pour enum DAQmxRelayPos
type
  DAQmxRelayPos = LongWord;
const
  DAQmx_Val_Open = $000028C5;
  DAQmx_Val_Closed = $000028C6;

// Constantes pour enum DAQmx_Cfg_Default
type
  DAQmx_Cfg_Default = LongWord;
const
  DAQmx_Val_Cfg_Default = $FFFFFFFF;

// Constantes pour enum DAQmx_Timeout_Values
type
  DAQmx_Timeout_Values = LongWord;
const
  DAQmx_Val_WaitInfinitely = $C0800000;

// Constantes pour enum DAQmx_NumSamples_Values
type
  DAQmx_NumSamples_Values = LongWord;
const
  DAQmx_Val_Auto = $FFFFFFFF;

// Constantes pour enum DAQmx_Save_Options_Values
type
  DAQmx_Save_Options_Values = LongWord;
const
  DAQmx_Val_Save_Overwrite = $00000001;
  DAQmx_Val_Save_AllowInteractiveEditing = $00000002;
  DAQmx_Val_Save_AllowInteractiveDeletion = $00000004;

// Constantes pour enum DAQmxEveryNSamplesEventType
type
  DAQmxEveryNSamplesEventType = LongWord;
const
  DAQmx_Val_Acquired_Into_Buffer = $00000001;
  DAQmx_Val_Transferred_From_Buffer = $00000002;

// Constantes pour enum DAQmxACExcitWireMode
type
  DAQmxACExcitWireMode = LongWord;
const
  DAQmx_Val_ACExcitWireMode_4Wire = $00000004;
  DAQmx_Val_ACExcitWireMode_5Wire = $00000005;

// Constantes pour enum DAQmxAIMeasurementType
type
  DAQmxAIMeasurementType = LongWord;
const
  DAQmx_Val_AIMeasurementType_Voltage = $00002852;
  DAQmx_Val_AIMeasurementType_Current = $00002796;
  DAQmx_Val_AIMeasurementType_Voltage_CustomWithExcitation = $00002853;
  DAQmx_Val_AIMeasurementType_Freq_Voltage = $000027C5;
  DAQmx_Val_AIMeasurementType_Resistance = $00002826;
  DAQmx_Val_AIMeasurementType_Temp_TC = $0000283F;
  DAQmx_Val_AIMeasurementType_Temp_Thrmstr = $0000283E;
  DAQmx_Val_AIMeasurementType_Temp_RTD = $0000283D;
  DAQmx_Val_AIMeasurementType_Temp_BuiltInSensor = $00002847;
  DAQmx_Val_AIMeasurementType_Strain_Gage = $0000283C;
  DAQmx_Val_AIMeasurementType_Position_LVDT = $00002870;
  DAQmx_Val_AIMeasurementType_Position_RVDT = $00002871;
  DAQmx_Val_AIMeasurementType_Accelerometer = $00002874;
  DAQmx_Val_AIMeasurementType_SoundPressure_Microphone = $00002872;
  DAQmx_Val_AIMeasurementType_TEDS_Sensor = $000030F3;

// Constantes pour enum DAQmxAOIdleOutputBehavior
type
  DAQmxAOIdleOutputBehavior = LongWord;
const
  DAQmx_Val_AOIdleOutputBehavior_ZeroVolts = $000030EE;
  DAQmx_Val_AOIdleOutputBehavior_HighImpedance = $000030EF;
  DAQmx_Val_AOIdleOutputBehavior_MaintainExistingValue = $000030F0;

// Constantes pour enum DAQmxAOOutputChannelType
type
  DAQmxAOOutputChannelType = LongWord;
const
  DAQmx_Val_AOOutputChannelType_Voltage = $00002852;
  DAQmx_Val_AOOutputChannelType_Current = $00002796;

// Constantes pour enum DAQmxAccelSensitivityUnits1
type
  DAQmxAccelSensitivityUnits1 = LongWord;
const
  DAQmx_Val_AccelSensitivityUnits1_mVoltsPerG = $000030DD;
  DAQmx_Val_AccelSensitivityUnits1_VoltsPerG = $000030DE;

// Constantes pour enum DAQmxAccelUnits2
type
  DAQmxAccelUnits2 = LongWord;
const
  DAQmx_Val_AccelUnits2_AccelUnit_g = $000027CA;
  DAQmx_Val_AccelUnits2_MetersPerSecondSquared = $000030B6;
  DAQmx_Val_AccelUnits2_FromCustomScale = $00002751;

// Constantes pour enum DAQmxAcquisitionType
type
  DAQmxAcquisitionType = LongWord;
const
  DAQmx_Val_AcquisitionType_FiniteSamps = $000027C2;
  DAQmx_Val_AcquisitionType_ContSamps = $0000278B;
  DAQmx_Val_AcquisitionType_HWTimedSinglePoint = $000030EA;

// Constantes pour enum DAQmxActiveLevel
type
  DAQmxActiveLevel = LongWord;
const
  DAQmx_Val_ActiveLevel_AboveLvl = $0000276D;
  DAQmx_Val_ActiveLevel_BelowLvl = $0000277B;

// Constantes pour enum DAQmxAngleUnits1
type
  DAQmxAngleUnits1 = LongWord;
const
  DAQmx_Val_AngleUnits1_Degrees = $000027A2;
  DAQmx_Val_AngleUnits1_Radians = $00002821;
  DAQmx_Val_AngleUnits1_FromCustomScale = $00002751;

// Constantes pour enum DAQmxAngleUnits2
type
  DAQmxAngleUnits2 = LongWord;
const
  DAQmx_Val_AngleUnits2_Degrees = $000027A2;
  DAQmx_Val_AngleUnits2_Radians = $00002821;
  DAQmx_Val_AngleUnits2_Ticks = $00002840;
  DAQmx_Val_AngleUnits2_FromCustomScale = $00002751;

// Constantes pour enum DAQmxAutoZeroType1
type
  DAQmxAutoZeroType1 = LongWord;
const
  DAQmx_Val_AutoZeroType1_None = $000027F6;
  DAQmx_Val_AutoZeroType1_Once = $00002804;
  DAQmx_Val_AutoZeroType1_EverySample = $000027B4;

// Constantes pour enum DAQmxBreakMode
type
  DAQmxBreakMode = LongWord;
const
  DAQmx_Val_BreakMode_NoAction = $000027F3;
  DAQmx_Val_BreakMode_BreakBeforeMake = $0000277E;

// Constantes pour enum DAQmxBridgeConfiguration1
type
  DAQmxBridgeConfiguration1 = LongWord;
const
  DAQmx_Val_BridgeConfiguration1_FullBridge = $000027C6;
  DAQmx_Val_BridgeConfiguration1_HalfBridge = $000027CB;
  DAQmx_Val_BridgeConfiguration1_QuarterBridge = $0000281E;
  DAQmx_Val_BridgeConfiguration1_NoBridge = $000027F4;

// Constantes pour enum DAQmxBusType
type
  DAQmxBusType = LongWord;
const
  DAQmx_Val_BusType_PCI = $00003126;
  DAQmx_Val_BusType_PCIe = $0000352C;
  DAQmx_Val_BusType_PXI = $00003127;
  DAQmx_Val_BusType_SCXI = $00003128;
  DAQmx_Val_BusType_PCCard = $00003129;
  DAQmx_Val_BusType_USB = $0000312A;
  DAQmx_Val_BusType_CompactDAQ = $0000392D;
  DAQmx_Val_BusType_Unknown = $0000312C;

// Constantes pour enum DAQmxCIMeasurementType
type
  DAQmxCIMeasurementType = LongWord;
const
  DAQmx_Val_CIMeasurementType_CountEdges = $0000278D;
  DAQmx_Val_CIMeasurementType_Freq = $000027C3;
  DAQmx_Val_CIMeasurementType_Period = $00002810;
  DAQmx_Val_CIMeasurementType_PulseWidth = $00002877;
  DAQmx_Val_CIMeasurementType_SemiPeriod = $00002831;
  DAQmx_Val_CIMeasurementType_Position_AngEncoder = $00002878;
  DAQmx_Val_CIMeasurementType_Position_LinEncoder = $00002879;
  DAQmx_Val_CIMeasurementType_TwoEdgeSep = $0000281B;
  DAQmx_Val_CIMeasurementType_GPS_Timestamp = $0000287A;

// Constantes pour enum DAQmxCJCSource1
type
  DAQmxCJCSource1 = LongWord;
const
  DAQmx_Val_CJCSource1_BuiltIn = $000027D8;
  DAQmx_Val_CJCSource1_ConstVal = $00002784;
  DAQmx_Val_CJCSource1_Chan = $00002781;

// Constantes pour enum DAQmxCOOutputType
type
  DAQmxCOOutputType = LongWord;
const
  DAQmx_Val_COOutputType_Pulse_Time = $0000281D;
  DAQmx_Val_COOutputType_Pulse_Freq = $00002787;
  DAQmx_Val_COOutputType_Pulse_Ticks = $0000281C;

// Constantes pour enum DAQmxChannelType
type
  DAQmxChannelType = LongWord;
const
  DAQmx_Val_ChannelType_AI = $00002774;
  DAQmx_Val_ChannelType_AO = $00002776;
  DAQmx_Val_ChannelType_DI = $000027A7;
  DAQmx_Val_ChannelType_DO = $000027A9;
  DAQmx_Val_ChannelType_CI = $00002793;
  DAQmx_Val_ChannelType_CO = $00002794;

// Constantes pour enum DAQmxCountDirection1
type
  DAQmxCountDirection1 = LongWord;
const
  DAQmx_Val_CountDirection1_CountUp = $00002790;
  DAQmx_Val_CountDirection1_CountDown = $0000278C;
  DAQmx_Val_CountDirection1_ExtControlled = $00002856;

// Constantes pour enum DAQmxCounterFrequencyMethod
type
  DAQmxCounterFrequencyMethod = LongWord;
const
  DAQmx_Val_CounterFrequencyMethod_LowFreq1Ctr = $00002779;
  DAQmx_Val_CounterFrequencyMethod_HighFreq2Ctr = $000027AD;
  DAQmx_Val_CounterFrequencyMethod_LargeRng2Ctr = $000027DD;

// Constantes pour enum DAQmxCoupling1
type
  DAQmxCoupling1 = LongWord;
const
  DAQmx_Val_Coupling1_AC = $0000273D;
  DAQmx_Val_Coupling1_DC = $00002742;
  DAQmx_Val_Coupling1_GND = $00002752;

// Constantes pour enum DAQmxCoupling2
type
  DAQmxCoupling2 = LongWord;
const
  DAQmx_Val_Coupling2_AC = $0000273D;
  DAQmx_Val_Coupling2_DC = $00002742;

// Constantes pour enum DAQmxCurrentShuntResistorLocation1
type
  DAQmxCurrentShuntResistorLocation1 = LongWord;
const
  DAQmx_Val_CurrentShuntResistorLocation1_Internal = $000027D8;
  DAQmx_Val_CurrentShuntResistorLocation1_External = $000027B7;

// Constantes pour enum DAQmxCurrentUnits1
type
  DAQmxCurrentUnits1 = LongWord;
const
  DAQmx_Val_CurrentUnits1_Amps = $00002866;
  DAQmx_Val_CurrentUnits1_FromCustomScale = $00002751;
  DAQmx_Val_CurrentUnits1_FromTEDS = $000030E4;

// Constantes pour enum DAQmxCurrentUnits2
type
  DAQmxCurrentUnits2 = LongWord;
const
  DAQmx_Val_CurrentUnits2_Amps = $00002866;
  DAQmx_Val_CurrentUnits2_FromCustomScale = $00002751;

// Constantes pour enum DAQmxDataJustification1
type
  DAQmxDataJustification1 = LongWord;
const
  DAQmx_Val_DataJustification1_RightJustified = $00002827;
  DAQmx_Val_DataJustification1_LeftJustified = $000027E1;

// Constantes pour enum DAQmxDataTransferMechanism
type
  DAQmxDataTransferMechanism = LongWord;
const
  DAQmx_Val_DataTransferMechanism_DMA = $00002746;
  DAQmx_Val_DataTransferMechanism_Interrupts = $000027DC;
  DAQmx_Val_DataTransferMechanism_ProgrammedIO = $00002818;
  DAQmx_Val_DataTransferMechanism_USBbulk = $0000312E;

// Constantes pour enum DAQmxDeassertCondition
type
  DAQmxDeassertCondition = LongWord;
const
  DAQmx_Val_DeassertCondition_OnbrdMemMoreThanHalfFull = $000027FD;
  DAQmx_Val_DeassertCondition_OnbrdMemFull = $000027FC;
  DAQmx_Val_DeassertCondition_OnbrdMemCustomThreshold = $00003121;

// Constantes pour enum DAQmxDigitalDriveType
type
  DAQmxDigitalDriveType = LongWord;
const
  DAQmx_Val_DigitalDriveType_ActiveDrive = $0000311D;
  DAQmx_Val_DigitalDriveType_OpenCollector = $0000311E;

// Constantes pour enum DAQmxDigitalLineState
type
  DAQmxDigitalLineState = LongWord;
const
  DAQmx_Val_DigitalLineState_High = $000027D0;
  DAQmx_Val_DigitalLineState_Low = $000027E6;
  DAQmx_Val_DigitalLineState_Tristate = $00002846;
  DAQmx_Val_DigitalLineState_NoChange = $000027B0;

// Constantes pour enum DAQmxDigitalPatternCondition1
type
  DAQmxDigitalPatternCondition1 = LongWord;
const
  DAQmx_Val_DigitalPatternCondition1_PatternMatches = $0000280E;
  DAQmx_Val_DigitalPatternCondition1_PatternDoesNotMatch = $0000280D;

// Constantes pour enum DAQmxDigitalWidthUnits1
type
  DAQmxDigitalWidthUnits1 = LongWord;
const
  DAQmx_Val_DigitalWidthUnits1_SampClkPeriods = $0000282E;
  DAQmx_Val_DigitalWidthUnits1_Seconds = $0000287C;
  DAQmx_Val_DigitalWidthUnits1_Ticks = $00002840;

// Constantes pour enum DAQmxDigitalWidthUnits2
type
  DAQmxDigitalWidthUnits2 = LongWord;
const
  DAQmx_Val_DigitalWidthUnits2_Seconds = $0000287C;
  DAQmx_Val_DigitalWidthUnits2_Ticks = $00002840;

// Constantes pour enum DAQmxDigitalWidthUnits3
type
  DAQmxDigitalWidthUnits3 = LongWord;
const
  DAQmx_Val_DigitalWidthUnits3_Seconds = $0000287C;

// Constantes pour enum DAQmxEdge1
type
  DAQmxEdge1 = LongWord;
const
  DAQmx_Val_Edge1_Rising = $00002828;
  DAQmx_Val_Edge1_Falling = $000027BB;

// Constantes pour enum DAQmxEncoderType2
type
  DAQmxEncoderType2 = LongWord;
const
  DAQmx_Val_EncoderType2_X1 = $0000276A;
  DAQmx_Val_EncoderType2_X2 = $0000276B;
  DAQmx_Val_EncoderType2_X4 = $0000276C;
  DAQmx_Val_EncoderType2_TwoPulseCounting = $00002849;

// Constantes pour enum DAQmxEncoderZIndexPhase1
type
  DAQmxEncoderZIndexPhase1 = LongWord;
const
  DAQmx_Val_EncoderZIndexPhase1_AHighBHigh = $00002738;
  DAQmx_Val_EncoderZIndexPhase1_AHighBLow = $00002739;
  DAQmx_Val_EncoderZIndexPhase1_ALowBHigh = $0000273A;
  DAQmx_Val_EncoderZIndexPhase1_ALowBLow = $0000273B;

// Constantes pour enum DAQmxExcitationDCorAC
type
  DAQmxExcitationDCorAC = LongWord;
const
  DAQmx_Val_ExcitationDCorAC_DC = $00002742;
  DAQmx_Val_ExcitationDCorAC_AC = $0000273D;

// Constantes pour enum DAQmxExcitationSource
type
  DAQmxExcitationSource = LongWord;
const
  DAQmx_Val_ExcitationSource_Internal = $000027D8;
  DAQmx_Val_ExcitationSource_External = $000027B7;
  DAQmx_Val_ExcitationSource_None = $000027F6;

// Constantes pour enum DAQmxExcitationVoltageOrCurrent
type
  DAQmxExcitationVoltageOrCurrent = LongWord;
const
  DAQmx_Val_ExcitationVoltageOrCurrent_Voltage = $00002852;
  DAQmx_Val_ExcitationVoltageOrCurrent_Current = $00002796;

// Constantes pour enum DAQmxExportActions2
type
  DAQmxExportActions2 = LongWord;
const
  DAQmx_Val_ExportActions2_Pulse = $00002819;
  DAQmx_Val_ExportActions2_Toggle = $00002843;

// Constantes pour enum DAQmxExportActions3
type
  DAQmxExportActions3 = LongWord;
const
  DAQmx_Val_ExportActions3_Pulse = $00002819;
  DAQmx_Val_ExportActions3_Lvl = $000027E2;

// Constantes pour enum DAQmxExportActions5
type
  DAQmxExportActions5 = LongWord;
const
  DAQmx_Val_ExportActions5_Interlocked = $00003105;
  DAQmx_Val_ExportActions5_Pulse = $00002819;

// Constantes pour enum DAQmxFrequencyUnits
type
  DAQmxFrequencyUnits = LongWord;
const
  DAQmx_Val_FrequencyUnits_Hz = $00002885;
  DAQmx_Val_FrequencyUnits_FromCustomScale = $00002751;

// Constantes pour enum DAQmxFrequencyUnits2
type
  DAQmxFrequencyUnits2 = LongWord;
const
  DAQmx_Val_FrequencyUnits2_Hz = $00002885;

// Constantes pour enum DAQmxFrequencyUnits3
type
  DAQmxFrequencyUnits3 = LongWord;
const
  DAQmx_Val_FrequencyUnits3_Hz = $00002885;
  DAQmx_Val_FrequencyUnits3_Ticks = $00002840;
  DAQmx_Val_FrequencyUnits3_FromCustomScale = $00002751;

// Constantes pour enum DAQmxGpsSignalType1
type
  DAQmxGpsSignalType1 = LongWord;
const
  DAQmx_Val_GpsSignalType1_IRIGB = $00002756;
  DAQmx_Val_GpsSignalType1_PPS = $00002760;
  DAQmx_Val_GpsSignalType1_None = $000027F6;

// Constantes pour enum DAQmxHandshakeStartCondition
type
  DAQmxHandshakeStartCondition = LongWord;
const
  DAQmx_Val_HandshakeStartCondition_Immediate = $000027D6;
  DAQmx_Val_HandshakeStartCondition_WaitForHandshakeTriggerAssert = $00003106;
  DAQmx_Val_HandshakeStartCondition_WaitForHandshakeTriggerDeassert = $00003107;

// Constantes pour enum DAQmxInputDataTransferCondition
type
  DAQmxInputDataTransferCondition = LongWord;
const
  DAQmx_Val_InputDataTransferCondition_OnBrdMemMoreThanHalfFull = $000027FD;
  DAQmx_Val_InputDataTransferCondition_OnBrdMemNotEmpty = $00002801;
  DAQmx_Val_InputDataTransferCondition_OnbrdMemCustomThreshold = $00003121;
  DAQmx_Val_InputDataTransferCondition_WhenAcqComplete = $00003102;

// Constantes pour enum DAQmxInputTermCfg
type
  DAQmxInputTermCfg = LongWord;
const
  DAQmx_Val_InputTermCfg_RSE = $00002763;
  DAQmx_Val_InputTermCfg_NRSE = $0000275E;
  DAQmx_Val_InputTermCfg_Diff = $0000277A;
  DAQmx_Val_InputTermCfg_PseudoDiff = $000030F1;

// Constantes pour enum DAQmxLVDTSensitivityUnits1
type
  DAQmxLVDTSensitivityUnits1 = LongWord;
const
  DAQmx_Val_LVDTSensitivityUnits1_mVoltsPerVoltPerMillimeter = $000030DA;
  DAQmx_Val_LVDTSensitivityUnits1_mVoltsPerVoltPerMilliInch = $000030D9;

// Constantes pour enum DAQmxLengthUnits2
type
  DAQmxLengthUnits2 = LongWord;
const
  DAQmx_Val_LengthUnits2_Meters = $000027EB;
  DAQmx_Val_LengthUnits2_Inches = $0000288B;
  DAQmx_Val_LengthUnits2_FromCustomScale = $00002751;

// Constantes pour enum DAQmxLengthUnits3
type
  DAQmxLengthUnits3 = LongWord;
const
  DAQmx_Val_LengthUnits3_Meters = $000027EB;
  DAQmx_Val_LengthUnits3_Inches = $0000288B;
  DAQmx_Val_LengthUnits3_Ticks = $00002840;
  DAQmx_Val_LengthUnits3_FromCustomScale = $00002751;

// Constantes pour enum DAQmxLevel1
type
  DAQmxLevel1 = LongWord;
const
  DAQmx_Val_Level1_High = $000027D0;
  DAQmx_Val_Level1_Low = $000027E6;

// Constantes pour enum DAQmxLogicFamily
type
  DAQmxLogicFamily = LongWord;
const
  DAQmx_Val_LogicFamily_2point5V = $0000391C;
  DAQmx_Val_LogicFamily_3point3V = $0000391D;
  DAQmx_Val_LogicFamily_5V = $0000391B;

// Constantes pour enum DAQmxMIOAIConvertTbSrc
type
  DAQmxMIOAIConvertTbSrc = LongWord;
const
  DAQmx_Val_MIOAIConvertTbSrc_SameAsSampTimebase = $0000282C;
  DAQmx_Val_MIOAIConvertTbSrc_SameAsMasterTimebase = $0000282A;
  DAQmx_Val_MIOAIConvertTbSrc_20MHzTimebase = $000030F9;
  DAQmx_Val_MIOAIConvertTbSrc_80MHzTimebase = $0000392C;

// Constantes pour enum DAQmxOutputDataTransferCondition
type
  DAQmxOutputDataTransferCondition = LongWord;
const
  DAQmx_Val_OutputDataTransferCondition_OnBrdMemEmpty = $000027FB;
  DAQmx_Val_OutputDataTransferCondition_OnBrdMemHalfFullOrLess = $000027FF;
  DAQmx_Val_OutputDataTransferCondition_OnBrdMemNotFull = $00002802;

// Constantes pour enum DAQmxOutputTermCfg
type
  DAQmxOutputTermCfg = LongWord;
const
  DAQmx_Val_OutputTermCfg_RSE = $00002763;
  DAQmx_Val_OutputTermCfg_Diff = $0000277A;
  DAQmx_Val_OutputTermCfg_PseudoDiff = $000030F1;

// Constantes pour enum DAQmxOverwriteMode1
type
  DAQmxOverwriteMode1 = LongWord;
const
  DAQmx_Val_OverwriteMode1_OverwriteUnreadSamps = $0000280C;
  DAQmx_Val_OverwriteMode1_DoNotOverwriteUnreadSamps = $000027AF;

// Constantes pour enum DAQmxPolarity2
type
  DAQmxPolarity2 = LongWord;
const
  DAQmx_Val_Polarity2_ActiveHigh = $0000276F;
  DAQmx_Val_Polarity2_ActiveLow = $00002770;

// Constantes pour enum DAQmxProductCategory
type
  DAQmxProductCategory = LongWord;
const
  DAQmx_Val_ProductCategory_MSeriesDAQ = $00003933;
  DAQmx_Val_ProductCategory_ESeriesDAQ = $00003932;
  DAQmx_Val_ProductCategory_SSeriesDAQ = $00003934;
  DAQmx_Val_ProductCategory_BSeriesDAQ = $00003946;
  DAQmx_Val_ProductCategory_SCSeriesDAQ = $00003935;
  DAQmx_Val_ProductCategory_USBDAQ = $00003936;
  DAQmx_Val_ProductCategory_AOSeries = $00003937;
  DAQmx_Val_ProductCategory_DigitalIO = $00003938;
  DAQmx_Val_ProductCategory_TIOSeries = $00003945;
  DAQmx_Val_ProductCategory_DynamicSignalAcquisition = $00003939;
  DAQmx_Val_ProductCategory_Switches = $0000393A;
  DAQmx_Val_ProductCategory_CompactDAQChassis = $00003942;
  DAQmx_Val_ProductCategory_CSeriesModule = $00003943;
  DAQmx_Val_ProductCategory_SCXIModule = $00003944;
  DAQmx_Val_ProductCategory_Unknown = $0000312C;

// Constantes pour enum DAQmxRTDType1
type
  DAQmxRTDType1 = LongWord;
const
  DAQmx_Val_RTDType1_Pt3750 = $000030C1;
  DAQmx_Val_RTDType1_Pt3851 = $00002757;
  DAQmx_Val_RTDType1_Pt3911 = $000030C2;
  DAQmx_Val_RTDType1_Pt3916 = $00002755;
  DAQmx_Val_RTDType1_Pt3920 = $00002745;
  DAQmx_Val_RTDType1_Pt3928 = $000030C3;
  DAQmx_Val_RTDType1_Custom = $00002799;

// Constantes pour enum DAQmxRVDTSensitivityUnits1
type
  DAQmxRVDTSensitivityUnits1 = LongWord;
const
  DAQmx_Val_RVDTSensitivityUnits1_mVoltsPerVoltPerDegree = $000030DB;
  DAQmx_Val_RVDTSensitivityUnits1_mVoltsPerVoltPerRadian = $000030DC;

// Constantes pour enum DAQmxRawDataCompressionType
type
  DAQmxRawDataCompressionType = LongWord;
const
  DAQmx_Val_RawDataCompressionType_None = $000027F6;
  DAQmx_Val_RawDataCompressionType_LosslessPacking = $0000310B;
  DAQmx_Val_RawDataCompressionType_LossyLSBRemoval = $0000310C;

// Constantes pour enum DAQmxReadRelativeTo
type
  DAQmxReadRelativeTo = LongWord;
const
  DAQmx_Val_ReadRelativeTo_FirstSample = $000028B8;
  DAQmx_Val_ReadRelativeTo_CurrReadPos = $000028B9;
  DAQmx_Val_ReadRelativeTo_RefTrig = $000028BA;
  DAQmx_Val_ReadRelativeTo_FirstPretrigSamp = $000028BB;
  DAQmx_Val_ReadRelativeTo_MostRecentSamp = $000028BC;

// Constantes pour enum DAQmxRegenerationMode1
type
  DAQmxRegenerationMode1 = LongWord;
const
  DAQmx_Val_RegenerationMode1_AllowRegen = $00002771;
  DAQmx_Val_RegenerationMode1_DoNotAllowRegen = $000027AE;

// Constantes pour enum DAQmxResistanceConfiguration
type
  DAQmxResistanceConfiguration = LongWord;
const
  DAQmx_Val_ResistanceConfiguration_2Wire = $00000002;
  DAQmx_Val_ResistanceConfiguration_3Wire = $00000003;
  DAQmx_Val_ResistanceConfiguration_4Wire = $00000004;

// Constantes pour enum DAQmxResistanceUnits1
type
  DAQmxResistanceUnits1 = LongWord;
const
  DAQmx_Val_ResistanceUnits1_Ohms = $00002890;
  DAQmx_Val_ResistanceUnits1_FromCustomScale = $00002751;
  DAQmx_Val_ResistanceUnits1_FromTEDS = $000030E4;

// Constantes pour enum DAQmxResistanceUnits2
type
  DAQmxResistanceUnits2 = LongWord;
const
  DAQmx_Val_ResistanceUnits2_Ohms = $00002890;
  DAQmx_Val_ResistanceUnits2_FromCustomScale = $00002751;

// Constantes pour enum DAQmxResolutionType1
type
  DAQmxResolutionType1 = LongWord;
const
  DAQmx_Val_ResolutionType1_Bits = $0000277D;

// Constantes pour enum DAQmxSCXI1124Range
type
  DAQmxSCXI1124Range = LongWord;
const
  DAQmx_Val_SCXI1124Range_SCXI1124Range0to1V = $00003925;
  DAQmx_Val_SCXI1124Range_SCXI1124Range0to5V = $00003926;
  DAQmx_Val_SCXI1124Range_SCXI1124Range0to10V = $00003927;
  DAQmx_Val_SCXI1124Range_SCXI1124RangeNeg1to1V = $00003928;
  DAQmx_Val_SCXI1124Range_SCXI1124RangeNeg5to5V = $00003929;
  DAQmx_Val_SCXI1124Range_SCXI1124RangeNeg10to10V = $0000392A;
  DAQmx_Val_SCXI1124Range_SCXI1124Range0to20mA = $0000392B;

// Constantes pour enum DAQmxSampleClockActiveOrInactiveEdgeSelection
type
  DAQmxSampleClockActiveOrInactiveEdgeSelection = LongWord;
const
  DAQmx_Val_SampleClockActiveOrInactiveEdgeSelection_SampClkActiveEdge = $00003919;
  DAQmx_Val_SampleClockActiveOrInactiveEdgeSelection_SampClkInactiveEdge = $0000391A;

// Constantes pour enum DAQmxSampleInputDataWhen
type
  DAQmxSampleInputDataWhen = LongWord;
const
  DAQmx_Val_SampleInputDataWhen_HandshakeTriggerAsserts = $00003108;
  DAQmx_Val_SampleInputDataWhen_HandshakeTriggerDeasserts = $00003109;

// Constantes pour enum DAQmxSampleTimingType
type
  DAQmxSampleTimingType = LongWord;
const
  DAQmx_Val_SampleTimingType_SampClk = $00002894;
  DAQmx_Val_SampleTimingType_BurstHandshake = $00003104;
  DAQmx_Val_SampleTimingType_Handshake = $00002895;
  DAQmx_Val_SampleTimingType_Implicit = $000028D3;
  DAQmx_Val_SampleTimingType_OnDemand = $00002896;
  DAQmx_Val_SampleTimingType_ChangeDetection = $000030D8;
  DAQmx_Val_SampleTimingType_PipelinedSampClk = $0000394C;

// Constantes pour enum DAQmxScaleType
type
  DAQmxScaleType = LongWord;
const
  DAQmx_Val_ScaleType_Linear = $000028CF;
  DAQmx_Val_ScaleType_MapRanges = $000028D0;
  DAQmx_Val_ScaleType_Polynomial = $000028D1;
  DAQmx_Val_ScaleType_Table = $000028D2;

// Constantes pour enum DAQmxScaleType2
type
  DAQmxScaleType2 = LongWord;
const
  DAQmx_Val_ScaleType2_Polynomial = $000028D1;
  DAQmx_Val_ScaleType2_Table = $000028D2;

// Constantes pour enum DAQmxShuntCalSelect
type
  DAQmxShuntCalSelect = LongWord;
const
  DAQmx_Val_ShuntCalSelect_A = $000030E1;
  DAQmx_Val_ShuntCalSelect_B = $000030E2;
  DAQmx_Val_ShuntCalSelect_AandB = $000030E3;

// Constantes pour enum DAQmxSignal
type
  DAQmxSignal = LongWord;
const
  DAQmx_Val_Signal_AIConvertClock = $000030C4;
  DAQmx_Val_Signal_10MHzRefClock = $000030F8;
  DAQmx_Val_Signal_20MHzTimebaseClock = $000030C6;
  DAQmx_Val_Signal_SampleClock = $000030C7;
  DAQmx_Val_Signal_AdvanceTrigger = $000030C8;
  DAQmx_Val_Signal_ReferenceTrigger = $000030CA;
  DAQmx_Val_Signal_StartTrigger = $000030CB;
  DAQmx_Val_Signal_AdvCmpltEvent = $000030CC;
  DAQmx_Val_Signal_AIHoldCmpltEvent = $000030CD;
  DAQmx_Val_Signal_CounterOutputEvent = $000030CE;
  DAQmx_Val_Signal_ChangeDetectionEvent = $000030DF;
  DAQmx_Val_Signal_WDTExpiredEvent = $000030E0;

// Constantes pour enum DAQmxSignal2
type
  DAQmxSignal2 = LongWord;
const
  DAQmx_Val_Signal2_SampleCompleteEvent = $000030F2;
  DAQmx_Val_Signal2_CounterOutputEvent = $000030CE;
  DAQmx_Val_Signal2_ChangeDetectionEvent = $000030DF;
  DAQmx_Val_Signal2_SampleClock = $000030C7;

// Constantes pour enum DAQmxSlope1
type
  DAQmxSlope1 = LongWord;
const
  DAQmx_Val_Slope1_RisingSlope = $00002828;
  DAQmx_Val_Slope1_FallingSlope = $000027BB;

// Constantes pour enum DAQmxSoundPressureUnits1
type
  DAQmxSoundPressureUnits1 = LongWord;
const
  DAQmx_Val_SoundPressureUnits1_Pascals = $00002761;
  DAQmx_Val_SoundPressureUnits1_FromCustomScale = $00002751;

// Constantes pour enum DAQmxSourceSelection
type
  DAQmxSourceSelection = LongWord;
const
  DAQmx_Val_SourceSelection_Internal = $000027D8;
  DAQmx_Val_SourceSelection_External = $000027B7;

// Constantes pour enum DAQmxStrainGageBridgeType1
type
  DAQmxStrainGageBridgeType1 = LongWord;
const
  DAQmx_Val_StrainGageBridgeType1_FullBridgeI = $000027C7;
  DAQmx_Val_StrainGageBridgeType1_FullBridgeII = $000027C8;
  DAQmx_Val_StrainGageBridgeType1_FullBridgeIII = $000027C9;
  DAQmx_Val_StrainGageBridgeType1_HalfBridgeI = $000027CC;
  DAQmx_Val_StrainGageBridgeType1_HalfBridgeII = $000027CD;
  DAQmx_Val_StrainGageBridgeType1_QuarterBridgeI = $0000281F;
  DAQmx_Val_StrainGageBridgeType1_QuarterBridgeII = $00002820;

// Constantes pour enum DAQmxStrainUnits1
type
  DAQmxStrainUnits1 = LongWord;
const
  DAQmx_Val_StrainUnits1_Strain = $0000283B;
  DAQmx_Val_StrainUnits1_FromCustomScale = $00002751;

// Constantes pour enum DAQmxSwitchScanRepeatMode
type
  DAQmxSwitchScanRepeatMode = LongWord;
const
  DAQmx_Val_SwitchScanRepeatMode_Finite = $000027BC;
  DAQmx_Val_SwitchScanRepeatMode_Cont = $00002785;

// Constantes pour enum DAQmxSwitchUsageTypes
type
  DAQmxSwitchUsageTypes = LongWord;
const
  DAQmx_Val_SwitchUsageTypes_Source = $000028C7;
  DAQmx_Val_SwitchUsageTypes_Load = $000028C8;
  DAQmx_Val_SwitchUsageTypes_ReservedForRouting = $000028C9;

// Constantes pour enum DAQmxTEDSUnits
type
  DAQmxTEDSUnits = LongWord;
const
  DAQmx_Val_TEDSUnits_FromCustomScale = $00002751;
  DAQmx_Val_TEDSUnits_FromTEDS = $000030E4;

// Constantes pour enum DAQmxTemperatureUnits1
type
  DAQmxTemperatureUnits1 = LongWord;
const
  DAQmx_Val_TemperatureUnits1_DegC = $0000279F;
  DAQmx_Val_TemperatureUnits1_DegF = $000027A0;
  DAQmx_Val_TemperatureUnits1_Kelvins = $00002855;
  DAQmx_Val_TemperatureUnits1_DegR = $000027A1;
  DAQmx_Val_TemperatureUnits1_FromCustomScale = $00002751;

// Constantes pour enum DAQmxThermocoupleType1
type
  DAQmxThermocoupleType1 = LongWord;
const
  DAQmx_Val_ThermocoupleType1_J_Type_TC = $00002758;
  DAQmx_Val_ThermocoupleType1_K_Type_TC = $00002759;
  DAQmx_Val_ThermocoupleType1_N_Type_TC = $0000275D;
  DAQmx_Val_ThermocoupleType1_R_Type_TC = $00002762;
  DAQmx_Val_ThermocoupleType1_S_Type_TC = $00002765;
  DAQmx_Val_ThermocoupleType1_T_Type_TC = $00002766;
  DAQmx_Val_ThermocoupleType1_B_Type_TC = $0000273F;
  DAQmx_Val_ThermocoupleType1_E_Type_TC = $00002747;

// Constantes pour enum DAQmxTimeUnits
type
  DAQmxTimeUnits = LongWord;
const
  DAQmx_Val_TimeUnits_Seconds = $0000287C;
  DAQmx_Val_TimeUnits_FromCustomScale = $00002751;

// Constantes pour enum DAQmxTimeUnits2
type
  DAQmxTimeUnits2 = LongWord;
const
  DAQmx_Val_TimeUnits2_Seconds = $0000287C;

// Constantes pour enum DAQmxTimeUnits3
type
  DAQmxTimeUnits3 = LongWord;
const
  DAQmx_Val_TimeUnits3_Seconds = $0000287C;
  DAQmx_Val_TimeUnits3_Ticks = $00002840;
  DAQmx_Val_TimeUnits3_FromCustomScale = $00002751;

// Constantes pour enum DAQmxTimingResponseMode
type
  DAQmxTimingResponseMode = LongWord;
const
  DAQmx_Val_TimingResponseMode_SingleCycle = $00003915;
  DAQmx_Val_TimingResponseMode_Multicycle = $00003916;

// Constantes pour enum DAQmxTriggerType4
type
  DAQmxTriggerType4 = LongWord;
const
  DAQmx_Val_TriggerType4_DigEdge = $000027A6;
  DAQmx_Val_TriggerType4_None = $000027F6;

// Constantes pour enum DAQmxTriggerType5
type
  DAQmxTriggerType5 = LongWord;
const
  DAQmx_Val_TriggerType5_DigEdge = $000027A6;
  DAQmx_Val_TriggerType5_Software = $00002834;
  DAQmx_Val_TriggerType5_None = $000027F6;

// Constantes pour enum DAQmxTriggerType6
type
  DAQmxTriggerType6 = LongWord;
const
  DAQmx_Val_TriggerType6_AnlgLvl = $00002775;
  DAQmx_Val_TriggerType6_AnlgWin = $00002777;
  DAQmx_Val_TriggerType6_DigLvl = $000027A8;
  DAQmx_Val_TriggerType6_DigPattern = $0000289E;
  DAQmx_Val_TriggerType6_None = $000027F6;

// Constantes pour enum DAQmxTriggerType8
type
  DAQmxTriggerType8 = LongWord;
const
  DAQmx_Val_TriggerType8_AnlgEdge = $00002773;
  DAQmx_Val_TriggerType8_DigEdge = $000027A6;
  DAQmx_Val_TriggerType8_DigPattern = $0000289E;
  DAQmx_Val_TriggerType8_AnlgWin = $00002777;
  DAQmx_Val_TriggerType8_None = $000027F6;

// Constantes pour enum DAQmxTriggerType9
type
  DAQmxTriggerType9 = LongWord;
const
  DAQmx_Val_TriggerType9_Interlocked = $00003105;
  DAQmx_Val_TriggerType9_None = $000027F6;

// Constantes pour enum DAQmxUnderflowBehavior
type
  DAQmxUnderflowBehavior = LongWord;
const
  DAQmx_Val_UnderflowBehavior_HaltOutputAndError = $00003917;
  DAQmx_Val_UnderflowBehavior_PauseUntilDataAvailable = $00003918;

// Constantes pour enum DAQmxUnitsPreScaled
type
  DAQmxUnitsPreScaled = LongWord;
const
  DAQmx_Val_UnitsPreScaled_Volts = $0000286C;
  DAQmx_Val_UnitsPreScaled_Amps = $00002866;
  DAQmx_Val_UnitsPreScaled_DegF = $000027A0;
  DAQmx_Val_UnitsPreScaled_DegC = $0000279F;
  DAQmx_Val_UnitsPreScaled_DegR = $000027A1;
  DAQmx_Val_UnitsPreScaled_Kelvins = $00002855;
  DAQmx_Val_UnitsPreScaled_Strain = $0000283B;
  DAQmx_Val_UnitsPreScaled_Ohms = $00002890;
  DAQmx_Val_UnitsPreScaled_Hz = $00002885;
  DAQmx_Val_UnitsPreScaled_Seconds = $0000287C;
  DAQmx_Val_UnitsPreScaled_Meters = $000027EB;
  DAQmx_Val_UnitsPreScaled_Inches = $0000288B;
  DAQmx_Val_UnitsPreScaled_Degrees = $000027A2;
  DAQmx_Val_UnitsPreScaled_Radians = $00002821;
  DAQmx_Val_UnitsPreScaled_g = $000027CA;
  DAQmx_Val_UnitsPreScaled_MetersPerSecondSquared = $000030B6;
  DAQmx_Val_UnitsPreScaled_Pascals = $00002761;
  DAQmx_Val_UnitsPreScaled_FromTEDS = $000030E4;

// Constantes pour enum DAQmxVoltageUnits1
type
  DAQmxVoltageUnits1 = LongWord;
const
  DAQmx_Val_VoltageUnits1_Volts = $0000286C;
  DAQmx_Val_VoltageUnits1_FromCustomScale = $00002751;
  DAQmx_Val_VoltageUnits1_FromTEDS = $000030E4;

// Constantes pour enum DAQmxVoltageUnits2
type
  DAQmxVoltageUnits2 = LongWord;
const
  DAQmx_Val_VoltageUnits2_Volts = $0000286C;
  DAQmx_Val_VoltageUnits2_FromCustomScale = $00002751;

// Constantes pour enum DAQmxWaitMode
type
  DAQmxWaitMode = LongWord;
const
  DAQmx_Val_WaitMode_WaitForInterrupt = $000030EB;
  DAQmx_Val_WaitMode_Poll = $000030EC;
  DAQmx_Val_WaitMode_Yield = $000030ED;
  DAQmx_Val_WaitMode_Sleep = $00003103;

// Constantes pour enum DAQmxWaitMode2
type
  DAQmxWaitMode2 = LongWord;
const
  DAQmx_Val_WaitMode2_Poll = $000030EC;
  DAQmx_Val_WaitMode2_Yield = $000030ED;
  DAQmx_Val_WaitMode2_Sleep = $00003103;

// Constantes pour enum DAQmxWaitMode3
type
  DAQmxWaitMode3 = LongWord;
const
  DAQmx_Val_WaitMode3_WaitForInterrupt = $000030EB;
  DAQmx_Val_WaitMode3_Poll = $000030EC;

// Constantes pour enum DAQmxWaitMode4
type
  DAQmxWaitMode4 = LongWord;
const
  DAQmx_Val_WaitMode4_WaitForInterrupt = $000030EB;
  DAQmx_Val_WaitMode4_Poll = $000030EC;

// Constantes pour enum DAQmxWindowTriggerCondition1
type
  DAQmxWindowTriggerCondition1 = LongWord;
const
  DAQmx_Val_WindowTriggerCondition1_EnteringWin = $000027B3;
  DAQmx_Val_WindowTriggerCondition1_LeavingWin = $000027E0;

// Constantes pour enum DAQmxWindowTriggerCondition2
type
  DAQmxWindowTriggerCondition2 = LongWord;
const
  DAQmx_Val_WindowTriggerCondition2_InsideWin = $000027D7;
  DAQmx_Val_WindowTriggerCondition2_OutsideWin = $0000280B;

// Constantes pour enum DAQmxWriteBasicTEDSOptions
type
  DAQmxWriteBasicTEDSOptions = LongWord;
const
  DAQmx_Val_WriteBasicTEDSOptions_WriteToEEPROM = $000030FA;
  DAQmx_Val_WriteBasicTEDSOptions_WriteToPROM = $000030FB;
  DAQmx_Val_WriteBasicTEDSOptions_DoNotWrite = $000030FC;

// Constantes pour enum DAQmxWriteRelativeTo
type
  DAQmxWriteRelativeTo = LongWord;
const
  DAQmx_Val_WriteRelativeTo_FirstSample = $000028B8;
  DAQmx_Val_WriteRelativeTo_CurrWritePos = $000028BE;

// Constantes pour enum __MIDL___MIDL_itf_NIDAQmx_0000_0001
type
  __MIDL___MIDL_itf_NIDAQmx_0000_0001 = LongWord;
const
  DAQmxSuccess = $00000000;
  ErrorCOCannotKeepUpInHWTimedSinglePoint = $FFFCCC73;
  ErrorWaitForNextSampClkDetected3OrMoreSampClks = $FFFCCC75;
  ErrorWaitForNextSampClkDetectedMissedSampClk = $FFFCCC76;
  ErrorWriteNotCompleteBeforeSampClk = $FFFCCC77;
  ErrorReadNotCompleteBeforeSampClk = $FFFCCC78;
  ErrorSCXI1600ImportNotSupported = $FFFCEE2A;
  ErrorPowerSupplyConfigurationFailed = $FFFCEE2B;
  ErrorIEPEWithDCNotAllowed = $FFFCEE2C;
  ErrorMinTempForThermocoupleTypeOutsideAccuracyForPolyScaling = $FFFCEE2D;
  ErrorDevImportFailedNoDeviceToOverwriteAndSimulationNotSupported = $FFFCEE2E;
  ErrorDevImportFailedDeviceNotSupportedOnDestination = $FFFCEE2F;
  ErrorFirmwareIsTooOld = $FFFCEE30;
  ErrorFirmwareCouldntUpdate = $FFFCEE31;
  ErrorFirmwareIsCorrupt = $FFFCEE32;
  ErrorFirmwareTooNew = $FFFCEE33;
  ErrorSampClockCannotBeExportedFromExternalSampClockSrc = $FFFCEE34;
  ErrorPhysChanReservedForInputWhenDesiredForOutput = $FFFCEE35;
  ErrorPhysChanReservedForOutputWhenDesiredForInput = $FFFCEE36;
  ErrorSpecifiedCDAQSlotNotEmpty = $FFFCEE37;
  ErrorDeviceDoesNotSupportSimulation = $FFFCEE38;
  ErrorInvalidCDAQSlotNumberSpecd = $FFFCEE39;
  ErrorCSeriesModSimMustMatchCDAQChassisSim = $FFFCEE3A;
  ErrorSCCCabledDevMustNotBeSimWhenSCCCarrierIsNotSim = $FFFCEE3B;
  ErrorSCCModSimMustMatchSCCCarrierSim = $FFFCEE3C;
  ErrorSCXIModuleDoesNotSupportSimulation = $FFFCEE3D;
  ErrorSCXICableDevMustNotBeSimWhenModIsNotSim = $FFFCEE3E;
  ErrorSCXIDigitizerSimMustNotBeSimWhenModIsNotSim = $FFFCEE3F;
  ErrorSCXIModSimMustMatchSCXIChassisSim = $FFFCEE40;
  ErrorSimPXIDevReqSlotAndChassisSpecd = $FFFCEE41;
  ErrorSimDevConflictWithRealDev = $FFFCEE42;
  ErrorInsufficientDataForCalibration = $FFFCEE43;
  ErrorTriggerChannelMustBeEnabled = $FFFCEE44;
  ErrorCalibrationDataConflictCouldNotBeResolved = $FFFCEE45;
  ErrorSoftwareTooNewForSelfCalibrationData = $FFFCEE46;
  ErrorSoftwareTooNewForExtCalibrationData = $FFFCEE47;
  ErrorSelfCalibrationDataTooNewForSoftware = $FFFCEE48;
  ErrorExtCalibrationDataTooNewForSoftware = $FFFCEE49;
  ErrorSoftwareTooNewForEEPROM = $FFFCEE4A;
  ErrorEEPROMTooNewForSoftware = $FFFCEE4B;
  ErrorSoftwareTooNewForHardware = $FFFCEE4C;
  ErrorHardwareTooNewForSoftware = $FFFCEE4D;
  ErrorTaskCannotRestartFirstSampNotAvailToGenerate = $FFFCEE4E;
  ErrorOnlyUseStartTrigSrcPrptyWithDevDataLines = $FFFCEE4F;
  ErrorOnlyUsePauseTrigSrcPrptyWithDevDataLines = $FFFCEE50;
  ErrorOnlyUseRefTrigSrcPrptyWithDevDataLines = $FFFCEE51;
  ErrorPauseTrigDigPatternSizeDoesNotMatchSrcSize = $FFFCEE52;
  ErrorLineConflictCDAQ = $FFFCEE53;
  ErrorCannotWriteBeyondFinalFiniteSample = $FFFCEE54;
  ErrorRefAndStartTriggerSrcCantBeSame = $FFFCEE55;
  ErrorMemMappingIncompatibleWithPhysChansInTask = $FFFCEE56;
  ErrorOutputDriveTypeMemMappingConflict = $FFFCEE57;
  ErrorCAPIDeviceIndexInvalid = $FFFCEE58;
  ErrorRatiometricDevicesMustUseExcitationForScaling = $FFFCEE59;
  ErrorPropertyRequiresPerDeviceCfg = $FFFCEE5A;
  ErrorAICouplingAndAIInputSourceConflict = $FFFCEE5B;
  ErrorOnlyOneTaskCanPerformDOMemoryMappingAtATime = $FFFCEE5C;
  ErrorTooManyChansForAnalogRefTrigCDAQ = $FFFCEE5D;
  ErrorSpecdPropertyValueIsIncompatibleWithSampleTimingType = $FFFCEE5E;
  ErrorCPUNotSupportedRequireSSE = $FFFCEE5F;
  ErrorSpecdPropertyValueIsIncompatibleWithSampleTimingResponseMode = $FFFCEE60;
  ErrorConflictingNextWriteIsLastAndRegenModeProperties = $FFFCEE61;
  ErrorMStudioOperationDoesNotSupportDeviceContext = $FFFCEE62;
  ErrorPropertyValueInChannelExpansionContextInvalid = $FFFCEE63;
  ErrorHWTimedNonBufferedAONotSupported = $FFFCEE64;
  ErrorWaveformLengthNotMultOfQuantum = $FFFCEE65;
  ErrorDSAExpansionMixedBoardsWrongOrderInPXIChassis = $FFFCEE66;
  ErrorPowerLevelTooLowForOOK = $FFFCEE67;
  ErrorDeviceComponentTestFailure = $FFFCEE68;
  ErrorUserDefinedWfmWithOOKUnsupported = $FFFCEE69;
  ErrorInvalidDigitalModulationUserDefinedWaveform = $FFFCEE6A;
  ErrorBothRefInAndRefOutEnabled = $FFFCEE6B;
  ErrorBothAnalogAndDigitalModulationEnabled = $FFFCEE6C;
  ErrorBufferedOpsNotSupportedInSpecdSlotForCDAQ = $FFFCEE6D;
  ErrorPhysChanNotSupportedInSpecdSlotForCDAQ = $FFFCEE6E;
  ErrorResourceReservedWithConflictingSettings = $FFFCEE6F;
  ErrorInconsistentAnalogTrigSettingsCDAQ = $FFFCEE70;
  ErrorTooManyChansForAnalogPauseTrigCDAQ = $FFFCEE71;
  ErrorAnalogTrigNotFirstInScanListCDAQ = $FFFCEE72;
  ErrorTooManyChansGivenTimingType = $FFFCEE73;
  ErrorSampClkTimebaseDivWithExtSampClk = $FFFCEE74;
  ErrorCantSaveTaskWithPerDeviceTimingProperties = $FFFCEE75;
  ErrorConflictingAutoZeroMode = $FFFCEE76;
  ErrorSampClkRateNotSupportedWithEAREnabled = $FFFCEE77;
  ErrorSampClkTimebaseRateNotSpecd = $FFFCEE78;
  ErrorSessionCorruptedByDLLReload = $FFFCEE79;
  ErrorActiveDevNotSupportedWithChanExpansion = $FFFCEE7A;
  ErrorSampClkRateInvalid = $FFFCEE7B;
  ErrorExtSyncPulseSrcCannotBeExported = $FFFCEE7C;
  ErrorSyncPulseMinDelayToStartNeededForExtSyncPulseSrc = $FFFCEE7D;
  ErrorSyncPulseSrcInvalid = $FFFCEE7E;
  ErrorSampClkTimebaseRateInvalid = $FFFCEE7F;
  ErrorSampClkTimebaseSrcInvalid = $FFFCEE80;
  ErrorSampClkRateMustBeSpecd = $FFFCEE81;
  ErrorInvalidAttributeName = $FFFCEE82;
  ErrorCJCChanNameMustBeSetWhenCJCSrcIsScannableChan = $FFFCEE83;
  ErrorHiddenChanMissingInChansPropertyInCfgFile = $FFFCEE84;
  ErrorChanNamesNotSpecdInCfgFile = $FFFCEE85;
  ErrorDuplicateHiddenChanNamesInCfgFile = $FFFCEE86;
  ErrorDuplicateChanNameInCfgFile = $FFFCEE87;
  ErrorInvalidSCCModuleForSlotSpecd = $FFFCEE88;
  ErrorInvalidSCCSlotNumberSpecd = $FFFCEE89;
  ErrorInvalidSectionIdentifier = $FFFCEE8A;
  ErrorInvalidSectionName = $FFFCEE8B;
  ErrorDAQmxVersionNotSupported = $FFFCEE8C;
  ErrorSWObjectsFoundInFile = $FFFCEE8D;
  ErrorHWObjectsFoundInFile = $FFFCEE8E;
  ErrorLocalChannelSpecdWithNoParentTask = $FFFCEE8F;
  ErrorTaskReferencesMissingLocalChannel = $FFFCEE90;
  ErrorTaskReferencesLocalChannelFromOtherTask = $FFFCEE91;
  ErrorTaskMissingChannelProperty = $FFFCEE92;
  ErrorInvalidLocalChanName = $FFFCEE93;
  ErrorInvalidEscapeCharacterInString = $FFFCEE94;
  ErrorInvalidTableIdentifier = $FFFCEE95;
  ErrorValueFoundInInvalidColumn = $FFFCEE96;
  ErrorMissingStartOfTable = $FFFCEE97;
  ErrorFileMissingRequiredDAQmxHeader = $FFFCEE98;
  ErrorDeviceIDDoesNotMatch = $FFFCEE99;
  ErrorBufferedOperationsNotSupportedOnSelectedLines = $FFFCEE9A;
  ErrorPropertyConflictsWithScale = $FFFCEE9B;
  ErrorInvalidINIFileSyntax = $FFFCEE9C;
  ErrorDeviceInfoFailedPXIChassisNotIdentified = $FFFCEE9D;
  ErrorInvalidHWProductNumber = $FFFCEE9E;
  ErrorInvalidHWProductType = $FFFCEE9F;
  ErrorInvalidNumericFormatSpecd = $FFFCEEA0;
  ErrorDuplicatePropertyInObject = $FFFCEEA1;
  ErrorInvalidEnumValueSpecd = $FFFCEEA2;
  ErrorTEDSSensorPhysicalChannelConflict = $FFFCEEA3;
  ErrorTooManyPhysicalChansForTEDSInterfaceSpecd = $FFFCEEA4;
  ErrorIncapableTEDSInterfaceControllingDeviceSpecd = $FFFCEEA5;
  ErrorSCCCarrierSpecdIsMissing = $FFFCEEA6;
  ErrorIncapableSCCDigitizingDeviceSpecd = $FFFCEEA7;
  ErrorAccessorySettingNotApplicable = $FFFCEEA8;
  ErrorDeviceAndConnectorSpecdAlreadyOccupied = $FFFCEEA9;
  ErrorIllegalAccessoryTypeForDeviceSpecd = $FFFCEEAA;
  ErrorInvalidDeviceConnectorNumberSpecd = $FFFCEEAB;
  ErrorInvalidAccessoryName = $FFFCEEAC;
  ErrorMoreThanOneMatchForSpecdDevice = $FFFCEEAD;
  ErrorNoMatchForSpecdDevice = $FFFCEEAE;
  ErrorProductTypeAndProductNumberConflict = $FFFCEEAF;
  ErrorExtraPropertyDetectedInSpecdObject = $FFFCEEB0;
  ErrorRequiredPropertyMissing = $FFFCEEB1;
  ErrorCantSetAuthorForLocalChan = $FFFCEEB2;
  ErrorInvalidTimeValue = $FFFCEEB3;
  ErrorInvalidTimeFormat = $FFFCEEB4;
  ErrorDigDevChansSpecdInModeOtherThanParallel = $FFFCEEB5;
  ErrorCascadeDigitizationModeNotSupported = $FFFCEEB6;
  ErrorSpecdSlotAlreadyOccupied = $FFFCEEB7;
  ErrorInvalidSCXISlotNumberSpecd = $FFFCEEB8;
  ErrorAddressAlreadyInUse = $FFFCEEB9;
  ErrorSpecdDeviceDoesNotSupportRTSI = $FFFCEEBA;
  ErrorSpecdDeviceIsAlreadyOnRTSIBus = $FFFCEEBB;
  ErrorIdentifierInUse = $FFFCEEBC;
  ErrorWaitForNextSampleClockOrReadDetected3OrMoreMissedSampClks = $FFFCEEBD;
  ErrorHWTimedAndDataXferPIO = $FFFCEEBE;
  ErrorNonBufferedAndHWTimed = $FFFCEEBF;
  ErrorCTROutSampClkPeriodShorterThanGenPulseTrainPeriodPolled = $FFFCEEC0;
  ErrorCTROutSampClkPeriodShorterThanGenPulseTrainPeriod2 = $FFFCEEC1;
  ErrorCOCannotKeepUpInHWTimedSinglePointPolled = $FFFCEEC2;
  ErrorWriteRecoveryCannotKeepUpInHWTimedSinglePoint = $FFFCEEC3;
  ErrorNoChangeDetectionOnSelectedLineForDevice = $FFFCEEC4;
  ErrorSMIOPauseTriggersNotSupportedWithChannelExpansion = $FFFCEEC5;
  ErrorClockMasterForExternalClockNotLongestPipeline = $FFFCEEC6;
  ErrorUnsupportedUnicodeByteOrderMarker = $FFFCEEC7;
  ErrorTooManyInstructionsInLoopInScript = $FFFCEEC8;
  ErrorPLLNotLocked = $FFFCEEC9;
  ErrorIfElseBlockNotAllowedInFiniteRepeatLoopInScript = $FFFCEECA;
  ErrorIfElseBlockNotAllowedInConditionalRepeatLoopInScript = $FFFCEECB;
  ErrorClearIsLastInstructionInIfElseBlockInScript = $FFFCEECC;
  ErrorInvalidWaitDurationBeforeIfElseBlockInScript = $FFFCEECD;
  ErrorMarkerPosInvalidBeforeIfElseBlockInScript = $FFFCEECE;
  ErrorInvalidSubsetLengthBeforeIfElseBlockInScript = $FFFCEECF;
  ErrorInvalidWaveformLengthBeforeIfElseBlockInScript = $FFFCEED0;
  ErrorGenerateOrFiniteWaitInstructionExpectedBeforeIfElseBlockInScript = $FFFCEED1;
  ErrorCalPasswordNotSupported = $FFFCEED2;
  ErrorSetupCalNeededBeforeAdjustCal = $FFFCEED3;
  ErrorMultipleChansNotSupportedDuringCalSetup = $FFFCEED4;
  ErrorDevCannotBeAccessed = $FFFCEED5;
  ErrorSampClkRateDoesntMatchSampClkSrc = $FFFCEED6;
  ErrorSampClkRateNotSupportedWithEARDisabled = $FFFCEED7;
  ErrorLabVIEWVersionDoesntSupportDAQmxEvents = $FFFCEED8;
  ErrorCOReadyForNewValNotSupportedWithOnDemand = $FFFCEED9;
  ErrorCIHWTimedSinglePointNotSupportedForMeasType = $FFFCEEDA;
  ErrorOnDemandNotSupportedWithHWTimedSinglePoint = $FFFCEEDB;
  ErrorHWTimedSinglePointAndDataXferNotProgIO = $FFFCEEDC;
  ErrorMemMapAndHWTimedSinglePoint = $FFFCEEDD;
  ErrorCannotSetPropertyWhenHWTimedSinglePointTaskIsRunning = $FFFCEEDE;
  ErrorCTROutSampClkPeriodShorterThanGenPulseTrainPeriod = $FFFCEEDF;
  ErrorTooManyEventsGenerated = $FFFCEEE0;
  ErrorMStudioCppRemoveEventsBeforeStop = $FFFCEEE1;
  ErrorCAPICannotRegisterSyncEventsFromMultipleThreads = $FFFCEEE2;
  ErrorReadWaitNextSampClkWaitMismatchTwo = $FFFCEEE3;
  ErrorReadWaitNextSampClkWaitMismatchOne = $FFFCEEE4;
  ErrorDAQmxSignalEventTypeNotSupportedByChanTypesOrDevicesInTask = $FFFCEEE5;
  ErrorCannotUnregisterDAQmxSoftwareEventWhileTaskIsRunning = $FFFCEEE6;
  ErrorAutoStartWriteNotAllowedEventRegistered = $FFFCEEE7;
  ErrorAutoStartReadNotAllowedEventRegistered = $FFFCEEE8;
  ErrorCannotGetPropertyWhenTaskNotReservedCommittedOrRunning = $FFFCEEE9;
  ErrorSignalEventsNotSupportedByDevice = $FFFCEEEA;
  ErrorEveryNSamplesAcqIntoBufferEventNotSupportedByDevice = $FFFCEEEB;
  ErrorEveryNSampsTransferredFromBufferEventNotSupportedByDevice = $FFFCEEEC;
  ErrorCAPISyncEventsTaskStateChangeNotAllowedFromDifferentThread = $FFFCEEED;
  ErrorDAQmxSWEventsWithDifferentCallMechanisms = $FFFCEEEE;
  ErrorCantSaveChanWithPolyCalScaleAndAllowInteractiveEdit = $FFFCEEEF;
  ErrorChanDoesNotSupportCJC = $FFFCEEF0;
  ErrorCOReadyForNewValNotSupportedWithHWTimedSinglePoint = $FFFCEEF1;
  ErrorDACAllowConnToGndNotSupportedByDevWhenRefSrcExt = $FFFCEEF2;
  ErrorCantGetPropertyTaskNotRunning = $FFFCEEF3;
  ErrorCantSetPropertyTaskNotRunning = $FFFCEEF4;
  ErrorCantSetPropertyTaskNotRunningCommitted = $FFFCEEF5;
  ErrorAIEveryNSampsEventIntervalNotMultipleOf2 = $FFFCEEF6;
  ErrorInvalidTEDSPhysChanNotAI = $FFFCEEF7;
  ErrorCAPICannotPerformTaskOperationInAsyncCallback = $FFFCEEF8;
  ErrorEveryNSampsTransferredFromBufferEventAlreadyRegistered = $FFFCEEF9;
  ErrorEveryNSampsAcqIntoBufferEventAlreadyRegistered = $FFFCEEFA;
  ErrorEveryNSampsTransferredFromBufferNotForInput = $FFFCEEFB;
  ErrorEveryNSampsAcqIntoBufferNotForOutput = $FFFCEEFC;
  ErrorAOSampTimingTypeDifferentIn2Tasks = $FFFCEEFD;
  ErrorCouldNotDownloadFirmwareHWDamaged = $FFFCEEFE;
  ErrorCouldNotDownloadFirmwareFileMissingOrDamaged = $FFFCEEFF;
  ErrorCannotRegisterDAQmxSoftwareEventWhileTaskIsRunning = $FFFCEF00;
  ErrorDifferentRawDataCompression = $FFFCEF01;
  ErrorConfiguredTEDSInterfaceDevNotDetected = $FFFCEF02;
  ErrorCompressedSampSizeExceedsResolution = $FFFCEF03;
  ErrorChanDoesNotSupportCompression = $FFFCEF04;
  ErrorDifferentRawDataFormats = $FFFCEF05;
  ErrorSampClkOutputTermIncludesStartTrigSrc = $FFFCEF06;
  ErrorStartTrigSrcEqualToSampClkSrc = $FFFCEF07;
  ErrorEventOutputTermIncludesTrigSrc = $FFFCEF08;
  ErrorCOMultipleWritesBetweenSampClks = $FFFCEF09;
  ErrorDoneEventAlreadyRegistered = $FFFCEF0A;
  ErrorSignalEventAlreadyRegistered = $FFFCEF0B;
  ErrorCannotHaveTimedLoopAndDAQmxSignalEventsInSameTask = $FFFCEF0C;
  ErrorNeedLabVIEW711PatchToUseDAQmxEvents = $FFFCEF0D;
  ErrorStartFailedDueToWriteFailure = $FFFCEF0E;
  ErrorDataXferCustomThresholdNotDMAXferMethodSpecifiedForDev = $FFFCEF0F;
  ErrorDataXferRequestConditionNotSpecifiedForCustomThreshold = $FFFCEF10;
  ErrorDataXferCustomThresholdNotSpecified = $FFFCEF11;
  ErrorCAPISyncCallbackNotSupportedOnThisPlatform = $FFFCEF12;
  ErrorCalChanReversePolyCoefNotSpecd = $FFFCEF13;
  ErrorCalChanForwardPolyCoefNotSpecd = $FFFCEF14;
  ErrorChanCalRepeatedNumberInPreScaledVals = $FFFCEF15;
  ErrorChanCalTableNumScaledNotEqualNumPrescaledVals = $FFFCEF16;
  ErrorChanCalTableScaledValsNotSpecd = $FFFCEF17;
  ErrorChanCalTablePreScaledValsNotSpecd = $FFFCEF18;
  ErrorChanCalScaleTypeNotSet = $FFFCEF19;
  ErrorChanCalExpired = $FFFCEF1A;
  ErrorChanCalExpirationDateNotSet = $FFFCEF1B;
  Error3OutputPortCombinationGivenSampTimingType653x = $FFFCEF1C;
  Error3InputPortCombinationGivenSampTimingType653x = $FFFCEF1D;
  Error2OutputPortCombinationGivenSampTimingType653x = $FFFCEF1E;
  Error2InputPortCombinationGivenSampTimingType653x = $FFFCEF1F;
  ErrorPatternMatcherMayBeUsedByOneTrigOnly = $FFFCEF20;
  ErrorNoChansSpecdForPatternSource = $FFFCEF21;
  ErrorChangeDetectionChanNotInTask = $FFFCEF22;
  ErrorChangeDetectionChanNotTristated = $FFFCEF23;
  ErrorWaitModeValueNotSupportedNonBuffered = $FFFCEF24;
  ErrorWaitModePropertyNotSupportedNonBuffered = $FFFCEF25;
  ErrorCantSavePerLineConfigDigChanSoInteractiveEditsAllowed = $FFFCEF26;
  ErrorCantSaveNonPortMultiLineDigChanSoInteractiveEditsAllowed = $FFFCEF27;
  ErrorBufferSizeNotMultipleOfEveryNSampsEventIntervalNoIrqOnDev = $FFFCEF28;
  ErrorGlobalTaskNameAlreadyChanName = $FFFCEF29;
  ErrorGlobalChanNameAlreadyTaskName = $FFFCEF2A;
  ErrorAOEveryNSampsEventIntervalNotMultipleOf2 = $FFFCEF2B;
  ErrorSampleTimebaseDivisorNotSupportedGivenTimingType = $FFFCEF2C;
  ErrorHandshakeEventOutputTermNotSupportedGivenTimingType = $FFFCEF2D;
  ErrorChangeDetectionOutputTermNotSupportedGivenTimingType = $FFFCEF2E;
  ErrorReadyForTransferOutputTermNotSupportedGivenTimingType = $FFFCEF2F;
  ErrorRefTrigOutputTermNotSupportedGivenTimingType = $FFFCEF30;
  ErrorStartTrigOutputTermNotSupportedGivenTimingType = $FFFCEF31;
  ErrorSampClockOutputTermNotSupportedGivenTimingType = $FFFCEF32;
  Error20MhzTimebaseNotSupportedGivenTimingType = $FFFCEF33;
  ErrorSampClockSourceNotSupportedGivenTimingType = $FFFCEF34;
  ErrorRefTrigTypeNotSupportedGivenTimingType = $FFFCEF35;
  ErrorPauseTrigTypeNotSupportedGivenTimingType = $FFFCEF36;
  ErrorHandshakeTrigTypeNotSupportedGivenTimingType = $FFFCEF37;
  ErrorStartTrigTypeNotSupportedGivenTimingType = $FFFCEF38;
  ErrorRefClkSrcNotSupported = $FFFCEF39;
  ErrorDataVoltageLowAndHighIncompatible = $FFFCEF3A;
  ErrorInvalidCharInDigPatternString = $FFFCEF3B;
  ErrorCantUsePort3AloneGivenSampTimingTypeOn653x = $FFFCEF3C;
  ErrorCantUsePort1AloneGivenSampTimingTypeOn653x = $FFFCEF3D;
  ErrorPartialUseOfPhysicalLinesWithinPortNotSupported653x = $FFFCEF3E;
  ErrorPhysicalChanNotSupportedGivenSampTimingType653x = $FFFCEF3F;
  ErrorCanExportOnlyDigEdgeTrigs = $FFFCEF40;
  ErrorRefTrigDigPatternSizeDoesNotMatchSourceSize = $FFFCEF41;
  ErrorStartTrigDigPatternSizeDoesNotMatchSourceSize = $FFFCEF42;
  ErrorChangeDetectionRisingAndFallingEdgeChanDontMatch = $FFFCEF43;
  ErrorPhysicalChansForChangeDetectionAndPatternMatch653x = $FFFCEF44;
  ErrorCanExportOnlyOnboardSampClk = $FFFCEF45;
  ErrorInternalSampClkNotRisingEdge = $FFFCEF46;
  ErrorRefTrigDigPatternChanNotInTask = $FFFCEF47;
  ErrorRefTrigDigPatternChanNotTristated = $FFFCEF48;
  ErrorStartTrigDigPatternChanNotInTask = $FFFCEF49;
  ErrorStartTrigDigPatternChanNotTristated = $FFFCEF4A;
  ErrorPXIStarAndClock10Sync = $FFFCEF4B;
  ErrorGlobalChanCannotBeSavedSoInteractiveEditsAllowed = $FFFCEF4C;
  ErrorTaskCannotBeSavedSoInteractiveEditsAllowed = $FFFCEF4D;
  ErrorInvalidGlobalChan = $FFFCEF4E;
  ErrorEveryNSampsEventAlreadyRegistered = $FFFCEF4F;
  ErrorEveryNSampsEventIntervalZeroNotSupported = $FFFCEF50;
  ErrorChanSizeTooBigForU16PortWrite = $FFFCEF51;
  ErrorChanSizeTooBigForU16PortRead = $FFFCEF52;
  ErrorBufferSizeNotMultipleOfEveryNSampsEventIntervalWhenDMA = $FFFCEF53;
  ErrorWriteWhenTaskNotRunningCOTicks = $FFFCEF54;
  ErrorWriteWhenTaskNotRunningCOFreq = $FFFCEF55;
  ErrorWriteWhenTaskNotRunningCOTime = $FFFCEF56;
  ErrorAOMinMaxNotSupportedDACRangeTooSmall = $FFFCEF57;
  ErrorAOMinMaxNotSupportedGivenDACRange = $FFFCEF58;
  ErrorAOMinMaxNotSupportedGivenDACRangeAndOffsetVal = $FFFCEF59;
  ErrorAOMinMaxNotSupportedDACOffsetValInappropriate = $FFFCEF5A;
  ErrorAOMinMaxNotSupportedGivenDACOffsetVal = $FFFCEF5B;
  ErrorAOMinMaxNotSupportedDACRefValTooSmall = $FFFCEF5C;
  ErrorAOMinMaxNotSupportedGivenDACRefVal = $FFFCEF5D;
  ErrorAOMinMaxNotSupportedGivenDACRefAndOffsetVal = $FFFCEF5E;
  ErrorWhenAcqCompAndNumSampsPerChanExceedsOnBrdBufSize = $FFFCEF5F;
  ErrorWhenAcqCompAndNoRefTrig = $FFFCEF60;
  ErrorWaitForNextSampClkNotSupported = $FFFCEF61;
  ErrorDevInUnidentifiedPXIChassis = $FFFCEF62;
  ErrorMaxSoundPressureMicSensitivitRelatedAIPropertiesNotSupportedByDev = $FFFCEF63;
  ErrorMaxSoundPressureAndMicSensitivityNotSupportedByDev = $FFFCEF64;
  ErrorAOBufferSizeZeroForSampClkTimingType = $FFFCEF65;
  ErrorAOCallWriteBeforeStartForSampClkTimingType = $FFFCEF66;
  ErrorInvalidCalLowPassCutoffFreq = $FFFCEF67;
  ErrorSimulationCannotBeDisabledForDevCreatedAsSimulatedDev = $FFFCEF68;
  ErrorCannotAddNewDevsAfterTaskConfiguration = $FFFCEF69;
  ErrorDifftSyncPulseSrcAndSampClkTimebaseSrcDevMultiDevTask = $FFFCEF6A;
  ErrorTermWithoutDevInMultiDevTask = $FFFCEF6B;
  ErrorSyncNoDevSampClkTimebaseOrSyncPulseInPXISlot2 = $FFFCEF6C;
  ErrorPhysicalChanNotOnThisConnector = $FFFCEF6D;
  ErrorNumSampsToWaitNotGreaterThanZeroInScript = $FFFCEF6E;
  ErrorNumSampsToWaitNotMultipleOfAlignmentQuantumInScript = $FFFCEF6F;
  ErrorEveryNSamplesEventNotSupportedForNonBufferedTasks = $FFFCEF70;
  ErrorBufferedAndDataXferPIO = $FFFCEF71;
  ErrorCannotWriteWhenAutoStartFalseAndTaskNotRunning = $FFFCEF72;
  ErrorNonBufferedAndDataXferInterrupts = $FFFCEF73;
  ErrorWriteFailedMultipleCtrsWithFREQOUT = $FFFCEF74;
  ErrorReadNotCompleteBefore3SampClkEdges = $FFFCEF75;
  ErrorCtrHWTimedSinglePointAndDataXferNotProgIO = $FFFCEF76;
  ErrorPrescalerNot1ForInputTerminal = $FFFCEF77;
  ErrorPrescalerNot1ForTimebaseSrc = $FFFCEF78;
  ErrorSampClkTimingTypeWhenTristateIsFalse = $FFFCEF79;
  ErrorOutputBufferSizeNotMultOfXferSize = $FFFCEF7A;
  ErrorSampPerChanNotMultOfXferSize = $FFFCEF7B;
  ErrorWriteToTEDSFailed = $FFFCEF7C;
  ErrorSCXIDevNotUsablePowerTurnedOff = $FFFCEF7D;
  ErrorCannotReadWhenAutoStartFalseBufSizeZeroAndTaskNotRunning = $FFFCEF7E;
  ErrorCannotReadWhenAutoStartFalseHWTimedSinglePtAndTaskNotRunning = $FFFCEF7F;
  ErrorCannotReadWhenAutoStartFalseOnDemandAndTaskNotRunning = $FFFCEF80;
  ErrorSimultaneousAOWhenNotOnDemandTiming = $FFFCEF81;
  ErrorMemMapAndSimultaneousAO = $FFFCEF82;
  ErrorWriteFailedMultipleCOOutputTypes = $FFFCEF83;
  ErrorWriteToTEDSNotSupportedOnRT = $FFFCEF84;
  ErrorVirtualTEDSDataFileError = $FFFCEF85;
  ErrorTEDSSensorDataError = $FFFCEF86;
  ErrorDataSizeMoreThanSizeOfEEPROMOnTEDS = $FFFCEF87;
  ErrorPROMOnTEDSContainsBasicTEDSData = $FFFCEF88;
  ErrorPROMOnTEDSAlreadyWritten = $FFFCEF89;
  ErrorTEDSDoesNotContainPROM = $FFFCEF8A;
  ErrorHWTimedSinglePointNotSupportedAI = $FFFCEF8B;
  ErrorHWTimedSinglePointOddNumChansInAITask = $FFFCEF8C;
  ErrorCantUseOnlyOnBoardMemWithProgrammedIO = $FFFCEF8D;
  ErrorSwitchDevShutDownDueToHighTemp = $FFFCEF8E;
  ErrorExcitationNotSupportedWhenTermCfgDiff = $FFFCEF8F;
  ErrorTEDSMinElecValGEMaxElecVal = $FFFCEF90;
  ErrorTEDSMinPhysValGEMaxPhysVal = $FFFCEF91;
  ErrorCIOnboardClockNotSupportedAsInputTerm = $FFFCEF92;
  ErrorInvalidSampModeForPositionMeas = $FFFCEF93;
  ErrorTrigWhenAOHWTimedSinglePtSampMode = $FFFCEF94;
  ErrorDAQmxCantUseStringDueToUnknownChar = $FFFCEF95;
  ErrorDAQmxCantRetrieveStringDueToUnknownChar = $FFFCEF96;
  ErrorClearTEDSNotSupportedOnRT = $FFFCEF97;
  ErrorCfgTEDSNotSupportedOnRT = $FFFCEF98;
  ErrorProgFilterClkCfgdToDifferentMinPulseWidthBySameTask1PerDev = $FFFCEF99;
  ErrorProgFilterClkCfgdToDifferentMinPulseWidthByAnotherTask1PerDev = $FFFCEF9A;
  ErrorNoLastExtCalDateTimeLastExtCalNotDAQmx = $FFFCEF9C;
  ErrorCannotWriteNotStartedAutoStartFalseNotOnDemandHWTimedSglPt = $FFFCEF9D;
  ErrorCannotWriteNotStartedAutoStartFalseNotOnDemandBufSizeZero = $FFFCEF9E;
  ErrorCOInvalidTimingSrcDueToSignal = $FFFCEF9F;
  ErrorCIInvalidTimingSrcForSampClkDueToSampTimingType = $FFFCEFA0;
  ErrorCIInvalidTimingSrcForEventCntDueToSampMode = $FFFCEFA1;
  ErrorNoChangeDetectOnNonInputDigLineForDev = $FFFCEFA2;
  ErrorEmptyStringTermNameNotSupported = $FFFCEFA3;
  ErrorMemMapEnabledForHWTimedNonBufferedAO = $FFFCEFA4;
  ErrorDevOnboardMemOverflowDuringHWTimedNonBufferedGen = $FFFCEFA5;
  ErrorCODAQmxWriteMultipleChans = $FFFCEFA6;
  ErrorCantMaintainExistingValueAOSync = $FFFCEFA7;
  ErrorMStudioMultiplePhysChansNotSupported = $FFFCEFA8;
  ErrorCantConfigureTEDSForChan = $FFFCEFA9;
  ErrorWriteDataTypeTooSmall = $FFFCEFAA;
  ErrorReadDataTypeTooSmall = $FFFCEFAB;
  ErrorMeasuredBridgeOffsetTooHigh = $FFFCEFAC;
  ErrorStartTrigConflictWithCOHWTimedSinglePt = $FFFCEFAD;
  ErrorSampClkRateExtSampClkTimebaseRateMismatch = $FFFCEFAE;
  ErrorInvalidTimingSrcDueToSampTimingType = $FFFCEFAF;
  ErrorVirtualTEDSFileNotFound = $FFFCEFB0;
  ErrorMStudioNoForwardPolyScaleCoeffs = $FFFCEFB1;
  ErrorMStudioNoReversePolyScaleCoeffs = $FFFCEFB2;
  ErrorMStudioNoPolyScaleCoeffsUseCalc = $FFFCEFB3;
  ErrorMStudioNoForwardPolyScaleCoeffsUseCalc = $FFFCEFB4;
  ErrorMStudioNoReversePolyScaleCoeffsUseCalc = $FFFCEFB5;
  ErrorCOSampModeSampTimingTypeSampClkConflict = $FFFCEFB6;
  ErrorDevCannotProduceMinPulseWidth = $FFFCEFB7;
  ErrorCannotProduceMinPulseWidthGivenPropertyValues = $FFFCEFB8;
  ErrorTermCfgdToDifferentMinPulseWidthByAnotherTask = $FFFCEFB9;
  ErrorTermCfgdToDifferentMinPulseWidthByAnotherProperty = $FFFCEFBA;
  ErrorDigSyncNotAvailableOnTerm = $FFFCEFBB;
  ErrorDigFilterNotAvailableOnTerm = $FFFCEFBC;
  ErrorDigFilterEnabledMinPulseWidthNotCfg = $FFFCEFBD;
  ErrorDigFilterAndSyncBothEnabled = $FFFCEFBE;
  ErrorHWTimedSinglePointAOAndDataXferNotProgIO = $FFFCEFBF;
  ErrorNonBufferedAOAndDataXferNotProgIO = $FFFCEFC0;
  ErrorProgIODataXferForBufferedAO = $FFFCEFC1;
  ErrorTEDSLegacyTemplateIDInvalidOrUnsupported = $FFFCEFC2;
  ErrorTEDSMappingMethodInvalidOrUnsupported = $FFFCEFC3;
  ErrorTEDSLinearMappingSlopeZero = $FFFCEFC4;
  ErrorAIInputBufferSizeNotMultOfXferSize = $FFFCEFC5;
  ErrorNoSyncPulseExtSampClkTimebase = $FFFCEFC6;
  ErrorNoSyncPulseAnotherTaskRunning = $FFFCEFC7;
  ErrorAOMinMaxNotInGainRange = $FFFCEFC8;
  ErrorAOMinMaxNotInDACRange = $FFFCEFC9;
  ErrorDevOnlySupportsSampClkTimingAO = $FFFCEFCA;
  ErrorDevOnlySupportsSampClkTimingAI = $FFFCEFCB;
  ErrorTEDSIncompatibleSensorAndMeasType = $FFFCEFCC;
  ErrorTEDSMultipleCalTemplatesNotSupported = $FFFCEFCD;
  ErrorTEDSTemplateParametersNotSupported = $FFFCEFCE;
  ErrorParsingTEDSData = $FFFCEFCF;
  ErrorMultipleActivePhysChansNotSupported = $FFFCEFD0;
  ErrorNoChansSpecdForChangeDetect = $FFFCEFD1;
  ErrorInvalidCalVoltageForGivenGain = $FFFCEFD2;
  ErrorInvalidCalGain = $FFFCEFD3;
  ErrorMultipleWritesBetweenSampClks = $FFFCEFD4;
  ErrorInvalidAcqTypeForFREQOUT = $FFFCEFD5;
  ErrorSuitableTimebaseNotFoundTimeCombo2 = $FFFCEFD6;
  ErrorSuitableTimebaseNotFoundFrequencyCombo2 = $FFFCEFD7;
  ErrorRefClkRateRefClkSrcMismatch = $FFFCEFD8;
  ErrorNoTEDSTerminalBlock = $FFFCEFD9;
  ErrorCorruptedTEDSMemory = $FFFCEFDA;
  ErrorTEDSNotSupported = $FFFCEFDB;
  ErrorTimingSrcTaskStartedBeforeTimedLoop = $FFFCEFDC;
  ErrorPropertyNotSupportedForTimingSrc = $FFFCEFDD;
  ErrorTimingSrcDoesNotExist = $FFFCEFDE;
  ErrorInputBufferSizeNotEqualSampsPerChanForFiniteSampMode = $FFFCEFDF;
  ErrorFREQOUTCannotProduceDesiredFrequency2 = $FFFCEFE0;
  ErrorExtRefClkRateNotSpecified = $FFFCEFE1;
  ErrorDeviceDoesNotSupportDMADataXferForNonBufferedAcq = $FFFCEFE2;
  ErrorDigFilterMinPulseWidthSetWhenTristateIsFalse = $FFFCEFE3;
  ErrorDigFilterEnableSetWhenTristateIsFalse = $FFFCEFE4;
  ErrorNoHWTimingWithOnDemand = $FFFCEFE5;
  ErrorCannotDetectChangesWhenTristateIsFalse = $FFFCEFE6;
  ErrorCannotHandshakeWhenTristateIsFalse = $FFFCEFE7;
  ErrorLinesUsedForStaticInputNotForHandshakingControl = $FFFCEFE8;
  ErrorLinesUsedForHandshakingControlNotForStaticInput = $FFFCEFE9;
  ErrorLinesUsedForStaticInputNotForHandshakingInput = $FFFCEFEA;
  ErrorLinesUsedForHandshakingInputNotForStaticInput = $FFFCEFEB;
  ErrorDifferentDITristateValsForChansInTask = $FFFCEFEC;
  ErrorTimebaseCalFreqVarianceTooLarge = $FFFCEFED;
  ErrorTimebaseCalFailedToConverge = $FFFCEFEE;
  ErrorInadequateResolutionForTimebaseCal = $FFFCEFEF;
  ErrorInvalidAOGainCalConst = $FFFCEFF0;
  ErrorInvalidAOOffsetCalConst = $FFFCEFF1;
  ErrorInvalidAIGainCalConst = $FFFCEFF2;
  ErrorInvalidAIOffsetCalConst = $FFFCEFF3;
  ErrorDigOutputOverrun = $FFFCEFF4;
  ErrorDigInputOverrun = $FFFCEFF5;
  ErrorAcqStoppedDriverCantXferDataFastEnough = $FFFCEFF6;
  ErrorChansCantAppearInSameTask = $FFFCEFF7;
  ErrorInputCfgFailedBecauseWatchdogExpired = $FFFCEFF8;
  ErrorAnalogTrigChanNotExternal = $FFFCEFF9;
  ErrorTooManyChansForInternalAIInputSrc = $FFFCEFFA;
  ErrorTEDSSensorNotDetected = $FFFCEFFB;
  ErrorPrptyGetSpecdActiveItemFailedDueToDifftValues = $FFFCEFFC;
  ErrorRoutingDestTermPXIClk10InNotInSlot2 = $FFFCEFFE;
  ErrorRoutingDestTermPXIStarXNotInSlot2 = $FFFCEFFF;
  ErrorRoutingSrcTermPXIStarXNotInSlot2 = $FFFCF000;
  ErrorRoutingSrcTermPXIStarInSlot16AndAbove = $FFFCF001;
  ErrorRoutingDestTermPXIStarInSlot16AndAbove = $FFFCF002;
  ErrorRoutingDestTermPXIStarInSlot2 = $FFFCF003;
  ErrorRoutingSrcTermPXIStarInSlot2 = $FFFCF004;
  ErrorRoutingDestTermPXIChassisNotIdentified = $FFFCF005;
  ErrorRoutingSrcTermPXIChassisNotIdentified = $FFFCF006;
  ErrorFailedToAcquireCalData = $FFFCF007;
  ErrorBridgeOffsetNullingCalNotSupported = $FFFCF008;
  ErrorAIMaxNotSpecified = $FFFCF009;
  ErrorAIMinNotSpecified = $FFFCF00A;
  ErrorOddTotalBufferSizeToWrite = $FFFCF00B;
  ErrorOddTotalNumSampsToWrite = $FFFCF00C;
  ErrorBufferWithWaitMode = $FFFCF00D;
  ErrorBufferWithHWTimedSinglePointSampMode = $FFFCF00E;
  ErrorCOWritePulseLowTicksNotSupported = $FFFCF00F;
  ErrorCOWritePulseHighTicksNotSupported = $FFFCF010;
  ErrorCOWritePulseLowTimeOutOfRange = $FFFCF011;
  ErrorCOWritePulseHighTimeOutOfRange = $FFFCF012;
  ErrorCOWriteFreqOutOfRange = $FFFCF013;
  ErrorCOWriteDutyCycleOutOfRange = $FFFCF014;
  ErrorInvalidInstallation = $FFFCF015;
  ErrorRefTrigMasterSessionUnavailable = $FFFCF016;
  ErrorRouteFailedBecauseWatchdogExpired = $FFFCF017;
  ErrorDeviceShutDownDueToHighTemp = $FFFCF018;
  ErrorNoMemMapWhenHWTimedSinglePoint = $FFFCF019;
  ErrorWriteFailedBecauseWatchdogExpired = $FFFCF01A;
  ErrorDifftInternalAIInputSrcs = $FFFCF01B;
  ErrorDifftAIInputSrcInOneChanGroup = $FFFCF01C;
  ErrorInternalAIInputSrcInMultChanGroups = $FFFCF01D;
  ErrorSwitchOpFailedDueToPrevError = $FFFCF01E;
  ErrorWroteMultiSampsUsingSingleSampWrite = $FFFCF01F;
  ErrorMismatchedInputArraySizes = $FFFCF020;
  ErrorCantExceedRelayDriveLimit = $FFFCF021;
  ErrorDACRngLowNotEqualToMinusRefVal = $FFFCF022;
  ErrorCantAllowConnectDACToGnd = $FFFCF023;
  ErrorWatchdogTimeoutOutOfRangeAndNotSpecialVal = $FFFCF024;
  ErrorNoWatchdogOutputOnPortReservedForInput = $FFFCF025;
  ErrorNoInputOnPortCfgdForWatchdogOutput = $FFFCF026;
  ErrorWatchdogExpirationStateNotEqualForLinesInPort = $FFFCF027;
  ErrorCannotPerformOpWhenTaskNotReserved = $FFFCF028;
  ErrorPowerupStateNotSupported = $FFFCF029;
  ErrorWatchdogTimerNotSupported = $FFFCF02A;
  ErrorOpNotSupportedWhenRefClkSrcNone = $FFFCF02B;
  ErrorSampClkRateUnavailable = $FFFCF02C;
  ErrorPrptyGetSpecdSingleActiveChanFailedDueToDifftVals = $FFFCF02D;
  ErrorPrptyGetImpliedActiveChanFailedDueToDifftVals = $FFFCF02E;
  ErrorPrptyGetSpecdActiveChanFailedDueToDifftVals = $FFFCF02F;
  ErrorNoRegenWhenUsingBrdMem = $FFFCF030;
  ErrorNonbufferedReadMoreThanSampsPerChan = $FFFCF031;
  ErrorWatchdogExpirationTristateNotSpecdForEntirePort = $FFFCF032;
  ErrorPowerupTristateNotSpecdForEntirePort = $FFFCF033;
  ErrorPowerupStateNotSpecdForEntirePort = $FFFCF034;
  ErrorCantSetWatchdogExpirationOnDigInChan = $FFFCF035;
  ErrorCantSetPowerupStateOnDigInChan = $FFFCF036;
  ErrorPhysChanNotInTask = $FFFCF037;
  ErrorPhysChanDevNotInTask = $FFFCF038;
  ErrorDigInputNotSupported = $FFFCF039;
  ErrorDigFilterIntervalNotEqualForLines = $FFFCF03A;
  ErrorDigFilterIntervalAlreadyCfgd = $FFFCF03B;
  ErrorCantResetExpiredWatchdog = $FFFCF03C;
  ErrorActiveChanTooManyLinesSpecdWhenGettingPrpty = $FFFCF03D;
  ErrorActiveChanNotSpecdWhenGetting1LinePrpty = $FFFCF03E;
  ErrorDigPrptyCannotBeSetPerLine = $FFFCF03F;
  ErrorSendAdvCmpltAfterWaitForTrigInScanlist = $FFFCF040;
  ErrorDisconnectionRequiredInScanlist = $FFFCF041;
  ErrorTwoWaitForTrigsAfterConnectionInScanlist = $FFFCF042;
  ErrorActionSeparatorRequiredAfterBreakingConnectionInScanlist = $FFFCF043;
  ErrorConnectionInScanlistMustWaitForTrig = $FFFCF044;
  ErrorActionNotSupportedTaskNotWatchdog = $FFFCF045;
  ErrorWfmNameSameAsScriptName = $FFFCF046;
  ErrorScriptNameSameAsWfmName = $FFFCF047;
  ErrorDSFStopClock = $FFFCF048;
  ErrorDSFReadyForStartClock = $FFFCF049;
  ErrorWriteOffsetNotMultOfIncr = $FFFCF04A;
  ErrorDifferentPrptyValsNotSupportedOnDev = $FFFCF04B;
  ErrorRefAndPauseTrigConfigured = $FFFCF04C;
  ErrorFailedToEnableHighSpeedInputClock = $FFFCF04D;
  ErrorEmptyPhysChanInPowerUpStatesArray = $FFFCF04E;
  ErrorActivePhysChanTooManyLinesSpecdWhenGettingPrpty = $FFFCF04F;
  ErrorActivePhysChanNotSpecdWhenGetting1LinePrpty = $FFFCF050;
  ErrorPXIDevTempCausedShutDown = $FFFCF051;
  ErrorInvalidNumSampsToWrite = $FFFCF052;
  ErrorOutputFIFOUnderflow2 = $FFFCF053;
  ErrorRepeatedAIPhysicalChan = $FFFCF054;
  ErrorMultScanOpsInOneChassis = $FFFCF055;
  ErrorInvalidAIChanOrder = $FFFCF056;
  ErrorReversePowerProtectionActivated = $FFFCF057;
  ErrorInvalidAsynOpHandle = $FFFCF058;
  ErrorFailedToEnableHighSpeedOutput = $FFFCF059;
  ErrorCannotReadPastEndOfRecord = $FFFCF05A;
  ErrorAcqStoppedToPreventInputBufferOverwriteOneDataXferMech = $FFFCF05B;
  ErrorZeroBasedChanIndexInvalid = $FFFCF05C;
  ErrorNoChansOfGivenTypeInTask = $FFFCF05D;
  ErrorSampClkSrcInvalidForOutputValidForInput = $FFFCF05E;
  ErrorOutputBufSizeTooSmallToStartGen = $FFFCF05F;
  ErrorInputBufSizeTooSmallToStartAcq = $FFFCF060;
  ErrorExportTwoSignalsOnSameTerminal = $FFFCF061;
  ErrorChanIndexInvalid = $FFFCF062;
  ErrorRangeSyntaxNumberTooBig = $FFFCF063;
  ErrorNULLPtr = $FFFCF064;
  ErrorScaledMinEqualMax = $FFFCF065;
  ErrorPreScaledMinEqualMax = $FFFCF066;
  ErrorPropertyNotSupportedForScaleType = $FFFCF067;
  ErrorChannelNameGenerationNumberTooBig = $FFFCF068;
  ErrorRepeatedNumberInScaledValues = $FFFCF069;
  ErrorRepeatedNumberInPreScaledValues = $FFFCF06A;
  ErrorLinesAlreadyReservedForOutput = $FFFCF06B;
  ErrorSwitchOperationChansSpanMultipleDevsInList = $FFFCF06C;
  ErrorInvalidIDInListAtBeginningOfSwitchOperation = $FFFCF06D;
  ErrorMStudioInvalidPolyDirection = $FFFCF06E;
  ErrorMStudioPropertyGetWhileTaskNotVerified = $FFFCF06F;
  ErrorRangeWithTooManyObjects = $FFFCF070;
  ErrorCppDotNetAPINegativeBufferSize = $FFFCF071;
  ErrorCppCantRemoveInvalidEventHandler = $FFFCF072;
  ErrorCppCantRemoveEventHandlerTwice = $FFFCF073;
  ErrorCppCantRemoveOtherObjectsEventHandler = $FFFCF074;
  ErrorDigLinesReservedOrUnavailable = $FFFCF075;
  ErrorDSFFailedToResetStream = $FFFCF076;
  ErrorDSFReadyForOutputNotAsserted = $FFFCF077;
  ErrorSampToWritePerChanNotMultipleOfIncr = $FFFCF078;
  ErrorAOPropertiesCauseVoltageBelowMin = $FFFCF079;
  ErrorAOPropertiesCauseVoltageOverMax = $FFFCF07A;
  ErrorPropertyNotSupportedWhenRefClkSrcNone = $FFFCF07B;
  ErrorAIMaxTooSmall = $FFFCF07C;
  ErrorAIMaxTooLarge = $FFFCF07D;
  ErrorAIMinTooSmall = $FFFCF07E;
  ErrorAIMinTooLarge = $FFFCF07F;
  ErrorBuiltInCJCSrcNotSupported = $FFFCF080;
  ErrorTooManyPostTrigSampsPerChan = $FFFCF081;
  ErrorTrigLineNotFoundSingleDevRoute = $FFFCF082;
  ErrorDifferentInternalAIInputSources = $FFFCF083;
  ErrorDifferentAIInputSrcInOneChanGroup = $FFFCF084;
  ErrorInternalAIInputSrcInMultipleChanGroups = $FFFCF085;
  ErrorCAPIChanIndexInvalid = $FFFCF086;
  ErrorCollectionDoesNotMatchChanType = $FFFCF087;
  ErrorOutputCantStartChangedRegenerationMode = $FFFCF088;
  ErrorOutputCantStartChangedBufferSize = $FFFCF089;
  ErrorChanSizeTooBigForU32PortWrite = $FFFCF08A;
  ErrorChanSizeTooBigForU8PortWrite = $FFFCF08B;
  ErrorChanSizeTooBigForU32PortRead = $FFFCF08C;
  ErrorChanSizeTooBigForU8PortRead = $FFFCF08D;
  ErrorInvalidDigDataWrite = $FFFCF08E;
  ErrorInvalidAODataWrite = $FFFCF08F;
  ErrorWaitUntilDoneDoesNotIndicateDone = $FFFCF090;
  ErrorMultiChanTypesInTask = $FFFCF091;
  ErrorMultiDevsInTask = $FFFCF092;
  ErrorCannotSetPropertyWhenTaskRunning = $FFFCF093;
  ErrorCannotGetPropertyWhenTaskNotCommittedOrRunning = $FFFCF094;
  ErrorLeadingUnderscoreInString = $FFFCF095;
  ErrorTrailingSpaceInString = $FFFCF096;
  ErrorLeadingSpaceInString = $FFFCF097;
  ErrorInvalidCharInString = $FFFCF098;
  ErrorDLLBecameUnlocked = $FFFCF099;
  ErrorDLLLock = $FFFCF09A;
  ErrorSelfCalConstsInvalid = $FFFCF09B;
  ErrorInvalidTrigCouplingExceptForExtTrigChan = $FFFCF09C;
  ErrorWriteFailsBufferSizeAutoConfigured = $FFFCF09D;
  ErrorExtCalAdjustExtRefVoltageFailed = $FFFCF09E;
  ErrorSelfCalFailedExtNoiseOrRefVoltageOutOfCal = $FFFCF09F;
  ErrorExtCalTemperatureNotDAQmx = $FFFCF0A0;
  ErrorExtCalDateTimeNotDAQmx = $FFFCF0A1;
  ErrorSelfCalTemperatureNotDAQmx = $FFFCF0A2;
  ErrorSelfCalDateTimeNotDAQmx = $FFFCF0A3;
  ErrorDACRefValNotSet = $FFFCF0A4;
  ErrorAnalogMultiSampWriteNotSupported = $FFFCF0A5;
  ErrorInvalidActionInControlTask = $FFFCF0A6;
  ErrorPolyCoeffsInconsistent = $FFFCF0A7;
  ErrorSensorValTooLow = $FFFCF0A8;
  ErrorSensorValTooHigh = $FFFCF0A9;
  ErrorWaveformNameTooLong = $FFFCF0AA;
  ErrorIdentifierTooLongInScript = $FFFCF0AB;
  ErrorUnexpectedIDFollowingSwitchChanName = $FFFCF0AC;
  ErrorRelayNameNotSpecifiedInList = $FFFCF0AD;
  ErrorUnexpectedIDFollowingRelayNameInList = $FFFCF0AE;
  ErrorUnexpectedIDFollowingSwitchOpInList = $FFFCF0AF;
  ErrorInvalidLineGrouping = $FFFCF0B0;
  ErrorCtrMinMax = $FFFCF0B1;
  ErrorWriteChanTypeMismatch = $FFFCF0B2;
  ErrorReadChanTypeMismatch = $FFFCF0B3;
  ErrorWriteNumChansMismatch = $FFFCF0B4;
  ErrorOneChanReadForMultiChanTask = $FFFCF0B5;
  ErrorCannotSelfCalDuringExtCal = $FFFCF0B6;
  ErrorMeasCalAdjustOscillatorPhaseDAC = $FFFCF0B7;
  ErrorInvalidCalConstCalADCAdjustment = $FFFCF0B8;
  ErrorInvalidCalConstOscillatorFreqDACValue = $FFFCF0B9;
  ErrorInvalidCalConstOscillatorPhaseDACValue = $FFFCF0BA;
  ErrorInvalidCalConstOffsetDACValue = $FFFCF0BB;
  ErrorInvalidCalConstGainDACValue = $FFFCF0BC;
  ErrorInvalidNumCalADCReadsToAverage = $FFFCF0BD;
  ErrorInvalidCfgCalAdjustDirectPathOutputImpedance = $FFFCF0BE;
  ErrorInvalidCfgCalAdjustMainPathOutputImpedance = $FFFCF0BF;
  ErrorInvalidCfgCalAdjustMainPathPostAmpGainAndOffset = $FFFCF0C0;
  ErrorInvalidCfgCalAdjustMainPathPreAmpGain = $FFFCF0C1;
  ErrorInvalidCfgCalAdjustMainPreAmpOffset = $FFFCF0C2;
  ErrorMeasCalAdjustCalADC = $FFFCF0C3;
  ErrorMeasCalAdjustOscillatorFrequency = $FFFCF0C4;
  ErrorMeasCalAdjustDirectPathOutputImpedance = $FFFCF0C5;
  ErrorMeasCalAdjustMainPathOutputImpedance = $FFFCF0C6;
  ErrorMeasCalAdjustDirectPathGain = $FFFCF0C7;
  ErrorMeasCalAdjustMainPathPostAmpGainAndOffset = $FFFCF0C8;
  ErrorMeasCalAdjustMainPathPreAmpGain = $FFFCF0C9;
  ErrorMeasCalAdjustMainPathPreAmpOffset = $FFFCF0CA;
  ErrorInvalidDateTimeInEEPROM = $FFFCF0CB;
  ErrorUnableToLocateErrorResources = $FFFCF0CC;
  ErrorDotNetAPINotUnsigned32BitNumber = $FFFCF0CD;
  ErrorInvalidRangeOfObjectsSyntaxInString = $FFFCF0CE;
  ErrorAttemptToEnableLineNotPreviouslyDisabled = $FFFCF0CF;
  ErrorInvalidCharInPattern = $FFFCF0D0;
  ErrorIntermediateBufferFull = $FFFCF0D1;
  ErrorLoadTaskFailsBecauseNoTimingOnDev = $FFFCF0D2;
  ErrorCAPIReservedParamNotNULLNorEmpty = $FFFCF0D3;
  ErrorCAPIReservedParamNotNULL = $FFFCF0D4;
  ErrorCAPIReservedParamNotZero = $FFFCF0D5;
  ErrorSampleValueOutOfRange = $FFFCF0D6;
  ErrorChanAlreadyInTask = $FFFCF0D7;
  ErrorVirtualChanDoesNotExist = $FFFCF0D8;
  ErrorChanNotInTask = $FFFCF0DA;
  ErrorTaskNotInDataNeighborhood = $FFFCF0DB;
  ErrorCantSaveTaskWithoutReplace = $FFFCF0DC;
  ErrorCantSaveChanWithoutReplace = $FFFCF0DD;
  ErrorDevNotInTask = $FFFCF0DE;
  ErrorDevAlreadyInTask = $FFFCF0DF;
  ErrorCanNotPerformOpWhileTaskRunning = $FFFCF0E1;
  ErrorCanNotPerformOpWhenNoChansInTask = $FFFCF0E2;
  ErrorCanNotPerformOpWhenNoDevInTask = $FFFCF0E3;
  ErrorCannotPerformOpWhenTaskNotRunning = $FFFCF0E5;
  ErrorOperationTimedOut = $FFFCF0E6;
  ErrorCannotReadWhenAutoStartFalseAndTaskNotRunningOrCommitted = $FFFCF0E7;
  ErrorCannotWriteWhenAutoStartFalseAndTaskNotRunningOrCommitted = $FFFCF0E8;
  ErrorTaskVersionNew = $FFFCF0EA;
  ErrorChanVersionNew = $FFFCF0EB;
  ErrorEmptyString = $FFFCF0ED;
  ErrorChannelSizeTooBigForPortReadType = $FFFCF0EE;
  ErrorChannelSizeTooBigForPortWriteType = $FFFCF0EF;
  ErrorExpectedNumberOfChannelsVerificationFailed = $FFFCF0F0;
  ErrorNumLinesMismatchInReadOrWrite = $FFFCF0F1;
  ErrorOutputBufferEmpty = $FFFCF0F2;
  ErrorInvalidChanName = $FFFCF0F3;
  ErrorReadNoInputChansInTask = $FFFCF0F4;
  ErrorWriteNoOutputChansInTask = $FFFCF0F5;
  ErrorPropertyNotSupportedNotInputTask = $FFFCF0F7;
  ErrorPropertyNotSupportedNotOutputTask = $FFFCF0F8;
  ErrorGetPropertyNotInputBufferedTask = $FFFCF0F9;
  ErrorGetPropertyNotOutputBufferedTask = $FFFCF0FA;
  ErrorInvalidTimeoutVal = $FFFCF0FB;
  ErrorAttributeNotSupportedInTaskContext = $FFFCF0FC;
  ErrorAttributeNotQueryableUnlessTaskIsCommitted = $FFFCF0FD;
  ErrorAttributeNotSettableWhenTaskIsRunning = $FFFCF0FE;
  ErrorDACRngLowNotMinusRefValNorZero = $FFFCF0FF;
  ErrorDACRngHighNotEqualRefVal = $FFFCF100;
  ErrorUnitsNotFromCustomScale = $FFFCF101;
  ErrorInvalidVoltageReadingDuringExtCal = $FFFCF102;
  ErrorCalFunctionNotSupported = $FFFCF103;
  ErrorInvalidPhysicalChanForCal = $FFFCF104;
  ErrorExtCalNotComplete = $FFFCF105;
  ErrorCantSyncToExtStimulusFreqDuringCal = $FFFCF106;
  ErrorUnableToDetectExtStimulusFreqDuringCal = $FFFCF107;
  ErrorInvalidCloseAction = $FFFCF108;
  ErrorExtCalFunctionOutsideExtCalSession = $FFFCF109;
  ErrorInvalidCalArea = $FFFCF10A;
  ErrorExtCalConstsInvalid = $FFFCF10B;
  ErrorStartTrigDelayWithExtSampClk = $FFFCF10C;
  ErrorDelayFromSampClkWithExtConv = $FFFCF10D;
  ErrorFewerThan2PreScaledVals = $FFFCF10E;
  ErrorFewerThan2ScaledValues = $FFFCF10F;
  ErrorPhysChanOutputType = $FFFCF110;
  ErrorPhysChanMeasType = $FFFCF111;
  ErrorInvalidPhysChanType = $FFFCF112;
  ErrorLabVIEWEmptyTaskOrChans = $FFFCF113;
  ErrorLabVIEWInvalidTaskOrChans = $FFFCF114;
  ErrorInvalidRefClkRate = $FFFCF115;
  ErrorInvalidExtTrigImpedance = $FFFCF116;
  ErrorHystTrigLevelAIMax = $FFFCF117;
  ErrorLineNumIncompatibleWithVideoSignalFormat = $FFFCF118;
  ErrorTrigWindowAIMinAIMaxCombo = $FFFCF119;
  ErrorTrigAIMinAIMax = $FFFCF11A;
  ErrorHystTrigLevelAIMin = $FFFCF11B;
  ErrorInvalidSampRateConsiderRIS = $FFFCF11C;
  ErrorInvalidReadPosDuringRIS = $FFFCF11D;
  ErrorImmedTrigDuringRISMode = $FFFCF11E;
  ErrorTDCNotEnabledDuringRISMode = $FFFCF11F;
  ErrorMultiRecWithRIS = $FFFCF120;
  ErrorInvalidRefClkSrc = $FFFCF121;
  ErrorInvalidSampClkSrc = $FFFCF122;
  ErrorInsufficientOnBoardMemForNumRecsAndSamps = $FFFCF123;
  ErrorInvalidAIAttenuation = $FFFCF124;
  ErrorACCouplingNotAllowedWith50OhmImpedance = $FFFCF125;
  ErrorInvalidRecordNum = $FFFCF126;
  ErrorZeroSlopeLinearScale = $FFFCF127;
  ErrorZeroReversePolyScaleCoeffs = $FFFCF128;
  ErrorZeroForwardPolyScaleCoeffs = $FFFCF129;
  ErrorNoReversePolyScaleCoeffs = $FFFCF12A;
  ErrorNoForwardPolyScaleCoeffs = $FFFCF12B;
  ErrorNoPolyScaleCoeffs = $FFFCF12C;
  ErrorReversePolyOrderLessThanNumPtsToCompute = $FFFCF12D;
  ErrorReversePolyOrderNotPositive = $FFFCF12E;
  ErrorNumPtsToComputeNotPositive = $FFFCF12F;
  ErrorWaveformLengthNotMultipleOfIncr = $FFFCF130;
  ErrorCAPINoExtendedErrorInfoAvailable = $FFFCF131;
  ErrorCVIFunctionNotFoundInDAQmxDLL = $FFFCF132;
  ErrorCVIFailedToLoadDAQmxDLL = $FFFCF133;
  ErrorNoCommonTrigLineForImmedRoute = $FFFCF134;
  ErrorNoCommonTrigLineForTaskRoute = $FFFCF135;
  ErrorF64PrptyValNotUnsignedInt = $FFFCF136;
  ErrorRegisterNotWritable = $FFFCF137;
  ErrorInvalidOutputVoltageAtSampClkRate = $FFFCF138;
  ErrorStrobePhaseShiftDCMBecameUnlocked = $FFFCF139;
  ErrorDrivePhaseShiftDCMBecameUnlocked = $FFFCF13A;
  ErrorClkOutPhaseShiftDCMBecameUnlocked = $FFFCF13B;
  ErrorOutputBoardClkDCMBecameUnlocked = $FFFCF13C;
  ErrorInputBoardClkDCMBecameUnlocked = $FFFCF13D;
  ErrorInternalClkDCMBecameUnlocked = $FFFCF13E;
  ErrorDCMLock = $FFFCF13F;
  ErrorDataLineReservedForDynamicOutput = $FFFCF140;
  ErrorInvalidRefClkSrcGivenSampClkSrc = $FFFCF141;
  ErrorNoPatternMatcherAvailable = $FFFCF142;
  ErrorInvalidDelaySampRateBelowPhaseShiftDCMThresh = $FFFCF143;
  ErrorStrainGageCalibration = $FFFCF144;
  ErrorInvalidExtClockFreqAndDivCombo = $FFFCF145;
  ErrorCustomScaleDoesNotExist = $FFFCF146;
  ErrorOnlyFrontEndChanOpsDuringScan = $FFFCF147;
  ErrorInvalidOptionForDigitalPortChannel = $FFFCF148;
  ErrorUnsupportedSignalTypeExportSignal = $FFFCF149;
  ErrorInvalidSignalTypeExportSignal = $FFFCF14A;
  ErrorUnsupportedTrigTypeSendsSWTrig = $FFFCF14B;
  ErrorInvalidTrigTypeSendsSWTrig = $FFFCF14C;
  ErrorRepeatedPhysicalChan = $FFFCF14D;
  ErrorResourcesInUseForRouteInTask = $FFFCF14E;
  ErrorResourcesInUseForRoute = $FFFCF14F;
  ErrorRouteNotSupportedByHW = $FFFCF150;
  ErrorResourcesInUseForExportSignalPolarity = $FFFCF151;
  ErrorResourcesInUseForInversionInTask = $FFFCF152;
  ErrorResourcesInUseForInversion = $FFFCF153;
  ErrorExportSignalPolarityNotSupportedByHW = $FFFCF154;
  ErrorInversionNotSupportedByHW = $FFFCF155;
  ErrorOverloadedChansExistNotRead = $FFFCF156;
  ErrorInputFIFOOverflow2 = $FFFCF157;
  ErrorCJCChanNotSpecd = $FFFCF158;
  ErrorCtrExportSignalNotPossible = $FFFCF159;
  ErrorRefTrigWhenContinuous = $FFFCF15A;
  ErrorIncompatibleSensorOutputAndDeviceInputRanges = $FFFCF15B;
  ErrorCustomScaleNameUsed = $FFFCF15C;
  ErrorPropertyValNotSupportedByHW = $FFFCF15D;
  ErrorPropertyValNotValidTermName = $FFFCF15E;
  ErrorResourcesInUseForProperty = $FFFCF15F;
  ErrorCJCChanAlreadyUsed = $FFFCF160;
  ErrorForwardPolynomialCoefNotSpecd = $FFFCF161;
  ErrorTableScaleNumPreScaledAndScaledValsNotEqual = $FFFCF162;
  ErrorTableScalePreScaledValsNotSpecd = $FFFCF163;
  ErrorTableScaleScaledValsNotSpecd = $FFFCF164;
  ErrorIntermediateBufferSizeNotMultipleOfIncr = $FFFCF165;
  ErrorEventPulseWidthOutOfRange = $FFFCF166;
  ErrorEventDelayOutOfRange = $FFFCF167;
  ErrorSampPerChanNotMultipleOfIncr = $FFFCF168;
  ErrorCannotCalculateNumSampsTaskNotStarted = $FFFCF169;
  ErrorScriptNotInMem = $FFFCF16A;
  ErrorOnboardMemTooSmall = $FFFCF16B;
  ErrorReadAllAvailableDataWithoutBuffer = $FFFCF16C;
  ErrorPulseActiveAtStart = $FFFCF16D;
  ErrorCalTempNotSupported = $FFFCF16E;
  ErrorDelayFromSampClkTooLong = $FFFCF16F;
  ErrorDelayFromSampClkTooShort = $FFFCF170;
  ErrorAIConvRateTooHigh = $FFFCF171;
  ErrorDelayFromStartTrigTooLong = $FFFCF172;
  ErrorDelayFromStartTrigTooShort = $FFFCF173;
  ErrorSampRateTooHigh = $FFFCF174;
  ErrorSampRateTooLow = $FFFCF175;
  ErrorPFI0UsedForAnalogAndDigitalSrc = $FFFCF176;
  ErrorPrimingCfgFIFO = $FFFCF177;
  ErrorCannotOpenTopologyCfgFile = $FFFCF178;
  ErrorInvalidDTInsideWfmDataType = $FFFCF179;
  ErrorRouteSrcAndDestSame = $FFFCF17A;
  ErrorReversePolynomialCoefNotSpecd = $FFFCF17B;
  ErrorDevAbsentOrUnavailable = $FFFCF17C;
  ErrorNoAdvTrigForMultiDevScan = $FFFCF17D;
  ErrorInterruptsInsufficientDataXferMech = $FFFCF17E;
  ErrorInvalidAttentuationBasedOnMinMax = $FFFCF17F;
  ErrorCabledModuleCannotRouteSSH = $FFFCF180;
  ErrorCabledModuleCannotRouteConvClk = $FFFCF181;
  ErrorInvalidExcitValForScaling = $FFFCF182;
  ErrorNoDevMemForScript = $FFFCF183;
  ErrorScriptDataUnderflow = $FFFCF184;
  ErrorNoDevMemForWaveform = $FFFCF185;
  ErrorStreamDCMBecameUnlocked = $FFFCF186;
  ErrorStreamDCMLock = $FFFCF187;
  ErrorWaveformNotInMem = $FFFCF188;
  ErrorWaveformWriteOutOfBounds = $FFFCF189;
  ErrorWaveformPreviouslyAllocated = $FFFCF18A;
  ErrorSampClkTbMasterTbDivNotAppropriateForSampTbSrc = $FFFCF18B;
  ErrorSampTbRateSampTbSrcMismatch = $FFFCF18C;
  ErrorMasterTbRateMasterTbSrcMismatch = $FFFCF18D;
  ErrorSampsPerChanTooBig = $FFFCF18E;
  ErrorFinitePulseTrainNotPossible = $FFFCF18F;
  ErrorExtMasterTimebaseRateNotSpecified = $FFFCF190;
  ErrorExtSampClkSrcNotSpecified = $FFFCF191;
  ErrorInputSignalSlowerThanMeasTime = $FFFCF192;
  ErrorCannotUpdatePulseGenProperty = $FFFCF193;
  ErrorInvalidTimingType = $FFFCF194;
  ErrorPropertyUnavailWhenUsingOnboardMemory = $FFFCF197;
  ErrorCannotWriteAfterStartWithOnboardMemory = $FFFCF199;
  ErrorNotEnoughSampsWrittenForInitialXferRqstCondition = $FFFCF19A;
  ErrorNoMoreSpace = $FFFCF19B;
  ErrorSamplesCanNotYetBeWritten = $FFFCF19C;
  ErrorGenStoppedToPreventIntermediateBufferRegenOfOldSamples = $FFFCF19D;
  ErrorGenStoppedToPreventRegenOfOldSamples = $FFFCF19E;
  ErrorSamplesNoLongerWriteable = $FFFCF19F;
  ErrorSamplesWillNeverBeGenerated = $FFFCF1A0;
  ErrorNegativeWriteSampleNumber = $FFFCF1A1;
  ErrorNoAcqStarted = $FFFCF1A2;
  ErrorSamplesNotYetAvailable = $FFFCF1A4;
  ErrorAcqStoppedToPreventIntermediateBufferOverflow = $FFFCF1A5;
  ErrorNoRefTrigConfigured = $FFFCF1A6;
  ErrorCannotReadRelativeToRefTrigUntilDone = $FFFCF1A7;
  ErrorSamplesNoLongerAvailable = $FFFCF1A9;
  ErrorSamplesWillNeverBeAvailable = $FFFCF1AA;
  ErrorNegativeReadSampleNumber = $FFFCF1AB;
  ErrorExternalSampClkAndRefClkThruSameTerm = $FFFCF1AC;
  ErrorExtSampClkRateTooLowForClkIn = $FFFCF1AD;
  ErrorExtSampClkRateTooHighForBackplane = $FFFCF1AE;
  ErrorSampClkRateAndDivCombo = $FFFCF1AF;
  ErrorSampClkRateTooLowForDivDown = $FFFCF1B0;
  ErrorProductOfAOMinAndGainTooSmall = $FFFCF1B1;
  ErrorInterpolationRateNotPossible = $FFFCF1B2;
  ErrorOffsetTooLarge = $FFFCF1B3;
  ErrorOffsetTooSmall = $FFFCF1B4;
  ErrorProductOfAOMaxAndGainTooLarge = $FFFCF1B5;
  ErrorMinAndMaxNotSymmetric = $FFFCF1B6;
  ErrorInvalidAnalogTrigSrc = $FFFCF1B7;
  ErrorTooManyChansForAnalogRefTrig = $FFFCF1B8;
  ErrorTooManyChansForAnalogPauseTrig = $FFFCF1B9;
  ErrorTrigWhenOnDemandSampTiming = $FFFCF1BA;
  ErrorInconsistentAnalogTrigSettings = $FFFCF1BB;
  ErrorMemMapDataXferModeSampTimingCombo = $FFFCF1BC;
  ErrorInvalidJumperedAttr = $FFFCF1BD;
  ErrorInvalidGainBasedOnMinMax = $FFFCF1BE;
  ErrorInconsistentExcit = $FFFCF1BF;
  ErrorTopologyNotSupportedByCfgTermBlock = $FFFCF1C0;
  ErrorBuiltInTempSensorNotSupported = $FFFCF1C1;
  ErrorInvalidTerm = $FFFCF1C2;
  ErrorCannotTristateTerm = $FFFCF1C3;
  ErrorCannotTristateBusyTerm = $FFFCF1C4;
  ErrorNoDMAChansAvailable = $FFFCF1C5;
  ErrorInvalidWaveformLengthWithinLoopInScript = $FFFCF1C6;
  ErrorInvalidSubsetLengthWithinLoopInScript = $FFFCF1C7;
  ErrorMarkerPosInvalidForLoopInScript = $FFFCF1C8;
  ErrorIntegerExpectedInScript = $FFFCF1C9;
  ErrorPLLBecameUnlocked = $FFFCF1CA;
  ErrorPLLLock = $FFFCF1CB;
  ErrorDDCClkOutDCMBecameUnlocked = $FFFCF1CC;
  ErrorDDCClkOutDCMLock = $FFFCF1CD;
  ErrorClkDoublerDCMBecameUnlocked = $FFFCF1CE;
  ErrorClkDoublerDCMLock = $FFFCF1CF;
  ErrorSampClkDCMBecameUnlocked = $FFFCF1D0;
  ErrorSampClkDCMLock = $FFFCF1D1;
  ErrorSampClkTimebaseDCMBecameUnlocked = $FFFCF1D2;
  ErrorSampClkTimebaseDCMLock = $FFFCF1D3;
  ErrorAttrCannotBeReset = $FFFCF1D4;
  ErrorExplanationNotFound = $FFFCF1D5;
  ErrorWriteBufferTooSmall = $FFFCF1D6;
  ErrorSpecifiedAttrNotValid = $FFFCF1D7;
  ErrorAttrCannotBeRead = $FFFCF1D8;
  ErrorAttrCannotBeSet = $FFFCF1D9;
  ErrorNULLPtrForC_Api = $FFFCF1DA;
  ErrorReadBufferTooSmall = $FFFCF1DB;
  ErrorBufferTooSmallForString = $FFFCF1DC;
  ErrorNoAvailTrigLinesOnDevice = $FFFCF1DD;
  ErrorTrigBusLineNotAvail = $FFFCF1DE;
  ErrorCouldNotReserveRequestedTrigLine = $FFFCF1DF;
  ErrorTrigLineNotFound = $FFFCF1E0;
  ErrorSCXI1126ThreshHystCombination = $FFFCF1E1;
  ErrorAcqStoppedToPreventInputBufferOverwrite = $FFFCF1E2;
  ErrorTimeoutExceeded = $FFFCF1E3;
  ErrorInvalidDeviceID = $FFFCF1E4;
  ErrorInvalidAOChanOrder = $FFFCF1E5;
  ErrorSampleTimingTypeAndDataXferMode = $FFFCF1E6;
  ErrorBufferWithOnDemandSampTiming = $FFFCF1E7;
  ErrorBufferAndDataXferMode = $FFFCF1E8;
  ErrorMemMapAndBuffer = $FFFCF1E9;
  ErrorNoAnalogTrigHW = $FFFCF1EA;
  ErrorTooManyPretrigPlusMinPostTrigSamps = $FFFCF1EB;
  ErrorInconsistentUnitsSpecified = $FFFCF1EC;
  ErrorMultipleRelaysForSingleRelayOp = $FFFCF1ED;
  ErrorMultipleDevIDsPerChassisSpecifiedInList = $FFFCF1EE;
  ErrorDuplicateDevIDInList = $FFFCF1EF;
  ErrorInvalidRangeStatementCharInList = $FFFCF1F0;
  ErrorInvalidDeviceIDInList = $FFFCF1F1;
  ErrorTriggerPolarityConflict = $FFFCF1F2;
  ErrorCannotScanWithCurrentTopology = $FFFCF1F3;
  ErrorUnexpectedIdentifierInFullySpecifiedPathInList = $FFFCF1F4;
  ErrorSwitchCannotDriveMultipleTrigLines = $FFFCF1F5;
  ErrorInvalidRelayName = $FFFCF1F6;
  ErrorSwitchScanlistTooBig = $FFFCF1F7;
  ErrorSwitchChanInUse = $FFFCF1F8;
  ErrorSwitchNotResetBeforeScan = $FFFCF1F9;
  ErrorInvalidTopology = $FFFCF1FA;
  ErrorAttrNotSupported = $FFFCF1FB;
  ErrorUnexpectedEndOfActionsInList = $FFFCF1FC;
  ErrorPowerBudgetExceeded = $FFFCF1FD;
  ErrorHWUnexpectedlyPoweredOffAndOn = $FFFCF1FE;
  ErrorSwitchOperationNotSupported = $FFFCF1FF;
  ErrorOnlyContinuousScanSupported = $FFFCF200;
  ErrorSwitchDifferentTopologyWhenScanning = $FFFCF201;
  ErrorDisconnectPathNotSameAsExistingPath = $FFFCF202;
  ErrorConnectionNotPermittedOnChanReservedForRouting = $FFFCF203;
  ErrorCannotConnectSrcChans = $FFFCF204;
  ErrorCannotConnectChannelToItself = $FFFCF205;
  ErrorChannelNotReservedForRouting = $FFFCF206;
  ErrorCannotConnectChansDirectly = $FFFCF207;
  ErrorChansAlreadyConnected = $FFFCF208;
  ErrorChanDuplicatedInPath = $FFFCF209;
  ErrorNoPathToDisconnect = $FFFCF20A;
  ErrorInvalidSwitchChan = $FFFCF20B;
  ErrorNoPathAvailableBetween2SwitchChans = $FFFCF20C;
  ErrorExplicitConnectionExists = $FFFCF20D;
  ErrorSwitchDifferentSettlingTimeWhenScanning = $FFFCF20E;
  ErrorOperationOnlyPermittedWhileScanning = $FFFCF20F;
  ErrorOperationNotPermittedWhileScanning = $FFFCF210;
  ErrorHardwareNotResponding = $FFFCF211;
  ErrorInvalidSampAndMasterTimebaseRateCombo = $FFFCF213;
  ErrorNonZeroBufferSizeInProgIOXfer = $FFFCF214;
  ErrorVirtualChanNameUsed = $FFFCF215;
  ErrorPhysicalChanDoesNotExist = $FFFCF216;
  ErrorMemMapOnlyForProgIOXfer = $FFFCF217;
  ErrorTooManyChans = $FFFCF218;
  ErrorCannotHaveCJTempWithOtherChans = $FFFCF219;
  ErrorOutputBufferUnderwrite = $FFFCF21A;
  ErrorSensorInvalidCompletionResistance = $FFFCF21D;
  ErrorVoltageExcitIncompatibleWith2WireCfg = $FFFCF21E;
  ErrorIntExcitSrcNotAvailable = $FFFCF21F;
  ErrorCannotCreateChannelAfterTaskVerified = $FFFCF220;
  ErrorLinesReservedForSCXIControl = $FFFCF221;
  ErrorCouldNotReserveLinesForSCXIControl = $FFFCF222;
  ErrorCalibrationFailed = $FFFCF223;
  ErrorReferenceFrequencyInvalid = $FFFCF224;
  ErrorReferenceResistanceInvalid = $FFFCF225;
  ErrorReferenceCurrentInvalid = $FFFCF226;
  ErrorReferenceVoltageInvalid = $FFFCF227;
  ErrorEEPROMDataInvalid = $FFFCF228;
  ErrorCabledModuleNotCapableOfRoutingAI = $FFFCF229;
  ErrorChannelNotAvailableInParallelMode = $FFFCF22A;
  ErrorExternalTimebaseRateNotKnownForDelay = $FFFCF22B;
  ErrorFREQOUTCannotProduceDesiredFrequency = $FFFCF22C;
  ErrorMultipleCounterInputTask = $FFFCF22D;
  ErrorCounterStartPauseTriggerConflict = $FFFCF22E;
  ErrorCounterInputPauseTriggerAndSampleClockInvalid = $FFFCF22F;
  ErrorCounterOutputPauseTriggerInvalid = $FFFCF230;
  ErrorCounterTimebaseRateNotSpecified = $FFFCF231;
  ErrorCounterTimebaseRateNotFound = $FFFCF232;
  ErrorCounterOverflow = $FFFCF233;
  ErrorCounterNoTimebaseEdgesBetweenGates = $FFFCF234;
  ErrorCounterMaxMinRangeFreq = $FFFCF235;
  ErrorCounterMaxMinRangeTime = $FFFCF236;
  ErrorSuitableTimebaseNotFoundTimeCombo = $FFFCF237;
  ErrorSuitableTimebaseNotFoundFrequencyCombo = $FFFCF238;
  ErrorInternalTimebaseSourceDivisorCombo = $FFFCF239;
  ErrorInternalTimebaseSourceRateCombo = $FFFCF23A;
  ErrorInternalTimebaseRateDivisorSourceCombo = $FFFCF23B;
  ErrorExternalTimebaseRateNotknownForRate = $FFFCF23C;
  ErrorAnalogTrigChanNotFirstInScanList = $FFFCF23D;
  ErrorNoDivisorForExternalSignal = $FFFCF23E;
  ErrorAttributeInconsistentAcrossRepeatedPhysicalChannels = $FFFCF240;
  ErrorCannotHandshakeWithPort0 = $FFFCF241;
  ErrorControlLineConflictOnPortC = $FFFCF242;
  ErrorLines4To7ConfiguredForOutput = $FFFCF243;
  ErrorLines4To7ConfiguredForInput = $FFFCF244;
  ErrorLines0To3ConfiguredForOutput = $FFFCF245;
  ErrorLines0To3ConfiguredForInput = $FFFCF246;
  ErrorPortConfiguredForOutput = $FFFCF247;
  ErrorPortConfiguredForInput = $FFFCF248;
  ErrorPortConfiguredForStaticDigitalOps = $FFFCF249;
  ErrorPortReservedForHandshaking = $FFFCF24A;
  ErrorPortDoesNotSupportHandshakingDataIO = $FFFCF24B;
  ErrorCannotTristate8255OutputLines = $FFFCF24C;
  ErrorTemperatureOutOfRangeForCalibration = $FFFCF24F;
  ErrorCalibrationHandleInvalid = $FFFCF250;
  ErrorPasswordRequired = $FFFCF251;
  ErrorIncorrectPassword = $FFFCF252;
  ErrorPasswordTooLong = $FFFCF253;
  ErrorCalibrationSessionAlreadyOpen = $FFFCF254;
  ErrorSCXIModuleIncorrect = $FFFCF255;
  ErrorAttributeInconsistentAcrossChannelsOnDevice = $FFFCF256;
  ErrorSCXI1122ResistanceChanNotSupportedForCfg = $FFFCF257;
  ErrorBracketPairingMismatchInList = $FFFCF258;
  ErrorInconsistentNumSamplesToWrite = $FFFCF259;
  ErrorIncorrectDigitalPattern = $FFFCF25A;
  ErrorIncorrectNumChannelsToWrite = $FFFCF25B;
  ErrorIncorrectReadFunction = $FFFCF25C;
  ErrorPhysicalChannelNotSpecified = $FFFCF25D;
  ErrorMoreThanOneTerminal = $FFFCF25E;
  ErrorMoreThanOneActiveChannelSpecified = $FFFCF25F;
  ErrorInvalidNumberSamplesToRead = $FFFCF260;
  ErrorAnalogWaveformExpected = $FFFCF261;
  ErrorDigitalWaveformExpected = $FFFCF262;
  ErrorActiveChannelNotSpecified = $FFFCF263;
  ErrorFunctionNotSupportedForDeviceTasks = $FFFCF264;
  ErrorFunctionNotInLibrary = $FFFCF265;
  ErrorLibraryNotPresent = $FFFCF266;
  ErrorDuplicateTask = $FFFCF267;
  ErrorInvalidTask = $FFFCF268;
  ErrorInvalidChannel = $FFFCF269;
  ErrorInvalidSyntaxForPhysicalChannelRange = $FFFCF26A;
  ErrorMinNotLessThanMax = $FFFCF26E;
  ErrorSampleRateNumChansConvertPeriodCombo = $FFFCF26F;
  ErrorAODuringCounter1DMAConflict = $FFFCF271;
  ErrorAIDuringCounter0DMAConflict = $FFFCF272;
  ErrorInvalidAttributeValue = $FFFCF273;
  ErrorSuppliedCurrentDataOutsideSpecifiedRange = $FFFCF274;
  ErrorSuppliedVoltageDataOutsideSpecifiedRange = $FFFCF275;
  ErrorCannotStoreCalConst = $FFFCF276;
  ErrorSCXIModuleNotFound = $FFFCF277;
  ErrorDuplicatePhysicalChansNotSupported = $FFFCF278;
  ErrorTooManyPhysicalChansInList = $FFFCF279;
  ErrorInvalidAdvanceEventTriggerType = $FFFCF27A;
  ErrorDeviceIsNotAValidSwitch = $FFFCF27B;
  ErrorDeviceDoesNotSupportScanning = $FFFCF27C;
  ErrorScanListCannotBeTimed = $FFFCF27D;
  ErrorConnectOperatorInvalidAtPointInList = $FFFCF27E;
  ErrorUnexpectedSwitchActionInList = $FFFCF27F;
  ErrorUnexpectedSeparatorInList = $FFFCF280;
  ErrorExpectedTerminatorInList = $FFFCF281;
  ErrorExpectedConnectOperatorInList = $FFFCF282;
  ErrorExpectedSeparatorInList = $FFFCF283;
  ErrorFullySpecifiedPathInListContainsRange = $FFFCF284;
  ErrorConnectionSeparatorAtEndOfList = $FFFCF285;
  ErrorIdentifierInListTooLong = $FFFCF286;
  ErrorDuplicateDeviceIDInListWhenSettling = $FFFCF287;
  ErrorChannelNameNotSpecifiedInList = $FFFCF288;
  ErrorDeviceIDNotSpecifiedInList = $FFFCF289;
  ErrorSemicolonDoesNotFollowRangeInList = $FFFCF28A;
  ErrorSwitchActionInListSpansMultipleDevices = $FFFCF28B;
  ErrorRangeWithoutAConnectActionInList = $FFFCF28C;
  ErrorInvalidIdentifierFollowingSeparatorInList = $FFFCF28D;
  ErrorInvalidChannelNameInList = $FFFCF28E;
  ErrorInvalidNumberInRepeatStatementInList = $FFFCF28F;
  ErrorInvalidTriggerLineInList = $FFFCF290;
  ErrorInvalidIdentifierInListFollowingDeviceID = $FFFCF291;
  ErrorInvalidIdentifierInListAtEndOfSwitchAction = $FFFCF292;
  ErrorDeviceRemoved = $FFFCF293;
  ErrorRoutingPathNotAvailable = $FFFCF294;
  ErrorRoutingHardwareBusy = $FFFCF295;
  ErrorRequestedSignalInversionForRoutingNotPossible = $FFFCF296;
  ErrorInvalidRoutingDestinationTerminalName = $FFFCF297;
  ErrorInvalidRoutingSourceTerminalName = $FFFCF298;
  ErrorRoutingNotSupportedForDevice = $FFFCF299;
  ErrorWaitIsLastInstructionOfLoopInScript = $FFFCF29A;
  ErrorClearIsLastInstructionOfLoopInScript = $FFFCF29B;
  ErrorInvalidLoopIterationsInScript = $FFFCF29C;
  ErrorRepeatLoopNestingTooDeepInScript = $FFFCF29D;
  ErrorMarkerPositionOutsideSubsetInScript = $FFFCF29E;
  ErrorSubsetStartOffsetNotAlignedInScript = $FFFCF29F;
  ErrorInvalidSubsetLengthInScript = $FFFCF2A0;
  ErrorMarkerPositionNotAlignedInScript = $FFFCF2A1;
  ErrorSubsetOutsideWaveformInScript = $FFFCF2A2;
  ErrorMarkerOutsideWaveformInScript = $FFFCF2A3;
  ErrorWaveformInScriptNotInMem = $FFFCF2A4;
  ErrorKeywordExpectedInScript = $FFFCF2A5;
  ErrorBufferNameExpectedInScript = $FFFCF2A6;
  ErrorProcedureNameExpectedInScript = $FFFCF2A7;
  ErrorScriptHasInvalidIdentifier = $FFFCF2A8;
  ErrorScriptHasInvalidCharacter = $FFFCF2A9;
  ErrorResourceAlreadyReserved = $FFFCF2AA;
  ErrorSelfTestFailed = $FFFCF2AC;
  ErrorADCOverrun = $FFFCF2AD;
  ErrorDACUnderflow = $FFFCF2AE;
  ErrorInputFIFOUnderflow = $FFFCF2AF;
  ErrorOutputFIFOUnderflow = $FFFCF2B0;
  ErrorSCXISerialCommunication = $FFFCF2B1;
  ErrorDigitalTerminalSpecifiedMoreThanOnce = $FFFCF2B2;
  ErrorDigitalOutputNotSupported = $FFFCF2B4;
  ErrorInconsistentChannelDirections = $FFFCF2B5;
  ErrorInputFIFOOverflow = $FFFCF2B6;
  ErrorTimeStampOverwritten = $FFFCF2B7;
  ErrorStopTriggerHasNotOccurred = $FFFCF2B8;
  ErrorRecordNotAvailable = $FFFCF2B9;
  ErrorRecordOverwritten = $FFFCF2BA;
  ErrorDataNotAvailable = $FFFCF2BB;
  ErrorDataOverwrittenInDeviceMemory = $FFFCF2BC;
  ErrorDuplicatedChannel = $FFFCF2BD;
  WarningTimestampCounterRolledOver = $00030D43;
  WarningInputTerminationOverloaded = $00030D44;
  WarningADCOverloaded = $00030D45;
  WarningPLLUnlocked = $00030D47;
  WarningCounter0DMADuringAIConflict = $00030D48;
  WarningCounter1DMADuringAOConflict = $00030D49;
  WarningStoppedBeforeDone = $00030D4A;
  WarningRateViolatesSettlingTime = $00030D4B;
  WarningRateViolatesMaxADCRate = $00030D4C;
  WarningUserDefInfoStringTooLong = $00030D4D;
  WarningTooManyInterruptsPerSecond = $00030D4E;
  WarningPotentialGlitchDuringWrite = $00030D4F;
  WarningDevNotSelfCalibratedWithDAQmx = $00030D50;
  WarningAISampRateTooLow = $00030D51;
  WarningAIConvRateTooLow = $00030D52;
  WarningReadOffsetCoercion = $00030D53;
  WarningPretrigCoercion = $00030D54;
  WarningSampValCoercedToMax = $00030D55;
  WarningSampValCoercedToMin = $00030D56;
  WarningPropertyVersionNew = $00030D58;
  WarningUserDefinedInfoTooLong = $00030D59;
  WarningCAPIStringTruncatedToFitBuffer = $00030D5A;
  WarningSampClkRateTooLow = $00030D5B;
  WarningPossiblyInvalidCTRSampsInFiniteDMAAcq = $00030D5C;
  WarningRISAcqCompletedSomeBinsNotFilled = $00030D5D;
  WarningPXIDevTempExceedsMaxOpTemp = $00030D5E;
  WarningOutputGainTooLowForRFFreq = $00030D5F;
  WarningOutputGainTooHighForRFFreq = $00030D60;
  WarningMultipleWritesBetweenSampClks = $00030D61;
  WarningDeviceMayShutDownDueToHighTemp = $00030D62;
  WarningRateViolatesMinADCRate = $00030D63;
  WarningSampClkRateAboveDevSpecs = $00030D64;
  WarningCOPrevDAQmxWriteSettingsOverwrittenForHWTimedSinglePoint = $00030D65;
  WarningLowpassFilterSettlingTimeExceedsUserTimeBetween2ADCConversions = $00030D66;
  WarningLowpassFilterSettlingTimeExceedsDriverTimeBetween2ADCConversions = $00030D67;
  WarningSampClkRateViolatesSettlingTimeForGen = $00030D68;
  WarningInvalidCalConstValueForAI = $00030D69;
  WarningInvalidCalConstValueForAO = $00030D6A;
  WarningChanCalExpired = $00030D6B;
  WarningUnrecognizedEnumValueEncounteredInStorage = $00030D6C;
  WarningTableCRCNotCorrect = $00030D6D;
  WarningExternalCRCNotCorrect = $00030D6E;
  WarningSelfCalCRCNotCorrect = $00030D6F;
  WarningDeviceSpecExceeded = $00030D70;
  WarningOnlyGainCalibrated = $00030D71;
  WarningReadNotCompleteBeforeSampClk = $00033388;
  WarningWriteNotCompleteBeforeSampClk = $00033389;
  WarningWaitForNextSampClkDetectedMissedSampClk = $0003338A;
  ErrorRoutingDestTermPXIClk10InNotInStarTriggerSlot_Routing = $FFFEA3B6;
  ErrorRoutingDestTermPXIClk10InNotInSystemTimingSlot_Routing = $FFFEA3B7;
  ErrorRoutingDestTermPXIStarXNotInStarTriggerSlot_Routing = $FFFEA3B8;
  ErrorRoutingDestTermPXIStarXNotInSystemTimingSlot_Routing = $FFFEA3B9;
  ErrorRoutingSrcTermPXIStarXNotInStarTriggerSlot_Routing = $FFFEA3BA;
  ErrorRoutingSrcTermPXIStarXNotInSystemTimingSlot_Routing = $FFFEA3BB;
  ErrorRoutingSrcTermPXIStarInNonStarTriggerSlot_Routing = $FFFEA3BC;
  ErrorRoutingDestTermPXIStarInNonStarTriggerSlot_Routing = $FFFEA3BD;
  ErrorRoutingDestTermPXIStarInStarTriggerSlot_Routing = $FFFEA3BE;
  ErrorRoutingDestTermPXIStarInSystemTimingSlot_Routing = $FFFEA3BF;
  ErrorRoutingSrcTermPXIStarInStarTriggerSlot_Routing = $FFFEA3C0;
  ErrorRoutingSrcTermPXIStarInSystemTimingSlot_Routing = $FFFEA3C1;
  ErrorInvalidSignalModifier_Routing = $FFFEA3C2;
  ErrorRoutingDestTermPXIClk10InNotInSlot2_Routing = $FFFEA3C3;
  ErrorRoutingDestTermPXIStarXNotInSlot2_Routing = $FFFEA3C4;
  ErrorRoutingSrcTermPXIStarXNotInSlot2_Routing = $FFFEA3C5;
  ErrorRoutingSrcTermPXIStarInSlot16AndAbove_Routing = $FFFEA3C6;
  ErrorRoutingDestTermPXIStarInSlot16AndAbove_Routing = $FFFEA3C7;
  ErrorRoutingDestTermPXIStarInSlot2_Routing = $FFFEA3C8;
  ErrorRoutingSrcTermPXIStarInSlot2_Routing = $FFFEA3C9;
  ErrorRoutingDestTermPXIChassisNotIdentified_Routing = $FFFEA3CA;
  ErrorRoutingSrcTermPXIChassisNotIdentified_Routing = $FFFEA3CB;
  ErrorTrigLineNotFoundSingleDevRoute_Routing = $FFFEA3CC;
  ErrorNoCommonTrigLineForRoute_Routing = $FFFEA3CD;
  ErrorResourcesInUseForRouteInTask_Routing = $FFFEA3CE;
  ErrorResourcesInUseForRoute_Routing = $FFFEA3CF;
  ErrorRouteNotSupportedByHW_Routing = $FFFEA3D0;
  ErrorResourcesInUseForInversionInTask_Routing = $FFFEA3D1;
  ErrorResourcesInUseForInversion_Routing = $FFFEA3D2;
  ErrorInversionNotSupportedByHW_Routing = $FFFEA3D3;
  ErrorResourcesInUseForProperty_Routing = $FFFEA3D4;
  ErrorRouteSrcAndDestSame_Routing = $FFFEA3D5;
  ErrorDevAbsentOrUnavailable_Routing = $FFFEA3D6;
  ErrorInvalidTerm_Routing = $FFFEA3D7;
  ErrorCannotTristateTerm_Routing = $FFFEA3D8;
  ErrorCannotTristateBusyTerm_Routing = $FFFEA3D9;
  ErrorCouldNotReserveRequestedTrigLine_Routing = $FFFEA3DA;
  ErrorTrigLineNotFound_Routing = $FFFEA3DB;
  ErrorRoutingPathNotAvailable_Routing = $FFFEA3DC;
  ErrorRoutingHardwareBusy_Routing = $FFFEA3DD;
  ErrorRequestedSignalInversionForRoutingNotPossible_Routing = $FFFEA3DE;
  ErrorInvalidRoutingDestinationTerminalName_Routing = $FFFEA3DF;
  ErrorInvalidRoutingSourceTerminalName_Routing = $FFFEA3E0;
  ErrorCouldNotConnectToServer_Routing = $FFFEA4BC;
  ErrorDeviceNameNotFound_Routing = $FFFEA573;
  ErrorLocalRemoteDriverVersionMismatch_Routing = $FFFEA574;
  ErrorDuplicateDeviceName_Routing = $FFFEA575;
  ErrorRuntimeAborting_Routing = $FFFEA57A;
  ErrorRuntimeAborted_Routing = $FFFEA57B;
  ErrorResourceNotInPool_Routing = $FFFEA57C;
  ErrorDriverDeviceGUIDNotFound_Routing = $FFFEA57F;
  ErrorValueInvalid = $FFFF2CF9;
  ErrorValueNotInSet = $FFFF2CFA;
  ErrorValueOutOfRange = $FFFF2CFB;
  ErrorTypeUnknown = $FFFF2CFC;
  ErrorInterconnectBridgeRouteReserved = $FFFF2D04;
  ErrorInterconnectBridgeRouteNotPossible = $FFFF2D05;
  ErrorInterconnectLineReserved = $FFFF2D06;
  ErrorInterconnectBusNotFound = $FFFF2D0E;
  ErrorEndpointNotFound = $FFFF2D0F;
  ErrorResourceNotFound = $FFFF2D10;
  ErrorPALBusResetOccurred = $FFFF3990;
  ErrorPALWaitInterrupted = $FFFF39F4;
  ErrorPALMessageUnderflow = $FFFF3A25;
  ErrorPALMessageOverflow = $FFFF3A26;
  ErrorPALThreadAlreadyDead = $FFFF3A54;
  ErrorPALThreadStackSizeNotSupported = $FFFF3A55;
  ErrorPALThreadControllerIsNotThreadCreator = $FFFF3A56;
  ErrorPALThreadHasNoThreadObject = $FFFF3A57;
  ErrorPALThreadCouldNotRun = $FFFF3A58;
  ErrorPALSyncTimedOut = $FFFF3A8A;
  ErrorPALReceiverSocketInvalid = $FFFF3AB9;
  ErrorPALSocketListenerInvalid = $FFFF3ABA;
  ErrorPALSocketListenerAlreadyRegistered = $FFFF3ABB;
  ErrorPALDispatcherAlreadyExported = $FFFF3ABC;
  ErrorPALDMALinkEventMissed = $FFFF3AEE;
  ErrorPALBusError = $FFFF3B13;
  ErrorPALRetryLimitExceeded = $FFFF3B14;
  ErrorPALTransferOverread = $FFFF3B15;
  ErrorPALTransferOverwritten = $FFFF3B16;
  ErrorPALPhysicalBufferFull = $FFFF3B17;
  ErrorPALPhysicalBufferEmpty = $FFFF3B18;
  ErrorPALLogicalBufferFull = $FFFF3B19;
  ErrorPALLogicalBufferEmpty = $FFFF3B1A;
  ErrorPALTransferAborted = $FFFF3B1B;
  ErrorPALTransferStopped = $FFFF3B1C;
  ErrorPALTransferInProgress = $FFFF3B1D;
  ErrorPALTransferNotInProgress = $FFFF3B1E;
  ErrorPALCommunicationsFault = $FFFF3B1F;
  ErrorPALTransferTimedOut = $FFFF3B20;
  ErrorPALMemoryBlockCheckFailed = $FFFF3B4E;
  ErrorPALMemoryPageLockFailed = $FFFF3B4F;
  ErrorPALMemoryFull = $FFFF3B50;
  ErrorPALMemoryAlignmentFault = $FFFF3B51;
  ErrorPALMemoryConfigurationFault = $FFFF3B52;
  ErrorPALDeviceInitializationFault = $FFFF3B81;
  ErrorPALDeviceNotSupported = $FFFF3B82;
  ErrorPALDeviceUnknown = $FFFF3B83;
  ErrorPALDeviceNotFound = $FFFF3B84;
  ErrorPALFeatureDisabled = $FFFF3BA7;
  ErrorPALComponentBusy = $FFFF3BA8;
  ErrorPALComponentAlreadyInstalled = $FFFF3BA9;
  ErrorPALComponentNotUnloadable = $FFFF3BAA;
  ErrorPALComponentNeverLoaded = $FFFF3BAB;
  ErrorPALComponentAlreadyLoaded = $FFFF3BAC;
  ErrorPALComponentCircularDependency = $FFFF3BAD;
  ErrorPALComponentInitializationFault = $FFFF3BAE;
  ErrorPALComponentImageCorrupt = $FFFF3BAF;
  ErrorPALFeatureNotSupported = $FFFF3BB0;
  ErrorPALFunctionNotFound = $FFFF3BB1;
  ErrorPALFunctionObsolete = $FFFF3BB2;
  ErrorPALComponentTooNew = $FFFF3BB3;
  ErrorPALComponentTooOld = $FFFF3BB4;
  ErrorPALComponentNotFound = $FFFF3BB5;
  ErrorPALVersionMismatch = $FFFF3BB6;
  ErrorPALFileFault = $FFFF3BDF;
  ErrorPALFileWriteFault = $FFFF3BE0;
  ErrorPALFileReadFault = $FFFF3BE1;
  ErrorPALFileSeekFault = $FFFF3BE2;
  ErrorPALFileCloseFault = $FFFF3BE3;
  ErrorPALFileOpenFault = $FFFF3BE4;
  ErrorPALDiskFull = $FFFF3BE5;
  ErrorPALOSFault = $FFFF3BE6;
  ErrorPALOSInitializationFault = $FFFF3BE7;
  ErrorPALOSUnsupported = $FFFF3BE8;
  ErrorPALCalculationOverflow = $FFFF3C01;
  ErrorPALHardwareFault = $FFFF3C18;
  ErrorPALFirmwareFault = $FFFF3C19;
  ErrorPALSoftwareFault = $FFFF3C1A;
  ErrorPALMessageQueueFull = $FFFF3C44;
  ErrorPALResourceAmbiguous = $FFFF3C45;
  ErrorPALResourceBusy = $FFFF3C46;
  ErrorPALResourceInitialized = $FFFF3C47;
  ErrorPALResourceNotInitialized = $FFFF3C48;
  ErrorPALResourceReserved = $FFFF3C49;
  ErrorPALResourceNotReserved = $FFFF3C4A;
  ErrorPALResourceNotAvailable = $FFFF3C4B;
  ErrorPALResourceOwnedBySystem = $FFFF3C4C;
  ErrorPALBadToken = $FFFF3C9C;
  ErrorPALBadThreadMultitask = $FFFF3C9D;
  ErrorPALBadLibrarySpecifier = $FFFF3C9E;
  ErrorPALBadAddressSpace = $FFFF3C9F;
  ErrorPALBadWindowType = $FFFF3CA0;
  ErrorPALBadAddressClass = $FFFF3CA1;
  ErrorPALBadWriteCount = $FFFF3CA2;
  ErrorPALBadWriteOffset = $FFFF3CA3;
  ErrorPALBadWriteMode = $FFFF3CA4;
  ErrorPALBadReadCount = $FFFF3CA5;
  ErrorPALBadReadOffset = $FFFF3CA6;
  ErrorPALBadReadMode = $FFFF3CA7;
  ErrorPALBadCount = $FFFF3CA8;
  ErrorPALBadOffset = $FFFF3CA9;
  ErrorPALBadMode = $FFFF3CAA;
  ErrorPALBadDataSize = $FFFF3CAB;
  ErrorPALBadPointer = $FFFF3CAC;
  ErrorPALBadSelector = $FFFF3CAD;
  ErrorPALBadDevice = $FFFF3CAE;
  ErrorPALIrrelevantAttribute = $FFFF3CAF;
  ErrorPALValueConflict = $FFFF3CB0;
  WarningPALValueConflict = $0000C350;
  WarningPALIrrelevantAttribute = $0000C351;
  WarningPALBadDevice = $0000C352;
  WarningPALBadSelector = $0000C353;
  WarningPALBadPointer = $0000C354;
  WarningPALBadDataSize = $0000C355;
  WarningPALBadMode = $0000C356;
  WarningPALBadOffset = $0000C357;
  WarningPALBadCount = $0000C358;
  WarningPALBadReadMode = $0000C359;
  WarningPALBadReadOffset = $0000C35A;
  WarningPALBadReadCount = $0000C35B;
  WarningPALBadWriteMode = $0000C35C;
  WarningPALBadWriteOffset = $0000C35D;
  WarningPALBadWriteCount = $0000C35E;
  WarningPALBadAddressClass = $0000C35F;
  WarningPALBadWindowType = $0000C360;
  WarningPALBadThreadMultitask = $0000C363;
  WarningPALResourceOwnedBySystem = $0000C3B4;
  WarningPALResourceNotAvailable = $0000C3B5;
  WarningPALResourceNotReserved = $0000C3B6;
  WarningPALResourceReserved = $0000C3B7;
  WarningPALResourceNotInitialized = $0000C3B8;
  WarningPALResourceInitialized = $0000C3B9;
  WarningPALResourceBusy = $0000C3BA;
  WarningPALResourceAmbiguous = $0000C3BB;
  WarningPALFirmwareFault = $0000C3E7;
  WarningPALHardwareFault = $0000C3E8;
  WarningPALOSUnsupported = $0000C418;
  WarningPALOSFault = $0000C41A;
  WarningPALFunctionObsolete = $0000C44E;
  WarningPALFunctionNotFound = $0000C44F;
  WarningPALFeatureNotSupported = $0000C450;
  WarningPALComponentInitializationFault = $0000C452;
  WarningPALComponentAlreadyLoaded = $0000C454;
  WarningPALComponentNotUnloadable = $0000C456;
  WarningPALMemoryAlignmentFault = $0000C4AF;
  WarningPALMemoryHeapNotEmpty = $0000C4B3;
  WarningPALTransferNotInProgress = $0000C4E2;
  WarningPALTransferInProgress = $0000C4E3;
  WarningPALTransferStopped = $0000C4E4;
  WarningPALTransferAborted = $0000C4E5;
  WarningPALLogicalBufferEmpty = $0000C4E6;
  WarningPALLogicalBufferFull = $0000C4E7;
  WarningPALPhysicalBufferEmpty = $0000C4E8;
  WarningPALPhysicalBufferFull = $0000C4E9;
  WarningPALTransferOverwritten = $0000C4EA;
  WarningPALTransferOverread = $0000C4EB;
  WarningPALDispatcherAlreadyExported = $0000C544;
  WarningPALSyncAbandoned = $0000C577;
  WarningValueNotInSet = $0000D306;

type

// *********************************************************************//
// Déclaration de structures, d'unions et d'alias.                        
// *********************************************************************//
  PInteger1 = ^Integer; {*}
  PWordBool1 = ^WordBool; {*}
  PDouble1 = ^Double; {*}
  PSmallint1 = ^Smallint; {*}
  PByte1 = ^Byte; {*}
  PUserType1 = ^DAQmxSwitchPathType; {*}
  PUserType2 = ^DAQmxRelayPos; {*}
  PWideString1 = ^WideString; {*}
  PUserType3 = ^DAQmxDigitalLineState; {*}
  PUserType4 = ^DAQmxPowerUpStates; {*}
  PUserType5 = ^DAQmxPowerUpChannelType; {*}
  PUserType6 = ^DAQmxAIMeasurementType; {*}
  PUserType7 = ^DAQmxVoltageUnits1; {*}
  PUserType8 = ^DAQmxTemperatureUnits1; {*}
  PUserType9 = ^DAQmxThermocoupleType1; {*}
  PUserType10 = ^DAQmxScaleType2; {*}
  PUserType11 = ^DAQmxCJCSource1; {*}
  PUserType12 = ^DAQmxRTDType1; {*}
  PUserType13 = ^DAQmxCurrentUnits1; {*}
  PUserType14 = ^DAQmxStrainUnits1; {*}
  PUserType15 = ^DAQmxStrainGageBridgeType1; {*}
  PUserType16 = ^DAQmxResistanceUnits1; {*}
  PUserType17 = ^DAQmxFrequencyUnits; {*}
  PUserType18 = ^DAQmxLengthUnits2; {*}
  PUserType19 = ^DAQmxLVDTSensitivityUnits1; {*}
  PUserType20 = ^DAQmxAngleUnits1; {*}
  PUserType21 = ^DAQmxRVDTSensitivityUnits1; {*}
  PUserType22 = ^DAQmxSoundPressureUnits1; {*}
  PUserType23 = ^DAQmxAccelUnits2; {*}
  PUserType24 = ^DAQmxAccelSensitivityUnits1; {*}
  PUserType25 = ^DAQmxCoupling1; {*}
  PUserType26 = ^DAQmxInputTermCfg; {*}
  PUserType27 = ^DAQmxResistanceConfiguration; {*}
  PUserType28 = ^DAQmxBridgeConfiguration1; {*}
  PUserType29 = ^DAQmxShuntCalSelect; {*}
  PUserType30 = ^DAQmxCurrentShuntResistorLocation1; {*}
  PUserType31 = ^DAQmxExcitationSource; {*}
  PUserType32 = ^DAQmxExcitationDCorAC; {*}
  PUserType33 = ^DAQmxExcitationVoltageOrCurrent; {*}
  PUserType34 = ^DAQmxACExcitWireMode; {*}
  PUserType35 = ^DAQmxSourceSelection; {*}
  PUserType36 = ^DAQmxResolutionType1; {*}
  PUserType37 = ^DAQmxDataJustification1; {*}
  PUserType38 = ^DAQmxAutoZeroType1; {*}
  PUserType39 = ^DAQmxDataTransferMechanism; {*}
  PUserType40 = ^DAQmxInputDataTransferCondition; {*}
  PUserType41 = ^DAQmxRawDataCompressionType; {*}
  PUserType42 = ^DAQmxAOOutputChannelType; {*}
  PUserType43 = ^DAQmxVoltageUnits2; {*}
  PUserType44 = ^DAQmxAOIdleOutputBehavior; {*}
  PUserType45 = ^DAQmxOutputTermCfg; {*}
  PUserType46 = ^DAQmxOutputDataTransferCondition; {*}
  PUserType47 = ^DAQmxLogicFamily; {*}
  PUserType48 = ^DAQmxSampleClockActiveOrInactiveEdgeSelection; {*}
  PUserType49 = ^DAQmxDigitalDriveType; {*}
  PUserType50 = ^DAQmxCIMeasurementType; {*}
  PUserType51 = ^DAQmxFrequencyUnits3; {*}
  PUserType52 = ^DAQmxEdge1; {*}
  PUserType53 = ^DAQmxCounterFrequencyMethod; {*}
  PUserType54 = ^DAQmxTimeUnits3; {*}
  PUserType55 = ^DAQmxCountDirection1; {*}
  PUserType56 = ^DAQmxAngleUnits2; {*}
  PUserType57 = ^DAQmxLengthUnits3; {*}
  PUserType58 = ^DAQmxEncoderType2; {*}
  PUserType59 = ^DAQmxEncoderZIndexPhase1; {*}
  PUserType60 = ^DAQmxTimeUnits; {*}
  PUserType61 = ^DAQmxGpsSignalType1; {*}
  PUserType62 = ^DAQmxLevel1; {*}
  PUserType63 = ^DAQmxCOOutputType; {*}
  PUserType64 = ^DAQmxTimeUnits2; {*}
  PUserType65 = ^DAQmxFrequencyUnits2; {*}
  PUserType66 = ^DAQmxChannelType; {*}
  PUserType67 = ^DAQmxPolarity2; {*}
  PUserType68 = ^DAQmxExportActions3; {*}
  PUserType69 = ^DAQmxDigitalWidthUnits3; {*}
  PUserType70 = ^DAQmxExportActions2; {*}
  PUserType71 = ^DAQmxExportActions5; {*}
  PUserType72 = ^DAQmxDeassertCondition; {*}
  PUserType73 = ^DAQmxProductCategory; {*}
  PUserType74 = ^DAQmxBusType; {*}
  PUserType75 = ^DAQmxReadRelativeTo; {*}
  PUserType76 = ^DAQmxOverwriteMode1; {*}
  PUserType77 = ^DAQmxWaitMode; {*}
  PUserType78 = ^DAQmxWaitMode3; {*}
  PUserType79 = ^DAQmxWaitMode4; {*}
  PUserType80 = ^DAQmxSwitchUsageTypes; {*}
  PUserType81 = ^DAQmxBreakMode; {*}
  PUserType82 = ^DAQmxSwitchScanRepeatMode; {*}
  PUserType83 = ^DAQmxUnitsPreScaled; {*}
  PUserType84 = ^DAQmxScaleType; {*}
  PUserType85 = ^DAQmxAcquisitionType; {*}
  PUserType86 = ^DAQmxSampleTimingType; {*}
  PUserType87 = ^DAQmxUnderflowBehavior; {*}
  PUserType88 = ^DAQmxHandshakeStartCondition; {*}
  PUserType89 = ^DAQmxSampleInputDataWhen; {*}
  PUserType90 = ^DAQmxMIOAIConvertTbSrc; {*}
  PUserType91 = ^DAQmxDigitalWidthUnits2; {*}
  PUserType92 = ^DAQmxTriggerType8; {*}
  PUserType93 = ^DAQmxDigitalPatternCondition1; {*}
  PUserType94 = ^DAQmxSlope1; {*}
  PUserType95 = ^DAQmxCoupling2; {*}
  PUserType96 = ^DAQmxWindowTriggerCondition1; {*}
  PUserType97 = ^DAQmxDigitalWidthUnits1; {*}
  PUserType98 = ^DAQmxTriggerType5; {*}
  PUserType99 = ^DAQmxTriggerType9; {*}
  PUserType100 = ^DAQmxTriggerType6; {*}
  PUserType101 = ^DAQmxActiveLevel; {*}
  PUserType102 = ^DAQmxWindowTriggerCondition2; {*}
  PUserType103 = ^DAQmxTriggerType4; {*}
  PUserType104 = ^DAQmxWriteRelativeTo; {*}
  PUserType105 = ^DAQmxRegenerationMode1; {*}
  PUserType106 = ^DAQmxWaitMode2; {*}
  PUserType107 = ^DAQmxTimingResponseMode; {*}

  ErrorCodes = __MIDL___MIDL_itf_NIDAQmx_0000_0001;

var
  DAQmxLoadTask: function(taskName:Pansichar; taskHandle:PLongint):Longint; stdcall;
  DAQmxCreateTask: function(taskName:Pansichar; taskHandle:PLongint):Longint; stdcall;
  DAQmxAddGlobalChansToTask: function(taskHandle:Longint; channelNames:Pansichar):Longint; stdcall;
  DAQmxStartTask: function(taskHandle:Longint):Longint; stdcall;
  DAQmxStopTask: function(taskHandle:Longint):Longint; stdcall;
  DAQmxClearTask: function(taskHandle:Longint):Longint; stdcall;
  DAQmxWaitUntilTaskDone: function(taskHandle:Longint; timeToWait:Double):Longint; stdcall;
  DAQmxIsTaskDone: function(taskHandle:Longint; isTaskDone:PBOOL):Longint; stdcall;
  DAQmxWaitForNextSampleClock: function(taskHandle:Longint; timeout:Double; isLate:PBOOL):Longint; stdcall;
  DAQmxTaskControl: function(taskHandle:Longint; action:DAQmxTaskMode):Longint; stdcall;
  DAQmxGetNthTaskChannel: function(taskHandle:Longint; index:Longint; buffer:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetNthTaskDevice: function(taskHandle:Longint; index:Longint; buffer:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxRegisterEveryNSamplesEvent: function(taskHandle:Longint; everyNsamplesEventType:DAQmxEveryNSamplesEventType; nSamples:Longint; options:Longint; callbackFunction:Longint; callbackData:Pointer):Longint; stdcall;
  DAQmxRegisterDoneEvent: function(taskHandle:Longint; options:Longint; callbackFunction:Longint; callbackData:Pointer):Longint; stdcall;
  DAQmxRegisterSignalEvent: function(taskHandle:Longint; signalID:DAQmxSignal2; options:Longint; callbackFunction:Longint; callbackData:Pointer):Longint; stdcall;
  DAQmxIsReadOrWriteLate: function(errorCode:Longint):BOOL; stdcall;
  DAQmxCreateAIVoltageChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxVoltageUnits2; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAICurrentChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxCurrentUnits2; shuntResistorLoc:DAQmxCurrentShuntResistorLocation1; extShuntResistorVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIThrmcplChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; thermocoupleType:DAQmxThermocoupleType1; cjcSource:DAQmxCJCSource1; cjcVal:Double; cjcChannel:Pansichar):Longint; stdcall;
  DAQmxCreateAIRTDChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; rtdType:DAQmxRTDType1; resistanceConfig:DAQmxResistanceConfiguration; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; r0:Double):Longint; stdcall;
  DAQmxCreateAIThrmstrChanIex: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; resistanceConfig:DAQmxResistanceConfiguration; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; a:Double; b:Double; c:Double):Longint; stdcall;
  DAQmxCreateAIThrmstrChanVex: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; resistanceConfig:DAQmxResistanceConfiguration; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; a:Double; b:Double; c:Double; r1:Double):Longint; stdcall;
  DAQmxCreateAIFreqVoltageChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxFrequencyUnits; thresholdLevel:Double; hysteresis:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIResistanceChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxResistanceUnits2; resistanceConfig:DAQmxResistanceConfiguration; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIStrainGageChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxStrainUnits1; strainConfig:DAQmxStrainGageBridgeType1; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; gageFactor:Double; initialBridgeVoltage:Double; nominalGageResistance:Double; poissonRatio:Double; leadWireResistance:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIVoltageChanWithExcit: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxVoltageUnits2; bridgeConfig:DAQmxBridgeConfiguration1; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; useExcitForScaling:BOOL; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAITempBuiltInSensorChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; units:DAQmxTemperatureUnits):Longint; stdcall;
  DAQmxCreateAIAccelChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxAccelUnits2; sensitivity:Double; sensitivityUnits:DAQmxAccelSensitivityUnits1; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIMicrophoneChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; units:DAQmxSoundPressureUnits1; micSensitivity:Double; maxSndPressLevel:Double; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIPosLVDTChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxLengthUnits2; sensitivity:Double; sensitivityUnits:DAQmxLVDTSensitivityUnits1; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:DAQmxACExcitWireMode; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIPosRVDTChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxAngleUnits1; sensitivity:Double; sensitivityUnits:DAQmxRVDTSensitivityUnits1; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:DAQmxACExcitWireMode; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIDeviceTempChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; units:DAQmxTemperatureUnits):Longint; stdcall;
  DAQmxCreateTEDSAIVoltageChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxTEDSUnits; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAICurrentChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxTEDSUnits; shuntResistorLoc:DAQmxCurrentShuntResistorLocation1; extShuntResistorVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIThrmcplChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; cjcSource:DAQmxCJCSource1; cjcVal:Double; cjcChannel:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIRTDChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; resistanceConfig:DAQmxResistanceConfiguration; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double):Longint; stdcall;
  DAQmxCreateTEDSAIThrmstrChanIex: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; resistanceConfig:DAQmxResistanceConfiguration; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double):Longint; stdcall;
  DAQmxCreateTEDSAIThrmstrChanVex: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTemperatureUnits; resistanceConfig:DAQmxResistanceConfiguration; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; r1:Double):Longint; stdcall;
  DAQmxCreateTEDSAIResistanceChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTEDSUnits; resistanceConfig:DAQmxResistanceConfiguration; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIStrainGageChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxStrainUnits1; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; initialBridgeVoltage:Double; leadWireResistance:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIVoltageChanWithExcit: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxTEDSUnits; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIAccelChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; minVal:Double; maxVal:Double; units:DAQmxAccelUnits2; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIMicrophoneChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:DAQmxInputTermCfg; units:DAQmxSoundPressureUnits1; maxSndPressLevel:Double; currentExcitSource:DAQmxExcitationSource; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIPosLVDTChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxLengthUnits2; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:DAQmxACExcitWireMode; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIPosRVDTChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxAngleUnits1; voltageExcitSource:DAQmxExcitationSource; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:DAQmxACExcitWireMode; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAOVoltageChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxVoltageUnits2; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAOCurrentChan: function(taskHandle:Longint; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxCurrentUnits2; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateDIChan: function(taskHandle:Longint; lines:Pansichar; nameToAssignToLines:Pansichar; lineGrouping:DAQmxLineGrouping):Longint; stdcall;
  DAQmxCreateDOChan: function(taskHandle:Longint; lines:Pansichar; nameToAssignToLines:Pansichar; lineGrouping:DAQmxLineGrouping):Longint; stdcall;
  DAQmxCreateCIFreqChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxFrequencyUnits3; edge:DAQmxEdge1; measMethod:DAQmxCounterFrequencyMethod; measTime:Double; divisor:Longint; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCIPeriodChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTimeUnits3; edge:DAQmxEdge1; measMethod:DAQmxCounterFrequencyMethod; measTime:Double; divisor:Longint; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCICountEdgesChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; edge:DAQmxEdge1; initialCount:Longint; countDirection:DAQmxCountDirection1):Longint; stdcall;
  DAQmxCreateCIPulseWidthChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTimeUnits3; startingEdge:DAQmxEdge1; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCISemiPeriodChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTimeUnits3; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCITwoEdgeSepChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:DAQmxTimeUnits3; firstEdge:DAQmxEdge1; secondEdge:DAQmxEdge1; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCILinEncoderChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; decodingType:DAQmxEncoderType2; ZidxEnable:BOOL; ZidxVal:Double; ZidxPhase:DAQmxEncoderZIndexPhase1; units:DAQmxLengthUnits3; distPerPulse:Double; initialPos:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCIAngEncoderChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; decodingType:DAQmxEncoderType2; ZidxEnable:BOOL; ZidxVal:Double; ZidxPhase:DAQmxEncoderZIndexPhase1; units:DAQmxAngleUnits2; pulsesPerRev:Longint; initialAngle:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCIGPSTimestampChan: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; units:DAQmxTimeUnits; syncMethod:DAQmxGpsSignalType1; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCOPulseChanFreq: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; units:DAQmxFrequencyUnits2; idleState:DAQmxLevel1; initialDelay:Double; freq:Double; dutyCycle:Double):Longint; stdcall;
  DAQmxCreateCOPulseChanTime: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; units:DAQmxTimeUnits2; idleState:DAQmxLevel1; initialDelay:Double; lowTime:Double; highTime:Double):Longint; stdcall;
  DAQmxCreateCOPulseChanTicks: function(taskHandle:Longint; counter:Pansichar; nameToAssignToChannel:Pansichar; sourceTerminal:Pansichar; idleState:DAQmxLevel1; initialDelay:Longint; lowTicks:Longint; highTicks:Longint):Longint; stdcall;
  DAQmxGetAIChanCalCalDate: function(taskHandle:Longint; channelName:Pansichar; year:PLongint; month:PLongint; day:PLongint; hour:PLongint; minute:PLongint):Longint; stdcall;
  DAQmxSetAIChanCalCalDate: function(taskHandle:Longint; channelName:Pansichar; year:Longint; month:Longint; day:Longint; hour:Longint; minute:Longint):Longint; stdcall;
  DAQmxGetAIChanCalExpDate: function(taskHandle:Longint; channelName:Pansichar; year:PLongint; month:PLongint; day:PLongint; hour:PLongint; minute:PLongint):Longint; stdcall;
  DAQmxSetAIChanCalExpDate: function(taskHandle:Longint; channelName:Pansichar; year:Longint; month:Longint; day:Longint; hour:Longint; minute:Longint):Longint; stdcall;
  DAQmxCfgSampClkTiming: function(taskHandle:Longint; source:Pansichar; rate:Double; activeEdge:DAQmxEdge; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint):Longint; stdcall;
  DAQmxCfgHandshakingTiming: function(taskHandle:Longint; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint):Longint; stdcall;
  DAQmxCfgBurstHandshakingTimingImportClock: function(taskHandle:Longint; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint; sampleClkRate:Double; sampleClkSrc:Pansichar; sampleClkActiveEdge:DAQmxEdge1; pauseWhen:DAQmxLevel1; readyEventActiveLevel:DAQmxPolarity2):Longint; stdcall;
  DAQmxCfgBurstHandshakingTimingExportClock: function(taskHandle:Longint; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint; sampleClkRate:Double; sampleClkOutpTerm:Pansichar; sampleClkPulsePolarity:DAQmxPolarity2; pauseWhen:DAQmxLevel1; readyEventActiveLevel:DAQmxPolarity2):Longint; stdcall;
  DAQmxCfgChangeDetectionTiming: function(taskHandle:Longint; risingEdgeChan:Pansichar; fallingEdgeChan:Pansichar; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint):Longint; stdcall;
  DAQmxCfgImplicitTiming: function(taskHandle:Longint; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint):Longint; stdcall;
  DAQmxCfgPipelinedSampClkTiming: function(taskHandle:Longint; source:Pansichar; rate:Double; activeEdge:DAQmxEdge; sampleMode:DAQmxAcquisitionType; sampsPerChan:Longint):Longint; stdcall;
  DAQmxDisableStartTrig: function(taskHandle:Longint):Longint; stdcall;
  DAQmxCfgDigEdgeStartTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerEdge:DAQmxEdge1):Longint; stdcall;
  DAQmxCfgAnlgEdgeStartTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerSlope:DAQmxSlope1; triggerLevel:Double):Longint; stdcall;
  DAQmxCfgAnlgWindowStartTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerWhen:DAQmxWindowTriggerCondition1; windowTop:Double; windowBottom:Double):Longint; stdcall;
  DAQmxCfgDigPatternStartTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerPattern:Pansichar; triggerWhen:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxDisableRefTrig: function(taskHandle:Longint):Longint; stdcall;
  DAQmxCfgDigEdgeRefTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerEdge:DAQmxEdge1; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxCfgAnlgEdgeRefTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerSlope:DAQmxSlope1; triggerLevel:Double; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxCfgAnlgWindowRefTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerWhen:DAQmxWindowTriggerCondition1; windowTop:Double; windowBottom:Double; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxCfgDigPatternRefTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerPattern:Pansichar; triggerWhen:DAQmxDigitalPatternCondition1; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxDisableAdvTrig: function(taskHandle:Longint):Longint; stdcall;
  DAQmxCfgDigEdgeAdvTrig: function(taskHandle:Longint; triggerSource:Pansichar; triggerEdge:DAQmxEdge1):Longint; stdcall;
  DAQmxSendSoftwareTrigger: function(taskHandle:Longint; triggerID:DAQmxSoftwareTrigger):Longint; stdcall;
  DAQmxReadAnalogF64: function(taskHandle:Longint; numSampsPerChan:Longint; timeout:Double; fillMode:DAQmxFillMode; readArray:PDouble; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadAnalogScalarF64: function(taskHandle:Longint; timeout:Double; value:PDouble; reserved:Pointer):Longint; stdcall;
  DAQmxReadBinaryI16: function(taskHandle:Longint; numSampsPerChan:Longint; timeout:Double; fillMode:DAQmxFillMode; readArray:PSmallint; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadBinaryI32: function(taskHandle:Longint; numSampsPerChan:Longint; timeout:Double; fillMode:DAQmxFillMode; readArray:PLongint; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadDigitalLines: function(taskHandle:Longint; numSampsPerChan:Longint; timeout:Double; fillMode:DAQmxFillMode; readArray:PByte; arraySizeInBytes:Longint; sampsPerChanRead:PLongint; numBytesPerSamp:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadCounterF64: function(taskHandle:Longint; numSampsPerChan:Longint; timeout:Double; readArray:PDouble; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadCounterScalarF64: function(taskHandle:Longint; timeout:Double; value:PDouble; reserved:Pointer):Longint; stdcall;
  DAQmxReadRaw: function(taskHandle:Longint; numSampsPerChan:Longint; timeout:Double; readArray:Pointer; arraySizeInBytes:Longint; sampsRead:PLongint; numBytesPerSamp:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxGetNthTaskReadChannel: function(taskHandle:Longint; index:Longint; buffer:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxWriteAnalogF64: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; writeArray:PDouble; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteAnalogScalarF64: function(taskHandle:Longint; autoStart:BOOL; timeout:Double; value:Double; reserved:Pointer):Longint; stdcall;
  DAQmxWriteBinaryI16: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; writeArray:PSmallint; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteBinaryI32: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; writeArray:PLongint; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteDigitalLines: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; writeArray:PByte; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrFreq: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; frequencyArray:PDouble; dutyCycleArray:PDouble; numSampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrFreqScalar: function(taskHandle:Longint; autoStart:BOOL; timeout:Double; frequency:Double; dutyCycle:Double; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTime: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; highTimeArray:PDouble; lowTimeArray:PDouble; numSampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTimeScalar: function(taskHandle:Longint; autoStart:BOOL; timeout:Double; highTime:Double; lowTime:Double; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTicks: function(taskHandle:Longint; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:DAQmxFillMode; highTicksArray:PLongint; lowTicksArray:PLongint; numSampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTicksScalar: function(taskHandle:Longint; autoStart:BOOL; timeout:Double; highTicks:Longint; lowTicks:Longint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteRaw: function(taskHandle:Longint; numSamps:Longint; autoStart:BOOL; timeout:Double; writeArray:Pointer; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxExportSignal: function(taskHandle:Longint; signalID:DAQmxSignal; outputTerminal:Pansichar):Longint; stdcall;
  DAQmxCreateLinScale: function(name:Pansichar; slope:Double; yIntercept:Double; preScaledUnits:DAQmxUnitsPreScaled; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCreateMapScale: function(name:Pansichar; prescaledMin:Double; prescaledMax:Double; scaledMin:Double; scaledMax:Double; preScaledUnits:DAQmxUnitsPreScaled; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCreatePolynomialScale: function(name:Pansichar; forwardCoeffsArray:PDouble; numForwardCoeffsIn:Longint; reverseCoeffsArray:PDouble; numReverseCoeffsIn:Longint; preScaledUnits:DAQmxUnitsPreScaled; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCreateTableScale: function(name:Pansichar; prescaledValsArray:PDouble; numPrescaledValsIn:Longint; scaledValsArray:PDouble; numScaledValsIn:Longint; preScaledUnits:DAQmxUnitsPreScaled; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCalculateReversePolyCoeff: function(forwardCoeffsArray:PDouble; numForwardCoeffsIn:Longint; minValX:Double; maxValX:Double; numPointsToCompute:Longint; reversePolyOrder:Longint; reverseCoeffsArray:PDouble):Longint; stdcall;
  DAQmxCfgInputBuffer: function(taskHandle:Longint; numSampsPerChan:Longint):Longint; stdcall;
  DAQmxCfgOutputBuffer: function(taskHandle:Longint; numSampsPerChan:Longint):Longint; stdcall;
  DAQmxSwitchCreateScanList: function(scanList:Pansichar; taskHandle:PLongint):Longint; stdcall;
  DAQmxSwitchConnect: function(switchChannel1:Pansichar; switchChannel2:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchConnectMulti: function(connectionList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchDisconnect: function(switchChannel1:Pansichar; switchChannel2:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchDisconnectMulti: function(connectionList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchDisconnectAll: function(deviceName:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchSetTopologyAndReset: function(deviceName:Pansichar; newTopology:Pansichar):Longint; stdcall;
  DAQmxSwitchFindPath: function(switchChannel1:Pansichar; switchChannel2:Pansichar; path:Pansichar; pathBufferSize:Longint; var pathStatus:DAQmxSwitchPathType):Longint; stdcall;
  DAQmxSwitchOpenRelays: function(relayList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchCloseRelays: function(relayList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchGetSingleRelayCount: function(relayName:Pansichar; count:PLongint):Longint; stdcall;
  DAQmxSwitchGetMultiRelayCount: function(relayList:Pansichar; countArray:PLongint; countArraySize:Longint; numRelayCountsRead:PLongint):Longint; stdcall;
  DAQmxSwitchGetSingleRelayPos: function(relayName:Pansichar; var relayPos:DAQmxRelayPos):Longint; stdcall;
  DAQmxSwitchGetMultiRelayPos: function(relayList:Pansichar; var relayPosArray:DAQmxRelayPos; relayPosArraySize:Longint; numRelayPossRead:PLongint):Longint; stdcall;
  DAQmxSwitchWaitForSettling: function(deviceName:Pansichar):Longint; stdcall;
  DAQmxConnectTerms: function(sourceTerminal:Pansichar; destinationTerminal:Pansichar; signalModifiers:DAQmxSignalModifiers):Longint; stdcall;
  DAQmxDisconnectTerms: function(sourceTerminal:Pansichar; destinationTerminal:Pansichar):Longint; stdcall;
  DAQmxTristateOutputTerm: function(outputTerminal:Pansichar):Longint; stdcall;
  DAQmxResetDevice: function(deviceName:Pansichar):Longint; stdcall;

 {:  variable ParamCount
  DAQmxCreateWatchdogTimerTask: function(deviceName:Pansichar; taskName:Pansichar; taskHandle:PLongint; timeout:Double; lines:Pansichar; var expStatesArray:DAQmxDigitalLineState; numItems:Longint):Longint; stdcall;

  function DAQmxControlWatchdogTask(taskHandle:Longint; action:DAQmxWDTTaskAction):Longint; stdcall;
 }
  DAQmxSelfCal: function(deviceName:Pansichar):Longint; stdcall;
  DAQmxPerformBridgeOffsetNullingCal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetSelfCalLastDateAndTime: function(deviceName:Pansichar; year:PLongint; month:PLongint; day:PLongint; hour:PLongint; minute:PLongint):Longint; stdcall;
  DAQmxGetExtCalLastDateAndTime: function(deviceName:Pansichar; year:PLongint; month:PLongint; day:PLongint; hour:PLongint; minute:PLongint):Longint; stdcall;
  DAQmxRestoreLastExtCalConst: function(deviceName:Pansichar):Longint; stdcall;
  DAQmxESeriesCalAdjust: function(calHandle:Longint; referenceVoltage:Double):Longint; stdcall;
  DAQmxMSeriesCalAdjust: function(calHandle:Longint; referenceVoltage:Double):Longint; stdcall;
  DAQmxSSeriesCalAdjust: function(calHandle:Longint; referenceVoltage:Double):Longint; stdcall;
  DAQmxSCBaseboardCalAdjust: function(calHandle:Longint; referenceVoltage:Double):Longint; stdcall;
  DAQmxAOSeriesCalAdjust: function(calHandle:Longint; referenceVoltage:Double):Longint; stdcall;
  DAQmxDeviceSupportsCal: function(deviceName:Pansichar; calSupported:PBOOL):Longint; stdcall;
  DAQmxInitExtCal: function(deviceName:Pansichar; password:Pansichar; calHandle:PLongint):Longint; stdcall;
  DAQmxCloseExtCal: function(calHandle:Longint; action:DAQmxAction):Longint; stdcall;
  DAQmxChangeExtCalPassword: function(deviceName:Pansichar; password:Pansichar; newPassword:Pansichar):Longint; stdcall;
  DAQmxAdjustDSAAICal: function(calHandle:Longint; referenceVoltage:Double):Longint; stdcall;
  DAQmxAdjustDSAAOCal: function(calHandle:Longint; channel:Longint; requestedLowVoltage:Double; actualLowVoltage:Double; requestedHighVoltage:Double; actualHighVoltage:Double; gainSetting:Double):Longint; stdcall;
  DAQmxAdjustDSATimebaseCal: function(calHandle:Longint; referenceFrequency:Double):Longint; stdcall;
  DAQmxAdjust4204Cal: function(calHandle:Longint; channelNames:Pansichar; lowPassFreq:Double; trackHoldEnabled:BOOL; inputVal:Double):Longint; stdcall;
  DAQmxAdjust4220Cal: function(calHandle:Longint; channelNames:Pansichar; gain:Double; inputVal:Double):Longint; stdcall;
  DAQmxAdjust4224Cal: function(calHandle:Longint; channelNames:Pansichar; gain:Double; inputVal:Double):Longint; stdcall;
  DAQmxAdjust4225Cal: function(calHandle:Longint; channelNames:Pansichar; gain:Double; inputVal:Double):Longint; stdcall;
  DAQmxSetup1102Cal: function(calHandle:Longint; channelNames:Pansichar; gain:Double):Longint; stdcall;
  DAQmxAdjust1102Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxSetup1104Cal: function(calHandle:Longint; channelName:Pansichar):Longint; stdcall;
  DAQmxAdjust1104Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxSetup1112Cal: function(calHandle:Longint; channelName:Pansichar):Longint; stdcall;
  DAQmxAdjust1112Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxSetup1124Cal: function(calHandle:Longint; channelNames:Pansichar; range:Longint; dacValue:Longint):Longint; stdcall;
  DAQmxAdjust1124Cal: function(calHandle:Longint; measOutput:Double):Longint; stdcall;
  DAQmxSetup1125Cal: function(calHandle:Longint; channelNames:Pansichar; gain:Double):Longint; stdcall;
  DAQmxAdjust1125Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxSetup1502Cal: function(calHandle:Longint; channelName:Pansichar; gain:Double):Longint; stdcall;
  DAQmxAdjust1502Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxSetup1503Cal: function(calHandle:Longint; channelName:Pansichar; gain:Double):Longint; stdcall;
  DAQmxAdjust1503Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxAdjust1503CurrentCal: function(calHandle:Longint; channelName:Pansichar; measCurrent:Double):Longint; stdcall;
  DAQmxSetup1520Cal: function(calHandle:Longint; channelNames:Pansichar; gain:Double):Longint; stdcall;
  DAQmxAdjust1520Cal: function(calHandle:Longint; refVoltage:Double; measOutput:Double):Longint; stdcall;
  DAQmxConfigureTEDS: function(physicalChannel:Pansichar; filePath:Pansichar):Longint; stdcall;
  DAQmxClearTEDS: function(physicalChannel:Pansichar):Longint; stdcall;
  DAQmxWriteToTEDSFromArray: function(physicalChannel:Pansichar; bitStreamArray:PByte; arraySize:Longint; basicTEDSOptions:DAQmxWriteBasicTEDSOptions):Longint; stdcall;
  DAQmxWriteToTEDSFromFile: function(physicalChannel:Pansichar; filePath:Pansichar; basicTEDSOptions:DAQmxWriteBasicTEDSOptions):Longint; stdcall;
  DAQmxSaveTask: function(taskHandle:Longint; saveAs:Pansichar; author:Pansichar; options:DAQmx_Save_Options_Values):Longint; stdcall;
  DAQmxSaveGlobalChan: function(taskHandle:Longint; channelName:Pansichar; saveAs:Pansichar; author:Pansichar; options:DAQmx_Save_Options_Values):Longint; stdcall;
  DAQmxSaveScale: function(scaleName:Pansichar; saveAs:Pansichar; author:Pansichar; options:DAQmx_Save_Options_Values):Longint; stdcall;
  DAQmxDeleteSavedTask: function(taskName:Pansichar):Longint; stdcall;
  DAQmxDeleteSavedGlobalChan: function(channelName:Pansichar):Longint; stdcall;
  DAQmxDeleteSavedScale: function(scaleName:Pansichar):Longint; stdcall;


  { Variable Param Count
  DAQmxSetDigitalPowerUpStates: function(deviceName:Pansichar; channelNamesArray:P<not supported>; var statesArray:DAQmxPowerUpStates; numItems:Longint):Longint; stdcall;

  function DAQmxSetAnalogPowerUpStates(deviceName:Pansichar; channelNamesArray:P<not supported>; statesArray:PDouble; var channelTypesArray:DAQmxPowerUpChannelType; numItems:Longint):Longint; stdcall;

  function DAQmxSetDigitalLogicFamilyPowerUpState(deviceName:Pansichar; logicFamily:DAQmxLogicFamily):Longint; stdcall;
 }
  DAQmxGetErrorString: function(errorCode:Longint; errorString:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetExtendedErrorInfo: function(errorString:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetBufInputBufSize: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetBufInputBufSize: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetBufInputBufSize: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetBufInputOnbrdBufSize: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetBufOutputBufSize: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetBufOutputBufSize: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetBufOutputBufSize: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetBufOutputOnbrdBufSize: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetBufOutputOnbrdBufSize: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetBufOutputOnbrdBufSize: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSelfCalSupported: function(deviceName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetSelfCalLastTemp: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetExtCalRecommendedInterval: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetExtCalLastTemp: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetCalUserDefinedInfo: function(deviceName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCalUserDefinedInfo: function(deviceName:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetCalUserDefinedInfoMaxSize: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCalDevTemp: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAIMax: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIMax: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIMax: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMin: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIMin: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIMin: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICustomScaleName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAICustomScaleName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAICustomScaleName: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMeasType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAIMeasurementType):Longint; stdcall;
  DAQmxGetAIVoltageUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxVoltageUnits1):Longint; stdcall;
  DAQmxSetAIVoltageUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxVoltageUnits1):Longint; stdcall;
  DAQmxResetAIVoltageUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAITempUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTemperatureUnits1):Longint; stdcall;
  DAQmxSetAITempUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTemperatureUnits1):Longint; stdcall;
  DAQmxResetAITempUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxThermocoupleType1):Longint; stdcall;
  DAQmxSetAIThrmcplType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxThermocoupleType1):Longint; stdcall;
  DAQmxResetAIThrmcplType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplScaleType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxScaleType2):Longint; stdcall;
  DAQmxSetAIThrmcplScaleType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxScaleType2):Longint; stdcall;
  DAQmxResetAIThrmcplScaleType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplCJCSrc: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCJCSource1):Longint; stdcall;
  DAQmxGetAIThrmcplCJCVal: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmcplCJCVal: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmcplCJCVal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplCJCChan: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetAIRTDType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxRTDType1):Longint; stdcall;
  DAQmxSetAIRTDType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxRTDType1):Longint; stdcall;
  DAQmxResetAIRTDType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDR0: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDR0: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDR0: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDA: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDA: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDA: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDB: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDB: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDB: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDC: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDC: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDC: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrA: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrA: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrA: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrB: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrB: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrB: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrC: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrC: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrC: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrR1: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrR1: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrR1: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIForceReadFromChan: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIForceReadFromChan: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIForceReadFromChan: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICurrentUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCurrentUnits1):Longint; stdcall;
  DAQmxSetAICurrentUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCurrentUnits1):Longint; stdcall;
  DAQmxResetAICurrentUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxStrainUnits1):Longint; stdcall;
  DAQmxSetAIStrainUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxStrainUnits1):Longint; stdcall;
  DAQmxResetAIStrainUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainGageGageFactor: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIStrainGageGageFactor: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIStrainGageGageFactor: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainGagePoissonRatio: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIStrainGagePoissonRatio: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIStrainGagePoissonRatio: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainGageCfg: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxStrainGageBridgeType1):Longint; stdcall;
  DAQmxSetAIStrainGageCfg: function(taskHandle:Longint; channel:Pansichar; data:DAQmxStrainGageBridgeType1):Longint; stdcall;
  DAQmxResetAIStrainGageCfg: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIResistanceUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxResistanceUnits1):Longint; stdcall;
  DAQmxSetAIResistanceUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxResistanceUnits1):Longint; stdcall;
  DAQmxResetAIResistanceUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIFreqUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxFrequencyUnits):Longint; stdcall;
  DAQmxSetAIFreqUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxFrequencyUnits):Longint; stdcall;
  DAQmxResetAIFreqUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIFreqThreshVoltage: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIFreqThreshVoltage: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIFreqThreshVoltage: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIFreqHyst: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIFreqHyst: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIFreqHyst: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILVDTUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLengthUnits2):Longint; stdcall;
  DAQmxSetAILVDTUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxLengthUnits2):Longint; stdcall;
  DAQmxResetAILVDTUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILVDTSensitivity: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILVDTSensitivity: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILVDTSensitivity: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILVDTSensitivityUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLVDTSensitivityUnits1):Longint; stdcall;
  DAQmxSetAILVDTSensitivityUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxLVDTSensitivityUnits1):Longint; stdcall;
  DAQmxResetAILVDTSensitivityUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRVDTUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAngleUnits1):Longint; stdcall;
  DAQmxSetAIRVDTUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxAngleUnits1):Longint; stdcall;
  DAQmxResetAIRVDTUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRVDTSensitivity: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRVDTSensitivity: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRVDTSensitivity: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRVDTSensitivityUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxRVDTSensitivityUnits1):Longint; stdcall;
  DAQmxSetAIRVDTSensitivityUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxRVDTSensitivityUnits1):Longint; stdcall;
  DAQmxResetAIRVDTSensitivityUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAISoundPressureMaxSoundPressureLvl: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAISoundPressureMaxSoundPressureLvl: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAISoundPressureMaxSoundPressureLvl: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAISoundPressureUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxSoundPressureUnits1):Longint; stdcall;
  DAQmxSetAISoundPressureUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxSoundPressureUnits1):Longint; stdcall;
  DAQmxResetAISoundPressureUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMicrophoneSensitivity: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIMicrophoneSensitivity: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIMicrophoneSensitivity: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAccelUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAccelUnits2):Longint; stdcall;
  DAQmxSetAIAccelUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxAccelUnits2):Longint; stdcall;
  DAQmxResetAIAccelUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAccelSensitivity: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIAccelSensitivity: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIAccelSensitivity: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAccelSensitivityUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAccelSensitivityUnits1):Longint; stdcall;
  DAQmxSetAIAccelSensitivityUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxAccelSensitivityUnits1):Longint; stdcall;
  DAQmxResetAIAccelSensitivityUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIIsTEDS: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetAITEDSUnits: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetAICoupling: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCoupling1):Longint; stdcall;
  DAQmxSetAICoupling: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCoupling1):Longint; stdcall;
  DAQmxResetAICoupling: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIImpedance: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIImpedance: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIImpedance: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAITermCfg: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxInputTermCfg):Longint; stdcall;
  DAQmxSetAITermCfg: function(taskHandle:Longint; channel:Pansichar; data:DAQmxInputTermCfg):Longint; stdcall;
  DAQmxResetAITermCfg: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIInputSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIInputSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIInputSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIResistanceCfg: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxResistanceConfiguration):Longint; stdcall;
  DAQmxSetAIResistanceCfg: function(taskHandle:Longint; channel:Pansichar; data:DAQmxResistanceConfiguration):Longint; stdcall;
  DAQmxResetAIResistanceCfg: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILeadWireResistance: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILeadWireResistance: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILeadWireResistance: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeCfg: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxBridgeConfiguration1):Longint; stdcall;
  DAQmxSetAIBridgeCfg: function(taskHandle:Longint; channel:Pansichar; data:DAQmxBridgeConfiguration1):Longint; stdcall;
  DAQmxResetAIBridgeCfg: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeNomResistance: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIBridgeNomResistance: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIBridgeNomResistance: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeInitialVoltage: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIBridgeInitialVoltage: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIBridgeInitialVoltage: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeShuntCalEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIBridgeShuntCalEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIBridgeShuntCalEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeShuntCalSelect: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxShuntCalSelect):Longint; stdcall;
  DAQmxSetAIBridgeShuntCalSelect: function(taskHandle:Longint; channel:Pansichar; data:DAQmxShuntCalSelect):Longint; stdcall;
  DAQmxResetAIBridgeShuntCalSelect: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeShuntCalGainAdjust: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIBridgeShuntCalGainAdjust: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIBridgeShuntCalGainAdjust: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeBalanceCoarsePot: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIBridgeBalanceCoarsePot: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIBridgeBalanceCoarsePot: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeBalanceFinePot: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIBridgeBalanceFinePot: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIBridgeBalanceFinePot: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICurrentShuntLoc: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCurrentShuntResistorLocation1):Longint; stdcall;
  DAQmxSetAICurrentShuntLoc: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCurrentShuntResistorLocation1):Longint; stdcall;
  DAQmxResetAICurrentShuntLoc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICurrentShuntResistance: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAICurrentShuntResistance: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAICurrentShuntResistance: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitSrc: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxExcitationSource):Longint; stdcall;
  DAQmxSetAIExcitSrc: function(taskHandle:Longint; channel:Pansichar; data:DAQmxExcitationSource):Longint; stdcall;
  DAQmxResetAIExcitSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitVal: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIExcitVal: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIExcitVal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitUseForScaling: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIExcitUseForScaling: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIExcitUseForScaling: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitUseMultiplexed: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIExcitUseMultiplexed: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIExcitUseMultiplexed: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitActualVal: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIExcitActualVal: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIExcitActualVal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitDCorAC: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxExcitationDCorAC):Longint; stdcall;
  DAQmxSetAIExcitDCorAC: function(taskHandle:Longint; channel:Pansichar; data:DAQmxExcitationDCorAC):Longint; stdcall;
  DAQmxResetAIExcitDCorAC: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitVoltageOrCurrent: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxExcitationVoltageOrCurrent):Longint; stdcall;
  DAQmxSetAIExcitVoltageOrCurrent: function(taskHandle:Longint; channel:Pansichar; data:DAQmxExcitationVoltageOrCurrent):Longint; stdcall;
  DAQmxResetAIExcitVoltageOrCurrent: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIACExcitFreq: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIACExcitFreq: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIACExcitFreq: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIACExcitSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIACExcitSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIACExcitSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIACExcitWireMode: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxACExcitWireMode):Longint; stdcall;
  DAQmxSetAIACExcitWireMode: function(taskHandle:Longint; channel:Pansichar; data:DAQmxACExcitWireMode):Longint; stdcall;
  DAQmxResetAIACExcitWireMode: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAtten: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIAtten: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIAtten: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAILowpassEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAILowpassEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassCutoffFreq: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILowpassCutoffFreq: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILowpassCutoffFreq: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapClkSrc: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxSourceSelection):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapClkSrc: function(taskHandle:Longint; channel:Pansichar; data:DAQmxSourceSelection):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapClkSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapExtClkFreq: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapExtClkFreq: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapExtClkFreq: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapExtClkDiv: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapExtClkDiv: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapExtClkDiv: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapOutClkDiv: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapOutClkDiv: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapOutClkDiv: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIResolutionUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxResolutionType1):Longint; stdcall;
  DAQmxGetAIResolution: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAIRawSampSize: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetAIRawSampJustification: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDataJustification1):Longint; stdcall;
  DAQmxGetAIDitherEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIDitherEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIDitherEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalHasValidCalInfo: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetAIChanCalEnableCal: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIChanCalEnableCal: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIChanCalEnableCal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalApplyCalIfExp: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIChanCalApplyCalIfExp: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIChanCalApplyCalIfExp: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalScaleType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxScaleType2):Longint; stdcall;
  DAQmxSetAIChanCalScaleType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxScaleType2):Longint; stdcall;
  DAQmxResetAIChanCalScaleType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalTablePreScaledVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalTablePreScaledVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalTablePreScaledVals: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalTableScaledVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalTableScaledVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalTableScaledVals: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalPolyForwardCoeff: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalPolyForwardCoeff: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalPolyForwardCoeff: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalPolyReverseCoeff: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalPolyReverseCoeff: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalPolyReverseCoeff: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalOperatorName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIChanCalOperatorName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIChanCalOperatorName: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalDesc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIChanCalDesc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIChanCalDesc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalVerifRefVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalVerifRefVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalVerifRefVals: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalVerifAcqVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalVerifAcqVals: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalVerifAcqVals: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRngHigh: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRngHigh: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRngHigh: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRngLow: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRngLow: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRngLow: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIGain: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIGain: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIGain: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAISampAndHoldEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAISampAndHoldEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAISampAndHoldEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAutoZeroMode: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAutoZeroType1):Longint; stdcall;
  DAQmxSetAIAutoZeroMode: function(taskHandle:Longint; channel:Pansichar; data:DAQmxAutoZeroType1):Longint; stdcall;
  DAQmxResetAIAutoZeroMode: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDataXferMech: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxSetAIDataXferMech: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxResetAIDataXferMech: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDataXferReqCond: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxInputDataTransferCondition):Longint; stdcall;
  DAQmxSetAIDataXferReqCond: function(taskHandle:Longint; channel:Pansichar; data:DAQmxInputDataTransferCondition):Longint; stdcall;
  DAQmxResetAIDataXferReqCond: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDataXferCustomThreshold: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIDataXferCustomThreshold: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIDataXferCustomThreshold: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIMemMapEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRawDataCompressionType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxRawDataCompressionType):Longint; stdcall;
  DAQmxSetAIRawDataCompressionType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxRawDataCompressionType):Longint; stdcall;
  DAQmxResetAIRawDataCompressionType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILossyLSBRemovalCompressedSampSize: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAILossyLSBRemovalCompressedSampSize: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAILossyLSBRemovalCompressedSampSize: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDevScalingCoeff: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetAIEnhancedAliasRejectionEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIEnhancedAliasRejectionEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIEnhancedAliasRejectionEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOMax: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOMax: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOMax: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOMin: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOMin: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOMin: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOCustomScaleName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAOCustomScaleName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAOCustomScaleName: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOOutputType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAOOutputChannelType):Longint; stdcall;
  DAQmxGetAOVoltageUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxVoltageUnits2):Longint; stdcall;
  DAQmxSetAOVoltageUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxVoltageUnits2):Longint; stdcall;
  DAQmxResetAOVoltageUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOCurrentUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCurrentUnits1):Longint; stdcall;
  DAQmxSetAOCurrentUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCurrentUnits1):Longint; stdcall;
  DAQmxResetAOCurrentUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOOutputImpedance: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOOutputImpedance: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOOutputImpedance: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOLoadImpedance: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOLoadImpedance: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOLoadImpedance: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOIdleOutputBehavior: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAOIdleOutputBehavior):Longint; stdcall;
  DAQmxSetAOIdleOutputBehavior: function(taskHandle:Longint; channel:Pansichar; data:DAQmxAOIdleOutputBehavior):Longint; stdcall;
  DAQmxResetAOIdleOutputBehavior: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOTermCfg: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxOutputTermCfg):Longint; stdcall;
  DAQmxSetAOTermCfg: function(taskHandle:Longint; channel:Pansichar; data:DAQmxOutputTermCfg):Longint; stdcall;
  DAQmxResetAOTermCfg: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOResolutionUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxResolutionType1):Longint; stdcall;
  DAQmxSetAOResolutionUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxResolutionType1):Longint; stdcall;
  DAQmxResetAOResolutionUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOResolution: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAODACRngHigh: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACRngHigh: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACRngHigh: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRngLow: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACRngLow: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACRngLow: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefConnToGnd: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAODACRefConnToGnd: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAODACRefConnToGnd: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefAllowConnToGnd: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAODACRefAllowConnToGnd: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAODACRefAllowConnToGnd: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefSrc: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxSourceSelection):Longint; stdcall;
  DAQmxSetAODACRefSrc: function(taskHandle:Longint; channel:Pansichar; data:DAQmxSourceSelection):Longint; stdcall;
  DAQmxResetAODACRefSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefExtSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAODACRefExtSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAODACRefExtSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefVal: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACRefVal: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACRefVal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACOffsetSrc: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxSourceSelection):Longint; stdcall;
  DAQmxSetAODACOffsetSrc: function(taskHandle:Longint; channel:Pansichar; data:DAQmxSourceSelection):Longint; stdcall;
  DAQmxResetAODACOffsetSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACOffsetExtSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAODACOffsetExtSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAODACOffsetExtSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACOffsetVal: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACOffsetVal: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACOffsetVal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOReglitchEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOReglitchEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOReglitchEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOGain: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOGain: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOGain: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOUseOnlyOnBrdMem: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOUseOnlyOnBrdMem: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOUseOnlyOnBrdMem: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODataXferMech: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxSetAODataXferMech: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxResetAODataXferMech: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODataXferReqCond: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxOutputDataTransferCondition):Longint; stdcall;
  DAQmxSetAODataXferReqCond: function(taskHandle:Longint; channel:Pansichar; data:DAQmxOutputDataTransferCondition):Longint; stdcall;
  DAQmxResetAODataXferReqCond: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOMemMapEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODevScalingCoeff: function(taskHandle:Longint; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetAOEnhancedImageRejectionEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOEnhancedImageRejectionEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOEnhancedImageRejectionEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIInvertLines: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDIInvertLines: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDIInvertLines: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDINumLines: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDIDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDIDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDIDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetDIDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetDIDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDITristate: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDITristate: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDITristate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDILogicFamily: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLogicFamily):Longint; stdcall;
  DAQmxSetDILogicFamily: function(taskHandle:Longint; channel:Pansichar; data:DAQmxLogicFamily):Longint; stdcall;
  DAQmxResetDILogicFamily: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIDataXferMech: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxSetDIDataXferMech: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxResetDIDataXferMech: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIDataXferReqCond: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxInputDataTransferCondition):Longint; stdcall;
  DAQmxSetDIDataXferReqCond: function(taskHandle:Longint; channel:Pansichar; data:DAQmxInputDataTransferCondition):Longint; stdcall;
  DAQmxResetDIDataXferReqCond: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDIMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDIMemMapEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIAcquireOn: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxSampleClockActiveOrInactiveEdgeSelection):Longint; stdcall;
  DAQmxSetDIAcquireOn: function(taskHandle:Longint; channel:Pansichar; data:DAQmxSampleClockActiveOrInactiveEdgeSelection):Longint; stdcall;
  DAQmxResetDIAcquireOn: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOOutputDriveType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDigitalDriveType):Longint; stdcall;
  DAQmxSetDOOutputDriveType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDigitalDriveType):Longint; stdcall;
  DAQmxResetDOOutputDriveType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOInvertLines: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOInvertLines: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOInvertLines: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDONumLines: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDOTristate: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOTristate: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOTristate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLineStatesStartState: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxSetDOLineStatesStartState: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxResetDOLineStatesStartState: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLineStatesPausedState: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxSetDOLineStatesPausedState: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxResetDOLineStatesPausedState: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLineStatesDoneState: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxSetDOLineStatesDoneState: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxResetDOLineStatesDoneState: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLogicFamily: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLogicFamily):Longint; stdcall;
  DAQmxSetDOLogicFamily: function(taskHandle:Longint; channel:Pansichar; data:DAQmxLogicFamily):Longint; stdcall;
  DAQmxResetDOLogicFamily: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOUseOnlyOnBrdMem: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOUseOnlyOnBrdMem: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOUseOnlyOnBrdMem: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDODataXferMech: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxSetDODataXferMech: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxResetDODataXferMech: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDODataXferReqCond: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxOutputDataTransferCondition):Longint; stdcall;
  DAQmxSetDODataXferReqCond: function(taskHandle:Longint; channel:Pansichar; data:DAQmxOutputDataTransferCondition):Longint; stdcall;
  DAQmxResetDODataXferReqCond: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOMemMapEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOMemMapEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOGenerateOn: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxSampleClockActiveOrInactiveEdgeSelection):Longint; stdcall;
  DAQmxSetDOGenerateOn: function(taskHandle:Longint; channel:Pansichar; data:DAQmxSampleClockActiveOrInactiveEdgeSelection):Longint; stdcall;
  DAQmxResetDOGenerateOn: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIMax: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIMax: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIMax: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIMin: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIMin: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIMin: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICustomScaleName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICustomScaleName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICustomScaleName: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIMeasType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCIMeasurementType):Longint; stdcall;
  DAQmxGetCIFreqUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxFrequencyUnits3):Longint; stdcall;
  DAQmxSetCIFreqUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxFrequencyUnits3):Longint; stdcall;
  DAQmxResetCIFreqUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIFreqTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIFreqTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqStartingEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCIFreqStartingEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCIFreqStartingEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqMeasMeth: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCounterFrequencyMethod):Longint; stdcall;
  DAQmxSetCIFreqMeasMeth: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCounterFrequencyMethod):Longint; stdcall;
  DAQmxResetCIFreqMeasMeth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqMeasTime: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIFreqMeasTime: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIFreqMeasTime: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDiv: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIFreqDiv: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIFreqDiv: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIFreqDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIFreqDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIFreqDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIFreqDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIFreqDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIFreqDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIFreqDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIFreqDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIFreqDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIFreqDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxSetCIPeriodUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxResetCIPeriodUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPeriodTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPeriodTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodStartingEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCIPeriodStartingEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCIPeriodStartingEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodMeasMeth: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCounterFrequencyMethod):Longint; stdcall;
  DAQmxSetCIPeriodMeasMeth: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCounterFrequencyMethod):Longint; stdcall;
  DAQmxResetCIPeriodMeasMeth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodMeasTime: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPeriodMeasTime: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPeriodMeasTime: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDiv: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIPeriodDiv: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIPeriodDiv: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPeriodDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPeriodDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDir: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCountDirection1):Longint; stdcall;
  DAQmxSetCICountEdgesDir: function(taskHandle:Longint; channel:Pansichar; data:DAQmxCountDirection1):Longint; stdcall;
  DAQmxResetCICountEdgesDir: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDirTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesDirTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesDirTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesInitialCnt: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCICountEdgesInitialCnt: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCICountEdgesInitialCnt: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesActiveEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCICountEdgesActiveEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCICountEdgesActiveEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIAngEncoderUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxAngleUnits2):Longint; stdcall;
  DAQmxSetCIAngEncoderUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxAngleUnits2):Longint; stdcall;
  DAQmxResetCIAngEncoderUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIAngEncoderPulsesPerRev: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIAngEncoderPulsesPerRev: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIAngEncoderPulsesPerRev: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIAngEncoderInitialAngle: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIAngEncoderInitialAngle: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIAngEncoderInitialAngle: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCILinEncoderUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLengthUnits3):Longint; stdcall;
  DAQmxSetCILinEncoderUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxLengthUnits3):Longint; stdcall;
  DAQmxResetCILinEncoderUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCILinEncoderDistPerPulse: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCILinEncoderDistPerPulse: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCILinEncoderDistPerPulse: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCILinEncoderInitialPos: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCILinEncoderInitialPos: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCILinEncoderInitialPos: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderDecodingType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEncoderType2):Longint; stdcall;
  DAQmxSetCIEncoderDecodingType: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEncoderType2):Longint; stdcall;
  DAQmxResetCIEncoderDecodingType: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderAInputTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderAInputTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderBInputTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderBInputTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderZInputTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderZInputTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZIndexEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderZIndexEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderZIndexEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZIndexVal: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderZIndexVal: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderZIndexVal: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZIndexPhase: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEncoderZIndexPhase1):Longint; stdcall;
  DAQmxSetCIEncoderZIndexPhase: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEncoderZIndexPhase1):Longint; stdcall;
  DAQmxResetCIEncoderZIndexPhase: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxSetCIPulseWidthUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxResetCIPulseWidthUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPulseWidthTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPulseWidthTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthStartingEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCIPulseWidthStartingEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCIPulseWidthStartingEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPulseWidthDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPulseWidthDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxSetCITwoEdgeSepUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxResetCITwoEdgeSepUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxSetCISemiPeriodUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTimeUnits3):Longint; stdcall;
  DAQmxResetCISemiPeriodUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCISemiPeriodTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCISemiPeriodTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodStartingEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCISemiPeriodStartingEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCISemiPeriodStartingEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCISemiPeriodDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCISemiPeriodDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITimestampUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTimeUnits):Longint; stdcall;
  DAQmxSetCITimestampUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTimeUnits):Longint; stdcall;
  DAQmxResetCITimestampUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITimestampInitialSeconds: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCITimestampInitialSeconds: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCITimestampInitialSeconds: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIGPSSyncMethod: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxGpsSignalType1):Longint; stdcall;
  DAQmxSetCIGPSSyncMethod: function(taskHandle:Longint; channel:Pansichar; data:DAQmxGpsSignalType1):Longint; stdcall;
  DAQmxResetCIGPSSyncMethod: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIGPSSyncSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIGPSSyncSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIGPSSyncSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICtrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICtrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICtrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICtrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseActiveEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCICtrTimebaseActiveEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCICtrTimebaseActiveEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICount: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCIOutputState: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxGetCITCReached: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetCICtrTimebaseMasterTimebaseDiv: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCICtrTimebaseMasterTimebaseDiv: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCICtrTimebaseMasterTimebaseDiv: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIDataXferMech: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxSetCIDataXferMech: function(taskHandle:Longint; channel:Pansichar; data:DAQmxDataTransferMechanism):Longint; stdcall;
  DAQmxResetCIDataXferMech: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCINumPossiblyInvalidSamps: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCIDupCountPrevent: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIDupCountPrevent: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIDupCountPrevent: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPrescaler: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIPrescaler: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIPrescaler: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOOutputType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxCOOutputType):Longint; stdcall;
  DAQmxGetCOPulseIdleState: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxSetCOPulseIdleState: function(taskHandle:Longint; channel:Pansichar; data:DAQmxLevel1):Longint; stdcall;
  DAQmxResetCOPulseIdleState: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCOPulseTerm: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCOPulseTerm: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTimeUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxTimeUnits2):Longint; stdcall;
  DAQmxSetCOPulseTimeUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxTimeUnits2):Longint; stdcall;
  DAQmxResetCOPulseTimeUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseHighTime: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseHighTime: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseHighTime: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseLowTime: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseLowTime: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseLowTime: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTimeInitialDelay: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseTimeInitialDelay: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseTimeInitialDelay: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseDutyCyc: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseDutyCyc: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseDutyCyc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseFreqUnits: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxFrequencyUnits2):Longint; stdcall;
  DAQmxSetCOPulseFreqUnits: function(taskHandle:Longint; channel:Pansichar; data:DAQmxFrequencyUnits2):Longint; stdcall;
  DAQmxResetCOPulseFreqUnits: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseFreq: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseFreq: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseFreq: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseFreqInitialDelay: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseFreqInitialDelay: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseFreqInitialDelay: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseHighTicks: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPulseHighTicks: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPulseHighTicks: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseLowTicks: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPulseLowTicks: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPulseLowTicks: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTicksInitialDelay: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPulseTicksInitialDelay: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPulseTicksInitialDelay: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCOCtrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCOCtrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOCtrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOCtrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseActiveEdge: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetCOCtrTimebaseActiveEdge: function(taskHandle:Longint; channel:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetCOCtrTimebaseActiveEdge: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrMinPulseWidth: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrTimebaseSrc: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrTimebaseRate: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigSyncEnable: function(taskHandle:Longint; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigSyncEnable: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCount: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCOOutputState: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxGetCOAutoIncrCnt: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOAutoIncrCnt: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOAutoIncrCnt: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseMasterTimebaseDiv: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOCtrTimebaseMasterTimebaseDiv: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOCtrTimebaseMasterTimebaseDiv: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseDone: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetCOPrescaler: function(taskHandle:Longint; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPrescaler: function(taskHandle:Longint; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPrescaler: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetCORdyForNewVal: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetChanType: function(taskHandle:Longint; channel:Pansichar; var data:DAQmxChannelType):Longint; stdcall;
  DAQmxGetPhysicalChanName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetPhysicalChanName: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetChanDescr: function(taskHandle:Longint; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetChanDescr: function(taskHandle:Longint; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetChanDescr: function(taskHandle:Longint; channel:Pansichar):Longint; stdcall;
  DAQmxGetChanIsGlobal: function(taskHandle:Longint; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetExportedAIConvClkOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAIConvClkOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAIConvClkOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAIConvClkPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxGetExported10MHzRefClkOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExported10MHzRefClkOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExported10MHzRefClkOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExported20MHzTimebaseOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExported20MHzTimebaseOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExported20MHzTimebaseOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedSampClkOutputBehavior: function(taskHandle:Longint; var data:DAQmxExportActions3):Longint; stdcall;
  DAQmxSetExportedSampClkOutputBehavior: function(taskHandle:Longint; data:DAQmxExportActions3):Longint; stdcall;
  DAQmxResetExportedSampClkOutputBehavior: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedSampClkOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedSampClkOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedSampClkOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedSampClkPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedSampClkPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedSampClkPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedSampClkTimebaseOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedSampClkTimebaseOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedSampClkTimebaseOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedDividedSampClkTimebaseOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedDividedSampClkTimebaseOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedDividedSampClkTimebaseOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvTrigOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAdvTrigOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAdvTrigOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvTrigPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxGetExportedAdvTrigPulseWidthUnits: function(taskHandle:Longint; var data:DAQmxDigitalWidthUnits3):Longint; stdcall;
  DAQmxSetExportedAdvTrigPulseWidthUnits: function(taskHandle:Longint; data:DAQmxDigitalWidthUnits3):Longint; stdcall;
  DAQmxResetExportedAdvTrigPulseWidthUnits: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvTrigPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetExportedAdvTrigPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetExportedAdvTrigPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedPauseTrigOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedPauseTrigOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedPauseTrigOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedPauseTrigLvlActiveLvl: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedPauseTrigLvlActiveLvl: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedPauseTrigLvlActiveLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRefTrigOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedRefTrigOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedRefTrigOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRefTrigPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedRefTrigPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedRefTrigPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedStartTrigOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedStartTrigOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedStartTrigOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedStartTrigPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedStartTrigPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedStartTrigPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventDelay: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventDelay: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventDelay: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAIHoldCmpltEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAIHoldCmpltEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAIHoldCmpltEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedAIHoldCmpltEventPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedAIHoldCmpltEventPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedAIHoldCmpltEventPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedChangeDetectEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedChangeDetectEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedChangeDetectEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedChangeDetectEventPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedChangeDetectEventPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedChangeDetectEventPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedCtrOutEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedCtrOutEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedCtrOutEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedCtrOutEventOutputBehavior: function(taskHandle:Longint; var data:DAQmxExportActions2):Longint; stdcall;
  DAQmxSetExportedCtrOutEventOutputBehavior: function(taskHandle:Longint; data:DAQmxExportActions2):Longint; stdcall;
  DAQmxResetExportedCtrOutEventOutputBehavior: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedCtrOutEventPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedCtrOutEventPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedCtrOutEventPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedCtrOutEventToggleIdleState: function(taskHandle:Longint; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxSetExportedCtrOutEventToggleIdleState: function(taskHandle:Longint; data:DAQmxLevel1):Longint; stdcall;
  DAQmxResetExportedCtrOutEventToggleIdleState: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedHshkEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedHshkEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventOutputBehavior: function(taskHandle:Longint; var data:DAQmxExportActions5):Longint; stdcall;
  DAQmxSetExportedHshkEventOutputBehavior: function(taskHandle:Longint; data:DAQmxExportActions5):Longint; stdcall;
  DAQmxResetExportedHshkEventOutputBehavior: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventDelay: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetExportedHshkEventDelay: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetExportedHshkEventDelay: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventInterlockedAssertedLvl: function(taskHandle:Longint; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxSetExportedHshkEventInterlockedAssertedLvl: function(taskHandle:Longint; data:DAQmxLevel1):Longint; stdcall;
  DAQmxResetExportedHshkEventInterlockedAssertedLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventInterlockedAssertOnStart: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetExportedHshkEventInterlockedAssertOnStart: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetExportedHshkEventInterlockedAssertOnStart: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventInterlockedDeassertDelay: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetExportedHshkEventInterlockedDeassertDelay: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetExportedHshkEventInterlockedDeassertDelay: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventPulsePolarity: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedHshkEventPulsePolarity: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedHshkEventPulsePolarity: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedHshkEventPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetExportedHshkEventPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetExportedHshkEventPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventLvlActiveLvl: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventLvlActiveLvl: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventLvlActiveLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventDeassertCond: function(taskHandle:Longint; var data:DAQmxDeassertCondition):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventDeassertCond: function(taskHandle:Longint; data:DAQmxDeassertCondition):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventDeassertCond: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventDeassertCondCustomThreshold: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventDeassertCondCustomThreshold: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventDeassertCondCustomThreshold: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedDataActiveEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedDataActiveEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedDataActiveEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedDataActiveEventLvlActiveLvl: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedDataActiveEventLvlActiveLvl: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedDataActiveEventLvlActiveLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRdyForStartEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedRdyForStartEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedRdyForStartEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedRdyForStartEventLvlActiveLvl: function(taskHandle:Longint; var data:DAQmxPolarity2):Longint; stdcall;
  DAQmxSetExportedRdyForStartEventLvlActiveLvl: function(taskHandle:Longint; data:DAQmxPolarity2):Longint; stdcall;
  DAQmxResetExportedRdyForStartEventLvlActiveLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedSyncPulseEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedSyncPulseEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedSyncPulseEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetExportedWatchdogExpiredEventOutputTerm: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedWatchdogExpiredEventOutputTerm: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedWatchdogExpiredEventOutputTerm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDevIsSimulated: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevProductCategory: function(device:Pansichar; var data:DAQmxProductCategory):Longint; stdcall;
  DAQmxGetDevProductType: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevProductNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevSerialNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevChassisModuleDevNames: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevAnlgTrigSupported: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevDigTrigSupported: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevAIPhysicalChans: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevAIMaxSingleChanRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevAIMaxMultiChanRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevAIMinRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevAISimultaneousSamplingSupported: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevAITrigUsage: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevAIVoltageRngs: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAIVoltageIntExcitDiscreteVals: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAIVoltageIntExcitRangeVals: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAICurrentRngs: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAICurrentIntExcitDiscreteVals: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAIFreqRngs: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAIGains: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAICouplings: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevAILowpassCutoffFreqDiscreteVals: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAILowpassCutoffFreqRangeVals: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAOPhysicalChans: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevAOSampClkSupported: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevAOMaxRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevAOMinRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevAOTrigUsage: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevAOVoltageRngs: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAOCurrentRngs: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevAOGains: function(device:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetDevDILines: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevDIPorts: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevDIMaxRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevDITrigUsage: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevDOLines: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevDOPorts: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevDOMaxRate: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevDOTrigUsage: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevCIPhysicalChans: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevCITrigUsage: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevCISampClkSupported: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevCIMaxTimebase: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevCOPhysicalChans: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevCOTrigUsage: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevCOMaxTimebase: function(device:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetDevBusType: function(device:Pansichar; var data:DAQmxBusType):Longint; stdcall;
  DAQmxGetDevNumDMAChans: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPCIBusNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPCIDevNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPXIChassisNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPXISlotNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevCompactDAQChassisDevName: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevCompactDAQSlotNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetReadRelativeTo: function(taskHandle:Longint; var data:DAQmxReadRelativeTo):Longint; stdcall;
  DAQmxSetReadRelativeTo: function(taskHandle:Longint; data:DAQmxReadRelativeTo):Longint; stdcall;
  DAQmxResetReadRelativeTo: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadOffset: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetReadOffset: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetReadOffset: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadChannelsToRead: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetReadChannelsToRead: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetReadChannelsToRead: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadReadAllAvailSamp: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetReadReadAllAvailSamp: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetReadReadAllAvailSamp: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadAutoStart: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetReadAutoStart: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetReadAutoStart: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadOverWrite: function(taskHandle:Longint; var data:DAQmxOverwriteMode1):Longint; stdcall;
  DAQmxSetReadOverWrite: function(taskHandle:Longint; data:DAQmxOverwriteMode1):Longint; stdcall;
  DAQmxResetReadOverWrite: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadCurrReadPos: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetReadAvailSampPerChan: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetReadTotalSampPerChanAcquired: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetReadOverloadedChansExist: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxGetReadOverloadedChans: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetReadChangeDetectHasOverflowed: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxGetReadRawDataWidth: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetReadNumChans: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetReadDigitalLinesBytesPerChan: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetReadWaitMode: function(taskHandle:Longint; var data:DAQmxWaitMode):Longint; stdcall;
  DAQmxSetReadWaitMode: function(taskHandle:Longint; data:DAQmxWaitMode):Longint; stdcall;
  DAQmxResetReadWaitMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetReadSleepTime: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetReadSleepTime: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetReadSleepTime: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRealTimeConvLateErrorsToWarnings: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetRealTimeConvLateErrorsToWarnings: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetRealTimeConvLateErrorsToWarnings: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRealTimeNumOfWarmupIters: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetRealTimeNumOfWarmupIters: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetRealTimeNumOfWarmupIters: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRealTimeWaitForNextSampClkWaitMode: function(taskHandle:Longint; var data:DAQmxWaitMode3):Longint; stdcall;
  DAQmxSetRealTimeWaitForNextSampClkWaitMode: function(taskHandle:Longint; data:DAQmxWaitMode3):Longint; stdcall;
  DAQmxResetRealTimeWaitForNextSampClkWaitMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRealTimeReportMissedSamp: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetRealTimeReportMissedSamp: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetRealTimeReportMissedSamp: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRealTimeWriteRecoveryMode: function(taskHandle:Longint; var data:DAQmxWaitMode4):Longint; stdcall;
  DAQmxSetRealTimeWriteRecoveryMode: function(taskHandle:Longint; data:DAQmxWaitMode4):Longint; stdcall;
  DAQmxResetRealTimeWriteRecoveryMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSwitchChanUsage: function(switchChannelName:Pansichar; var data:DAQmxSwitchUsageTypes):Longint; stdcall;
  DAQmxSetSwitchChanUsage: function(switchChannelName:Pansichar; data:DAQmxSwitchUsageTypes):Longint; stdcall;
  DAQmxGetSwitchChanMaxACCarryCurrent: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxACSwitchCurrent: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxACCarryPwr: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxACSwitchPwr: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxDCCarryCurrent: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxDCSwitchCurrent: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxDCCarryPwr: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxDCSwitchPwr: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxACVoltage: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanMaxDCVoltage: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanWireMode: function(switchChannelName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetSwitchChanBandwidth: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchChanImpedance: function(switchChannelName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetSwitchDevSettlingTime: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetSwitchDevSettlingTime: function(deviceName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetSwitchDevAutoConnAnlgBus: function(deviceName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetSwitchDevAutoConnAnlgBus: function(deviceName:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxGetSwitchDevPwrDownLatchRelaysAfterSettling: function(deviceName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetSwitchDevPwrDownLatchRelaysAfterSettling: function(deviceName:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxGetSwitchDevSettled: function(deviceName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetSwitchDevRelayList: function(deviceName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSwitchDevNumRelays: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetSwitchDevSwitchChanList: function(deviceName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSwitchDevNumSwitchChans: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetSwitchDevNumRows: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetSwitchDevNumColumns: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetSwitchDevTopology: function(deviceName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSwitchScanBreakMode: function(taskHandle:Longint; var data:DAQmxBreakMode):Longint; stdcall;
  DAQmxSetSwitchScanBreakMode: function(taskHandle:Longint; data:DAQmxBreakMode):Longint; stdcall;
  DAQmxResetSwitchScanBreakMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSwitchScanRepeatMode: function(taskHandle:Longint; var data:DAQmxSwitchScanRepeatMode):Longint; stdcall;
  DAQmxSetSwitchScanRepeatMode: function(taskHandle:Longint; data:DAQmxSwitchScanRepeatMode):Longint; stdcall;
  DAQmxResetSwitchScanRepeatMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSwitchScanWaitingForAdv: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxGetScaleDescr: function(scaleName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetScaleDescr: function(scaleName:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetScaleScaledUnits: function(scaleName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetScaleScaledUnits: function(scaleName:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetScalePreScaledUnits: function(scaleName:Pansichar; var data:DAQmxUnitsPreScaled):Longint; stdcall;
  DAQmxSetScalePreScaledUnits: function(scaleName:Pansichar; data:DAQmxUnitsPreScaled):Longint; stdcall;
  DAQmxGetScaleType: function(scaleName:Pansichar; var data:DAQmxScaleType):Longint; stdcall;
  DAQmxGetScaleLinSlope: function(scaleName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetScaleLinSlope: function(scaleName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetScaleLinYIntercept: function(scaleName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetScaleLinYIntercept: function(scaleName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetScaleMapScaledMax: function(scaleName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetScaleMapScaledMax: function(scaleName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetScaleMapPreScaledMax: function(scaleName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetScaleMapPreScaledMax: function(scaleName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetScaleMapScaledMin: function(scaleName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetScaleMapScaledMin: function(scaleName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetScaleMapPreScaledMin: function(scaleName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetScaleMapPreScaledMin: function(scaleName:Pansichar; data:Double):Longint; stdcall;
  DAQmxGetScalePolyForwardCoeff: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetScalePolyForwardCoeff: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetScalePolyReverseCoeff: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetScalePolyReverseCoeff: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetScaleTableScaledVals: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetScaleTableScaledVals: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetScaleTablePreScaledVals: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetScaleTablePreScaledVals: function(scaleName:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetSysGlobalChans: function(data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSysScales: function(data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSysTasks: function(data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSysDevNames: function(data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetSysNIDAQMajorVersion: function(data:PLongint):Longint; stdcall;
  DAQmxGetSysNIDAQMinorVersion: function(data:PLongint):Longint; stdcall;
  DAQmxGetTaskName: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetTaskChannels: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetTaskNumChans: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetTaskDevices: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetTaskNumDevices: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetTaskComplete: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxGetSampQuantSampMode: function(taskHandle:Longint; var data:DAQmxAcquisitionType):Longint; stdcall;
  DAQmxSetSampQuantSampMode: function(taskHandle:Longint; data:DAQmxAcquisitionType):Longint; stdcall;
  DAQmxResetSampQuantSampMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampQuantSampPerChan: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetSampQuantSampPerChan: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetSampQuantSampPerChan: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampTimingType: function(taskHandle:Longint; var data:DAQmxSampleTimingType):Longint; stdcall;
  DAQmxSetSampTimingType: function(taskHandle:Longint; data:DAQmxSampleTimingType):Longint; stdcall;
  DAQmxResetSampTimingType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetSampClkRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkMaxRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxGetSampClkSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSampClkSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetSampClkSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkActiveEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetSampClkActiveEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetSampClkActiveEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkUnderflowBehavior: function(taskHandle:Longint; var data:DAQmxUnderflowBehavior):Longint; stdcall;
  DAQmxSetSampClkUnderflowBehavior: function(taskHandle:Longint; data:DAQmxUnderflowBehavior):Longint; stdcall;
  DAQmxResetSampClkUnderflowBehavior: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkTimebaseDiv: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetSampClkTimebaseDiv: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetSampClkTimebaseDiv: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkTimebaseRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkTimebaseRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetSampClkTimebaseRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkTimebaseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSampClkTimebaseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetSampClkTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkTimebaseActiveEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetSampClkTimebaseActiveEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetSampClkTimebaseActiveEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkTimebaseMasterTimebaseDiv: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetSampClkTimebaseMasterTimebaseDiv: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetSampClkTimebaseMasterTimebaseDiv: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkDigFltrEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetSampClkDigFltrEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetSampClkDigFltrEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkDigFltrMinPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkDigFltrMinPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetSampClkDigFltrMinPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSampClkDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetSampClkDigFltrTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkDigFltrTimebaseRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkDigFltrTimebaseRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetSampClkDigFltrTimebaseRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSampClkDigSyncEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetSampClkDigSyncEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetSampClkDigSyncEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetHshkDelayAfterXfer: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetHshkDelayAfterXfer: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetHshkDelayAfterXfer: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetHshkStartCond: function(taskHandle:Longint; var data:DAQmxHandshakeStartCondition):Longint; stdcall;
  DAQmxSetHshkStartCond: function(taskHandle:Longint; data:DAQmxHandshakeStartCondition):Longint; stdcall;
  DAQmxResetHshkStartCond: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetHshkSampleInputDataWhen: function(taskHandle:Longint; var data:DAQmxSampleInputDataWhen):Longint; stdcall;
  DAQmxSetHshkSampleInputDataWhen: function(taskHandle:Longint; data:DAQmxSampleInputDataWhen):Longint; stdcall;
  DAQmxResetHshkSampleInputDataWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetChangeDetectDIRisingEdgePhysicalChans: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetChangeDetectDIRisingEdgePhysicalChans: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetChangeDetectDIRisingEdgePhysicalChans: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetChangeDetectDIFallingEdgePhysicalChans: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetChangeDetectDIFallingEdgePhysicalChans: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetChangeDetectDIFallingEdgePhysicalChans: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetOnDemandSimultaneousAOEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetOnDemandSimultaneousAOEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetOnDemandSimultaneousAOEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAIConvRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAIConvRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAIConvRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAIConvRateEx: function(taskHandle:Longint; deviceNames:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIConvRateEx: function(taskHandle:Longint; deviceNames:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIConvRateEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvMaxRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxGetAIConvMaxRateEx: function(taskHandle:Longint; deviceNames:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAIConvSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIConvSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAIConvSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAIConvSrcEx: function(taskHandle:Longint; deviceNames:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIConvSrcEx: function(taskHandle:Longint; deviceNames:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIConvSrcEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvActiveEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetAIConvActiveEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetAIConvActiveEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAIConvActiveEdgeEx: function(taskHandle:Longint; deviceNames:Pansichar; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetAIConvActiveEdgeEx: function(taskHandle:Longint; deviceNames:Pansichar; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetAIConvActiveEdgeEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvTimebaseDiv: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetAIConvTimebaseDiv: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetAIConvTimebaseDiv: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAIConvTimebaseDivEx: function(taskHandle:Longint; deviceNames:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIConvTimebaseDivEx: function(taskHandle:Longint; deviceNames:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIConvTimebaseDivEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvTimebaseSrc: function(taskHandle:Longint; var data:DAQmxMIOAIConvertTbSrc):Longint; stdcall;
  DAQmxSetAIConvTimebaseSrc: function(taskHandle:Longint; data:DAQmxMIOAIConvertTbSrc):Longint; stdcall;
  DAQmxResetAIConvTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAIConvTimebaseSrcEx: function(taskHandle:Longint; deviceNames:Pansichar; var data:DAQmxMIOAIConvertTbSrc):Longint; stdcall;
  DAQmxSetAIConvTimebaseSrcEx: function(taskHandle:Longint; deviceNames:Pansichar; data:DAQmxMIOAIConvertTbSrc):Longint; stdcall;
  DAQmxResetAIConvTimebaseSrcEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelayUnits: function(taskHandle:Longint; var data:DAQmxDigitalWidthUnits2):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelayUnits: function(taskHandle:Longint; data:DAQmxDigitalWidthUnits2):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelayUnits: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelayUnitsEx: function(taskHandle:Longint; deviceNames:Pansichar; var data:DAQmxDigitalWidthUnits2):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelayUnitsEx: function(taskHandle:Longint; deviceNames:Pansichar; data:DAQmxDigitalWidthUnits2):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelayUnitsEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelay: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelay: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelay: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelayEx: function(taskHandle:Longint; deviceNames:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelayEx: function(taskHandle:Longint; deviceNames:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelayEx: function(taskHandle:Longint; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetMasterTimebaseRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetMasterTimebaseRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetMasterTimebaseRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetMasterTimebaseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetMasterTimebaseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetMasterTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRefClkRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetRefClkRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetRefClkRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRefClkSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetRefClkSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetRefClkSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSyncPulseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSyncPulseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetSyncPulseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetSyncPulseSyncTime: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxGetSyncPulseMinDelayToStart: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetSyncPulseMinDelayToStart: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetSyncPulseMinDelayToStart: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetStartTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType8):Longint; stdcall;
  DAQmxSetStartTrigType: function(taskHandle:Longint; data:DAQmxTriggerType8):Longint; stdcall;
  DAQmxResetStartTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrMinPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrMinPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrMinPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrTimebaseRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrTimebaseRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrTimebaseRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigSyncEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigSyncEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigSyncEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternStartTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternStartTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternStartTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternStartTrigPattern: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternStartTrigPattern: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternStartTrigPattern: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternStartTrigWhen: function(taskHandle:Longint; var data:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxSetDigPatternStartTrigWhen: function(taskHandle:Longint; data:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxResetDigPatternStartTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigSlope: function(taskHandle:Longint; var data:DAQmxSlope1):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigSlope: function(taskHandle:Longint; data:DAQmxSlope1):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigSlope: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigLvl: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigLvl: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigHyst: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigHyst: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigHyst: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigCoupling: function(taskHandle:Longint; var data:DAQmxCoupling2):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigCoupling: function(taskHandle:Longint; data:DAQmxCoupling2):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigCoupling: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigWhen: function(taskHandle:Longint; var data:DAQmxWindowTriggerCondition1):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigWhen: function(taskHandle:Longint; data:DAQmxWindowTriggerCondition1):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigTop: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigTop: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigTop: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigBtm: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigBtm: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigBtm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigCoupling: function(taskHandle:Longint; var data:DAQmxCoupling2):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigCoupling: function(taskHandle:Longint; data:DAQmxCoupling2):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigCoupling: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetStartTrigDelay: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetStartTrigDelay: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetStartTrigDelay: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetStartTrigDelayUnits: function(taskHandle:Longint; var data:DAQmxDigitalWidthUnits1):Longint; stdcall;
  DAQmxSetStartTrigDelayUnits: function(taskHandle:Longint; data:DAQmxDigitalWidthUnits1):Longint; stdcall;
  DAQmxResetStartTrigDelayUnits: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetStartTrigRetriggerable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetStartTrigRetriggerable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetStartTrigRetriggerable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRefTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType8):Longint; stdcall;
  DAQmxSetRefTrigType: function(taskHandle:Longint; data:DAQmxTriggerType8):Longint; stdcall;
  DAQmxResetRefTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetRefTrigPretrigSamples: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetRefTrigPretrigSamples: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetRefTrigPretrigSamples: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeRefTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeRefTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeRefTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeRefTrigEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetDigEdgeRefTrigEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetDigEdgeRefTrigEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternRefTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternRefTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternRefTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternRefTrigPattern: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternRefTrigPattern: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternRefTrigPattern: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternRefTrigWhen: function(taskHandle:Longint; var data:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxSetDigPatternRefTrigWhen: function(taskHandle:Longint; data:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxResetDigPatternRefTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigSlope: function(taskHandle:Longint; var data:DAQmxSlope1):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigSlope: function(taskHandle:Longint; data:DAQmxSlope1):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigSlope: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigLvl: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigLvl: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigHyst: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigHyst: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigHyst: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigCoupling: function(taskHandle:Longint; var data:DAQmxCoupling2):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigCoupling: function(taskHandle:Longint; data:DAQmxCoupling2):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigCoupling: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigWhen: function(taskHandle:Longint; var data:DAQmxWindowTriggerCondition1):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigWhen: function(taskHandle:Longint; data:DAQmxWindowTriggerCondition1):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigTop: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigTop: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigTop: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigBtm: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigBtm: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigBtm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigCoupling: function(taskHandle:Longint; var data:DAQmxCoupling2):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigCoupling: function(taskHandle:Longint; data:DAQmxCoupling2):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigCoupling: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAdvTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType5):Longint; stdcall;
  DAQmxSetAdvTrigType: function(taskHandle:Longint; data:DAQmxTriggerType5):Longint; stdcall;
  DAQmxResetAdvTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeAdvTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeAdvTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeAdvTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeAdvTrigEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetDigEdgeAdvTrigEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetDigEdgeAdvTrigEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeAdvTrigDigFltrEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeAdvTrigDigFltrEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeAdvTrigDigFltrEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetHshkTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType9):Longint; stdcall;
  DAQmxSetHshkTrigType: function(taskHandle:Longint; data:DAQmxTriggerType9):Longint; stdcall;
  DAQmxResetHshkTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetInterlockedHshkTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetInterlockedHshkTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetInterlockedHshkTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetInterlockedHshkTrigAssertedLvl: function(taskHandle:Longint; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxSetInterlockedHshkTrigAssertedLvl: function(taskHandle:Longint; data:DAQmxLevel1):Longint; stdcall;
  DAQmxResetInterlockedHshkTrigAssertedLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetPauseTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType6):Longint; stdcall;
  DAQmxSetPauseTrigType: function(taskHandle:Longint; data:DAQmxTriggerType6):Longint; stdcall;
  DAQmxResetPauseTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigWhen: function(taskHandle:Longint; var data:DAQmxActiveLevel):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigWhen: function(taskHandle:Longint; data:DAQmxActiveLevel):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigLvl: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigLvl: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigLvl: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigHyst: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigHyst: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigHyst: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigCoupling: function(taskHandle:Longint; var data:DAQmxCoupling2):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigCoupling: function(taskHandle:Longint; data:DAQmxCoupling2):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigCoupling: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigWhen: function(taskHandle:Longint; var data:DAQmxWindowTriggerCondition2):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigWhen: function(taskHandle:Longint; data:DAQmxWindowTriggerCondition2):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigTop: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigTop: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigTop: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigBtm: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigBtm: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigBtm: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigCoupling: function(taskHandle:Longint; var data:DAQmxCoupling2):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigCoupling: function(taskHandle:Longint; data:DAQmxCoupling2):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigCoupling: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigWhen: function(taskHandle:Longint; var data:DAQmxLevel1):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigWhen: function(taskHandle:Longint; data:DAQmxLevel1):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrMinPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrMinPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrMinPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrTimebaseRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrTimebaseRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrTimebaseRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigSyncEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigSyncEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigSyncEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternPauseTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternPauseTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternPauseTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternPauseTrigPattern: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternPauseTrigPattern: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternPauseTrigPattern: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigPatternPauseTrigWhen: function(taskHandle:Longint; var data:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxSetDigPatternPauseTrigWhen: function(taskHandle:Longint; data:DAQmxDigitalPatternCondition1):Longint; stdcall;
  DAQmxResetDigPatternPauseTrigWhen: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetArmStartTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType4):Longint; stdcall;
  DAQmxSetArmStartTrigType: function(taskHandle:Longint; data:DAQmxTriggerType4):Longint; stdcall;
  DAQmxResetArmStartTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrMinPulseWidth: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrMinPulseWidth: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrMinPulseWidth: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseRate: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseRate: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseRate: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigSyncEnable: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigSyncEnable: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigSyncEnable: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWatchdogTimeout: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetWatchdogTimeout: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetWatchdogTimeout: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWatchdogExpirTrigType: function(taskHandle:Longint; var data:DAQmxTriggerType4):Longint; stdcall;
  DAQmxSetWatchdogExpirTrigType: function(taskHandle:Longint; data:DAQmxTriggerType4):Longint; stdcall;
  DAQmxResetWatchdogExpirTrigType: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeWatchdogExpirTrigSrc: function(taskHandle:Longint; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeWatchdogExpirTrigSrc: function(taskHandle:Longint; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeWatchdogExpirTrigSrc: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetDigEdgeWatchdogExpirTrigEdge: function(taskHandle:Longint; var data:DAQmxEdge1):Longint; stdcall;
  DAQmxSetDigEdgeWatchdogExpirTrigEdge: function(taskHandle:Longint; data:DAQmxEdge1):Longint; stdcall;
  DAQmxResetDigEdgeWatchdogExpirTrigEdge: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWatchdogDOExpirState: function(taskHandle:Longint; lines:Pansichar; var data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxSetWatchdogDOExpirState: function(taskHandle:Longint; lines:Pansichar; data:DAQmxDigitalLineState):Longint; stdcall;
  DAQmxResetWatchdogDOExpirState: function(taskHandle:Longint; lines:Pansichar):Longint; stdcall;
  DAQmxGetWatchdogHasExpired: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxGetWriteRelativeTo: function(taskHandle:Longint; var data:DAQmxWriteRelativeTo):Longint; stdcall;
  DAQmxSetWriteRelativeTo: function(taskHandle:Longint; data:DAQmxWriteRelativeTo):Longint; stdcall;
  DAQmxResetWriteRelativeTo: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWriteOffset: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxSetWriteOffset: function(taskHandle:Longint; data:Longint):Longint; stdcall;
  DAQmxResetWriteOffset: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWriteRegenMode: function(taskHandle:Longint; var data:DAQmxRegenerationMode1):Longint; stdcall;
  DAQmxSetWriteRegenMode: function(taskHandle:Longint; data:DAQmxRegenerationMode1):Longint; stdcall;
  DAQmxResetWriteRegenMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWriteCurrWritePos: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetWriteSpaceAvail: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetWriteTotalSampPerChanGenerated: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetWriteRawDataWidth: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetWriteNumChans: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetWriteWaitMode: function(taskHandle:Longint; var data:DAQmxWaitMode2):Longint; stdcall;
  DAQmxSetWriteWaitMode: function(taskHandle:Longint; data:DAQmxWaitMode2):Longint; stdcall;
  DAQmxResetWriteWaitMode: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWriteSleepTime: function(taskHandle:Longint; data:PDouble):Longint; stdcall;
  DAQmxSetWriteSleepTime: function(taskHandle:Longint; data:Double):Longint; stdcall;
  DAQmxResetWriteSleepTime: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWriteNextWriteIsLast: function(taskHandle:Longint; data:PBOOL):Longint; stdcall;
  DAQmxSetWriteNextWriteIsLast: function(taskHandle:Longint; data:BOOL):Longint; stdcall;
  DAQmxResetWriteNextWriteIsLast: function(taskHandle:Longint):Longint; stdcall;
  DAQmxGetWriteDigitalLinesBytesPerChan: function(taskHandle:Longint; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanAITermCfgs: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanAOTermCfgs: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanDIPortWidth: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanDISampClkSupported: function(physicalChannel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPhysicalChanDIChangeDetectSupported: function(physicalChannel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPhysicalChanDOPortWidth: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanDOSampClkSupported: function(physicalChannel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSMfgID: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSModelNum: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSSerialNum: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSVersionNum: function(physicalChannel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSVersionLetter: function(physicalChannel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSBitStream: function(physicalChannel:Pansichar; data:PByte; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetPhysicalChanTEDSTemplateIDs: function(physicalChannel:Pansichar; data:PLongint; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetPersistedTaskAuthor: function(taskName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetPersistedTaskAllowInteractiveEditing: function(taskName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPersistedTaskAllowInteractiveDeletion: function(taskName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPersistedChanAuthor: function(channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetPersistedChanAllowInteractiveEditing: function(channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPersistedChanAllowInteractiveDeletion: function(channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPersistedScaleAuthor: function(scaleName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetPersistedScaleAllowInteractiveEditing: function(scaleName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetPersistedScaleAllowInteractiveDeletion: function(scaleName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetSampClkTimingResponseMode: function(taskHandle:Longint; var data:DAQmxTimingResponseMode):Longint; stdcall;
  DAQmxSetSampClkTimingResponseMode: function(taskHandle:Longint; data:DAQmxTimingResponseMode):Longint; stdcall;
  DAQmxResetSampClkTimingResponseMode: function(taskHandle:Longint):Longint; stdcall;


function InitNIlib:boolean;

Implementation

uses util1;
const
  hh:integer=0;

function getProc(st:string):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
end;

procedure InitNIlib1;
begin
  DAQmxLoadTask:=getProc('DAQmxLoadTask');
  DAQmxCreateTask := getProc('DAQmxCreateTask');
  DAQmxAddGlobalChansToTask := getProc('DAQmxAddGlobalChansToTask');
  DAQmxStartTask := getProc('DAQmxStartTask');
  DAQmxStopTask := getProc('DAQmxStopTask');
  DAQmxClearTask := getProc('DAQmxClearTask');
  DAQmxWaitUntilTaskDone := getProc('DAQmxWaitUntilTaskDone');
  DAQmxIsTaskDone := getProc('DAQmxIsTaskDone_VB6');
  DAQmxWaitForNextSampleClock := getProc('DAQmxWaitForNextSampleClock_VB6');
  DAQmxTaskControl := getProc('DAQmxTaskControl');
  DAQmxGetNthTaskChannel := getProc('DAQmxGetNthTaskChannel');
  DAQmxGetNthTaskDevice := getProc('DAQmxGetNthTaskDevice');
  DAQmxRegisterEveryNSamplesEvent := getProc('DAQmxRegisterEveryNSamplesEvent_VB6');
  DAQmxRegisterDoneEvent := getProc('DAQmxRegisterDoneEvent_VB6');
  DAQmxRegisterSignalEvent := getProc('DAQmxRegisterSignalEvent_VB6');
  DAQmxIsReadOrWriteLate := getProc('DAQmxIsReadOrWriteLate');
  DAQmxCreateAIVoltageChan := getProc('DAQmxCreateAIVoltageChan');
  DAQmxCreateAICurrentChan := getProc('DAQmxCreateAICurrentChan');
  DAQmxCreateAIThrmcplChan := getProc('DAQmxCreateAIThrmcplChan');
  DAQmxCreateAIRTDChan := getProc('DAQmxCreateAIRTDChan');
  DAQmxCreateAIThrmstrChanIex := getProc('DAQmxCreateAIThrmstrChanIex');
  DAQmxCreateAIThrmstrChanVex := getProc('DAQmxCreateAIThrmstrChanVex');
  DAQmxCreateAIFreqVoltageChan := getProc('DAQmxCreateAIFreqVoltageChan');
  DAQmxCreateAIResistanceChan := getProc('DAQmxCreateAIResistanceChan');
  DAQmxCreateAIStrainGageChan := getProc('DAQmxCreateAIStrainGageChan');
  DAQmxCreateAIVoltageChanWithExcit := getProc('DAQmxCreateAIVoltageChanWithExcit');
  DAQmxCreateAITempBuiltInSensorChan := getProc('DAQmxCreateAITempBuiltInSensorChan');
  DAQmxCreateAIAccelChan := getProc('DAQmxCreateAIAccelChan');
  DAQmxCreateAIMicrophoneChan := getProc('DAQmxCreateAIMicrophoneChan');
  DAQmxCreateAIPosLVDTChan := getProc('DAQmxCreateAIPosLVDTChan');
  DAQmxCreateAIPosRVDTChan := getProc('DAQmxCreateAIPosRVDTChan');
  DAQmxCreateAIDeviceTempChan := getProc('DAQmxCreateAIDeviceTempChan');
  DAQmxCreateTEDSAIVoltageChan := getProc('DAQmxCreateTEDSAIVoltageChan');
  DAQmxCreateTEDSAICurrentChan := getProc('DAQmxCreateTEDSAICurrentChan');
  DAQmxCreateTEDSAIThrmcplChan := getProc('DAQmxCreateTEDSAIThrmcplChan');
  DAQmxCreateTEDSAIRTDChan := getProc('DAQmxCreateTEDSAIRTDChan');
  DAQmxCreateTEDSAIThrmstrChanIex := getProc('DAQmxCreateTEDSAIThrmstrChanIex');
  DAQmxCreateTEDSAIThrmstrChanVex := getProc('DAQmxCreateTEDSAIThrmstrChanVex');
  DAQmxCreateTEDSAIResistanceChan := getProc('DAQmxCreateTEDSAIResistanceChan');
  DAQmxCreateTEDSAIStrainGageChan := getProc('DAQmxCreateTEDSAIStrainGageChan');
  DAQmxCreateTEDSAIVoltageChanWithExcit := getProc('DAQmxCreateTEDSAIVoltageChanWithExcit');
  DAQmxCreateTEDSAIAccelChan := getProc('DAQmxCreateTEDSAIAccelChan');
  DAQmxCreateTEDSAIMicrophoneChan := getProc('DAQmxCreateTEDSAIMicrophoneChan');
  DAQmxCreateTEDSAIPosLVDTChan := getProc('DAQmxCreateTEDSAIPosLVDTChan');
  DAQmxCreateTEDSAIPosRVDTChan := getProc('DAQmxCreateTEDSAIPosRVDTChan');
  DAQmxCreateAOVoltageChan := getProc('DAQmxCreateAOVoltageChan');
  DAQmxCreateAOCurrentChan := getProc('DAQmxCreateAOCurrentChan');
  DAQmxCreateDIChan := getProc('DAQmxCreateDIChan');
  DAQmxCreateDOChan := getProc('DAQmxCreateDOChan');
  DAQmxCreateCIFreqChan := getProc('DAQmxCreateCIFreqChan');
  DAQmxCreateCIPeriodChan := getProc('DAQmxCreateCIPeriodChan');
  DAQmxCreateCICountEdgesChan := getProc('DAQmxCreateCICountEdgesChan');
  DAQmxCreateCIPulseWidthChan := getProc('DAQmxCreateCIPulseWidthChan');
  DAQmxCreateCISemiPeriodChan := getProc('DAQmxCreateCISemiPeriodChan');
  DAQmxCreateCITwoEdgeSepChan := getProc('DAQmxCreateCITwoEdgeSepChan');
  DAQmxCreateCILinEncoderChan := getProc('DAQmxCreateCILinEncoderChan');
  DAQmxCreateCIAngEncoderChan := getProc('DAQmxCreateCIAngEncoderChan');
  DAQmxCreateCIGPSTimestampChan := getProc('DAQmxCreateCIGPSTimestampChan');
  DAQmxCreateCOPulseChanFreq := getProc('DAQmxCreateCOPulseChanFreq');
  DAQmxCreateCOPulseChanTime := getProc('DAQmxCreateCOPulseChanTime');
  DAQmxCreateCOPulseChanTicks := getProc('DAQmxCreateCOPulseChanTicks');
  DAQmxGetAIChanCalCalDate := getProc('DAQmxGetAIChanCalCalDate');
  DAQmxSetAIChanCalCalDate := getProc('DAQmxSetAIChanCalCalDate');
  DAQmxGetAIChanCalExpDate := getProc('DAQmxGetAIChanCalExpDate');
  DAQmxSetAIChanCalExpDate := getProc('DAQmxSetAIChanCalExpDate');
  DAQmxCfgSampClkTiming := getProc('DAQmxCfgSampClkTiming_VB6');
  DAQmxCfgHandshakingTiming := getProc('DAQmxCfgHandshakingTiming_VB6');
  DAQmxCfgBurstHandshakingTimingImportClock := getProc('DAQmxCfgBurstHandshakingTimingImportClock_VB6');
  DAQmxCfgBurstHandshakingTimingExportClock := getProc('DAQmxCfgBurstHandshakingTimingExportClock_VB6');
  DAQmxCfgChangeDetectionTiming := getProc('DAQmxCfgChangeDetectionTiming_VB6');
  DAQmxCfgImplicitTiming := getProc('DAQmxCfgImplicitTiming_VB6');
  DAQmxCfgPipelinedSampClkTiming := getProc('DAQmxCfgPipelinedSampClkTiming_VB6');
  DAQmxDisableStartTrig := getProc('DAQmxDisableStartTrig');
  DAQmxCfgDigEdgeStartTrig := getProc('DAQmxCfgDigEdgeStartTrig');
  DAQmxCfgAnlgEdgeStartTrig := getProc('DAQmxCfgAnlgEdgeStartTrig');
  DAQmxCfgAnlgWindowStartTrig := getProc('DAQmxCfgAnlgWindowStartTrig');
  DAQmxCfgDigPatternStartTrig := getProc('DAQmxCfgDigPatternStartTrig');
  DAQmxDisableRefTrig := getProc('DAQmxDisableRefTrig');
  DAQmxCfgDigEdgeRefTrig := getProc('DAQmxCfgDigEdgeRefTrig');
  DAQmxCfgAnlgEdgeRefTrig := getProc('DAQmxCfgAnlgEdgeRefTrig');
  DAQmxCfgAnlgWindowRefTrig := getProc('DAQmxCfgAnlgWindowRefTrig');
  DAQmxCfgDigPatternRefTrig := getProc('DAQmxCfgDigPatternRefTrig');
  DAQmxDisableAdvTrig := getProc('DAQmxDisableAdvTrig');
  DAQmxCfgDigEdgeAdvTrig := getProc('DAQmxCfgDigEdgeAdvTrig');
  DAQmxSendSoftwareTrigger := getProc('DAQmxSendSoftwareTrigger');
  DAQmxReadAnalogF64 := getProc('DAQmxReadAnalogF64');
  DAQmxReadAnalogScalarF64 := getProc('DAQmxReadAnalogScalarF64');
  DAQmxReadBinaryI16 := getProc('DAQmxReadBinaryI16');
  DAQmxReadBinaryI32 := getProc('DAQmxReadBinaryI32');
  DAQmxReadDigitalLines := getProc('DAQmxReadDigitalLines');
  DAQmxReadCounterF64 := getProc('DAQmxReadCounterF64');
  DAQmxReadCounterScalarF64 := getProc('DAQmxReadCounterScalarF64');
  DAQmxReadRaw := getProc('DAQmxReadRaw');
  DAQmxGetNthTaskReadChannel := getProc('DAQmxGetNthTaskReadChannel');
  DAQmxWriteAnalogF64 := getProc('DAQmxWriteAnalogF64');
  DAQmxWriteAnalogScalarF64 := getProc('DAQmxWriteAnalogScalarF64');
  DAQmxWriteBinaryI16 := getProc('DAQmxWriteBinaryI16');
  DAQmxWriteBinaryI32 := getProc('DAQmxWriteBinaryI32');
  DAQmxWriteDigitalLines := getProc('DAQmxWriteDigitalLines');
  DAQmxWriteCtrFreq := getProc('DAQmxWriteCtrFreq');
  DAQmxWriteCtrFreqScalar := getProc('DAQmxWriteCtrFreqScalar');
  DAQmxWriteCtrTime := getProc('DAQmxWriteCtrTime');
  DAQmxWriteCtrTimeScalar := getProc('DAQmxWriteCtrTimeScalar');
  DAQmxWriteCtrTicks := getProc('DAQmxWriteCtrTicks');
  DAQmxWriteCtrTicksScalar := getProc('DAQmxWriteCtrTicksScalar');
  DAQmxWriteRaw := getProc('DAQmxWriteRaw');
  DAQmxExportSignal := getProc('DAQmxExportSignal');
  DAQmxCreateLinScale := getProc('DAQmxCreateLinScale');
  DAQmxCreateMapScale := getProc('DAQmxCreateMapScale');
  DAQmxCreatePolynomialScale := getProc('DAQmxCreatePolynomialScale');
  DAQmxCreateTableScale := getProc('DAQmxCreateTableScale');
  DAQmxCalculateReversePolyCoeff := getProc('DAQmxCalculateReversePolyCoeff');
  DAQmxCfgInputBuffer := getProc('DAQmxCfgInputBuffer');
  DAQmxCfgOutputBuffer := getProc('DAQmxCfgOutputBuffer');
  DAQmxSwitchCreateScanList := getProc('DAQmxSwitchCreateScanList');
  DAQmxSwitchConnect := getProc('DAQmxSwitchConnect');
  DAQmxSwitchConnectMulti := getProc('DAQmxSwitchConnectMulti');
  DAQmxSwitchDisconnect := getProc('DAQmxSwitchDisconnect');
  DAQmxSwitchDisconnectMulti := getProc('DAQmxSwitchDisconnectMulti');
  DAQmxSwitchDisconnectAll := getProc('DAQmxSwitchDisconnectAll');
  DAQmxSwitchSetTopologyAndReset := getProc('DAQmxSwitchSetTopologyAndReset');
  DAQmxSwitchFindPath := getProc('DAQmxSwitchFindPath');
  DAQmxSwitchOpenRelays := getProc('DAQmxSwitchOpenRelays');
  DAQmxSwitchCloseRelays := getProc('DAQmxSwitchCloseRelays');
  DAQmxSwitchGetSingleRelayCount := getProc('DAQmxSwitchGetSingleRelayCount');
  DAQmxSwitchGetMultiRelayCount := getProc('DAQmxSwitchGetMultiRelayCount');
  DAQmxSwitchGetSingleRelayPos := getProc('DAQmxSwitchGetSingleRelayPos');
  DAQmxSwitchGetMultiRelayPos := getProc('DAQmxSwitchGetMultiRelayPos');
  DAQmxSwitchWaitForSettling := getProc('DAQmxSwitchWaitForSettling');
  DAQmxConnectTerms := getProc('DAQmxConnectTerms');
  DAQmxDisconnectTerms := getProc('DAQmxDisconnectTerms');
  DAQmxTristateOutputTerm := getProc('DAQmxTristateOutputTerm');
  DAQmxResetDevice := getProc('DAQmxResetDevice');

  {
  DAQmxCreateWatchdogTimerTask := getProc('DAQmxCreateWatchdogTimerTask_VB6');
  DAQmxControlWatchdogTask:= getProc('DAQmxControlWatchdogTask');
  }
  DAQmxSelfCal := getProc('DAQmxSelfCal');
  DAQmxPerformBridgeOffsetNullingCal := getProc('DAQmxPerformBridgeOffsetNullingCal');
  DAQmxGetSelfCalLastDateAndTime := getProc('DAQmxGetSelfCalLastDateAndTime');
  DAQmxGetExtCalLastDateAndTime := getProc('DAQmxGetExtCalLastDateAndTime');
  DAQmxRestoreLastExtCalConst := getProc('DAQmxRestoreLastExtCalConst');
  DAQmxESeriesCalAdjust := getProc('DAQmxESeriesCalAdjust');
  DAQmxMSeriesCalAdjust := getProc('DAQmxMSeriesCalAdjust');
  DAQmxSSeriesCalAdjust := getProc('DAQmxSSeriesCalAdjust');
  DAQmxSCBaseboardCalAdjust := getProc('DAQmxSCBaseboardCalAdjust');
  DAQmxAOSeriesCalAdjust := getProc('DAQmxAOSeriesCalAdjust');
  DAQmxDeviceSupportsCal := getProc('DAQmxDeviceSupportsCal_VB6');
  DAQmxInitExtCal := getProc('DAQmxInitExtCal');
  DAQmxCloseExtCal := getProc('DAQmxCloseExtCal');
  DAQmxChangeExtCalPassword := getProc('DAQmxChangeExtCalPassword');
  DAQmxAdjustDSAAICal := getProc('DAQmxAdjustDSAAICal');
  DAQmxAdjustDSAAOCal := getProc('DAQmxAdjustDSAAOCal');
  DAQmxAdjustDSATimebaseCal := getProc('DAQmxAdjustDSATimebaseCal');
  DAQmxAdjust4204Cal := getProc('DAQmxAdjust4204Cal');
  DAQmxAdjust4220Cal := getProc('DAQmxAdjust4220Cal');
  DAQmxAdjust4224Cal := getProc('DAQmxAdjust4224Cal');
  DAQmxAdjust4225Cal := getProc('DAQmxAdjust4225Cal');
  DAQmxSetup1102Cal := getProc('DAQmxSetup1102Cal');
  DAQmxAdjust1102Cal := getProc('DAQmxAdjust1102Cal');
  DAQmxSetup1104Cal := getProc('DAQmxSetup1104Cal');
  DAQmxAdjust1104Cal := getProc('DAQmxAdjust1104Cal');
  DAQmxSetup1112Cal := getProc('DAQmxSetup1112Cal');
  DAQmxAdjust1112Cal := getProc('DAQmxAdjust1112Cal');
  DAQmxSetup1124Cal := getProc('DAQmxSetup1124Cal');
  DAQmxAdjust1124Cal := getProc('DAQmxAdjust1124Cal');
  DAQmxSetup1125Cal := getProc('DAQmxSetup1125Cal');
  DAQmxAdjust1125Cal := getProc('DAQmxAdjust1125Cal');
  DAQmxSetup1502Cal := getProc('DAQmxSetup1502Cal');
  DAQmxAdjust1502Cal := getProc('DAQmxAdjust1502Cal');
  DAQmxSetup1503Cal := getProc('DAQmxSetup1503Cal');
  DAQmxAdjust1503Cal := getProc('DAQmxAdjust1503Cal');
  DAQmxAdjust1503CurrentCal := getProc('DAQmxAdjust1503CurrentCal');
  DAQmxSetup1520Cal := getProc('DAQmxSetup1520Cal');
  DAQmxAdjust1520Cal := getProc('DAQmxAdjust1520Cal');
  DAQmxConfigureTEDS := getProc('DAQmxConfigureTEDS');
  DAQmxClearTEDS := getProc('DAQmxClearTEDS');
  DAQmxWriteToTEDSFromArray := getProc('DAQmxWriteToTEDSFromArray');
  DAQmxWriteToTEDSFromFile := getProc('DAQmxWriteToTEDSFromFile');
  DAQmxSaveTask := getProc('DAQmxSaveTask');
  DAQmxSaveGlobalChan := getProc('DAQmxSaveGlobalChan');
  DAQmxSaveScale := getProc('DAQmxSaveScale');
  DAQmxDeleteSavedTask := getProc('DAQmxDeleteSavedTask');
  DAQmxDeleteSavedGlobalChan := getProc('DAQmxDeleteSavedGlobalChan');
  DAQmxDeleteSavedScale := getProc('DAQmxDeleteSavedScale');
  {
  DAQmxSetDigitalPowerUpStates := getProc('DAQmxSetDigitalPowerUpStates_VB6';

  DAQmxSetAnalogPowerUpStates:= getProc('DAQmxSetAnalogPowerUpStates_VB6');

  DAQmxSetDigitalLogicFamilyPowerUpState := getProc('DAQmxSetDigitalLogicFamilyPowerUpState');
  }

  DAQmxGetErrorString := getProc('DAQmxGetErrorString');
  DAQmxGetExtendedErrorInfo := getProc('DAQmxGetExtendedErrorInfo');
  DAQmxGetBufInputBufSize := getProc('DAQmxGetBufInputBufSize');
  DAQmxSetBufInputBufSize := getProc('DAQmxSetBufInputBufSize');
  DAQmxResetBufInputBufSize := getProc('DAQmxResetBufInputBufSize');
  DAQmxGetBufInputOnbrdBufSize := getProc('DAQmxGetBufInputOnbrdBufSize');
  DAQmxGetBufOutputBufSize := getProc('DAQmxGetBufOutputBufSize');
  DAQmxSetBufOutputBufSize := getProc('DAQmxSetBufOutputBufSize');
  DAQmxResetBufOutputBufSize := getProc('DAQmxResetBufOutputBufSize');
  DAQmxGetBufOutputOnbrdBufSize := getProc('DAQmxGetBufOutputOnbrdBufSize');
  DAQmxSetBufOutputOnbrdBufSize := getProc('DAQmxSetBufOutputOnbrdBufSize');
  DAQmxResetBufOutputOnbrdBufSize := getProc('DAQmxResetBufOutputOnbrdBufSize');
  DAQmxGetSelfCalSupported := getProc('DAQmxGetSelfCalSupported_VB6');
  DAQmxGetSelfCalLastTemp := getProc('DAQmxGetSelfCalLastTemp');
  DAQmxGetExtCalRecommendedInterval := getProc('DAQmxGetExtCalRecommendedInterval');
  DAQmxGetExtCalLastTemp := getProc('DAQmxGetExtCalLastTemp');
  DAQmxGetCalUserDefinedInfo := getProc('DAQmxGetCalUserDefinedInfo');
  DAQmxSetCalUserDefinedInfo := getProc('DAQmxSetCalUserDefinedInfo');
  DAQmxGetCalUserDefinedInfoMaxSize := getProc('DAQmxGetCalUserDefinedInfoMaxSize');
  DAQmxGetCalDevTemp := getProc('DAQmxGetCalDevTemp');
  DAQmxGetAIMax := getProc('DAQmxGetAIMax');
  DAQmxSetAIMax := getProc('DAQmxSetAIMax');
  DAQmxResetAIMax := getProc('DAQmxResetAIMax');
  DAQmxGetAIMin := getProc('DAQmxGetAIMin');
  DAQmxSetAIMin := getProc('DAQmxSetAIMin');
  DAQmxResetAIMin := getProc('DAQmxResetAIMin');
  DAQmxGetAICustomScaleName := getProc('DAQmxGetAICustomScaleName');
  DAQmxSetAICustomScaleName := getProc('DAQmxSetAICustomScaleName');
  DAQmxResetAICustomScaleName := getProc('DAQmxResetAICustomScaleName');
  DAQmxGetAIMeasType := getProc('DAQmxGetAIMeasType');
  DAQmxGetAIVoltageUnits := getProc('DAQmxGetAIVoltageUnits');
  DAQmxSetAIVoltageUnits := getProc('DAQmxSetAIVoltageUnits');
  DAQmxResetAIVoltageUnits := getProc('DAQmxResetAIVoltageUnits');
  DAQmxGetAITempUnits := getProc('DAQmxGetAITempUnits');
  DAQmxSetAITempUnits := getProc('DAQmxSetAITempUnits');
  DAQmxResetAITempUnits := getProc('DAQmxResetAITempUnits');
  DAQmxGetAIThrmcplType := getProc('DAQmxGetAIThrmcplType');
  DAQmxSetAIThrmcplType := getProc('DAQmxSetAIThrmcplType');
  DAQmxResetAIThrmcplType := getProc('DAQmxResetAIThrmcplType');
  DAQmxGetAIThrmcplScaleType := getProc('DAQmxGetAIThrmcplScaleType');
  DAQmxSetAIThrmcplScaleType := getProc('DAQmxSetAIThrmcplScaleType');
  DAQmxResetAIThrmcplScaleType := getProc('DAQmxResetAIThrmcplScaleType');
  DAQmxGetAIThrmcplCJCSrc := getProc('DAQmxGetAIThrmcplCJCSrc');
  DAQmxGetAIThrmcplCJCVal := getProc('DAQmxGetAIThrmcplCJCVal');
  DAQmxSetAIThrmcplCJCVal := getProc('DAQmxSetAIThrmcplCJCVal');
  DAQmxResetAIThrmcplCJCVal := getProc('DAQmxResetAIThrmcplCJCVal');
  DAQmxGetAIThrmcplCJCChan := getProc('DAQmxGetAIThrmcplCJCChan');
  DAQmxGetAIRTDType := getProc('DAQmxGetAIRTDType');
  DAQmxSetAIRTDType := getProc('DAQmxSetAIRTDType');
  DAQmxResetAIRTDType := getProc('DAQmxResetAIRTDType');
  DAQmxGetAIRTDR0 := getProc('DAQmxGetAIRTDR0');
  DAQmxSetAIRTDR0 := getProc('DAQmxSetAIRTDR0');
  DAQmxResetAIRTDR0 := getProc('DAQmxResetAIRTDR0');
  DAQmxGetAIRTDA := getProc('DAQmxGetAIRTDA');
  DAQmxSetAIRTDA := getProc('DAQmxSetAIRTDA');
  DAQmxResetAIRTDA := getProc('DAQmxResetAIRTDA');
  DAQmxGetAIRTDB := getProc('DAQmxGetAIRTDB');
  DAQmxSetAIRTDB := getProc('DAQmxSetAIRTDB');
  DAQmxResetAIRTDB := getProc('DAQmxResetAIRTDB');
  DAQmxGetAIRTDC := getProc('DAQmxGetAIRTDC');
  DAQmxSetAIRTDC := getProc('DAQmxSetAIRTDC');
  DAQmxResetAIRTDC := getProc('DAQmxResetAIRTDC');
  DAQmxGetAIThrmstrA := getProc('DAQmxGetAIThrmstrA');
  DAQmxSetAIThrmstrA := getProc('DAQmxSetAIThrmstrA');
  DAQmxResetAIThrmstrA := getProc('DAQmxResetAIThrmstrA');
  DAQmxGetAIThrmstrB := getProc('DAQmxGetAIThrmstrB');
  DAQmxSetAIThrmstrB := getProc('DAQmxSetAIThrmstrB');
  DAQmxResetAIThrmstrB := getProc('DAQmxResetAIThrmstrB');
  DAQmxGetAIThrmstrC := getProc('DAQmxGetAIThrmstrC');
  DAQmxSetAIThrmstrC := getProc('DAQmxSetAIThrmstrC');
  DAQmxResetAIThrmstrC := getProc('DAQmxResetAIThrmstrC');
  DAQmxGetAIThrmstrR1 := getProc('DAQmxGetAIThrmstrR1');
  DAQmxSetAIThrmstrR1 := getProc('DAQmxSetAIThrmstrR1');
  DAQmxResetAIThrmstrR1 := getProc('DAQmxResetAIThrmstrR1');
  DAQmxGetAIForceReadFromChan := getProc('DAQmxGetAIForceReadFromChan_VB6');
  DAQmxSetAIForceReadFromChan := getProc('DAQmxSetAIForceReadFromChan');
  DAQmxResetAIForceReadFromChan := getProc('DAQmxResetAIForceReadFromChan');
  DAQmxGetAICurrentUnits := getProc('DAQmxGetAICurrentUnits');
  DAQmxSetAICurrentUnits := getProc('DAQmxSetAICurrentUnits');
  DAQmxResetAICurrentUnits := getProc('DAQmxResetAICurrentUnits');
  DAQmxGetAIStrainUnits := getProc('DAQmxGetAIStrainUnits');
  DAQmxSetAIStrainUnits := getProc('DAQmxSetAIStrainUnits');
  DAQmxResetAIStrainUnits := getProc('DAQmxResetAIStrainUnits');
  DAQmxGetAIStrainGageGageFactor := getProc('DAQmxGetAIStrainGageGageFactor');
  DAQmxSetAIStrainGageGageFactor := getProc('DAQmxSetAIStrainGageGageFactor');
  DAQmxResetAIStrainGageGageFactor := getProc('DAQmxResetAIStrainGageGageFactor');
  DAQmxGetAIStrainGagePoissonRatio := getProc('DAQmxGetAIStrainGagePoissonRatio');
  DAQmxSetAIStrainGagePoissonRatio := getProc('DAQmxSetAIStrainGagePoissonRatio');
  DAQmxResetAIStrainGagePoissonRatio := getProc('DAQmxResetAIStrainGagePoissonRatio');
  DAQmxGetAIStrainGageCfg := getProc('DAQmxGetAIStrainGageCfg');
  DAQmxSetAIStrainGageCfg := getProc('DAQmxSetAIStrainGageCfg');
  DAQmxResetAIStrainGageCfg := getProc('DAQmxResetAIStrainGageCfg');
  DAQmxGetAIResistanceUnits := getProc('DAQmxGetAIResistanceUnits');
  DAQmxSetAIResistanceUnits := getProc('DAQmxSetAIResistanceUnits');
  DAQmxResetAIResistanceUnits := getProc('DAQmxResetAIResistanceUnits');
  DAQmxGetAIFreqUnits := getProc('DAQmxGetAIFreqUnits');
  DAQmxSetAIFreqUnits := getProc('DAQmxSetAIFreqUnits');

  DAQmxResetAIFreqUnits := getProc('DAQmxResetAIFreqUnits');
  DAQmxGetAIFreqThreshVoltage := getProc('DAQmxGetAIFreqThreshVoltage');
  DAQmxSetAIFreqThreshVoltage := getProc('DAQmxSetAIFreqThreshVoltage');
  DAQmxResetAIFreqThreshVoltage := getProc('DAQmxResetAIFreqThreshVoltage');
  DAQmxGetAIFreqHyst := getProc('DAQmxGetAIFreqHyst');
  DAQmxSetAIFreqHyst := getProc('DAQmxSetAIFreqHyst');
  DAQmxResetAIFreqHyst := getProc('DAQmxResetAIFreqHyst');
  DAQmxGetAILVDTUnits := getProc('DAQmxGetAILVDTUnits');
  DAQmxSetAILVDTUnits := getProc('DAQmxSetAILVDTUnits');
  DAQmxResetAILVDTUnits := getProc('DAQmxResetAILVDTUnits');
  DAQmxGetAILVDTSensitivity := getProc('DAQmxGetAILVDTSensitivity');
  DAQmxSetAILVDTSensitivity := getProc('DAQmxSetAILVDTSensitivity');
  DAQmxResetAILVDTSensitivity := getProc('DAQmxResetAILVDTSensitivity');
  DAQmxGetAILVDTSensitivityUnits := getProc('DAQmxGetAILVDTSensitivityUnits');
  DAQmxSetAILVDTSensitivityUnits := getProc('DAQmxSetAILVDTSensitivityUnits');
  DAQmxResetAILVDTSensitivityUnits := getProc('DAQmxResetAILVDTSensitivityUnits');
  DAQmxGetAIRVDTUnits := getProc('DAQmxGetAIRVDTUnits');
  DAQmxSetAIRVDTUnits := getProc('DAQmxSetAIRVDTUnits');
  DAQmxResetAIRVDTUnits := getProc('DAQmxResetAIRVDTUnits');
  DAQmxGetAIRVDTSensitivity := getProc('DAQmxGetAIRVDTSensitivity');
  DAQmxSetAIRVDTSensitivity := getProc('DAQmxSetAIRVDTSensitivity');
  DAQmxResetAIRVDTSensitivity := getProc('DAQmxResetAIRVDTSensitivity');
  DAQmxGetAIRVDTSensitivityUnits := getProc('DAQmxGetAIRVDTSensitivityUnits');
  DAQmxSetAIRVDTSensitivityUnits := getProc('DAQmxSetAIRVDTSensitivityUnits');
  DAQmxResetAIRVDTSensitivityUnits := getProc('DAQmxResetAIRVDTSensitivityUnits');
  DAQmxGetAISoundPressureMaxSoundPressureLvl := getProc('DAQmxGetAISoundPressureMaxSoundPressureLvl');
  DAQmxSetAISoundPressureMaxSoundPressureLvl := getProc('DAQmxSetAISoundPressureMaxSoundPressureLvl');
  DAQmxResetAISoundPressureMaxSoundPressureLvl := getProc('DAQmxResetAISoundPressureMaxSoundPressureLvl');
  DAQmxGetAISoundPressureUnits := getProc('DAQmxGetAISoundPressureUnits');
  DAQmxSetAISoundPressureUnits := getProc('DAQmxSetAISoundPressureUnits');
  DAQmxResetAISoundPressureUnits := getProc('DAQmxResetAISoundPressureUnits');
  DAQmxGetAIMicrophoneSensitivity := getProc('DAQmxGetAIMicrophoneSensitivity');
  DAQmxSetAIMicrophoneSensitivity := getProc('DAQmxSetAIMicrophoneSensitivity');
  DAQmxResetAIMicrophoneSensitivity := getProc('DAQmxResetAIMicrophoneSensitivity');
  DAQmxGetAIAccelUnits := getProc('DAQmxGetAIAccelUnits');
  DAQmxSetAIAccelUnits := getProc('DAQmxSetAIAccelUnits');
  DAQmxResetAIAccelUnits := getProc('DAQmxResetAIAccelUnits');
  DAQmxGetAIAccelSensitivity := getProc('DAQmxGetAIAccelSensitivity');
  DAQmxSetAIAccelSensitivity := getProc('DAQmxSetAIAccelSensitivity');
  DAQmxResetAIAccelSensitivity := getProc('DAQmxResetAIAccelSensitivity');
  DAQmxGetAIAccelSensitivityUnits := getProc('DAQmxGetAIAccelSensitivityUnits');
  DAQmxSetAIAccelSensitivityUnits := getProc('DAQmxSetAIAccelSensitivityUnits');
  DAQmxResetAIAccelSensitivityUnits := getProc('DAQmxResetAIAccelSensitivityUnits');
  DAQmxGetAIIsTEDS := getProc('DAQmxGetAIIsTEDS_VB6');
  DAQmxGetAITEDSUnits := getProc('DAQmxGetAITEDSUnits');
  DAQmxGetAICoupling := getProc('DAQmxGetAICoupling');
  DAQmxSetAICoupling := getProc('DAQmxSetAICoupling');
  DAQmxResetAICoupling := getProc('DAQmxResetAICoupling');
  DAQmxGetAIImpedance := getProc('DAQmxGetAIImpedance');
  DAQmxSetAIImpedance := getProc('DAQmxSetAIImpedance');
  DAQmxResetAIImpedance := getProc('DAQmxResetAIImpedance');
  DAQmxGetAITermCfg := getProc('DAQmxGetAITermCfg');
  DAQmxSetAITermCfg := getProc('DAQmxSetAITermCfg');
  DAQmxResetAITermCfg := getProc('DAQmxResetAITermCfg');
  DAQmxGetAIInputSrc := getProc('DAQmxGetAIInputSrc');
  DAQmxSetAIInputSrc := getProc('DAQmxSetAIInputSrc');
  DAQmxResetAIInputSrc := getProc('DAQmxResetAIInputSrc');
  DAQmxGetAIResistanceCfg := getProc('DAQmxGetAIResistanceCfg');
  DAQmxSetAIResistanceCfg := getProc('DAQmxSetAIResistanceCfg');
  DAQmxResetAIResistanceCfg := getProc('DAQmxResetAIResistanceCfg');
  DAQmxGetAILeadWireResistance := getProc('DAQmxGetAILeadWireResistance');
  DAQmxSetAILeadWireResistance := getProc('DAQmxSetAILeadWireResistance');
  DAQmxResetAILeadWireResistance := getProc('DAQmxResetAILeadWireResistance');
  DAQmxGetAIBridgeCfg := getProc('DAQmxGetAIBridgeCfg');
  DAQmxSetAIBridgeCfg := getProc('DAQmxSetAIBridgeCfg');
  DAQmxResetAIBridgeCfg := getProc('DAQmxResetAIBridgeCfg');
  DAQmxGetAIBridgeNomResistance := getProc('DAQmxGetAIBridgeNomResistance');
  DAQmxSetAIBridgeNomResistance := getProc('DAQmxSetAIBridgeNomResistance');
  DAQmxResetAIBridgeNomResistance := getProc('DAQmxResetAIBridgeNomResistance');
  DAQmxGetAIBridgeInitialVoltage := getProc('DAQmxGetAIBridgeInitialVoltage');
  DAQmxSetAIBridgeInitialVoltage := getProc('DAQmxSetAIBridgeInitialVoltage');
  DAQmxResetAIBridgeInitialVoltage := getProc('DAQmxResetAIBridgeInitialVoltage');
  DAQmxGetAIBridgeShuntCalEnable := getProc('DAQmxGetAIBridgeShuntCalEnable_VB6');
  DAQmxSetAIBridgeShuntCalEnable := getProc('DAQmxSetAIBridgeShuntCalEnable');
  DAQmxResetAIBridgeShuntCalEnable := getProc('DAQmxResetAIBridgeShuntCalEnable');
  DAQmxGetAIBridgeShuntCalSelect := getProc('DAQmxGetAIBridgeShuntCalSelect');
  DAQmxSetAIBridgeShuntCalSelect := getProc('DAQmxSetAIBridgeShuntCalSelect');
  DAQmxResetAIBridgeShuntCalSelect := getProc('DAQmxResetAIBridgeShuntCalSelect');
  DAQmxGetAIBridgeShuntCalGainAdjust := getProc('DAQmxGetAIBridgeShuntCalGainAdjust');
  DAQmxSetAIBridgeShuntCalGainAdjust := getProc('DAQmxSetAIBridgeShuntCalGainAdjust');
  DAQmxResetAIBridgeShuntCalGainAdjust := getProc('DAQmxResetAIBridgeShuntCalGainAdjust');
  DAQmxGetAIBridgeBalanceCoarsePot := getProc('DAQmxGetAIBridgeBalanceCoarsePot');
  DAQmxSetAIBridgeBalanceCoarsePot := getProc('DAQmxSetAIBridgeBalanceCoarsePot');
  DAQmxResetAIBridgeBalanceCoarsePot := getProc('DAQmxResetAIBridgeBalanceCoarsePot');
  DAQmxGetAIBridgeBalanceFinePot := getProc('DAQmxGetAIBridgeBalanceFinePot');
  DAQmxSetAIBridgeBalanceFinePot := getProc('DAQmxSetAIBridgeBalanceFinePot');
  DAQmxResetAIBridgeBalanceFinePot := getProc('DAQmxResetAIBridgeBalanceFinePot');
  DAQmxGetAICurrentShuntLoc := getProc('DAQmxGetAICurrentShuntLoc');
  DAQmxSetAICurrentShuntLoc := getProc('DAQmxSetAICurrentShuntLoc');
  DAQmxResetAICurrentShuntLoc := getProc('DAQmxResetAICurrentShuntLoc');
  DAQmxGetAICurrentShuntResistance := getProc('DAQmxGetAICurrentShuntResistance');
  DAQmxSetAICurrentShuntResistance := getProc('DAQmxSetAICurrentShuntResistance');
  DAQmxResetAICurrentShuntResistance := getProc('DAQmxResetAICurrentShuntResistance');
  DAQmxGetAIExcitSrc := getProc('DAQmxGetAIExcitSrc');
  DAQmxSetAIExcitSrc := getProc('DAQmxSetAIExcitSrc');
  DAQmxResetAIExcitSrc := getProc('DAQmxResetAIExcitSrc');
  DAQmxGetAIExcitVal := getProc('DAQmxGetAIExcitVal');
  DAQmxSetAIExcitVal := getProc('DAQmxSetAIExcitVal');
  DAQmxResetAIExcitVal := getProc('DAQmxResetAIExcitVal');
  DAQmxGetAIExcitUseForScaling := getProc('DAQmxGetAIExcitUseForScaling_VB6');
  DAQmxSetAIExcitUseForScaling := getProc('DAQmxSetAIExcitUseForScaling');
  DAQmxResetAIExcitUseForScaling := getProc('DAQmxResetAIExcitUseForScaling');
  DAQmxGetAIExcitUseMultiplexed := getProc('DAQmxGetAIExcitUseMultiplexed_VB6');
  DAQmxSetAIExcitUseMultiplexed := getProc('DAQmxSetAIExcitUseMultiplexed');
  DAQmxResetAIExcitUseMultiplexed := getProc('DAQmxResetAIExcitUseMultiplexed');
  DAQmxGetAIExcitActualVal := getProc('DAQmxGetAIExcitActualVal');
  DAQmxSetAIExcitActualVal := getProc('DAQmxSetAIExcitActualVal');
  DAQmxResetAIExcitActualVal := getProc('DAQmxResetAIExcitActualVal');
  DAQmxGetAIExcitDCorAC := getProc('DAQmxGetAIExcitDCorAC');
  DAQmxSetAIExcitDCorAC := getProc('DAQmxSetAIExcitDCorAC');
  DAQmxResetAIExcitDCorAC := getProc('DAQmxResetAIExcitDCorAC');
  DAQmxGetAIExcitVoltageOrCurrent := getProc('DAQmxGetAIExcitVoltageOrCurrent');
  DAQmxSetAIExcitVoltageOrCurrent := getProc('DAQmxSetAIExcitVoltageOrCurrent');
  DAQmxResetAIExcitVoltageOrCurrent := getProc('DAQmxResetAIExcitVoltageOrCurrent');
  DAQmxGetAIACExcitFreq := getProc('DAQmxGetAIACExcitFreq');
  DAQmxSetAIACExcitFreq := getProc('DAQmxSetAIACExcitFreq');
  DAQmxResetAIACExcitFreq := getProc('DAQmxResetAIACExcitFreq');
  DAQmxGetAIACExcitSyncEnable := getProc('DAQmxGetAIACExcitSyncEnable_VB6');
  DAQmxSetAIACExcitSyncEnable := getProc('DAQmxSetAIACExcitSyncEnable');
  DAQmxResetAIACExcitSyncEnable := getProc('DAQmxResetAIACExcitSyncEnable');
  DAQmxGetAIACExcitWireMode := getProc('DAQmxGetAIACExcitWireMode');
  DAQmxSetAIACExcitWireMode := getProc('DAQmxSetAIACExcitWireMode');
  DAQmxResetAIACExcitWireMode := getProc('DAQmxResetAIACExcitWireMode');
  DAQmxGetAIAtten := getProc('DAQmxGetAIAtten');
  DAQmxSetAIAtten := getProc('DAQmxSetAIAtten');
  DAQmxResetAIAtten := getProc('DAQmxResetAIAtten');
  DAQmxGetAILowpassEnable := getProc('DAQmxGetAILowpassEnable_VB6');
  DAQmxSetAILowpassEnable := getProc('DAQmxSetAILowpassEnable');
  DAQmxResetAILowpassEnable := getProc('DAQmxResetAILowpassEnable');
  DAQmxGetAILowpassCutoffFreq := getProc('DAQmxGetAILowpassCutoffFreq');
  DAQmxSetAILowpassCutoffFreq := getProc('DAQmxSetAILowpassCutoffFreq');
  DAQmxResetAILowpassCutoffFreq := getProc('DAQmxResetAILowpassCutoffFreq');
  DAQmxGetAILowpassSwitchCapClkSrc := getProc('DAQmxGetAILowpassSwitchCapClkSrc');
  DAQmxSetAILowpassSwitchCapClkSrc := getProc('DAQmxSetAILowpassSwitchCapClkSrc');
  DAQmxResetAILowpassSwitchCapClkSrc := getProc('DAQmxResetAILowpassSwitchCapClkSrc');
  DAQmxGetAILowpassSwitchCapExtClkFreq := getProc('DAQmxGetAILowpassSwitchCapExtClkFreq');
  DAQmxSetAILowpassSwitchCapExtClkFreq := getProc('DAQmxSetAILowpassSwitchCapExtClkFreq');
  DAQmxResetAILowpassSwitchCapExtClkFreq := getProc('DAQmxResetAILowpassSwitchCapExtClkFreq');
  DAQmxGetAILowpassSwitchCapExtClkDiv := getProc('DAQmxGetAILowpassSwitchCapExtClkDiv');
  DAQmxSetAILowpassSwitchCapExtClkDiv := getProc('DAQmxSetAILowpassSwitchCapExtClkDiv');
  DAQmxResetAILowpassSwitchCapExtClkDiv := getProc('DAQmxResetAILowpassSwitchCapExtClkDiv');
  DAQmxGetAILowpassSwitchCapOutClkDiv := getProc('DAQmxGetAILowpassSwitchCapOutClkDiv');
  DAQmxSetAILowpassSwitchCapOutClkDiv := getProc('DAQmxSetAILowpassSwitchCapOutClkDiv');
  DAQmxResetAILowpassSwitchCapOutClkDiv := getProc('DAQmxResetAILowpassSwitchCapOutClkDiv');
  DAQmxGetAIResolutionUnits := getProc('DAQmxGetAIResolutionUnits');
  DAQmxGetAIResolution := getProc('DAQmxGetAIResolution');

  DAQmxGetAIRawSampSize := getProc('DAQmxGetAIRawSampSize');
  DAQmxGetAIRawSampJustification := getProc('DAQmxGetAIRawSampJustification');
  DAQmxGetAIDitherEnable := getProc('DAQmxGetAIDitherEnable_VB6');
  DAQmxSetAIDitherEnable := getProc('DAQmxSetAIDitherEnable');
  DAQmxResetAIDitherEnable := getProc('DAQmxResetAIDitherEnable');
  DAQmxGetAIChanCalHasValidCalInfo := getProc('DAQmxGetAIChanCalHasValidCalInfo_VB6');
  DAQmxGetAIChanCalEnableCal := getProc('DAQmxGetAIChanCalEnableCal_VB6');
  DAQmxSetAIChanCalEnableCal := getProc('DAQmxSetAIChanCalEnableCal');
  DAQmxResetAIChanCalEnableCal := getProc('DAQmxResetAIChanCalEnableCal');
  DAQmxGetAIChanCalApplyCalIfExp := getProc('DAQmxGetAIChanCalApplyCalIfExp_VB6');
  DAQmxSetAIChanCalApplyCalIfExp := getProc('DAQmxSetAIChanCalApplyCalIfExp');
  DAQmxResetAIChanCalApplyCalIfExp := getProc('DAQmxResetAIChanCalApplyCalIfExp');
  DAQmxGetAIChanCalScaleType := getProc('DAQmxGetAIChanCalScaleType');
  DAQmxSetAIChanCalScaleType := getProc('DAQmxSetAIChanCalScaleType');
  DAQmxResetAIChanCalScaleType := getProc('DAQmxResetAIChanCalScaleType');
  DAQmxGetAIChanCalTablePreScaledVals := getProc('DAQmxGetAIChanCalTablePreScaledVals');
  DAQmxSetAIChanCalTablePreScaledVals := getProc('DAQmxSetAIChanCalTablePreScaledVals');
  DAQmxResetAIChanCalTablePreScaledVals := getProc('DAQmxResetAIChanCalTablePreScaledVals');
  DAQmxGetAIChanCalTableScaledVals := getProc('DAQmxGetAIChanCalTableScaledVals');
  DAQmxSetAIChanCalTableScaledVals := getProc('DAQmxSetAIChanCalTableScaledVals');
  DAQmxResetAIChanCalTableScaledVals := getProc('DAQmxResetAIChanCalTableScaledVals');
  DAQmxGetAIChanCalPolyForwardCoeff := getProc('DAQmxGetAIChanCalPolyForwardCoeff');
  DAQmxSetAIChanCalPolyForwardCoeff := getProc('DAQmxSetAIChanCalPolyForwardCoeff');
  DAQmxResetAIChanCalPolyForwardCoeff := getProc('DAQmxResetAIChanCalPolyForwardCoeff');
  DAQmxGetAIChanCalPolyReverseCoeff := getProc('DAQmxGetAIChanCalPolyReverseCoeff');
  DAQmxSetAIChanCalPolyReverseCoeff := getProc('DAQmxSetAIChanCalPolyReverseCoeff');
  DAQmxResetAIChanCalPolyReverseCoeff := getProc('DAQmxResetAIChanCalPolyReverseCoeff');
  DAQmxGetAIChanCalOperatorName := getProc('DAQmxGetAIChanCalOperatorName');
  DAQmxSetAIChanCalOperatorName := getProc('DAQmxSetAIChanCalOperatorName');
  DAQmxResetAIChanCalOperatorName := getProc('DAQmxResetAIChanCalOperatorName');
  DAQmxGetAIChanCalDesc := getProc('DAQmxGetAIChanCalDesc');
  DAQmxSetAIChanCalDesc := getProc('DAQmxSetAIChanCalDesc');
  DAQmxResetAIChanCalDesc := getProc('DAQmxResetAIChanCalDesc');
  DAQmxGetAIChanCalVerifRefVals := getProc('DAQmxGetAIChanCalVerifRefVals');
  DAQmxSetAIChanCalVerifRefVals := getProc('DAQmxSetAIChanCalVerifRefVals');
  DAQmxResetAIChanCalVerifRefVals := getProc('DAQmxResetAIChanCalVerifRefVals');
  DAQmxGetAIChanCalVerifAcqVals := getProc('DAQmxGetAIChanCalVerifAcqVals');
  DAQmxSetAIChanCalVerifAcqVals := getProc('DAQmxSetAIChanCalVerifAcqVals');
  DAQmxResetAIChanCalVerifAcqVals := getProc('DAQmxResetAIChanCalVerifAcqVals');
  DAQmxGetAIRngHigh := getProc('DAQmxGetAIRngHigh');
  DAQmxSetAIRngHigh := getProc('DAQmxSetAIRngHigh');
  DAQmxResetAIRngHigh := getProc('DAQmxResetAIRngHigh');
  DAQmxGetAIRngLow := getProc('DAQmxGetAIRngLow');
  DAQmxSetAIRngLow := getProc('DAQmxSetAIRngLow');
  DAQmxResetAIRngLow := getProc('DAQmxResetAIRngLow');
  DAQmxGetAIGain := getProc('DAQmxGetAIGain');
  DAQmxSetAIGain := getProc('DAQmxSetAIGain');
  DAQmxResetAIGain := getProc('DAQmxResetAIGain');
  DAQmxGetAISampAndHoldEnable := getProc('DAQmxGetAISampAndHoldEnable_VB6');
  DAQmxSetAISampAndHoldEnable := getProc('DAQmxSetAISampAndHoldEnable');
  DAQmxResetAISampAndHoldEnable := getProc('DAQmxResetAISampAndHoldEnable');
  DAQmxGetAIAutoZeroMode := getProc('DAQmxGetAIAutoZeroMode');
  DAQmxSetAIAutoZeroMode := getProc('DAQmxSetAIAutoZeroMode');
  DAQmxResetAIAutoZeroMode := getProc('DAQmxResetAIAutoZeroMode');
  DAQmxGetAIDataXferMech := getProc('DAQmxGetAIDataXferMech');
  DAQmxSetAIDataXferMech := getProc('DAQmxSetAIDataXferMech');
  DAQmxResetAIDataXferMech := getProc('DAQmxResetAIDataXferMech');
  DAQmxGetAIDataXferReqCond := getProc('DAQmxGetAIDataXferReqCond');
  DAQmxSetAIDataXferReqCond := getProc('DAQmxSetAIDataXferReqCond');
  DAQmxResetAIDataXferReqCond := getProc('DAQmxResetAIDataXferReqCond');
  DAQmxGetAIDataXferCustomThreshold := getProc('DAQmxGetAIDataXferCustomThreshold');
  DAQmxSetAIDataXferCustomThreshold := getProc('DAQmxSetAIDataXferCustomThreshold');
  DAQmxResetAIDataXferCustomThreshold := getProc('DAQmxResetAIDataXferCustomThreshold');
  DAQmxGetAIMemMapEnable := getProc('DAQmxGetAIMemMapEnable_VB6');
  DAQmxSetAIMemMapEnable := getProc('DAQmxSetAIMemMapEnable');
  DAQmxResetAIMemMapEnable := getProc('DAQmxResetAIMemMapEnable');
  DAQmxGetAIRawDataCompressionType := getProc('DAQmxGetAIRawDataCompressionType');
  DAQmxSetAIRawDataCompressionType := getProc('DAQmxSetAIRawDataCompressionType');
  DAQmxResetAIRawDataCompressionType := getProc('DAQmxResetAIRawDataCompressionType');
  DAQmxGetAILossyLSBRemovalCompressedSampSize := getProc('DAQmxGetAILossyLSBRemovalCompressedSampSize');
  DAQmxSetAILossyLSBRemovalCompressedSampSize := getProc('DAQmxSetAILossyLSBRemovalCompressedSampSize');
  DAQmxResetAILossyLSBRemovalCompressedSampSize := getProc('DAQmxResetAILossyLSBRemovalCompressedSampSize');
  DAQmxGetAIDevScalingCoeff := getProc('DAQmxGetAIDevScalingCoeff');
  DAQmxGetAIEnhancedAliasRejectionEnable := getProc('DAQmxGetAIEnhancedAliasRejectionEnable_VB6');
  DAQmxSetAIEnhancedAliasRejectionEnable := getProc('DAQmxSetAIEnhancedAliasRejectionEnable');
  DAQmxResetAIEnhancedAliasRejectionEnable := getProc('DAQmxResetAIEnhancedAliasRejectionEnable');
  DAQmxGetAOMax := getProc('DAQmxGetAOMax');
  DAQmxSetAOMax := getProc('DAQmxSetAOMax');
  DAQmxResetAOMax := getProc('DAQmxResetAOMax');
  DAQmxGetAOMin := getProc('DAQmxGetAOMin');
  DAQmxSetAOMin := getProc('DAQmxSetAOMin');
  DAQmxResetAOMin := getProc('DAQmxResetAOMin');
  DAQmxGetAOCustomScaleName := getProc('DAQmxGetAOCustomScaleName');
  DAQmxSetAOCustomScaleName := getProc('DAQmxSetAOCustomScaleName');
  DAQmxResetAOCustomScaleName := getProc('DAQmxResetAOCustomScaleName');
  DAQmxGetAOOutputType := getProc('DAQmxGetAOOutputType');
  DAQmxGetAOVoltageUnits := getProc('DAQmxGetAOVoltageUnits');
  DAQmxSetAOVoltageUnits := getProc('DAQmxSetAOVoltageUnits');
  DAQmxResetAOVoltageUnits := getProc('DAQmxResetAOVoltageUnits');
  DAQmxGetAOCurrentUnits := getProc('DAQmxGetAOCurrentUnits');
  DAQmxSetAOCurrentUnits := getProc('DAQmxSetAOCurrentUnits');
  DAQmxResetAOCurrentUnits := getProc('DAQmxResetAOCurrentUnits');
  DAQmxGetAOOutputImpedance := getProc('DAQmxGetAOOutputImpedance');
  DAQmxSetAOOutputImpedance := getProc('DAQmxSetAOOutputImpedance');
  DAQmxResetAOOutputImpedance := getProc('DAQmxResetAOOutputImpedance');
  DAQmxGetAOLoadImpedance := getProc('DAQmxGetAOLoadImpedance');
  DAQmxSetAOLoadImpedance := getProc('DAQmxSetAOLoadImpedance');
  DAQmxResetAOLoadImpedance := getProc('DAQmxResetAOLoadImpedance');
  DAQmxGetAOIdleOutputBehavior := getProc('DAQmxGetAOIdleOutputBehavior');
  DAQmxSetAOIdleOutputBehavior := getProc('DAQmxSetAOIdleOutputBehavior');
  DAQmxResetAOIdleOutputBehavior := getProc('DAQmxResetAOIdleOutputBehavior');
  DAQmxGetAOTermCfg := getProc('DAQmxGetAOTermCfg');
  DAQmxSetAOTermCfg := getProc('DAQmxSetAOTermCfg');
  DAQmxResetAOTermCfg := getProc('DAQmxResetAOTermCfg');
  DAQmxGetAOResolutionUnits := getProc('DAQmxGetAOResolutionUnits');
  DAQmxSetAOResolutionUnits := getProc('DAQmxSetAOResolutionUnits');
  DAQmxResetAOResolutionUnits := getProc('DAQmxResetAOResolutionUnits');
  DAQmxGetAOResolution := getProc('DAQmxGetAOResolution');
  DAQmxGetAODACRngHigh := getProc('DAQmxGetAODACRngHigh');
  DAQmxSetAODACRngHigh := getProc('DAQmxSetAODACRngHigh');
  DAQmxResetAODACRngHigh := getProc('DAQmxResetAODACRngHigh');
  DAQmxGetAODACRngLow := getProc('DAQmxGetAODACRngLow');
  DAQmxSetAODACRngLow := getProc('DAQmxSetAODACRngLow');
  DAQmxResetAODACRngLow := getProc('DAQmxResetAODACRngLow');
  DAQmxGetAODACRefConnToGnd := getProc('DAQmxGetAODACRefConnToGnd_VB6');
  DAQmxSetAODACRefConnToGnd := getProc('DAQmxSetAODACRefConnToGnd');
  DAQmxResetAODACRefConnToGnd := getProc('DAQmxResetAODACRefConnToGnd');
  DAQmxGetAODACRefAllowConnToGnd := getProc('DAQmxGetAODACRefAllowConnToGnd_VB6');
  DAQmxSetAODACRefAllowConnToGnd := getProc('DAQmxSetAODACRefAllowConnToGnd');
  DAQmxResetAODACRefAllowConnToGnd := getProc('DAQmxResetAODACRefAllowConnToGnd');
  DAQmxGetAODACRefSrc := getProc('DAQmxGetAODACRefSrc');
  DAQmxSetAODACRefSrc := getProc('DAQmxSetAODACRefSrc');
  DAQmxResetAODACRefSrc := getProc('DAQmxResetAODACRefSrc');
  DAQmxGetAODACRefExtSrc := getProc('DAQmxGetAODACRefExtSrc');
  DAQmxSetAODACRefExtSrc := getProc('DAQmxSetAODACRefExtSrc');
  DAQmxResetAODACRefExtSrc := getProc('DAQmxResetAODACRefExtSrc');
  DAQmxGetAODACRefVal := getProc('DAQmxGetAODACRefVal');
  DAQmxSetAODACRefVal := getProc('DAQmxSetAODACRefVal');
  DAQmxResetAODACRefVal := getProc('DAQmxResetAODACRefVal');
  DAQmxGetAODACOffsetSrc := getProc('DAQmxGetAODACOffsetSrc');
  DAQmxSetAODACOffsetSrc := getProc('DAQmxSetAODACOffsetSrc');
  DAQmxResetAODACOffsetSrc := getProc('DAQmxResetAODACOffsetSrc');
  DAQmxGetAODACOffsetExtSrc := getProc('DAQmxGetAODACOffsetExtSrc');
  DAQmxSetAODACOffsetExtSrc := getProc('DAQmxSetAODACOffsetExtSrc');
  DAQmxResetAODACOffsetExtSrc := getProc('DAQmxResetAODACOffsetExtSrc');
  DAQmxGetAODACOffsetVal := getProc('DAQmxGetAODACOffsetVal');
  DAQmxSetAODACOffsetVal := getProc('DAQmxSetAODACOffsetVal');
  DAQmxResetAODACOffsetVal := getProc('DAQmxResetAODACOffsetVal');
  DAQmxGetAOReglitchEnable := getProc('DAQmxGetAOReglitchEnable_VB6');
  DAQmxSetAOReglitchEnable := getProc('DAQmxSetAOReglitchEnable');
  DAQmxResetAOReglitchEnable := getProc('DAQmxResetAOReglitchEnable');
  DAQmxGetAOGain := getProc('DAQmxGetAOGain');
  DAQmxSetAOGain := getProc('DAQmxSetAOGain');
  DAQmxResetAOGain := getProc('DAQmxResetAOGain');
  DAQmxGetAOUseOnlyOnBrdMem := getProc('DAQmxGetAOUseOnlyOnBrdMem_VB6');
  DAQmxSetAOUseOnlyOnBrdMem := getProc('DAQmxSetAOUseOnlyOnBrdMem');
  DAQmxResetAOUseOnlyOnBrdMem := getProc('DAQmxResetAOUseOnlyOnBrdMem');
  DAQmxGetAODataXferMech := getProc('DAQmxGetAODataXferMech');
  DAQmxSetAODataXferMech := getProc('DAQmxSetAODataXferMech');
  DAQmxResetAODataXferMech := getProc('DAQmxResetAODataXferMech');
  DAQmxGetAODataXferReqCond := getProc('DAQmxGetAODataXferReqCond');
  DAQmxSetAODataXferReqCond := getProc('DAQmxSetAODataXferReqCond');
  DAQmxResetAODataXferReqCond := getProc('DAQmxResetAODataXferReqCond');
  DAQmxGetAOMemMapEnable := getProc('DAQmxGetAOMemMapEnable_VB6');
  DAQmxSetAOMemMapEnable := getProc('DAQmxSetAOMemMapEnable');
  DAQmxResetAOMemMapEnable := getProc('DAQmxResetAOMemMapEnable');
  DAQmxGetAODevScalingCoeff := getProc('DAQmxGetAODevScalingCoeff');
  DAQmxGetAOEnhancedImageRejectionEnable := getProc('DAQmxGetAOEnhancedImageRejectionEnable_VB6');
  DAQmxSetAOEnhancedImageRejectionEnable := getProc('DAQmxSetAOEnhancedImageRejectionEnable');
  DAQmxResetAOEnhancedImageRejectionEnable := getProc('DAQmxResetAOEnhancedImageRejectionEnable');
  DAQmxGetDIInvertLines := getProc('DAQmxGetDIInvertLines_VB6');
  DAQmxSetDIInvertLines := getProc('DAQmxSetDIInvertLines');
  DAQmxResetDIInvertLines := getProc('DAQmxResetDIInvertLines');
  DAQmxGetDINumLines := getProc('DAQmxGetDINumLines');
  DAQmxGetDIDigFltrEnable := getProc('DAQmxGetDIDigFltrEnable_VB6');
  DAQmxSetDIDigFltrEnable := getProc('DAQmxSetDIDigFltrEnable');
  DAQmxResetDIDigFltrEnable := getProc('DAQmxResetDIDigFltrEnable');
  DAQmxGetDIDigFltrMinPulseWidth := getProc('DAQmxGetDIDigFltrMinPulseWidth');
  DAQmxSetDIDigFltrMinPulseWidth := getProc('DAQmxSetDIDigFltrMinPulseWidth');
  DAQmxResetDIDigFltrMinPulseWidth := getProc('DAQmxResetDIDigFltrMinPulseWidth');
  DAQmxGetDITristate := getProc('DAQmxGetDITristate_VB6');
  DAQmxSetDITristate := getProc('DAQmxSetDITristate');
  DAQmxResetDITristate := getProc('DAQmxResetDITristate');
  DAQmxGetDILogicFamily := getProc('DAQmxGetDILogicFamily');
  DAQmxSetDILogicFamily := getProc('DAQmxSetDILogicFamily');
  DAQmxResetDILogicFamily := getProc('DAQmxResetDILogicFamily');
  DAQmxGetDIDataXferMech := getProc('DAQmxGetDIDataXferMech');
  DAQmxSetDIDataXferMech := getProc('DAQmxSetDIDataXferMech');
  DAQmxResetDIDataXferMech := getProc('DAQmxResetDIDataXferMech');
  DAQmxGetDIDataXferReqCond := getProc('DAQmxGetDIDataXferReqCond');
  DAQmxSetDIDataXferReqCond := getProc('DAQmxSetDIDataXferReqCond');
  DAQmxResetDIDataXferReqCond := getProc('DAQmxResetDIDataXferReqCond');
  DAQmxGetDIMemMapEnable := getProc('DAQmxGetDIMemMapEnable_VB6');
  DAQmxSetDIMemMapEnable := getProc('DAQmxSetDIMemMapEnable');
  DAQmxResetDIMemMapEnable := getProc('DAQmxResetDIMemMapEnable');
  DAQmxGetDIAcquireOn := getProc('DAQmxGetDIAcquireOn');
  DAQmxSetDIAcquireOn := getProc('DAQmxSetDIAcquireOn');
  DAQmxResetDIAcquireOn := getProc('DAQmxResetDIAcquireOn');
  DAQmxGetDOOutputDriveType := getProc('DAQmxGetDOOutputDriveType');
  DAQmxSetDOOutputDriveType := getProc('DAQmxSetDOOutputDriveType');
  DAQmxResetDOOutputDriveType := getProc('DAQmxResetDOOutputDriveType');
  DAQmxGetDOInvertLines := getProc('DAQmxGetDOInvertLines_VB6');
  DAQmxSetDOInvertLines := getProc('DAQmxSetDOInvertLines');
  DAQmxResetDOInvertLines := getProc('DAQmxResetDOInvertLines');
  DAQmxGetDONumLines := getProc('DAQmxGetDONumLines');
  DAQmxGetDOTristate := getProc('DAQmxGetDOTristate_VB6');
  DAQmxSetDOTristate := getProc('DAQmxSetDOTristate');
  DAQmxResetDOTristate := getProc('DAQmxResetDOTristate');
  DAQmxGetDOLineStatesStartState := getProc('DAQmxGetDOLineStatesStartState');
  DAQmxSetDOLineStatesStartState := getProc('DAQmxSetDOLineStatesStartState');
  DAQmxResetDOLineStatesStartState := getProc('DAQmxResetDOLineStatesStartState');
  DAQmxGetDOLineStatesPausedState := getProc('DAQmxGetDOLineStatesPausedState');
  DAQmxSetDOLineStatesPausedState := getProc('DAQmxSetDOLineStatesPausedState');
  DAQmxResetDOLineStatesPausedState := getProc('DAQmxResetDOLineStatesPausedState');
  DAQmxGetDOLineStatesDoneState := getProc('DAQmxGetDOLineStatesDoneState');
  DAQmxSetDOLineStatesDoneState := getProc('DAQmxSetDOLineStatesDoneState');
  DAQmxResetDOLineStatesDoneState := getProc('DAQmxResetDOLineStatesDoneState');
  DAQmxGetDOLogicFamily := getProc('DAQmxGetDOLogicFamily');
  DAQmxSetDOLogicFamily := getProc('DAQmxSetDOLogicFamily');
  DAQmxResetDOLogicFamily := getProc('DAQmxResetDOLogicFamily');
  DAQmxGetDOUseOnlyOnBrdMem := getProc('DAQmxGetDOUseOnlyOnBrdMem_VB6');
  DAQmxSetDOUseOnlyOnBrdMem := getProc('DAQmxSetDOUseOnlyOnBrdMem');
  DAQmxResetDOUseOnlyOnBrdMem := getProc('DAQmxResetDOUseOnlyOnBrdMem');
  DAQmxGetDODataXferMech := getProc('DAQmxGetDODataXferMech');
  DAQmxSetDODataXferMech := getProc('DAQmxSetDODataXferMech');
  DAQmxResetDODataXferMech := getProc('DAQmxResetDODataXferMech');
  DAQmxGetDODataXferReqCond := getProc('DAQmxGetDODataXferReqCond');
  DAQmxSetDODataXferReqCond := getProc('DAQmxSetDODataXferReqCond');
  DAQmxResetDODataXferReqCond := getProc('DAQmxResetDODataXferReqCond');
  DAQmxGetDOMemMapEnable := getProc('DAQmxGetDOMemMapEnable_VB6');
  DAQmxSetDOMemMapEnable := getProc('DAQmxSetDOMemMapEnable');
  DAQmxResetDOMemMapEnable := getProc('DAQmxResetDOMemMapEnable');
  DAQmxGetDOGenerateOn := getProc('DAQmxGetDOGenerateOn');
  DAQmxSetDOGenerateOn := getProc('DAQmxSetDOGenerateOn');
  DAQmxResetDOGenerateOn := getProc('DAQmxResetDOGenerateOn');
  DAQmxGetCIMax := getProc('DAQmxGetCIMax');
  DAQmxSetCIMax := getProc('DAQmxSetCIMax');
  DAQmxResetCIMax := getProc('DAQmxResetCIMax');
  DAQmxGetCIMin := getProc('DAQmxGetCIMin');
  DAQmxSetCIMin := getProc('DAQmxSetCIMin');
  DAQmxResetCIMin := getProc('DAQmxResetCIMin');
  DAQmxGetCICustomScaleName := getProc('DAQmxGetCICustomScaleName');
  DAQmxSetCICustomScaleName := getProc('DAQmxSetCICustomScaleName');
  DAQmxResetCICustomScaleName := getProc('DAQmxResetCICustomScaleName');
  DAQmxGetCIMeasType := getProc('DAQmxGetCIMeasType');
  DAQmxGetCIFreqUnits := getProc('DAQmxGetCIFreqUnits');
  DAQmxSetCIFreqUnits := getProc('DAQmxSetCIFreqUnits');
  DAQmxResetCIFreqUnits := getProc('DAQmxResetCIFreqUnits');
  DAQmxGetCIFreqTerm := getProc('DAQmxGetCIFreqTerm');
  DAQmxSetCIFreqTerm := getProc('DAQmxSetCIFreqTerm');
  DAQmxResetCIFreqTerm := getProc('DAQmxResetCIFreqTerm');
  DAQmxGetCIFreqStartingEdge := getProc('DAQmxGetCIFreqStartingEdge');
  DAQmxSetCIFreqStartingEdge := getProc('DAQmxSetCIFreqStartingEdge');
  DAQmxResetCIFreqStartingEdge := getProc('DAQmxResetCIFreqStartingEdge');
  DAQmxGetCIFreqMeasMeth := getProc('DAQmxGetCIFreqMeasMeth');
  DAQmxSetCIFreqMeasMeth := getProc('DAQmxSetCIFreqMeasMeth');
  DAQmxResetCIFreqMeasMeth := getProc('DAQmxResetCIFreqMeasMeth');
  DAQmxGetCIFreqMeasTime := getProc('DAQmxGetCIFreqMeasTime');
  DAQmxSetCIFreqMeasTime := getProc('DAQmxSetCIFreqMeasTime');
  DAQmxResetCIFreqMeasTime := getProc('DAQmxResetCIFreqMeasTime');
  DAQmxGetCIFreqDiv := getProc('DAQmxGetCIFreqDiv');
  DAQmxSetCIFreqDiv := getProc('DAQmxSetCIFreqDiv');
  DAQmxResetCIFreqDiv := getProc('DAQmxResetCIFreqDiv');
  DAQmxGetCIFreqDigFltrEnable := getProc('DAQmxGetCIFreqDigFltrEnable_VB6');
  DAQmxSetCIFreqDigFltrEnable := getProc('DAQmxSetCIFreqDigFltrEnable');
  DAQmxResetCIFreqDigFltrEnable := getProc('DAQmxResetCIFreqDigFltrEnable');
  DAQmxGetCIFreqDigFltrMinPulseWidth := getProc('DAQmxGetCIFreqDigFltrMinPulseWidth');
  DAQmxSetCIFreqDigFltrMinPulseWidth := getProc('DAQmxSetCIFreqDigFltrMinPulseWidth');
  DAQmxResetCIFreqDigFltrMinPulseWidth := getProc('DAQmxResetCIFreqDigFltrMinPulseWidth');
  DAQmxGetCIFreqDigFltrTimebaseSrc := getProc('DAQmxGetCIFreqDigFltrTimebaseSrc');
  DAQmxSetCIFreqDigFltrTimebaseSrc := getProc('DAQmxSetCIFreqDigFltrTimebaseSrc');
  DAQmxResetCIFreqDigFltrTimebaseSrc := getProc('DAQmxResetCIFreqDigFltrTimebaseSrc');
  DAQmxGetCIFreqDigFltrTimebaseRate := getProc('DAQmxGetCIFreqDigFltrTimebaseRate');
  DAQmxSetCIFreqDigFltrTimebaseRate := getProc('DAQmxSetCIFreqDigFltrTimebaseRate');
  DAQmxResetCIFreqDigFltrTimebaseRate := getProc('DAQmxResetCIFreqDigFltrTimebaseRate');
  DAQmxGetCIFreqDigSyncEnable := getProc('DAQmxGetCIFreqDigSyncEnable_VB6');
  DAQmxSetCIFreqDigSyncEnable := getProc('DAQmxSetCIFreqDigSyncEnable');
  DAQmxResetCIFreqDigSyncEnable := getProc('DAQmxResetCIFreqDigSyncEnable');
  DAQmxGetCIPeriodUnits := getProc('DAQmxGetCIPeriodUnits');
  DAQmxSetCIPeriodUnits := getProc('DAQmxSetCIPeriodUnits');
  DAQmxResetCIPeriodUnits := getProc('DAQmxResetCIPeriodUnits');
  DAQmxGetCIPeriodTerm := getProc('DAQmxGetCIPeriodTerm');
  DAQmxSetCIPeriodTerm := getProc('DAQmxSetCIPeriodTerm');
  DAQmxResetCIPeriodTerm := getProc('DAQmxResetCIPeriodTerm');
  DAQmxGetCIPeriodStartingEdge := getProc('DAQmxGetCIPeriodStartingEdge');
  DAQmxSetCIPeriodStartingEdge := getProc('DAQmxSetCIPeriodStartingEdge');
  DAQmxResetCIPeriodStartingEdge := getProc('DAQmxResetCIPeriodStartingEdge');
  DAQmxGetCIPeriodMeasMeth := getProc('DAQmxGetCIPeriodMeasMeth');
  DAQmxSetCIPeriodMeasMeth := getProc('DAQmxSetCIPeriodMeasMeth');
  DAQmxResetCIPeriodMeasMeth := getProc('DAQmxResetCIPeriodMeasMeth');
  DAQmxGetCIPeriodMeasTime := getProc('DAQmxGetCIPeriodMeasTime');
  DAQmxSetCIPeriodMeasTime := getProc('DAQmxSetCIPeriodMeasTime');
  DAQmxResetCIPeriodMeasTime := getProc('DAQmxResetCIPeriodMeasTime');
  DAQmxGetCIPeriodDiv := getProc('DAQmxGetCIPeriodDiv');
  DAQmxSetCIPeriodDiv := getProc('DAQmxSetCIPeriodDiv');
  DAQmxResetCIPeriodDiv := getProc('DAQmxResetCIPeriodDiv');
  DAQmxGetCIPeriodDigFltrEnable := getProc('DAQmxGetCIPeriodDigFltrEnable_VB6');
  DAQmxSetCIPeriodDigFltrEnable := getProc('DAQmxSetCIPeriodDigFltrEnable');
  DAQmxResetCIPeriodDigFltrEnable := getProc('DAQmxResetCIPeriodDigFltrEnable');
  DAQmxGetCIPeriodDigFltrMinPulseWidth := getProc('DAQmxGetCIPeriodDigFltrMinPulseWidth');
  DAQmxSetCIPeriodDigFltrMinPulseWidth := getProc('DAQmxSetCIPeriodDigFltrMinPulseWidth');
  DAQmxResetCIPeriodDigFltrMinPulseWidth := getProc('DAQmxResetCIPeriodDigFltrMinPulseWidth');
  DAQmxGetCIPeriodDigFltrTimebaseSrc := getProc('DAQmxGetCIPeriodDigFltrTimebaseSrc');
  DAQmxSetCIPeriodDigFltrTimebaseSrc := getProc('DAQmxSetCIPeriodDigFltrTimebaseSrc');
  DAQmxResetCIPeriodDigFltrTimebaseSrc := getProc('DAQmxResetCIPeriodDigFltrTimebaseSrc');
  DAQmxGetCIPeriodDigFltrTimebaseRate := getProc('DAQmxGetCIPeriodDigFltrTimebaseRate');
  DAQmxSetCIPeriodDigFltrTimebaseRate := getProc('DAQmxSetCIPeriodDigFltrTimebaseRate');
  DAQmxResetCIPeriodDigFltrTimebaseRate := getProc('DAQmxResetCIPeriodDigFltrTimebaseRate');
  DAQmxGetCIPeriodDigSyncEnable := getProc('DAQmxGetCIPeriodDigSyncEnable_VB6');
  DAQmxSetCIPeriodDigSyncEnable := getProc('DAQmxSetCIPeriodDigSyncEnable');
  DAQmxResetCIPeriodDigSyncEnable := getProc('DAQmxResetCIPeriodDigSyncEnable');
  DAQmxGetCICountEdgesTerm := getProc('DAQmxGetCICountEdgesTerm');
  DAQmxSetCICountEdgesTerm := getProc('DAQmxSetCICountEdgesTerm');
  DAQmxResetCICountEdgesTerm := getProc('DAQmxResetCICountEdgesTerm');
  DAQmxGetCICountEdgesDir := getProc('DAQmxGetCICountEdgesDir');
  DAQmxSetCICountEdgesDir := getProc('DAQmxSetCICountEdgesDir');
  DAQmxResetCICountEdgesDir := getProc('DAQmxResetCICountEdgesDir');
  DAQmxGetCICountEdgesDirTerm := getProc('DAQmxGetCICountEdgesDirTerm');
  DAQmxSetCICountEdgesDirTerm := getProc('DAQmxSetCICountEdgesDirTerm');
  DAQmxResetCICountEdgesDirTerm := getProc('DAQmxResetCICountEdgesDirTerm');
  DAQmxGetCICountEdgesCountDirDigFltrEnable := getProc('DAQmxGetCICountEdgesCountDirDigFltrEnable_VB6');
  DAQmxSetCICountEdgesCountDirDigFltrEnable := getProc('DAQmxSetCICountEdgesCountDirDigFltrEnable');
  DAQmxResetCICountEdgesCountDirDigFltrEnable := getProc('DAQmxResetCICountEdgesCountDirDigFltrEnable');
  DAQmxGetCICountEdgesCountDirDigFltrMinPulseWidth := getProc('DAQmxGetCICountEdgesCountDirDigFltrMinPulseWidth');
  DAQmxSetCICountEdgesCountDirDigFltrMinPulseWidth := getProc('DAQmxSetCICountEdgesCountDirDigFltrMinPulseWidth');
  DAQmxResetCICountEdgesCountDirDigFltrMinPulseWidth := getProc('DAQmxResetCICountEdgesCountDirDigFltrMinPulseWidth');
  DAQmxGetCICountEdgesCountDirDigFltrTimebaseSrc := getProc('DAQmxGetCICountEdgesCountDirDigFltrTimebaseSrc');
  DAQmxSetCICountEdgesCountDirDigFltrTimebaseSrc := getProc('DAQmxSetCICountEdgesCountDirDigFltrTimebaseSrc');
  DAQmxResetCICountEdgesCountDirDigFltrTimebaseSrc := getProc('DAQmxResetCICountEdgesCountDirDigFltrTimebaseSrc');
  DAQmxGetCICountEdgesCountDirDigFltrTimebaseRate := getProc('DAQmxGetCICountEdgesCountDirDigFltrTimebaseRate');
  DAQmxSetCICountEdgesCountDirDigFltrTimebaseRate := getProc('DAQmxSetCICountEdgesCountDirDigFltrTimebaseRate');
  DAQmxResetCICountEdgesCountDirDigFltrTimebaseRate := getProc('DAQmxResetCICountEdgesCountDirDigFltrTimebaseRate');
  DAQmxGetCICountEdgesCountDirDigSyncEnable := getProc('DAQmxGetCICountEdgesCountDirDigSyncEnable_VB6');
  DAQmxSetCICountEdgesCountDirDigSyncEnable := getProc('DAQmxSetCICountEdgesCountDirDigSyncEnable');
  DAQmxResetCICountEdgesCountDirDigSyncEnable := getProc('DAQmxResetCICountEdgesCountDirDigSyncEnable');
  DAQmxGetCICountEdgesInitialCnt := getProc('DAQmxGetCICountEdgesInitialCnt');
  DAQmxSetCICountEdgesInitialCnt := getProc('DAQmxSetCICountEdgesInitialCnt');
  DAQmxResetCICountEdgesInitialCnt := getProc('DAQmxResetCICountEdgesInitialCnt');
  DAQmxGetCICountEdgesActiveEdge := getProc('DAQmxGetCICountEdgesActiveEdge');
  DAQmxSetCICountEdgesActiveEdge := getProc('DAQmxSetCICountEdgesActiveEdge');
  DAQmxResetCICountEdgesActiveEdge := getProc('DAQmxResetCICountEdgesActiveEdge');
  DAQmxGetCICountEdgesDigFltrEnable := getProc('DAQmxGetCICountEdgesDigFltrEnable_VB6');
  DAQmxSetCICountEdgesDigFltrEnable := getProc('DAQmxSetCICountEdgesDigFltrEnable');
  DAQmxResetCICountEdgesDigFltrEnable := getProc('DAQmxResetCICountEdgesDigFltrEnable');
  DAQmxGetCICountEdgesDigFltrMinPulseWidth := getProc('DAQmxGetCICountEdgesDigFltrMinPulseWidth');
  DAQmxSetCICountEdgesDigFltrMinPulseWidth := getProc('DAQmxSetCICountEdgesDigFltrMinPulseWidth');
  DAQmxResetCICountEdgesDigFltrMinPulseWidth := getProc('DAQmxResetCICountEdgesDigFltrMinPulseWidth');
  DAQmxGetCICountEdgesDigFltrTimebaseSrc := getProc('DAQmxGetCICountEdgesDigFltrTimebaseSrc');
  DAQmxSetCICountEdgesDigFltrTimebaseSrc := getProc('DAQmxSetCICountEdgesDigFltrTimebaseSrc');
  DAQmxResetCICountEdgesDigFltrTimebaseSrc := getProc('DAQmxResetCICountEdgesDigFltrTimebaseSrc');
  DAQmxGetCICountEdgesDigFltrTimebaseRate := getProc('DAQmxGetCICountEdgesDigFltrTimebaseRate');
  DAQmxSetCICountEdgesDigFltrTimebaseRate := getProc('DAQmxSetCICountEdgesDigFltrTimebaseRate');
  DAQmxResetCICountEdgesDigFltrTimebaseRate := getProc('DAQmxResetCICountEdgesDigFltrTimebaseRate');
  DAQmxGetCICountEdgesDigSyncEnable := getProc('DAQmxGetCICountEdgesDigSyncEnable_VB6');
  DAQmxSetCICountEdgesDigSyncEnable := getProc('DAQmxSetCICountEdgesDigSyncEnable');
  DAQmxResetCICountEdgesDigSyncEnable := getProc('DAQmxResetCICountEdgesDigSyncEnable');
  DAQmxGetCIAngEncoderUnits := getProc('DAQmxGetCIAngEncoderUnits');
  DAQmxSetCIAngEncoderUnits := getProc('DAQmxSetCIAngEncoderUnits');
  DAQmxResetCIAngEncoderUnits := getProc('DAQmxResetCIAngEncoderUnits');
  DAQmxGetCIAngEncoderPulsesPerRev := getProc('DAQmxGetCIAngEncoderPulsesPerRev');
  DAQmxSetCIAngEncoderPulsesPerRev := getProc('DAQmxSetCIAngEncoderPulsesPerRev');
  DAQmxResetCIAngEncoderPulsesPerRev := getProc('DAQmxResetCIAngEncoderPulsesPerRev');
  DAQmxGetCIAngEncoderInitialAngle := getProc('DAQmxGetCIAngEncoderInitialAngle');
  DAQmxSetCIAngEncoderInitialAngle := getProc('DAQmxSetCIAngEncoderInitialAngle');
  DAQmxResetCIAngEncoderInitialAngle := getProc('DAQmxResetCIAngEncoderInitialAngle');
  DAQmxGetCILinEncoderUnits := getProc('DAQmxGetCILinEncoderUnits');
  DAQmxSetCILinEncoderUnits := getProc('DAQmxSetCILinEncoderUnits');
  DAQmxResetCILinEncoderUnits := getProc('DAQmxResetCILinEncoderUnits');
  DAQmxGetCILinEncoderDistPerPulse := getProc('DAQmxGetCILinEncoderDistPerPulse');
  DAQmxSetCILinEncoderDistPerPulse := getProc('DAQmxSetCILinEncoderDistPerPulse');
  DAQmxResetCILinEncoderDistPerPulse := getProc('DAQmxResetCILinEncoderDistPerPulse');
  DAQmxGetCILinEncoderInitialPos := getProc('DAQmxGetCILinEncoderInitialPos');
  DAQmxSetCILinEncoderInitialPos := getProc('DAQmxSetCILinEncoderInitialPos');
  DAQmxResetCILinEncoderInitialPos := getProc('DAQmxResetCILinEncoderInitialPos');
  DAQmxGetCIEncoderDecodingType := getProc('DAQmxGetCIEncoderDecodingType');
  DAQmxSetCIEncoderDecodingType := getProc('DAQmxSetCIEncoderDecodingType');
  DAQmxResetCIEncoderDecodingType := getProc('DAQmxResetCIEncoderDecodingType');
  DAQmxGetCIEncoderAInputTerm := getProc('DAQmxGetCIEncoderAInputTerm');
  DAQmxSetCIEncoderAInputTerm := getProc('DAQmxSetCIEncoderAInputTerm');
  DAQmxResetCIEncoderAInputTerm := getProc('DAQmxResetCIEncoderAInputTerm');
  DAQmxGetCIEncoderAInputDigFltrEnable := getProc('DAQmxGetCIEncoderAInputDigFltrEnable_VB6');
  DAQmxSetCIEncoderAInputDigFltrEnable := getProc('DAQmxSetCIEncoderAInputDigFltrEnable');
  DAQmxResetCIEncoderAInputDigFltrEnable := getProc('DAQmxResetCIEncoderAInputDigFltrEnable');
  DAQmxGetCIEncoderAInputDigFltrMinPulseWidth := getProc('DAQmxGetCIEncoderAInputDigFltrMinPulseWidth');
  DAQmxSetCIEncoderAInputDigFltrMinPulseWidth := getProc('DAQmxSetCIEncoderAInputDigFltrMinPulseWidth');
  DAQmxResetCIEncoderAInputDigFltrMinPulseWidth := getProc('DAQmxResetCIEncoderAInputDigFltrMinPulseWidth');
  DAQmxGetCIEncoderAInputDigFltrTimebaseSrc := getProc('DAQmxGetCIEncoderAInputDigFltrTimebaseSrc');
  DAQmxSetCIEncoderAInputDigFltrTimebaseSrc := getProc('DAQmxSetCIEncoderAInputDigFltrTimebaseSrc');
  DAQmxResetCIEncoderAInputDigFltrTimebaseSrc := getProc('DAQmxResetCIEncoderAInputDigFltrTimebaseSrc');
  DAQmxGetCIEncoderAInputDigFltrTimebaseRate := getProc('DAQmxGetCIEncoderAInputDigFltrTimebaseRate');
  DAQmxSetCIEncoderAInputDigFltrTimebaseRate := getProc('DAQmxSetCIEncoderAInputDigFltrTimebaseRate');
  DAQmxResetCIEncoderAInputDigFltrTimebaseRate := getProc('DAQmxResetCIEncoderAInputDigFltrTimebaseRate');
  DAQmxGetCIEncoderAInputDigSyncEnable := getProc('DAQmxGetCIEncoderAInputDigSyncEnable_VB6');
  DAQmxSetCIEncoderAInputDigSyncEnable := getProc('DAQmxSetCIEncoderAInputDigSyncEnable');
  DAQmxResetCIEncoderAInputDigSyncEnable := getProc('DAQmxResetCIEncoderAInputDigSyncEnable');
  DAQmxGetCIEncoderBInputTerm := getProc('DAQmxGetCIEncoderBInputTerm');
  DAQmxSetCIEncoderBInputTerm := getProc('DAQmxSetCIEncoderBInputTerm');
  DAQmxResetCIEncoderBInputTerm := getProc('DAQmxResetCIEncoderBInputTerm');
  DAQmxGetCIEncoderBInputDigFltrEnable := getProc('DAQmxGetCIEncoderBInputDigFltrEnable_VB6');
  DAQmxSetCIEncoderBInputDigFltrEnable := getProc('DAQmxSetCIEncoderBInputDigFltrEnable');
  DAQmxResetCIEncoderBInputDigFltrEnable := getProc('DAQmxResetCIEncoderBInputDigFltrEnable');
  DAQmxGetCIEncoderBInputDigFltrMinPulseWidth := getProc('DAQmxGetCIEncoderBInputDigFltrMinPulseWidth');
  DAQmxSetCIEncoderBInputDigFltrMinPulseWidth := getProc('DAQmxSetCIEncoderBInputDigFltrMinPulseWidth');
  DAQmxResetCIEncoderBInputDigFltrMinPulseWidth := getProc('DAQmxResetCIEncoderBInputDigFltrMinPulseWidth');
  DAQmxGetCIEncoderBInputDigFltrTimebaseSrc := getProc('DAQmxGetCIEncoderBInputDigFltrTimebaseSrc');
  DAQmxSetCIEncoderBInputDigFltrTimebaseSrc := getProc('DAQmxSetCIEncoderBInputDigFltrTimebaseSrc');
  DAQmxResetCIEncoderBInputDigFltrTimebaseSrc := getProc('DAQmxResetCIEncoderBInputDigFltrTimebaseSrc');
  DAQmxGetCIEncoderBInputDigFltrTimebaseRate := getProc('DAQmxGetCIEncoderBInputDigFltrTimebaseRate');
  DAQmxSetCIEncoderBInputDigFltrTimebaseRate := getProc('DAQmxSetCIEncoderBInputDigFltrTimebaseRate');
  DAQmxResetCIEncoderBInputDigFltrTimebaseRate := getProc('DAQmxResetCIEncoderBInputDigFltrTimebaseRate');
  DAQmxGetCIEncoderBInputDigSyncEnable := getProc('DAQmxGetCIEncoderBInputDigSyncEnable_VB6');
  DAQmxSetCIEncoderBInputDigSyncEnable := getProc('DAQmxSetCIEncoderBInputDigSyncEnable');
  DAQmxResetCIEncoderBInputDigSyncEnable := getProc('DAQmxResetCIEncoderBInputDigSyncEnable');
  DAQmxGetCIEncoderZInputTerm := getProc('DAQmxGetCIEncoderZInputTerm');
  DAQmxSetCIEncoderZInputTerm := getProc('DAQmxSetCIEncoderZInputTerm');
  DAQmxResetCIEncoderZInputTerm := getProc('DAQmxResetCIEncoderZInputTerm');
  DAQmxGetCIEncoderZInputDigFltrEnable := getProc('DAQmxGetCIEncoderZInputDigFltrEnable_VB6');
  DAQmxSetCIEncoderZInputDigFltrEnable := getProc('DAQmxSetCIEncoderZInputDigFltrEnable');
  DAQmxResetCIEncoderZInputDigFltrEnable := getProc('DAQmxResetCIEncoderZInputDigFltrEnable');
  DAQmxGetCIEncoderZInputDigFltrMinPulseWidth := getProc('DAQmxGetCIEncoderZInputDigFltrMinPulseWidth');
  DAQmxSetCIEncoderZInputDigFltrMinPulseWidth := getProc('DAQmxSetCIEncoderZInputDigFltrMinPulseWidth');
  DAQmxResetCIEncoderZInputDigFltrMinPulseWidth := getProc('DAQmxResetCIEncoderZInputDigFltrMinPulseWidth');
  DAQmxGetCIEncoderZInputDigFltrTimebaseSrc := getProc('DAQmxGetCIEncoderZInputDigFltrTimebaseSrc');
  DAQmxSetCIEncoderZInputDigFltrTimebaseSrc := getProc('DAQmxSetCIEncoderZInputDigFltrTimebaseSrc');
  DAQmxResetCIEncoderZInputDigFltrTimebaseSrc := getProc('DAQmxResetCIEncoderZInputDigFltrTimebaseSrc');
  DAQmxGetCIEncoderZInputDigFltrTimebaseRate := getProc('DAQmxGetCIEncoderZInputDigFltrTimebaseRate');
  DAQmxSetCIEncoderZInputDigFltrTimebaseRate := getProc('DAQmxSetCIEncoderZInputDigFltrTimebaseRate');
  DAQmxResetCIEncoderZInputDigFltrTimebaseRate := getProc('DAQmxResetCIEncoderZInputDigFltrTimebaseRate');
  DAQmxGetCIEncoderZInputDigSyncEnable := getProc('DAQmxGetCIEncoderZInputDigSyncEnable_VB6');
  DAQmxSetCIEncoderZInputDigSyncEnable := getProc('DAQmxSetCIEncoderZInputDigSyncEnable');
  DAQmxResetCIEncoderZInputDigSyncEnable := getProc('DAQmxResetCIEncoderZInputDigSyncEnable');
  DAQmxGetCIEncoderZIndexEnable := getProc('DAQmxGetCIEncoderZIndexEnable_VB6');
  DAQmxSetCIEncoderZIndexEnable := getProc('DAQmxSetCIEncoderZIndexEnable');
  DAQmxResetCIEncoderZIndexEnable := getProc('DAQmxResetCIEncoderZIndexEnable');
  DAQmxGetCIEncoderZIndexVal := getProc('DAQmxGetCIEncoderZIndexVal');
  DAQmxSetCIEncoderZIndexVal := getProc('DAQmxSetCIEncoderZIndexVal');
  DAQmxResetCIEncoderZIndexVal := getProc('DAQmxResetCIEncoderZIndexVal');
  DAQmxGetCIEncoderZIndexPhase := getProc('DAQmxGetCIEncoderZIndexPhase');
  DAQmxSetCIEncoderZIndexPhase := getProc('DAQmxSetCIEncoderZIndexPhase');
  DAQmxResetCIEncoderZIndexPhase := getProc('DAQmxResetCIEncoderZIndexPhase');
  DAQmxGetCIPulseWidthUnits := getProc('DAQmxGetCIPulseWidthUnits');
  DAQmxSetCIPulseWidthUnits := getProc('DAQmxSetCIPulseWidthUnits');
  DAQmxResetCIPulseWidthUnits := getProc('DAQmxResetCIPulseWidthUnits');
  DAQmxGetCIPulseWidthTerm := getProc('DAQmxGetCIPulseWidthTerm');
  DAQmxSetCIPulseWidthTerm := getProc('DAQmxSetCIPulseWidthTerm');
  DAQmxResetCIPulseWidthTerm := getProc('DAQmxResetCIPulseWidthTerm');
  DAQmxGetCIPulseWidthStartingEdge := getProc('DAQmxGetCIPulseWidthStartingEdge');
  DAQmxSetCIPulseWidthStartingEdge := getProc('DAQmxSetCIPulseWidthStartingEdge');
  DAQmxResetCIPulseWidthStartingEdge := getProc('DAQmxResetCIPulseWidthStartingEdge');
  DAQmxGetCIPulseWidthDigFltrEnable := getProc('DAQmxGetCIPulseWidthDigFltrEnable_VB6');
  DAQmxSetCIPulseWidthDigFltrEnable := getProc('DAQmxSetCIPulseWidthDigFltrEnable');
  DAQmxResetCIPulseWidthDigFltrEnable := getProc('DAQmxResetCIPulseWidthDigFltrEnable');
  DAQmxGetCIPulseWidthDigFltrMinPulseWidth := getProc('DAQmxGetCIPulseWidthDigFltrMinPulseWidth');
  DAQmxSetCIPulseWidthDigFltrMinPulseWidth := getProc('DAQmxSetCIPulseWidthDigFltrMinPulseWidth');
  DAQmxResetCIPulseWidthDigFltrMinPulseWidth := getProc('DAQmxResetCIPulseWidthDigFltrMinPulseWidth');
  DAQmxGetCIPulseWidthDigFltrTimebaseSrc := getProc('DAQmxGetCIPulseWidthDigFltrTimebaseSrc');
  DAQmxSetCIPulseWidthDigFltrTimebaseSrc := getProc('DAQmxSetCIPulseWidthDigFltrTimebaseSrc');
  DAQmxResetCIPulseWidthDigFltrTimebaseSrc := getProc('DAQmxResetCIPulseWidthDigFltrTimebaseSrc');
  DAQmxGetCIPulseWidthDigFltrTimebaseRate := getProc('DAQmxGetCIPulseWidthDigFltrTimebaseRate');
  DAQmxSetCIPulseWidthDigFltrTimebaseRate := getProc('DAQmxSetCIPulseWidthDigFltrTimebaseRate');
  DAQmxResetCIPulseWidthDigFltrTimebaseRate := getProc('DAQmxResetCIPulseWidthDigFltrTimebaseRate');
  DAQmxGetCIPulseWidthDigSyncEnable := getProc('DAQmxGetCIPulseWidthDigSyncEnable_VB6');
  DAQmxSetCIPulseWidthDigSyncEnable := getProc('DAQmxSetCIPulseWidthDigSyncEnable');
  DAQmxResetCIPulseWidthDigSyncEnable := getProc('DAQmxResetCIPulseWidthDigSyncEnable');
  DAQmxGetCITwoEdgeSepUnits := getProc('DAQmxGetCITwoEdgeSepUnits');
  DAQmxSetCITwoEdgeSepUnits := getProc('DAQmxSetCITwoEdgeSepUnits');
  DAQmxResetCITwoEdgeSepUnits := getProc('DAQmxResetCITwoEdgeSepUnits');
  DAQmxGetCITwoEdgeSepFirstTerm := getProc('DAQmxGetCITwoEdgeSepFirstTerm');
  DAQmxSetCITwoEdgeSepFirstTerm := getProc('DAQmxSetCITwoEdgeSepFirstTerm');
  DAQmxResetCITwoEdgeSepFirstTerm := getProc('DAQmxResetCITwoEdgeSepFirstTerm');
  DAQmxGetCITwoEdgeSepFirstEdge := getProc('DAQmxGetCITwoEdgeSepFirstEdge');
  DAQmxSetCITwoEdgeSepFirstEdge := getProc('DAQmxSetCITwoEdgeSepFirstEdge');
  DAQmxResetCITwoEdgeSepFirstEdge := getProc('DAQmxResetCITwoEdgeSepFirstEdge');
  DAQmxGetCITwoEdgeSepFirstDigFltrEnable := getProc('DAQmxGetCITwoEdgeSepFirstDigFltrEnable_VB6');
  DAQmxSetCITwoEdgeSepFirstDigFltrEnable := getProc('DAQmxSetCITwoEdgeSepFirstDigFltrEnable');
  DAQmxResetCITwoEdgeSepFirstDigFltrEnable := getProc('DAQmxResetCITwoEdgeSepFirstDigFltrEnable');
  DAQmxGetCITwoEdgeSepFirstDigFltrMinPulseWidth := getProc('DAQmxGetCITwoEdgeSepFirstDigFltrMinPulseWidth');
  DAQmxSetCITwoEdgeSepFirstDigFltrMinPulseWidth := getProc('DAQmxSetCITwoEdgeSepFirstDigFltrMinPulseWidth');
  DAQmxResetCITwoEdgeSepFirstDigFltrMinPulseWidth := getProc('DAQmxResetCITwoEdgeSepFirstDigFltrMinPulseWidth');
  DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseSrc := getProc('DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseSrc');
  DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseSrc := getProc('DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseSrc');
  DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseSrc := getProc('DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseSrc');
  DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseRate := getProc('DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseRate');
  DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseRate := getProc('DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseRate');
  DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseRate := getProc('DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseRate');
  DAQmxGetCITwoEdgeSepFirstDigSyncEnable := getProc('DAQmxGetCITwoEdgeSepFirstDigSyncEnable_VB6');
  DAQmxSetCITwoEdgeSepFirstDigSyncEnable := getProc('DAQmxSetCITwoEdgeSepFirstDigSyncEnable');

  DAQmxResetCITwoEdgeSepFirstDigSyncEnable := getProc('DAQmxResetCITwoEdgeSepFirstDigSyncEnable');
  DAQmxGetCITwoEdgeSepSecondTerm := getProc('DAQmxGetCITwoEdgeSepSecondTerm');
  DAQmxSetCITwoEdgeSepSecondTerm := getProc('DAQmxSetCITwoEdgeSepSecondTerm');
  DAQmxResetCITwoEdgeSepSecondTerm := getProc('DAQmxResetCITwoEdgeSepSecondTerm');
  DAQmxGetCITwoEdgeSepSecondEdge := getProc('DAQmxGetCITwoEdgeSepSecondEdge');
  DAQmxSetCITwoEdgeSepSecondEdge := getProc('DAQmxSetCITwoEdgeSepSecondEdge');
  DAQmxResetCITwoEdgeSepSecondEdge := getProc('DAQmxResetCITwoEdgeSepSecondEdge');
  DAQmxGetCITwoEdgeSepSecondDigFltrEnable := getProc('DAQmxGetCITwoEdgeSepSecondDigFltrEnable_VB6');
  DAQmxSetCITwoEdgeSepSecondDigFltrEnable := getProc('DAQmxSetCITwoEdgeSepSecondDigFltrEnable');
  DAQmxResetCITwoEdgeSepSecondDigFltrEnable := getProc('DAQmxResetCITwoEdgeSepSecondDigFltrEnable');
  DAQmxGetCITwoEdgeSepSecondDigFltrMinPulseWidth := getProc('DAQmxGetCITwoEdgeSepSecondDigFltrMinPulseWidth');
  DAQmxSetCITwoEdgeSepSecondDigFltrMinPulseWidth := getProc('DAQmxSetCITwoEdgeSepSecondDigFltrMinPulseWidth');
  DAQmxResetCITwoEdgeSepSecondDigFltrMinPulseWidth := getProc('DAQmxResetCITwoEdgeSepSecondDigFltrMinPulseWidth');
  DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseSrc := getProc('DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseSrc');
  DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseSrc := getProc('DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseSrc');
  DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseSrc := getProc('DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseSrc');
  DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseRate := getProc('DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseRate');
  DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseRate := getProc('DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseRate');
  DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseRate := getProc('DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseRate');
  DAQmxGetCITwoEdgeSepSecondDigSyncEnable := getProc('DAQmxGetCITwoEdgeSepSecondDigSyncEnable_VB6');
  DAQmxSetCITwoEdgeSepSecondDigSyncEnable := getProc('DAQmxSetCITwoEdgeSepSecondDigSyncEnable');
  DAQmxResetCITwoEdgeSepSecondDigSyncEnable := getProc('DAQmxResetCITwoEdgeSepSecondDigSyncEnable');
  DAQmxGetCISemiPeriodUnits := getProc('DAQmxGetCISemiPeriodUnits');
  DAQmxSetCISemiPeriodUnits := getProc('DAQmxSetCISemiPeriodUnits');
  DAQmxResetCISemiPeriodUnits := getProc('DAQmxResetCISemiPeriodUnits');
  DAQmxGetCISemiPeriodTerm := getProc('DAQmxGetCISemiPeriodTerm');
  DAQmxSetCISemiPeriodTerm := getProc('DAQmxSetCISemiPeriodTerm');
  DAQmxResetCISemiPeriodTerm := getProc('DAQmxResetCISemiPeriodTerm');
  DAQmxGetCISemiPeriodStartingEdge := getProc('DAQmxGetCISemiPeriodStartingEdge');
  DAQmxSetCISemiPeriodStartingEdge := getProc('DAQmxSetCISemiPeriodStartingEdge');
  DAQmxResetCISemiPeriodStartingEdge := getProc('DAQmxResetCISemiPeriodStartingEdge');
  DAQmxGetCISemiPeriodDigFltrEnable := getProc('DAQmxGetCISemiPeriodDigFltrEnable_VB6');
  DAQmxSetCISemiPeriodDigFltrEnable := getProc('DAQmxSetCISemiPeriodDigFltrEnable');
  DAQmxResetCISemiPeriodDigFltrEnable := getProc('DAQmxResetCISemiPeriodDigFltrEnable');
  DAQmxGetCISemiPeriodDigFltrMinPulseWidth := getProc('DAQmxGetCISemiPeriodDigFltrMinPulseWidth');
  DAQmxSetCISemiPeriodDigFltrMinPulseWidth := getProc('DAQmxSetCISemiPeriodDigFltrMinPulseWidth');
  DAQmxResetCISemiPeriodDigFltrMinPulseWidth := getProc('DAQmxResetCISemiPeriodDigFltrMinPulseWidth');
  DAQmxGetCISemiPeriodDigFltrTimebaseSrc := getProc('DAQmxGetCISemiPeriodDigFltrTimebaseSrc');
  DAQmxSetCISemiPeriodDigFltrTimebaseSrc := getProc('DAQmxSetCISemiPeriodDigFltrTimebaseSrc');
  DAQmxResetCISemiPeriodDigFltrTimebaseSrc := getProc('DAQmxResetCISemiPeriodDigFltrTimebaseSrc');
  DAQmxGetCISemiPeriodDigFltrTimebaseRate := getProc('DAQmxGetCISemiPeriodDigFltrTimebaseRate');
  DAQmxSetCISemiPeriodDigFltrTimebaseRate := getProc('DAQmxSetCISemiPeriodDigFltrTimebaseRate');
  DAQmxResetCISemiPeriodDigFltrTimebaseRate := getProc('DAQmxResetCISemiPeriodDigFltrTimebaseRate');
  DAQmxGetCISemiPeriodDigSyncEnable := getProc('DAQmxGetCISemiPeriodDigSyncEnable_VB6');
  DAQmxSetCISemiPeriodDigSyncEnable := getProc('DAQmxSetCISemiPeriodDigSyncEnable');
  DAQmxResetCISemiPeriodDigSyncEnable := getProc('DAQmxResetCISemiPeriodDigSyncEnable');
  DAQmxGetCITimestampUnits := getProc('DAQmxGetCITimestampUnits');
  DAQmxSetCITimestampUnits := getProc('DAQmxSetCITimestampUnits');
  DAQmxResetCITimestampUnits := getProc('DAQmxResetCITimestampUnits');
  DAQmxGetCITimestampInitialSeconds := getProc('DAQmxGetCITimestampInitialSeconds');
  DAQmxSetCITimestampInitialSeconds := getProc('DAQmxSetCITimestampInitialSeconds');
  DAQmxResetCITimestampInitialSeconds := getProc('DAQmxResetCITimestampInitialSeconds');
  DAQmxGetCIGPSSyncMethod := getProc('DAQmxGetCIGPSSyncMethod');
  DAQmxSetCIGPSSyncMethod := getProc('DAQmxSetCIGPSSyncMethod');
  DAQmxResetCIGPSSyncMethod := getProc('DAQmxResetCIGPSSyncMethod');
  DAQmxGetCIGPSSyncSrc := getProc('DAQmxGetCIGPSSyncSrc');
  DAQmxSetCIGPSSyncSrc := getProc('DAQmxSetCIGPSSyncSrc');
  DAQmxResetCIGPSSyncSrc := getProc('DAQmxResetCIGPSSyncSrc');
  DAQmxGetCICtrTimebaseSrc := getProc('DAQmxGetCICtrTimebaseSrc');
  DAQmxSetCICtrTimebaseSrc := getProc('DAQmxSetCICtrTimebaseSrc');
  DAQmxResetCICtrTimebaseSrc := getProc('DAQmxResetCICtrTimebaseSrc');
  DAQmxGetCICtrTimebaseRate := getProc('DAQmxGetCICtrTimebaseRate');
  DAQmxSetCICtrTimebaseRate := getProc('DAQmxSetCICtrTimebaseRate');
  DAQmxResetCICtrTimebaseRate := getProc('DAQmxResetCICtrTimebaseRate');
  DAQmxGetCICtrTimebaseActiveEdge := getProc('DAQmxGetCICtrTimebaseActiveEdge');
  DAQmxSetCICtrTimebaseActiveEdge := getProc('DAQmxSetCICtrTimebaseActiveEdge');
  DAQmxResetCICtrTimebaseActiveEdge := getProc('DAQmxResetCICtrTimebaseActiveEdge');
  DAQmxGetCICtrTimebaseDigFltrEnable := getProc('DAQmxGetCICtrTimebaseDigFltrEnable_VB6');
  DAQmxSetCICtrTimebaseDigFltrEnable := getProc('DAQmxSetCICtrTimebaseDigFltrEnable');
  DAQmxResetCICtrTimebaseDigFltrEnable := getProc('DAQmxResetCICtrTimebaseDigFltrEnable');
  DAQmxGetCICtrTimebaseDigFltrMinPulseWidth := getProc('DAQmxGetCICtrTimebaseDigFltrMinPulseWidth');
  DAQmxSetCICtrTimebaseDigFltrMinPulseWidth := getProc('DAQmxSetCICtrTimebaseDigFltrMinPulseWidth');
  DAQmxResetCICtrTimebaseDigFltrMinPulseWidth := getProc('DAQmxResetCICtrTimebaseDigFltrMinPulseWidth');
  DAQmxGetCICtrTimebaseDigFltrTimebaseSrc := getProc('DAQmxGetCICtrTimebaseDigFltrTimebaseSrc');
  DAQmxSetCICtrTimebaseDigFltrTimebaseSrc := getProc('DAQmxSetCICtrTimebaseDigFltrTimebaseSrc');
  DAQmxResetCICtrTimebaseDigFltrTimebaseSrc := getProc('DAQmxResetCICtrTimebaseDigFltrTimebaseSrc');
  DAQmxGetCICtrTimebaseDigFltrTimebaseRate := getProc('DAQmxGetCICtrTimebaseDigFltrTimebaseRate');
  DAQmxSetCICtrTimebaseDigFltrTimebaseRate := getProc('DAQmxSetCICtrTimebaseDigFltrTimebaseRate');
  DAQmxResetCICtrTimebaseDigFltrTimebaseRate := getProc('DAQmxResetCICtrTimebaseDigFltrTimebaseRate');
  DAQmxGetCICtrTimebaseDigSyncEnable := getProc('DAQmxGetCICtrTimebaseDigSyncEnable_VB6');
  DAQmxSetCICtrTimebaseDigSyncEnable := getProc('DAQmxSetCICtrTimebaseDigSyncEnable');
  DAQmxResetCICtrTimebaseDigSyncEnable := getProc('DAQmxResetCICtrTimebaseDigSyncEnable');
  DAQmxGetCICount := getProc('DAQmxGetCICount');
  DAQmxGetCIOutputState := getProc('DAQmxGetCIOutputState');
  DAQmxGetCITCReached := getProc('DAQmxGetCITCReached_VB6');
  DAQmxGetCICtrTimebaseMasterTimebaseDiv := getProc('DAQmxGetCICtrTimebaseMasterTimebaseDiv');
  DAQmxSetCICtrTimebaseMasterTimebaseDiv := getProc('DAQmxSetCICtrTimebaseMasterTimebaseDiv');
  DAQmxResetCICtrTimebaseMasterTimebaseDiv := getProc('DAQmxResetCICtrTimebaseMasterTimebaseDiv');
  DAQmxGetCIDataXferMech := getProc('DAQmxGetCIDataXferMech');
  DAQmxSetCIDataXferMech := getProc('DAQmxSetCIDataXferMech');
  DAQmxResetCIDataXferMech := getProc('DAQmxResetCIDataXferMech');
  DAQmxGetCINumPossiblyInvalidSamps := getProc('DAQmxGetCINumPossiblyInvalidSamps');
  DAQmxGetCIDupCountPrevent := getProc('DAQmxGetCIDupCountPrevent_VB6');
  DAQmxSetCIDupCountPrevent := getProc('DAQmxSetCIDupCountPrevent');
  DAQmxResetCIDupCountPrevent := getProc('DAQmxResetCIDupCountPrevent');
  DAQmxGetCIPrescaler := getProc('DAQmxGetCIPrescaler');
  DAQmxSetCIPrescaler := getProc('DAQmxSetCIPrescaler');
  DAQmxResetCIPrescaler := getProc('DAQmxResetCIPrescaler');
  DAQmxGetCOOutputType := getProc('DAQmxGetCOOutputType');
  DAQmxGetCOPulseIdleState := getProc('DAQmxGetCOPulseIdleState');
  DAQmxSetCOPulseIdleState := getProc('DAQmxSetCOPulseIdleState');
  DAQmxResetCOPulseIdleState := getProc('DAQmxResetCOPulseIdleState');
  DAQmxGetCOPulseTerm := getProc('DAQmxGetCOPulseTerm');
  DAQmxSetCOPulseTerm := getProc('DAQmxSetCOPulseTerm');
  DAQmxResetCOPulseTerm := getProc('DAQmxResetCOPulseTerm');
  DAQmxGetCOPulseTimeUnits := getProc('DAQmxGetCOPulseTimeUnits');
  DAQmxSetCOPulseTimeUnits := getProc('DAQmxSetCOPulseTimeUnits');
  DAQmxResetCOPulseTimeUnits := getProc('DAQmxResetCOPulseTimeUnits');
  DAQmxGetCOPulseHighTime := getProc('DAQmxGetCOPulseHighTime');
  DAQmxSetCOPulseHighTime := getProc('DAQmxSetCOPulseHighTime');
  DAQmxResetCOPulseHighTime := getProc('DAQmxResetCOPulseHighTime');
  DAQmxGetCOPulseLowTime := getProc('DAQmxGetCOPulseLowTime');
  DAQmxSetCOPulseLowTime := getProc('DAQmxSetCOPulseLowTime');
  DAQmxResetCOPulseLowTime := getProc('DAQmxResetCOPulseLowTime');
  DAQmxGetCOPulseTimeInitialDelay := getProc('DAQmxGetCOPulseTimeInitialDelay');
  DAQmxSetCOPulseTimeInitialDelay := getProc('DAQmxSetCOPulseTimeInitialDelay');
  DAQmxResetCOPulseTimeInitialDelay := getProc('DAQmxResetCOPulseTimeInitialDelay');
  DAQmxGetCOPulseDutyCyc := getProc('DAQmxGetCOPulseDutyCyc');
  DAQmxSetCOPulseDutyCyc := getProc('DAQmxSetCOPulseDutyCyc');
  DAQmxResetCOPulseDutyCyc := getProc('DAQmxResetCOPulseDutyCyc');
  DAQmxGetCOPulseFreqUnits := getProc('DAQmxGetCOPulseFreqUnits');
  DAQmxSetCOPulseFreqUnits := getProc('DAQmxSetCOPulseFreqUnits');
  DAQmxResetCOPulseFreqUnits := getProc('DAQmxResetCOPulseFreqUnits');
  DAQmxGetCOPulseFreq := getProc('DAQmxGetCOPulseFreq');
  DAQmxSetCOPulseFreq := getProc('DAQmxSetCOPulseFreq');
  DAQmxResetCOPulseFreq := getProc('DAQmxResetCOPulseFreq');
  DAQmxGetCOPulseFreqInitialDelay := getProc('DAQmxGetCOPulseFreqInitialDelay');
  DAQmxSetCOPulseFreqInitialDelay := getProc('DAQmxSetCOPulseFreqInitialDelay');
  DAQmxResetCOPulseFreqInitialDelay := getProc('DAQmxResetCOPulseFreqInitialDelay');
  DAQmxGetCOPulseHighTicks := getProc('DAQmxGetCOPulseHighTicks');
  DAQmxSetCOPulseHighTicks := getProc('DAQmxSetCOPulseHighTicks');
  DAQmxResetCOPulseHighTicks := getProc('DAQmxResetCOPulseHighTicks');
  DAQmxGetCOPulseLowTicks := getProc('DAQmxGetCOPulseLowTicks');
  DAQmxSetCOPulseLowTicks := getProc('DAQmxSetCOPulseLowTicks');
  DAQmxResetCOPulseLowTicks := getProc('DAQmxResetCOPulseLowTicks');
  DAQmxGetCOPulseTicksInitialDelay := getProc('DAQmxGetCOPulseTicksInitialDelay');
  DAQmxSetCOPulseTicksInitialDelay := getProc('DAQmxSetCOPulseTicksInitialDelay');
  DAQmxResetCOPulseTicksInitialDelay := getProc('DAQmxResetCOPulseTicksInitialDelay');
  DAQmxGetCOCtrTimebaseSrc := getProc('DAQmxGetCOCtrTimebaseSrc');
  DAQmxSetCOCtrTimebaseSrc := getProc('DAQmxSetCOCtrTimebaseSrc');
  DAQmxResetCOCtrTimebaseSrc := getProc('DAQmxResetCOCtrTimebaseSrc');
  DAQmxGetCOCtrTimebaseRate := getProc('DAQmxGetCOCtrTimebaseRate');
  DAQmxSetCOCtrTimebaseRate := getProc('DAQmxSetCOCtrTimebaseRate');
  DAQmxResetCOCtrTimebaseRate := getProc('DAQmxResetCOCtrTimebaseRate');
  DAQmxGetCOCtrTimebaseActiveEdge := getProc('DAQmxGetCOCtrTimebaseActiveEdge');
  DAQmxSetCOCtrTimebaseActiveEdge := getProc('DAQmxSetCOCtrTimebaseActiveEdge');
  DAQmxResetCOCtrTimebaseActiveEdge := getProc('DAQmxResetCOCtrTimebaseActiveEdge');
  DAQmxGetCOCtrTimebaseDigFltrEnable := getProc('DAQmxGetCOCtrTimebaseDigFltrEnable_VB6');
  DAQmxSetCOCtrTimebaseDigFltrEnable := getProc('DAQmxSetCOCtrTimebaseDigFltrEnable');
  DAQmxResetCOCtrTimebaseDigFltrEnable := getProc('DAQmxResetCOCtrTimebaseDigFltrEnable');
  DAQmxGetCOCtrTimebaseDigFltrMinPulseWidth := getProc('DAQmxGetCOCtrTimebaseDigFltrMinPulseWidth');
  DAQmxSetCOCtrTimebaseDigFltrMinPulseWidth := getProc('DAQmxSetCOCtrTimebaseDigFltrMinPulseWidth');
  DAQmxResetCOCtrTimebaseDigFltrMinPulseWidth := getProc('DAQmxResetCOCtrTimebaseDigFltrMinPulseWidth');
  DAQmxGetCOCtrTimebaseDigFltrTimebaseSrc := getProc('DAQmxGetCOCtrTimebaseDigFltrTimebaseSrc');
  DAQmxSetCOCtrTimebaseDigFltrTimebaseSrc := getProc('DAQmxSetCOCtrTimebaseDigFltrTimebaseSrc');
  DAQmxResetCOCtrTimebaseDigFltrTimebaseSrc := getProc('DAQmxResetCOCtrTimebaseDigFltrTimebaseSrc');
  DAQmxGetCOCtrTimebaseDigFltrTimebaseRate := getProc('DAQmxGetCOCtrTimebaseDigFltrTimebaseRate');
  DAQmxSetCOCtrTimebaseDigFltrTimebaseRate := getProc('DAQmxSetCOCtrTimebaseDigFltrTimebaseRate');
  DAQmxResetCOCtrTimebaseDigFltrTimebaseRate := getProc('DAQmxResetCOCtrTimebaseDigFltrTimebaseRate');
  DAQmxGetCOCtrTimebaseDigSyncEnable := getProc('DAQmxGetCOCtrTimebaseDigSyncEnable_VB6');
  DAQmxSetCOCtrTimebaseDigSyncEnable := getProc('DAQmxSetCOCtrTimebaseDigSyncEnable');
  DAQmxResetCOCtrTimebaseDigSyncEnable := getProc('DAQmxResetCOCtrTimebaseDigSyncEnable');
  DAQmxGetCOCount := getProc('DAQmxGetCOCount');
  DAQmxGetCOOutputState := getProc('DAQmxGetCOOutputState');
  DAQmxGetCOAutoIncrCnt := getProc('DAQmxGetCOAutoIncrCnt');
  DAQmxSetCOAutoIncrCnt := getProc('DAQmxSetCOAutoIncrCnt');
  DAQmxResetCOAutoIncrCnt := getProc('DAQmxResetCOAutoIncrCnt');
  DAQmxGetCOCtrTimebaseMasterTimebaseDiv := getProc('DAQmxGetCOCtrTimebaseMasterTimebaseDiv');
  DAQmxSetCOCtrTimebaseMasterTimebaseDiv := getProc('DAQmxSetCOCtrTimebaseMasterTimebaseDiv');
  DAQmxResetCOCtrTimebaseMasterTimebaseDiv := getProc('DAQmxResetCOCtrTimebaseMasterTimebaseDiv');
  DAQmxGetCOPulseDone := getProc('DAQmxGetCOPulseDone_VB6');
  DAQmxGetCOPrescaler := getProc('DAQmxGetCOPrescaler');
  DAQmxSetCOPrescaler := getProc('DAQmxSetCOPrescaler');
  DAQmxResetCOPrescaler := getProc('DAQmxResetCOPrescaler');
  DAQmxGetCORdyForNewVal := getProc('DAQmxGetCORdyForNewVal_VB6');
  DAQmxGetChanType := getProc('DAQmxGetChanType');
  DAQmxGetPhysicalChanName := getProc('DAQmxGetPhysicalChanName');
  DAQmxSetPhysicalChanName := getProc('DAQmxSetPhysicalChanName');
  DAQmxGetChanDescr := getProc('DAQmxGetChanDescr');
  DAQmxSetChanDescr := getProc('DAQmxSetChanDescr');
  DAQmxResetChanDescr := getProc('DAQmxResetChanDescr');
  DAQmxGetChanIsGlobal := getProc('DAQmxGetChanIsGlobal_VB6');
  DAQmxGetExportedAIConvClkOutputTerm := getProc('DAQmxGetExportedAIConvClkOutputTerm');
  DAQmxSetExportedAIConvClkOutputTerm := getProc('DAQmxSetExportedAIConvClkOutputTerm');
  DAQmxResetExportedAIConvClkOutputTerm := getProc('DAQmxResetExportedAIConvClkOutputTerm');
  DAQmxGetExportedAIConvClkPulsePolarity := getProc('DAQmxGetExportedAIConvClkPulsePolarity');
  DAQmxGetExported10MHzRefClkOutputTerm := getProc('DAQmxGetExported10MHzRefClkOutputTerm');
  DAQmxSetExported10MHzRefClkOutputTerm := getProc('DAQmxSetExported10MHzRefClkOutputTerm');
  DAQmxResetExported10MHzRefClkOutputTerm := getProc('DAQmxResetExported10MHzRefClkOutputTerm');
  DAQmxGetExported20MHzTimebaseOutputTerm := getProc('DAQmxGetExported20MHzTimebaseOutputTerm');
  DAQmxSetExported20MHzTimebaseOutputTerm := getProc('DAQmxSetExported20MHzTimebaseOutputTerm');
  DAQmxResetExported20MHzTimebaseOutputTerm := getProc('DAQmxResetExported20MHzTimebaseOutputTerm');
  DAQmxGetExportedSampClkOutputBehavior := getProc('DAQmxGetExportedSampClkOutputBehavior');
  DAQmxSetExportedSampClkOutputBehavior := getProc('DAQmxSetExportedSampClkOutputBehavior');
  DAQmxResetExportedSampClkOutputBehavior := getProc('DAQmxResetExportedSampClkOutputBehavior');
  DAQmxGetExportedSampClkOutputTerm := getProc('DAQmxGetExportedSampClkOutputTerm');
  DAQmxSetExportedSampClkOutputTerm := getProc('DAQmxSetExportedSampClkOutputTerm');
  DAQmxResetExportedSampClkOutputTerm := getProc('DAQmxResetExportedSampClkOutputTerm');
  DAQmxGetExportedSampClkPulsePolarity := getProc('DAQmxGetExportedSampClkPulsePolarity');
  DAQmxSetExportedSampClkPulsePolarity := getProc('DAQmxSetExportedSampClkPulsePolarity');
  DAQmxResetExportedSampClkPulsePolarity := getProc('DAQmxResetExportedSampClkPulsePolarity');
  DAQmxGetExportedSampClkTimebaseOutputTerm := getProc('DAQmxGetExportedSampClkTimebaseOutputTerm');
  DAQmxSetExportedSampClkTimebaseOutputTerm := getProc('DAQmxSetExportedSampClkTimebaseOutputTerm');
  DAQmxResetExportedSampClkTimebaseOutputTerm := getProc('DAQmxResetExportedSampClkTimebaseOutputTerm');
  DAQmxGetExportedDividedSampClkTimebaseOutputTerm := getProc('DAQmxGetExportedDividedSampClkTimebaseOutputTerm');
  DAQmxSetExportedDividedSampClkTimebaseOutputTerm := getProc('DAQmxSetExportedDividedSampClkTimebaseOutputTerm');
  DAQmxResetExportedDividedSampClkTimebaseOutputTerm := getProc('DAQmxResetExportedDividedSampClkTimebaseOutputTerm');
  DAQmxGetExportedAdvTrigOutputTerm := getProc('DAQmxGetExportedAdvTrigOutputTerm');
  DAQmxSetExportedAdvTrigOutputTerm := getProc('DAQmxSetExportedAdvTrigOutputTerm');
  DAQmxResetExportedAdvTrigOutputTerm := getProc('DAQmxResetExportedAdvTrigOutputTerm');
  DAQmxGetExportedAdvTrigPulsePolarity := getProc('DAQmxGetExportedAdvTrigPulsePolarity');
  DAQmxGetExportedAdvTrigPulseWidthUnits := getProc('DAQmxGetExportedAdvTrigPulseWidthUnits');
  DAQmxSetExportedAdvTrigPulseWidthUnits := getProc('DAQmxSetExportedAdvTrigPulseWidthUnits');
  DAQmxResetExportedAdvTrigPulseWidthUnits := getProc('DAQmxResetExportedAdvTrigPulseWidthUnits');
  DAQmxGetExportedAdvTrigPulseWidth := getProc('DAQmxGetExportedAdvTrigPulseWidth');
  DAQmxSetExportedAdvTrigPulseWidth := getProc('DAQmxSetExportedAdvTrigPulseWidth');
  DAQmxResetExportedAdvTrigPulseWidth := getProc('DAQmxResetExportedAdvTrigPulseWidth');
  DAQmxGetExportedPauseTrigOutputTerm := getProc('DAQmxGetExportedPauseTrigOutputTerm');
  DAQmxSetExportedPauseTrigOutputTerm := getProc('DAQmxSetExportedPauseTrigOutputTerm');
  DAQmxResetExportedPauseTrigOutputTerm := getProc('DAQmxResetExportedPauseTrigOutputTerm');
  DAQmxGetExportedPauseTrigLvlActiveLvl := getProc('DAQmxGetExportedPauseTrigLvlActiveLvl');
  DAQmxSetExportedPauseTrigLvlActiveLvl := getProc('DAQmxSetExportedPauseTrigLvlActiveLvl');
  DAQmxResetExportedPauseTrigLvlActiveLvl := getProc('DAQmxResetExportedPauseTrigLvlActiveLvl');
  DAQmxGetExportedRefTrigOutputTerm := getProc('DAQmxGetExportedRefTrigOutputTerm');
  DAQmxSetExportedRefTrigOutputTerm := getProc('DAQmxSetExportedRefTrigOutputTerm');
  DAQmxResetExportedRefTrigOutputTerm := getProc('DAQmxResetExportedRefTrigOutputTerm');
  DAQmxGetExportedRefTrigPulsePolarity := getProc('DAQmxGetExportedRefTrigPulsePolarity');
  DAQmxSetExportedRefTrigPulsePolarity := getProc('DAQmxSetExportedRefTrigPulsePolarity');
  DAQmxResetExportedRefTrigPulsePolarity := getProc('DAQmxResetExportedRefTrigPulsePolarity');
  DAQmxGetExportedStartTrigOutputTerm := getProc('DAQmxGetExportedStartTrigOutputTerm');
  DAQmxSetExportedStartTrigOutputTerm := getProc('DAQmxSetExportedStartTrigOutputTerm');
  DAQmxResetExportedStartTrigOutputTerm := getProc('DAQmxResetExportedStartTrigOutputTerm');
  DAQmxGetExportedStartTrigPulsePolarity := getProc('DAQmxGetExportedStartTrigPulsePolarity');
  DAQmxSetExportedStartTrigPulsePolarity := getProc('DAQmxSetExportedStartTrigPulsePolarity');
  DAQmxResetExportedStartTrigPulsePolarity := getProc('DAQmxResetExportedStartTrigPulsePolarity');
  DAQmxGetExportedAdvCmpltEventOutputTerm := getProc('DAQmxGetExportedAdvCmpltEventOutputTerm');
  DAQmxSetExportedAdvCmpltEventOutputTerm := getProc('DAQmxSetExportedAdvCmpltEventOutputTerm');
  DAQmxResetExportedAdvCmpltEventOutputTerm := getProc('DAQmxResetExportedAdvCmpltEventOutputTerm');
  DAQmxGetExportedAdvCmpltEventDelay := getProc('DAQmxGetExportedAdvCmpltEventDelay');
  DAQmxSetExportedAdvCmpltEventDelay := getProc('DAQmxSetExportedAdvCmpltEventDelay');
  DAQmxResetExportedAdvCmpltEventDelay := getProc('DAQmxResetExportedAdvCmpltEventDelay');
  DAQmxGetExportedAdvCmpltEventPulsePolarity := getProc('DAQmxGetExportedAdvCmpltEventPulsePolarity');
  DAQmxSetExportedAdvCmpltEventPulsePolarity := getProc('DAQmxSetExportedAdvCmpltEventPulsePolarity');
  DAQmxResetExportedAdvCmpltEventPulsePolarity := getProc('DAQmxResetExportedAdvCmpltEventPulsePolarity');
  DAQmxGetExportedAdvCmpltEventPulseWidth := getProc('DAQmxGetExportedAdvCmpltEventPulseWidth');
  DAQmxSetExportedAdvCmpltEventPulseWidth := getProc('DAQmxSetExportedAdvCmpltEventPulseWidth');
  DAQmxResetExportedAdvCmpltEventPulseWidth := getProc('DAQmxResetExportedAdvCmpltEventPulseWidth');
  DAQmxGetExportedAIHoldCmpltEventOutputTerm := getProc('DAQmxGetExportedAIHoldCmpltEventOutputTerm');
  DAQmxSetExportedAIHoldCmpltEventOutputTerm := getProc('DAQmxSetExportedAIHoldCmpltEventOutputTerm');
  DAQmxResetExportedAIHoldCmpltEventOutputTerm := getProc('DAQmxResetExportedAIHoldCmpltEventOutputTerm');
  DAQmxGetExportedAIHoldCmpltEventPulsePolarity := getProc('DAQmxGetExportedAIHoldCmpltEventPulsePolarity');
  DAQmxSetExportedAIHoldCmpltEventPulsePolarity := getProc('DAQmxSetExportedAIHoldCmpltEventPulsePolarity');
  DAQmxResetExportedAIHoldCmpltEventPulsePolarity := getProc('DAQmxResetExportedAIHoldCmpltEventPulsePolarity');
  DAQmxGetExportedChangeDetectEventOutputTerm := getProc('DAQmxGetExportedChangeDetectEventOutputTerm');
  DAQmxSetExportedChangeDetectEventOutputTerm := getProc('DAQmxSetExportedChangeDetectEventOutputTerm');
  DAQmxResetExportedChangeDetectEventOutputTerm := getProc('DAQmxResetExportedChangeDetectEventOutputTerm');
  DAQmxGetExportedChangeDetectEventPulsePolarity := getProc('DAQmxGetExportedChangeDetectEventPulsePolarity');
  DAQmxSetExportedChangeDetectEventPulsePolarity := getProc('DAQmxSetExportedChangeDetectEventPulsePolarity');
  DAQmxResetExportedChangeDetectEventPulsePolarity := getProc('DAQmxResetExportedChangeDetectEventPulsePolarity');
  DAQmxGetExportedCtrOutEventOutputTerm := getProc('DAQmxGetExportedCtrOutEventOutputTerm');
  DAQmxSetExportedCtrOutEventOutputTerm := getProc('DAQmxSetExportedCtrOutEventOutputTerm');
  DAQmxResetExportedCtrOutEventOutputTerm := getProc('DAQmxResetExportedCtrOutEventOutputTerm');
  DAQmxGetExportedCtrOutEventOutputBehavior := getProc('DAQmxGetExportedCtrOutEventOutputBehavior');
  DAQmxSetExportedCtrOutEventOutputBehavior := getProc('DAQmxSetExportedCtrOutEventOutputBehavior');
  DAQmxResetExportedCtrOutEventOutputBehavior := getProc('DAQmxResetExportedCtrOutEventOutputBehavior');
  DAQmxGetExportedCtrOutEventPulsePolarity := getProc('DAQmxGetExportedCtrOutEventPulsePolarity');
  DAQmxSetExportedCtrOutEventPulsePolarity := getProc('DAQmxSetExportedCtrOutEventPulsePolarity');
  DAQmxResetExportedCtrOutEventPulsePolarity := getProc('DAQmxResetExportedCtrOutEventPulsePolarity');
  DAQmxGetExportedCtrOutEventToggleIdleState := getProc('DAQmxGetExportedCtrOutEventToggleIdleState');
  DAQmxSetExportedCtrOutEventToggleIdleState := getProc('DAQmxSetExportedCtrOutEventToggleIdleState');
  DAQmxResetExportedCtrOutEventToggleIdleState := getProc('DAQmxResetExportedCtrOutEventToggleIdleState');
  DAQmxGetExportedHshkEventOutputTerm := getProc('DAQmxGetExportedHshkEventOutputTerm');
  DAQmxSetExportedHshkEventOutputTerm := getProc('DAQmxSetExportedHshkEventOutputTerm');
  DAQmxResetExportedHshkEventOutputTerm := getProc('DAQmxResetExportedHshkEventOutputTerm');
  DAQmxGetExportedHshkEventOutputBehavior := getProc('DAQmxGetExportedHshkEventOutputBehavior');
  DAQmxSetExportedHshkEventOutputBehavior := getProc('DAQmxSetExportedHshkEventOutputBehavior');
  DAQmxResetExportedHshkEventOutputBehavior := getProc('DAQmxResetExportedHshkEventOutputBehavior');
  DAQmxGetExportedHshkEventDelay := getProc('DAQmxGetExportedHshkEventDelay');
  DAQmxSetExportedHshkEventDelay := getProc('DAQmxSetExportedHshkEventDelay');
  DAQmxResetExportedHshkEventDelay := getProc('DAQmxResetExportedHshkEventDelay');
  DAQmxGetExportedHshkEventInterlockedAssertedLvl := getProc('DAQmxGetExportedHshkEventInterlockedAssertedLvl');
  DAQmxSetExportedHshkEventInterlockedAssertedLvl := getProc('DAQmxSetExportedHshkEventInterlockedAssertedLvl');
  DAQmxResetExportedHshkEventInterlockedAssertedLvl := getProc('DAQmxResetExportedHshkEventInterlockedAssertedLvl');
  DAQmxGetExportedHshkEventInterlockedAssertOnStart := getProc('DAQmxGetExportedHshkEventInterlockedAssertOnStart_VB6');
  DAQmxSetExportedHshkEventInterlockedAssertOnStart := getProc('DAQmxSetExportedHshkEventInterlockedAssertOnStart');
  DAQmxResetExportedHshkEventInterlockedAssertOnStart := getProc('DAQmxResetExportedHshkEventInterlockedAssertOnStart');
  DAQmxGetExportedHshkEventInterlockedDeassertDelay := getProc('DAQmxGetExportedHshkEventInterlockedDeassertDelay');
  DAQmxSetExportedHshkEventInterlockedDeassertDelay := getProc('DAQmxSetExportedHshkEventInterlockedDeassertDelay');
  DAQmxResetExportedHshkEventInterlockedDeassertDelay := getProc('DAQmxResetExportedHshkEventInterlockedDeassertDelay');
  DAQmxGetExportedHshkEventPulsePolarity := getProc('DAQmxGetExportedHshkEventPulsePolarity');
  DAQmxSetExportedHshkEventPulsePolarity := getProc('DAQmxSetExportedHshkEventPulsePolarity');
  DAQmxResetExportedHshkEventPulsePolarity := getProc('DAQmxResetExportedHshkEventPulsePolarity');
  DAQmxGetExportedHshkEventPulseWidth := getProc('DAQmxGetExportedHshkEventPulseWidth');
  DAQmxSetExportedHshkEventPulseWidth := getProc('DAQmxSetExportedHshkEventPulseWidth');
  DAQmxResetExportedHshkEventPulseWidth := getProc('DAQmxResetExportedHshkEventPulseWidth');
  DAQmxGetExportedRdyForXferEventOutputTerm := getProc('DAQmxGetExportedRdyForXferEventOutputTerm');
  DAQmxSetExportedRdyForXferEventOutputTerm := getProc('DAQmxSetExportedRdyForXferEventOutputTerm');
  DAQmxResetExportedRdyForXferEventOutputTerm := getProc('DAQmxResetExportedRdyForXferEventOutputTerm');
  DAQmxGetExportedRdyForXferEventLvlActiveLvl := getProc('DAQmxGetExportedRdyForXferEventLvlActiveLvl');
  DAQmxSetExportedRdyForXferEventLvlActiveLvl := getProc('DAQmxSetExportedRdyForXferEventLvlActiveLvl');
  DAQmxResetExportedRdyForXferEventLvlActiveLvl := getProc('DAQmxResetExportedRdyForXferEventLvlActiveLvl');
  DAQmxGetExportedRdyForXferEventDeassertCond := getProc('DAQmxGetExportedRdyForXferEventDeassertCond');
  DAQmxSetExportedRdyForXferEventDeassertCond := getProc('DAQmxSetExportedRdyForXferEventDeassertCond');
  DAQmxResetExportedRdyForXferEventDeassertCond := getProc('DAQmxResetExportedRdyForXferEventDeassertCond');
  DAQmxGetExportedRdyForXferEventDeassertCondCustomThreshold := getProc('DAQmxGetExportedRdyForXferEventDeassertCondCustomThreshold');
  DAQmxSetExportedRdyForXferEventDeassertCondCustomThreshold := getProc('DAQmxSetExportedRdyForXferEventDeassertCondCustomThreshold');
  DAQmxResetExportedRdyForXferEventDeassertCondCustomThreshold := getProc('DAQmxResetExportedRdyForXferEventDeassertCondCustomThreshold');
  DAQmxGetExportedDataActiveEventOutputTerm := getProc('DAQmxGetExportedDataActiveEventOutputTerm');
  DAQmxSetExportedDataActiveEventOutputTerm := getProc('DAQmxSetExportedDataActiveEventOutputTerm');
  DAQmxResetExportedDataActiveEventOutputTerm := getProc('DAQmxResetExportedDataActiveEventOutputTerm');
  DAQmxGetExportedDataActiveEventLvlActiveLvl := getProc('DAQmxGetExportedDataActiveEventLvlActiveLvl');
  DAQmxSetExportedDataActiveEventLvlActiveLvl := getProc('DAQmxSetExportedDataActiveEventLvlActiveLvl');
  DAQmxResetExportedDataActiveEventLvlActiveLvl := getProc('DAQmxResetExportedDataActiveEventLvlActiveLvl');
  DAQmxGetExportedRdyForStartEventOutputTerm := getProc('DAQmxGetExportedRdyForStartEventOutputTerm');
  DAQmxSetExportedRdyForStartEventOutputTerm := getProc('DAQmxSetExportedRdyForStartEventOutputTerm');
  DAQmxResetExportedRdyForStartEventOutputTerm := getProc('DAQmxResetExportedRdyForStartEventOutputTerm');
  DAQmxGetExportedRdyForStartEventLvlActiveLvl := getProc('DAQmxGetExportedRdyForStartEventLvlActiveLvl');
  DAQmxSetExportedRdyForStartEventLvlActiveLvl := getProc('DAQmxSetExportedRdyForStartEventLvlActiveLvl');
  DAQmxResetExportedRdyForStartEventLvlActiveLvl := getProc('DAQmxResetExportedRdyForStartEventLvlActiveLvl');
  DAQmxGetExportedSyncPulseEventOutputTerm := getProc('DAQmxGetExportedSyncPulseEventOutputTerm');
  DAQmxSetExportedSyncPulseEventOutputTerm := getProc('DAQmxSetExportedSyncPulseEventOutputTerm');
  DAQmxResetExportedSyncPulseEventOutputTerm := getProc('DAQmxResetExportedSyncPulseEventOutputTerm');
  DAQmxGetExportedWatchdogExpiredEventOutputTerm := getProc('DAQmxGetExportedWatchdogExpiredEventOutputTerm');
  DAQmxSetExportedWatchdogExpiredEventOutputTerm := getProc('DAQmxSetExportedWatchdogExpiredEventOutputTerm');
  DAQmxResetExportedWatchdogExpiredEventOutputTerm := getProc('DAQmxResetExportedWatchdogExpiredEventOutputTerm');
end;

procedure InitNIlib2;
begin
  DAQmxGetDevIsSimulated := getProc('DAQmxGetDevIsSimulated_VB6');
  DAQmxGetDevProductCategory := getProc('DAQmxGetDevProductCategory');
  DAQmxGetDevProductType := getProc('DAQmxGetDevProductType');
  DAQmxGetDevProductNum := getProc('DAQmxGetDevProductNum');
  DAQmxGetDevSerialNum := getProc('DAQmxGetDevSerialNum');
  DAQmxGetDevChassisModuleDevNames := getProc('DAQmxGetDevChassisModuleDevNames');
  DAQmxGetDevAnlgTrigSupported := getProc('DAQmxGetDevAnlgTrigSupported_VB6');
  DAQmxGetDevDigTrigSupported := getProc('DAQmxGetDevDigTrigSupported_VB6');
  DAQmxGetDevAIPhysicalChans := getProc('DAQmxGetDevAIPhysicalChans');
  DAQmxGetDevAIMaxSingleChanRate := getProc('DAQmxGetDevAIMaxSingleChanRate');
  DAQmxGetDevAIMaxMultiChanRate := getProc('DAQmxGetDevAIMaxMultiChanRate');
  DAQmxGetDevAIMinRate := getProc('DAQmxGetDevAIMinRate');
  DAQmxGetDevAISimultaneousSamplingSupported := getProc('DAQmxGetDevAISimultaneousSamplingSupported_VB6');
  DAQmxGetDevAITrigUsage := getProc('DAQmxGetDevAITrigUsage');
  DAQmxGetDevAIVoltageRngs := getProc('DAQmxGetDevAIVoltageRngs');
  DAQmxGetDevAIVoltageIntExcitDiscreteVals := getProc('DAQmxGetDevAIVoltageIntExcitDiscreteVals');
  DAQmxGetDevAIVoltageIntExcitRangeVals := getProc('DAQmxGetDevAIVoltageIntExcitRangeVals');
  DAQmxGetDevAICurrentRngs := getProc('DAQmxGetDevAICurrentRngs');
  DAQmxGetDevAICurrentIntExcitDiscreteVals := getProc('DAQmxGetDevAICurrentIntExcitDiscreteVals');
  DAQmxGetDevAIFreqRngs := getProc('DAQmxGetDevAIFreqRngs');
  DAQmxGetDevAIGains := getProc('DAQmxGetDevAIGains');
  DAQmxGetDevAICouplings := getProc('DAQmxGetDevAICouplings');
  DAQmxGetDevAILowpassCutoffFreqDiscreteVals := getProc('DAQmxGetDevAILowpassCutoffFreqDiscreteVals');
  DAQmxGetDevAILowpassCutoffFreqRangeVals := getProc('DAQmxGetDevAILowpassCutoffFreqRangeVals');
  DAQmxGetDevAOPhysicalChans := getProc('DAQmxGetDevAOPhysicalChans');
  DAQmxGetDevAOSampClkSupported := getProc('DAQmxGetDevAOSampClkSupported_VB6');
  DAQmxGetDevAOMaxRate := getProc('DAQmxGetDevAOMaxRate');
  DAQmxGetDevAOMinRate := getProc('DAQmxGetDevAOMinRate');
  DAQmxGetDevAOTrigUsage := getProc('DAQmxGetDevAOTrigUsage');
  DAQmxGetDevAOVoltageRngs := getProc('DAQmxGetDevAOVoltageRngs');
  DAQmxGetDevAOCurrentRngs := getProc('DAQmxGetDevAOCurrentRngs');
  DAQmxGetDevAOGains := getProc('DAQmxGetDevAOGains');
  DAQmxGetDevDILines := getProc('DAQmxGetDevDILines');
  DAQmxGetDevDIPorts := getProc('DAQmxGetDevDIPorts');
  DAQmxGetDevDIMaxRate := getProc('DAQmxGetDevDIMaxRate');
  DAQmxGetDevDITrigUsage := getProc('DAQmxGetDevDITrigUsage');
  DAQmxGetDevDOLines := getProc('DAQmxGetDevDOLines');
  DAQmxGetDevDOPorts := getProc('DAQmxGetDevDOPorts');
  DAQmxGetDevDOMaxRate := getProc('DAQmxGetDevDOMaxRate');
  DAQmxGetDevDOTrigUsage := getProc('DAQmxGetDevDOTrigUsage');
  DAQmxGetDevCIPhysicalChans := getProc('DAQmxGetDevCIPhysicalChans');
  DAQmxGetDevCITrigUsage := getProc('DAQmxGetDevCITrigUsage');
  DAQmxGetDevCISampClkSupported := getProc('DAQmxGetDevCISampClkSupported_VB6');
  DAQmxGetDevCIMaxTimebase := getProc('DAQmxGetDevCIMaxTimebase');
  DAQmxGetDevCOPhysicalChans := getProc('DAQmxGetDevCOPhysicalChans');
  DAQmxGetDevCOTrigUsage := getProc('DAQmxGetDevCOTrigUsage');
  DAQmxGetDevCOMaxTimebase := getProc('DAQmxGetDevCOMaxTimebase');
  DAQmxGetDevBusType := getProc('DAQmxGetDevBusType');
  DAQmxGetDevNumDMAChans := getProc('DAQmxGetDevNumDMAChans');
  DAQmxGetDevPCIBusNum := getProc('DAQmxGetDevPCIBusNum');
  DAQmxGetDevPCIDevNum := getProc('DAQmxGetDevPCIDevNum');
  DAQmxGetDevPXIChassisNum := getProc('DAQmxGetDevPXIChassisNum');
  DAQmxGetDevPXISlotNum := getProc('DAQmxGetDevPXISlotNum');
  DAQmxGetDevCompactDAQChassisDevName := getProc('DAQmxGetDevCompactDAQChassisDevName');
  DAQmxGetDevCompactDAQSlotNum := getProc('DAQmxGetDevCompactDAQSlotNum');
  DAQmxGetReadRelativeTo := getProc('DAQmxGetReadRelativeTo');
  DAQmxSetReadRelativeTo := getProc('DAQmxSetReadRelativeTo');
  DAQmxResetReadRelativeTo := getProc('DAQmxResetReadRelativeTo');
  DAQmxGetReadOffset := getProc('DAQmxGetReadOffset');
  DAQmxSetReadOffset := getProc('DAQmxSetReadOffset');
  DAQmxResetReadOffset := getProc('DAQmxResetReadOffset');
  DAQmxGetReadChannelsToRead := getProc('DAQmxGetReadChannelsToRead');
  DAQmxSetReadChannelsToRead := getProc('DAQmxSetReadChannelsToRead');
  DAQmxResetReadChannelsToRead := getProc('DAQmxResetReadChannelsToRead');
  DAQmxGetReadReadAllAvailSamp := getProc('DAQmxGetReadReadAllAvailSamp_VB6');
  DAQmxSetReadReadAllAvailSamp := getProc('DAQmxSetReadReadAllAvailSamp');
  DAQmxResetReadReadAllAvailSamp := getProc('DAQmxResetReadReadAllAvailSamp');
  DAQmxGetReadAutoStart := getProc('DAQmxGetReadAutoStart_VB6');
  DAQmxSetReadAutoStart := getProc('DAQmxSetReadAutoStart');
  DAQmxResetReadAutoStart := getProc('DAQmxResetReadAutoStart');
  DAQmxGetReadOverWrite := getProc('DAQmxGetReadOverWrite');
  DAQmxSetReadOverWrite := getProc('DAQmxSetReadOverWrite');
  DAQmxResetReadOverWrite := getProc('DAQmxResetReadOverWrite');
  DAQmxGetReadCurrReadPos := getProc('DAQmxGetReadCurrReadPos_VB6');
  DAQmxGetReadAvailSampPerChan := getProc('DAQmxGetReadAvailSampPerChan');
  DAQmxGetReadTotalSampPerChanAcquired := getProc('DAQmxGetReadTotalSampPerChanAcquired_VB6');
  DAQmxGetReadOverloadedChansExist := getProc('DAQmxGetReadOverloadedChansExist_VB6');
  DAQmxGetReadOverloadedChans := getProc('DAQmxGetReadOverloadedChans');
  DAQmxGetReadChangeDetectHasOverflowed := getProc('DAQmxGetReadChangeDetectHasOverflowed_VB6');
  DAQmxGetReadRawDataWidth := getProc('DAQmxGetReadRawDataWidth');
  DAQmxGetReadNumChans := getProc('DAQmxGetReadNumChans');
  DAQmxGetReadDigitalLinesBytesPerChan := getProc('DAQmxGetReadDigitalLinesBytesPerChan');
  DAQmxGetReadWaitMode := getProc('DAQmxGetReadWaitMode');
  DAQmxSetReadWaitMode := getProc('DAQmxSetReadWaitMode');
  DAQmxResetReadWaitMode := getProc('DAQmxResetReadWaitMode');
  DAQmxGetReadSleepTime := getProc('DAQmxGetReadSleepTime');
  DAQmxSetReadSleepTime := getProc('DAQmxSetReadSleepTime');
  DAQmxResetReadSleepTime := getProc('DAQmxResetReadSleepTime');
  DAQmxGetRealTimeConvLateErrorsToWarnings := getProc('DAQmxGetRealTimeConvLateErrorsToWarnings_VB6');
  DAQmxSetRealTimeConvLateErrorsToWarnings := getProc('DAQmxSetRealTimeConvLateErrorsToWarnings');
  DAQmxResetRealTimeConvLateErrorsToWarnings := getProc('DAQmxResetRealTimeConvLateErrorsToWarnings');
  DAQmxGetRealTimeNumOfWarmupIters := getProc('DAQmxGetRealTimeNumOfWarmupIters');
  DAQmxSetRealTimeNumOfWarmupIters := getProc('DAQmxSetRealTimeNumOfWarmupIters');
  DAQmxResetRealTimeNumOfWarmupIters := getProc('DAQmxResetRealTimeNumOfWarmupIters');
  DAQmxGetRealTimeWaitForNextSampClkWaitMode := getProc('DAQmxGetRealTimeWaitForNextSampClkWaitMode');
  DAQmxSetRealTimeWaitForNextSampClkWaitMode := getProc('DAQmxSetRealTimeWaitForNextSampClkWaitMode');
  DAQmxResetRealTimeWaitForNextSampClkWaitMode := getProc('DAQmxResetRealTimeWaitForNextSampClkWaitMode');
  DAQmxGetRealTimeReportMissedSamp := getProc('DAQmxGetRealTimeReportMissedSamp_VB6');
  DAQmxSetRealTimeReportMissedSamp := getProc('DAQmxSetRealTimeReportMissedSamp');
  DAQmxResetRealTimeReportMissedSamp := getProc('DAQmxResetRealTimeReportMissedSamp');
  DAQmxGetRealTimeWriteRecoveryMode := getProc('DAQmxGetRealTimeWriteRecoveryMode');
  DAQmxSetRealTimeWriteRecoveryMode := getProc('DAQmxSetRealTimeWriteRecoveryMode');
  DAQmxResetRealTimeWriteRecoveryMode := getProc('DAQmxResetRealTimeWriteRecoveryMode');
  DAQmxGetSwitchChanUsage := getProc('DAQmxGetSwitchChanUsage');
  DAQmxSetSwitchChanUsage := getProc('DAQmxSetSwitchChanUsage');
  DAQmxGetSwitchChanMaxACCarryCurrent := getProc('DAQmxGetSwitchChanMaxACCarryCurrent');
  DAQmxGetSwitchChanMaxACSwitchCurrent := getProc('DAQmxGetSwitchChanMaxACSwitchCurrent');
  DAQmxGetSwitchChanMaxACCarryPwr := getProc('DAQmxGetSwitchChanMaxACCarryPwr');
  DAQmxGetSwitchChanMaxACSwitchPwr := getProc('DAQmxGetSwitchChanMaxACSwitchPwr');
  DAQmxGetSwitchChanMaxDCCarryCurrent := getProc('DAQmxGetSwitchChanMaxDCCarryCurrent');
  DAQmxGetSwitchChanMaxDCSwitchCurrent := getProc('DAQmxGetSwitchChanMaxDCSwitchCurrent');
  DAQmxGetSwitchChanMaxDCCarryPwr := getProc('DAQmxGetSwitchChanMaxDCCarryPwr');
  DAQmxGetSwitchChanMaxDCSwitchPwr := getProc('DAQmxGetSwitchChanMaxDCSwitchPwr');
  DAQmxGetSwitchChanMaxACVoltage := getProc('DAQmxGetSwitchChanMaxACVoltage');
  DAQmxGetSwitchChanMaxDCVoltage := getProc('DAQmxGetSwitchChanMaxDCVoltage');
  DAQmxGetSwitchChanWireMode := getProc('DAQmxGetSwitchChanWireMode');
  DAQmxGetSwitchChanBandwidth := getProc('DAQmxGetSwitchChanBandwidth');
  DAQmxGetSwitchChanImpedance := getProc('DAQmxGetSwitchChanImpedance');
  DAQmxGetSwitchDevSettlingTime := getProc('DAQmxGetSwitchDevSettlingTime');
  DAQmxSetSwitchDevSettlingTime := getProc('DAQmxSetSwitchDevSettlingTime');
  DAQmxGetSwitchDevAutoConnAnlgBus := getProc('DAQmxGetSwitchDevAutoConnAnlgBus_VB6');
  DAQmxSetSwitchDevAutoConnAnlgBus := getProc('DAQmxSetSwitchDevAutoConnAnlgBus');
  DAQmxGetSwitchDevPwrDownLatchRelaysAfterSettling := getProc('DAQmxGetSwitchDevPwrDownLatchRelaysAfterSettling_VB6');
  DAQmxSetSwitchDevPwrDownLatchRelaysAfterSettling := getProc('DAQmxSetSwitchDevPwrDownLatchRelaysAfterSettling');
  DAQmxGetSwitchDevSettled := getProc('DAQmxGetSwitchDevSettled_VB6');
  DAQmxGetSwitchDevRelayList := getProc('DAQmxGetSwitchDevRelayList');
  DAQmxGetSwitchDevNumRelays := getProc('DAQmxGetSwitchDevNumRelays');
  DAQmxGetSwitchDevSwitchChanList := getProc('DAQmxGetSwitchDevSwitchChanList');
  DAQmxGetSwitchDevNumSwitchChans := getProc('DAQmxGetSwitchDevNumSwitchChans');
  DAQmxGetSwitchDevNumRows := getProc('DAQmxGetSwitchDevNumRows');
  DAQmxGetSwitchDevNumColumns := getProc('DAQmxGetSwitchDevNumColumns');
  DAQmxGetSwitchDevTopology := getProc('DAQmxGetSwitchDevTopology');
  DAQmxGetSwitchScanBreakMode := getProc('DAQmxGetSwitchScanBreakMode');
  DAQmxSetSwitchScanBreakMode := getProc('DAQmxSetSwitchScanBreakMode');
  DAQmxResetSwitchScanBreakMode := getProc('DAQmxResetSwitchScanBreakMode');
  DAQmxGetSwitchScanRepeatMode := getProc('DAQmxGetSwitchScanRepeatMode');
  DAQmxSetSwitchScanRepeatMode := getProc('DAQmxSetSwitchScanRepeatMode');
  DAQmxResetSwitchScanRepeatMode := getProc('DAQmxResetSwitchScanRepeatMode');
  DAQmxGetSwitchScanWaitingForAdv := getProc('DAQmxGetSwitchScanWaitingForAdv_VB6');
  DAQmxGetScaleDescr := getProc('DAQmxGetScaleDescr');
  DAQmxSetScaleDescr := getProc('DAQmxSetScaleDescr');
  DAQmxGetScaleScaledUnits := getProc('DAQmxGetScaleScaledUnits');
  DAQmxSetScaleScaledUnits := getProc('DAQmxSetScaleScaledUnits');
  DAQmxGetScalePreScaledUnits := getProc('DAQmxGetScalePreScaledUnits');
  DAQmxSetScalePreScaledUnits := getProc('DAQmxSetScalePreScaledUnits');
  DAQmxGetScaleType := getProc('DAQmxGetScaleType');
  DAQmxGetScaleLinSlope := getProc('DAQmxGetScaleLinSlope');
  DAQmxSetScaleLinSlope := getProc('DAQmxSetScaleLinSlope');
  DAQmxGetScaleLinYIntercept := getProc('DAQmxGetScaleLinYIntercept');
  DAQmxSetScaleLinYIntercept := getProc('DAQmxSetScaleLinYIntercept');
  DAQmxGetScaleMapScaledMax := getProc('DAQmxGetScaleMapScaledMax');
  DAQmxSetScaleMapScaledMax := getProc('DAQmxSetScaleMapScaledMax');
  DAQmxGetScaleMapPreScaledMax := getProc('DAQmxGetScaleMapPreScaledMax');
  DAQmxSetScaleMapPreScaledMax := getProc('DAQmxSetScaleMapPreScaledMax');
  DAQmxGetScaleMapScaledMin := getProc('DAQmxGetScaleMapScaledMin');
  DAQmxSetScaleMapScaledMin := getProc('DAQmxSetScaleMapScaledMin');
  DAQmxGetScaleMapPreScaledMin := getProc('DAQmxGetScaleMapPreScaledMin');
  DAQmxSetScaleMapPreScaledMin := getProc('DAQmxSetScaleMapPreScaledMin');
  DAQmxGetScalePolyForwardCoeff := getProc('DAQmxGetScalePolyForwardCoeff');
  DAQmxSetScalePolyForwardCoeff := getProc('DAQmxSetScalePolyForwardCoeff');
  DAQmxGetScalePolyReverseCoeff := getProc('DAQmxGetScalePolyReverseCoeff');
  DAQmxSetScalePolyReverseCoeff := getProc('DAQmxSetScalePolyReverseCoeff');
  DAQmxGetScaleTableScaledVals := getProc('DAQmxGetScaleTableScaledVals');
  DAQmxSetScaleTableScaledVals := getProc('DAQmxSetScaleTableScaledVals');
  DAQmxGetScaleTablePreScaledVals := getProc('DAQmxGetScaleTablePreScaledVals');
  DAQmxSetScaleTablePreScaledVals := getProc('DAQmxSetScaleTablePreScaledVals');
  DAQmxGetSysGlobalChans := getProc('DAQmxGetSysGlobalChans');
  DAQmxGetSysScales := getProc('DAQmxGetSysScales');
  DAQmxGetSysTasks := getProc('DAQmxGetSysTasks');
  DAQmxGetSysDevNames := getProc('DAQmxGetSysDevNames');
  DAQmxGetSysNIDAQMajorVersion := getProc('DAQmxGetSysNIDAQMajorVersion');
  DAQmxGetSysNIDAQMinorVersion := getProc('DAQmxGetSysNIDAQMinorVersion');
  DAQmxGetTaskName := getProc('DAQmxGetTaskName');
  DAQmxGetTaskChannels := getProc('DAQmxGetTaskChannels');
  DAQmxGetTaskNumChans := getProc('DAQmxGetTaskNumChans');
  DAQmxGetTaskDevices := getProc('DAQmxGetTaskDevices');
  DAQmxGetTaskNumDevices := getProc('DAQmxGetTaskNumDevices');
  DAQmxGetTaskComplete := getProc('DAQmxGetTaskComplete_VB6');
  DAQmxGetSampQuantSampMode := getProc('DAQmxGetSampQuantSampMode');
  DAQmxSetSampQuantSampMode := getProc('DAQmxSetSampQuantSampMode');
  DAQmxResetSampQuantSampMode := getProc('DAQmxResetSampQuantSampMode');
  DAQmxGetSampQuantSampPerChan := getProc('DAQmxGetSampQuantSampPerChan_VB6');
  DAQmxSetSampQuantSampPerChan := getProc('DAQmxSetSampQuantSampPerChan_VB6');
  DAQmxResetSampQuantSampPerChan := getProc('DAQmxResetSampQuantSampPerChan');
  DAQmxGetSampTimingType := getProc('DAQmxGetSampTimingType');
  DAQmxSetSampTimingType := getProc('DAQmxSetSampTimingType');
  DAQmxResetSampTimingType := getProc('DAQmxResetSampTimingType');
  DAQmxGetSampClkRate := getProc('DAQmxGetSampClkRate');
  DAQmxSetSampClkRate := getProc('DAQmxSetSampClkRate');
  DAQmxResetSampClkRate := getProc('DAQmxResetSampClkRate');
  DAQmxGetSampClkMaxRate := getProc('DAQmxGetSampClkMaxRate');
  DAQmxGetSampClkSrc := getProc('DAQmxGetSampClkSrc');
  DAQmxSetSampClkSrc := getProc('DAQmxSetSampClkSrc');
  DAQmxResetSampClkSrc := getProc('DAQmxResetSampClkSrc');
  DAQmxGetSampClkActiveEdge := getProc('DAQmxGetSampClkActiveEdge');
  DAQmxSetSampClkActiveEdge := getProc('DAQmxSetSampClkActiveEdge');
  DAQmxResetSampClkActiveEdge := getProc('DAQmxResetSampClkActiveEdge');
  DAQmxGetSampClkUnderflowBehavior := getProc('DAQmxGetSampClkUnderflowBehavior');
  DAQmxSetSampClkUnderflowBehavior := getProc('DAQmxSetSampClkUnderflowBehavior');
  DAQmxResetSampClkUnderflowBehavior := getProc('DAQmxResetSampClkUnderflowBehavior');
  DAQmxGetSampClkTimebaseDiv := getProc('DAQmxGetSampClkTimebaseDiv');
  DAQmxSetSampClkTimebaseDiv := getProc('DAQmxSetSampClkTimebaseDiv');
  DAQmxResetSampClkTimebaseDiv := getProc('DAQmxResetSampClkTimebaseDiv');
  DAQmxGetSampClkTimebaseRate := getProc('DAQmxGetSampClkTimebaseRate');
  DAQmxSetSampClkTimebaseRate := getProc('DAQmxSetSampClkTimebaseRate');
  DAQmxResetSampClkTimebaseRate := getProc('DAQmxResetSampClkTimebaseRate');
  DAQmxGetSampClkTimebaseSrc := getProc('DAQmxGetSampClkTimebaseSrc');
  DAQmxSetSampClkTimebaseSrc := getProc('DAQmxSetSampClkTimebaseSrc');
  DAQmxResetSampClkTimebaseSrc := getProc('DAQmxResetSampClkTimebaseSrc');
  DAQmxGetSampClkTimebaseActiveEdge := getProc('DAQmxGetSampClkTimebaseActiveEdge');
  DAQmxSetSampClkTimebaseActiveEdge := getProc('DAQmxSetSampClkTimebaseActiveEdge');
  DAQmxResetSampClkTimebaseActiveEdge := getProc('DAQmxResetSampClkTimebaseActiveEdge');
  DAQmxGetSampClkTimebaseMasterTimebaseDiv := getProc('DAQmxGetSampClkTimebaseMasterTimebaseDiv');
  DAQmxSetSampClkTimebaseMasterTimebaseDiv := getProc('DAQmxSetSampClkTimebaseMasterTimebaseDiv');
  DAQmxResetSampClkTimebaseMasterTimebaseDiv := getProc('DAQmxResetSampClkTimebaseMasterTimebaseDiv');
  DAQmxGetSampClkDigFltrEnable := getProc('DAQmxGetSampClkDigFltrEnable_VB6');
  DAQmxSetSampClkDigFltrEnable := getProc('DAQmxSetSampClkDigFltrEnable');
  DAQmxResetSampClkDigFltrEnable := getProc('DAQmxResetSampClkDigFltrEnable');
  DAQmxGetSampClkDigFltrMinPulseWidth := getProc('DAQmxGetSampClkDigFltrMinPulseWidth');
  DAQmxSetSampClkDigFltrMinPulseWidth := getProc('DAQmxSetSampClkDigFltrMinPulseWidth');
  DAQmxResetSampClkDigFltrMinPulseWidth := getProc('DAQmxResetSampClkDigFltrMinPulseWidth');
  DAQmxGetSampClkDigFltrTimebaseSrc := getProc('DAQmxGetSampClkDigFltrTimebaseSrc');
  DAQmxSetSampClkDigFltrTimebaseSrc := getProc('DAQmxSetSampClkDigFltrTimebaseSrc');
  DAQmxResetSampClkDigFltrTimebaseSrc := getProc('DAQmxResetSampClkDigFltrTimebaseSrc');
  DAQmxGetSampClkDigFltrTimebaseRate := getProc('DAQmxGetSampClkDigFltrTimebaseRate');
  DAQmxSetSampClkDigFltrTimebaseRate := getProc('DAQmxSetSampClkDigFltrTimebaseRate');
  DAQmxResetSampClkDigFltrTimebaseRate := getProc('DAQmxResetSampClkDigFltrTimebaseRate');
  DAQmxGetSampClkDigSyncEnable := getProc('DAQmxGetSampClkDigSyncEnable_VB6');
  DAQmxSetSampClkDigSyncEnable := getProc('DAQmxSetSampClkDigSyncEnable');
  DAQmxResetSampClkDigSyncEnable := getProc('DAQmxResetSampClkDigSyncEnable');
  DAQmxGetHshkDelayAfterXfer := getProc('DAQmxGetHshkDelayAfterXfer');
  DAQmxSetHshkDelayAfterXfer := getProc('DAQmxSetHshkDelayAfterXfer');
  DAQmxResetHshkDelayAfterXfer := getProc('DAQmxResetHshkDelayAfterXfer');
  DAQmxGetHshkStartCond := getProc('DAQmxGetHshkStartCond');
  DAQmxSetHshkStartCond := getProc('DAQmxSetHshkStartCond');
  DAQmxResetHshkStartCond := getProc('DAQmxResetHshkStartCond');
  DAQmxGetHshkSampleInputDataWhen := getProc('DAQmxGetHshkSampleInputDataWhen');
  DAQmxSetHshkSampleInputDataWhen := getProc('DAQmxSetHshkSampleInputDataWhen');
  DAQmxResetHshkSampleInputDataWhen := getProc('DAQmxResetHshkSampleInputDataWhen');
  DAQmxGetChangeDetectDIRisingEdgePhysicalChans := getProc('DAQmxGetChangeDetectDIRisingEdgePhysicalChans');
  DAQmxSetChangeDetectDIRisingEdgePhysicalChans := getProc('DAQmxSetChangeDetectDIRisingEdgePhysicalChans');
  DAQmxResetChangeDetectDIRisingEdgePhysicalChans := getProc('DAQmxResetChangeDetectDIRisingEdgePhysicalChans');
  DAQmxGetChangeDetectDIFallingEdgePhysicalChans := getProc('DAQmxGetChangeDetectDIFallingEdgePhysicalChans');
  DAQmxSetChangeDetectDIFallingEdgePhysicalChans := getProc('DAQmxSetChangeDetectDIFallingEdgePhysicalChans');
  DAQmxResetChangeDetectDIFallingEdgePhysicalChans := getProc('DAQmxResetChangeDetectDIFallingEdgePhysicalChans');
  DAQmxGetOnDemandSimultaneousAOEnable := getProc('DAQmxGetOnDemandSimultaneousAOEnable_VB6');
  DAQmxSetOnDemandSimultaneousAOEnable := getProc('DAQmxSetOnDemandSimultaneousAOEnable');
  DAQmxResetOnDemandSimultaneousAOEnable := getProc('DAQmxResetOnDemandSimultaneousAOEnable');
  DAQmxGetAIConvRate := getProc('DAQmxGetAIConvRate');
  DAQmxSetAIConvRate := getProc('DAQmxSetAIConvRate');
  DAQmxResetAIConvRate := getProc('DAQmxResetAIConvRate');
  DAQmxGetAIConvRateEx := getProc('DAQmxGetAIConvRateEx');
  DAQmxSetAIConvRateEx := getProc('DAQmxSetAIConvRateEx');
  DAQmxResetAIConvRateEx := getProc('DAQmxResetAIConvRateEx');
  DAQmxGetAIConvMaxRate := getProc('DAQmxGetAIConvMaxRate');
  DAQmxGetAIConvMaxRateEx := getProc('DAQmxGetAIConvMaxRateEx');
  DAQmxGetAIConvSrc := getProc('DAQmxGetAIConvSrc');
  DAQmxSetAIConvSrc := getProc('DAQmxSetAIConvSrc');
  DAQmxResetAIConvSrc := getProc('DAQmxResetAIConvSrc');
  DAQmxGetAIConvSrcEx := getProc('DAQmxGetAIConvSrcEx');
  DAQmxSetAIConvSrcEx := getProc('DAQmxSetAIConvSrcEx');
  DAQmxResetAIConvSrcEx := getProc('DAQmxResetAIConvSrcEx');
  DAQmxGetAIConvActiveEdge := getProc('DAQmxGetAIConvActiveEdge');
  DAQmxSetAIConvActiveEdge := getProc('DAQmxSetAIConvActiveEdge');
  DAQmxResetAIConvActiveEdge := getProc('DAQmxResetAIConvActiveEdge');
  DAQmxGetAIConvActiveEdgeEx := getProc('DAQmxGetAIConvActiveEdgeEx');
  DAQmxSetAIConvActiveEdgeEx := getProc('DAQmxSetAIConvActiveEdgeEx');
  DAQmxResetAIConvActiveEdgeEx := getProc('DAQmxResetAIConvActiveEdgeEx');
  DAQmxGetAIConvTimebaseDiv := getProc('DAQmxGetAIConvTimebaseDiv');
  DAQmxSetAIConvTimebaseDiv := getProc('DAQmxSetAIConvTimebaseDiv');
  DAQmxResetAIConvTimebaseDiv := getProc('DAQmxResetAIConvTimebaseDiv');
  DAQmxGetAIConvTimebaseDivEx := getProc('DAQmxGetAIConvTimebaseDivEx');
  DAQmxSetAIConvTimebaseDivEx := getProc('DAQmxSetAIConvTimebaseDivEx');
  DAQmxResetAIConvTimebaseDivEx := getProc('DAQmxResetAIConvTimebaseDivEx');
  DAQmxGetAIConvTimebaseSrc := getProc('DAQmxGetAIConvTimebaseSrc');
  DAQmxSetAIConvTimebaseSrc := getProc('DAQmxSetAIConvTimebaseSrc');
  DAQmxResetAIConvTimebaseSrc := getProc('DAQmxResetAIConvTimebaseSrc');
  DAQmxGetAIConvTimebaseSrcEx := getProc('DAQmxGetAIConvTimebaseSrcEx');
  DAQmxSetAIConvTimebaseSrcEx := getProc('DAQmxSetAIConvTimebaseSrcEx');
  DAQmxResetAIConvTimebaseSrcEx := getProc('DAQmxResetAIConvTimebaseSrcEx');
  DAQmxGetDelayFromSampClkDelayUnits := getProc('DAQmxGetDelayFromSampClkDelayUnits');
  DAQmxSetDelayFromSampClkDelayUnits := getProc('DAQmxSetDelayFromSampClkDelayUnits');
  DAQmxResetDelayFromSampClkDelayUnits := getProc('DAQmxResetDelayFromSampClkDelayUnits');
  DAQmxGetDelayFromSampClkDelayUnitsEx := getProc('DAQmxGetDelayFromSampClkDelayUnitsEx');
  DAQmxSetDelayFromSampClkDelayUnitsEx := getProc('DAQmxSetDelayFromSampClkDelayUnitsEx');
  DAQmxResetDelayFromSampClkDelayUnitsEx := getProc('DAQmxResetDelayFromSampClkDelayUnitsEx');
  DAQmxGetDelayFromSampClkDelay := getProc('DAQmxGetDelayFromSampClkDelay');
  DAQmxSetDelayFromSampClkDelay := getProc('DAQmxSetDelayFromSampClkDelay');
  DAQmxResetDelayFromSampClkDelay := getProc('DAQmxResetDelayFromSampClkDelay');
  DAQmxGetDelayFromSampClkDelayEx := getProc('DAQmxGetDelayFromSampClkDelayEx');
  DAQmxSetDelayFromSampClkDelayEx := getProc('DAQmxSetDelayFromSampClkDelayEx');
  DAQmxResetDelayFromSampClkDelayEx := getProc('DAQmxResetDelayFromSampClkDelayEx');
  DAQmxGetMasterTimebaseRate := getProc('DAQmxGetMasterTimebaseRate');
  DAQmxSetMasterTimebaseRate := getProc('DAQmxSetMasterTimebaseRate');
  DAQmxResetMasterTimebaseRate := getProc('DAQmxResetMasterTimebaseRate');
  DAQmxGetMasterTimebaseSrc := getProc('DAQmxGetMasterTimebaseSrc');
  DAQmxSetMasterTimebaseSrc := getProc('DAQmxSetMasterTimebaseSrc');
  DAQmxResetMasterTimebaseSrc := getProc('DAQmxResetMasterTimebaseSrc');
  DAQmxGetRefClkRate := getProc('DAQmxGetRefClkRate');
  DAQmxSetRefClkRate := getProc('DAQmxSetRefClkRate');
  DAQmxResetRefClkRate := getProc('DAQmxResetRefClkRate');
  DAQmxGetRefClkSrc := getProc('DAQmxGetRefClkSrc');
  DAQmxSetRefClkSrc := getProc('DAQmxSetRefClkSrc');
  DAQmxResetRefClkSrc := getProc('DAQmxResetRefClkSrc');
  DAQmxGetSyncPulseSrc := getProc('DAQmxGetSyncPulseSrc');
  DAQmxSetSyncPulseSrc := getProc('DAQmxSetSyncPulseSrc');
  DAQmxResetSyncPulseSrc := getProc('DAQmxResetSyncPulseSrc');
  DAQmxGetSyncPulseSyncTime := getProc('DAQmxGetSyncPulseSyncTime');
  DAQmxGetSyncPulseMinDelayToStart := getProc('DAQmxGetSyncPulseMinDelayToStart');
  DAQmxSetSyncPulseMinDelayToStart := getProc('DAQmxSetSyncPulseMinDelayToStart');
  DAQmxResetSyncPulseMinDelayToStart := getProc('DAQmxResetSyncPulseMinDelayToStart');
  DAQmxGetStartTrigType := getProc('DAQmxGetStartTrigType');
  DAQmxSetStartTrigType := getProc('DAQmxSetStartTrigType');
  DAQmxResetStartTrigType := getProc('DAQmxResetStartTrigType');
  DAQmxGetDigEdgeStartTrigSrc := getProc('DAQmxGetDigEdgeStartTrigSrc');
  DAQmxSetDigEdgeStartTrigSrc := getProc('DAQmxSetDigEdgeStartTrigSrc');
  DAQmxResetDigEdgeStartTrigSrc := getProc('DAQmxResetDigEdgeStartTrigSrc');
  DAQmxGetDigEdgeStartTrigEdge := getProc('DAQmxGetDigEdgeStartTrigEdge');
  DAQmxSetDigEdgeStartTrigEdge := getProc('DAQmxSetDigEdgeStartTrigEdge');
  DAQmxResetDigEdgeStartTrigEdge := getProc('DAQmxResetDigEdgeStartTrigEdge');
  DAQmxGetDigEdgeStartTrigDigFltrEnable := getProc('DAQmxGetDigEdgeStartTrigDigFltrEnable_VB6');
  DAQmxSetDigEdgeStartTrigDigFltrEnable := getProc('DAQmxSetDigEdgeStartTrigDigFltrEnable');
  DAQmxResetDigEdgeStartTrigDigFltrEnable := getProc('DAQmxResetDigEdgeStartTrigDigFltrEnable');
  DAQmxGetDigEdgeStartTrigDigFltrMinPulseWidth := getProc('DAQmxGetDigEdgeStartTrigDigFltrMinPulseWidth');
  DAQmxSetDigEdgeStartTrigDigFltrMinPulseWidth := getProc('DAQmxSetDigEdgeStartTrigDigFltrMinPulseWidth');
  DAQmxResetDigEdgeStartTrigDigFltrMinPulseWidth := getProc('DAQmxResetDigEdgeStartTrigDigFltrMinPulseWidth');
  DAQmxGetDigEdgeStartTrigDigFltrTimebaseSrc := getProc('DAQmxGetDigEdgeStartTrigDigFltrTimebaseSrc');
  DAQmxSetDigEdgeStartTrigDigFltrTimebaseSrc := getProc('DAQmxSetDigEdgeStartTrigDigFltrTimebaseSrc');
  DAQmxResetDigEdgeStartTrigDigFltrTimebaseSrc := getProc('DAQmxResetDigEdgeStartTrigDigFltrTimebaseSrc');
  DAQmxGetDigEdgeStartTrigDigFltrTimebaseRate := getProc('DAQmxGetDigEdgeStartTrigDigFltrTimebaseRate');
  DAQmxSetDigEdgeStartTrigDigFltrTimebaseRate := getProc('DAQmxSetDigEdgeStartTrigDigFltrTimebaseRate');
  DAQmxResetDigEdgeStartTrigDigFltrTimebaseRate := getProc('DAQmxResetDigEdgeStartTrigDigFltrTimebaseRate');
  DAQmxGetDigEdgeStartTrigDigSyncEnable := getProc('DAQmxGetDigEdgeStartTrigDigSyncEnable_VB6');
  DAQmxSetDigEdgeStartTrigDigSyncEnable := getProc('DAQmxSetDigEdgeStartTrigDigSyncEnable');
  DAQmxResetDigEdgeStartTrigDigSyncEnable := getProc('DAQmxResetDigEdgeStartTrigDigSyncEnable');
  DAQmxGetDigPatternStartTrigSrc := getProc('DAQmxGetDigPatternStartTrigSrc');
  DAQmxSetDigPatternStartTrigSrc := getProc('DAQmxSetDigPatternStartTrigSrc');
  DAQmxResetDigPatternStartTrigSrc := getProc('DAQmxResetDigPatternStartTrigSrc');
  DAQmxGetDigPatternStartTrigPattern := getProc('DAQmxGetDigPatternStartTrigPattern');
  DAQmxSetDigPatternStartTrigPattern := getProc('DAQmxSetDigPatternStartTrigPattern');
  DAQmxResetDigPatternStartTrigPattern := getProc('DAQmxResetDigPatternStartTrigPattern');
  DAQmxGetDigPatternStartTrigWhen := getProc('DAQmxGetDigPatternStartTrigWhen');
  DAQmxSetDigPatternStartTrigWhen := getProc('DAQmxSetDigPatternStartTrigWhen');
  DAQmxResetDigPatternStartTrigWhen := getProc('DAQmxResetDigPatternStartTrigWhen');
  DAQmxGetAnlgEdgeStartTrigSrc := getProc('DAQmxGetAnlgEdgeStartTrigSrc');

  DAQmxSetAnlgEdgeStartTrigSrc := getProc('DAQmxSetAnlgEdgeStartTrigSrc');
  DAQmxResetAnlgEdgeStartTrigSrc := getProc('DAQmxResetAnlgEdgeStartTrigSrc');
  DAQmxGetAnlgEdgeStartTrigSlope := getProc('DAQmxGetAnlgEdgeStartTrigSlope');
  DAQmxSetAnlgEdgeStartTrigSlope := getProc('DAQmxSetAnlgEdgeStartTrigSlope');
  DAQmxResetAnlgEdgeStartTrigSlope := getProc('DAQmxResetAnlgEdgeStartTrigSlope');
  DAQmxGetAnlgEdgeStartTrigLvl := getProc('DAQmxGetAnlgEdgeStartTrigLvl');
  DAQmxSetAnlgEdgeStartTrigLvl := getProc('DAQmxSetAnlgEdgeStartTrigLvl');
  DAQmxResetAnlgEdgeStartTrigLvl := getProc('DAQmxResetAnlgEdgeStartTrigLvl');
  DAQmxGetAnlgEdgeStartTrigHyst := getProc('DAQmxGetAnlgEdgeStartTrigHyst');
  DAQmxSetAnlgEdgeStartTrigHyst := getProc('DAQmxSetAnlgEdgeStartTrigHyst');
  DAQmxResetAnlgEdgeStartTrigHyst := getProc('DAQmxResetAnlgEdgeStartTrigHyst');
  DAQmxGetAnlgEdgeStartTrigCoupling := getProc('DAQmxGetAnlgEdgeStartTrigCoupling');
  DAQmxSetAnlgEdgeStartTrigCoupling := getProc('DAQmxSetAnlgEdgeStartTrigCoupling');
  DAQmxResetAnlgEdgeStartTrigCoupling := getProc('DAQmxResetAnlgEdgeStartTrigCoupling');
  DAQmxGetAnlgWinStartTrigSrc := getProc('DAQmxGetAnlgWinStartTrigSrc');
  DAQmxSetAnlgWinStartTrigSrc := getProc('DAQmxSetAnlgWinStartTrigSrc');
  DAQmxResetAnlgWinStartTrigSrc := getProc('DAQmxResetAnlgWinStartTrigSrc');
  DAQmxGetAnlgWinStartTrigWhen := getProc('DAQmxGetAnlgWinStartTrigWhen');
  DAQmxSetAnlgWinStartTrigWhen := getProc('DAQmxSetAnlgWinStartTrigWhen');
  DAQmxResetAnlgWinStartTrigWhen := getProc('DAQmxResetAnlgWinStartTrigWhen');
  DAQmxGetAnlgWinStartTrigTop := getProc('DAQmxGetAnlgWinStartTrigTop');
  DAQmxSetAnlgWinStartTrigTop := getProc('DAQmxSetAnlgWinStartTrigTop');
  DAQmxResetAnlgWinStartTrigTop := getProc('DAQmxResetAnlgWinStartTrigTop');
  DAQmxGetAnlgWinStartTrigBtm := getProc('DAQmxGetAnlgWinStartTrigBtm');
  DAQmxSetAnlgWinStartTrigBtm := getProc('DAQmxSetAnlgWinStartTrigBtm');
  DAQmxResetAnlgWinStartTrigBtm := getProc('DAQmxResetAnlgWinStartTrigBtm');
  DAQmxGetAnlgWinStartTrigCoupling := getProc('DAQmxGetAnlgWinStartTrigCoupling');
  DAQmxSetAnlgWinStartTrigCoupling := getProc('DAQmxSetAnlgWinStartTrigCoupling');
  DAQmxResetAnlgWinStartTrigCoupling := getProc('DAQmxResetAnlgWinStartTrigCoupling');
  DAQmxGetStartTrigDelay := getProc('DAQmxGetStartTrigDelay');
  DAQmxSetStartTrigDelay := getProc('DAQmxSetStartTrigDelay');
  DAQmxResetStartTrigDelay := getProc('DAQmxResetStartTrigDelay');
  DAQmxGetStartTrigDelayUnits := getProc('DAQmxGetStartTrigDelayUnits');
  DAQmxSetStartTrigDelayUnits := getProc('DAQmxSetStartTrigDelayUnits');
  DAQmxResetStartTrigDelayUnits := getProc('DAQmxResetStartTrigDelayUnits');
  DAQmxGetStartTrigRetriggerable := getProc('DAQmxGetStartTrigRetriggerable_VB6');
  DAQmxSetStartTrigRetriggerable := getProc('DAQmxSetStartTrigRetriggerable');
  DAQmxResetStartTrigRetriggerable := getProc('DAQmxResetStartTrigRetriggerable');
  DAQmxGetRefTrigType := getProc('DAQmxGetRefTrigType');
  DAQmxSetRefTrigType := getProc('DAQmxSetRefTrigType');
  DAQmxResetRefTrigType := getProc('DAQmxResetRefTrigType');
  DAQmxGetRefTrigPretrigSamples := getProc('DAQmxGetRefTrigPretrigSamples');
  DAQmxSetRefTrigPretrigSamples := getProc('DAQmxSetRefTrigPretrigSamples');
  DAQmxResetRefTrigPretrigSamples := getProc('DAQmxResetRefTrigPretrigSamples');
  DAQmxGetDigEdgeRefTrigSrc := getProc('DAQmxGetDigEdgeRefTrigSrc');
  DAQmxSetDigEdgeRefTrigSrc := getProc('DAQmxSetDigEdgeRefTrigSrc');
  DAQmxResetDigEdgeRefTrigSrc := getProc('DAQmxResetDigEdgeRefTrigSrc');
  DAQmxGetDigEdgeRefTrigEdge := getProc('DAQmxGetDigEdgeRefTrigEdge');
  DAQmxSetDigEdgeRefTrigEdge := getProc('DAQmxSetDigEdgeRefTrigEdge');
  DAQmxResetDigEdgeRefTrigEdge := getProc('DAQmxResetDigEdgeRefTrigEdge');
  DAQmxGetDigPatternRefTrigSrc := getProc('DAQmxGetDigPatternRefTrigSrc');
  DAQmxSetDigPatternRefTrigSrc := getProc('DAQmxSetDigPatternRefTrigSrc');
  DAQmxResetDigPatternRefTrigSrc := getProc('DAQmxResetDigPatternRefTrigSrc');
  DAQmxGetDigPatternRefTrigPattern := getProc('DAQmxGetDigPatternRefTrigPattern');
  DAQmxSetDigPatternRefTrigPattern := getProc('DAQmxSetDigPatternRefTrigPattern');
  DAQmxResetDigPatternRefTrigPattern := getProc('DAQmxResetDigPatternRefTrigPattern');
  DAQmxGetDigPatternRefTrigWhen := getProc('DAQmxGetDigPatternRefTrigWhen');
  DAQmxSetDigPatternRefTrigWhen := getProc('DAQmxSetDigPatternRefTrigWhen');
  DAQmxResetDigPatternRefTrigWhen := getProc('DAQmxResetDigPatternRefTrigWhen');
  DAQmxGetAnlgEdgeRefTrigSrc := getProc('DAQmxGetAnlgEdgeRefTrigSrc');
  DAQmxSetAnlgEdgeRefTrigSrc := getProc('DAQmxSetAnlgEdgeRefTrigSrc');
  DAQmxResetAnlgEdgeRefTrigSrc := getProc('DAQmxResetAnlgEdgeRefTrigSrc');
  DAQmxGetAnlgEdgeRefTrigSlope := getProc('DAQmxGetAnlgEdgeRefTrigSlope');
  DAQmxSetAnlgEdgeRefTrigSlope := getProc('DAQmxSetAnlgEdgeRefTrigSlope');
  DAQmxResetAnlgEdgeRefTrigSlope := getProc('DAQmxResetAnlgEdgeRefTrigSlope');
  DAQmxGetAnlgEdgeRefTrigLvl := getProc('DAQmxGetAnlgEdgeRefTrigLvl');
  DAQmxSetAnlgEdgeRefTrigLvl := getProc('DAQmxSetAnlgEdgeRefTrigLvl');
  DAQmxResetAnlgEdgeRefTrigLvl := getProc('DAQmxResetAnlgEdgeRefTrigLvl');
  DAQmxGetAnlgEdgeRefTrigHyst := getProc('DAQmxGetAnlgEdgeRefTrigHyst');
  DAQmxSetAnlgEdgeRefTrigHyst := getProc('DAQmxSetAnlgEdgeRefTrigHyst');
  DAQmxResetAnlgEdgeRefTrigHyst := getProc('DAQmxResetAnlgEdgeRefTrigHyst');
  DAQmxGetAnlgEdgeRefTrigCoupling := getProc('DAQmxGetAnlgEdgeRefTrigCoupling');
  DAQmxSetAnlgEdgeRefTrigCoupling := getProc('DAQmxSetAnlgEdgeRefTrigCoupling');
  DAQmxResetAnlgEdgeRefTrigCoupling := getProc('DAQmxResetAnlgEdgeRefTrigCoupling');
  DAQmxGetAnlgWinRefTrigSrc := getProc('DAQmxGetAnlgWinRefTrigSrc');
  DAQmxSetAnlgWinRefTrigSrc := getProc('DAQmxSetAnlgWinRefTrigSrc');
  DAQmxResetAnlgWinRefTrigSrc := getProc('DAQmxResetAnlgWinRefTrigSrc');
  DAQmxGetAnlgWinRefTrigWhen := getProc('DAQmxGetAnlgWinRefTrigWhen');
  DAQmxSetAnlgWinRefTrigWhen := getProc('DAQmxSetAnlgWinRefTrigWhen');
  DAQmxResetAnlgWinRefTrigWhen := getProc('DAQmxResetAnlgWinRefTrigWhen');
  DAQmxGetAnlgWinRefTrigTop := getProc('DAQmxGetAnlgWinRefTrigTop');
  DAQmxSetAnlgWinRefTrigTop := getProc('DAQmxSetAnlgWinRefTrigTop');
  DAQmxResetAnlgWinRefTrigTop := getProc('DAQmxResetAnlgWinRefTrigTop');
  DAQmxGetAnlgWinRefTrigBtm := getProc('DAQmxGetAnlgWinRefTrigBtm');
  DAQmxSetAnlgWinRefTrigBtm := getProc('DAQmxSetAnlgWinRefTrigBtm');
  DAQmxResetAnlgWinRefTrigBtm := getProc('DAQmxResetAnlgWinRefTrigBtm');
  DAQmxGetAnlgWinRefTrigCoupling := getProc('DAQmxGetAnlgWinRefTrigCoupling');
  DAQmxSetAnlgWinRefTrigCoupling := getProc('DAQmxSetAnlgWinRefTrigCoupling');
  DAQmxResetAnlgWinRefTrigCoupling := getProc('DAQmxResetAnlgWinRefTrigCoupling');
  DAQmxGetAdvTrigType := getProc('DAQmxGetAdvTrigType');
  DAQmxSetAdvTrigType := getProc('DAQmxSetAdvTrigType');
  DAQmxResetAdvTrigType := getProc('DAQmxResetAdvTrigType');
  DAQmxGetDigEdgeAdvTrigSrc := getProc('DAQmxGetDigEdgeAdvTrigSrc');
  DAQmxSetDigEdgeAdvTrigSrc := getProc('DAQmxSetDigEdgeAdvTrigSrc');
  DAQmxResetDigEdgeAdvTrigSrc := getProc('DAQmxResetDigEdgeAdvTrigSrc');
  DAQmxGetDigEdgeAdvTrigEdge := getProc('DAQmxGetDigEdgeAdvTrigEdge');
  DAQmxSetDigEdgeAdvTrigEdge := getProc('DAQmxSetDigEdgeAdvTrigEdge');
  DAQmxResetDigEdgeAdvTrigEdge := getProc('DAQmxResetDigEdgeAdvTrigEdge');
  DAQmxGetDigEdgeAdvTrigDigFltrEnable := getProc('DAQmxGetDigEdgeAdvTrigDigFltrEnable_VB6');
  DAQmxSetDigEdgeAdvTrigDigFltrEnable := getProc('DAQmxSetDigEdgeAdvTrigDigFltrEnable');
  DAQmxResetDigEdgeAdvTrigDigFltrEnable := getProc('DAQmxResetDigEdgeAdvTrigDigFltrEnable');
  DAQmxGetHshkTrigType := getProc('DAQmxGetHshkTrigType');
  DAQmxSetHshkTrigType := getProc('DAQmxSetHshkTrigType');

  DAQmxResetHshkTrigType := getProc('DAQmxResetHshkTrigType');
  DAQmxGetInterlockedHshkTrigSrc := getProc('DAQmxGetInterlockedHshkTrigSrc');
  DAQmxSetInterlockedHshkTrigSrc := getProc('DAQmxSetInterlockedHshkTrigSrc');
  DAQmxResetInterlockedHshkTrigSrc := getProc('DAQmxResetInterlockedHshkTrigSrc');
  DAQmxGetInterlockedHshkTrigAssertedLvl := getProc('DAQmxGetInterlockedHshkTrigAssertedLvl');
  DAQmxSetInterlockedHshkTrigAssertedLvl := getProc('DAQmxSetInterlockedHshkTrigAssertedLvl');
  DAQmxResetInterlockedHshkTrigAssertedLvl := getProc('DAQmxResetInterlockedHshkTrigAssertedLvl');
  DAQmxGetPauseTrigType := getProc('DAQmxGetPauseTrigType');
  DAQmxSetPauseTrigType := getProc('DAQmxSetPauseTrigType');
  DAQmxResetPauseTrigType := getProc('DAQmxResetPauseTrigType');
  DAQmxGetAnlgLvlPauseTrigSrc := getProc('DAQmxGetAnlgLvlPauseTrigSrc');
  DAQmxSetAnlgLvlPauseTrigSrc := getProc('DAQmxSetAnlgLvlPauseTrigSrc');
  DAQmxResetAnlgLvlPauseTrigSrc := getProc('DAQmxResetAnlgLvlPauseTrigSrc');
  DAQmxGetAnlgLvlPauseTrigWhen := getProc('DAQmxGetAnlgLvlPauseTrigWhen');
  DAQmxSetAnlgLvlPauseTrigWhen := getProc('DAQmxSetAnlgLvlPauseTrigWhen');
  DAQmxResetAnlgLvlPauseTrigWhen := getProc('DAQmxResetAnlgLvlPauseTrigWhen');
  DAQmxGetAnlgLvlPauseTrigLvl := getProc('DAQmxGetAnlgLvlPauseTrigLvl');
  DAQmxSetAnlgLvlPauseTrigLvl := getProc('DAQmxSetAnlgLvlPauseTrigLvl');
  DAQmxResetAnlgLvlPauseTrigLvl := getProc('DAQmxResetAnlgLvlPauseTrigLvl');
  DAQmxGetAnlgLvlPauseTrigHyst := getProc('DAQmxGetAnlgLvlPauseTrigHyst');
  DAQmxSetAnlgLvlPauseTrigHyst := getProc('DAQmxSetAnlgLvlPauseTrigHyst');
  DAQmxResetAnlgLvlPauseTrigHyst := getProc('DAQmxResetAnlgLvlPauseTrigHyst');
  DAQmxGetAnlgLvlPauseTrigCoupling := getProc('DAQmxGetAnlgLvlPauseTrigCoupling');
  DAQmxSetAnlgLvlPauseTrigCoupling := getProc('DAQmxSetAnlgLvlPauseTrigCoupling');
  DAQmxResetAnlgLvlPauseTrigCoupling := getProc('DAQmxResetAnlgLvlPauseTrigCoupling');
  DAQmxGetAnlgWinPauseTrigSrc := getProc('DAQmxGetAnlgWinPauseTrigSrc');
  DAQmxSetAnlgWinPauseTrigSrc := getProc('DAQmxSetAnlgWinPauseTrigSrc');
  DAQmxResetAnlgWinPauseTrigSrc := getProc('DAQmxResetAnlgWinPauseTrigSrc');
  DAQmxGetAnlgWinPauseTrigWhen := getProc('DAQmxGetAnlgWinPauseTrigWhen');
  DAQmxSetAnlgWinPauseTrigWhen := getProc('DAQmxSetAnlgWinPauseTrigWhen');
  DAQmxResetAnlgWinPauseTrigWhen := getProc('DAQmxResetAnlgWinPauseTrigWhen');
  DAQmxGetAnlgWinPauseTrigTop := getProc('DAQmxGetAnlgWinPauseTrigTop');
  DAQmxSetAnlgWinPauseTrigTop := getProc('DAQmxSetAnlgWinPauseTrigTop');
  DAQmxResetAnlgWinPauseTrigTop := getProc('DAQmxResetAnlgWinPauseTrigTop');
  DAQmxGetAnlgWinPauseTrigBtm := getProc('DAQmxGetAnlgWinPauseTrigBtm');
  DAQmxSetAnlgWinPauseTrigBtm := getProc('DAQmxSetAnlgWinPauseTrigBtm');
  DAQmxResetAnlgWinPauseTrigBtm := getProc('DAQmxResetAnlgWinPauseTrigBtm');
  DAQmxGetAnlgWinPauseTrigCoupling := getProc('DAQmxGetAnlgWinPauseTrigCoupling');
  DAQmxSetAnlgWinPauseTrigCoupling := getProc('DAQmxSetAnlgWinPauseTrigCoupling');
  DAQmxResetAnlgWinPauseTrigCoupling := getProc('DAQmxResetAnlgWinPauseTrigCoupling');
  DAQmxGetDigLvlPauseTrigSrc := getProc('DAQmxGetDigLvlPauseTrigSrc');
  DAQmxSetDigLvlPauseTrigSrc := getProc('DAQmxSetDigLvlPauseTrigSrc');
  DAQmxResetDigLvlPauseTrigSrc := getProc('DAQmxResetDigLvlPauseTrigSrc');
  DAQmxGetDigLvlPauseTrigWhen := getProc('DAQmxGetDigLvlPauseTrigWhen');
  DAQmxSetDigLvlPauseTrigWhen := getProc('DAQmxSetDigLvlPauseTrigWhen');
  DAQmxResetDigLvlPauseTrigWhen := getProc('DAQmxResetDigLvlPauseTrigWhen');
  DAQmxGetDigLvlPauseTrigDigFltrEnable := getProc('DAQmxGetDigLvlPauseTrigDigFltrEnable_VB6');
  DAQmxSetDigLvlPauseTrigDigFltrEnable := getProc('DAQmxSetDigLvlPauseTrigDigFltrEnable');

  DAQmxResetDigLvlPauseTrigDigFltrEnable := getProc('DAQmxResetDigLvlPauseTrigDigFltrEnable');
  DAQmxGetDigLvlPauseTrigDigFltrMinPulseWidth := getProc('DAQmxGetDigLvlPauseTrigDigFltrMinPulseWidth');
  DAQmxSetDigLvlPauseTrigDigFltrMinPulseWidth := getProc('DAQmxSetDigLvlPauseTrigDigFltrMinPulseWidth');
  DAQmxResetDigLvlPauseTrigDigFltrMinPulseWidth := getProc('DAQmxResetDigLvlPauseTrigDigFltrMinPulseWidth');
  DAQmxGetDigLvlPauseTrigDigFltrTimebaseSrc := getProc('DAQmxGetDigLvlPauseTrigDigFltrTimebaseSrc');
  DAQmxSetDigLvlPauseTrigDigFltrTimebaseSrc := getProc('DAQmxSetDigLvlPauseTrigDigFltrTimebaseSrc');
  DAQmxResetDigLvlPauseTrigDigFltrTimebaseSrc := getProc('DAQmxResetDigLvlPauseTrigDigFltrTimebaseSrc');
  DAQmxGetDigLvlPauseTrigDigFltrTimebaseRate := getProc('DAQmxGetDigLvlPauseTrigDigFltrTimebaseRate');
  DAQmxSetDigLvlPauseTrigDigFltrTimebaseRate := getProc('DAQmxSetDigLvlPauseTrigDigFltrTimebaseRate');
  DAQmxResetDigLvlPauseTrigDigFltrTimebaseRate := getProc('DAQmxResetDigLvlPauseTrigDigFltrTimebaseRate');
  DAQmxGetDigLvlPauseTrigDigSyncEnable := getProc('DAQmxGetDigLvlPauseTrigDigSyncEnable_VB6');
  DAQmxSetDigLvlPauseTrigDigSyncEnable := getProc('DAQmxSetDigLvlPauseTrigDigSyncEnable');
  DAQmxResetDigLvlPauseTrigDigSyncEnable := getProc('DAQmxResetDigLvlPauseTrigDigSyncEnable');
  DAQmxGetDigPatternPauseTrigSrc := getProc('DAQmxGetDigPatternPauseTrigSrc');
  DAQmxSetDigPatternPauseTrigSrc := getProc('DAQmxSetDigPatternPauseTrigSrc');
  DAQmxResetDigPatternPauseTrigSrc := getProc('DAQmxResetDigPatternPauseTrigSrc');
  DAQmxGetDigPatternPauseTrigPattern := getProc('DAQmxGetDigPatternPauseTrigPattern');
  DAQmxSetDigPatternPauseTrigPattern := getProc('DAQmxSetDigPatternPauseTrigPattern');
  DAQmxResetDigPatternPauseTrigPattern := getProc('DAQmxResetDigPatternPauseTrigPattern');
  DAQmxGetDigPatternPauseTrigWhen := getProc('DAQmxGetDigPatternPauseTrigWhen');
  DAQmxSetDigPatternPauseTrigWhen := getProc('DAQmxSetDigPatternPauseTrigWhen');
  DAQmxResetDigPatternPauseTrigWhen := getProc('DAQmxResetDigPatternPauseTrigWhen');
  DAQmxGetArmStartTrigType := getProc('DAQmxGetArmStartTrigType');
  DAQmxSetArmStartTrigType := getProc('DAQmxSetArmStartTrigType');
  DAQmxResetArmStartTrigType := getProc('DAQmxResetArmStartTrigType');
  DAQmxGetDigEdgeArmStartTrigSrc := getProc('DAQmxGetDigEdgeArmStartTrigSrc');
  DAQmxSetDigEdgeArmStartTrigSrc := getProc('DAQmxSetDigEdgeArmStartTrigSrc');
  DAQmxResetDigEdgeArmStartTrigSrc := getProc('DAQmxResetDigEdgeArmStartTrigSrc');
  DAQmxGetDigEdgeArmStartTrigEdge := getProc('DAQmxGetDigEdgeArmStartTrigEdge');
  DAQmxSetDigEdgeArmStartTrigEdge := getProc('DAQmxSetDigEdgeArmStartTrigEdge');
  DAQmxResetDigEdgeArmStartTrigEdge := getProc('DAQmxResetDigEdgeArmStartTrigEdge');
  DAQmxGetDigEdgeArmStartTrigDigFltrEnable := getProc('DAQmxGetDigEdgeArmStartTrigDigFltrEnable_VB6');
  DAQmxSetDigEdgeArmStartTrigDigFltrEnable := getProc('DAQmxSetDigEdgeArmStartTrigDigFltrEnable');
  DAQmxResetDigEdgeArmStartTrigDigFltrEnable := getProc('DAQmxResetDigEdgeArmStartTrigDigFltrEnable');
  DAQmxGetDigEdgeArmStartTrigDigFltrMinPulseWidth := getProc('DAQmxGetDigEdgeArmStartTrigDigFltrMinPulseWidth');
  DAQmxSetDigEdgeArmStartTrigDigFltrMinPulseWidth := getProc('DAQmxSetDigEdgeArmStartTrigDigFltrMinPulseWidth');
  DAQmxResetDigEdgeArmStartTrigDigFltrMinPulseWidth := getProc('DAQmxResetDigEdgeArmStartTrigDigFltrMinPulseWidth');
  DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseSrc := getProc('DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseSrc');
  DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseSrc := getProc('DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseSrc');
  DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseSrc := getProc('DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseSrc');
  DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseRate := getProc('DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseRate');
  DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseRate := getProc('DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseRate');
  DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseRate := getProc('DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseRate');
  DAQmxGetDigEdgeArmStartTrigDigSyncEnable := getProc('DAQmxGetDigEdgeArmStartTrigDigSyncEnable_VB6');
  DAQmxSetDigEdgeArmStartTrigDigSyncEnable := getProc('DAQmxSetDigEdgeArmStartTrigDigSyncEnable');
  DAQmxResetDigEdgeArmStartTrigDigSyncEnable := getProc('DAQmxResetDigEdgeArmStartTrigDigSyncEnable');
  DAQmxGetWatchdogTimeout := getProc('DAQmxGetWatchdogTimeout');
  DAQmxSetWatchdogTimeout := getProc('DAQmxSetWatchdogTimeout');
  DAQmxResetWatchdogTimeout := getProc('DAQmxResetWatchdogTimeout');
  DAQmxGetWatchdogExpirTrigType := getProc('DAQmxGetWatchdogExpirTrigType');
  DAQmxSetWatchdogExpirTrigType := getProc('DAQmxSetWatchdogExpirTrigType');
  DAQmxResetWatchdogExpirTrigType := getProc('DAQmxResetWatchdogExpirTrigType');
  DAQmxGetDigEdgeWatchdogExpirTrigSrc := getProc('DAQmxGetDigEdgeWatchdogExpirTrigSrc');
  DAQmxSetDigEdgeWatchdogExpirTrigSrc := getProc('DAQmxSetDigEdgeWatchdogExpirTrigSrc');
  DAQmxResetDigEdgeWatchdogExpirTrigSrc := getProc('DAQmxResetDigEdgeWatchdogExpirTrigSrc');
  DAQmxGetDigEdgeWatchdogExpirTrigEdge := getProc('DAQmxGetDigEdgeWatchdogExpirTrigEdge');
  DAQmxSetDigEdgeWatchdogExpirTrigEdge := getProc('DAQmxSetDigEdgeWatchdogExpirTrigEdge');
  DAQmxResetDigEdgeWatchdogExpirTrigEdge := getProc('DAQmxResetDigEdgeWatchdogExpirTrigEdge');
  DAQmxGetWatchdogDOExpirState := getProc('DAQmxGetWatchdogDOExpirState');
  DAQmxSetWatchdogDOExpirState := getProc('DAQmxSetWatchdogDOExpirState');
  DAQmxResetWatchdogDOExpirState := getProc('DAQmxResetWatchdogDOExpirState');
  DAQmxGetWatchdogHasExpired := getProc('DAQmxGetWatchdogHasExpired_VB6');
  DAQmxGetWriteRelativeTo := getProc('DAQmxGetWriteRelativeTo');
  DAQmxSetWriteRelativeTo := getProc('DAQmxSetWriteRelativeTo');
  DAQmxResetWriteRelativeTo := getProc('DAQmxResetWriteRelativeTo');
  DAQmxGetWriteOffset := getProc('DAQmxGetWriteOffset');
  DAQmxSetWriteOffset := getProc('DAQmxSetWriteOffset');
  DAQmxResetWriteOffset := getProc('DAQmxResetWriteOffset');
  DAQmxGetWriteRegenMode := getProc('DAQmxGetWriteRegenMode');
  DAQmxSetWriteRegenMode := getProc('DAQmxSetWriteRegenMode');
  DAQmxResetWriteRegenMode := getProc('DAQmxResetWriteRegenMode');
  DAQmxGetWriteCurrWritePos := getProc('DAQmxGetWriteCurrWritePos_VB6');
  DAQmxGetWriteSpaceAvail := getProc('DAQmxGetWriteSpaceAvail');
  DAQmxGetWriteTotalSampPerChanGenerated := getProc('DAQmxGetWriteTotalSampPerChanGenerated_VB6');
  DAQmxGetWriteRawDataWidth := getProc('DAQmxGetWriteRawDataWidth');
  DAQmxGetWriteNumChans := getProc('DAQmxGetWriteNumChans');
  DAQmxGetWriteWaitMode := getProc('DAQmxGetWriteWaitMode');
  DAQmxSetWriteWaitMode := getProc('DAQmxSetWriteWaitMode');

  DAQmxResetWriteWaitMode := getProc('DAQmxResetWriteWaitMode');
  DAQmxGetWriteSleepTime := getProc('DAQmxGetWriteSleepTime');
  DAQmxSetWriteSleepTime := getProc('DAQmxSetWriteSleepTime');
  DAQmxResetWriteSleepTime := getProc('DAQmxResetWriteSleepTime');
  DAQmxGetWriteNextWriteIsLast := getProc('DAQmxGetWriteNextWriteIsLast_VB6');
  DAQmxSetWriteNextWriteIsLast := getProc('DAQmxSetWriteNextWriteIsLast');
  DAQmxResetWriteNextWriteIsLast := getProc('DAQmxResetWriteNextWriteIsLast');
  DAQmxGetWriteDigitalLinesBytesPerChan := getProc('DAQmxGetWriteDigitalLinesBytesPerChan');
  DAQmxGetPhysicalChanAITermCfgs := getProc('DAQmxGetPhysicalChanAITermCfgs');
  DAQmxGetPhysicalChanAOTermCfgs := getProc('DAQmxGetPhysicalChanAOTermCfgs');
  DAQmxGetPhysicalChanDIPortWidth := getProc('DAQmxGetPhysicalChanDIPortWidth');
  DAQmxGetPhysicalChanDISampClkSupported := getProc('DAQmxGetPhysicalChanDISampClkSupported_VB6');
  DAQmxGetPhysicalChanDIChangeDetectSupported := getProc('DAQmxGetPhysicalChanDIChangeDetectSupported_VB6');
  DAQmxGetPhysicalChanDOPortWidth := getProc('DAQmxGetPhysicalChanDOPortWidth');
  DAQmxGetPhysicalChanDOSampClkSupported := getProc('DAQmxGetPhysicalChanDOSampClkSupported_VB6');
  DAQmxGetPhysicalChanTEDSMfgID := getProc('DAQmxGetPhysicalChanTEDSMfgID');
  DAQmxGetPhysicalChanTEDSModelNum := getProc('DAQmxGetPhysicalChanTEDSModelNum');
  DAQmxGetPhysicalChanTEDSSerialNum := getProc('DAQmxGetPhysicalChanTEDSSerialNum');
  DAQmxGetPhysicalChanTEDSVersionNum := getProc('DAQmxGetPhysicalChanTEDSVersionNum');
  DAQmxGetPhysicalChanTEDSVersionLetter := getProc('DAQmxGetPhysicalChanTEDSVersionLetter');
  DAQmxGetPhysicalChanTEDSBitStream := getProc('DAQmxGetPhysicalChanTEDSBitStream');
  DAQmxGetPhysicalChanTEDSTemplateIDs := getProc('DAQmxGetPhysicalChanTEDSTemplateIDs');
  DAQmxGetPersistedTaskAuthor := getProc('DAQmxGetPersistedTaskAuthor');
  DAQmxGetPersistedTaskAllowInteractiveEditing := getProc('DAQmxGetPersistedTaskAllowInteractiveEditing_VB6');
  DAQmxGetPersistedTaskAllowInteractiveDeletion := getProc('DAQmxGetPersistedTaskAllowInteractiveDeletion_VB6');
  DAQmxGetPersistedChanAuthor := getProc('DAQmxGetPersistedChanAuthor');
  DAQmxGetPersistedChanAllowInteractiveEditing := getProc('DAQmxGetPersistedChanAllowInteractiveEditing_VB6');
  DAQmxGetPersistedChanAllowInteractiveDeletion := getProc('DAQmxGetPersistedChanAllowInteractiveDeletion_VB6');
  DAQmxGetPersistedScaleAuthor := getProc('DAQmxGetPersistedScaleAuthor');
  DAQmxGetPersistedScaleAllowInteractiveEditing := getProc('DAQmxGetPersistedScaleAllowInteractiveEditing_VB6');
  DAQmxGetPersistedScaleAllowInteractiveDeletion := getProc('DAQmxGetPersistedScaleAllowInteractiveDeletion_VB6');
  DAQmxGetSampClkTimingResponseMode := getProc('DAQmxGetSampClkTimingResponseMode');
  DAQmxSetSampClkTimingResponseMode := getProc('DAQmxSetSampClkTimingResponseMode');
  DAQmxResetSampClkTimingResponseMode := getProc('DAQmxResetSampClkTimingResponseMode');

end;

function InitNIlib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('nicaiu.dll');
  result:=(hh<>0);

  if not result then exit;

  initNILib1;
  initNILib2;
end;

end.


