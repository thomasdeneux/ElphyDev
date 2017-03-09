object AcqOpenFile: TAcqOpenFile
  Left = 354
  Top = 184
  Width = 324
  Height = 149
  Caption = 'Open file'
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object Lspace: TLabel
    Left = 10
    Top = 11
    Width = 116
    Height = 13
    Caption = 'Space available on disk:'
  end
  object Label1: TLabel
    Left = 10
    Top = 30
    Width = 48
    Height = 13
    Caption = 'File name:'
  end
  object BOK: TButton
    Left = 48
    Top = 81
    Width = 89
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOKClick
  end
  object Bcancel: TButton
    Left = 162
    Top = 81
    Width = 89
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ESname: TeditString
    Left = 14
    Top = 46
    Width = 287
    Height = 21
    TabOrder = 2
    Text = 'ESname'
    len = 0
    UpdateVarOnExit = False
  end
end
