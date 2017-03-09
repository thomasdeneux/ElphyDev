unit RArray1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Gdos,varconf1,dtf0,Dgraphic,
     stmDef,stmObj,stmData0,stmVec1,
     DtbEdit2, iniRA0,
     debug0,
     Ncdef2,stmError,stmPg;


type
  TarrayEditor=TTableEdit;

  TrealArray=
    class(Tdata0)
    private
      decimale:array[1..256] of byte;
      immediat:boolean;

      procedure setValue(i,j:integer;x:float);
      function getValue(i,j:integer):float;

      procedure setDeci(i:integer;w:integer);
      function getDeci(i:integer):integer;

      procedure DsetColName (i:integer;st:AnsiString);
      function DgetColName (i:integer):AnsiString;

      function DdragVector(col:integer):boolean;

      procedure DinvalidateCell(col,row:integer);
      procedure DinvalidateVector(col:integer);
      procedure DinvalidateAll;

      procedure Dprint;

    public
      nbCol,nbLig:integer;

      Vcol:array[1..256] of Tvector;

      error:boolean;
      property value[i,j:integer]:float read getValue write setValue;

      class function STMClassName:AnsiString;override;

      constructor create;override;
      destructor destroy;override;


      procedure initVecs;
      procedure initTemp(nbc,nbl:integer);

      procedure createForm;override;
      function initialise(st:AnsiString):boolean;override;

      procedure modify(nbc,nbl:integer);

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeSaveInfo;override;

      procedure Dshow(num:integer);
      procedure Dproperties;

      procedure saveToStream(f:Tstream;Fdata:boolean);override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

      procedure fill1(i1,i2,j1,j2:integer;x:float);
      procedure clear;override;
    end;

procedure proTrealArray_create(name:AnsiString;col,lig:longint;var pu:typeUO);pascal;
procedure proTrealArray_create_1(col,lig:longint;var pu:typeUO);pascal;

procedure proTrealArray_modify(nbc,nbl:integer;var pu:typeUO);pascal;
procedure proTrealArray_show(var pu:typeUO);pascal;

