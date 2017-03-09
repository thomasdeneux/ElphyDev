unit stmOpti1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,menus,forms,
     util1,Gdos,Dgraphic,Dtrace1, debug0,chrono0,
     Ncdef2,varconf1,
     stmDef,stmObj,stmVec1,stmMat1,stmPopup,
     stmError,stmPg,
     stmKLmat, stmMatU1, Models1,
     IPPS,IPPSovr,IPPdefs, mathKernel0,
     stmChk0,chkPstw1,
     VlistA1;

type
  Toptimizer=
    class(typeUO)
      Eval:TvectorEval;
      FileName:AnsiString;

      cntmax:integer;
      seuil:float;

      para:Tvector;        {vecteur colonne contenant les paramètres P valeurs, commence à 1}
      paraMin,paraMax:Tvector;
      paraDum:Tvector;
      Jmat:Tmat;           {Le jacobien  M lignes P colonnes}

      Vclamp:array of boolean;

      ChiSq1:double;
      IDatStart,IdatEnd:array of integer;

      IstartVec,IendVec:integer; {permet de vérifier que tous les vecteurs entrés on les mêmes bornes }

      U0:ptExp;
      U1:array of ptElem;
      ydat:Tvector;
      yfit:Tvector;

      Bmat:Tmat;           {La hessienne en quasi-Newton }
      JmatOld:Tmat;
      NormG:float;

      paraHis:TVlist;
      modHis:integer;

      decimale:array[0..4] of byte;
      Editform:Tform;
      ParaNames:TstringList;

      initOpti:boolean;
      FinDemandee:boolean;


      constructor create;override;
      destructor destroy;override;

      procedure ClearDerivatives;

      class function STMClassName:AnsiString;override;
      procedure setChildNames;override;
      procedure BuildChildList;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;

      function loadFromFile(st:AnsiString):boolean;
      function loadFromText(st:AnsiString):boolean;

      function compile:boolean;
      procedure CalculateOutPut(stName:AnsiString);
      procedure reset;
      function setVector(stName:AnsiString;vec:Tvector): boolean;
      procedure getVector(stName:AnsiString;vec:Tvector);
      procedure setSeg(Vseg:Tvector);
      function setClamp(clamp:Tvector):boolean;
      procedure setParams(vec:Tvector);
      procedure getParams(vec:Tvector);

      function initOpt(stOut:AnsiString;VecOut:Tvector):boolean;
      procedure Optimize;
      function chi2:float;
      procedure setNbpt(nbpt1:integer);

      procedure getYfit(pp:Tvector);
      procedure getJacobian(pp:Tvector);

      procedure initBmat;


      procedure controleVar(dd:Tvector);
      function Chi2opt(vec:Tmat):double;
      procedure executeOpt;

      procedure LMstep;
      procedure QNstep;


      function nbpt:integer;
      function nbpara:integer;
      function nbparaNC:integer;

      procedure evaluer(U:ptElem;para1,matRes:Tvector);
      procedure evaluerExp(U:ptExp;para1,matRes:Tvector);
      procedure saveTree(rac:ptElem);
      procedure saveTrees;

      function getChi2(stOut:AnsiString; Vdat: Tvector): double;

      procedure setFilterParam(name:AnsiString;w:float);
      procedure setFilterParams(name:AnsiString;vec:Tvector);
      function getFilterParam(name:AnsiString):float;
      procedure getFilterParams(name:AnsiString;vec:Tvector);

      procedure setBounds(vecMin,vecMax:Tvector);
      procedure getBounds(vecMin,vecMax:Tvector);

      procedure setFilterBounds(name:AnsiString; Vmin,Vmax: float);overload;
      procedure setFilterBounds(name:AnsiString;vecMin,vecMax:Tvector);overload;

      procedure getFilterBounds(name:AnsiString;vecMin,vecMax:Tvector);

      procedure setFilterConsts(name:AnsiString;vecCte:Tvector);

      function setFilterClamp(name:AnsiString;clamp:Tvector):boolean;overload;
      function setFilterClamp(name:AnsiString;clamp:float;num:integer):boolean;overload;

      procedure ParaToNC(vec,vecNC:Tvector);
      procedure NCtoPara(vecNC,vec:Tvector);

      procedure updateBmat(oldPara,newPara:Tvector;diff:Tmat);
      function getNormG(diff:Tmat):double;

      procedure TestGrad(paraNC:Tvector);

      procedure ChkManu2(N:integer;h1,h2:Tvector;K11,K12,K21,K22:Tmatrix;stX1,stX2,stY:AnsiString);
      function getPopUp:TpopupMenu;override;

      procedure Show(sender:Tobject);override;
      procedure UpdateEditForm;
      procedure CalculateOutputs(sender:Tobject);

      procedure BuildParaNames;
      procedure setParaLengths(n:integer);
      procedure invalidateVectors;

      procedure getFilterAux(name:AnsiString;numVec,NumOcc:integer;vec:Tvector);
      procedure setHistoryList(var vec:TVlist);
    end;



procedure proToptimizer_create(name:AnsiString;var pu:typeUO);pascal;
procedure proToptimizer_create_1(var pu:typeUO);pascal;

procedure proToptimizer_loadFromFile(st:AnsiString;var pu:typeUO);pascal;
procedure proToptimizer_loadFromText(st:AnsiString;var pu:typeUO);pascal;


