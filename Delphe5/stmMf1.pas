unit StmMf1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,
     classes,graphics,forms,controls,menus,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,Dtrace1,Darbre0,tbE0,
     Dcur2fit,
     Dpalette,Ncdef2,formMenu,
     editcont,cood0,

     stmDef,stmObj,defForm,
     visu0,
     varconf1,stmDobj1,
     stmMat1,
     debug0,
     stmError,stmPg,symbAc3;
     


var
  E_stTxt:integer;
  E_nbpt:integer;
  E_index:integer;
  E_paramName:integer;
  E_model:integer;
  E_rangeArg:integer;
  E_pgFunc:integer;

type
  TMatFunction=
            class(Tmatrix)

               protected
                  procedure setDx(x:double);  override;
                  procedure setX0(x:double);  override;
                  procedure setDy(x:double);  override;
                  procedure setY0(x:double);  override;

               public
                  StTxt:AnsiString;
                  NumModel:integer;

                  NomVar:tabNom;
                  Valeur:tabVal;
                  nbvar:integer;
                  numvar:array[1..2] of integer;
                  U0:ptElem;

                  x1f,x2f,y1f,y2f:float;
                  i1f,i2f,j1f,j2f:integer;

                  PgFunc:Tpg2Event;
                  FpgFunc:boolean;

                  constructor create;override;
                  destructor destroy;override;
                  class function STMClassName:AnsiString;override;

                  procedure initDataTemp;override;
                  function initialise(st:AnsiString):boolean;override;

                  function compiler(var lig,col:integer):boolean;
                  function compiler1(var lig,col:integer):boolean;

                  function evaluate:float;
                  procedure DisplayNow;

                  function getRvalue(x,y:float):float;override;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                    override;

                  procedure completeLoadInfo;override;

                  procedure createForm;override;
                  procedure proprietes(sender:Tobject);override;
                  function indexof(st:AnsiString):integer;

                  procedure setGraphParam(x1,x2,y1,y2:float;i1,i2,j1,j2:integer);
                  function setPgFunc(p:integer):boolean;
                end;


{***************** Déclarations STM pour TmatFunction *****************************}

procedure proTMatfunction_create(name:AnsiString;st:AnsiString;var pu:typeUO);pascal;
procedure proTMatfunction_create_1(st:AnsiString;var pu:typeUO);pascal;
procedure proTmatFunction_create1(name:AnsiString;ad:integer;var pu:typeUO);pascal;
procedure proTmatFunction_create1_1(ad:integer;var pu:typeUO);pascal;


procedure proTmatFunction_Text(st:AnsiString;var pu:typeUO);pascal;
function fonctionTmatFunction_Text(var pu:typeUO):AnsiString;pascal;

procedure proTmatFunction_Argument(n:integer;st:AnsiString;var pu:typeUO);pascal;
function fonctionTmatFunction_Argument(n:integer;var pu:typeUO):AnsiString;pascal;

procedure proTmatFunction_Param(st:AnsiString;x:float;var pu:typeUO);pascal;
function fonctionTmatFunction_Param(st:AnsiString;var pu:typeUO):float;pascal;

function fonctionTmatFunction_indexof(st:AnsiString;var pu:typeUO):smallint;pascal;

function fonctionTmatFunction_paramCount(var pu:typeUO):smallint;pascal;

