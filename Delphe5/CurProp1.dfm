object CursorProp: TCursorProp
  Left = 355
  Top = 172
  Width = 385
  Height = 311
  Caption = 'Cursor Properties'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 192
    Top = 35
    Width = 74
    Height = 13
    Caption = 'Small increment'
  end
  object Label2: TLabel
    Left = 192
    Top = 84
    Width = 75
    Height = 13
    Caption = 'Decimal places:'
  end
  object Label3: TLabel
    Left = 13
    Top = 116
    Width = 37
    Height = 13
    Caption = 'Source:'
  end
  object Label4: TLabel
    Left = 13
    Top = 167
    Width = 26
    Height = 13
    Caption = 'Style:'
  end
  object Label5: TLabel
    Left = 9
    Top = 35
    Width = 26
    Height = 13
    Caption = 'Xmin:'
  end
  object Label6: TLabel
    Left = 10
    Top = 57
    Width = 29
    Height = 13
    Caption = 'Xmax:'
  end
  object Label7: TLabel
    Left = 9
    Top = 14
    Width = 23
    Height = 13
    Caption = 'Title:'
  end
  object Label8: TLabel
    Left = 13
    Top = 211
    Width = 70
    Height = 13
    Caption = 'Window width:'
  end
  object Label9: TLabel
    Left = 192
    Top = 57
    Width = 79
    Height = 13
    Caption = 'Large increment:'
  end
  object Label10: TLabel
    Left = 13
    Top = 190
    Width = 78
    Height = 13
    Caption = 'Window content'
  end
  object Label11: TLabel
    Left = 13
    Top = 138
    Width = 30
    Height = 13
    Caption = 'Zoom:'
  end
  object enSmallInc: TeditNum
    Left = 277
    Top = 33
    Width = 90
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDeci: TeditNum
    Left = 277
    Top = 81
    Width = 90
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Bcolor: TButton
    Left = 11
    Top = 81
    Width = 74
    Height = 20
    Caption = 'Color'
    TabOrder = 2
    OnClick = BcolorClick
  end
  object Panel1: TPanel
    Left = 96
    Top = 80
    Width = 88
    Height = 21
    TabOrder = 3
  end
  object BOK: TButton
    Left = 121
    Top = 252
    Width = 59
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Bcancel: TButton
    Left = 193
    Top = 252
    Width = 59
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object CBstyle: TcomboBoxV
    Left = 96
    Top = 163
    Width = 90
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object CBdouble: TCheckBoxV
    Left = 202
    Top = 178
    Width = 166
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Double cursor:'
    TabOrder = 7
    UpdateVarOnToggle = False
  end
  object CBvisible: TCheckBoxV
    Left = 203
    Top = 194
    Width = 165
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Visible'
    TabOrder = 8
    UpdateVarOnToggle = False
  end
  object enXmin: TeditNum
    Left = 94
    Top = 33
    Width = 90
    Height = 21
    TabOrder = 9
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enXmax: TeditNum
    Left = 94
    Top = 54
    Width = 90
    Height = 21
    TabOrder = 10
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object EStitle: TeditString
    Left = 59
    Top = 11
    Width = 308
    Height = 21
    TabOrder = 11
    Text = 'EStitle'
    len = 0
    UpdateVarOnExit = False
  end
  object enWidth: TeditNum
    Left = 96
    Top = 209
    Width = 90
    Height = 21
    TabOrder = 12
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enLargeInc: TeditNum
    Left = 277
    Top = 54
    Width = 90
    Height = 21
    TabOrder = 13
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbWinContent: TcomboBoxV
    Left = 96
    Top = 186
    Width = 90
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 14
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbTrackSource: TCheckBoxV
    Left = 202
    Top = 161
    Width = 166
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Track source'
    TabOrder = 15
    UpdateVarOnToggle = False
  end
  object cbShowScrollBar: TCheckBoxV
    Left = 202
    Top = 210
    Width = 166
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Show scrollbar'
    TabOrder = 16
    UpdateVarOnToggle = False
  end
  object Esource: TEdit
    Left = 72
    Top = 112
    Width = 185
    Height = 21
    TabOrder = 17
    Text = 'Esource'
  end
  object Ezoom: TEdit
    Left = 72
    Top = 135
    Width = 185
    Height = 21
    TabOrder = 18
    Text = 'Edit1'
  end
  object Bsource: TBitBtn
    Left = 261
    Top = 116
    Width = 15
    Height = 15
    TabOrder = 19
    OnClick = BsourceClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333300000000000
      0033388888888888883330F888888888803338F333333333383330F333333333
      803338F333333333383330F333333333803338F333333333383330F333303333
      803338F333333333383330F333000333803338F333333333383330F330000033
      803338F333333333383330F333000333803338F333333333383330F333303333
      803338F333333333383330F333333333803338F333333333383330F333333333
      803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
      0033388888888888883333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object Bzoom: TBitBtn
    Left = 261
    Top = 139
    Width = 15
    Height = 15
    TabOrder = 20
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333300000000000
      0033388888888888883330F888888888803338F333333333383330F333333333
      803338F333333333383330F333333333803338F333333333383330F333303333
      803338F333333333383330F333000333803338F333333333383330F330000033
      803338F333333333383330F333000333803338F333333333383330F333303333
      803338F333333333383330F333333333803338F333333333383330F333333333
      803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
      0033388888888888883333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object ColorDialog1: TColorDialog
    Left = 345
    Top = 251
  end
end
