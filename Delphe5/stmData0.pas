unit stmData0;


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,

     util1,Dgraphic,varconf1,formRec0,debug0,
     stmDef,stmObj,defForm,getVect0;



{ Tdata0 est le type de base pour tous les objets data:
  TdataObj, Tvector, Tpsth, Tmatrix,
  TdataFile, TrealArray...

  Il est appelé TWINOBJECT dans Elphy

  Ils contiennent tous un objet Tform. Cette fiche doit être sauvée et
  restituée convenablement.

  TformRec est un enregistrement destiné à sauver la fiche.


  completeLoadInfo pose un pb si la form affiche des références. Il faut en effet
  appeler recupForm dans resetAll plutot que dans completeLoadInfo.
}


type
  TData0= class(typeUO)
          protected

             modifiedData:boolean;
             // modifiedData devrait être positionné à true à chaque modification des données
             // de cette façon, Invalidate appelle InvalidateData
             FBKcolor:Tcolor;
             Fembedded:boolean;

             procedure setBKcolor(w:Tcolor);virtual;

             procedure setWinLeft(w:integer);
             function getWinLeft:integer;

             procedure setWinTop(w:integer);
             function getWinTop:integer;

             procedure setWinWidth(w:integer);virtual;
             function getWinWidth:integer;virtual;

             procedure setWinHeight(w:integer);virtual;
             function getWinHeight:integer;virtual;

             procedure setIdent(st:AnsiString);override;

          public
                 form:Tform;
                 FormRec:Tformrec;  {ne sert que pour la sauvegarde}
                 CanDestroyForm:boolean; {Vaut true par défaut. Indique que la
                                          form sera détruite pendant Destroy}


                 constructor create;override;
                 destructor destroy;override;  { toujours appeler inherited}
                 procedure createForm;virtual; { surcharger et créer la forme }
                 procedure show(sender:Tobject);override;
                 procedure showModal;
                                               { ok:surcharge inutile en général}
                 procedure recupForm;          { completeLoadInfo doit appeler
                        {recupForm après mise en place de certains paramètres }
                 procedure recupFormXY;
                        {ou bien recupFormXY qui oublie les dimensions de la fiche}

                 function DialogForm:TclassGenForm;override; {ok}
                 procedure installDialog(var form:Tgenform;var newF:boolean);
                                  override;                  {ok}

                 procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                   override;                   { toujours appeler inherited}

                 procedure CompleteLoadInfo;override;

                 function getWindowHandle:integer;override;

                 procedure invalidate;override;
                 procedure invalidateData;virtual;

                 procedure invalidateForm;virtual;
                 procedure invalidateForm2;virtual;

                 procedure invalidateExceptMG0;virtual;

                 procedure proprietes(sender:Tobject);virtual; {vide}

                 property BKcolor:Tcolor read FBKcolor write setBKcolor;
                 property winTop:integer read getWintop write setWinTop;
                 property winLeft:integer read getWinLeft write setWinLeft;
                 property winWidth:integer read getWinWidth write setWinWidth;
                 property winHeight:integer read getWinHeight write setWinHeight;

                 procedure setEmbedded(v:boolean);override;
                 function getEmbedded:boolean;override;

              end;


procedure proTwinObject_show(var pu:typeUO);pascal;
procedure proTwinObject_hide(var pu:typeUO);pascal;
procedure proTwinObject_invalidate(var pu:typeUO);pascal;

procedure proTwinObject_WinTop(w:integer;var pu:typeUO);pascal;
function fonctionTwinObject_WinTop(var pu:typeUO):integer;pascal;

procedure proTwinObject_WinLeft(w:integer;var pu:typeUO);pascal;
function fonctionTwinObject_WinLeft(var pu:typeUO):integer;pascal;

procedure proTwinObject_WinWidth(w:integer;var pu:typeUO);pascal;
function fonctionTwinObject_WinWidth(var pu:typeUO):integer;pascal;

procedure proTwinObject_WinHeight(w:integer;var pu:typeUO);pascal;
function fonctionTwinObject_WinHeight(var pu:typeUO):integer;pascal;

procedure proTwinObject_BKcolor(w:integer;var pu:typeUO);pascal;
function fonctionTwinObject_BKcolor(var pu:typeUO):integer;pascal;

IMPLEMENTATION


{****************** Méthodes de TData0 *****************************}

constructor Tdata0.create;
begin
  inherited;
  CanDestroyForm:=true;
  FBKcolor:=DefBKcolor;
end;

destructor Tdata0.destroy;
begin
  if CanDestroyForm then form.free;
  form:=nil;
  inherited destroy;
end;

procedure Tdata0.setIdent(st:AnsiString);
begin
  inherited;
  if assigned(form) then form.caption:=st;
end;

procedure Tdata0.createForm;
begin
end;

procedure Tdata0.show(sender:Tobject);
begin
  if not assigned(form) then createForm;

  if assigned(form) and not Embedded then form.show;
end;

procedure Tdata0.showModal;
begin
  if not assigned(form) then createForm;

  if assigned(form) and not Embedded then form.showModal;
end;


procedure Tdata0.recupForm;
begin
   formRec.restoreForm(form,createForm);
end;

procedure Tdata0.recupFormXY;
begin
  formRec.restoreFormXY(form,createForm);
end;


function Tdata0.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetVector;
end;

procedure Tdata0.installDialog(var form:Tgenform;var newF:boolean);
  begin
    installForm(form,newF);

    TgetVector(Form).onshowD:=show;
  end;



procedure Tdata0.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  if not lecture and assigned(form) then FBKcolor:=form.color;

  inherited buildInfo(conf,lecture,tout);

  conf.setvarConf('BKcolor',FBKcolor,sizeof(FBKcolor));

  formRec.setForm(form);
  if tout then
    with conf do setvarconf('FormRec',FormRec,sizeof(FormRec));
end;

procedure Tdata0.CompleteLoadInfo;
begin
  inherited CompleteLoadInfo;

  recupForm;
  if assigned(form) then form.color:=FBKcolor;
end;

function Tdata0.getWindowHandle:integer;
begin
  if assigned(form) and (form.visible)
    then  getWindowHandle:=form.handle
    else  getWindowHandle:=0;
end;

procedure Tdata0.invalidate;
begin
  invalidateForm;
  messageToRef(UOmsg_invalidate,nil);
end;

procedure Tdata0.invalidateData;
begin
  invalidateForm;
  messageToRef(UOmsg_invalidateData,nil);
  ModifiedData:=false;
end;


procedure Tdata0.invalidateExceptMG0;
var
  i:integer;
  p:typeUO;
begin
  for i:=0 to refcount-1 do
  begin
    p:=typeUO(reference.items[i]);
    if p<>dacMultigraph then p.ProcessMessage(UOmsg_invalidateData,self,nil);
  end;
end;


procedure Tdata0.invalidateForm;
begin
  if assigned(form) then form.invalidate;
end;

procedure Tdata0.invalidateForm2;
begin
end;


procedure Tdata0.proprietes(sender:Tobject);
begin
end;

procedure TData0.setBKcolor(w: Tcolor);
begin
  FBKcolor:=w;
  if assigned(form) then form.Color:=w;
end;

function TData0.getWinHeight: integer;
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then result:=form.Height
    else result:=0;
end;

function TData0.getWinLeft: integer;
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then result:=form.Left
    else result:=0;
end;

function TData0.getWinTop: integer;
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then result:=form.Top
    else result:=0;
end;

function TData0.getWinWidth: integer;
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then result:=form.Width
    else result:=0;
end;

procedure TData0.setWinHeight(w: integer);
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then form.Height:=w;
end;

procedure TData0.setWinLeft(w: integer);
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then form.Left:=w;
end;

procedure TData0.setWinTop(w: integer);
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then form.Top:=w;
end;

procedure TData0.setWinWidth(w: integer);
begin
  if not assigned(form) then createForm;
  if assigned(form)
    then form.Width:=w;
end;

function TData0.getEmbedded: boolean;
begin
  result:=Fembedded;
end;

procedure TData0.setEmbedded(v: boolean);
begin
 Fembedded:=false; {refusé en général}
end;


{*************************** Méthodes STM *************************************}

procedure proTwinObject_show(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdata0(pu) do show(nil);
end;

procedure proTwinObject_hide(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdata0(pu) do
    if assigned(form) then form.hide;
end;

procedure proTwinObject_invalidate(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdata0(pu) do invalidateData;
end;


procedure proTwinObject_WinTop(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdata0(pu).winTop:=w;
end;

function fonctionTwinObject_WinTop(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tdata0(pu).winTop;
end;

procedure proTwinObject_WinLeft(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdata0(pu).winLeft:=w;
end;

function fonctionTwinObject_WinLeft(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tdata0(pu).winLeft;
end;


procedure proTwinObject_WinWidth(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdata0(pu).winWidth:=w;
end;

function fonctionTwinObject_WinWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tdata0(pu).winWidth;
end;


procedure proTwinObject_WinHeight(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdata0(pu).winHeight:=w;
end;

function fonctionTwinObject_WinHeight(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tdata0(pu).winHeight;
end;

procedure proTwinObject_BKcolor(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdata0(pu).BKcolor:=w;
end;

function fonctionTwinObject_BKcolor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tdata0(pu).BKcolor;
end;



end.
