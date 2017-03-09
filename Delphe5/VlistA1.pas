unit VlistA1;

interface

uses windows,classes,controls,graphics,menus,forms,comCtrls,
     util1,Dgraphic,varconf1,debug0, dtf0,
     stmdef,stmObj,visu0,stmDplot,stmVec1,stmPopup,formRec0,
     tpVector,
     Velicom1,Velicom0,
     stmVlist0,
     Ncdef2,stmPg,stmError,
     stmVzoom;



{ Implémente le TVlist du langage Elphy.

  Les vecteurs sont dans childList, ce qui n'est pas forcément une bonne idée.
}

type
  TVList=
    class(TVList0)

    private
      Viewer:TVlistCommandA;               { à terminer }
      FormRecCom:Tformrec;

      Foptions:TVlistRecord;

      nbvec0:integer;      {=count sert pour la sauvegarde}

      currentVec:TimageVector;

      procedure updateCommand;


      function getVector(i:integer):Tvector; {i de 1 à count}
      function Vtitle(i:integer):AnsiString;     {i de 1 à count}

      procedure createCommand;
      function getCurrentVec:Timagevector;

    public
      UseVparams:boolean;

      function curPos:integer;    {Numéro sélectionné de 1 à count}

      procedure DisplayInfo;
      procedure DisplayGraph;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      property Vectors[i:integer]:Tvector read getVector; default;  { i de 1 à count}
      property CurVec:Timagevector read getcurrentVec;

      function count:integer;override;
      function dataValid:boolean;override;
      procedure displayTrace(num:integer);override;
      procedure getLineWorld(num:integer;var x1,y1,x2,y2:float);override;

      procedure cadrerX(sender:Tobject);override;
      procedure cadrerY(sender:Tobject);override;

      procedure autoscaleX;override;
      procedure autoscaleY;override;


      procedure showViewer(sender:Tobject);


      procedure buildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;
      procedure saveToStream( f:Tstream;Fdata:boolean);override;
      function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

      function CanLoadVectors:boolean;override;
      procedure addClone(p:Tvector);override;
      function getClone(i:integer):Tvector;override;

      procedure AddVector(vec:Tvector);
      procedure InsertVector(n:integer;vec:Tvector);
      procedure deleteVector(n:integer);
      procedure clear;

      procedure setChildNames;override;
      function getPopUp:TpopupMenu;override;

      function OpVector(var vec:Tvector; op:integer):integer;
      function VerifySameVectors: boolean;
      procedure MedianVector(var vec:Tvector);

      function Xstart:float;override;
      function Xend:float;override;

      procedure setFirstLine(num:integer);override;
      function expandTree(tree:TtreeView;node:TtreeNode):boolean;override;

    end;

procedure proTVList_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTVList_create_1(var pu:typeUO);pascal;
procedure proTVList_AddVector(var vec:Tvector;var pu:typeUO);pascal;
procedure proTVList_InsertVector(n:integer;var vec:Tvector;var pu:typeUO);pascal;
procedure proTVList_DeleteVector(num:integer;var pu:typeUO);pascal;
procedure proTVList_Clear(var pu:typeUO);pascal;

function fonctionTVlist_V(i:integer;var pu:typeUO):pointer;pascal;
procedure proTVList_MedianVector(var vec:Tvector;var pu:typeUO);pascal;

procedure proTVList_MaxVector(var vec:Tvector;var pu:typeUO);pascal;
procedure proTVList_MinVector(var vec:Tvector;var pu:typeUO);pascal;
procedure proTVList_MeanVector(var vec:Tvector;var pu:typeUO);pascal;
procedure proTVList_StdDevVector(var vec:Tvector;var pu:typeUO);pascal;

function fonctionTVlist_CurVec(var pu:typeUO):pointer;pascal;

procedure proTVList_UseVparams(w:boolean;var pu:typeUO);pascal;
function fonctionTVList_UseVparams(var pu:typeUO):boolean;pascal;

implementation

constructor TVlist.create;
begin
  inherited create;
  Foptions.FdisplayGraph:=true;

  currentVec:=TimageVector.create;
  currentVec.Fchild:=true;
end;

destructor TVlist.destroy;
begin
  currentVec.Free;
  clear;
  Viewer.free;

  inherited destroy;
end;

