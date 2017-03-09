object Form1: TForm1
  Left = 676
  Top = 206
  Width = 402
  Height = 440
  Caption = 'Form1'
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
    Top = 0
    Width = 394
    Height = 335
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 335
    Width = 394
    Height = 71
    Align = alBottom
    TabOrder = 1
    object Bstart: TButton
      Left = 64
      Top = 27
      Width = 66
      Height = 20
      Caption = 'Start'
      TabOrder = 0
      OnClick = BstartClick
    end
    object Bstop: TButton
      Left = 160
      Top = 27
      Width = 66
      Height = 20
      Caption = 'Stop'
      TabOrder = 1
      OnClick = BstopClick
    end
    object Button1: TButton
      Left = 259
      Top = 27
      Width = 66
      Height = 20
      Caption = 'Clear'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 24
    Top = 256
  end
end
