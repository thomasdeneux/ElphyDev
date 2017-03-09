unit getColVec1;

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
  debug0;

type
  TColParam = class(TForm)
    Label2: TLabel;
    enDeci: TeditNum;
    Bok: TButton;
    Bcancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function ColParam: TColParam;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FColParam: TColParam;

function ColParam: TColParam;
begin
  if not assigned(FColParam) then FColParam:= TColParam.create(nil);
  result:= FColParam;
end;

Initialization
AffDebug('Initialization getColVec1',0);
{$IFDEF FPC}
{$I getColVec1.lrs}
{$ENDIF}
end.
