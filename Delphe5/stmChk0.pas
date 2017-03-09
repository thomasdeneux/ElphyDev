unit stmchk0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, debug0,
     stmDef,stmObj,stmVec1,stmPg,NcDef2,
     ChkPstw1,stmMat1,VlistA1;

type
  TCHKsolver=
    class(typeUO)
      CHK:TCHKPstw;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;
      procedure setChildNames;override;

      Procedure Init(Ni1,Nt1:integer);

      Procedure AddLine(vecCoeff,vecSignal:Tvector); overload;
      Procedure AddLine(vecCoeff:Tvector; w:float);  overload;

      Procedure Solve(Fkeep:boolean);
      Procedure GetVector(code,ntau: integer; vec: Tvector);
      procedure getResidual(vec: Tvector);

      procedure FillManu1(In1,In2,out1:Tvector;nbtau,i1,i2:integer);

      procedure InitManu2(nbtau:integer);
      procedure FillManu2(In1,In2,out1:Tvector;x1,x2:float);overload;
      procedure FillManu2(In1, In2, out1: Tvector; x1,x2:float;VL:TVlist);overload;
      procedure getManu2(VF1,VF2:Tvector;M00,M01,M10,M11:Tmatrix);

      procedure InitManu2ex(nbtau:integer);
      procedure FillManu2ex(In1,In2,out1:Tvector;x1,x2:float);overload;
      procedure FillManu2ex(In1, In2, out1: Tvector; x1,x2:float;VL:TVlist);overload;
      procedure getManu2ex(VF1,VF2:Tvector;M00,M01,M10,M11:Tmatrix;var h0:float);

      procedure InitManu3(nbtau:integer);
      procedure FillManu3(In1,out1:Tvector;x1,x2:float);
      procedure getManu3(VF1:Tvector;M00:Tmatrix);

      procedure BuildLine1(Mat:Tmatrix;y:float;mode:integer);
    end;

procedure proTCHKsolver_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTCHKsolver_create_1(var pu:typeUO);pascal;

procedure proTCHKsolver_Init(Ni1,Nt1:integer;var pu:typeUO);pascal;

procedure proTCHKsolver_AddLine(var Coef,signal:Tvector;var pu:typeUO);pascal;
procedure proTCHKsolver_AddLine_1(var Coef:Tvector; w:float ;var pu:typeUO);pascal;

procedure proTCHKsolver_Solve(var pu:typeUO);pascal;
procedure proTCHKsolver_Solve_1(Fkeep:boolean;var pu:typeUO);pascal;

procedure proTCHKsolver_GetVector(code,ntau: integer;var vec: Tvector; var pu:typeUO);pascal;
procedure proTCHKsolver_GetResidual(var vec: Tvector; var pu:typeUO);pascal;

function fonctionTCHKsolver_matH(var pu:typeUO):pointer;pascal;
function fonctionTCHKsolver_matB(var pu:typeUO):pointer;pascal;
function fonctionTCHKsolver_matX(var pu:typeUO):pointer;pascal;

function fonctionTCHKsolver_Residual(i:integer; var pu:typeUO):float;pascal;

procedure proTCHKsolver_lambda(w:float; var pu:typeUO);pascal;
function fonctionTCHKsolver_lambda(var pu:typeUO):float;pascal;

procedure proTCHKsolver_FillManu1(var In1,In2,out1:Tvector;nbtau,i1,i2:integer;var pu:typeUO);pascal;

procedure proTCHKsolver_InitManu2(nbtau:integer;var pu:typeUO);pascal;
procedure proTCHKsolver_FillManu2(var In1,In2,out1:Tvector;x1,x2:float;var pu:typeUO);pascal;
procedure proTCHKsolver_FillManu2_1(var In1,In2,out1:Tvector;x1,x2:float;var VL:TVlist;var pu:typeUO);pascal;
procedure proTCHKsolver_getManu2(var VF1,VF2:Tvector;var M00,M01,M10,M11:Tmatrix;var pu:typeUO);pascal;
procedure proBuildManu2(var In1,in2,out1:Tvector;var VH1,VH2:Tvector;var MK11,MK12,MK21,MK22:Tmatrix);pascal;

procedure proTCHKsolver_InitManu2ex(nbtau:integer;var pu:typeUO);pascal;
procedure proTCHKsolver_FillManu2ex(var In1,In2,out1:Tvector;x1,x2:float;var pu:typeUO);pascal;
procedure proTCHKsolver_FillManu2ex_1(var In1,In2,out1:Tvector;x1,x2:float;var VL:TVlist;var pu:typeUO);pascal;
procedure proTCHKsolver_getManu2ex(var VF1,VF2:Tvector;var M00,M01,M10,M11:Tmatrix;var h0:float;var pu:typeUO);pascal;


procedure proTCHKsolver_InitManu3(nbtau:integer;var pu:typeUO);pascal;
procedure proTCHKsolver_FillManu3(var In1,out1:Tvector;x1,x2:float;var pu:typeUO);pascal;
procedure proTCHKsolver_getManu3(var VF1:Tvector;var M00:Tmatrix;var pu:typeUO);pascal;
procedure proBuildManu3(var In1,out1:Tvector;var VH:Tvector;var MKK:Tmatrix);pascal;


procedure proTchkSolver_BlockSize(n:integer;var pu:typeUO);pascal;
function fonctionTchkSolver_BlockSize(var pu:typeUO):integer;pascal;
procedure proTchkSolver_NormalizeBlock(w:boolean;var pu:typeUO);pascal;
function fonctionTchkSolver_NormalizeBlock(var pu:typeUO):boolean;pascal;

