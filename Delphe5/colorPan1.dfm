object colorPan: TcolorPan
  Left = 0
  Top = 0
  Width = 144
  Height = 22
  TabOrder = 0
  object Bcol: TButton
    Left = 0
    Top = 1
    Width = 63
    Height = 20
    Caption = 'Color'
    TabOrder = 0
    OnClick = BcolClick
  end
  object Pcol: TPanel
    Left = 69
    Top = 1
    Width = 56
    Height = 20
    TabOrder = 1
  end
  object ColorDialog1: TColorDialog
    Left = 133
    Top = 4
  end
end
