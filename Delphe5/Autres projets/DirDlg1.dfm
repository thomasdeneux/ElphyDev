object Form2: TForm2
  Left = 577
  Top = 311
  BorderStyle = bsDialog
  Caption = 'Choose a directory'
  ClientHeight = 321
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 82
    Top = 279
    Width = 64
    Height = 22
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 186
    Top = 279
    Width = 64
    Height = 22
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 48
    Width = 337
    Height = 217
    ItemHeight = 16
    TabOrder = 2
  end
end
