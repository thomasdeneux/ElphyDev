object paramAcq: TparamAcq
  Left = 292
  Top = 106
  BorderStyle = bsDialog
  Caption = 'Acquisition parameters'
  ClientHeight = 316
  ClientWidth = 357
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object TPageControl
    Left = 0
    Top = 0
    Width = 357
    Height = 264
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 349
        Height = 210
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 23
          Top = 18
          Width = 30
          Height = 13
          Caption = 'Mode:'
        end
        object Label2: TLabel
          Left = 22
          Top = 47
          Width = 98
          Height = 13
          Caption = 'Number of channels:'
        end
        object Label3: TLabel
          Left = 22
          Top = 76
          Width = 43
          Height = 13
          Caption = 'Duration:'
        end
        object Label4: TLabel
          Left = 22
          Top = 106
          Width = 92
          Height = 13
          Caption = 'Period per channel:'
        end
        object TLabel
          Left = 23
          Top = 139
          Width = 3
          Height = 13
        end
        object Label5: TLabel
          Left = 22
          Top = 136
          Width = 102
          Height = 13
          Caption = 'Samples per channel:'
        end
        object Label6: TLabel
          Left = 22
          Top = 166
          Width = 108
          Height = 13
          Caption = 'Samples before trigger:'
        end
        object cbMode: TcomboBoxV
          Left = 60
          Top = 15
          Width = 98
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Tnum = T_byte
          UpdateVarOnExit = False
        end
        object enNbvoie: TeditNum
          Left = 139
          Top = 44
          Width = 106
          Height = 21
          TabOrder = 1
          Tnum = T_byte
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDuree: TeditNum
          Left = 139
          Top = 74
          Width = 106
          Height = 21
          TabOrder = 2
          Tnum = T_byte
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enPeriode: TeditNum
          Left = 139
          Top = 104
          Width = 106
          Height = 21
          TabOrder = 3
          Tnum = T_byte
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enNbpt: TeditNum
          Left = 139
          Top = 134
          Width = 106
          Height = 21
          TabOrder = 4
          Tnum = T_byte
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enNbAv: TeditNum
          Left = 139
          Top = 164
          Width = 106
          Height = 21
          TabOrder = 5
          Tnum = T_byte
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Trigger'
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 349
        Height = 236
        Align = alClient
        TabOrder = 0
        object Label7: TLabel
          Left = 23
          Top = 18
          Width = 30
          Height = 13
          Caption = 'Mode:'
        end
        object Label8: TLabel
          Left = 22
          Top = 47
          Width = 73
          Height = 13
          Caption = 'analog channel'
        end
        object Label9: TLabel
          Left = 22
          Top = 76
          Width = 75
          Height = 13
          Caption = 'Upper threshold'
        end
        object Label10: TLabel
          Left = 23
          Top = 106
          Width = 75
          Height = 13
          Caption = 'Lower threshold'
        end
        object Label11: TLabel
          Left = 22
          Top = 136
          Width = 58
          Height = 13
          Caption = 'Test interval'
        end
        object comboBoxV1: TcomboBoxV
          Left = 61
          Top = 14
          Width = 142
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Tnum = T_byte
          UpdateVarOnExit = False
        end
        object enVoieSynchro: TeditNum
          Left = 139
          Top = 44
          Width = 106
          Height = 21
          TabOrder = 1
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enSeuilHaut: TeditNum
          Left = 139
          Top = 74
          Width = 106
          Height = 21
          TabOrder = 2
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enSeuilBas: TeditNum
          Left = 140
          Top = 104
          Width = 106
          Height = 21
          TabOrder = 3
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enInterval: TeditNum
          Left = 139
          Top = 134
          Width = 106
          Height = 21
          TabOrder = 4
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Channels'
      object Label12: TLabel
        Left = 13
        Top = 11
        Width = 42
        Height = 13
        Caption = 'Channel:'
      end
      object Label17: TLabel
        Left = 8
        Top = 169
        Width = 118
        Height = 13
        Caption = 'Physical channel number'
      end
      object Label18: TLabel
        Left = 9
        Top = 194
        Width = 25
        Height = 13
        Caption = 'Gain:'
      end
      object GroupBox3: TGroupBox
        Left = -1
        Top = 39
        Width = 350
        Height = 114
        Caption = 'Vertical scaling factors'
        TabOrder = 0
        object Label13: TLabel
          Left = 23
          Top = 56
          Width = 8
          Height = 13
          Caption = 'j='
        end
        object Label80: TLabel
          Left = 113
          Top = 57
          Width = 85
          Height = 13
          Caption = 'Corresponds to y='
        end
        object Label14: TLabel
          Left = 23
          Top = 84
          Width = 8
          Height = 13
          Caption = 'j='
        end
        object Label15: TLabel
          Left = 112
          Top = 84
          Width = 85
          Height = 13
          Caption = 'Corresponds to y='
        end
        object Label16: TLabel
          Left = 23
          Top = 27
          Width = 27
          Height = 13
          Caption = 'Units:'
        end
        object enJ1: TeditNum
          Left = 44
          Top = 53
          Width = 58
          Height = 21
          TabOrder = 0
          Tnum = T_byte
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enY1: TeditNum
          Left = 203
          Top = 55
          Width = 93
          Height = 21
          TabOrder = 1
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enJ2: TeditNum
          Left = 44
          Top = 81
          Width = 58
          Height = 21
          TabOrder = 2
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enY2: TeditNum
          Left = 202
          Top = 82
          Width = 93
          Height = 21
          TabOrder = 3
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object editNum1: TeditNum
          Left = 69
          Top = 24
          Width = 89
          Height = 21
          TabOrder = 4
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
      object comboBoxV2: TcomboBoxV
        Left = 73
        Top = 8
        Width = 75
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Tnum = T_byte
        UpdateVarOnExit = False
      end
      object editNum2: TeditNum
        Left = 136
        Top = 167
        Width = 53
        Height = 21
        TabOrder = 2
        Tnum = T_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object editNum3: TeditNum
        Left = 136
        Top = 192
        Width = 53
        Height = 21
        TabOrder = 3
        Tnum = T_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object CheckBoxV1: TCheckBoxV
        Left = 7
        Top = 217
        Width = 182
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Invert signal:'
        TabOrder = 4
        UpdateVarOnToggle = False
      end
    end
  end
  object Button1: TButton
    Left = 110
    Top = 278
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 198
    Top = 278
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
