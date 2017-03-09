object chooseOpt: TchooseOpt
  Left = 533
  Top = 316
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 253
  ClientWidth = 372
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
    Left = 105
    Top = 206
    Width = 57
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 202
    Top = 206
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
    Height = 126
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
    Height = 126
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
      Top = 100
      Width = 146
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Zero axis'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object Bcolor: TButton
    Left = 22
    Top = 172
    Width = 72
    Height = 23
    Caption = 'Scale color '
    TabOrder = 4
    OnClick = BcolorClick
  end
  object Pcolor: TPanel
    Left = 104
    Top = 172
    Width = 68
    Height = 23
    TabOrder = 5
  end
  object Bfont: TButton
    Left = 201
    Top = 172
    Width = 65
    Height = 22
    Caption = 'Font'
    TabOrder = 6
    OnClick = BfontClick
  end
  object cbKeepRatio: TCheckBoxV
    Left = 21
    Top = 143
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Keep aspect ratio'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
  object ColorDialog1: TColorDialog
    Left = 37
    Top = 217
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 12
    Top = 217
  end
end
