object Form1: TForm1
  Left = 476
  Top = 173
  Width = 658
  Height = 414
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 346
    Width = 650
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 72
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 240
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 1
    end
    object Button3: TButton
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button3'
      TabOrder = 2
    end
    object Button4: TButton
      Left = 496
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button4'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 650
    Height = 169
    Align = alTop
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 0
    Top = 169
    Width = 650
    Height = 177
    Align = alClient
    Lines.Strings = (
      'test.Value = 10'
      'print test, test.Value'
      ''
      'test.Value = [1,2,3]'
      'print test'
      '')
    TabOrder = 2
  end
  object PythonEngine1: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 32
    Top = 296
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    Output = Memo1
    Left = 80
    Top = 296
  end
  object PythonDelphiVar1: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'test'
    Left = 176
    Top = 296
  end
end
