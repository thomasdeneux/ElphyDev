object Main: TMain
  Left = 192
  Top = 106
  Width = 544
  Height = 375
  Caption = 'Test Ncompil2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 536
    Height = 289
    Align = alTop
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 112
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 1
    OnClick = Button1Click
  end
end
