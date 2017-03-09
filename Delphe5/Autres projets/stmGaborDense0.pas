unit stmGaborDense0;          { Non utilisée dans Elphy , voir stmGaborDense1 }

interface

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette,
     stmDef,stmObj,stmobv0,stmRev1,varconf1,Ncdef2,
     defForm,selRF1,editcont,
     getMseq1,syspal32,
     stmgrid1,
     stmvec1,stmMat1,stmOdat2,
     stmPg,stmError,
     Rarray1,listG,
     matrix0,chrono0,gratDX1,IspGS1,
     stmexe11,stmExe10,stmISPL1,stmgrid2;



type

  TGaborNoise=class(Trevcor)

              private

                recouvrement:boolean;

                lgBB,nbGabor,preSim:integer;

                BB:array of shortInt;

                ker1:array of array of array of TDCplx;
                ker2:array of array of array of array of array of array of TDCplx;

                tau1K1,tau2K1,NtauK1:integer;
                tau1K2,tau2K2,NtauK2:integer;


                pseq:integer;

                count1,count2:integer;

                obvisuel:array of TLGabor;{}
                fonctionsObvisuel:array of TDCplx;{utilisé dans le calcul des kernels}
                grid:Tgrid;
                grid2:TVSgrid;

                dataK1,dataK2:typeDataGetCpx;
                VK1,VK2:Tvector;

                {le zero complexe}
                zero:TDCplx;
                variance:double;
                {propriétés de l'objet GaborNoise utilisées par l'utilisateur d'Elphy}
                Eextensionx,Eextensiony,
                Eattenuationx,Eattenuationy,
                Eperiode,Ephase,
                Econtraste,
                EpasLum,EpasPer,EpasPhase:double;
                EpasOrient,EnbLum,EnbPer,EnbPhase,EnbOrient:integer;

                {qq fonctions pour l'utilisation des complexes...}
                function copy(x:TDCplx):TFloatComp;
                function reel(x:double):TDCplx;
                function moduleCarre(x:TDCplx):double;
                function conjugate(x:TDCplx):TDCplx;

                {La fonction à interpoler dans les noyaux. Le signal est une somme et un produit de cette fonction pour différentes valeurs}
                function analyseFonction(theta,luminance,phase,periode:double):TDCplx;
                procedure initFonctionsObvisuel;

                procedure initObvisuel(taillex,tailley,attx,atty,period,phas,contraste,pasLuminance,pasPeriode,pasPhase:double;pasOrientation,nbLuminance,nbPer,nbPhase,nbOrient:integer;rectbloque:boolean);{}
                function getKernel1(x,y,tau:integer):TFloatComp;
                procedure setKernel1(x,y,tau:integer;w:TFloatComp);
                function getKernel2(x1,y1,t1,x2,y2,t2:integer):TFloatComp;
                procedure setKernel2(x1,y1,t1,x2,y2,t2:integer;w:TFloatComp);

                function getKer1L(i:integer):TFloatComp;
                function getKer2L(i:integer):TFloatComp;

                procedure CalculBruit;

                procedure CalculK1(VData:Tvector;t1,t2:integer;Fclear:boolean);
                procedure CalculK2(VData:Tvector;t11,t22:integer;Fclear:boolean);


                function Xker1(tab:Ptabdouble;Nb,x,y,t:integer):TFloatComp;
                function Xker2(tab:Ptabdouble;Nb,x1,y1,t1,x2,y2,t2:integer):TFloatComp;

                procedure setSeed(x:integer);override;

              public
                constructor create;override;
                destructor destroy;override;
                class function STMClassName:string;override;

                procedure setVisiFlags(obOn:boolean);override;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;


                function Von(x,y:integer):Tresizable;
                function Von2(x,y:integer):integer;
                procedure initParams;

                procedure FirstOrder(var mat:Tmatrix;tau:integer);
                procedure SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer);
                procedure SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer);

                property Kernel1[x,y,tau:integer]:TFloatComp read getKernel1
                                                        write setKernel1;
                property Kernel2[x1,y1,tau1,x2,y2,tau2:integer]:TFloatComp read getKernel2
                                                                      write setKernel2;


                procedure Simulate(var RA:TrealArray;var vec:Tvector;
                                    var Ferror:boolean);

                procedure BuildK1list(var RA:TrealArray;seuil1,seuil2:float);
                procedure BuildK2list(var RA:TrealArray;seuil1,seuil2:float);

                function getXker1(var Vdata:Tvector;x,y,tau:integer):TfloatComp;
                function getXker2(var Vdata:Tvector;x1,y1,tau1,x2,y2,tau2:integer):TFloatComp;

                procedure setChildNames;override;
              end;


procedure proTGaborNoise_create(name:String;var pu:typeUO);pascal;

{Fonctions pour traiter le signal acquis avant de le décomposer en noyaux}
procedure proSamplingIntAbove(var source,dest,evenements:TVector;seuil:float);pascal;
procedure proSamplingIntBelow(var source,dest,evenements:TVector;seuil:float);pascal;
procedure proSamplingEnergie1(var source,dest,evenements:TVector;Y0:float);pascal;

{Fonctions pour les ondelettes}
procedure proWaveletAnalysis(var source,dest:TVector;profondeur,wType,param1,param2:integer);pascal;
procedure proWaveletShow(var vec:TVector;profondeur:integer;var mat:Tmatrix); pascal;
procedure proWaveletReconstruct(var source,dest:TVector;profondeur,wType,param1,param2,composanteMin,composanteMax:integer);pascal;
procedure proWaveletDenoise(var vec:TVector;profondeur,composanteMin,composanteMax:integer;seuil:double);pascal;

