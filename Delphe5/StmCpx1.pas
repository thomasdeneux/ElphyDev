unit StmCpx1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses math,
     util1,Dgraphic,Ncdef2;

function fonctionRe(z:TfloatComp):float;pascal;
function fonctionIm(z:TfloatComp):float;pascal;
function fonctionComp(x,y:float):TfloatComp;pascal;
function fonctionComp1(rho,theta:float):TfloatComp;pascal;

function fonctionMdl(z:TfloatComp):float;pascal;
function fonctionAngle(z:TfloatComp):float;pascal;
function fonctionAngle1(x,y:float):float;pascal;

function fonctionConj(z:TfloatComp):TfloatComp;pascal;

function fonctionCstr(z:TfloatComp;n,m:smallInt):AnsiString;pascal;



implementation

function fonctionRe(z:TfloatComp):float;
begin
  result:=z.x;
end;

function fonctionIm(z:TfloatComp):float;
begin
  result:=z.y;
end;

function fonctionComp(x,y:float):TfloatComp;
begin
  result.x:=x;
  result.y:=y;
end;

function fonctionComp1(rho,theta:float):TfloatComp;
begin
  result.x:=rho*cos(theta);
  result.y:=rho*sin(theta);
end;

function fonctionMdl(z:TfloatComp):float;
begin
  result:=sqrt(sqr(z.x)+sqr(z.y));
end;

function fonctionAngle(z:TfloatComp):float;
begin
  if (z.x=0) and (z.y=0)
    then result:=0
    else result:=arcTan2(z.y,z.x);         { L'ordre est bien y,x }
end;

function fonctionAngle1(x,y:float):float;
begin
  if (x=0) and (y=0)
    then result:=0
    else result:=arcTan2(y,x);             { L'ordre est bien y,x }
end;

function fonctionCstr(z:TfloatComp;n,m:smallInt):AnsiString;
begin
  result:=Estr1(z.x,n,m)+'+i'+Estr1(z.y,n,m);
end;

function fonctionConj(z:TfloatComp):TfloatComp;
begin
  result.x:=z.x;
  result.y:=-z.y;
end;


end.
