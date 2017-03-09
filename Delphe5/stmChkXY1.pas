unit stmChkXY1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,listG, debug0,
     stmDef,stmObj,stmVec1,stmPsth1,stmPg,NcDef2,
     mathKernel0,stmKLmat,stmMlist;

type
  TGvalues=record
             min,max:float;
             state:integer;
             Amp:float;
             flag:integer;
           end;

  TchkSolverXYB=
    class(typeUO)
      MatH:Tmat;    { La hessienne    matH = matS' * matS   }
      pstw:  Tmat;  { Les pstw bruts  pstw = matS' * matB   }
      XX:  Tmat;    { Les pstw vrais (résultats) }
      lambda:float;

      Ni,Nt:integer;

      source,TopSync:Tvector;
      Mlist:TmatList;

      tau1,tau2:integer;
      dt:float;
      nbt:integer;
      DTmesure:float;

      Nx,Ny,Nz,Ntau:integer;

      Gvalues:array of TGvalues;
      cycleCount:integer;
      EvtTimes:array of double;
      Fpsth:boolean;
      psth:Tpsth;
      Lclasse:float;

      pgGetK:Tpg2Event;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;
      procedure processMessage(id:integer;src:typeUO;p:pointer);override;
      procedure setChildNames;override;

      procedure Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse1:float);

      procedure InstallTimes;
      function CorrectTimes:boolean;
      function installSources(src,top:Tvector;mat:TmatList):float;

      procedure updateHessian(mat:TmatList);
      procedure updateSources(src,top:Tvector;mat:TmatList);
      Procedure Solve;
      Procedure GetVector(x,y,z:integer; vec: Tvector;raw,norm:boolean);
      Procedure SetVector(x,y,z:integer; vec: Tvector);

      Procedure BuildSignal(vec,top:Tvector;mat:TmatList);
      function getK(tt,z:integer;w:float):float;
    end;

procedure proTchkSolverXYB_create(name:AnsiString;var pu:typeUO);pascal;
function fonctionTchkSolverXYB_installSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO):float;pascal;
procedure proTchkSolverXYB_updateSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO);pascal;
procedure proTchkSolverXYB_Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse:float;var pu:typeUO); pascal;
procedure proTchkSolverXYB_setGvalues(min1,max1:float;state1:integer;Amp1:float;flag1:integer;var pu:typeUO);pascal;
procedure proTchkSolverXYB_Solve(var pu:typeUO);pascal;
procedure proTchkSolverXYB_GetVector(x,y,z:integer;var vec: Tvector;raw,norm:boolean; var pu:typeUO);pascal;
procedure proTchkSolverXYB_SetVector(x,y,z:integer;var vec: Tvector; var pu:typeUO);pascal;

function fonctionTchkSolverXYB_matH(var pu:typeUO):pointer; pascal;
function fonctionTchkSolverXYB_matB(var pu:typeUO):pointer; pascal;
function fonctionTchkSolverXYB_matX(var pu:typeUO):pointer; pascal;

procedure proTchkSolverXYB_lambda(w:float; var pu:typeUO);  pascal;
function fonctionTchkSolverXYB_lambda(var pu:typeUO):float; pascal;
procedure proTchkSolverXYB_BuildSignal(var vec, top: Tvector; var mat: TmatList;var pu:typeUO);pascal;

procedure proTchkSolverXYB_getK(w:integer;var pu:typeUO);pascal;
function fonctionTchkSolverXYB_getK(var pu:typeUO):integer;pascal;

implementation

constructor TchkSolverXYB.create;
begin
  inherited;
  MatH:=Tmat.create(G_double,0,0);
  pstw:=Tmat.create(G_double,0,0);
  XX:=Tmat.create(G_double,0,0);

  matH.NotPublished:=true;
  pstw.NotPublished:=true;
  XX.NotPublished:=true;


  addToChildList(MatH);
  addToChildList(pstw);
  addToChildList(XX);

  psth:=Tpsth.create;
  psth.notPublished:=true;
end;

destructor TchkSolverXYB.destroy;
begin
  installSources(nil,nil,nil);

  MatH.Free;
  pstw.free;
  XX.free;

  psth.free;
  inherited;
end;

class function TchkSolverXYB.STMClassName:AnsiString;
begin
  result:='ChkSolverXYB';
end;

procedure TchkSolverXYB.setChildNames;
begin
  matH.ident:=ident+'.matH';
  pstw.ident:=ident+'.matB';
  XX.ident:=ident+'.matX';
end;

procedure TchkSolverXYB.processMessage(id:integer;src:typeUO;p:pointer);
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

function TchkSolverXYB.installSources(src,top:Tvector;mat:TmatList):float;
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
    Nx:=Mlist.Mat[1].Icount;
    Ny:=Mlist.Mat[1].Jcount;
    cycleCount:=Mlist.count;
  end
  else
  begin
    Nx:=0;
    Ny:=0;
    cycleCount:=0;
  end;

  DTmesure:=0;
  if assigned(source) then installTimes;
  result:=DTmesure;
