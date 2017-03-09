unit stmPstA1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,
     util1,Dgraphic,Dtrace1,stmdef,stmObj,debug0,
     stmvec1,
     stmPsth1,stmOdat2,
     Ncdef2,stmError,stmPg;

type
  TpsthArray=
    class(TvectorArray)

      constructor create;override;
      destructor destroy; override;
      class function STMClassName:AnsiString;override;

      procedure initPsths(n1,n2:longint;tNombre:typetypeG;classe:float);
      function Psths(i,j:integer):Tpsth;

      procedure reinit;override;
      procedure saveData(f:Tstream);override;
      function loadData(f:Tstream):boolean;override;

    end;


procedure proTpsthArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTpsthArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTpsthArray_create_2(i1,i2:integer;var pu:typeUO);pascal;

procedure proTpsthArray_initObjects(tn:integer;n1,n2:longint;classe:float;var pu:typeUO);pascal;

function fonctionTpsthArray_V(i,j:integer;var pu:typeUO):pointer;pascal;
function fonctionTpsthArray_V_1(i:integer;var pu:typeUO):pointer;pascal;

procedure proTPsthArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTPsthArray_modify_1(i1,i2: integer;var pu:typeUO);pascal;

implementation

constructor TpsthArray.create;
begin
  inherited;

  UObase:=Tpsth;
  visu.color:=rgb(0,128,128);
  visu.modeT:=dm_histo0;
end;

destructor TpsthArray.destroy;
begin
  inherited;
end;


class function TpsthArray.STMClassName:AnsiString;
begin
  STMClassName:='PsthArray';
end;


procedure TpsthArray.initPsths(n1,n2:longint;tNombre:typeTypeG;classe:float);
var
  k:integer;
begin
  inf.Imin:=n1;
  inf.Imax:=n2;
  dxu:=classe;

  for k:= 0 to nbobj-1 do
    begin
      uo^[k].free;
      uo^[k]:=Tpsth.create;
      Tpsth(uo^[k]).initTemp(n1,n2,tnombre,classe);

      uo^[k].Fchild:=true;
      uo^[k].ident:= BuildIdent(k);
    end;

  initChildList;
  updateVectorParams;
end;

function TpsthArray.psths(i,j:integer):Tpsth;
begin
  if (nbdim=2) and (i>=imin) and (i<=imax) and (j>=jmin) and (j<=jmax) and assigned(uo)
     then result:=Tpsth(uo^[nblig*(i-imin)+j-jmin])
     else result:=nil;
end;

procedure TpsthArray.reinit;
begin
  if NbDim=1
    then initArray1(indminA[1],indmaxA[1])                        // NbDim=1
    else initArray(indminA[1],indmaxA[1],indminA[2],indmaxA[2]);  // NbDim=2

  initPsths(Istart,Iend,tpNum,dxu);
end;


{***********************  Méthodes STM de TpsthArray ********************}

var
  E_PsthArrayCreate:integer;
  E_indice:integer;
  E_typeVector:integer;


procedure proTpsthArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  if (i1>i2) or (j1>j2)  then sortieErreur('TpsthArray.create : bad index');
  createPgObject(name,pu,TpsthArray);

  with TpsthArray(pu) do initArray(i1,i2,j1,j2);
end;

procedure proTpsthArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTpsthArray_create('',i1,i2,j1,j2,pu);
end;

procedure proTpsthArray_create_2(i1,i2:integer;var pu:typeUO);
begin
  if (i1>i2)  then sortieErreur('TpsthArray.create : bad index');
  createPgObject('',pu,TpsthArray);

  with TpsthArray(pu) do initArray1(i1,i2);
end;


procedure proTpsthArray_initObjects(tn:integer;n1,n2:longint;classe:float;var pu:typeUO);
begin
  if not (typeTypeG(tn) in typesVecteursSupportes)
    then sortieErreur(E_typeVector);

  verifierObjet(pu);
  with TpsthArray(pu) do iniTpsths(n1,n2,typeTypeG(tn),classe);
end;



function fonctionTpsthArray_V(i,j:integer;var pu:typeUO):pointer;
begin
  result:= fonctionTvectorArray_V(i,j,pu);
end;

function fonctionTpsthArray_V_1(i:integer;var pu:typeUO):pointer;
begin
  result:= fonctionTvectorArray_V_1(i,pu);
end;


procedure proTPsthArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTvectorArray_modify(i1,i2,j1,j2,pu);
end;

procedure proTPsthArray_modify_1(i1,i2:integer;var pu:typeUO);
begin
  proTvectorArray_modify_1(i1,i2,pu);
end;




function TpsthArray.loadData(f: Tstream): boolean;
var
  i,size:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if size<> ((Iend-Istart+1)*tailleTypeG[tpNum] +4)*nbObj then exit;

  for i:=0 to nbObj-1 do
  with Tpsth(uo[i]) do
  begin
    if assigned(data) then data.readBlockFromStream(f,0,Istart,Iend,tpNum);
    f.Read(count,sizeof(count));
  end;

  modifiedData:=true;
end;



procedure TpsthArray.saveData(f: Tstream);
var
  i,sz:integer;
begin
  if not CanCompact then exit;

  sz:=((Iend-Istart+1)*tailleTypeG[tpNum] +4)*nbObj;
  writeDataHeader(f,sz);
  for i:=0 to nbObj-1 do
  with Tpsth(uo[i]) do
  begin
    if assigned(data) then data.writeBlockToStream(f,Istart,Iend,tpNum);
    f.Write(count,sizeof(count));
  end;



end;


Initialization
AffDebug('Initialization Stmpsta1',0);
  registerObject(TpsthArray,data);

  installError(E_PsthArrayCreate,'TpsthArray.create: invalid parameter');
  installError(E_indice,'TpsthArray: index out of range');
  installError(E_typeVector,'TpsthArray.initPsths: Type not supported');


end.
