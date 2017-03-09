unit stmMultiRev1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,sysutils,forms,classes,graphics,
     util1,Dgraphic,Gdos,dtf0,tbe0,listG,
     Stmdef,stmObj,
     Dpalette,
     stmObv0,stmMvtX1,
     stmVec1,stmAve1,stmMat1,stmOdat2,stmPsth1,stmPstA1,stmAveA1,
     varconf1,syspal32,
     debug0,
     NcDef2,stmPg,
     stmMList,
     D7random1;


type
  TseqElt = record
                X,Y,Z,FP: byte;
                NumDt:smallint;
                tt:integer;
              end;

  TmultiRev=  class(TonOff)
              protected
                DtOns:array[0..19] of integer;
                DTmesure:float;            {Duree de cycle mesurée en millisecondes }

                CurT,nextT:integer;        { Date de Début du cycle courant et du cycle suivant }
                function sequenceInstalled:boolean;virtual;


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

                dtN:integer;

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;
                procedure setChildNames;override;

                procedure CalculeCentre(place:TseqElt;var ic,jc:float);
                procedure CalculeCentre1(x,y:integer;var ic,jc:single);
                procedure CalculeCentre2(x,y:float;var ic,jc:float);
                procedure randSequence;virtual;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure setVisiFlags(obOn:boolean);override;
                procedure doneMvt; override;


                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                procedure afficheC;override;
                procedure afficheS;override;

                function getInfo:AnsiString;override;

                procedure setSeed(x:integer);virtual;
                function getSeed:integer;virtual;
                Property seed:integer read getSeed write setSeed;

                procedure installSequence(seed1,nbDivX1,nbDivY1,expansion1,scotome1,DtN1:integer);
                function InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;
                procedure DetectTimes(vec:Tvector;x1,x2,th,linhib:float;Fup:boolean);
                procedure InstallFP(vec:Tvector);

                procedure initPsth(var1,var2:TpsthArray;source:Tvector;x1,x2,deltaX:float);virtual;
                procedure calculatePsth(var1,var2:TpsthArray;source:Tvector;numT:integer);virtual;

                procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);virtual;
                procedure calculatePstw(var1,var2:TaverageArray;source:Tvector;numT:integer);virtual;

                procedure BuildSignal(var1,var2:TvectorArray;vec:Tvector;numT:integer);
                procedure Display;override;
                function Plotable:boolean;override;

                function cycleTime(i:integer):integer;
                procedure getMlist(Mlist: TmatList);
                procedure BuildRevMask(mat:Tmatrix;Xpos,Ypos:Tvector);
              end;



procedure proTmultiRev_create(var pu:typeUO);pascal;
procedure proTmultiRev_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTmultiRev_setRF(num:integer;var pu:typeUO);pascal;

procedure proTmultiRev_divXcount(ww:integer;var pu:typeUO);pascal;
function fonctionTmultiRev_divXcount(var pu:typeUO):integer;pascal;

procedure proTmultiRev_divYcount(ww:integer;var pu:typeUO);pascal;
function fonctionTmultiRev_divYcount(var pu:typeUO):integer;pascal;

