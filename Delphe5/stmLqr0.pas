unit stmLqr0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,debug0,
     stmDef,stmObj,stmVec1,stmPg,NcDef2,
     LqrPstw1;

type
  TLQRsolver=
    class(typeUO)
      lqr:TlqrPstw;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;

      Procedure InitMats(Ni1,Nt1,Neq1:integer);
      Procedure Init(Ni1,Nt1:integer);
      Procedure AddLine(vecCoeff,vecSignal:Tvector);
      Procedure Solve;
      Procedure GetVector(code,ntau: integer; vec: Tvector);
      procedure getResidual(vec: Tvector);
    end;

procedure proTLQRsolver_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTLQRsolver_InitMats(Ni1,Nt1,Neq1:integer;var pu:typeUO);pascal;
procedure proTLQRsolver_Init(Ni1,Nt1:integer;var pu:typeUO);pascal;
procedure proTLQRsolver_AddLine(var Coef,signal:Tvector;var pu:typeUO);pascal;
procedure proTLQRsolver_Solve(var pu:typeUO);pascal;
procedure proTLQRsolver_GetVector(code,ntau: integer;var vec: Tvector; var pu:typeUO);pascal;
procedure proTLQRsolver_GetResidual(var vec: Tvector; var pu:typeUO);pascal;

function fonctionTLQRsolver_matA(var pu:typeUO):pointer;pascal;

function fonctionTLQRsolver_matB(var pu:typeUO):pointer;pascal;

function fonctionTLQRsolver_matX(var pu:typeUO):pointer;pascal;

function fonctionTLQRsolver_Residual(i:integer; var pu:typeUO):float;pascal;

implementation

{ TLQRsolver }


constructor TLQRsolver.create;
begin
  inherited;
  lqr:=TlqrPstw.create;
end;

destructor TLQRsolver.destroy;
begin
  lqr.Free;
  inherited;
end;


class function TLQRsolver.STMClassName: AnsiString;
begin
  result:='LQRsolver';
end;

procedure TLQRsolver.Init(Ni1, Nt1: integer);
begin
  if (Ni1<1) or (Nt1<1) then sortieErreur('TLQRsolver.Init: invalid parameter');
  lqr.Init(Ni1,Nt1);
end;

procedure TLQRsolver.InitMats(Ni1, Nt1,Neq1: integer);
begin
  if (Ni1<1) or (Nt1<1) or (Neq1<1)
    then sortieErreur('TLQRsolver.InitMats: invalid parameter');
  lqr.InitMats(Ni1,Nt1,Neq1);
end;


procedure TLQRsolver.AddLine(vecCoeff, vecSignal: Tvector);
var
  i:integer;
begin
  if vecCoeff.Icount<>lqr.Ni
    then sortieErreur('TLQRsolver.AddLine: firstVector.Icount must be equal to Ni');

  if vecSignal.Icount<>lqr.Nt
    then sortieErreur('TLQRsolver.AddLine: SecondVector.Icount must be equal to Nt');

  lqr.Newline;

  with vecCoeff do
  for i:=Istart to Iend do
    lqr.MatSline[i-Istart]:= Yvalue[i];

  with vecSignal do
  for i:=Istart to Iend do
    lqr.BXline[i-Istart]:= Yvalue[i];
end;

procedure TLQRsolver.Solve;
begin
  lqr.SolveLqr(false);
end;


procedure TLQRsolver.getResidual(vec: Tvector);
begin
  lqr.getResidual(vec);
end;

procedure TLQRsolver.GetVector(code, ntau: integer; vec: Tvector);
begin
  lqr.getVector(code,ntau,vec,false);

end;

{************************** Méthodes STM ********************************************}


procedure proTLQRsolver_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TlqrSolver);
end;

procedure proTLQRsolver_InitMats(Ni1,Nt1,Neq1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TLQRsolver(pu).InitMats(Ni1,Nt1,Neq1);
end;

procedure proTLQRsolver_Init(Ni1,Nt1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  TLQRsolver(pu).Init(Ni1,Nt1);
end;

procedure proTLQRsolver_AddLine(var Coef,signal:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(Coef);
  verifierVecteur(signal);

  TLQRsolver(pu).AddLine(Coef,signal);
end;

procedure proTLQRsolver_Solve(var pu:typeUO);
begin
  verifierObjet(pu);
  TLQRsolver(pu).Solve;
end;

procedure proTLQRsolver_GetVector(code,ntau: integer;var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  TLQRsolver(pu).GetVector(code,ntau,vec);
end;

procedure proTLQRsolver_GetResidual(var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  TLQRsolver(pu).GetResidual(vec);
end;


function fonctionTLQRsolver_matA(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TLQRsolver(pu).lqr do result:=@MatS;
end;

function fonctionTLQRsolver_matB(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TLQRsolver(pu).lqr do result:=@BX;
end;

function fonctionTLQRsolver_matX(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TLQRsolver(pu).lqr do result:=@XX;
end;


function fonctionTLQRsolver_Residual(i:integer; var pu:typeUO):float;
begin
  verifierObjet(pu);
  dec(i);

  with TLQRsolver(pu).lqr do
  begin
    if (i<0) or (i>=Nt)
      then sortieErreur('TLQRsolver.Residual : index out of range');
    result:= residual(i);
  end;
end;



Initialization
AffDebug('Initialization stmLqr0',0);

RegisterObject(TlqrSolver,data);

end.
