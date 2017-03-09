unit SimpleODE;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysutils,
     util1,stmVec1,adamsbdfG;

type
  TsimpleHH=class
              y : TVector;
              t, tout : double;
              Lsoda : TLsoda;

              Ivector:Tvector;

              Capa:double;
              gNa,gK,gL:double;
              ENa,EK,EL:double;

              constructor create;
              destructor destroy;override;
              procedure ComputeODEs (t : double; y, dydt : TVector);

              procedure Init;

              procedure next(tt:double);
            end;

procedure proMyHH(var src,dest1,dest2,dest3,dest4:Tvector);pascal;

implementation


Const V0=-58;

function alphaN(u:double):double;
begin
  result:=(0.1-0.01*u)/(exp(1-0.1*u)-1);
end;

function alphaM(u:double):double;
begin
  result:=(2.5-0.1*u)/(exp(2.5-0.1*u)-1);
end;

function alphaH(u:double):double;
begin
  result:=0.07*exp(-u/20);
end;

function betaN(u:double):double;
begin
  result:=0.125*exp(-u/80);
end;

function betaM(u:double):double;
begin
  result:=4*exp(-u/18);
end;

function betaH(u:double):double;
begin
  result:=1/(exp(3-0.1*u)+1);
end;



constructor TsimpleHH.create;
const
  K0=1 ;
begin
  y := TVector.Create (g_double,1,4);
  LSoda := TLsoda.Create (4);

  ENa:=115 +V0;
  EK:=-12  +V0;
  EL:= 10.6  +V0;

  gNa:=120  *K0;
  gK:=  36  *K0;
  gL:=   3  *K0;

  Capa:=1;
end;

destructor TsimpleHH.destroy;
begin
  y.free;
  LSoda.free;

  inherited;
end;


procedure TsimpleHH.ComputeODEs (t : double; y, dydt : TVector);
var
  u,m,n,h:double;
  w:double;
  It:double;
begin
  w:=y[1];
  m:=y[2];
  n:=y[3];
  h:=y[4];


  if (t>=Ivector.Xstart) and (t<=Ivector.Xend)
    then It:=Ivector.Rvalue[t]
  else It:=Ivector.Yvalue[Ivector.Iend];

  //It:=It/1E6;
  u:=w-V0;

  dydt[1] := 1/Capa*(It-gNa*m*m*m*h*(w-ENa)-gK*sqr(sqr(n))*(w-EK)-gL*(w-EL) );
  dydt[2] := alphaM(u)*(1-m)-betaM(u)*m;
  dydt[3] := alphaN(u)*(1-n)-betaN(u)*n;
  dydt[4] := alphaH(u)*(1-h)-betaH(u)*h;
end;


procedure TsimpleHH.Init;
var
  i:integer;
begin
  for i:=1 to Lsoda.nbEq do
  begin
    LSoda.rtol[i] := 1e-5;
    LSoda.atol[i] := 1e-5;
  end;

  t:=0;

  y[1] := 0;
  y[2] := 1;
  y[3] := 1;
  y[4] := 1;

  LSoda.itol := 2;
  LSoda.itask := 1;
  LSoda.istate := 1;
  LSoda.iopt := 0;
  LSoda.jt := 1;

  LSoda.Setfcn (ComputeODES);
end;


procedure TsimpleHH.next(tt:double);
begin
  tout:=tt;
  LSoda.execute (y, t, tout);

  if LSoda.istate < 0 then
    messageCentral ('Error, istate = '+Istr(LSoda.istate));
end;


procedure proMyHH(var src,dest1,dest2,dest3,dest4:Tvector);
var
  hh:TsimpleHH;
  i:integer;
begin
  hh:=TsimpleHH.create;

  verifierVecteur(src);
  verifierVecteurTemp(dest1);
  verifierVecteurTemp(dest2);
  verifierVecteurTemp(dest3);
  verifierVecteurTemp(dest4);


  try
    hh.Ivector:=src;
    with src do
    begin
      dest1.initTemp1(Istart,Iend,g_single);
      dest1.Dxu:=src.Dxu;
      dest1.x0u:=src.x0u;

      dest2.initTemp1(Istart,Iend,g_single);
      dest2.Dxu:=src.Dxu;
      dest2.x0u:=src.x0u;

      dest3.initTemp1(Istart,Iend,g_single);
      dest3.Dxu:=src.Dxu;
      dest3.x0u:=src.x0u;

      dest4.initTemp1(Istart,Iend,g_single);
      dest4.Dxu:=src.Dxu;
      dest4.x0u:=src.x0u;
    end;

    hh.Init;
    dest1.Yvalue[src.Istart]:=hh.y[1];
    dest2.Yvalue[src.Istart]:=hh.y[2];
    dest3.Yvalue[src.Istart]:=hh.y[3];
    dest4.Yvalue[src.Istart]:=hh.y[4];

    for i:=src.Istart+1 to src.Iend do
    begin
      hh.next(src.convx(i));
      dest1.Yvalue[i]:=hh.y[1];
      dest2.Yvalue[i]:=hh.y[2];
      dest3.Yvalue[i]:=hh.y[3];
      dest4.Yvalue[i]:=hh.y[4];
    end;

  finally
    hh.Free;
  end;


end;




end.