procedure proTmultiRev_Lum1(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_Lum1(var pu:typeUO):float;pascal;

procedure proTmultiRev_Lum2(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_Lum2(var pu:typeUO):float;pascal;

procedure proTmultiRev_expansion(ww:integer;var pu:typeUO);pascal;
function fonctionTmultiRev_expansion(var pu:typeUO):integer;pascal;

procedure proTmultiRev_scotome(ww:integer;var pu:typeUO);pascal;
function fonctionTmultiRev_scotome(var pu:typeUO):integer;pascal;

procedure proTmultiRev_Seed(ww:integer;var pu:typeUO);pascal;
function fonctionTmultiRev_Seed(var pu:typeUO):integer;pascal;

procedure proTmultiRev_AdjustObjectSize(ww:boolean;var pu:typeUO); pascal;
function fonctionTmultiRev_AdjustObjectSize(var pu:typeUO):boolean; pascal;

function fonctionTmultiRev_Xcount(var pu:typeUO):integer;pascal;
function fonctionTmultiRev_Ycount(var pu:typeUO):integer;pascal;

procedure proTmultiRev_updateSequence(var pu:typeUO);pascal;

procedure proTmultiRev_RFx(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_RFx(var pu:typeUO):float;pascal;

procedure proTmultiRev_RFy(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_RFy(var pu:typeUO):float;pascal;

procedure proTmultiRev_RFdx(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_RFdx(var pu:typeUO):float;pascal;

procedure proTmultiRev_RFdy(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_RFdy(var pu:typeUO):float;pascal;

procedure proTmultiRev_RFtheta(ww:float;var pu:typeUO);pascal;
function fonctionTmultiRev_RFtheta(var pu:typeUO):float;pascal;



procedure proTmultiRev_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome,DtN1:integer;
                                    var pu:typeUO);pascal;

function fonctionTmultiRev_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO): boolean;pascal;
function fonctionTmultiRev_installTimes_1(var vecEvt:Tvector;dx:float;NoError:boolean; var pu:typeUO): boolean;pascal;

procedure proTmultiRev_installFP(var vec:Tvector;var pu:typeUO);pascal;

function fonctionTmultiRev_PosCount(var pu:typeUO):longint;pascal;

function fonctionTmultiRev_Xpos(i:integer;var pu:typeUO):integer;pascal;
procedure proTmultiRev_Xpos(i,w:integer;var pu:typeUO);pascal;

function fonctionTmultiRev_Ypos(i:integer;var pu:typeUO):integer;pascal;
procedure proTmultiRev_Ypos(i,w:integer;var pu:typeUO);pascal;

function fonctionTmultiRev_Zpos(i:integer;var pu:typeUO):integer;pascal;
procedure proTmultiRev_Zpos(i,w:integer;var pu:typeUO);pascal;

function fonctionTmultiRev_Tpos(i:integer;var pu:typeUO):integer;pascal;
procedure proTmultiRev_Tpos(i,w:integer;var pu:typeUO);pascal;


procedure proTmultiRev_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                              x1,x2,deltaX:float;var pu:typeUO);pascal;
procedure proTmultiRev_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;numT:integer;
                                   var pu:typeUO);pascal;

procedure proTmultiRev_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                              x1,x2:float;var pu:typeUO);pascal;
procedure proTmultiRev_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;numT:integer;
                                   var pu:typeUO);pascal;

function fonctionTmultiRev_CycleTime(i:integer;var pu:typeUO):float;pascal;

procedure proTmultiRev_DetectTimes(var vec:Tvector;x1,x2,th,linhib:float;Fup:boolean;var pu:typeUO);pascal;


procedure proTmultiRev_DtOns(i:integer;w:float;var pu:typeUO);pascal;
function fonctionTmultiRev_DtOns(i:integer;var pu:typeUO):float;pascal;

procedure proTmultiRev_getMlist(var Mlist: TmatList;var pu:typeUO);pascal;

procedure proTmultiRev_BuildSignal(var var1,var2:TvectorArray;var vec:Tvector;numT:integer;var pu:typeUO);pascal;
procedure proTmultiRev_BuildSimMask(var mat:Tmatrix;var Xpos,Ypos:Tvector;var pu:typeUO);pascal;

implementation



{*********************   Méthodes de TmultiRev  *************************}

constructor TmultiRev.create;
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

    dtN:=5;
    for i:=0 to 19 do DtOns[i]:=8;
  end;


destructor TmultiRev.destroy;
begin
  inherited destroy;

end;

class function TmultiRev.STMClassName:AnsiString;
  begin
    STMClassName:='MultiRev';
  end;

