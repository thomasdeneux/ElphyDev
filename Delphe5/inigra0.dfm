object initGraph: TinitGraph
  Left = 380
  Top = 156
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'New graph'
  ClientHeight = 282
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 10
    Width = 43
    Height = 13
    Caption = 'X vector:'
  end
  object Label2: TLabel
    Left = 15
    Top = 33
    Width = 43
    Height = 13
    Caption = 'Y vector:'
  end
  object Label3: TLabel
    Left = 15
    Top = 56
    Width = 58
    Height = 13
    Caption = 'Error vector:'
  end
  object BOK: TButton
    Left = 42
    Top = 230
    Width = 64
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 128
    Top = 230
    Width = 64
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 85
    Width = 220
    Height = 97
    Caption = 'Limits'
    TabOrder = 2
    object Label4: TLabel
      Left = 11
      Top = 18
      Width = 53
      Height = 13
      Caption = 'Start index:'
    end
    object Label5: TLabel
      Left = 11
      Top = 43
      Width = 50
      Height = 13
      Caption = 'End index:'
    end
    object ENi1: TeditNum
      Left = 119
      Top = 15
      Width = 93
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object ENi2: TeditNum
      Left = 119
      Top = 40
      Width = 93
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbAuto: TCheckBoxV
      Left = 10
      Top = 68
      Width = 122
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Automatic'
      TabOrder = 2
      OnClick = cbAutoClick
      UpdateVarOnToggle = False
    end
  end
  object enXdata: TEdit
    Left = 77
    Top = 7
    Width = 115
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '123'
  end
  object Bxdata: TBitBtn
    Tag = 1
    Left = 194
    Top = 9
    Width = 14
    Height = 14
    TabOrder = 4
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
  object Bydata: TBitBtn
    Tag = 2
    Left = 194
    Top = 31
    Width = 14
    Height = 14
    TabOrder = 5
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
    Left = 77
    Top = 29
    Width = 115
    Height = 21
    ReadOnly = True
    TabOrder = 6
  end
  object enSigData: TEdit
    Left = 77
    Top = 51
    Width = 115
    Height = 21
    ReadOnly = True
    TabOrder = 7
  end
  object BerrorData: TBitBtn
    Tag = 3
    Left = 194
    Top = 53
    Width = 14
    Height = 14
    TabOrder = 8
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
  object cbOwned: TCheckBoxV
    Left = 17
    Top = 192
    Width = 122
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Owned Vectors'
    TabOrder = 9
    OnClick = cbAutoClick
    UpdateVarOnToggle = False
  end
end
