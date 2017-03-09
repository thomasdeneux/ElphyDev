inherited getPhaseTrans: TgetPhaseTrans
  Height = 150
  Caption = 'getPhaseTrans'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Top = 99
  end
  object Label1: TLabel [5]
    Left = 8
    Top = 54
    Width = 62
    Height = 13
    Caption = 'Phase speed'
  end
  object Label2: TLabel [6]
    Left = 8
    Top = 75
    Width = 56
    Height = 13
    Caption = 'Initial phase'
  end
  inherited CBvisual: TComboBox
    Top = 95
  end
  object EnSpeed: TeditNum
    Left = 111
    Top = 49
    Width = 65
    Height = 21
    TabOrder = 5
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enPhase0: TeditNum
    Left = 111
    Top = 70
    Width = 65
    Height = 21
    TabOrder = 6
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
end
