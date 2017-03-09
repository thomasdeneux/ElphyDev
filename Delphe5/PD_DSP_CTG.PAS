unit PD_DSP_CT;

{===========================================================================

 NAME:    pd_dsp_ct.h

 DESCRIPTION:
          Definitions for PowerDAQ PCI Device Driver.

 NOTES:   This is DSP counter-timer register definitions

 AUTHOR:  Alex Ivchenko

 DATE:    15-JAN-2001

 HISTORY:

      Rev 0.1,    15-JAN-01,  A.I.,   Initial version.

 NOTE: DSP counters are used in PowerDAQ asynchronous operations
       PD2-AO uses counter-timer 2 for AOut
       PD2-DIO uses counter-timer 1 for DIn and 2 for DOut

---------------------------------------------------------------------------

      Copyright (C) 2001 United Electronic Industries, Inc.
      All rights reserved.
      United Electronic Industries Confidential Information.

===========================================================================

 PD2-DIO UCT Support

 General Information

 PowerDAQ DIO board has three 24-bit counter/timers.
 Also there is an additional 21-bit counter called prescaler which can be
 used as a pre-divider or for the programmable cascading purposes.
 Each counter can be clocked from the one of the three sources
 ·    External TIOx pin (Note: That when external signal source attached
     100-200 Ohm series resistor should be used to protect DSP TIOx pin)
 ·    Internal DSP Clock/2 (33 MHz for the all PD2-DIO boards)
 ·    Prescaler output
 Please note: That each counter/timer has programmable polarity and can generate
 interrupt on the any of the two events - compare and overflow.
 Each timer has an associated compare register that is used in some modes to
 generate PWM signal and to generate compare interrupt in all modes.
 DSP Counters are count-up type counters.

 Prescaler counter can use any of the four following sources (software selectable)
 ·    Internal DSP Clock/2 (33 MHz for the all PD2-DIO boards)
 ·    External TIO0/1/2 pin

 Please refer to the Motorola DSP56301 User Manual for the details
 (Motorola P/N DSP56301UM/AD)

 PowerDAQ Implementation

 DIO Interrupts are supported by revision 3 of the PowerDAQ driver that is in the
 beta stage right now. Following algorithm should be used:

 1)   All timers should be programmed using the _PdDspRegWrite  and _PdDSPRegRead
   functions and proper ants. Note that using of the wrong addresses can
   cause system problems.
 2)   Timer1 should not be used with DIn asynchronous operations and Timer2 with
   DOut asynchronous operations.
 3)   UCT Interrupts should be enabled first by _PdSetUserEvents function, after
   that using the _PdDspRegWrite  function user should enable interrupt for the
   selected counter (M_TOIE and M_TCIE bits in M_TCSRx). Note that because only one
   bit is dedicated in the events word for the each UCT interrupt only one type of
   the interrupt should be enabled at the time.
 4)   After host is interrupted because of the UCT interrupt it should be
   re-enabled if necessary using the same algorithm.
 5)   Before program is closed each DSP Timer used should be reset using
   the _PdDspRegWrite function (write zero to the corresponding TCSR).
 6)   The functions below are not supported and should NEVER used with DSP UCTs

 PDUCTCFG
 PDUCTSTATUS
 PDUCTWRITE
 PDUCTREAD
 PDUCTSWGATE
 PDUCTSWCLK
 PDUCTRESET
}


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

const

{ Timer Prescaler Register Bit Flags }

  M_PS = $600000; { Prescaler Source Mask}

  M_PS0 = (1 SHL 21);

  M_PS1 = (1 SHL 22);

{ Prescaler clock sources }

  M_PS_CLK2 = 0; { Use internal clock / 2}

  M_PS_TIO0 = (M_PS0); { Use timer IO 0}

  M_PS_TIO1 = (M_PS1); { Use timer IO 1}

  M_PS_TIO2 = (M_PS0 or M_PS1); { Use timer IO 2}

