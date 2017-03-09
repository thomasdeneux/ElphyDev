object BuildContourForm: TBuildContourForm
  Left = 491
  Top = 184
  BorderStyle = bsDialog
  Caption = 'Build contour plot'
  ClientHeight = 446
  ClientWidth = 305
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
    Left = 18
    Top = 68
    Width = 79
    Height = 13
    Caption = 'Number of levels'
  end
  object Label2: TLabel
    Left = 18
    Top = 19
    Width = 23
    Height = 13
    Caption = 'Zmin'
  end
  object Label3: TLabel
    Left = 18
    Top = 43
    Width = 26
    Height = 13
    Caption = 'Zmax'
  end
  object Label4: TLabel
    Left = 18
    Top = 178
    Width = 48
    Height = 13
    Caption = 'Line width'
  end
  object Label5: TLabel
    Left = 18
    Top = 229
    Width = 51
    Height = 13
    Caption = 'Zero Level'
  end
  object Bok: TButton
    Left = 66
    Top = 388
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 155
    Top = 388
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object enNumber: TeditNum
    Left = 120
    Top = 64
    Width = 81
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enZmin: TeditNum
    Left = 120
    Top = 15
    Width = 81
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enZmax: TeditNum
    Left = 120
    Top = 39
    Width = 81
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 213
    Top = 30
    Width = 74
    Height = 20
    Caption = 'Search limits'
    TabOrder = 5
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 14
    Top = 257
    Width = 219
    Height = 112
    Caption = 'Options'
    TabOrder = 6
    object cbSel: TCheckBoxV
      Left = 9
      Top = 24
      Width = 185
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Ignore selected pixels'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbMark: TCheckBoxV
      Left = 9
      Top = 42
      Width = 185
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Ignore marked pixels'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object cbValue: TCheckBoxV
      Left = 9
      Top = 60
      Width = 89
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Ignore value'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object enValue: TeditNum
      Left = 113
      Top = 59
      Width = 81
      Height = 21
      TabOrder = 3
      Text = '111'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbPosition: TCheckBoxV
      Left = 9
      Top = 79
      Width = 185
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use Matrix Position'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
  end
  object Bcolor: TButton
    Left = 17
    Top = 91
    Width = 84
    Height = 20
    Caption = 'Color'
    TabOrder = 7
    OnClick = BcolorClick
  end
  object Pcolor: TPanel
    Left = 121
    Top = 91
    Width = 80
    Height = 21
    TabOrder = 8
  end
  object GroupBox2: TGroupBox
    Left = 15
    Top = 117
    Width = 143
    Height = 53
    Caption = 'Palette name'
    TabOrder = 9
    object cbPalName: TComboBox
      Left = 5
      Top = 20
      Width = 132
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object enLineWidth: TeditNum
    Left = 120
    Top = 174
    Width = 81
    Height = 21
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbPolygons: TCheckBoxV
    Left = 18
    Top = 201
    Width = 82
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Polygons'
    TabOrder = 11
    UpdateVarOnToggle = False
  end
  object enFirstLevel: TeditNum
    Left = 120
    Top = 221
    Width = 81
    Height = 21
    TabOrder = 12
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object ColorDialog1: TColorDialog
    Left = 264
    Top = 363
  end
end
