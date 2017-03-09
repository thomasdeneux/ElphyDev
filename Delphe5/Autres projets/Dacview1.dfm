object DACview: TDACview
  Left = 255
  Top = 202
  Width = 435
  Height = 300
  Caption = 'DAC2 viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 48
    Width = 427
    Height = 206
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 24
    Align = alTop
    TabOrder = 1
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 62
      Height = 22
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Episode'
      TabOrder = 0
    end
    object Pepisode: TPanel
      Left = 63
      Top = 1
      Width = 47
      Height = 22
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '12'
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 110
      Top = 1
      Width = 73
      Height = 22
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      object BEpPrevious: TBitBtn
        Left = 3
        Top = 1
        Width = 33
        Height = 20
        TabOrder = 0
        OnClick = BEpPreviousClick
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
      object BEpNext: TBitBtn
        Left = 37
        Top = 1
        Width = 33
        Height = 20
        TabOrder = 1
        OnClick = BEpNextClick
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
    end
    object Panel4: TPanel
      Left = 183
      Top = 1
      Width = 56
      Height = 22
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Object'
      TabOrder = 3
    end
    object Pobject: TPanel
      Left = 239
      Top = 1
      Width = 49
      Height = 22
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '1'
      TabOrder = 4
    end
    object BobjPrevious: TBitBtn
      Left = 292
      Top = 2
      Width = 33
      Height = 20
      TabOrder = 5
      OnClick = BobjPreviousClick
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
    object BobjNext: TBitBtn
      Left = 326
      Top = 2
      Width = 33
      Height = 20
      TabOrder = 6
      OnClick = BobjNextClick
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
  end
  object Panel5: TPanel
    Left = 0
    Top = 24
    Width = 427
    Height = 24
    Align = alTop
    TabOrder = 2
    object Panel6: TPanel
      Left = 150
      Top = 1
      Width = 62
      Height = 22
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Name'
      TabOrder = 0
    end
    object Pname: TPanel
      Left = 212
      Top = 1
      Width = 214
      Height = 22
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
    end
    object Panel8: TPanel
      Left = 1
      Top = 1
      Width = 45
      Height = 22
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Class'
      TabOrder = 2
    end
    object Pclass: TPanel
      Left = 46
      Top = 1
      Width = 104
      Height = 22
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 3
    end
  end
  object MainMenu1: TMainMenu
    Left = 7
    Top = 248
    object File1: TMenuItem
      Caption = 'File'
      OnClick = File1Click
    end
    object Options1: TMenuItem
      Caption = 'Options'
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'STIM2 files (sm2)|*.sm2|Object  files (oac)|*.oac|Configuration ' +
      'files (gfc)|*.gfc'
    Left = 120
    Top = 237
  end
end
