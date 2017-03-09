unit stmDNter1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette,tbe0, debug0,
     stmDef,stmObj,stmobv0,stmRev1,varconf1,Ncdef2,
     defForm,selRF1,editcont,
     getMseq1,syspal32,
     stmgrid3,
     stmvec1,stmMat1,stmOdat2,stmAve1,stmAveA1,stmPsth1,stmPstA1, VlistA1,
     stmPg,stmError,
     Rarray1,listG,
     matrix0,chrono0,
     Gnoise1,
     stmMlist,
     IPPdefs,IPPS,IPPSovr,mathKernel0,
     Cuda1, DNkernel1;



type

  TMNoise=class(Trevcor)

              private
                noise:TXYNoise1;

                GridCol: array of integer;
                Flums:array of single;
                grid:TgridEx;

                // Threaded lists
                vA: array[0..2] of Tlist; // Pointe sur les TaverageArray
                VSrc: TVlist;              // Contient des copies des vecteurs sources


                procedure setSeed(x:integer);override;
                function getState(x,y,t:integer):integer;

                procedure setStateCount(n:integer);
                function getStateCount:integer;
                procedure setLums(n:integer;w:float);
                function getLums(n:integer):float;


              protected
                function sequenceInstalled:boolean;override;
                function InstallMatList(matlist:Tmatlist;Nmin,Nmax:integer): boolean;
                function InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;override;
              public

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;
                procedure freeRef;override;

                property StateCount:integer read getStateCount write setstateCount;
                property lums[n:integer]:float read getLums write setLums;

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

                procedure initPstw(var1,var2,var3:TaverageArray;source:Tvector;x1,x2:float);
                procedure CudacalculatePstw(var1,var2,var3:TaverageArray;source:Tvector);
                procedure calculatePstw(var1,var2,var3:TaverageArray;source:Tvector);

                function LqrNz:integer;override;
                procedure calculateLqrPstw(source:Tvector);override;

                procedure getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);override;

                procedure BuildSignal(var1,var2:TvectorArray;vec:Tvector);override;
                procedure getMlist(Mlist:TmatList);override;

                procedure ClearThreadedPstw;
                procedure AddThreadedPstw(var1,var2,var3:TaverageArray;source:Tvector);
                procedure CalculateThreadedPstw;
              end;


procedure proTMnoise_create(var pu:typeUO);pascal;
procedure proTMnoise_create_1(name:AnsiString;var pu:typeUO);pascal;

function fonctionTMnoise_Gstate(x,y,t:integer;var pu:typeUO):integer;pascal;

procedure proTMnoise_Lum(n:integer;w:float;var pu:typeUO);pascal;
function fonctionTMnoise_Lum(n:integer;var pu:typeUO):float;pascal;

procedure proTMnoise_initPstw(var v1,v2,v3:TaverageArray;var source:Tvector;
                              x1,x2:float;var pu:typeUO);pascal;
procedure proTMnoise_calculatePstw(var v1,v2,v3:TaverageArray;var source:Tvector;
                                   var pu:typeUO);pascal;


procedure proTMnoise_initThreadedPstw(var pu:typeUO);pascal;
procedure proTMnoise_AddThreadedPstw(var va1, va2, va3: TaverageArray; var source: Tvector; var pu:typeUO);pascal;
procedure proTMnoise_CalculateThreadedPstw(var pu:typeUO);pascal;

procedure proTMnoise_installMatlist(var matlist1:Tmatlist;N1,N2:integer ;var pu:typeUO);pascal;

implementation



{*********************   Méthodes de TMnoise  *************************}

constructor TMnoise.create;
var
  i,j:integer;
begin
  inherited create;

  timeMan.dtOn:=1;

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

  timeMan.nbCycle:=1000;

  StateCount:=3;
  lums[0]:=25;
  lums[1]:=0;


  noise:=TXYnoise1.create(1,1,0,stateCount-1,seed,CycleCount);

  for i:=0 to 2 do vA[i]:=Tlist.create;

  Vsrc:=TVlist.create;
  Vsrc.NotPublished:=true;
end;


destructor TMnoise.destroy;
var
  i:integer;
