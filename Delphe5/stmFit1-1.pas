unit stmFit1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,Dcurfit0,Darbre1,Dtrace1, debug0,
     Ncdef2,varconf1,
     stmDef,stmObj,stmVec1,stmfunc1,
     stmError,stmPg;



type
  TfitInfo=record
             FitX,FitY,FitSigma:Tvector;  {vecteurs sources }
             xbid,x1FTR,x2FTR:float;      {origine et limites du fit }
             FitParaCl:typeParaClamp;     {array[1..maxPara] of boolean;}
                                          {paramètres de clamp}
             BidNbptMax:smallint;         {remplacé par FitNbptMax}
             FitMode:smallint;            {mode de pondération}
             FitSeuil:smallint;           {seuil de sortie de l'itération}
             maxIT:smallint;              {nombre d'itérations max }
             initialize:boolean;          {appeler la procédure d'init pour les
                                           fonctions standard}
             Fdisplay:boolean;

             I1Ftr,I2FTR:integer;
             useIndices:boolean;
             FitNbptMax:integer;          {nb points max à traiter}

             y1FTR,y2FTR:float;
            end;

type
  {maxPara=20 dans Dcurfit0}
  tabPtElem=array[1..maxPara] of ptelem;
  typeNumPar=array[1..maxPara] of integer;



type
  TFit=class(Tfunction)
       private
                                 { Pour un modèle utilisateur: }
         U1:tabPtelem;           { arbres des dérivées partielles }

         NumPar:typeNumPar;      { Numpar[i] donne la position dans valeur du
                                   paramètre de fit de numéro i
                                   Comme on peut clamper certains paramètres,
                                   les paramètres de arbre0 ne correspondent pas
                                   aux paramètres de fit }

         pxFTR:PtabFloat1;       { tableaux utilisés par curfit}
         pyFTR:PtabFloat1;
         pzFTR:PtabFloat1;

         FitAux1:pointer;
         FitAux2:pointer;



         FitNbpt:integer;           {nb de points traités }

         sqX,sqY,sqXY,meanX,meanY,residualVariance:float;

       public

         FitXb,FitYb,FitSigmab:Tvector;  {id pour sauvegarde }

         fitInfo:TfitInfo;

         FitSigmaA:typePara;          {array[1..maxPara] of float;}
                                      {en sortie, incertitudes sur para}
         NbParaFit:integer;           { Nombre de paramètres de fit<>nb param
                                        de arbre0 }
         FitChiSqr:float;             {dernier Chi2 calculé}
         FitReg,fitRegSeb:float;      {dernier coeff de régression calculé}

         constructor create;override;
         destructor destroy;override;
         class function STMClassName:AnsiString;override;
         procedure freeRef;override;

         procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
           override;
         procedure RetablirReferences(list:Tlist);override;
         procedure proprietes(sender:Tobject);override;
         procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;
         procedure clearReferences;override;


         procedure reset;

         procedure setXdata(v:Tvector);
         procedure setYdata(v:Tvector);
         procedure setSigdata(v:Tvector);

         procedure permut(i,j:integer);
         procedure trierPara;

         procedure AllouerFit;
         procedure libererFit;
         function copyData:boolean;

         function Fit:boolean;

         procedure executeFit;
         procedure afficherFit;

         procedure CompressParam(v:float);
         function statFit:boolean;
       end;


procedure proTcurveFitting_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTcurveFitting_create_1(var pu:typeUO);pascal;

procedure proTcurveFitting_reset(var pu:typeUO);pascal;
function fonctionTcurveFitting_execute(var pu:typeUO):boolean;pascal;

procedure proTcurveFitting_initialize(v:boolean;var pu:typeUO);pascal;
function fonctionTcurveFitting_initialize(var pu:typeUO):boolean;pascal;

procedure proTcurveFitting_setXdata(var v:Tvector;var pu:typeUO);pascal;
procedure proTcurveFitting_setYdata(var v:Tvector;var pu:typeUO);pascal;
procedure proTcurveFitting_setErrorData(var v:Tvector;var pu:typeUO);pascal;


procedure proTcurveFitting_XstartFit(v:float;var pu:typeUO);pascal;
function fonctionTcurveFitting_XstartFit(var pu:typeUO):float;pascal;

procedure proTcurveFitting_XendFit(v:float;var pu:typeUO);pascal;
function fonctionTcurveFitting_XendFit(var pu:typeUO):float;pascal;

procedure proTcurveFitting_YstartFit(v:float;var pu:typeUO);pascal;
function fonctionTcurveFitting_YstartFit(var pu:typeUO):float;pascal;

procedure proTcurveFitting_YendFit(v:float;var pu:typeUO);pascal;
function fonctionTcurveFitting_YendFit(var pu:typeUO):float;pascal;

procedure proTcurveFitting_IstartFit(v:integer;var pu:typeUO);pascal;
function fonctionTcurveFitting_IstartFit(var pu:typeUO):integer;pascal;

procedure proTcurveFitting_IendFit(v:integer;var pu:typeUO);pascal;
function fonctionTcurveFitting_IendFit(var pu:typeUO):integer;pascal;


function fonctionTcurveFitting_UserModel(var pu:typeUO):boolean;pascal;

procedure proTcurveFitting_Mode(v:smallint;var pu:typeUO);pascal;
function fonctionTcurveFitting_Mode(var pu:typeUO):smallint;pascal;

procedure proTcurveFitting_MaxData(v:integer;var pu:typeUO);pascal;
function fonctionTcurveFitting_MaxData(var pu:typeUO):integer;pascal;

function fonctionTcurveFitting_DataCount(var pu:typeUO):integer;pascal;

procedure proTcurveFitting_Clamp(st:AnsiString;v:boolean;var pu:typeUO);pascal;
function fonctionTcurveFitting_clamp(st:AnsiString;var pu:typeUO):boolean;pascal;

procedure proTcurveFitting_MaxIT(v:integer;var pu:typeUO);pascal;
function fonctionTcurveFitting_maxIT(var pu:typeUO):integer;pascal;

procedure proTcurveFitting_Threshold(v:integer;var pu:typeUO);pascal;
function fonctionTcurveFitting_Threshold(var pu:typeUO):integer;pascal;

function fonctionTcurveFitting_FitReg(var pu:typeUO):float;pascal;
procedure proTcurveFitting_CompressParam(v:float;var pu:typeUO);pascal;

function fonctionTcurveFitting_FitReg2(var pu:typeUO):float;pascal;


function fonctionTcurveFitting_SXX(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_SYY(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_SXY(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_MeanX(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_MeanY(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_ResidualVariance(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_Chi2(var pu:typeUO):float;pascal;
function fonctionTcurveFitting_ParamSig(st:AnsiString;var pu:typeUO):float;pascal;

IMPLEMENTATION

uses fitprop;

var
  E_fit:integer;
  E_paramName:integer;
  E_model:integer;
  E_mode:integer;
  E_maxdata:integer;



constructor Tfit.create;
begin
  inherited create;

  reset;
end;

procedure Tfit.reset;
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitX));
    derefObjet(typeUO(fitY));
    derefObjet(typeUO(fitSigma));
    FitX:=nil;
    FitY:=nil;
    FitSigma:=nil;

    FitMode:=1;
    FitSeuil:=12;
    maxIT:=10000;
    bidNbptMax:=100;
    FitNbptMax:=1000000;
    initialize:=true;
  end;
end;

procedure Tfit.setXdata(v:Tvector);
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitX));
    fitX:=v;
    refObjet(fitX);
  end;
end;

procedure Tfit.setYdata(v:Tvector);
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitY));
    fitY:=v;
    refObjet(fitY);
  end;
end;

procedure Tfit.setSigdata(v:Tvector);
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitSigma));
    fitSigma:=v;
    refObjet(fitSigma);
  end;
