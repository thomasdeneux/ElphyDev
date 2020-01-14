object paramAcq: TparamAcq
  Left = 651
  Top = 238
  BorderStyle = bsDialog
  Caption = 'Acquisition parameters'
  ClientHeight = 473
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Bok: TButton
    Left = 182
    Top = 399
    Width = 92
    Height = 31
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 281
    Top = 399
    Width = 92
    Height = 31
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 572
    Height = 385
    ActivePage = TabSgeneral
    Align = alTop
    TabOrder = 2
    object TabSgeneral: TTabSheet
      Caption = 'General'
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 564
        Height = 306
        Align = alTop
        TabOrder = 0
        object Label19: TLabel
          Left = 28
          Top = 22
          Width = 38
          Height = 16
          Caption = 'Mode:'
        end
        object Lnbvoie: TLabel
          Left = 27
          Top = 89
          Width = 84
          Height = 16
          Caption = 'Channel count'
        end
        object Lduree: TLabel
          Left = 27
          Top = 145
          Width = 79
          Height = 16
          Caption = 'Duration (ms)'
        end
        object Lperiod: TLabel
          Left = 27
          Top = 117
          Width = 142
          Height = 16
          Caption = 'Period per channel (ms)'
        end
        object Lnbav: TLabel
          Left = 27
          Top = 174
          Width = 97
          Height = 16
          Caption = 'Pre-trig. duration'
        end
        object LepCount: TLabel
          Left = 27
          Top = 60
          Width = 86
          Height = 16
          Caption = 'Episode count'
        end
        object Lmaxduration: TLabel
          Left = 28
          Top = 202
          Width = 112
          Height = 16
          Caption = 'Max. duration (sec)'
        end
        object cbModeAcq: TcomboBoxV
          Left = 74
          Top = 18
          Width = 120
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 0
          OnChange = cbModeAcqChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enNbvoie: TeditNum
          Left = 171
          Top = 84
          Width = 133
          Height = 24
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
          Left = 171
          Top = 140
          Width = 133
          Height = 24
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
          Left = 171
          Top = 112
          Width = 133
          Height = 24
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
          Left = 171
          Top = 169
          Width = 133
          Height = 24
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
          Left = 26
          Top = 226
          Width = 161
          Height = 21
          Alignment = taLeftJustify
          Caption = 'Stimulate'
          TabOrder = 5
          OnClick = BcheckClick
          UpdateVarOnToggle = False
        end
        object enEpCount: TeditNum
          Left = 171
          Top = 55
          Width = 133
          Height = 24
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
          Left = 171
          Top = 197
          Width = 133
          Height = 24
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
          Left = 313
          Top = 48
          Width = 227
          Height = 219
          Caption = 'Calculated values'
          TabOrder = 8
          object Lfreq: TLabel
            Left = 12
            Top = 46
            Width = 101
            Height = 16
            Caption = 'Freq per channel'
          end
          object AggFreq: TLabel
            Left = 12
            Top = 68
            Width = 131
            Height = 16
            Caption = 'Aggregate Frequency'
          end
          object Lduration: TLabel
            Left = 12
            Top = 90
            Width = 50
            Height = 16
            Caption = 'Duration'
          end
          object Lpretrig: TLabel
            Left = 12
            Top = 132
            Width = 94
            Height = 16
            Caption = 'Pretrig.samples'
          end
          object Lwarning: TLabel
            Left = 12
            Top = 160
            Width = 53
            Height = 16
            Caption = 'Lwarning'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object LperiodPerChan: TLabel
            Left = 14
            Top = 23
            Width = 113
            Height = 16
            Caption = 'Period per channel'
          end
          object LQnbpt: TLabel
            Left = 12
            Top = 112
            Width = 127
            Height = 16
            Caption = 'Samples per channel'
          end
        end
        object Bcheck: TButton
          Left = 315
          Top = 276
          Width = 51
          Height = 18
          Caption = 'Check'
          TabOrder = 9
          OnClick = BcheckClick
        end
        object Boptions: TButton
          Left = 313
          Top = 18
          Width = 92
          Height = 25
          Caption = 'Options'
          TabOrder = 10
          OnClick = BoptionsClick
        end
        object cbSound: TCheckBoxV
          Left = 26
          Top = 251
          Width = 161
          Height = 21
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
        Top = -4
        Width = 506
        Height = 250
        TabOrder = 0
        object Label25: TLabel
          Left = 27
          Top = 22
          Width = 82
          Height = 16
          Caption = 'Trigger Mode'
        end
        object LvoieSync: TLabel
          Left = 27
          Top = 58
          Width = 94
          Height = 16
          Caption = 'Trigger channel'
        end
        object LseuilHaut: TLabel
          Left = 27
          Top = 86
          Width = 96
          Height = 16
          Caption = 'Upper threshold'
        end
        object LseuilBas: TLabel
          Left = 27
          Top = 114
          Width = 94
          Height = 16
          Caption = 'Lower threshold'
        end
        object LtestInt: TLabel
          Left = 27
          Top = 143
          Width = 73
          Height = 16
          Caption = 'Test interval'
        end
        object Lisi: TLabel
          Left = 27
          Top = 170
          Width = 15
          Height = 16
          Caption = 'ISI'
        end
        object cbModeTrig: TcomboBoxV
          Left = 146
          Top = 17
          Width = 175
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
          Left = 171
          Top = 55
          Width = 131
          Height = 21
          TabOrder = 1
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enSeuilHaut: TeditNum
          Left = 171
          Top = 84
          Width = 131
          Height = 21
          TabOrder = 2
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enSeuilBas: TeditNum
          Left = 171
          Top = 112
          Width = 131
          Height = 21
          TabOrder = 3
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enTestInt: TeditNum
          Left = 171
          Top = 140
          Width = 131
          Height = 21
          TabOrder = 4
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enISI: TeditNum
          Left = 171
          Top = 169
          Width = 131
          Height = 21
          TabOrder = 5
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbRisingSlope: TCheckBoxV
          Left = 27
          Top = 197
          Width = 159
          Height = 21
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
        Width = 564
        Height = 354
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
          Left = 23
          Top = 210
          Width = 149
          Height = 16
          Caption = 'Physical channel number'
        end
        object LabelRange: TLabel
          Left = 25
          Top = 238
          Width = 41
          Height = 16
          Caption = 'Range'
        end
        object Label7: TLabel
          Left = 23
          Top = 265
          Width = 129
          Height = 16
          Caption = 'Down-sampling factor'
        end
        object Label9: TLabel
          Left = 305
          Top = 182
          Width = 32
          Height = 16
          Caption = 'Type'
        end
        object Ldevice: TLabel
          Left = 23
          Top = 183
          Width = 43
          Height = 16
          Caption = 'Device'
        end
        object EventPanel: TPanel
          Left = 293
          Top = 207
          Width = 247
          Height = 90
          BevelOuter = bvNone
          TabOrder = 6
          object Label6: TLabel
            Left = 12
            Top = 5
            Width = 61
            Height = 16
            Caption = 'Threshold'
          end
          object Label12: TLabel
            Left = 12
            Top = 33
            Width = 64
            Height = 16
            Caption = 'Hysteresis'
          end
          object enThreshold: TeditNum
            Left = 85
            Top = 1
            Width = 117
            Height = 24
            TabOrder = 0
            Text = '000'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enHys: TeditNum
            Left = 85
            Top = 31
            Width = 117
            Height = 24
            TabOrder = 1
            Text = '000'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object CbRising: TCheckBoxV
            Left = 11
            Top = 59
            Width = 191
            Height = 21
            Alignment = taLeftJustify
            Caption = 'Rising edge'
            TabOrder = 2
            UpdateVarOnToggle = False
          end
        end
        object NotUsedPanel: TPanel
          Left = 293
          Top = 207
          Width = 247
          Height = 90
          BevelOuter = bvNone
          TabOrder = 7
          object Label10: TLabel
            Left = 12
            Top = 12
            Width = 54
            Height = 16
            Caption = 'Not used'
          end
        end
        object GroupBox6: TGroupBox
          Left = 25
          Top = 39
          Width = 391
          Height = 132
          Caption = 'Vertical scaling factors'
          TabOrder = 0
          object Label32: TLabel
            Left = 10
            Top = 65
            Width = 10
            Height = 16
            Caption = 'j='
          end
          object Label33: TLabel
            Left = 133
            Top = 68
            Width = 109
            Height = 16
            Caption = 'Corresponds to y='
          end
          object Label34: TLabel
            Left = 10
            Top = 96
            Width = 10
            Height = 16
            Caption = 'j='
          end
          object Label35: TLabel
            Left = 132
            Top = 97
            Width = 109
            Height = 16
            Caption = 'Corresponds to y='
          end
          object Label36: TLabel
            Left = 9
            Top = 31
            Width = 33
            Height = 16
            Caption = 'Units:'
          end
          object enJ1: TeditNum
            Left = 49
            Top = 63
            Width = 72
            Height = 24
            TabOrder = 0
            Text = '1'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enY1: TeditNum
            Left = 244
            Top = 63
            Width = 107
            Height = 24
            TabOrder = 1
            Text = '1123456789'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enJ2: TeditNum
            Left = 49
            Top = 92
            Width = 72
            Height = 24
            TabOrder = 2
            Text = '2'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object enY2: TeditNum
            Left = 244
            Top = 92
            Width = 107
            Height = 24
            TabOrder = 3
            Text = '1123456789'
            Tnum = G_byte
            Max = 255.000000000000000000
            UpdateVarOnExit = False
            Decimal = 0
            Dxu = 1.000000000000000000
          end
          object esUnits: TeditString
            Left = 58
            Top = 27
            Width = 108
            Height = 24
            TabOrder = 4
            Text = 'mV'
            len = 0
            UpdateVarOnExit = False
          end
        end
        object enVoiePhys: TeditNum
          Left = 203
          Top = 206
          Width = 65
          Height = 24
          TabOrder = 1
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbGain: TcomboBoxV
          Left = 79
          Top = 233
          Width = 189
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enKS: TeditNum
          Left = 203
          Top = 260
          Width = 65
          Height = 24
          TabOrder = 3
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbType: TcomboBoxV
          Left = 352
          Top = 178
          Width = 143
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 4
          OnChange = cbTypeChange
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enDevice: TeditNum
          Left = 203
          Top = 178
          Width = 65
          Height = 24
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
        Top = 6
        Width = 506
        Height = 320
        TabOrder = 0
        object Label13: TLabel
          Left = 28
          Top = 25
          Width = 93
          Height = 16
          Caption = 'Electrode count'
        end
        object Label14: TLabel
          Left = 28
          Top = 53
          Width = 123
          Height = 16
          Caption = 'Max Number of Units'
        end
        object Label15: TLabel
          Left = 28
          Top = 80
          Width = 79
          Height = 16
          Caption = 'Wave Length'
        end
        object Label16: TLabel
          Left = 28
          Top = 108
          Width = 137
          Height = 16
          Caption = 'Samples before trigger'
        end
        object cbCybElec: TcomboBoxV
          Left = 172
          Top = 20
          Width = 94
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
          Left = 172
          Top = 48
          Width = 94
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
          Left = 172
          Top = 78
          Width = 94
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
          Left = 172
          Top = 106
          Width = 94
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
          Left = 21
          Top = 142
          Width = 391
          Height = 131
          Caption = 'Vertical scaling factors'
          TabOrder = 4
          object Label17: TLabel
            Left = 10
            Top = 65
            Width = 10
            Height = 16
            Caption = 'j='
          end
          object Label18: TLabel
            Left = 133
            Top = 68
            Width = 109
            Height = 16
            Caption = 'Corresponds to y='
          end
          object Label20: TLabel
            Left = 10
            Top = 96
            Width = 10
            Height = 16
            Caption = 'j='
          end
          object Label21: TLabel
            Left = 132
            Top = 97
            Width = 109
            Height = 16
            Caption = 'Corresponds to y='
          end
          object Label22: TLabel
            Left = 9
            Top = 31
            Width = 33
            Height = 16
            Caption = 'Units:'
          end
          object enCyberJru1: TeditNum
            Left = 49
            Top = 63
            Width = 72
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
            Left = 244
            Top = 63
            Width = 107
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
            Left = 49
            Top = 92
            Width = 72
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
            Left = 244
            Top = 92
            Width = 107
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
            Left = 58
            Top = 27
            Width = 108
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
        Left = 18
        Top = 94
        Width = 153
        Height = 16
        Caption = 'File information block size'
      end
      object Label4: TLabel
        Left = 18
        Top = 121
        Width = 182
        Height = 16
        Caption = 'Episode information block size'
      end
      object Label5: TLabel
        Left = 18
        Top = 148
        Width = 131
        Height = 16
        Caption = 'Minimal comment size'
      end
      object Label8: TLabel
        Left = 20
        Top = 190
        Width = 62
        Height = 16
        Caption = 'File format'
      end
      object LfileWarning: TLabel
        Left = 20
        Top = 236
        Width = 90
        Height = 16
        Caption = '                              '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object GroupBox1: TGroupBox
        Left = 7
        Top = 6
        Width = 496
        Height = 62
        Caption = 'Generic file name'
        TabOrder = 0
        object cbGenAcq: TComboBox
          Left = 9
          Top = 25
          Width = 400
          Height = 21
          ItemHeight = 0
          TabOrder = 0
          Text = 'cbGenAcq'
          OnEnter = cbGenAcqEnter
          OnExit = cbGenAcqEnter
        end
        object Bbrowse: TButton
          Left = 417
          Top = 26
          Width = 64
          Height = 24
          Caption = 'Browse'
          TabOrder = 1
          OnClick = BbrowseClick
        end
      end
      object enFileInfo: TeditNum
        Left = 213
        Top = 91
        Width = 133
        Height = 21
        TabOrder = 1
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enEpInfo: TeditNum
        Left = 213
        Top = 118
        Width = 133
        Height = 21
        TabOrder = 2
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enCommentSize: TeditNum
        Left = 213
        Top = 145
        Width = 133
        Height = 21
        TabOrder = 3
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbFileFormat: TcomboBoxV
        Left = 213
        Top = 183
        Width = 135
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
        Left = 10
        Top = 7
        Width = 533
        Height = 279
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
        Width = 562
        Height = 277
        Align = alTop
        TabOrder = 0
        object cbProcess: TCheckBoxV
          Left = 11
          Top = 23
          Width = 151
          Height = 21
          Alignment = taLeftJustify
          Caption = 'Execute primary file'
          TabOrder = 0
          UpdateVarOnToggle = False
        end
        object GroupBox3: TGroupBox
          Left = 9
          Top = 59
          Width = 409
          Height = 151
          Caption = 'Clear following objects before acquisition:'
          TabOrder = 1
          object lbClear: TListBox
            Left = 10
            Top = 21
            Width = 261
            Height = 119
            ItemHeight = 13
            TabOrder = 0
          end
          object BaddClear: TButton
            Left = 297
            Top = 27
            Width = 92
            Height = 25
            Caption = 'Add'
            TabOrder = 1
            OnClick = BaddClearClick
          end
          object BremoveClear: TButton
            Left = 295
            Top = 59
            Width = 93
            Height = 25
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
        Width = 553
        Height = 199
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 12
          Top = 79
          Width = 155
          Height = 16
          Caption = 'Save average after every '
        end
        object Label2: TLabel
          Left = 271
          Top = 79
          Width = 57
          Height = 16
          Caption = 'episodes'
        end
        object CbQmoy: TCheckBoxV
          Left = 10
          Top = 23
          Width = 247
          Height = 21
          Alignment = taLeftJustify
          Caption = 'Compute average'
          TabOrder = 0
          UpdateVarOnToggle = False
        end
        object cbSaveMoy: TCheckBoxV
          Left = 10
          Top = 50
          Width = 247
          Height = 21
          Alignment = taLeftJustify
          Caption = 'Save average'
          TabOrder = 1
          UpdateVarOnToggle = False
        end
        object enCadMoy: TeditNum
          Left = 180
          Top = 75
          Width = 77
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
        Left = 331
        Top = 47
        Width = 191
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Display data'
        TabOrder = 0
        UpdateVarOnToggle = False
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 36
        Width = 304
        Height = 211
        Caption = 'Track following objects'
        TabOrder = 1
        object lbRefresh: TListBox
          Left = 17
          Top = 21
          Width = 266
          Height = 143
          ItemHeight = 13
          TabOrder = 0
        end
        object BaddRefresh: TButton
          Left = 38
          Top = 172
          Width = 92
          Height = 25
          Caption = 'Add'
          TabOrder = 1
          OnClick = BaddRefreshClick
        end
        object BremoveRefresh: TButton
          Left = 146
          Top = 172
          Width = 93
          Height = 25
          Caption = 'Remove'
          TabOrder = 2
          OnClick = BremoveRefreshClick
        end
      end
      object cbImmediate: TCheckBoxV
        Left = 331
        Top = 70
        Width = 192
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Immediate display'
        TabOrder = 2
        UpdateVarOnToggle = False
      end
      object cbHold: TCheckBoxV
        Left = 331
        Top = 117
        Width = 192
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Hold traces'
        TabOrder = 3
        UpdateVarOnToggle = False
      end
      object cbControlPanel: TCheckBoxV
        Left = 331
        Top = 139
        Width = 192
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Show control panel'
        TabOrder = 4
        UpdateVarOnToggle = False
      end
      object cbTriggerPos: TCheckBoxV
        Left = 331
        Top = 162
        Width = 192
        Height = 21
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
        Top = 10
        Width = 553
        Height = 139
        Caption = 'Analog channels'
        TabOrder = 0
        object TabNumCacqNrn: TTabControl
          Left = 2
          Top = 18
          Width = 549
          Height = 119
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
            Left = 12
            Top = 42
            Width = 86
            Height = 16
            Caption = 'Symbol name:'
          end
          object esAcqSymbol: TeditString
            Left = 10
            Top = 62
            Width = 228
            Height = 21
            TabOrder = 0
            Text = 'esNrnSymbol'
            len = 0
            UpdateVarOnExit = False
          end
          object BacqSymbol: TButton
            Left = 257
            Top = 62
            Width = 93
            Height = 25
            Caption = 'Choose'
            TabOrder = 1
            OnClick = BsymbolNameClick
          end
        end
      end
      object GroupBox13: TGroupBox
        Left = 0
        Top = 161
        Width = 553
        Height = 184
        Caption = 'Tag channels'
        TabOrder = 1
        object TabNumCtagNrn: TTabControl
          Left = 2
          Top = 18
          Width = 549
          Height = 164
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
            Left = 12
            Top = 42
            Width = 86
            Height = 16
            Caption = 'Symbol name:'
          end
          object esTagSymbol: TeditString
            Left = 10
            Top = 62
            Width = 228
            Height = 21
            TabOrder = 0
            Text = 'esNrnSymbol'
            len = 0
            UpdateVarOnExit = False
          end
          object BtagSymbol: TButton
            Left = 257
            Top = 62
            Width = 93
            Height = 25
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
        Left = 30
        Top = 23
        Width = 110
        Height = 16
        Caption = 'Photon Acquisition'
      end
      object cbDisplayPhotons: TCheckBoxV
        Left = 27
        Top = 50
        Width = 191
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Immediate display'
        TabOrder = 0
        UpdateVarOnToggle = False
      end
      object cbAcqPhoton: TcomboBoxV
        Left = 197
        Top = 20
        Width = 178
        Height = 24
        ItemHeight = 16
        TabOrder = 1
        OnChange = cbAcqPhotonChange
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object GBtcpip: TGroupBox
        Left = 20
        Top = 98
        Width = 523
        Height = 149
        Caption = 'TCPIP parameters'
        TabOrder = 2
        object Label26: TLabel
          Left = 25
          Top = 34
          Width = 65
          Height = 16
          Caption = 'IP address'
        end
        object Label27: TLabel
          Left = 23
          Top = 63
          Width = 24
          Height = 16
          Caption = 'Port'
        end
        object esIPaddress: TeditString
          Left = 192
          Top = 30
          Width = 257
          Height = 24
          TabOrder = 0
          Text = 'esIPaddress'
          len = 0
          UpdateVarOnExit = False
        end
        object enPort: TeditNum
          Left = 192
          Top = 60
          Width = 149
          Height = 24
          TabOrder = 1
          Text = 'enPort'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbRawBuffer: TCheckBoxV
          Left = 20
          Top = 89
          Width = 188
          Height = 21
          Alignment = taLeftJustify
          Caption = 'Packets without header'
          TabOrder = 2
          UpdateVarOnToggle = False
        end
        object cbSwapBytes: TCheckBoxV
          Left = 20
          Top = 114
          Width = 188
          Height = 21
          Alignment = taLeftJustify
          Caption = 'Swap Bytes'
          TabOrder = 3
          UpdateVarOnToggle = False
        end
      end
      object GroupBox14: TGroupBox
        Left = 20
        Top = 256
        Width = 523
        Height = 70
        Caption = 'Frame Size'
        TabOrder = 3
        object Label28: TLabel
          Left = 22
          Top = 32
          Width = 16
          Height = 16
          Caption = 'Nx'
        end
        object Label29: TLabel
          Left = 213
          Top = 32
          Width = 17
          Height = 16
          Caption = 'Ny'
        end
        object enNX: TeditNum
          Left = 50
          Top = 28
          Width = 64
          Height = 24
          TabOrder = 0
          Text = '512'
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enNY: TeditNum
          Left = 244
          Top = 28
          Width = 64
          Height = 24
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
