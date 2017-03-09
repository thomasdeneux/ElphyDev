unit stmMatImageA1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,stmdef,stmObj,varconf1,
     stmvec1,stmMat1,stmMatA1,stmMatImage,
     Ncdef2,stmPg;

type
  TmatImageArray=
    class(TmatrixArray)
      class function STMClassName:AnsiString;override;

      constructor create;override;

      procedure initMatrix(tNombre:typetypeG;i1,i2,j1,j2:integer);
      function Matrix(i,j:integer):TMatImage;

    end;

procedure proTmatImageArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTmatImageArray_initObjects(tn:integer;ncol,nrow:longint;var pu:typeUO);pascal;
function fonctionTmatImageArray_M(i,j:integer;var pu:typeUO):pointer;pascal;
procedure proTmatImageArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);pascal;


implementation

constructor TmatImageArray.create;
begin
  inherited;
  UObase:=TmatImage;
end;

class function TmatImageArray.STMClassName:AnsiString;
begin
  STMClassName:='MatImageArray';
end;


procedure TmatImageArray.initMatrix(tNombre:typeTypeG;i1,i2,j1,j2:integer);
var
  i,j,k:integer;
begin
  inf.Imin:=i1;
  inf.Imax:=i2;
  inf.Jmin:=j1;
  inf.Jmax:=j2;

  for i:=imin to imax do
    for j:=jmin to jmax do
    begin
      k:=nbCol*(j-jmin)+i-imin;
      uo^[k].free;
      uo^[k]:=TMatImage.create;
      TMatImage(uo^[k]).initTemp(i1,i2,j1,j2,tnombre);

      uo^[k].Fchild:=true;
      uo^[k].ident:=ident+'.v['+Istr(i)+','+Istr(j)+']';
    end;

  initChildList;

  autoscaleX;
  autoscaleY;
  updateVectorParams;
end;

function TmatImageArray.Matrix(i,j:integer):TMatImage;
  begin
    if (i>=imin) and (i<=imax) and (j>=jmin) and (j<=jmax) and assigned(uo)
     then result:=TMatImage(uo^[nbCol*(j-jmin)+i-imin])
     else result:=nil;
  end;



{**********************  Méthodes STM *****************************************}

procedure proTmatImageArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  createPgObject(name,pu,TmatImageArray);

  if (i2-i1<0) or (i2-i1>32000) or
     (j2-j1<0) or (j2-j1>32000)  then sortieErreur('TmatImageArray.create : index out of range');

  with TmatImageArray(pu) do initArray(i1,i2,j1,j2);
end;


procedure proTmatImageArray_initObjects(tn:integer;ncol,nrow:longint;var pu:typeUO);
begin
  if not (typeTypeG(tn) in typesIMSupportes)
    then sortieErreur('TmatImageArray_initObjects : invalid number type');

  verifierObjet(pu);
  with TmatImageArray(pu) do iniTMatrix(typeTypeG(tn),0,ncol-1,0,nrow-1);
end;



function fonctionTmatImageArray_M(i,j:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with TmatImageArray(pu) do
  begin
    ControleParam(i,Imin,Imax,'TmatImageArray.M : index out of range');
    ControleParam(j,Jmin,Jmax,'TmatImageArray.M : index out of range');
    result:=@uo^[nbCol*(j-jmin)+i-imin];
  end;
end;

procedure proTmatImageArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (i2-i1<0) or (i2-i1>32000) or
     (j2-j1<0) or (j2-j1>32000)  then sortieErreur('TmatImageArray.modify : index out of range');

  with TmatImageArray(pu) do initArray(i1,i2,j1,j2);
end;


end.
