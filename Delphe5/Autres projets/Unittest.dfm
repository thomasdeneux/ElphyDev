object Ftest: TFtest
  Left = 258
  Top = 184
  Width = 435
  Height = 300
  Caption = 'Ftest'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object editNum1: TeditNum
    Left = 74
    Top = 21
    Width = 110
    Height = 21
    TabOrder = 0
    Text = 'editNum1'
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum2: TeditNum
    Left = 76
    Top = 51
    Width = 104
    Height = 21
    TabOrder = 1
    Text = 'editNum2'
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object comboBoxV1: TcomboBoxV
    Left = 80
    Top = 98
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'comboBoxV1'
    Tnum = T_byte
    UpdateVarOnExit = False
  end
  object Button1: TButton
    Left = 99
    Top = 186
    Width = 75
    Height = 25
    Caption = 'Button1'
    ModalResult = 1
    TabOrder = 3
  end
end
