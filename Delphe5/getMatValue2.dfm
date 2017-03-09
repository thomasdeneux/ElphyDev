object MatCpxValue: TMatCpxValue
  Left = 317
  Top = 277
  BorderIcons = []
  BorderStyle = bsToolWindow
  ClientHeight = 72
  ClientWidth = 148
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
    Width = 148
    Height = 72
    Align = alClient
    TabOrder = 4
    object Panel2: TPanel
      Left = 1
      Top = 24
      Width = 31
      Height = 22
      BevelOuter = bvLowered
      Caption = 'Im'
      TabOrder = 0
    end
    object enIm: TeditNum
      Left = 34
      Top = 25
      Width = 109
      Height = 21
      TabOrder = 1
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object enRe: TeditNum
    Left = 34
    Top = 2
    Width = 109
    Height = 21
    TabOrder = 0
    Text = 'enRe'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object BOK: TButton
    Left = 24
    Top = 50
    Width = 49
    Height = 17
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 77
    Top = 50
    Width = 49
    Height = 17
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Pre: TPanel
    Left = 1
    Top = 1
    Width = 31
    Height = 22
    BevelOuter = bvLowered
    Caption = 'Re'
    TabOrder = 3
  end
end
