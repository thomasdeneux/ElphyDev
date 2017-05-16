
unit ChkPstw1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  sysutils,forms,math,
      util1,Gdos,
      stmvec1,
      MathKernel0,stmKLmat;

{ L'équation initiale s'écrit        matS * XX = BX

  Ni est le nombre d'inconnues
  Nt est le nombre d'instants pour lesquels on fait le calcul
  Neq est le nombre d'équations

  MatS est la matrice brute du stimulus:  chaque ligne contient les coefficients
  d'une stimulation élémentaire (donc d'une équation).
  Le nombre de lignes est égal au nombre de stimulus élémentaires (nb d'équations).
  Dimensions Neq * Ni

  Bx contient le signal: chaque ligne contient les Nt points survenus après un
  stimulus élémentaire.
  Dimensions Neq * Nt

  XX est le résultat cherché
  Chaque ligne contient la valeur d'un coefficient pour chacun des Nt instants
  Dimensions Ni * Nt

  On n'écrit pas la matrice matS . On cherche à résoudre le système
             (matS' * matS) *XX = matS' * BX    ( ' signifie transposée )
         ou  matH * XX = pstw

  avec matH = matS' * matS et pstw = matS' * BX

  On construit directement matH et pstw et on résout le système obtenu par
  une décomposition de Cholesky

  matH a pour dimensions Ni * Ni , c'est une matrice symétrique (donc Cholesky est applicable)
  pstw a pour dimensions Ni * Nt , c'est un pstw non normalisé .

  Pour remplir matH et BX, on introduit les équations une par une:
    - on appelle clearMatSline;
    - on range des coeff dans MatSline

    - on appelle clearBXline;
    - on range des valeurs dans BXline

    - on appelle updateHessian

  fONE rend plus efficace le remplissage si la majorité des éléments vaut zéro

  Après l'appel de Solve , XX contient la solution

  Si XX est connu , BuildOutLine permet de calculer la réponse à partir du contenu de
  matSline. Le résultat se trouve dans OutLine (Nt valeurs)
}

type
  Tvalue=record
           index:integer;
           value:double;
         end;

  TchkPstw=
    class
    public
      BlocS,BlocB:Tmat;
      Mbloc:integer;
      FNormaliseBloc:boolean;

      MatH:Tmat;    { La hessienne    matH = matS' * matS   }
      pstw:  Tmat;  { Les pstw bruts  pstw = matS' * matB   }
      XX:  Tmat;    { Les pstw vrais (résultats) }

      FOutline:array of double;       { Ligne estimée }

      FcolSum:array of double;
      FNeq:integer;
      FupdateMat:boolean;

      procedure setMatSline(n:integer;w:double);
      function getMatSline(n:integer):double;
      procedure setBXline(n:integer;w:double);
      function getBXline(n:integer):double;

      procedure setOutline(n:integer;w:double);
      function getOutline(n:integer):double;

      procedure UpdateMats;
      procedure NormaliseBloc(nbline:integer);
    public
      Ni:integer;     { Nombre d'inconnues }
      Nt:integer;     { Nombre de termes au second membre }


      lambda:float;   { Lambda correction Machens Wehr Zador }

      Fone:boolean;
      constructor create;
      destructor destroy;override;
      procedure setChildNames(st:AnsiString);

      procedure ClearMatSline;
      procedure ClearBXline;

      property MatSline[n:integer]:double read getMatSline write setMatSline;
      property BXline[n:integer]:double read getBXline write setBXline;
      property outline[n:integer]:double read getOutline write setOutline;
      property Neq:integer read FNeq;
      procedure UpdateHessian;

      procedure Init(nk1,nt1:integer);

      procedure Solve(Fkeep:boolean);

      procedure getVector(code,ntau:integer;vec:Tvector;raw,norm:boolean);
      procedure setVector(code,ntau:integer;vec:Tvector);
      procedure getResidual(vec:Tvector);
      function residual(n:integer):float;

      function MatSColSum(n:integer):float;
      procedure subAverage;

      procedure BuildOutLine;

      procedure CorrectionXX(ntau:integer);
      procedure calculSVD(mat:Tmat);

      procedure ClearMats;
    end;


implementation

{ TchkPstw }

constructor TchkPstw.create;
begin
  MatH:=Tmat.create(G_double,0,0);
  pstw:=Tmat.create(G_double,0,0);
  XX:=Tmat.create(G_double,0,0);

  matH.NotPublished:=true;
  pstw.NotPublished:=true;
  XX.NotPublished:=true;

  BlocS:=Tmat.create(G_double,0,0);
  BlocS.NotPublished:=true;
  BlocB:=Tmat.create(G_double,0,0);
  BlocB.NotPublished:=true;
  Mbloc:=1000;
end;

destructor TchkPstw.destroy;
begin
  MatH.Free;
  pstw.free;
  XX.free;

  BlocS.Free;
  BlocB.Free;
  inherited;
end;


procedure TchkPstw.Init(nk1,nt1: integer);
begin
  Ni:=nk1;
  Nt:=Nt1;

  MatH.setSize(Ni,Ni);
  matH.clear;
  pstw.setSize(Ni,Nt);
  pstw.clear;
  XX.setSize(Ni,Nt);
  XX.clear;

  setLength(Foutline,Nt);
  fillchar(Foutline[0],sizeof(Foutline[0])*Nt,0);

  setLength(FcolSum,Ni);
  fillchar(FcolSum[0],sizeof(FcolSum[0])*Ni,0);

  BlocS.setSize(MBloc,Ni);
  BlocS.clear;
  BlocB.setSize(Mbloc,Nt);
  BlocB.clear;

  FNeq:=0;
  FupdateMat:=false;
end;

procedure TchkPstw.ClearMatSline;
var
  i:integer;
begin
  for i:=1 to Ni do
    BlocS[Neq mod Mbloc+1,i]:=0;
end;

procedure TchkPstw.ClearBXline;
var
  i:integer;
begin
  for i:=1 to Nt do
    BlocB[Neq mod Mbloc+1,i]:=0;
end;

procedure TchkPstw.NormaliseBloc(nbline:integer);
var
  i,j:integer;
  w:double;
begin
  with BlocS do
  for i:=1 to Ni do
  begin
    w:=0;
    for j:=1 to nbline do
      w:=w+blocS[j,i];

    w:=w/nbline;

    for j:=1 to nbline do
      blocS[j,i]:=blocS[j,i]-w;
  end;
end;


procedure TchkPstw.UpdateHessian;
var
  i,j,u,v:integer;
begin
  inc(FNeq);

  if Neq mod Mbloc =0 then
  begin
    if FNormaliseBloc then NormaliseBloc(Mbloc);
    dsyrk('U','T',Ni,MBloc,1,BlocS.tb,Mbloc,1,matH.tb,Ni);    { matH:= matH + BlocS'*BlocS }
    dgemm('T','N',Ni,Nt,Mbloc,1,BlocS.tb,Mbloc,BlocB.tb,Mbloc,1,pstw.tb,Ni);
                                                              { pstw:= pstw + BlocS'*blocB }
  end;
  FupdateMat:=true;
end;

procedure TchkPstw.UpdateMats;
var
  nb:integer;
begin
  nb:=Neq mod Mbloc;
  if nb>1 then
  begin
    if FNormaliseBloc then NormaliseBloc(nb);
    dsyrk('U','T',Ni,nb,1,BlocS.tb,Mbloc,1,matH.tb,Ni);    { matH:= matH + BlocS'*BlocS }
    dgemm('T','N',Ni,Nt,nb,1,BlocS.tb,Mbloc,BlocB.tb,Mbloc,1,pstw.tb,Ni);
                                                           { pstw:= pstw + BlocS'*blocB }
  end;
  FupdateMat:=false;
end;


procedure TchkPstw.Solve(Fkeep:boolean);
var
  i,j:integer;
  Vnorm:array of double;
  nbpara:integer;
  matHbis:Tmat;
const
  epsilon=1E-100;
begin
  if FupdateMat then updateMats;

  nbpara:=matH.RowCount;


  if Fkeep then
  begin
    matHbis:=Tmat.create;
    matHbis.copy(matH);
  end;

  TRY
  for i:=1 to nbpara do
   if abs(matH[i,i])<epsilon then
     if matH[i,i]>=0 then matH[i,i]:=epsilon
                     else matH[i,i]:=-epsilon;


  for i:=1 to nbPara do matH[i,i]:=matH[i,i]*(1+lambda);

  matH.solveCHK(pstw,XX);

  FINALLY
  if Fkeep then
  begin
    matH.copy(matHbis);
    matHbis.free;
  end;

  END;
end;






procedure TchkPstw.getVector(code,ntau: integer; vec: Tvector;raw,norm:boolean);
var
  i,k:integer;
begin
  if vec.Icount<>Nt*ntau then
    vec.initTemp1(vec.Istart,vec.Istart+Nt*Ntau-1,vec.tpNum);

  if raw and norm then
  for i:=0 to nt-1 do
  for k:=0 to nTau-1 do
    vec.Yvalue[vec.Istart+i+nt*k]:=Pstw[code+k+1,i+1]/FcolSum[code]
  else
  if raw then
  for i:=0 to nt-1 do
  for k:=0 to nTau-1 do
    vec.Yvalue[vec.Istart+i+nt*k]:=Pstw[code+k+1,i+1]
  else
  for i:=0 to nt-1 do
  for k:=0 to nTau-1 do
    vec.Yvalue[vec.Istart+i+nt*k]:=XX[code+k+1,i+1];
end;


{$O-}
procedure TchkPstw.setVector(code,ntau: integer; vec: Tvector);
var
  i,k:integer;
  w:single;
begin
  {
  ippSetFlushToZero(1,nil);
  ippSetDenormAreZeros(1);
  }
  if vec.Icount<Nt*ntau then exit;

  for i:=0 to nt-1 do
  for k:=0 to nTau-1 do
  begin
    w:=vec.Yvalue[vec.Istart+i+nt*k];
    XX[code+k+1,i+1]:=w;
  end;
end;
{$O+}

function TchkPstw.residual(n: integer): float;
var
  i:integer;
begin
  result:=0;
end;

procedure TchkPstw.getResidual(vec: Tvector);
var
  i,k:integer;
  w:float;
begin
  if vec.Icount<>Nt then
    vec.initTemp1(vec.Istart,vec.Istart+Nt-1,vec.tpNum);

  for i:=0 to nt-1 do
  begin
    w:=0;
    vec.Yvalue[vec.Istart+i]:=0;
  end;
end;

procedure TchkPstw.setBXline(n:integer; w: double);
begin
  BlocB[Neq mod Mbloc+1,n+1]:=w;
end;

function TchkPstw.getBXline(n: integer): double;
begin
  result:=BlocB[Neq mod Mbloc+1,n+1];
end;

function TchkPstw.getMatSline(n: integer): double;
begin
  result:=BlocS[Neq mod Mbloc+1,n+1];
end;

procedure TchkPstw.setMatSline(n: integer; w: double);
begin
  BlocS[Neq mod Mbloc+1,n+1]:=w;
end;


function TchkPstw.MatScolSum(n: integer): float;
begin
  result:=FcolSum[n];
end;


procedure TchkPstw.subAverage;
var
  i,j:integer;
  W:array of double;
begin
  setLength(W,Nt);
  for j:=0 to Nt-1 do
    W[j]:=XX.colSum(j+1)/Ni;

  for i:=0 to Ni-1 do
  for j:=0 to Nt-1 do
    XX[i,j]:=XX[i+1,j+1]-W[j];

end;


procedure TchkPstw.BuildOutLine;
var
  Fline:array of double;
  i,j:integer;
  w:double;
begin
  setLength(Fline,Ni);
  for i:=0 to Ni-1 do
    Fline[i]:=BlocS[Neq mod Mbloc+1,i+1];



 dgemv('T',Ni,Nt,1,XX.tb,Ni,@Fline[0],1,0,@FOutline[0],1);
 {
  for i:=1 to Nt do
  begin
    w:=0;
    for j:=1 to Ni do
      w:=w+Fline[j-1]*XX[j,i];
    Foutline[i-1]:=w;
  end;
 }
end;

function TchkPstw.getOutline(n: integer): double;
begin
  result:=Foutline[n];
end;

procedure TchkPstw.setOutline(n: integer; w: double);
begin
  Foutline[n]:=w;
end;

procedure TchkPstw.CorrectionXX(ntau:integer);
var
  i,j,k:integer;
  y0:float;
begin
  with XX do
  for j:=0 to RowCount div ntau -1 do
  begin
    for k:=1 to ntau-1 do
    begin
      y0:=XX[j*ntau+k+1,1]-XX[j*ntau+k,ColCount];
      for i:=0 to ColCount-1 do
        XX[j*ntau+k+1,i+1]:= XX[j*ntau+k+1,i+1]-y0;
    end;
  end;
end;


procedure TchkPstw.setChildNames(st: AnsiString);
begin
  matH.ident:=st+'.matH';
  pstw.ident:=st+'.matB';
  XX.ident:=st+'.matX';

end;

procedure TchkPstw.calculSVD(mat:Tmat);
begin
  matH.SVD(nil,nil,mat);
end;

procedure TchkPstw.ClearMats;
begin
  matH.clear;
  pstw.clear;
  XX.clear;
end;


end.


