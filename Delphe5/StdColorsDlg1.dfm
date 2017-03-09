object StdColorsDlg: TStdColorsDlg
  Left = 547
  Top = 332
  BorderStyle = bsDialog
  Caption = 'Standard Colors'
  ClientHeight = 219
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline ColFrame1: TColFrame
    Left = 85
    Top = 137
    Width = 127
    Height = 20
    TabOrder = 0
    inherited Button: TButton
      Height = 20
      Caption = 'Color 0'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame2: TColFrame
    Left = 14
    Top = 17
    Width = 127
    Height = 20
    TabOrder = 1
    inherited Button: TButton
      Height = 20
      Caption = 'Color 1'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame3: TColFrame
    Left = 13
    Top = 40
    Width = 127
    Height = 20
    TabOrder = 2
    inherited Button: TButton
      Height = 20
      Caption = 'Color 2'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame4: TColFrame
    Left = 13
    Top = 63
    Width = 127
    Height = 20
    TabOrder = 3
    inherited Button: TButton
      Height = 20
      Caption = 'Color 3'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame5: TColFrame
    Left = 13
    Top = 86
    Width = 127
    Height = 20
    TabOrder = 4
    inherited Button: TButton
      Height = 20
      Caption = 'Color4'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame6: TColFrame
    Left = 13
    Top = 109
    Width = 127
    Height = 20
    TabOrder = 5
    inherited Button: TButton
      Height = 20
      Caption = 'Color 5'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame7: TColFrame
    Left = 156
    Top = 17
    Width = 127
    Height = 20
    TabOrder = 6
    inherited Button: TButton
      Height = 20
      Caption = 'Color 6'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame8: TColFrame
    Left = 156
    Top = 40
    Width = 127
    Height = 20
    TabOrder = 7
    inherited Button: TButton
      Height = 20
      Caption = 'Color 7'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame9: TColFrame
    Left = 156
    Top = 63
    Width = 127
    Height = 20
    TabOrder = 8
    inherited Button: TButton
      Height = 20
      Caption = 'Color 8'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame10: TColFrame
    Left = 156
    Top = 86
    Width = 127
    Height = 20
    TabOrder = 9
    inherited Button: TButton
      Height = 20
      Caption = 'Color 9'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  inline ColFrame11: TColFrame
    Left = 156
    Top = 109
    Width = 127
    Height = 20
    TabOrder = 10
    inherited Button: TButton
      Height = 20
      Caption = 'Color 10'
    end
    inherited Panel: TPanel
      Height = 20
    end
  end
  object Button1: TButton
    Left = 64
    Top = 176
    Width = 75
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 11
  end
  object Button2: TButton
    Left = 152
    Top = 176
    Width = 75
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 12
  end
end
