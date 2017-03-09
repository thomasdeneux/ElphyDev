object TestForm: TTestForm
  Left = 745
  Top = 253
  Width = 542
  Height = 440
  Caption = 'TestForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 534
    Height = 372
    Align = alClient
    OnPaint = PaintBox1Paint
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 372
    Width = 534
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 56
      Top = 8
      Width = 75
      Height = 25
      Caption = 'GO'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
