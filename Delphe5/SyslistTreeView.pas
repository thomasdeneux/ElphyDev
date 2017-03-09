unit SyslistTreeView;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont, ExtCtrls, ComCtrls,

  util1,stmObj , debug0;

type
  TSyslistView = class(TFrame)
    TreeView1: TTreeView;
    Panel1: TPanel;
    cbSort: TCheckBoxV;
    Label1: TLabel;
    ESsearch: TEdit;
    procedure ESsearchChange(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    { Déclarations privées }
    Fupdate:boolean;
  public
    { Déclarations publiques }
    ob:typeUO;
    Fsort:boolean;
    procedure updateList;
    procedure Install;
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TSyslistView }

procedure TSyslistView.updateList;
begin
  Fupdate:=true;
  syslist.fillTreeView(treeView1,ob,Fsort);
  Fupdate:=false;
end;

procedure TSyslistView.install;
begin
  cbSort.setVar(Fsort);
  updateList;
end;


function FindTreeNode(st:AnsiString;vv:TtreeNode):TtreeNode;
var
  i:integer;
  st1:AnsiString;
begin
  result:=nil;

  st:=Fmaj(st);
  st1:=Fmaj(vv.text);
  if copy(st1,1,4)='PG0.' then delete(st1,1,4);
  if (copy(st1,1,length(st))=st) then
  begin
    result:=vv;
    exit;
  end;

  for i:=0 to vv.Count-1 do
  begin
    result:=FindTreeNode(st,vv[i]);
    if result<>nil then exit;
  end;
end;

procedure TSyslistView.ESsearchChange(Sender: TObject);
const
  st:AnsiString='';
var
  p0:TtreeNode;
  i:integer;
begin
  if SysList.FModified then
    begin
      updateList;
      SysList.FModified:=false;
    end;

  if ESsearch.Text=copy(st,1,length(ESsearch.Text)) then exit;

  st:=ESsearch.Text;

  with treeView1 do
  for i:=0 to items.Count-1 do
  begin
    p0:=FindTreeNode(st,treeView1.Items[i]);
    if p0<>nil then break;
  end;

  if p0<>nil then
  begin
    p0.selected:=true;
    ob:=p0.data;
  end;
end;

procedure TSyslistView.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if Fupdate then exit;
  ob:=node.data;

end;

procedure TSyslistView.TreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  uo:typeUO;
begin
  uo:=node.data;
  if assigned(uo)
    then AllowExpansion:=uo.expandTree(TtreeView(sender),node);  
end;





Initialization
AffDebug('Initialization SyslistTreeView',0);
{$IFDEF FPC}
{$I SyslistTreeView.lrs}
{$ENDIF}
end.
