unit stmchkXY;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, listG, debug0,
     stmDef,stmObj,stmVec1,stmPsth1,stmPg,NcDef2,
     ChkPstw1,stmMlist,
     MathKernel0;

type
  TGvalues=record
             min,max:float;
             state:integer;
             Amp:float;
             flag:integer;
           end;

  TCHKsolverXY=
    class(typeUO)
      CHK:TCHKPstw;
      source,TopSync:Tvector;
      Mlist:TmatList;

      tau1,tau2:integer;
      dt:float;
      nbt:integer;
      DTmesure:float;

      Nx,Ny,Nz,Ntau:integer;
      topEvt:boolean;

      Gvalues:array of TGvalues;
      cycleCount:integer;
      EvtTimes:array of double;
      Fpsth:boolean;
      psth:Tpsth;
      Lclasse:float;

      pgGetK:Tpg2Event;

      I1s,I2s,J1s,J2s:integer;
      tbStim:array of array of array of double;
      tbSig:array of array of double;

      Nbefore,Nafter:integer;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;
      procedure processMessage(id:integer;src:typeUO;p:pointer);override;
      procedure setChildNames;override;

      procedure Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse1:float;Nbt1:integer);

      procedure InstallTimes;
      function CorrectTimes:boolean;
      function installSources(src,top:Tvector;mat:TmatList;topEvt1:boolean):float;
      procedure selectRegion(I1,J1,I2,J2:integer);

      procedure setGvalues(min1,max1:float;state1:integer;Amp1:float;flag1:integer);

      procedure BuildMatSline(t:integer);
      procedure BuildBXline(t:integer);

      procedure updateSources(src,top:Tvector;mat:TmatList);
      Procedure Solve(Fkeep:boolean);
      Procedure GetVector(x,y,z:integer; vec: Tvector;raw,norm:boolean);
      Procedure SetVector(x,y,z:integer; vec: Tvector);

      Procedure BuildSignal(vec,top:Tvector;mat:TmatList;topEvt1:boolean);
      function getK(tt,z:integer;w:float):float;

    end;

procedure proTchkSolverXY_create(name:AnsiString;var pu:typeUO);pascal;
function fonctionTchkSolverXY_installSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO):float;pascal;
function fonctionTchkSolverXY_installSources_1(var src,sync:Tvector;var Mlist1:TmatList;TopIsEvt:boolean;var pu:typeUO):float;pascal;

procedure proTchkSolverXY_selectRegion(I1,J1,I2,J2:integer;var pu:typeUO);pascal;

procedure proTchkSolverXY_updateSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO);pascal;

procedure proTchkSolverXY_Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse:float;var pu:typeUO); pascal;
procedure proTchkSolverXY_Init_1(t1,t2,Ns1:integer;modePsth:boolean;Lclasse:float;nbt1:integer;var pu:typeUO);pascal;

procedure proTchkSolverXY_setGvalues(min1,max1:float;state1:integer;Amp1:float;flag1:integer;var pu:typeUO);pascal;

procedure proTchkSolverXY_Solve(var pu:typeUO);pascal;
procedure proTchkSolverXY_Solve_1(Fkeep:boolean;var pu:typeUO);pascal;


procedure proTchkSolverXY_GetVector(x,y,z:integer;var vec: Tvector;raw,norm:boolean; var pu:typeUO);pascal;
procedure proTchkSolverXY_SetVector(x,y,z:integer;var vec: Tvector; var pu:typeUO);pascal;

function fonctionTchkSolverXY_matH(var pu:typeUO):pointer; pascal;
function fonctionTchkSolverXY_matB(var pu:typeUO):pointer; pascal;
function fonctionTchkSolverXY_matX(var pu:typeUO):pointer; pascal;

procedure proTchkSolverXY_lambda(w:float; var pu:typeUO);  pascal;
function fonctionTchkSolverXY_lambda(var pu:typeUO):float; pascal;
procedure proTCHKsolverXY_BuildSignal(var vec, top: Tvector; var mat: TmatList;var pu:typeUO);pascal;
procedure proTCHKsolverXY_BuildSignal_1(var vec, top: Tvector; var mat: TmatList;topEvt1:boolean;var pu:typeUO);pascal;

