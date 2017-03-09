object getMatrix: TgetMatrix
  Left = 376
  Top = 153
  Width = 190
  Height = 91
  Caption = 'Default form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 20
    Top = 8
    Width = 89
    Height = 21
    Caption = 'Show'
    TabOrder = 0
    OnClick = Button1Click
  end
  object cbOnControl: TCheckBoxV
    Left = 19
    Top = 36
    Width = 90
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 1
    OnClick = cbOnControlClick
    UpdateVarOnToggle = False
  end
end
