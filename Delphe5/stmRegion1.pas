unit stmRegion1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,
     editcont,math,
     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,

     stmDef,stmObj,
     varconf1,stmPlot1,stmDplot,stmDobj1,
     debug0,
     dtf0,Dtrace1,
     stmError,stmPg,
     stmPopup,regions1;


{ TregionList gère une liste de régions ( voir Region1 )
  Les régions travaillent en pixels et s'appuient toujours sur un objet pixelisé
  (Tmatrix, TbitmapPlot ou TOIseq)

  DisplayInside utilise le world du premier objet affiché dans la fenêtre multigraph
  TregionList s'affiche aussi dans TRegEditor (regEditor1) avec un objet TdataObj en arrière plan



}

type
  TDumRegion=class(typeUO)
               function getPopUp:TpopupMenu;override;
             end;

  TregionList=class(TdataPlot)
           private
              Freg:TregList;
              designForm:Tform;

              NewReg:Treg;

              RegSel:integer;             { numéro de la région sélectionnée -1 =aucune}
              HandleSel:integer;          { numéro de la poignée sélectionnée 0 =aucune }
              Xmove,Ymove:integer;
              Fpoly:boolean;

              FirstPlot:TdataObj;
              IrectMg:Trect;
              x1mg,y1mg,x2mg,y2mg:float;

              DumReg:TdumRegion;
              EditMode:boolean;

              procedure setSelected(n:integer;w:boolean);
              function getSelected(n:integer):boolean;

              function RegInvConvx(w: float): integer;
              function RegInvConvy(w: float): integer;
              function RegInvConvx1(w: float): integer;
              function RegInvConvy1(w: float): integer;

              procedure DeleteClick(sender:Tobject);
              procedure EditClick(sender:Tobject);


            public
              Fpix:boolean;
              BkPlot:TdataObj;

              FeditReg:boolean;
              toolSelected:integer;

              property regList:TregList read Freg;
              property selected[n:integer]:boolean read getSelected write setSelected;

              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

              procedure draw(withpix:boolean);

              procedure displayInside(FirstUO:typeUO;
                                   extWorld,logX,logY:boolean;
                                   const order:integer=-1);override;
              procedure display; override;
              procedure invalidate;override;
              procedure invalidateData;override;

              procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;
              function getPopUp:TpopupMenu;override;

              procedure edit(sender:Tobject);
              procedure editRegions(BkPlot1:TdataObj);
              procedure EditRegionList;
              procedure copy(regList:TregionList);

              procedure createRectRegion(left1,top1,width1,height1:integer);
              procedure createEllipticRegion(left1,top1,width1,height1:integer);

              procedure CreateRegionFromMatrix(mat:TdataObj;tt:integer);
              procedure setBKplot(plot:TdataObj);

              procedure selectAll;
              procedure UnSelectAll;

              procedure setColors(w:integer);

              function MouseDownMG(numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; override;
              function MouseMoveMG(x,y:integer):boolean;override;
              procedure MouseUpMG(x,y:integer; mg:typeUO);override;

              function MouseRightMG(ControlSource:Twincontrol;numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean;override;
           end;


function fonctionTregion_RegType(var pu:typeUO):integer;pascal;

function fonctionTregion_left(var pu:typeUO):single;pascal;
function fonctionTregion_top(var pu:typeUO):single;pascal;
function fonctionTregion_width(var pu:typeUO):single;pascal;
function fonctionTregion_height(var pu:typeUO):single;pascal;

function fonctionTregion_pixCount(var pu:typeUO):integer;pascal;
function fonctionTregion_XPix(n:integer;var pu:typeUO):integer;pascal;
function fonctionTregion_YPix(n:integer;var pu:typeUO):integer;pascal;
function fonctionTregion_color(var pu:typeUO):integer;pascal;
procedure proTregion_color(w:integer;var pu:typeUO);pascal;

procedure proTregion_move(deltaX,deltaY:integer;var pu:typeUO);pascal;
procedure proTregion_moveAbs(x0,y0:integer;var pu:typeUO);pascal;

procedure proTregion_Filled(w:boolean; var pu:typeUO);pascal;
function fonctionTregion_Filled(var pu:typeUO):boolean;pascal;

procedure proTregion_Selected(w:boolean; var pu:typeUO);pascal;
function fonctionTregion_Selected(var pu:typeUO):boolean;pascal;

procedure proTregion_saveToXYplot(var plot,pu:typeUO);pascal;

procedure proTregionList_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTregionList_create_1(var pu:typeUO);pascal;
function fonctionTregionList_Count(var pu:typeUO):integer;pascal;
function fonctionTregionList_Region(n:integer;var pu:typeUO):pointer;pascal;
procedure proTregionList_clear(var pu:typeUO);pascal;
procedure proTregionList_copy(var regList:TregionList; var pu:typeUO);pascal;
procedure proTregionList_add(var reg:Treg; var pu:typeUO);pascal;
procedure proTregionList_add_1(var regList:TregionList; var pu:typeUO);pascal;

procedure proTregionList_Defcolor(w:integer; var pu:typeUO);pascal;
function fonctionTregionList_Defcolor(var pu:typeUO):integer;pascal;


procedure proTregionList_createRegionFromMatrix(var mat:typeUO;tt:integer;var pu:typeUO);pascal;
procedure proTregionList_createRectRegion(left1,top1,width1,height1:integer;var pu:typeUO);pascal;
procedure proTregionList_createEllipticRegion(left1,top1,width1,height1:integer;var pu:typeUO);pascal;

procedure proTregionList_EditMode(w:boolean; var pu:typeUO);pascal;
function fonctionTregionList_EditMode(var pu:typeUO):boolean;pascal;

procedure proTregionList_SelectedTool(w:integer; var pu:typeUO);pascal;
function fonctionTregionList_SelectedTool(var pu:typeUO):integer;pascal;

procedure proTregionList_SaveToFile(stF:AnsiString; var pu:typeUO);pascal;
procedure proTregionList_LoadFromFile(stF:AnsiString; var pu:typeUO);pascal;

implementation

uses stmMat1,EditRegList1,RegEditor1, stmGraph2;


{ TDumRegion }

function TDumRegion.getPopUp: TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TdumRegion,'TdumRegion_Delete').onClick:=TregionList(UOowner).DeleteClick;
    PopUpItem(pop_TdumRegion,'TdumRegion_Edit').onClick:=TregionList(UOowner).EditClick;

    result:=pop_TdumRegion;
  end;
end;



{ TregionList }

constructor TregionList.create;
begin
  inherited;
  visu.keepRatio:=true;

  Freg:=TregList.create;
  DumReg:=TdumRegion.create;
  DumReg.UOowner:=self;
  DumReg.NotPublished:=true;

end;

destructor TregionList.destroy;
begin
  designForm.free;
  derefObjet(typeUO(BKplot));

  DumReg.free;
  Freg.free;
  inherited;
end;

class function TregionList.STMClassName: AnsiString;
begin
  result:='RegionList';
end;


procedure TregionList.display;
var
  rectI:Trect;
begin
  rectI:=visu.displayEmpty;                         // trace les graduations , met en place le world, renvoie rectI

  with rectI do setWindow(left,top,right,bottom);
  displayInside(nil,false,false,false);
end;

procedure TregionList.draw(withpix:boolean);
begin
  canvasGlb.pen.Style:=psSolid;
  canvasGlb.pen.width:=1;

  canvasGlb.brush.Style:=bsClear;

  Freg.draw;
  if withpix and assigned(FirstPlot) then
    with FirstPlot do Freg.drawPix(dxu,x0u,dyu,y0u);
  if assigned(NewReg) then NewReg.draw;
end;

{ Utilise toujours le world courant
}
procedure TregionList.displayInside(FirstUO: typeUO; extWorld, logX,logY: boolean;
                                const order:integer=-1);
var
  x1,y1,x2,y2:float;
  n:integer;
begin
  Dgraphic.getWorld(x1,y1,x2,y2);

  if assigned(FirstUO) and (firstUO is TdataPlot) then
  begin
                                  // on utilise les param InverseXY de firstUO
    n:= ord(TdataPlot(firstUO).inverseX) +2*ord(TdataPlot(firstUO).inverseY);
    case n of
      0: Dgraphic.setWorld(x1,y1,x2,y2);
      1: Dgraphic.setWorld(x2,y1,x1,y2);
      2: Dgraphic.setWorld(x1,y2,x2,y1);
      3: Dgraphic.setWorld(x2,y2,x1,y1);
    end;

    FirstPlot:=TdataObj(firstUO);
  end
  else
  begin
    n:= ord(inverseX) +2*ord(inverseY);
    case n of
      0: Dgraphic.setWorld(xmin,ymin,xmax,ymax);
      1: Dgraphic.setWorld(xmax,ymin,xmin,ymax);
      2: Dgraphic.setWorld(xmin,ymax,xmax,ymin);
      3: Dgraphic.setWorld(xmax,ymax,xmin,ymin);
    end;
    FirstPlot:=nil;
  end;

  canvasGlb.pen.Style:=psSolid;
  canvasGlb.pen.width:=1;

  canvasGlb.brush.Style:=bsClear;

  draw(Fpix);
end;

procedure TregionList.editRegions(BkPlot1: TdataObj);
begin
  if not assigned(designForm) then
    DesignForm:=TregEditor.create(formStm);


  if BkPlot<>BKplot1 then
  begin
    derefObjet(typeUO(BKplot));
    BKplot:=BKplot1;
    refObjet(BKplot1);
  end;

  with TregEditor(DesignForm) do
  begin
    install(self,BKplot,self);
    caption:=ident;
  end;

  designForm.Show;
end;

procedure TregionList.edit(sender: Tobject);
begin
  if FirstUOpopup is TdataObj
    then editRegions(TdataObj(FirstUOpopup))
    else editRegions(nil);
end;


procedure TregionList.invalidate;
begin
  inherited invalidate;
  if assigned(designForm) then designForm.Invalidate;

  {messageToRef(UOmsg_invalidateData,designForm);}
  { La région invalidée envoie un message uomsg_invalidate à son propriétaire
    éventuel (OIseq) qui doit invalider sa fenêtre principale.
  }
end;

procedure TregionList.invalidateData;
begin
  invalidateForm;
  if assigned(designForm) then designForm.Invalidate;
  messageToRef(UOmsg_invalidateData,designForm);
  ModifiedData:=false;
end;

procedure TregionList.ProcessMessage(id: integer; source: typeUO;p: pointer);
begin
  inherited;
  if assigned(designForm) and (source=BKplot) then
  case id of
    uomsg_destroy:  begin
                      derefObjet(typeUO(BKplot));
                      TregEditor(designForm).install(self,nil,self);
                    end;
    uomsg_invalidate,uomsg_invalidateData:
                    TregEditor(designForm).install(self,BKplot,self);
  end;
end;

procedure TregionList.copy(regList:TregionList);
begin
  Freg.copy(regList.Freg);
end;

function TregionList.getPopUp: TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TregionList,'TregionList_Coordinates').onClick:=self.chooseCoo;
    PopUpItem(pop_TregionList,'TregionList_Show').onClick:=self.Show;
    PopUpItem(pop_TregionList,'TregionList_Edit').onClick:=Edit;
    PopUpItem(pop_TregionList,'TregionList_Clone').onClick:=CreateClone;

    result:=pop_TregionList;
  end;
