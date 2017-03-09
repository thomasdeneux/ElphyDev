object consoleG: TconsoleG
  Left = 579
  Top = 226
  Width = 578
  Height = 460
  Caption = 'consoleG'
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 392
    Width = 570
    Height = 34
    Align = alBottom
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 570
    Height = 392
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 456
    Top = 384
  end
end
