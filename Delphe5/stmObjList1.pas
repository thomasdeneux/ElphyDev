unit stmObjList1;

Interface
uses windows,classes,menus,controls,comCtrls,
     util1,Dgraphic,varconf1,debug0,
     stmdef,stmObj,stmPopup,
     Ncdef2,stmPg;


type
  TobjectList=
    class(TypeUO)

    private

      count0:integer;      {=count sert pour la sauvegarde}


      function getObject(i:integer):typeUO;     {i de 1 à count}

    public
      property Objects[i:integer]:TypeUO read getObject; default;  { i de 1 à count}

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      function count:integer;

      procedure buildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;
      procedure saveToStream( f:Tstream;Fdata:boolean);override;
      function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

      procedure AddToList(p:typeUO);

      function AddObject(uo:typeUO):typeUO;
      procedure InsertObject(n:integer;uo:typeUO);
      procedure deleteObject(n:integer);
      procedure clear;

      procedure setChildNames;override;
      procedure ChangeName(st:AnsiString);override;
      //function getPopUp:TpopupMenu;override;

      procedure setLocalRef;
    end;

procedure proTObjectList_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTObjectList_create_1(var pu:typeUO);pascal;
procedure proTObjectList_AddObject(var uo:TypeUO;var pu:typeUO);pascal;
procedure proTObjectList_InsertObject(n:integer;var uo:typeUO;var pu:typeUO);pascal;
procedure proTObjectList_DeleteObject(num:integer;var pu:typeUO);pascal;
procedure proTObjectList_Clear(var pu:typeUO);pascal;


implementation

constructor TobjectList.create;
begin
  inherited create;

end;

destructor TobjectList.destroy;
begin
  clear;

  inherited destroy;
end;

procedure TobjectList.clear;
var
  i:integer;
begin
  for i:=0 to count-1 do
  begin
    typeUO(childList[i]).free;
  end;

  ClearChildList;
end;


class function TobjectList.stmClassName:AnsiString;
begin
  result:='ObjectList';
end;

function TobjectList.getObject(i:integer):typeUO;
begin
  if (i>=1) and (i<=count)
    then result:=typeUO(ChildList[i-1])
    else result:=nil;
end;

function TobjectList.count:integer;
begin
  if assigned(childList)
    then result:=ChildList.count
    else result:=0;
end;




procedure TobjectList.buildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildinfo(conf,lecture,tout);

  if not lecture then
  begin
    count0:=count;
  end;

  with conf do
  begin
    setvarconf('Count',count0,sizeof(count0));
  end;
end;

procedure TobjectList.completeLoadInfo;
begin
  inherited;
end;

function TobjectList.loadFromStream(f: Tstream; size: LongWord;Fdata: boolean): boolean;
var
  st1:AnsiString;
  posIni:LongWord;
  i,j:integer;
  uo:typeUO;
begin
  result:=inherited loadFromStream(f,size,false);
  if not result OR (f.position>=f.size) then exit;

  clear;

  posIni:=f.position;

  for i:=1 to count0 do
  begin
    uo:=ReadAndCreateUO(f,UO_main,false,true);
    if assigned(uo) and uo.Fchild then AddToList(uo)
    else
    begin
      uo.Free;
      result:=false;
      break;
    end;
  end;

  if not result then
    begin
      result:=false;
      f.Position:=posini;
    end;

  setChildNames;
  result:=true;
end;

procedure TobjectList.saveToStream(f: Tstream; Fdata: boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  for i:=1 to count do
    objects[i].saveToStream(f,Fdata);
end;


procedure TobjectList.AddToList(p:typeUO);
begin
   p.notPublished:=false;
   p.Fchild:=true;

   AddToChildlist(p);
end;

function TobjectList.AddObject(uo: typeUO):typeUO;
begin
  if assigned(uo) then
  begin
     result:=uo.clone(true,false);
     result.resetMyAd;
     result.ident:=ident+'.'+uo.ident;
     AddToList(result);
  end
  else result:=nil;
end;

procedure TobjectList.deleteObject(n: integer);
begin
  if (n>=1) and (n<=count) then
  begin
    typeUO(childList[n-1]).free;
    childList.Delete(n-1);
    setChildNames;

  end;
end;

procedure TobjectList.InsertObject(n:integer;uo:typeUO);
var
  p:typeUO;
begin
  if (n<1) or (n>count+1) then exit;
  if assigned(uo)
    then p:=typeUO(uo.clone(true));
  if assigned(p) then
  begin
    p.ident:=ident+'.'+uo.ident;
    AddToList(p);
    with childList do Move(count-1,n-1);
  end;
  setChildNames;
end;



procedure TobjectList.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

end;


procedure TobjectList.setChildNames;
var
  i:integer;
begin
  for i:=1 to count do
  if copy(objects[i].ident,1,length(ident)+1) <> ident+'.'
    then objects[i].ident:=ident+'.'+ objects[i].ident;
end;

procedure TobjectList.ChangeName(st: AnsiString);
var
  i:integer;
begin
  inherited;
  for i:=1 to count do objects[i].ChangeName(st);
end;


procedure TobjectList.setLocalRef;
var
  list: Tlist;
  i:integer;
begin
  list:= Tlist.create;
  for i:=1 to count do
    list.Add(objects[i]);

  for i:=1 to count do
    objects[i].RetablirReferences(list);

  resetMyAd;

  list.Free;
end;


{
function TobjectList.getPopUp:TpopupMenu;
begin
  // Le popup est aussi utilisé par TmatList
  with PopUps do
  begin
    PopupItem(pop_TObjectList,'TObjectList_SaveObject').onclick:=SaveObjectToFile;
    PopupItem(pop_TObjectList,'TObjectList_Clone').onclick:=CreateClone;

    result:=pop_TObjectList;
  end;
end;
}



{****************************** Méthodes STM **********************************}

var
  E_indice:integer;

procedure proTObjectList_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TobjectList);
end;

procedure proTObjectList_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TobjectList);
end;


procedure proTObjectList_AddObject(var uo:typeUO;var pu:typeUO);
begin
  verifierObjet(typeUO(uo));
  verifierObjet(pu);

  TobjectList(pu).addObject(uo);
end;

procedure proTObjectList_InsertObject(n:integer;var uo:typeUO;var pu:typeUO);
begin
  verifierObjet(typeUO(uo));
  verifierObjet(pu);

  TobjectList(pu).insertObject(n,uo);
end;


procedure proTObjectList_DeleteObject(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TobjectList(pu).deleteObject(num);
end;

procedure proTObjectList_Clear(var pu:typeUO);
begin
  verifierObjet(pu);

  TobjectList(pu).clear;
end;






Initialization
AffDebug('Initialization VlistA1',0);

registerObject(TobjectList,data);


end.
