unit stmCorA1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,
     util1,Dgraphic,stmdef,stmObj,debug0,
     stmvec1,
     stmPsth1,stmOdat2,stmPstA1,
     Ncdef2,stmError,stmPg;

type
  TCorrelogramArray=
    class(TpsthArray)

      class function STMClassName:AnsiString;override;

      constructor create;override;
      procedure initCorrelograms(n1,n2:longint;tNombre:typetypeG;classe:float);
      function cors(i,j:integer):TCorrelogram;

      procedure reinit;override;
    end;


procedure proTCorrelogramArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTCorrelogramArray_create_1(i1,i2,j1,j2: integer;var pu:typeUO);pascal;
procedure proTCorrelogramArray_create_2(i1,i2: integer;var pu:typeUO);pascal;

procedure proTCorrelogramArray_initObjects(tn:smallint;n1,n2:longint;classe:float;var pu:typeUO);pascal;

function fonctionTCorrelogramArray_V(i,j: integer;var pu:typeUO):pointer;pascal;
function fonctionTCorrelogramArray_V_1(i: integer;var pu:typeUO):pointer;pascal;

procedure proTCorrelogramArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTCorrelogramArray_modify_1(i1,i2: integer;var pu:typeUO);pascal;

implementation


class function TCorrelogramArray.STMClassName:AnsiString;
begin
  STMClassName:='CorrelogramArray';
end;


procedure TCorrelogramArray.initCorrelograms(n1,n2:longint;tNombre:typeTypeG;classe:float);
var
  i,j,k:integer;
begin
  inf.Imin:=n1;
  inf.Imax:=n2;

  for i:=imin to imax do
    for j:=jmin to jmax do
    begin
      k:=nblig*(i-imin)+j-jmin;
      uo^[k].free;
      uo^[k]:=TCorrelogram.create;
      TCorrelogram(uo^[k]).initTemp(n1,n2,tnombre,classe);

      uo^[k].Fchild:=true;
      uo^[k].ident:=ident+'.v['+Istr(i)+','+Istr(j)+']';
    end;

  initChildList;
  updateVectorParams;
end;

function TCorrelogramArray.Cors(i,j:integer):TCorrelogram;
  begin
    if (i>=imin) and (i<=imax) and (j>=jmin) and (j<=jmax) and assigned(uo)
     then result:=TCorrelogram(uo^[nblig*(i-imin)+j-jmin])
     else result:=nil;
  end;

constructor TCorrelogramArray.create;
begin
  inherited;
  UObase:=TCorrelogram;
end;

procedure TCorrelogramArray.reinit;
begin
  initArray(Imin,Imax,Jmin,Jmax);
  initCorrelograms(Istart,Iend,tpNum,dxu);
end;



{***********************  Méthodes STM de TCorrelogramArray ********************}

var
  E_CorrelogramArrayCreate:integer;
  E_indice:integer;
  E_typeVector:integer;


procedure proTCorrelogramArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  if (i1>i2) or (j1>j2)  then sortieErreur('TcorrelogramArray.create : bad index');

  createPgObject(name,pu,TCorrelogramArray);
  with TCorrelogramArray(pu) do initArray(i1,i2,j1,j2);
end;

procedure proTCorrelogramArray_create_1(i1,i2,j1,j2: integer;var pu:typeUO);
begin
  proTCorrelogramArray_create('',i1,i2,j1,j2, pu);
end;

procedure proTCorrelogramArray_create_2(i1,i2:integer;var pu:typeUO);
begin
  if (i1>i2)  then sortieErreur('TcorrelogramArray.create : bad index');

  createPgObject('',pu,TCorrelogramArray);
  with TCorrelogramArray(pu) do initArray1(i1,i2);
end;


procedure proTCorrelogramArray_initObjects(tn:smallint;n1,n2:longint;classe:float;var pu:typeUO);
begin
  if not (typeTypeG(tn) in typesVecteursSupportes)
    then sortieErreur(E_typeVector);

  verifierObjet(pu);
  with TCorrelogramArray(pu) do iniTCorrelograms(n1,n2,typeTypeG(tn),classe);
end;



function fonctionTCorrelogramArray_V(i,j:integer;var pu:typeUO):pointer;
begin
  result:= fonctionTvectorArray_V(i,j,pu);
end;

function fonctionTCorrelogramArray_V_1(i:integer;var pu:typeUO):pointer;
begin
  result:= fonctionTvectorArray_V_1(i,pu);
end;


procedure proTCorrelogramArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTvectorArray_modify(i1,i2,j1,j2,pu);
end;

procedure proTCorrelogramArray_modify_1(i1,i2:integer;var pu:typeUO);
begin
  proTvectorArray_modify_1(i1,i2,pu);
end;



Initialization
AffDebug('Initialization stmCorA1',0);
  installError(E_CorrelogramArrayCreate,'TCorrelogramArray.create: invalid parameter');

  installError(E_indice,'TCorrelogramArray: index out of range');

  installError(E_typeVector,'TCorrelogramArray.initCorrelograms: Type not supported');


end.

