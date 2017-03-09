object ObjFileCommand: TObjFileCommand
  Left = 764
  Top = 327
  Width = 460
  Height = 446
  Caption = 'ObjFileCommand'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 145
    Top = 0
    Height = 364
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 145
    Height = 364
    Align = alLeft
    HideSelection = False
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeView1Change
    OnDragDrop = TreeView1DragDrop
    OnDragOver = TreeView1DragOver
    OnEndDrag = TreeView1EndDrag
    OnMouseDown = TreeView1MouseDown
  end
  object Panel1: TPanel
    Left = 148
    Top = 0
    Width = 304
    Height = 364
    Align = alClient
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 1
      Top = 89
      Width = 298
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 298
      Height = 88
      Align = alTop
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    inline UODisplay1: TUODisplay
      Left = 1
      Top = 92
      Width = 298
      Height = 267
      Align = alClient
      TabOrder = 1
      inherited PaintBox0: TPaintBox
        Width = 298
        Height = 267
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 364
    Width = 452
    Height = 36
    Align = alBottom
    TabOrder = 2
    object Bok: TButton
      Left = 147
      Top = 8
      Width = 63
      Height = 20
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = BokClick
    end
    object Bcancel: TButton
      Left = 232
      Top = 8
      Width = 63
      Height = 20
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 208
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
    end
  end
end
