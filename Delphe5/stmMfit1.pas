unit stmMfit1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,Dcur2fit,Darbre0,Dtrace1,
     Ncdef2,varconf1,
     stmDef,stmObj,stmMat1,stmMf1,

     stmError,stmPg,
     debug0;


type
  {maxPara=20 dans Dcurfit0}
  tabPtElem=array[1..maxPara] of ptelem;
  typeNumPar=array[1..maxPara] of integer;

  TmatfitInfo=record
             FitM,FitSigma:Tmatrix;       {matrice source et matrice Error}
             FitParaCl:array[1..20] of boolean;
                                          {paramètres de clamp}
             FitMode:smallint;            {mode de pondération}
             FitSeuil:smallint;           {seuil de sortie de l'itération}
             maxIT:smallint;              {nombre d'itérations max }
             initialize:boolean;          {appeler la procédure d'init pour les
                                           fonctions standard}
             Fdisplay:boolean;
             UseSelect:boolean;
            end;



type
  TmatFit=class(TmatFunction)
         private
                                 { Pour un modèle utilisateur: }
         U1:tabPtelem;           { arbres des dérivées partielles }

         NumPar:typeNumPar;      { Numpar[i] donne la position dans valeur du
                                   paramètre de fit de numéro i
                                   Comme on peut clamper certains paramètres,
                                   les paramètres de arbre0 ne correspondent pas
                                   aux paramètres de fit }

         pxFTR:PtabDoublet1;     { tableaux utilisés par curfit}
         pyFTR:PtabFloat1;
         pzFTR:PtabFloat1;

         FitAux1:PtabFloat1;
         FitAux2:PtabFloat1;

         tailleFTR:integer;

         FitNbpt:integer;           {nb de points traités }

         sqX,sqY,sqXY,meanX,meanY,residualVariance:float;

         function F0fit(z:Tdoublet;para:ptabFloat1):float;
         function F0fitPG(z:Tdoublet;para:ptabFloat1):float;
         Procedure Derivee0fit(var z:Tdoublet;para:ptabFloat1;
                   Cl:PtabBoolean1;deriv:ptabFloat1);


         public

         FitMb,FitSigmab:Tmatrix;    {id pour sauvegarde }

         fitInfo:TmatfitInfo;

         FitSigmaA:array[1..20] of float;
                                      {en sortie, incertitudes sur para}
         NbParaFit:integer;           { Nombre de paramètres de fit<>nb param
                                        de arbre0 }
         FitChiSqr:float;             {dernier Chi2 calculé}
         FitReg:float;                {dernier coeff de régression calculé}

         constructor create;override;
         destructor destroy;override;
         class function STMClassName:AnsiString;override;
         procedure freeRef;override;

         procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
           override;
         procedure RetablirReferences(list:Tlist);override;
         procedure ClearReferences;override;

         procedure proprietes(sender:Tobject);override;
         procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;


         procedure reset;

         procedure setdata(m:Tmatrix);
         procedure setErrordata(m:Tmatrix);

         procedure AllouerFit;
         procedure libererFit;
         function copyData:boolean;

         function Fit:boolean;

         procedure executeFit;
         function getChi2:float;
         procedure afficherFit;

         procedure statFit;
       end;


procedure proTmatFitting_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTmatFitting_create_1(var pu:typeUO);pascal;

procedure proTmatFitting_reset(var pu:typeUO);pascal;
procedure proTmatFitting_execute(var pu:typeUO);pascal;

procedure proTmatFitting_initialize(v:boolean;var pu:typeUO);pascal;
function fonctionTmatFitting_initialize(var pu:typeUO):boolean;pascal;

procedure proTmatFitting_setdata(var m:Tmatrix;var pu:typeUO);pascal;
procedure proTmatFitting_setErrordata(var m:Tmatrix;var pu:typeUO);pascal;

function fonctionTmatFitting_UserModel(var pu:typeUO):boolean;pascal;

procedure proTmatFitting_Mode(v:smallint;var pu:typeUO);pascal;
function fonctionTmatFitting_Mode(var pu:typeUO):smallint;pascal;

procedure proTmatFitting_Clamp(st:AnsiString;v:boolean;var pu:typeUO);pascal;
function fonctionTmatFitting_clamp(st:AnsiString;var pu:typeUO):boolean;pascal;

procedure proTmatFitting_MaxIT(v:integer;var pu:typeUO);pascal;
function fonctionTmatFitting_maxIT(var pu:typeUO):integer;pascal;

procedure proTmatFitting_Threshold(v:integer;var pu:typeUO);pascal;
function fonctionTmatFitting_Threshold(var pu:typeUO):integer;pascal;

function fonctionTmatFitting_FitReg(var pu:typeUO):float;pascal;

procedure proTmatFitting_UseSelection(v:boolean;var pu:typeUO);pascal;
function fonctionTmatFitting_UseSelection(var pu:typeUO):boolean;pascal;

function fonctionTmatFitting_ParamSig(st:AnsiString;var pu:typeUO):float;pascal;

IMPLEMENTATION

uses MfitProp;

var
  E_fit:integer;
  E_paramName:integer;
  E_model:integer;
  E_mode:integer;
  E_maxdata:integer;



procedure TmatFit.reset;
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitM));
    derefObjet(typeUO(fitSigma));
    FitM:=nil;
    FitSigma:=nil;

    FitMode:=1;
    FitSeuil:=12;
    maxIT:=10000;
    initialize:=true;
    UseSelect:=false;
  end;
