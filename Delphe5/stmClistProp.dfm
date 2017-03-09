object ClistProp: TClistProp
  Left = 584
  Top = 210
  BorderStyle = bsToolWindow
  Caption = 'ClistProp'
  ClientHeight = 266
  ClientWidth = 249
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
  object Label1: TLabel
    Left = 15
    Top = 10
    Width = 34
    Height = 13
    Caption = 'Vevent'
  end
  object Label2: TLabel
    Left = 15
    Top = 33
    Width = 39
    Height = 13
    Caption = 'Vdisplay'
  end
  object Label3: TLabel
    Left = 15
    Top = 56
    Width = 32
    Height = 13
    Caption = 'Vzoom'
  end
  object Label4: TLabel
    Left = 15
    Top = 152
    Width = 57
    Height = 13
    Caption = 'Max cursors'
  end
  object Label5: TLabel
    Left = 15
    Top = 174
    Width = 72
    Height = 13
    Caption = 'Decimal places'
  end
  object BOK: TButton
    Left = 51
    Top = 232
    Width = 64
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Bcancel: TButton
    Left = 138
    Top = 232
    Width = 64
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 85
    Width = 113
    Height = 49
    Caption = 'Cursor color'
    TabOrder = 2
    object Pselected: TPanel
      Left = 8
      Top = 18
      Width = 49
      Height = 21
      Caption = 'Selected'
      TabOrder = 0
      OnClick = PselectedClick
    end
    object PotherCursors: TPanel
      Left = 62
      Top = 18
      Width = 44
      Height = 21
      Caption = 'Others'
      TabOrder = 1
      OnClick = PotherCursorsClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 124
    Top = 85
    Width = 115
    Height = 49
    Caption = 'Caption color'
    TabOrder = 3
    object Pcurrent: TPanel
      Left = 8
      Top = 18
      Width = 49
      Height = 21
      Caption = 'Current'
      TabOrder = 0
      OnClick = PcurrentClick
    end
    object PotherCaptions: TPanel
      Left = 62
      Top = 18
      Width = 44
      Height = 21
      Caption = 'Others'
      TabOrder = 1
      OnClick = PotherCaptionsClick
    end
  end
  object enMaxCursors: TeditNum
    Left = 94
    Top = 149
    Width = 67
    Height = 21
    TabOrder = 4
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object enDeci: TeditNum
    Left = 94
    Top = 171
    Width = 67
    Height = 21
    TabOrder = 5
    Tnum = G_byte
    Max = 255.000000000000000000
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
  object cbAutoZoom: TCheckBoxV
    Left = 14
    Top = 196
    Width = 147
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Autoscale Vzoom'
    TabOrder = 6
    UpdateVarOnToggle = True
  end
  object EditEvent: TEdit
    Left = 64
    Top = 8
    Width = 157
    Height = 21
    TabOrder = 7
    Text = '12121'
  end
  object Bevent: TBitBtn
    Left = 223
    Top = 11
    Width = 14
    Height = 15
    TabOrder = 8
    OnClick = BeventClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333300000000000
      0033388888888888883330F888888888803338F333333333383330F333333333
      803338F333333333383330F333333333803338F333333333383330F333303333
      803338F333333333383330F333000333803338F333333333383330F330000033
      803338F333333333383330F333000333803338F333333333383330F333303333
      803338F333333333383330F333333333803338F333333333383330F333333333
      803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
      0033388888888888883333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object EditDisplay: TEdit
    Left = 64
    Top = 31
    Width = 157
    Height = 21
    TabOrder = 9
    Text = '12121'
  end
  object Bdisplay: TBitBtn
    Left = 223
    Top = 34
    Width = 14
    Height = 15
    TabOrder = 10
    OnClick = BdisplayClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333300000000000
      0033388888888888883330F888888888803338F333333333383330F333333333
      803338F333333333383330F333333333803338F333333333383330F333303333
      803338F333333333383330F333000333803338F333333333383330F330000033
      803338F333333333383330F333000333803338F333333333383330F333303333
      803338F333333333383330F333333333803338F333333333383330F333333333
      803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
      0033388888888888883333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object EditZoom: TEdit
    Left = 64
    Top = 53
    Width = 157
    Height = 21
    TabOrder = 11
    Text = '12121'
  end
  object Bzoom: TBitBtn
    Left = 223
    Top = 56
    Width = 14
    Height = 15
    TabOrder = 12
    OnClick = BzoomClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333300000000000
      0033388888888888883330F888888888803338F333333333383330F333333333
      803338F333333333383330F333333333803338F333333333383330F333303333
      803338F333333333383330F333000333803338F333333333383330F330000033
      803338F333333333383330F333000333803338F333333333383330F333303333
      803338F333333333383330F333333333803338F333333333383330F333333333
      803338F333333333383330FFFFFFFFFFF03338FFFFFFFFFFF833300000000000
      0033388888888888883333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object ColorDialog1: TColorDialog
    Left = 224
    Top = 142
  end
end
