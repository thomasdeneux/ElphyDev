object RevMatProp: TRevMatProp
  Left = 29
  Top = 159
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'RevMatProp'
  ClientHeight = 88
  ClientWidth = 306
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 10
    Width = 9
    Height = 13
    Caption = 't1'
  end
  object Label2: TLabel
    Left = 5
    Top = 33
    Width = 9
    Height = 13
    Caption = 't2'
  end
  object Label3: TLabel
    Left = 5
    Top = 56
    Width = 11
    Height = 13
    Caption = 'Dt'
  end
  object Lip1: TLabel
    Left = 137
    Top = 14
    Width = 15
    Height = 13
    Caption = 'Ip1'
  end
  object Lip2: TLabel
    Left = 137
    Top = 35
    Width = 15
    Height = 13
    Caption = 'Ip2'
  end
  object enT1: TeditNum
    Left = 25
    Top = 8
    Width = 89
    Height = 21
    TabOrder = 0
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enT2: TeditNum
    Left = 25
    Top = 30
    Width = 89
    Height = 21
    TabOrder = 1
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDT: TeditNum
    Left = 25
    Top = 55
    Width = 89
    Height = 21
    TabOrder = 2
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbIP1: TscrollbarV
    Left = 202
    Top = 12
    Width = 93
    Height = 16
    Max = 30000
    TabOrder = 3
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbIP1ScrollV
  end
  object sbIP2: TscrollbarV
    Left = 202
    Top = 34
    Width = 93
    Height = 16
    Max = 30000
    TabOrder = 4
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbIP2ScrollV
  end
  object Bcalcul: TButton
    Left = 201
    Top = 55
    Width = 96
    Height = 20
    Caption = 'Calculate'
    TabOrder = 5
    OnClick = BcalculClick
  end
end
