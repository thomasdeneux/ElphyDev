inherited MainDac: TMainDac
  Left = 274
  Top = 154
  Width = 492
  Height = 355
  BorderStyle = bsSizeable
  Caption = 'DAC2'
  Menu = MainMenu1
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  inherited PaintBox1: TPaintBox
    Top = 25
    Width = 484
    Height = 268
    OnDblClick = PaintBox1DblClick
    OnDragDrop = PaintBox1DragDrop
    OnDragOver = PaintBox1DragOver
    OnMouseDown = FormMouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
    OnPaint = FormPaint
  end
  object PanelTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 484
    Height = 25
    Align = alTop
    BevelWidth = 2
    TabOrder = 0
    object Panel4: TPanel
      Left = 94
      Top = 2
      Width = 67
      Height = 21
      Align = alLeft
      Caption = 'Episode:'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object PanSequence: TPanel
      Left = 161
      Top = 2
      Width = 40
      Height = 21
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '1'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object Pnomdat: TPanel
      Left = 2
      Top = 2
      Width = 92
      Height = 21
      Align = alLeft
      BevelOuter = bvLowered
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Bprevious: TBitBtn
      Left = 207
      Top = 2
      Width = 33
      Height = 20
      TabOrder = 3
      OnClick = BpreviousClick
      Glyph.Data = {
        78010000424D7801000000000000760000002800000020000000100000000100
        04000000000000000000120B0000120B00000000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        33333333333333333333333333333333333333333333333333330000}
      NumGlyphs = 2
    end
    object Bnext: TBitBtn
      Left = 247
      Top = 2
      Width = 33
      Height = 20
      TabOrder = 4
      OnClick = BnextClick
      Glyph.Data = {
        78010000424D7801000000000000760000002800000020000000100000000100
        04000000000000000000120B0000120B00000000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        33333333333333333333333333333333333333333333333333330000}
      NumGlyphs = 2
    end
    object Btest: TButton
      Left = 292
      Top = 2
      Width = 51
      Height = 20
      Caption = 'Test'
      TabOrder = 5
      OnClick = BtestClick
    end
    object TabPage: TTabControl
      Left = 353
      Top = 2
      Width = 129
      Height = 21
      Align = alRight
      TabIndex = 0
      TabOrder = 6
      Tabs.Strings = (
        'un'
        'deux'
        'trois')
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 293
    Width = 484
    Height = 16
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 1
    object PanelStatus: TPanel
      Left = 1
      Top = 1
      Width = 482
      Height = 14
      Align = alClient
      BevelOuter = bvLowered
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  inherited PopupNew: TPopupMenu
    Left = 60
    Top = 262
  end
  inherited PopupDestroy: TPopupMenu
    Left = 91
    Top = 262
  end
  inherited PopupMain: TPopupMenu
    Left = 6
    Top = 262
  end
  object MainMenu1: TMainMenu
    Left = 218
    Top = 269
    object File1: TMenuItem
      Caption = 'File'
      ShortCut = 0
      object Load1: TMenuItem
        Caption = 'Load data file'
        ShortCut = 0
        OnClick = Load1Click
      end
      object Gotoepisode1: TMenuItem
        Caption = 'Select episode'
        ShortCut = 0
        OnClick = Gotoepisode1Click
      end
      object Nextfile1: TMenuItem
        Caption = 'Next file'
        ShortCut = 0
        OnClick = Nextfile1Click
      end
      object Previousfile1: TMenuItem
        Caption = 'Previous file'
        ShortCut = 0
        OnClick = Previousfile1Click
      end
      object Informations1: TMenuItem
        Caption = 'Informations'
        ShortCut = 0
        OnClick = Informations1Click
      end
      object Configuration1: TMenuItem
        Caption = 'Configuration'
        ShortCut = 0
        object Load2: TMenuItem
          Caption = 'Load'
          ShortCut = 0
          OnClick = Load2Click
        end
        object Save1: TMenuItem
          Caption = 'Save'
          ShortCut = 0
          OnClick = Save1Click
        end
        object Options2: TMenuItem
          Caption = 'Options'
          ShortCut = 0
        end
      end
      object Print1: TMenuItem
        Caption = 'Print'
        ShortCut = 0
      end
    end
    object Channels1: TMenuItem
      Caption = 'Channels'
      ShortCut = 0
      object v11: TMenuItem
        Tag = 1
        Caption = 'v1'
        ShortCut = 0
        OnClick = v161Click
      end
      object v21: TMenuItem
        Tag = 2
        Caption = 'v2'
        ShortCut = 0
        OnClick = v161Click
      end
      object v31: TMenuItem
        Tag = 3
        Caption = 'v3'
        ShortCut = 0
        OnClick = v161Click
      end
      object v41: TMenuItem
        Tag = 4
        Caption = 'v4'
        ShortCut = 0
        OnClick = v161Click
      end
      object v51: TMenuItem
        Tag = 5
        Caption = 'v5'
        ShortCut = 0
        OnClick = v161Click
      end
      object v61: TMenuItem
        Tag = 6
        Caption = 'v6'
        ShortCut = 0
        OnClick = v161Click
      end
      object v71: TMenuItem
        Tag = 7
        Caption = 'v7'
        ShortCut = 0
        OnClick = v161Click
      end
      object v81: TMenuItem
        Tag = 8
        Caption = 'v8'
        ShortCut = 0
        OnClick = v161Click
      end
      object v91: TMenuItem
        Tag = 9
        Caption = 'v9'
        ShortCut = 0
        OnClick = v161Click
      end
      object v101: TMenuItem
        Tag = 10
        Caption = 'v10'
        ShortCut = 0
        OnClick = v161Click
      end
      object v111: TMenuItem
        Tag = 11
        Caption = 'v11'
        ShortCut = 0
        OnClick = v161Click
      end
      object v121: TMenuItem
        Tag = 12
        Caption = 'v12'
        ShortCut = 0
        OnClick = v161Click
      end
      object v131: TMenuItem
        Tag = 13
        Caption = 'v13'
        ShortCut = 0
        OnClick = v161Click
      end
      object v141: TMenuItem
        Tag = 14
        Caption = 'v14'
        ShortCut = 0
        OnClick = v161Click
      end
      object v151: TMenuItem
        Tag = 15
        Caption = 'v15'
        ShortCut = 0
        OnClick = v161Click
      end
      object v161: TMenuItem
        Tag = 16
        Caption = 'v16'
        ShortCut = 0
        OnClick = v161Click
      end
    end
    object Objects1: TMenuItem
      Caption = 'Objects'
      ShortCut = 0
      object Edit1: TMenuItem
        Caption = 'Inspect'
        ShortCut = 0
        OnClick = Edit1Click
      end
      object New1: TMenuItem
        Caption = 'New'
        ShortCut = 0
        OnClick = New1Click
      end
    end
    object Analysis1: TMenuItem
      Caption = 'Analysis'
      ShortCut = 0
      object Programming1: TMenuItem
        Caption = 'Programming'
        ShortCut = 0
        OnClick = Programming1Click
      end
      object Executeprogram1: TMenuItem
        Caption = 'Execute program'
        ShortCut = 0
        OnClick = Executeprogram1Click
      end
      object Processfile1: TMenuItem
        Caption = 'Process file'
        ShortCut = 0
      end
    end
    object Spreadsheet1: TMenuItem
      Caption = 'Spreadsheet'
      ShortCut = 0
      OnClick = Spreadsheet1Click
    end
  end
end
