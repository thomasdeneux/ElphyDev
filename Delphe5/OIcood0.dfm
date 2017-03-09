object OICooD: TOICooD
  Left = 576
  Top = 257
  BorderStyle = bsDialog
  Caption = 'Coordinates'
  ClientHeight = 399
  ClientWidth = 324
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
    Width = 14
    Height = 13
    Caption = 'G0'
  end
  object Label3: TLabel
    Left = 15
    Top = 63
    Width = 11
    Height = 13
    Caption = 'x0'
  end
  object Label4: TLabel
    Left = 15
    Top = 86
    Width = 11
    Height = 13
    Caption = 'y0'
  end
  object Label10: TLabel
    Left = 23
    Top = 307
    Width = 20
    Height = 13
    Caption = 'XY :'
  end
  object Label1: TLabel
    Left = 15
    Top = 107
    Width = 23
    Height = 13
    Caption = 'Zmin'
  end
  object Label12: TLabel
    Left = 15
    Top = 129
    Width = 26
    Height = 13
    Caption = 'Zmax'
  end
  object Label9: TLabel
    Left = 15
    Top = 287
    Width = 49
    Height = 13
    Caption = 'Couplings:'
  end
  object Label13: TLabel
    Left = 176
    Top = 307
    Width = 29
    Height = 13
    Caption = 'Index:'
  end
  object Label14: TLabel
    Left = 13
    Top = 12
    Width = 23
    Height = 13
    Caption = 'Title:'
  end
  object Label11: TLabel
    Left = 106
    Top = 307
    Width = 13
    Height = 13
    Caption = 'Z :'
  end
  object Label5: TLabel
    Left = 127
    Top = 225
    Width = 87
    Height = 13
    Caption = 'Transparent Value'
  end
  object C_G0: TeditNum
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
  object C_X0: TeditNum
    Left = 60
    Top = 61
    Width = 93
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Y0: TeditNum
    Left = 60
    Top = 83
    Width = 93
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_scale: TButton
    Left = 163
    Top = 39
    Width = 150
    Height = 21
    Caption = 'AutoScale'
    TabOrder = 3
    OnClick = C_scaleClick
  end
  object C_options: TButton
    Left = 15
    Top = 258
    Width = 77
    Height = 21
    Caption = 'Options'
    TabOrder = 4
    OnClick = C_optionsClick
  end
  object C_color: TButton
    Left = 15
    Top = 169
    Width = 77
    Height = 21
    Caption = 'Colors'
    TabOrder = 5
    OnClick = C_colorClick
  end
  object Panel1: TPanel
    Left = 99
    Top = 170
    Width = 36
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 6
  end
  object C_ok: TButton
    Left = 88
    Top = 349
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = C_okClick
  end
  object C_cancel: TButton
    Left = 168
    Top = 349
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object C_Cpxy: TeditNum
    Left = 44
    Top = 304
    Width = 46
    Height = 21
    TabOrder = 9
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Zmin: TeditNum
    Left = 60
    Top = 105
    Width = 93
    Height = 21
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_Zmax: TeditNum
    Left = 60
    Top = 127
    Width = 93
    Height = 21
    TabOrder = 11
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_scaleZ: TButton
    Left = 163
    Top = 105
    Width = 150
    Height = 21
    Caption = 'AutoScale Z current frame'
    TabOrder = 12
    OnClick = C_scaleZClick
  end
  object Panel2: TPanel
    Left = 139
    Top = 170
    Width = 36
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 13
  end
  object C_cpIndex: TeditNum
    Left = 209
    Top = 304
    Width = 46
    Height = 21
    TabOrder = 14
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object C_two: TCheckBoxV
    Left = 94
    Top = 196
    Width = 81
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use 2 colors'
    TabOrder = 15
    UpdateVarOnToggle = True
  end
  object editString1: TeditString
    Left = 47
    Top = 9
    Width = 215
    Height = 21
    TabOrder = 16
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object C_cpZ: TeditNum
    Left = 120
    Top = 304
    Width = 46
    Height = 21
    TabOrder = 17
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Tag = 1
    Left = 163
    Top = 128
    Width = 150
    Height = 21
    Caption = 'AutoScale Z all frames'
    TabOrder = 18
    OnClick = C_scaleZClick
  end
  object cbTransparent: TCheckBoxV
    Left = 14
    Top = 224
    Width = 87
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Transparent'
    TabOrder = 19
    UpdateVarOnToggle = False
  end
  object enTransparent: TeditNum
    Left = 217
    Top = 223
    Width = 93
    Height = 21
    TabOrder = 20
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object ColorDialog1: TColorDialog
    Left = 4
    Top = 350
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 34
    Top = 350
  end
end