procedure proTchkSolverXY_getK(w:integer;var pu:typeUO);pascal;
function fonctionTchkSolverXY_getK(var pu:typeUO):integer;pascal;
procedure proTchkSolverXY_clearMats(var pu:typeUO);pascal;

procedure proTchkSolverXY_BlockSize(n:integer;var pu:typeUO);pascal;
function fonctionTchkSolverXY_BlockSize(var pu:typeUO):integer;pascal;

procedure proTchkSolverXY_NormalizeBlock(w:boolean;var pu:typeUO);pascal;
function fonctionTchkSolverXY_NormalizeBlock(var pu:typeUO):boolean;pascal;

procedure proTchkSolverXY_Nbefore(w:integer; var pu:typeUO);pascal;
function fonctionTchkSolverXY_Nbefore(var pu:typeUO):integer;pascal;

procedure proTchkSolverXY_Nafter(w:integer; var pu:typeUO);pascal;
function fonctionTchkSolverXY_Nafter(var pu:typeUO):integer;pascal;


implementation

constructor TCHKsolverXY.create;
begin
  inherited;
  CHK:=TCHKPstw.create;

  addToChildList(chk.MatH);
  addToChildList(chk.pstw);
  addToChildList(chk.XX);

  psth:=Tpsth.create;
  psth.notPublished:=true;
end;

destructor TCHKsolverXY.destroy;
begin
  installSources(nil,nil,nil,false);

  chk.free;
  psth.free;
  inherited;
end;

class function TCHKsolverXY.STMClassName:AnsiString;
begin
  result:='ChkSolverXY';
end;

procedure TCHKsolverXY.setChildNames;
begin
  chk.setChildNames(ident);
end;

procedure TCHKsolverXY.processMessage(id:integer;src:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);

  case id of
    UOmsg_invalidateData:
      begin
        if (src=source) or (src=topSync) then
          begin
          end;
      end;

    UOmsg_destroy:
      begin
        if (src=source) then
        begin
          source:=nil;
          derefObjet(src);
        end;
        if (src=topSync) then
        begin
          topSync:=nil;
          derefObjet(src);
        end;
        if (src=Mlist) then
        begin
          Mlist:=nil;
          derefObjet(src);
        end;
      end;
  end;
end;

function TCHKsolverXY.installSources(src,top:Tvector;mat:TmatList;topEvt1:boolean):float;
begin

  derefObjet(typeUO(source));
  source:=src;
  refObjet(typeUO(source));

  derefObjet(typeUO(topSync));
  topSync:=top;
  refObjet(typeUO(topSync));

  derefObjet(typeUO(Mlist));
  Mlist:=mat;
  refObjet(typeUO(Mlist));

  if assigned(Mlist) and (Mlist.count>0) then
  begin
    I1s:=Mlist.Mat[1].Istart;
    I2s:=Mlist.Mat[1].Iend;
    J1s:=Mlist.Mat[1].Jstart;
    J2s:=Mlist.Mat[1].Jend;

    Nx:=I2s-I1s+1;
    Ny:=J2s-J1s+1;
    cycleCount:=Mlist.count;
  end
  else
  begin
    Nx:=0;
    Ny:=0;
    cycleCount:=0;
  end;

  DTmesure:=0;
  topEvt:=topEvt1;
  if assigned(source) then installTimes;
  result:=DTmesure;

  if assigned(source) then
  begin
    if Fpsth then
    begin
      nbt:=round(DTmesure/Lclasse);
      dt:=DTmesure/nbt;
    end
    else
    begin
      dt:=Source.dxu;
      nbt:=round(DTmesure/dt);
    end;
  end;
  
end;