end;


destructor Tfit.destroy;
begin
  reset;
  inherited destroy;
end;

procedure Tfit.freeRef;
begin
  inherited;
  reset;
end;

class function Tfit.STMClassName:AnsiString;
begin
  STMClassName:='CurveFitting';
end;

procedure Tfit.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited ;

  with fitInfo do
  begin
    if lecture then
      begin
        conf.setvarConf('fitX',fitXb,sizeof(fitX));
        conf.setvarConf('fitY',fitYb,sizeof(fitY));
        conf.setvarConf('fitSigma',fitSigmab,sizeof(fitSigma));
      end
    else
      begin
        conf.setvarConf('fitX',fitX,sizeof(fitX));
        conf.setvarConf('fitY',fitY,sizeof(fitY));
        conf.setvarConf('fitSigma',fitSigma,sizeof(fitSigma));
      end;

    with conf do setvarconf('FitInfo',fitInfo ,sizeof(fitInfo ));
    {les vecteurs sont sauvés 2 fois. Au chargement, fitInfo contient des
    références fausses. Il faut les mettre à nil dans retablirReferences}
  end;
end;

procedure Tfit.RetablirReferences(list:Tlist);
var
  i:integer;
  p:typeUO;
begin
  fitInfo.fitX:=nil;
  fitInfo.fitY:=nil;
  fitInfo.fitSigma:=nil;

  with fitInfo do
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=fitXb then
       begin
         fitX:=list.items[i];
         refObjet(fitX);
       end;
     if p=fitYb then
       begin
         fitY:=list.items[i];
         refObjet(fitY);
       end;
     if p=fitSigmab then
       begin
         fitSigma:=list.items[i];
         refObjet(fitSigma);
       end;
    end;
