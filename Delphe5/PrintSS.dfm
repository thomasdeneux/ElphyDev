object PrintArray: TPrintArray
  Left = 296
  Top = 205
  BorderStyle = bsDialog
  Caption = 'Print spreadSheet'
  ClientHeight = 195
  ClientWidth = 375
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
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 357
    Height = 135
    Shape = bsFrame
    IsControl = True
  end
  object Label1: TLabel
    Left = 24
    Top = 28
    Width = 56
    Height = 13
    Caption = 'First column'
  end
  object Label2: TLabel
    Left = 24
    Top = 49
    Width = 57
    Height = 13
    Caption = 'Last column'
  end
  object Label3: TLabel
    Left = 24
    Top = 70
    Width = 39
    Height = 13
    Caption = 'First row'
  end
  object Label4: TLabel
    Left = 24
    Top = 91
    Width = 40
    Height = 13
    Caption = 'Last row'
  end
  object Label5: TLabel
    Left = 196
    Top = 30
    Width = 72
    Height = 13
    Caption = 'Column interval'
  end
  object Label6: TLabel
    Left = 196
    Top = 51
    Width = 50
    Height = 13
    Caption = 'Field width'
  end
  object Label7: TLabel
    Left = 196
    Top = 72
    Width = 72
    Height = 13
    Caption = 'Decimal places'
  end
  object FirstCol: TeditNum
    Left = 100
    Top = 26
    Width = 81
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object LastCol: TeditNum
    Left = 100
    Top = 47
    Width = 81
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object FirstRow: TeditNum
    Left = 100
    Top = 68
    Width = 81
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object LastRow: TeditNum
    Left = 100
    Top = 89
    Width = 81
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Search: TButton
    Left = 23
    Top = 113
    Width = 87
    Height = 20
    Caption = 'Search limits'
    TabOrder = 4
    OnClick = SearchClick
  end
  object cbNames: TCheckBoxV
    Left = 194
    Top = 94
    Width = 159
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Print column names'
    TabOrder = 5
    UpdateVarOnToggle = False
  end
  object enInterval: TeditNum
    Left = 272
    Top = 28
    Width = 81
    Height = 21
    TabOrder = 6
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object BOK: TButton
    Left = 109
    Top = 157
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = OKBtnClick
  end
  object Bcancel: TButton
    Left = 189
    Top = 157
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object enField: TeditNum
    Left = 272
    Top = 49
    Width = 81
    Height = 21
    TabOrder = 9
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDeci: TeditNum
    Left = 272
    Top = 70
    Width = 81
    Height = 21
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bfont: TButton
    Left = 196
    Top = 113
    Width = 87
    Height = 20
    Caption = 'Font'
    TabOrder = 11
    OnClick = BfontClick
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdEffects, fdFixedPitchOnly]
    Left = 332
    Top = 160
  end
end
