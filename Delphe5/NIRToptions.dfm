object NiRTopt: TNiRTopt
  Left = 700
  Top = 385
  BorderStyle = bsDialog
  Caption = 'NI RT-Neuron options'
  ClientHeight = 336
  ClientWidth = 380
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
  object BOK: TButton
    Left = 119
    Top = 290
    Width = 53
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 187
    Top = 290
    Width = 53
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 12
    Width = 369
    Height = 41
    Caption = 'INTIME file'
    TabOrder = 2
    object Bexe: TBitBtn
      Left = 344
      Top = 15
      Width = 15
      Height = 15
      TabOrder = 0
      OnClick = BexeClick
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
    object EditExe: TEdit
      Left = 8
      Top = 15
      Width = 331
      Height = 21
      TabOrder = 1
      Text = 'EditExe'
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 64
    Width = 369
    Height = 41
    Caption = 'Original Neuron Exe File'
    TabOrder = 3
    object Bbin: TBitBtn
      Left = 344
      Top = 15
      Width = 15
      Height = 15
      TabOrder = 0
      OnClick = BbinClick
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
    object EditBin: TEdit
      Left = 8
      Top = 15
      Width = 331
      Height = 21
      TabOrder = 1
      Text = 'EditExe'
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 114
    Width = 369
    Height = 41
    Caption = 'Hoc file'
    TabOrder = 4
    object Bhoc: TBitBtn
      Left = 344
      Top = 15
      Width = 15
      Height = 15
      TabOrder = 0
      OnClick = BhocClick
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
    object EditHoc: TEdit
      Left = 8
      Top = 15
      Width = 331
      Height = 21
      TabOrder = 1
      Text = 'EditExe'
    end
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 164
    Width = 367
    Height = 101
    Caption = 'NI device'
    TabOrder = 5
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 58
      Height = 13
      Caption = 'Bus Number'
    end
    object Label2: TLabel
      Left = 16
      Top = 43
      Width = 74
      Height = 13
      Caption = 'Device Number'
    end
    object Label3: TLabel
      Left = 17
      Top = 68
      Width = 51
      Height = 13
      Caption = 'ADC mode'
    end
    object enBus: TeditNum
      Left = 101
      Top = 18
      Width = 60
      Height = 21
      TabOrder = 0
      Text = '0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDevice: TeditNum
      Left = 101
      Top = 41
      Width = 60
      Height = 21
      TabOrder = 1
      Text = '0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbAdcMode: TcomboBoxV
      Left = 101
      Top = 64
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'cbAdcMode'
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
  end
end
