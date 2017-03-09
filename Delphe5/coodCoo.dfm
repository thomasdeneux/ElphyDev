object getCooDcoo: TgetCooDcoo
  Left = 395
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Coordinates'
  ClientHeight = 333
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
  object cbGrid: TCheckBoxV
    Left = 176
    Top = 203
    Width = 71
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Grid:'
    TabOrder = 4
    UpdateVarOnToggle = False
  end
  object Button5: TButton
    Left = 82
    Top = 290
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 162
    Top = 290
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 58
    Width = 137
    Height = 136
    Caption = 'Horizontal scale'
    TabOrder = 7
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
    object cbLogX: TCheckBoxV
      Left = 10
      Top = 101
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Logarithmic'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 161
    Top = 58
    Width = 137
    Height = 136
    Caption = 'Vertical scale'
    TabOrder = 8
    object cbValueY: TCheckBoxV
      Left = 9
      Top = 20
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show values'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbTicksY: TCheckBoxV
      Left = 9
      Top = 36
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show ticks'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object cbExternalY: TCheckBoxV
      Left = 9
      Top = 52
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'external ticks'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object cbCompletY: TCheckBoxV
      Left = 9
      Top = 68
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'right ticks'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object CbInvertY: TCheckBoxV
      Left = 9
      Top = 85
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Invert axis'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
    object cbLogY: TCheckBoxV
      Left = 9
      Top = 101
      Width = 114
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Logarithmic'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object Bcolor: TButton
    Left = 19
    Top = 239
    Width = 72
    Height = 23
    Caption = 'Scale color '
    TabOrder = 9
    OnClick = BcolorClick
  end
  object Pcolor: TPanel
    Left = 101
    Top = 239
    Width = 68
    Height = 23
    TabOrder = 10
  end
  object Bfont: TButton
    Left = 198
    Top = 239
    Width = 65
    Height = 22
    Caption = 'Font'
    TabOrder = 11
    OnClick = BfontClick
  end
  object cbKeepRatio: TCheckBoxV
    Left = 12
    Top = 204
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Keep aspect ratio'
    TabOrder = 12
    UpdateVarOnToggle = False
  end
  object ColorDialog2: TColorDialog
    Left = 65534
    Top = 308
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 33
    Top = 308
  end
end
