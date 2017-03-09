object DefColorsDlg: TDefColorsDlg
  Left = 514
  Top = 293
  BorderStyle = bsDialog
  Caption = 'Default Colors'
  ClientHeight = 156
  ClientWidth = 225
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
  inline BKFrame: TColFrame
    Left = 14
    Top = 17
    Width = 211
    Height = 20
    TabOrder = 0
    inherited Button: TButton
      Width = 119
      Height = 20
      Caption = 'BackGround Color'
    end
    inherited Panel: TPanel
      Left = 135
      Height = 20
    end
  end
  inline ScaleFrame: TColFrame
    Left = 14
    Top = 42
    Width = 211
    Height = 20
    TabOrder = 1
    inherited Button: TButton
      Width = 119
      Height = 20
      Caption = 'Scale color'
    end
    inherited Panel: TPanel
      Left = 135
      Height = 20
    end
  end
  inline PenFrame: TColFrame
    Left = 14
    Top = 68
    Width = 211
    Height = 20
    TabOrder = 2
    inherited Button: TButton
      Width = 119
      Height = 20
      Caption = 'Pen color'
    end
    inherited Panel: TPanel
      Left = 135
      Height = 20
    end
  end
  object Button1: TButton
    Left = 30
    Top = 113
    Width = 75
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 118
    Top = 113
    Width = 75
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
