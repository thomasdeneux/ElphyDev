unit stmfunc1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses Windows,
     classes,graphics,forms,controls,menus,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,Dtrace1,Darbre1,dtf0,
     Dpalette,Ncdef2,
     editcont,cood0,
     tpForm0,

     stmDef,stmObj,defForm,
     getVect0,getMat0,visu0,
     inivect0,
     varconf1,stmDobj1,stmvec1,
     debug0,stmCurs,
     stmError,stmPg,symbac3,
     Dcurfit0;


var
  E_stTxt:integer;
  E_nbpt:integer;
  E_extension:integer;
  E_index:integer;
  E_paramName:integer;
  E_model:integer;
  E_pgFunc:integer;


type
  Tfunction= class(Tvector)
               private
                  function getNbvar: integer;
                  procedure setNbVar(n:integer);

               protected
                  data0:typedataFonc;

                  procedure setDx(x:double);  override;
                  procedure setX0(x:double);  override;
                  procedure setDy(x:double);  override;
                  procedure setY0(x:double);  override;

               public
                  StTxt:AnsiString;
                  NumModel:integer;

                  NomVar:tabNom;
                  Valeur:tabVal;
                  numvar:integer;
                  U0:ptElem;

                  x1f,x2f:float;
                  i1f,i2f:integer;

                  xorg:float;

                  PgFunc:Tpg2Event;
                  FpgFunc:boolean;

                  constructor create;override;
                  destructor destroy;override;
                  class function STMClassName:AnsiString;override;

                  function initialise(st:AnsiString):boolean;override;

                  function compiler(var lig,col:integer):boolean;
                  function evaluate:float;
                  procedure DisplayNow;

                  function getRvalue(x:float):float;override;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                    override;

                  procedure completeLoadInfo;override;

                  procedure createForm;override;
                  procedure proprietes(sender:Tobject);override;
                  function ParamIndex(st:AnsiString):integer;

                  procedure setGraphParam(x1,x2:float;i1,i2:integer);

                  function setPgFunc(p:integer):boolean;

                  property nbvar:integer read getNbVar write setNbVar;
                end;


{***************** Déclarations STM pour Tfunction *****************************}

procedure proTfunction_create(name:AnsiString;st:AnsiString;var pu:typeUO);pascal;
procedure proTfunction_create_1(st:AnsiString;var pu:typeUO);pascal;

procedure proTfunction_create1(name:AnsiString;ad:integer;var pu:typeUO);pascal;
procedure proTfunction_create1_1(ad:integer;var pu:typeUO);pascal;


procedure proTfunction_Text(st:AnsiString;var pu:typeUO);pascal;
function fonctionTfunction_Text(var pu:typeUO):AnsiString;pascal;

procedure proTfunction_Argument(st:AnsiString;var pu:typeUO);pascal;
function fonctionTfunction_Argument(var pu:typeUO):AnsiString;pascal;

procedure proTfunction_Param(st:AnsiString;x:float;var pu:typeUO);pascal;
function fonctionTfunction_Param(st:AnsiString;var pu:typeUO):float;pascal;

function fonctionTfunction_indexof(st:AnsiString;var pu:typeUO):integer;pascal;

function fonctionTfunction_paramCount(var pu:typeUO):integer;pascal;

procedure proTfunction_setGraphParam(x1,x2:float;i1,i2:integer;var pu:typeUO);pascal;
procedure proTfunction_matchVector(var v:Tvector;var pu:typeUO);pascal;

procedure proTfunction_StandardModel(n:integer;var pu:typeUO);pascal;
function fonctionTfunction_StandardModel(var pu:typeUO):integer;pascal;


procedure proTfunction_Xorigin(v:float;var pu:typeUO);pascal;
function fonctionTfunction_Xorigin(var pu:typeUO):float;pascal;

procedure proTfunction_PgFunction(p:integer;var pu:typeUO);pascal;
function fonctionTfunction_PgFunction(var pu:typeUO):integer;pascal;


IMPLEMENTATION

uses funcProp;

{****************** Méthodes de Tfunction ******************}


constructor Tfunction.create;
begin
   inherited create;

   numvar:=1;
   x1f:=0;
   x2f:=100;
   i1f:=0;
   i2f:=999;

   nomvar:=TstringList.create;

   data0:=typeDataFonc.create(getRvalue,x1f,x2f,i1f,i2f);
   initdat1(data0,g_single);
end;

class function Tfunction.STMClassName:AnsiString;
begin
  STMClassName:='Function';
end;

function Tfunction.initialise(st:AnsiString):boolean;
begin
  ident:=st;            {comme on hérite de Tvector et que Tvector.initialise}
                        {ne convient pas, on réécrit tout}
  title:=st;
  initialise:=true;
end;

