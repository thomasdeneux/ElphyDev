object EditDBtable: TEditDBtable
  Left = 587
  Top = 207
  Width = 680
  Height = 406
  Caption = 'EditDBtable'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 672
    Height = 373
    Align = alClient
    TabOrder = 0
    inline TableFrame1: TTableFrame
      Left = 1
      Top = 37
      Width = 670
      Height = 335
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      inherited DrawGrid1: TDrawGrid
        Width = 670
        Height = 335
        Font.Height = -15
        OnMouseUp = TableFrame1DrawGrid1MouseUp
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 670
      Height = 36
      Align = alTop
      TabOrder = 1
      object Bprop: TButton
        Left = 30
        Top = 5
        Width = 92
        Height = 25
        Caption = 'Properties'
        TabOrder = 0
        OnClick = BpropClick
      end
      object Binsert: TButton
        Left = 128
        Top = 5
        Width = 92
        Height = 25
        Caption = 'Append'
        TabOrder = 1
      end
      object Bdelete: TButton
        Left = 226
        Top = 5
        Width = 93
        Height = 25
        Caption = 'Delete'
        TabOrder = 2
      end
      object Panel2: TPanel
        Left = 502
        Top = 1
        Width = 167
        Height = 34
        Align = alRight
        BevelOuter = bvLowered
        TabOrder = 3
      end
      object BupdateDB: TButton
        Left = 326
        Top = 5
        Width = 138
        Height = 25
        Caption = 'Update Database'
        TabOrder = 4
      end
    end
  end
end
