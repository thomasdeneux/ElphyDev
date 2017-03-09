object Form1: TForm1
  Left = 465
  Top = 273
  Width = 458
  Height = 369
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 450
    Height = 301
    Align = alClient
    Lines.Strings = (
      '')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 301
    Width = 450
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 40
      Top = 8
      Width = 75
      Height = 25
      Caption = 'GO'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
