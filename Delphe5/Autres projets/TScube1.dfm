object Form1: TForm1
  Left = 287
  Top = 123
  Width = 472
  Height = 375
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DXDraw1: TDXDraw
    Left = 0
    Top = 0
    Width = 464
    Height = 257
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Options = [doFullScreen, doAllowReboot, doWaitVBlank, doCenter, do3D, doDirectX7Mode, doHardware, doSelectDriver, doZBuffer]
    SurfaceHeight = 257
    SurfaceWidth = 464
    OnFinalize = DXDraw1Finalize
    OnInitialize = DXDraw1Initialize
    OnInitializeSurface = DXDraw1InitializeSurface
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 257
    Width = 464
    Height = 91
    Align = alBottom
    TabOrder = 1
    object Lalpha: TLabel
      Left = 105
      Top = 16
      Width = 27
      Height = 13
      Caption = 'Alpha'
    end
    object Lbeta: TLabel
      Left = 105
      Top = 41
      Width = 22
      Height = 13
      Caption = 'Beta'
    end
    object Ldist: TLabel
      Left = 105
      Top = 66
      Width = 8
      Height = 13
      Caption = 'D'
    end
    object LlightX: TLabel
      Left = 263
      Top = 15
      Width = 27
      Height = 13
      Caption = 'Alpha'
    end
    object LlightY: TLabel
      Left = 263
      Top = 40
      Width = 22
      Height = 13
      Caption = 'Beta'
    end
    object LlightZ: TLabel
      Left = 263
      Top = 65
      Width = 8
      Height = 13
      Caption = 'D'
    end
    object Lfov: TLabel
      Left = 424
      Top = 15
      Width = 27
      Height = 13
      Caption = 'Alpha'
    end
    object sbAlpha: TscrollbarV
      Left = 7
      Top = 16
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 0
      Xmax = 1000
      dxSmall = 1
      dxLarge = 10
      OnScrollV = sbAlphaScrollV
    end
    object sbBeta: TscrollbarV
      Left = 7
      Top = 40
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 1
      Xmax = 1000
      dxSmall = 1
      dxLarge = 10
      OnScrollV = sbBetaScrollV
    end
    object sbDist: TscrollbarV
      Left = 7
      Top = 64
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 2
      Xmax = 1000
      dxSmall = 0.1
      dxLarge = 1
      OnScrollV = sbDistScrollV
    end
    object sbLightX: TscrollbarV
      Left = 165
      Top = 15
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 3
      Xmax = 1000
      dxSmall = 1
      dxLarge = 10
      OnScrollV = sbLightXScrollV
    end
    object sbLightY: TscrollbarV
      Left = 165
      Top = 39
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 4
      Xmax = 1000
      dxSmall = 1
      dxLarge = 10
      OnScrollV = sbLightYScrollV
    end
    object sbLightZ: TscrollbarV
      Left = 165
      Top = 63
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 5
      Xmax = 1000
      dxSmall = 0.1
      dxLarge = 1
      OnScrollV = sbLightZScrollV
    end
    object sbFov: TscrollbarV
      Left = 332
      Top = 15
      Width = 87
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 6
      Xmax = 1000
      dxSmall = 1
      dxLarge = 10
      OnScrollV = sbFovScrollV
    end
  end
end
