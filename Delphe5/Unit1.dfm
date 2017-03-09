object FormTest: TFormTest
  Left = 644
  Top = 198
  Width = 677
  Height = 475
  Caption = 'Salut '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 64
    Width = 393
    Height = 49
    Caption = 'Ceci est un essai de label'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBackground
    Font.Height = -27
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object BOK: TButton
    Left = 104
    Top = 336
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOKClick
  end
  object Bcancel: TButton
    Left = 208
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BcancelClick
  end
  object MainMenu1: TMainMenu
    Left = 616
    Top = 232
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load'
      end
      object Save1: TMenuItem
        Caption = 'Save'
      end
    end
    object Display1: TMenuItem
      Caption = 'Display'
    end
  end
end
