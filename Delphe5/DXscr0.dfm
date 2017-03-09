object DXscreenB: TDXscreenB
  Left = 431
  Top = 187
  Width = 334
  Height = 195
  Caption = 'DXscreenB'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DXDraw0: TDXDraw
    Left = 0
    Top = 0
    Width = 326
    Height = 161
    AutoInitialize = True
    AutoSize = True
    Color = clBlack
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Display.RefreshRate = 0
    Options = [doFullScreen, doAllowReboot, doWaitVBlank, doAllowPalette256, doCenter, doFlip, doDirectX7Mode, doHardware, doSelectDriver]
    SurfaceHeight = 161
    SurfaceWidth = 326
    OnFinalizeSurface = DXDraw0FinalizeSurface
    OnInitializing = DXDraw0Initializing
    OnRestoreSurface = DXDraw0RestoreSurface
    Align = alClient
    TabOrder = 0
    Visible = False
  end
end
