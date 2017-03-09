object DemoOptions: TDemoOptions
  Left = 681
  Top = 337
  BorderStyle = bsDialog
  Caption = 'Demo interface options'
  ClientHeight = 215
  ClientWidth = 234
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
    Left = 10
    Top = 19
    Width = 29
    Height = 13
    Caption = 'Model'
  end
  object Label2: TLabel
    Left = 10
    Top = 41
    Width = 49
    Height = 13
    Caption = 'Period(ms)'
  end
  object Label3: TLabel
    Left = 10
    Top = 85
    Width = 76
    Height = 13
    Caption = 'Noise Amplitude'
  end
  object Label4: TLabel
    Left = 10
    Top = 63
    Width = 46
    Height = 13
    Caption = 'Amplitude'
  end
  object Label5: TLabel
    Left = 10
    Top = 107
    Width = 81
    Height = 13
    Caption = 'Event Frequency'
  end
  object cbTagStart: TCheckBoxV
    Left = 9
    Top = 127
    Width = 210
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use Tag Channels'
    TabOrder = 0
    UpdateVarOnToggle = False
  end
  object BOK: TButton
    Left = 48
    Top = 159
    Width = 56
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 126
    Top = 159
    Width = 56
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cbModel: TcomboBoxV
    Left = 100
    Top = 16
    Width = 122
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'cbModel'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object enPeriod: TeditNum
    Left = 100
    Top = 38
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '1000'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enNoise: TeditNum
    Left = 100
    Top = 82
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '1000'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enAmplitude: TeditNum
    Left = 100
    Top = 60
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '1000'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enFreq: TeditNum
    Left = 100
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 7
    Text = '1000'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
