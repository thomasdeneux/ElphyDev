object EditRegList: TEditRegList
  Left = 403
  Top = 194
  Width = 415
  Height = 209
  BorderStyle = bsSizeToolWin
  Caption = 'Region list'
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
    Width = 407
    Height = 148
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
      Width = 407
      Height = 148
      ColWidths = (
        64
        64
        126
        64
        64)
    end
    inherited ColorDialog1: TColorDialog
      Left = 8
      Top = 112
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 148
    Width = 407
    Height = 34
    Align = alBottom
    TabOrder = 1
    object Bclose: TButton
      Left = 184
      Top = 7
      Width = 90
      Height = 20
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 0
    end
    object BchangeColors: TButton
      Left = 65
      Top = 7
      Width = 90
      Height = 20
      Caption = 'Change all colors'
      TabOrder = 1
      OnClick = BchangeColorsClick
    end
  end
end
