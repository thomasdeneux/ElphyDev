unit WaveListForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TPform0, Menus, ExtCtrls, StdCtrls, Buttons,
  util1, editcont, debug0;

type
  TWaveListForm = class(TPform)
    Panel1: TPanel;
    Pnum: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Ptime: TPanel;
    Panel3: TPanel;
    Punit: TPanel;
    SBindex: TscrollbarV;
    Panel5: TPanel;
    cbHold: TCheckBoxV;
    cbStdColors: TCheckBoxV;
    BdisplayAll: TButton;
    procedure FormPaint(Sender: TObject);
    procedure SBindexScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure cbHoldClick(Sender: TObject);
    procedure BdisplayAllClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function WaveListForm: TWaveListForm;

implementation

uses StmSpkWave1;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FWaveListForm: TWaveListForm;

function WaveListForm: TWaveListForm;
begin
  if not assigned(FWaveListForm) then FWaveListForm:= TWaveListForm.create(nil);
  result:= FWaveListForm;
end;



procedure TWaveListForm.FormPaint(Sender: TObject);
begin
  inherited;
  with TwaveList(Uplot) do
  begin
    Pnum.Caption:=Istr(Windex)+' / '+Istr(maxIndex);
    Ptime.Caption:= getTimeString;
    Punit.Caption:= getUnitString;
  end;
end;

procedure TWaveListForm.SBindexScrollV(Sender: TObject; x: Extended; ScrollCode: TScrollCode);
begin
  with TwaveList(Uplot) do
  begin
    setIndex(round(x));
    self.invalidate;
  end;
end;

procedure TWaveListForm.cbHoldClick(Sender: TObject);
begin
  if HoldMode then HoldFirst:=true;
  invalidate;
end;

procedure TWaveListForm.BdisplayAllClick(Sender: TObject);
var
  i:integer;
  oldHold:boolean;
begin
  oldHold:=HoldMode;
  HoldMode:=true;
  HoldFirst:=true;

  with TwaveList(Uplot) do
  for i:=1 to maxIndex do
  begin
    setIndex(i);
    self.Refresh;
    if testEscape then break;
  end;

  HoldMode:=oldHold;
end;

Initialization
AffDebug('Initialization WaveListForm1',0);
{$IFDEF FPC}
{$I WaveListForm1.lrs}
{$ENDIF}
end.
