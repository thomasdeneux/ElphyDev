object AngularOpt: TAngularOpt
  Left = 435
  Top = 241
  BorderStyle = bsDialog
  Caption = 'Angular mode options'
  ClientHeight = 115
  ClientWidth = 200
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
  object Label1: TLabel
    Left = 16
    Top = 23
    Width = 48
    Height = 13
    Caption = 'Line width'
  end
  object enLineWidth: TeditNum
    Left = 77
    Top = 20
    Width = 84
    Height = 21
    TabOrder = 0
    Text = 'enLineWidth'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_ok: TButton
    Left = 24
    Top = 73
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object C_cancel: TButton
    Left = 103
    Top = 73
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
