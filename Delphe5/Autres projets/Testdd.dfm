object Form1: TForm1
  Left = 376
  Top = 50
  Width = 409
  Height = 488
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TestButton: TButton
    Left = 9
    Top = 417
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 0
    OnClick = TestButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 312
    Width = 185
    Height = 97
    Caption = 'Screen Characteristics'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 23
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Width'
    end
    object Label2: TLabel
      Left = 8
      Top = 47
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Height'
    end
    object Label3: TLabel
      Left = 8
      Top = 71
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Depth'
    end
    object Width: TEdit
      Left = 72
      Top = 19
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '640'
    end
    object Height: TEdit
      Left = 72
      Top = 43
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '480'
    end
    object Depth: TEdit
      Left = 72
      Top = 67
      Width = 105
      Height = 21
      TabOrder = 2
      Text = '8'
    end
  end
  object GroupBox2: TGroupBox
    Left = 200
    Top = 312
    Width = 185
    Height = 97
    Caption = 'Animation'
    TabOrder = 2
    object Label4: TLabel
      Left = 8
      Top = 23
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Count'
    end
    object Label5: TLabel
      Left = 8
      Top = 47
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Size'
    end
    object Label6: TLabel
      Left = 15
      Top = 73
      Width = 32
      Height = 13
      Caption = 'Label6'
    end
    object Count: TEdit
      Left = 72
      Top = 19
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '10'
    end
    object Size: TEdit
      Left = 72
      Top = 43
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '30'
    end
    object ComboBox1: TComboBox
      Left = 73
      Top = 69
      Width = 106
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'un'
        'deux'
        'trois')
    end
  end
  object Button2: TButton
    Left = 154
    Top = 417
    Width = 75
    Height = 25
    Caption = 'test1'
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 1
    Top = 1
    Width = 384
    Height = 292
    Caption = 'Panel1'
    TabOrder = 4
    object PaintBox1: TPaintBox
      Left = 1
      Top = 1
      Width = 382
      Height = 290
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnPaint = PaintBox1Paint
    end
  end
  object Button1: TButton
    Left = 289
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Palette'
    TabOrder = 5
  end
end
