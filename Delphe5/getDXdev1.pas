unit getDXdev1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,

  util1,
  {$IFDEF DX11}

  {$ELSE}
  DXTypes, Direct3D9G, D3DX9G,
  {$ENDIF}
  stmDef, debug0;

type
  TDXdevice = class(TForm)
    Label3: TLabel;
    cbDevice: TcomboBoxV;
    Button1: TButton;
    Button2: TButton;
  private
    { Déclarations privées }
    VSDriverIndex:integer;
  public
    { Déclarations publiques }
    procedure execution;
  end;


procedure getDXdevice;

implementation

{$R *.DFM}

{ TDXdevice }


procedure TDXdevice.execution;
var
  i:integer;

begin
  with cbDevice do
  begin
    clear;
    VSDriverIndex:=-1;
    for i:=0 to DXscreen.Nscreen-1 do
      begin
        items.add(DXscreen.screenId[i]);
        if (stDXdriver = DXscreen.screenId[i]) then VSdriverIndex:=i;
      end;

    if VSDriverIndex=-1
      then VSDriverIndex:=DXscreen.Nscreen-1;

    setvar(VSDriverIndex,t_longint,0);
  end;

  if showModal=mrOK then
  begin
    updateAllVar(self);
    stDXdriver:=DXscreen.ScreenId[VSdriverIndex];
  end;
end;


procedure getDXdevice;
var
  dxdevice:TdxDevice;
begin
  dxdevice:=TdxDevice.create(formstm);
  dxDevice.execution;
  dxDevice.free;

end;


Initialization
AffDebug('Initialization getDXdev1',0);
{$IFDEF FPC}
{$I getDXdev1.lrs}
{$ENDIF}
end.
