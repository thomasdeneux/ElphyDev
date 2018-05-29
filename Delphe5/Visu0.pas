unit Visu0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  Windows,graphics,classes,sysutils,math,
      util1,Dgraphic,Dtrace1,dtf0,tbe0,Dgrad1,
      Daffmat,Dpalette,
      debug0,
      dibG,

      stmDef;

{ TvisuInfo contient les paramètres d'affichage d'une trace ou d'une matrice }
{ C'est un Record plutôt qu'un objet }
{ Il est utilisé dans la saisie de coordonnées ==> Cood0 }
{ et par dataF0 }



Const
  nbComplexMode=8;
  LongNomComplexMode=7;
  tbComplexMode:array[1..nbComplexMode] of string[LongNomComplexMode]=(
  'X',
  'Y',
  'MDL',
  'ARG',
  'X/Y',
  'Y/X',
  'MDL/ARG',
  'ARG/MDL'
  );


type
    {
    16-9-99: On note TvisuInfo dans ToldVisuInfo pour pouvoir changer les
    configurations

    Dans le nouveau TvisuInfo:
       on supprime Title
       on modifie le type de cpx, cpy, cpz qui deviennent smallint
    }

    TOldVisuInfo=
        record
          Xmin,Xmax,Ymin,Ymax,Zmin,Zmax:double;
          gamma:single;
          aspect:single;
          ux,uy:string[10];
          color:longint;
          twoCol:boolean;
          modeT,tailleT:byte;
          largeurTrait,styleTrait:byte;
          modeLogX,modeLogY,grille:boolean;
          cpX,cpY,cpZ:byte;
          title:string[80];

          echX,echY:boolean;
          FtickX,FtickY:boolean;
          CompletX,completY:boolean;
          TickExtX,TickExtY:boolean;
          ScaleColor:longint;

          fontDesc:TfontDescriptor;
          font:Tfont;
          theta:single;

          inverseX,inverseY:boolean;
          Epduration:single;

        end;

    TWFoptions=record
                 active:boolean;
                 DxAff,DyAff:single;
                 Mleft,Mtop,Mright,Mbottom:single;
               end;
    PWFoptions=^TWFoptions;


    TgetSelectPixel=function(i,j:integer):boolean of object;

type
  TvisuFlagIndex=(
  VF_Xmin,
  VF_Xmax,
  VF_Ymin,
  VF_Ymax,
  VF_Zmin,
  VF_Zmax,
  VF_gamma,
  VF__aspect,
  VF_ux,
  VF_uy,
  VF_color,
  VF_twoCol,
  VF_modeT,
  VF_tailleT,
  VF_largeurTrait,
  VF_styleTrait,
  VF_modeLogX,
  VF_modeLogY,
  VF_grille,
  VF_cpX,
  VF_cpY,
  VF_cpZ,

  VF_echX,
  VF_echY,
  VF_FtickX,
  VF_FtickY,
  VF_CompletX,
  VF_completY,
  VF_TickExtX,
  VF_TickExtY,
  VF_ScaleColor,

  VF_fontVisu,
  VF_theta,

  VF_inverseX,
  VF_inverseY,
  VF_Epduration,

  VF_ModeMat,
  VF_keepRatio,
  VF_color2,

  VF_CpxMode,
  VF_AngularMode,
  VF_AngularLW,
  VF_Cmin,
  VF_Cmax,
  VF_gammaC,
  VF_FscaleX0,
  VF_FscaleY0,
  VF_modeLogZ,

  VF_Gdisp,
  VF_Xdisp,
  VF_Ydisp,
  VF_FullD2,

  VF_toptop
  );

  TvisuFlags=array[TvisuFlagIndex] of boolean;
  PvisuFlags=^TvisuFlags;

const
  NbVisuFlags= ord(VF_toptop);

type
    PvisuInfo=^TvisuInfo;
    TvisuInfo=
        object
          Xmin,Xmax,Ymin,Ymax,Zmin,Zmax:double;
          gamma:single;
          //_aspect:single;
          BarWidth: single;
          ux,uy:string[10];
          color:longint;
          twoCol:boolean;
          modeT,tailleT:byte;
          largeurTrait,styleTrait:byte;
          modeLogX,modeLogY,grille:boolean;
          cpX,cpY,cpZ:smallint;

          echX,echY:boolean;
          FtickX,FtickY:boolean;
          CompletX,completY:boolean;
          TickExtX,TickExtY:boolean;
          ScaleColor:longint;

          fontDescA:TfontDescriptor;
          SmoothFactor:integer;
          DumTheta:single;

          inverseX,inverseY:boolean;
          Epduration:single;

          ModeMat:byte;
          keepRatio:boolean;
          color2:longint;

          getSelectPixel,getMarkedPixel:TgetSelectPixel;
          selectCol,MarkCol:integer;

          CpxMode:byte;                        { 0: X
                                                 1: Y
                                                 2: Mdl
                                                 3: Arg
                                                 4: X / Y
                                                 5: Y / X
                                                 6: Mdl / Arg
                                                 7: Arg / Mdl
                                               }
          AngularMode:byte;                    { 0: none
                                                 1: angle=value
                                                 2: angle=cpx arg }
          AngularLW:integer;                   { largeur trait en mode angulaire }

          Cmin,Cmax:double;
          gammaC:single;
          FscaleX0,FscaleY0:boolean;
          modeLogZ:boolean;

          Gdisp,Xdisp,Ydisp:double;
          FullD2:boolean;

          FvisuFlags: PvisuFlags;             {Ces deux pointeurs sont mis à zéro après un chargement}
          fontVisu:Tfont;

          procedure init;
          procedure done;
          procedure InitVisuFlags;

          procedure assign(const visu:TvisuInfo);

          procedure displayScale;

          {getInsideT calcule la position du rectangle de tracé en fonction
          de la fenêtre courante pour les vecteurs, graphes et fonctions }
          function getInsideT:Trect;

          function getInsideT2(data:TdataTbB):Trect;
          {getInsideMat calcule la position du rectangle de tracé en fonction
          de la fenêtre courante pour les matrices }
          function getInsideMat(data:TdataTbB;wf:PwfOptions;degP:typedegre):Trect;



          {displayTrace0 affiche la trace seule dans la fenêtre courante}
          procedure displayTrace0(data:typedataB;
                                  ExternalWorld,
                                  ExtParam,logX,logY:boolean;
                                  mode,taille:integer;onDP:TonDisplayPoint;
                                  deltaY:float);
          {displayTrace affiche la trace et les échelles dans la fenêtre courante
           En sortie, la fenêtre n'est pas modifiée}
          procedure displayTrace(data:typedataB;onDP:TonDisplayPoint;deltaY:float);
          function displayEmpty:Trect;

          procedure displayPoints(data:typedataB;onDP:TonDisplayPoint;i1,i2:integer;
                                  inside:boolean;deltaY:float);

          procedure affPaveA(poly:Tpoly4;i,j:integer);
          procedure affPaveWire(poly:Tpoly4;i,j:integer);
          procedure moveWire(poly:Tpoly4;i,j:integer);

          procedure affPaveA3(poly:Tpoly4;i,j:integer);
          procedure affPaveA3bis(poly:Tpoly4;i,j:integer);

          procedure affPaveSel(poly:Tpoly4;i,j:integer);

          procedure affPavePhase(poly:Tpoly4;phase:float);

          procedure FastDisplayMat0(ExternalWorld:boolean;palName:AnsiString;
                                    Fcell:boolean;Acol,Arow:integer;
                                    getSel,getMark:TgetSelectPixel;
                                    const TransparentValue:double=0;Ftransparent:boolean=false);

          procedure DisplayMatLog0(ExternalWorld:boolean;palName:AnsiString;
                                    Fcell:boolean;Acol,Arow:integer;const TransparentValue:double=0;Ftransparent:boolean=false);

          procedure displayMat0(data:TdataTbB;ExternalWorld:boolean;palName:AnsiString;
                                Fcell:boolean;Acol,Arow:integer;
                                wf:PwfOptions;degP:typedegre;
                                getSel,getMark:TgetSelectPixel;
                                const TransparentValue:double=0;Ftransparent:boolean=false;
                                ForceNotFast:boolean=false);
          procedure displayMat(data:TdataTbB;palName:AnsiString;
                               Fcell:boolean;Acol,Arow:integer;
                               wf:PwfOptions;degP:typedegre;
                               getSel,getMark:TgetSelectPixel;
                               const TransparentValue:double=0;Ftransparent:boolean=false);

          function getMatPos(data:TdataTbB;wf:PwfOptions;degP:typedegre;var x,y:integer):boolean;overload;
          function getMatPos(data:TdataTbB;wf:PwfOptions;degP:typedegre;var x,y:float):boolean;overload;

          procedure displayGraph0(data1,data2,dataS:typedataB;min,max:integer;
                                  ExternalWorld,extParam,logX,logY:boolean;
                                  mode,taille:integer);
          procedure displayGraph(data1,data2,dataS:typedataB;min,max:integer);

          procedure displayFunc0(f0:TypefonctionEE;xdeb,xfin:float;nbpt:integer;
                                  ExternalWorld,extParam,logX,logY:boolean;
                                  mode,taille:integer);
          procedure displayFunc(f0:TypefonctionEE;xdeb,xfin:float;nbpt:integer);


          procedure cadrerX(data:typeDataB);
          procedure cadrerY(data:typeDataB);
          procedure cadrerYlocal(data:typeDataB);


          procedure initFont;
          procedure freeFont;
          procedure CompleteLoadInfo;

          procedure translateCoo(plus:boolean);

          procedure transferOldVisu(var oldVisu:ToldVisuInfo);

          procedure displayColorMap0(name:AnsiString;dir,Ncol:integer);
          procedure displayColorMap(name:AnsiString;dir,Ncol:integer);

          procedure controle;

          procedure FontToGlb;
          procedure resetFontToGlb;
          function info(ww:AnsiString):AnsiString;

          function compare(visu1:TvisuInfo):boolean;
          procedure getIntegerBounds(data:TdataTbB;var x1,y1,x2,y2:double);
          function MatFastCondition(wf:PwfOptions;degP:typedegre): boolean;
        end;

    TmatColor=record
                col1:byte;
                tpPal:TpaletteType;
                col2:byte;
                bid:byte;
              end;


{Marges minimales pour l'affichage du cadre intérieur}
const
  DispVec_left=5;
  DispVec_Right=8;
  DispVec_Top=5;
  DispVec_Bottom=5;

var
  visuModel:TvisuInfo;

implementation



{****************** Méthodes de TvisuInfo *********************************}

var
  FontCnt:integer;
  oldFont:Tfont;
  FmagFont:boolean;

  FlagPoints:boolean;
  I1points,I2points:integer;



procedure TvisuInfo.init;
begin
  Xmax:=100;
  Ymax:=100;
  Zmax:=1;
  gamma:=1;
  color:=DefPenColor;
  modeT:=2;
  tailleT:=3;
  largeurTrait:=1;
  styleTrait:=1;

  //_aspect:=0;
  BarWidth:=0;

  echX:=true;
  echY:=true;
  FtickX:=true;
  FtickY:=true;
  CompletX:=true;
  completY:=true;
  TickExtX:=false;
  TickExtY:=false;
  ScaleColor:=DefScaleColor;

  inverseX:=false;
  inverseY:=false;
  fontDescA.init;
  fontVisu:=nil;
  initFont;

  CpxMode:=0;
  AngularLW:=1;

  Cmin:=0;
  Cmax:=100;
  gammaC:=1;

  Gdisp:=1;
  FvisuFlags:=nil;

  SmoothFactor:=0;
end;

procedure TvisuInfo.done;
begin
  fontVisu.free;
  fontVisu:=nil;
  if assigned(FvisuFlags) then
  begin
    dispose(FvisuFlags);
    FvisuFlags:=nil;
  end;
end;

procedure TvisuInfo.InitVisuFlags;
begin
  new(FvisuFlags);
  fillchar(FvisuFlags^,sizeof(FvisuFlags^),0);
end;

procedure TvisuInfo.assign(const visu:TvisuInfo);
var
  p:pointer;
begin
  p:=fontVisu;
  move(visu,Xmin,sizeof(visu));
  fontVisu:=p;                          {conserver le pointeur  font}

  if assigned(visu.fontVisu) then
  begin
    if not assigned(fontVisu) then fontVisu:=Tfont.Create;
    fontVisu.Assign(visu.fontVisu);       {copier le contenu de font}
  end;
end;

procedure TvisuInfo.initFont;
begin
  if not assigned(fontVisu) then fontVisu:=Tfont.create;

  DescToFont(fontDescA,fontVisu);
end;

procedure TvisuInfo.freeFont;
begin
  fontVisu.free;
  fontVisu:=nil;
end;

procedure TvisuInfo.CompleteLoadInfo;
begin
  fontvisu:=nil;
  FvisuFlags:=nil;
  SmoothFactor:=0;
end;

procedure TvisuInfo.DisplayScale;
  var
    grad:typeGrad;
  begin
    FontToGlb;

    Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);
    grad:=typeGrad.create;

    TRY
    with grad do
    begin
      setUnites(uX,uY);
      setLog(modeLogX,modeLogY);

      setEch(echX,echY);
      setCadre(FtickX,FtickY,1);
      setComplet(completX,completY);
      setExternal(tickExtX,tickExtY);
      setInverse(inverseX,inverseY);
      setGrille(grille);
      setZeroAxis(FscaleX0,FscaleY0);

      if PRprinting and PRmonochrome
        then setColors(clBlack,clWhite)
        else setColors(scaleColor,canvasGlb.brush.color);

      affiche;
    end;

    FINALLY
    grad.free;

    resetFontToGlb;
    END;
  end;

function duplicate(data:typedataB):typeDataB;
begin
  if data.ClassType=typeDataCpxS then
    with typeDataCpxS(data) do
    result:=typeDataCpxS.create(p,StepSize div 8 {nbvoie},indice1,indiceMin,indiceMax)
  else
  if data.ClassType=typeDataCpxD then
    with typeDataCpxD(data) do
    result:=typeDataCpxD.create(p,StepSize div 16 {nbvoie},indice1,indiceMin,indiceMax)
  else
  if data.ClassType=typeDataCpxE then
    with typeDataCpxE(data) do
    result:=typeDataCpxE.create(p,StepSize div 20 {nbvoie},indice1,indiceMin,indiceMax)
  else result:=nil;

  if assigned(result) then
  begin
    result.ax:=data.ax;
    result.bx:=data.bx;
    result.ay:=data.ay;
    result.by:=data.by;
  end;
end;

procedure TvisuInfo.displayTrace0(data:typeDataB;
                                  ExternalWorld,ExtParam,logX,logY:boolean;
                                  mode,taille:integer;onDP:TonDisplayPoint;
                                  deltaY:float);
var
  univers:TUnivers;
  trace:TTrace0;
  x1,y1,x2,y2:float;
  mt,tt:integer;
  dataY:typeDataB;
begin
  if data=nil then exit;

  dataY:=duplicate(data);
  if not assigned(dataY) and (cpxMode>=4) then exit;

  univers:=Tunivers.create;
  if externalWorld then
   begin
     Dgraphic.getWorld(x1,y1,x2,y2);
     univers.setWorld(x1,y1,x2,y2);
     univers.setModeLog(LogX,LogY)
   end
  else
   begin
     univers.setWorld(xmin,ymin+deltaY,xmax,ymax+deltaY);
     univers.setModeLog(modeLogX,modeLogY);
   end;

  univers.setInverse(inverseX,inverseY);

  if cpxMode<4
   then trace:=TtraceTableau.create(univers,data)
   else trace:=TTraceTableauDouble.create(univers,data,dataY,nil);

  with TtraceTableau(trace) do
  begin
   if PRprinting and PRmonochrome then
     begin
       setColorTrace(clBlack);
       setColorTrace2(clBlack);
     end
   else
     begin
       if ExtParam then
         begin
           setColorTrace(canvasGlb.pen.color);
           setColorTrace2(canvasGlb.pen.color);
         end
       else
         begin
           setColorTrace(self.color);
           setColorTrace2(self.color2);
         end;
     end;

   if extParam then
     begin
       if mode<>0 then mt:=mode else mt:=modeT;
       if taille<>0 then tt:=taille else tt:=tailleT;
       setStyle(mT,tT);
     end
   else setStyle(modeT,tailleT);
   setTrait(largeurTrait,styleTrait);
   setBarWidth(self.BarWidth);

   onDisplayPoint:=onDP;

   if CpxMode<4 then data.modeCpx:=CpxMode
   else
   begin
     data.modeCpx:=0;
     dataY.modeCpx:=1;
   end;

   SmoothF:=(SmoothFactor-1) div 2;

   if FlagPoints
     then afficherPoints(I1points,I2points)
     else afficher;
  end;

  trace.free;
  univers.free;
  data.modeCpx:=0;
  dataY.free;
end;

function TvisuInfo.getInsideT:Trect;
var
  x1,y1,x2,y2:integer;
  xw1,yw1,xw2,yw2:integer;

  htext,ltext:integer;
  ratio:float;
  dx,dy:integer;
begin
  FontToGlb;

  TRY
  getWindowG(x1,y1,x2,y2);

  htext:=canvasGlb.textHeight('1');
  ltext:=canvasGlb.textWidth('1000000');

  xw1:=x1+DispVec_left+ord(echY {and not FscaleY0})*ltext;
  yw1:=y1+DispVec_Top;
  xw2:=x2-DispVec_Right;
  yw2:=y2-ord(echX {and not FscaleX0})*htext-DispVec_Bottom;

  if keepRatio and (Xmax-Xmin<>0) then
    begin
      ratio:=abs((Ymax-Ymin)/(Xmax-Xmin));
      dx:=xw2-xw1;
      dy:=yw2-yw1;
      if dx*ratio<dy
         then dy:=roundL(dx*ratio)
         else dx:=roundL(dy/ratio);

      if dx<4 then dx:=4;
      if dy<4 then dy:=4;

      xw1:=(xw1+xw2) div 2 -dx div 2;
      xw2:=xw1+dx ;

      yw1:=(yw1+yw2) div 2 -dy div 2;
      yw2:=yw1+dy;
    end;

  result:= rect(xw1,yw1,xw2,yw2);

  FINALLY
  resetFontToGlb;
  END;
end;

procedure TVisuInfo.displayTrace(data:typeDataB;onDP:TonDisplayPoint;deltaY:float);
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  rectI:Trect;
begin
  FontToGLB;

  TRY

  BKcolor:=canvasGlb.brush.color;

  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideT;

  with rectI do setWindow(left,top,right,bottom);

  displayTrace0(data,false,false,false,false,0,0,onDP,deltaY);
  DisplayScale;

  setWindow(x1,y1,x2,y2);

  FINALLY
  canvasGlb.brush.color:=BKcolor;
  resetFontToGLB;
  END;
end;

function TVisuInfo.displayEmpty:Trect;
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  rectI:Trect;
begin
  FontToGLB;

  TRY

  BKcolor:=canvasGlb.brush.color;
  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideT;
  result:=rectI;

  with rectI do setWindow(left,top,right,bottom);

  DisplayScale;

  setWindow(x1,y1,x2,y2);

  FINALLY
  canvasGlb.brush.color:=BKcolor;
  resetFontToGLB;
  END;

end;


procedure TVisuInfo.displayPoints(data:typeDataB;onDP:TonDisplayPoint;i1,i2:integer;
                                  inside:boolean;deltaY:float);
begin
  if not assigned(data) then exit;

  FlagPoints:=true;
  I1points:=I1;
  I2points:=I2;

  try
    if not inside
      then displayTrace(data,onDP,deltaY)
      else displayTrace0(data,false,false,false,false,0,0,onDP,deltaY);

  finally
    FlagPoints:=false;
  end;
end;

procedure TvisuInfo.displayGraph0(data1,data2,dataS:typeDataB;min,max:integer;
                        ExternalWorld,extParam,logX,logY:boolean;
                        mode,taille:integer);
var
  univers:TUnivers;
  trace:TTraceTableauDouble;
  x1,y1,x2,y2:float;
  mt,tt:integer;
begin
  if (data1=nil) or (data2=nil) then exit;

  univers:=Tunivers.create;
  if externalWorld then
    begin
      Dgraphic.getWorld(x1,y1,x2,y2);
      univers.setWorld(x1,y1,x2,y2);
      univers.setModeLog(LogX,LogY)
    end
  else
    begin
      univers.setWorld(xmin,ymin,xmax,ymax);
      univers.setModeLog(modeLogX,modeLogY);
    end;

  univers.setInverse(inverseX,inverseY);

  trace:=TTraceTableauDouble.create(univers,data1,data2,dataS);
  trace.setIminImax(min,max);

  with trace do
  begin
     if PRprinting and PRmonochrome then
       begin
         setColorTrace(clBlack);
         setColorTrace2(clBlack);
       end
     else
       begin
         if ExtParam then
           begin
             setColorTrace(canvasGlb.pen.color);
             setColorTrace2(canvasGlb.pen.color);
           end
         else
           begin
             setColorTrace(self.color);
             setColorTrace2(self.color2);
           end;
       end;

    if extParam then
      begin
        if mode<>0 then mt:=mode else mt:=modeT;
        if taille<>0 then tt:=taille else tt:=tailleT;
        setStyle(mT,tT);
      end
    else setStyle(modeT,tailleT);
    setTrait(largeurTrait,styleTrait);
    setBarWidth(self.BarWidth);
    afficher;
  end;

  trace.free;
  univers.free;
end;

procedure TvisuInfo.displayGraph(data1,data2,dataS:typeDataB;min,max:integer);
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  rectI:Trect;
const
  dd=5;
begin
  FontToGlb;

  TRY

  BKcolor:=canvasGlb.brush.color;

  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideT;

  with rectI do setWindow(left,top,right,bottom);

  displayGraph0(data1,data2,dataS,min,max,false,false,false,false,0,0);
  DisplayScale;

  setWindow(x1,y1,x2,y2);

  FINALLY
  canvasGlb.brush.color:=BKcolor;
  resetFontToGlb;
  END;

end;


procedure TvisuInfo.displayFunc0(f0:TypefonctionEE;xdeb,xfin:float;nbpt:integer;
                                  ExternalWorld,extParam,logX,logY:boolean;
                                  mode,taille:integer);
var
  univers:TUnivers;
  trace:TTracefonction;
  x1,y1,x2,y2:float;
  mt,tt:integer;
begin
  if (@f0=nil) then exit;

  univers:=Tunivers.create;
  if externalWorld then
    begin
      Dgraphic.getWorld(x1,y1,x2,y2);
      univers.setWorld(x1,y1,x2,y2);
      univers.setModeLog(LogX,LogY);
    end
  else
    begin
      univers.setWorld(xmin,ymin,xmax,ymax);
      univers.setModeLog(modeLogX,modeLogY);
    end;
  univers.setInverse(inverseX,inverseY);

  trace:=TTracefonction.create(univers);
  trace.setFonction(trace.identA,f0,xdeb,xfin,nbpt);

  with trace do
  begin
    if PRprinting and PRmonochrome then
       begin
         setColorTrace(clBlack);
         setColorTrace2(clBlack);
       end
     else
       begin
         if ExtParam then
           begin
             setColorTrace(canvasGlb.pen.color);
             setColorTrace2(canvasGlb.pen.color);
           end
         else
           begin
             setColorTrace(self.color);
             setColorTrace2(self.color2);
           end;
       end;

    if extParam then
      begin
        if mode<>0 then mt:=mode else mt:=modeT;
        if taille<>0 then tt:=taille else tt:=tailleT;
        setStyle(mT,tT);
      end
    else setStyle(modeT,tailleT);
    setTrait(largeurTrait,styleTrait);
    setBarWidth(self.BarWidth);
    afficher;
  end;

  trace.free;
  univers.free;
end;


procedure TvisuInfo.displayFunc(f0:TypefonctionEE;xdeb,xfin:float;nbpt:integer);
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  rectI:Trect;
const
  dd=5;
begin
  fontToGlb;

  TRY

  BKcolor:=canvasGlb.brush.color;

  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideT;

  with rectI do setWindow(left,top,right,bottom);

  displayFunc0(f0,xdeb,xfin,nbpt,false,false,false,false,0,0);
  DisplayScale;

  setWindow(x1,y1,x2,y2);

  FINALLY
  canvasGlb.brush.color:=BKcolor;
  resetFontToGlb;
  END;

end;


var
  data0:TdataTbB;
  dpal:TDpalette;
  transparentColor0:integer;


procedure TvisuInfo.moveWire(poly:Tpoly4;i,j:integer);
var
  x,y,z:integer;
  z0:float;
begin
  with data0 do
  if (i>=Imin) and (i<=Imax) and (j>=Jmin) and (j<=Jmax)
    then z0:=getE(i,j)
    else z0:=0;

  x:=(poly[1].x+poly[3].x) div 2;
  y:=(poly[1].y+poly[3].y) div 2;
  z:=round(z0);

  with canvasGlb do
  begin
    pen.color:=clBlack;

    moveto(x,y-z);
  end;
end;


procedure TvisuInfo.affPaveWire(poly:Tpoly4;i,j:integer);
var
  x,y,z:integer;
  z0:float;
begin
  with data0 do
  if (i>=Imin) and (i<=Imax) and (j>=Jmin) and (j<=Jmax)
    then z0:=getE(i,j)
    else z0:=0;

  x:=(poly[1].x+poly[3].x) div 2;
  y:=(poly[1].y+poly[3].y) div 2;
  z:=round(z0);

  with canvasGlb do
  begin
    pen.color:=clBlack;

    lineto(x,y-z);

  end;
end;

procedure TvisuInfo.affPavePhase(poly:Tpoly4;phase:float);
var
  xc,yc,cosA,sinA,cos1,sin1,d1,d2:float;
begin
  phase:=-phase;

  xc:=(poly[1].x+poly[3].x)/2;
  yc:=(poly[1].y+poly[3].y)/2;

  d1:=sqrt(sqr(poly[1].X-poly[2].X)+sqr(poly[1].y-poly[2].y));
  d2:=sqrt(sqr(poly[3].X-poly[2].X)+sqr(poly[3].y-poly[2].y));

  if (d1<1) or (d2<1) then exit;

  cosA:=(poly[2].X-poly[3].X)/d1;
  sinA:=(poly[2].Y-poly[3].Y)/d1;

  cos1:=cosA*cos(phase)-sinA*sin(phase);
  sin1:=sinA*cos(phase)+sin(phase)*cosA;

  if d2<d1 then d1:=d2;
  d1:=(d1-angularLW)/2;
  if d1<1 then d1:=1;

  with canvasGlb do
  begin
    moveto(round(xc+d1*cos1),round(yc+d1*sin1));
    lineto(round(xc-d1*cos1),round(yc-d1*sin1));
  end;
end;


procedure TvisuInfo.affPaveA(poly:Tpoly4;i,j:integer);
var
  z:float;
  col:integer;
  w:TfloatComp;
  x,y:float;
begin
  if CpxMode>=4 then
  begin
    with data0 do
    case modeMat of
      0: w:=getCpxValA(i,j);
      1: w:=getCpxSmoothValA3(i,j);
      2: w:=getCpxSmoothValA3bis(i,j);
    end;

    case CpxMode of
      4: begin
           x:=w.x;
           y:=w.y;
         end;
      5: begin
           x:=w.y;
           y:=w.x;
         end;
      6: begin
           x:=mdlCpx(w);
           y:=angleCpx(w);
         end;
      7: begin
           y:=mdlCpx(w);
           x:=angleCpx(w);
         end;
    end;
    col:=Dpal.color2D(x,y);
  end
  else
  with data0 do
  begin
    case modeMat of
      0: z:=getValA(i,j);
      1: z:=getSmoothValA3(i,j);
      2: z:=getSmoothValA3bis(i,j);
    end;
    
    col:=dpal.colorPal(z);
    if transparentColor0=col then exit;
  end;

  with canvasGlb do
  begin
    brush.color:=col;

    if col=$0100000F then col:=$0100000E;    {Un bug sur la couleur 15 !}
    pen.color:=col;

    case AngularMode of
      0: polyGon(poly);

      1: begin
           canvasGlb.Pen.Width:=angularLW;
           affPavePhase(poly,z);
         end;

      2: begin
           case modeMat of
             0: w:=data0.getCpxValA(i,j);
             1: w:=data0.getCpxSmoothValA3(i,j);
             2: w:=data0.getCpxSmoothValA3bis(i,j);
           end;

           canvasGlb.Pen.Width:=angularLW;
           affPavePhase(poly,angleCpx(w));
           canvasGlb.Pen.Width:=1;
         end;

    end;
  end;
end;


procedure TvisuInfo.affPaveA3(poly:Tpoly4;i,j:integer);
var
  col:integer;
begin
  col:=dpal.colorPal(data0.getSmoothValA3(i,j));

  with canvasGlb do
  begin
    brush.color:=col;

    if col=$0100000F then col:=$0100000E;    {Un bug sur la couleur 15 !}
    pen.color:=col;

    polyGon(poly);
  end;
end;

procedure TvisuInfo.affPaveA3bis(poly:Tpoly4;i,j:integer);
var
  col:integer;
begin
  col:=dpal.colorPal(data0.getSmoothValA3bis(i,j));

  with canvasGlb do
  begin
    brush.color:=col;

    if col=$0100000F then col:=$0100000E;    {Un bug sur la couleur 15 !}
    pen.color:=col;

    polyGon(poly);
  end;
end;

procedure TvisuInfo.affPaveSel(poly:Tpoly4;i,j:integer);
var
  invX,invY:boolean;
begin
  //invX:=inverseX and
  with canvasGlb do
  begin
    if getSelectPixel(i,j) then
      begin
         brush.style:=bsClear;
         pen.Color:=SelectCol;

         {polygon(poly);}

         if (data0.ay>0) and not getSelectPixel(i,j-1) or (data0.ay<0) and not getSelectPixel(i,j+1) then
         begin
           moveto(poly[1].x,poly[1].y);
           lineto(poly[2].x,poly[2].y);
         end;

         if (data0.ax>0) and not getSelectPixel(i+1,j) or (data0.ax<0) and not getSelectPixel(i-1,j) then
         begin
           moveto(poly[2].x,poly[2].y);
           lineto(poly[3].x,poly[3].y);
         end;

         if (data0.ay>0) and not getSelectPixel(i,j+1) or (data0.ay<0) and not getSelectPixel(i,j-1) then
         begin
           moveto(poly[3].x,poly[3].y);
           lineto(poly[4].x,poly[4].y);
         end;

         if (data0.ax>0) and not getSelectPixel(i-1,j) or (data0.ax<0) and not getSelectPixel(i+1,j) then
         begin
           moveto(poly[4].x,poly[4].y);
           lineto(poly[1].x,poly[1].y);
         end;

      end;

    if getMarkedPixel(i,j) then
      begin
         pen.Color:=MarkCol;
         moveto(poly[1].x,poly[1].y);
         lineto(poly[3].x,poly[3].y);
         moveto(poly[2].x,poly[2].y);
         lineto(poly[4].x,poly[4].y);
      end;

  end;
end;




function TvisuInfo.getInsideT2(data:TdataTbB):Trect;
var
  x1,y1,x2,y2:integer;
  xw1,yw1,xw2,yw2:integer;

  htext,ltext:integer;
  ratio:float;
  dx,dy:integer;
begin
  FontToGlb;

  TRY
  getWindowG(x1,y1,x2,y2);

  htext:=canvasGlb.textHeight('1');
  ltext:=canvasGlb.textWidth('1000000');

  // on réduit d'abord la fenêtre pour tenir compte des échelles
  xw1:=x1+DispVec_left+ord(echY)*ltext;
  yw1:=y1+DispVec_Top;
  xw2:=x2-DispVec_Right;
  yw2:=y2-ord(echX)*htext-DispVec_Bottom;
  result:= rect(xw1,yw1,xw2,yw2);

  // On tient compte ensuite de l'aspectratio
  if keepRatio and assigned(data) and (data.invConvX(Xmax)-data.invConvX(Xmin)<>0) then
    begin
      with data do
      //ratio:=abs(PixRatio*(invConvY(Ymax)-invConvY(Ymin))/(invConvX(Xmax)-invConvX(Xmin)));
      ratio:=abs(PixRatio*(Ymax-Ymin)/(Xmax-Xmin));
      dx:=xw2-xw1;
      dy:=yw2-yw1;
      if dx*ratio<dy
         then dy:=roundL(dx*ratio)
         else dx:=roundL(dy/ratio);

      if dx<4 then dx:=4;
      if dy<4 then dy:=4;

      xw1:=(xw1+xw2) div 2 -dx div 2;
      xw2:=xw1+dx ;

      yw1:=(yw1+yw2) div 2 -dy div 2;
      yw2:=yw1+dy;
    end;

  result:= rect(xw1,yw1,xw2,yw2);

  {statuslineTxt(Estr(xw1,1)+' '+Estr(yw1,1)+' '+Estr(xw2,1)+' '+Estr(yw2,1) );}

  FINALLY
  resetFontToGlb;
  END;
end;


procedure TvisuInfo.getIntegerBounds(data:TdataTbB;var x1,y1,x2,y2:double);
begin
  with data do
  if Xmin<Xmax then
  begin
    X1:=convx(floor(invconvxR(Xmin)));
    X2:=convx(ceil(invconvxR(Xmax)));
  end
  else
  begin
    X1:=convx(ceil(invconvxR(Xmin)));
    X2:=convx(floor(invconvxR(Xmax)));
  end;

  with data do
  if Ymin<Ymax then
  begin
    Y1:=convy(floor(invconvyR(Ymin)));
    Y2:=convy(ceil(invconvyR(Ymax)));
  end
  else
  begin
    Y1:=convy(ceil(invconvyR(Ymin)));
    Y2:=convy(floor(invconvyR(Ymax)));
  end;

end;



function TvisuInfo.getInsideMat(data:TdataTbB;wf:PwfOptions;degP:typedegre):Trect;
var
  affMat:typeAffmat;
  x1,y1,x2,y2:integer;
  aspect:float;
begin
  getWindowG(x1,y1,x2,y2);
  result:=rect(x1,y1,x2,y2);

  if (data=nil) or (data.Imax<data.Imin) or (data.Jmax<data.Jmin) then exit;
  data0:=data;

  aspect:=data.AspectRatio;

  if (Xmin=Xmax) or (Ymin=Ymax) or degP.Fuse or assigned(wf) and wf^.active then exit;

  result:= getInsideT2(data);


  with result do setWindow(left,top,right,bottom);

  with affMat do
  begin
  (*
    case modeMat of
      0: begin
           init(data.Imin,data.Jmin,data.Imax,data.Jmax,aspect,0);
           affPaveU:=affPaveA;
           setXlimits(data.invConvX(Xmin),data.invConvX(Xmax)-1);
           setYlimits(data.invConvY(Ymin),data.invConvY(Ymax)-1);
         end;
      1: begin
           init(data.Imin,data.Jmin,
                 data.Imin+(data.Imax-data.Imin+1)*3,data.Jmin+(data.Jmax-data.Jmin+1)*3,
                 aspect,0);
           affPaveU:=affPaveA;
           setXlimits(data.invConvX(Xmin)*3-2,data.invConvX(Xmax)*3-3);
           setYlimits(data.invConvY(Ymin)*3-2,data.invConvY(Ymax)*3-3);
         end;
      2: begin
           init(data.Imin,data.Jmin,
                 data.Imin+(data.Imax-data.Imin+1)*3,data.Jmin+(data.Jmax-data.Jmin+1)*3,
                 aspect,0);
           affPaveU:=affPaveA;
           setXlimits(data.invConvX(Xmin)*3-2,data.invConvX(Xmax)*3-3);
           setYlimits(data.invConvY(Ymin)*3-2,data.invConvY(Ymax)*3-3);
         end;
    end;
    {Fwires:=(modeMat=3);}

    setInv(inverseX,inverseY);
    setKeepRatio(keepRatio);

    calculRbase;

    result:=getIrect;
    *)
    setWindow(x1,y1,x2,y2);

  end;
end;



procedure TvisuInfo.FastDisplayMat0(ExternalWorld:boolean;palName:AnsiString;
                                    Fcell:boolean;Acol,Arow:integer;
                                    getSel,getMark:TgetSelectPixel;
                                    const TransparentValue:double=0;Ftransparent:boolean=false);
var
  x1e,y1e,x2e,y2e:float;
  x1,y1,x2,y2:integer;
  x1g,y1g,x2g,y2g: integer;
  rectS, rectS1, rectW:Trect;
  dib:Tbitmap;
  i,j,i1,j1:integer;
  p:PtabOctet;
  w:integer;
  w1,w2:float;
  dpal:TDpalette;

  logPal:TMaxLogPalette;
  TransparentIndex:integer;
  invX,invY: boolean;
  rectU:Trect;
  deltaX,deltaY:float;
  poly4: Tpoly4;

  sgnX,sgnY: integer;


function getV(i,j:integer):float;
begin
  with data0 do
  case modeMat of
    0: if (i>=Imin)and (i<=Imax) and (j>=Jmin) and (j<=Jmax)
         then result:=getE(i,j)
         else result:=0;
    1: result:=getSmoothValA3(i,j);
    2: result:=getSmoothValA3bis(i,j);
  end;
end;

procedure getVCpx(i,j:integer;var x,y:float);
var
  z:TFloatComp;
begin
  with data0 do
  case modeMat of
    0: z:=getCpxValA(i,j);
    1: z:=getCpxSmoothValA3(i,j);
    2: z:=getCpxSmoothValA3bis(i,j);
  end;

  case CpxMode of
    4: begin
         x:=z.x;
         y:=z.y;
       end;
    5: begin
         x:=z.y;
         y:=z.x;
       end;
    6: begin
         x:=mdlCpx(z);
         y:=angleCpx(z);
       end;
    7: begin
         y:=mdlCpx(z);
         x:=angleCpx(z);
       end;
  end;
end;

procedure CheckLeftRight;
begin
  with rectS do
  begin
    if rectS.left>rectS.Right then swap(left,right);
    dec(left);
    inc(right);

    if top>bottom then swap(top,bottom);
    dec(Top);
    inc(Bottom);
  end;
end;

function cvx(x:float):integer;
begin
  if not inverseX
    then result:=convWx(x)
    else result:=convWxInvert(x);
end;

function cvy(y:float):integer;
begin
  if not inverseY
    then result:=convWy(y)
    else result:=convWyInvert(y);
end;


begin
  if Zmin=Zmax then Zmax:=Zmin+1;

  if externalWorld then
    Dgraphic.getWorld(x1e,y1e,x2e,y2e)
  else
    begin
      x1e:=Xmin;
      y1e:=Ymin;
      x2e:=Xmax;
      y2e:=Ymax;
      setWorld(x1e,y1e,x2e,y2e);
    end;

  invX:= (x1e>x2e) xor (data0.ax<0) xor inverseX;
  invY:= (y1e>y2e) xor (data0.ay<0) xor inverseY;


  dpal:=TDpalette.create;
  dpal.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,canvasGlb.handle);
  dpal.setType(palName);
  dpal.SetPalette(Zmin,Zmax,gamma,modeLogZ);


  Dib:=Tbitmap.Create;
  Dib.PixelFormat:= pf8bit;

  TRY
  with Dib do
  begin
    if cpxMode>=4 then
    begin
      dpal.set2DPalette(FullD2);
      dpal.setChrominance(Cmin,Cmax,gammaC);
    end;

    LogPal:=dpal.rgbPalette;
    Dib.Transparent:= FTransparent;
    TransparentIndex:=Dpal.ColorIndex(TransparentValue);
    Dib.TransparentMode:= tmFixed;
    with LogPal.palPalEntry[TransparentIndex] do Dib.transparentColor:=rgb(peRed,peGreen,peBlue);

    Palette:= CreatePalette(PlogPalette(@LogPal)^);

    // rectS définit la zone matrice affichée pour modemat=0
    rectS:=rect(data0.invConvX(X1e),data0.invConvY(Y1e),data0.invConvX(X2e),data0.invConvY(Y2e));
    checkLeftRight;
    rectS1:=rectS;

    // rectW définit la fenêtre en pixels qui doit recevoir exactement rectS
    // ce calcul est aussi valable pour modeMat<>0
    if data0.ax>0 then
    begin
      rectW.Left:=  cvx(data0.convx(rectS.left));
      rectW.Right:= cvx(data0.convx(rectS.right+1));
    end
    else
    begin
      rectW.Left:=  cvx(data0.convx(rectS.right));
      rectW.Right:= cvx(data0.convx(rectS.left-1));
    end;

    if data0.ay>0 then
    begin
      rectW.top:=    cvy(data0.convy(rectS.top));
      rectW.bottom:= cvy(data0.convy(rectS.bottom+1));
    end
    else
    begin
      rectW.top:=    cvy(data0.convy(rectS.bottom));
      rectW.bottom:= cvy(data0.convy(rectS.top-1));
    end;

    checkRectangle(rectW);

    if modeMat=0 then
    begin
      //Dimensionner le dib
      width:= rectS.Right-rectS.Left+1;
      height:= rectS.bottom-rectS.top+1;

      //fill(0);

      x1:=0;
      y1:=0;
      x2:=width-1;
      y2:=height-1;

      if rectS.Left+x1<data0.Imin then x1:=data0.Imin-rectS.Left;
      if rectS.Left+x2>data0.Imax then x2:=data0.Imax-rectS.Left;

      if rectS.top+y1<data0.Jmin then y1:=data0.Jmin-rectS.top;
      if rectS.top+y2>data0.Jmax then y2:=data0.Jmax-rectS.top;

    end
    else
    begin

      rectS:=rect(rectS.left*3-2*data0.Imin,rectS.top*3-2*data0.Jmin, rectS.right*3-2*data0.Imin+2,rectS.bottom*3-2*data0.Jmin+2);

      width:= rectS.Right-rectS.Left+1;
      height:= rectS.bottom-rectS.top+1;

      x1:=0;
      y1:=0;
      x2:=width-1;
      y2:=height-1;

    end;
    // si la matrice n'occupe pas toute la fenêtre, on veille à remplir le fond
    if (x1>0) or (x1<width-1) or (y1>0) or (y1<height-1) then
      begin
        Canvas.Brush.Color:=transparentColor;
        Canvas.Brush.style:=bsSolid;
        Canvas.Pen.Color:=transparentColor;
        Canvas.Pen.style:=psSolid;
        Canvas.fillrect(rect(0,0,Width,height));
      end;


    if cpxMode<4 then
      begin
        for j:=y1 to y2 do
          begin
            if invY
              then p:=scanline[j]
              else p:=scanline[height-1-j];
            for i:=x1 to x2 do
            begin
               w:=Dpal.colorIndex(getV(rectS.Left+i,rectS.top+j));

              if invX
                then p^[width-1-i]:=w
                else p^[i]:=w;
            end;
          end;
        end
      else
        begin
          for j:=y1 to y2 do
            begin
              if invY
                then p:=scanline[j]
                else p:=scanline[height-1-j];
              for i:=x1 to x2 do
              begin
                getVCpx(rectS.Left+i,rectS.top+j,w1,w2);
                w:=Dpal.colorIndex2D(w1,w2);

                if invX
                  then p^[width-1-i]:=w
                  else p^[i]:=w;
              end;
            end;
        end;

    {
    statuslineTxt(Istr(rectS.left)+' '+Istr(rectS.top)+' '+Istr(rectS.right)+' '+Istr(rectS.bottom)+' '+
                  Istr(rectW.left)+' '+Istr(rectW.top)+' '+Istr(rectW.right)+' '+Istr(rectW.bottom) );
    }
  end;


  canvasGlb.stretchDraw(rectW,Dib );

  if assigned(getSel) or assigned(getMark) then
  begin
    if data0.ax>0 then sgnX:=1 else sgnX:=-1;
    if data0.ay>0 then sgnY:=1 else sgnY:=-1;


    getWorld(x1e,y1e,x2e,y2e);

    i:=ord(inverseX)+2*ord(inverseY);
    case i of
      0: setWorld(X1e,Y1e,X2e,Y2e);
      1: setWorld(X2e,Y1e,X1e,Y2e);
      2: setWorld(X1e,Y2e,X2e,Y1e);
      3: setWorld(X2e,Y2e,X1e,Y1e);
    end;


    for i:=rectS1.Left to rectS1.Right do
    for j:=rectS1.top to rectS1.bottom do
    begin
      if (i>=data0.Imin) and (i<=data0.Imax) and (j>=data0.Jmin) and (j<=data0.Jmax) and  ( getSel(i,j) or getMark(i,j))  then
      begin

        poly4[1]:= point(convWx(data0.convx(i)),convWy(data0.convy(j)));
        poly4[2]:= point(convWx(data0.convx(i+sgnX)),convWy(data0.convy(j)));
        poly4[3]:= point(convWx(data0.convx(i+sgnX)),convWy(data0.convy(j+sgnY)));
        poly4[4]:= point(convWx(data0.convx(i)),convWy(data0.convy(j+sgnY)));

        AffPaveSel(poly4,i,j);

      end;
    end;

    setWorld(X1e,Y1e,X2e,Y2e);
  end;

  FINALLY
  dib.Free;
  dpal.Free;
  data0.modeCpx:=0;
  {ISPend;}
  END;
end;

procedure TvisuInfo.DisplayMatLog0(ExternalWorld:boolean;palName:AnsiString;
                                    Fcell:boolean;Acol,Arow:integer;
                                    const TransparentValue:double=0;Ftransparent:boolean=false);
var
  x1e,y1e,x2e,y2e:float;
  x1,y1,x2,y2:float;
  i1,j1,i2,j2:integer;
  i1r,j1r,i2r,j2r:integer;

  i,j:integer;
  xb:float;
  w:integer;
  w1,w2:float;
  dpal:TDpalette;


function getV(i,j:integer):float;
begin
  with data0 do
  case modeMat of
    0: result:=getE(i,j);
    1: result:=getSmoothValA3(i,j);
    2: result:=getSmoothValA3bis(i,j);
  end;
end;

procedure getVCpx(i,j:integer;var x,y:float);
var
  z:TFloatComp;
begin
  with data0 do
  case modeMat of
    0: z:=getCpxValA(i,j);
    1: z:=getCpxSmoothValA3(i,j);
    2: z:=getCpxSmoothValA3bis(i,j);
  end;

  case CpxMode of
    4: begin
         x:=z.x;
         y:=z.y;
       end;
    5: begin
         x:=z.y;
         y:=z.x;
       end;
    6: begin
         x:=mdlCpx(z);
         y:=angleCpx(z);
       end;
    7: begin
         y:=mdlCpx(z);
         x:=angleCpx(z);
       end;
  end;
end;


begin
  if Zmin=Zmax then Zmax:=Zmin+1;

  if externalWorld then
    Dgraphic.getWorld(x1e,y1e,x2e,y2e)
  else
    begin
      x1e:=Xmin;
      y1e:=Ymin;
      x2e:=Xmax;
      y2e:=Ymax;
    end;

  dpal:=TDpalette.create;
  dpal.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,canvasGlb.handle);
  dpal.setType(palName);
  dpal.SetPalette(Zmin,Zmax,gamma,modeLogZ);

  try

  if cpxMode>=4 then
  begin
    dpal.set2DPalette(FullD2);
    dpal.setChrominance(Cmin,Cmax,gammaC);
  end;

  if modeMat=0 then
  begin
    i1:=data0.invConvX(X1e);
    j1:=data0.invConvY(Y1e);
    i2:=data0.invConvX(X2e)-1;
    j2:=data0.invConvY(Y2e)-1;

    if i1<data0.Imin then i1:=data0.Imin;
    if i2>data0.Imax then i2:=data0.Imax;
    if j1<data0.Jmin then j1:=data0.Jmin;
    if j2>data0.Jmax then j2:=data0.Jmax;
  end
  else
  begin
    i1:=data0.invConvX(X1e)*3-2;
    j1:=data0.invConvY(Y1e)*3-2;
    i2:=data0.invConvX(X2e)*3-3;
    j2:=data0.invConvY(Y2e)*3-3;

    x1e:=3*x1e;
    x2e:=3*x2e;
    y1e:=3*y1e;
    y2e:=3*y2e;
  end;

  if modeLogX then
  begin
    x1:=log10(x1e);
    x2:=log10(x2e);
  end
  else
  begin
    x1:=x1e;
    x2:=x2e;
  end;

  if modeLogY then
  begin
    y1:=log10(y1e);
    y2:=log10(y2e);
  end
  else
  begin
    y1:=y1e;
    y2:=y2e;
  end;

  if inverseX then
  begin
    xb:=x1;
    x1:=x2;
    x2:=xb;
  end;

  if inverseY then
  begin
    xb:=y1;
    y1:=y2;
    y2:=xb;
  end;

  Dgraphic.setWorld(x1,y1,x2,y2);


  for j:=j1 to j2 do
  for i:=i1 to i2 do
  begin
    if cpxMode<4 then  canvasGlb.Pen.color:=Dpal.ColorPal(getV(i,j))
    else
    begin
      getVCpx(i,j,w1,w2);
      canvasGlb.Pen.color:=Dpal.color2D(w1,w2);
    end;
    canvasGlb.brush.color:=canvasGlb.pen.color;

    if modeLogX then
    begin
      i1r:=convWx(log10(data0.convx(i)));
      i2r:=convWx(log10(data0.convx(i+1)));
    end
    else
    begin
      i1r:=convWx(data0.convx(i));
      i2r:=convWx(data0.convx(i+1));
    end;

    if modeLogY then
    begin
      j1r:=convWy(log10(data0.convy(j)));
      j2r:=convWy(log10(data0.convy(j+1)));
    end
    else
    begin
      j1r:=convWy(data0.convy(j));
      j2r:=convWy(data0.convy(j+1));
    end;

    if i1r>i2r then swap(i1r,i2r);
    if j1r>j2r then swap(j1r,j2r);

    inc(i2r);
    inc(j2r);

    canvasGlb.rectangle(i1r,j1r,i2r,j2r);
  end;

  FINALLY
  dpal.Free;
  data0.modeCpx:=0;
  {ISPend;}
  END;