procedure TmultiRev.setChildNames;
begin
end;

procedure TmultiRev.CalculeCentre(place:TseqElt;var ic,jc:float);
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

procedure TmultiRev.CalculeCentre1(x,y:integer;var ic,jc:single);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((x-nX/2 + 0.5) * RFdeg.dX) / nbDivX;
    y0 := ((y-nY/2 + 0.5) * RFdeg.dY) / nbDivY;
    DegRotationR(x0,y0,xc,yc,0,0,RFdeg.theta);
    ic:=xc+RFdeg.x;
    jc:=yc+RFdeg.y;
  end;

procedure TmultiRev.CalculeCentre2(x,y:float;var ic,jc:float);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((x-nX/2 -1) * RFdeg.dX) / nbDivX;
    y0 := ((y-nY/2 -1) * RFdeg.dY) / nbDivY;
    DegRotationR(x0,y0,xc,yc,0,0,RFdeg.theta);
    ic:=xc+RFdeg.x;
    jc:=yc+RFdeg.y;
  end;


procedure TmultiRev.RandSequence;
var
  seq0:TseqElt;
  i, j, k,t: integer;
  nbtot:integer;

begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
  XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
  YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
  YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

  setLength(sequence,nx*ny*2*DtN); {longueur max}

  nbtot:=0;
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  for k:=0 to 1 do
  for t:=0 to DtN-1 do
    if (Scotome = 0) or ((i<Xinf) or (i>Xsup)) and ((j<Yinf) or (j>Ysup)) then
    begin
      with sequence[nbtot] do
      begin
        x:=i;
        y:=j;
        z:=k;
        FP:=1;
        NumDt:=t;
      end;
      inc(nbtot);
    end;
  setLength(sequence,nbtot); {longueur vraie}

  cycleCount:=length(sequence);

  GsetRandSeed(seed0);
  for i:= 0 to NbTot-1 do
  begin
    j:=Grandom(nbtot);
    swapmem(sequence[i],sequence[j],sizeof(TseqElt));         { swap sequences i et j }
  end;

  tend:=0;
  for i:=0 to high(sequence) do
  with sequence[i] do
  begin
    tt:=tend;
    tend:=tend+DtOns[NumDt]+dtOff;
  end;
  tend:=tend+torg;
end;



procedure TmultiRev.InitMvt;
var
  i:integer;
begin
  SortSyncPulse;
  index:=0;

  RandSequence;

  curT:=0;
  if length(sequence)>0 then nextT:=sequence[1].tt;

  obvis.deg.theta:=RFdeg.theta;

  if AdjustObjectSize then
    begin
      obvis.deg.dx:=RFdeg.dx /nbDivX;
      obvis.deg.dy:=RFdeg.dy /nbDivY;
    end;

  obvis.deg.lum:=lum[1];

  obvisA[1]:=obvis;

  obvisA[2]:=Tresizable(obvis.clone(false));
  obvisA[2].ident:='Clone';
  obvisA[2].deg.lum:=lum[2];

end;

procedure TmultiRev.initObvis;
begin
  obvisA[1].prepareS;
  obvisA[2].prepareS;
end;


procedure TmultiRev.calculeMvt;
var
  ic,jc:float;
begin
  obvisA[1].FlagonScreen:=false;
  obvisA[2].FlagonScreen:=false;

  obvisA[1].FlagonControl:=false;
  obvisA[2].FlagonControl:=false;


  if (timeS>=nextT) then
  begin
    inc(Index);
    if index>=cycleCount then exit;

    curT:=nextT;
    if index<cycleCount-1
      then nextT:=sequence[index+1].tt
      else nextT:=tEnd-torg;
  end;

  calculeCentre(Sequence[Index],ic,jc);

  obvis:=obvisA[Sequence[Index].Z+1];
  obvis.deg.x:=ic;
  obvis.deg.y:=jc;
end;

