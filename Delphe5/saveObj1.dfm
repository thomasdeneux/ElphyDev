object SaveObjectDialog: TSaveObjectDialog
  Left = 269
  Top = 196
  BorderStyle = bsDialog
  Caption = 'SaveObjectDialog'
  ClientHeight = 149
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 6
    Width = 321
    Height = 69
    Caption = 'Comment'
    TabOrder = 0
    object Memo1: TMemo
      Left = 6
      Top = 15
      Width = 311
      Height = 48
      Lines.Strings = (
        'un'
        'deux'
        'trois'
        '')
      TabOrder = 0
    end
  end
  object cbAppend: TCheckBoxV
    Left = 5
    Top = 81
    Width = 96
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Append'
    TabOrder = 1
    UpdateVarOnToggle = False
  end
  object Bok: TButton
    Left = 89
    Top = 110
    Width = 56
    Height = 25
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 2
  end
  object Bcancel: TButton
    Left = 168
    Top = 110
    Width = 56
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