end;

function TvisuInfo.MatFastCondition(wf:PwfOptions;degP:typedegre): boolean;
begin
  result:= (not degP.Fuse) and ((wf=nil) or not wf.active ) and (Angularmode=0)
           and
           not (PRprinting and PRsplitMatrix)
end;

procedure TvisuInfo.displayMat0(data:TdataTbB;externalWorld:boolean;palName:AnsiString;
                                Fcell:boolean;Acol,Arow:integer;
                                wf:PwfOptions;degP:typedegre;
                                getSel,getMark:TgetSelectPixel;
                                const TransparentValue:double=0;Ftransparent:boolean=false;
                                ForceNotFast:boolean=false);
var
  i:integer;
  affMat:typeAffmat;
  x1e,y1e,x2e,y2e:float;

  x1,y1,x2,y2:integer;
  Mtop1,Mbottom1,Mleft1,Mright1:integer;
  aspect:float;
  theta1:float;
  degPix:typedegre;

  poly: typePoly5R;
  xminA,yminA,xmaxA,ymaxA,dxmax,dymax:float;
  di,dj:integer;
  R:float;

begin
  if (data=nil) or (data.aspectRatio=0) or (data.Imax<data.Imin) or (data.Jmax<data.Jmin) then exit;
  if (Xmin=Xmax) or (Ymin=Ymax) then exit;


  data0:=data;
  aspect:= data0.AspectRatio;
  if degP.Fuse  then               // Affichage multigraph avec params position
  begin
    if (degP.dx<=0) or (degP.dy<=0) then exit;

    theta1:= degP.theta;

    degToPolyR(degP,poly);

    xminA:= 1E100;
    xmaxA:=-1E100;
    yminA:= 1E100;
    ymaxA:=-1E100;

    for i:=1 to 4 do
    begin
      if poly[i].x < xminA then xminA:=poly[i].x;
      if poly[i].x > xmaxA then xmaxA:=poly[i].x;
      if poly[i].y < yminA then yminA:=poly[i].y;
      if poly[i].y > ymaxA then ymaxA:=poly[i].y;
    end;
    dxmax:=xmaxA-xminA;
    dymax:=ymaxA-yminA;
    di:=x2act-x1act;
    dj:=y2act-y1act;
    if dymax/dxmax>dj/di
      then R:=dymax/dj
      else R:=dxmax/di;

    degPix.x:= (x1act+x2act)/2 ;
    degPix.y:= (y1act+y2act)/2;
    degPix.dx:= degP.dx/R;
    degPix.dy:= degP.dy/R;
    degPix.theta:= degP.theta;
  end
  else
  if degP.Fcontrol  then               // Affichage controle avec params position
    theta1:= degP.theta
  else theta1:=0;

  getSelectPixel:=getSel;
  getMarkedPixel:=getMark;

  data0.modeCpx:=CpxMode mod 4;

  if externalWorld
    then Dgraphic.getWorld(x1e,y1e,x2e,y2e)
    else
    begin
      x1e:=Xmin;
      y1e:=Ymin;
      x2e:=Xmax;
      y2e:=Ymax;
    end;

  if modeLogX or modeLogY then DisplayMatLog0(ExternalWorld,palName,Fcell,Acol,Arow)

  else
  if MatFastCondition(wf,degP) and not ForceNotFast then
  begin
    FastDisplayMat0(ExternalWorld,palName,Fcell,Acol,Arow,
                         getSel,getMark,
                         TransparentValue, Ftransparent);
    exit;
  end
  else
  with affMat do
  begin
    case modeMat of
      0: begin
           init(data.Imin,data.Jmin,data.Imax,data.Jmax,aspect, theta1);
           affPaveU:=affPaveA;
           setXlimits(data.invConvX(X1e),data.invConvX(X2e)-1);
           setYlimits(data.invConvY(Y1e),data.invConvY(Y2e)-1);
         end;
      1: begin
           init(data.Imin,data.Jmin,
                 data.Imin+(data.Imax-data.Imin+1)*3,data.Jmin+(data.Jmax-data.Jmin+1)*3,
                 aspect, theta1);
           affPaveU:=affPaveA;
           setXlimits(data.invConvX(X1e)*3-2,data.invConvX(X2e)*3-3);
           setYlimits(data.invConvY(Y1e)*3-2,data.invConvY(Y2e)*3-3);
         end;
      2: begin
           init(data.Imin,data.Jmin,
                 data.Imin+(data.Imax-data.Imin+1)*3,data.Jmin+(data.Jmax-data.Jmin+1)*3,
                 aspect, theta1);
           affPaveU:=affPaveA;
           setXlimits(data.invConvX(X1e)*3-2,data.invConvX(X2e)*3-3);
           setYlimits(data.invConvY(Y1e)*3-2,data.invConvY(Y2e)*3-3);
         end;

    end;

    {Fwires:=(modeMat=3);}

    dpal:=TDpalette.create;
    dpal.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,canvasGlb.handle);
    dpal.setType(palName);
    dpal.SetPalette(Zmin,Zmax,gamma,modeLogZ);

    if Ftransparent
      then TransparentColor0:=Dpal.ColorPal(TransparentValue)
      else TransparentColor0:= -1;

    if cpxMode>=4 then
    begin
      dpal.set2DPalette(FullD2);
      dpal.setChrominance(Cmin,Cmax,gammaC);
    end;


    setInv(inverseX,inverseY);
    setKeepRatio(keepRatio);

    if assigned(wf) and wf^.active and not degP.Fuse then
      with wf^ do
      begin
        getWindowG(x1,y1,x2,y2);

        Mtop1:=round((y2-y1)*Mtop/100);
        Mleft1:=round((x2-x1)*Mleft/100);
        Mbottom1:=round((y2-y1)*Mbottom/100);
        Mright1:=round((x2-x1)*Mright/100);

        setClipRegion(x1,y1,x2,y2);
        setWindow(x1+Mleft1,y1+Mtop1,x2-Mright1,y2-Mbottom1);

        setDxAffDyAff(dxAff,dyAff);
      end;


    if Fcell then afficheCell(Acol,Arow)
    else
    if degP.Fuse then
      With DegPix do displayInRect(x,y,dx,dy,theta)
    else
    if degP.Fcontrol then
      With DegP do displayInRect(x,y,dx,dy,theta)
    else affiche;

    dpal.free;
  end;


  if assigned(getSel) or assigned(getMark) then
  with affMat do
  begin
    init(data.Imin,data.Jmin,data.Imax,data.Jmax,aspect,theta1);
    setXlimits(data.invConvX(X1e),data.invConvX(X2e)-1);
    setYlimits(data.invConvY(Y1e),data.invConvY(Y2e)-1);

    setInv(inverseX,inverseY);
    setKeepRatio(keepRatio);

    if assigned(wf) and wf^.active and not degP.Fuse then
      with wf^ do
      begin
        getWindowG(x1,y1,x2,y2);

        Mtop1:=round((y2-y1)*Mtop/100);
        Mleft1:=round((x2-x1)*Mleft/100);
        Mbottom1:=round((y2-y1)*Mbottom/100);
        Mright1:=round((x2-x1)*Mright/100);

        setWindow(x1+Mleft1,y1+Mtop1,x2-Mright1,y2-Mbottom1);

        setDxAffDyAff(dxAff,dyAff);
      end;


    affPaveU:=affPaveSel;
    if not degP.Fuse then affiche
    else
    with degPix do displayInRect(x,y,dx,dy,theta);

    {drawBorder(clWhite);}

    with getIrect do setWindow(left,top,right,bottom);
  end;

  data.modeCpx:=0;
