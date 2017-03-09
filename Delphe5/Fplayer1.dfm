object FilePlayer: TFilePlayer
  Left = 438
  Top = 217
  BorderStyle = bsDialog
  Caption = 'File player'
  ClientHeight = 170
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 146
    Width = 277
    Height = 24
    Align = alBottom
    TabOrder = 0
    object SBplay: TSpeedButton
      Left = 2
      Top = 2
      Width = 31
      Height = 20
      GroupIndex = 10
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333033333
        3333333333003333333333333300033333333333330000333333333333000003
        3333333333000033333333333300033333333333330033333333333333033333
        3333333333333333333333333333333333333333333333333333}
      OnClick = SBplayClick
    end
    object SBstop: TSpeedButton
      Left = 36
      Top = 2
      Width = 31
      Height = 20
      GroupIndex = 10
      Down = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333330000003
        3333333330000003333333333000000333333333300000033333333330000003
        3333333330000003333333333000000333333333300000033333333330000003
        3333333333333333333333333333333333333333333333333333}
      OnClick = SBstopClick
    end
    object SBmute: TSpeedButton
      Left = 138
      Top = 2
      Width = 31
      Height = 20
      AllowAllUp = True
      GroupIndex = 4
      Glyph.Data = {
        76020000424D7602000000000000760000002800000040000000100000000100
        0400000000000002000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333933333333339333333333333303
        3333333333333383333333333333338333333393333333493333333333333003
        3333333333333883333333333333388333333339333334933333333333330003
        3333333333338883333333333333888333333333933349433333333300300003
        3333333388388883333333338838888333333333493494433333333300000003
        3333333388888883333333338888888333333333449944433333333300000003
        3333333388888883333333338888888333333333449944433333333300000003
        3333333388888883333333338888888333333333494494433333333300300003
        3333333388388883333333338838888333333333903449433333333333330003
        3333333333338883333333333333888333333339333344933333333333333003
        3333333333333883333333333333388333333393333334493333333333333303
        3333333333333383333333333333338333333933333333439333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 4
    end
    object TBvolume: TTrackBar
      Left = 173
      Top = 2
      Width = 98
      Height = 18
      Max = 65535
      TabOrder = 0
      ThumbLength = 12
      OnChange = TBvolumeChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 122
    Width = 277
    Height = 24
    Align = alBottom
    TabOrder = 1
    object Pposition: TPanel
      Left = 51
      Top = 1
      Width = 85
      Height = 22
      Align = alLeft
      BevelOuter = bvLowered
      TabOrder = 0
      object enPosition: TeditNum
        Left = 0
        Top = 1
        Width = 85
        Height = 21
        TabOrder = 0
        Text = '21.000'
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 50
      Height = 22
      Align = alLeft
      Caption = 'Position'
      TabOrder = 1
    end
    object SBposition: TscrollbarV
      Left = 142
      Top = 6
      Width = 133
      Height = 13
      Max = 30000
      PageSize = 0
      TabOrder = 2
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = SBpositionScrollV
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 98
    Width = 277
    Height = 24
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 136
      Height = 24
      Align = alLeft
      TabOrder = 0
      object Panel8: TPanel
        Left = 1
        Top = 1
        Width = 58
        Height = 22
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Gain'
        TabOrder = 0
      end
      object Pgain: TPanel
        Left = 59
        Top = 1
        Width = 64
        Height = 22
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '0'
        TabOrder = 1
      end
      object UDgain: TUpDown
        Left = 123
        Top = 1
        Width = 12
        Height = 22
        Associate = Pgain
        Min = -100
        TabOrder = 2
        OnClick = UDgainClick
      end
    end
    object Panel10: TPanel
      Left = 136
      Top = 0
      Width = 141
      Height = 24
      Align = alClient
      TabOrder = 1
      object Panel11: TPanel
        Left = 1
        Top = 1
        Width = 57
        Height = 22
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Offset'
        TabOrder = 0
      end
      object Poffset: TPanel
        Left = 58
        Top = 1
        Width = 69
        Height = 22
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '0'
        TabOrder = 1
      end
      object UDoffset: TUpDown
        Left = 127
        Top = 1
        Width = 12
        Height = 22
        Associate = Poffset
        Min = -100
        TabOrder = 2
      end
    end
  end
end
