inherited DetPanel: TDetPanel
  Left = 541
  Top = 214
  Width = 457
  Height = 455
  Caption = 'DetPanel'
  Constraints.MinHeight = 455
  Constraints.MinWidth = 365
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited PaintBox0: TPaintBox
    Width = 441
    Height = 240
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 240
    Width = 441
    Height = 157
    Align = alBottom
    TabOrder = 0
    object Label6: TLabel
      Left = 16
      Top = 34
      Width = 27
      Height = 13
      Caption = 'Xstart'
    end
    object Label7: TLabel
      Left = 142
      Top = 34
      Width = 25
      Height = 13
      Caption = 'Xend'
    end
    object Label2: TLabel
      Left = 16
      Top = 57
      Width = 27
      Height = 13
      Caption = 'Mode'
    end
    object Label4: TLabel
      Left = 16
      Top = 80
      Width = 31
      Height = 13
      Caption = 'Height'
    end
    object Label5: TLabel
      Left = 16
      Top = 103
      Width = 33
      Height = 13
      Caption = 'Length'
    end
    object Label3: TLabel
      Left = 190
      Top = 58
      Width = 74
      Height = 13
      Caption = 'Inhibition length'
    end
    object ShapeExe: TShape
      Left = 329
      Top = 134
      Width = 10
      Height = 10
      Brush.Color = clLime
      Shape = stCircle
      Visible = False
    end
    object Label1: TLabel
      Left = 15
      Top = 11
      Width = 34
      Height = 13
      Caption = 'Source'
    end
    object enXstart: TeditNum
      Left = 56
      Top = 30
      Width = 76
      Height = 21
      TabOrder = 0
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enXend: TeditNum
      Left = 182
      Top = 30
      Width = 76
      Height = 21
      TabOrder = 1
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object Bautoscale: TButton
      Left = 276
      Top = 31
      Width = 67
      Height = 20
      Caption = 'Autoscale'
      TabOrder = 2
      OnClick = BautoscaleClick
    end
    object cbMode: TcomboBoxV
      Left = 57
      Top = 54
      Width = 118
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      UpdateVarOnExit = True
      UpdateVarOnChange = False
    end
    object ENheight: TeditNum
      Left = 97
      Top = 76
      Width = 78
      Height = 21
      TabOrder = 4
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object ENlength: TeditNum
      Left = 97
      Top = 98
      Width = 78
      Height = 21
      TabOrder = 5
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enInhib: TeditNum
      Left = 275
      Top = 54
      Width = 70
      Height = 21
      TabOrder = 6
      Max = 255.000000000000000000
      UpdateVarOnExit = True
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object cbStepOption: TCheckBoxV
      Left = 189
      Top = 78
      Width = 99
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Option 1'
      TabOrder = 7
      UpdateVarOnToggle = False
    end
    object Bexecute: TButton
      Left = 96
      Top = 129
      Width = 75
      Height = 20
      Caption = 'Execute'
      TabOrder = 8
      OnClick = BexecuteClick
    end
    object PnbDet: TPanel
      Left = 193
      Top = 129
      Width = 123
      Height = 20
      Caption = 'N=0'
      TabOrder = 9
    end
    object Pnum: TPanel
      Left = 360
      Top = 19
      Width = 70
      Height = 20
      BevelOuter = bvLowered
      Caption = '1'
      TabOrder = 10
    end
    object sbNum: TscrollbarV
      Left = 362
      Top = 46
      Width = 70
      Height = 13
      Max = 30000
      PageSize = 0
      TabOrder = 11
      Xmax = 1000.000000000000000000
      dxSmall = 1.000000000000000000
      dxLarge = 10.000000000000000000
      OnScrollV = sbNumScrollV
    end
    object cbHold: TCheckBoxV
      Left = 359
      Top = 72
      Width = 76
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Hold traces'
      TabOrder = 12
      OnClick = cbHoldClick
      UpdateVarOnToggle = True
    end
    object EditSource: TEdit
      Left = 56
      Top = 8
      Width = 202
      Height = 21
      TabOrder = 13
    end
    object Bchoose: TBitBtn
      Left = 259
      Top = 11
      Width = 15
      Height = 15
      TabOrder = 14
      OnClick = BchooseClick
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
  end
  inherited MainMenu1: TMainMenu
    Left = 327
    Top = 419
  end
end