end;

procedure TchkSolverXYB.InstallTimes;
var
  i,cnt:integer;
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

  if cnt>cycleCount then
  begin
    if not correctTimes
      then sortieErreur('TchkSolverXYB: installTimes failed');
  end
  else
  if cnt<cycleCount then sortieErreur('TchkSolverXYB: installTimes failed : cycleCount>top count ');

  DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);
end;

function TchkSolverXYB.CorrectTimes:boolean;
var
  i:integer;
  dt,dtM,delta:float;
begin
  dtM:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);

  i:=0;
  while i<high(EvtTimes) do
  begin
    dt:=EvtTimes[i+1]-EvtTimes[i];
    if dt > dtM+2 then
    begin
      setLength(EvtTimes,length(EvtTimes)+1);
      move(EvtTimes[i],EvtTimes[i+1],sizeof(EvtTimes[0])*(high(EvtTimes)-i));
      EvtTimes[i]:=EvtTimes[i]+round(dt);
    end
    else
    if dt<dtM-2 then
    begin
      move(EvtTimes[i+2],EvtTimes[i+1],sizeof(EvtTimes[0])*(high(EvtTimes)-i-1));
      setLength(EvtTimes,length(EvtTimes)-1);
    end;
    inc(i);
  end;
  result:=(cycleCount=length(EvtTimes));
end;


procedure TchkSolverXYB.Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse1:float);
begin
  tau1:=t1;
  tau2:=t2;
  Nz:=Ns1;
  ntau:=tau2-tau1+1;

  if not assigned(source) then exit;

  FPsth:=modePsth;
  Lclasse:=Lclasse1;

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

  Ni:=Nx*Ny*Nz*Ntau;
  Nt:=Nbt;

  MatH.setSize(Ni,Ni);
  matH.clear;
  pstw.setSize(Ni,Nt);
  pstw.clear;
  XX.setSize(Ni,Nt);
  XX.clear;


  psth.initTemp(0,nbt,g_longint,dt);
end;

procedure TchkSolverXYB.updateHessian(mat:TmatList);
var
  i,j,k:integer;
  BXline:array of double;
begin
  { code= y + Ny*x + Nx*Ny*tau }
  { mat doit être formée de réels doubles et contenir +1 et -1 }

  setLength(BXline,nbt);

  with mat do
  for k:=0 to count-1 do
  for i:=0 to Ntau-1 do
  for j:=0 to Ntau-1 do
  if (k-i>=0) and (k-j>=0) and (i<=j) then
    dger(Nx*Ny, Nx*Ny,1, mat[k-i+1].tb,1,mat[k-j+1].tb,1, matH.getP(i*Nx*Ny+1,j*Nx*Ny+1), Ni);


  with mat do
  for i:=0 to count-1 do
  begin
    if not FPsth then
    for j:=0 to nbt-1 do
      BXline[j]:=source.Rvalue[EvtTimes[i]+j*dt]
    else
    begin
      Psth.clear;
      psth.AddEx(source,EvtTimes[i]);
      for j:=0 to nbt-1 do
        BXline[j]:=psth.Yvalue[j];
    end;

    for j:=0 to Ntau-1 do
    if (i-j>=0) then
      dger(Nx*Ny, Nt,1, mat[i-j+1].tb,1,@BXline[0],1, pstw.getP(j*Nx*Ny+1,1), Ni);
  end;
end;

procedure TchkSolverXYB.updateSources(src,top:Tvector;mat:TmatList);
var
  i:integer;
begin
  if not assigned(src) or (src.dxu<>source.Dxu)
    then sortieErreur('TchkSolverXYB.updateSources error');
  if not assigned(top) or (top.dxu<>topSync.Dxu)
    then sortieErreur('TchkSolverXYB.updateSources error');
  if not assigned(mat) or (mat.count<1) or (mat.Mat[1].Icount<>Mlist.Mat[1].Icount)
     or (mat.Mat[1].Jcount<>Mlist.Mat[1].Jcount)
    then sortieErreur('TchkSolverXYB.updateSources error');

  derefObjet(typeUO(source));
  source:=src;
  refObjet(typeUO(source));

  derefObjet(typeUO(topSync));
  topSync:=top;
  refObjet(typeUO(topSync));

  derefObjet(typeUO(Mlist));
  Mlist:=mat;
  refObjet(typeUO(Mlist));

  Nx:=Mlist.Mat[1].Icount;
  Ny:=Mlist.Mat[1].Jcount;
  cycleCount:=Mlist.count;

  installTimes;


  UpdateHessian(Mlist);

end;


Procedure TchkSolverXYB.Solve;
var
  i:integer;
