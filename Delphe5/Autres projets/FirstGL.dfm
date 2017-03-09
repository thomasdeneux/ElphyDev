object Form1: TForm1
  Left = 285
  Top = 311
  Width = 575
  Height = 288
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 28
    Width = 567
    Height = 233
    Align = alClient
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 28
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object scrollbarV1: TscrollbarV
      Left = 32
      Top = 3
      Width = 121
      Height = 18
      Max = 30000
      PageSize = 0
      TabOrder = 0
      Xmax = 1000
      dxSmall = 1
      dxLarge = 10
      OnScrollV = scrollbarV1ScrollV
    end
    object Button1: TButton
      Left = 178
      Top = 2
      Width = 75
      Height = 22
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