procedure proTCHKsolver_StoreISA2(var Vsrc,Vdest,Vbeta:Tvector; var pu:TchkSolver);pascal;

procedure proTCHKsolver_BuildLine1(var Mat: Tmatrix; y: float; mode: integer; var pu:typeUO);pascal;

implementation


{ TCHKsolver }


constructor TCHKsolver.create;
begin
  inherited;
  CHK:=TCHKPstw.create;
end;

destructor TCHKsolver.destroy;
begin
  CHK.Free;
  inherited;
end;


class function TCHKsolver.STMClassName: AnsiString;
begin
  result:='CHKsolver';
end;

procedure TCHKsolver.setChildNames;
begin
  chk.setChildNames(ident);
end;

procedure TCHKsolver.Init(Ni1, Nt1: integer);
begin
  if (Ni1<1) or (Nt1<1) then sortieErreur('TCHKsolver.Init: invalid parameter');
  CHK.Init(Ni1,Nt1);
end;


procedure TCHKsolver.AddLine(vecCoeff, vecSignal: Tvector);
var
  i:integer;
begin
  if vecCoeff.Icount<>CHK.Ni
    then sortieErreur('TCHKsolver.AddLine: firstVector.Icount must be equal to Ni');

  if vecSignal.Icount<>CHK.Nt
    then sortieErreur('TCHKsolver.AddLine: SecondVector.Icount must be equal to Nt');

  CHK.clearMatSline;

  with vecCoeff do
  for i:=Istart to Iend do
    CHK.MatSline[i-Istart]:= Yvalue[i];

  CHK.clearBXline;
  with vecSignal do
  for i:=Istart to Iend do
    CHK.BXline[i-Istart]:= Yvalue[i];

  CHK.UpdateHessian;
end;

procedure TCHKsolver.AddLine(vecCoeff: Tvector; w:float);
var
  i:integer;
begin
  if vecCoeff.Icount<>CHK.Ni
    then sortieErreur('TCHKsolver.AddLine: firstVector.Icount must be equal to Ni');

  if CHK.Nt<>1 then sortieErreur('TCHKsolver.AddLine: Nt must be equal to 1');

  CHK.clearMatSline;

  with vecCoeff do
  for i:=Istart to Iend do
    CHK.MatSline[i-Istart]:= Yvalue[i];

  CHK.clearBXline;
  CHK.BXline[0]:= w;

  CHK.UpdateHessian;
end;



procedure TCHKsolver.Solve(Fkeep:boolean);
begin
  CHK.Solve(Fkeep);
end;


procedure TCHKsolver.getResidual(vec: Tvector);
begin
  CHK.getResidual(vec);
end;

procedure TCHKsolver.GetVector(code, ntau: integer; vec: Tvector);
begin
  CHK.getVector(code,ntau,vec,false,false);

end;

procedure TCHKsolver.FillManu1(In1, In2, out1: Tvector; nbtau,i1,i2: integer);
var
  i:integer;
  tau,tau1,tau2:integer;
  Nphi:integer;
  x11,x12,x21,x22:float;
  nbInc:integer;
begin
  nbInc:= 2*nbtau + 4*nbtau*nbtau;
  Init(nbInc,1);

  for i:=I1+nbtau to I2 do
  begin
    CHK.clearMatSline;

    for tau:=0 to nbTau-1 do
    begin
      CHK.MatSline[tau]:=In1.Yvalue[i-tau];
      CHK.MatSline[nbtau+tau]:=In2.Yvalue[i-tau];
    end;

    for tau1:=0 to nbTau-1 do
    for tau2:=0 to nbTau-1 do
    begin
      x11:=In1.Yvalue[i-tau1];
      x12:=In2.Yvalue[i-tau1];

      x21:=In1.Yvalue[i-tau2];
      x22:=In2.Yvalue[i-tau2];

      Nphi:=ord(x11<>0) + ord(x21<>0)*2;
      CHK.MatSline[nbTau*(2+Nphi*nbtau) +tau1+nbtau*tau2]:=(x11+x12)*(x21+x22);
    end;

    CHK.clearBXline;
    CHK.BXline[0]:= out1.Yvalue[i];

    CHK.UpdateHessian;
  end;


end;

{***************************************** MANU2 ****************************************}

procedure TCHKsolver.initManu2(nbtau:integer);
var
  nbInc:integer;
begin
  { Le nb d'inconnues est 3*N + 2*N²  , soit
       N dans chaque 1er ordre
       N*(N+1)/2 dans K11 et K22 (les matrices sont symétriques)
       N² dans K12 ou K21 (les matrices sont transposées l'une de l'autre)
  }
  nbInc:= 2*nbtau + nbtau*(2*nbtau+1);
  Init(nbInc,1);
end;

procedure TCHKsolver.FillManu2(In1, In2, out1: Tvector; x1,x2:float);
var
  i,i1,i2:integer;
  tau,tau1,tau2:integer;
  Nphi:integer;
  x11,x12,x21,x22:float;
  ind1,ind2:integer;
  nbTau:integer;
