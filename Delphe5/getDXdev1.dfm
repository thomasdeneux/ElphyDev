object DXdevice: TDXdevice
  Left = 425
  Top = 339
  BorderStyle = bsDialog
  Caption = 'DirectX device'
  ClientHeight = 103
  ClientWidth = 248
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
  object Label3: TLabel
    Left = 15
    Top = 13
    Width = 34
    Height = 13
    Caption = 'Device'
  end
  object cbDevice: TcomboBoxV
    Left = 73
    Top = 10
    Width = 153
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'Dev1'
    Tnum = G_byte
    UpdateVarOnExit = False
    UpdateVarOnChange = False
  end
  object Button1: TButton
    Left = 45
    Top = 52
    Width = 63
    Height = 20
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 131
    Top = 52
    Width = 63
    Height = 20
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
