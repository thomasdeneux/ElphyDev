object Form1: TForm1
  Left = 339
  Top = 129
  Width = 431
  Height = 333
  Caption = 'FPS tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Width = 423
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 423
    Height = 137
    Align = alTop
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 0
    Top = 170
    Width = 423
    Height = 129
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 3
    Width = 423
    Height = 30
    Align = alTop
    TabOrder = 2
    object Button1: TButton
      Left = 88
      Top = 6
      Width = 75
      Height = 20
      Caption = 'Compile'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 20
      Caption = 'Paste'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
