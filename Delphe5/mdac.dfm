inherited MainDac: TMainDac
  Left = 691
  Top = 207
  Width = 731
  Height = 592
  Caption = 'Elphy2'
  Menu = MainMenu1
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  inherited PaintBox1: TPaintBox
    Width = 723
    Height = 481
  end
  object PanelBottom: TPanel [1]
    Left = 0
    Top = 512
    Width = 723
    Height = 22
    Align = alBottom
    Caption = 'PanelBottom'
    TabOrder = 0
    object PanelTime: TPanel
      Left = 599
      Top = 1
      Width = 123
      Height = 20
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 0
    end
    object PanelCount: TPanel
      Left = 476
      Top = 1
      Width = 123
      Height = 20
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 1
    end
    object PanelStatus: TPanel
      Left = 1
      Top = 1
      Width = 339
      Height = 20
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 2
    end
    object Psave: TPanel
      Left = 340
      Top = 1
      Width = 136
      Height = 20
      Align = alRight
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  inherited Panel1Top: TPanel
    Width = 723
    TabOrder = 1
    object Pnomdat: TPanel [0]
      Left = 1
      Top = 1
      Width = 113
      Height = 29
      Align = alLeft
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel4: TPanel [1]
      Left = 114
      Top = 1
      Width = 66
      Height = 29
      Align = alLeft
      Caption = 'Episode:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object PanSequence: TPanel [2]
      Left = 180
      Top = 1
      Width = 49
      Height = 29
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object Bprevious: TBitBtn [3]
      Left = 234
      Top = 2
      Width = 40
      Height = 25
      Hint = 'Previous episode Ctrl W'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BpreviousClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object Bnext: TBitBtn [4]
      Left = 277
      Top = 2
      Width = 41
      Height = 25
      Hint = 'Next episode Ctrl X'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = BnextClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    inherited TabPage1: TTabControl
      Left = 487
      TabOrder = 5
    end
    inherited Bprint: TBitBtn
      Left = 370
      Top = 2
      Height = 26
      TabOrder = 6
    end
    object Bexe: TBitBtn
      Left = 327
      Top = 2
      Width = 40
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = Executeprogram1Click
      Glyph.Data = {
        76050000424D7605000000000000360400002800000012000000100000000100
        0800000000004001000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6000020400000206000002080000020A0000020C0000020E000004000000040
        20000040400000406000004080000040A0000040C0000040E000006000000060
        20000060400000606000006080000060A0000060C0000060E000008000000080
        20000080400000806000008080000080A0000080C0000080E00000A0000000A0
        200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
        200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
        200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
        20004000400040006000400080004000A0004000C0004000E000402000004020
        20004020400040206000402080004020A0004020C0004020E000404000004040
        20004040400040406000404080004040A0004040C0004040E000406000004060
        20004060400040606000406080004060A0004060C0004060E000408000004080
        20004080400040806000408080004080A0004080C0004080E00040A0000040A0
        200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
        200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
        200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
        20008000400080006000800080008000A0008000C0008000E000802000008020
        20008020400080206000802080008020A0008020C0008020E000804000008040
        20008040400080406000804080008040A0008040C0008040E000806000008060
        20008060400080606000806080008060A0008060C0008060E000808000008080
        20008080400080806000808080008080A0008080C0008080E00080A0000080A0
        200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
        200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
        200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
        2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
        2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
        2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
        2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
        2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
        2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
        2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000FFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF0000FFFFFFFFFFFF
        FF0000000000FFFF0000FFFF0000FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF
        0000FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF0000FFFFFFFFFFFF0000FF00
        0000FFFF0000FFFF0000000000FFFFFF0000FFFFFFFFFFFF0000FFFF0000FFFF
        0000FFFF0000FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
        0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF
        FF00000000FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
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
    Left = 152
    Top = 256
    object File1: TMenuItem
      Caption = 'File'
      OnClick = File1Click
      object Load1: TMenuItem
        Caption = 'Load data file'
        OnClick = Load1Click
      end
      object LoadBinaryFile1: TMenuItem
        Caption = 'Load Binary File'
        object Load3: TMenuItem
          Caption = 'Load'
          OnClick = LoadBinaryFile1Click
        end
        object Parameters1: TMenuItem
          Caption = 'Parameters'
          OnClick = Parameters1Click
        end
      end
      object Shortcuts1: TMenuItem
        Caption = 'Shortcuts'
        Visible = False
        object Nextepisode1: TMenuItem
          Caption = 'Next episode'
          ShortCut = 16472
          Visible = False
          OnClick = BnextClick
        end
        object Previousepisode1: TMenuItem
          Caption = 'Previous episode'
          ShortCut = 16471
          Visible = False
          OnClick = BpreviousClick
        end
        object ssu1: TMenuItem
          Tag = 1
          Caption = 'ssu1'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu2: TMenuItem
          Tag = 2
          Caption = 'ssu2'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu3: TMenuItem
          Tag = 3
          Caption = 'ssu3'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu4: TMenuItem
          Tag = 4
          Caption = 'ssu4'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu5: TMenuItem
          Tag = 5
          Caption = 'ssu5'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu6: TMenuItem
          Tag = 6
          Caption = 'ssu6'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu7: TMenuItem
          Tag = 7
          Caption = 'ssu7'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu8: TMenuItem
          Tag = 8
          Caption = 'ssu8'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu9: TMenuItem
          Tag = 9
          Caption = 'ssu9'
          Visible = False
          OnClick = ssu5Click
        end
        object ssu10: TMenuItem
          Tag = 10
          Caption = 'ssu10'
          Visible = False
          OnClick = ssu5Click
        end
      end
      object Gotoepisode1: TMenuItem
        Caption = 'Select episode'
        OnClick = Gotoepisode1Click
      end
      object Nextfile1: TMenuItem
        Caption = 'Next file'
        OnClick = Nextfile1Click
      end
      object Previousfile1: TMenuItem
        Caption = 'Previous file'
        OnClick = Previousfile1Click
      end
      object Informations1: TMenuItem
        Caption = 'Informations'
        OnClick = Informations1Click
      end
      object Properties1: TMenuItem
        Caption = 'Properties'
        OnClick = Properties1Click
      end
      object Configuration1: TMenuItem
        Caption = 'Configuration'
        object New2: TMenuItem
          Caption = 'New'
          OnClick = New2Click
        end
        object Load2: TMenuItem
          Caption = 'Load'
          OnClick = Load2Click
        end
        object Save1: TMenuItem
          Caption = 'Save'
          OnClick = Save1Click
        end
        object Options2: TMenuItem
          Caption = 'Options'
          OnClick = Options2Click
        end
        object N2: TMenuItem
          Caption = '-'
        end
      end
      object Print1: TMenuItem
        Caption = 'Print'
        OnClick = BprintClick
      end
      object Copy1: TMenuItem
        Caption = 'Copy'
        OnClick = Copy1Click
      end
      object Play1: TMenuItem
        Caption = 'Play'
        OnClick = Play1Click
      end
      object Debug1: TMenuItem
        Caption = 'Debug'
        OnClick = Debug1Click
      end
      object setElphyServer: TMenuItem
        Caption = 'Elphy Server'
        OnClick = setElphyServerClick
      end
      object Quit1: TMenuItem
        Caption = 'Quit'
        OnClick = Quit1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
    object Averaging1: TMenuItem
      Caption = 'Averaging'
      OnClick = Averaging1Click
    end
    object Objects1: TMenuItem
      Caption = 'Objects'
      OnClick = Objects1Click
      object Edit1: TMenuItem
        Caption = 'Inspect'
        OnClick = Edit1Click
      end
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object ObjectFiles1: TMenuItem
        Caption = 'Object Files'
        object Open1: TMenuItem
          Caption = 'New'
        end
        object CloseAll1: TMenuItem
          Caption = 'Close All'
          OnClick = CloseAll1Click
        end
      end
    end
    object Analysis1: TMenuItem
      Caption = 'Anal&ysis'
      object Programming1: TMenuItem
        Caption = 'Programming'
        OnClick = Programming1Click
      end
      object Executeprogram1: TMenuItem
        Caption = 'Execute program'
        OnClick = Executeprogram1Click
      end
      object Processfile1: TMenuItem
        Caption = 'Process file'
        OnClick = Processfile1Click
      end
      object InstallTools1: TMenuItem
        Caption = 'Install tools'
        OnClick = InstallTools1Click
      end
      object Programreset1: TMenuItem
        Caption = 'Program reset'
        OnClick = Programreset1Click
      end
      object ShowCommands1: TMenuItem
        Caption = 'Show Commands'
        OnClick = ShowCommands1Click
      end
      object ShowErrorMessages1: TMenuItem
        Caption = 'Show Error Messages'
        OnClick = ShowErrorMessages1Click
      end
    end
    object Spreadsheet1: TMenuItem
      Caption = 'Spreadsheet'
      OnClick = Spreadsheet1Click
    end
    object DacAcq1: TMenuItem
      Caption = 'Ac&quisition'
      OnClick = DacAcq1Click
      object DacAcqParams: TMenuItem
        Caption = 'Parameters'
        OnClick = DacAcqParamsClick
      end
      object DacStim1: TMenuItem
        Caption = 'Stimulation'
        OnClick = DacStim1Click
      end
      object Visualstim1: TMenuItem
        Caption = 'Visual stimulation'
        OnClick = Visualstim1Click
      end
      object Start1: TMenuItem
        Caption = 'Start (display only)'
        OnClick = Start1Click
      end
      object Startandsave1: TMenuItem
        Caption = 'Start and save (new file)'
        OnClick = Startandsave1Click
      end
      object Continue1: TMenuItem
        Caption = 'Start and save (same file)'
        Enabled = False
        OnClick = Continue1Click
      end
      object Controlpanel1: TMenuItem
        Caption = 'Control panel'
        OnClick = Controlpanel1Click
      end
      object Comments1: TMenuItem
        Caption = 'Comments'
      end
      object Systemdac1: TMenuItem
        Caption = 'System'
        OnClick = Systemdac1Click
      end
      object RTNeuronParameters1: TMenuItem
        Caption = 'RT-Neuron Parameters'
        OnClick = RTNeuronParameters1Click
      end
      object ShowConsole1: TMenuItem
        Caption = 'Show Neuron Console'
        OnClick = ShowConsole1Click
      end
      object RestartNeuron: TMenuItem
        Caption = 'Restart Neuron'
        OnClick = ResetNeuronClick
      end
      object Ass: TMenuItem
        Caption = 'Ass'
        Visible = False
        object ass0: TMenuItem
          Caption = 'ass0'
          Visible = False
          OnClick = ass9Click
        end
        object ass1: TMenuItem
          Tag = 1
          Caption = 'ass1'
          Visible = False
          OnClick = ass9Click
        end
        object ass2: TMenuItem
          Tag = 2
          Caption = 'ass2'
          Visible = False
          OnClick = ass9Click
        end
        object ass3: TMenuItem
          Tag = 3
          Caption = 'ass3'
          Visible = False
          OnClick = ass9Click
        end
        object ass4: TMenuItem
          Tag = 4
          Caption = 'ass4'
          Visible = False
          OnClick = ass9Click
        end
        object ass5: TMenuItem
          Tag = 5
          Caption = 'ass5'
          Visible = False
          OnClick = ass9Click
        end
        object ass6: TMenuItem
          Tag = 6
          Caption = 'ass6'
          Visible = False
          OnClick = ass9Click
        end
        object ass7: TMenuItem
          Tag = 7
          Caption = 'ass7'
          Visible = False
          OnClick = ass9Click
        end
        object ass8: TMenuItem
          Tag = 8
          Caption = 'ass8'
          Visible = False
          OnClick = ass9Click
        end
        object ass9: TMenuItem
          Tag = 9
          Caption = 'ass9'
          Visible = False
          OnClick = ass9Click
        end
      end
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      object ToolsFile1: TMenuItem
        Caption = 'File'
      end
    end
    object StandardColors1: TMenuItem
      Caption = 'Display'
      object StandardColors2: TMenuItem
        Caption = 'Standard Colors'
        OnClick = StandardColors2Click
      end
      object DefaultColors1: TMenuItem
        Caption = 'Default Colors'
        OnClick = DefaultColors1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Introduction1: TMenuItem
        Caption = 'Elphy Help'
        OnClick = Introduction1Click
      end
      object Programming2: TMenuItem
        Caption = 'Programming'
        OnClick = Programming2Click
      end
      object About1: TMenuItem
        Caption = 'About Elphy'
        OnClick = About1Click
      end
    end
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 200
    Top = 344
  end
  object MRUdat: TadpMRU
    ParentMenuItem = File1
    OnClick = MRUdatClick
    Left = 56
    Top = 360
  end
  object MRUcfg: TadpMRU
    ParentMenuItem = Configuration1
    OnClick = MRUcfgClick
    Left = 112
    Top = 360
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 240
    Top = 344
  end
end
