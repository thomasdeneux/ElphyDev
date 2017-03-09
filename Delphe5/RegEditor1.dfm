object RegEditor: TRegEditor
  Left = 650
  Top = 258
  Width = 684
  Height = 521
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'RegEditor'
  Color = clWhite
  Constraints.MinHeight = 400
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox0: TPaintBox
    Left = 0
    Top = 0
    Width = 410
    Height = 457
    Align = alClient
    Color = clBlack
    ParentColor = False
    OnDblClick = PaintBox0DblClick
    OnEndDrag = PaintBox0EndDrag
    OnMouseDown = PaintBox0MouseDown
    OnMouseMove = PaintBox0MouseMove
    OnMouseUp = PaintBox0MouseUp
    OnPaint = PaintBox0Paint
  end
  object Panel1: TPanel
    Left = 410
    Top = 0
    Width = 16
    Height = 457
    Align = alRight
    TabOrder = 0
    object scrollbarV: TscrollbarV
      Left = 1
      Top = 1
      Width = 14
      Height = 455
      Align = alClient
      Kind = sbVertical
      Max = 30000
      PageSize = 0
      TabOrder = 0
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = scrollbarVScrollV
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 457
    Width = 676
    Height = 16
    Align = alBottom
    TabOrder = 1
    object PanelMouse: TPanel
      Left = 465
      Top = 1
      Width = 210
      Height = 14
      Align = alRight
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 449
      Top = 1
      Width = 16
      Height = 14
      Align = alRight
      TabOrder = 1
      object Bcadrer: TBitBtn
        Left = 1
        Top = -1
        Width = 15
        Height = 15
        TabOrder = 0
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
    end
    object scrollbarH: TscrollbarV
      Left = 1
      Top = 1
      Width = 448
      Height = 14
      Align = alClient
      Max = 30000
      PageSize = 0
      TabOrder = 2
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = scrollbarHScrollV
    end
  end
  object PanelRight: TPanel
    Left = 426
    Top = 0
    Width = 250
    Height = 457
    Align = alRight
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 248
      Height = 455
      ActivePage = TabFilters
      Align = alClient
      TabOrder = 0
      object TabScales: TTabSheet
        Caption = 'Axis'
        ImageIndex = 3
        object GroupBox4: TGroupBox
          Left = 3
          Top = 10
          Width = 235
          Height = 72
          Caption = 'Origin'
          TabOrder = 0
          inline EsOriginX: TEditScroll
            Left = 11
            Top = 15
            Width = 213
            Height = 24
            TabOrder = 0
            inherited Lb: TLabel
              Width = 18
              Caption = 'xpix'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
          inline EsOriginY: TEditScroll
            Left = 11
            Top = 40
            Width = 213
            Height = 24
            TabOrder = 1
            inherited Lb: TLabel
              Width = 18
              Caption = 'ypix'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
        end
        object GroupBox5: TGroupBox
          Left = 3
          Top = 89
          Width = 235
          Height = 82
          Caption = 'X axis'
          TabOrder = 1
          object Label1: TLabel
            Left = 43
            Top = 22
            Width = 116
            Height = 13
            Caption = 'pixels correspond to Dx='
          end
          object Label2: TLabel
            Left = 8
            Top = 50
            Width = 24
            Height = 13
            Caption = 'Units'
          end
          object enXaxisPix: TeditNum
            Left = 6
            Top = 19
            Width = 33
            Height = 21
            TabOrder = 0
            Text = '512'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enXaxisDx: TeditNum
            Left = 167
            Top = 19
            Width = 61
            Height = 21
            TabOrder = 1
            Text = '20.000'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object esXaxisUnits: TeditString
            Left = 44
            Top = 47
            Width = 88
            Height = 21
            TabOrder = 2
            Text = 'esXaxisUnits'
            len = 0
            UpdateVarOnExit = False
          end
        end
        object GroupBox6: TGroupBox
          Left = 3
          Top = 176
          Width = 235
          Height = 82
          Caption = 'Y axis'
          TabOrder = 2
          object Label3: TLabel
            Left = 43
            Top = 22
            Width = 116
            Height = 13
            Caption = 'pixels correspond to Dy='
          end
          object Label4: TLabel
            Left = 8
            Top = 50
            Width = 24
            Height = 13
            Caption = 'Units'
          end
          object enYaxisPix: TeditNum
            Left = 6
            Top = 19
            Width = 33
            Height = 21
            TabOrder = 0
            Text = '512'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enYaxisDy: TeditNum
            Left = 167
            Top = 19
            Width = 61
            Height = 21
            TabOrder = 1
            Text = '20.000'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object esYaxisUnits: TeditString
            Left = 44
            Top = 47
            Width = 88
            Height = 21
            TabOrder = 2
            Text = 'editString1'
            len = 0
            UpdateVarOnExit = False
          end
        end
      end
      object TabCoo: TTabSheet
        Caption = 'Coo'
        ImageIndex = 1
        object PanelX: TPanel
          Left = 5
          Top = 9
          Width = 210
          Height = 22
          BevelOuter = bvLowered
          TabOrder = 0
          object LG0: TLabel
            Left = 4
            Top = 3
            Width = 47
            Height = 13
            Caption = 'G0=1.000'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object SBG0: TscrollbarV
            Left = 95
            Top = 3
            Width = 78
            Height = 16
            Max = 30000
            PageSize = 0
            TabOrder = 0
            Xmax = 1000.000000000000000000
            dxSmall = 0.100000000000000000
            dxLarge = 1.000000000000000000
            OnScrollV = SBG0ScrollV
          end
          object BautoG0: TBitBtn
            Left = 177
            Top = 3
            Width = 15
            Height = 15
            TabOrder = 1
            OnClick = BautoG0Click
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
        object PanelZ: TPanel
          Left = 5
          Top = 43
          Width = 210
          Height = 55
          BevelOuter = bvLowered
          TabOrder = 1
          object BautoZ: TBitBtn
            Left = 177
            Top = 16
            Width = 15
            Height = 15
            TabOrder = 0
            OnClick = BautoZClick
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
          inline ESCzmin: TEditScroll
            Left = 5
            Top = 5
            Width = 172
            Height = 22
            TabOrder = 1
            inherited Lb: TLabel
              Left = 0
              Width = 23
              Caption = 'Zmin'
            end
            inherited en: TeditNum
              Left = 32
              Width = 49
              Text = '78'
            end
            inherited sb: TscrollbarV
              Left = 89
              Width = 81
              Height = 16
            end
          end
          inline ESCZmax: TEditScroll
            Left = 5
            Top = 26
            Width = 172
            Height = 22
            TabOrder = 2
            inherited Lb: TLabel
              Left = 0
              Width = 26
              Caption = 'Zmax'
            end
            inherited en: TeditNum
              Left = 32
              Width = 49
              Text = '78'
            end
            inherited sb: TscrollbarV
              Left = 89
              Width = 81
              Height = 16
            end
          end
        end
        object GroupOIseq: TGroupBox
          Left = 4
          Top = 107
          Width = 211
          Height = 54
          Caption = 'Frame'
          TabOrder = 2
          object Lindex1: TLabel
            Left = 5
            Top = 17
            Width = 44
            Height = 13
            Caption = 'Index = 1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Lindex2: TLabel
            Left = 6
            Top = 33
            Width = 42
            Height = 13
            Caption = 't = 1.000'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object sbindex: TscrollbarV
            Left = 96
            Top = 17
            Width = 78
            Height = 16
            Max = 30000
            PageSize = 0
            TabOrder = 0
            Xmax = 1000.000000000000000000
            dxSmall = 1.000000000000000000
            dxLarge = 10.000000000000000000
            OnScrollV = sbindexScrollV
          end
        end
        object PanelPCL: TPanel
          Left = 5
          Top = 172
          Width = 220
          Height = 141
          BevelOuter = bvLowered
          TabOrder = 3
          object LNframe: TLabel
            Left = 6
            Top = 88
            Width = 60
            Height = 13
            Caption = 'Frame Count'
          end
          object BitBtn1: TBitBtn
            Left = 199
            Top = 33
            Width = 15
            Height = 15
            TabOrder = 0
            OnClick = BautoZClick
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
          inline EscBinX: TEditScroll
            Left = 5
            Top = 31
            Width = 188
            Height = 22
            TabOrder = 1
            inherited Lb: TLabel
              Left = 0
              Width = 22
              Caption = 'BinX'
            end
            inherited en: TeditNum
              Left = 50
              Width = 49
              Text = '78'
            end
            inherited sb: TscrollbarV
              Left = 107
              Width = 81
              Height = 16
            end
          end
          inline EscBinY: TEditScroll
            Left = 5
            Top = 52
            Width = 193
            Height = 22
            TabOrder = 2
            inherited Lb: TLabel
              Left = 0
              Width = 22
              Caption = 'BinY'
            end
            inherited en: TeditNum
              Left = 50
              Width = 49
              Text = '78'
            end
            inherited sb: TscrollbarV
              Left = 107
              Width = 81
              Height = 16
            end
          end
          inline EscBinT: TEditScroll
            Left = 5
            Top = 10
            Width = 192
            Height = 22
            TabOrder = 3
            OnExit = EscBinTExit
            inherited Lb: TLabel
              Left = 0
              Width = 44
              Caption = 'BinT (ms)'
            end
            inherited en: TeditNum
              Left = 50
              Width = 49
              Text = '78'
            end
            inherited sb: TscrollbarV
              Left = 107
              Width = 81
              Height = 16
            end
          end
          object enNframe: TeditNum
            Left = 83
            Top = 84
            Width = 93
            Height = 21
            TabOrder = 4
            Text = 'enNframe'
            OnExit = enNframeExit
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object cbNoOverlap: TCheckBoxV
            Left = 5
            Top = 112
            Width = 91
            Height = 17
            Alignment = taLeftJustify
            Caption = 'No Overlap'
            TabOrder = 5
            OnClick = cbNoOverlapClick
            UpdateVarOnToggle = False
          end
        end
      end
      object TabRegions: TTabSheet
        Caption = 'Regions'
        object GBdisplay: TGroupBox
          Left = 5
          Top = 10
          Width = 195
          Height = 233
          TabOrder = 0
          object cbDisplayRegions: TCheckBoxV
            Left = 16
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Show regions'
            TabOrder = 0
            OnClick = cbDisplayRegionsClick
            UpdateVarOnToggle = True
          end
          object cbDisplayPixels: TCheckBoxV
            Left = 16
            Top = 32
            Width = 97
            Height = 17
            Caption = 'Show pixels'
            TabOrder = 1
            OnClick = cbDisplayPixelsClick
            UpdateVarOnToggle = True
          end
          object PregionColor: TPanel
            Left = 141
            Top = 52
            Width = 29
            Height = 20
            TabOrder = 2
          end
          object BregionColor: TButton
            Left = 17
            Top = 52
            Width = 112
            Height = 20
            Caption = 'Current region color'
            TabOrder = 3
            OnClick = BregionColorClick
          end
          object Panel3: TPanel
            Left = 3
            Top = 184
            Width = 187
            Height = 33
            BevelOuter = bvLowered
            TabOrder = 4
            object Brectangle: TSpeedButton
              Left = 4
              Top = 4
              Width = 25
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Glyph.Data = {
                96010000424D9601000000000000760000002800000018000000180000000100
                0400000000002001000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888800000000000000000
                0888888088888888888888880888888088888888888888880888888088888888
                8888888808888880888888888888888808888880888888888888888808888880
                8888888888888888088888808888888888888888088888808888888888888888
                0888888088888888888888880888888088888888888888880888888088888888
                8888888808888880888888888888888808888880000000000000000008888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888}
              OnClick = BcircleClick
            end
            object Bcircle: TSpeedButton
              Left = 32
              Top = 4
              Width = 25
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Glyph.Data = {
                96010000424D9601000000000000760000002800000018000000180000000100
                0400000000002001000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
                8888888888888888888888888888888888888888888888000088888888888888
                8888008888008888888888888800888888880088888888888088888888888808
                8888888880888888888888088888888808888888888888808888888808888888
                8888888088888880888888888888888808888880888888888888888808888880
                8888888888888888088888808888888888888888088888808888888888888888
                0888888088888888888888880888888808888888888888808888888808888888
                8888888088888888808888888888880888888888808888888888880888888888
                8800888888880088888888888888008888008888888888888888880000888888
                8888888888888888888888888888888888888888888888888888}
              OnClick = BcircleClick
            end
            object Bpolygon: TSpeedButton
              Left = 60
              Top = 4
              Width = 25
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Glyph.Data = {
                96010000424D9601000000000000760000002800000018000000180000000100
                0400000000002001000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888800000000000000888888888808888888888880888888888808888888
                8888808888888888808888888888808888888888808888800000008888888888
                8088888808888888888888888808888880888888888888888808888880888888
                8888888888808888880888888888888888808888880888888888888888880888
                8880888888888888888808888880888888888888888800000000088888888888
                8888888888888888888888888888888888888888888888888888888888888888
                8888888888888888888888888888888888888888888888888888}
              OnClick = BcircleClick
            end
            object Bselect: TSpeedButton
              Left = 88
              Top = 4
              Width = 25
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000120B0000120B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                33333333333333333333333333333333333333FF333333333333370733333333
                33333777F33333333333309073333333333337F77F3333F33333370907333733
                3333377F77F337F3333333709073003333333377F77F77F33333333709009033
                333333377F77373F33333333709999033333333377F3337F3333333330999903
                3333333337333373F333333309999990333333337FF33337F333333700999990
                33333337773FF3373F333333330099990333333333773FF37F33333333330099
                033333333333773F73F3333333333300903333333333337737F3333333333333
                0033333333333333773333333333333333333333333333333333}
              NumGlyphs = 2
              OnClick = BcircleClick
            end
            object Btrajectory: TSpeedButton
              Left = 117
              Top = 4
              Width = 25
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Glyph.Data = {
                F6000000424DF600000000000000760000002800000010000000100000000100
                0400000000008000000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFF00FFFFFFFFFFFFFFF00FFFFF
                FFFFFFFFFF00FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFF
                FFFFFFFFFFF0FFFFFFFFFFFFFFF00FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF00FF
                FFFFFFFFFFFFF00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              OnClick = BcircleClick
            end
            object BsmartRect: TSpeedButton
              Left = 146
              Top = 4
              Width = 25
              Height = 25
              AllowAllUp = True
              GroupIndex = 1
              Glyph.Data = {
                36080000424D3608000000000000360400002800000020000000200000000100
                0800000000000004000000000000000000000001000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                A6000020400000206000002080000020A0000020C0000020E000004000000040
                20000040400000406000004080000040A0000040C0000040E000006000000060
                20000060400000606000006080000060A0000060C0000060E000008000000080
                20000080400000806000008080000080A0000080C0000080E00000A0000000A0
                200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
                200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
                200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
                20004000400040006000400080004000A0004000C0004000E000402000004020
                20004020400040206000402080004020A0004020C0004020E000404000004040
                20004040400040406000404080004040A0004040C0004040E000406000004060
                20004060400040606000406080004060A0004060C0004060E000408000004080
                20004080400040806000408080004080A0004080C0004080E00040A0000040A0
                200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
                200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
                200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
                20008000400080006000800080008000A0008000C0008000E000802000008020
                20008020400080206000802080008020A0008020C0008020E000804000008040
                20008040400080406000804080008040A0008040C0008040E000806000008060
                20008060400080606000806080008060A0008060C0008060E000808000008080
                20008080400080806000808080008080A0008080C0008080E00080A0000080A0
                200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
                200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
                200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
                2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
                2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
                2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
                2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
                2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
                2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
                2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070700000707070707070707070707070707070707070707
                0707070707070707070000000007070707070707070707070707070707070707
                0707070707070707000007070000070707070707070707070707070707070707
                0707070707070700000707070700000707070707070707070707070707070707
                0707070707070000070707070707000007070707070707070707070707070707
                0707070707000007070707070707070000070707070707070707070707070707
                0707070700000707070707070707070700000707070707070707070707070707
                0707070000070707070707070707070707000007070707070707070707070707
                0707000007070707070707070707070707070000070707070707070707070707
                0700000707070707070707070707070707070000070707070707070707070707
                0000070707070707070707070707070707000007070707070707070707070700
                0007070707070707070707070707070700000707070707070707070707070700
                0007070707070707070707070707070000070707070707070707070707070707
                0000070707070707070707070707000007070707070707070707070707070707
                0700000707070707070707070700000707070707070707070707070707070707
                0707000007070707070707070000070707070707070707070707070707070707
                0707070000070707070707000007070707070707070707070707070707070707
                0707070700000707070700000707070707070707070707070707070707070707
                0707070707000007070000070707070707070707070707070707070707070707
                0707070707070000000007070707070707070707070707070707070707070707
                0707070707070700000707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707}
              OnClick = BcircleClick
            end
          end
          object GroupBox1: TGroupBox
            Left = 8
            Top = 79
            Width = 180
            Height = 93
            Caption = 'Highlight'
            TabOrder = 5
            object Lhighlight: TLabel
              Left = 20
              Top = 41
              Width = 43
              Height = 13
              Caption = 'Region 1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object SBhighlight: TScrollBar
              Left = 90
              Top = 41
              Width = 78
              Height = 16
              Max = 30000
              PageSize = 0
              TabOrder = 0
              OnScroll = SBhighlightScroll
            end
            object BhighLightColor: TButton
              Left = 23
              Top = 15
              Width = 65
              Height = 20
              Caption = 'color'
              TabOrder = 1
              OnClick = BhighLightColorClick
            end
            object PhighlightColor: TPanel
              Left = 133
              Top = 15
              Width = 29
              Height = 20
              TabOrder = 2
            end
            object BhighSelect: TButton
              Left = 23
              Top = 65
              Width = 65
              Height = 20
              Caption = 'Select'
              TabOrder = 3
              OnClick = BhighSelectClick
            end
          end
        end
      end
      object TabFilters: TTabSheet
        Caption = 'Filter'
        ImageIndex = 2
        object GroupBox2: TGroupBox
          Left = 3
          Top = 81
          Width = 218
          Height = 101
          Caption = 'Rotation'
          TabOrder = 0
          inline FilterX: TEditScroll
            Left = 3
            Top = 15
            Width = 213
            Height = 24
            TabOrder = 0
            inherited Lb: TLabel
              Width = 5
              Caption = 'x'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
          inline FilterY: TEditScroll
            Left = 3
            Top = 40
            Width = 213
            Height = 24
            TabOrder = 1
            inherited Lb: TLabel
              Width = 5
              Caption = 'y'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
          inline FilterTheta: TEditScroll
            Left = 3
            Top = 64
            Width = 213
            Height = 24
            TabOrder = 2
            inherited Lb: TLabel
              Width = 28
              Caption = 'Theta'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
        end
        object GroupBox3: TGroupBox
          Left = 4
          Top = 187
          Width = 218
          Height = 71
          Caption = 'Scaling'
          TabOrder = 1
          inline FilterDx: TEditScroll
            Left = 3
            Top = 17
            Width = 213
            Height = 24
            TabOrder = 0
            inherited Lb: TLabel
              Width = 13
              Caption = 'Dx'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
          inline FilterDy: TEditScroll
            Left = 3
            Top = 41
            Width = 213
            Height = 24
            TabOrder = 1
            inherited Lb: TLabel
              Width = 13
              Caption = 'Dy'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
        end
        object cbFilterActive: TCheckBoxV
          Left = 5
          Top = 279
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Active'
          TabOrder = 2
          OnClick = cbFilterActiveClick
          UpdateVarOnToggle = True
        end
        object BupdateFilter: TButton
          Left = 8
          Top = 303
          Width = 75
          Height = 20
          Caption = 'Update'
          TabOrder = 3
        end
        object BsaveFilter: TButton
          Left = 8
          Top = 326
          Width = 113
          Height = 20
          Caption = 'Save to data file'
          TabOrder = 4
          OnClick = BsaveFilterClick
        end
        object GroupBox7: TGroupBox
          Left = 3
          Top = 6
          Width = 218
          Height = 72
          Caption = 'Translation'
          TabOrder = 5
          inline FilterVx: TEditScroll
            Left = 3
            Top = 15
            Width = 213
            Height = 24
            TabOrder = 0
            inherited Lb: TLabel
              Caption = 'Vx'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
          inline FilterVy: TEditScroll
            Left = 3
            Top = 40
            Width = 213
            Height = 24
            TabOrder = 1
            inherited Lb: TLabel
              Caption = 'Vy'
            end
            inherited en: TeditNum
              Left = 42
              Width = 64
            end
            inherited sb: TscrollbarV
              Left = 113
              Width = 87
            end
          end
        end
      end
    end
  end
  object PopupRegion: TPopupMenu
    Left = 284
    Top = 400
    object Region1: TMenuItem
      Caption = 'Region'
      object Delete1: TMenuItem
        Caption = 'Delete'
        OnClick = Delete1Click
      end
      object Edit1: TMenuItem
        Caption = 'Edit'
        OnClick = Edit1Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 316
    Top = 404
    object File1: TMenuItem
      Caption = 'File'
      object LoadBK1: TMenuItem
        Caption = 'Load background'
        OnClick = LoadBK1Click
      end
      object SaveBK1: TMenuItem
        Caption = 'Save background'
        OnClick = SaveBK1Click
      end
    end
    object Coordinates1: TMenuItem
      Caption = 'Coordinates'
      OnClick = Coordinates1Click
    end
    object Regions1: TMenuItem
      Caption = 'Regions'
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Clear1: TMenuItem
        Caption = 'Clear'
        OnClick = Clear1Click
      end
      object Showlist1: TMenuItem
        Caption = 'Show list'
        OnClick = Showlist1Click
      end
      object SelectAll1: TMenuItem
        Caption = 'Select All'
        OnClick = SelectAll1Click
      end
      object UnSelectAll1: TMenuItem
        Caption = 'Unselect all'
        OnClick = UnSelectAll1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 248
    Top = 400
  end
end
