unit LqrPstw1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  sysutils,forms,
      util1,Gdos,
      stmvec1,stmMat1,stmKLmat,stmMatU1;

{ L'équation initiale s'écrit        matS * XX = BX

  Ni est le nombre d'inconnues
  Neq est le nombre d'équations
  Nt est le nombre d'instants pour lesquels on fait le calcul


  MatS est la matrice brute du stimulus:  chaque ligne contient les coefficients
  d'une stimulation élémentaire (donc d'une équation).
  Le nombre de lignes est égal au nombre de stimulus élémentaires (nb d'équations).
  Dimensions Neq * Ni

  Bx contient le signal: chaque ligne contient les Nt points survenus après un
  stimulus élémentaire.
  Dimensions Neq * Nt

  Pstw  est le (pseudo) PSTW brut.
  Dimensions Ni * Nt


  XX est le vrai PSTW (résultat du calcul)
  Dimensions Ni * Nt
}

type
  TlqrPstw=
    class
      Ni,Nt:integer;

      MatS:Tmat;
      BX:  Tmat;
      pstw:Tmat;
      XX:  Tmat;

      FcolSum:array of double;
      last:integer;


      constructor create;
      destructor destroy;override;

      procedure Newline;
      procedure RemoveLastLine;

      procedure setMatSline(n:integer;w:single);
      function getMatSline(n:integer):single;
      property MatSline[n:integer]:single read getMatSline write setMatSline;

      procedure setBXline(n:integer;w:single);
      function getBXline(n:integer):single;
      property BXline[n:integer]:single read getBXline write setBXline;

      procedure InitMats(nk1,nt1,Neq1:integer);
      procedure Init(nk1,nt1:integer);

      Procedure CalculatePstw;
      procedure SolveLqr(saveMatS:boolean);

      function Neq:integer;

      procedure getVector(code,ntau:integer;vec:Tvector;raw:boolean);
      procedure getResidual(vec:Tvector);
      function residual(n:integer):float;

      function MatScolSum(n:integer):float;
      procedure calculColSum;
      procedure subAverage;
    end;


implementation

{ TlqrPstw }

constructor TlqrPstw.create;
begin
  MatS:=Tmat.create(g_double,0,0);
  BX:=Tmat.create(g_double,0,0);
  pstw:=Tmat.create(g_double,0,0);
  XX:=Tmat.create(g_double,0,0);

  matS.NotPublished:=true;
  BX.NotPublished:=true;
  pstw.NotPublished:=true;
  XX.NotPublished:=true;
end;

destructor TlqrPstw.destroy;
begin
  matS.free;
  BX.free;
  pstw.free;
  XX.free;
  inherited;
end;


procedure TlqrPstw.InitMats(nk1,nt1,Neq1: integer);
begin
  Ni:=nk1;
  Nt:=Nt1;
  last:=Neq1-1;

  MatS.setSize(Neq1,Ni);
  BX.setSize(Neq1,nt);
  pstw.setSize(0,0);
  XX.setSize(0,0);

  setLength(FcolSum,Ni);
  fillchar(FcolSum[0],sizeof(FcolSum[0])*Ni,0);

end;


procedure TlqrPstw.Init(nk1,nt1: integer);
begin
  Ni:=nk1;
  Nt:=Nt1;

  MatS.setSize(0,Ni);
  BX.setSize(0,nt);
  pstw.setSize(0,0);
  XX.setSize(0,0);

  setLength(FcolSum,Ni);
  fillchar(FcolSum[0],sizeof(FcolSum[0])*Ni,0);

  last:=-1;
end;

procedure TlqrPstw.Newline;
var
  i:integer;
begin
  inc(last);
  if MatS.RowCount-1<Last then
    MatS.AddLines(1000);

  if BX.RowCount-1<Last then
    BX.addLines(1000);
end;

procedure TlqrPstw.RemoveLastLine;
begin
  if last>=0 then dec(last);
end;


procedure TlqrPstw.CalculatePstw;
begin
  pstw.prod(MatS,BX,normal,transpose);           { pstw = trans(matS) * BX }
  proMmulNum(Tmatrix(pstw),CpxNumber(1/Neq,0));
end;



procedure TlqrPstw.SolveLqr(saveMatS:boolean);
begin
  MatS.setSize(last+1,Ni);
  BX.setSize(last+1,Nt);

  {subAverage;}
  calculColSum;
  calculatePstw;

  MatS.solveLqr('N',BX,XX);

end;


function TlqrPstw.Neq: integer;
begin
  result:=last+1;
end;


function TlqrPstw.getMatSline(n: integer): single;
begin
  result:=MatS[last,n];
end;

procedure TlqrPstw.setMatSline(n:integer; w: single);
begin
  MatS[last,n]:=w;
end;


procedure TlqrPstw.setBXline(n:integer; w: single);
begin
  BX[last,n]:=w;
end;

function TlqrPstw.getBXline(n: integer): single;
begin
  result:=BX[last,n];
end;


procedure TlqrPstw.getVector(code,ntau: integer; vec: Tvector;raw:boolean);
var
  i,k:integer;
begin
  if vec.Icount<>Nt*ntau then
    vec.initTemp1(vec.Istart,vec.Istart+Nt*Ntau-1,vec.tpNum);

  if raw then
  for i:=0 to nt-1 do
  for k:=0 to nTau-1 do
    vec.Yvalue[vec.Istart+i+nt*k]:=Pstw[code+k,i]
  else
  for i:=0 to nt-1 do
  for k:=0 to nTau-1 do
    vec.Yvalue[vec.Istart+i+nt*k]:=XX[code+k,i];

end;

function TlqrPstw.residual(n: integer): float;
var
  i:integer;
begin
  result:=0;
  for i:=Ni to Neq-1 do
    result:=result+sqr(XX[i,n]);

  if Neq>0 then result:=result/Neq;
end;

procedure TlqrPstw.getResidual(vec: Tvector);
var
  i,k:integer;
  w:float;
begin
  if vec.Icount<>Nt then
    vec.initTemp1(vec.Istart,vec.Istart+Nt-1,vec.tpNum);

  for i:=0 to nt-1 do
  begin
    w:=0;
    for k:=Ni to Neq-1 do
      w:=w+sqr(XX[k,i]);
    vec.Yvalue[vec.Istart+i]:=w/Neq;
  end;
end;


function TlqrPstw.MatScolSum(n: integer): float;
begin
  result:=FcolSum[n];
end;



procedure TlqrPstw.calculColSum;
var
  i:integer;
begin
  for i:=0 to Ni-1 do
    FcolSum[i]:=matS.colSum(i);
end;

procedure TlqrPstw.subAverage;
var
  i,j:integer;
  W:array of double;
begin
  setLength(W,Nt);
  for j:=0 to Nt-1 do
    W[j]:=Bx.colSum(j)/Neq;

  for i:=0 to Neq-1 do
  for j:=0 to Nt-1 do
    BX[i,j]:=BX[i,j]-W[j];

end;


end.

