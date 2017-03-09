object DfSaveList: TDfSaveList
  Left = 238
  Top = 163
  BorderStyle = bsDialog
  Caption = 'DfSaveList'
  ClientHeight = 246
  ClientWidth = 246
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
  object Label6: TLabel
    Left = 13
    Top = 111
    Width = 27
    Height = 13
    Caption = 'Xstart'
  end
  object Label7: TLabel
    Left = 13
    Top = 133
    Width = 25
    Height = 13
    Caption = 'Xend'
  end
  object Label1: TLabel
    Left = 13
    Top = 155
    Width = 22
    Height = 13
    Caption = 'Xorg'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 5
    Width = 228
    Height = 95
    Caption = 'Saved channels'
    TabOrder = 0
    object CheckBoxV1: TCheckBoxV
      Left = 14
      Top = 18
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v1'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object CheckBoxV2: TCheckBoxV
      Left = 14
      Top = 34
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v2'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object CheckBoxV3: TCheckBoxV
      Left = 14
      Top = 50
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v3'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object CheckBoxV4: TCheckBoxV
      Left = 14
      Top = 66
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v4'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object CheckBoxV5: TCheckBoxV
      Left = 65
      Top = 18
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v5'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
    object CheckBoxV6: TCheckBoxV
      Left = 65
      Top = 34
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v6'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
    object CheckBoxV7: TCheckBoxV
      Left = 65
      Top = 50
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v7'
      TabOrder = 6
      UpdateVarOnToggle = False
    end
    object CheckBoxV8: TCheckBoxV
      Left = 65
      Top = 66
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v8'
      TabOrder = 7
      UpdateVarOnToggle = False
    end
    object CheckBoxV9: TCheckBoxV
      Left = 118
      Top = 17
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v9'
      TabOrder = 8
      UpdateVarOnToggle = False
    end
    object CheckBoxV10: TCheckBoxV
      Left = 118
      Top = 33
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v10'
      TabOrder = 9
      UpdateVarOnToggle = False
    end
    object CheckBoxV11: TCheckBoxV
      Left = 118
      Top = 49
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v11'
      TabOrder = 10
      UpdateVarOnToggle = False
    end
    object CheckBoxV12: TCheckBoxV
      Left = 118
      Top = 65
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v12'
      TabOrder = 11
      UpdateVarOnToggle = False
    end
    object CheckBoxV13: TCheckBoxV
      Left = 173
      Top = 18
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v13'
      TabOrder = 12
      UpdateVarOnToggle = False
    end
    object CheckBoxV14: TCheckBoxV
      Left = 173
      Top = 33
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v14'
      TabOrder = 13
      UpdateVarOnToggle = False
    end
    object CheckBoxV15: TCheckBoxV
      Left = 173
      Top = 49
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v15'
      TabOrder = 14
      UpdateVarOnToggle = False
    end
    object CheckBoxV16: TCheckBoxV
      Left = 173
      Top = 65
      Width = 40
      Height = 17
      Alignment = taLeftJustify
      Caption = 'v16'
      TabOrder = 15
      UpdateVarOnToggle = False
    end
  end
  object BsaveData: TButton
    Left = 8
    Top = 211
    Width = 91
    Height = 25
    Caption = 'Save'
    ModalResult = 100
    TabOrder = 1
  end
  object Boptions: TButton
    Left = 143
    Top = 211
    Width = 91
    Height = 25
    Caption = 'Options'
    TabOrder = 2
    OnClick = BoptionsClick
  end
  object enXstart: TeditNum
    Left = 53
    Top = 107
    Width = 95
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enXend: TeditNum
    Left = 53
    Top = 129
    Width = 95
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bautoscale: TButton
    Left = 162
    Top = 119
    Width = 69
    Height = 20
    Caption = 'Autoscale'
    TabOrder = 5
    OnClick = BautoscaleClick
  end
  object enXorg: TeditNum
    Left = 53
    Top = 151
    Width = 95
    Height = 21
    TabOrder = 6
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbCont: TCheckBoxV
    Left = 11
    Top = 179
    Width = 138
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Continuous file'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
end
