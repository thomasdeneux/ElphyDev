unit diviwin;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,
  debug0;

type
  TDivideWin = class(TForm)
    label1: TLabel;
    Label2: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
    BOK: TButton;
    Bcancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(var nbx,nby:integer):boolean;
  end;

function DivideWin: TDivideWin;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDivideWin: TDivideWin;

function DivideWin: TDivideWin;
begin
  if not assigned(FDivideWin) then FDivideWin:= TDivideWin.create(nil);
  result:= FDivideWin;
end;

function TDivideWin.execution(var nbx,nby:integer):boolean;
begin
  editNum1.setvar(nbx,t_longint);
  editNum1.setMinMax(1,100);

  editNum2.setvar(nby,t_longint);
  editNum2.setMinMax(1,100);

  result:=(showModal=mrOK);
  if result then updateAllVar(self);
end;

Initialization
AffDebug('Initialization diviwin',0);
{$IFDEF FPC}
{$I diviwin.lrs}
{$ENDIF}
end.
