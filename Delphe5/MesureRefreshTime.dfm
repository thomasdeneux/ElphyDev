object RefreshTimeMeasurement: TRefreshTimeMeasurement
  Left = 477
  Top = 320
  Width = 259
  Height = 152
  Caption = 'Refresh Time Measurement'
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
    Left = 16
    Top = 24
    Width = 102
    Height = 13
    Caption = 'Sampling interval (ms)'
  end
  object Label2: TLabel
    Left = 16
    Top = 47
    Width = 118
    Height = 13
    Caption = 'Acquisition duration (sec)'
  end
  object enSampleInt: TeditNum
    Left = 152
    Top = 21
    Width = 84
    Height = 21
    TabOrder = 0
    Text = '0.010'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enAcqDur: TeditNum
    Left = 152
    Top = 44
    Width = 84
    Height = 21
    TabOrder = 1
    Text = '0.010'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 52
    Top = 82
    Width = 63
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 138
    Top = 82
    Width = 63
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
