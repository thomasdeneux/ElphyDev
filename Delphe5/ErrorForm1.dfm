object ErrorForm: TErrorForm
  Left = 778
  Top = 235
  Width = 750
  Height = 344
  Caption = 'Error History List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline TableFrame1: TTableFrame
    Left = 0
    Top = 0
    Width = 742
    Height = 279
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    inherited DrawGrid1: TDrawGrid
      Width = 742
      Height = 279
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 279
    Width = 742
    Height = 38
    Align = alBottom
    TabOrder = 0
    object BClear: TButton
      Left = 24
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Clear Messages'
      TabOrder = 0
      OnClick = BClearClick
    end
  end
end