procedure TmultiRev.setVisiFlags(obOn: boolean);
var
  tCycle:integer;
begin
  if index>=cycleCount then exit;
  tCycle:=timeS -curT;

  if assigned(obvis) and affStim  then
    with sequence[index] do
    begin
      if (tcycle<dtOns[NumDt])
        then obvis.FlagonScreen:=true;
      if tcycle=0 then FtopSync:=true;
    end;

  if assigned(obvis) and affControl then
    with sequence[index] do
    if tcycle<dtOns[numDt]
      then obvis.FlagonControl:=true;
end;


procedure TmultiRev.doneMvt;
begin
  obvisA[2].free;
  obvis:=obvisA[1];
end;


procedure TmultiRev.buildInfo(var conf:TblocConf;lecture,tout:boolean);
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
      setVarConf('DtOns',DtOns,sizeof(DtOns));
      setVarConf('DtN',DtN,sizeof(DtN));
    end;

  end;

function TmultiRev.getInfo:AnsiString;
var
  i:integer;
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
          'AdjustObjectSize='+Bstr(AdjustObjectSize)+CRLF+
          'DtN=       '+Istr(DtN) +CRLF+
          'DtOns =    ';

  if DtN>20 then DtN:=20;
  for i:=0 to DtN-1 do result:=result+' '+Istr(DtOns[i]);
end;

procedure TmultiRev.CompleteLoadInfo;
begin
  CheckOldIdent;
  randSequence;
  majPos;
end;


procedure TmultiRev.afficheC;
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
      pen.color:=clBlue;
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


procedure TmultiRev.afficheS;
begin

end;

procedure TmultiRev.setSeed(x:integer);
begin
  seed0:=x;
end;

function TmultiRev.getSeed:integer;
begin
  result:=seed0;
end;


