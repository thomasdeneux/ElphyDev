object RestForm: TRestForm
  Left = 613
  Top = 84
  Width = 758
  Height = 551
  Caption = 'RESTclient'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object AddressMemo: TMemo
    Left = 0
    Top = 0
    Width = 750
    Height = 57
    Align = alTop
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 482
    Width = 750
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Get: TButton
      Left = 8
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Get'
      TabOrder = 0
      OnClick = GetClick
    end
    object MemoClear: TButton
      Left = 312
      Top = 8
      Width = 35
      Height = 25
      Caption = 'Clear'
      TabOrder = 1
      OnClick = MemoClearClick
    end
    object Patch: TButton
      Left = 80
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Put'
      TabOrder = 2
      OnClick = PutClick
    end
    object Button1: TButton
      Left = 144
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Delete'
      TabOrder = 3
      OnClick = DeleteClick
    end
    object Button2: TButton
      Left = 208
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Post'
      TabOrder = 4
      OnClick = PostClick
    end
  end
  object ReceiveLog: TMemo
    Left = 0
    Top = 57
    Width = 750
    Height = 425
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
end
