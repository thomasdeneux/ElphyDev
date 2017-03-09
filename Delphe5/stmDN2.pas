unit stmDN2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette,tbe0,
     stmDef,stmObj,stmobv0,stmRev1,varconf1,Ncdef2, Debug0,
     defForm,selRF1,editcont,
     getMseq1,syspal32,
     stmgrid3,
     stmvec1,stmMat1,stmOdat2,stmAve1,stmAveA1,stmPsth1,stmPstA1,
     stmPg,stmError,
     Rarray1,listG,
     matrix0,chrono0,
     Gnoise1,
     ipps, ippsovr,
     stmISPL1,stmMlist;



type

  TdenseNoise=class(Trevcor)

              private
                noise:TgridNoise;
                GridCol1, GridCol2: integer;
                grid:TgridEx;

                nbdivX2,nbdivY2:integer;
                nx2,ny2:integer;

                procedure setSeed(x:integer);override;
                function getState(x,y,t:integer):integer;

              protected
                function sequenceInstalled:boolean;override;
                function InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;override;                
              public

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;
                procedure freeRef;override;

                // randSequence n'impose pas CycleCount qui doit être fixé avant.
                // construit Noise
                procedure randSequence;override;

                procedure setVisiFlags(obOn:boolean);override;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;


                function valid: boolean;override;
                function GetGridCol(x,y:integer): integer;
                function Gstate(x,y,t:integer):integer;


                procedure setChildNames;override;

                procedure calculatePsth(var1,var2:TpsthArray;source:Tvector);override;

                procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);override;
                procedure calculatePstw(var1,var2:TaverageArray;source:Tvector);override;

                function LqrNz:integer;override;
                procedure calculateLqrPstw(source:Tvector);override;
                procedure getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);override;

                procedure BuildSignal(var1,var2:TvectorArray;vec:Tvector);override;
                procedure getMlist(Mlist:TmatList);override;
              end;


procedure proTdenseNoise_create(var pu:typeUO);pascal;
procedure proTdenseNoise_create_1(name:AnsiString;var pu:typeUO);pascal;

function fonctionTdenseNoise_Gstate(x,y,t:integer;var pu:typeUO):integer;pascal;


procedure proTdenseNoise_divXcount2(ww:integer;var pu:typeUO);pascal;
function fonctionTdenseNoise_divXcount2(var pu:typeUO):integer;pascal;
procedure proTdenseNoise_divYcount2(ww:integer;var pu:typeUO);pascal;
function fonctionTdenseNoise_divYcount2(var pu:typeUO):integer;pascal;

implementation



{*********************   Méthodes de TdenseNoise  *************************}

constructor TdenseNoise.create;
var
  i,j:integer;
begin
  inherited create;

  DtOn:=1;

  nbDivX:=8;
  nbDivY:=8;
  expansion:=100;
  dureeC:=10;
  if assigned(rfSys[1])
    then RFDeg:=rfSys[1].deg
    else RFdeg:=degNul;

  grid:=TgridEx.create;
  grid.notpublished:=true;
  grid.Fchild:=true;

  CycleCount:=1000;
  noise:=TXYnoise.create(1,1,seed,CycleCount);
end;


destructor TdenseNoise.destroy;
begin
  grid.free;

  noise.free;

  inherited destroy;
end;

procedure TdenseNoise.freeRef;
begin
  inherited;
end;

procedure TdenseNoise.setChildNames;
begin
end;


class function TdenseNoise.STMClassName:AnsiString;
begin
  STMClassName:='DenseNoise';
end;

procedure TdenseNoise.randSequence;
begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  nX2 := roundI(nbDivX2*Expansion/100.0);
  nY2 := roundI(nbDivY2*Expansion/100.0);

  if (nx2=0) or (ny2=0)
    then noise.modify(nx,ny,seed,cycleCount)
  else
  begin
    noise.free;
    noise:=TXYnoise.create(nx,ny,seed,cycleCount,nx2,ny2);
  end;
end;

function TdenseNoise.sequenceInstalled:boolean;
begin
  result:=(cycleCount>0) and (length(EvtTimes)=cycleCount) and (noise.tmax>=cycleCount);
end;

function TdenseNoise.InstallTimes(vec: Tvector; dx: float; var stE: string): boolean;
var
  i:integer;
begin
  if (cycleCount=0) then
  begin
    stE:='TDenseNoise: sequence not installed';
    result:=false;
    exit;
  end;

  dxEvt:=dx;
  setLength(EvtTimes,vec.ICount);
  for i:=vec.Istart to vec.Iend do
    EvtTimes[i-vec.Istart]:=roundL(vec.Yvalue[i]/dxEvt);

  result:= (vec.Icount<=cycleCount);
  cycleCount:=vec.Icount;   // cycleCount devient inférieur à noise.tmax

  if not result then stE:='TDenseNoise: installTimes failed';

  if cycleCount>1 then DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])*DxEvt/(cycleCount-1);
end;


procedure TdenseNoise.InitMvt;
var
  i,j:integer;
  deg1:typeDegre;
