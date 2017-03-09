object GetDateForm: TGetDateForm
  Left = 579
  Top = 313
  BorderStyle = bsDialog
  Caption = 'Set Date And Time'
  ClientHeight = 264
  ClientWidth = 207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MonthCalendar1: TMonthCalendar
    Left = 8
    Top = 8
    Width = 191
    Height = 154
    Date = 40718.597641597220000000
    TabOrder = 0
  end
  object BOK: TButton
    Left = 29
    Top = 218
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Bcancel: TButton
    Left = 107
    Top = 218
    Width = 69
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PanelTime: TPanel
    Left = 24
    Top = 178
    Width = 164
    Height = 23
    BevelOuter = bvLowered
    TabOrder = 3
    object Label2: TLabel
      Left = 35
      Top = 5
      Width = 6
      Height = 13
      Caption = 'h'
    end
    object Label3: TLabel
      Left = 90
      Top = 5
      Width = 14
      Height = 13
      Caption = 'mn'
    end
    object Label4: TLabel
      Left = 147
      Top = 5
      Width = 5
      Height = 13
      Caption = 's'
    end
    object enHour: TeditNum
      Left = 2
      Top = 2
      Width = 30
      Height = 21
      TabOrder = 0
      Text = '000'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enMinute: TeditNum
      Left = 57
      Top = 2
      Width = 30
      Height = 21
      TabOrder = 1
      Text = '00'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enSecond: TeditNum
      Left = 114
      Top = 2
      Width = 30
      Height = 21
      TabOrder = 2
      Text = '00'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
  end
end
