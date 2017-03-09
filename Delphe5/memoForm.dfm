object ViewText: TViewText
  Left = 569
  Top = 213
  Width = 575
  Height = 430
  BorderIcons = [biSystemMenu]
  Caption = 'ViewText'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 559
    Height = 330
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 330
    Width = 559
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Bok: TButton
      Left = 187
      Top = 12
      Width = 75
      Height = 20
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object Bcancel: TButton
      Left = 275
      Top = 12
      Width = 75
      Height = 20
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 344
    object File1: TMenuItem
      Caption = 'File'
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Print1: TMenuItem
        Caption = 'Print'
        OnClick = Print1Click
      end
    end
  end
end
