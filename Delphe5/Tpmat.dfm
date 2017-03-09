object paintMatrix: TpaintMatrix
  Left = 268
  Top = 146
  Width = 497
  Height = 348
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'paintMatrix'
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object PaintBox1: TPaintBox
    Left = 0
    Top = 21
    Width = 489
    Height = 293
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnMouseDown = PaintBox1MouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 489
    Height = 21
    Align = alTop
    TabOrder = 0
    object SBlmin: TScrollBar
      Left = 67
      Top = 2
      Width = 70
      Height = 17
      LargeChange = 10
      PageSize = 0
      TabOrder = 0
      OnChange = SBlminChange
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 36
      Height = 19
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Lmin:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object PLmin: TPanel
      Left = 37
      Top = 1
      Width = 28
      Height = 19
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '9999'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Panel4: TPanel
      Left = 151
      Top = 1
      Width = 37
      Height = 19
      BevelOuter = bvNone
      Caption = 'Lmax:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object Plmax: TPanel
      Left = 188
      Top = 1
      Width = 28
      Height = 19
      BevelOuter = bvLowered
      Caption = '9999'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object SBLmax: TScrollBar
      Left = 218
      Top = 2
      Width = 70
      Height = 17
      LargeChange = 10
      PageSize = 0
      TabOrder = 5
      OnChange = SBLmaxChange
    end
    object Panel6: TPanel
      Left = 303
      Top = 1
      Width = 40
      Height = 19
      BevelOuter = bvNone
      Caption = 'Gamma:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object Pgamma: TPanel
      Left = 344
      Top = 1
      Width = 28
      Height = 19
      BevelOuter = bvLowered
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object SBgamma: TScrollBar
      Left = 374
      Top = 2
      Width = 70
      Height = 17
      LargeChange = 10
      PageSize = 0
      TabOrder = 8
      OnChange = SBgammaChange
    end
    object BitBtn1: TBitBtn
      Left = 451
      Top = 1
      Width = 30
      Height = 19
      TabOrder = 9
      OnClick = BitBtn1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333FFF333333333333000333333333
        3333777FFF3FFFFF33330B000300000333337F777F777773F333000E00BFBFB0
        3333777F773333F7F333000E0BFBF0003333777F7F3337773F33000E0FBFBFBF
        0333777F7F3333FF7FFF000E0BFBF0000003777F7F3337777773000E0FBFBFBF
        BFB0777F7F33FFFFFFF7000E0BF000000003777F7FF777777773000000BFB033
        33337777773FF733333333333300033333333333337773333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
  end
end
