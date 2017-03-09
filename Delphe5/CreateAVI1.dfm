object CreateAVIform: TCreateAVIform
  Left = 654
  Top = 349
  Width = 487
  Height = 200
  Caption = 'Create AVI file'
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
  object Lquality: TLabel
    Left = 248
    Top = 92
    Width = 60
    Height = 13
    Caption = 'JPEG quality'
  end
  object LNfactor: TLabel
    Left = 16
    Top = 93
    Width = 82
    Height = 13
    Caption = 'Reduction Factor'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 16
    Width = 465
    Height = 57
    Caption = 'File Name'
    TabOrder = 0
    object esFile: TEdit
      Left = 8
      Top = 20
      Width = 425
      Height = 21
      TabOrder = 0
    end
    object Bfile: TBitBtn
      Left = 440
      Top = 24
      Width = 16
      Height = 16
      TabOrder = 1
      OnClick = BfileClick
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
  object BOK: TButton
    Left = 141
    Top = 133
    Width = 75
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 257
    Top = 133
    Width = 75
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object enQuality: TeditNum
    Left = 333
    Top = 90
    Width = 81
    Height = 21
    TabOrder = 3
    Text = 'enQuality'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enNfactor: TeditNum
    Left = 120
    Top = 90
    Width = 81
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
