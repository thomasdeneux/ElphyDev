// Itcmm.h
// Delphi translation by Gérard Sadoc (CNRS-UNIC) January 2004
// gerard.sadoc@unic.cnrs-gif.fr

Unit ITCmm;

Interface
{$IFDEF WIN64}
{$A8}
{$ENDIF}

Uses Windows,util1,debug0;

Const
  MAX_DEVICE_TYPE_NUMBER       	= 4;
  ITC16_ID		       	= 0;
  ITC16_MAX_DEVICE_NUMBER      	= 16;
  ITC18_ID		        = 1;
  ITC18_MAX_DEVICE_NUMBER      	= 16;
  ITC1600_ID			= 2;
  ITC1600_MAX_DEVICE_NUMBER     = 16;
  ITC00_ID			= 3;
  ITC00_MAX_DEVICE_NUMBER	= 16;
  ITC_MAX_DEVICE_NUMBER		= 16;

  NORMAL_MODE			= 0;
  SMART_MODE 			= 1;

  NUMBER_OF_CHANNEL_GROUPS	= 6;			//Currently 6 are implemented
  MAX_NUMBER_OF_CHANNELS_IN_GROUP	= 32;		//Maximum number

  D2H	 			= 0;		//Input
  H2D				= 1;		//Output
  INPUT_GROUP			= D2H;		//Input
  OUTPUT_GROUP			= H2D;		//Input

  DIGITAL_INPUT	       		= 2;		//Digital Input;
  DIGITAL_OUTPUT	       	= 3;		//Digital Output

  AUX_INPUT			= 4;		//Aux Input
  AUX_OUTPUT			= 5;		//Aux Output

  TEMP_INPUT			= 6;		//Temp Input

//STUB -> check the correct number
  NUMBER_OF_D2H_CHANNELS     	= 32;   	//ITC1600: 8+F+S0+S1+4(AUX)+T == 16 * 2 = 32
  NUMBER_OF_H2D_CHANNELS     	= 15;   	//ITC1600: 4+F+S0+S1 == 7 * 2 = 14 + 1-Host-Aux

//STUB -> Move this object to the Registry
  ITC18_SOFTWARE_SEQUENCE_SIZE	= 4096;

//STUB ->Verify
  ITC16_SOFTWARE_SEQUENCE_SIZE	= 1024;
  ITC1600_SOFTWARE_SEQUENCE_SIZE= 16;
  ITC00_SOFTWARE_SEQUENCE_SIZE	= 16;

  ITC18_NUMBEROFCHANNELS	= 16;	        //4 + 8 + 2 + 1 + 1
  ITC18_NUMBEROFOUTPUTS	        = 7;		//4 + 2 + 1
  ITC18_NUMBEROFINPUTS	        = 9;		//8 + 1

  ITC18_NUMBEROFADCINPUTS       = 8;
  ITC18_NUMBEROFDACOUTPUTS      = 4;
  ITC18_NUMBEROFDIGINPUTS       = 1;
  ITC18_NUMBEROFDIGOUTPUTS      = 2;
  ITC18_NUMBEROFAUXINPUTS       = 0;
  ITC18_NUMBEROFAUXOUTPUTS      = 1;

  ITC18_DA_CH_MASK		= 3;			//4 DA Channels
  ITC18_DO0_CH			= 4;			//DO0
  ITC18_DO1_CH			= 5;			//DO1
  ITC18_AUX_CH		        = 6;			//AUX

  ITC16_NUMBEROFCHANNELS       	= 14;			//4 + 8 + 1 + 1
  ITC16_NUMBEROFOUTPUTS		= 5;			//4 + 1
  ITC16_NUMBEROFINPUTS	        = 9;			//8 + 1
  ITC16_DO_CH			= 4;

  ITC16_NUMBEROFADCINPUTS	 = 8;
  ITC16_NUMBEROFDACOUTPUTS	 = 4;
  ITC16_NUMBEROFDIGINPUTS	 = 1;
  ITC16_NUMBEROFDIGOUTPUTS	 = 1;
  ITC16_NUMBEROFAUXINPUTS	 = 0;
  ITC16_NUMBEROFAUXOUTPUTS	 = 0;

