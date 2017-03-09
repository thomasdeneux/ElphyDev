object getTrackColor: TgetTrackColor
  Left = 339
  Top = 57
  Width = 302
  Height = 456
  Caption = 'Track Colors'
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 13
    Top = 361
    Width = 82
    Height = 13
    Caption = 'Delay (frames)'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 18
    Width = 279
    Height = 155
    Caption = 'Color 1'
    TabOrder = 0
    object pb1: TPaintBox
      Left = 5
      Top = 50
      Width = 260
      Height = 33
    end
    object Label1: TLabel
      Left = 6
      Top = 86
      Width = 16
      Height = 13
      Caption = 'min'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 235
      Top = 86
      Width = 19
      Height = 13
      Caption = 'max'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 111
      Top = 86
      Width = 34
      Height = 13
      Caption = 'gamma'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LBdot1: TLabel
      Left = 21
      Top = 130
      Width = 51
      Height = 13
      Caption = 'Dot size:'
    end
    object Label8: TLabel
      Left = 146
      Top = 130
      Width = 31
      Height = 13
      Caption = 'Shift:'
    end
    object tr11: TPanel
      Tag = 1
      Left = 6
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 0
      OnClick = tr11Click
    end
    object tr12: TPanel
      Tag = 2
      Left = 44
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 1
      OnClick = tr11Click
    end
    object tr13: TPanel
      Tag = 3
      Left = 81
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 2
      OnClick = tr11Click
    end
    object tr14: TPanel
      Tag = 4
      Left = 119
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 3
      OnClick = tr11Click
    end
    object tr15: TPanel
      Tag = 5
      Left = 157
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 4
      OnClick = tr11Click
    end
    object tr16: TPanel
      Tag = 6
      Left = 194
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 5
      OnClick = tr11Click
    end
    object tr17: TPanel
      Tag = 7
      Left = 232
      Top = 20
      Width = 33
      Height = 25
      TabOrder = 6
      OnClick = tr11Click
    end
    object ScrollBar1: TScrollBar
      Tag = 1
      Left = 3
      Top = 102
      Width = 71
      Height = 17
      TabOrder = 7
      OnChange = ScrollBar1Change
    end
    object ScrollBar2: TScrollBar
      Tag = 1
      Left = 98
      Top = 101
      Width = 71
      Height = 17
      TabOrder = 8
      OnChange = ScrollBar5Change
    end
    object ScrollBar3: TScrollBar
      Tag = 1
      Left = 192
      Top = 101
      Width = 71
      Height = 17
      TabOrder = 9
      OnChange = ScrollBar3Change
    end
    object enDot1: TeditNum
      Left = 82
      Top = 127
      Width = 41
      Height = 21
      TabOrder = 10
      Tnum = T_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDelta1: TeditNum
      Left = 200
      Top = 127
      Width = 41
      Height = 21
      TabOrder = 11
      Text = '1'
      Tnum = T_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 184
    Width = 279
    Height = 159
    Caption = 'Color 2'
    TabOrder = 1
    object pb2: TPaintBox
      Left = 5
      Top = 50
      Width = 260
      Height = 33
    end
    object Label3: TLabel
      Left = 6
      Top = 85
      Width = 16
      Height = 13
      Caption = 'min'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 235
      Top = 86
      Width = 19
      Height = 13
      Caption = 'max'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 111
      Top = 86
      Width = 34
      Height = 13
      Caption = 'gamma'
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 21
      Top = 130
      Width = 51
      Height = 13
      Caption = 'Dot size:'
    end
    object Label9: TLabel
      Left = 146
      Top = 130
      Width = 31
      Height = 13
      Caption = 'Shift:'
    end
    object tr21: TPanel
      Tag = 11
      Left = 6
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 0
      OnClick = tr11Click
    end
    object tr22: TPanel
      Tag = 12
      Left = 44
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 1
      OnClick = tr11Click
    end
    object tr23: TPanel
      Tag = 13
      Left = 81
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 2
      OnClick = tr11Click
    end
    object tr24: TPanel
      Tag = 14
      Left = 119
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 3
      OnClick = tr11Click
    end
    object tr25: TPanel
      Tag = 15
      Left = 157
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 4
      OnClick = tr11Click
    end
    object tr26: TPanel
      Tag = 16
      Left = 194
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 5
      OnClick = tr11Click
    end
    object tr27: TPanel
      Tag = 17
      Left = 232
      Top = 19
      Width = 33
      Height = 25
      TabOrder = 6
      OnClick = tr11Click
    end
    object ScrollBar4: TScrollBar
      Tag = 2
      Left = 3
      Top = 100
      Width = 71
      Height = 17
      TabOrder = 7
      OnChange = ScrollBar1Change
    end
    object ScrollBar5: TScrollBar
      Tag = 2
      Left = 99
      Top = 100
      Width = 71
      Height = 17
      TabOrder = 8
      OnChange = ScrollBar5Change
    end
    object ScrollBar6: TScrollBar
      Tag = 2
      Left = 194
      Top = 100
      Width = 71
      Height = 17
      TabOrder = 9
      OnChange = ScrollBar3Change
    end
    object enDot2: TeditNum
      Left = 81
      Top = 128
      Width = 41
      Height = 21
      TabOrder = 10
      Tnum = T_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enDelta2: TeditNum
      Left = 200
      Top = 127
      Width = 41
      Height = 21
      TabOrder = 11
      Text = '2'
      Tnum = T_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
  object Button1: TButton
    Left = 105
    Top = 394
    Width = 72
    Height = 26
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object enDelay: TeditNum
    Left = 108
    Top = 359
    Width = 41
    Height = 21
    TabOrder = 3
    Tnum = T_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = True
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
