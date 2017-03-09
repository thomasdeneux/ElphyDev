object NeuroShareTest: TNeuroShareTest
  Left = 451
  Top = 347
  Width = 572
  Height = 570
  Caption = 'NeuroShareTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 392
    Width = 564
    Height = 144
    Align = alBottom
    TabOrder = 0
    object BloadDLL: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Load DLL'
      TabOrder = 0
      OnClick = BloadDLLClick
    end
    object Bload: TButton
      Left = 98
      Top = 16
      Width = 79
      Height = 25
      Caption = 'Load Data File'
      TabOrder = 1
      OnClick = BloadClick
    end
    object BClose: TButton
      Left = 185
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Close File'
      TabOrder = 2
      OnClick = BCloseClick
    end
    object Bedit: TButton
      Left = 267
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 3
      OnClick = BeditClick
    end
    object BnexFile: TButton
      Left = 16
      Top = 53
      Width = 75
      Height = 25
      Caption = 'Test NEX file'
      TabOrder = 4
      OnClick = BnexFileClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 564
    Height = 392
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
