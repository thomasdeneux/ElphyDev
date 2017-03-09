unit DXDGS1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DXClass, DIB, DXTexImg, DirectX,
  DXdraws,
  util1;

type

  TDXscreen = class(TCustomControl)
  private
    FAutoInitialize: Boolean;
    FAutoSize: Boolean;
    FCalledDoInitialize: Boolean;
    FCalledDoInitializeSurface: Boolean;
    FForm: TCustomForm;
    FNotifyEventList: TList;
    FInitialized: Boolean;
    FInitialized2: Boolean;
    FInternalInitialized: Boolean;
    FUpdating: Boolean;
    FSubClass: TControlSubClass;
    FNowOptions: TDXDrawOptions;
    FOptions: TDXDrawOptions;
    FOnFinalize: TNotifyEvent;
    FOnFinalizeSurface: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOnInitializeSurface: TNotifyEvent;
    FOnInitializing: TNotifyEvent;
    FOnRestoreSurface: TNotifyEvent;
    FOffNotifyRestore: Integer;
    { DirectDraw }
    FDXDrawDriver: TObject;
    FDriver: PGUID;
    FDriverGUID: TGUID;
    FDDraw: TDirectDraw;
    FDisplay: TDXDrawDisplay;
    FClipper: TDirectDrawClipper;
    FPalette: TDirectDrawPalette;
    FPrimary: TDirectDrawSurface;
    FSurface: TDirectDrawSurface;
    FSurfaceWidth: Integer;
    FSurfaceHeight: Integer;
    { Direct3D }
    FD3D: IDirect3D;
    FD3D2: IDirect3D2;
    FD3D3: IDirect3D3;
    FD3D7: IDirect3D7;
    FD3DDevice: IDirect3DDevice;
    FD3DDevice2: IDirect3DDevice2;
    FD3DDevice3: IDirect3DDevice3;
    FD3DDevice7: IDirect3DDevice7;
    FD3DRM: IDirect3DRM;
    FD3DRM2: IDirect3DRM2;
    FD3DRM3: IDirect3DRM3;
    FD3DRMDevice: IDirect3DRMDevice;
    FD3DRMDevice2: IDirect3DRMDevice2;
    FD3DRMDevice3: IDirect3DRMDevice3;
    FCamera: IDirect3DRMFrame;
    FScene: IDirect3DRMFrame;
    FViewport: IDirect3DRMViewport;
    FZBuffer: TDirectDrawSurface;
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    function GetCanDraw: Boolean;
    function GetCanPaletteAnimation: Boolean;
    function GetSurfaceHeight: Integer;
    function GetSurfaceWidth: Integer;
    procedure NotifyEventList(NotifyType: TDXDrawNotifyType);
    procedure SetAutoSize(Value: Boolean);
    procedure SetColorTable(const ColorTable: TRGBQuads);
    procedure SetCooperativeLevel;
    procedure SetDisplay(Value: TDXDrawDisplay);
    procedure SetDriver(Value: PGUID);
    procedure SetOptions(Value: TDXDrawOptions);
    procedure SetSurfaceHeight(Value: Integer);
    procedure SetSurfaceWidth(Value: Integer);
    function TryRestore: Boolean;
    procedure WMCreate(var Message: TMessage); message WM_CREATE;
  protected
    procedure DoFinalize; virtual;
    procedure DoFinalizeSurface; virtual;
    procedure DoInitialize; virtual;
    procedure DoInitializeSurface; virtual;
    procedure DoInitializing; virtual;
    procedure DoRestoreSurface; virtual;
    procedure Loaded; override;
    procedure Paint; override;
    function PaletteChanged(Foreground: Boolean): Boolean; override;
    procedure SetParent(AParent: TWinControl); override;
  public
    ColorTable: TRGBQuads;
    DefColorTable: TRGBQuads;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Finalize;
    procedure Flip;
    procedure Initialize;
    procedure Render;
    procedure Restore;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
    procedure UpdatePalette;
    procedure RegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
    procedure UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);

    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Camera: IDirect3DRMFrame read FCamera;
    property CanDraw: Boolean read GetCanDraw;
    property CanPaletteAnimation: Boolean read GetCanPaletteAnimation;
    property Clipper: TDirectDrawClipper read FClipper;
    property Color;
    property D3D: IDirect3D read FD3D;
    property D3D2: IDirect3D2 read FD3D2;
    property D3D3: IDirect3D3 read FD3D3;
    property D3D7: IDirect3D7 read FD3D7;
    property D3DDevice: IDirect3DDevice read FD3DDevice;
    property D3DDevice2: IDirect3DDevice2 read FD3DDevice2;
    property D3DDevice3: IDirect3DDevice3 read FD3DDevice3;
    property D3DDevice7: IDirect3DDevice7 read FD3DDevice7;
    property D3DRM: IDirect3DRM read FD3DRM;
    property D3DRM2: IDirect3DRM2 read FD3DRM2;
    property D3DRM3: IDirect3DRM3 read FD3DRM3;
    property D3DRMDevice: IDirect3DRMDevice read FD3DRMDevice;
    property D3DRMDevice2: IDirect3DRMDevice2 read FD3DRMDevice2;
    property D3DRMDevice3: IDirect3DRMDevice3 read FD3DRMDevice3;
    property DDraw: TDirectDraw read FDDraw;
    property Display: TDXDrawDisplay read FDisplay write SetDisplay;
    property Driver: PGUID read FDriver write SetDriver;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDXDrawOptions read FNowOptions;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnFinalizeSurface: TNotifyEvent read FOnFinalizeSurface write FOnFinalizeSurface;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property OnInitializeSurface: TNotifyEvent read FOnInitializeSurface write FOnInitializeSurface;
    property OnInitializing: TNotifyEvent read FOnInitializing write FOnInitializing;
    property OnRestoreSurface: TNotifyEvent read FOnRestoreSurface write FOnRestoreSurface;
    property Options: TDXDrawOptions read FOptions write SetOptions;
    property Palette: TDirectDrawPalette read FPalette;
    property Primary: TDirectDrawSurface read FPrimary;
    property Scene: IDirect3DRMFrame read FScene;
    property Surface: TDirectDrawSurface read FSurface;
    property SurfaceHeight: Integer read GetSurfaceHeight write SetSurfaceHeight default 480;
    property SurfaceWidth: Integer read GetSurfaceWidth write SetSurfaceWidth default 640;
    property Viewport: IDirect3DRMViewport read FViewport;
    property ZBuffer: TDirectDrawSurface read FZBuffer;
  end;