begin
   SortSyncPulse;
   
  index:=-1;
  randSequence;

  deg1:=RFdeg;
  deg1.dx:=deg1.dx*expansion/100;
  deg1.dy:=deg1.dy*expansion/100;

  grid.initGrille(deg1,nx,ny);

  with TimeMan do tend:=torg+dureeC*nbCycle;


  { obvis n'est pas utilisé
    AdjustObjectSize non plus
  }
  GridCol1:= syspal.DX9color(lum[1]);
  GridCol2:= syspal.DX9color(lum[2]);

  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
    grid.GridCol[i,j]:=DevcolBK;


end;


procedure TdenseNoise.initObvis;
begin
end;


function TdenseNoise.valid: boolean;
begin
  result:=true;
end;

function TdenseNoise.GetGridCol(x,y:integer): integer;
begin
  if noise.f(x,y,index)=-1
    then result:=GridCol1
    else result:=GridCol2;
end;


function TdenseNoise.Gstate(x,y,t:integer):integer;
begin
  result:=noise.f(x,y,t);
end;

procedure TdenseNoise.calculeMvt;
var
  i,j:integer;
begin

  if (timeS mod dureeC=0) then inc(Index);

  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
     grid.GridCol[i,j]:=GetGridCol(i,j);

end;

procedure TdenseNoise.doneMvt;
var
  i,j:integer;
begin
end;

procedure TdenseNoise.setVisiFlags(obOn:boolean);
begin
  grid.FlagOnScreen:=affStim and ObON;
  grid.FlagOnControl:=affControl and ObON;
end;

procedure TdenseNoise.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      if tout then setvarConf('OBVIS',intG(obvis),sizeof(intG));
    end;
  end;

procedure TdenseNoise.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;

function TdenseNoise.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMseq;;
end;


procedure TdenseNoise.installDialog(var form:Tgenform;var newF:boolean);
begin
  installForm(form,newF);

  with TgetMseq(form) do
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

    cbDivX.setString('2|4|8|16');
    cbDivX.setNumVar(nbDivX,T_longint);

    cbDivY.setString('2|4|8|16');
    cbDivY.setNumVar(nbDivY,T_longint);

    enLum1.setVar(lum[1],T_single);
    enLum1.setMinMax(0,10000);

    enLum2.setVar(lum[2],T_single);
    enLum2.setMinMax(0,10000);

    cbExpansion.setString('25|50|100|200|400');
    cbExpansion.setNumVar(Expansion,T_longint);

    selectRFD:=SelectRF;

    CBadjust.setvar(adjustObjectSize);

    onControlD:=SetOnControl;   {Ces procédures doivent être mises en place}
    onScreenD:=SetOnScreen;     {AVANT de modifier checked }

    CbOnControl.checked:=onControl;
    CbOnScreen.checked:=onScreen;

    initCBvisual(self,typeUO(obvis));
    updateAllCtrl(form);
  end;

end;


procedure TdenseNoise.setSeed(x:integer);
begin
  inherited setSeed(x);
end;



function TdenseNoise.getState(x,y,t:integer):integer;
begin
  result:=(noise.f(x,y,t)+1) div 2;
end;

{ Calcul des PSTW }


var
  E_average:integer;

{initPstw est identique à initPstw de Trevcor mais on impose le type DOUBLE }  
procedure TdenseNoise.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
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
      pstw[i].initAverages(i1,i2,g_double);
      pstw[i].dxu:=source.dxu;

      pstw[i].clear;
    end;
end;


procedure TdenseNoise.calculatePstw(var1,var2:TaverageArray;source:Tvector);

var
  i:integer;
  x,y,z:integer;
  t:double;

  vv:Taverage;
  pstw:array[1..2] of TaverageArray;
  pp:array of array of array of pointer;
  ppCount:array of array of array of integer;

  Ncount:integer;
  tbSource:PtabDouble;
  idx:integer;
  idxMin,idxMax:integer;

begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  for i:=1 to 2 do
    if not assigned(pstw[i]) then exit;
  if (length(EvtTimes)<>cycleCount) or not assigned(noise) then exit;

  vv:=pstw[1].average(1,1);

  if (source.tpNum=g_double) and assigned(vv) and (source.inf.temp) and (vv.tpNum=g_double) and
     not vv.stdOn and initIPPS then
  begin
    setLength(pp,2,nx,ny);
    setLength(ppCount,2,nx,ny);

    Ncount:=vv.Icount;
    tbSource:=source.tbDouble;
    idxMin:=source.Istart+Ncount;
    idxMax:=source.Iend-Ncount;

    for z:=0 to 1 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      vv:=pstw[z+1].average(x+1,y+1);
      if not assigned(vv) then sortieErreur(E_average);

      pp[z,x,y]:= vv.tb;
      ppCount[z,x,y]:=vv.Count;
      ippsMulC(vv.count,vv.tbD,Ncount);
    end;

    for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      idx:=source.invconvx(t+vv.Xstart);
      for x:=0 to nx-1 do
      for y:=0 to ny-1 do
      begin
        z:=getState(x,y,i);
        if (idx>=idxMin) and (idx<=idxMax) then
        begin
          ippsAdd(Pdouble(@tbSource^[idx]) , pp[z,x,y], Ncount);
          inc(ppCount[z,x,y]);
        end;
      end;
    end;

    for z:=0 to 1 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      vv:=pstw[z+1].average(x+1,y+1);
      vv.Count:=ppCount[z,x,y];
      if vv.Count<>0 then ippsMulC(1/vv.count,vv.tbD,Ncount);
    end;

  end

  else

  for i:=0 to cycleCount-1 do
  begin
    t:=EvtTimes[i]*dxEvt;
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=getState(x,y,i);
      vv:=pstw[z+1].average(x+1,y+1);

      if assigned(vv)
        then vv.addEx(source,t)
        else sortieErreur(E_average);

    end;
  end;


