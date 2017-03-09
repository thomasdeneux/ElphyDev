object Form1: TForm1
  Left = 272
  Top = 118
  Width = 684
  Height = 381
  Caption = 'Sample For Delphi 2.0'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 10
    Top = 6
    Width = 437
    Height = 263
    AutoSize = True
  end
  object Label1: TLabel
    Left = 96
    Top = 328
    Width = 3
    Height = 13
  end
  object Button1: TButton
    Left = 16
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Load JPEG'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Load GIF'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Save_JPG'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 176
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Load BMP'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 256
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Load TGA'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 336
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Load PCX'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 416
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Get Error'
    TabOrder = 6
    OnClick = Button7Click
  end
  object RadioButton1: TRadioButton
    Left = 472
    Top = 16
    Width = 113
    Height = 17
    Caption = 'English'
    Checked = True
    TabOrder = 7
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 472
    Top = 40
    Width = 113
    Height = 17
    Caption = 'German'
    TabOrder = 8
    OnClick = RadioButton2Click
  end
  object RadioButton3: TRadioButton
    Left = 472
    Top = 64
    Width = 113
    Height = 17
    Caption = 'Dutch'
    TabOrder = 9
    OnClick = RadioButton3Click
  end
  object RadioButton4: TRadioButton
    Left = 472
    Top = 88
    Width = 113
    Height = 17
    Caption = 'Portuguese'
    TabOrder = 10
    OnClick = RadioButton4Click
  end
  object RadioButton5: TRadioButton
    Left = 472
    Top = 112
    Width = 113
    Height = 17
    Caption = 'Spanish'
    TabOrder = 11
    OnClick = RadioButton5Click
  end
  object RadioButton6: TRadioButton
    Left = 472
    Top = 136
    Width = 201
    Height = 17
    Caption = 'Japanese (Need Japanese Windows)'
    TabOrder = 12
    OnClick = RadioButton6Click
  end
  object RadioButton7: TRadioButton
    Left = 472
    Top = 208
    Width = 113
    Height = 17
    Caption = 'Custom'
    TabOrder = 13
    OnClick = RadioButton7Click
  end
  object RadioButton8: TRadioButton
    Left = 472
    Top = 160
    Width = 113
    Height = 17
    Caption = 'Italian'
    TabOrder = 14
    OnClick = RadioButton8Click
  end
  object RadioButton9: TRadioButton
    Left = 472
    Top = 184
    Width = 113
    Height = 17
    Caption = 'French'
    TabOrder = 15
    OnClick = RadioButton9Click
  end
end
