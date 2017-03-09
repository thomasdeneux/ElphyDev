unit Dcur2fit;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,FormMenu;

const
  maxPara=20;
  maxModele=1;
  Vclamp=1.0E20;

  tabModeFit:array[1..6] of string[11]=('1       ',
                                       '1/sigma[i]²',
                                       '1/z[i]² ',
                                       '1/|z[i]|',
                                       'z[i]²   ',
                                       '|z[i]|  ');

  modeFit:byte=1;

type
  TAffproc=procedure of object;

type
  Tdoublet=record
             x1,x2:float;
           end;
  TtabDoublet1=array[1..1] of Tdoublet;
  PtabDoublet1=^TtabDoublet1;


  TypeFonction=function(x:Tdoublet;p:ptabFloat1):float of object;

  TypeDerivee=procedure(var x:Tdoublet;
                        p:ptabFloat1;
                        Cl:ptabBoolean1;
                        deriv:ptabFloat1) of object;

  typeInitFit=procedure(x:PtabDoublet1;
                        y:PtabFloat1;
                        para:PtabFloat1;
                        NbPts,NbPara:integer) of object;

  TmodeleFit=class
    class Function id:AnsiString;
    Function f(x:Tdoublet;p:PtabFloat1):float;virtual;
    procedure Derivee(var x:Tdoublet;
                      p:PtabFloat1;
                      Cl:PtabBoolean1;
                      deriv:PtabFloat1);virtual;
    procedure init(x:PtabDoublet1;
                   y:PtabFloat1;
                   para:PtabFloat1;
                   NbPts,NbPara:integer);virtual;
    function nbparam:integer;virtual;
  end;


procedure curfit1(x:PtabDoublet1;
                  y,yFit,Poids,SigmaY,SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);

procedure curfit (x:PtabDoublet1;
                  y,yFit,Poids,SigmaY,SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);


{ Curfit effectue un fitting par une méthode de Marquart modifiée. Il s'agit
 de la  méthode du gradient à laquelle est incorporée la méthode de
 linéarisation des fonctions.

  Les 6 premiers paramètres sont des tableaux de réels .
  Ils doivent être alloués par le programme appelant. Seuls a, b et éventuellement
  d doivent être initialisés.

  a: (x)       tableau des données, variable indépendante
  b: (y)       tableau des données, variable dépendante
  c: (yFit)    tableau des valeurs calculées de y
  d: (Poids)   tableau des poids les poids dépendent du mode
       mode=1 ==>poids[i]=1;
       mode=2 ==>poids[i]=1.0/(sigmaY[i]*sigmaY[i]);
       mode=3 ==>poids[i]=1.0/(y[i]*y[i]);
       mode=4 ==>poids[i]=1.0/abs(y[i]);
  e: (sigmaY)  tableau des écarts types sur y
  f: (sigmaA)  tableau des écarts types sur les paramŠtres

  para         tableau des paramètres
  paraCl       indique les paramètres clampés
  ChiSqr       le Ki carré
  NbPts        nombre de données
  NbPara       nombre de paramètres. Ce nombre est lié au modèle utilisé.
  fonc         fonction évaluant la fonction à fitter
  derivee      procédure calculant les dérivées partielles de la fonction
               théorique par rapport aux paramètres
  mode         détermine le poids des données

  yFit, poids et sigmaA n'ont pas à être initialisés.
  sigmaY doit être initialisé pour le mode 2.
  Les paramètres para doivent etre initialisés.

}


Procedure ChoixModeleStandard(owner:Tcomponent;var NumModele,xpos,ypos:integer);


function allouerFit(var a,b,c,d,e:pointer;Nbdata:integer):boolean;
procedure DesallouerFit(var a,b,c,d,e:pointer;Nbdata:integer);

function KiCarre(x:PtabDoublet1;
                 y,SigmaY:PtabFloat1;
                 para:PtabFloat1;
                 Nbpts:integer;
                 NbPara:integer;
                 mode:integer;
                 fonc:typeFonction):float;