implementation

uses DXConsts, DXRender;

type
  {  TDXDrawDriver  }

  TDXDrawDriver = class
  private
    FDXDraw: TDXscreen;
    constructor Create(ADXDraw: TDXscreen); virtual;
    destructor Destroy; override;
    procedure Finalize; virtual;
    procedure Flip; virtual; abstract;
    procedure Initialize; virtual; abstract;
    procedure Initialize3D;
    function SetSize(AWidth, AHeight: Integer): Boolean; virtual;
    function Restore: Boolean;
  end;

  TDXDrawDriverBlt = class(TDXDrawDriver)
  private
    procedure Flip; override;
    procedure Initialize; override;
    procedure InitializeSurface;
    function SetSize(AWidth, AHeight: Integer): Boolean; override;
  end;

  TDXDrawDriverFlip = class(TDXDrawDriver)
  private
    procedure Flip; override;
    procedure Initialize; override;
  end;

{  TDXDrawDriver  }

type
  TInitializeDirect3DOption = (idoSelectDriver, idoOptimizeDisplayMode,
    idoHardware, idoRetainedMode, idoZBuffer);

  TInitializeDirect3DOptions = set of TInitializeDirect3DOption;

constructor TDXDrawDriver.Create(ADXDraw: TDXscreen);
var
  AOptions: TInitializeDirect3DOptions;
begin
  inherited Create;
  FDXDraw := ADXDraw;

  {  Driver selection and Display mode optimizationn }
  if FDXDraw.FOptions*[doFullScreen, doSystemMemory, do3D, doHardware]=
    [doFullScreen, do3D, doHardware] then
  begin
    AOptions := [];
    with FDXDraw do
    begin
      if doSelectDriver in Options then AOptions := AOptions + [idoSelectDriver];
      if not FDXDraw.Display.FixedBitCount then AOptions := AOptions + [idoOptimizeDisplayMode];

      if doHardware in Options then AOptions := AOptions + [idoHardware];
      if doRetainedMode in Options then AOptions := AOptions + [idoRetainedMode];
      if doZBuffer in Options then AOptions := AOptions + [idoZBuffer];
    end;

    {Direct3DInitializing_DXDraw(AOptions, FDXDraw);}
  end;

  if FDXDraw.Options*[doFullScreen, doHardware, doSystemMemory]=[doFullScreen, doHardware] then
    FDXDraw.FDDraw := TDirectDraw.CreateEx(PGUID(FDXDraw.FDriver), doDirectX7Mode in FDXDraw.Options)
  else
    FDXDraw.FDDraw := TDirectDraw.CreateEx(nil, doDirectX7Mode in FDXDraw.Options);
end;

procedure TDXDrawDriver.Initialize3D;
const
  DXDrawOptions3D = [doHardware, doRetainedMode, doSelectDriver, doZBuffer];
var
  AOptions: TInitializeDirect3DOptions;