end;

procedure TvisuInfo.displayMat(data:TdataTbB;palName:AnsiString;
                               Fcell:boolean;Acol,Arow:integer;
                               wf:PwfOptions;degP:typedegre;
                               getSel,getMark:TgetSelectPixel;
                               const TransparentValue:double=0;Ftransparent:boolean=false);
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  withWF:boolean;
begin
  fontToGlb;

  TRY

  BKcolor:=canvasGlb.brush.color;
  withWF:=assigned(wf) and wf^.active;

  getWindowG(x1,y1,x2,y2);

  if not withWF  then
    with getInsideMat(data,wf,degP) do setWindow(left,top,right,bottom);

  displayMat0(data,false,palName,Fcell,Acol,Arow,wf,degP,getSel,getMark, TransparentValue, Ftransparent);
  if (not degP.Fuse) {and not Fcell} and not(assigned(wf) and wf^.active) {and (modeMat<>3)}
    then DisplayScale;


  setWindow(x1,y1,x2,y2);

  FINALLY
  canvasGlb.brush.color:=BKcolor;
  resetFontToGlb;
  END;
end;

function TvisuInfo.getMatPos(data:TdataTbB;wf:PwfOptions;degP:typedegre;var x,y:integer):boolean;
var
  x1,y1,x2,y2:integer;
  withWF:boolean;
  Mtop1,Mbottom1,Mleft1,Mright1:integer;
  affMat:typeAffmat;
  aspect:float;
  theta1:float;

  Xr,Yr: float;
  i:integer;

