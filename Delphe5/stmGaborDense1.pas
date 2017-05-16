unit stmGaborDense1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette,debug0,
     stmDef,stmObj,stmobv0,stmRev1,varconf1,Ncdef2,
     defForm,selRF1,editcont,
     getMseq1,syspal32,
     stmgrid1,
     stmvec1,stmMat1,stmOdat2,stmPsth1,stmPstA1,
     stmPg,stmError,
     Rarray1,listG,
     matrix0,chrono0,gratDX1,
     stmexe11,stmExe10,stmISPL1,stmgrid2,
     Gnoise1, VlistA1,
     stmAve1,stmAveA1,
     stmMlist,
     ipps17;


const
  LqrModeMax=3;

type
  TGaborNoiseInfo=
    record
      NoiseModel:integer;   {0 = modèle initial }
                            {sinon autre modèle. Permet de sauver l'information}
      preSim:integer;       { 0: stimulation aléatoire}
                            { 1: préstimulation avec gabors en phase }
                            { 2: préstimulation avec phases aléatoires }
      Overlap:boolean;      { autorise le recouvrement }

      ExtensionX,ExtensionY:double;    {1 par défaut.
                                          Multiplie les dimensions d'un gabor }
      AttenuationX,AttenuationY:double;{1 par défaut.
                                          Multiplie l' atténuation standard d'un gabor }
      Period,Phase,Contrast:double;
      LumInc,PeriodInc,PhaseInc,OrientInc:double;
      LumCount,PeriodCount,PhaseCount,OrientCount:integer;
      Fblank:boolean;
    end;


  TGaborNoise=class(Trevcor)

              protected
                GBinfo:TgaborNoiseInfo;

                noise:TgridNoise;      { TBBnoise1 est identique au bruit initial }


                nbGabor:integer;      {nbGabor=EOrientCount*EPeriodCount*ELumCount*EPhaseCount +ord(Fblank) }
                obvisuel:array of TLGabor;{}
                grid:Tgrid;
                grid2:TVSgrid;

                LqrMode:integer;       {0 Cas général. On n'accèdera qu'aux différences.
                                        1 Les phases opposées donnent des réponses opposées
                                        2 Les orientations opposées donnent des réponses opposées
                                        3 Combine 1 et 2
                                        }
                LqrLumCount,LqrPeriodCount,LqrPhaseCount,LqrOrientCount:integer;

                FuserModel:boolean;   { User changed the model }

                procedure initObvisuel;

                procedure setSeed(x:integer);override;
                procedure randSequence;override;
                function sequenceInstalled:boolean;override;

              public
                Property NoiseModel:integer read GBinfo.NoiseModel write GBinfo.NoiseModel;
                Property preSim:integer read GBinfo.preSim write GBinfo.preSim;
                Property Overlap:boolean read GBinfo.Overlap write GBinfo.Overlap;
                Property ExtensionX:double read GBinfo.ExtensionX write GBinfo.ExtensionX;
                Property ExtensionY:double read GBinfo.ExtensionY write GBinfo.ExtensionY;
                Property AttenuationX:double read GBinfo.AttenuationX write GBinfo.AttenuationX;
                Property AttenuationY:double read GBinfo.AttenuationY write GBinfo.AttenuationY;
                Property Period:double read GBinfo.period write GBinfo.period;
                Property Phase:double read GBinfo.Phase write GBinfo.Phase;
                Property Contrast:double read GBinfo.Contrast write GBinfo.Contrast;
                Property LumInc:double read GBinfo.LumInc write GBinfo.LumInc;
                Property PeriodInc:double read GBinfo.PeriodInc write GBinfo.PeriodInc;
                Property PhaseInc:double read GBinfo.PhaseInc write GBinfo.PhaseInc;
                Property OrientInc:double read GBinfo.OrientInc write GBinfo.OrientInc;
                Property LumCount:integer read GBinfo.LumCount write GBinfo.LumCount;
                Property PeriodCount:integer read GBinfo.PeriodCount write GBinfo.PeriodCount;
                Property PhaseCount:integer read GBinfo.PhaseCount write GBinfo.PhaseCount;
                Property OrientCount:integer read GBinfo.OrientCount write GBinfo.OrientCount;
                Property Fblank:boolean read GBinfo.Fblank write GBinfo.Fblank;

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure setVisiFlags(obOn:boolean);override;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;
                function getInfo:AnsiString;override;

                function Von(x,y:integer):Tresizable;virtual;
                function Von2(x,y:integer):integer;

                function encodeZ(orient1,period1,lum1,phase1:integer):integer;
                procedure decodeZ(code:integer;var orient1,period1,lum1,phase1:integer);

                function LQRencodeZ(orient1,period1,lum1,phase1:integer):integer;
                procedure LQRdecodeZ(code:integer;var orient1,period1,lum1,phase1:integer);

                function LqrNz:integer;override;
                procedure initLqrPstw(source:Tvector;tau1,tau2:integer);override;
                procedure calculateLqrPstw(source:Tvector);override;

                procedure getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);override;

                procedure BuildSignal(pstw:TvectorArray;vec:Tvector);
                procedure BuildSignalSpk(pstw:TvectorArray;vec:Tvector;Nmax:integer);

                procedure BuildSignal1(Vlist:TVlist;vec:Tvector);override;
                procedure BuildSignalSpk1(Vlist:TVlist;vec:Tvector;Nmax:integer);override;

                procedure initPsth(psth:TpsthArray;source:Tvector;x1,x2,deltaX:float);
                procedure calculatePsth(psth:TpsthArray;source:Tvector);

                procedure AddK1(x,y,z:integer);override;
                procedure AddK2(x1a,y1a,z1a,x2a,y2a,z2a,lag:integer);override;
                procedure calculateLqrPstw1(source:Tvector);override;

                procedure initPstw(pstw:TaverageArray;source:Tvector;x1,x2:float);
                procedure calculatePstw(pstw:TaverageArray;source:Tvector);

                procedure initPstw2(pstw:TaverageArray;source:Tvector;x1,x2:float);
                procedure calculatePstw2(pstw:TaverageArray;source:Tvector;dtau:integer);

                procedure encodePstw2(x,y,z,z2,d:integer;var gx,gy:integer);
                procedure decodePstw2(gx,gy:integer;var x,y,z,z2,d:integer);

                procedure getMlist(Mlist:TmatList);override;
                procedure setMlist(Mlist:TmatList);override;

                procedure SinglePstw2(moy: Taverage; source: Tvector;x1,y1,z1,x2,y2,z2,dtau:integer);
                procedure SinglePsth2(psth: Tpsth; source: Tvector;x1,y1,z1,x2,y2,z2,dtau:integer);
              end;


procedure proTGaborNoise_create(name:AnsiString;var pu:typeUO);pascal;

{Fonctions pour traiter le signal acquis avant de le décomposer en noyaux}
procedure proSamplingIntAbove(var source,dest,evenements:TVector;seuil:float);pascal;
procedure proSamplingIntBelow(var source,dest,evenements:TVector;seuil:float);pascal;
procedure proSamplingEnergie1(var source,dest,evenements:TVector;Y0:float);pascal;

{modification des variables de réglages du bruit dense}
procedure proTGaborNoise_Overlap(val:boolean;var pu:typeUO);pascal;
function fonctionTGaborNoise_Overlap(var pu:typeUO):boolean;pascal;
procedure proTGaborNoise_preSim(val:boolean;var pu:typeUO);pascal;
function fonctionTGaborNoise_preSim(var pu:typeUO):boolean;pascal;
procedure proTGaborNoise_extensionx(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_extensionx(var pu:typeUO):double; pascal;
procedure proTGaborNoise_extensiony(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_extensiony(var pu:typeUO):double;pascal;
procedure proTGaborNoise_attenuationx(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_attenuationx(var pu:typeUO):double;pascal;
procedure proTGaborNoise_attenuationy(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_attenuationy(var pu:typeUO):double; pascal;
procedure proTGaborNoise_period(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_period(var pu:typeUO):double; pascal;
procedure proTGaborNoise_phase(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_phase(var pu:typeUO):double; pascal;
procedure proTGaborNoise_contrast(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_contrast(var pu:typeUO):double; pascal;
procedure proTGaborNoise_LumInc(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_LumInc(var pu:typeUO):double;  pascal;
procedure proTGaborNoise_PeriodInc(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_PeriodInc(var pu:typeUO):double;   pascal;
procedure proTGaborNoise_PhaseInc(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_PhaseInc(var pu:typeUO):double;   pascal;
procedure proTGaborNoise_OrientInc(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_OrientInc(var pu:typeUO):double;pascal;
procedure proTGaborNoise_PeriodCount(value:integer;var pu:typeUO); pascal;
function fonctionTGaborNoise_PeriodCount(var pu:typeUO):integer;  pascal;
procedure proTGaborNoise_LumCount(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_LumCount(var pu:typeUO):integer;pascal;
procedure proTGaborNoise_PhaseCount(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_PhaseCount(var pu:typeUO):integer;pascal;
procedure proTGaborNoise_OrientCount(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_OrientCount(var pu:typeUO):integer;pascal;

procedure proTGaborNoise_NoiseModel(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_NoiseModel(var pu:typeUO):integer;pascal;

function fonctionTGaborNoise_State(x,y,t:integer;var pu:typeUO):integer;pascal;
procedure proTGaborNoise_State(x,y,t,w:integer;var pu:typeUO);pascal;

procedure proTGaborNoise_Nvalue(n,value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_Nvalue(n:integer;var pu:typeUO):integer;pascal;



function fonctionTgaborNoise_encodeZ(orient1,period1,lum1,phase1:integer;var pu:typeUO):integer;pascal;
procedure proTgaborNoise_decodeZ(code:integer;var orient1,period1,lum1,phase1:integer;var pu:typeUO);pascal;

function fonctionTgaborNoise_LQRencodeZ(orient1,period1,lum1,phase1:integer;var pu:typeUO):integer;pascal;
procedure proTgaborNoise_LQRdecodeZ(code:integer;var orient1,period1,lum1,phase1:integer;var pu:typeUO);pascal;

procedure proTgaborNoise_BuildSignal(var pstw:TvectorArray;var vec:Tvector;var pu:typeUO);pascal;
procedure proTgaborNoise_BuildSignalSpk(var pstw:TvectorArray;var vec:Tvector;Nmax:integer;var pu:typeUO);pascal;



procedure proTGaborNoise_LqrMode(w:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_LqrMode(var pu:typeUO):integer;pascal;

procedure proTGaborNoise_Blank(w:boolean;var pu:typeUO);pascal;
function fonctionTGaborNoise_Blank(var pu:typeUO):boolean;pascal;

procedure proTGaborNoise_initPsth(var psth:TpsthArray;var source:Tvector;x1,x2,deltaX:float;var pu:typeUO);pascal;
procedure proTGaborNoise_calculatePsth(var psth:TpsthArray;var source:Tvector;var pu:typeUO);pascal;

procedure proTGaborNoise_initPstw(var pstw:TaverageArray;var source:Tvector;x1,x2:float;var pu:typeUO);pascal;
procedure proTGaborNoise_calculatePstw(var pstw:TaverageArray;var source:Tvector;var pu:typeUO);pascal;

procedure proTGaborNoise_initPstw2(var pstw:TaverageArray;var source:Tvector;x1,x2:float;var pu:typeUO);pascal;
procedure proTGaborNoise_calculatePstw2(var pstw:TaverageArray;var source:Tvector;dtau:integer;var pu:typeUO);pascal;

procedure proTGaborNoise_encodePstw2(x,y,z,z2,d:integer;var gx,gy:integer;var pu:typeUO);pascal;
procedure proTGaborNoise_decodePstw2(gx,gy:integer;var x,y,z,z2,d:integer;var pu:typeUO);pascal;

procedure proTGaborNoise_InitSinglePstw2(var mm:Taverage;var source:Tvector;x1,x2:float);pascal;
procedure proTGaborNoise_SinglePstw2(var moy:Taverage;var source:Tvector;x1,y1,z1,x2,y2,z2,dtau:integer;var pu:typeUO);pascal;

procedure proTGaborNoise_InitSinglePsth2(var psth:Tpsth;var source:Tvector;x1,x2,deltaX:float);pascal;
procedure proTGaborNoise_SinglePsth2(var psth:Tpsth;var source:Tvector;x1,y1,z1,x2,y2,z2,dtau:integer;var pu:typeUO);pascal;



implementation


function DeuxPuissance(a:integer) : integer;
begin
  result:=1 shl a;
end;


{*********************   Méthodes de TGaborNoise  *************************}

constructor TGaborNoise.create;
var
  i,j:integer;
begin
  inherited create;

  timeMan.dtOn:=1;

  if not initIPPS then
  begin
    messageCentral('IPPS not installed');
    exit;
  end;

  nbDivX:=8;
  nbDivY:=8;
  expansion:=100;
  dureeC:=10;
  if assigned(rfSys[1])
    then RFDeg:=rfSys[1].deg
    else RFdeg:=degNul;

  grid:=Tgrid.create;
  grid.notpublished:=true;
  grid.Fchild:=true;

  grid2:=TVSgrid.create;
  grid2.notpublished:=true;
  grid2.Fchild:=true;

  CycleCount:=1000;

  with GBinfo do
  begin
    extensionx:=1;
    extensiony:=1;
    attenuationx:=0.2;
    attenuationy:=0.2;
    period:=0.5;
    phase:=0;
    contrast:=0.8;
    LumInc:=0;
    PeriodInc:=0;
    PhaseInc:=0;
    OrientInc:=30;
    LumCount:=1;
    PeriodCount:=1;
    PhaseCount:=1;
    OrientCount:=6;
  end;

  LqrMode:=0;
end;


destructor TGaborNoise.destroy;
var
  i:integer;
begin
  noise.free;
  grid.free;
  grid2.Free;

  inherited destroy;
end;


procedure TGaborNoise.randSequence;
var
  i,j,debut: integer;
begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);
  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  noise.free;
  if NoiseModel=0
    then noise:=TBBnoise1.create(nx,ny,nbGabor,seed,0)
    else noise:=TXYnoise1.create(nx,ny,0,nbGabor-1,seed,cycleCount);

  if (NoiseModel=0) and (GBinfo.preSim=1) then {préstimulation avec les gabors en phase}
    with TBBnoise1(noise) do
    begin
      for i:=0 to nx*ny-1 do
        for j:=0 to pseq-1 do
          BB[i*pseq+j]:=j mod nbGabor;
    end;

  if (NoiseModel=0) and (GBinfo.preSim=2) then {préstimulation avec phases aléatoires}
    begin
      with TBBnoise1(noise) do
      for i:=0 to nx*ny-1 do
        begin
          debut:=random(nbGabor);
          for j:=0 to pseq-1 do
            BB[i*pseq+j]:=(debut+j) mod nbGabor;
        end;
    end;
end;

function TgaborNoise.sequenceInstalled:boolean;
begin
  result:=(cycleCount>0) and (length(EvtTimes)=cycleCount) and
          assigned(noise) and (noise.tmax>=cycleCount);
end;


procedure TGaborNoise.initObvisuel;
const
  rectbloque=true;
var
  i,j,k,l,indiceCourant:integer;
  tailleX,tailleY,attX,attY:double;
  dimension:double;

begin
  dimension:=min(RFdeg.dx/nbDivX,RFdeg.dy/nbDivY);

  tailleX:=extensionx*dimension;
  tailleY:=extensiony*dimension;
  attX:=   attenuationx*dimension;
  attY:=   attenuationy*dimension;

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ 1 {ord(Fblank)};
  setLength(obvisuel,nbGabor);

  for l:=0 to PhaseCount-1 do
  for k:=0 to LumCount-1 do
  for j:=0 to PeriodCount-1 do
  for i:=0 to OrientCount-1 do
  begin
    indiceCourant:=i+j*OrientCount+k*OrientCount*PeriodCount+l*OrientCount*PeriodCount*LumCount;
    obvisuel[indiceCourant]:=TLGabor.create;
    with obvisuel[indiceCourant] do
    begin
      deg.dx:=taillex;
      deg.dy:=tailley;
      Lx:=attx;
      Ly:=atty;
      phase:=self.phase+l*PhaseInc;
      contrast:=self.contrast+k*LumInc;
      periode:=self.period+j*PeriodInc;
      orientation:=i*OrientInc;
     {2 possibilités: on fait bouger le rectangle contenant le gabor avec l'orientation,
      ou on le laisse bloqué et on ne fait varier que l'orientation}
      if rectbloque
        then deg.theta:=RFdeg.theta
        else deg.theta:=i*OrientInc;
    end;
    if Overlap then grid2.addObject(obvisuel[indiceCourant]);
  end;

  obvisuel[nbGabor-1]:=nil;

  if Fblank then
  begin
    if Overlap then grid2.addObject(nil);
  end;

end;

class function TGaborNoise.STMClassName:AnsiString;
  begin
    STMClassName:='GaborNoise';
  end;


procedure TGaborNoise.InitMvt;
var
  i,j:integer;
  deg1:typeDegre;
  dimension:single;
begin
  SortSyncPulse;
  index:=-1;
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  deg1:=RFdeg;
  deg1.dx:=deg1.dx*expansion/100;
  deg1.dy:=deg1.dy*expansion/100;

  if Overlap then
    begin
      grid2.deg:=deg1;
      grid2.initGrid(nx,ny);
    end
  else
    grid.initGrille(deg1,nx,ny);

  obvis.deg.theta:=RFdeg.theta;

  if AdjustObjectSize then
    begin
      obvis.deg.dx:=RFdeg.dx /nbDivX;
      obvis.deg.dy:=RFdeg.dy /nbDivY;
    end;

  obvis.onScreen:=false;
  obvis.onControl:=false;

  obvis.deg.lum:=lum[1];

  dimension:=min(RFdeg.dx/nbDivX,RFdeg.dy/nbDivY);

  initObvisuel;

  if not FuserModel then randSequence;
  with TimeMan do tend:=torg+dureeC*nbCycle;
end;

procedure TGaborNoise.initObvis;
var i:integer;
begin
  if not Overlap then
  begin
    obvis.prepareS;
    for i:=0 to nbGabor-1 do
      if assigned(obvisuel[i])
        then obvisuel[i].prepareS;
  end
  else grid2.prepareS;
end;

function TGaborNoise.Von(x,y:integer):Tresizable;
begin
  result:=obvisuel[noise.getState(x,y,index)];
end;

function TGaborNoise.Von2(x,y:integer):integer;
begin
  result:=noise.getState(x,y,index)+1;
end;

procedure TGaborNoise.calculeMvt;
var
  i,j:integer;
begin
  if (timeS mod dureeC=0)  then inc(Index);

  if index>cycleCount then exit;

  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
      if Overlap
         then grid2.status[i+1,j+1]:=Von2(i,j)
         else grid.obvisA[i,j]:=Von(i,j);
end;

procedure TGaborNoise.doneMvt;
var
  i,j:integer;
begin
  for i:=0 to nbGabor-1 do
    obvisuel[i].Free;

  if Overlap then grid2.resetGrid
  else
    begin
      for i:=0 to nx-1 do
        for j:=0 to ny-1 do
          grid.obvisA[i,j]:=nil;
    end;

  FuserModel:=false;
end;

procedure TGaborNoise.setVisiFlags(obOn:boolean);
begin
  if not Overlap then
  begin
    if assigned(grid) then
    begin
      grid.FlagonScreen:=affStim and ObON;
      grid.FlagonControl:=affControl and ObON;
    end;
  end
  else
  begin
    if assigned(grid2) then
    begin
      grid2.FlagonScreen:=affStim and ObON;
      grid2.FlagonControl:=affControl and ObON;
    end;
  end;
end;

procedure TGaborNoise.buildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    if tout then setvarConf('OBVIS',intG(obvis),sizeof(intG));

    setvarConf('GBinfo',GBinfo,sizeof(GBinfo));
  end;
end;

procedure TGaborNoise.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;

function TgaborNoise.getInfo:AnsiString;
begin
  result:=inherited getInfo+CRLF+
      'NoiseModel=   '+Istr(NoiseModel) +CRLF+
      'PreSim=       '+Istr(Presim)     +CRLF+
      'Overlap=      '+Bstr(Overlap)    +CRLF+
      'ExtensionX=  '+Estr(extensionX,3) +CRLF+
      'ExtensionY=  '+Estr(extensionY,3) +CRLF+
      'AttenuationX='+Estr(attenuationX,3) +CRLF+
      'AttenuationY='+Estr(attenuationY,3) +CRLF+
      'Period=      '+Estr(period,3) +CRLF+
      'Phase=       '+Estr(phase,3) +CRLF+
      'Contrast=    '+Estr(contrast,3) +CRLF+
      'LumInc=      '+Estr(LumInc,3) +CRLF+
      'PeriodInc=   '+Estr(PeriodInc,3) +CRLF+
      'PhaseInc=    '+Estr(PhaseInc,3) +CRLF+
      'OrientInc=   '+Estr(OrientInc,3) +CRLF+
      'LumCount=    '+Istr(LumCount) +CRLF+
      'PeriodCount= '+Istr(PeriodCount) +CRLF+
      'PhaseCount=  '+Istr(PhaseCount) +CRLF+
      'OrientCount= '+Istr(OrientCount) ;
end;

procedure TGaborNoise.setSeed(x:integer);
begin
  inherited setSeed(x);
end;

function TgaborNoise.encodeZ(orient1,period1,lum1,phase1:integer):integer;
begin
  result:=orient1+OrientCount*(period1+PeriodCount*(lum1+LumCount*phase1));
end;

procedure TgaborNoise.decodeZ(code:integer;var orient1,period1,lum1,phase1:integer);
begin
  orient1:=code mod orientCount;
  code:=code div orientCount;

  period1:=code mod periodCount;
  code:=code div periodCount;

  lum1:=code mod lumCount;
  phase1:=code div lumCount;
end;

function TgaborNoise.LQRencodeZ(orient1,period1,lum1,phase1:integer):integer;
begin
  orient1:=orient1 mod LqrOrientCount;
  period1:=period1 mod LqrPeriodCount;
  lum1:=lum1 mod LqrLumCount;
  phase1:=phase1 mod LqrPhaseCount;

  result:=orient1+LqrOrientCount*(period1+LqrPeriodCount*(lum1+LqrLumCount*phase1));
end;

procedure TgaborNoise.LqrdecodeZ(code:integer;var orient1,period1,lum1,phase1:integer);
begin
  orient1:=code mod LqrOrientCount;
  code:=code div LqrOrientCount;

  period1:=code mod LqrPeriodCount;
  code:=code div LqrPeriodCount;

  lum1:=code mod LqrLumCount;
  phase1:=code div LqrLumCount;
end;


function TGaborNoise.LqrNz:integer;
begin
  LqrOrientCount:=OrientCount;
  LqrPeriodCount:=PeriodCount;
  LqrLumCount:=LumCount;
  LqrPhaseCount:=PhaseCount;

  case lqrMode of
    1:  LqrPhaseCount:=PhaseCount div 2;
    2:  LqrOrientCount:=OrientCount div 2;
    3:  begin
          LqrPhaseCount:=PhaseCount div 2;
          LqrOrientCount:=OrientCount div 2;
        end;
  end;

  result:=LqrOrientCount*LqrPeriodCount*LqrLumCount*LqrPhaseCount;
end;

procedure TGaborNoise.initLqrPstw(source:Tvector;tau1,tau2:integer);
begin
  inherited;
  lqrP.fONE:=false;
end;

procedure TGaborNoise.calculateLqrPstw(source:Tvector);
var
  i,j,k:integer;
  x,y,z:integer;
  nz:integer;

  nTau:integer;
  nbpos:integer;

  orient1,period1,lum1,phase1:integer;
  w:integer;
  psth:Tpsth;
begin
  if FlqrPsth then
  begin
    psth:=Tpsth.create;
    psth.initTemp(0,KPnbt,g_longint,KPdt);
  end
  else psth:=nil;

  try

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  ntau:=KPtau2-KPtau1+1;
  nz:=LqrNz;

  for i:=0 to cycleCount-1 do
  begin
    lqrP.ClearMatSline;

    case LqrMode of
      0:for k:=KPtau1 to KPTau2 do   { Cas général }
        begin
          if (i-k>=0) and (i-k<cycleCount) then
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i-k);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              j:=k-KPtau1+ Ntau*(z+nz*(y+ny*x));   {Nombre compris entre 0 et Nc-1  }
              lqrP.matSline[j]:=1;
            end;
          end;
        end;
      1:for k:=KPtau1 to KPTau2 do  { Les phases opposées donnent des réponses opposées}
        begin
          if (i-k>=0) and (i-k<cycleCount) then
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i-k);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              decodeZ(z,orient1,period1,lum1,phase1);
              z:=LqrEncodeZ(orient1,period1,lum1,phase1);
              j:=k-KPtau1+ Ntau*(z+nz*(y+ny*x));   {Nombre compris entre 0 et Nc-1  }
              if phase1<phaseCount div 2
                then lqrP.matSline[j]:=1
                else lqrP.matSline[j]:=-1;
            end;
          end;
        end;

      2:for k:=KPtau1 to KPTau2 do  { Les orientations opposées donnent des réponses opposées }
        begin
          if (i-k>=0) and (i-k<cycleCount) then
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i-k);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              decodeZ(z,orient1,period1,lum1,phase1);
              z:=LqrEncodeZ(orient1,period1,lum1,phase1);
              j:=k-KPtau1+ Ntau*(z+nz*(y+ny*x));   {Nombre compris entre 0 et Nc-1  }
              if orient1<orientCount div 2
                then lqrP.MatSline[j]:=1
                else lqrP.MatSline[j]:=-1;
            end;
          end;
        end;

      3:for k:=KPtau1 to KPTau2 do  { Les orientations opposées donnent des réponses opposées }
        begin                       { Les phases opposées donnent des réponses opposées }
          if (i-k>=0) and (i-k<cycleCount) then
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i-k);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              decodeZ(z,orient1,period1,lum1,phase1);
              z:=LqrEncodeZ(orient1,period1,lum1,phase1);
              j:=k-KPtau1+ Ntau*(z+nz*(y+ny*x));   {Nombre compris entre 0 et Nc-1  }
              if (orient1>=orientCount div 2)
                  XOR
                  (phase1>=phaseCount div 2)
                then lqrP.MatSline[j]:=-1
                else lqrP.MatSline[j]:=1;
            end;
          end;
        end;
    end;

    if not FlqrPsth then
    for j:=0 to KPnbt-1 do
      lqrP.BXline[j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt]
    else
    begin
      psth.clear;
      psth.AddEx(source,EvtTimes[i]*DxEvt);
      for j:=0 to KPnbt-1 do
        lqrP.BXline[j]:=psth.Yvalue[j];
    end;

    lqrP.UpdateHessian;
  end;

  finally
  psth.Free;
  end;
end;

procedure TGaborNoise.AddK1(x,y,z:integer);
var
  w:integer;
  orient1,period1,lum1,phase1:integer;
begin
  x:=x-1;
  y:=y-1;

  w:=x+y shl 8+ z shl 16 ;
  listK1.add(pointer(w));

  LqrNz; {Calcule LqrOrientCount etc.. }
  nbK1bis:=0;

  case LqrMode of
    1:  { Les phases opposées donnent des réponses opposées}
      begin
        LqrDecodeZ(z,orient1,period1,lum1,phase1);
        z:=LqrEncodeZ(orient1,period1,lum1,phase1+phaseCOunt div 2);

        w:=x+y shl 8+ z shl 16 ;
        listK1bis.add(pointer(w));
        listK1bisV.add(pointer(-1));

        nbK1bis:=1;
      end;

    2:  { Les orientations opposées donnent des réponses opposées }
      begin
        LqrDecodeZ(z,orient1,period1,lum1,phase1);
        z:=LqrEncodeZ(orient1+orientCount div 2,period1,lum1,phase1);

        w:=x+y shl 8+ z shl 16 ;
        listK1bis.add(pointer(w));
        listK1bisV.add(pointer(-1));

        nbK1bis:=1;
      end;

    3:  { Les orientations opposées donnent des réponses opposées }
        { Les phases opposées donnent des réponses opposées }
      begin
        LqrDecodeZ(z,orient1,period1,lum1,phase1);

        z:=LqrEncodeZ(orient1+orientCount div 2,period1,lum1,phase1);
        w:=x+y shl 8+ z shl 16 ;
        listK1bis.add(pointer(w));
        listK1bisV.add(pointer(-1));

        z:=LqrEncodeZ(orient1,period1,lum1,phase1+phaseCount div 2);
        w:=x+y shl 8+ z shl 16 ;
        listK1bis.add(pointer(w));
        listK1bisV.add(pointer(-1));

        z:=LqrEncodeZ(orient1+orientCount div 2,period1,lum1,phase1+phaseCount div 2);
        w:=x+y shl 8+ z shl 16 ;
        listK1bis.add(pointer(w));
        listK1bisV.add(pointer(1));

        nbK1bis:=3;
      end;
  end;

end;

procedure TGaborNoise.AddK2(x1a,y1a,z1a,x2a,y2a,z2a,lag:integer);
var
  w:TELtK2;
  orient1,period1,lum1,phase1:integer;
  orient2,period2,lum2,phase2:integer;
begin
  dec(x1a);
  dec(y1a);
  dec(x2a);
  dec(y2a);

  w.x1:=x1a;
  w.y1:=y1a;
  w.z1:=z1a;
  w.t1:=0;
  w.x2:=x2a;
  w.y2:=y2a;
  w.z2:=z2a;
  w.t2:=lag;

  listK2.add(@w);

  nbK2bis:=0;
  case LqrMode of
    1:  { Les phases opposées donnent des réponses opposées}
      begin
        {
        LqrDecodeZ(z1a,orient1,period1,lum1,phase1);
        LqrDecodeZ(z2a,orient2,period2,lum2,phase2);

        w.z1:=LqrEncodeZ(orient1,period1,lum1,phase1+phaseCOunt div 2);
        w.z2:=LqrEncodeZ(orient2,period2,lum2,phase2+phaseCOunt div 2);

        listK2bis.add(w);
        listK2bisV.add(pointer(-1));

        nbK2bis:=1;
        }
      end;

    2:  { Les orientations opposées donnent des réponses opposées }
      begin
      end;

    3:  { Les orientations opposées donnent des réponses opposées }
        { Les phases opposées donnent des réponses opposées }
      begin
      end;
  end;


end;

procedure TgaborNoise.calculateLqrPstw1(source: Tvector);
var
  i,j,k1,k2:integer;
  index:integer;
  w:integer;
  x1,y1,z1,x2,y2,z2:integer;

  nTau:integer;
  nbpos:integer;
  psth:Tpsth;
  flag:boolean;
  w2:TEltK2;
  nbK1,lag,maxLag:integer;
begin
  nTau:=KPtau2-KPtau1+1;
  maxLag:=KPtau2;
  nbK1:=listK1.count*ntau;

  if FlqrPsth then
  begin
    psth:=Tpsth.create;
    psth.initTemp(0,KPnbt,g_longint,KPdt);
  end;

  try

  for i:=0 to cycleCount-1 do
  begin
    lqrP.ClearMatSline;

    flag:=false;

    for k1:=KPtau1 to KPTau2 do
      if (i-k1>=0) and (i-k1<cycleCount) then
      for x1:=0 to nx-1 do
      for y1:=0 to ny-1 do
      begin
        z1:=noise.f(x1,y1,i-k1);
        w:=x1+y1 shl 8+ z1 shl 16 ;
        index:=listK1.IndexOf(pointer(w));
        if index>=0 then
        begin
          lqrP.MatSline[index*ntau+k1-KPtau1]:=1;
          flag:=true;
        end;

        index:=listK1bis.IndexOf(pointer(w));
        if index>=0 then
        begin
          lqrP.MatSline[(index div nbK1bis)*ntau+k1-KPtau1]:=intG(listK1bisV[index]);
          flag:=true;
        end;

        for lag:=0 to maxlag do
          if (i-k1-lag>=0) and (i-k1-lag<cycleCount) then
          for x2:=0 to nx-1 do
          for y2:=0 to ny-1 do
          begin
            z2:=noise.f(x2,y2,i-k1-lag);

            w2.x1:=x1;
            w2.y1:=y1;
            w2.z1:=z1;
            w2.x2:=x2;
            w2.y2:=y2;
            w2.z2:=z2;
            w2.t2:=lag;
            index:=listK2.IndexOf(@w2);
            if index>=0 then
            begin
              lqrP.MatSline[ nbK1 + index*ntau +k1-KPtau1 ]:=1;
              flag:=true;
            end;

            index:=listK2bis.IndexOf(@w2);
            if index>=0 then
            begin
              lqrP.MatSline[ nbK1 + (index div nbK2bis)*ntau +k1-KPtau1 ]:=
                   intG(listK2bisV[index]);
              flag:=true;
            end;
          end;

      end;

    if flag then
    begin
      if not FlqrPsth then
      for j:=0 to KPnbt-1 do
        lqrP.BXline[j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt]
      else
      begin
        psth.clear;
        psth.AddEx(source,EvtTimes[i]*DxEvt);
        for j:=0 to KPnbt-1 do
          lqrP.BXline[j]:=psth.Yvalue[j];
      end;
      lqrP.updateHessian;
    end;
     
  end;

  finally
  if FlqrPsth then psth.Free;
  end;
end;




procedure TGaborNoise.getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);
var
  i1,i2:integer;
  i,j,k,x,y,tau:integer;
  nz:integer;
  KPcode:integer;

  N,Ntau:integer;
  index:integer;
  z1,z2:integer;
begin
  if (z<0) or (z>=LqrNz) then
  begin
    z1:=0;
    z2:=LqrNz-1;
  end
  else
  begin
    z1:=z;
    z2:=z;
  end;

  Ntau:=KPtau2-KPtau1+1;
  if (Ntau<1) or (KPdt<=0) or not assigned(lqrP) then exit;
  nz:=LqrNz;

  i1:=KPtau1*KPnbt;
  i2:=(KPtau2+1)*KPnbt-1;

  pstw.initarray(1,nx,1,ny*(z2-z1+1));
  pstw.initvectors(i1,i2,g_single);
  pstw.dxu:=KPdt;

  for z:=z1 to z2 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    KPcode:=ntau*(z+nz*(y+ny*x));
    lqrP.getVector(KPcode,ntau,Pstw[x+1,y+1+ny*(z-z1)],raw,norm);
  end;

end;



procedure TGaborNoise.BuildSignal(pstw: TvectorArray; vec: Tvector);
var
  i,j:integer;
  vv:Tvector;
  tt,tmax:float;
  x,y,z,j0:integer;
  nbGab1:integer;
  orient1,period1,lum1,phase1:integer;


begin
  if not sequenceInstalled then exit;

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  LqrNz;
  nbGab1:= LqrOrientCount*LqrPeriodCount*LqrLumCount*LqrPhaseCount;

  with pstw do
  if (Imin<>1) or (Imax<>nx) or (Jmin<>1) or (Jmax<>ny*nbGab1) then exit;

  tmax:=EvtTimes[cycleCount-1]*DxEvt+pstw.Xend;

  vec.X0u:=0;
  vec.Dxu:=pstw.dxu;
  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);

  for i:=0 to cycleCount-1 do
  begin
    tt:=EvtTimes[i]*dxEvt;
    j0:=vec.invconvx(tt);

    case LqrMode of
      0:{ Cas général }
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              vv:=pstw[x+1,y+1+ny*z];
              for j:=0 to vv.Iend do
                vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
            end;
          end;
      1:  { Les phases opposées donnent des réponses opposées}
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              decodeZ(z,orient1,period1,lum1,phase1);
              z:=LqrEncodeZ(orient1,period1,lum1,phase1);
              vv:=pstw[x+1,y+1+ny*z];
              for j:=0 to vv.Iend do
                vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]-vv.Yvalue[j];
            end;
          end;

      2:  { Les orientations opposées donnent des réponses opposées }
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              decodeZ(z,orient1,period1,lum1,phase1);
              z:=LqrEncodeZ(orient1,period1,lum1,phase1);
              vv:=pstw[x+1,y+1+ny*z];
              for j:=0 to vv.Iend do
                vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]-vv.Yvalue[j];

            end;
          end;

      3:  { Les orientations opposées donnent des réponses opposées }
          { Les phases opposées donnent des réponses opposées }
          for x:=0 to nx-1 do
          for y:=0 to ny-1 do
          begin
            z:=noise.f(x,y,i);
            if not (Fblank and (z=nbgabor-1)) then
            begin
              decodeZ(z,orient1,period1,lum1,phase1);
              z:=LqrEncodeZ(orient1,period1,lum1,phase1);
              vv:=pstw[x+1,y+1+ny*z];
              if (orient1>=orientCount div 2)
                  XOR
                  (phase1>=phaseCount div 2)
                then
                   for j:=0 to vv.Iend do
                     vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]-vv.Yvalue[j]
                else
                  for j:=0 to vv.Iend do
                     vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]-vv.Yvalue[j];
            end;
          end;
    end;
  end;
end;


procedure TGaborNoise.BuildSignalSpk(pstw: TvectorArray; vec: Tvector;Nmax:integer);
var
  i,j:integer;
  vv:Tvector;
  tt,tmax:float;
  x,y,z,j0:integer;
  nbGab1:integer;
  wNorm:float;
begin
  if not sequenceInstalled then exit;

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);
  nbGab1:= LqrOrientCount*LqrPeriodCount*LqrLumCount*LqrPhaseCount;

  with pstw do                                                    
  if (Imin<>1) or (Imax<>nx) or (Jmin<>1) or (Jmax<>ny*nbGab1) then exit;

  tmax:=EvtTimes[cycleCount-1]*DxEvt+pstw.Xend;

  vec.X0u:=0;
  vec.Dxu:=pstw.dxu;
  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);

  {Calcul NtotSpk}
  wNorm:=0;
  {
  with pstw do
  for x:=Imin to Imax do
  for y:=Jmin to Jmax do
    with vector(x,y) do
      wNorm:=wNorm+sum(Istart,Iend);
  }
  for i:=0 to cycleCount-1 do
  begin
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=noise.getState(x,y,i);
      if not (Fblank and (z=nbgabor-1)) then
      begin
        with pstw[x+1,y+1+ny*z] do
          wNorm:=wNorm+sum(Istart,Iend);
      end;
    end;
  end;


  wNorm:=Nmax/wNorm;

  for i:=0 to cycleCount-1 do
  begin
    tt:=EvtTimes[i]*dxEvt;
    j0:=vec.invconvx(tt);

    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=noise.getState(x,y,i);
      if not (Fblank and (z=nbgabor-1)) then
      begin
        with pstw[x+1,y+1+ny*z] do
        for j:=0 to Iend do
          if random<Yvalue[j]*Wnorm then
            vec.Yvalue[j0+j]:=1
      end;
    end;
  end;
end;

procedure TGaborNoise.BuildSignal1(Vlist: TVlist; vec: Tvector);
var
  i,j:integer;
  vv:Tvector;
  tt,tmax:float;
  x1,y1,z1,x2,y2,z2:integer;
  nbGab1:integer;
  orient1,period1,lum1,phase1:integer;
  w,k0:integer;
  j0:integer;
  lag,maxlag:integer;
  w2:TEltK2;

begin
  maxLag:=10;

  if not sequenceInstalled then exit;

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);
  nbGab1:= LqrOrientCount*LqrPeriodCount*LqrLumCount*LqrPhaseCount;


  tmax:=EvtTimes[cycleCount-1]*DxEvt+Vlist.Xend;

  vec.X0u:=0;
  if Vlist.count>0
    then vec.Dxu:=Vlist.Vectors[1].dxu;

  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);

  for i:=0 to cycleCount-1 do
  begin
    tt:=EvtTimes[i]*dxEvt;
    j0:=vec.invconvx(tt);

    for x1:=0 to nx-1 do
    for y1:=0 to ny-1 do
      begin
        z1:=noise.f(x1,y1,i);

        w:=x1+ y1 shl 8 +z1 shl 16;
        index:=listK1.IndexOf(pointer(w));
        if (index>=0) then
        begin
          vv:=Vlist.vectors[index+1];
          for j:=0 to vv.Iend do
            vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
        end
        else
        begin
          index:=listK1bis.IndexOf(pointer(w));
          if (index>=0) then
          begin
            k0:=intG(listK1bisV[index]);
            vv:=Vlist.vectors[index+1];
            for j:=0 to vv.Iend do
              vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+k0*vv.Yvalue[j];
          end
        end;

        if listK2.count>0 then
          for lag:=0 to maxLag do
          if (i-lag>=0) then
          for x2:=0 to nx-1 do
          for y2:=0 to ny-1 do
          begin
            z2:=noise.f(x2,y2,i-lag);

            w2.x1:=x1;
            w2.y1:=y1;
            w2.z1:=z1;
            w2.x2:=x2;
            w2.y2:=y2;
            w2.z2:=z2;
            w2.t2:=lag;

            index:=listK2.IndexOf(@w2);
            if index>=0 then
            begin
              vv:=Vlist.vectors[index+1];
              for j:=0 to vv.Iend do
                vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
            end;
          end;
    end;
  end;
end;

procedure TGaborNoise.BuildSignalSpk1(Vlist: TVlist; vec: Tvector;
  Nmax: integer);
begin

end;


{ Calcul des Psths }

procedure TGaborNoise.initPsth(psth: TpsthArray; source: Tvector; x1,x2,deltaX: float);
var
  i1,i2:integer;
  nbGab:integer;
begin
  i1:=roundL(x1/deltaX);
  i2:=roundL(x2/deltaX);

  NbGab:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  psth.initarray(1,nx,1,ny*nbGab);
  psth.initPsths(i1,i2,g_longint,deltaX);
  psth.clear;
end;


procedure TgaborNoise.calculatePsth(psth: TpsthArray; source: Tvector);
var
  i,x,y,z:integer;
  t:double;
  vv:Tpsth;
  nbGab:integer;
begin
  if not assigned(psth)  then exit;
  if not sequenceInstalled then exit;
  NbGab:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  for i:=0 to cycleCount-1 do
  begin
    t:=EvtTimes[i]*dxEvt;

    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
      begin
        z:=noise.f(x,y,i);
        if z<nbGab then
        begin
          vv:=psth.psths(x+1,y+1+ny*z);
          if assigned(vv) then
            vv.addEx(source,t)
          else sortieErreur('TgaborNoise.calculatePsth : invalid psth object ');
        end;
      end;
    end;

end;


procedure TGaborNoise.initPstw(pstw: TaverageArray; source: Tvector; x1,x2: float);
var
  i1,i2:integer;
  nbgabor:integer;
begin
  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  pstw.initarray(1,nx,1,ny*nbGabor);
  pstw.initAverages(i1,i2,source.tpNum);
  pstw.dxu:=source.dxu;

  pstw.clear;
end;

procedure TGaborNoise.calculatePstw(pstw: TaverageArray; source: Tvector);
var
  i,x,y,z:integer;
  vv:Taverage;
  t:float;
begin
  if not assigned(pstw)  then exit;
  if not sequenceInstalled then exit;

  for i:=0 to cycleCount-1 do
  begin
    t:=EvtTimes[i]*dxEvt;

    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=noise.f(x,y,i);

      vv:=pstw.average(x+1,z*ny+y+1);
      if assigned(vv)
        then vv.addEx1(source,t)
        else sortieErreur('TgaborNoise.calculatePstw : invalid average object ');
    end;
  end;

end;


procedure TGaborNoise.initPstw2(pstw: TaverageArray; source: Tvector; x1,x2: float);
var
  i1,i2:integer;
  nbgabor:integer;
begin
  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  pstw.initarray(1,nx*ny*nbGabor,1,9*nbGabor);
  pstw.initAverages(i1,i2,source.tpNum);
  pstw.dxu:=source.dxu;

  pstw.clear;
end;

procedure TGaborNoise.calculatePstw2(pstw: TaverageArray; source: Tvector;dtau:integer);
var
  i,x,y,z:integer;
  z2:integer;
  vv:Taverage;
  t:float;
  imin,imax:integer;
  d,gx,gy:integer;
  x1,y1,i1:integer;
const
  deltaX:array[0..8] of integer=(0,1,1,0,-1,-1,-1,0,1);
  deltaY:array[0..8] of integer=(0,0,1,1,1,0,-1,-1,-1);

begin
  if not assigned(pstw)  then exit;
  if not sequenceInstalled then exit;

  if dtau>0 then
  begin
    imin:=0;
    imax:=cycleCount-dtau-1;
  end
  else
  begin
    imin:=-dtau;
    imax:=cycleCount-1;
  end;

  for i:=imin to imax do
  begin
    t:=EvtTimes[i]*dxEvt;

    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=noise.f(x,y,i);
      gx:=z+nbgabor*(y+ny*x) +1;

      for d:=0 to 8 do
      begin
        x1:=x+deltaX[d];
        y1:=y+deltaY[d];
        i1:=i+dtau;

        if (x1>=0) and (x1<nx) and (y1>=0) and (y1<ny) then
        begin
          z2:=noise.f(x1,y1,i1);
          gy:=9*z2 +d +1;
          vv:=pstw.average(gx,gy);
          if assigned(vv) then vv.addEx1(source,t);
        end;
      end;
    end;
  end;
end;

procedure TGaborNoise.encodePstw2(x,y,z,z2,d:integer;var gx,gy:integer);
begin
  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  gx:=z+nbgabor*(y+ny*x) +1;
  gy:=9*z2 +d +1;
end;

procedure TGaborNoise.decodePstw2(gx,gy:integer;var x,y,z,z2,d:integer);
begin
  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount+ord(Fblank);

  z:=(gx-1) mod nbgabor;
  gx:=(gx-z-1) div nbgabor;
  y:=gx mod ny;
  x:=(gx-y) div ny;

  d:=(gy-1) mod 9;
  z2:=(gy-d-1) div 9;
end;


procedure TGaborNoise.getMlist(Mlist: TmatList);
var
  mat:Tmatrix;
  i,x,y:integer;
begin
  Mlist.clear;
  mat:=Tmatrix.create;
  try
  mat.initTemp(1,Nx,1,Ny,G_short);

  for i:=0 to cycleCount-1 do
  begin
    mat.clear;
    for x:=0 to Nx-1 do
    for y:=0 to Ny-1 do
      mat.Zvalue[x+1,y+1]:=noise.getState(x,y,i);

    Mlist.AddMatrix(mat);
  end;

  finally
  mat.free;
  end;
end;

procedure TGaborNoise.setMlist(Mlist:TmatList);
var
  i,x,y:integer;
begin
  with Mlist do
  begin
    if count-1>noise.tmax then sortieErreur('TGaborNoise.setMlist : invalid number of matrix');
    for i:=0 to Count-1 do
    with mat[i+1] do
    begin
      if (Istart<>1) or (Iend<>Nx) or
         (Jstart<>1) or (Jend<>Nx) then sortieErreur('TGaborNoise.setMlist : invalid matrix dimensions');
      for x:=0 to Nx-1 do
      for y:=0 to Ny-1 do
        noise.State[x,y,i]:=round(Zvalue[x+1,y+1]);
    end;
  end;
end;

procedure TGaborNoise.SinglePstw2(moy: Taverage; source: Tvector;x1,y1,z1,x2,y2,z2,dtau:integer);
var
  i:integer;
  t:float;
  imin,imax:integer;
begin
  if not sequenceInstalled then exit;

  if dtau>0 then
  begin
    imin:=0;
    imax:=cycleCount-dtau-1;
  end
  else
  begin
    imin:=-dtau;
    imax:=cycleCount-1;
  end;

  for i:=imin to imax do
  begin
    t:=EvtTimes[i]*dxEvt;

    if (z1=noise.f(x1,y1,i)) and (z2=noise.f(x2,y2,i+dtau))
      then moy.addEx1(source,t);
  end;
end;

procedure TGaborNoise.SinglePsth2(psth: Tpsth; source: Tvector;x1,y1,z1,x2,y2,z2,dtau:integer);
var
  i:integer;
  t:float;
  imin,imax:integer;
begin
  if not sequenceInstalled then exit;

  if dtau>0 then
  begin
    imin:=0;
    imax:=cycleCount-dtau-1;
  end
  else
  begin
    imin:=-dtau;
    imax:=cycleCount-1;
  end;

  for i:=imin to imax do
  begin
    t:=EvtTimes[i]*dxEvt;

    if (z1=noise.f(x1,y1,i)) and (z2=noise.f(x2,y2,i+dtau))
      then psth.addEx(source,t);
  end;
end;



{*************************** Méthodes STM ************************************}

var
  E_order:integer;

  E_ker1:integer;
  E_ker2:integer;

  E_index:integer;
  E_data:integer;

  E_XYpos:integer;
  E_simul:integer;

procedure proTGaborNoise_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TGaborNoise);
end;


procedure proTGaborNoise_Overlap(val:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
    Overlap:=val;
end;

function fonctionTGaborNoise_Overlap(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
    result:=Overlap;
end;

procedure proTGaborNoise_preSim(val:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if val then preSim:=2 else preSim:=0;
  end;
end;

function fonctionTGaborNoise_preSim(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
    result:=(preSim=2);
end;


procedure proTGaborNoise_extensionx(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    extensionX:=value;
  end;
end;

function fonctionTGaborNoise_extensionx(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=extensionx;
  end;
end;

procedure proTGaborNoise_extensiony(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    extensiony:=value;
  end;
end;

function fonctionTGaborNoise_extensiony(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=extensiony;
  end;
end;

procedure proTGaborNoise_attenuationx(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    attenuationx:=value;
  end;
end;

function fonctionTGaborNoise_attenuationx(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=attenuationx;
  end;
end;

procedure proTGaborNoise_attenuationy(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    attenuationy:=value;
  end;
end;

function fonctionTGaborNoise_attenuationy(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=attenuationy;
  end;
end;

procedure proTGaborNoise_period(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 100) then sortieErreur(E_order);
    period:=value;
  end;
end;

function fonctionTGaborNoise_period(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=period;
  end;
end;

procedure proTGaborNoise_phase(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < -200) or (value > 200) then sortieErreur(E_order);
    phase:=value;
  end;
end;

function fonctionTGaborNoise_phase(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=phase;
  end;
end;

procedure proTGaborNoise_contrast(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 100) then sortieErreur(E_order);
    contrast:=value;
  end;
end;

function fonctionTGaborNoise_contrast(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=contrast;
  end;
end;

procedure proTGaborNoise_LumInc(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 50) then sortieErreur(E_order);
    LumInc:=value;
  end;
end;

function fonctionTGaborNoise_LumInc(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=LumInc;
  end;
end;

procedure proTGaborNoise_PeriodInc(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) then sortieErreur(E_order);
    PeriodInc:=value;
  end;
end;

function fonctionTGaborNoise_PeriodInc(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=PeriodInc;
  end;
end;

procedure proTGaborNoise_PhaseInc(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 200) then sortieErreur(E_order);
    PhaseInc:=value;
  end;
end;

function fonctionTGaborNoise_PhaseInc(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=PhaseInc;
  end;
end;

procedure proTGaborNoise_OrientInc(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 100) then sortieErreur(E_order);
    OrientInc:=value;
  end;
end;

function fonctionTGaborNoise_OrientInc(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=OrientInc;
  end;
end;

procedure proTGaborNoise_PeriodCount(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    PeriodCount:=value;
  end;
end;

function fonctionTGaborNoise_PeriodCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=PeriodCount;
  end;
end;

procedure proTGaborNoise_LumCount(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    LumCount:=value;
  end;
end;

function fonctionTGaborNoise_LumCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=LumCount;
  end;
end;

procedure proTGaborNoise_PhaseCount(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    PhaseCount:=value;
  end;
end;

function fonctionTGaborNoise_PhaseCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=PhaseCount;
  end;
end;

procedure proTGaborNoise_OrientCount(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    OrientCount:=value;
  end;
end;

function fonctionTGaborNoise_OrientCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=OrientCount;
  end;
end;

procedure proTGaborNoise_Nvalue(n,value:integer;var pu:typeUO);
begin
end;

function fonctionTGaborNoise_State(x,y,t:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if not sequenceInstalled
      then sortieErreur('TgaborNoise.getState : sequence not installed');
    result:=Noise.getState(x-1,y-1,t);
  end;
end;

procedure proTGaborNoise_State(x,y,t,w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (x<1) or (x>noise.Nx) or
       (y<1) or (y>noise.Ny) or
       (t<0) or (t>=noise.tmax) then sortieErreur('TGaborNoise.setState : parameter out of range');
    if (w<0) or (w>=nbGabor) then  sortieErreur('TGaborNoise.setState : value out of range');

    Noise.setState(x,y,t,w);
  end;
end;

function fonctionTGaborNoise_Nvalue(n:integer;var pu:typeUO):integer;
begin
end;

function fonctionTGaborNoise_length(var pu:typeUO):integer;
begin
end;



procedure proSamplingIntAbove(var source,dest,evenements:TVector;seuil:float);pascal;
var i:integer;
    len:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(evenements);
  Vmodify(dest,source.tpNum,evenements.Istart,evenements.Iend-1);{attention au -1!}
  dest.unitX:=source.unitX;
  with evenements do
  begin
    dest.Dxu:=Yvalue[Istart+3]-Yvalue[Istart+2];
    dest.x0u:=Yvalue[Istart];
  end;

  for i:=evenements.Istart to evenements.Iend-1 do
      dest.Yvalue[i]:=FonctionIntAbove(source,evenements.Yvalue[i],evenements.Yvalue[i+1],seuil,len);
end;

procedure proSamplingIntBelow(var source,dest,evenements:TVector;seuil:float);pascal;
var i:integer;
    len:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(evenements);
  Vmodify(dest,source.tpNum,evenements.Istart,evenements.Iend-1);{attention au -1!}
  dest.unitX:=source.unitX;
  with evenements do
  begin
    dest.Dxu:=Yvalue[Istart+3]-Yvalue[Istart+2];
    dest.x0u:=Yvalue[Istart];
  end;

  for i:=evenements.Istart to evenements.Iend-1 do
      dest.Yvalue[i]:=FonctionIntBelow(source,evenements.Yvalue[i],evenements.Yvalue[i+1],seuil,len);
end;

procedure proSamplingEnergie1(var source,dest,evenements:TVector;Y0:float);pascal;
var i:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(evenements);
  Vmodify(dest,source.tpNum,evenements.Istart,evenements.Iend-1);{attention au -1!}
  dest.unitX:=source.unitX;
  with evenements do
  begin
    dest.Dxu:=Yvalue[Istart+3]-Yvalue[Istart+2];
    dest.x0u:=Yvalue[Istart];
  end;

  for i:=evenements.Istart to evenements.Iend-1 do
      dest.Yvalue[i]:=FonctionEnergie1(source,evenements.Yvalue[i],evenements.Yvalue[i+1],Y0);
end;



procedure proTgaborNoise_BuildSignal(var pstw:TvectorArray;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));
  verifierVecteur(vec);

  TgaborNoise(pu).BuildSignal(pstw,vec);
end;

procedure proTgaborNoise_BuildSignalSpk(var pstw:TvectorArray;var vec:Tvector;Nmax:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));
  verifierVecteur(vec);

  TgaborNoise(pu).BuildSignalSpk(pstw,vec,Nmax);
end;



function fonctionTgaborNoise_encodeZ(orient1,period1,lum1,phase1:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
  result:=encodeZ(orient1,period1,lum1,phase1);
end;

procedure proTgaborNoise_decodeZ(code:integer;var orient1,period1,lum1,phase1:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
  DecodeZ(code,orient1,period1,lum1,phase1);
end;

function fonctionTgaborNoise_LQRencodeZ(orient1,period1,lum1,phase1:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
  result:=LQRencodeZ(orient1,period1,lum1,phase1);
end;

procedure proTgaborNoise_LQRdecodeZ(code:integer;var orient1,period1,lum1,phase1:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
  LQRDecodeZ(code,orient1,period1,lum1,phase1);
end;


procedure proTGaborNoise_LqrMode(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,LqrModeMax,'TGaborNoise: invalid LqrMode');
  TgaborNoise(pu).LqrMode:=w;
end;

function fonctionTGaborNoise_LqrMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TgaborNoise(pu).LqrMode;
end;

procedure proTGaborNoise_Blank(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TgaborNoise(pu).Fblank:=w;
end;


function fonctionTGaborNoise_Blank(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TgaborNoise(pu).Fblank;
end;

procedure proTGaborNoise_initPsth(var psth:TpsthArray;var source:Tvector;x1,x2,deltaX:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(psth));
  verifierVecteur(source);

  with TgaborNoise(pu) do initPsth(psth,source,x1,x2,deltaX);
end;

procedure proTGaborNoise_calculatePsth(var psth:TpsthArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(psth));
  verifierVecteur(source);

  with TgaborNoise(pu) do calculatePsth(psth,source);
end;

procedure proTGaborNoise_initPstw(var pstw:TaverageArray;var source:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));
  verifierVecteur(source);

  with TgaborNoise(pu) do initPstw(pstw,source,x1,x2);
end;


procedure proTGaborNoise_calculatePstw(var pstw:TaverageArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));
  verifierVecteur(source);

  with TgaborNoise(pu) do calculatePstw(pstw,source);
end;

procedure proTGaborNoise_initPstw2(var pstw:TaverageArray;var source:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));
  verifierVecteur(source);

  with TgaborNoise(pu) do initPstw2(pstw,source,x1,x2);
end;


procedure proTGaborNoise_calculatePstw2(var pstw:TaverageArray;var source:Tvector;dtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));
  verifierVecteur(source);

  with TgaborNoise(pu) do calculatePstw2(pstw,source,dtau);
end;


procedure proTGaborNoise_NoiseModel(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (value<0) or (value>1) then sortieErreur('TGaborNoise.NoiseModel : value out of range');
  with TgaborNoise(pu) do
  begin
    NoiseModel:=value;
    randSequence;
    FuserModel:=true;
  end;
end;

function fonctionTGaborNoise_NoiseModel(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
  result:=NoiseModel;
end;

procedure proTGaborNoise_encodePstw2(x,y,z,z2,d:integer;var gx,gy:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
    encodePstw2(x,y,z,z2,d,gx,gy);
end;

procedure proTGaborNoise_decodePstw2(gx,gy:integer;var x,y,z,z2,d:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TgaborNoise(pu) do
  decodePstw2(gx,gy,x,y,z,z2,d);
end;

procedure proTGaborNoise_SinglePstw2(var moy:Taverage;var source:Tvector;x1,y1,z1,x2,y2,z2,dtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(moy));
  verifierVecteur(source);

  with TgaborNoise(pu) do SinglePstw2(moy,source,x1-1,y1-1,z1,x2-1,y2-1,z2,dtau);
end;

procedure proTGaborNoise_InitSinglePstw2(var mm:Taverage;var source:Tvector;x1,x2:float);
var
  i1,i2:integer;
begin
  verifierVecteur(source);
  verifierObjet(typeUO(mm));

  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  mm.modify(mm.tpNum,i1,i2);

  mm.dxu:=source.dxu;
  mm.X0u:=0;
end;


procedure proTGaborNoise_SinglePsth2(var psth:Tpsth;var source:Tvector;x1,y1,z1,x2,y2,z2,dtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(psth));
  verifierVecteur(source);

  with TgaborNoise(pu) do SinglePsth2(psth,source,x1-1,y1-1,z1,x2-1,y2-1,z2,dtau);
end;

procedure proTGaborNoise_InitSinglePsth2(var psth:Tpsth;var source:Tvector;x1,x2,deltaX:float);
var
  i1,i2:integer;
begin
  verifierVecteur(source);
  verifierobjet(typeUO(psth));

  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  psth.modify(psth.tpNum,i1,i2);
  psth.Dxu:=deltaX;
  psth.X0u:=0;
end;



Initialization
AffDebug('Initialization stmGaborDense1',0);

registerObject(TGaborNoise,stim);

installError(E_order,'TGaborNoise: order out of range');
installError(E_index,'TGaborNoise: index out of range');
installError(E_simul,'TGaborNoise.simulate bad data ');

installError(E_ker1,'TGaborNoise: kernel1 not available ');
installError(E_ker2,'TGaborNoise: kernel2 not available ');

installError(E_XYpos,'TGaborNoise: invalid coordinates x y t ');


end.
