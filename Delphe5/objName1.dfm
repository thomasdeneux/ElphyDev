object GetObjName: TGetObjName
  Left = 703
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Object name'
  ClientHeight = 120
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BOK: TButton
    Left = 22
    Top = 76
    Width = 71
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BOKClick
  end
  object Bcancel: TButton
    Left = 110
    Top = 76
    Width = 71
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editString1: TeditString
    Left = 5
    Top = 10
    Width = 188
    Height = 21
    TabOrder = 2
    Text = 'editString1'
    len = 0
    UpdateVarOnExit = False
  end
  object cbPermanent: TCheckBoxV
    Left = 4
    Top = 42
    Width = 82
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Permanent'
    TabOrder = 3
    UpdateVarOnToggle = False
  end
end
