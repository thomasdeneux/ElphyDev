inherited getRevCor1: TgetRevCor1
  Height = 225
  Caption = 'getRevCor1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Top = 171
  end
  object Label1: TLabel [1]
    Left = 5
    Top = 9
    Width = 54
    Height = 13
    Caption = ' divX count'
  end
  object Label2: TLabel [2]
    Left = 4
    Top = 31
    Width = 54
    Height = 13
    Caption = ' divY count'
  end
  object Label4: TLabel [3]
    Left = 8
    Top = 55
    Width = 30
    Height = 13
    Caption = 'Color1'
  end
  object Label5: TLabel [4]
    Left = 88
    Top = 54
    Width = 30
    Height = 13
    Caption = 'Color2'
  end
  object Label6: TLabel [5]
    Left = 5
    Top = 76
    Width = 52
    Height = 13
    Caption = ' Expansion'
  end
  object Label7: TLabel [6]
    Left = 7
    Top = 98
    Width = 42
    Height = 13
    Caption = 'Scotome'
  end
  object Label8: TLabel [7]
    Left = 8
    Top = 121
    Width = 14
    Height = 13
    Caption = 'RF'
  end
  object Label9: TLabel [8]
    Left = 88
    Top = 120
    Width = 25
    Height = 13
    Caption = 'Seed'
  end
  inherited CBvisual: TComboBox
    Top = 167
  end
  object enDivX: TeditNum
    Left = 109
    Top = 6
    Width = 64
    Height = 21
    TabOrder = 1
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enDivY: TeditNum
    Left = 109
    Top = 29
    Width = 64
    Height = 21
    TabOrder = 2
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enCol1: TeditNum
    Left = 40
    Top = 52
    Width = 41
    Height = 21
    TabOrder = 3
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enCol2: TeditNum
    Left = 131
    Top = 51
    Width = 42
    Height = 21
    TabOrder = 4
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enExpansion: TeditNum
    Left = 109
    Top = 73
    Width = 64
    Height = 21
    TabOrder = 5
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enScotome: TeditNum
    Left = 109
    Top = 95
    Width = 64
    Height = 21
    TabOrder = 6
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enRF: TeditNum
    Left = 40
    Top = 118
    Width = 41
    Height = 21
    TabOrder = 7
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enSeed: TeditNum
    Left = 128
    Top = 118
    Width = 45
    Height = 21
    TabOrder = 8
    UpdateVarOnExit = False
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object cbOnControl: TCheckBox
    Left = 7
    Top = 146
    Width = 74
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 9
  end
  object cbOnScreen: TCheckBox
    Left = 99
    Top = 145
    Width = 74
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 10
  end
end
