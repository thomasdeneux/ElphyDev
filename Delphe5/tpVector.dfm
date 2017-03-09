object paint0: Tpaint0
  Left = 250
  Top = 129
  Width = 497
  Height = 348
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'paint0'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 489
    Height = 294
    Align = alClient
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnEndDrag = PaintBox1EndDrag
    OnMouseDown = PaintBox1MouseDown
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 24
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
    end
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
  end
end
