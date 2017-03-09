object DiskForm: TDiskForm
  Left = 523
  Top = 190
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Obvis'
  ClientHeight = 131
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
    Width = 24
    Height = 13
    Caption = 'Diam'
  end
  object Ltheta: TLabel
    Left = 2
    Top = 65
    Width = 28
    Height = 13
    Caption = 'Theta'
  end
  object Label1: TLabel
    Left = 2
    Top = 85
    Width = 20
    Height = 13
    Caption = 'Lum'
  end
  object enX: TeditNum
    Left = 42
    Top = 3
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 0
    OnExit = enXExit
    Tnum = G_byte
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
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDiam: TeditNum
    Left = 42
    Top = 43
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 3
    OnExit = enXExit
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enTheta: TeditNum
    Left = 42
    Top = 63
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 4
    OnExit = enXExit
    Tnum = G_byte
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
    TabOrder = 5
    OnChange = enXExit
  end
  object SBdiam: TScrollBar
    Tag = 3
    Left = 97
    Top = 43
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 6
    OnChange = enXExit
  end
  object SBtheta: TScrollBar
    Tag = 5
    Left = 97
    Top = 63
    Width = 80
    Height = 17
    LargeChange = 10
    PageSize = 0
    TabOrder = 7
    OnChange = enXExit
  end
  object enLum: TeditNum
    Left = 42
    Top = 83
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 8
    OnExit = enXExit
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object CheckLocked: TCheckBox
    Left = 98
    Top = 84
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 9
    OnClick = CheckLockedClick
  end
  object CheckOnScreen: TCheckBox
    Left = 3
    Top = 106
    Width = 90
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 10
    OnClick = CheckOnScreenClick
  end
  object CheckOnControl: TCheckBox
    Left = 99
    Top = 106
    Width = 80
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 11
    OnClick = CheckOnControlClick
  end
end
