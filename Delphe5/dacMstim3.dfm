inherited MultiGstim2: TMultiGstim2
  Left = 576
  Top = 238
  Width = 720
  Height = 600
  Caption = 'MultiGstim2'
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 720
  Position = poDefaultPosOnly
  PixelsPerInch = 96
  TextHeight = 13
  inherited PaintBox1: TPaintBox
    Width = 712
    Height = 279
  end
  inherited Panel1Top: TPanel
    Width = 712
    inherited TabPage1: TTabControl
      Left = 520
    end
  end
  object PanelBottom: TPanel [2]
    Left = 0
    Top = 535
    Width = 712
    Height = 37
    Align = alBottom
    TabOrder = 1
    object BOK: TButton
      Left = 304
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object PageControl1: TPageControl [3]
    Left = 0
    Top = 331
    Width = 712
    Height = 204
    ActivePage = TabSheetChannels
    Align = alBottom
    TabOrder = 2
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    object TabSheetGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = 2
      object Label2: TLabel
        Left = 6
        Top = 17
        Width = 39
        Height = 13
        Caption = 'ISI (sec)'
      end
      object Label1: TLabel
        Left = 6
        Top = 42
        Width = 70
        Height = 13
        Caption = 'Channel Count'
      end
      object Label13: TLabel
        Left = 6
        Top = 68
        Width = 149
        Height = 13
        Caption = 'Max number of logical channels'
      end
      object Label10: TLabel
        Left = 6
        Top = 93
        Width = 108
        Height = 13
        Caption = 'Buffer Count (0 = Auto)'
      end
      object Label17: TLabel
        Left = 6
        Top = 116
        Width = 98
        Height = 13
        Caption = 'Buffer size (0 = Auto)'
      end
      object enIsi: TeditNum
        Left = 147
        Top = 13
        Width = 84
        Height = 21
        TabOrder = 0
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object GroupBox1: TGroupBox
        Left = 299
        Top = 2
        Width = 233
        Height = 143
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
        object LC4: TLabel
          Left = 8
          Top = 112
          Width = 19
          Height = 13
          Caption = 'LC4'
        end
      end
      object Bcheck: TButton
        Left = 535
        Top = 82
        Width = 40
        Height = 17
        Caption = 'Check'
        TabOrder = 2
        OnClick = BcheckClick
      end
      object enNbChan: TeditNum
        Left = 147
        Top = 38
        Width = 84
        Height = 21
        TabOrder = 3
        OnChange = changeBuffers
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbMaxChan: TcomboBoxV
        Left = 162
        Top = 64
        Width = 71
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        OnChange = cbMaxChanChange
        Tnum = G_byte
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object cbSetByProg: TCheckBoxV
        Left = 6
        Top = 139
        Width = 153
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Set By Program'
        TabOrder = 5
        UpdateVarOnToggle = False
      end
      object enBufferCount: TeditNum
        Left = 147
        Top = 89
        Width = 84
        Height = 21
        TabOrder = 6
        OnChange = changeBuffers
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enBufferSize: TeditNum
        Left = 147
        Top = 112
        Width = 84
        Height = 21
        TabOrder = 7
        OnChange = changeBuffers
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
    object TabSheetChannels: TTabSheet
      Caption = 'Channels'
      object TabChannel: TTabControl
        Left = 0
        Top = 0
        Width = 704
        Height = 176
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
        OnMouseDown = TabEditMouseDown
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
          Left = 12
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
        object LabelNrnSymbol: TLabel
          Left = 12
          Top = 121
          Width = 66
          Height = 13
          Caption = 'Symbol name:'
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
          OnChange = changeBuffers
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
          OnChange = changeBuffers
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
          OnChange = changeBuffers
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
          OnChange = changeBuffers
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object esNrnSymbol: TeditString
          Left = 12
          Top = 137
          Width = 185
          Height = 21
          TabOrder = 5
          Text = 'esNrnSymbol'
          len = 0
          UpdateVarOnExit = False
        end
        object BsymbolName: TButton
          Left = 202
          Top = 137
          Width = 52
          Height = 21
          Caption = 'Choose'
          TabOrder = 6
          OnClick = BsymbolNameClick
        end
      end
    end
    object TabSheetEdit: TTabSheet
      Caption = 'Edit'
      ImageIndex = 2
      object TabEdit: TTabControl
        Left = 0
        Top = 0
        Width = 704
        Height = 176
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
        OnMouseDown = TabEditMouseDown
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
        object Label18: TLabel
          Left = 8
          Top = 46
          Width = 27
          Height = 13
          Caption = 'Mode'
        end
        object Label16: TLabel
          Left = 200
          Top = 46
          Width = 46
          Height = 13
          Caption = 'Amplitude'
        end
        object PanelDigi: TPanel
          Left = 4
          Top = 72
          Width = 695
          Height = 93
          TabOrder = 1
          object PanelTrain: TPanel
            Left = 3
            Top = 1
            Width = 690
            Height = 92
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
          inline TableFrameDigi: TTableFrame
            Left = 3
            Top = 1
            Width = 688
            Height = 90
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
              Width = 688
              Height = 90
              DefaultColWidth = 80
            end
          end
        end
        object cbFillMode: TcomboBoxV
          Left = 44
          Top = 44
          Width = 103
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = cbFillModeChange
          Items.Strings = (
            'Analog segments'
            'Pulses'
            'Pulse Train')
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object PanelAna: TPanel
          Left = 4
          Top = 67
          Width = 695
          Height = 106
          TabOrder = 0
          inline TableFrameAna: TTableFrame
            Left = 3
            Top = 6
            Width = 690
            Height = 90
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
              Height = 90
              DefaultColWidth = 80
            end
          end
        end
        object enPulseAmp: TeditNum
          Left = 264
          Top = 42
          Width = 83
          Height = 21
          TabOrder = 3
          Tnum = G_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
  end
  object Panel0: TPanel [4]
    Left = 0
    Top = 304
    Width = 712
    Height = 27
    Align = alBottom
    TabOrder = 3
    object Panel3: TPanel
      Left = 421
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
        Left = 9
        Top = 4
        Width = 96
        Height = 20
        Caption = 'Update Display'
        TabOrder = 1
        OnClick = changeDisplay
      end
      object Bprevious: TBitBtn
        Left = 216
        Top = 4
        Width = 33
        Height = 20
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = changeDisplay
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
        OnClick = changeDisplay
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
      Width = 420
      Height = 25
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
    end
  end
end
