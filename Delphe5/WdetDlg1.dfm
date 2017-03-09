object WindetectDlg: TWindetectDlg
  Left = 350
  Top = 206
  BorderStyle = bsDialog
  Caption = 'WindetectDlg'
  ClientHeight = 131
  ClientWidth = 243
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
  inline edsX: TEditScroll
    Left = 8
    Top = 8
    Width = 248
    Height = 30
    TabOrder = 0
    inherited Lb: TLabel
      Width = 7
      Caption = 'X'
    end
  end
  inline edsY: TEditScroll
    Left = 8
    Top = 30
    Width = 248
    Height = 30
    TabOrder = 1
    inherited Lb: TLabel
      Width = 7
      Caption = 'Y'
    end
  end
  inline edsH: TEditScroll
    Left = 8
    Top = 51
    Width = 248
    Height = 30
    TabOrder = 2
    inherited Lb: TLabel
      Width = 8
      Caption = 'H'
    end
  end
  inline cpColor: TcolorPan
    Left = 10
    Top = 79
    Width = 144
    Height = 22
    TabOrder = 3
    inherited ColorDialog1: TColorDialog
      Left = 128
      Top = 65532
    end
  end
  object cbActive: TCheckBoxV
    Left = 168
    Top = 82
    Width = 66
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Active'
    TabOrder = 4
    OnClick = cbActiveClick
    UpdateVarOnToggle = False
  end
  object BOK: TButton
    Left = 90
    Top = 107
    Width = 63
    Height = 20
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 5
  end
end
