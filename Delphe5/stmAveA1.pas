unit stmAveA1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,
     util1,Dgraphic,stmdef,stmObj,varconf1, debug0,
     stmvec1,
     stmAve1,stmOdat2,
     Ncdef2,stmError,stmPg,
     stmMat1;

type
  TaverageArray=
    class(TvectorArray)
      stdOn:boolean;
      sqrs,stdDev,stdUp,stdDw:TvectorArray;

      constructor create;override;
      destructor destroy; override;
      class function STMClassName:AnsiString;override;

      procedure initChildList;override;
      procedure setChildNames;override;
      procedure setChilds;

      procedure initArray(i1,i2,j1,j2:integer);override;
      procedure initArray1(i1,i2:integer);override;

      procedure initAverages(n1,n2:longint;tNombre:typetypeG);
      function Average(i,j:integer):Taverage;

      procedure setStdON(w:boolean);

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      procedure reinit;override;

      procedure updateStdDev;

      function CanCompact: boolean;override;
      procedure saveData(f:Tstream);override;
      function loadData(f:Tstream):boolean;override;

    end;


procedure proTaverageArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTaverageArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTaverageArray_create_2(i1,i2:integer;var pu:typeUO);pascal;

procedure proTaverageArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTaverageArray_modify_1(i1,i2: integer;var pu:typeUO);pascal;

procedure proTaverageArray_initObjects(tn:integer;n1,n2:longint;var pu:typeUO);pascal;

function fonctionTaverageArray_V(i,j:integer;var pu:typeUO):pointer;pascal;
function fonctionTaverageArray_V_1(i:integer;var pu:typeUO):pointer;pascal

procedure proTaverageArray_StdOn(w:boolean;var pu:typeUO); pascal;
function fonctionTaverageArray_StdOn(var pu:typeUO):boolean;pascal;

function fonctionTaverageArray_VSqrs(var pu:typeUO):TvectorArray;pascal;
function fonctionTaverageArray_VstdDev(var pu:typeUO):TvectorArray;pascal;
function fonctionTaverageArray_VStdUp(var pu:typeUO):TvectorArray;pascal;
function fonctionTaverageArray_VStdDw(var pu:typeUO):TvectorArray;pascal;
Procedure proTaverageArray_UpdateStdDev(var pu:typeUO); pascal;

implementation


constructor TaverageArray.create;
begin
  inherited;

  UObase:=Taverage;

  Sqrs:=TvectorArray.create;
  stdDev:=TvectorArray.create;
  stdUp:=TvectorArray.create;
  stdDw:=TvectorArray.create;

  setChilds;

  initChildList;
end;

destructor TaverageArray.destroy;
begin
  Sqrs.free;
  stdDev.free;
  stdUp.free;
  stdDw.free;

  Sqrs:=nil;
  stdDev:=nil;
  stdUp:=nil;
  stdDw:=nil;

  inherited;
end;


class function TaverageArray.STMClassName:AnsiString;
begin
  STMClassName:='AverageArray';
end;

procedure TaverageArray.initChildList;
var
  i,j,k:integer;
begin
  ClearChildList;

  if assigned(Sqrs) then
  begin
    AddtochildList(Sqrs);
    AddtochildList(stdDev);
    AddTochildList(stdUp);
    AddTochildList(stdDw);
  end;

  if initOK then
    for k:= 0 to nbobj-1 do  AddTochildList(uo^[k]);

end;

procedure TaverageArray.setChildNames;
var
  i:integer;
begin
  inherited;

  with Sqrs do
  begin
    ident:=self.ident+'.Vsqrs';
    notPublished:=true;
    Fchild:=true;
  end;

  with stdDev do
  begin
    ident:=self.ident+'.VstdDev';
    notPublished:=true;
    Fchild:=true;
  end;

  with stdUp do
  begin
    ident:=self.ident+'.VstdUp';
    notPublished:=true;
    Fchild:=true;
  end;

  with stdDw do
  begin
    ident:=self.ident+'.VstdDw';
    notPublished:=true;
    Fchild:=true;
  end;

end;

procedure TaverageArray.setChilds;
var
  i,j:integer;
begin
  setChildNames;

  if initOK then
  for i:= 0 to nbobj-1 do Taverage(uo[i]).setChilds;

  Sqrs.visu.color:=clBlue;
  stdDev.visu.color:=clBlue;
  stdUp.visu.color:=clGreen;
  stdDw.visu.color:=clGreen;

end;


