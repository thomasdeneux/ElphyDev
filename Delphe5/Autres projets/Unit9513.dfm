object Form1: TForm1
  Left = 686
  Top = 372
  BorderStyle = bsSingle
  Caption = 'USB-4301'
  ClientHeight = 186
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 18
    Width = 79
    Height = 13
    Caption = 'Pulse Width (ms)'
  end
  object Label2: TLabel
    Left = 12
    Top = 43
    Width = 98
    Height = 13
    Caption = 'Delay 2nd pulse (ms)'
  end
  object Label3: TLabel
    Left = 12
    Top = 67
    Width = 134
    Height = 13
    Caption = 'Interval between pulses (ms)'
  end
  object Label4: TLabel
    Left = 12
    Top = 91
    Width = 85
    Height = 13
    Caption = 'Number Of Pulses'
  end
  object Lduration: TLabel
    Left = 12
    Top = 115
    Width = 40
    Height = 13
    Caption = 'Duration'
  end
  object enPulseWidth: TeditNum
    Left = 160
    Top = 15
    Width = 111
    Height = 21
    TabOrder = 0
    Text = '0'
    OnExit = enPulseWidthExit
    Tnum = G_byte
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDelay: TeditNum
    Left = 160
    Top = 40
    Width = 111
    Height = 21
    TabOrder = 1
    Text = '0'
    OnExit = enPulseWidthExit
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enInterval: TeditNum
    Left = 160
    Top = 64
    Width = 111
    Height = 21
    TabOrder = 2
    Text = '0'
    OnExit = enPulseWidthExit
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enNumberOfPulses: TeditNum
    Left = 160
    Top = 88
    Width = 111
    Height = 21
    TabOrder = 3
    Text = '0'
    OnExit = enPulseWidthExit
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object BGO: TButton
    Left = 52
    Top = 154
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 4
    OnClick = BGOClick
  end
  object Bstop: TButton
    Left = 157
    Top = 154
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 5
    OnClick = BstopClick
  end
  object MainMenu1: TMainMenu
    Left = 248
    Top = 160
    object Board1: TMenuItem
      Caption = 'Board'
      object N01: TMenuItem
        Tag = 1
        Caption = '#0'
        OnClick = N41Click
      end
      object N11: TMenuItem
        Tag = 2
        Caption = '#1'
        OnClick = N41Click
      end
      object N21: TMenuItem
        Tag = 3
        Caption = '#2'
        OnClick = N41Click
      end
      object N31: TMenuItem
        Tag = 4
        Caption = '#3'
        OnClick = N41Click
      end
      object N41: TMenuItem
        Tag = 5
        Caption = '#4'
        OnClick = N41Click
      end
    end
  end
end
