object Form1: TForm1
  Left = 218
  Top = 18
  Width = 686
  Height = 878
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
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 657
    Height = 385
  end
  object Button1: TButton
    Left = 8
    Top = 400
    Width = 97
    Height = 25
    Caption = 'Open Picture...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 808
    Width = 105
    Height = 25
    Caption = 'Execute'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 568
    Width = 657
    Height = 233
    Lines.Strings = (
      'import StringIO'
      'import Image'
      ''
      'def ProcessImage(data):'
      '  stream = StringIO.StringIO(data)'
      '  im = Image.open(stream)'
      
        '  print "Processing image %s of %d bytes" % (im.format, len(data' +
        '))'
      '  new_im = im.rotate(90)'
      '  new_im.format = im.format'
      '  return new_im'
      '  '
      'def ImageToString(image):'
      '  stream = StringIO.StringIO()'
      '  image.save(stream, image.format)'
      '  return stream.getvalue()')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 8
    Top = 432
    Width = 657
    Height = 129
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object chkUseDC: TCheckBox
    Left = 152
    Top = 808
    Width = 193
    Height = 17
    Caption = 'Use Device Context'
    TabOrder = 4
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 104
    Top = 336
  end
  object PythonEngine1: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 168
    Top = 624
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    Output = Memo2
    Left = 208
    Top = 624
  end
end
