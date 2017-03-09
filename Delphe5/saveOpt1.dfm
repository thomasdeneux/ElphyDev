object SaveOptions: TSaveOptions
  Left = 249
  Top = 208
  BorderStyle = bsDialog
  Caption = 'SaveOptions'
  ClientHeight = 285
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Bok: TButton
    Left = 241
    Top = 212
    Width = 67
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 339
    Top = 212
    Width = 67
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 186
    Width = 202
    Height = 82
    Caption = 'Information block sizes'
    TabOrder = 2
    object Label3: TLabel
      Left = 17
      Top = 24
      Width = 70
      Height = 13
      Caption = 'File information'
    end
    object Label4: TLabel
      Left = 17
      Top = 45
      Width = 96
      Height = 13
      Caption = 'Episode Information:'
    end
    object enFileInfo: TeditNum
      Left = 122
      Top = 21
      Width = 69
      Height = 21
      TabOrder = 0
      Text = '1200'
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enEpInfo: TeditNum
      Left = 121
      Top = 43
      Width = 70
      Height = 21
      TabOrder = 1
      Text = '00'
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 9
    Width = 202
    Height = 97
    Caption = 'X-scale parameters'
    TabOrder = 3
    object Dx: TLabel
      Left = 20
      Top = 42
      Width = 13
      Height = 13
      Caption = 'Dx'
    end
    object Label7: TLabel
      Left = 20
      Top = 65
      Width = 24
      Height = 13
      Caption = 'Units'
    end
    object enDx: TeditNum
      Left = 74
      Top = 39
      Width = 115
      Height = 21
      TabOrder = 0
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitX: TeditString
      Left = 74
      Top = 62
      Width = 115
      Height = 21
      TabOrder = 1
      Text = 'esUnitX'
      len = 0
      UpdateVarOnExit = False
    end
    object cbAutoX: TCheckBoxV
      Left = 21
      Top = 20
      Width = 169
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Automatic'
      TabOrder = 2
      OnClick = cbAutoXClick
      UpdateVarOnToggle = False
    end
  end
  object GroupBox3: TGroupBox
    Left = 7
    Top = 110
    Width = 202
    Height = 72
    Caption = 'Data type'
    TabOrder = 4
    object Label1: TLabel
      Left = 20
      Top = 42
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object cbType: TcomboBoxV
      Left = 95
      Top = 40
      Width = 96
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbType'
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbAutoTp: TCheckBoxV
      Left = 21
      Top = 20
      Width = 169
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Automatic'
      TabOrder = 1
      OnClick = cbAutoXClick
      UpdateVarOnToggle = False
    end
  end
  object GroupBox4: TGroupBox
    Left = 221
    Top = 9
    Width = 203
    Height = 172
    Caption = 'Y-scale parameters'
    TabOrder = 5
    object Label2: TLabel
      Left = 20
      Top = 86
      Width = 13
      Height = 13
      Caption = 'Dy'
    end
    object Label5: TLabel
      Left = 18
      Top = 19
      Width = 34
      Height = 13
      Caption = 'Vector:'
    end
    object Label6: TLabel
      Left = 20
      Top = 110
      Width = 11
      Height = 13
      Caption = 'y0'
    end
    object Label8: TLabel
      Left = 20
      Top = 136
      Width = 24
      Height = 13
      Caption = 'Units'
    end
    object enDy: TeditNum
      Left = 70
      Top = 83
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '1'
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbVecY: TcomboBoxV
      Left = 19
      Top = 34
      Width = 173
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'cbVecY'
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object enY0: TeditNum
      Left = 70
      Top = 107
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0'
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitY: TeditString
      Left = 70
      Top = 134
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'esUnitY'
      len = 0
      UpdateVarOnExit = False
    end
    object cbAutoY: TCheckBoxV
      Left = 18
      Top = 61
      Width = 173
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Automatic'
      TabOrder = 4
      OnClick = cbAutoYClick
      UpdateVarOnToggle = False
    end
  end
end
