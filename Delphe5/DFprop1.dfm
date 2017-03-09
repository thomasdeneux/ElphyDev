object DataFileProp: TDataFileProp
  Left = 570
  Top = 244
  BorderStyle = bsDialog
  Caption = 'DataFile Properties'
  ClientHeight = 586
  ClientWidth = 287
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
  object Label2: TLabel
    Left = 10
    Top = 24
    Width = 140
    Height = 13
    Caption = 'Maximum number of channels'
  end
  object Label1: TLabel
    Left = 10
    Top = 48
    Width = 164
    Height = 13
    Caption = 'Maximum number of SPK channels'
  end
  object Label3: TLabel
    Left = 10
    Top = 72
    Width = 121
    Height = 13
    Caption = 'Maximum number of Units'
  end
  object Bok: TButton
    Left = 66
    Top = 536
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 146
    Top = 536
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cbChan: TcomboBoxV
    Left = 210
    Top = 21
    Width = 67
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = '64'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 276
    Width = 273
    Height = 245
    Caption = 'Data file types'
    TabOrder = 3
    object CheckBoxV1: TCheckBoxV
      Left = 24
      Top = 16
      Width = 177
      Height = 17
      Caption = 'CheckBoxV1'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object CheckBoxV2: TCheckBoxV
      Left = 24
      Top = 32
      Width = 177
      Height = 17
      Caption = 'CheckBoxV2'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object CheckBoxV3: TCheckBoxV
      Left = 24
      Top = 48
      Width = 177
      Height = 17
      Caption = 'CheckBoxV3'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object CheckBoxV4: TCheckBoxV
      Left = 24
      Top = 64
      Width = 177
      Height = 17
      Caption = 'CheckBoxV4'
      TabOrder = 3
      UpdateVarOnToggle = False
    end
    object CheckBoxV5: TCheckBoxV
      Left = 24
      Top = 80
      Width = 177
      Height = 17
      Caption = 'CheckBoxV5'
      TabOrder = 4
      UpdateVarOnToggle = False
    end
    object CheckBoxV6: TCheckBoxV
      Left = 24
      Top = 96
      Width = 177
      Height = 17
      Caption = 'CheckBoxV6'
      TabOrder = 5
      UpdateVarOnToggle = False
    end
    object CheckBoxV7: TCheckBoxV
      Left = 24
      Top = 112
      Width = 177
      Height = 17
      Caption = 'CheckBoxV1'
      TabOrder = 6
      UpdateVarOnToggle = False
    end
    object CheckBoxV8: TCheckBoxV
      Left = 24
      Top = 128
      Width = 177
      Height = 17
      Caption = 'CheckBoxV2'
      TabOrder = 7
      UpdateVarOnToggle = False
    end
    object CheckBoxV9: TCheckBoxV
      Left = 24
      Top = 144
      Width = 177
      Height = 17
      Caption = 'CheckBoxV3'
      TabOrder = 8
      UpdateVarOnToggle = False
    end
    object CheckBoxV10: TCheckBoxV
      Left = 24
      Top = 160
      Width = 177
      Height = 17
      Caption = 'CheckBoxV4'
      TabOrder = 9
      UpdateVarOnToggle = False
    end
    object CheckBoxV11: TCheckBoxV
      Left = 24
      Top = 176
      Width = 177
      Height = 17
      Caption = 'CheckBoxV5'
      TabOrder = 10
      UpdateVarOnToggle = False
    end
    object CheckBoxV12: TCheckBoxV
      Left = 24
      Top = 192
      Width = 177
      Height = 17
      Caption = 'CheckBoxV6'
      TabOrder = 11
      UpdateVarOnToggle = False
    end
    object CheckBoxV13: TCheckBoxV
      Left = 24
      Top = 208
      Width = 177
      Height = 17
      Caption = 'CheckBoxV6'
      TabOrder = 12
      UpdateVarOnToggle = False
    end
  end
  object cbSPK: TcomboBoxV
    Left = 210
    Top = 45
    Width = 67
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = '64'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbNbUnit: TcomboBoxV
    Left = 210
    Top = 69
    Width = 67
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = '64'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 94
    Width = 273
    Height = 74
    Caption = 'Spike Table'
    TabOrder = 6
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 67
      Height = 13
      Caption = 'Table Number'
    end
    object Label5: TLabel
      Left = 16
      Top = 43
      Width = 176
      Height = 13
      Caption = '( 0=original table, -1=last table added)'
    end
    object enSpkTable: TeditNum
      Left = 175
      Top = 20
      Width = 77
      Height = 21
      TabOrder = 0
      Text = '1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox3: TGroupBox
    Left = 9
    Top = 177
    Width = 273
    Height = 88
    Caption = 'Photon Imaging'
    TabOrder = 7
    object Label6: TLabel
      Left = 16
      Top = 44
      Width = 103
      Height = 13
      Caption = 'Filter Parameter Table'
    end
    object Label7: TLabel
      Left = 16
      Top = 63
      Width = 161
      Height = 13
      Caption = '( 0= not used, -1=last table added)'
    end
    object enPCLfilter: TeditNum
      Left = 175
      Top = 40
      Width = 77
      Height = 21
      TabOrder = 0
      Text = '1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbPhoton: TCheckBoxV
      Left = 16
      Top = 19
      Width = 142
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Active'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
  end
end
