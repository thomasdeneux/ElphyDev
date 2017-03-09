inherited getTranslation1: TgetTranslation1
  Height = 253
  Caption = 'getTranslation1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Top = 200
  end
  object Label1: TLabel [1]
    Left = 8
    Top = 48
    Width = 85
    Height = 13
    Caption = 'Initial coordinates:'
  end
  object Lx: TLabel [2]
    Left = 2
    Top = 72
    Width = 11
    Height = 13
    Caption = 'x0'
  end
  object Ly: TLabel [3]
    Left = 2
    Top = 92
    Width = 11
    Height = 13
    Caption = 'y0'
  end
  object Label4: TLabel [4]
    Left = 8
    Top = 111
    Width = 34
    Height = 13
    Caption = 'Speed:'
  end
  object Label5: TLabel [5]
    Left = 2
    Top = 133
    Width = 12
    Height = 13
    Caption = 'v0'
  end
  object Label6: TLabel [6]
    Left = 2
    Top = 152
    Width = 30
    Height = 13
    Caption = 'theta0'
  end
  object Label10: TLabel [7]
    Left = 6
    Top = 28
    Width = 30
    Height = 13
    Caption = 'DtON:'
  end
  object Label11: TLabel [8]
    Left = 92
    Top = 28
    Width = 34
    Height = 13
    Caption = 'DtOFF:'
  end
  object Label12: TLabel [9]
    Left = 90
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Cycles:'
  end
  object Label13: TLabel [10]
    Left = 6
    Top = 8
    Width = 30
    Height = 13
    Caption = 'Delay:'
  end
  inherited CBvisual: TComboBox
    Top = 195
  end
  object enX: TeditNum
    Left = 42
    Top = 69
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 1
    OnExit = sbxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object SBx: TScrollBar
    Tag = 1
    Left = 97
    Top = 69
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 2
    OnChange = sbxChange
  end
  object enY: TeditNum
    Left = 42
    Top = 89
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 3
    OnExit = sbxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object SBy: TScrollBar
    Tag = 2
    Left = 97
    Top = 89
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 4
    OnChange = sbxChange
  end
  object enV0: TeditNum
    Left = 42
    Top = 130
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 5
    OnExit = sbxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbV0: TScrollBar
    Tag = 3
    Left = 97
    Top = 130
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 6
    OnChange = sbxChange
  end
  object enTheta0: TeditNum
    Left = 42
    Top = 150
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 7
    OnExit = sbxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbTheta0: TScrollBar
    Tag = 4
    Left = 97
    Top = 150
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 8
    OnChange = sbxChange
  end
  object CheckLocked: TCheckBox
    Left = 5
    Top = 175
    Width = 72
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 9
    OnClick = CheckLockedClick
  end
  object CheckOnControl: TCheckBox
    Left = 96
    Top = 175
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 10
    OnClick = CheckOnControlClick
  end
  object enDtON: TeditNum
    Left = 37
    Top = 25
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 11
    OnExit = sbxChange
    Tnum = T_byte
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
    TabOrder = 12
    OnExit = sbxChange
    Tnum = T_byte
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
    TabOrder = 13
    OnExit = sbxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDelay: TeditNum
    Left = 37
    Top = 7
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 14
    OnExit = sbxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
