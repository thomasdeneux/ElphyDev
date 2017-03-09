object LineForm: TLineForm
  Left = 523
  Top = 190
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Obvis'
  ClientHeight = 106
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
  object Ltheta: TLabel
    Left = 2
    Top = 45
    Width = 28
    Height = 13
    Caption = 'Theta'
  end
  object Label1: TLabel
    Left = 2
    Top = 66
    Width = 24
    Height = 13
    Caption = 'Color'
  end
  object enX: TeditNum
    Left = 42
    Top = 3
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
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enTheta: TeditNum
    Left = 42
    Top = 43
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 3
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
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
    TabOrder = 4
    OnChange = enXExit
  end
  object SBtheta: TScrollBar
    Tag = 3
    Left = 97
    Top = 43
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 5
    OnChange = enXExit
  end
  object CheckOnScreen: TCheckBoxV
    Left = 12
    Top = 86
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 6
    OnClick = CheckOnScreenClick
    UpdateVarOnToggle = False
  end
  object enColor: TeditNum
    Left = 42
    Top = 63
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 7
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object CheckOnControl: TCheckBoxV
    Left = 97
    Top = 86
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 8
    OnClick = CheckOnControlClick
    UpdateVarOnToggle = False
  end
  object CheckLocked: TCheckBoxV
    Left = 96
    Top = 65
    Width = 76
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 9
    OnClick = CheckLockedClick
    UpdateVarOnToggle = False
  end
end
