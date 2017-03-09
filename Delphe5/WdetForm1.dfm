inherited WinDetPanel: TWinDetPanel
  Left = 310
  Top = 204
  Height = 471
  Caption = 'WinDetPanel'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PaintBox0: TPaintBox
    Height = 208
  end
  inherited Panel1: TPanel
    Top = 208
    Height = 209
    inherited ShapeExe: TShape
      Left = 184
      Top = 153
    end
    inherited cbMode: TcomboBoxV
      TabOrder = 6
    end
    inherited enInhib: TeditNum
      TabOrder = 15
    end
    inherited Bexecute: TButton
      Left = 9
      Top = 146
    end
    inherited PnbDet: TPanel
      Left = 92
      Top = 146
      Width = 86
    end
    object GroupBox1: TGroupBox
      Left = 214
      Top = 106
      Width = 219
      Height = 97
      Caption = 'Cursors'
      TabOrder = 3
      object Label8: TLabel
        Left = 10
        Top = 75
        Width = 59
        Height = 13
        Caption = 'Ref. position'
      end
      object Bcr1: TButton
        Tag = 1
        Left = 7
        Top = 18
        Width = 17
        Height = 17
        Caption = '1'
        TabOrder = 0
        OnClick = Bcr10Click
      end
      object Bcr2: TButton
        Tag = 2
        Left = 25
        Top = 18
        Width = 17
        Height = 17
        Caption = '2'
        TabOrder = 1
        OnClick = Bcr10Click
      end
      object Bcr3: TButton
        Tag = 3
        Left = 43
        Top = 18
        Width = 17
        Height = 17
        Caption = '3'
        TabOrder = 2
        OnClick = Bcr10Click
      end
      object Bcr4: TButton
        Tag = 4
        Left = 61
        Top = 18
        Width = 17
        Height = 17
        Caption = '4'
        TabOrder = 3
        OnClick = Bcr10Click
      end
      object Bcr8: TButton
        Tag = 8
        Left = 133
        Top = 18
        Width = 17
        Height = 17
        Caption = '8'
        TabOrder = 4
        OnClick = Bcr10Click
      end
      object Bcr7: TButton
        Tag = 7
        Left = 115
        Top = 18
        Width = 17
        Height = 17
        Caption = '7'
        TabOrder = 5
        OnClick = Bcr10Click
      end
      object Bcr6: TButton
        Tag = 6
        Left = 97
        Top = 18
        Width = 17
        Height = 17
        Caption = '6'
        TabOrder = 6
        OnClick = Bcr10Click
      end
      object Bcr5: TButton
        Tag = 5
        Left = 79
        Top = 18
        Width = 17
        Height = 17
        Caption = '5'
        TabOrder = 7
        OnClick = Bcr10Click
      end
      object Bcr10: TButton
        Tag = 10
        Left = 169
        Top = 18
        Width = 17
        Height = 17
        Caption = '10'
        TabOrder = 8
        OnClick = Bcr10Click
      end
      object Bcr9: TButton
        Tag = 9
        Left = 151
        Top = 18
        Width = 17
        Height = 17
        Caption = '9'
        TabOrder = 9
        OnClick = Bcr10Click
      end
      object Bcadrer: TBitBtn
        Left = 195
        Top = 19
        Width = 15
        Height = 15
        TabOrder = 10
        OnClick = BcadrerClick
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
      object cbAbsolute: TCheckBoxV
        Left = 8
        Top = 54
        Width = 99
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Absolute'
        TabOrder = 11
        UpdateVarOnToggle = False
      end
      object enRefPos: TeditNum
        Left = 94
        Top = 71
        Width = 76
        Height = 21
        TabOrder = 12
        Max = 255.000000000000000000
        UpdateVarOnExit = True
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbActive1: TCheckBoxV
        Left = 8
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 13
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object CbActive2: TCheckBoxV
        Left = 26
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 14
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive3: TCheckBoxV
        Left = 44
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 15
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive4: TCheckBoxV
        Left = 62
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 16
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive5: TCheckBoxV
        Left = 80
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 17
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive6: TCheckBoxV
        Left = 98
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 18
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive7: TCheckBoxV
        Left = 116
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 19
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive8: TCheckBoxV
        Left = 134
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 20
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive9: TCheckBoxV
        Left = 152
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 21
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
      object cbActive10: TCheckBoxV
        Left = 171
        Top = 35
        Width = 15
        Height = 16
        TabOrder = 22
        OnClick = cbActive1Click
        UpdateVarOnToggle = False
      end
    end
  end
  inherited MainMenu1: TMainMenu
    Left = 31
    Top = 467
  end
end
