object tagBlock: TtagBlock
  Left = 232
  Top = 128
  Width = 205
  Height = 154
  Caption = 'Tag block'
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
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 65
    Height = 13
    Caption = 'Start episode:'
  end
  object Label2: TLabel
    Left = 10
    Top = 32
    Width = 62
    Height = 13
    Caption = 'End episode:'
  end
  object Label3: TLabel
    Left = 10
    Top = 54
    Width = 25
    Height = 13
    Caption = 'Step:'
  end
  object ENstart: TeditNum
    Left = 105
    Top = 8
    Width = 80
    Height = 21
    TabOrder = 0
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object ENend: TeditNum
    Left = 105
    Top = 30
    Width = 80
    Height = 21
    TabOrder = 1
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object Button1: TButton
    Left = 14
    Top = 82
    Width = 59
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 108
    Top = 82
    Width = 59
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object ENstep: TeditNum
    Left = 105
    Top = 52
    Width = 80
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
