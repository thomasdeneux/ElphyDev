object SysOpt: TSysOpt
  Left = 211
  Top = 195
  Width = 291
  Height = 193
  Caption = 'System options'
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
  object GroupBox1: TGroupBox
    Left = 20
    Top = 12
    Width = 241
    Height = 77
    Caption = 'Spreadsheet'
    TabOrder = 2
    object Label3: TLabel
      Left = 12
      Top = 20
      Width = 93
      Height = 13
      Caption = 'Number of rows:'
    end
    object Label4: TLabel
      Left = 12
      Top = 48
      Width = 113
      Height = 13
      Caption = 'Number of columns:'
    end
    object editNum1: TeditNum
      Left = 136
      Top = 18
      Width = 80
      Height = 21
      TabOrder = 0
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object editNum2: TeditNum
      Left = 136
      Top = 46
      Width = 80
      Height = 21
      TabOrder = 1
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object BOK: TButton
    Left = 36
    Top = 112
    Width = 89
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 150
    Top = 112
    Width = 89
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
end
