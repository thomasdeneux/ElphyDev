object initTvector: TinitTvector
  Left = 434
  Top = 241
  BorderStyle = bsDialog
  Caption = 'New vector'
  ClientHeight = 328
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bok: TButton
    Left = 97
    Top = 286
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 225
    Top = 286
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 10
    Width = 360
    Height = 87
    Caption = 'Structure'
    TabOrder = 2
    object Label2: TLabel
      Left = 10
      Top = 24
      Width = 53
      Height = 13
      Caption = 'Start index:'
    end
    object Label3: TLabel
      Left = 10
      Top = 46
      Width = 47
      Height = 13
      Caption = 'End index'
    end
    object Label4: TLabel
      Left = 181
      Top = 24
      Width = 60
      Height = 13
      Caption = 'Number type'
    end
    object enStart: TeditNum
      Left = 70
      Top = 22
      Width = 95
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enEnd: TeditNum
      Left = 70
      Top = 45
      Width = 95
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbType: TcomboBoxV
      Left = 257
      Top = 22
      Width = 96
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'cbType'
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbReadOnly: TCheckBoxV
      Left = 180
      Top = 47
      Width = 90
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Read Only'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 9
    Top = 107
    Width = 360
    Height = 120
    Caption = 'Scaling parameters'
    TabOrder = 3
    object Label1: TLabel
      Left = 11
      Top = 21
      Width = 16
      Height = 13
      Caption = 'Dx:'
    end
    object Label5: TLabel
      Left = 11
      Top = 42
      Width = 16
      Height = 13
      Caption = 'X0:'
    end
    object Label6: TLabel
      Left = 11
      Top = 65
      Width = 16
      Height = 13
      Caption = 'Dy:'
    end
    object Label7: TLabel
      Left = 11
      Top = 86
      Width = 16
      Height = 13
      Caption = 'Y0:'
    end
    object Label12: TLabel
      Left = 216
      Top = 23
      Width = 35
      Height = 13
      Caption = 'X units:'
    end
    object Label13: TLabel
      Left = 215
      Top = 52
      Width = 35
      Height = 13
      Caption = 'Y units:'
    end
    object enDx: TeditNum
      Left = 70
      Top = 20
      Width = 96
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enX0: TeditNum
      Left = 70
      Top = 41
      Width = 96
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDy: TeditNum
      Left = 70
      Top = 63
      Width = 96
      Height = 21
      TabOrder = 2
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enY0: TeditNum
      Left = 70
      Top = 85
      Width = 96
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitX: TeditString
      Left = 257
      Top = 20
      Width = 71
      Height = 21
      TabOrder = 4
      len = 0
      UpdateVarOnExit = False
    end
    object esUnitY: TeditString
      Left = 258
      Top = 49
      Width = 71
      Height = 21
      TabOrder = 5
      len = 0
      UpdateVarOnExit = False
    end
    object cbInHz: TCheckBoxV
      Left = 214
      Top = 79
      Width = 115
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Display In Hertz'
      TabOrder = 6
      UpdateVarOnToggle = False
    end
  end
  object GBopt: TGroupBox
    Left = 9
    Top = 235
    Width = 360
    Height = 34
    TabOrder = 4
    object LabelOpt: TLabel
      Left = 11
      Top = 12
      Width = 43
      Height = 13
      Caption = 'LabelOpt'
    end
  end
end
