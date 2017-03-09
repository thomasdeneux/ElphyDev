unit Kernels;

interface

uses windows,math, classes,
     util1, ipps,
     stmObj, ncDef2,stmPg,
     stmvec1,stmMat1,stmOdat2, stmOIseq1;


procedure proBuildKernel1(var stim:TvectorArray;var Vm: Tvector;Ntau:integer; var VA,VAnorm:TVectorArray; First:boolean);pascal;
procedure proBuildKernel2(var stim:TvectorArray;var Vm: Tvector; Ntau:integer;var mat2:Tmatrix;var Mnorm2: Tmatrix; First:boolean);pascal;

implementation

uses stmAveA1;
{
  stim contient des vecteurs de single , mêmes Istart Iend, avec Dx égal au DeltaTau souhaité.
  Vm a le même Dx , les mêmes indices Istart Iend
  Dans les calculs, on oublie Ntau points aux extrémités.

}

procedure BuildKernel2(stim:TvectorArray;Vm: Tvector; mat2,Mnorm2: Tmatrix; Ntau:integer;First:boolean);
var
  i1,i2,j1,j2,tau1,tau2,k1,k2: integer;
  imin,imax,jmin,jmax:integer;
  N,Ni,Nj:integer;

  p1,p2,pVm: Psingle;
  Len: integer;
  dum: array of single;
  w,wnorm:single;
  D:integer;
begin
  IPPStest;

  TRY
  imin:=stim.imin;
  imax:=stim.imax;
  jmin:=stim.jmin;
  jmax:=stim.jmax;

  Ni:=imax-imin+1;
  Nj:=jmax-jmin+1;
  N:= Ni*Nj*Ntau;


  if first then
  begin
    if assigned(mat2) then
    begin
      mat2.modify(g_double,0,0,N-1,N-1);
      Mnorm2.modify(g_double,0,0,N-1,N-1);
    end;
  end;

  pVm:=@PtabSingle(Vm.tb)^[Vm.Istart+Ntau-1];
  len:=Vm.Icount-Ntau;
  setLength(dum,len);

(*
  for i1:=0 to Ni-1 do
  for j1:=0 to Nj-1 do
  begin
    if testEscape then exit;
    for i2:=0 to Ni-1 do
    for j2:=0 to Nj-1 do
    for tau1:=0 to Ntau-1 do
    for tau2:=0 to Ntau-1 do
    begin
      k1:=tau1+Ntau*j1+Ntau*Nj*i1;
      k2:=tau2+Ntau*j2+Ntau*Nj*i2;

      p1:=@PtabSingle(stim[imin+i1,jmin+j1].tb)^[Ntau-1-tau1];
      p2:=@PtabSingle(stim[imin+i2,jmin+j2].tb)^[Ntau-1-tau2];

      if k1>=k2 then
      begin
        ippsMul_32f(p1,p2,@dum[0],len);
        ippsDotProd_32f(@dum[0],pVm,len,@w);
        mat2.AddE(k1,k2,w);
        mat2.AddE(k2,k1,w);
      end;
    end;
  end;
*)

  for i1:=0 to Ni-1 do
  for j1:=0 to Nj-1 do
  begin
    if testEscape then exit;
    for i2:=0 to Ni-1 do
    for j2:=0 to Nj-1 do
    for D:=-Ntau+1 to Ntau-1 do
    begin
      if D>=0 then
      begin
        p1:=@PtabSingle(stim[imin+i1,jmin+j1].tb)^[D];
        p2:=@PtabSingle(stim[imin+i2,jmin+j2].tb)^[0];
      end
      else
      begin
        p1:=@PtabSingle(stim[imin+i1,jmin+j1].tb)^[0];
        p2:=@PtabSingle(stim[imin+i2,jmin+j2].tb)^[-D];
      end;

      ippsMul_32f(p1,p2,@dum[0],len);
      ippsNorm_L2_32f(@dum[0],len,@wnorm);

      if wnorm>0 then
      for tau1:= max(0,-D) to min(Ntau-1,Ntau-1-D) do
      begin
        tau2:=tau1+D;
        k1:=tau1+Ntau*j1+Ntau*Nj*i1;
        k2:=tau2+Ntau*j2+Ntau*Nj*i2;

        if k1>=k2 then
        begin
          //ippsDotProd_32f(@dum[Ntau-tau1],pVm,len,@w);
          ippsDotProd_32f(@dum[Ntau-1-tau1-D],pVm,len,@w);

          mat2.AddE(k1,k2,w);
          if k1<>k2 then mat2.AddE(k2,k1,w);

          Mnorm2.addE(k1,k2,sqr(wNorm));
          if k1<>k2 then Mnorm2.addE(k2,k1,sqr(wnorm));
        end;
      end;
    end;
  end;


  FINALLY
  IPPSend;
  END;
