inherited MessagesWindow: TMessagesWindow
  Left = 259
  Top = 257
  Width = 701
  Height = 212
  HelpContext = 440
  Caption = 'Messages'
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000FF000000FF000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000FFC6C6C6FF000000FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000FFFFFFFFFFC6C6C6FF0000
    00FF000000000000000000000000000000000000000000000000000000000000
    000000000000000000FF000000FF000000FF000000FFFFFFFFFFFFFFFFFFC6C6
    C6FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    000000000000848484FFC6C6C6FFC6C6C6FFC6C6C6FFFFFFFFFFFFFFFFFFFFFF
    FFFFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FF000000FF0000
    000000000000848484FF848484FF848484FF848484FF848484FF848484FF8484
    84FF848484FF848484FF848484FF848484FF848484FF848484FF848484FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000F9FF
    0000F8FF0000F87F0000C0000000C0000000C0000000C0000000C0000000C000
    0000C0000000C0000000C0000000C0000000C0000000FFFF0000FFFF0000}
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited FGPanel: TPanel
    Width = 676
    Height = 170
    object MessagesView: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 676
      Height = 170
      Align = alClient
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoHotTrack, hoOwnerDraw, hoVisible]
      HintMode = hmTooltip
      PopupMenu = TBXPopupMenu
      TabOrder = 0
      TreeOptions.AnimationOptions = [toAnimatedToggle]
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight]
      TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toUseBlendedImages, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
      TreeOptions.StringOptions = [toAutoAcceptEditChange]
      OnDblClick = MessagesViewDblClick
      OnGetText = MessagesViewGetText
      OnInitNode = MessagesViewInitNode
      Columns = <
        item
          Position = 0
          Width = 300
          WideText = 'Message'
        end
        item
          Position = 1
          Width = 150
          WideText = 'File Name'
        end
        item
          Alignment = taRightJustify
          Position = 2
          WideText = 'Line'
        end
        item
          Alignment = taRightJustify
          Position = 3
          WideText = 'Position'
        end>
    end
    object TBToolbar1: TTBToolbar
      Left = 635
      Top = 0
      Width = 39
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'TBToolbar1'
      TabOrder = 1
      DesignSize = (
        39
        17)
      object TBControlItem5: TTBControlItem
        Control = BtnPreviousMsgs
      end
      object TBControlItem6: TTBControlItem
        Control = BtnNextMsgs
      end
      object BtnPreviousMsgs: TTBXButton
        Left = 0
        Top = 0
        Width = 20
        Height = 17
        Hint = 'Show previous messages'
        Anchors = [akTop, akRight]
        BorderSize = 0
        Caption = '3'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Webdings'
        Font.Style = []
        GlyphSpacing = 0
        Layout = blGlyphBottom
        ParentFont = False
        TabOrder = 0
        OnClick = actPreviousMsgsExecute
      end
      object BtnNextMsgs: TTBXButton
        Left = 20
        Top = 0
        Width = 19
        Height = 17
        Hint = 'Show next messages'
        Anchors = [akTop, akRight]
        BorderSize = 0
        Caption = '4'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Webdings'
        Font.Style = []
        GlyphSpacing = 0
        Layout = blGlyphBottom
        ParentFont = False
        TabOrder = 1
        OnClick = actNextMsgsExecute
      end
    end
  end
  inherited DockClient: TJvDockClient
    Left = 6
    Top = 12
  end
  object TBXPopupMenu: TTBXPopupMenu
    Images = CommandsDataModule.Images
    OnPopup = TBXPopupMenuPopup
    Left = 10
    Top = 82
    object TBXItem1: TTBXItem
      Action = actPreviousMsgs
    end
    object TBXItem2: TTBXItem
      Action = actNextMsgs
    end
    object TBXSeparatorItem1: TTBXSeparatorItem
    end
    object mnClearall: TTBXItem
      Action = actClearAll
    end
    object TBXSeparatorItem2: TTBXSeparatorItem
    end
    object TBXItem3: TTBXItem
      Action = actCopyToClipboard
    end
  end
  object MsgsActionList: TActionList
    Images = CommandsDataModule.Images
    Left = 9
    Top = 47
    object actClearAll: TAction
      Caption = '&Clear all'
      Hint = 'Clear all messages'
      ImageIndex = 14
      OnExecute = ClearAllExecute
    end
    object actPreviousMsgs: TAction
      Caption = '&Previous Messages'
      Hint = 'Show previous messages'
      ImageIndex = 96
      OnExecute = actPreviousMsgsExecute
    end
    object actNextMsgs: TAction
      Caption = '&Next Messages'
      Hint = 'Show next messages'
      ImageIndex = 97
      OnExecute = actNextMsgsExecute
    end
    object actCopyToClipboard: TAction
      Caption = 'Co&py to Clipboard'
      Hint = 'Copy contents to Clipboard'
      ImageIndex = 12
      OnExecute = actCopyToClipboardExecute
    end
  end
end
