inherited getGrating2: TgetGrating2
  Caption = 'getGrating2'
  ClientHeight = 252
  PixelsPerInch = 96
  TextHeight = 13
  inherited Lx: TLabel
    Top = 8
  end
  inherited Ly: TLabel
    Top = 28
  end
  inherited Ldx: TLabel
    Top = 48
  end
  inherited Ldy: TLabel
    Top = 68
  end
  inherited Ltheta: TLabel
    Top = 89
  end
  inherited Label1: TLabel
    Left = 42
    Top = 223
    Visible = False
  end
  object Label5: TLabel [6]
    Left = 2
    Top = 107
    Width = 31
    Height = 13
    Caption = 'Orient.'
  end
  object Label6: TLabel [7]
    Left = 2
    Top = 126
    Width = 28
    Height = 13
    Caption = 'Contr.'
  end
  object Label7: TLabel [8]
    Left = 2
    Top = 146
    Width = 30
    Height = 13
    Caption = 'Period'
  end
  object Label8: TLabel [9]
    Left = 2
    Top = 165
    Width = 30
    Height = 13
    Caption = 'Phase'
  end
  inherited enX: TeditNum
    Top = 6
    OnEnter = enXExit
    OnKeyDown = nil
  end
  inherited SBx: TScrollBar
    Top = 6
  end
  inherited enY: TeditNum
    Top = 26
    OnEnter = enXExit
    OnKeyDown = nil
  end
  inherited enDX: TeditNum
    Top = 46
    OnEnter = enXExit
    OnKeyDown = nil
  end
  inherited enDY: TeditNum
    Top = 66
    OnEnter = enXExit
    OnKeyDown = nil
  end
  inherited enTheta: TeditNum
    Top = 86
    OnEnter = enXExit
    OnKeyDown = nil
  end
  inherited SBy: TScrollBar
    Top = 26
  end
  inherited SBdx: TScrollBar
    Top = 47
  end
  inherited SBdy: TScrollBar
    Top = 66
  end
  inherited SBtheta: TScrollBar
    Left = 98
    Top = 86
  end
  inherited enLum: TeditNum
    Visible = False
  end
  inherited CheckLocked: TCheckBox
    Top = 183
  end
  inherited CheckOnScreen: TCheckBox
    Left = 98
    Top = 200
    Width = 80
  end
  inherited CheckOnControl: TCheckBox
    Left = 4
    Top = 202
    Width = 88
  end
  object cbCircle: TCheckBox
    Left = 3
    Top = 184
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'elliptic outline '
    TabOrder = 14
    OnClick = cbCircleClick
  end
  object enOrient: TeditNum
    Tag = 101
    Left = 42
    Top = 105
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 15
    OnExit = enOrientExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enContrast: TeditNum
    Tag = 102
    Left = 42
    Top = 124
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 16
    OnExit = enOrientExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enPeriod: TeditNum
    Tag = 103
    Left = 42
    Top = 144
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 17
    OnExit = enOrientExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enPhase: TeditNum
    Tag = 104
    Left = 42
    Top = 164
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 18
    OnExit = enOrientExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object sbOrient: TscrollbarV
    Tag = 6
    Left = 98
    Top = 106
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 19
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbOrientScrollV
  end
  object sbContrast: TscrollbarV
    Left = 97
    Top = 125
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 20
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbOrientScrollV
  end
  object sbPeriod: TscrollbarV
    Left = 97
    Top = 146
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 21
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbOrientScrollV
  end
  object sbPhase: TscrollbarV
    Left = 97
    Top = 165
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 22
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbOrientScrollV
  end
end