function fonctionToptimizer_compile(var pu:typeUO):boolean;pascal;
procedure proToptimizer_CalculateOutput(stName:AnsiString;var pu:typeUO);pascal;
procedure proToptimizer_reset(var pu:typeUO);pascal;
procedure proToptimizer_setVector(stName:AnsiString;var vec:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_getVector(stName:AnsiString;var vec:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_setSeg(var Vseg:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_setClamp(var clamp:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_setParams(var vec:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_getParams(var vec:Tvector;var pu:typeUO);pascal;

procedure proToptimizer_initOpti(stOut:AnsiString;var vecOut:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_Optimize(var pu:typeUO);pascal;

function fonctionToptimizer_chi2(var pu:typeUO):float;pascal;
function fonctionToptimizer_getchi2(stName:AnsiString;var Vec:Tvector;var pu:typeUO):float;pascal;

procedure proToptimizer_maxIt(n:integer;var pu:typeUO);pascal;
function fonctionToptimizer_maxIt(var pu:typeUO):integer;pascal;

procedure proToptimizer_setFilterParam(name:AnsiString;w:float;var pu:typeUO);pascal;
procedure proToptimizer_setFilterParams(name:AnsiString;var vec:Tvector;var pu:typeUO);pascal;

procedure proToptimizer_setFilterClamp(name:AnsiString;w:float;var pu:typeUO);pascal;
procedure proToptimizer_setFilterClamp_1(name:AnsiString;w:float;num:integer;var pu:typeUO);pascal;
procedure proToptimizer_setFilterClamp_2(name:AnsiString;var vec:Tvector;var pu:typeUO);pascal;

function fonctionToptimizer_getFilterParam(name:AnsiString;var pu:typeUO):float;pascal;
procedure proToptimizer_getFilterParams(name:AnsiString;var vec:Tvector;var pu:typeUO);pascal;

procedure proToptimizer_InitLMQN(stOut:AnsiString;var vecOut:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_LMstep(var chi2,NormG1:float ;var pu:typeUO);pascal;
procedure proToptimizer_QNstep(var chi2:float ;var pu:typeUO);pascal;

procedure proToptimizer_Ngrad(N:integer;var pu:typeUO);pascal;
function fonctionToptimizer_Ngrad(var pu:typeUO):integer;pascal;

procedure proToptimizer_setFilterBounds(name:AnsiString;var vecMin,vecMax:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_setFilterBounds_1(name:AnsiString; Vmin,Vmax:float;var pu:typeUO);pascal;

procedure proToptimizer_getFilterBounds(name:AnsiString;var vecMin,vecMax:Tvector;var pu:typeUO);pascal;

procedure proToptimizer_setBounds(var vecMin,vecMax:Tvector;var pu:typeUO);pascal;
procedure proToptimizer_getBounds(var vecMin,vecMax:Tvector;var pu:typeUO);pascal;

procedure proToptimizer_getFilterAux(name: AnsiString; numVec,NumOcc:integer;var vec: Tvector;var pu:typeUO);pascal;

procedure proInitINTELlib;pascal;

procedure proToptimizer_setHistoryList(var vec:TVlist;var pu:typeUO);pascal;

procedure proToptimizer_setFilterConsts(name:AnsiString;var vecCte:Tvector;var pu:typeUO);pascal;


implementation

uses OptiEdit1;

{ Toptimizer }


constructor Toptimizer.create;
begin
  inherited;

  IPPStest;
  MKLtest;

  Eval:=TvectorEval.create;

  para:=Tvector.create32(g_double,1,1);
  para.ident:='Para';

  paraMin:=Tvector.create32(g_double,1,1);
  paraMin.ident:='ParaMin';

  paraMax:=Tvector.create32(g_double,1,1);
  paraMax.ident:='ParaMax';

  Jmat:=Tmat.create32(g_double,1,1);
  Jmat.ident:='Jmat';

  Bmat:=Tmat.create32(g_double,1,1);
  Bmat.ident:='Bmat';

  ydat:=Tvector.create32(g_double,1,1);
  ydat.ident:='ydat';

  reset;

  cntmax:=1000;
  seuil:=1E15;

  ParaNames:=TstringList.create;
  modHis:=2;
end;

destructor Toptimizer.destroy;
begin
  editForm.free;

  para.free;
  paraMin.free;
  paraMax.free;

  Jmat.free;
  Bmat.free;

  ydat.free;
  ParaNames.free;

  ClearDerivatives;
  Eval.free;

  derefObjet(typeUO(paraHis));
  inherited;
end;

procedure Toptimizer.ClearDerivatives;
var
  i:integer;
begin
  for i:=0 to high(U1) do
    eval.detruireArbre(U1[i]);
  setLength(U1,0);
end;

procedure Toptimizer.BuildChildList;
var
  i:integer;
begin
  clearChildList;

  addToChildList(para);
  addToChildList(paraMin);
  addToChildList(paraMax);

  addToChildList(Jmat);
  addToChildList(Bmat);
  addToChildList(ydat);

  with eval.varlist do
  for i:=0 to count-1 do
    addToChildList(Tvector(items[i]));


end;

procedure Toptimizer.setChildNames;
begin
  inherited;

end;

class function Toptimizer.STMClassName: AnsiString;
begin
  result:='Optimizer';
end;

function Toptimizer.loadFromFile(st: AnsiString):boolean;
begin
  try
    FileName:=st;
    eval.textPg.LoadFromFile(st);
    result:=true;
  except
    eval.textPg.Clear;
    FileName:='';
    result:=false;
  end;
end;

function Toptimizer.loadFromText(st:AnsiString):boolean;
begin
  try
    FileName:='';
    eval.textPg.Text:=st;
    result:=true;
  except
    eval.textPg.Clear;
    FileName:='';
    result:=false;
  end;
end;

function Toptimizer.setVector(stName: AnsiString; vec: Tvector): boolean;
var
  p:Tvector;
  i:integer;
begin
  result:= false;
  if IstartVec=IendVec+1 then
  begin
    IStartVec:=vec.Istart;
    IendVec:=vec.Iend;
    eval.initVectors(vec.Icount);
  end;

  if (IstartVec=vec.Istart) and (IendVec=vec.Iend) then
  begin
    p:=eval.getVar(stName);
    result:= assigned(p);
    if result then
    begin
      with vec do
      for i:=Istart to Iend do
        p[i-Istart+1]:=Yvalue[i];
    end;
  end;
end;

procedure Toptimizer.setSeg(Vseg: Tvector);
var
  i:integer;
begin
  if not assigned(Vseg) then exit;
  if IstartVec=IendVec+1 then exit;

  setLength(IdatStart,Vseg.Icount div 2);
  setLength(IdatEnd,Vseg.Icount div 2);

  for i:=0 to Vseg.Icount div 2-1 do
  begin
    IdatStart[i]:=Vseg.Jvalue[Vseg.Istart+i*2]-IstartVec+1;
    IdatEnd[i]:=Vseg.Jvalue[Vseg.Istart+i*2+1]-IstartVec+1;
  end;
end;

function Toptimizer.setClamp(clamp: Tvector):boolean;
var
  i:integer;
begin
  result:=false;
  if not assigned(clamp) then exit;

  if not eval.initOK or (clamp.Icount<nbpara) then exit;

  setlength(Vclamp,nbpara);
  for i:=0 to high(Vclamp) do
    Vclamp[i]:=(clamp.Jvalue[clamp.Istart+i]<>0);
    result:=true;
end;




procedure Toptimizer.getVector(stName: AnsiString; vec: Tvector);
var
  p:Tvector;
  i:integer;
begin
  p:=eval.getVar(stName);
  if assigned(p) then
   with vec do
   begin
     modify(tpNum,Istart,Istart+p.ICount-1);
     for i:=Istart to Iend do
       Yvalue[i]:=p[i-Istart+1];
   end;
end;


function Toptimizer.chi2: float;
begin
  result:=ChiSq1;
end;

procedure Toptimizer.setParaLengths(n:integer);
begin
  para.modify(g_double,1,n);
  paraMin.modify(g_double,1,n);
  paraMax.modify(g_double,1,n);
  setlength(Vclamp,n);
end;

function Toptimizer.compile:boolean;
var
  i,j:integer;
begin
  ClearDerivatives;
  with eval do
  begin
    Compiler;
    result:=(stError='');
    if not result then
    begin
      if FileName<>''
        then messageCentral('Error in '+extractFileName(FileName)+crlf
                                  +'line '+Istr(eval.ligneC)+'  column '+Istr(colonneC) )
        else messageCentral('Error in model '+crlf
                                  +'line '+Istr(eval.ligneC)+'  column '+Istr(colonneC) );
    end
    else
    begin
      setParaLengths(Pcount);
      initPara(para,paraMin,paraMax);
      initBounds;

      BuildParaNames;
      updateEditForm;
    end;
  end;

  BuildChildList;

end;

procedure Toptimizer.BuildParaNames;
var
  i,j:integer;
begin
  paraNames.Clear;
  with eval do
  for i:=0 to FilterList.count-1 do
    with Tfilter(FilterList[i]) do
    for j:=0 to paramCount-1 do
      paraNames.Add(Istr1(1+num0+j,3)+': '+paraName(j+1));
end;

procedure Toptimizer.CalculateOutput(stName:AnsiString);
var
  Pexp:ptExp;
  mat:Tvector;
begin
  Pexp:=eval.getExp(stName);
  mat:=eval.getvar(stName);
  if assigned(Pexp) and assigned(mat) then
  begin
    saveTree(Pexp^.rac);
    evaluer(Pexp^.rac,para,mat);
  end;
end;



var
  time0:TdateTime;

procedure Toptimizer.Optimize;
begin
  initchrono(time0);
  affdebug(chrono(time0),77);

  if not initOpti then exit;

  saveTrees;

  executeOpt;
end;

procedure Toptimizer.reset;
begin
  eval.resetPg;

  setParaLengths(0);

  Jmat.clear;
  Bmat.clear;

  setLength(IDatStart,0);
  setLength(IdatEnd,0);

  IStartVec:=0;
  IendVec:=-1;

  ChiSq1:=0;
  BuildChildList;
  initOpti:=false;
end;



procedure Toptimizer.setNbpt(nbpt1: integer);
begin
  eval.initVectors(nbpt1);
end;


function Toptimizer.Chi2opt(vec: Tmat): double;
{ Chi2opt donne un chi2 non normalisé = sum(y²) ,
  travaille sur un vecteur de doubles indicé à partir de 1}
var
  i,i1,i2:integer;
  w:double;
begin
  if length(IdatStart)=0 then  {pas de segments}
  begin
    ippsNorm_L2(Pdouble(vec.tb),vec.Icount,@result);  {Norm_L2=sqrt(sum(y²))}
    result:=sqr(result)                               {Eliminer sqrt }
  end
  else
  begin                        {avec segments}
    result:=0;
    for i:=0 to high(IdatStart) do
    begin
      i1:=IdatStart[i];
      i2:=IdatEnd[i];
      if (i1<=i2) and (i2<=eval.nbpt) then
      begin
        ippsNorm_L2(Pdouble(@PtabDouble1(vec.tb)^[i1]),i2-i1+1,@w);
        result:=result+sqr(w);
      end;
    end;
  end;
end;

{ getChi2 donne un chi2 normalisé
}
function Toptimizer.getChi2(stOut:AnsiString; Vdat: Tvector): double;
var
  yfit:Tvector;
  diff:Tmat;
begin
  result:=0;
  yfit:=eval.getVar(stOut);
  if not assigned(yfit)
    then sortieErreur('Toptimizer.getChi2 : yfit is not calculated');

  if nbpt<>vdat.ICount
    then sortieErreur('Toptimizer.getChi2 : bad number of points in vec');

  if nbpt-nbpara<1 then exit;

  diff:=Tmat.create32(g_double,nbpt,1);
  result:=-1;
  try

  ippssub(Pdouble(yfit.tb),Pdouble(Vdat.tb),Pdouble(diff.tb),nbpt);

  result:=Chi2Opt(diff)/(Nbpt-nbParaNC);
  finally
  diff.free;
  end;

end;

procedure TOptimizer.ParaToNC(vec,vecNC:Tvector);
var
  i,j:integer;
begin
  j:=0;
  for i:=1 to Nbpara do
  if not Vclamp[i-1] then
  begin
    inc(j);
    vecNC[j]:=vec[i];
  end;

end;

procedure TOptimizer.NCtoPara(vecNC,vec:Tvector);
var
  i,j:integer;
begin
  j:=0;
  for i:=1 to Nbpara do
  if not Vclamp[i-1] then
  begin
    inc(j);
    vec[i]:=vecNC[j];
  end;
end;

function getMu(x:float):integer;
begin
  result:=0;
  if x<=0 then exit;

  if x<1 then
  while x<1 do
  begin
    x:=x*10;
    dec(result);
  end
  else
  while x>1 do
  begin
    x:=x/10;
    inc(result);
  end
end;

procedure TOptimizer.executeOpt;
const
  lambda0=1E-5;
  Mlambda:float=10;
  IteraMax=15;
  epsilon=1E-300;
var
  Nlib:integer;
  nbParaNC1:integer;
  befor,first,fin,finB:boolean;
  Lambda,LambdaB:float;
  i,j,k,itera:integer;
  chiSqr:float;

  Alpha,Beta,BB:Tmat;
  BB1:Tvector;
  paraB:Tvector;
  tablo:Tmat;
  diff:Tmat;
  Vnorm:Tvector;
  paraNC:Tvector;

  cnt:longint;
  test:integer;
  w0:double;

  OKyfit:boolean; {indique que yfit contient bien ce qui correspond à paraNC}

begin
  FinDemandee:=false;

  NbparaNC1:=nbParaNC;
  Nlib:=Nbpt-NbParaNC1;
  if Nlib<=0 then exit;

  Lambda:=lambda0;
  befor:=false;
  first:=true;
  fin:=false;
  cnt:=0;

  Beta:=Tmat.create32(g_double,NbparaNC1,1);
  BB:=Tmat.create32(g_double,NbparaNC1,1);
  BB1:=Tvector.create32(g_double,1,NbparaNC1);

  paraB:=Tvector.create32(g_double,1,NbparaNC1);
  Alpha:=Tmat.create32(g_double,NbparaNC1,NbparaNC1);
  tablo:=Tmat.create32(g_double,NbparaNC1,NbparaNC1);
  diff:=Tmat.create32(g_double,Nbpt,1);
  Vnorm:=Tvector.create32(g_double,1,NbparaNC1);
  paraNC:=Tvector.create32(g_double,1,NbparaNC1);

  paraDum:=Tvector.create32(g_double,1,Nbpara);
  paraDum.Vcopy(para);

  paraToNC(para,paraNC);

  affdebug('début boucle '+chrono(time0),77);

  TRY
  repeat                          { Boucle principale }

    getYfit(paraNC);                 { Calcul yfit = estimation pour para }
    {affdebug('para:  '+Estr1(para[1],20,12)+Estr1(para[2],20,12)+Estr1(para[3],20,12),20);}
    OKyfit:=true;

    affdebug('getYfit '+chrono(time0),77);
    ippsSub(Pdouble(yfit.tb),Pdouble(ydat.tb),Pdouble(diff.tb),nbpt);

    chisq1:=chi2opt(diff)/Nlib;

    {statuslineTxt('opt 1');}

    getJacobian(paraNC);             { Calcul matrice jacobienne }
    affdebug('getJacobian '+chrono(time0),77);

    {statuslineTxt('opt 2');}
    beta.prod(Jmat,diff,transpose,normal);
    alpha.prod(Jmat,Jmat,transpose,normal);
    {nspdbMpy1(1/nbpt,alpha.tb,nbparaNC1*nbparaNC1);}
    ippsmulC(1/nbpt,Pdouble(alpha.tb),nbparaNC1*nbparaNC1);

    {affdebug('alpha:  '+Estr1(alpha[1,1],20,12)+Estr1(alpha[2,2],20,12)+Estr1(alpha[3,3],20,12),20);}

    for i:=1 to nbparaNC1 do
     if abs(alpha[i,i])<epsilon then
       if alpha[i,i]>0 then alpha[i,i]:=epsilon
                       else alpha[i,i]:=-epsilon ;

    for i:=1 to nbParaNC1 do
      Vnorm[i]:=1/sqrt(abs(alpha[i,i]));

    for i:=1 to nbParaNC1 do
    begin
       for j:=1 to nbParaNC1 do
         alpha[i,j]:=alpha[i,j]*(Vnorm[i]*Vnorm[j]);
       alpha[i,i]:=1.0+Lambda;
       beta[i,1]:=beta[i,1]*Vnorm[i];
    end;
    {statuslineTxt('MU='+Istr(getMu(lambda)));}

    affdebug('repeat '+chrono(time0),77);

    itera:=0;
    finB:=false;
    repeat
      affdebug('   IT '+chrono(time0),77);
      tablo.copy(alpha);
      with tablo do
      for j:=1 to rowCount do
        tablo[j,j]:=1.0+Lambda;
      affdebug('MU='+Istr(getMu(lambda)),29);

      tablo.solveChk(beta,BB);

      for i:=1 to nbParaNC1 do BB1[i]:=BB[i,1]*Vnorm[i];

      ippsAdd(paraNC.tbD,BB1.tbD,nbparaNC1);

      controleVar(BB1);
      getYfit(BB1);                    { Calcul du chi carré pour BB }

      ippsSub(yfit.tbD,ydat.tbD,diff.tbD,nbpt);

      chisqr:=chi2opt(diff)/Nlib;

      {affdebug('BB1 ==>  '+Estr1(BB1[1],20,12)+Estr1(BB1[2],20,12)+Estr1(BB1[3],20,12),20);}

      affdebug('  ==>'+Estr(BB[1,1],3)+' Lambda='+Estr(lambda,3)+' chi='+Estr(chisqr,3)
                     +' diff='+Estr(diff[1,1],3)
                     +' ydat='+Estr(ydat[1],3)
                     +' yfit='+Estr(yfit[1],3)
        ,29 );

      if (ChiSqr<=Chisq1) then        { S'il est meilleur, on le garde }
        begin
          paraB.Vcopy(paraNC);
          paraNC.Vcopy(BB1);

          first:=false;
          LambdaB:=Lambda;
          Lambda:=Lambda/Mlambda;
          if (ChiSq1-ChiSqr)*seuil>Chisq1
            then FinB:=true
            else fin:=true;

          chiSq1:=ChiSqr;

          if assigned(paraHis) then testGrad(paraNC);
          OKyfit:=true;
        end
      else                           { Sinon on le rejette }
        begin
          Lambda:=Lambda*Mlambda;
          inc(Itera);
          OKyfit:=false;
        end;

      if testerFinPg then
      begin
        fin:=true;
        FinDemandee:=true;
      end;
      affdebug('Itera= '+Istr(itera),78);

    until (itera>IteraMax) or FinB or Fin;

    inc(cnt);
    if cnt>=cntmax then fin:=true;

    if not (FinB or Fin) then
      begin
        if Befor or first then  fin:=true
        else
        begin
          paraNC.Vcopy(paraB);
          Lambda:=LambdaB*Mlambda;
          Befor:=True;
        end;

      end;
    {else lambda:=lambda0;}

  until Fin;       { Fin Boucle Principale }

  {if not OKyFit then} getYfit(paraNC);
  affdebug('Fin boucle  '+chrono(time0),77);

  FINALLY
    Beta.free;
    BB.free;
    BB1.free;
    paraB.free;
    Alpha.free;
    tablo.free;
    diff.free;
    Vnorm.free;

    NCtoPara(paraNC,para);

    paraNC.Free;
    paraDum.free;
    paraDum:=nil;
  END;
end;

(*
procedure Toptimizer.TestGrad(paraNC:Tvector);
var
  Vdiff:array of double;
  oldParam:Tvector;
  diff:Tmat;
  nbIt:integer;
  ch,oldChi2:double;
  nbparaNC1:integer;

begin
  if not assigned(paraHis) or (modHis<1) then exit;


  ParaHis.AddVector(paraNC);

  if paraHis.count<=modHis then exit;

  nbParaNC1:=paraNC.Icount;
  setLength(Vdiff,nbparaNC1);
  Diff:=Tmat.create32(g_double,nbpt,1);

  oldParam:=Tvector.create32(g_double,0,0);
  TRY
  ippsSub(paraHis.Vectors[paraHis.count-modHis+1].tbD,ParaNC.tbD,@Vdiff[0],nbParaNC1);

  ippsMulC(0.1,@Vdiff[0],nbParaNC1);
  nbIt:=0;
  ch:=ChiSq1;
  repeat
    oldChi2:=ch;
    oldParam.Vcopy(paraNC);
    ippsAdd(@Vdiff[0],paraNC.tbd,nbParaNC1);

    controleVar(paraNC);
    getYfit(paraNC);

    ippsSub(yfit.tbd,ydat.tbd,diff.tbd,nbpt);
    ch:=chi2opt(diff)/(Nbpt-nbparaNC1);
    inc(nbIt);

  until (ch>oldChi2) or (nbIt>100);

  paraNC.Vcopy(oldParam);

  chiSq1:=oldChi2;

  Finally
  diff.free;
  oldParam.free;
  End;
end;
*)

procedure Toptimizer.TestGrad(paraNC:Tvector);
var
  Vdum:Tvector;
  Vdiff:array of double;
  Diff:Tmat;
  oldParam:Tvector;
  dd:double;
  nbIt:integer;
  ch,oldChi2:double;
  i,nbparaNC1:integer;
  N:integer;

begin
  nbParaNC1:=paraNC.Icount;
  if not assigned(paraHis) or (nbParaNC1<1) then exit;

  setLength(Vdiff,nbParaNC1+1);

  with ParaHis do
  begin
    if count=0 then
    begin                             {Initialiser ParaHis}
      Vdum:=Tvector.create;
      Vdum.initList(g_double);
      for i:=1 to nbParaNC1 do AddVector(Vdum);
      Vdum.free;
    end;

    for i:=1 to nbParaNC1 do          {Ajouter les nouvelles valeurs}
      vectors[i].addtoList(paraNC[i]);
  end;

  if (modHis<1) or (paraHis.vectors[1].Iend<=modHis) then exit;


  Diff:=Tmat.create32(g_double,nbpt,1);
  oldParam:=Tvector.create32(g_double,0,0);

  TRY
  N:=modHis;

  Repeat
    if paraHis.Vectors[1].Iend>3*N then
    begin
      with ParaHis do
      begin
        for i:=1 to nbParaNC1 do
        with vectors[i] do
        begin                             {Différence entre f(Iend) et f(Iend-N)}
          Vdiff[i]:=Yvalue[Iend]-Yvalue[Iend-N];
          if Iend>2*N then
          begin
            dd:=Yvalue[Iend-N]-Yvalue[Iend-2*N];
            if abs(dd)<>0 then Vdiff[i]:=Vdiff[i]*abs(Vdiff[i]/dd)/N
                          else Vdiff[i]:=Vdiff[i]/10/N;
          end
          else Vdiff[i]:=Vdiff[i]/10/N;
        end;
      end;

      nbIt:=0;
      ch:=ChiSq1;
      repeat
        oldChi2:=ch;
        oldParam.Vcopy(paraNC);
        ippsAdd(@Vdiff[1],paraNC.tbd,nbParaNC1);

        controleVar(paraNC);
        getYfit(paraNC);

        ippsSub(yfit.tbd,ydat.tbd,diff.tbd,nbpt);
        ch:=chi2opt(diff)/(Nbpt-nbparaNC1);
        inc(nbIt);

      until (ch>oldChi2) or (nbIt>100);

      paraNC.Vcopy(oldParam);

      chiSq1:=oldChi2;
    end;

    dec(N);
  until N<=1;

  Finally
  oldParam.free;
  diff.free;
  End;
end;


procedure Toptimizer.initBmat;
var
  i:integer;
  nbCC:integer;
begin
  nbCC:=nbParaNC;
  with Bmat do
  begin
    setSize(nbCC,nbCC);
    for i:=1 to nbCC do
      Zvalue[i,i]:=1;
  end;

  JmatOld:=Tmat.create32(g_double,nbpt,nbCC);
end;


procedure TOptimizer.updateBmat(oldPara,newPara:Tvector;diff:Tmat);
var
  alpha:Tmat;
  h:Tmat;
  yQN,vQN,yfx,Bdum:Tmat;
  why,whv:double;
begin
(*
  alpha:=Tmat.create32(g_double,1,1);
  h:=Tmat.create32(g_double,1,1);

  yQN:=Tmat.create32(g_double,1,1);
  vQN:=Tmat.create32(g_double,1,1);
  Bdum:=Tmat.create32(g_double,1,1);
  yfx:=Tmat.create32(g_double,1,1);

  TRY
  h.copy(newPara);
  nspdbSub2(oldpara.tb,h.tb,h.Kcount);

  alpha.prod(Jmat,Jmat,transpose,normal);  { Hessienne habituelle }
  yQN.prod(alpha,h);
  Bdum.sub(Jmat,JmatOld);
  JmatOld.copy(Jmat);

  yfx.prod(Bdum,diff,transpose,normal);
  yQN.add(yQN,yfx);

  why:=NspdDotProd(h.tb,yQN.tb,h.Kcount);
  if why>0 then
  begin
    vQN.prod(Bmat,h);
    Bdum.prod(yQN,yQN,normal,transpose);
    Bdum.mulnum(1/why);
    Bmat.add(Bmat,Bdum);
    whv:=nspdDotProd(h.tb,vQN.tb,h.Kcount);
    Bdum.prod(vQN,vQN,normal,transpose);
    Bdum.mulnum(1/whv);
    Bmat.sub(Bmat,Bdum);
  end;

  FINALLY
    alpha.free;
    h.Free;
    yQN.free;
    vQN.free;
    Bdum.free;
    yfx.free;
  END;
  *)
end;

function TOptimizer.getNormG(diff:Tmat):double;
var
  dum:Tmat;
begin
  dum:=Tmat.create32(g_double,1,1);
  try
  dum.prod(Jmat,diff,transpose,normal);
  {result:=nspdNorm(dum.tb,nil,dum.Kcount,NSP_C);}
  ippsNorm_inf(Pdouble(dum.tb),dum.Kcount,@result);
  finally
  dum.Free;
  end;
end;

function TOptimizer.initOpt(stOut:AnsiString;VecOut:Tvector):boolean;
var
  i:integer;
begin
  initOpti:=false;
  result:=eval.initOK;
  if not result then exit;

  if vecOut.Icount<>nbpt
    then sortieErreur('Toptimizer.init : bad vector length ');

  U0:=eval.getExp(stOut);
  yfit:=eval.getVar(stOut);
  result:=assigned(U0) and assigned(yfit);
  if not result then
  begin
    sortieErreur('Toptimizer.optimize : unable to calculate expression ');
    exit;
  end;


  ClearDerivatives;
  with eval do
  begin
    setLength(U1,Pcount);
    for i:=0 to Pcount-1 do
      U1[i]:=derivee(U0^.rac,i);
  end;

  ydat.modify(g_double,1,nbpt);
  with vecOut do
  for i:=Istart to Iend do
    ydat[i-Istart+1]:=Yvalue[i];

  initOpti:=true;
end;

procedure TOptimizer.LMstep;
const
  lambda0=1E-5;
  Mlambda:float=10;
  IteraMax=25;
  epsilon=1E-300;
var
  Nlib:integer;
  nbParaNC1:integer;
  befor,first,fin,finB:boolean;
  Lambda,LambdaB:float;
  i,j,k,itera:integer;
  chiSqr:float;

  Alpha,Beta,BB:Tmat;
  BB1:Tvector;
  paraB:Tvector;
  tablo:Tmat;
  diff:Tmat;
  Vnorm:Tvector;
  paraNC:Tvector;

  cnt:longint;
  test:integer;
  w0:double;

begin
(*
  NbparaNC1:=nbParaNC;
  Nlib:=Nbpt-NbParaNC1;
  if Nlib<=0 then exit;

  Lambda:=lambda0;
  befor:=false;
  first:=true;
  fin:=false;
  cnt:=0;

  Beta:=Tmat.create32(g_double,NbparaNC1,1);
  BB:=Tmat.create32(g_double,NbparaNC1,1);
  BB1:=Tvector.create32(g_double,1,NbparaNC1);

  paraB:=Tvector.create32(g_double,1,NbparaNC1);
  Alpha:=Tmat.create32(g_double,NbparaNC1,NbparaNC1);
  tablo:=Tmat.create32(g_double,NbparaNC1,NbparaNC1);
  diff:=Tmat.create32(g_double,Nbpt,1);
  Vnorm:=Tvector.create32(g_double,1,NbparaNC1);
  paraNC:=Tvector.create32(g_double,1,NbparaNC1);

  paraDum:=Tvector.create32(g_double,1,Nbpara);
  paraDum.Vcopy(para);

  paraToNC(para,paraNC);
  paraB.Vcopy(paraNC);

  affdebug('Toptimizer.executeOpt ',29 );
  TRY
    getYfit(paraNC);                 { Calcul yfit = estimation pour para }

    move(ydat.tb^,diff.tb^,nbpt*8);
    nspdbsub2(yfit.tb,diff.tb,nbpt);

    chisq1:=chi2opt(diff)/Nlib;

    getJacobian(paraNC);             { Calcul matrice jacobienne }

    alpha.prod(Jmat,Jmat,transpose,normal);  { Hessienne habituelle }
    beta.prod(Jmat,diff,transpose,normal);

    nspdbMpy1(1/nbpt,alpha.tb,nbparaNC1*nbparaNC1);

    for i:=1 to nbparaNC1 do
     if abs(alpha[i,i])<epsilon then
       if alpha[i,i]>0 then alpha[i,i]:=epsilon
                       else alpha[i,i]:=-epsilon ;

    for i:=1 to nbParaNC1 do
      Vnorm[i]:=1/sqrt(abs(alpha[i,i]));

    for i:=1 to nbParaNC1 do
    begin
       for j:=1 to nbParaNC1 do
         alpha[i,j]:=alpha[i,j]*(Vnorm[i]*Vnorm[j]);
       alpha[i,i]:=1.0+Lambda;
       beta[i,1]:=beta[i,1]*Vnorm[i];
    end;

    itera:=0;
    finB:=false;
    repeat
      tablo.copy(alpha);

      with tablo do
      for j:=1 to rowCount do
        tablo[j,j]:=1.0+Lambda;
      affdebug('MU='+Istr(getMu(lambda)),29);

      tablo.solveChk(beta,BB);

      for i:=1 to nbParaNC1 do BB1[i]:=BB[i,1]*Vnorm[i];

      nspdbAdd2(paraNC.tb,BB1.tb,nbparaNC1);

      controleVar(BB1);
      getYfit(BB1);                    { Calcul du chi carré pour BB }

      move(ydat.tb^,diff.tb^,nbpt*8);
      nspdbsub2(yfit.tb,diff.tb,nbpt);
      chisqr:=chi2opt(diff)/Nlib;

      affdebug('  ==>'+Estr(BB[1,1],3)+' Lambda='+Estr(lambda,3)+' chi='+Estr(chisqr,3)
                     +' diff='+Estr(diff[1,1],3)
                     +' ydat='+Estr(ydat[1],3)
                     +' yfit='+Estr(yfit[1],3)
        ,29 );

      if (ChiSqr<=Chisq1) then        { S'il est meilleur, on le garde }
        begin
          updateBmat(paraB,paraNC,diff);
          NormG:=getNormG(diff)/Nlib;
          paraB.Vcopy(paraNC);
          paraNC.Vcopy(BB1);

          first:=false;               { first = on n'a jamais amélioré }
          LambdaB:=Lambda;
          Lambda:=Lambda/Mlambda;
          if (ChiSq1-ChiSqr)*seuil>Chisq1
            then FinB:=true
            else fin:=true;
                                     { fin or finB = amélioration du chi2 }
                                     { fin = seuil atteint }
                                     { finB = seuil non atteint }
          chiSq1:=ChiSqr;

        end
      else                           { Sinon on le rejette }
        begin
          Lambda:=Lambda*Mlambda;
          inc(Itera);
        end;

      if testerFinPg then fin:=true;
    until (itera>IteraMax) or FinB or Fin;
                   { on boucle si pas d'amélioration et si max it non atteint }


  FINALLY
    Beta.free;
    BB.free;
    BB1.free;
    paraB.free;
    Alpha.free;
    tablo.free;
    diff.free;
    Vnorm.free;

    NCtoPara(paraNC,para);

    paraDum.free;
    paraDum:=nil;
  END;
  *)
end;


procedure TOptimizer.QNstep;
const
  lambda0=1E-5;
  Mlambda:float=10;
  IteraMax=25;
  epsilon=1E-300;
var
  Nlib:integer;
  nbParaNC1:integer;
  befor,first,fin,finB:boolean;
  Lambda,LambdaB:float;
  i,j,k,itera:integer;
  chiSqr:float;

  Alpha,Beta,BB:Tmat;
  BB1:Tvector;
  paraB:Tvector;
  tablo:Tmat;
  diff:Tmat;
  Vnorm:Tvector;
  paraNC:Tvector;

  cnt:longint;
  test:integer;
  w0:double;

begin
(*
  NbparaNC1:=nbParaNC;
  Nlib:=Nbpt-NbParaNC1;
  if Nlib<=0 then exit;

  Lambda:=lambda0;
  befor:=false;
  first:=true;
  fin:=false;
  cnt:=0;

  Beta:=Tmat.create32(g_double,NbparaNC1,1);
  BB:=Tmat.create32(g_double,NbparaNC1,1);
  BB1:=Tvector.create32(g_double,1,NbparaNC1);

  paraB:=Tvector.create32(g_double,1,NbparaNC1);
  Alpha:=Tmat.create32(g_double,NbparaNC1,NbparaNC1);
  tablo:=Tmat.create32(g_double,NbparaNC1,NbparaNC1);
  diff:=Tmat.create32(g_double,Nbpt,1);
  Vnorm:=Tvector.create32(g_double,1,NbparaNC1);
  paraNC:=Tvector.create32(g_double,1,NbparaNC1);

  paraDum:=Tvector.create32(g_double,1,Nbpara);
  paraDum.Vcopy(para);

  paraToNC(para,paraNC);

  affdebug('Toptimizer.executeOpt ',29 );
  TRY
    getYfit(paraNC);                 { Calcul yfit = estimation pour para }

    move(ydat.tb^,diff.tb^,nbpt*8);
    nspdbsub2(yfit.tb,diff.tb,nbpt);

    chisq1:=chi2opt(diff)/Nlib;

    getJacobian(paraNC);             { Calcul matrice jacobienne }

    alpha.copy(Bmat);
    beta.prod(Jmat,diff,transpose,normal);

    nspdbMpy1(1/nbpt,alpha.tb,nbparaNC1*nbparaNC1);

    for i:=1 to nbparaNC1 do
     if abs(alpha[i,i])<epsilon then
       if alpha[i,i]>0 then alpha[i,i]:=epsilon
                       else alpha[i,i]:=-epsilon ;

    for i:=1 to nbParaNC1 do
      Vnorm[i]:=1/sqrt(abs(alpha[i,i]));

    for i:=1 to nbParaNC1 do
    begin
       for j:=1 to nbParaNC1 do
         alpha[i,j]:=alpha[i,j]*(Vnorm[i]*Vnorm[j]);
       beta[i,1]:=beta[i,1]*Vnorm[i];
    end;

    alpha.solveChk(beta,BB);
    for i:=1 to nbParaNC1 do BB1[i]:=BB[i,1]*Vnorm[i];

    nspdbAdd2(paraNC.tb,BB1.tb,nbparaNC1);
    controleVar(BB1);
    getYfit(BB1);                    { Calcul du chi carré pour BB }

    move(ydat.tb^,diff.tb^,nbpt*8);
    nspdbsub2(yfit.tb,diff.tb,nbpt);
    chisqr:=chi2opt(diff)/Nlib;

    if (ChiSqr<=Chisq1) then        { S'il est meilleur, on le garde }
    begin
      updateBmat(paraB,paraNC,diff);
      NormG:=getNormG(diff);
      paraNC.Vcopy(BB1);
    end;

  FINALLY
    Beta.free;
    BB.free;
    BB1.free;
    paraB.free;
    Alpha.free;
    tablo.free;
    diff.free;
    Vnorm.free;

    NCtoPara(paraNC,para);

    paraDum.free;
    paraDum:=nil;
  END;
*)
end;


procedure Toptimizer.getYfit(pp: Tvector);
var
  i,j:integer;
begin
  NCtoPara(pp,paraDum);
  evaluerExp(U0,paraDum,yfit);
end;

procedure Toptimizer.getJacobian(pp: Tvector);
var
  i,j:integer;
  Vdum:Tvector;
begin
  Vdum:=Tvector.create32(g_double,1,nbpt);
  Vdum.NotPublished:=true;

  Jmat.setSize(nbpt,pp.Icount);
  Jmat.fill(0);

  NCtoPara(pp,paraDum);

  try
  j:=0;
  for i:=1 to NbPara do
  if not Vclamp[i-1] then
  begin
    inc(j);
    evaluer(U1[i-1],paraDum,Vdum);
    move(Vdum.tb^,Jmat.cell(1,j)^,nbpt*8);
    affdebug('   Jacobian param '+Istr(j)+' '+chrono(time0),77);
  end;

  finally
  Vdum.free;
  end;
end;


procedure Toptimizer.controleVar(dd: Tvector);
var
  i,j:integer;
begin
  j:=0;
  for i:=1 to NbPara do
  if not Vclamp[i-1] then
  begin
    inc(j);

    if paraMin[i]<paraMax[i] then
    begin
      if dd[j]<paraMin[i] then dd[j]:=paraMin[i]
      else
      if dd[j]>paraMax[i] then dd[j]:=paraMax[i];
    end;

  end;




 (* Pourrait compléter les contraintes

   NCtoPara(dd,paraDum);
  with eval.FilterList do
  for i:=0 to count-1 do
    Tfilter(items[i]).controleVar(paraDum.tb);
  *)
end;

function Toptimizer.nbpara: integer;
begin
  result:=eval.Pcount;
end;

function Toptimizer.nbparaNC: integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to high(VClamp) do
    if not Vclamp[i] then inc(result);
end;


function Toptimizer.nbpt: integer;
begin
  result:=eval.nbpt;
end;


procedure Toptimizer.evaluer(U:ptElem;para1,matRes:Tvector);
begin
  IPPStest;
  try
  eval.initPara(para1,paraMin,paraMax);
  eval.evaluer(U,matRes);
  finally
  IPPSend;
  end;
end;

procedure Toptimizer.evaluerExp(U:ptExp;para1,matRes:Tvector);
begin
  IPPStest;
  try
  eval.initPara(para1,paraMin,paraMax);
  eval.evaluerExp(U,matRes);
  finally
  IPPSend;
  end;
end;


procedure Toptimizer.saveTree(rac:ptElem);
var
  f:Text;
  i:integer;
begin
  try
  assign(f,debugPath+'Tree.txt');
  rewrite(f);
  writeln(f,  '--------------------------------- TREE');
  eval.AffArbre0(f,rac);
  close(f);
  except
  {$I-}closeFile(f);{$I+}
  end;
end;


procedure Toptimizer.saveTrees;
var
  f:Text;
  i:integer;
begin
  try
  assign(f,debugPath+'Trees.txt');
  rewrite(f);
  writeln(f,  '--------------------------------- U0');
  eval.AffArbre0(f,U0^.rac);

  for i:=0 to high(U1) do
  begin
    writeln(f,'');
    writeln(f,'---------------------------------- U1 Param '+Istr(i));
    eval.AffArbre0(f,U1[i]);
  end;

  closeFile(f);
  except
  {$I-}closeFile(f);{$I+}
  end;
end;


procedure Toptimizer.setParams(vec: Tvector);
var
  i,max:integer;
begin
  if eval.Pcount<vec.Icount
    then max:=eval.Pcount
    else max:=vec.Icount;
  if eval.initOK then
    for i:=0 to max-1 do
      para[i+1]:=vec[vec.Istart+i];
end;

procedure Toptimizer.getParams(vec: Tvector);
var
  i:integer;
begin
  with vec do
  initTemp1(Istart,Istart+eval.Pcount-1,tpNum);

  for i:=0 to eval.Pcount-1 do
    vec[vec.Istart+i]:=para[i+1];
end;

function Toptimizer.getFilterParam(name: AnsiString): float;
var
  fil:Tfilter;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then
      result:= para[fil.num0+1];
  end;
end;


procedure Toptimizer.setFilterParam(name: AnsiString; w: float);
var
  fil:Tfilter;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) and (fil.num0<eval.Pcount)  then
    begin
      para[fil.num0+1]:=w;
    end;
  end;
end;

procedure Toptimizer.setFilterParams(name: AnsiString; vec: Tvector);
var
  fil:Tfilter;
  i,max:integer;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then
    begin
      max:=vec.Icount;
      if max>fil.paramCount then max:=fil.paramCount;
      for i:=0 to max-1 do
        para[fil.num0+1+i]:=vec[vec.Istart+i];
    end;
  end;
end;

function Toptimizer.setFilterClamp(name: AnsiString; clamp: Tvector): boolean;
var
  fil:Tfilter;
  i,max:integer;
begin
  result:=false;
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    setlength(Vclamp,nbpara);

    if assigned(fil) and (fil.num0<eval.Pcount)  then
    begin
      max:=clamp.Icount;
      if max>fil.paramCount then max:=fil.paramCount;
      for i:=0 to max-1 do
        Vclamp[fil.num0+i]:=(clamp[clamp.Istart+i]<>0);
    end;
  end;

  result:=true;
end;

function Toptimizer.setFilterClamp(name: AnsiString; clamp: float;num:integer): boolean;
var
  fil:Tfilter;
begin
  result:=false;
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    setlength(Vclamp,nbpara);

    if assigned(fil) and (fil.num0+num-1<eval.Pcount) and (num>=1) and (num<=fil.paramCount)
     then Vclamp[fil.num0+num-1]:=(clamp<>0)
     else exit;
  end;

  result:=true;
end;



procedure Toptimizer.setBounds(vecMin,vecMax: Tvector);
var
  i,max:integer;
begin
  if eval.Pcount<vecMin.Icount
    then max:=eval.Pcount
    else max:=vecMin.Icount;
  if eval.initOK then
    for i:=0 to max-1 do
    begin
      paraMin[i+1]:=vecMin[vecMin.Istart+i];
      paraMax[i+1]:=vecMax[vecMax.Istart+i];
    end;
end;

procedure Toptimizer.getBounds(vecMin,vecMax: Tvector);
var
  i:integer;
begin
  with vecMin do
  initTemp1(Istart,Istart+eval.Pcount-1,tpNum);

  with vecMax do
  initTemp1(Istart,Istart+eval.Pcount-1,tpNum);

  for i:=0 to eval.Pcount-1 do
  begin
    vecMin[vecMin.Istart+i]:=paraMin[i+1];
    vecMax[vecMax.Istart+i]:=paraMax[i+1];
  end;

end;

procedure Toptimizer.setFilterBounds(name: AnsiString; vecMin,vecMax: Tvector);
var
  fil:Tfilter;
  i,max:integer;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then
    begin
      max:=vecMin.Icount;
      if max>fil.paramCount then max:=fil.paramCount;
      for i:=0 to max-1 do
      begin
        paraMin[fil.num0+1+i]:=vecMin[vecMin.Istart+i];
        paraMax[fil.num0+1+i]:=vecMax[vecMax.Istart+i];
      end;
    end;
  end;
end;

procedure Toptimizer.setFilterBounds(name: AnsiString; Vmin,Vmax:float);
var
  fil:Tfilter;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then
    begin
      paraMin[fil.num0+1]:= Vmin;
      paraMax[fil.num0+1]:= Vmax;
    end;
  end;
end;

procedure Toptimizer.setFilterConsts(name:AnsiString;vecCte:Tvector);
var
  fil:Tfilter;
  i,max:integer;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then fil.setConsts(vecCte);
  end;
end;

procedure Toptimizer.getFilterBounds(name: AnsiString; vecMin,vecMax: Tvector);
var
  fil:Tfilter;
  i:integer;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then
    begin
      vecMin.modify(vecMin.tpNum,vecMin.Istart,vecMin.Istart+fil.paramCount-1 );
      vecMax.modify(vecMax.tpNum,vecMax.Istart,vecMax.Istart+fil.paramCount-1 );

      for i:=0 to fil.paramCount-1 do
      begin
        vecMin[vecMin.Istart+i]:=paraMin[fil.num0+1+i];
        vecMax[vecMax.Istart+i]:=paraMax[fil.num0+1+i];
      end;
    end;
  end;
end;


procedure Toptimizer.getFilterParams(name: AnsiString; vec: Tvector);
var
  fil:Tfilter;
  i:integer;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil) then
    begin
      vec.modify(vec.tpNum,vec.Istart,vec.Istart+fil.paramCount-1 );
      for i:=0 to fil.paramCount-1 do
        vec[vec.Istart+i]:=para[fil.num0+1+i];
    end;
  end;
end;

procedure Toptimizer.ChkManu2(N:integer;h1, h2: Tvector; K11, K12, K21, K22: Tmatrix; stX1, stX2,stY: AnsiString);
var
  chk:Tchkpstw;
  Vx1,Vx2,Vy:Tvector;
  i,tau,tau1,tau2,nbInc:integer;
  ind1,ind2:integer;
  x11,x12,x21,x22:float;
  phi1,phi2:integer;
begin
  chk:=TchkPstw.create;

  eval.initVectors(N*10); {vecteurs avec 10 fois le nombre de paramètres}

  Vx1:=eval.getVar(stX1);
  Vx2:=eval.getVar(stX2);
  Vy:=eval.getVar(stY);

  h1.modify(g_double,0,n-1);
  h2.modify(g_double,0,n-1);
  K11.modify(g_double,0,n-1,0,n-1);
  K12.modify(g_double,0,n-1,0,n-1);
  K21.modify(g_double,0,n-1,0,n-1);
  K22.modify(g_double,0,n-1,0,n-1);


  {Etape 1: VX1=random , VX2=0 , on calcule h1 et K11 }
  Vx1.Vrandom(-1,1);
  Vx2.fill(0);
  CalculateOutPut(stY);

  nbInc:= n + n*(n+1) div 2;
  chk.Init(nbInc,1);

  for i:=Vx1.Istart+n to Vx1.Iend do
  begin
    CHK.clearMatSline;

    for tau:=0 to n-1 do
      CHK.MatSline[tau]:=Vx1.Yvalue[i-tau];

    for tau1:=0 to n-1 do
    for tau2:=0 to n-1 do
    begin
      x11:=Vx1.Yvalue[i-tau1];                   {2eme indice = num entrée }
                                                 {1er indice =  Tau }
      x21:=Vx1.Yvalue[i-tau2];

      ind1:=tau1;
      ind2:=tau2;
      if ind1>=ind2 then
        CHK.MatSline[n*2 +ind1*(ind1+1) div 2+ind2]:=x11*x21;     {K11}
    end;


    CHK.clearBXline;
    CHK.BXline[0]:= Vy.Yvalue[i];

    CHK.UpdateHessian;
  end;

  chk.Solve(false);

  for tau:=0 to n-1 do
    h1[tau]:=chk.XX[tau+1,1];

  for tau1:=0 to n-1 do
  for tau2:=0 to n-1 do
  begin
    ind1:=tau1;
    ind2:=tau2;

    if ind1>=ind2
      then K11[tau1,tau2]:=CHK.XX[1+n*2 +ind1*(ind1+1) div 2+ind2,1]
      else K11[tau1,tau2]:=CHK.XX[1+n*2 +ind2*(ind2+1) div 2+ind1,1];
  end;

  {Etape 2: VX1=0 , VX2=random , on calcule h2 et K22 }

  Vx1.fill(0);
  Vx2.Vrandom(-1,1);
  CalculateOutPut(stY);

  nbInc:= n + n*(n+1) div 2;
  chk.Init(nbInc,1);

  for i:=Vx2.Istart+n to Vx1.Iend do
  begin
    CHK.clearMatSline;

    for tau:=0 to n-1 do
      CHK.MatSline[tau]:=Vx2.Yvalue[i-tau];

    for tau1:=0 to n-1 do
    for tau2:=0 to n-1 do
    begin
      x11:=Vx1.Yvalue[i-tau1];                   {2eme indice = num entrée }
      x12:=Vx2.Yvalue[i-tau1];                   {1er indice =  Tau }

      x21:=Vx1.Yvalue[i-tau2];
      x22:=Vx2.Yvalue[i-tau2];

      ind1:=tau1;
      ind2:=tau2;
      if ind1>=ind2 then
        CHK.MatSline[n*2 +ind1*(ind1+1) div 2+ind2]:=x11*x21;     {K11}
    end;


    CHK.clearBXline;
    CHK.BXline[0]:= Vy.Yvalue[i];

    CHK.UpdateHessian;
  end;

  chk.Solve(false);

  for tau:=0 to n-1 do
    h1[tau]:=chk.XX[tau+1,1];

  for tau1:=0 to n-1 do
  for tau2:=0 to n-1 do
  begin
    ind1:=tau1;
    ind2:=tau2;

    if ind1>=ind2
      then K11[tau1,tau2]:=CHK.XX[1+n*2 +ind1*(ind1+1) div 2+ind2,1]
      else K11[tau1,tau2]:=CHK.XX[1+n*2 +ind2*(ind2+1) div 2+ind1,1];
  end;


end;

function Toptimizer.getPopUp:TpopupMenu;
var
  mi,cursorItem:TmenuItem;
  i:integer;
begin

  with PopUps do
  begin
    PopUpItem(pop_Toptimizer,'Toptimizer_Info').onclick:=self.Show;
    PopUpItem(pop_Toptimizer,'Toptimizer_CalculateOutputs').onclick:=CalculateOutputs;

    result:=pop_Toptimizer;
  end;
end;

procedure Toptimizer.CalculateOutputs(sender: Tobject);
begin
  eval.initPara(para,paraMin,paraMax);
  if eval.initOK then eval.evaluerTOUT;

  invalidateVectors;
end;

procedure Toptimizer.invalidateVectors;
var
  i:integer;
begin
  with ChildList do
  for i:=0 to count-1 do typeUO(items[i]).invalidate;
  if assigned(editForm) then editForm.Invalidate;
end;

procedure Toptimizer.UpdateEditForm;
begin
  if assigned(EditForm) then ToptiForm(EditForm).init(self);
end;

procedure Toptimizer.Show(sender: Tobject);
begin
  if not assigned(EditForm) then
    Editform:=ToptiForm.create(formStm);

  updateEditForm;

  EditForm.Show;
end;

procedure Toptimizer.getFilterAux(name: AnsiString; numVec,NumOcc:integer;vec: Tvector);
var
  fil:Tfilter;
begin
  if eval.initOK then
  begin
    fil:=eval.getFilter(name);
    if assigned(fil)
      then fil.getAux(numVec,numOcc,vec)
      else sortieErreur('Toptimizer : getFilterAux : filter not found');
  end
  else sortieErreur('Toptimizer : getFilterAux : optimizer not initialized');
end;

procedure Toptimizer.setHistoryList(var vec: TVlist);
begin
  derefObjet(typeUO(paraHis));
  paraHis:=vec;
  refObjet(paraHis);
end;

procedure Toptimizer.processMessage(id: integer; source: typeUO;p: pointer);
begin
  inherited;

  case id of
    UOmsg_destroy:
      begin
        if (paraHis=source)  then
        begin
          paraHis:=nil;
          derefObjet(source);
        end;
      end;
  end;
end;



{ ********************************** Méthodes STM *****************************}

procedure proToptimizer_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Toptimizer);
end;

procedure proToptimizer_create_1(var pu:typeUO);
begin
  createPgObject('',pu,Toptimizer);
end;

procedure proToptimizer_loadFromFile(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  if not Toptimizer(pu).loadFromFile(st)
    then sortieErreur('Toptimizer : unable to load '+st);
end;

procedure proToptimizer_loadFromText(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  if not Toptimizer(pu).loadFromText(st)
    then sortieErreur('Toptimizer : unable to install text');
end;


function fonctionToptimizer_compile(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=Toptimizer(pu).compile;
end;

procedure proToptimizer_reset(var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).reset;
end;

procedure proToptimizer_setVector(stName:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  if not Toptimizer(pu).setVector(stName,vec)
    then sortieErreur('Toptimizer.setvector error');
end;

procedure proToptimizer_getVector(stName:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  Toptimizer(pu).getVector(stName,vec);
end;

procedure proToptimizer_setSeg(var Vseg:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(Vseg);
  Toptimizer(pu).setSeg(Vseg);
end;

procedure proToptimizer_setClamp(var clamp:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(clamp);
  if not Toptimizer(pu).setclamp(clamp)
    then sortieErreur('Toptimizer.setClamp : unable to clamp');;
end;


procedure proToptimizer_setParams(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  Toptimizer(pu).setParams(vec);
end;

procedure proToptimizer_getParams(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  Toptimizer(pu).getParams(vec);
end;

procedure proToptimizer_CalculateOutput(stName:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).CalculateOutPut(stName);
end;

procedure proToptimizer_initOpti(stOut:AnsiString;var vecOut:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecOut);
  Toptimizer(pu).initOpt(stOut,VecOut);
end;

procedure proToptimizer_Optimize(var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).Optimize;
end;


procedure proToptimizer_InitLMQN(stOut:AnsiString;var vecOut:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).initOpt(stOut,VecOut);
  Toptimizer(pu).initBmat;
end;

procedure proToptimizer_LMstep(var chi2,NormG1:float ;var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).LMstep;
  chi2:=Toptimizer(pu).chi2;
  NormG1:=Toptimizer(pu).NormG;
end;

procedure proToptimizer_QNstep(var chi2:float ;var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).QNstep;
  chi2:=Toptimizer(pu).chi2;
end;




function fonctionToptimizer_chi2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Toptimizer(pu).chi2;
end;

function fonctionToptimizer_getchi2(stName:AnsiString;var Vec:Tvector;var pu:typeUO):float;
var
  Vmat:Tvector;
  i:integer;
begin
  verifierVecteur(vec);
  verifierObjet(pu);
  with Toptimizer(pu) do
  begin
    if nbpt<>vec.Icount
      then sortieErreur('Toptimizer.getChi2 : bad number of points in vec');

    Vmat:=Tvector.create32(g_double,1,nbpt);
    try
    with Vmat do
    for i:=1 to ICount do Yvalue[i]:=vec.Yvalue[vec.Istart+i-1];

    result:=getChi2(stName,Vmat);
    finally
    Vmat.free;
    end;
  end;
end;


procedure proToptimizer_maxIt(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if n<1 then sortieErreur('Toptimizer : MaxIt must be >0');
  Toptimizer(pu).cntMax:=n;
end;

function fonctionToptimizer_maxIt(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Toptimizer(pu).cntMax;
end;

procedure proToptimizer_setFilterParam(name:AnsiString;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).setFilterParam(name,w);
end;

procedure proToptimizer_setFilterParams(name:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  Toptimizer(pu).setFilterParams(name,vec);
end;


function fonctionToptimizer_getFilterParam(name:AnsiString;var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Toptimizer(pu).getFilterParam(name);
end;

procedure proToptimizer_getFilterParams(name:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteurTemp(vec);
  Toptimizer(pu).getFilterParams(name,vec);
end;

procedure proToptimizer_Ngrad(N:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if n<0 then sortieErreur('Toptimizer.Ngrad must be positive');
  Toptimizer(pu).ModHis:=N;
end;

function fonctionToptimizer_Ngrad(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Toptimizer(pu).ModHis;
end;



procedure proToptimizer_setFilterBounds(name:AnsiString;var vecMin,vecMax:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecMin);
  verifierVecteur(vecMax);

  if (vecMin.Istart<>vecMax.Istart) or (vecMin.Iend<>vecMax.Iend)
    then sortieErreur('Toptimizer.setFilterBounds : vectors must have the same bounds');
  Toptimizer(pu).setFilterBounds(name,vecMin,vecMax);
end;

procedure proToptimizer_setFilterBounds_1(name:AnsiString; Vmin,Vmax:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Toptimizer(pu).setFilterBounds(name,VMin,VMax);
end;


procedure proToptimizer_setFilterConsts(name:AnsiString;var vecCte:Tvector;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  verifierVecteur(vecCte);

  Toptimizer(pu).setFilterConsts(name,vecCte);
end;


procedure proToptimizer_getFilterBounds(name:AnsiString;var vecMin,vecMax:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecMin);
  verifierVecteur(vecMax);

  Toptimizer(pu).getFilterBounds(name,vecMin,vecMax);
end;

procedure proToptimizer_setBounds(var vecMin,vecMax:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecMin);
  verifierVecteur(vecMax);

  if (vecMin.Istart<>vecMax.Istart) or (vecMin.Iend<>vecMax.Iend)
    then sortieErreur('Toptimizer.setFilterBounds : vectors must have the same bounds');
  Toptimizer(pu).setBounds(vecMin,vecMax);
end;

procedure proToptimizer_getBounds(var vecMin,vecMax:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecMin);
  verifierVecteur(vecMax);

  Toptimizer(pu).getBounds(vecMin,vecMax);
end;

procedure proToptimizer_getFilterAux(name: AnsiString; numVec,NumOcc:integer;var vec: Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);

  Toptimizer(pu).getFilterAux(name,numVec,NumOcc,vec);
end;

procedure proToptimizer_setFilterClamp(name:AnsiString;w:float;var pu:typeUO);
begin
  verifierObjet(pu);

  if  not Toptimizer(pu).setFilterClamp(name,w,1)
    then sortieErreur('Toptimizer.setFilterClamp : unable to clamp '+name);
end;

procedure proToptimizer_setFilterClamp_1(name:AnsiString;w:float;num:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if  not Toptimizer(pu).setFilterClamp(name,w,num)
    then sortieErreur('Toptimizer.setFilterClamp : unable to clamp '+name);
end;


procedure proToptimizer_setFilterClamp_2(name:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);

  if  not Toptimizer(pu).setFilterClamp(name,vec)
    then sortieErreur('Toptimizer.setFilterClamp : unable to clamp '+name);
end;


procedure proInitINTELlib;
begin
  freeMKL;
  freeIPPS;

  initMKLib;
  initIPPS;
end;

procedure proToptimizer_setHistoryList(var vec:TVlist;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));

  Toptimizer(pu).setHistoryList(vec);
end;




end.
