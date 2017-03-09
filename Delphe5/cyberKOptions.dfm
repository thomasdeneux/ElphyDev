object CyberKOpt: TCyberKOpt
  Left = 654
  Top = 301
  Width = 468
  Height = 176
  Caption = 'CyberK Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bcancel: TButton
    Left = 241
    Top = 98
    Width = 53
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object BOK: TButton
    Left = 165
    Top = 98
    Width = 53
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 16
    Width = 425
    Height = 65
    Caption = 'Central Software Directory'
    TabOrder = 2
    object Bbrowse: TButton
      Left = 367
      Top = 25
      Width = 52
      Height = 20
      Caption = 'Browse'
      TabOrder = 0
      OnClick = BbrowseClick
    end
    object esCentralDir: TEdit
      Left = 8
      Top = 24
      Width = 353
      Height = 21
      TabOrder = 1
      Text = 'esCentralDir'
    end
  end
end
