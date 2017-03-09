object edit4: Tedit4
  Left = 276
  Top = 112
  Width = 544
  Height = 375
  Caption = 'edit4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu2
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 310
    Width = 536
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
    Width = 536
    Height = 310
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
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
    Left = 371
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
      object Delete1: TMenuItem
        Caption = 'Delete'
        OnClick = Delete1Click
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
        ShortCut = 16449
        OnClick = Replace1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Font1: TMenuItem
        Caption = 'Font'
        OnClick = Font1Click
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
      object Execute1: TMenuItem
        Caption = 'Execute '
        ShortCut = 16504
        OnClick = Execute1Click
      end
      object Evaluate1: TMenuItem
        Caption = 'Evaluate'
        ShortCut = 16499
        OnClick = Evaluate1Click
      end
      object Programreset1: TMenuItem
        Caption = 'Program reset'
        ShortCut = 16497
        OnClick = Programreset1Click
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
          Caption = 'Last error message'
          OnClick = Lasterrormessage1Click
        end
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
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      (
        1584
        0
        2056
        72
        1037
        256)
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 2000
    Left = 409
    Top = 200
  end
  object OvcMenuMRU1: TOvcMenuMRU
    AddPosition = apBottom
    Enabled = True
    GroupIndex = 0
    MenuItem = File1
    Options = [moAddAccelerators, moAddSeparator]
    Visible = True
    OnClick = OvcMenuMRU1Click
    Left = 461
    Top = 212
  end
  object RPopup: TPopupMenu
    Left = 333
    Top = 246
    object Help2: TMenuItem
      Caption = 'Program help'
      OnClick = Help2Click
    end
    object Open1: TMenuItem
      Caption = 'Open editor with the same file'
      OnClick = Open1Click
    end
    object Openfileatcursor1: TMenuItem
      Caption = 'Open file at cursor'
      OnClick = Openfileatcursor1Click
    end
    object Evaluate2: TMenuItem
      Caption = 'Evaluate '
      OnClick = Evaluate1Click
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
    Left = 385
    Top = 250
  end
end
