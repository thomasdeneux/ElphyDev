object MainForm: TMainForm
  Left = 250
  Top = 122
  Width = 648
  Height = 507
  Caption = 'Direct3D7 IM Sample - Cube'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object DXDraw: TDXDraw
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.BitCount = 16
    Display.FixedBitCount = False
    Display.FixedRatio = True
    Display.FixedSize = False
    Display.RefreshRate = 0
    Options = [doAllowReboot, doWaitVBlank, doCenter, do3D, doDirectX7Mode, doHardware, doSelectDriver]
    OnInitializeSurface = DXDrawInitializeSurface
    Align = alClient
    TabOrder = 0
  end
end
