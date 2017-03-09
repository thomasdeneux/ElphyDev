object initRealArray: TinitRealArray
  Left = 286
  Top = 127
  BorderStyle = bsDialog
  Caption = 'New array'
  ClientHeight = 110
  ClientWidth = 190
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
  object Label2: TLabel
    Left = 12
    Top = 12
    Width = 68
    Height = 13
    Caption = 'Column count:'
  end
  object Label3: TLabel
    Left = 12
    Top = 33
    Width = 53
    Height = 13
    Caption = 'Line count:'
  end
  object Bok: TButton
    Left = 19
    Top = 65
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 98
    Top = 65
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editNum1: TeditNum
    Left = 103
    Top = 9
    Width = 73
    Height = 21
    TabOrder = 2
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum2: TeditNum
    Left = 103
    Top = 31
    Width = 73
    Height = 21
    TabOrder = 3
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