{Deux procédures d'initialisation indispensables }

procedure TmultiRev.installSequence(seed1, nbdivX1, nbdivY1, expansion1, scotome1,DtN1: integer);
begin
  seed:=seed1;
  nbDivX:=nbdivX1;
  nbDivY:=nbdivY1;
  expansion:=expansion1;
  scotome:=scotome1;

  DtN:=DtN1;

  randSequence;
end;

function TmultiRev.InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;
var
  i:integer;
begin
  if (cycleCount=0) then
  begin
    stE:='TmultiRev: sequence not installed';
    result:=false;
    exit;
  end;

  dxEvt:=dx;
  setLength(EvtTimes,vec.ICount);
  for i:=vec.Istart to vec.Iend do
    EvtTimes[i-vec.Istart]:=roundL(vec.Yvalue[i]/dxEvt);

  result:= vec.Icount=cycleCount;
  if not result then stE:='TmultiRev: installTimes failed'; 
end;

procedure TmultiRev.DetectTimes(vec:Tvector;x1,x2,th,linhib:float;Fup:boolean);
var
  i,i1,i2:integer;
  w1,w:float;
  dlinhib:integer;
begin
  if (cycleCount=0)
      then sortieErreur('TmultiRev: sequence not installed');

  dxEvt:=vec.dxu;
  setLength(EvtTimes,0);

  i1:=vec.invConvX(x1);
  if i1<vec.Istart then i1:=vec.Istart;
  i2:=vec.invConvX(x2);
  if i2>vec.Iend then i2:=vec.Iend;

  i:=i1;
  w1:=vec.data.getE(i);
  dlinhib:=vec.invConvX(lInhib)-vec.invConvX(0);

  repeat
     inc(i);
     w:=vec.data.getE(i);
     if Fup and (w1<th) and (w>=th) then
       begin
         setLength(EvtTimes,length(EvtTimes)+1);
         EvtTimes[high(EvtTimes)]:=i;
         inc(i,dlinhib);
       end
     else
     if not Fup and (w1>=th) and (w<th) then
       begin
         setLength(EvtTimes,length(EvtTimes)+1);
         EvtTimes[high(EvtTimes)]:=i;
         inc(i,dlinhib);
       end;
     w1:=w;
  until i>=i2;

  if length(EvtTimes)<>cycleCount
      then sortieErreur('TmultiRev: DetectTimes failed');;

end;


procedure TmultiRev.InstallFP(vec:Tvector);
var
  i:integer;
begin
  for i:=0 to cycleCount-1 do
    sequence[i].fp:=vec.Jvalue[i+vec.Istart];
end;



{ Calcul des PSTW }

procedure TmultiRev.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
var
  i,i1,i2:integer;
  pstw:array[1..2] of TaverageArray;
  tp:typetypeG;
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


procedure TmultiRev.calculatePstw(var1,var2:TaverageArray;source:Tvector;numT:integer);
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
  if not sequenceInstalled then exit;

  for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      with sequence[i] do
      begin
        vv:=pstw[z+1].average(x+1,y+1);
        if assigned(vv) then
        begin
          if (fp>0) and (NumDt=numT) then vv.addEx(source,t)
        end
        else sortieErreur('TmultiRev.calculatePstw : invalid average object ');
      end;
    end;

end;

{ Calcul des Psths }

procedure TmultiRev.initPsth(var1, var2: TpsthArray; source: Tvector; x1,x2,deltaX: float);
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


procedure TmultiRev.calculatePsth(var1, var2: TpsthArray; source: Tvector;numT:integer);
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
  if not sequenceInstalled then exit;

  for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      with sequence[i] do
      begin
        vv:=psth[z+1].psths(x+1,y+1);
        if assigned(vv) then
        begin
          if (FP>0) and (numDt=NumT) then vv.addEx(source,t);
        end
        else sortieErreur('TmultiRev.calculatePsth : invalid psth object ');
      end;
    end;

end;

procedure TmultiRev.BuildSignal(var1,var2:TvectorArray;vec:Tvector;numT:integer);
var
  i,j:integer;
  pstw:array[1..2] of TvectorArray;
  vv:Tvector;
  ttt,tmax:float;
  j0:integer;

begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  if not sequenceInstalled then exit;

  tmax:=EvtTimes[cycleCount-1]*DxEvt+pstw[1].Xend;

  vec.X0u:=0;
  vec.Dxu:=pstw[1].dxu;
  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);

  for i:=0 to cycleCount-1 do
  with sequence[i] do
  if numDT=numT then
  begin
    vv:=Pstw[z+1][x+1,y+1];
    ttt:=evtTimes[i]*Dxevt;
    j0:=vec.invconvx(ttt);
    for j:=0 to vv.Iend do
    vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
  end;
end;


function TmultiRev.sequenceInstalled: boolean;
begin
  result:=(cycleCount>0) and (length(EvtTimes)=cycleCount) and (length(sequence)=cycleCount);
end;



procedure TmultiRev.Display;
var
  x,y,dx,dy:integer;
  deg:typeDegre;
  poly:typePoly5R;
  d12x,d12y:float;
  d14x,d14y:float;
  i:integer;

begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  deg:=RFdeg;

  deg.dx:=RFdeg.dx*nx/nbDivX;
  deg.dy:=RFdeg.dy*ny/nbDivY;

  degToPolyR(deg,poly);

  d12x:=(poly[2].x-poly[1].x)/nx;
  d12y:=(poly[2].y-poly[1].y)/ny;

  d14x:=(poly[4].x-poly[1].x)/nx;
  d14y:=(poly[4].y-poly[1].y)/ny;


  with canvasGlb do
  begin
    pen.Color:=Dcolor;
    pen.width:=DlineWidth;

    i:=0;
    while i<=nx do
    begin
      moveto(convWx(poly[1].x+i*d12x) ,convWy(poly[1].y+i*d12y));
      lineto(convWx(poly[4].x+i*d12x) ,convWy(poly[4].y+i*d12y));
      inc(i);
    end;

    i:=0;
    while i<=ny do
    begin
      moveto(convWx(poly[1].x+i*d14x) ,convWy(poly[1].y+i*d14y));
      lineto(convWx(poly[2].x+i*d14x) ,convWy(poly[2].y+i*d14y));
      inc(i);
    end;
  end;
