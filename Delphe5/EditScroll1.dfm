object EditScroll: TEditScroll
  Left = 0
  Top = 0
  Width = 248
  Height = 24
  TabOrder = 0
  object Lb: TLabel
    Left = 2
    Top = 3
    Width = 12
    Height = 13
    Caption = 'Lb'
  end
  object en: TeditNum
    Left = 47
    Top = 0
    Width = 73
    Height = 21
    TabOrder = 0
    Text = 'en'
    OnExit = enExit
    OnKeyDown = enKeyDown
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object sb: TscrollbarV
    Left = 125
    Top = 2
    Width = 100
    Height = 17
    Max = 30000
    PageSize = 0
    TabOrder = 1
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbScrollV
  end
end
