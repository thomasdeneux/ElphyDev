unit getGab1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Getdeg0, StdCtrls, editcont, Debug0;

type
  TgetGabor1 = class(TDegform)
    Label5: TLabel;
    enOrient: TeditNum;
    Label6: TLabel;
    enContrast: TeditNum;
    Label7: TLabel;
    enPeriod: TeditNum;
    Label8: TLabel;
    enPhase: TeditNum;
    sbOrient: TscrollbarV;
    sbContrast: TscrollbarV;
    sbPeriod: TscrollbarV;
    sbPhase: TscrollbarV;
    Label2: TLabel;
    enLx: TeditNum;
    sbLx: TscrollbarV;
    Label3: TLabel;
    enLy: TeditNum;
    sbLy: TscrollbarV;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    circleD: procedure (v:boolean) of object;
  end;

var
  getGabor1: TgetGabor1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization GETGAB1',0);
{$IFDEF FPC}
{$I getGab1.lrs}
{$ENDIF}
end.
