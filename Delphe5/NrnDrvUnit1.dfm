object NrnConsole: TNrnConsole
  Left = 836
  Top = 321
  Width = 473
  Height = 335
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'NrnConsole'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 284
    Width = 465
    Height = 23
    Align = alBottom
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 21
      Align = alLeft
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 186
      Top = 1
      Width = 185
      Height = 21
      Align = alLeft
      TabOrder = 1
    end
  end
  object Editor: TSynEdit
    Left = 0
    Top = 0
    Width = 465
    Height = 284
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    OnProcessCommand = EditorProcessCommand
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 384
    Top = 200
  end
end