procedure TaverageArray.initArray(i1,i2,j1,j2:integer);
begin
  inherited;

  sqrs.initArray(i1,i2,j1,j2);
  stdDev.initArray(i1,i2,j1,j2);
  stdUp.initArray(i1,i2,j1,j2);
  stdDw.initArray(i1,i2,j1,j2);

end;

procedure TaverageArray.initArray1(i1,i2:integer);
begin
  inherited;

  sqrs.initArray1(i1,i2);
  stdDev.initArray1(i1,i2);
  stdUp.initArray1(i1,i2);
  stdDw.initArray1(i1,i2);
end;


procedure TaverageArray.initAverages(n1,n2:longint;tNombre:typeTypeG);
var
  i,j,k:integer;
begin
  inf.Imin:=n1;
  inf.Imax:=n2;

  for k:=0 to nbobj-1 do
    begin
      uo^[k].free;
      uo^[k]:=Taverage.create;
      Taverage(uo^[k]).initTemp1(n1,n2,tnombre);

      uo^[k].Fchild:=true;
      uo^[k].ident:= BuildIdent(k);

      Sqrs.setVectorEx(k,Taverage(uo^[k]).Sqrs);
      stdDev.setVectorEx(k,Taverage(uo^[k]).stdDev);
      stdUp.setVectorEx(k,Taverage(uo^[k]).stdUp);
      stdDw.setVectorEx(k,Taverage(uo^[k]).stdDw);

    end;

  {
  sqrs.initChildList;
  stdDev.initChildList;
  stdUp.initChildList;
  stdDw.initChildList;
  }
  setChilds;
  initChildList;

  updateVectorParams;
end;

function TAverageArray.average(i,j:integer):Taverage;
begin
  if (nbDim=2) and (i>=imin) and (i<=imax) and (j>=jmin) and (j<=jmax) and assigned(uo)
     then result:=Taverage(uo^[nblig*(i-imin)+j-jmin])
     else result:=nil;
  end;

procedure TAverageArray.setStdON(w:boolean);
var
  i:integer;
begin
  StdOn:=w;
  if not initOK then exit;

  for i:=0 to nbobj-1 do Taverage(uo^[i]).setStdOn(w);

  sqrs.inf.Imin:=uo^[0].Istart;
  sqrs.inf.Imax:=uo^[0].Iend;
  sqrs.inf.tpNum:=uo^[0].tpNum;
  sqrs.dxu:=uo^[0].dxu;

  stdDev.inf.Imin:=uo^[0].Istart;
  stdDev.inf.Imax:=uo^[0].Iend;
  stdDev.inf.tpNum:=uo^[0].tpNum;
  stdDev.dxu:=uo^[0].dxu;

  stdUp.inf.Imin:=uo^[0].Istart;
  stdUp.inf.Imax:=uo^[0].Iend;
  stdUp.inf.tpNum:=uo^[0].tpNum;
  stdUp.dxu:=uo^[0].dxu;

  stdDw.inf.Imin:=uo^[0].Istart;
  stdDw.inf.Imax:=uo^[0].Iend;
  stdDw.inf.tpNum:=uo^[0].tpNum;
  stdDw.dxu:=uo^[0].dxu;

end;



procedure TaverageArray.completeLoadInfo;
begin
  inherited;
end;

procedure TaverageArray.reinit;
begin
  if NbDim=1
    then initArray1(indminA[1],indmaxA[1])                        // NbDim=1
    else initArray(indminA[1],indmaxA[1],indminA[2],indmaxA[2]);  // NbDim=2

  initAverages(Istart,Iend,tpNum);
  setStdON(stdON);

  if stdON then
  begin
    sqrs.initDisp;
    stdDev.initDisp;
    stdUp.initDisp;
    stdDw.initDisp;
  end;
end;

procedure TaverageArray.BuildInfo(var conf: TblocConf; lecture,
  tout: boolean);
begin
  inherited;
  with conf do
    setvarconf('stdON',stdON,sizeof(stdON));
end;

procedure TaverageArray.updateStdDev;
var
  i:integer;
begin
  if not initOK then exit;

  for i:=0 to nbobj-1 do Taverage(uo^[i]).updateStdDev;
end;


function TaverageArray.CanCompact: boolean;
begin
  result:= inherited CanCompact; // rien à ajouter ?
end;

