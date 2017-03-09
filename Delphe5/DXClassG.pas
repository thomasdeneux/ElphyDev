unit DXClassG;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{$INCLUDE DelphiXcfgG.inc}

uses
  {$IFDEF FPC}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Controls, Forms, MMSystem, DirectXG,
  util1,debug0;

type

  {  EDirectDrawError  }

  EDirectXError = class(Exception);

  {  TDirectX  }

  TDirectX = class(TPersistent)
  private
    procedure SetDXResult(Value: HRESULT);
  protected
    FDXResult: HRESULT;
    procedure Check; virtual;
  public
    property DXResult: HRESULT read FDXResult write SetDXResult;
  end;

  {  TDirectXDriver  }

  TDirectXDriver = class(TCollectionItem)
  private
    FGUID: PGUID;
    FGUID2: TGUID;
    FDescription: AnsiString;
    FDriverName: AnsiString;
    procedure SetGUID(Value: PGUID);
  public
    property GUID: PGUID read FGUID write SetGUID;
    property Description: AnsiString read FDescription write FDescription;
    property DriverName: AnsiString read FDriverName write FDriverName;
  end;

  {  TDirectXDrivers  }

  TDirectXDrivers = class(TCollection)
  private
    function GetDriver(Index: Integer): TDirectXDriver;
  public
    constructor Create;
    property Drivers[Index: Integer]: TDirectXDriver read GetDriver; default;
  end;

  {  TControlSubClass  }

  TControlSubClassProc = procedure(var Message: TMessage; DefWindowProc: TWndMethod) of object;

  TControlSubClass = class
  private
    FControl: TControl;
    FDefWindowProc: TWndMethod;
    FWindowProc: TControlSubClassProc;
    procedure WndProc(var Message: TMessage);
  public
    constructor Create(Control: TControl; WindowProc: TControlSubClassProc);
    destructor Destroy; override;
  end;

  {  THashCollectionItem  }

  THashCollectionItem = class(TCollectionItem)
  private
    FHashCode: Integer;
    FIndex: Integer;
    FName: AnsiString;
    FLeft: THashCollectionItem;
    FRight: THashCollectionItem;
    procedure SetName(const Value: AnsiString);
    procedure AddHash;
    procedure DeleteHash;
  protected
    function GetDisplayName: String; override;
    procedure SetIndex(Value: Integer); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Index: Integer read FIndex write SetIndex;
  published
    property Name: AnsiString read FName write SetName;
  end;

  {  THashCollection  }

  THashCollection = class(TCollection)
  private
    FHash: array[0..255] of THashCollectionItem;
  public
    function IndexOf(const Name: AnsiString): Integer;
  end;

function Max(Val1, Val2: Integer): Integer;
function Min(Val1, Val2: Integer): Integer;

function Cos256(i: Integer): Double;
function Sin256(i: Integer): Double;

function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
function RectInRect(const Rect1, Rect2: TRect): Boolean;
function OverlapRect(const Rect1, Rect2: TRect): Boolean;

function WideRect(ALeft, ATop, AWidth, AHeight: Integer): TRect;
procedure ReleaseCom(out Com);
function DXLoadLibrary(const FileName, FuncName: AnsiString): TFarProc;

implementation

uses DXConstsG;

function Max(Val1, Val2: Integer): Integer;
begin
  if Val1>=Val2 then Result := Val1 else Result := Val2;
end;

function Min(Val1, Val2: Integer): Integer;
begin
  if Val1<=Val2 then Result := Val1 else Result := Val2;
end;

function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
  Result := (Point.X >= Rect.Left) and
            (Point.X <= Rect.Right) and
            (Point.Y >= Rect.Top) and
            (Point.Y <= Rect.Bottom);
end;

function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left >= Rect2.Left) and
            (Rect1.Right <= Rect2.Right) and
            (Rect1.Top >= Rect2.Top) and
            (Rect1.Bottom <= Rect2.Bottom);
end;

function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
  Result := (Rect1.Left < Rect2.Right) and
            (Rect1.Right > Rect2.Left) and
            (Rect1.Top < Rect2.Bottom) and
            (Rect1.Bottom > Rect2.Top);
end;

function WideRect(ALeft, ATop, AWidth, AHeight: Integer): TRect;
begin
  with Result do
  begin
    Left := ALeft;
    Top := ATop;
    Right := ALeft+AWidth;
    Bottom := ATop+AHeight;
  end;
end;

var
  CosinTable: array[0..255] of Double;

procedure InitCosinTable;
var
  i: Integer;
begin
  for i:=0 to 255 do
    CosinTable[i] := Cos((i/256)*2*PI);
end;

function Cos256(i: Integer): Double;
begin
  Result := CosinTable[i and 255];
end;

function Sin256(i: Integer): Double;
begin
  Result := CosinTable[(i+192) and 255];
end;

procedure ReleaseCom(out Com);
begin
end;

var
  LibList: TStringList;

function DXLoadLibrary(const FileName, FuncName: AnsiString): Pointer;
var
  i: Integer;
  h: THandle;
