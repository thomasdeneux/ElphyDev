unit Dcurfit0;

INTERFACE

uses classes,
     util1,FormMenu;

const
  maxPara=20;
  maxModele=26; {34; on laisse de coté les modèles de Vincent}
  Vclamp=1.0E20;

  tabModeFit:array[1..9] of string[11]=('1       ',
                                       '1/sigma[i]²',
                                       '1/y[i]² ',
                                       '1/|y[i]|',
                                       'y[i]ý   ',
                                       '|y[i]|  ',
                                       'x[i]    ',
                                       '1/x[i]² ',
                                       '1/|x[i]|');

  modeFit:byte=1;

type
  TAffproc=procedure of object;

type
  TypeFonction=function(z:float; pw: PtabFloat1):float;

  TypeDerivee=procedure(var z:float;
                        pw: PtabFloat1;
                        Cl: PtabBoolean1;
                        deriv: PtabFloat1);

  typeInitFit=procedure( a,b: PtabFloat1;
                         pw: PtabFloat1;
                         NbPts,NbPara:integer);
  typeModeleFit=record
                  f:typeFonction;
                  d:typeDerivee;
                  initF:typeInitFit;
                  n:integer;
                  id:AnsiString;
                end;
  PModeleFit=^typeModeleFit;


function curfit(  x, y, yFit, Poids, SigmaY, SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1,reg2:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc):boolean;

procedure curfit1(x, y, yFit, Poids, SigmaY, SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;

                  var ChiSqr:float;
                  var reg1,reg2:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);

{ Curfit effectue un fitting par la méthode de Marquart .

  Les 6 premiers paramŠtres sont des tableaux de réels ( PtabFloat1). Ce ne sont
  pas tous de vrais paramŠtres mais ce type de d‚claration permet l'allocation
  des tableaux en m‚moire dynamique par le programme appelant.

  a: (x)       tableau des donn‚es, variable ind‚pendante
  b: (y)       tableau des donn‚es, variable d‚pendante
  c: (yFit)    tableau des valeurs calcul‚es de y
  d: (Poids)   tableau des poids les poids d‚pendent du mode
       mode=1 ==>poids[i]=1;
       mode=2 ==>poids[i]=1.0/(sigmaY[i]*sigmaY[i]);
       mode=3 ==>poids[i]=1.0/(y[i]*y[i]);
       mode=4 ==>poids[i]=1.0/abs(y[i]);
  e: (sigmaY)  tableau des ‚carts types sur y
  f: (sigmaA)  tableau des ‚carts types sur les paramŠtres

  para         tableau des paramŠtres
  paraCl       indique les paramŠtres clamp‚s
  ChiSqr       le Ki carr‚
  NbPts        nombre de donn‚es
  NbPara       nombre de paramŠtres. Ce nombre est li‚ au modŠle utilis‚.
  fonc         fonction ‚valuant la fonction … fitter
  derivee      proc‚dure calculant les d‚riv‚es partielles de la fonction
               th‚orique par rapport aux paramŠtres
  mode         d‚termine le poids des donn‚es

  yFit, poids et sigmaA n'ont pas … ˆtre initialis‚s.
  sigmaY doit ˆtre initialis‚ pour le mode 2.
  Notons que les paramŠtres para doivent ˆtre initialis‚s.

}

function ModeleFit(num:integer):PmodeleFit;

{ **************** 6 modèles d'exponentielle ******************************* }

Function Fexpo1               (z:float;p: PtabFloat1):float;
procedure DeriveeExpo1        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function Fexpo2               (z:float;p: PtabFloat1):float;
procedure DeriveeExpo2        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function Fexpo3               (z:float;p: PtabFloat1):float;
procedure DeriveeExpo3        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function Fexpo1B              (z:float;p: PtabFloat1):float;
procedure DeriveeExpo1B       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function Fexpo2B              (z:float;p: PtabFloat1):float;
procedure DeriveeExpo2B       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function Fexpo3B              (z:float;p: PtabFloat1):float;
procedure DeriveeExpo3B       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

{ ************************************************************************* }

Function Fac1                 (z:float;pw: PtabFloat1):float;
procedure Deriveeac1          (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function Fac2                 (z:float;p: PtabFloat1):float;
procedure Deriveeac2          (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);


Function Fdroite              (z:float;p: PtabFloat1):float;
procedure DeriveeDroite       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);


Function FPoly2               (z:float;p: PtabFloat1):float;
procedure DeriveePoly2        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FPoly3               (z:float;p: PtabFloat1):float;
procedure DeriveePoly3        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FPoly4               (z:float;p: PtabFloat1):float;
procedure DeriveePoly4        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FPoly5               (z:float;p: PtabFloat1):float;
procedure DeriveePoly5        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FPoly6               (z:float;p: PtabFloat1):float;
procedure DeriveePoly6        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FPoly7               (z:float;p: PtabFloat1):float;
procedure DeriveePoly7        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);


Function FPoly8               (z:float;p: PtabFloat1):float;
procedure DeriveePoly8        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FPoly9               (z:float;p: PtabFloat1):float;
procedure DeriveePoly9        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FGauss1              (z:float;p: PtabFloat1):float;
procedure DeriveeGauss1       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FGauss2              (z:float;p: PtabFloat1):float;
procedure DeriveeGauss2       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);

Function FGauss3              (z:float;p: PtabFloat1):float;
procedure DeriveeGauss3       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);


procedure InitExpo             (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);

procedure InitExpoN            (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);


procedure InitAC1              (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);
procedure InitAC2              (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);

procedure InitDroite           (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);

procedure InitPoly             (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);

procedure InitGauss            (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);


