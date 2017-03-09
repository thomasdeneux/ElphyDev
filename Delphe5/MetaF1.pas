unit MetaF1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Graphics;

type
  TmetaFile = class;

  TMetafileCanvas = class(TCanvas)
  private
    FMetafile: TMetafile;
  public
    constructor Create(AMetafile: TMetafile; ReferenceDevice: HDC);
    constructor CreateWithComment(AMetafile: TMetafile; ReferenceDevice: HDC;
      const CreatedBy, Description: AnsiString);
    destructor Destroy; override;
  end;

  TSharedImage = class
  private
    FRefCount: Integer;
  protected
    procedure Reference;
    procedure Release;
    procedure FreeHandle; virtual; abstract;
    property RefCount: Integer read FRefCount;
  end;

  TMetafileImage = class(TSharedImage)
  private
    FHandle: HENHMETAFILE;
    FWidth: Integer;      // FWidth and FHeight are in 0.01 mm logical pixels
    FHeight: Integer;     // These are converted to device pixels in TMetafile
    FPalette: HPALETTE;
    FInch: Word;          // Used only when writing WMF files.
    FTempWidth: Integer;  // FTempWidth and FTempHeight are in device pixels
    FTempHeight: Integer; // Used only when width/height are set when FHandle = 0
  protected
    procedure FreeHandle; override;
  public
    destructor Destroy; override;
  end;

  TMetafile = class(TGraphic)
  private
    FImage: TMetafileImage;
    FEnhanced: Boolean;
    function GetAuthor: AnsiString;
    function GetDesc: AnsiString;
    function GetHandle: HENHMETAFILE;
    function GetInch: Word;
    function GetMMHeight: Integer;
    function GetMMWidth: Integer;
    procedure NewImage;
    procedure SetHandle(Value: HENHMETAFILE);
    procedure SetInch(Value: Word);
    procedure SetMMHeight(Value: Integer);
    procedure SetMMWidth(Value: Integer);
    procedure UniqueImage;
  protected
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetPalette: HPALETTE; override;
    function GetWidth: Integer; override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    procedure ReadData(Stream: TStream); override;

    procedure SetHeight(Value: Integer); override;
    procedure SetTransparent(Value: Boolean); override;
    procedure SetWidth(Value: Integer); override;
    function  TestEMF(Stream: TStream): Boolean;
    procedure WriteData(Stream: TStream); override;
    procedure WriteEMFStream(Stream: TStream);
    procedure WriteWMFStream(Stream: TStream);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    function HandleAllocated: Boolean;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const Filename: AnsiString); override;
    procedure SaveToStream(Stream: TStream); override;
//    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
//      APalette: HPALETTE); override;
//    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
//      var APalette: HPALETTE); override;
    procedure Assign(Source: TPersistent); override;
    function ReleaseHandle: HENHMETAFILE;
    property CreatedBy: AnsiString read GetAuthor;
    property Description: AnsiString read GetDesc;
    property Enhanced: Boolean read FEnhanced write FEnhanced default True;
    property Handle: HENHMETAFILE read GetHandle write SetHandle;
    property MMWidth: Integer read GetMMWidth write SetMMWidth;
    property MMHeight: Integer read GetMMHeight write SetMMHeight;
    property Inch: Word read GetInch write SetInch;
  end;


implementation

const
  csAllValid = [csHandleValid..csBrushValid];

var
  ScreenLogPixels: Integer;
  StockPen: HPEN;
  StockBrush: HBRUSH;
  StockFont: HFONT;
  StockIcon: HICON;
  BitmapImageLock: TRTLCriticalSection;
  CounterLock: TRTLCriticalSection;

{ Exception routines }

procedure InvalidOperation(Str: PResStringRec);
begin
  raise EInvalidGraphicOperation.CreateRes(Str);
end;

procedure InvalidGraphic(Str: PResStringRec);
begin
  raise EInvalidGraphic.CreateRes(Str);
end;

procedure InvalidBitmap;
begin
end;

procedure InvalidIcon;
begin
end;

procedure InvalidMetafile;
begin
  //InvalidGraphic(@SInvalidMetafile);
end;

procedure OutOfResources;
begin
  raise EOutOfResources.Create('Out of resources');
end;

