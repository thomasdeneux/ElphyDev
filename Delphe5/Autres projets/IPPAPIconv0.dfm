object Form1: TForm1
  Left = 362
  Top = 212
  Width = 457
  Height = 338
  Caption = 'IPPAPI conversion'
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
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 449
    Height = 270
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 449
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 40
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cr'#233'er ipp'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 154
      Top = 8
      Width = 111
      Height = 25
      Caption = 'Cr'#233'er ipp overload'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
