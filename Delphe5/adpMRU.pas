unit adpMRU;


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Menus;

type


  TMRUClickEvent = procedure(Sender: TObject; const FileName: AnsiString) of object;

  TadpMRU = class(TComponent)
  private
    FItems : TStringList;

    FMaxItems: cardinal;
    FShowFullPath: boolean;
    FParentMenuItem: TMenuItem;
    FOnClick: TMRUClickEvent;
    procedure SetMaxItems(const Value: cardinal);
    procedure SetShowFullPath(const Value: boolean);
    procedure SetParentMenuItem(const Value: TMenuItem);

    procedure ItemsChange(Sender: TObject);
    procedure ClearParentMenu;

    function getText:AnsiString;
    procedure setText(st:AnsiString);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoClick(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddItem(const FileName: AnsiString);
    function RemoveItem(const FileName : AnsiString) : boolean;
  published
    property MaxItems: cardinal read FMaxItems write SetMaxItems default 4;
    property ShowFullPath: boolean read FShowFullPath write SetShowFullPath default True;
    property ParentMenuItem: TMenuItem read FParentMenuItem write SetParentMenuItem;

    property OnClick: TMRUClickEvent read FOnClick write FOnClick;
    property text:AnsiString read getText write setText;
  end;

procedure Register;

implementation

type
  TMRUMenuItem = class(TMenuItem); //to be able to recognize MRU menu item when deleting


procedure Register;
begin
  RegisterComponents('Var', [TadpMRU]);
end;

{ TadpMRU }

constructor TadpMRU.Create(AOwner: TComponent);
begin
  inherited;
  FParentMenuItem := nil;
  FItems := TStringList.Create;
  FItems.OnChange := ItemsChange;

  FMaxItems := 4;
  FShowFullPath := True;
end; (*Create*)


destructor TadpMRU.Destroy;
begin

  FItems.OnChange := nil;
  FItems.Free;

  inherited;
end; (*Destroy*)

procedure TadpMRU.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FParentMenuItem) then
    FParentMenuItem := nil;
end; (*Notification*)

procedure TadpMRU.AddItem(const FileName: AnsiString);
begin
  if FileName <> '' then
  begin
    FItems.BeginUpdate;
    try
      if FItems.IndexOf(FileName) > -1 then
        FItems.Delete(FItems.IndexOf(FileName));
      FItems.Insert(0, FileName);

      while FItems.Count > MaxItems do
        FItems.Delete(MaxItems);
    finally
      FItems.EndUpdate;
    end;
  end;
end; (*AddItem*)

function TadpMRU.RemoveItem(const FileName: AnsiString): boolean;
begin
  if FItems.IndexOf(FileName) > -1 then
  begin
    FItems.Delete(FItems.IndexOf(FileName));
    Result := True;
  end
  else
    Result := False;
end; (*RemoveItem*)

procedure TadpMRU.SetMaxItems(const Value: Cardinal);
begin
  if Value <> FMaxItems then
  begin
    if Value < 1 then FMaxItems := 1
    else
      if Value > MaxInt then
        FMaxItems := MaxInt - 1
      else
      begin
        FMaxItems := Value;
        FItems.BeginUpdate;
        try
          while FItems.Count > MaxItems do
            FItems.Delete(FItems.Count - 1);
        finally
          FItems.EndUpdate;
        end;
      end;
  end;
end; (*SetMaxItems*)


procedure TadpMRU.SetShowFullPath(const Value: boolean);
begin
  if FShowFullPath <> Value then
  begin
    FShowFullPath := Value;
    ItemsChange(Self);
  end;
end; (*SetShowFullPath*)


procedure TadpMRU.ItemsChange(Sender: TObject);
var
  i: Integer;
  NewMenuItem: TMenuItem;
  FileName: AnsiString;
begin
  if ParentMenuItem <> nil then
  begin
    ClearParentMenu;
    for i := 0 to -1 + FItems.Count do
    begin
      if ShowFullPath then
        FileName := StringReplace(FItems[I], '&', '&&', [rfReplaceAll, rfIgnoreCase])
      else
        FileName := StringReplace(ExtractFileName(FItems[i]), '&', '&&', [rfReplaceAll, rfIgnoreCase]);

      NewMenuItem := TMRUMenuItem.Create(Self);
      NewMenuItem.Caption := Format('%s', [FileName]);
      NewMenuItem.Tag := i;
      NewMenuItem.OnClick := DoClick;
      ParentMenuItem.Add(NewMenuItem);
    end;
  end;
end; (*ItemsChange*)

procedure TadpMRU.ClearParentMenu;
var
  i:integer;
begin
  if Assigned(ParentMenuItem) then
    for i:= -1 + ParentMenuItem.Count downto 0 do
      if ParentMenuItem.Items[i] is TMRUMenuItem then
        ParentMenuItem.Delete(i);
end; (*ClearParentMenu*)

procedure TadpMRU.DoClick(Sender: TObject);
begin
  if Assigned(FOnClick) and (Sender is TMRUMenuItem) then
    FOnClick(Self, FItems[TMRUMenuItem(Sender).Tag]);
end;(*DoClick*)

procedure TadpMRU.SetParentMenuItem(const Value: TMenuItem);
begin
  if FParentMenuItem <> Value then
  begin
    ClearParentMenu;
    FParentMenuItem := Value;
    ItemsChange(Self);
  end;
end; (*SetParentMenuItem*)

function TadpMRU.getText: AnsiString;
begin
  result:=Fitems.Text;
end;

procedure TadpMRU.setText(st: AnsiString);
begin
  Fitems.Text:=st;

  while FItems.Count > MaxItems do
        FItems.Delete(MaxItems);
end;

end. (*adpMRU.pas*)