end;

procedure Tfit.proprietes(sender:Tobject);
begin
  fitProp1.caption:=ident+' properties';

  fitProp1.execution(self);
end;

procedure Tfit.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      with fitInfo do
      begin
        if (fitX=source) or (fitY=source) or (fitSigma=source) then
          begin
            if fitX=source then
              begin
                derefObjet(source);
                fitX:=nil;
              end;
            if fitY=source then
              begin
                derefObjet(source);
                fitY:=nil;
              end;
            if fitSigma=source then
              begin
                derefObjet(source);
                fitSigma:=nil;
              end;
          end;
      end;


  end;
end;



var
  actualFit:Tfit;

function F0fit(z:float;var pw):float;
  var
    i:integer;
    p:typePara absolute pw;
  begin
    with actualFit do
    begin
      valeur[numvar-1]:=z;
      for i:=1 to nbparaFit do valeur[NumPar[i]-1]:=p[i];
      F0fit:=evaluer(U0,valeur);
    end;
  end;

function F0fitPG(z:float;var pw):float;
  var
    i:integer;
    p:typePara absolute pw;
  begin
    with actualFit do
    begin
      valeur[numvar-1]:=z;
      for i:=1 to nbparaFit do valeur[NumPar[i]-1]:=p[i];
      result:=evaluate;
    end;
  end;


Procedure Derivee0fit(var z:float;var pw;
                      var Cl:typeParaClamp;var deriv:typePara);
  var
    i:integer;
    p:typePara absolute pw;
  begin
    with actualFit do
    begin
      valeur[numvar-1]:=z;
      for i:=1 to nbparaFit do valeur[NumPar[i]-1]:=p[i];
      for i:=1 to nbParafit do deriv[i]:=evaluer(U1[i],valeur);
    end;
  end;


procedure Tfit.permut(i,j:integer);
var
  x:float;
begin
  x:=valeur[i];
  valeur[i]:=valeur[j];
  valeur[j]:=x;
end;

procedure Tfit.trierPara;
var
  Md:integer;

begin
  if numModel in [21..26]
    then Md:=numModel-20
    else Md:=numModel;

  if (Md=2) or (Md=3) or
     (Md=5) or (Md=6) then
    begin
      if valeur[2]>valeur[4] then
        begin
          permut(2,4);
          permut(1,3);
        end;
    end;
  if (Md=3) or (Md=6) then
    begin
      if valeur[4]>valeur[6] then
        begin
          permut(4,6);
          permut(3,5);
        end;
      if valeur[2]>valeur[4] then
        begin
          permut(2,4);
          permut(1,3);
        end;
    end;
end;

procedure Tfit.AllouerFit;
var
  ok:boolean;
  tailleFTR:integer;
begin
  tailleFTR:=FitNbpt*sizeof(float);

  try
  ok:=false;

  getmem(pxFTR,tailleFTR);
  getmem(pyFTR,tailleFTR);
  if assigned(fitInfo.fitSigma) then getmem(pzFTR,tailleFTR);
  getmem(fitAux1,tailleFTR);
  getmem(fitAux2,tailleFTR);
  ok:=true;

  finally
  if not ok then libererFit;
  end;
end;

procedure Tfit.libererFit;
begin
  if assigned(pxFTR) then freemem(pxFTR);
  if assigned(pyFTR) then freemem(pyFTR);
  if assigned(pzFTR) then freemem(pzFTR);
  if assigned(fitAux1) then freemem(fitAux1);
  if assigned(fitAux2) then freemem(fitAux2);

  pxFTR:=nil;
  pyFTR:=nil;
  pzFTR:=nil;
  fitAux1:=nil;
  fitAux2:=nil;