end;

procedure BuildKernel1(stim:TvectorArray;Vm: Tvector;VA,VAnorm:TVectorArray; Ntau:integer;First:boolean);
var
  i1,i2,j1,j2,tau1,tau2,k1,k2: integer;
  imin,imax,jmin,jmax:integer;
  N,Ni,Nj:integer;

  p1,p2,pVm: Psingle;
  Len: integer;
  w,wnorm:single;
  D:integer;
  Tdum1, Tdum2: array of single;
begin
  IPPStest;

  TRY
  imin:=stim.imin;
  imax:=stim.imax;
  jmin:=stim.jmin;
  jmax:=stim.jmax;

  Ni:=imax-imin+1;
  Nj:=jmax-jmin+1;
  N:= Ni*Nj*Ntau;


  if first or (Va.imin<>imin)or (Va.imax<>imax)  or (Va.jmin<>jmin) or (Va.jmax<>jmax) then
  begin
    Va.initArray(imin,imax,jmin,jmax);
    if va is TaverageArray
      then TaverageArray(va).initAverages(0,Ntau-1,g_single)
      else Va.initVectors(0,Ntau-1,g_single);
    Va.Dxu:=Vm.Dxu;

    VaNorm.initArray(imin,imax,jmin,jmax);
    if vaNorm is TaverageArray
      then TaverageArray(vaNorm).initAverages(0,Ntau-1,g_single)
      else VaNorm.initVectors(0,Ntau-1,g_single);
    VaNorm.Dxu:=Vm.Dxu;
  end;

  pVm:=@PtabSingle(Vm.tb)^[Vm.Istart+Ntau-1];
  len:=Vm.Icount-Ntau;

  setlength(Tdum1,Ntau);
  setlength(Tdum2,Ntau);
  pVm:=@PtabSingle(Vm.tb)^[Vm.Istart];

  for i1:=0 to Ni-1 do
  for j1:=0 to Nj-1 do
  begin
    //p1:=@PtabSingle(stim[imin+i1,jmin+j1].tb)^[Ntau];
    //ippsNorm_L2_32f(p1,len,@wnorm);
    //wnorm:=sqr(wnorm);

    p1:=@PtabSingle(stim[imin+i1,jmin+j1].tb)^[0];
    ippsCrossCorr_32f(p1,len,pVm,len,@Tdum1[0],Ntau,0);
    ippsDotProd_32f(p1,p1,len,@w);

    for tau1:=0 to Ntau-1 do
    begin
      va[imin+i1,jmin+j1].AddE(tau1,Tdum1[tau1]);
      vaNorm[imin+i1,jmin+j1].AddE(tau1,w);
    end;

    (*
    for tau1:=0 to Ntau-1 do
    begin
      p1:=@PtabSingle(stim[imin+i1,jmin+j1].tb)^[Ntau-tau1-1];
      ippsDotProd_32f(p1,pVm,len,@w);
      va[imin+i1,jmin+j1].AddE(tau1,w);

      ippsDotProd_32f(p1,p1,len,@w);
      vaNorm[imin+i1,jmin+j1].AddE(tau1,w);
    end;
    *)
  end;

  FINALLY
  IPPSend;
  END;
