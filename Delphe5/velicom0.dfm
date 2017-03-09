object VlistOptions: TVlistOptions
  Left = 339
  Top = 220
  Width = 238
  Height = 176
  Caption = 'VlistOptions'
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
  object cbDisplayGraph: TCheckBoxV
    Left = 16
    Top = 8
    Width = 194
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Display graph'
    TabOrder = 0
    UpdateVarOnToggle = False
  end
  object BbkColor: TButton
    Left = 12
    Top = 34
    Width = 114
    Height = 25
    Caption = 'Background color'
    TabOrder = 1
    OnClick = BbkColorClick
  end
  object Pcolor: TPanel
    Left = 156
    Top = 34
    Width = 55
    Height = 25
    TabOrder = 2
  end
  object Bfont: TButton
    Left = 12
    Top = 64
    Width = 114
    Height = 25
    Caption = 'Font'
    TabOrder = 3
    OnClick = BfontClick
  end
  object BOK: TButton
    Left = 37
    Top = 106
    Width = 53
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Bcancel: TButton
    Left = 133
    Top = 106
    Width = 53
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object ColorDialog1: TColorDialog
    Left = 192
    Top = 136
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 144
    Top = 136
  end
end
