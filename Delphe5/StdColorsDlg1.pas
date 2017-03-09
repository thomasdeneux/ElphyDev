unit StdColorsDlg1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, colorPan1, StdCtrls, ColorFrame1,
  debug0;

type
  TStdColorsDlg = class(TForm)
    ColFrame1: TColFrame;
    ColFrame2: TColFrame;
    ColFrame3: TColFrame;
    ColFrame4: TColFrame;
    ColFrame5: TColFrame;
    ColFrame6: TColFrame;
    ColFrame7: TColFrame;
    ColFrame8: TColFrame;
    ColFrame9: TColFrame;
    ColFrame10: TColFrame;
    ColFrame11: TColFrame;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    cf:array[0..10] of TcolFrame;
    tbCol:array[0..10] of integer;


  public
    { Déclarations publiques }
    procedure execute(var tb:array of integer);

  end;

function StdColorsDlg: TStdColorsDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FStdColorsDlg: TStdColorsDlg;

function StdColorsDlg: TStdColorsDlg;
begin
  if not assigned(FStdColorsDlg) then FStdColorsDlg:= TStdColorsDlg.create(nil);
  result:= FStdColorsDlg;
end;

procedure TStdColorsDlg.execute(var tb:array of integer);
var
  i:integer;
begin
  for i:=0 to 10 do tbcol[i]:=tb[i];
  for i:=0 to 10 do cf[i].init(tbcol[i]);

  if showModal=mrOK then
    for i:=0 to 10 do tb[i]:=tbCol[i];
end;

procedure TStdColorsDlg.FormCreate(Sender: TObject);
var
  i:integer;
begin
  cf[0]:=colFrame1;
  cf[1]:=colFrame2;
  cf[2]:=colFrame3;
  cf[3]:=colFrame4;
  cf[4]:=colFrame5;
  cf[5]:=colFrame6;
  cf[6]:=colFrame7;
  cf[7]:=colFrame8;
  cf[8]:=colFrame9;
  cf[9]:=colFrame10;
  cf[10]:=colFrame11;
end;

Initialization
AffDebug('Initialization StdColorsDlg1',0);
{$IFDEF FPC}
{$I StdColorsDlg1.lrs}
{$ENDIF}
end.
