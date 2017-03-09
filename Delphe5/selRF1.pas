unit selrf1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,
  debug0;

type
  TFormSelectRF = class(TForm)
    rf1: TButton;
    CancelBtn: TButton;
    rf2: TButton;
    rf3: TButton;
    rf4: TButton;
    rf5: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FormSelectRF: TFormSelectRF;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FFormSelectRF: TFormSelectRF;

function FormSelectRF: TFormSelectRF;
begin
  if not assigned(FFormSelectRF) then FFormSelectRF:= TFormSelectRF.create(nil);
  result:= FFormSelectRF;
end;

Initialization
AffDebug('Initialization selRF1',0);
{$IFDEF FPC}
{$I selrf1.lrs}
{$ENDIF}
end.
