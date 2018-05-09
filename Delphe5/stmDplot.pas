unit stmDplot;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,classes,menus,forms,stdCtrls,sysutils,controls,Graphics,
     util1,Dgraphic,Dgrad1,Dtrace1,BMex1,

     cood0,
     stmDef,stmObj,stmPlot1,Ncdef2,stmError,
     visu0,
     varconf1,
     debug0,

     tpform0,
     objFile1,
     stmPopUp,stmCooX1,
     FontEx0,
     stmPG,
     CpList0,
     matlab_matrix, matlab_Mat;


     {stmExe dans implementation}

{ A partir de Tplot, on construit TdataPlot en ajoutant les paramètres de visu }

type
  TdataPlot= class(Tplot)
            private
                 xdebScr,xFinScr:float;
                 ydebScr,yFinScr:float;
                 zdebScr,zFinScr:float;

            protected
                 UOcap:typeUO;


                 procedure setXmin(x:double);virtual;
                 procedure setXmax(x:double);virtual;
                 procedure setYmin(x:double);virtual;
                 procedure setYmax(x:double);virtual;
                 procedure setZmin(x:double);virtual;
                 procedure setZmax(x:double);virtual;

                 procedure setUnitX(st:AnsiString);virtual;
                 function getUnitX:AnsiString;

                 procedure setUnitY(st:AnsiString);virtual;
                 function getUnitY:AnsiString;

                 procedure setcolorT(w:longint);virtual;
                 procedure setcolorT2(w:longint);virtual;

                 procedure settwoCol(w:boolean);virtual;
                 procedure setmodeT(w:byte);virtual;
                 procedure settailleT(w:byte);virtual;
                 procedure setlargeurTrait(w:byte);virtual;
                 procedure setstyleTrait(w:byte);virtual;
                 procedure setmodeLogX(w:boolean);virtual;
                 procedure setmodeLogY(w:boolean);virtual;
                 procedure setgrille(w:boolean);virtual;

                 procedure setcpX(w:smallint);virtual;
                 procedure setcpY(w:smallint);virtual;
                 procedure setcpZ(w:smallint);virtual;

                 function getCpLine: smallint;virtual;
                 procedure setcpLine(w:smallint);virtual;


                 procedure setechX(w:boolean);virtual;
                 procedure setechY(w:boolean);virtual;
                 procedure setFtickX(w:boolean);virtual;
                 procedure setFtickY(w:boolean);virtual;
                 procedure setCompletX(w:boolean);virtual;
                 procedure setcompletY(w:boolean);virtual;
                 procedure setTickExtX(w:boolean);virtual;
                 procedure setTickExtY(w:boolean);virtual;
                 procedure setScaleColor(w:longint);virtual;

                 procedure setinverseX(w:boolean);virtual;
                 procedure setinverseY(w:boolean);virtual;

                 procedure setAspectRatio(w:single);virtual;
                 function getAspectRatio:single;virtual;

                 procedure setPixelRatio(w:single);virtual;
                 function getPixelRatio:single;virtual;

                 procedure setKeepRatio(w:boolean);virtual;
                 procedure setCpxMode(w:byte);virtual;

                 procedure fileSaveData(sender:Tobject);virtual;
                 procedure fileSaveAsText(sender:Tobject);virtual;

                 procedure fileLoad(sender:Tobject);virtual;
                 procedure filePrint(sender:Tobject);virtual;
                 procedure fileCopy(sender:Tobject);virtual;

                 function withZ:boolean;virtual;

                 procedure setIstart(w:integer);virtual;
                 function getIstart:integer;virtual;
                 procedure setIend(w:integer);virtual;
                 function getIend:integer;virtual;

                 procedure setJstart(w:integer);virtual;
                 function getJstart:integer;virtual;
                 procedure setJend(w:integer);virtual;
                 function getJend:integer;  virtual;

                 function getCoupledBinXY:boolean;virtual;
                 procedure setCoupledBinXY(w:boolean);virtual;

                 
            public
                 oldVisu:^ToldVisuInfo; {Pour assurer le chargement des cfg
                                         créées avant le 16-9-99 }

                 visu:TvisuInfo;
                 visu0:^TvisuInfo; {utilisé par cood}
                 Facquis:boolean;  {positionné par AffContext pour indiquer que
                                    l'affichage est pris en main par l'acquisition}
                 CpEnabled:boolean;  {Utilise les coef de couplage}

                 AcqFlag: boolean;

                 property Xmin:double read visu.xmin write setXmin;
                 property Xmax:double read visu.xmax write setXmax;
                 property Ymin:double read visu.Ymin write setYmin;
                 property Ymax:double read visu.Ymax write setYmax;
                 property Zmin:double read visu.Zmin write setZmin;
                 property Zmax:double read visu.Zmax write setZmax;

                 property unitX:AnsiString read getUnitX write setUnitX;
                 property unitY:AnsiString read getUnitY write setUnitY;

                 property colorT:longint read visu.color write setColorT;
                 property colorT2:longint read visu.color2 write setColorT2;

                 property twoCol:boolean read visu.twoCol  write settwoCol;
                 property modeT:byte read visu.modeT  write setmodeT;
                 property tailleT:byte read visu.tailleT  write settailleT;
                 property largeurTrait:byte read visu.largeurTrait  write setlargeurTrait;
                 property styleTrait:byte read visu.styleTrait  write setstyleTrait;
                 property modeLogX:boolean read visu.modeLogX  write setmodeLogX;
                 property modeLogY:boolean read visu.modeLogY  write setmodeLogY;
                 property modeLogZ:boolean read visu.modeLogZ  write visu.modeLogZ;

                 property grille:boolean read visu.grille  write setgrille;
                 property cpX:smallint read visu.cpX  write setcpX;
                 property cpY:smallint read visu.cpY  write setcpY;
                 property cpZ:smallint read visu.cpZ  write setcpZ;
                 property cpLine:smallint read getCpLine  write setcpLine;

                 property echX:boolean read visu.echX  write setechX;
                 property echY:boolean read visu.echY  write setechY;
                 property FtickX:boolean read visu.FtickX  write setFtickX;
                 property FtickY:boolean read visu.FtickY  write setFtickY;
                 property CompletX:boolean read visu.CompletX  write setCompletX;
                 property completY:boolean read visu.completY  write setcompletY;
                 property TickExtX:boolean read visu.TickExtX  write setTickExtX;
                 property TickExtY:boolean read visu.TickExtY  write setTickExtY;
                 property ScaleColor:longint read visu.ScaleColor  write setScaleColor;

                 property inverseX:boolean read visu.inverseX  write setinverseX;
                 property inverseY:boolean read visu.inverseY  write setinverseY;

                 property AspectRatio:single read getAspectRatio write setAspectRatio;
                 property PixelRatio:single read getPixelRatio write setPixelRatio;

                 property keepRatio:boolean read visu.keepRatio  write setKeepRatio;
                 property CpxMode:byte read visu.cpxMode write setCpxMode;

                 property Gdisp:double read visu.Gdisp write visu.Gdisp;
                 property Xdisp:double read visu.Xdisp write visu.Xdisp;
                 property Ydisp:double read visu.Ydisp write visu.Ydisp;

                 property EpDuration: single read visu.EpDuration write visu.EpDuration;

                 function Xstart:float;  virtual; {Ces 8 fonctions renvoient 0}
                 function Xend:float;    virtual;

                 property Istart:integer read getIstart write setIstart;
                 property Iend:integer read getIend write setIend;
                 function Icount:integer;
                 procedure setIcount(n:integer);virtual;

                 function Ystart:float;  virtual;
                 function Yend:float;    virtual;

                 property Jstart:integer read getJstart write setJstart;
                 property Jend:integer read getJend write setJend;
                 function Jcount:integer;

                 function Kcount:integer;

                 property CoupledBinXY:boolean read getCoupledBinXY write setCoupledBinXY;

                 constructor create;override;
                 destructor destroy;override;


                 function getInsideWindow:Trect;override;

                 {Les procédures Cadrer doivent modifier visu0^ }
                 procedure cadrerX(sender:Tobject);virtual;
                 procedure cadrerY(sender:Tobject);virtual;
                 procedure cadrerZ(sender:Tobject);virtual;
                 procedure cadrerC(sender:Tobject);virtual;


                 { ces deux procédures gèrent fontVisu correctement }
                 procedure initVisu0;  { crée visu0^ et copie visu dans visu0}
                 procedure doneVisu0;  { détruit visu0 }

                 {chooseCoo est le gestionnaire d'événement appelé dans le
                  menu Coo

                  FchooseCoo fait exactement la même chose mais renvoie une
                  valeur booléenne et est appelé par une méthode stm.

                  ChooseCoo et FchooseCoo appellent tous deux ChooseCoo1
                 }
                 procedure chooseCoo(sender:Tobject);override;
                 function FchooseCoo(sender:Tobject):boolean;
                 function ChooseCoo1:boolean;virtual;

                 procedure setWorld(x1,y1,x2,y2:float);
                 procedure getWorld(var x1,y1,x2,y2:float);

                 {processMessage traite UOmsg_coupling }
                 procedure processMessage(id:integer;source:typeUO;p:pointer);
                   override;

                 function FindLimits(id:integer;var Amin,Amax: float): boolean;override;
                 { autoscale modifie directement visu
                   alors que cadrer modifie visu0^}
                 procedure AutoscaleX;      virtual;
                 procedure AutoscaleY;      virtual;
                 procedure AutoscaleZ;      virtual;

                 {autoscaleY1 cadre les data entre Xmin et Xmax}
                 procedure AutoscaleY1;      virtual;

                 procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                 procedure CompleteLoadInfo;override;
                 procedure CompleteSaveInfo;override;

                 procedure translateCoo(plus:boolean);virtual;

                 procedure displayCursors(BMex:TbitmapEx);override;
                 procedure InvalidateCursors;override;

                 function getTitleColor:integer;override;

                 function getPopUp:TpopupMenu;override;

                 function MouseDownMG(numOrdre:integer;Irect:Trect;
                          Shift: TShiftState;Xc,Yc,X,Y: Integer):boolean;override;
                 function MouseMoveMG(x,y:integer):boolean;override;
                 procedure MouseUpMG(x,y:integer; mg:typeUO);override;

                 function MouseRightMG(ControlSource:TWincontrol;numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean;override;

                 procedure scrollPosX(Sender: TObject;x:float;ScrollCode: TScrollCode);
                 procedure scrollRangeX(Sender: TObject;x:float;ScrollCode: TScrollCode);
                 procedure installFastCooX(ControlSource:Twincontrol;rr:Trect;xc,yc:integer);
                 procedure clickCadrerX(Sender: TObject);

                 procedure scrollPosY(Sender: TObject;x:float;ScrollCode: TScrollCode);
                 procedure scrollRangeY(Sender: TObject;x:float;ScrollCode: TScrollCode);
                 procedure clickCadrerY(Sender: TObject);
                 procedure clickLevelY(Sender: TObject);

                 procedure installFastCooY(ControlSource:Twincontrol;rr:Trect;xc,yc:integer);

                 procedure scrollPosZ(Sender: TObject;x:float;ScrollCode: TScrollCode);
                 procedure scrollRangeZ(Sender: TObject;x:float;ScrollCode: TScrollCode);
                 procedure clickCadrerZ(Sender: TObject);
                 procedure installFastCooZ(ControlSource:Twincontrol;rr:Trect;xc,yc:integer);

                 procedure AdjustXminXmax(x0:float);
                 procedure ReinitXminXmax;

                 procedure getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                                      var x1,y1,x2,y2:float);override;

                 function isModified:boolean;override;

                 procedure swapFont(var font:Tfont;var color:integer);override;
                 procedure swapVisu(visu1: PvisuInfo;flags: PvisuFlags);override;
                 procedure AdjustXmin(x0:float);

                 procedure GdispToWorld(Gdisp,xdisp,ydisp:float);virtual;
                 procedure WorldToGdisp(var Gdisp,xdisp,ydisp:float);virtual;

                 function getMean(x1,x2:float):float;virtual;

                 function indexToReal(id:integer):float;virtual;

                 procedure messageCpx;
                 procedure messageCpy;
                 procedure messageCpz;
                 procedure messageCpLine;

                 class procedure UpdateCouplings;
              end;


