object paramAcq: TparamAcq
  Left = 429
  Top = 154
  BorderStyle = bsDialog
  Caption = 'Acquisition parameters'
  ClientHeight = 344
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bok: TButton
    Left = 140
    Top = 289
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 228
    Top = 289
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 457
    Height = 281
    ActivePage = TabSChannels
    Align = alTop
    TabOrder = 2
    object TabSgeneral: TTabSheet
      Caption = 'General'
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 449
        Height = 249
        Align = alTop
        TabOrder = 0
        object Label19: TLabel
          Left = 23
          Top = 18
          Width = 30
          Height = 13
          Caption = 'Mode:'
        end
        object Lnbvoie: TLabel
          Left = 22
          Top = 71
          Width = 69
          Height = 13
          Caption = 'Channel count'
        end
        object Lduree: TLabel
          Left = 22
          Top = 94
          Width = 62
          Height = 13
          Caption = 'Duration (ms)'
        end
        object Lperiod: TLabel
          Left = 22
          Top = 141
          Width = 111
          Height = 13
          Caption = 'Period per channel (ms)'
        end
        object Lnbpt: TLabel
          Left = 22
          Top = 116
          Width = 102
          Height = 13
          Caption = 'Samples per channel:'
        end
        object Lnbav: TLabel
          Left = 22
          Top = 185
          Width = 108
          Height = 13
          Caption = 'Samples before trigger:'
        end
        object LepCount: TLabel
          Left = 22
          Top = 47
          Width = 68
          Height = 13
          Caption = 'Episode count'
        end
        object Lmaxduration: TLabel
          Left = 23
          Top = 164
          Width = 90
          Height = 13
          Caption = 'Max. duration (sec)'
        end
        object cbModeAcq: TcomboBoxV
          Left = 60
          Top = 15
          Width = 98
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbModeAcqChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enNbvoie: TeditNum
          Left = 139
          Top = 68
          Width = 108
          Height = 21
          TabOrder = 1
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDuree: TeditNum
          Left = 139
          Top = 91
          Width = 108
          Height = 21
          TabOrder = 2
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enPeriod: TeditNum
          Left = 139
          Top = 137
          Width = 108
          Height = 21
          TabOrder = 3
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enNbpt: TeditNum
          Left = 139
          Top = 114
          Width = 108
          Height = 21
          TabOrder = 4
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enNbAv: TeditNum
          Left = 139
          Top = 183
          Width = 108
          Height = 21
          TabOrder = 5
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbStim: TCheckBoxV
          Left = 21
          Top = 206
          Width = 131
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Stimulate'
          TabOrder = 6
          OnClick = BcheckClick
          UpdateVarOnToggle = False
        end
        object enEpCount: TeditNum
          Left = 139
          Top = 45
          Width = 108
          Height = 21
          TabOrder = 7
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enMaxDuration: TeditNum
          Left = 139
          Top = 160
          Width = 108
          Height = 21
          TabOrder = 8
          OnEnter = BcheckClick
          OnExit = BcheckClick
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object GroupBox9: TGroupBox
          Left = 254
          Top = 39
          Width = 185
          Height = 130
          Caption = 'Calculated values'
          TabOrder = 9
          object Lfreq: TLabel
            Left = 10
            Top = 19
            Width = 53
            Height = 13
            Caption = 'Frequency:'
          end
          object Lperiode: TLabel
            Left = 10
            Top = 37
            Width = 30
            Height = 13
            Caption = 'Period'
          end
          object Lduration: TLabel
            Left = 10
            Top = 56
            Width = 40
            Height = 13
            Caption = 'Duration'
          end
          object Lpretrig: TLabel
            Left = 10
            Top = 76
            Width = 71
            Height = 13
            Caption = 'Pretrig.duration'
          end
          object Lwarning: TLabel
            Left = 10
            Top = 99
            Width = 43
            Height = 13
            Caption = 'Lwarning'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
        end
        object Bcheck: TButton
          Left = 256
          Top = 190
          Width = 41
          Height = 15
          Caption = 'Check'
          TabOrder = 10
          OnClick = BcheckClick
        end
        object Boptions: TButton
          Left = 254
          Top = 15
          Width = 75
          Height = 20
          Caption = 'Options'
          TabOrder = 11
          OnClick = BoptionsClick
        end
        object cbSound: TCheckBoxV
          Left = 21
          Top = 225
          Width = 131
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Record sound'
          TabOrder = 12
          OnClick = BcheckClick
          UpdateVarOnToggle = False
        end
      end
    end
    object TabStrigger: TTabSheet
      Caption = 'Trigger'
      object GroupBox5: TGroupBox
        Left = 0
        Top = -3
        Width = 411
        Height = 203
        TabOrder = 0
        object Label25: TLabel
          Left = 23
          Top = 18
          Width = 30
          Height = 13
          Caption = 'Mode:'
        end
        object LvoieSync: TLabel
          Left = 22
          Top = 47
          Width = 73
          Height = 13
          Caption = 'analog channel'
        end
        object LseuilHaut: TLabel
          Left = 22
          Top = 70
          Width = 75
          Height = 13
          Caption = 'Upper threshold'
        end
        object LseuilBas: TLabel
          Left = 23
          Top = 95
          Width = 75
          Height = 13
          Caption = 'Lower threshold'
        end
        object LtestInt: TLabel
          Left = 22
          Top = 119
          Width = 58
          Height = 13
          Caption = 'Test interval'
        end
        object Label6: TLabel
          Left = 22
          Top = 141
          Width = 27
          Height = 13
          Caption = 'Delay'
        end
        object cbModeTrig: TcomboBoxV
          Left = 61
          Top = 14
          Width = 142
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = cbModeTrigChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enVoieSync: TeditNum
          Left = 139
          Top = 45
          Width = 106
          Height = 21
          TabOrder = 1
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enSeuilHaut: TeditNum
          Left = 139
          Top = 68
          Width = 106
          Height = 21
          TabOrder = 2
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enSeuilBas: TeditNum
          Left = 139
          Top = 91
          Width = 106
          Height = 21
          TabOrder = 3
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enTestInt: TeditNum
          Left = 139
          Top = 114
          Width = 106
          Height = 21
          TabOrder = 4
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDelay: TeditNum
          Left = 139
          Top = 137
          Width = 106
          Height = 21
          TabOrder = 5
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
    object TabSChannels: TTabSheet
      Caption = 'Channels'
      object TabNumC: TTabControl
        Left = 0
        Top = 0
        Width = 449
        Height = 253
        Align = alClient
        TabOrder = 0
        Tabs.Strings = (
          '1'
          '2 '
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16')
        TabIndex = 0
        TabWidth = 22
        OnChange = TabNumCChange
        object Label31: TLabel
          Left = 19
          Top = 150
          Width = 118
          Height = 13
          Caption = 'Physical channel number'
        end
        object LabelRange: TLabel
          Left = 20
          Top = 172
          Width = 32
          Height = 13
          Caption = 'Range'
        end
        object Label7: TLabel
          Left = 19
          Top = 194
          Width = 102
          Height = 13
          Caption = 'Down-sampling factor'
        end
        object Label9: TLabel
          Left = 248
          Top = 148
          Width = 24
          Height = 13
          Caption = 'Type'
        end
        object GroupBox6: TGroupBox
          Left = 20
          Top = 32
          Width = 318
          Height = 107
          Caption = 'Vertical scaling factors'
          TabOrder = 0
          object Label32: TLabel
            Left = 8
            Top = 53
            Width = 8
            Height = 13
            Caption = 'j='
          end
          object Label33: TLabel
            Left = 108
            Top = 55
            Width = 85
            Height = 13
            Caption = 'Corresponds to y='
          end
          object Label34: TLabel
            Left = 8
            Top = 78
            Width = 8
            Height = 13
            Caption = 'j='
          end
          object Label35: TLabel
            Left = 107
            Top = 79
            Width = 85
            Height = 13
            Caption = 'Corresponds to y='
          end
          object Label36: TLabel
            Left = 7
            Top = 25
            Width = 27
            Height = 13
            Caption = 'Units:'
          end
          object enJ1: TeditNum
            Left = 40
            Top = 51
            Width = 58
            Height = 21
            TabOrder = 0
            Text = '1'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enY1: TeditNum
            Left = 198
            Top = 51
            Width = 87
            Height = 21
            TabOrder = 1
            Text = '1123456789'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enJ2: TeditNum
            Left = 40
            Top = 75
            Width = 58
            Height = 21
            TabOrder = 2
            Text = '2'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enY2: TeditNum
            Left = 198
            Top = 75
            Width = 87
            Height = 21
            TabOrder = 3
            Text = '1123456789'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object esUnits: TeditString
            Left = 47
            Top = 22
            Width = 88
            Height = 21
            TabOrder = 4
            Text = 'mV'
            len = 0
            UpdateVarOnExit = False
          end
        end
        object enVoiePhys: TeditNum
          Left = 165
          Top = 146
          Width = 53
          Height = 21
          TabOrder = 1
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbGain: TcomboBoxV
          Left = 64
          Top = 168
          Width = 154
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enKS: TeditNum
          Left = 165
          Top = 190
          Width = 53
          Height = 21
          TabOrder = 3
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbType: TcomboBoxV
          Left = 286
          Top = 145
          Width = 116
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          OnChange = cbTypeChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object EventPanel: TPanel
          Left = 238
          Top = 168
          Width = 201
          Height = 73
          BevelOuter = bvNone
          TabOrder = 5
          object Label2: TLabel
            Left = 10
            Top = 4
            Width = 47
            Height = 13
            Caption = 'Threshold'
          end
          object Label12: TLabel
            Left = 10
            Top = 27
            Width = 48
            Height = 13
            Caption = 'Hysteresis'
          end
          object enThreshold: TeditNum
            Left = 69
            Top = 1
            Width = 95
            Height = 21
            TabOrder = 0
            Text = '000'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enHys: TeditNum
            Left = 69
            Top = 25
            Width = 95
            Height = 21
            TabOrder = 1
            Text = '000'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object cbRising: TCheckBoxV
            Left = 9
            Top = 48
            Width = 155
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Rising edge'
            TabOrder = 2
            UpdateVarOnToggle = False
          end
        end
      end
    end
    object TabSfiles: TTabSheet
      Caption = 'Data file'
      object Label3: TLabel
        Left = 15
        Top = 117
        Width = 120
        Height = 13
        Caption = 'File information block size'
      end
      object Label4: TLabel
        Left = 15
        Top = 139
        Width = 142
        Height = 13
        Caption = 'Episode information block size'
      end
      object Label5: TLabel
        Left = 15
        Top = 161
        Width = 102
        Height = 13
        Caption = 'Minimal comment size'
      end
      object Label8: TLabel
        Left = 16
        Top = 195
        Width = 48
        Height = 13
        Caption = 'File format'
      end
      object GroupBox1: TGroupBox
        Left = 6
        Top = 5
        Width = 403
        Height = 50
        Caption = 'Generic file name'
        TabOrder = 0
        object cbGenAcq: TComboBox
          Left = 7
          Top = 20
          Width = 325
          Height = 21
          ItemHeight = 0
          TabOrder = 0
          Text = 'cbGenAcq'
          OnEnter = cbGenAcqEnter
          OnExit = cbGenAcqEnter
        end
        object Bbrowse: TButton
          Left = 339
          Top = 21
          Width = 52
          Height = 20
          Caption = 'Browse'
          TabOrder = 1
          OnClick = BbrowseClick
        end
      end
      object cbValidate: TCheckBoxV
        Left = 12
        Top = 72
        Width = 174
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Validate at end of acquisition:'
        TabOrder = 1
        UpdateVarOnToggle = False
      end
      object cbClearEntireFile: TCheckBoxV
        Left = 12
        Top = 92
        Width = 174
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Clear entire file if not validated'
        TabOrder = 2
        UpdateVarOnToggle = False
      end
      object enFileInfo: TeditNum
        Left = 173
        Top = 115
        Width = 108
        Height = 21
        TabOrder = 3
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enEpInfo: TeditNum
        Left = 173
        Top = 137
        Width = 108
        Height = 21
        TabOrder = 4
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enCommentSize: TeditNum
        Left = 173
        Top = 159
        Width = 108
        Height = 21
        TabOrder = 5
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbFileFormat: TcomboBoxV
        Left = 173
        Top = 190
        Width = 110
        Height = 21
        ItemHeight = 0
        TabOrder = 6
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Comment'
      object MemoComment: TMemo
        Left = 8
        Top = 6
        Width = 433
        Height = 226
        Lines.Strings = (
          '')
        TabOrder = 0
      end
    end
    object TabSprocess: TTabSheet
      Caption = 'Process'
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 449
        Height = 225
        Align = alTop
        TabOrder = 0
        object cbProcess: TCheckBoxV
          Left = 9
          Top = 19
          Width = 192
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Execute program loaded in editor'
          TabOrder = 0
          UpdateVarOnToggle = False
        end
        object GroupBox3: TGroupBox
          Left = 7
          Top = 48
          Width = 333
          Height = 123
          Caption = 'Clear following objects before acquisition:'
          TabOrder = 1
          object lbClear: TListBox
            Left = 8
            Top = 17
            Width = 212
            Height = 97
            ItemHeight = 13
            TabOrder = 0
          end
          object BaddClear: TButton
            Left = 241
            Top = 22
            Width = 75
            Height = 20
            Caption = 'Add'
            TabOrder = 1
            OnClick = BaddClearClick
          end
          object BremoveClear: TButton
            Left = 240
            Top = 48
            Width = 75
            Height = 20
            Caption = 'Remove'
            TabOrder = 2
            OnClick = BremoveClearClick
          end
        end
      end
    end
    object TabSDisplay: TTabSheet
      Caption = 'Display'
      object cbDisplay: TCheckBoxV
        Left = 269
        Top = 38
        Width = 155
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Display data'
        TabOrder = 0
        UpdateVarOnToggle = False
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 29
        Width = 247
        Height = 172
        Caption = 'Track following objects'
        TabOrder = 1
        object lbRefresh: TListBox
          Left = 14
          Top = 17
          Width = 216
          Height = 116
          ItemHeight = 13
          TabOrder = 0
        end
        object BaddRefresh: TButton
          Left = 31
          Top = 140
          Width = 75
          Height = 20
          Caption = 'Add'
          TabOrder = 1
          OnClick = BaddRefreshClick
        end
        object BremoveRefresh: TButton
          Left = 119
          Top = 140
          Width = 75
          Height = 20
          Caption = 'Remove'
          TabOrder = 2
          OnClick = BremoveRefreshClick
        end
      end
      object cbImmediate: TCheckBoxV
        Left = 269
        Top = 57
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Immediate display'
        TabOrder = 2
        UpdateVarOnToggle = False
      end
      object cbHold: TCheckBoxV
        Left = 269
        Top = 95
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Hold traces'
        TabOrder = 3
        UpdateVarOnToggle = False
      end
      object cbCycled: TCheckBoxV
        Left = 269
        Top = 76
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Cycled display'
        TabOrder = 4
        UpdateVarOnToggle = False
      end
      object cbControlPanel: TCheckBoxV
        Left = 269
        Top = 113
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show control panel'
        TabOrder = 5
        UpdateVarOnToggle = False
      end
      object cbTriggerPos: TCheckBoxV
        Left = 269
        Top = 132
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show trigger position'
        TabOrder = 6
        UpdateVarOnToggle = False
      end
    end
  end
end
