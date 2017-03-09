object VisualSys: TVisualSys
  Left = 610
  Top = 214
  BorderStyle = bsDialog
  Caption = 'System parameters'
  ClientHeight = 561
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 78
    Width = 94
    Height = 13
    Caption = 'Refresh interval ('#181's)'
  end
  object Label2: TLabel
    Left = 14
    Top = 43
    Width = 63
    Height = 13
    Caption = 'Display mode'
  end
  object Label3: TLabel
    Left = 15
    Top = 13
    Width = 34
    Height = 13
    Caption = 'Device'
  end
  object Shape1: TShape
    Left = 447
    Top = 77
    Width = 13
    Height = 16
    Brush.Color = clRed
    Shape = stCircle
    Visible = False
  end
  object Label4: TLabel
    Left = 15
    Top = 102
    Width = 167
    Height = 13
    Caption = 'Screen distance from observer (cm)'
  end
  object Label5: TLabel
    Left = 15
    Top = 125
    Width = 89
    Height = 13
    Caption = 'Screen height (cm)'
  end
  object Label7: TLabel
    Left = 16
    Top = 146
    Width = 33
    Height = 13
    Caption = 'Palette'
  end
  object LlumMax: TLabel
    Left = 16
    Top = 415
    Width = 145
    Height = 13
    Caption = 'Required Maximum Luminance'
  end
  object enRefreshRate: TeditNum
    Left = 196
    Top = 75
    Width = 77
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 164
    Top = 521
    Width = 63
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 250
    Top = 521
    Width = 63
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cbUseAcqInt: TCheckBoxV
    Left = 296
    Top = 13
    Width = 174
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use acquisition interface'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
  object cbAlwaysActivate: TCheckBoxV
    Left = 296
    Top = 31
    Width = 174
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Always activate visual stimulator'
    TabOrder = 4
    UpdateVarOnToggle = False
  end
  object cbDisplayMode: TcomboBoxV
    Left = 136
    Top = 40
    Width = 137
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = '480x640'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object Bmeasure: TButton
    Left = 298
    Top = 75
    Width = 134
    Height = 20
    Caption = 'Measure refresh interval'
    TabOrder = 6
    OnClick = BmeasureClick
  end
  object cbDevice: TcomboBoxV
    Left = 56
    Top = 10
    Width = 217
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'Dev1'
    OnChange = cbDeviceChange
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object enScreenDistance: TeditNum
    Left = 196
    Top = 99
    Width = 77
    Height = 21
    TabOrder = 8
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enScreenHeight: TeditNum
    Left = 196
    Top = 120
    Width = 77
    Height = 21
    TabOrder = 9
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 171
    Width = 464
    Height = 237
    Caption = 'Calibration'
    TabOrder = 10
    object Label6: TLabel
      Left = 9
      Top = 23
      Width = 48
      Height = 13
      Caption = 'File name:'
    end
    object PfileName: TPanel
      Left = 64
      Top = 20
      Width = 302
      Height = 20
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      Caption = 'PfileName'
      TabOrder = 0
    end
    object Bchoose: TButton
      Left = 380
      Top = 21
      Width = 44
      Height = 18
      Caption = 'Choose'
      TabOrder = 1
      OnClick = BchooseClick
    end
    object Pdisplay: TPanel
      Left = 6
      Top = 46
      Width = 451
      Height = 188
      BevelOuter = bvLowered
      TabOrder = 2
      inline CalibFrame: TDispFrame
        Left = 1
        Top = 1
        Width = 449
        Height = 186
        Align = alClient
        TabOrder = 0
        inherited PaintBox1: TPaintBox
          Width = 449
          Height = 186
        end
      end
    end
  end
  object cbPalette: TcomboBoxV
    Left = 196
    Top = 144
    Width = 77
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 11
    Items.Strings = (
      '')
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object GroupBox2: TGroupBox
    Left = 9
    Top = 449
    Width = 464
    Height = 57
    Caption = 'Synchronisation'
    TabOrder = 12
    object Label8: TLabel
      Left = 16
      Top = 21
      Width = 27
      Height = 13
      Caption = 'Mode'
    end
    object cbSyncMode: TcomboBoxV
      Left = 57
      Top = 18
      Width = 168
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
      OnChange = cbSyncModeChange
      Items.Strings = (
        'Red and Blue lines'
        'Spot detection'
        'None')
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = True
    end
    object BsyncParams: TButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Parameters'
      TabOrder = 1
      OnClick = BsyncParamsClick
    end
  end
  object enLumMax: TeditNum
    Left = 189
    Top = 410
    Width = 77
    Height = 21
    TabOrder = 13
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbWinMode: TCheckBoxV
    Left = 296
    Top = 49
    Width = 174
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Window mode (debug)'
    TabOrder = 14
    UpdateVarOnToggle = False
  end
end