procedure RebuildCouplings;
procedure BlockCouplings;

{***************** Déclarations STM pour TdataPlot ****************************}

procedure proTdataPlot_SetWorld(x1,y1,x2,y2:float;var pu:typeUO);pascal;
procedure proTdataPlot_GetWorld(var x1,y1,x2,y2:float;var pu:typeUO);pascal;

function fonctionTdataPlot_Xmin(var pu:typeUO):float;pascal;
procedure proTdataPlot_Xmin(x:float;var pu:typeUO);pascal;
function fonctionTdataPlot_Xmax(var pu:typeUO):float;pascal;
procedure proTdataPlot_Xmax(x:float;var pu:typeUO);pascal;
function fonctionTdataPlot_Ymin(var pu:typeUO):float;pascal;
procedure proTdataPlot_Ymin(x:float;var pu:typeUO);pascal;
function fonctionTdataPlot_Ymax(var pu:typeUO):float;pascal;
procedure proTdataPlot_Ymax(x:float;var pu:typeUO);pascal;

function fonctionTdataPlot_unitX(var pu:typeUO):AnsiString;pascal;
procedure proTdataPlot_unitX(x:AnsiString;var pu:typeUO);pascal;
function fonctionTdataPlot_unitY(var pu:typeUO):AnsiString;pascal;
procedure proTdataPlot_unitY(x:AnsiString;var pu:typeUO);pascal;


