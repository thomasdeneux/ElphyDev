object ChooseEp: TChooseEp
  Left = 281
  Top = 225
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select episode'
  ClientHeight = 104
  ClientWidth = 205
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
  object Label1: TLabel
    Left = 22
    Top = 23
    Width = 51
    Height = 13
    Caption = 'Episode #:'
  end
  object Button1: TButton
    Left = 32
    Top = 60
    Width = 56
    Height = 21
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 117
    Top = 60
    Width = 56
    Height = 21
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editNum1: TeditNum
    Left = 103
    Top = 20
    Width = 75
    Height = 21
    TabOrder = 2
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
