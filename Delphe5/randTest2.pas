unit randTest2;


interface

uses windows, classes,
     util1, Ncdef2, stmObj,stmvec1,VlistA1, stmPG,
     ipps, ippsovr,
     stmMat1;

type
  Tarray2OfSingle = array of TarrayOfSingle;

  TRndThread =
    class(Tthread)
      I1,I2:integer;
      N1,N2:integer;
      tb1,tb2: Tarray2OfSingle;
      Nrep1,Nrep2:integer;
      Vdiff: Tarray2OfSingle;

      Fworking: boolean;
      mark: array of boolean;
      Fpairs:boolean;

      constructor create;
      destructor destroy;override;
      procedure Init( I1a,I2a:integer; tb1a,tb2a,Vdiffa: pointer;Fp:boolean);
      procedure start(Nrep1a,Nrep2a:integer);

      procedure FillMarks;
      procedure BuildMeanDiff(ind:integer);


      procedure Execute;override;

    end;



type
  TRandTest = class(typeUO)
              I1,I2:integer;
              N1,N2:integer;
              tb1,tb2: Tarray2OfSingle;
              Nrep:integer;
              Vdiff: Tarray2OfSingle;
              Vdiff0: TarrayOfSingle;

              maxTh: integer;
              ThRnd: array of TRndThread;

              MatchedPairs: boolean;

              constructor create;override;
              destructor destroy;override;
              class function STMClassName:AnsiString;

              procedure setVlist1( Vlist: TVlist);
              procedure setVlist2( Vlist: TVlist);

              procedure BuildMeanDiff0( mark: TarrayOfBoolean);
              procedure execute(Nrep: integer;percent:single; vecmin, vecmax,vecP: Tvector; Flog:boolean);


            end;



procedure proTRandTest_create(var pu:typeUO);pascal;
procedure proTRandTest_create_1(Fpairs:boolean; var pu:typeUO);pascal;

procedure proTRandTest_setVlist1(var Vlist:TVlist;var pu:typeUO);pascal;
procedure proTRandTest_setVlist2(var Vlist:TVlist;var pu:typeUO);pascal;

procedure proTRandTest_execute(Nrep: integer;percent:float; var vecmin, vecmax: Tvector; var pu:typeUO);pascal;
procedure proTRandTest_execute_1(Nrep: integer;percent:float; var vecmin, vecmax, vecP: Tvector; Flog: boolean;var pu:typeUO);pascal;

procedure proRespDistri(var Vlist: TVlist;Nb, Nrep:integer;var mat: Tmatrix);pascal;
procedure proRespDistri_1(var Vlist: TVlist;Nb, Nrep:integer;var mat: Tmatrix;Fsort:boolean);pascal;

implementation

{ TthreadRndTest }

constructor TRndThread.create;
begin
  inherited create(true);
end;

destructor TRndThread.destroy;
begin
  pointer(tb1):= nil;
  pointer(tb2):= nil;
  pointer(Vdiff):= nil;

  inherited;
end;

procedure TRndThread.Init(I1a, I2a:integer; tb1a, tb2a,  Vdiffa: pointer;Fp:boolean);
begin
  I1:= I1a;
  I2:= I2a;
  pointer(tb1):= tb1a;
  pointer(tb2):= tb2a;
  pointer(Vdiff):= Vdiffa;

  N1:=length(tb1);
  N2:=length(tb2);
  setLength(mark,N1+N2);
  Fpairs:=Fp;
end;

procedure TRndThread.start(Nrep1a, Nrep2a: integer);
begin
  Nrep1:=Nrep1a;
  Nrep2:=Nrep2a;
  Fworking:=true;
  resume;
end;

procedure TRndThread.Execute;
var
  rep: integer;
begin
  repeat
    for rep:=Nrep1 to Nrep2 do
    begin
      fillMarks;
      BuildMeanDiff(rep-1);
    end;
    Fworking:= false;
    Suspend;
  until terminated;
end;

procedure TRndThread.FillMarks;
var
  i,k,N:integer;

begin
  if Fpairs then
  begin
    for i:=0 to N1-1 do mark[i]:=(random(2)=0);
  end
  else
  begin
    N:=0;
    fillchar(mark[0],length(mark),0);

    while N<N2 do
    begin
      k:=random(N1+N2);
      if not mark[k] then
      begin
        mark[k]:=true;
        inc(N);
      end;
    end;
  end;
end;

procedure TRndThread.BuildMeanDiff(ind:integer);
var
  i:integer;
  moy1,moy2: array of single;
