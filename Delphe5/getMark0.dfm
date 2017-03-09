inherited MarkForm: TMarkForm
  Height = 119
  Caption = 'MarkForm'
  PixelsPerInch = 96
  TextHeight = 13
  object Lx: TLabel
    Left = 2
    Top = 5
    Width = 5
    Height = 13
    Caption = 'x'
  end
  object Ly: TLabel
    Left = 2
    Top = 25
    Width = 5
    Height = 13
    Caption = 'y'
  end
  object Label1: TLabel
    Left = 2
    Top = 46
    Width = 20
    Height = 13
    Caption = 'Lum'
  end
  object enX: TeditNum
    Left = 42
    Top = 5
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 0
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object SBx: TScrollBar
    Tag = 1
    Left = 97
    Top = 4
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 1
    OnChange = enXExit
  end
  object enY: TeditNum
    Left = 42
    Top = 23
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 2
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object SBy: TScrollBar
    Tag = 2
    Left = 97
    Top = 24
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 3
    OnChange = enXExit
  end
  object CheckOnScreen: TCheckBoxV
    Left = 12
    Top = 66
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 4
    OnClick = CheckOnScreenClick
    UpdateVarOnToggle = False
  end
  object enLum: TeditNum
    Left = 42
    Top = 43
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 5
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object CheckOnControl: TCheckBoxV
    Left = 97
    Top = 66
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 6
    OnClick = CheckOnControlClick
    UpdateVarOnToggle = False
  end
  object CheckLocked: TCheckBoxV
    Left = 96
    Top = 45
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 7
    OnClick = CheckLockedClick
    UpdateVarOnToggle = False
  end
end