procedure GDIError;
var
  ErrorCode: Integer;
  Buf: array [Byte] of Char;
begin
  ErrorCode := GetLastError;
  if (ErrorCode <> 0) and (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil,
    ErrorCode, LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil) <> 0) then
    raise EOutOfResources.Create(Buf)
  else
    OutOfResources;
end;

function GDICheck(Value: Integer): Integer;
begin
  if Value = 0 then GDIError;
  Result := Value;
end;

{ TSharedImage }

procedure TSharedImage.Reference;
begin
  Inc(FRefCount);
end;

procedure TSharedImage.Release;
begin
  if Pointer(Self) <> nil then
  begin
    Dec(FRefCount);
    if FRefCount = 0 then
    begin
      FreeHandle;
      Free;
    end;
  end;
end;


{ TMetafileImage }

destructor TMetafileImage.Destroy;
begin
  if FHandle <> 0 then DeleteEnhMetafile(FHandle);
//  InternalDeletePalette(FPalette);
  inherited Destroy;
end;

procedure TMetafileImage.FreeHandle;
begin
end;


{ TMetafileCanvas }

constructor TMetafileCanvas.Create(AMetafile: TMetafile; ReferenceDevice: HDC);
begin
  CreateWithComment(AMetafile, ReferenceDevice, AMetafile.CreatedBy,
    AMetafile.Description);
end;

constructor TMetafileCanvas.CreateWithComment(AMetafile : TMetafile;
  ReferenceDevice: HDC; const CreatedBy, Description: AnsiString);
var
  RefDC: HDC;
  R: TRect;
  Temp: HDC;
  P: Pansichar;
