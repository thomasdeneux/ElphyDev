unit Objname1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,

  util1,Dgraphic,formMenu,stmObj, debug0;

type
  TGetObjName = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    editString1: TeditString;
    cbPermanent: TCheckBoxV;
    procedure BOKClick(Sender: TObject);
  private
    { Déclarations private }
    St0:shortstring;
    perm:boolean;
  public
    { Déclarations public }
    accept:function(st:AnsiString):boolean of object;
    function execution(var st:shortstring;var status:TUOstatus):boolean;
  end;

function GetObjName: TGetObjName;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FGetObjName: TGetObjName;

function GetObjName: TGetObjName;
begin
  if not assigned(FGetObjName) then FGetObjName:= TGetObjName.create(nil);
  result:= FGetObjName;
end;

function TGetObjName.execution(var st:shortstring;var status:TUOstatus):boolean;
  begin
    execution:=false;
    st0:=st;
    perm:=false;
    editString1.setvar(st0,50);
    cbPermanent.setVar(perm);
    if showModal=mrOK then
      begin
        st:=st0;
        if perm
          then status:=UO_main
          else status:=UO_temp;
        execution:=true;
      end;
  end;

procedure TGetObjName.BOKClick(Sender: TObject);
begin
  updateAllVar(self);

  if not accept(st0)
    then messageCentral('This name is not a valid name')
    else modalResult:=mrOK;
end;



Initialization
AffDebug('Initialization Objname1',0);
{$IFDEF FPC}
{$I Objname1.lrs}
{$ENDIF}
end.
