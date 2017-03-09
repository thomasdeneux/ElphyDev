unit inigra0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  editCont, StdCtrls,

  stmObj,stmvec1, Buttons, debug0;

type
  TinitGraph = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    ENi1: TeditNum;
    Label5: TLabel;
    ENi2: TeditNum;
    cbAuto: TCheckBoxV;
    enXdata: TEdit;
    Bxdata: TBitBtn;
    Bydata: TBitBtn;
    enYdata: TEdit;
    enSigData: TEdit;
    BerrorData: TBitBtn;
    cbOwned: TCheckBoxV;
    procedure cbAutoClick(Sender: TObject);
    procedure BxdataClick(Sender: TObject);
  private
    { Déclarations privées }
    v10,v20,vs0:Tvector;
  public
    { Déclarations publiques }
    function execution(cap:AnsiString;var v1,v2,vs:Tvector;
                       var Ideb,Ifin: integer;var autoLimit,OwnedVec: boolean):boolean;

  end;

function initGraph: TinitGraph;

implementation

uses chooseOb;


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FinitGraph: TinitGraph;

function initGraph: TinitGraph;
begin
  if not assigned(FinitGraph) then FinitGraph:= TinitGraph.create(nil);
  result:= FinitGraph;
end;


function TinitGraph.execution(cap:AnsiString;var v1,v2,vs:Tvector;
                               var Ideb,Ifin:integer;var autoLimit,OwnedVec:boolean):boolean;
var
  Ivec1,Ivec2,IvecS:integer;
begin
  caption:=cap;

  v10:=v1;
  v20:=v2;
  vs0:=vs;
  enXdata.Text:=uoIdent(v1);
  enYdata.Text:=uoIdent(v2);
  enSigdata.Text:=uoIdent(vs);

  ENi1.setVar(Ideb,T_longint);
  ENi2.setVar(Ifin,T_longint);

  cbAuto.setVar(autoLimit);
  cbOwned.setVar(OwnedVec);

  cbAutoClick(nil);

  execution:=showModal=mrOK;
  if result then
    begin
      updateAllVar(self);

      v1:=v10;
      v2:=v20;
      vs:=vs0;
    end;

end;

procedure TinitGraph.cbAutoClick(Sender: TObject);
begin
  Label4.enabled:=not cbAuto.checked;
  Label5.enabled:=not cbAuto.checked;
  enI1.enabled:=not cbAuto.checked;
  enI2.enabled:=not cbAuto.checked;
end;

procedure TinitGraph.BxdataClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  case Tbutton(sender).tag of
    1: if chooseObject.execution(Tvector,typeUO(v10))
         then  enXdata.Text:=uoIdent(v10);
    2: if chooseObject.execution(Tvector,typeUO(v20))
         then  enYdata.Text:=uoIdent(v20);
    3: if chooseObject.execution(Tvector,typeUO(vs0))
         then  enSigdata.Text:=uoIdent(vs0);
  end;
end;

Initialization
AffDebug('Initialization inigra0',0);
{$IFDEF FPC}
{$I inigra0.lrs}
{$ENDIF}
end.
