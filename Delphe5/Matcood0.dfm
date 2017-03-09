object MatCooD: TMatCooD
  Left = 612
  Top = 196
  Width = 587
  Height = 376
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
  object Label10: TLabel
    Left = 23
    Top = 243
    Width = 13
    Height = 13
    Caption = 'X :'
  end
  object Label11: TLabel
    Left = 106
    Top = 243
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
  object Label9: TLabel
    Left = 18
    Top = 221
    Width = 49
    Height = 13
    Caption = 'Couplings:'
  end
  object Label13: TLabel
    Left = 190
    Top = 243
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
    Left = 306
    Top = 140
    Width = 66
    Height = 13
    Caption = 'Display mode:'
  end
  object Label16: TLabel
    Left = 307
    Top = 164
    Width = 48
    Height = 13
    Caption = 'Cpx Mode'
  end
  object Label17: TLabel
    Left = 307
    Top = 188
    Width = 65
    Height = 13
    Caption = 'Angular mode'
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
    Left = 18
    Top = 181
    Width = 67
    Height = 21
    Caption = 'Colors'
    TabOrder = 8
    OnClick = C_colorClick
  end
  object Panel1: TPanel
    Left = 96
    Top = 182
    Width = 36
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 9
  end
  object C_ok: TButton
    Left = 196
    Top = 294
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 10
    OnClick = C_okClick
  end
  object C_cancel: TButton
    Left = 307
    Top = 294
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object C_Cpx: TeditNum
    Left = 44
    Top = 240
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
    Top = 240
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
  object Panel2: TPanel
    Left = 136
    Top = 182
    Width = 36
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 17
  end
  object C_cpZ: TeditNum
    Left = 211
    Top = 240
    Width = 46
    Height = 21
    TabOrder = 18
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_two: TCheckBoxV
    Left = 178
    Top = 184
    Width = 84
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use 2 colors'
    TabOrder = 19
    UpdateVarOnToggle = True
  end
  object editString1: TeditString
    Left = 60
    Top = 9
    Width = 354
    Height = 21
    TabOrder = 20
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object cbDisplayMode: TcomboBoxV
    Left = 380
    Top = 137
    Width = 102
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 21
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbCmode: TcomboBoxV
    Left = 380
    Top = 160
    Width = 102
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 22
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbAngleMode: TcomboBoxV
    Left = 380
    Top = 184
    Width = 102
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 23
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object BangleOptions: TButton
    Left = 486
    Top = 185
    Width = 77
    Height = 21
    Caption = 'Angle options'
    TabOrder = 24
    OnClick = BangleOptionsClick
  end
  object BcpxOptions: TButton
    Left = 486
    Top = 161
    Width = 77
    Height = 21
    Caption = 'Cpx options'
    TabOrder = 25
    OnClick = BcpxOptionsClick
  end
  object GroupBox1: TGroupBox
    Left = 307
    Top = 223
    Width = 257
    Height = 40
    Caption = 'Logarithmic modes'
    TabOrder = 26
    object cbLogX: TCheckBoxV
      Left = 8
      Top = 17
      Width = 65
      Height = 17
      Alignment = taLeftJustify
      Caption = 'X scale :'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbLogY: TCheckBoxV
      Left = 96
      Top = 17
      Width = 65
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Y scale :'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object cbLogZ: TCheckBoxV
      Left = 184
      Top = 17
      Width = 65
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Zscale :'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 304
    Top = 36
    Width = 257
    Height = 89
    Caption = 'Position'
    TabOrder = 27
    object Label6: TLabel
      Left = 8
      Top = 19
      Width = 5
      Height = 13
      Caption = 'x'
    end
    object Label7: TLabel
      Left = 8
      Top = 42
      Width = 5
      Height = 13
      Caption = 'y'
    end
    object Label8: TLabel
      Left = 140
      Top = 20
      Width = 11
      Height = 13
      Caption = 'dx'
    end
    object Label18: TLabel
      Left = 140
      Top = 42
      Width = 11
      Height = 13
      Caption = 'dy'
    end
    object Label19: TLabel
      Left = 9
      Top = 65
      Width = 28
      Height = 13
      Caption = 'Theta'
    end
    object C_x: TeditNum
      Left = 41
      Top = 17
      Width = 93
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object C_y: TeditNum
      Left = 41
      Top = 40
      Width = 93
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object C_dx: TeditNum
      Left = 155
      Top = 18
      Width = 93
      Height = 21
      TabOrder = 2
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object C_dy: TeditNum
      Left = 155
      Top = 40
      Width = 93
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object C_theta: TeditNum
      Left = 42
      Top = 63
      Width = 93
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbUsePosition: TCheckBoxV
      Left = 151
      Top = 65
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use Position'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object ColorDialog1: TColorDialog
    Left = 5
    Top = 291
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 35
    Top = 291
  end
end
