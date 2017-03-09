object ProcessFileForm: TProcessFileForm
  Left = 565
  Top = 121
  BorderStyle = bsDialog
  Caption = 'ProcessFile'
  ClientHeight = 462
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 17
    Top = 423
    Width = 134
    Height = 13
    Caption = 'Delay after each episod (ms)'
  end
  object Bexecute: TButton
    Left = 381
    Top = 229
    Width = 64
    Height = 25
    Caption = 'Execute'
    ModalResult = 1
    TabOrder = 0
  end
  object Bclose: TButton
    Left = 381
    Top = 269
    Width = 64
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 203
    Height = 104
    Caption = 'File'
    TabOrder = 2
    object Label1: TLabel
      Left = 13
      Top = 50
      Width = 59
      Height = 13
      Caption = 'First episode'
    end
    object Label2: TLabel
      Left = 13
      Top = 73
      Width = 60
      Height = 13
      Caption = 'Last episode'
    end
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Object'
    end
    object enFirst: TeditNum
      Left = 88
      Top = 46
      Width = 79
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enLast: TeditNum
      Left = 88
      Top = 69
      Width = 79
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbDF: TcomboBoxV
      Left = 56
      Top = 21
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'cbDF'
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object Bautoscale: TBitBtn
      Left = 173
      Top = 56
      Width = 14
      Height = 14
      TabOrder = 3
      OnClick = BautoscaleClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333300000000000
        0033388888888888883330F888888888803338F333333333383330F333333333
        803338F333333333383330F333333333803338F333333333383330F333303333
        803338F333333333383330F333000333803338F333333333383330F330000033
        803338F333333333383330F333000333803338F333333333383330F333303333
        803338F333333333383330F333333333803338F333333333383330F333333333
        803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
        0033388888888888883333333333333333333333333333333333}
      NumGlyphs = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 216
    Top = 8
    Width = 241
    Height = 104
    Caption = 'Program'
    TabOrder = 3
    object Label5: TLabel
      Left = 8
      Top = 25
      Width = 52
      Height = 13
      Caption = 'InitProcess'
    end
    object Label6: TLabel
      Left = 8
      Top = 46
      Width = 38
      Height = 13
      Caption = 'Process'
    end
    object Label7: TLabel
      Left = 8
      Top = 67
      Width = 57
      Height = 13
      Caption = 'EndProcess'
    end
    object cbInit: TcomboBoxV
      Left = 79
      Top = 22
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbProcess: TcomboBoxV
      Left = 79
      Top = 43
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbEnd: TcomboBoxV
      Left = 79
      Top = 64
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object cbInitValid: TCheckBoxV
      Left = 216
      Top = 24
      Width = 18
      Height = 17
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object cbProcessValid: TCheckBoxV
      Left = 216
      Top = 45
      Width = 18
      Height = 17
      TabOrder = 4
      UpdateVarOnToggle = False
    end
    object cbEndValid: TCheckBoxV
      Left = 216
      Top = 66
      Width = 18
      Height = 17
      TabOrder = 5
      UpdateVarOnToggle = False
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 120
    Width = 313
    Height = 129
    Caption = 'Refresh following objects after each episode'
    TabOrder = 4
    object Badd: TButton
      Left = 240
      Top = 20
      Width = 56
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = BaddClick
    end
    object Bremove: TButton
      Left = 240
      Top = 60
      Width = 56
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = BremoveClick
    end
    object lbRefresh: TListBox
      Left = 8
      Top = 15
      Width = 216
      Height = 106
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 259
    Width = 313
    Height = 126
    Caption = 'Clear following objects before processing'
    TabOrder = 5
    object bAddClear: TButton
      Left = 240
      Top = 20
      Width = 56
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = bAddClearClick
    end
    object BremoveClear: TButton
      Left = 240
      Top = 60
      Width = 56
      Height = 25
      Caption = 'Remove'
      TabOrder = 1
      OnClick = BremoveClearClick
    end
    object lbClear: TListBox
      Left = 8
      Top = 15
      Width = 216
      Height = 106
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object cbUpdate: TCheckBoxV
    Left = 368
    Top = 135
    Width = 78
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Display'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
  object cbPause: TCheckBoxV
    Left = 16
    Top = 399
    Width = 217
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Pause after each episod'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
  object enDelay: TeditNum
    Left = 168
    Top = 419
    Width = 65
    Height = 21
    TabOrder = 8
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
