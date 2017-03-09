object stmMemoForm: TstmMemoForm
  Left = 591
  Top = 184
  Width = 312
  Height = 294
  Caption = 'stmMemoForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 304
    Height = 174
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 174
    Width = 304
    Height = 72
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 46
      Height = 13
      Caption = 'X position'
    end
    object Label2: TLabel
      Left = 8
      Top = 34
      Width = 46
      Height = 13
      Caption = 'Y position'
    end
    object enX: TeditNum
      Left = 61
      Top = 10
      Width = 67
      Height = 21
      TabOrder = 0
      Text = '0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enY: TeditNum
      Left = 61
      Top = 31
      Width = 67
      Height = 21
      TabOrder = 1
      Text = '0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object Bvalidate: TButton
      Left = 171
      Top = 32
      Width = 75
      Height = 20
      Caption = 'Validate'
      TabOrder = 2
    end
    object UpDownX: TUpDown
      Left = 128
      Top = 10
      Width = 13
      Height = 21
      Min = -32000
      Max = 32000
      Increment = 5
      TabOrder = 3
    end
    object UpDownY: TUpDown
      Left = 128
      Top = 31
      Width = 13
      Height = 21
      Min = -32000
      Max = 32000
      Increment = 5
      TabOrder = 4
    end
  end
  object MainMenu1: TMainMenu
    Left = 202
    Top = 14
    object FOnt1: TMenuItem
      Caption = 'Font'
      OnClick = FOnt1Click
    end
    object Options1: TMenuItem
      Caption = 'Options'
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 240
    Top = 14
  end
end
