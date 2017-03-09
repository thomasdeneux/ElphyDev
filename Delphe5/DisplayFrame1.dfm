object DispFrame: TDispFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    OnMouseDown = PaintBox1MouseDown
    OnPaint = PaintBox1Paint
  end
  object PopupMenu1: TPopupMenu
    Left = 284
    Top = 204
    object Coordinates1: TMenuItem
      Caption = 'Coordinates'
      OnClick = Coordinates1Click
    end
    object Backgroundcolor1: TMenuItem
      Caption = 'Background color'
      OnClick = Backgroundcolor1Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 244
    Top = 205
  end
end