//STUB: Check the numbers
  ITC1600_NUMBEROFCHANNELS	= 47;			//15 + 32
  ITC1600_NUMBEROFINPUTS	= 32;			//(8 AD + 1 Temp + 4 Aux + 3 Dig) * 2
  ITC1600_NUMBEROFOUTPUTS      	= 15;			//(4 + 3) * 2 + 1
  ITC1600_NUMBEROFADCINPUTS	= 16;			//8+8
  ITC1600_NUMBEROFDACOUTPUTS	= 8;			//4+4
  ITC1600_NUMBEROFDIGINPUTS	= 6;			//F+S+S * 2
  ITC1600_NUMBEROFDIGOUTPUTS	= 6;			//F+S+S * 2
  ITC1600_NUMBEROFAUXINPUTS	= 8;			//4+4
  ITC1600_NUMBEROFAUXOUTPUTS	= 1;			//On Host
  ITC1600_NUMBEROFTEMPINPUTS	= 2;			//1+1
  ITC1600_NUMBEROFINPUTGROUPS  	= 11;		        //
  ITC1600_NUMBEROFOUTPUTGROUPS	= 5;		        //(DAC, SD) + (DAC, SD) + FD + FD + HOST

  ITC00_NUMBEROFCHANNELS	= 47;			//15 + 32
  ITC00_NUMBEROFINPUTS		= 32;			//(8 AD + 1 Temp + 4 Aux + 3 Dig) * 2
  ITC00_NUMBEROFOUTPUTS		= 15;			//(4 + 3) * 2 + 1

  ITC00_NUMBEROFADCINPUTS       = 16;			//8+8;
  ITC00_NUMBEROFDACOUTPUTS	= 8;			//4+4;
  ITC00_NUMBEROFDIGINPUTS	= 6;			//F+S+S * 2;
  ITC00_NUMBEROFDIGOUTPUTS	= 6;			//F+S+S * 2;
  ITC00_NUMBEROFAUXINPUTS      	= 8;			//4+4;
  ITC00_NUMBEROFAUXOUTPUTS	= 1;			//On Host;
  ITC00_NUMBEROFTEMPINPUTS	= 2;			//1+1;
  ITC00_NUMBEROFINPUTGROUPS	= 11;         		//;
  ITC00_NUMBEROFOUTPUTGROUPS	= 5;    		//(DAC, SD) + (DAC, SD) + FD + FD + HOST;

//***************************************************************************
//ITC16 CHANNELS
  ITC16_DA0						= 0;
  ITC16_DA1						= 1;
  ITC16_DA2						= 2;
  ITC16_DA3						= 3;
  ITC16_DO						= 4;

  ITC16_AD0						= 0;
  ITC16_AD1						= 1;
  ITC16_AD2						= 2;
  ITC16_AD3						= 3;
  ITC16_AD4						= 4;
  ITC16_AD5						= 5;
  ITC16_AD6						= 6;
  ITC16_AD7						= 7;
  ITC16_DI						= 8;

//***************************************************************************
//ITC18 CHANNELS
  ITC18_DA0						= 0;
  ITC18_DA1						= 1;
  ITC18_DA2						= 2;
  ITC18_DA3						= 3;
  ITC18_DO0						= 4;
  ITC18_DO1						= 5;
  ITC18_AUX						= 6;

  ITC18_AD0						= 0;
  ITC18_AD1						= 1;
  ITC18_AD2						= 2;
  ITC18_AD3						= 3;
  ITC18_AD4						= 4;
  ITC18_AD5						= 5;
  ITC18_AD6						= 6;
  ITC18_AD7						= 7;
  ITC18_DI						= 8;

//***************************************************************************
//ITC1600 CHANNELS

//DACs
  ITC1600_DA0						= 0;		//RACK0
  ITC1600_DA1						= 1;
  ITC1600_DA2						= 2;
  ITC1600_DA3						= 3;
  ITC1600_DA4						= 4;		//RACK1
  ITC1600_DA5						= 5;
  ITC1600_DA6						= 6;
  ITC1600_DA7						= 7;

//Digital outputs
  ITC1600_DOF0					= 8;		//RACK0
  ITC1600_DOS00					= 9;
  ITC1600_DOS01					= 10;
  ITC1600_DOF1					= 11;		//RACK1
  ITC1600_DOS10					= 12;
  ITC1600_DOS11					= 13;
  ITC1600_HOST					= 14;

//ADCs
  ITC1600_AD0		      			= 0;		//RACK0
  ITC1600_AD1		      			= 1;
  ITC1600_AD2		      			= 2;
  ITC1600_AD3		      			= 3;
  ITC1600_AD4		      			= 4;
  ITC1600_AD5		      			= 5;
  ITC1600_AD6		      			= 6;
  ITC1600_AD7		      			= 7;

  ITC1600_AD8 					= 8;		//RACK1
  ITC1600_AD9 					= 9;
  ITC1600_AD10					= 10;
  ITC1600_AD11					= 11;
  ITC1600_AD12					= 12;
  ITC1600_AD13					= 13;
  ITC1600_AD14					= 14;
  ITC1600_AD15					= 15;