procedure proTmatFunction_setGraphParam(x1,x2,y1,y2:float;
                                  i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTmatFunction_matchMatrix(var m:Tmatrix;var pu:typeUO);pascal;

procedure proTmatFunction_StandardModel(n:smallint;var pu:typeUO);pascal;
function fonctionTmatFunction_StandardModel(var pu:typeUO):smallint;pascal;

procedure proTmatFunction_PgFunction(p:integer;var pu:typeUO);pascal;
function fonctionTmatFunction_PgFunction(var pu:typeUO):integer;pascal;


IMPLEMENTATION

uses MFprop;
{****************** Méthodes de TmatFunction ******************}


constructor TmatFunction.create;
begin
   inherited create;

   inf.tpNum:=g_extended;

   numvar[1]:=1;
   numvar[2]:=2;
   x1f:=0;
   x2f:=100;
   y1f:=0;
   y2f:=100;

   i1f:=0;
   i2f:=99;
   j1f:=0;
   j2f:=99;

   data:=TdataFoncEE.create(getRvalue,i1f,i2f,j1f,j2f,x1f,x2f,y1f,y2f);
end;

class function TmatFunction.STMClassName:AnsiString;
begin
  STMClassName:='MatFunction';
end;

procedure TmatFunction.initDataTemp;
begin

end;

function TmatFunction.initialise(st:AnsiString):boolean;
begin
  ident:=st;            {comme on hérite de Tvector et que Tvector.initialise}
                        {ne convient pas, on réécrit tout}
  initialise:=true;
end;

destructor TmatFunction.destroy;
begin
  inherited destroy;
  detruireArbre(U0);
end;

function TmatFunction.compiler(var lig,col:integer):boolean;
var
  error:integer;
  list:TstringList;
  st:AnsiString;
  i:integer;
begin
  TdataFoncEE(data).create(getRvalue,i1f,i2f,j1f,j2f,x1f,x2f,y1f,y2f);

  compiler:=false;
  stTxt:=Fmaj(stTxt);

  list:=TstringList.create;
  list.add('X=X');
  list.add('Y=Y');

  st:='';
  for i:=1 to length(stTxt) do
    begin
      if (stTxt[i]=#10) or (stTxt[i]=#13) then
        begin
          if st<>'' then list.add(st);
          st:='';
        end
      else st:=st+stTxt[i];
    end;
  if st<>'' then list.add(st);


  detruireArbre(U0);

  {pc:=1;
  verifierExpression(stTxt,pc,Error);}
  verifierListe(list,lig,col,error);
  if error<>0 then
    begin
      list.free;
      exit;
    end;


  nbvar:=0;
  numvar[1]:=1;
  numvar[2]:=2;
  {fillchar(valeur,sizeof(valeur),0);}

  {pc:=1;
  creerArbre(U0,stTxt,pc,nomVar,nbVar);}
  CreerArbreListe(U0,List,nomVar,nbvar);
  list.free;

  compiler:=true;
end;

function TmatFunction.compiler1(var lig,col:integer):boolean;
begin
  setGraphParam(x1f,x2f,y1f,y2f,i1f,i2f,j1f,j2f);

  result:=compiler(lig,col);
  invalidate;
end;

function TmatFunction.evaluate:float;
begin
  result:=getRvalue(valeur[numvar[1]],valeur[numvar[2]]);
end;

procedure TmatFunction.DisplayNow;
begin
  TdataFoncEE(data).create(getRvalue,i1f,i2f,j1f,j2f,x1f,x2f,y1f,y2f);
  invalidate;
end;


function TmatFunction.getRvalue(x,y:float):float;
var
  i:integer;
begin
  TRY
  if FpgFunc then
    with PgFunc do
    begin
      if valid then
        begin
          valeur[numvar[1]]:=x;
          valeur[numvar[2]]:=y;

          result:=pg.executerRfunc(ad,@valeur,nbvar);
        end
      else result:=0;
    end
  else
  if assigned(U0) then
    begin
      valeur[numvar[1]]:=x;
      valeur[numvar[2]]:=y;

      getRvalue:=evaluer(U0,valeur);
    end
  else getRvalue:=0;
  EXCEPT
  result:=0;
  END;
end;



procedure TmatFunction.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin

  inherited;

  conf.setStringConf('StTxt',stTxt);

  conf.setvarConf('VAL',valeur,sizeof(valeur));
  conf.setvarConf('NOM',NomVar,sizeof(nomvar));
  conf.setvarConf('NumVar',NumVar,sizeof(numvar));

  conf.setvarConf('X1f',x1f,sizeof(x1f));
  conf.setvarConf('X2f',x2f,sizeof(x2f));
  conf.setvarConf('I1f',i1f,sizeof(i1f));
  conf.setvarConf('I2f',i2f,sizeof(i2f));

  conf.setvarConf('Y1f',y1f,sizeof(y1f));
  conf.setvarConf('Y2f',y2f,sizeof(y2f));
  conf.setvarConf('J1f',j1f,sizeof(j1f));
  conf.setvarConf('J2f',j2f,sizeof(j2f));

  conf.setvarConf('NumMod',numModel,sizeof(numModel));

end;

procedure TmatFunction.completeLoadInfo;
var
  lig,col:integer;
begin
  inherited;

  inf.tpNum:=G_extended;
  setGraphParam(x1f,x2f,y1f,y2f,i1f,i2f,j1f,j2f);
  compiler(lig,col);
  invalidate;
end;

procedure TmatFunction.proprietes(sender:Tobject);
begin
  MFuncProp.caption:=ident+' properties';

  MFuncProp.execution(self);

  setGraphParam(x1f,x2f,y1f,y2f,i1f,i2f,j1f,j2f);
end;

procedure TmatFunction.createForm;
begin
  inherited createForm;

end;

procedure TmatFunction.setDx(x:double);
begin
end;

procedure TmatFunction.setx0(x:double);
begin
end;

procedure TmatFunction.setDy(x:double);
begin
end;

procedure TmatFunction.setY0(x:double);
begin
end;

function TmatFunction.indexof(st:AnsiString):integer;
var
  i:integer;
begin
  st:=Fmaj(st);
  for i:=1 to nbvar do
    if nomvar[i]=st then
      begin
        indexof:=i;
        exit;
      end;
  indexof:=0;
end;

procedure TmatFunction.setGraphParam(x1,x2,y1,y2:float;i1,i2,j1,j2:integer);
begin
  if (i2<=i1+1) then exit;
  if (j2<=j1+1) then exit;

  x1f:=x1;
  x2f:=x2;
  y1f:=y1;
  y2f:=y2;

  i1f:=i1;
  i2f:=i2;
  j1f:=j1;
  j2f:=j2;

  inf.Imin:=i1;
  inf.Imax:=i2;
  inf.Jmin:=j1;
  inf.Jmax:=j2;

  inf.Dxu:=(X2f-X1f)/(I2f-I1f);
  inf.X0u:=X1f-I1f*Dxu;
  inf.Dyu:=(Y2f-Y1f)/(J2f-J1f);
  inf.Y0u:=Y1f-J1f*Dyu;

  nbcol:=i2-i1+1;
  nblig:=j2-j1+1;

  TdataFoncEE(data).create(getRvalue,i1f,i2f,j1f,j2f,x1f,x2f,y1f,y2f);
end;

function TMatFunction.setPgFunc(p: integer): boolean;
var
  Pdef:PdefSymbole;
  i:integer;
  st:AnsiString;
begin
  result:=false;
  Pdef:=activeMacro.getProcInfo(p,st);
  if assigned(Pdef) then
  with Pdef^ do
  begin
    result:=(infP.nbParam>2) and (infP.result1=nbExtended);
    for i:=1 to infP.nbParam do
      result:=result and (infP.parametre[i].tp=nbExtended);
  end;

  if result then
  begin
    pgFunc.setAd(p);
    FpgFunc:=true;
    nbvar:=Pdef^.infP.nbParam;
    numvar[1]:=1;
    numvar[2]:=2;

    {messageCentral(st);}

    for i:=1 to nbvar-1 do
    begin
      nomvar[i]:=copy(st,1,pos('|',st)-1);
      delete(st,1,pos('|',st));
    end;
    nomvar[nbvar]:=st;
  end
  else FpgFunc:=false;
end;


{***************** Méthodes STM pour TmatFunction ********************************}

procedure proTmatFunction_create(name:AnsiString;st:AnsiString;var pu:typeUO);
var
  lig,col:integer;
begin
  createPgObject(name,pu,TmatFunction);
  with TmatFunction(pu) do
  begin
    stTxt:=st;
    if not compiler(lig,col) then sortieErreur(E_stTxt);
  end;
end;

procedure proTmatFunction_create_1(st:AnsiString;var pu:typeUO);
begin
  proTmatFunction_create('',st, pu);
end;

procedure proTmatFunction_create1(name:AnsiString;ad:integer;var pu:typeUO);
begin
  createPgObject(name,pu,TmatFunction);
  with TmatFunction(pu) do
  begin
    if not setPgFunc(ad) then sortieErreur(E_pgFunc);
  end;
end;

procedure proTmatFunction_create1_1(ad:integer;var pu:typeUO);
begin
  proTmatFunction_create1('',ad, pu);
end;

procedure proTmatFunction_Text(st:AnsiString;var pu:typeUO);
var
  lig,col:integer;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    stTxt:=st;
    if not compiler(lig,col) then sortieErreur(E_stTxt);
    numModel:=0;
    FpgFunc:=false;
  end;
end;

function fonctionTmatFunction_Text(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    fonctionTmatFunction_Text:=stTxt;
  end;
end;

procedure proTmatFunction_Argument(n:integer;st:AnsiString;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  controleParam(n,1,2,E_rangeArg);
  with TmatFunction(pu) do
  begin
    i:=indexof(st);
    if i=0 then sortieErreur(E_paramName);
    numvar[n]:=i;
  end;
end;

function fonctionTmatFunction_Argument(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  controleParam(n,1,2,E_rangeArg);
  with TmatFunction(pu) do
  begin
    result:=nomvar[numvar[n]];
  end;
end;

procedure proTmatFunction_Param(st:AnsiString;x:float;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    i:=indexof(st);
    if i=0 then sortieErreur(E_paramName);
    valeur[i]:=x;
  end;
end;

function fonctionTmatFunction_Param(st:AnsiString;var pu:typeUO):float;
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    i:=indexof(st);
    if i=0 then sortieErreur(E_paramName);
    result:=valeur[i];
  end;
end;

function fonctionTmatFunction_indexof(st:AnsiString;var pu:typeUO):smallint;
var
  n:integer;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    n:=indexOf(st);
    {if n=0 then sortieErreur(E_paramName);}
    fonctionTmatFunction_indexOf:=n;
  end;
end;

function fonctionTmatFunction_paramCount(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    fonctionTmatFunction_ParamCount:=nbvar;
  end;
end;

procedure proTmatFunction_setGraphParam(x1,x2,y1,y2:float;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (i2<=i1+1) then sortieErreur(E_nbpt);
  if (j2<=j1+1) then sortieErreur(E_nbpt);

  with TmatFunction(pu) do
  begin
    setGraphParam(x1,x2,y1,y2,i1,i2,j1,j2);
    invalidate;
  end;
end;

procedure proTmatFunction_matchMatrix(var m:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(m));

  with m do proTmatFunction_setGraphParam(m.Xstart,m.Xend,m.Ystart,m.Yend,
                                          m.Istart,m.Iend,m.Jstart,m.Jend,
                                          pu);

  TmatFunction(pu).invalidate;
end;

procedure proTmatFunction_StandardModel(n:smallint;var pu:typeUO);
var
  lig,col:integer;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    if (n<1) or (n>maxModele) then sortieErreur(E_model);
    numModel:=n;
    sttxt:='RES='+modeleFit(n).id;
    numvar[1]:=1;
    numvar[2]:=2;
    compiler(lig,col);
    FpgFunc:=false;
  end;
end;


function fonctionTmatFunction_StandardModel(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TmatFunction(pu) do
  begin
    fonctionTmatFunction_StandardModel:=numModel;
  end;
end;

procedure proTmatFunction_PgFunction(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatFunction(pu).setPgFunc(p);
end;

function fonctionTmatFunction_PgFunction(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmatFunction(pu).PgFunc.ad;
end;



Initialization
AffDebug('Initialization StmMf1',0);

installError(E_stTxt,'TmatFunction: error in expression');
installError(E_nbpt,'TmatFunction: invalid number of points');
installError(E_index,'TmatFunction: invalid index');
installError(E_paramName,'TmatFunction: unknown name parameter');
installError(E_model,'TmatFunction: invalid standard model number');
installError(E_rangeArg,'TmatFunction: Argument number out of range');
installError(E_pgFunc,'TmatFunction: invalid function');

registerObject(TmatFunction,data);

end.