end;



procedure TregionList.EditRegionList;
begin
  EditRegList.Init(self);
  EditRegList.showModal;
end;

procedure TregionList.CreateRegionFromMatrix(mat: TdataObj; tt: integer);
var
  i,j:integer;
  pixreg:TpixReg;

function condition(i,j:integer):boolean;
begin
  with Tmatrix(mat) do
  result:=((tt and 1<>0) and selPix[i,j] or (tt and 2<>0) and markPix[i,j]);
end;

begin
  pixreg:=TpixReg.create;

  with Tmatrix(mat) do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    if condition(i,j) then pixReg.AddPix(i,j);

  regList.Add(pixreg);
  pixReg.BuildPolygons;
end;

procedure TregionList.createRectRegion(left1,top1,width1,height1:integer);
var
  reg:TrectReg;
begin
  reg:=TrectReg.create(left1,top1);
  reg.movePt(left1+width1,top1+height1,false);
  regList.Add(reg);
end;

procedure TregionList.createEllipticRegion(left1,top1,width1,height1:integer);
var
  reg:TellipseReg;
begin
  reg:=TellipseReg.create(left1,top1);
  reg.movePt(left1+width1,top1+height1,false);
  regList.Add(reg);
end;



procedure TregionList.setColors(w: integer);
begin
  Freg.setColors(w);
