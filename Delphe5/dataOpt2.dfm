object chooseMatOpt: TchooseMatOpt
  Left = 326
  Top = 123
  Width = 374
  Height = 388
  Caption = 'Options'
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
  object BOK: TButton
    Left = 117
    Top = 325
    Width = 57
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 214
    Top = 325
    Width = 57
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 11
    Top = 7
    Width = 169
    Height = 127
    Caption = 'Horizontal scale'
    TabOrder = 2
    object cbValueX: TCheckBoxV
      Left = 10
      Top = 21
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show values'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbTicksX: TCheckBoxV
      Left = 10
      Top = 36
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show ticks'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object cbExternalX: TCheckBoxV
      Left = 10
      Top = 52
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'external ticks'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object CbCompletX: TCheckBoxV
      Left = 10
      Top = 68
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'top ticks'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object cbInvertX: TCheckBoxV
      Left = 10
      Top = 84
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Invert axis'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
    object cbX0: TCheckBoxV
      Left = 10
      Top = 101
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Zero axis'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 190
    Top = 7
    Width = 169
    Height = 127
    Caption = 'Vertical scale'
    TabOrder = 3
    object cbValueY: TCheckBoxV
      Left = 10
      Top = 20
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show values'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object cbTicksY: TCheckBoxV
      Left = 10
      Top = 36
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'show ticks'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object cbExternalY: TCheckBoxV
      Left = 11
      Top = 52
      Width = 145
      Height = 17
      Alignment = taLeftJustify
      Caption = 'external ticks'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object cbCompletY: TCheckBoxV
      Left = 10
      Top = 68
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'right ticks'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object CbInvertY: TCheckBoxV
      Left = 10
      Top = 85
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Invert axis'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
    object cbY0: TCheckBoxV
      Left = 10
      Top = 101
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Zero axis'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object Bcolor: TButton
    Left = 34
    Top = 291
    Width = 72
    Height = 23
    Caption = 'Scale color '
    TabOrder = 4
    OnClick = BcolorClick
  end
  object Pcolor: TPanel
    Left = 116
    Top = 291
    Width = 68
    Height = 23
    TabOrder = 5
  end
  object Bfont: TButton
    Left = 213
    Top = 291
    Width = 65
    Height = 22
    Caption = 'Font'
    TabOrder = 6
    OnClick = BfontClick
  end
  object cbKeepRatio: TCheckBoxV
    Left = 12
    Top = 265
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Keep aspect ratio'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
  object GroupBox3: TGroupBox
    Left = 11
    Top = 138
    Width = 348
    Height = 117
    Caption = 'WF mode'
    TabOrder = 8
    object enDx: TLabel
      Left = 10
      Top = 61
      Width = 30
      Height = 13
      Caption = 'Dx (%)'
    end
    object Label8: TLabel
      Left = 10
      Top = 85
      Width = 30
      Height = 13
      Caption = 'Dy (%)'
    end
    object Label1: TLabel
      Left = 189
      Top = 21
      Width = 52
      Height = 13
      Caption = 'Left margin'
    end
    object Label2: TLabel
      Left = 189
      Top = 42
      Width = 59
      Height = 13
      Caption = 'Right margin'
    end
    object Label3: TLabel
      Left = 189
      Top = 66
      Width = 53
      Height = 13
      Caption = 'Top margin'
    end
    object Label4: TLabel
      Left = 189
      Top = 90
      Width = 67
      Height = 13
      Caption = 'Bottom margin'
    end
    object enDeltaX: TeditNum
      Left = 80
      Top = 59
      Width = 73
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDeltaY: TeditNum
      Left = 80
      Top = 81
      Width = 73
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enLeft: TeditNum
      Left = 260
      Top = 15
      Width = 73
      Height = 21
      TabOrder = 2
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enRight: TeditNum
      Left = 260
      Top = 38
      Width = 73
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enTop: TeditNum
      Left = 260
      Top = 61
      Width = 73
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enBottom: TeditNum
      Left = 260
      Top = 85
      Width = 73
      Height = 21
      TabOrder = 5
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbUsesWF: TCheckBoxV
      Left = 10
      Top = 23
      Width = 143
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use WF mode'
      TabOrder = 6
      UpdateVarOnToggle = False
    end
  end
  object ColorDialog1: TColorDialog
    Left = 36
    Top = 336
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 65535
    Top = 336
  end
end