//Slow ADCs
  ITC1600_SAD0					= 16;		//RACK0
  ITC1600_SAD1					= 17;
  ITC1600_SAD2					= 18;
  ITC1600_SAD3					= 19;
  ITC1600_SAD4					= 20;		//RACK1
  ITC1600_SAD5					= 21;
  ITC1600_SAD6					= 22;
  ITC1600_SAD7					= 23;

//Temperature
  ITC1600_TEM0					= 24;		//RACK0
  ITC1600_TEM1					= 25;		//RACK1

//Digital Inputs
  ITC1600_DIF0					= 26;		//RACK0
  ITC1600_DIS00					= 27;
  ITC1600_DIS01					= 28;
  ITC1600_DIF1					= 29;		//RACK1
  ITC1600_DIS10					= 30;
  ITC1600_DIS11					= 31;

//***************************************************************************
//ITC00 CHANNELS

//DACs
  ITC00_DA0   					= 0;		//RACK0
  ITC00_DA1   					= 1;
  ITC00_DA2   					= 2;
  ITC00_DA3   					= 3;
  ITC00_DA4   					= 4;		//RACK1
  ITC00_DA5   					= 5;
  ITC00_DA6   					= 6;
  ITC00_DA7   					= 7;

//Digital outputs
  ITC00_DOF0					= 8;		//RACK0
  ITC00_DOS00					= 9;
  ITC00_DOS01					= 10;
  ITC00_DOF1					= 11;		//RACK1
  ITC00_DOS10					= 12;
  ITC00_DOS11					= 13;
  ITC00_HOST					= 14;

//ADCs
  ITC00_AD0   					= 0;		//RACK0
  ITC00_AD1   					= 1;
  ITC00_AD2   					= 2;
  ITC00_AD3   					= 3;
  ITC00_AD4   					= 4;
  ITC00_AD5   					= 5;
  ITC00_AD6   					= 6;
  ITC00_AD7   					= 7;

  ITC00_AD8    					= 8;		//RACK1
  ITC00_AD9    					= 9;
  ITC00_AD10					= 10;
  ITC00_AD11					= 11;
  ITC00_AD12					= 12;
  ITC00_AD13					= 13;
  ITC00_AD14					= 14;
  ITC00_AD15					= 15;

//Slow ADCs
  ITC00_SAD0					= 16;		//RACK0
  ITC00_SAD1					= 17;
  ITC00_SAD2					= 18;
  ITC00_SAD3					= 19;
  ITC00_SAD4					= 20;		//RACK1
  ITC00_SAD5					= 21;
  ITC00_SAD6					= 22;
  ITC00_SAD7					= 23;

//Temperature
  ITC00_TEM0					= 24;		//RACK0
  ITC00_TEM1					= 25;		//RACK1

//Digital Inputs
  ITC00_DIF0					= 26;		//RACK0
  ITC00_DIS00					= 27;
  ITC00_DIS01					= 28;
  ITC00_DIF1					= 29;		//RACK1
  ITC00_DIS10					= 30;
  ITC00_DIS11					= 31;

//***************************************************************************

  ITC18_STANDARD_FUNCTION 		= 0;
  ITC18_PHASESHIFT_FUNCTION 		= 1;
  ITC18_DYNAMICCLAMP_FUNCTION		= 2;
  ITC18_SPECIAL_FUNCTION		= 3;

  ITC1600_STANDARD_FUNCTION 		= 0;
  ITC1600_TEST_FUNCTION	 		= $10;
  ITC1600_STANDARD_DSP			= 0;
  ITC1600_TEST_DSP	       		= 4;
  ITC1600_STANDARD_HOST        		= 0;
  ITC1600_STANDARD_RACK	 		= 0;

  ITC00_STANDARD_FUNCTION 		= 0;
  ITC00_TEST_FUNCTION	       		= $10;
  ITC00_STANDARD_DSP	       		= 0;
  ITC00_TEST_DSP	       		= 4;
  ITC00_STANDARD_HOST 			= 0;
  ITC00_STANDARD_RACK	       		= 0;

