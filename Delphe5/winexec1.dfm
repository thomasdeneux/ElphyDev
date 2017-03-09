object Form1: TForm1
  Left = 490
  Top = 200
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 288
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDir: TLabel
    Left = 16
    Top = 56
    Width = 42
    Height = 13
    Caption = 'Directory'
  end
  object editString1: TeditString
    Left = 16
    Top = 88
    Width = 505
    Height = 21
    TabOrder = 0
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object Bgo: TButton
    Left = 16
    Top = 192
    Width = 75
    Height = 25
    Caption = 'GO'
    TabOrder = 1
    OnClick = BgoClick
  end
  object Bdir: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Directory'
    TabOrder = 2
    OnClick = BdirClick
  end
  object OpenDialog1: TOpenDialog
    Left = 136
    Top = 256
  end
end
