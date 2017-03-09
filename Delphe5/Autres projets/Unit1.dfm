object Form1: TForm1
  Left = 258
  Top = 189
  Width = 696
  Height = 480
  Caption = 'Mseq'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 688
    Height = 434
    Align = alClient
  end
  object MainMenu: TMainMenu
    object Fichier: TMenuItem
      Caption = '&Fichier'
      object Saisie: TMenuItem
        Caption = '&Saisie'
        OnClick = SaisieClick
      end
      object Quitter: TMenuItem
        Caption = '&Quitter'
        OnClick = QuitterClick
      end
    end
    object Affichage: TMenuItem
      Caption = 'Affichage'
      OnClick = AffichageClick
    end
  end
end
