unit AngleOption1;

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
  visu0, debug0;

type
  TAngularOpt = class(TForm)
    Label1: TLabel;
    enLineWidth: TeditNum;
    C_ok: TButton;
    C_cancel: TButton;
  private
    { Déclarations privées }
    visu0:TvisuInfo;
  public
    { Déclarations publiques }
    function execution(var visu1:TvisuInfo):boolean;
  end;

function AngularOpt: TAngularOpt;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FAngularOpt: TAngularOpt;

function AngularOpt: TAngularOpt;
begin
  if not assigned(FAngularOpt) then FAngularOpt:= TAngularOpt.create(nil);
  result:= FAngularOpt;
end;

{ TAngularOpt }

function TAngularOpt.execution(var visu1: TvisuInfo): boolean;
begin
  visu0:=visu1;

  enLineWidth.setVar(visu1.angularLW,t_longint);

  result:= (showModal=mrOK);
  if result then updateAllVar(self);
end;

Initialization
AffDebug('Initialization AngleOption1',0);
{$IFDEF FPC}
{$I AngleOption1.lrs}
{$ENDIF}
end.
