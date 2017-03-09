// --------------------------------------------------------
// converted from Select C++ header file (source)
// 1/3/03 3:56:54 PM
// --------------------------------------------------------
//===========================================================================
//
// NAME:    pd_dsp_es.h
//
// DESCRIPTION: PowerDAQ DLL Low-Level Driver 
//		Interface functions. File handle
//
// NOTES:   This is ESSI port register definitions
//
// AUTHOR:  dk
//
// DATE:    01-JUN-2001
//
// HISTORY:
//
//      Rev 0.1,     01-JUN-2001,  dk,   Initial version.
//
//---------------------------------------------------------------------------
//
//      Copyright (C) 2001 United Electronic Industries, Inc.
//      All rights reserved.
//      United Electronic Industries Confidential Information.
//
//===========================================================================
//
// General Information
//
// Using of ESSI port require proper initialization procedure.
// Generally at least two control registers, CRA and CRB need to be defined.
// Also generally port C(ESSI0)/D(ESSI1) control/direction/GPIO registers 
// should be set before outputting any data.
// See Motorola DSP56301 User Manual for the details about ESSI programming
// Manual is available for download from http:\\www.mot.com
//
// PD2-DIO ESSI Support
//
// General Information
//
// PowerDAQ DIO board has two Enhanced Synchronous Serial Interface (ESSI).
// The ESSI provides a full-duplex serial port for communicating with a variety of
// serial devices. The ESSI comprises independent transmitter and receiver sections 
// and a common ESSI clock generator. Three transmit shift registers enable it to 
// transmit from three different pins simultaneously.
//
// Please refer to the Motorola DSP56301 User Manual for the details
//
//
//
//---------------------------------------------------------------------------
//
//       DSP EQUATES for I/O Port Programming
//
//------------------------------------------------------------------------
unit pd_dsp_es;
interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
const
  M_PCRC = $FFFFBF;// Port C Control Register 
  M_PRRC = $FFFFBE;// Port C Direction Register 			
  M_PDRC = $FFFFBD;// Port C GPIO Data Register 	
  M_PCRC0 = $2F;
  M_PRRC0 = $2F;
  M_PDRC0 = $2F;

const
  M_PCRD = $FFFFAF;// Port D Control Register 
  M_PRRD = $FFFFAE;// Port D Direction Register 			
  M_PDRD = $FFFFAD;// Port D GPIO Data Register
  M_PCRD0 = $2F;
  M_PRRD0 = $2F;
  M_PDRD0 = $2F;


//------------------------------------------------------------------------
//
//       EQUATES for Enhanced Synchronous Serial Interface (ESSI)
//
//------------------------------------------------------------------------

//       Register Addresses Of ESSI0 
const
  M_TX00 = $FFFFBC;// ESSI0 Transmit Data Register 0
  M_TX01 = $FFFFBB;// ESSIO Transmit Data Register 1
  M_TX02 = $FFFFBA;// ESSIO Transmit Data Register 2
  M_TSR0 = $FFFFB9;// ESSI0 Time Slot Register
  M_RX0 = $FFFFB8;// ESSI0 Receive Data Register
  M_SSISR0 = $FFFFB7;// ESSI0 Status Register
  M_CRB0 = $FFFFB6;// ESSI0 Control Register B
  M_CRA0 = $FFFFB5;// ESSI0 Control Register A
  M_TSMA0 = $FFFFB4;// ESSI0 Transmit Slot Mask Register A
  M_TSMB0 = $FFFFB3;// ESSI0 Transmit Slot Mask Register B
  M_RSMA0 = $FFFFB2;// ESSI0 Receive Slot Mask Register A
  M_RSMB0 = $FFFFB1;// ESSI0 Receive Slot Mask Register B

//       Register Addresses Of ESSI1
const
  M_TX10 = $FFFFAC;// ESSI1 Transmit Data Register 0
  M_TX11 = $FFFFAB;// ESSI1 Transmit Data Register 1
  M_TX12 = $FFFFAA;// ESSI1 Transmit Data Register 2
  M_TSR1 = $FFFFA9;// ESSI1 Time Slot Register
  M_RX1 = $FFFFA8;// ESSI1 Receive Data Register
  M_SSISR1 = $FFFFA7;// ESSI1 Status Register
  M_CRB1 = $FFFFA6;// ESSI1 Control Register B
  M_CRA1 = $FFFFA5;// ESSI1 Control Register A
  M_TSMA1 = $FFFFA4;// ESSI1 Transmit Slot Mask Register A
  M_TSMB1 = $FFFFA3;// ESSI1 Transmit Slot Mask Register B
  M_RSMA1 = $FFFFA2;// ESSI1 Receive Slot Mask Register A
  M_RSMB1 = $FFFFA1;// ESSI1 Receive Slot Mask Register B

