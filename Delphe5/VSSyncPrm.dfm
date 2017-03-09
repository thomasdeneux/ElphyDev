object GetVSsyncParam: TGetVSsyncParam
  Left = 526
  Top = 234
  BorderStyle = bsDialog
  Caption = 'Synchronisation spot positions'
  ClientHeight = 330
  ClientWidth = 345
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
  object Label13: TLabel
    Left = 7
    Top = 262
    Width = 68
    Height = 13
    Caption = 'Spot Size (cm)'
  end
  object Label3: TLabel
    Left = 5
    Top = 224
    Width = 186
    Height = 13
    Caption = 'All values in cm: (0,0) = Top Left Corner'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 345
    Height = 109
    Align = alTop
    Caption = 'Synchro'
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 10
      Top = 21
      Width = 158
      Height = 75
      Caption = 'First spot'
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 22
        Width = 5
        Height = 13
        Caption = 'x'
      end
      object Label2: TLabel
        Left = 15
        Top = 45
        Width = 5
        Height = 13
        Caption = 'y'
      end
      object enS1x: TeditNum
        Left = 51
        Top = 19
        Width = 77
        Height = 21
        TabOrder = 0
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enS1y: TeditNum
        Left = 51
        Top = 42
        Width = 77
        Height = 21
        TabOrder = 1
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
    object GroupBox3: TGroupBox
      Left = 176
      Top = 21
      Width = 158
      Height = 75
      Caption = 'Second spot'
      TabOrder = 1
      object Label4: TLabel
        Left = 15
        Top = 22
        Width = 5
        Height = 13
        Caption = 'x'
      end
      object Label5: TLabel
        Left = 15
        Top = 45
        Width = 5
        Height = 13
        Caption = 'y'
      end
      object enS2x: TeditNum
        Left = 51
        Top = 19
        Width = 77
        Height = 21
        TabOrder = 0
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enS2y: TeditNum
        Left = 51
        Top = 42
        Width = 77
        Height = 21
        TabOrder = 1
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 109
    Width = 345
    Height = 109
    Align = alTop
    Caption = 'Control'
    TabOrder = 1
    object GroupBox5: TGroupBox
      Left = 10
      Top = 21
      Width = 158
      Height = 75
      Caption = 'First spot'
      TabOrder = 0
      object Label7: TLabel
        Left = 15
        Top = 22
        Width = 5
        Height = 13
        Caption = 'x'
      end
      object Label8: TLabel
        Left = 15
        Top = 45
        Width = 5
        Height = 13
        Caption = 'y'
      end
      object enC1x: TeditNum
        Left = 51
        Top = 19
        Width = 77
        Height = 21
        TabOrder = 0
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enC1y: TeditNum
        Left = 51
        Top = 42
        Width = 77
        Height = 21
        TabOrder = 1
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
    object GroupBox6: TGroupBox
      Left = 176
      Top = 21
      Width = 158
      Height = 75
      Caption = 'Second spot'
      TabOrder = 1
      object Label10: TLabel
        Left = 15
        Top = 22
        Width = 5
        Height = 13
        Caption = 'x'
      end
      object Label11: TLabel
        Left = 15
        Top = 45
        Width = 5
        Height = 13
        Caption = 'y'
      end
      object enC2x: TeditNum
        Left = 51
        Top = 19
        Width = 77
        Height = 21
        TabOrder = 0
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enC2y: TeditNum
        Left = 51
        Top = 42
        Width = 77
        Height = 21
        TabOrder = 1
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
  end
  object Button2: TButton
    Left = 185
    Top = 293
    Width = 63
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Button1: TButton
    Left = 99
    Top = 293
    Width = 63
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object enSpotSize: TeditNum
    Left = 82
    Top = 259
    Width = 77
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
