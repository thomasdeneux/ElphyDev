{
 ----------------------------------------------------------------
 File - PCI_REGS.PAS

 Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com 
 ----------------------------------------------------------------
}

unit PCI_Regs;

interface

{ PCI register definitions }
const
  PCI_IDR  = $00;
  PCI_CR   = $04;
  PCI_SR   = $06;
  PCI_REV  = $08;
  PCI_CCR  = $09;
  PCI_LSR  = $0c;
  PCI_LTR  = $0d;
  PCI_HTR  = $0e;
  PCI_BISTR= $0f;
  PCI_BAR0 = $10;
  PCI_BAR1 = $14;
  PCI_BAR2 = $18;
  PCI_BAR3 = $1c;
  PCI_BAR4 = $20;
  PCI_BAR5 = $24;
  PCI_CIS  = $28;
  PCI_SVID = $2c;
  PCI_SID  = $2e;
  PCI_ERBAR= $30;
  PCI_ILR  = $3c;
  PCI_IPR  = $3d;
  PCI_MGR  = $3e;
  PCI_MLR  = $3f;

const
  AD_PCI_BAR0 = 0;
  AD_PCI_BAR1 = 1;
  AD_PCI_BAR2 = 2;
  AD_PCI_BAR3 = 3;
  AD_PCI_BAR4 = 4;
  AD_PCI_BAR5 = 5;
  AD_PCI_BAR_EPROM = 6;
  AD_PCI_BARS = 7;

implementation

end.

