unit Getrotp1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont;

type
  TgetPhaseTrans = class(TForm)
    Label1: TLabel;
    enSpeed: TeditNum;
    CBobvis: TcomboBoxV;
    Label2: TLabel;
  private
    { Déclarations private }
  public
    { Déclarations public }
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization Getrotp1',0);
{$IFDEF FPC}
{$I Getrotp1.lrs}
{$ENDIF}
end.
