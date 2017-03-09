object Mstimulator: TMstimulator
  Left = 515
  Top = 184
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Stimulator'
  ClientHeight = 457
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 612
    Height = 266
    Align = alClient
    OnPaint = PaintBox1Paint
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 295
    Width = 612
    Height = 162
    ActivePage = TabSheet2
    Align = alBottom
    MultiLine = True
    TabOrder = 0
    OnEnter = FormOnEnter
    object TabSheet5: TTabSheet
      Caption = 'General'
      ImageIndex = 2
      object Label2: TLabel
        Left = 6
        Top = 36
        Width = 39
        Height = 13
        Caption = 'ISI (sec)'
      end
      object cbProgram: TCheckBoxV
        Left = 3
        Top = 7
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Set by Program'
        TabOrder = 0
        OnClick = cbDisplayedClick
        UpdateVarOnToggle = False
      end
      object enIsi: TeditNum
        Left = 72
        Top = 32
        Width = 84
        Height = 21
        TabOrder = 1
        OnExit = enStimDurationExit
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object GroupBox1: TGroupBox
        Left = 224
        Top = 21
        Width = 233
        Height = 97
        Caption = 'Calculated values'
        TabOrder = 2
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
      object Button1: TButton
        Left = 460
        Top = 101
        Width = 40
        Height = 17
        Caption = 'Check'
        TabOrder = 3
        OnClick = enStimDurationExit
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Analog outputs'
      object TabAna: TTabControl
        Left = 0
        Top = 0
        Width = 604
        Height = 134
        Align = alClient
        TabOrder = 0
        Tabs.Strings = (
          '0'
          '1')
        TabIndex = 0
        TabWidth = 20
        OnChange = TabAnaChange
        object DGana: TDrawGrid
          Left = 1
          Top = 27
          Width = 586
          Height = 74
          ColCount = 10
          DefaultRowHeight = 16
          RowCount = 20
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          ScrollBars = ssVertical
          TabOrder = 0
          OnDrawCell = DGanaDrawCell
          OnEnter = FormOnEnter
          OnSelectCell = DGanaSelectCell
          OnSetEditText = DGanaSetEditText
          OnTopLeftChanged = DGanaTopLeftChanged
          RowHeights = (
            16
            18
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16
            16)
        end
        object cbTemp: TComboBox
          Left = 398
          Top = 51
          Width = 96
          Height = 21
          Style = csDropDownList
          DropDownCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 1
          Visible = False
          OnChange = cbTempChange
          OnExit = cbTempExit
          Items.Strings = (
            'Step'
            'Ramp')
        end
        object Bscale: TButton
          Left = 187
          Top = 107
          Width = 75
          Height = 20
          Caption = 'Scaling'
          TabOrder = 2
          OnClick = BscaleClick
        end
        object cbActive: TCheckBoxV
          Left = 16
          Top = 109
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Active'
          TabOrder = 3
          UpdateVarOnToggle = False
        end
        object Bcoo: TButton
          Left = 274
          Top = 107
          Width = 75
          Height = 20
          Caption = 'Coordinates'
          TabOrder = 4
          OnClick = BcooClick
        end
        object cbDisplayed: TCheckBoxV
          Left = 98
          Top = 109
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Displayed'
          TabOrder = 5
          OnClick = cbDisplayedClick
          UpdateVarOnToggle = False
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'digital outputs'
      ImageIndex = 1
      object TabDigi: TTabControl
        Left = 0
        Top = 0
        Width = 604
        Height = 134
        Align = alClient
        TabOrder = 0
        Tabs.Strings = (
          '0'
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
          '15')
        TabIndex = 0
        TabWidth = 20
        OnChange = TabDigiChange
        object Label1: TLabel
          Left = 7
          Top = 27
          Width = 27
          Height = 13
          Caption = 'Mode'
        end
        object cbDigiMode: TcomboBoxV
          Left = 43
          Top = 25
          Width = 61
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbDigiModeChange
          Items.Strings = (
            'Pulses'
            'Train')
          Tnum = G_byte
          UpdateVarOnExit = False
          UpdateVarOnChange = False
        end
        object PageDigi: TPageControl
          Left = 1
          Top = 48
          Width = 588
          Height = 87
          ActivePage = TabSheet4
          TabHeight = 1
          TabOrder = 1
          TabWidth = 1
          object TabSheet3: TTabSheet
            object dgDigi: TDrawGrid
              Left = 2
              Top = 3
              Width = 577
              Height = 72
              ColCount = 7
              DefaultRowHeight = 16
              RowCount = 20
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
              ScrollBars = ssVertical
              TabOrder = 0
              OnDrawCell = DGdigiDrawCell
              OnEnter = FormOnEnter
              OnMouseUp = dgDigiMouseUp
              OnSetEditText = dgDigiSetEditText
              RowHeights = (
                16
                18
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16
                16)
            end
          end
          object TabSheet4: TTabSheet
            ImageIndex = 1
            object Label3: TLabel
              Left = 5
              Top = 9
              Width = 54
              Height = 13
              Caption = 'Pulse width'
            end
            object Label4: TLabel
              Left = 6
              Top = 32
              Width = 86
              Height = 13
              Caption = 'Inter pulse interval'
            end
            object Label5: TLabel
              Left = 6
              Top = 55
              Width = 84
              Height = 13
              Caption = 'Inter burst interval'
            end
            object Label6: TLabel
              Left = 180
              Top = 9
              Width = 75
              Height = 13
              Caption = 'Pulses per burst'
            end
            object Label7: TLabel
              Left = 180
              Top = 32
              Width = 54
              Height = 13
              Caption = 'Burst count'
            end
            object Label8: TLabel
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
            object enInterPulse: TeditNum
              Left = 101
              Top = 26
              Width = 65
              Height = 21
              TabOrder = 1
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
              TabOrder = 2
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
              TabOrder = 3
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
        end
        object cbDispDigi: TCheckBoxV
          Left = 197
          Top = 28
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Displayed'
          TabOrder = 2
          OnClick = cbDisplayedClick
          UpdateVarOnToggle = False
        end
        object cbDigiActive: TCheckBoxV
          Left = 114
          Top = 28
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Active'
          TabOrder = 3
          UpdateVarOnToggle = False
        end
      end
    end
  end
  object Panel0: TPanel
    Left = 0
    Top = 266
    Width = 612
    Height = 29
    Align = alBottom
    TabOrder = 1
    object Panel3: TPanel
      Left = 321
      Top = 1
      Width = 290
      Height = 27
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
      Width = 320
      Height = 27
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
    end
  end
end