end;

function TRegionList.RegInvConvx(w: float): integer;
begin
  if assigned(FirstPlot)
    then result:=FirstPlot.invconvx(w)
    else result:=round(w);
end;

function TRegionList.RegInvConvy(w: float): integer;
begin
  if assigned(FirstPlot)
    then result:=FirstPlot.invconvy(w)
    else result:=round(w);
end;


{ indique la case pointée par la souris }
function TRegionList.RegInvConvx1(w: float): integer;
begin
  if assigned(FirstPlot) then
  with FirstPlot  do
    result:=floor( (w-inf.x0u)/inf.dxu )
  else result:=floor(w);
end;

function TRegionList.RegInvConvy1(w: float): integer;
begin
  if assigned(FirstPlot) then
  with FirstPlot  do
    result:=floor( (w-inf.y0u)/inf.dyu )
  else result:=floor(w);
end;


function TregionList.MouseDownMG(numOrdre: integer; Irect: Trect;
  Shift: TShiftState; Xc, Yc, X, Y: Integer): boolean;
var
  num:integer;
  handleDum:integer;
  p:Tpoint;
begin
  result:=false;
  if not EditMode then exit;

  x:=x+x1act;
  y:=y+y1act;
  Dgraphic.getWorld(x1mg,y1mg,x2mg,y2mg);
  with Irect do setWindow(left,top,right,bottom);
  IrectMg:=Irect;
  Dgraphic.setWorld(x1mg,y1mg,x2mg,y2mg);


  

  HandleSel:=0;

  if (toolSelected=4) then                                     {outil de sélection}
  begin
    HandleSel:= regList.ptInHandleRect(x,y);

    Xmove:=ReginvconvX(invconvWx(x));
    Ymove:=ReginvconvY(invconvWy(y));

    if HandleSel=0 then
    begin
      RegSel:=regList.ptInRegion(Xmove,Ymove,handleSel);

      if not(ssCtrl in shift) and not ((RegSel>=0) and (selected[RegSel]))
        then regList.clearSelection;

      regList.AddSelection(RegSel);
    end;
    result:=true;
    invalidate;

    exit;
  end;

  if Fpoly and (toolSelected<>3) then
  begin
    Newreg.close;
    regList.Add(Newreg);
    Newreg:=nil;
    Fpoly:=false;
  end;


  x:=ReginvconvX(invconvWx(x));
  y:=ReginvconvY(invconvWy(y));

  case toolSelected of
    1: begin
         NewReg:=TrectReg.create(x,y);  {Création nouveau rectangle}
       end;
    2: begin                            {Création nouvel ellipse}
         NewReg:=TellipseReg.create(x,y);
       end;
    3: begin                            {Création nouveau polygone}
         if not Fpoly then NewReg:=TpolygonReg.create(x,y);
         Fpoly:=true;
       end;

    5: begin                            {Création nouveau polygone}
         NewReg:=TpolygonReg.create(x,y);
         Fpoly:=false;
       end;
  end;

  if assigned(NewReg) then NewReg.color:=regList.Defcolor;
  result:=true;
