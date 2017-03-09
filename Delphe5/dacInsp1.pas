unit dacInsp1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,Menus,

  util1,varconf1,
  stmDef,stmObj,stmdata0,
  debug0, editcont, stmPopup;





type
  TInspectFormDac = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    Bshow: TButton;
    Bdestroy: TButton;
    Binfo: TButton;
    cbSort: TCheckBoxV;
    ESsearch: TEdit;
    Label1: TLabel;
    procedure BshowClick(Sender: TObject);
    procedure BdestroyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BinfoClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure TreeView1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure cbSortClick(Sender: TObject);
    procedure ESsearchChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    { Déclarations private }
    ob:TypeUO;
    Fupdate:boolean;
    Fdestroy:boolean;

    uo:typeUO;

    Fsort:boolean;
    pop:TpopupMenu;

    stSearch:TstringList;
    Isearch:Tlist;

    function compare(st1,st2:AnsiString):integer;
    procedure controleOb;
  public
    { Déclarations public }
    procedure UpdateList;
    procedure changeObvis;
  end;


  TstmInspector=class(Tdata0)
    constructor create;override;
    destructor destroy;override;
    class function stmClassName:AnsiString;override;
    procedure createForm;override;

    procedure completeLoadInfo;override;
    procedure resetAll;override;
    procedure update;
  end;


var
  uoInspector:TstmInspector;

const
  stStmInspector='StmInspector';


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}


{*********************** Méthodes de TstmInspector ***************************}

constructor TstmInspector.create;
begin
  inherited;
  notPublished:=true;
  FsingleLoad:=true;
end;

destructor TstmInspector.destroy;
begin
  if assigned(form) then TInspectFormDac(form).Fdestroy:=true;
  inherited;
end;

class function TstmInspector.stmClassName:AnsiString;
begin
  result:='StmInspector';
end;

procedure TstmInspector.createForm;
begin
  form:=TInspectFormDac.create(formStm);
  TInspectFormDac(form).uo:=self;
end;

procedure TstmInspector.resetAll;
begin
  inherited completeLoadInfo;
  if not assigned(form) then createForm;
  TInspectFormDac(form).updateList;
end;