begin
  grid.free;

  noise.free;

  ClearThreadedPstw;
  for i:=0 to 2 do vA[i].free;
  Vsrc.free;

  inherited destroy;
end;


procedure TMnoise.freeRef;
begin
  inherited;
end;

procedure TMnoise.setChildNames;
begin
end;


class function TMnoise.STMClassName:AnsiString;
begin
  STMClassName:='MNoise';
end;

procedure TMnoise.setStateCount(n:integer);
var
  i:integer;
begin
  {On suppose que n est impair}
  

  setLength(GridCol,n);


  setLength(Flums,n);
  for i:=0 to n-1 do lums[i]:=0;

  noise.free;
  noise:=TXYnoise1.create(1,1,0,n-1,seed,CycleCount);
end;

function  TMnoise.getStateCount:integer;
begin
  result:=length(Flums);
end;

procedure TMnoise.setLums(n:integer;w:float);
begin
  if (n>=0) and (n<stateCount)
    then Flums[n]:=w;
end;

function TMnoise.getLums(n:integer):float;
begin
  if (n>=0) and (n<stateCount)
    then result:=Flums[n]
    else result:=0;
end;


procedure TMnoise.randSequence;
begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  if assigned(noise)
    then noise.modify(nx,ny,seed,cycleCount);
end;

function TMnoise.sequenceInstalled:boolean;
begin
  result:=(cycleCount>0) and (length(EvtTimes)=cycleCount) and (noise.tmax>=cycleCount);
end;

function TMNoise.InstallMatList(matlist:Tmatlist;Nmin,Nmax:integer): boolean;
var
  i,j,k:integer;
  Nk:integer;
  i1,j1:integer;
begin
  result:=false;
  if not matList.canCompact or (matlist.count=0) then exit;

  Nk:= matList.count;
  Nx:= matlist.Icount;
  Ny:= matlist.Jcount;

  noise.Free;
  noise:=TXYNoise1.create(Nx,Ny,Nmin,Nmax,0,Nk,false);

  i1:=matlist.Mat[1].Istart;
  j1:=matlist.Mat[1].Jstart;

  for k:=0 to Nk-1 do
  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
    noise.G0[i,j,k]:=matList.mat[1+k].Kvalue[i1+i,j1+j];

  result:=true;
end;

function TMNoise.InstallTimes(vec: Tvector; dx: float;var stE: string): boolean;
var
  i:integer;
begin
  if (cycleCount=0) then
  begin
    stE:='TMnoise: sequence not installed';
    result:=false;
    exit;
  end;

  dxEvt:=dx;
  setLength(EvtTimes,vec.ICount);
  for i:=vec.Istart to vec.Iend do
    EvtTimes[i-vec.Istart]:=roundL(vec.Yvalue[i]/dxEvt);

  result:= (vec.Icount<=cycleCount);
  cycleCount:=vec.Icount;   // cycleCount devient inférieur à noise.tmax


  if not result then stE:='TMnoise: installTimes failed';

  if cycleCount>1 then DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])*DxEvt/(cycleCount-1);
end;


procedure TMnoise.InitMvt;
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


    lums[stateCount-1]:=syspal.BKlum;
    for i:=0 to stateCount-1 do
      GridCol[i]:= syspal.DX9color(lums[i]);

  end;


procedure TMnoise.initObvis;
var
  i:integer;
begin
end;


function TMnoise.valid: boolean;
begin
  result:=true;
end;

function TMnoise.GetGridCol(x,y:integer): integer;
begin
  result:=GridCol[noise.getState(x,y,index)];
end;



function TMnoise.Gstate(x,y,t:integer):integer;
begin
  result:=noise.f(x,y,t);
end;

procedure TMnoise.calculeMvt;
var
  i,j:integer;
begin
  if (timeS mod dureeC=0) then inc(Index);
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
     grid.GridCol[i,j]:=GetGridCol(i,j);


end;

procedure TMnoise.doneMvt;
var
  i,j:integer;
begin
end;

procedure TMnoise.setVisiFlags(obOn:boolean);
begin
  grid.FlagonScreen:=affStim and ObON;
  grid.FlagonControl:=affControl and ObON;
end;

