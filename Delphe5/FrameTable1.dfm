object TableFrame: TTableFrame
  Left = 0
  Top = 0
  Width = 356
  Height = 166
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object DrawGrid1: TDrawGrid
    Left = 0
    Top = 0
    Width = 356
    Height = 166
    Align = alClient
    DefaultRowHeight = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    ParentFont = False
    TabOrder = 0
    OnDblClick = DrawGrid1DblClick
    OnDrawCell = DrawGrid1DrawCell
    OnMouseDown = DrawGrid1MouseDown
    OnSelectCell = DrawGrid1SelectCell
    OnTopLeftChanged = DrawGrid1TopLeftChanged
  end
  object ColorDialog1: TColorDialog
    Left = 128
    Top = 136
  end
end