begin
  { On range les coeffs dans l'ordre:
     H1    H2     K11      K12     K22
     n     n     n*(n+1)/2  n²     n*(n+1)/2          (nombre de coeffs)

    On ne compte qu'une fois les coeffs  à occurence multiple
    Donc, dans getManu, il n'y a pas de facteur divisif pour ces coefficients

    Si on considère la relation f(i1,i2)=i1*(i1+1) div 2 + i2 avec i1>=i2, on a une
    relation biunivoque entre les élements en dessous de la diagonale d'une matrice (2n,2n) et
    les éléments d'un vecteur de taille 2n*(2n+1) div 2. Ceci permet de ranger rationnellement les
    inconnues des Kii dans un vecteur
      ( .     .       )
      (   .   .       )
      ( K11 . .       )
      ( . . . . . . . )
      (       . .     )
      (  K12  .   .   )
      (       . K22 . )

     Pour K11, on a i1=tau1 i2=tau2 avec i1>=i2
     Pour K12, on a i1=tau1+n  i2=tau2 mais pas de condition
     Pour K22, on a i1=tau1+n  i2=tau2+n avec i1>=i2

     On remarquera que les éléments de K12 et K22 sont mélangés dans le vecteur destination.
  }

  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/4);

  i1:=out1.invconvx(x1);
  i2:=out1.invconvx(x2);

  if i1-nbtau+1<In1.Istart then i1:=In1.Istart+nbtau-1;

  for i:=I1 to I2 do
  begin
    CHK.clearMatSline;

    for tau:=0 to nbTau-1 do
    begin
      CHK.MatSline[tau]:=In1.Yvalue[i-tau];
      CHK.MatSline[nbtau+tau]:=In2.Yvalue[i-tau];
    end;

    for tau1:=0 to nbTau-1 do
    for tau2:=0 to nbtau-1 do
    begin
      x11:=In1.Yvalue[i-tau1];                   {2eme indice = num entrée }
      x12:=In2.Yvalue[i-tau1];                   {1er indice =  Tau }

      x21:=In1.Yvalue[i-tau2];
      x22:=In2.Yvalue[i-tau2];

      ind1:=tau1;
      ind2:=tau2;

      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x11*x21      {K11}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x11*x21;   {K11}

      ind1:=tau1+nbtau;
      ind2:=tau2;
      CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x21;     {K21 = K12'}


      ind1:=tau1+nbtau;
      ind2:=tau2+nbtau;
      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x12*x22      {K22}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x22;   {K22}

    end;


    CHK.clearBXline;
    CHK.BXline[0]:= out1.Yvalue[i];

    CHK.UpdateHessian;
  end;


end;

procedure TCHKsolver.FillManu2(In1, In2, out1: Tvector; x1,x2:float;VL:TVlist);
var
  i,i1,i2:integer;
  tau,tau1,tau2:integer;
  Nphi:integer;
  x11,x12,x21,x22:float;
  ind1,ind2:integer;
  nbTau:integer;
  nbvec:integer;
  In1c,In2c:array of float;
  u1,u2:integer;
  scal1,scal2:float;

begin
  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/4);
  nbvec:=VL.count;

  i1:=out1.invconvx(x1);
  i2:=out1.invconvx(x2);

  if i1-nbtau+1<In1.Istart then i1:=In1.Istart+nbtau-1;

  setLength(In1c,nbtau);
  setLength(In2c,nbtau);



  for i:=I1 to I2 do
  begin
    CHK.clearMatSline;

    for tau:=0 to nbTau-1 do
    begin
      In1c[tau]:=In1.Yvalue[i-tau];
      In2c[tau]:=In2.Yvalue[i-tau];
    end;

    for u1:=1 to VL.count do
    with VL.Vectors[u1] do
    begin
      scal1:=0;
      scal2:=0;
      for tau:=0 to nbtau-1 do
      begin
        scal1:=scal1+Yvalue[Istart+tau]*In1[i-tau];
        scal1:=scal1+Yvalue[Istart+nbtau+tau]*In2[i-tau];
      end;

      for tau:=0 to nbtau-1 do
      begin
        In1c[tau]:=In1c[tau]-scal1*Yvalue[Istart+tau];
        In2c[tau]:=In2c[tau]-scal1*Yvalue[Istart+nbtau+tau];
      end;
    end;

    for tau:=0 to nbTau-1 do
    begin
      CHK.MatSline[tau]:=In1c[tau];
      CHK.MatSline[nbtau+tau]:=In2c[tau];
    end;

    for tau1:=0 to nbTau-1 do
    for tau2:=0 to nbtau-1 do
    begin
      x11:=In1c[tau1];                   {2eme indice = num entrée }
      x12:=In2c[tau1];                   {1er indice =  Tau }

      x21:=In1c[tau2];
      x22:=In2c[tau2];

      ind1:=tau1;
      ind2:=tau2;

      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x11*x21      {K11}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x11*x21;   {K11}

      ind1:=tau1+nbtau;
      ind2:=tau2;
      CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x21;     {K21 = K12'}


      ind1:=tau1+nbtau;
      ind2:=tau2+nbtau;
      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x12*x22      {K22}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x22;   {K22}

    end;


    CHK.clearBXline;
    CHK.BXline[0]:= out1.Yvalue[i];

    CHK.UpdateHessian;
  end;
end;


procedure TCHKsolver.getManu2(VF1,VF2:Tvector;M00,M01,M10,M11:Tmatrix);
var
  nbtau:integer;
  t,t1,t2:integer;
  ind1,ind2,phi1,phi2:integer;
  m:array[0..1,0..1] of Tmatrix;

begin
  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/4);
  m[0,0]:=M00;
  m[0,1]:=M01;
  m[1,0]:=M10;
  m[1,1]:=M11;

  VF1.initTemp1(0,nbtau-1,g_double);
  VF2.initTemp1(0,nbtau-1,g_double);

  M00.initTemp(0,nbtau-1,0,nbtau-1,g_double);
  M01.initTemp(0,nbtau-1,0,nbtau-1,g_double);
  M10.initTemp(0,nbtau-1,0,nbtau-1,g_double);
  M11.initTemp(0,nbtau-1,0,nbtau-1,g_double);

  for t:=0 to nbtau-1 do
  begin
    VF1[t]:=chk.XX[t+1,1];
    VF2[t]:=chk.XX[t+1+nbtau,1];
  end;

  for t1:=0 to nbtau-1 do
  for t2:=0 to nbtau-1 do
  for phi1:=0 to 1 do
  for phi2:=0 to 1 do
  begin
    ind1:=t1+phi1*nbTau;
    ind2:=t2+phi2*nbTau;

    if ind1>=ind2
      then M[phi1,phi2][t1,t2]:=CHK.XX[1+nbTau*2 +ind1*(ind1+1) div 2+ind2,1]
      else M[phi1,phi2][t1,t2]:=CHK.XX[1+nbTau*2 +ind2*(ind2+1) div 2+ind1,1];
  end;