procedure TchkSolverXY.selectRegion(I1,J1,I2,J2:integer);
begin
  I1s:=I1;
  I2s:=I2;
  J1s:=J1;
  J2s:=J2;

  Nx:=I2-I1+1;
  Ny:=J2-J1+1;
end;

{Remplit EVTtimes}
procedure TchkSolverXY.InstallTimes;
var
  i,cnt:integer;
begin
  { Si TopSync n'est pas un vecteur d'événements, on détecte les franchissement du seuil 0.5
    On exclut les dix premières millisecondes.
  }
  if not topEvt then
  begin
    setLength(EvtTimes,Mlist.count);

    cnt:=0;
    with topSync do
    for i:=invconvx(Xstart+10) to Iend do
    if (Yvalue[i]>0.5) and (Yvalue[i-1]<0.5) then
    begin
      if cnt>high(EvtTimes) then setLength(EvtTimes,cnt+1);
      EvtTimes[cnt]:=i*dxu+x0u;
      inc(cnt);
    end;
    setLength(EvtTimes,cnt);
  end
  else
  with topSync do
  begin
    setLength(EvtTimes,Icount);
    for i:=Istart to Iend do EvtTimes[i-Istart]:=Yvalue[i];
    cnt:=Icount;
  end;

  if cnt>cycleCount then
  begin
    if not correctTimes
      then sortieErreur('TchkSolverXY: installTimes failed');
  end
  else
  if cnt<cycleCount then sortieErreur('TchkSolverXY: installTimes failed : cycleCount>top count ');

  DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);
end;

function TchkSolverXY.CorrectTimes:boolean;
var
  i:integer;
  dt1,dtM,delta:float;
begin
  dtM:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);

  i:=0;
  while i<high(EvtTimes) do
  begin
    dt1:=EvtTimes[i+1]-EvtTimes[i];
    if dt1 > dtM+2 then
    begin
      setLength(EvtTimes,length(EvtTimes)+1);
      move(EvtTimes[i],EvtTimes[i+1],sizeof(EvtTimes[0])*(high(EvtTimes)-i));
      EvtTimes[i]:=EvtTimes[i]+round(dt1);
    end
    else
    if dt1<dtM-2 then
    begin
      move(EvtTimes[i+2],EvtTimes[i+1],sizeof(EvtTimes[0])*(high(EvtTimes)-i-1));
      setLength(EvtTimes,length(EvtTimes)-1);
    end;
    inc(i);
  end;
  result:=(cycleCount=length(EvtTimes));
end;


procedure TCHKsolverXY.Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse1:float;nbt1:integer);
begin
  tau1:=t1;
  tau2:=t2;
  Nz:=Ns1;
  ntau:=tau2-tau1+1;

  if not assigned(source) and (nbt1=0) then exit;

  FPsth:=modePsth;
  Lclasse:=Lclasse1;

  if nbt1>0 then
  begin
    Nbt:=Nbt1;
    dt:=1;
  end
  else
  if Fpsth then
  begin
    nbt:=round(DTmesure/Lclasse);
    dt:=DTmesure/nbt;
  end
  else
  begin
    dt:=Source.dxu;
    nbt:=round(DTmesure/dt);
  end;

  chk.Init(Nx*Ny*Nz*Ntau,Nbt);

  psth.initTemp(0,nbt,g_longint,dt);
end;


procedure TCHKsolverXY.setGvalues(min1,max1:float;state1:integer;Amp1:float;flag1:integer);
const
  epsilon=1E-10;
begin
  setLength(Gvalues,length(Gvalues)+1);
  with Gvalues[high(Gvalues)] do
  begin
    min:=min1-epsilon;
    max:=max1+epsilon;
    state:=state1;
    Amp:=Amp1;
    flag:=flag1;
  end;
end;


procedure TCHKsolverXY.BuildMatSline(t:integer);
var
  x,y,k,l,z:integer;
  w:float;
  code:integer;