begin
  if LibList=nil then
    LibList := TStringList.Create;

  i := LibList.IndexOf(AnsiLowerCase(FileName));
  if i=-1 then
  begin
    {  DLL is loaded.  }
    h := GLoadLibrary(FileName);
    if h=0 then
      raise Exception.CreateFmt(SDLLNotLoaded, [FileName]);
    LibList.AddObject(AnsiLowerCase(FileName), Pointer(h));
  end else
  begin
    {  DLL has already been loaded.  }
    h := THandle(LibList.Objects[i]);
  end;

  Result := GetProcAddress(h, PAnsiChar(FuncName));
  if Result=nil then
    raise Exception.CreateFmt(SDLLNotLoaded, [FileName]);
end;

procedure FreeLibList;
var
  i: Integer;
begin
  if LibList<>nil then
  begin
    for i:=0 to LibList.Count-1 do
      FreeLibrary(THandle(LibList.Objects[i]));
    LibList.Free;
  end;
end;

{  TDirectX  }

procedure TDirectX.Check;
begin
end;

procedure TDirectX.SetDXResult(Value: HRESULT);
begin
  FDXResult := Value;
  if FDXResult<>0 then Check;
end;

{  TDirectXDriver  }

procedure TDirectXDriver.SetGUID(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then
  begin
    FGUID2 := Value^;
    FGUID := @FGUID2;
  end else
    FGUID := Value;
end;

{  TDirectXDrivers  }

constructor TDirectXDrivers.Create;
begin
  inherited Create(TDirectXDriver);
end;

function TDirectXDrivers.GetDriver(Index: Integer): TDirectXDriver;
begin
  Result := (inherited Items[Index]) as TDirectXDriver;
end;


{  TControlSubClass  }

constructor TControlSubClass.Create(Control: TControl;
  WindowProc: TControlSubClassProc);
begin
  inherited Create;
  FControl := Control;
  FDefWindowProc := FControl.WindowProc;
  FControl.WindowProc := WndProc;
  FWindowProc := WindowProc;
end;

destructor TControlSubClass.Destroy;
begin
  FControl.WindowProc := FDefWindowProc;
  inherited Destroy;
end;

procedure TControlSubClass.WndProc(var Message: TMessage);
begin
  FWindowProc(Message, FDefWindowProc);
end;


{  THashCollectionItem  }

function MakeHashCode(const Str: AnsiString): Integer;
var
  s: AnsiString;
begin
  s := AnsiLowerCase(Str);
  Result := Length(s)*16;
  if Length(s)>=2 then
    Result := Result + (Ord(s[1]) + Ord(s[Length(s)-1]));
  Result := Result and 255;
end;

constructor THashCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FIndex := inherited Index;
  AddHash;
end;

destructor THashCollectionItem.Destroy;
var
  i: Integer;
begin
  for i:=FIndex+1 to Collection.Count-1 do
    Dec(THashCollectionItem(Collection.Items[i]).FIndex);
  DeleteHash;
  inherited Destroy;
end;

procedure THashCollectionItem.Assign(Source: TPersistent);
begin
  if Source is THashCollectionItem then
  begin
    Name := THashCollectionItem(Source).Name;
  end else
    inherited Assign(Source);
end;

procedure THashCollectionItem.AddHash;
var
  Item: THashCollectionItem;
begin
  FHashCode := MakeHashCode(FName);

  Item := THashCollection(Collection).FHash[FHashCode];
  if Item<>nil then
  begin
    Item.FLeft := Self;
    Self.FRight := Item;
  end;

  THashCollection(Collection).FHash[FHashCode] := Self;
end;

procedure THashCollectionItem.DeleteHash;
begin
  if FLeft<>nil then
  begin
    FLeft.FRight := FRight;
    if FRight<>nil then
      FRight.FLeft := FLeft;
  end else
  begin
    if FHashCode<>-1 then
    begin
      THashCollection(Collection).FHash[FHashCode] := FRight;
      if FRight<>nil then
        FRight.FLeft := nil;
    end;
  end;
  FLeft := nil;
  FRight := nil;
end;

function THashCollectionItem.GetDisplayName: String;
begin
  Result := Name;
  if Result='' then Result := inherited GetDisplayName;
end;

procedure THashCollectionItem.SetIndex(Value: Integer);
begin
  if FIndex<>Value then
  begin
    FIndex := Value;
    inherited SetIndex(Value);
  end;
end;

procedure THashCollectionItem.SetName(const Value: AnsiString);
begin
  if FName<>Value then
  begin
    FName := Value;
    DeleteHash;
    AddHash;
  end;
end;

{  THashCollection  }

function THashCollection.IndexOf(const Name: AnsiString): Integer;
var
  Item: THashCollectionItem;
begin
  Item := FHash[MakeHashCode(Name)];
  while Item<>nil do
  begin
    if AnsiCompareText(Item.Name, Name)=0 then
    begin
      Result := Item.FIndex;
      Exit;
    end;
    Item := Item.FRight;
  end;
  Result := -1;
end;


Initialization
AffDebug('Initialization DXClassG',0);
  InitCosinTable;
finalization
  FreeLibList;
end.
