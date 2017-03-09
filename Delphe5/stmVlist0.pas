unit stmVlist0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,controls,graphics,menus,forms,
     util1,Dgraphic,varconf1,debug0,NcDef2,
     stmdef,stmObj,visu0,stmDplot,stmVec1,stmPopup,formRec0,stmError,
     tpForm0,VListForm1,
     chooseOb,listG,
     stmPg;


{ TVlist0 est le type de base pour TVlistDF dans stmVlist1
                                   TsyncList dans stmSyncC
                                   TVlist dans VlistA1

  TVlist0 ignore tout des données et gère seulement l'affichage en mode
  WaterFall
}


type
  TVlist0=
    class(TdataPlot)

    protected
      rect1,rect2:Trect; {calculParams range getWindowG dans rect1
                          et getInsideWindow dans rect2. }
      Select: array of boolean;
      imax:integer;      {nb lignes effectivement affichées (peut être <count)}

      Zy0,Zdelta:single; {positionnement des numéros}
      Zwidth,Zheight:integer;

      lastSel:integer;   {dernier numéro cliqué}
      lastSelB:boolean;  {indique l'effet du clic}

      Fpartiel:boolean;  {permet un réaffichage partiel quand on clique}


      onSelect:Tpg2Event;
      FCpLine:integer;

      function getSelected(num:integer):boolean;
      procedure setSelected(num:integer;w:boolean);

      procedure CalculParams;

      procedure proprietes(sender:Tobject);override;

      function selectedCount:integer;

      procedure OnselectEvent(n:integer);

    public


      FirstIndex:integer;     {vaut toujours 1 actuellement}
      ligne1,nbligne:integer; {numéro première ligne et nb de lignes affichées}

      DxAff:single;
      DyAff:single;
      Mleft,Mtop,Mright,Mbottom:single;
      FVscale:byte;          { 0 : Standard scale, 1: Vector numbers , 2: No Scale }
      Affselect:boolean;

      gridColor:integer;
      gridON:boolean;


      Xlevel,Ylevel:float;
      UseLevel:boolean;

      procedure setCpLine(w:smallint);override;
      function getCpLine: smallint;override;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;
      procedure createForm;override;
      procedure initForm;

      {Ces 4 fonctions doivent être surchargées pour un objet réel
       DisplayTrace affiche un vecteur dans la sous fenêtre sélectionnée.
       getLineWorld renvoie le système de coordonnées utilisé pour afficher la
       trace num.
      }

      function count:integer;virtual;
      function dataValid:boolean;virtual;
      procedure displayTrace(num:integer);virtual;
      procedure getLineWorld(num:integer;var x1,y1,x2,y2:float);virtual;



      property selected[num:integer]:boolean read getSelected write setSelected ;
      {selected utilise les indices réels de FirstIndex à FirstIndex+count-1
      }

      procedure display0(Inside:boolean);
      procedure Display;override;
      procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                              const order:integer=-1); override;

      procedure DisplayGUI;override;

      procedure cadrerX(sender:Tobject);override;
      procedure cadrerY(sender:Tobject);override;


      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      procedure completeLoadInfo;override;

      procedure resetAll;override;


      function MouseDownMG(numOrdre:integer;Irect:Trect;
               Shift: TShiftState; Xc,Yc,X, Y: Integer):boolean;override;
      procedure InvalidateSelection;

      function getPopUp:TpopupMenu;override;


      {réponses aux événements de VListCommand}
      procedure setFirstLine(num:integer);virtual;
      procedure setLineCount(num:integer);

      procedure selectAllG;
      procedure unselectAllG;
      procedure SaveSelectionG(modeAppend:boolean);virtual;
      procedure CopySelectionG;virtual;

      function CanLoadVectors:boolean;virtual;
      procedure AddClone(vec:Tvector);virtual;
      function getClone(i:integer):Tvector;virtual;

      procedure DisplayGrid;

      procedure processMessage(id:integer;source:typeUO;p:pointer);override;


    end;


function fonctionTVlist0_count(var pu:typeUO):integer;pascal;

procedure proTVlist0_FirstLine(n:integer;var pu:typeUO);pascal;
function fonctionTVlist0_FirstLine(var pu:typeUO):integer;pascal;

