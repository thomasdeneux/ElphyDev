object MenuForm: TMenuForm
  Left = 463
  Top = 145
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Menu'
  ClientHeight = 270
  ClientWidth = 115
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 115
    Height = 260
    Align = alClient
    BorderStyle = bsNone
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
    OnClick = ListBox1Click
    OnKeyUp = ListBox1KeyUp
  end
end