begin
  if Fpairs then
  begin
    setlength(moy1,I2-I1+1);

    fillchar(moy1[0],length(moy1)*4,0);
    fillchar(moy2[0],length(moy2)*4,0);

    for i:= 0 to N1-1 do
    if mark[i] then
    begin
      ippsAdd(Psingle(@tb1[i][0]),Psingle(@moy1[0]),I2-I1+1);
      ippsSub(Psingle(@tb2[i][0]),Psingle(@moy1[0]),I2-I1+1);
    end
    else
    begin
      ippsAdd(Psingle(@tb2[i][0]),Psingle(@moy1[0]),I2-I1+1);
      ippsSub(Psingle(@tb1[i][0]),Psingle(@moy1[0]),I2-I1+1);
    end;
    ippsMulC(1/N1,Psingle(@moy1[0]),I2-I1+1);
    for i:= 0 to I2-I1 do Vdiff[i,ind]:=moy1[i];
  end
  else
  begin
    setlength(moy1,I2-I1+1);
    setlength(moy2,I2-I1+1);

    fillchar(moy1[0],length(moy1)*4,0);
    fillchar(moy2[0],length(moy2)*4,0);

    for i:= 0 to N1-1 do
    if mark[i]
      then ippsAdd(Psingle(@tb1[i][0]),Psingle(@moy2[0]),I2-I1+1)
      else ippsAdd(Psingle(@tb1[i][0]),Psingle(@moy1[0]),I2-I1+1);

    for i:= N1 to N1+N2-1 do
    if mark[i]
      then ippsAdd(Psingle(@tb2[i-N1][0]),Psingle(@moy2[0]),I2-I1+1)
      else ippsAdd(Psingle(@tb2[i-N1][0]),Psingle(@moy1[0]),I2-I1+1);

    ippsMulC(1/N1,Psingle(@moy1[0]),I2-I1+1);
    ippsMulC(1/N2,Psingle(@moy2[0]),I2-I1+1);

    ippsSub(Psingle(@moy1[0]),Psingle(@moy2[0]) ,I2-I1+1);

    for i:= 0 to I2-I1 do Vdiff[i,ind]:=moy2[i];
  end;
end;


{ TRandTest }

constructor TRandTest.create;
var
  i:integer;
  info: TSystemInfo;
begin
  inherited;

  getSystemInfo(info);
  MaxTh := info.dwNumberOfProcessors*2;
  if MaxTh<1 then MaxTh:=1;
  setLength(ThRnd,MaxTh);

  for i:=0 to maxTh-1 do ThRnd[i]:=TRndThread.create;


end;

destructor TRandTest.destroy;
var
  i:integer;
begin
  for i:=0 to maxTh-1 do ThRnd[i].free;
  inherited;
end;

class function TRandTest.STMClassName: AnsiString;
begin
  result:='RandTest';
end;


procedure Shuffle(tb: TarrayOfSingle);
var
  i,n:integer;
begin
  n:=length(tb);
  for i:=0 to n-1 do swap(tb[i],tb[random(n)]);
end;


procedure TRandTest.setVlist1(Vlist: TVlist);
var
  i,j:integer;
begin
  setLength(tb1,0,0);

  verifierObjet(typeUO(Vlist));
  N1:=Vlist.count;
  if (N1<2) then sortieErreur('TRandTest.setVlist1 : not enough vectors in Vlist');

  I1:=Vlist[1].Istart;
  I2:=Vlist[1].Iend;

  for i:= 1 to N1 do
    if (Vlist[i].Istart<>I1) or (Vlist[i].Iend<>I2)
      then sortieErreur('TRandTest.setVlist1 : vectors have different Istart/Iend properties');

  setlength(tb1,N1,I2-I1+1);
  for i:= 1 to N1 do
  with Vlist[i] do
    for j:=I1 to I2 do tb1[i-1,j-I1]:=Yvalue[j];

  if MatchedPairs then RandSeed:=0;
  for j:=0 to I2-I1 do
    for i:=0 to N1-1 do
      swap(tb1[i,j],tb1[random(N1),j]);

end;

procedure TRandTest.setVlist2(Vlist: TVlist);
var
  i,j:integer;
begin
  setLength(tb2,0,0);

  verifierObjet(typeUO(Vlist));
  N2:=Vlist.count;
  if (N2<2) then sortieErreur('TRandTest.setVlist2 : not enough vectors in Vlist');

  for i:= 1 to N2 do
    if (Vlist[i].Istart<>I1) or (Vlist[i].Iend<>I2)
      then sortieErreur('TRandTest.setVlist2 : vectors have different Istart/Iend properties');

  if MatchedPairs and (N1<>N2)
    then sortieErreur('TRandTest.setVlist2 : vector list have different numbers of vectors');

  setlength(tb2,N2,I2-I1+1);
  for i:= 1 to N2 do
  with Vlist[i] do
    for j:=I1 to I2 do tb2[i-1,j-I1]:=Yvalue[j];

  if MatchedPairs then RandSeed:=0;

  for j:=0 to I2-I1 do
    for i:=0 to N2-1 do
      swap(tb2[i,j],tb2[random(N2),j]);

