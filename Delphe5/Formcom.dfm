object CommandForm: TCommandForm
  Left = 474
  Top = 164
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Commands'
  ClientHeight = 273
  ClientWidth = 115
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 115
    Height = 273
    Align = alClient
    BorderStyle = bsNone
    Color = clMenu
    IntegralHeight = True
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
    OnKeyUp = ListBox1KeyUp
  end
end
