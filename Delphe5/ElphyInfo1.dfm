object ElphyFileInfo: TElphyFileInfo
  Left = 633
  Top = 206
  Width = 632
  Height = 524
  Caption = 'File informations'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 250
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 497
    ActivePage = TabBlocks
    Align = alClient
    TabOrder = 0
    object TabGeneral: TTabSheet
      Caption = 'General'
      object MemoGeneral: TMemo
        Left = 0
        Top = 0
        Width = 446
        Height = 321
        Align = alClient
        ReadOnly = True
        TabOrder = 0
      end
    end
    object TabBlocks: TTabSheet
      Caption = 'Blocks'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 351
        Width = 616
        Height = 118
        Align = alBottom
        TabOrder = 0
        object LnbBlocks: TLabel
          Left = 8
          Top = 64
          Width = 3
          Height = 13
        end
        object BsaveBlocks: TButton
          Left = 8
          Top = 82
          Width = 137
          Height = 22
          Caption = 'Save Selected Blocks'
          TabOrder = 0
          OnClick = BsaveBlocksClick
        end
        object BOpenFile: TButton
          Left = 8
          Top = 11
          Width = 137
          Height = 22
          Caption = 'Open File'
          TabOrder = 1
          OnClick = BOpenFileClick
        end
        object EditFileName: TEdit
          Left = 7
          Top = 36
          Width = 602
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object Breload: TButton
          Left = 176
          Top = 82
          Width = 137
          Height = 22
          Caption = 'Analyze And Reload File'
          TabOrder = 3
          OnClick = BreloadClick
        end
        object BcloseData: TButton
          Left = 328
          Top = 82
          Width = 137
          Height = 22
          Caption = 'Close Last Data Block'
          TabOrder = 4
          OnClick = BcloseDataClick
        end
      end
      object MemoBlocks: TMemo
        Left = 169
        Top = 0
        Width = 447
        Height = 351
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object VLboxBlocks: TListBox
        Left = 0
        Top = 0
        Width = 169
        Height = 351
        Style = lbOwnerDrawFixed
        Align = alLeft
        ItemHeight = 16
        MultiSelect = True
        TabOrder = 2
        OnClick = VLBoxBlocksClick
        OnDrawItem = VLboxBlocksDrawItem
      end
    end
    object TabTags: TTabSheet
      Caption = 'Tags'
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 0
        Top = 0
        Height = 441
      end
      object Splitter2: TSplitter
        Left = 185
        Top = 0
        Height = 441
      end
      object Panel1: TPanel
        Left = 0
        Top = 441
        Width = 616
        Height = 21
        Align = alBottom
        TabOrder = 1
      end
      object MemoTag: TMemo
        Left = 188
        Top = 0
        Width = 428
        Height = 441
        Align = alClient
        TabOrder = 0
      end
      object VLboxTags: TListBox
        Left = 3
        Top = 0
        Width = 182
        Height = 441
        Style = lbOwnerDrawFixed
        Align = alLeft
        ItemHeight = 16
        TabOrder = 2
        OnClick = VLboxTagClick
        OnDrawItem = VLboxTagsDrawItem
      end
    end
  end
end
