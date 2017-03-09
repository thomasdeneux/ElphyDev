object VideoCommand: TVideoCommand
  Left = 425
  Top = 260
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'VideoCommand'
  ClientHeight = 16
  ClientWidth = 187
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Pframe: TPanel
    Left = 0
    Top = 0
    Width = 49
    Height = 16
    Align = alLeft
    BevelOuter = bvLowered
    Caption = '0'
    TabOrder = 0
  end
  object sbCurrent: TscrollbarV
    Left = 62
    Top = 1
    Width = 121
    Height = 16
    Max = 30000
    PageSize = 0
    TabOrder = 1
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
    OnScrollV = sbCurrentScrollV
  end
end
