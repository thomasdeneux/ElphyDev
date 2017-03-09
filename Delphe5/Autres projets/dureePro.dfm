object HisDuree: THisDuree
  Left = 327
  Top = 138
  Width = 435
  Height = 300
  Caption = 'Refresh times'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 427
    Height = 254
    Align = alClient
    Color = clWhite
    ParentColor = False
  end
  object MainMenu1: TMainMenu
    Left = 5
    Top = 248
    object Coordinates1: TMenuItem
      Caption = 'Coordinates'
      object Histogram1: TMenuItem
        Tag = 1
        Caption = 'Histogram'
        OnClick = Histogram1Click
      end
      object Durations1: TMenuItem
        Tag = 2
        Caption = 'Durations'
        OnClick = Histogram1Click
      end
    end
  end
end
