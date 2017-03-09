inherited CodeExplorerWindow: TCodeExplorerWindow
  Left = 237
  Top = 237
  HelpContext = 430
  Caption = 'Code Explorer'
  ClientHeight = 306
  ClientWidth = 249
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000005555000000000000000060000000005
    555555500000000000066666000000555D5D5D5500000000006E6E6E60000055
    D5D5D5D50000000006E6E6E6E600005D5D5D5D5D500000006E6E6E6E6E000555
    D5D5D5550000000066E6EEEEE6E0055D5D5DD000000000006E6EEEEEEE6005D5
    D5DDD07F7F7F880666EEEEEEEEE0055DDDDDD000000000006E6EEEEFEFE005D5
    DDDDDFDFD00000006660EEFEFEE0005DDDDDFDFD5000000060070EEFFF600055
    DDDDDFFF00000000007F0EFEFE000005DDDDFDF50000000000F00EEFEF000000
    05DDDD000000000007F0EEEE00000000000000F7000000008F00000000000000
    000000070000000080000000000000000000000F700222000000000000000000
    00000000F02222220000000000000000000000008802A2A2A000000000000000
    00000000080A2A2A20000000000000000000000200A2A2A2A200000000000000
    0000002A2A2A2AAA2A00000000000000000002A2A2AAAAAAA200000000000000
    0000022A2AAAAAAAAA00000000000000000002A2AAAAAFAFA200000000000000
    0000002AAAAAFAFAF00000000000000000000022AAAAAFFF2000000000000000
    00000002AAAAFAFA0000000000000000000000000AAAAF000000000000000000
    000000000000000000000000000000000000000000000000000000000000F87F
    FFFFE01FFE0FC00FF8078007F0038007E0010003E0010003C000000000000000
    0000000000000003C0008003E0008007E001C007E001E00FF003F807E10FFFC4
    03FFFFC003FFFFE007FFFFC003FFFF8003FFFF8001FFFF0001FFFF0001FFFF00
    01FFFF0001FFFF8003FFFF8003FFFFC007FFFFE00FFFFFF83FFFFFFFFFFF}
  OnActivate = FormActivate
  ExplicitWidth = 257
  ExplicitHeight = 332
  PixelsPerInch = 96
  TextHeight = 13
  inherited FGPanel: TPanel
    Width = 240
    Height = 290
    ExplicitWidth = 240
    ExplicitHeight = 290
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 290
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object ExplorerTree: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 240
        Height = 290
        Align = alClient
        BorderStyle = bsNone
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        HintMode = hmHint
        Images = CommandsDataModule.CodeImages
        IncrementalSearch = isAll
        PopupMenu = TreePopupMenu
        TabOrder = 0
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toWheelPanning, toVariableNodeHeight]
        TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
        TreeOptions.StringOptions = [toAutoAcceptEditChange]
        OnDblClick = ExplorerTreeDblClick
        OnGetText = ExplorerTreeGetText
        OnGetImageIndex = ExplorerTreeGetImageIndex
        OnGetHint = ExplorerTreeGetHint
        OnInitChildren = ExplorerTreeInitChildren
        OnInitNode = ExplorerTreeInitNode
        Columns = <>
      end
    end
  end
  object TreePopupMenu: TTBXPopupMenu
    Images = CommandsDataModule.Images
    Left = 8
    Top = 49
    object mnExpandAll: TTBXItem
      Caption = '&Expand All'
      Hint = 'Expand all nodes'
      ImageIndex = 28
      OnClick = mnExpandAllClick
    end
    object nCollapseAll: TTBXItem
      Caption = '&Collapse All'
      Hint = 'Collapse all nodes'
      ImageIndex = 29
      OnClick = nCollapseAllClick
    end
  end
end
