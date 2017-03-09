object FrameTest: TFrameTest
  Left = 0
  Top = 0
  Width = 248
  Height = 30
  TabOrder = 0
  object Lb: TLabel
    Left = 2
    Top = 9
    Width = 12
    Height = 13
    Caption = 'Lb'
  end
  object ed: TeditNum
    Left = 47
    Top = 5
    Width = 73
    Height = 21
    TabOrder = 0
    Text = 'ed'
    Tnum = T_byte
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1
  end
  object sb: TscrollbarV
    Left = 139
    Top = 7
    Width = 100
    Height = 16
    Max = 30000
    PageSize = 0
    TabOrder = 1
    Xmax = 1000
    dxSmall = 1
    dxLarge = 10
  end
end
