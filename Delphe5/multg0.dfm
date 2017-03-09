object MultiGform: TMultiGform
  Left = 466
  Top = 213
  Width = 872
  Height = 627
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'MultiGform'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object PaintBox1: TPaintBox
    Left = 0
    Top = 31
    Width = 864
    Height = 563
    Align = alClient
    OnDblClick = PaintBox1DblClick
    OnDragDrop = PaintBox1DragDrop
    OnDragOver = PaintBox1DragOver
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
  end
  object Panel1Top: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 31
    Align = alTop
    TabOrder = 0
    object TabPage1: TTabControl
      Left = 628
      Top = 1
      Width = 235
      Height = 29
      Align = alRight
      Style = tsFlatButtons
      TabOrder = 0
      OnChange = TabPage1Change
      OnChanging = TabPage1Changing
    end
    object Bprint: TBitBtn
      Left = 218
      Top = 0
      Width = 32
      Height = 27
      TabOrder = 1
      OnClick = BprintClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
        8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
        8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
        8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
    end
  end
  object PopupNew: TPopupMenu
    AutoPopup = False
    Left = 142
    Top = 235
    object Newwindow1: TMenuItem
      Caption = 'New window'
      OnClick = Newwindow1Click
    end
  end
  object PopupDestroy: TPopupMenu
    Left = 187
    Top = 235
    object Destroywindow1: TMenuItem
      Caption = 'Destroy window'
      OnClick = Destroywindow1Click
    end
    object Clearwindow1: TMenuItem
      Caption = 'Clear window'
      OnClick = Clearwindow1Click
    end
    object Dividewindow1: TMenuItem
      Caption = 'Divide window'
      OnClick = Dividewindow1Click
    end
  end
  object PopupMain: TPopupMenu
    Left = 59
    Top = 240
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
    end
    object Design1: TMenuItem
      Caption = 'Design'
      OnClick = Design1Click
    end
    object Newpage1: TMenuItem
      Caption = 'New page'
      OnClick = Newpage1Click
    end
    object Deletepage1: TMenuItem
      Caption = 'Delete'
      object CurrentPage1: TMenuItem
        Caption = 'Current Page'
        OnClick = Deletepage1Click
      end
      object AllPagesExceptCurrent1: TMenuItem
        Caption = 'All Pages Except Current'
        OnClick = AllPagesExceptCurrent1Click
      end
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      OnClick = Refresh1Click
    end
    object Pages1: TMenuItem
      Caption = 'Page List'
      OnClick = Pages1Click
    end
    object MultigraphList1: TMenuItem
      Caption = 'Multigraph List'
      OnClick = MultigraphList1Click
    end
    object MgTools: TMenuItem
      Caption = 'Tools'
      object CreateSimpleMultigraph1: TMenuItem
        Caption = 'Create  Multigraph'
        OnClick = CreateSimpleMultigraph1Click
      end
      object CreateObjectList1: TMenuItem
        Caption = 'Clone Page'
        OnClick = CreateObjectList1Click
      end
      object SavePage1: TMenuItem
        Caption = 'Save Page'
        OnClick = SavePage1Click
      end
      object LoadPage1: TMenuItem
        Caption = 'Load Page'
        OnClick = LoadPage1Click
      end
    end
  end
end