end;

function TmultiRev.Plotable:boolean;
begin
  result:=true;
end;

function TmultiRev.cycleTime(i:integer):integer;
begin
  result:=sequence[i].tt;
end;

procedure TmultiRev.getMlist(Mlist: TmatList);
var
  mat:Tmatrix;
  i:integer;
begin
  Mlist.clear;
  mat:=Tmatrix.create;
  try
  mat.initTemp(1,Nx,1,Ny,G_short);


  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    mat.clear;
    if z=0
      then mat.Zvalue[x+1,y+1]:=-1
      else mat.Zvalue[x+1,y+1]:=1;

    Mlist.AddMatrix(mat);
  end;

  finally
  mat.free;
  end;
end;


{ RevMask est une matrice ayant les dimensions de l'écran de stimulation

  On donne à chaque pixel de l'écran un numéro correspondant à la case de la grille
  de stimulation.
  Ce numéro est y+Ny*x+1
}

procedure TmultiRev.BuildRevMask(mat:Tmatrix;Xpos,Ypos:Tvector);
var
  bar:Tbar;
  i,j,k:integer;
  x,y:single;
  xorg,yorg:integer;

begin
  bar:=Tbar.create;
  bar.deg:=RFdeg;
  bar.deg.dx:=RFdeg.dx /nbDivX;
  bar.deg.dy:=RFdeg.dy /nbDivY;
  bar.buildMaskSingle(mat);
  xorg:= (mat.Icount{-2}) div 2;  // -2 pour rester compatible
  yorg:= (mat.Jcount{-2}) div 2;

  bar.free;

  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  Xpos.initTemp1(0,Nx*Ny-1,g_longint);
  Ypos.initTemp1(0,Nx*Ny-1,g_longint);

  k:=0;
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  begin
    calculeCentre1(i,j,x,y);
    Xpos.Rvalue[k]:=degToX(x)-xorg;
    Ypos.Rvalue[k]:=degToY(y)-yorg;
    inc(k);
  end;
end;



{************** Méthodes STM  de TmultiRev *****************************}

procedure proTmultiRev_create(var pu:typeUO);
begin
  createPgObject('',pu,TmultiRev);
end;

procedure proTmultiRev_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TmultiRev);
end;

