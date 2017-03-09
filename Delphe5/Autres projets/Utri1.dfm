object Form1: TForm1
  Left = 320
  Top = 152
  Width = 435
  Height = 289
  Caption = 'Tri SM2'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 17
    Width = 72
    Height = 13
    Caption = 'Destination file:'
  end
  object ESdest: TeditString
    Left = 93
    Top = 14
    Width = 327
    Height = 21
    TabOrder = 0
    Text = 'ESdest'
    len = 0
    UpdateVarOnExit = True
  end
  object ListBox1: TListBox
    Left = 91
    Top = 54
    Width = 327
    Height = 120
    Columns = 3
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 1
  end
  object Bsave: TButton
    Left = 22
    Top = 199
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = BsaveClick
  end
  object Bappend: TButton
    Left = 122
    Top = 199
    Width = 75
    Height = 25
    Caption = 'Append'
    TabOrder = 3
    OnClick = BappendClick
  end
  object MainMenu1: TMainMenu
    Left = 395
    Top = 191
    object File1: TMenuItem
      Caption = 'File'
      ShortCut = 0
      OnClick = File1Click
    end
    object Info1: TMenuItem
      Caption = 'Info'
      ShortCut = 0
    end
  end
end