begin
  AOptions := [];
  with FDXDraw do
  begin
    if doHardware in FOptions then AOptions := AOptions + [idoHardware];
    if doRetainedMode in FNowOptions then AOptions := AOptions + [idoRetainedMode];
    if doSelectDriver in FOptions then AOptions := AOptions + [idoSelectDriver];
    if doZBuffer in FOptions then AOptions := AOptions + [idoZBuffer];

    {
    if doDirectX7Mode in FOptions then
    begin
      InitializeDirect3D7(FSurface, FZBuffer, FD3D7, FD3DDevice7, AOptions);
    end else
    begin
      InitializeDirect3D(FSurface, FZBuffer, FD3D, FD3D2, FD3D3, FD3DDevice, FD3DDevice2, FD3DDevice3,
        FD3DRM, FD3DRM2, FD3DRM3, FD3DRMDevice, FD3DRMDevice2, FD3DRMDevice3, FViewport, FScene, FCamera, AOptions);
    end;
    }
    FNowOptions := FNowOptions - DXDrawOptions3D;
    if idoHardware in AOptions then FNowOptions := FNowOptions + [doHardware];
    if idoRetainedMode in AOptions then FNowOptions := FNowOptions + [doRetainedMode];
    if idoSelectDriver in AOptions then FNowOptions := FNowOptions + [doSelectDriver];
    if idoZBuffer in AOptions then FNowOptions := FNowOptions + [doZBuffer];
  end;
end;

destructor TDXDrawDriver.Destroy;
begin
  Finalize;
  FDXDraw.FDDraw.Free;
  inherited Destroy;
end;

procedure TDXDrawDriver.Finalize;
begin
  with FDXDraw do
  begin
    FViewport := nil;
    FCamera := nil;
    FScene := nil;

    FD3DRMDevice := nil;
    FD3DRMDevice2 := nil;
    FD3DRMDevice3 := nil;
    FD3DDevice := nil;
    FD3DDevice2 := nil;
    FD3DDevice3 := nil;
    FD3DDevice7 := nil;
    FD3D := nil;
    FD3D2 := nil;
    FD3D3 := nil;
    FD3D7 := nil;

    {FreeZBufferSurface(FSurface, FZBuffer);}

    FClipper.Free;  FClipper := nil;
    FPalette.Free;  FPalette := nil;
    FSurface.Free;  FSurface := nil;
    FPrimary.Free;  FPrimary := nil;

    FD3DRM3 := nil;
    FD3DRM2 := nil;
    FD3DRM := nil;
  end;
end;

function TDXDrawDriver.Restore: Boolean;
begin
  Result := FDXDraw.FPrimary.Restore and FDXDraw.FSurface.Restore;
  if Result then
  begin
    FDXDraw.FPrimary.Fill(0);
    FDXDraw.FSurface.Fill(0);
  end;
end;

function TDXDrawDriver.SetSize(AWidth, AHeight: Integer): Boolean;
begin
  Result := False;
end;

{  TDXDrawDriverBlt  }

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then
  begin
    dc := GetDC(0);
    GetSystemPaletteEntries(dc, 0, 256, Entries);
    ReleaseDC(0, dc);

    for i:=0 to 9 do
      Result[i] := Entries[i];

    for i:=256-10 to 255 do
      Result[i] := Entries[i];
  end;

  for i:=0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

procedure TDXDrawDriverBlt.Flip;
var
  pt: TPoint;
  Dest: TRect;
  DF: TDDBltFX;
begin
  pt := FDXDraw.ClientToScreen(Point(0, 0));

  if doStretch in FDXDraw.NowOptions then
  begin
    Dest := Bounds(pt.x, pt.y, FDXDraw.Width, FDXDraw.Height);
  end else
  begin
    if doCenter in FDXDraw.NowOptions then
    begin
      Inc(pt.x, (FDXDraw.Width-FDXDraw.FSurface.Width) div 2);
      Inc(pt.y, (FDXDraw.Height-FDXDraw.FSurface.Height) div 2);
    end;

    Dest := Bounds(pt.x, pt.y, FDXDraw.FSurface.Width, FDXDraw.FSurface.Height);
  end;

  if doWaitVBlank in FDXDraw.NowOptions then
    FDXDraw.FDDraw.DXResult := FDXDraw.FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);

  DF.dwsize := SizeOf(DF);
  DF.dwDDFX := 0;

  FDXDraw.FPrimary.Blt(Dest, FDXDraw.FSurface.ClientRect, DDBLT_WAIT, df, FDXDraw.FSurface);
end;

procedure TDXDrawDriverBlt.Initialize;
const
  PrimaryDesc: TDDSurfaceDesc = (
      dwSize: SizeOf(PrimaryDesc);
      dwFlags: DDSD_CAPS;
      ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE)
      );
var
  Entries: TPaletteEntries;
  PaletteCaps: Integer;
