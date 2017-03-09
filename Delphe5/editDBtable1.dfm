object EditDBtable: TEditDBtable
  Left = 587
  Top = 207
  Width = 680
  Height = 406
  Caption = 'EditDBtable'
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 367
    Align = alClient
    TabOrder = 0
    inline TableFrame1: TTableFrame
      Left = 1
      Top = 30
      Width = 662
      Height = 336
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      inherited DrawGrid1: TDrawGrid
        Width = 662
        Height = 336
        Font.Height = -12
        OnMouseUp = TableFrame1DrawGrid1MouseUp
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 662
      Height = 29
      Align = alTop
      TabOrder = 1
      object Bprop: TButton
        Left = 24
        Top = 4
        Width = 75
        Height = 20
        Caption = 'Properties'
        TabOrder = 0
        OnClick = BpropClick
      end
      object Binsert: TButton
        Left = 104
        Top = 4
        Width = 75
        Height = 20
        Caption = 'Append'
        TabOrder = 1
      end
      object Bdelete: TButton
        Left = 184
        Top = 4
        Width = 75
        Height = 20
        Caption = 'Delete'
        TabOrder = 2
      end
      object Panel2: TPanel
        Left = 526
        Top = 1
        Width = 135
        Height = 27
        Align = alRight
        BevelOuter = bvLowered
        TabOrder = 3
      end
      object BupdateDB: TButton
        Left = 265
        Top = 4
        Width = 112
        Height = 20
        Caption = 'Update Database'
        TabOrder = 4
      end
    end
  end
end
