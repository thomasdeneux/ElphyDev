object ListGViewer: TListGViewer
  Left = 489
  Top = 221
  Width = 338
  Height = 257
  Caption = 'ListGViewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 330
    Height = 223
    Style = lbOwnerDrawFixed
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
    OnDrawItem = ListBox1DrawItem
  end
end
