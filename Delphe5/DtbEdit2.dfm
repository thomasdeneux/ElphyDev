object TableEdit: TTableEdit
  Left = 742
  Top = 265
  Width = 460
  Height = 317
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 452
    Height = 21
    Align = alTop
    TabOrder = 0
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
  inline TableFrame1: TTableFrame
    Left = 0
    Top = 21
    Width = 452
    Height = 250
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    inherited DrawGrid1: TDrawGrid
      Width = 452
      Height = 250
      ColCount = 20
      RowCount = 20
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
        OnClick = Clear2Click
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
