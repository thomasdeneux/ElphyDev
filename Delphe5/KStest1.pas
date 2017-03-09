unit KStest1;

interface

uses util1, ippdefs, ipps,
     Ncdef2, stmObj,stmvec1,VlistA1, stmPG;

type
  TKStest = class(typeUO)
              I1,I2:integer;
              N1,N2:integer;
              tb1,tb2: array of TarrayOfSingle;

              constructor create;override;
              destructor destroy;override;
              class function STMClassName:AnsiString;

              procedure setVlist1( Vlist: TVlist);
              procedure setVlist2( Vlist: TVlist);
              procedure execute(vecD, vecP: Tvector; Flog:boolean);


            end;


procedure proKStest(var vec1,vec2: Tvector;var D,P: float);pascal;

procedure proTKStest_create(var pu:typeUO);pascal;
procedure proTKStest_setVlist1(var Vlist:TVlist;var pu:typeUO);pascal;
procedure proTKStest_setVlist2(var Vlist:TVlist;var pu:typeUO);pascal;

procedure proTKStest_execute(var VecD,vecP:Tvector; var pu:typeUO);pascal;
procedure proTKStest_execute_1(var VecD,vecP:Tvector;Flog:boolean; var pu:typeUO);pascal;


implementation

{ TKStest }

constructor TKStest.create;
begin
  inherited;

end;

destructor TKStest.destroy;
begin
  inherited;
end;

class function TKStest.STMClassName: AnsiString;
begin
  result:='KStest';
end;



Const
(*
  tbP:array[0..40] of double=
    (
        0.26999967,  // c(alpha)=1
        0.24415943,
        0.22020556,
        0.19808132,
        0.17771819,
        0.15903889,
        0.14195987,
        0.12639347,
        0.11224967,
        0.09943752,
        0.08786641,
        0.07744704,
        0.06809222,
        0.05971754,
        0.05224189,
        0.04558782,
        0.03968188,
        0.03445477,
        0.02984147,
        0.02578132,
        0.02221796,
        0.0190993 ,
        0.01637739,
        0.01400833,
        0.01195204,
        0.01017214,
        0.00863568,
        0.00731299,
        0.00617743,
        0.00520517,
        0.00437498,
        0.00366802,
        0.00306762,
        0.00255909,
        0.00212953,
        0.00176765,
        0.0014636 ,
        0.00120883,
        0.00099591,
        0.00081845,
        0.00067093   //  c(alpha)=2
    );
*)
  tbP:array[0..100] of double=
    (
        1,                      //   calpha= 0.5
        0.9456719992,
        0.9228167946,
        0.8955551044,
        0.8642827791,
        0.8295530622,
        0.7920130315,
        0.7523476365,
        0.711235195,
        0.6693151477,
        0.6271670418,
        0.5852988403,
        0.5441424116,
        0.5040541804,
        0.4653192202,
        0.4281574211,
        0.3927307079,
        0.3591505804,
        0.3274854845,
        0.2977677137,
        0.2699996717,
        0.2441594274,
        0.2202055587,
        0.19808132,
        0.1777181926,
        0.1590388871,
        0.1419598689,
        0.1263934726,
        0.1122496667,
        0.0994375197,
        0.0878664139,
        0.0774470426,
        0.0680922218,
        0.0597175434,
        0.0522418886,
        0.0455878219,
        0.0396818795,
        0.0344547665,
        0.029841473,
        0.0257813231,
        0.0222179626,
        0.0190992982,
        0.016377393,
        0.0140083295,
        0.0119520432,
        0.0101721371,
        0.0086356793,
        0.0073129914,
        0.0061774306,
        0.0052051704,
        0.0043749822,
        0.0036680216,
        0.0030676213,
        0.0025590919,
        0.0021295325,
        0.0017676526,
        0.0014636048,
        0.0012088294,
        0.0009959108,
        0.0008184463,
        0.0006709253,
        0.0005486209,
        0.0004474916,
        0.0003640924,
        0.0002954967,
        0.0002392258,
        0.0001931868,
        0.0001556185,
        0.000125043,
        0.000100224,
        8.01305947858956E-005,
        6.3905647548843E-005,
        5.08386930323969E-005,
        4.03425901531154E-005,
        3.19335677956089E-005,
        2.52142103540965E-005,
        0.000019859,
        1.56021346046214E-005,
        1.22271359327425E-005,
        9.5582794644091E-006,
        7.4533063441572E-006,
        5.79738954926578E-006,
        4.49811193406461E-006,
        3.48130679298652E-006,
        2.68762455526299E-006,
        2.06970842221871E-006,
        1.58987872306979E-006,
        1.21824066310307E-006,
        9.31143143156597E-007,
        7.0992761739425E-007,
        5.39915700672592E-007,
        4.09592604239481E-007,
        0.00000031,
        0.000000234,
        1.76163583929206E-007,
        1.3231203275395E-007,
        9.91281063834474E-008,
        7.40812910158851E-008,
        5.52248491365595E-008,
        4.10652808984622E-008,
        3.04599594894243E-008         //   calpha= 3
    );


function getPvalue(calpha: float):float;
var
  i:integer;
  id:float;
begin
  id:= (calpha-0.5)/0.025;
  if id<=0 then result:=tbP[0]
  else
  if id>=100 then result:=tbP[100]
  else
  begin
     i:=trunc(id);
     result:=tbP[i]+(tbP[i+1]-tbP[i])*(id-i);
  end;
end;