procedure proTVlist0_Index(n:integer;var pu:typeUO);pascal;
function fonctionTVlist0_Index(var pu:typeUO):integer;pascal;


procedure proTVlist0_LineCount(n:integer;var pu:typeUO);pascal;
function fonctionTVlist0_LineCount(var pu:typeUO):integer;pascal;

procedure proTVlist0_getLineWorld(num:integer;var x1,y1,x2,y2:float;
           var pu:typeUO);pascal;

procedure proTVlist0_DxWF(x:float;var pu:typeUO);pascal;
function fonctionTVlist0_DxWf(var pu:typeUO):float;pascal;

procedure proTVlist0_DyWF(x:float;var pu:typeUO);pascal;
function fonctionTVlist0_DyWf(var pu:typeUO):float;pascal;

procedure proTVlist0_ShowNumbers(x:boolean;var pu:typeUO);pascal;
function fonctionTVlist0_ShowNumbers(var pu:typeUO):boolean;pascal;

procedure proTVlist0_ShowSelection(x:boolean;var pu:typeUO);pascal;
function fonctionTVlist0_ShowSelection(var pu:typeUO):boolean;pascal;

procedure proTVlist0_Selected(n:integer;x:boolean;var pu:typeUO);pascal;
function fonctionTVlist0_Selected(n:integer;var pu:typeUO):boolean;pascal;

procedure proTVlist0_OnSelect(p:integer;var pu:typeUO);pascal;
function fonctionTVlist0_OnSelect(var pu:typeUO):integer;pascal;

procedure proTVlist0_CpLine(p:integer;var pu:typeUO);pascal;
function fonctionTVlist0_CpLine(var pu:typeUO):integer;pascal;

procedure proTVlist0_Xlevel(x:float;var pu:typeUO);pascal;
function fonctionTVlist0_Xlevel(var pu:typeUO):float;pascal;

procedure proTVlist0_Ylevel(x:float;var pu:typeUO);pascal;
function fonctionTVlist0_Ylevel(var pu:typeUO):float;pascal;

procedure proTVlist0_Uselevel(x:boolean;var pu:typeUO);pascal;
function fonctionTVlist0_Uselevel(var pu:typeUO):boolean;pascal;


procedure proTVlist0_DisplayMode(x:integer;var pu:typeUO);pascal;
function fonctionTVlist0_DisplayMode(var pu:typeUO):integer;pascal;

implementation

uses propVlist;

constructor TVlist0.create;
begin
  inherited create;
  firstIndex:=1;
  ligne1:=1;
  nbligne:=10;
  dyAff:=0;
  FVscale:=0;  { Standard scale }
end;

destructor TVlist0.destroy;
begin
  inherited destroy;
end;

class function TVlist0.stmClassName:AnsiString;
begin
  result:='VectorList';
end;

function TVlist0.count:integer;
begin
  result:=0;
end;

function TVlist0.dataValid:boolean;
begin
  result:=false;
end;

procedure TVlist0.displayTrace(num:integer);
begin
end;

function TVlist0.getSelected(num:integer):boolean;
var
  n:integer;
begin
  n:=num-FirstIndex;
  result:=(n>=0) and (n<length(select)) and select[n];
end;


procedure TVlist0.setSelected(num:integer;w:boolean);
var
  n:integer;
begin
  n:=num-FirstIndex;
  if (n<0) or (n>=count) then exit;

  if n>=length(select) then setLength(select,n+1);
  select[n]:=w;
end;


procedure TVlist0.CalculParams;
begin
  if affselect then
    begin
      if ligne1+nbligne-1>selectedCount
        then imax:=selectedCount-ligne1+1
        else imax:=nbligne;
    end
  else
    begin
      if ligne1+nbligne-firstIndex>count
        then imax:=count-ligne1+FirstIndex
        else imax:=nbligne;
    end;

  echY:=(FVscale<>2);

  with rect1 do getWindowG(left,top,right,bottom);
  rect2:=getInsideWindow;

  if nbligne>0 then
    begin
      Zdelta:=(rect2.bottom-rect2.top)/ nbligne;
      Zy0:=rect2.top-rect1.top+(Zdelta-canvasGlb.textHeight('1'))/2;

      Zwidth:=rect2.left-rect1.left;
      Zheight:=canvasGlb.textHeight('1');
    end;
