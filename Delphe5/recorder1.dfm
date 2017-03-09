object AcqCommand: TAcqCommand
  Left = 589
  Top = 206
  Width = 555
  Height = 398
  Caption = 'Acquisition control panel'
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 340
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pbottom: TPanel
    Left = 0
    Top = 315
    Width = 547
    Height = 29
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Btag1: TSpeedButton
      Left = 6
      Top = 4
      Width = 21
      Height = 21
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Btag1Click
    end
    object Btag2: TSpeedButton
      Left = 28
      Top = 4
      Width = 21
      Height = 21
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Btag1Click
    end
    object Btag4: TSpeedButton
      Left = 74
      Top = 4
      Width = 21
      Height = 21
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Btag1Click
    end
    object Btag3: TSpeedButton
      Left = 51
      Top = 4
      Width = 21
      Height = 21
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Btag1Click
    end
    object Btag5: TSpeedButton
      Left = 97
      Top = 4
      Width = 21
      Height = 21
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Btag1Click
    end
    object Bstore: TButton
      Left = 326
      Top = 4
      Width = 54
      Height = 21
      Caption = 'Store'
      TabOrder = 0
      OnClick = BstoreClick
    end
    object Bclear: TButton
      Left = 250
      Top = 4
      Width = 54
      Height = 21
      Caption = 'Clear'
      TabOrder = 1
      OnClick = BclearClick
    end
    object Ptime: TPanel
      Left = 123
      Top = 4
      Width = 116
      Height = 21
      BevelOuter = bvLowered
      TabOrder = 2
    end
  end
  object Pcomment: TPanel
    Left = 0
    Top = 55
    Width = 547
    Height = 260
    Align = alClient
    Caption = 'Pcomment'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 203
      Width = 545
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Phistory: TPanel
      Left = 1
      Top = 1
      Width = 545
      Height = 202
      Align = alClient
      TabOrder = 0
      object HisViewer: TSynEdit
        Left = 1
        Top = 1
        Width = 543
        Height = 200
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Lines.Strings = (
          '')
        ReadOnly = True
        OnSpecialLineColors = HisViewerSpecialLineColors
      end
    end
    object Pintro: TPanel
      Left = 1
      Top = 206
      Width = 545
      Height = 53
      Align = alBottom
      TabOrder = 1
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 543
        Height = 51
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object Pthreshold: TPanel
    Left = 0
    Top = 0
    Width = 547
    Height = 55
    Align = alTop
    TabOrder = 2
    object TBUpper: TTrackBar
      Left = 6
      Top = 33
      Width = 168
      Height = 16
      Max = 4095
      PageSize = 10
      Frequency = 200
      TabOrder = 0
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TBUpperChange
    end
    object TBLower: TTrackBar
      Left = 173
      Top = 33
      Width = 168
      Height = 16
      Max = 4095
      PageSize = 10
      Frequency = 200
      TabOrder = 1
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TBLowerChange
    end
    object cbRising: TCheckBoxV
      Left = 349
      Top = 11
      Width = 96
      Height = 17
      Alignment = taLeftJustify
      Caption = 'NI Rising Slope'
      TabOrder = 2
      OnClick = cbRisingClick
      UpdateVarOnToggle = False
    end
    object PanelUpper: TPanel
      Left = 12
      Top = 4
      Width = 155
      Height = 27
      TabOrder = 3
      object Pupper: TPanel
        Left = 1
        Top = 1
        Width = 92
        Height = 25
        Align = alLeft
        BevelOuter = bvLowered
        Caption = 'Upper Threshold'
        TabOrder = 0
      end
      object PupperValue: TPanel
        Left = 93
        Top = 1
        Width = 61
        Height = 25
        Align = alClient
        BevelOuter = bvLowered
        Caption = '200.000'
        TabOrder = 1
      end
    end
    object PanelLower: TPanel
      Left = 180
      Top = 4
      Width = 155
      Height = 27
      TabOrder = 4
      object Plower: TPanel
        Left = 1
        Top = 1
        Width = 92
        Height = 25
        Align = alLeft
        BevelOuter = bvLowered
        Caption = 'Lower Threshold'
        TabOrder = 0
      end
      object PlowerValue: TPanel
        Left = 93
        Top = 1
        Width = 61
        Height = 25
        Align = alClient
        BevelOuter = bvLowered
        Caption = '200.000'
        TabOrder = 1
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 506
    Top = 10
    object Panels1: TMenuItem
      Caption = 'Display'
      object Thresholds1: TMenuItem
        Caption = 'Thresholds'
        OnClick = Thresholds1Click
      end
      object Comments1: TMenuItem
        Caption = 'Comments'
        OnClick = Comments1Click
      end
    end
  end
end
