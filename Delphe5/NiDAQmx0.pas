

(*============================================================================*)
(*                 National Instruments / Data Acquisition                    *)
(*----------------------------------------------------------------------------*)
(*    Copyright (c) National Instruments 2003.  All Rights Reserved.          *)
(*----------------------------------------------------------------------------*)
(*                                                                            *)
(* Title:       NIDAQmx.h                                                     *)
(* Purpose:     Include file for NI-DAQmx library support.                    *)
(*                                                                            *)
(*============================================================================*)

unit NiDAQmx0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,util1;

type
  TtaskHandle=intG;


(******************************************************************************
 *** NI-DAQmx Attributes ******************************************************
 ******************************************************************************)

// ********* Buffer Attributes **********
Const
  DAQmx_Buf_Input_BufSize                                          = $186C; // Specifies the number of samples the input buffer can hold for each channel in the task. Zero indicates to allocate no buffer. Use a buffer size of 0 to perform a hardware-timed operation without using a buffer. Setting this property overrides the automatic input buffer allocation that NI-DAQmx performs.
  DAQmx_Buf_Input_OnbrdBufSize                                     = $230A; // Indicates in samples per channel the size of the onboard input buffer of the device.
  DAQmx_Buf_Output_BufSize                                         = $186D; // Specifies the number of samples the output buffer can hold for each channel in the task. Zero indicates to allocate no buffer. Use a buffer size of 0 to perform a hardware-timed operation without using a buffer. Setting this property overrides the automatic output buffer allocation that NI-DAQmx performs.
  DAQmx_Buf_Output_OnbrdBufSize                                    = $230B; // Specifies in samples per channel the size of the onboard output buffer of the device.

// ********* Calibration Info Attributes **********
  DAQmx_SelfCal_Supported                                          = $1860; // Indicates whether the device supports self calibration.
  DAQmx_SelfCal_LastTemp                                           = $1864; // Indicates in degrees Celsius the temperature of the device at the time of the last self calibration. Compare this temperature to the current onboard temperature to determine if you should perform another calibration.
  DAQmx_ExtCal_RecommendedInterval                                 = $1868; // Indicates in months the National Instruments recommended interval between each external calibration of the device.
  DAQmx_ExtCal_LastTemp                                            = $1867; // Indicates in degrees Celsius the temperature of the device at the time of the last external calibration. Compare this temperature to the current onboard temperature to determine if you should perform another calibration.
  DAQmx_Cal_UserDefinedInfo                                        = $1861; // Specifies a string that contains arbitrary, user-defined information. This number of characters in this string can be no more than Max Size.
  DAQmx_Cal_UserDefinedInfo_MaxSize                                = $191C; // Indicates the maximum length in characters of Information.
  DAQmx_Cal_DevTemp                                                = $223B; // Indicates in degrees Celsius the current temperature of the device.

// ********* Channel Attributes **********
  DAQmx_AI_Max                                                     = $17DD; // Specifies the maximum value you expect to measure. This value is in the units you specify with a units property. When you query this property, it returns the coerced maximum value that the device can measure with the current settings.
  DAQmx_AI_Min                                                     = $17DE; // Specifies the minimum value you expect to measure. This value is in the units you specify with a units property.  When you query this property, it returns the coerced minimum value that the device can measure with the current settings.
  DAQmx_AI_CustomScaleName                                         = $17E0; // Specifies the name of a custom scale for the channel.
  DAQmx_AI_MeasType                                                = $0695; // Indicates the measurement to take with the analog input channel and in some cases, such as for temperature measurements, the sensor to use.
  DAQmx_AI_Voltage_Units                                           = $1094; // Specifies the units to use to return voltage measurements from the channel.
  DAQmx_AI_Voltage_dBRef                                           = $29B0; // Specifies the decibel reference level in the units of the channel. When you read samples as a waveform, the decibel reference level is included in the waveform attributes.
  DAQmx_AI_Voltage_ACRMS_Units                                     = $17E2; // Specifies the units to use to return voltage RMS measurements from the channel.
  DAQmx_AI_Temp_Units                                              = $1033; // Specifies the units to use to return temperature measurements from the channel.
  DAQmx_AI_Thrmcpl_Type                                            = $1050; // Specifies the type of thermocouple connected to the channel. Thermocouple types differ in composition and measurement range.
  DAQmx_AI_Thrmcpl_ScaleType                                       = $29D0; // Specifies the method or equation form that the thermocouple scale uses.
  DAQmx_AI_Thrmcpl_CJCSrc                                          = $1035; // Indicates the source of cold-junction compensation.
  DAQmx_AI_Thrmcpl_CJCVal                                          = $1036; // Specifies the temperature of the cold junction if CJC Source is DAQmx_Val_ConstVal. Specify this value in the units of the measurement.
  DAQmx_AI_Thrmcpl_CJCChan                                         = $1034; // Indicates the channel that acquires the temperature of the cold junction if CJC Source is DAQmx_Val_Chan. If the channel is a temperature channel, NI-DAQmx acquires the temperature in the correct units. Other channel types, such as a resistance channel with a custom sensor, must use a custom scale to scale values to degrees Celsius.
  DAQmx_AI_RTD_Type                                                = $1032; // Specifies the type of RTD connected to the channel.
  DAQmx_AI_RTD_R0                                                  = $1030; // Specifies in ohms the sensor resistance at 0 deg C. The Callendar-Van Dusen equation requires this value. Refer to the sensor documentation to determine this value.
  DAQmx_AI_RTD_A                                                   = $1010; // Specifies the 'A' constant of the Callendar-Van Dusen equation. NI-DAQmx requires this value when you use a custom RTD.
  DAQmx_AI_RTD_B                                                   = $1011; // Specifies the 'B' constant of the Callendar-Van Dusen equation. NI-DAQmx requires this value when you use a custom RTD.
  DAQmx_AI_RTD_C                                                   = $1013; // Specifies the 'C' constant of the Callendar-Van Dusen equation. NI-DAQmx requires this value when you use a custom RTD.
  DAQmx_AI_Thrmstr_A                                               = $18C9; // Specifies the 'A' constant of the Steinhart-Hart thermistor equation.
  DAQmx_AI_Thrmstr_B                                               = $18CB; // Specifies the 'B' constant of the Steinhart-Hart thermistor equation.
  DAQmx_AI_Thrmstr_C                                               = $18CA; // Specifies the 'C' constant of the Steinhart-Hart thermistor equation.
  DAQmx_AI_Thrmstr_R1                                              = $1061; // Specifies in ohms the value of the reference resistor if you use voltage excitation. NI-DAQmx ignores this value for current excitation.
  DAQmx_AI_ForceReadFromChan                                       = $18F8; // Specifies whether to read from the channel if it is a cold-junction compensation channel. By default, an NI-DAQmx Read function does not return data from cold-junction compensation channels.  Setting this property to TRUE forces read operations to return the cold-junction compensation channel data with the other channels in the task.
  DAQmx_AI_Current_Units                                           = $0701; // Specifies the units to use to return current measurements from the channel.
  DAQmx_AI_Current_ACRMS_Units                                     = $17E3; // Specifies the units to use to return current RMS measurements from the channel.
  DAQmx_AI_Strain_Units                                            = $0981; // Specifies the units to use to return strain measurements from the channel.
  DAQmx_AI_StrainGage_GageFactor                                   = $0994; // Specifies the sensitivity of the strain gage.  Gage factor relates the change in electrical resistance to the change in strain. Refer to the sensor documentation for this value.
  DAQmx_AI_StrainGage_PoissonRatio                                 = $0998; // Specifies the ratio of lateral strain to axial strain in the material you are measuring.
  DAQmx_AI_StrainGage_Cfg                                          = $0982; // Specifies the bridge configuration of the strain  #define = DAQmx_AI_Resistance_Units;                                        $0955 // Specifies the units to use to return resistance measurements.
  DAQmx_AI_Freq_Units                                              = $0806; // Specifies the units to use to return frequency measurements from the channel.
  DAQmx_AI_Freq_ThreshVoltage                                      = $0815; // Specifies the voltage level at which to recognize waveform repetitions. You should select a voltage level that occurs only once within the entire period of a waveform. You also can select a voltage that occurs only once while the voltage rises or falls.
  DAQmx_AI_Freq_Hyst                                               = $0814; // Specifies in volts a window below Threshold Level. The input voltage must pass below Threshold Level minus this value before NI-DAQmx recognizes a waveform repetition at Threshold Level. Hysteresis can improve the measurement accuracy when the signal contains noise or jitter.
  DAQmx_AI_LVDT_Units                                              = $0910; // Specifies the units to use to return linear position measurements from the channel.
  DAQmx_AI_LVDT_Sensitivity                                        = $0939; // Specifies the sensitivity of the LVDT. This value is in the units you specify with Sensitivity Units. Refer to the sensor documentation to determine this value.
  DAQmx_AI_LVDT_SensitivityUnits                                   = $219A; // Specifies the units of Sensitivity.
  DAQmx_AI_RVDT_Units                                              = $0877; // Specifies the units to use to return angular position measurements from the channel.
  DAQmx_AI_RVDT_Sensitivity                                        = $0903; // Specifies the sensitivity of the RVDT. This value is in the units you specify with Sensitivity Units. Refer to the sensor documentation to determine this value.
  DAQmx_AI_RVDT_SensitivityUnits                                   = $219B; // Specifies the units of Sensitivity.
  DAQmx_AI_SoundPressure_MaxSoundPressureLvl                       = $223A; // Specifies the maximum instantaneous sound pressure level you expect to measure. This value is in decibels, referenced to 20 micropascals. NI-DAQmx uses the maximum sound pressure level to calculate values in pascals for Maximum Value and Minimum Value for the channel.
  DAQmx_AI_SoundPressure_Units                                     = $1528; // Specifies the units to use to return sound pressure measurements from the channel.
  DAQmx_AI_SoundPressure_dBRef                                     = $29B1; // Specifies the decibel reference level in the units of the channel. When you read samples as a waveform, the decibel reference level is included in the waveform attributes. NI-DAQmx also uses the decibel reference level when converting Maximum Sound Pressure Level to a voltage level.
  DAQmx_AI_Microphone_Sensitivity                                  = $1536; // Specifies the sensitivity of the microphone. This value is in mV/Pa. Refer to the sensor documentation to determine this value.
  DAQmx_AI_Accel_Units                                             = $0673; // Specifies the units to use to return acceleration measurements from the channel.
  DAQmx_AI_Accel_dBRef                                             = $29B2; // Specifies the decibel reference level in the units of the channel. When you read samples as a waveform, the decibel reference level is included in the waveform attributes.
  DAQmx_AI_Accel_Sensitivity                                       = $0692; // Specifies the sensitivity of the accelerometer. This value is in the units you specify with Sensitivity Units. Refer to the sensor documentation to determine this value.
  DAQmx_AI_Accel_SensitivityUnits                                  = $219C; // Specifies the units of Sensitivity.
  DAQmx_AI_Is_TEDS                                                 = $2983; // Indicates if the virtual channel was initialized using a TEDS bitstream from the corresponding physical channel.
  DAQmx_AI_TEDS_Units                                              = $21E0; // Indicates the units defined by TEDS information associated with the channel.
  DAQmx_AI_Coupling                                                = $0064; // Specifies the coupling for the channel.
  DAQmx_AI_Impedance                                               = $0062; // Specifies the input impedance of the channel.
  DAQmx_AI_TermCfg                                                 = $1097; // Specifies the terminal configuration for the channel.
  DAQmx_AI_InputSrc                                                = $2198; // Specifies the source of the channel. You can use the signal from the I/O connector or one of several calibration signals. Certain devices have a single calibration signal bus. For these devices, you must specify the same calibration signal for all channels you connect to a calibration signal.
  DAQmx_AI_ResistanceCfg                                           = $1881; // Specifies the resistance configuration for the channel. NI-DAQmx uses this value for any resistance-based measurements, including temperature measurement using a thermistor or RTD.
  DAQmx_AI_LeadWireResistance                                      = $17EE; // Specifies in ohms the resistance of the wires that lead to the sensor.
  DAQmx_AI_Bridge_Cfg                                              = $0087; // Specifies the type of Wheatstone bridge that the sensor is.
  DAQmx_AI_Bridge_NomResistance                                    = $17EC; // Specifies in ohms the resistance across each arm of the bridge in an unloaded position.
  DAQmx_AI_Bridge_InitialVoltage                                   = $17ED; // Specifies in volts the output voltage of the bridge in the unloaded condition. NI-DAQmx subtracts this value from any measurements before applying scaling equations.
  DAQmx_AI_Bridge_ShuntCal_Enable                                  = $0094; // Specifies whether to enable a shunt calibration switch. Use Shunt Cal Select to select the switch(es) to enable.
  DAQmx_AI_Bridge_ShuntCal_Select                                  = $21D5; // Specifies which shunt calibration switch(es) to enable.  Use Shunt Cal Enable to enable the switch(es) you specify with this property.
  DAQmx_AI_Bridge_ShuntCal_GainAdjust                              = $193F; // Specifies the result of a shunt calibration. NI-DAQmx multiplies data read from the channel by the value of this property. This value should be close to 1.0.
  DAQmx_AI_Bridge_Balance_CoarsePot                                = $17F1; // Specifies by how much to compensate for offset in the signal. This value can be between 0 and 127.
  DAQmx_AI_Bridge_Balance_FinePot                                  = $18F4; // Specifies by how much to compensate for offset in the signal. This value can be between 0 and 4095.
  DAQmx_AI_CurrentShunt_Loc                                        = $17F2; // Specifies the shunt resistor location for current measurements.
  DAQmx_AI_CurrentShunt_Resistance                                 = $17F3; // Specifies in ohms the external shunt resistance for current measurements.
  DAQmx_AI_Excit_Src                                               = $17F4; // Specifies the source of excitation.
  DAQmx_AI_Excit_Val                                               = $17F5; // Specifies the amount of excitation that the sensor requires. If Voltage or Current is  DAQmx_Val_Voltage, this value is in volts. If Voltage or Current is  DAQmx_Val_Current, this value is in amperes.
  DAQmx_AI_Excit_UseForScaling                                     = $17FC; // Specifies if NI-DAQmx divides the measurement by the excitation. You should typically set this property to TRUE for ratiometric transducers. If you set this property to TRUE, set Maximum Value and Minimum Value to reflect the scaling.
  DAQmx_AI_Excit_UseMultiplexed                                    = $2180; // Specifies if the SCXI-1122 multiplexes the excitation to the upper half of the channels as it advances through the scan list.
  DAQmx_AI_Excit_ActualVal                                         = $1883; // Specifies the actual amount of excitation supplied by an internal excitation source.  If you read an internal excitation source more precisely with an external device, set this property to the value you read.  NI-DAQmx ignores this value for external excitation. When performing shunt calibration, some devices set this property automatically.
  DAQmx_AI_Excit_DCorAC                                            = $17FB; // Specifies if the excitation supply is DC or AC.
  DAQmx_AI_Excit_VoltageOrCurrent                                  = $17F6; // Specifies if the channel uses current or voltage excitation.
  DAQmx_AI_ACExcit_Freq                                            = $0101; // Specifies the AC excitation frequency in Hertz.
  DAQmx_AI_ACExcit_SyncEnable                                      = $0102; // Specifies whether to synchronize the AC excitation source of the channel to that of another channel. Synchronize the excitation sources of multiple channels to use multichannel sensors. Set this property to FALSE for the master channel and to TRUE for the slave channels.
  DAQmx_AI_ACExcit_WireMode                                        = $18CD; // Specifies the number of leads on the LVDT or RVDT. Some sensors require you to tie leads together to create a four- or five- wire sensor. Refer to the sensor documentation for more information.
  DAQmx_AI_Atten                                                   = $1801; // Specifies the amount of attenuation to use.
  DAQmx_AI_Lowpass_Enable                                          = $1802; // Specifies whether to enable the lowpass filter of the channel.
  DAQmx_AI_Lowpass_CutoffFreq                                      = $1803; // Specifies the frequency in Hertz that corresponds to the -3dB cutoff of the filter.
  DAQmx_AI_Lowpass_SwitchCap_ClkSrc                                = $1884; // Specifies the source of the filter clock. If you need a higher resolution for the filter, you can supply an external clock to increase the resolution. Refer to the SCXI-1141/1142/1143 User Manual for more information.
  DAQmx_AI_Lowpass_SwitchCap_ExtClkFreq                            = $1885; // Specifies the frequency of the external clock when you set Clock Source to DAQmx_Val_External.  NI-DAQmx uses this frequency to set the pre- and post- filters on the SCXI-1141, SCXI-1142, and SCXI-1143. On those devices, NI-DAQmx determines the filter cutoff by using the equation f/(100*n), where f is the external frequency, and n is the external clock divisor. Refer to the SCXI-1141/1142/1143 User Manual for more...
  DAQmx_AI_Lowpass_SwitchCap_ExtClkDiv                             = $1886; // Specifies the divisor for the external clock when you set Clock Source to DAQmx_Val_External. On the SCXI-1141, SCXI-1142, and SCXI-1143, NI-DAQmx determines the filter cutoff by using the equation f/(100*n), where f is the external frequency, and n is the external clock divisor. Refer to the SCXI-1141/1142/1143 User Manual for more information.
  DAQmx_AI_Lowpass_SwitchCap_OutClkDiv                             = $1887; // Specifies the divisor for the output clock.  NI-DAQmx uses the cutoff frequency to determine the output clock frequency. Refer to the SCXI-1141/1142/1143 User Manual for more information.
  DAQmx_AI_ResolutionUnits                                         = $1764; // Indicates the units of Resolution Value.
  DAQmx_AI_Resolution                                              = $1765; // Indicates the resolution of the analog-to-digital converter of the channel. This value is in the units you specify with Resolution Units.
  DAQmx_AI_RawSampSize                                             = $22DA; // Indicates in bits the size of a raw sample from the device.
  DAQmx_AI_RawSampJustification                                    = $0050; // Indicates the justification of a raw sample from the device.
  DAQmx_AI_ADCTimingMode                                           = $29F9; // Specifies the ADC timing mode, controlling the tradeoff between speed and effective resolution. Some ADC timing modes provide increased powerline noise rejection. On devices that have an AI Convert clock, this setting affects both the maximum and default values for Rate. You must use the same ADC timing mode for all channels on a device, but you can use different ADC timing modes for different device in the same t...
  DAQmx_AI_Dither_Enable                                           = $0068; // Specifies whether to enable dithering.  Dithering adds Gaussian noise to the input signal. You can use dithering to achieve higher resolution measurements by over sampling the input signal and averaging the results.
  DAQmx_AI_ChanCal_HasValidCalInfo                                 = $2297; // Indicates if the channel has calibration information.
  DAQmx_AI_ChanCal_EnableCal                                       = $2298; // Specifies whether to enable the channel calibration associated with the channel.
  DAQmx_AI_ChanCal_ApplyCalIfExp                                   = $2299; // Specifies whether to apply the channel calibration to the channel after the expiration date has passed.
  DAQmx_AI_ChanCal_ScaleType                                       = $229C; // Specifies the method or equation form that the calibration scale uses.
  DAQmx_AI_ChanCal_Table_PreScaledVals                             = $229D; // Specifies the reference values collected when calibrating the channel.
  DAQmx_AI_ChanCal_Table_ScaledVals                                = $229E; // Specifies the acquired values collected when calibrating the channel.
  DAQmx_AI_ChanCal_Poly_ForwardCoeff                               = $229F; // Specifies the forward polynomial values used for calibrating the channel.
  DAQmx_AI_ChanCal_Poly_ReverseCoeff                               = $22A0; // Specifies the reverse polynomial values used for calibrating the channel.
  DAQmx_AI_ChanCal_OperatorName                                    = $22A3; // Specifies the name of the operator who performed the channel calibration.
  DAQmx_AI_ChanCal_Desc                                            = $22A4; // Specifies the description entered for the calibration of the channel.
  DAQmx_AI_ChanCal_Verif_RefVals                                   = $22A1; // Specifies the reference values collected when verifying the calibration. NI-DAQmx stores these values as a record of calibration accuracy and does not use them in the scaling process.
  DAQmx_AI_ChanCal_Verif_AcqVals                                   = $22A2; // Specifies the acquired values collected when verifying the calibration. NI-DAQmx stores these values as a record of calibration accuracy and does not use them in the scaling process.
  DAQmx_AI_Rng_High                                                = $1815; // Specifies the upper limit of the input range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
  DAQmx_AI_Rng_Low                                                 = $1816; // Specifies the lower limit of the input range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
  DAQmx_AI_Gain                                                    = $1818; // Specifies a gain factor to apply to the channel.
  DAQmx_AI_SampAndHold_Enable                                      = $181A; // Specifies whether to enable the sample and hold circuitry of the device. When you disable sample and hold circuitry, a small voltage offset might be introduced into the signal.  You can eliminate this offset by using Auto Zero Mode to perform an auto zero on the channel.
  DAQmx_AI_AutoZeroMode                                            = $1760; // Specifies how often to measure ground. NI-DAQmx subtracts the measured ground voltage from every sample.
  DAQmx_AI_DataXferMech                                            = $1821; // Specifies the data transfer mode for the device.
  DAQmx_AI_DataXferReqCond                                         = $188B; // Specifies under what condition to transfer data from the onboard memory of the device to the buffer.
  DAQmx_AI_DataXferCustomThreshold                                 = $230C; // Specifies the number of samples that must be in the FIFO to transfer data from the device if Data Transfer Request Condition is DAQmx_Val_OnbrdMemCustomThreshold.
  DAQmx_AI_MemMapEnable                                            = $188C; // Specifies for NI-DAQmx to map hardware registers to the memory space of the application, if possible. Normally, NI-DAQmx maps hardware registers to memory accessible only to the kernel. Mapping the registers to the memory space of the application increases performance. However, if the application accesses the memory space mapped to the registers, it can adversely affect the operation of the device and possibly res...
  DAQmx_AI_RawDataCompressionType                                  = $22D8; // Specifies the type of compression to apply to raw samples returned from the device.
  DAQmx_AI_LossyLSBRemoval_CompressedSampSize                      = $22D9; // Specifies the number of bits to return in a raw sample when Raw Data Compression Type is set to DAQmx_Val_LossyLSBRemoval.
  DAQmx_AI_DevScalingCoeff                                         = $1930; // Indicates the coefficients of a polynomial equation that NI-DAQmx uses to scale values from the native format of the device to volts. Each element of the array corresponds to a term of the equation. For example, if index two of the array is 4, the third term of the equation is 4x^2. Scaling coefficients do not account for any custom scales or sensors contained by the channel.
  DAQmx_AI_EnhancedAliasRejectionEnable                            = $2294; // Specifies whether to enable enhanced alias rejection. By default, enhanced alias rejection is enabled on supported devices. Leave this property set to the default value for most applications.
  DAQmx_AO_Max                                                     = $1186; // Specifies the maximum value you expect to generate. The value is in the units you specify with a units property. If you try to write a value larger than the maximum value, NI-DAQmx generates an error. NI-DAQmx might coerce this value to a smaller value if other task settings restrict the device from generating the desired maximum.
  DAQmx_AO_Min                                                     = $1187; // Specifies the minimum value you expect to generate. The value is in the units you specify with a units property. If you try to write a value smaller than the minimum value, NI-DAQmx generates an error. NI-DAQmx might coerce this value to a larger value if other task settings restrict the device from generating the desired minimum.
  DAQmx_AO_CustomScaleName                                         = $1188; // Specifies the name of a custom scale for the channel.
  DAQmx_AO_OutputType                                              = $1108; // Indicates whether the channel generates voltage,  current, or a waveform.
  DAQmx_AO_Voltage_Units                                           = $1184; // Specifies in what units to generate voltage on the channel. Write data to the channel in the units you select.
  DAQmx_AO_Voltage_CurrentLimit                                    = $2A1D; // Specifies the current limit, in amperes, for the voltage channel.
  DAQmx_AO_Current_Units                                           = $1109; // Specifies in what units to generate current on the channel. Write data to the channel in the units you select.
  DAQmx_AO_FuncGen_Type                                            = $2A18; // Specifies the kind of the waveform to generate.
  DAQmx_AO_FuncGen_Freq                                            = $2A19; // Specifies the frequency of the waveform to generate in hertz.
  DAQmx_AO_FuncGen_Amplitude                                       = $2A1A; // Specifies the zero-to-peak amplitude of the waveform to generate in volts. Zero and negative values are valid.
  DAQmx_AO_FuncGen_Offset                                          = $2A1B; // Specifies the voltage offset of the waveform to generate.
  DAQmx_AO_FuncGen_Square_DutyCycle                                = $2A1C; // Specifies the square wave duty cycle of the waveform to generate.
  DAQmx_AO_FuncGen_ModulationType                                  = $2A22; // Specifies if the device generates a modulated version of the waveform using the original waveform as a carrier and input from an external terminal as the signal.
  DAQmx_AO_FuncGen_FMDeviation                                     = $2A23; // Specifies the FM deviation in hertz per volt when Type is DAQmx_Val_FM.
  DAQmx_AO_OutputImpedance                                         = $1490; // Specifies in ohms the impedance of the analog output stage of the device.
  DAQmx_AO_LoadImpedance                                           = $0121; // Specifies in ohms the load impedance connected to the analog output channel.
  DAQmx_AO_IdleOutputBehavior                                      = $2240; // Specifies the state of the channel when no generation is in progress.
  DAQmx_AO_TermCfg                                                 = $188E; // Specifies the terminal configuration of the channel.
  DAQmx_AO_ResolutionUnits                                         = $182B; // Specifies the units of Resolution Value.
  DAQmx_AO_Resolution                                              = $182C; // Indicates the resolution of the digital-to-analog converter of the channel. This value is in the units you specify with Resolution Units.
  DAQmx_AO_DAC_Rng_High                                            = $182E; // Specifies the upper limit of the output range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
  DAQmx_AO_DAC_Rng_Low                                             = $182D; // Specifies the lower limit of the output range of the device. This value is in the native units of the device. On E Series devices, for example, the native units is volts.
  DAQmx_AO_DAC_Ref_ConnToGnd                                       = $0130; // Specifies whether to ground the internal DAC reference. Grounding the internal DAC reference has the effect of grounding all analog output channels and stopping waveform generation across all analog output channels regardless of whether the channels belong to the current task. You can ground the internal DAC reference only when Source is DAQmx_Val_Internal and Allow Connecting DAC Reference to Ground at Runtime is...
  DAQmx_AO_DAC_Ref_AllowConnToGnd                                  = $1830; // Specifies whether to allow grounding the internal DAC reference at run time. You must set this property to TRUE and set Source to DAQmx_Val_Internal before you can set Connect DAC Reference to Ground to TRUE.
  DAQmx_AO_DAC_Ref_Src                                             = $0132; // Specifies the source of the DAC reference voltage. The value of this voltage source determines the full-scale value of the DAC.
  DAQmx_AO_DAC_Ref_ExtSrc                                          = $2252; // Specifies the source of the DAC reference voltage if Source is DAQmx_Val_External. The valid sources for this signal vary by device.
  DAQmx_AO_DAC_Ref_Val                                             = $1832; // Specifies in volts the value of the DAC reference voltage. This voltage determines the full-scale range of the DAC. Smaller reference voltages result in smaller ranges, but increased resolution.
  DAQmx_AO_DAC_Offset_Src                                          = $2253; // Specifies the source of the DAC offset voltage. The value of this voltage source determines the full-scale value of the DAC.
  DAQmx_AO_DAC_Offset_ExtSrc                                       = $2254; // Specifies the source of the DAC offset voltage if Source is DAQmx_Val_External. The valid sources for this signal vary by device.
  DAQmx_AO_DAC_Offset_Val                                          = $2255; // Specifies in volts the value of the DAC offset voltage. To achieve best accuracy, the DAC offset value should be hand calibrated.
  DAQmx_AO_ReglitchEnable                                          = $0133; // Specifies whether to enable reglitching.  The output of a DAC normally glitches whenever the DAC is updated with a new value. The amount of glitching differs from code to code and is generally largest at major code transitions.  Reglitching generates uniform glitch energy at each code transition and provides for more uniform glitches.  Uniform glitch energy makes it easier to filter out the noise introduced from g...
  DAQmx_AO_Gain                                                    = $0118; // Specifies in decibels the gain factor to apply to the channel.
  DAQmx_AO_UseOnlyOnBrdMem                                         = $183A; // Specifies whether to write samples directly to the onboard memory of the device, bypassing the memory buffer. Generally, you cannot update onboard memory directly after you start the task. Onboard memory includes data FIFOs.
  DAQmx_AO_DataXferMech                                            = $0134; // Specifies the data transfer mode for the device.
  DAQmx_AO_DataXferReqCond                                         = $183C; // Specifies under what condition to transfer data from the buffer to the onboard memory of the device.
  DAQmx_AO_MemMapEnable                                            = $188F; // Specifies for NI-DAQmx to map hardware registers to the memory space of the application, if possible. Normally, NI-DAQmx maps hardware registers to memory accessible only to the kernel. Mapping the registers to the memory space of the application increases performance. However, if the application accesses the memory space mapped to the registers, it can adversely affect the operation of the device and possibly res...
  DAQmx_AO_DevScalingCoeff                                         = $1931; // Indicates the coefficients of a linear equation that NI-DAQmx uses to scale values from a voltage to the native format of the device.  Each element of the array corresponds to a term of the equation. For example, if index two of the array is 4, the third term of the equation is 4x^2.  Scaling coefficients do not account for any custom scales that may be applied to the channel.
  DAQmx_AO_EnhancedImageRejectionEnable                            = $2241; // Specifies whether to enable the DAC interpolation filter. Disable the interpolation filter to improve DAC signal-to-noise ratio at the expense of degraded image rejection.
  DAQmx_DI_InvertLines                                             = $0793; // Specifies whether to invert the lines in the channel. If you set this property to TRUE, the lines are at high logic when off and at low logic when on.
  DAQmx_DI_NumLines                                                = $2178; // Indicates the number of digital lines in the channel.
  DAQmx_DI_DigFltr_Enable                                          = $21D6; // Specifies whether to enable the digital filter for the line(s) or port(s). You can enable the filter on a line-by-line basis. You do not have to enable the filter for all lines in a channel.
  DAQmx_DI_DigFltr_MinPulseWidth                                   = $21D7; // Specifies in seconds the minimum pulse width the filter recognizes as a valid high or low state transition.
  DAQmx_DI_Tristate                                                = $1890; // Specifies whether to tristate the lines in the channel. If you set this property to TRUE, NI-DAQmx tristates the lines in the channel. If you set this property to FALSE, NI-DAQmx does not modify the configuration of the lines even if the lines were previously tristated. Set this property to FALSE to read lines in other tasks or to read output-only lines.
  DAQmx_DI_LogicFamily                                             = $296D; // Specifies the logic family to use for acquisition. A logic family corresponds to voltage thresholds that are compatible with a group of voltage standards. Refer to device documentation for information on the logic high and logic low voltages for these logic families.
  DAQmx_DI_DataXferMech                                            = $2263; // Specifies the data transfer mode for the device.
  DAQmx_DI_DataXferReqCond                                         = $2264; // Specifies under what condition to transfer data from the onboard memory of the device to the buffer.
  DAQmx_DI_MemMapEnable                                            = $296A; // Specifies for NI-DAQmx to map hardware registers to the memory space of the application, if possible. Normally, NI-DAQmx maps hardware registers to memory accessible only to the kernel. Mapping the registers to the memory space of the application increases performance. However, if the application accesses the memory space mapped to the registers, it can adversely affect the operation of the device and possibly res...
  DAQmx_DI_AcquireOn                                               = $2966; // Specifies on which edge of the sample clock to acquire samples.
  DAQmx_DO_OutputDriveType                                         = $1137; // Specifies the drive type for digital output channels.
  DAQmx_DO_InvertLines                                             = $1133; // Specifies whether to invert the lines in the channel. If you set this property to TRUE, the lines are at high logic when off and at low logic when on.
  DAQmx_DO_NumLines                                                = $2179; // Indicates the number of digital lines in the channel.
  DAQmx_DO_Tristate                                                = $18F3; // Specifies whether to stop driving the channel and set it to a high-impedance state. You must commit the task for this setting to take effect.
  DAQmx_DO_LineStates_StartState                                   = $2972; // Specifies the state of the lines in a digital output task when the task starts.
  DAQmx_DO_LineStates_PausedState                                  = $2967; // Specifies the state of the lines in a digital output task when the task pauses.
  DAQmx_DO_LineStates_DoneState                                    = $2968; // Specifies the state of the lines in a digital output task when the task completes execution.
  DAQmx_DO_LogicFamily                                             = $296E; // Specifies the logic family to use for generation. A logic family corresponds to voltage thresholds that are compatible with a group of voltage standards. Refer to device documentation for information on the logic high and logic low voltages for these logic families.
  DAQmx_DO_UseOnlyOnBrdMem                                         = $2265; // Specifies whether to write samples directly to the onboard memory of the device, bypassing the memory buffer. Generally, you cannot update onboard memory after you start the task. Onboard memory includes data FIFOs.
  DAQmx_DO_DataXferMech                                            = $2266; // Specifies the data transfer mode for the device.
  DAQmx_DO_DataXferReqCond                                         = $2267; // Specifies under what condition to transfer data from the buffer to the onboard memory of the device.
  DAQmx_DO_MemMapEnable                                            = $296B; // Specifies for NI-DAQmx to map hardware registers to the memory space of the application, if possible. Normally, NI-DAQmx maps hardware registers to memory accessible only to the kernel. Mapping the registers to the memory space of the application increases performance. However, if the application accesses the memory space mapped to the registers, it can adversely affect the operation of the device and possibly res...
  DAQmx_DO_GenerateOn                                              = $2969; // Specifies on which edge of the sample clock to generate samples.
  DAQmx_CI_Max                                                     = $189C; // Specifies the maximum value you expect to measure. This value is in the units you specify with a units property. When you query this property, it returns the coerced maximum value that the hardware can measure with the current settings.
  DAQmx_CI_Min                                                     = $189D; // Specifies the minimum value you expect to measure. This value is in the units you specify with a units property. When you query this property, it returns the coerced minimum value that the hardware can measure with the current settings.
  DAQmx_CI_CustomScaleName                                         = $189E; // Specifies the name of a custom scale for the channel.
  DAQmx_CI_MeasType                                                = $18A0; // Indicates the measurement to take with the channel.
  DAQmx_CI_Freq_Units                                              = $18A1; // Specifies the units to use to return frequency measurements.
  DAQmx_CI_Freq_Term                                               = $18A2; // Specifies the input terminal of the signal to measure.
  DAQmx_CI_Freq_StartingEdge                                       = $0799; // Specifies between which edges to measure the frequency of the signal.
  DAQmx_CI_Freq_MeasMeth                                           = $0144; // Specifies the method to use to measure the frequency of the signal.
  DAQmx_CI_Freq_MeasTime                                           = $0145; // Specifies in seconds the length of time to measure the frequency of the signal if Method is DAQmx_Val_HighFreq2Ctr. Measurement accuracy increases with increased measurement time and with increased signal frequency. If you measure a high-frequency signal for too long, however, the count register could roll over, which results in an incorrect measurement.
  DAQmx_CI_Freq_Div                                                = $0147; // Specifies the value by which to divide the input signal if  Method is DAQmx_Val_LargeRng2Ctr. The larger the divisor, the more accurate the measurement. However, too large a value could cause the count register to roll over, which results in an incorrect measurement.
  DAQmx_CI_Freq_DigFltr_Enable                                     = $21E7; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_Freq_DigFltr_MinPulseWidth                              = $21E8; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_Freq_DigFltr_TimebaseSrc                                = $21E9; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_Freq_DigFltr_TimebaseRate                               = $21EA; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_Freq_DigSync_Enable                                     = $21EB; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_Period_Units                                            = $18A3; // Specifies the unit to use to return period measurements.
  DAQmx_CI_Period_Term                                             = $18A4; // Specifies the input terminal of the signal to measure.
  DAQmx_CI_Period_StartingEdge                                     = $0852; // Specifies between which edges to measure the period of the signal.
  DAQmx_CI_Period_MeasMeth                                         = $192C; // Specifies the method to use to measure the period of the signal.
  DAQmx_CI_Period_MeasTime                                         = $192D; // Specifies in seconds the length of time to measure the period of the signal if Method is DAQmx_Val_HighFreq2Ctr. Measurement accuracy increases with increased measurement time and with increased signal frequency. If you measure a high-frequency signal for too long, however, the count register could roll over, which results in an incorrect measurement.
  DAQmx_CI_Period_Div                                              = $192E; // Specifies the value by which to divide the input signal if Method is DAQmx_Val_LargeRng2Ctr. The larger the divisor, the more accurate the measurement. However, too large a value could cause the count register to roll over, which results in an incorrect measurement.
  DAQmx_CI_Period_DigFltr_Enable                                   = $21EC; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_Period_DigFltr_MinPulseWidth                            = $21ED; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_Period_DigFltr_TimebaseSrc                              = $21EE; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_Period_DigFltr_TimebaseRate                             = $21EF; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_Period_DigSync_Enable                                   = $21F0; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_CountEdges_Term                                         = $18C7; // Specifies the input terminal of the signal to measure.
  DAQmx_CI_CountEdges_Dir                                          = $0696; // Specifies whether to increment or decrement the counter on each edge.
  DAQmx_CI_CountEdges_DirTerm                                      = $21E1; // Specifies the source terminal of the digital signal that controls the count direction if Direction is DAQmx_Val_ExtControlled.
  DAQmx_CI_CountEdges_CountDir_DigFltr_Enable                      = $21F1; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_CountEdges_CountDir_DigFltr_MinPulseWidth               = $21F2; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_CountEdges_CountDir_DigFltr_TimebaseSrc                 = $21F3; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_CountEdges_CountDir_DigFltr_TimebaseRate                = $21F4; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_CountEdges_CountDir_DigSync_Enable                      = $21F5; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_CountEdges_InitialCnt                                   = $0698; // Specifies the starting value from which to count.
  DAQmx_CI_CountEdges_ActiveEdge                                   = $0697; // Specifies on which edges to increment or decrement the counter.
  DAQmx_CI_CountEdges_DigFltr_Enable                               = $21F6; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_CountEdges_DigFltr_MinPulseWidth                        = $21F7; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_CountEdges_DigFltr_TimebaseSrc                          = $21F8; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_CountEdges_DigFltr_TimebaseRate                         = $21F9; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_CountEdges_DigSync_Enable                               = $21FA; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_AngEncoder_Units                                        = $18A6; // Specifies the units to use to return angular position measurements from the channel.
  DAQmx_CI_AngEncoder_PulsesPerRev                                 = $0875; // Specifies the number of pulses the encoder generates per revolution. This value is the number of pulses on either signal A or signal B, not the total number of pulses on both signal A and signal B.
  DAQmx_CI_AngEncoder_InitialAngle                                 = $0881; // Specifies the starting angle of the encoder. This value is in the units you specify with Units.
  DAQmx_CI_LinEncoder_Units                                        = $18A9; // Specifies the units to use to return linear encoder measurements from the channel.
  DAQmx_CI_LinEncoder_DistPerPulse                                 = $0911; // Specifies the distance to measure for each pulse the encoder generates on signal A or signal B. This value is in the units you specify with Units.
  DAQmx_CI_LinEncoder_InitialPos                                   = $0915; // Specifies the position of the encoder when the measurement begins. This value is in the units you specify with Units.
  DAQmx_CI_Encoder_DecodingType                                    = $21E6; // Specifies how to count and interpret the pulses the encoder generates on signal A and signal B. DAQmx_Val_X1, DAQmx_Val_X2, and DAQmx_Val_X4 are valid for quadrature encoders only. DAQmx_Val_TwoPulseCounting is valid for two-pulse encoders only.
  DAQmx_CI_Encoder_AInputTerm                                      = $219D; // Specifies the terminal to which signal A is connected.
  DAQmx_CI_Encoder_AInput_DigFltr_Enable                           = $21FB; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_Encoder_AInput_DigFltr_MinPulseWidth                    = $21FC; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_Encoder_AInput_DigFltr_TimebaseSrc                      = $21FD; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_Encoder_AInput_DigFltr_TimebaseRate                     = $21FE; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_Encoder_AInput_DigSync_Enable                           = $21FF; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_Encoder_BInputTerm                                      = $219E; // Specifies the terminal to which signal B is connected.
  DAQmx_CI_Encoder_BInput_DigFltr_Enable                           = $2200; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_Encoder_BInput_DigFltr_MinPulseWidth                    = $2201; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_Encoder_BInput_DigFltr_TimebaseSrc                      = $2202; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_Encoder_BInput_DigFltr_TimebaseRate                     = $2203; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_Encoder_BInput_DigSync_Enable                           = $2204; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_Encoder_ZInputTerm                                      = $219F; // Specifies the terminal to which signal Z is connected.
  DAQmx_CI_Encoder_ZInput_DigFltr_Enable                           = $2205; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_Encoder_ZInput_DigFltr_MinPulseWidth                    = $2206; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_Encoder_ZInput_DigFltr_TimebaseSrc                      = $2207; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_Encoder_ZInput_DigFltr_TimebaseRate                     = $2208; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_Encoder_ZInput_DigSync_Enable                           = $2209; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_Encoder_ZIndexEnable                                    = $0890; // Specifies whether to use Z indexing for the channel.
  DAQmx_CI_Encoder_ZIndexVal                                       = $0888; // Specifies the value to which to reset the measurement when signal Z is high and signal A and signal B are at the states you specify with Z Index Phase. Specify this value in the units of the measurement.
  DAQmx_CI_Encoder_ZIndexPhase                                     = $0889; // Specifies the states at which signal A and signal B must be while signal Z is high for NI-DAQmx to reset the measurement. If signal Z is never high while signal A and signal B are high, for example, you must choose a phase other than DAQmx_Val_AHighBHigh.
  DAQmx_CI_PulseWidth_Units                                        = $0823; // Specifies the units to use to return pulse width measurements.
  DAQmx_CI_PulseWidth_Term                                         = $18AA; // Specifies the input terminal of the signal to measure.
  DAQmx_CI_PulseWidth_StartingEdge                                 = $0825; // Specifies on which edge of the input signal to begin each pulse width measurement.
  DAQmx_CI_PulseWidth_DigFltr_Enable                               = $220A; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_PulseWidth_DigFltr_MinPulseWidth                        = $220B; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_PulseWidth_DigFltr_TimebaseSrc                          = $220C; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_PulseWidth_DigFltr_TimebaseRate                         = $220D; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_PulseWidth_DigSync_Enable                               = $220E; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_TwoEdgeSep_Units                                        = $18AC; // Specifies the units to use to return two-edge separation measurements from the channel.
  DAQmx_CI_TwoEdgeSep_FirstTerm                                    = $18AD; // Specifies the source terminal of the digital signal that starts each measurement.
  DAQmx_CI_TwoEdgeSep_FirstEdge                                    = $0833; // Specifies on which edge of the first signal to start each measurement.
  DAQmx_CI_TwoEdgeSep_First_DigFltr_Enable                         = $220F; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_TwoEdgeSep_First_DigFltr_MinPulseWidth                  = $2210; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_TwoEdgeSep_First_DigFltr_TimebaseSrc                    = $2211; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_TwoEdgeSep_First_DigFltr_TimebaseRate                   = $2212; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_TwoEdgeSep_First_DigSync_Enable                         = $2213; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_TwoEdgeSep_SecondTerm                                   = $18AE; // Specifies the source terminal of the digital signal that stops each measurement.
  DAQmx_CI_TwoEdgeSep_SecondEdge                                   = $0834; // Specifies on which edge of the second signal to stop each measurement.
  DAQmx_CI_TwoEdgeSep_Second_DigFltr_Enable                        = $2214; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_TwoEdgeSep_Second_DigFltr_MinPulseWidth                 = $2215; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_TwoEdgeSep_Second_DigFltr_TimebaseSrc                   = $2216; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_TwoEdgeSep_Second_DigFltr_TimebaseRate                  = $2217; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_TwoEdgeSep_Second_DigSync_Enable                        = $2218; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_SemiPeriod_Units                                        = $18AF; // Specifies the units to use to return semi-period measurements.
  DAQmx_CI_SemiPeriod_Term                                         = $18B0; // Specifies the input terminal of the signal to measure.
  DAQmx_CI_SemiPeriod_StartingEdge                                 = $22FE; // Specifies on which edge of the input signal to begin semi-period measurement. Semi-period measurements alternate between high time and low time, starting on this edge.
  DAQmx_CI_SemiPeriod_DigFltr_Enable                               = $2219; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_SemiPeriod_DigFltr_MinPulseWidth                        = $221A; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_SemiPeriod_DigFltr_TimebaseSrc                          = $221B; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_SemiPeriod_DigFltr_TimebaseRate                         = $221C; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_SemiPeriod_DigSync_Enable                               = $221D; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_Timestamp_Units                                         = $22B3; // Specifies the units to use to return timestamp measurements.
  DAQmx_CI_Timestamp_InitialSeconds                                = $22B4; // Specifies the number of seconds that elapsed since the beginning of the current year. This value is ignored if  Synchronization Method is DAQmx_Val_IRIGB.
  DAQmx_CI_GPS_SyncMethod                                          = $1092; // Specifies the method to use to synchronize the counter to a GPS receiver.
  DAQmx_CI_GPS_SyncSrc                                             = $1093; // Specifies the terminal to which the GPS synchronization signal is connected.
  DAQmx_CI_CtrTimebaseSrc                                          = $0143; // Specifies the terminal of the timebase to use for the counter.
  DAQmx_CI_CtrTimebaseRate                                         = $18B2; // Specifies in Hertz the frequency of the counter timebase. Specifying the rate of a counter timebase allows you to take measurements in terms of time or frequency rather than in ticks of the timebase. If you use an external timebase and do not specify the rate, you can take measurements only in terms of ticks of the timebase.
  DAQmx_CI_CtrTimebaseActiveEdge                                   = $0142; // Specifies whether a timebase cycle is from rising edge to rising edge or from falling edge to falling edge.
  DAQmx_CI_CtrTimebase_DigFltr_Enable                              = $2271; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CI_CtrTimebase_DigFltr_MinPulseWidth                       = $2272; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CI_CtrTimebase_DigFltr_TimebaseSrc                         = $2273; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CI_CtrTimebase_DigFltr_TimebaseRate                        = $2274; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CI_CtrTimebase_DigSync_Enable                              = $2275; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CI_Count                                                   = $0148; // Indicates the current value of the count register.
  DAQmx_CI_OutputState                                             = $0149; // Indicates the current state of the out terminal of the counter.
  DAQmx_CI_TCReached                                               = $0150; // Indicates whether the counter rolled over. When you query this property, NI-DAQmx resets it to FALSE.
  DAQmx_CI_CtrTimebaseMasterTimebaseDiv                            = $18B3; // Specifies the divisor for an external counter timebase. You can divide the counter timebase in order to measure slower signals without causing the count register to roll over.
  DAQmx_CI_DataXferMech                                            = $0200; // Specifies the data transfer mode for the channel.
  DAQmx_CI_NumPossiblyInvalidSamps                                 = $193C; // Indicates the number of samples that the device might have overwritten before it could transfer them to the buffer.
  DAQmx_CI_DupCountPrevent                                         = $21AC; // Specifies whether to enable duplicate count prevention for the channel. Duplicate count prevention is enabled by default. Setting  Prescaler disables duplicate count prevention unless you explicitly enable it.
  DAQmx_CI_Prescaler                                               = $2239; // Specifies the divisor to apply to the signal you connect to the counter source terminal. Scaled data that you read takes this setting into account. You should use a prescaler only when you connect an external signal to the counter source terminal and when that signal has a higher frequency than the fastest onboard timebase. Setting this value disables duplicate count prevention unless you explicitly set Duplicate ...
  DAQmx_CO_OutputType                                              = $18B5; // Indicates how to define pulses generated on the channel.
  DAQmx_CO_Pulse_IdleState                                         = $1170; // Specifies the resting state of the output terminal.
  DAQmx_CO_Pulse_Term                                              = $18E1; // Specifies on which terminal to generate pulses.
  DAQmx_CO_Pulse_Time_Units                                        = $18D6; // Specifies the units in which to define high and low pulse time.
  DAQmx_CO_Pulse_HighTime                                          = $18BA; // Specifies the amount of time that the pulse is at a high voltage. This value is in the units you specify with Units or when you create the channel.
  DAQmx_CO_Pulse_LowTime                                           = $18BB; // Specifies the amount of time that the pulse is at a low voltage. This value is in the units you specify with Units or when you create the channel.
  DAQmx_CO_Pulse_Time_InitialDelay                                 = $18BC; // Specifies in seconds the amount of time to wait before generating the first pulse.
  DAQmx_CO_Pulse_DutyCyc                                           = $1176; // Specifies the duty cycle of the pulses. The duty cycle of a signal is the width of the pulse divided by period. NI-DAQmx uses this ratio and the pulse frequency to determine the width of the pulses and the delay between pulses.
  DAQmx_CO_Pulse_Freq_Units                                        = $18D5; // Specifies the units in which to define pulse frequency.
  DAQmx_CO_Pulse_Freq                                              = $1178; // Specifies the frequency of the pulses to generate. This value is in the units you specify with Units or when you create the channel.
  DAQmx_CO_Pulse_Freq_InitialDelay                                 = $0299; // Specifies in seconds the amount of time to wait before generating the first pulse.
  DAQmx_CO_Pulse_HighTicks                                         = $1169; // Specifies the number of ticks the pulse is high.
  DAQmx_CO_Pulse_LowTicks                                          = $1171; // Specifies the number of ticks the pulse is low.
  DAQmx_CO_Pulse_Ticks_InitialDelay                                = $0298; // Specifies the number of ticks to wait before generating the first pulse.
  DAQmx_CO_CtrTimebaseSrc                                          = $0339; // Specifies the terminal of the timebase to use for the counter. Typically, NI-DAQmx uses one of the internal counter timebases when generating pulses. Use this property to specify an external timebase and produce custom pulse widths that are not possible using the internal timebases.
  DAQmx_CO_CtrTimebaseRate                                         = $18C2; // Specifies in Hertz the frequency of the counter timebase. Specifying the rate of a counter timebase allows you to define output pulses in seconds rather than in ticks of the timebase. If you use an external timebase and do not specify the rate, you can define output pulses only in ticks of the timebase.
  DAQmx_CO_CtrTimebaseActiveEdge                                   = $0341; // Specifies whether a timebase cycle is from rising edge to rising edge or from falling edge to falling edge.
  DAQmx_CO_CtrTimebase_DigFltr_Enable                              = $2276; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_CO_CtrTimebase_DigFltr_MinPulseWidth                       = $2277; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_CO_CtrTimebase_DigFltr_TimebaseSrc                         = $2278; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_CO_CtrTimebase_DigFltr_TimebaseRate                        = $2279; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_CO_CtrTimebase_DigSync_Enable                              = $227A; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_CO_Count                                                   = $0293; // Indicates the current value of the count register.
  DAQmx_CO_OutputState                                             = $0294; // Indicates the current state of the output terminal of the counter.
  DAQmx_CO_AutoIncrCnt                                             = $0295; // Specifies a number of timebase ticks by which to increment each successive pulse.
  DAQmx_CO_CtrTimebaseMasterTimebaseDiv                            = $18C3; // Specifies the divisor for an external counter timebase. You can divide the counter timebase in order to generate slower signals without causing the count register to roll over.
  DAQmx_CO_PulseDone                                               = $190E; // Indicates if the task completed pulse generation. Use this value for retriggerable pulse generation when you need to determine if the device generated the current pulse. When you query this property, NI-DAQmx resets it to FALSE.
  DAQmx_CO_ConstrainedGenMode                                      = $29F2; // Specifies constraints to apply when the counter generates pulses. Constraining the counter reduces the device resources required for counter operation. Constraining the counter can also allow additional analog or counter tasks on the device to run concurrently. For continuous counter tasks, NI-DAQmx consumes no device resources when the counter is constrained. For finite counter tasks, resource use increases with ...
  DAQmx_CO_Prescaler                                               = $226D; // Specifies the divisor to apply to the signal you connect to the counter source terminal. Pulse generations defined by frequency or time take this setting into account, but pulse generations defined by ticks do not. You should use a prescaler only when you connect an external signal to the counter source terminal and when that signal has a higher frequency than the fastest onboard timebase.
  DAQmx_CO_RdyForNewVal                                            = $22FF; // Indicates whether the counter is ready for new continuous pulse train values.
  DAQmx_ChanType                                                   = $187F; // Indicates the type of the virtual channel.
  DAQmx_PhysicalChanName                                           = $18F5; // Specifies the name of the physical channel upon which this virtual channel is based.
  DAQmx_ChanDescr                                                  = $1926; // Specifies a user-defined description for the channel.
  DAQmx_ChanIsGlobal                                               = $2304; // Indicates whether the channel is a global channel.

// ********* Export Signal Attributes **********
  DAQmx_Exported_AIConvClk_OutputTerm                              = $1687; // Specifies the terminal to which to route the AI Convert Clock.
  DAQmx_Exported_AIConvClk_Pulse_Polarity                          = $1688; // Indicates the polarity of the exported AI Convert Clock. The polarity is fixed and independent of the active edge of the source of the AI Convert Clock.
  DAQmx_Exported_10MHzRefClk_OutputTerm                            = $226E; // Specifies the terminal to which to route the 10MHz Clock.
  DAQmx_Exported_20MHzTimebase_OutputTerm                          = $1657; // Specifies the terminal to which to route the 20MHz Timebase.
  DAQmx_Exported_SampClk_OutputBehavior                            = $186B; // Specifies whether the exported Sample Clock issues a pulse at the beginning of a sample or changes to a high state for the duration of the sample.
  DAQmx_Exported_SampClk_OutputTerm                                = $1663; // Specifies the terminal to which to route the Sample Clock.
  DAQmx_Exported_SampClk_DelayOffset                               = $21C4; // Specifies in seconds the amount of time to offset the exported Sample clock.  Refer to timing diagrams for generation applications in the device documentation for more information about this value.
  DAQmx_Exported_SampClk_Pulse_Polarity                            = $1664; // Specifies the polarity of the exported Sample Clock if Output Behavior is DAQmx_Val_Pulse.
  DAQmx_Exported_SampClkTimebase_OutputTerm                        = $18F9; // Specifies the terminal to which to route the Sample Clock Timebase.
  DAQmx_Exported_DividedSampClkTimebase_OutputTerm                 = $21A1; // Specifies the terminal to which to route the Divided Sample Clock Timebase.
  DAQmx_Exported_AdvTrig_OutputTerm                                = $1645; // Specifies the terminal to which to route the Advance Trigger.
  DAQmx_Exported_AdvTrig_Pulse_Polarity                            = $1646; // Indicates the polarity of the exported Advance Trigger.
  DAQmx_Exported_AdvTrig_Pulse_WidthUnits                          = $1647; // Specifies the units of Width Value.
  DAQmx_Exported_AdvTrig_Pulse_Width                               = $1648; // Specifies the width of an exported Advance Trigger pulse. Specify this value in the units you specify with Width Units.
  DAQmx_Exported_PauseTrig_OutputTerm                              = $1615; // Specifies the terminal to which to route the Pause Trigger.
  DAQmx_Exported_PauseTrig_Lvl_ActiveLvl                           = $1616; // Specifies the active level of the exported Pause Trigger.
  DAQmx_Exported_RefTrig_OutputTerm                                = $0590; // Specifies the terminal to which to route the Reference Trigger.
  DAQmx_Exported_RefTrig_Pulse_Polarity                            = $0591; // Specifies the polarity of the exported Reference Trigger.
  DAQmx_Exported_StartTrig_OutputTerm                              = $0584; // Specifies the terminal to which to route the Start Trigger.
  DAQmx_Exported_StartTrig_Pulse_Polarity                          = $0585; // Specifies the polarity of the exported Start Trigger.
  DAQmx_Exported_AdvCmpltEvent_OutputTerm                          = $1651; // Specifies the terminal to which to route the Advance Complete Event.
  DAQmx_Exported_AdvCmpltEvent_Delay                               = $1757; // Specifies the output signal delay in periods of the sample clock.
  DAQmx_Exported_AdvCmpltEvent_Pulse_Polarity                      = $1652; // Specifies the polarity of the exported Advance Complete Event.
  DAQmx_Exported_AdvCmpltEvent_Pulse_Width                         = $1654; // Specifies the width of the exported Advance Complete Event pulse.
  DAQmx_Exported_AIHoldCmpltEvent_OutputTerm                       = $18ED; // Specifies the terminal to which to route the AI Hold Complete Event.
  DAQmx_Exported_AIHoldCmpltEvent_PulsePolarity                    = $18EE; // Specifies the polarity of an exported AI Hold Complete Event pulse.
  DAQmx_Exported_ChangeDetectEvent_OutputTerm                      = $2197; // Specifies the terminal to which to route the Change Detection Event.
  DAQmx_Exported_ChangeDetectEvent_Pulse_Polarity                  = $2303; // Specifies the polarity of an exported Change Detection Event pulse.
  DAQmx_Exported_CtrOutEvent_OutputTerm                            = $1717; // Specifies the terminal to which to route the Counter Output Event.
  DAQmx_Exported_CtrOutEvent_OutputBehavior                        = $174F; // Specifies whether the exported Counter Output Event pulses or changes from one state to the other when the counter reaches terminal count.
  DAQmx_Exported_CtrOutEvent_Pulse_Polarity                        = $1718; // Specifies the polarity of the pulses at the output terminal of the counter when Output Behavior is DAQmx_Val_Pulse. NI-DAQmx ignores this property if Output Behavior is DAQmx_Val_Toggle.
  DAQmx_Exported_CtrOutEvent_Toggle_IdleState                      = $186A; // Specifies the initial state of the output terminal of the counter when Output Behavior is DAQmx_Val_Toggle. The terminal enters this state when NI-DAQmx commits the task.
  DAQmx_Exported_HshkEvent_OutputTerm                              = $22BA; // Specifies the terminal to which to route the Handshake Event.
  DAQmx_Exported_HshkEvent_OutputBehavior                          = $22BB; // Specifies the output behavior of the Handshake Event.
  DAQmx_Exported_HshkEvent_Delay                                   = $22BC; // Specifies the number of seconds to delay after the Handshake Trigger deasserts before asserting the Handshake Event.
  DAQmx_Exported_HshkEvent_Interlocked_AssertedLvl                 = $22BD; // Specifies the asserted level of the exported Handshake Event if Output Behavior is DAQmx_Val_Interlocked.
  DAQmx_Exported_HshkEvent_Interlocked_AssertOnStart               = $22BE; // Specifies to assert the Handshake Event when the task starts if Output Behavior is DAQmx_Val_Interlocked.
  DAQmx_Exported_HshkEvent_Interlocked_DeassertDelay               = $22BF; // Specifies in seconds the amount of time to wait after the Handshake Trigger asserts before deasserting the Handshake Event if Output Behavior is DAQmx_Val_Interlocked.
  DAQmx_Exported_HshkEvent_Pulse_Polarity                          = $22C0; // Specifies the polarity of the exported Handshake Event if Output Behavior is DAQmx_Val_Pulse.
  DAQmx_Exported_HshkEvent_Pulse_Width                             = $22C1; // Specifies in seconds the pulse width of the exported Handshake Event if Output Behavior is DAQmx_Val_Pulse.
  DAQmx_Exported_RdyForXferEvent_OutputTerm                        = $22B5; // Specifies the terminal to which to route the Ready for Transfer Event.
  DAQmx_Exported_RdyForXferEvent_Lvl_ActiveLvl                     = $22B6; // Specifies the active level of the exported Ready for Transfer Event.
  DAQmx_Exported_RdyForXferEvent_DeassertCond                      = $2963; // Specifies when the ready for transfer event deasserts.
  DAQmx_Exported_RdyForXferEvent_DeassertCondCustomThreshold       = $2964; // Specifies in samples the threshold below which the Ready for Transfer Event deasserts. This threshold is an amount of space available in the onboard memory of the device. Deassert Condition must be DAQmx_Val_OnbrdMemCustomThreshold to use a custom threshold.
  DAQmx_Exported_DataActiveEvent_OutputTerm                        = $1633; // Specifies the terminal to which to export the Data Active Event.
  DAQmx_Exported_DataActiveEvent_Lvl_ActiveLvl                     = $1634; // Specifies the polarity of the exported Data Active Event.
  DAQmx_Exported_RdyForStartEvent_OutputTerm                       = $1609; // Specifies the terminal to which to route the Ready for Start Event.
  DAQmx_Exported_RdyForStartEvent_Lvl_ActiveLvl                    = $1751; // Specifies the polarity of the exported Ready for Start Event.
  DAQmx_Exported_SyncPulseEvent_OutputTerm                         = $223C; // Specifies the terminal to which to route the Synchronization Pulse Event.
  DAQmx_Exported_WatchdogExpiredEvent_OutputTerm                   = $21AA; // Specifies the terminal  to which to route the Watchdog Timer Expired Event.

// ********* Device Attributes **********
  DAQmx_Dev_IsSimulated                                            = $22CA; // Indicates if the device is a simulated device.
  DAQmx_Dev_ProductCategory                                        = $29A9; // Indicates the product category of the device. This category corresponds to the category displayed in MAX when creating NI-DAQmx simulated devices.
  DAQmx_Dev_ProductType                                            = $0631; // Indicates the product name of the device.
  DAQmx_Dev_ProductNum                                             = $231D; // Indicates the unique hardware identification number for the device.
  DAQmx_Dev_SerialNum                                              = $0632; // Indicates the serial number of the device. This value is zero if the device does not have a serial number.
  DAQmx_Dev_Chassis_ModuleDevNames                                 = $29B6; // Indicates an array containing the names of the modules in the chassis.
  DAQmx_Dev_AnlgTrigSupported                                      = $2984; // Indicates if the device supports analog triggering.
  DAQmx_Dev_DigTrigSupported                                       = $2985; // Indicates if the device supports digital triggering.
  DAQmx_Dev_AI_PhysicalChans                                       = $231E; // Indicates an array containing the names of the analog input physical channels available on the device.
  DAQmx_Dev_AI_MaxSingleChanRate                                   = $298C; // Indicates the maximum rate for an analog input task if the task contains only a single channel from this device.
  DAQmx_Dev_AI_MaxMultiChanRate                                    = $298D; // Indicates the maximum rate for an analog input task if the task contains multiple channels from this device. For multiplexed devices, divide this rate by the number of channels to determine the maximum sampling rate.
  DAQmx_Dev_AI_MinRate                                             = $298E; // Indicates the minimum rate for an analog input task on this device. NI-DAQmx returns a warning or error if you attempt to sample at a slower rate.
  DAQmx_Dev_AI_SimultaneousSamplingSupported                       = $298F; // Indicates if the device supports simultaneous sampling.
  DAQmx_Dev_AI_TrigUsage                                           = $2986; // Indicates the triggers supported by this device for an analog input task.
  DAQmx_Dev_AI_VoltageRngs                                         = $2990; // Indicates pairs of input voltage ranges supported by this device. Each pair consists of the low value, followed by the high value.
  DAQmx_Dev_AI_VoltageIntExcitDiscreteVals                         = $29C9; // Indicates the set of discrete internal voltage excitation values supported by this device. If the device supports ranges of internal excitation values, use Range Values to determine supported excitation values.
  DAQmx_Dev_AI_VoltageIntExcitRangeVals                            = $29CA; // Indicates pairs of internal voltage excitation ranges supported by this device. Each pair consists of the low value, followed by the high value. If the device supports a set of discrete internal excitation values, use Discrete Values to determine the supported excitation values.
  DAQmx_Dev_AI_CurrentRngs                                         = $2991; // Indicates the pairs of current input ranges supported by this device. Each pair consists of the low value, followed by the high value.
  DAQmx_Dev_AI_CurrentIntExcitDiscreteVals                         = $29CB; // Indicates the set of discrete internal current excitation values supported by this device.
  DAQmx_Dev_AI_FreqRngs                                            = $2992; // Indicates the pairs of frequency input ranges supported by this device. Each pair consists of the low value, followed by the high value.
  DAQmx_Dev_AI_Gains                                               = $2993; // Indicates the input gain settings supported by this device.
  DAQmx_Dev_AI_Couplings                                           = $2994; // Indicates the coupling types supported by this device.
  DAQmx_Dev_AI_LowpassCutoffFreqDiscreteVals                       = $2995; // Indicates the set of discrete lowpass cutoff frequencies supported by this device. If the device supports ranges of lowpass cutoff frequencies, use Range Values to determine supported frequencies.
  DAQmx_Dev_AI_LowpassCutoffFreqRangeVals                          = $29CF; // Indicates pairs of lowpass cutoff frequency ranges supported by this device. Each pair consists of the low value, followed by the high value. If the device supports a set of discrete lowpass cutoff frequencies, use Discrete Values to determine the supported  frequencies.
  DAQmx_Dev_AO_PhysicalChans                                       = $231F; // Indicates an array containing the names of the analog output physical channels available on the device.
  DAQmx_Dev_AO_SampClkSupported                                    = $2996; // Indicates if the device supports the sample clock timing  type for analog output tasks.
  DAQmx_Dev_AO_MaxRate                                             = $2997; // Indicates the maximum analog output rate of the device.
  DAQmx_Dev_AO_MinRate                                             = $2998; // Indicates the minimum analog output rate of the device.
  DAQmx_Dev_AO_TrigUsage                                           = $2987; // Indicates the triggers supported by this device for analog output tasks.
  DAQmx_Dev_AO_VoltageRngs                                         = $299B; // Indicates pairs of output voltage ranges supported by this device. Each pair consists of the low value, followed by the high value.
  DAQmx_Dev_AO_CurrentRngs                                         = $299C; // Indicates pairs of output current ranges supported by this device. Each pair consists of the low value, followed by the high value.
  DAQmx_Dev_AO_Gains                                               = $299D; // Indicates the output gain settings supported by this device.
  DAQmx_Dev_DI_Lines                                               = $2320; // Indicates an array containing the names of the digital input lines available on the device.
  DAQmx_Dev_DI_Ports                                               = $2321; // Indicates an array containing the names of the digital input ports available on the device.
  DAQmx_Dev_DI_MaxRate                                             = $2999; // Indicates the maximum digital input rate of the device.
  DAQmx_Dev_DI_TrigUsage                                           = $2988; // Indicates the triggers supported by this device for digital input tasks.
  DAQmx_Dev_DO_Lines                                               = $2322; // Indicates an array containing the names of the digital output lines available on the device.
  DAQmx_Dev_DO_Ports                                               = $2323; // Indicates an array containing the names of the digital output ports available on the device.
  DAQmx_Dev_DO_MaxRate                                             = $299A; // Indicates the maximum digital output rate of the device.
  DAQmx_Dev_DO_TrigUsage                                           = $2989; // Indicates the triggers supported by this device for digital output tasks.
  DAQmx_Dev_CI_PhysicalChans                                       = $2324; // Indicates an array containing the names of the counter input physical channels available on the device.
  DAQmx_Dev_CI_TrigUsage                                           = $298A; // Indicates the triggers supported by this device for counter input tasks.
  DAQmx_Dev_CI_SampClkSupported                                    = $299E; // Indicates if the device supports the sample clock timing type for counter input tasks.
  DAQmx_Dev_CI_MaxSize                                             = $299F; // Indicates in bits the size of the counters on the device.
  DAQmx_Dev_CI_MaxTimebase                                         = $29A0; // Indicates in hertz the maximum counter timebase frequency.
  DAQmx_Dev_CO_PhysicalChans                                       = $2325; // Indicates an array containing the names of the counter output physical channels available on the device.
  DAQmx_Dev_CO_TrigUsage                                           = $298B; // Indicates the triggers supported by this device for counter output tasks.
  DAQmx_Dev_CO_MaxSize                                             = $29A1; // Indicates in bits the size of the counters on the device.
  DAQmx_Dev_CO_MaxTimebase                                         = $29A2; // Indicates in hertz the maximum counter timebase frequency.
  DAQmx_Dev_BusType                                                = $2326; // Indicates the bus type of the device.
  DAQmx_Dev_NumDMAChans                                            = $233C; // Indicates the number of DMA channels on the device.
  DAQmx_Dev_PCI_BusNum                                             = $2327; // Indicates the PCI bus number of the device.
  DAQmx_Dev_PCI_DevNum                                             = $2328; // Indicates the PCI slot number of the device.
  DAQmx_Dev_PXI_ChassisNum                                         = $2329; // Indicates the PXI chassis number of the device, as identified in MAX.
  DAQmx_Dev_PXI_SlotNum                                            = $232A; // Indicates the PXI slot number of the device.
  DAQmx_Dev_CompactDAQ_ChassisDevName                              = $29B7; // Indicates the name of the CompactDAQ chassis that contains this module.
  DAQmx_Dev_CompactDAQ_SlotNum                                     = $29B8; // Indicates the slot number in which this module is located in the CompactDAQ chassis.
  DAQmx_Dev_Terminals                                              = $2A40; // Indicates a list of all terminals on the device.

// ********* Read Attributes **********
  DAQmx_Read_RelativeTo                                            = $190A; // Specifies the point in the buffer at which to begin a read operation. If you also specify an offset with Offset, the read operation begins at that offset relative to the point you select with this property. The default value is DAQmx_Val_CurrReadPos unless you configure a Reference Trigger for the task. If you configure a Reference Trigger, the default value is DAQmx_Val_FirstPretrigSamp.
  DAQmx_Read_Offset                                                = $190B; // Specifies an offset in samples per channel at which to begin a read operation. This offset is relative to the location you specify with RelativeTo.
  DAQmx_Read_ChannelsToRead                                        = $1823; // Specifies a subset of channels in the task from which to read.
  DAQmx_Read_ReadAllAvailSamp                                      = $1215; // Specifies whether subsequent read operations read all samples currently available in the buffer or wait for the buffer to become full before reading. NI-DAQmx uses this setting for finite acquisitions and only when the number of samples to read is -1. For continuous acquisitions when the number of samples to read is -1, a read operation always reads all samples currently available in the buffer.
  DAQmx_Read_AutoStart                                             = $1826; // Specifies if an NI-DAQmx Read function automatically starts the task  if you did not start the task explicitly by using DAQmxStartTask(). The default value is TRUE. When  an NI-DAQmx Read function starts a finite acquisition task, it also stops the task after reading the last sample.
  DAQmx_Read_OverWrite                                             = $1211; // Specifies whether to overwrite samples in the buffer that you have not yet read.
  DAQmx_Read_CurrReadPos                                           = $1221; // Indicates in samples per channel the current position in the buffer.
  DAQmx_Read_AvailSampPerChan                                      = $1223; // Indicates the number of samples available to read per channel. This value is the same for all channels in the task.
  DAQmx_Read_TotalSampPerChanAcquired                              = $192A; // Indicates the total number of samples acquired by each channel. NI-DAQmx returns a single value because this value is the same for all channels.
  DAQmx_Read_OvercurrentChansExist                                 = $29E6; // Indicates if the device(s) detected an overcurrent condition for any virtual channel in the task. Reading this property clears the overcurrent status for all channels in the task. You must read this property before you read Overcurrent Channels. Otherwise, you will receive an error.
  DAQmx_Read_OvercurrentChans                                      = $29E7; // Indicates the names of any virtual channels in the task for which an overcurrent condition has been detected. You must read Overcurrent Channels Exist before you read this property. Otherwise, you will receive an error. On some devices, you must restart the task for all overcurrent channels to recover.
  DAQmx_Read_OpenCurrentLoopChansExist                             = $2A09; // Indicates if the device(s) detected an open current loop for any virtual channel in the task. Reading this property clears the open current loop status for all channels in the task. You must read this property before you read Open Current Loop Channels. Otherwise, you will receive an error.
  DAQmx_Read_OpenCurrentLoopChans                                  = $2A0A; // Indicates the names of any virtual channels in the task for which the device(s) detected an open current loop. You must read Open Current Loop Channels Exist before you read this property. Otherwise, you will receive an error.
  DAQmx_Read_OverloadedChansExist                                  = $2174; // Indicates if the device(s) detected an overload in any virtual channel in the task. Reading this property clears the overload status for all channels in the task. You must read this property before you read Overloaded Channels. Otherwise, you will receive an error.
  DAQmx_Read_OverloadedChans                                       = $2175; // Indicates the names of any overloaded virtual channels in the task. You must read Overloaded Channels Exist before you read this property. Otherwise, you will receive an error.
  DAQmx_Read_ChangeDetect_HasOverflowed                            = $2194; // Indicates if samples were missed because change detection events occurred faster than the device could handle them. Some devices detect overflows differently than others.
  DAQmx_Read_RawDataWidth                                          = $217A; // Indicates in bytes the size of a raw sample from the task.
  DAQmx_Read_NumChans                                              = $217B; // Indicates the number of channels that an NI-DAQmx Read function reads from the task. This value is the number of channels in the task or the number of channels you specify with Channels to Read.
  DAQmx_Read_DigitalLines_BytesPerChan                             = $217C; // Indicates the number of bytes per channel that NI-DAQmx returns in a sample for line-based reads. If a channel has fewer lines than this number, the extra bytes are FALSE.
  DAQmx_Read_WaitMode                                              = $2232; // Specifies how an NI-DAQmx Read function waits for samples to become available.
  DAQmx_Read_SleepTime                                             = $22B0; // Specifies in seconds the amount of time to sleep after checking for available samples if Wait Mode is DAQmx_Val_Sleep.

// ********* Real-Time Attributes **********
  DAQmx_RealTime_ConvLateErrorsToWarnings                          = $22EE; // Specifies if DAQmxWaitForNextSampleClock() and an NI-DAQmx Read function convert late errors to warnings. NI-DAQmx returns no late warnings or errors until the number of warmup iterations you specify with Number Of Warmup Iterations execute.
  DAQmx_RealTime_NumOfWarmupIters                                  = $22ED; // Specifies the number of loop iterations that must occur before DAQmxWaitForNextSampleClock() and an NI-DAQmx Read function return any late warnings or errors. The system needs a number of iterations to stabilize. During this period, a large amount of jitter occurs, potentially causing reads and writes to be late. The default number of warmup iterations is 100. Specify a larger number if needed to stabilize the sys...
  DAQmx_RealTime_WaitForNextSampClkWaitMode                        = $22EF; // Specifies how DAQmxWaitForNextSampleClock() waits for the next Sample Clock pulse.
  DAQmx_RealTime_ReportMissedSamp                                  = $2319; // Specifies whether an NI-DAQmx Read function returns lateness errors or warnings when it detects missed Sample Clock pulses. This setting does not affect DAQmxWaitForNextSampleClock(). Set this property to TRUE for applications that need to detect lateness without using DAQmxWaitForNextSampleClock().
  DAQmx_RealTime_WriteRecoveryMode                                 = $231A; // Specifies how NI-DAQmx attempts to recover after missing a Sample Clock pulse when performing counter writes.

// ********* Switch Channel Attributes **********
  DAQmx_SwitchChan_Usage                                           = $18E4; // Specifies how you can use the channel. Using this property acts as a safety mechanism to prevent you from connecting two source channels, for example.
  DAQmx_SwitchChan_MaxACCarryCurrent                               = $0648; // Indicates in amperes the maximum AC current that the device can carry.
  DAQmx_SwitchChan_MaxACSwitchCurrent                              = $0646; // Indicates in amperes the maximum AC current that the device can switch. This current is always against an RMS voltage level.
  DAQmx_SwitchChan_MaxACCarryPwr                                   = $0642; // Indicates in watts the maximum AC power that the device can carry.
  DAQmx_SwitchChan_MaxACSwitchPwr                                  = $0644; // Indicates in watts the maximum AC power that the device can switch.
  DAQmx_SwitchChan_MaxDCCarryCurrent                               = $0647; // Indicates in amperes the maximum DC current that the device can carry.
  DAQmx_SwitchChan_MaxDCSwitchCurrent                              = $0645; // Indicates in amperes the maximum DC current that the device can switch. This current is always against a DC voltage level.
  DAQmx_SwitchChan_MaxDCCarryPwr                                   = $0643; // Indicates in watts the maximum DC power that the device can carry.
  DAQmx_SwitchChan_MaxDCSwitchPwr                                  = $0649; // Indicates in watts the maximum DC power that the device can switch.
  DAQmx_SwitchChan_MaxACVoltage                                    = $0651; // Indicates in volts the maximum AC RMS voltage that the device can switch.
  DAQmx_SwitchChan_MaxDCVoltage                                    = $0650; // Indicates in volts the maximum DC voltage that the device can switch.
  DAQmx_SwitchChan_WireMode                                        = $18E5; // Indicates the number of wires that the channel switches.
  DAQmx_SwitchChan_Bandwidth                                       = $0640; // Indicates in Hertz the maximum frequency of a signal that can pass through the switch without significant deterioration.
  DAQmx_SwitchChan_Impedance                                       = $0641; // Indicates in ohms the switch impedance. This value is important in the RF domain and should match the impedance of the sources and loads.

// ********* Switch Device Attributes **********
  DAQmx_SwitchDev_SettlingTime                                     = $1244; // Specifies in seconds the amount of time to wait for the switch to settle (or debounce). NI-DAQmx adds this time to the settling time of the motherboard. Modify this property only if the switch does not settle within the settling time of the motherboard. Refer to device documentation for supported settling times.
  DAQmx_SwitchDev_AutoConnAnlgBus                                  = $17DA; // Specifies if NI-DAQmx routes multiplexed channels to the analog bus backplane. Only the SCXI-1127 and SCXI-1128 support this property.
  DAQmx_SwitchDev_PwrDownLatchRelaysAfterSettling                  = $22DB; // Specifies if DAQmxSwitchWaitForSettling() powers down latching relays after waiting for the device to settle.
  DAQmx_SwitchDev_Settled                                          = $1243; // Indicates when Settling Time expires.
  DAQmx_SwitchDev_RelayList                                        = $17DC; // Indicates a comma-delimited list of relay names.
  DAQmx_SwitchDev_NumRelays                                        = $18E6; // Indicates the number of relays on the device. This value matches the number of relay names in Relay List.
  DAQmx_SwitchDev_SwitchChanList                                   = $18E7; // Indicates a comma-delimited list of channel names for the current topology of the device.
  DAQmx_SwitchDev_NumSwitchChans                                   = $18E8; // Indicates the number of switch channels for the current topology of the device. This value matches the number of channel names in Switch Channel List.
  DAQmx_SwitchDev_NumRows                                          = $18E9; // Indicates the number of rows on a device in a matrix switch topology. Indicates the number of multiplexed channels on a device in a mux topology.
  DAQmx_SwitchDev_NumColumns                                       = $18EA; // Indicates the number of columns on a device in a matrix switch topology. This value is always 1 if the device is in a mux topology.
  DAQmx_SwitchDev_Topology                                         = $193D; // Indicates the current topology of the device. This value is one of the topology options in DAQmxSwitchSetTopologyAndReset().

// ********* Switch Scan Attributes **********
  DAQmx_SwitchScan_BreakMode                                       = $1247; // Specifies the action to take between each entry in a scan list.
  DAQmx_SwitchScan_RepeatMode                                      = $1248; // Specifies if the task advances through the scan list multiple times.
  DAQmx_SwitchScan_WaitingForAdv                                   = $17D9; // Indicates if the switch hardware is waiting for an  Advance Trigger. If the hardware is waiting, it completed the previous entry in the scan list.

// ********* Scale Attributes **********
  DAQmx_Scale_Descr                                                = $1226; // Specifies a description for the scale.
  DAQmx_Scale_ScaledUnits                                          = $191B; // Specifies the units to use for scaled values. You can use an arbitrary string.
  DAQmx_Scale_PreScaledUnits                                       = $18F7; // Specifies the units of the values that you want to scale.
  DAQmx_Scale_Type                                                 = $1929; // Indicates the method or equation form that the custom scale uses.
  DAQmx_Scale_Lin_Slope                                            = $1227; // Specifies the slope, m, in the equation y=mx+b.
  DAQmx_Scale_Lin_YIntercept                                       = $1228; // Specifies the y-intercept, b, in the equation y=mx+b.
  DAQmx_Scale_Map_ScaledMax                                        = $1229; // Specifies the largest value in the range of scaled values. NI-DAQmx maps this value to Pre-Scaled Maximum Value. Reads coerce samples that are larger than this value to match this value. Writes generate errors for samples that are larger than this value.
  DAQmx_Scale_Map_PreScaledMax                                     = $1231; // Specifies the largest value in the range of pre-scaled values. NI-DAQmx maps this value to Scaled Maximum Value.
  DAQmx_Scale_Map_ScaledMin                                        = $1230; // Specifies the smallest value in the range of scaled values. NI-DAQmx maps this value to Pre-Scaled Minimum Value. Reads coerce samples that are smaller than this value to match this value. Writes generate errors for samples that are smaller than this value.
  DAQmx_Scale_Map_PreScaledMin                                     = $1232; // Specifies the smallest value in the range of pre-scaled values. NI-DAQmx maps this value to Scaled Minimum Value.
  DAQmx_Scale_Poly_ForwardCoeff                                    = $1234; // Specifies an array of coefficients for the polynomial that converts pre-scaled values to scaled values. Each element of the array corresponds to a term of the equation. For example, if index three of the array is 9, the fourth term of the equation is 9x^3.
  DAQmx_Scale_Poly_ReverseCoeff                                    = $1235; // Specifies an array of coefficients for the polynomial that converts scaled values to pre-scaled values. Each element of the array corresponds to a term of the equation. For example, if index three of the array is 9, the fourth term of the equation is 9y^3.
  DAQmx_Scale_Table_ScaledVals                                     = $1236; // Specifies an array of scaled values. These values map directly to the values in Pre-Scaled Values.
  DAQmx_Scale_Table_PreScaledVals                                  = $1237; // Specifies an array of pre-scaled values. These values map directly to the values in Scaled Values.

// ********* System Attributes **********
  DAQmx_Sys_GlobalChans                                            = $1265; // Indicates an array that contains the names of all global channels saved on the system.
  DAQmx_Sys_Scales                                                 = $1266; // Indicates an array that contains the names of all custom scales saved on the system.
  DAQmx_Sys_Tasks                                                  = $1267; // Indicates an array that contains the names of all tasks saved on the system.
  DAQmx_Sys_DevNames                                               = $193B; // Indicates the names of all devices installed in the system.
  DAQmx_Sys_NIDAQMajorVersion                                      = $1272; // Indicates the major portion of the installed version of NI-DAQ, such as 7 for version 7.0.
  DAQmx_Sys_NIDAQMinorVersion                                      = $1923; // Indicates the minor portion of the installed version of NI-DAQ, such as 0 for version 7.0.

// ********* Task Attributes **********
  DAQmx_Task_Name                                                  = $1276; // Indicates the name of the task.
  DAQmx_Task_Channels                                              = $1273; // Indicates the names of all virtual channels in the task.
  DAQmx_Task_NumChans                                              = $2181; // Indicates the number of virtual channels in the task.
  DAQmx_Task_Devices                                               = $230E; // Indicates an array containing the names of all devices in the task.
  DAQmx_Task_NumDevices                                            = $29BA; // Indicates the number of devices in the task.
  DAQmx_Task_Complete                                              = $1274; // Indicates whether the task completed execution.

// ********* Timing Attributes **********
  DAQmx_SampQuant_SampMode                                         = $1300; // Specifies if a task acquires or generates a finite number of samples or if it continuously acquires or generates samples.
  DAQmx_SampQuant_SampPerChan                                      = $1310; // Specifies the number of samples to acquire or generate for each channel if Sample Mode is DAQmx_Val_FiniteSamps. If Sample Mode is DAQmx_Val_ContSamps, NI-DAQmx uses this value to determine the buffer size.
  DAQmx_SampTimingType                                             = $1347; // Specifies the type of sample timing to use for the task.
  DAQmx_SampClk_Rate                                               = $1344; // Specifies the sampling rate in samples per channel per second. If you use an external source for the Sample Clock, set this input to the maximum expected rate of that clock.
  DAQmx_SampClk_MaxRate                                            = $22C8; // Indicates the maximum Sample Clock rate supported by the task, based on other timing settings. For output tasks, the maximum Sample Clock rate is the maximum rate of the DAC. For input tasks, NI-DAQmx calculates the maximum sampling rate differently for multiplexed devices than simultaneous sampling devices.
  DAQmx_SampClk_Src                                                = $1852; // Specifies the terminal of the signal to use as the Sample Clock.
  DAQmx_SampClk_ActiveEdge                                         = $1301; // Specifies on which edge of a clock pulse sampling takes place. This property is useful primarily when the signal you use as the Sample Clock is not a periodic clock.
  DAQmx_SampClk_UnderflowBehavior                                  = $2961; // Specifies the action to take when the onboard memory of the device becomes empty.
  DAQmx_SampClk_TimebaseDiv                                        = $18EB; // Specifies the number of Sample Clock Timebase pulses needed to produce a single Sample Clock pulse.
  DAQmx_SampClk_Timebase_Rate                                      = $1303; // Specifies the rate of the Sample Clock Timebase. Some applications require that you specify a rate when you use any signal other than the onboard Sample Clock Timebase. NI-DAQmx requires this rate to calculate other timing parameters.
  DAQmx_SampClk_Timebase_Src                                       = $1308; // Specifies the terminal of the signal to use as the Sample Clock Timebase.
  DAQmx_SampClk_Timebase_ActiveEdge                                = $18EC; // Specifies on which edge to recognize a Sample Clock Timebase pulse. This property is useful primarily when the signal you use as the Sample Clock Timebase is not a periodic clock.
  DAQmx_SampClk_Timebase_MasterTimebaseDiv                         = $1305; // Specifies the number of pulses of the Master Timebase needed to produce a single pulse of the Sample Clock Timebase.
  DAQmx_SampClk_DigFltr_Enable                                     = $221E; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_SampClk_DigFltr_MinPulseWidth                              = $221F; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_SampClk_DigFltr_TimebaseSrc                                = $2220; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_SampClk_DigFltr_TimebaseRate                               = $2221; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_SampClk_DigSync_Enable                                     = $2222; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_Hshk_DelayAfterXfer                                        = $22C2; // Specifies the number of seconds to wait after a handshake cycle before starting a new handshake cycle.
  DAQmx_Hshk_StartCond                                             = $22C3; // Specifies the point in the handshake cycle that the device is in when the task starts.
  DAQmx_Hshk_SampleInputDataWhen                                   = $22C4; // Specifies on which edge of the Handshake Trigger an input task latches the data from the peripheral device.
  DAQmx_ChangeDetect_DI_RisingEdgePhysicalChans                    = $2195; // Specifies the names of the digital lines or ports on which to detect rising edges. The lines or ports must be used by virtual channels in the task. You also can specify a string that contains a list or range of digital lines or ports.
  DAQmx_ChangeDetect_DI_FallingEdgePhysicalChans                   = $2196; // Specifies the names of the digital lines or ports on which to detect falling edges. The lines or ports must be used by virtual channels in the task. You also can specify a string that contains a list or range of digital lines or ports.
  DAQmx_OnDemand_SimultaneousAOEnable                              = $21A0; // Specifies whether to update all channels in the task simultaneously, rather than updating channels independently when you write a sample to that channel.
  DAQmx_AIConv_Rate                                                = $1848; // Specifies in Hertz the rate at which to clock the analog-to-digital converter. This clock is specific to the analog input section of multiplexed devices.
  DAQmx_AIConv_MaxRate                                             = $22C9; // Indicates the maximum convert rate supported by the task, given the current devices and channel count.
  DAQmx_AIConv_Src                                                 = $1502; // Specifies the terminal of the signal to use as the AI Convert Clock.
  DAQmx_AIConv_ActiveEdge                                          = $1853; // Specifies on which edge of the clock pulse an analog-to-digital conversion takes place.
  DAQmx_AIConv_TimebaseDiv                                         = $1335; // Specifies the number of AI Convert Clock Timebase pulses needed to produce a single AI Convert Clock pulse.
  DAQmx_AIConv_Timebase_Src                                        = $1339; // Specifies the terminal  of the signal to use as the AI Convert Clock Timebase.
  DAQmx_DelayFromSampClk_DelayUnits                                = $1304; // Specifies the units of Delay.
  DAQmx_DelayFromSampClk_Delay                                     = $1317; // Specifies the amount of time to wait after receiving a Sample Clock edge before beginning to acquire the sample. This value is in the units you specify with Delay Units.
  DAQmx_MasterTimebase_Rate                                        = $1495; // Specifies the rate of the Master Timebase.
  DAQmx_MasterTimebase_Src                                         = $1343; // Specifies the terminal of the signal to use as the Master Timebase. On an E Series device, you can choose only between the onboard 20MHz Timebase or the RTSI7 terminal.
  DAQmx_RefClk_Rate                                                = $1315; // Specifies the frequency of the Reference Clock.
  DAQmx_RefClk_Src                                                 = $1316; // Specifies the terminal of the signal to use as the Reference Clock.
  DAQmx_SyncPulse_Src                                              = $223D; // Specifies the terminal of the signal to use as the synchronization pulse. The synchronization pulse resets the clock dividers and the ADCs/DACs on the device.
  DAQmx_SyncPulse_SyncTime                                         = $223E; // Indicates in seconds the delay required to reset the ADCs/DACs after the device receives the synchronization pulse.
  DAQmx_SyncPulse_MinDelayToStart                                  = $223F; // Specifies in seconds the amount of time that elapses after the master device issues the synchronization pulse before the task starts.
  DAQmx_SampTimingEngine                                           = $2A26; // Specifies which timing engine to use for the specified timing type. Refer to device documentation for information on supported timing engines.

// ********* Trigger Attributes **********
  DAQmx_StartTrig_Type                                             = $1393; // Specifies the type of trigger to use to start a task.
  DAQmx_DigEdge_StartTrig_Src                                      = $1407; // Specifies the name of a terminal where there is a digital signal to use as the source of the Start Trigger.
  DAQmx_DigEdge_StartTrig_Edge                                     = $1404; // Specifies on which edge of a digital pulse to start acquiring or generating samples.
  DAQmx_DigEdge_StartTrig_DigFltr_Enable                           = $2223; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_DigEdge_StartTrig_DigFltr_MinPulseWidth                    = $2224; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_DigEdge_StartTrig_DigFltr_TimebaseSrc                      = $2225; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_DigEdge_StartTrig_DigFltr_TimebaseRate                     = $2226; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_DigEdge_StartTrig_DigSync_Enable                           = $2227; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_DigPattern_StartTrig_Src                                   = $1410; // Specifies the physical channels to use for pattern matching. The order of the physical channels determines the order of the pattern. If a port is included, the order of the physical channels within the port is in ascending order.
  DAQmx_DigPattern_StartTrig_Pattern                               = $2186; // Specifies the digital pattern that must be met for the Start Trigger to occur.
  DAQmx_DigPattern_StartTrig_When                                  = $1411; // Specifies whether the Start Trigger occurs when the physical channels specified with Source match or differ from the digital pattern specified with Pattern.
  DAQmx_AnlgEdge_StartTrig_Src                                     = $1398; // Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Start Trigger.
  DAQmx_AnlgEdge_StartTrig_Slope                                   = $1397; // Specifies on which slope of the trigger signal to start acquiring or generating samples.
  DAQmx_AnlgEdge_StartTrig_Lvl                                     = $1396; // Specifies at what threshold in the units of the measurement or generation to start acquiring or generating samples. Use Slope to specify on which slope to trigger on this threshold.
  DAQmx_AnlgEdge_StartTrig_Hyst                                    = $1395; // Specifies a hysteresis level in the units of the measurement or generation. If Slope is DAQmx_Val_RisingSlope, the trigger does not deassert until the source signal passes below  Level minus the hysteresis. If Slope is DAQmx_Val_FallingSlope, the trigger does not deassert until the source signal passes above Level plus the hysteresis.
  DAQmx_AnlgEdge_StartTrig_Coupling                                = $2233; // Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
  DAQmx_AnlgWin_StartTrig_Src                                      = $1400; // Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Start Trigger.
  DAQmx_AnlgWin_StartTrig_When                                     = $1401; // Specifies whether the task starts acquiring or generating samples when the signal enters or leaves the window you specify with Bottom and Top.
  DAQmx_AnlgWin_StartTrig_Top                                      = $1403; // Specifies the upper limit of the window. Specify this value in the units of the measurement or generation.
  DAQmx_AnlgWin_StartTrig_Btm                                      = $1402; // Specifies the lower limit of the window. Specify this value in the units of the measurement or generation.
  DAQmx_AnlgWin_StartTrig_Coupling                                 = $2234; // Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
  DAQmx_StartTrig_Delay                                            = $1856; // Specifies an amount of time to wait after the Start Trigger is received before acquiring or generating the first sample. This value is in the units you specify with Delay Units.
  DAQmx_StartTrig_DelayUnits                                       = $18C8; // Specifies the units of Delay.
  DAQmx_StartTrig_Retriggerable                                    = $190F; // Specifies whether to enable retriggerable counter pulse generation. When you set this property to TRUE, the device generates pulses each time it receives a trigger. The device ignores a trigger if it is in the process of generating pulses.
  DAQmx_RefTrig_Type                                               = $1419; // Specifies the type of trigger to use to mark a reference point for the measurement.
  DAQmx_RefTrig_PretrigSamples                                     = $1445; // Specifies the minimum number of pretrigger samples to acquire from each channel before recognizing the reference trigger. Post-trigger samples per channel are equal to Samples Per Channel minus the number of pretrigger samples per channel.
  DAQmx_DigEdge_RefTrig_Src                                        = $1434; // Specifies the name of a terminal where there is a digital signal to use as the source of the Reference Trigger.
  DAQmx_DigEdge_RefTrig_Edge                                       = $1430; // Specifies on what edge of a digital pulse the Reference Trigger occurs.
  DAQmx_DigPattern_RefTrig_Src                                     = $1437; // Specifies the physical channels to use for pattern matching. The order of the physical channels determines the order of the pattern. If a port is included, the order of the physical channels within the port is in ascending order.
  DAQmx_DigPattern_RefTrig_Pattern                                 = $2187; // Specifies the digital pattern that must be met for the Reference Trigger to occur.
  DAQmx_DigPattern_RefTrig_When                                    = $1438; // Specifies whether the Reference Trigger occurs when the physical channels specified with Source match or differ from the digital pattern specified with Pattern.
  DAQmx_AnlgEdge_RefTrig_Src                                       = $1424; // Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Reference Trigger.
  DAQmx_AnlgEdge_RefTrig_Slope                                     = $1423; // Specifies on which slope of the source signal the Reference Trigger occurs.
  DAQmx_AnlgEdge_RefTrig_Lvl                                       = $1422; // Specifies in the units of the measurement the threshold at which the Reference Trigger occurs.  Use Slope to specify on which slope to trigger at this threshold.
  DAQmx_AnlgEdge_RefTrig_Hyst                                      = $1421; // Specifies a hysteresis level in the units of the measurement. If Slope is DAQmx_Val_RisingSlope, the trigger does not deassert until the source signal passes below Level minus the hysteresis. If Slope is DAQmx_Val_FallingSlope, the trigger does not deassert until the source signal passes above Level plus the hysteresis.
  DAQmx_AnlgEdge_RefTrig_Coupling                                  = $2235; // Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
  DAQmx_AnlgWin_RefTrig_Src                                        = $1426; // Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the Reference Trigger.
  DAQmx_AnlgWin_RefTrig_When                                       = $1427; // Specifies whether the Reference Trigger occurs when the source signal enters the window or when it leaves the window. Use Bottom and Top to specify the window.
  DAQmx_AnlgWin_RefTrig_Top                                        = $1429; // Specifies the upper limit of the window. Specify this value in the units of the measurement.
  DAQmx_AnlgWin_RefTrig_Btm                                        = $1428; // Specifies the lower limit of the window. Specify this value in the units of the measurement.
  DAQmx_AnlgWin_RefTrig_Coupling                                   = $1857; // Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
  DAQmx_AdvTrig_Type                                               = $1365; // Specifies the type of trigger to use to advance to the next entry in a switch scan list.
  DAQmx_DigEdge_AdvTrig_Src                                        = $1362; // Specifies the name of a terminal where there is a digital signal to use as the source of the Advance Trigger.
  DAQmx_DigEdge_AdvTrig_Edge                                       = $1360; // Specifies on which edge of a digital signal to advance to the next entry in a scan list.
  DAQmx_DigEdge_AdvTrig_DigFltr_Enable                             = $2238; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_HshkTrig_Type                                              = $22B7; // Specifies the type of Handshake Trigger to use.
  DAQmx_Interlocked_HshkTrig_Src                                   = $22B8; // Specifies the source terminal of the Handshake Trigger.
  DAQmx_Interlocked_HshkTrig_AssertedLvl                           = $22B9; // Specifies the asserted level of the Handshake Trigger.
  DAQmx_PauseTrig_Type                                             = $1366; // Specifies the type of trigger to use to pause a task.
  DAQmx_AnlgLvl_PauseTrig_Src                                      = $1370; // Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the trigger.
  DAQmx_AnlgLvl_PauseTrig_When                                     = $1371; // Specifies whether the task pauses above or below the threshold you specify with Level.
  DAQmx_AnlgLvl_PauseTrig_Lvl                                      = $1369; // Specifies the threshold at which to pause the task. Specify this value in the units of the measurement or generation. Use Pause When to specify whether the task pauses above or below this threshold.
  DAQmx_AnlgLvl_PauseTrig_Hyst                                     = $1368; // Specifies a hysteresis level in the units of the measurement or generation. If Pause When is DAQmx_Val_AboveLvl, the trigger does not deassert until the source signal passes below Level minus the hysteresis. If Pause When is DAQmx_Val_BelowLvl, the trigger does not deassert until the source signal passes above Level plus the hysteresis.
  DAQmx_AnlgLvl_PauseTrig_Coupling                                 = $2236; // Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
  DAQmx_AnlgWin_PauseTrig_Src                                      = $1373; // Specifies the name of a virtual channel or terminal where there is an analog signal to use as the source of the trigger.
  DAQmx_AnlgWin_PauseTrig_When                                     = $1374; // Specifies whether the task pauses while the trigger signal is inside or outside the window you specify with Bottom and Top.
  DAQmx_AnlgWin_PauseTrig_Top                                      = $1376; // Specifies the upper limit of the window. Specify this value in the units of the measurement or generation.
  DAQmx_AnlgWin_PauseTrig_Btm                                      = $1375; // Specifies the lower limit of the window. Specify this value in the units of the measurement or generation.
  DAQmx_AnlgWin_PauseTrig_Coupling                                 = $2237; // Specifies the coupling for the source signal of the trigger if the source is a terminal rather than a virtual channel.
  DAQmx_DigLvl_PauseTrig_Src                                       = $1379; // Specifies the name of a terminal where there is a digital signal to use as the source of the Pause Trigger.
  DAQmx_DigLvl_PauseTrig_When                                      = $1380; // Specifies whether the task pauses while the signal is high or low.
  DAQmx_DigLvl_PauseTrig_DigFltr_Enable                            = $2228; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_DigLvl_PauseTrig_DigFltr_MinPulseWidth                     = $2229; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_DigLvl_PauseTrig_DigFltr_TimebaseSrc                       = $222A; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_DigLvl_PauseTrig_DigFltr_TimebaseRate                      = $222B; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_DigLvl_PauseTrig_DigSync_Enable                            = $222C; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.
  DAQmx_DigPattern_PauseTrig_Src                                   = $216F; // Specifies the physical channels to use for pattern matching. The order of the physical channels determines the order of the pattern. If a port is included, the lines within the port are in ascending order.
  DAQmx_DigPattern_PauseTrig_Pattern                               = $2188; // Specifies the digital pattern that must be met for the Pause Trigger to occur.
  DAQmx_DigPattern_PauseTrig_When                                  = $2170; // Specifies if the Pause Trigger occurs when the physical channels specified with Source match or differ from the digital pattern specified with Pattern.
  DAQmx_ArmStartTrig_Type                                          = $1414; // Specifies the type of trigger to use to arm the task for a Start Trigger. If you configure an Arm Start Trigger, the task does not respond to a Start Trigger until the device receives the Arm Start Trigger.
  DAQmx_DigEdge_ArmStartTrig_Src                                   = $1417; // Specifies the name of a terminal where there is a digital signal to use as the source of the Arm Start Trigger.
  DAQmx_DigEdge_ArmStartTrig_Edge                                  = $1415; // Specifies on which edge of a digital signal to arm the task for a Start Trigger.
  DAQmx_DigEdge_ArmStartTrig_DigFltr_Enable                        = $222D; // Specifies whether to apply the pulse width filter to the signal.
  DAQmx_DigEdge_ArmStartTrig_DigFltr_MinPulseWidth                 = $222E; // Specifies in seconds the minimum pulse width the filter recognizes.
  DAQmx_DigEdge_ArmStartTrig_DigFltr_TimebaseSrc                   = $222F; // Specifies the input terminal of the signal to use as the timebase of the pulse width filter.
  DAQmx_DigEdge_ArmStartTrig_DigFltr_TimebaseRate                  = $2230; // Specifies in hertz the rate of the pulse width filter timebase. NI-DAQmx uses this value to compute settings for the filter.
  DAQmx_DigEdge_ArmStartTrig_DigSync_Enable                        = $2231; // Specifies whether to synchronize recognition of transitions in the signal to the internal timebase of the device.

// ********* Watchdog Attributes **********
  DAQmx_Watchdog_Timeout                                           = $21A9; // Specifies in seconds the amount of time until the watchdog timer expires. A value of -1 means the internal timer never expires. Set this input to -1 if you use an Expiration Trigger to expire the watchdog task.
  DAQmx_WatchdogExpirTrig_Type                                     = $21A3; // Specifies the type of trigger to use to expire a watchdog task.
  DAQmx_DigEdge_WatchdogExpirTrig_Src                              = $21A4; // Specifies the name of a terminal where a digital signal exists to use as the source of the Expiration Trigger.
  DAQmx_DigEdge_WatchdogExpirTrig_Edge                             = $21A5; // Specifies on which edge of a digital signal to expire the watchdog task.
  DAQmx_Watchdog_DO_ExpirState                                     = $21A7; // Specifies the state to which to set the digital physical channels when the watchdog task expires.  You cannot modify the expiration state of dedicated digital input physical channels.
  DAQmx_Watchdog_HasExpired                                        = $21A8; // Indicates if the watchdog timer expired. You can read this property only while the task is running.

// ********* Write Attributes **********
  DAQmx_Write_RelativeTo                                           = $190C; // Specifies the point in the buffer at which to write data. If you also specify an offset with Offset, the write operation begins at that offset relative to this point you select with this property.
  DAQmx_Write_Offset                                               = $190D; // Specifies in samples per channel an offset at which a write operation begins. This offset is relative to the location you specify with Relative To.
  DAQmx_Write_RegenMode                                            = $1453; // Specifies whether to allow NI-DAQmx to generate the same data multiple times.
  DAQmx_Write_CurrWritePos                                         = $1458; // Indicates the position in the buffer of the next sample to generate. This value is identical for all channels in the task.
  DAQmx_Write_OvercurrentChansExist                                = $29E8; // Indicates if the device(s) detected an overcurrent condition for any channel in the task. Reading this property clears the overcurrent status for all channels in the task. You must read this property before you read Overcurrent Channels. Otherwise, you will receive an error.
  DAQmx_Write_OvercurrentChans                                     = $29E9; // Indicates the names of any virtual channels in the task for which an overcurrent condition has been detected. You must read Overcurrent Channels Exist before you read this property. Otherwise, you will receive an error.
  DAQmx_Write_OpenCurrentLoopChansExist                            = $29EA; // Indicates if the device(s) detected an open current loop for any channel in the task. Reading this property clears the open current loop status for all channels in the task. You must read this property before you read Open Current Loop Channels. Otherwise, you will receive an error.
  DAQmx_Write_OpenCurrentLoopChans                                 = $29EB; // Indicates the names of any virtual channels in the task for which the device(s) detected an open current loop. You must read Open Current Loop Channels Exist before you read this property. Otherwise, you will receive an error.
  DAQmx_Write_PowerSupplyFaultChansExist                           = $29EC; // Indicates if the device(s) detected a power supply fault for any channel in the task. Reading this property clears the power supply fault status for all channels in the task. You must read this property before you read Power Supply Fault Channels. Otherwise, you will receive an error.
  DAQmx_Write_PowerSupplyFaultChans                                = $29ED; // Indicates the names of any virtual channels in the task that have a power supply fault. You must read Power Supply Fault Channels Exist before you read this property. Otherwise, you will receive an error.
  DAQmx_Write_SpaceAvail                                           = $1460; // Indicates in samples per channel the amount of available space in the buffer.
  DAQmx_Write_TotalSampPerChanGenerated                            = $192B; // Indicates the total number of samples generated by each channel in the task. This value is identical for all channels in the task.
  DAQmx_Write_RawDataWidth                                         = $217D; // Indicates in bytes the required size of a raw sample to write to the task.
  DAQmx_Write_NumChans                                             = $217E; // Indicates the number of channels that an NI-DAQmx Write function writes to the task. This value is the number of channels in the task.
  DAQmx_Write_WaitMode                                             = $22B1; // Specifies how an NI-DAQmx Write function waits for space to become available in the buffer.
  DAQmx_Write_SleepTime                                            = $22B2; // Specifies in seconds the amount of time to sleep after checking for available buffer space if Wait Mode is DAQmx_Val_Sleep.
  DAQmx_Write_NextWriteIsLast                                      = $296C; // Specifies that the next samples written are the last samples you want to generate. Use this property when performing continuous generation to prevent underflow errors after writing the last sample. Regeneration Mode must be DAQmx_Val_DoNotAllowRegen to use this property.
  DAQmx_Write_DigitalLines_BytesPerChan                            = $217F; // Indicates the number of bytes expected per channel in a sample for line-based writes. If a channel has fewer lines than this number, NI-DAQmx ignores the extra bytes.

// ********* Physical Channel Attributes **********
  DAQmx_PhysicalChan_AI_TermCfgs                                   = $2342; // Indicates the list of terminal configurations supported by the channel.
  DAQmx_PhysicalChan_AO_TermCfgs                                   = $29A3; // Indicates the list of terminal configurations supported by the channel.
  DAQmx_PhysicalChan_AO_ManualControlEnable                        = $2A1E; // Specifies if you can control the physical channel externally via a manual control located on the device. You cannot simultaneously control a channel manually and with NI-DAQmx.
  DAQmx_PhysicalChan_AO_ManualControlAmplitude                     = $2A1F; // Indicates the current value of the front panel amplitude control for the physical channel in volts.
  DAQmx_PhysicalChan_AO_ManualControlFreq                          = $2A20; // Indicates the current value of the front panel frequency control for the physical channel in hertz.
  DAQmx_PhysicalChan_DI_PortWidth                                  = $29A4; // Indicates in bits the width of digital input port.
  DAQmx_PhysicalChan_DI_SampClkSupported                           = $29A5; // Indicates if the sample clock timing type is supported for the digital input physical channel.
  DAQmx_PhysicalChan_DI_ChangeDetectSupported                      = $29A6; // Indicates if the change detection timing type is supported for the digital input physical channel.
  DAQmx_PhysicalChan_DO_PortWidth                                  = $29A7; // Indicates in bits the width of digital output port.
  DAQmx_PhysicalChan_DO_SampClkSupported                           = $29A8; // Indicates if the sample clock timing type is supported for the digital output physical channel.
  DAQmx_PhysicalChan_TEDS_MfgID                                    = $21DA; // Indicates the manufacturer ID of the sensor.
  DAQmx_PhysicalChan_TEDS_ModelNum                                 = $21DB; // Indicates the model number of the sensor.
  DAQmx_PhysicalChan_TEDS_SerialNum                                = $21DC; // Indicates the serial number of the sensor.
  DAQmx_PhysicalChan_TEDS_VersionNum                               = $21DD; // Indicates the version number of the sensor.
  DAQmx_PhysicalChan_TEDS_VersionLetter                            = $21DE; // Indicates the version letter of the sensor.
  DAQmx_PhysicalChan_TEDS_BitStream                                = $21DF; // Indicates the TEDS binary bitstream without checksums.
  DAQmx_PhysicalChan_TEDS_TemplateIDs                              = $228F; // Indicates the IDs of the templates in the bitstream in BitStream.

// ********* Persisted Task Attributes **********
  DAQmx_PersistedTask_Author                                       = $22CC; // Indicates the author of the task.
  DAQmx_PersistedTask_AllowInteractiveEditing                      = $22CD; // Indicates whether the task can be edited in the DAQ Assistant.
  DAQmx_PersistedTask_AllowInteractiveDeletion                     = $22CE; // Indicates whether the task can be deleted through MAX.

// ********* Persisted Channel Attributes **********
  DAQmx_PersistedChan_Author                                       = $22D0; // Indicates the author of the global channel.
  DAQmx_PersistedChan_AllowInteractiveEditing                      = $22D1; // Indicates whether the global channel can be edited in the DAQ Assistant.
  DAQmx_PersistedChan_AllowInteractiveDeletion                     = $22D2; // Indicates whether the global channel can be deleted through MAX.

// ********* Persisted Scale Attributes **********
  DAQmx_PersistedScale_Author                                      = $22D4; // Indicates the author of the custom scale.
  DAQmx_PersistedScale_AllowInteractiveEditing                     = $22D5; // Indicates whether the custom scale can be edited in the DAQ Assistant.
  DAQmx_PersistedScale_AllowInteractiveDeletion                    = $22D6; // Indicates whether the custom scale can be deleted through MAX.


// For backwards compatibility, the DAQmx_ReadWaitMode has to be defined because this was the original spelling
// that has been later on corrected.
  DAQmx_ReadWaitMode	= DAQmx_Read_WaitMode;

(******************************************************************************
 *** NI-DAQmx Values **********************************************************
 ******************************************************************************)

(******************************************************)
(***    Non-Attribute Function Parameter Values     ***)
(******************************************************)

// ** Values for the Mode parameter of DAQmxTaskControl ***
  DAQmx_Val_Task_Start                                              = 0;   // Start
  DAQmx_Val_Task_Stop                                               = 1;   // Stop
  DAQmx_Val_Task_Verify                                             = 2;   // Verify
  DAQmx_Val_Task_Commit                                             = 3;   // Commit
  DAQmx_Val_Task_Reserve                                            = 4;   // Reserve
  DAQmx_Val_Task_Unreserve                                          = 5;   // Unreserve
  DAQmx_Val_Task_Abort                                              = 6;   // Abort

// ** Values for the Options parameter of the event registration functions
  DAQmx_Val_SynchronousEventCallbacks                               = 1;   //      (1<<0)     // Synchronous callbacks

// ** Values for the everyNsamplesEventType parameter of DAQmxRegisterEveryNSamplesEvent ***
  DAQmx_Val_Acquired_Into_Buffer                                    = 1;     // Acquired Into Buffer
  DAQmx_Val_Transferred_From_Buffer                                 = 2;     // Transferred From Buffer


// ** Values for the Action parameter of DAQmxControlWatchdogTask ***
  DAQmx_Val_ResetTimer                                              = 0;   // Reset Timer
  DAQmx_Val_ClearExpiration                                         = 1;   // Clear Expiration

// ** Values for the Line Grouping parameter of DAQmxCreateDIChan and DAQmxCreateDOChan ***
  DAQmx_Val_ChanPerLine                                             = 0;   // One Channel For Each Line
  DAQmx_Val_ChanForAllLines                                         = 1;   // One Channel For All Lines

// ** Values for the Fill Mode parameter of DAQmxReadAnalogF64, DAQmxReadBinaryI16, DAQmxReadBinaryU16, DAQmxReadBinaryI32, DAQmxReadBinaryU32,
//    DAQmxReadDigitalU8, DAQmxReadDigitalU32, DAQmxReadDigitalLines ***
// ** Values for the Data Layout parameter of DAQmxWriteAnalogF64, DAQmxWriteBinaryI16, DAQmxWriteDigitalU8, DAQmxWriteDigitalU32, DAQmxWriteDigitalLines ***
  DAQmx_Val_GroupByChannel                                          = 0;   // Group by Channel
  DAQmx_Val_GroupByScanNumber                                       = 1;   // Group by Scan Number

// ** Values for the Signal Modifiers parameter of DAQmxConnectTerms ***)
  DAQmx_Val_DoNotInvertPolarity                                     = 0;   // Do not invert polarity
  DAQmx_Val_InvertPolarity                                          = 1;   // Invert polarity

// ** Values for the Action paramter of DAQmxCloseExtCal ***
  DAQmx_Val_Action_Commit                                           = 0;   // Commit
  DAQmx_Val_Action_Cancel                                           = 1;   // Cancel

// ** Values for the Trigger ID parameter of DAQmxSendSoftwareTrigger ***
  DAQmx_Val_AdvanceTrigger                                          = 12488; // Advance Trigger

// ** Value set for the ActiveEdge parameter of DAQmxCfgSampClkTiming and DAQmxCfgPipelinedSampClkTiming ***
  DAQmx_Val_Rising                                                  = 10280; // Rising
  DAQmx_Val_Falling                                                 = 10171; // Falling

// ** Value set SwitchPathType ***
// ** Value set for the output Path Status parameter of DAQmxSwitchFindPath ***
  DAQmx_Val_PathStatus_Available                                    = 10431; // Path Available
  DAQmx_Val_PathStatus_AlreadyExists                                = 10432; // Path Already Exists
  DAQmx_Val_PathStatus_Unsupported                                  = 10433; // Path Unsupported
  DAQmx_Val_PathStatus_ChannelInUse                                 = 10434; // Channel In Use
  DAQmx_Val_PathStatus_SourceChannelConflict                        = 10435; // Channel Source Conflict
  DAQmx_Val_PathStatus_ChannelReservedForRouting                    = 10436; // Channel Reserved for Routing

// ** Value set for the Units parameter of DAQmxCreateAIThrmcplChan, DAQmxCreateAIRTDChan, DAQmxCreateAIThrmstrChanIex, DAQmxCreateAIThrmstrChanVex and DAQmxCreateAITempBuiltInSensorChan ***
  DAQmx_Val_DegC                                                    = 10143; // Deg C
  DAQmx_Val_DegF                                                    = 10144; // Deg F
  DAQmx_Val_Kelvins                                                 = 10325; // Kelvins
  DAQmx_Val_DegR                                                    = 10145; // Deg R

// ** Value set for the state parameter of DAQmxSetDigitalPowerUpStates ***
  DAQmx_Val_High                                                    = 10192; // High
  DAQmx_Val_Low                                                     = 10214; // Low
  DAQmx_Val_Tristate                                                = 10310; // Tristate

// ** Value set for the channelType parameter of DAQmxSetAnalogPowerUpStates ***
  DAQmx_Val_ChannelVoltage                                          = 0;     // Voltage Channel
  DAQmx_Val_ChannelCurrent                                          = 1;     // Current Channel

// ** Value set RelayPos ***
// ** Value set for the state parameter of DAQmxSwitchGetSingleRelayPos and DAQmxSwitchGetMultiRelayPos ***
  DAQmx_Val_Open                                                    = 10437; // Open
  DAQmx_Val_Closed                                                  = 10438; // Closed


// ** Value set for the inputCalSource parameter of DAQmxAdjust1540Cal ***
  DAQmx_Val_Loopback0                                               = 0;     // Loopback 0 degree shift
  DAQmx_Val_Loopback180                                             = 1;     // Loopback 180 degree shift
  DAQmx_Val_Ground                                                  = 2;     // Ground


// ** Value for the Terminal Config parameter of DAQmxCreateAIVoltageChan, DAQmxCreateAICurrentChan and DAQmxCreateAIVoltageChanWithExcit ***
  DAQmx_Val_Cfg_Default                                             = -1; // Default
// ** Value for the Shunt Resistor Location parameter of DAQmxCreateAICurrentChan ***
  DAQmx_Val_Default                                                 = -1; // Default

// ** Value for the Timeout parameter of DAQmxWaitUntilTaskDone
  DAQmx_Val_WaitInfinitely                                          = -1.0;

// ** Value for the Number of Samples per Channel parameter of DAQmxReadAnalogF64, DAQmxReadBinaryI16, DAQmxReadBinaryU16,
//    DAQmxReadBinaryI32, DAQmxReadBinaryU32, DAQmxReadDigitalU8, DAQmxReadDigitalU32,
//    DAQmxReadDigitalLines, DAQmxReadCounterF64, DAQmxReadCounterU32 and DAQmxReadRaw ***
  DAQmx_Val_Auto                                                    = -1;

// Value set for the Options parameter of DAQmxSaveTask, DAQmxSaveGlobalChan and DAQmxSaveScale
  DAQmx_Val_Save_Overwrite                                          = 1;
  DAQmx_Val_Save_AllowInteractiveEditing                            = 2;
  DAQmx_Val_Save_AllowInteractiveDeletion                           = 4;

// ** Values for the Trigger Usage parameter - set of trigger types a device may support
// ** Values for TriggerUsageTypeBits
  DAQmx_Val_Bit_TriggerUsageTypes_Advance                           = 1;  // Device supports advance triggers
  DAQmx_Val_Bit_TriggerUsageTypes_Pause                             = 2;  // Device supports pause triggers
  DAQmx_Val_Bit_TriggerUsageTypes_Reference                         = 4;  // Device supports reference triggers
  DAQmx_Val_Bit_TriggerUsageTypes_Start                             = 8;  // Device supports start triggers
  DAQmx_Val_Bit_TriggerUsageTypes_Handshake                         = 16; // Device supports handshake triggers
  DAQmx_Val_Bit_TriggerUsageTypes_ArmStart                          = 32; // Device supports arm start triggers

// ** Values for the Coupling Types parameter - set of coupling types a device may support
// ** Values for CouplingTypeBits
  DAQmx_Val_Bit_CouplingTypes_AC                                    = 1; // Device supports AC coupling
  DAQmx_Val_Bit_CouplingTypes_DC                                    = 2; // Device supports DC coupling
  DAQmx_Val_Bit_CouplingTypes_Ground                                = 4; // Device supports ground coupling
  DAQmx_Val_Bit_CouplingTypes_HFReject                              = 8; // Device supports High Frequency Reject coupling
  DAQmx_Val_Bit_CouplingTypes_LFReject                              = 16; // Device supports Low Frequency Reject coupling
  DAQmx_Val_Bit_CouplingTypes_NoiseReject                           = 32; // Device supports Noise Reject coupling

// ** Values for DAQmx_PhysicalChan_AI_TermCfgs and DAQmx_PhysicalChan_AO_TermCfgs
// ** Value set TerminalConfigurationBits ***
  DAQmx_Val_Bit_TermCfg_RSE                                         = 1; // RSE terminal configuration
  DAQmx_Val_Bit_TermCfg_NRSE                                        = 2; // NRSE terminal configuration
  DAQmx_Val_Bit_TermCfg_Diff                                        = 4; // Differential terminal configuration
  DAQmx_Val_Bit_TermCfg_PseudoDIFF                                  = 8; // Pseudodifferential terminal configuration


(******************************************************)
(***              Attribute Values                  ***)
(******************************************************)

// ** Values for DAQmx_AI_ACExcit_WireMode ***
// ** Value set ACExcitWireMode ***
  DAQmx_Val_4Wire                                                       = 4; // 4-Wire
  DAQmx_Val_5Wire                                                       = 5; // 5-Wire

// ** Values for DAQmx_AI_ADCTimingMode ***
// ** Value set ADCTimingMode ***
  DAQmx_Val_HighResolution                                          = 10195; // High Resolution
  DAQmx_Val_HighSpeed                                               = 14712; // High Speed
  DAQmx_Val_Best50HzRejection                                       = 14713; // Best 50 Hz Rejection
  DAQmx_Val_Best60HzRejection                                       = 14714; // Best 60 Hz Rejection

// ** Values for DAQmx_AI_MeasType ***
// ** Value set AIMeasurementType ***
  DAQmx_Val_Voltage                                                 = 10322; // Voltage
  DAQmx_Val_VoltageRMS                                              = 10350; // Voltage RMS
  DAQmx_Val_Current                                                 = 10134; // Current
  DAQmx_Val_CurrentRMS                                              = 10351; // Current RMS
  DAQmx_Val_Voltage_CustomWithExcitation                            = 10323; // More:Voltage:Custom with Excitation
  DAQmx_Val_Freq_Voltage                                            = 10181; // Frequency
  DAQmx_Val_Resistance                                              = 10278; // Resistance
  DAQmx_Val_Temp_TC                                                 = 10303; // Temperature:Thermocouple
  DAQmx_Val_Temp_Thrmstr                                            = 10302; // Temperature:Thermistor
  DAQmx_Val_Temp_RTD                                                = 10301; // Temperature:RTD
  DAQmx_Val_Temp_BuiltInSensor                                      = 10311; // Temperature:Built-in Sensor
  DAQmx_Val_Strain_Gage                                             = 10300; // Strain Gage
  DAQmx_Val_Position_LVDT                                           = 10352; // Position:LVDT
  DAQmx_Val_Position_RVDT                                           = 10353; // Position:RVDT
  DAQmx_Val_Accelerometer                                           = 10356; // Accelerometer
  DAQmx_Val_SoundPressure_Microphone                                = 10354; // Sound Pressure:Microphone
  DAQmx_Val_TEDS_Sensor                                             = 12531; // TEDS Sensor

// ** Values for DAQmx_AO_IdleOutputBehavior ***
// ** Value set AOIdleOutputBehavior ***
  DAQmx_Val_ZeroVolts                                               = 12526; // Zero Volts
  DAQmx_Val_HighImpedance                                           = 12527; // High Impedance
  DAQmx_Val_MaintainExistingValue                                   = 12528; // Maintain Existing Value

// ** Values for DAQmx_AO_OutputType ***
// ** Value set AOOutputChannelType ***
//  DAQmx_Val_Voltage                                                 = 10322; // Voltage
//  DAQmx_Val_Current                                                 = 10134; // Current
  DAQmx_Val_FuncGen                                                 = 14750; // Function Generation

// ** Values for DAQmx_AI_Accel_SensitivityUnits ***
// ** Value set AccelSensitivityUnits1 ***
  DAQmx_Val_mVoltsPerG                                              = 12509; // mVolts/g
  DAQmx_Val_VoltsPerG                                               = 12510; // Volts/g

// ** Values for DAQmx_AI_Accel_Units ***
// ** Value set AccelUnits2 ***
  DAQmx_Val_AccelUnit_g                                             = 10186; // g
  DAQmx_Val_MetersPerSecondSquared                                  = 12470; // m/s^2
  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_SampQuant_SampMode ***
// ** Value set AcquisitionType ***
  DAQmx_Val_FiniteSamps                                             = 10178; // Finite Samples
  DAQmx_Val_ContSamps                                               = 10123; // Continuous Samples
  DAQmx_Val_HWTimedSinglePoint                                      = 12522; // Hardware Timed Single Point

// ** Values for DAQmx_AnlgLvl_PauseTrig_When ***
// ** Value set ActiveLevel ***
  DAQmx_Val_AboveLvl                                                = 10093; // Above Level
  DAQmx_Val_BelowLvl                                                = 10107; // Below Level

// ** Values for DAQmx_AI_RVDT_Units ***
// ** Value set AngleUnits1 ***
  DAQmx_Val_Degrees                                                 = 10146; // Degrees
  DAQmx_Val_Radians                                                 = 10273; // Radians
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_CI_AngEncoder_Units ***
// ** Value set AngleUnits2 ***
//  DAQmx_Val_Degrees                                                 = 10146; // Degrees
//  DAQmx_Val_Radians                                                 = 10273; // Radians
  DAQmx_Val_Ticks                                                   = 10304; // Ticks
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_AI_AutoZeroMode ***
// ** Value set AutoZeroType1 ***
  DAQmx_Val_None                                                    = 10230; // None
  DAQmx_Val_Once                                                    = 10244; // Once
  DAQmx_Val_EverySample                                             = 10164; // Every Sample

// ** Values for DAQmx_SwitchScan_BreakMode ***
// ** Value set BreakMode ***
  DAQmx_Val_NoAction                                                = 10227; // No Action
  DAQmx_Val_BreakBeforeMake                                         = 10110; // Break Before Make

// ** Values for DAQmx_AI_Bridge_Cfg ***
// ** Value set BridgeConfiguration1 ***
  DAQmx_Val_FullBridge                                              = 10182; // Full Bridge
  DAQmx_Val_HalfBridge                                              = 10187; // Half Bridge
  DAQmx_Val_QuarterBridge                                           = 10270; // Quarter Bridge
  DAQmx_Val_NoBridge                                                = 10228; // No Bridge

// ** Values for DAQmx_Dev_BusType ***
// ** Value set BusType ***
  DAQmx_Val_PCI                                                     = 12582; // PCI
  DAQmx_Val_PCIe                                                    = 13612; // PCIe
  DAQmx_Val_PXI                                                     = 12583; // PXI
  DAQmx_Val_PXIe                                                    = 14706; // PXIe
  DAQmx_Val_SCXI                                                    = 12584; // SCXI
  DAQmx_Val_SCC                                                     = 14707; // SCC
  DAQmx_Val_PCCard                                                  = 12585; // PCCard
  DAQmx_Val_USB                                                     = 12586; // USB
  DAQmx_Val_CompactDAQ                                              = 14637; // CompactDAQ
  DAQmx_Val_Unknown                                                 = 12588; // Unknown

// ** Values for DAQmx_CI_MeasType ***
// ** Value set CIMeasurementType ***
  DAQmx_Val_CountEdges                                              = 10125; // Count Edges
  DAQmx_Val_Freq                                                    = 10179; // Frequency
  DAQmx_Val_Period                                                  = 10256; // Period
  DAQmx_Val_PulseWidth                                              = 10359; // Pulse Width
  DAQmx_Val_SemiPeriod                                              = 10289; // Semi Period
  DAQmx_Val_Position_AngEncoder                                     = 10360; // Position:Angular Encoder
  DAQmx_Val_Position_LinEncoder                                     = 10361; // Position:Linear Encoder
  DAQmx_Val_TwoEdgeSep                                              = 10267; // Two Edge Separation
  DAQmx_Val_GPS_Timestamp                                           = 10362; // GPS Timestamp

// ** Values for DAQmx_AI_Thrmcpl_CJCSrc ***
// ** Value set CJCSource1 ***
  DAQmx_Val_BuiltIn                                                 = 10200; // Built-In
  DAQmx_Val_ConstVal                                                = 10116; // Constant Value
  DAQmx_Val_Chan                                                    = 10113; // Channel

// ** Values for DAQmx_CO_OutputType ***
// ** Value set COOutputType ***
  DAQmx_Val_Pulse_Time                                              = 10269; // Pulse:Time
  DAQmx_Val_Pulse_Freq                                              = 10119; // Pulse:Frequency
  DAQmx_Val_Pulse_Ticks                                             = 10268; // Pulse:Ticks

// ** Values for DAQmx_ChanType ***
// ** Value set ChannelType ***
  DAQmx_Val_AI                                                      = 10100; // Analog Input
  DAQmx_Val_AO                                                      = 10102; // Analog Output
  DAQmx_Val_DI                                                      = 10151; // Digital Input
  DAQmx_Val_DO                                                      = 10153; // Digital Output
  DAQmx_Val_CI                                                      = 10131; // Counter Input
  DAQmx_Val_CO                                                      = 10132; // Counter Output

// ** Values for DAQmx_CO_ConstrainedGenMode ***
// ** Value set ConstrainedGenMode ***
  DAQmx_Val_Unconstrained                                           = 14708; // Unconstrained
  DAQmx_Val_FixedHighFreq                                           = 14709; // Fixed High Frequency
  DAQmx_Val_FixedLowFreq                                            = 14710; // Fixed Low Frequency
  DAQmx_Val_Fixed50PercentDutyCycle                                 = 14711; // Fixed 50 Percent Duty Cycle

// ** Values for DAQmx_CI_CountEdges_Dir ***
// ** Value set CountDirection1 ***
  DAQmx_Val_CountUp                                                 = 10128; // Count Up
  DAQmx_Val_CountDown                                               = 10124; // Count Down
  DAQmx_Val_ExtControlled                                           = 10326; // Externally Controlled

// ** Values for DAQmx_CI_Freq_MeasMeth ***
// ** Values for DAQmx_CI_Period_MeasMeth ***
// ** Value set CounterFrequencyMethod ***
  DAQmx_Val_LowFreq1Ctr                                             = 10105; // Low Frequency with 1 Counter
  DAQmx_Val_HighFreq2Ctr                                            = 10157; // High Frequency with 2 Counters
  DAQmx_Val_LargeRng2Ctr                                            = 10205; // Large Range with 2 Counters

// ** Values for DAQmx_AI_Coupling ***
// ** Value set Coupling1 ***
  DAQmx_Val_AC                                                      = 10045; // AC
  DAQmx_Val_DC                                                      = 10050; // DC
  DAQmx_Val_GND                                                     = 10066; // GND

// ** Values for DAQmx_AnlgEdge_StartTrig_Coupling ***
// ** Values for DAQmx_AnlgWin_StartTrig_Coupling ***
// ** Values for DAQmx_AnlgEdge_RefTrig_Coupling ***
// ** Values for DAQmx_AnlgWin_RefTrig_Coupling ***
// ** Values for DAQmx_AnlgLvl_PauseTrig_Coupling ***
// ** Values for DAQmx_AnlgWin_PauseTrig_Coupling ***
// ** Value set Coupling2 ***
//  DAQmx_Val_AC                                                      = 10045; // AC
//  DAQmx_Val_DC                                                      = 10050; // DC

// ** Values for DAQmx_AI_CurrentShunt_Loc ***
// ** Value set CurrentShuntResistorLocation1 ***
  DAQmx_Val_Internal                                                = 10200; // Internal
  DAQmx_Val_External                                                = 10167; // External

// ** Values for DAQmx_AI_Current_Units ***
// ** Values for DAQmx_AI_Current_ACRMS_Units ***
// ** Values for DAQmx_AO_Current_Units ***
// ** Value set CurrentUnits1 ***
  DAQmx_Val_Amps                                                    = 10342; // Amps
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale
  DAQmx_Val_FromTEDS                                                = 12516; // From TEDS

// ** Value set CurrentUnits2 ***
//  DAQmx_Val_Amps                                                    = 10342; // Amps
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_AI_RawSampJustification ***
// ** Value set DataJustification1 ***
  DAQmx_Val_RightJustified                                          = 10279; // Right-Justified
  DAQmx_Val_LeftJustified                                           = 10209; // Left-Justified

// ** Values for DAQmx_AI_DataXferMech ***
// ** Values for DAQmx_AO_DataXferMech ***
// ** Values for DAQmx_DI_DataXferMech ***
// ** Values for DAQmx_DO_DataXferMech ***
// ** Values for DAQmx_CI_DataXferMech ***
// ** Value set DataTransferMechanism ***
  DAQmx_Val_DMA                                                     = 10054; // DMA
  DAQmx_Val_Interrupts                                              = 10204; // Interrupts
  DAQmx_Val_ProgrammedIO                                            = 10264; // Programmed I/O
  DAQmx_Val_USBbulk                                                 = 12590; // USB Bulk

// ** Values for DAQmx_Exported_RdyForXferEvent_DeassertCond ***
// ** Value set DeassertCondition ***
  DAQmx_Val_OnbrdMemMoreThanHalfFull                                = 10237; // Onboard Memory More than Half Full
  DAQmx_Val_OnbrdMemFull                                            = 10236; // Onboard Memory Full
  DAQmx_Val_OnbrdMemCustomThreshold                                 = 12577; // Onboard Memory Custom Threshold

// ** Values for DAQmx_DO_OutputDriveType ***
// ** Value set DigitalDriveType ***
  DAQmx_Val_ActiveDrive                                             = 12573; // Active Drive
  DAQmx_Val_OpenCollector                                           = 12574; // Open Collector

// ** Values for DAQmx_DO_LineStates_StartState ***
// ** Values for DAQmx_DO_LineStates_PausedState ***
// ** Values for DAQmx_DO_LineStates_DoneState ***
// ** Values for DAQmx_Watchdog_DO_ExpirState ***
// ** Value set DigitalLineState ***
//  DAQmx_Val_High                                                    = 10192; // High
//  DAQmx_Val_Low                                                     = 10214; // Low
//  DAQmx_Val_Tristate                                                = 10310; // Tristate
  DAQmx_Val_NoChange                                                = 10160; // No Change

// ** Values for DAQmx_DigPattern_StartTrig_When ***
// ** Values for DAQmx_DigPattern_RefTrig_When ***
// ** Values for DAQmx_DigPattern_PauseTrig_When ***
// ** Value set DigitalPatternCondition1 ***
  DAQmx_Val_PatternMatches                                          = 10254; // Pattern Matches
  DAQmx_Val_PatternDoesNotMatch                                     = 10253; // Pattern Does Not Match

// ** Values for DAQmx_StartTrig_DelayUnits ***
// ** Value set DigitalWidthUnits1 ***
  DAQmx_Val_SampClkPeriods                                          = 10286; // Sample Clock Periods
  DAQmx_Val_Seconds                                                 = 10364; // Seconds
//  DAQmx_Val_Ticks                                                   = 10304; // Ticks

// ** Values for DAQmx_DelayFromSampClk_DelayUnits ***
// ** Value set DigitalWidthUnits2 ***
//  DAQmx_Val_Seconds                                                 = 10364; // Seconds
//  DAQmx_Val_Ticks                                                   = 10304; // Ticks

// ** Values for DAQmx_Exported_AdvTrig_Pulse_WidthUnits ***
// ** Value set DigitalWidthUnits3 ***
//  DAQmx_Val_Seconds                                                 = 10364; // Seconds

// ** Values for DAQmx_CI_Freq_StartingEdge ***
// ** Values for DAQmx_CI_Period_StartingEdge ***
// ** Values for DAQmx_CI_CountEdges_ActiveEdge ***
// ** Values for DAQmx_CI_PulseWidth_StartingEdge ***
// ** Values for DAQmx_CI_TwoEdgeSep_FirstEdge ***
// ** Values for DAQmx_CI_TwoEdgeSep_SecondEdge ***
// ** Values for DAQmx_CI_SemiPeriod_StartingEdge ***
// ** Values for DAQmx_CI_CtrTimebaseActiveEdge ***
// ** Values for DAQmx_CO_CtrTimebaseActiveEdge ***
// ** Values for DAQmx_SampClk_ActiveEdge ***
// ** Values for DAQmx_SampClk_Timebase_ActiveEdge ***
// ** Values for DAQmx_AIConv_ActiveEdge ***
// ** Values for DAQmx_DigEdge_StartTrig_Edge ***
// ** Values for DAQmx_DigEdge_RefTrig_Edge ***
// ** Values for DAQmx_DigEdge_AdvTrig_Edge ***
// ** Values for DAQmx_DigEdge_ArmStartTrig_Edge ***
// ** Values for DAQmx_DigEdge_WatchdogExpirTrig_Edge ***
// ** Value set Edge1 ***
//  DAQmx_Val_Rising                                                  = 10280; // Rising
//  DAQmx_Val_Falling                                                 = 10171; // Falling

// ** Values for DAQmx_CI_Encoder_DecodingType ***
// ** Value set EncoderType2 ***
  DAQmx_Val_X1                                                      = 10090; // X1
  DAQmx_Val_X2                                                      = 10091; // X2
  DAQmx_Val_X4                                                      = 10092; // X4
  DAQmx_Val_TwoPulseCounting                                        = 10313; // Two Pulse Counting

// ** Values for DAQmx_CI_Encoder_ZIndexPhase ***
// ** Value set EncoderZIndexPhase1 ***
  DAQmx_Val_AHighBHigh                                              = 10040; // A High B High
  DAQmx_Val_AHighBLow                                               = 10041; // A High B Low
  DAQmx_Val_ALowBHigh                                               = 10042; // A Low B High
  DAQmx_Val_ALowBLow                                                = 10043; // A Low B Low

// ** Values for DAQmx_AI_Excit_DCorAC ***
// ** Value set ExcitationDCorAC ***
//  DAQmx_Val_DC                                                      = 10050; // DC
//  DAQmx_Val_AC                                                      = 10045; // AC

// ** Values for DAQmx_AI_Excit_Src ***
// ** Value set ExcitationSource ***
//  DAQmx_Val_Internal                                                = 10200; // Internal
//  DAQmx_Val_External                                                = 10167; // External
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_AI_Excit_VoltageOrCurrent ***
// ** Value set ExcitationVoltageOrCurrent ***
//  DAQmx_Val_Voltage                                                 = 10322; // Voltage
//  DAQmx_Val_Current                                                 = 10134; // Current

// ** Values for DAQmx_Exported_CtrOutEvent_OutputBehavior ***
// ** Value set ExportActions2 ***
  DAQmx_Val_Pulse                                                   = 10265; // Pulse
  DAQmx_Val_Toggle                                                  = 10307; // Toggle

// ** Values for DAQmx_Exported_SampClk_OutputBehavior ***
// ** Value set ExportActions3 ***
//  DAQmx_Val_Pulse                                                   = 10265; // Pulse
  DAQmx_Val_Lvl                                                     = 10210; // Level

// ** Values for DAQmx_Exported_HshkEvent_OutputBehavior ***
// ** Value set ExportActions5 ***
  DAQmx_Val_Interlocked                                             = 12549; // Interlocked
//  DAQmx_Val_Pulse                                                   = 10265; // Pulse

// ** Values for DAQmx_AI_Freq_Units ***
// ** Value set FrequencyUnits ***
  DAQmx_Val_Hz                                                      = 10373; // Hz
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_CO_Pulse_Freq_Units ***
// ** Value set FrequencyUnits2 ***
//  DAQmx_Val_Hz                                                      = 10373; // Hz

// ** Values for DAQmx_CI_Freq_Units ***
// ** Value set FrequencyUnits3 ***
//  DAQmx_Val_Hz                                                      = 10373; // Hz
//  DAQmx_Val_Ticks                                                   = 10304; // Ticks
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_AO_FuncGen_Type ***
// ** Value set FuncGenType ***
  DAQmx_Val_Sine                                                    = 14751; // Sine
  DAQmx_Val_Triangle                                                = 14752; // Triangle
  DAQmx_Val_Square                                                  = 14753; // Square
  DAQmx_Val_Sawtooth                                                = 14754; // Sawtooth

// ** Values for DAQmx_CI_GPS_SyncMethod ***
// ** Value set GpsSignalType1 ***
  DAQmx_Val_IRIGB                                                   = 10070; // IRIG-B
  DAQmx_Val_PPS                                                     = 10080; // PPS
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_Hshk_StartCond ***
// ** Value set HandshakeStartCondition ***
  DAQmx_Val_Immediate                                               = 10198; // Immediate
  DAQmx_Val_WaitForHandshakeTriggerAssert                           = 12550; // Wait For Handshake Trigger Assert
  DAQmx_Val_WaitForHandshakeTriggerDeassert                         = 12551; // Wait For Handshake Trigger Deassert


// ** Values for DAQmx_AI_DataXferReqCond ***
// ** Values for DAQmx_DI_DataXferReqCond ***
// ** Value set InputDataTransferCondition ***
//  DAQmx_Val_OnBrdMemMoreThanHalfFull                                = 10237; // Onboard Memory More than Half Full
  DAQmx_Val_OnBrdMemNotEmpty                                        = 10241; // Onboard Memory Not Empty
//  DAQmx_Val_OnbrdMemCustomThreshold                                 = 12577; // Onboard Memory Custom Threshold
  DAQmx_Val_WhenAcqComplete                                         = 12546; // When Acquisition Complete

// ** Values for DAQmx_AI_TermCfg ***
// ** Value set InputTermCfg ***
  DAQmx_Val_RSE                                                     = 10083; // RSE
  DAQmx_Val_NRSE                                                    = 10078; // NRSE
  DAQmx_Val_Diff                                                    = 10106; // Differential
  DAQmx_Val_PseudoDiff                                              = 12529; // Pseudodifferential

// ** Values for DAQmx_AI_LVDT_SensitivityUnits ***
// ** Value set LVDTSensitivityUnits1 ***
  DAQmx_Val_mVoltsPerVoltPerMillimeter                              = 12506; // mVolts/Volt/mMeter
  DAQmx_Val_mVoltsPerVoltPerMilliInch                               = 12505; // mVolts/Volt/0.001 Inch

// ** Values for DAQmx_AI_LVDT_Units ***
// ** Value set LengthUnits2 ***
  DAQmx_Val_Meters                                                  = 10219; // Meters
  DAQmx_Val_Inches                                                  = 10379; // Inches
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_CI_LinEncoder_Units ***
// ** Value set LengthUnits3 ***
//  DAQmx_Val_Meters                                                  = 10219; // Meters
//  DAQmx_Val_Inches                                                  = 10379; // Inches
//  DAQmx_Val_Ticks                                                   = 10304; // Ticks
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_CI_OutputState ***
// ** Values for DAQmx_CO_Pulse_IdleState ***
// ** Values for DAQmx_CO_OutputState ***
// ** Values for DAQmx_Exported_CtrOutEvent_Toggle_IdleState ***
// ** Values for DAQmx_Exported_HshkEvent_Interlocked_AssertedLvl ***
// ** Values for DAQmx_Interlocked_HshkTrig_AssertedLvl ***
// ** Values for DAQmx_DigLvl_PauseTrig_When ***
// ** Value set Level1 ***
//  DAQmx_Val_High                                                    = 10192; // High
//  DAQmx_Val_Low                                                     = 10214; // Low

// ** Values for DAQmx_DI_LogicFamily ***
// ** Values for DAQmx_DO_LogicFamily ***
// ** Value set LogicFamily ***
  DAQmx_Val_2point5V                                                = 14620; // 2.5 V
  DAQmx_Val_3point3V                                                = 14621; // 3.3 V
  DAQmx_Val_5V                                                      = 14619; // 5.0 V

// ** Values for DAQmx_AIConv_Timebase_Src ***
// ** Value set MIOAIConvertTbSrc ***
  DAQmx_Val_SameAsSampTimebase                                      = 10284; // Same as Sample Timebase
  DAQmx_Val_SameAsMasterTimebase                                    = 10282; // Same as Master Timebase
  DAQmx_Val_20MHzTimebase                                           = 12537; // 20MHz Timebase
  DAQmx_Val_80MHzTimebase                                           = 14636; // 80MHz Timebase

// ** Values for DAQmx_AO_FuncGen_ModulationType ***
// ** Value set ModulationType ***
  DAQmx_Val_AM                                                      = 14756; // AM
  DAQmx_Val_FM                                                      = 14757; // FM
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_AO_DataXferReqCond ***
// ** Values for DAQmx_DO_DataXferReqCond ***
// ** Value set OutputDataTransferCondition ***
  DAQmx_Val_OnBrdMemEmpty                                           = 10235; // Onboard Memory Empty
  DAQmx_Val_OnBrdMemHalfFullOrLess                                  = 10239; // Onboard Memory Half Full or Less
  DAQmx_Val_OnBrdMemNotFull                                         = 10242; // Onboard Memory Less than Full

// ** Values for DAQmx_AO_TermCfg ***
// ** Value set OutputTermCfg ***
//  DAQmx_Val_RSE                                                     = 10083; // RSE
//  DAQmx_Val_Diff                                                    = 10106; // Differential
//  DAQmx_Val_PseudoDiff                                              = 12529; // Pseudodifferential

// ** Values for DAQmx_Read_OverWrite ***
// ** Value set OverwriteMode1 ***
  DAQmx_Val_OverwriteUnreadSamps                                    = 10252; // Overwrite Unread Samples
  DAQmx_Val_DoNotOverwriteUnreadSamps                               = 10159; // Do Not Overwrite Unread Samples

// ** Values for DAQmx_Exported_AIConvClk_Pulse_Polarity ***
// ** Values for DAQmx_Exported_SampClk_Pulse_Polarity ***
// ** Values for DAQmx_Exported_AdvTrig_Pulse_Polarity ***
// ** Values for DAQmx_Exported_PauseTrig_Lvl_ActiveLvl ***
// ** Values for DAQmx_Exported_RefTrig_Pulse_Polarity ***
// ** Values for DAQmx_Exported_StartTrig_Pulse_Polarity ***
// ** Values for DAQmx_Exported_AdvCmpltEvent_Pulse_Polarity ***
// ** Values for DAQmx_Exported_AIHoldCmpltEvent_PulsePolarity ***
// ** Values for DAQmx_Exported_ChangeDetectEvent_Pulse_Polarity ***
// ** Values for DAQmx_Exported_CtrOutEvent_Pulse_Polarity ***
// ** Values for DAQmx_Exported_HshkEvent_Pulse_Polarity ***
// ** Values for DAQmx_Exported_RdyForXferEvent_Lvl_ActiveLvl ***
// ** Values for DAQmx_Exported_DataActiveEvent_Lvl_ActiveLvl ***
// ** Values for DAQmx_Exported_RdyForStartEvent_Lvl_ActiveLvl ***
// ** Value set Polarity2 ***
  DAQmx_Val_ActiveHigh                                              = 10095; // Active High
  DAQmx_Val_ActiveLow                                               = 10096; // Active Low

// ** Values for DAQmx_Dev_ProductCategory ***
// ** Value set ProductCategory ***
  DAQmx_Val_MSeriesDAQ                                              = 14643; // M Series DAQ
  DAQmx_Val_ESeriesDAQ                                              = 14642; // E Series DAQ
  DAQmx_Val_SSeriesDAQ                                              = 14644; // S Series DAQ
  DAQmx_Val_BSeriesDAQ                                              = 14662; // B Series DAQ
  DAQmx_Val_SCSeriesDAQ                                             = 14645; // SC Series DAQ
  DAQmx_Val_USBDAQ                                                  = 14646; // USB DAQ
  DAQmx_Val_AOSeries                                                = 14647; // AO Series
  DAQmx_Val_DigitalIO                                               = 14648; // Digital I/O
  DAQmx_Val_TIOSeries                                               = 14661; // TIO Series
  DAQmx_Val_DynamicSignalAcquisition                                = 14649; // Dynamic Signal Acquisition
  DAQmx_Val_Switches                                                = 14650; // Switches
  DAQmx_Val_CompactDAQChassis                                       = 14658; // CompactDAQ Chassis
  DAQmx_Val_CSeriesModule                                           = 14659; // C Series Module
  DAQmx_Val_SCXIModule                                              = 14660; // SCXI Module
  DAQmx_Val_SCCConnectorBlock                                       = 14704; // SCC Connector Block
  DAQmx_Val_SCCModule                                               = 14705; // SCC Module
  DAQmx_Val_NIELVIS                                                 = 14755; // NI ELVIS
//  DAQmx_Val_Unknown                                                 = 12588; // Unknown

// ** Values for DAQmx_AI_RTD_Type ***
// ** Value set RTDType1 ***
  DAQmx_Val_Pt3750                                                  = 12481; // Pt3750
  DAQmx_Val_Pt3851                                                  = 10071; // Pt3851
  DAQmx_Val_Pt3911                                                  = 12482; // Pt3911
  DAQmx_Val_Pt3916                                                  = 10069; // Pt3916
  DAQmx_Val_Pt3920                                                  = 10053; // Pt3920
  DAQmx_Val_Pt3928                                                  = 12483; // Pt3928
  DAQmx_Val_Custom                                                  = 10137; // Custom

// ** Values for DAQmx_AI_RVDT_SensitivityUnits ***
// ** Value set RVDTSensitivityUnits1 ***
  DAQmx_Val_mVoltsPerVoltPerDegree                                  = 12507; // mVolts/Volt/Degree
  DAQmx_Val_mVoltsPerVoltPerRadian                                  = 12508; // mVolts/Volt/Radian

// ** Values for DAQmx_AI_RawDataCompressionType ***
// ** Value set RawDataCompressionType ***
//  DAQmx_Val_None                                                    = 10230; // None
  DAQmx_Val_LosslessPacking                                         = 12555; // Lossless Packing
  DAQmx_Val_LossyLSBRemoval                                         = 12556; // Lossy LSB Removal

// ** Values for DAQmx_Read_RelativeTo ***
// ** Value set ReadRelativeTo ***
  DAQmx_Val_FirstSample                                             = 10424; // First Sample
  DAQmx_Val_CurrReadPos                                             = 10425; // Current Read Position
  DAQmx_Val_RefTrig                                                 = 10426; // Reference Trigger
  DAQmx_Val_FirstPretrigSamp                                        = 10427; // First Pretrigger Sample
  DAQmx_Val_MostRecentSamp                                          = 10428; // Most Recent Sample

// ** Values for DAQmx_Write_RegenMode ***
// ** Value set RegenerationMode1 ***
  DAQmx_Val_AllowRegen                                              = 10097; // Allow Regeneration
  DAQmx_Val_DoNotAllowRegen                                         = 10158; // Do Not Allow Regeneration

// ** Values for DAQmx_AI_ResistanceCfg ***
// ** Value set ResistanceConfiguration ***
  DAQmx_Val_2Wire                                                       = 2; // 2-Wire
  DAQmx_Val_3Wire                                                       = 3; // 3-Wire
//  DAQmx_Val_4Wire                                                       = 4; // 4-Wire

// ** Values for DAQmx_AI_Resistance_Units ***
// ** Value set ResistanceUnits1 ***
  DAQmx_Val_Ohms                                                    = 10384; // Ohms
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale
//  DAQmx_Val_FromTEDS                                                = 12516; // From TEDS

// ** Value set ResistanceUnits2 ***
//  DAQmx_Val_Ohms                                                    = 10384; // Ohms
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_AI_ResolutionUnits ***
// ** Values for DAQmx_AO_ResolutionUnits ***
// ** Value set ResolutionType1 ***
  DAQmx_Val_Bits                                                    = 10109; // Bits

// ** Value set SCXI1124Range ***
  DAQmx_Val_SCXI1124Range0to1V                                      = 14629; // 0V to 1V
  DAQmx_Val_SCXI1124Range0to5V                                      = 14630; // 0V to 5V
  DAQmx_Val_SCXI1124Range0to10V                                     = 14631; // 0V to 10V
  DAQmx_Val_SCXI1124RangeNeg1to1V                                   = 14632; // -1V to 1V
  DAQmx_Val_SCXI1124RangeNeg5to5V                                   = 14633; // -5V to 5V
  DAQmx_Val_SCXI1124RangeNeg10to10V                                 = 14634; // -10V to 10V
  DAQmx_Val_SCXI1124Range0to20mA                                    = 14635; // 0mA to 20mA

// ** Values for DAQmx_DI_AcquireOn ***
// ** Values for DAQmx_DO_GenerateOn ***
// ** Value set SampleClockActiveOrInactiveEdgeSelection ***
  DAQmx_Val_SampClkActiveEdge                                       = 14617; // Sample Clock Active Edge
  DAQmx_Val_SampClkInactiveEdge                                     = 14618; // Sample Clock Inactive Edge

// ** Values for DAQmx_Hshk_SampleInputDataWhen ***
// ** Value set SampleInputDataWhen ***
  DAQmx_Val_HandshakeTriggerAsserts                                 = 12552; // Handshake Trigger Asserts
  DAQmx_Val_HandshakeTriggerDeasserts                               = 12553; // Handshake Trigger Deasserts

// ** Values for DAQmx_SampTimingType ***
// ** Value set SampleTimingType ***
  DAQmx_Val_SampClk                                                 = 10388; // Sample Clock
  DAQmx_Val_BurstHandshake                                          = 12548; // Burst Handshake
  DAQmx_Val_Handshake                                               = 10389; // Handshake
  DAQmx_Val_Implicit                                                = 10451; // Implicit
  DAQmx_Val_OnDemand                                                = 10390; // On Demand
  DAQmx_Val_ChangeDetection                                         = 12504; // Change Detection
  DAQmx_Val_PipelinedSampClk                                        = 14668; // Pipelined Sample Clock

// ** Values for DAQmx_Scale_Type ***
// ** Value set ScaleType ***
  DAQmx_Val_Linear                                                  = 10447; // Linear
  DAQmx_Val_MapRanges                                               = 10448; // Map Ranges
  DAQmx_Val_Polynomial                                              = 10449; // Polynomial
  DAQmx_Val_Table                                                   = 10450; // Table

// ** Values for DAQmx_AI_Thrmcpl_ScaleType ***
// ** Value set ScaleType2 ***
//  DAQmx_Val_Polynomial                                              = 10449; // Polynomial
//  DAQmx_Val_Table                                                   = 10450; // Table

// ** Values for DAQmx_AI_ChanCal_ScaleType ***
// ** Value set ScaleType3 ***
//  DAQmx_Val_Polynomial                                              = 10449; // Polynomial
//  DAQmx_Val_Table                                                   = 10450; // Table
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_AI_Bridge_ShuntCal_Select ***
// ** Value set ShuntCalSelect ***
  DAQmx_Val_A                                                       = 12513; // A
  DAQmx_Val_B                                                       = 12514; // B
  DAQmx_Val_AandB                                                   = 12515; // A and B

// ** Value set ShuntElementLocation ***
  DAQmx_Val_R1                                                      = 12465; // R1
  DAQmx_Val_R2                                                      = 12466; // R2
  DAQmx_Val_R3                                                      = 12467; // R3
  DAQmx_Val_R4                                                      = 14813; // R4
//  DAQmx_Val_None                                                    = 10230; // None

// ** Value set Signal ***
  DAQmx_Val_AIConvertClock                                          = 12484; // AI Convert Clock
  DAQmx_Val_10MHzRefClock                                           = 12536; // 10MHz Reference Clock
  DAQmx_Val_20MHzTimebaseClock                                      = 12486; // 20MHz Timebase Clock
  DAQmx_Val_SampleClock                                             = 12487; // Sample Clock
//  DAQmx_Val_AdvanceTrigger                                          = 12488; // Advance Trigger
  DAQmx_Val_ReferenceTrigger                                        = 12490; // Reference Trigger
  DAQmx_Val_StartTrigger                                            = 12491; // Start Trigger
  DAQmx_Val_AdvCmpltEvent                                           = 12492; // Advance Complete Event
  DAQmx_Val_AIHoldCmpltEvent                                        = 12493; // AI Hold Complete Event
  DAQmx_Val_CounterOutputEvent                                      = 12494; // Counter Output Event
  DAQmx_Val_ChangeDetectionEvent                                    = 12511; // Change Detection Event
  DAQmx_Val_WDTExpiredEvent                                         = 12512; // Watchdog Timer Expired Event

// ** Value set Signal2 ***
  DAQmx_Val_SampleCompleteEvent                                     = 12530; // Sample Complete Event
//  DAQmx_Val_CounterOutputEvent                                      = 12494; // Counter Output Event
//  DAQmx_Val_ChangeDetectionEvent                                    = 12511; // Change Detection Event
//  DAQmx_Val_SampleClock                                             = 12487; // Sample Clock

// ** Values for DAQmx_AnlgEdge_StartTrig_Slope ***
// ** Values for DAQmx_AnlgEdge_RefTrig_Slope ***
// ** Value set Slope1 ***
  DAQmx_Val_RisingSlope                                             = 10280; // Rising
  DAQmx_Val_FallingSlope                                            = 10171; // Falling

// ** Values for DAQmx_AI_SoundPressure_Units ***
// ** Value set SoundPressureUnits1 ***
  DAQmx_Val_Pascals                                                 = 10081; // Pascals
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_AI_Lowpass_SwitchCap_ClkSrc ***
// ** Values for DAQmx_AO_DAC_Ref_Src ***
// ** Values for DAQmx_AO_DAC_Offset_Src ***
// ** Value set SourceSelection ***
//  DAQmx_Val_Internal                                                = 10200; // Internal
//  DAQmx_Val_External                                                = 10167; // External

// ** Values for DAQmx_AI_StrainGage_Cfg ***
// ** Value set StrainGageBridgeType1 ***
  DAQmx_Val_FullBridgeI                                             = 10183; // Full Bridge I
  DAQmx_Val_FullBridgeII                                            = 10184; // Full Bridge II
  DAQmx_Val_FullBridgeIII                                           = 10185; // Full Bridge III
  DAQmx_Val_HalfBridgeI                                             = 10188; // Half Bridge I
  DAQmx_Val_HalfBridgeII                                            = 10189; // Half Bridge II
  DAQmx_Val_QuarterBridgeI                                          = 10271; // Quarter Bridge I
  DAQmx_Val_QuarterBridgeII                                         = 10272; // Quarter Bridge II

// ** Values for DAQmx_AI_Strain_Units ***
// ** Value set StrainUnits1 ***
  DAQmx_Val_Strain                                                  = 10299; // Strain
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_SwitchScan_RepeatMode ***
// ** Value set SwitchScanRepeatMode ***
  DAQmx_Val_Finite                                                  = 10172; // Finite
  DAQmx_Val_Cont                                                    = 10117; // Continuous

// ** Values for DAQmx_SwitchChan_Usage ***
// ** Value set SwitchUsageTypes ***
  DAQmx_Val_Source                                                  = 10439; // Source
  DAQmx_Val_Load                                                    = 10440; // Load
  DAQmx_Val_ReservedForRouting                                      = 10441; // Reserved for Routing

// ** Value set TEDSUnits ***
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale
//  DAQmx_Val_FromTEDS                                                = 12516; // From TEDS

// ** Values for DAQmx_AI_Temp_Units ***
// ** Value set TemperatureUnits1 ***
//  DAQmx_Val_DegC                                                    = 10143; // Deg C
//  DAQmx_Val_DegF                                                    = 10144; // Deg F
//  DAQmx_Val_Kelvins                                                 = 10325; // Kelvins
//  DAQmx_Val_DegR                                                    = 10145; // Deg R
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_AI_Thrmcpl_Type ***
// ** Value set ThermocoupleType1 ***
  DAQmx_Val_J_Type_TC                                               = 10072; // J
  DAQmx_Val_K_Type_TC                                               = 10073; // K
  DAQmx_Val_N_Type_TC                                               = 10077; // N
  DAQmx_Val_R_Type_TC                                               = 10082; // R
  DAQmx_Val_S_Type_TC                                               = 10085; // S
  DAQmx_Val_T_Type_TC                                               = 10086; // T
  DAQmx_Val_B_Type_TC                                               = 10047; // B
  DAQmx_Val_E_Type_TC                                               = 10055; // E

// ** Values for DAQmx_CI_Timestamp_Units ***
// ** Value set TimeUnits ***
//  DAQmx_Val_Seconds                                                 = 10364; // Seconds
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_CO_Pulse_Time_Units ***
// ** Value set TimeUnits2 ***
//  DAQmx_Val_Seconds                                                 = 10364; // Seconds

// ** Values for DAQmx_CI_Period_Units ***
// ** Values for DAQmx_CI_PulseWidth_Units ***
// ** Values for DAQmx_CI_TwoEdgeSep_Units ***
// ** Values for DAQmx_CI_SemiPeriod_Units ***
// ** Value set TimeUnits3 ***
//  DAQmx_Val_Seconds                                                 = 10364; // Seconds
//  DAQmx_Val_Ticks                                                   = 10304; // Ticks
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Value set TimingResponseMode ***
  DAQmx_Val_SingleCycle                                             = 14613; // Single-cycle
  DAQmx_Val_Multicycle                                              = 14614; // Multicycle

// ** Values for DAQmx_ArmStartTrig_Type ***
// ** Values for DAQmx_WatchdogExpirTrig_Type ***
// ** Value set TriggerType4 ***
  DAQmx_Val_DigEdge                                                 = 10150; // Digital Edge
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_AdvTrig_Type ***
// ** Value set TriggerType5 ***
//  DAQmx_Val_DigEdge                                                 = 10150; // Digital Edge
  DAQmx_Val_Software                                                = 10292; // Software
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_PauseTrig_Type ***
// ** Value set TriggerType6 ***
  DAQmx_Val_AnlgLvl                                                 = 10101; // Analog Level
  DAQmx_Val_AnlgWin                                                 = 10103; // Analog Window
  DAQmx_Val_DigLvl                                                  = 10152; // Digital Level
  DAQmx_Val_DigPattern                                              = 10398; // Digital Pattern
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_StartTrig_Type ***
// ** Values for DAQmx_RefTrig_Type ***
// ** Value set TriggerType8 ***
  DAQmx_Val_AnlgEdge                                                = 10099; // Analog Edge
//  DAQmx_Val_DigEdge                                                 = 10150; // Digital Edge
//  DAQmx_Val_DigPattern                                              = 10398; // Digital Pattern
//  DAQmx_Val_AnlgWin                                                 = 10103; // Analog Window
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_HshkTrig_Type ***
// ** Value set TriggerType9 ***
//  DAQmx_Val_Interlocked                                             = 12549; // Interlocked
//  DAQmx_Val_None                                                    = 10230; // None

// ** Values for DAQmx_SampClk_UnderflowBehavior ***
// ** Value set UnderflowBehavior ***
  DAQmx_Val_HaltOutputAndError                                      = 14615; // Halt Output and Error
  DAQmx_Val_PauseUntilDataAvailable                                 = 14616; // Pause until Data Available

// ** Values for DAQmx_Scale_PreScaledUnits ***
// ** Value set UnitsPreScaled ***
  DAQmx_Val_Volts                                                   = 10348; // Volts
//  DAQmx_Val_Amps                                                    = 10342; // Amps
//  DAQmx_Val_DegF                                                    = 10144; // Deg F
//  DAQmx_Val_DegC                                                    = 10143; // Deg C
//  DAQmx_Val_DegR                                                    = 10145; // Deg R
//  DAQmx_Val_Kelvins                                                 = 10325; // Kelvins
//  DAQmx_Val_Strain                                                  = 10299; // Strain
//  DAQmx_Val_Ohms                                                    = 10384; // Ohms
//  DAQmx_Val_Hz                                                      = 10373; // Hz
//  DAQmx_Val_Seconds                                                 = 10364; // Seconds
//  DAQmx_Val_Meters                                                  = 10219; // Meters
//  DAQmx_Val_Inches                                                  = 10379; // Inches
//  DAQmx_Val_Degrees                                                 = 10146; // Degrees
//  DAQmx_Val_Radians                                                 = 10273; // Radians
  DAQmx_Val_g                                                       = 10186; // g
//  DAQmx_Val_MetersPerSecondSquared                                  = 12470; // m/s^2
//  DAQmx_Val_Pascals                                                 = 10081; // Pascals
//  DAQmx_Val_FromTEDS                                                = 12516; // From TEDS

// ** Values for DAQmx_AI_Voltage_Units ***
// ** Values for DAQmx_AI_Voltage_ACRMS_Units ***
// ** Value set VoltageUnits1 ***
//  DAQmx_Val_Volts                                                   = 10348; // Volts
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale
//  DAQmx_Val_FromTEDS                                                = 12516; // From TEDS

// ** Values for DAQmx_AO_Voltage_Units ***
// ** Value set VoltageUnits2 ***
//  DAQmx_Val_Volts                                                   = 10348; // Volts
//  DAQmx_Val_FromCustomScale                                         = 10065; // From Custom Scale

// ** Values for DAQmx_Read_WaitMode ***
// ** Value set WaitMode ***
  DAQmx_Val_WaitForInterrupt                                        = 12523; // Wait For Interrupt
  DAQmx_Val_Poll                                                    = 12524; // Poll
  DAQmx_Val_Yield                                                   = 12525; // Yield
  DAQmx_Val_Sleep                                                   = 12547; // Sleep

// ** Values for DAQmx_Write_WaitMode ***
// ** Value set WaitMode2 ***
//  DAQmx_Val_Poll                                                    = 12524; // Poll
//  DAQmx_Val_Yield                                                   = 12525; // Yield
//  DAQmx_Val_Sleep                                                   = 12547; // Sleep

// ** Values for DAQmx_RealTime_WaitForNextSampClkWaitMode ***
// ** Value set WaitMode3 ***
//  DAQmx_Val_WaitForInterrupt                                        = 12523; // Wait For Interrupt
//  DAQmx_Val_Poll                                                    = 12524; // Poll

// ** Values for DAQmx_RealTime_WriteRecoveryMode ***
// ** Value set WaitMode4 ***
//  DAQmx_Val_WaitForInterrupt                                        = 12523; // Wait For Interrupt
//  DAQmx_Val_Poll                                                    = 12524; // Poll

// ** Values for DAQmx_AnlgWin_StartTrig_When ***
// ** Values for DAQmx_AnlgWin_RefTrig_When ***
// ** Value set WindowTriggerCondition1 ***
  DAQmx_Val_EnteringWin                                             = 10163; // Entering Window
  DAQmx_Val_LeavingWin                                              = 10208; // Leaving Window

// ** Values for DAQmx_AnlgWin_PauseTrig_When ***
// ** Value set WindowTriggerCondition2 ***
  DAQmx_Val_InsideWin                                               = 10199; // Inside Window
  DAQmx_Val_OutsideWin                                              = 10251; // Outside Window

// ** Value set WriteBasicTEDSOptions ***
  DAQmx_Val_WriteToEEPROM                                           = 12538; // Write To EEPROM
  DAQmx_Val_WriteToPROM                                             = 12539; // Write To PROM Once
  DAQmx_Val_DoNotWrite                                              = 12540; // Do Not Write

// ** Values for DAQmx_Write_RelativeTo ***
// ** Value set WriteRelativeTo ***
//  DAQmx_Val_FirstSample                                             = 10424; // First Sample
  DAQmx_Val_CurrWritePos                                            = 10430; // Current Write Position


(******************************************************************************
 *** NI-DAQmx Function Declarations *******************************************
 ******************************************************************************)


// Switch Topologies
Const
  DAQmx_Val_Switch_Topology_1127_1_Wire_64x1_Mux            = '1127/1-Wire 64x1 Mux' ;             // 1127/1-Wire 64x1 Mux
  DAQmx_Val_Switch_Topology_1127_2_Wire_32x1_Mux            = '1127/2-Wire 32x1 Mux' ;             // 1127/2-Wire 32x1 Mux
  DAQmx_Val_Switch_Topology_1127_2_Wire_4x8_Matrix          = '1127/2-Wire 4x8 Matrix' ;           // 1127/2-Wire 4x8 Matrix
  DAQmx_Val_Switch_Topology_1127_4_Wire_16x1_Mux            = '1127/4-Wire 16x1 Mux' ;             // 1127/4-Wire 16x1 Mux
  DAQmx_Val_Switch_Topology_1127_Independent                = '1127/Independent' ;                 // 1127/Independent
  DAQmx_Val_Switch_Topology_1128_1_Wire_64x1_Mux            = '1128/1-Wire 64x1 Mux' ;             // 1128/1-Wire 64x1 Mux
  DAQmx_Val_Switch_Topology_1128_2_Wire_32x1_Mux            = '1128/2-Wire 32x1 Mux' ;             // 1128/2-Wire 32x1 Mux
  DAQmx_Val_Switch_Topology_1128_2_Wire_4x8_Matrix          = '1128/2-Wire 4x8 Matrix' ;           // 1128/2-Wire 4x8 Matrix
  DAQmx_Val_Switch_Topology_1128_4_Wire_16x1_Mux            = '1128/4-Wire 16x1 Mux' ;             // 1128/4-Wire 16x1 Mux
  DAQmx_Val_Switch_Topology_1128_Independent                = '1128/Independent' ;                 // 1128/Independent
  DAQmx_Val_Switch_Topology_1129_2_Wire_16x16_Matrix        = '1129/2-Wire 16x16 Matrix' ;         // 1129/2-Wire 16x16 Matrix
  DAQmx_Val_Switch_Topology_1129_2_Wire_8x32_Matrix         = '1129/2-Wire 8x32 Matrix' ;          // 1129/2-Wire 8x32 Matrix
  DAQmx_Val_Switch_Topology_1129_2_Wire_4x64_Matrix         = '1129/2-Wire 4x64 Matrix' ;          // 1129/2-Wire 4x64 Matrix
  DAQmx_Val_Switch_Topology_1129_2_Wire_Dual_8x16_Matrix    = '1129/2-Wire Dual 8x16 Matrix' ;     // 1129/2-Wire Dual 8x16 Matrix
  DAQmx_Val_Switch_Topology_1129_2_Wire_Dual_4x32_Matrix    = '1129/2-Wire Dual 4x32 Matrix' ;     // 1129/2-Wire Dual 4x32 Matrix
  DAQmx_Val_Switch_Topology_1129_2_Wire_Quad_4x16_Matrix    = '1129/2-Wire Quad 4x16 Matrix'  ;    // 1129/2-Wire Quad 4x16 Matrix
  DAQmx_Val_Switch_Topology_1130_1_Wire_256x1_Mux           = '1130/1-Wire 256x1 Mux'         ;    // 1130/1-Wire 256x1 Mux
  DAQmx_Val_Switch_Topology_1130_1_Wire_Dual_128x1_Mux      = '1130/1-Wire Dual 128x1 Mux'    ;    // 1130/1-Wire Dual 128x1 Mux
  DAQmx_Val_Switch_Topology_1130_2_Wire_128x1_Mux           = '1130/2-Wire 128x1 Mux'         ;    // 1130/2-Wire 128x1 Mux
  DAQmx_Val_Switch_Topology_1130_4_Wire_64x1_Mux            = '1130/4-Wire 64x1 Mux'          ;    // 1130/4-Wire 64x1 Mux
  DAQmx_Val_Switch_Topology_1130_1_Wire_4x64_Matrix         = '1130/1-Wire 4x64 Matrix'       ;    // 1130/1-Wire 4x64 Matrix
  DAQmx_Val_Switch_Topology_1130_1_Wire_8x32_Matrix         = '1130/1-Wire 8x32 Matrix'       ;    // 1130/1-Wire 8x32 Matrix
  DAQmx_Val_Switch_Topology_1130_1_Wire_Octal_32x1_Mux      = '1130/1-Wire Octal 32x1 Mux'    ;    // 1130/1-Wire Octal 32x1 Mux
  DAQmx_Val_Switch_Topology_1130_1_Wire_Quad_64x1_Mux       = '1130/1-Wire Quad 64x1 Mux'     ;    // 1130/1-Wire Quad 64x1 Mux
  DAQmx_Val_Switch_Topology_1130_1_Wire_Sixteen_16x1_Mux    = '1130/1-Wire Sixteen 16x1 Mux'  ;    // 1130/1-Wire Sixteen 16x1 Mux
  DAQmx_Val_Switch_Topology_1130_2_Wire_4x32_Matrix         = '1130/2-Wire 4x32 Matrix'       ;    // 1130/2-Wire 4x32 Matrix
  DAQmx_Val_Switch_Topology_1130_2_Wire_Octal_16x1_Mux      = '1130/2-Wire Octal 16x1 Mux'    ;    // 1130/2-Wire Octal 16x1 Mux
  DAQmx_Val_Switch_Topology_1130_2_Wire_Quad_32x1_Mux       = '1130/2-Wire Quad 32x1 Mux'     ;    // 1130/2-Wire Quad 32x1 Mux
  DAQmx_Val_Switch_Topology_1130_4_Wire_Quad_16x1_Mux       = '1130/4-Wire Quad 16x1 Mux'     ;    // 1130/4-Wire Quad 16x1 Mux
  DAQmx_Val_Switch_Topology_1130_Independent                = '1130/Independent'              ;    // 1130/Independent
  DAQmx_Val_Switch_Topology_1160_16_SPDT                    = '1160/16-SPDT'                  ;    // 1160/16-SPDT
  DAQmx_Val_Switch_Topology_1161_8_SPDT                     = '1161/8-SPDT'                   ;    // 1161/8-SPDT
  DAQmx_Val_Switch_Topology_1163R_Octal_4x1_Mux             = '1163R/Octal 4x1 Mux'           ;    // 1163R/Octal 4x1 Mux
  DAQmx_Val_Switch_Topology_1166_32_SPDT                    = '1166/32-SPDT'                  ;    // 1166/32-SPDT
  DAQmx_Val_Switch_Topology_1166_16_DPDT                    = '1166/16-DPDT'                  ;    // 1166/16-DPDT
  DAQmx_Val_Switch_Topology_1167_Independent                = '1167/Independent'              ;    // 1167/Independent
  DAQmx_Val_Switch_Topology_1169_100_SPST                   = '1169/100-SPST'                 ;    // 1169/100-SPST
  DAQmx_Val_Switch_Topology_1169_50_DPST                    = '1169/50-DPST'                  ;    // 1169/50-DPST
  DAQmx_Val_Switch_Topology_1175_1_Wire_196x1_Mux           = '1175/1-Wire 196x1 Mux'         ;    // 1175/1-Wire 196x1 Mux
  DAQmx_Val_Switch_Topology_1175_2_Wire_98x1_Mux            = '1175/2-Wire 98x1 Mux'          ;    // 1175/2-Wire 98x1 Mux
  DAQmx_Val_Switch_Topology_1175_2_Wire_95x1_Mux            = '1175/2-Wire 95x1 Mux'          ;    // 1175/2-Wire 95x1 Mux
  DAQmx_Val_Switch_Topology_1190_Quad_4x1_Mux               = '1190/Quad 4x1 Mux'             ;    // 1190/Quad 4x1 Mux
  DAQmx_Val_Switch_Topology_1191_Quad_4x1_Mux               = '1191/Quad 4x1 Mux'             ;    // 1191/Quad 4x1 Mux
  DAQmx_Val_Switch_Topology_1192_8_SPDT                     = '1192/8-SPDT'                   ;    // 1192/8-SPDT
  DAQmx_Val_Switch_Topology_1193_32x1_Mux                   = '1193/32x1 Mux'                 ;    // 1193/32x1 Mux
  DAQmx_Val_Switch_Topology_1193_Dual_16x1_Mux              = '1193/Dual 16x1 Mux'            ;    // 1193/Dual 16x1 Mux
  DAQmx_Val_Switch_Topology_1193_Quad_8x1_Mux               = '1193/Quad 8x1 Mux'             ;    // 1193/Quad 8x1 Mux
  DAQmx_Val_Switch_Topology_1193_16x1_Terminated_Mux        = '1193/16x1 Terminated Mux'      ;    // 1193/16x1 Terminated Mux
  DAQmx_Val_Switch_Topology_1193_Dual_8x1_Terminated_Mux    = '1193/Dual 8x1 Terminated Mux'  ;    // 1193/Dual 8x1 Terminated Mux
  DAQmx_Val_Switch_Topology_1193_Quad_4x1_Terminated_Mux    = '1193/Quad 4x1 Terminated Mux'  ;    // 1193/Quad 4x1 Terminated Mux
  DAQmx_Val_Switch_Topology_1193_Independent                = '1193/Independent'              ;    // 1193/Independent
  DAQmx_Val_Switch_Topology_1194_Quad_4x1_Mux               = '1194/Quad 4x1 Mux'             ;    // 1194/Quad 4x1 Mux
  DAQmx_Val_Switch_Topology_1195_Quad_4x1_Mux               = '1195/Quad 4x1 Mux'             ;    // 1195/Quad 4x1 Mux
  DAQmx_Val_Switch_Topology_2501_1_Wire_48x1_Mux            = '2501/1-Wire 48x1 Mux'          ;    // 2501/1-Wire 48x1 Mux
  DAQmx_Val_Switch_Topology_2501_1_Wire_48x1_Amplified_Mux  = '2501/1-Wire 48x1 Amplified Mux';    // 2501/1-Wire 48x1 Amplified Mux
  DAQmx_Val_Switch_Topology_2501_2_Wire_24x1_Mux            = '2501/2-Wire 24x1 Mux'          ;    // 2501/2-Wire 24x1 Mux
  DAQmx_Val_Switch_Topology_2501_2_Wire_24x1_Amplified_Mux  = '2501/2-Wire 24x1 Amplified Mux';    // 2501/2-Wire 24x1 Amplified Mux
  DAQmx_Val_Switch_Topology_2501_2_Wire_Dual_12x1_Mux       = '2501/2-Wire Dual 12x1 Mux'     ;    // 2501/2-Wire Dual 12x1 Mux
  DAQmx_Val_Switch_Topology_2501_2_Wire_Quad_6x1_Mux        = '2501/2-Wire Quad 6x1 Mux'      ;    // 2501/2-Wire Quad 6x1 Mux
  DAQmx_Val_Switch_Topology_2501_2_Wire_4x6_Matrix          = '2501/2-Wire 4x6 Matrix'        ;    // 2501/2-Wire 4x6 Matrix
  DAQmx_Val_Switch_Topology_2501_4_Wire_12x1_Mux            = '2501/4-Wire 12x1 Mux'          ;    // 2501/4-Wire 12x1 Mux
  DAQmx_Val_Switch_Topology_2503_1_Wire_48x1_Mux            = '2503/1-Wire 48x1 Mux'          ;    // 2503/1-Wire 48x1 Mux
  DAQmx_Val_Switch_Topology_2503_2_Wire_24x1_Mux            = '2503/2-Wire 24x1 Mux'          ;    // 2503/2-Wire 24x1 Mux
  DAQmx_Val_Switch_Topology_2503_2_Wire_Dual_12x1_Mux       = '2503/2-Wire Dual 12x1 Mux'     ;    // 2503/2-Wire Dual 12x1 Mux
  DAQmx_Val_Switch_Topology_2503_2_Wire_Quad_6x1_Mux        = '2503/2-Wire Quad 6x1 Mux'      ;    // 2503/2-Wire Quad 6x1 Mux
  DAQmx_Val_Switch_Topology_2503_2_Wire_4x6_Matrix          = '2503/2-Wire 4x6 Matrix'        ;    // 2503/2-Wire 4x6 Matrix
  DAQmx_Val_Switch_Topology_2503_4_Wire_12x1_Mux            = '2503/4-Wire 12x1 Mux'          ;    // 2503/4-Wire 12x1 Mux
  DAQmx_Val_Switch_Topology_2527_1_Wire_64x1_Mux            = '2527/1-Wire 64x1 Mux'          ;    // 2527/1-Wire 64x1 Mux
  DAQmx_Val_Switch_Topology_2527_1_Wire_Dual_32x1_Mux       = '2527/1-Wire Dual 32x1 Mux'     ;    // 2527/1-Wire Dual 32x1 Mux
  DAQmx_Val_Switch_Topology_2527_2_Wire_32x1_Mux            = '2527/2-Wire 32x1 Mux'          ;    // 2527/2-Wire 32x1 Mux
  DAQmx_Val_Switch_Topology_2527_2_Wire_Dual_16x1_Mux       = '2527/2-Wire Dual 16x1 Mux'     ;    // 2527/2-Wire Dual 16x1 Mux
  DAQmx_Val_Switch_Topology_2527_4_Wire_16x1_Mux            = '2527/4-Wire 16x1 Mux'          ;    // 2527/4-Wire 16x1 Mux
  DAQmx_Val_Switch_Topology_2527_Independent                = '2527/Independent'              ;    // 2527/Independent
  DAQmx_Val_Switch_Topology_2529_2_Wire_8x16_Matrix         = '2529/2-Wire 8x16 Matrix'       ;    // 2529/2-Wire 8x16 Matrix
  DAQmx_Val_Switch_Topology_2529_2_Wire_4x32_Matrix         = '2529/2-Wire 4x32 Matrix'       ;    // 2529/2-Wire 4x32 Matrix
  DAQmx_Val_Switch_Topology_2529_2_Wire_Dual_4x16_Matrix    = '2529/2-Wire Dual 4x16 Matrix'  ;    // 2529/2-Wire Dual 4x16 Matrix
  DAQmx_Val_Switch_Topology_2530_1_Wire_128x1_Mux           = '2530/1-Wire 128x1 Mux'         ;    // 2530/1-Wire 128x1 Mux
  DAQmx_Val_Switch_Topology_2530_1_Wire_Dual_64x1_Mux       = '2530/1-Wire Dual 64x1 Mux'     ;    // 2530/1-Wire Dual 64x1 Mux
  DAQmx_Val_Switch_Topology_2530_2_Wire_64x1_Mux            = '2530/2-Wire 64x1 Mux'          ;    // 2530/2-Wire 64x1 Mux
  DAQmx_Val_Switch_Topology_2530_4_Wire_32x1_Mux            = '2530/4-Wire 32x1 Mux'          ;    // 2530/4-Wire 32x1 Mux
  DAQmx_Val_Switch_Topology_2530_1_Wire_4x32_Matrix         = '2530/1-Wire 4x32 Matrix'       ;    // 2530/1-Wire 4x32 Matrix
  DAQmx_Val_Switch_Topology_2530_1_Wire_8x16_Matrix         = '2530/1-Wire 8x16 Matrix'       ;    // 2530/1-Wire 8x16 Matrix
  DAQmx_Val_Switch_Topology_2530_1_Wire_Octal_16x1_Mux      = '2530/1-Wire Octal 16x1 Mux'    ;    // 2530/1-Wire Octal 16x1 Mux
  DAQmx_Val_Switch_Topology_2530_1_Wire_Quad_32x1_Mux       = '2530/1-Wire Quad 32x1 Mux'     ;    // 2530/1-Wire Quad 32x1 Mux
  DAQmx_Val_Switch_Topology_2530_2_Wire_4x16_Matrix         = '2530/2-Wire 4x16 Matrix'       ;    // 2530/2-Wire 4x16 Matrix
  DAQmx_Val_Switch_Topology_2530_2_Wire_Dual_32x1_Mux       = '2530/2-Wire Dual 32x1 Mux'     ;    // 2530/2-Wire Dual 32x1 Mux
  DAQmx_Val_Switch_Topology_2530_2_Wire_Quad_16x1_Mux       = '2530/2-Wire Quad 16x1 Mux'     ;    // 2530/2-Wire Quad 16x1 Mux
  DAQmx_Val_Switch_Topology_2530_4_Wire_Dual_16x1_Mux       = '2530/4-Wire Dual 16x1 Mux'     ;    // 2530/4-Wire Dual 16x1 Mux
  DAQmx_Val_Switch_Topology_2530_Independent                = '2530/Independent'              ;    // 2530/Independent
  DAQmx_Val_Switch_Topology_2532_1_Wire_16x32_Matrix        = '2532/1-Wire 16x32 Matrix'      ;    // 2532/1-Wire 16x32 Matrix
  DAQmx_Val_Switch_Topology_2532_1_Wire_4x128_Matrix        = '2532/1-Wire 4x128 Matrix'      ;    // 2532/1-Wire 4x128 Matrix
  DAQmx_Val_Switch_Topology_2532_1_Wire_8x64_Matrix         = '2532/1-Wire 8x64 Matrix'       ;    // 2532/1-Wire 8x64 Matrix
  DAQmx_Val_Switch_Topology_2532_1_Wire_Dual_16x16_Matrix   = '2532/1-Wire Dual 16x16 Matrix' ;    // 2532/1-Wire Dual 16x16 Matrix
  DAQmx_Val_Switch_Topology_2532_1_Wire_Dual_4x64_Matrix    = '2532/1-Wire Dual 4x64 Matrix'  ;    // 2532/1-Wire Dual 4x64 Matrix
  DAQmx_Val_Switch_Topology_2532_1_Wire_Dual_8x32_Matrix    = '2532/1-Wire Dual 8x32 Matrix'  ;    // 2532/1-Wire Dual 8x32 Matrix
  DAQmx_Val_Switch_Topology_2532_1_Wire_Sixteen_2x16_Matrix = '2532/1-Wire Sixteen 2x16 Matrix';   // 2532/1-Wire Sixteen 2x16 Matrix
  DAQmx_Val_Switch_Topology_2532_2_Wire_16x16_Matrix        = '2532/2-Wire 16x16 Matrix'      ;    // 2532/2-Wire 16x16 Matrix
  DAQmx_Val_Switch_Topology_2532_2_Wire_4x64_Matrix         = '2532/2-Wire 4x64 Matrix'       ;    // 2532/2-Wire 4x64 Matrix
  DAQmx_Val_Switch_Topology_2532_2_Wire_8x32_Matrix         = '2532/2-Wire 8x32 Matrix'       ;    // 2532/2-Wire 8x32 Matrix
  DAQmx_Val_Switch_Topology_2533_1_Wire_4x64_Matrix         = '2533/1-Wire 4x64 Matrix'       ;    // 2533/1-Wire 4x64 Matrix
  DAQmx_Val_Switch_Topology_2534_1_Wire_8x32_Matrix         = '2534/1-Wire 8x32 Matrix'       ;    // 2534/1-Wire 8x32 Matrix
  DAQmx_Val_Switch_Topology_2535_1_Wire_4x136_Matrix        = '2535/1-Wire 4x136 Matrix'      ;    // 2535/1-Wire 4x136 Matrix
  DAQmx_Val_Switch_Topology_2536_1_Wire_8x68_Matrix         = '2536/1-Wire 8x68 Matrix'       ;    // 2536/1-Wire 8x68 Matrix
  DAQmx_Val_Switch_Topology_2545_4x1_Terminated_Mux         = '2545/4x1 Terminated Mux'       ;    // 2545/4x1 Terminated Mux
  DAQmx_Val_Switch_Topology_2546_Dual_4x1_Mux               = '2546/Dual 4x1 Mux'             ;    // 2546/Dual 4x1 Mux
  DAQmx_Val_Switch_Topology_2547_8x1_Mux                    = '2547/8x1 Mux'                  ;    // 2547/8x1 Mux
  DAQmx_Val_Switch_Topology_2548_4_SPDT                     = '2548/4-SPDT'                   ;    // 2548/4-SPDT
  DAQmx_Val_Switch_Topology_2549_Terminated_2_SPDT          = '2549/Terminated 2-SPDT'        ;    // 2549/Terminated 2-SPDT
  DAQmx_Val_Switch_Topology_2554_4x1_Mux                    = '2554/4x1 Mux'                  ;    // 2554/4x1 Mux
  DAQmx_Val_Switch_Topology_2555_4x1_Terminated_Mux         = '2555/4x1 Terminated Mux'       ;    // 2555/4x1 Terminated Mux
  DAQmx_Val_Switch_Topology_2556_Dual_4x1_Mux               = '2556/Dual 4x1 Mux'             ;    // 2556/Dual 4x1 Mux
  DAQmx_Val_Switch_Topology_2557_8x1_Mux                    = '2557/8x1 Mux'                  ;    // 2557/8x1 Mux
  DAQmx_Val_Switch_Topology_2558_4_SPDT                     = '2558/4-SPDT'                   ;    // 2558/4-SPDT
  DAQmx_Val_Switch_Topology_2559_Terminated_2_SPDT          = '2559/Terminated 2-SPDT'        ;    // 2559/Terminated 2-SPDT
  DAQmx_Val_Switch_Topology_2564_16_SPST                    = '2564/16-SPST'                  ;    // 2564/16-SPST
  DAQmx_Val_Switch_Topology_2564_8_DPST                     = '2564/8-DPST'                   ;    // 2564/8-DPST
  DAQmx_Val_Switch_Topology_2565_16_SPST                    = '2565/16-SPST'                  ;    // 2565/16-SPST
  DAQmx_Val_Switch_Topology_2566_16_SPDT                    = '2566/16-SPDT'                  ;    // 2566/16-SPDT
  DAQmx_Val_Switch_Topology_2566_8_DPDT                     = '2566/8-DPDT'                   ;    // 2566/8-DPDT
  DAQmx_Val_Switch_Topology_2567_Independent                = '2567/Independent'              ;    // 2567/Independent
  DAQmx_Val_Switch_Topology_2568_31_SPST                    = '2568/31-SPST'                  ;    // 2568/31-SPST
  DAQmx_Val_Switch_Topology_2568_15_DPST                    = '2568/15-DPST'                  ;    // 2568/15-DPST
  DAQmx_Val_Switch_Topology_2569_100_SPST                   = '2569/100-SPST'                 ;    // 2569/100-SPST
  DAQmx_Val_Switch_Topology_2569_50_DPST                    = '2569/50-DPST'                  ;    // 2569/50-DPST
  DAQmx_Val_Switch_Topology_2570_40_SPDT                    = '2570/40-SPDT'                  ;    // 2570/40-SPDT
  DAQmx_Val_Switch_Topology_2570_20_DPDT                    = '2570/20-DPDT'                  ;    // 2570/20-DPDT
  DAQmx_Val_Switch_Topology_2575_1_Wire_196x1_Mux           = '2575/1-Wire 196x1 Mux'         ;    // 2575/1-Wire 196x1 Mux
  DAQmx_Val_Switch_Topology_2575_2_Wire_98x1_Mux            = '2575/2-Wire 98x1 Mux'          ;    // 2575/2-Wire 98x1 Mux
  DAQmx_Val_Switch_Topology_2575_2_Wire_95x1_Mux            = '2575/2-Wire 95x1 Mux'          ;    // 2575/2-Wire 95x1 Mux
  DAQmx_Val_Switch_Topology_2576_2_Wire_64x1_Mux            = '2576/2-Wire 64x1 Mux'          ;    // 2576/2-Wire 64x1 Mux
  DAQmx_Val_Switch_Topology_2576_2_Wire_Dual_32x1_Mux       = '2576/2-Wire Dual 32x1 Mux'     ;    // 2576/2-Wire Dual 32x1 Mux
  DAQmx_Val_Switch_Topology_2576_2_Wire_Octal_8x1_Mux       = '2576/2-Wire Octal 8x1 Mux'     ;    // 2576/2-Wire Octal 8x1 Mux
  DAQmx_Val_Switch_Topology_2576_2_Wire_Quad_16x1_Mux       = '2576/2-Wire Quad 16x1 Mux'     ;    // 2576/2-Wire Quad 16x1 Mux
  DAQmx_Val_Switch_Topology_2576_2_Wire_Sixteen_4x1_Mux     = '2576/2-Wire Sixteen 4x1 Mux'   ;    // 2576/2-Wire Sixteen 4x1 Mux
  DAQmx_Val_Switch_Topology_2576_Independent                = '2576/Independent'              ;    // 2576/Independent
  DAQmx_Val_Switch_Topology_2584_1_Wire_12x1_Mux            = '2584/1-Wire 12x1 Mux'          ;    // 2584/1-Wire 12x1 Mux
  DAQmx_Val_Switch_Topology_2584_1_Wire_Dual_6x1_Mux        = '2584/1-Wire Dual 6x1 Mux'      ;    // 2584/1-Wire Dual 6x1 Mux
  DAQmx_Val_Switch_Topology_2584_2_Wire_6x1_Mux             = '2584/2-Wire 6x1 Mux'           ;    // 2584/2-Wire 6x1 Mux
  DAQmx_Val_Switch_Topology_2584_Independent                = '2584/Independent'              ;    // 2584/Independent
  DAQmx_Val_Switch_Topology_2585_1_Wire_10x1_Mux            = '2585/1-Wire 10x1 Mux'          ;    // 2585/1-Wire 10x1 Mux
  DAQmx_Val_Switch_Topology_2586_10_SPST                    = '2586/10-SPST'                  ;    // 2586/10-SPST
  DAQmx_Val_Switch_Topology_2586_5_DPST                     = '2586/5-DPST'                   ;    // 2586/5-DPST
  DAQmx_Val_Switch_Topology_2590_4x1_Mux                    = '2590/4x1 Mux'                  ;    // 2590/4x1 Mux
  DAQmx_Val_Switch_Topology_2591_4x1_Mux                    = '2591/4x1 Mux'                  ;    // 2591/4x1 Mux
  DAQmx_Val_Switch_Topology_2593_16x1_Mux                   = '2593/16x1 Mux'                 ;    // 2593/16x1 Mux
  DAQmx_Val_Switch_Topology_2593_Dual_8x1_Mux               = '2593/Dual 8x1 Mux'             ;    // 2593/Dual 8x1 Mux
  DAQmx_Val_Switch_Topology_2593_8x1_Terminated_Mux         = '2593/8x1 Terminated Mux'       ;    // 2593/8x1 Terminated Mux
  DAQmx_Val_Switch_Topology_2593_Dual_4x1_Terminated_Mux    = '2593/Dual 4x1 Terminated Mux'  ;    // 2593/Dual 4x1 Terminated Mux
  DAQmx_Val_Switch_Topology_2593_Independent                = '2593/Independent'              ;    // 2593/Independent
  DAQmx_Val_Switch_Topology_2594_4x1_Mux                    = '2594/4x1 Mux'                  ;    // 2594/4x1 Mux
  DAQmx_Val_Switch_Topology_2595_4x1_Mux                    = '2595/4x1 Mux'                  ;    // 2595/4x1 Mux
  DAQmx_Val_Switch_Topology_2596_Dual_6x1_Mux               = '2596/Dual 6x1 Mux'             ;    // 2596/Dual 6x1 Mux
  DAQmx_Val_Switch_Topology_2597_6x1_Terminated_Mux         = '2597/6x1 Terminated Mux'       ;    // 2597/6x1 Terminated Mux
  DAQmx_Val_Switch_Topology_2598_Dual_Transfer              = '2598/Dual Transfer'            ;    // 2598/Dual Transfer
  DAQmx_Val_Switch_Topology_2599_2_SPDT                     = '2599/2-SPDT'                   ;    // 2599/2-SPDT


(******************************************************************************
 *** NI-DAQmx Error Codes *****************************************************
 ******************************************************************************)

 {
  DAQmxSuccess
  DAQmxFailed
 }

// Error and Warning Codes
  DAQmxErrorCOCannotKeepUpInHWTimedSinglePoint                                    = -209805;
  DAQmxErrorWaitForNextSampClkDetected3OrMoreSampClks                             = -209803;
  DAQmxErrorWaitForNextSampClkDetectedMissedSampClk                               = -209802;
  DAQmxErrorWriteNotCompleteBeforeSampClk                                         = -209801;
  DAQmxErrorReadNotCompleteBeforeSampClk                                          = -209800;
  DAQmxErrorReferencedDevSimMustMatchTarget                                       = -201230;
  DAQmxErrorProgrammedIOFailsBecauseOfWatchdogTimer                               = -201229;
  DAQmxErrorWatchdogTimerFailsBecauseOfProgrammedIO                               = -201228;
  DAQmxErrorCantUseThisTimingEngineWithAPort                                      = -201227;
  DAQmxErrorProgrammedIOConflict                                                  = -201226;
  DAQmxErrorChangeDetectionIncompatibleWithProgrammedIO                           = -201225;
  DAQmxErrorTristateNotEnoughLines                                                = -201224;
  DAQmxErrorTristateConflict                                                      = -201223;
  DAQmxErrorGenerateOrFiniteWaitExpectedBeforeBreakBlock                          = -201222;
  DAQmxErrorBreakBlockNotAllowedInLoop                                            = -201221;
  DAQmxErrorClearTriggerNotAllowedInBreakBlock                                    = -201220;
  DAQmxErrorNestingNotAllowedInBreakBlock                                         = -201219;
  DAQmxErrorIfElseBlockNotAllowedInBreakBlock                                     = -201218;
  DAQmxErrorRepeatUntilTriggerLoopNotAllowedInBreakBlock                          = -201217;
  DAQmxErrorWaitUntilTriggerNotAllowedInBreakBlock                                = -201216;
  DAQmxErrorMarkerPosInvalidInBreakBlock                                          = -201215;
  DAQmxErrorInvalidWaitDurationInBreakBlock                                       = -201214;
  DAQmxErrorInvalidSubsetLengthInBreakBlock                                       = -201213;
  DAQmxErrorInvalidWaveformLengthInBreakBlock                                     = -201212;
  DAQmxErrorInvalidWaitDurationBeforeBreakBlock                                   = -201211;
  DAQmxErrorInvalidSubsetLengthBeforeBreakBlock                                   = -201210;
  DAQmxErrorInvalidWaveformLengthBeforeBreakBlock                                 = -201209;
  DAQmxErrorSampleRateTooHighForADCTimingMode                                     = -201208;
  DAQmxErrorActiveDevNotSupportedWithMultiDevTask                                 = -201207;
  DAQmxErrorRealDevAndSimDevNotSupportedInSameTask                                = -201206;
  DAQmxErrorRTSISimMustMatchDevSim                                                = -201205;
  DAQmxErrorBridgeShuntCaNotSupported                                             = -201204;
  DAQmxErrorStrainShuntCaNotSupported                                             = -201203;
  DAQmxErrorGainTooLargeForGainCalConst                                           = -201202;
  DAQmxErrorOffsetTooLargeForOffsetCalConst                                       = -201201;
  DAQmxErrorElvisPrototypingBoardRemoved                                          = -201200;
  DAQmxErrorElvis2PowerRailFault                                                  = -201199;
  DAQmxErrorElvis2PhysicalChansFault                                              = -201198;
  DAQmxErrorElvis2PhysicalChansThermalEvent                                       = -201197;
  DAQmxErrorRXBitErrorRateLimitExceeded                                           = -201196;
  DAQmxErrorPHYBitErrorRateLimitExceeded                                          = -201195;
  DAQmxErrorTwoPartAttributeCalledOutOfOrder                                      = -201194;
  DAQmxErrorInvalidSCXIChassisAddress                                             = -201193;
  DAQmxErrorCouldNotConnectToRemoteMXS                                            = -201192;
  DAQmxErrorExcitationStateRequiredForAttributes                                  = -201191;
  DAQmxErrorDeviceNotUsableUntilUSBReplug                                         = -201190;
  DAQmxErrorInputFIFOOverflowDuringCalibrationOnFullSpeedUSB                      = -201189;
  DAQmxErrorInputFIFOOverflowDuringCalibration                                    = -201188;
  DAQmxErrorCJCChanConflictsWithNonThermocoupleChan                               = -201187;
  DAQmxErrorCommDeviceForPXIBackplaneNotInRightmostSlot                           = -201186;
  DAQmxErrorCommDeviceForPXIBackplaneNotInSameChassis                             = -201185;
  DAQmxErrorCommDeviceForPXIBackplaneNotPXI                                       = -201184;
  DAQmxErrorInvalidCalExcitFrequency                                              = -201183;
  DAQmxErrorInvalidCalExcitVoltage                                                = -201182;
  DAQmxErrorInvalidAIInputSrc                                                     = -201181;
  DAQmxErrorInvalidCalInputRef                                                    = -201180;
  DAQmxErrordBReferenceValueNotGreaterThanZero                                    = -201179;
  DAQmxErrorSampleClockRateIsTooFastForSampleClockTiming                          = -201178;
  DAQmxErrorDeviceNotUsableUntilColdStart                                         = -201177;
  DAQmxErrorSampleClockRateIsTooFastForBurstTiming                                = -201176;
  DAQmxErrorDevImportFailedAssociatedResourceIDsNotSupported                      = -201175;
  DAQmxErrorSCXI1600ImportNotSupported                                            = -201174;
  DAQmxErrorPowerSupplyConfigurationFailed                                        = -201173;
  DAQmxErrorIEPEWithDCNotAllowed                                                  = -201172;
  DAQmxErrorMinTempForThermocoupleTypeOutsideAccuracyForPolyScaling               = -201171;
  DAQmxErrorDevImportFailedNoDeviceToOverwriteAndSimulationNotSupported           = -201170;
  DAQmxErrorDevImportFailedDeviceNotSupportedOnDestination                        = -201169;
  DAQmxErrorFirmwareIsTooOld                                                      = -201168;
  DAQmxErrorFirmwareCouldntUpdate                                                 = -201167;
  DAQmxErrorFirmwareIsCorrupt                                                     = -201166;
  DAQmxErrorFirmwareTooNew                                                        = -201165;
  DAQmxErrorSampClockCannotBeExportedFromExternalSampClockSrc                     = -201164;
  DAQmxErrorPhysChanReservedForInputWhenDesiredForOutput                          = -201163;
  DAQmxErrorPhysChanReservedForOutputWhenDesiredForInput                          = -201162;
  DAQmxErrorSpecifiedCDAQSlotNotEmpty                                             = -201161;
  DAQmxErrorDeviceDoesNotSupportSimulation                                        = -201160;
  DAQmxErrorInvalidCDAQSlotNumberSpecd                                            = -201159;
  DAQmxErrorCSeriesModSimMustMatchCDAQChassisSim                                  = -201158;
  DAQmxErrorSCCCabledDevMustNotBeSimWhenSCCCarrierIsNotSim                        = -201157;
  DAQmxErrorSCCModSimMustMatchSCCCarrierSim                                       = -201156;
  DAQmxErrorSCXIModuleDoesNotSupportSimulation                                    = -201155;
  DAQmxErrorSCXICableDevMustNotBeSimWhenModIsNotSim                               = -201154;
  DAQmxErrorSCXIDigitizerSimMustNotBeSimWhenModIsNotSim                           = -201153;
  DAQmxErrorSCXIModSimMustMatchSCXIChassisSim                                     = -201152;
  DAQmxErrorSimPXIDevReqSlotAndChassisSpecd                                       = -201151;
  DAQmxErrorSimDevConflictWithRealDev                                             = -201150;
  DAQmxErrorInsufficientDataForCalibration                                        = -201149;
  DAQmxErrorTriggerChannelMustBeEnabled                                           = -201148;
  DAQmxErrorCalibrationDataConflictCouldNotBeResolved                             = -201147;
  DAQmxErrorSoftwareTooNewForSelfCalibrationData                                  = -201146;
  DAQmxErrorSoftwareTooNewForExtCalibrationData                                   = -201145;
  DAQmxErrorSelfCalibrationDataTooNewForSoftware                                  = -201144;
  DAQmxErrorExtCalibrationDataTooNewForSoftware                                   = -201143;
  DAQmxErrorSoftwareTooNewForEEPROM                                               = -201142;
  DAQmxErrorEEPROMTooNewForSoftware                                               = -201141;
  DAQmxErrorSoftwareTooNewForHardware                                             = -201140;
  DAQmxErrorHardwareTooNewForSoftware                                             = -201139;
  DAQmxErrorTaskCannotRestartFirstSampNotAvailToGenerate                          = -201138;
  DAQmxErrorOnlyUseStartTrigSrcPrptyWithDevDataLines                              = -201137;
  DAQmxErrorOnlyUsePauseTrigSrcPrptyWithDevDataLines                              = -201136;
  DAQmxErrorOnlyUseRefTrigSrcPrptyWithDevDataLines                                = -201135;
  DAQmxErrorPauseTrigDigPatternSizeDoesNotMatchSrcSize                            = -201134;
  DAQmxErrorLineConflictCDAQ                                                      = -201133;
  DAQmxErrorCannotWriteBeyondFinalFiniteSample                                    = -201132;
  DAQmxErrorRefAndStartTriggerSrcCantBeSame                                       = -201131;
  DAQmxErrorMemMappingIncompatibleWithPhysChansInTask                             = -201130;
  DAQmxErrorOutputDriveTypeMemMappingConflict                                     = -201129;
  DAQmxErrorCAPIDeviceIndexInvalid                                                = -201128;
  DAQmxErrorRatiometricDevicesMustUseExcitationForScaling                         = -201127;
  DAQmxErrorPropertyRequiresPerDeviceCfg                                          = -201126;
  DAQmxErrorAICouplingAndAIInputSourceConflict                                    = -201125;
  DAQmxErrorOnlyOneTaskCanPerformDOMemoryMappingAtATime                           = -201124;
  DAQmxErrorTooManyChansForAnalogRefTrigCDAQ                                      = -201123;
  DAQmxErrorSpecdPropertyValueIsIncompatibleWithSampleTimingType                  = -201122;
  DAQmxErrorCPUNotSupportedRequireSSE                                             = -201121;
  DAQmxErrorSpecdPropertyValueIsIncompatibleWithSampleTimingResponseMode          = -201120;
  DAQmxErrorConflictingNextWriteIsLastAndRegenModeProperties                      = -201119;
  DAQmxErrorMStudioOperationDoesNotSupportDeviceContext                           = -201118;
  DAQmxErrorPropertyValueInChannelExpansionContextInvalid                         = -201117;
  DAQmxErrorHWTimedNonBufferedAONotSupported                                      = -201116;
  DAQmxErrorWaveformLengthNotMultOfQuantum                                        = -201115;
  DAQmxErrorDSAExpansionMixedBoardsWrongOrderInPXIChassis                         = -201114;
  DAQmxErrorPowerLevelTooLowForOOK                                                = -201113;
  DAQmxErrorDeviceComponentTestFailure                                            = -201112;
  DAQmxErrorUserDefinedWfmWithOOKUnsupported                                      = -201111;
  DAQmxErrorInvalidDigitalModulationUserDefinedWaveform                           = -201110;
  DAQmxErrorBothRefInAndRefOutEnabled                                             = -201109;
  DAQmxErrorBothAnalogAndDigitalModulationEnabled                                 = -201108;
  DAQmxErrorBufferedOpsNotSupportedInSpecdSlotForCDAQ                             = -201107;
  DAQmxErrorPhysChanNotSupportedInSpecdSlotForCDAQ                                = -201106;
  DAQmxErrorResourceReservedWithConflictingSettings                               = -201105;
  DAQmxErrorInconsistentAnalogTrigSettingsCDAQ                                    = -201104;
  DAQmxErrorTooManyChansForAnalogPauseTrigCDAQ                                    = -201103;
  DAQmxErrorAnalogTrigNotFirstInScanListCDAQ                                      = -201102;
  DAQmxErrorTooManyChansGivenTimingType                                           = -201101;
  DAQmxErrorSampClkTimebaseDivWithExtSampClk                                      = -201100;
  DAQmxErrorCantSaveTaskWithPerDeviceTimingProperties                             = -201099;
  DAQmxErrorConflictingAutoZeroMode                                               = -201098;
  DAQmxErrorSampClkRateNotSupportedWithEAREnabled                                 = -201097;
  DAQmxErrorSampClkTimebaseRateNotSpecd                                           = -201096;
  DAQmxErrorSessionCorruptedByDLLReload                                           = -201095;
  DAQmxErrorActiveDevNotSupportedWithChanExpansion                                = -201094;
  DAQmxErrorSampClkRateInvalid                                                    = -201093;
  DAQmxErrorExtSyncPulseSrcCannotBeExported                                       = -201092;
  DAQmxErrorSyncPulseMinDelayToStartNeededForExtSyncPulseSrc                      = -201091;
  DAQmxErrorSyncPulseSrcInvalid                                                   = -201090;
  DAQmxErrorSampClkTimebaseRateInvalid                                            = -201089;
  DAQmxErrorSampClkTimebaseSrcInvalid                                             = -201088;
  DAQmxErrorSampClkRateMustBeSpecd                                                = -201087;
  DAQmxErrorInvalidAttributeName                                                  = -201086;
  DAQmxErrorCJCChanNameMustBeSetWhenCJCSrcIsScannableChan                         = -201085;
  DAQmxErrorHiddenChanMissingInChansPropertyInCfgFile                             = -201084;
  DAQmxErrorChanNamesNotSpecdInCfgFile                                            = -201083;
  DAQmxErrorDuplicateHiddenChanNamesInCfgFile                                     = -201082;
  DAQmxErrorDuplicateChanNameInCfgFile                                            = -201081;
  DAQmxErrorInvalidSCCModuleForSlotSpecd                                          = -201080;
  DAQmxErrorInvalidSCCSlotNumberSpecd                                             = -201079;
  DAQmxErrorInvalidSectionIdentifier                                              = -201078;
  DAQmxErrorInvalidSectionName                                                    = -201077;
  DAQmxErrorDAQmxVersionNotSupported                                              = -201076;
  DAQmxErrorSWObjectsFoundInFile                                                  = -201075;
  DAQmxErrorHWObjectsFoundInFile                                                  = -201074;
  DAQmxErrorLocalChannelSpecdWithNoParentTask                                     = -201073;
  DAQmxErrorTaskReferencesMissingLocalChannel                                     = -201072;
  DAQmxErrorTaskReferencesLocalChannelFromOtherTask                               = -201071;
  DAQmxErrorTaskMissingChannelProperty                                            = -201070;
  DAQmxErrorInvalidLocalChanName                                                  = -201069;
  DAQmxErrorInvalidEscapeCharacterInString                                        = -201068;
  DAQmxErrorInvalidTableIdentifier                                                = -201067;
  DAQmxErrorValueFoundInInvalidColumn                                             = -201066;
  DAQmxErrorMissingStartOfTable                                                   = -201065;
  DAQmxErrorFileMissingRequiredDAQmxHeader                                        = -201064;
  DAQmxErrorDeviceIDDoesNotMatch                                                  = -201063;
  DAQmxErrorBufferedOperationsNotSupportedOnSelectedLines                         = -201062;
  DAQmxErrorPropertyConflictsWithScale                                            = -201061;
  DAQmxErrorInvalidINIFileSyntax                                                  = -201060;
  DAQmxErrorDeviceInfoFailedPXIChassisNotIdentified                               = -201059;
  DAQmxErrorInvalidHWProductNumber                                                = -201058;
  DAQmxErrorInvalidHWProductType                                                  = -201057;
  DAQmxErrorInvalidNumericFormatSpecd                                             = -201056;
  DAQmxErrorDuplicatePropertyInObject                                             = -201055;
  DAQmxErrorInvalidEnumValueSpecd                                                 = -201054;
  DAQmxErrorTEDSSensorPhysicalChannelConflict                                     = -201053;
  DAQmxErrorTooManyPhysicalChansForTEDSInterfaceSpecd                             = -201052;
  DAQmxErrorIncapableTEDSInterfaceControllingDeviceSpecd                          = -201051;
  DAQmxErrorSCCCarrierSpecdIsMissing                                              = -201050;
  DAQmxErrorIncapableSCCDigitizingDeviceSpecd                                     = -201049;
  DAQmxErrorAccessorySettingNotApplicable                                         = -201048;
  DAQmxErrorDeviceAndConnectorSpecdAlreadyOccupied                                = -201047;
  DAQmxErrorIllegalAccessoryTypeForDeviceSpecd                                    = -201046;
  DAQmxErrorInvalidDeviceConnectorNumberSpecd                                     = -201045;
  DAQmxErrorInvalidAccessoryName                                                  = -201044;
  DAQmxErrorMoreThanOneMatchForSpecdDevice                                        = -201043;
  DAQmxErrorNoMatchForSpecdDevice                                                 = -201042;
  DAQmxErrorProductTypeAndProductNumberConflict                                   = -201041;
  DAQmxErrorExtraPropertyDetectedInSpecdObject                                    = -201040;
  DAQmxErrorRequiredPropertyMissing                                               = -201039;
  DAQmxErrorCantSetAuthorForLocalChan                                             = -201038;
  DAQmxErrorInvalidTimeValue                                                      = -201037;
  DAQmxErrorInvalidTimeFormat                                                     = -201036;
  DAQmxErrorDigDevChansSpecdInModeOtherThanParallel                               = -201035;
  DAQmxErrorCascadeDigitizationModeNotSupported                                   = -201034;
  DAQmxErrorSpecdSlotAlreadyOccupied                                              = -201033;
  DAQmxErrorInvalidSCXISlotNumberSpecd                                            = -201032;
  DAQmxErrorAddressAlreadyInUse                                                   = -201031;
  DAQmxErrorSpecdDeviceDoesNotSupportRTSI                                         = -201030;
  DAQmxErrorSpecdDeviceIsAlreadyOnRTSIBus                                         = -201029;
  DAQmxErrorIdentifierInUse                                                       = -201028;
  DAQmxErrorWaitForNextSampleClockOrReadDetected3OrMoreMissedSampClks             = -201027;
  DAQmxErrorHWTimedAndDataXferPIO                                                 = -201026;
  DAQmxErrorNonBufferedAndHWTimed                                                 = -201025;
  DAQmxErrorCTROutSampClkPeriodShorterThanGenPulseTrainPeriodPolled               = -201024;
  DAQmxErrorCTROutSampClkPeriodShorterThanGenPulseTrainPeriod2                    = -201023;
  DAQmxErrorCOCannotKeepUpInHWTimedSinglePointPolled                              = -201022;
  DAQmxErrorWriteRecoveryCannotKeepUpInHWTimedSinglePoint                         = -201021;
  DAQmxErrorNoChangeDetectionOnSelectedLineForDevice                              = -201020;
  DAQmxErrorSMIOPauseTriggersNotSupportedWithChannelExpansion                     = -201019;
  DAQmxErrorClockMasterForExternalClockNotLongestPipeline                         = -201018;
  DAQmxErrorUnsupportedUnicodeByteOrderMarker                                     = -201017;
  DAQmxErrorTooManyInstructionsInLoopInScript                                     = -201016;
  DAQmxErrorPLLNotLocked                                                          = -201015;
  DAQmxErrorIfElseBlockNotAllowedInFiniteRepeatLoopInScript                       = -201014;
  DAQmxErrorIfElseBlockNotAllowedInConditionalRepeatLoopInScript                  = -201013;
  DAQmxErrorClearIsLastInstructionInIfElseBlockInScript                           = -201012;
  DAQmxErrorInvalidWaitDurationBeforeIfElseBlockInScript                          = -201011;
  DAQmxErrorMarkerPosInvalidBeforeIfElseBlockInScript                             = -201010;
  DAQmxErrorInvalidSubsetLengthBeforeIfElseBlockInScript                          = -201009;
  DAQmxErrorInvalidWaveformLengthBeforeIfElseBlockInScript                        = -201008;
  DAQmxErrorGenerateOrFiniteWaitInstructionExpectedBeforeIfElseBlockInScript      = -201007;
  DAQmxErrorCalPasswordNotSupported                                               = -201006;
  DAQmxErrorSetupCalNeededBeforeAdjustCal                                         = -201005;
  DAQmxErrorMultipleChansNotSupportedDuringCalSetup                               = -201004;
  DAQmxErrorDevCannotBeAccessed                                                   = -201003;
  DAQmxErrorSampClkRateDoesntMatchSampClkSrc                                      = -201002;
  DAQmxErrorSampClkRateNotSupportedWithEARDisabled                                = -201001;
  DAQmxErrorLabVIEWVersionDoesntSupportDAQmxEvents                                = -201000;
  DAQmxErrorCOReadyForNewValNotSupportedWithOnDemand                              = -200999;
  DAQmxErrorCIHWTimedSinglePointNotSupportedForMeasType                           = -200998;
  DAQmxErrorOnDemandNotSupportedWithHWTimedSinglePoint                            = -200997;
  DAQmxErrorHWTimedSinglePointAndDataXferNotProgIO                                = -200996;
  DAQmxErrorMemMapAndHWTimedSinglePoint                                           = -200995;
  DAQmxErrorCannotSetPropertyWhenHWTimedSinglePointTaskIsRunning                  = -200994;
  DAQmxErrorCTROutSampClkPeriodShorterThanGenPulseTrainPeriod                     = -200993;
  DAQmxErrorTooManyEventsGenerated                                                = -200992;
  DAQmxErrorMStudioCppRemoveEventsBeforeStop                                      = -200991;
  DAQmxErrorCAPICannotRegisterSyncEventsFromMultipleThreads                       = -200990;
  DAQmxErrorReadWaitNextSampClkWaitMismatchTwo                                    = -200989;
  DAQmxErrorReadWaitNextSampClkWaitMismatchOne                                    = -200988;
  DAQmxErrorDAQmxSignalEventTypeNotSupportedByChanTypesOrDevicesInTask            = -200987;
  DAQmxErrorCannotUnregisterDAQmxSoftwareEventWhileTaskIsRunning                  = -200986;
  DAQmxErrorAutoStartWriteNotAllowedEventRegistered                               = -200985;
  DAQmxErrorAutoStartReadNotAllowedEventRegistered                                = -200984;
  DAQmxErrorCannotGetPropertyWhenTaskNotReservedCommittedOrRunning                = -200983;
  DAQmxErrorSignalEventsNotSupportedByDevice                                      = -200982;
  DAQmxErrorEveryNSamplesAcqIntoBufferEventNotSupportedByDevice                   = -200981;
  DAQmxErrorEveryNSampsTransferredFromBufferEventNotSupportedByDevice             = -200980;
  DAQmxErrorCAPISyncEventsTaskStateChangeNotAllowedFromDifferentThread            = -200979;
  DAQmxErrorDAQmxSWEventsWithDifferentCallMechanisms                              = -200978;
  DAQmxErrorCantSaveChanWithPolyCalScaleAndAllowInteractiveEdit                   = -200977;
  DAQmxErrorChanDoesNotSupportCJC                                                 = -200976;
  DAQmxErrorCOReadyForNewValNotSupportedWithHWTimedSinglePoint                    = -200975;
  DAQmxErrorDACAllowConnToGndNotSupportedByDevWhenRefSrcExt                       = -200974;
  DAQmxErrorCantGetPropertyTaskNotRunning                                         = -200973;
  DAQmxErrorCantSetPropertyTaskNotRunning                                         = -200972;
  DAQmxErrorCantSetPropertyTaskNotRunningCommitted                                = -200971;
  DAQmxErrorAIEveryNSampsEventIntervalNotMultipleOf2                              = -200970;
  DAQmxErrorInvalidTEDSPhysChanNotAI                                              = -200969;
  DAQmxErrorCAPICannotPerformTaskOperationInAsyncCallback                         = -200968;
  DAQmxErrorEveryNSampsTransferredFromBufferEventAlreadyRegistered                = -200967;
  DAQmxErrorEveryNSampsAcqIntoBufferEventAlreadyRegistered                        = -200966;
  DAQmxErrorEveryNSampsTransferredFromBufferNotForInput                           = -200965;
  DAQmxErrorEveryNSampsAcqIntoBufferNotForOutput                                  = -200964;
  DAQmxErrorAOSampTimingTypeDifferentIn2Tasks                                     = -200963;
  DAQmxErrorCouldNotDownloadFirmwareHWDamaged                                     = -200962;
  DAQmxErrorCouldNotDownloadFirmwareFileMissingOrDamaged                          = -200961;
  DAQmxErrorCannotRegisterDAQmxSoftwareEventWhileTaskIsRunning                    = -200960;
  DAQmxErrorDifferentRawDataCompression                                           = -200959;
  DAQmxErrorConfiguredTEDSInterfaceDevNotDetected                                 = -200958;
  DAQmxErrorCompressedSampSizeExceedsResolution                                   = -200957;
  DAQmxErrorChanDoesNotSupportCompression                                         = -200956;
  DAQmxErrorDifferentRawDataFormats                                               = -200955;
  DAQmxErrorSampClkOutputTermIncludesStartTrigSrc                                 = -200954;
  DAQmxErrorStartTrigSrcEqualToSampClkSrc                                         = -200953;
  DAQmxErrorEventOutputTermIncludesTrigSrc                                        = -200952;
  DAQmxErrorCOMultipleWritesBetweenSampClks                                       = -200951;
  DAQmxErrorDoneEventAlreadyRegistered                                            = -200950;
  DAQmxErrorSignalEventAlreadyRegistered                                          = -200949;
  DAQmxErrorCannotHaveTimedLoopAndDAQmxSignalEventsInSameTask                     = -200948;
  DAQmxErrorNeedLabVIEW711PatchToUseDAQmxEvents                                   = -200947;
  DAQmxErrorStartFailedDueToWriteFailure                                          = -200946;
  DAQmxErrorDataXferCustomThresholdNotDMAXferMethodSpecifiedForDev                = -200945;
  DAQmxErrorDataXferRequestConditionNotSpecifiedForCustomThreshold                = -200944;
  DAQmxErrorDataXferCustomThresholdNotSpecified                                   = -200943;
  DAQmxErrorCAPISyncCallbackNotSupportedOnThisPlatform                            = -200942;
  DAQmxErrorCalChanReversePolyCoefNotSpecd                                        = -200941;
  DAQmxErrorCalChanForwardPolyCoefNotSpecd                                        = -200940;
  DAQmxErrorChanCalRepeatedNumberInPreScaledVals                                  = -200939;
  DAQmxErrorChanCalTableNumScaledNotEqualNumPrescaledVals                         = -200938;
  DAQmxErrorChanCalTableScaledValsNotSpecd                                        = -200937;
  DAQmxErrorChanCalTablePreScaledValsNotSpecd                                     = -200936;
  DAQmxErrorChanCalScaleTypeNotSet                                                = -200935;
  DAQmxErrorChanCalExpired                                                        = -200934;
  DAQmxErrorChanCalExpirationDateNotSet                                           = -200933;
  DAQmxError3OutputPortCombinationGivenSampTimingType653x                         = -200932;
  DAQmxError3InputPortCombinationGivenSampTimingType653x                          = -200931;
  DAQmxError2OutputPortCombinationGivenSampTimingType653x                         = -200930;
  DAQmxError2InputPortCombinationGivenSampTimingType653x                          = -200929;
  DAQmxErrorPatternMatcherMayBeUsedByOneTrigOnly                                  = -200928;
  DAQmxErrorNoChansSpecdForPatternSource                                          = -200927;
  DAQmxErrorChangeDetectionChanNotInTask                                          = -200926;
  DAQmxErrorChangeDetectionChanNotTristated                                       = -200925;
  DAQmxErrorWaitModeValueNotSupportedNonBuffered                                  = -200924;
  DAQmxErrorWaitModePropertyNotSupportedNonBuffered                               = -200923;
  DAQmxErrorCantSavePerLineConfigDigChanSoInteractiveEditsAllowed                 = -200922;
  DAQmxErrorCantSaveNonPortMultiLineDigChanSoInteractiveEditsAllowed              = -200921;
  DAQmxErrorBufferSizeNotMultipleOfEveryNSampsEventIntervalNoIrqOnDev             = -200920;
  DAQmxErrorGlobalTaskNameAlreadyChanName                                         = -200919;
  DAQmxErrorGlobalChanNameAlreadyTaskName                                         = -200918;
  DAQmxErrorAOEveryNSampsEventIntervalNotMultipleOf2                              = -200917;
  DAQmxErrorSampleTimebaseDivisorNotSupportedGivenTimingType                      = -200916;
  DAQmxErrorHandshakeEventOutputTermNotSupportedGivenTimingType                   = -200915;
  DAQmxErrorChangeDetectionOutputTermNotSupportedGivenTimingType                  = -200914;
  DAQmxErrorReadyForTransferOutputTermNotSupportedGivenTimingType                 = -200913;
  DAQmxErrorRefTrigOutputTermNotSupportedGivenTimingType                          = -200912;
  DAQmxErrorStartTrigOutputTermNotSupportedGivenTimingType                        = -200911;
  DAQmxErrorSampClockOutputTermNotSupportedGivenTimingType                        = -200910;
  DAQmxError20MhzTimebaseNotSupportedGivenTimingType                              = -200909;
  DAQmxErrorSampClockSourceNotSupportedGivenTimingType                            = -200908;
  DAQmxErrorRefTrigTypeNotSupportedGivenTimingType                                = -200907;
  DAQmxErrorPauseTrigTypeNotSupportedGivenTimingType                              = -200906;
  DAQmxErrorHandshakeTrigTypeNotSupportedGivenTimingType                          = -200905;
  DAQmxErrorStartTrigTypeNotSupportedGivenTimingType                              = -200904;
  DAQmxErrorRefClkSrcNotSupported                                                 = -200903;
  DAQmxErrorDataVoltageLowAndHighIncompatible                                     = -200902;
  DAQmxErrorInvalidCharInDigPatternString                                         = -200901;
  DAQmxErrorCantUsePort3AloneGivenSampTimingTypeOn653x                            = -200900;
  DAQmxErrorCantUsePort1AloneGivenSampTimingTypeOn653x                            = -200899;
  DAQmxErrorPartialUseOfPhysicalLinesWithinPortNotSupported653x                   = -200898;
  DAQmxErrorPhysicalChanNotSupportedGivenSampTimingType653x                       = -200897;
  DAQmxErrorCanExportOnlyDigEdgeTrigs                                             = -200896;
  DAQmxErrorRefTrigDigPatternSizeDoesNotMatchSourceSize                           = -200895;
  DAQmxErrorStartTrigDigPatternSizeDoesNotMatchSourceSize                         = -200894;
  DAQmxErrorChangeDetectionRisingAndFallingEdgeChanDontMatch                      = -200893;
  DAQmxErrorPhysicalChansForChangeDetectionAndPatternMatch653x                    = -200892;
  DAQmxErrorCanExportOnlyOnboardSampClk                                           = -200891;
  DAQmxErrorInternalSampClkNotRisingEdge                                          = -200890;
  DAQmxErrorRefTrigDigPatternChanNotInTask                                        = -200889;
  DAQmxErrorRefTrigDigPatternChanNotTristated                                     = -200888;
  DAQmxErrorStartTrigDigPatternChanNotInTask                                      = -200887;
  DAQmxErrorStartTrigDigPatternChanNotTristated                                   = -200886;
  DAQmxErrorPXIStarAndClock10Sync                                                 = -200885;
  DAQmxErrorGlobalChanCannotBeSavedSoInteractiveEditsAllowed                      = -200884;
  DAQmxErrorTaskCannotBeSavedSoInteractiveEditsAllowed                            = -200883;
  DAQmxErrorInvalidGlobalChan                                                     = -200882;
  DAQmxErrorEveryNSampsEventAlreadyRegistered                                     = -200881;
  DAQmxErrorEveryNSampsEventIntervalZeroNotSupported                              = -200880;
  DAQmxErrorChanSizeTooBigForU16PortWrite                                         = -200879;
  DAQmxErrorChanSizeTooBigForU16PortRead                                          = -200878;
  DAQmxErrorBufferSizeNotMultipleOfEveryNSampsEventIntervalWhenDMA                = -200877;
  DAQmxErrorWriteWhenTaskNotRunningCOTicks                                        = -200876;
  DAQmxErrorWriteWhenTaskNotRunningCOFreq                                         = -200875;
  DAQmxErrorWriteWhenTaskNotRunningCOTime                                         = -200874;
  DAQmxErrorAOMinMaxNotSupportedDACRangeTooSmall                                  = -200873;
  DAQmxErrorAOMinMaxNotSupportedGivenDACRange                                     = -200872;
  DAQmxErrorAOMinMaxNotSupportedGivenDACRangeAndOffsetVal                         = -200871;
  DAQmxErrorAOMinMaxNotSupportedDACOffsetValInappropriate                         = -200870;
  DAQmxErrorAOMinMaxNotSupportedGivenDACOffsetVal                                 = -200869;
  DAQmxErrorAOMinMaxNotSupportedDACRefValTooSmall                                 = -200868;
  DAQmxErrorAOMinMaxNotSupportedGivenDACRefVal                                    = -200867;
  DAQmxErrorAOMinMaxNotSupportedGivenDACRefAndOffsetVal                           = -200866;
  DAQmxErrorWhenAcqCompAndNumSampsPerChanExceedsOnBrdBufSize                      = -200865;
  DAQmxErrorWhenAcqCompAndNoRefTrig                                               = -200864;
  DAQmxErrorWaitForNextSampClkNotSupported                                        = -200863;
  DAQmxErrorDevInUnidentifiedPXIChassis                                           = -200862;
  DAQmxErrorMaxSoundPressureMicSensitivitRelatedAIPropertiesNotSupportedByDev     = -200861;
  DAQmxErrorMaxSoundPressureAndMicSensitivityNotSupportedByDev                    = -200860;
  DAQmxErrorAOBufferSizeZeroForSampClkTimingType                                  = -200859;
  DAQmxErrorAOCallWriteBeforeStartForSampClkTimingType                            = -200858;
  DAQmxErrorInvalidCalLowPassCutoffFreq                                           = -200857;
  DAQmxErrorSimulationCannotBeDisabledForDevCreatedAsSimulatedDev                 = -200856;
  DAQmxErrorCannotAddNewDevsAfterTaskConfiguration                                = -200855;
  DAQmxErrorDifftSyncPulseSrcAndSampClkTimebaseSrcDevMultiDevTask                 = -200854;
  DAQmxErrorTermWithoutDevInMultiDevTask                                          = -200853;
  DAQmxErrorSyncNoDevSampClkTimebaseOrSyncPulseInPXISlot2                         = -200852;
  DAQmxErrorPhysicalChanNotOnThisConnector                                        = -200851;
  DAQmxErrorNumSampsToWaitNotGreaterThanZeroInScript                              = -200850;
  DAQmxErrorNumSampsToWaitNotMultipleOfAlignmentQuantumInScript                   = -200849;
  DAQmxErrorEveryNSamplesEventNotSupportedForNonBufferedTasks                     = -200848;
  DAQmxErrorBufferedAndDataXferPIO                                                = -200847;
  DAQmxErrorCannotWriteWhenAutoStartFalseAndTaskNotRunning                        = -200846;
  DAQmxErrorNonBufferedAndDataXferInterrupts                                      = -200845;
  DAQmxErrorWriteFailedMultipleCtrsWithFREQOUT                                    = -200844;
  DAQmxErrorReadNotCompleteBefore3SampClkEdges                                    = -200843;
  DAQmxErrorCtrHWTimedSinglePointAndDataXferNotProgIO                             = -200842;
  DAQmxErrorPrescalerNot1ForInputTerminal                                         = -200841;
  DAQmxErrorPrescalerNot1ForTimebaseSrc                                           = -200840;
  DAQmxErrorSampClkTimingTypeWhenTristateIsFalse                                  = -200839;
  DAQmxErrorOutputBufferSizeNotMultOfXferSize                                     = -200838;
  DAQmxErrorSampPerChanNotMultOfXferSize                                          = -200837;
  DAQmxErrorWriteToTEDSFailed                                                     = -200836;
  DAQmxErrorSCXIDevNotUsablePowerTurnedOff                                        = -200835;
  DAQmxErrorCannotReadWhenAutoStartFalseBufSizeZeroAndTaskNotRunning              = -200834;
  DAQmxErrorCannotReadWhenAutoStartFalseHWTimedSinglePtAndTaskNotRunning          = -200833;
  DAQmxErrorCannotReadWhenAutoStartFalseOnDemandAndTaskNotRunning                 = -200832;
  DAQmxErrorSimultaneousAOWhenNotOnDemandTiming                                   = -200831;
  DAQmxErrorMemMapAndSimultaneousAO                                               = -200830;
  DAQmxErrorWriteFailedMultipleCOOutputTypes                                      = -200829;
  DAQmxErrorWriteToTEDSNotSupportedOnRT                                           = -200828;
  DAQmxErrorVirtualTEDSDataFileError                                              = -200827;
  DAQmxErrorTEDSSensorDataError                                                   = -200826;
  DAQmxErrorDataSizeMoreThanSizeOfEEPROMOnTEDS                                    = -200825;
  DAQmxErrorPROMOnTEDSContainsBasicTEDSData                                       = -200824;
  DAQmxErrorPROMOnTEDSAlreadyWritten                                              = -200823;
  DAQmxErrorTEDSDoesNotContainPROM                                                = -200822;
  DAQmxErrorHWTimedSinglePointNotSupportedAI                                      = -200821;
  DAQmxErrorHWTimedSinglePointOddNumChansInAITask                                 = -200820;
  DAQmxErrorCantUseOnlyOnBoardMemWithProgrammedIO                                 = -200819;
  DAQmxErrorSwitchDevShutDownDueToHighTemp                                        = -200818;
  DAQmxErrorExcitationNotSupportedWhenTermCfgDiff                                 = -200817;
  DAQmxErrorTEDSMinElecValGEMaxElecVal                                            = -200816;
  DAQmxErrorTEDSMinPhysValGEMaxPhysVal                                            = -200815;
  DAQmxErrorCIOnboardClockNotSupportedAsInputTerm                                 = -200814;
  DAQmxErrorInvalidSampModeForPositionMeas                                        = -200813;
  DAQmxErrorTrigWhenAOHWTimedSinglePtSampMode                                     = -200812;
  DAQmxErrorDAQmxCantUseStringDueToUnknownChar                                    = -200811;
  DAQmxErrorDAQmxCantRetrieveStringDueToUnknownChar                               = -200810;
  DAQmxErrorClearTEDSNotSupportedOnRT                                             = -200809;
  DAQmxErrorCfgTEDSNotSupportedOnRT                                               = -200808;
  DAQmxErrorProgFilterClkCfgdToDifferentMinPulseWidthBySameTask1PerDev            = -200807;
  DAQmxErrorProgFilterClkCfgdToDifferentMinPulseWidthByAnotherTask1PerDev         = -200806;
  DAQmxErrorNoLastExtCalDateTimeLastExtCalNotDAQmx                                = -200804;
  DAQmxErrorCannotWriteNotStartedAutoStartFalseNotOnDemandHWTimedSglPt            = -200803;
  DAQmxErrorCannotWriteNotStartedAutoStartFalseNotOnDemandBufSizeZero             = -200802;
  DAQmxErrorCOInvalidTimingSrcDueToSignal                                         = -200801;
  DAQmxErrorCIInvalidTimingSrcForSampClkDueToSampTimingType                       = -200800;
  DAQmxErrorCIInvalidTimingSrcForEventCntDueToSampMode                            = -200799;
  DAQmxErrorNoChangeDetectOnNonInputDigLineForDev                                 = -200798;
  DAQmxErrorEmptyStringTermNameNotSupported                                       = -200797;
  DAQmxErrorMemMapEnabledForHWTimedNonBufferedAO                                  = -200796;
  DAQmxErrorDevOnboardMemOverflowDuringHWTimedNonBufferedGen                      = -200795;
  DAQmxErrorCODAQmxWriteMultipleChans                                             = -200794;
  DAQmxErrorCantMaintainExistingValueAOSync                                       = -200793;
  DAQmxErrorMStudioMultiplePhysChansNotSupported                                  = -200792;
  DAQmxErrorCantConfigureTEDSForChan                                              = -200791;
  DAQmxErrorWriteDataTypeTooSmall                                                 = -200790;
  DAQmxErrorReadDataTypeTooSmall                                                  = -200789;
  DAQmxErrorMeasuredBridgeOffsetTooHigh                                           = -200788;
  DAQmxErrorStartTrigConflictWithCOHWTimedSinglePt                                = -200787;
  DAQmxErrorSampClkRateExtSampClkTimebaseRateMismatch                             = -200786;
  DAQmxErrorInvalidTimingSrcDueToSampTimingType                                   = -200785;
  DAQmxErrorVirtualTEDSFileNotFound                                               = -200784;
  DAQmxErrorMStudioNoForwardPolyScaleCoeffs                                       = -200783;
  DAQmxErrorMStudioNoReversePolyScaleCoeffs                                       = -200782;
  DAQmxErrorMStudioNoPolyScaleCoeffsUseCalc                                       = -200781;
  DAQmxErrorMStudioNoForwardPolyScaleCoeffsUseCalc                                = -200780;
  DAQmxErrorMStudioNoReversePolyScaleCoeffsUseCalc                                = -200779;
  DAQmxErrorCOSampModeSampTimingTypeSampClkConflict                               = -200778;
  DAQmxErrorDevCannotProduceMinPulseWidth                                         = -200777;
  DAQmxErrorCannotProduceMinPulseWidthGivenPropertyValues                         = -200776;
  DAQmxErrorTermCfgdToDifferentMinPulseWidthByAnotherTask                         = -200775;
  DAQmxErrorTermCfgdToDifferentMinPulseWidthByAnotherProperty                     = -200774;
  DAQmxErrorDigSyncNotAvailableOnTerm                                             = -200773;
  DAQmxErrorDigFilterNotAvailableOnTerm                                           = -200772;
  DAQmxErrorDigFilterEnabledMinPulseWidthNotCfg                                   = -200771;
  DAQmxErrorDigFilterAndSyncBothEnabled                                           = -200770;
  DAQmxErrorHWTimedSinglePointAOAndDataXferNotProgIO                              = -200769;
  DAQmxErrorNonBufferedAOAndDataXferNotProgIO                                     = -200768;
  DAQmxErrorProgIODataXferForBufferedAO                                           = -200767;
  DAQmxErrorTEDSLegacyTemplateIDInvalidOrUnsupported                              = -200766;
  DAQmxErrorTEDSMappingMethodInvalidOrUnsupported                                 = -200765;
  DAQmxErrorTEDSLinearMappingSlopeZero                                            = -200764;
  DAQmxErrorAIInputBufferSizeNotMultOfXferSize                                    = -200763;
  DAQmxErrorNoSyncPulseExtSampClkTimebase                                         = -200762;
  DAQmxErrorNoSyncPulseAnotherTaskRunning                                         = -200761;
  DAQmxErrorAOMinMaxNotInGainRange                                                = -200760;
  DAQmxErrorAOMinMaxNotInDACRange                                                 = -200759;
  DAQmxErrorDevOnlySupportsSampClkTimingAO                                        = -200758;
  DAQmxErrorDevOnlySupportsSampClkTimingAI                                        = -200757;
  DAQmxErrorTEDSIncompatibleSensorAndMeasType                                     = -200756;
  DAQmxErrorTEDSMultipleCalTemplatesNotSupported                                  = -200755;
  DAQmxErrorTEDSTemplateParametersNotSupported                                    = -200754;
  DAQmxErrorParsingTEDSData                                                       = -200753;
  DAQmxErrorMultipleActivePhysChansNotSupported                                   = -200752;
  DAQmxErrorNoChansSpecdForChangeDetect                                           = -200751;
  DAQmxErrorInvalidCalVoltageForGivenGain                                         = -200750;
  DAQmxErrorInvalidCalGain                                                        = -200749;
  DAQmxErrorMultipleWritesBetweenSampClks                                         = -200748;
  DAQmxErrorInvalidAcqTypeForFREQOUT                                              = -200747;
  DAQmxErrorSuitableTimebaseNotFoundTimeCombo2                                    = -200746;
  DAQmxErrorSuitableTimebaseNotFoundFrequencyCombo2                               = -200745;
  DAQmxErrorRefClkRateRefClkSrcMismatch                                           = -200744;
  DAQmxErrorNoTEDSTerminalBlock                                                   = -200743;
  DAQmxErrorCorruptedTEDSMemory                                                   = -200742;
  DAQmxErrorTEDSNotSupported                                                      = -200741;
  DAQmxErrorTimingSrcTaskStartedBeforeTimedLoop                                   = -200740;
  DAQmxErrorPropertyNotSupportedForTimingSrc                                      = -200739;
  DAQmxErrorTimingSrcDoesNotExist                                                 = -200738;
  DAQmxErrorInputBufferSizeNotEqualSampsPerChanForFiniteSampMode                  = -200737;
  DAQmxErrorFREQOUTCannotProduceDesiredFrequency2                                 = -200736;
  DAQmxErrorExtRefClkRateNotSpecified                                             = -200735;
  DAQmxErrorDeviceDoesNotSupportDMADataXferForNonBufferedAcq                      = -200734;
  DAQmxErrorDigFilterMinPulseWidthSetWhenTristateIsFalse                          = -200733;
  DAQmxErrorDigFilterEnableSetWhenTristateIsFalse                                 = -200732;
  DAQmxErrorNoHWTimingWithOnDemand                                                = -200731;
  DAQmxErrorCannotDetectChangesWhenTristateIsFalse                                = -200730;
  DAQmxErrorCannotHandshakeWhenTristateIsFalse                                    = -200729;
  DAQmxErrorLinesUsedForStaticInputNotForHandshakingControl                       = -200728;
  DAQmxErrorLinesUsedForHandshakingControlNotForStaticInput                       = -200727;
  DAQmxErrorLinesUsedForStaticInputNotForHandshakingInput                         = -200726;
  DAQmxErrorLinesUsedForHandshakingInputNotForStaticInput                         = -200725;
  DAQmxErrorDifferentDITristateValsForChansInTask                                 = -200724;
  DAQmxErrorTimebaseCalFreqVarianceTooLarge                                       = -200723;
  DAQmxErrorTimebaseCalFailedToConverge                                           = -200722;
  DAQmxErrorInadequateResolutionForTimebaseCal                                    = -200721;
  DAQmxErrorInvalidAOGainCalConst                                                 = -200720;
  DAQmxErrorInvalidAOOffsetCalConst                                               = -200719;
  DAQmxErrorInvalidAIGainCalConst                                                 = -200718;
  DAQmxErrorInvalidAIOffsetCalConst                                               = -200717;
  DAQmxErrorDigOutputOverrun                                                      = -200716;
  DAQmxErrorDigInputOverrun                                                       = -200715;
  DAQmxErrorAcqStoppedDriverCantXferDataFastEnough                                = -200714;
  DAQmxErrorChansCantAppearInSameTask                                             = -200713;
  DAQmxErrorInputCfgFailedBecauseWatchdogExpired                                  = -200712;
  DAQmxErrorAnalogTrigChanNotExternal                                             = -200711;
  DAQmxErrorTooManyChansForInternalAIInputSrc                                     = -200710;
  DAQmxErrorTEDSSensorNotDetected                                                 = -200709;
  DAQmxErrorPrptyGetSpecdActiveItemFailedDueToDifftValues                         = -200708;
  DAQmxErrorRoutingDestTermPXIClk10InNotInSlot2                                   = -200706;
  DAQmxErrorRoutingDestTermPXIStarXNotInSlot2                                     = -200705;
  DAQmxErrorRoutingSrcTermPXIStarXNotInSlot2                                      = -200704;
  DAQmxErrorRoutingSrcTermPXIStarInSlot16AndAbove                                 = -200703;
  DAQmxErrorRoutingDestTermPXIStarInSlot16AndAbove                                = -200702;
  DAQmxErrorRoutingDestTermPXIStarInSlot2                                         = -200701;
  DAQmxErrorRoutingSrcTermPXIStarInSlot2                                          = -200700;
  DAQmxErrorRoutingDestTermPXIChassisNotIdentified                                = -200699;
  DAQmxErrorRoutingSrcTermPXIChassisNotIdentified                                 = -200698;
  DAQmxErrorFailedToAcquireCalData                                                = -200697;
  DAQmxErrorBridgeOffsetNullingCalNotSupported                                    = -200696;
  DAQmxErrorAIMaxNotSpecified                                                     = -200695;
  DAQmxErrorAIMinNotSpecified                                                     = -200694;
  DAQmxErrorOddTotalBufferSizeToWrite                                             = -200693;
  DAQmxErrorOddTotalNumSampsToWrite                                               = -200692;
  DAQmxErrorBufferWithWaitMode                                                    = -200691;
  DAQmxErrorBufferWithHWTimedSinglePointSampMode                                  = -200690;
  DAQmxErrorCOWritePulseLowTicksNotSupported                                      = -200689;
  DAQmxErrorCOWritePulseHighTicksNotSupported                                     = -200688;
  DAQmxErrorCOWritePulseLowTimeOutOfRange                                         = -200687;
  DAQmxErrorCOWritePulseHighTimeOutOfRange                                        = -200686;
  DAQmxErrorCOWriteFreqOutOfRange                                                 = -200685;
  DAQmxErrorCOWriteDutyCycleOutOfRange                                            = -200684;
  DAQmxErrorInvalidInstallation                                                   = -200683;
  DAQmxErrorRefTrigMasterSessionUnavailable                                       = -200682;
  DAQmxErrorRouteFailedBecauseWatchdogExpired                                     = -200681;
  DAQmxErrorDeviceShutDownDueToHighTemp                                           = -200680;
  DAQmxErrorNoMemMapWhenHWTimedSinglePoint                                        = -200679;
  DAQmxErrorWriteFailedBecauseWatchdogExpired                                     = -200678;
  DAQmxErrorDifftInternalAIInputSrcs                                              = -200677;
  DAQmxErrorDifftAIInputSrcInOneChanGroup                                         = -200676;
  DAQmxErrorInternalAIInputSrcInMultChanGroups                                    = -200675;
  DAQmxErrorSwitchOpFailedDueToPrevError                                          = -200674;
  DAQmxErrorWroteMultiSampsUsingSingleSampWrite                                   = -200673;
  DAQmxErrorMismatchedInputArraySizes                                             = -200672;
  DAQmxErrorCantExceedRelayDriveLimit                                             = -200671;
  DAQmxErrorDACRngLowNotEqualToMinusRefVal                                        = -200670;
  DAQmxErrorCantAllowConnectDACToGnd                                              = -200669;
  DAQmxErrorWatchdogTimeoutOutOfRangeAndNotSpecialVal                             = -200668;
  DAQmxErrorNoWatchdogOutputOnPortReservedForInput                                = -200667;
  DAQmxErrorNoInputOnPortCfgdForWatchdogOutput                                    = -200666;
  DAQmxErrorWatchdogExpirationStateNotEqualForLinesInPort                         = -200665;
  DAQmxErrorCannotPerformOpWhenTaskNotReserved                                    = -200664;
  DAQmxErrorPowerupStateNotSupported                                              = -200663;
  DAQmxErrorWatchdogTimerNotSupported                                             = -200662;
  DAQmxErrorOpNotSupportedWhenRefClkSrcNone                                       = -200661;
  DAQmxErrorSampClkRateUnavailable                                                = -200660;
  DAQmxErrorPrptyGetSpecdSingleActiveChanFailedDueToDifftVals                     = -200659;
  DAQmxErrorPrptyGetImpliedActiveChanFailedDueToDifftVals                         = -200658;
  DAQmxErrorPrptyGetSpecdActiveChanFailedDueToDifftVals                           = -200657;
  DAQmxErrorNoRegenWhenUsingBrdMem                                                = -200656;
  DAQmxErrorNonbufferedReadMoreThanSampsPerChan                                   = -200655;
  DAQmxErrorWatchdogExpirationTristateNotSpecdForEntirePort                       = -200654;
  DAQmxErrorPowerupTristateNotSpecdForEntirePort                                  = -200653;
  DAQmxErrorPowerupStateNotSpecdForEntirePort                                     = -200652;
  DAQmxErrorCantSetWatchdogExpirationOnDigInChan                                  = -200651;
  DAQmxErrorCantSetPowerupStateOnDigInChan                                        = -200650;
  DAQmxErrorPhysChanNotInTask                                                     = -200649;
  DAQmxErrorPhysChanDevNotInTask                                                  = -200648;
  DAQmxErrorDigInputNotSupported                                                  = -200647;
  DAQmxErrorDigFilterIntervalNotEqualForLines                                     = -200646;
  DAQmxErrorDigFilterIntervalAlreadyCfgd                                          = -200645;
  DAQmxErrorCantResetExpiredWatchdog                                              = -200644;
  DAQmxErrorActiveChanTooManyLinesSpecdWhenGettingPrpty                           = -200643;
  DAQmxErrorActiveChanNotSpecdWhenGetting1LinePrpty                               = -200642;
  DAQmxErrorDigPrptyCannotBeSetPerLine                                            = -200641;
  DAQmxErrorSendAdvCmpltAfterWaitForTrigInScanlist                                = -200640;
  DAQmxErrorDisconnectionRequiredInScanlist                                       = -200639;
  DAQmxErrorTwoWaitForTrigsAfterConnectionInScanlist                              = -200638;
  DAQmxErrorActionSeparatorRequiredAfterBreakingConnectionInScanlist              = -200637;
  DAQmxErrorConnectionInScanlistMustWaitForTrig                                   = -200636;
  DAQmxErrorActionNotSupportedTaskNotWatchdog                                     = -200635;
  DAQmxErrorWfmNameSameAsScriptName                                               = -200634;
  DAQmxErrorScriptNameSameAsWfmName                                               = -200633;
  DAQmxErrorDSFStopClock                                                          = -200632;
  DAQmxErrorDSFReadyForStartClock                                                 = -200631;
  DAQmxErrorWriteOffsetNotMultOfIncr                                              = -200630;
  DAQmxErrorDifferentPrptyValsNotSupportedOnDev                                   = -200629;
  DAQmxErrorRefAndPauseTrigConfigured                                             = -200628;
  DAQmxErrorFailedToEnableHighSpeedInputClock                                     = -200627;
  DAQmxErrorEmptyPhysChanInPowerUpStatesArray                                     = -200626;
  DAQmxErrorActivePhysChanTooManyLinesSpecdWhenGettingPrpty                       = -200625;
  DAQmxErrorActivePhysChanNotSpecdWhenGetting1LinePrpty                           = -200624;
  DAQmxErrorPXIDevTempCausedShutDown                                              = -200623;
  DAQmxErrorInvalidNumSampsToWrite                                                = -200622;
  DAQmxErrorOutputFIFOUnderflow2                                                  = -200621;
  DAQmxErrorRepeatedAIPhysicalChan                                                = -200620;
  DAQmxErrorMultScanOpsInOneChassis                                               = -200619;
  DAQmxErrorInvalidAIChanOrder                                                    = -200618;
  DAQmxErrorReversePowerProtectionActivated                                       = -200617;
  DAQmxErrorInvalidAsynOpHandle                                                   = -200616;
  DAQmxErrorFailedToEnableHighSpeedOutput                                         = -200615;
  DAQmxErrorCannotReadPastEndOfRecord                                             = -200614;
  DAQmxErrorAcqStoppedToPreventInputBufferOverwriteOneDataXferMech                = -200613;
  DAQmxErrorZeroBasedChanIndexInvalid                                             = -200612;
  DAQmxErrorNoChansOfGivenTypeInTask                                              = -200611;
  DAQmxErrorSampClkSrcInvalidForOutputValidForInput                               = -200610;
  DAQmxErrorOutputBufSizeTooSmallToStartGen                                       = -200609;
  DAQmxErrorInputBufSizeTooSmallToStartAcq                                        = -200608;
  DAQmxErrorExportTwoSignalsOnSameTerminal                                        = -200607;
  DAQmxErrorChanIndexInvalid                                                      = -200606;
  DAQmxErrorRangeSyntaxNumberTooBig                                               = -200605;
  DAQmxErrorNULLPtr                                                               = -200604;
  DAQmxErrorScaledMinEqualMax                                                     = -200603;
  DAQmxErrorPreScaledMinEqualMax                                                  = -200602;
  DAQmxErrorPropertyNotSupportedForScaleType                                      = -200601;
  DAQmxErrorChannelNameGenerationNumberTooBig                                     = -200600;
  DAQmxErrorRepeatedNumberInScaledValues                                          = -200599;
  DAQmxErrorRepeatedNumberInPreScaledValues                                       = -200598;
  DAQmxErrorLinesAlreadyReservedForOutput                                         = -200597;
  DAQmxErrorSwitchOperationChansSpanMultipleDevsInList                            = -200596;
  DAQmxErrorInvalidIDInListAtBeginningOfSwitchOperation                           = -200595;
  DAQmxErrorMStudioInvalidPolyDirection                                           = -200594;
  DAQmxErrorMStudioPropertyGetWhileTaskNotVerified                                = -200593;
  DAQmxErrorRangeWithTooManyObjects                                               = -200592;
  DAQmxErrorCppDotNetAPINegativeBufferSize                                        = -200591;
  DAQmxErrorCppCantRemoveInvalidEventHandler                                      = -200590;
  DAQmxErrorCppCantRemoveEventHandlerTwice                                        = -200589;
  DAQmxErrorCppCantRemoveOtherObjectsEventHandler                                 = -200588;
  DAQmxErrorDigLinesReservedOrUnavailable                                         = -200587;
  DAQmxErrorDSFFailedToResetStream                                                = -200586;
  DAQmxErrorDSFReadyForOutputNotAsserted                                          = -200585;
  DAQmxErrorSampToWritePerChanNotMultipleOfIncr                                   = -200584;
  DAQmxErrorAOPropertiesCauseVoltageBelowMin                                      = -200583;
  DAQmxErrorAOPropertiesCauseVoltageOverMax                                       = -200582;
  DAQmxErrorPropertyNotSupportedWhenRefClkSrcNone                                 = -200581;
  DAQmxErrorAIMaxTooSmall                                                         = -200580;
  DAQmxErrorAIMaxTooLarge                                                         = -200579;
  DAQmxErrorAIMinTooSmall                                                         = -200578;
  DAQmxErrorAIMinTooLarge                                                         = -200577;
  DAQmxErrorBuiltInCJCSrcNotSupported                                             = -200576;
  DAQmxErrorTooManyPostTrigSampsPerChan                                           = -200575;
  DAQmxErrorTrigLineNotFoundSingleDevRoute                                        = -200574;
  DAQmxErrorDifferentInternalAIInputSources                                       = -200573;
  DAQmxErrorDifferentAIInputSrcInOneChanGroup                                     = -200572;
  DAQmxErrorInternalAIInputSrcInMultipleChanGroups                                = -200571;
  DAQmxErrorCAPIChanIndexInvalid                                                  = -200570;
  DAQmxErrorCollectionDoesNotMatchChanType                                        = -200569;
  DAQmxErrorOutputCantStartChangedRegenerationMode                                = -200568;
  DAQmxErrorOutputCantStartChangedBufferSize                                      = -200567;
  DAQmxErrorChanSizeTooBigForU32PortWrite                                         = -200566;
  DAQmxErrorChanSizeTooBigForU8PortWrite                                          = -200565;
  DAQmxErrorChanSizeTooBigForU32PortRead                                          = -200564;
  DAQmxErrorChanSizeTooBigForU8PortRead                                           = -200563;
  DAQmxErrorInvalidDigDataWrite                                                   = -200562;
  DAQmxErrorInvalidAODataWrite                                                    = -200561;
  DAQmxErrorWaitUntilDoneDoesNotIndicateDone                                      = -200560;
  DAQmxErrorMultiChanTypesInTask                                                  = -200559;
  DAQmxErrorMultiDevsInTask                                                       = -200558;
  DAQmxErrorCannotSetPropertyWhenTaskRunning                                      = -200557;
  DAQmxErrorCannotGetPropertyWhenTaskNotCommittedOrRunning                        = -200556;
  DAQmxErrorLeadingUnderscoreInString                                             = -200555;
  DAQmxErrorTrailingSpaceInString                                                 = -200554;
  DAQmxErrorLeadingSpaceInString                                                  = -200553;
  DAQmxErrorInvalidCharInString                                                   = -200552;
  DAQmxErrorDLLBecameUnlocked                                                     = -200551;
  DAQmxErrorDLLLock                                                               = -200550;
  DAQmxErrorSelfCalConstsInvalid                                                  = -200549;
  DAQmxErrorInvalidTrigCouplingExceptForExtTrigChan                               = -200548;
  DAQmxErrorWriteFailsBufferSizeAutoConfigured                                    = -200547;
  DAQmxErrorExtCalAdjustExtRefVoltageFailed                                       = -200546;
  DAQmxErrorSelfCalFailedExtNoiseOrRefVoltageOutOfCal                             = -200545;
  DAQmxErrorExtCalTemperatureNotDAQmx                                             = -200544;
  DAQmxErrorExtCalDateTimeNotDAQmx                                                = -200543;
  DAQmxErrorSelfCalTemperatureNotDAQmx                                            = -200542;
  DAQmxErrorSelfCalDateTimeNotDAQmx                                               = -200541;
  DAQmxErrorDACRefValNotSet                                                       = -200540;
  DAQmxErrorAnalogMultiSampWriteNotSupported                                      = -200539;
  DAQmxErrorInvalidActionInControlTask                                            = -200538;
  DAQmxErrorPolyCoeffsInconsistent                                                = -200537;
  DAQmxErrorSensorValTooLow                                                       = -200536;
  DAQmxErrorSensorValTooHigh                                                      = -200535;
  DAQmxErrorWaveformNameTooLong                                                   = -200534;
  DAQmxErrorIdentifierTooLongInScript                                             = -200533;
  DAQmxErrorUnexpectedIDFollowingSwitchChanName                                   = -200532;
  DAQmxErrorRelayNameNotSpecifiedInList                                           = -200531;
  DAQmxErrorUnexpectedIDFollowingRelayNameInList                                  = -200530;
  DAQmxErrorUnexpectedIDFollowingSwitchOpInList                                   = -200529;
  DAQmxErrorInvalidLineGrouping                                                   = -200528;
  DAQmxErrorCtrMinMax                                                             = -200527;
  DAQmxErrorWriteChanTypeMismatch                                                 = -200526;
  DAQmxErrorReadChanTypeMismatch                                                  = -200525;
  DAQmxErrorWriteNumChansMismatch                                                 = -200524;
  DAQmxErrorOneChanReadForMultiChanTask                                           = -200523;
  DAQmxErrorCannotSelfCalDuringExtCal                                             = -200522;
  DAQmxErrorMeasCalAdjustOscillatorPhaseDAC                                       = -200521;
  DAQmxErrorInvalidCalConstCalADCAdjustment                                       = -200520;
  DAQmxErrorInvalidCalConstOscillatorFreqDACValue                                 = -200519;
  DAQmxErrorInvalidCalConstOscillatorPhaseDACValue                                = -200518;
  DAQmxErrorInvalidCalConstOffsetDACValue                                         = -200517;
  DAQmxErrorInvalidCalConstGainDACValue                                           = -200516;
  DAQmxErrorInvalidNumCalADCReadsToAverage                                        = -200515;
  DAQmxErrorInvalidCfgCalAdjustDirectPathOutputImpedance                          = -200514;
  DAQmxErrorInvalidCfgCalAdjustMainPathOutputImpedance                            = -200513;
  DAQmxErrorInvalidCfgCalAdjustMainPathPostAmpGainAndOffset                       = -200512;
  DAQmxErrorInvalidCfgCalAdjustMainPathPreAmpGain                                 = -200511;
  DAQmxErrorInvalidCfgCalAdjustMainPreAmpOffset                                   = -200510;
  DAQmxErrorMeasCalAdjustCalADC                                                   = -200509;
  DAQmxErrorMeasCalAdjustOscillatorFrequency                                      = -200508;
  DAQmxErrorMeasCalAdjustDirectPathOutputImpedance                                = -200507;
  DAQmxErrorMeasCalAdjustMainPathOutputImpedance                                  = -200506;
  DAQmxErrorMeasCalAdjustDirectPathGain                                           = -200505;
  DAQmxErrorMeasCalAdjustMainPathPostAmpGainAndOffset                             = -200504;
  DAQmxErrorMeasCalAdjustMainPathPreAmpGain                                       = -200503;
  DAQmxErrorMeasCalAdjustMainPathPreAmpOffset                                     = -200502;
  DAQmxErrorInvalidDateTimeInEEPROM                                               = -200501;
  DAQmxErrorUnableToLocateErrorResources                                          = -200500;
  DAQmxErrorDotNetAPINotUnsigned32BitNumber                                       = -200499;
  DAQmxErrorInvalidRangeOfObjectsSyntaxInString                                   = -200498;
  DAQmxErrorAttemptToEnableLineNotPreviouslyDisabled                              = -200497;
  DAQmxErrorInvalidCharInPattern                                                  = -200496;
  DAQmxErrorIntermediateBufferFull                                                = -200495;
  DAQmxErrorLoadTaskFailsBecauseNoTimingOnDev                                     = -200494;
  DAQmxErrorCAPIReservedParamNotNULLNorEmpty                                      = -200493;
  DAQmxErrorCAPIReservedParamNotNULL                                              = -200492;
  DAQmxErrorCAPIReservedParamNotZero                                              = -200491;
  DAQmxErrorSampleValueOutOfRange                                                 = -200490;
  DAQmxErrorChanAlreadyInTask                                                     = -200489;
  DAQmxErrorVirtualChanDoesNotExist                                               = -200488;
  DAQmxErrorChanNotInTask                                                         = -200486;
  DAQmxErrorTaskNotInDataNeighborhood                                             = -200485;
  DAQmxErrorCantSaveTaskWithoutReplace                                            = -200484;
  DAQmxErrorCantSaveChanWithoutReplace                                            = -200483;
  DAQmxErrorDevNotInTask                                                          = -200482;
  DAQmxErrorDevAlreadyInTask                                                      = -200481;
  DAQmxErrorCanNotPerformOpWhileTaskRunning                                       = -200479;
  DAQmxErrorCanNotPerformOpWhenNoChansInTask                                      = -200478;
  DAQmxErrorCanNotPerformOpWhenNoDevInTask                                        = -200477;
  DAQmxErrorCannotPerformOpWhenTaskNotRunning                                     = -200475;
  DAQmxErrorOperationTimedOut                                                     = -200474;
  DAQmxErrorCannotReadWhenAutoStartFalseAndTaskNotRunningOrCommitted              = -200473;
  DAQmxErrorCannotWriteWhenAutoStartFalseAndTaskNotRunningOrCommitted             = -200472;
  DAQmxErrorTaskVersionNew                                                        = -200470;
  DAQmxErrorChanVersionNew                                                        = -200469;
  DAQmxErrorEmptyString                                                           = -200467;
  DAQmxErrorChannelSizeTooBigForPortReadType                                      = -200466;
  DAQmxErrorChannelSizeTooBigForPortWriteType                                     = -200465;
  DAQmxErrorExpectedNumberOfChannelsVerificationFailed                            = -200464;
  DAQmxErrorNumLinesMismatchInReadOrWrite                                         = -200463;
  DAQmxErrorOutputBufferEmpty                                                     = -200462;
  DAQmxErrorInvalidChanName                                                       = -200461;
  DAQmxErrorReadNoInputChansInTask                                                = -200460;
  DAQmxErrorWriteNoOutputChansInTask                                              = -200459;
  DAQmxErrorPropertyNotSupportedNotInputTask                                      = -200457;
  DAQmxErrorPropertyNotSupportedNotOutputTask                                     = -200456;
  DAQmxErrorGetPropertyNotInputBufferedTask                                       = -200455;
  DAQmxErrorGetPropertyNotOutputBufferedTask                                      = -200454;
  DAQmxErrorInvalidTimeoutVal                                                     = -200453;
  DAQmxErrorAttributeNotSupportedInTaskContext                                    = -200452;
  DAQmxErrorAttributeNotQueryableUnlessTaskIsCommitted                            = -200451;
  DAQmxErrorAttributeNotSettableWhenTaskIsRunning                                 = -200450;
  DAQmxErrorDACRngLowNotMinusRefValNorZero                                        = -200449;
  DAQmxErrorDACRngHighNotEqualRefVal                                              = -200448;
  DAQmxErrorUnitsNotFromCustomScale                                               = -200447;
  DAQmxErrorInvalidVoltageReadingDuringExtCal                                     = -200446;
  DAQmxErrorCalFunctionNotSupported                                               = -200445;
  DAQmxErrorInvalidPhysicalChanForCal                                             = -200444;
  DAQmxErrorExtCalNotComplete                                                     = -200443;
  DAQmxErrorCantSyncToExtStimulusFreqDuringCal                                    = -200442;
  DAQmxErrorUnableToDetectExtStimulusFreqDuringCal                                = -200441;
  DAQmxErrorInvalidCloseAction                                                    = -200440;
  DAQmxErrorExtCalFunctionOutsideExtCalSession                                    = -200439;
  DAQmxErrorInvalidCalArea                                                        = -200438;
  DAQmxErrorExtCalConstsInvalid                                                   = -200437;
  DAQmxErrorStartTrigDelayWithExtSampClk                                          = -200436;
  DAQmxErrorDelayFromSampClkWithExtConv                                           = -200435;
  DAQmxErrorFewerThan2PreScaledVals                                               = -200434;
  DAQmxErrorFewerThan2ScaledValues                                                = -200433;
  DAQmxErrorPhysChanOutputType                                                    = -200432;
  DAQmxErrorPhysChanMeasType                                                      = -200431;
  DAQmxErrorInvalidPhysChanType                                                   = -200430;
  DAQmxErrorLabVIEWEmptyTaskOrChans                                               = -200429;
  DAQmxErrorLabVIEWInvalidTaskOrChans                                             = -200428;
  DAQmxErrorInvalidRefClkRate                                                     = -200427;
  DAQmxErrorInvalidExtTrigImpedance                                               = -200426;
  DAQmxErrorHystTrigLevelAIMax                                                    = -200425;
  DAQmxErrorLineNumIncompatibleWithVideoSignalFormat                              = -200424;
  DAQmxErrorTrigWindowAIMinAIMaxCombo                                             = -200423;
  DAQmxErrorTrigAIMinAIMax                                                        = -200422;
  DAQmxErrorHystTrigLevelAIMin                                                    = -200421;
  DAQmxErrorInvalidSampRateConsiderRIS                                            = -200420;
  DAQmxErrorInvalidReadPosDuringRIS                                               = -200419;
  DAQmxErrorImmedTrigDuringRISMode                                                = -200418;
  DAQmxErrorTDCNotEnabledDuringRISMode                                            = -200417;
  DAQmxErrorMultiRecWithRIS                                                       = -200416;
  DAQmxErrorInvalidRefClkSrc                                                      = -200415;
  DAQmxErrorInvalidSampClkSrc                                                     = -200414;
  DAQmxErrorInsufficientOnBoardMemForNumRecsAndSamps                              = -200413;
  DAQmxErrorInvalidAIAttenuation                                                  = -200412;
  DAQmxErrorACCouplingNotAllowedWith50OhmImpedance                                = -200411;
  DAQmxErrorInvalidRecordNum                                                      = -200410;
  DAQmxErrorZeroSlopeLinearScale                                                  = -200409;
  DAQmxErrorZeroReversePolyScaleCoeffs                                            = -200408;
  DAQmxErrorZeroForwardPolyScaleCoeffs                                            = -200407;
  DAQmxErrorNoReversePolyScaleCoeffs                                              = -200406;
  DAQmxErrorNoForwardPolyScaleCoeffs                                              = -200405;
  DAQmxErrorNoPolyScaleCoeffs                                                     = -200404;
  DAQmxErrorReversePolyOrderLessThanNumPtsToCompute                               = -200403;
  DAQmxErrorReversePolyOrderNotPositive                                           = -200402;
  DAQmxErrorNumPtsToComputeNotPositive                                            = -200401;
  DAQmxErrorWaveformLengthNotMultipleOfIncr                                       = -200400;
  DAQmxErrorCAPINoExtendedErrorInfoAvailable                                      = -200399;
  DAQmxErrorCVIFunctionNotFoundInDAQmxDLL                                         = -200398;
  DAQmxErrorCVIFailedToLoadDAQmxDLL                                               = -200397;
  DAQmxErrorNoCommonTrigLineForImmedRoute                                         = -200396;
  DAQmxErrorNoCommonTrigLineForTaskRoute                                          = -200395;
  DAQmxErrorF64PrptyValNotUnsignedInt                                             = -200394;
  DAQmxErrorRegisterNotWritable                                                   = -200393;
  DAQmxErrorInvalidOutputVoltageAtSampClkRate                                     = -200392;
  DAQmxErrorStrobePhaseShiftDCMBecameUnlocked                                     = -200391;
  DAQmxErrorDrivePhaseShiftDCMBecameUnlocked                                      = -200390;
  DAQmxErrorClkOutPhaseShiftDCMBecameUnlocked                                     = -200389;
  DAQmxErrorOutputBoardClkDCMBecameUnlocked                                       = -200388;
  DAQmxErrorInputBoardClkDCMBecameUnlocked                                        = -200387;
  DAQmxErrorInternalClkDCMBecameUnlocked                                          = -200386;
  DAQmxErrorDCMLock                                                               = -200385;
  DAQmxErrorDataLineReservedForDynamicOutput                                      = -200384;
  DAQmxErrorInvalidRefClkSrcGivenSampClkSrc                                       = -200383;
  DAQmxErrorNoPatternMatcherAvailable                                             = -200382;
  DAQmxErrorInvalidDelaySampRateBelowPhaseShiftDCMThresh                          = -200381;
  DAQmxErrorStrainGageCalibration                                                 = -200380;
  DAQmxErrorInvalidExtClockFreqAndDivCombo                                        = -200379;
  DAQmxErrorCustomScaleDoesNotExist                                               = -200378;
  DAQmxErrorOnlyFrontEndChanOpsDuringScan                                         = -200377;
  DAQmxErrorInvalidOptionForDigitalPortChannel                                    = -200376;
  DAQmxErrorUnsupportedSignalTypeExportSignal                                     = -200375;
  DAQmxErrorInvalidSignalTypeExportSignal                                         = -200374;
  DAQmxErrorUnsupportedTrigTypeSendsSWTrig                                        = -200373;
  DAQmxErrorInvalidTrigTypeSendsSWTrig                                            = -200372;
  DAQmxErrorRepeatedPhysicalChan                                                  = -200371;
  DAQmxErrorResourcesInUseForRouteInTask                                          = -200370;
  DAQmxErrorResourcesInUseForRoute                                                = -200369;
  DAQmxErrorRouteNotSupportedByHW                                                 = -200368;
  DAQmxErrorResourcesInUseForExportSignalPolarity                                 = -200367;
  DAQmxErrorResourcesInUseForInversionInTask                                      = -200366;
  DAQmxErrorResourcesInUseForInversion                                            = -200365;
  DAQmxErrorExportSignalPolarityNotSupportedByHW                                  = -200364;
  DAQmxErrorInversionNotSupportedByHW                                             = -200363;
  DAQmxErrorOverloadedChansExistNotRead                                           = -200362;
  DAQmxErrorInputFIFOOverflow2                                                    = -200361;
  DAQmxErrorCJCChanNotSpecd                                                       = -200360;
  DAQmxErrorCtrExportSignalNotPossible                                            = -200359;
  DAQmxErrorRefTrigWhenContinuous                                                 = -200358;
  DAQmxErrorIncompatibleSensorOutputAndDeviceInputRanges                          = -200357;
  DAQmxErrorCustomScaleNameUsed                                                   = -200356;
  DAQmxErrorPropertyValNotSupportedByHW                                           = -200355;
  DAQmxErrorPropertyValNotValidTermName                                           = -200354;
  DAQmxErrorResourcesInUseForProperty                                             = -200353;
  DAQmxErrorCJCChanAlreadyUsed                                                    = -200352;
  DAQmxErrorForwardPolynomialCoefNotSpecd                                         = -200351;
  DAQmxErrorTableScaleNumPreScaledAndScaledValsNotEqual                           = -200350;
  DAQmxErrorTableScalePreScaledValsNotSpecd                                       = -200349;
  DAQmxErrorTableScaleScaledValsNotSpecd                                          = -200348;
  DAQmxErrorIntermediateBufferSizeNotMultipleOfIncr                               = -200347;
  DAQmxErrorEventPulseWidthOutOfRange                                             = -200346;
  DAQmxErrorEventDelayOutOfRange                                                  = -200345;
  DAQmxErrorSampPerChanNotMultipleOfIncr                                          = -200344;
  DAQmxErrorCannotCalculateNumSampsTaskNotStarted                                 = -200343;
  DAQmxErrorScriptNotInMem                                                        = -200342;
  DAQmxErrorOnboardMemTooSmall                                                    = -200341;
  DAQmxErrorReadAllAvailableDataWithoutBuffer                                     = -200340;
  DAQmxErrorPulseActiveAtStart                                                    = -200339;
  DAQmxErrorCalTempNotSupported                                                   = -200338;
  DAQmxErrorDelayFromSampClkTooLong                                               = -200337;
  DAQmxErrorDelayFromSampClkTooShort                                              = -200336;
  DAQmxErrorAIConvRateTooHigh                                                     = -200335;
  DAQmxErrorDelayFromStartTrigTooLong                                             = -200334;
  DAQmxErrorDelayFromStartTrigTooShort                                            = -200333;
  DAQmxErrorSampRateTooHigh                                                       = -200332;
  DAQmxErrorSampRateTooLow                                                        = -200331;
  DAQmxErrorPFI0UsedForAnalogAndDigitalSrc                                        = -200330;
  DAQmxErrorPrimingCfgFIFO                                                        = -200329;
  DAQmxErrorCannotOpenTopologyCfgFile                                             = -200328;
  DAQmxErrorInvalidDTInsideWfmDataType                                            = -200327;
  DAQmxErrorRouteSrcAndDestSame                                                   = -200326;
  DAQmxErrorReversePolynomialCoefNotSpecd                                         = -200325;
  DAQmxErrorDevAbsentOrUnavailable                                                = -200324;
  DAQmxErrorNoAdvTrigForMultiDevScan                                              = -200323;
  DAQmxErrorInterruptsInsufficientDataXferMech                                    = -200322;
  DAQmxErrorInvalidAttentuationBasedOnMinMax                                      = -200321;
  DAQmxErrorCabledModuleCannotRouteSSH                                            = -200320;
  DAQmxErrorCabledModuleCannotRouteConvClk                                        = -200319;
  DAQmxErrorInvalidExcitValForScaling                                             = -200318;
  DAQmxErrorNoDevMemForScript                                                     = -200317;
  DAQmxErrorScriptDataUnderflow                                                   = -200316;
  DAQmxErrorNoDevMemForWaveform                                                   = -200315;
  DAQmxErrorStreamDCMBecameUnlocked                                               = -200314;
  DAQmxErrorStreamDCMLock                                                         = -200313;
  DAQmxErrorWaveformNotInMem                                                      = -200312;
  DAQmxErrorWaveformWriteOutOfBounds                                              = -200311;
  DAQmxErrorWaveformPreviouslyAllocated                                           = -200310;
  DAQmxErrorSampClkTbMasterTbDivNotAppropriateForSampTbSrc                        = -200309;
  DAQmxErrorSampTbRateSampTbSrcMismatch                                           = -200308;
  DAQmxErrorMasterTbRateMasterTbSrcMismatch                                       = -200307;
  DAQmxErrorSampsPerChanTooBig                                                    = -200306;
  DAQmxErrorFinitePulseTrainNotPossible                                           = -200305;
  DAQmxErrorExtMasterTimebaseRateNotSpecified                                     = -200304;
  DAQmxErrorExtSampClkSrcNotSpecified                                             = -200303;
  DAQmxErrorInputSignalSlowerThanMeasTime                                         = -200302;
  DAQmxErrorCannotUpdatePulseGenProperty                                          = -200301;
  DAQmxErrorInvalidTimingType                                                     = -200300;
  DAQmxErrorPropertyUnavailWhenUsingOnboardMemory                                 = -200297;
  DAQmxErrorCannotWriteAfterStartWithOnboardMemory                                = -200295;
  DAQmxErrorNotEnoughSampsWrittenForInitialXferRqstCondition                      = -200294;
  DAQmxErrorNoMoreSpace                                                           = -200293;
  DAQmxErrorSamplesCanNotYetBeWritten                                             = -200292;
  DAQmxErrorGenStoppedToPreventIntermediateBufferRegenOfOldSamples                = -200291;
  DAQmxErrorGenStoppedToPreventRegenOfOldSamples                                  = -200290;
  DAQmxErrorSamplesNoLongerWriteable                                              = -200289;
  DAQmxErrorSamplesWillNeverBeGenerated                                           = -200288;
  DAQmxErrorNegativeWriteSampleNumber                                             = -200287;
  DAQmxErrorNoAcqStarted                                                          = -200286;
  DAQmxErrorSamplesNotYetAvailable                                                = -200284;
  DAQmxErrorAcqStoppedToPreventIntermediateBufferOverflow                         = -200283;
  DAQmxErrorNoRefTrigConfigured                                                   = -200282;
  DAQmxErrorCannotReadRelativeToRefTrigUntilDone                                  = -200281;
  DAQmxErrorSamplesNoLongerAvailable                                              = -200279;
  DAQmxErrorSamplesWillNeverBeAvailable                                           = -200278;
  DAQmxErrorNegativeReadSampleNumber                                              = -200277;
  DAQmxErrorExternalSampClkAndRefClkThruSameTerm                                  = -200276;
  DAQmxErrorExtSampClkRateTooLowForClkIn                                          = -200275;
  DAQmxErrorExtSampClkRateTooHighForBackplane                                     = -200274;
  DAQmxErrorSampClkRateAndDivCombo                                                = -200273;
  DAQmxErrorSampClkRateTooLowForDivDown                                           = -200272;
  DAQmxErrorProductOfAOMinAndGainTooSmall                                         = -200271;
  DAQmxErrorInterpolationRateNotPossible                                          = -200270;
  DAQmxErrorOffsetTooLarge                                                        = -200269;
  DAQmxErrorOffsetTooSmall                                                        = -200268;
  DAQmxErrorProductOfAOMaxAndGainTooLarge                                         = -200267;
  DAQmxErrorMinAndMaxNotSymmetric                                                 = -200266;
  DAQmxErrorInvalidAnalogTrigSrc                                                  = -200265;
  DAQmxErrorTooManyChansForAnalogRefTrig                                          = -200264;
  DAQmxErrorTooManyChansForAnalogPauseTrig                                        = -200263;
  DAQmxErrorTrigWhenOnDemandSampTiming                                            = -200262;
  DAQmxErrorInconsistentAnalogTrigSettings                                        = -200261;
  DAQmxErrorMemMapDataXferModeSampTimingCombo                                     = -200260;
  DAQmxErrorInvalidJumperedAttr                                                   = -200259;
  DAQmxErrorInvalidGainBasedOnMinMax                                              = -200258;
  DAQmxErrorInconsistentExcit                                                     = -200257;
  DAQmxErrorTopologyNotSupportedByCfgTermBlock                                    = -200256;
  DAQmxErrorBuiltInTempSensorNotSupported                                         = -200255;
  DAQmxErrorInvalidTerm                                                           = -200254;
  DAQmxErrorCannotTristateTerm                                                    = -200253;
  DAQmxErrorCannotTristateBusyTerm                                                = -200252;
  DAQmxErrorNoDMAChansAvailable                                                   = -200251;
  DAQmxErrorInvalidWaveformLengthWithinLoopInScript                               = -200250;
  DAQmxErrorInvalidSubsetLengthWithinLoopInScript                                 = -200249;
  DAQmxErrorMarkerPosInvalidForLoopInScript                                       = -200248;
  DAQmxErrorIntegerExpectedInScript                                               = -200247;
  DAQmxErrorPLLBecameUnlocked                                                     = -200246;
  DAQmxErrorPLLLock                                                               = -200245;
  DAQmxErrorDDCClkOutDCMBecameUnlocked                                            = -200244;
  DAQmxErrorDDCClkOutDCMLock                                                      = -200243;
  DAQmxErrorClkDoublerDCMBecameUnlocked                                           = -200242;
  DAQmxErrorClkDoublerDCMLock                                                     = -200241;
  DAQmxErrorSampClkDCMBecameUnlocked                                              = -200240;
  DAQmxErrorSampClkDCMLock                                                        = -200239;
  DAQmxErrorSampClkTimebaseDCMBecameUnlocked                                      = -200238;
  DAQmxErrorSampClkTimebaseDCMLock                                                = -200237;
  DAQmxErrorAttrCannotBeReset                                                     = -200236;
  DAQmxErrorExplanationNotFound                                                   = -200235;
  DAQmxErrorWriteBufferTooSmall                                                   = -200234;
  DAQmxErrorSpecifiedAttrNotValid                                                 = -200233;
  DAQmxErrorAttrCannotBeRead                                                      = -200232;
  DAQmxErrorAttrCannotBeSet                                                       = -200231;
  DAQmxErrorNULLPtrForC_Api                                                       = -200230;
  DAQmxErrorReadBufferTooSmall                                                    = -200229;
  DAQmxErrorBufferTooSmallForString                                               = -200228;
  DAQmxErrorNoAvailTrigLinesOnDevice                                              = -200227;
  DAQmxErrorTrigBusLineNotAvail                                                   = -200226;
  DAQmxErrorCouldNotReserveRequestedTrigLine                                      = -200225;
  DAQmxErrorTrigLineNotFound                                                      = -200224;
  DAQmxErrorSCXI1126ThreshHystCombination                                         = -200223;
  DAQmxErrorAcqStoppedToPreventInputBufferOverwrite                               = -200222;
  DAQmxErrorTimeoutExceeded                                                       = -200221;
  DAQmxErrorInvalidDeviceID                                                       = -200220;
  DAQmxErrorInvalidAOChanOrder                                                    = -200219;
  DAQmxErrorSampleTimingTypeAndDataXferMode                                       = -200218;
  DAQmxErrorBufferWithOnDemandSampTiming                                          = -200217;
  DAQmxErrorBufferAndDataXferMode                                                 = -200216;
  DAQmxErrorMemMapAndBuffer                                                       = -200215;
  DAQmxErrorNoAnalogTrigHW                                                        = -200214;
  DAQmxErrorTooManyPretrigPlusMinPostTrigSamps                                    = -200213;
  DAQmxErrorInconsistentUnitsSpecified                                            = -200212;
  DAQmxErrorMultipleRelaysForSingleRelayOp                                        = -200211;
  DAQmxErrorMultipleDevIDsPerChassisSpecifiedInList                               = -200210;
  DAQmxErrorDuplicateDevIDInList                                                  = -200209;
  DAQmxErrorInvalidRangeStatementCharInList                                       = -200208;
  DAQmxErrorInvalidDeviceIDInList                                                 = -200207;
  DAQmxErrorTriggerPolarityConflict                                               = -200206;
  DAQmxErrorCannotScanWithCurrentTopology                                         = -200205;
  DAQmxErrorUnexpectedIdentifierInFullySpecifiedPathInList                        = -200204;
  DAQmxErrorSwitchCannotDriveMultipleTrigLines                                    = -200203;
  DAQmxErrorInvalidRelayName                                                      = -200202;
  DAQmxErrorSwitchScanlistTooBig                                                  = -200201;
  DAQmxErrorSwitchChanInUse                                                       = -200200;
  DAQmxErrorSwitchNotResetBeforeScan                                              = -200199;
  DAQmxErrorInvalidTopology                                                       = -200198;
  DAQmxErrorAttrNotSupported                                                      = -200197;
  DAQmxErrorUnexpectedEndOfActionsInList                                          = -200196;
  DAQmxErrorPowerBudgetExceeded                                                   = -200195;
  DAQmxErrorHWUnexpectedlyPoweredOffAndOn                                         = -200194;
  DAQmxErrorSwitchOperationNotSupported                                           = -200193;
  DAQmxErrorOnlyContinuousScanSupported                                           = -200192;
  DAQmxErrorSwitchDifferentTopologyWhenScanning                                   = -200191;
  DAQmxErrorDisconnectPathNotSameAsExistingPath                                   = -200190;
  DAQmxErrorConnectionNotPermittedOnChanReservedForRouting                        = -200189;
  DAQmxErrorCannotConnectSrcChans                                                 = -200188;
  DAQmxErrorCannotConnectChannelToItself                                          = -200187;
  DAQmxErrorChannelNotReservedForRouting                                          = -200186;
  DAQmxErrorCannotConnectChansDirectly                                            = -200185;
  DAQmxErrorChansAlreadyConnected                                                 = -200184;
  DAQmxErrorChanDuplicatedInPath                                                  = -200183;
  DAQmxErrorNoPathToDisconnect                                                    = -200182;
  DAQmxErrorInvalidSwitchChan                                                     = -200181;
  DAQmxErrorNoPathAvailableBetween2SwitchChans                                    = -200180;
  DAQmxErrorExplicitConnectionExists                                              = -200179;
  DAQmxErrorSwitchDifferentSettlingTimeWhenScanning                               = -200178;
  DAQmxErrorOperationOnlyPermittedWhileScanning                                   = -200177;
  DAQmxErrorOperationNotPermittedWhileScanning                                    = -200176;
  DAQmxErrorHardwareNotResponding                                                 = -200175;
  DAQmxErrorInvalidSampAndMasterTimebaseRateCombo                                 = -200173;
  DAQmxErrorNonZeroBufferSizeInProgIOXfer                                         = -200172;
  DAQmxErrorVirtualChanNameUsed                                                   = -200171;
  DAQmxErrorPhysicalChanDoesNotExist                                              = -200170;
  DAQmxErrorMemMapOnlyForProgIOXfer                                               = -200169;
  DAQmxErrorTooManyChans                                                          = -200168;
  DAQmxErrorCannotHaveCJTempWithOtherChans                                        = -200167;
  DAQmxErrorOutputBufferUnderwrite                                                = -200166;
  DAQmxErrorSensorInvalidCompletionResistance                                     = -200163;
  DAQmxErrorVoltageExcitIncompatibleWith2WireCfg                                  = -200162;
  DAQmxErrorIntExcitSrcNotAvailable                                               = -200161;
  DAQmxErrorCannotCreateChannelAfterTaskVerified                                  = -200160;
  DAQmxErrorLinesReservedForSCXIControl                                           = -200159;
  DAQmxErrorCouldNotReserveLinesForSCXIControl                                    = -200158;
  DAQmxErrorCalibrationFailed                                                     = -200157;
  DAQmxErrorReferenceFrequencyInvalid                                             = -200156;
  DAQmxErrorReferenceResistanceInvalid                                            = -200155;
  DAQmxErrorReferenceCurrentInvalid                                               = -200154;
  DAQmxErrorReferenceVoltageInvalid                                               = -200153;
  DAQmxErrorEEPROMDataInvalid                                                     = -200152;
  DAQmxErrorCabledModuleNotCapableOfRoutingAI                                     = -200151;
  DAQmxErrorChannelNotAvailableInParallelMode                                     = -200150;
  DAQmxErrorExternalTimebaseRateNotKnownForDelay                                  = -200149;
  DAQmxErrorFREQOUTCannotProduceDesiredFrequency                                  = -200148;
  DAQmxErrorMultipleCounterInputTask                                              = -200147;
  DAQmxErrorCounterStartPauseTriggerConflict                                      = -200146;
  DAQmxErrorCounterInputPauseTriggerAndSampleClockInvalid                         = -200145;
  DAQmxErrorCounterOutputPauseTriggerInvalid                                      = -200144;
  DAQmxErrorCounterTimebaseRateNotSpecified                                       = -200143;
  DAQmxErrorCounterTimebaseRateNotFound                                           = -200142;
  DAQmxErrorCounterOverflow                                                       = -200141;
  DAQmxErrorCounterNoTimebaseEdgesBetweenGates                                    = -200140;
  DAQmxErrorCounterMaxMinRangeFreq                                                = -200139;
  DAQmxErrorCounterMaxMinRangeTime                                                = -200138;
  DAQmxErrorSuitableTimebaseNotFoundTimeCombo                                     = -200137;
  DAQmxErrorSuitableTimebaseNotFoundFrequencyCombo                                = -200136;
  DAQmxErrorInternalTimebaseSourceDivisorCombo                                    = -200135;
  DAQmxErrorInternalTimebaseSourceRateCombo                                       = -200134;
  DAQmxErrorInternalTimebaseRateDivisorSourceCombo                                = -200133;
  DAQmxErrorExternalTimebaseRateNotknownForRate                                   = -200132;
  DAQmxErrorAnalogTrigChanNotFirstInScanList                                      = -200131;
  DAQmxErrorNoDivisorForExternalSignal                                            = -200130;
  DAQmxErrorAttributeInconsistentAcrossRepeatedPhysicalChannels                   = -200128;
  DAQmxErrorCannotHandshakeWithPort0                                              = -200127;
  DAQmxErrorControlLineConflictOnPortC                                            = -200126;
  DAQmxErrorLines4To7ConfiguredForOutput                                          = -200125;
  DAQmxErrorLines4To7ConfiguredForInput                                           = -200124;
  DAQmxErrorLines0To3ConfiguredForOutput                                          = -200123;
  DAQmxErrorLines0To3ConfiguredForInput                                           = -200122;
  DAQmxErrorPortConfiguredForOutput                                               = -200121;
  DAQmxErrorPortConfiguredForInput                                                = -200120;
  DAQmxErrorPortConfiguredForStaticDigitalOps                                     = -200119;
  DAQmxErrorPortReservedForHandshaking                                            = -200118;
  DAQmxErrorPortDoesNotSupportHandshakingDataIO                                   = -200117;
  DAQmxErrorCannotTristate8255OutputLines                                         = -200116;
  DAQmxErrorTemperatureOutOfRangeForCalibration                                   = -200113;
  DAQmxErrorCalibrationHandleInvalid                                              = -200112;
  DAQmxErrorPasswordRequired                                                      = -200111;
  DAQmxErrorIncorrectPassword                                                     = -200110;
  DAQmxErrorPasswordTooLong                                                       = -200109;
  DAQmxErrorCalibrationSessionAlreadyOpen                                         = -200108;
  DAQmxErrorSCXIModuleIncorrect                                                   = -200107;
  DAQmxErrorAttributeInconsistentAcrossChannelsOnDevice                           = -200106;
  DAQmxErrorSCXI1122ResistanceChanNotSupportedForCfg                              = -200105;
  DAQmxErrorBracketPairingMismatchInList                                          = -200104;
  DAQmxErrorInconsistentNumSamplesToWrite                                         = -200103;
  DAQmxErrorIncorrectDigitalPattern                                               = -200102;
  DAQmxErrorIncorrectNumChannelsToWrite                                           = -200101;
  DAQmxErrorIncorrectReadFunction                                                 = -200100;
  DAQmxErrorPhysicalChannelNotSpecified                                           = -200099;
  DAQmxErrorMoreThanOneTerminal                                                   = -200098;
  DAQmxErrorMoreThanOneActiveChannelSpecified                                     = -200097;
  DAQmxErrorInvalidNumberSamplesToRead                                            = -200096;
  DAQmxErrorAnalogWaveformExpected                                                = -200095;
  DAQmxErrorDigitalWaveformExpected                                               = -200094;
  DAQmxErrorActiveChannelNotSpecified                                             = -200093;
  DAQmxErrorFunctionNotSupportedForDeviceTasks                                    = -200092;
  DAQmxErrorFunctionNotInLibrary                                                  = -200091;
  DAQmxErrorLibraryNotPresent                                                     = -200090;
  DAQmxErrorDuplicateTask                                                         = -200089;
  DAQmxErrorInvalidTask                                                           = -200088;
  DAQmxErrorInvalidChannel                                                        = -200087;
  DAQmxErrorInvalidSyntaxForPhysicalChannelRange                                  = -200086;
  DAQmxErrorMinNotLessThanMax                                                     = -200082;
  DAQmxErrorSampleRateNumChansConvertPeriodCombo                                  = -200081;
  DAQmxErrorAODuringCounter1DMAConflict                                           = -200079;
  DAQmxErrorAIDuringCounter0DMAConflict                                           = -200078;
  DAQmxErrorInvalidAttributeValue                                                 = -200077;
  DAQmxErrorSuppliedCurrentDataOutsideSpecifiedRange                              = -200076;
  DAQmxErrorSuppliedVoltageDataOutsideSpecifiedRange                              = -200075;
  DAQmxErrorCannotStoreCalConst                                                   = -200074;
  DAQmxErrorSCXIModuleNotFound                                                    = -200073;
  DAQmxErrorDuplicatePhysicalChansNotSupported                                    = -200072;
  DAQmxErrorTooManyPhysicalChansInList                                            = -200071;
  DAQmxErrorInvalidAdvanceEventTriggerType                                        = -200070;
  DAQmxErrorDeviceIsNotAValidSwitch                                               = -200069;
  DAQmxErrorDeviceDoesNotSupportScanning                                          = -200068;
  DAQmxErrorScanListCannotBeTimed                                                 = -200067;
  DAQmxErrorConnectOperatorInvalidAtPointInList                                   = -200066;
  DAQmxErrorUnexpectedSwitchActionInList                                          = -200065;
  DAQmxErrorUnexpectedSeparatorInList                                             = -200064;
  DAQmxErrorExpectedTerminatorInList                                              = -200063;
  DAQmxErrorExpectedConnectOperatorInList                                         = -200062;
  DAQmxErrorExpectedSeparatorInList                                               = -200061;
  DAQmxErrorFullySpecifiedPathInListContainsRange                                 = -200060;
  DAQmxErrorConnectionSeparatorAtEndOfList                                        = -200059;
  DAQmxErrorIdentifierInListTooLong                                               = -200058;
  DAQmxErrorDuplicateDeviceIDInListWhenSettling                                   = -200057;
  DAQmxErrorChannelNameNotSpecifiedInList                                         = -200056;
  DAQmxErrorDeviceIDNotSpecifiedInList                                            = -200055;
  DAQmxErrorSemicolonDoesNotFollowRangeInList                                     = -200054;
  DAQmxErrorSwitchActionInListSpansMultipleDevices                                = -200053;
  DAQmxErrorRangeWithoutAConnectActionInList                                      = -200052;
  DAQmxErrorInvalidIdentifierFollowingSeparatorInList                             = -200051;
  DAQmxErrorInvalidChannelNameInList                                              = -200050;
  DAQmxErrorInvalidNumberInRepeatStatementInList                                  = -200049;
  DAQmxErrorInvalidTriggerLineInList                                              = -200048;
  DAQmxErrorInvalidIdentifierInListFollowingDeviceID                              = -200047;
  DAQmxErrorInvalidIdentifierInListAtEndOfSwitchAction                            = -200046;
  DAQmxErrorDeviceRemoved                                                         = -200045;
  DAQmxErrorRoutingPathNotAvailable                                               = -200044;
  DAQmxErrorRoutingHardwareBusy                                                   = -200043;
  DAQmxErrorRequestedSignalInversionForRoutingNotPossible                         = -200042;
  DAQmxErrorInvalidRoutingDestinationTerminalName                                 = -200041;
  DAQmxErrorInvalidRoutingSourceTerminalName                                      = -200040;
  DAQmxErrorRoutingNotSupportedForDevice                                          = -200039;
  DAQmxErrorWaitIsLastInstructionOfLoopInScript                                   = -200038;
  DAQmxErrorClearIsLastInstructionOfLoopInScript                                  = -200037;
  DAQmxErrorInvalidLoopIterationsInScript                                         = -200036;
  DAQmxErrorRepeatLoopNestingTooDeepInScript                                      = -200035;
  DAQmxErrorMarkerPositionOutsideSubsetInScript                                   = -200034;
  DAQmxErrorSubsetStartOffsetNotAlignedInScript                                   = -200033;
  DAQmxErrorInvalidSubsetLengthInScript                                           = -200032;
  DAQmxErrorMarkerPositionNotAlignedInScript                                      = -200031;
  DAQmxErrorSubsetOutsideWaveformInScript                                         = -200030;
  DAQmxErrorMarkerOutsideWaveformInScript                                         = -200029;
  DAQmxErrorWaveformInScriptNotInMem                                              = -200028;
  DAQmxErrorKeywordExpectedInScript                                               = -200027;
  DAQmxErrorBufferNameExpectedInScript                                            = -200026;
  DAQmxErrorProcedureNameExpectedInScript                                         = -200025;
  DAQmxErrorScriptHasInvalidIdentifier                                            = -200024;
  DAQmxErrorScriptHasInvalidCharacter                                             = -200023;
  DAQmxErrorResourceAlreadyReserved                                               = -200022;
  DAQmxErrorSelfTestFailed                                                        = -200020;
  DAQmxErrorADCOverrun                                                            = -200019;
  DAQmxErrorDACUnderflow                                                          = -200018;
  DAQmxErrorInputFIFOUnderflow                                                    = -200017;
  DAQmxErrorOutputFIFOUnderflow                                                   = -200016;
  DAQmxErrorSCXISerialCommunication                                               = -200015;
  DAQmxErrorDigitalTerminalSpecifiedMoreThanOnce                                  = -200014;
  DAQmxErrorDigitalOutputNotSupported                                             = -200012;
  DAQmxErrorInconsistentChannelDirections                                         = -200011;
  DAQmxErrorInputFIFOOverflow                                                     = -200010;
  DAQmxErrorTimeStampOverwritten                                                  = -200009;
  DAQmxErrorStopTriggerHasNotOccurred                                             = -200008;
  DAQmxErrorRecordNotAvailable                                                    = -200007;
  DAQmxErrorRecordOverwritten                                                     = -200006;
  DAQmxErrorDataNotAvailable                                                      = -200005;
  DAQmxErrorDataOverwrittenInDeviceMemory                                         = -200004;
  DAQmxErrorDuplicatedChannel                                                     = -200003;
  DAQmxWarningTimestampCounterRolledOver                                          =  200003;
  DAQmxWarningInputTerminationOverloaded                                          =  200004;
  DAQmxWarningADCOverloaded                                                       =  200005;
  DAQmxWarningPLLUnlocked                                                         =  200007;
  DAQmxWarningCounter0DMADuringAIConflict                                         =  200008;
  DAQmxWarningCounter1DMADuringAOConflict                                         =  200009;
  DAQmxWarningStoppedBeforeDone                                                   =  200010;
  DAQmxWarningRateViolatesSettlingTime                                            =  200011;
  DAQmxWarningRateViolatesMaxADCRate                                              =  200012;
  DAQmxWarningUserDefInfoStringTooLong                                            =  200013;
  DAQmxWarningTooManyInterruptsPerSecond                                          =  200014;
  DAQmxWarningPotentialGlitchDuringWrite                                          =  200015;
  DAQmxWarningDevNotSelfCalibratedWithDAQmx                                       =  200016;
  DAQmxWarningAISampRateTooLow                                                    =  200017;
  DAQmxWarningAIConvRateTooLow                                                    =  200018;
  DAQmxWarningReadOffsetCoercion                                                  =  200019;
  DAQmxWarningPretrigCoercion                                                     =  200020;
  DAQmxWarningSampValCoercedToMax                                                 =  200021;
  DAQmxWarningSampValCoercedToMin                                                 =  200022;
  DAQmxWarningPropertyVersionNew                                                  =  200024;
  DAQmxWarningUserDefinedInfoTooLong                                              =  200025;
  DAQmxWarningCAPIStringTruncatedToFitBuffer                                      =  200026;
  DAQmxWarningSampClkRateTooLow                                                   =  200027;
  DAQmxWarningPossiblyInvalidCTRSampsInFiniteDMAAcq                               =  200028;
  DAQmxWarningRISAcqCompletedSomeBinsNotFilled                                    =  200029;
  DAQmxWarningPXIDevTempExceedsMaxOpTemp                                          =  200030;
  DAQmxWarningOutputGainTooLowForRFFreq                                           =  200031;
  DAQmxWarningOutputGainTooHighForRFFreq                                          =  200032;
  DAQmxWarningMultipleWritesBetweenSampClks                                       =  200033;
  DAQmxWarningDeviceMayShutDownDueToHighTemp                                      =  200034;
  DAQmxWarningRateViolatesMinADCRate                                              =  200035;
  DAQmxWarningSampClkRateAboveDevSpecs                                            =  200036;
  DAQmxWarningCOPrevDAQmxWriteSettingsOverwrittenForHWTimedSinglePoint            =  200037;
  DAQmxWarningLowpassFilterSettlingTimeExceedsUserTimeBetween2ADCConversions      =  200038;
  DAQmxWarningLowpassFilterSettlingTimeExceedsDriverTimeBetween2ADCConversions    =  200039;
  DAQmxWarningSampClkRateViolatesSettlingTimeForGen                               =  200040;
  DAQmxWarningInvalidCalConstValueForAI                                           =  200041;
  DAQmxWarningInvalidCalConstValueForAO                                           =  200042;
  DAQmxWarningChanCalExpired                                                      =  200043;
  DAQmxWarningUnrecognizedEnumValueEncounteredInStorage                           =  200044;
  DAQmxWarningTableCRCNotCorrect                                                  =  200045;
  DAQmxWarningExternalCRCNotCorrect                                               =  200046;
  DAQmxWarningSelfCalCRCNotCorrect                                                =  200047;
  DAQmxWarningDeviceSpecExceeded                                                  =  200048;
  DAQmxWarningOnlyGainCalibrated                                                  =  200049;
  DAQmxWarningReadNotCompleteBeforeSampClk                                        =  209800;
  DAQmxWarningWriteNotCompleteBeforeSampClk                                       =  209801;
  DAQmxWarningWaitForNextSampClkDetectedMissedSampClk                             =  209802;
  DAQmxErrorRoutingDestTermPXIClk10InNotInStarTriggerSlot_Routing                  = -89162;
  DAQmxErrorRoutingDestTermPXIClk10InNotInSystemTimingSlot_Routing                 = -89161;
  DAQmxErrorRoutingDestTermPXIStarXNotInStarTriggerSlot_Routing                    = -89160;
  DAQmxErrorRoutingDestTermPXIStarXNotInSystemTimingSlot_Routing                   = -89159;
  DAQmxErrorRoutingSrcTermPXIStarXNotInStarTriggerSlot_Routing                     = -89158;
  DAQmxErrorRoutingSrcTermPXIStarXNotInSystemTimingSlot_Routing                    = -89157;
  DAQmxErrorRoutingSrcTermPXIStarInNonStarTriggerSlot_Routing                      = -89156;
  DAQmxErrorRoutingDestTermPXIStarInNonStarTriggerSlot_Routing                     = -89155;
  DAQmxErrorRoutingDestTermPXIStarInStarTriggerSlot_Routing                        = -89154;
  DAQmxErrorRoutingDestTermPXIStarInSystemTimingSlot_Routing                       = -89153;
  DAQmxErrorRoutingSrcTermPXIStarInStarTriggerSlot_Routing                         = -89152;
  DAQmxErrorRoutingSrcTermPXIStarInSystemTimingSlot_Routing                        = -89151;
  DAQmxErrorInvalidSignalModifier_Routing                                          = -89150;
  DAQmxErrorRoutingDestTermPXIClk10InNotInSlot2_Routing                            = -89149;
  DAQmxErrorRoutingDestTermPXIStarXNotInSlot2_Routing                              = -89148;
  DAQmxErrorRoutingSrcTermPXIStarXNotInSlot2_Routing                               = -89147;
  DAQmxErrorRoutingSrcTermPXIStarInSlot16AndAbove_Routing                          = -89146;
  DAQmxErrorRoutingDestTermPXIStarInSlot16AndAbove_Routing                         = -89145;
  DAQmxErrorRoutingDestTermPXIStarInSlot2_Routing                                  = -89144;
  DAQmxErrorRoutingSrcTermPXIStarInSlot2_Routing                                   = -89143;
  DAQmxErrorRoutingDestTermPXIChassisNotIdentified_Routing                         = -89142;
  DAQmxErrorRoutingSrcTermPXIChassisNotIdentified_Routing                          = -89141;
  DAQmxErrorTrigLineNotFoundSingleDevRoute_Routing                                 = -89140;
  DAQmxErrorNoCommonTrigLineForRoute_Routing                                       = -89139;
  DAQmxErrorResourcesInUseForRouteInTask_Routing                                   = -89138;
  DAQmxErrorResourcesInUseForRoute_Routing                                         = -89137;
  DAQmxErrorRouteNotSupportedByHW_Routing                                          = -89136;
  DAQmxErrorResourcesInUseForInversionInTask_Routing                               = -89135;
  DAQmxErrorResourcesInUseForInversion_Routing                                     = -89134;
  DAQmxErrorInversionNotSupportedByHW_Routing                                      = -89133;
  DAQmxErrorResourcesInUseForProperty_Routing                                      = -89132;
  DAQmxErrorRouteSrcAndDestSame_Routing                                            = -89131;
  DAQmxErrorDevAbsentOrUnavailable_Routing                                         = -89130;
  DAQmxErrorInvalidTerm_Routing                                                    = -89129;
  DAQmxErrorCannotTristateTerm_Routing                                             = -89128;
  DAQmxErrorCannotTristateBusyTerm_Routing                                         = -89127;
  DAQmxErrorCouldNotReserveRequestedTrigLine_Routing                               = -89126;
  DAQmxErrorTrigLineNotFound_Routing                                               = -89125;
  DAQmxErrorRoutingPathNotAvailable_Routing                                        = -89124;
  DAQmxErrorRoutingHardwareBusy_Routing                                            = -89123;
  DAQmxErrorRequestedSignalInversionForRoutingNotPossible_Routing                  = -89122;
  DAQmxErrorInvalidRoutingDestinationTerminalName_Routing                          = -89121;
  DAQmxErrorInvalidRoutingSourceTerminalName_Routing                               = -89120;
  DAQmxErrorServiceLocatorNotAvailable_Routing                                     = -88907;
  DAQmxErrorCouldNotConnectToServer_Routing                                        = -88900;
  DAQmxErrorDeviceNameContainsSpacesOrPunctuation_Routing                          = -88720;
  DAQmxErrorDeviceNameContainsNonprintableCharacters_Routing                       = -88719;
  DAQmxErrorDeviceNameIsEmpty_Routing                                              = -88718;
  DAQmxErrorDeviceNameNotFound_Routing                                             = -88717;
  DAQmxErrorLocalRemoteDriverVersionMismatch_Routing                               = -88716;
  DAQmxErrorDuplicateDeviceName_Routing                                            = -88715;
  DAQmxErrorRuntimeAborting_Routing                                                = -88710;
  DAQmxErrorRuntimeAborted_Routing                                                 = -88709;
  DAQmxErrorResourceNotInPool_Routing                                              = -88708;
  DAQmxErrorDriverDeviceGUIDNotFound_Routing                                       = -88705;
  DAQmxErrorPALBusResetOccurred                                                    = -50800;
  DAQmxErrorPALWaitInterrupted                                                     = -50700;
  DAQmxErrorPALMessageUnderflow                                                    = -50651;
  DAQmxErrorPALMessageOverflow                                                     = -50650;
  DAQmxErrorPALThreadAlreadyDead                                                   = -50604;
  DAQmxErrorPALThreadStackSizeNotSupported                                         = -50603;
  DAQmxErrorPALThreadControllerIsNotThreadCreator                                  = -50602;
  DAQmxErrorPALThreadHasNoThreadObject                                             = -50601;
  DAQmxErrorPALThreadCouldNotRun                                                   = -50600;
  DAQmxErrorPALSyncTimedOut                                                        = -50550;
  DAQmxErrorPALReceiverSocketInvalid                                               = -50503;
  DAQmxErrorPALSocketListenerInvalid                                               = -50502;
  DAQmxErrorPALSocketListenerAlreadyRegistered                                     = -50501;
  DAQmxErrorPALDispatcherAlreadyExported                                           = -50500;
  DAQmxErrorPALDMALinkEventMissed                                                  = -50450;
  DAQmxErrorPALBusError                                                            = -50413;
  DAQmxErrorPALRetryLimitExceeded                                                  = -50412;
  DAQmxErrorPALTransferOverread                                                    = -50411;
  DAQmxErrorPALTransferOverwritten                                                 = -50410;
  DAQmxErrorPALPhysicalBufferFull                                                  = -50409;
  DAQmxErrorPALPhysicalBufferEmpty                                                 = -50408;
  DAQmxErrorPALLogicalBufferFull                                                   = -50407;
  DAQmxErrorPALLogicalBufferEmpty                                                  = -50406;
  DAQmxErrorPALTransferAborted                                                     = -50405;
  DAQmxErrorPALTransferStopped                                                     = -50404;
  DAQmxErrorPALTransferInProgress                                                  = -50403;
  DAQmxErrorPALTransferNotInProgress                                               = -50402;
  DAQmxErrorPALCommunicationsFault                                                 = -50401;
  DAQmxErrorPALTransferTimedOut                                                    = -50400;
  DAQmxErrorPALMemoryBlockCheckFailed                                              = -50354;
  DAQmxErrorPALMemoryPageLockFailed                                                = -50353;
  DAQmxErrorPALMemoryFull                                                          = -50352;
  DAQmxErrorPALMemoryAlignmentFault                                                = -50351;
  DAQmxErrorPALMemoryConfigurationFault                                            = -50350;
  DAQmxErrorPALDeviceInitializationFault                                           = -50303;
  DAQmxErrorPALDeviceNotSupported                                                  = -50302;
  DAQmxErrorPALDeviceUnknown                                                       = -50301;
  DAQmxErrorPALDeviceNotFound                                                      = -50300;
  DAQmxErrorPALFeatureDisabled                                                     = -50265;
  DAQmxErrorPALComponentBusy                                                       = -50264;
  DAQmxErrorPALComponentAlreadyInstalled                                           = -50263;
  DAQmxErrorPALComponentNotUnloadable                                              = -50262;
  DAQmxErrorPALComponentNeverLoaded                                                = -50261;
  DAQmxErrorPALComponentAlreadyLoaded                                              = -50260;
  DAQmxErrorPALComponentCircularDependency                                         = -50259;
  DAQmxErrorPALComponentInitializationFault                                        = -50258;
  DAQmxErrorPALComponentImageCorrupt                                               = -50257;
  DAQmxErrorPALFeatureNotSupported                                                 = -50256;
  DAQmxErrorPALFunctionNotFound                                                    = -50255;
  DAQmxErrorPALFunctionObsolete                                                    = -50254;
  DAQmxErrorPALComponentTooNew                                                     = -50253;
  DAQmxErrorPALComponentTooOld                                                     = -50252;
  DAQmxErrorPALComponentNotFound                                                   = -50251;
  DAQmxErrorPALVersionMismatch                                                     = -50250;
  DAQmxErrorPALFileFault                                                           = -50209;
  DAQmxErrorPALFileWriteFault                                                      = -50208;
  DAQmxErrorPALFileReadFault                                                       = -50207;
  DAQmxErrorPALFileSeekFault                                                       = -50206;
  DAQmxErrorPALFileCloseFault                                                      = -50205;
  DAQmxErrorPALFileOpenFault                                                       = -50204;
  DAQmxErrorPALDiskFull                                                            = -50203;
  DAQmxErrorPALOSFault                                                             = -50202;
  DAQmxErrorPALOSInitializationFault                                               = -50201;
  DAQmxErrorPALOSUnsupported                                                       = -50200;
  DAQmxErrorPALCalculationOverflow                                                 = -50175;
  DAQmxErrorPALHardwareFault                                                       = -50152;
  DAQmxErrorPALFirmwareFault                                                       = -50151;
  DAQmxErrorPALSoftwareFault                                                       = -50150;
  DAQmxErrorPALMessageQueueFull                                                    = -50108;
  DAQmxErrorPALResourceAmbiguous                                                   = -50107;
  DAQmxErrorPALResourceBusy                                                        = -50106;
  DAQmxErrorPALResourceInitialized                                                 = -50105;
  DAQmxErrorPALResourceNotInitialized                                              = -50104;
  DAQmxErrorPALResourceReserved                                                    = -50103;
  DAQmxErrorPALResourceNotReserved                                                 = -50102;
  DAQmxErrorPALResourceNotAvailable                                                = -50101;
  DAQmxErrorPALResourceOwnedBySystem                                               = -50100;
  DAQmxErrorPALBadToken                                                            = -50020;
  DAQmxErrorPALBadThreadMultitask                                                  = -50019;
  DAQmxErrorPALBadLibrarySpecifier                                                 = -50018;
  DAQmxErrorPALBadAddressSpace                                                     = -50017;
  DAQmxErrorPALBadWindowType                                                       = -50016;
  DAQmxErrorPALBadAddressClass                                                     = -50015;
  DAQmxErrorPALBadWriteCount                                                       = -50014;
  DAQmxErrorPALBadWriteOffset                                                      = -50013;
  DAQmxErrorPALBadWriteMode                                                        = -50012;
  DAQmxErrorPALBadReadCount                                                        = -50011;
  DAQmxErrorPALBadReadOffset                                                       = -50010;
  DAQmxErrorPALBadReadMode                                                         = -50009;
  DAQmxErrorPALBadCount                                                            = -50008;
  DAQmxErrorPALBadOffset                                                           = -50007;
  DAQmxErrorPALBadMode                                                             = -50006;
  DAQmxErrorPALBadDataSize                                                         = -50005;
  DAQmxErrorPALBadPointer                                                          = -50004;
  DAQmxErrorPALBadSelector                                                         = -50003;
  DAQmxErrorPALBadDevice                                                           = -50002;
  DAQmxErrorPALIrrelevantAttribute                                                 = -50001;
  DAQmxErrorPALValueConflict                                                       = -50000;
  DAQmxWarningPALValueConflict                                                     =  50000;
  DAQmxWarningPALIrrelevantAttribute                                               =  50001;
  DAQmxWarningPALBadDevice                                                         =  50002;
  DAQmxWarningPALBadSelector                                                       =  50003;
  DAQmxWarningPALBadPointer                                                        =  50004;
  DAQmxWarningPALBadDataSize                                                       =  50005;
  DAQmxWarningPALBadMode                                                           =  50006;
  DAQmxWarningPALBadOffset                                                         =  50007;
  DAQmxWarningPALBadCount                                                          =  50008;
  DAQmxWarningPALBadReadMode                                                       =  50009;
  DAQmxWarningPALBadReadOffset                                                     =  50010;
  DAQmxWarningPALBadReadCount                                                      =  50011;
  DAQmxWarningPALBadWriteMode                                                      =  50012;
  DAQmxWarningPALBadWriteOffset                                                    =  50013;
  DAQmxWarningPALBadWriteCount                                                     =  50014;
  DAQmxWarningPALBadAddressClass                                                   =  50015;
  DAQmxWarningPALBadWindowType                                                     =  50016;
  DAQmxWarningPALBadThreadMultitask                                                =  50019;
  DAQmxWarningPALResourceOwnedBySystem                                             =  50100;
  DAQmxWarningPALResourceNotAvailable                                              =  50101;
  DAQmxWarningPALResourceNotReserved                                               =  50102;
  DAQmxWarningPALResourceReserved                                                  =  50103;
  DAQmxWarningPALResourceNotInitialized                                            =  50104;
  DAQmxWarningPALResourceInitialized                                               =  50105;
  DAQmxWarningPALResourceBusy                                                      =  50106;
  DAQmxWarningPALResourceAmbiguous                                                 =  50107;
  DAQmxWarningPALFirmwareFault                                                     =  50151;
  DAQmxWarningPALHardwareFault                                                     =  50152;
  DAQmxWarningPALOSUnsupported                                                     =  50200;
  DAQmxWarningPALOSFault                                                           =  50202;
  DAQmxWarningPALFunctionObsolete                                                  =  50254;
  DAQmxWarningPALFunctionNotFound                                                  =  50255;
  DAQmxWarningPALFeatureNotSupported                                               =  50256;
  DAQmxWarningPALComponentInitializationFault                                      =  50258;
  DAQmxWarningPALComponentAlreadyLoaded                                            =  50260;
  DAQmxWarningPALComponentNotUnloadable                                            =  50262;
  DAQmxWarningPALMemoryAlignmentFault                                              =  50351;
  DAQmxWarningPALMemoryHeapNotEmpty                                                =  50355;
  DAQmxWarningPALTransferNotInProgress                                             =  50402;
  DAQmxWarningPALTransferInProgress                                                =  50403;
  DAQmxWarningPALTransferStopped                                                   =  50404;
  DAQmxWarningPALTransferAborted                                                   =  50405;
  DAQmxWarningPALLogicalBufferEmpty                                                =  50406;
  DAQmxWarningPALLogicalBufferFull                                                 =  50407;
  DAQmxWarningPALPhysicalBufferEmpty                                               =  50408;
  DAQmxWarningPALPhysicalBufferFull                                                =  50409;
  DAQmxWarningPALTransferOverwritten                                               =  50410;
  DAQmxWarningPALTransferOverread                                                  =  50411;
  DAQmxWarningPALDispatcherAlreadyExported                                         =  50500;
  DAQmxWarningPALSyncAbandoned                                                     =  50551;


var
  DAQmxLoadTask: function(taskName:Pansichar; taskHandle:PintG):Longint; stdcall;
  DAQmxCreateTask: function(taskName:Pansichar; taskHandle:PintG):Longint; stdcall;
  DAQmxAddGlobalChansToTask: function(taskHandle:TtaskHandle; channelNames:Pansichar):Longint; stdcall;
  DAQmxStartTask: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxStopTask: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxClearTask: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxWaitUntilTaskDone: function(taskHandle:TtaskHandle; timeToWait:Double):Longint; stdcall;
  DAQmxIsTaskDone: function(taskHandle:TtaskHandle; isTaskDone:PBOOL):Longint; stdcall;
  DAQmxWaitForNextSampleClock: function(taskHandle:TtaskHandle; timeout:Double; isLate:PBOOL):Longint; stdcall;
  DAQmxTaskControl: function(taskHandle:TtaskHandle; action:integer):Longint; stdcall;
  DAQmxGetNthTaskChannel: function(taskHandle:TtaskHandle; index:Longint; buffer:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetNthTaskDevice: function(taskHandle:TtaskHandle; index:Longint; buffer:Pansichar; bufferSize:Longint):Longint; stdcall;

  DAQmxRegisterEveryNSamplesEvent: function(taskHandle:TtaskHandle; everyNsamplesEventType:integer; nSamples:Longint; options:Longint; callbackFunction:pointer; callbackData:Pointer):Longint; stdcall;
  DAQmxRegisterDoneEvent: function(taskHandle:TtaskHandle; options:Longint; callbackFunction:pointer; callbackData:Pointer):Longint; stdcall;
  DAQmxRegisterSignalEvent: function(taskHandle:TtaskHandle; signalID:integer; options:Longint; callbackFunction:pointer; callbackData:Pointer):Longint; stdcall;
  
  DAQmxIsReadOrWriteLate: function(errorCode:Longint):BOOL; stdcall;
  DAQmxCreateAIVoltageChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAICurrentChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; shuntResistorLoc:integer; extShuntResistorVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIThrmcplChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; thermocoupleType:integer; cjcSource:integer; cjcVal:Double; cjcChannel:Pansichar):Longint; stdcall;
  DAQmxCreateAIRTDChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; rtdType:integer; resistanceConfig:integer; currentExcitSource:integer; currentExcitVal:Double; r0:Double):Longint; stdcall;
  DAQmxCreateAIThrmstrChanIex: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; currentExcitSource:integer; currentExcitVal:Double; a:Double; b:Double; c:Double):Longint; stdcall;
  DAQmxCreateAIThrmstrChanVex: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; voltageExcitSource:integer; voltageExcitVal:Double; a:Double; b:Double; c:Double; r1:Double):Longint; stdcall;
  DAQmxCreateAIFreqVoltageChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; thresholdLevel:Double; hysteresis:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIResistanceChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; currentExcitSource:integer; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIStrainGageChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; strainConfig:integer; voltageExcitSource:integer; voltageExcitVal:Double; gageFactor:Double; initialBridgeVoltage:Double; nominalGageResistance:Double; poissonRatio:Double; leadWireResistance:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIVoltageChanWithExcit: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; bridgeConfig:integer; voltageExcitSource:integer; voltageExcitVal:Double; useExcitForScaling:BOOL; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAITempBuiltInSensorChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; units:integer):Longint; stdcall;
  DAQmxCreateAIAccelChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; sensitivity:Double; sensitivityUnits:integer; currentExcitSource:integer; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIMicrophoneChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; units:integer; micSensitivity:Double; maxSndPressLevel:Double; currentExcitSource:integer; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIPosLVDTChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; sensitivity:Double; sensitivityUnits:integer; voltageExcitSource:integer; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIPosRVDTChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; sensitivity:Double; sensitivityUnits:integer; voltageExcitSource:integer; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAIDeviceTempChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; units:integer):Longint; stdcall;
  DAQmxCreateTEDSAIVoltageChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAICurrentChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; shuntResistorLoc:integer; extShuntResistorVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIThrmcplChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; cjcSource:integer; cjcVal:Double; cjcChannel:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIRTDChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; currentExcitSource:integer; currentExcitVal:Double):Longint; stdcall;
  DAQmxCreateTEDSAIThrmstrChanIex: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; currentExcitSource:integer; currentExcitVal:Double):Longint; stdcall;
  DAQmxCreateTEDSAIThrmstrChanVex: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; voltageExcitSource:integer; voltageExcitVal:Double; r1:Double):Longint; stdcall;
  DAQmxCreateTEDSAIResistanceChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; resistanceConfig:integer; currentExcitSource:integer; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIStrainGageChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; voltageExcitSource:integer; voltageExcitVal:Double; initialBridgeVoltage:Double; leadWireResistance:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIVoltageChanWithExcit: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; voltageExcitSource:integer; voltageExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIAccelChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; minVal:Double; maxVal:Double; units:integer; currentExcitSource:integer; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIMicrophoneChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; terminalConfig:integer; units:integer; maxSndPressLevel:Double; currentExcitSource:integer; currentExcitVal:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIPosLVDTChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; voltageExcitSource:integer; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateTEDSAIPosRVDTChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; voltageExcitSource:integer; voltageExcitVal:Double; voltageExcitFreq:Double; ACExcitWireMode:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAOVoltageChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateAOCurrentChan: function(taskHandle:TtaskHandle; physicalChannel:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateDIChan: function(taskHandle:TtaskHandle; lines:Pansichar; nameToAssignToLines:Pansichar; lineGrouping:integer):Longint; stdcall;
  DAQmxCreateDOChan: function(taskHandle:TtaskHandle; lines:Pansichar; nameToAssignToLines:Pansichar; lineGrouping:integer):Longint; stdcall;
  DAQmxCreateCIFreqChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; edge:integer; measMethod:integer; measTime:Double; divisor:Longint; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCIPeriodChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; edge:integer; measMethod:integer; measTime:Double; divisor:Longint; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCICountEdgesChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; edge:integer; initialCount:Longint; countDirection:integer):Longint; stdcall;
  DAQmxCreateCIPulseWidthChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; startingEdge:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCISemiPeriodChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCITwoEdgeSepChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; minVal:Double; maxVal:Double; units:integer; firstEdge:integer; secondEdge:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCILinEncoderChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; decodingType:integer; ZidxEnable:BOOL; ZidxVal:Double; ZidxPhase:integer; units:integer; distPerPulse:Double; initialPos:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCIAngEncoderChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; decodingType:integer; ZidxEnable:BOOL; ZidxVal:Double; ZidxPhase:integer; units:integer; pulsesPerRev:Longint; initialAngle:Double; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCIGPSTimestampChan: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; units:integer; syncMethod:integer; customScaleName:Pansichar):Longint; stdcall;
  DAQmxCreateCOPulseChanFreq: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; units:integer; idleState:integer; initialDelay:Double; freq:Double; dutyCycle:Double):Longint; stdcall;
  DAQmxCreateCOPulseChanTime: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; units:integer; idleState:integer; initialDelay:Double; lowTime:Double; highTime:Double):Longint; stdcall;
  DAQmxCreateCOPulseChanTicks: function(taskHandle:TtaskHandle; counter:Pansichar; nameToAssignToChannel:Pansichar; sourceTerminal:Pansichar; idleState:integer; initialDelay:Longint; lowTicks:Longint; highTicks:Longint):Longint; stdcall;
  DAQmxGetAIChanCalCalDate: function(taskHandle:TtaskHandle; channelName:Pansichar; year:PLongint; month:PLongint; day:PLongint; hour:PLongint; minute:PLongint):Longint; stdcall;
  DAQmxSetAIChanCalCalDate: function(taskHandle:TtaskHandle; channelName:Pansichar; year:Longint; month:Longint; day:Longint; hour:Longint; minute:Longint):Longint; stdcall;
  DAQmxGetAIChanCalExpDate: function(taskHandle:TtaskHandle; channelName:Pansichar; year:PLongint; month:PLongint; day:PLongint; hour:PLongint; minute:PLongint):Longint; stdcall;
  DAQmxSetAIChanCalExpDate: function(taskHandle:TtaskHandle; channelName:Pansichar; year:Longint; month:Longint; day:Longint; hour:Longint; minute:Longint):Longint; stdcall;
  DAQmxCfgSampClkTiming: function(taskHandle:TtaskHandle; source:Pansichar; rate:Double; activeEdge:integer; sampleMode:integer; sampsPerChan:int64):Longint; stdcall;
  DAQmxCfgHandshakingTiming: function(taskHandle:TtaskHandle; sampleMode:integer; sampsPerChan:int64):Longint; stdcall;
  DAQmxCfgBurstHandshakingTimingImportClock: function(taskHandle:TtaskHandle; sampleMode:integer; sampsPerChan:int64; sampleClkRate:Double; sampleClkSrc:Pansichar; sampleClkActiveEdge:integer; pauseWhen:integer; readyEventActiveLevel:integer):Longint; stdcall;
  DAQmxCfgBurstHandshakingTimingExportClock: function(taskHandle:TtaskHandle; sampleMode:integer; sampsPerChan:int64; sampleClkRate:Double; sampleClkOutpTerm:Pansichar; sampleClkPulsePolarity:integer; pauseWhen:integer; readyEventActiveLevel:integer):Longint; stdcall;
  DAQmxCfgChangeDetectionTiming: function(taskHandle:TtaskHandle; risingEdgeChan:Pansichar; fallingEdgeChan:Pansichar; sampleMode:integer; sampsPerChan:int64):Longint; stdcall;
  DAQmxCfgImplicitTiming: function(taskHandle:TtaskHandle; sampleMode:integer; sampsPerChan:int64):Longint; stdcall;
  DAQmxCfgPipelinedSampClkTiming: function(taskHandle:TtaskHandle; source:Pansichar; rate:Double; activeEdge:integer; sampleMode:integer; sampsPerChan:int64):Longint; stdcall;
  DAQmxDisableStartTrig: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxCfgDigEdgeStartTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerEdge:integer):Longint; stdcall;
  DAQmxCfgAnlgEdgeStartTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerSlope:integer; triggerLevel:Double):Longint; stdcall;
  DAQmxCfgAnlgWindowStartTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerWhen:integer; windowTop:Double; windowBottom:Double):Longint; stdcall;
  DAQmxCfgDigPatternStartTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerPattern:Pansichar; triggerWhen:integer):Longint; stdcall;
  DAQmxDisableRefTrig: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxCfgDigEdgeRefTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerEdge:integer; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxCfgAnlgEdgeRefTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerSlope:integer; triggerLevel:Double; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxCfgAnlgWindowRefTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerWhen:integer; windowTop:Double; windowBottom:Double; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxCfgDigPatternRefTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerPattern:Pansichar; triggerWhen:integer; pretriggerSamples:Longint):Longint; stdcall;
  DAQmxDisableAdvTrig: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxCfgDigEdgeAdvTrig: function(taskHandle:TtaskHandle; triggerSource:Pansichar; triggerEdge:integer):Longint; stdcall;
  DAQmxSendSoftwareTrigger: function(taskHandle:TtaskHandle; triggerID:integer):Longint; stdcall;

  DAQmxReadAnalogScalarF64: function(taskHandle:TtaskHandle; timeout:Double; value:PDouble; reserved:Pointer):Longint; stdcall;
  DAQmxReadAnalogF64: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer;
                               readArray:PDouble; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadBinaryI16: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer;
                               readArray:PSmallint; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadBinaryI32: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer;
                               readArray:PLongint; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;

  DAQmxReadDigitalU8: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer;
                               readArray:Pbyte; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadDigitalU16: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer;
                               readArray:Pword; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadDigitalU32: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer;
                               readArray:Plongword; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;


  DAQmxReadDigitalLines: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; fillMode:integer; readArray:PByte; arraySizeInBytes:Longint; sampsPerChanRead:PLongint; numBytesPerSamp:PLongint; reserved:Pointer):Longint; stdcall;

  DAQmxReadCounterF64: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; readArray:PDouble; arraySizeInSamps:Longint; sampsPerChanRead:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxReadCounterU32: function(TaskHandle: longint;numSampsPerChan: longint; timeout: double; readArray:Plongword; arraySizeInSamps: longint; sampsPerChanRead: Plongint; reserved: pointer): Longint;stdcall;
  DAQmxReadCounterScalarF64: function(taskHandle:TtaskHandle; timeout:Double; value:PDouble; reserved:Pointer):Longint; stdcall;
  DAQmxReadCounterScalarU32: function(taskHandle:TtaskHandle; timeout:Double; value:Plongword; reserved:Pointer):Longint; stdcall;


  DAQmxReadRaw: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; timeout:Double; readArray:Pointer; arraySizeInBytes:Longint; sampsRead:PLongint; numBytesPerSamp:PLongint; reserved:Pointer):Longint; stdcall;

  DAQmxGetNthTaskReadChannel: function(taskHandle:TtaskHandle; index:Longint; buffer:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxWriteAnalogF64: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; writeArray:PDouble; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteAnalogScalarF64: function(taskHandle:TtaskHandle; autoStart:BOOL; timeout:Double; value:Double; reserved:Pointer):Longint; stdcall;
  DAQmxWriteBinaryI16: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; writeArray:PSmallint; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteBinaryI32: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; writeArray:PLongint; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;

  DAQmxWriteDigitalLines, DAQmxWriteDigitalU8,  DAQmxWriteDigitalU16,  DAQmxWriteDigitalU32:
    function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; writeArray:PByte; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;

  DAQmxWriteCtrFreq: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; frequencyArray:PDouble; dutyCycleArray:PDouble; numSampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrFreqScalar: function(taskHandle:TtaskHandle; autoStart:BOOL; timeout:Double; frequency:Double; dutyCycle:Double; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTime: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; highTimeArray:PDouble; lowTimeArray:PDouble; numSampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTimeScalar: function(taskHandle:TtaskHandle; autoStart:BOOL; timeout:Double; highTime:Double; lowTime:Double; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTicks: function(taskHandle:TtaskHandle; numSampsPerChan:Longint; autoStart:BOOL; timeout:Double; dataLayout:integer; highTicksArray:PLongint; lowTicksArray:PLongint; numSampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteCtrTicksScalar: function(taskHandle:TtaskHandle; autoStart:BOOL; timeout:Double; highTicks:Longint; lowTicks:Longint; reserved:Pointer):Longint; stdcall;
  DAQmxWriteRaw: function(taskHandle:TtaskHandle; numSamps:Longint; autoStart:BOOL; timeout:Double; writeArray:Pointer; sampsPerChanWritten:PLongint; reserved:Pointer):Longint; stdcall;
  DAQmxExportSignal: function(taskHandle:TtaskHandle; signalID:integer; outputTerminal:Pansichar):Longint; stdcall;
  DAQmxCreateLinScale: function(name:Pansichar; slope:Double; yIntercept:Double; preScaledUnits:integer; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCreateMapScale: function(name:Pansichar; prescaledMin:Double; prescaledMax:Double; scaledMin:Double; scaledMax:Double; preScaledUnits:integer; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCreatePolynomialScale: function(name:Pansichar; forwardCoeffsArray:PDouble; numForwardCoeffsIn:Longint; reverseCoeffsArray:PDouble; numReverseCoeffsIn:Longint; preScaledUnits:integer; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCreateTableScale: function(name:Pansichar; prescaledValsArray:PDouble; numPrescaledValsIn:Longint; scaledValsArray:PDouble; numScaledValsIn:Longint; preScaledUnits:integer; scaledUnits:Pansichar):Longint; stdcall;
  DAQmxCalculateReversePolyCoeff: function(forwardCoeffsArray:PDouble; numForwardCoeffsIn:Longint; minValX:Double; maxValX:Double; numPointsToCompute:Longint; reversePolyOrder:Longint; reverseCoeffsArray:PDouble):Longint; stdcall;
  DAQmxCfgInputBuffer: function(taskHandle:TtaskHandle; numSampsPerChan:Longint):Longint; stdcall;
  DAQmxCfgOutputBuffer: function(taskHandle:TtaskHandle; numSampsPerChan:Longint):Longint; stdcall;
  DAQmxSwitchCreateScanList: function(scanList:Pansichar; taskHandle:PintG):Longint; stdcall;
  DAQmxSwitchConnect: function(switchChannel1:Pansichar; switchChannel2:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchConnectMulti: function(connectionList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchDisconnect: function(switchChannel1:Pansichar; switchChannel2:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchDisconnectMulti: function(connectionList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchDisconnectAll: function(deviceName:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchSetTopologyAndReset: function(deviceName:Pansichar; newTopology:Pansichar):Longint; stdcall;
  DAQmxSwitchFindPath: function(switchChannel1:Pansichar; switchChannel2:Pansichar; path:Pansichar; pathBufferSize:Longint; var pathStatus:integer):Longint; stdcall;
  DAQmxSwitchOpenRelays: function(relayList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchCloseRelays: function(relayList:Pansichar; waitForSettling:BOOL):Longint; stdcall;
  DAQmxSwitchGetSingleRelayCount: function(relayName:Pansichar; count:PLongint):Longint; stdcall;
  DAQmxSwitchGetMultiRelayCount: function(relayList:Pansichar; countArray:PLongint; countArraySize:Longint; numRelayCountsRead:PLongint):Longint; stdcall;
  DAQmxSwitchGetSingleRelayPos: function(relayName:Pansichar; var relayPos:integer):Longint; stdcall;
  DAQmxSwitchGetMultiRelayPos: function(relayList:Pansichar; var relayPosArray:integer; relayPosArraySize:Longint; numRelayPossRead:PLongint):Longint; stdcall;
  DAQmxSwitchWaitForSettling: function(deviceName:Pansichar):Longint; stdcall;
  DAQmxConnectTerms: function(sourceTerminal:Pansichar; destinationTerminal:Pansichar; signalModifiers:integer):Longint; stdcall;
  DAQmxDisconnectTerms: function(sourceTerminal:Pansichar; destinationTerminal:Pansichar):Longint; stdcall;
  DAQmxTristateOutputTerm: function(outputTerminal:Pansichar):Longint; stdcall;
  DAQmxResetDevice: function(deviceName:Pansichar):Longint; stdcall;

 {:  variable ParamCount
  DAQmxCreateWatchdogTimerTask: function(deviceName:Pansichar; taskName:Pansichar; taskHandle:PintG; timeout:Double; lines:Pansichar; var expStatesArray:integer; numItems:Longint):Longint; stdcall;

  function DAQmxControlWatchdogTask(taskHandle:TtaskHandle; action:DAQmxWDTTaskAction):Longint; stdcall;
 }
  DAQmxSelfCal: function(deviceName:Pansichar):Longint; stdcall;
  DAQmxPerformBridgeOffsetNullingCal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
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
  DAQmxCloseExtCal: function(calHandle:Longint; action:integer):Longint; stdcall;
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
  DAQmxWriteToTEDSFromArray: function(physicalChannel:Pansichar; bitStreamArray:PByte; arraySize:Longint; basicTEDSOptions:integer):Longint; stdcall;
  DAQmxWriteToTEDSFromFile: function(physicalChannel:Pansichar; filePath:Pansichar; basicTEDSOptions:integer):Longint; stdcall;
  DAQmxSaveTask: function(taskHandle:TtaskHandle; saveAs:Pansichar; author:Pansichar; options:integer):Longint; stdcall;
  DAQmxSaveGlobalChan: function(taskHandle:TtaskHandle; channelName:Pansichar; saveAs:Pansichar; author:Pansichar; options:integer):Longint; stdcall;
  DAQmxSaveScale: function(scaleName:Pansichar; saveAs:Pansichar; author:Pansichar; options:integer):Longint; stdcall;
  DAQmxDeleteSavedTask: function(taskName:Pansichar):Longint; stdcall;
  DAQmxDeleteSavedGlobalChan: function(channelName:Pansichar):Longint; stdcall;
  DAQmxDeleteSavedScale: function(scaleName:Pansichar):Longint; stdcall;


  { Variable Param Count
  DAQmxSetDigitalPowerUpStates: function(deviceName:Pansichar; channelNamesArray:P<not supported>; var statesArray:DAQmxPowerUpStates; numItems:Longint):Longint; stdcall;

  function DAQmxSetAnalogPowerUpStates(deviceName:Pansichar; channelNamesArray:P<not supported>; statesArray:PDouble; var channelTypesArray:DAQmxPowerUpChannelType; numItems:Longint):Longint; stdcall;

  function DAQmxSetDigitalLogicFamilyPowerUpState(deviceName:Pansichar; logicFamily:integer):Longint; stdcall;
 }
  DAQmxGetErrorString: function(errorCode:Longint; errorString:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetExtendedErrorInfo: function(errorString:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetBufInputBufSize: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetBufInputBufSize: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetBufInputBufSize: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetBufInputOnbrdBufSize: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetBufOutputBufSize: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetBufOutputBufSize: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetBufOutputBufSize: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetBufOutputOnbrdBufSize: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetBufOutputOnbrdBufSize: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetBufOutputOnbrdBufSize: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSelfCalSupported: function(deviceName:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetSelfCalLastTemp: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetExtCalRecommendedInterval: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetExtCalLastTemp: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetCalUserDefinedInfo: function(deviceName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCalUserDefinedInfo: function(deviceName:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetCalUserDefinedInfoMaxSize: function(deviceName:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCalDevTemp: function(deviceName:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAIMax: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIMax: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIMax: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMin: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIMin: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIMin: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAICustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAICustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMeasType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetAIVoltageUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIVoltageUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIVoltageUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAITempUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAITempUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAITempUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIThrmcplType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIThrmcplType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplScaleType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIThrmcplScaleType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIThrmcplScaleType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplCJCSrc: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetAIThrmcplCJCVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmcplCJCVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmcplCJCVal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmcplCJCChan: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetAIRTDType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIRTDType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIRTDType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDR0: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDR0: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDR0: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDA: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDA: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDA: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDB: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDB: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDB: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRTDC: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRTDC: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRTDC: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrA: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrA: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrA: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrB: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrB: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrB: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrC: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrC: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrC: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIThrmstrR1: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIThrmstrR1: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIThrmstrR1: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIForceReadFromChan: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIForceReadFromChan: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIForceReadFromChan: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICurrentUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAICurrentUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAICurrentUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIStrainUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIStrainUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainGageGageFactor: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIStrainGageGageFactor: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIStrainGageGageFactor: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainGagePoissonRatio: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIStrainGagePoissonRatio: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIStrainGagePoissonRatio: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIStrainGageCfg: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIStrainGageCfg: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIStrainGageCfg: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIResistanceUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIResistanceUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIResistanceUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIFreqThreshVoltage: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIFreqThreshVoltage: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIFreqThreshVoltage: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIFreqHyst: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIFreqHyst: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIFreqHyst: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILVDTUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAILVDTUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAILVDTUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILVDTSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILVDTSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILVDTSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILVDTSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAILVDTSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAILVDTSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRVDTUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIRVDTUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIRVDTUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRVDTSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRVDTSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRVDTSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRVDTSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIRVDTSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIRVDTSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAISoundPressureMaxSoundPressureLvl: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAISoundPressureMaxSoundPressureLvl: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAISoundPressureMaxSoundPressureLvl: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAISoundPressureUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAISoundPressureUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAISoundPressureUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMicrophoneSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIMicrophoneSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIMicrophoneSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAccelUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIAccelUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIAccelUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAccelSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIAccelSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIAccelSensitivity: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAccelSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIAccelSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIAccelSensitivityUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIIsTEDS: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetAITEDSUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetAICoupling: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAICoupling: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAICoupling: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIImpedance: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIImpedance: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIImpedance: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAITermCfg: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAITermCfg: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAITermCfg: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIInputSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIInputSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIInputSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIResistanceCfg: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIResistanceCfg: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIResistanceCfg: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILeadWireResistance: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILeadWireResistance: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILeadWireResistance: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeCfg: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIBridgeCfg: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIBridgeCfg: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeNomResistance: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIBridgeNomResistance: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIBridgeNomResistance: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeInitialVoltage: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIBridgeInitialVoltage: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIBridgeInitialVoltage: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeShuntCalEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIBridgeShuntCalEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIBridgeShuntCalEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeShuntCalSelect: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIBridgeShuntCalSelect: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIBridgeShuntCalSelect: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeShuntCalGainAdjust: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIBridgeShuntCalGainAdjust: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIBridgeShuntCalGainAdjust: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeBalanceCoarsePot: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIBridgeBalanceCoarsePot: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIBridgeBalanceCoarsePot: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIBridgeBalanceFinePot: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIBridgeBalanceFinePot: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIBridgeBalanceFinePot: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICurrentShuntLoc: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAICurrentShuntLoc: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAICurrentShuntLoc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAICurrentShuntResistance: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAICurrentShuntResistance: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAICurrentShuntResistance: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitSrc: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIExcitSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIExcitSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIExcitVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIExcitVal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitUseForScaling: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIExcitUseForScaling: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIExcitUseForScaling: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitUseMultiplexed: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIExcitUseMultiplexed: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIExcitUseMultiplexed: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitActualVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIExcitActualVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIExcitActualVal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitDCorAC: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIExcitDCorAC: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIExcitDCorAC: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIExcitVoltageOrCurrent: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIExcitVoltageOrCurrent: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIExcitVoltageOrCurrent: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIACExcitFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIACExcitFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIACExcitFreq: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIACExcitSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIACExcitSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIACExcitSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIACExcitWireMode: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIACExcitWireMode: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIACExcitWireMode: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAtten: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIAtten: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIAtten: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAILowpassEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAILowpassEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassCutoffFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILowpassCutoffFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILowpassCutoffFreq: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapClkSrc: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapClkSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapClkSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapExtClkFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapExtClkFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapExtClkFreq: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapExtClkDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapExtClkDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapExtClkDiv: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILowpassSwitchCapOutClkDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAILowpassSwitchCapOutClkDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAILowpassSwitchCapOutClkDiv: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIResolutionUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetAIResolution: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAIRawSampSize: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetAIRawSampJustification: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetAIDitherEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIDitherEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIDitherEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalHasValidCalInfo: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetAIChanCalEnableCal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIChanCalEnableCal: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIChanCalEnableCal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalApplyCalIfExp: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIChanCalApplyCalIfExp: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIChanCalApplyCalIfExp: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalScaleType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIChanCalScaleType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIChanCalScaleType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalTablePreScaledVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalTablePreScaledVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalTablePreScaledVals: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalTableScaledVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalTableScaledVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalTableScaledVals: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalPolyForwardCoeff: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalPolyForwardCoeff: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalPolyForwardCoeff: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalPolyReverseCoeff: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalPolyReverseCoeff: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalPolyReverseCoeff: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalOperatorName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIChanCalOperatorName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIChanCalOperatorName: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalDesc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIChanCalDesc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIChanCalDesc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalVerifRefVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalVerifRefVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalVerifRefVals: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIChanCalVerifAcqVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxSetAIChanCalVerifAcqVals: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxResetAIChanCalVerifAcqVals: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRngHigh: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRngHigh: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRngHigh: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRngLow: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIRngLow: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIRngLow: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIGain: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIGain: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIGain: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAISampAndHoldEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAISampAndHoldEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAISampAndHoldEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIAutoZeroMode: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIAutoZeroMode: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIAutoZeroMode: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIDataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIDataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDataXferCustomThreshold: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIDataXferCustomThreshold: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIDataXferCustomThreshold: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIRawDataCompressionType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIRawDataCompressionType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIRawDataCompressionType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAILossyLSBRemovalCompressedSampSize: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAILossyLSBRemovalCompressedSampSize: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAILossyLSBRemovalCompressedSampSize: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAIDevScalingCoeff: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetAIEnhancedAliasRejectionEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAIEnhancedAliasRejectionEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAIEnhancedAliasRejectionEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOMax: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOMax: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOMax: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOMin: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOMin: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOMin: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOCustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAOCustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAOCustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOOutputType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetAOVoltageUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAOVoltageUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAOVoltageUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOCurrentUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAOCurrentUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAOCurrentUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOOutputImpedance: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOOutputImpedance: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOOutputImpedance: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOLoadImpedance: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOLoadImpedance: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOLoadImpedance: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOIdleOutputBehavior: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAOIdleOutputBehavior: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAOIdleOutputBehavior: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOTermCfg: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAOTermCfg: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAOTermCfg: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOResolutionUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAOResolutionUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAOResolutionUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOResolution: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAODACRngHigh: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACRngHigh: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACRngHigh: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRngLow: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACRngLow: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACRngLow: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefConnToGnd: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAODACRefConnToGnd: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAODACRefConnToGnd: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefAllowConnToGnd: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAODACRefAllowConnToGnd: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAODACRefAllowConnToGnd: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefSrc: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAODACRefSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAODACRefSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefExtSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAODACRefExtSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAODACRefExtSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACRefVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACRefVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACRefVal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACOffsetSrc: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAODACOffsetSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAODACOffsetSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACOffsetExtSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAODACOffsetExtSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAODACOffsetExtSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODACOffsetVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAODACOffsetVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAODACOffsetVal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOReglitchEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOReglitchEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOReglitchEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOGain: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAOGain: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAOGain: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOUseOnlyOnBrdMem: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOUseOnlyOnBrdMem: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOUseOnlyOnBrdMem: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAODataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAODataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAODataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAODataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAOMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetAODevScalingCoeff: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble; arraySizeInSamples:Longint):Longint; stdcall;
  DAQmxGetAOEnhancedImageRejectionEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetAOEnhancedImageRejectionEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetAOEnhancedImageRejectionEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIInvertLines: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDIInvertLines: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDIInvertLines: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDINumLines: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDIDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDIDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDIDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetDIDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetDIDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDITristate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDITristate: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDITristate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDILogicFamily: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDILogicFamily: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDILogicFamily: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIDataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDIDataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDIDataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDIMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDIMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDIAcquireOn: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDIAcquireOn: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDIAcquireOn: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOOutputDriveType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDOOutputDriveType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDOOutputDriveType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOInvertLines: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOInvertLines: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOInvertLines: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDONumLines: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDOTristate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOTristate: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOTristate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLineStatesStartState: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDOLineStatesStartState: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDOLineStatesStartState: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLineStatesPausedState: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDOLineStatesPausedState: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDOLineStatesPausedState: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLineStatesDoneState: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDOLineStatesDoneState: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDOLineStatesDoneState: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOLogicFamily: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDOLogicFamily: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDOLogicFamily: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOUseOnlyOnBrdMem: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOUseOnlyOnBrdMem: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOUseOnlyOnBrdMem: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDODataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDODataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDODataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDODataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDODataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDODataXferReqCond: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetDOMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetDOMemMapEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetDOGenerateOn: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDOGenerateOn: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDOGenerateOn: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIMax: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIMax: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIMax: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIMin: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIMin: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIMin: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICustomScaleName: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIMeasType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetCIFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIFreqTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIFreqTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIFreqStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIFreqStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqMeasMeth: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIFreqMeasMeth: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIFreqMeasMeth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqMeasTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIFreqMeasTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIFreqMeasTime: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIFreqDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIFreqDiv: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIFreqDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIFreqDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIFreqDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIFreqDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIFreqDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIFreqDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIFreqDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIFreqDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIFreqDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIFreqDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIFreqDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIPeriodUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIPeriodUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPeriodTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPeriodTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIPeriodStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIPeriodStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodMeasMeth: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIPeriodMeasMeth: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIPeriodMeasMeth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodMeasTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPeriodMeasTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPeriodMeasTime: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIPeriodDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIPeriodDiv: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPeriodDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPeriodDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPeriodDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPeriodDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPeriodDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDir: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCICountEdgesDir: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCICountEdgesDir: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDirTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesDirTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesDirTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesCountDirDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesCountDirDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesCountDirDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesInitialCnt: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCICountEdgesInitialCnt: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCICountEdgesInitialCnt: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCICountEdgesActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCICountEdgesActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICountEdgesDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICountEdgesDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICountEdgesDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICountEdgesDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICountEdgesDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIAngEncoderUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIAngEncoderUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIAngEncoderUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIAngEncoderPulsesPerRev: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIAngEncoderPulsesPerRev: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIAngEncoderPulsesPerRev: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIAngEncoderInitialAngle: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIAngEncoderInitialAngle: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIAngEncoderInitialAngle: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCILinEncoderUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCILinEncoderUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCILinEncoderUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCILinEncoderDistPerPulse: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCILinEncoderDistPerPulse: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCILinEncoderDistPerPulse: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCILinEncoderInitialPos: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCILinEncoderInitialPos: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCILinEncoderInitialPos: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderDecodingType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIEncoderDecodingType: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIEncoderDecodingType: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderAInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderAInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderAInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderAInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderAInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderBInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderBInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderBInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderBInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderBInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderZInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderZInputTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderZInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderZInputDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZIndexEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIEncoderZIndexEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIEncoderZIndexEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZIndexVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIEncoderZIndexVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIEncoderZIndexVal: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIEncoderZIndexPhase: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIEncoderZIndexPhase: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIEncoderZIndexPhase: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIPulseWidthUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIPulseWidthUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPulseWidthTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPulseWidthTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIPulseWidthStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIPulseWidthStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCIPulseWidthDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCIPulseWidthDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPulseWidthDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIPulseWidthDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIPulseWidthDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCITwoEdgeSepUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCITwoEdgeSepUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepFirstDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepFirstDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepFirstDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITwoEdgeSepSecondDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCITwoEdgeSepSecondDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCITwoEdgeSepSecondDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCISemiPeriodUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCISemiPeriodUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCISemiPeriodTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCISemiPeriodTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCISemiPeriodStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCISemiPeriodStartingEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCISemiPeriodDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCISemiPeriodDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCISemiPeriodDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCISemiPeriodDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCISemiPeriodDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITimestampUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCITimestampUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCITimestampUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCITimestampInitialSeconds: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCITimestampInitialSeconds: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCITimestampInitialSeconds: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIGPSSyncMethod: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIGPSSyncMethod: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIGPSSyncMethod: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIGPSSyncSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCIGPSSyncSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCIGPSSyncSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICtrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICtrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICtrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICtrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCICtrTimebaseActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCICtrTimebaseActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICtrTimebaseDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCICtrTimebaseDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCICtrTimebaseDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCICount: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCIOutputState: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetCITCReached: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetCICtrTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCICtrTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCICtrTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCIDataXferMech: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCINumPossiblyInvalidSamps: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCIDupCountPrevent: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCIDupCountPrevent: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCIDupCountPrevent: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCIPrescaler: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCIPrescaler: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCIPrescaler: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOOutputType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetCOPulseIdleState: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCOPulseIdleState: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCOPulseIdleState: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCOPulseTerm: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCOPulseTerm: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTimeUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCOPulseTimeUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCOPulseTimeUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseHighTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseHighTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseHighTime: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseLowTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseLowTime: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseLowTime: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTimeInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseTimeInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseTimeInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseDutyCyc: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseDutyCyc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseDutyCyc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCOPulseFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCOPulseFreqUnits: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseFreq: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseFreq: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseFreqInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOPulseFreqInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOPulseFreqInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseHighTicks: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPulseHighTicks: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPulseHighTicks: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseLowTicks: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPulseLowTicks: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPulseLowTicks: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseTicksInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPulseTicksInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPulseTicksInitialDelay: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCOCtrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCOCtrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOCtrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOCtrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetCOCtrTimebaseActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetCOCtrTimebaseActiveEdge: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigFltrTimebaseRate: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxSetCOCtrTimebaseDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar; data:BOOL):Longint; stdcall;
  DAQmxResetCOCtrTimebaseDigSyncEnable: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCount: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetCOOutputState: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetCOAutoIncrCnt: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOAutoIncrCnt: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOAutoIncrCnt: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOCtrTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOCtrTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOCtrTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCOPulseDone: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetCOPrescaler: function(taskHandle:TtaskHandle; channel:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetCOPrescaler: function(taskHandle:TtaskHandle; channel:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetCOPrescaler: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetCORdyForNewVal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetChanType: function(taskHandle:TtaskHandle; channel:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetPhysicalChanName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetPhysicalChanName: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetChanDescr: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetChanDescr: function(taskHandle:TtaskHandle; channel:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetChanDescr: function(taskHandle:TtaskHandle; channel:Pansichar):Longint; stdcall;
  DAQmxGetChanIsGlobal: function(taskHandle:TtaskHandle; channel:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetExportedAIConvClkOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAIConvClkOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAIConvClkOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAIConvClkPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxGetExported10MHzRefClkOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExported10MHzRefClkOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExported10MHzRefClkOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExported20MHzTimebaseOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExported20MHzTimebaseOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExported20MHzTimebaseOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedSampClkOutputBehavior: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedSampClkOutputBehavior: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedSampClkOutputBehavior: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedSampClkOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedSampClkOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedSampClkOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedSampClkPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedSampClkPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedSampClkPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedSampClkTimebaseOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedSampClkTimebaseOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedSampClkTimebaseOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedDividedSampClkTimebaseOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedDividedSampClkTimebaseOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedDividedSampClkTimebaseOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAdvTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAdvTrigOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvTrigPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxGetExportedAdvTrigPulseWidthUnits: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedAdvTrigPulseWidthUnits: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedAdvTrigPulseWidthUnits: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvTrigPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetExportedAdvTrigPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetExportedAdvTrigPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedPauseTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedPauseTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedPauseTrigOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedPauseTrigLvlActiveLvl: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedPauseTrigLvlActiveLvl: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedPauseTrigLvlActiveLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRefTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedRefTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedRefTrigOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRefTrigPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedRefTrigPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedRefTrigPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedStartTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedStartTrigOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedStartTrigOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedStartTrigPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedStartTrigPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedStartTrigPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventDelay: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventDelay: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventDelay: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAdvCmpltEventPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetExportedAdvCmpltEventPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetExportedAdvCmpltEventPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAIHoldCmpltEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedAIHoldCmpltEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedAIHoldCmpltEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedAIHoldCmpltEventPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedAIHoldCmpltEventPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedAIHoldCmpltEventPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedChangeDetectEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedChangeDetectEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedChangeDetectEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedChangeDetectEventPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedChangeDetectEventPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedChangeDetectEventPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedCtrOutEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedCtrOutEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedCtrOutEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedCtrOutEventOutputBehavior: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedCtrOutEventOutputBehavior: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedCtrOutEventOutputBehavior: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedCtrOutEventPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedCtrOutEventPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedCtrOutEventPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedCtrOutEventToggleIdleState: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedCtrOutEventToggleIdleState: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedCtrOutEventToggleIdleState: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedHshkEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedHshkEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventOutputBehavior: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedHshkEventOutputBehavior: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedHshkEventOutputBehavior: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventDelay: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetExportedHshkEventDelay: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetExportedHshkEventDelay: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventInterlockedAssertedLvl: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedHshkEventInterlockedAssertedLvl: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedHshkEventInterlockedAssertedLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventInterlockedAssertOnStart: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetExportedHshkEventInterlockedAssertOnStart: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetExportedHshkEventInterlockedAssertOnStart: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventInterlockedDeassertDelay: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetExportedHshkEventInterlockedDeassertDelay: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetExportedHshkEventInterlockedDeassertDelay: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventPulsePolarity: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedHshkEventPulsePolarity: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedHshkEventPulsePolarity: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedHshkEventPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetExportedHshkEventPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetExportedHshkEventPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventLvlActiveLvl: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventLvlActiveLvl: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventLvlActiveLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventDeassertCond: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventDeassertCond: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventDeassertCond: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRdyForXferEventDeassertCondCustomThreshold: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetExportedRdyForXferEventDeassertCondCustomThreshold: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetExportedRdyForXferEventDeassertCondCustomThreshold: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedDataActiveEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedDataActiveEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedDataActiveEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedDataActiveEventLvlActiveLvl: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedDataActiveEventLvlActiveLvl: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedDataActiveEventLvlActiveLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRdyForStartEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedRdyForStartEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedRdyForStartEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedRdyForStartEventLvlActiveLvl: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetExportedRdyForStartEventLvlActiveLvl: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetExportedRdyForStartEventLvlActiveLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedSyncPulseEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedSyncPulseEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedSyncPulseEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetExportedWatchdogExpiredEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetExportedWatchdogExpiredEventOutputTerm: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetExportedWatchdogExpiredEventOutputTerm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDevIsSimulated: function(device:Pansichar; data:PBOOL):Longint; stdcall;
  DAQmxGetDevProductCategory: function(device:Pansichar; var data:integer):Longint; stdcall;
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
  DAQmxGetDevBusType: function(device:Pansichar; var data:integer):Longint; stdcall;
  DAQmxGetDevNumDMAChans: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPCIBusNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPCIDevNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPXIChassisNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevPXISlotNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetDevCompactDAQChassisDevName: function(device:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetDevCompactDAQSlotNum: function(device:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxGetReadRelativeTo: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetReadRelativeTo: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetReadRelativeTo: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadOffset: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetReadOffset: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetReadOffset: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadChannelsToRead: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetReadChannelsToRead: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetReadChannelsToRead: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadReadAllAvailSamp: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetReadReadAllAvailSamp: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetReadReadAllAvailSamp: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadAutoStart: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetReadAutoStart: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetReadAutoStart: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadOverWrite: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetReadOverWrite: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetReadOverWrite: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadCurrReadPos: function(taskHandle:TtaskHandle; data:Pint64):Longint; stdcall;
  DAQmxGetReadAvailSampPerChan: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetReadTotalSampPerChanAcquired: function(taskHandle:TtaskHandle; data:Pint64):Longint; stdcall;
  DAQmxGetReadOverloadedChansExist: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxGetReadOverloadedChans: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetReadChangeDetectHasOverflowed: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxGetReadRawDataWidth: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetReadNumChans: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetReadDigitalLinesBytesPerChan: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetReadWaitMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetReadWaitMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetReadWaitMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetReadSleepTime: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetReadSleepTime: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetReadSleepTime: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRealTimeConvLateErrorsToWarnings: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetRealTimeConvLateErrorsToWarnings: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetRealTimeConvLateErrorsToWarnings: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRealTimeNumOfWarmupIters: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetRealTimeNumOfWarmupIters: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetRealTimeNumOfWarmupIters: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRealTimeWaitForNextSampClkWaitMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetRealTimeWaitForNextSampClkWaitMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetRealTimeWaitForNextSampClkWaitMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRealTimeReportMissedSamp: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetRealTimeReportMissedSamp: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetRealTimeReportMissedSamp: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRealTimeWriteRecoveryMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetRealTimeWriteRecoveryMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetRealTimeWriteRecoveryMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSwitchChanUsage: function(switchChannelName:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetSwitchChanUsage: function(switchChannelName:Pansichar; data:integer):Longint; stdcall;
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
  DAQmxGetSwitchScanBreakMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSwitchScanBreakMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSwitchScanBreakMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSwitchScanRepeatMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSwitchScanRepeatMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSwitchScanRepeatMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSwitchScanWaitingForAdv: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxGetScaleDescr: function(scaleName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetScaleDescr: function(scaleName:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetScaleScaledUnits: function(scaleName:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetScaleScaledUnits: function(scaleName:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxGetScalePreScaledUnits: function(scaleName:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetScalePreScaledUnits: function(scaleName:Pansichar; data:integer):Longint; stdcall;
  DAQmxGetScaleType: function(scaleName:Pansichar; var data:integer):Longint; stdcall;
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
  DAQmxGetSysDevNames: function(data:Pansichar; bufferSize: Longint):Longint; stdcall;
  DAQmxGetSysNIDAQMajorVersion: function(data:PLongint):Longint; stdcall;
  DAQmxGetSysNIDAQMinorVersion: function(data:PLongint):Longint; stdcall;
  DAQmxGetTaskName: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetTaskChannels: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetTaskNumChans: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetTaskDevices: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxGetTaskNumDevices: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetTaskComplete: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxGetSampQuantSampMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSampQuantSampMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSampQuantSampMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampQuantSampPerChan: function(taskHandle:TtaskHandle; data:Pint64):Longint; stdcall;
  DAQmxSetSampQuantSampPerChan: function(taskHandle:TtaskHandle; data:int64):Longint; stdcall;
  DAQmxResetSampQuantSampPerChan: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampTimingType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSampTimingType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSampTimingType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetSampClkRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkMaxRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxGetSampClkSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSampClkSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetSampClkSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkActiveEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSampClkActiveEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSampClkActiveEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkUnderflowBehavior: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSampClkUnderflowBehavior: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSampClkUnderflowBehavior: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkTimebaseDiv: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetSampClkTimebaseDiv: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetSampClkTimebaseDiv: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkTimebaseRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkTimebaseRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetSampClkTimebaseRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSampClkTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetSampClkTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkTimebaseActiveEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSampClkTimebaseActiveEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSampClkTimebaseActiveEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetSampClkTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetSampClkTimebaseMasterTimebaseDiv: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkDigFltrEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetSampClkDigFltrEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetSampClkDigFltrEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetSampClkDigFltrMinPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSampClkDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetSampClkDigFltrTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetSampClkDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetSampClkDigFltrTimebaseRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSampClkDigSyncEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetSampClkDigSyncEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetSampClkDigSyncEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetHshkDelayAfterXfer: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetHshkDelayAfterXfer: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetHshkDelayAfterXfer: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetHshkStartCond: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetHshkStartCond: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetHshkStartCond: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetHshkSampleInputDataWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetHshkSampleInputDataWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetHshkSampleInputDataWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetChangeDetectDIRisingEdgePhysicalChans: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetChangeDetectDIRisingEdgePhysicalChans: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetChangeDetectDIRisingEdgePhysicalChans: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetChangeDetectDIFallingEdgePhysicalChans: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetChangeDetectDIFallingEdgePhysicalChans: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetChangeDetectDIFallingEdgePhysicalChans: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetOnDemandSimultaneousAOEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetOnDemandSimultaneousAOEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetOnDemandSimultaneousAOEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAIConvRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAIConvRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAIConvRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAIConvRateEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetAIConvRateEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetAIConvRateEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvMaxRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxGetAIConvMaxRateEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxGetAIConvSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIConvSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAIConvSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAIConvSrcEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAIConvSrcEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:Pansichar):Longint; stdcall;
  DAQmxResetAIConvSrcEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvActiveEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAIConvActiveEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAIConvActiveEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAIConvActiveEdgeEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIConvActiveEdgeEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIConvActiveEdgeEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvTimebaseDiv: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetAIConvTimebaseDiv: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetAIConvTimebaseDiv: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAIConvTimebaseDivEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:PLongint):Longint; stdcall;
  DAQmxSetAIConvTimebaseDivEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:Longint):Longint; stdcall;
  DAQmxResetAIConvTimebaseDivEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetAIConvTimebaseSrc: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAIConvTimebaseSrc: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAIConvTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAIConvTimebaseSrcEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetAIConvTimebaseSrcEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetAIConvTimebaseSrcEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelayUnits: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelayUnits: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelayUnits: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelayUnitsEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelayUnitsEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelayUnitsEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelay: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelay: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelay: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDelayFromSampClkDelayEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:PDouble):Longint; stdcall;
  DAQmxSetDelayFromSampClkDelayEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar; data:Double):Longint; stdcall;
  DAQmxResetDelayFromSampClkDelayEx: function(taskHandle:TtaskHandle; deviceNames:Pansichar):Longint; stdcall;
  DAQmxGetMasterTimebaseRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetMasterTimebaseRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetMasterTimebaseRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetMasterTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetMasterTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetMasterTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRefClkRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetRefClkRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetRefClkRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRefClkSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetRefClkSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetRefClkSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSyncPulseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetSyncPulseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetSyncPulseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetSyncPulseSyncTime: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxGetSyncPulseMinDelayToStart: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetSyncPulseMinDelayToStart: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetSyncPulseMinDelayToStart: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetStartTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetStartTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetStartTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeStartTrigDigSyncEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeStartTrigDigSyncEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeStartTrigDigSyncEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternStartTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternStartTrigPattern: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternStartTrigPattern: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternStartTrigPattern: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternStartTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigPatternStartTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigPatternStartTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigSlope: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigSlope: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigSlope: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigLvl: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigLvl: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigHyst: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigHyst: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigHyst: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeStartTrigCoupling: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgEdgeStartTrigCoupling: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgEdgeStartTrigCoupling: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigTop: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigTop: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigTop: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigBtm: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigBtm: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigBtm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinStartTrigCoupling: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgWinStartTrigCoupling: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgWinStartTrigCoupling: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetStartTrigDelay: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetStartTrigDelay: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetStartTrigDelay: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetStartTrigDelayUnits: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetStartTrigDelayUnits: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetStartTrigDelayUnits: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetStartTrigRetriggerable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetStartTrigRetriggerable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetStartTrigRetriggerable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRefTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetRefTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetRefTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetRefTrigPretrigSamples: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetRefTrigPretrigSamples: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetRefTrigPretrigSamples: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeRefTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeRefTrigEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigEdgeRefTrigEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigEdgeRefTrigEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternRefTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternRefTrigPattern: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternRefTrigPattern: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternRefTrigPattern: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternRefTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigPatternRefTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigPatternRefTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigSlope: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigSlope: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigSlope: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigLvl: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigLvl: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigHyst: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigHyst: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigHyst: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgEdgeRefTrigCoupling: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgEdgeRefTrigCoupling: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgEdgeRefTrigCoupling: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigTop: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigTop: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigTop: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigBtm: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigBtm: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigBtm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinRefTrigCoupling: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgWinRefTrigCoupling: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgWinRefTrigCoupling: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAdvTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAdvTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAdvTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeAdvTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeAdvTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeAdvTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeAdvTrigEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigEdgeAdvTrigEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigEdgeAdvTrigEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeAdvTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeAdvTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeAdvTrigDigFltrEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetHshkTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetHshkTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetHshkTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetInterlockedHshkTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetInterlockedHshkTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetInterlockedHshkTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetInterlockedHshkTrigAssertedLvl: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetInterlockedHshkTrigAssertedLvl: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetInterlockedHshkTrigAssertedLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetPauseTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetPauseTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetPauseTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigLvl: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigLvl: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigLvl: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigHyst: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigHyst: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigHyst: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgLvlPauseTrigCoupling: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgLvlPauseTrigCoupling: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgLvlPauseTrigCoupling: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigTop: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigTop: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigTop: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigBtm: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigBtm: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigBtm: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetAnlgWinPauseTrigCoupling: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetAnlgWinPauseTrigCoupling: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetAnlgWinPauseTrigCoupling: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigLvlPauseTrigDigSyncEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigLvlPauseTrigDigSyncEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigLvlPauseTrigDigSyncEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternPauseTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternPauseTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternPauseTrigPattern: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigPatternPauseTrigPattern: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigPatternPauseTrigPattern: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigPatternPauseTrigWhen: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigPatternPauseTrigWhen: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigPatternPauseTrigWhen: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetArmStartTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetArmStartTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetArmStartTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrMinPulseWidth: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigFltrTimebaseRate: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeArmStartTrigDigSyncEnable: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetDigEdgeArmStartTrigDigSyncEnable: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetDigEdgeArmStartTrigDigSyncEnable: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWatchdogTimeout: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetWatchdogTimeout: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetWatchdogTimeout: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWatchdogExpirTrigType: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetWatchdogExpirTrigType: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetWatchdogExpirTrigType: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeWatchdogExpirTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar; bufferSize:Longint):Longint; stdcall;
  DAQmxSetDigEdgeWatchdogExpirTrigSrc: function(taskHandle:TtaskHandle; data:Pansichar):Longint; stdcall;
  DAQmxResetDigEdgeWatchdogExpirTrigSrc: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetDigEdgeWatchdogExpirTrigEdge: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetDigEdgeWatchdogExpirTrigEdge: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetDigEdgeWatchdogExpirTrigEdge: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWatchdogDOExpirState: function(taskHandle:TtaskHandle; lines:Pansichar; var data:integer):Longint; stdcall;
  DAQmxSetWatchdogDOExpirState: function(taskHandle:TtaskHandle; lines:Pansichar; data:integer):Longint; stdcall;
  DAQmxResetWatchdogDOExpirState: function(taskHandle:TtaskHandle; lines:Pansichar):Longint; stdcall;
  DAQmxGetWatchdogHasExpired: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxGetWriteRelativeTo: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetWriteRelativeTo: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetWriteRelativeTo: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWriteOffset: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxSetWriteOffset: function(taskHandle:TtaskHandle; data:Longint):Longint; stdcall;
  DAQmxResetWriteOffset: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWriteRegenMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetWriteRegenMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetWriteRegenMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWriteCurrWritePos: function(taskHandle:TtaskHandle; data:Pint64):Longint; stdcall;
  DAQmxGetWriteSpaceAvail: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetWriteTotalSampPerChanGenerated: function(taskHandle:TtaskHandle; data:Pint64):Longint; stdcall;
  DAQmxGetWriteRawDataWidth: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetWriteNumChans: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
  DAQmxGetWriteWaitMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetWriteWaitMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetWriteWaitMode: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWriteSleepTime: function(taskHandle:TtaskHandle; data:PDouble):Longint; stdcall;
  DAQmxSetWriteSleepTime: function(taskHandle:TtaskHandle; data:Double):Longint; stdcall;
  DAQmxResetWriteSleepTime: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWriteNextWriteIsLast: function(taskHandle:TtaskHandle; data:PBOOL):Longint; stdcall;
  DAQmxSetWriteNextWriteIsLast: function(taskHandle:TtaskHandle; data:BOOL):Longint; stdcall;
  DAQmxResetWriteNextWriteIsLast: function(taskHandle:TtaskHandle):Longint; stdcall;
  DAQmxGetWriteDigitalLinesBytesPerChan: function(taskHandle:TtaskHandle; data:PLongint):Longint; stdcall;
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
  DAQmxGetSampClkTimingResponseMode: function(taskHandle:TtaskHandle; var data:integer):Longint; stdcall;
  DAQmxSetSampClkTimingResponseMode: function(taskHandle:TtaskHandle; data:integer):Longint; stdcall;
  DAQmxResetSampClkTimingResponseMode: function(taskHandle:TtaskHandle):Longint; stdcall;


function InitNIlib:boolean;

Implementation


const
  hh:intG=0;

function getProc(st:AnsiString):pointer;
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
  DAQmxIsTaskDone := getProc('DAQmxIsTaskDone');
  DAQmxWaitForNextSampleClock := getProc('DAQmxWaitForNextSampleClock');
  DAQmxTaskControl := getProc('DAQmxTaskControl');
  DAQmxGetNthTaskChannel := getProc('DAQmxGetNthTaskChannel');
  DAQmxGetNthTaskDevice := getProc('DAQmxGetNthTaskDevice');
  DAQmxRegisterEveryNSamplesEvent := getProc('DAQmxRegisterEveryNSamplesEvent');
  DAQmxRegisterDoneEvent := getProc('DAQmxRegisterDoneEvent');
  DAQmxRegisterSignalEvent := getProc('DAQmxRegisterSignalEvent');
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
  DAQmxCfgSampClkTiming := getProc('DAQmxCfgSampClkTiming');
  DAQmxCfgHandshakingTiming := getProc('DAQmxCfgHandshakingTiming');
  DAQmxCfgBurstHandshakingTimingImportClock := getProc('DAQmxCfgBurstHandshakingTimingImportClock');
  DAQmxCfgBurstHandshakingTimingExportClock := getProc('DAQmxCfgBurstHandshakingTimingExportClock');
  DAQmxCfgChangeDetectionTiming := getProc('DAQmxCfgChangeDetectionTiming');
  DAQmxCfgImplicitTiming := getProc('DAQmxCfgImplicitTiming');
  DAQmxCfgPipelinedSampClkTiming := getProc('DAQmxCfgPipelinedSampClkTiming');
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

  DAQmxReadDigitalU8 := getProc('DAQmxReadDigitalU8');
  DAQmxReadDigitalU16 := getProc('DAQmxReadDigitalU16');
  DAQmxReadDigitalU32 := getProc('DAQmxReadDigitalU32');

  DAQmxReadDigitalLines := getProc('DAQmxReadDigitalLines');

  DAQmxReadCounterF64 := getProc('DAQmxReadCounterF64');
  DAQmxReadCounterScalarF64 := getProc('DAQmxReadCounterScalarF64');
  DAQmxReadCounterU32 := getProc('DAQmxReadCounterU32');
  DAQmxReadCounterScalarU32:= getProc('DAQmxReadCounterScalarU32');


  DAQmxReadRaw := getProc('DAQmxReadRaw');
  DAQmxGetNthTaskReadChannel := getProc('DAQmxGetNthTaskReadChannel');
  DAQmxWriteAnalogF64 := getProc('DAQmxWriteAnalogF64');
  DAQmxWriteAnalogScalarF64 := getProc('DAQmxWriteAnalogScalarF64');
  DAQmxWriteBinaryI16 := getProc('DAQmxWriteBinaryI16');
  DAQmxWriteBinaryI32 := getProc('DAQmxWriteBinaryI32');

  DAQmxWriteDigitalLines := getProc('DAQmxWriteDigitalLines');
  DAQmxWriteDigitalU8    := getProc('DAQmxWriteDigitalU8');
  DAQmxWriteDigitalU16   := getProc('DAQmxWriteDigitalU16');
  DAQmxWriteDigitalU32   := getProc('DAQmxWriteDigitalU32');

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
  DAQmxCreateWatchdogTimerTask := getProc('DAQmxCreateWatchdogTimerTask');
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
  DAQmxDeviceSupportsCal := getProc('DAQmxDeviceSupportsCal');
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
  DAQmxSetDigitalPowerUpStates := getProc('DAQmxSetDigitalPowerUpStates';

  DAQmxSetAnalogPowerUpStates:= getProc('DAQmxSetAnalogPowerUpStates');

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
  DAQmxGetSelfCalSupported := getProc('DAQmxGetSelfCalSupported');
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
  DAQmxGetAIForceReadFromChan := getProc('DAQmxGetAIForceReadFromChan');
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
  DAQmxGetAIIsTEDS := getProc('DAQmxGetAIIsTEDS');
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
  DAQmxGetAIBridgeShuntCalEnable := getProc('DAQmxGetAIBridgeShuntCalEnable');
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
  DAQmxGetAIExcitUseForScaling := getProc('DAQmxGetAIExcitUseForScaling');
  DAQmxSetAIExcitUseForScaling := getProc('DAQmxSetAIExcitUseForScaling');
  DAQmxResetAIExcitUseForScaling := getProc('DAQmxResetAIExcitUseForScaling');
  DAQmxGetAIExcitUseMultiplexed := getProc('DAQmxGetAIExcitUseMultiplexed');
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
  DAQmxGetAIACExcitSyncEnable := getProc('DAQmxGetAIACExcitSyncEnable');
  DAQmxSetAIACExcitSyncEnable := getProc('DAQmxSetAIACExcitSyncEnable');
  DAQmxResetAIACExcitSyncEnable := getProc('DAQmxResetAIACExcitSyncEnable');
  DAQmxGetAIACExcitWireMode := getProc('DAQmxGetAIACExcitWireMode');
  DAQmxSetAIACExcitWireMode := getProc('DAQmxSetAIACExcitWireMode');
  DAQmxResetAIACExcitWireMode := getProc('DAQmxResetAIACExcitWireMode');
  DAQmxGetAIAtten := getProc('DAQmxGetAIAtten');
  DAQmxSetAIAtten := getProc('DAQmxSetAIAtten');
  DAQmxResetAIAtten := getProc('DAQmxResetAIAtten');
  DAQmxGetAILowpassEnable := getProc('DAQmxGetAILowpassEnable');
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
  DAQmxGetAIDitherEnable := getProc('DAQmxGetAIDitherEnable');
  DAQmxSetAIDitherEnable := getProc('DAQmxSetAIDitherEnable');
  DAQmxResetAIDitherEnable := getProc('DAQmxResetAIDitherEnable');
  DAQmxGetAIChanCalHasValidCalInfo := getProc('DAQmxGetAIChanCalHasValidCalInfo');
  DAQmxGetAIChanCalEnableCal := getProc('DAQmxGetAIChanCalEnableCal');
  DAQmxSetAIChanCalEnableCal := getProc('DAQmxSetAIChanCalEnableCal');
  DAQmxResetAIChanCalEnableCal := getProc('DAQmxResetAIChanCalEnableCal');
  DAQmxGetAIChanCalApplyCalIfExp := getProc('DAQmxGetAIChanCalApplyCalIfExp');
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
  DAQmxGetAISampAndHoldEnable := getProc('DAQmxGetAISampAndHoldEnable');
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
  DAQmxGetAIMemMapEnable := getProc('DAQmxGetAIMemMapEnable');
  DAQmxSetAIMemMapEnable := getProc('DAQmxSetAIMemMapEnable');
  DAQmxResetAIMemMapEnable := getProc('DAQmxResetAIMemMapEnable');
  DAQmxGetAIRawDataCompressionType := getProc('DAQmxGetAIRawDataCompressionType');
  DAQmxSetAIRawDataCompressionType := getProc('DAQmxSetAIRawDataCompressionType');
  DAQmxResetAIRawDataCompressionType := getProc('DAQmxResetAIRawDataCompressionType');
  DAQmxGetAILossyLSBRemovalCompressedSampSize := getProc('DAQmxGetAILossyLSBRemovalCompressedSampSize');
  DAQmxSetAILossyLSBRemovalCompressedSampSize := getProc('DAQmxSetAILossyLSBRemovalCompressedSampSize');
  DAQmxResetAILossyLSBRemovalCompressedSampSize := getProc('DAQmxResetAILossyLSBRemovalCompressedSampSize');
  DAQmxGetAIDevScalingCoeff := getProc('DAQmxGetAIDevScalingCoeff');
  DAQmxGetAIEnhancedAliasRejectionEnable := getProc('DAQmxGetAIEnhancedAliasRejectionEnable');
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
  DAQmxGetAODACRefConnToGnd := getProc('DAQmxGetAODACRefConnToGnd');
  DAQmxSetAODACRefConnToGnd := getProc('DAQmxSetAODACRefConnToGnd');
  DAQmxResetAODACRefConnToGnd := getProc('DAQmxResetAODACRefConnToGnd');
  DAQmxGetAODACRefAllowConnToGnd := getProc('DAQmxGetAODACRefAllowConnToGnd');
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
  DAQmxGetAOReglitchEnable := getProc('DAQmxGetAOReglitchEnable');
  DAQmxSetAOReglitchEnable := getProc('DAQmxSetAOReglitchEnable');
  DAQmxResetAOReglitchEnable := getProc('DAQmxResetAOReglitchEnable');
  DAQmxGetAOGain := getProc('DAQmxGetAOGain');
  DAQmxSetAOGain := getProc('DAQmxSetAOGain');
  DAQmxResetAOGain := getProc('DAQmxResetAOGain');
  DAQmxGetAOUseOnlyOnBrdMem := getProc('DAQmxGetAOUseOnlyOnBrdMem');
  DAQmxSetAOUseOnlyOnBrdMem := getProc('DAQmxSetAOUseOnlyOnBrdMem');
  DAQmxResetAOUseOnlyOnBrdMem := getProc('DAQmxResetAOUseOnlyOnBrdMem');
  DAQmxGetAODataXferMech := getProc('DAQmxGetAODataXferMech');
  DAQmxSetAODataXferMech := getProc('DAQmxSetAODataXferMech');
  DAQmxResetAODataXferMech := getProc('DAQmxResetAODataXferMech');
  DAQmxGetAODataXferReqCond := getProc('DAQmxGetAODataXferReqCond');
  DAQmxSetAODataXferReqCond := getProc('DAQmxSetAODataXferReqCond');
  DAQmxResetAODataXferReqCond := getProc('DAQmxResetAODataXferReqCond');
  DAQmxGetAOMemMapEnable := getProc('DAQmxGetAOMemMapEnable');
  DAQmxSetAOMemMapEnable := getProc('DAQmxSetAOMemMapEnable');
  DAQmxResetAOMemMapEnable := getProc('DAQmxResetAOMemMapEnable');
  DAQmxGetAODevScalingCoeff := getProc('DAQmxGetAODevScalingCoeff');
  DAQmxGetAOEnhancedImageRejectionEnable := getProc('DAQmxGetAOEnhancedImageRejectionEnable');
  DAQmxSetAOEnhancedImageRejectionEnable := getProc('DAQmxSetAOEnhancedImageRejectionEnable');
  DAQmxResetAOEnhancedImageRejectionEnable := getProc('DAQmxResetAOEnhancedImageRejectionEnable');
  DAQmxGetDIInvertLines := getProc('DAQmxGetDIInvertLines');
  DAQmxSetDIInvertLines := getProc('DAQmxSetDIInvertLines');
  DAQmxResetDIInvertLines := getProc('DAQmxResetDIInvertLines');
  DAQmxGetDINumLines := getProc('DAQmxGetDINumLines');
  DAQmxGetDIDigFltrEnable := getProc('DAQmxGetDIDigFltrEnable');
  DAQmxSetDIDigFltrEnable := getProc('DAQmxSetDIDigFltrEnable');
  DAQmxResetDIDigFltrEnable := getProc('DAQmxResetDIDigFltrEnable');
  DAQmxGetDIDigFltrMinPulseWidth := getProc('DAQmxGetDIDigFltrMinPulseWidth');
  DAQmxSetDIDigFltrMinPulseWidth := getProc('DAQmxSetDIDigFltrMinPulseWidth');
  DAQmxResetDIDigFltrMinPulseWidth := getProc('DAQmxResetDIDigFltrMinPulseWidth');
  DAQmxGetDITristate := getProc('DAQmxGetDITristate');
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
  DAQmxGetDIMemMapEnable := getProc('DAQmxGetDIMemMapEnable');
  DAQmxSetDIMemMapEnable := getProc('DAQmxSetDIMemMapEnable');
  DAQmxResetDIMemMapEnable := getProc('DAQmxResetDIMemMapEnable');
  DAQmxGetDIAcquireOn := getProc('DAQmxGetDIAcquireOn');
  DAQmxSetDIAcquireOn := getProc('DAQmxSetDIAcquireOn');
  DAQmxResetDIAcquireOn := getProc('DAQmxResetDIAcquireOn');
  DAQmxGetDOOutputDriveType := getProc('DAQmxGetDOOutputDriveType');
  DAQmxSetDOOutputDriveType := getProc('DAQmxSetDOOutputDriveType');
  DAQmxResetDOOutputDriveType := getProc('DAQmxResetDOOutputDriveType');
  DAQmxGetDOInvertLines := getProc('DAQmxGetDOInvertLines');
  DAQmxSetDOInvertLines := getProc('DAQmxSetDOInvertLines');
  DAQmxResetDOInvertLines := getProc('DAQmxResetDOInvertLines');
  DAQmxGetDONumLines := getProc('DAQmxGetDONumLines');
  DAQmxGetDOTristate := getProc('DAQmxGetDOTristate');
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
  DAQmxGetDOUseOnlyOnBrdMem := getProc('DAQmxGetDOUseOnlyOnBrdMem');
  DAQmxSetDOUseOnlyOnBrdMem := getProc('DAQmxSetDOUseOnlyOnBrdMem');
  DAQmxResetDOUseOnlyOnBrdMem := getProc('DAQmxResetDOUseOnlyOnBrdMem');
  DAQmxGetDODataXferMech := getProc('DAQmxGetDODataXferMech');
  DAQmxSetDODataXferMech := getProc('DAQmxSetDODataXferMech');
  DAQmxResetDODataXferMech := getProc('DAQmxResetDODataXferMech');
  DAQmxGetDODataXferReqCond := getProc('DAQmxGetDODataXferReqCond');
  DAQmxSetDODataXferReqCond := getProc('DAQmxSetDODataXferReqCond');
  DAQmxResetDODataXferReqCond := getProc('DAQmxResetDODataXferReqCond');
  DAQmxGetDOMemMapEnable := getProc('DAQmxGetDOMemMapEnable');
  DAQmxSetDOMemMapEnable := getProc('DAQmxSetDOMemMapEnable');
  DAQmxResetDOMemMapEnable := getProc('DAQmxResetDOMemMapEnable');
  DAQmxGetDOGenerateOn := getProc('DAQmxGetDOGenerateOn');
  DAQmxSetDOGenerateOn := getProc('DAQmxSetDOGenerateOn');
end;


procedure InitNIlib2;
begin
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
  DAQmxGetCIFreqDigFltrEnable := getProc('DAQmxGetCIFreqDigFltrEnable');
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
  DAQmxGetCIFreqDigSyncEnable := getProc('DAQmxGetCIFreqDigSyncEnable');
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
  DAQmxGetCIPeriodDigFltrEnable := getProc('DAQmxGetCIPeriodDigFltrEnable');
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
  DAQmxGetCIPeriodDigSyncEnable := getProc('DAQmxGetCIPeriodDigSyncEnable');
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
  DAQmxGetCICountEdgesCountDirDigFltrEnable := getProc('DAQmxGetCICountEdgesCountDirDigFltrEnable');
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
  DAQmxGetCICountEdgesCountDirDigSyncEnable := getProc('DAQmxGetCICountEdgesCountDirDigSyncEnable');
  DAQmxSetCICountEdgesCountDirDigSyncEnable := getProc('DAQmxSetCICountEdgesCountDirDigSyncEnable');
  DAQmxResetCICountEdgesCountDirDigSyncEnable := getProc('DAQmxResetCICountEdgesCountDirDigSyncEnable');
  DAQmxGetCICountEdgesInitialCnt := getProc('DAQmxGetCICountEdgesInitialCnt');
  DAQmxSetCICountEdgesInitialCnt := getProc('DAQmxSetCICountEdgesInitialCnt');
  DAQmxResetCICountEdgesInitialCnt := getProc('DAQmxResetCICountEdgesInitialCnt');
  DAQmxGetCICountEdgesActiveEdge := getProc('DAQmxGetCICountEdgesActiveEdge');
  DAQmxSetCICountEdgesActiveEdge := getProc('DAQmxSetCICountEdgesActiveEdge');
  DAQmxResetCICountEdgesActiveEdge := getProc('DAQmxResetCICountEdgesActiveEdge');
  DAQmxGetCICountEdgesDigFltrEnable := getProc('DAQmxGetCICountEdgesDigFltrEnable');
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
  DAQmxGetCICountEdgesDigSyncEnable := getProc('DAQmxGetCICountEdgesDigSyncEnable');
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
  DAQmxGetCIEncoderAInputDigFltrEnable := getProc('DAQmxGetCIEncoderAInputDigFltrEnable');
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
  DAQmxGetCIEncoderAInputDigSyncEnable := getProc('DAQmxGetCIEncoderAInputDigSyncEnable');
  DAQmxSetCIEncoderAInputDigSyncEnable := getProc('DAQmxSetCIEncoderAInputDigSyncEnable');
  DAQmxResetCIEncoderAInputDigSyncEnable := getProc('DAQmxResetCIEncoderAInputDigSyncEnable');
  DAQmxGetCIEncoderBInputTerm := getProc('DAQmxGetCIEncoderBInputTerm');
  DAQmxSetCIEncoderBInputTerm := getProc('DAQmxSetCIEncoderBInputTerm');
  DAQmxResetCIEncoderBInputTerm := getProc('DAQmxResetCIEncoderBInputTerm');
  DAQmxGetCIEncoderBInputDigFltrEnable := getProc('DAQmxGetCIEncoderBInputDigFltrEnable');
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
  DAQmxGetCIEncoderBInputDigSyncEnable := getProc('DAQmxGetCIEncoderBInputDigSyncEnable');
  DAQmxSetCIEncoderBInputDigSyncEnable := getProc('DAQmxSetCIEncoderBInputDigSyncEnable');
  DAQmxResetCIEncoderBInputDigSyncEnable := getProc('DAQmxResetCIEncoderBInputDigSyncEnable');
  DAQmxGetCIEncoderZInputTerm := getProc('DAQmxGetCIEncoderZInputTerm');
  DAQmxSetCIEncoderZInputTerm := getProc('DAQmxSetCIEncoderZInputTerm');
  DAQmxResetCIEncoderZInputTerm := getProc('DAQmxResetCIEncoderZInputTerm');
  DAQmxGetCIEncoderZInputDigFltrEnable := getProc('DAQmxGetCIEncoderZInputDigFltrEnable');
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
  DAQmxGetCIEncoderZInputDigSyncEnable := getProc('DAQmxGetCIEncoderZInputDigSyncEnable');
  DAQmxSetCIEncoderZInputDigSyncEnable := getProc('DAQmxSetCIEncoderZInputDigSyncEnable');
  DAQmxResetCIEncoderZInputDigSyncEnable := getProc('DAQmxResetCIEncoderZInputDigSyncEnable');
  DAQmxGetCIEncoderZIndexEnable := getProc('DAQmxGetCIEncoderZIndexEnable');
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
  DAQmxGetCIPulseWidthDigFltrEnable := getProc('DAQmxGetCIPulseWidthDigFltrEnable');
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
  DAQmxGetCIPulseWidthDigSyncEnable := getProc('DAQmxGetCIPulseWidthDigSyncEnable');
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
  DAQmxGetCITwoEdgeSepFirstDigFltrEnable := getProc('DAQmxGetCITwoEdgeSepFirstDigFltrEnable');
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
  DAQmxGetCITwoEdgeSepFirstDigSyncEnable := getProc('DAQmxGetCITwoEdgeSepFirstDigSyncEnable');
  DAQmxSetCITwoEdgeSepFirstDigSyncEnable := getProc('DAQmxSetCITwoEdgeSepFirstDigSyncEnable');

  DAQmxResetCITwoEdgeSepFirstDigSyncEnable := getProc('DAQmxResetCITwoEdgeSepFirstDigSyncEnable');
  DAQmxGetCITwoEdgeSepSecondTerm := getProc('DAQmxGetCITwoEdgeSepSecondTerm');
  DAQmxSetCITwoEdgeSepSecondTerm := getProc('DAQmxSetCITwoEdgeSepSecondTerm');
  DAQmxResetCITwoEdgeSepSecondTerm := getProc('DAQmxResetCITwoEdgeSepSecondTerm');
  DAQmxGetCITwoEdgeSepSecondEdge := getProc('DAQmxGetCITwoEdgeSepSecondEdge');
  DAQmxSetCITwoEdgeSepSecondEdge := getProc('DAQmxSetCITwoEdgeSepSecondEdge');
  DAQmxResetCITwoEdgeSepSecondEdge := getProc('DAQmxResetCITwoEdgeSepSecondEdge');
  DAQmxGetCITwoEdgeSepSecondDigFltrEnable := getProc('DAQmxGetCITwoEdgeSepSecondDigFltrEnable');
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
  DAQmxGetCITwoEdgeSepSecondDigSyncEnable := getProc('DAQmxGetCITwoEdgeSepSecondDigSyncEnable');
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
  DAQmxGetCISemiPeriodDigFltrEnable := getProc('DAQmxGetCISemiPeriodDigFltrEnable');
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
  DAQmxGetCISemiPeriodDigSyncEnable := getProc('DAQmxGetCISemiPeriodDigSyncEnable');
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
  DAQmxGetCICtrTimebaseDigFltrEnable := getProc('DAQmxGetCICtrTimebaseDigFltrEnable');
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
  DAQmxGetCICtrTimebaseDigSyncEnable := getProc('DAQmxGetCICtrTimebaseDigSyncEnable');
  DAQmxSetCICtrTimebaseDigSyncEnable := getProc('DAQmxSetCICtrTimebaseDigSyncEnable');
  DAQmxResetCICtrTimebaseDigSyncEnable := getProc('DAQmxResetCICtrTimebaseDigSyncEnable');
  DAQmxGetCICount := getProc('DAQmxGetCICount');
  DAQmxGetCIOutputState := getProc('DAQmxGetCIOutputState');
  DAQmxGetCITCReached := getProc('DAQmxGetCITCReached');
  DAQmxGetCICtrTimebaseMasterTimebaseDiv := getProc('DAQmxGetCICtrTimebaseMasterTimebaseDiv');
  DAQmxSetCICtrTimebaseMasterTimebaseDiv := getProc('DAQmxSetCICtrTimebaseMasterTimebaseDiv');
  DAQmxResetCICtrTimebaseMasterTimebaseDiv := getProc('DAQmxResetCICtrTimebaseMasterTimebaseDiv');
  DAQmxGetCIDataXferMech := getProc('DAQmxGetCIDataXferMech');
  DAQmxSetCIDataXferMech := getProc('DAQmxSetCIDataXferMech');
  DAQmxResetCIDataXferMech := getProc('DAQmxResetCIDataXferMech');
  DAQmxGetCINumPossiblyInvalidSamps := getProc('DAQmxGetCINumPossiblyInvalidSamps');
  DAQmxGetCIDupCountPrevent := getProc('DAQmxGetCIDupCountPrevent');
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
  DAQmxGetCOCtrTimebaseDigFltrEnable := getProc('DAQmxGetCOCtrTimebaseDigFltrEnable');
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
  DAQmxGetCOCtrTimebaseDigSyncEnable := getProc('DAQmxGetCOCtrTimebaseDigSyncEnable');
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
  DAQmxGetCOPulseDone := getProc('DAQmxGetCOPulseDone');
  DAQmxGetCOPrescaler := getProc('DAQmxGetCOPrescaler');
  DAQmxSetCOPrescaler := getProc('DAQmxSetCOPrescaler');
  DAQmxResetCOPrescaler := getProc('DAQmxResetCOPrescaler');
  DAQmxGetCORdyForNewVal := getProc('DAQmxGetCORdyForNewVal');
  DAQmxGetChanType := getProc('DAQmxGetChanType');
  DAQmxGetPhysicalChanName := getProc('DAQmxGetPhysicalChanName');
  DAQmxSetPhysicalChanName := getProc('DAQmxSetPhysicalChanName');
  DAQmxGetChanDescr := getProc('DAQmxGetChanDescr');
  DAQmxSetChanDescr := getProc('DAQmxSetChanDescr');
  DAQmxResetChanDescr := getProc('DAQmxResetChanDescr');
  DAQmxGetChanIsGlobal := getProc('DAQmxGetChanIsGlobal');
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
  DAQmxGetExportedHshkEventInterlockedAssertOnStart := getProc('DAQmxGetExportedHshkEventInterlockedAssertOnStart');
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

procedure InitNIlib3;
begin
  DAQmxGetDevIsSimulated := getProc('DAQmxGetDevIsSimulated');
  DAQmxGetDevProductCategory := getProc('DAQmxGetDevProductCategory');
  DAQmxGetDevProductType := getProc('DAQmxGetDevProductType');
  DAQmxGetDevProductNum := getProc('DAQmxGetDevProductNum');
  DAQmxGetDevSerialNum := getProc('DAQmxGetDevSerialNum');
  DAQmxGetDevChassisModuleDevNames := getProc('DAQmxGetDevChassisModuleDevNames');
  DAQmxGetDevAnlgTrigSupported := getProc('DAQmxGetDevAnlgTrigSupported');
  DAQmxGetDevDigTrigSupported := getProc('DAQmxGetDevDigTrigSupported');
  DAQmxGetDevAIPhysicalChans := getProc('DAQmxGetDevAIPhysicalChans');
  DAQmxGetDevAIMaxSingleChanRate := getProc('DAQmxGetDevAIMaxSingleChanRate');
  DAQmxGetDevAIMaxMultiChanRate := getProc('DAQmxGetDevAIMaxMultiChanRate');
  DAQmxGetDevAIMinRate := getProc('DAQmxGetDevAIMinRate');
  DAQmxGetDevAISimultaneousSamplingSupported := getProc('DAQmxGetDevAISimultaneousSamplingSupported');
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
  DAQmxGetDevAOSampClkSupported := getProc('DAQmxGetDevAOSampClkSupported');
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
  DAQmxGetDevCISampClkSupported := getProc('DAQmxGetDevCISampClkSupported');
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
  DAQmxGetReadReadAllAvailSamp := getProc('DAQmxGetReadReadAllAvailSamp');
  DAQmxSetReadReadAllAvailSamp := getProc('DAQmxSetReadReadAllAvailSamp');
  DAQmxResetReadReadAllAvailSamp := getProc('DAQmxResetReadReadAllAvailSamp');
  DAQmxGetReadAutoStart := getProc('DAQmxGetReadAutoStart');
  DAQmxSetReadAutoStart := getProc('DAQmxSetReadAutoStart');
  DAQmxResetReadAutoStart := getProc('DAQmxResetReadAutoStart');
  DAQmxGetReadOverWrite := getProc('DAQmxGetReadOverWrite');
  DAQmxSetReadOverWrite := getProc('DAQmxSetReadOverWrite');
  DAQmxResetReadOverWrite := getProc('DAQmxResetReadOverWrite');
  DAQmxGetReadCurrReadPos := getProc('DAQmxGetReadCurrReadPos');
  DAQmxGetReadAvailSampPerChan := getProc('DAQmxGetReadAvailSampPerChan');
  DAQmxGetReadTotalSampPerChanAcquired := getProc('DAQmxGetReadTotalSampPerChanAcquired');
  DAQmxGetReadOverloadedChansExist := getProc('DAQmxGetReadOverloadedChansExist');
  DAQmxGetReadOverloadedChans := getProc('DAQmxGetReadOverloadedChans');
  DAQmxGetReadChangeDetectHasOverflowed := getProc('DAQmxGetReadChangeDetectHasOverflowed');
  DAQmxGetReadRawDataWidth := getProc('DAQmxGetReadRawDataWidth');
  DAQmxGetReadNumChans := getProc('DAQmxGetReadNumChans');
  DAQmxGetReadDigitalLinesBytesPerChan := getProc('DAQmxGetReadDigitalLinesBytesPerChan');
  DAQmxGetReadWaitMode := getProc('DAQmxGetReadWaitMode');
  DAQmxSetReadWaitMode := getProc('DAQmxSetReadWaitMode');
  DAQmxResetReadWaitMode := getProc('DAQmxResetReadWaitMode');
  DAQmxGetReadSleepTime := getProc('DAQmxGetReadSleepTime');
  DAQmxSetReadSleepTime := getProc('DAQmxSetReadSleepTime');
  DAQmxResetReadSleepTime := getProc('DAQmxResetReadSleepTime');
  DAQmxGetRealTimeConvLateErrorsToWarnings := getProc('DAQmxGetRealTimeConvLateErrorsToWarnings');
  DAQmxSetRealTimeConvLateErrorsToWarnings := getProc('DAQmxSetRealTimeConvLateErrorsToWarnings');
  DAQmxResetRealTimeConvLateErrorsToWarnings := getProc('DAQmxResetRealTimeConvLateErrorsToWarnings');
  DAQmxGetRealTimeNumOfWarmupIters := getProc('DAQmxGetRealTimeNumOfWarmupIters');
  DAQmxSetRealTimeNumOfWarmupIters := getProc('DAQmxSetRealTimeNumOfWarmupIters');
  DAQmxResetRealTimeNumOfWarmupIters := getProc('DAQmxResetRealTimeNumOfWarmupIters');
  DAQmxGetRealTimeWaitForNextSampClkWaitMode := getProc('DAQmxGetRealTimeWaitForNextSampClkWaitMode');
  DAQmxSetRealTimeWaitForNextSampClkWaitMode := getProc('DAQmxSetRealTimeWaitForNextSampClkWaitMode');
  DAQmxResetRealTimeWaitForNextSampClkWaitMode := getProc('DAQmxResetRealTimeWaitForNextSampClkWaitMode');
  DAQmxGetRealTimeReportMissedSamp := getProc('DAQmxGetRealTimeReportMissedSamp');
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
  DAQmxGetSwitchDevAutoConnAnlgBus := getProc('DAQmxGetSwitchDevAutoConnAnlgBus');
  DAQmxSetSwitchDevAutoConnAnlgBus := getProc('DAQmxSetSwitchDevAutoConnAnlgBus');
  DAQmxGetSwitchDevPwrDownLatchRelaysAfterSettling := getProc('DAQmxGetSwitchDevPwrDownLatchRelaysAfterSettling');
  DAQmxSetSwitchDevPwrDownLatchRelaysAfterSettling := getProc('DAQmxSetSwitchDevPwrDownLatchRelaysAfterSettling');
  DAQmxGetSwitchDevSettled := getProc('DAQmxGetSwitchDevSettled');
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
  DAQmxGetSwitchScanWaitingForAdv := getProc('DAQmxGetSwitchScanWaitingForAdv');
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
  DAQmxGetTaskComplete := getProc('DAQmxGetTaskComplete');
  DAQmxGetSampQuantSampMode := getProc('DAQmxGetSampQuantSampMode');
  DAQmxSetSampQuantSampMode := getProc('DAQmxSetSampQuantSampMode');
  DAQmxResetSampQuantSampMode := getProc('DAQmxResetSampQuantSampMode');
  DAQmxGetSampQuantSampPerChan := getProc('DAQmxGetSampQuantSampPerChan');
  DAQmxSetSampQuantSampPerChan := getProc('DAQmxSetSampQuantSampPerChan');
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
  DAQmxGetSampClkDigFltrEnable := getProc('DAQmxGetSampClkDigFltrEnable');
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
  DAQmxGetSampClkDigSyncEnable := getProc('DAQmxGetSampClkDigSyncEnable');
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
  DAQmxGetOnDemandSimultaneousAOEnable := getProc('DAQmxGetOnDemandSimultaneousAOEnable');
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
  DAQmxGetDigEdgeStartTrigDigFltrEnable := getProc('DAQmxGetDigEdgeStartTrigDigFltrEnable');
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
  DAQmxGetDigEdgeStartTrigDigSyncEnable := getProc('DAQmxGetDigEdgeStartTrigDigSyncEnable');
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
  DAQmxGetStartTrigRetriggerable := getProc('DAQmxGetStartTrigRetriggerable');
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
  DAQmxGetDigEdgeAdvTrigDigFltrEnable := getProc('DAQmxGetDigEdgeAdvTrigDigFltrEnable');
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
  DAQmxGetDigLvlPauseTrigDigFltrEnable := getProc('DAQmxGetDigLvlPauseTrigDigFltrEnable');
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
  DAQmxGetDigLvlPauseTrigDigSyncEnable := getProc('DAQmxGetDigLvlPauseTrigDigSyncEnable');
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
  DAQmxGetDigEdgeArmStartTrigDigFltrEnable := getProc('DAQmxGetDigEdgeArmStartTrigDigFltrEnable');
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
  DAQmxGetDigEdgeArmStartTrigDigSyncEnable := getProc('DAQmxGetDigEdgeArmStartTrigDigSyncEnable');
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
  DAQmxGetWatchdogHasExpired := getProc('DAQmxGetWatchdogHasExpired');
  DAQmxGetWriteRelativeTo := getProc('DAQmxGetWriteRelativeTo');
  DAQmxSetWriteRelativeTo := getProc('DAQmxSetWriteRelativeTo');
  DAQmxResetWriteRelativeTo := getProc('DAQmxResetWriteRelativeTo');
  DAQmxGetWriteOffset := getProc('DAQmxGetWriteOffset');
  DAQmxSetWriteOffset := getProc('DAQmxSetWriteOffset');
  DAQmxResetWriteOffset := getProc('DAQmxResetWriteOffset');
  DAQmxGetWriteRegenMode := getProc('DAQmxGetWriteRegenMode');
  DAQmxSetWriteRegenMode := getProc('DAQmxSetWriteRegenMode');
  DAQmxResetWriteRegenMode := getProc('DAQmxResetWriteRegenMode');
  DAQmxGetWriteCurrWritePos := getProc('DAQmxGetWriteCurrWritePos');
  DAQmxGetWriteSpaceAvail := getProc('DAQmxGetWriteSpaceAvail');
  DAQmxGetWriteTotalSampPerChanGenerated := getProc('DAQmxGetWriteTotalSampPerChanGenerated');
  DAQmxGetWriteRawDataWidth := getProc('DAQmxGetWriteRawDataWidth');
  DAQmxGetWriteNumChans := getProc('DAQmxGetWriteNumChans');
  DAQmxGetWriteWaitMode := getProc('DAQmxGetWriteWaitMode');
  DAQmxSetWriteWaitMode := getProc('DAQmxSetWriteWaitMode');

  DAQmxResetWriteWaitMode := getProc('DAQmxResetWriteWaitMode');
  DAQmxGetWriteSleepTime := getProc('DAQmxGetWriteSleepTime');
  DAQmxSetWriteSleepTime := getProc('DAQmxSetWriteSleepTime');
  DAQmxResetWriteSleepTime := getProc('DAQmxResetWriteSleepTime');
  DAQmxGetWriteNextWriteIsLast := getProc('DAQmxGetWriteNextWriteIsLast');
  DAQmxSetWriteNextWriteIsLast := getProc('DAQmxSetWriteNextWriteIsLast');
  DAQmxResetWriteNextWriteIsLast := getProc('DAQmxResetWriteNextWriteIsLast');
  DAQmxGetWriteDigitalLinesBytesPerChan := getProc('DAQmxGetWriteDigitalLinesBytesPerChan');
  DAQmxGetPhysicalChanAITermCfgs := getProc('DAQmxGetPhysicalChanAITermCfgs');
  DAQmxGetPhysicalChanAOTermCfgs := getProc('DAQmxGetPhysicalChanAOTermCfgs');
  DAQmxGetPhysicalChanDIPortWidth := getProc('DAQmxGetPhysicalChanDIPortWidth');
  DAQmxGetPhysicalChanDISampClkSupported := getProc('DAQmxGetPhysicalChanDISampClkSupported');
  DAQmxGetPhysicalChanDIChangeDetectSupported := getProc('DAQmxGetPhysicalChanDIChangeDetectSupported');
  DAQmxGetPhysicalChanDOPortWidth := getProc('DAQmxGetPhysicalChanDOPortWidth');
  DAQmxGetPhysicalChanDOSampClkSupported := getProc('DAQmxGetPhysicalChanDOSampClkSupported');
  DAQmxGetPhysicalChanTEDSMfgID := getProc('DAQmxGetPhysicalChanTEDSMfgID');
  DAQmxGetPhysicalChanTEDSModelNum := getProc('DAQmxGetPhysicalChanTEDSModelNum');
  DAQmxGetPhysicalChanTEDSSerialNum := getProc('DAQmxGetPhysicalChanTEDSSerialNum');
  DAQmxGetPhysicalChanTEDSVersionNum := getProc('DAQmxGetPhysicalChanTEDSVersionNum');
  DAQmxGetPhysicalChanTEDSVersionLetter := getProc('DAQmxGetPhysicalChanTEDSVersionLetter');
  DAQmxGetPhysicalChanTEDSBitStream := getProc('DAQmxGetPhysicalChanTEDSBitStream');
  DAQmxGetPhysicalChanTEDSTemplateIDs := getProc('DAQmxGetPhysicalChanTEDSTemplateIDs');
  DAQmxGetPersistedTaskAuthor := getProc('DAQmxGetPersistedTaskAuthor');
  DAQmxGetPersistedTaskAllowInteractiveEditing := getProc('DAQmxGetPersistedTaskAllowInteractiveEditing');
  DAQmxGetPersistedTaskAllowInteractiveDeletion := getProc('DAQmxGetPersistedTaskAllowInteractiveDeletion');
  DAQmxGetPersistedChanAuthor := getProc('DAQmxGetPersistedChanAuthor');
  DAQmxGetPersistedChanAllowInteractiveEditing := getProc('DAQmxGetPersistedChanAllowInteractiveEditing');
  DAQmxGetPersistedChanAllowInteractiveDeletion := getProc('DAQmxGetPersistedChanAllowInteractiveDeletion');
  DAQmxGetPersistedScaleAuthor := getProc('DAQmxGetPersistedScaleAuthor');
  DAQmxGetPersistedScaleAllowInteractiveEditing := getProc('DAQmxGetPersistedScaleAllowInteractiveEditing');
  DAQmxGetPersistedScaleAllowInteractiveDeletion := getProc('DAQmxGetPersistedScaleAllowInteractiveDeletion');
  DAQmxGetSampClkTimingResponseMode := getProc('DAQmxGetSampClkTimingResponseMode');
  DAQmxSetSampClkTimingResponseMode := getProc('DAQmxSetSampClkTimingResponseMode');
  DAQmxResetSampClkTimingResponseMode := getProc('DAQmxResetSampClkTimingResponseMode');

end;

function InitNIlib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('nicaiu.dll');
  //messageCentral('InitNIlib='+Int64str(hh));
  result:=(hh<>0);

  if not result then exit;

  initNILib1;
  initNILib2;
  initNIlib3;
end;

end.


