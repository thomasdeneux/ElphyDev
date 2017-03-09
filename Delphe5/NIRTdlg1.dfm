object NIRTparams: TNIRTparams
  Left = 470
  Top = 216
  BorderStyle = bsDialog
  Caption = 'NIRTparams'
  ClientHeight = 620
  ClientWidth = 639
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 9
    Width = 625
    Height = 160
    Caption = 'Analog Inputs'
    TabOrder = 0
    object TabNumAdc: TTabControl
      Left = 2
      Top = 15
      Width = 621
      Height = 143
      TabOrder = 0
      Tabs.Strings = (
        '0'
        '1'
        '2 '
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15')
      TabIndex = 0
      TabWidth = 22
      OnChange = TabNumAdcChange
      object Label23: TLabel
        Left = 12
        Top = 35
        Width = 66
        Height = 13
        Caption = 'Symbol name:'
      end
      object GroupBox6: TGroupBox
        Left = 276
        Top = 28
        Width = 318
        Height = 107
        Caption = 'Vertical scaling factors'
        TabOrder = 0
        object Label32: TLabel
          Left = 8
          Top = 53
          Width = 8
          Height = 13
          Caption = 'j='
        end
        object Label33: TLabel
          Left = 108
          Top = 55
          Width = 85
          Height = 13
          Caption = 'Corresponds to y='
        end
        object Label34: TLabel
          Left = 8
          Top = 78
          Width = 8
          Height = 13
          Caption = 'j='
        end
        object Label35: TLabel
          Left = 107
          Top = 79
          Width = 85
          Height = 13
          Caption = 'Corresponds to y='
        end
        object Label36: TLabel
          Left = 7
          Top = 25
          Width = 27
          Height = 13
          Caption = 'Units:'
        end
        object enJ1: TeditNum
          Left = 40
          Top = 51
          Width = 58
          Height = 21
          TabOrder = 0
          Text = '1'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enY1: TeditNum
          Left = 198
          Top = 51
          Width = 87
          Height = 21
          TabOrder = 1
          Text = '1123456789'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enJ2: TeditNum
          Left = 40
          Top = 75
          Width = 58
          Height = 21
          TabOrder = 2
          Text = '2'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enY2: TeditNum
          Left = 198
          Top = 75
          Width = 87
          Height = 21
          TabOrder = 3
          Text = '1123456789'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object esUnits: TeditString
          Left = 47
          Top = 22
          Width = 88
          Height = 21
          TabOrder = 4
          Text = 'mV'
          len = 0
          UpdateVarOnExit = False
        end
      end
      object esAdcSymbol: TeditString
        Left = 10
        Top = 51
        Width = 185
        Height = 21
        TabOrder = 1
        Text = 'esNrnSymbol'
        len = 0
        UpdateVarOnExit = False
      end
      object BadcSymbol: TBitBtn
        Tag = 100
        Left = 198
        Top = 55
        Width = 14
        Height = 15
        TabOrder = 2
        OnClick = BadcSymbolClick
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
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 181
    Width = 625
    Height = 169
    Caption = 'Analog Outputs'
    TabOrder = 1
    object TabNumDac: TTabControl
      Left = 2
      Top = 15
      Width = 621
      Height = 152
      Align = alClient
      TabOrder = 0
      Tabs.Strings = (
        '0'
        '1 ')
      TabIndex = 0
      TabWidth = 22
      OnChange = TabNumDacChange
      object Label2: TLabel
        Left = 12
        Top = 35
        Width = 66
        Height = 13
        Caption = 'Symbol name:'
      end
      object Label10: TLabel
        Left = 10
        Top = 81
        Width = 66
        Height = 13
        Caption = 'Holding Value'
      end
      object GroupBox3: TGroupBox
        Left = 276
        Top = 28
        Width = 318
        Height = 107
        Caption = 'Vertical scaling factors'
        TabOrder = 0
        object Label3: TLabel
          Left = 8
          Top = 53
          Width = 8
          Height = 13
          Caption = 'j='
        end
        object Label4: TLabel
          Left = 108
          Top = 55
          Width = 85
          Height = 13
          Caption = 'Corresponds to y='
        end
        object Label5: TLabel
          Left = 8
          Top = 78
          Width = 8
          Height = 13
          Caption = 'j='
        end
        object Label6: TLabel
          Left = 107
          Top = 79
          Width = 85
          Height = 13
          Caption = 'Corresponds to y='
        end
        object Label7: TLabel
          Left = 7
          Top = 25
          Width = 27
          Height = 13
          Caption = 'Units:'
        end
        object enDacJ1: TeditNum
          Left = 40
          Top = 51
          Width = 58
          Height = 21
          TabOrder = 0
          Text = '1'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDacY1: TeditNum
          Left = 198
          Top = 51
          Width = 87
          Height = 21
          TabOrder = 1
          Text = '1123456789'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDacJ2: TeditNum
          Left = 40
          Top = 75
          Width = 58
          Height = 21
          TabOrder = 2
          Text = '2'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDacY2: TeditNum
          Left = 198
          Top = 75
          Width = 87
          Height = 21
          TabOrder = 3
          Text = '1123456789'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object esDacUnits: TeditString
          Left = 47
          Top = 22
          Width = 88
          Height = 21
          TabOrder = 4
          Text = 'mV'
          len = 0
          UpdateVarOnExit = False
        end
      end
      object esDacSymbol: TeditString
        Left = 10
        Top = 51
        Width = 185
        Height = 21
        TabOrder = 1
        Text = 'esNrnSymbol'
        len = 0
        UpdateVarOnExit = False
      end
      object BdacSymbol: TBitBtn
        Tag = 200
        Left = 199
        Top = 55
        Width = 14
        Height = 15
        TabOrder = 2
        OnClick = BadcSymbolClick
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
      object enDacEnd: TeditNum
        Left = 88
        Top = 79
        Width = 104
        Height = 21
        TabOrder = 3
        Text = '0'
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbUseHoldingValue: TCheckBoxV
        Left = 8
        Top = 105
        Width = 184
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Use Holding Value'
        TabOrder = 4
        UpdateVarOnToggle = False
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 357
    Width = 625
    Height = 153
    Caption = 'Digital IO'
    TabOrder = 2
    object Label1: TLabel
      Left = 71
      Top = 20
      Width = 66
      Height = 13
      Caption = 'Symbol name:'
    end
    object Label12: TLabel
      Left = 246
      Top = 20
      Width = 65
      Height = 13
      Caption = 'Used as input'
    end
    object Label8: TLabel
      Left = 380
      Top = 20
      Width = 66
      Height = 13
      Caption = 'Symbol name:'
    end
    object Label9: TLabel
      Left = 546
      Top = 20
      Width = 65
      Height = 13
      Caption = 'Used as input'
    end
    object Panel1: TPanel
      Left = 17
      Top = 34
      Width = 288
      Height = 23
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol0: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol0: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel4: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig0: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel5: TPanel
      Left = 17
      Top = 57
      Width = 288
      Height = 23
      TabOrder = 1
      object Panel6: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol1: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol1: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel8: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig1: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel9: TPanel
      Left = 17
      Top = 80
      Width = 288
      Height = 23
      TabOrder = 2
      object Panel10: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel11: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol2: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol2: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel12: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig2: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel13: TPanel
      Left = 17
      Top = 103
      Width = 288
      Height = 23
      TabOrder = 3
      object Panel14: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel15: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol3: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol3: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel16: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig3: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel17: TPanel
      Left = 318
      Top = 34
      Width = 288
      Height = 23
      TabOrder = 4
      object Panel18: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel19: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol4: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol4: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel20: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig4: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel21: TPanel
      Left = 318
      Top = 57
      Width = 288
      Height = 23
      TabOrder = 5
      object Panel22: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel23: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol5: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol5: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel24: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig5: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel25: TPanel
      Left = 318
      Top = 80
      Width = 288
      Height = 23
      TabOrder = 6
      object Panel26: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel27: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol6: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol6: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel28: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig6: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
    object Panel29: TPanel
      Left = 318
      Top = 103
      Width = 288
      Height = 23
      TabOrder = 7
      object Panel30: TPanel
        Left = 1
        Top = 1
        Width = 27
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Panel31: TPanel
        Left = 28
        Top = 1
        Width = 201
        Height = 21
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
        object esDigiSymbol7: TeditString
          Left = 4
          Top = 2
          Width = 169
          Height = 21
          TabOrder = 0
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BdigiSymbol7: TBitBtn
          Left = 176
          Top = 4
          Width = 14
          Height = 15
          TabOrder = 1
          OnClick = BadcSymbolClick
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
      object Panel32: TPanel
        Left = 229
        Top = 1
        Width = 58
        Height = 21
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object cbDig7: TCheckBoxV
          Left = 20
          Top = 2
          Width = 17
          Height = 17
          TabOrder = 0
          UpdateVarOnToggle = False
        end
      end
    end
  end
  object Bok: TButton
    Left = 221
    Top = 576
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object Bcancel: TButton
    Left = 301
    Top = 576
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 517
    Width = 625
    Height = 49
    Caption = 'Neuron Simulator'
    TabOrder = 5
    object cbFadvance: TCheckBoxV
      Left = 22
      Top = 22
      Width = 97
      Height = 17
      Caption = 'Call Fadvance'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
  end
end