begin
  result:=false;
  if data=nil then exit;

  getWindowG(x1,y1,x2,y2);

  if MatFastCondition(wf,degP) then
  begin
    with getInsideT2(data) do setWindow(left,top,right,bottom,true);
    i:=ord(inverseX)+2*ord(inverseY);
    case i of
      0: setWorld(Xmin,Ymin,Xmax,Ymax);
      1: setWorld(Xmax,Ymin,Xmin,Ymax);
      2: setWorld(Xmin,Ymax,Xmax,Ymin);
      3: setWorld(Xmax,Ymax,Xmin,Ymin);
    end;

    Xr:= invconvWx(x);
    Yr:= invconvWy(y);

    with data do
    begin
      if (ax<0) then x:= ceil((Xr-bx)/ax) else x:= floor((Xr-bx)/ax);
      if (ay<0) then y:= ceil((Yr-by)/ax) else y:= floor((Yr-by)/ay);

      result:= (x>=Imin) and (x<=Imax) and (y>=Jmin) and (y<=Jmax);
    end;

    setWindow(x1,y1,x2,y2);
    exit;
  end;


  if degP.Fuse then theta1:=degP.theta else theta1:=0;
  fontToGlb;

  TRY

  withWF:=assigned(wf) and wf^.active;



  if not withWF and not degP.Fuse then
    with getInsideT2(data) do setWindow(left,top,right,bottom);

  

  aspect:=data.aspectRatio;

  with affMat do
  begin
    init(data.Imin,data.Jmin,data.Imax,data.Jmax,aspect,theta1);
    setXlimits(data.invConvX(Xmin),data.invConvX(Xmax)-1);
    setYlimits(data.invConvY(Ymin),data.invConvY(Ymax)-1);

    setInv(inverseX,inverseY);
    setKeepRatio(keepRatio);

    if withWF then
      with wf^ do
      begin
        getWindowG(x1,y1,x2,y2);

        Mtop1:=round((y2-y1)*Mtop/100);
        Mleft1:=round((x2-x1)*Mleft/100);
        Mbottom1:=round((y2-y1)*Mbottom/100);
        Mright1:=round((x2-x1)*Mright/100);

        setWindow(x1+Mleft1,y1+Mtop1,x2-Mright1,y2-Mbottom1);

        setDxAffDyAff(dxAff,dyAff);
      end;


    result:=getPixelPos(x,y);
  end;




  FINALLY
  setWindow(x1,y1,x2,y2);
  resetFontToGlb;
  END;

