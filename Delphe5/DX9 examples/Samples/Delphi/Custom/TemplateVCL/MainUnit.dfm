object MainForm: TMainForm
  Left = 359
  Top = 106
  Width = 443
  Height = 343
  Caption = 'VCL Direct3D9 template application'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 105
    Top = 0
    Height = 270
  end
  object DisplayPanel: TPanel
    Left = 108
    Top = 0
    Width = 327
    Height = 270
    Align = alClient
    Caption = 'Direct3D Display Panel'
    TabOrder = 0
    OnResize = DisplayPanelResize
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 270
    Width = 435
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 0
    Width = 105
    Height = 270
    Align = alLeft
    Caption = 'Button Panel'
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 1
      Top = 266
      Width = 103
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object FullScreenButton: TButton
      Left = 8
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Goto Fullscreen'
      TabOrder = 0
      OnClick = FullScreenButtonClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 116
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object FullScreen: TMenuItem
        Caption = 'FullScreen'
        ShortCut = 32781
        OnClick = FullScreenButtonClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
      OnClick = About1Click
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 148
    Top = 8
  end
end