{ **************** 6 modŠles d'exponentielle avec constante de temps ****** }

Function FExpoN1               (z:float;p: PtabFloat1):float;
procedure DeriveeExpoN1        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function FExpoN2               (z:float;p: PtabFloat1):float;
procedure DeriveeExpoN2        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function FExpoN3               (z:float;p: PtabFloat1):float;
procedure DeriveeExpoN3        (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function FExpoN1B              (z:float;p: PtabFloat1):float;
procedure DeriveeExpoN1B       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function FExpoN2B              (z:float;p: PtabFloat1):float;
procedure DeriveeExpoN2B       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);
Function FExpoN3B              (z:float;p: PtabFloat1):float;
procedure DeriveeExpoN3B       (var z:float;
                               p: PtabFloat1;
                               Cl: PtabBoolean1;
                               deriv: PtabFloat1);




Procedure ChoixModeleStandard(owner:Tcomponent;var NumModele,xpos,ypos:integer);

procedure parametresFonctionStandard(x0,y0:integer;
                                     numModele:integer;
                                     var para:PtabFloat1;
                                     var paraCl:PtabBoolean1;
                                     var sigmaA:PtabFloat1;
                                     var ChiSqr:float;
                                     var reg1:float;
                                     var x,y,sigmaY;
                                     nbData:integer;
                                     mode:integer);

procedure parametresFonction(x0,y0:integer;
                             n:integer;
                             f:typeFonction;
                             var nomvar;
                             Lnom:integer;
                             var para:PtabFloat1;
                             var paraCl:PtabBoolean1;
                             var sigmaA:PtabFloat1;
                             var ChiSqr:float;
                             var reg1:float;
                             var x,y,sigmaY;
                             nbData:integer;
                             mode:integer);

function allouerFit(var a,b,c,d,e: PtabFloat1;Nbdata:integer):boolean;
procedure DesallouerFit(var a,b,c,d,e:PtabFloat1;Nbdata:integer);

function CoeffReglin(var a,b,c,d;N,mode:integer):float;
                    {x,y,poids,sigmaY}

function CoeffReg1(var a,b,c;NbPt:integer;f:typeFonction):float;
                   {x,y,para}
function CoeffRegSeb(var a,b,c;NbPt:integer;f:typeFonction):float;                   

function CoeffReg2(var a,b,c;NbPt:integer;f:typeFonction):float;

{ CoeffRegLin utilise tous les cas de pond‚ration, contrairement … coeffReg1 }

function KiCarre(var a,b,c;            { x,y,sigma }
                 var para:PtabFloat1;
                 Nbpts:integer;
                 NbPara:integer;
                 mode:integer;
                 fonc:typeFonction):float;

function KiCarre1(var a,b,c;            { idem sans appel de sauver0 }
                 var para:PtabFloat1;
                 Nbpts:integer;
                 NbPara:integer;
                 mode:integer;
                 fonc:typeFonction):float;


procedure setFitCntMax(n:integer);


IMPLEMENTATION

const
  FitCntmax:integer=10000;

procedure setFitCntMax(n:integer);
  begin
    FitCntMax:=n;
  end;

procedure trierPara(var para:PtabFloat1;num:integer);

  procedure permut(i,j:integer);
    var
      x:float;
    begin
      x:=para[i];
      para[i]:=para[j];
      para[j]:=x;
    end;

  begin
    if (num=2) or (num=3) or
       (num=5) or (num=6) then
      begin
        if para[2]<para[4] then
          begin
            permut(2,4);
            permut(1,3);
          end;
      end;
    if (num=3) or (num=6) then
      begin
        if para[4]<para[6] then
          begin
            permut(4,6);
            permut(3,5);
          end;
        if para[2]<para[4] then
          begin
            permut(2,4);
            permut(1,3);
          end;
      end;
  end;





type
  typeMatrice=array of array of float;

const
  invPi= 1/pi; //0.3989422804;

{$IFDEF WIN64}
  epsilon=1.0E-150;
{$ELSE}
  epsilon=1.0E-2000;
{$ENDIF}

function expA(x:float):float;
  begin
    if x<-88 then expA:=0
    else
    if x>88 then expA:=1.0E34
    else
    expA:=exp(x);
  end;

Function Fexpo1;
  begin
    Fexpo1:=p[1]*expA(p[2]*z);
  end;

procedure DeriveeExpo1;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);
  end;

Function Fexpo1B;
  begin
    Fexpo1B:=p[1]*expA(p[2]*z)+p[3];
  end;

procedure DeriveeExpo1B;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=1;
  end;



Function Fexpo2;
  begin
    Fexpo2:=p[1]*expA(p[2]*z)+p[3]*expA(p[4]*z);
  end;

procedure DeriveeExpo2;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(p[4]*z);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(p[4]*z);
  end;


Function Fexpo2B;
  begin
    Fexpo2B:=p[1]*expA(p[2]*z)+p[3]*expA(p[4]*z)+p[5];
  end;

procedure DeriveeExpo2B;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(p[4]*z);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(p[4]*z);
    if Cl[5] then deriv[5]:=Vclamp
             else deriv[5]:=1;
  end;

Function Fexpo3;
  begin
    Fexpo3:=p[1]*expA(p[2]*z)+p[3]*expA(p[4]*z)+p[5]*expA(p[6]*z);
  end;

procedure DeriveeExpo3;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(p[4]*z);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(p[4]*z);
    if Cl[5] then deriv[5]:=Vclamp
             else deriv[5]:=expA(p[6]*z);
    if Cl[6] then deriv[6]:=Vclamp
             else deriv[6]:=p[5]*z*expA(p[6]*z);
  end;

Function Fexpo3B;
  begin
    Fexpo3B:=p[1]*expA(p[2]*z)+p[3]*expA(p[4]*z)+p[5]*expA(p[6]*z)+p[7];
  end;

