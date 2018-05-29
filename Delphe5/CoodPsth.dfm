object CooD: TCooD
  Left = 542
  Top = 159
  BorderStyle = bsDialog
  Caption = 'Coordinates'
  ClientHeight = 454
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 20
    Top = 16
    Width = 29
    Height = 16
    Caption = 'Title:'
  end
  object Label2: TLabel
    Left = 18
    Top = 50
    Width = 32
    Height = 16
    Caption = 'Xmin:'
  end
  object Label3: TLabel
    Left = 18
    Top = 80
    Width = 33
    Height = 16
    Caption = 'Xmax'
  end
  object Label4: TLabel
    Left = 18
    Top = 111
    Width = 30
    Height = 16
    Caption = 'Ymin'
  end
  object Label5: TLabel
    Left = 18
    Top = 140
    Width = 34
    Height = 16
    Caption = 'Ymax'
  end
  object Label6: TLabel
    Left = 18
    Top = 182
    Width = 33
    Height = 16
    Caption = 'Style:'
  end
  object Label7: TLabel
    Left = 18
    Top = 217
    Width = 76
    Height = 16
    Caption = 'Symbol size:'
  end
  object Label8: TLabel
    Left = 18
    Top = 247
    Width = 61
    Height = 16
    Caption = 'Line width:'
  end
  object Label10: TLabel
    Left = 18
    Top = 363
    Width = 65
    Height = 16
    Caption = 'X coupling:'
  end
  object Label11: TLabel
    Left = 210
    Top = 363
    Width = 69
    Height = 16
    Caption = 'Y coupling :'
  end
  object Label9: TLabel
    Left = 210
    Top = 335
    Width = 44
    Height = 16
    Caption = 'Cmode'
  end
  object Label12: TLabel
    Left = 18
    Top = 278
    Width = 58
    Height = 16
    Caption = 'Line Style'
  end
  object editNum1: TeditNum
    Left = 74
    Top = 48
    Width = 114
    Height = 21
    TabOrder = 0
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum2: TeditNum
    Left = 74
    Top = 78
    Width = 114
    Height = 21
    TabOrder = 1
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum3: TeditNum
    Left = 74
    Top = 107
    Width = 114
    Height = 21
    TabOrder = 2
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum4: TeditNum
    Left = 74
    Top = 137
    Width = 114
    Height = 21
    TabOrder = 3
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 256
    Top = 47
    Width = 95
    Height = 26
    Caption = 'AutoScale X'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 107
    Width = 95
    Height = 26
    Caption = 'AutoScale Y'
    TabOrder = 5
    OnClick = Button2Click
  end
  object comboBoxV2: TcomboBoxV
    Left = 162
    Top = 212
    Width = 76
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 6
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV3: TcomboBoxV
    Left = 162
    Top = 242
    Width = 76
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 7
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object CheckBoxV1: TCheckBoxV
    Left = 16
    Top = 306
    Width = 172
    Height = 21
    Alignment = taLeftJustify
    Caption = 'Logarithmic X scale :'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    UpdateVarOnToggle = False
  end
  object CheckBoxV2: TCheckBoxV
    Left = 16
    Top = 331
    Width = 172
    Height = 21
    Alignment = taLeftJustify
    Caption = 'Logarithmic Y scale:'
    TabOrder = 9
    UpdateVarOnToggle = False
  end
  object CheckBoxV3: TCheckBoxV
    Left = 266
    Top = 309
    Width = 87
    Height = 21
    Alignment = taLeftJustify
    Caption = 'Grid:'
    TabOrder = 10
    UpdateVarOnToggle = False
  end
  object Button4: TButton
    Left = 251
    Top = 177
    Width = 53
    Height = 26
    Caption = 'Color'
    TabOrder = 11
    OnClick = Button4Click
  end
  object Pcolor1: TPanel
    Left = 319
    Top = 177
    Width = 35
    Height = 26
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 12
  end
  object Button5: TButton
    Left = 94
    Top = 405
    Width = 84
    Height = 31
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 13
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 192
    Top = 405
    Width = 85
    Height = 31
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 14
  end
  object editString1: TeditString
    Left = 74
    Top = 14
    Width = 277
    Height = 21
    TabOrder = 15
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object enCpx: TeditNum
    Left = 133
    Top = 359
    Width = 57
    Height = 21
    TabOrder = 16
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enCpY: TeditNum
    Left = 299
    Top = 359
    Width = 57
    Height = 21
    TabOrder = 17
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Boptions: TButton
    Left = 251
    Top = 242
    Width = 103
    Height = 26
    Caption = 'Options'
    TabOrder = 18
    OnClick = BoptionsClick
  end
  object Button3: TButton
    Left = 251
    Top = 212
    Width = 53
    Height = 26
    Caption = ' color 2'
    TabOrder = 19
    OnClick = Button3Click
  end
  object Pcolor2: TPanel
    Left = 319
    Top = 212
    Width = 35
    Height = 26
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 20
  end
  object cbCmode: TcomboBoxV
    Left = 254
    Top = 330
    Width = 103
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 21
    OnChange = cbCmodeChange
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV1: TcomboBoxV
    Left = 74
    Top = 177
    Width = 162
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 22
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbLineStyle: TcomboBoxV
    Left = 108
    Top = 273
    Width = 130
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 23
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object ColorDialog1: TColorDialog
    Left = 16
    Top = 356
  end
end