end;

constructor TmatFit.create;
begin
  inherited create;

  reset;
end;


destructor TmatFit.destroy;
begin
  reset;
  inherited destroy;
end;

procedure TmatFit.freeRef;
begin
  inherited;
  reset;
end;

procedure TmatFit.setdata(m:Tmatrix);
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitM));
    fitM:=m;
    refObjet(fitM);
  end;
end;

procedure TmatFit.setErrordata(m:Tmatrix);
begin
  with fitInfo do
  begin
    derefObjet(typeUO(fitSigma));
    fitSigma:=m;
    refObjet(fitSigma);
  end;
end;




class function TmatFit.STMClassName:AnsiString;
begin
  STMClassName:='MatFitting';
end;

procedure TmatFit.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited ;

  with fitInfo do
  begin
    if lecture then
      begin
        conf.setvarConf('fitM',fitMb,sizeof(fitM));
        conf.setvarConf('fitSigma',fitSigmab,sizeof(fitSigma));
      end
    else
      begin
        conf.setvarConf('fitM',fitM,sizeof(fitM));
        conf.setvarConf('fitSigma',fitSigma,sizeof(fitSigma));
      end;

    with conf do setvarconf('FitInfo',fitInfo ,sizeof(fitInfo ));

  end;
end;

procedure TmatFit.RetablirReferences(list:Tlist);
var
  i:integer;
  p:typeUO;
begin
  fitInfo.fitM:=nil;
  fitInfo.fitSigma:=nil;

  with fitInfo do
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=fitMb then
       begin
         fitM:=list.items[i];
         refObjet(fitM);
       end;
     if p=fitSigmab then
       begin
         fitSigma:=list.items[i];
         refObjet(fitSigma);
       end;
    end;
end;

procedure TmatFit.ClearReferences;
begin
  fitInfo.fitM:=nil;
  fitInfo.fitSigma:=nil;
end;

procedure TmatFit.proprietes(sender:Tobject);
begin
  MfitProp1.caption:=ident+' properties';

  MfitProp1.execution(self);
end;

procedure TmatFit.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      with fitInfo do
      begin
        if (fitM=source) or (fitSigma=source) then
          begin
            if fitM=source then
              begin
                derefObjet(source);
                fitM:=nil;
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




function TmatFit.F0fit(z:Tdoublet;para:ptabFloat1):float;
var
  i:integer;
begin
  valeur[numvar[1]]:=z.x1;
  valeur[numvar[2]]:=z.x2;

  for i:=1 to nbparaFit do valeur[NumPar[i]]:=para[i];
  F0fit:=evaluer(U0,valeur);
end;