end;

function TregionList.MouseMoveMG(x, y: integer): boolean;
var
  x1,y1:integer;
  i1,j1:integer;
  z1:float;
begin
  result:=false;
  if not EditMode then exit;

  with IrectMg do setWindow(left,top,right,bottom);
  Dgraphic.setWorld(x1mg,y1mg,x2mg,y2mg);

  x1:=ReginvconvX(invconvWx(x));
  y1:=ReginvconvY(invconvWy(y));

  i1:=ReginvconvX1(invconvWx(x));
  j1:=ReginvconvY1(invconvWy(y));

  if HandleSel>0 then
  begin
    regList.modifySelection(HandleSel,x1-Xmove,y1-Ymove);
    Xmove:=x1;
    Ymove:=y1;
    invalidate;
  end
  else
  if toolSelected=4 then
  begin
    if RegSel>=0 then                   {Déplacement région }
    begin
      regList.moveSelection(x1-Xmove,y1-Ymove);
      Xmove:=x1;
      Ymove:=y1;
      invalidate;
    end;
  end
  else
  if toolSelected in [1..5]  then
  begin
    if toolSelected=5
      then Newreg.addPoint(x1,y1)
      else Newreg.MovePt(x1,y1,false);                {Construction région}
    invalidate;
  end;

  result:=true;