end;

(*
function Tfit.copyData:boolean;
var
  i,j:longint;
  i1,i2:integer;
  pas:float;
  x,xj:float;

procedure cadrer(t:Tvector;var i:integer);
    begin
      if i<t.Istart then i:=t.Istart
      else
      if i>t.Iend then i:=t.Iend;
    end;

begin
  copydata:=false;
  with fitInfo do
  begin
    if not assigned(fitY) then exit;

    if useIndices then
      begin
        i1:=I1FTR;
        i2:=I2FTR;
        if assigned(fitX) then
          begin
            cadrer(FitX,i1);
            cadrer(FitX,i2);
          end;
      end
    else
      begin
        if not assigned(fitX) then
          begin
            i1:=fitY.invconvx(x1FTR);
            i2:=fitY.invconvx(x2FTR);
          end
        else
          begin
            i1:=fitX.Istart;
            i2:=fitX.Iend;
          end;
      end;

    cadrer(FitY,i1);
    cadrer(FitY,i2);

    FitNbpt:=FitNbptMax;
    if FitNbpt>i2-i1+1 then FitNbpt:=i2-i1+1;
    if FitNbpt<=1 then exit;

    pas:=(i2-i1)/(FitNbpt-1);
    allouerFit;


    xj:=i1;
    i:=1;
    repeat
      j:=roundL(xj);
      if assigned(fitX) then
        begin
          x:=FitX.data.getE(j);
          if useIndices or (x>=X1FTR) and (x<=X2FTR) then
            begin
              pxFTR^[i]:=x-xOrg;
              pyFTR^[i]:=FitY.data.getE(j);
              if assigned(FitSigma) then
                pzFTR^[i]:=FitSigma.data.getE(j);
              inc(i);
            end;
          end
      else
        begin
          pxFTR^[i]:=FitY.data.convx(j)-xorg;
          pyFTR^[i]:=FitY.data.getE(j);

          if assigned(FitSigma) then
            pzFTR^[i]:=FitSigma.data.getE(j);
          inc(i);
        end;
      xj:=xj+pas;

    until (i>FitNbpt) or (xj>i2);

    FitNbpt:=i-1;

    copyData:=true;
  end;
end;
*)

function Tfit.copyData:boolean;
var
  i,j,nb:integer;
  i1,i2:integer;
  pas:float;
  x,y:float;
  tabX,tabY,tabZ:array of float;
  FlimY:boolean;

procedure cadrer(t:Tvector;var i:integer);
    begin
      if i<t.Istart then i:=t.Istart
      else
      if i>t.Iend then i:=t.Iend;
    end;

begin
  copydata:=false;


  with fitInfo do
  begin
    FlimY:=Y2FTR>Y1FTR;
    if not assigned(fitY) then exit;

    if useIndices then
      begin
        i1:=I1FTR;
        i2:=I2FTR;
        if assigned(fitX) then
          begin
            cadrer(FitX,i1);
            cadrer(FitX,i2);
          end;
      end
    else
      begin
        if not assigned(fitX) then
          begin
            i1:=fitY.invconvx(x1FTR);
            i2:=fitY.invconvx(x2FTR);
          end
        else
          begin
            i1:=fitX.Istart;
            i2:=fitX.Iend;
          end;
      end;

    cadrer(FitY,i1);
    cadrer(FitY,i2);

    if i2<=i1 then exit;

    setLength(tabX,i2-i1+1);
    setLength(tabY,i2-i1+1);
    setLength(tabZ,i2-i1+1);

    nb:=0;
    for i:=i1 to i2 do
    begin
      y:=FitY.data.getE(i);
      if assigned(fitX) then
        begin
          x:=FitX.data.getE(i);
          if (useIndices or (x>=X1FTR) and (x<=X2FTR)) and (not FlimY or (y>=Y1FTR) and (y<=Y2FTR)) then
            begin
              tabX[nb]:=x-xOrg;
              tabY[nb]:=y;
              if assigned(FitSigma) then
                tabZ[nb]:=FitSigma.data.getE(i);
              inc(nb);
            end;
        end
      else
      if not FlimY or (y>=Y1FTR) and (y<=Y2FTR) then
        begin
          tabX[nb]:=FitY.data.convx(i)-xorg;
          tabY[nb]:=y;

          if assigned(FitSigma) then
            tabZ[nb]:=FitSigma.data.getE(i);
          inc(nb);
        end;
    end;

    FitNbpt:=FitNbptMax;
    if FitNbpt>nb then FitNbpt:=nb;
    if FitNbpt<=1 then exit;

    pas:=(nb-1)/(FitNbpt-1);
    allouerFit;


    i:=0;
    j:=0;
    x:=0;
    repeat
      if assigned(pxFTR) then pxFTR^[i+1]:=tabX[j];
      if assigned(pyFTR) then pyFTR^[i+1]:=tabY[j];
      if assigned(pzFTR) then pzFTR^[i+1]:=tabZ[j];
      x:=x+pas;
      j:=trunc(x);
      inc(i);
    until j>=nb;

    FitNbpt:=i;

    copyData:=true;
  end;