function TmatFit.F0fitPG(z:Tdoublet;para:ptabFloat1):float;
var
  i:integer;
begin
  valeur[numvar[1]]:=z.x1;
  valeur[numvar[2]]:=z.x2;

  for i:=1 to nbparaFit do valeur[NumPar[i]]:=para[i];

  Result:=evaluate;
end;


Procedure TmatFit.Derivee0fit(var z:Tdoublet;para:ptabFloat1;
                    Cl:pTabBoolean1;deriv:ptabFloat1);
var
  i:integer;
begin
  valeur[numvar[1]]:=z.x1;
  valeur[numvar[2]]:=z.x2;

  for i:=1 to nbparaFit do valeur[NumPar[i]]:=para[i];
  for i:=1 to nbParafit do deriv[i]:=evaluer(U1[i],valeur);
end;


procedure TmatFit.AllouerFit;
begin
  tailleFTR:=FitNbpt*sizeof(float);

  try

  getmem(pxFTR,tailleFTR*2);
  getmem(pyFTR,tailleFTR);
  if assigned(fitInfo.fitSigma) then getmem(pzFTR,tailleFTR);
  getmem(fitAux1,tailleFTR);
  getmem(fitAux2,tailleFTR);

  except
  libererFit;
  end;
end;

procedure TmatFit.libererFit;
begin
  if assigned(pxFTR) then freemem(pxFTR,tailleFTR*2);
  if assigned(pyFTR) then freemem(pyFTR,tailleFTR);
  if assigned(pzFTR) then freemem(pzFTR,tailleFTR);
  if assigned(fitAux1) then freemem(fitAux1,tailleFTR);
  if assigned(fitAux2) then freemem(fitAux2,tailleFTR);

  pxFTR:=nil;
  pyFTR:=nil;
  pzFTR:=nil;
  fitAux1:=nil;
  fitAux2:=nil;
end;

function TmatFit.copyData:boolean;
var
  i,j,k:longint;
  z:Tdoublet;

begin
  copydata:=false;
  with fitInfo do
  begin
    if not assigned(fitM) then exit;

    if not useSelect
      then FitNbpt:=(fitM.Iend-fitM.Istart+1)*(fitM.Jend-fitM.Jstart+1)
      else FitNbPt:=fitM.SelPixCount;

    allouerFit;

    k:=0;
    for i:=fitM.Istart to fitM.Iend do
      for j:=fitM.Jstart to fitM.Jend do
        if not useSelect or fitM.SelPix[i,j] then
        begin
          z.x1:=fitM.convx(i);
          z.x2:=fitM.convy(j);
          inc(k);
          pxFTR^[k]:=z;
          pyFTR^[k]:=fitM.Zvalue[i,j];
          if assigned(FitSigma) then
             pzFTR^[k]:=FitSigma.Zvalue[i,j];
        end;

    {messageCentral('k='+Istr(k));}
    copyData:=true;
  end;
end;

