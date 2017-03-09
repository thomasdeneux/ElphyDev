object moyEc: TmoyEc
  Left = 290
  Top = 259
  Width = 331
  Height = 202
  Caption = 'Standard deviation'
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
    Left = 13
    Top = 16
    Width = 94
    Height = 13
    Caption = 'Processed channel:'
  end
  object Label2: TLabel
    Left = 13
    Top = 38
    Width = 156
    Height = 13
    Caption = 'Store average+StdDev in vector:'
  end
  object Label3: TLabel
    Left = 13
    Top = 60
    Width = 153
    Height = 13
    Caption = 'Store average-StdDev in vector:'
  end
  object Label4: TLabel
    Left = 14
    Top = 82
    Width = 166
    Height = 13
    Caption = 'Store Standard Deviation in vector:'
  end
  object Label5: TLabel
    Left = 13
    Top = 104
    Width = 167
    Height = 13
    Caption = 'Store variation coefficient in vector:'
  end
  object comboBoxV1: TcomboBoxV
    Left = 218
    Top = 14
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV2: TcomboBoxV
    Left = 218
    Top = 36
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV3: TcomboBoxV
    Left = 218
    Top = 58
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV4: TcomboBoxV
    Left = 218
    Top = 80
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object comboBoxV5: TcomboBoxV
    Left = 218
    Top = 102
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object Button1: TButton
    Left = 61
    Top = 134
    Width = 89
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 169
    Top = 134
    Width = 89
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
end