begin
  if lambda<>0 then
  with matH do
  for i:=1 to RowCount do matH[i,i]:=matH[i,i]+lambda;

  matH.solveCHK(pstw,XX);
end;

Procedure TchkSolverXYB.GetVector(x,y,z:integer; vec: Tvector;raw,norm:boolean);
var
  code,i,k:integer;
begin
  vec.Dxu:=source.dxu;
  vec.X0u:=0;

  if vec.Icount<>Nt*ntau then
    vec.initTemp1(vec.Istart,vec.Istart+Nt*Ntau-1,vec.tpNum);


  for k:=0 to nTau-1 do
  begin
    code:= y + Ny*x + Nx*Ny*k;
    for i:=0 to nt-1 do
      vec.Yvalue[vec.Istart+i+nt*k]:=XX[code+1,i+1];
  end;
end;

Procedure TchkSolverXYB.SetVector(x,y,z:integer; vec: Tvector);
var
  code:integer;
begin
  code:=ntau*(z+nz*(y+ny*x));
  {chk.setVector(code,ntau,vec);}
end;


procedure TchkSolverXYB.BuildSignal(vec, top: Tvector; mat: TmatList);
var
  i,j,j0:integer;
  tt,tmax:double;
begin

end;

function TchkSolverXYB.getK(tt,z: integer; w: float): float;
begin
  with PgGetK do
    if valid then
      result:=pg.executerGetK(ad,tt,z,w);
end;


{************************** Méthodes STM ********************************************}


procedure proTchkSolverXYB_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TchkSolverXYB);
end;

function fonctionTchkSolverXYB_installSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO):float;
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteur(sync);
  verifierObjet(typeUO(Mlist1));

  result:=TchkSolverXYB(pu).installSources(src,sync,Mlist1);
end;

procedure proTchkSolverXYB_updateSources(var src,sync:Tvector;var Mlist1:TmatList;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteur(sync);
  verifierObjet(typeUO(Mlist1));

  TchkSolverXYB(pu).updateSources(src,sync,Mlist1);
end;


procedure proTchkSolverXYB_Init(t1,t2,Ns1:integer;modePsth:boolean;Lclasse:float;var pu:typeUO);
begin
  verifierObjet(pu);

  TchkSolverXYB(pu).Init(t1,t2,Ns1,modePsth,Lclasse);
end;

procedure proTchkSolverXYB_setGvalues(min1,max1:float;state1:integer;Amp1:float;flag1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  {TchkSolverXYB(pu).setGvalues(min1,max1,state1,Amp1,flag1);}
end;

procedure proTchkSolverXYB_Solve(var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXYB(pu).Solve;
end;

procedure proTchkSolverXYB_GetVector(x,y,z:integer;var vec: Tvector;raw,norm:boolean; var pu:typeUO);
begin
  verifierObjet(pu);

  with TchkSolverXYB(pu) do
  begin
    x:=x-1;
    y:=y-1;
    if (x<0) or (x>=Nx) or (y<0) or (y>=Ny) or (z<0) or (z>=Nz)
      then sortieErreur('TchkSolverXYB.GetVector : parameter out of range');

    GetVector(x,y,z,vec,raw,norm);
  end;
end;

procedure proTchkSolverXYB_SetVector(x,y,z:integer;var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);

  with TchkSolverXYB(pu) do
  begin
    x:=x-1;
    y:=y-1;
    if (x<0) or (x>=Nx) or (y<0) or (y>=Ny) or (z<0) or (z>=Nz)
      then sortieErreur('TchkSolverXYB.SetVector : parameter out of range');

    SetVector(x,y,z,vec);
  end;
end;


function fonctionTchkSolverXYB_matH(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TchkSolverXYB(pu) do
    result:=@matH;
end;

function fonctionTchkSolverXYB_matB(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TchkSolverXYB(pu) do
    result:=@pstw;
end;

function fonctionTchkSolverXYB_matX(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TchkSolverXYB(pu) do
    result:=@XX;
end;



procedure proTchkSolverXYB_lambda(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TchkSolverXYB(pu).lambda:=w;
end;

function fonctionTchkSolverXYB_lambda(var pu:typeUO):float;
begin
  verifierObjet(pu);

  result:= TchkSolverXYB(pu).lambda;
end;

procedure proTCHKsolverXYB_BuildSignal(var vec, top: Tvector; var mat: TmatList;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  verifierVecteur(top);
  verifierObjet(typeUO(mat));

  TchkSolverXYB(pu).BuildSignal( vec, top, mat);
end;

procedure proTchkSolverXYB_getK(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TchkSolverXYB(pu) do
  begin
    PgGetK.setad(w);
  end;
end;

function fonctionTchkSolverXYB_getK(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TchkSolverXYB(pu) do
  begin
    result:=PgGetK.ad;
  end;
end;


Initialization
AffDebug('Initialization stmChkXY1',0);

RegisterObject(TchkSolverXYB,data);


end.
