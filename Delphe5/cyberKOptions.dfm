object CyberKOpt: TCyberKOpt
  Left = 654
  Top = 301
  BorderStyle = bsDialog
  Caption = 'CyberK Options'
  ClientHeight = 207
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 22
    Top = 124
    Width = 201
    Height = 16
    Caption = 'Device Maximum Electrode Count'
  end
  object Bcancel: TButton
    Left = 297
    Top = 164
    Width = 65
    Height = 24
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object BOK: TButton
    Left = 203
    Top = 164
    Width = 65
    Height = 24
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 20
    Top = 20
    Width = 523
    Height = 80
    Caption = 'Central Software Directory'
    TabOrder = 2
    object Bbrowse: TButton
      Left = 452
      Top = 31
      Width = 64
      Height = 24
      Caption = 'Browse'
      TabOrder = 0
      OnClick = BbrowseClick
    end
    object esCentralDir: TEdit
      Left = 10
      Top = 30
      Width = 434
      Height = 21
      TabOrder = 1
      Text = 'esCentralDir'
    end
  end
  object enDevChCount: TeditNum
    Left = 243
    Top = 120
    Width = 121
    Height = 24
    TabOrder = 3
    Tnum = G_byte
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
