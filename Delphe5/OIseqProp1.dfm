object OIseqProp: TOIseqProp
  Left = 528
  Top = 328
  Width = 337
  Height = 313
  Caption = 'OIseqProp'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox6: TGroupBox
    Left = 6
    Top = 8
    Width = 318
    Height = 107
    Caption = 'Horizontal scaling factors'
    TabOrder = 0
    object Label32: TLabel
      Left = 8
      Top = 53
      Width = 8
      Height = 13
      Caption = 'i='
    end
    object Label33: TLabel
      Left = 108
      Top = 55
      Width = 85
      Height = 13
      Caption = 'Corresponds to x='
    end
    object Label34: TLabel
      Left = 8
      Top = 78
      Width = 8
      Height = 13
      Caption = 'i='
    end
    object Label35: TLabel
      Left = 107
      Top = 79
      Width = 85
      Height = 13
      Caption = 'Corresponds to x='
    end
    object Label36: TLabel
      Left = 7
      Top = 25
      Width = 27
      Height = 13
      Caption = 'Units:'
    end
    object enI1: TeditNum
      Left = 40
      Top = 51
      Width = 58
      Height = 21
      TabOrder = 0
      Text = '1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enX1: TeditNum
      Left = 198
      Top = 51
      Width = 87
      Height = 21
      TabOrder = 1
      Text = '1123456789'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enI2: TeditNum
      Left = 40
      Top = 75
      Width = 58
      Height = 21
      TabOrder = 2
      Text = '2'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enX2: TeditNum
      Left = 198
      Top = 75
      Width = 87
      Height = 21
      TabOrder = 3
      Text = '1123456789'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitX: TeditString
      Left = 47
      Top = 22
      Width = 88
      Height = 21
      TabOrder = 4
      Text = 'mV'
      len = 0
      UpdateVarOnExit = False
    end
  end
  object Bok: TButton
    Left = 87
    Top = 249
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 167
    Top = 249
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 118
    Width = 318
    Height = 107
    Caption = 'Vertical scaling factors'
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 53
      Width = 8
      Height = 13
      Caption = 'j='
    end
    object Label2: TLabel
      Left = 108
      Top = 55
      Width = 85
      Height = 13
      Caption = 'Corresponds to y='
    end
    object Label3: TLabel
      Left = 8
      Top = 78
      Width = 8
      Height = 13
      Caption = 'j='
    end
    object Label4: TLabel
      Left = 107
      Top = 79
      Width = 85
      Height = 13
      Caption = 'Corresponds to y='
    end
    object Label5: TLabel
      Left = 7
      Top = 25
      Width = 27
      Height = 13
      Caption = 'Units:'
    end
    object enJ1: TeditNum
      Left = 40
      Top = 51
      Width = 58
      Height = 21
      TabOrder = 0
      Text = '1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enY1: TeditNum
      Left = 198
      Top = 51
      Width = 87
      Height = 21
      TabOrder = 1
      Text = '1123456789'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enJ2: TeditNum
      Left = 40
      Top = 75
      Width = 58
      Height = 21
      TabOrder = 2
      Text = '2'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enY2: TeditNum
      Left = 198
      Top = 75
      Width = 87
      Height = 21
      TabOrder = 3
      Text = '1123456789'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitY: TeditString
      Left = 47
      Top = 22
      Width = 88
      Height = 21
      TabOrder = 4
      Text = 'mV'
      len = 0
      UpdateVarOnExit = False
    end
  end
end
