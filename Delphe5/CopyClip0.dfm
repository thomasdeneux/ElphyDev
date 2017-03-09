object CopyClip: TCopyClip
  Left = 291
  Top = 191
  BorderStyle = bsDialog
  Caption = 'CopyClip'
  ClientHeight = 147
  ClientWidth = 348
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
  object C_cancel: TButton
    Left = 182
    Top = 110
    Width = 93
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object CBbitmap: TCheckBoxV
    Left = 217
    Top = 20
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Bitmap mode'
    TabOrder = 1
    UpdateVarOnToggle = False
  end
  object CBmono: TCheckBoxV
    Left = 217
    Top = 38
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Monochrome'
    TabOrder = 2
    UpdateVarOnToggle = False
  end
  object CBwhiteBK: TCheckBoxV
    Left = 217
    Top = 56
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'White background'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
  object Bcopy: TButton
    Left = 57
    Top = 110
    Width = 93
    Height = 20
    Caption = 'Copy'
    ModalResult = 1
    TabOrder = 4
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 9
    Width = 177
    Height = 76
    Caption = 'Mag.factors'
    TabOrder = 5
    object Label1: TLabel
      Left = 11
      Top = 21
      Width = 26
      Height = 13
      Caption = 'Fonts'
    end
    object Label2: TLabel
      Left = 11
      Top = 45
      Width = 45
      Height = 13
      Caption = 'Symboles'
    end
    object enMagFactor: TeditNum
      Left = 64
      Top = 18
      Width = 57
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enSymbFactor: TeditNum
      Left = 64
      Top = 42
      Width = 57
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbAutoSymb: TCheckBoxV
      Left = 126
      Top = 43
      Width = 43
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Auto'
      TabOrder = 2
      OnClick = cbAutoSymbClick
      UpdateVarOnToggle = False
    end
    object cbAutoFont: TCheckBoxV
      Left = 126
      Top = 20
      Width = 43
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Auto'
      TabOrder = 3
      OnClick = cbAutoFontClick
      UpdateVarOnToggle = False
    end
  end
  object cbSplitMat: TCheckBoxV
    Left = 217
    Top = 74
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Split Matrices'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
end
