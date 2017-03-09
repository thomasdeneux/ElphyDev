object BMplotForm: TBMplotForm
  Left = 323
  Top = 222
  Width = 603
  Height = 456
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'BMplotForm'
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
    Width = 368
    Height = 386
    Align = alClient
    Color = clBlack
    ParentColor = False
    OnDblClick = PaintBox0DblClick
    OnMouseDown = PaintBox0MouseDown
    OnMouseMove = PaintBox0MouseMove
    OnMouseUp = PaintBox0MouseUp
    OnPaint = PaintBox0Paint
  end
  object PanelRight: TPanel
    Left = 384
    Top = 0
    Width = 211
    Height = 386
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object PanelX: TPanel
      Left = 10
      Top = 9
      Width = 195
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
      object BG0: TBitBtn
        Left = 177
        Top = 3
        Width = 15
        Height = 15
        TabOrder = 1
        OnClick = BG0Click
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
    object Panel5: TPanel
      Left = 10
      Top = 34
      Width = 195
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
    object Panel6: TPanel
      Left = 10
      Top = 207
      Width = 195
      Height = 33
      BevelOuter = bvLowered
      TabOrder = 2
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
        OnClick = BrectangleClick
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
      end
    end
    object GBdisplay: TGroupBox
      Left = 10
      Top = 91
      Width = 195
      Height = 102
      Caption = 'Display'
      TabOrder = 3
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
      object cbFillMode: TCheckBoxV
        Left = 16
        Top = 76
        Width = 97
        Height = 17
        Caption = 'Fill mode'
        TabOrder = 4
        OnClick = cbFillModeClick
        UpdateVarOnToggle = False
      end
    end
    object GroupBox1: TGroupBox
      Left = 10
      Top = 241
      Width = 196
      Height = 47
      Caption = 'Frame'
      TabOrder = 4
      object Lindex: TLabel
        Left = 5
        Top = 17
        Width = 56
        Height = 13
        Caption = 'Zmin=1.000'
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
  end
  object Panel1: TPanel
    Left = 368
    Top = 0
    Width = 16
    Height = 386
    Align = alRight
    TabOrder = 1
    object scrollbarV: TscrollbarV
      Left = 1
      Top = 1
      Width = 14
      Height = 384
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
    Top = 386
    Width = 595
    Height = 16
    Align = alBottom
    TabOrder = 2
    object PanelMouse: TPanel
      Left = 384
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
      Left = 368
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
      Width = 367
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
  object PopupRegion: TPopupMenu
    Left = 396
    Top = 344
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
    Left = 548
    Top = 348
    object Coordinates1: TMenuItem
      Caption = 'Coordinates'
      OnClick = Coordinates1Click
    end
    object File1: TMenuItem
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
    end
  end
  object ColorDialog1: TColorDialog
    Left = 440
    Top = 352
  end
end