end;

procedure TVlist0.display0(Inside:boolean);
var
  i,j:integer;
  st:AnsiString;
  y1,y2:float;
  selColor1,selColor2:integer;
  oldFont:Tfont;

  xx0,yy0:float;
  Lx1,Ly1,incDx,incDy:float;
  xx,yy:float;

  tbS:array of integer;
  oldTickY:boolean;
  y0:integer;

  rectI:Trect;
  oldBrushColor:integer;

begin
  if not DataValid then exit;

  oldFont:=canvasGlb.font;
  canvasGlb.font:=visu.fontVisu;
  oldBrushColor:=canvasGlb.brush.color;

  selColor1:=visu.scaleColor;
  selColor2:=(not SelColor1) and $FFFFFF;

  calculParams;
  if inside
    then rectI:=rect1
    else rectI:=rect2;


  canvasGlb.brush.style:=bsSolid;

  if affSelect then
  begin
    setlength(tbS,selectedcount);
    j:=0;
    for i:=firstIndex to firstIndex+count-1 do
      if selected[i] then
        begin
          tbs[j]:=i;
          inc(j);
        end;
  end;

  if not inside and (FVscale=1) then             { Numbers or standard }
    if not affSelect then
      for i:=1 to imax do
        begin
          st:=Istr(ligne1+i-1);

          if dyAff>=0
            then y0:=roundI((nbligne-i)*Zdelta+Zy0)
            else y0:=roundI((i-1)*Zdelta+Zy0);

          if selected[ligne1+i-1] then
            begin
              canvasGlb.font.color:=SelColor2;
              canvasGlb.brush.color:=SelColor1;
            end
          else
            begin
              canvasGlb.font.color:=SelColor1;
              canvasGlb.brush.color:=SelColor2;
            end;

          TextOutG(rect2.left-rect1.left-canvasGlb.textWidth(st)-5,y0,st);
        end
    else
      begin
        for i:=1 to imax do
        begin
          st:=Istr(tbS[ligne1+i-1-1]);

          canvasGlb.font.color:=SelColor1;
          canvasGlb.brush.color:=SelColor2;

          if dyAff>=0
            then y0:=roundI((nbligne-i)*Zdelta+Zy0)
            else y0:=roundI((i-1)*Zdelta+Zy0);

          TextOutG(rect2.left-rect1.left-canvasGlb.textWidth(st)-5,y0,st);
        end;
      end;

  canvasGlb.font:=oldFont;
  canvasGlb.brush.color:=oldBrushColor;

  if Fpartiel then exit;

  lx1:=(rectI.right-rectI.left+1)/(1+(nbligne-1)*abs(dxAff)/100);
  ly1:=(rectI.bottom-rectI.top+1)/(1+(nbligne-1)*abs(dyAff)/100);

  incDx:=lx1*dxAff/100;
  incDy:=-ly1*dyAff/100;


  if dxAff>=0 then xx0:=0 else xx0:=-(nbligne-1)*incDx;
  if dyAff<0 then yy0:=0 else yy0:=-(nbligne-1)*incDy;

  with rectI do
  if dxAff>=0
    then setWindow(left,top,left+roundL(lx1),bottom)
    else setWindow(right-roundL(lx1),top,right,bottom);

  if not inside then
  begin
    oldTickY:=visu.FtickY;

    visu.EchY:=(FVscale=0) ;
    visu.FtickY:=visu.FtickY;
    if FVscale<>0 then
    begin
      visu.CompletX:=false;
      visu.CompletY:=false;
    end;

    if FVscale=0 then
    begin
      xx:=rectI.left+xx0;
      yy:=rectI.top+yy0;
      setWindow(round(xx),round(yy), round(xx+lx1),round(yy+ly1) );
    end;
    visu.displayScale;

    visu.EchY:=(FVscale<>2);
    visu.FtickY:=oldTickY;

  end;

  with rectI do setWindow(left,top,right,bottom);
  with rectI do setClipRegion(left,top,right,bottom);

  for i:=imax downto 1 do
    begin
      xx:=rectI.left+xx0+(i-1)*incDx;
      yy:=rectI.top+yy0+(i-1)*incDy;
      setWindow(round(xx),round(yy), round(xx+lx1),round(yy+ly1) );

      if affselect
        then displayTrace(tbS[ligne1+i-1-1])
        else displayTrace(ligne1+i-1);
      if testEscape or AbortDisplay then exit;
    end;

  resetClipRegion;
