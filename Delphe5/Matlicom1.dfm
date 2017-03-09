object MatlistCommandA: TMatlistCommandA
  Left = 426
  Top = 253
  Width = 430
  Height = 297
  Caption = 'MatlistCommandA'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 145
    Top = 0
    Height = 243
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 145
    Height = 243
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
    OnDragDrop = ListBox1DragDrop
    OnDragOver = ListBox1DragOver
    OnEndDrag = ListBox1EndDrag
    OnMouseDown = ListBox1MouseDown
  end
  object Panel1: TPanel
    Left = 148
    Top = 0
    Width = 274
    Height = 243
    Align = alClient
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 1
      Top = 4
      Width = 268
      Height = 234
      Align = alClient
      OnPaint = PaintBox1Paint
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 1
      Width = 268
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 208
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Close1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object New1: TMenuItem
        Caption = 'Clear'
        OnClick = Clear1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Addvector1: TMenuItem
        Caption = 'Add vector'
        OnClick = Addvector1Click
      end
      object Deletevector1: TMenuItem
        Caption = 'Delete vector'
        OnClick = Deletevector1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      OnClick = Options1Click
    end
  end
end
