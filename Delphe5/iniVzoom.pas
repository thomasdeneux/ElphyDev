unit iniVzoom;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  editCont, StdCtrls, Buttons,

  stmObj,stmvec1, debug0;

type
  TinitVzoom = class(TForm)
    Label1: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    EditSource: TEdit;
    Bchoose: TBitBtn;
    procedure BchooseClick(Sender: TObject);
  private
    { Déclarations privées }
    adSource: PPUO;
  public
    { Déclarations publiques }
    function execution(cap:AnsiString;var vs:Tvector):boolean;

  end;


function initVzoom: TinitVzoom;

implementation

uses chooseOb;


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FinitVzoom: TinitVzoom;

function initVzoom: TinitVzoom;
begin
  if not assigned(FinitVzoom) then FinitVzoom:= TinitVzoom.create(nil);
  result:= FinitVzoom;
end;


function TinitVzoom.execution(cap:AnsiString;var vs:Tvector):boolean;
begin
  caption:=cap;

  if assigned(vs)
      then EditSource.Text:= vs.ident
      else EditSource.Text:='';
  adSource:=@vs;

  result:= (showModal=mrOK);
end;

procedure TinitVzoom.BchooseClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(adsource^)) then
  begin
    if assigned(adsource^)
      then EditSource.Text:= adsource^.ident
      else EditSource.Text:='';
  end;

end;



Initialization
AffDebug('Initialization iniVzoom',0);
{$IFDEF FPC}
{$I iniVzoom.lrs}
{$ENDIF}
end.
