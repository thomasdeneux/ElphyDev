object HexaCooD: THexaCooD
  Left = 694
  Top = 247
  Width = 293
  Height = 417
  Caption = 'Coordinates'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 15
    Top = 41
    Width = 26
    Height = 13
    Caption = 'Xmin:'
  end
  object Label3: TLabel
    Left = 15
    Top = 63
    Width = 26
    Height = 13
    Caption = 'Xmax'
  end
  object Label4: TLabel
    Left = 15
    Top = 86
    Width = 23
    Height = 13
    Caption = 'Ymin'
  end
  object Label5: TLabel
    Left = 15
    Top = 108
    Width = 26
    Height = 13
    Caption = 'Ymax'
  end
  object Label8: TLabel
    Left = 15
    Top = 188
    Width = 36
    Height = 13
    Caption = 'Gamma'
  end
  object Label10: TLabel
    Left = 23
    Top = 307
    Width = 13
    Height = 13
    Caption = 'X :'
  end
  object Label11: TLabel
    Left = 106
    Top = 307
    Width = 13
    Height = 13
    Caption = 'Y :'
  end
  object Label1: TLabel
    Left = 15
    Top = 130
    Width = 23
    Height = 13
    Caption = 'Zmin'
  end
  object Label12: TLabel
    Left = 15
    Top = 152
    Width = 26
    Height = 13
    Caption = 'Zmax'
  end
  object Label6: TLabel
    Left = 15
    Top = 210
    Width = 28
    Height = 13
    Caption = 'Theta'
  end
  object Label9: TLabel
    Left = 15
    Top = 287
    Width = 49
    Height = 13
    Caption = 'Couplings:'
  end
  object Label13: TLabel
    Left = 190
    Top = 307
    Width = 10
    Height = 13
    Caption = 'Z:'
  end
  object Label14: TLabel
    Left = 13
    Top = 12
    Width = 23
    Height = 13
    Caption = 'Title:'
  end
  object Label15: TLabel
    Left = 15
    Top = 261
    Width = 66
    Height = 13
    Caption = 'Display mode:'
  end
  object C_Xmin: TeditNum
    Left = 60
    Top = 39
    Width = 93
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Xmax: TeditNum
    Left = 60
    Top = 61
    Width = 93
    Height = 21
    TabOrder = 1
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Ymin: TeditNum
    Left = 60
    Top = 83
    Width = 93
    Height = 21
    TabOrder = 2
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Ymax: TeditNum
    Left = 60
    Top = 105
    Width = 93
    Height = 21
    TabOrder = 3
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_scaleX: TButton
    Left = 185
    Top = 39
    Width = 77
    Height = 21
    Caption = 'AutoScale X'
    TabOrder = 4
    OnClick = C_scaleXClick
  end
  object C_scaleY: TButton
    Left = 185
    Top = 67
    Width = 77
    Height = 21
    Caption = 'AutoScale Y'
    TabOrder = 5
    OnClick = C_scaleYClick
  end
  object C_grid: TCheckBoxV
    Left = 192
    Top = 150
    Width = 70
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Grid:'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
  object C_font: TButton
    Left = 185
    Top = 122
    Width = 77
    Height = 21
    Caption = 'Options'
    TabOrder = 7
    OnClick = C_OptionsClick
  end
  object C_color: TButton
    Left = 186
    Top = 185
    Width = 77
    Height = 21
    Caption = 'Colors'
    TabOrder = 8
    OnClick = C_colorClick
  end
  object Panel1: TPanel
    Left = 185
    Top = 207
    Width = 36
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 9
  end
  object C_ok: TButton
    Left = 76
    Top = 344
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 10
    OnClick = C_okClick
  end
  object C_cancel: TButton
    Left = 156
    Top = 344
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object C_Cpx: TeditNum
    Left = 44
    Top = 304
    Width = 46
    Height = 21
    TabOrder = 12
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_CpY: TeditNum
    Left = 127
    Top = 304
    Width = 46
    Height = 21
    TabOrder = 13
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Zmin: TeditNum
    Left = 60
    Top = 128
    Width = 93
    Height = 21
    TabOrder = 14
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Zmax: TeditNum
    Left = 60
    Top = 150
    Width = 93
    Height = 21
    TabOrder = 15
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_scaleZ: TButton
    Left = 185
    Top = 95
    Width = 77
    Height = 21
    Caption = 'AutoScale Z'
    TabOrder = 16
    OnClick = C_scaleZClick
  end
  object C_contrast: TeditNum
    Left = 89
    Top = 186
    Width = 63
    Height = 21
    TabOrder = 17
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_theta: TeditNum
    Left = 89
    Top = 208
    Width = 63
    Height = 21
    TabOrder = 18
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Panel2: TPanel
    Left = 225
    Top = 207
    Width = 36
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 19
  end
  object C_cpZ: TeditNum
    Left = 211
    Top = 304
    Width = 46
    Height = 21
    TabOrder = 20
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_two: TCheckBoxV
    Left = 176
    Top = 233
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use 2 colors'
    TabOrder = 21
    UpdateVarOnToggle = True
  end
  object editString1: TeditString
    Left = 47
    Top = 9
    Width = 215
    Height = 21
    TabOrder = 22
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object cbDisplayMode: TcomboBoxV
    Left = 89
    Top = 258
    Width = 102
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 23
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object ColorDialog1: TColorDialog
    Left = 5
    Top = 355
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 35
    Top = 355
  end
end