begin
  chk.clearMatSline;

  for k:=tau1 to tau2 do
  begin
    if (t-k>=0) and (t-k<cycleCount) then
    with Mlist.mat[t-k+1] do
    begin
      for x:=0 to Nx-1 do
      for y:=0 to Ny-1 do
      begin
        w:=Zvalue[I1s+x,J1s+y];
        for l:=0 to high(Gvalues) do
        with Gvalues[l] do
        if (w>=min) and (w<=max) then
        begin
          case flag of
            0:  begin
                  code:=k-tau1+ Ntau*(state+Nz*(y+ny*x));
                  chk.MatSline[code]:=Amp;
                end;
            1:  begin
                  code:=k-tau1+ Ntau*(state+Nz*(y+ny*x));
                  chk.MatSline[code]:=w;
                end;
            2:  begin
                  code:=k-tau1+ Ntau*(state+Nz*(y+ny*x));
                  chk.MatSline[code]:=-w;
                end;
            3:  begin
                  code:=k-tau1+ Ntau*(state+Nz*(y+ny*x));
                  chk.MatSline[code]:=getK(t,state,w);
                end;
            4:  begin
                  code:=k-tau1+ Ntau*(state+Nz*(y+ny*x));
                  chk.MatSline[code]:=sqr(w);
                end;
          end;
          break;
        end;
      end;

    end;
  end;
end;

procedure TCHKsolverXY.BuildBXline(t:integer);
var
  j,k,index:integer;
  time0:double;
begin
  if t<0 then time0:=EvtTimes[0]+t*DTmesure
  else
  if t>=cycleCount then time0:=EvtTimes[cycleCount-1]+ (t-cycleCount+1)*DTmesure
  else time0:=EvtTimes[t];

  chk.clearBXline;

  if not FPsth then
  for j:=0 to nbt-1 do
    chk.BXline[j]:=source.Rvalue[time0+j*dt]
  else
  begin
    Psth.clear;
    psth.AddEx(source,time0);
    for j:=0 to nbt-1 do
      chk.BXline[j]:=psth.Yvalue[j];
  end;
end;


procedure TCHKsolverXY.updateSources(src,top:Tvector;mat:TmatList);
var
  i:integer;
begin
  if not assigned(src) or (src.dxu<>source.Dxu)
    then sortieErreur('TCHKsolverXY.updateSources error');

  if not assigned(top) or (top.dxu<>topSync.Dxu)
    then sortieErreur('TCHKsolverXY.updateSources error');

  if not assigned(mat) or (mat.count<1) or (mat.Mat[1].Icount<>Nx)
     or (mat.Mat[1].Jcount<>Ny)
    then sortieErreur('TCHKsolverXY.updateSources error');

  derefObjet(typeUO(source));
  source:=src;
  refObjet(typeUO(source));

  derefObjet(typeUO(topSync));
  topSync:=top;
  refObjet(typeUO(topSync));

  derefObjet(typeUO(Mlist));
  Mlist:=mat;
  refObjet(typeUO(Mlist));

  cycleCount:=Mlist.count;

  installTimes;


  {calculH;}

  for i:=Nbefore to cycleCount-1+Nafter do
  begin
    BuildMatSline(i);
    BuildBXline(i);
    chk.UpdateHessian;
  end;

end;


Procedure TCHKsolverXY.Solve(Fkeep:boolean);
begin
  chk.Solve(Fkeep);
end;

Procedure TCHKsolverXY.GetVector(x,y,z:integer; vec: Tvector;raw,norm:boolean);
var
  code:integer;
begin
  if Fpsth
    then vec.Dxu:=Lclasse
    else vec.Dxu:=source.dxu;
  vec.X0u:=0;
  code:=ntau*(z+nz*(y+ny*x));
  chk.getVector(code,ntau,vec,raw,norm);
end;

Procedure TCHKsolverXY.SetVector(x,y,z:integer; vec: Tvector);
var
  code:integer;
begin
  code:=ntau*(z+nz*(y+ny*x));
  chk.setVector(code,ntau,vec);
end;