end;



procedure TVlist0.Display;
begin
  display0(false);
end;

procedure TVlist0.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                const order:integer=-1);
begin
  display0(true);
end;



procedure TVlist0.DisplayGrid;
var
  i,j:integer;

  xx0,yy0:float;
  Lx1,Ly1,incDx,incDy:float;
  xx,yy:float;


begin
  if not DataValid then exit;
  calculParams;

  lx1:=(rect2.right-rect2.left+1)/(1+(nbligne-1)*abs(dxAff)/100);
  ly1:=(rect2.bottom-rect2.top+1)/(1+(nbligne-1)*abs(dyAff)/100);

  incDx:=lx1*dxAff/100;
  incDy:=-ly1*dyAff/100;


  if dxAff>=0 then xx0:=0 else xx0:=-(nbligne-1)*incDx;
  if dyAff<0 then yy0:=0 else yy0:=-(nbligne-1)*incDy;

  with rect2 do
  if dxAff>=0
    then setWindow(left,top,left+roundL(lx1),bottom)
    else setWindow(right-roundL(lx1),top,right,bottom);

  with rect2 do setWindow(left,top,right,bottom);
  with rect2 do setClipRegion(left,top,right,bottom);

  for i:=imax downto 1 do
    begin
      xx:=rect2.left+xx0+(i-1)*incDx;
      yy:=rect2.top+yy0+(i-1)*incDy;
      setWindow(round(xx),round(yy), round(xx+lx1),round(yy+ly1) );
      drawBorder(GridColor);
    end;

  resetClipRegion;
end;

procedure TVlist0.DisplayGUI;
begin
  displayGrid;
end;

procedure TVlist0.cadrerX(sender:Tobject);
begin
end;

procedure TVlist0.cadrerY(sender:Tobject);
begin
end;


procedure TVlist0.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  with conf do setvarconf('FormRec',FormRec,sizeof(FormRec));

  conf.setvarConf('FirstLine',ligne1,sizeof(ligne1));
  conf.setvarConf('LineCount',nbligne,sizeof(nbligne));

  conf.setvarConf('Dxaff',dxAff,sizeof(dxAff));
  conf.setvarConf('Dyaff',dyAff,sizeof(dyAff));

  conf.setvarConf('Mtop',Mtop,sizeof(Mtop));
  conf.setvarConf('Mbottom',Mbottom,sizeof(Mbottom));
  conf.setvarConf('Mleft',Mleft,sizeof(Mleft));
  conf.setvarConf('Mright',Mright,sizeof(Mright));

  conf.setvarConf('ShowNum',FVscale,sizeof(FVscale));

end;

procedure TVlist0.completeLoadInfo;
begin
  inherited;

  if assigned(form) then form.caption:=ident;

end;


procedure TVlist0.resetAll;
begin
  if assigned(form) then TPform(form).invalidate;
end;

procedure TVlist0.OnselectEvent(n:integer);
begin
  with onSelect do
    if valid then pg.executerVlistSelect(ad,typeUO(self.MyAd),n);
end;


function TVlist0.MouseDownMG(numOrdre:integer;Irect:Trect;
               Shift: TShiftState; Xc,Yc,X, Y: Integer):boolean;
const
  flag:boolean=false;
var
  i,j,ytop,num:integer;
begin
  if flag then exit;

  {Il faut recalculer les positions des labels car l'affichage peut se faire dans
  plusieurs fenêtres}
  result:=false;
  flag:=true;
  if (numOrdre=0) and not affselect and DataValid then
  begin
    calculParams;

    for i:=1 to imax do
      begin
        ytop:=roundI(Zy0+(nbligne-i)*Zdelta);
        if ptInrect(rect(0,ytop,Zwidth,ytop+Zheight),classes.point(x,y)) then
          begin
            if DyAff>=0
              then num:=ligne1+i-1
              else num:=ligne1+nbligne-i;
            if SSshift in Shift then
              begin
                if lastSel=0 then
                  begin
                    lastSel:=num;
                    lastSelB:=true;
                  end;
                if lastSel<=num then
                  for j:=lastSel to num do selected[j]:=lastSelB
                else
                  for j:=num to lastSel do selected[j]:=lastSelB;
              end
            else selected[num]:=not selected[num];
            lastSel:=num;
            lastSelB:=selected[num];

            invalidateSelection;
            OnSelectEvent(num);

            result:=true;
            flag:=false;
            exit;
          end;
      end;
  end;

  if not result
    then result:=inherited MouseDownMG(numOrdre,Irect,Shift,Xc,Yc,X, Y);

  flag:=false;
