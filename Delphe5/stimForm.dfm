inherited stimulusForm: TstimulusForm
  Left = 389
  Top = 198
  Height = 73
  Caption = 'stimulusForm'
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 7
    Top = 15
    Width = 63
    Height = 13
    Caption = 'Visual object:'
  end
  object CBvisual: TComboBox
    Left = 76
    Top = 9
    Width = 101
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = CBvisualChange
    OnDropDown = CBvisualDropDown
    Items.Strings = (
      'un'
      'deux'
      'trois')
  end
end
