unit Daffac1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses windows,classes,graphics,sysutils,syncObjs,

     util1,Dgraphic,dtf0,Dtrace1,Dgrad1,debug0,listG,BMex1,
     stmdef,stmObj,dataGeneFile,
     acqDef2,acqInf2,stimInf2,
     AcqBrd1,visu0,multg1,stmvec1, stmVecSpk1, stmRaster1,
     stmOIseq1;


type
  {TaffContext contient toutes les info qui permettent d'afficher une trace dans
   un cadre pendant l'acquisition.
   L'affichage se fait dans le bitmap de la page courante. On appelle mutigForm.DrawBM
   pour afficher ce BM sur l'écran.

   Les données analogiques se trouvent dans Mainbuf.

   create2 s'applique à l'utilisation hors acquisition.

  }
  TAffContext=class
              protected
                BKcolor:Tcolor;     {couleur du fond. Sert pour effacer }
                win,WinI:Trect;     {rectangles extérieur et intérieur }
                trace:TTraceTableau;{objet trace}
                data:typeDataB;     {objet décrivant les data}
                Univers:TUnivers;   {objet décrivant les coordonnées}
                grad:typeGrad;      {objet décrivant les graduations}
                font1:Tfont;        {fonte pour graduations}

                Lcadrer:integer;    {nb points pour cadrer la trace}
                I1cadrer,I2cadrer:integer;

                Ffirst:boolean;     {le vecteur est en premier plan}
                vec:Tvector;        {vecteur source}

                InvRect:Trect;      {rectangle à invalider}
                modeEvt:boolean;

                continu:boolean;
                FExtData:boolean;

                xorg:float;

                voie0:integer;     { ajouté pourCyberK : voie d'acquisition}
                KS:integer;        {                     facteur de sous-ech }
                LastIfin:integer;  { dernier point affiché mode CyberSpk }

                Fworld:boolean;    { Le world est imposé par le premier objet de la fenêtre }

                indexT, oldIndexT:integer;
                nbpt:integer;
                periodeMS:double;


              public
                constructor create(voie:integer;vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numOrdre:integer);
                constructor create2(vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numOrdre:integer);

                procedure initTrace(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);

                destructor destroy;override;

                procedure afficherPoints(ep:integer;ideb,ifin:integer);virtual;
                function AdjustXminXmax(xx:float):boolean;
                procedure resetWindow(clear:boolean);virtual;
                procedure resetWindow1(II:integer);virtual;
                procedure setOrigin(n:integer);

                procedure updateVector;
                procedure updateScale;virtual;
                procedure updateContext;

                procedure cadrerY;virtual;
                procedure setLevelY;virtual;
                procedure afficherMtag(x:float;col:integer);
              end;

  TAffContextTag=
              class(TaffContext)
                constructor create(voie:integer;vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);
                constructor create2(vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);
                procedure cadrerY;override;
                procedure setLevelY;override;
              end;

  TAffContextSpk=
              class(TaffContext)
                dataAtt:typeDataB;
                colors:array of integer;
                constructor create(voie:integer;vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);
                constructor create2(vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);
                procedure OnDP(i:integer);
              end;

  TAffContextPCLtimes=
              class(TaffContext)
                constructor create(vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);
              end;

  TAffContextRaster=
              class(TaffContext)
                constructor create(vec1:TrasterPlot;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);
                constructor create2(vec1:Tvector;
                                  winrect,winRectI:Trect;BackCol:Tcolor;
                                  numordre:integer);

                procedure afficherPoints(ep:integer;ideb,ifin:integer);override;
                procedure cadrerY;override;
                procedure setLevelY;override;
                procedure resetWindow(clear:boolean);override;
                procedure resetWindow1(II:integer);override;

                procedure updateScale;override;
              end;


type
  TAcqContext=class(typeUO)
                AcqBM:TbitmapEx;
                AffContext:array of TaffContext;
                nbvoie,nbpt:integer;
                periodeN:float; {période nominale en  ms ou sec}

                AffTournant:boolean;

                oldI1:integer;
                Norg:integer;
                AcqPage:integer;

                Fdisplay,Fhold,Continu:boolean;
                Facq:boolean;
                PCLobj: TOIseqPCL;
                PeriodeMicro: float;
                EpMicro:float;

                constructor create;override;
                destructor destroy;override;

                procedure Init(acq:boolean);

                procedure add(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                              numOrdre:integer; World:boolean);
                procedure addTag(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                              numOrdre:integer; World:boolean);
                procedure addSpk(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                              numOrdre:integer; World:boolean);
                procedure addPCLtimes(vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                              numOrdre:integer; World:boolean);


                procedure addRaster(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                              numOrdre:integer; World:boolean);


                function AdjustXminXmax(xx:float):boolean;
                { modifie le cadrage des traces en acquisition continue }

                procedure AfficherSegmentVisu(ep:integer;ideb,ifin:integer);
                procedure AfficherSegment(i1,i2:integer);

                procedure setOrigins(N:integer);
                procedure resetWindows(Const Fempty:boolean=true);
                procedure resetWindows1(II:integer);

                procedure updateVectors;

                procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;

                procedure afficherMtag(x:float;col:integer);
                procedure RefreshMGrects;

                procedure Build(reprise:boolean;LastXend:float);
              end;

var
  AcqContext:TacqContext;

type
  TthreadAff=class(Tthread)
               acqContext:TacqContext;
               ITcont1,ITcont2:integer;
               ITcontStart:integer;
               cnt:integer;
               nbpt:integer;
               fini:boolean;
               lastSeq:integer;
               numSeq,debSeq,finSeq0:integer;
               nextTime:integer;
               FlagRefresh:boolean;
               Fimmediate:boolean;
               Tperiode:float;
               numseq0:integer;

               constructor create(acqCont:TacqContext;nbptSeq:integer;
                                  TimePeriod:float;AffIm,suspended:boolean);
               procedure DisplayTime;
               procedure DoAffImmediat;
               procedure doAff1;{appelé par DoaffNormal}
               procedure DoAffNormal;
               procedure doAffVS(index:integer);

               procedure execute;override;
             end;

var
  threadAff:TthreadAff;
  eventAff:Tevent;

IMPLEMENTATION

uses stmdf0 ;

{************************** Méthodes de TaffContext ************************}

constructor TAffContext.create(voie:integer;vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
var
  numT:typetypeG;
  OffsetT:integer;
  nbStepT:integer;
  Dxu1:float;
begin
  voie0:=voie;
  numT:=acqInf.ChannelNumType[voie];
  OffsetT:=acqInf.SampleOffset[voie];

  NbStepT:=mainBufSize div acqInf.AgTotSize;

  KS:= AcqInf.QKS[voie];
  if KS=0 then KS:=1;

  if AcqInf.continu
    then nbpt:=maxEntierLong
    else nbpt:=AcqInf.Qnbpt;

  periodeMS:=AcqInf.periodeParVoieMS;

  if FmultiMainBuf then
  begin
    { Le cas EVT n'est pas prévu }
    if AcqInf.ChannelType[voie]=TI_analog then
    begin
      case NumT of
        G_smallint: with MultiMainBuf[voie-1] do
           data:=typedataIT.createStep(Buf,2,BufSize ,0,0,BufSize-1);

        G_single: with MultiMainBuf[voie-1] do
           data:=typedataST.createStep(Buf,4,BufSize ,0,0,BufSize-1);
      end;

      data.setConversionX(acqInf.Dxu * KS,xorg);
      data.setConversionY(acqInf.Dyu(voie),acqInf.Y0u(voie));

    end;

    xorg:=mainBufIndex0 * acqInf.Dxu;

  end
  else
  begin
    xorg:=mainBufIndex0 * acqInf.Dxu;

    if vec1.visu.modeT=DM_evt1 then
      begin
        modeEvt:=true;
        KS:=0;
        with EvtBuf[voie] do
          data:=typedataLT.createStep(Buf,4,BufSize,0 ,1,BufSize);
        if AcqInf.ChannelType[voie]=TI_digiEvent then
        begin
          if AcqInf.continu then Dxu1:=0.000001 else Dxu1:=0.001;
        end
        else Dxu1:=AcqInf.Dxu;
        data.setConversionX(Dxu1 ,xorg);
        data.setConversionY(Dxu1 ,xorg);
      end
    else
    begin
      case NumT of
        G_smallint:
          case board.dataFormat of
            Fdigi1200,Fdigi1322:
                 data:=typedataIdigiT.createStep(@MainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT,0,0,nbAg0-1,board.tagShift);
            else data:=typedataIT.createStep(@MainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT,0,0,nbAg0-1);
          end;
        G_single:
           data:=typedataST.createStep(@MainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT,0,0,nbAg0-1);
      end;
      data.setConversionX(acqInf.Dxu,xorg);
      data.setConversionY(acqInf.Dyu(voie),acqInf.Y0u(voie));
    end;
  end;


  continu:=AcqInf.continu;
  if continu
    then Lcadrer:=roundL(1000/AcqInf.periodeCont)
    else Lcadrer:=AcqInf.Qnbpt;

  if FmultiMainBuf and (KS<>0) then Lcadrer := Lcadrer div KS;
  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
  LastIfin:=1;
  indexT:=-1;
  oldIndexT:=-1;
end;


constructor TAffContext.create2(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);

begin
  data:=typedataE(vec1.data);
  FExtData:=true;

  continu:=true;
  Lcadrer:=roundL(1/vec1.dxu);

  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
end;


procedure TaffContext.initTrace(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
begin
  vec:=vec1;
  vec.Facquis:=true;

  Univers:=Tunivers.create;
  with vec.visu do
  begin
    Univers.setworld(Xmin,Ymin,Xmax,Ymax);
    univers.setModeLog(modeLogX,modeLogY);
    univers.setInverse(inverseX,inverseY);
  end;

  trace:=TTraceTableau.create(Univers,data);

  with vec.visu do
  begin
    trace.setColorTrace(color);
    trace.setStyle(modeT,tailleT);
    trace.setTrait(largeurTrait,styleTrait);
  end;

  grad:=typeGrad.create;
  with grad,vec.visu do
  begin
    if not assigned(font1) then font1:=Tfont.create;
    font1.Assign(fontVisu);
    setUnites(uX,uY);
    setLog(modeLogX,modeLogY);

    setEch(echX,echY);
    setCadre(FtickX,FtickY,1);
    setComplet(completX,completY);
    setExternal(tickExtX,tickExtY);
    setInverse(inverseX,inverseY);
    setGrille(grille);

    setColors(scaleColor,Backcol);
  end;

  win:=winRect;
  winI:=winRectI;
  BKcolor:=BackCol;


  Ffirst:=(numOrdre=0);

end;

destructor TAffContext.destroy;
begin
  trace.free;

  if not FExtData then data.free;

  Univers.free;
  grad.free;
end;

procedure TAffContext.afficherPoints(ep:integer;ideb,ifin:integer);  {indices dans mainbuf}
const
  pdum:Pinteger=nil;
var
  f1,f2:boolean;
begin
  if KS=-1 then                       // voie PCLtimes
    begin
      ideb:=LastIFin+1;
      ifin:=PCLbuf.Index;                  {en index-1 se trouve le dernier pt stocké
                                          mais le buffer travaille avec indice1=0 et dataSpk avec indice1=1 }
      if (ifin<ideb) then exit;
    end
  else
  if FmultiMainBuf then
  begin
    if KS=0 then                           // voies SPK
    begin
      ideb:=LastIFin+1;
      ifin:=MultiEvtBuf[voie0-1].Index;   {en index-1 se trouve le dernier pt stocké
                                           mais le buffer travaille avec indice1=0 et dataSpk avec indice1=1 }
    end
    else
    if voie0<>0 then                       // voies Analog
    begin
      ideb:=LastIFin;
      ifin:=MultiMainBuf[voie0-1].Index-1;   {en index-1 se trouve le dernier pt stocké }
    end
    else
    begin                                 // voies tag
      ideb:=LastIFin;
      ifin:=MultiCyberTagBuf.Index-1;     {en index-1 se trouve le dernier pt stocké }
    end;

    if ifin<ideb then exit;
  end
  else
  if modeEvt then
   begin
     EvtBuf[voie0].ProcessSpikes(ep,indexT,oldIndexT);
     ideb:=oldIndexT+1;
     ifin:=indexT;
//     affdebug('voie='+Istr(voie0)+'    ideb='+Istr(ideb)+'     ifin='+Istr(ifin),101);
     if (ifin<ideb) then exit;
   end
  else
  if Ideb<0 then Ideb:=0;

  with winI do Dgraphic.setWindow(left,top,right,bottom);

  f1:=false;
  f2:=false;
  Try
    trace.afficherPoints(Ideb,Ifin);
    f1:=true;

    if KS=-1
      then InvRect:=rect(convWx(data.getE(ideb))-10,y1act,convWx(data.getE(ifin))+1+10,y2act)
    else
    if FmultiMainBuf then
    begin
      if modeEvt
        then InvRect:=rect(convWx(data.getE(ideb)),y1act,convWx(data.getE(ifin))+1,y2act)
        else InvRect:=rect(trace.cvx0(ideb),y1act,trace.cvx0(ifin)+1,y2act);
    end
    else
    begin
      if modeEvt
        then InvRect:=rect( convWx(data.getE(ideb)),y1act,convWx(data.getE(ifin))+1,y2act)
        else InvRect:=rect(trace.cvx0(ideb),y1act,trace.cvx0(ifin)+1,y2act);
    end;
    if invRect.left>=invrect.Right
      then invRect.left:=winI.Left;
    f2:=true;
    I2cadrer:=Ifin;
    I1cadrer:=Ifin-Lcadrer;

  Except
    sendStmMessage('Display error= 100');
    affDebug('afficherPoints '+Bstr(f1)+' '+Bstr(f2),13);
    FlagStopPanic:=true;
  end;

  LastIfin:=Ifin;
end;

{Si x0 est en dehors de la fenêtre, AdjustXminXmax
   - modifie Xmin et Xmax
   - efface l'intérieur de la fenêtre et les graduations
   - réaffiche les graduations
}

function TaffContext.AdjustXminXmax(xx:float):boolean;
var
  d:float;
  x0:float;
begin

  x0:=xx;
  {affdebug('AdjustXminXmax');}
  result:=false;
  with univers do
  begin
    if XmaxA<=XminA then exit;

    if (x0>XmaxA) or (x0<XminA) then
    begin
      affdebug('AdjustXminXmax '+vec.ident+'  '+Estr(x0,3)+' Xmin='+Estr(XminA,3)
            +' Xmax='+Estr(XmaxA,3)+Bstr(result),15);

      d:=XmaxA-XminA;
      while x0>XmaxA do
      begin
        XminA:=XminA+d;
        XmaxA:=XmaxA+d;
      end;
      while x0<XminA do
      begin
        XminA:=XminA-d;
        XmaxA:=XmaxA-d;
      end;

      result:=true;
      if (vec.Xmin<>XminA) and not Fworld then
        begin
          vec.Xmin:=XminA;
          vec.Xmax:=XmaxA;
          vec.messageCpx;
        end;

    end;
  end;
end;

procedure TaffContext.resetWindow(clear:boolean);
begin
  //if not Ffirst then exit;

  if clear then vec.FlagPaintEmpty:=true;
  vec.MessageToRef(uomsg_updateBM,nil);
end;

procedure TaffContext.resetWindow1(II:integer);
begin
  vec.flagPartialPaint:=true;
  vec.IpartialPaint:=II;
  vec.MessageToRef(uomsg_updateBM,nil);
end;


procedure TaffContext.updateScale;
var
  oldFont:Tfont;
begin
  {affdebug('updateScale');}
  if not Ffirst then exit;

  {effacer le bas}
  Dgraphic.setWindow(win.left,winI.bottom+2,win.right,win.bottom);
  clearWindow(BKcolor);
  {effacer la partie gauche}
  Dgraphic.setWindow(win.left,win.top,winI.left-2,win.bottom);
  clearWindow(BKcolor);

  {effacer les ticks gauche}
  Dgraphic.setWindow(winI.left,winI.top,winI.left+grad.gv.Ltick,winI.bottom);
  clearWindow(BKcolor);
  {effacer les ticks droite}
  Dgraphic.setWindow(winI.right-grad.gv.Ltick,winI.top,winI.right,winI.bottom);
  clearWindow(BKcolor);

  {afficher les coordonnées}
  with winI do Dgraphic.setWindow(left,top,right,bottom);
  oldFont:=canvasGlb.font;
  canvasGlb.font:=font1;
  with univers do Dgraphic.setWorld(XminA,YminA,XmaxA,YmaxA);
  grad.affiche;
  canvasGlb.font:=oldFont;
end;


procedure TaffContext.setOrigin(n:integer);
begin
  if FmultiMainBuf and (KS>0) then data.setConversionX(data.ax,-(n div KS)*data.ax)
  else
  if not FmultiMainBuf and not modeEvt then data.setConversionX(data.ax,-n *data.ax);

  {if KS=0 then data.setConversionY(data.ax,-n*data.ax);}
  {affdebug('setOrg '+Estr(-n*data.ax,3));}
end;

procedure TaffContext.updateVector;
begin
  if not Fworld then
  begin
    vec.Xmin:=univers.XminA;
    vec.Xmax:=univers.XmaxA;
    vec.Ymin:=univers.YminA;
    vec.Ymax:=univers.YmaxA;
  end;
end;

procedure TaffContext.updateContext;
begin
  if not Fworld then
  begin
    univers.XminA:=vec.Xmin;
    univers.XmaxA:=vec.Xmax;
    univers.YminA:=vec.Ymin;
    univers.YmaxA:=vec.Ymax;
    updateScale;
  end;
end;

procedure TaffContext.cadrerY;
var
  y1,y2:float;
begin
  with data do
  limitesY(y1,y2,I1cadrer,I2cadrer);
  if y2<>y1 then
    begin
      vec.Ymin:=y1;
      vec.Ymax:=y2;
      updateContext;
    end;
  affdebug('TaffContext.cadrerY '+Estr(y1,3)+' '+Estr(y2,3)+'  '+Istr(I1cadrer)+'/'+Istr(I2cadrer),20 );
end;

procedure TaffContext.setLevelY;
var
  dd,mm:float;
begin
  mm:=data.moyenne(I1cadrer,I2cadrer);
  dd:=vec.Ymax-vec.Ymin;
  if dd>0 then
  begin
    vec.Ymin:=mm-dd/2;
    vec.Ymax:=mm+dd/2;
    updateContext;
  end;
end;

procedure TaffContext.afficherMtag(x:float;col:integer);
var
  i:integer;
begin
  with winI do Dgraphic.setWindow(left,top,right,bottom);

  with Univers do Dgraphic.setWorld(XminA,YminA,XmaxA,YmaxA);

  linever(x,col,false);


end;


{************************** Méthodes de TaffContextRaster ************************}

constructor TaffContextRaster.create(vec1:TRasterPlot;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
begin

  if FmultiMainBuf then KS:=1 else KS:=0;

  data:=typeDataB.create(0,1);
  data.setConversionX(acqInf.Dxu,xorg);

  xorg:=mainBufIndex0 * acqInf.Dxu;

  continu:=AcqInf.continu;
  if continu
    then Lcadrer:=roundL(1000/AcqInf.periodeCont)
    else Lcadrer:=AcqInf.Qnbpt;

  if FmultiMainBuf and (KS<>0) then Lcadrer := Lcadrer div KS;
  initTrace(Tvector(vec1), winrect,winRectI,BackCol,numOrdre);
  LastIfin:=1;

  grad.setEch(true,false);
  grad.setCadre(true,false,1);

  Ffirst:=true;
end;


constructor TaffContextRaster.create2(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
begin
end;

procedure TaffContextRaster.afficherPoints(ep:integer;ideb,ifin:integer);
begin
end;

procedure TaffContextRaster.cadrerY;
begin
end;

procedure TaffContextRaster.setLevelY;
begin
end;

procedure TaffContextRaster.resetWindow(clear:boolean);
begin
  vec.MessageToRef(uomsg_paintEmpty,nil);
end;

procedure TaffContextRaster.resetWindow1(II:integer);
begin
  vec.MessageToRef(uomsg_updateBM,nil);
end;

procedure TaffContextRaster.updateScale;
var
  oldFont:Tfont;
begin
  {effacer le bas}
  Dgraphic.setWindow(win.left,winI.bottom+2,win.right,win.bottom);
  clearWindow(BKcolor);

  {afficher les coordonnées}
  with winI do Dgraphic.setWindow(left,top,right,bottom);
  oldFont:=canvasGlb.font;
  canvasGlb.font:=font1;
  with univers do Dgraphic.setWorld(XminA,YminA,XmaxA,YmaxA);
  grad.affiche;
  canvasGlb.font:=oldFont;
end;


{************************** Méthodes de TaffContextTag ************************}

constructor TAffContextTag.create(voie:integer;vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
var
  OffsetT,NbstepT:integer;

begin
  if FmultiMainBuf then
  with acqInf do
  begin
    with MultiCyberTagBuf do
    data:=typedataDigiTagT.create(Buf,1,BufSize,0,0,BufSize-1,voie);

    xorg:= mainBufIndex0 * acqInf.Dxu;
    data.setConversionX(Dxu,xorg);
    KS:=1;
  end
  else
  begin
    OffsetT:=acqInf.SampleOffset[acqInf.nbVoieAcq];

    NbStepT:=mainBufSize div acqInf.AgTotSize;

    with acqInf do
    begin
      if (board.dataFormat in [Fdigi1200,Fdigi1322])
        then data:=typedataDigiTagT.create(@MainBuf^[0],nbvoieAcq,nbAg0,0,0,nbAg0-1,voie)
        else data:=typedataDigiTagT.createStep(@MainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT,0,0,nbAg0-1,voie);



      xorg:= mainBufIndex0 * acqInf.Dxu;
      data.setConversionX(Dxu,xorg);
    end;
  end;

  continu:=AcqInf.continu;
  if continu
    then Lcadrer:=roundL(1000/AcqInf.periodeCont)
    else Lcadrer:=AcqInf.Qnbpt;

  if FmultiMainBuf then
    with acqInf do Lcadrer:=Lcadrer div QKS[voie];


  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
end;

constructor TAffContextTag.create2(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
begin
  data:=typedataE(vec1.data);
  FExtData:=true;

  continu:=true;
  Lcadrer:=roundL(1/vec1.dxu);

  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
end;

procedure TaffContextTag.cadrerY;
begin
  vec.Ymin:=-1;
  vec.Ymax:=2;
  updateContext;
  {affdebug('TaffContextTag.cadrerY ');}
end;

procedure TaffContextTag.setLevelY;
begin
  vec.Ymin:=-1;
  vec.Ymax:=2;
  updateContext;
end;

{************************** Méthodes de TaffContextSpk ************************}

constructor TAffContextSpk.create(voie:integer;vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
var
  i:integer;
begin
  voie0:=voie;

  { Toujours FmultiMainBuf }

  KS:=0;
  with MultiEvtBuf[voie-1] do
  begin
    data:=typedataLT.createStep(Buf,4,BufSize,-1 ,1,BufSize);
    dataAtt:=typeDataByteT.createStep(bufAtt,1,BufSize,-1,1,BufSize);
  end;

  data.setConversionX(acqInf.Dxu ,xorg);
  data.setConversionY(acqInf.Dxu ,xorg);

  modeEvt:=true;

  with TvectorSpk(vec1) do
  begin
    setLength(colors,length(StdColors));
    for i:=0 to high(StdColors) do
      colors[i]:=StdColors[i];
  end;

  xorg:= mainBufIndex0 * acqInf.Dxu;

  continu:=AcqInf.continu;
  if continu
    then Lcadrer:=roundL(1000/AcqInf.periodeCont)
    else Lcadrer:=AcqInf.Qnbpt;

  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
  trace.onDisplayPoint:=OnDp;
  LastIfin:=1;
  indexT:=-1;
  oldIndexT:=-1;
end;


constructor TAffContextSpk.create2(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
begin
  data:=typedataE(vec1.data);
  FExtData:=true;

  continu:=true;
  Lcadrer:=roundL(1/vec1.dxu);

  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
  trace.onDisplayPoint:=OnDp;
end;

procedure TAffContextSpk.OnDP(i:integer);
var
  bb:byte;
begin

  bb:=dataAtt.getI(i);
  if (bb<length(colors))
    then canvasGlb.pen.color:=colors[bb]
    else canvasGlb.pen.color:=colors[0];
  {
  if bb<length(colors)
    then affDebug('onDP '+Istr(i)+' '+Istr(bb)+' '+Istr(colors[bb]),99)
    else affDebug('onDP '+Istr(i)+' '+Istr(bb),99)
  }
end;

{************************** Méthodes de TaffContextPCLtimes ************************}

constructor TaffContextPCLtimes.create(vec1:Tvector;
                               winrect,winRectI:Trect;BackCol:Tcolor;
                               numOrdre:integer);
var
  i:integer;
begin

  KS:=-1;
  with PCLBuf do
    data:=typedataDT.createStep(Buf,14,nbrec,-1 ,1,nbrec);

  modeEvt:=true;

  xorg:= mainBufIndex0 * acqInf.Dxu;

  continu:=AcqInf.continu;
  if continu
    then Lcadrer:=roundL(1000/AcqInf.periodeCont)
    else Lcadrer:=AcqInf.Qnbpt;

  initTrace(vec1, winrect,winRectI,BackCol,numOrdre);
  LastIfin:=1;
  indexT:=-1;
  oldIndexT:=-1;
end;



{************************** Méthodes de TacqContext ************************}

constructor TacqContext.create;
begin
  inherited create;
  notPublished:=true;
  ident:='_AcqContext';
end;

procedure TacqContext.Init(acq:boolean);
begin
  {AcqBM:=bm;}
  Facq:=acq;
  if Facq then
    begin
      with acqInf do
      begin
        nbvoie:=nbvoieAcq;
        if continu
          then nbpt:=maxEntierLong
          else nbpt:= Qnbpt;
        periodeN:=periodeParVoie;
        PeriodeMicro:=periodeParVoieMs*1000;
        EpMicro:= DureeSeq*1000;
      end;

      Continu:=acqInf.continu;
      Fhold:=acqInf.Fhold;
      Fdisplay:=acqInf.Fdisplay;
    end
  else
    begin
      nbvoie:=0;
      periodeN:=0;

      Continu:=true;
      Fhold:=false;
      Fdisplay:=true;
    end;
end;

destructor TacqContext.destroy;
var
  i:integer;
begin
  for i:=0 to length(AffContext)-1 do
    begin
      affcontext[i].vec.Facquis:=false;
      if typeUO(affcontext[i].vec) is Tvector then affcontext[i].vec.FlagPaintEmpty:=false;

      derefObjet(typeUO(affcontext[i].vec));
      affcontext[i].free;
    end;
  inherited;
end;


procedure TacqContext.add(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                          numOrdre:integer; World:boolean);
begin
  if rect.left<>rect.right then
    begin
      setLength(affContext,length(AffContext)+1);
      if Facq
        then affContext[length(AffContext)-1]:=TaffContext.create(num,vec1,rect,rectI,col,numOrdre)
        else affContext[length(AffContext)-1]:=TaffContext.create2(vec1,rect,rectI,col,numOrdre);
      refObjet(vec1);
    end;

  if periodeN=0 then periodeN:=vec1.Dxu;
  affContext[length(AffContext)-1].Fworld:=World;
end;

procedure TacqContext.addTag(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                          numOrdre:integer; World:boolean);
begin
  if rect.left<>rect.right then
    begin
      setLength(affContext,length(AffContext)+1);
      if Facq
        then affContext[length(AffContext)-1]:=TaffContextTag.create(num,vec1,rect,rectI,col,numOrdre)
        else affContext[length(AffContext)-1]:=TaffContextTag.create2(vec1,rect,rectI,col,numOrdre);
      refObjet(vec1);
    end;
  affContext[length(AffContext)-1].Fworld:=World;
end;

procedure TacqContext.addSpk(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                          numOrdre:integer; World:boolean);
begin
  if rect.left<>rect.right then
    begin
      setLength(affContext,length(AffContext)+1);
      if Facq
        then affContext[length(AffContext)-1]:=TaffContextSpk.create(num,vec1,rect,rectI,col,numOrdre)
        else affContext[length(AffContext)-1]:=TaffContextSpk.create2(vec1,rect,rectI,col,numOrdre);
      refObjet(vec1);
    end;
  affContext[length(AffContext)-1].Fworld:=World;
end;

procedure TacqContext.addPCLtimes(vec1:Tvector;rect,rectI:Trect;col:Tcolor; numOrdre:integer; World:boolean);
begin
  if rect.left<>rect.right then
    begin
      setLength(affContext,length(AffContext)+1);
      affContext[length(AffContext)-1]:=TaffContextPCLtimes.create(vec1,rect,rectI,col,numOrdre);
      refObjet(vec1);
    end;
  affContext[length(AffContext)-1].Fworld:=World;
end;

procedure TacqContext.addRaster(num:integer;vec1:Tvector;rect,rectI:Trect;col:Tcolor;
                          numOrdre:integer; World:boolean);
var
  i:integer;
begin
  for i:=0 to length(AffContext)-1 do
  with AffContext[i] do
  if (vec=vec1) and comparemem(@win, @rect,sizeof(Trect)) then exit;  {même vecteur, même fenêtre }

  if rect.left<>rect.right then
  begin
    setLength(affContext,length(AffContext)+1);
    if Facq
      then affContext[length(AffContext)-1]:=TaffContextRaster.create(TrasterPlot(vec1),rect,rectI,col,numOrdre)
      else affContext[length(AffContext)-1]:=TaffContext.create2(vec1,rect,rectI,col,numOrdre);
    refObjet(vec1);
  end;

  affContext[length(AffContext)-1].Fworld:=World;
end;


procedure TacqContext.AfficherSegmentVisu(ep:integer;ideb,ifin:integer);
var
  i:integer;
begin
  with AcqBM do initGraphic(canvas,0,0,width,height);
  for i:=0 to length(AffContext)-1 do
    affcontext[i].afficherPoints(ep,ideb-1,ifin);
  doneGraphic;
  Affdebug('AfficherSegmentVisu '+Istr(ideb)+' '+Istr(ifin),15);
  If assigned(PCLbuf) then PCLobj.UpdatePhotons(PCLbuf.Index-1, (ifin mod nbpt)*PeriodeMicro);
end;

function TacqContext.AdjustXminXmax(xx:float):boolean;
var
  i:integer;
begin
  result:=false;
  for i:=0 to length(AffContext)-1 do
    if affcontext[i].AdjustXminXmax(xx) then result:=true;
end;

procedure TacqContext.resetWindows(Const Fempty:boolean=true);
var
  i:integer;
  nb:integer;
begin
  for i:=0 to length(AffContext)-1 do
    with affcontext[i] do
    if Ffirst then
      if Fempty
        then nb:=vec.MessageToRef(uomsg_PaintEmpty,nil)
        else nb:=vec.MessageToRef(uomsg_invalidate,nil);

//  affdebug('                             Reset Windows ',101);
end;

{ resetWindows1 est utilisée par stmPlay1}
procedure TacqContext.resetWindows1(II:integer);
var
  i:integer;
begin
  for i:=0 to length(AffContext)-1 do
    affcontext[i].resetWindow1(II);
end;


procedure TacqContext.setOrigins(n:integer);
var
  i:integer;
begin
  Norg:=n;
  for i:=0 to length(AffContext)-1 do
    affcontext[i].setOrigin(n);
end;



procedure TacqContext.AfficherSegment(i1,i2:integer);
var
  adjust:boolean;
  i:integer;
begin
  dec(i1);
  {si la fin de la fenêtre est atteinte, les coordonnées sont modifiées et
  on reprend le i1 précédent pour ne pas perdre le début de l'affichage}
  adjust:=false;
  {
  if AffTournant then
  begin
    adjust:=adjust or AdjustXminXmax(i2);
    if adjust then
      begin
        i1:=oldI1;
        resetWindows;
      end;
  end;
  }
  if AffTournant then
  begin
    for i:=0 to length(AffContext)-1 do
    with affContext[i] do
      if AdjustXminXmax(xorg+i2*periodeN) then
        begin
          i1:=oldI1;
          resetWindow(true);
        end;
  end;

  afficherSegmentVisu(1,i1,i2);

  oldI1:=i1;
end;


procedure TacqContext.updateVectors;
var
  i:integer;
begin
  if continu then
     for i:=0 to length(AffContext)-1 do AffContext[i].updateVector;
end;


procedure TacqContext.ProcessMessage(id:integer;source:typeUO;p:pointer);
var
  i:integer;
begin
  case id of
    UOmsg_invalidateAcq:
      for i:=0 to length(AffContext)-1 do
        if source=affcontext[i].vec then
          begin
            with AcqBM do initGraphic(canvas,0,0,width,height);
            affcontext[i].updateContext;
            doneGraphic;
          end;
    UOmsg_autoscaleAcq:
      for i:=0 to length(AffContext)-1 do
        if source=affcontext[i].vec then
          begin
            with AcqBM do initGraphic(canvas,0,0,width,height);
            affcontext[i].cadrerY;
            doneGraphic;
          end;

    UOmsg_setLevelAcq:
      for i:=0 to length(AffContext)-1 do
        if source=affcontext[i].vec then
          begin
            with AcqBM do initGraphic(canvas,0,0,width,height);
            affcontext[i].SetLevelY;
            doneGraphic;
          end;

    {
    UOmsg_bringToFront:
      for i:=1 to length(AffContext) do
        affcontext[i].Ffirst:= (source=affcontext[i].vec);
     }
  end;

end;

procedure TacqContext.afficherMtag(x:float;col:integer);
var
  i,j:integer;
begin
  with AcqBM do initGraphic(canvas,0,0,width,height);
  for i:=0 to length(AffContext)-1 do
  begin
    affContext[i].afficherMTag(x,col);
    j:=convWx(x);
    multigraph0.formG.drawRect(AcqPage,Rect(j,y1act,j+1,y2act));
  end;
  doneGraphic;
end;


procedure TacqContext.RefreshMGrects;
var
  i:integer;
begin
  for i:=0 to length(AffContext)-1  do
    multigraph0.formG.drawRect(AcqPage,affContext[i].InvRect);
//  multigraph0.formG.drawRect(AcqPage,rect(0,0,1500,1000));
//  affdebug('drawRect',79); 
end;




procedure TAcqContext.Build(reprise:boolean;LastXend:float);
var
  i,numF,numO:integer;
  firstPlot:typeUO;
  Fworld,FlogX,FlogY,canDraw:boolean;
  x1w,y1w,x2w,y2w:float;
  x1wa,y1wa,x2wa,y2wa:float;
  flagFont:boolean;
  curFont:Tfont;

  procedure AddDataFileVector(numV:integer;vec: Tvector; cat: integer);
  var
    rect1,rect2:Trect;
  begin
    {
    if AcqInf.continu then
    with vec do
    if reprise
      then AdjustXminXmax(LastXend)
      else AdjustXminXmax(0);
    }
    rect1:=multigraph0.formG.getRect(vec,numF,numO,firstPlot);     { rect1 = le cadre }
    if numF>=0 then
    begin
      with rect1 do setWindow(left,top,right,bottom);
      with multigraph0.formG do
        rect2:=curPageRec.getInsideWindow(numF,1);                   { rect2 = fenêtre intérieure }

      FirstPlot.getWorldPriorities(Fworld,FlogX,FlogY,x1w,y1w,x2w,y2w);

      if Fworld then
      begin
         FirstPlot.SetCurrentWorld(numO,x1w,y1w,x2w,y2w);
         canDraw:=FirstPlot.SetCurrentWindow(numO,rect2);
      end
      else
      begin
         with rect2 do setWindow(left,top,right,bottom);
         canDraw:=true;
      end;

      if not canDraw then exit;


      flagFont:=multigraph0.formG.CurPageRec.PageFontP;
      if FlagFont then
      begin
        curFont:=Tfont.create;
        curfont.Assign(multigraph0.formG.CurpageRec.fontP);
      end
      else curFont:=nil;


      try
        if flagFont then vec.swapFont(curFont,multigraph0.formG.CurpageRec.scaleColorP);
        with multigraph0.formG.CurpageRec do
          if UseVparams then vec.swapVisu(visuP,visuFlags);
        FirstPlot.modifyPlot(numO,vec);
        if Fworld then
        begin
          vec.getWorld(x1wa,y1wa,x2wa,y2wa);
          Dgraphic.getWorld(x1w,y1w,x2w,y2w);
          vec.setWorld(x1w,y1w,x2w,y2w);
        end;

        with rect2 do getWindowG(left,top,right,bottom);
        case cat of
          1: add(numV,vec,rect1,rect2,multigraph0.formG.curPageRec.BKcolorP,numO, Fworld);
          2: addTag(numV,vec,rect1,rect2,multigraph0.formG.curPageRec.BKcolorP,numO, Fworld);
          3: addSpk(numV,vec,rect1,rect2,multigraph0.formG.curPageRec.BKcolorP,numO, Fworld);
          4: addPCLtimes(vec,rect1,rect2,multigraph0.formG.curPageRec.BKcolorP,numO, Fworld);
        end;

      finally
        FirstPlot.RestorePlot(numO,vec);
        if Fworld then vec.setWorld(x1wa,y1wa,x2wa,y2wa);
        if flagFont then vec.swapFont(curFont,multigraph0.formG.CurpageRec.scaleColorP);
        with multigraph0.formG.CurpageRec do
          if UseVparams then vec.swapVisu(visuP,visuFlags);
      end;

      if FirstPlot is TrasterPlot then addRaster(0,Tvector(FirstPlot),rect1,rect2,multigraph0.formG.curPageRec.BKcolorP,0,false);

    end;

  end;



begin
  with acqInf,dataFile0 do
  begin
    for i:=1 to Qnbvoie do
      case ChannelType[i] of
        TI_analog,TI_Neuron:channel(i).modeT:=DM_line;
        else channel(i).modeT:=DM_Evt1;
      end;
    for i:=1 to nbvoieSpk do
    if not (Vspk(i).modeT in [DM_Evt1,DM_Evt2])
      then Vspk(i).modeT:=DM_Evt1;
  end;

  init(true);
  acqBM:=multigraph0.formG.getBM;
  acqPage:=multigraph0.formG.currentPage;
  AffTournant:=acqInf.continu;

  with multigraph0.formG.paintBox1 do initGraphic(canvas,left,top,width,height);

  for i:=1 to AcqInf.Qnbvoie do AddDataFileVector(i,datafile0.channel(i),1);

  if board.tagMode<>tmNone then
    for i:=1 to board.TagCount do AddDataFileVector(i,datafile0.Vtag[i],2);

  for i:=1 to AcqInf.nbvoieSpk do AddDataFileVector(i,datafile0.Vspk(i),3);

  if assigned(PCLbuf) then AddDataFileVector(i,datafile0.FPCL.Vtimes,4);
  doneGraphic;

  if AcqInf.continu then
  begin
    if not reprise then LastXend:=0;

    for i:=0 to length(AffContext)-1 do
    with affContext[i] do
      if AdjustXminXmax(LastXend) then resetWindow(false);
  end;
end;




{*********************** Méthodes de TthreadAff ***********************}

constructor TthreadAff.create(acqCont:TacqContext;nbptSeq:integer;
                              TimePeriod:float;AffIm,suspended:boolean);
begin
  acqContext:=acqCont;
  if nbptSeq=0 then nbptSeq:=maxEntierLong;
  nbpt:=nbptSeq;
  Fimmediate:=AffIm;
  Tperiode:=TimePeriod;


  ITcont1:=0;

  if acqCont.Fhold then acqCont.resetWindows;

  inherited create(suspended);
end;

procedure TthreadAff.displayTime;
var
  n,t,sec,min,h:integer;
  st:string;
begin
  n:=MainBufIndex+1;
  if n>=nextTime then
    begin
      t:=roundL(Tperiode*n/1000);
      sec:= t mod 60;

      min:= (t div 60) mod 60;

      h:= t div 3600;

      TimePanel.caption:=Istr1(h,2)+'.'+Istr2(min,2)+'.'+Istr2(sec,2);
      TimePanel.Update;

      nextTime:=nextTime+roundL(1000/Tperiode);
    end;

  st:=Istr(itCont2){+'/'+Istr(count2)};
  if assigned(PCLbuf) then st:=st+'/'+Istr(PCLbuf.Index);

  CountPanel.caption:= st;
  CountPanel.update;

  SavePanel.update;
end;

{Méthode synchronisée en mode affichage immédiat}

procedure TthreadAff.DoAffImmediat;
var
  i1,i2,deb,fin,numS:integer;
begin
  if acqContext.Fdisplay then
    begin
      affdebug('DoAffImmediat ',3);

      {pushCriticalVar;}
      with AcqContext.AcqBM do initGraphic(canvas,0,0,width,height);

      {mode continu}
      if nbpt=maxEntierLong then
        with AcqContext do
        begin
          AfficherSegment(iTcont1,iTcont2-1);

          if FlagStop2 then fini:=true;
        end
      else
      {mode séquence}
        begin
          i1:=ITcont1;
          while i1<itCont2 do
          begin
            numS:=I1 div nbpt;
            deb:=numS*nbpt;
            fin:=(numS+1)*nbpt;

            if deb=I1 then
              with AcqContext do
              begin

                if not Fhold  OR FlagRefresh
                  then resetWindows;

                FlagRefresh:=false;
                setOrigins(I1);

                panelSeq.caption:=Istr(numseq0+numS+1);
                panelSeq.update;

              end;

            if itcont2<=fin then i2:=itcont2
                            else i2:=fin;

            with AcqContext do AfficherSegmentVisu(numS+1,i1,i2-1);

            i1:=i2;
          end;

          if FlagStop2 then fini:=true;
        end;

      {Tmultigraph(DacMultigraph).formG.drawBM;}

      AcqContext.RefreshMGrects;

      doneGraphic;
      {popCriticalVar;}
      affdebug('Fin DoAffImmediat ',3);
    end;

  inc(cnt);
end;

{Méthode appelée en stimulation visuelle}

procedure TthreadAff.DoAffVS(index:integer);
var
  i1,i2,deb,fin,numS:integer;

begin
  iTcont2:=Index;

  i1:=ITcont1;

  if itcont2<acqinf.Qnbpt
    then i2:=itcont2
    else i2:=acqinf.Qnbpt;

  if i1>=i2 then exit;

  with AcqContext.AcqBM do initGraphic(canvas,0,0,width,height);
  with AcqContext do AfficherSegmentVisu(1,i1,i2-1);

  AcqContext.RefreshMGrects;
  doneGraphic;

  iTcont1:=iTcont2;
end;


{Méthode synchronisée en mode affichage normal}
procedure TthreadAff.DoAff1;
var
  i:integer;
begin

  with acqContext do
  begin
    {pushCriticalVar;}
    with AcqBM do initGraphic(canvas,0,0,width,height);
    if not Fhold OR FlagRefresh
      then resetWindows;
    FlagRefresh:=false;
    setOrigins(debSeq);
    panelSeq.caption:=Istr(numseq0+numSeq+1);
    panelSeq.update;

    AfficherSegment(debSeq,finSeq0);
    lastSeq:=numSeq;
    Tmultigraph(DacMultigraph).formG.drawBM;
    doneGraphic;
  end;
end;

procedure TthreadAff.DoAffNormal;
var
  i1:integer;
  cnt:integer;
begin
  with acqContext do
  if Fdisplay then
    begin
      cnt:=0;
      i1:=ITcont1;
      while i1<itCont2 do
      begin
        inc(cnt);
        numSeq:=I1 div nbpt+1;
        debSeq:=(numSeq-1)*nbpt;
        finSeq0:=numSeq*nbpt-1;

        if (numSeq<>lastSeq) and (finSeq0<=ITcont2) and (cnt=1)
          then synchronize(doAff1);

        i1:=finSeq0+1;

        {affdebug('DoAffNormal '+Istr(i1)+' '+Istr(itCont2)+' '+Istr(finseq0));}
      end;
    end;

end;


procedure TthreadAff.execute;
begin
  repeat
    iTcont2:=MainBufIndex;
//    Affdebug('ITcont1='+Istr1(ITcont1,8)+'  ITcont2= '+Istr1(ITcont2,8) ,79);
    if itcont2>itcont1 then
      begin
        if Fimmediate
          then synchronize(DoAffImmediat)
          else DoAffNormal;
        iTcont1:=iTcont2;
      end;

    synchronize(DisplayTime);

    if FlagStopPanic then FlagStop2:=true;
    if not FlagStop2
      then eventAff.waitFor(10000)
      else terminate;
  until terminated ;

  postMessage(formStm.handle,msg_EndAcq1,2,0);
end;





Initialization
AffDebug('Initialization Daffac1',0);
eventAff:=Tevent.create(nil,false,false,'');

end.
