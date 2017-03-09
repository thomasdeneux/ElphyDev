unit getMatValue2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont, ExtCtrls,
  debug0;

type
  TMatCpxValue = class(TForm)
    enRe: TeditNum;
    BOK: TButton;
    Bcancel: TButton;
    Pre: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    enIm: TeditNum;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MatCpxValue: TMatCpxValue;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization getMatValue2',0);
{$IFDEF FPC}
{$I getMatValue2.lrs}
{$ENDIF}
end.