begin
  {  Surface making  }
  FDXDraw.FPrimary := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if not FDXDraw.FPrimary.CreateSurface(PrimaryDesc) then
    raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawPrimarySurface]);

  FDXDraw.FSurface := TDirectDrawSurface.Create(FDXDraw.FDDraw);

  {  Clipper making  }
  FDXDraw.FClipper := TDirectDrawClipper.Create(FDXDraw.FDDraw);
  FDXDraw.FClipper.Handle := FDXDraw.Handle;
  FDXDraw.FPrimary.Clipper := FDXDraw.FClipper;

  {  Palette making  }
  PaletteCaps := DDPCAPS_8BIT or DDPCAPS_INITIALIZE;
  if doAllowPalette256 in FDXDraw.NowOptions then
    PaletteCaps := PaletteCaps or DDPCAPS_ALLOW256;

  FDXDraw.FPalette := TDirectDrawPalette.Create(FDXDraw.FDDraw);
  Entries := TDXDrawRGBQuadsToPaletteEntries(FDXDraw.ColorTable,
    doAllowPalette256 in FDXDraw.NowOptions);
  FDXDraw.FPalette.CreatePalette(PaletteCaps, Entries);

  FDXDraw.FPrimary.Palette := FDXDraw.Palette;

  InitializeSurface;
end;

procedure TDXDrawDriverBlt.InitializeSurface;
var
  ddsd: TDDSurfaceDesc;
begin
  FDXDraw.FSurface.IDDSurface := nil;

  {  Surface making  }
  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];

  FillChar(ddsd, SizeOf(ddsd), 0);
  with ddsd do
  begin
    dwSize := SizeOf(ddsd);
    dwFlags := DDSD_WIDTH or DDSD_HEIGHT or DDSD_CAPS;
    dwWidth := Max(FDXDraw.FSurfaceWidth, 1);
    dwHeight := Max(FDXDraw.FSurfaceHeight, 1);
    ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
    if doSystemMemory in FDXDraw.Options then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    if do3D in FDXDraw.FNowOptions then
      ddsCaps.dwCaps := ddsCaps.dwCaps or DDSCAPS_3DDEVICE;
  end;

  if not FDXDraw.FSurface.CreateSurface(ddsd) then
  begin
    ddsd.ddsCaps.dwCaps := ddsd.ddsCaps.dwCaps or DDSCAPS_SYSTEMMEMORY;
    if not FDXDraw.FSurface.CreateSurface(ddsd) then
      raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawSurface]);
  end;

  if FDXDraw.FSurface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_VIDEOMEMORY=0 then
    FDXDraw.FNowOptions := FDXDraw.FNowOptions + [doSystemMemory];

  FDXDraw.FSurface.Palette := FDXDraw.Palette;
  FDXDraw.FSurface.Fill(0);

  if do3D in FDXDraw.FNowOptions then
    Initialize3D;
end;

function TDXDrawDriverBlt.SetSize(AWidth, AHeight: Integer): Boolean;
begin
  Result := True;

  FDXDraw.FSurfaceWidth := Max(AWidth, 1);
  FDXDraw.FSurfaceHeight := Max(AHeight, 1);

  Inc(FDXDraw.FOffNotifyRestore);
  try
    FDXDraw.NotifyEventList(dxntFinalizeSurface);

    if FDXDraw.FCalledDoInitializeSurface then
    begin
      FDXDraw.FCalledDoInitializeSurface := False;
      FDXDraw.DoFinalizeSurface;
    end;                     
    
    InitializeSurface;

    FDXDraw.NotifyEventList(dxntInitializeSurface);
    FDXDraw.FCalledDoInitializeSurface := True; FDXDraw.DoInitializeSurface;
  finally
    Dec(FDXDraw.FOffNotifyRestore);
  end;
end;

{  TDXDrawDriverFlip  }

procedure TDXDrawDriverFlip.Flip;
begin                                        
  if (FDXDraw.FForm<>nil) and (FDXDraw.FForm.Active) then
    FDXDraw.FPrimary.DXResult := FDXDraw.FPrimary.ISurface.Flip(nil, DDFLIP_WAIT)
  else
    FDXDraw.FPrimary.DXResult := 0;
end;

procedure TDXDrawDriverFlip.Initialize;
const
  DefPrimaryDesc: TDDSurfaceDesc = (
      dwSize: SizeOf(DefPrimaryDesc);
      dwFlags: DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
      dwBackBufferCount: 1;
      ddsCaps: (dwCaps: DDSCAPS_PRIMARYSURFACE or DDSCAPS_FLIP or DDSCAPS_COMPLEX)
      );
  BackBufferCaps: TDDSCaps = (dwCaps: DDSCAPS_BACKBUFFER);
var
  PrimaryDesc: TDDSurfaceDesc;
  PaletteCaps: Integer;
  Entries: TPaletteEntries;
  DDSurface: IDirectDrawSurface;
