unit colorPan1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  debug0;

type
  TcolorPan = class(TFrame)
    Bcol: TButton;
    Pcol: TPanel;
    ColorDialog1: TColorDialog;
    procedure BcolClick(Sender: TObject);
  private
    { Déclarations privées }
    Fimmediat:boolean;
    adcol:^integer;
  public
    { Déclarations publiques }

    onChange:procedure of object;

    procedure init(var col:integer;immediat:boolean);
    function getColor:integer;
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TcolorPan.init(var col:integer;immediat:boolean);
begin
  adcol:=@col;
  Pcol.color:=col;
  Fimmediat:=immediat;
end;

procedure TcolorPan.BcolClick(Sender: TObject);
begin
  ColorDialog1.color:=Pcol.Color;
  if ColorDialog1.Execute
    then Pcol.Color:=ColorDialog1.color;

  if Fimmediat then adcol^:=Pcol.Color;
  if assigned(onChange) then onChange; 
end;



function TcolorPan.getColor: integer;
begin
  result:=Pcol.color;
end;

Initialization
AffDebug('Initialization colorPan1',0);
{$IFDEF FPC}
{$I colorPan1.lrs}
{$ENDIF}
end.
