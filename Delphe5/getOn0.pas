unit geton0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, stimForm,
  debug0;

type
  TgetOnOff1 = class(TstimulusForm)
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    enDtON: TeditNum;
    enDtOff: TeditNum;
    enCycleCount: TeditNum;
    enDelay: TeditNum;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  getOnOff1: TgetOnOff1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization getOn0',0);
{$IFDEF FPC}
{$I geton0.lrs}
{$ENDIF}
end.
