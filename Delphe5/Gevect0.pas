unit Gevect0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TgetVector = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    onShowD:procedure of object;
  end;

var
  getVector: TgetVector;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetVector.Button1Click(Sender: TObject);
begin
  if assigned(onShowD) then onshowD;
end;

Initialization
AffDebug('Initialization Gevect0',0);
{$IFDEF FPC}
{$I Gevect0.lrs}
{$ENDIF}
end.
