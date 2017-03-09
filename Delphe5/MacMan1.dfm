object MacroManagerDialog: TMacroManagerDialog
  Left = 501
  Top = 220
  BorderStyle = bsDialog
  Caption = 'Install Tools'
  ClientHeight = 373
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 9
    Top = 169
    Width = 20
    Height = 13
    Caption = 'Title'
  end
  object BOK: TButton
    Left = 117
    Top = 326
    Width = 61
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 200
    Top = 326
    Width = 61
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object enTitle: TeditString
    Left = 42
    Top = 166
    Width = 185
    Height = 21
    TabOrder = 2
    OnExit = enTitleExit
    len = 0
    UpdateVarOnExit = False
  end
  object lbMacro: TListBox
    Left = 8
    Top = 8
    Width = 313
    Height = 145
    ItemHeight = 13
    TabOrder = 3
    OnClick = lbMacroClick
  end
  object Badd: TButton
    Left = 330
    Top = 17
    Width = 50
    Height = 20
    Caption = 'Add'
    TabOrder = 4
    OnClick = BaddClick
  end
  object Bup: TBitBtn
    Left = 330
    Top = 75
    Width = 50
    Height = 20
    TabOrder = 5
    OnClick = BupClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
      3333333333777F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
      3333333777737777F333333099999990333333373F3333373333333309999903
      333333337F33337F33333333099999033333333373F333733333333330999033
      3333333337F337F3333333333099903333333333373F37333333333333090333
      33333333337F7F33333333333309033333333333337373333333333333303333
      333333333337F333333333333330333333333333333733333333}
    NumGlyphs = 2
  end
  object Bdown: TBitBtn
    Left = 330
    Top = 105
    Width = 50
    Height = 20
    TabOrder = 6
    OnClick = BdownClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
      333333333337F33333333333333033333333333333373F333333333333090333
      33333333337F7F33333333333309033333333333337373F33333333330999033
      3333333337F337F33333333330999033333333333733373F3333333309999903
      333333337F33337F33333333099999033333333373333373F333333099999990
      33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333300033333333333337773333333}
    NumGlyphs = 2
  end
  object Bdelete: TButton
    Left = 330
    Top = 45
    Width = 50
    Height = 20
    Caption = 'Delete'
    TabOrder = 7
    OnClick = BdeleteClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 200
    Width = 373
    Height = 105
    Caption = 'Search for Tool files'
    TabOrder = 8
    object Label1: TLabel
      Left = 16
      Top = 23
      Width = 29
      Height = 13
      Caption = 'Mask:'
    end
    object enMask: TeditString
      Left = 56
      Top = 20
      Width = 231
      Height = 21
      TabOrder = 0
      len = 0
      UpdateVarOnExit = False
    end
    object Bbrowse: TButton
      Left = 295
      Top = 21
      Width = 61
      Height = 20
      Caption = 'Browse'
      TabOrder = 1
      OnClick = BbrowseClick
    end
    object cbRemove: TCheckBoxV
      Left = 14
      Top = 47
      Width = 115
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Remove old tools'
      TabOrder = 2
      UpdateVarOnToggle = False
    end
    object Bgo: TButton
      Left = 16
      Top = 74
      Width = 61
      Height = 20
      Caption = 'GO'
      TabOrder = 3
      OnClick = BgoClick
    end
  end
end
