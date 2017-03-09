object VlistCommand: TVlistCommand
  Left = 838
  Top = 406
  BorderStyle = bsToolWindow
  Caption = 'VlistCommand'
  ClientHeight = 74
  ClientWidth = 140
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 140
    Height = 51
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 6
      Width = 77
      Height = 13
      Caption = 'Current episode:'
    end
    object PanelSeq: TPanel
      Left = 83
      Top = 5
      Width = 51
      Height = 16
      BevelOuter = bvLowered
      Caption = '0'
      TabOrder = 0
    end
    object sbCurrent: TscrollbarV
      Left = 7
      Top = 28
      Width = 127
      Height = 16
      Max = 30000
      PageSize = 0
      TabOrder = 1
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = sbCurrentScrollV
    end
  end
  object Ptexte: TPanel
    Left = 0
    Top = 51
    Width = 140
    Height = 23
    Align = alClient
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 65525
    Top = 57
    object File1: TMenuItem
      Caption = 'File'
      object Saveselection1: TMenuItem
        Caption = 'Save selection'
        object Newfile1: TMenuItem
          Caption = 'New file'
          OnClick = Newfile1Click
        end
        object Apend1: TMenuItem
          Caption = 'Append'
          OnClick = Append1Click
        end
      end
      object Copyselection1: TMenuItem
        Caption = 'Copy selection'
        OnClick = Copyselection1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Selectall1: TMenuItem
        Caption = 'Select all'
        OnClick = Selectall1Click
      end
      object Unselectall1: TMenuItem
        Caption = 'Unselect all'
        OnClick = Unselectall1Click
      end
    end
  end
end