end;


function Tfit.fit:boolean;
  var
    paraFit:typePara;
    seuilR:float;
    i:integer;

  function FitU:boolean;
    var
      i:integer;
      paraClFit:typeParaClamp;

    begin
      with fitInfo do
      begin
        nbParaFit:=0;
        for i:=1 to nbvar do
          if (i<>numvar) and not FitparaCl[i] then
            begin
              inc(nbparaFit);
              numPar[nbparaFit]:=i;
              paraFit[nbParaFit]:=valeur[i-1];
            end;
        for i:=1 to nbparaFit do
          begin
            detruireArbre(U1[i]);
            U1[i]:=derivee(U0,numpar[i]);
          end;

        fillchar(paraClfit,sizeof(paraClfit),0);

        result:=curfit(pxFTR^,pyFTR^,
                       FitAux1^,FitAux2^,pzFTR^,
                       FitSigmaA,
                       ParaFit,
                       ParaClFit,
                       FitChiSqr,
                       FitReg,FitRegSeb,
                       FitNbpt,
                       nbParaFit,
                       F0fit,
                       derivee0Fit,
                       FitMode,
                       seuilR,
                       AfficherFit);

        for i:=1 to nbparaFit do detruireArbre(U1[i]);
        for i:=1 to NbParaFit do valeur[numpar[i]-1]:=paraFit[i];
      end;
    end;

  function FitUPG:boolean;
    var
      i:integer;
      paraClFit:typeParaClamp;

    begin
      with fitInfo do
      begin
        nbParaFit:=0;
        for i:=1 to nbvar do
          if (i<>numvar) and not FitparaCl[i] then
            begin
              inc(nbparaFit);
              numPar[nbparaFit]:=i;
              paraFit[nbParaFit]:=valeur[i-1];
            end;
        fillchar(paraClfit,sizeof(paraClfit),0);

        result:=curfit(pxFTR^,pyFTR^,
                       FitAux1^,FitAux2^,pzFTR^,
                       FitSigmaA,
                       ParaFit,
                       ParaClFit,
                       FitChiSqr,
                       FitReg,FitRegSeb,
                       FitNbpt,
                       nbParaFit,
                       F0fitPG,
                       nil,             {derivee0Fit}
                       FitMode,
                       seuilR,
                       AfficherFit);

        for i:=1 to NbParaFit do valeur[numpar[i]-1]:=paraFit[i];
      end;
    end;


begin
  with fitInfo do
  begin
    result:=false;
    actualFit:=self;

    seuilR:=1;
    for i:=1 to FitSeuil do seuilR:=seuilR*10;

    if not assigned(fitY) then exit;

    if not copyData then exit;{copyData appelle AllouerFit}

    setFitCntMax(maxIT);

    if FpgFunc
      then result:=FitUpg
    else
    if numModel>0 then
      with modeleFit(numModel)^ do
      begin
        nbvar:=n+1;
        if initialize then
          initF(pxFTR^,pyFTR^,valeur[1],FitNbpt,n);


        result:=curfit(pxFTR^,pyFTR^,
                       FitAux1^,FitAux2^,pzFTR^,
                       FitSigmaA,
                       valeur[1],
                       FitParaCl[2],
                       FitChiSqr,
                       FitReg,FitRegSeb,
                       FitNbpt,
                       n,
                       f,
                       d,
                       FitMode,
                       seuilR,
                       afficherFit);

      end
      else result:=fitU;

      if result then result:=statFit;
      libererFit;

      if result and (numModel>0) and (numModel in [2,3,5,6,22,23,25,26])
        then trierPara;

  end;