procedure DeriveeExpo3B;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(p[2]*z);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(p[2]*z);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(p[4]*z);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(p[4]*z);
    if Cl[5] then deriv[5]:=Vclamp
             else deriv[5]:=expA(p[6]*z);
    if Cl[6] then deriv[6]:=Vclamp
             else deriv[6]:=p[5]*z*expA(p[6]*z);
    if Cl[7] then deriv[7]:=Vclamp
             else deriv[7]:=1;
  end;


Function FExpoN1;
  begin
    FExpoN1:=p[1]*expA(-z/p[2]);
  end;

procedure DeriveeExpoN1;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(-z/p[2]);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(-z/p[2])/sqr(p[2]);
  end;

Function FExpoN1B;
  begin
    FExpoN1B:=p[1]*expA(-z/p[2])+p[3];
  end;

procedure DeriveeExpoN1B;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(-z/p[2]);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(-z/p[2])/sqr(p[2]);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=1;
  end;



Function FExpoN2;
  begin
    FExpoN2:=p[1]*expA(-z/p[2])+p[3]*expA(-z/p[4]);
  end;

procedure DeriveeExpoN2;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(-z/p[2]);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(-z/p[2])/sqr(p[2]);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(-z/p[4]);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(-z/p[4])/sqr(p[4]);
  end;


Function FExpoN2B;
  begin
    FExpoN2B:=p[1]*expA(-z/p[2])+p[3]*expA(-z/p[4])+p[5];
  end;

procedure DeriveeExpoN2B;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(-z/p[2]);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(-z/p[2])/sqr(p[2]);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(-z/p[4]);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(-z/p[4])/sqr(p[4]);
    if Cl[5] then deriv[5]:=Vclamp
             else deriv[5]:=1;
  end;

Function FExpoN3;
  begin
    FExpoN3:=p[1]*expA(-z/p[2])+p[3]*expA(-z/p[4])+p[5]*expA(-z/p[6]);
  end;

procedure DeriveeExpoN3;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(-z/p[2]);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(-z/p[2])/sqr(p[2]);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(-z/p[4]);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(-z/p[4])/sqr(p[4]);
    if Cl[5] then deriv[5]:=Vclamp
             else deriv[5]:=expA(-z/p[6]);
    if Cl[6] then deriv[6]:=Vclamp
             else deriv[6]:=p[5]*z*expA(-z/p[6])/sqr(p[6]);
  end;

Function FExpoN3B;
  begin
    FExpoN3B:=p[1]*expA(-z/p[2])+p[3]*expA(-z/p[4])+p[5]*expA(-z/p[6])+p[7];
  end;

procedure DeriveeExpoN3B;
  begin
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=expA(-z/p[2]);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*z*expA(-z/p[2])/sqr(p[2]);
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=expA(-z/p[4]);
    if Cl[4] then deriv[4]:=Vclamp
             else deriv[4]:=p[3]*z*expA(-z/p[4])/sqr(p[4]);
    if Cl[5] then deriv[5]:=Vclamp
             else deriv[5]:=expA(-z/p[6]);
    if Cl[6] then deriv[6]:=Vclamp
             else deriv[6]:=p[5]*z*expA(-z/p[6])/sqr(p[6]);
    if Cl[7] then deriv[7]:=Vclamp
             else deriv[7]:=1;
  end;

{
function Fac1;
  begin
    Fac1:=p[1]/(1+expA((p[2]-z)/p[3]));
  end;

procedure deriveeAC1;
  var
    u,v:float;
  begin
    u:=expA((p[2]-z)/p[3]);
    v:=u/sqr(1+u);
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=1/(1+u);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=-p[1]*v/p[3];
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=p[1]*v*(p[2]-z)/sqr(p[3]);
  end;
}
function Fac1;
  var
    p:PtabFloat1 absolute pw;
  begin
    Fac1:=p[1]/(1+expA((-p[2]+z)/p[3]));
  end;

procedure deriveeAC1;
  var
    u,v:float;
  begin
    u:=expA((-p[2]+z)/p[3]);
    v:=u/sqr(1+u);
    if Cl[1] then deriv[1]:=Vclamp
             else deriv[1]:=1/(1+u);
    if Cl[2] then deriv[2]:=Vclamp
             else deriv[2]:=p[1]*v/p[3];
    if Cl[3] then deriv[3]:=Vclamp
             else deriv[3]:=-p[1]*v*(p[2]-z)/sqr(p[3]);
  end;


function Fac2;
  const
    epsilon=1E-20;
  begin
    if abs(z)<epsilon then Fac2:=p[1]
    else
    Fac2:=p[1]/(1+expA(p[3]*ln(abs(z/p[2]))));
  end;

procedure deriveeAC2;
  const
    epsilon=1E-20;
  var
    u,v:float;
  begin
    if abs(z)<epsilon then
      begin
        if Cl[1] then deriv[1]:=Vclamp
                 else deriv[1]:=1;
        if Cl[2] then deriv[2]:=Vclamp
                 else deriv[2]:=0;
        if Cl[3] then deriv[3]:=Vclamp
                 else deriv[3]:=0;
      end
    else
      begin
        u:=expA(p[3]*ln(z/p[2]));
        v:=u/sqr(1+u);
        if Cl[1] then deriv[1]:=Vclamp
                 else deriv[1]:=1/(1+u);
        if Cl[2] then deriv[2]:=Vclamp
                 else deriv[2]:=p[1]*p[3]*v/p[2];
        if Cl[3] then deriv[3]:=Vclamp
                 else deriv[3]:=-p[1]*v*ln(abs(z/p[2]));
      end;
  end;

