inherited getGabor1: TgetGabor1
  Caption = 'getGabor1'
  ClientHeight = 256
  PixelsPerInch = 96
  TextHeight = 13
  inherited Ltheta: TLabel
    Top = 86
  end
  inherited Label1: TLabel
    Left = 42
    Top = 264
    Visible = False
  end
  object Label5: TLabel [6]
    Left = 2
    Top = 104
    Width = 31
    Height = 13
    Caption = 'Orient.'
  end
  object Label6: TLabel [7]
    Left = 2
    Top = 123
    Width = 28
    Height = 13
    Caption = 'Contr.'
  end
  object Label7: TLabel [8]
    Left = 2
    Top = 143
    Width = 30
    Height = 13
    Caption = 'Period'
  end
  object Label8: TLabel [9]
    Left = 2
    Top = 162
    Width = 30
    Height = 13
    Caption = 'Phase'
  end
  object Label2: TLabel [10]
    Left = 2
    Top = 181
    Width = 11
    Height = 13
    Caption = 'Lx'
  end
  object Label3: TLabel [11]
    Left = 2
    Top = 200
    Width = 11
    Height = 13
    Caption = 'Ly'
  end
  inherited enLum: TeditNum
    Visible = False
  end
  inherited CheckLocked: TCheckBox
    Left = 98
    Top = 217
  end
  inherited CheckOnScreen: TCheckBox
    Left = 98
    Top = 234
    Width = 80
  end
  inherited CheckOnControl: TCheckBox
    Left = 4
    Top = 235
    Width = 88
  end
  object enOrient: TeditNum
    Left = 42
    Top = 102
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 14
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enContrast: TeditNum
    Left = 42
    Top = 121
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 15
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enPeriod: TeditNum
    Left = 42
    Top = 141
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 16
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enPhase: TeditNum
    Left = 42
    Top = 161
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 17
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object sbOrient: TscrollbarV
    Tag = 6
    Left = 98
    Top = 103
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 18
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
  object sbContrast: TscrollbarV
    Tag = 7
    Left = 97
    Top = 122
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 19
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
  object sbPeriod: TscrollbarV
    Tag = 8
    Left = 97
    Top = 143
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 20
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
  object sbPhase: TscrollbarV
    Tag = 9
    Left = 97
    Top = 162
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 21
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
  object enLx: TeditNum
    Left = 42
    Top = 180
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 22
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object sbLx: TscrollbarV
    Tag = 10
    Left = 97
    Top = 181
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 23
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
  object enLy: TeditNum
    Left = 42
    Top = 199
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 24
    OnExit = enXExit
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object sbLy: TscrollbarV
    Tag = 11
    Left = 97
    Top = 200
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 25
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
end
