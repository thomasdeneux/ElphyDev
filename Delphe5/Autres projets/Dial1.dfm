object Dial: TDial
  Left = 337
  Top = 217
  BorderStyle = bsDialog
  Caption = 'Dialogue'
  ClientHeight = 179
  ClientWidth = 384
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 9
    Top = 8
    Width = 281
    Height = 161
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 301
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object CheckBoxV1: TCheckBoxV
    Left = 104
    Top = 31
    Width = 97
    Height = 17
    Caption = 'CheckBoxV1'
    TabOrder = 2
    UpdateVarOnToggle = False
  end
  object CheckBoxV2: TCheckBoxV
    Left = 105
    Top = 62
    Width = 97
    Height = 17
    Caption = 'CheckBoxV2'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
  object editNum1: TeditNum
    Left = 106
    Top = 92
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'editNum1'
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