end;

procedure TVlist0.InvalidateSelection;
begin
  Fpartiel:=true;
  messageToRef(UOmsg_SimpleRefresh,nil);
  if assigned(form) and form.visible then TPform(form).invalidate;
  Fpartiel:=false;

end;

function TVlist0.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TVlist0,'TVlist0_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_TVlist0,'TVlist0_ShowPlot').onclick:=self.Show;

    PopupItem(pop_TVlist0,'TVlist0_Properties').onclick:=Proprietes;
    PopupItem(pop_TVlist0,'TVlist0_SaveObject').onclick:=SaveObjectToFile;
    PopupItem(pop_TVlist0,'TVlist0_Clone').onclick:=CreateClone;

    result:=pop_TVlist0;
  end;
end;

procedure TVlist0.setFirstLine(num:integer);
begin
  if ligne1=num then exit;
  ligne1:=num;
  invalidate;
  if cpLine<>0 then messageCpLine;
end;

procedure TVlist0.setLineCount(num:integer);
begin
  if (num<=0) then exit;
  nbligne:=num;
  invalidate;
end;

procedure TVlist0.createForm;
begin
  Form:=TVlistForm.create(formStm);
  with TVlistForm(Form) do
  begin
    caption:=ident;
    Uplot:=self;
    initForm;
    color:=BKcolor;
  end;
end;

procedure TVlist0.initForm;
begin
  if assigned(form) then
  with TVlistForm(Form) do
  begin
    SBindex.setParams(ligne1,1,count);
    cbHold.setvar(HoldMode);
    enNbLine.setVar(nbligne,g_longint);
    enNbLine.setMinMax(1,1000);

    enDxAff.setVar(dxAff,g_single);
    enDxAff.setMinMax(-100,100);

    enDyAff.setVar(dyAff,g_single);
    enDyAff.setMinMax(-100,100);

    cbVscale.setVar(FVscale,g_byte,0);
    cbDisplaySel.setVar(affselect);

    sbDx.position:=round(Dxaff);
    sbDy.position:=round(Dyaff);


    beginDragG:=GbeginDrag;
  end;
end;


procedure TVlist0.selectAllG;
var
  i:integer;
begin
  for i:=1 to count do selected[i]:=true;
  InvalidateSelection;

end;

procedure TVlist0.unselectAllG;
var
  i:integer;
begin
  for i:=1 to count do selected[i]:=false;
  InvalidateSelection;

end;


procedure TVlist0.SaveSelectionG(modeAppend:boolean);
begin
end;



procedure TVlist0.CopySelectionG;
var
  ob:TVlist0;
  i:integer;
begin
  ChooseObject.caption:='Choose destination';
  if chooseObject.execution(TVlist0,typeUO(ob)) then
    if ob.canLoadVectors then
      for i:=0 to count-1 do
        if selected[i] then ob.addClone(getClone(i));
end;

procedure TVlist0.getLineWorld(num:integer;var x1,y1,x2,y2:float);
begin

end;

procedure TVlist0.proprietes(sender:Tobject);
begin
  if VlistProperties.execution(self) then invalidate;
end;

function TVlist0.CanLoadVectors:boolean;
begin
  result:=false;
end;


procedure TVlist0.AddClone(vec:Tvector);
begin
end;

function TVlist0.getClone(i:integer):Tvector;
begin
end;

function TVlist0.selectedCount:integer;
var
  i:integer;
begin
  result:=0;
  for i:=FirstIndex to FirstIndex+count-1 do
    if selected[i] then inc(result);
end;


procedure TVlist0.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

  case id of
    UOmsg_LineCoupling:
       if (TVlist0(source).cpLine<>0) and (TVlist0(source).cpLine=cpLine) and
          (TVlist0(source).ligne1<>Ligne1) then
          begin
            Ligne1:=TVlist0(source).Ligne1;
            invalidate;
          end;
  end;
