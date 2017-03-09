unit Getvect0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  defForm,
  debug0;

type
  TgetVector = class(TgenForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    onShowD:TnotifyEvent;
  end;

var
  getVector: TgetVector;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetVector.Button1Click(Sender: TObject);
begin
  if assigned(onShowD) then onshowD(sender);
end;

Initialization
AffDebug('Initialization Getvect0',0);
{$IFDEF FPC}
{$I Getvect0.lrs}
{$ENDIF}
end.
