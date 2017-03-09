object edit5: Tedit5
  Left = 620
  Top = 213
  Width = 608
  Height = 453
  Caption = 'edit5'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu2
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 376
    Top = 328
    Width = 23
    Height = 22
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 386
    Width = 600
    Height = 19
    Panels = <
      item
        Width = 70
      end
      item
        Width = 70
      end
      item
        Width = 70
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 600
    Height = 386
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
    OnExit = PageControl1Exit
    OnMouseDown = PageControl1MouseDown
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Options = [fdEffects, fdFixedPitchOnly]
    Left = 339
    Top = 200
  end
  object MainMenu2: TMainMenu
    Left = 395
    Top = 200
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Load1: TMenuItem
        Caption = 'Load'
        ShortCut = 114
        OnClick = Load1Click
      end
      object save1: TMenuItem
        Caption = 'Save'
        ShortCut = 113
        OnClick = save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as'
        OnClick = Saveas1Click
      end
      object Saveall1: TMenuItem
        Caption = 'Save all'
        ShortCut = 8305
        OnClick = Saveall1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
      object Closeall1: TMenuItem
        Caption = 'Close all'
        OnClick = Closeall1Click
      end
      object Print1: TMenuItem
        Caption = 'Print'
        object Printsetup2: TMenuItem
          Caption = 'Print setup'
          OnClick = Printsetup1Click
        end
        object Font2: TMenuItem
          Caption = 'Font'
          OnClick = Font2Click
        end
        object Print2: TMenuItem
          Caption = 'Print'
          OnClick = Print1Click
        end
      end
      object N1: TMenuItem
        Caption = '-'
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
      object N2: TMenuItem
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
    object Search1: TMenuItem
      Caption = 'Search'
      object Find1: TMenuItem
        Caption = 'Find'
        ShortCut = 16454
        OnClick = Find1Click
      end
      object FindNext1: TMenuItem
        Caption = 'Find next'
        ShortCut = 16460
        OnClick = FindNext1Click
      end
      object Replace1: TMenuItem
        Caption = 'Replace'
        ShortCut = 24641
        OnClick = Replace1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Font1: TMenuItem
        Caption = 'Font'
        OnClick = Font1Click
      end
      object Colors1: TMenuItem
        Caption = 'Colors'
        OnClick = Colors1Click
      end
      object Directories1: TMenuItem
        Caption = 'Directories'
        OnClick = Directories1Click
      end
    end
    object Program1: TMenuItem
      Caption = 'Program'
      OnClick = Program1Click
      object Compile1: TMenuItem
        Caption = 'Compile current file'
        OnClick = Compile1Click
      end
      object Build1: TMenuItem
        Caption = 'Compile'
        ShortCut = 120
        OnClick = Build1Click
      end
      object Build2: TMenuItem
        Caption = 'Build'
        OnClick = Build2Click
      end
      object Primaryfile1: TMenuItem
        Caption = 'Primary file'
        object Choose1: TMenuItem
          Caption = 'Choose'
          OnClick = Primaryfile1Click
        end
        object Clear1: TMenuItem
          Caption = 'Clear'
          OnClick = Clear1Click
        end
      end
      object Info1: TMenuItem
        Caption = 'Information'
        object Sizes1: TMenuItem
          Caption = 'Sizes'
          OnClick = Sizes1Click
        end
        object Code2: TMenuItem
          Caption = 'Code'
          OnClick = Code2Click
        end
        object Symbols2: TMenuItem
          Caption = 'Symbols'
          OnClick = Symbols2Click
        end
        object Adlist1: TMenuItem
          Caption = 'Adlist'
          OnClick = Adlist1Click
        end
        object Ulist1: TMenuItem
          Caption = 'Ulist'
          OnClick = Ulist1Click
        end
        object CompiledFiles1: TMenuItem
          Caption = 'Compiled Files '
          OnClick = CompiledFiles1Click
        end
        object Lasterrormessage1: TMenuItem
          Caption = 'Error messages'
          OnClick = Lasterrormessage1Click
        end
      end
      object ShowCommands1: TMenuItem
        Caption = 'Show Commands'
        OnClick = ShowCommands1Click
      end
    end
    object Run1: TMenuItem
      Caption = 'Run'
      object Execute2: TMenuItem
        Caption = 'Execute'
        ShortCut = 16504
        OnClick = Execute1Click
      end
      object ProgramReset2: TMenuItem
        Caption = 'Program Reset'
        ShortCut = 16497
        OnClick = Programreset1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Debug1: TMenuItem
        Caption = 'Enter Debug Mode'
        OnClick = Debug1Click
      end
      object StepOver1: TMenuItem
        Caption = 'Step Over'
        ShortCut = 119
        OnClick = StepOver1Click
      end
      object TraceInto1: TMenuItem
        Caption = 'Trace Into'
        ShortCut = 118
        OnClick = TraceInto1Click
      end
      object StopDebug1: TMenuItem
        Caption = 'Stop Program'
        OnClick = StopDebug1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object AddBreakPoint1: TMenuItem
        Caption = 'Add BreakPoint'
        OnClick = AddBreakPoint1Click
      end
      object ClearBreakPointlist1: TMenuItem
        Caption = 'Clear BreakPoint list'
        OnClick = ClearBreakPointlist1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Editorhelp1: TMenuItem
        Caption = 'Editor help'
        OnClick = Editorhelp1Click
      end
      object Programhelp1: TMenuItem
        Caption = 'Program help'
        OnClick = Programhelp1Click
      end
    end
  end
  object RPopup: TPopupMenu
    Left = 333
    Top = 246
    object FindDeclaration1: TMenuItem
      Caption = 'Find Declaration'
      OnClick = FindDeclaration1Click
    end
    object Help2: TMenuItem
      Caption = 'Program help'
      OnClick = Help2Click
    end
    object Openfileatcursor1: TMenuItem
      Caption = 'Open file at cursor'
      OnClick = Openfileatcursor1Click
    end
    object Evaluate2: TMenuItem
      Caption = 'Evaluate word at cursor'
      ShortCut = 16499
      OnClick = Evaluate1Click
    end
    object Evaluateselection1: TMenuItem
      Caption = 'Evaluate selection'
      OnClick = Evaluateselection1Click
    end
    object Setasprimaryfile1: TMenuItem
      Caption = 'Set as primary file'
      OnClick = Setasprimaryfile1Click
    end
    object Splitprimaryfile1: TMenuItem
      Caption = 'Split primary file'
      OnClick = Splitprimaryfile1Click
    end
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 401
    Top = 250
  end
  object adpMRU1: TadpMRU
    ParentMenuItem = File1
    OnClick = adpMRU1Click
    Left = 224
    Top = 256
  end
  object GutterMenu: TPopupMenu
    Left = 88
    Top = 256
    object AddBreakPoint2: TMenuItem
      Caption = 'Add BreakPoint'
      OnClick = AddBreakPoint1Click
    end
  end
end
