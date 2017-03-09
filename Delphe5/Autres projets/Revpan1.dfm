object revPanel: TrevPanel
  Left = 350
  Top = 192
  BorderStyle = bsToolWindow
  Caption = 'revPanel'
  ClientHeight = 227
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 351
    Height = 227
    ActivePage = Pcriteria
    Align = alClient
    TabOrder = 0
    OnChange = pageControl1Change
    object Pgeneral: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 8
        Top = 10
        Width = 35
        Height = 13
        Caption = 'Evt file:'
      end
      object Label2: TLabel
        Left = 9
        Top = 37
        Width = 59
        Height = 13
        Caption = 'Data vector:'
      end
      object esEvtFile: TeditString
        Left = 51
        Top = 9
        Width = 158
        Height = 21
        TabOrder = 0
        len = 0
        UpdateVarOnExit = False
      end
      object BevtFile: TButton
        Left = 219
        Top = 9
        Width = 46
        Height = 21
        Caption = 'Choose'
        TabOrder = 1
        OnClick = BevtFileClick
      end
      object Bcalculate: TButton
        Left = 186
        Top = 172
        Width = 54
        Height = 21
        Caption = 'Calculate'
        TabOrder = 2
        OnClick = BcalculateClick
      end
      object cbDataVector: TcomboBoxV
        Left = 72
        Top = 34
        Width = 153
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 3
        OnChange = cbDataVectorChange
        OnDropDown = cbDataVectorDropDown
        Tnum = T_byte
        UpdateVarOnExit = False
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 59
        Width = 272
        Height = 75
        Caption = 'Time'
        TabOrder = 4
        object Label4: TLabel
          Left = 23
          Top = 17
          Width = 24
          Height = 13
          Caption = 'maxi:'
        end
        object Label7: TLabel
          Left = 28
          Top = 42
          Width = 15
          Height = 13
          Caption = 'dt0'
        end
        object enT2: TeditNum
          Left = 54
          Top = 15
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '100'
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDt0: TeditNum
          Left = 54
          Top = 38
          Width = 73
          Height = 21
          TabOrder = 1
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
    object Pcriteria: TTabSheet
      Caption = 'Criteria'
      object TabSheet1: TTabSheet
        Caption = 'Criteria'
        object ListBox1: TListBox
          Left = 6
          Top = 33
          Width = 121
          Height = 97
          ItemHeight = 13
          TabOrder = 0
        end
        object editNum5: TeditNum
          Left = 181
          Top = 32
          Width = 73
          Height = 21
          TabOrder = 1
          Text = 'editNum5'
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
      object Badd: TButton
        Left = 6
        Top = 140
        Width = 50
        Height = 20
        Caption = 'Add'
        TabOrder = 1
        OnClick = BaddClick
      end
      object Bremove: TButton
        Left = 70
        Top = 141
        Width = 50
        Height = 20
        Caption = 'Remove'
        TabOrder = 2
        OnClick = BremoveClick
      end
      object Bdistri: TButton
        Left = 250
        Top = 140
        Width = 66
        Height = 20
        Caption = 'Distribution'
        TabOrder = 3
        OnClick = BdistriClick
      end
      object DrawGrid1: TDrawGrid
        Left = 0
        Top = 0
        Width = 343
        Height = 123
        Align = alTop
        ColCount = 4
        DefaultRowHeight = 16
        RowCount = 22
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 4
        OnDrawCell = drawGrid1DrawCell
        OnGetEditText = DrawGrid1GetEditText
        OnMouseUp = DrawGrid1MouseUp
        OnSetEditText = DrawGrid1SetEditText
      end
      object BminMax: TButton
        Left = 134
        Top = 140
        Width = 90
        Height = 20
        Caption = 'Search min max'
        TabOrder = 5
        OnClick = BminMaxClick
      end
    end
    object Pdisplay: TTabSheet
      Caption = 'Display'
      OnEnter = PdisplayEnter
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 343
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object PaintBox1: TPaintBox
          Left = 0
          Top = 0
          Width = 343
          Height = 21
          Align = alClient
          OnPaint = PaintBox1Paint
        end
      end
      object cbAutoScale: TCheckBoxV
        Left = 10
        Top = 175
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Autoscale'
        TabOrder = 1
        UpdateVarOnToggle = False
      end
      object GroupBox3: TGroupBox
        Left = 2
        Top = 25
        Width = 340
        Height = 58
        Caption = 'Time'
        TabOrder = 2
        object Lt: TLabel
          Left = 10
          Top = 14
          Width = 9
          Height = 13
          Caption = 't='
        end
        object Ldt: TLabel
          Left = 10
          Top = 31
          Width = 15
          Height = 13
          Caption = 'dt='
        end
        object LzupRaw: TLabel
          Left = 206
          Top = 16
          Width = 45
          Height = 13
          Caption = 'LzupRaw'
        end
        object sbT: TscrollbarV
          Left = 98
          Top = 13
          Width = 93
          Height = 16
          Max = 30000
          PageSize = 0
          TabOrder = 0
          Xmax = 1000.000000000000000000
          dxSmall = 1.000000000000000000
          dxLarge = 10.000000000000000000
          OnScrollV = sbTScrollV
        end
        object sbDT: TscrollbarV
          Left = 98
          Top = 32
          Width = 93
          Height = 16
          Max = 30000
          PageSize = 0
          TabOrder = 1
          Xmax = 1000.000000000000000000
          dxSmall = 1.000000000000000000
          dxLarge = 10.000000000000000000
          OnScrollV = sbDTScrollV
        end
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 87
        Width = 340
        Height = 85
        Caption = 'Main criterion'
        TabOrder = 3
        object Lx: TLabel
          Left = 10
          Top = 39
          Width = 11
          Height = 13
          Caption = 'x='
        end
        object Ldx: TLabel
          Left = 10
          Top = 60
          Width = 17
          Height = 13
          Caption = 'dx='
        end
        object LN1: TLabel
          Left = 253
          Top = 23
          Width = 20
          Height = 13
          Caption = 'N1='
        end
        object LN2: TLabel
          Left = 254
          Top = 46
          Width = 20
          Height = 13
          Caption = 'N2='
        end
        object sbX: TscrollbarV
          Left = 142
          Top = 37
          Width = 93
          Height = 16
          Max = 30000
          PageSize = 0
          TabOrder = 0
          Xmax = 1000.000000000000000000
          dxSmall = 1.000000000000000000
          dxLarge = 10.000000000000000000
          OnScrollV = sbXScrollV
        end
        object sbDx: TscrollbarV
          Left = 142
          Top = 61
          Width = 93
          Height = 16
          Max = 30000
          PageSize = 0
          TabOrder = 1
          Xmax = 1000.000000000000000000
          dxSmall = 1.000000000000000000
          dxLarge = 10.000000000000000000
          OnScrollV = sbDxScrollV
        end
        object cbMainC: TcomboBoxV
          Left = 32
          Top = 13
          Width = 204
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 2
          OnChange = cbMainCChange
          OnDropDown = cbMainCDropDown
          Tnum = T_byte
          UpdateVarOnExit = False
        end
        object enXC: TeditNum
          Left = 32
          Top = 35
          Width = 102
          Height = 21
          TabOrder = 3
          OnEnter = enXCEnter
          OnExit = enXCEnter
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
        object enDxC: TeditNum
          Left = 32
          Top = 58
          Width = 102
          Height = 21
          TabOrder = 4
          Text = '110'
          OnEnter = enDxCEnter
          OnExit = enDxCEnter
          Tnum = T_byte
          Max = 255.000000000000000000
          UpdateVarOnExit = False
          Decimal = 0
          Dxu = 1.000000000000000000
        end
      end
    end
    object Popti: TTabSheet
      Caption = 'Optimization'
      object Label3: TLabel
        Left = 17
        Top = 111
        Width = 50
        Height = 13
        Caption = 'Threshold:'
      end
      object GroupBox2: TGroupBox
        Left = 13
        Top = 12
        Width = 210
        Height = 84
        Caption = 'Results'
        TabOrder = 0
        object LNmoyen: TLabel
          Left = 15
          Top = 21
          Width = 14
          Height = 13
          Caption = 'N='
        end
        object LdeltaN: TLabel
          Left = 15
          Top = 38
          Width = 39
          Height = 13
          Caption = 'DeltaN='
        end
        object LzupOpt: TLabel
          Left = 16
          Top = 56
          Width = 25
          Height = 13
          Caption = 'Zup='
        end
      end
      object Button1: TButton
        Left = 17
        Top = 159
        Width = 68
        Height = 20
        Caption = 'Calculate'
        TabOrder = 1
        OnClick = Button1Click
      end
      object enSeuil: TeditNum
        Left = 78
        Top = 108
        Width = 121
        Height = 21
        TabOrder = 2
        Tnum = T_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object cbUseTh: TCheckBoxV
        Left = 16
        Top = 133
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Use threshold'
        TabOrder = 3
        UpdateVarOnToggle = False
      end
    end
  end
end