end;



procedure proBuildKernel1(var stim:TvectorArray;var Vm: Tvector;Ntau:integer; var VA,VAnorm:TVectorArray; First:boolean);
var
  i,j:integer;
  tp0:typetypeG;
  is1,is2:integer;
  ok: boolean;

begin
  verifierObjet(typeUO(stim));
  with stim do
  begin
    tp0:=vector[Imin,Jmin].tpNum;
    is1:=vector[Imin,Jmin].Istart;
    is2:=vector[Imin,Jmin].Iend;
    if tp0 <>g_single then sortieErreur('BuildKernel1 : VectorArray type must be Single');

    ok:=true;
    for i:=Imin to Imax do
    for j:=Jmin to Jmax do
      if (vector[Imin,Jmin].tpNum<>tp0) or (vector[Imin,Jmin].Istart<>is1) or (vector[Imin,Jmin].Iend<>is2)
        then ok:=false;
    if not ok then sortieErreur('BuildKernel1 : VectorArray not valid');

    verifierVecteurTemp(Vm);
    if Vm.tpNum<> g_single then sortieErreur('BuildKernel1 : Vm type must be Single');
  end;

  controleParam(Ntau,1,10000,'BuildKernel1 : Ntau out of range');

  verifierObjet(typeUO(VA));
  verifierObjet(typeUO(VAnorm));

  if not first and ((Va.imin<>stim.imin) or (Va.imax<>stim.imax)  or (Va.jmin<>stim.jmin) or (Va.jmax<>stim.jmax))
    then sortieErreur('BuildKernel1 : VA not initialized');

  if not first and ((VaNorm.imin<>stim.imin) or (VaNorm.imax<>stim.imax)  or (VaNorm.jmin<>stim.jmin) or (VaNorm.jmax<>stim.jmax))
    then sortieErreur('BuildKernel1 : VAnorm not initialized');

  BuildKernel1( stim, Vm, VA, VAnorm, Ntau, First);
end;





{******************************************************************************}


type
  typeStim = array of array of PtabSingle;
  TstoreProc = procedure (k1,k2:integer; w:float) of object;

  TthreadK = class(Tthread)
             private
               NiK,NjK,NtauK:integer;
               i1minK,i1maxK,j1minK,j1maxK, i2minK,i2maxK,j2minK,j2maxK: integer;
               pVmK: Psingle;              // vecteur de données
               stimK: typeStim;            // vecteurs de stim
               LenK: integer;
               dum: array of single;

               store, storeNorm: TstoreProc;

             public
               count:integer;
               constructor create(NiA, NjA,NtauA:integer;storeA,storeNormA: TstoreProc);
               procedure setLimits( i1minA,i1maxA,j1minA,j1maxA, i2minA,i2maxA,j2minA,j2maxA: integer);
               procedure setData(Vm:Psingle; lenA: integer;stimA:typeStim);
               procedure start;
               procedure execute;override;
             end;

constructor TthreadK.create(NiA, NjA,NtauA:integer;storeA,storeNormA: TstoreProc);
begin
  NiK:= NiA;
  NjK:= NjA;
  NtauK:= NtauA;
  store:= storeA;
  storeNorm:= storeNormA;

  inherited create(true);
end;

procedure TthreadK.execute;
var
  i1,i2,j1,j2,tau1,tau2,k1,k2: integer;

  p1,p2: Psingle;

  w,wnorm:single;
  D:integer;