end;

function TVList0.getCpLine: smallint;
begin
  result:=FcpLine;
end;

procedure TVList0.setCpLine(w: smallint);
begin
  inherited;
  FcpLine:=w;
end;



                      { Méthodes STM }

var
  E_line:integer;
  E_lineCount:integer;
  E_DxAff:integer;
  E_DyAff:integer;
  E_index:integer;


function fonctionTVlist0_count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=count;
end;

procedure proTVlist0_FirstLine(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    controleParam(n,1,count,E_line);
    setFirstLine(n);
  end;
end;

function fonctionTVlist0_FirstLine(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=ligne1;
end;

procedure proTVlist0_index(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    controleParam(n,1,count,E_line);
    setFirstLine(n);
  end;
end;

function fonctionTVlist0_index(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=ligne1;
end;


procedure proTVlist0_LineCount(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    controleParam(n,1,10000,E_LineCount);
    setLineCount(n);
  end;
end;

function fonctionTVlist0_LineCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=nbligne;
end;


procedure proTVlist0_getLineWorld(num:integer;var x1,y1,x2,y2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVlist0(pu) do getLineWorld(num,x1,y1,x2,y2);
end;

procedure proTVlist0_DxWF(x:float;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    controleParam(x,0,100,E_DxAff);
    DxAff:=x;
  end;
end;

function fonctionTVlist0_DxWf(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=DxAff;
end;

procedure proTVlist0_DyWF(x:float;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    controleParam(x,-100,100,E_DyAff);
    DyAff:=x;
  end;
end;

function fonctionTVlist0_DyWf(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=DyAff;
end;

procedure proTVlist0_ShowNumbers(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    FVscale:=ord(x);
  end;
end;

function fonctionTVlist0_ShowNumbers(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:=(FVscale=1);
end;

procedure proTVlist0_ShowSelection(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    Affselect:=x;
  end;
end;

function fonctionTVlist0_ShowSelection(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TVlist0(pu) do result:= AffSelect;
end;


procedure proTVlist0_Selected(n:integer;x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TVlist0(pu) do
  begin
    controleParam(n,1,count,E_index);
    selected[n]:=x;
  end;
end;

function fonctionTVlist0_Selected(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TVlist0(pu) do
  begin
    controleParam(n,1,count,E_index);
    result:=selected[n];
  end;
end;

procedure proTVlist0_OnSelect(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVlist0(pu).onSelect do setAd(p);
end;

function fonctionTVlist0_OnSelect(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TVlist0(pu).OnSelect.ad;
end;


procedure proTVlist0_CpLine(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TVlist0(pu).CpLine:=p;
end;

function fonctionTVlist0_CpLine(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TVlist0(pu).CpLine;
end;

procedure proTVlist0_Xlevel(x:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TVlist0(pu).Xlevel:=x;
end;

function fonctionTVlist0_Xlevel(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  result:=TVlist0(pu).Xlevel;
end;

procedure proTVlist0_Ylevel(x:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TVlist0(pu).Ylevel:=x;
end;

function fonctionTVlist0_Ylevel(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  result:=TVlist0(pu).Ylevel;
end;


procedure proTVlist0_Uselevel(x:boolean;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TVlist0(pu).UseLevel:=x;
end;

function fonctionTVlist0_Uselevel(var pu:typeUO):boolean;
begin
  verifierObjet(typeUO(pu));
  result:=TVlist0(pu).UseLevel;
end;

procedure proTVlist0_DisplayMode(x:integer;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  if (x<0) or (x>2) then sortieErreur ('TVlist.DisplayMode out of range');
  TVlist0(pu).FVscale:=x;
end;

function fonctionTVlist0_DisplayMode(var pu:typeUO):integer;
begin
  verifierObjet(typeUO(pu));
  result:=TVlist0(pu).FVscale;
end;


Initialization
AffDebug('Initialization stmVlist0',0);

installError(E_line,'TVlist: line number out of range');
installError(E_lineCount,'TVlist: line count out of range');
installError(E_DxAff,'TVlist: DxWF out of range');
installError(E_DyAff,'TVlist: DyWF out of range');
installError(E_index,'TVlist: index out of range');


end.