procedure proTrealArray_t(i,j:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t(i,j:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t1(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t1(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t2(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t2(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t3(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t3(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t4(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t4(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t5(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t5(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t6(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t6(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t7(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t7(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t8(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t8(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t9(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t9(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t10(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t10(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t11(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t11(i:integer;var pu:typeUO):float;pascal;

procedure proTrealArray_t12(i:integer;x:float;var pu:typeUO);pascal;
function fonctionTrealArray_t12(i:integer;var pu:typeUO):float;pascal;

function fonctionTrealArray_tN(i:integer;var pu:typeUO):pointer;pascal;

function fonctionTrealArray_tN1(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN2(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN3(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN4(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN5(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN6(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN7(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN8(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN9(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN10(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN11(var pu:typeUO):pointer;pascal;
function fonctionTrealArray_tN12(var pu:typeUO):pointer;pascal;


procedure proTrealArray_NomTab(num:integer;st:AnsiString;var pu:typeUO);pascal;
procedure proTrealArray_columnName(i:integer;st:AnsiString;var pu:typeUO);pascal;
function fonctionTrealArray_columnName(i:integer;var pu:typeUO):AnsiString;pascal;

procedure proTrealArray_SauverTableau(st:AnsiString;lig1,lig2,col1,col2:integer;
                        sauverNom:boolean;charsep:AnsiString;var pu:typeUO);pascal;

function fonctionTrealArray_ChargerTableau(st:AnsiString;ChargerNom:boolean;
                         lig1,col1:integer;
                         var lig,col:integer;CharSep:AnsiString;var pu:typeUO):boolean;pascal;

procedure proTrealArray_ImprimerTableau(lig1,lig2,col1,col2:integer;var pu:typeUO);pascal;

function fonctionTrealArray_NbColTableau(var pu:typeUO):integer;pascal;

function fonctionTrealArray_NbLigneTableau(var pu:typeUO):integer;pascal;

procedure proTrealArray_FillTableau(lig1,lig2,col1,col2:integer;
                                     x:float;var pu:typeUO);pascal;

procedure proTrealArray_SSclear(var pu:typeUO);pascal;
procedure proTrealArray_SSrefresh(var pu:typeUO);pascal;

procedure proTrealArray_SSindex(col,m:integer;var pu:typeUO);pascal;
function fonctionTrealArray_SSindex(col:integer;var pu:typeUO):integer;pascal;

procedure proTrealArray_StringToLine(st:AnsiString;line:integer;var pu:typeUO);pascal;

implementation

var
  E_RealArrayIndex:integer;
  E_affectation:integer;
  E_ssLoad:integer;
  E_colCount:integer;
  E_lineCount:integer;
  E_numCol:integer;
  E_numLig:integer;
  E_realArrayCreate:integer;


class function TrealArray.STMClassName:AnsiString;
begin
  STMClassName:='RealArray';
end;

procedure TrealArray.initVecs;
var
  i:integer;
begin
  for i:=1 to nbcol do
    with Vcol[i] do
    begin
      notPublished:=true;
      Fchild:=true;

      {Warning: InitTemp1 modifie les flags }
      initList(G_extended);
      with flags do
      begin
        FmaxIndex:=true;
        Findex:=false;
        Ftype:=false;
      end;
      ImaxAutorise:=nblig;

      ident:=self.ident+'.tn'+Istr(i);
      inf.readOnly:=false;
    end;
end;

procedure TrealArray.initTemp(nbc,nbl:integer);
var
  i:integer;

begin
  {supprimer les vecteurs en surplus }
  for i:= nbcol downto nbc+1 do
    begin
      Vcol[i].free;
      Vcol[i]:=nil;
    end;


  {créer les vecteurs manquants }
  for i:=nbcol+1 to nbc do
    begin
      Vcol[i]:=Tvector.create;
      with Vcol[i] do
      begin
        inittemp1(1,1,G_extended);

        title:='T'+Istr(i);
      end;
    end;




  nbCol:=nbc;
  nbLig:=nbl;

  initVecs;

  ClearChildList;
  for i:=1 to nbcol do AddToChildList(Vcol[i]);

end;

constructor TrealArray.create;
var
  i:integer;
begin
  inherited;
  fillchar(decimale,sizeof(decimale),3);

  immediat:=true;
end;


destructor TrealArray.destroy;
var
  i:integer;
begin
  for i:=1 to nbCol do Vcol[i].free;

  inherited destroy;
end;

procedure TrealArray.createForm;
begin
  form:=TarrayEditor.create(formStm);
  with TarrayEditor(form) do
  begin
    installe(1,1,nbcol,nblig);
    caption:=ident;
    showD:=Dshow;
    propertiesD:=Dproperties;

    getTabValue:=getValue;
    setTabValue:=setValue;

    setColName:=DsetColName;
    getColName:=DgetColName;

    getDeciValue:=self.getDeci;
    setDeciValue:=self.setDeci;


    clearData:=self.clear;
    DragVector:=DDragVector;

    invalidateCellD:=DinvalidateCell;
    invalidateVectorD:=DinvalidateVector;
    invalidateAllD:=DinvalidateAll;

    FImmediate:=@Immediat;

    adjustFormSize;
  end;
end;


function TrealArray.initialise(st:AnsiString):boolean;
var
  col,lig,i:integer;
begin
  inherited initialise(st);

  if initRealArray.execution('New array: '+st,col,lig) then
    begin
      initTemp(col,lig);
      initialise:=true;
    end
  else initialise:=false;
end;

procedure TrealArray.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  with conf do
  begin
    setvarConf('nblig',nblig,sizeof(nblig));
    setvarConf('nbcol',nbcol,sizeof(nbcol));
  end;
end;


procedure TrealArray.completeSaveInfo;
begin
end;



procedure TrealArray.Dshow(num:integer);
var
  p:Tvector;
begin
  p:=Vcol[num];
  if assigned(p) then p.show(nil);
end;

procedure TrealArray.modify(nbc,nbl:integer);
var
  i:integer;
  vis:boolean;
begin
  vis:= assigned(form) and form.visible;
  if vis then form.close;

  initTemp(nbc,nbl);                   {Modifier les vecteurs }
  if assigned(form) then TarrayEditor(form).modifyData(1,1,nbc,nbl);

  if vis then form.show;
end;


procedure TrealArray.Dproperties;
var
  nbc,nbl:integer;
begin
  nbc:=nbcol;
  nbl:=nblig;
  if initRealArray.execution(ident+' properties',nbC,nbl)
    then modify(nbc,nbl);
end;

procedure TrealArray.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);
  for i:=1 to nbcol do Vcol[i].saveToStream(f,Fdata);
end;

function TrealArray.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  ok,ok1:boolean;
  posIni:LongWord;
  p:typeUO;
  x,code,i:integer;
  st1:AnsiString;
  dum,oldNbcol:integer;
begin
  oldNbcol:=nbcol;

  ok:=inherited loadFromStream(f,size,Fdata);
  result:=ok;
  if ok then
    begin

      dum:=nbcol;
      nbCol:=oldnbCol;
      initTemp(dum,nblig);
      recupForm;
      if assigned(form) then
        begin
          form.caption:=ident;
        end;
    end
  else exit;

  i:=1;
  ok1:=true;
  while (i<=nbcol) and ok1 do
  begin
    posIni:=f.position;
    st1:=readHeader(f,size);

    ok:=(st1=Tvector.stmClassName) and
         (Vcol[i].LoadFromStream(f,size,Fdata));

    if not ok then
      begin
         f.Position:=Posini;
         ok1:=false;
       end;
    inc(i);
  end;

  initVecs;

  result:=true;
end;


procedure TrealArray.setValue(i,j:integer;x:float);
begin
  error:=false;
  if (i>=1) and (i<=nbcol) and (j>=1) and (j<=nblig) then
    with Vcol[i] do
    begin
      Yvalue[j]:=x;
    end
  else error:=true;
end;

function TrealArray.getValue(i,j:integer):float;
begin
  error:=false;
  if (i>=1) and (i<=nbcol) and (j>=1) and (j<=nblig)
    then getValue:=vCol[i].Yvalue[j]
    else error:=true;
end;


procedure TrealArray.fill1(i1,i2,j1,j2:integer;x:float);
var
  i:integer;
begin
  for i:=i1 to i2 do Vcol[i].fill1(x,j1,j2);
end;

procedure TrealArray.clear;
var
  i:integer;
begin
  for i:=1 to nbcol do Vcol[i].resetList;
end;


procedure TrealArray.DsetColName (i:integer;st:AnsiString);
begin
  Vcol[i].title:=st;
end;

function TrealArray.DgetColName (i:integer):AnsiString;
begin
  result:=Vcol[i].title;
end;

function TrealArray.DdragVector(col:integer):boolean;
begin
  result:=(col>=1) and (col<=nbcol) and assigned(Vcol[col]);
  if result then
  begin
    DragUOsource:=Vcol[col];
    DraggedUO:=Vcol[col];
  end;
end;

procedure TrealArray.DinvalidateCell(col,row:integer);
begin
  Vcol[col].invalidate;
end;

procedure TrealArray.DinvalidateVector(col:integer);
begin
  Vcol[col].invalidate;
end;

procedure TrealArray.DinvalidateAll;
var
  i:integer;
begin
  for i:=1 to nbcol do
    if assigned(Vcol[i]) then Vcol[i].invalidate;
end;



procedure TrealArray.Dprint;
begin

end;

function TrealArray.getDeci(i: integer): integer;
begin
  result:=decimale[i];
end;

procedure TrealArray.setDeci(i, w: integer);
begin
  decimale[i]:=w;
end;


{***************************** Méthodes stm  ******************************** }

procedure proTrealArray_create(name:AnsiString;col,lig:longint;var pu:typeUO);
begin
  controleParam(col,1,256,E_realArrayCreate);
  controleParam(lig,1,1000000,E_realArrayCreate);

  createPgObject(name,pu,TrealArray);

  TrealArray(pu).initTemp(col,lig);
end;

procedure proTrealArray_create_1(col,lig:longint;var pu:typeUO);
begin
  proTrealArray_create('',col,lig, pu);
end;

procedure proTrealArray_modify(nbc,nbl:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if (nbc<1) or (nbc>256) then sortieErreur(E_ColCount);
    if (nbl<1) or (nbl>maxEntierLong) then sortieErreur(E_LineCount);

    modify(nbc,nbl);
  end;
end;

procedure proTrealArray_show(var pu:typeUO);
begin
  verifierObjet(pu);
  TrealArray(pu).show(nil);
end;


procedure proTrealArray_t(i,j:integer;x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    value[i,j]:=x;
    if error then sortieErreur(E_RealArrayIndex);
  end;
end;

function fonctionTrealArray_t(i,j:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    fonctionTrealArray_t:=value[i,j];
    if error then sortieErreur(E_RealArrayIndex);
  end;
end;

procedure proTrealArray_t1(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(1,i,x,pu);
end;

function fonctionTrealArray_t1(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t1:=fonctionTrealArray_t(1,i,pu);
end;

procedure proTrealArray_t2(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(2,i,x,pu);
end;

function fonctionTrealArray_t2(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t2:=fonctionTrealArray_t(2,i,pu);
end;

procedure proTrealArray_t3(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(3,i,x,pu);
end;

function fonctionTrealArray_t3(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t3:=fonctionTrealArray_t(3,i,pu);
end;

procedure proTrealArray_t4(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(4,i,x,pu);
end;

function fonctionTrealArray_t4(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t4:=fonctionTrealArray_t(4,i,pu);
end;

procedure proTrealArray_t5(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(5,i,x,pu);
end;

function fonctionTrealArray_t5(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t5:=fonctionTrealArray_t(5,i,pu);
end;

procedure proTrealArray_t6(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(6,i,x,pu);
end;

function fonctionTrealArray_t6(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t6:=fonctionTrealArray_t(6,i,pu);
end;

procedure proTrealArray_t7(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(7,i,x,pu);
end;

function fonctionTrealArray_t7(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t7:=fonctionTrealArray_t(7,i,pu);
end;

procedure proTrealArray_t8(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(8,i,x,pu);
end;

function fonctionTrealArray_t8(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t8:=fonctionTrealArray_t(8,i,pu);
end;

procedure proTrealArray_t9(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(9,i,x,pu);
end;

function fonctionTrealArray_t9(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t9:=fonctionTrealArray_t(9,i,pu);
end;

procedure proTrealArray_t10(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(10,i,x,pu);
end;

function fonctionTrealArray_t10(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t10:=fonctionTrealArray_t(10,i,pu);
end;

procedure proTrealArray_t11(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(11,i,x,pu);
end;

function fonctionTrealArray_t11(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t11:=fonctionTrealArray_t(11,i,pu);
end;

procedure proTrealArray_t12(i:integer;x:float;var pu:typeUO);
begin
  proTrealArray_t(12,i,x,pu);
end;

function fonctionTrealArray_t12(i:integer;var pu:typeUO):float;
begin
  fonctionTrealArray_t12:=fonctionTrealArray_t(12,i,pu);
end;


function fonctionTrealArray_tN(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    result:=pointer(Vcol[i]);
    if result=nil then sortieErreur(E_realArrayIndex);
    {with Vcol[i] do
      if not assigned(form) then createForm;}
    result:=@Vcol[i].myAd;
  end;
end;

function fonctionTrealArray_tN1(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN1:=fonctionTrealArray_tN(1,pu);
end;

function fonctionTrealArray_tN2(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN2:=fonctionTrealArray_tN(2,pu);
end;

function fonctionTrealArray_tN3(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN3:=fonctionTrealArray_tN(3,pu);
end;

function fonctionTrealArray_tN4(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN4:=fonctionTrealArray_tN(4,pu);
end;

function fonctionTrealArray_tN5(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN5:=fonctionTrealArray_tN(5,pu);
end;

function fonctionTrealArray_tN6(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN6:=fonctionTrealArray_tN(6,pu);
end;

function fonctionTrealArray_tN7(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN7:=fonctionTrealArray_tN(7,pu);
end;

function fonctionTrealArray_tN8(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN8:=fonctionTrealArray_tN(8,pu);
end;

function fonctionTrealArray_tN9(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN9:=fonctionTrealArray_tN(9,pu);
end;

function fonctionTrealArray_tN10(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN10:=fonctionTrealArray_tN(10,pu);
end;

function fonctionTrealArray_tN11(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN11:=fonctionTrealArray_tN(11,pu);
end;

function fonctionTrealArray_tN12(var pu:typeUO):pointer;
begin
  fonctionTrealArray_tN12:=fonctionTrealArray_tN(12,pu);
end;


procedure proTrealArray_NomTab(num:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if not assigned(form) then createForm;
    with TarrayEditor(form) do
      if (num>=1) and (num<=nbcol) then setNomcol(num,st)
      else sortieErreur(E_realArrayIndex);
  end;
end;

procedure proTrealArray_columnName(i:integer;st:AnsiString;var pu:typeUO);
begin
  proTrealArray_NomTab(i,st,pu);
end;

function fonctionTrealArray_columnName(i:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if not assigned(form) then createForm;
    with TarrayEditor(form) do
      if (i>=1) and (i<=nbcol)
        then fonctionTrealArray_columnName:=nomcol[i]
        else sortieErreur(E_realArrayIndex);
  end;
end;

procedure proTrealArray_SauverTableau(st:AnsiString;lig1,lig2,col1,col2:integer;
                        sauverNom:boolean;charsep:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if not assigned(form) then createForm;
    with TarrayEditor(form) do
    begin
      Xproposer(lig1,lig2,col1,col2);
      if charsep='' then charsep:=' ';
      Xsauver(st,sauverNom,charSep[1]);
    end;
  end;
end;

function fonctionTrealArray_ChargerTableau(st:AnsiString;ChargerNom:boolean;
                         lig1,col1:integer;
                         var lig,col:integer;CharSep:AnsiString;var pu:typeUO):boolean;
var
  stc:setChar;
  i:integer;
begin
  stc:=[];
  for i:=1 to length(charSep) do stc:=stc+[charsep[i]];
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if not assigned(form) then createForm;
    with TarrayEditor(form) do
    begin
      if not Xcharger(st,ChargerNom,lig1,col1,lig,col,stc)
        then sortieErreur(E_SSload);
    end;
  end;
  fonctionTrealArray_ChargerTableau:=true;
end;

procedure proTrealArray_ImprimerTableau(lig1,lig2,col1,col2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if not assigned(form) then createForm;
    with TarrayEditor(form) do
    begin
    end;
  end;
end;

function fonctionTrealArray_NbColTableau(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    fonctionTrealArray_NbColTableau:=nbcol;
  end;
end;

function fonctionTrealArray_NbLigneTableau(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    fonctionTrealArray_NbLigneTableau:=nblig;
  end;
end;

procedure proTrealArray_FillTableau(lig1,lig2,col1,col2:integer;
                                     x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    fill1(col1,col2,lig1,lig2,x);
  end;
end;

procedure proTrealArray_SSrefresh(var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    if assigned(form) then TarrayEditor(form).refresh;
  end;
end;

procedure proTrealArray_SSclear(var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with TrealArray(pu) do clear;
end;

procedure proTrealArray_SSindex(col,m:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    controleParam(col,1,nbcol,E_numCol);
    controleParam(m,1,nblig,E_numLig);
    Vcol[col].modifyLimits(1,m);
  end;
end;

function fonctionTrealArray_SSindex(col:integer;var pu:typeUO):integer;pascal;
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    controleParam(col,1,nbcol,E_numCol);
    result:=Vcol[col].Iend;
  end;
end;

procedure proTrealArray_StringToLine(st:AnsiString;line:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrealArray(pu) do
  begin
    controleParam(line,1,nblig,E_numLig);

    if not assigned(form) then createForm;
    with TarrayEditor(form) do
    stringToLine(st,line);
  end;
end;



Initialization
AffDebug('Initialization RArray1',0);
  installError(E_RealArrayIndex,'RealArray: index out of range');
  installError(E_affectation,'RealArray: cannot modify this object');
  installError(E_ssLoad,'RealArray: unable to load file');
  installError(E_colCount,'RealArray: invalid column count');
  installError(E_lineCount,'RealArray: invalid line count');

  installError(E_NumCol,'RealArray: Column number out of range');
  installError(E_NumLig,'RealArray: Line number out of range');

  installError(E_realArrayCreate,'TRealArray.create: invalid parameter');

  
  registerObject(TrealArray,data);

end.
