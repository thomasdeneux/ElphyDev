object HelpSearch: THelpSearch
  Left = 381
  Top = 252
  BorderStyle = bsDialog
  Caption = 'Elphy Help Topics'
  ClientHeight = 370
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Words'
  end
  object Label2: TLabel
    Left = 8
    Top = 184
    Width = 32
    Height = 13
    Caption = 'Topics'
  end
  object lbWords: TlistBoxV
    Left = 8
    Top = 48
    Width = 305
    Height = 121
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnClick = lbWordsClick
    UpdateVarOnExit = False
  end
  object lbTopics: TlistBoxV
    Left = 8
    Top = 200
    Width = 305
    Height = 97
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnDblClick = lbTopicsDblClick
    UpdateVarOnExit = False
  end
  object Bclear: TButton
    Left = 328
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = BclearClick
  end
  object Boptions: TButton
    Left = 328
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Options'
    TabOrder = 3
  end
  object BOK: TButton
    Left = 117
    Top = 328
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Bcancel: TButton
    Left = 221
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object esWords: TEdit
    Left = 8
    Top = 24
    Width = 305
    Height = 21
    TabOrder = 6
    OnChange = esWordsChange
  end
end
