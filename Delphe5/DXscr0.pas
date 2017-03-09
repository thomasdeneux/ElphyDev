unit DXscr0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDrawsG,

  stmDef,stmObj,debug0;

type
  TDXscreenB = class(TForm)
    DXDraw0: TDXDraw;
    procedure DXDraw0Initializing(Sender: TObject);
    procedure DXDraw0RestoreSurface(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXDraw0FinalizeSurface(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InMemory:boolean;
    FinalizeG:procedure of object;
  end;

var
  DXscreenB: TDXscreenB;

implementation


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}


procedure TDXscreenB.DXDraw0Initializing(Sender: TObject);
var
  i:integer;
begin
  with dxDraw0 do
  for i:=0 to drivers.count-1 do
    if (drivers[i].Description =stDXdriver) and (i=stDXdriverIndex) then
      begin
        driver:=drivers[i].GUID;
        exit;
      end;

  with dxDraw0 do
  for i:=0 to drivers.count-1 do
    if (drivers[i].Description =stDXdriver) then
      begin
        driver:=drivers[i].GUID;
        exit;
      end;

end;

procedure TDXscreenB.DXDraw0RestoreSurface(Sender: TObject);
begin
  postMessage(Tform(owner).handle,Msg_DXdraw2,0,0);
end;

procedure TDXscreenB.FormCreate(Sender: TObject);
begin
  visible:=false;
end;

procedure TDXscreenB.DXDraw0FinalizeSurface(Sender: TObject);
var
  i:integer;
begin
  if assigned(finalizeG) then FinalizeG;

  for i:=0 to HKpaint.count-1 do
    with TypeUO(HKpaint.items[i]) do freeBM;
end;

Initialization
AffDebug('Initialization DXscr0',0);
{$IFDEF FPC}
{$I DXscr0.lrs}
{$ENDIF}
end.
