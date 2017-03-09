object MtagProperties: TMtagProperties
  Left = 445
  Top = 241
  Width = 422
  Height = 276
  Caption = 'Mtag properties'
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
  object Panel1: TPanel
    Left = 0
    Top = 216
    Width = 414
    Height = 26
    Align = alBottom
    TabOrder = 0
    object Bgo: TButton
      Left = 20
      Top = 2
      Width = 56
      Height = 22
      Caption = 'Go'
      TabOrder = 0
      OnClick = BgoClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 414
    Height = 216
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 210
      Top = 1
      Height = 214
    end
    object MemoTag: TMemo
      Left = 213
      Top = 1
      Width = 200
      Height = 214
      Align = alClient
      TabOrder = 0
    end
    object VLBtag: TListBox
      Left = 1
      Top = 1
      Width = 209
      Height = 214
      Style = lbOwnerDrawFixed
      Align = alLeft
      ItemHeight = 13
      TabOrder = 1
      OnClick = VLboxTagClick
      OnDrawItem = VLBtagDrawItem
    end
  end
end
