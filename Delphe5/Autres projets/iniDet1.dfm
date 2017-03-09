object DetectPanel: TDetectPanel
  Left = 318
  Top = 171
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'DetectPanel'
  ClientHeight = 237
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 10
    Width = 37
    Height = 13
    Caption = 'Source '
  end
  object Label4: TLabel
    Left = 16
    Top = 109
    Width = 31
    Height = 13
    Caption = 'Height'
  end
  object Label5: TLabel
    Left = 16
    Top = 132
    Width = 33
    Height = 13
    Caption = 'Length'
  end
  object Label2: TLabel
    Left = 16
    Top = 87
    Width = 27
    Height = 13
    Caption = 'Mode'
  end
  object Label6: TLabel
    Left = 16
    Top = 34
    Width = 27
    Height = 13
    Caption = 'Xstart'
  end
  object Label7: TLabel
    Left = 16
    Top = 56
    Width = 25
    Height = 13
    Caption = 'Xend'
  end
  object Label3: TLabel
    Left = 16
    Top = 154
    Width = 74
    Height = 13
    Caption = 'Inhibition length'
  end
  object CBsource: TComboBox
    Left = 56
    Top = 8
    Width = 179
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = CBsourceChange
    OnDropDown = CBsourceDropDown
  end
  object ENheight: TeditNum
    Left = 139
    Top = 105
    Width = 95
    Height = 21
    TabOrder = 1
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object ENlength: TeditNum
    Left = 139
    Top = 127
    Width = 95
    Height = 21
    TabOrder = 2
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbMode: TcomboBoxV
    Left = 91
    Top = 83
    Width = 144
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbModeChange
    Tnum = T_byte
    UpdateVarOnExit = True
  end
  object enXstart: TeditNum
    Left = 56
    Top = 30
    Width = 95
    Height = 21
    TabOrder = 4
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enXend: TeditNum
    Left = 56
    Top = 52
    Width = 95
    Height = 21
    TabOrder = 5
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bexecute: TButton
    Left = 15
    Top = 208
    Width = 75
    Height = 20
    Caption = 'Execute'
    TabOrder = 6
    OnClick = BexecuteClick
  end
  object Bautoscale: TButton
    Left = 165
    Top = 41
    Width = 69
    Height = 20
    Caption = 'Autoscale'
    TabOrder = 7
    OnClick = BautoscaleClick
  end
  object PnbDet: TPanel
    Left = 112
    Top = 208
    Width = 123
    Height = 20
    Caption = 'N=0'
    TabOrder = 8
  end
  object enInhib: TeditNum
    Left = 139
    Top = 149
    Width = 95
    Height = 21
    TabOrder = 9
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbStepOption: TCheckBoxV
    Left = 15
    Top = 173
    Width = 218
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Option 1'
    TabOrder = 10
    UpdateVarOnToggle = False
  end
end
