object MainForm: TMainForm
  Left = 588
  Top = 496
  Width = 620
  Height = 375
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bcreate: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 0
    OnClick = BcreateClick
  end
  object Button2: TButton
    Tag = 1
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Render1'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 128
    Top = 8
    Width = 457
    Height = 249
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button1: TButton
    Tag = 2
    Left = 8
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Render2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Tag = 3
    Left = 8
    Top = 102
    Width = 75
    Height = 25
    Caption = 'Render3'
    TabOrder = 4
    OnClick = Button2Click
  end
  object cbAnimate: TCheckBoxV
    Left = 8
    Top = 240
    Width = 75
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Animate'
    TabOrder = 5
    UpdateVarOnToggle = False
  end
  object Button4: TButton
    Left = 8
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 6
    OnClick = Button4Click
  end
end