end;

function TvisuInfo.getMatPos(data:TdataTbB;wf:PwfOptions;degP:typedegre;var x,y:float):boolean;
var
  x1,y1,x2,y2:integer;
  withWF:boolean;
  Mtop1,Mbottom1,Mleft1,Mright1:integer;
  affMat:typeAffmat;
  aspect:float;
  theta1:float;

  Xr,Yr: float;
  i:integer;
begin
  result:=false;
  if data=nil then exit;


  getWindowG(x1,y1,x2,y2);

  if MatFastCondition(wf,degP) then
  begin
    with getInsideT2(data) do setWindow(left,top,right,bottom,true);
    i:=ord(inverseX)+2*ord(inverseY);
    case i of
      0: setWorld(Xmin,Ymin,Xmax,Ymax);
      1: setWorld(Xmax,Ymin,Xmin,Ymax);
      2: setWorld(Xmin,Ymax,Xmax,Ymin);
      3: setWorld(Xmax,Ymax,Xmin,Ymin);
    end;

    Xr:= invconvWx(round(x));
    Yr:= invconvWy(round(y));

    with data do
    begin
      x:= (Xr-bx)/ax;
      y:= (Yr-by)/ax;

      result:= (x>=Imin) and (x<=Imax) and (y>=Jmin) and (y<=Jmax);
    end;

    setWindow(x1,y1,x2,y2);
    exit;
  end;

  fontToGlb;

  TRY
  if degP.Fuse then theta1:=degP.theta else theta1:=0;
  withWF:=assigned(wf) and wf^.active;

  getWindowG(x1,y1,x2,y2);

  if not withWF and not degP.Fuse then
    with getInsideT2(data) do setWindow(left,top,right,bottom);

  aspect:=data.aspectRatio;


  with affMat do
  begin
    init(data.Imin,data.Jmin,data.Imax,data.Jmax,aspect,theta1);
    setXlimits(data.invConvX(Xmin),data.invConvX(Xmax)-1);
    setYlimits(data.invConvY(Ymin),data.invConvY(Ymax)-1);

    setInv(inverseX,inverseY);
    setKeepRatio(keepRatio);

    if withWF then
      with wf^ do
      begin
        getWindowG(x1,y1,x2,y2);

        Mtop1:=round((y2-y1)*Mtop/100);
        Mleft1:=round((x2-x1)*Mleft/100);
        Mbottom1:=round((y2-y1)*Mbottom/100);
        Mright1:=round((x2-x1)*Mright/100);

        setWindow(x1+Mleft1,y1+Mtop1,x2-Mright1,y2-Mbottom1);

        setDxAffDyAff(dxAff,dyAff);
      end;


    result:=getPixelPos(x,y);
  end;
  

  FINALLY
  setWindow(x1,y1,x2,y2);
  resetFontToGlb;
  END;

