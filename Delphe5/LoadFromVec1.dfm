object LoadFromVecDlg: TLoadFromVecDlg
  Left = 333
  Top = 189
  BorderStyle = bsDialog
  Caption = 'Load data  from vector'
  ClientHeight = 404
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 7
    Width = 321
    Height = 270
    Caption = 'Choose a vector'
    TabOrder = 0
    inline SyslistView1: TSyslistView
      Left = 2
      Top = 15
      Width = 317
      Height = 253
      Align = alClient
      TabOrder = 0
      inherited TreeView1: TTreeView
        Width = 317
        Height = 223
      end
      inherited Panel1: TPanel
        Top = 223
        Width = 317
      end
    end
  end
  object PageControl1: TPageControl
    Left = 4
    Top = 283
    Width = 241
    Height = 114
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Copy'
      object Label6: TLabel
        Left = 16
        Top = 24
        Width = 168
        Height = 13
        Caption = 'Copy data with structure and scales'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Extract'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 99
        Height = 13
        Caption = 'extract data from x1='
      end
      object Label2: TLabel
        Left = 78
        Top = 30
        Width = 29
        Height = 13
        Caption = 'to x2='
      end
      object enX1: TeditNum
        Left = 116
        Top = 4
        Width = 93
        Height = 21
        TabOrder = 0
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enX2: TeditNum
        Left = 116
        Top = 26
        Width = 93
        Height = 21
        TabOrder = 1
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object bcadrerX1: TBitBtn
        Left = 212
        Top = 5
        Width = 15
        Height = 15
        TabOrder = 2
        OnClick = bcadrerX1Click
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
      object bCadrerX2: TBitBtn
        Left = 212
        Top = 29
        Width = 15
        Height = 15
        TabOrder = 3
        OnClick = bCadrerX2Click
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
    object TabSheet3: TTabSheet
      Caption = 'Move'
      ImageIndex = 2
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 99
        Height = 13
        Caption = 'extract data from x1='
      end
      object Label4: TLabel
        Left = 78
        Top = 30
        Width = 29
        Height = 13
        Caption = 'to x2='
      end
      object Label5: TLabel
        Left = 26
        Top = 56
        Width = 81
        Height = 13
        Caption = 'Send data to xd='
      end
      object enMoveX1: TeditNum
        Left = 116
        Top = 4
        Width = 93
        Height = 21
        TabOrder = 0
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object McadrerX1: TBitBtn
        Left = 212
        Top = 5
        Width = 15
        Height = 15
        TabOrder = 1
        OnClick = McadrerX1Click
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
      object enMoveX2: TeditNum
        Left = 116
        Top = 26
        Width = 93
        Height = 21
        TabOrder = 2
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object McadrerX2: TBitBtn
        Left = 212
        Top = 29
        Width = 15
        Height = 15
        TabOrder = 3
        OnClick = McadrerX2Click
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
      object enXD: TeditNum
        Left = 117
        Top = 53
        Width = 93
        Height = 21
        TabOrder = 4
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Append'
      ImageIndex = 3
      object Label7: TLabel
        Left = 8
        Top = 8
        Width = 90
        Height = 13
        Caption = 'copy data from x1='
      end
      object Label8: TLabel
        Left = 70
        Top = 30
        Width = 29
        Height = 13
        Caption = 'to x2='
      end
      object Label9: TLabel
        Left = 10
        Top = 54
        Width = 111
        Height = 13
        Caption = 'at the end of the vector'
      end
      object enX1a: TeditNum
        Left = 116
        Top = 4
        Width = 93
        Height = 21
        TabOrder = 0
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object BitBtn1: TBitBtn
        Left = 212
        Top = 5
        Width = 15
        Height = 15
        TabOrder = 1
        OnClick = BitBtn1Click
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
      object enX2a: TeditNum
        Left = 116
        Top = 26
        Width = 93
        Height = 21
        TabOrder = 2
        Text = 'enX1'
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object BitBtn2: TBitBtn
        Left = 212
        Top = 29
        Width = 15
        Height = 15
        TabOrder = 3
        OnClick = BitBtn2Click
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
  object Bok: TButton
    Left = 255
    Top = 334
    Width = 63
    Height = 20
    Caption = 'OK'
    TabOrder = 2
    OnClick = BokClick
  end
  object Bcancel: TButton
    Left = 255
    Top = 362
    Width = 63
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