end;

procedure TregionList.MouseUpMG(x, y: integer; mg: typeUO);
begin
  if not EditMode then exit;

  with IrectMg do setWindow(left,top,right,bottom);
  Dgraphic.setWorld(x1mg,y1mg,x2mg,y2mg);

  x:=ReginvconvX(invconvWx(x));
  y:=ReginvconvY(invconvWy(y));

  RegSel:=-1;
  HandleSel:=-1;

  if toolSelected in [1,2,3,5] then
  begin
    if toolSelected=5 then
    begin
      Newreg.addPoint(x,y);
      Newreg.close;
    end
    else Newreg.MovePt(x,y,true);

    if Fpoly then
    begin
      Newreg.AddPoint(x,y);
    end
    else
    begin
      regList.Add(Newreg);
      Newreg:=nil;
    end;
  end;


  invalidateData;
end;

procedure TregionList.DeleteClick(sender: Tobject);
begin
  regList.deleteSelection;
  invalidateData;
end;

procedure TregionList.EditClick(sender: Tobject);
begin

end;

procedure TregionList.setBKplot(plot: TdataObj);
begin
  derefObjet(typeUO(BKplot));
  BKplot:=plot;
  refObjet(plot);
end;

function TregionList.getSelected(n: integer): boolean;
begin
  with regList do
  result:= (n>=0) and (n<count) and region[n].selected;
end;

procedure TregionList.setSelected(n: integer; w: boolean);
begin
  with regList do
  if (n>=0) and (n<count)
    then region[n].selected:=w;
end;

procedure TregionList.selectAll;
var
  i:integer;
begin
  with regList do
  for i:=0 to count-1 do
    region[i].selected:=true;
end;

procedure TregionList.UnSelectAll;
var
  i:integer;
begin
  with regList do
  for i:=0 to count-1 do
    region[i].selected:=false;
end;

function TregionList.MouseRightMG(ControlSource: Twincontrol;
  numOrdre: integer; Irect: Trect; Shift: TShiftState; Xc, Yc, X,
  Y: Integer; var uoMenu: typeUO): boolean;
var
  Num,handleDum:integer;
begin
  Dgraphic.getWorld(x1mg,y1mg,x2mg,y2mg);

  result:=inherited MouseRightMG(ControlSource,numOrdre, Irect, Shift, Xc, Yc, X, Y, uoMenu);
  if result then exit;

  x:=x+x1act;
  y:=y+y1act;

  with Irect do setWindow(left,top,right,bottom);
  IrectMg:=Irect;
  Dgraphic.setWorld(x1mg,y1mg,x2mg,y2mg);

  Num:=regList.ptInRegion(ReginvconvX(invconvWx(x)),ReginvconvY(invconvWy(y)),handleDum);
  result:=(num>=0) and Selected[num];
  if result then
  begin
    DumReg.ident:='Region '+Istr(Num+1);
    uoMenu:=DumReg;
  end;

end;




{************************** Méthodes Stm de Tregion *********************************}

function fonctionTregion_RegType(var pu:typeUO):integer;
begin
  result:=Treg(pu).RegType;
end;

function fonctionTregion_left(var pu:typeUO):single;
begin
  result:=Treg(pu).regionBox.Left;
end;

function fonctionTregion_top(var pu:typeUO):single;
begin
  result:=Treg(pu).regionBox.top;
end;

function fonctionTregion_width(var pu:typeUO):single;
begin
  with Treg(pu).regionBox do
  result:=right-left;
end;

function fonctionTregion_height(var pu:typeUO):single;
begin
  with Treg(pu).regionBox do
  result:=bottom-top;
end;

function fonctionTregion_pixCount(var pu:typeUO):integer;
begin
  result:=Treg(pu).pixCount;
end;


function fonctionTregion_XPix(n:integer;var pu:typeUO):integer;
begin
  with Treg(pu) do
  begin
    if (n<1) or (n>pixCount) then sortieErreur('Tregion : Pixel number out of range');
    result:=getPixel(n-1).x;
  end;
end;

