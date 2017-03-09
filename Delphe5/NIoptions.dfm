object NIOpt: TNIOpt
  Left = 700
  Top = 385
  BorderStyle = bsDialog
  Caption = 'NI options'
  ClientHeight = 287
  ClientWidth = 284
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
  object BOK: TButton
    Left = 75
    Top = 242
    Width = 53
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 151
    Top = 242
    Width = 53
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 15
    Top = 112
    Width = 242
    Height = 89
    Caption = 'Digital IO'
    TabOrder = 2
    object Label3: TLabel
      Left = 21
      Top = 67
      Width = 213
      Height = 13
      Caption = '0     1     2     3     4     5     6     7    '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 166
      Height = 13
      Caption = 'Check the channels used as inputs'
    end
    object cb7: TCheckBox
      Left = 203
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 0
    end
    object cb6: TCheckBox
      Left = 175
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 1
    end
    object cb4: TCheckBox
      Left = 121
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 2
    end
    object cb5: TCheckBox
      Left = 148
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 3
    end
    object cb3: TCheckBox
      Left = 94
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 4
    end
    object cb2: TCheckBox
      Left = 67
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 5
    end
    object cb0: TCheckBox
      Left = 13
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 6
    end
    object cb1: TCheckBox
      Left = 40
      Top = 47
      Width = 17
      Height = 17
      Alignment = taLeftJustify
      TabOrder = 7
    end
  end
  object cbUseTags: TCheckBox
    Left = 28
    Top = 211
    Width = 200
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Acquire digital inputs (Vtags)'
    TabOrder = 3
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 8
    Width = 241
    Height = 84
    Caption = 'Analog Inputs'
    TabOrder = 4
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 135
      Height = 13
      Caption = 'Input Terminal Configuration:'
    end
    object cbTerminalConfig: TcomboBoxV
      Left = 16
      Top = 40
      Width = 217
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Referenced Single Ended'
        'NonReferenced Single Ended'
        'Differential'
        'PseudoDifferential')
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = False
    end
  end
end