{modification des variables de réglages du bruit dense}
procedure proTGaborNoise_recouvrement(val:boolean;var pu:typeUO);pascal;
function fonctionTGaborNoise_recouvrement(var pu:typeUO):boolean;pascal;
procedure proTGaborNoise_preSim(val:boolean;var pu:typeUO);pascal;
function fonctionTGaborNoise_preSim(var pu:typeUO):boolean;pascal;
procedure proTGaborNoise_extensionx(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_extensionx(var pu:typeUO):double; pascal;
procedure proTGaborNoise_extensiony(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_extensiony(var pu:typeUO):double;pascal;
procedure proTGaborNoise_attenuationx(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_attenuationx(var pu:typeUO):double;pascal;
procedure proTGaborNoise_attenuationy(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_attenuationy(var pu:typeUO):double; pascal;
procedure proTGaborNoise_periode(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_periode(var pu:typeUO):double; pascal;
procedure proTGaborNoise_phase(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_phase(var pu:typeUO):double; pascal;
procedure proTGaborNoise_contraste(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_contraste(var pu:typeUO):double; pascal;
procedure proTGaborNoise_pasLum(value:double;var pu:typeUO); pascal;
function fonctionTGaborNoise_pasLum(var pu:typeUO):double;  pascal;
procedure proTGaborNoise_pasPer(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_pasPer(var pu:typeUO):double;   pascal;
procedure proTGaborNoise_pasPhase(value:double;var pu:typeUO);pascal;
function fonctionTGaborNoise_pasPhase(var pu:typeUO):double;   pascal;
procedure proTGaborNoise_pasOrient(value:integer;var pu:typeUO); pascal;
function fonctionTGaborNoise_pasOrient(var pu:typeUO):integer;pascal;
procedure proTGaborNoise_nbPer(value:integer;var pu:typeUO); pascal;
function fonctionTGaborNoise_nbPer(var pu:typeUO):integer;  pascal;
procedure proTGaborNoise_nbLum(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_nbLum(var pu:typeUO):integer;pascal;
procedure proTGaborNoise_nbPhase(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_nbPhase(var pu:typeUO):integer;pascal;
procedure proTGaborNoise_nbOrient(value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_nbOrient(var pu:typeUO):integer;pascal;

function fonctionTGaborNoise_bruit(x,y,t:integer;var pu:typeUO):integer;pascal;

function fonctionTGaborNoise_length(var pu:typeUO):integer;pascal;

procedure proTGaborNoise_Nvalue(n,value:integer;var pu:typeUO);pascal;
function fonctionTGaborNoise_Nvalue(n:integer;var pu:typeUO):integer;pascal;

procedure proTGaborNoise_BuildK1(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);pascal;
procedure proTGaborNoise_BuildK2(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);pascal;

procedure proTGaborNoise_FirstOrder(var mat:Tmatrix;tau:integer;
                                    var pu:typeUO);pascal;
procedure proTGaborNoise_SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer;
                                    var pu:typeUO);pascal;
procedure proTGaborNoise_SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer;
                                    var pu:typeUO);pascal;


function fonctionTGaborNoise_Kernel1(x,y,t:integer;var pu:typeUO):TFloatComp;pascal;
function fonctionTGaborNoise_Kernel2(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):TFloatComp;pascal;

function fonctionTGaborNoise_Ker1(var Vdata:Tvector;x,y,t:integer;var pu:typeUO):TFloatComp;pascal;
function fonctionTGaborNoise_Ker2(var Vdata:Tvector;x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):TFloatComp;pascal;

procedure proTGaborNoise_Simulate(var RA:TrealArray;
                                  var vec:Tvector;
                                  var pu:typeUO);pascal;

function fonctionTGaborNoise_VK1(var pu:typeUO):Tvector;pascal;
function fonctionTGaborNoise_VK2(var pu:typeUO):Tvector;pascal;

procedure proTGaborNoise_BuildK1list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);pascal;
procedure proTGaborNoise_BuildK2list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);pascal;


implementation


function DeuxPuissance(a:integer) : integer;
begin
  result:=1 shl a;
end;


{*********************   Méthodes de TGaborNoise  *************************}

constructor TGaborNoise.create;
var
  i,j:integer;
begin
  inherited create;

  timeMan.dtOn:=1;

  if not initISPL then
  begin
    messageCentral('ISPL not installed');
    exit;
  end;

  zero.Re:=0;
  zero.Im:=0;

  nbGabor:=6; {valeur par défaut pour ne pas perturber calculbruit}
  recouvrement:=false;{par défaut on fait du recouvrement}
  preSim:=0;{valeur par défaut de preSim}
  lgBB:=65536;
  setLength(bb,lgBB);

  nbDivX:=8;
  nbDivY:=8;
  expansion:=100;
  dureeC:=10;
  if assigned(rfSys[1])
    then RFDeg:=rfSys[1].deg
    else RFdeg:=degNul;

  grid:=Tgrid.create;
  grid.notpublished:=true;
  grid.Fchild:=true;

  grid2:=TVSgrid.create;
  grid2.notpublished:=true;
  grid2.Fchild:=true;

  timeMan.nbCycle:=1000;
  calculBruit;


  dataK1.create(getKer1L,0,1);

  VK1:=Tvector.create;
  AddTochildList(VK1);
  with VK1 do
  begin
    Fchild:=true;
    initdat1(@dataK1,g_double);
  end;

  dataK2.create(getKer2L,0,1);

  VK2:=Tvector.create;
  AddTochildList(VK2);
  with VK2 do
  begin
    Fchild:=true;
    initdat1(@dataK2,g_double);
  end;
  Eextensionx:=1;
  Eextensiony:=1;
  Eattenuationx:=0.2;
  Eattenuationy:=0.2;
  Eperiode:=0.5;
  Ephase:=0;
  Econtraste:=0.8;
  EpasLum:=0;
  EpasPer:=0;
  EpasPhase:=0;
  EpasOrient:=30;
  EnbLum:=1;
  EnbPer:=1;
  EnbPhase:=1;
  EnbOrient:=6;
  initFonctionsObvisuel;
end;


destructor TGaborNoise.destroy;
var
  i:integer;
begin

  grid.free;
  grid2.Free;

  VK1.free;
  VK2.free;

  dataK1.free;
  dataK2.free;


  inherited destroy;
end;

procedure TGaborNoise.setChildNames;
begin
  with VK1 do
  begin
    ident:=self.ident+'.VK1';

  end;
  with VK2 do
  begin
    ident:=self.ident+'.VK2';

  end;
end;


procedure TGaborNoise.calculBruit;
var
  i,j,debut: integer;
begin
  setLength(bb,lgBB);

  randSeed:=seed;
  if preSim=0 then
    begin
      for i:=0 to lgBB-1 do
        bb[i]:=random(nbGabor);
    end;

  if preSim=1 then {préstimulation avec les gabors en phase}
    begin
      for i:=0 to nx*ny-1 do
        for j:=0 to pseq-1 do
          BB[i*pseq+j]:=j mod nbGabor;
    end;

  if preSim=2 then {préstimulation avec phases aléatoires}
    begin
      for i:=0 to nx*ny-1 do
        begin
          debut:=random(nbGabor);
          for j:=0 to pseq-1 do
            BB[i*pseq+j]:=(debut+j) mod nbGabor;
        end;
    end;
end;

procedure proSamplingIntAbove(var source,dest,evenements:TVector;seuil:float);pascal;
var i:integer;
    len:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(evenements);
  Vmodify(dest,source.tpNum,evenements.Istart,evenements.Iend-1);{attention au -1!}
  dest.unitX:=source.unitX;
  with evenements do
  begin
    dest.Dxu:=Yvalue[Istart+3]-Yvalue[Istart+2];
    dest.x0u:=Yvalue[Istart];
  end;

  for i:=evenements.Istart to evenements.Iend-1 do
      dest.Yvalue[i]:=FonctionIntAbove(source,evenements.Yvalue[i],evenements.Yvalue[i+1],seuil,len);
end;

procedure proSamplingIntBelow(var source,dest,evenements:TVector;seuil:float);pascal;
var i:integer;
    len:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(evenements);
  Vmodify(dest,source.tpNum,evenements.Istart,evenements.Iend-1);{attention au -1!}
  dest.unitX:=source.unitX;
  with evenements do
  begin
    dest.Dxu:=Yvalue[Istart+3]-Yvalue[Istart+2];
    dest.x0u:=Yvalue[Istart];
  end;

  for i:=evenements.Istart to evenements.Iend-1 do
      dest.Yvalue[i]:=FonctionIntBelow(source,evenements.Yvalue[i],evenements.Yvalue[i+1],seuil,len);
end;

procedure proSamplingEnergie1(var source,dest,evenements:TVector;Y0:float);pascal;
var i:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(evenements);
  Vmodify(dest,source.tpNum,evenements.Istart,evenements.Iend-1);{attention au -1!}
  dest.unitX:=source.unitX;
  with evenements do
  begin
    dest.Dxu:=Yvalue[Istart+3]-Yvalue[Istart+2];
    dest.x0u:=Yvalue[Istart];
  end;

  for i:=evenements.Istart to evenements.Iend-1 do
      dest.Yvalue[i]:=FonctionEnergie1(source,evenements.Yvalue[i],evenements.Yvalue[i+1],Y0);
end;

procedure proWaveletAnalysis(var source,dest:TVector;profondeur,wType,param1,param2:integer);
var etat:TNSPWtState;
    longueurDec,i:integer;
    tab:array of double;
begin
  ISPtest;
  verifierVecteur(source);
  verifierVecteurTemp(dest);
  dest.unitX:=source.unitX;
  dest.Dxu:=source.Dxu;
  dest.X0u:=source.X0u;
  setLength(tab,source.Icount);
  for i:=0 to source.Icount-1 do
    tab[i]:=source.Yvalue[i+source.Istart];

  if not initIspl then messageCentral('Ispl pas installée');

  nspdWtInitLen(param1,param2,source.Icount,profondeur,etat,wType,longueurDec);
  Vmodify(dest,g_Double,source.Istart,source.Istart+longueurDec);
  nspdWtDecompose(etat,@tab[0],dest.tb);

  if source.Icount <> longueurDec then
    messageCentral('Longueur du signal:'+Istr(source.Icount)+crlf+'Longueur d''analyse:'+Istr(longueurDec));

  nspWtFree(etat);
  ISPend;
end;

procedure proWaveletShow(var vec:TVector;profondeur:integer;var mat:Tmatrix);
var i,j,debut,pas:integer;
begin
  mat.modify(mat.tpNum, 1,1,floor(vec.Icount/2),profondeur+1);
  pas:=1;

  for i:=1 to profondeur do
  begin

    debut:=floor(vec.Icount / DeuxPuissance(i));

    for j:=0 to floor(vec.Icount/2)-1 do
      mat.Zvalue[j+1,i]:= vec.Yvalue[vec.Istart+debut+floor(j/pas)];

   pas:=pas*2;
  end;

  pas:=pas div 2;
  for j:=0 to floor(vec.Icount/2)-1 do
    mat.Zvalue[j+1,profondeur+1]:=vec.Yvalue[vec.Istart+floor(j/pas)];
end;

procedure proWaveletReconstruct(var source,dest:TVector;profondeur,wType,param1,param2,composanteMin,composanteMax:integer);
{composantemin ou max=-1 on reconstitue le signal tel quel, sinon on met tout à 0 sauf les composantes enrte min et max}
var etat:TNSPWtState;
    longueurDec,i,deb,fin:integer;
    tab:array of double;
begin
  ISPtest;
  verifierVecteur(source);
  verifierVecteurTemp(dest);
  Vmodify(dest,g_Double,source.Istart,source.Iend);
  dest.unitX:=source.unitX;
  dest.Dxu:=source.Dxu;
  dest.X0u:=source.X0u;
  setLength(tab,source.Icount);
  for i:=0 to source.Icount-1 do
    tab[i]:=source.Yvalue[i+source.Istart];

  if (composanteMin>0) and (composanteMax>0)then
  begin
    if composanteMin <= profondeur then deb:=floor(dest.Icount/DeuxPuissance(composanteMin))
      else deb:=0;

    fin:=floor(source.Icount/DeuxPuissance(composanteMax-1))-1;

    for i:=0 to deb-1 do tab[i]:=0;
    for i:=fin+1 to source.Icount-1 do tab[i]:=0;
  end;

  nspdWtInitLen(param1,param2,dest.Icount,profondeur,etat,wType,longueurDec);
  Vmodify(dest,g_Double,source.Istart,source.Istart+longueurDec);
  nspdWtReconstruct(etat,@tab[0],dest.tb);

  nspWtFree(etat);
  ISPend;
end;

procedure proWaveletDenoise(var vec:TVector;profondeur,composanteMin,composanteMax:integer;seuil:double);
{Débruite les coefficients en mettant à zéro ceux qui ne dépassent pas un certain seuil.
Attention, dest doit déjà etre rempli: on ne met pas ses paramètres à jour}
var i,deb,fin:integer;
begin
  verifierVecteur(vec);

  if (composanteMin>0) and (composanteMax>0)then
  begin
    if composanteMin <= profondeur then deb:=floor(vec.Icount/DeuxPuissance(composanteMin))
      else deb:=0;

    fin:=floor(vec.Icount/DeuxPuissance(composanteMax-1))-1;

    for i:=deb to fin do
    begin
      if sqr(vec.Yvalue[i])< sqr(seuil) then vec.Yvalue[i]:=0;
    end;
  end;
end;

function TGaborNoise.conjugate(x:TDCplx):TDCplx;
begin
  result.Re:=x.Re;
  result.Im:=-x.Im;
end;

function TGaborNoise.copy(x:TDCplx):TFloatComp;
begin
  result.x:=x.Re;
  result.y:=x.Im;
end;

function TGaborNoise.reel(x:double):TDCplx;
begin
  result.Re:=x;
  result.Im:=0;
end;

function TGaborNoise.moduleCarre(x:TDCplx):double;
begin
  result:= sqr(x.Re) + sqr(x.Im);
end;

function TGaborNoise.analyseFonction(theta,luminance,phase,periode:double):TDCplx;
begin
  if phase=EPhase then result:=nspzSet(cos(theta),sin(theta))
  else result:=nspzSet(-cos(theta),-sin(theta));
end;


procedure TGaborNoise.initFonctionsObvisuel;
var orient,angle:double;
    per,lum:double;
    somme:TDCplx;
    nbangle,i,j,k,l,indiceCourant:integer;
begin
  nbGabor:=EnbOrient*EnbLum*EnbPer*EnbPhase;
  setLength(fonctionsObvisuel,nbGabor);
  nbAngle:=EnbOrient;
  angle:=0;
  somme:=nspzSet(0,0);
  for l:=0 to EnbPhase-1 do
  for k:=0 to EnbLum-1 do
  for j:=0 to EnbPer-1 do
  for i:=0 to nbAngle-1 do
    begin
      angle:=i*EpasOrient;
      {if angle > 90 then angle:=angle-180;} {on garde les angles entre -90 et 90 pour plus de lisibilité des résultats (écart à l'orientation préférée...)}
      indiceCourant:=i+j*nbAngle+k*nbAngle*EnbPer+l*nbAngle*EnbPer*EnbLum;
      fonctionsObvisuel[indiceCourant]:=analyseFonction(angle,Econtraste+k*EpasLum,Ephase+l*EpasPhase,Eperiode+j*EpasPer);
      somme:=nspzAdd(somme,fonctionsObvisuel[indiceCourant]);
    end;

    somme:=nspzDiv(somme,reel(nbGabor));
    for i:=0 to nbGabor-1 do fonctionsObvisuel[i]:=nspzSub(fonctionsObvisuel[i],somme);{le but est d'avoir un bruit centré en 0}
    variance:=0;
    for i:=0 to nbGabor-1 do variance:=variance+moduleCarre(fonctionsObvisuel[i]);
    variance:=variance/nbGabor;

end;

procedure TGaborNoise.initObvisuel(taillex,tailley,attx,atty,period,phas,contraste,pasLuminance,pasPeriode,pasPhase:double;pasOrientation,nbLuminance,nbPer,nbPhase,nbOrient:integer;rectbloque:boolean);{}
var i,j,k,l,nbAngle,indiceCourant:integer;
    orient,angle:double;
    per,lum:double;
    somme:TDCplx;
begin
  ISPtest;
  nbAngle:=nbOrient;
  nbGabor:=nbAngle*nbPer*nbLuminance*nbPhase;
  setLength(obvisuel,nbGabor);
  setLength(fonctionsObvisuel,nbGabor);
  orient:=RFdeg.theta;
  somme:=nspzSet(0,0);
  for l:=0 to nbPhase-1 do
  for k:=0 to nbLuminance-1 do
  for j:=0 to nbPer-1 do
  for i:=0 to nbAngle-1 do
    begin
      indiceCourant:=i+j*nbAngle+k*nbAngle*nbPer+l*nbAngle*nbPer*nbLuminance;
      obvisuel[indiceCourant]:=TLGabor.create;
      obvisuel[indiceCourant].deg.dx:=taillex;
      obvisuel[indiceCourant].deg.dy:=tailley;
      obvisuel[indiceCourant].Lx:=attx;
      obvisuel[indiceCourant].Ly:=atty;
      obvisuel[indiceCourant].phase:=phas+l*pasPhase;
      obvisuel[indiceCourant].contrast:=contraste+k*pasLuminance;
      obvisuel[indiceCourant].periode:=period+j*pasPeriode;
      orient:=i*pasOrientation;
      obvisuel[indiceCourant].orientation:=orient;
      {2 possibilités: on fait bouger le rectangle contenant le gabor avec l'orientation, ou on le laisse bloqué et on ne fait varier que l'orientation}
      if rectbloque then obvisuel[indiceCourant].deg.theta:=RFdeg.theta else obvisuel[indiceCourant].deg.theta:=orient;

      {on remplit le tableau fonctionsObvisuel qui servira pour le calcul des noyaux}
      angle:=orient;
      {if angle > 90 then angle:=angle-180;} {on garde les angles entre -90 et 90 pour plus de lisibilité des résultats (écart à l'orientation préférée...)}
      fonctionsObvisuel[indiceCourant]:=analyseFonction(angle,contraste+k*pasLuminance,phas+l*pasPhase,period+j*pasPeriode);
      somme:=nspzAdd(somme,fonctionsObvisuel[indiceCourant]);

      if recouvrement then grid2.addObject(obvisuel[indiceCourant]);
    end;
    somme:=nspzDiv(somme,reel(nbGabor));
    for i:=0 to nbGabor-1 do fonctionsObvisuel[i]:=nspzSub(fonctionsObvisuel[i],somme);{le but est d'avoir un bruit centré en 0}
    calculbruit;

    ISPend;
end;

class function TGaborNoise.STMClassName:string;
  begin
    STMClassName:='GaborNoise';
  end;

procedure TGaborNoise.initParams;
begin
  index:=-1;
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  pseq:=lgBB div (nx*ny);
end;


procedure TGaborNoise.InitMvt;
  var
    i,j:integer;
    deg1:typeDegre;
    dimension:single;
  begin
    initParams;

    deg1:=RFdeg;
    deg1.dx:=deg1.dx*expansion/100;
    deg1.dy:=deg1.dy*expansion/100;

    if recouvrement then
    begin
      grid2.deg:=deg1;
      grid2.initGrid(nx,ny);
    end
    else
      grid.initGrille(deg1,nx,ny);

    obvis.deg.theta:=RFdeg.theta;

    if AdjustObjectSize then
      begin
        obvis.deg.dx:=RFdeg.dx /nbDivX;
        obvis.deg.dy:=RFdeg.dy /nbDivY;
      end;

    obvis.onScreen:=false;
    obvis.onControl:=false;

    obvis.deg.lum:=lum[1];


    with TimeMan do tend:=torg+dureeC*nbCycle;

    dimension:=min(RFdeg.dx/nbDivX,RFdeg.dy/nbDivY);
    initObvisuel(Eextensionx*dimension,Eextensiony*dimension,Eattenuationx*dimension,Eattenuationy*dimension,
                 Eperiode,Ephase,Econtraste,EpasLum,EpasPer,EpasPhase,EpasOrient,EnbLum,EnbPer,EnbPhase,EnbOrient,true);        {valeurs à changer}
  end;

procedure TGaborNoise.initObvis;
var i:integer;
begin
  if not recouvrement then
  begin
    obvis.prepareS;
    for i:=0 to nbGabor-1 do
      obvisuel[i].prepareS;
    end
  else
    grid2.prepareS;
end;

function TGaborNoise.Von(x,y:integer):Tresizable;
var
  k,decal:integer;
begin
  k:=x+nx*y;
  decal:=(k*pseq +index) mod lgBB;

  if bb[decal]=-1
    then result:=obvis
  else result:=obvisuel[bb[decal]];
end;

function TGaborNoise.Von2(x,y:integer):integer;
var
  k,decal:integer;
begin
  k:=x+nx*y;
  decal:=(k*pseq +index) mod lgBB;

  result:=bb[decal]+1;
end;

procedure TGaborNoise.calculeMvt;
var
  i,j:integer;
begin
  if (timeS mod dureeC=0)  then inc(Index);

  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
        if recouvrement then grid2.status[i+1,j+1]:=Von2(i,j)
         else grid.obvisA[i,j]:=Von(i,j);
end;

procedure TGaborNoise.doneMvt;
var
  i,j:integer;
begin
  for i:=0 to nbGabor-1 do
    obvisuel[i].Free;

  if recouvrement then grid2.resetGrid
    else
    begin
      for i:=0 to nx-1 do
        for j:=0 to ny-1 do
          grid.obvisA[i,j]:=nil;
    end;
end;

procedure TGaborNoise.setVisiFlags(obOn:boolean);
begin
  if not recouvrement then
  begin
    if assigned(grid) then
    begin
      grid.FonScreen:=affStim and ObON;
      grid.FonControl:=affControl and ObON;
    end;
  end
  else
  begin
    if assigned(grid2) then
    begin
      grid2.FonScreen:=affStim and ObON;
      grid2.FonControl:=affControl and ObON;
    end;
  end;
end;

procedure TGaborNoise.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      if tout then setvarConf('OBVIS',longint(obvis),sizeof(longint));
    end;
  end;

procedure TGaborNoise.CompleteLoadInfo;
  begin
    majPos;
  end;

function TGaborNoise.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMseq;;
end;


procedure TGaborNoise.installDialog(var form:Tgenform;var newF:boolean);
begin
  installForm(form,newF);

  with TgetMseq(form) do
  begin
    enDelay.setVar(timeMan.tOrg,T_longInt);
    enDelay.setMinMax(0,maxEntierLong);
    enDelay.Dxu:=Tfreq/1E6;

    enDtON.setVar(timeMan.dtON,T_longInt);
    enDtON.setMinMax(0,maxEntierLong);
    enDtON.Dxu:=Tfreq/1E6;

    enDtOff.setVar(timeMan.dtOff,T_longInt);
    enDtOff.setMinMax(0,maxEntierLong);
    enDtOff.Dxu:=Tfreq/1E6;

    enCycleCount.setVar(timeMan.nbCycle,T_longInt);
    enCycleCount.setMinMax(0,maxEntierLong);

    cbDivX.setString('2|4|8|16');
    cbDivX.setNumVar(nbDivX,T_longint);

    cbDivY.setString('2|4|8|16');
    cbDivY.setNumVar(nbDivY,T_longint);

    enLum1.setVar(lum[1],T_double);
    enLum1.setMinMax(0,10000);

    enLum2.setVar(lum[2],T_double);
    enLum2.setMinMax(0,10000);

    cbExpansion.setString('25|50|100|200|400');
    cbExpansion.setNumVar(Expansion,T_longint);

    selectRFD:=SelectRF;

    CBadjust.setvar(adjustObjectSize);

    onControlD:=DisplayOnControl;   {Ces procédures doivent être mises en place}
    onScreenD:=DisplayOnScreen;     {AVANT de modifier checked }

    CbOnControl.checked:=onControl;
    CbOnScreen.checked:=onScreen;

    initCBvisual(self,typeUO(obvis));
    updateAllCtrl(form);
  end;

end;


function TGaborNoise.getKernel1(x,y,tau:integer):TFloatCOmp;
begin
  if (x>=0) and (x<nx) and (y>=0) and (y<ny) and (tau>=tau1K1) and (tau<=tau2K1)
    then result:=copy(ker1[x,y,tau-tau1K1])
    else result:=copy(zero);
end;

procedure TGaborNoise.setKernel1(x,y,tau:integer;w:TFloatComp);
begin
  if (x>=0) and (x<nx) and (y>=0) and (y<ny) and (tau>=tau1K1) and (tau<=tau2K1)
    then
    begin
      ker1[x,y,tau-tau1K1].Re:=w.x;
      ker1[x,y,tau-tau1K1].Im:=w.y;
    end;
end;




function TGaborNoise.getKer1L(i:integer):TFloatComp;
var
  x,y,tau:integer;
begin
  if ntauK1>0 then
  begin
    tau:=i mod ntauK1;
    i:=i div ntauK1;
    y:= i mod ny;
    x:=i div ny;
    result:=copy(ker1[x,y,tau]);
  end
  else result:=copy(zero);
end;

function TGaborNoise.getKer2L(i:integer):TFloatCOmp;
var
  x1,y1,tau1,x2,y2,tau2:integer;
begin
  if ntauK2>0 then
  begin
    tau2:=i mod ntauK2;
    i:=i div ntauK2;

    y2:= i mod ny;
    i:=i div ny;

    x2:= i mod nx;
    i:=i div nx;

    tau1:=i mod ntauK2;
    i:=i div ntauK2;

    y1:= i mod ny;
    x1:=i div ny;

    result:=copy(ker2[x1,y1,tau1,x2,y2,tau2]);
  end
  else result:=copy(zero);
end;

procedure TGaborNoise.calculK1(VData:Tvector;t1,t2:integer;Fclear:boolean);
var
  i,x,y,t:integer;
  k1:integer;

  tab:array of double;
  tab2,resultat: array of TDCplx;

  kw,ajout:TDCplx;
  nbtot,indice:integer;
begin
  initParams;
  ISPtest;

  tau1K1:=t1;
  tau2K1:=t2;
  NtauK1:=t2-t1+1;

  setLength(ker1,nx,ny,ntauK1);

  setLength(tab,Vdata.Icount);
  setLength(tab2,Vdata.Icount);
  setLength(resultat,2*Vdata.Icount);

  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  if Fclear
    then count1:=1
    else inc(count1);

  nbTot:=Vdata.Icount{-nTauK1};

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
    begin

      k1:=(x+nx*y)*pseq -tau1K1+lgBB;

      for i:={ntauK1}0 to Vdata.Icount-1 do
      begin
        indice:=BB[(i+k1) mod LgBB];{quel était le gabor à cet endroit à ce moment?}
        tab2[Vdata.Icount-1-i]:=conjugate(fonctionsObvisuel[indice]);
      end;

      nspdzConv(@tab[0],Vdata.Icount,@tab2[0],Vdata.Icount,@resultat[0]);

    for t:=0 to nTauK1-1 do
      begin
      {kw:=nspzSet(0,0);}
        kw:=resultat[t+Vdata.Icount-1];

{      k1:=(x+nx*y)*pseq -t-tau1K1+lgBB;}

(*
      for i:={ntauK1}0 to Vdata.Icount-1 do
        begin{!!partie copiée telle quelle dans Xker1}
          indice:=BB[(i+k1) mod LgBB];{quel était le gabor à cet endroit à ce moment?}
          ajout:=reel(tab[i]); {on doit ajouter tab[i]*fonctionsObvisuel[indice]}
          ajout:=nspzMpy(ajout,conjugate(fonctionsObvisuel[indice]));
          kw:=nspzAdd(kw,ajout);    {somme complexe... }
        end;
*)

        kw:=nspzDiv(kw,nspzSet(nbTot*variance,0)); {kw/nbTot*variance}
        if Fclear
          then ker1[x,y,t]:=kw
          else   {(ker1[x,y,t]*(count1-1)+kw)/count1}
            begin
              ker1[x,y,t]:=nspzMpy(ker1[x,y,t],reel(count1-1));
              ker1[x,y,t]:=nspzAdd(ker1[x,y,t],kw);
              ker1[x,y,t]:=nspzDiv(ker1[x,y,t],reel(count1));
            end;

      end;
    end;

  dataK1.create(getKer1L,0,nx*ny*ntauK1-1);
  VK1.initdat1(@dataK1,g_doubleComp);
  ISPend;
end;

procedure TGaborNoise.calculK2(VData:Tvector;t11,t22:integer;Fclear:boolean);
var
  i:integer;
  p1,p2:integer;

  x1,y1,t1,x2,y2,t2:integer;
  w1,w2:integer;

  tab:array of double;
  tab1,tab2,resultat: array of TDCplx;
  kw1,ajout:TDCplx;

  nbtot:integer;
  cond:boolean;
  q1,q2,indice1,indice2:integer;
  Ndata:integer;
begin
  {initChrono;}
  initParams;
  ISPtest;

  tau1K2:=t11;
  tau2K2:=t22;
  NtauK2:=t22-t11+1;
  nbTot:=CycleCount-ntauK2;

  if Fclear
    then count2:=1
    else inc(count2);

  if Fclear then
    begin
      setLength(ker2,nx,ny,ntauK2,nx,ny,ntauK2);
      
      for x1:=0 to nx-1 do
      for y1:=0 to ny-1 do
      for t1:=0 to ntauK2-1 do
      for x2:=0 to nx-1 do
      for y2:=0 to ny-1 do
      for t2:=0 to ntauK2-1 do
        ker2[x1,y1,t1,x2,y2,t2]:=zero;
    end;

  setLength(tab,Vdata.Icount);
  setLength(tab1,Vdata.Icount);
  setLength(tab2,Vdata.Icount);
  setLength(resultat,2*Vdata.Icount);

  for i:=0 to Vdata.Icount-1 do
    tab[i]:=Vdata.Yvalue[i+Vdata.Istart];
  Ndata:=Vdata.Icount;

  for x1:=0 to nx-1 do
  for y1:=0 to ny-1 do
  for t1:=0 to ntauK2-1 do
  BEGIN
    for x2:=0 to nx-1 do
    for y2:=0 to ny-1 do

    begin
      p1:=(x1+nx*y1)*pseq -t1 -tau1K2 +lgBB;
      p2:=(x2+nx*y2)*pseq {-t2} -tau1K2 +lgBB;


      for i:={ntauK1}0 to Vdata.Icount-1 do
        begin
          w1:=(i+p1) mod lgBB;
          w2:=(i+p2) mod lgBB;
          indice1:=BB[w1];{quel était le gabor à cet endroit (1) à ce moment?}
          indice2:=BB[w2];{quel était le gabor à cet endroit (2) à ce moment?}

          tab1[i]:=nspzMpy(reel(tab[i]),conjugate(fonctionsObvisuel[indice1]));
          tab2[Vdata.Icount-1-i]:=conjugate(fonctionsObvisuel[indice2]);

        end;

      nspzConv(@tab1[0],Vdata.Icount,@tab2[0],Vdata.Icount,@resultat[0]);



      for t2:=0 to ntauK2-1 do
        begin
          q1:=x1+nx*y1+nx*ny*t1;
          q2:=x2+nx*y2+nx*ny*t2;

          if q1>=q2 then      {K(x,y)==K(y,x)}
          begin
            p1:=(x1+nx*y1)*pseq -t1 -tau1K2 +lgBB;
            p2:=(x2+nx*y2)*pseq -t2 -tau1K2 +lgBB;

            kw1:=resultat[Vdata.Icount-1+t2];

(*          for i:=ntauK2 to Ndata-1 do
            begin
               { BUG DELPHI !
                 En écrivant If BB[(i+p1) mod lgBB]=BB[(i+p2) mod lgBB] then ...
                 ==> Erreur fatale Internal error
               }
              w1:=(i+p1) mod lgBB;
              w2:=(i+p2) mod lgBB;
              indice1:=BB[w1];{quel était le gabor à cet endroit (1) à ce moment?}
              indice2:=BB[w2];{quel était le gabor à cet endroit (2) à ce moment?}
              ajout:=reel(tab[i]); {on doit ajouter tab[i]*fonctionsObvisuel[indice1]*fonctionsObvisuel[indice2]}
              ajout:=nspzMpy(ajout,conjugate(fonctionsObvisuel[indice1]));
              ajout:=nspzMpy(ajout,conjugate(fonctionsObvisuel[indice2]));

              kw1:=nspzAdd(kw1,ajout);{somme complexe... }
            end;
*)            {if p1=p2 then kw1:=nspzDiv(kw1,reel(2));}{pour les coefficients diagonaux}
            if Fclear then
              begin
                ker2[x1,y1,t1,x2,y2,t2]:=nspzDiv(kw1,reel(nbtot));
                ker2[x2,y2,t2,x1,y1,t1]:=ker2[x1,y1,t1,x2,y2,t2];
              end
            else
              begin
                ker2[x2,y2,t2,x1,y1,t1]:=nspzMpy(ker2[x2,y2,t2,x1,y1,t1],nspzSet(count2-1,0));
                ker2[x2,y2,t2,x1,y1,t1]:=nspzAdd(ker2[x2,y2,t2,x1,y1,t1],nspzDiv(kw1,reel(nbtot)));
                ker2[x2,y2,t2,x1,y1,t1]:=nspzDiv(ker2[x2,y2,t2,x1,y1,t1],reel(count2));
{             ker2[x1,y1,t1,x2,y2,t2]:=( ker2[x1,y1,t1,x2,y2,t2]*(count2-1)+kw1/(nbtot) )/count2;}

                ker2[x2,y2,t2,x1,y1,t1]:=ker2[x1,y1,t1,x2,y2,t2];
              end;
          end;
        end;
      end;
    if testerFinPg then
    begin
      dataK2.create(getKer2L,0,sqr(nx*ny*ntauK2)-1);
      VK2.initdat1(@dataK2,g_double);
      exit;
    end;
    {statusLineTxt(Istr(x1)+' '+Istr(y1)+' '+Istr(t1));}
  END;

  dataK2.create(getKer2L,0,sqr(nx*ny*ntauK2)-1);
  VK2.initdat1(@dataK2,g_doubleComp);
  ISPend;
  {messageCentral(Chrono);}
end;




{A quoi servent ces 2 fonctions?}
function TGaborNoise.Xker1(tab:Ptabdouble;Nb,x,y,t:integer):TFloatComp;
var
  i,k1:integer;
  kw,ajout:TDCplx;
  tmin,tmax,indice:integer;
begin
  kw:=zero;

  k1:=(x+nx*y)*pseq -t-tau1K1+lgBB;

  tmin:=max(0,t);
  tmax:=min(Nb-1,Nb-1+t);

  for i:=tmin to tmax do
    begin {cette partie a été copiée/collée sur celle de calculK1}
      indice:=BB[(i+k1) mod LgBB];{quel était le gabor à cet endroit à ce moment?}
      ajout:=reel(tab[i]); {on doit ajouter tab[i]*fonctionsObvisuel[indice]}
      ajout:=nspzMpy(ajout,conjugate(fonctionsObvisuel[indice]));
      kw:=nspzAdd(kw,ajout);    {somme complexe... }
    end;
  result:=copy(nspzDiv(kw,reel((tmax-tmin+1))));
end;

function TGaborNoise.Xker2(tab:Ptabdouble;Nb,x1,y1,t1,x2,y2,t2:integer):TFloatComp;
var
  i:integer;
  p1,p2:integer;
  w1,w2,indice1,indice2:integer;
  kw1,ajout:TDCplx;
  tmin,tmax:integer;
begin
  p1:=(x1+nx*y1)*pseq -t1 -tau1K2 +lgBB;
  p2:=(x2+nx*y2)*pseq -t2 -tau1K2 +lgBB;

  tmin:=max(0,t1);
  tmin:=max(tmin,t2);
  tmax:=min(Nb-1,Nb-1+t1);
  tmax:=min(tmax,Nb-1+t2);

  kw1:=zero;
  for i:=tmin to tmax do
    begin
      w1:=(i+p1) mod lgBB;
      w2:=(i+p2) mod lgBB;
      {partie copiée de calculK2}
      indice1:=BB[w1];{quel était le gabor à cet endroit (1) à ce moment?}
      indice2:=BB[w2];{quel était le gabor à cet endroit (2) à ce moment?}
      ajout:=nspzSet(tab[i],0); {on doit ajouter tab[i]*fonctionsObvisuel[indice1]*fonctionsObvisuel[indice2]}
      ajout:=nspzMpy(ajout,fonctionsObvisuel[indice1]);
      ajout:=nspzMpy(ajout,fonctionsObvisuel[indice2]);
      kw1:=nspzAdd(kw1,ajout);    {somme complexe... }
    end;

  result:=copy(nspzDiv(kw1,reel(tmax-tmin+1)));
end;

function TGaborNoise.getXker1(var Vdata:Tvector;x,y,tau:integer):TFloatComp;
var
  i,j:integer;
  tab:array of double;
begin
  initParams;

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  result:= Xker1(@tab[0],length(tab),i,j,tau);
end;

function TGaborNoise.getXker2(var Vdata:Tvector;x1,y1,tau1,x2,y2,tau2:integer):TFloatComp;
var
  i:integer;
  tab:array of double;
begin
  initParams;

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  result:= Xker2(@tab[0],length(tab),x1,y1,tau1,x2,y2,tau2);
end;



procedure TGaborNoise.FirstOrder(var mat:Tmatrix;tau:integer);{!!Il nous faut une matrice de complexes!!}
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Cpxvalue[1+i,1+j]:= Kernel1[i,j,tau];
end;

procedure TGaborNoise.SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer);{!!Il nous faut une matrice de complexes!!}
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Cpxvalue[1+i,1+j]:= Kernel2[x1,y1,tau1,i,j,tau2];

end;


procedure TGaborNoise.SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=max(0,-dx) to min(nX-1,nX-dx-1) do
  for j:=max(0,-dy) to min(nY-1,nY-dy-1) do
    mat.Cpxvalue[1+i,1+j]:= kernel2[i,j,tau1,i+dx,j+dx,tau1+dt];
end;


(* Id avec calcul immédiat
procedure TGaborNoise.FirstOrder(var Vdata:Tvector;var mat:Tmatrix;tau:integer);
var
  i,j:integer;
  tab:array of double;
begin
  initParams;
  mat.modify(1,1,nx,ny);

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= Xker1(@tab[0],length(tab),i,j,tau);
end;



procedure TGaborNoise.SecondOrder(var Vdata:Tvector;var mat:Tmatrix;x1,y1,tau1,tau2:integer);
var
  i,j:integer;
  tab:array of double;
begin
  initParams;
  mat.modify(1,1,nx,ny);

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= XKer2(@tab[0],length(tab),x1,y1,tau1,i,j,tau2);
end;

procedure TGaborNoise.SecondOrder1(var Vdata:Tvector;var mat:Tmatrix;tau1,dx,dy,dt:integer);
var
  i,j:integer;
  tab:array of double;
begin
  initParams;
  mat.modify(1,1,nx,ny);

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  for i:=max(0,-dx) to min(nX-1,nX-dx-1) do
  for j:=max(0,-dy) to min(nY-1,nY-dy-1) do
    mat.Zvalue[1+i,1+j]:= Xker2(@tab[0],length(tab),i,j,tau1,i+dx,j+dx,tau1+dt);

end;
*)


function TGaborNoise.getKernel2(x1,y1,t1,x2,y2,t2:integer):TFloatComp;
begin
  if (x1>=0) and (x1<nx) and (y1>=0) and (y1<ny) and (t1>=tau1K2) and (t1<=tau2K2)
     and
     (x2>=0) and (x2<nx) and (y2>=0) and (y2<ny) and (t2>=tau1K2) and (t2<=tau2K2)
    then result:=copy(ker2[x1,y1,t1-tau1K2,x2,y2,t2-tau1K2])
    else result:=copy(zero);

end;

procedure TGaborNoise.setKernel2(x1,y1,t1,x2,y2,t2:integer;w:TFloatComp);
begin
  if (x1>=0) and (x1<nx) and (y1>=0) and (y1<ny) and (t1>=tau1K2) and (t1<=tau2K2)
     and
     (x2>=0) and (x2<nx) and (y2>=0) and (y2<ny) and (t2>=tau1K2) and (t2<=tau2K2)
    then
    begin
      ker2[x1,y1,t1-tau1K2,x2,y2,t2-tau1K2].Re:=w.x;
      ker2[x1,y1,t1-tau1K2,x2,y2,t2-tau1K2].Re:=w.x;
    end;
end;

type
  TKrecord=record
             bloc,decal:integer;
             value:TDCplx;
           end;
  PKrecord=^TKrecord;

  TKrecord2=record
              bloc1,decal1,bloc2,decal2:integer;
              value:TDCplx;
              First:boolean;
            end;
  PKrecord2=^TKrecord2;





procedure TGaborNoise.Simulate(var RA:TrealArray;var vec:Tvector;  {!!TrealArray doit avoir 8 colonnes}
                               var Ferror:boolean);
var
  i,t:integer;
  x1,y1,tau1,x2,y2,tau2:integer;
  w:TKrecord2;
  data:typedataB;
  Klist:TlistG;
  tmp:real;
  produit:TDCplx;

{Attention, dans le formalisme de Wiener, au deuxième ordre, les coefficients diagonaux ne sont pas nuls!}
{De plus la reconstitution du signal est différente à l'ordre 2}
begin
  initParams;
  ISPtest;
  initFonctionsObvisuel;
  Klist:=TlistG.create(sizeof(TKrecord2));

  {calcul de la variance du bruit, nécessaire pour reconstituer le signal}
  variance:=0;
  for i:=0 to nbGabor-1 do variance:=variance+moduleCarre(fonctionsObvisuel[i]);
  variance:=variance/nbGabor;

  Ferror:=false;
  TRY
    vec.initTemp1(0,CycleCount-1,g_double);

    for i:=1 to RA.nblig do
      begin
        w.value:=nspzSet(RA.value[7,i],RA.value[8,i]);
        if (w.value.Re<>0) or (w.value.Im<>0) then
          begin
            x1:=roundL(RA.value[1,i])-1;
            y1:=roundL(RA.value[2,i])-1;
            tau1:=roundL(RA.value[3,i]);
            w.decal1:=((x1+y1*nx)*pseq-tau1 +lgBB) mod LgBB;

            x2:=roundL(RA.value[4,i])-1;
            y2:=roundL(RA.value[5,i])-1;
            tau2:=roundL(RA.value[6,i]);

            w.First:=(x2<0);
            if not w.First then
              w.decal2:=((x2+y2*nx)*pseq-tau2 +lgBB) mod LgBB;

            if (x1>=0) and (y1>=0)
              then Klist.add(@w)
              else Ferror:=true;
          end;
      end;

    data:=vec.data;

    if not Ferror then
      for t:=0 to CycleCount-1 do
      begin
        vec.Yvalue[t]:=0;
        for i:=0 to Klist.count-1 do
          with PKrecord2(Klist[i])^ do
          if First
            then data.addE(t,nspzMpy(value,fonctionsObvisuel[bb[(decal1+t) mod LgBB]]).Re)
            else
              begin
                if (decal1=decal2) then tmp:=variance*value.Re {ajout d'un terme spécifique au noyau de Wiener}
                  else tmp:=0;
                produit:=nspzMpy(fonctionsObvisuel[bb[(decal1+t) mod LgBB]],fonctionsObvisuel[bb[(decal2+t) mod LgBB]]);

                data.addE(t,nspzMpy(value,produit).Re-tmp);
              end;
      end;

  FINALLY
    Klist.free;
  END;
  ISPend;
end;


type
  TBKrecord=record
              x,y:byte;
              t:smallint;
              value:TDCplx;
           end;
  PBKrecord=^TBKrecord;

  TBKrecord2=record
              x1,y1:byte;
              t1:smallint;
              x2,y2:byte;
              t2:smallint;
              value:TDCplx;
            end;
  PBKrecord2=^TBKrecord2;
{les 2 fonctions suivantes ne peuvent être adaptées au cas complexe. Sont-elles nécessaires?}
{
function compareK1(Item1, Item2: Pointer): Integer;
begin
  if PBKrecord(item1)^.value<PBKrecord(item2)^.value then result:=-1
  else
  if PBKrecord(item1)^.value>PBKrecord(item2)^.value then result:=1
  else result:=0;
end;

function compareK2(Item1, Item2: Pointer): Integer;
begin
  if PBKrecord2(item1)^.value<PBKrecord2(item2)^.value then result:=-1
  else
  if PBKrecord2(item1)^.value>PBKrecord2(item2)^.value then result:=1
  else result:=0;
end;
}

{pour les 2 procedures build on seuille sur la valeur du module}
procedure TGaborNoise.BuildK1list(var RA:TrealArray;seuil1,seuil2:float);
var
  i,k:integer;
  x,y,t:integer;
  Nt:integer;
  w:TBKrecord;
  Klist:TlistG;
begin
  Klist:=TlistG.create(sizeof(TBKrecord));
  seuil1:=sqr(seuil1);
  seuil2:=sqr(seuil2);

  TRY
    RA.modify(4,Nx*Ny*NtauK1);

    for t:=0 to ntauK1-1 do
    for y:=0 to ny-1 do
    for x:=0 to nx-1 do
      begin
        w.value:=Ker1[x,y,t];
        if (moduleCarre(w.value)<=seuil1) or (moduleCarre(w.value)>=seuil2) then
          begin
            w.x:=x;
            w.y:=y;
            w.t:=t;
            Klist.add(@w);
          end;
      end;

 {   Klist.sort(compareK1);}

    for i:=0 to nx*ny*ntauK1-1 do
    with PBKrecord(Klist[i])^ do
    begin
      RA.value[1,i+1]:=x+1;
      RA.value[2,i+1]:=y+1;
      RA.value[3,i+1]:=tau1K1+t;
      RA.value[4,i+1]:=value.Re;
      RA.value[5,i+1]:=value.Im;
    end;

  FINALLY
    Klist.free;
  END;
end;

procedure TGaborNoise.BuildK2list(var RA:TrealArray;seuil1,seuil2:float);
var
  i,k:integer;
  x1,y1,t1,x2,y2,t2:integer;
  Nt:integer;
  w:TBKrecord2;
  w0:double;
  index1,index2:integer;
  Klist:TlistG;
  
begin
  Klist:=TlistG.create(sizeof(TBKrecord2));
  seuil1:=sqr(seuil1);
  seuil2:=sqr(seuil2);

  TRY
    RA.modify(8,Nx*Ny*Nt*Nx*Ny*Nt);

    for t2:=0 to ntauK2-1 do
    for y2:=0 to ny-1 do
    for x2:=0 to nx-1 do
    for t1:=0 to ntauK2-1 do
    for y1:=0 to ny-1 do
    for x1:=0 to nx-1 do
      begin
        w.value:=Ker2[x1,y1,tau1K2,x2,y2,tau2K2];
        if (moduleCarre(w.value)<=seuil1) or (moduleCarre(w.value)>=seuil2) then
          begin
            w.x1:=x1;
            w.y1:=y1;
            w.t1:=t1;
            w.x2:=x2;
            w.y2:=y2;
            w.t2:=t2;
            Klist.add(@w);
          end;
      end;

{    Klist.sort(compareK2);}

    for i:=0 to Klist.count-1 do
    with PBKrecord2(Klist[i])^ do
    begin
      RA.value[1,i+1]:=x1+1;
      RA.value[2,i+1]:=y1+1;
      RA.value[3,i+1]:=tau1K2+t1;
      RA.value[4,i+1]:=x2+1;
      RA.value[5,i+1]:=y2+1;
      RA.value[6,i+1]:=tau1K2+t2;

      RA.value[7,i+1]:=value.Re;
      RA.value[8,i+1]:=value.Im;
    end;

  FINALLY
    Klist.free;
  END;
end;


procedure TGaborNoise.setSeed(x:integer);
begin
  inherited setSeed(x);
  calculBruit;
end;

{*************************** Méthodes STM ************************************}

var
  E_order:integer;

  E_ker1:integer;
  E_ker2:integer;

  E_index:integer;
  E_data:integer;

  E_XYpos:integer;
  E_simul:integer;

procedure proTGaborNoise_create(name:String;var pu:typeUO);
begin
  createPgObject(name,pu,TGaborNoise);

  with TGaborNoise(pu) do
  begin
    calculBruit;
    setChildNames;
  end;
end;


procedure proTGaborNoise_recouvrement(val:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
    recouvrement:=val;
end;

function fonctionTGaborNoise_recouvrement(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
    result:=recouvrement;
end;

procedure proTGaborNoise_preSim(val:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if val then preSim:=2 else preSim:=0;
  end;
end;

function fonctionTGaborNoise_preSim(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
    result:=(preSim=2);
end;

{procedures et fonctions de lecture/écriture dans les variables suivantes:
                Eextensionx,Eextensiony,
                Eattenuationx,Eattenuationy,
                Eperiode,Ephase,
                Econtraste,
                EpasLum,EpasPer,EpasPhase:double;
                EpasOrient,EnbLum,EnbPer,EnbPhase:integer;

}

procedure proTGaborNoise_extensionx(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    Eextensionx:=value;
  end;
end;

function fonctionTGaborNoise_extensionx(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Eextensionx;
  end;
end;

procedure proTGaborNoise_extensiony(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    Eextensiony:=value;
  end;
end;

function fonctionTGaborNoise_extensiony(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Eextensiony;
  end;
end;

procedure proTGaborNoise_attenuationx(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    Eattenuationx:=value;
  end;
end;

function fonctionTGaborNoise_attenuationx(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Eattenuationx;
  end;
end;

procedure proTGaborNoise_attenuationy(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    Eattenuationy:=value;
  end;
end;

function fonctionTGaborNoise_attenuationy(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Eattenuationy;
  end;
end;

procedure proTGaborNoise_periode(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    Eperiode:=value;
  end;
end;

function fonctionTGaborNoise_periode(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Eperiode;
  end;
end;

procedure proTGaborNoise_phase(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < -200) or (value > 200) then sortieErreur(E_order);
    Ephase:=value;
  end;
end;

function fonctionTGaborNoise_phase(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Ephase;
  end;
end;

procedure proTGaborNoise_contraste(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 100) then sortieErreur(E_order);
    Econtraste:=value;
  end;
end;

function fonctionTGaborNoise_contraste(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=Econtraste;
  end;
end;

procedure proTGaborNoise_pasLum(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 50) then sortieErreur(E_order);
    EpasLum:=value;
  end;
end;

function fonctionTGaborNoise_pasLum(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EpasLum;
  end;
end;

procedure proTGaborNoise_pasPer(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) then sortieErreur(E_order);
    EpasPer:=value;
  end;
end;

function fonctionTGaborNoise_pasPer(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EpasPer;
  end;
end;

procedure proTGaborNoise_pasPhase(value:double;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 200) then sortieErreur(E_order);
    EpasPhase:=value;
  end;
end;

function fonctionTGaborNoise_pasPhase(var pu:typeUO):double;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EpasPhase;
  end;
end;

procedure proTGaborNoise_pasOrient(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 100) then sortieErreur(E_order);
    EpasOrient:=value;
  end;
end;

function fonctionTGaborNoise_pasOrient(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EpasOrient;
  end;
end;

procedure proTGaborNoise_nbPer(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    EnbPer:=value;
  end;
end;

function fonctionTGaborNoise_nbPer(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EnbPer;
  end;
end;

procedure proTGaborNoise_nbLum(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    EnbLum:=value;
  end;
end;

function fonctionTGaborNoise_nbLum(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EnbLum;
  end;
end;

procedure proTGaborNoise_nbPhase(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    EnbPhase:=value;
  end;
end;

function fonctionTGaborNoise_nbPhase(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EnbPhase;
  end;
end;

procedure proTGaborNoise_nbOrient(value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (value < 0) or (value > 10) then sortieErreur(E_order);
    EnbOrient:=value;
  end;
end;

function fonctionTGaborNoise_nbOrient(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    result:=EnbOrient;
  end;
end;

procedure proTGaborNoise_Nvalue(n,value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if (n<0) or (n>=lgBB) then sortieErreur(E_Index);
    bb[n]:=value;
  end;
end;

function fonctionTGaborNoise_bruit(x,y,t:integer;var pu:typeUO):integer;
var k,decal:integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    k:=x+nx*y;
    decal:=(k*pseq +t) mod lgBB;
    result:=bb[decal];
  end;
end;

function fonctionTGaborNoise_Nvalue(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if  (n<0) or (n>=lgBB) then sortieErreur(E_Index);
    result:=bb[n];
  end;
end;

function fonctionTGaborNoise_length(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do result:=lgBB;
end;

procedure proTGaborNoise_BuildK1(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vdata));

  with TGaborNoise(pu) do CalculK1(Vdata,t1,t2,Fclear);
end;


procedure proTGaborNoise_BuildK2(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vdata));

  with TGaborNoise(pu) do CalculK2(Vdata,t1,t2,Fclear);
end;


procedure proTGaborNoise_FirstOrder(var mat:Tmatrix;tau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  TGaborNoise(pu).firstOrder(mat,tau);
end;


procedure proTGaborNoise_SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  TGaborNoise(pu).SecondOrder(mat,x1-1,y1-1,tau1,tau2);
end;

procedure proTGaborNoise_SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  TGaborNoise(pu).SecondOrder1(mat,tau1,dx,dy,dt);
end;


function fonctionTGaborNoise_Kernel1(x,y,t:integer;var pu:typeUO):TFloatComp;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if not assigned(ker1) then sortieErreur(E_ker1);
    if (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (t<tau1K1) or (t>tau2K1) then sortieErreur(E_XYpos);

    result:=kernel1[x-1,y-1,t];
  end;
end;


function fonctionTGaborNoise_Kernel2(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):TFloatComp;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if not assigned(ker2) then sortieErreur(E_ker2);

    if (x1<1) or (x1>nx) or
       (y1<1) or (y1>ny) or
       (x2<1) or (x2>nx) or
       (y2<1) or (y2>ny) or
       (t1<tau1K2) or (t1>tau2K2) or
       (t2<tau1K2) or (t2>tau2K2)
       then sortieErreur(E_XYpos);

    result:=kernel2[x1-1,y1-1,t1,x2-1,y2-1,t2];
  end;
end;

function fonctionTGaborNoise_Ker1(var Vdata:Tvector;x,y,t:integer;var pu:typeUO):TFloatComp;
begin
  verifierObjet(pu);
  verifierVecteur(Vdata);
  with TGaborNoise(pu) do
  begin
    if (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (t<tau1K1) or (t>tau2K1) then sortieErreur(E_XYpos);

    result:=getXker1(Vdata,x-1,y-1,t);
  end;
end;


function fonctionTGaborNoise_Ker2(var Vdata:Tvector;x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):TFloatCOmp;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do
  begin
    if not assigned(ker2) then sortieErreur(E_ker2);

    if (x1<1) or (x1>nx) or
       (y1<1) or (y1>ny) or
       (x2<1) or (x2>nx) or
       (y2<1) or (y2>ny) or
       (t1<tau1K2) or (t1>tau2K2) or
       (t2<tau1K2) or (t2>tau2K2)
       then sortieErreur(E_XYpos);

    result:=getXker2(Vdata,x1-1,y1-1,t1,x2-1,y2-1,t2);
  end;
end;


procedure proTGaborNoise_Simulate(var RA:TrealArray;
                                  var vec:Tvector;
                                  var pu:typeUO);
var
  error:boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  verifierObjet(typeUO(RA));

  vec.controleReadOnly;

  with TGaborNoise(pu) do simulate(ra,vec,error);
  if error then sortieErreur(E_simul);
end;


function fonctionTGaborNoise_VK1(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do result:=@VK1.myAd;
end;

function fonctionTGaborNoise_VK2(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TGaborNoise(pu) do result:=@VK2.myAd;
end;

procedure proTGaborNoise_BuildK1list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(RA));
  with TGaborNoise(pu) do BuildK1list(RA,seuil1,seuil2);
end;

procedure proTGaborNoise_BuildK2list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(RA));
  with TGaborNoise(pu) do BuildK2list(RA,seuil1,seuil2);
end;


Initialization

registerObject(TGaborNoise,stim);

installError(E_order,'TGaborNoise: order out of range');
installError(E_index,'TGaborNoise: index out of range');
installError(E_simul,'TGaborNoise.simulate bad data ');

installError(E_ker1,'TGaborNoise: kernel1 not available ');
installError(E_ker2,'TGaborNoise: kernel2 not available ');

installError(E_XYpos,'TGaborNoise: invalid coordinates x y t ');


end.
