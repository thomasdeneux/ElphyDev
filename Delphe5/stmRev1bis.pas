unit stmRev1bis;           N'est pas utilisée

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,
     util1,Dgraphic,Gdos,dtf0,tbe0,
     Stmdef,stmObj,
     Dpalette,
     stmObv0,stmMvtX1,
     stmVec1,stmAve1,stmMat1,stmOdat2,stmPsth1,stmPstA1,stmAveA1,
     varconf1,syspal32,
     editCont,defForm,selRF1,getRev1,
     debug0,
     NcDef2,stmPg,
     {NumToolsMatrix,}
     MtxVec,
     D7random1;


type
  TseqElt = record
                X,Y,Z,FP: byte;  { 0 à n-1 }
              end;

  TKPrecord= record
               index:integer;
               value:single;
             end;

  Trevcor=    class(TonOff)
              private
                KPdt:float;
                KPnbtau,KPnbt:integer;
                KPline:integer;
                KP:array of array of TKPrecord;
                KPvec:array of array of single;

                DTmesure:float;            {Duree de cycle mesurée en millisecondes }
              public
                nbDivX, nbDivY:integer;    { nb Divisions pour paver RF }
                lum:array[1..2] of single; { num luminance pour les 2 contrastes }
                expansion:integer;         { on pave un certain % du RF }
                scotome:integer;           { on peut exclure une partie du RF }
                RFDeg: TypeDegre;          { reçoit un RF système }
                Seed0: word;               { seed pour fonction Random }
                AdjustObjectSize:boolean;  { initialiser la taille de l'objet }
                index: integer;            { numéro du cycle courant }
                Sequence: Array of TseqElt;

                nX,nY:integer;             { nb div effectifs en tenant compte de
                                             expansion et scotome }
                XInf,XSup,YInf,YSup : integer;
                                           { coo du scotome }

                obvisA:array[1..2] of Tresizable;


                EvtTimes:array of integer;
                dxEvt:double;             { Param d'échelle pour les dates evt }

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure CalculeCentre(place:TseqElt;var ic,jc:float);
                procedure randSequence;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;


                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                procedure selectRF;
                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;
                procedure afficheC;override;
                procedure afficheS;override;

                function getInfo:AnsiString;override;

                procedure setSeed(x:integer);virtual;
                function getSeed:integer;virtual;
                Property seed:integer read getSeed write setSeed;

                procedure installSequence(seed1,nbDivX1,nbDivY1,expansion1,scotome1:integer);
                procedure InstallTimes(vec:Tvector;dx:float);
                function CorrectTimes(nb:integer):boolean;
                procedure InstallFP(vec:Tvector);

                procedure initPsth(var1,var2:TpsthArray;source:Tvector;x1,x2,deltaX:float);
                procedure calculatePsth(var1,var2:TpsthArray;source:Tvector);

                procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
                procedure calculatePstw(var1,var2:TaverageArray;source:Tvector);

                function encode(x,y,z:integer):integer;          {x,y,z et code commencent à zéro}
                procedure decode(code:integer;var x,y,z:integer);
                function EltCode(Elt:TseqElt):integer;

                function getX(code:integer):integer;
                function getY(code:integer):integer;
                function getZ(code:integer):integer;
                procedure getMatXYZ(mat1, mat2: Tmatrix);
                procedure getCodes(vec: Tvector;num:integer);

                procedure initPstw2(nbpt,nbtau:integer);
                procedure calculatePstw2(source:Tvector);
                procedure DonePstw2(var1,var2:TvectorArray);

              end;



procedure proTrevCor_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTrevcor_setRF(num:integer;var pu:typeUO);pascal;

procedure proTrevcor_divXcount(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_divXcount(var pu:typeUO):integer;pascal;

procedure proTrevcor_divYcount(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_divYcount(var pu:typeUO):integer;pascal;

procedure proTrevcor_Lum1(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_Lum1(var pu:typeUO):float;pascal;

procedure proTrevcor_Lum2(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_Lum2(var pu:typeUO):float;pascal;

procedure proTrevcor_expansion(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_expansion(var pu:typeUO):integer;pascal;

procedure proTrevcor_scotome(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_scotome(var pu:typeUO):integer;pascal;

procedure proTrevcor_Seed(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_Seed(var pu:typeUO):integer;pascal;

procedure proTrevcor_AdjustObjectSize(ww:boolean;var pu:typeUO); pascal;
function fonctionTrevcor_AdjustObjectSize(var pu:typeUO):boolean; pascal;

function fonctionTrevcor_Xcount(var pu:typeUO):integer;pascal;
function fonctionTrevcor_Ycount(var pu:typeUO):integer;pascal;

procedure proTrevcor_updateSequence(var pu:typeUO);pascal;

procedure proTrevcor_RFx(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFx(var pu:typeUO):float;pascal;

procedure proTrevcor_RFy(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFy(var pu:typeUO):float;pascal;

procedure proTrevcor_RFdx(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFdx(var pu:typeUO):float;pascal;

procedure proTrevcor_RFdy(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFdy(var pu:typeUO):float;pascal;

procedure proTrevcor_RFtheta(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFtheta(var pu:typeUO):float;pascal;



procedure proTrevcor_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome:integer;
                                    var pu:typeUO);pascal;
procedure proTrevcor_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO);pascal;
procedure proTrevcor_installFP(var vec:Tvector;var pu:typeUO);pascal;

function fonctionTrevcor_PosCount(var pu:typeUO):longint;pascal;

function fonctionTrevcor_Codes(i:integer;var pu:typeUO):integer;pascal;
function fonctionTrevcor_Xpos(i:integer;var pu:typeUO):integer;pascal;
function fonctionTrevcor_Ypos(i:integer;var pu:typeUO):integer;pascal;
function fonctionTrevcor_Zpos(i:integer;var pu:typeUO):integer;pascal;

function fonctionTrevcor_encode(x,y,z:integer;var pu:typeUO):integer;pascal;
procedure proTrevcor_decode(code:integer;var x,y,z:integer;var pu:typeUO);pascal;

procedure proTrevcor_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                              x1,x2,deltaX:float;var pu:typeUO);pascal;
procedure proTrevcor_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;
                                   var pu:typeUO);pascal;

procedure proTrevcor_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                              x1,x2:float;var pu:typeUO);pascal;
procedure proTrevcor_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;
                                   var pu:typeUO);pascal;

procedure proTrevcor_getMatXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);pascal;
procedure proTrevcor_getCodes(var vec: Tvector;num:integer;var pu:typeUO);pascal;

procedure proTrevcor_initPstw2(nbpt,nbtau:integer;var pu:typeUO);pascal;
procedure proTrevcor_calculatePstw2(var source:Tvector;var pu:typeUO);pascal;
procedure proTrevcor_DonePstw2(var var1,var2:TvectorArray;var pu:typeUO);pascal;

implementation



{*********************   Méthodes de TRevCOR  *************************}

constructor TRevCOR.create;
  var
    i,j:integer;
  begin
    inherited create;
    nbDivX:=5;
    nbDivY:=5;
    lum[1]:=25;
    lum[2]:=0;
    expansion:=100;
    scotome:=0;
    dureeC:=10;
    RFDeg:=degNul;
    Seed:=0;

  end;


destructor Trevcor.destroy;
begin
  inherited destroy;
end;

class function Trevcor.STMClassName:AnsiString;
  begin
    STMClassName:='Revcor';
  end;


procedure TrevCor.CalculeCentre(place:TseqElt;var ic,jc:float);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((place.x-nX/2 + 0.5) * RFdeg.dX) / nbDivX;
    y0 := ((place.y-nY/2 + 0.5) * RFdeg.dY) / nbDivY;
    DegRotationR(x0,y0,xc,yc,0,0,RFdeg.theta);
    ic:=xc+RFdeg.x;
    jc:=yc+RFdeg.y;
  end;

procedure TrevCor.RandSequence;
var
  MemoMat : array of array of array of boolean;
  i, j, k: integer;
  nbtot:integer;

begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);
  setLength(MemoMat,2,nx,ny);

  GsetRandSeed(Seed);

  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  for k:=0 to 1 do
    memoMat[k,i,j]:=false;

  Nbtot :=nx*ny*2;

  XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
  XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
  YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
  YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

  if (Scotome <> 0) then
    for i:= XInf to XSup do
      for j:= YInf to YSup do
        for k:=0 to 1 do
          begin
            MemoMat[k,i,j]:=TRUE;
            dec(NbTot);
          end;

  setLength(sequence,nbTot);
  cycleCount:=length(sequence);

  for i:= 0 to NbTot-2 do
    with sequence[i] do
    begin
      repeat
         X := Grandom(nX);
         Y := Grandom(nY);
         Z := Grandom(2);
         FP:=1;
      until (MemoMat[Z,X,Y] = FALSE);
      MemoMat[Z,X,Y] := TRUE;
    end;

  for i:=0 to nX-1 do
    for j:=0 to nY-1 do
      for k:=0 to 1 do
        if MemoMat[k,i,j]=FALSE then
          with sequence[nbTot-1] do
          begin
            X:= i;
            Y:= j;
            Z:= k;
            FP:=1;
            exit;
          end;
end;



procedure TRevCOR.InitMvt;
  begin
    {inc(seed0);}
    index:=-1;

    RandSequence;

    obvis.deg.theta:=RFdeg.theta;

    if AdjustObjectSize then
      begin
        obvis.deg.dx:=RFdeg.dx /nbDivX;
        obvis.deg.dy:=RFdeg.dy /nbDivY;
      end;

    obvis.deg.lum:=lum[1];

    CycleCount:=length(sequence);

    with TimeMan do tend:=torg+dureeC*nbCycle;


    obvisA[1]:=obvis;

    obvisA[2]:=Tresizable(obvis.clone(false));
    obvisA[2].ident:='Clone';
    obvisA[2].deg.lum:=lum[2];
  end;

procedure TrevCor.initObvis;
begin
  obvisA[1].prepareS;
  obvisA[2].prepareS;
end;


procedure TRevCOR.calculeMvt;
  var
    tcycle:longint;
    i,j:integer;
    ic,jc:float;
  begin
    obvisA[1].FonScreen:=false;
    obvisA[2].FonScreen:=false;

    obvisA[1].FonControl:=false;
    obvisA[2].FonControl:=false;

    tCycle:=timeS mod dureeC;
    if (tCycle=0) and (timeS < cycleCount*dureeC) then inc(Index);
    if index>cycleCount then exit;

    calculeCentre(Sequence[Index],ic,jc);

    obvis:=obvisA[Sequence[Index].Z+1];
    obvis.deg.x:=ic;
    obvis.deg.y:=jc;
  end;

procedure Trevcor.doneMvt;
begin

  obvisA[2].free;
  obvis:=obvisA[1];
end;


procedure Trevcor.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      setVarConf('nbDivX',nbDivX,sizeof(nbDivX));
      setVarConf('nbDivY',nbDivY,sizeof(nbDivY));
      setVarConf('Lum',lum,sizeof(lum));
      setVarConf('expansion',expansion,sizeof(expansion));
      setVarConf('scotome',scotome,sizeof(scotome));
      setVarConf('RFdeg',RFdeg,sizeof(RFdeg));
      setVarConf('seed',Seed0,sizeof(Seed0));
      setVarConf('ADjustSize',AdjustObjectSize,sizeof(AdjustObjectSize));
    end;

  end;

function Trevcor.getInfo:AnsiString;
begin
  result:=inherited getInfo+CRLF+
          'nbDivX=    '+Istr(nbDivX)+CRLF+
          'nbDivY=    '+Istr(nbDivY)+CRLF+
          'lum1=      '+Estr(lum[1],3)+CRLF+
          'lum2=      '+Estr(lum[2],3)+CRLF+
          'Expansion= '+Istr(expansion)+CRLF+
          'Scotome=   '+Istr(scotome)+CRLF+
          'RF.x=      '+Estr1(RFdeg.x,10,3)+CRLF+
          'RF.y=      '+Estr1(RFdeg.y,10,3)+CRLF+
          'RF.dx=     '+Estr1(RFdeg.dx,10,3)+CRLF+
          'RF.dy=     '+Estr1(RFdeg.dy,10,3)+CRLF+
          'RF.theta=  '+Estr1(RFdeg.theta,10,3)+CRLF+
          'Seed=      '+Istr(seed)+CRLF+
          'AdjustObjectSize='+Bstr(AdjustObjectSize)+CRLF;
end;

procedure Trevcor.CompleteLoadInfo;
begin
  CheckOldIdent;
  randSequence;
  majPos;
end;

procedure Trevcor.selectRF;
var
  res:integer;
begin
  res:=FormselectRF.showModal;
  if res>100 then
    begin
      RFdeg:=RFsys[res-100].deg;
      majpos;
    end;
end;

function Trevcor.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetRevCor1;
end;

procedure Trevcor.installDialog(var form:Tgenform;var newF:boolean);
begin
    installForm(form,newF);

    with TgetRevcor1(form) do
    begin
      enDelay.setVar(timeMan.tOrg,T_longInt);
      enDelay.setMinMax(0,maxEntierLong);
      enDelay.Dxu:=Tfreq/1E6;

      enDtON.setVar(timeMan.dtON,T_longInt);
      enDtON.setMinMax(0,maxEntierLong);
      enDtON.Dxu:=Tfreq/1E6;

      enDtOff.setVar(timeMan.dtOff,T_longInt);
      enDtOff.setMinMax(0,maxEntierLong);
      enDtOff.Dxu:=Tfreq/1E6;

      enCycleCount.setVar(timeMan.nbCycle,T_longInt);
      enCycleCount.setMinMax(0,maxEntierLong);

      enDivX.setVar(nbDivX,T_smallint);
      enDivX.setMinMax(1,32000);

      enDivY.setVar(nbDivY,T_smallint);
      enDivY.setMinMax(1,32000);

      enDivY.setVar(nbDivY,T_smallint);
      enDivY.setMinMax(1,32000);

      enLum1.setVar(lum[1],T_single);
      enLum1.setMinMax(0,10000);

      enLum2.setVar(lum[2],T_single);
      enLum2.setMinMax(0,10000);

      enExpansion.setVar(Expansion,T_smallint);
      enExpansion.setMinMax(1,32000);

      enScotome.setVar(Scotome,T_smallint);
      enScotome.setMinMax(0,32000);

      selectRFD:=SelectRF;

      enSeed.setVar(seed0,T_smallint);
      CBadjust.setvar(adjustObjectSize);

      onControlD:=DisplayOnControl;   {Ces procédures doivent être mises en place}
      onScreenD:=DisplayOnScreen;     {AVANT de modifier checked }

      CbOnControl.checked:=onControl;
      CbOnScreen.checked:=onScreen;

      initCBvisual(self,typeUO(obvis));
    end;
end;



procedure Trevcor.afficheC;
  var
    x,y,dx,dy:integer;
    deg:typeDegre;
    poly,polyAff:typePoly5;
    d12x,d12y:float;
    d14x,d14y:float;
    i:integer;

  begin
    nX := roundI(nbDivX*Expansion/100.0);
    nY := roundI(nbDivY*Expansion/100.0);

    deg:=RFdeg;
    deg.dx:=RFdeg.dx*nx/nbDivX;
    deg.dy:=RFdeg.dy*ny/nbDivY;

    degToPolyAff(deg,polyAff);

    d12x:=(polyAff[2].x-polyAff[1].x)/nx;
    d12y:=(polyAff[2].y-polyAff[1].y)/ny;

    d14x:=(polyAff[4].x-polyAff[1].x)/nx;
    d14y:=(polyAff[4].y-polyAff[1].y)/ny;


    with canvasGlb do
    begin
        selectDPaletteHandle(handle);
        pen.color:=pgBlue;
        i:=0;
        while i<=nx do
        begin
          moveto(polyAff[1].x+round(i*d12x) ,polyAff[1].y+round(i*d12y));
          lineto(polyAff[4].x+round(i*d12x) ,polyAff[4].y+round(i*d12y));
          inc(i);
        end;

        i:=0;
        while i<=ny do
        begin
          moveto(polyAff[1].x+round(i*d14x) ,polyAff[1].y+round(i*d14y));
          lineto(polyAff[2].x+round(i*d14x) ,polyAff[2].y+round(i*d14y));
          inc(i);
        end;
    end;
  end;

procedure Trevcor.afficheS;
  var
    x,y,dx,dy:integer;
    deg:typeDegre;
    poly:typePoly5;
    d12x,d12y:float;
    d14x,d14y:float;
    i:integer;

  begin
    if (DXscreen=nil) or (DXscreen.ddraw=nil) then exit;

    nX := roundI(nbDivX*Expansion/100.0);
    nY := roundI(nbDivY*Expansion/100.0);

    deg:=RFdeg;

    deg.dx:=RFdeg.dx*nx/nbDivX;
    deg.dy:=RFdeg.dy*ny/nbDivY;

    degToPoly(deg,poly);

    d12x:=(poly[2].x-poly[1].x)/nx;
    d12y:=(poly[2].y-poly[1].y)/ny;

    d14x:=(poly[4].x-poly[1].x)/nx;
    d14y:=(poly[4].y-poly[1].y)/ny;


    with DXscreen,surface do
    begin
      try
      with canvas do
      begin
        pen.Color:=rgb(0,253,0);
        i:=0;
        while i<=nx do
        begin
          moveto(poly[1].x+round(i*d12x) ,poly[1].y+round(i*d12y));
          lineto(poly[4].x+round(i*d12x) ,poly[4].y+round(i*d12y));
          inc(i);
        end;

        i:=0;
        while i<=ny do
        begin
          moveto(poly[1].x+round(i*d14x) ,poly[1].y+round(i*d14y));
          lineto(poly[2].x+round(i*d14x) ,poly[2].y+round(i*d14y));
          inc(i);
        end;
      end;
      finally
      Canvas.release;
      end;
    end;
  end;

procedure Trevcor.setSeed(x:integer);
begin
  seed0:=x;
end;

function Trevcor.getSeed:integer;
begin
  result:=seed0;
end;


{Deux procédures d'initialisation indispensables }

procedure Trevcor.installSequence(seed1, nbdivX1, nbdivY1, expansion1, scotome1: integer);
begin
  seed:=seed1;
  nbDivX:=nbdivX1;
  nbDivY:=nbdivY1;
  expansion:=expansion1;
  scotome:=scotome1;

  randSequence;
end;

procedure Trevcor.InstallTimes(vec:Tvector;dx:float);
var
  i:integer;
begin
  if vec.Icount>cycleCount then exit;

  dxEvt:=dx;
  setLength(EvtTimes,cycleCount);
  for i:=vec.Istart to vec.Iend do
    EvtTimes[i-vec.Istart]:=roundL(vec.Yvalue[i]/dxEvt);

  if vec.Icount<cycleCount then correctTimes(vec.Icount);
  DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])*DxEvt/(cycleCount-1);
end;

function Trevcor.CorrectTimes(nb:integer):boolean;
var
  i,cnt:integer;
  dt,delta:float;
begin
  dt:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);

  cnt:=0;
  for i:=0 to nb-2 do
  if abs(EvtTimes[i+1]-EvtTimes[i]-dt)>dt/2 then
  begin
    move(EvtTimes[i],EvtTimes[i+1],sizeof(EvtTimes[0])*(cycleCount-i-1));
    EvtTimes[i]:=EvtTimes[i]+round(dt);
    inc(cnt);
  end;
  result:=(cnt=cycleCount-nb);
end;

procedure Trevcor.InstallFP(vec:Tvector);
var
  i:integer;
begin
  for i:=0 to cycleCount-1 do
    sequence[i].fp:=vec.Jvalue[i-vec.Istart];
end;



{ Calcul des PSTW }

procedure TrevCor.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
var
  i,i1,i2:integer;
  pstw:array[1..2] of TaverageArray;
begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  for i:=1 to 2 do
    begin
      pstw[i].initarray(1,nx,1,ny);
      pstw[i].initAverages(i1,i2,g_single);
      pstw[i].dxu:=source.dxu;

      pstw[i].clear;
    end;
end;


procedure TrevCor.calculatePstw(var1,var2:TaverageArray;source:Tvector);
var
  i:integer;
  t:double;
  vv:Taverage;
  pstw:array[1..2] of TaverageArray;
begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  for i:=1 to 2 do
    if not assigned(pstw[i])  then exit;
  if (length(EvtTimes)<>cycleCount) or (length(sequence)<>cycleCount) then exit;

  for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      with sequence[i] do
      begin
        vv:=pstw[z+1].average(x+1,y+1);
        if assigned(vv) then
        begin
          if fp>0 then vv.addEx(source,t)
        end
        else sortieErreur('TrevCor.calculatePstw : invalid average object ');
      end;
    end;

end;

{ Calcul des Psths }

procedure Trevcor.initPsth(var1, var2: TpsthArray; source: Tvector; x1,x2,deltaX: float);
var
  i,i1,i2:integer;
  psth:array[1..2] of TpsthArray;
begin
  psth[1]:=var1;
  psth[2]:=var2;

  i1:=roundL(x1/deltaX);
  i2:=roundL(x2/deltaX);

  for i:=1 to 2 do
    begin
      psth[i].initarray(1,nx,1,ny);
      psth[i].initPsths(i1,i2,g_longint,deltaX);
      psth[i].clear;
    end;
end;


procedure Trevcor.calculatePsth(var1, var2: TpsthArray; source: Tvector);
var
  i:integer;
  t:double;
  vv:Tpsth;
  psth:array[1..2] of TpsthArray;
begin
  psth[1]:=var1;
  psth[2]:=var2;

  for i:=1 to 2 do
    if not assigned(psth[i])  then exit;
  if (length(EvtTimes)<>cycleCount) or (length(sequence)<>cycleCount) then exit;

  for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      with sequence[i] do
      begin
        vv:=psth[z+1].psths(x+1,y+1);
        if assigned(vv) then
        begin
          if FP>0 then vv.addEx(source,t);
        end
        else sortieErreur('TrevCor.calculatePsth : invalid psth object ');
      end;
    end;

end;

{ Codage et décodage: x,y et z commencent à zéro
  Le code est z+nz*(y+ny*x)  , il commence aussi à zéro
}


procedure TrevCor.decode(code:integer;var x,y,z:integer);
begin
  z:=code mod 2;
  code:=(code-z) div 2;
  y:=code mod ny;
  x:=(code-y) div ny;
end;

function TrevCor.encode(x,y,z:integer):integer;
begin
  result:=z+2*(y+ny*x);
end;

function Trevcor.EltCode(Elt: TseqElt): integer;
begin
  with Elt do result:=encode(x,y,z);
end;


function TrevCor.getX(code:integer):integer;
var
  x,y,z:integer;
begin
  z:=code mod 2;
  code:=(code-z) div 2;
  y:=code mod ny;
  result:=(code-y) div ny;
end;

function TrevCor.getY(code:integer):integer;
var
  x,y,z:integer;
begin
  z:=code mod 2;
  code:=(code-z) div 2;
  result:=code mod ny;
end;

function TrevCor.getZ(code:integer):integer;
var
  x,y,z:integer;
begin
  result:=code mod 2;
end;



procedure Trevcor.getMatXYZ(mat1, mat2: Tmatrix);
var
  i:integer;
  x,y,z:integer;
begin
  if not assigned(mat1) or not assigned(mat2) then exit;
  if cycleCount<=0 then exit;
  if (length(EvtTimes)<>cycleCount) or (length(sequence)<>cycleCount) then exit;

  mat1.initTemp(1,nx,1,ny,g_longint);
  mat2.initTemp(1,nx,1,ny,g_longint);

  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    if z=0
      then mat1.Kvalue[x+1,y+1]:=EvtTimes[i]
      else mat2.Kvalue[x+1,y+1]:=EvtTimes[i];
  end;
end;

procedure Trevcor.getCodes(vec: Tvector;num:integer);
var
  i,cc:integer;
begin
  if not assigned(vec)  then exit;
  if cycleCount<=0 then exit;
  if (length(EvtTimes)<>cycleCount) or (length(sequence)<>cycleCount) then exit;

  vec.modify(g_longint,0,nx*ny*2-1);

  for i:=0 to cycleCount-1 do
  begin
    with sequence[i] do cc:=encode(x,y,z);

    if (i+num>=0) and (i+num<=cycleCount-1)
      then with sequence[i+num] do vec.Jvalue[cc]:=encode(x,y,z)
      else vec.Jvalue[cc]:=-1;
  end;
end;


procedure Trevcor.initPstw2(nbPt,nbtau:integer);
var
  i:integer;
begin
  KPdt:=DTmesure/nbpt;
  KPnbtau:=nbtau;
  KPnbt:=nbPt;

  setLength(KP,0,0);
  setLength(KPvec,0,0);

  KPline:=0;
end;

procedure Trevcor.calculatePstw2(source:Tvector);
var
  i,j,k:integer;
  N:integer;

function KPcode(i,tau:integer):integer;
begin
  result:=tau*cycleCount+ eltCode(sequence[i]);
  {Donne un nombre compris entre 0 et cycleCount*KPnbtau-1  }
end;

begin
  N:=length(KP);

  setLength(KP,N+cycleCount,KPnbtau);
  setLength(KPvec,N+cycleCount,KPnbt);

  for i:=N to N+cyclecount-1 do
  begin
    for j:=0 to KPnbtau-1 do
      KP[i,j].index:=-1;
    for j:=0 to KPnbt-1 do
      KPvec[i,j]:=0;
  end;

  N:=N+cycleCount;

  for i:=0 to cycleCount-1 do
  begin
    for k:=0 to KPnbtau-1 do
    begin
      if (i-k>=0) and (i-k<cycleCount) then
        with KP[KPline,k] do
        begin
          index:=KPcode(i-k,k);
          value:=1;
        end
        else
        with KP[KPline,k] do
        begin
          index:=-1;
          value:=0;
        end;
      for j:=0 to KPnbt-1 do
        KPvec[KPline,j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt];
    end;
    inc(KPline);
  end;
end;


procedure Trevcor.DonePstw2(var1,var2:TvectorArray);
var
  i1,i2:integer;
  i,j,k,x,y,z,tau:integer;
  pstw:array[1..2] of TvectorArray;
  vecSol:TypeDataS;
  error:byte;
  KPcode:integer;

  matX:TmtX;
  BX,XX:Tmtx;
  N:integer;

begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  i1:=0;
  i2:=KPnbtau*KPnbt-1;

  for i:=1 to 2 do
    begin
      pstw[i].initarray(1,nx,1,ny);
      pstw[i].initvectors(i1,i2,g_single);
      pstw[i].dxu:=KPdt;
    end;

(*
  matX:=Tmtx.create;
  N:=cycleCount*KPnbtau;
  matX.Size(KPline,N,false);

  BX:=Tmtx.Create;
  BX.Size(KPline,KPnbt);
  XX:=Tmtx.Create;
  XX.Size(N,KPnbt);

  for i:=0 to KPline-1 do
  for j:=0 to KPnbtau-1 do
  with KP[i,j] do
    if index>=0 then
    matX[i,index]:=value;

  setLength(KP,0,0);

  for i:=0 to KPline-1 do
  for j:=0 to KPnbt-1 do
      BX[i,j]:=KPvec[i,j];


  matX.LQRSolve(BX,XX);
*)
  matX:=Tmtx.create;
  N:=cycleCount*KPnbtau;
  matX.Size(N,N,false);

  BX:=Tmtx.Create;
  BX.Size(N,KPnbt);
  XX:=Tmtx.Create;
  XX.Size(N,KPnbt);

  for i:=0 to N-1 do
  for j:=0 to KPnbtau-1 do
  with KP[i,j] do
    if index>=0 then
    matX[i,index]:=value;

  setLength(KP,0,0);

  for i:=0 to N-1 do
  for j:=0 to KPnbt-1 do
      BX[i,j]:=KPvec[i,j];


  matX.LUSolve(BX,XX);

  for i:=0 to KPnbt-1 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for z:=0 to 1 do
  for tau:=0 to KPnbtau-1 do
  begin
    KPcode:=tau*cycleCount+ encode(x,y,z);
    Pstw[z+1].vector(x+1,y+1).Yvalue[i +KPnbt*tau]:=XX[KPcode,i];
  end;


  matX.Free;
  BX.free;
  XX.free;

end;




{************** Méthodes STM  de Trevcor *****************************}

procedure proTrevcor_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Trevcor);
end;

procedure proTrevcor_setRF(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(num,1,5);
  Trevcor(pu).RFdeg:=RFsys[num].deg;
end;

function fonctionTrevcor_Xcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
    fonctionTrevcor_Xcount:=roundI(nbDivX*Expansion/100.0);
end;

function fonctionTrevcor_Ycount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
    fonctionTrevcor_Ycount:=roundI(nbDivY*Expansion/100.0);
end;

procedure proTrevcor_divXcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  Trevcor(pu).nbdivX:=ww;
end;

function fonctionTrevcor_divXcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_divXcount:=Trevcor(pu).nbdivX;
end;

procedure proTrevcor_divYcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  Trevcor(pu).nbdivY:=ww;
end;

function fonctionTrevcor_divYcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_divYcount:=Trevcor(pu).nbdivY;
end;


procedure proTrevcor_Lum1(ww:float;var pu:typeUO);
begin
verifierObjet(pu);
controleParametre(ww,0,10000);
Trevcor(pu).lum[1]:=ww;
end;

function fonctionTrevcor_lum1(var pu:typeUO):float;
begin
verifierObjet(pu);
result:=Trevcor(pu).lum[1];
end;


procedure proTrevcor_lum2(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,10000);
  Trevcor(pu).lum[2]:=ww;
end;

function fonctionTrevcor_lum2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Trevcor(pu).lum[2];
end;

procedure proTrevcor_expansion(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,1000);
  Trevcor(pu).expansion:=ww;
end;

function fonctionTrevcor_expansion(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_expansion:=Trevcor(pu).expansion;
end;

procedure proTrevcor_scotome(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,32000);
  Trevcor(pu).scotome:=ww;
end;

function fonctionTrevcor_scotome(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_scotome:=Trevcor(pu).scotome;
end;

procedure proTrevcor_Seed(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).Seed:=ww;
end;

function fonctionTrevcor_Seed(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_Seed:=Trevcor(pu).seed;
end;

procedure proTrevcor_AdjustObjectSize(ww:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).AdjustObjectSize:=ww;
end;

function fonctionTrevcor_AdjustObjectSize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTrevcor_AdjustObjectSize:=Trevcor(pu).AdjustObjectSize;
end;

procedure proTrevcor_updateSequence(var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do randSequence;
end;

procedure proTrevcor_RFx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  if RFdeg.x<>ww then RFdeg.x:=ww;
end;

function fonctionTrevcor_RFx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFx:=Trevcor(pu).RFdeg.x;
end;

procedure proTrevcor_RFy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  if RFdeg.y<>ww then RFdeg.y:=ww;
end;

function fonctionTrevcor_RFy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFy:=Trevcor(pu).RFdeg.y;
end;

procedure proTrevcor_RFdx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with Trevcor(pu) do
  if RFdeg.dx<>ww then RFdeg.dx:=ww;
end;

function fonctionTrevcor_RFdx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFdx:=Trevcor(pu).RFdeg.dx;
end;

procedure proTrevcor_RFdy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with Trevcor(pu) do
  if RFdeg.dy<>ww then RFdeg.dy:=ww;
end;

function fonctionTrevcor_RFdy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFdy:=Trevcor(pu).RFdeg.dy;
end;

procedure proTrevcor_RFtheta(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  if RFdeg.theta<>ww then RFdeg.theta:=ww;
end;

function fonctionTrevcor_RFtheta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFtheta:=Trevcor(pu).RFdeg.theta;
end;


procedure proTrevCor_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome:integer;
                                            var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TrevCor(pu).installSequence(seed,nbDivX,nbDivY,expansion,scotome);
end;


procedure proTrevcor_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with Trevcor(pu) do
  begin
    if (CycleCount=0) or (vecEvt.Icount<CycleCount)
      then sortieErreur('Trevcor: stim. sequence not installed');
    InstallTimes(vecEvt,dx);
  end;
end;

procedure proTrevcor_installFP(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with Trevcor(pu) do
  begin
    if (CycleCount=0) or (vec.Icount<CycleCount)
      then sortieErreur('Trevcor: stim. sequence not installed');
    InstallFP(vec);
  end;
end;




function fonctionTrevcor_PosCount(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with Trevcor(pu) do result:=CycleCount;
end;

function fonctionTrevcor_Codes(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=EltCode(sequence[i-1]);
  end;
end;

function fonctionTrevcor_Xpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=sequence[i-1].x+1;
  end;
end;

function fonctionTrevcor_Ypos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=sequence[i-1].y+1;
  end;
end;

function fonctionTrevcor_Zpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=sequence[i-1].z+1;
  end;
end;


function fonctionTrevcor_encode(x,y,z:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    result:=encode(x-1,y-1,z-1);
  end;
end;

procedure proTrevcor_decode(code:integer;var x,y,z:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    decode(code,x,y,z);
    inc(x);
    inc(y);
    inc(z);
  end;
end;


procedure proTrevcor_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                                      x1,x2,deltaX:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  if deltaX<=0 then sortieErreur('Trevcor.initPsth : invalid binWidth');
  if x2<x1 then sortieErreur('Trevcor.initPsth : invalid psth bounds');


  with Trevcor(pu) do initPsth(v1,v2,source,x1,x2,deltaX);
end;

procedure proTrevcor_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do calculatePsth(v1,v2,source);
end;


procedure proTrevcor_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  with Trevcor(pu) do initPstw(v1,v2,source,x1,x2);
end;

procedure proTrevcor_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do calculatePstw(v1,v2, source);
end;



procedure proTrevcor_getMatXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat1));
  verifierObjet(typeUO(mat2));

  Trevcor(pu).getMatXYZ(mat1,mat2);
end;

procedure proTrevcor_getCodes(var vec: Tvector;num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));

  Trevcor(pu).getCodes(vec,num);
end;

procedure proTrevcor_initPstw2(nbpt,nbtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  Trevcor(pu).initPstw2(nbpt,nbtau);
end;

procedure proTrevcor_calculatePstw2(var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);
  Trevcor(pu).calculatePstw2(source);
end;

procedure proTrevcor_DonePstw2(var var1,var2:TvectorArray;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(var1));
  verifierObjet(typeUO(var2));


  Trevcor(pu).DonePstw2(var1,var2);
end;



end.
