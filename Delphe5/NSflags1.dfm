object NsFlagsDlg: TNsFlagsDlg
  Left = 477
  Top = 231
  BorderStyle = bsDialog
  Caption = 'Check the analog channels you want to export'
  ClientHeight = 359
  ClientWidth = 371
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
  object Panel1: TPanel
    Left = 8
    Top = 7
    Width = 174
    Height = 289
    BevelOuter = bvLowered
    TabOrder = 0
    object VlistBox: TCheckListBox
      Left = 1
      Top = 1
      Width = 172
      Height = 250
      Align = alTop
      ItemHeight = 13
      TabOrder = 0
    end
    object BVselectAll: TButton
      Left = 17
      Top = 260
      Width = 63
      Height = 22
      Caption = 'Select All'
      TabOrder = 1
      OnClick = BVselectAllClick
    end
    object BVunselectAll: TButton
      Left = 90
      Top = 260
      Width = 63
      Height = 22
      Caption = 'Unselect All'
      TabOrder = 2
      OnClick = BVunselectAllClick
    end
  end
  object Panel2: TPanel
    Left = 187
    Top = 7
    Width = 174
    Height = 289
    BevelOuter = bvLowered
    TabOrder = 1
    object VtagListBox: TCheckListBox
      Left = 1
      Top = 1
      Width = 172
      Height = 250
      Align = alTop
      ItemHeight = 13
      TabOrder = 0
    end
    object BVtagUnselectAll: TButton
      Left = 90
      Top = 260
      Width = 63
      Height = 22
      Caption = 'Unselect All'
      TabOrder = 1
      OnClick = BVtagUnselectAllClick
    end
    object BVtagSelectAll: TButton
      Left = 17
      Top = 260
      Width = 63
      Height = 22
      Caption = 'Select All'
      TabOrder = 2
      OnClick = BVtagSelectAllClick
    end
  end
  object Bcancel: TButton
    Left = 210
    Top = 314
    Width = 63
    Height = 22
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object BOK: TButton
    Left = 97
    Top = 314
    Width = 63
    Height = 22
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
end