procedure TMnoise.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      if tout then setvarConf('OBVIS',intG(obvis),sizeof(intG));
    end;
  end;

procedure TMnoise.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;

function TMnoise.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMseq;;
end;


procedure TMnoise.installDialog(var form:Tgenform;var newF:boolean);
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


procedure TMnoise.setSeed(x:integer);
begin
  inherited setSeed(x);
end;



function TMnoise.getState(x,y,t:integer):integer;
begin
  result:=noise.getState(x,y,t);
end;

{ Calcul des PSTW }



procedure TMNoise.initPstw(var1,var2,var3:TaverageArray;source:Tvector;x1,x2:float);
var
  i,i1,i2:integer;
  pstw:array[1..3] of TaverageArray;
  tp:typetypeG;
begin
  pstw[1]:=var1;
  pstw[2]:=var2;
  pstw[3]:=var3;


  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  for i:=1 to 3 do
    begin
      pstw[i].initarray(1,nx,1,ny);
      pstw[i].initAverages(i1,i2,source.tpNum);
      pstw[i].dxu:=source.dxu;

      pstw[i].clear;
    end;
end;


var
  E_average:integer;


{ Test du 8avril:    fichier   1413_CXLEFT_MST11.dat

  15x15x3 = 675 pstws contenant 1000 points
  2160 tops synchro

                  le calcul classique en mode single prend 12.2 secondes (on appelle IPPS)
                  le calcul classique en mode double prend 50 secondes (on appelle IPPS)
                  le calcul CUDA prend 15.2 secondes
                  le calcul classique single basé sur le même algorithme que Cuda prend  114 secondes (n'appelle pas IPPS)
                  les transferts Delphi prennent 0.6 seconde
                  les transferts CUDA prennent 0.6 seconde

  Cuda fait donc gagner un facteur 8 sur le calcul brut mais reste moins performant que IPP
  Les transferts ont une importance négligeable.
}

procedure TMNoise.CudaCalculatePstw(var1,var2,var3:TaverageArray;source:Tvector);
var
  Vsource:PtabSingle;
  Vt: array of integer;
  Vcode:array of integer;
  Pstw: array of single;

  Npoint:integer;    // Number of samples in source
  Ncode: integer;    // Number of codes in one frame = Nx*Ny
  Ncycle:integer;    // Number of frames = number of topSyncs
  Npstw: integer;    // Number of samples in one pstw

  varP:array[0..2] of TaverageArray;

  i,i1,x,y,k:integer;
  Vcount: array of integer;
  res:integer;

  idx,code,z,t:integer;
  p: Psingle;

begin

  Npoint:=source.Icount;
  Ncode:= Nx*Ny;
  Ncycle:=length(EvtTimes);
  Npstw:= var1.Vector[1,1].Icount;


  Vsource:=source.tb;
  setlength(Vt,Ncycle);            //  tops synchro
  setlength(Vcode, Ncode*Ncycle);  //  codes = z +  x* Nstate + y*Nstate*Nx,
                                   //  Vcode contient les numéros des pstw à incrémenter ( Ncode Pstws à chaque cycle )
  setLength(Pstw,Npstw*Ncode*3);   //  Ncode*3 pstws

  setLength(Vcount,Ncode*3);


  i1:= var1.Vector[1,1].Istart;
  for i:=0 to length(Vt)-1 do Vt[i]:=round(EvtTimes[i]*DxEvt/source.Dxu)+i1;


  varP[0]:=var1;
  varP[1]:=var2;
  varP[2]:=var3;

  //copier les Taverage dans pstw
  for i:=0 to 2 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    k:= i +3*(x+Nx*y);
    move(varP[i].Vector[x+1,y+1].tb^,pstw[k*Npstw],Npstw*sizeof(single));
    Vcount[k]:= Taverage(varP[i].Vector[x+1,y+1]).count;
    ippsMulC(Vcount[k],@pstw[k*Npstw],Npstw);
  end;
  // calculer les Vcount
  k:=0;
  for i:=0 to Ncycle-1 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    Vcode[k]:= getState(x,y,i) +3*(x+Nx*y);
    inc(Vcount[Vcode[k]]);
    inc(k);
  end;
  {
  res:= DNpstw(Psingle(Vsource), Npoint, @Vt[0], Ncode, @Vcode[0], Ncycle, @Pstw[0], Npstw);
  if res<>0 then messageCentral('CUDA DNpstw='+Istr(res));
  }
  {
  for idx:=0 to Npstw-1 do
  begin
    for i:= 0 to Ncycle-1 do
    begin
      t := Vt[i];
      for code := 0 to Ncode-1 do
      begin
        z := Vcode[i*Ncode+code];
        p:=@Pstw[ z*Npstw + idx];
        p^:=p^+ Vsource[ t+idx];
      end;
    end;
  end;
  }
  // faire le calcul: on somme les pstws
  for i:= 0 to Ncycle-1 do
  begin
    t := Vt[i];
    for code := 0 to Ncode-1 do
    begin
      z := Vcode[i*Ncode+code];
      p:=@Pstw[ z*Npstw ];

      ippsAdd(Psingle(@Vsource[t]),p,Npstw);
    end;
  end;

  // copier les pstw dans les Taverage en divisant par count
  // count est également copié
  for i:=0 to 2 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    k:= i +3*(x+Nx*y);
    ippsMulC(1/Vcount[k],@pstw[k*Npstw],Npstw);

    move(pstw[k*Npstw], varP[i].Vector[x+1,y+1].tb^, Npstw*sizeof(single));
    Taverage(varP[i].Vector[x+1,y+1]).count:=Vcount[k];
  end;


end;


procedure TMNoise.calculatePstw(var1,var2,var3:TaverageArray;source:Tvector);

var
  i:integer;
  x,y,z:integer;
  t:double;

  vv:Taverage;
  pstw:array[1..3] of TaverageArray;
  pp:array of array of array of pointer;
  ppCount:array of array of array of integer;

  Ncount:integer;
  tbSource:Pointer;
  idx:integer;
  idxMin,idxMax:integer;

begin
  pstw[1]:=var1;
  pstw[2]:=var2;
  pstw[3]:=var3;

  for i:=1 to 3 do
    if not assigned(pstw[i]) then exit;
  if (length(EvtTimes)<>cycleCount) or not assigned(noise) then exit;

  vv:=pstw[1].average(1,1);


  if (source.tpNum=g_single) and assigned(vv) and (source.inf.temp) and (vv.tpNum=g_single) and not vv.stdOn and InitCudaLib2
    then CudaCalculatePstw(var1,var2,var3,source)
  else

  if (source.tpNum=g_single) and assigned(vv) and (source.inf.temp) and (vv.tpNum=g_single) and
     not vv.stdOn then
  TRY
    IPPStest;

    setLength(pp,3,nx,ny);
    setLength(ppCount,3,nx,ny);

    Ncount:=vv.Icount;
    tbSource:=source.tbSingle;
    idxMin:=source.Istart{+Ncount};
    idxMax:=source.Iend-Ncount;

    for z:=0 to 2 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      vv:=pstw[z+1].average(x+1,y+1);
      if not assigned(vv) then sortieErreur(E_average);

      pp[z,x,y]:= vv.tb;
      ppCount[z,x,y]:=vv.Count;
      ippsMulC(vv.count,Psingle(vv.tb),Ncount);
    end;

    for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      idx:=source.invconvx(t+vv.Xstart) ;
      for x:=0 to nx-1 do
      for y:=0 to ny-1 do
      begin
        z:=getState(x,y,i);
        if (idx>=idxMin) and (idx<=idxMax) then
        begin
          //ippsAdd(Psingle(@PtabSingle(tbSource)^[idx]) , Psingle(pp[z,x,y]), Ncount);
          Affdebug('vsAdd '+Istr(i)+' '+Istr(z)+' '+' '+Istr(x)+' '+' '+Istr(y) ,255);
          vsAdd(Ncount,Psingle(@PtabSingle(tbSource)^[idx]) , Psingle(pp[z,x,y]),Psingle(pp[z,x,y]));
          inc(ppCount[z,x,y]);

        end;
      end;
    end;

    for z:=0 to 2 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      vv:=pstw[z+1].average(x+1,y+1);
      vv.Count:=ppCount[z,x,y];
      if vv.Count<>0 then ippsMulC(1/vv.count,Psingle(vv.tb),Ncount);
    end;

  FINALLY
    IPPSend;
    MKLend;
  end

  else

  if (source.tpNum=g_double) and assigned(vv) and (source.inf.temp) and (vv.tpNum=g_double) and
     not vv.stdOn then
  begin
    IPPStest;
    setLength(pp,3,nx,ny);
    setLength(ppCount,3,nx,ny);

    Ncount:=vv.Icount;
    tbSource:=source.tbDouble;
    idxMin:=source.Istart{+Ncount};
    idxMax:=source.Iend-Ncount;

    for z:=0 to 2 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      vv:=pstw[z+1].average(x+1,y+1);
      if not assigned(vv) then sortieErreur(E_average);

      pp[z,x,y]:= vv.tb;
      ppCount[z,x,y]:=vv.Count;
      ippsMulC(vv.count,Pdouble(vv.tb),Ncount);
    end;

    for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      idx:=source.invconvx(t+vv.Xstart) ;
      for x:=0 to nx-1 do
      for y:=0 to ny-1 do
      begin
        z:=getState(x,y,i);
        if (idx>=idxMin) and (idx<=idxMax) then
        begin
          ippsAdd(Pdouble(@PtabDouble(tbSource)^[idx]) , Pdouble(pp[z,x,y]), Ncount);
          inc(ppCount[z,x,y]);
        end;
      end;
    end;

    for z:=0 to 2 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      vv:=pstw[z+1].average(x+1,y+1);
      vv.Count:=ppCount[z,x,y];
      if vv.Count<>0 then ippsMulC(1/vv.count,Pdouble(vv.tb),Ncount);
    end;

    IPPSend;
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



procedure TMnoise.calculatePsth(var1, var2: TpsthArray; source: Tvector);
var
  i:integer;
  t:double;
  vv:Tpsth;
  psth:array[1..2] of TpsthArray;
  x,y,z:integer;

  Smin,Smax:array of integer;
  s1,s2:integer;
  nb:integer;
  XstartPsth,XendPsth:float;

begin
  psth[1]:=var1;
  psth[2]:=var2;

  nb:= length(EvtTimes);
  for i:=1 to 2 do
    if not assigned(psth[i])  then exit;
  if (nb<>cycleCount) or not assigned(noise) then exit;

  if (source.Icount=0) or (nb=0) then exit;

  setlength(Smin,nb);
  setlength(Smax,nb);

  s1:= source.Istart;
  s2:= source.Istart;
  XstartPsth:= var1.Vector[1,1].Xstart;
  XendPsth:= var1.Vector[1,1].Xend;

  for i:=0 to nb-1 do
  begin
    while (s1<source.Iend) and (source[s1]-EvtTimes[i]*DxEvt < XstartPsth) do inc(s1);
    while (s2<source.Iend) and (source[s2]-EvtTimes[i]*DxEvt < XendPsth) do inc(s2);
    Smin[i]:=s1;
    Smax[i]:=s2;
  end;

  for i:=0 to cycleCount-1 do
  begin
    t:=EvtTimes[i]*dxEvt;
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=getState(x,y,i);
      if z<2 then
      begin
        vv:=psth[z+1].psths(x+1,y+1);
        if assigned(vv)
          then vv.addEx(source,t,Smin[i],Smax[i])
          else sortieErreur('TMnoise.calculatePsth : invalid psth object ');
      end;
    end;
  end;

end;

function TMnoise.LqrNz:integer;
begin
  result:=StateCount-1;
end;

procedure TMnoise.calculateLqrPstw(source:Tvector);
var
  i,j,k:integer;
  x,y,z:integer;
  nz:integer;

  nTau:integer;
  nbpos:integer;
begin
  ntau:=KPtau2-KPtau1+1;
  nz:=stateCount-1;

  for i:=0 to cycleCount-1 do
  begin
    lqrP.ClearMatSline;

    for k:=KPtau1 to KPTau2 do
    begin
      if (i-k>=0) and (i-k<cycleCount) then
      for x:=0 to nx-1 do
      for y:=0 to ny-1 do
      begin
        z:=noise.f(x,y,i-k);
        if z<>nz then
        begin
          j:=k-KPtau1+ Ntau*(z+nz*(y+ny*x));   {Nombre compris entre 0 et Nc-1  }
          lqrP.MatSline[j]:=1;
        end;
      end;
    end;

    for j:=0 to KPnbt-1 do
      lqrP.BXline[j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt];

    lqrP.UpdateHessian;
  end;
end;


const
  CssId='Mnoise Css';
type
  TrecCss=record
            id:String[10];
            nx1,ny1:integer;
            states:integer;
            KP1,KP2:integer;
            nbSeed:integer;
            seeds:array[1..1000] of integer;
          end;




procedure TMNoise.getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);
var
  i1,i2:integer;
  i,j,k,x,y,tau:integer;
  nz:integer;
  KPcode:integer;

  N,Ntau:integer;
  index:integer;