procedure TVlist.CreateCommand;
begin
  if assigned(Viewer) then exit;

  Viewer:=TVlistCommandA.create(formStm);
  with Viewer do
  begin
    UO:=self;
    optionsG:=@Foptions;
  end;

  with Foptions do
  begin
    fontToDesc(Viewer.panel1.font,FontRec);
    color:=Viewer.panel1.color;
  end;

  Viewer.Caption:=ident;
  updateCommand;
end;

function TVlist.curPos:integer;
begin
  if assigned(Viewer)
    then result:=Viewer.listBox1.itemIndex +1
    else result:=0;
end;

procedure TVlist.clear;
var
  i:integer;
begin
  for i:=0 to count-1 do
  begin
    Tvector(childList[i]).free;
  end;

  ClearChildList;
  if assigned(Viewer) then
  with Viewer do
  begin
    ListBox1.clear;
    paintBox1.invalidate;
  end;
end;


class function TVlist.stmClassName:AnsiString;
begin
  result:='VList';
end;

function TVlist.getVector(i:integer):Tvector;
begin
  if (i>=1) and (i<=count)
    then result:=Tvector(ChildList[i-1])
    else result:=nil;
end;

function TVlist.count:integer;
begin
  if assigned(childList)
    then result:=ChildList.count
    else result:=0;
end;

function TVlist.dataValid:boolean;
begin
  result:=(count>0);
end;

procedure TVlist.displayTrace(num:integer);
var
  oldVisuX:TvisuInfo;
  oldUseLevel:boolean;
  oldXlevel:  extended;
  oldYlevel:  extended;

begin
  if vectors[num]=nil then exit;

  with Vectors[num] do
  begin
    oldVisuX:=visu;
    oldUseLevel:=UseLevel;
    oldXlevel:=Xlevel;
    oldYlevel:=Ylevel;

    visu:=self.visu;
    UseLevel:=self.UseLevel;
    Xlevel:=self.Xlevel;
    Ylevel:=self.Ylevel;

    if UseVparams then
    begin
      visu.color:=oldVisuX.color;
      visu.color2:=oldVisuX.color2;
      visu.modeT:=oldVisuX.modeT;
      visu.tailleT:=oldVisuX.tailleT;
      visu.largeurTrait:=oldVisuX.largeurTrait;
      visu.styleTrait:=oldVisuX.styleTrait;
    end;
  end;

  Vectors[num].displayInside(nil,false,false,false);

  with Vectors[num] do
  begin
    visu:=oldVisuX;
    UseLevel:=oldUseLevel;
    Xlevel:=oldXlevel;
    Ylevel:=oldYlevel;
  end;

end;


procedure TVlist.getLineWorld(num:integer;var x1,y1,x2,y2:float);
begin

end;

procedure TVlist.cadrerX(sender:Tobject);
var
  i:integer;
  x1,x2:float;
begin
  if count<1 then exit;

  x1:=1E200;
  x2:=-1E200;

  for i:=1 to count do
  with vectors[i] do
  begin
    if Xstart<x1 then x1:=Xstart;
    if Xend>x2 then x2:=Xend;
  end;

  if (x1<>1E200) and (x2<>-1E200) then
  begin
    visu0^.Xmin:=x1;
    visu0^.Xmax:=x2;
  end;
end;

procedure TVlist.cadrerY(sender:Tobject);
var
  i:integer;
  y1,y2:float;
  deltaY:float;
begin
  if count<1 then exit;

  y1:=1E200;
  y2:=-1E200;

  for i:=1 to count do
    vectors[i].getMinMax(y1,y2);

  deltaY:=vectors[1].deltaLevel(UseLevel,Xlevel,Ylevel);
  if (y1<>1E200) and (y2<>-1E200) then
  begin
    visu0^.Ymin:=y1-deltaY;
    visu0^.Ymax:=y2-deltaY;
  end;
end;

procedure TVlist.autoscaleX;
var
  i:integer;
  x1,x2:float;
begin
  if count<1 then exit;

  x1:=1E200;
  x2:=-1E200;

  for i:=1 to count do
  with vectors[i] do
  begin
    if Xstart<x1 then x1:=Xstart;
    if Xend>x2 then x2:=Xend;
  end;

  if (x1<>1E200) and (x2<>-1E200) then
  begin
    Xmin:=x1;
    Xmax:=x2;
  end;
end;

procedure TVlist.autoscaleY;
var
  i:integer;
  y1,y2:float;
  deltaY:float;
