inherited GetVSBM: TGetVSBM
  Left = 549
  Top = 447
  Height = 303
  Caption = 'GetVSBM'
  OnCreate = FormCreate
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
  object Label1: TLabel
    Left = 3
    Top = 85
    Width = 11
    Height = 13
    Caption = 'x0'
  end
  object Label2: TLabel
    Left = 3
    Top = 105
    Width = 11
    Height = 13
    Caption = 'y0'
  end
  object Label3: TLabel
    Left = 3
    Top = 125
    Width = 24
    Height = 13
    Caption = 'theta'
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
    OnKeyUp = enXKeyUp
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enY: TeditNum
    Tag = 2
    Left = 42
    Top = 23
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 1
    OnExit = enXExit
    OnKeyUp = enXKeyUp
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
    TabOrder = 2
    OnExit = enXExit
    OnKeyUp = enXKeyUp
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
    TabOrder = 3
    OnExit = enXExit
    OnKeyUp = enXKeyUp
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object CheckOnScreen: TCheckBox
    Left = 2
    Top = 192
    Width = 91
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 4
    OnClick = CheckOnScreenClick
  end
  object CheckOnControl: TCheckBox
    Left = 99
    Top = 191
    Width = 79
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 5
    OnClick = CheckOnControlClick
  end
  object enX0: TeditNum
    Tag = 5
    Left = 43
    Top = 83
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 6
    OnExit = enXExit
    OnKeyUp = enXKeyUp
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enY0: TeditNum
    Tag = 7
    Left = 43
    Top = 103
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 7
    OnExit = enXExit
    OnKeyUp = enXKeyUp
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbX: TscrollbarV
    Left = 97
    Top = 4
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 8
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
  object sbY: TscrollbarV
    Left = 97
    Top = 24
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 9
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
  object sbDx: TscrollbarV
    Left = 97
    Top = 44
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 10
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
  object sbDy: TscrollbarV
    Left = 97
    Top = 65
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 11
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
  object sbX0: TscrollbarV
    Left = 97
    Top = 84
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 12
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
  object sbY0: TscrollbarV
    Left = 97
    Top = 104
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 13
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
  object CheckLocked: TCheckBox
    Left = 4
    Top = 210
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Locked'
    TabOrder = 14
    OnClick = CheckLockedClick
  end
  object GroupBox1: TGroupBox
    Left = 2
    Top = 153
    Width = 159
    Height = 34
    Caption = 'File'
    TabOrder = 15
    object LabelFile: TLabel
      Left = 8
      Top = 15
      Width = 47
      Height = 13
      Caption = 'Piero.bmp'
    end
  end
  object BitBtn1: TBitBtn
    Left = 164
    Top = 168
    Width = 14
    Height = 15
    TabOrder = 16
    OnClick = BitBtn1Click
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333300000000000
      0033388888888888883330F888888888803338F333333333383330F333333333
      803338F333333333383330F333333333803338F333333333383330F333303333
      803338F333333333383330F333000333803338F333333333383330F330000033
      803338F333333333383330F333000333803338F333333333383330F333303333
      803338F333333333383330F333333333803338F333333333383330F333333333
      803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
      0033388888888888883333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object enTheta: TeditNum
    Tag = 4
    Left = 43
    Top = 123
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 17
    OnExit = enXExit
    OnKeyUp = enXKeyUp
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sbTheta: TscrollbarV
    Left = 97
    Top = 124
    Width = 80
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 18
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbXScrollV
  end
end
