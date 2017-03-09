unit Getmat0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  SysUtils, Classes, Controls, Messages, Graphics,
  Forms, Dialogs, StdCtrls, editcont,
  defForm,
  debug0;

type
  TgetMatrix = class(TgenForm)
    Button1: TButton;
    cbOnControl: TCheckBoxV;
    procedure Button1Click(Sender: TObject);
    procedure cbOnControlClick(Sender: TObject);
  private
    { Déclarations private }
    
  public
    { Déclarations public }
    Voncontrol:boolean;
    onShowD:TnotifyEvent;
    onControlD:procedure(v:boolean) of object;
  end;

var
  getMatrix: TgetMatrix;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetMatrix.Button1Click(Sender: TObject);
begin
  if assigned(onShowD) then onshowD(sender);
end;

procedure TgetMatrix.cbOnControlClick(Sender: TObject);
begin
  cbOnControl.updateVar;
  if assigned(onControlD) then onControlD(VonControl);
end;

Initialization
AffDebug('Initialization Getmat0',0);
{$IFDEF FPC}
{$I Getmat0.lrs}
{$ENDIF}
end.
