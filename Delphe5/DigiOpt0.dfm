object DigiOptions: TDigiOptions
  Left = 345
  Top = 211
  BorderStyle = bsDialog
  Caption = 'Digidata 1200 options'
  ClientHeight = 136
  ClientWidth = 205
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 31
    Top = 17
    Width = 75
    Height = 13
    Caption = 'Dma channel 1 '
  end
  object Label2: TLabel
    Left = 31
    Top = 40
    Width = 72
    Height = 13
    Caption = 'Dma channel 2'
  end
  object cbDma1: TcomboBoxV
    Left = 121
    Top = 14
    Width = 52
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbDma2: TcomboBoxV
    Left = 121
    Top = 37
    Width = 52
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object BOK: TButton
    Left = 34
    Top = 90
    Width = 56
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Bcancel: TButton
    Left = 112
    Top = 90
    Width = 56
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
