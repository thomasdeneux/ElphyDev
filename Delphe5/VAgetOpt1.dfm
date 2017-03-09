object VAGetOptions: TVAGetOptions
  Left = 270
  Top = 122
  BorderStyle = bsDialog
  Caption = 'VAGetOptions'
  ClientHeight = 317
  ClientWidth = 385
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
  object cbOverlap: TCheckBoxV
    Left = 9
    Top = 17
    Width = 161
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Accept overlap'
    TabOrder = 0
    UpdateVarOnToggle = False
  end
  object Bok: TButton
    Left = 109
    Top = 275
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 196
    Top = 275
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 134
    Width = 179
    Height = 124
    Caption = 'Margins (%)'
    TabOrder = 3
    object Label1: TLabel
      Left = 19
      Top = 23
      Width = 18
      Height = 13
      Caption = 'Left'
    end
    object Label2: TLabel
      Left = 19
      Top = 44
      Width = 25
      Height = 13
      Caption = 'Right'
    end
    object Label3: TLabel
      Left = 19
      Top = 68
      Width = 19
      Height = 13
      Caption = 'Top'
    end
    object Label4: TLabel
      Left = 19
      Top = 92
      Width = 33
      Height = 13
      Caption = 'Bottom'
    end
    object enLeft: TeditNum
      Left = 90
      Top = 17
      Width = 73
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enRight: TeditNum
      Left = 90
      Top = 40
      Width = 73
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enTop: TeditNum
      Left = 90
      Top = 63
      Width = 73
      Height = 21
      TabOrder = 2
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enBottom: TeditNum
      Left = 90
      Top = 87
      Width = 73
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 42
    Width = 179
    Height = 82
    Caption = 'Waterfall'
    TabOrder = 4
    object enDx: TLabel
      Left = 19
      Top = 24
      Width = 30
      Height = 13
      Caption = 'Dx (%)'
    end
    object Label8: TLabel
      Left = 19
      Top = 48
      Width = 30
      Height = 13
      Caption = 'Dy (%)'
    end
    object enDeltaX: TeditNum
      Left = 89
      Top = 22
      Width = 73
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDeltaY: TeditNum
      Left = 89
      Top = 44
      Width = 73
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox3: TGroupBox
    Left = 194
    Top = 7
    Width = 182
    Height = 168
    Caption = 'Grid coordinates'
    TabOrder = 5
    object Label5: TLabel
      Left = 19
      Top = 23
      Width = 19
      Height = 13
      Caption = 'Imin'
    end
    object Label6: TLabel
      Left = 19
      Top = 44
      Width = 22
      Height = 13
      Caption = 'Imax'
    end
    object Label7: TLabel
      Left = 19
      Top = 68
      Width = 21
      Height = 13
      Caption = 'Jmin'
    end
    object Label9: TLabel
      Left = 19
      Top = 92
      Width = 24
      Height = 13
      Caption = 'Jmax'
    end
    object enIdispMin: TeditNum
      Left = 75
      Top = 17
      Width = 91
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enIdispMax: TeditNum
      Left = 75
      Top = 40
      Width = 91
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enJdispMin: TeditNum
      Left = 75
      Top = 63
      Width = 91
      Height = 21
      TabOrder = 2
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enJdispMax: TeditNum
      Left = 75
      Top = 87
      Width = 91
      Height = 21
      TabOrder = 3
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object Button1: TButton
      Left = 20
      Top = 112
      Width = 88
      Height = 20
      Caption = 'Autoscale I'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 20
      Top = 136
      Width = 88
      Height = 20
      Caption = 'Autoscale J'
      TabOrder = 5
      OnClick = Button2Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 195
    Top = 181
    Width = 181
    Height = 78
    Caption = 'Intervals between objects'
    TabOrder = 6
    object Label10: TLabel
      Left = 19
      Top = 27
      Width = 30
      Height = 13
      Caption = 'Dx (%)'
    end
    object Label11: TLabel
      Left = 19
      Top = 48
      Width = 30
      Height = 13
      Caption = 'Dy (%)'
    end
    object enDxInt: TeditNum
      Left = 90
      Top = 21
      Width = 73
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDyInt: TeditNum
      Left = 90
      Top = 44
      Width = 73
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
end
