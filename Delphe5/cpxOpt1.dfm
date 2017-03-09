object CpxOpt: TCpxOpt
  Left = 365
  Top = 186
  BorderStyle = bsDialog
  Caption = 'CpxOpt'
  ClientHeight = 152
  ClientWidth = 244
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
    Top = 13
    Width = 23
    Height = 13
    Caption = 'Cmin'
  end
  object Label12: TLabel
    Left = 8
    Top = 35
    Width = 26
    Height = 13
    Caption = 'Cmax'
  end
  object Label8: TLabel
    Left = 8
    Top = 63
    Width = 36
    Height = 13
    Caption = 'Gamma'
  end
  object Bok: TButton
    Left = 44
    Top = 105
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 123
    Top = 105
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object enCmin: TeditNum
    Left = 53
    Top = 11
    Width = 93
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enCmax: TeditNum
    Left = 53
    Top = 33
    Width = 93
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bautoscale: TButton
    Left = 156
    Top = 22
    Width = 77
    Height = 21
    Caption = 'AutoScale'
    TabOrder = 4
    OnClick = BautoscaleClick
  end
  object enGamma: TeditNum
    Left = 82
    Top = 61
    Width = 63
    Height = 21
    TabOrder = 5
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
