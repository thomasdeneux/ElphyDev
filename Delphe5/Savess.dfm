object SaveArray: TSaveArray
  Left = 296
  Top = 205
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  Caption = 'Save spreadsheet'
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
    Height = 129
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
    Top = 53
    Width = 57
    Height = 13
    Caption = 'Last column'
  end
  object Label3: TLabel
    Left = 197
    Top = 28
    Width = 39
    Height = 13
    Caption = 'First row'
  end
  object Label4: TLabel
    Left = 197
    Top = 53
    Width = 40
    Height = 13
    Caption = 'Last row'
  end
  object Label5: TLabel
    Left = 197
    Top = 81
    Width = 49
    Height = 13
    Caption = 'Separator:'
  end
  object OKBtn: TBitBtn
    Left = 107
    Top = 152
    Width = 77
    Height = 25
    TabOrder = 0
    OnClick = OKBtnClick
    Kind = bkOK
    Margin = 2
    Spacing = -1
    IsControl = True
  end
  object CancelBtn: TBitBtn
    Left = 191
    Top = 152
    Width = 77
    Height = 25
    TabOrder = 1
    Kind = bkCancel
    Margin = 2
    Spacing = -1
    IsControl = True
  end
  object FirstCol: TeditNum
    Left = 100
    Top = 26
    Width = 81
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object LastCol: TeditNum
    Left = 100
    Top = 51
    Width = 81
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object FirstRow: TeditNum
    Left = 273
    Top = 26
    Width = 81
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object LastRow: TeditNum
    Left = 273
    Top = 51
    Width = 81
    Height = 21
    TabOrder = 5
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Search: TButton
    Left = 24
    Top = 92
    Width = 89
    Height = 25
    Caption = 'Search limits'
    TabOrder = 6
    OnClick = SearchClick
  end
  object comboSep: TcomboBoxV
    Left = 274
    Top = 77
    Width = 80
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'comboSep'
    Items.Strings = (
      'space'
      'tab'
      ';'
      ',')
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object CheckBoxV1: TCheckBoxV
    Left = 195
    Top = 104
    Width = 159
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Save column names'
    TabOrder = 8
    UpdateVarOnToggle = False
  end
end
