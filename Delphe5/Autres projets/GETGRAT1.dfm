object getGrating1: TgetGrating1
  Left = 526
  Top = 193
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Obvis'
  ClientHeight = 170
  ClientWidth = 182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  OnKeyDown = FormKeyDown
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
  object Ldx: TLabel
    Left = 2
    Top = 45
    Width = 11
    Height = 13
    Caption = 'dx'
  end
  object Ldy: TLabel
    Left = 2
    Top = 65
    Width = 11
    Height = 13
    Caption = 'dy'
  end
  object Ltheta: TLabel
    Left = 2
    Top = 85
    Width = 28
    Height = 13
    Caption = 'Theta'
  end
  object Label1: TLabel
    Left = 2
    Top = 105
    Width = 28
    Height = 13
    Caption = 'Contr:'
  end
  object Label3: TLabel
    Left = 2
    Top = 125
    Width = 30
    Height = 13
    Caption = 'Period'
  end
  object Label4: TLabel
    Left = 2
    Top = 145
    Width = 30
    Height = 13
    Caption = 'Phase'
  end
  object enX: TeditNum
    Left = 42
    Top = 3
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 0
    OnExit = enXExit
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object SBx: TScrollBar
    Tag = 1
    Left = 97
    Top = 3
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
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDX: TeditNum
    Left = 42
    Top = 43
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 3
    OnExit = enXExit
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDY: TeditNum
    Left = 42
    Top = 63
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 4
    OnExit = enXExit
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enTheta: TeditNum
    Left = 41
    Top = 83
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 5
    OnExit = enXExit
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object SBy: TScrollBar
    Tag = 2
    Left = 97
    Top = 23
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 6
    OnChange = enXExit
  end
  object SBdx: TScrollBar
    Tag = 3
    Left = 97
    Top = 43
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 7
    OnChange = enXExit
  end
  object SBdy: TScrollBar
    Tag = 4
    Left = 97
    Top = 63
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 8
    OnChange = enXExit
  end
  object SBtheta: TScrollBar
    Tag = 5
    Left = 97
    Top = 83
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 9
    OnChange = enXExit
  end
  object enContrast: TeditNum
    Left = 42
    Top = 103
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 10
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enPeriod: TeditNum
    Left = 42
    Top = 123
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 11
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enPhase: TeditNum
    Left = 42
    Top = 142
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 12
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object CheckLocked: TCheckBox
    Left = 97
    Top = 103
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 13
    OnClick = CheckLockedClick
  end
  object CheckOnControl: TCheckBox
    Left = 97
    Top = 123
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 14
    OnClick = CheckOnControlClick
  end
  object CheckOnScreen: TCheckBox
    Left = 97
    Top = 143
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 15
    OnClick = CheckOnScreenClick
  end
end
