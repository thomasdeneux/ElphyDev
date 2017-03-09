unit stmClist1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,controls,stdCtrls,comCtrls,forms,

     util1,Dgraphic,varconf1,debug0,listG,
     stmdef,stmObj,stmData0,stmvec1,stmcurs,stmPg;



type
  TauxRec=record
            curX:TLcursor;
            VevtX:Tvector;
          end;
  PauxRec=^TauxRec;

  tabVector=array[0..0] of Tvector;
  PtabVector=^tabVector;

  TcursorList=
    class(Tdata0)

    private
      cur:Tlist;
      cur0:TLcursor;

      FVevent:Tvector;      { Evénements }
      FVdisplay:Tvector;    { Vecteur sur lequel s'affichent les curseurs }
      FVzoom:Tvector;       { Zoom sur le curseur courant }

      oldVdisplay,oldVzoom,oldVevent:Tvector;
      oldXmin,oldXmax,oldYmin,oldYmax:float;

      Vselect:TlistG;
      FVaux:TlistG;

      i1cur,i2cur:integer; {indices début et fin des curseurs affichés}
      nbcur:integer;       {= i2cur-i1cur+1}


      curEv:integer;       {curseur courant
                            varie de Vevent.Istart à Vevent.Iend
                           }

      Fselect:boolean;     {en mode select,le curseur change de couleur
                            quand on clique dessus }
      FCurlocked:boolean;  {Empêche le déplacement des curseurs sur Vdisplay
                            Ne pas confondre avec Flocked utilisé par stimvis
                           }
      FshowCursors:boolean;{true par défaut, permet de ne pas afficher les curseurs}

      VeventB:Tvector;       {Les B permettent de recharger les références}
      VdisplayB:Tvector;
      VzoomB:Tvector;

      auxB:PtabVector;
      tailleAuxB:integer;

      Fforcer:boolean;

      procedure installVevent(ref:Tvector);
      procedure installZoom(ref:Tvector);
      procedure installDisplay(ref:Tvector);

      procedure setMaxCursor(n:integer);
      function getMaxCursor:integer;

      function getLcursor(n:integer):TLcursor;
      procedure preparePage(p:pointer);

      procedure setSelected(n:integer;b:boolean);
      function getSelected(n:integer):boolean;

      procedure TrackSource;
      procedure OnClkD(n:integer;shift:TshiftState);
      procedure OnClk0D(n:integer;shift:TshiftState);

      procedure setCur0;
      function curEvValid:boolean;

      procedure scrollEv(Sender: TObject;x:float;ScrollCode: TScrollCode);

      procedure setCurLocked(b:boolean);

      procedure setNames;


      function getVaux(n:integer):Tvector;
      function VAuxCount:integer;
      function getAuxCur(n:integer):TLcursor;

      property Vaux[n:integer]:Tvector read getVaux;
      property AuxCur[n:integer]:TLcursor read getAuxCur;

      procedure setCurEv(n:integer);

    public
      color1:integer;      {couleur curseur sélectionné}
      color2:integer;      {couleur autres curseurs}

      Rcolor1:integer;     {couleur caption curseur courant}
      Rcolor2:integer;     {couleur caption autres curseurs}

      nbdeci:integer;
      FautoZoom:boolean;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;
      procedure FreeRef;override;

      procedure createForm;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      function initialise(st:AnsiString):boolean;override;
      procedure RetablirReferences(list:Tlist);override;
      procedure resetAll;override;


      procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;

      property MaxCursor:integer read getMaxCursor write setMaxCursor;
      property cursor[n:integer]:TLcursor read getLcursor;
      property Selected[n:integer]:boolean read getSelected write setSelected;

      procedure updateForm;
      property LockedCursors:boolean read Fcurlocked write setCurLocked;

      procedure deleteCursor;
      procedure DndAdd(x,y:float);

      property Vevent:Tvector read FVevent write installVevent ;
      property Vdisplay:Tvector read FVdisplay write installDisplay ;
      property Vzoom:Tvector read FVzoom write installZoom ;

      procedure invalidate;override;
      procedure selectAll;
      procedure unselectAll;
      procedure proprietes(sender:Tobject);override;

      procedure installAux(ref:Tvector);
      procedure RemoveAux(vec:Tvector);
      procedure FreeAux;


      procedure addToTree(tree:TtreeView;node:TtreeNode);override;
      function expandTree(tree:TtreeView;node:TtreeNode):boolean;override;
    end;


procedure proTcursorList_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTcursorList_create_1(var pu:typeUO);pascal;
procedure proTcursorList_installVevent(var v:Tvector;var pu:typeUO);pascal;
procedure proTcursorList_installVDisplay(var v:Tvector;var pu:typeUO);pascal;
procedure proTcursorList_installVZoom(var v:Tvector;var pu:typeUO);pascal;

procedure proTcursorList_installVaux(var v:Tvector;var pu:typeUO);pascal;

procedure proTcursorList_Selected(n:integer;b:boolean;var pu:typeUO);pascal;
function fonctionTcursorList_Selected(n:integer;var pu:typeUO):boolean;pascal;

procedure proTcursorList_Index(n:integer;var pu:typeUO);pascal;
function fonctionTcursorList_Index(var pu:typeUO):integer;pascal;
procedure proTcursorList_DeleteCurrent(var pu:typeUO);pascal;

implementation

uses ClistForm1,stmClistProp;

constructor TcursorList.create;
begin
  inherited;
  cur:=Tlist.create;
  Vselect:=TlistG.create(1);
  FVaux:=TlistG.create(sizeof(TauxRec));

  maxCursor:=100;

  color1:=clRed;
  color2:=clGreen;

  Rcolor1:=clLime;
  Rcolor2:=clBlack;

  nbdeci:=3;
  FshowCursors:=true;
  FautoZoom:=true;
  FCurlocked:=true;
end;

destructor TcursorList.destroy;
var
  i:integer;
begin
  installVevent(nil);
  installZoom(nil);
  installDisplay(nil);

  FreeAux;

  with cur do
  for i:=0 to count-1 do TLcursor(items[i]).free;

  cur.free;
  Vselect.free;

  cur0.free;
  inherited;
end;

procedure TcursorList.FreeRef;
begin
  installVevent(nil);
  installZoom(nil);
  installDisplay(nil);

  FreeAux;
end;

procedure TcursorList.FreeAux;
var
  i:integer;
begin
  for i:=0 to FVaux.count-1 do
    with PauxRec(Fvaux[i])^ do
    begin
      derefObjet(typeUO(VevtX));
      curX.Free;
    end;
end;

procedure TcursorList.RemoveAux(vec:Tvector);
var
  i:integer;
begin
  for i:=0 to FVaux.count-1 do
    with PauxRec(Fvaux[i])^ do
    if VevtX=vec then
    begin
      derefObjet(typeUO(VevtX));
      curX.Free;
      VevtX:=nil;
      curX:=nil;
    end;
  FVaux.pack;

  for i:=0 to FVaux.count-1 do
    AuxCur[i].tagUO:=i+1;
end;


procedure TcursorList.installAux(ref:Tvector);
var
  i:integer;
  rec:TauxRec;
begin
  if ref=nil then exit;
  for i:=0 to FVaux.count-1 do
    if Vaux[i]=ref then exit;

  with rec do
  begin
    curX:=TLcursor.create;
    with curX do
    begin
      ident:=self.ident+'.C0'+Istr(VauxCount);
      Fchild:=true;
      notPublished:=true;
      installsource(Vzoom);
      rec.color:=clRed;
      rec.visible:=true;
      Fonclick:=OnClk0D;
      tagUO:=VauxCount+1;
    end;
    VevtX:=ref;
  end;
  Fvaux.add(@rec);
  refObjet(ref);

end;

function TcursorList.getVaux(n:integer):Tvector;
begin
  result:=PauxRec(Fvaux[n])^.VevtX;
end;

function TcursorList.getAuxCur(n:integer):TLcursor;
begin
  result:=PauxRec(Fvaux[n])^.curX;
end;

function TcursorList.VAuxCount:integer;
begin
  result:=FVaux.Count;
end;


class function TcursorList.stmClassName:AnsiString;
begin
  result:='CursorList';
end;

procedure TcursorList.createForm;
begin
  form:=TClistForm.create(formStm);
  with TClistForm(form) do
  begin
    caption:=ident;

    install(self);

    if assigned(Vevent)
      then SBindex.setParams(curEv,Vevent.Istart,Vevent.Iend);
    SBindex.OnScrollV :=ScrollEv;

    cbSelect.setvar(Fselect);
    cbLocked.setvar(Fcurlocked);
    cbShowCursors.setvar(FshowCursors);

  end;

end;

procedure TcursorList.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
var
  i:integer;
begin
  if lecture then
    begin
      conf.setvarConf('Vevent',Veventb,sizeof(Vevent));
      conf.setvarConf('Vdisplay',Vdisplayb,sizeof(Vdisplay));
      conf.setvarConf('Vzoom',Vzoomb,sizeof(Vzoom));
      conf.setDynConf('VAux',AuxB,tailleAuxB);
    end
  else
    begin
      conf.setvarConf('Vevent',FVevent,sizeof(FVevent));
      conf.setvarConf('Vdisplay',FVdisplay,sizeof(FVdisplay));
      conf.setvarConf('Vzoom',FVzoom,sizeof(FVzoom));

      tailleAuxB:=FVaux.count*sizeof(pointer);
      reallocmem(AuxB,tailleAuxB);
      for i:=0 to FVaux.count-1 do  auxB^[i]:=PauxRec(FVaux[i])^.VevtX;
      conf.setDynConf('VAux',AuxB,tailleAuxB);
    end;

end;


function TcursorList.initialise(st:AnsiString):boolean;
begin
  result:=inherited initialise(st);
end;

procedure TcursorList.RetablirReferences(list:Tlist);
var
  i,j:integer;
  V1,V2,V3:Tvector;
  p:typeUO;
  px:array of Tvector;
  nbx:integer;
begin
  V1:=nil;
  V2:=nil;
  V3:=nil;

  nbx:=tailleAuxB div 4;
  setlength(px,nbx);
  fillchar(px[0],nbx*4,0);

  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=VeventB then V1:=list.items[i];
     if p=VdisplayB then V2:=list.items[i];
     if p=VzoomB then V3:=list.items[i];

     for j:=0 to nbx-1 do
     if p=auxB^[j] then px[j]:=list.items[i];
    end;

  VeventB:=v1;
  VdisplayB:=v2;
  VzoomB:=v3;

  for j:=0 to nbx-1 do AuxB^[j]:=px[j];
end;

procedure TcursorList.resetAll;
var
  i:integer;
begin
  Vevent:=VeventB;
  Vdisplay:=VdisplayB;
  Vzoom:=VzoomB;

  for i:=0 to tailleAuxB-1 do
    if assigned(auxB^[i]) then installAux(auxB^[i]);
end;



procedure TcursorList.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if Vevent=source then installVevent(nil);
        if Vdisplay=source then installDisplay(nil);
        if Vzoom=source then installZoom(nil);

        removeAux(Tvector(source));
      end;
    UOmsg_invalidate,UOmsg_invalidateData:
      begin
        if Vevent=source then  invalidate;
      end;
  end;
end;


procedure TcursorList.preparePage(p:pointer);
var
  i,k:integer;
  flag:boolean;
begin
  if not assigned(Vdisplay) then exit;
  if not assigned(Vevent) then exit;

  if not Fforcer and
     (Vdisplay=oldVdisplay) and  (Vevent=oldVevent) and
     (oldXmin=Vdisplay.Xmin) and (oldXmax=Vdisplay.Xmax) and
     (oldYmin=Vdisplay.Ymin) and (oldYmax=Vdisplay.Ymax)
     then exit;
  Fforcer:=false;

  if curEv<Vevent.Istart then curEv:=Vevent.Istart;
  if curEv>Vevent.Iend then curEv:=Vevent.Iend;

  if Vselect.count<>Vevent.Iend-Vevent.Istart+1 then
    begin
      Vselect.count:=Vevent.Iend-Vevent.Istart+1;
      Vselect.fill(0);
    end;

  i1cur:=Vevent.getFirstEvent(Vdisplay.Xmin);
  i2cur:=Vevent.getFirstEvent(Vdisplay.Xmax)-1;
  nbCur:=i2cur-i1cur+1;

  flag:=nbcur>maxCursor;
  if flag then nbcur:=maxCursor;

  if assigned(form) then
    with TClistForm(form) do
    begin
      if flag
        then Pcount.font.color:=clRed
        else Pcount.font.color:=clBlack;
      Pcount.caption:=Istr(nbcur);
    end;

  if not FshowCursors and not cursor[0].rec.visible then exit;

  for i:=0 to nbcur-1 do
    with cursor[i] do
    begin
      k:=i1cur+i;
      position[1]:=Vevent.Yvalue[k];
      if selected[k]
        then rec.color:=color1
        else rec.color:=color2;
      rec.visible:=FshowCursors;
      rec.CapColor:=Rcolor2;
      {Finvalidate2;}
      rec.curlocked:=Fcurlocked;
    end;

  for i:=nbcur to maxCursor-1 do
    with cursor[i] do
    begin
      rec.visible:=false;
      {Finvalidate2;}
    end;

  k:=curEv-I1cur;
  if (k>=0) and (k<maxCursor) then
  begin
    cursor[k].rec.CapColor:=Rcolor1;
    {cursor[k].Finvalidate2;}
  end;

  oldVdisplay:=Vdisplay;
  oldVevent:=Vevent;
  oldXmin:=Vdisplay.Xmin;
  oldXmax:=Vdisplay.Xmax;
  oldYmin:=Vdisplay.Ymin;
  oldYmax:=Vdisplay.Ymax;

end;

procedure TcursorList.installVevent(ref:Tvector);
var
  i:integer;
begin
  if ref=FVevent then exit;

  derefObjet(typeUO(FVevent));
  FVevent:=ref;
  refObjet(typeUO(FVevent));

  Vselect.clear;
  if assigned(FVevent) then
    begin
      Vselect.count:=Vevent.Iend-Vevent.Istart+1;
      Vselect.fill(0);
      preparePage(nil);
    end;

  if assigned(FVevent)
    then curEv:=Vevent.Istart
    else curEv:=0;
end;

procedure TcursorList.installZoom(ref:Tvector);
var
  i:integer;
begin
  if ref=FVzoom then exit;

  derefObjet(typeUO(FVzoom));
  FVzoom:=ref;
  refObjet(typeUO(FVzoom));

  if assigned(FVzoom) then
    begin
      if not assigned(cur0) then cur0:=TLcursor.create;
      with cur0 do
      begin
        ident:=self.ident+'.C0';
        Fchild:=true;
        notPublished:=true;
        installsource(Vzoom);
        rec.visible:=true;
        Fonclick:=OnClk0D;
      end;
      for i:=0 to VauxCount-1 do
      with AuxCur[i] do
      begin
        ident:=self.ident+'.C0'+Istr(i);
        Fchild:=true;
        notPublished:=true;
        installsource(Vzoom);
        rec.visible:=true;
        Fonclick:=OnClk0D;
      end;
    end
  else
    begin
      cur0.free;
      cur0:=nil;
    end;

  setcur0;
end;

procedure TcursorList.installDisplay(ref:Tvector);
var
  i:integer;
begin
  if ref=FVdisplay then exit;

  derefObjet(typeUO(FVdisplay));
  if assigned(FVdisplay) then FVdisplay.Fondisplay:=nil;

  FVdisplay:=ref;
  if assigned(FVdisplay) then FVdisplay.Fondisplay:=preparePage;
  refObjet(typeUO(FVdisplay));

  for i:=0 to maxCursor-1 do
  with cursor[i] do installSource(FVdisplay);

  preparePage(nil);
end;

procedure TcursorList.setMaxCursor(n:integer);
var
  i:integer;
  cc:TLcursor;
begin
  for i:=cur.count to n-1 do
    begin
       cc:=TLcursor.create;
       with cc do
       begin
         ident:=self.ident+'.C'+Istr(i+1);
         Fchild:=true;
         notPublished:=true;
         tagUO:=cur.count;
         FonClick:=OnClkD;
       end;
       cur.add(cc);
    end;

  for i:=n to cur.count-1 do TLcursor(cur.items[i]).free;
  cur.count:=n;
end;

function TcursorList.getMaxCursor:integer;
begin
  if assigned(cur)
    then result:=cur.count
    else result:=0;
end;

function TcursorList.getLcursor(n:integer):TLcursor;
begin
  result:=TLcursor(cur[n]);
end;

procedure TcursorList.setSelected(n:integer;b:boolean);
begin
  if assigned(Vevent) and (n>=Vevent.Istart) and (n<=Vevent.Iend) then
    Pboolean(Vselect[n-Vevent.Istart])^:=b;
end;

function TcursorList.getSelected(n:integer):boolean;
begin
  if assigned(Vevent) and (n>=Vevent.Istart) and (n<=Vevent.Iend)
    then result:=Pboolean(Vselect[n-Vevent.Istart])^
    else result:=false;
end;

procedure TcursorList.TrackSource;
var
  x,delta:float;
begin
  if (Vevent=nil) or (Vdisplay=nil) then exit;

  x:=Vevent.Yvalue[curEv];

  with Vdisplay do
  begin
    if x<Xmin then
      begin
        delta:=Xmax-Xmin;
        while x<Xmin do
        begin
          Xmin:=Xmin-delta;
          Xmax:=Xmax-delta;
        end;
        invalidate;
      end
    else
    if x>Xmax then
      begin
        delta:=Xmax-Xmin;
        while x>Xmax do
        begin
          Xmin:=Xmin+delta;
          Xmax:=Xmax+delta;
        end;
        invalidate;
      end;
  end;
end;

procedure TcursorList.OnClkD(n:integer;shift:TshiftState);
var
  delta:float;
  i:integer;
begin
  CurEv:=I1cur+n;

  for i:= 0 to I2cur-I1cur do cursor[i].rec.CapColor:=Rcolor2;
  cursor[n].rec.CapColor:=Rcolor1;


  if Fselect or (ssCtrl in shift) then
    begin
      Selected[curEv]:=not Selected[curEv];
      if Selected[curEv]
        then cursor[n].rec.color:=color1
        else cursor[n].rec.color:=color2;
    end;
  for i:= 0 to I2cur-I1cur do cursor[i].Finvalidate2;

  Vevent.Yvalue[curEv]:=cursor[n].position[1];
  Vevent.invalidate;

  setCur0;

  updateForm;
end;

function TcursorList.curEvValid:boolean;
begin
  result:=assigned(Vevent) and
          (curEv>=Vevent.Istart) and (curEv<=Vevent.Iend);
end;

procedure TcursorList.OnClk0D(n:integer;shift:TshiftState);
begin
  if not curEvValid then exit;

  if n=0 then
    begin
      Vevent.Yvalue[curEv]:=cur0.position[1];
      Vevent.invalidate;
      setCur0;
      updateForm;
    end
  else
    if n<=VauxCount then
    with Pauxrec(Fvaux[n-1])^ do
    begin
      VevtX.Yvalue[curEv]:=curX.position[1];

    end;
end;


procedure TcursorList.setCur0;
var
  x,delta:real;
  i:integer;
begin
  if assigned(Vevent) then
    begin
      if curEv<Vevent.Istart then curEv:=Vevent.Istart;
      if curEv>Vevent.Iend then curEv:=Vevent.Iend;
    end;

  if not assigned(Vevent) or not assigned(Vzoom) or not CurEvValid
    then exit;

  x:=Vevent.Yvalue[curEv];

  cur0.position[1]:=x;
  with Vzoom do
  begin
    delta:=Xmax-Xmin;
    Xmin:=x-delta/2;
    Xmax:=Xmin+delta;
    if FautoZoom then autoscaleY1;
    invalidate;
  end;

  for i:=0 to VauxCount-1 do
  with PauxRec(FVaux[i])^ do
  begin
    if curEv<=VevtX.Iend then
      curX.position[1]:=VevtX.Yvalue[curEv];
  end;
end;

procedure TcursorList.scrollEv(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  n,old:integer;
begin
  old:=curEv;
  curEv:=roundL(x);

  if curEvValid then
    with TClistForm(form) do
    begin
      Pindex.caption:=Istr(curEv);
      Pvalue.caption:=Estr(Vevent.Yvalue[curEv],nbdeci);

      n:=old-I1cur;
      if (n>=0) and (n<maxCursor) then
        begin
          self.cursor[n].rec.capColor:=Rcolor2;
          self.cursor[n].Finvalidate2;
        end;

      n:=curEv-I1cur;
      if (n>=0) and (n<maxCursor) then
        begin
          self.cursor[n].rec.capColor:=Rcolor1;
          self.cursor[n].Finvalidate2;
        end;

      setCur0;

      if not (scrollCode in [scTrack]) then trackSource;
    end
  else curEv:=old;
end;

procedure TcursorList.setCurEv(n:integer);
begin
  scrollEv(self,n,scPosition);
end;


procedure TcursorList.updateForm;
begin
  if assigned(form) and curEvValid then
    with TClistForm(form) do
    begin
      Pindex.caption:=Istr(curEv);
      Pvalue.caption:=Estr(Vevent.Yvalue[curEv],nbdeci);

      SBindex.setParams(curEv,Vevent.Istart,Vevent.Iend);
    end;
end;

procedure TcursorList.setCurLocked(b:boolean);
var
  i:integer;
begin
  Fcurlocked:=true;
  for i:=0 to maxCursor-1 do cursor[i].rec.curLocked :=b;
end;

procedure TcursorList.deleteCursor;
var
  i:integer;
begin
  if curEvValid then
    begin
      Vevent.removeFromList(curEv);
      for i:=0 to VauxCount-1 do
        Vaux[i].removeFromList(curEv);

      if curEv>Vevent.Iend then dec(curEv);

      trackSource;

      setCur0;
      Vevent.invalidate;
    end;
end;


procedure TcursorList.DndAdd(x,y:float);
var
  i,j:integer;
  bb:boolean;
begin
  with Vevent do
  begin
    i:=getFirstEvent(x);
    insertIntoList(i,x);

    for j:=0 to VauxCount-1 do
      Vaux[j].insertIntoList(i,x);
  end;

  bb:=false;
  Vselect.insert(i-Vevent.Istart,@bb);

  CurEv:=i;

  setCur0;
  updateForm;

  Vevent.invalidate;
end;

procedure TcursorList.invalidate;
begin
  Fforcer:=true;
  preparePage(nil);
  setCur0;
  updateForm;
end;

procedure TcursorList.selectAll;
var
  i:integer;
begin
  if Vevent=nil then exit;

  for i:=Vevent.Istart to Vevent.Iend do selected[i]:=true;
  invalidate;
end;

procedure TcursorList.unselectAll;
var
  i:integer;
begin
  if Vevent=nil then exit;
  for i:=Vevent.Istart to Vevent.Iend do selected[i]:=false;
  invalidate;
end;

procedure TcursorList.proprietes(sender:Tobject);
begin
  if ClistProp.execution(self) then invalidate;
end;

procedure TcursorList.setNames;
var
  i:integer;
begin
  for i:=0 to maxCursor-1 do
    cursor[i].ident:=ident+'.C'+Istr(i+1);
end;

procedure TcursorList.addToTree(tree:TtreeView;node:TtreeNode);
var
  p:TtreeNode;
begin
  p:=tree.Items.addChildObject(node,ident,self);
  tree.Items.addChildObject(p,'Dummy',nil) { on ajoute un élément bidon pour afficher une case "+" }
end;

function TcursorList.expandTree(tree:TtreeView;node:TtreeNode):boolean;
var
  i:integer;
begin
  result:=true;
  if not assigned(cur) or (cur.count=0) then exit;

  if (node.count>0) and (node[0].data=nil) and (node[0].text='Dummy') then
  begin
    node[0].delete;

    screen.Cursor:=crHourGlass;
    for i:=0 to cur.count-1 do
    begin
      typeUO(cur.items[i]).addToTree(tree,node);
      if testEscape then break;
    end;

    if node.count<>cur.Count then
    begin
      node.DeleteChildren;
      tree.Items.addChildObject(node,'Dummy',nil);
      result:=false;
    end;

    screen.Cursor:=crDefault;
  end;
end;


{******************** Méthodes STM ******************************************}

procedure proTcursorList_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TcursorList);

  with TcursorList(pu) do
  begin
    setNames;
  end;
end;

procedure proTcursorList_create_1(var pu:typeUO);
begin
  proTcursorList_create('',pu);
end;

procedure proTcursorList_installVevent(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TcursorList(pu) do installVevent(v);
end;

procedure proTcursorList_installVDisplay(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TcursorList(pu) do installDisplay(v);
end;

procedure proTcursorList_installVZoom(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  {verifierObjet(typeUO(v));}

  with TcursorList(pu) do installZoom(v);
end;

procedure proTcursorList_installVaux(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TcursorList(pu) do installAux(v);
end;

procedure proTcursorList_Selected(n:integer;b:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TcursorList(pu) do Selected[n]:=b;
end;

function fonctionTcursorList_Selected(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);

  with TcursorList(pu) do
  result:=Selected[n];
end;

procedure proTcursorList_Index(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TcursorList(pu).SetCurEv(n);
end;


function fonctionTcursorList_Index(var pu:typeUO):integer;
begin
  verifierObjet(pu);

  result:=TcursorList(pu).curEv;
end;

procedure proTcursorList_DeleteCurrent(var pu:typeUO);
begin
  verifierObjet(pu);

  TcursorList(pu).DeleteCursor;
end;


Initialization
AffDebug('Initialization stmClist1',0);

registerObject(TcursorList,data);

end.
