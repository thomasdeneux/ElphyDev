object MatValue: TMatValue
  Left = 317
  Top = 277
  BorderIcons = []
  BorderStyle = bsToolWindow
  ClientHeight = 43
  ClientWidth = 130
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 130
    Height = 43
    Align = alClient
    TabOrder = 3
  end
  object editNum1: TeditNum
    Left = 1
    Top = 1
    Width = 126
    Height = 21
    TabOrder = 0
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object BOK: TButton
    Left = 14
    Top = 24
    Width = 49
    Height = 17
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 67
    Top = 24
    Width = 49
    Height = 17
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
