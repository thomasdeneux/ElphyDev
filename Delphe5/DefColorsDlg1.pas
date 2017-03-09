unit DefColorsDlg1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ColorFrame1,
  debug0;

type
  TDefColorsDlg = class(TForm)
    BKFrame: TColFrame;
    ScaleFrame: TColFrame;
    PenFrame: TColFrame;
    Button1: TButton;
    Button2: TButton;
  private
    { Déclarations privées }
    BKcol1,ScaleCol1,PenCol1:integer;
  public
    { Déclarations publiques }
    function execute(var BKcol,ScaleCol,PenCol:integer):boolean;
  end;

function DefColorsDlg: TDefColorsDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDefColorsDlg: TDefColorsDlg;

function DefColorsDlg: TDefColorsDlg;
begin
  if not assigned(FDefColorsDlg) then FDefColorsDlg:= TDefColorsDlg.create(nil);
  result:= FDefColorsDlg;
end;

{ TDefColors }

function TDefColorsDlg.execute(var BKcol, ScaleCol, PenCol: integer): boolean;
begin
  BKcol1:=BKcol;
  ScaleCol1:=ScaleCol;
  PenCol1:=PenCol;

  ScaleFrame.init(ScaleCol1);
  BKFrame.init(BKcol1);
  PenFrame.init(PenCol1);

  if ShowModal=mrOK then
  begin
    BKcol:=BKcol1;
    ScaleCol:=ScaleCol1;
    PenCol:=PenCol1;
  end;
end;

Initialization
AffDebug('Initialization DefColorsDlg1',0);
{$IFDEF FPC}
{$I DefColorsDlg1.lrs}
{$ENDIF}
end.
