object ReplayFile: TReplayFile
  Left = 324
  Top = 188
  BorderStyle = bsDialog
  Caption = 'Replay a file'
  ClientHeight = 150
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 59
    Height = 13
    Caption = 'First episode'
  end
  object Label2: TLabel
    Left = 8
    Top = 70
    Width = 60
    Height = 13
    Caption = 'Last episode'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 313
    Height = 34
    Align = alTop
    Caption = 'File name'
    TabOrder = 0
    object Lfile: TLabel
      Left = 15
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Nom de fichier'
    end
    object Bchoose: TButton
      Left = 258
      Top = 9
      Width = 46
      Height = 20
      Caption = 'Choose'
      TabOrder = 0
      OnClick = BchooseClick
    end
  end
  object enFirst: TeditNum
    Left = 88
    Top = 45
    Width = 89
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enLast: TeditNum
    Left = 88
    Top = 67
    Width = 89
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 90
    Top = 105
    Width = 46
    Height = 20
    Caption = 'Replay'
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 173
    Top = 105
    Width = 46
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object Bauto: TButton
    Left = 183
    Top = 55
    Width = 64
    Height = 20
    Caption = 'Autoscale'
    TabOrder = 5
    OnClick = BautoClick
  end
end