{ Register Addresses Of TIMER0 }

  M_TCSR0 = $FFFF8; { TIMER0 Control/Status Register}

  M_TLR0 = $FFFF8E; { TIMER0 Load Reg}

  M_TCPR0 = $FFFF8D; { TIMER0 Compare Register}

  M_TCR0 = $FFFF8C; { TIMER0 Count Register}

{ Register Addresses Of TIMER1 }

  M_TCSR1 = $FFFF8B; { TIMER1 Control/Status Register}

  M_TLR1 = $FFFF8A; { TIMER1 Load Reg}

  M_TCPR1 = $FFFF89; { TIMER1 Compare Register}

  M_TCR1 = $FFFF88; { TIMER1 Count Register}

{ Register Addresses Of TIMER2 }

  M_TCSR2 = $FFFF87; { TIMER2 Control/Status Register}

  M_TLR2 = $FFFF86; { TIMER2 Load Reg}

  M_TCPR2 = $FFFF85; { TIMER2 Compare Register}

  M_TCR2 = $FFFF84; { TIMER2 Count Register}

{ Prescaler Registers }

  M_TPLR = $FFFF83; { TIMER Prescaler Load Register}

  M_TPCR = $FFFF82; { TIMER Prescalar Count Register}

{ Timer Control/Status Register Bit Flags }

  M_TE = (1 SHL 0); { Timer Enable}

  M_TOIE = (1 SHL 1); { Timer Overflow Interrupt Enable}

  M_TCIE = (1 SHL 2); { Timer Compare Interrupt Enable}

  M_TC0 = (1 SHL 4); { Timer Control 0}

  M_TC1 = (1 SHL 5); { Timer Control 1}

  M_TC2 = (1 SHL 6); { Timer Control 2}

  M_TC3 = (1 SHL 7); { Timer Control 3}

  M_TC = $F0; { Timer Control Mask (TC0-TC3)}

  M_INV = (1 SHL 8); { Inverter Bit}

  M_TRM = (1 SHL 9); { Timer Restart Mode}

  M_DIR = (1 SHL 11); { Direction Bit}

  M_DI = (1 SHL 12); { Data Input}

  M_DO = (1 SHL 13); { Data Output}

  M_PCE = (1 SHL 15); { Prescaled Clock Enable}

  M_TOF = (1 SHL 20); { Timer Overflow Flag}

  M_TCF = (1 SHL 21); { Timer Compare Flag}

{ Timer Mode Masks }

  DCT_Timer = $0;

  DCT_TimerPulse = $10;

  DCT_TimerToggle = $20;

  DCT_EventCounter = $30;

  DCT_InputWidth = $40;

  DCT_InputPeriod = $50;

  DCT_Capture = $60;

  DCT_PWM = $70;

  DCT_WatchdogPulse = $90;

  DCT_WatchdogToggle = $A0;

{ DCT_Status bits }

  DCTB_TE0 = (1 SHL 0); { Timer 0 Enable}

  DCTB_TE1 = (1 SHL 1); { Timer 1 Enable}

  DCTB_TE2 = (1 SHL 2); { Timer 2 Enable}

  DCTB_TA0 = (1 SHL 3); { Timer 0 Available}

  DCTB_TA1 = (1 SHL 4); { Timer 1 Available}

  DCTB_TA2 = (1 SHL 5); { Timer 2 Available}

  DCTB_FMODE = (1 SHL 6); { Frequency Mode On}

  DCTB_FDONE = (1 SHL 7); { Frequency Measurement Done}

  DCTB_TFME0 = (1 SHL 8); { Timer 0 Frequency Mode Enable}

  DCTB_TFME1 = (1 SHL 9); { Timer 1 Frequency Mode Enable}

{ Counter IDs }

  DCT_UCT0 = $0; { counter 0}

  DCT_UCT1 = $1; { counter 1}

  DCT_UCT2 = $2; { counter 2}

implementation

end.
