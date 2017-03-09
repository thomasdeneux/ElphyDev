object PythonForm: TPythonForm
  Left = 456
  Top = 220
  Width = 476
  Height = 403
  Caption = 'PythonForm'
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
  object Splitter1: TSplitter
    Left = 0
    Top = 161
    Width = 468
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 328
    Width = 468
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Bload: TButton
      Left = 48
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Load'
      TabOrder = 0
      OnClick = BloadClick
    end
    object Bsave: TButton
      Left = 224
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save results'
      TabOrder = 1
      OnClick = BsaveClick
    end
    object Bexecute: TButton
      Left = 136
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Execute'
      TabOrder = 2
      OnClick = BexecuteClick
    end
  end
  object MemoSource: TMemo
    Left = 0
    Top = 0
    Width = 468
    Height = 161
    Align = alTop
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object MemoOutput: TMemo
    Left = 0
    Top = 164
    Width = 468
    Height = 164
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object PythonEngine1: TPythonEngine
    FatalAbort = False
    IO = PythonGUIInputOutput1
    Left = 320
    Top = 343
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = False
    RawOutput = False
    Output = MemoOutput
    Left = 352
    Top = 343
  end
  object OpenDialog1: TOpenDialog
    Left = 384
    Top = 343
  end
  object SaveDialog1: TSaveDialog
    Left = 416
    Top = 343
  end
end
