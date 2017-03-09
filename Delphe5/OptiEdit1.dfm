object OptiForm: TOptiForm
  Left = 553
  Top = 226
  Width = 357
  Height = 280
  Caption = 'OptiForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inline TableFrame1: TTableFrame
    Left = 0
    Top = 53
    Width = 349
    Height = 193
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    inherited DrawGrid1: TDrawGrid
      Width = 349
      Height = 193
      DefaultColWidth = 80
      RowCount = 20
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 349
    Height = 53
    Align = alTop
    TabOrder = 1
    object Bcalc: TButton
      Left = 4
      Top = 4
      Width = 93
      Height = 20
      Caption = 'Calculate outputs'
      TabOrder = 0
      OnClick = BcalcClick
    end
    object Bone: TButton
      Left = 100
      Top = 4
      Width = 61
      Height = 20
      Caption = 'One step'
      TabOrder = 1
      OnClick = BoneClick
    end
    object Bopt: TButton
      Left = 164
      Top = 4
      Width = 61
      Height = 20
      Caption = 'Optimize'
      TabOrder = 2
      OnClick = BoptClick
    end
    object Panel2: TPanel
      Left = 1
      Top = 28
      Width = 347
      Height = 24
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object Label2: TLabel
        Left = 270
        Top = 5
        Width = 29
        Height = 13
        Caption = 'Ngrad'
      end
      object Label3: TLabel
        Left = 186
        Top = 5
        Width = 26
        Height = 13
        Caption = 'MaxIt'
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 37
        Height = 24
        Align = alLeft
        BevelOuter = bvLowered
        Caption = 'Chi2'
        TabOrder = 0
      end
      object Pchi2: TPanel
        Left = 37
        Top = 0
        Width = 136
        Height = 24
        Align = alLeft
        BevelOuter = bvLowered
        TabOrder = 1
      end
      object enNgrad: TeditNum
        Left = 303
        Top = 2
        Width = 29
        Height = 21
        TabOrder = 2
        Text = '1'
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
      object enMaxIt: TeditNum
        Left = 218
        Top = 2
        Width = 29
        Height = 21
        TabOrder = 3
        Text = '0'
        Tnum = G_byte
        Max = 255.000000000000000000
        UpdateVarOnExit = False
        Decimal = 0
        Dxu = 1.000000000000000000
      end
    end
  end
end