begin
  inherited Create;
  FMetafile := AMetafile;
  RefDC := ReferenceDevice;
  if ReferenceDevice = 0 then RefDC := GetDC(0);
  try
    if FMetafile.MMWidth = 0 then
      if FMetafile.Width = 0 then
        FMetafile.MMWidth := GetDeviceCaps(RefDC, HORZSIZE)*100
      else
        FMetafile.MMWidth := MulDiv(FMetafile.Width,
          GetDeviceCaps(RefDC, HORZSIZE)*100, GetDeviceCaps(RefDC, HORZRES));
    if FMetafile.MMHeight = 0 then
      if FMetafile.Height = 0 then
        FMetafile.MMHeight := GetDeviceCaps(RefDC, VERTSIZE)*100
      else
        FMetafile.MMHeight := MulDiv(FMetafile.Height,
          GetDeviceCaps(RefDC, VERTSIZE)*100, GetDeviceCaps(RefDC, VERTRES));
    R := Rect(0,0,FMetafile.MMWidth,FMetafile.MMHeight);
    if (Length(CreatedBy) > 0) or (Length(Description) > 0) then
      P := Pansichar(CreatedBy+#0+Description+#0#0)
    else
      P := nil;
    Temp := CreateEnhMetafileA(RefDC, nil, @R, P);
//    if Temp = 0 then GDIError;
    Handle := Temp;
  finally
    if ReferenceDevice = 0 then ReleaseDC(0, RefDC);
  end;
end;

destructor TMetafileCanvas.Destroy;
var
  Temp: HDC;
begin
  Temp := Handle;
  Handle := 0;
  FMetafile.Handle := CloseEnhMetafile(Temp);
  inherited Destroy;
end;

{ TMetafile }

constructor TMetafile.Create;
begin
  inherited Create;
  FEnhanced := True;
//  FTransparent := True;
  Assign(nil);
end;

destructor TMetafile.Destroy;
begin
  FImage.Release;
  inherited Destroy;
end;

procedure TMetafile.Assign(Source: TPersistent);
var
  Pal: HPalette;
begin
  if (Source = nil) or (Source is TMetafile) then
  begin
    Pal := 0;
    if FImage <> nil then
    begin
      Pal := FImage.FPalette;
      FImage.Release;
    end;
    if Assigned(Source) then
    begin
      FImage := TMetafile(Source).FImage;
      FEnhanced := TMetafile(Source).Enhanced;
    end
    else
    begin
      FImage := TMetafileImage.Create;
      FEnhanced := True;
    end;
    FImage.Reference;
    PaletteModified := (Pal <> Palette) and (Palette <> 0);
    Changed(Self);
  end
  else
    inherited Assign(Source);
end;

procedure TMetafile.Clear;
begin
  NewImage;
end;

procedure TMetafile.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  MetaPal, OldPal: HPALETTE;
  R: TRect;
begin
  if FImage = nil then Exit;
  MetaPal := Palette;
  OldPal := 0;
  if MetaPal <> 0 then
  begin
    OldPal := SelectPalette(ACanvas.Handle, MetaPal, True);
    RealizePalette(ACanvas.Handle);
  end;
  R := Rect;
  Dec(R.Right);  // Metafile rect includes right and bottom coords
  Dec(R.Bottom);
  PlayEnhMetaFile(ACanvas.Handle, FImage.FHandle, R);
  if MetaPal <> 0 then
    SelectPalette(ACanvas.Handle, OldPal, True);
end;

function TMetafile.GetAuthor: AnsiString;
var
  Temp: Integer;
begin
  Result := '';
  if (FImage = nil) or (FImage.FHandle = 0) then Exit;
  Temp := GetEnhMetafileDescription(FImage.FHandle, 0, nil);
  if Temp <= 0 then Exit;
  SetLength(Result, Temp);
  GetEnhMetafileDescriptionA(FImage.FHandle, Temp, Pansichar(Result));
  SetLength(Result, StrLen(Pansichar(Result)));
end;

function TMetafile.GetDesc: AnsiString;
var
  Temp: Integer;
begin
  Result := '';
  if (FImage = nil) or (FImage.FHandle = 0) then Exit;
  Temp := GetEnhMetafileDescription(FImage.FHandle, 0, nil);
  if Temp <= 0 then Exit;
  SetLength(Result, Temp);
  GetEnhMetafileDescriptionA(FImage.FHandle, Temp, Pansichar(Result));
  Delete(Result, 1, StrLen(Pansichar(Result))+1);
  SetLength(Result, StrLen(Pansichar(Result)));
end;

function TMetafile.GetEmpty: boolean;
begin
  Result := FImage = nil;
end;

function TMetafile.GetHandle: HENHMETAFILE;
begin
  if Assigned(FImage) then
    Result := FImage.FHandle
  else
    Result := 0;
end;

function TMetaFile.HandleAllocated: Boolean;
begin
  Result := Assigned(FImage) and (FImage.FHandle <> 0);
end;

const
  HundredthMMPerInch = 2540;

function TMetafile.GetHeight: Integer;
var
  EMFHeader: TEnhMetaHeader;
begin
  if FImage = nil then NewImage;
  with FImage do
   if FInch = 0 then
     if FHandle = 0 then
       Result := FTempHeight
     else
     begin               { convert 0.01mm units to referenceDC device pixels }
       GetEnhMetaFileHeader(FHandle, Sizeof(EMFHeader), @EMFHeader);
       Result := MulDiv(FHeight,                     { metafile height in 0.01mm }
         EMFHeader.szlDevice.cy,                      { device height in pixels }
         EMFHeader.szlMillimeters.cy*100);            { device height in mm }
     end
   else          { for WMF files, convert to font dpi based device pixels }
     Result := MulDiv(FHeight, ScreenLogPixels, HundredthMMPerInch);
end;

function TMetafile.GetInch: Word;
begin
  Result := 0;
  if FImage <> nil then Result := FImage.FInch;
end;

function TMetafile.GetMMHeight: Integer;
begin
  if FImage = nil then NewImage;
  Result := FImage.FHeight;
end;

function TMetafile.GetMMWidth: Integer;
begin
  if FImage = nil then NewImage;
  Result := FImage.FWidth;
end;

function TMetafile.GetPalette: HPALETTE;
begin
  Result := 0;
end;

function TMetafile.GetWidth: Integer;
var
  EMFHeader: TEnhMetaHeader;
begin
  if FImage = nil then NewImage;
  with FImage do
    if FInch = 0 then
      if FHandle = 0 then
        Result := FTempWidth
      else
      begin     { convert 0.01mm units to referenceDC device pixels }
        GetEnhMetaFileHeader(FHandle, Sizeof(EMFHeader), @EMFHeader);
        Result := MulDiv(FWidth,                      { metafile width in 0.01mm }
          EMFHeader.szlDevice.cx,                      { device width in pixels }
          EMFHeader.szlMillimeters.cx*100);            { device width in 0.01mm }
      end
    else      { for WMF files, convert to font dpi based device pixels }
      Result := MulDiv(FWidth, ScreenLogPixels, HundredthMMPerInch);
end;

procedure TMetafile.LoadFromStream(Stream: TStream);
begin
end;

procedure TMetafile.NewImage;
begin
  FImage.Release;
  FImage := TMetafileImage.Create;
  FImage.Reference;
end;

procedure TMetafile.ReadData(Stream: TStream);
begin
end;


procedure TMetafile.SaveToFile(const Filename: AnsiString);
var
  SaveEnh: Boolean;
begin
  SaveEnh := Enhanced;
  try
    if AnsiLowerCaseFileName(ExtractFileExt(Filename)) = '.wmf' then
      Enhanced := False;              { For 16 bit compatibility }
    inherited SaveToFile(Filename);
  finally
    Enhanced := SaveEnh;
  end;
end;

procedure TMetafile.SaveToStream(Stream: TStream);
begin
  if FImage <> nil then
    if Enhanced then
      WriteEMFStream(Stream)
    else
      WriteWMFStream(Stream);
end;

procedure TMetafile.SetHandle(Value: HENHMETAFILE);
var
  EnhHeader: TEnhMetaHeader;
begin
  if (Value <> 0) and
    (GetEnhMetafileHeader(Value, sizeof(EnhHeader), @EnhHeader) = 0) then
    InvalidMetafile;
  UniqueImage;
  if FImage.FHandle <> 0 then DeleteEnhMetafile(FImage.FHandle);
//  InternalDeletePalette(FImage.FPalette);
  FImage.FPalette := 0;
  FImage.FHandle := Value;
  FImage.FTempWidth := 0;
  FImage.FTempHeight := 0;
  if Value <> 0 then
    with EnhHeader.rclFrame do
    begin
      FImage.FWidth := Right - Left;
      FImage.FHeight := Bottom - Top;
    end;
  PaletteModified := Palette <> 0;
  Changed(Self);
end;

procedure TMetafile.SetHeight(Value: Integer);
var
  EMFHeader: TEnhMetaHeader;
begin
  if FImage = nil then NewImage;
  with FImage do
    if FInch = 0 then
      if FHandle = 0 then
        FTempHeight := Value
      else
      begin                 { convert device pixels to 0.01mm units }
        GetEnhMetaFileHeader(FHandle, Sizeof(EMFHeader), @EMFHeader);
        MMHeight := MulDiv(Value,                      { metafile height in pixels }
          EMFHeader.szlMillimeters.cy*100,             { device height in 0.01mm }
          EMFHeader.szlDevice.cy);                     { device height in pixels }
      end
    else
      MMHeight := MulDiv(Value, HundredthMMPerInch, ScreenLogPixels);
end;

procedure TMetafile.SetInch(Value: Word);
begin
  if FImage = nil then NewImage;
  if FImage.FInch <> Value then
  begin
    UniqueImage;
    FImage.FInch := Value;
    Changed(Self);
  end;
end;

procedure TMetafile.SetMMHeight(Value: Integer);
begin
  if FImage = nil then NewImage;
  FImage.FTempHeight := 0;
  if FImage.FHeight <> Value then
  begin
    UniqueImage;
    FImage.FHeight := Value;
    Changed(Self);
  end;
end;

procedure TMetafile.SetMMWidth(Value: Integer);
begin
  if FImage = nil then NewImage;
  FImage.FTempWidth := 0;
  if FImage.FWidth <> Value then
  begin
    UniqueImage;
    FImage.FWidth := Value;
    Changed(Self);
  end;
end;

procedure TMetafile.SetTransparent(Value: Boolean);
begin
  // Ignore assignments to this property.
  // Metafiles must always be considered transparent.
end;

procedure TMetafile.SetWidth(Value: Integer);
var
  EMFHeader: TEnhMetaHeader;
begin
  if FImage = nil then NewImage;
  with FImage do
    if FInch = 0 then
      if FHandle = 0 then
        FTempWidth := Value
      else
      begin                 { convert device pixels to 0.01mm units }
        GetEnhMetaFileHeader(FHandle, Sizeof(EMFHeader), @EMFHeader);
        MMWidth := MulDiv(Value,                      { metafile width in pixels }
          EMFHeader.szlMillimeters.cx*100,            { device width in mm }
          EMFHeader.szlDevice.cx);                    { device width in pixels }
      end
    else
      MMWidth := MulDiv(Value, HundredthMMPerInch, ScreenLogPixels);
end;

function TMetafile.TestEMF(Stream: TStream): Boolean;
var
  Size: Longint;
  Header: TEnhMetaHeader;
begin
  Size := Stream.Size - Stream.Position;
  if Size > Sizeof(Header) then
  begin
    Stream.Read(Header, Sizeof(Header));
    Stream.Seek(-Sizeof(Header), soFromCurrent);
  end;
  Result := (Size > Sizeof(Header)) and
    (Header.iType = EMR_HEADER) and (Header.dSignature = ENHMETA_SIGNATURE);
end;

procedure TMetafile.UniqueImage;
var
  NewImage1: TMetafileImage;
begin
  if FImage = nil then
    Self.NewImage
  else
    if FImage.FRefCount > 1 then
    begin
      NewImage1:= TMetafileImage.Create;
      if FImage.FHandle <> 0 then
        NewImage1.FHandle := CopyEnhMetafile(FImage.FHandle, nil);
      NewImage1.FHeight := FImage.FHeight;
      NewImage1.FWidth := FImage.FWidth;
      NewImage1.FInch := FImage.FInch;
      NewImage1.FTempWidth := FImage.FTempWidth;
      NewImage1.FTempHeight := FImage.FTempHeight;
      FImage.Release;
      FImage := NewImage1;
      FImage.Reference;
    end;
end;

procedure TMetafile.WriteData(Stream: TStream);
var
  SavePos: Longint;
begin
  if FImage <> nil then
  begin
    SavePos := 0;
    Stream.Write(SavePos, Sizeof(SavePos));
    SavePos := Stream.Position - Sizeof(SavePos);
    if Enhanced then
      WriteEMFStream(Stream)
    else
      WriteWMFStream(Stream);
    Stream.Seek(SavePos, soFromBeginning);
    SavePos := Stream.Size - SavePos;
    Stream.Write(SavePos, Sizeof(SavePos));
    Stream.Seek(0, soFromEnd);
  end;
end;

procedure TMetafile.WriteEMFStream(Stream: TStream);
var
  Buf: Pointer;
  Length: Longint;
begin
  if FImage = nil then Exit;
  Length := GetEnhMetaFileBits(FImage.FHandle, 0, nil);
  if Length = 0 then Exit;
  GetMem(Buf, Length);
  try
    GetEnhMetaFileBits(FImage.FHandle, Length, Buf);
    Stream.WriteBuffer(Buf^, Length);
  finally
    FreeMem(Buf, Length);
  end;
end;

procedure TMetafile.WriteWMFStream(Stream: TStream);
begin
end;

(*
procedure TMetafile.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
var
  EnhHeader: TEnhMetaHeader;
begin
  AData := GetClipboardData(CF_ENHMETAFILE); // OS will convert WMF to EMF
  if AData = 0 then  InvalidGraphic(@SUnknownClipboardFormat);
  NewImage;
  with FImage do
  begin
    FHandle := CopyEnhMetafile(AData, nil);
    GetEnhMetaFileHeader(FHandle, sizeof(EnhHeader), @EnhHeader);
    with EnhHeader.rclFrame do
    begin
      FWidth := Right - Left;
      FHeight := Bottom - Top;
    end;
    FInch := 0;
  end;
  Enhanced := True;
  PaletteModified := Palette <> 0;
  Changed(Self);
end;

procedure TMetafile.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
begin
  if FImage = nil then Exit;
  AFormat := CF_ENHMETAFILE;
  APalette := 0;
  AData := CopyEnhMetaFile(FImage.FHandle, nil);
end;
*)
function TMetafile.ReleaseHandle: HENHMETAFILE;
begin
  UniqueImage;
  Result := FImage.FHandle;
  FImage.FHandle := 0;
end;



end.

