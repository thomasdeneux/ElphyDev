inherited getMseq: TgetMseq
  Left = 624
  Top = 373
  Height = 277
  Caption = 'getMseq'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label3: TLabel
    Top = 224
  end
  object Label1: TLabel [1]
    Left = 3
    Top = 65
    Width = 54
    Height = 13
    Caption = ' divX count'
  end
  object Label2: TLabel [2]
    Left = 2
    Top = 87
    Width = 54
    Height = 13
    Caption = ' divY count'
  end
  object Label4: TLabel [3]
    Left = 6
    Top = 111
    Width = 26
    Height = 13
    Caption = 'Lum1'
  end
  object Label5: TLabel [4]
    Left = 88
    Top = 110
    Width = 26
    Height = 13
    Caption = 'Lum2'
  end
  object Label6: TLabel [5]
    Left = 3
    Top = 132
    Width = 52
    Height = 13
    Caption = ' Expansion'
  end
  object Label8: TLabel [6]
    Left = 8
    Top = 210
    Width = 14
    Height = 13
    Caption = 'RF'
  end
  object Label9: TLabel [7]
    Left = 83
    Top = 154
    Width = 25
    Height = 13
    Caption = 'Seed'
  end
  object Label10: TLabel [8]
    Left = 4
    Top = 43
    Width = 30
    Height = 13
    Caption = 'DtON:'
  end
  object Label11: TLabel [9]
    Left = 92
    Top = 43
    Width = 34
    Height = 13
    Caption = 'DtOFF:'
  end
  object Label12: TLabel [10]
    Left = 90
    Top = 23
    Width = 34
    Height = 13
    Caption = 'Cycles:'
  end
  object Label13: TLabel [11]
    Left = 4
    Top = 23
    Width = 30
    Height = 13
    Caption = 'Delay:'
  end
  object Label7: TLabel [12]
    Left = 4
    Top = 4
    Width = 27
    Height = 13
    Caption = 'order:'
  end
  inherited CBvisual: TComboBox
    Top = 221
  end
  object enLum1: TeditNum
    Left = 40
    Top = 109
    Width = 41
    Height = 21
    TabOrder = 1
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enLum2: TeditNum
    Left = 135
    Top = 107
    Width = 42
    Height = 21
    TabOrder = 2
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enSeed: TeditNum
    Left = 122
    Top = 152
    Width = 55
    Height = 21
    TabOrder = 3
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object cbOnControl: TCheckBox
    Left = 5
    Top = 199
    Width = 74
    Height = 22
    Alignment = taLeftJustify
    Caption = 'On control'
    TabOrder = 4
    OnClick = cbOnControlClick
  end
  object cbOnScreen: TCheckBox
    Left = 103
    Top = 198
    Width = 74
    Height = 22
    Alignment = taLeftJustify
    Caption = 'On screen'
    TabOrder = 5
    OnClick = cbOnScreenClick
  end
  object enDtON: TeditNum
    Left = 35
    Top = 40
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 6
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enDtOff: TeditNum
    Left = 127
    Top = 41
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 7
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enCycleCount: TeditNum
    Left = 127
    Top = 22
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 8
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object enDelay: TeditNum
    Left = 35
    Top = 22
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 9
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 4
    Top = 151
    Width = 55
    Height = 20
    Caption = 'Select RF'
    TabOrder = 10
    OnClick = Button1Click
  end
  object CBadjust: TCheckBoxV
    Left = 5
    Top = 181
    Width = 106
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Adjust object size'
    TabOrder = 11
    UpdateVarOnToggle = True
  end
  object enOrder: TeditNum
    Left = 35
    Top = 3
    Width = 50
    Height = 18
    AutoSize = False
    TabOrder = 12
    OnExit = enOrderChange
    UpdateVarOnExit = True
    Decimal = 3
    Dxu = 1.000000000000000000
  end
  object cbDivX: TcomboBoxV
    Left = 98
    Top = 62
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 13
    UpdateVarOnExit = True
    UpdateVarOnChange = False
  end
  object cbDivY: TcomboBoxV
    Left = 98
    Top = 83
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 14
    UpdateVarOnExit = True
    UpdateVarOnChange = False
  end
  object cbExpansion: TcomboBoxV
    Left = 98
    Top = 129
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 15
    UpdateVarOnExit = True
    UpdateVarOnChange = False
  end
end
