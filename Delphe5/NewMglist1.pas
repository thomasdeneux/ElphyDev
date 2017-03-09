unit NewMglist1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1,Dgraphic,stmObj, debug0, editcont, StdCtrls;

type
  TNewMGlist = class(TForm)
    Label1: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    esName: TeditString;
    Label2: TLabel;
    esTitle: TeditString;
    procedure BOKClick(Sender: TObject);
  private
    { Déclarations privées }
    st0,st1:AnsiString;
  public
    accept:function(st:AnsiString):boolean of object;
    { Déclarations publiques }
    function Execution(var stName, stTitle: AnsiString): boolean;
  end;


function NewMGlist: TNewMGlist;

implementation

{$R *.dfm}

var
  FNewMGlist: TNewMGlist;

function NewMGlist: TNewMGlist;
begin
  if not assigned(FNewMGlist) then FNewMGlist:= TNewMGlist.Create(nil);
  result:= FNewMGlist;
end;

procedure TNewMGlist.BOKClick(Sender: TObject);
begin
  updateAllVar(self);

  if not accept(st0)
    then messageCentral('This name is not a valid name')
    else modalResult:=mrOK;
end;

function TNewMGlist.Execution(var stName, stTitle: AnsiString): boolean;
begin
  result:=false;

  st0:=stName;
  st1:=stTitle;
  esName.setString(st0,20);
  esTitle.setString(st1,50);
  if showModal=mrOK then
  begin
    stName:=st0;
    stTitle:=st1;
    result:=true;
  end;
end;

end.
