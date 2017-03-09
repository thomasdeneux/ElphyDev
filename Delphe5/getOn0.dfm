inherited getOnOff1: TgetOnOff1
  Height = 105
  Caption = 'getOnOff1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Left = 5
    Top = 52
  end
  object Label10: TLabel [1]
    Left = 6
    Top = 28
    Width = 30
    Height = 13
    Caption = 'DtON:'
  end
  object Label11: TLabel [2]
    Left = 92
    Top = 28
    Width = 34
    Height = 13
    Caption = 'DtOFF:'
  end
  object Label12: TLabel [3]
    Left = 90
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Cycles:'
  end
  object Label13: TLabel [4]
    Left = 6
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Start t.'
  end
  inherited CBvisual: TComboBox
    Top = 48
  end
  object enDtON: TeditNum
    Left = 37
    Top = 25
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 1
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enDtOff: TeditNum
    Left = 127
    Top = 26
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 2
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enCycleCount: TeditNum
    Left = 127
    Top = 6
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 3
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enDelay: TeditNum
    Left = 37
    Top = 7
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 4
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
end
