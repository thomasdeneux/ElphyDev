object CBoptions: TCBoptions
  Left = 521
  Top = 220
  BorderStyle = bsDialog
  Caption = 'CBoptions'
  ClientHeight = 259
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 21
    Top = 110
    Width = 108
    Height = 13
    Caption = 'SingleIO threshold (Hz)'
  end
  object Label8: TLabel
    Left = 24
    Top = 16
    Width = 63
    Height = 13
    Caption = 'Adc bit count'
  end
  object Label9: TLabel
    Left = 24
    Top = 137
    Width = 64
    Height = 13
    Caption = 'Dac bit count'
  end
  object Label2: TLabel
    Left = 24
    Top = 39
    Width = 49
    Height = 13
    Caption = 'Buffer size'
  end
  object Label3: TLabel
    Left = 24
    Top = 63
    Width = 55
    Height = 13
    Caption = 'Packet size'
  end
  object cbSingleIO: TcomboBoxV
    Left = 144
    Top = 106
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object BOK: TButton
    Left = 62
    Top = 214
    Width = 56
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 140
    Top = 214
    Width = 56
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cbUseDma: TCheckBoxV
    Left = 21
    Top = 85
    Width = 136
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Dma transfer'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
  object cbAdcBits: TcomboBoxV
    Left = 144
    Top = 12
    Width = 64
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbDacBits: TcomboBoxV
    Left = 144
    Top = 133
    Width = 64
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object Bdefaults: TButton
    Left = 22
    Top = 175
    Width = 123
    Height = 20
    Caption = 'Defaults'
    TabOrder = 6
    OnClick = BdefaultsClick
  end
  object cbAdcBufferSize: TcomboBoxV
    Left = 144
    Top = 35
    Width = 64
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Items.Strings = (
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object enPacketSize: TeditNum
    Left = 144
    Top = 59
    Width = 63
    Height = 21
    TabOrder = 8
    Text = '2048'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
