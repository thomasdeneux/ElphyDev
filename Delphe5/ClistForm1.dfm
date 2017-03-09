object ClistForm: TClistForm
  Left = 647
  Top = 298
  BorderStyle = bsToolWindow
  Caption = 'ClistForm'
  ClientHeight = 163
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SBindex: TscrollbarV
    Left = 0
    Top = 25
    Width = 232
    Height = 16
    Align = alTop
    Max = 30000
    PageSize = 0
    TabOrder = 0
    Xmax = 1000.000000000000000000
    dxSmall = 1.000000000000000000
    dxLarge = 10.000000000000000000
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 232
    Height = 25
    Align = alTop
    TabOrder = 1
    object Panel2: TPanel
      Left = 97
      Top = 1
      Width = 50
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Value:'
      TabOrder = 0
    end
    object Pvalue: TPanel
      Left = 147
      Top = 1
      Width = 84
      Height = 23
      Align = alClient
      BevelOuter = bvLowered
      Caption = '0'
      TabOrder = 1
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 45
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Index:'
      TabOrder = 2
    end
    object Pindex: TPanel
      Left = 46
      Top = 1
      Width = 51
      Height = 23
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '0'
      TabOrder = 3
    end
  end
  object Badd: TButton
    Left = 6
    Top = 48
    Width = 44
    Height = 20
    Caption = 'Add'
    TabOrder = 2
    OnEndDrag = BaddEndDrag
    OnMouseDown = BaddMouseDown
    OnStartDrag = BaddStartDrag
  end
  object Bdelete: TButton
    Left = 56
    Top = 48
    Width = 44
    Height = 20
    Caption = 'Delete'
    TabOrder = 3
    OnClick = BdeleteClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 77
    Width = 233
    Height = 42
    TabOrder = 4
    object CBselect: TCheckBoxV
      Left = 8
      Top = 16
      Width = 53
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Select'
      TabOrder = 0
      UpdateVarOnToggle = True
    end
    object cbLocked: TCheckBoxV
      Left = 72
      Top = 16
      Width = 60
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Locked'
      TabOrder = 1
      OnClick = cbLockedClick
      UpdateVarOnToggle = True
    end
    object cbShowCursors: TCheckBoxV
      Left = 144
      Top = 16
      Width = 82
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Show cursors'
      TabOrder = 2
      OnClick = cbShowCursorsClick
      UpdateVarOnToggle = True
    end
  end
  object BselectAll: TButton
    Left = 107
    Top = 48
    Width = 52
    Height = 20
    Caption = 'Select all'
    TabOrder = 5
    OnClick = BselectAllClick
  end
  object BunselectAll: TButton
    Left = 166
    Top = 48
    Width = 64
    Height = 20
    Caption = 'Unselect all'
    TabOrder = 6
    OnClick = BunselectAllClick
  end
  object Bextra: TBitBtn
    Left = 204
    Top = 129
    Width = 25
    Height = 23
    TabOrder = 7
    OnClick = BextraClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333033333
      33333333373F33333333333330B03333333333337F7F33333333333330F03333
      333333337F7FF3333333333330B00333333333337F773FF33333333330F0F003
      333333337F7F773F3333333330B0B0B0333333337F7F7F7F3333333300F0F0F0
      333333377F73737F33333330B0BFBFB03333337F7F33337F33333330F0FBFBF0
      3333337F7333337F33333330BFBFBFB033333373F3333373333333330BFBFB03
      33333337FFFFF7FF3333333300000000333333377777777F333333330EEEEEE0
      33333337FFFFFF7FF3333333000000000333333777777777F33333330000000B
      03333337777777F7F33333330000000003333337777777773333}
    NumGlyphs = 2
  end
  object Panel3: TPanel
    Left = 0
    Top = 128
    Width = 169
    Height = 25
    TabOrder = 8
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 104
      Height = 23
      Align = alLeft
      Caption = 'Displayed cursors'
      TabOrder = 0
    end
    object Pcount: TPanel
      Left = 105
      Top = 1
      Width = 64
      Height = 23
      Align = alLeft
      BevelOuter = bvLowered
      Caption = '0'
      TabOrder = 1
    end
  end
end
