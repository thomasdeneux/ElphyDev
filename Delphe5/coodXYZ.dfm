object CooXYZ: TCooXYZ
  Left = 724
  Top = 237
  BorderStyle = bsDialog
  Caption = 'Coordinates'
  ClientHeight = 300
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 13
    Width = 23
    Height = 13
    Caption = 'Title:'
  end
  object Label2: TLabel
    Left = 15
    Top = 41
    Width = 26
    Height = 13
    Caption = 'Xmin:'
  end
  object Label3: TLabel
    Left = 15
    Top = 65
    Width = 26
    Height = 13
    Caption = 'Xmax'
  end
  object Label4: TLabel
    Left = 15
    Top = 90
    Width = 23
    Height = 13
    Caption = 'Ymin'
  end
  object Label5: TLabel
    Left = 15
    Top = 114
    Width = 26
    Height = 13
    Caption = 'Ymax'
  end
  object Label7: TLabel
    Left = 15
    Top = 137
    Width = 23
    Height = 13
    Caption = 'Zmin'
  end
  object Label8: TLabel
    Left = 15
    Top = 161
    Width = 26
    Height = 13
    Caption = 'Zmax'
  end
  object editNum1: TeditNum
    Left = 60
    Top = 39
    Width = 93
    Height = 21
    TabOrder = 0
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum2: TeditNum
    Left = 60
    Top = 63
    Width = 93
    Height = 21
    TabOrder = 1
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum3: TeditNum
    Left = 60
    Top = 87
    Width = 93
    Height = 21
    TabOrder = 2
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum4: TeditNum
    Left = 60
    Top = 111
    Width = 93
    Height = 21
    TabOrder = 3
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 208
    Top = 38
    Width = 77
    Height = 21
    Caption = 'AutoScale X'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 208
    Top = 87
    Width = 77
    Height = 21
    Caption = 'AutoScale Y'
    TabOrder = 5
    OnClick = Button2Click
  end
  object cbShowScale: TCheckBoxV
    Left = 163
    Top = 187
    Width = 120
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Show Scale'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
  object Button5: TButton
    Left = 76
    Top = 259
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 156
    Top = 259
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object editString1: TeditString
    Left = 60
    Top = 11
    Width = 225
    Height = 21
    TabOrder = 9
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object editNum5: TeditNum
    Left = 60
    Top = 134
    Width = 93
    Height = 21
    TabOrder = 10
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum6: TeditNum
    Left = 60
    Top = 158
    Width = 93
    Height = 21
    TabOrder = 11
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button3: TButton
    Left = 208
    Top = 134
    Width = 77
    Height = 21
    Caption = 'AutoScale Z'
    TabOrder = 12
    OnClick = Button3Click
  end
  inline ColFrame1: TColFrame
    Left = 16
    Top = 213
    Width = 177
    Height = 26
    TabOrder = 13
    inherited Button: TButton
      Width = 73
      Caption = 'Scale Color'
    end
    inherited Panel: TPanel
      Left = 95
    end
  end
  object cbShowGrid: TCheckBoxV
    Left = 16
    Top = 187
    Width = 120
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Show Grid'
    TabOrder = 14
    UpdateVarOnToggle = False
  end
  object ColorDialog1: TColorDialog
    Left = 16
    Top = 271
  end
end
