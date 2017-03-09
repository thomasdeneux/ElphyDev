object InspectFormDac: TInspectFormDac
  Left = 526
  Top = 314
  Width = 189
  Height = 333
  BorderIcons = [biSystemMenu]
  Caption = 'Elphy objects'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 185
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 181
    Height = 243
    Align = alClient
    HideSelection = False
    Indent = 19
    ReadOnly = True
    SortType = stBoth
    TabOrder = 0
    OnChange = TreeView1Change
    OnDragDrop = TreeView1DragDrop
    OnDragOver = TreeView1DragOver
    OnEndDrag = TreeView1EndDrag
    OnExpanding = TreeView1Expanding
    OnMouseDown = TreeView1MouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 243
    Width = 181
    Height = 62
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 56
      Top = 41
      Width = 34
      Height = 13
      Caption = 'Search'
    end
    object Bshow: TButton
      Left = 8
      Top = 10
      Width = 52
      Height = 21
      Caption = 'Show'
      TabOrder = 0
      OnClick = BshowClick
    end
    object Bdestroy: TButton
      Left = 64
      Top = 10
      Width = 50
      Height = 21
      Caption = 'Destroy'
      TabOrder = 1
      OnClick = BdestroyClick
    end
    object Binfo: TButton
      Left = 119
      Top = 10
      Width = 50
      Height = 21
      Caption = 'Info'
      TabOrder = 2
      OnClick = BinfoClick
    end
    object cbSort: TCheckBoxV
      Left = 5
      Top = 40
      Width = 41
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Sort'
      TabOrder = 3
      OnClick = cbSortClick
      UpdateVarOnToggle = True
    end
    object ESsearch: TEdit
      Left = 97
      Top = 38
      Width = 72
      Height = 21
      TabOrder = 4
      OnChange = ESsearchChange
    end
  end
end