function TmatFit.fit:boolean;
  var
    paraFit:array[1..20] of float;
    seuilR:float;
    i:integer;

  procedure FitU;
    var
      i:integer;
      paraClFit:array[1..20] of boolean;

    begin
      with fitInfo do
      begin
        nbParaFit:=0;
        for i:=1 to nbvar do
          if (i<>numvar[1]) and (i<>numvar[2]) and not FitparaCl[i] then
            begin
              inc(nbparaFit);
              numPar[nbparaFit]:=i;
              paraFit[nbParaFit]:=valeur[i];
            end;
        for i:=1 to nbparaFit do
          begin
            detruireArbre(U1[i]);
            U1[i]:=derivee(U0,numpar[i]);
          end;

        fillchar(paraClfit,sizeof(paraClfit),0);

        fillchar(FitSigmaA,sizeof(fitSigmaA),0);

        curfit1( pxFTR,pyFTR,
                 FitAux1,FitAux2,pzFTR,
                 @FitSigmaA,
                 @ParaFit,
                 @ParaClFit,
                 FitChiSqr,
                 FitReg,
                 FitNbpt,
                 nbParaFit,
                 F0fit,
                 derivee0Fit,
                 FitMode,
                 seuilR,
                 AfficherFit);

        for i:=1 to nbparaFit do detruireArbre(U1[i]);
        for i:=1 to NbParaFit do valeur[numpar[i]]:=paraFit[i];

        for i:=NbParaFit downto 1 do FitSigmaA[numpar[i]]:=FitSigmaA[i];
      end;
    end;

  procedure FitUPG;
    var
      i:integer;
      paraClFit:array[1..20] of boolean;

    begin
      with fitInfo do
      begin
        nbParaFit:=0;
        for i:=1 to nbvar do
          if (i<>numvar[1]) and (i<>numvar[2]) and not FitparaCl[i] then
            begin
              inc(nbparaFit);
              numPar[nbparaFit]:=i;
              paraFit[nbParaFit]:=valeur[i];
            end;

        fillchar(paraClfit,sizeof(paraClfit),0);
        fillchar(FitSigmaA,sizeof(fitSigmaA),0);

        curfit1( pxFTR,pyFTR,
                 FitAux1,FitAux2,pzFTR,
                 @FitSigmaA,
                 @ParaFit,
                 @ParaClFit,
                 FitChiSqr,
                 FitReg,
                 FitNbpt,
                 nbParaFit,
                 F0fitPG,
                 nil,
                 FitMode,
                 seuilR,
                 AfficherFit);

        for i:=1 to NbParaFit do valeur[numpar[i]]:=paraFit[i];

        for i:=NbParaFit downto 1 do FitSigmaA[numpar[i]]:=FitSigmaA[i];
      end;
    end;

begin
  with fitInfo do
  begin
    fit:=false;

    seuilR:=1;
    for i:=1 to FitSeuil do seuilR:=seuilR*10;

    if not copyData then exit;{copyData appelle AllouerFit}

    setFitCntMax(maxIT);

    if FpgFunc then FitUPg
    else
    if numModel>0 then
      with modeleFit(numModel) do
      begin
        if initialize then
          init(pxFTR,pyFTR,@valeur[2],FitNbpt,nbParam);

        curfit1(pxFTR,pyFTR,
               FitAux1,FitAux2,pzFTR,
               @FitSigmaA,
               @valeur[2],
               @FitParaCl[2],
               FitChiSqr,
               FitReg,
               FitNbpt,
               nbParam,
               f,
               derivee,
               FitMode,
               seuilR,
               afficherFit);

      end
      else fitU;

      statFit;
      libererFit;

      fit:=true;
  end;
end;

procedure TmatFit.StatFit;
var
  i:integer;
  delta:float;
  sx,sy,sx2,sy2,sxy:float;
begin

end;

procedure TmatFit.executeFit;
begin
  if fit then invalidate;
end;


function TmatFit.getChi2:float;
  var
    paraFit:array[1..20] of float;
    seuilR:float;
    i:integer;

  function getU:float;
    var
      i:integer;
    begin
      with fitInfo do
      begin
        nbParaFit:=0;
        for i:=1 to nbvar do
          if (i<>numvar[1]) and (i<>numvar[2]) and not FitparaCl[i] then
            begin
              inc(nbparaFit);
              numPar[nbparaFit]:=i;
              paraFit[nbParaFit]:=valeur[i];
            end;
        for i:=1 to nbparaFit do
          begin
            detruireArbre(U1[i]);
            U1[i]:=derivee(U0,numpar[i]);
          end;

        result:=KiCarre (PxFtr,PyFtr,PzFtr,
                         @paraFit,
                         FitNbpt,
                         NbParaFit,
                         Fitmode,
                         f0fit);

        for i:=1 to nbparaFit do detruireArbre(U1[i]);
        for i:=1 to NbParaFit do valeur[numpar[i]]:=paraFit[i];
      end;
    end;

