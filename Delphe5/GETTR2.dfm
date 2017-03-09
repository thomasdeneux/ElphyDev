inherited getTranslation2: TgetTranslation2
  Left = 456
  Top = 158
  Height = 298
  Caption = 'getTranslation2'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Top = 243
  end
  object Label1: TLabel [5]
    Left = 8
    Top = 48
    Width = 85
    Height = 13
    Caption = 'Initial coordinates:'
  end
  object Lx: TLabel [6]
    Left = 2
    Top = 72
    Width = 11
    Height = 13
    Caption = 'x0'
  end
  object Ly: TLabel [7]
    Left = 2
    Top = 92
    Width = 11
    Height = 13
    Caption = 'y0'
  end
  object Label4: TLabel [8]
    Left = 8
    Top = 111
    Width = 34
    Height = 13
    Caption = 'Speed:'
  end
  object Label5: TLabel [9]
    Left = 2
    Top = 133
    Width = 12
    Height = 13
    Caption = 'v0'
  end
  object Label6: TLabel [10]
    Left = 2
    Top = 152
    Width = 30
    Height = 13
    Caption = 'theta0'
  end
  inherited CBvisual: TComboBox
    Top = 239
  end
  inherited enDtON: TeditNum
    OnExit = ChangePos
  end
  inherited enDtOff: TeditNum
    OnExit = ChangePos
  end
  inherited enCycleCount: TeditNum
    OnExit = ChangePos
  end
  inherited enDelay: TeditNum
    OnExit = ChangePos
  end
  object enX: TeditNum
    Left = 42
    Top = 69
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 5
    OnExit = ChangePos
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object SBx: TScrollBar
    Tag = 1
    Left = 97
    Top = 69
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 6
    OnChange = ChangePos
  end
  object enY: TeditNum
    Left = 42
    Top = 89
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 7
    OnExit = ChangePos
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object SBy: TScrollBar
    Tag = 2
    Left = 97
    Top = 89
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 8
    OnChange = ChangePos
  end
  object enV0: TeditNum
    Left = 42
    Top = 130
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 9
    OnExit = ChangePos
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object sbV0: TScrollBar
    Tag = 3
    Left = 97
    Top = 130
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 10
    OnChange = ChangePos
  end
  object enTheta0: TeditNum
    Left = 42
    Top = 150
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 11
    OnExit = ChangePos
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object sbTheta0: TScrollBar
    Tag = 4
    Left = 97
    Top = 150
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 12
    OnChange = ChangePos
  end
  object CheckLocked: TCheckBox
    Left = 5
    Top = 214
    Width = 72
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 13
    OnClick = CheckLockedClick
  end
  object CheckOnControl: TCheckBox
    Left = 96
    Top = 214
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 14
    OnClick = CheckOnControlClick
  end
  object CheckBNforth: TCheckBoxV
    Left = 3
    Top = 175
    Width = 91
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Back and forth'
    TabOrder = 15
    UpdateVarOnToggle = True
  end
  object CheckOrtho: TCheckBoxV
    Left = 103
    Top = 175
    Width = 73
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Orthogonal'
    TabOrder = 16
    UpdateVarOnToggle = True
  end
  object CheckInitPos: TCheckBoxV
    Left = 4
    Top = 193
    Width = 110
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Keep initial position'
    TabOrder = 17
    UpdateVarOnToggle = True
  end
end