procedure TCHKsolverXY.BuildSignal(vec, top: Tvector; mat: TmatList;topEvt1:boolean);
var
  i,j,j0:integer;
  tt,tmax:double;
begin
  {on ne touche pas à la source}

  derefObjet(typeUO(topSync));
  topSync:=top;
  refObjet(typeUO(topSync));

  derefObjet(typeUO(Mlist));
  Mlist:=mat;
  refObjet(typeUO(Mlist));

  if assigned(Mlist) and (Mlist.count>0) then
  begin
    I1s:=Mlist.Mat[1].Istart;
    I2s:=Mlist.Mat[1].Iend;
    J1s:=Mlist.Mat[1].Jstart;
    J2s:=Mlist.Mat[1].Jend;

    Nx:=I2s-I1s+1;
    Ny:=J2s-J1s+1;
    cycleCount:=Mlist.count;
  end
  else
  begin
    Nx:=0;
    Ny:=0;
    cycleCount:=0;
  end;

  topEvt:=topEvt1;
  installTimes;

  DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);

  if (dt=0) then dt:=vec.dxu;

  tmax:=EvtTimes[cycleCount-1] + DTmesure +100;

  vec.Dxu:=dt;          { Le dt est celui du calcul précédent }

  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);


  freeMKL;
  initMKLib;
  chk.BuildOutLine;

  for i:=-Nbefore to cycleCount-1+Nafter do
  begin
    BuildMatSline(i);
    chk.BuildOutLine;

    if i<0 then tt:=EvtTimes[0]+i*DTmesure
    else
    if i>=cycleCount then tt:=EvtTimes[cycleCount-1]+ (i-cycleCount+1)*DTmesure
    else tt:=EvtTimes[i];

    j0:=vec.invconvx(tt);
    for j:=0 to chk.Nt-1 do
    vec.Yvalue[j0+j]:=chk.outline[j];
  end;
end;

function TCHKsolverXY.getK(tt,z: integer; w: float): float;
begin
  with PgGetK do
    if valid then
      result:=pg.executerGetK(ad,tt,z,w);
end;


{************************** Méthodes STM ********************************************}


procedure proTchkSolverXY_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TchkSolverXY);
end;

function fonctionTchkSolverXY_installSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO):float;
begin
  result:=fonctionTchkSolverXY_installSources_1(src,sync,Mlist1,false,pu);
end;

function fonctionTchkSolverXY_installSources_1(var src,sync:Tvector;var Mlist1:TmatList;TopIsEvt:boolean;var pu:typeUO):float;
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteur(sync);
  verifierObjet(typeUO(Mlist1));

  result:=TchkSolverXY(pu).installSources(src,sync,Mlist1,TopIsEvt);
end;

procedure proTchkSolverXY_selectRegion(I1,J1,I2,J2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    if not assigned(Mlist) or (Mlist.count<1)
      then sortieErreur('TchkSolverXY.selectRegion : Mlist not installed');
    if (I1<Mlist.Mat[1].Istart) or (I2>Mlist.Mat[1].Iend) or
       (J1<Mlist.Mat[1].Jstart) or (J2>Mlist.Mat[1].Jend)
      then sortieErreur('TchkSolverXY.selectRegion : invalid region');
  end;

  TchkSolverXY(pu).selectRegion(I1,J1,I2,J2);
end;


procedure proTchkSolverXY_updateSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteur(sync);
  verifierObjet(typeUO(Mlist1));

  TchkSolverXY(pu).updateSources(src,sync,Mlist1);
end;


procedure proTchkSolverXY_Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse:float;var pu:typeUO);
begin
  verifierObjet(pu);

  TchkSolverXY(pu).Init(t1,t2,Ns1,modePsth,Lclasse,0);
end;

