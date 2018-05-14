object Form1: TForm1
  Left = 472
  Top = 242
  Width = 583
  Height = 563
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 169
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 62
      Height = 13
      Caption = 'Main FPS file'
    end
    object Label2: TLabel
      Left = 16
      Top = 32
      Width = 64
      Height = 13
      Caption = 'EXE directory'
    end
    object Label3: TLabel
      Left = 16
      Top = 55
      Width = 64
      Height = 13
      Caption = 'PAS directory'
    end
    object Label4: TLabel
      Left = 16
      Top = 79
      Width = 73
      Height = 13
      Caption = 'HTML directory'
    end
    object Label5: TLabel
      Left = 16
      Top = 103
      Width = 38
      Height = 13
      Caption = 'PRC file'
    end
    object esFPS: TeditString
      Left = 120
      Top = 5
      Width = 417
      Height = 24
      TabOrder = 0
      len = 0
      UpdateVarOnExit = False
    end
    object esEXE: TeditString
      Left = 120
      Top = 29
      Width = 417
      Height = 24
      TabOrder = 1
      len = 0
      UpdateVarOnExit = False
    end
    object esPAS: TeditString
      Left = 120
      Top = 52
      Width = 417
      Height = 24
      TabOrder = 2
      len = 0
      UpdateVarOnExit = False
    end
    object esHTML: TeditString
      Left = 120
      Top = 76
      Width = 417
      Height = 24
      TabOrder = 3
      len = 0
      UpdateVarOnExit = False
    end
    object Bgo: TButton
      Left = 17
      Top = 138
      Width = 75
      Height = 20
      Caption = 'GO'
      TabOrder = 4
      OnClick = BgoClick
    end
    object Bfps: TButton
      Left = 544
      Top = 8
      Width = 16
      Height = 16
      TabOrder = 5
    end
    object Bexe: TButton
      Left = 544
      Top = 32
      Width = 16
      Height = 16
      TabOrder = 6
      OnClick = BexeClick
    end
    object Bpas: TButton
      Left = 544
      Top = 56
      Width = 16
      Height = 16
      TabOrder = 7
    end
    object Bhtml: TButton
      Left = 544
      Top = 80
      Width = 16
      Height = 16
      TabOrder = 8
    end
    object esPRC: TeditString
      Left = 120
      Top = 100
      Width = 417
      Height = 24
      TabOrder = 9
      len = 0
      UpdateVarOnExit = False
    end
    object Bchm: TButton
      Left = 112
      Top = 138
      Width = 75
      Height = 20
      Caption = 'Open CHM'
      TabOrder = 10
      OnClick = BchmClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 169
    Width = 567
    Height = 355
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
