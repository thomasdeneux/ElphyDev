inherited getRevCor1: TgetRevCor1
  Left = 384
  Top = 173
  Height = 285
  Caption = 'getRevCor1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Top = 231
  end
  object Label1: TLabel [1]
    Left = 3
    Top = 50
    Width = 54
    Height = 13
    Caption = ' divX count'
  end
  object Label2: TLabel [2]
    Left = 2
    Top = 72
    Width = 54
    Height = 13
    Caption = ' divY count'
  end
  object Label4: TLabel [3]
    Left = 6
    Top = 96
    Width = 26
    Height = 13
    Caption = 'Lum1'
  end
  object Label5: TLabel [4]
    Left = 88
    Top = 95
    Width = 26
    Height = 13
    Caption = 'Lum2'
  end
  object Label6: TLabel [5]
    Left = 3
    Top = 117
    Width = 52
    Height = 13
    Caption = ' Expansion'
  end
  object Label7: TLabel [6]
    Left = 5
    Top = 139
    Width = 42
    Height = 13
    Caption = 'Scotome'
  end
  object Label8: TLabel [7]
    Left = 8
    Top = 217
    Width = 14
    Height = 13
    Caption = 'RF'
  end
  object Label9: TLabel [8]
    Left = 83
    Top = 161
    Width = 25
    Height = 13
    Caption = 'Seed'
  end
  object Label10: TLabel [9]
    Left = 4
    Top = 28
    Width = 30
    Height = 13
    Caption = 'DtON:'
  end
  object Label11: TLabel [10]
    Left = 92
    Top = 28
    Width = 34
    Height = 13
    Caption = 'DtOFF:'
  end
  object Label12: TLabel [11]
    Left = 90
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Cycles:'
  end
  object Label13: TLabel [12]
    Left = 4
    Top = 8
    Width = 30
    Height = 13
    Caption = 'Delay:'
  end
  inherited CBvisual: TComboBox
    Top = 228
  end
  object enDivX: TeditNum
    Left = 103
    Top = 47
    Width = 74
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDivY: TeditNum
    Left = 103
    Top = 70
    Width = 74
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enLum1: TeditNum
    Left = 40
    Top = 94
    Width = 41
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enLum2: TeditNum
    Left = 135
    Top = 92
    Width = 42
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enExpansion: TeditNum
    Left = 103
    Top = 114
    Width = 74
    Height = 21
    TabOrder = 5
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enScotome: TeditNum
    Left = 103
    Top = 136
    Width = 74
    Height = 21
    TabOrder = 6
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enSeed: TeditNum
    Left = 122
    Top = 159
    Width = 55
    Height = 21
    TabOrder = 7
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbOnControl: TCheckBoxV
    Left = 5
    Top = 206
    Width = 74
    Height = 22
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 8
    OnClick = cbOnControlClick
  end
  object cbOnScreen: TCheckBoxV
    Left = 103
    Top = 205
    Width = 74
    Height = 22
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 9
    OnClick = cbOnScreenClick
  end
  object enDtON: TeditNum
    Left = 35
    Top = 25
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDtOff: TeditNum
    Left = 127
    Top = 26
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 11
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enCycleCount: TeditNum
    Left = 127
    Top = 6
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 12
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDelay: TeditNum
    Left = 35
    Top = 7
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 13
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 4
    Top = 158
    Width = 55
    Height = 20
    Caption = 'Select RF'
    TabOrder = 14
    OnClick = Button1Click
  end
  object CBadjust: TCheckBoxV
    Left = 5
    Top = 188
    Width = 106
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Adjust object size'
    TabOrder = 15
    UpdateVarOnToggle = True
  end
end
