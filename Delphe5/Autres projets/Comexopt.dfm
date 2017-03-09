object CommandBoxOption: TCommandBoxOption
  Left = 198
  Top = 168
  Width = 239
  Height = 113
  Caption = 'Execute options'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object CBmask: TCheckBox
    Left = 15
    Top = 11
    Width = 200
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Hide command box while executing'
    TabOrder = 0
  end
  object BOK: TButton
    Left = 39
    Top = 44
    Width = 67
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 128
    Top = 44
    Width = 67
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
