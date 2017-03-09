object AcqOpt1: TAcqOpt1
  Left = 256
  Top = 127
  Width = 322
  Height = 279
  Caption = 'Acquisition  options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 143
    Width = 94
    Height = 13
    Caption = 'First track point:'
  end
  object Label2: TLabel
    Left = 9
    Top = 166
    Width = 91
    Height = 13
    Caption = '2nd track point:'
  end
  object BOK: TButton
    Left = 28
    Top = 208
    Width = 89
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 158
    Top = 208
    Width = 89
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Tag = 10
    Left = 4
    Top = 10
    Width = 301
    Height = 97
    Caption = 'Tracked channels'
    TabOrder = 2
    object ac4: TCheckBox
      Tag = 4
      Left = 20
      Top = 72
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '4'
      TabOrder = 0
    end
    object ac2: TCheckBox
      Tag = 2
      Left = 20
      Top = 40
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '2'
      TabOrder = 1
    end
    object ac3: TCheckBox
      Tag = 3
      Left = 20
      Top = 56
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '3'
      TabOrder = 2
    end
    object ac1: TCheckBox
      Tag = 1
      Left = 20
      Top = 24
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '1'
      TabOrder = 3
    end
    object ac5: TCheckBox
      Tag = 5
      Left = 95
      Top = 24
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '5'
      TabOrder = 4
    end
    object ac6: TCheckBox
      Tag = 6
      Left = 95
      Top = 40
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '6'
      TabOrder = 5
    end
    object ac7: TCheckBox
      Tag = 7
      Left = 95
      Top = 56
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '7'
      TabOrder = 6
    end
    object ac8: TCheckBox
      Tag = 8
      Left = 95
      Top = 72
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '8'
      TabOrder = 7
    end
    object ac9: TCheckBox
      Tag = 9
      Left = 170
      Top = 24
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '9'
      TabOrder = 8
    end
    object ac10: TCheckBox
      Tag = 10
      Left = 170
      Top = 40
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '10'
      TabOrder = 9
    end
    object ac11: TCheckBox
      Tag = 11
      Left = 170
      Top = 56
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '11'
      TabOrder = 10
    end
    object ac12: TCheckBox
      Tag = 12
      Left = 170
      Top = 72
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '12'
      TabOrder = 11
    end
    object ac13: TCheckBox
      Tag = 13
      Left = 240
      Top = 24
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '13'
      TabOrder = 12
    end
    object ac14: TCheckBox
      Tag = 14
      Left = 240
      Top = 40
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '14'
      TabOrder = 13
    end
    object ac15: TCheckBox
      Tag = 15
      Left = 240
      Top = 56
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '15'
      TabOrder = 14
    end
    object ac16: TCheckBox
      Tag = 16
      Left = 240
      Top = 72
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = '16'
      TabOrder = 15
    end
  end
  object enPoint1: TeditNum
    Left = 110
    Top = 139
    Width = 45
    Height = 21
    TabOrder = 3
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enPoint2: TeditNum
    Left = 110
    Top = 162
    Width = 45
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
