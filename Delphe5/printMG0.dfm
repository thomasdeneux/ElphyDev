object printMgDialog: TprintMgDialog
  Left = 493
  Top = 224
  BorderStyle = bsDialog
  Caption = 'Print'
  ClientHeight = 349
  ClientWidth = 383
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
  object Lcomment: TLabel
    Left = 16
    Top = 205
    Width = 47
    Height = 13
    Caption = 'Comment:'
  end
  object C_print: TButton
    Left = 72
    Top = 252
    Width = 121
    Height = 20
    Caption = 'Print'
    ModalResult = 1
    TabOrder = 0
  end
  object C_setup: TButton
    Left = 216
    Top = 252
    Width = 93
    Height = 20
    Caption = 'Printer setup'
    TabOrder = 1
    OnClick = C_setupClick
  end
  object C_cancel: TButton
    Left = 216
    Top = 292
    Width = 93
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object C_orientation: TRadioGroup
    Left = 17
    Top = 7
    Width = 119
    Height = 66
    Caption = 'Orientation'
    Items.Strings = (
      'Portrait'
      'Landscape')
    TabOrder = 3
  end
  object CBbitmap: TCheckBoxV
    Left = 202
    Top = 11
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Bitmap mode'
    TabOrder = 4
    UpdateVarOnToggle = False
  end
  object CBmono: TCheckBoxV
    Left = 202
    Top = 29
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Monochrome'
    TabOrder = 5
    UpdateVarOnToggle = False
  end
  object CBwhiteBK: TCheckBoxV
    Left = 202
    Top = 47
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'White background'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
  object EScomment: TeditString
    Left = 15
    Top = 221
    Width = 346
    Height = 21
    TabOrder = 7
    len = 0
    UpdateVarOnExit = False
  end
  object C_printName: TCheckBoxV
    Left = 13
    Top = 185
    Width = 164
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Print  date and file name'
    TabOrder = 8
    UpdateVarOnToggle = False
  end
  object Button1: TButton
    Left = 72
    Top = 278
    Width = 121
    Height = 20
    Caption = 'Save '
    ModalResult = 101
    TabOrder = 9
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 95
    Width = 169
    Height = 76
    Caption = 'Aspect'
    TabOrder = 10
    object rbAspect: TRadioButton
      Left = 16
      Top = 21
      Width = 113
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Keep aspect ratio'
      TabOrder = 0
    end
    object rbWholePage: TRadioButton
      Left = 16
      Top = 44
      Width = 113
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use whole page'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 192
    Top = 95
    Width = 177
    Height = 76
    Caption = 'Mag.factors'
    TabOrder = 11
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
  object cbSplitMatrix: TCheckBoxV
    Left = 202
    Top = 65
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Split Matrix'
    TabOrder = 12
    UpdateVarOnToggle = False
  end
  object Button2: TButton
    Left = 72
    Top = 304
    Width = 121
    Height = 20
    Caption = 'Copy To ClipBoard'
    ModalResult = 102
    TabOrder = 13
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 356
    Top = 281
  end
end
