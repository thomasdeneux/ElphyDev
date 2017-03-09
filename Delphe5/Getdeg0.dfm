object Degform: TDegform
  Left = 434
  Top = 199
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Obvis'
  ClientHeight = 147
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
    Width = 26
    Height = 13
    Caption = 'dx (L)'
  end
  object Ldy: TLabel
    Left = 2
    Top = 65
    Width = 31
    Height = 13
    Caption = 'dy (W)'
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
    Width = 20
    Height = 13
    Caption = 'Lum'
  end
  object enX: TeditNum
    Tag = 1
    Left = 42
    Top = 3
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 0
    OnExit = enXExit
    OnKeyDown = FormKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
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
    OnChange = SBxChange
  end
  object enY: TeditNum
    Tag = 2
    Left = 42
    Top = 23
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 2
    OnExit = enXExit
    OnKeyDown = FormKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDX: TeditNum
    Tag = 3
    Left = 42
    Top = 43
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 3
    OnExit = enXExit
    OnKeyDown = FormKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDY: TeditNum
    Tag = 4
    Left = 42
    Top = 63
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 4
    OnExit = enXExit
    OnKeyDown = FormKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enTheta: TeditNum
    Tag = 5
    Left = 42
    Top = 83
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 5
    OnExit = enXExit
    OnKeyDown = FormKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
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
    TabOrder = 6
    OnChange = SBxChange
  end
  object SBdx: TScrollBar
    Tag = 3
    Left = 97
    Top = 44
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 7
    OnChange = SBxChange
  end
  object SBdy: TScrollBar
    Tag = 4
    Left = 97
    Top = 64
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 8
    OnChange = SBxChange
  end
  object SBtheta: TScrollBar
    Tag = 5
    Left = 97
    Top = 84
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 9
    OnChange = SBxChange
  end
  object enLum: TeditNum
    Left = 42
    Top = 103
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 10
    OnExit = enXExit
    OnKeyDown = FormKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object CheckLocked: TCheckBox
    Left = 99
    Top = 105
    Width = 79
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 11
    OnClick = CheckLockedClick
  end
  object CheckOnScreen: TCheckBox
    Left = 2
    Top = 125
    Width = 91
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 12
    OnClick = CheckOnScreenClick
  end
  object CheckOnControl: TCheckBox
    Left = 99
    Top = 124
    Width = 79
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 13
    OnClick = CheckOnControlClick
  end
end
