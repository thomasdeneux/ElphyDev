object FormSelectRF: TFormSelectRF
  Left = 412
  Top = 175
  BorderStyle = bsDialog
  Caption = 'Select receptive field'
  ClientHeight = 74
  ClientWidth = 253
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
  object rf1: TButton
    Left = 11
    Top = 10
    Width = 43
    Height = 21
    Caption = 'RF1'
    Default = True
    ModalResult = 101
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 91
    Top = 40
    Width = 66
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object rf2: TButton
    Left = 57
    Top = 10
    Width = 43
    Height = 21
    Caption = 'RF2'
    Default = True
    ModalResult = 102
    TabOrder = 2
  end
  object rf3: TButton
    Left = 102
    Top = 10
    Width = 48
    Height = 21
    Caption = 'RF3'
    Default = True
    ModalResult = 103
    TabOrder = 3
  end
  object rf4: TButton
    Left = 152
    Top = 10
    Width = 43
    Height = 21
    Caption = 'RF4'
    Default = True
    ModalResult = 104
    TabOrder = 4
  end
  object rf5: TButton
    Left = 197
    Top = 10
    Width = 43
    Height = 21
    Caption = 'RF5'
    Default = True
    ModalResult = 105
    TabOrder = 5
  end
end