end;


procedure TdenseNoise.calculatePsth(var1, var2: TpsthArray; source: Tvector);
var
  i:integer;
  t:double;
  vv:Tpsth;
  psth:array[1..2] of TpsthArray;
  x,y,z:integer;
begin
  psth[1]:=var1;
  psth[2]:=var2;

  for i:=1 to 2 do
    if not assigned(psth[i])  then exit;
  if (length(EvtTimes)<>cycleCount) or not assigned(noise) then exit;

  for i:=0 to cycleCount-1 do
  begin
    t:=EvtTimes[i]*dxEvt;
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=getState(x,y,i);
      vv:=psth[z+1].psths(x+1,y+1);
      if assigned(vv)
        then vv.addEx(source,t)
        else sortieErreur('TdenseNoise.calculatePsth : invalid psth object ');
    end;
  end;

end;

function TdenseNoise.LqrNz:integer;
begin
  result:=1;
end;

procedure TdenseNoise.calculateLqrPstw(source:Tvector);
var
  i,j,k:integer;
  x,y:integer;

  nTau:integer;
  nbpos:integer;
begin
  ntau:=KPtau2-KPtau1+1;

  for i:=0 to cycleCount-1 do
  begin
    lqrP.ClearMatSline;

    for k:=KPtau1 to KPTau2 do
    begin
      if (i-k>=0) and (i-k<cycleCount) then
      for x:=0 to nx-1 do
      for y:=0 to ny-1 do
      begin
        j:=(k-KPtau1)+ntau*(y+ny*x);  {Nombre compris entre 0 et Nx*Ny*ntau-1  }
        lqrP.matSline[j]:=noise.f(x,y,i-k);
      end;
    end;

    for j:=0 to KPnbt-1 do
      lqrP.BXline[j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt];
    lqrP.UpdateHessian;
  end;
end;


const
  CssId='DN Css    ';
type
  TrecCss=record
            id:String[10];
            nx1,ny1:integer;
            KP1,KP2:integer;
            nbSeed:integer;
            seeds:array[1..1000] of integer;
          end;



procedure TdenseNoise.getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);
var
  i1,i2:integer;
  i,j,k,x,y,tau:integer;
  KPcode:integer;

  N,ntau:integer;

begin
  {z indifférent }

  nTau:=KPtau2-KPtau1+1;
  if (nTau<1) or (KPdt<=0) or not assigned(lqrP) then exit;

  i1:=KPtau1*KPnbt;
  i2:=(KPtau2+1)*KPnbt-1;

  pstw.initarray(1,nx,1,ny);
  pstw.initvectors(i1,i2,g_single);
  pstw.dxu:=KPdt;
                      { Construction des Pstws }
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    KPcode:=ntau*(y+ny*x);
    lqrP.getVector(KPcode,ntau,Pstw[x+1,y+1],raw,norm );
  end;
end;


procedure TdenseNoise.BuildSignal(var1, var2: TvectorArray; vec: Tvector);
var
  i,j:integer;
  pstw:array[1..2] of TvectorArray;
  vv:Tvector;
  tt,tmax:float;
  x,y,z,j0:integer;

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
  begin
    tt:=EvtTimes[i]*dxEvt;
    j0:=vec.invconvx(tt);

    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=getState(x,y,i);
      vv:=pstw[z+1][x+1,y+1];
      for j:=0 to vv.Iend do
        vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
    end;
  end;
end;

procedure TdenseNoise.getMlist(Mlist: TmatList);
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


{*************************** Méthodes STM ************************************}


procedure proTdenseNoise_create(var pu:typeUO);
begin
  createPgObject('',pu,TdenseNoise);
end;

procedure proTdenseNoise_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TdenseNoise);
end;


function fonctionTdenseNoise_Gstate(x,y,t:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);

  result:=TdenseNoise(pu).Gstate(x-1,y-1,t);
end;


procedure proTdenseNoise_divXcount2(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  TdenseNoise(pu).nbdivX2:=ww;
end;

function fonctionTdenseNoise_divXcount2(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TdenseNoise(pu).nbdivX2;
end;

procedure proTdenseNoise_divYcount2(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  TdenseNoise(pu).nbdivY2:=ww;
end;

function fonctionTdenseNoise_divYcount2(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TdenseNoise(pu).nbdivY2;
end;





Initialization
AffDebug('Initialization stmDN2',0);

registerObject(TdenseNoise,stim);


end.
