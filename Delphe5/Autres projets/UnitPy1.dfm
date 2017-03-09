object Form1: TForm1
  Left = 436
  Top = 176
  Width = 544
  Height = 375
  VertScrollBar.Range = 197
  ActiveControl = Button1
  AutoScroll = False
  Caption = 'Demo of Python'
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 11
  Font.Name = 'MS Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 161
    Width = 536
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Memo1: TMemo
    Left = 0
    Top = 164
    Width = 536
    Height = 148
    Align = alClient
    Lines.Strings = (
      'test.Value = 10'
      'print test, test.Value'
      ''
      'test.Value = [1,2,3]'
      'print test')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 536
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 6
      Top = 8
      Width = 115
      Height = 25
      Caption = 'Execute script'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 168
      Top = 8
      Width = 91
      Height = 25
      Caption = 'Load script...'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 264
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Save script...'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 368
      Top = 8
      Width = 105
      Height = 25
      Caption = 'Show var content'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 0
    Width = 536
    Height = 161
    Align = alTop
    TabOrder = 2
  end
  object PythonEngine1: TPythonEngine
    InitScript.Strings = (
      'import sys'
      'print "Python Dll: ", sys.version'
      'print sys.copyright'
      'print')
    IO = PythonGUIInputOutput1
    Left = 32
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.py'
    Filter = 'Python files|*.py|Text files|*.txt|All files|*.*'
    Title = 'Open'
    Left = 176
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.py'
    Filter = 'Python files|*.py|Text files|*.txt|All files|*.*'
    Title = 'Save As'
    Left = 208
  end
  object PythonDelphiVar1: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'test'
    Left = 128
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    Output = Memo2
    Left = 64
  end
end
