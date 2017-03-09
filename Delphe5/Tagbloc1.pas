unit Tagbloc1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont, debug0;

type
  TtagBlock = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ENstart: TeditNum;
    ENend: TeditNum;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    ENstep: TeditNum;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    function execution(var deb,fin,step:integer;max:integer):boolean;
  end;

function tagBlock: TtagBlock;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FtagBlock: TtagBlock;

function tagBlock: TtagBlock;
begin
  if not assigned(FtagBlock) then FtagBlock:= TtagBlock.create(nil);
  result:= FtagBlock;
end;

function TtagBlock.execution(var deb,fin,step:integer;max:integer):boolean;
begin
  if deb=0 then
    begin
      deb:=1;
      fin:=max;
      step:=1;
    end;
  
  ENstart.setvar(deb,T_smallInt);
  ENstart.setMinMax(1,max);
  ENend.setvar(fin,T_smallInt);
  ENend.setMinMax(1,max);
  ENstep.setvar(step,T_smallInt);
  ENstep.setMinMax(1,max);

  execution:= (showModal=mrOK);

end;


procedure TtagBlock.Button1Click(Sender: TObject);
begin
  updateAllVar(self);
end;

Initialization
AffDebug('Initialization Tagbloc1',0);
{$IFDEF FPC}
{$I Tagbloc1.lrs}
{$ENDIF}
end.