destructor Tfunction.destroy;
begin
  inherited destroy;
  data0.free;
  detruireArbre(U0);
  nomvar.Free;
end;

function Tfunction.compiler(var lig,col:integer):boolean;
var
  error:integer;
  list:TstringList;
  st:AnsiString;
  i:integer;
begin
  data0.create(getRvalue,x1f,x2f,i1f,i2f);
  initdat1(data0,g_single);

  compiler:=false;
  stTxt:=Fmaj(stTxt);

  list:=TstringList.create;
  list.add('X=X');
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


  nomvar.Clear;  
  numvar:=1;
  {fillchar(valeur,sizeof(valeur),0);}

  {pc:=1;
  creerArbre(U0,stTxt,pc,nomVar,nbVar);}
  CreerArbreListe(U0,List,nomVar);
  list.free;

  compiler:=true;
end;

function Tfunction.evaluate:float;
begin
  result:=getRvalue(valeur[numvar-1]);
end;

procedure Tfunction.DisplayNow;
begin
  data0.create(getRvalue,x1f,x2f,i1f,i2f);
  initdat1(data0,g_single);
  invalidate;
end;


function Tfunction.getRvalue(x:float):float;
var
  i:integer;
begin
  if FpgFunc then
    with PgFunc do
    begin
      if valid then
        begin
          valeur[numvar-1]:=x-xorg;
          result:=pg.executerRfunc(ad,@valeur[0],nbvar);
        end
      else result:=0;
    end
  else
  if assigned(U0) then
    begin
      valeur[numvar-1]:=x-xorg;
      result:=evaluer(U0,valeur);
    end
  else result:=0;
end;


procedure Tfunction.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin

  inherited;

  conf.setStringConf('StTxt',stTxt);

//  conf.setvarConf('VAL',valeur,sizeof(valeur));
//  conf.setvarConf('NOM',NomVar,sizeof(nomvar));
//  conf.setvarConf('NumVar',NumVar,sizeof(numvar));
  conf.setvarConf('X1f',x1f,sizeof(x1f));
  conf.setvarConf('X2f',x2f,sizeof(x2f));
  conf.setvarConf('I1f',i1f,sizeof(i1f));
  conf.setvarConf('I2f',i2f,sizeof(i2f));
  conf.setvarConf('NumMod',numModel,sizeof(numModel));

end;

procedure Tfunction.completeLoadInfo;
var
  lig,col:integer;
begin
  inherited;
  recupForm;
  if assigned(form) then
    begin
      form.caption:=ident;
      form.color:=BKcolor;
    end;
  compiler(lig,col);
  invalidate;
end;

procedure Tfunction.proprietes(sender:Tobject);
begin
  functionProp.caption:=ident+' properties';

  functionProp.execution(self);
end;

procedure Tfunction.createForm;
begin
  inherited createForm;

end;

procedure Tfunction.setDx(x:double);
begin
end;

procedure Tfunction.setx0(x:double);
begin
end;

procedure Tfunction.setDy(x:double);
begin
end;

procedure Tfunction.setY0(x:double);
begin
end;

function Tfunction.ParamIndex(st:AnsiString):integer;
var
  i:integer;
begin
  st:=Fmaj(st);
  for i:=1 to nbvar do
    if nomvar[i-1]=st then
      begin
        ParamIndex:=i;
        exit;
      end;
  ParamIndex:=0;
end;

procedure Tfunction.setGraphParam(x1,x2:float;i1,i2:integer);
begin
  if (i2f<=i1f+1) or (x1=x2) then exit;

  x1f:=x1;
  x2f:=x2;
  i1f:=i1;
  i2f:=i2;

  Dxu:=(X2f-X1f)/(I2f-I1f);
  X0u:=X1f-I1f*Dxu;

  data0.create(getRvalue,x1f,x2f,i1f,i2f);
  initdat1(data0,g_single);
end;

function Tfunction.setPgFunc(p: integer):boolean;
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
    result:=(infP.nbParam>1) and (infP.result=nbExtended);
    for i:=1 to infP.nbParam do
      result:=result and (infP.parametre[i].tp=nbExtended);
  end;

  if result then
  begin
    pgFunc.setAd(p);
    FpgFunc:=true;
    nbvar:=Pdef^.infP.nbParam;
    numvar:=1;

    {messageCentral(st);}

    for i:=1 to nbvar-1 do
    begin
      nomvar[i-1]:=copy(st,1,pos('|',st)-1);
      delete(st,1,pos('|',st));
    end;
    nomvar[nbvar-1]:=st;
  end
  else FpgFunc:=false;
end;


{***************** Méthodes STM pour Tfunction ********************************}

procedure proTfunction_create(name:AnsiString;st:AnsiString;var pu:typeUO);
var
  lig,col:integer;
