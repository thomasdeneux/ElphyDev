object DivideWin: TDivideWin
  Left = 250
  Top = 186
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Divide a window'
  ClientHeight = 103
  ClientWidth = 202
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
  object label1: TLabel
    Left = 20
    Top = 9
    Width = 68
    Height = 13
    Caption = 'Column count:'
  end
  object Label2: TLabel
    Left = 20
    Top = 31
    Width = 55
    Height = 13
    Caption = 'Row count:'
  end
  object editNum1: TeditNum
    Left = 101
    Top = 5
    Width = 75
    Height = 21
    TabOrder = 0
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum2: TeditNum
    Left = 101
    Top = 27
    Width = 75
    Height = 21
    TabOrder = 1
    Text = 'editNum2'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object BOK: TButton
    Left = 19
    Top = 64
    Width = 65
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Bcancel: TButton
    Left = 108
    Top = 64
    Width = 65
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
