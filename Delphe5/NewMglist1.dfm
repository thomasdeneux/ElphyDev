object NewMGlist: TNewMGlist
  Left = 498
  Top = 407
  BorderStyle = bsDialog
  Caption = 'New MGlist'
  ClientHeight = 150
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 16
    Width = 28
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 16
    Top = 65
    Width = 20
    Height = 13
    Caption = 'Title'
  end
  object BOK: TButton
    Left = 96
    Top = 116
    Width = 67
    Height = 22
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOKClick
  end
  object Bcancel: TButton
    Left = 184
    Top = 116
    Width = 67
    Height = 22
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object esName: TeditString
    Left = 11
    Top = 32
    Width = 320
    Height = 21
    TabOrder = 2
    Text = 'esName'
    len = 0
    UpdateVarOnExit = False
  end
  object esTitle: TeditString
    Left = 11
    Top = 80
    Width = 320
    Height = 21
    TabOrder = 3
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
end
