unit getPhasT;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  geton0, StdCtrls, editcont, Debug0;

type
  TgetPhaseTrans = class(TgetOnOff1)
    EnSpeed: TeditNum;
    Label1: TLabel;
    enPhase0: TeditNum;
    Label2: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  getPhaseTrans: TgetPhaseTrans;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization Getphast',0);
{$IFDEF FPC}
{$I getPhasT.lrs}
{$ENDIF}
end.