procedure proTmultiRev_setRF(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(num,1,5);
  TmultiRev(pu).RFdeg:=RFsys[num].deg;
end;

function fonctionTmultiRev_Xcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
    fonctionTmultiRev_Xcount:=roundI(nbDivX*Expansion/100.0);
end;

function fonctionTmultiRev_Ycount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
    fonctionTmultiRev_Ycount:=roundI(nbDivY*Expansion/100.0);
end;

procedure proTmultiRev_divXcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  TmultiRev(pu).nbdivX:=ww;
end;

function fonctionTmultiRev_divXcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTmultiRev_divXcount:=TmultiRev(pu).nbdivX;
end;

procedure proTmultiRev_divYcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  TmultiRev(pu).nbdivY:=ww;
end;

function fonctionTmultiRev_divYcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTmultiRev_divYcount:=TmultiRev(pu).nbdivY;
end;


procedure proTmultiRev_Lum1(ww:float;var pu:typeUO);
begin
verifierObjet(pu);
controleParametre(ww,0,10000);
TmultiRev(pu).lum[1]:=ww;
end;

function fonctionTmultiRev_lum1(var pu:typeUO):float;
begin
verifierObjet(pu);
result:=TmultiRev(pu).lum[1];
end;


procedure proTmultiRev_lum2(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,10000);
  TmultiRev(pu).lum[2]:=ww;
end;

function fonctionTmultiRev_lum2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmultiRev(pu).lum[2];
end;

procedure proTmultiRev_expansion(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,1000);
  TmultiRev(pu).expansion:=ww;
end;

function fonctionTmultiRev_expansion(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTmultiRev_expansion:=TmultiRev(pu).expansion;
end;

procedure proTmultiRev_scotome(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,32000);
  TmultiRev(pu).scotome:=ww;
end;

function fonctionTmultiRev_scotome(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTmultiRev_scotome:=TmultiRev(pu).scotome;
end;

procedure proTmultiRev_Seed(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiRev(pu).Seed:=ww;
end;

function fonctionTmultiRev_Seed(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTmultiRev_Seed:=TmultiRev(pu).seed;
end;

procedure proTmultiRev_AdjustObjectSize(ww:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiRev(pu).AdjustObjectSize:=ww;
end;

function fonctionTmultiRev_AdjustObjectSize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTmultiRev_AdjustObjectSize:=TmultiRev(pu).AdjustObjectSize;
end;

procedure proTmultiRev_updateSequence(var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do randSequence;
end;

procedure proTmultiRev_RFx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  if RFdeg.x<>ww then RFdeg.x:=ww;
end;

function fonctionTmultiRev_RFx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTmultiRev_RFx:=TmultiRev(pu).RFdeg.x;
end;

procedure proTmultiRev_RFy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  if RFdeg.y<>ww then RFdeg.y:=ww;
end;

function fonctionTmultiRev_RFy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTmultiRev_RFy:=TmultiRev(pu).RFdeg.y;
end;

procedure proTmultiRev_RFdx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with TmultiRev(pu) do
  if RFdeg.dx<>ww then RFdeg.dx:=ww;
end;

function fonctionTmultiRev_RFdx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTmultiRev_RFdx:=TmultiRev(pu).RFdeg.dx;
end;

procedure proTmultiRev_RFdy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with TmultiRev(pu) do
  if RFdeg.dy<>ww then RFdeg.dy:=ww;
end;

function fonctionTmultiRev_RFdy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTmultiRev_RFdy:=TmultiRev(pu).RFdeg.dy;
end;

procedure proTmultiRev_RFtheta(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  if RFdeg.theta<>ww then RFdeg.theta:=ww;
end;

function fonctionTmultiRev_RFtheta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTmultiRev_RFtheta:=TmultiRev(pu).RFdeg.theta;
end;


procedure proTmultiRev_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome,DtN1:integer;
                                            var pu:typeUO);
begin
  verifierObjet(typeUO(pu));

  if (nbDivX<1) or (nbDivX>10000) then sortieErreur('InstallStimSeq : Nx out of range ('+Istr(nbDivX)+')');
  if (nbDivY<1) or (nbDivY>10000) then sortieErreur('InstallStimSeq : Ny out of range ('+Istr(nbDivY)+')');
  if (expansion<1) or (expansion>10000) then sortieErreur('InstallStimSeq : expansion out of range ('+Istr(expansion)+')');
  if (scotome<0) or (scotome>100) then sortieErreur('InstallStimSeq : scotome out of range ('+Istr(scotome)+')');
  if (DtN1<0) or (DtN1>20) then sortieErreur('InstallStimSeq : Ndt out of range ('+Istr(DtN1)+')');

  TmultiRev(pu).installSequence(seed,nbDivX,nbDivY,expansion,scotome,DtN1);
end;

procedure proTmultiRev_DtOns(i:integer;w:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  if (i<1) or (i>20) then sortieErreur('TmultiRev.DtOns : index out of range');
  with TmultiRev(pu) do
    DtOns[i-1]:=roundL(w/Tfreq*1E6);
end;

function fonctionTmultiRev_DtOns(i:integer;var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  if (i<1) or (i>20) then sortieErreur('TmultiRev.DtOns : index out of range');
  with TmultiRev(pu) do
    result:=DtOns[i-1]*Tfreq/1E6;
end;


function fonctionTmultirev_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO): boolean;
begin
  result:= fonctionTmultirev_installTimes_1(vecEvt , dx, false,pu);
end;

function fonctionTmultirev_installTimes_1(var vecEvt:Tvector;dx:float;NoError:boolean; var pu:typeUO): boolean;
var
  stE:string;
begin
  verifierObjet(typeUO(pu));
  verifierVecteur(vecEvt);
  with Tmultirev(pu) do
    result:= InstallTimes(vecEvt,dx,stE);

  if not result and not NoError then sortieErreur(stE);
end;


procedure proTmultiRev_installFP(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TmultiRev(pu) do
  begin
    if (CycleCount=0) or (vec.Icount<CycleCount)
      then sortieErreur('TmultiRev: stim. sequence not installed');
    InstallFP(vec);
  end;
end;




function fonctionTmultiRev_PosCount(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do result:=CycleCount;
end;

function fonctionTmultiRev_Xpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    result:=sequence[i-1].x+1;
  end;
end;

procedure proTmultiRev_Xpos(i,w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    sequence[i-1].x:=w-1;
  end;
end;


function fonctionTmultiRev_Ypos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    result:=sequence[i-1].y+1;
  end;
end;

procedure proTmultiRev_Ypos(i,w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    sequence[i-1].y:=w-1;
  end;
end;


function fonctionTmultiRev_Zpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    result:=sequence[i-1].z+1;
  end;
end;

procedure proTmultiRev_Zpos(i,w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    sequence[i-1].Z:=w-1;
  end;
end;

function fonctionTmultiRev_Tpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    result:=sequence[i-1].NumDt+1;
  end;
end;

procedure proTmultiRev_Tpos(i,w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    sequence[i-1].NumDt:=w-1;
  end;
end;

procedure proTmultiRev_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                                      x1,x2,deltaX:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  if deltaX<=0 then sortieErreur('TmultiRev.initPsth : invalid binWidth');
  if x2<x1 then sortieErreur('TmultiRev.initPsth : invalid psth bounds');


  with TmultiRev(pu) do initPsth(v1,v2,source,x1,x2,deltaX);
end;

procedure proTmultiRev_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;numT:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do calculatePsth(v1,v2,source,numT);
end;

procedure proTmultiRev_BuildSignal(var var1,var2:TvectorArray;var vec:Tvector;numT:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(var1));
  verifierObjet(typeUO(var2));
  verifierVecteur(vec);
  TmultiRev(pu).BuildSignal(var1,var2,vec,numT );
end;

procedure proTmultiRev_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  with TmultiRev(pu) do initPstw(v1,v2,source,x1,x2);
end;

procedure proTmultiRev_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;numT:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiRev(pu) do calculatePstw(v1,v2, source,numT);
end;

function fonctionTmultiRev_CycleTime(i:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TmultiRev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('TmultiRev: sequence index out of range');
    result:=CycleTime(i-1)*Tfreq/1E6;
  end;
end;

procedure proTmultiRev_DetectTimes(var vec:Tvector;x1,x2,th,linhib:float;Fup:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with TmultiRev(pu) do
  begin
    DetectTimes(vec,x1,x2,th,linhib,Fup);
  end;
end;

procedure proTmultiRev_getMlist(var Mlist: TmatList;var pu:typeUO);
begin
  verifierObjet(pu);

  with TmultiRev(pu) do
    getMlist(Mlist);
end;

procedure proTmultiRev_BuildSimMask(var mat:Tmatrix;var Xpos,Ypos:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);

  TmultiRev(pu).BuildRevMask(mat,Xpos,Ypos);
end;


Initialization
AffDebug('Initialization stmMultiRev1',0);

registerObject(TmultiRev,stim);

end.