end;


procedure QuickSort(tb: PtabSingle;L, R: Integer);
var
  I, J: Integer;
  P, T: float;
begin
  repeat
    I := L;
    J := R;
    P := tb^[(L + R) shr 1];
    repeat
      while tb^[I]< P do Inc(I);
      while tb^[J]> P do Dec(J);
      if I <= J then
      begin
        T := tb^[I];
        tb^[I]:= tb^[J];
        tb^[J]:= T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(tb,L, J);
    L := I;
  until I >= R;
end;


procedure TRandTest.BuildMeanDiff0( mark: TarrayOfBoolean);
var
  i:integer;
  moy1,moy2: array of single;
begin
  setlength(moy1,I2-I1+1);
  setlength(moy2,I2-I1+1);

  fillchar(moy1[0],length(moy1)*4,0);
  fillchar(moy2[0],length(moy2)*4,0);

  for i:= 0 to N1-1 do
  if mark[i]
    then ippsAdd(Psingle(@tb1[i][0]),Psingle(@moy2[0]),I2-I1+1)
    else ippsAdd(Psingle(@tb1[i][0]),Psingle(@moy1[0]),I2-I1+1);

  for i:= N1 to N1+N2-1 do
  if mark[i]
    then ippsAdd(Psingle(@tb2[i-N1][0]),Psingle(@moy2[0]),I2-I1+1)
    else ippsAdd(Psingle(@tb2[i-N1][0]),Psingle(@moy1[0]),I2-I1+1);

  ippsMulC(1/N1,Psingle(@moy1[0]),I2-I1+1);
  ippsMulC(1/N2,Psingle(@moy2[0]),I2-I1+1);

  ippsSub(Psingle(@moy1[0]),Psingle(@moy2[0]) ,I2-I1+1);

  for i:= 0 to I2-I1 do Vdiff0[i]:=moy2[i];
end;


procedure TRandTest.execute(Nrep: integer;percent:single; vecmin, vecmax, vecP: Tvector; Flog:boolean);
var
  rep,i,j,n,j0:integer;
  Imin,Imax: integer;
  P: float;
  mark: TarrayOfBoolean;
  Nrep1,Nrep2:integer;

  ok, Ferror:boolean;
begin
  verifierVecteurTemp(vecmin);
  verifierVecteurTemp(vecmax);

  if not assigned(tb1) or not assigned(tb2) then sortieErreur('TRandTest.execute : data not installed');

  vecmin.modify(g_single,I1,I2);
  vecmax.modify(g_single,I1,I2);

  setLength(Vdiff,I2-I1+1,Nrep);
  setLength(Vdiff0,I2-I1+1);

  setlength(mark, N1+N2);
  // on suppose N2<N1

  for i:=0 to maxTh-1 do
  begin
    ThRnd[i].Init(I1,I2,tb1,tb2,Vdiff,MatchedPairs);

    Nrep1:=(Nrep div MaxTh)*i;
    Nrep2:=(Nrep div MaxTh)*(i+1)-1;
    if Nrep2>Nrep-1 then Nrep2:=Nrep-1;
    ThRnd[i].start(Nrep1,Nrep2 );
  end;

  Ferror:=false;
  repeat
    ok:= true;
    for i:=0 to maxTh-1 do
    if  ThRnd[i].Fworking then ok:=false
    else
    if assigned(thRnd[i].FatalException) then Ferror:=true;
    // ok=true si tous les threads sont terminés

    if not Ferror then
    begin
      if testerFinPg then ok:=true;
      if not ok then sleep(10);
    end;

  until ok or Ferror;

  if Ferror then sortieErreur('TRandTest Error');

  for i:=0 to I2-I1 do
   QuickSort(@Vdiff[i][0],0,Nrep-1);

  Imin:= round((Nrep-1)*percent);
  Imax:= round((Nrep-1)*(1-percent));


  for i:=I1 to I2 do
  begin
    vecmin[i]:=VDiff[i-I1,Imin];
    vecmax[i]:=VDiff[i-I1,Imax];
  end;

  if assigned(vecP) then
  begin
    vecP.modify(g_single,I1,I2);

    fillchar(mark[0],length(mark),0);

    for i:=N1 to N1+N2-1 do Mark[i]:=true;
    BuildMeanDiff0(mark);

    for i:=0 to I2-I1 do
    begin
       n:=0;
       j:=0;
       while (j<Nrep) and (abs(Vdiff[i,j])>=abs(Vdiff0[i])) do
       begin
         inc(n);
         inc(j);
       end;
       j0:=j;

       j:=Nrep-1;
       while (j>=j0) and (abs(Vdiff[i,j])>=abs(Vdiff0[i])) do
       begin
         inc(n);
         dec(j);
       end;

       P:= n/Nrep;
       if Flog then
       begin
         if P>0 then P:=-ln(P)/ln(10)
                else P:=5;
       end;
       if Vdiff0[i]<0 then P:=-P;
       vecP[i+vecP.Istart]:= P;
    end;

  end;

  setLength(Vdiff,0);
  setLength(Vdiff0,0);