begin
  if count<1 then exit;

  y1:=1E200;
  y2:=-1E200;

  for i:=1 to count do
    vectors[i].getMinMax(y1,y2);

  deltaY:=vectors[1].deltaLevel(UseLevel,Xlevel,Ylevel);
  if (y1<>1E200) and (y2<>-1E200) then
  begin
    Ymin:=y1-deltaY;
    Ymax:=y2-deltaY;
  end;
end;


procedure TVlist.DisplayInfo;
begin

end;

procedure TVlist.DisplayGraph;    {Appelée seulement par Viewer}
begin
  if assigned(Viewer) and
     Foptions.FdisplayGraph and assigned(vectors[Viewer.listBox1.itemIndex+1]) then
    begin
      vectors[curPos].display;
    end;
end;

function TVlist.CanLoadVectors:boolean;
begin
  result:=true;
end;

procedure TVlist.addClone(p:Tvector);
var
  i:integer;
begin
   p.ident:=ident+'.v'+Istr(count+1);
   p.notPublished:=false;
   p.Fchild:=true;
   with p do
   begin
     inf.readOnly:=false;
     Cpx:=0;
     Cpy:=0;
   end;

   AddToChildlist(p);
   {refObjet(p);}

   if assigned(Viewer) then
     Viewer.ListBox1.items.add(Vtitle(count));
end;

function TVlist.getClone(i:integer):Tvector;
var
  j:integer;
begin
  result:=Tvector(vectors[i].clone(true));
  result.ident:=ident+'_';

  with result do
  begin
    Cpx:=0;
    Cpy:=0;
  end;

end;


procedure TVlist.showViewer(sender:Tobject);
begin
  createCommand;
  Viewer.show;
end;


function TVlist.Vtitle(i:integer):AnsiString;
begin
  result:=Ident+'.'+'V'+Istr(i)
end;


procedure TVlist.updateCommand;
var
  i:integer;
  st:AnsiString;
begin
  if assigned(Viewer) then
  with Viewer.ListBox1 do
  begin
    items.beginUpdate;
    clear;
    for i:=1 to self.count do
      items.add(Vtitle(i));
    items.endUpdate;
  end;
end;

procedure TVlist.buildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildinfo(conf,lecture,tout);

  if not lecture then
  begin
    if assigned(Viewer) then FontToDesc(Viewer.panel1.font,Foptions.FontRec);
    nbVec0:=count;
  end;

  formRecCom.setForm(Viewer);
  with conf do
  begin
    setvarconf('FormRecC',FormRecCom,sizeof(FormRecCom));
    setvarconf('Foptions',Foptions,sizeof(Foptions));
    setvarconf('Count',nbVec0,sizeof(nbVec0));
  end;
end;

procedure TVlist.completeLoadInfo;
begin
  inherited;
  formRecCom.restoreForm(Tform(Viewer),createCommand);
  if assigned(Viewer) then
  with Viewer do
  begin
    caption:=ident;
    DescToFont(Foptions.FontRec,Panel1.font);
    Panel1.color:=Foptions.color;
  end;
end;

function TVList.loadFromStream(f: Tstream; size: LongWord;Fdata: boolean): boolean;
var
  st1,stID:AnsiString;
  LID:integer;
  posIni:LongWord;
  i,j:integer;

  vec:Tvector;
begin
  result:=inherited loadFromStream(f,size,false);
  if not result OR (f.position>=f.size) then exit;

  clear;

  stID:=ident;
  LID:=length(ident);
  posIni:=f.position;

  for i:=1 to nbvec0 do
  begin
    st1:=readHeader(f,size);

    if (st1=Tvector.STMClassName) then
    begin
      vec:=Tvector.create;
      with vec do
      begin
        result:=loadFromStream(f,size,Fdata);
        result:=result and Fchild;
        result:=result and (copy(ident,1,LID)=stID);
        if result
          then addClone(vec)
          else vec.Free;
      end;
      if not result then break;
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

