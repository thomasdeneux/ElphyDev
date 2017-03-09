object revPanel: TrevPanel
  Left = 350
  Top = 192
  BorderStyle = bsToolWindow
  Caption = 'revPanel'
  ClientHeight = 227
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 351
    Height = 227
    ActivePage = Pgeneral
    Align = alClient
    TabOrder = 0
    OnChange = pageControl1Change
    object Pgeneral: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 8
        Top = 10
        Width = 35
        Height = 13
        Caption = 'Evt file:'
      end
      object Label2: TLabel
        Left = 9
        Top = 37
        Width = 59
        Height = 13
        Caption = 'Data vector:'
      end
      object esEvtFile: TeditString
        Left = 51
        Top = 9
        Width = 158
        Height = 21
        TabOrder = 0
        len = 0
        UpdateVarOnExit = False
      end
      object BevtFile: TButton
        Left = 219
        Top = 9
        Width = 46
        Height = 21
        Caption = 'Choose'
        TabOrder = 1
        OnClick = BevtFileClick
      end
      object Bcalculate: TButton
        Left = 186
        Top = 172
        Width = 54
        Height = 21
        Caption = 'Calculate'
        TabOrder = 2
        OnClick = BcalculateClick
      end
      object cbDataVector: TcomboBoxV
        Left = 72
        Top = 34
        Width = 153
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnChange = cbDataVectorChange
        OnDropDown = cbDataVectorDropDown
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 59
        Width = 272
        Height = 75
        Caption = 'Time'
        TabOrder = 4
        object Label4: TLabel
          Left = 23
          Top = 17
          Width = 24
          Height = 13
          Caption = 'maxi:'
        end
        object Label7: TLabel
          Left = 28
          Top = 42
          Width = 15
          Height = 13
          Caption = 'dt0'
        end
        object enT2: TeditNum
          Left = 54
          Top = 15
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '100'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDt0: TeditNum
          Left = 54
          Top = 38
          Width = 73
          Height = 21
          TabOrder = 1
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
    object Pdisplay: TTabSheet
      Caption = 'Display'
      OnEnter = PdisplayEnter
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 343
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object PaintBox1: TPaintBox
          Left = 0
          Top = 0
          Width = 343
          Height = 21
          Align = alClient
          OnPaint = PaintBox1Paint
        end
      end
      object cbAutoScale: TCheckBoxV
        Left = 10
        Top = 175
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Autoscale'
        TabOrder = 1
        UpdateVarOnToggle = False
      end
      object GroupBox3: TGroupBox
        Left = 2
        Top = 25
        Width = 340
        Height = 58
        Caption = 'Time'
        TabOrder = 2
        object Lt: TLabel
          Left = 10
          Top = 14
          Width = 9
          Height = 13
          Caption = 't='
        end
        object Ldt: TLabel
          Left = 10
          Top = 31
          Width = 15
          Height = 13
          Caption = 'dt='
        end
        object LzupRaw: TLabel
          Left = 206
          Top = 16
          Width = 45
          Height = 13
          Caption = 'LzupRaw'
        end
        object sbT: TscrollbarV
          Left = 98
          Top = 13
          Width = 93
          Height = 16
          Max = 30000
          PageSize = 0
          TabOrder = 0
          Xmax = 1000.000000000000000000
          dxSmall = 1.000000000000000000
          dxLarge = 10.000000000000000000
          OnScrollV = sbTScrollV
        end
        object sbDT: TscrollbarV
          Left = 98
          Top = 32
          Width = 93
          Height = 16
          Max = 30000
          PageSize = 0
          TabOrder = 1
          Xmax = 1000.000000000000000000
          dxSmall = 1.000000000000000000
          dxLarge = 10.000000000000000000
          OnScrollV = sbDTScrollV
        end
      end
    end
    object Popti: TTabSheet
      Caption = 'Optimization'
      object Label3: TLabel
        Left = 17
        Top = 111
        Width = 50
        Height = 13
        Caption = 'Threshold:'
      end
      object GroupBox2: TGroupBox
        Left = 13
        Top = 12
        Width = 210
        Height = 84
        Caption = 'Results'
        TabOrder = 0
        object LNmoyen: TLabel
          Left = 15
          Top = 21
          Width = 14
          Height = 13
          Caption = 'N='
        end
        object LdeltaN: TLabel
          Left = 15
          Top = 38
          Width = 39
          Height = 13
          Caption = 'DeltaN='
        end
        object LzupOpt: TLabel
          Left = 16
          Top = 56
          Width = 25
          Height = 13
          Caption = 'Zup='
        end
      end
      object Button1: TButton
        Left = 17
        Top = 159
        Width = 68
        Height = 20
        Caption = 'Calculate'
        TabOrder = 1
        OnClick = Button1Click
      end
      object enSeuil: TeditNum
        Left = 78
        Top = 108
        Width = 121
        Height = 21
        TabOrder = 2
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbUseTh: TCheckBoxV
        Left = 16
        Top = 133
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Use threshold'
        TabOrder = 3
        UpdateVarOnToggle = False
      end
    end
  end
end
