unit MesureRefreshTime;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont, debug0;

type
  TRefreshTimeMeasurement = class(TForm)
    enSampleInt: TeditNum;
    Label1: TLabel;
    Label2: TLabel;
    enAcqDur: TeditNum;
    Button1: TButton;
    Button2: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function RefreshTimeMeasurement: TRefreshTimeMeasurement;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FRefreshTimeMeasurement: TRefreshTimeMeasurement;

function RefreshTimeMeasurement: TRefreshTimeMeasurement;
begin
  if not assigned(FRefreshTimeMeasurement) then FRefreshTimeMeasurement:= TRefreshTimeMeasurement.create(nil);
  result:= FRefreshTimeMeasurement;
end;

Initialization
AffDebug('Initialization MesureRefreshTime',0);
{$IFDEF FPC}
{$I MesureRefreshTime.lrs}
{$ENDIF}
end.
