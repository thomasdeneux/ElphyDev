object getPhaseTrans: TgetPhaseTrans
  Left = 376
  Top = 153
  Width = 190
  Height = 87
  Caption = 'Default form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 7
    Width = 31
    Height = 13
    Caption = 'Speed'
  end
  object Label2: TLabel
    Left = 4
    Top = 37
    Width = 60
    Height = 13
    Caption = 'Visual object'
  end
  object enSpeed: TeditNum
    Left = 76
    Top = 5
    Width = 57
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object CBobvis: TcomboBoxV
    Left = 76
    Top = 33
    Width = 104
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'CBobvis'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
end
