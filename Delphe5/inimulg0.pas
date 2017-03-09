unit Inimulg0;

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
  TinitTmultigraph = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    Lname: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
  private
    { Private declarations }
  public
    { Public declarations }
    function execution(st:AnsiString;var n1,n2:longint):boolean;

  end;

function initTmultigraph: TinitTmultigraph;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FinitTmultigraph: TinitTmultigraph;

function initTmultigraph: TinitTmultigraph;
begin
  if not assigned(FinitTmultigraph) then FinitTmultigraph:= TinitTmultigraph.create(nil);
  result:= FinitTmultigraph;
end;

function TinitTmultigraph.execution(st:AnsiString;var n1,n2:longint):boolean;
var
  ok:boolean;
begin
  n1:=1;
  n2:=1;
  Lname.caption:=st;
  editnum1.setvar(n1,t_longint);
  editnum2.setvar(n2,t_longint);

  ok:=(showModal=mrOK);
  if ok then updateAllVar(self);
  execution:=ok;

end;


Initialization
AffDebug('Initialization Inimulg0',0);
{$IFDEF FPC}
{$I Inimulg0.lrs}
{$ENDIF}
end.
