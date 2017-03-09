inherited MFitProp1: TMFitProp1
  Left = 245
  Top = 205
  Caption = 'MFitProp1'
  ClientHeight = 456
  ClientWidth = 459
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 11
    Top = 291
    Width = 438
    Height = 96
    Caption = 'Fit parameters'
    TabOrder = 18
    object Label12: TLabel
      Left = 13
      Top = 20
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object Label14: TLabel
      Left = 13
      Top = 43
      Width = 49
      Height = 13
      Caption = 'Error data:'
    end
    object Label15: TLabel
      Left = 220
      Top = 20
      Width = 51
      Height = 13
      Caption = 'Weighting:'
    end
    object Label16: TLabel
      Left = 219
      Top = 45
      Width = 115
      Height = 13
      Caption = 'Max number of iterations'
    end
    object Label17: TLabel
      Left = 219
      Top = 67
      Width = 50
      Height = 13
      Caption = 'Threshold:'
    end
    object CBdata: TcomboBoxV
      Left = 67
      Top = 17
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbSigdata: TcomboBoxV
      Left = 67
      Top = 40
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbMode: TcomboBoxV
      Left = 320
      Top = 16
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object enMaxIt: TeditNum
      Left = 342
      Top = 42
      Width = 82
      Height = 21
      TabOrder = 3
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enSeuil: TeditNum
      Left = 282
      Top = 64
      Width = 54
      Height = 21
      TabOrder = 4
      Text = '00'
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object CBinit: TCheckBox
      Left = 349
      Top = 67
      Width = 74
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Initialize:'
      TabOrder = 5
    end
    object cbUseSelection: TCheckBoxV
      Left = 12
      Top = 68
      Width = 158
      Height = 18
      Alignment = taLeftJustify
      Caption = 'Use selection'
      TabOrder = 6
      UpdateVarOnToggle = False
    end
  end
  object GroupBox3: TGroupBox
    Left = 12
    Top = 398
    Width = 213
    Height = 47
    Caption = 'Chi2'
    TabOrder = 19
    object Lchi2: TLabel
      Left = 10
      Top = 19
      Width = 27
      Height = 13
      Caption = '0.000'
    end
    object Bchi2: TButton
      Left = 134
      Top = 16
      Width = 64
      Height = 20
      Caption = 'Calculate'
      TabOrder = 0
      OnClick = Bchi2Click
    end
  end
  object Button5: TButton
    Left = 258
    Top = 413
    Width = 64
    Height = 20
    Caption = 'Execute fit'
    TabOrder = 20
    OnClick = BexecuteClick
  end
end
