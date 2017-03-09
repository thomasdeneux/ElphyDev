object paramAcq: TparamAcq
  Left = 651
  Top = 238
  BorderStyle = bsDialog
  Caption = 'Acquisition parameters'
  ClientHeight = 384
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bok: TButton
    Left = 148
    Top = 324
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 228
    Top = 324
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 465
    Height = 313
    ActivePage = TabSChannels
    Align = alTop
    TabOrder = 2
    object TabSgeneral: TTabSheet
      Caption = 'General'
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 457
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
          Top = 72
          Width = 69
          Height = 13
          Caption = 'Channel count'
        end
        object Lduree: TLabel
          Left = 22
          Top = 118
          Width = 62
          Height = 13
          Caption = 'Duration (ms)'
        end
        object Lperiod: TLabel
          Left = 22
          Top = 95
          Width = 111
          Height = 13
          Caption = 'Period per channel (ms)'
        end
        object Lnbav: TLabel
          Left = 22
          Top = 141
          Width = 77
          Height = 13
          Caption = 'Pre-trig. duration'
        end
        object LepCount: TLabel
          Left = 22
          Top = 49
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
          Top = 114
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
          Top = 91
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
        object enDureeAv: TeditNum
          Left = 139
          Top = 137
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
        object cbStim: TCheckBoxV
          Left = 21
          Top = 184
          Width = 131
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Stimulate'
          TabOrder = 5
          OnClick = BcheckClick
          UpdateVarOnToggle = False
        end
        object enEpCount: TeditNum
          Left = 139
          Top = 45
          Width = 108
          Height = 21
          TabOrder = 6
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
          TabOrder = 7
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
          Height = 178
          Caption = 'Calculated values'
          TabOrder = 8
          object Lfreq: TLabel
            Left = 10
            Top = 37
            Width = 80
            Height = 13
            Caption = 'Freq per channel'
          end
          object AggFreq: TLabel
            Left = 10
            Top = 55
            Width = 102
            Height = 13
            Caption = 'Aggregate Frequency'
          end
          object Lduration: TLabel
            Left = 10
            Top = 73
            Width = 40
            Height = 13
            Caption = 'Duration'
          end
          object Lpretrig: TLabel
            Left = 10
            Top = 107
            Width = 71
            Height = 13
            Caption = 'Pretrig.samples'
          end
          object Lwarning: TLabel
            Left = 10
            Top = 130
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
          object LperiodPerChan: TLabel
            Left = 11
            Top = 19
            Width = 89
            Height = 13
            Caption = 'Period per channel'
          end
          object LQnbpt: TLabel
            Left = 10
            Top = 91
            Width = 99
            Height = 13
            Caption = 'Samples per channel'
          end
        end
        object Bcheck: TButton
          Left = 256
          Top = 224
          Width = 41
          Height = 15
          Caption = 'Check'
          TabOrder = 9
          OnClick = BcheckClick
        end
        object Boptions: TButton
          Left = 254
          Top = 15
          Width = 75
          Height = 20
          Caption = 'Options'
          TabOrder = 10
          OnClick = BoptionsClick
        end
        object cbSound: TCheckBoxV
          Left = 21
          Top = 204
          Width = 131
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Record sound'
          TabOrder = 11
          Visible = False
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
          Left = 22
          Top = 18
          Width = 63
          Height = 13
          Caption = 'Trigger Mode'
        end
        object LvoieSync: TLabel
          Left = 22
          Top = 47
          Width = 74
          Height = 13
          Caption = 'Trigger channel'
        end
        object LseuilHaut: TLabel
          Left = 22
          Top = 70
          Width = 75
          Height = 13
          Caption = 'Upper threshold'
        end
        object LseuilBas: TLabel
          Left = 22
          Top = 93
          Width = 75
          Height = 13
          Caption = 'Lower threshold'
        end
        object LtestInt: TLabel
          Left = 22
          Top = 116
          Width = 58
          Height = 13
          Caption = 'Test interval'
        end
        object Lisi: TLabel
          Left = 22
          Top = 138
          Width = 13
          Height = 13
          Caption = 'ISI'
        end
        object cbModeTrig: TcomboBoxV
          Left = 119
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
        object enISI: TeditNum
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
        object cbRisingSlope: TCheckBoxV
          Left = 22
          Top = 160
          Width = 129
          Height = 17
          Alignment = taLeftJustify
          Caption = 'NI Rising Slope'
          TabOrder = 6
          UpdateVarOnToggle = False
        end
      end
    end
    object TabSChannels: TTabSheet
      Caption = 'Channels'
      object TabNumC: TTabControl
        Left = 0
        Top = 0
        Width = 457
        Height = 285
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
          Top = 171
          Width = 118
          Height = 13
          Caption = 'Physical channel number'
        end
        object LabelRange: TLabel
          Left = 20
          Top = 193
          Width = 32
          Height = 13
          Caption = 'Range'
        end
        object Label7: TLabel
          Left = 19
          Top = 215
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
        object Ldevice: TLabel
          Left = 19
          Top = 149
          Width = 34
          Height = 13
          Caption = 'Device'
        end
        object EventPanel: TPanel
          Left = 238
          Top = 168
          Width = 201
          Height = 73
          BevelOuter = bvNone
          TabOrder = 6
          object Label6: TLabel
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
          object CbRising: TCheckBoxV
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
        object NotUsedPanel: TPanel
          Left = 238
          Top = 168
          Width = 201
          Height = 73
          BevelOuter = bvNone
          TabOrder = 7
          object Label10: TLabel
            Left = 10
            Top = 10
            Width = 43
            Height = 13
            Caption = 'Not used'
          end
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
          Top = 167
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
          Top = 189
          Width = 154
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enKS: TeditNum
          Left = 165
          Top = 211
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
        object enDevice: TeditNum
          Left = 165
          Top = 145
          Width = 53
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
    object TabScyberK: TTabSheet
      Caption = 'Cyber Spikes'
      ImageIndex = 8
      object GroupBox10: TGroupBox
        Left = 0
        Top = 5
        Width = 411
        Height = 260
        TabOrder = 0
        object Label13: TLabel
          Left = 23
          Top = 20
          Width = 75
          Height = 13
          Caption = 'Electrode count'
        end
        object Label14: TLabel
          Left = 23
          Top = 43
          Width = 99
          Height = 13
          Caption = 'Max Number of Units'
        end
        object Label15: TLabel
          Left = 23
          Top = 65
          Width = 65
          Height = 13
          Caption = 'Wave Length'
        end
        object Label16: TLabel
          Left = 23
          Top = 88
          Width = 105
          Height = 13
          Caption = 'Samples before trigger'
        end
        object cbCybElec: TcomboBoxV
          Left = 140
          Top = 16
          Width = 76
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = cbModeTrigChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object cbCybUnits: TcomboBoxV
          Left = 140
          Top = 39
          Width = 76
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnChange = cbModeTrigChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enWaveLen: TeditNum
          Left = 140
          Top = 63
          Width = 76
          Height = 21
          TabOrder = 2
          Text = 'enWaveLen'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enPretrig: TeditNum
          Left = 140
          Top = 86
          Width = 76
          Height = 21
          TabOrder = 3
          Text = 'editNum1'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object GroupBox11: TGroupBox
          Left = 17
          Top = 115
          Width = 318
          Height = 107
          Caption = 'Vertical scaling factors'
          TabOrder = 4
          object Label17: TLabel
            Left = 8
            Top = 53
            Width = 8
            Height = 13
            Caption = 'j='
          end
          object Label18: TLabel
            Left = 108
            Top = 55
            Width = 85
            Height = 13
            Caption = 'Corresponds to y='
          end
          object Label20: TLabel
            Left = 8
            Top = 78
            Width = 8
            Height = 13
            Caption = 'j='
          end
          object Label21: TLabel
            Left = 107
            Top = 79
            Width = 85
            Height = 13
            Caption = 'Corresponds to y='
          end
          object Label22: TLabel
            Left = 7
            Top = 25
            Width = 27
            Height = 13
            Caption = 'Units:'
          end
          object enCyberJru1: TeditNum
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
          object enCyberYru1: TeditNum
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
          object enCyberJru2: TeditNum
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
          object enCyberYru2: TeditNum
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
          object esCyberUnitY: TeditString
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
      end
    end
    object TabSfiles: TTabSheet
      Caption = 'Data file'
      object Label3: TLabel
        Left = 15
        Top = 76
        Width = 120
        Height = 13
        Caption = 'File information block size'
      end
      object Label4: TLabel
        Left = 15
        Top = 98
        Width = 142
        Height = 13
        Caption = 'Episode information block size'
      end
      object Label5: TLabel
        Left = 15
        Top = 120
        Width = 102
        Height = 13
        Caption = 'Minimal comment size'
      end
      object Label8: TLabel
        Left = 16
        Top = 154
        Width = 48
        Height = 13
        Caption = 'File format'
      end
      object LfileWarning: TLabel
        Left = 16
        Top = 192
        Width = 90
        Height = 13
        Caption = '                              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
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
      object enFileInfo: TeditNum
        Left = 173
        Top = 74
        Width = 108
        Height = 21
        TabOrder = 1
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enEpInfo: TeditNum
        Left = 173
        Top = 96
        Width = 108
        Height = 21
        TabOrder = 2
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enCommentSize: TeditNum
        Left = 173
        Top = 118
        Width = 108
        Height = 21
        TabOrder = 3
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbFileFormat: TcomboBoxV
        Left = 173
        Top = 149
        Width = 110
        Height = 21
        ItemHeight = 0
        TabOrder = 4
        OnChange = cbFileFormatChange
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
        Width = 457
        Height = 225
        Align = alTop
        TabOrder = 0
        object cbProcess: TCheckBoxV
          Left = 9
          Top = 19
          Width = 123
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Execute primary file'
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
    object TabSaverage: TTabSheet
      Caption = 'Average'
      TabVisible = False
      object GroupBox7: TGroupBox
        Left = 0
        Top = 0
        Width = 449
        Height = 162
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 10
          Top = 64
          Width = 123
          Height = 13
          Caption = 'Save average after every '
        end
        object Label2: TLabel
          Left = 220
          Top = 64
          Width = 42
          Height = 13
          Caption = 'episodes'
        end
        object CbQmoy: TCheckBoxV
          Left = 8
          Top = 19
          Width = 201
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Compute average'
          TabOrder = 0
          UpdateVarOnToggle = False
        end
        object cbSaveMoy: TCheckBoxV
          Left = 8
          Top = 41
          Width = 201
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Save average'
          TabOrder = 1
          UpdateVarOnToggle = False
        end
        object enCadMoy: TeditNum
          Left = 146
          Top = 61
          Width = 63
          Height = 21
          TabOrder = 2
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
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
      object cbControlPanel: TCheckBoxV
        Left = 269
        Top = 113
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show control panel'
        TabOrder = 4
        UpdateVarOnToggle = False
      end
      object cbTriggerPos: TCheckBoxV
        Left = 269
        Top = 132
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show trigger position'
        TabOrder = 5
        UpdateVarOnToggle = False
      end
    end
    object TabSChannelsNRN: TTabSheet
      Caption = 'Channels'
      ImageIndex = 9
      object GroupBox12: TGroupBox
        Left = 0
        Top = 8
        Width = 449
        Height = 113
        Caption = 'Analog channels'
        TabOrder = 0
        object TabNumCacqNrn: TTabControl
          Left = 2
          Top = 15
          Width = 445
          Height = 96
          Align = alClient
          TabOrder = 0
          Tabs.Strings = (
            '1'
            '2'
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
          OnChange = TabNumCacqNrnChange
          object Label23: TLabel
            Left = 10
            Top = 34
            Width = 66
            Height = 13
            Caption = 'Symbol name:'
          end
          object esAcqSymbol: TeditString
            Left = 8
            Top = 50
            Width = 185
            Height = 21
            TabOrder = 0
            Text = 'esNrnSymbol'
            len = 0
            UpdateVarOnExit = False
          end
          object BacqSymbol: TButton
            Left = 209
            Top = 50
            Width = 75
            Height = 21
            Caption = 'Choose'
            TabOrder = 1
            OnClick = BsymbolNameClick
          end
        end
      end
      object GroupBox13: TGroupBox
        Left = 0
        Top = 131
        Width = 449
        Height = 149
        Caption = 'Tag channels'
        TabOrder = 1
        object TabNumCtagNrn: TTabControl
          Left = 2
          Top = 15
          Width = 445
          Height = 132
          Align = alClient
          TabOrder = 0
          Tabs.Strings = (
            '1'
            '2'
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
          OnChange = TabNumCtagNrnChange
          object Label24: TLabel
            Left = 10
            Top = 34
            Width = 66
            Height = 13
            Caption = 'Symbol name:'
          end
          object esTagSymbol: TeditString
            Left = 8
            Top = 50
            Width = 185
            Height = 21
            TabOrder = 0
            Text = 'esNrnSymbol'
            len = 0
            UpdateVarOnExit = False
          end
          object BtagSymbol: TButton
            Left = 209
            Top = 50
            Width = 75
            Height = 21
            Caption = 'Choose'
            TabOrder = 1
            OnClick = BtagSymbolClick
          end
        end
      end
    end
    object TabSPhoton: TTabSheet
      Caption = 'Photon Imaging'
      ImageIndex = 10
      object Label11: TLabel
        Left = 24
        Top = 19
        Width = 88
        Height = 13
        Caption = 'Photon Acquisition'
      end
      object cbDisplayPhotons: TCheckBoxV
        Left = 22
        Top = 41
        Width = 155
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Immediate display'
        TabOrder = 0
        UpdateVarOnToggle = False
      end
      object cbAcqPhoton: TcomboBoxV
        Left = 160
        Top = 16
        Width = 145
        Height = 21
        ItemHeight = 0
        TabOrder = 1
        OnChange = cbAcqPhotonChange
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object GBtcpip: TGroupBox
        Left = 16
        Top = 80
        Width = 425
        Height = 121
        Caption = 'TCPIP parameters'
        TabOrder = 2
        object Label26: TLabel
          Left = 20
          Top = 28
          Width = 50
          Height = 13
          Caption = 'IP address'
        end
        object Label27: TLabel
          Left = 19
          Top = 51
          Width = 19
          Height = 13
          Caption = 'Port'
        end
        object esIPaddress: TeditString
          Left = 156
          Top = 24
          Width = 209
          Height = 21
          TabOrder = 0
          Text = 'esIPaddress'
          len = 0
          UpdateVarOnExit = False
        end
        object enPort: TeditNum
          Left = 156
          Top = 49
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'enPort'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbRawBuffer: TCheckBoxV
          Left = 16
          Top = 72
          Width = 153
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Packets without header'
          TabOrder = 2
          UpdateVarOnToggle = False
        end
        object cbSwapBytes: TCheckBoxV
          Left = 16
          Top = 93
          Width = 153
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Swap Bytes'
          TabOrder = 3
          UpdateVarOnToggle = False
        end
      end
      object GroupBox14: TGroupBox
        Left = 16
        Top = 208
        Width = 425
        Height = 57
        Caption = 'Frame Size'
        TabOrder = 3
        object Label28: TLabel
          Left = 18
          Top = 26
          Width = 13
          Height = 13
          Caption = 'Nx'
        end
        object Label29: TLabel
          Left = 173
          Top = 26
          Width = 13
          Height = 13
          Caption = 'Ny'
        end
        object enNX: TeditNum
          Left = 41
          Top = 23
          Width = 52
          Height = 21
          TabOrder = 0
          Text = '512'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enNY: TeditNum
          Left = 198
          Top = 23
          Width = 52
          Height = 21
          TabOrder = 1
          Text = '512'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
  end
end
