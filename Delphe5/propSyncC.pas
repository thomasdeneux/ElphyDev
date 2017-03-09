unit propSyncC;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  propVlist, StdCtrls, editcont,

  stmObj,stmVec1,debug0,
  stmVlist0,stmSyncC, Buttons;

type
  TSyncCProperties = class(TVlistProperties)
    Label6: TLabel;
    Label7: TLabel;
    EditSource: TEdit;
    Bsource: TBitBtn;
    Bevent: TBitBtn;
    EditEvent: TEdit;
    procedure BsourceClick(Sender: TObject);
    procedure BeventClick(Sender: TObject);
  private
    { Private declarations }
    Vs,Ve: Tvector;
  public
    { Public declarations }
    procedure install(w:TVlist0);override;
    function execution(w:TVlist0):boolean;override;
  end;

function SyncCProperties: TSyncCProperties;

implementation

uses chooseOb;

var
  FSyncCProperties: TSyncCProperties;

function SyncCProperties: TSyncCProperties;
begin
  if not assigned(FSyncCProperties) then FSyncCProperties:= TSyncCProperties.create(nil);
  result:= FSyncCProperties;
end;


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
procedure TSyncCProperties.install(w:TVlist0);
begin
  inherited install(w);

  with TsyncList(uo) do
  begin
    Vs:=Vsource;
    Ve:=Vevent;

    if Vs<>nil
      then EditSource.Text:=Vs.ident
      else EditSource.Text:='';
    if Ve<>nil
      then EditEvent.Text:=Ve.ident
      else EditEvent.Text:='';

  end;
end;

function TSyncCProperties.execution(w:TVlist0):boolean;
begin
  install(w);
  result:=showModal=mrOK;
  if result then
    begin
      updateAllVar(self);

      with TsyncList(uo) do
      begin
        Vsource:=Vs;
        Vevent:=Ve;
      end;
    end;
end;

procedure TSyncCProperties.BsourceClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(vs)) then
  begin
    if assigned(vs)
      then EditSource.Text:= vs.ident
      else EditSource.Text:='';
  end;
end;

procedure TSyncCProperties.BeventClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(ve)) then
  begin
    if assigned(ve)
      then EditEvent.Text:= ve.ident
      else EditEvent.Text:='';
  end;

end;

Initialization
AffDebug('Initialization propSyncC',0);
{$IFDEF FPC}
{$I propSyncC.lrs}
{$ENDIF}
end.