begin
  {  Surface making  }
  PrimaryDesc := DefPrimaryDesc;

  if do3D in FDXDraw.FNowOptions then
    PrimaryDesc.ddsCaps.dwCaps := PrimaryDesc.ddsCaps.dwCaps or DDSCAPS_3DDEVICE;

  FDXDraw.FPrimary := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if not FDXDraw.FPrimary.CreateSurface(PrimaryDesc) then
    raise EDXDrawError.CreateFmt(SCannotMade, [SDirectDrawPrimarySurface]);

  FDXDraw.FSurface := TDirectDrawSurface.Create(FDXDraw.FDDraw);
  if FDXDraw.FPrimary.ISurface.GetAttachedSurface(BackBufferCaps, DDSurface)=DD_OK then
    FDXDraw.FSurface.IDDSurface := DDSurface;

  FDXDraw.FNowOptions := FDXDraw.FNowOptions - [doSystemMemory];
  if FDXDraw.FSurface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_SYSTEMMEMORY<>0 then
    FDXDraw.FNowOptions := FDXDraw.FNowOptions + [doSystemMemory];

  {  Clipper making of dummy  }
  FDXDraw.FClipper := TDirectDrawClipper.Create(FDXDraw.FDDraw);

  {  Palette making  }
  PaletteCaps := DDPCAPS_8BIT;
  if doAllowPalette256 in FDXDraw.Options then
    PaletteCaps := PaletteCaps or DDPCAPS_ALLOW256;

  FDXDraw.FPalette := TDirectDrawPalette.Create(FDXDraw.FDDraw);
  Entries := TDXDrawRGBQuadsToPaletteEntries(FDXDraw.ColorTable,
    doAllowPalette256 in FDXDraw.NowOptions);
  FDXDraw.FPalette.CreatePalette(PaletteCaps, Entries);
                          
  FDXDraw.FPrimary.Palette := FDXDraw.Palette;
  FDXDraw.FSurface.Palette := FDXDraw.Palette;

  if do3D in FDXDraw.FNowOptions then
    Initialize3D;
end;

constructor TDXscreen.Create(AOwner: TComponent);
var
  Entries: TPaletteEntries;
  dc: THandle;
begin
  FNotifyEventList := TList.Create;
  inherited Create(AOwner);
  FAutoInitialize := True;
  FDisplay := TDXDrawDisplay.Create(Self);

  Options := [doAllowReboot, doWaitVBlank, doCenter, doDirectX7Mode, doHardware, doSelectDriver];

  FAutoSize := True;

  dc := GetDC(0);
  GetSystemPaletteEntries(dc, 0, 256, Entries);
  ReleaseDC(0, dc);

  ColorTable := PaletteEntriesToRGBQuads(Entries);
  DefColorTable := ColorTable;

  Width := 100;
  Height := 100;
  ParentColor := False;
  Color := clBtnFace;
end;

destructor TDXscreen.Destroy;
begin
  Finalize;
  NotifyEventList(dxntDestroying);
  FDisplay.Free;
  FSubClass.Free; FSubClass := nil;
  FNotifyEventList.Free;
  inherited Destroy;
end;

class function TDXscreen.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectDrawDrivers;
end;

type
  PDXDrawNotifyEvent = ^TDXDrawNotifyEvent;

procedure TDXscreen.RegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
begin
  UnRegisterNotifyEvent(NotifyEvent);

  New(Event);
  Event^ := NotifyEvent;
  FNotifyEventList.Add(Event);

  NotifyEvent(Self, dxntSetSurfaceSize);

  if Initialized then
  begin
    NotifyEvent(Self, dxntInitialize);
    if FCalledDoInitializeSurface then
      NotifyEvent(Self, dxntInitializeSurface);
    if FOffNotifyRestore=0 then
      NotifyEvent(Self, dxntRestore);
  end;
end;

procedure TDXscreen.UnRegisterNotifyEvent(NotifyEvent: TDXDrawNotifyEvent);
var
  Event: PDXDrawNotifyEvent;
  i: Integer;
begin
  for i:=0 to FNotifyEventList.Count-1 do
  begin
    Event := FNotifyEventList[i];
    if (TMethod(Event^).Code = TMethod(NotifyEvent).Code) and
      (TMethod(Event^).Data = TMethod(NotifyEvent).Data) then
    begin
      FreeMem(Event);
      FNotifyEventList.Delete(i);

      if FCalledDoInitializeSurface then
        NotifyEvent(Self, dxntFinalizeSurface);
      if Initialized then
        NotifyEvent(Self, dxntFinalize);

      Break;
    end;
  end;
end;

procedure TDXscreen.NotifyEventList(NotifyType: TDXDrawNotifyType);
var
  i: Integer;
begin
  for i:=FNotifyEventList.Count-1 downto 0 do
    PDXDrawNotifyEvent(FNotifyEventList[i])^(Self, NotifyType);
