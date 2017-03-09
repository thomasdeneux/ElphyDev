object LoadBinForm: TLoadBinForm
  Left = 673
  Top = 308
  BorderStyle = bsDialog
  Caption = 'Load Binary File'
  ClientHeight = 545
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 120
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 433
    Height = 345
    Caption = 'Main Parameters'
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 31
      Width = 119
      Height = 16
      Caption = 'Header Size (bytes)'
    end
    object Label2: TLabel
      Left = 32
      Top = 57
      Width = 64
      Height = 16
      Caption = 'Data Type'
    end
    object Label3: TLabel
      Left = 32
      Top = 83
      Width = 57
      Height = 16
      Caption = 'Nchannel'
    end
    object label4: TLabel
      Left = 32
      Top = 109
      Width = 16
      Height = 16
      Caption = 'Dx'
    end
    object Label5: TLabel
      Left = 32
      Top = 136
      Width = 13
      Height = 16
      Caption = 'x0'
    end
    object Label6: TLabel
      Left = 32
      Top = 163
      Width = 31
      Height = 16
      Caption = 'UnitX'
    end
    object Label7: TLabel
      Left = 32
      Top = 189
      Width = 17
      Height = 16
      Caption = 'Dy'
    end
    object Label8: TLabel
      Left = 32
      Top = 216
      Width = 14
      Height = 16
      Caption = 'y0'
    end
    object Label9: TLabel
      Left = 32
      Top = 243
      Width = 32
      Height = 16
      Caption = 'UnitY'
    end
    object Label10: TLabel
      Left = 32
      Top = 311
      Width = 132
      Height = 16
      Caption = 'Samples Per Episode'
    end
    object enHeaderSize: TeditNum
      Left = 182
      Top = 28
      Width = 185
      Height = 24
      TabOrder = 0
      Text = 'enHeaderSize'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbNumType: TcomboBoxV
      Left = 182
      Top = 54
      Width = 145
      Height = 24
      ItemHeight = 16
      TabOrder = 1
      Text = 'cbNumType'
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
    object enNchannel: TeditNum
      Left = 182
      Top = 80
      Width = 185
      Height = 24
      TabOrder = 2
      Text = 'enNchannel'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDx: TeditNum
      Left = 182
      Top = 106
      Width = 185
      Height = 24
      TabOrder = 3
      Text = 'enNchannel'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enX0: TeditNum
      Left = 182
      Top = 133
      Width = 185
      Height = 24
      TabOrder = 4
      Text = 'enNchannel'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDy: TeditNum
      Left = 182
      Top = 186
      Width = 185
      Height = 24
      TabOrder = 5
      Text = 'enNchannel'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enY0: TeditNum
      Left = 182
      Top = 213
      Width = 185
      Height = 24
      TabOrder = 6
      Text = 'enNchannel'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbContinuous: TCheckBoxV
      Left = 30
      Top = 268
      Width = 167
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Continuous'
      TabOrder = 7
      UpdateVarOnToggle = False
    end
    object cbMultiplexed: TCheckBoxV
      Left = 30
      Top = 288
      Width = 167
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Multiplexed'
      TabOrder = 8
      UpdateVarOnToggle = False
    end
    object enSample: TeditNum
      Left = 182
      Top = 308
      Width = 185
      Height = 24
      TabOrder = 9
      Text = 'enNchannel'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object esUnitX: TeditString
      Left = 182
      Top = 160
      Width = 185
      Height = 24
      TabOrder = 10
      Text = 'esUnitX'
      len = 0
      UpdateVarOnExit = False
    end
    object esUnitY: TeditString
      Left = 182
      Top = 240
      Width = 185
      Height = 24
      TabOrder = 11
      Text = 'esUnitX'
      len = 0
      UpdateVarOnExit = False
    end
  end
  object Bok: TButton
    Left = 142
    Top = 491
    Width = 92
    Height = 31
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 241
    Top = 491
    Width = 92
    Height = 31
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 368
    Width = 433
    Height = 105
    Caption = 'Parameter File'
    TabOrder = 3
    object LabName: TLabel
      Left = 24
      Top = 24
      Width = 161
      Height = 19
      Caption = 'Cont 64 channels 30K'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bload: TButton
      Left = 22
      Top = 58
      Width = 92
      Height = 25
      Caption = 'Load'
      TabOrder = 0
      OnClick = BloadClick
    end
    object Bsave: TButton
      Left = 179
      Top = 58
      Width = 92
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = BsaveClick
    end
  end
end
