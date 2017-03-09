object OptionsMultg1: TOptionsMultg1
  Left = 610
  Top = 219
  BorderStyle = bsDialog
  Caption = 'esMgCaption'
  ClientHeight = 300
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object BOK: TButton
    Left = 116
    Top = 265
    Width = 58
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 186
    Top = 265
    Width = 58
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 8
    Width = 373
    Height = 153
    Caption = 'Current page options'
    TabOrder = 2
    object Label1: TLabel
      Left = 11
      Top = 33
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object ESname: TeditString
      Left = 45
      Top = 30
      Width = 104
      Height = 21
      TabOrder = 0
      Text = 'ESname'
      len = 0
      UpdateVarOnExit = False
    end
    object Btitlefont: TButton
      Left = 9
      Top = 85
      Width = 68
      Height = 20
      Caption = 'Titles font'
      TabOrder = 1
      OnClick = BtitlefontClick
    end
    object BBKcol: TButton
      Left = 9
      Top = 60
      Width = 97
      Height = 20
      Caption = 'Background color'
      TabOrder = 2
      OnClick = BBKcolClick
    end
    object PanelBKcol: TPanel
      Left = 113
      Top = 59
      Width = 42
      Height = 22
      TabOrder = 3
    end
    object cbScaleFont: TCheckBoxV
      Left = 112
      Top = 113
      Width = 34
      Height = 17
      TabOrder = 4
      OnClick = cbScaleFontClick
      UpdateVarOnToggle = False
    end
    object BscaleFont: TButton
      Left = 9
      Top = 112
      Width = 68
      Height = 20
      Caption = 'Scale font'
      TabOrder = 5
      OnClick = BscaleFontClick
    end
    object BscaleColor: TButton
      Left = 184
      Top = 109
      Width = 97
      Height = 20
      Caption = 'Scale color       '
      TabOrder = 6
      OnClick = BscaleColorClick
    end
    object PanelScaleColor: TPanel
      Left = 287
      Top = 108
      Width = 42
      Height = 22
      TabOrder = 7
    end
    object CBtitles: TCheckBoxV
      Left = 191
      Top = 32
      Width = 137
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Show Titles'
      TabOrder = 8
      UpdateVarOnToggle = False
    end
    object CBoutline: TCheckBoxV
      Left = 191
      Top = 51
      Width = 137
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Show Outlines'
      TabOrder = 9
      UpdateVarOnToggle = False
    end
    object CBnum: TCheckBoxV
      Left = 191
      Top = 71
      Width = 137
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Show Numbers'
      TabOrder = 10
      UpdateVarOnToggle = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 173
    Width = 373
    Height = 65
    Caption = 'Multigraph Options'
    TabOrder = 3
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 36
      Height = 13
      Caption = 'Caption'
    end
    object esMgCaption: TeditString
      Left = 62
      Top = 22
      Width = 299
      Height = 21
      TabOrder = 0
      Text = 'esMgCaption'
      len = 0
      UpdateVarOnExit = False
    end
  end
  object ColorDialog1: TColorDialog
    Left = 8
    Top = 253
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 43
    Top = 254
  end
end
