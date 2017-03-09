unit ITCopt1;

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
  TITCoptions = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Label1: TLabel;
    enDelay: TeditNum;
    cbTags: TCheckBoxV;
  private
    { Déclarations privées }
    p0:pointer;
  public
    { Déclarations publiques }
    procedure execution(p:pointer);
  end;

function ITCoptions: TITCoptions;

implementation

uses ITCbrd;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FITCoptions: TITCoptions;

function ITCoptions: TITCoptions;
begin
  if not assigned(FITCoptions) then FITCoptions:= TITCoptions.create(nil);
  result:= FITCoptions;
end;

{ TITCoptions }

procedure TITCoptions.execution(p: pointer);
begin
  p0:=p;

  with TITCinterface(p0) do
  begin
    enDelay.setVar(delay1600,t_longint);
    enDelay.setMinMax(0,10000);
    cbTags.setVar(FuseTagStart);
  end;

  if showModal=mrOK then updateAllvar(self);
end;

Initialization
AffDebug('Initialization ITCopt1',0);
{$IFDEF FPC}
{$I ITCopt1.lrs}
{$ENDIF}
end.
