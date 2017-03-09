unit Getcoln;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,
  debug0;

type
  TGetColParams = class(TForm)
    editString1: TeditString;
    Bok: TButton;
    Bcancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    editNum1: TeditNum;
    Button1: TButton;
  private
    { Déclarations private }
  public
    { Déclarations public }
    function execution(var st:AnsiString;var nbDeci:byte):integer;
  end;

function GetColParams: TGetColParams;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FGetColParams: TGetColParams;

function GetColParams: TGetColParams;
begin
  if not assigned(FGetColParams) then FGetColParams:= TGetColParams.create(nil);
  result:= FGetColParams;
end;


function TGetColParams.execution(var st:AnsiString;
                                   var nbDeci:byte):integer;
  var
    res:integer;
  begin
    editString1.setString(st,100);
    editNum1.setvar(nbdeci,t_byte);
    editNum1.setMinMax(0,25);

    res:=showModal;
    if res<>10 then
      begin
        updateAllVar(self);
        execution:=res;
      end
    else execution:=0;
  end;

Initialization
AffDebug('Initialization getColN',0);
  {$IFDEF FPC}
  {$I Getcoln.lrs}
  {$ENDIF}
end.