procedure TVList.saveToStream(f: Tstream; Fdata: boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  for i:=1 to count do
    vectors[i].saveToStream(f,Fdata);
end;

procedure TVList.AddVector(vec: Tvector);
var
  p:Tvector;
begin
  if assigned(vec) then
  begin
    p:=Tvector.create;
    p.initTemp1(vec.Istart,vec.Iend,vec.tpNum);

    p.Dxu:=vec.Dxu;
    p.x0u:=vec.x0u;
    p.unitX:=vec.unitX;

    p.Dyu:=vec.Dyu;
    p.y0u:=vec.y0u;
    p.unitY:=vec.unitY;

    p.Vcopy(vec);
    AddClone(p);
  end;
end;

procedure TVList.deleteVector(n: integer);
begin
  if (n>=1) and (n<=count) then
  begin
    Tvector(childList[n-1]).free;
    childList.Delete(n-1);
    setChildNames;

    if assigned(Viewer) then
    begin
      Viewer.ListBox1.items.delete(n-1);
      updateCommand;
    end;
  end;
end;

procedure TVlist.InsertVector(n:integer;vec:Tvector);
var
  p:Tvector;
begin
  if (n<1) or (n>count+1) then exit;
  if assigned(vec)
    then p:=Tvector(vec.clone(true));
  if assigned(p) then
  begin
    AddClone(p);
    with childList do Move(count-1,n-1);
  end;
  setChildNames;
end;



procedure TVlist.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

  case id of
    UOmsg_invalidate,UOmsg_invalidateData:
      if assigned(Viewer) and (source=Vectors[curPos])
       then Viewer.paintBox1.invalidate;
  end;
end;


procedure TVList.setChildNames;
var
  i:integer;
begin
  curVec.ident:=ident+'.Curvec';
  for i:=1 to count do
    vectors[i].ident:=ident+'.v'+Istr(i);

  if assigned(Viewer)
    then Viewer.Caption:=ident;
end;

function TVlist.getPopUp:TpopupMenu;
begin
  // Le popup est aussi utilisé par TmatList
  with PopUps do
  begin
    PopUpItem(pop_TVlist,'TVlist_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_TVlist,'TVlist_ShowPlot').onclick:=self.Show;

    PopupItem(pop_TVlist,'TVlist_ShowViewer').onclick:=Showviewer;
    PopupItem(pop_TVlist,'TVlist_ShowViewer').caption:='Show Viewer';

    PopupItem(pop_TVlist,'TVlist_Properties').onclick:=Proprietes;
    {PopupItem(pop_TVlist,'TVlist_SaveData').onclick:=SaveDataToFile;}

    PopupItem(pop_TVlist,'TVlist_SaveObject').onclick:=SaveObjectToFile;
    PopupItem(pop_TVlist,'TVlist_Clone').onclick:=CreateClone;

    result:=pop_TVlist;
  end;
end;

function TVlist.VerifySameVectors: boolean;
var
  i, i1, i2:integer;
begin
  result:= false;
  if count=0 then exit;

  i1:= vectors[1].Istart;
  i2:= vectors[1].Iend;

  for i:=2 to count do
  if (vectors[i].Istart<>i1) or (vectors[i].Iend<>i2) then exit;

  result:= true;
end;

function TVList.OpVector(var vec: Tvector; op: integer): integer;
var
  t:TArrayOfDouble;
  dataVec: typeDataD;
  i,j,N:integer;
begin
  if count=0 then
  begin
    result:=1;
    exit;
  end;

  if not VerifySameVectors then
  begin
    result:=2;
    exit;
  end;

  N:=count;
  VadjustIstartIend(vectors[1],vec);

  setLength(t,N);
  dataVec:= typeDataD.create(@t[0],1,0,0,N-1);


  for i:=vec.Istart to vec.Iend do
  begin
    for j:=1 to N do t[j-1]:=vectors[j][i];
    case op of
      1: vec[i]:= dataVec.maxi(0,N-1);
      2: vec[i]:= dataVec.mini(0,N-1);
      3: vec[i]:= dataVec.moyenne(0,N-1);
      4: vec[i]:= dataVec.StdDev(0,N-1);

    end;
  end;
  result:=0;
end;




procedure TVList.MedianVector(var vec: Tvector);
var
  t:TArrayOfDouble;
  i,j:integer;
begin
  if count=0 then exit;
  setLength(t,count);
  VadjustIstartIend(vectors[1],vec);
  for i:=vec.Istart to vec.Iend do
  begin
    for j:=1 to count do
    t[j-1]:=vectors[j].Yvalue[i];
    vec.Yvalue[i]:=mediane(t,count);
  end;
end;

function TVList.Xstart: float;
var
  i:integer;
begin
  if count<1 then
  begin
    result:=0;
    exit;
  end;

  result:=1E200;

  for i:=1 to count do
  with vectors[i] do
    if Xstart<result then result:=Xstart;
end;


function TVList.Xend: float;
var
  i:integer;
begin
  if count<1 then
  begin
    result:=0;
    exit;
  end;

  result:=-1E200;

  for i:=1 to count do
  with vectors[i] do
    if Xend>result then result:=Xend;
end;

procedure TVList.setFirstLine(num: integer);
begin
  inherited;

  if (ligne1>0) and (ligne1<=count)
    then curVec.installSource(vectors[ligne1])
    else curVec.installSource(nil);
end;

function TVList.getCurrentVec: TimageVector;
begin
  if not assigned(currentVec.Vsource) or (currentVec.Vsource<>vectors[ligne1]) then
    if (ligne1>0) and (ligne1<=count)
      then currentVec.installSource(vectors[ligne1])
      else currentVec.installSource(nil);

  result:=currentVec;
end;


function TVlist.expandTree(tree:TtreeView;node:TtreeNode):boolean;
var
  i:integer;
begin
  {On reprend la version de typeUO en ajoutant Curvec au début de la liste}

  result:=true;
  if not assigned(childList) or (count=0) then exit;

  if (node.count>0) and (node[0].data=nil) and (node[0].text='Dummy') then
  begin
    node[0].delete;

    curVec.addToTree(tree,node);

    screen.Cursor:=crHourGlass;
    for i:=0 to childList.count-1 do
    begin
      typeUO(childList.items[i]).addToTree(tree,node);
      if testEscape then break;
    end;

    if node.count<>childList.Count+1 then
    begin
      node.DeleteChildren;
      tree.Items.addChildObject(node,'Dummy',nil);
      result:=false;
    end;

    screen.Cursor:=crDefault;
  end;
end;



{****************************** Méthodes STM **********************************}

var
  E_indice:integer;

procedure proTVList_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TVlist);
end;

procedure proTVList_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TVlist);
end;


