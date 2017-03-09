object SysDialog: TSysDialog
  Left = 494
  Top = 178
  Width = 247
  Height = 231
  Caption = 'System parameters'
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 128
    Width = 81
    Height = 13
    Caption = 'Base address:'
  end
  object BOK: TButton
    Left = 34
    Top = 161
    Width = 69
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 130
    Top = 161
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 20
    Top = 12
    Width = 193
    Height = 105
    Caption = 'Data acquisition board'
    TabOrder = 2
    object RadioButtonV1: TRadioButtonV
      Left = 36
      Top = 24
      Width = 113
      Height = 17
      Alignment = taLeftJustify
      Caption = 'SOF 30188'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object RadioButtonV2: TRadioButtonV
      Left = 36
      Top = 48
      Width = 113
      Height = 17
      Alignment = taLeftJustify
      Caption = 'CIO PDMA'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object RadioButtonV3: TRadioButtonV
      Left = 36
      Top = 72
      Width = 113
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Simulation'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
  end
  object editString1: TeditString
    Left = 116
    Top = 126
    Width = 101
    Height = 21
    TabOrder = 3
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
end