end;


procedure TvisuInfo.cadrerX(data:typeDataB);
var
  min,max:float;
begin
  if data=nil then exit;

  if CpxMode>=4 then data.LimitesY(min,max,0,0)
  else
  begin
    if modeT=DM_evt1 then
      begin
        if EpDuration>0 then
          begin
            min:=0;
            max:=EpDuration;
          end
        else data.limitesY(min,max,0,0);
      end
    else data.limitesX(min,max);
  end;

  if min<=max then
    begin
     Xmin:=min;
     Xmax:=max;
   end;
end;

procedure TvisuInfo.cadrerY(data:typeDataB);
var
  min,max:float;
begin
  if data=nil then exit;

  if CpxMode>=4 then
  begin
    data.modeCpx:=1;
    data.LimitesY(min,max,0,0);
  end
  else
  begin
    data.modeCpx:=CpxMode;
    if modeT=DM_evt1 then
      begin
        min:=-100;
        max:=100;
      end
    else data.limitesY(min,max,0,0);
  end;

  if min<=max then
    begin
      Ymin:=min;
      Ymax:=max;
    end;
  data.modeCpx:=0;
end;

procedure TvisuInfo.cadrerYlocal(data:typeDataB);
var
  min,max,delta:float;
begin
  if data=nil then exit;

  if cpxMode<4 then data.modeCpx:=CpxMode;

  if modeT=DM_evt1 then
    begin
      min:=-100;
      max:=100;
    end
  else
  begin
    data.limitesY(min,max,data.invconvx(Xmin),data.invconvx(Xmax));
  end;

  delta:=max-min;

  Ymin:=min-delta/10;
  Ymax:=max+delta/10;
  data.modeCpx:=0;