//       ESSI Control Register A Bit Flags
const
  M_PM = $FF;           // Prescale Modulus Select Mask (PM0-PM7)
  M_PM0 = 0;
  M_PSR = 11;           // Prescaler Range
  M_DC = $1F000;        // Frame Rate Divider Control Mask (DC0-DC7)
  M_DC0 = 12;
  M_ALC = 18;           // Alignment Control (ALC)
  M_WL = $380000;       // Word Length Control Mask (WL0-WL7)
  M_WL0 = 19;
  M_SSC1 = 22;  // Select SC1 as TR #0 drive enable (SSC1)

//       ESSI Control Register B Bit Flags
const
  M_OF = $3;// Serial Output Flag Mask
  M_OF0 = 0;// Serial Output Flag 0
  M_OF1 = 1;// Serial Output Flag 1
  M_SCD = $1C;// Serial Control Direction Mask
  M_SCD0 = 2;// Serial Control 0 Direction
  M_SCD1 = 3;// Serial Control 1 Direction
  M_SCD2 = 4;// Serial Control 2 Direction
  M_SCKD = 5;// Clock Source Direction
  M_SHFD = 6;// Shift Direction
  M_FSL = $180;// Frame Sync Length Mask (FSL0-FSL1)
  M_FSL0 = 7;// Frame Sync Length 0
  M_FSL1 = 8;// Frame Sync Length 1
  M_FSR = 9;// Frame Sync Relative Timing
  M_FSP = 10;// Frame Sync Polarity
  M_CKP = 11;// Clock Polarity
  M_SYN = 12;// Sync/Async Control
  M_MOD = 13;// ESSI Mode Select
  M_SSTE = $1C000;// ESSI Transmit enable Mask
  M_SSTE2 = 14;// ESSI Transmit #2 Enable
  M_SSTE1 = 15;// ESSI Transmit #1 Enable
  M_SSTE0 = 16;// ESSI Transmit #0 Enable
  M_SSRE = 17;// ESSI Receive Enable
  M_SSTIE = 18;// ESSI Transmit Interrupt Enable
  M_SSRIE = 19;// ESSI Receive Interrupt Enable
  M_STLIE = 20;// ESSI Transmit Last Slot Interrupt Enable
  M_SRLIE = 21;// ESSI Receive Last Slot Interrupt Enable
  M_STEIE = 22;// ESSI Transmit Error Interrupt Enable
  M_SREIE = 23;// ESSI Receive Error Interrupt Enable

//       ESSI Status Register Bit Flags
const
  M_IF = $3;// Serial Input Flag Mask
  M_IF0 = 0;// Serial Input Flag 0
  M_IF1 = 1;// Serial Input Flag 1
  M_TFS = 2;// Transmit Frame Sync Flag
  M_RFS = 3;// Receive Frame Sync Flag
  M_TUE = 4;// Transmitter Underrun Error FLag
  M_ROE = 5;// Receiver Overrun Error Flag
  M_TDE = 6;// Transmit Data Register Empty
  M_RDF = 7;// Receive Data Register Full

//       ESSI Transmit Slot Mask Register A
const
  M_SSTSA = $FFFF;// ESSI Transmit Slot Bits Mask A (TS0-TS15)

//       ESSI Transmit Slot Mask Register B
const
  M_SSTSB = $FFFF;// ESSI Transmit Slot Bits Mask B (TS16-TS31)

//       ESSI Receive Slot Mask Register A
const
  M_SSRSA = $FFFF;// ESSI Receive Slot Bits Mask A (RS0-RS15)

//       ESSI Receive Slot Mask Register B
const
  M_SSRSB = $FFFF;// ESSI Receive Slot Bits Mask B (RS16-RS31)


// 	 Word Length Control Mask.  CRA[21:19]
const
  M_WL_MASK0 = $00000000;
  M_WL_MASK1 = $00080000;
  M_WL_MASK2 = $00100000;
  M_WL_MASK3 = $00180000;

implementation
begin
end.