begin
  for i1:=i1minK to i1maxK do
  for j1:=j1minK to j1maxK do
  begin
    if testEscape then exit;
    for i2:=i2minK to i2maxK do
    for j2:=j2minK to j2maxK do
    for D:=-NtauK+1 to NtauK-1 do
    begin
      if D>=0 then
      begin
        p1:=@stimK[i1,j1]^[D];
        p2:=@stimK[i2,j2]^[0];
      end
      else
      begin
        p1:=@stimK[i1,j1]^[0];
        p2:=@stimK[i2,j2]^[-D];
      end;

      ippsMul_32f(p1,p2,@dum[0],lenK);
      ippsNorm_L2_32f(@dum[0],lenK,@wnorm);

      if wnorm>0 then
      for tau1:= max(0,-D) to min(NtauK-1,NtauK-1-D) do
      begin
        tau2:=tau1+D;
        k1:=tau1+NtauK*j1+NtauK*NjK*i1;
        k2:=tau2+NtauK*j2+NtauK*NjK*i2;

        if k1>=k2 then
        begin
          //ippsDotProd_32f(@dum[NtauK-tau1],pVmK,lenK-NtauK+tau1,@w);
          //if (NtauK-1-tau1-D<0) or (NtauK-1-tau1-D>NtauK-1) then messageCentral('ICI');

          ippsDotProd_32f(@dum[NtauK-1-tau1-D],pVmK,lenK-NtauK+1+tau1+D,@w);
          store(k1,k2,w);
          inc(count);
          if k1<>k2 then store(k2,k1,w);

          StoreNorm(k1,k2,sqr(wNorm));
          if k1<>k2 then StoreNorm(k2,k1,sqr(wnorm));
        end;
      end;
    end;
  end;
  terminate;
end;




procedure TthreadK.setData(Vm: Psingle; lenA: integer; stimA: typeStim);
begin
  pVmK:=Vm;
  lenK:=lenA;
  stimK:=stimA;
  setlength(dum,lenK);
end;

procedure TthreadK.setLimits(i1minA, i1maxA, j1minA, j1maxA, i2minA,
  i2maxA, j2minA, j2maxA: integer);
begin
  i1minK:= i1minA;
  i1maxK:= i1maxA;
  j1minK:= j1minA;
  j1maxK:= j1maxA;
  i2minK:= i2minA;
  i2maxK:= i2maxA;
  j2minK:= j2minA;
  j2maxK:= j2maxA;
end;

procedure TthreadK.start;
begin
  resume;
end;


procedure BuildKernel2TH(stim:TvectorArray;Vm: Tvector; mat2,Mnorm2: Tmatrix; Ntau:integer;First:boolean);
var
  i,j,di,dj: integer;
  i1A,i2A,j1A,j2A,i1B,i2B,j1B,j2B: integer;
  imin,imax,jmin,jmax:integer;
  N,Ni,Nj:integer;

  pVm: Psingle;
  Len: integer;

  stim1: typeStim;

  threadK: array of TthreadK;
  ok:boolean;
  st:string;
  tot:integer;
  Ferror: boolean;

procedure AddThread(i1,i2,j1,j2,i1B,i2B,j1B,J2B:integer);
begin
  setLength(ThreadK,length(ThreadK)+1);
  ThreadK[high(threadK)]:=TthreadK.create(Ni,Nj,Ntau,mat2.addE,Mnorm2.addE);
  with ThreadK[High(threadK)] do
  begin
    setData(pVm,len,stim1);
    setLimits(i1,i2,j1,j2,i1B,i2B,j1B,J2B);
    start;
  end;

end;