end;

procedure TDXscreen.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);

  procedure FlipToGDISurface;
  begin
    if Initialized and (FNowOptions*[doFullScreen, doFlip]=[doFullScreen, doFlip]) then
      DDraw.IDraw.FlipToGDISurface;
  end;

begin
  case Message.Msg of
    {CM_ACTIVATE:
        begin
          DefWindowProc(Message);
          if AutoInitialize and (not FInitalized2) then
            Initialize;
          Exit;
        end;   }
    WM_WINDOWPOSCHANGED:
        begin
          if TWMWindowPosChanged(Message).WindowPos^.flags and SWP_SHOWWINDOW<>0 then
          begin
            DefWindowProc(Message);
            if AutoInitialize and (not FInitialized2) then
              Initialize;
            Exit;
          end;
        end;
    WM_ACTIVATE:
        begin
          if TWMActivate(Message).Active=WA_INACTIVE then
            FlipToGDISurface;
        end;
    WM_INITMENU:
        begin
          FlipToGDISurface;
        end;
    WM_DESTROY:
        begin
          Finalize;
        end;
  end;      
  DefWindowProc(Message);
end;

procedure TDXscreen.DoFinalize;
begin
  if Assigned(FOnFinalize) then FOnFinalize(Self);
end;

procedure TDXscreen.DoFinalizeSurface;
begin
  if Assigned(FOnFinalizeSurface) then FOnFinalizeSurface(Self);
end;

procedure TDXscreen.DoInitialize;
begin
  if Assigned(FOnInitialize) then FOnInitialize(Self);
end;

procedure TDXscreen.DoInitializeSurface;
begin
  if Assigned(FOnInitializeSurface) then FOnInitializeSurface(Self);
end;

procedure TDXscreen.DoInitializing;
begin
  if Assigned(FOnInitializing) then FOnInitializing(Self);
end;

procedure TDXscreen.DoRestoreSurface;
begin
  if Assigned(FOnRestoreSurface) then FOnRestoreSurface(Self);
end;

procedure TDXscreen.Finalize;
begin
  if FInternalInitialized then
  begin
    FSurfaceWidth := SurfaceWidth;
    FSurfaceHeight := SurfaceHeight;

    FDisplay.FModes.Clear;

    FUpdating := True;
    try
      try
        try
          if FCalledDoInitializeSurface then
          begin
            FCalledDoInitializeSurface := False;
            DoFinalizeSurface;
          end;
        finally
          NotifyEventList(dxntFinalizeSurface);
        end;
      finally
        try
          if FCalledDoInitialize then
          begin
            FCalledDoInitialize := False;
            DoFinalize;
          end;
        finally
          NotifyEventList(dxntFinalize);
        end;
      end;
    finally
      FInternalInitialized := False;
      FInitialized := False;

      SetOptions(FOptions);

      FDXDrawDriver.Free; FDXDrawDriver := nil;
      FUpdating := False;
    end;
  end;
end;

procedure TDXscreen.Flip;
begin
  if Initialized and (not FUpdating) then
  begin
    if TryRestore then
      TDXDrawDriver(FDXDrawDriver).Flip;
  end;
end;

function TDXscreen.GetCanDraw: Boolean;
begin
  Result := Initialized and (not FUpdating) and (Surface.IDDSurface<>nil) and
    TryRestore;
end;

function TDXscreen.GetCanPaletteAnimation: Boolean;
begin
  Result := Initialized and (not FUpdating) and (doFullScreen in FNowOptions)
    and (DDraw.DisplayMode.ddpfPixelFormat.dwRGBBitCount<=8);
end;

function TDXscreen.GetSurfaceHeight: Integer;
begin
  if Surface.IDDSurface<>nil then
    Result := Surface.Height
  else
    Result := FSurfaceHeight;
end;

function TDXscreen.GetSurfaceWidth: Integer;
begin
  if Surface.IDDSurface<>nil then
    Result := Surface.Width
  else
    Result := FSurfaceWidth;
end;

procedure TDXscreen.Loaded;
begin
  inherited Loaded;

  if AutoSize then
  begin
    FSurfaceWidth := Width;
    FSurfaceHeight := Height;
  end;

  NotifyEventList(dxntSetSurfaceSize);

  if FAutoInitialize and (not (csDesigning in ComponentState)) then
  begin                                       
    if {(not (doFullScreen in FOptions)) or }(FSubClass=nil) then
      Initialize;
  end;
end;

