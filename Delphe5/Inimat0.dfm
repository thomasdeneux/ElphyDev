object initTmatrix: TinitTmatrix
  Left = 390
  Top = 198
  BorderStyle = bsDialog
  Caption = 'New matrix'
  ClientHeight = 385
  ClientWidth = 346
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
    Left = 82
    Top = 350
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 171
    Top = 350
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 11
    Width = 329
    Height = 105
    Caption = 'Structure'
    TabOrder = 2
    object Label2: TLabel
      Left = 10
      Top = 24
      Width = 23
      Height = 13
      Caption = 'Istart'
    end
    object Label3: TLabel
      Left = 10
      Top = 46
      Width = 21
      Height = 13
      Caption = 'Iend'
    end
    object Label4: TLabel
      Left = 51
      Top = 76
      Width = 60
      Height = 13
      Caption = 'Number type'
    end
    object Label8: TLabel
      Left = 163
      Top = 23
      Width = 25
      Height = 13
      Caption = 'Jstart'
    end
    object Label9: TLabel
      Left = 163
      Top = 45
      Width = 23
      Height = 13
      Caption = 'Jend'
    end
    object enIStart: TeditNum
      Left = 51
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
    object enIEnd: TeditNum
      Left = 51
      Top = 46
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
      Left = 137
      Top = 74
      Width = 96
      Height = 21
      TabOrder = 2
      Text = 'cbType'
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object enJstart: TeditNum
      Left = 204
      Top = 21
      Width = 95
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enJend: TeditNum
      Left = 204
      Top = 44
      Width = 95
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 120
    Width = 331
    Height = 163
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
    object Label10: TLabel
      Left = 11
      Top = 108
      Width = 16
      Height = 13
      Caption = 'Dz:'
    end
    object Label11: TLabel
      Left = 11
      Top = 129
      Width = 16
      Height = 13
      Caption = 'Z0:'
    end
    object Label12: TLabel
      Left = 207
      Top = 23
      Width = 35
      Height = 13
      Caption = 'X units:'
    end
    object Label13: TLabel
      Left = 206
      Top = 66
      Width = 35
      Height = 13
      Caption = 'Y units:'
    end
    object enDx: TeditNum
      Left = 97
      Top = 20
      Width = 96
      Height = 21
      TabOrder = 0
      Text = 'enDx'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enX0: TeditNum
      Left = 97
      Top = 41
      Width = 96
      Height = 21
      TabOrder = 1
      Text = 'enX0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDy: TeditNum
      Left = 97
      Top = 63
      Width = 96
      Height = 21
      TabOrder = 2
      Text = 'enDy'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enY0: TeditNum
      Left = 97
      Top = 85
      Width = 96
      Height = 21
      TabOrder = 3
      Text = 'enY0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDz: TeditNum
      Left = 97
      Top = 106
      Width = 96
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enZ0: TeditNum
      Left = 97
      Top = 128
      Width = 96
      Height = 21
      TabOrder = 5
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitX: TeditString
      Left = 248
      Top = 20
      Width = 71
      Height = 21
      TabOrder = 6
      len = 0
      UpdateVarOnExit = False
    end
    object esUnitY: TeditString
      Left = 249
      Top = 63
      Width = 71
      Height = 21
      TabOrder = 7
      len = 0
      UpdateVarOnExit = False
    end
  end
  object GBopt: TGroupBox
    Left = 7
    Top = 285
    Width = 331
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
