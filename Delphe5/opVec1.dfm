object OptionsVec1: TOptionsVec1
  Left = 262
  Top = 181
  Width = 175
  Height = 120
  Caption = 'Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object BOK: TButton
    Left = 20
    Top = 57
    Width = 58
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 91
    Top = 57
    Width = 58
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object BBKcol: TButton
    Left = 11
    Top = 6
    Width = 97
    Height = 20
    Caption = 'Background color'
    TabOrder = 2
    OnClick = BBKcolClick
  end
  object PanelBKcol: TPanel
    Left = 115
    Top = 6
    Width = 42
    Height = 22
    TabOrder = 3
  end
  object ColorDialog1: TColorDialog
    Left = 65535
    Top = 79
  end
end