begin
  with fitInfo do
  begin
    FitChiSqr:=0;
    result:=0;

    if not copyData then exit;{copyData appelle AllouerFit}

    if numModel>0 then
      with modeleFit(numModel) do
      begin
      FitChiSqr:=KiCarre (PxFtr,PyFtr,PzFtr,
                          @valeur[2],
                          FitNbpt,
                          NbParam,
                          Fitmode,
                          f);

      end
      else FitChiSqr:=getU;

      libererFit;

      result:=FitChiSqr;
  end;
end;



procedure TmatFit.afficherFit;
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


{************************ Méthodes STM de TmatFit *******************************}

procedure proTmatFitting_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TmatFit);
end;

procedure proTmatFitting_create_1(var pu:typeUO);
begin
  proTmatFitting_create('', pu);
end;

procedure proTmatFitting_reset(var pu:typeUO);
begin
  verifierObjet(pu);
  with TmatFit(pu) do
  begin
    reset;
  end;
end;

procedure proTmatFitting_execute(var pu:typeUO);
begin
  verifierObjet(pu);
  with TmatFit(pu) do
  begin
    if not fit then sortieErreur(E_fit);
  end;
end;

procedure proTmatFitting_initialize(v:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    initialize:=v;
  end;
end;

function fonctionTmatFitting_initialize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    fonctionTmatFitting_initialize:=initialize;
  end;
end;

procedure proTmatFitting_setdata(var m:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatFit(pu).setdata(m);
end;


procedure proTmatFitting_setErrorData(var m:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatFit(pu).setErrorData(m);
end;


function fonctionTmatFitting_UserModel(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    fonctionTmatFitting_UserModel:=(numModel>0);
  end;
end;


procedure proTmatFitting_Mode(v:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    if (v<1) or (v>9) then sortieErreur(E_mode);
    Fitmode:=v;
  end;
end;


function fonctionTmatFitting_Mode(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    fonctionTmatFitting_Mode:=Fitmode;
  end;
end;


function fonctionTmatFitting_DataCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    fonctionTmatFitting_DataCount:=FitNbpt;
  end;
end;

procedure proTmatFitting_Clamp(st:AnsiString;v:boolean;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    i:=indexof(st);
    if i=0 then sortieErreur(E_paramName);
    FitParaCl[i]:=v;
  end;
end;

function fonctionTmatFitting_clamp(st:AnsiString;var pu:typeUO):boolean;
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    i:=indexof(st);
    if i=0 then sortieErreur(E_paramName);
    fonctionTmatFitting_clamp:=FitParaCl[i];
  end;
end;

function fonctionTmatFitting_FitReg(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TmatFit(pu) do
    fonctionTmatFitting_FitReg:=FitReg;
end;

procedure proTmatFitting_MaxIT(v:integer;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    if v>0 then maxIT:=v;
  end;
end;

function fonctionTmatFitting_maxIT(var pu:typeUO):integer;
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    result:=maxIT;
  end;
end;

procedure proTmatFitting_Threshold(v:integer;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    if v>0 then FitSeuil:=v;
  end;
end;

function fonctionTmatFitting_Threshold(var pu:typeUO):integer;
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    result:=FitSeuil;
  end;
end;

procedure proTmatFitting_UseSelection(v:boolean;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  TmatFit(pu).fitInfo.useSelect:=v;
end;

function fonctionTmatFitting_UseSelection(var pu:typeUO):boolean;
var
  i:integer;
begin
  verifierObjet(pu);
  result:=TmatFit(pu).fitInfo.useSelect;
end;

function fonctionTmatFitting_ParamSig(st:AnsiString;var pu:typeUO):float;
var
  i:integer;
begin
  verifierObjet(pu);
  with TmatFit(pu),fitInfo do
  begin
    i:=indexof(st);
    if i=0 then sortieErreur(E_paramName);
    result:=FitsigmaA[i];
  end;
end;


Initialization
AffDebug('Initialization stmMfit1',0);

installError(E_fit  ,'TmatFitting.execute error');
installError(E_paramName ,'TmatFitting: unknown param name');
installError(E_model ,'TmatFitting: invalid model number ');
installError( E_mode ,'TmatFitting: invalid weighting mode');
installError(E_maxdata ,'TmatFitting: maxData error ');

registerObject(TmatFit,data);

end.