end;

{***************************************** MANU2ex ****************************************}

procedure TCHKsolver.initManu2ex(nbtau:integer);
var
  nbInc:integer;
begin
  { Le nb d'inconnues est 3*N + 2*N²  , soit
       N dans chaque 1er ordre
       N*(N+1)/2 dans K11 et K22 (les matrices sont symétriques)
       N² dans K12 ou K21 (les matrices sont transposées l'une de l'autre)
  }
  nbInc:= 2*nbtau + nbtau*(2*nbtau+1) +1;
  Init(nbInc,1);
end;

procedure TCHKsolver.FillManu2ex(In1, In2, out1: Tvector; x1,x2:float);
var
  i,i1,i2:integer;
  tau,tau1,tau2:integer;
  Nphi:integer;
  x11,x12,x21,x22:float;
  ind1,ind2:integer;
  nbTau:integer;
begin
  { On range les coeffs dans l'ordre:
     H1    H2     K11      K12     K22            H0
     n     n     n*(n+1)/2  n²     n*(n+1)/2      1    (nombre de coeffs)

    On ne compte qu'une fois les coeffs  à occurence multiple
    Donc, dans getManu, il n'y a pas de facteur divisif pour ces coefficients

    Si on considère la relation f(i1,i2)=i1*(i1+1) div 2 + i2 avec i1>=i2, on a une
    relation biunivoque entre les élements en dessous de la diagonale d'une matrice (2n,2n) et
    les éléments d'un vecteur de taille 2n*(2n+1) div 2. Ceci permet de ranger rationnellement les
    inconnues des Kii dans un vecteur
      ( .     .       )
      (   .   .       )
      ( K11 . .       )
      ( . . . . . . . )
      (       . .     )
      (  K12  .   .   )
      (       . K22 . )

     Pour K11, on a i1=tau1 i2=tau2 avec i1>=i2
     Pour K12, on a i1=tau1+n  i2=tau2 mais pas de condition
     Pour K22, on a i1=tau1+n  i2=tau2+n avec i1>=i2

     On remarquera que les éléments de K12 et K22 sont mélangés dans le vecteur destination.
  }

  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/4);

  i1:=out1.invconvx(x1);
  i2:=out1.invconvx(x2);

  if i1-nbtau+1<In1.Istart then i1:=In1.Istart+nbtau-1;

  for i:=I1 to I2 do
  begin
    CHK.clearMatSline;

    for tau:=0 to nbTau-1 do
    begin
      CHK.MatSline[tau]:=In1.Yvalue[i-tau];
      CHK.MatSline[nbtau+tau]:=In2.Yvalue[i-tau];
    end;

    for tau1:=0 to nbTau-1 do
    for tau2:=0 to nbtau-1 do
    begin
      x11:=In1.Yvalue[i-tau1];                   {2eme indice = num entrée }
      x12:=In2.Yvalue[i-tau1];                   {1er indice =  Tau }

      x21:=In1.Yvalue[i-tau2];
      x22:=In2.Yvalue[i-tau2];

      ind1:=tau1;
      ind2:=tau2;

      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x11*x21      {K11}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x11*x21;   {K11}

      ind1:=tau1+nbtau;
      ind2:=tau2;
      CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x21;     {K21 = K12'}


      ind1:=tau1+nbtau;
      ind2:=tau2+nbtau;
      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x12*x22      {K22}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x22;   {K22}

    end;

    CHK.MatSline[2*nbtau + nbtau*(2*nbtau+1)]:=1;                     {H0}

    CHK.clearBXline;
    CHK.BXline[0]:= out1.Yvalue[i];

    CHK.UpdateHessian;
  end;


end;

procedure TCHKsolver.FillManu2ex(In1, In2, out1: Tvector; x1,x2:float;VL:TVlist);
var
  i,i1,i2:integer;
  tau,tau1,tau2:integer;
  Nphi:integer;
  x11,x12,x21,x22:float;
  ind1,ind2:integer;
  nbTau:integer;
  nbvec:integer;
  In1c,In2c:array of float;
  u1,u2:integer;
  scal1,scal2:float;

begin
  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/4);
  nbvec:=VL.count;

  i1:=out1.invconvx(x1);
  i2:=out1.invconvx(x2);

  if i1-nbtau+1<In1.Istart then i1:=In1.Istart+nbtau-1;

  setLength(In1c,nbtau);
  setLength(In2c,nbtau);



  for i:=I1 to I2 do
  begin
    CHK.clearMatSline;

    for tau:=0 to nbTau-1 do
    begin
      In1c[tau]:=In1.Yvalue[i-tau];
      In2c[tau]:=In2.Yvalue[i-tau];
    end;

    for u1:=1 to VL.count do
    with VL.Vectors[u1] do
    begin
      scal1:=0;
      scal2:=0;
      for tau:=0 to nbtau-1 do
      begin
        scal1:=scal1+Yvalue[Istart+tau]*In1[i-tau];
        scal1:=scal1+Yvalue[Istart+nbtau+tau]*In2[i-tau];
      end;

      for tau:=0 to nbtau-1 do
      begin
        In1c[tau]:=In1c[tau]-scal1*Yvalue[Istart+tau];
        In2c[tau]:=In2c[tau]-scal1*Yvalue[Istart+nbtau+tau];
      end;
    end;

    for tau:=0 to nbTau-1 do
    begin
      CHK.MatSline[tau]:=In1c[tau];
      CHK.MatSline[nbtau+tau]:=In2c[tau];
    end;

    for tau1:=0 to nbTau-1 do
    for tau2:=0 to nbtau-1 do
    begin
      x11:=In1c[tau1];                   {2eme indice = num entrée }
      x12:=In2c[tau1];                   {1er indice =  Tau }

      x21:=In1c[tau2];
      x22:=In2c[tau2];

      ind1:=tau1;
      ind2:=tau2;

      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x11*x21      {K11}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x11*x21;   {K11}

      ind1:=tau1+nbtau;
      ind2:=tau2;
      CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x21;     {K21 = K12'}


      ind1:=tau1+nbtau;
      ind2:=tau2+nbtau;
      if ind1=ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=x12*x22      {K22}
      else
      if ind1>ind2 then
        CHK.MatSline[nbTau*2 +ind1*(ind1+1) div 2+ind2]:=2*x12*x22;   {K22}

    end;

    CHK.MatSline[2*nbtau + nbtau*(2*nbtau+1)]:=1;                     {H0}

    CHK.clearBXline;
    CHK.BXline[0]:= out1.Yvalue[i];

    CHK.UpdateHessian;
  end;
end;


procedure TCHKsolver.getManu2ex(VF1,VF2:Tvector;M00,M01,M10,M11:Tmatrix;var h0:float);
var
  nbtau:integer;
  t,t1,t2:integer;
  ind1,ind2,phi1,phi2:integer;
  m:array[0..1,0..1] of Tmatrix;

begin
  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/4);
  m[0,0]:=M00;
  m[0,1]:=M01;
  m[1,0]:=M10;
  m[1,1]:=M11;

  VF1.initTemp1(0,nbtau-1,g_double);
  VF2.initTemp1(0,nbtau-1,g_double);

  M00.initTemp(0,nbtau-1,0,nbtau-1,g_double);
  M01.initTemp(0,nbtau-1,0,nbtau-1,g_double);
  M10.initTemp(0,nbtau-1,0,nbtau-1,g_double);
  M11.initTemp(0,nbtau-1,0,nbtau-1,g_double);

  for t:=0 to nbtau-1 do
  begin
    VF1[t]:=chk.XX[t+1,1];
    VF2[t]:=chk.XX[t+1+nbtau,1];
  end;

  for t1:=0 to nbtau-1 do
  for t2:=0 to nbtau-1 do
  for phi1:=0 to 1 do
  for phi2:=0 to 1 do
  begin
    ind1:=t1+phi1*nbTau;
    ind2:=t2+phi2*nbTau;

    if ind1>=ind2
      then M[phi1,phi2][t1,t2]:=CHK.XX[1+nbTau*2 +ind1*(ind1+1) div 2+ind2,1]
      else M[phi1,phi2][t1,t2]:=CHK.XX[1+nbTau*2 +ind2*(ind2+1) div 2+ind1,1];
  end;

  h0:=chk.XX[2*nbtau + nbtau*(2*nbtau+1)+1,1];