end;

function Tfit.StatFit:boolean;
var
  i:integer;
  delta:float;
  sx,sy,sx2,sy2,sxy:float;
begin
  try
    sx:=0;sy:=0;sxy:=0;sx2:=0;sy2:=0;
    for i:=1 to FitNbPt do
      begin
        sx:=sx+pxFTR^[i];
        sy:=sy+pyFTR^[i];
        sxy:=sxy+pxFTR^[i]*pyFTR^[i];
        sx2:=sx2+sqr(pxFTR^[i]);
        sy2:=sy2+sqr(pyFTR^[i]);
      end;

    sqX:=sx2-sqr(sx)/FitNbpt;
    sqY:=sy2-sqr(sy)/FitNbpt;
    sqXY:=sxy-sx*sy/FitNbpt;
    MeanX:=sx/FitNbPt;
    MeanY:=sy/FitNbPt;

    if fitNbpt>2 then residualVariance:=1/(FitNbpt-2)*(sqY-sqr(sqXY)/sqX);
    result:=true;
  except
    result:=false;
  end;
end;

procedure Tfit.executeFit;
begin
  if fit then invalidate;
end;

procedure Tfit.afficherFit;
begin
  if fitInfo.Fdisplay then
    begin
      invalidate;
      updateAff;
    end;
end;



function proche(x,y,v:float):boolean;
  var
    d:float;
  begin
    d:=abs(x*v);
    proche:=(y>x-d) and (y<x+d);
  end;

procedure Tfit.CompressParam(v:float);
 const
   Vnul=1E100;
 var
    Md:integer;
  begin
    if numModel in [21..26]
      then Md:=numModel-20
      else Md:=numModel;

    if not (Md in [2,3,5,6]) then exit;

    if proche(valeur[2],valeur[4],v) then
      begin
        valeur[1]:=valeur[1]+valeur[3];
        valeur[3]:=0;
        if numModel>20 then valeur[4]:=Vnul else valeur[4]:=0;
      end;

    if (Md in [3,6]) then
      begin
        if proche(valeur[4],valeur[6],v) then
          begin
            valeur[3]:=valeur[3]+valeur[5];
            valeur[5]:=0;
            if numModel>20 then valeur[6]:=Vnul else valeur[6]:=0;
          end;

        if valeur[3]=0 then
          begin
            permut(3,5);
            permut(4,6);
          end;

        if proche(valeur[2],valeur[4],v) then
          begin
            valeur[1]:=valeur[1]+valeur[3];
            valeur[3]:=0;
            if numModel>20 then valeur[4]:=Vnul else valeur[4]:=0;
          end;
      end;
  end;

procedure TFit.clearReferences;
begin
  fitInfo.fitX:=nil;
  fitInfo.fitY:=nil;
  fitInfo.fitSigma:=nil;

end;


{************************ Méthodes STM de Tfit *******************************}

procedure proTcurveFitting_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TFit);
  with Tfit(pu) do title:=ident;
end;

procedure proTcurveFitting_create_1(var pu:typeUO);
begin
  proTcurveFitting_create('', pu);
end;

procedure proTcurveFitting_reset(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu) do
  begin
    reset;
  end;
end;

