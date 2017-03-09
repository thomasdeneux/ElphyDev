inherited WaveListForm: TWaveListForm
  Left = 665
  Top = 375
  Width = 497
  Height = 358
  Caption = 'WaveListForm'
  Constraints.MinHeight = 350
  Constraints.MinWidth = 497
  OldCreateOrder = True
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited PaintBox0: TPaintBox
    Width = 489
    Height = 253
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 253
    Width = 489
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Pnum: TPanel
      Left = 53
      Top = 0
      Width = 67
      Height = 26
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '1 / 10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 53
      Height = 26
      Align = alLeft
      Caption = 'Spike'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 234
      Top = 0
      Width = 46
      Height = 26
      Align = alLeft
      Caption = 'Time'
      TabOrder = 2
    end
    object Ptime: TPanel
      Left = 280
      Top = 0
      Width = 85
      Height = 26
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '105.5'
      TabOrder = 3
    end
    object Panel3: TPanel
      Left = 120
      Top = 0
      Width = 46
      Height = 26
      Align = alLeft
      Caption = 'Unit'
      TabOrder = 4
    end
    object Punit: TPanel
      Left = 166
      Top = 0
      Width = 68
      Height = 26
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '3'
      TabOrder = 5
    end
    object SBindex: TscrollbarV
      Left = 376
      Top = 6
      Width = 101
      Height = 17
      Max = 30000
      PageSize = 0
      TabOrder = 6
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = SBindexScrollV
    end
  end
  object Panel5: TPanel [2]
    Left = 0
    Top = 279
    Width = 489
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object cbHold: TCheckBoxV
      Left = 109
      Top = 4
      Width = 76
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Hold traces'
      TabOrder = 0
      OnClick = cbHoldClick
      UpdateVarOnToggle = True
    end
    object cbStdColors: TCheckBoxV
      Left = 13
      Top = 4
      Width = 76
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Std Colors'
      TabOrder = 1
      UpdateVarOnToggle = True
    end
    object BdisplayAll: TButton
      Left = 216
      Top = 3
      Width = 75
      Height = 20
      Caption = 'Display All'
      TabOrder = 2
      OnClick = BdisplayAllClick
    end
  end
end
