object detectSave: TdetectSave
  Left = 485
  Top = 245
  BorderStyle = bsDialog
  Caption = 'detectSave'
  ClientHeight = 275
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 8
    Top = 126
    Width = 27
    Height = 13
    Caption = 'Xstart'
  end
  object Label7: TLabel
    Left = 8
    Top = 149
    Width = 25
    Height = 13
    Caption = 'Xend'
  end
  object Lxorg: TLabel
    Left = 9
    Top = 171
    Width = 22
    Height = 13
    Caption = 'Xorg'
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 170
    Height = 106
    Caption = 'Saved vectors'
    TabOrder = 0
    object LBvectors: TListBox
      Left = 5
      Top = 17
      Width = 160
      Height = 82
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      IntegralHeight = True
      ItemHeight = 13
      Items.Strings = (
        'un'
        'deux'
        'trois'
        'quatre'
        'cinq'
        'six'
        'sept'
        'huit'
        'neuf'
        'dix'
        'onze'
        'douze')
      ParentFont = False
      TabOrder = 0
    end
  end
  object enXstart: TeditNum
    Left = 48
    Top = 122
    Width = 113
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enXend: TeditNum
    Left = 48
    Top = 144
    Width = 113
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bdefault: TButton
    Left = 172
    Top = 131
    Width = 62
    Height = 20
    Caption = 'Autoscale'
    TabOrder = 3
    OnClick = BdefaultClick
  end
  object Bup: TBitBtn
    Left = 185
    Top = 14
    Width = 47
    Height = 22
    TabOrder = 4
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
  object Bdw: TBitBtn
    Left = 185
    Top = 41
    Width = 47
    Height = 22
    TabOrder = 5
    OnClick = BdwClick
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
  object Bsave: TButton
    Left = 29
    Top = 238
    Width = 76
    Height = 25
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 6
  end
  object Boptions: TButton
    Left = 124
    Top = 238
    Width = 76
    Height = 25
    Caption = 'Options'
    TabOrder = 7
    OnClick = BoptionsClick
  end
  object Badd: TButton
    Left = 186
    Top = 66
    Width = 47
    Height = 22
    Caption = 'Add'
    TabOrder = 8
    OnClick = BaddClick
  end
  object Bremove: TButton
    Left = 185
    Top = 92
    Width = 47
    Height = 22
    Caption = 'Remove'
    TabOrder = 9
    OnClick = BremoveClick
  end
  object enXorg: TeditNum
    Left = 48
    Top = 166
    Width = 113
    Height = 21
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbAppend: TCheckBoxV
    Left = 7
    Top = 194
    Width = 154
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Append'
    TabOrder = 11
    UpdateVarOnToggle = False
  end
  object cbContinu: TCheckBoxV
    Left = 7
    Top = 213
    Width = 154
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Continuous file'
    TabOrder = 12
    UpdateVarOnToggle = False
  end
end
