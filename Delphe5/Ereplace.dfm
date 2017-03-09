object GEditReplace: TGEditReplace
  Left = 470
  Top = 253
  ActiveControl = CBtext
  BorderStyle = bsDialog
  Caption = 'Find text'
  ClientHeight = 259
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 10
    Width = 56
    Height = 13
    Caption = '&Text to find:'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 45
    Height = 13
    Caption = '&New text:'
  end
  object CBtext: TComboBox
    Left = 82
    Top = 7
    Width = 183
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'CBtext'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 63
    Width = 154
    Height = 78
    Caption = 'Options'
    TabOrder = 1
    object CBcase: TCheckBoxV
      Left = 18
      Top = 17
      Width = 120
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Case sensitive'
      TabOrder = 0
      UpdateVarOnToggle = False
    end
    object CBwholeWord: TCheckBoxV
      Left = 18
      Top = 35
      Width = 120
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Whole words only'
      TabOrder = 1
      UpdateVarOnToggle = False
    end
    object CBprompt: TCheckBoxV
      Left = 18
      Top = 53
      Width = 120
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Prompt on replace'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 144
    Width = 155
    Height = 60
    Caption = 'Scope'
    TabOrder = 2
    object RBglobal: TRadioButton
      Left = 17
      Top = 16
      Width = 122
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Global'
      TabOrder = 0
    end
    object RBselected: TRadioButton
      Left = 17
      Top = 34
      Width = 123
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Selected text'
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 183
    Top = 63
    Width = 154
    Height = 78
    Caption = 'Direction'
    TabOrder = 3
    object RBforward: TRadioButton
      Left = 16
      Top = 17
      Width = 124
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Forward'
      TabOrder = 0
    end
    object RBbackward: TRadioButton
      Left = 17
      Top = 34
      Width = 123
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Backward'
      TabOrder = 1
    end
  end
  object GroupBox4: TGroupBox
    Left = 184
    Top = 145
    Width = 154
    Height = 60
    Caption = 'Origin'
    TabOrder = 4
    object RBfromCursor: TRadioButton
      Left = 16
      Top = 16
      Width = 124
      Height = 17
      Alignment = taLeftJustify
      Caption = 'F&rom cursor'
      TabOrder = 0
    end
    object RBentireScope: TRadioButton
      Left = 17
      Top = 34
      Width = 123
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Entire scope'
      TabOrder = 1
    end
  end
  object Bok: TButton
    Left = 48
    Top = 222
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Bcancel: TButton
    Left = 227
    Top = 222
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object CBnew: TComboBox
    Left = 82
    Top = 29
    Width = 183
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'CBtext'
  end
  object Ball: TButton
    Left = 137
    Top = 222
    Width = 75
    Height = 25
    Caption = 'Change &All'
    Default = True
    ModalResult = 100
    TabOrder = 8
  end
end
