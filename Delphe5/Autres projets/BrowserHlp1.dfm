object Hbrowser: THbrowser
  Left = 376
  Top = 202
  Width = 604
  Height = 521
  Caption = 'Elphy Help'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 25
    Width = 596
    Height = 450
    Align = alClient
    TabOrder = 0
    OnCommandStateChange = WebBrowser1CommandStateChange
    OnTitleChange = WebBrowser1TitleChange
    ControlData = {
      4C000000993D0000822E00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 596
    Height = 25
    Align = alTop
    Caption = 'Les programmes Elphy'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 384
    object Contents1: TMenuItem
      Caption = 'Contents'
      OnClick = Contents1Click
    end
    object Previous1: TMenuItem
      Caption = 'Previous'
      OnClick = Previous1Click
    end
    object Next1: TMenuItem
      Caption = 'Next'
      OnClick = Next1Click
    end
    object Search1: TMenuItem
      Caption = 'Search'
      OnClick = Search1Click
    end
  end
end