end;





procedure proTRandTest_create(var pu:typeUO);
begin
  createPgObject('',pu, TRandTest);
end;

procedure proTRandTest_create_1(Fpairs:boolean; var pu:typeUO);
begin
  createPgObject('',pu, TRandTest);
  TrandTest(pu).MatchedPairs:= Fpairs;
end;

procedure proTRandTest_setVlist1(var Vlist:TVlist;var pu:typeUO);
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(pu);
  TRandTest(pu).setVlist1(Vlist);
end;

procedure proTRandTest_setVlist2(var Vlist:TVlist;var pu:typeUO);
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(pu);
  TRandTest(pu).setVlist2(Vlist);
end;

procedure proTRandTest_execute(Nrep: integer;percent:float; var vecmin, vecmax: Tvector; var pu:typeUO);
begin
  verifierVecteurTemp(Vecmin);
  verifierVecteurTemp(Vecmax);
  verifierObjet(pu);
  TRandTest(pu).execute(Nrep,percent, vecmin, vecmax,nil,false);
end;

procedure proTRandTest_execute_1(Nrep: integer;percent:float; var vecmin, vecmax, vecP: Tvector;Flog: boolean; var pu:typeUO);
begin
  verifierVecteurTemp(Vecmin);
  verifierVecteurTemp(Vecmax);
  verifierVecteurTemp(VecP);
  verifierObjet(pu);
  TRandTest(pu).execute(Nrep,percent, vecmin, vecmax, vecP, Flog);
end;




procedure proRespDistri_1(var Vlist: TVlist;Nb, Nrep:integer;var mat: Tmatrix; Fsort:boolean);
var
  i,j,k:integer;
  I1,I2:integer;
  N, rep: integer;
  tb1: array of array of single;
  tb2:Ptabsingle;
  moy: array of single;
  Nep: integer;
begin
  verifierObjet(typeUO(Vlist));
  if Nb>0 then Nep:= Vlist.count div Nb else Nep:=0;

  if (Nep<1) or (Nb<1) or (Vlist.count<>Nep*Nb) or (Nrep<1) then sortieErreur('RespDistri : bad parameters');

  I1:=Vlist[1].Istart;
  I2:=Vlist[1].Iend;

  for i:= 1 to Vlist.count do
    if (Vlist[i].Istart<>I1) or (Vlist[i].Iend<>I2)
      then sortieErreur('TRandTest.setVlist1 : vectors have different Istart/Iend properties');

  verifierObjet(typeUO(mat));
  mat.modify(g_single,I1,1,I2,Nrep);
  tb2:=mat.tb;

  N:=I2-I1+1;

  setlength(tb1,Vlist.count,N);
  for i:= 1 to Vlist.count do
  with Vlist[i] do
    for j:=I1 to I2 do tb1[i-1,j-I1]:=Yvalue[j];

  setlength(moy,N);
  for rep:=0 to Nrep-1 do
  begin
    fillchar(moy[0],N*4,0);

    for i:= 0 to Nep-1 do
    begin
      k:= i*Nb + random(Nb);
      ippsAdd(Psingle(@tb1[k][0]),Psingle(@moy[0]),N);
    end;

    ippsMulC(1/Nep,Psingle(@moy[0]),N);
    for i:=I1 to I2 do mat[i,rep+1]:= moy[i-I1];
  end;

  if Fsort then
  for i:=0 to N-1 do QuickSort(@tb2[Nrep*i],0,Nrep-1);


end;

procedure proRespDistri(var Vlist: TVlist;Nb, Nrep:integer;var mat: Tmatrix);
begin
  proRespDistri_1(Vlist,Nb, Nrep, mat, true);
end;


end.