//ITC1600 Modes
  ITC1600_INTERNAL_CLOCK       		= $0;
  ITC1600_INTRABOX_CLOCK       		= $1;
  ITC1600_EXTERNAL_CLOCK       		= $2;
  ITC1600_CLOCKMODE_MASK       		= $3;
  ITC1600_PCI1600_RACK 			= $8;

  ITC1600_RACK_RELOAD 			= $10;

  ITC00_INTERNAL_CLOCK 			= $0;
  ITC00_EXTERNAL_CLOCK 			= $1;
  ITC00_INTRABOX_CLOCK 			= $2;
  ITC00_CLOCKMODE_MASK 			= $3;
  ITC00_PCI1600_RACK 	       		= $8;

  ITC00_RACK_RELOAD	       		= $10;

//ITC1600 Digital Input Modes Bit definition
  DI_HEKA_ACTIVE_LOW			= $8000;
  DI_HEKA_LATCHING_MODE			= $4000;
  DI_TRIGIN_ACTIVE_LOW			= $2000;
  DI_TRIGIN_LATCHING_MODE      		= $1000;
  DI_FRONT_3_2_ACTIVE_LOW      		= $0800;
  DI_FRONT_3_2_LATCHING_MODE		= $0400;
  DI_FRONT_1_0_ACTIVE_LOW      		= $0200;
  DI_FRONT_1_0_LATCHING_MODE		= $0100;
  DI_15_12_ACTIVE_LOW			= $0080;
  DI_15_12_LATCHING_MODE       		= $0040;
  DI_11_08_ACTIVE_LOW			= $0020;
  DI_11_08_LATCHING_MODE       		= $0010;
  DI_07_04_ACTIVE_LOW			= $0008;
  DI_07_04_LATCHING_MODE       		= $0004;
  DI_03_00_ACTIVE_LOW			= $0002;
  DI_03_00_LATCHING_MODE       		= $0001;

//***************************************************************************
//Overflow/Underrun Codes
  ITC_READ_OVERFLOW_H		= $00010000;
  ITC_WRITE_UNDERRUN_H		= $00020000;
  ITC_READ_OVERFLOW_S		= $00100000;
  ITC_WRITE_UNDERRUN_S		= $00200000;

  ITC_STOP_CH_ON_OVERFLOW      	= $00000001;	//Stop One Channel
  ITC_STOP_CH_ON_UNDERRUN      	= $00000002;

  ITC_STOP_CH_ON_COUNT		= $00000010;
  ITC_STOP_PR_ON_COUNT		= $00000020;

  ITC_STOP_DR_ON_OVERFLOW      	= $00000100;	//Stop One Direction
  ITC_STOP_DR_ON_UNDERRUN      	= $00000200;

  ITC_STOP_ALL_ON_OVERFLOW	= $00001000;	//Stop System (Hardware STOP)
  ITC_STOP_ALL_ON_UNDERRUN	= $00002000;

//***************************************************************************
//Predefined Vendor IDs (Software Keys MSW)
  PaulKey		       	= $5053;
  HekaKey		       	= $4845;
  UicKey		       	= $5543;
  InstruKey		       	= $4954;
  AlexKey		       	= $4142;

//Predefined Program IDs (Software Keys LSW)
  EcellKey		        = $4142;
  SampleKey		       	= $5470;
  TestKey		       	= $4444;
  TestSuiteKey		       	= $5453;
  DemoKey			= $4445;
  IgorKey			= $4947;
  CalibrationKey		= $4341;
//***************************************************************************

  ITC_EMPTY			= 0;
  ITC_RESERVE			= $80000000;
  ITC_INIT_FLAG			= $00008000;
  ITC_RACK_FLAG			= $00004000;
  ITC_FUNCTION_MASK		= $00000FFF;

  RUN_STATE		      	= $10;
  ERROR_STATE		        = $80000000;
  DEAD_STATE			= $00;
  EMPTY_INPUT		     	= $01;
  EMPTY_OUTPUT		        = $02;
//***************************************************************************