begin
  IPPStest;

  imin:=stim.imin;
  imax:=stim.imax;
  jmin:=stim.jmin;
  jmax:=stim.jmax;

  Ni:=imax-imin+1;
  Nj:=jmax-jmin+1;
  N:= Ni*Nj*Ntau;


  if first then
  begin
    if assigned(mat2) then
    begin
      mat2.modify(g_double,0,0,N-1,N-1);
      Mnorm2.modify(g_double,0,0,N-1,N-1);
    end;
  end;

  pVm:=@PtabSingle(Vm.tb)^[Vm.Istart+Ntau-1];
  len:=Vm.Icount-Ntau;

  setLength(stim1,imax-imin+1,jmax-jmin+1);
  for i:=0 to imax-imin do
  for j:=0 to jmax-jmin do
    stim1[i,j]:= stim[imin+i,jmin+j].tb;

  { 2 zones
  AddThread(0,Ni div 2-1,0,Nj-1,0,Ni div 2-1,0,Nj-1);
  AddThread(Ni div 2,Ni-1,0,Nj-1,Ni div 2,Ni-1,0,Nj-1);
  AddThread(Ni div 2,Ni-1,0,Nj-1,0,Ni div 2-1,0,Nj-1);
  // AddThread(0,Ni div 2-1,0,Nj-1,Ni div 2,Ni-1,0,Nj-1); donne 0
  }

  {3 zones}
  di:=Ni div 3;
  AddThread(0,di-1,0,Nj-1,0,di-1,0,Nj-1);
  AddThread(di,2*di-1,0,Nj-1,di,2*di-1,0,Nj-1);
  AddThread(2*di,Ni-1,0,Nj-1,2*di,Ni-1,0,Nj-1);

  // on garde les zones telles que i1>i2, les autres apportent des contributions en dessous de la diagonale.
  AddThread(di,2*di-1,0,Nj-1,0,di-1,0,Nj-1);
  AddThread(2*di,Ni-1,0,Nj-1,0,di-1,0,Nj-1);
  AddThread(2*di,Ni-1,0,Nj-1,di,2*di-1,0,Nj-1);


  Ferror:=false;
  repeat
    ok:= true;
    for i:=0 to high(ThreadK) do
    if not ThreadK[i].Terminated then ok:=false
    else
    if assigned(threadK[i].FatalException) then Ferror:=true;
    // ok=true si tous les threads sont terminés

    if not Ferror then
    begin
      if testerFinPg then ok:=true;
      if not ok then sleep(10);
    end;

  until ok or Ferror;
  {
  st:='';
  tot:=0;
  for i:= 0 to high(ThreadK) do
  begin
    tot:=tot+ThreadK[i].count;
    st:=st+'  '+Istr(ThreadK[i].count);
  end;
  messageCentral(st+'  tot='+Istr(tot));
  }
  for i:=0 to high(threadK) do ThreadK[i].Free;

  if Ferror then sortieErreur('BuildKernel2 error');
end;


procedure proBuildKernel2(var stim:TvectorArray;var Vm: Tvector;Ntau:integer; var mat2,Mnorm2:Tmatrix; First:boolean);
var
  i,j:integer;
  tp0:typetypeG;
  is1,is2:integer;
  ok: boolean;
begin
  verifierObjet(typeUO(stim));
  with stim do
  begin
    tp0:=vector[Imin,Jmin].tpNum;
    is1:=vector[Imin,Jmin].Istart;
    is2:=vector[Imin,Jmin].Iend;
    if tp0 <>g_single then sortieErreur('BuildKernel2 : VectorArray type must be Single');

    ok:=true;
    for i:=Imin to Imax do
    for j:=Jmin to Jmax do
      if (vector[Imin,Jmin].tpNum<>tp0) or (vector[Imin,Jmin].Istart<>is1) or (vector[Imin,Jmin].Iend<>is2)
        then ok:=false;
    if not ok then sortieErreur('BuildKernel2 : VectorArray not valid');

    verifierVecteurTemp(Vm);
    if Vm.tpNum<> g_single then sortieErreur('BuildKernel2 : Vm type must be Single');
  end;

  controleParam(Ntau,1,10000,'BuildKernel2 : Ntau out of range');

  verifierObjet(typeUO(mat2));
  verifierObjet(typeUO(Mnorm2));

  if Ntau<=0 then sortieErreur('BuildKernel2 : Ntau must be positive');

  BuildKernel2TH(stim, Vm, mat2,Mnorm2, Ntau,First);


end;


end.