end;


{******************************** MANU3 **********************************************}

procedure TCHKsolver.initManu3(nbtau:integer);
var
  nbInc:integer;
begin
  { Le nb d'inconnues est N + N*(N+1)/2  , soit
       N dans chaque 1er ordre
       N*(N+1)/2 dans K11
  }
  nbInc:= nbtau + nbtau*(nbtau+1) div 2;
  Init(nbInc,1);
end;

procedure TCHKsolver.FillManu3(In1, out1: Tvector; x1,x2:float);
var
  i,i1,i2:integer;
  tau,tau1,tau2:integer;
  Nphi:integer;
  x11,x12,x21,x22:float;
  ind1,ind2:integer;
  nbTau:integer;
begin
  { On range les coeffs dans l'ordre:
     H1       K11
     n        n*(n+1)/2          (nombre de coeffs)

  }

  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/2);

  i1:=out1.invconvx(x1);
  i2:=out1.invconvx(x2);

  if i1-nbtau+1<In1.Istart then i1:=In1.Istart+nbtau-1;

  for i:=I1 to I2 do
  begin
    CHK.clearMatSline;

    for tau:=0 to nbTau-1 do
      CHK.MatSline[tau]:=In1.Yvalue[i-tau];

    for tau1:=0 to nbTau-1 do
    for tau2:=0 to nbtau-1 do
    begin
      x11:=In1.Yvalue[i-tau1];                   {2eme indice = num entrée }
      x21:=In1.Yvalue[i-tau2];

      ind1:=tau1;
      ind2:=tau2;
      if ind1=ind2 then CHK.MatSline[nbTau +ind1*(ind1+1) div 2+ind2]:=x11*x21
      else
      if ind1>ind2 then CHK.MatSline[nbTau +ind1*(ind1+1) div 2+ind2]:=2*x11*x21;
    end;


    CHK.clearBXline;
    CHK.BXline[0]:= out1.Yvalue[i];

    CHK.UpdateHessian;
  end;


end;

procedure TCHKsolver.getManu3(VF1:Tvector;M00:Tmatrix);
var
  nbtau:integer;
  t,t1,t2:integer;
  ind1,ind2:integer;