procedure proTdataPlot_LogX(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_LogX(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_LogY(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_LogY(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_Xscale(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_Xscale(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_Yscale(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_Yscale(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_Xticks(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_Xticks(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_Yticks(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_Yticks(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_RightTicks(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_RightTicks(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_TopTicks(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_TopTicks(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_ScaleColor(x:integer;var pu:typeUO);pascal;
function fonctionTdataPlot_ScaleColor(var pu:typeUO):integer;pascal;

procedure proTdataPlot_inverseX(b:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_inverseX(var pu:typeUO):boolean;pascal;
procedure proTdataPlot_inverseY(b:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_inverseY(var pu:typeUO):boolean;pascal;

function fonctionTdataPlot_ChooseCoo(var pu:typeUO):boolean;pascal;



function fonctionTdataPlot_Cpx(var pu:typeUO):integer;pascal;
procedure proTdataPlot_Cpx(x:integer;var pu:typeUO);pascal;
function fonctionTdataPlot_Cpy(var pu:typeUO):integer;pascal;
procedure proTdataPlot_Cpy(x:integer;var pu:typeUO);pascal;
function fonctionTdataPlot_Cpz(var pu:typeUO):integer;pascal;
procedure proTdataPlot_Cpz(x:integer;var pu:typeUO);pascal;


procedure proTdataPlot_AutoscaleX(var pu:typeUO);pascal;
procedure proTdataPlot_AutoscaleY(var pu:typeUO);pascal;
procedure proTdataPlot_AutoscaleY1(var pu:typeUO);pascal;


procedure proTdataPlot_color(x:longint;var pu:typeUO);pascal;
function fonctionTdataPlot_color(var pu:typeUO):longint;pascal;

procedure proTdataPlot_color2(x:longint;var pu:typeUO);pascal;
function fonctionTdataPlot_color2(var pu:typeUO):longint;pascal;

procedure proTdataPlot_Mode(x:integer;var pu:typeUO);pascal;
function fonctionTdataPlot_Mode(var pu:typeUO):integer;pascal;

procedure proTdataPlot_SymbolSize(x:integer;var pu:typeUO);pascal;
function fonctionTdataPlot_SymbolSize(var pu:typeUO):integer;pascal;

procedure proTdataPlot_LineStyle(w:integer ;var pu:typeUO);pascal;
function fonctionTdataPlot_LineStyle(var pu:typeUO):integer;pascal;

procedure proTdataPlot_lineWidth(x:smallint;var pu:typeUO);pascal;
function fonctionTdataPlot_lineWidth(var pu:typeUO):smallint;pascal;

procedure proTdataPlot_keepAspectRatio(b:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_keepAspectRatio(var pu:typeUO):boolean;pascal;


procedure proTdataPlot_ExtTicksX(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_ExtTicksX(var pu:typeUO):boolean;pascal;

procedure proTdataPlot_ExtTicksY(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_ExtTicksY(var pu:typeUO):boolean;pascal;

function fonctionTdataPlot_font(var pu:typeUO):pointer;pascal;

procedure proTdataPlot_ZeroAxisX(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_ZeroAxisX(var pu:typeUO):boolean;pascal;

procedure proTdataPlot_ZeroAxisY(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_ZeroAxisY(var pu:typeUO):boolean;pascal;

procedure proTdataPlot_Fgrid(x:boolean;var pu:typeUO);pascal;
function fonctionTdataPlot_Fgrid(var pu:typeUO):boolean;pascal;

procedure ProSuspendCouplings;pascal;
procedure ProUpdateCouplings;pascal;


IMPLEMENTATION

uses stmCurs;

var
  CpListX, CpListY, CpListZ, CpListLine: TCPlist;


{****************** Méthodes de TdataPlot *****************************}


constructor TdataPlot.create;
begin
  inherited create;
  visu.init;
  CpEnabled:=true;
end;

destructor TdataPlot.destroy;
begin
  FastCoo.reset;
  visu.done;

  CPlistX.setUO(cpx,0,self);
  CPlistY.setUO(cpy,0,self);
  CPlistZ.setUO(cpz,0,self);
  CPlistLine.setUO(cpLine,0,self);

  inherited destroy;
end;


function TdataPlot.getInsideWindow:Trect;
begin
  getInsideWindow:=visu.getInsideT;
end;

procedure TdataPlot.setWorld(x1,y1,x2,y2:float);
  begin
    setXmin(x1);
    setYmin(y1);
    setXmax(x2);
    setYmax(y2);
  end;

procedure TdataPlot.getWorld(var x1,y1,x2,y2:float);
begin
  with visu do
  begin
    x1:=Xmin;
    y1:=Ymin;
    x2:=Xmax;
    y2:=Ymax;
  end;
end;


procedure TdataPlot.cadrerX(sender:Tobject);
  begin
  end;

procedure TdataPlot.cadrerY(sender:Tobject);
  begin
  end;

procedure TdataPlot.cadrerZ(sender:Tobject);
  begin
  end;

procedure TdataPlot.cadrerC(sender:Tobject);
  begin
  end;


procedure TdataPlot.processMessage(id:integer;source:typeUO;p:pointer);
var
  chg:boolean;
begin
  chg:=false;
  case id of
    UOmsg_CouplingX:
      if CpEnabled and (source<>self) and
         (TdataPlot(source).cpx<>0) and (TdataPlot(source).cpx=cpx) and
         ((TdataPlot(source).Xmin<>Xmin) or (TdataPlot(source).Xmax<>Xmax))  then
          begin
            if not Facquis then
              begin
                Xmin:=TdataPlot(source).Xmin;
                Xmax:=TdataPlot(source).Xmax;
              end;
            chg:=true;
          end;
    UOmsg_CouplingY:
      if CpEnabled and (source<>self) and
         (TdataPlot(source).cpy<>0) and (TdataPlot(source).cpy=cpy) and
         ((TdataPlot(source).Ymin<>Ymin) or (TdataPlot(source).Ymax<>Ymax))  then
          begin
            if not Facquis then
              begin
                Ymin:=TdataPlot(source).Ymin;
                Ymax:=TdataPlot(source).Ymax;
              end;
            chg:=true;
          end;
    UOmsg_CouplingZ:
      if CpEnabled and (source<>self) and
         (TdataPlot(source).cpz<>0) and (TdataPlot(source).cpz=cpz) and
         ((TdataPlot(source).Zmin<>Zmin) or (TdataPlot(source).Zmax<>Zmax))  then
          begin
            if not Facquis then
              begin
                Zmin:=TdataPlot(source).Zmin;
                Zmax:=TdataPlot(source).Zmax;
              end;
            chg:=true;
          end;
  end;

  if chg then
    if Facquis
      then messageToRef(UOmsg_invalidateAcq,nil)
      else invalidate;
end;


procedure TdataPlot.initVisu0;
begin
  new(visu0);
  visu0^.init;
  visu0^.assign(visu);
end;

procedure TdataPlot.doneVisu0;
begin
  visu0^.done;
  dispose(visu0);
  visu0:=nil;
end;

function TdataPlot.ChooseCoo1:boolean;
  var
    chg:boolean;
    title0:AnsiString;
    oldCpx,oldCpy,oldCpz: integer;
  begin
    initVisu0;
    title0:=title;

    if cood.choose(title0,visu0^,cadrerX,cadrerY) then
      begin
        chg:= not visu.compare(visu0^) or (title<>title0);

        if chg then
        begin
          oldCpx:= visu.cpx;
          oldCpy:= visu.cpy;
          oldCpz:= visu.cpz;
          visu.assign(visu0^);
          if oldCpx<>visu0^.cpX then
          begin
            visu.cpX:=OldCpx;
            setCpx(visu0^.cpx);
          end;
          if oldCpy<>visu0^.cpy then
          begin
            visu.cpy:=OldCpy;
            setCpy(visu0^.cpy);
          end;
          if oldCpz<>visu0^.cpz then
          begin
            visu.cpz:=OldCpz;
            setCpz(visu0^.cpz);
          end;

          title:=title0;
        end;
      end
    else chg:=false;

    doneVisu0;

    chooseCoo1:=chg;
  end;

function TdataPlot.FchooseCoo(sender:Tobject):boolean;
  begin
    result:=ChooseCoo1;
    if result then
      begin
        if cpEnabled then
        begin
          if (cpx<>0) then messageCpx;
          if (cpy<>0) then messageCpy;
          if (cpz<>0) then messageCpz;
        end;

        invalidate;
      end;
  end;


procedure TdataPlot.chooseCoo(sender:Tobject);
  var
    modif:boolean;
  begin
    if acquisitionON and AcqFlag then exit;
    modif:=ChooseCoo1;
    if modif then
      begin
        if cpEnabled then
        begin
          if (cpx<>0) then messageCpx;
          if (cpy<>0) then messageCpy;
          if (cpz<>0) then messageCpz;
        end;
        invalidate;
      end;
  end;


procedure TdataPlot.setUnitX(st:AnsiString);
  begin
    visu.ux:=st;
  end;

function TdataPlot.getUnitX:AnsiString;
  begin
    getUnitX:=visu.ux;
  end;

procedure TdataPlot.setUnitY(st:AnsiString);
  begin
    visu.uy:=st;
  end;

function TdataPlot.getUnitY:AnsiString;
  begin
    getUnitY:=visu.uy;
  end;


procedure TdataPlot.AutoscaleX;
  begin
  end;

procedure TdataPlot.AutoscaleY;
  begin
  end;

procedure TdataPlot.AutoscaleZ;
  begin
  end;


procedure TdataPlot.AutoscaleY1;
  begin
  end;

procedure TdataPlot.setXmin(x:double );
  begin
    visu.Xmin:=x;
  end;

procedure TdataPlot.setXmax(x:double);
  begin
    visu.Xmax:=x;
  end;

procedure TdataPlot.setYmin(x:double);
  begin
    visu.Ymin:=x;
  end;

procedure TdataPlot.setYmax(x:double);
  begin
    visu.Ymax:=x;
  end;

procedure TdataPlot.setZmin(x:double);
  begin
    visu.Zmin:=x;
  end;

procedure TdataPlot.setZmax(x:double);
  begin
    visu.Zmax:=x;
  end;


procedure TdataPlot.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  if lecture and not FDoNotLoadDisplayParams then
  begin
    {
    CplistX.setUO(cpx,0,self);
    CplistY.setUO(cpy,0,self);
    CplistZ.setUO(cpZ,0,self);
    CplistLine.setUO(cpLine,0,self);
    }
    cpx:=0;
    cpy:=0;
    cpz:=0;
    cpLine:=0;
  end;

  inherited buildInfo(conf,lecture,tout);
  if lecture and FDoNotLoadDisplayParams then exit;

  with visu do fontToDesc(fontVisu,fontDescA);
  visu.freeFont;
  with conf do
  begin
    setvarconf('PlotVisu',visu,sizeof(visu));
  end;
end;

procedure TdataPlot.CompleteLoadInfo;
var
  w:integer;
begin
  inherited CompleteLoadInfo;

  if FDoNotLoadDisplayParams then exit;

  visu.completeLoadInfo;
  visu.initFont;

  w:= Cpx;
  Cpx:=0;
  Cpx:=w;

  w:= Cpy;
  Cpy:=0;
  Cpy:=w;

  w:= Cpz;
  Cpz:=0;
  Cpz:=w;

  w:= CpLine;
  CpLine:=0;
  CpLine:=w;


{
  CplistX.setUO(0,cpx,self);
  CplistY.setUO(0,cpy,self);
  CplistZ.setUO(0,cpZ,self);
  CplistLine.setUO(0,cpLine,self);
 }
end;

procedure TdataPlot.CompleteSaveInfo;
begin
  inherited;
  visu.initFont;
end;

procedure TdataPlot.translateCoo(plus:boolean);
begin
  visu.translateCoo(plus);
end;


procedure TdataPlot.InvalidateCursors;
begin
  invalidateForm2;
  messageToRef(UOmsg_cursor,nil);
end;

procedure TdataPlot.displayCursors(BMex:TbitmapEx);
var
  i:integer;
begin
  {affdebug('displayCursors 0'+ident);}
  if not assigned(reference) then exit;

  with visu do Dgraphic.setWorld(xmin,ymin,xmax,ymax);


  with reference do
  for i:=0 to count-1 do
    if controleRef(TypeUO(items[i])) then
      with TypeUO(items[i]) do paintCursor(BMex);

  {affdebug('displayCursors '+ident);}
end;

function TdataPlot.getTitleColor:integer;
begin
  result:=visu.color;
end;


function TdataPlot.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TdataPlot,'TdataPlot_FileSaveData').onclick:=FileSaveData;
    PopUpItem(pop_TdataPlot,'TdataPlot_FileSaveObject').onclick:=SaveObjectToFile;
    PopUpItem(pop_TdataPlot,'TdataPlot_FileSaveAsText').onclick:=FileSaveAsText;

    PopUpItem(pop_TdataPlot,'TdataPlot_FileLoad').onclick:=FileLoad;
    PopUpItem(pop_TdataPlot,'TdataPlot_FilePrint').onclick:=FilePrint;
    PopUpItem(pop_TdataPlot,'TdataPlot_FileCopy').onclick:=FileCopy;

    PopUpItem(pop_TdataPlot,'TdataPlot_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_TdataPlot,'TdataPlot_Show').onclick:=self.Show;
    PopupItem(pop_TdataPlot,'TdataPlot_Properties').onclick:=Proprietes;

    result:=pop_TdataPlot;
  end;
end;


procedure TdataPlot.setcolorT(w:longint);
begin
  visu.color:=w;
end;

procedure TdataPlot.setcolorT2(w:longint);
begin
  visu.color2:=w;
end;


procedure TdataPlot.settwoCol(w:boolean);
begin
  visu.twocol:=w;
end;

procedure TdataPlot.setmodeT(w:byte);
begin
  visu.modeT:=w;
end;

procedure TdataPlot.settailleT(w:byte);
begin
  visu.TailleT:=w;
end;

procedure TdataPlot.setlargeurTrait(w:byte);
begin
  visu.largeurTrait:=w;
end;

procedure TdataPlot.setstyleTrait(w:byte);
begin
  visu.styleTrait:=w;
end;

procedure TdataPlot.setmodeLogX(w:boolean);
begin
  visu.modeLogX:=w;
end;

procedure TdataPlot.setmodeLogY(w:boolean);
begin
  visu.modeLogY:=w;
end;

procedure TdataPlot.setgrille(w:boolean);
begin
  visu.grille:=w;
end;

procedure TdataPlot.setcpX(w:smallint);
var
  Amin,Amax:float;
begin
  // On vérifie d'abord s'il existe un autre objet avec le même Cpx
  // Si oui, on modifie les coordonnées X 
  if (w<>0) and not FKeepCoordinates then
    if CpListX.FindLimits(w,UOmsg_CouplingX,Amin,Amax) then
    begin
      Xmin:=Amin;
      Xmax:=Amax;
    end;

  CPlistX.setUO(cpx,w,self);
  visu.cpx:=w;
end;

procedure TdataPlot.setcpY(w:smallint);
var
  Amin,Amax:float;
begin
  if (w<>0) and not FKeepCoordinates then
    if CpListY.FindLimits(w,UOmsg_CouplingY,Amin,Amax) then
    begin
      Ymin:=Amin;
      Ymax:=Amax;
    end;

  CPlistY.setUO(cpy,w,self);
  visu.cpy:=w;
end;
                                                               
procedure TdataPlot.setcpZ(w:smallint);
var
  Amin,Amax:float;
begin
  if (w<>0) and not FKeepCoordinates then
    if CpListZ.FindLimits(w,UOmsg_CouplingZ,Amin,Amax) then
    begin
      Zmin:=Amin;
      Zmax:=Amax;
    end;

  CPlistZ.setUO(cpz,w,self);
  visu.cpz:=w;
end;

function TdataPlot.getCpLine: smallint;
begin
  result:=0;
end;

procedure TdataPlot.setcpLine(w: smallint);
begin
  CPlistLine.setUO(cpLine,w,self);
end;


procedure TdataPlot.setechX(w:boolean);
begin
  visu.echX:=w;
end;

procedure TdataPlot.setechY(w:boolean);
begin
  visu.echY:=w;
end;

procedure TdataPlot.setFtickX(w:boolean);
begin
  visu.FtickX:=w;
end;

procedure TdataPlot.setFtickY(w:boolean);
begin
  visu.FtickY:=w;
end;

procedure TdataPlot.setCompletX(w:boolean);
begin
  visu.completX:=w;
end;

procedure TdataPlot.setcompletY(w:boolean);
begin
  visu.completY:=w;
end;

procedure TdataPlot.setTickExtX(w:boolean);
begin
  visu.tickExtX:=w;
end;

procedure TdataPlot.setTickExtY(w:boolean);
begin
  visu.tickExtY:=w;
end;

procedure TdataPlot.setScaleColor(w:longint);
begin
  visu.scaleColor:=w;
end;


procedure TdataPlot.setinverseX(w:boolean);
begin
  visu.inverseX:=w;
end;

procedure TdataPlot.setinverseY(w:boolean);
begin
  visu.inverseY:=w;
end;

procedure TdataPlot.setKeepRatio(w:boolean);
begin
  visu.KeepRatio:=w;
end;

procedure TdataPlot.setCpxMode(w:byte);
begin
  visu.CpxMode:=w;
end;


function TdataPlot.Xstart:float;
begin
  Xstart:=0;
end;

function TdataPlot.Xend:float;
begin
  Xend:=0;
end;

procedure TdataPlot.setIstart(w:integer);
begin
end;

function TdataPlot.getIstart:longint;
begin
  result:=0;
end;

procedure TdataPlot.setIend(w:integer);
begin
end;

function TdataPlot.getIend:longint;
begin
  result:=0;
end;

function TdataPlot.Icount:integer;
begin
  result:=Iend-Istart+1;
end;

procedure TdataPlot.setIcount(n: integer);
begin

end;


function TdataPlot.Ystart:float;
begin
  result:=0;
end;

function TdataPlot.Yend:float;
begin
  result:=0;
end;


procedure TdataPlot.setJstart(w:integer);
begin
end;

function TdataPlot.getJstart:integer;
begin
  result:=0;
end;

procedure TdataPlot.setJend(w:integer);
begin
end;

function TdataPlot.getJend:integer;
begin
  result:=0;
end;

function TdataPlot.Jcount:integer;
begin
  result:=Jend-Jstart+1;
end;

function TdataPlot.Kcount:integer;
begin
  result:=(Iend-Istart+1)*(Jend-Jstart+1);
end;


procedure TdataPlot.fileSaveData(sender:Tobject);
begin
end;


procedure TdataPlot.fileSaveAsText(sender:Tobject);
begin
end;


procedure TdataPlot.fileLoad(sender:Tobject);
begin
end;


procedure TdataPlot.filePrint(sender:Tobject);
begin
end;

procedure TdataPlot.fileCopy(sender:Tobject);
begin
end;

function TdataPlot.MouseDownMG(numOrdre:integer;Irect:Trect;
            Shift: TShiftState;Xc,Yc,X,Y: Integer):boolean;
var
  i:integer;
  x1,y1,x2,y2:integer;
begin
  getWindowG(x1,y1,x2,y2);
  result:=false;
  if not assigned(reference) then exit;

  UOcap:=nil;
  for i:=0 to reference.count-1 do
    begin
      { sept 2009: Cette partie ne concerne que les curseurs
        Si on a cliqué sur la poignée d'un curseur, on affecte UOcap et on sort
      }
      setWindow(x1,y1,x2,y2);
      Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);
      result:=typeUO(reference.items[i]).MouseDownMG2(Irect,Shift,Xc,Yc,X,Y);
      if result then
        begin
          UOcap:=typeUO(reference.items[i]);  { Curseur capturé . Ce UOcap est différent de Multigraph.UOcap }
          result:=true;
          exit;
        end;
    end;

  //if onMgClick.valid then result:=true;
end;

function TdataPlot.MouseMoveMG(x,y:integer):boolean;
begin
  result:=(UOcap<>nil) and UOcap.mouseMoveMG2(x,y) or OnMgClick.valid;
  if not result then UOcap:=nil;
end;

procedure TdataPlot.MouseUpMG(x,y:integer; mg:typeUO);
begin
  if UOcap<>nil then
  begin
    UOcap.MouseUpMG2(x,y);
    UOcap:=nil;
  end
  else
  if OnMgClick.valid  and assigned(mg) then
  begin
    onMgClick.Pg.executerMouseUpMg(OnMgClick.Ad,Mg,typeUO(self));

  end;
end;

function TdataPlot.MouseRightMG(ControlSource:Twincontrol;numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean;
var
  i:integer;
  rr:Trect;
  x1,y1:integer;
begin
  result:=false;
  uoMenu:=nil;

  {coo du clic en coo client}
  x1:=xc+x-(ControlSource.clientOrigin.x+leftGlb);
  y1:=yc+y-(ControlSource.clientOrigin.y+topGlb);

  {si l'objet est le premier dans le cadre}
  if numOrdre=0 then
    begin
      rr:=rect(Irect.left,Irect.bottom,x2act,y2act);  {coo client}
      {et si le clic est dans la partie basse}
      if ptInRect(rr,classes.point(x1,y1)) then
        begin
          {installer la fenêtre controle des coo X}
          InstallFastCooX(ControlSource,rr,xc,yc);
          result:=true;
          exit;
        end;

      rr:=rect(x1act,y1act,Irect.left,y1act+(Irect.bottom-Irect.Top) div 2);
      {ou si le clic est dans la partie supérieure gauche}
      if ptInRect(rr,classes.point(x1,y1)) then
        begin
          {installer la fenêtre controle des coo Y}
          InstallFastCooY(ControlSource,rr,xc,yc);
          result:=true;
          exit;
        end;

       rr:=rect(x1act,y1act,Irect.left,Irect.bottom);
      {ou si le clic est dans la partie inférieure gauche}
      if ptInRect(rr,classes.point(x1,y1)) then
        begin
          {installer la fenêtre controle des coo Z}
          if withZ
            then InstallFastCooZ(ControlSource,rr,xc,yc)
            else InstallFastCooY(ControlSource,rr,xc,yc);
          result:=true;
          exit;
        end;

    end;

  if not assigned(reference) then exit;

  Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

  for i:=0 to reference.count-1 do
    begin
      result:=typeUO(reference.items[i]).MouseRightMG2(numOrdre,Irect,Shift,Xc,Yc,X,Y,uoMenu);
      if result then exit;
    end;
end;


procedure TdataPlot.scrollPosX(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  delta:float;
begin
  delta:=Xmax-Xmin;
  Xmin:=x;
  Xmax:=x+delta;

  with FastCoo do
  begin
    LXmin.caption:=Estr(Xmin,3);
    LXmax.caption:=Estr(Xmax,3);
  end;
  if scrollCode<>scTrack then
    begin
      if Facquis
        then messageToRef(UOmsg_invalidateAcq,nil)
        else invalidate;
      if cpEnabled and(cpx<>0) then messageCpx;
    end;
end;

procedure TdataPlot.scrollRangeX(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  x0,delta,k:float;
begin
  if not (scrollCode in [scLineUp,scLineDown,scPageUp,scPageDown]) then exit;
  if Xmin=Xmax then exit;

  x0:=(Xmax+Xmin)/2;
  delta:=(Xmax-Xmin)/2;

  case scrollcode of
    scLineUp: k:=sqrt(2);
    scLineDown: k:=1/sqrt(2);
    scPageUp:   k:=2;
    scPageDown:   k:=1/2;
  end;

  Xmin:=x0-k*delta;
  Xmax:=x0+k*delta;

  with FastCoo do
  begin
    LXmin.caption:=Estr(Xmin,3);
    LXmax.caption:=Estr(Xmax,3);

    SBposX.setParams(Xmin,xdebScr,xFinScr);
    SBposX.dxSmall:=(Xmax-Xmin)/100;
    SBposX.dxLarge:=(Xmax-Xmin)/10;
  end;

  if Facquis
    then messageToRef(UOmsg_invalidateAcq,nil)
    else invalidate;
  if cpEnabled and(cpx<>0) then messageCpx;

end;

procedure TdataPlot.clickCadrerX(Sender: TObject);
begin
  fastCoo.reset;
  autoscaleX;
  invalidate;
  if cpEnabled and(cpx<>0) then messageCpx;
end;


procedure TdataPlot.installFastCooX(controlSource:Twincontrol;rr:Trect;xc,yc:integer);
var
  delta:float;
  x1,y1:integer;
begin
  if Facquis then exit;

  delta:=Xmax-Xmin;
  xdebScr:=Xstart;
  xFinScr:=Xend;
  if xFinScr<=xdebScr then
    begin
      xdebScr:=Xmin-delta*100;
      xFinScr:=Xmax+delta*100;
    end;

  with FastCoo,panelX do
  begin
    parent:=controlSource;
    FastCoo.adjustSize(rr.right-rr.left,rr.bottom-rr.top);

    x1:=rr.left+leftGlb; {coo paintbox du panelX}
    if x1+width>widthGlb-1 then x1:=widthGlb-width-1;
    if x1<0 then
      begin
        reset;
        exit;
      end;
    left:=x1;

    y1:=rr.top+topGlb+2;
    if y1+height>topGlb+heightGlb-1 then y1:=topGlb+heightGlb-height-1;
    if y1<0 then
      begin
        reset;
        exit;
      end;
    top:=y1;

    LXmin.caption:=Estr(Xmin,3);

    SBposX.setParams(Xmin,xdebScr,xFinScr);
    SBposX.dxSmall:=(Xmax-Xmin)/100;
    SBposX.dxLarge:=(Xmax-Xmin)/10;
    SBposX.onScrollV:=scrollPosX;

    LXmax.caption:=Estr(Xmax,3);

    SBrangeX.setParams(0,-10000,10000);
    SBrangeX.onScrollV:=scrollRangeX;

    bCadrerX.onClick:=clickCadrerX;
  end;
end;

procedure TdataPlot.scrollPosY(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  delta:float;
begin
  delta:=Ymax-Ymin;
  Ymin:=x;
  Ymax:=x+delta;

  with FastCoo do
  begin
    LYmin.caption:=Estr(Ymin,3);
    LYmax.caption:=Estr(Ymax,3);
  end;
  if scrollCode<>scTrack then
    begin
      if Facquis
        then messageToRef(UOmsg_invalidateAcq,nil)
        else invalidate;
      if cpEnabled and(cpy<>0) then messageCpy;
    end;
end;

procedure TdataPlot.scrollRangeY(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  y0,delta,k:float;
begin
  if not (scrollCode in [scLineUp,scLineDown,scPageUp,scPageDown]) then exit;
  if Ymin=Ymax then exit;

  y0:=(Ymax+Ymin)/2;
  delta:=(Ymax-Ymin)/2;

  case scrollcode of
    scLineUp: k:=1/sqrt(2);
    scLineDown: k:=sqrt(2);
    scPageUp:   k:=1/2;
    scPageDown:   k:=2;
  end;

  Ymin:=y0-k*delta;
  Ymax:=y0+k*delta;

  with FastCoo do
  begin
    LYmin.caption:=Estr(Ymin,3);
    LYmax.caption:=Estr(Ymax,3);

    SBposY.setParams(Ymin,ydebScr,yFinScr);
    SBposY.dxSmall:=(Ymax-Ymin)/100;
    SBposY.dxLarge:=(Ymax-Ymin)/10;
  end;

  if Facquis
    then messageToRef(UOmsg_invalidateAcq,nil)
    else invalidate;
  if cpEnabled and (cpy<>0) then messageCpy;

end;

procedure TdataPlot.clickCadrerY(Sender: TObject);
begin
  fastCoo.reset;
  if not Facquis then
    begin
      autoscaleY;
      if Ymin=Ymax then
        begin
          Ymin:=0;
          Ymax:=100;
        end;
       with FastCoo do
       begin
         LYmin.caption:=Estr(Ymin,3);
         LYmax.caption:=Estr(Ymax,3);
       end;

      invalidate;
      if cpEnabled and (cpy<>0) then messageCpy;
    end
  else
    begin
      messageToRef(UOmsg_autoScaleAcq,nil);
      if cpEnabled and (cpy<>0) then messageCpy;

       with FastCoo do
       begin
         LYmin.caption:=Estr(Ymin,3);
         LYmax.caption:=Estr(Ymax,3);
       end;
    end;

end;

procedure TdataPlot.clickLevelY(Sender: TObject);
var
  dd,mm:float;
begin
  fastCoo.reset;
  if not Facquis then
    begin
      dd:=Ymax-Ymin;
      mm:=getMean(Xmin,Xmax);
      Ymin:=mm-dd/2;
      Ymax:=mm+dd/2;
      if Ymin=Ymax then
        begin
          Ymin:=0;
          Ymax:=100;
        end;

       with FastCoo do
       begin
         LYmin.caption:=Estr(Ymin,3);
         LYmax.caption:=Estr(Ymax,3);
       end;

      invalidate;
      if cpEnabled and (cpy<>0) then messageCpy;
    end
  else
    begin
      messageToRef(UOmsg_SetLevelAcq,nil);
      if cpEnabled and (cpy<>0) then messageCpy;

       with FastCoo do
       begin
         LYmin.caption:=Estr(Ymin,3);
         LYmax.caption:=Estr(Ymax,3);
       end;
    end;

end;


procedure TdataPlot.installFastCooY(controlSource:Twincontrol;rr:Trect;xc,yc:integer);
var
  yamp,delta:float;
  x1,y1:integer;
begin
  if abs(Ymin)<abs(Ymax) then yamp:=abs(Ymax) else yamp:=abs(Ymin);
  ydebScr:=-yamp*10;
  yfinScr:=yamp*10;
  delta:=Ymax-Ymin;

  with FastCoo,panelY do
  begin
    parent:=controlSource;
    {adjustSizeY(rr.right-rr.left,rr.bottom-rr.top);}

    x1:=rr.left+leftGlb; {coo paintbox du panelY}
    if x1+width>widthGlb-1 then x1:=widthGlb-width-1;
    if x1<0 then
      begin
        reset;
        exit;
      end;
    left:=x1;

    y1:=rr.top+topGlb+2;
    if y1+height>topGlb+heightGlb-1 then y1:=topGlb+heightGlb-height-1;
    if y1<0 then
      begin
        reset;
        exit;
      end;
    top:=y1;

    LYmin.caption:=Estr(Ymin,3);

    SBposY.setParams(Ymin,ydebScr,yFinScr);
    SBposY.dxSmall:=(Ymax-Ymin)/100;
    SBposY.dxLarge:=(Ymax-Ymin)/10;
    SBposY.onScrollV:=scrollPosY;

    LYmax.caption:=Estr(Ymax,3);

    SBrangeY.setParams(ln(abs(Ymax-Ymin)/(yFinScr-ydebScr)),ln(1/1000000),ln(4));
    SBrangeY.dxSmall:=ln(sqrt(2));
    SBrangeY.dxLarge:=ln(2);
    SBrangeY.onScrollV:=scrollRangeY;

    bcadrerY.onClick:=ClickCadrerY;
    blevel.onClick:=ClickLevelY;
  end;
end;

procedure TdataPlot.scrollPosZ(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  delta:float;
begin
  delta:=Zmax-Zmin;
  Zmin:=x;
  Zmax:=x+delta;

  with FastCoo do
  begin
    LYmin.caption:=Estr(Zmin,3);
    LYmax.caption:=Estr(Zmax,3);
  end;
  if scrollCode<>scTrack then
    begin
      invalidate;
      if cpEnabled and(cpz<>0) then messageCpz;
    end;
end;

procedure TdataPlot.scrollRangeZ(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  y0,delta,k:float;
begin
  if not (scrollCode in [scLineUp,scLineDown,scPageUp,scPageDown]) then exit;
  if Zmin=Zmax then exit;

  y0:=(Zmax+Zmin)/2;
  delta:=(Zmax-Zmin)/2;

  case scrollcode of
    scLineUp: k:=1/sqrt(2);
    scLineDown: k:=sqrt(2);
    scPageUp:   k:=1/2;
    scPageDown:   k:=2;
  end;

  Zmin:=y0-k*delta;
  Zmax:=y0+k*delta;

  with FastCoo do
  begin
    LYmin.caption:=Estr(Zmin,3);
    LYmax.caption:=Estr(Zmax,3);

    SBposY.setParams(Zmin,zdebScr,zFinScr);
    SBposY.dxSmall:=(Zmax-Zmin)/100;
    SBposY.dxLarge:=(Zmax-Zmin)/10;
  end;

  invalidate;
  if cpEnabled and (cpz<>0) then messageCpz;

end;

procedure TdataPlot.clickCadrerZ(Sender: TObject);
begin
  fastCoo.reset;

  autoscaleZ;
  if Zmin=Zmax then
    begin
      Zmin:=0;
      Zmax:=100;
    end;
   with FastCoo do
   begin
     LYmin.caption:=Estr(Zmin,3);
     LYmax.caption:=Estr(Zmax,3);
   end;

  invalidate;
  if cpEnabled and (cpz<>0) then messageCpz;

end;

procedure TdataPlot.installFastCooZ(controlSource:Twincontrol;rr:Trect;xc,yc:integer);
var
  yamp,delta:float;
  x1,y1:integer;
begin
  if abs(Zmin)<abs(Zmax) then yamp:=abs(Zmax) else yamp:=abs(Zmin);
  zdebScr:=-yamp*10;
  zfinScr:=yamp*10;
  delta:=Zmax-Zmin;

  with FastCoo,panelY do
  begin
    parent:=controlSource;
    {adjustSizeY(rr.right-rr.left,rr.bottom-rr.top);}

    x1:=rr.left+leftGlb; {coo paintbox du panelY}
    if x1+width>widthGlb-1 then x1:=widthGlb-width-1;
    if x1<0 then
      begin
        reset;
        exit;
      end;
    left:=x1;

    y1:=topGlb+rr.bottom-height-1;
    if y1+height>topGlb+heightGlb-1 then y1:=topGlb+heightGlb-height-1;
    if y1<0 then
      begin
        reset;
        exit;
      end;
    top:=y1;

    LYmin.caption:=Estr(Zmin,3);

    SBposY.setParams(Zmin,zdebScr,zFinScr);
    SBposY.dxSmall:=(Zmax-Zmin)/100;
    SBposY.dxLarge:=(Zmax-Zmin)/10;
    SBposY.onScrollV:=scrollPosZ;

    LYmax.caption:=Estr(Zmax,3);

    SBrangeY.setParams(ln(abs(Zmax-Zmin)/(zFinScr-zdebScr)),ln(1/1000000),ln(4));
    SBrangeY.dxSmall:=ln(sqrt(2));
    SBrangeY.dxLarge:=ln(2);
    SBrangeY.onScrollV:=scrollRangeZ;

    bcadrerY.onClick:=ClickCadrerZ;
  end;
end;



procedure TdataPlot.AdjustXminXmax(x0:float);
var
  flag:boolean;
  d,dum:float;
begin
  d:=Xmax-Xmin;
  if d=0 then exit;

  flag:= (d<0);
  if flag then
    begin
      dum:=Xmin;
      Xmin:=Xmax;
      Xmax:=dum;
      d:=-d;
    end;

  while (x0>Xmax) do
  begin
    Xmin:=Xmin+d;
    Xmax:=Xmax+d;
  end;

  while (x0<Xmin) do
  begin
    Xmin:=Xmin-d;
    Xmax:=Xmax-d;
  end;

  if flag then
    begin
      dum:=Xmin;
      Xmin:=Xmax;
      Xmax:=dum;
    end;

end;

procedure TdataPlot.ReinitXminXmax;
begin
  Xmax:=Xmax-Xmin;
  Xmin:=0;
end;

procedure TdataPlot.getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                              var x1,y1,x2,y2:float);
begin
  Fworld:=false;
  FlogX:=visu.modelogX;
  FlogY:=visu.modelogY;
  x1:=visu.Xmin;
  x2:=visu.Xmax;
  y1:=visu.Ymin;
  y2:=visu.Ymax;

end;


function TdataPlot.withZ: boolean;
begin
  result:=false;
end;


function TdataPlot.isModified: boolean;
begin
  result:=not compareMem(@visu,@visuModel,sizeof(visu));
end;

procedure TdataPlot.swapFont(var font:Tfont;var color:integer);
begin
  swapmem(visu.fontVisu,font,sizeof(pointer));
  swap(visu.scaleColor,color);
end;

procedure TdataPlot.swapVisu(visu1: PvisuInfo;flags: PvisuFlags);
begin
  if assigned(visu1) and assigned(flags) then
  begin
    if flags[VF_Xmin] then swapmem(visu1^.Xmin,visu.Xmin,sizeof(visu.Xmin));
    if flags[VF_Xmax] then swapmem(visu1^.Xmax,visu.Xmax,sizeof(visu.Xmax));
    if flags[VF_Ymin] then swapmem(visu1^.Ymin,visu.Ymin,sizeof(visu.Ymin));
    if flags[VF_Ymax] then swapmem(visu1^.Ymax,visu.Ymax,sizeof(visu.Ymax));
    if flags[VF_Zmin] then swapmem(visu1^.Zmin,visu.Zmin,sizeof(visu.Zmin));
    if flags[VF_Zmax] then swapmem(visu1^.Zmax,visu.Zmax,sizeof(visu.Zmax));
    if flags[VF_gamma] then swapmem(visu1^.gamma,visu.gamma,sizeof(visu.gamma));
    if flags[VF__aspect] then swapmem(visu1^._aspect,visu._aspect,sizeof(visu._aspect));
    if flags[VF_ux] then swapmem(visu1^.ux,visu.ux,sizeof(visu.ux));
    if flags[VF_uy] then swapmem(visu1^.uy,visu.uy,sizeof(visu.uy));
    if flags[VF_color] then swapmem(visu1^.color,visu.color,sizeof(visu.color));
    if flags[VF_twoCol] then swapmem(visu1^.twoCol,visu.twoCol,sizeof(visu.twoCol));
    if flags[VF_modeT] then swapmem(visu1^.modeT,visu.modeT,sizeof(visu.modeT));
    if flags[VF_tailleT] then swapmem(visu1^.tailleT,visu.tailleT,sizeof(visu.tailleT));
    if flags[VF_largeurTrait] then swapmem(visu1^.largeurTrait,visu.largeurTrait,sizeof(visu.largeurTrait));
    if flags[VF_styleTrait] then swapmem(visu1^.styleTrait,visu.styleTrait,sizeof(visu.styleTrait));
    if flags[VF_modeLogX] then swapmem(visu1^.modeLogX,visu.modeLogX,sizeof(visu.modeLogX));
    if flags[VF_modeLogY] then swapmem(visu1^.modeLogY,visu.modeLogY,sizeof(visu.modeLogY));
    if flags[VF_grille] then swapmem(visu1^.grille,visu.grille,sizeof(visu.grille));
    if flags[VF_cpX] then swapmem(visu1^.cpX,visu.cpX,sizeof(visu.cpX));
    if flags[VF_cpY] then swapmem(visu1^.cpY,visu.cpY,sizeof(visu.cpY));
    if flags[VF_cpZ] then swapmem(visu1^.cpZ,visu.cpZ,sizeof(visu.cpZ));

    if flags[VF_echX] then swapmem(visu1^.echX,visu.echX,sizeof(visu.echX));
    if flags[VF_echY] then swapmem(visu1^.echY,visu.echY,sizeof(visu.echY));
    if flags[VF_FtickX] then swapmem(visu1^.FtickX,visu.FtickX,sizeof(visu.FtickX));
    if flags[VF_FtickY] then swapmem(visu1^.FtickY,visu.FtickY,sizeof(visu.FtickY));
    if flags[VF_CompletX] then swapmem(visu1^.CompletX,visu.CompletX,sizeof(visu.CompletX));
    if flags[VF_completY] then swapmem(visu1^.completY,visu.completY,sizeof(visu.completY));
    if flags[VF_TickExtX] then swapmem(visu1^.TickExtX,visu.TickExtX,sizeof(visu.TickExtX));
    if flags[VF_TickExtY] then swapmem(visu1^.TickExtY,visu.TickExtY,sizeof(visu.TickExtY));
    if flags[VF_ScaleColor] then swapmem(visu1^.ScaleColor,visu.ScaleColor,sizeof(visu.ScaleColor));

    if flags[VF_fontVisu] then swapmem(visu1^.fontVisu,visu.fontVisu,sizeof(visu.fontVisu));
    

    if flags[VF_inverseX] then swapmem(visu1^.inverseX,visu.inverseX,sizeof(visu.inverseX));
    if flags[VF_inverseY] then swapmem(visu1^.inverseY,visu.inverseY,sizeof(visu.inverseY));
    if flags[VF_Epduration] then swapmem(visu1^.Epduration,visu.Epduration,sizeof(visu.Epduration));

    if flags[VF_ModeMat] then swapmem(visu1^.ModeMat,visu.ModeMat,sizeof(visu.ModeMat));
    if flags[VF_keepRatio] then swapmem(visu1^.keepRatio,visu.keepRatio,sizeof(visu.keepRatio));
    if flags[VF_color2] then swapmem(visu1^.color2,visu.color2,sizeof(visu.color2));

    if flags[VF_CpxMode] then swapmem(visu1^.CpxMode,visu.CpxMode,sizeof(visu.CpxMode));
    if flags[VF_AngularMode] then swapmem(visu1^.AngularMode,visu.AngularMode,sizeof(visu.AngularMode));
    if flags[VF_AngularLW] then swapmem(visu1^.AngularLW,visu.AngularLW,sizeof(visu.AngularLW));
    if flags[VF_Cmin] then swapmem(visu1^.Cmin,visu.Cmin,sizeof(visu.Cmin));
    if flags[VF_Cmax] then swapmem(visu1^.Cmax,visu.Cmax,sizeof(visu.Cmax));
    if flags[VF_gammaC] then swapmem(visu1^.gammaC,visu.gammaC,sizeof(visu.gammaC));
    if flags[VF_FscaleX0] then swapmem(visu1^.FscaleX0,visu.FscaleX0,sizeof(visu.FscaleX0));
    if flags[VF_FscaleY0] then swapmem(visu1^.FscaleY0,visu.FscaleY0,sizeof(visu.FscaleY0));
    if flags[VF_modeLogZ] then swapmem(visu1^.modeLogZ,visu.modeLogZ,sizeof(visu.modeLogZ));

    if flags[VF_Gdisp] then swapmem(visu1^.Gdisp,visu.Gdisp,sizeof(visu.Gdisp));
    if flags[VF_Xdisp] then swapmem(visu1^.Xdisp,visu.Xdisp,sizeof(visu.Xdisp));
    if flags[VF_Ydisp] then swapmem(visu1^.Ydisp,visu.Ydisp,sizeof(visu.Ydisp));
    if flags[VF_FullD2] then swapmem(visu1^.FullD2,visu.FullD2,sizeof(visu.FullD2));

  end;
end;

procedure TdataPlot.setAspectRatio(w: single);
begin

end;

function TdataPlot.getAspectRatio:single;
begin
  result:=1;
end;

procedure TdataPlot.setPixelRatio(w: single);
begin
  if Icount>0
    then aspectRatio:=w*Jcount/Icount
    else aspectRatio:=1;
end;

function TdataPlot.getPixelRatio: single;
begin
  if Jcount>0
    then result:=aspectRatio*Icount/Jcount
    else result:=1;
end;




{Calcule xmin, xmax, ymin, ymax à partir de Gdisp, xdisp, ydisp
 utilisé par OIseq et BitmapPlot
}


{Fixe Xmin en conservant l'intervalle Xmax-Xmin }
procedure TdataPlot.AdjustXmin(x0: float);
var
 delta:float;
begin
  delta:=Xmax-Xmin;
  Xmin:=x0;
  Xmax:=x0+delta;
end;

procedure TdataPlot.GdispToWorld(Gdisp,xdisp,ydisp:float);
var
  h,w: float;             {dimensions de la fenêtre en pixels }
  Dimx,DimY:float;        {dimensions de l'objets en pixels }
  Gm:float;               {facteur de gain optimal: quand l'objet utilise au mieux la fenêtre }
  Gtot:float;
  x00,y00:float;

  i1,i2,j1,j2:integer;    {fenêtre d'affichage}
  Xend1,Yend1:float;

begin
  Xend1:=100;
  Yend1:=100;

  DimX:=100;
  Dimy:=100;

  x00:=50+xDisp;
  y00:=50+yDisp;

  getWindowG(i1,j1,i2,j2);
  w:=i2-i1;
  h:=j2-j1;


  if Dimy/Dimx>h/w
    then Gm:=H/DimY
    else Gm:=W/DimX;

  Gtot:=GDisp*Gm;
  if Gtot<0.0001 then Gtot:=0.0001;

  xmin:=x00- W/2/Gtot;
  xmax:=x00+ W/2/Gtot;

  ymin:=y00- H/2/Gtot;
  ymax:=y00+ H/2/Gtot;
end;


procedure TdataPlot.WorldToGdisp(var Gdisp,xdisp,ydisp:float);
var
  h,w: float;             {dimensions de la fenêtre en pixels }
  Dimx,DimY:float;        {dimensions de l'objets en pixels }
  Gm:float;               {facteur de gain optimal: quand l'objet utilise au mieux la fenêtre }
  Gtot:float;             {facteur de gain total actuel}

  i1,i2,j1,j2:integer;    {fenêtre d'affichage}
  Xend1,Yend1:float;

begin
  Xend1:=100;
  Yend1:=100;

  DimX:=100;
  Dimy:=100;

  getWindowG(i1,j1,i2,j2);
  w:=i2-i1;
  h:=j2-j1;

  if Dimy/Dimx>h/w
    then Gm:=H/DimY
    else Gm:=W/DimX;


  Gtot:=w/(Xmax-Xmin);
  Gdisp:=Gtot/Gm;
  Xdisp:=Xmin+W/2/Gtot-50;
  Ydisp:=Ymin+H/2/Gtot-50;
end;


function TdataPlot.getMean(x1,x2:float):float;
begin
  result:=0;
end;


function TdataPlot.getCoupledBinXY: boolean;
begin
  result:=false;
end;

procedure TdataPlot.setCoupledBinXY(w: boolean);
begin

end;

function TdataPlot.indexToReal(id: integer): float;
begin
  result:=id;
end;

procedure TdataPlot.messageCpx;
begin
  CpListX.sendMessage(Cpx,UOmsg_couplingX,self);
end;

procedure TdataPlot.messageCpy;
begin
  CpListY.sendMessage(Cpy,UOmsg_couplingY,self);
end;

procedure TdataPlot.messageCpz;
begin
  CpListZ.sendMessage(Cpz,UOmsg_couplingZ,self);
end;

procedure TdataPlot.messageCpLine;
begin
  CpListLine.sendMessage(CpLine,UOmsg_LineCoupling,self);
end;

function TdataPlot.FindLimits(id: integer; var Amin, Amax: float): boolean;
begin
  result:=false;
  case id of
    UOmsg_couplingX: begin
                       Amin:=Xmin;
                       Amax:=Xmax;
                       result:=true;
                     end;
    UOmsg_couplingY: begin
                       Amin:=Ymin;
                       Amax:=Ymax;
                       result:=true;
                     end;
  end;

end;




{***************** Méthodes STM pour TdataPlot ****************************}

var
  E_lineWidth:integer;

procedure proTdataPlot_SetWorld(x1,y1,x2,y2:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      SetWorld(x1,y1,x2,y2);
      if (cpx<>0) or (cpy<>0) then
        begin
          if cpEnabled then
          begin
            if (cpx<>0) then messageCPx;
            if (cpy<>0) then messageCPy;
          end;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;

procedure proTdataPlot_GetWorld(var x1,y1,x2,y2:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).GetWorld(x1,y1,x2,y2);
  end;

function fonctionTdataPlot_Xmin(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Xmin:=TdataPlot(pu).Xmin;
  end;

procedure proTdataPlot_Xmin(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      setXmin(x);
      if Cpx<>0 then
        begin
          if cpEnabled and (cpx<>0) then messageCpx;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;



function fonctionTdataPlot_Xmax(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Xmax:=TdataPlot(pu).Xmax;
  end;

procedure proTdataPlot_Xmax(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      setXmax(x);
      if cpx<>0 then
        begin
          if cpEnabled and (cpx<>0) then messageCpx;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;

function fonctionTdataPlot_Ymin(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Ymin:=TdataPlot(pu).Ymin;
  end;

procedure proTdataPlot_Ymin(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      setYmin(x);
      if cpy<>0 then
        begin
          if cpEnabled and (cpy<>0) then messageCpy;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;

function fonctionTdataPlot_Ymax(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Ymax:=TdataPlot(pu).Ymax;
  end;

procedure proTdataPlot_Ymax(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      setYmax(x);
      if cpy<>0 then
        begin
          if cpEnabled and (cpy<>0) then messageCpy;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;

function fonctionTdataPlot_Cpx(var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Cpx:=TdataPlot(pu).cpx;
  end;

procedure proTdataPlot_Cpx(x:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      Cpx:=x;
    end;
  end;

function fonctionTdataPlot_Cpy(var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Cpy:=TdataPlot(pu).cpy;
  end;

procedure proTdataPlot_Cpy(x:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      Cpy:=x;
    end;
  end;

function fonctionTdataPlot_Cpz(var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Cpz:=TdataPlot(pu).cpz;
  end;

procedure proTdataPlot_Cpz(x:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      Cpz:=x;
    end;
  end;


function fonctionTdataPlot_unitX(var pu:typeUO):AnsiString;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_unitX:=TdataPlot(pu).unitX;
  end;

procedure proTdataPlot_unitX(x:AnsiString;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).UnitX:=x;
  end;

function fonctionTdataPlot_unitY(var pu:typeUO):AnsiString;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_unitY:=TdataPlot(pu).unitY;
  end;

procedure proTdataPlot_unitY(x:AnsiString;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).UnitY:=x;
  end;


procedure proTdataPlot_AutoscaleX(var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      autoscaleX;
      if cpEnabled and (cpx<>0) then  messageCpx;
    end;
  end;

procedure proTdataPlot_AutoscaleY(var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      autoscaleY;
      if cpEnabled and (cpy<>0) then  messageCpy;
    end;
  end;

procedure proTdataPlot_AutoscaleY1(var pu:typeUO);
  begin
    verifierObjet(pu);
    with TdataPlot(pu) do
    begin
      autoscaleY1;
      if cpEnabled and (cpy<>0) then  messageCpy;
    end;
  end;


procedure proTdataPlot_LogX(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).modelogX:=x;
end;

function fonctionTdataPlot_LogX(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTdataPlot_LogX:=TdataPlot(pu).modelogX;
end;

procedure proTdataPlot_LogY(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).modelogY:=x;
end;

function fonctionTdataPlot_LogY(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTdataPlot_LogY:=TdataPlot(pu).modelogY;
end;

procedure proTdataPlot_Xscale(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).echX:=x;
end;

function fonctionTdataPlot_Xscale(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTdataPlot_Xscale:=TdataPlot(pu).echX;
end;

procedure proTdataPlot_Yscale(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).echY:=x;
end;

function fonctionTdataPlot_Yscale(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTdataPlot_Yscale:=TdataPlot(pu).echY;
end;

procedure proTdataPlot_Xticks(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).FtickX:=x;
end;

function fonctionTdataPlot_Xticks(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).FtickX;
end;

procedure proTdataPlot_Yticks(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).FtickY:=x;
end;

function fonctionTdataPlot_Yticks(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).FtickY;
end;

procedure proTdataPlot_ExtTicksX(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).TickExtX:=x;
end;

function fonctionTdataPlot_ExtTicksX(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).TickExtX;
end;


procedure proTdataPlot_ExtTicksY(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).TickExtY:=x;
end;

function fonctionTdataPlot_ExtTicksY(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).TickExtY;
end;


procedure proTdataPlot_RightTicks(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).completY:=x;
end;

function fonctionTdataPlot_RightTicks(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).completY;
end;

procedure proTdataPlot_TopTicks(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).completX:=x;
end;

function fonctionTdataPlot_TopTicks(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).completX;
end;

procedure proTdataPlot_ScaleColor(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).ScaleColor:=x;
end;

function fonctionTdataPlot_ScaleColor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).scaleColor;
end;

procedure proTdataPlot_inverseX(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).inverseX:=b;
  end;

function fonctionTdataPlot_inverseX(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_inverseX:=TdataPlot(pu).inverseX;
  end;

procedure proTdataPlot_inverseY(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).inverseY:=b;
  end;

function fonctionTdataPlot_inverseY(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_inverseY:=TdataPlot(pu).inverseY;
  end;



function fonctionTdataPlot_ChooseCoo(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TdataPlot(pu) do
    fonctionTdataPlot_ChooseCoo:=FchooseCoo(nil);
end;



procedure proTdataPlot_color(x:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).colorT:=x;
  end;

function fonctionTdataPlot_color(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_color:=TdataPlot(pu).colorT;
  end;

procedure proTdataPlot_color2(x:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataPlot(pu).colorT2:=x;
  end;

function fonctionTdataPlot_color2(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    result:=TdataPlot(pu).colorT2;
  end;

procedure proTdataPlot_Mode(x:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(x,1,nbStyleTrace);
    TdataPlot(pu).modeT:=x;
  end;

function fonctionTdataPlot_Mode(var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_Mode:=TdataPlot(pu).modeT;
  end;

procedure proTdataPlot_SymbolSize(x:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(x,1,10000);
    TdataPlot(pu).tailleT:=x;
  end;

function fonctionTdataPlot_SymbolSize(var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    fonctionTdataPlot_SymbolSize:=TdataPlot(pu).TailleT;
  end;

procedure proTdataPlot_lineWidth(x:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  if x<=0 then sortieErreur(E_lineWidth);
  with TdataPlot(pu) do largeurTrait:=x;
end;

function fonctionTdataPlot_lineWidth(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).largeurTrait;
end;

procedure proTdataPlot_LineStyle(w:integer ;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).styleTrait:=w;
end;

function fonctionTdataPlot_LineStyle(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TdataPlot(pu).styleTrait;
end;


procedure proTdataPlot_keepAspectRatio(b:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).keepRatio:=b;
end;

function fonctionTdataPlot_keepAspectRatio(var pu:typeUO):boolean;pascal;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).keepRatio;
end;

function fonctionTdataPlot_font(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TdataPlot(pu) do
  begin
    result:=visu.fontVisu;
  end;
end;


procedure proTdataPlot_ZeroAxisX(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).visu.FscaleX0:=x;
end;

function fonctionTdataPlot_ZeroAxisX(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).visu.FscaleX0;
end;


procedure proTdataPlot_ZeroAxisY(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).visu.FscaleY0:=x;
end;

function fonctionTdataPlot_ZeroAxisY(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).visu.FscaleY0;
end;

procedure proTdataPlot_Fgrid(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataPlot(pu).visu.grille:=x;
end;


function fonctionTdataPlot_Fgrid(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TdataPlot(pu).visu.grille;
end;

procedure ProSuspendCouplings;
begin
  CplistX.suspend;
  CplistY.suspend;
  CplistZ.suspend;
end;

procedure ProUpdateCouplings;
begin
  TdataPlot.UpdateCouplings
end;

procedure RebuildCouplings;
var
  i: integer;
begin
  CpListX.Blocked:=false;
  CpListY.Blocked:=false;
  CpListZ.Blocked:=false;

  CpListX.clear;
  CpListY.clear;
  CpListZ.clear;

  for i:=0 to syslist.Count-1 do
  if typeUO(syslist[i]) is TdataPlot then
  with TdataPlot(syslist[i]) do
  begin
    if cpx<>0 then CPlistX.setUORebuild(cpx,typeUO(syslist[i]));
    if cpy<>0 then CPlistY.setUORebuild(cpy,typeUO(syslist[i]));
    if cpz<>0 then CPlistz.setUORebuild(cpz,typeUO(syslist[i]));
  end;
end;


procedure BlockCouplings;
begin
  CpListX.Blocked:= true;
  CpListY.Blocked:= true;
  CpListZ.Blocked:= true;

end;

class procedure TdataPlot.UpdateCouplings;
begin
  CplistX.UpdateCp(UOmsg_couplingX);
  CplistY.UpdateCp(UOmsg_couplingY);
  CplistZ.UpdateCp(UOmsg_couplingZ);
end;

Initialization
AffDebug('Initialization stmDplot',0);

installError(E_lineWidth,'TdataPlot: invalid line width');

CPlistX:=TCPlist.create;
CPlistY:=TCPlist.create;
CPlistZ:=TCPlist.create;
CPlistLine:=TCPlist.create;

AddToTerminationlist(TdataPlot.UpdateCouplings);

end.
