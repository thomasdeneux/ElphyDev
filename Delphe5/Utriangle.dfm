object Form1: TForm1
  Left = 691
  Top = 198
  Width = 652
  Height = 773
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 698
    Width = 644
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Btriangles: TButton
      Left = 104
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Triangles'
      TabOrder = 0
      OnClick = BtrianglesClick
    end
    object BEdges: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Edges'
      TabOrder = 1
      OnClick = BEdgesClick
    end
    object Bgo: TButton
      Left = 24
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Add Point'
      TabOrder = 2
      OnClick = BgoClick
    end
    object Bflip: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Flip'
      TabOrder = 3
      OnClick = BflipClick
    end
    object cbEdgeSel: TcomboBoxV
      Left = 361
      Top = 11
      Width = 104
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = 'cbEdgeSel'
      OnChange = cbEdgeSelChange
      Tnum = G_byte
      UpdateVarOnExit = False
      UpdateVarOnChange = True
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 568
    Width = 644
    Height = 130
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 568
    Align = alClient
    TabOrder = 2
    object PaintBox1: TPaintBox
      Left = 1
      Top = 1
      Width = 642
      Height = 566
      Align = alClient
      OnPaint = PaintBox1Paint
    end
  end
end
