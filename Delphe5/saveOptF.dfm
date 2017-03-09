object SaveDFOptions: TSaveDFOptions
  Left = 373
  Top = 250
  BorderStyle = bsDialog
  Caption = 'Save options'
  ClientHeight = 246
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bok: TButton
    Left = 31
    Top = 209
    Width = 67
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 109
    Top = 209
    Width = 67
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 7
    Width = 187
    Height = 88
    Caption = 'File Information block '
    TabOrder = 2
    object Label3: TLabel
      Left = 10
      Top = 41
      Width = 46
      Height = 13
      Caption = 'New size:'
    end
    object Label4: TLabel
      Left = 10
      Top = 20
      Width = 51
      Height = 13
      Caption = 'Actual size'
    end
    object LfileInfo: TLabel
      Left = 97
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object enFileInfo: TeditNum
      Left = 99
      Top = 38
      Width = 75
      Height = 21
      TabOrder = 0
      Text = '0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbCopyFileInfo: TCheckBoxV
      Tag = 1
      Left = 9
      Top = 61
      Width = 166
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Copy file information'
      TabOrder = 1
      OnClick = cbCopyEpInfoClick
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 10
    Top = 106
    Width = 187
    Height = 88
    Caption = 'Episode Information block '
    TabOrder = 3
    object Label6: TLabel
      Left = 10
      Top = 41
      Width = 46
      Height = 13
      Caption = 'New size:'
    end
    object Label7: TLabel
      Left = 10
      Top = 20
      Width = 51
      Height = 13
      Caption = 'Actual size'
    end
    object LepInfo: TLabel
      Left = 99
      Top = 19
      Width = 6
      Height = 13
      Caption = '0'
    end
    object enEpInfo: TeditNum
      Left = 101
      Top = 39
      Width = 75
      Height = 21
      TabOrder = 0
      Text = '0'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbCopyEpInfo: TCheckBoxV
      Tag = 2
      Left = 8
      Top = 61
      Width = 166
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Copy episode information'
      TabOrder = 1
      OnClick = cbCopyEpInfoClick
      UpdateVarOnToggle = False
    end
  end
end
