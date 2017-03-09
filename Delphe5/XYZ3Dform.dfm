object XYZplot3Dcom: TXYZplot3Dcom
  Left = 651
  Top = 294
  BorderStyle = bsToolWindow
  Caption = 'XYZplot3Dcom'
  ClientHeight = 334
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
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
      Width = 36
      Caption = 'ThetaD'
    end
  end
  inline EdsThetaZ: TEditScroll
    Left = 23
    Top = 55
    Width = 248
    Height = 30
    TabOrder = 2
    inherited Lb: TLabel
      Width = 23
      Caption = 'PhiD'
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
  object BinitD0: TBitBtn
    Left = 253
    Top = 10
    Width = 15
    Height = 15
    TabOrder = 4
    OnClick = BinitD0Click
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 154
    Width = 344
    Height = 180
    Align = alBottom
    Caption = 'Polylines'
    TabOrder = 5
    object Label1: TLabel
      Left = 32
      Top = 18
      Width = 37
      Height = 13
      Caption = 'Number'
    end
    object Lnbpts: TLabel
      Left = 192
      Top = 18
      Width = 67
      Height = 13
      Caption = '200000 points'
    end
    object enNum: TeditNum
      Left = 82
      Top = 16
      Width = 65
      Height = 21
      TabOrder = 0
      Text = '0'
      OnChange = enNumChange
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object UpDown1: TUpDown
      Left = 147
      Top = 16
      Width = 17
      Height = 21
      TabOrder = 1
      Wrap = True
      OnClick = UpDown1Click
    end
    object Panel1: TPanel
      Left = 4
      Top = 40
      Width = 335
      Height = 136
      TabOrder = 2
      object Label2: TLabel
        Left = 9
        Top = 24
        Width = 27
        Height = 13
        Caption = 'Mode'
      end
      object Label3: TLabel
        Left = 177
        Top = 25
        Width = 57
        Height = 13
        Caption = 'Symbol Size'
      end
      object Label4: TLabel
        Left = 177
        Top = 52
        Width = 66
        Height = 13
        Caption = 'Symbol Size 2'
      end
      object cbMode: TcomboBoxV
        Left = 49
        Top = 22
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = 'cbMode'
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      inline ColFrame1: TColFrame
        Left = 10
        Top = 49
        Width = 145
        Height = 26
        TabOrder = 1
        inherited Button: TButton
          Left = 2
          Caption = 'Color'
        end
        inherited Panel: TPanel
          Width = 81
        end
      end
      object enSymbSize: TeditNum
        Left = 248
        Top = 22
        Width = 79
        Height = 21
        TabOrder = 2
        Text = '1.2'
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enSymbSize2: TeditNum
        Left = 248
        Top = 49
        Width = 79
        Height = 21
        TabOrder = 3
        Text = '1.2'
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      inline EsTheta: TEditScroll
        Left = 10
        Top = 80
        Width = 248
        Height = 30
        TabOrder = 4
        inherited Lb: TLabel
          Width = 28
          Caption = 'Theta'
        end
      end
      inline EsPhi: TEditScroll
        Left = 9
        Top = 106
        Width = 248
        Height = 30
        TabOrder = 5
        inherited Lb: TLabel
          Width = 15
          Caption = 'Phi'
        end
      end
    end
  end
  object cbScaling3D: TCheckBoxV
    Left = 24
    Top = 107
    Width = 144
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Scaling 3D'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
  object cbOrtho: TCheckBoxV
    Left = 24
    Top = 125
    Width = 144
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Orthographic Projection'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
end
