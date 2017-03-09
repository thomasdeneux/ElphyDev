inherited XYplotEditor: TXYplotEditor
  Left = 360
  Top = 135
  Width = 389
  Height = 361
  Caption = 'XYplotEditor'
  Constraints.MinWidth = 200
  Font.Charset = ANSI_CHARSET
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DrawGrid1: TDrawGrid
    Left = 204
    Width = 177
    Height = 286
    ColCount = 3
    ColWidths = (
      64
      66
      71)
  end
  inherited Panel1: TPanel
    Width = 381
    TabOrder = 2
    inherited LigCol: TLabel
      Left = 168
    end
  end
  object LeftPanel: TPanel [2]
    Left = 0
    Top = 21
    Width = 204
    Height = 286
    Align = alLeft
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 6
      Top = 10
      Width = 188
      Height = 268
      Caption = 'Polylines'
      TabOrder = 0
      object Lcount: TLabel
        Left = 12
        Top = 20
        Width = 40
        Height = 13
        Caption = 'Count: 0'
      end
      object Label2: TLabel
        Left = 12
        Top = 44
        Width = 45
        Height = 13
        Caption = 'Selected:'
      end
      object Label6: TLabel
        Left = 12
        Top = 149
        Width = 26
        Height = 13
        Caption = 'Style:'
      end
      object Label7: TLabel
        Left = 12
        Top = 176
        Width = 58
        Height = 13
        Caption = 'Symbol size:'
      end
      object Label8: TLabel
        Left = 12
        Top = 201
        Width = 51
        Height = 13
        Caption = 'Line width:'
      end
      object cbSelected: TcomboBoxV
        Left = 66
        Top = 41
        Width = 49
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = '0'
        OnChange = cbSelectedChange
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object Bdelete: TButton
        Left = 91
        Top = 230
        Width = 51
        Height = 25
        Caption = 'Delete'
        TabOrder = 1
        OnClick = BdeleteClick
      end
      object Binsert: TButton
        Left = 26
        Top = 230
        Width = 51
        Height = 25
        Caption = 'Insert'
        TabOrder = 2
        OnClick = BinsertClick
      end
      inline Bcolor: TColFrame
        Left = 9
        Top = 72
        Width = 127
        Height = 26
        TabOrder = 3
        inherited Button: TButton
          Caption = 'Color'
        end
      end
      inline Bcolor2: TColFrame
        Left = 9
        Top = 103
        Width = 127
        Height = 26
        TabOrder = 4
        inherited Button: TButton
          Caption = 'Color2'
        end
      end
      object cbStyle: TcomboBoxV
        Left = 42
        Top = 144
        Width = 132
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object cbSymbolSize: TcomboBoxV
        Left = 113
        Top = 172
        Width = 61
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
      object cbLineWidth: TcomboBoxV
        Left = 113
        Top = 197
        Width = 61
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 7
        UpdateVarOnExit = False
        UpdateVarOnChange = False
      end
    end
  end
  inherited MainMenu1: TMainMenu
    Left = 278
  end
  inherited SaveDialog1: TSaveDialog
    Left = 316
  end
end
