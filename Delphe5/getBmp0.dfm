object initImagePlot: TinitImagePlot
  Left = 261
  Top = 138
  BorderStyle = bsDialog
  Caption = 'initImagePlot'
  ClientHeight = 143
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 13
    Top = 8
    Width = 253
    Height = 38
    Caption = 'File name'
    TabOrder = 0
    object Lfile: TLabel
      Left = 12
      Top = 15
      Width = 55
      Height = 13
      Caption = 'Bitmap.bmp'
    end
  end
  object Button1: TButton
    Left = 74
    Top = 101
    Width = 65
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 166
    Top = 101
    Width = 65
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 271
    Top = 21
    Width = 29
    Height = 25
    TabOrder = 3
    OnClick = BloadClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333033333
      33333333373F33333333333330B03333333333337F7F33333333333330F03333
      333333337F7FF3333333333330B00333333333337F773FF33333333330F0F003
      333333337F7F773F3333333330B0B0B0333333337F7F7F7F3333333300F0F0F0
      333333377F73737F33333330B0BFBFB03333337F7F33337F33333330F0FBFBF0
      3333337F7333337F33333330BFBFBFB033333373F3333373333333330BFBFB03
      33333337FFFFF7FF3333333300000000333333377777777F333333330EEEEEE0
      33333337FFFFFF7FF3333333000000000333333777777777F33333330000000B
      03333337777777F7F33333330000000003333337777777773333}
    NumGlyphs = 2
  end
  object cbPavage: TCheckBoxV
    Left = 13
    Top = 52
    Width = 97
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Tile'
    TabOrder = 4
    UpdateVarOnToggle = False
  end
  object cbStretch: TCheckBoxV
    Left = 13
    Top = 70
    Width = 97
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Stretch'
    TabOrder = 5
    UpdateVarOnToggle = False
  end
  object cbAspectRatio: TCheckBoxV
    Left = 137
    Top = 52
    Width = 112
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Keep aspect ratio'
    TabOrder = 6
    UpdateVarOnToggle = False
  end
end
