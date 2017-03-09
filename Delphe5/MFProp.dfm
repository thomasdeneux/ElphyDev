object MFuncProp: TMFuncProp
  Left = 286
  Top = 168
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Function properties'
  ClientHeight = 304
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 3
    Width = 24
    Height = 13
    Caption = 'Text:'
  end
  object Label2: TLabel
    Left = 294
    Top = 3
    Width = 56
    Height = 13
    Caption = 'Parameters:'
  end
  object Label3: TLabel
    Left = 280
    Top = 169
    Width = 30
    Height = 13
    Caption = 'Result'
  end
  object Memo1: TMemo
    Left = 7
    Top = 18
    Width = 261
    Height = 139
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 0
    OnChange = Memo1Change
  end
  object Bvalidate: TButton
    Left = 307
    Top = 261
    Width = 64
    Height = 20
    Caption = 'Validate'
    TabOrder = 1
    OnClick = BvalidateClick
  end
  object Bevaluate: TButton
    Left = 380
    Top = 261
    Width = 64
    Height = 20
    Caption = 'Evaluate'
    TabOrder = 2
    OnClick = Bevaluateclick
  end
  object PanelResult: TPanel
    Left = 322
    Top = 166
    Width = 104
    Height = 21
    TabOrder = 3
  end
  object Bsave: TButton
    Left = 307
    Top = 234
    Width = 64
    Height = 20
    Caption = 'Save'
    TabOrder = 4
    OnClick = BsaveClick
  end
  object DrawGrid1: TDrawGrid
    Left = 294
    Top = 18
    Width = 150
    Height = 140
    ColCount = 2
    DefaultRowHeight = 16
    RowCount = 20
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ScrollBars = ssVertical
    TabOrder = 5
    OnDrawCell = drawgrid1DrawCell
    OnSetEditText = drawgrid1SetEditText
    OnTopLeftChanged = DrawGrid1TopLeftChanged
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 166
    Width = 263
    Height = 115
    Caption = 'Graph parameters:'
    TabOrder = 6
    object Label4: TLabel
      Left = 11
      Top = 19
      Width = 30
      Height = 13
      Caption = 'Xstart:'
    end
    object Label5: TLabel
      Left = 13
      Top = 40
      Width = 28
      Height = 13
      Caption = 'Xend:'
    end
    object Label6: TLabel
      Left = 11
      Top = 62
      Width = 27
      Height = 13
      Caption = 'Ystart'
      OnClick = BchooseClick
    end
    object Label18: TLabel
      Left = 11
      Top = 84
      Width = 25
      Height = 13
      Caption = 'Yend'
    end
    object Label8: TLabel
      Left = 149
      Top = 19
      Width = 26
      Height = 13
      Caption = 'Istart:'
    end
    object Label9: TLabel
      Left = 149
      Top = 40
      Width = 24
      Height = 13
      Caption = 'Iend:'
    end
    object Label19: TLabel
      Left = 149
      Top = 62
      Width = 25
      Height = 13
      Caption = 'Jstart'
      OnClick = BchooseClick
    end
    object Label20: TLabel
      Left = 149
      Top = 84
      Width = 23
      Height = 13
      Caption = 'Jend'
    end
    object enXstart: TeditNum
      Left = 46
      Top = 16
      Width = 89
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enXend: TeditNum
      Left = 46
      Top = 37
      Width = 89
      Height = 21
      TabOrder = 1
      Text = '2000'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enYstart: TeditNum
      Left = 46
      Top = 59
      Width = 89
      Height = 21
      TabOrder = 2
      Text = '1000'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enYend: TeditNum
      Left = 46
      Top = 81
      Width = 89
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enIstart: TeditNum
      Left = 184
      Top = 16
      Width = 67
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enIend: TeditNum
      Left = 184
      Top = 37
      Width = 67
      Height = 21
      TabOrder = 5
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enJstart: TeditNum
      Left = 184
      Top = 59
      Width = 67
      Height = 21
      TabOrder = 6
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enJend: TeditNum
      Left = 184
      Top = 80
      Width = 67
      Height = 21
      TabOrder = 7
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object Bnew: TButton
    Left = 380
    Top = 207
    Width = 64
    Height = 20
    Caption = 'New'
    TabOrder = 7
  end
  object Bload: TButton
    Left = 307
    Top = 207
    Width = 64
    Height = 20
    Caption = 'Load'
    TabOrder = 8
    OnClick = LoadClick
  end
  object Bchoose: TButton
    Left = 380
    Top = 234
    Width = 64
    Height = 20
    Caption = 'Choose'
    TabOrder = 9
    OnClick = BchooseClick
  end
  object RB1: TCheckBoxV
    Left = 276
    Top = 19
    Width = 17
    Height = 17
    TabOrder = 10
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB2: TCheckBoxV
    Left = 276
    Top = 36
    Width = 17
    Height = 17
    TabOrder = 11
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB3: TCheckBoxV
    Left = 276
    Top = 53
    Width = 17
    Height = 17
    TabOrder = 12
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB4: TCheckBoxV
    Left = 276
    Top = 70
    Width = 17
    Height = 17
    TabOrder = 13
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB5: TCheckBoxV
    Left = 276
    Top = 88
    Width = 17
    Height = 17
    TabOrder = 14
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB6: TCheckBoxV
    Left = 276
    Top = 105
    Width = 17
    Height = 17
    TabOrder = 15
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB7: TCheckBoxV
    Left = 276
    Top = 122
    Width = 17
    Height = 17
    TabOrder = 16
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
  object RB8: TCheckBoxV
    Left = 276
    Top = 139
    Width = 17
    Height = 17
    TabOrder = 17
    OnClick = RB1Click
    UpdateVarOnToggle = False
  end
end
