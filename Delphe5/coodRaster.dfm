object getRasterCoo: TgetRasterCoo
  Left = 469
  Top = 192
  BorderStyle = bsDialog
  Caption = 'Raster Plot Coordinates'
  ClientHeight = 355
  ClientWidth = 311
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
  object Label2: TLabel
    Left = 15
    Top = 8
    Width = 26
    Height = 13
    Caption = 'Xmin:'
  end
  object Label3: TLabel
    Left = 15
    Top = 32
    Width = 26
    Height = 13
    Caption = 'Xmax'
  end
  object Label4: TLabel
    Left = 159
    Top = 9
    Width = 23
    Height = 13
    Caption = 'Ymin'
  end
  object Label5: TLabel
    Left = 159
    Top = 33
    Width = 26
    Height = 13
    Caption = 'Ymax'
  end
  object Label1: TLabel
    Left = 23
    Top = 205
    Width = 54
    Height = 13
    Caption = 'Line Height'
  end
  object Label6: TLabel
    Left = 173
    Top = 205
    Width = 51
    Height = 13
    Caption = 'Title Width'
  end
  object Label7: TLabel
    Left = 173
    Top = 229
    Width = 18
    Height = 13
    Caption = 'Cpx'
  end
  object Label8: TLabel
    Left = 23
    Top = 229
    Width = 57
    Height = 13
    Caption = 'Symbol Size'
  end
  object editNum1: TeditNum
    Left = 60
    Top = 6
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
    Top = 30
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
    Left = 204
    Top = 6
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
    Left = 204
    Top = 30
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
  object Button5: TButton
    Left = 82
    Top = 316
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 162
    Top = 316
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 58
    Width = 137
    Height = 136
    Caption = 'Horizontal scale'
    TabOrder = 6
    object cbValueX: TCheckBoxV
      Left = 10
      Top = 21
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show values'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbTicksX: TCheckBoxV
      Left = 10
      Top = 36
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show ticks'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object cbExternalX: TCheckBoxV
      Left = 10
      Top = 52
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'external ticks'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object CbCompletX: TCheckBoxV
      Left = 10
      Top = 68
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'top ticks'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object cbInvertX: TCheckBoxV
      Left = 10
      Top = 84
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Invert axis'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 161
    Top = 58
    Width = 137
    Height = 136
    Caption = 'Vertical scale'
    TabOrder = 7
    object cbTitles: TCheckBoxV
      Left = 9
      Top = 20
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show titles'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbGrid: TCheckBoxV
      Left = 9
      Top = 36
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show grid'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object CbInvertY: TCheckBoxV
      Left = 9
      Top = 52
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Invert axis'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
  end
  object Bcolor: TButton
    Left = 19
    Top = 265
    Width = 72
    Height = 22
    Caption = 'Scale color '
    TabOrder = 8
    OnClick = BcolorClick
  end
  object Pcolor: TPanel
    Left = 101
    Top = 265
    Width = 68
    Height = 22
    TabOrder = 9
  end
  object Bfont: TButton
    Left = 198
    Top = 265
    Width = 65
    Height = 22
    Caption = 'Font'
    TabOrder = 10
    OnClick = BfontClick
  end
  object enHline: TeditNum
    Left = 91
    Top = 202
    Width = 46
    Height = 21
    TabOrder = 11
    Text = '20'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enTitleWidth: TeditNum
    Left = 241
    Top = 202
    Width = 46
    Height = 21
    TabOrder = 12
    Text = '20'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enCpx: TeditNum
    Left = 241
    Top = 226
    Width = 46
    Height = 21
    TabOrder = 13
    Text = '20'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enTailleT: TeditNum
    Left = 91
    Top = 226
    Width = 46
    Height = 21
    TabOrder = 14
    Text = '20'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object ColorDialog2: TColorDialog
    Left = 65534
    Top = 334
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 33
    Top = 334
  end
end