function fonctionTregion_YPix(n:integer;var pu:typeUO):integer;
begin
  with Treg(pu) do
  begin
    if (n<1) or (n>pixCount) then sortieErreur('Tregion : Pixel number out of range');
    result:=getPixel(n-1).y;
  end;
end;

function fonctionTregion_color(var pu:typeUO):integer;
begin
  result:=Treg(pu).color;
end;

procedure proTregion_color(w:integer;var pu:typeUO);
begin
  Treg(pu).color:=w;
end;

function fonctionTregion_filled(var pu:typeUO):boolean;
begin
  result:=Treg(pu).filled;
end;

procedure proTregion_filled(w:boolean;var pu:typeUO);
begin
  Treg(pu).filled:=w;
end;

procedure proTregion_move(deltaX,deltaY:integer;var pu:typeUO);
begin
  with Treg(pu) do move(deltaX,deltaY);
end;

procedure proTregion_moveAbs(x0,y0:integer;var pu:typeUO);pascal;
begin
  with Treg(pu) do moveAbs(x0,y0);
end;

procedure proTregion_saveToXYplot(var plot,pu:typeUO);
begin
  verifierObjet(plot);
  verifierObjet(pu);
  if not( Treg(pu).regType in [1,3] ) then sortieErreur('Tregion.saveToXYplot : region cannot be converted');

  TXYplot(plot).addPolyline;
//  Treg(pu).saveToXYplot( plot);

end;

function fonctionTregion_Selected(var pu:typeUO):boolean;
begin
  result:=Treg(pu).Selected;
end;

procedure proTregion_Selected(w:boolean;var pu:typeUO);
begin
  Treg(pu).Selected:=w;
end;

{************************** Méthodes Stm de TregionList ***************************}


procedure proTregionList_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stName,pu,TregionList);
end;

procedure proTregionList_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TregionList);
end;


function fonctionTregionList_Count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TregionList(pu).regList.Count;
end;

function fonctionTregionList_Region(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TregionList(pu) do
  begin
    if (n<1) or (n>regList.Count) then sortieErreur('TregionList : Region number out of range');
    result:= @regList.region[n-1].myad;
  end;
end;


procedure proTregionList_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  TregionList(pu).regList.clear;
end;

procedure proTregionList_copy(var regList:TregionList; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(regList));
  TregionList(pu).copy(regList);
end;

procedure proTregionList_add(var reg:Treg; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(reg));
  TregionList(pu).regList.addReg(reg);
end;

procedure proTregionList_add_1(var regList:TregionList; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(regList));
  TregionList(pu).regList.addRegList(regList.regList);
end;

procedure proTregionList_Defcolor(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TregionList(pu).regList.Defcolor:=w;
end;

function fonctionTregionList_Defcolor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TregionList(pu).regList.Defcolor;
end;



procedure proTregionList_createRegionFromMatrix(var mat:typeUO;tt:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(mat);
  with TregionList(pu) do createRegionFromMatrix(TdataObj(mat),tt);
end;


procedure proTregionList_createRectRegion(left1,top1,width1,height1:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TregionList(pu) do createRectRegion(left1,top1,width1,height1);
end;

procedure proTregionList_createEllipticRegion(left1,top1,width1,height1:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TregionList(pu) do createEllipticRegion(left1,top1,width1,height1);
end;

procedure proTregionList_EditMode(w:boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  TregionList(pu).EditMode:=w;
end;

function fonctionTregionList_EditMode(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TregionList(pu).EditMode;
end;

procedure proTregionList_SelectedTool(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TregionList(pu).ToolSelected:=w;
end;

function fonctionTregionList_SelectedTool(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TregionList(pu).ToolSelected;
end;

procedure proTregionList_SaveToFile(stF:AnsiString; var pu:typeUO);
begin
  verifierObjet(pu);
  with TregionList(pu) do
  if not regList.saveToFile(stF,FirstPlot)
    then sortieErreur('Unable to save '+stF);
end;

procedure proTregionList_LoadFromFile(stF:AnsiString; var pu:typeUO);
begin
  verifierObjet(pu);
  with TregionList(pu) do
  if not regList.LoadFromFile(stF,FirstPlot)
    then sortieErreur('Unable to load '+stF);
end;


Initialization
AffDebug('Initialization stmRegion1',0);

registerObject(TregionList,data);

end.