procedure TstmInspector.completeLoadInfo;
begin
  {on interdit la mise à jour de la liste tant que tous les objets ne sont pas
   complètement initialisés. C'est resetAll qui fait le travail }
end;

procedure TstmInspector.update;
begin
  if assigned(form) then TInspectFormDac(form).updateList;
end;

{*********************** Méthodes de TInspectFormDac *************************}

procedure TInspectFormDac.controleOb;
begin
  if syslist.indexof(ob)<0 then ob:=nil;
end;

procedure TInspectFormDac.UpdateList;
begin
  if Fdestroy then exit;
  Fupdate:=true;

  syslist.fillTreeView(treeView1,ob,Fsort);
  treeView1.Items.addChildObject(nil,'()',nil);

  Fupdate:=false;
  changeObvis;

  stSearch.clear;
  ISearch.clear;

  SysList.FModified:=false;
end;


procedure TInspectFormDac.BshowClick(Sender: TObject);
begin
  if SysList.FModified then updateList;

  controleOb;
  if ob=nil then exit;

  ob.show(nil);
end;

procedure TInspectFormDac.BdestroyClick(Sender: TObject);
begin
  updateList;

  ob.free;
  mainObjList.supprime(ob);

  ob:=nil;
  updateList;
end;



procedure TInspectFormDac.FormCreate(Sender: TObject);
begin
  top:=240;
  left:=screen.width-width-5;

  {$IFNDEF FPC}
  treeView1.changeDelay:=0;
  {$ENDIF}

  cbSort.setVar(Fsort);
  stSearch:=TstringList.Create;
  ISearch:=TList.Create;
end;

procedure TInspectFormDac.FormDestroy(Sender: TObject);
begin
  stSearch.Free;
  ISearch.Free;
end;

procedure TInspectFormDac.changeObvis;
begin
  if Fdestroy then exit;
  try
  Bdestroy.enabled:= (ob<>nil) and
                      not ob.Fsystem and
                      not ob.Fchild and
                      (ob.Fstatus<>UO_PG);
  except
  Bdestroy.enabled:=false;
  end;
end;


procedure TInspectFormDac.BinfoClick(Sender: TObject);
begin
  (*debug
  if SysList.FModified then updateList;

  controleOb;
  if ob=nil then exit;

   messageCentral( ob.ident+' myad='+Pstr(ob.myAd)+'  ad= '+Pstr(ob) );
   debug end *)


   sysList.inspect;
end;

procedure TInspectFormDac.TreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  if Fupdate then exit;
  ob:=node.data;
  changeObvis;
end;

procedure TInspectFormDac.TreeView1Expanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  uo:typeUO;
begin
  uo:=node.data;
  if assigned(uo)
    then AllowExpansion:=uo.expandTree(TtreeView(sender),node);  
end;

procedure TInspectFormDac.TreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
  mi:TmenuItem;
begin
  if SysList.FModified then updateList;

  controleOb;
  if ob=nil then exit;

  if button=mbRight then
  begin
    p:=TwinControl(sender).ClientToScreen(point(x,y));
    if ob.getPopUp<>nil then
    begin
      if assigned(pop) then pop.free;
      pop:=TpopUpMenu.create(nil);

      mi:=TmenuItem.create(pop);

      mi.caption:=ob.ident; {item avec nom de l'objet}

      CopyPopup(mi,ob.getPopup);
      pop.items.add(mi);

      pop.popup(p.x,p.y);
    end;

    exit;
  end;

  with treeView1 do
  begin
    tag:=ob.getSysListPosition;

    DragUOsource:=uo;
    DraggedUO:=ob;

    beginDrag(false);
  end;

end;

procedure TInspectFormDac.TreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept:=assigned(DragUOsource) and (DragUOsource.stmclassName='ObjectFile');

end;

procedure TInspectFormDac.TreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  node:TtreeNode;
  uo:typeUO;
begin
  node:=TreeView1.getNodeAt(x,y);
  if assigned(node) and assigned(node.data) then
    with typeUO(node.Data) do
    begin
      loadFromObject(draggedUO,true);
      invalidate;
    end
  else
  if cloneObjet(DraggedUO)<>nil then
    begin
      updateList;
    end;

  resetDragUO;
end;

procedure TInspectFormDac.FormShow(Sender: TObject);
begin
  if SysList.FModified then updateList;
end;

procedure TInspectFormDac.TreeView1EndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  resetDragUO;
end;

procedure TInspectFormDac.cbSortClick(Sender: TObject);
begin
  cbSort.UpdateVar;
  UpdateList;
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


procedure TInspectFormDac.ESsearchChange(Sender: TObject);
var
  p0:TtreeNode;
  i,lastI,n,k:integer;
  st:AnsiString;
  lastNode:integer;
begin
  if SysList.FModified then updateList;

  st:=ESsearch.Text;
  p0:=nil;
  n:=0;
  lastI:=0;

  with stSearch do
  begin
    for i:=0 to count-1 do
    begin
      k:=compare(stSearch[i],st);
      if k>n then
      begin
        n:=k;
        lastI:=intG(Isearch[i]);
        if n=length(st) then
        begin
          p0:=pointer(stSearch.objects[i]);
          break;
        end;
      end;
    end;
  end;


  if p0=nil then
    with treeView1 do
    begin
      for i:=lastI to items.Count-1 do
      begin
        p0:=FindTreeNode(st,treeView1.Items[i]);
        if p0<>nil then
        begin
          lastNode:=i;
          stSearch.AddObject(st,p0);
          Isearch.Add(pointer(lastNode));

          if stSearch.count>200 then
          begin
            stSearch.Delete(0);
            ISearch.Delete(0);
          end;

          break;
        end;
      end;
    end;

  if p0<>nil then
  begin
    p0.selected:=true;
    ob:=p0.data;
    changeObvis;
  end;

end;

{ Renvoie TRUE si st1 est égale au début de st2
}
function TInspectFormDac.compare(st1, st2: AnsiString): integer;
var
  i:integer;
  max:integer;
begin
  st1:=Fmaj(st1);
  st2:=Fmaj(st2);
  if copy(st2,1,4)='PG0.' then delete(st2,1,4);

  result:=0;
  max:=length(st1);
  if length(st2)<length(st1) then max:=length(st2);
  for i:=1 to max do
    if st1[i]=st2[i]
      then inc(result)
      else break;
end;



Initialization
AffDebug('Initialization dacInsp1',0);

registerObject(TstmInspector,data);

{$IFDEF FPC}
{$I dacInsp1.lrs}
{$ENDIF}
end.