procedure proTVList_AddVector(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(vec));
  verifierObjet(pu);

  TVlist(pu).addVector(vec);
end;

procedure proTVList_InsertVector(n:integer;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(vec));
  verifierObjet(pu);

  TVlist(pu).insertVector(n,vec);
end;


procedure proTVList_DeleteVector(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TVlist(pu).deleteVector(num);
end;

procedure proTVList_Clear(var pu:typeUO);
begin
  verifierObjet(pu);

  TVlist(pu).clear;
end;

function fonctionTVlist_V(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TVlist(pu) do
  begin
    ControleParam(i,1,count,E_indice);
    result:=@vectors[i].myAd;
  end;
end;

function fonctionTVlist_CurVec(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TVlist(pu) do
    result:=@curVec.myAd;
end;


procedure proTVList_MedianVector(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(vec));
  verifierObjet(pu);

  TVlist(pu).MedianVector(vec);
end;

procedure proTVList_UseVparams(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  TVlist(pu).UseVparams:=w;
end;

function fonctionTVList_UseVparams(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TVlist(pu).UseVparams;
end;

procedure proTVList_MaxVector(var vec:Tvector;var pu:typeUO);
var
  res: integer;
begin
  verifierObjet(pu);
  res:= TVlist(pu).OpVector(vec,1);
  case res of
    1: sortieErreur('TVlist.MaxVector : empty list');
    2: sortieErreur('TVlist.MaxVector : vectors must have the same Istart, Iend properties');
  end;
end;


procedure proTVList_MinVector(var vec:Tvector;var pu:typeUO);
var
  res: integer;
begin
  verifierObjet(pu);
  res:= TVlist(pu).OpVector(vec,2);
  case res of
    1: sortieErreur('TVlist.MinVector : empty list');
    2: sortieErreur('TVlist.MinVector : vectors must have the same Istart, Iend properties');
  end;
end;

procedure proTVList_MeanVector(var vec:Tvector;var pu:typeUO);
var
  res: integer;
begin
  verifierObjet(pu);
  res:= TVlist(pu).OpVector(vec,3);
  case res of
    1: sortieErreur('TVlist.MeanVector : empty list');
    2: sortieErreur('TVlist.MeanVector : vectors must have the same Istart, Iend properties');
  end;
end;

procedure proTVList_StdDevVector(var vec:Tvector;var pu:typeUO);
var
  res: integer;
begin
  verifierObjet(pu);
  res:= TVlist(pu).OpVector(vec,4);
  case res of
    1: sortieErreur('TVlist.StdDevVector : empty list');
    2: sortieErreur('TVlist.StdDevVector : vectors must have the same Istart, Iend properties');
  end;
end;




Initialization
AffDebug('Initialization VlistA1',0);

registerObject(TVlist,data);

installError(E_indice,'TVlist: index out of range');

end.