//Specification for Hardware Configuration
type
  HWFunction=
    record
      Mode: longWord;			//Mode: 0 - Internal Clock; 1 - Intrabox Clock; 2 - External Clock
      		    			//Mode -1; - Do not reload
		    			//For ITC18 - LCA_MODE
      U2F_File: pointer;	        //U2F File name -> may be NULL
      SizeOfSpecialFunction: longword;	//Sizeof SpecialFunction
      SpecialFunction: pointer;		//different for each device

      Reserved: longword;
      id: longword;      		//Rack ID for ITC1600
    end;

  ITC1600_Special_HWFunction=
    record
      Func:    longword;      		//HWFunction ( GS ==> function }
      DSPType: longword;         	//LCA for Interface side
      HOSTType: longword;	 	//LCA for Interface side
      RACKType: longword;	 	//LCA for Interface side
    end;

  ITC00_Special_HWFunction=
    record
      Func: longword;	 		//HWFunction
      DSPType: longword; 		//LCA for Interface side
      HOSTType: longword;		//LCA for Interface side
      RACKType: longword;		//LCA for Interface side
    end;

  ITC18_Special_HWFunction=
    record
      Func: longword;			//HWFunction
      InterfaceData: pointer;	  	//LCA for Interface side
      IsolatedData: pointer;	  	//LCA for Isolated side
      Reserved: longword;
    end;

Const
//SamplingIntervalFlag / StartOffset:
  SAMPLING_MASK	= $03;
  USE_FREQUENCY	= $00;
  USE_TIME     	= $01;
  USE_TICKS	= $02;

  SCALE_MASK	= $0C;
  NO_SCALE      = $00;
  MS_SCALE     	= $04;	//Milliseconds
  US_SCALE     	= $08;	//Microseconds
  NS_SCALE	= $0C;	//Nanoseconds

  ADJUST_RATE		= $10;	//Adjust to closest available
  DONTIGNORE_SCAN	= $20;	//Use StartOffset to set Scan Number

//Conversion values
  ANALOGVOLT	       	= 3200.0;
  SLOWANALOGVOLT       	= 3276.7;
  OFFSETINVOLTS	        = 819200.0; 	//3200*256.
  SLOWOFFSETINVOLTS   	= 838835.2;	//838860.8	//3276.8*256 838835.2
  POSITIVEVOLT	      	= 10.2396875;
  SLOWPOSITIVEVOLT    	= 10.0;

type
  ITCChannelInfo=
    record
      ModeNumberOfPoints: longword;
      ChannelType: longword;
      ChannelNumber: longword;
      Reserved0: longword;

      ErrorMode: longword; 			//See ITC_STOP_XX..XX definition for Error Modes
      ErrorState: longword;
      FIFOPointer:pointer;
      FIFONumberOfPoints: longword;  		//In Points

      ModeOfOperation: longword;
      SizeOfModeParameters: longword;
      ModeParameters: pointer;
      SamplingIntervalFlag: longword;		//See flags above

      SamplingRate:double;			//See flags above
      StartOffset: double;			//See flags above
      Gain: double;  				//Times
      Offset: double; 				//Volts

      ExternalDecimation: longword;
      Reserved1: longword;
      Reserved2: longword;
      Reserved3: longword;
    end;

Const
  READ_TOTALTIME        	= $01;
  READ_RUNTIME	      		= $02;
  READ_ERRORS	      		= $04;
  READ_RUNNINGMODE    		= $08;
  READ_OVERFLOW	      		= $10;
  READ_CLIPPING	      		= $20;

  READ_ASYN_ADC	      		= $40;

//DSP State
  RACKLCAISALIVE      		= $80000000;
  PLLERRORINDICATOR   		= $08000000;
  RACK0MODEMASK	      		= $70000000;
  RACK1MODEMASK	      		= $07000000;
  RACK0IDERROR	      		= $00020000;
  RACK1IDERROR	      		= $00010000;
  RACK0CRCERRORMASK   		= $0000FF00;
  RACK1CRCERRORMASK   		= $000000FF;

type
  ITCStatus=
    record
      CommandStatus: longword ;
      RunningMode: longword ;
      Overflow: longword ;
      Clipping: longword ;

      State: longword ;
      Reserved0: longword ;
      Reserved1: longword ;
      Reserved2: longword ;

      TotalSeconds:double;
      RunSeconds: double;
    end;

Const
  USE_TRIG_IN		= $01;
  USE_TRIG_IN_HOST	= $02;
  USE_TRIG_IN_TIMER	= $04;
  USE_TRIG_IN_RACK	= $08;
  USE_TRIG_IN_FDI0	= $10;
  USE_TRIG_IN_FDI1	= $20;
  USE_TRIG_IN_FDI2	= $40;
  USE_TRIG_IN_FDI3	= $80;
  TRIG_IN_MASK		= $FF;

  USE_HARD_TRIG_IN	= $100;