end;


procedure TvisuInfo.translateCoo(plus:boolean);
var
  d:float;
begin
  d:=Xmax-Xmin;
  if plus then
    begin
      Xmin:=Xmin+d;
      Xmax:=Xmax+d;
    end
  else
    begin
      Xmin:=Xmin-d;
      Xmax:=Xmax-d;
    end;

end;

procedure TvisuInfo.transferOldVisu(var oldVisu:ToldVisuInfo);
begin
  Xmin:=oldVisu.Xmin;
  Xmax:=oldVisu.Xmax;
  Ymin:=oldVisu.Ymin;
  Ymax:=oldVisu.Ymax;
  Zmin:=oldVisu.Zmin;
  Zmax:=oldVisu.Zmax;
  gamma:=oldVisu.gamma;
  //_aspect:=oldVisu.aspect;
  ux:=oldVisu.ux;
  uy:=oldVisu.uy;
  color:=oldVisu.color;
  twoCol:=oldVisu.twoCol;
  modeT:=oldVisu.modeT;
  tailleT:=oldVisu.tailleT;
  largeurTrait:=oldVisu.largeurTrait;
  styleTrait:=oldVisu.styleTrait;
  modeLogX:=oldVisu.modeLogX;
  modeLogY:=oldVisu.modeLogY;
  grille:=oldVisu.grille;
  cpX:=oldVisu.cpx;
  cpY:=oldVisu.cpy;
  cpZ:=oldVisu.cpz;

  echX:=oldVisu.echX;
  echY:=oldVisu.echY;
  FtickX:=oldVisu.FtickX;
  FtickY:=oldVisu.FtickY;
  CompletX:=oldVisu.completX;
  completY:=oldVisu.completY;
  TickExtX:=oldVisu.TickExtX;
  TickExtY:=oldVisu.TickExtY;
  ScaleColor:=oldVisu.ScaleColor;

  fontDescA:=oldVisu.fontDesc;
  initFont;
  //theta:=oldVisu.theta;
  inverseX:=false;
  inverseY:=false;
  Epduration:=oldVisu.EpDuration;

