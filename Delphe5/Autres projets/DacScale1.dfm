object DacScale1Form: TDacScale1Form
  Left = 256
  Top = 191
  BorderStyle = bsDialog
  Caption = 'DacScale1Form'
  ClientHeight = 169
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 7
    Width = 302
    Height = 117
    Caption = 'Scaling parameters for Dac1'
    TabOrder = 0
    object Label32: TLabel
      Left = 11
      Top = 55
      Width = 8
      Height = 13
      Caption = 'j='
    end
    object Label33: TLabel
      Left = 101
      Top = 56
      Width = 85
      Height = 13
      Caption = 'Corresponds to y='
    end
    object Label34: TLabel
      Left = 11
      Top = 83
      Width = 8
      Height = 13
      Caption = 'j='
    end
    object Label35: TLabel
      Left = 100
      Top = 83
      Width = 85
      Height = 13
      Caption = 'Corresponds to y='
    end
    object Label36: TLabel
      Left = 11
      Top = 26
      Width = 27
      Height = 13
      Caption = 'Units:'
    end
    object enJ1: TeditNum
      Left = 34
      Top = 52
      Width = 58
      Height = 21
      TabOrder = 0
      UpdateVarOnExit = False
      Decimal = 3
      Dxu = 1.000000000000000000
    end
    object enY1: TeditNum
      Left = 194
      Top = 52
      Width = 93
      Height = 21
      TabOrder = 1
      UpdateVarOnExit = False
      Decimal = 3
      Dxu = 1.000000000000000000
    end
    object enJ2: TeditNum
      Left = 33
      Top = 79
      Width = 58
      Height = 21
      TabOrder = 2
      UpdateVarOnExit = False
      Decimal = 3
      Dxu = 1.000000000000000000
    end
    object enY2: TeditNum
      Left = 195
      Top = 79
      Width = 93
      Height = 21
      TabOrder = 3
      UpdateVarOnExit = False
      Decimal = 3
      Dxu = 1.000000000000000000
    end
    object esUnits: TeditString
      Left = 51
      Top = 23
      Width = 88
      Height = 21
      TabOrder = 4
      Text = 'mV'
      len = 0
      UpdateVarOnExit = False
    end
  end
  object BOK: TButton
    Left = 67
    Top = 137
    Width = 61
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 161
    Top = 137
    Width = 61
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
