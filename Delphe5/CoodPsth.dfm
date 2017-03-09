object CooD: TCooD
  Left = 542
  Top = 159
  BorderStyle = bsDialog
  Caption = 'Coordinates'
  ClientHeight = 369
  ClientWidth = 304
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
  object Label1: TLabel
    Left = 16
    Top = 13
    Width = 23
    Height = 13
    Caption = 'Title:'
  end
  object Label2: TLabel
    Left = 15
    Top = 41
    Width = 26
    Height = 13
    Caption = 'Xmin:'
  end
  object Label3: TLabel
    Left = 15
    Top = 65
    Width = 26
    Height = 13
    Caption = 'Xmax'
  end
  object Label4: TLabel
    Left = 15
    Top = 90
    Width = 23
    Height = 13
    Caption = 'Ymin'
  end
  object Label5: TLabel
    Left = 15
    Top = 114
    Width = 26
    Height = 13
    Caption = 'Ymax'
  end
  object Label6: TLabel
    Left = 15
    Top = 148
    Width = 26
    Height = 13
    Caption = 'Style:'
  end
  object Label7: TLabel
    Left = 15
    Top = 176
    Width = 58
    Height = 13
    Caption = 'Symbol size:'
  end
  object Label8: TLabel
    Left = 15
    Top = 201
    Width = 51
    Height = 13
    Caption = 'Line width:'
  end
  object Label10: TLabel
    Left = 15
    Top = 295
    Width = 53
    Height = 13
    Caption = 'X coupling:'
  end
  object Label11: TLabel
    Left = 171
    Top = 295
    Width = 56
    Height = 13
    Caption = 'Y coupling :'
  end
  object Label9: TLabel
    Left = 171
    Top = 272
    Width = 33
    Height = 13
    Caption = 'Cmode'
  end
  object Label12: TLabel
    Left = 15
    Top = 226
    Width = 46
    Height = 13
    Caption = 'Line Style'
  end
  object editNum1: TeditNum
    Left = 60
    Top = 39
    Width = 93
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
    Left = 60
    Top = 63
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
  object editNum3: TeditNum
    Left = 60
    Top = 87
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
  object editNum4: TeditNum
    Left = 60
    Top = 111
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
  object Button1: TButton
    Left = 208
    Top = 38
    Width = 77
    Height = 21
    Caption = 'AutoScale X'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 208
    Top = 87
    Width = 77
    Height = 21
    Caption = 'AutoScale Y'
    TabOrder = 5
    OnClick = Button2Click
  end
  object comboBoxV2: TcomboBoxV
    Left = 132
    Top = 172
    Width = 61
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV3: TcomboBoxV
    Left = 132
    Top = 197
    Width = 61
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object CheckBoxV1: TCheckBoxV
    Left = 13
    Top = 249
    Width = 140
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Logarithmic X scale :'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 8
    UpdateVarOnToggle = False
  end
  object CheckBoxV2: TCheckBoxV
    Left = 13
    Top = 269
    Width = 140
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Logarithmic Y scale:'
    TabOrder = 9
    UpdateVarOnToggle = False
  end
  object CheckBoxV3: TCheckBoxV
    Left = 216
    Top = 251
    Width = 71
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Grid:'
    TabOrder = 10
    UpdateVarOnToggle = False
  end
  object Button4: TButton
    Left = 204
    Top = 144
    Width = 43
    Height = 21
    Caption = 'Color'
    TabOrder = 11
    OnClick = Button4Click
  end
  object Pcolor1: TPanel
    Left = 259
    Top = 144
    Width = 29
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 12
  end
  object Button5: TButton
    Left = 76
    Top = 329
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 13
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 156
    Top = 329
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 14
  end
  object editString1: TeditString
    Left = 60
    Top = 11
    Width = 225
    Height = 21
    TabOrder = 15
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object enCpx: TeditNum
    Left = 108
    Top = 292
    Width = 46
    Height = 21
    TabOrder = 16
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enCpY: TeditNum
    Left = 243
    Top = 292
    Width = 46
    Height = 21
    TabOrder = 17
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Boptions: TButton
    Left = 204
    Top = 197
    Width = 84
    Height = 21
    Caption = 'Options'
    TabOrder = 18
    OnClick = BoptionsClick
  end
  object Button3: TButton
    Left = 204
    Top = 172
    Width = 43
    Height = 21
    Caption = ' color 2'
    TabOrder = 19
    OnClick = Button3Click
  end
  object Pcolor2: TPanel
    Left = 259
    Top = 172
    Width = 29
    Height = 21
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 20
  end
  object cbCmode: TcomboBoxV
    Left = 206
    Top = 268
    Width = 84
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 21
    OnChange = cbCmodeChange
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV1: TcomboBoxV
    Left = 60
    Top = 144
    Width = 132
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 22
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbLineStyle: TcomboBoxV
    Left = 88
    Top = 222
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
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