function KiCarre1(x:PtabDoublet1;
                  y,SigmaY:PtabFloat1;
                  para:PtabFloat1;
                  Nbpts:integer;
                  NbPara:integer;
                  mode:integer;
                  fonc:typeFonction):float;


procedure setFitCntMax(n:integer);
function ModeleFit(num:integer):TmodeleFit;

IMPLEMENTATION

const
  FitCntmax:integer=10000;

procedure setFitCntMax(n:integer);
  begin
    FitCntMax:=n;
  end;



type
  typeMatrice=array[1..maxPara,1..maxPara] of float;

const
  invPi=0.3989422804;
  epsilon=1.0E-2000;


{****************************************************************************}

  {  Calcul de l'inverse d'une matrice carrée symétrique de dimension n }
  {  renvoie det=0 si la matrice n'est pas inversible, sinon det=1      }

procedure MatInv(var t:typeMatrice;var det:float;n:integer);
  var
    i,j,k,l:integer;
    Ik,Jk:array[1..maxPara] of integer;
    amax,s:float;
  begin
    det:=1;
    for k:=1 to n do
      begin
                         { trouver le plus grand élément du tableau }
        amax:=0;
        for i:=k to n do
          for j:=k to n do
            if abs(amax)<=abs(t[i,j]) then
              begin
                amax:=t[i,j];
                Ik[k]:=i;
                Jk[k]:=j;
              end;

                         { intervertir rangées et colonnes pour avoir amax }
                         { dans t[k,k] }
        if amax=0 then
          begin
            det:=0;
            exit;
          end;
        i:=Ik[k];
        if i>k then
          for j:=1 to n do
            begin
              s:=t[k,j];t[k,j]:=t[i,j];t[i,j]:=-s;
            end;
        j:=Jk[k];
        if j>k then
          for i:=1 to n do
            begin
              s:=t[i,k];t[i,k]:=t[i,j];t[i,j]:=-s;
            end;
                         { accumuler les éléments de la matrice inverse }
        for i:=1 to n do
          if i<>k then t[i,k]:=-t[i,k]/amax;
        for i:=1 to n do
          for j:=1 to n do
            if (i<>k) and (j<>k) then t[i,j]:=t[i,j]+t[i,k]*t[k,j];

        for j:=1 to n do
          if j<>k then t[k,j]:=t[k,j]/amax;
        t[k,k]:=1.0/amax;
      end;
                         { remettre la matrice en ordre }
      for l:=1 to n do
        begin
          k:=n-l+1;
          j:=Ik[k];
          if j>k then
            for i:=1 to n do
              begin
                s:=t[i,k];
                t[i,k]:=-t[i,j];
                t[i,j]:=s;
              end;
          i:=Jk[k];
          if i>k then
            for j:=1 to n do
              begin
                s:=t[k,j];
                t[k,j]:=-t[i,j];
                t[i,j]:=s;
              end;
        end;
  end;  { of MatInv }

function KiCarre1(x:PtabDoublet1;
                  y,SigmaY:PtabFloat1;
                  para:PtabFloat1;
                  Nbpts:integer;
                  NbPara:integer;
                  mode:integer;
                  fonc:typeFonction):float;
  var
    poids:float;
    chisqr:float;
    i:integer;
  begin
    if NbPts-NbPara<=0 then
      begin
        KiCarre1:=0;
        exit;
      end;

    chisqr:=0;
    for i:=1 to NbPts do
      begin
        case mode of
          1:Poids:=1;
          2:if sigmaY[i]<>0 then Poids:=1.0/(sigmaY[i]*sigmaY[i])
                            else Poids:=1;
          3:if y[i]<>0 then Poids:=1.0/(y[i]*y[i]) else Poids:=1;
          4:if y[i]<>0 then Poids:=1.0/abs(y[i]) else Poids:=1;
          5:Poids:=y[i]*y[i];
          6:Poids:=abs(y[i]);
        end;
        chisqr:=chisqr+poids*sqr(y[i]-fonc(x[i],para));
      end;

    Kicarre1:=chisqr/(NbPts-NbPara);
  end;


function KiCarre (x:PtabDoublet1;
                  y,SigmaY:PtabFloat1;
                  para:PtabFloat1;
                  Nbpts:integer;
                  NbPara:integer;
                  mode:integer;
                  fonc:typeFonction):float;
  begin
    try
      Kicarre:=Kicarre1(x,y,sigmaY,para,Nbpts,NbPara,mode,fonc)
    except
      Kicarre:=0;
    end;
  end;

procedure DeriveeGene(var x:Tdoublet;
                      pw:ptabFloat1;
                      Cl:ptabBoolean1;
                      deriv:ptabFloat1;
                      nb:integer;
                      fonc:typeFonction);
const
  eps=1E-10;
var
  i:integer;
  pw1:array[1..30] of float;
begin
  move(pw^,pw1,sizeof(float)*nb);

  for i:=1 to nb do
  begin
    if Cl^[i] then deriv^[i]:=Vclamp
    else
    begin
      pw1[i]:=pw1[i]+eps;
      deriv^[i]:=(fonc(x,@pw1)-fonc(x,pw))/eps;
      pw1[i]:=pw1[i]-eps;
    end;
  end;
end;


procedure curfit1 (x:PtabDoublet1;
                  y,yFit,Poids,SigmaY,SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);

  const
    IteraMax=100;

  var
    befor,first,fin,finB:boolean;
    Lambda,LambdaB:float;
    i,j,k,itera:integer;
    ChiSq1:float;
    Beta,BB,paraB:array[1..20] of float;
    Alpha:typeMatrice;
    tablo:typeMatrice;
    petit:float;
    det:float;
    Nlib:integer;
    Deriv:array[1..20] of float;
    cnt:longint;
    test:integer;
    diff:float;


  begin
    cnt:=0;
    Nlib:=NbPts-NbPara;
    if Nlib<=0 then exit;

    Lambda:=1.0E-5;
    befor:=false;
    first:=true;
    fin:=false;

    for i:=1 to NbPts do
      begin
        case mode of
          1:Poids[i]:=1;
          2:if sigmaY[i]<>0 then Poids[i]:=1.0/(sigmaY[i]*sigmaY[i])
                            else Poids[i]:=1;
          3:if y[i]<>0 then Poids[i]:=1.0/(y[i]*y[i]) else Poids[i]:=1;
          4:if y[i]<>0 then Poids[i]:=1.0/abs(y[i]) else Poids[i]:=1;
          5:Poids[i]:=y[i]*y[i];
          6:Poids[i]:=abs(y[i]);
        end;
      end;

    chisqr:=0;                    { pour AffVar }
    for i:=1 to NbPts do
       chisqr:=chisqr+poids[i]*sqr(y[i]-fonc(x[i],para));
    chisqr:=chisqr/(Nlib);


    if assigned(Faff) then FAff;
    repeat                          { Boucle principale }

      chisq1:=0;
      for i:=1 to NbPts do
        begin
          yfit[i]:=fonc(x[i],para);
          diff:=y[i]-yfit[i];
          chisq1:=chisq1+poids[i]*diff*diff;
        end;
      chisq1:=chisq1/(Nlib);

      fillchar(alpha,sizeof(alpha),0);     { Calcul de alpha et beta }
      fillchar(beta,sizeof(beta),0);
      for i:=1 to NbPts do
        begin
          if assigned(derivee)
            then derivee(x[i],para,paraCl,@deriv)
            else deriveeGene(x[i],para,paraCl,@deriv,nbPara,fonc);

          for j:=1 to NbPara do
            begin
              beta[j]:=beta[j]+poids[i]*(y[i]-yfit[i])*deriv[j];
              for k:=1 to j do
                alpha[j,k]:=alpha[j,k]+poids[i]*deriv[j]*deriv[k];
            end;
        end;
      for j:=1 to NbPara do              { Compléter la matrice symétrique }
        begin
          for k:=1 to j do
            alpha[k,j]:=alpha[j,k];
          if abs(alpha[j,j])<epsilon then
            if alpha[j,j]>0 then alpha[j,j]:=epsilon
                            else alpha[j,j]:=-epsilon ;
        end;



      itera:=0;                           { Inverser la matrice     }
      finB:=false;                        { de pseudo-courbure...   }
      repeat
        if assigned(Faff) then FAff;
        if testEscape then fin:=true;
        inc(cnt);
        if cnt>Fitcntmax then fin:=true;
        for j:=1 to nbPara do
          begin
            for k:=1 to nbPara do
              tablo[j,k]:=alpha[j,k]/sqrt(abs(alpha[j,j]*alpha[k,k]));
            tablo[j,j]:=1.0+Lambda;
          end;
        MatInv(tablo,det,nbPara);
        for j:=1 to nbPara do
          begin
            BB[j]:=para[j];
            for k:=1 to nbPara do
              BB[j]:=BB[j]+beta[k]*tablo[j,k]/sqrt(abs(alpha[j,j]*alpha[k,k]));
          end;

        chisqr:=0;
        for i:=1 to NbPts do
          begin
            yfit[i]:=fonc(x[i],@BB);
            diff:=y[i]-yfit[i];
            chisqr:=chisqr+poids[i]*diff*diff;
          end;
        chisqr:=chisqr/(Nlib);

        if (Chisq1>=ChiSqr) then
          begin
            for j:=1 to Nbpara do
              begin
                paraB[j]:=para[j];
                para[j]:=BB[j];
                sigmaa[j]:=sqrt(abs(tablo[j,j]/alpha[j,j]));
              end;
            first:=false;
            LambdaB:=Lambda;
            Lambda:=Lambda*0.1;
            if (ChiSq1-ChiSqr)*seuil>Chisq1
              then FinB:=true
              else fin:=true;
          end
        else
          begin
            Lambda:=Lambda*10;
            inc(Itera);
          end;

      until (itera>IteraMax) or FinB or Fin;
      if not (FinB or Fin) then
        begin
          if Befor or first then  fin:=true
          else
          begin
            For j:=1 to NbPara do para[j]:=paraB[j];
            Lambda:=LambdaB*10;
            Befor:=True;
          end;
        end;

    until Fin;       { Fin Boucle Principale }

  end; { of CurFit1 }


procedure curfit (x:PtabDoublet1;
                  y,yFit,Poids,SigmaY,SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);

  var
    exPara:array[1..20] of float;

  begin
    move(para^,expara,20*sizeof(float));
    try
      curfit1(x,y,yFit,Poids,SigmaY,SigmaA,para,ParaCl,ChiSqr,reg1,Nbpts,NbPara,
                              fonc,derivee,Mode,seuil,Faff);
    except
      fillchar(yFit,Nbpts*sizeof(float),0);
      fillchar(sigmaY,Nbpts*sizeof(float),0);
      fillchar(sigmaA,Nbpara*sizeof(float),0);
      move(expara,para^,20*sizeof(float));
      Chisqr:=0;
    end;
  end;



function allouerFit(var a,b,c,d,e:pointer;Nbdata:integer):boolean;
var
  size:integer;
begin
  try
    size:=sizeof(float)*NbData;
    getmem(a,2*size);
    getmem(b,size);
    getmem(c,size);
    getmem(d,size);
    getmem(e,size);
    result:=true;
  except
    freemem(a,size);
    freemem(b,size);
    freemem(c,size);
    freemem(d,size);
    freemem(e,size);
    result:=false;
  end;
end;

procedure desallouerFit(var a,b,c,d,e:pointer;nbData:integer);
var size:integer;
begin
  size:=sizeof(float)*NbData;
  if a<>nil then freemem(a,2*size);
  if b<>nil then freemem(b,size);
  if b<>nil then freemem(c,size);
  if d<>nil then freemem(d,size);
  if e<>nil then freemem(e,size);
  a:=nil;b:=nil;c:=nil;d:=nil;e:=nil;
end;

function CoeffReglin(var x,y,poids,sigmaY:array of float;N,mode:integer):float;
  var
    i:integer;
    somme,sommeX,sommeX2,sommeY,sommeY2,sommeXY:float;
    u:float;

  begin
    if N<=1 then exit;

    for i:=1 to N do
      begin
        case mode of
          1:Poids[i]:=1;
          2:if sigmaY[i]<>0 then Poids[i]:=1.0/(sigmaY[i]*sigmaY[i])
                            else Poids[i]:=1;
          3:if y[i]<>0 then Poids[i]:=1.0/(y[i]*y[i]) else Poids[i]:=1;
          4:if y[i]<>0 then Poids[i]:=1.0/abs(y[i]) else Poids[i]:=1;
          5:Poids[i]:=y[i]*y[i];
          6:Poids[i]:=abs(y[i]);
          7:Poids[i]:=x[i];
          8:if x[i]<>0 then Poids[i]:=1.0/(x[i]*x[i]) else Poids[i]:=1;
          9:if x[i]<>0 then Poids[i]:=1.0/abs(x[i]) else Poids[i]:=1;
        end;
      end;

    somme:=0;
    sommeX:=0;
    sommeX2:=0;
    sommeY:=0;

    sommeY2:=0;
    sommeXY:=0;
    for i:=1 to N do
      begin
        somme:=somme+poids[i];
        sommeX:=sommeX+x[i]*poids[i];
        sommeX2:=sommeX2+sqr(x[i])*poids[i];
        sommeY:=sommeY+y[i]*poids[i];
        sommeY2:=sommeY2+sqr(y[i])*poids[i];
        sommeXY:=sommeXY+x[i]*y[i]*poids[i];
      end;

    u:=sqrt(abs(sommeX2*N-sqr(sommeX)))*sqrt(abs(sommeY2*N-sqr(sommeY)));
    if u<>0 then CoeffRegLin:= abs( (sommeXY*N-sommeX*sommeY)/u )
            else CoeffRegLin:=0;
  end;



type
  TparamChiReg=record
                 chi,reg:^float;
                 x,y,sigmaY:ptabFloat1;
                 para:ptabFloat1;
                 nbdata,mode:integer;
                 f:typeFonction;
                 n:integer;
               end;


{************************* Modèles de fonctions *****************************}

class function TmodeleFit.id;
begin
  id:='Fonc1'
end;

Function TmodeleFit.f(x:Tdoublet;p:ptabFloat1):float;
begin
  result:=0;
end;

procedure TmodeleFit.Derivee(var x:Tdoublet;
                             p:ptabFloat1;
                             Cl:ptabBoolean1;
                             deriv:ptabFloat1);

begin
{    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);}
end;


procedure TmodeleFit.init(x:pTabDoublet1;
                      y:ptabFloat1;
                      para:ptabFloat1;
                      NbPts,NbPara:integer);
begin
end;

function TmodeleFit.nbparam:integer;
begin
  result:=0;
end;

function ModeleFit(num:integer):TmodeleFit;
const
  fonc:TmodeleFit=nil;
begin
  fonc.free;
  fonc:=nil;
  case num of
    1: fonc:=TmodeleFit.create;

  end;
  result:=fonc;
end;


{******************************************************************************}
var
  menuChoose:TmenuForm;

Procedure ChoixModeleStandard(owner:Tcomponent;var NumModele,xpos,ypos:integer);
  var
    i,res:integer;
  begin
    menuChoose:=TmenuForm.create(owner);
    with MenuChoose do
    begin
      if xpos<>0 then left:=xpos;
      if ypos<>0 then top:=ypos;

      for i:=1 to maxModele do add(modeleFit(i).id);
      res:=choose('Standard functions',200,numModele);
      if res>0 then numModele:=res;

      xpos:=left;
      ypos:=top;

      free;
    end;
  end;



end.
