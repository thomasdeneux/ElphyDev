object BitmapCompForm: TBitmapCompForm
  Left = 253
  Top = 243
  Width = 737
  Height = 434
  Caption = '256 colour bitmap RLE8 compression'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 393
    Caption = 'Input bitmap'
    TabOrder = 0
    object InFilesizeLabel: TLabel
      Left = 16
      Top = 104
      Width = 40
      Height = 13
      Caption = 'File size:'
    end
    object InBrowseBtn: TBitBtn
      Left = 264
      Top = 22
      Width = 75
      Height = 25
      Caption = 'Browse'
      TabOrder = 0
      OnClick = InBrowseBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
    end
    object InFilenameEdit: TEdit
      Left = 16
      Top = 24
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      OnChange = OutFilenameEditChange
    end
    object InScrollBox: TScrollBox
      Left = 16
      Top = 144
      Width = 329
      Height = 233
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      TabOrder = 2
      object InImage: TImage
        Left = 0
        Top = 0
        Width = 325
        Height = 229
        Align = alClient
        AutoSize = True
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 368
    Top = 8
    Width = 353
    Height = 393
    Caption = 'Compressed bitmap'
    TabOrder = 1
    object OutFilesizeLabel: TLabel
      Left = 16
      Top = 104
      Width = 40
      Height = 13
      Caption = 'File size:'
    end
    object CompUsingLabel: TLabel
      Left = 16
      Top = 120
      Width = 92
      Height = 13
      Caption = 'Compressed using: '
    end
    object QualityLabel: TLabel
      Left = 16
      Top = 72
      Width = 12
      Height = 13
      Caption = '85'
    end
    object Label1: TLabel
      Left = 16
      Top = 56
      Width = 32
      Height = 13
      Caption = 'Quality'
    end
    object OutFilenameEdit: TEdit
      Left = 16
      Top = 24
      Width = 233
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      OnChange = OutFilenameEditChange
    end
    object OutBrowseBtn: TBitBtn
      Left = 264
      Top = 22
      Width = 75
      Height = 25
      Caption = 'Browse'
      TabOrder = 1
      OnClick = OutBrowseBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
    end
    object OutScrollBox: TScrollBox
      Left = 16
      Top = 144
      Width = 329
      Height = 233
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      TabOrder = 2
      object OutImage: TImage
        Left = 0
        Top = 0
        Width = 325
        Height = 229
        Align = alClient
        AutoSize = True
      end
    end
    object CompressBtn: TBitBtn
      Left = 264
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Compress'
      Enabled = False
      TabOrder = 3
      OnClick = CompressBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333388888888888888883000000000000003F33333333333333830CCCCC0BBBB
        BB03F38FFFF38FFFFF3830CCCCC0BBBBB033F38333F38333F383330CCC0BBBBB
        B0333F383F383333F3833330C0BBBBBB033333F38383333F383333330BBBBBBB
        0333333F3833333F3833333330BBBBB033333333F38333F38333333330BBBBB0
        33333333F38333F383333333330BBB03333333333F383F3833333333330BBB03
        333333333F383F38333333333330B0333333333333F38383333333333330B033
        3333333333F38383333333333333033333333333333F38333333333333330333
        33333333333F38333333333333333333333333333333F3333333}
      NumGlyphs = 2
    end
    object PaletteCheckBox: TCheckBox
      Left = 208
      Top = 60
      Width = 105
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Compress Palette'
      State = cbChecked
      TabOrder = 4
    end
    object QualityTrackBar: TTrackBar
      Left = 51
      Top = 56
      Width = 150
      Height = 33
      Max = 100
      Orientation = trHorizontal
      Frequency = 10
      Position = 85
      SelEnd = 86
      SelStart = 84
      TabOrder = 5
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = QualityTrackBarChange
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Title = 'Select bitmap to compress'
    Left = 168
    Top = 192
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'BMP'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Title = 'Set compressed filename'
    Left = 528
    Top = 184
  end
end
