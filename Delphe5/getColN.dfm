object GetColParams: TGetColParams
  Left = 507
  Top = 233
  BorderStyle = bsDialog
  Caption = 'Column parameters'
  ClientHeight = 126
  ClientWidth = 206
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label2: TLabel
    Left = 8
    Top = 34
    Width = 75
    Height = 13
    Caption = 'Decimal places:'
  end
  object editString1: TeditString
    Left = 52
    Top = 8
    Width = 141
    Height = 21
    TabOrder = 0
    len = 0
    UpdateVarOnExit = False
  end
  object Bok: TButton
    Left = 30
    Top = 96
    Width = 65
    Height = 20
    Caption = 'OK'
    ModalResult = 101
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 104
    Top = 96
    Width = 65
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object editNum1: TeditNum
    Left = 124
    Top = 32
    Width = 69
    Height = 21
    TabOrder = 3
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 11
    Top = 66
    Width = 183
    Height = 20
    Caption = 'Show vector'
    ModalResult = 102
    TabOrder = 4
  end
end