function TaverageArray.loadData(f: Tstream): boolean;
var
  i,size,sz,w:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if stdON
    then sz:=( (Iend-Istart+1)*(tailleTypeG[tpNum]+sizeof(double) ) +4)*nbObj  // on sauve Sqrs et count
    else sz:=( (Iend-Istart+1)*tailleTypeG[tpNum] +4)*nbObj;
  if size<>sz then exit;

  for i:=0 to nbObj-1 do
  begin
    with Taverage(uo[i]) do
    begin
      if assigned(data) then data.readBlockFromStream(f,0,Istart,Iend,tpNum);
      f.Read(w,sizeof(w));
      count:=w;
    end;
    if StdON then
    with Taverage(uo[i]).Sqrs do
      if assigned(data) then data.readBlockFromStream(f,0,Istart,Iend,tpNum);
  end;

  UpdateStdDev;

  modifiedData:=true;
end;


procedure TaverageArray.saveData(f: Tstream);
var
  i,sz,w:integer;
begin
  if not CanCompact then exit;

  if stdON
    then sz:=( (Iend-Istart+1)*(tailleTypeG[tpNum]+sizeof(double) ) +4)*nbObj  // on sauve Sqrs et count
    else sz:=( (Iend-Istart+1)*tailleTypeG[tpNum] +4)*nbObj;

  writeDataHeader(f,sz);
  for i:=0 to nbObj-1 do
  begin
    with Taverage(uo[i]) do
    begin
      if assigned(data) then data.writeBlockToStream(f,Istart,Iend,tpNum);
      w:=count;
      f.Write(w,sizeof(w));
    end;

    if stdON then
    with Taverage(uo[i]).Sqrs do
      if assigned(data) then data.writeBlockToStream(f,Istart,Iend,tpNum);
  end;
end;


{***********************  Méthodes STM de TaverageArray ********************}

var
  E_AverageArrayCreate:integer;
  E_indice:integer;
  E_typeVector:integer;


procedure proTaverageArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  createPgObject(name,pu,TaverageArray);

  if (i1>i2) or (j1>j2)  then sortieErreur('TaverageArray.create : bad index');

  with TaverageArray(pu) do initArray(i1,i2,j1,j2);
end;

procedure proTaverageArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTaverageArray_create('',i1,i2,j1,j2, pu);
end;

procedure proTaverageArray_create_2(i1,i2:integer;var pu:typeUO);
begin
  createPgObject('',pu,TaverageArray);

  if (i1>i2) then sortieErreur('TaverageArray.create : bad index');

  with TaverageArray(pu) do initArray1(i1,i2);
end;


procedure proTaverageArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTvectorArray_modify(i1,i2,j1,j2,pu);
end;

procedure proTaverageArray_modify_1(i1,i2:integer;var pu:typeUO);
begin
  proTvectorArray_modify_1(i1,i2,pu);
end;

procedure proTaverageArray_initObjects(tn:integer;n1,n2:longint;var pu:typeUO);
begin
  if not (typeTypeG(tn) in typesVecteursSupportes)
    then sortieErreur(E_typeVector);

  verifierObjet(pu);
  with TaverageArray(pu) do initAverages(n1,n2,typeTypeG(tn));
end;



function fonctionTaverageArray_V(i,j:integer;var pu:typeUO):pointer;
begin
  result:= fonctionTvectorArray_V(i,j,pu);
end;

function fonctionTaverageArray_V_1(i:integer;var pu:typeUO):pointer;
begin
  result:= fonctionTvectorArray_V_1(i,pu);
end;


procedure proTaverageArray_StdOn(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TaverageArray(pu).setStdON(w);
end;


function fonctionTaverageArray_StdOn(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TaverageArray(pu).stdOn;
end;

function fonctionTaverageArray_VSqrs(var pu:typeUO):TvectorArray;
begin
  verifierObjet(pu);
  with TaverageArray(pu) do result:=@Sqrs.myAd;
end;

function fonctionTaverageArray_VstdDev(var pu:typeUO):TvectorArray;
begin
  verifierObjet(pu);
  with TaverageArray(pu) do result:=@stdDev.myAd;
end;

function fonctionTaverageArray_VStdUp(var pu:typeUO):TvectorArray;
begin
  verifierObjet(pu);
  with TaverageArray(pu) do result:=@StdUp.myAd;
end;

function fonctionTaverageArray_VStdDw(var pu:typeUO):TvectorArray;
begin
  verifierObjet(pu);
  with TaverageArray(pu) do result:=@StdDw.myAd;
end;

Procedure proTaverageArray_UpdateStdDev(var pu:typeUO);
begin
  verifierObjet(pu);
  with TaverageArray(pu) do UpdateStdDev;
end;



Initialization
AffDebug('Initialization stmAveA1',0);
  installError(E_averageArrayCreate,'TAverageArray.create: invalid parameter');

  installError(E_indice,'TAverageArray: index out of range');

  installError(E_typeVector,'TAverageArray.initVectors: Type not supported');

  registerObject(TaverageArray,data);
end.
