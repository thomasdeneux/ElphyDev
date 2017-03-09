object ArrayEditor: TArrayEditor
  Left = 377
  Top = 202
  Width = 486
  Height = 368
  Caption = 'Array editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object DrawGrid1: TDrawGrid
    Left = 0
    Top = 21
    Width = 478
    Height = 293
    Align = alClient
    ColCount = 20
    RowCount = 50
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    ParentFont = False
    TabOrder = 0
    OnDblClick = DrawGrid1DblClick
    OnDrawCell = DrawGrid1DrawCell
    OnKeyDown = DrawGrid1KeyDown
    OnMouseDown = DrawGrid1MouseDown
    OnMouseMove = DrawGrid1MouseMove
    OnMouseUp = DrawGrid1MouseUp
    OnSelectCell = DrawGrid1SelectCell
    OnSetEditText = DrawGrid1SetEditText
    ColWidths = (
      64
      66
      71
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 478
    Height = 21
    Align = alTop
    TabOrder = 1
    object LigCol: TLabel
      Left = 8
      Top = 5
      Width = 33
      Height = 13
      Caption = '--------'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Lselect: TLabel
      Left = 70
      Top = 5
      Width = 3
      Height = 13
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object MainMenu1: TMainMenu
    Left = 254
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Clear1: TMenuItem
        Caption = 'Clear all'
        OnClick = ClearAll1Click
      end
      object Numberoflines1: TMenuItem
        Caption = 'Number of lines'
      end
      object Print1: TMenuItem
        Caption = 'Print'
        OnClick = Print1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Select1: TMenuItem
        Caption = 'Select'
        OnClick = Select1Click
      end
      object Copy1: TMenuItem
        Caption = 'Copy'
        OnClick = Copy1Click
      end
      object paste1: TMenuItem
        Caption = 'paste'
        OnClick = paste1Click
      end
      object Clear2: TMenuItem
        Caption = 'Clear'
        OnClick = Clear1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
      object Properties1: TMenuItem
        Caption = 'Properties'
        OnClick = Properties1Click
      end
      object Font1: TMenuItem
        Caption = 'Font'
        OnClick = Font1Click
      end
      object UseKvalue1: TMenuItem
        Caption = 'Edit integer values'
        Visible = False
        OnClick = UseKvalue1Click
      end
      object ImmediateRefresh: TMenuItem
        Caption = 'Immediate refresh'
        OnClick = ImmediateRefreshClick
      end
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh '
      OnClick = Refresh1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 340
    Top = 8
  end
end
