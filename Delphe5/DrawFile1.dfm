object RedrawFile: TRedrawFile
  Left = 324
  Top = 188
  BorderStyle = bsDialog
  Caption = 'Redraw current file'
  ClientHeight = 151
  ClientWidth = 269
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
    Left = 8
    Top = 12
    Width = 59
    Height = 13
    Caption = 'First episode'
  end
  object Label2: TLabel
    Left = 8
    Top = 34
    Width = 60
    Height = 13
    Caption = 'Last episode'
  end
  object enFirst: TeditNum
    Left = 88
    Top = 9
    Width = 89
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enLast: TeditNum
    Left = 88
    Top = 31
    Width = 89
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 68
    Top = 108
    Width = 46
    Height = 20
    Caption = 'Redraw'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 151
    Top = 108
    Width = 46
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Bauto: TButton
    Left = 183
    Top = 19
    Width = 64
    Height = 20
    Caption = 'Autoscale'
    TabOrder = 4
    OnClick = BautoClick
  end
  object cbClearCtrl: TCheckBoxV
    Left = 6
    Top = 60
    Width = 172
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Clear control screen'
    TabOrder = 5
    UpdateVarOnToggle = False
  end
  object cbFastMode: TCheckBoxV
    Left = 6
    Top = 80
    Width = 172
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Fast display'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
end
