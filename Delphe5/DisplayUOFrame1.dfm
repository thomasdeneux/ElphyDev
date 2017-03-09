object UODisplay: TUODisplay
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object PaintBox0: TPaintBox
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    OnEndDrag = PaintBox0EndDrag
    OnMouseDown = PaintBox0MouseDown
    OnMouseMove = PaintBox0MouseMove
    OnMouseUp = PaintBox0MouseUp
    OnPaint = PaintBox0Paint
  end
end
