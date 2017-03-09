object ElphyOpt: TElphyOpt
  Left = 440
  Top = 432
  BorderStyle = bsDialog
  Caption = 'Elphy Options'
  ClientHeight = 303
  ClientWidth = 417
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
  object Label1: TLabel
    Left = 12
    Top = 24
    Width = 71
    Height = 13
    Caption = 'MATLAB Path '
  end
  object Label2: TLabel
    Left = 13
    Top = 137
    Width = 85
    Height = 13
    Caption = 'Managed Memory'
  end
  object Label3: TLabel
    Left = 12
    Top = 48
    Width = 55
    Height = 13
    Caption = 'DATA Root'
  end
  object Label4: TLabel
    Left = 12
    Top = 72
    Width = 41
    Height = 13
    Caption = 'PG Root'
  end
  object Label5: TLabel
    Left = 12
    Top = 96
    Width = 75
    Height = 13
    Caption = 'TEMP Directory'
  end
  object Label6: TLabel
    Left = 144
    Top = 217
    Width = 46
    Height = 13
    Caption = 'Log Code'
  end
  object Label7: TLabel
    Left = 13
    Top = 161
    Width = 63
    Height = 13
    Caption = 'Cuda Version'
  end
  object Label8: TLabel
    Left = 13
    Top = 184
    Width = 73
    Height = 13
    Caption = 'DirectX Version'
  end
  object Button1: TButton
    Left = 126
    Top = 249
    Width = 69
    Height = 22
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 230
    Top = 249
    Width = 69
    Height = 22
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ESMatlab: TeditString
    Left = 97
    Top = 22
    Width = 289
    Height = 21
    TabOrder = 2
    Text = 'ESMatlab'
    len = 0
    UpdateVarOnExit = False
  end
  object MatlabButton: TBitBtn
    Tag = 1
    Left = 387
    Top = 24
    Width = 15
    Height = 15
    TabOrder = 3
    OnClick = MatlabButtonClick
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
  object cbManagedMem: TcomboBoxV
    Left = 114
    Top = 134
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'cbManagedMem'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object ESdataRoot: TeditString
    Left = 97
    Top = 46
    Width = 289
    Height = 21
    TabOrder = 5
    Text = 'ESdataRoot'
    len = 0
    UpdateVarOnExit = False
  end
  object DataRootBtn: TBitBtn
    Tag = 1
    Left = 387
    Top = 48
    Width = 15
    Height = 15
    TabOrder = 6
    OnClick = DataRootBtnClick
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
  object ESpgRoot: TeditString
    Left = 97
    Top = 70
    Width = 289
    Height = 21
    TabOrder = 7
    Text = 'ESpgRoot'
    len = 0
    UpdateVarOnExit = False
  end
  object PgRootBtn: TBitBtn
    Tag = 1
    Left = 387
    Top = 72
    Width = 15
    Height = 15
    TabOrder = 8
    OnClick = PgRootBtnClick
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
  object EStempDir: TeditString
    Left = 97
    Top = 94
    Width = 289
    Height = 21
    TabOrder = 9
    Text = 'TempDir'
    len = 0
    UpdateVarOnExit = False
  end
  object TempDirBtn: TBitBtn
    Tag = 1
    Left = 387
    Top = 96
    Width = 15
    Height = 15
    TabOrder = 10
    OnClick = TempDirBtnClick
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
  object CBcreateLog: TCheckBoxV
    Left = 12
    Top = 217
    Width = 97
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Create Log File'
    TabOrder = 11
    UpdateVarOnToggle = False
  end
  object enLogCode: TeditNum
    Left = 208
    Top = 214
    Width = 90
    Height = 21
    TabOrder = 12
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbCudaVersion: TcomboBoxV
    Left = 114
    Top = 158
    Width = 145
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 13
    Text = 'CudaVersion'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object cbDirectXVersion: TcomboBoxV
    Left = 114
    Top = 181
    Width = 145
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 14
    Text = 'cbManagedMem'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
end
