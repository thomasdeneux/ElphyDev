unit RandTest1;


interface

uses classes,
     util1, Ncdef2, stmObj,stmvec1,VlistA1, stmPG,
     ipps, ippsovr;

type
  TRandTest = class(typeUO)
              I1,I2:integer;
              N1,N2:integer;
              tb1,tb2: array of TarrayOfSingle;
              Nrep:integer;
              Vdiff: array of TarrayOfSingle;
              Vdiff0: TarrayOfSingle;

              

              constructor create;override;
              destructor destroy;override;
              class function STMClassName:AnsiString;

              procedure setVlist1( Vlist: TVlist);
              procedure setVlist2( Vlist: TVlist);

              procedure FillMarks(Mark: TarrayOfBoolean);
              procedure BuildMeanDiff(ind:integer; mark: TarrayOfBoolean);
              procedure execute(Nrep: integer;percent:single; vecmin, vecmax,vecP: Tvector; Flog:boolean);


            end;



procedure proTRandTest_create(var pu:typeUO);pascal;
procedure proTRandTest_setVlist1(var Vlist:TVlist;var pu:typeUO);pascal;
procedure proTRandTest_setVlist2(var Vlist:TVlist;var pu:typeUO);pascal;

procedure proTRandTest_execute(Nrep: integer;percent:float; var vecmin, vecmax: Tvector; var pu:typeUO);pascal;
procedure proTRandTest_execute_1(Nrep: integer;percent:float; var vecmin, vecmax, vecP: Tvector; Flog: boolean;var pu:typeUO);pascal;

implementation

{ TRandTest }

constructor TRandTest.create;
begin
  inherited;

end;

destructor TRandTest.destroy;
begin
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

  setlength(tb2,N2,I2-I1+1);
  for i:= 1 to N2 do
  with Vlist[i] do
  for j:=I1 to I2 do
    tb2[i-1,j-I1]:=Yvalue[j];

   for j:=0 to I2-I1 do
    for i:=0 to N2-1 do
      swap(tb2[i,j],tb2[random(N2),j]);

end;

procedure TRandTest.FillMarks(Mark: TarrayOfBoolean);
var
  i,k,N:integer;

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

procedure QuickSort(tb: TarrayOfSingle;L, R: Integer);
var
  I, J: Integer;
  P, T: float;
begin
  repeat
    I := L;
    J := R;
    P := tb[(L + R) shr 1];
    repeat
      while tb[I]< P do Inc(I);
      while tb[J]> P do Dec(J);
      if I <= J then
      begin
        T := tb[I];
        tb[I]:= tb[J];
        tb[J]:= T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(tb,L, J);
    L := I;
  until I >= R;
end;

procedure TRandTest.BuildMeanDiff(ind:integer; mark: TarrayOfBoolean);
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

  if ind>=0
    then for i:= 0 to I2-I1 do Vdiff[i,ind]:=moy2[i]
    else for i:= 0 to I2-I1 do Vdiff0[i]:=moy2[i];

end;

procedure TRandTest.execute(Nrep: integer;percent:single; vecmin, vecmax, vecP: Tvector; Flog:boolean);
var
  rep,i,j,n,j0:integer;
  Imin,Imax: integer;
  P: float;
  mark: TarrayOfBoolean;
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

  for rep:=1 to Nrep do
  begin
    fillMarks(mark);
    BuildMeanDiff(rep-1,mark);
  end;

  for i:=0 to I2-I1 do
   QuickSort(Vdiff[i],0,Nrep-1);

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
    BuildMeanDiff(-1,mark);

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


end;





procedure proTRandTest_create(var pu:typeUO);
begin
  createPgObject('',pu, TRandTest);
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




end.