function Fpolynome(z:float;p: PtabFloat1;nb:integer):float;
  var
    i:integer;
    x,z1:float;
  begin
    x:=0;
    z1:=1;
    for i:=1 to nb do
      begin
        x:=x+p[i]*z1;
        z1:=z1*z;
      end;
    Fpolynome:=x;
  end;

procedure DeriveePolynome(var z:float;
                         p: PtabFloat1;
                         Cl: PtabBoolean1;
                         deriv: PtabFloat1;
                         nb:integer);
  var
    i:integer;
    z1:float;
  begin
    z1:=1;
    for i:=1 to nb do
      begin
        if Cl[i] then deriv[i]:=Vclamp
                 else deriv[i]:=z1;
        z1:=z1*z;
      end;
  end;


function Fdroite;
  begin
    Fdroite:=Fpolynome(z,p,2);
  end;

procedure DeriveeDroite;
  begin
    deriveePolynome(z,p,Cl,deriv,2);
  end;

function FPoly2;
  begin
    FPoly2:=Fpolynome(z,p,3);
  end;

procedure DeriveePoly2;
  begin
    deriveePolynome(z,p,Cl,deriv,3);
  end;

function FPoly3;
  begin
    FPoly3:=Fpolynome(z,p,4);
  end;

procedure DeriveePoly3;
  begin
    deriveePolynome(z,p,Cl,deriv,4);
  end;

function FPoly4;
  begin
    FPoly4:=Fpolynome(z,p,5);
  end;

procedure DeriveePoly4;
  begin
    deriveePolynome(z,p,Cl,deriv,5);
  end;

function FPoly5;
  begin
    FPoly5:=Fpolynome(z,p,6);
  end;

procedure DeriveePoly5;
  begin
    deriveePolynome(z,p,Cl,deriv,6);
  end;

function FPoly6;
  begin
    FPoly6:=Fpolynome(z,p,7);
  end;

procedure DeriveePoly6;
  begin
    deriveePolynome(z,p,Cl,deriv,7);
  end;

function FPoly7;
  begin
    FPoly7:=Fpolynome(z,p,8);
  end;

procedure DeriveePoly7;
  begin
    deriveePolynome(z,p,Cl,deriv,8);
  end;

function FPoly8;
  begin
    FPoly8:=Fpolynome(z,p,9);
  end;

procedure DeriveePoly8;
  begin
    deriveePolynome(z,p,Cl,deriv,9);
  end;

function FPoly9;
  begin
    FPoly9:=Fpolynome(z,p,10);
  end;

procedure DeriveePoly9;
  begin
    deriveePolynome(z,p,Cl,deriv,10);
  end;


Function Fgauss(z:float;p: PtabFloat1;nb:integer):float;
  var
    i:integer;
    z1:float;
  begin
    z1:=0;
    for i:=1 to nb do
      z1:=z1+p[3*i-2]*expA(-0.5*sqr((z-p[3*i-1])/p[3*i]));
    Fgauss:=z1;
  end;



procedure DeriveeGauss(var z:float;
                       p: PtabFloat1;
                       Cl: PtabBoolean1;
                       deriv: PtabFloat1;nb:integer);
  var
    i:integer;
    z1,z2:float;
  begin
    for i:=1 to nb do
      begin
        z1:=expA(-0.5*sqr((z-p[3*i-1])/p[3*i]));
        z2:=p[3*i-2]*z1*(z-p[3*i-1])/sqr(p[3*i]);
        if Cl[3*i-2]
          then deriv[3*i-2]:=Vclamp
          else deriv[3*i-2]:=z1;
        if Cl[3*i-1]
          then deriv[3*i-1]:=Vclamp
          else deriv[3*i-1]:=z2;
        if Cl[3*i]
          then deriv[3*i]:=Vclamp
          else deriv[3*i]:=z2*(z-p[3*i-1])/p[3*i];
      end;
  end;



Function FGauss1;
  begin
    Fgauss1:=Fgauss(z,p,1);
  end;

procedure DeriveeGauss1;
  begin
    DeriveeGauss(z,p,Cl,deriv,1);
  end;

Function FGauss2;
  begin
    Fgauss2:=Fgauss(z,p,2);
  end;

procedure DeriveeGauss2;
  begin
    DeriveeGauss(z,p,Cl,deriv,2);
  end;

Function FGauss3;
  begin
    Fgauss3:=Fgauss(z,p,3);
  end;

procedure DeriveeGauss3;
  begin
    DeriveeGauss(z,p,Cl,deriv,3);
  end;

procedure initPoly;
  begin
    fillchar(p,sizeof(p),0);
  end;

procedure initDroite;
  var
    S,Sx,Sy,Sxy,Sx2,Sy2,delta:float;
    i:integer;

  begin
    s:=0;sx:=0;sy:=0;sxy:=0;sx2:=0;sy2:=0;
    for i:=1 to NbPts do
      begin
        s:=s+1;
        sx:=sx+x[i];
        sy:=sy+y[i];
        sxy:=sxy+x[i]*y[i];
        sx2:=sx2+x[i]*x[i];
        sy2:=sy2+y[i]*y[i];
      end;
    delta:=s*sx2-sx*sx;
    if delta>0 then
    begin
      p[1]:=(sx2*sy-sx*sxy)/delta;
      p[2]:=(sxy*s-sx*sy)/delta;
    end
    else
    begin
      p[1]:=0;
      p[2]:=0;
    end
  end;

procedure initAC1             (x,y: Ptabfloat1;
                               p: PtabFloat1;
                               NbPts,NbPara:integer);
  var
    i:integer;
  begin
    p[1]:=y[1];
    for i:=2 to NbPts do
      if y[i]>p[1] then p[1]:=y[i];
    p[2]:=0;
    p[3]:=1;
  end;


