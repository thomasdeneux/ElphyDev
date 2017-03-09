object GlprintForm: TGlprintForm
  Left = 627
  Top = 381
  BorderStyle = bsDialog
  Caption = 'GlprintForm'
  ClientHeight = 219
  ClientWidth = 276
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
  object Label3: TLabel
    Left = 158
    Top = 158
    Width = 32
    Height = 13
    Caption = 'Quality'
  end
  object GroupBox1: TGroupBox
    Left = 13
    Top = 12
    Width = 244
    Height = 109
    Caption = 'Bitmap Size'
    TabOrder = 0
    object Label1: TLabel
      Left = 26
      Top = 24
      Width = 29
      Height = 13
      Caption = 'Width'
    end
    object Label2: TLabel
      Left = 26
      Top = 46
      Width = 32
      Height = 13
      Caption = 'Height'
    end
    object enWidth: TeditNum
      Left = 95
      Top = 21
      Width = 91
      Height = 21
      TabOrder = 0
      Text = 'enWidth'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    object enHeight: TeditNum
      Left = 95
      Top = 43
      Width = 91
      Height = 21
      TabOrder = 1
      Text = 'editNum1'
      Tnum = G_byte
      Max = 255.000000000000000000
      UpdateVarOnExit = False
      Decimal = 0
      Dxu = 1.000000000000000000
    end
    inline ColFrame1: TColFrame
      Left = 27
      Top = 67
      Width = 160
      Height = 26
      TabOrder = 2
      inherited Button: TButton
        Width = 102
        Caption = 'BackGround Color'
      end
      inherited Panel: TPanel
        Left = 114
        Width = 44
      end
    end
  end
  object Bcopy: TButton
    Left = 12
    Top = 182
    Width = 127
    Height = 20
    Caption = 'Copy To ClipBoard'
    ModalResult = 103
    TabOrder = 1
  end
  object Bprint: TButton
    Left = 12
    Top = 131
    Width = 127
    Height = 20
    Caption = 'Print'
    ModalResult = 101
    TabOrder = 2
  end
  object Button2: TButton
    Left = 12
    Top = 156
    Width = 127
    Height = 20
    Caption = 'Save To File'
    ModalResult = 102
    TabOrder = 3
  end
  object enQuality: TeditNum
    Left = 197
    Top = 155
    Width = 57
    Height = 21
    TabOrder = 4
    Text = 'enQuality'
    Tnum = G_byte
    UpdateVarOnExit = False
    Decimal = 0
    Dxu = 1.000000000000000000
  end
end
