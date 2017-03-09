object getZorder: TgetZorder
  Left = 503
  Top = 157
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Z-order'
  ClientHeight = 284
  ClientWidth = 180
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 11
    Top = 10
    Width = 160
    Height = 169
    Caption = 'Display order for visual objects'
    TabOrder = 0
    object LBstim: TListBox
      Left = 7
      Top = 21
      Width = 143
      Height = 134
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
      MultiSelect = True
      ParentFont = False
      Style = lbOwnerDrawFixed
      TabOrder = 0
      OnDrawItem = LBstimDrawItem
      OnMouseUp = LBstimMouseUp
    end
  end
  object BOK: TButton
    Left = 57
    Top = 243
    Width = 57
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object ActiveAll: TButton
    Left = 14
    Top = 185
    Width = 159
    Height = 20
    Caption = 'Send selection to back'
    TabOrder = 2
    OnClick = SendBack
  end
  object unActiveAll: TButton
    Left = 14
    Top = 211
    Width = 159
    Height = 20
    Caption = 'Bring selection to front'
    TabOrder = 3
    OnClick = BringFront
  end
end
