object SyslistView: TSyslistView
  Left = 0
  Top = 0
  Width = 202
  Height = 264
  TabOrder = 0
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 202
    Height = 234
    Align = alClient
    HideSelection = False
    Indent = 19
    ReadOnly = True
    SortType = stBoth
    TabOrder = 0
    OnChange = TreeView1Change
    OnExpanding = TreeView1Expanding
  end
  object Panel1: TPanel
    Left = 0
    Top = 234
    Width = 202
    Height = 30
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 56
      Top = 8
      Width = 34
      Height = 13
      Caption = 'Search'
    end
    object cbSort: TCheckBoxV
      Left = 5
      Top = 6
      Width = 41
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Sort'
      TabOrder = 0
      UpdateVarOnToggle = True
    end
    object ESsearch: TEdit
      Left = 97
      Top = 5
      Width = 72
      Height = 21
      TabOrder = 1
      OnChange = ESsearchChange
    end
  end
end
