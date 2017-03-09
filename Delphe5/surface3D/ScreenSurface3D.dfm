object Surface: TSurface
  Left = 344
  Top = 252
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '3D Surface'
  ClientHeight = 461
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Image: TImage
    Left = 19
    Top = 50
    Width = 400
    Height = 400
  end
  object ButtonDraw: TButton
    Left = 15
    Top = 8
    Width = 89
    Height = 33
    Caption = 'Draw'
    TabOrder = 0
    OnClick = ButtonDrawClick
  end
  object ClearClear: TButton
    Left = 122
    Top = 8
    Width = 89
    Height = 33
    Caption = 'Clear'
    TabOrder = 1
    OnClick = ClearClearClick
  end
  object ButtonPrint: TButton
    Left = 335
    Top = 8
    Width = 89
    Height = 33
    Caption = 'Print'
    TabOrder = 2
    OnClick = ButtonPrintClick
  end
  object ButtonWriteBMP: TButton
    Left = 228
    Top = 8
    Width = 89
    Height = 33
    Caption = 'Write BMP'
    TabOrder = 3
    OnClick = ButtonWriteBMPClick
  end
end
