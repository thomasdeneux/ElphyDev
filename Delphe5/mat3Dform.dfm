object Mat3Dcom: TMat3Dcom
  Left = 445
  Top = 296
  BorderStyle = bsToolWindow
  Caption = 'Mat3Dcom'
  ClientHeight = 262
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 19
    Top = 223
    Width = 27
    Height = 13
    Caption = 'Mode'
  end
  inline EdsD0: TEditScroll
    Left = 23
    Top = 8
    Width = 248
    Height = 30
    TabOrder = 0
    inherited Lb: TLabel
      Width = 14
      Caption = 'D0'
    end
  end
  inline EdsThetaX: TEditScroll
    Left = 23
    Top = 32
    Width = 248
    Height = 30
    TabOrder = 1
    inherited Lb: TLabel
      Width = 35
      Caption = 'ThetaX'
    end
  end
  inline EdsThetaZ: TEditScroll
    Left = 23
    Top = 55
    Width = 248
    Height = 30
    TabOrder = 2
    inherited Lb: TLabel
      Width = 35
      Caption = 'ThetaZ'
    end
  end
  inline EdsFov: TEditScroll
    Left = 23
    Top = 78
    Width = 248
    Height = 30
    TabOrder = 3
    inherited Lb: TLabel
      Width = 21
      Caption = 'FOV'
    end
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 110
    Width = 270
    Height = 92
    Caption = 'Amplitude'
    TabOrder = 4
    object Label2: TLabel
      Left = 10
      Top = 21
      Width = 23
      Height = 13
      Caption = 'Zmin'
    end
    object Label3: TLabel
      Left = 118
      Top = 21
      Width = 26
      Height = 13
      Caption = 'Zmax'
    end
    object Label1: TLabel
      Left = 40
      Top = 70
      Width = 22
      Height = 13
      Caption = 'Gain'
    end
    object Label4: TLabel
      Left = 151
      Top = 70
      Width = 28
      Height = 13
      Caption = 'Offset'
    end
    object enZmin: TeditNum
      Left = 37
      Top = 18
      Width = 73
      Height = 21
      TabOrder = 0
      Text = 'en'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enZmax: TeditNum
      Left = 146
      Top = 18
      Width = 73
      Height = 21
      TabOrder = 1
      Text = 'en'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object sbGain: TscrollbarV
      Left = 12
      Top = 50
      Width = 100
      Height = 17
      Max = 30000
      PageSize = 0
      TabOrder = 2
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = sbGainScrollV
    end
    object sbOffset: TscrollbarV
      Left = 125
      Top = 50
      Width = 100
      Height = 17
      Max = 30000
      PageSize = 0
      TabOrder = 3
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = sbOffsetScrollV
    end
    object Bapply: TButton
      Left = 227
      Top = 22
      Width = 34
      Height = 17
      Caption = 'Apply'
      TabOrder = 4
      OnClick = BapplyClick
    end
    object BcadrerX: TBitBtn
      Left = 233
      Top = 53
      Width = 15
      Height = 15
      TabOrder = 5
      OnClick = BcadrerXClick
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
  object cbMode3D: TcomboBoxV
    Left = 59
    Top = 220
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbMode3DChange
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
end
