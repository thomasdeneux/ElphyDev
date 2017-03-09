unit opVec1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls,
  debug0;

type
  TOptionsVec1 = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    BBKcol: TButton;
    PanelBKcol: TPanel;
    ColorDialog1: TColorDialog;
    procedure BBKcolClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Adcolor:^Tcolor;
  end;

function OptionsVec1: TOptionsVec1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FOptionsVec1: TOptionsVec1;

function OptionsVec1: TOptionsVec1;
begin
  if not assigned(FOptionsVec1) then FOptionsVec1:= TOptionsVec1.create(nil);
  result:= FOptionsVec1;
end;

procedure TOptionsVec1.BBKcolClick(Sender: TObject);
begin
  if assigned(Adcolor) then
    with colorDialog1 do
    begin
      color:=AdColor^;
      execute;
      AdColor^:=color;
      PanelBKcol.color:=Adcolor^;
    end;
end;

procedure TOptionsVec1.FormActivate(Sender: TObject);
begin
  if assigned(Adcolor) then panelBKcol.color:=AdColor^;
end;

Initialization
AffDebug('Initialization opVec1',0);
{$IFDEF FPC}
{$I opVec1.lrs}
{$ENDIF}
end.