begin
  controleParam(z,-stateCount div 2,stateCount div 2,'getLqrPstw: invalid Z');
  if z=0 then sortieErreur('getLqrPstw: invalid Z');

  Ntau:=KPtau2-KPtau1+1;
  if (Ntau<1) or (KPdt<=0) or not assigned(lqrP) then exit;
  nz:=stateCount-1;

  i1:=KPtau1*KPnbt;
  i2:=(KPtau2+1)*KPnbt-1;

  pstw.initarray(1,nx,1,ny);
  pstw.initvectors(i1,i2,g_single);
  pstw.dxu:=KPdt;

  if z<0
    then z:=z+StateCount div 2
    else z:=z+StateCount div 2-1;

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    KPcode:=ntau*(z+nz*(y+ny*x));
    lqrP.getVector(KPcode,ntau,Pstw[x+1,y+1],raw,norm );
  end;

end;



procedure TMnoise.BuildSignal(var1, var2: TvectorArray; vec: Tvector);
var
  i,j:integer;
  pstw:array[1..2] of TvectorArray;
  vv:Tvector;
  tt,tmax:float;
  x,y,z,j0:integer;
  nz:integer;

begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  nz:=stateCount-1;

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
      if z<2 then
      begin
        vv:=pstw[z+1][x+1,y+1];
        for j:=0 to vv.Iend do
          vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
      end;
    end;
  end;
