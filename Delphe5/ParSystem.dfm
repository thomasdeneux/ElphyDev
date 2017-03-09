object ParamSystem: TParamSystem
  Left = 335
  Top = 243
  BorderStyle = bsDialog
  Caption = 'System parameters'
  ClientHeight = 106
  ClientWidth = 291
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
    Left = 20
    Top = 20
    Width = 45
    Height = 13
    Caption = 'Interface:'
  end
  object BOK: TButton
    Left = 56
    Top = 61
    Width = 64
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 160
    Top = 61
    Width = 64
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cbDriver: TComboBox
    Left = 97
    Top = 17
    Width = 176
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'cbDriver'
  end
end
