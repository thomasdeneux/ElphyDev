object getLine: TgetLine
  Left = 308
  Top = 203
  BorderStyle = bsDialog
  Caption = 'LineHor'
  ClientHeight = 253
  ClientWidth = 184
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
  object labelX1: TLabel
    Left = 16
    Top = 17
    Width = 11
    Height = 13
    Caption = 'x1'
  end
  object Label2: TLabel
    Left = 16
    Top = 146
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object LabelB: TLabel
    Left = 16
    Top = 39
    Width = 11
    Height = 13
    Caption = 'y1'
  end
  object Label4: TLabel
    Left = 16
    Top = 168
    Width = 23
    Height = 13
    Caption = 'Style'
  end
  object Label1: TLabel
    Left = 16
    Top = 62
    Width = 11
    Height = 13
    Caption = 'x2'
  end
  object Label3: TLabel
    Left = 16
    Top = 84
    Width = 11
    Height = 13
    Caption = 'y2'
  end
  object enx1: TeditNum
    Left = 68
    Top = 13
    Width = 90
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bcolor: TButton
    Left = 16
    Top = 117
    Width = 56
    Height = 20
    Caption = 'Color'
    TabOrder = 1
    OnClick = BcolorClick
  end
  object Pcolor: TPanel
    Left = 100
    Top = 117
    Width = 58
    Height = 21
    TabOrder = 2
  end
  object enWidth: TeditNum
    Left = 97
    Top = 142
    Width = 62
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button5: TButton
    Left = 21
    Top = 218
    Width = 57
    Height = 20
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Button6: TButton
    Left = 91
    Top = 218
    Width = 57
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object eny1: TeditNum
    Left = 68
    Top = 35
    Width = 90
    Height = 21
    TabOrder = 6
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbStyle: TcomboBoxV
    Left = 56
    Top = 165
    Width = 104
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbVisible: TCheckBoxV
    Left = 15
    Top = 191
    Width = 144
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Visible'
    TabOrder = 8
    UpdateVarOnToggle = False
  end
  object enX2: TeditNum
    Left = 68
    Top = 58
    Width = 90
    Height = 21
    TabOrder = 9
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object eny2: TeditNum
    Left = 68
    Top = 80
    Width = 90
    Height = 21
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object ColorDialog1: TColorDialog
    Left = 40
    Top = 247
  end
end
