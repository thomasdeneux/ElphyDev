object saisiePal32: TsaisiePal32
  Left = 335
  Top = 173
  Width = 238
  Height = 154
  Caption = 'Palette manager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label19: TLabel
    Left = 16
    Top = 18
    Width = 112
    Height = 13
    Caption = 'Background luminance:'
  end
  object BOK: TButton
    Left = 27
    Top = 92
    Width = 71
    Height = 22
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 131
    Top = 92
    Width = 71
    Height = 22
    Caption = 'Apply'
    TabOrder = 1
    OnClick = BApplylClick
  end
  object enBK: TeditNum
    Left = 136
    Top = 14
    Width = 58
    Height = 21
    TabOrder = 2
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbGammaRamp: TCheckBoxV
    Left = 15
    Top = 44
    Width = 180
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use Gamma Ramp'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
end