begin
  nbtau:=round( (-3+sqrt(9+8*chk.Ni))/2);

  VF1.initTemp1(0,nbtau-1,g_double);

  M00.initTemp(0,nbtau-1,0,nbtau-1,g_double);

  for t:=0 to nbtau-1 do
    VF1[t]:=chk.XX[t+1,1];

  for t1:=0 to nbtau-1 do
  for t2:=0 to nbtau-1 do
  begin
    ind1:=t1;
    ind2:=t2;
    if ind1>=ind2
      then M00[t1,t2]:=CHK.XX[1+nbTau +ind1*(ind1+1) div 2+ind2,1]
      else M00[t1,t2]:=CHK.XX[1+nbTau +ind2*(ind2+1) div 2+ind1,1];
  end;
end;

procedure TCHKsolver.BuildLine1(Mat: Tmatrix; y: float; mode: integer);
var
  i1,j1,i2,j2,k1,k2: integer;
  i0,j0,N: integer;
  i,nb:integer;
  w:double;
begin
  N:= mat.Icount; // matrice carrée
  if mat.Jcount<>N then exit;
  case mode of
    1: if (CHK.Ni<>1+N*N) then exit;
    2: if (CHK.Ni<>1+2*N*N) then exit;
    3: if (CHK.Ni<>1+N*N+ N*N*(N*N+1) div 2) then exit;
  end;


  CHK.clearMatSline;
  CHK.clearBXline;
  CHK.BXline[0]:= y;

  CHK.MatSline[0]:=1;                    // constante


  with Mat do
  begin
    i0:=Istart;
    j0:=Jstart;
    

    nb:=0;
    for i1:=0 to Icount-1 do
    for j1:=0 to Jcount-1 do
    begin
      w:= Zvalue[I0+i1,J0+j1];
      CHK.MatSline[1+i1+N*j1]:=   w;         // 1er ordre

      if mode>1 then
      begin
        CHK.MatSline[101+i1+10*j1]:= sqr(w); // 2eme ordre diag

        if mode=3 then                       // 2eme ordre off diag
        for i2:=0 to 9 do
        for j2:=0 to 9 do
        begin
          k1:=i1+10*j1;
          k2:=i2+10*j2;
          if k1>k2 then
          begin
            inc(nb);
            CHK.MatSline[200+nb]:= 2*Zvalue[I0+i1,J0+j1]*Zvalue[I0+i2,J0+j2];
          end;
        end;
      end;
    end;
  end;
  CHK.UpdateHessian;
end;



{************************** Méthodes STM ********************************************}


procedure proTCHKsolver_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TCHKSolver);
end;

procedure proTCHKsolver_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TCHKSolver);
end;