function fonctionTcurveFitting_execute(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tfit(pu) do
  begin
    result:=fit;
  end;
end;

procedure proTcurveFitting_initialize(v:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    initialize:=v;
  end;
end;

function fonctionTcurveFitting_initialize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_initialize:=initialize;
  end;
end;

procedure proTcurveFitting_setXdata(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  Tfit(pu).setXdata(v);
end;

procedure proTcurveFitting_setYdata(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  Tfit(pu).setYdata(v);
end;

procedure proTcurveFitting_setErrorData(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  Tfit(pu).setSigdata(v);
end;




procedure proTcurveFitting_XstartFit(v:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    useIndices:=false;
    X1FTR:=v;
  end;
end;

function fonctionTcurveFitting_XstartFit(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_XstartFit:=X1FTR;
  end;
end;

procedure proTcurveFitting_XendFit(v:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    useIndices:=false;
    X2FTR:=v;
  end;
end;

function fonctionTcurveFitting_XendFit(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_XendFit:=X2FTR;
  end;
end;

procedure proTcurveFitting_YstartFit(v:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    Y1FTR:=v;
  end;
end;

function fonctionTcurveFitting_YstartFit(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    result:=Y1FTR;
  end;
end;

procedure proTcurveFitting_YendFit(v:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    Y2FTR:=v;
  end;
end;

function fonctionTcurveFitting_YendFit(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    result:=Y2FTR;
  end;
end;


procedure proTcurveFitting_IstartFit(v:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    I1FTR:=v;
    useIndices:=true;
  end;
end;

function fonctionTcurveFitting_IstartFit(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_IstartFit:=I1FTR;
  end;
end;

procedure proTcurveFitting_IendFit(v:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    useIndices:=true;
    I2FTR:=v;
  end;
end;

function fonctionTcurveFitting_IendFit(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_IendFit:=I2FTR;
  end;
end;


function fonctionTcurveFitting_UserModel(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_UserModel:=(numModel>0);
  end;
end;



procedure proTcurveFitting_Mode(v:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    if (v<1) or (v>9) then sortieErreur(E_mode);
    Fitmode:=v;
  end;
end;


function fonctionTcurveFitting_Mode(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_Mode:=Fitmode;
  end;
end;


procedure proTcurveFitting_MaxData(v:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (v<1) then sortieErreur(E_maxData);
  with Tfit(pu),fitInfo do
  begin
    FitNbptMax:=v;
  end;
end;

function fonctionTcurveFitting_MaxData(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_MaxData:=FitNbptMax;
  end;
end;

function fonctionTcurveFitting_DataCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    fonctionTcurveFitting_DataCount:=FitNbpt;
  end;
end;

procedure proTcurveFitting_Clamp(st:AnsiString;v:boolean;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    i:=ParamIndex(st);
    if i=0 then sortieErreur(E_paramName);
    FitParaCl[i]:=v;
  end;
end;

function fonctionTcurveFitting_clamp(st:AnsiString;var pu:typeUO):boolean;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    i:=ParamIndex(st);
    if i=0 then sortieErreur(E_paramName);
    fonctionTcurveFitting_clamp:=FitParaCl[i];
  end;
end;

function fonctionTcurveFitting_FitReg(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfit(pu) do
    fonctionTcurveFitting_FitReg:=FitReg;
end;

function fonctionTcurveFitting_FitReg2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tfit(pu) do
    result:=FitRegSeb;
end;

procedure proTcurveFitting_MaxIT(v:integer;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    if v>0 then maxIT:=v;
  end;
end;

function fonctionTcurveFitting_maxIT(var pu:typeUO):integer;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    result:=maxIT;
  end;
end;

procedure proTcurveFitting_Threshold(v:integer;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    if v>0 then FitSeuil:=v;
  end;
end;

function fonctionTcurveFitting_Threshold(var pu:typeUO):integer;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tfit(pu),fitInfo do
  begin
    result:=FitSeuil;
  end;
end;

procedure proTcurveFitting_CompressParam(v:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tfit(pu).compressParam(v);
end;


function fonctionTcurveFitting_SXX(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).sqX;
end;

function fonctionTcurveFitting_SYY(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).sqY;
end;

function fonctionTcurveFitting_SXY(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).sqXY;
end;

function fonctionTcurveFitting_MeanX(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).MeanX;
end;

function fonctionTcurveFitting_MeanY(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).MeanY;
end;

function fonctionTcurveFitting_ResidualVariance(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).ResidualVariance;
end;

function fonctionTcurveFitting_Chi2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tfit(pu).FitChiSqr;
end;

function fonctionTcurveFitting_ParamSig(st:AnsiString;var pu:typeUO):float;
var
  i:integer;
begin
  verifierObjet(pu);
  with TFit(pu),fitInfo do
  begin
    i:=ParamIndex(st);
    if i=0 then sortieErreur(E_paramName);
    result:=FitsigmaA[i];
  end;
end;




Initialization
AffDebug('Initialization stmFit1',0);

installError(E_fit  ,'TcurveFitting.execute error');
installError(E_paramName ,'TcurveFitting: unknown param name');
installError(E_model ,'TcurveFitting: invalid model number ');
installError( E_mode ,'TcurveFitting: invalid weighting mode');
installError(E_maxdata ,'TcurveFitting: maxData error ');

registerObject(Tfit,data);

end.
