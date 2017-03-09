object getPal0: TgetPal0
  Left = 244
  Top = 87
  Width = 363
  Height = 433
  Caption = 'Palette manager'
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 10
    Width = 70
    Height = 13
    Caption = 'Total depth:'
  end
  object Label9: TLabel
    Left = 45
    Top = 220
    Width = 5
    Height = 13
  end
  object Label14: TLabel
    Left = 225
    Top = 220
    Width = 5
    Height = 13
    Caption = 'Label14'
  end
  object GroupBox4: TGroupBox
    Left = 12
    Top = 160
    Width = 317
    Height = 185
    Caption = 'Luminances (Cd/m²)'
    TabOrder = 6
    object Label19: TLabel
      Left = 20
      Top = 160
      Width = 75
      Height = 13
      Caption = 'BackGround:'
    end
    object editNum17: TeditNum
      Left = 120
      Top = 156
      Width = 73
      Height = 20
      TabOrder = 0
      Text = 'editNum17'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
  end
  object BOK: TButton
    Left = 52
    Top = 363
    Width = 89
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 176
    Top = 363
    Width = 89
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editNum1: TeditNum
    Left = 94
    Top = 8
    Width = 41
    Height = 20
    TabOrder = 2
    Text = 'editNum1'
    Tnum = T_byte
    UpdateVarOnExit = False
    Decimal = 0
  end
  object GroupBox1: TGroupBox
    Left = 17
    Top = 36
    Width = 260
    Height = 109
    Caption = 'Bit plane allocation'
    TabOrder = 3
    object Label2: TLabel
      Left = 12
      Top = 36
      Width = 97
      Height = 13
      Caption = 'Standard objects'
    end
    object Label3: TLabel
      Left = 12
      Top = 58
      Width = 79
      Height = 13
      Caption = 'Static objects'
    end
    object Label4: TLabel
      Left = 12
      Top = 80
      Width = 88
      Height = 13
      Caption = 'Palette rotation'
    end
    object Label5: TLabel
      Left = 120
      Top = 17
      Width = 35
      Height = 13
      Caption = 'Depth'
    end
    object Label6: TLabel
      Left = 176
      Top = 17
      Width = 40
      Height = 13
      Caption = 'Priority'
    end
    object editNum2: TeditNum
      Left = 120
      Top = 34
      Width = 41
      Height = 20
      TabOrder = 0
      Text = 'editNum2'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum3: TeditNum
      Left = 120
      Top = 56
      Width = 41
      Height = 20
      TabOrder = 1
      Text = 'editNum3'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum4: TeditNum
      Left = 120
      Top = 78
      Width = 41
      Height = 20
      TabOrder = 2
      Text = 'editNum4'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum5: TeditNum
      Left = 177
      Top = 34
      Width = 41
      Height = 20
      TabOrder = 3
      Text = 'editNum5'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum6: TeditNum
      Left = 177
      Top = 56
      Width = 41
      Height = 20
      TabOrder = 4
      Text = 'editNum6'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum7: TeditNum
      Left = 177
      Top = 78
      Width = 41
      Height = 20
      TabOrder = 5
      Text = 'editNum7'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 21
    Top = 185
    Width = 140
    Height = 121
    Caption = 'Standard objects '
    TabOrder = 4
    object Label11: TLabel
      Left = 20
      Top = 28
      Width = 12
      Height = 13
      Caption = '1:'
    end
    object Label10: TLabel
      Left = 20
      Top = 50
      Width = 12
      Height = 13
      Caption = '2:'
    end
    object Label12: TLabel
      Left = 20
      Top = 71
      Width = 12
      Height = 13
      Caption = '3:'
    end
    object Label13: TLabel
      Left = 20
      Top = 93
      Width = 12
      Height = 13
      Caption = '4:'
    end
    object editNum9: TeditNum
      Left = 43
      Top = 26
      Width = 41
      Height = 20
      TabOrder = 0
      Text = 'editNum9'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum10: TeditNum
      Left = 43
      Top = 48
      Width = 41
      Height = 20
      TabOrder = 1
      Text = 'editNum10'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum11: TeditNum
      Left = 43
      Top = 70
      Width = 41
      Height = 20
      TabOrder = 2
      Text = 'editNum11'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum12: TeditNum
      Left = 43
      Top = 92
      Width = 41
      Height = 20
      TabOrder = 3
      Text = 'editNum12'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object ScrollBar1: TScrollBar
      Left = 98
      Top = 27
      Width = 17
      Height = 85
      Kind = sbVertical
      TabOrder = 4
    end
  end
  object GroupBox3: TGroupBox
    Left = 174
    Top = 185
    Width = 140
    Height = 121
    Caption = 'Static objects '
    TabOrder = 5
    object Label15: TLabel
      Left = 20
      Top = 28
      Width = 12
      Height = 13
      Caption = '1:'
    end
    object Label16: TLabel
      Left = 20
      Top = 50
      Width = 12
      Height = 13
      Caption = '2:'
    end
    object Label17: TLabel
      Left = 20
      Top = 71
      Width = 12
      Height = 13
      Caption = '3:'
    end
    object Label18: TLabel
      Left = 20
      Top = 93
      Width = 12
      Height = 13
      Caption = '4:'
    end
    object editNum13: TeditNum
      Left = 43
      Top = 26
      Width = 41
      Height = 20
      TabOrder = 0
      Text = 'editNum9'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum14: TeditNum
      Left = 43
      Top = 48
      Width = 41
      Height = 20
      TabOrder = 1
      Text = 'editNum10'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum15: TeditNum
      Left = 43
      Top = 70
      Width = 41
      Height = 20
      TabOrder = 2
      Text = 'editNum11'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object editNum16: TeditNum
      Left = 43
      Top = 92
      Width = 41
      Height = 20
      TabOrder = 3
      Text = 'editNum12'
      Tnum = T_byte
      UpdateVarOnExit = False
      Decimal = 0
    end
    object ScrollBar2: TScrollBar
      Left = 98
      Top = 27
      Width = 17
      Height = 85
      Kind = sbVertical
      TabOrder = 4
    end
  end
end
