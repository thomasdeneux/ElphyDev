object DD1322Options: TDD1322Options
  Left = 389
  Top = 133
  BorderStyle = bsDialog
  Caption = 'Digidata 1320 options'
  ClientHeight = 158
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cbTagStart: TCheckBoxV
    Left = 16
    Top = 16
    Width = 158
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use Tag/Start bits'
    TabOrder = 0
    UpdateVarOnToggle = False
  end
  object BOK: TButton
    Left = 38
    Top = 113
    Width = 53
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 114
    Top = 113
    Width = 53
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Button1: TButton
    Left = 28
    Top = 46
    Width = 145
    Height = 20
    Caption = 'Calibrate'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 28
    Top = 71
    Width = 145
    Height = 20
    Caption = 'Info'
    TabOrder = 4
    OnClick = Button2Click
  end
end
