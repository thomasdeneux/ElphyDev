object TestForm: TTestForm
  Left = 353
  Top = 184
  Width = 414
  Height = 338
  Caption = 'FormTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline TDispFrame1: TDispFrame
    Left = 0
    Top = 52
    Width = 406
    Height = 240
    Align = alBottom
    TabOrder = 0
    inherited PaintBox1: TPaintBox
      Width = 406
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 406
    Height = 52
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 302
    Top = 166
    object Coordinates1: TMenuItem
      Caption = 'Coordinates'
      OnClick = Coordinates1Click
    end
    object Color1: TMenuItem
      Caption = 'Color'
      OnClick = Color1Click
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 364
    Top = 259
  end
end
