unit getMatValue1;

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
  TMatValue = class(TForm)
    editNum1: TeditNum;
    BOK: TButton;
    Bcancel: TButton;
    Panel1: TPanel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MatValue: TMatValue;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization getMatValue1',0);
{$IFDEF FPC}
{$I getMatValue1.lrs}
{$ENDIF}
end.