end;

procedure TvisuInfo.displayColorMap0(name:AnsiString;dir,Ncol:integer);
var
  i:integer;
  x1,x2:integer;
  dp:TDpalette;
  k,w,h:integer;
begin
  dp:=TDpalette.create;
  dp.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,canvasGlb.handle);
  dp.setType(Name);
  dp.SetPalette(Zmin,Zmax,gamma,modeLogZ);

  with canvasGlb do
  begin
    w:=x2act-x1act+1;
    h:=y2act-y1act+1;

    brush.style:=bsSolid;
    pen.style:=psSolid;

    case dir of
      0:for i:=0 to nCol-1 do
          begin
            x1:=x1act+round(w/nCol*i);
            x2:=x1act+round(w/nCol*(i+1));

            k:=dp.ColorPal(Zmin+i*(Zmax-Zmin)/(nCol-1));
            brush.color:=k;
            pen.color:=k;

            rectangle(x1-1,y1act,x2+1,y2act+2);
          end;

      1:for i:=0 to nCol-1 do
          begin
            x2:=y2act-round(h/nCol*i);
            x1:=y2act-round(h/nCol*(i+1));

            k:=dp.ColorPal(Zmin+i*(Zmax-Zmin)/(nCol-1));
            brush.color:=k;
            pen.color:=k;

            rectangle(x1act,x1-1,x2act+1,x2+1);
          end;

      2:for i:=0 to nCol-1 do
          begin
            x2:=x2act-round(w/nCol*i);
            x1:=x2act-round(w/nCol*(i+1));

            k:=dp.ColorPal(Zmin+i*(Zmax-Zmin)/(nCol-1));
            brush.color:=k;
            pen.color:=k;

            rectangle(x1-1,y1act,x2+1,y2act+2);
          end;

      3:for i:=0 to nCol-1 do
          begin
            x1:=y1act+round(h/nCol*i);
            x2:=y1act+round(h/nCol*(i+1));

            k:=dp.ColorPal(Zmin+i*(Zmax-Zmin)/(nCol-1));
            brush.color:=k;
            pen.color:=k;

            rectangle(x1act,x1-1,x2act+1,x2+1);
          end;
      end;
  end;

  dp.free;
end;

procedure TvisuInfo.displayColorMap(name:AnsiString;dir,Ncol:integer);
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  rectI:Trect;
begin

  FontToGlb;

  TRY

  BKcolor:=canvasGlb.brush.color;

  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideT;

  with rectI do setWindow(left,top,right,bottom);

  displayColorMap0(name,dir,Ncol);
  DisplayScale;


  setWindow(x1,y1,x2,y2);

  Finally
  canvasGlb.brush.color:=BKcolor;
  resetFontToGlb;
  End;
  
end;

procedure TvisuInfo.controle;
begin
  if Xmin=Xmax then
    begin
      Xmin:=0;
      Xmax:=100;
    end;

  if Ymin=Ymax then
    begin
      Ymin:=0;
      Ymax:=100;
    end;

  if (modeT<1) or (modeT>nbStyleTrace) then
    begin
      modeT:=1;
    end;

  if (gamma<=0) then
    begin
      gamma:=1;
    end;

end;

procedure TvisuInfo.FontToGlb;
begin
  if not assigned(canvasGlb) then exit;

  if fontvisu=nil then initFont;
  
  if FontCnt=0 then
    begin
      oldFont:=canvasGlb.font;
      canvasGlb.font:=fontVisu;

      if PRprinting and not FmagFont then
        begin
          canvasGlb.font.size:=round(canvasGlb.font.size*PRfontMag);
          FmagFont:=true;
        end;
    end;

  inc(FontCnt);
end;

procedure TvisuInfo.resetFontToGlb;
begin
  if not assigned(canvasGlb) then exit;

  dec(fontCnt);
  if FontCnt=0 then
    begin
      if FmagFont then canvasGlb.font.size:=round(canvasGlb.font.size/PRfontMag);
      FmagFont:=false;
      canvasGlb.Font:=oldFont;
    end;
end;


function TvisuInfo.info(ww:AnsiString): AnsiString;
begin
  result:=ww+'MinMax='+Estr(Xmin,3)+','+Estr(Xmax,3)+','
                   +Estr(Ymin,3)+','+Estr(Ymax,3)+','
                   +Estr(Zmin,3)+','+Estr(Zmax,3)+CRLF+
          ww+'gamma='+Estr(gamma,3)+CRLF+
          {ww+'aspect='+Estr(aspect,3)+CRLF+}
          ww+'Ux='+ux+CRLF+
          ww+'Uy='+uy+CRLF+
          ww+'color='+Istr(color)+CRLF+
          ww+'twoCol='+Bstr(twocol)+CRLF+
          ww+'modeT='+Istr(modeT)+CRLF+
          ww+'tailleT='+Istr(tailleT)+CRLF+
          ww+'lineWidth='+Istr(largeurTrait)+CRLF+
          ww+'StyleT='+Istr(styleTrait)+CRLF+
          ww+'logX='+Bstr(modeLogX)+CRLF+
          ww+'logY='+Bstr(modeLogY)+CRLF+
          ww+'Grid='+Bstr(grille)+CRLF+
          ww+'CP='+Istr(cpX)+','+Istr(cpY)+','+Istr(cpZ)+CRLF+
          ww+'Ech='+Bstr(echX)+','+Bstr(echY)+CRLF+
          ww+'Ftick='+Bstr(FtickX)+','+Bstr(FtickY)+CRLF+
          ww+'Complet='+Bstr(completX)+','+Bstr(completY)+CRLF+
          ww+'TickExt='+Bstr(TickExtX)+','+Bstr(TickExtY)+CRLF+
          ww+'ScaleColor='+Istr(scaleColor)+CRLF+
          ww+'fontDesc='+fontDescA.info+Crlf+
          ww+'font='+Istr(intG(fontVisu))+CRLF+
          //ww+'theta='+Estr(theta,3)+CRLF+

          ww+'inverse='+Bstr(inverseX)+','+Bstr(inverseY)+CRLF+
          ww+'Epduration='+Estr(EpDuration,3)+CRLF+
          ww+'ModeMat='+Istr(modeMat)+CRLF+
          ww+'keepRatio='+Bstr(keepRatio)+CRLF+
          ww+'color2='+Istr(color2)+CRLF+

          ww+'getS='+Istr(intG(@@getselectPixel))+','+Istr(intG(@@getMarkedPixel))+CRLF+
          ww+'selectCol='+Istr(selectCol)+CRLF+
          ww+'MarkCol='+Istr(MarkCol);
end;

function TvisuInfo.compare(visu1:TvisuInfo):boolean;
var
  p1,p2:pointer;
begin
  result:=(fontVisu.name=visu1.fontVisu.name)
          and
          (fontVisu.size=visu1.fontVisu.size)
          and
          (fontVisu.Style=visu1.fontVisu.style)
          and
          (fontVisu.Color=visu1.fontVisu.color);

  if result then
  begin
    p1:=fontVisu;
    p2:=visu1.fontVisu;
    fontVisu:=nil;
    visu1.fontVisu:=nil;

    result:=comparemem(@self,@visu1,sizeof(TvisuInfo));
    fontVisu:=p1;
    visu1.fontVisu:=p2;
  end;

end;


Initialization
AffDebug('Initialization visu0',0);

visuModel.init;

end.
