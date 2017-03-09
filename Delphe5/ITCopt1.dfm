object ITCoptions: TITCoptions
  Left = 387
  Top = 244
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'ITC options'
  ClientHeight = 114
  ClientWidth = 262
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
    Top = 16
    Width = 144
    Height = 13
    Caption = 'Delay for second interface ('#181's)'
  end
  object BOK: TButton
    Left = 53
    Top = 76
    Width = 53
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 129
    Top = 76
    Width = 53
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object enDelay: TeditNum
    Left = 167
    Top = 12
    Width = 83
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbTags: TCheckBoxV
    Left = 7
    Top = 40
    Width = 173
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use Tags'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
end
