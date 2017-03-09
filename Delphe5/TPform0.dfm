object Pform: TPform
  Left = 505
  Top = 213
  Width = 388
  Height = 242
  Caption = 'Pform'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox0: TPaintBox
    Left = 0
    Top = 0
    Width = 380
    Height = 196
    Align = alClient
    OnEndDrag = PaintBox0EndDrag
    OnMouseDown = PaintBox0MouseDown
    OnMouseMove = PaintBox0MouseMove
    OnMouseUp = PaintBox0MouseUp
    OnPaint = PaintBox0Paint
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 176
    object File1: TMenuItem
      Caption = 'File'
      object PrintSave1: TMenuItem
        Caption = 'Print/Save'
        OnClick = PrintSave1Click
      end
      object Copytoclipboard1: TMenuItem
        Caption = 'Copy to clipboard'
        OnClick = Copytoclipboard1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
    end
  end
end