procedure initAC2              (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);
  var
    i:integer;

  begin
    p[1]:=y[1];
    for i:=2 to NbPts do
      if y[i]>p[1] then p[1]:=y[i];
    p[2]:=1;
    p[3]:=1;
  end;


procedure InitExpo             (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);
  var
    i:integer;
    NbExp:integer;
  begin
    NbExp:=nbPara div 2;
    for i:=1 to NbExp do
      begin
        p[i*2-1]:=(y[1]-y[NbPts])/NbExp;
        if abs(x[NbPts]-x[1])>1E-20 then p[i*2]:=-3.0/abs(x[NbPts]-x[1])
                                    else p[i*2]:=-1;
      end;
    if NbPara mod 2=1 then p[NbPara]:=y[NbPts];
  end;



procedure InitExpoN            (x,y: Ptabfloat1;
                                p: PtabFloat1;
                                NbPts,NbPara:integer);
  var
    i:integer;
    NbExp:integer;

  begin
    NbExp:=nbPara div 2;
    for i:=1 to NbExp do
      begin
        p[i*2-1]:=(y[1]-y[NbPts])/NbExp;
        if abs(x[NbPts]-x[1])>1E-20 then p[i*2]:=abs(x[NbPts]-x[1])/3
                                    else p[i*2]:=1;
      end;
    if NbPara mod 2=1 then p[NbPara]:=y[NbPts];
  end;

procedure initGauss;
  var
    i:integer;
    s,sy,sxy,sigma,x0,max:float;
  begin
    s:=0;sy:=0;sxy:=0;max:=0;

    for i:=1 to NbPts do
      begin
        if y[i]>max then max:=y[i];
        sy:=sy+y[i];
        sxy:=sxy+x[i]*y[i];
      end;
    x0:=sxy/sy;
    for i:=1 to NbPts do
        s:=s+sqr(x[i]-x0)*y[i];
    sigma:=sqrt(s/sy);

    for i:=1 to nbpara div 3 do
      begin
        p[3*i-2]:=max;
        p[3*i-1]:=x0;
        p[3*i]:=sigma;
      end;
  end;

{****************************************************************************}




procedure DeriveeGene(z:float;pw: PtabFloat1;const Cl:PtabBoolean1;
                       deriv: PtabFloat1;nb:integer;
                       fonc:typeFonction);
const
  eps=1E-10;
var
  i:integer;
  pw1:PtabFloat1;
begin
  getmem(Pw1,nb*sizeof(float));
  move(pw^,pw1^,nb*sizeof(float));
  for i:=1 to nb do
  begin
    if Cl[i] then deriv[i]:=Vclamp
    else
    begin
      pw1[i]:=pw1[i]+eps;
      deriv[i]:=(fonc(z,pw1)-fonc(z,pw))/eps;
      pw1[i]:=pw1[i]-eps;
    end;
  end;
end;





