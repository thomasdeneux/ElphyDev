inherited FitProp1: TFitProp1
  Left = 573
  Top = 131
  Caption = 'FitProp1'
  ClientHeight = 523
  ClientWidth = 525
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel [3]
    Left = 493
    Top = 3
    Width = 29
    Height = 13
    Caption = 'Clamp'
  end
  object Label9: TLabel [4]
    Left = 320
    Top = 192
    Width = 24
    Height = 13
    Caption = ' Chi2'
  end
  inherited Bcompile: TButton
    Top = 219
  end
  inherited Bvalidate: TButton
    Top = 245
  end
  inherited PanelResult: TPanel
    Width = 126
  end
  inherited Bsave: TButton
    Top = 245
  end
  inherited RB1: TRadioButton
    Top = 21
  end
  inherited GroupBox1: TGroupBox
    Left = 6
    Top = 165
  end
  inherited Bnew: TButton
    Top = 218
  end
  inherited Bload: TButton
    Top = 218
  end
  inherited Bchoose: TButton
    Top = 245
  end
  object CB1: TCheckBoxV
    Left = 496
    Top = 19
    Width = 20
    Height = 17
    TabOrder = 18
    UpdateVarOnToggle = True
  end
  object CB2: TCheckBoxV
    Left = 496
    Top = 36
    Width = 20
    Height = 17
    TabOrder = 19
    UpdateVarOnToggle = True
  end
  object CB3: TCheckBoxV
    Left = 496
    Top = 54
    Width = 20
    Height = 17
    TabOrder = 20
    UpdateVarOnToggle = True
  end
  object CB4: TCheckBoxV
    Left = 496
    Top = 71
    Width = 20
    Height = 17
    TabOrder = 21
    UpdateVarOnToggle = True
  end
  object CB5: TCheckBoxV
    Left = 496
    Top = 88
    Width = 20
    Height = 17
    TabOrder = 22
    UpdateVarOnToggle = True
  end
  object CB6: TCheckBoxV
    Left = 496
    Top = 105
    Width = 20
    Height = 17
    TabOrder = 23
    UpdateVarOnToggle = True
  end
  object CB7: TCheckBoxV
    Left = 496
    Top = 123
    Width = 20
    Height = 17
    TabOrder = 24
    UpdateVarOnToggle = True
  end
  object CB8: TCheckBoxV
    Left = 496
    Top = 140
    Width = 20
    Height = 17
    TabOrder = 25
    UpdateVarOnToggle = True
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 300
    Width = 507
    Height = 217
    Caption = 'Fit parameters'
    TabOrder = 26
    object LXstartFit: TLabel
      Left = 182
      Top = 120
      Width = 30
      Height = 13
      Caption = 'Xstart:'
    end
    object LXendFit: TLabel
      Left = 182
      Top = 143
      Width = 28
      Height = 13
      Caption = 'Xend:'
    end
    object Label10: TLabel
      Left = 237
      Top = 43
      Width = 101
      Height = 13
      Caption = 'Max number of points'
    end
    object Label12: TLabel
      Left = 13
      Top = 20
      Width = 31
      Height = 13
      Caption = 'Xdata:'
    end
    object Label13: TLabel
      Left = 13
      Top = 42
      Width = 31
      Height = 13
      Caption = 'Ydata:'
    end
    object Label14: TLabel
      Left = 13
      Top = 65
      Width = 49
      Height = 13
      Caption = 'Error data:'
    end
    object Label15: TLabel
      Left = 237
      Top = 20
      Width = 51
      Height = 13
      Caption = 'Weighting:'
    end
    object Label16: TLabel
      Left = 236
      Top = 65
      Width = 115
      Height = 13
      Caption = 'Max number of iterations'
    end
    object Label17: TLabel
      Left = 236
      Top = 87
      Width = 50
      Height = 13
      Caption = 'Threshold:'
    end
    object LIstartFit: TLabel
      Left = 13
      Top = 120
      Width = 26
      Height = 13
      Caption = 'Istart:'
    end
    object LIendFit: TLabel
      Left = 13
      Top = 143
      Width = 24
      Height = 13
      Caption = 'Iend:'
    end
    object LYstartFit: TLabel
      Left = 182
      Top = 165
      Width = 30
      Height = 13
      Caption = 'Ystart:'
    end
    object LYendFit: TLabel
      Left = 182
      Top = 188
      Width = 28
      Height = 13
      Caption = 'Yend:'
    end
    object enXStartFit: TeditNum
      Left = 235
      Top = 118
      Width = 106
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enXEndFit: TeditNum
      Left = 235
      Top = 140
      Width = 106
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enMaxNbpt: TeditNum
      Left = 359
      Top = 40
      Width = 82
      Height = 21
      TabOrder = 2
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbMode: TcomboBoxV
      Left = 338
      Top = 16
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object enMaxIt: TeditNum
      Left = 359
      Top = 62
      Width = 82
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enSeuil: TeditNum
      Left = 299
      Top = 84
      Width = 54
      Height = 21
      TabOrder = 5
      Text = '00'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object CBinit: TCheckBox
      Left = 366
      Top = 87
      Width = 74
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Initialize:'
      TabOrder = 6
    end
    object Bexecute: TButton
      Left = 377
      Top = 142
      Width = 64
      Height = 20
      Caption = 'Execute'
      TabOrder = 7
      OnClick = BexecuteClick
    end
    object enIstartFit: TeditNum
      Left = 66
      Top = 118
      Width = 93
      Height = 21
      TabOrder = 8
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enIendFit: TeditNum
      Left = 66
      Top = 140
      Width = 93
      Height = 21
      TabOrder = 9
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbUseIndices: TCheckBoxV
      Left = 12
      Top = 164
      Width = 146
      Height = 18
      Alignment = taLeftJustify
      Caption = 'Use indices'
      TabOrder = 10
      OnClick = cbUseIndicesClick
      UpdateVarOnToggle = False
    end
    object enYstartFit: TeditNum
      Left = 235
      Top = 163
      Width = 106
      Height = 21
      TabOrder = 11
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enYendFit: TeditNum
      Left = 235
      Top = 185
      Width = 106
      Height = 21
      TabOrder = 12
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enXdata: TEdit
      Left = 66
      Top = 17
      Width = 115
      Height = 21
      ReadOnly = True
      TabOrder = 13
      Text = '123'
    end
    object Bxdata: TBitBtn
      Tag = 1
      Left = 183
      Top = 19
      Width = 14
      Height = 14
      TabOrder = 14
      OnClick = BxdataClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333300000000000
        0033388888888888883330F888888888803338F333333333383330F333333333
        803338F333333333383330F333333333803338F333333333383330F333303333
        803338F333333333383330F333000333803338F333333333383330F330000033
        803338F333333333383330F333000333803338F333333333383330F333303333
        803338F333333333383330F333333333803338F333333333383330F333333333
        803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
        0033388888888888883333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object enYdata: TEdit
      Left = 66
      Top = 39
      Width = 115
      Height = 21
      ReadOnly = True
      TabOrder = 15
    end
    object Bydata: TBitBtn
      Tag = 2
      Left = 183
      Top = 41
      Width = 14
      Height = 14
      TabOrder = 16
      OnClick = BxdataClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333300000000000
        0033388888888888883330F888888888803338F333333333383330F333333333
        803338F333333333383330F333333333803338F333333333383330F333303333
        803338F333333333383330F333000333803338F333333333383330F330000033
        803338F333333333383330F333000333803338F333333333383330F333303333
        803338F333333333383330F333333333803338F333333333383330F333333333
        803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
        0033388888888888883333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object enSigData: TEdit
      Left = 66
      Top = 61
      Width = 115
      Height = 21
      ReadOnly = True
      TabOrder = 17
    end
    object BerrorData: TBitBtn
      Tag = 3
      Left = 183
      Top = 63
      Width = 14
      Height = 14
      TabOrder = 18
      OnClick = BxdataClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333300000000000
        0033388888888888883330F888888888803338F333333333383330F333333333
        803338F333333333383330F333333333803338F333333333383330F333303333
        803338F333333333383330F333000333803338F333333333383330F330000033
        803338F333333333383330F333000333803338F333333333383330F333303333
        803338F333333333383330F333333333803338F333333333383330F333333333
        803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
        0033388888888888883333333333333333333333333333333333}
      NumGlyphs = 2
    end
  end
  object PanelCHI2: TPanel
    Left = 363
    Top = 189
    Width = 126
    Height = 21
    Caption = ' '
    TabOrder = 27
  end
end
