object initTmultigraph: TinitTmultigraph
  Left = 402
  Top = 239
  BorderStyle = bsDialog
  Caption = 'New multigraph'
  ClientHeight = 135
  ClientWidth = 201
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
  object Lname: TLabel
    Left = 73
    Top = 7
    Width = 32
    Height = 13
    Alignment = taCenter
    Caption = 'Lname'
  end
  object Label2: TLabel
    Left = 3
    Top = 33
    Width = 94
    Height = 13
    Caption = 'Number of columns:'
  end
  object Label3: TLabel
    Left = 3
    Top = 56
    Width = 77
    Height = 13
    Caption = 'Number of rows:'
  end
  object Bok: TButton
    Left = 18
    Top = 86
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 107
    Top = 86
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editNum1: TeditNum
    Left = 119
    Top = 31
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
    Left = 119
    Top = 54
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