//Specification for Acquisition Configuration
type
  ITCPublicConfig=
    record
      DigitalInputMode: longword;  	//Bit 0: Latch Enable, Bit 1: Invert. For ITC1600; See AES doc.
      ExternalTriggerMode: longword;	//Bit 0: Transition, Bit 1: Invert
      ExternalTrigger: longword; 	//Enable
      EnableExternalClock: longword;	//Enable

      DACShiftValue: longword;		//For ITC18 Only. Needs special LCA
      InputRange: longword;     	//AD0.. AD7
      TriggerOutPosition: longword ;
      OutputEnable: longword ;

      SequenceLength: longword;		//In/Out for ITC16/18; Out for ITC1600
      Sequence: Plongword;  		//In/Out for ITC16/18; Out for ITC1600
      SequenceLengthIn: longword;	//For ITC1600 only
      SequenceIn: Plongword; 		//For ITC1600 only

      ResetFIFOFlag: longword;		//Reset FIFO Pointers / Total Number of points in NORMALMODE
      ControlLight: longword;
      SamplingInterval: double;	 	//In Seconds. Note: may be calculated from channel setting
    end;



Const
  RESET_FIFO_COMMAND	  	= $00010000;
  PRELOAD_FIFO_COMMAND		= $00020000;
  LAST_FIFO_COMMAND	  	= $00040000;
  FLUSH_FIFO_COMMAND	  	= $00080000;
  ITC_SET_SHORT_ACQUISITION	= $00100000;
  READ_OUTPUT_ONLY	  	= $00200000;

  RESET_FIFO_COMMAND_EX	  	= $0001;
  PRELOAD_FIFO_COMMAND_EX 	= $0002;
  LAST_FIFO_COMMAND_EX	  	= $0004;
  FLUSH_FIFO_COMMAND_EX	  	= $0008;
  ITC_SET_SHORT_ACQUISITION_EX	= $0010;
  READ_OUTPUT_ONLY_EX	  	= $0020;

//GetFIFOInformation flags
  READ_FIFO_INFO	        	= 0;
  READ_FIFO_READ_POINTER_COUNTER 	= 1;
  READ_FIFO_WRITE_POINTER_COUNTER	= 2;


type
  ITCChannelDataEx=
    record
      ChannelType: word;		//Channel Type
      Command: word;			//Command
      ChannelNumber: word;              //Channel Number
      Status: word;			//Status
      Value: longword;			//Number of points OR Data Value
      DataPointer: pointer; 		//Data
    end;



  VersionInfo=
    record
      Major: integer;
      Minor: integer;
      description: array[0..79] of AnsiChar;
      date: array[0..79] of AnsiChar;
    end;

  GlobalDeviceInfo=
    record
      DeviceType: longword ;
      DeviceNumber: longword;
      PrimaryFIFOSize: longword;    //In Points
      SecondaryFIFOSize: longword;  //In Points

      LoadedFunction: longword;
      SoftKey: longword;
      Mode: longword;
      MasterSerialNumber: longword;

      SecondarySerialNumber: longword;
      HostSerialNumber: longword;
      NumberOfDACs: longword;
      NumberOfADCs: longword;

      NumberOfDOs: longword;
      NumberOfDIs: longword;
      
      NumberOfAUXOs: longword;
      NumberOfAUXIs: longword;

      Reserved0: longword;
      Reserved1: longword;
      Reserved2: longword;
      Reserved3: longword;
    end;


//RunningOption
Const
  DontUseTimerThread		= 1;
  FastPointerUpdate		= 2;
  ShortDataAcquisition	        = 4;
  TimerResolutionMask	        = $00FF0000;
  TimerIntervalMask	        = $FF000000;
  TimerResolutionShift	        = 16;
  TimerIntervalShift		= 24;

type
  ITCStartInfo=
    record
      ExternalTrigger: longword; 	//-1 - do not change
      OutputEnable: longword;	 	//-1 - do not change
      StopOnOverflow: longword;		//-1 - do not change
      StopOnUnderrun: longword;		//-1 - do not change

      RunningOption: longword;		//-1 - do not change
      ResetFIFOs: longword;

      NumberOf640usToRun: longword;
      Reserved3: longword;

      StartTime:double;
      StopTime:double;
    end;


