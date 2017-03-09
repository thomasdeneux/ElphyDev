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
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 208
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 10
      Width = 78
      Height = 16
      Caption = 'Main FPS file'
    end
    object Label2: TLabel
      Left = 20
      Top = 39
      Width = 81
      Height = 16
      Caption = 'EXE directory'
    end
    object Label3: TLabel
      Left = 20
      Top = 68
      Width = 82
      Height = 16
      Caption = 'PAS directory'
    end
    object Label4: TLabel
      Left = 20
      Top = 97
      Width = 92
      Height = 16
      Caption = 'HTML directory'
    end
    object Label5: TLabel
      Left = 20
      Top = 127
      Width = 48
      Height = 16
      Caption = 'PRC file'
    end
    object esFPS: TeditString
      Left = 148
      Top = 6
      Width = 513
      Height = 24
      TabOrder = 0
      len = 0
      UpdateVarOnExit = False
    end
    object esEXE: TeditString
      Left = 148
      Top = 36
      Width = 513
      Height = 24
      TabOrder = 1
      len = 0
      UpdateVarOnExit = False
    end
    object esPAS: TeditString
      Left = 148
      Top = 64
      Width = 513
      Height = 24
      TabOrder = 2
      len = 0
      UpdateVarOnExit = False
    end
    object esHTML: TeditString
      Left = 148
      Top = 94
      Width = 513
      Height = 24
      TabOrder = 3
      len = 0
      UpdateVarOnExit = False
    end
    object Bgo: TButton
      Left = 21
      Top = 170
      Width = 92
      Height = 24
      Caption = 'GO'
      TabOrder = 4
      OnClick = BgoClick
    end
    object Bfps: TButton
      Left = 670
      Top = 10
      Width = 19
      Height = 20
      TabOrder = 5
    end
    object Bexe: TButton
      Left = 670
      Top = 39
      Width = 19
      Height = 20
      TabOrder = 6
      OnClick = BexeClick
    end
    object Bpas: TButton
      Left = 670
      Top = 69
      Width = 19
      Height = 20
      TabOrder = 7
    end
    object Bhtml: TButton
      Left = 670
      Top = 98
      Width = 19
      Height = 20
      TabOrder = 8
    end
    object esPRC: TeditString
      Left = 148
      Top = 123
      Width = 513
      Height = 24
      TabOrder = 9
      len = 0
      UpdateVarOnExit = False
    end
    object Bchm: TButton
      Left = 138
      Top = 170
      Width = 92
      Height = 24
      Caption = 'Open CHM'
      TabOrder = 10
      OnClick = BchmClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 208
    Width = 567
    Height = 317
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
