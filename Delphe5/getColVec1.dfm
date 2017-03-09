object ColParam: TColParam
  Left = 296
  Top = 380
  Width = 215
  Height = 109
  Caption = 'ColParam'
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
  object Label2: TLabel
    Left = 8
    Top = 9
    Width = 75
    Height = 13
    Caption = 'Decimal places:'
  end
  object enDeci: TeditNum
    Left = 124
    Top = 7
    Width = 69
    Height = 21
    TabOrder = 0
    Text = 'enDeci'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bok: TButton
    Left = 30
    Top = 48
    Width = 65
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 104
    Top = 48
    Width = 65
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