//SINGLE SCAN Limitations
Const
  ITC16_MaximumSingleScan   		= 16*1024;
  ITC18_MaximumSingleScan   		= 256*1024;
  ITC1600_MaximumSingleScan		= 1024;
  ITC00_MaximumSingleScan   		= 1024;

  ITC16_MAX_SEQUENCE_LENGTH		= 16;
  ITC18_MAX_SEQUENCE_LENGTH		= 16;
  ITC1600_MAX_SEQUENCE_LENGTH		= 16;
  ITC00_MAX_SEQUENCE_LENGTH		= 16;

  ITC18_NOP_CHANNEL	    		= $80000000;
  ITC1600_NOP_CHANNEL_RACK0		= $80000000;
  ITC1600_NOP_CHANNEL_RACK1		= $80000001;
  ITC00_NOP_CHANNEL_RACK0   		= $80000000;
  ITC00_NOP_CHANNEL_RACK1   		= $80000001;

type
  ITCLimited=
    record
      ChannelType: longword;
      ChannelNumber: longword;
      Reserved0: longword;
      Reserved1: longword;

      Reserved2: longword;
      NumberOfPoints: longword;
      DecimateMode: longword;
      Data: pointer;
    end;


//	GLOBAL MANAGEMENT FUNCTIONs
type
  ITCGlobalConfig=
    record
      SoftwareFIFOSize: integer;
      HardwareFIFOSize_A: integer;
      HardwareFIFOSize_B: integer;
      Reserved: integer;

      Reserved0: integer;
      Reserved1: integer;
      Reserved2: integer;
      Reserved3: integer;
    end;



var
  ITC_GlobalConfig: function(var GlobalConfig: ITCGlobalConfig):longword;cdecl;

//       	  POWER MANAGEMENT FUNCTIONs

  ITC_Devices: function(DeviceType: longword; var DeviceNumber: longword ):longword;cdecl;

  ITC_GetDeviceHandle: function(DeviceType,DeviceNumber: longword;var DeviceHandle:Thandle):longword;cdecl;

  ITC_GetDeviceType: function(DeviceHandle:Thandle; var DeviceType: longword; var DeviceNumber:longword):longword;cdecl;

  ITC_OpenDevice: function(DeviceType,DeviceNumber,Mode: longword;var DeviceHandle:Thandle):longword;cdecl;

  ITC_CloseDevice: function(DeviceHandle:Thandle):longword;cdecl;

  ITC_InitDevice: function(DeviceHandle: Thandle;var sHWFunction:HWFunction ):longword;cdecl;

// 		  STATIC INFORMATION FUNCTIONs

  ITC_GetDeviceInfo: function(DeviceHandle: Thandle;var sDeviceInfo: GlobalDeviceInfo):longword;cdecl;

  ITC_GetVersions: function(DeviceHandle: Thandle;var ThisDriverVersion,KernelLevelDriverVersion,HardwareVersion:VersionInfo):longword;cdecl;

  ITC_GetSerialNumbers: function(DeviceHandle: Thandle; var HostSerialNumber,MasterBoxSerialNumber, SlaveBoxSerialNumber:longword):longword;cdecl;

  ITC_GetStatusText: function(DeviceHandle: Thandle;Status:integer; Text:Pansichar;MaxCharacters:integer):longword;cdecl;

  ITC_SetSoftKey: function(DeviceHandle: Thandle; SoftKey:longword):longword;cdecl;

//		  DYNAMIC INFORMATION FUNCTIONs

  ITC_GetState: function(DeviceHandle: Thandle;sParam:pointer):longword;cdecl;
  ITC_SetState: function(DeviceHandle: Thandle; sParam:pointer):longword;cdecl;
  ITC_GetFIFOInformation: function(DeviceHandle: Thandle;NumberOfChannels:longword;var sparam:ITCChannelDataEx):longword;cdecl;
  ITC_GetTime: function(DeviceHandle: Thandle;var Seconds:double):longword;cdecl;

//		  CONFIGURATION FUNCTIONs

  ITC_ResetChannels: function(DeviceHandle: Thandle):longword;cdecl;

  ITC_SetChannels: function(DeviceHandle: Thandle; NumberOfChannels:longword;var Channels:ITCChannelInfo):longword;cdecl;

  ITC_UpdateChannels: function(DeviceHandle: Thandle):longword;cdecl;

  ITC_GetChannels: function(DeviceHandle: Thandle; NumberOfChannels:longword;var Channels:ITCChannelInfo):longword;cdecl;

  ITC_ConfigDevice: function(DeviceHandle: Thandle;var sITCConfig:ITCPublicConfig ):longword;cdecl;

  ITC_Start: function(DeviceHandle: Thandle;var sparam: ITCStartInfo):longword;cdecl;
  ITC_Stop: function(DeviceHandle: Thandle; sparam:pointer):longword;cdecl;

  ITC_UpdateNow: function(DeviceHandle: Thandle; sparam: pointer):longword;cdecl;

  ITC_SingleScan: function(DeviceHandle: Thandle; NumberOfChannels:longword;var sparam:ITCLimited):longword;cdecl;

  ITC_AsyncIO: function(DeviceHandle: Thandle; NumberOfChannels:longword;var sparam:ITCChannelDataEx):longword;cdecl;

