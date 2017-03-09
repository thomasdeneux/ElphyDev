object initTvectorArray: TinitTvectorArray
  Left = 539
  Top = 187
  BorderStyle = bsDialog
  Caption = 'New vector array'
  ClientHeight = 310
  ClientWidth = 187
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
  object Lname: TLabel
    Left = 67
    Top = 4
    Width = 32
    Height = 13
    Alignment = taCenter
    Caption = 'Lname'
  end
  object Bok: TButton
    Left = 12
    Top = 272
    Width = 69
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 101
    Top = 272
    Width = 69
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 1
    Top = 22
    Width = 181
    Height = 116
    Caption = 'Grid indices'
    TabOrder = 2
    object Label6: TLabel
      Left = 9
      Top = 19
      Width = 26
      Height = 13
      Caption = 'Istart:'
    end
    object Label7: TLabel
      Left = 9
      Top = 41
      Width = 24
      Height = 13
      Caption = 'Iend '
    end
    object Label8: TLabel
      Left = 9
      Top = 64
      Width = 28
      Height = 13
      Caption = 'Jstart:'
    end
    object Label9: TLabel
      Left = 9
      Top = 87
      Width = 26
      Height = 13
      Caption = 'Jend '
    end
    object en1: TeditNum
      Left = 92
      Top = 17
      Width = 73
      Height = 21
      TabOrder = 0
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object en2: TeditNum
      Left = 92
      Top = 39
      Width = 73
      Height = 21
      TabOrder = 1
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object en3: TeditNum
      Left = 92
      Top = 61
      Width = 73
      Height = 21
      TabOrder = 2
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object en4: TeditNum
      Left = 92
      Top = 83
      Width = 73
      Height = 21
      TabOrder = 3
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 150
    Width = 182
    Height = 105
    Caption = 'Vector parameters'
    TabOrder = 3
    object Label2: TLabel
      Left = 11
      Top = 26
      Width = 26
      Height = 13
      Caption = 'Istart:'
    end
    object Label3: TLabel
      Left = 11
      Top = 49
      Width = 24
      Height = 13
      Caption = 'Iend '
    end
    object Label1: TLabel
      Left = 10
      Top = 74
      Width = 60
      Height = 13
      Caption = 'Number type'
    end
    object en5: TeditNum
      Left = 94
      Top = 24
      Width = 73
      Height = 21
      TabOrder = 0
      Text = '5'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object en6: TeditNum
      Left = 94
      Top = 46
      Width = 73
      Height = 21
      TabOrder = 1
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object CB1: TcomboBoxV
      Left = 94
      Top = 71
      Width = 74
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'comboBoxV1'
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
  end
end
