unit chooseOb;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  util1,stmDef,stmObj, ComCtrls,debug0;

type
  TChooseObject = class(TForm)
    GroupBox1: TGroupBox;
    Bok: TButton;
    Bcancel: TButton;
    TreeView1: TTreeView;
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    { Déclarations privées }
    tuo1:TUOclass;
  public
    { Déclarations publiques }
    function execution(TUO:TUOclass;var ob:typeUO):boolean;
  end;

function ChooseObject: TChooseObject;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FChooseObject: TChooseObject;

function ChooseObject: TChooseObject;
begin
  if not assigned(FChooseObject) then FChooseObject:= TChooseObject.create(nil);
  result:= FChooseObject;
end;

function TChooseObject.execution(TUO:TUOclass;var ob:typeUO):boolean;
begin
  tuo1:=tuo;

  syslist.fillTreeView(treeView1,ob,false);

  result:= (showModal=mrOK);

  with treeView1 do
  if result and assigned(selected) and ((typeUO(selected.data) is TUO))
    then ob:=typeUO(selected.data)
    else result:=false;
end;

procedure TChooseObject.TreeView1DblClick(Sender: TObject);
begin
  if typeUO(treeView1.selected.data) is TUO1 then modalResult:=mrOK;
end;

procedure TChooseObject.TreeView1Expanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  uo:typeUO;
begin
  uo:=node.data;
  if assigned(uo)
    then AllowExpansion:=uo.expandTree(TtreeView(sender),node);
end;

Initialization
AffDebug('Initialization Chooseob',0);
{$IFDEF FPC}
{$I chooseOb.lrs}
{$ENDIF}
end.
