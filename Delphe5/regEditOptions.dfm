object RegOptions: TRegOptions
  Left = 624
  Top = 319
  BorderStyle = bsDialog
  Caption = 'RegOptions'
  ClientHeight = 148
  ClientWidth = 215
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
  object cbBinXBinY: TCheckBoxV
    Left = 15
    Top = 57
    Width = 176
    Height = 17
    Alignment = taLeftJustify
    Caption = 'BinX is always equal to BinY '
    TabOrder = 0
    UpdateVarOnToggle = False
  end
  object Button5: TButton
    Left = 36
    Top = 99
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button6: TButton
    Left = 113
    Top = 99
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  inline ColFrame1: TColFrame
    Left = 16
    Top = 16
    Width = 177
    Height = 25
    TabOrder = 3
    inherited Button: TButton
      Width = 105
      Caption = 'BackGround Color'
    end
    inherited Panel: TPanel
      Left = 113
    end
  end
end
