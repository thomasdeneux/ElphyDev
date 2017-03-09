object consoleE: TconsoleE
  Left = 968
  Top = 262
  Width = 600
  Height = 437
  Caption = 'consoleE'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 368
    Width = 592
    Height = 23
    Align = alBottom
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 21
      Align = alLeft
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 186
      Top = 1
      Width = 185
      Height = 21
      Align = alLeft
      TabOrder = 1
    end
  end
  object Editor: TSynEdit
    Left = 0
    Top = 0
    Width = 592
    Height = 368
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    OnKeyDown = EditorKeyDown
    OnMouseDown = EditorMouseDown
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    OnProcessCommand = EditorProcessCommand
  end
  object MainMenu1: TMainMenu
    Left = 448
    Top = 368
    object File1: TMenuItem
      Caption = 'File'
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Clear1: TMenuItem
        Caption = 'Clear'
        OnClick = Clear1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Undo1: TMenuItem
        Caption = 'Undo'
        OnClick = Undo1Click
      end
      object Redo1: TMenuItem
        Caption = 'Redo'
        OnClick = Redo1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Copy1: TMenuItem
        Caption = 'Copy'
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = 'Paste'
        OnClick = Paste1Click
      end
      object Cut1: TMenuItem
        Caption = 'Cut'
        OnClick = Cut1Click
      end
    end
    object S1: TMenuItem
      Caption = 'Search'
      object Find1: TMenuItem
        Caption = 'Find'
        ShortCut = 16454
        OnClick = Find1Click
      end
      object FindNext1: TMenuItem
        Caption = 'Find Next'
        ShortCut = 16460
        OnClick = FindNext1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Font1: TMenuItem
        Caption = 'Font'
      end
      object Colors1: TMenuItem
        Caption = 'Colors'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
    object Debug1: TMenuItem
      Caption = 'Debug'
      Visible = False
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 520
    Top = 364
    object ProgramHelp1: TMenuItem
      Caption = 'Program Help'
      OnClick = ProgramHelp1Click
    end
  end
end
