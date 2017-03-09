object ObjectFileOptions: TObjectFileOptions
  Left = 565
  Top = 243
  BorderStyle = bsDialog
  Caption = 'ObjectFileOptions'
  ClientHeight = 186
  ClientWidth = 224
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
  object cbDisplayInfo: TCheckBoxV
    Left = 16
    Top = 24
    Width = 194
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Display info'
    TabOrder = 0
    UpdateVarOnToggle = False
  end
  object cbDisplayGraph: TCheckBoxV
    Left = 16
    Top = 43
    Width = 194
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Display graph'
    TabOrder = 1
    UpdateVarOnToggle = False
  end
  object BbkColor: TButton
    Left = 12
    Top = 69
    Width = 114
    Height = 25
    Caption = 'Background color'
    TabOrder = 2
    OnClick = BbkColorClick
  end
  object Pcolor: TPanel
    Left = 156
    Top = 69
    Width = 55
    Height = 25
    TabOrder = 3
  end
  object Bfont: TButton
    Left = 12
    Top = 99
    Width = 114
    Height = 25
    Caption = 'Font'
    TabOrder = 4
    OnClick = BfontClick
  end
  object BOK: TButton
    Left = 37
    Top = 141
    Width = 53
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 5
  end
  object Bcancel: TButton
    Left = 133
    Top = 140
    Width = 53
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object ColorDialog1: TColorDialog
    Left = 128
    Top = 176
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 192
    Top = 176
  end
end
