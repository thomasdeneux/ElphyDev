object Form1: TForm1
  Left = 801
  Top = 189
  Width = 443
  Height = 602
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 81
    Align = alTop
    TabOrder = 0
    object Lstat: TLabel
      Left = 24
      Top = 56
      Width = 37
      Height = 13
      Caption = 'Nstat=0'
    end
    object Lstatus: TLabel
      Left = 270
      Top = 55
      Width = 3
      Height = 13
    end
    object Bstart: TButton
      Left = 16
      Top = 16
      Width = 47
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = BstartClick
    end
    object Bstop: TButton
      Left = 68
      Top = 16
      Width = 47
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = BstopClick
    end
    object Bcoo: TButton
      Left = 121
      Top = 16
      Width = 47
      Height = 25
      Caption = 'Coo'
      TabOrder = 2
      OnClick = BcooClick
    end
    object Bclear: TButton
      Left = 174
      Top = 16
      Width = 47
      Height = 25
      Caption = 'Clear'
      TabOrder = 3
      OnClick = BclearClick
    end
    object Brefresh: TButton
      Left = 225
      Top = 16
      Width = 47
      Height = 25
      Caption = 'Refresh'
      TabOrder = 4
      OnClick = BrefreshClick
    end
    object Bflag: TButton
      Left = 288
      Top = 16
      Width = 49
      Height = 25
      Caption = 'Flag'
      TabOrder = 5
      OnClick = BflagClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 305
    Width = 435
    Height = 263
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  inline DispFrame1: TDispFrame
    Left = 0
    Top = 81
    Width = 435
    Height = 224
    Align = alTop
    TabOrder = 2
    inherited PaintBox1: TPaintBox
      Width = 435
      Height = 224
    end
  end
end