procedure proTCHKsolver_Init(Ni1,Nt1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TCHKsolver(pu).Init(Ni1,Nt1);
end;

procedure proTCHKsolver_AddLine(var Coef,signal:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(Coef);
  verifierVecteur(signal);

  TCHKsolver(pu).AddLine(Coef,signal);
end;

procedure proTCHKsolver_AddLine_1(var Coef:Tvector; w:float ;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(Coef);

  TCHKsolver(pu).AddLine(Coef,w);
end;


procedure proTCHKsolver_Solve(var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).Solve(false);
end;

procedure proTCHKsolver_Solve_1(Fkeep:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).Solve(Fkeep);
end;


procedure proTCHKsolver_GetVector(code,ntau: integer;var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).GetVector(code,ntau,vec);
end;

procedure proTCHKsolver_GetResidual(var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).GetResidual(vec);
end;

function fonctionTCHKsolver_matH(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TCHKsolver(pu).CHK do
    result:=@matH;
end;

function fonctionTCHKsolver_matB(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TCHKsolver(pu).CHK do
    result:=@pstw;
end;

function fonctionTCHKsolver_matX(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TCHKsolver(pu).CHK do
    result:=@XX;
end;


function fonctionTCHKsolver_Residual(i:integer; var pu:typeUO):float;
begin
  verifierObjet(pu);
  dec(i);

  with TCHKsolver(pu).CHK do
  begin
    if (i<0) or (i>=Nt)
      then sortieErreur('TCHKsolver.Residual : index out of range');
    result:= residual(i);
  end;
end;

procedure proTCHKsolver_lambda(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).CHK.lambda:=w;
end;

function fonctionTCHKsolver_lambda(var pu:typeUO):float;
begin
  verifierObjet(pu);

  result:= TCHKsolver(pu).CHK.lambda;
end;

procedure proTCHKsolver_FillManu1(var In1,In2,out1:Tvector;nbtau,i1,i2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(In1);
  verifierVecteur(In2);
  verifierVecteur(out1);

  {Vérifier que les 3 vecteurs ont les mêmes indices}
  {Vérifier que nbInconnues=2*nbtau + 4*nbtau*nbtau }

  TCHKsolver(pu).FillManu1(In1,In2,out1,nbtau,i1,i2);
end;

procedure proTCHKsolver_InitManu2(nbtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).initManu2(nbtau);
end;

procedure proTCHKsolver_FillManu2(var In1,In2,out1:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(In1);
  verifierVecteur(In2);
  verifierVecteur(out1);

  TCHKsolver(pu).FillManu2(In1,In2,out1,x1,x2);
end;

procedure proTCHKsolver_FillManu2_1(var In1,In2,out1:Tvector;x1,x2:float;var VL:TVlist;var pu:typeUO);
var
  i,d:integer;

begin
  verifierObjet(pu);
  verifierVecteur(In1);
  verifierVecteur(In2);
  verifierVecteur(out1);
  verifierObjet(typeUO(VL));

  if VL.count>0 then
  begin
    d:=VL.Vectors[1].Icount;
    for i:=2 to VL.count do
    if VL.Vectors[i].Icount<>d then sortieErreur('TCHKsolver.FillManu2 : Vectors with bad Icount');
  end;


  TCHKsolver(pu).FillManu2(In1,In2,out1,x1,x2,VL);
end;



procedure proTCHKsolver_getManu2(var VF1,VF2:Tvector;var M00,M01,M10,M11:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(VF1);
  verifierVecteur(VF2);
  verifierMatrice(M00);
  verifierMatrice(M01);
  verifierMatrice(M10);
  verifierMatrice(M11);

  TCHKsolver(pu).getManu2(VF1,VF2, M00,M01,M10,M11);
end;


procedure proTCHKsolver_InitManu2ex(nbtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).initManu2ex(nbtau);
end;

procedure proTCHKsolver_FillManu2ex(var In1,In2,out1:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(In1);
  verifierVecteur(In2);
  verifierVecteur(out1);

  TCHKsolver(pu).FillManu2ex(In1,In2,out1,x1,x2);
end;

procedure proTCHKsolver_FillManu2ex_1(var In1,In2,out1:Tvector;x1,x2:float;var VL:TVlist;var pu:typeUO);
var
  i,d:integer;

begin
  verifierObjet(pu);
  verifierVecteur(In1);
  verifierVecteur(In2);
  verifierVecteur(out1);
  verifierObjet(typeUO(VL));

  if VL.count>0 then
  begin
    d:=VL.Vectors[1].Icount;
    for i:=2 to VL.count do
    if VL.Vectors[i].Icount<>d then sortieErreur('TCHKsolver.FillManu2ex : Vectors with bad Icount');
  end;


  TCHKsolver(pu).FillManu2ex(In1,In2,out1,x1,x2,VL);
end;



procedure proTCHKsolver_getManu2ex(var VF1,VF2:Tvector;var M00,M01,M10,M11:Tmatrix;var h0:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(VF1);
  verifierVecteur(VF2);
  verifierMatrice(M00);
  verifierMatrice(M01);
  verifierMatrice(M10);
  verifierMatrice(M11);

  TCHKsolver(pu).getManu2ex(VF1,VF2, M00,M01,M10,M11,h0);
end;


procedure proTCHKsolver_InitManu3(nbtau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TCHKsolver(pu).initManu3(nbtau);
end;

procedure proTCHKsolver_FillManu3(var In1,out1:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(In1);
  verifierVecteur(out1);

  TCHKsolver(pu).FillManu3(In1,out1,x1,x2);
end;

procedure proTCHKsolver_getManu3(var VF1:Tvector;var M00:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(VF1);
  verifierMatrice(M00);

  TCHKsolver(pu).getManu3(VF1,M00);
end;


procedure BuildManu2(In1,In2,out1:Tvector;VH1,VH2:Tvector;MK11,MK12,MK21,MK22:Tmatrix);
var
  i,j,k:integer;
  K00:array of array of double;
  K01:array of array of double;
  K10:array of array of double;
  K11:array of array of double;

  H1,H2:array of double;
  w:double;
  N:integer;
begin
  N:=VH1.Icount;
  setLength(H1,N);
  setLength(H2,N);

  setLength(K00,N,N);
  setLength(K01,N,N);
  setLength(K10,N,N);
  setLength(K11,N,N);


  for i:=0 to N-1 do
  begin
    H1[i]:=VH1[VH1.Istart+i];
    H2[i]:=VH2[VH2.Istart+i];
  end;

  for i:=0 to N-1 do
  for j:=0 to N-1 do
  begin
    K00[i,j]:=MK11[MK11.Istart+i,MK11.Jstart+j];
    K01[i,j]:=MK12[MK12.Istart+i,MK12.Jstart+j];
    K10[i,j]:=MK21[MK21.Istart+i,MK21.Jstart+j];
    K11[i,j]:=MK22[MK22.Istart+i,MK22.Jstart+j];
  end;

  with in1 do
  for i:=Istart to Iend do
  begin
    w:=0;

    for j:=0 to N-1 do
      if i>=j then
        w:=w+H1[j]*Yvalue[i-j];

    for j:=0 to N-1 do
      if i>=j then
        w:=w+H2[j]*in2.Yvalue[i-j];

    for j:=0 to N-1 do
    for k:=0 to N-1 do
      if (i>=j) and (i>=k) then
        w:=w+ K00[j,k]*Yvalue[i-j]*Yvalue[i-k];

    for j:=0 to N-1 do
    for k:=0 to N-1 do
      if (i>=j) and (i>=k) then
        w:=w + K01[j,k]*Yvalue[i-j]*in2.Yvalue[i-k];

    for j:=0 to N-1 do
    for k:=0 to N-1 do
      if (i>=j) and (i>=k) then
        w:=w + K10[j,k]*in2.Yvalue[i-j]*Yvalue[i-k];

    for j:=0 to N-1 do
    for k:=0 to N-1 do
      if (i>=j) and (i>=k) then
        w:=w + K11[j,k]*in2.Yvalue[i-j]*in2.Yvalue[i-k];


    out1.Yvalue[i]:=w;
  end;
end;


procedure proBuildManu2(var In1,in2,out1:Tvector;var VH1,VH2:Tvector;var MK11,MK12,MK21,MK22:Tmatrix);
begin
  verifierVecteur(In1);
  verifierVecteur(In2);
  verifierVecteurTemp(out1);
  verifierVecteur(VH1);
  verifierVecteur(VH2);

  verifierMatrice(MK11);
  verifierMatrice(MK12);
  verifierMatrice(MK21);
  verifierMatrice(MK22);

  if (In1.Istart<>In2.Istart) or (In1.Iend<>In2.Iend)
    then sortieErreur('BuildManu2 : In1 and In2 must have the same dimensions');

  if (VH1.Icount<>VH2.Icount) or
     (VH1.Icount<>MK11.Icount) or (VH1.Icount<>MK11.Jcount) or
     (VH1.Icount<>MK12.Icount) or (VH1.Icount<>MK12.Jcount) or
     (VH1.Icount<>MK21.Icount) or (VH1.Icount<>MK21.Jcount) or
     (VH1.Icount<>MK22.Icount) or (VH1.Icount<>MK22.Jcount)

    then sortieErreur('BuildManu2 : VH1,VH2,MK11,MK12,MK21 and MK22 must have the same dimensions');

  out1.modify(out1.tpNum,In1.Istart,In1.Iend);
  out1.Dxu:=In1.Dxu;
  out1.x0u:=In1.x0u;
  out1.Dyu:=In1.Dyu;
  out1.y0u:=In1.y0u;


  BuildManu2(In1,In2,out1,VH1,VH2,MK11,MK12,MK21,MK22);
end;


procedure BuildManu3(In1,out1:Tvector;VH:Tvector;MKK:Tmatrix);
var
  i,j,k:integer;
  KK:array of array of double;
  H:array of double;
  w:double;
  N:integer;
begin
  N:=VH.Icount;
  setLength(H,N);
  setLength(KK,N,N);

  for i:=0 to N-1 do
    H[i]:=VH[VH.Istart+i];

  for i:=0 to N-1 do
  for j:=0 to N-1 do
    KK[i,j]:=MKK[MKK.Istart+i,MKK.Jstart+j];

  with in1 do
  for i:=Istart to Iend do
  begin
    w:=0;

    for j:=0 to N-1 do
      if i>=j then
        w:=w+H[j]*Yvalue[i-j];

    for j:=0 to N-1 do
    for k:=0 to N-1 do
      if (i>=j) and (i>=k) then
        w:=w+ KK[j,k]*Yvalue[i-j]*Yvalue[i-k];

    out1.Yvalue[i]:=w;
  end;
end;


procedure proBuildManu3(var In1,out1:Tvector;var VH:Tvector;var MKK:Tmatrix);
begin
  verifierVecteur(In1);
  verifierVecteurTemp(out1);
  verifierVecteur(VH);
  verifierMatrice(MKK);

  if (VH.Icount<>MKK.Icount) or (VH.Icount<>MKK.Jcount)
    then sortieErreur('BuildManu3 : VH and MKK must have the same dimensions');

  out1.modify(out1.tpNum,In1.Istart,In1.Iend);
  out1.Dxu:=In1.Dxu;
  out1.x0u:=In1.x0u;
  out1.Dyu:=In1.Dyu;
  out1.y0u:=In1.y0u;


  BuildManu3(In1,out1,VH,MKK);
end;


procedure proTchkSolver_BlockSize(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if n<1 then sortieErreur('TchkSolver.BlockSize must be positive');

  with TchkSolver(pu) do
  begin
    chk.Mbloc:=n;
  end;
end;

function fonctionTchkSolver_BlockSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TchkSolver(pu) do
  begin
    result:=chk.Mbloc;
  end;
end;

procedure proTchkSolver_NormalizeBlock(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TchkSolver(pu) do
  begin
    chk.FnormaliseBloc:=w;
  end;
end;

function fonctionTchkSolver_NormalizeBlock(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TchkSolver(pu) do
  begin
    result:=chk.FNormaliseBloc;
  end;
end;


procedure proTCHKsolver_StoreISA2(var Vsrc,Vdest,Vbeta:Tvector; var pu:TchkSolver);
var
  i,p,q:integer;
  KK: double;
  Vdum1, Vdum2: Tvector;
  maxcoeff:integer;
  src,dest,beta: array of double;

begin
  verifierObjet(typeUO(pu));
  maxcoeff:=pu.CHK.Ni-1;

  setlength(src,Vsrc.Icount);
  for i:=Vsrc.Istart to Vsrc.Iend do src[i-Vsrc.Istart]:=Vsrc[i];

  setlength(dest,Vdest.Icount);
  for i:=Vdest.Istart to Vdest.Iend do dest[i-Vdest.Istart]:=Vdest[i];

  setlength(beta,Vbeta.Icount);
  for i:=Vbeta.Istart to Vbeta.Iend do beta[i-Vbeta.Istart]:=Vbeta[i];

  Vdum1:=Tvector.create(G_double,0,maxCoeff-1+1);
  Vdum2:=Tvector.create(G_double,0,0);

  try

  for i:= maxcoeff*2 to high(src)-maxcoeff div 2 do
  begin
    for p:=0 to maxCoeff-1 do
    begin
      KK:=0;
      for q:=0 to maxCoeff-1 do
        KK:=KK + beta[q]*src[i-p-q + maxcoeff div 2];

      Vdum1[p]:=KK;
    end;
    Vdum1[maxCoeff]:=1 ;

    Vdum2[0]:=dest[i];

    pu.addLine(Vdum1,Vdum2);
  end;

  finally
  Vdum1.Free;
  Vdum2.Free;
  end;
end;


procedure proTCHKsolver_BuildLine1(var Mat: Tmatrix; y: float; mode: integer; var pu:typeUO);
begin
  verifierObjet(pu);
  if (mode<1) or (mode>3) then sortieErreur('TCHKsolver.BuildLine1 : mode out of range');
  verifierObjet(typeUO(mat));

  TCHKsolver(pu).BuildLine1(Mat, y, mode);

end;




Initialization
AffDebug('Initialization stmchk0',0);

RegisterObject(TCHKSolver,data);

end.