//***************************************************************************

  ITC_GetDataAvailable: function(DeviceHandle: Thandle;NumberOfChannels:longword;var sparam:ITCChannelDataEx):longword;cdecl;
  ITC_UpdateFIFOPosition: function(DeviceHandle: Thandle; NumberOfChannels:longword;var sparam:ITCChannelDataEx):longword;cdecl;

  ITC_ReadWriteFIFO: function(DeviceHandle: Thandle;NumberOfChannels:longword;var sparam:ITCChannelDataEx):longword;cdecl;

  ITC_GetFIFOPointers: function(DeviceHandle: Thandle;NumberOfChannels: longword;var sparam:ITCChannelDataEx):longword;cdecl;
//***************************************************************************

function InitITClib:boolean;

Implementation

function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
                 {else messageCentral(st+' OK');}
end;

var
  hh:intG;


function InitITClib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  {$IFDEF WIN64}
  hh:=GloadLibrary('ITCMM.dll');   // ITCMM64
  if hh=0 then hh:=GloadLibrary('ITCMM64.dll');
  result:=(hh<>0);
  if not result then
  begin
    if GdebugMode then messageCentral('ITCMM64.dll not found');
    exit;
  end;
  {$ELSE}
  hh:=GloadLibrary('ITCMM.dll');
  if hh=0 then hh:=GloadLibrary('ITCMM32.dll');
  result:=(hh<>0);
  if not result then exit;
  {$ENDIF}
  ITC_GlobalConfig:=getProc(hh,'ITC_GlobalConfig');
  ITC_Devices:=getProc(hh,'ITC_Devices');
  ITC_GetDeviceHandle:=getProc(hh,'ITC_GetDeviceHandle');
  ITC_GetDeviceType:=getProc(hh,'ITC_GetDeviceType');
  ITC_OpenDevice:=getProc(hh,'ITC_OpenDevice');
  ITC_CloseDevice:=getProc(hh,'ITC_CloseDevice');
  ITC_InitDevice:=getProc(hh,'ITC_InitDevice');
  ITC_GetDeviceInfo:=getProc(hh,'ITC_GetDeviceInfo');
  ITC_GetVersions:=getProc(hh,'ITC_GetVersions');
  ITC_GetSerialNumbers:=getProc(hh,'ITC_GetSerialNumbers');
  ITC_GetStatusText:=getProc(hh,'ITC_GetStatusText');
  ITC_SetSoftKey:=getProc(hh,'ITC_SetSoftKey');
  ITC_GetState:=getProc(hh,'ITC_GetState');
  ITC_SetState:=getProc(hh,'ITC_SetState');
  ITC_GetFIFOInformation:=getProc(hh,'ITC_GetFIFOInformation');
  ITC_GetTime:=getProc(hh,'ITC_GetTime');
  ITC_ResetChannels:=getProc(hh,'ITC_ResetChannels');
  ITC_SetChannels:=getProc(hh,'ITC_SetChannels');
  ITC_UpdateChannels:=getProc(hh,'ITC_UpdateChannels');
  ITC_GetChannels:=getProc(hh,'ITC_GetChannels');
  ITC_ConfigDevice:=getProc(hh,'ITC_ConfigDevice');
  ITC_Start:=getProc(hh,'ITC_Start');
  ITC_Stop:=getProc(hh,'ITC_Stop');
  ITC_UpdateNow:=getProc(hh,'ITC_UpdateNow');
  ITC_SingleScan:=getProc(hh,'ITC_SingleScan');
  ITC_AsyncIO:=getProc(hh,'ITC_AsyncIO');
  ITC_GetDataAvailable:=getProc(hh,'ITC_GetDataAvailable');
  ITC_UpdateFIFOPosition:=getProc(hh,'ITC_UpdateFIFOPosition');
  ITC_ReadWriteFIFO:=getProc(hh,'ITC_ReadWriteFIFO');
  ITC_GetFIFOPointers:=getProc(hh,'ITC_GetFIFOPointers');
end;

Initialization
AffDebug('Initialization Itcmm',0);

finalization
  if hh<>0 then freeLibrary(hh);

end.



