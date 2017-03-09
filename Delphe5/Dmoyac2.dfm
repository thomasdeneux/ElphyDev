object AverageBox: TAverageBox
  Left = 339
  Top = 175
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Averaging'
  ClientHeight = 146
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Btag: TButton
    Left = 3
    Top = 69
    Width = 69
    Height = 20
    Caption = 'Tag'
    TabOrder = 0
    OnClick = BtagClick
  end
  object Buntag: TButton
    Left = 79
    Top = 69
    Width = 69
    Height = 20
    Caption = 'Untag'
    TabOrder = 1
    OnClick = BuntagClick
  end
  object Bclear: TButton
    Left = 154
    Top = 69
    Width = 70
    Height = 20
    Caption = 'Clear'
    TabOrder = 2
    OnClick = BclearClick
  end
  object BtagBlock: TButton
    Left = 230
    Top = 69
    Width = 69
    Height = 20
    Caption = 'Tag block'
    TabOrder = 3
    OnClick = BtagBlockClick
  end
  object GroupBox1: TGroupBox
    Left = 1
    Top = 1
    Width = 299
    Height = 62
    Caption = 'Tagged episodes'
    TabOrder = 5
    object Memo1: TMemo
      Left = 2
      Top = 15
      Width = 295
      Height = 45
      Align = alClient
      Lines.Strings = (
        '1'
        '2'
        '3')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object cbStdDev: TCheckBoxV
    Left = 182
    Top = 107
    Width = 113
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Compute StdDev'
    TabOrder = 6
    OnClick = cbStdDevClick
    UpdateVarOnToggle = False
  end
  object GroupBox2: TGroupBox
    Left = 6
    Top = 95
    Width = 155
    Height = 44
    Caption = 'Save'
    TabOrder = 7
    object Bappend: TButton
      Left = 78
      Top = 15
      Width = 67
      Height = 20
      Caption = 'Append'
      TabOrder = 0
      OnClick = BappendClick
    end
  end
  object Bsave: TButton
    Left = 13
    Top = 110
    Width = 67
    Height = 20
    Caption = 'New file'
    TabOrder = 4
    OnClick = BsaveClick
  end
end
