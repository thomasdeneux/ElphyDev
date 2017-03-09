inherited VlistForm: TVlistForm
  Left = 454
  Top = 218
  Width = 651
  Height = 560
  Caption = 'Vlist form'
  OldCreateOrder = True
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited PaintBox0: TPaintBox
    Width = 643
    Height = 431
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 431
    Width = 643
    Height = 83
    Align = alBottom
    TabOrder = 0
    object Label2: TLabel
      Left = 12
      Top = 59
      Width = 85
      Height = 13
      Caption = 'Displayed Vectors'
    end
    object Label3: TLabel
      Left = 242
      Top = 12
      Width = 65
      Height = 13
      Caption = 'Vertical Scale'
    end
    object GroupBox1: TGroupBox
      Left = 401
      Top = 6
      Width = 193
      Height = 73
      Caption = 'Waterfall'
      TabOrder = 0
      object Label4: TLabel
        Left = 13
        Top = 22
        Width = 13
        Height = 13
        Caption = 'Dx'
      end
      object Label1: TLabel
        Left = 13
        Top = 44
        Width = 13
        Height = 13
        Caption = 'Dy'
      end
      object enDxAff: TeditNum
        Left = 32
        Top = 17
        Width = 54
        Height = 21
        TabOrder = 0
        OnExit = enDxAffExit
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enDyAff: TeditNum
        Left = 32
        Top = 39
        Width = 54
        Height = 21
        TabOrder = 1
        OnExit = enDxAffExit
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object sbDx: TScrollBar
        Left = 93
        Top = 20
        Width = 93
        Height = 16
        LargeChange = 10
        Min = -100
        PageSize = 0
        TabOrder = 2
        OnScroll = sbDxScroll
      end
      object sbDy: TScrollBar
        Left = 93
        Top = 42
        Width = 93
        Height = 16
        LargeChange = 10
        Min = -100
        PageSize = 0
        TabOrder = 3
        OnScroll = sbDyScroll
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 5
      Width = 233
      Height = 26
      BevelOuter = bvNone
      TabOrder = 1
      object Pnum: TPanel
        Left = 53
        Top = 0
        Width = 67
        Height = 26
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '1 / 10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 53
        Height = 26
        Align = alLeft
        Caption = 'Vector'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object SBindex: TscrollbarV
        Left = 127
        Top = 6
        Width = 101
        Height = 17
        Max = 30000
        PageSize = 0
        TabOrder = 2
        Xmax = 1000.000000000000000000
        dxSmall = 1.000000000000000000
        dxLarge = 10.000000000000000000
        OnScrollV = SBindexScrollV
      end
    end
    object Panel9: TPanel
      Left = 0
      Top = 30
      Width = 233
      Height = 25
      BevelOuter = bvNone
      TabOrder = 2
      object cbHold: TCheckBoxV
        Left = 9
        Top = 4
        Width = 76
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Hold traces'
        TabOrder = 0
        OnClick = cbHoldClick
        UpdateVarOnToggle = True
      end
      object BdisplayAll: TButton
        Left = 125
        Top = 3
        Width = 75
        Height = 20
        Caption = 'Display All'
        TabOrder = 1
        OnClick = BdisplayAllClick
      end
    end
    object enNbLine: TeditNum
      Left = 123
      Top = 56
      Width = 107
      Height = 21
      TabOrder = 3
      Text = '10'
      OnExit = enNbLineExit
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbVscale: TcomboBoxV
      Left = 317
      Top = 8
      Width = 74
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = cbVscaleChange
      Items.Strings = (
        'Standard'
        'Numbers'
        'None')
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbDisplaySel: TCheckBoxV
      Left = 241
      Top = 36
      Width = 119
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Display Selection'
      TabOrder = 5
      OnClick = cbShowNumClick
      UpdateVarOnToggle = True
    end
    object Bupdate: TButton
      Left = 237
      Top = 57
      Width = 47
      Height = 20
      Caption = 'Update'
      TabOrder = 6
      OnClick = BupdateClick
    end
  end
  inherited MainMenu1: TMainMenu
    inherited File1: TMenuItem
      object Save1: TMenuItem [0]
        Caption = 'Save selection'
        object NewFile1: TMenuItem
          Caption = 'New File'
          OnClick = NewFile1Click
        end
        object Append1: TMenuItem
          Caption = 'Append'
          OnClick = Append1Click
        end
      end
      object Copyselection1: TMenuItem [1]
        Caption = 'Copy selection'
        OnClick = Copyselection1Click
      end
    end
    object Edit1: TMenuItem [1]
      Caption = 'Edit'
      object SelectAll1: TMenuItem
        Caption = 'Select All'
        OnClick = SelectAll1Click
      end
      object UnselectAll1: TMenuItem
        Caption = 'Unselect All'
        OnClick = UnselectAll1Click
      end
    end
  end
end
