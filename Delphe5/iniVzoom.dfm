object initVzoom: TinitVzoom
  Left = 380
  Top = 156
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Init Vzoom'
  ClientHeight = 91
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 10
    Width = 67
    Height = 13
    Caption = 'Source vector'
  end
  object BOK: TButton
    Left = 68
    Top = 45
    Width = 72
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 155
    Top = 45
    Width = 72
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object EditSource: TEdit
    Left = 90
    Top = 8
    Width = 184
    Height = 21
    TabOrder = 2
  end
  object Bchoose: TBitBtn
    Left = 277
    Top = 11
    Width = 15
    Height = 15
    TabOrder = 3
    OnClick = BchooseClick
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
