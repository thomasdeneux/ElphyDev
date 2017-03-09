object Mstimulator: TMstimulator
  Left = 802
  Top = 236
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Stimulator'
  ClientHeight = 642
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 711
    Height = 312
    Align = alClient
    OnPaint = PaintBox1Paint
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 339
    Width = 711
    Height = 266
    ActivePage = TabSheetChannels
    Align = alBottom
    MultiLine = True
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    OnEnter = FormOnEnter
    object TabSheetGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 2
      object Label2: TLabel
        Left = 6
        Top = 36
        Width = 39
        Height = 13
        Caption = 'ISI (sec)'
      end
      object Label1: TLabel
        Left = 6
        Top = 61
        Width = 95
        Height = 13
        Caption = 'Number of channels'
      end
      object Label13: TLabel
        Left = 6
        Top = 87
        Width = 149
        Height = 13
        Caption = 'Max number of logical channels'
      end
      object enIsi: TeditNum
        Left = 147
        Top = 32
        Width = 84
        Height = 21
        TabOrder = 0
        OnExit = enStimDurationExit
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object GroupBox1: TGroupBox
        Left = 299
        Top = 21
        Width = 233
        Height = 97
        Caption = 'Calculated values'
        TabOrder = 1
        object LC1: TLabel
          Left = 8
          Top = 24
          Width = 19
          Height = 13
          Caption = 'LC1'
        end
        object LC2: TLabel
          Left = 8
          Top = 40
          Width = 19
          Height = 13
          Caption = 'LC2'
        end
        object LC3: TLabel
          Left = 8
          Top = 56
          Width = 19
          Height = 13
          Caption = 'LC3'
        end
      end
      object Bcheck: TButton
        Left = 535
        Top = 101
        Width = 40
        Height = 17
        Caption = 'Check'
        TabOrder = 2
        OnClick = enStimDurationExit
      end
      object enNbChan: TeditNum
        Left = 147
        Top = 57
        Width = 84
        Height = 21
        TabOrder = 3
        OnExit = enStimDurationExit
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbMaxChan: TcomboBoxV
        Left = 162
        Top = 83
        Width = 71
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
        OnChange = cbMaxChanChange
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object cbSetByProg: TCheckBoxV
        Left = 6
        Top = 113
        Width = 153
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Set By Program'
        TabOrder = 5
        UpdateVarOnToggle = False
      end
    end
    object TabSheetChannels: TTabSheet
      Caption = 'Channels'
      object TabChannel: TTabControl
        Left = 0
        Top = 0
        Width = 703
        Height = 238
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
        OnChange = TabChannelChange
        object Label5: TLabel
          Left = 12
          Top = 56
          Width = 34
          Height = 13
          Caption = 'Device'
        end
        object Label6: TLabel
          Left = 12
          Top = 78
          Width = 80
          Height = 13
          Caption = 'Physical channel'
        end
        object Label8: TLabel
          Left = 13
          Top = 101
          Width = 12
          Height = 13
          Caption = 'Bit'
        end
        object Label12: TLabel
          Left = 12
          Top = 32
          Width = 24
          Height = 13
          Caption = 'Type'
        end
        object GroupBox6: TGroupBox
          Left = 307
          Top = 26
          Width = 318
          Height = 102
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
        object enDevice: TeditNum
          Left = 101
          Top = 52
          Width = 53
          Height = 21
          TabOrder = 1
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbBitNum: TcomboBoxV
          Left = 101
          Top = 97
          Width = 71
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object enPhysChannel: TeditNum
          Left = 101
          Top = 74
          Width = 53
          Height = 21
          TabOrder = 3
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object cbOutType: TcomboBoxV
          Left = 101
          Top = 29
          Width = 116
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
      end
    end
    object TabSheetEdit: TTabSheet
      Caption = 'Edit'
      ImageIndex = 2
      object TabEdit: TTabControl
        Left = 0
        Top = 0
        Width = 703
        Height = 238
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
        OnChange = TabEditChange
        object EditTypeLabel: TLabel
          Left = 12
          Top = 27
          Width = 80
          Height = 13
          Caption = 'Analog output'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PanelAna: TPanel
          Left = 4
          Top = 44
          Width = 695
          Height = 106
          BevelOuter = bvNone
          TabOrder = 0
          inline TableFrameAna: TTableFrame
            Left = 3
            Top = 8
            Width = 690
            Height = 73
            HorzScrollBar.Visible = False
            VertScrollBar.Visible = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            inherited DrawGrid1: TDrawGrid
              Width = 690
              Height = 73
              DefaultColWidth = 80
            end
          end
        end
        object PanelDigi: TPanel
          Left = 4
          Top = 44
          Width = 695
          Height = 121
          TabOrder = 1
          object Label16: TLabel
            Left = 7
            Top = 10
            Width = 27
            Height = 13
            Caption = 'Mode'
          end
          inline TableFrameDigi: TTableFrame
            Left = 3
            Top = 40
            Width = 690
            Height = 73
            HorzScrollBar.Visible = False
            VertScrollBar.Visible = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            inherited DrawGrid1: TDrawGrid
              Width = 690
              Height = 73
              DefaultColWidth = 80
            end
          end
          object PanelTrain: TPanel
            Left = 3
            Top = 31
            Width = 690
            Height = 80
            TabOrder = 1
            object Label3: TLabel
              Left = 5
              Top = 9
              Width = 54
              Height = 13
              Caption = 'Pulse width'
            end
            object Label4: TLabel
              Left = 180
              Top = 9
              Width = 75
              Height = 13
              Caption = 'Pulses per burst'
            end
            object Label7: TLabel
              Left = 6
              Top = 32
              Width = 86
              Height = 13
              Caption = 'Inter pulse interval'
            end
            object Label11: TLabel
              Left = 180
              Top = 32
              Width = 54
              Height = 13
              Caption = 'Burst count'
            end
            object Label14: TLabel
              Left = 6
              Top = 55
              Width = 84
              Height = 13
              Caption = 'Inter burst interval'
            end
            object Label15: TLabel
              Left = 180
              Top = 55
              Width = 105
              Height = 13
              Caption = 'Delay before first burst'
            end
            object enPulseWidth: TeditNum
              Left = 101
              Top = 2
              Width = 65
              Height = 21
              TabOrder = 0
              Tnum = G_byte
              Max = 255.000000000000000000
              UpdateVarOnExit = False
              Decimal = 0
              Dxu = 1.000000000000000000
            end
            object enPulsesPerBurst: TeditNum
              Left = 292
              Top = 3
              Width = 65
              Height = 21
              TabOrder = 1
              Tnum = G_byte
              Max = 255.000000000000000000
              UpdateVarOnExit = False
              Decimal = 0
              Dxu = 1.000000000000000000
            end
            object enInterPulse: TeditNum
              Left = 101
              Top = 26
              Width = 65
              Height = 21
              TabOrder = 2
              Tnum = G_byte
              Max = 255.000000000000000000
              UpdateVarOnExit = False
              Decimal = 0
              Dxu = 1.000000000000000000
            end
            object enBurstCount: TeditNum
              Left = 292
              Top = 26
              Width = 65
              Height = 21
              TabOrder = 3
              Tnum = G_byte
              Max = 255.000000000000000000
              UpdateVarOnExit = False
              Decimal = 0
              Dxu = 1.000000000000000000
            end
            object enInterBurst: TeditNum
              Left = 101
              Top = 50
              Width = 65
              Height = 21
              TabOrder = 4
              Tnum = G_byte
              Max = 255.000000000000000000
              UpdateVarOnExit = False
              Decimal = 0
              Dxu = 1.000000000000000000
            end
            object enDelay: TeditNum
              Left = 292
              Top = 49
              Width = 65
              Height = 21
              TabOrder = 5
              Tnum = G_byte
              Max = 255.000000000000000000
              UpdateVarOnExit = False
              Decimal = 0
              Dxu = 1.000000000000000000
            end
          end
          object cbDigiMode: TcomboBoxV
            Left = 43
            Top = 8
            Width = 61
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 2
            OnChange = cbDigiModeChange
            Items.Strings = (
              'Pulses'
              'Train')
            Tnum = G_byte
            UpdateVarOnExit = False
            UpdateVarOnChange = False
          end
        end
      end
    end
  end
  object Panel0: TPanel
    Left = 0
    Top = 312
    Width = 711
    Height = 27
    Align = alBottom
    TabOrder = 1
    object Panel3: TPanel
      Left = 420
      Top = 1
      Width = 290
      Height = 25
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 0
      object Label9: TLabel
        Left = 118
        Top = 7
        Width = 38
        Height = 13
        Caption = 'Episode'
      end
      object Label10: TLabel
        Left = 9
        Top = 7
        Width = 37
        Height = 13
        Caption = 'Display:'
      end
      object Pepisode: TPanel
        Left = 160
        Top = 2
        Width = 49
        Height = 22
        BevelOuter = bvLowered
        Caption = '12'
        TabOrder = 0
      end
      object Bupdate: TButton
        Left = 59
        Top = 4
        Width = 53
        Height = 20
        Caption = 'Update '
        TabOrder = 1
        OnClick = BupdateClick
      end
      object Bprevious: TBitBtn
        Left = 216
        Top = 4
        Width = 33
        Height = 20
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
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
      object Bnext: TBitBtn
        Left = 251
        Top = 4
        Width = 33
        Height = 20
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
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
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 419
      Height = 25
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 605
    Width = 711
    Height = 37
    Align = alBottom
    TabOrder = 2
    object BOK: TButton
      Left = 304
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
