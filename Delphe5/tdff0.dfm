object dataFileForm: TdataFileForm
  Left = 325
  Top = 218
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'dataFileForm'
  ClientHeight = 42
  ClientWidth = 192
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
  PixelsPerInch = 96
  TextHeight = 13
  object PanelName: TPanel
    Left = 0
    Top = 0
    Width = 192
    Height = 16
    Align = alTop
    Caption = 'Fichier.dat'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 16
    Width = 192
    Height = 26
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 6
      Width = 41
      Height = 13
      Caption = 'Episode:'
    end
    object Bnext: TBitBtn
      Left = 147
      Top = 3
      Width = 33
      Height = 20
      TabOrder = 0
      OnClick = BnextClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object Bprevious: TBitBtn
      Left = 107
      Top = 3
      Width = 33
      Height = 20
      TabOrder = 1
      OnClick = BpreviousClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object PanelSeq: TPanel
      Left = 47
      Top = 5
      Width = 51
      Height = 16
      BevelOuter = bvLowered
      Caption = '0'
      TabOrder = 2
    end
  end
  object MainMenu1: TMainMenu
    Left = 65531
    Top = 26
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object NextFile1: TMenuItem
        Caption = 'Next file'
        OnClick = NextFileClick
      end
      object Previousfile1: TMenuItem
        Caption = 'Previous file'
        OnClick = Previousfile1Click
      end
      object Informations1: TMenuItem
        Caption = 'Informations'
        OnClick = Informations1Click
      end
    end
    object Averaging1: TMenuItem
      Caption = 'Averaging'
      OnClick = Averaging1Click
    end
  end
end
