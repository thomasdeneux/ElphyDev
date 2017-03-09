object getActiveStim: TgetActiveStim
  Left = 323
  Top = 148
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'stm32'
  ClientHeight = 284
  ClientWidth = 180
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
  object GroupBox1: TGroupBox
    Left = 12
    Top = 11
    Width = 160
    Height = 169
    Caption = 'Active stimuli'
    TabOrder = 0
    object LBstim: TListBox
      Left = 8
      Top = 22
      Width = 143
      Height = 134
      Style = lbOwnerDrawFixed
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
      MultiSelect = True
      ParentFont = False
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
    Caption = 'Activate selection'
    TabOrder = 2
    OnClick = ActiveAllClick
  end
  object unActiveAll: TButton
    Left = 14
    Top = 210
    Width = 159
    Height = 20
    Caption = 'Unactivate selection'
    TabOrder = 3
    OnClick = unActiveAllClick
  end
end