procedure TDXscreen.Initialize;
begin
  FInitialized2 := True;

  Finalize;

  if FForm=nil then
    raise EDXDrawError.Create(SNoForm);

  try
    DoInitializing;

    {  Initialization.  }
    FUpdating := True;
    try
      FInternalInitialized := True;

      NotifyEventList(dxntInitializing);

      {  DirectDraw initialization.  }
      if doFlip in FNowOptions then
        FDXDrawDriver := TDXDrawDriverFlip.Create(Self)
      else
        FDXDrawDriver := TDXDrawDriverBlt.Create(Self);

      {  Window handle setting.  }
      SetCooperativeLevel;

      {  Set display mode.  }
      if doFullScreen in FNowOptions then
      begin
        if not Display.DynSetSize(Display.Width, Display.Height, Display.BitCount) then
          raise EDXDrawError.CreateFmt(SDisplaymodeChange, [Display.Width, Display.Height, Display.BitCount]);
      end;

      {  Resource initialization.  }
      if AutoSize then
      begin
        FSurfaceWidth := Width;
        FSurfaceHeight := Height;
      end;

      TDXDrawDriver(FDXDrawDriver).Initialize;
    finally
      FUpdating := False;
    end;
  except
    Finalize;
    raise;
  end;

  FInitialized := True;

  Inc(FOffNotifyRestore);
  try
    NotifyEventList(dxntSetSurfaceSize);
    NotifyEventList(dxntInitialize);
    FCalledDoInitialize := True; DoInitialize;

    NotifyEventList(dxntInitializeSurface);
    FCalledDoInitializeSurface := True; DoInitializeSurface;
  finally
    Dec(FOffNotifyRestore);
  end;

  Restore;
end;

procedure TDXscreen.Paint;
var
  Old: TDXDrawOptions;
  w, h: Integer;
  s: AnsiString;
begin
  inherited Paint;
  if (csDesigning in ComponentState) then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Style := psDash;
    Canvas.Rectangle(0, 0, Width, Height);

    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clGray;
    Canvas.MoveTo(0, 0);
    Canvas.LineTo(Width, Height);

    Canvas.MoveTo(0, Height);
    Canvas.LineTo(Width, 0);

    s := Format('(%s)', [ClassName]);

    w := Canvas.TextWidth(s);
    h := Canvas.TextHeight(s);

    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clBtnFace;
    Canvas.TextOut(Width div 2-w div 2, Height div 2-h div 2, s);
  end else
  begin
    Old := FNowOptions;
    try
      FNowOptions := FNowOptions - [doWaitVBlank];
      Flip;
    finally         
      FNowOptions := Old;
    end;    
    if (Parent<>nil) and (Initialized) and (Surface.SurfaceDesc.ddscaps.dwCaps and DDSCAPS_VIDEOMEMORY<>0) then
      Parent.Invalidate;                                                                                
  end;
end;

function TDXscreen.PaletteChanged(Foreground: Boolean): Boolean;
begin
  if Foreground then
  begin
    Restore;
    Result := True;
  end else
    Result := False;
end;

procedure TDXscreen.Render;
begin
  if FInitialized and (do3D in FNowOptions) and (doRetainedMode in FNowOptions) then
  begin
    asm FInit end;
    FViewport.Clear;
    FViewport.Render(FScene);
    FD3DRMDevice.Update;
    asm FInit end;
  end;
end;

procedure TDXscreen.Restore;
begin
  if Initialized and (not FUpdating) then
  begin
    FUpdating := True;
    try
      if TDXDrawDriver(FDXDrawDriver).Restore then
      begin
        Primary.Palette := Palette;
        Surface.Palette := Palette;

        SetColorTable(DefColorTable);
        NotifyEventList(dxntRestore);
        DoRestoreSurface;
        SetColorTable(ColorTable);
      end;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TDXscreen.SetAutoSize(Value: Boolean);
begin
  if FAutoSize<>Value then
  begin
    FAutoSize := Value;
    if FAutoSize then
      SetSize(Width, Height);
  end;
end;

procedure TDXscreen.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if FAutoSize and (not FUpdating) then
    SetSize(AWidth, AHeight);
end;

procedure TDXscreen.SetColorTable(const ColorTable: TRGBQuads);
var
  Entries: TPaletteEntries;
begin
  if Initialized and (Palette<>nil) then
  begin
    Entries := TDXDrawRGBQuadsToPaletteEntries(ColorTable,
      doAllowPalette256 in FNowOptions);
    Palette.SetEntries(0, 256, Entries);
  end;
end;

procedure TDXscreen.SetCooperativeLevel;
var
  Flags: Integer;
  Control: TWinControl;
begin
  Control := FForm;
  if Control=nil then
    Control := Self;

  if doFullScreen in FNowOptions then
  begin
    Flags := DDSCL_FULLSCREEN or DDSCL_EXCLUSIVE or DDSCL_ALLOWMODEX;
    if doNoWindowChange in FNowOptions then
      Flags := Flags or DDSCL_NOWINDOWCHANGES;
    if doAllowReboot in FNowOptions then
      Flags := Flags or DDSCL_ALLOWREBOOT;
  end else
    Flags := DDSCL_NORMAL;

  DDraw.DXResult := DDraw.IDraw.SetCooperativeLevel(Control.Handle, Flags);
