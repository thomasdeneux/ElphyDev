object FunctionProp: TFunctionProp
  Left = 744
  Top = 222
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'FunctionProp'
  ClientHeight = 312
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
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
    Left = 321
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
  object Bcompile: TButton
    Left = 274
    Top = 208
    Width = 64
    Height = 20
    Caption = 'Validate'
    TabOrder = 1
    OnClick = BcompileClick
  end
  object Bvalidate: TButton
    Left = 274
    Top = 234
    Width = 64
    Height = 20
    Caption = 'Evaluate'
    TabOrder = 2
    OnClick = Bevaluateclick
  end
  object PanelResult: TPanel
    Left = 363
    Top = 166
    Width = 104
    Height = 21
    TabOrder = 3
  end
  object Bsave: TButton
    Left = 348
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
    Width = 195
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
  object RB1: TRadioButton
    Tag = 1
    Left = 275
    Top = 20
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    TabOrder = 6
    OnClick = RB1Click
  end
  object RB2: TRadioButton
    Tag = 2
    Left = 275
    Top = 37
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB2'
    TabOrder = 7
    OnClick = RB1Click
  end
  object RB3: TRadioButton
    Tag = 3
    Left = 275
    Top = 54
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB3'
    TabOrder = 8
    OnClick = RB1Click
  end
  object RB4: TRadioButton
    Tag = 4
    Left = 275
    Top = 71
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB4'
    TabOrder = 9
    OnClick = RB1Click
  end
  object RB5: TRadioButton
    Tag = 5
    Left = 275
    Top = 88
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB5'
    TabOrder = 10
    OnClick = RB1Click
  end
  object RB6: TRadioButton
    Tag = 6
    Left = 275
    Top = 105
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB6'
    TabOrder = 11
    OnClick = RB1Click
  end
  object RB7: TRadioButton
    Tag = 7
    Left = 275
    Top = 122
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB7'
    TabOrder = 12
    OnClick = RB1Click
  end
  object RB8: TRadioButton
    Tag = 8
    Left = 275
    Top = 139
    Width = 16
    Height = 17
    Alignment = taLeftJustify
    Caption = 'RB8'
    TabOrder = 13
    OnClick = RB1Click
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 166
    Width = 209
    Height = 133
    Caption = 'Graph parameters:'
    TabOrder = 14
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
      Width = 23
      Height = 13
      Caption = 'Istart'
      OnClick = BchooseClick
    end
    object Label18: TLabel
      Left = 11
      Top = 84
      Width = 21
      Height = 13
      Caption = 'Iend'
    end
    object Label8: TLabel
      Left = 12
      Top = 110
      Width = 35
      Height = 13
      Caption = 'Xorigin:'
    end
    object editNum1: TeditNum
      Left = 63
      Top = 16
      Width = 137
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object editNum2: TeditNum
      Left = 63
      Top = 37
      Width = 137
      Height = 21
      TabOrder = 1
      Text = '2000'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object editNum3: TeditNum
      Left = 118
      Top = 59
      Width = 82
      Height = 21
      TabOrder = 2
      Text = '1000'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object editNum4: TeditNum
      Left = 118
      Top = 81
      Width = 82
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object editNum5: TeditNum
      Left = 64
      Top = 107
      Width = 137
      Height = 21
      TabOrder = 4
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object Bnew: TButton
    Left = 421
    Top = 207
    Width = 64
    Height = 20
    Caption = 'New'
    TabOrder = 15
  end
  object Bload: TButton
    Left = 348
    Top = 207
    Width = 64
    Height = 20
    Caption = 'Load'
    TabOrder = 16
    OnClick = LoadClick
  end
  object Bchoose: TButton
    Left = 421
    Top = 234
    Width = 64
    Height = 20
    Caption = 'Choose'
    TabOrder = 17
    OnClick = BchooseClick
  end
end