begin
  createPgObject(name,pu,Tfunction);
  with Tfunction(pu) do
  begin
    stTxt:=st;
    title:=ident;
    if not compiler(lig,col) then sortieErreur(E_stTxt);
    FpgFunc:=false;
  end;
end;

procedure proTfunction_create_1(st:AnsiString;var pu:typeUO);
begin
  proTfunction_create('',st, pu);
end;

procedure proTfunction_create1(name:AnsiString;ad:integer;var pu:typeUO);
begin
  createPgObject(name,pu,Tfunction);
  with Tfunction(pu) do
  begin
    title:=ident;
    if not setPgFunc(ad) then sortieErreur(E_pgFunc);
  end;
end;

procedure proTfunction_create1_1(ad:integer;var pu:typeUO);
begin
  proTfunction_create1('',ad, pu);
end;

procedure proTfunction_Text(st:AnsiString;var pu:typeUO);
var
  lig,col:integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    stTxt:=st;
    if not compiler(lig,col) then sortieErreur(E_stTxt);
    numModel:=0;
    FpgFunc:=false;
  end;
end;

function fonctionTfunction_Text(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    fonctionTfunction_Text:=stTxt;
  end;
end;

procedure proTfunction_Argument(st:AnsiString;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    i:=ParamIndex(st);
    if i=0 then sortieErreur(E_paramName);
    numvar:=i;
  end;
end;

function fonctionTfunction_Argument(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    if (numvar>=1) and (numvar<=nbvar)
      then result:=nomvar[numvar-1]
      else result:='';
  end;
end;

procedure proTfunction_Param(st:AnsiString;x:float;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    i:=ParamIndex(st);
    if i=0 then sortieErreur(E_paramName);
    valeur[i-1]:=x;
    ModifiedData:=true;
  end;
end;

function fonctionTfunction_Param(st:AnsiString;var pu:typeUO):float;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    i:=ParamIndex(st);
    if i=0 then sortieErreur(E_paramName);
    result:=valeur[i-1];
  end;
end;

function fonctionTfunction_indexof(st:AnsiString;var pu:typeUO):integer;
var
  n:integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    n:=ParamIndex(st);
    {if n=0 then sortieErreur(E_paramName);}
    fonctionTfunction_indexOf:=n;
  end;
end;

function fonctionTfunction_paramCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    fonctionTfunction_ParamCount:=nbvar;
  end;
end;

procedure proTfunction_setGraphParam(x1,x2:float;i1,i2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (i2<=i1+1) then sortieErreur(E_nbpt);
  if x1=x2 then sortieErreur(E_extension);

  with Tfunction(pu) do
  begin
    setGraphParam(x1,x2,i1,i2);
    invalidateData;
  end;
end;

procedure proTfunction_matchVector(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  proTfunction_setGraphParam(v.Xstart,v.Xend,v.Istart,v.Iend,pu);
end;

procedure proTfunction_StandardModel(n:integer;var pu:typeUO);
var
  lig,col:integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    if (n<1) or (n>maxModele) then sortieErreur(E_model);
    numModel:=n;
    sttxt:='RES='+modeleFit(n)^.id;
    numvar:=1;
    compiler(lig,col);
    FpgFunc:=false;
  end;
end;


function fonctionTfunction_StandardModel(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    fonctionTfunction_StandardModel:=numModel;
  end;
end;


procedure proTfunction_Xorigin(v:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    XOrg:=v;
  end;
end;

function fonctionTfunction_Xorigin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfunction(pu) do
  begin
    fonctionTfunction_Xorigin:=XOrg;
  end;
end;

procedure proTfunction_PgFunction(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tfunction(pu).setPgFunc(p);
end;

function fonctionTfunction_PgFunction(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tfunction(pu).PgFunc.ad;
end;



function Tfunction.getNbvar: integer;
begin
  result:= nomvar.Count;
end;

procedure Tfunction.setNbVar(n: integer);
var
  i:integer;
  oldN:integer;
begin
  oldN:=nomvar.Count;
  for i:= oldN+1 to n do nomvar.add('');
  for i:= oldN-1 downto n do nomvar.Delete(i);

  setlength(valeur,n);
  if n>oldN then fillchar(valeur[oldN],(n-oldN)*sizeof(float),0);
end;

Initialization
AffDebug('Initialization stmFunc1',0);

installError(E_stTxt,'Tfunction: error in expression');
installError(E_nbpt,'Tfunction: invalid number of points');
installError(E_extension,'Tfunction.setGraphParam: Xstart cannot be equal to Xend');
installError(E_index,'Tfunction: invalid index');
installError(E_paramName,'Tfunction: unknown name parameter');
installError(E_model,'Tfunction: invalid standard model number');
installError(E_pgFunc,'Tfunction: invalid function');

registerObject(Tfunction,data);

end.
