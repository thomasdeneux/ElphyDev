object VlistProperties: TVlistProperties
  Left = 474
  Top = 174
  BorderStyle = bsDialog
  Caption = 'VlistProperties'
  ClientHeight = 260
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 5
    Top = 14
    Width = 51
    Height = 13
    Caption = 'Line Count'
  end
  object Label2: TLabel
    Left = 5
    Top = 122
    Width = 70
    Height = 13
    Caption = 'Top margin (%)'
  end
  object Label3: TLabel
    Left = 5
    Top = 144
    Width = 84
    Height = 13
    Caption = 'Bottom margin (%)'
  end
  object ENnbLigne: TeditNum
    Left = 114
    Top = 9
    Width = 74
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object BOK: TButton
    Left = 23
    Top = 224
    Width = 64
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 110
    Top = 224
    Width = 64
    Height = 21
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object enMtop: TeditNum
    Left = 115
    Top = 117
    Width = 74
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enMbottom: TeditNum
    Left = 115
    Top = 139
    Width = 74
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbShowNum: TCheckBoxV
    Left = 4
    Top = 165
    Width = 185
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Show numbers'
    TabOrder = 5
    UpdateVarOnToggle = False
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 32
    Width = 193
    Height = 73
    Caption = 'Waterfall'
    TabOrder = 6
    object Label4: TLabel
      Left = 13
      Top = 22
      Width = 13
      Height = 13
      Caption = 'Dx'
    end
    object Label1: TLabel
      Left = 13
      Top = 44
      Width = 13
      Height = 13
      Caption = 'Dy'
    end
    object enDxAff: TeditNum
      Left = 32
      Top = 17
      Width = 54
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDyAff: TeditNum
      Left = 32
      Top = 39
      Width = 54
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object sbDx: TScrollBar
      Left = 93
      Top = 20
      Width = 93
      Height = 16
      LargeChange = 10
      Min = -100
      PageSize = 0
      TabOrder = 2
      OnScroll = sbDxScroll
    end
    object sbDy: TScrollBar
      Left = 93
      Top = 42
      Width = 93
      Height = 16
      LargeChange = 10
      Min = -100
      PageSize = 0
      TabOrder = 3
      OnScroll = sbDyScroll
    end
  end
  object cbSelect: TCheckBoxV
    Left = 4
    Top = 187
    Width = 185
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Display selection'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
end
