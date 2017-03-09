unit MathSpeedTest;

{ Quelques résultats

    Col1  :  pour N= 1000000 et Nloop= 1000
    Col2  :  pour N=10000 et Nloop=10000
    Col3  :  pour N=1000 et Nloop=100000

  Addition de 2 vecteurs:            Loop 2.88            1.38            1.39
                                     IPP  2.36            1.03            0.38
                                     MKL  1.50            1.13            0.78

  Addition de 2 vecteurs IN Place:   Loop 2.10            1.15            1.08
                                     IPP  1.91            0.88            0.43

  AddNum v2:=v1+num                  Loop 2.02            1.41            1.42
                                     IPP  1.92            0.79            0.34

  AddNum inplace v1 = v1+num         Loop 1.38            1.25            1.24
                                     IPP  0.38            0.30            0.20

  Le seul cas toujours intéressants est:
    Addition d'un nombre INPLACE avec IPP

  Sinon, MKL semble plus efficace seulement pour les gros vecteurs  (addition de deux vecteurs)

}


interface

uses windows,
     util1,chrono0,
     ipps,ippsOvr,ippDefs,
     mathKernel0;

procedure SpeedTest1;
procedure SpeedTest1_I;
procedure SpeedTest2;
procedure SpeedTest3;

procedure SpeedTest;

implementation


Const
  N=1000000;
  Nloop=1000;

procedure add(p1,p2,p3:Psingle);
begin
  p3^:=p1^+p2^;
end;

procedure testAdd(p1, p2, p3:PtabSingle; n:integer);
var
  i:integer;
begin
  for i:=0 to N-1 do
    p3^[i]:= p1^[i]+p2^[i];

end;

procedure testAddIPP(p1, p2, p3:PtabSingle; n:integer);
var
  i:integer;
begin
  ippsAdd(Psingle(p1),Psingle(p2),Psingle(p3),N);
end;


procedure testAddMKL(p1, p2, p3:PtabSingle; n:integer);
var
  i:integer;
begin
  vsAdd(N,Psingle(p1),Psingle(p2),Psingle(p3));
end;



procedure SpeedTest1;     // Addition de deux vecteurs , résultat dans un troisième

var
  tb1,tb2,tbR:array of single;
  i,j:integer;
  st:string;
begin
  setLength(tb1,N);
  setLength(tb2,N);
  setLength(tbR,N);

  for i:=0 to high(tb1) do tb1[i]:= random;
  for i:=0 to high(tb2) do tb2[i]:= random;

  st:='v3=v1+v2'+crlf;
  initChrono;
  for j:=1 to Nloop do testAdd(@tb1[0],@tb2[0],@tbR[0],N);
  st:=st+'Loop  '+Chrono+crlf;


  initChrono;
    for j:=1 to Nloop do testAddIPP(@tb1[0],@tb2[0],@tbR[0],N);
   st:=st+'IPP  '+Chrono+crlf;

  initChrono;
    for j:=1 to Nloop do testAddMKL(@tb1[0],@tb2[0],@tbR[0],N);
  st:=st+'MKL  '+Chrono;

  messageCentral(st);
end;

procedure testAdd_I(p1, p2:PtabSingle; n:integer);
var
  i:integer;
begin
  for i:=0 to N-1 do
    p2^[i]:= p1^[i]+p2^[i];
end;

procedure testAddIPP_I(p1, p2:PtabSingle; n:integer);
var
  i:integer;
begin
  ippsAdd(Psingle(p1),Psingle(p2),N);
end;





procedure SpeedTest1_I;     // Addition de deux vecteurs , résultat dans le premier vecteur
var
  tb1,tb2:array of single;
  i,j:integer;
  st:string;
begin
  setLength(tb1,N);
  setLength(tb2,N);

  for i:=0 to high(tb1) do tb1[i]:= random;
  for i:=0 to high(tb2) do tb2[i]:= random;

  st:='v2=v1+v2'+crlf;
  initChrono;
  for j:=1 to Nloop do testAdd_I(@tb1[0],@tb2[0],N);
  st:=st+'Loop  '+Chrono+crlf;


  initChrono;
    for j:=1 to Nloop do testAddIPP_I(@tb1[0],@tb2[0],N);
   st:=st+'IPP  '+Chrono+crlf;

  messageCentral(st);
end;

procedure testAddC(val1:single; p2, p3:PtabSingle; n:integer);
var
  i:integer;
begin
  for i:=0 to N-1 do
    p3^[i]:= val1+p2^[i];
end;

procedure testAddCIPP(val1:single; p2, p3:PtabSingle; n:integer);
var
  i:integer;
begin
  ippsAddC(Psingle(p2),val1,Psingle(p3),n);

  //ippsMove(Psingle(p2),Psingle(p3),n);
  //move(p2^,p3^,N*4);
  //ippsAddC(val1,Psingle(p3),n);
end;



procedure SpeedTest2;
Const
  Cte=12.5;
var
  tb1,tb2,tbR:array of single;
  i,j:integer;
  st:string;
begin

  setLength(tb2,N);
  setLength(tbR,N);

  for i:=0 to high(tb2) do tb2[i]:= random;

  st:='v3=Cte+v2'+crlf;
  initChrono;
  for j:=1 to Nloop do testAddC(Cte,@tb2[0],@tbR[0],N);
  st:=st+'Loop  '+Chrono+crlf;


  initChrono;
    for j:=1 to Nloop do testAddCIPP(Cte,@tb2[0],@tbR[0],N);
   st:=st+'IPP  '+Chrono+crlf;

  messageCentral(st);
end;


procedure testAddC_I(val1:single;  p3:PtabSingle; n:integer);
var
  i:integer;
begin
  for i:=0 to N-1 do
   p3^[i]:= val1+p3^[i];
end;

procedure testAddCIPP_I(val1:single;  p3:PtabSingle; n:integer);
var
  i:integer;
begin
  ippsAddC(val1,Psingle(p3),n);
end;

procedure SpeedTest3;
Const
  Cte=12.5;
var
  tbR:array of single;
  i,j:integer;
  st:string;
begin

  setLength(tbR,N);

  for i:=0 to high(tbR) do tbR[i]:= random;

  st:='v3=Cte+v3'+crlf;
  initChrono;
  for j:=1 to Nloop do testAddC_I(Cte,@tbR[0],N);
  st:=st+'Loop  '+Chrono+crlf;


  initChrono;
    for j:=1 to Nloop do testAddCIPP_I(Cte,@tbR[0],N);
   st:=st+'IPP  '+Chrono+crlf;

  messageCentral(st);
end;


procedure SpeedTest;
begin
  SpeedTest1;
  SpeedTest1_I;
  SpeedTest2;
  SpeedTest3;
end;

end.
