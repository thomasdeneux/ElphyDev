unit getEp0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, debug0;

type
  TChooseEp = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    editNum1: TeditNum;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(var num:integer;max:integer):boolean;
  end;

function ChooseEp: TChooseEp;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FChooseEp: TChooseEp;

function ChooseEp: TChooseEp;
begin
  if not assigned(FChooseEp) then FChooseEp:= TChooseEp.create(nil);
  result:= FChooseEp;
end;

function TchooseEp.execution(var num:integer;max:integer):boolean;
begin
  editNum1.setvar(num,t_longint);
  editNum1.setMinMax(1,max);
  if showModal=mrOK then
    begin
      updateAllVar(self);
      execution:=true;
    end
  else execution:=false;
end;


Initialization
AffDebug('Initialization getEp0',0);
{$IFDEF FPC}
{$I getEp0.lrs}
{$ENDIF}
end.
