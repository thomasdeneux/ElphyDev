object StmColSat: TStmColSat
  Left = 403
  Top = 158
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Colors'
  ClientHeight = 327
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Tag = 1
    Left = 0
    Top = 4
    Width = 51
    Height = 21
    TabOrder = 0
    OnClick = Panel1Click
    OnDblClick = Panel1Click
  end
  object Panel2: TPanel
    Tag = 2
    Left = 0
    Top = 29
    Width = 51
    Height = 21
    TabOrder = 1
    OnClick = Panel1Click
  end
  object Panel3: TPanel
    Tag = 3
    Left = 0
    Top = 53
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 2
    OnClick = Panel1Click
  end
  object Panel4: TPanel
    Tag = 4
    Left = 0
    Top = 78
    Width = 51
    Height = 21
    TabOrder = 3
    OnClick = Panel1Click
  end
  object Panel5: TPanel
    Tag = 5
    Left = 0
    Top = 103
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 4
    OnClick = Panel1Click
  end
  object Panel6: TPanel
    Tag = 6
    Left = 0
    Top = 127
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 5
    OnClick = Panel1Click
  end
  object Panel7: TPanel
    Tag = 7
    Left = 0
    Top = 152
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 6
    OnClick = Panel1Click
  end
  object Panel8: TPanel
    Left = 112
    Top = 4
    Width = 256
    Height = 169
    TabOrder = 7
    object PaintBox1: TPaintBox
      Left = 1
      Top = 1
      Width = 254
      Height = 167
      Align = alClient
      OnPaint = FormPaint
    end
  end
  object Panel21: TPanel
    Tag = 11
    Left = 56
    Top = 4
    Width = 51
    Height = 21
    TabOrder = 8
    OnClick = Panel1Click
    OnDblClick = Panel1Click
  end
  object Panel22: TPanel
    Tag = 12
    Left = 56
    Top = 29
    Width = 51
    Height = 21
    TabOrder = 9
    OnClick = Panel1Click
  end
  object Panel23: TPanel
    Tag = 13
    Left = 56
    Top = 53
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 10
    OnClick = Panel1Click
  end
  object Panel24: TPanel
    Tag = 14
    Left = 56
    Top = 78
    Width = 51
    Height = 21
    TabOrder = 11
    OnClick = Panel1Click
  end
  object Panel25: TPanel
    Tag = 15
    Left = 56
    Top = 103
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 12
    OnClick = Panel1Click
  end
  object Panel26: TPanel
    Tag = 16
    Left = 56
    Top = 127
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 13
    OnClick = Panel1Click
  end
  object Panel27: TPanel
    Tag = 17
    Left = 56
    Top = 152
    Width = 51
    Height = 21
    Caption = ' '
    TabOrder = 14
    OnClick = Panel1Click
  end
  object BOK: TButton
    Left = 179
    Top = 286
    Width = 69
    Height = 22
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 15
  end
  object Bcancel: TButton
    Left = 275
    Top = 286
    Width = 69
    Height = 22
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 16
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 181
    Width = 143
    Height = 53
    Caption = 'Palette name'
    TabOrder = 17
    object cbPalName: TComboBox
      Left = 5
      Top = 20
      Width = 132
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbPalNameChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 156
    Top = 181
    Width = 207
    Height = 77
    Caption = 'Test'
    TabOrder = 18
    object Panel12: TPanel
      Left = 10
      Top = 47
      Width = 193
      Height = 22
      TabOrder = 0
      object sbNbCol: TScrollBar
        Left = 76
        Top = 2
        Width = 77
        Height = 17
        PageSize = 0
        TabOrder = 2
        OnChange = SBnbcolChange
      end
      object Pnbcol: TPanel
        Left = 31
        Top = 1
        Width = 42
        Height = 20
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Panel15: TPanel
        Left = 1
        Top = 1
        Width = 30
        Height = 20
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'N='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object Panel16: TPanel
      Left = 10
      Top = 20
      Width = 193
      Height = 22
      TabOrder = 1
      object sbGamma: TScrollBar
        Left = 113
        Top = 2
        Width = 77
        Height = 17
        PageSize = 0
        TabOrder = 2
        OnChange = SBgammaChange
      end
      object Pgamma: TPanel
        Left = 49
        Top = 1
        Width = 61
        Height = 20
        Align = alLeft
        BevelOuter = bvLowered
        Caption = '255'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Panel18: TPanel
        Left = 1
        Top = 1
        Width = 48
        Height = 20
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Gamma:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  inline SelPan: TcolorPan
    Left = 6
    Top = 266
    Width = 144
    Height = 22
    TabOrder = 19
    inherited Bcol: TButton
      Width = 77
      Caption = 'Select color'
    end
    inherited Pcol: TPanel
      Left = 85
    end
  end
  inline MarkPan: TcolorPan
    Left = 6
    Top = 293
    Width = 144
    Height = 22
    TabOrder = 20
    inherited Bcol: TButton
      Width = 77
      Caption = 'Mark color'
    end
    inherited Pcol: TPanel
      Left = 85
    end
  end
  object cbFull2D: TCheckBoxV
    Left = 14
    Top = 239
    Width = 109
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Full 2D palette'
    TabOrder = 21
    UpdateVarOnToggle = True
  end
end
