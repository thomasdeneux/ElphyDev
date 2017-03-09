object DragAndDropObject: TDragAndDropObject
  Left = 357
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Save object to file'
  ClientHeight = 216
  ClientWidth = 304
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
    Left = 3
    Top = 57
    Width = 44
    Height = 13
    Caption = 'Comment'
  end
  object BOK: TButton
    Left = 75
    Top = 181
    Width = 53
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 171
    Top = 181
    Width = 53
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 0
    Top = 73
    Width = 304
    Height = 90
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 304
    Height = 41
    Align = alTop
    Caption = 'Object name'
    TabOrder = 3
    object Lname: TLabel
      Left = 8
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Name'
    end
  end
end
