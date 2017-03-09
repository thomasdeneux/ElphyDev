object ElphyEntete: TElphyEntete
  Left = 487
  Top = 245
  BorderIcons = []
  BorderStyle = bsNone
  BorderWidth = 1
  ClientHeight = 234
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClick = FormClick
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 382
    Height = 234
    Align = alClient
    TabOrder = 6
    object Lversion: TLabel
      Left = 19
      Top = 88
      Width = 91
      Height = 22
      Caption = 'Version 4.0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BOK: TButton
      Left = 111
      Top = 196
      Width = 64
      Height = 22
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = BOKClick
    end
  end
  object StaticText1: TStaticText
    Left = 18
    Top = 5
    Width = 169
    Height = 59
    Caption = 'ELPHY'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -48
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object StaticText2: TStaticText
    Left = 18
    Top = 58
    Width = 251
    Height = 26
    Caption = 'ElectroPhysiological Software'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object StaticText3: TStaticText
    Left = 18
    Top = 124
    Width = 164
    Height = 23
    Caption = 'G'#233'rard Sadoc 1995-2014'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object StaticText4: TStaticText
    Left = 18
    Top = 164
    Width = 309
    Height = 23
    Caption = 'Unit'#233' de Neurosciences Information et Complexit'#233
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object StaticText5: TStaticText
    Left = 18
    Top = 144
    Width = 99
    Height = 23
    Caption = 'CNRS - UNIC'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object Binfo: TButton
    Left = 211
    Top = 196
    Width = 64
    Height = 22
    Caption = 'Info'
    TabOrder = 5
    OnClick = BinfoClick
  end
end