{****************************************************************************}


  {  Calcul de l'inverse d'une matrice carr‚e sym‚trique de dimension n }
  {  renvoie det=0 si la matrice n'est pas inversible, sinon det=1      }
  {  n'utilise aucune variable globale }

procedure MatInv(var t:typeMatrice;var det:float;n:integer);
  var
    i,j,k,l:integer;
    Ik,Jk:array of integer;
    amax,s:float;
  begin
    setlength(Ik,n+1);
    setlength(Jk,n+1);


    det:=1;
    for k:=1 to n do
      begin
                         { trouver le plus grand ‚l‚ment du tableau }
        amax:=0;
        for i:=k to n do
          for j:=k to n do
            if abs(amax)<=abs(t[i,j]) then
              begin
                amax:=t[i,j];
                Ik[k]:=i;
                Jk[k]:=j;
              end;

                         { intervertir rang‚es et colonnes pour avoir amax }
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
                         { accumuler les ‚l‚ments de la matrice inverse }
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

function KiCarre1(var a,b,c;
                 var para:PtabFloat1;
                 Nbpts:integer;
                 NbPara:integer;
                 mode:integer;
                 fonc:typeFonction):float;
  var
    x:PtabFloat1 ABSOLUTE a;
    y:PtabFloat1 ABSOLUTE b;
    SigmaY:PtabFloat1 ABSOLUTE c;
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
          7:Poids:=x[i];
          8:if x[i]<>0 then Poids:=1.0/(x[i]*x[i]) else Poids:=1;
          9:if x[i]<>0 then Poids:=1.0/abs(x[i]) else Poids:=1;
        end;
        chisqr:=chisqr+poids*sqr(y[i]-fonc(x[i],para));
      end;

    Kicarre1:=chisqr/(NbPts-NbPara);
  end;


function KiCarre(var a,b,c;
                 var para:PtabFloat1;
                 Nbpts:integer;
                 NbPara:integer;
                 mode:integer;
                 fonc:typeFonction):float;
  begin
    try
      Kicarre:=Kicarre1(a,b,c,para,Nbpts,NbPara,mode,fonc)
    except
      Kicarre:=0;
    end;
  end;

procedure curfit1(x, y, yFit, Poids, SigmaY, SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1,reg2:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);

  const
    IteraMax=30;

  var
    befor,first,fin,finB:boolean;
    Lambda,LambdaB:float;
    i,j,k,itera:integer;
    ChiSq1:float;

    Alpha:typeMatrice;
    tablo:typeMatrice;
    petit:float;
    det:float;
    Nlib:integer;

    Beta,BB,paraB: array of float;
    Deriv: array of float;

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

    setlength(alpha,nbPara+1,nbPara+1);
    setlength(tablo,nbPara+1,nbPara+1);

    setlength(Beta,nbPara+1);
    setlength(BB,nbPara+1);
    setlength(paraB,nbPara+1);
    setlength(Deriv,nbPara+1);


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
          7:Poids[i]:=x[i];
          8:if x[i]<>0 then Poids[i]:=1.0/(x[i]*x[i]) else Poids[i]:=1;
          9:if x[i]<>0 then Poids[i]:=1.0/abs(x[i]) else Poids[i]:=1;
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


      for i:=0 to nbpara do
        fillchar(alpha[i][0],(nbpara+1)*sizeof(float),0);     { Calcul de alpha et beta }
      fillchar(beta[0],(nbpara+1)*sizeof(float),0);

      for i:=1 to NbPts do
        begin
          if assigned(derivee)
            then derivee(x[i],para,paraCl,@deriv[1])
            else deriveeGene(x[i],para,paraCl,@deriv[1],nbPara,fonc);

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

        // Estimer un nouveau jeu de paramètres BB
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

        // Calculer le nouveau Chi2
        chisqr:=0;
        for i:=1 to NbPts do
          begin
            yfit[i]:=fonc(x[i],@BB[1]);
            diff:=y[i]-yfit[i];
            chisqr:=chisqr+poids[i]*diff*diff;
          end;
        chisqr:=chisqr/(Nlib);

        // S'il est meilleur
        if (Chisqr<=ChiSq1) then
          begin
            // on le garde
            for j:=1 to Nbpara do
              begin
                paraB[j]:=para[j];
                para[j]:=BB[j];
                sigmaa[j]:=sqrt(abs(tablo[j,j]/alpha[j,j]));
              end;
            first:=false;
            LambdaB:=Lambda;
            // et on continue avec Lambda divisé par 10
            Lambda:=Lambda*0.1;
            if (ChiSq1-ChiSqr)*seuil>Chisq1
              then FinB:=true
              else fin:=true;
          end
        else
        // S'il est plus mauvais
          begin
            // on continue avec Lambda multiplié multiplié par 10
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
    reg1:=coeffReg1(x,y,para,nbPts,fonc);
    reg2:=coeffRegSEB(x,y,para,nbPts,fonc);
  end; { of CurFit1 }


function curfit(  x, y, yFit, Poids, SigmaY, SigmaA:PtabFloat1;
                  para:PtabFloat1;
                  ParaCl:PtabBoolean1;
                  var ChiSqr:float;
                  var reg1,reg2:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc):boolean;

var
  exPara: array of float;

begin
  setlength(expara,nbpara+1);
  move(para^,expara[0],Nbpara*sizeof(float));

  try
    curfit1( x,y,yFit,Poids,SigmaY,SigmaA,
             para, ParaCl,
             ChiSqr,reg1,reg2,Nbpts,NbPara,
             fonc,derivee,Mode,seuil,Faff);
    result:=true;
  except
    fillchar(yfit^,  Nbpts*sizeof(float),0);
    fillchar(Poids^, Nbpts*sizeof(float),0);
    fillchar(SigmaA^,Nbpara*sizeof(float),0);

    move(Expara[0],para^,Nbpara*sizeof(float));
    Chisqr:=0;
    result:=false;
  end;
end;



function allouerFit(var a,b,c,d,e:PtabFloat1;Nbdata:integer):boolean;
var
  size:integer;
begin
  try
    size:=sizeof(float)*NbData;
    if size>=0 then
    begin
      getmem(a,size);
      getmem(b,size);
      getmem(c,size);
      getmem(d,size);
      getmem(e,size);
    end;
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

procedure desallouerFit(var a,b,c,d,e:PtabFloat1;nbData:integer);
var size:integer;
begin
  size:=sizeof(float)*NbData;
  if a<>nil then freemem(a,size);
  if b<>nil then freemem(b,size);
  if b<>nil then freemem(c,size);
  if d<>nil then freemem(d,size);
  if e<>nil then freemem(e,size);
  a:=nil;b:=nil;c:=nil;d:=nil;e:=nil;
end;

function CoeffReglin(var a,b,c,d;N,mode:integer):float;
  var
    x:PtabFloat1      ABSOLUTE a;
    y:PtabFloat1      ABSOLUTE b;
    poids:PtabFloat1  ABSOLUTE c;
    sigmaY:PtabFloat1 ABSOLUTE d;
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
                 para:^PtabFloat1;
                 nbdata,mode:integer;
                 f:typeFonction;
                 n:integer;
               end;

var
  paramChireg:^TparamChireg;

procedure calculChiReg;
  begin
    with paramChiReg^ do
    begin
      chi^:=KiCarre(x^,y^,sigmaY^,para^,nbData,n,mode,f);

      reg^:=coeffReg1(x^,y^,para^,nbData,f);
    end;
  end;

procedure parametresFonctionStandard(x0,y0:integer;
                                     numModele:integer;
                                     var para:PtabFloat1;
                                     var paraCl:PtabBoolean1;
                                     var sigmaA:PtabFloat1;
                                     var ChiSqr:float;
                                     var reg1:float;
                                     var x,y,sigmaY;
                                     nbData:integer;
                                     mode:integer);

  var
    nbpara:integer;

  begin
    nbpara:=modeleFit(numModele)^.n;

    new(paramChireg);
    paramChireg^.chi:=@chiSqr;
    paramChireg^.reg:=@reg1;
    paramChireg^.x:=@x;
    paramChireg^.y:=@y;
    paramChireg^.sigmaY:=@sigmaY;
    paramChireg^.para:=@para;
    paramChireg^.nbData:=nbData;

    paramChireg^.f:=modeleFit(numModele)^.f;
    paramChireg^.n:=modeleFit(numModele)^.n;

    paramChireg^.mode:=mode;

    {
    with funcfit1 do
    begin
      setUp(nbpara,para,paraCl,chiSqr,reg1, calculChiReg,0,nil);
      showModal;
    end;
    }
    dispose(paramChiReg);
  end;

procedure parametresFonction(x0,y0:integer;
                             n:integer;
                             f:typeFonction;
                             var nomvar;
                             Lnom:integer;
                             var para:PtabFloat1;
                             var paraCl:PtabBoolean1;
                             var sigmaA:PtabFloat1;
                             var ChiSqr:float;
                             var reg1:float;
                             var x,y,sigmaY;
                             nbData:integer;
                             mode:integer);

  begin
    new(paramChireg);
    paramChireg^.chi:=@chiSqr;
    paramChireg^.reg:=@reg1;
    paramChireg^.x:=@x;
    paramChireg^.y:=@y;
    paramChireg^.sigmaY:=@sigmaY;
    paramChireg^.para:=@para;
    paramChireg^.nbData:=nbData;
    paramChireg^.f:=f;
    paramChireg^.n:=n;
    paramChireg^.mode:=mode;

    {
    with funcfit1 do
    begin
      setUp(n,para,paraCl,chiSqr,reg1, calculChiReg,Lnom,@nomvar);
      showModal;
    end;
    }
    dispose(paramChiReg);
  end;

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

      for i:=1 to maxModele do add(modeleFit(i)^.id);
      res:=choose('Standard functions',200,numModele);
      if res>0 then numModele:=res;

      xpos:=left;
      ypos:=top;

      free;
    end;
  end;


function CoeffReg1(var a,b,c;NbPt:integer;f:typeFonction):float;
  var
    x:PtabFloat1      ABSOLUTE a;
    y:PtabFloat1      ABSOLUTE b;
    para:PtabFloat1   ABSOLUTE c;
    i:integer;
    ym,yN,yD:float;

  begin
    try
        CoeffReg1:=0;
        if NbPt<1 then exit;
        ym:=0;
        for i:=1 to NbPt do ym:=ym+y[i];
        ym:=ym/nbPt;
        yN:=0;
        yD:=0;
        for i:=1 to nbPt do
          begin
            yN:=yN+sqr(f(x[i],para)-ym);
            yD:=yD+sqr(y[i]-ym);
          end;
        if yD>1E-100 then CoeffReg1:=sqrt(yN/yD)
                     else CoeffReg1:=1;
    except
    CoeffReg1:=0;
    end;
  end;

function CoeffRegSeb(var a,b,c;NbPt:integer;f:typeFonction):float;
  var
    x:PtabFloat1      ABSOLUTE a;
    y:PtabFloat1      ABSOLUTE b;
    para:PtabFloat1   ABSOLUTE c;
    i:integer;
    ym,yD,SSE:float;

  begin
    try
        result:=0;
        if NbPt<1 then exit;
        ym:=0;
        for i:=1 to NbPt do ym:=ym+y[i];
        ym:=ym/nbPt;
        yD:=0;
        SSE:=0;
        for i:=1 to nbPt do
          begin
            SSE:=SSE+sqr(f(x[i],para)-y[i]);
            yD:=yD+sqr(y[i]-ym);
          end;


        if abs(yD)>1E-100
          then result:=1-SSE/yD
          else result:=0;

        if result>0
         then result:=sqrt(result)
         else result:=0;
    except
        result:=0;
    end;
  end;



function CoeffReg2(var a,b,c;NbPt:integer;f:typeFonction):float;
  var
    x:PtabFloat1      ABSOLUTE a;
    y:PtabFloat1      ABSOLUTE b;
    para:PtabFloat1   ABSOLUTE c;
    i:integer;
    Sx,Sy,Sxy,Sx2,Sy2:float;
    Num,Denom:float;

  begin
    try
        CoeffReg2:=0;
        if NbPt<1 then exit;
        Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;Sy2:=0;
        for i:=1 to NbPt do
          begin
            Sx:=Sx+y[i];
            Sy:=Sy+f(x[i],para);
            Sxy:=Sxy+y[i]*f(x[i],para);
            Sx2:=Sx2+sqr(y[i]);
            Sy2:=Sy2+sqr(f(x[i],para));
            Num:=NbPt*Sxy-Sx*Sy;
            Denom:=sqrt( (NbPt*Sx2-sqr(Sx))*(Nbpt*Sy2-Sqr(Sy)) );
            CoeffReg2:=Num/Denom;
          end;
    except
        CoeffReg2:=0;
    end;
  end;





function ModeleFit(num:integer):PmodeleFit;
  const
    modele:typeModeleFit=( f:Fexpo1;
                           d:DeriveeExpo1;
                           initF:initExpo;
                           n:2;
                           id:'a1*exp(a2*x)'
                         );
  begin
    case num of
      1:  with modele do
          begin
              f:=Fexpo1;
              d:=DeriveeExpo1;
              initF:=initExpo;
              n:=2;
              id:='a1*exp(a2*x)';
          end;

      2:  with modele do
          begin
              f:=Fexpo2;
              d:=DeriveeExpo2;
              initF:=initExpo;
              n:=4;
              id:='a1*exp(a2*x)+a3*exp(a4*x)';
          end;

      3:  with modele do
          begin
              f:=Fexpo3;
              d:=DeriveeExpo3;
              initF:=initExpo;
              n:=6;
              id:='a1*exp(a2*x)+a3*exp(a4*x)+a5*exp(a6*x)';
          end;

      4:  with modele do
          begin
              f:=Fexpo1B;
              d:=DeriveeExpo1B;
              initF:=initExpo;
              n:=3;
              id:='a1*exp(a2*x)+a3'
          end;

      5:  with modele do
          begin
              f:=Fexpo2B;
              d:=DeriveeExpo2B;
              initF:=initExpo;
              n:=5;
              id:='a1*exp(a2*x)+a3*exp(a4*x)+a5'
          end;

      6:  with modele do
          begin
              f:=Fexpo3B;
              d:=DeriveeExpo3B;
              initF:=initExpo;
              n:=7;
              id:='a1*exp(a2*x)+a3*exp(a4*x)+a5*exp(a6*x)+a7'
          end;

      7:  with modele do
          begin
              f:=Fac1;
              d:=DeriveeAC1;
              initF:=initAC1;
              n:=3;
              id:='a1/(1+exp((x-a2)/a3))'
          end;

      8:  with modele do
          begin
              f:=Fac2;
              d:=DeriveeAC2;
              initF:=initAC2;
              n:=3;
              id:='a1/( 1+(x/a2)^a3 )'
          end;

      9:  with modele do
          begin
              f:=Fdroite;
              d:=DeriveeDroite;
              initF:=initDroite;
              n:=2;
              id:='a1+a2*x'
          end;

      10: with modele do
          begin
              f:=Fpoly2;
              d:=DeriveePoly2;
              initF:=initPoly;
              n:=1+2;
              id:='a1+a2*x+a3*x^2'
          end;

      11: with modele do
          begin
              f:=Fpoly3;
              d:=DeriveePoly3;
              initF:=initPoly;
              n:=1+3;
              id:='a1+a2*x+a3*x^2+a4*x^3'
          end;

      12: with modele do
          begin
              f:=Fpoly4;
              d:=DeriveePoly4;
              initF:=initPoly;
              n:=1+4;
              id:='a1+a2*x+a3*x^2+a4*x^3+a5*x^4'
          end;

      13: with modele do
          begin
              f:=Fpoly5;
              d:=DeriveePoly5;
              initF:=initPoly;
              n:=1+5;
              id:='a1+a2*x+a3*x^2+a4*x^3+a5*x^4+a6*x^5'
          end;

      14: with modele do
          begin
              f:=Fpoly6;
              d:=DeriveePoly6;
              initF:=initPoly;
              n:=1+6;
              id:='a1+a2*x+a3*x^2+a4*x^3+a5*x^4+a6*x^5+a7*x^6'
          end;

      15: with modele do
          begin
              f:=Fpoly7;
              d:=DeriveePoly7;
              initF:=initPoly;
              n:=1+7;
              id:='a1+a2*x+a3*x^2+a4*x^3+a5*x^4+a6*x^5+a7*x^6+a8*x^7'
          end;

      16: with modele do
          begin
              f:=Fpoly8;
              d:=DeriveePoly8;
              initF:=initPoly;
              n:=1+8;
              id:='a1+a2*x+a3*x^2+a4*x^3+a5*x^4+a6*x^5+a7*x^6+a8*x^7+a9*x^8'
          end;

      17: with modele do
          begin
              f:=Fpoly9;
              d:=DeriveePoly9;
              initF:=initPoly;
              n:=1+9;
              id:='a1+a2*x+a3*x^2+a4*x^3+a5*x^4+a6*x^5+a7*x^6+a8*x^7+a9*x^8+a10*x^9'
          end;

      18: with modele do
          begin
              f:=Fgauss1;
              d:=DeriveeGauss1;
              initF:=initGauss;
              n:=3;
              id:='a1*exp(-0.5*( (x-a2)/a3)^2)';
          end;

      19: with modele do
          begin
              f:=Fgauss2;
              d:=DeriveeGauss2;
              initF:=initGauss;
              n:=6;
              id:='a1*exp(-0.5*( (x-a2)/a3)^2)+a4*exp(-0.5*( (x-a5)/a6)^2)';
          end;

      20: with modele do
          begin
              f:=Fgauss3;
              d:=DeriveeGauss3;
              initF:=initGauss;
              n:=9;
              id:='a1*exp(-0.5*( (x-a2)/a3)^2)'+
                  '+a4*exp(-0.5*( (x-a5)/a6)^2)+a7*exp(-0.5*( (x-a8)/a9)^2)';
          end;


      21: with modele do
          begin
              f:=FexpoN1;
              d:=DeriveeexpoN1;
              initF:=initExpoN;
              n:=2;
              id:='a1*exp(-x/a2)'
          end;

      22: with modele do
          begin
              f:=FexpoN2;
              d:=DeriveeexpoN2;
              initF:=initExpoN;
              n:=4;
              id:='a1*exp(-x/a2)+a3*exp(-x/a4)'
          end;

      23: with modele do
          begin
              f:=FexpoN3;
              d:=DeriveeexpoN3;
              initF:=initExpoN;
              n:=6;
              id:='a1*exp(-x/a2)+a3*exp(-x/a4)+a5*exp(-x/a6)'
          end;

      24: with modele do
          begin
              f:=FexpoN1B;
              d:=DeriveeexpoN1B;
              initF:=initExpoN;
              n:=3;
              id:='a1*exp(-x/a2)+a3'
          end;

      25: with modele do
          begin
              f:=FexpoN2B;
              d:=DeriveeexpoN2B;
              initF:=initExpoN;
              n:=5;
              id:='a1*exp(-x/a2)+a3*exp(-x/a4)+a5'
          end;

      26: with modele do
          begin
              f:=FexpoN3B;
              d:=DeriveeexpoN3B;
              initF:=initExpoN;
              n:=7;
              id:='a1*exp(-x/a2)+a3*exp(-x/a4)+a5*exp(-x/a6)+a7'
          end;

    end;
    modeleFit:=@modele;
  end;



end.
