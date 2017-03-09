unit ParSystem;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,

  stmDef,debug0;

type
  TParamSystem = class(TForm)
    Label1: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    cbDriver: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
    function execution(var stName1:DriverString;list:TstringList):boolean;
  end;

function ParamSystem: TParamSystem;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FParamSystem: TParamSystem;

function ParamSystem: TParamSystem;
begin
  if not assigned(FParamSystem) then FParamSystem:= TParamSystem.create(nil);
  result:= FParamSystem;
end;
function TParamSystem.execution(var stName1:Driverstring;list:TstringList):boolean;
var
  i:integer;
begin
  with cbDriver do
  begin
    clear;
    for i:=0 to list.count-1 do
      begin
        items.add(list.strings[i]);
        if stName1=list.strings[i] then itemIndex:=i;
      end;
  end;

  result:= (showModal=mrOK);

  if result then stName1:=cbDriver.text;
end;

Initialization
AffDebug('Initialization ParSystem',0);
{$IFDEF FPC}
{$I ParSystem.lrs}
{$ENDIF}
end.
