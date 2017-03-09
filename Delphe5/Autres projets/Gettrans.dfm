object getTranslation: TgetTranslation
  Left = 376
  Top = 153
  Width = 190
  Height = 251
  Caption = 'Translation'
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  OnKeyDown = FormKeyDown
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 71
    Width = 85
    Height = 13
    Caption = 'Initial coordinates:'
  end
  object Lx: TLabel
    Left = 2
    Top = 95
    Width = 11
    Height = 13
    Caption = 'x0'
  end
  object Ly: TLabel
    Left = 2
    Top = 115
    Width = 11
    Height = 13
    Caption = 'y0'
  end
  object Label2: TLabel
    Left = 2
    Top = 7
    Width = 30
    Height = 13
    Caption = 'DtON:'
  end
  object Label3: TLabel
    Left = 8
    Top = 134
    Width = 34
    Height = 13
    Caption = 'Speed:'
  end
  object Label4: TLabel
    Left = 2
    Top = 156
    Width = 12
    Height = 13
    Caption = 'v0'
  end
  object Label5: TLabel
    Left = 2
    Top = 175
    Width = 30
    Height = 13
    Caption = 'theta0'
  end
  object Label6: TLabel
    Left = 2
    Top = 27
    Width = 34
    Height = 13
    Caption = 'DtOFF:'
  end
  object Label7: TLabel
    Left = 2
    Top = 47
    Width = 31
    Height = 13
    Caption = 'Cycles'
  end
  object enX: TeditNum
    Left = 42
    Top = 92
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 0
    Text = 'enX'
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object SBx: TScrollBar
    Tag = 1
    Left = 97
    Top = 92
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 1
    OnChange = SBxChange
  end
  object enY: TeditNum
    Left = 42
    Top = 112
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 2
    Text = 'enY'
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object SBy: TScrollBar
    Tag = 2
    Left = 97
    Top = 112
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 3
    OnChange = SBxChange
  end
  object enDtON: TeditNum
    Left = 42
    Top = 5
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 4
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enV0: TeditNum
    Left = 42
    Top = 153
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 5
    Text = 'enX'
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbV0: TScrollBar
    Tag = 3
    Left = 97
    Top = 153
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 6
    OnChange = SBxChange
  end
  object enTheta0: TeditNum
    Left = 42
    Top = 173
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 7
    Text = 'enY'
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbTheta0: TScrollBar
    Tag = 4
    Left = 97
    Top = 173
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 8
    OnChange = SBxChange
  end
  object enDtOff: TeditNum
    Left = 42
    Top = 25
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 9
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enCycleCount: TeditNum
    Left = 42
    Top = 45
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 10
    Text = 'editNum3'
    OnExit = SBxChange
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object CheckLocked: TCheckBoxV
    Left = 12
    Top = 198
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 11
    OnClick = CheckLockedClick
    UpdateVarOnToggle = False
  end
  object CheckOnControl: TCheckBoxV
    Left = 96
    Top = 198
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 12
    OnClick = CheckOnControlClick
    UpdateVarOnToggle = False
  end
  object sbDtOn: TScrollBar
    Tag = 5
    Left = 97
    Top = 6
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 13
    OnChange = SBxChange
  end
  object sbDtOff: TScrollBar
    Tag = 6
    Left = 97
    Top = 26
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 14
    OnChange = SBxChange
  end
  object sbCycles: TScrollBar
    Tag = 7
    Left = 97
    Top = 46
    Width = 80
    Height = 17
    LargeChange = 10
    TabOrder = 15
    OnChange = SBxChange
  end
end