procedure KSexecute(tb1,tb2:TArrayOfSingle;var D,P: single;Flog:boolean);
var
  i,j:integer;
  N1,N2: integer;
  l1,l2,D1: single;
  a,b,Calpha:single;
  moy1,moy2:single;
begin
  N1:=length(tb1);
  N2:=length(tb2);

  ippsMean_32f(@tb1[0],N1,@moy1,ippAlgHintNone);
  ippsMean_32f(@tb2[0],N2,@moy2,ippAlgHintNone);

  i:=-1;
  j:=-1;
  l1:=0;
  l2:=0;
  D:=0;

  while (i<N1-1) and (j<N2-1) do
  begin
    a:= tb1[i+1];
    b:= tb2[j+1];

    if (a<=b) then
    repeat
      inc(i);
      l1:=l1+1/N1;
    until (i>=N1-1) or (tb1[i+1]<>a);

    if (a>=b)  then
    repeat
      inc(j);
      l2:=l2+1/N2;
    until (j>=N2-1) or (tb2[j+1]<>b);
    D1:= l2-l1;
    if abs(D1)> abs(D) then D:=D1;
  end;

  D:=abs(D);

  Calpha:=abs(D)*sqrt(N1*N2/(N1+N2));

  P:=getPvalue(Calpha);
  if Flog then P:=-ln(P)/ln(10);

  if moy2<moy1 then P:=-P;
end;


procedure TKStest.execute(vecD, vecP: Tvector;Flog:boolean);
var
  i:integer;
  D,P:single;
begin
  verifierVecteurTemp(vecD);
  verifierVecteurTemp(vecP);

  if not assigned(tb1) or not assigned(tb2) then sortieErreur('TKStest.execute : data not installed');

  vecD.modify(g_single,I1,I2);
  vecP.modify(g_single,I1,I2);

  for i:=I1 to I2 do
  begin
    KSexecute(tb1[i-I1], tb2[i-I1],D,P, Flog);
    vecD[i]:=D;
    vecP[i]:=P;
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


procedure TKStest.setVlist1(Vlist: TVlist);
var
  i,j:integer;
begin
  setLength(tb1,0,0);

  verifierObjet(typeUO(Vlist));
  N1:=Vlist.count;
  if (N1<2) then sortieErreur('TKStest.setVlist1 : not enough vectors in Vlist');

  I1:=Vlist[1].Istart;
  I2:=Vlist[1].Iend;

  for i:= 1 to N1 do
    if (Vlist[i].Istart<>I1) or (Vlist[i].Iend<>I2)
      then sortieErreur('TKStest.setVlist1 : vectors have different Istart/Iend properties');

  setlength(tb1,I2-I1+1,N1);
  for i:= 1 to N1 do
  with Vlist[i] do
  for j:=I1 to I2 do tb1[j-I1,i-1]:=Yvalue[j];

  for j:=0 to I2-I1 do QuickSort(tb1[j],0,N1-1);
end;

procedure TKStest.setVlist2(Vlist: TVlist);
var
  i,j:integer;
begin
  setLength(tb2,0,0);

  verifierObjet(typeUO(Vlist));
  N2:=Vlist.count;
  if (N2<2) then sortieErreur('TKStest.setVlist2 : not enough vectors in Vlist');

  for i:= 1 to N2 do
    if (Vlist[i].Istart<>I1) or (Vlist[i].Iend<>I2)
      then sortieErreur('TKStest.setVlist2 : vectors have different Istart/Iend properties');

  setlength(tb2,I2-I1+1,N2);
  for i:= 1 to N2 do
  with Vlist[i] do
  for j:=I1 to I2 do tb2[j-I1,i-1]:=Yvalue[j];

  for j:=0 to I2-I1 do QuickSort(tb2[j],0,N2-1);
end;

procedure proKStest(var vec1,vec2: Tvector;var D,P: float);
var
  tb1,tb2: TarrayOfSingle;
  i:integer;
  D1,P1: single;
begin
  verifierVecteur(vec1);
  verifierVecteur(vec2);

  with vec1 do
  begin
    setLength(tb1,Icount);
    for i:=Istart to Iend do tb1[i-Istart]:=vec1[i];
  end;

  with vec2 do
  begin
    setLength(tb2,Icount);
    for i:=Istart to Iend do tb2[i-Istart]:=vec2[i];
  end;

  QuickSort(tb1,0,high(tb1));
  QuickSort(tb2,0,high(tb2));

  KSexecute(tb1,tb2, D1,P1,false );
  D:=D1;
  P:=P1;
end;


procedure proTKStest_create(var pu:typeUO);
begin
  createPgObject('',pu, TKStest);
end;


procedure proTKStest_setVlist1(var Vlist:TVlist;var pu:typeUO);
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(pu);
  TKStest(pu).setVlist1(Vlist);
end;

procedure proTKStest_setVlist2(var Vlist:TVlist;var pu:typeUO);
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(pu);
  TKStest(pu).setVlist2(Vlist);
end;

procedure proTKStest_execute(var VecD,vecP:Tvector; var pu:typeUO);
begin
  verifierVecteur(VecD);
  verifierVecteur(VecP);
  verifierObjet(pu);
  TKStest(pu).execute(vecD,vecP,false);

end;

procedure proTKStest_execute_1(var VecD,vecP:Tvector;Flog:boolean; var pu:typeUO);pascal;
begin
  verifierVecteur(VecD);
  verifierVecteur(VecP);
  verifierObjet(pu);
  TKStest(pu).execute(vecD,vecP,Flog);
end;


end.
