unit stmPlot1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,classes,graphics,forms,controls,menus,

     util1, Dgraphic, varconf1,
     stmDef,stmObj,stmData0,stmPopUp,stmPG,
     tpForm0;


{ TPlot est le type de base pour tous les objets qui peuvent être glissés de
  l'inspecteur d'objets vers une fenêtre multigraph

  La plupart des méthodes sont vides.

  Initialise range ident dans title.
  getInsideWindow renvoie tout le cadre

  createForm crée une form du type Tpform
  InvalidateForm invalide la form de type TPform

  Il faut surcharger les DEUX METHODES en meme temps. SINON DANGER !

  BuildInfo contient seulement Title
  getTitleColor renvoie ClBlack

  displayInside appelle Display
}

type
  Tplot= class(Tdata0)

         protected
           title0:AnsiString;
           OnMgClick:Tpg2Event;

           function getTitle:AnsiString;override;
           procedure setTitle(st:AnsiString);override;

         public

           procedure createForm;override;

           procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
             override;

           function getPopUp:TpopupMenu;override;

           function GbeginDrag:boolean;

           procedure invalidateForm;override;
           procedure invalidateForm2;override;


           function Plotable:boolean;override;
           function withInside:boolean;override;

           function MouseDownMG(numOrdre:integer;Irect:Trect;
                        Shift: TShiftState;Xc,Yc,X,Y: Integer):boolean; override;
           function MouseMoveMG(x,y:integer):boolean; override;
           procedure MouseUpMG(x,y:integer; mg:typeUO); override;
           function HasMgClickEvent:boolean;override;
         end;



{***************** Déclarations STM pour Tplot ******************************}

procedure proTplot_show(var pu:typeUO); pascal;

procedure proTplot_invalidate(var pu:typeUO);pascal;
procedure proTplot_refresh(var pu:typeUO);pascal;

function fonctionTplot_Title(var pu:typeUO):AnsiString;pascal;
procedure proTplot_Title(x:AnsiString;var pu:typeUO);pascal;

procedure proTplot_resetUserPopUp(var pu:typeUO);pascal;
procedure proTplot_AddUserPopUpItem(st:AnsiString; ad:integer; var pu:typeUO);pascal;

procedure proTPlot_OnMgClick(p:integer;var pu:typeUO);pascal;
function fonctionTPlot_OnMgClick(var pu:typeUO):integer;pascal;


IMPLEMENTATION


{****************** Méthodes de Tplot *****************************}


function Tplot.getTitle:AnsiString;
begin
  if title0=''
    then result:= ident
    else result:= title0;
end;

procedure Tplot.setTitle(st:AnsiString);
begin
  if st=ident
    then title0:=''
    else title0:=st;
end;


procedure Tplot.createForm;
begin
  form:=TpForm.create(FormStm);
  with TpForm(form) do
  begin
    beginDragG:=GbeginDrag;
    {coordinates1.onclick:=ChooseCoo;
    Dproperties:=proprietes;}
    caption:=ident;
    color:=BKcolor;
    Uplot:=self;
  end;
end;



procedure Tplot.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  with conf do
  begin
    setStringConf('PlotTitle',title0);
  end;
end;


function TPlot.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin

    PopUpItem(pop_TPlot,'TPlot_Show').onClick:=self.Show;
    PopUpItem(pop_TPlot,'TPlot_Properties').onClick:=Proprietes;
    PopUpItem(pop_TPlot,'TPlot_Clone').onClick:=CreateClone;

    result:=pop_TPlot;
  end;
end;

function Tplot.GbeginDrag:boolean;
begin
  DragUOsource:=self;    
  DraggedUO:=self;
  result:=true;
end;

procedure Tplot.invalidateForm;
begin
  if assigned(form) then
    if form is TPform then TPform(form).invalidate
    else form.Invalidate;
end;

procedure Tplot.invalidateForm2;
begin
  if assigned(form) then
    if form is TPform then TPform(form).invalidate2
    else form.Invalidate;
end;


function Tplot.Plotable:boolean;
begin
  result:=true;
end;

function Tplot.withInside:boolean;
begin
  result:=true;
end;

function TPlot.MouseDownMG(numOrdre:integer;Irect:Trect;
            Shift: TShiftState;Xc,Yc,X,Y: Integer):boolean;
begin
  result:= onMgClick.valid;
end;

function TPlot.MouseMoveMG(x,y:integer):boolean;
begin
  result:= OnMgClick.valid;
end;

procedure TPlot.MouseUpMG(x,y:integer; mg:typeUO);
begin
  if OnMgClick.valid  and assigned(mg) then
    onMgClick.Pg.executerMouseUpMg(OnMgClick.Ad,Mg,typeUO(self));
end;

function Tplot.HasMgClickEvent: boolean;
begin
  result:= OnMgClick.valid;
end;


{***************** Méthodes STM pour Tplot ****************************}


procedure proTplot_show(var pu:typeUO);
  begin
    verifierObjet(pu);
    Tplot(pu).show(nil);
  end;

procedure proTplot_invalidate(var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tplot(pu) do
    begin
      if ModifiedData
        then invalidateData
        else invalidate;
    end;
  end;

procedure proTplot_refresh(var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tplot(pu) do
    begin
      if assigned(form) then form.refresh;
      messageToRef(UOmsg_invalidate,nil);
      updateAff;
    end;
  end;



function fonctionTplot_Title(var pu:typeUO):AnsiString;
  begin
    verifierObjet(pu);
    fonctionTplot_Title:=Tplot(pu).title;
  end;

procedure proTplot_Title(x:AnsiString;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tplot(pu).title:=x;
  end;


procedure proTplot_resetUserPopUp(var pu:typeUO);
begin
  verifierObjet(pu);
  pu.resetUserPopUp;
end;


procedure proTplot_AddUserPopUpItem(st:AnsiString; ad:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  pu.AddUserPopUpItem(st,ad);
end;

procedure proTPlot_OnMgClick(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TPlot(pu).onMgClick do setAd(p);
end;

function fonctionTPlot_OnMgClick(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TPlot(pu).OnMgClick.ad;
end;




end.