end;

procedure TDXscreen.SetDisplay(Value: TDXDrawDisplay);
begin
  FDisplay.Assign(Value);
end;

procedure TDXscreen.SetDriver(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then
  begin
    FDriverGUID := Value^;
    FDriver := @FDriverGUID;
  end else
    FDriver := Value;
end;

procedure TDXscreen.SetOptions(Value: TDXDrawOptions);
const
  InitOptions = [doDirectX7Mode, doFullScreen, doNoWindowChange, doAllowReboot,
    doAllowPalette256, doSystemMemory, doFlip, do3D,
    doRetainedMode, doHardware, doSelectDriver, doZBuffer];
var
  OldOptions: TDXDrawOptions;
begin
  FOptions := Value;

  if Initialized then
  begin
    OldOptions := FNowOptions;
    FNowOptions := FNowOptions*InitOptions+(FOptions-InitOptions);

    if not (do3D in FNowOptions) then
      FNowOptions := FNowOptions - [doHardware, doRetainedMode, doSelectDriver, doZBuffer];
  end else
  begin
    FNowOptions := FOptions;

    if not (doFullScreen in FNowOptions) then
      FNowOptions := FNowOptions - [doNoWindowChange, doAllowReBoot, doAllowPalette256, doFlip];

    if not (do3D in FNowOptions) then
      FNowOptions := FNowOptions - [doDirectX7Mode, doRetainedMode, doHardware, doSelectDriver, doZBuffer];

    if doSystemMemory in FNowOptions then
      FNowOptions := FNowOptions - [doFlip];

    if doDirectX7Mode in FNowOptions then
      FNowOptions := FNowOptions - [doRetainedMode];

    FNowOptions := FNowOptions - [doHardware];
  end;
end;

procedure TDXscreen.SetParent(AParent: TWinControl);
var
  Control: TWinControl;
begin
  inherited SetParent(AParent);

  FForm := nil;
  FSubClass.Free; FSubClass := nil;

  if not (csDesigning in ComponentState) then
  begin
    Control := Parent;
    while (Control<>nil) and (not (Control is TCustomForm)) do
      Control := Control.Parent;
    if Control<>nil then
    begin
      FForm := TCustomForm(Control);
      FSubClass := TControlSubClass.Create(Control, FormWndProc);
    end;
  end;
end;

procedure TDXscreen.SetSize(ASurfaceWidth, ASurfaceHeight: Integer);
begin
  if ((ASurfaceWidth<>SurfaceWidth) or (ASurfaceHeight<>SurfaceHeight)) and
    (not FUpdating) then
  begin
    if Initialized then
    begin
      try
        if not TDXDrawDriver(FDXDrawDriver).SetSize(ASurfaceWidth, ASurfaceHeight) then
          Exit;
      except
        Finalize;
        raise;
      end;
    end else
    begin
      FSurfaceWidth := ASurfaceWidth;
      FSurfaceHeight := ASurfaceHeight;
    end;

    NotifyEventList(dxntSetSurfaceSize);
  end;
end;

procedure TDXscreen.SetSurfaceHeight(Value: Integer);
begin
  if ComponentState*[csReading, csLoading]=[] then
    SetSize(SurfaceWidth, Value)
  else
    FSurfaceHeight := Value;
end;

procedure TDXscreen.SetSurfaceWidth(Value: Integer);
begin
  if ComponentState*[csReading, csLoading]=[] then
    SetSize(Value, SurfaceHeight)
  else
    FSurfaceWidth := Value;
end;

function TDXscreen.TryRestore: Boolean;
begin
  Result := False;

  if Initialized and (not FUpdating) and (Primary.IDDSurface<>nil) then
  begin
    if (Primary.ISurface.IsLost=DDERR_SURFACELOST) or
      (Surface.ISurface.IsLost=DDERR_SURFACELOST) then
    begin
      Restore;
      Result := (Primary.ISurface.IsLost=DD_OK) and (Surface.ISurface.IsLost=DD_OK);
    end else
      Result := True;
  end;
end;

procedure TDXscreen.UpdatePalette;
begin
  if Initialized and (doWaitVBlank in FNowOptions) then
  begin
    if FDDraw.FDriverCaps.dwPalCaps and DDPCAPS_VSYNC=0 then
      FDDraw.IDraw.WaitForVerticalBlank(DDWAITVB_BLOCKBEGIN, 0);
  end; 

  SetColorTable(ColorTable);
end;

procedure TDXscreen.WMCreate(var Message: TMessage);
begin
  inherited;
  if Initialized and (not FUpdating) then
  begin
    if Clipper<>nil then
      Clipper.Handle := Handle;
    SetCooperativeLevel;
  end;
end;



end.

end.
