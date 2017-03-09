object FXcontrol: TFXcontrol
  Left = 679
  Top = 213
  Width = 603
  Height = 469
  BorderIcons = [biSystemMenu]
  Caption = 'Visual stimulator'
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 30
    Align = alTop
    TabOrder = 0
    object SpeedControl: TSpeedButton
      Left = 5
      Top = 4
      Width = 46
      Height = 22
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Caption = 'Ctrl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        033333777777777773333330777777703333333773F333773333333330888033
        33333FFFF7FFF7FFFFFF0000000000000003777777777777777F0FFFFFFFFFF9
        FF037F3333333337337F0F78888888887F037F33FFFFFFFFF37F0F7000000000
        8F037F3777777777F37F0F70AAAAAAA08F037F37F3333337F37F0F70ADDDDDA0
        8F037F37F3333337F37F0F70A99A99A08F037F37F3333337F37F0F70A99A99A0
        8F037F37F3333337F37F0F70AAAAAAA08F037F37FFFFFFF7F37F0F7000000000
        8F037F3777777777337F0F77777777777F037F3333333333337F0FFFFFFFFFFF
        FF037FFFFFFFFFFFFF7F00000000000000037777777777777773}
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedControlClick
    end
    object SpeedStim: TSpeedButton
      Left = 56
      Top = 4
      Width = 50
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'Stim'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        033333777777777773333330777777703333333773F333773333333330888033
        33333FFFF7FFF7FFFFFF0000000000000003777777777777777F0FFFFFFFFFF9
        FF037F3333333337337F0F78888888887F037F33FFFFFFFFF37F0F7000000000
        8F037F3777777777F37F0F70AAAAAAA08F037F37F3333337F37F0F70ADDDDDA0
        8F037F37F3333337F37F0F70A99A99A08F037F37F3333337F37F0F70A99A99A0
        8F037F37F3333337F37F0F70AAAAAAA08F037F37FFFFFFF7F37F0F7000000000
        8F037F3777777777337F0F77777777777F037F3333333333337F0FFFFFFFFFFF
        FF037FFFFFFFFFFFFF7F00000000000000037777777777777773}
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedStimClick
    end
    object SpeedTrack1: TSpeedButton
      Left = 110
      Top = 4
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 3
      Caption = 'Tr1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedTrack1Click
    end
    object SpeedRF1: TSpeedButton
      Left = 183
      Top = 4
      Width = 38
      Height = 22
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'RF1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedRF1Click
    end
    object SpeedAC: TSpeedButton
      Left = 225
      Top = 4
      Width = 34
      Height = 22
      AllowAllUp = True
      GroupIndex = 6
      Caption = 'AC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedACClick
    end
    object SpeedTrack2: TSpeedButton
      Left = 146
      Top = 4
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 4
      Caption = 'Tr2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedTrack2Click
    end
    object Panel1: TPanel
      Left = 405
      Top = 1
      Width = 189
      Height = 28
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Bfront: TBitBtn
        Left = 8
        Top = 3
        Width = 46
        Height = 23
        Caption = 'Front'
        TabOrder = 0
        OnClick = BfrontClick
      end
      object Bback: TBitBtn
        Left = 57
        Top = 3
        Width = 46
        Height = 23
        Caption = 'Back'
        TabOrder = 1
        OnClick = BbackClick
      end
      object Btest: TButton
        Left = 112
        Top = 3
        Width = 46
        Height = 23
        Caption = 'Update'
        TabOrder = 2
        OnClick = UpdateRightPanel
      end
    end
    object PanelError: TPanel
      Left = 265
      Top = 5
      Width = 72
      Height = 21
      BevelOuter = bvNone
      BorderWidth = 2
      BorderStyle = bsSingle
      Caption = 'Error'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
    end
    object Bstop: TBitBtn
      Left = 346
      Top = 5
      Width = 37
      Height = 21
      Caption = 'Stop'
      TabOrder = 2
      OnClick = BstopClick
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 401
    Width = 595
    Height = 22
    Align = alBottom
    TabOrder = 1
    object PanelMouse: TPanel
      Left = 474
      Top = 1
      Width = 120
      Height = 20
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 0
    end
    object PanelStatusX: TPanel
      Left = 196
      Top = 1
      Width = 158
      Height = 20
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
    end
    object PanelSeqStim: TPanel
      Left = 354
      Top = 1
      Width = 120
      Height = 20
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 2
    end
    object PanelX: TPanel
      Left = 1
      Top = 1
      Width = 195
      Height = 20
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 3
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
  end
  object PanelRight: TPanel
    Left = 405
    Top = 30
    Width = 190
    Height = 371
    Align = alRight
    TabOrder = 2
    object BBextra: TBitBtn
      Left = 7
      Top = 32
      Width = 20
      Height = 21
      TabOrder = 0
      OnClick = BBextraClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333033333
        33333333373F33333333333330B03333333333337F7F33333333333330F03333
        333333337F7FF3333333333330B00333333333337F773FF33333333330F0F003
        333333337F7F773F3333333330B0B0B0333333337F7F7F7F3333333300F0F0F0
        333333377F73737F33333330B0BFBFB03333337F7F33337F33333330F0FBFBF0
        3333337F7333337F33333330BFBFBFB033333373F3333373333333330BFBFB03
        33333337FFFFF7FF3333333300000000333333377777777F333333330EEEEEE0
        33333337FFFFFF7FF3333333000000000333333777777777F33333330000000B
        03333337777777F7F33333330000000003333337777777773333}
      NumGlyphs = 2
    end
    object Binfo: TButton
      Left = 110
      Top = 32
      Width = 69
      Height = 21
      Caption = 'Info'
      TabOrder = 1
    end
    object Bdestroy: TButton
      Left = 36
      Top = 32
      Width = 67
      Height = 21
      Caption = 'Destroy'
      Enabled = False
      TabOrder = 2
      OnClick = BdestroyClick
    end
    object TreeView1: TTreeView
      Left = 8
      Top = 24
      Width = 174
      Height = 113
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 3
      Visible = False
      OnChange = TreeView1Change
    end
    object Edit1: TEdit
      Left = 8
      Top = 5
      Width = 151
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = 'Edit1'
    end
    object BitBtn1: TBitBtn
      Left = 160
      Top = 5
      Width = 20
      Height = 20
      TabOrder = 5
      OnClick = BitBtn1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333337F33333333333333033333333333333373F333333333333090333
        33333333337F7F33333333333309033333333333337373F33333333330999033
        3333333337F337F33333333330999033333333333733373F3333333309999903
        333333337F33337F33333333099999033333333373333373F333333099999990
        33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333309033333333333337F7F333333333333090333
        33333333337F7F33333333333300033333333333337773333333}
      NumGlyphs = 2
    end
  end
  object PanelControl: TPanel
    Left = 0
    Top = 30
    Width = 405
    Height = 371
    Align = alClient
    Color = clBlack
    TabOrder = 3
    object PaintBox0: TPaintBox
      Left = 1
      Top = 1
      Width = 387
      Height = 353
      Align = alClient
      Color = clBackground
      ParentColor = False
      OnMouseDown = PaintBox0MouseDown
      OnMouseMove = PaintBox0MouseMove
      OnMouseUp = PaintBox0MouseUp
      OnPaint = PaintBox0Paint
    end
    object Panel2: TPanel
      Left = 1
      Top = 354
      Width = 403
      Height = 16
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Panel4: TPanel
        Left = 387
        Top = 0
        Width = 16
        Height = 16
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object Bcadrer: TBitBtn
          Left = 1
          Top = 1
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
        Left = 0
        Top = 0
        Width = 387
        Height = 16
        Align = alClient
        Max = 30000
        PageSize = 0
        TabOrder = 1
        Xmax = 1000.000000000000000000
        dxSmall = 1.000000000000000000
        dxLarge = 10.000000000000000000
        OnScrollV = scrollbarHScrollV
      end
    end
    object Panel3: TPanel
      Left = 388
      Top = 1
      Width = 16
      Height = 353
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object scrollbarV: TscrollbarV
        Left = 0
        Top = 0
        Width = 16
        Height = 353
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
  end
  object MainMenu1: TMainMenu
    Left = 552
    Top = 353
    object System1: TMenuItem
      Caption = 'System'
      OnClick = System1Click
    end
    object Objects1: TMenuItem
      Caption = 'Objects'
      object New1: TMenuItem
        Caption = 'New'
        object visualobject1: TMenuItem
          Caption = 'visual object'
          OnClick = visualobject1Click
        end
        object stimulus1: TMenuItem
          Caption = 'stimulus'
          OnClick = stimulus1Click
        end
      end
    end
    object Palette1: TMenuItem
      Caption = 'Palette'
      OnClick = Palette1Click
    end
    object Stimulation1: TMenuItem
      Caption = 'Stimulation'
      object Animateobjects1: TMenuItem
        Caption = 'Animate objects'
        OnClick = Animateobjects1Click
      end
      object Replay1: TMenuItem
        Caption = 'Replay'
        OnClick = Replay1Click
      end
      object Redraw1: TMenuItem
        Caption = 'Redraw'
        OnClick = Redraw1Click
      end
      object Options1: TMenuItem
        Caption = 'Options'
      end
      object Activestimuli1: TMenuItem
        Caption = 'Active stimuli'
        OnClick = Activestimuli1Click
      end
      object CreateAVI1: TMenuItem
        Caption = 'Create AVI'
        OnClick = CreateAVI1Click
      end
    end
    object Acquisition1: TMenuItem
      Caption = 'Acquisition'
      OnClick = Acquisition1Click
      object Parameters1: TMenuItem
        Caption = 'Parameters'
        OnClick = Parameters1Click
      end
      object Open1: TMenuItem
        Caption = 'Open file'
        OnClick = Open1Click
      end
      object Append1: TMenuItem
        Caption = 'Append'
        OnClick = Append1Click
      end
    end
    object Screen1: TMenuItem
      Caption = 'Screen'
      object Clear1: TMenuItem
        Caption = 'Clear'
        OnClick = Clear1Click
      end
      object Displayall1: TMenuItem
        Caption = 'Display all'
        OnClick = Displayall1Click
      end
      object SaveasBMP1: TMenuItem
        Caption = 'Save as BMP'
        OnClick = SaveasBMP1Click
      end
      object Debug1: TMenuItem
        Caption = 'Debug'
        object Displaysync1: TMenuItem
          Caption = 'Display sync'
          OnClick = Displaysync1Click
        end
        object Test1: TMenuItem
          Caption = 'Test'
          OnClick = Test1Click
        end
      end
    end
    object Control1: TMenuItem
      Caption = 'Control'
      object Clear2: TMenuItem
        Caption = 'Clear'
        OnClick = Clear2Click
      end
      object Displayall2: TMenuItem
        Caption = 'Display all'
        OnClick = Displayall2Click
      end
      object Showtracks1: TMenuItem
        Caption = 'Show tracks 1'
        OnClick = Showtracks1Click
      end
      object Showtracks21: TMenuItem
        Caption = 'Show tracks 2'
        OnClick = Showtracks21Click
      end
      object cleartracks1: TMenuItem
        Caption = 'clear tracks 1'
        OnClick = cleartracks1Click
      end
      object Cleartracks21: TMenuItem
        Caption = 'Clear tracks 2'
        OnClick = Cleartracks21Click
      end
      object SaveasBMP2: TMenuItem
        Caption = 'Save as BMP'
        OnClick = SaveasBMP2Click
      end
      object Copytoclipboard1: TMenuItem
        Caption = 'Copy to clipboard'
        OnClick = Copytoclipboard1Click
      end
    end
  end
end
