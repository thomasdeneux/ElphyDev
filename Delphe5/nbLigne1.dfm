object NumOfLines: TNumOfLines
  Left = 221
  Top = 125
  Width = 267
  Height = 204
  Caption = 'Effective numbers of lines'
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
    Left = 11
    Top = 11
    Width = 44
    Height = 13
    Caption = 'Column 1'
  end
  object Label2: TLabel
    Left = 11
    Top = 33
    Width = 44
    Height = 13
    Caption = 'Column 2'
  end
  object Label3: TLabel
    Left = 11
    Top = 55
    Width = 44
    Height = 13
    Caption = 'Column 3'
  end
  object Label4: TLabel
    Left = 11
    Top = 77
    Width = 44
    Height = 13
    Caption = 'Column 4'
  end
  object Label5: TLabel
    Left = 11
    Top = 99
    Width = 44
    Height = 13
    Caption = 'Column 5'
  end
  object BOK: TButton
    Left = 44
    Top = 136
    Width = 70
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 143
    Top = 136
    Width = 70
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editNum1: TeditNum
    Left = 80
    Top = 9
    Width = 71
    Height = 21
    TabOrder = 2
    Text = 'editNum1'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum2: TeditNum
    Left = 80
    Top = 31
    Width = 71
    Height = 21
    TabOrder = 3
    Text = 'editNum2'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum3: TeditNum
    Left = 80
    Top = 53
    Width = 71
    Height = 21
    TabOrder = 4
    Text = 'editNum3'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum4: TeditNum
    Left = 80
    Top = 75
    Width = 71
    Height = 21
    TabOrder = 5
    Text = 'editNum4'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object editNum5: TeditNum
    Left = 80
    Top = 97
    Width = 71
    Height = 21
    TabOrder = 6
    Text = 'editNum5'
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Tag = 1
    Left = 166
    Top = 8
    Width = 48
    Height = 20
    Caption = ' Count'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Tag = 2
    Left = 166
    Top = 30
    Width = 48
    Height = 20
    Caption = ' Count'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button3: TButton
    Tag = 3
    Left = 166
    Top = 52
    Width = 48
    Height = 20
    Caption = ' Count'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button4: TButton
    Tag = 4
    Left = 166
    Top = 74
    Width = 48
    Height = 20
    Caption = ' Count'
    TabOrder = 10
    OnClick = Button1Click
  end
  object Button5: TButton
    Tag = 5
    Left = 166
    Top = 96
    Width = 48
    Height = 20
    Caption = ' Count'
    TabOrder = 11
    OnClick = Button1Click
  end
  object ScrollBar1: TScrollBar
    Left = 229
    Top = 10
    Width = 16
    Height = 105
    Kind = sbVertical
    PageSize = 0
    TabOrder = 12
    OnChange = ScrollBar1Change
  end
end
