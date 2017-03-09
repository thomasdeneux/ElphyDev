object TableFrameTest: TTableFrameTest
  Left = 422
  Top = 234
  Width = 696
  Height = 480
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'TableFrameTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline TableFrame1: TTableFrame
    Left = 0
    Top = 0
    Width = 688
    Height = 446
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    inherited DrawGrid1: TDrawGrid
      Width = 688
      Height = 446
    end
  end
end