procedure proTchkSolverXY_Init_1(t1,t2,Ns1:integer;modePsth:boolean;Lclasse:float;nbt1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TchkSolverXY(pu).Init(t1,t2,Ns1,modePsth,Lclasse,nbt1);
end;


procedure proTchkSolverXY_setGvalues(min1,max1:float;state1:integer;Amp1:float;flag1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TchkSolverXY(pu).setGvalues(min1,max1,state1,Amp1,flag1);
end;

procedure proTchkSolverXY_Solve(var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXY(pu).Solve(false);
end;

procedure proTchkSolverXY_Solve_1(Fkeep:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXY(pu).Solve(Fkeep);
end;



procedure proTchkSolverXY_GetVector(x,y,z:integer;var vec: Tvector;raw,norm:boolean; var pu:typeUO);
begin
  verifierObjet(pu);

  with TchkSolverXY(pu) do
  begin
    x:=x-1;
    y:=y-1;
    if (x<0) or (x>=Nx) or (y<0) or (y>=Ny) or (z<0) or (z>=Nz)
      then sortieErreur('TchkSolverXY.GetVector : parameter out of range');

    GetVector(x,y,z,vec,raw,norm);
  end;
end;

procedure proTchkSolverXY_SetVector(x,y,z:integer;var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);

  with TchkSolverXY(pu) do
  begin
    x:=x-1;
    y:=y-1;
    if (x<0) or (x>=Nx) or (y<0) or (y>=Ny) or (z<0) or (z>=Nz)
      then sortieErreur('TchkSolverXY.SetVector : parameter out of range');

    SetVector(x,y,z,vec);
  end;
end;


function fonctionTchkSolverXY_matH(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TchkSolverXY(pu).CHK do
    result:=@matH;
end;

function fonctionTchkSolverXY_matB(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TchkSolverXY(pu).CHK do
    result:=@pstw;
end;

function fonctionTchkSolverXY_matX(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TchkSolverXY(pu).CHK do
    result:=@XX;
end;



procedure proTchkSolverXY_lambda(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXY(pu).CHK.lambda:=w;
end;

function fonctionTchkSolverXY_lambda(var pu:typeUO):float;
begin
  verifierObjet(pu);

  result:= TchkSolverXY(pu).CHK.lambda;
end;



procedure proTCHKsolverXY_BuildSignal(var vec, top: Tvector; var mat: TmatList;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  verifierVecteur(top);
  verifierObjet(typeUO(mat));

  TCHKsolverXY(pu).BuildSignal( vec, top, mat,false);
end;

procedure proTCHKsolverXY_BuildSignal_1(var vec, top: Tvector; var mat: TmatList;topEvt1:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  verifierVecteur(top);
  verifierObjet(typeUO(mat));

  TCHKsolverXY(pu).BuildSignal( vec, top, mat,topEvt1);
end;

procedure proTchkSolverXY_getK(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    PgGetK.setad(w);
  end;
end;

function fonctionTchkSolverXY_getK(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    result:=PgGetK.ad;
  end;
end;

procedure proTchkSolverXY_clearMats(var pu:typeUO);
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    chk.clearMats;
  end;
end;

procedure proTchkSolverXY_BlockSize(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if n<1 then sortieErreur('TchkSolverXY.BlockSize must be positive');

  with TchkSolverXY(pu) do
  begin
    chk.Mbloc:=n;
  end;
end;

function fonctionTchkSolverXY_BlockSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    result:=chk.Mbloc;
  end;
end;

procedure proTchkSolverXY_NormalizeBlock(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    chk.FnormaliseBloc:=w;
  end;
end;

function fonctionTchkSolverXY_NormalizeBlock(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TchkSolverXY(pu) do
  begin
    result:=chk.FNormaliseBloc;
  end;
end;


procedure proTchkSolverXY_Nbefore(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXY(pu).Nbefore:=w;
end;

function fonctionTchkSolverXY_Nbefore(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TchkSolverXY(pu).Nbefore;
end;


procedure proTchkSolverXY_Nafter(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXY(pu).Nafter:=w;
end;

function fonctionTchkSolverXY_Nafter(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TchkSolverXY(pu).Nafter;
end;


Initialization
AffDebug('Initialization stmchkXY',0);

RegisterObject(TCHKSolverXY,data);


end.
