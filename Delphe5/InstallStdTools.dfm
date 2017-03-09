object InstallStdToolsDlg: TInstallStdToolsDlg
  Left = 506
  Top = 186
  BorderStyle = bsDialog
  Caption = 'Tools'
  ClientHeight = 162
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 196
    Height = 16
    Caption = 'To install standard tools, click OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 64
    Width = 115
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Remove old tools'
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 157
    Top = 100
    Width = 64
    Height = 22
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Button2: TButton
    Left = 53
    Top = 100
    Width = 64
    Height = 22
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
end