end;


procedure TMNoise.getMlist(Mlist: TmatList);
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


procedure proTMnoise_create(var pu:typeUO);
begin
  createPgObject('',pu,TMnoise);
end;

procedure proTMnoise_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TMnoise);
end;


function fonctionTMnoise_Gstate(x,y,t:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);

  result:=TMnoise(pu).Gstate(x-1,y-1,t);
end;

procedure proTMnoise_Lum(n:integer;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TMnoise(pu) do
  if (n>=1) and (n<=stateCount-1)
    then Lums[n-1]:=w
    else sortieErreur('TMNoise.Lum : index out of range');
end;


function fonctionTMnoise_Lum(n:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TMnoise(pu) do
  if (n>=1) and (n<=stateCount-1)
    then result:=TMnoise(pu).Lums[n-1]
    else sortieErreur('TMNoise.Lum : index out of range');
end;


procedure proTMnoise_installMatlist(var matlist1:Tmatlist;N1,N2:integer ;var pu:typeUO);
begin
  verifierObjet(pu);
  with TMnoise(pu) do installMatlist(matlist1,N1,N2);
end;

procedure proTMnoise_initPstw(var v1,v2,v3:TaverageArray;var source:Tvector;
                              x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));
  verifierObjet(typeUO(v3));

  verifierVecteur(source);

  with TMnoise(pu) do initPstw(v1,v2,v3,source,x1,x2);
end;



procedure proTMnoise_calculatePstw(var v1,v2,v3:TaverageArray;var source:Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  with TMnoise(pu) do calculatePstw(v1,v2,v3, source);
end;


procedure TMnoise.ClearThreadedPstw;
var
  i,j:integer;
  uo: typeUO;
begin
  for i:=0 to 2 do
  begin
    for j:= 0 to VA[i].count-1 do
    begin
      uo:= typeUO(VA[i][j]);
      derefObjet(uo);
    end;
    VA[i].Clear;
  end;

  Vsrc.Clear;

end;


procedure TMNoise.CalculateThreadedPstw;
var
  Vsource:PtabSingle;
  Vt: array of integer;
  Vcode:array of integer;
  Pstw: array of TpstwArray;

  Npoint:integer;    // Number of samples in source
  Ncode: integer;    // Number of codes in one frame = Nx*Ny
  Ncycle:integer;    // Number of frames = number of topSyncs
  Npstw: integer;    // Number of samples in one pstw

  i,j,i1,x,y,k:integer;
  Vcount1, Vcount2: array of integer;
  res:integer;

  idx,code,z,t:integer;
  p: Psingle;

  ThMulti: TthreadedMulti;
  DxuSource: float;

begin
  Ncode:= Nx*Ny;
  Ncycle:=length(EvtTimes);

  Npstw:=TvectorArray(va[0][0]).Vector[1,1].Icount;

  setlength(Vt,Ncycle);            //  tops synchro
  setlength(Vcode, Ncode*Ncycle);  //  codes = z +  x* Nstate + y*Nstate*Nx
  setLength(Vcount1,Ncode*3);
  setLength(Vcount2,Ncode*3);

  setLength(Pstw,va[0].Count,Ncode*3);

  i1:= TvectorArray(va[0][0]).Vector[1,1].Istart;
  DxuSource:= TvectorArray(va[0][0]).Vector[1,1].Dxu;
  for i:=0 to length(Vt)-1 do
    Vt[i]:=round(EvtTimes[i]*DxEvt/DxuSource)+i1;


  // Ancien Vcount
  for i:=0 to 2 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    k:= i +3*(x+Nx*y);
    Vcount1[k]:= TaverageArray(va[i][0]).average(x+1,y+1).count;
  end;

  // Nouveau Vcount
  // on remplit aussi Vcode
  move(Vcount1[0], Vcount2[0], length(Vcount1)*4);
  k:=0;
  for i:=0 to Ncycle-1 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    Vcode[k]:= getState(x,y,i) +3*(x+Nx*y);
    inc(Vcount2[Vcode[k]]);
    inc(k);
  end;


  thMulti:= TthreadedMulti.create(Ncycle, Ncode, Npstw,Vt,Vcode,Vcount1,Vcount2);

  For j:=0 to Vsrc.Count-1 do
  begin
     for i:=0 to 2 do
     for x:=0 to nx-1 do
     for y:=0 to ny-1 do
     begin
       k:= i +3*(x+Nx*y);
       Pstw[j][k]:= TaverageArray(va[i][j]).Vector[x+1,y+1].tb;
     end;

     thMulti.AddPstw( Vsrc[j+1].tb, Pstw[j]);
  end;

  thMulti.Calculate;
  thMulti.Free;

  for i:=0 to 2 do
  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  begin
    k:= i +3*(x+Nx*y);
    for j:=0 to va[i].count-1 do
    TaverageArray(va[i][j]).Average(x+1,y+1).count:=Vcount2[k];
  end;


end;

procedure TMNoise.AddThreadedPstw(var1, var2, var3: TaverageArray; source: Tvector);
begin
  va[0].Add(var1);
  refObjet(var1);

  va[1].Add(var2);
  refObjet(var2);

  va[2].Add(var3);
  refObjet(var3);

  Vsrc.AddVector(source);  // Copie le vecteur source

end;

procedure proTMnoise_initThreadedPstw(var pu:typeUO);
begin
  verifierObjet(pu);

  with TMnoise(pu) do ClearThreadedPstw;
end;

procedure proTMnoise_AddThreadedPstw(var va1, va2, va3: TaverageArray; var source: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(va1));
  verifierObjet(typeUO(va2));
  verifierObjet(typeUO(va3));
  verifierObjet(typeUO(source));

  with TMnoise(pu) do AddThreadedPstw(va1, va2, va3,source);
end;


procedure proTMnoise_CalculateThreadedPstw(var pu:typeUO);
begin
  verifierObjet(pu);
  with TMnoise(pu) do
    CalculateThreadedPstw;
end;


Initialization
AffDebug('Initialization stmDNter1',0);

registerObject(TMnoise,stim);


end.
