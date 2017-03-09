object ChooseNrnSym: TChooseNrnSym
  Left = 535
  Top = 249
  BorderStyle = bsDialog
  Caption = 'Choose a NEURON symbol'
  ClientHeight = 370
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bsection: TButton
    Tag = 1
    Left = 26
    Top = 296
    Width = 69
    Height = 20
    Caption = 'Section'
    TabOrder = 0
    OnClick = BsectionClick
  end
  object Bobjvar: TButton
    Tag = 2
    Left = 100
    Top = 296
    Width = 69
    Height = 20
    Caption = 'Object Var'
    TabOrder = 1
    OnClick = BsectionClick
  end
  object Bvar: TButton
    Tag = 3
    Left = 175
    Top = 296
    Width = 69
    Height = 20
    Caption = 'Var'
    TabOrder = 2
    OnClick = BsectionClick
  end
  object Btemplate: TButton
    Tag = 4
    Left = 250
    Top = 296
    Width = 69
    Height = 20
    Caption = 'Template'
    TabOrder = 3
    OnClick = BsectionClick
  end
  object Bok: TButton
    Left = 98
    Top = 334
    Width = 63
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Bcancel: TButton
    Left = 183
    Top = 334
    Width = 63
    Height = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 346
    Height = 281
    Align = alTop
    Indent = 19
    TabOrder = 6
    OnChange = TreeView1Change
  end
end
