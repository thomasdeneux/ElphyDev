unit iniRA0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls,
  util1,editCont, debug0;

type
  TinitRealArray = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    Label3: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
  private
    { Private declarations }
  public
    { Public declarations }
    function execution(st:string;var col,lig:integer):boolean;

  end;

function initRealArray: TinitRealArray;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FinitRealArray: TinitRealArray;

function initRealArray: TinitRealArray;
begin
  if not assigned(FinitRealArray) then FinitRealArray:= TinitRealArray.create(nil);
  result:= FinitRealArray;
end;

function TinitRealArray.execution(st:string;var col,lig:integer):boolean;
begin
  caption:=st;
  editnum1.setvar(col,t_longint);
  editnum1.setMinMax(1,256);
  editnum2.setvar(lig,t_longint);
  editnum2.setMinMax(1,1000000);

  result:=(showModal=mrOK);
  if result then updateAllvar(self);
end;


Initialization
AffDebug('Initialization iniRA0',0);
{$IFDEF FPC}
{$I iniRA0.lrs}
{$ENDIF}
end.
