unit Models1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,classes, sysutils,math,
     util1,Gdos,debug0,
     stmvec1,
     IPPdefs,IPPS,IPPSovr,
     DUlex5,NcDef2,stmVecU2,
     evalVec1;


{ TvectorEval est capable de compiler le texte suivant

  var
    h1,h2: TlinearFilter;
    f0: TNL1;
    y,y1,y2,x1,x2: Tvector;

  Model
    y1:=h1(x1);
    y2:=h2(x2);
    y:=f0(y1+y2);

  Le résultat de la compilation est un ensemble de structures arborescentes rangées dans expU.
  Chaque structure correspond à une équation.
  TvectorEval est responsable de la destruction de ces structures.

  Par contre, l'opération Derivee crée une nouvelle structure qui doit être détruite par
  le programme appelant. Cette structure n'est pas autonome puisqu'elle s'appuie sur TvectorEval.


  30 aout 2006: on rend possible les occurences multiples du même filtre.
  Le problème vient du fait que Tfilter conserve le vecteur d'entrée Input et éventuellement d'autres vecteurs
  calculés dans Evaluer. Input est souvent utilisé par evaluerDeriv.
  Donc Input devient un tableau de vecteurs. On a un vecteur par occurence.

  Les fonctions standard sont considérées comme des filtres ordinaires sans paramètres.
}



type
  TarrayOfFloat = array of float;
  TarrayOfTypeNombre = array of typeTypeG;

  Tfilter= class
             name:AnsiString;       { nom de la variable dans textPg }
             Para:PtabDouble;   { pointeur sur le début des paramètres du filtre}
             ParaMin,ParaMax:PtabDouble;
             num0:integer;      { numéro absolu du premier paramètre
                                  le premier filtre reçoit zéro }
             nbpt:integer;      { nombre de points des vecteurs }
             FilterOcc:integer; { numéro de l'occurence. Commence à zéro }
             input:array of Tvector;{ input[n]=vecteur d'entrée pour l'occurence n.
                                  Toujours conservés après evaluer }

             constructor create;virtual;
             destructor destroy;override;
             function paramCount:integer;virtual;

             function NewOcc:integer;virtual;
             {  Appelée à chaque fois que l'on crée un élément Gfilter.
                Augmente la taille des tableaux de vecteurs.
                Renvoie le numéro de la nouvelle occurence.
             }

             function LastOcc:integer;
             {  Renvoie le numéro de la dernière occurence créée
             }
             procedure evaluer(input1,output1:Tvector;numOcc:integer);virtual;
             { Calcul du vecteur de sortie à partir du vecteur d'entrée
               input1 est rangé dans input

               input1 peut être utilisé comme tampon par evaluer
             }
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);virtual;
             { numParam vaut 0,1 .. paramCount-1 pour désigner un paramètre propre au filtre
                    dans ce cas argIn vaut nil
               ou bien numparam=-1 pour désigner un paramètre externe p
                    dans ce cas argIn contient la dérivée de l'entrée par rapport à p

               La procédure doit fournir output=dérivée de la sortie par rapport à p
             }
             procedure initPara(p,pmin,pmax:pointer);
             { on donne au filtre l'adresse des tableaux de coefficients para,paramin,paramax
             }
             procedure initBounds;virtual;
             {  Le filtre peut remplir paramin et paramax si nécessaire
             }
             procedure setNbpt(nbpt1:integer);virtual;
             procedure controlevar(dd:PtabDouble);virtual;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);virtual;
             { Renseigne l'optimiseur sur la liste des paramètres attendus dans la définition du modèle.
               Le filtre doit fixer la taille des tableaux et donner pour chaque paramètre
               le type, la valeur max et la valeur min.
             }
             procedure SetParamList(var Values:TarrayOfFloat);virtual;
             { Utilisée par l'optimiseur pour ranger les valeurs des paramètres.
             }

             function paraName(i:integer):AnsiString;virtual; { l'indice commence à un }

             procedure getAux(numVec,numOcc:integer;vec:Tvector);virtual;

             procedure setConsts(vec:Tvector);virtual;
           end;

  TfilterClass=class of Tfilter;

  TexpFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TlnFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TabsFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TsqrFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;


  TsqrtFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TthreshFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TarctanFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  ThilbertFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TsinFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;

  TcosFilter=class(Tfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;


  { Pseudo filtre = paramètre constant }
  TRealFilter=
           class(Tfilter)
             constructor create;override;
             destructor destroy;override;
             procedure setNbpt(nbpt1:integer);override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             function paraName(i:integer):AnsiString;override;
           end;

  { Filtre linéaire : les coefficients forment la réponse impulsionnelle }
  Tlinearfilter=
           class(Tfilter)
             nblin:integer;    { nombre de points de la réponse impulsionnelle }
             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
           end;

  { Filtre linéaire : la réponse impulsionnelle est définie par nbCoeff paramètres
    mais on travaille avec nbCoeff*nbK points. Les points manquants sont
    obtenus par interpolation linéaire.
  }
  Tlinearfilter2=
           class(Tfilter)
             nbCoeff:integer;  { nombre de paramètres }
             nbK:integer;      { facteur de compression }
             nblin:integer;    { nombre de points de la réponse impulsionnelle }
                               { nblin = nbCoeff*nbK }

             Vtriangle:array of double;
             inputC:array of double;
             hI:array of double;

             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
           end;

  { Filtre linéaire : la réponse impulsionnelle est définie par un polynome ayant nbCoeff paramètres
    mais on travaille avec nbLin points.
  }
  TlinearfilterP=
           class(Tfilter)
             nbCoeff:integer;  { nombre de paramètres du polynome }
             nblin:integer;    { nombre de points de la réponse impulsionnelle }

             H:array of double;
             VH:array of array of double;

             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
             procedure getAux(numVec,numOcc:integer;vec:Tvector);override;
           end;

  { Filtre non linéaire statique: les coeffs sont g0 , alpha et Cte
    La sortie est y = g0*x^alpha +Cte
    x est d'abord seuillé à 1E-100
  }
  TNL1filter=
           class(Tfilter)
             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;
           end;

  { Filtre non linéaire statique: les coeffs sont g0 et alpha
    La sortie est y = g0*abs(x)^alpha
    x est d'abord seuillé à 1E-20
  }
  TNL2filter=
           class(Tfilter)
             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;
           end;

  { Filtre statique  y=f(x) :
    La fonction f est définie par nbVal points régulièrement espacés entre les abscisses min et max
    Les autre points sont obtenus par interpolation linéaire.
  }
  TstaticFilter=
           class(Tfilter)
             nbval:integer;
             min,max,deltaVal:double;
             function f(x:double):double;
             function fprim(x:double):double;

             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
           end;

  { Filtre statique  y=f(x) :
    La fonction f est définie par nbVal points d'abscisses contenues dans Xcc
    Les autre points sont obtenus par interpolation linéaire.
  }
  TstaticFilterB=
           class(Tfilter)
             Xcc:array of double;
             nbval:integer;
             function f(x:double):double;
             function fprim(x:double):double;
             function getIndex(x:double):integer;

             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;

             procedure setConsts(vec:Tvector);override;

           end;


  {Filtre linéaire pour x>0, pour x<0 , avec une non linéarité en zéro }
  TdoubleGainFilter=
           class(Tfilter)
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             function paraName(i:integer):AnsiString;override;
           end;

  { Filtre statique  y=f(x) :
    La fonction f est définie par un polynome ayant nbcoeff coefficients.
  }
  TpolyFilter=
           class(Tfilter)
             nbCoeff:integer;

             constructor create;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
           end;

  { Tsyndep implémente un filtre géré par l'équation

    tau*dV2/dt=-V2+V2max-tau*(1-fdep)*V1*V2

    v1 et v2 sont l'entrée et la sortie du filtre
    tau, V2max et fdep sont des paramètres

    En remplaçant la dérivée par V2(t)-V2(t-1), ou pour simplifier l'écriture V2-V2°
    on obtient

    V2=(tau*V2°+V2max)/(tau+1+tau*(1-fdep)*V1)
  }
  TsynDep=
           class(Tfilter)
             Vt0:array of Tvector;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;

           end;

  TlowPassFilter=
           class(Tfilter)
             Vy0:array of Tvector;
             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;
           end;

  ThighPassFilter=
           class(TlowPassfilter)
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
           end;



  Tfilter2= class(Tfilter)
             input2:array of Tvector;        { Deuxième entrée }
             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             procedure setNbpt(nbpt1:integer);override;
             procedure evaluer2(inputA1,inputA2,output1:Tvector;numOcc:integer);virtual;
           end;

  TLowPassFilter2=class(Tfilter2)
             Nmax:integer;
             KN:array of double;
             Vt0,VTnorm0,Vexp0:array of Tvector;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             function Knorm(w:double):double;
             procedure evaluer2(inputA1,inputA2,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
           end;

  TLowPassFilter2B=class(Tfilter2)
             Vt0:array of Tvector;
             K0:double;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer2(inputA1,inputA2,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;
           end;

  TLowPassFilter2C=class(Tfilter2)
             Vt0:array of Tvector;
             g1,gm,V2:double;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer2(inputA1,inputA2,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;
           end;

  TRCCell=class(Tfilter2)
             Vt0:array of Tvector;
             gm:double;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer2(inputA1,inputA2,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;
           end;

  TLPRFilter=
           class(Tfilter)
             Vy0,Vw0,Vz0:array of Tvector;
             mode:integer;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;

             procedure getAux(numVec,numOcc:integer;vec:Tvector);override;
           end;

  THLPRFilter=
           class(Tfilter)
             Vy0,Vw0,Vu0,Vz0,Vh0:array of Tvector;
             mode:integer;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;

             procedure getAux(numVec,numOcc:integer;vec:Tvector);override;
           end;

  TLPRMFilter=
           class(Tfilter)
             Vy0,Vw0,Vz0:array of Tvector;
             mode:integer;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;

             procedure getAux(numVec,numOcc:integer;vec:Tvector);override;
           end;

  THLPRMFilter=
           class(Tfilter)
             Vy0,Vw0,Vu0,Vz0,Vh0:array of Tvector;
             mode:integer;

             constructor create;override;
             destructor destroy;override;
             function NewOcc:integer;override;
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;

             class procedure GetParamList(var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);override;
             procedure SetParamList(var Values:TarrayOfFloat);override;

             procedure getAux(numVec,numOcc:integer;vec:Tvector);override;
           end;

  Tdelayfilter=
           class(Tfilter)
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             procedure initBounds;override;
           end;

  TinvertFilter=
           class(Tfilter)
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;
             procedure initBounds;override;
           end;

  TSecondOrderFilter=
           class(TlowPassfilter)
             function paramCount:integer;override;
             procedure evaluer(input1,output1:Tvector;numOcc:integer);override;
             procedure evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);override;

             procedure initBounds;override;
             function paraName(i:integer):AnsiString;override;
           end;


const
  motVar0 = variLocByte;
  motModels = varidef;
  genreFilter = variLocDef;
  genreVar = refLocDef;
  FilterType = variClass;
  motVector = refLocClass;

type
  typeGenreElem=(GEop,GEnbr,GEvari,GEfilter,GEfilterDeriv,GEfilter2);

  ptelem=^typelem ;
  PtExp=^typeExp;

  typelem=record
            case genre:typeGenreElem of
               GEop:(g,d:ptelem;opnom:typelex);
               GEnbr:(vnbr:float);
               GEvari:(mat:Tvector;exp1:ptExp);
               GEfilter:(f:Tfilter;arg:ptelem;occF:integer);
               GEfilterDeriv: ( f1:Tfilter;numP:integer;arg1:ptElem;occD:integer);
               GEfilter2:(f2:Tfilter2;argF1,argF2:ptElem;occF2:integer);
            end;

  typeExp=record
            rac:ptElem;
            FlagEval:boolean;
          end;

  TarrayInfo=record
               NbDim:integer;
               mini,maxi:array[1..100] of integer;
             end;

  TvectorEval=
          class
          private
            stMotUlex:shortString;    { Le dernier mot ramené par lireUlex }
            stMotUlexMaj:shortString; { ID en majuscules }
            genreLex:typelex;         { genre d'Ulex rameé par lireUlex }

            CurFilter:Tfilter;        { Filtre ramené par identifierMot }
            CurFilterId:integer;      { Son ID }
            CurFilterClass: TfilterClass; {Sa classe }
            CurVar:Tvector;              { vecteur ramené par identifierMot }
            x0Lex:float;              { nombre ramené par lireUlex }


            expU:TstringList;         { liste des expressions : nom + pointeur sur TypeExp }

            checksum: integer;
            
            function getFilterParam(NumAbs:integer;f:Tfilter):integer;
            procedure sortie(st:AnsiString);

            procedure lireUlex0;
            procedure lireUlex;
            procedure accepte(tp:typeLex);
            procedure identifierMot;

            procedure AddToVarList(st:AnsiString);
            procedure AddArrayToVarList(st:AnsiString;var inf:TarrayInfo);

            procedure AddToFilterList(st:AnsiString;ParValues: TarrayOfFloat);
            procedure AddArrayToFilterList(st:AnsiString;ParValues: TarrayOfFloat;var inf:TarrayInfo);

            procedure getArrayInfo(var inf:TarrayInfo);
            procedure creerVarPart;
            procedure creerModelsPart;

            procedure creerAtome(var rac:ptElem);
            procedure creerFacteur(var rac:ptElem);
            procedure creerTerme(var rac:ptElem);
            procedure creerExp(var rac:ptElem);
            procedure creerArbre1;
            procedure compiler1;

          public

            stError:AnsiString;                 { Message d'erreur }
            ligneC,colonneC:integer;        { Position courante du pointeur de lecture }
            stFile:AnsiString;
            Utext:TUtextStringList;         { gère la lecture de textPg }
            textPg:TstringList;             { Le texte à compiler }
            Ulex1:TUlex1;                   { analyseur lexical }

            FilterList:TList; { contient les Tfilter déclarés dans le pg}
            varList: TList;   { contient les Tvector déclarés dans le pg}
            ArrayList:TstringList;
            FmodelPart:boolean;

            numVar:integer;        { sert pour derivee }
            PlusDeSimp:boolean; { sert pour simplifier }

            nbpt:integer;       { nombre de pts des vecteurs }
            Pcount:integer;     { contient le nombre total de paramètres
                                  initialisé à zéro par compiler
                                }

            paraEval:Tvector;

            constructor create;
            destructor destroy;override;

            function getVar(st:AnsiString):pointer;
            function getFilter(st:AnsiString):pointer;
            function getExp(st:AnsiString):ptExp;

            procedure DetruireArbre(var rac:ptelem);
            procedure affarbre0(var f:text;var rac:ptelem);
            procedure evaluer(rac:ptelem;res:Tvector);
            procedure evaluerExp(exp1:ptExp;res:Tvector);
            procedure evaluerTOut;

            function derivee1(rac:ptelem):ptelem;
            Function derivee(rac:ptelem;num:integer):ptelem;

            procedure simplifier1(var r:ptelem);
            procedure simplifier(var r:ptelem);

            procedure Compiler;
            procedure resetPg;
            procedure DefaultFilters;

            procedure initVectors(nbpt1:integer);
            function initOK:boolean;
            procedure initPara(para1,paraMin1,paraMax1:Tvector);
            procedure initBounds;

          end;

procedure registerFilter(f:TfilterClass);

IMPLEMENTATION

{*********************** Bibliothèque pour simplifier l'écriture ********************}


procedure exp1(src: Tvector;nbpt:integer);
var
  i:integer;
begin
  for i:=1 to nbpt do src[i]:=exp(src[i]);
end;


procedure Thresh1(src: Tvector; w: float;up:boolean;nbpt:integer);
begin
  if up
    then ippsThreshold_GT(src.tbD,nbpt,w)
    else ippsThreshold_LT(src.tbD,nbpt,w);
end;

procedure AbsThresh(src:Tvector;w:float;nbpt:integer);
begin
  ippsAbs(src.tbD,nbpt);
  ippsThreshold_LT(src.tbD,nbpt,w);
end;

procedure ln1(src: Tvector;nbpt:integer);
var
  i:integer;
begin
  for i:=1 to nbpt do src[i]:=ln(src[i]);
end;


procedure exposant(src:Tvector;w:float;dest:Tvector;nbpt:integer);
var
  i:integer;
begin
  if dest<>src then dest.Vcopy(src);

  if w=2 then
  begin
    ippsSqr(dest.tbD,nbpt);
    exit;
  end;

  Thresh1(dest,1E-20,false,nbpt);     { seuil +epsilon }
  Ln1(dest,nbpt);                     { dest = Log(dest) }
  ippsMulC(w,dest.tbD,nbpt);          { dest = cc * Log(dest) }

  Thresh1(dest,100,true,nbpt);         { seuil +inf }
  Thresh1(dest,-100,false,nbpt);       { seuil -inf }

  for i:=1 to nbpt do dest[i]:=exp(dest[i]);

end;

procedure exposant1(src: Tvector;alpha:double;nbpt:integer);overload;
var
  i:integer;
begin
  Thresh1(src,1E-100,false,nbpt);         { seuil +epsilon }
  Ln1(src,nbpt);                          { y = Log(y) }
  ippsMulC(alpha,src.tbD,nbpt);           { y = alpha * Log(y) }

  Thresh1(src,100,true,nbpt);             { seuil +inf }
  Thresh1(src,-100,false,nbpt);           { seuil -inf }

  exp1(src,nbpt);
end;

procedure exposant1(src: Tvector;alpha,cte,g0:double;nbpt:integer);overload;
var
  i:integer;
begin
  Thresh1(src,1E-100,false,nbpt);         { seuil +epsilon }
  Ln1(src,nbpt);                          { y = Log(y) }
  ippsMulC(alpha,src.tbD,nbpt);           { y = alpha * Log(y) }

  Thresh1(src,100,true,nbpt);             { seuil +inf }
  Thresh1(src,-100,false,nbpt);           { seuil -inf }

  exp1(src,nbpt);
  ippsmulC(g0,src.tbD,nbpt);
  ippsaddC(cte,Pdouble(src.tb),nbpt);
end;


var
  FilterTypes:TstringList;


{ TvectorEval }

constructor TvectorEval.create;
begin
  textPg:=TstringList.create;
  Utext:=TUtextStringList.create(textPg);
  expU:=TstringList.create;
  FilterList:=Tlist.create;
  VarList:=Tlist.create;
  ArrayList:=TstringList.create;


  paraEval:=Tvector.create32(g_double,1,1);
  paraEval.ident:='ParaEval';
  paraEval.NotPublished:=true;

end;

destructor TvectorEval.destroy;
begin
  resetPg;

  paraEval.free;

  VarList.free;
  FilterList.free;

  ArrayList.free;
  expU.free;
  Utext.Free;
  textPg.free;

end;



procedure TvectorEval.identifierMot;
begin
  if stmotUlexMaj='VAR' then genrelex:=motVar0
  else
  if stmotUlexMaj='MODEL' then genrelex:=motModels
  else
  if stmotUlexMaj='TVECTOR' then genrelex:=motVector
  else
  if stmotUlexMaj='REAL' then genrelex:=motExtended
  else
  if stmotUlexMaj='ARRAY' then genrelex:=motArray
  else
  if stmotUlexMaj='OF' then genrelex:=motOF
  else
  begin
    curFilterId:=FilterTypes.indexof(stmotUlexMaj);
    if curFilterId>=0 then
    begin
      genrelex:=FilterType;
      curFilterClass:=TfilterClass(FilterTypes.Objects[curFilterId]);
    end;
  end;


  if genrelex=vid then
  begin
    curFilter:=getFilter(stMotUlex);
    if assigned(curFilter) then genrelex:=GenreFilter;
  end;

  if genrelex=vid then
  begin
    curVar:=getvar(stMotUlex);
    if assigned(curVar) then genrelex:=GenreVar;
  end;

  if genrelex=vid then genrelex:=motNouveau;
end;

procedure TvectorEval.lireUlex0;
var
  errComp:integer;
begin
  Ulex1.lire(stMotUlex,genreLex,x0lex,errComp,checksum);
  Ulex1.getLastPos(ligneC,colonneC,stFile);
  stMotUlexMaj:=Fmaj(stMotUlex);

  if errComp<>0 then sortie('Error reading text');
  if genreLex=vid then identifierMot;
end;

procedure TvectorEval.lireUlex;
var
  st:AnsiString;
begin
  lireUlex0;
  if (genreLex=motNouveau) and FmodelPart and (ArrayList.IndexOf(stMotUlexMaj)>=0) then
  begin
    st:=stMotUlex;
    lireUlex0;
    accepte(croOu);
    st:=st+'[';
    repeat
      lireUlex0;
      if genrelex<>nbi then break;
      st:=st+Istr(round(x0lex));
      lireUlex0;
      if genrelex=virgule then st:=st+','
      else
      if genrelex=croFer then st:=st+']'
      else accepte(crofer);
    until genrelex=croFer;

    genrelex:=vid;
    stMotUlex:=st;
    stMotUlexMaj:=Fmaj(st);
    identifierMot;
  end;
end;

function TvectorEval.getVar(st:AnsiString):pointer;
var
  i:integer;
begin
  st:=Fmaj(st);
  with varList do
  begin
    for i:=0 to count-1 do
    if st=Fmaj(Tvector(items[i]).ident) then
    begin
      result:=items[i];
      exit;
    end;
    result:=nil;
  end;
end;

function TvectorEval.getFilter(st:AnsiString):pointer;
var
  i:integer;
begin
  st:=Fmaj(st);
  with FilterList do
  begin
    for i:=0 to count-1 do
    if st=Fmaj(Tfilter(items[i]).name) then
    begin
      result:=items[i];
      exit;
    end;
    result:=nil;
  end;
end;

function TvectorEval.getExp(st:AnsiString):ptExp;
var
  i:integer;
begin
  i:=expU.IndexOf(Fmaj(st));
  if i>=0
    then result:=ptExp(expU.Objects[i])
    else result:=nil;
end;

var NbElem:integer;

function NewElem:ptElem;
begin
  new(result);
  fillchar(result^,sizeof(result^),0);
  inc(nbElem);
end;

function NewOp(w:typelex):ptElem;
begin
  new(result);
  fillchar(result^,sizeof(result^),0);
  result^.genre:=GEop;
  result^.opnom:=w;
  inc(nbElem);
end;

function NewNbr(w:float):ptElem;
begin
  new(result);
  fillchar(result^,sizeof(result^),0);
  result^.genre:=GEnbr;
  result^.vnbr:=w;
  inc(nbElem);
end;

procedure TvectorEval.detruireArbre(var rac:ptelem);
  begin
    if rac<>nil then
      case rac^.genre of
        GEop: begin
                detruireArbre(rac^.g);
                detruireArbre(rac^.d);
                dispose(rac);
                dec(nbElem);
              end;
        GEfilter:
              begin
                detruireArbre(rac^.arg);
                dispose(rac);
                dec(nbElem);
               end;
        GEfilter2:
              begin
                detruireArbre(rac^.argF1);
                detruireArbre(rac^.argF2);
                dispose(rac);
                dec(nbElem);
               end;

        GEnbr,GEvari:
               begin
                 dispose(rac);
                 dec(nbElem);
               end;

        GEfilterDeriv:
               begin
                 detruireArbre(rac^.arg1);
                 dispose(rac);
                 dec(nbElem);
               end;
      end;
    rac:=nil;
  end;

procedure TvectorEval.affarbre0(var f:text;var rac:ptelem);
  begin
    if rac<>nil then
      begin
        case rac^.genre of
          GEop :begin
                write(f,'(');
                Affarbre0(f,rac^.g);
                write(f,')');
                write(f,nomlex(rac^.opnom));
                write(f,'(');
                Affarbre0(f,rac^.d);
                write(f,')');
              end;

          GEnbr:write(f,Estr(rac^.vnbr,3));

          GEvari:write(f,rac^.mat.ident);

          GEfilter:
               begin
                 write(f,rac^.f.name);
                 write(f,'(');
                 Affarbre0(f,rac^.arg);
                 write(f,')');
               end;
          GEfilter2:
               begin
                 write(f,rac^.f.name);
                 write(f,'(');
                 Affarbre0(f,rac^.argF1);
                 write(f,' , ');
                 Affarbre0(f,rac^.argF2);
                 write(f,')');
               end;

          GEfilterDeriv:
               begin
                 write(f,'Deriv '+rac^.f.name+' / '+Istr(rac^.numP)+' / '+Istr(rac^.OccD));
                 if rac^.numP<0 then
                 begin
                   write(f,' Arg=');
                   affArbre0(f,rac^.arg1);
                 end;
               end;
        end;
      end
    else write(f,' nil ');
  end;

procedure TvectorEval.evaluer(rac:ptelem;res:Tvector);
var
  x,y,x2:Tvector;
begin
  x:=nil;
  y:=nil;
  if rac=nil then res.fill(0)
  else
  case rac^.genre of
    GEop :
        if rac^.opnom=expos then       {l'exposant ne vient que de la dérivation }
        try
          x:=Tvector.create32(g_double,1,nbpt);
          evaluer(rac^.g,x);
          exposant(x,rac^.d^.vnbr ,res,nbpt);
        finally
          x.Free;
        end
        else
        try
          x:=Tvector.create32(g_double,1,nbpt);
          y:=Tvector.create32(g_double,1,nbpt);
          evaluer(rac^.g,x);
          evaluer(rac^.d,y);
          case rac^.opnom of
            plus: ippsadd(x.tbD,y.tbD,res.tbD,nbpt);
            moins: ippssub(y.tbD,x.tbD,res.tbD,nbpt);
            mult: ippsmul(x.tbD,y.tbD,res.tbD,nbpt);
            divis: ippsdiv(y.tbD,x.tbD,res.tbD,nbpt);
          end;
        finally
          x.free;
          y.free;
        end;

    GEnbr:res.fill(rac^.vnbr);

    GEvari:
        begin
          if assigned(rac) and assigned(rac^.exp1) {and not rac^.exp1.FlagEval }then
          with rac^ do
          begin
            evaluer(exp1^.rac,mat);
            exp1^.FlagEval:=true;
          end;
          res.Vcopy(rac^.mat);
        end;
    GEfilter:
         if assigned(rac^.arg) then
         try
           x:=Tvector.create32(g_double,1,nbpt);
           evaluer(rac^.arg,x);
           rac^.f.evaluer(x,res,rac^.occF);
         finally
           x.free;
         end
         else rac^.f.evaluer(nil,res,rac^.occF);

    GEfilter2:
         try
           x:=nil;
           x2:=nil;

           if assigned(rac^.argF1) then
           begin
             x:=Tvector.create32(g_double,1,nbpt);
             evaluer(rac^.argF1,x);
           end;

           if assigned(rac^.argF2) then
           begin
             x2:=Tvector.create32(g_double,1,nbpt);
             evaluer(rac^.argF2,x2);
           end;

           rac^.f2.evaluer2(x,x2,res,rac^.occF2 );
         finally
           x.free;
           x2.free;
         end;


    GEfilterDeriv:
         try
           x:=Tvector.create32(g_double,1,nbpt);
           evaluer(rac^.arg1,x);
           rac^.f.evaluerDeriv(rac^.numP,x,res,rac^.occD);
         finally
           x.free;
         end;

  end;
end;

procedure TvectorEval.evaluerExp(exp1:ptExp;res:Tvector);
var
  i:integer;
  expRec:ptExp;
begin
  for i:=0 to expU.count-1 do
  begin
    expRec:=ptExp(expU.objects[i]);
    expRec^.FlagEval:=false;
  end;

  evaluer(exp1^.rac,res);
end;

procedure TvectorEval.evaluerTout;
var
  i:integer;
  expRec:ptExp;
  vec:Tvector;
begin
  for i:=0 to expU.count-1 do
  begin
    expRec:=ptExp(expU.objects[i]);
    expRec^.FlagEval:=false;
  end;

  for i:=0 to expU.count-1 do
  begin
    expRec:=ptExp(expU.objects[i]);
    vec:=getVar(expU.Strings[i]);
    if {not expRec^.FlagEval and} assigned(vec)
      then evaluer(expRec^.rac,vec);
  end;
end;


function Pnombre(n:float):Ptelem;
  var
    a:ptElem;
  begin
    a:=newElem;
    a^.genre:=GEnbr;
    a^.vnbr:=n;
    Pnombre:=a;
  end;

function Poppose(r:ptelem):ptelem;
  var
    a:ptelem;
  begin
    if r=nil then Poppose:=nil
    else
    begin
      a:=newElem;
      a^.genre:=GEop;
      a^.opnom:=moins;
      a^.g:=nil;
      a^.d:=r;
      Poppose:=a;
    end;
  end;

function Pcopie(r:ptelem):ptelem;
  var
    a:ptelem;
  begin
    if r=nil then result:=nil
    else
    begin
      a:=newElem;
      move(r^,a^,sizeof(typelem));
      case r^.genre of
        GEop: begin
                a^.g:=Pcopie(r^.g);
                a^.d:=Pcopie(r^.d);
              end;
        GEfilter:a^.arg:=Pcopie(r^.arg);
        GEfilter2:
              begin
                a^.argF1:=Pcopie(r^.argF1);
                a^.argF2:=Pcopie(r^.argF2);
              end;

        GEfilterDeriv: a^.arg1:=Pcopie(r^.arg1);
      end;
      result:=a;
    end;
  end;

function PcopieSub(r:ptelem):ptelem;
  var
    a:ptelem;
  begin
    if r=nil then result:=nil
    else
    if (r^.genre=GEvari) and assigned(r^.exp1) then result:=PcopieSub(r^.exp1^.rac)
    else
    begin
      a:=newElem;
      move(r^,a^,sizeof(typelem));
      case r^.genre of
        GEop: begin
                a^.g:=PcopieSub(r^.g);
                a^.d:=PcopieSub(r^.d);
              end;
        GEfilter:a^.arg:=PcopieSub(r^.arg);

        GEfilter2:
              begin
                a^.argF1:=PcopieSub(r^.argF1);
                a^.argF2:=PcopieSub(r^.argF2);
              end;

        GEfilterDeriv: a^.arg1:=PcopieSub(r^.arg1);
      end;
      result:=a;
    end;
  end;


function TvectorEval.derivee1(rac:ptelem):ptelem;
  var
    a,b,c,d,e,f,c1,c2:ptelem;
    k:integer;
  begin
    if rac=nil then
      begin
        derivee1:=nil;
        exit;
      end;
    case rac^.genre of
      GEop :case rac^.opnom of
            plus,moins:
              begin
                {
                a:=newElem;
                a^.genre:=GEop;
                a^.opnom:=rac^.opnom;
                a^.g:=derivee1(rac^.g);
                a^.d:=derivee1(rac^.d);
                derivee1:=a;
                }
                a:=derivee1(rac^.g);                       { u' }
                b:=derivee1(rac^.d);                       { v' }

                if (a=nil) and (b=nil) then result:=nil
                else
                if b=nil then result:=a
                else
                if (a=nil) and (rac^.opnom=plus) then result:=b
                else
                begin
                  result:=newOp(rac^.opnom);
                  result^.g:=a;
                  result^.d:=b;
                end;
              end;
            mult:
              begin
                {
                a:=newElem;b:=newElem;c:=newElem;
                a^.genre:=GEop;
                a^.opnom:=plus;
                a^.g:=b;
                a^.d:=c;

                b^.genre:=GEop;
                b^.opnom:=mult;
                b^.g:=Pcopie(rac^.g);
                b^.d:=derivee1(rac^.d);

                c^.genre:=GEop;
                c^.opnom:=mult;
                c^.g:=derivee1(rac^.g);
                c^.d:=Pcopie(rac^.d);

                derivee1:=a;
                }
                a:=derivee1(rac^.g);                       { u' }
                b:=derivee1(rac^.d);                       { v' }

                if (a=nil) and (b=nil) then result:=nil
                else
                if a=nil then
                begin
                  result:=newOp(mult);
                  result^.g:=Pcopie(rac^.g);
                  result^.d:=b;
                end
                else
                if b=nil then
                begin
                  result:=newOp(mult);
                  result^.g:=a;
                  result^.d:=Pcopie(rac^.d);
                end
                else
                begin
                  result:=newOp(plus);
                  result^.g:=newOp(mult);
                  result^.d:=newOp(mult);
                  result^.g^.g:=Pcopie(rac^.g);
                  result^.g^.d:=b;
                  result^.d^.g:=a;
                  result^.d^.d:=Pcopie(rac^.d);
                end;
              end;
            divis:
              begin
                {
                a:=newElem;b:=newElem;c:=newElem;d:=newElem;e:=newElem;f:=newElem;
                a^.genre:=GEop;
                a^.opnom:=divis;
                a^.g:=b;
                a^.d:=c;

                b^.genre:=GEop;
                b^.opnom:=moins;
                b^.g:=d;
                b^.d:=e;

                c^.genre:=GEop;
                c^.opnom:=expos;
                c^.g:=Pcopie(rac^.d);
                c^.d:=f;

                d^.genre:=GEop;
                d^.opnom:=mult;
                d^.g:=Pcopie(rac^.d);
                d^.d:=derivee1(rac^.g);

                e^.genre:=GEop;
                e^.opnom:=mult;
                e^.g:=Pcopie(rac^.g);
                e^.d:=derivee1(rac^.d);

                f^.genre:=GEnbr;
                f^.vnbr:=2;

                derivee1:=a;
                }
                a:=derivee1(rac^.g);                       { u' }
                b:=derivee1(rac^.d);                       { v' }

                if (a=nil) and (b=nil) then result:=nil
                else
                if a=nil then
                begin                       { -u*v'/v^2 }
                  result:=newop(moins);
                  result^.g:=nil;
                  result^.d:=newOp(divis);

                  result^.d^.g:=newop(mult);
                  result^.d^.g^.g:=Pcopie(rac^.g);
                  result^.d^.g^.d:=b;

                  result^.d^.d:=newop(expos);
                  result^.d^.d^.g:=Pcopie(rac^.d);
                  result^.d^.d^.d:=newNbr(2);

                end
                else
                if b=nil then
                begin                        { u'/v }
                  result:=newop(divis);
                  result^.g:=a;
                  result^.d:=Pcopie(rac^.d);
                end
                else
                begin                        { (v*u'-u*v')/v^2 }
                  result:=newop(divis);
                  result^.g:=newop(moins);
                  result^.d:=newop(expos);
                  result^.g^.g:=newop(mult);
                  result^.g^.d:=newop(mult);

                  result^.g^.g^.g:=Pcopie(rac^.d);
                  result^.g^.g^.d:=a;

                  result^.g^.d^.g:=Pcopie(rac^.g);
                  result^.g^.d^.d:=b;

                  result^.d^.g:=Pcopie(rac^.d);
                  result^.d^.d:=newNbr(2);
                end;
              end;
          end;

      GEnbr:derivee1:=nil;

      GEvari: derivee1:=nil;

      GEfilter:
        if rac^.arg=nil then         { Constante }
        begin
          if numvar=rac^.f.num0 then
          begin
            result:=newElem;
            result^.genre:=GEnbr;
            result^.vnbr:=1;
          end
          else result:=nil;
        end
        else
             { D'une façon générale, ou bien le paramètre p est un paramètre du filtre,
               ou bien c'est un paramètre extérieur qui affecte l'entrée.
               Pour un paramètre interne, le filtre calcule la dérivée connaissant l'entrée
               Pour un paramètre externe, on a:
                  dy/dp= J * dx/dp ou J est la matrice jacobienne de l'application
               qui au vecteur d'entrée x fait correspondre le vecteur de sortie y

               Le filtre est capable de calculer J mais a besoin de dx/dp, ce qu'on lui fournit
               dans l'argument.

               Il est peu vraisemblable que les deux termes soient présents.

               Exemple:     result:= df/dp  +  df/dX * dX/dp pour un filtre statique
                            result:= df/dp  +  convolution( f, dX/dp) pour un filtre linéaire

               On accroche donc:
                  FilterDeriv(p,arg=nil) + FilterDeriv(-1,arg=derivee(X)   }

        begin
          k:=getFilterParam(numvar,rac^.f); { si négatif, le premier terme est nul }
          c:=derivee1(rac^.arg);            { si nil, le second terme est nul }

          if (k<0) and (c=nil) then result:=nil
          else
          if (k>=0) and (c=nil) then         {premier terme uniquement}
          begin
            result:=newElem;
            result^.genre:=GEfilterDeriv;
            result^.f1:=rac^.f;
            result^.occD:=rac^.occF;
            result^.arg1:=nil;
            result^.numP:=k;
          end
          else
          if (k<0) and (c<>nil) then         {second terme uniquement}
          begin
            result:=newElem;
            result^.genre:=GEfilterDeriv;
            result^.f1:=rac^.f;
            result^.occD:=rac^.occF;
            result^.arg1:=c;
            result^.numP:=-1;
          end
          else
          begin                              {les deux termes}
            a:=newElem;
            a^.genre:=GEfilterDeriv;
            a^.f1:=rac^.f;
            a^.occD:=rac^.occF;
            a^.arg1:=nil;
            a^.numP:=k;

            b:=newElem;
            b^.genre:=GEfilterDeriv;
            b^.f1:=rac^.f;
            b^.occD:=rac^.occF;
            b^.arg1:=c;
            b^.numP:=-1;

            result:=newElem;
            result^.genre:=GEop;
            result^.opnom:=plus;
            result^.g:=a;
            result^.d:=b;
          end;
        end;

      GEfilter2:
             { FilterDeriv(pk,arg=nil) + FilterDeriv(-1,arg=derivee(X1) + FilterDeriv(-2,arg=derivee(X2)   }
        begin
          k:=getFilterParam(numvar,rac^.f); { si négatif, le premier terme est nul }
          c1:=derivee1(rac^.argF1);         { si nil, le second terme est nul }
          c2:=derivee1(rac^.argF2);         { si nil, le 3eme terme est nul }

          result:=nil;
          a:=nil;

          if (k>=0) then                     {premier terme }
          begin
            result:=newElem;
            result^.genre:=GEfilterDeriv;
            result^.f1:=rac^.f;
            result^.occD:=rac^.occF2;
            result^.arg1:=nil;
            result^.numP:=k;
          end;

          if (k<0) and (c1<>nil) then         {2eme terme }
          begin
            a:=newElem;
            a^.genre:=GEfilterDeriv;
            a^.f1:=rac^.f;
            a^.occD:=rac^.occF2;
            a^.arg1:=c1;
            a^.numP:=-1;

            if result=nil then result:=a      { result = a }
            else
            begin
              b:=newElem;                     {ou bien result = a + result }
              b^.genre:=GEop;
              b^.opnom:=plus;
              b^.g:=a;
              b^.d:=result;
              result:=b;
            end;
          end;

          if (k<0) and (c2<>nil) then         {3eme terme }
          begin
            a:=newElem;
            a^.genre:=GEfilterDeriv;
            a^.f1:=rac^.f;
            a^.occD:=rac^.occF2;
            a^.arg1:=c2;
            a^.numP:=-2;

            if result=nil then result:=a       { result = a }
            else
            begin
              b:=newElem;                      {ou bien result = result + a }
              b^.genre:=GEop;
              b^.opnom:=plus;
              b^.g:=a;
              b^.d:=result;
              result:=b;
            end;
          end;

        end;
      end;
  end;

function TvectorEval.derivee(rac:ptelem;num:integer):ptelem;
var
  p:ptElem;
begin
  p:=PcopieSub(rac);
  numVar:=num;
  result:=derivee1(p);
  simplifier(result);
  detruireArbre(p);
end;


function Pegal(r1,r2:ptelem):boolean;
  begin
    Pegal:=false;
  end;


procedure TvectorEval.simplifier1(var r:ptelem);
  var
    sg,sd:ptelem;
  begin
    if r=nil then exit;
    case r^.genre of
      GEnbr:if r^.vnbr=0 then
            begin
              dispose(r);
              r:=nil;
              PlusDeSimp:=false;
            end;
      GEop:begin
           simplifier1(r^.g);
           simplifier1(r^.d);
           sg:=r^.g;
           sd:=r^.d;

           case r^.opnom of
             plus:if sg=nil then         { 0+x=x }
                   begin
                     dispose(r);
                     r:=sd;
                     PlusDeSimp:=false;
                   end
                 else
                 if sd=nil then         { x+0=x }
                   begin
                     dispose(r);
                     r:=sg;
                     PlusDeSimp:=false;
                   end;
             moins:if sd=nil then         { x-0=x }
                   begin
                     dispose(r);
                     r:=sg;
                     PlusDeSimp:=false;
                   end
                 else
                 if Pegal(sd,sg) then   { x-x=0 }
                   begin
                     detruireArbre(r);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sg=nil) and (sd^.genre=GEop) and (sd^.opnom=moins) and
                 (sd^.g=nil) then
                   begin                { -(-x)=x }
                     dispose(r);
                     r:=sd^.d;
                     dispose(sd);
                     PlusDeSimp:=false;
                   end;
             mult:if sd=nil then         { x*0=0 }
                   begin
                     dispose(r);
                     detruireArbre(sg);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if sg=nil then         { 0*x=0 }
                   begin
                     dispose(r);
                     detruireArbre(sd);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sd^.genre=GEnbr) and (sd^.vnbr=1) then
                   begin
                     dispose(r);        { x*1=x }
                     dispose(sd);
                     r:=sg;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sg^.genre=GEnbr) and (sg^.vnbr=1) then
                   begin
                     dispose(r);        { 1*x=x }
                     dispose(sg);
                     r:=sd;
                     PlusDeSimp:=false;
                   end;
             divis:if sg=nil then         { 0/x=0 }
                   begin
                     dispose(r);
                     detruireArbre(sd);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if Pegal(sd,sg) then
                   begin                { x/x=1 }
                     detruirearbre(sd);
                     detruirearbre(sg);
                     dispose(r);
                     r:=Pnombre(1);
                     PlusDeSimp:=false;
                   end;
             expos:if sd=nil then         { x^0=1 }
                   begin
                     dispose(r);
                     detruireArbre(sg);
                     r:=Pnombre(1);
                     PlusDeSimp:=false;
                   end
                 else
                 if (sd^.genre=GEnbr) and (sd^.vnbr=1) then
                   begin                { x^1=x }
                     dispose(r);
                     dispose(sd);
                     r:=sg;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sg^.genre=GEnbr) and (sg^.vnbr=1) then
                   begin                { 1^x=1 }
                     detruirearbre(r);
                     r:=Pnombre(1);
                     PlusDeSimp:=false;
                   end;
           end; { of case r^.opnom }
         end;

      GEfilter:  begin
                   simplifier1(r^.arg);
                 end;

      GEfilter2: begin
                   simplifier1(r^.argF1);
                   simplifier1(r^.argF2);
                 end;

      GEfilterDeriv:
                 begin
                   simplifier1(r^.arg1);
                   (*
                   if (r^.arg1=nil) and (r^.numP=-1)  then
                   begin
                     dispose(r);
                     r:=nil;
                     PlusDeSimp:=false;
                   end;
                   *)
                 end;


      GEvari:    if r^.mat.isZero then       
                 begin
                   dispose(r);
                   r:=nil;
                    PlusDeSimp:=false;
                 end;
      
    end; { of case r^.genre }
  end; { of simplifier }

procedure TvectorEval.simplifier(var r:ptelem);
  begin
    repeat
      PlusDeSimp:=true;
      simplifier1(r);
    until plusDeSimp;
  end;



{**************************************************************************}


procedure TvectorEval.accepte(tp:typeLex);
begin
  if genrelex<>tp then sortie(nomlex(tp)+' expected');
end;

procedure TvectorEval.creerAtome(var rac:ptElem);
begin
  rac:=newElem;
  case genreLex of
    nbI,nbL,nbr:
      begin
        rac^.genre:=GEnbr;
        rac^.vnbr:=x0lex;
        lireUlex;
      end;

    genreVar:
      begin
        rac^.genre:=GEvari;
        rac^.mat:=getvar(stMotUlex);
        rac^.exp1:=getExp(stMotUlex);
        lireUlex;
      end;

    genreFilter:
      begin
        rac^.f:=getFilter(stMotUlex);
        if rac^.f is Tfilter2 then
        begin
          rac^.genre:=GEfilter2;
          rac^.occF2:= rac^.f.NewOcc;
        end
        else
        if rac^.f is TrealFilter then
        begin
          rac^.genre:=GEfilter;
          rac^.occF:=-1;
        end
        else
        begin
          rac^.genre:=GEfilter;
          rac^.occF:= rac^.f.NewOcc;
        end;

        if not (rac^.f is TrealFilter) then
        begin
          lireUlex;
          accepte(parou);
          lireUlex;
          creerExp(rac^.arg);

          if rac^.f is Tfilter2 then
          begin
            accepte(virgule);
            lireUlex;
            creerExp(rac^.argF2);
          end;

          accepte(parfer);
        end;
        lireUlex;
      end;

    else sortie('Number, var or filter expected');
  end;
end;

procedure TvectorEval.creerFacteur(var rac:ptElem);
begin
  if genrelex=parou then
  begin
    lireUlex;
    creerExp(rac);
    accepte(parfer);
    lireUlex;
  end
  else creerAtome(rac);
end;

procedure TvectorEval.creerTerme(var rac:ptElem);
var
  n1,n2,n3:ptelem;
begin
  creerFacteur(n1);
  while genreLex in [mult,divis] do
  begin
    n2:=NewOp(genrelex);
    lireUlex;
    creerFacteur(n3);

    n2^.g:=n1;
    n2^.d:=n3;
    n1:=n2;
  end;
  rac:=n1;
end;

procedure TvectorEval.creerExp(var rac:ptElem);
var
  n1,n2,n3:ptelem;

begin
  n1:=nil;
  n2:=nil;

  if genrelex=plus then
  begin
    lireUlex;
    creerTerme(n1);
  end
  else
  if genrelex=moins then
    begin
      n1:=NewElem;
      n1^.opNom:=moins;
      lireUlex;
      creerTerme(n2);
      if n2^.genre=GEnbr then
      begin
        dispose(n1);
        n1:=n2;
        n1^.vnbr:=-n1^.vnbr;
      end
      else
      begin
        n1^.g:=nil;
        n1^.d:=n2;
      end;
    end
  else
  creerTerme(n1);

  while genreLex in [plus,moins] do
  begin
      n2:=NewOp(genrelex);                { signe + ou - }
      lireUlex;                           { terme suivant }
      creerTerme(n3);

      n2^.g:=n1;
      n2^.d:=n3;
      n1:=n2;
  end;

  rac:=n1;
end;



procedure TvectorEval.creerArbre1;
var
  st1:AnsiString;
  num:pointer;
  rac:ptElem;
  ExpRec:PtExp;
begin
  accepte(genreVar);
  st1:=stMotUlexMaj;
  Num:=getVar(st1);
  lireUlex;
  accepte(DeuxPointEgal);
  lireUlex;

  CreerExp(rac);
  new(ExpRec);
  ExpRec^.rac:=rac;
  ExpRec^.FlagEval:=false;
  expU.addObject(st1,Tobject(ExpRec));
end;

procedure TvectorEval.creerModelsPart;
begin
  FmodelPart:=true;

  lireUlex;         { Ecraser Model }
  repeat
    creerArbre1;
    accepte(pointVirgule);
    lireUlex;
  until genrelex in [motvar0,motModels,finfich];
end;

procedure TvectorEval.getArrayInfo(var inf:TarrayInfo);
var
  i1,i2:Integer;
  Fmoins:boolean;

begin
  fillchar(inf,sizeof(inf),0);

  lireUlex;               {Ecarter Array}
  accepte(croOu);         {Crochet ouvert}
  repeat
    lireUlex;

    if genrelex=moins then
      begin
        lireUlex;
        Fmoins:=true;
      end
    else Fmoins:=false;
    accepte(nbi);
    if Fmoins then i1:=-round(x0lex) else i1:=round(x0lex);

    lireUlex;
    accepte(PointDouble);
    lireUlex;

    if genrelex=moins then
      begin
        lireUlex;
        Fmoins:=true;
      end
    else Fmoins:=false;
    accepte(nbi);
    if Fmoins then i2:=-round(x0lex) else i2:=round(x0lex);

    if i1>i2 then sortie('Bad array index');

    inc(inf.NbDim);
    inf.mini[inf.NbDim]:=i1;
    inf.maxi[inf.NbDim]:=i2;

    lireUlex;
  until genrelex<>virgule;
  accepte(croFer);
  lireUlex;
  accepte(motOF);
  lireUlex;
end;

procedure TvectorEval.AddToVarList(st:AnsiString);
var
  vec:Tvector;
begin
  vec:=Tvector.create32(g_double,1,1);
  vec.ident:=st;
  varList.Add(vec);
end;

type
  Tindex=array[1..100] of integer;

function nextIndex(var ind:Tindex;inf:TarrayInfo):AnsiString;
var
  i:integer;
  fini:boolean;
begin
  result:='[';
  with inf do
  begin
    for i:=1 to nbDim-1 do
      result:=result+Istr(ind[i])+',';
    result:=result+Istr(ind[nbDim])+']';
  end;

  fini:=false;

  with inf do
  begin
    i:=nbDim;
    while not fini and (i>=1) do
    begin
      inc(ind[i]);
      fini:= ind[i]<=maxi[i];
      if not fini then ind[i]:=mini[i];
      dec(i);
    end;
  end;
end;


procedure TvectorEval.AddArrayToVarList(st:AnsiString;var inf:TarrayInfo);
var
  i,nb:integer;
  index:Tindex;
begin
  nb:=1;
  with inf do
    for i:=1 to nbDim do
    begin
      index[i]:=mini[i];
      nb:=nb*(maxi[i]-mini[i]+1);
    end;

  for i:=1 to nb do
    AddToVarList(st+nextIndex(index,inf));

  ArrayList.Add(Fmaj(st));
end;

procedure TvectorEval.AddToFilterList(st:AnsiString;ParValues: TarrayOfFloat);
var
  filter:Tfilter;
begin
  filter:=curFilterClass.create;
  filter.SetParamList(ParValues);
  filter.name:=st;
  filter.num0:=Pcount;
  Pcount:=Pcount+filter.paramCount;
  FilterList.Add(filter);
end;

procedure TvectorEval.AddArrayToFilterList(st:AnsiString;ParValues: TarrayOfFloat;var inf:TarrayInfo);
var
  i,nb:integer;
  index:Tindex;
begin
  nb:=1;
  with inf do
    for i:=1 to nbDim do
    begin
      index[i]:=mini[i];
      nb:=nb*(maxi[i]-mini[i]+1);
    end;

  for i:=1 to nb do
    AddToFilterList(st+nextIndex(index,inf),parValues);

  ArrayList.Add(Fmaj(st));
end;

procedure TvectorEval.creerVarPart;
var
  i,nb:integer;
  vv:TstringList;
  ParValues: TarrayOfFloat;
  NumTypes:TarrayOfTypeNombre;
  minis,maxis: TarrayOfFloat;
  Fmoins:boolean;

  FlagArray:boolean;
  ArrayInfo:TarrayInfo;


begin
  FmodelPart:=false;

  lireUlex;                                    {Ecraser VAR}
  accepte(motNouveau);                         {Identificateur}
  vv:=TstringList.create;
  TRY
  while genrelex=motNouveau do
  begin
    vv.Clear;
    vv.add(stMotUlexMaj);
    lireUlex;
    while genrelex=Virgule do                  { virgule }
    begin
      lireUlex;
      accepte(motNouveau);
      vv.add(stMotUlexMaj);                    { ranger les mots dans vv }
      lireUlex;
    end;
    accepte(DeuxPoint);                        { deux points }
    lireUlex;

    FlagArray:=(genreLex=motArray);            { Array of.. éventuellement }
    if FlagArray then getArrayInfo(ArrayInfo);

    case genrelex of                           { puis type }
      motVector:
        with vv do
        for i:=0 to count-1 do
          if not FlagArray
            then addToVarList(strings[i])
            else addArrayToVarList(strings[i],ArrayInfo);

      motExtended:
        begin
          curFilterClass:=TrealFilter;
          with vv do
          for i:=0 to count-1 do
            if not FlagArray
              then addToFilterList(strings[i],parValues)
              else addArrayToFilterList(strings[i],parValues,ArrayInfo);
        end;

      FilterType:
        begin
          curFilterClass.GetParamList(NumTypes,minis,maxis);

          if length(numTypes)>0 then
          begin
            setLength(parvalues,length(NumTypes));

            lireUlex;
            accepte(parou);
            for i:=0 to high(NumTypes) do
            begin
              lireUlex;                     {écraser parou ou virgule}

              if genrelex=moins then
              begin
                Fmoins:=true;
                lireUlex;
              end
              else Fmoins:=false;

              case NumTypes[i] of
                g_longint: if genrelex<>nbL then accepte(nbi);
                g_extended: if (genrelex<>nbi) and (genrelex<>nbL) then accepte(nbR);
                else sortie('Unexpected filter param type');
              end;
              if Fmoins then x0lex:=-x0lex;

              ParValues[i]:=x0lex;
              if (x0lex<minis[i]) or (x0lex>maxis[i])
                then sortie('Parameter out of range');
              lireUlex;
              if i<high(NumTypes) then accepte(virgule);
            end;
            accepte(parfer);
          end;

          with vv do
          for i:=0 to count-1 do
            if not FlagArray
              then addToFilterList(strings[i],parValues)
              else addArrayToFilterList(strings[i],parValues,ArrayInfo);
        end;

      else sortie('Type name expected');
    end;

    lireUlex;
    accepte(pointVirgule);                     {point virgule}
    lireUlex;
  end;

  FINALLY
  vv.free;
  END;
end;


procedure TvectorEval.compiler1;
begin
  lireUlex;

  nbElem:=0;
  while genrelex<>finFich do
  begin
    case genrelex of
      motVar0: creerVarPart;
      motModels:  creerModelsPart;
      else sortie('VAR or MODEL expected');
    end;
  end;
end;


procedure TvectorEval.Compiler;
var
  i:integer;
  rac:ptElem;

begin

  stError:='';
  Ulex1:=TUlex1.create(Utext);
  Pcount:=0;

  resetPg;
  DefaultFilters;

  try
    compiler1;
  except
    on E: Exception do
      begin
        if stError='' then raise;
      end;
  end;

  Ulex1.Free;
  if stError<>'' then resetPg;

end;


type
  Emodel=class(exception);

procedure TvectorEval.sortie(st: AnsiString);
begin
  StError:=st;
  raise Emodel.Create('Model Exe Error');
end;

procedure TvectorEval.DefaultFilters;
var
  fonc:Tfilter;
begin
  with FilterList do
  begin
    fonc:=TexpFilter.create;
    fonc.name:='EXP';
    add(fonc);

    fonc:=TlnFilter.create;
    fonc.name:='LN';
    add(fonc);

    fonc:=TabsFilter.create;
    fonc.name:='ABS';
    add(fonc);

    fonc:=TthreshFilter.create;
    fonc.name:='THRESH';
    add(fonc);

    fonc:=TarctanFilter.create;
    fonc.name:='ATAN';
    add(fonc);

    fonc:=THilbertFilter.create;
    fonc.name:='HILBERT';
    add(fonc);

    fonc:=TsqrtFilter.create;
    fonc.name:='SQRT';
    add(fonc);

    fonc:=TsqrFilter.create;
    fonc.name:='SQR';
    add(fonc);

    fonc:=TsinFilter.create;
    fonc.name:='SIN';
    add(fonc);

    fonc:=TcosFilter.create;
    fonc.name:='COS';
    add(fonc);
  end;
end;


procedure TvectorEval.resetPg;
var
  i:integer;
  expRec:ptExp;

begin
  with FilterList do
  begin
    for i:=0 to count-1 do Tfilter(items[i]).Free;
    Clear;
  end;

  with VarList do
  begin
    for i:=0 to count-1 do Tvector(items[i]).Free;
    Clear;
  end;

  for i:=0 to expU.count-1 do
    begin
      expRec:=ptExp(expU.objects[i]);
      detruireArbre(expRec^.rac);
      dispose(expRec);
    end;

  expU.clear;
end;


function TvectorEval.getFilterParam(NumAbs: integer; f: Tfilter): integer;
var
  i:integer;
begin
  with filterList do
  begin
    i:=indexof(f);
    if i>=0 then
    begin
      result:=Numabs-Tfilter(items[i]).num0;  {numéro relatif }
      if (result<0) or (result>=Tfilter(items[i]).paramCount) then result:=-1;
    end
    else result:=-1;
  end;
end;

procedure TvectorEval.initVectors(nbpt1:integer);
var
  i:integer;
begin
  with varlist do
  for i:=0 to count-1 do
    Tvector(items[i]).modify(g_double,1,nbpt1);

  with FilterList do
  for i:=0 to count-1 do
    Tfilter(items[i]).setNbpt(nbpt1);

  nbpt:=nbpt1;
end;

function TvectorEval.initOK: boolean;
begin
  result:=(expU.count>0);
end;


procedure TvectorEval.initPara(para1,paraMin1,paraMax1:Tvector);
var
  i:integer;
begin
  paraEval.modify(paraEval.tpNum,1,Pcount);
  move(para1.tb^,paraEval.tb^,Pcount*8 );

  with FilterList do
  for i:=0 to count-1 do
    Tfilter(items[i]).initPara(paraEval.tb,paraMin1.tb,paraMax1.tb);
end;

procedure TvectorEval.initBounds;
var
  i:integer;
begin
  with FilterList do
  for i:=0 to count-1 do
    Tfilter(items[i]).initBounds;
end;


{ Tfilter }

constructor Tfilter.create;
begin

end;

destructor Tfilter.destroy;
var
  i:integer;
begin
  for i:=0 to LastOcc do input[i].Free;
  inherited;
end;


function Tfilter.paramCount: integer;
begin
  result:=0;
end;

function Tfilter.NewOcc: integer;
begin
  setLength(input,length(input)+1);
  input[LastOcc]:=Tvector.create32(g_double,1,1);
  input[LastOcc].ident:='Input';
  input[LastOcc].notPublished:=true;

  result:=LastOcc;
end;

function Tfilter.LastOcc:integer;
begin
  result:=High(input);
end;

procedure Tfilter.evaluer(input1,output1:Tvector;numOcc:integer);
begin
  move(input1.tb^,input[numOcc].tb^,nbpt*8);
end;

procedure Tfilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
begin

end;


procedure Tfilter.initPara(p,pmin,pmax: pointer);
begin
  intG(p):=intG(p)+num0*8;
  intG(pmin):=intG(pmin)+num0*8;
  intG(pmax):=intG(pmax)+num0*8;

  para:=p;
  paraMin:=pmin;
  paraMax:=pmax;

  affdebug('InitPara',29);
end;

procedure Tfilter.initBounds;
begin
end;

procedure Tfilter.setNbpt(nbpt1: integer);
var
  i:integer;
begin
  nbpt:=nbpt1;
  for i:=0 to lastOcc do input[i].modify(g_double,1,nbpt);
end;

procedure Tfilter.controlevar(dd: PtabDouble);
begin
{ Le premier paramètre est dd^[num0]
  Le second            est dd^[num0+1]
  ..
}
end;


class procedure Tfilter.GetParamList(var  NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);
begin
  setLength(NumTypes,0);
  setLength(mini,0);
  setLength(maxi,0);
end;

procedure Tfilter.SetParamList(var Values: TarrayOfFloat);
begin
end;

function Tfilter.paraName(i:integer):AnsiString;
begin
  result:=name+'-'+Istr(i);
end;

procedure Tfilter.getAux(numVec,numOcc: integer; vec: Tvector);
begin
end;

procedure Tfilter.setConsts(vec:Tvector);
begin
end;

{ TexpFilter }

procedure TexpFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;
  for i:=1 to nbpt do
    output1[i]:=exp(input1[i]);
end;

procedure TexpFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do output[i]:=exp(Vx[i])*argIn[i];
  end;
end;


{ TlnFilter }

procedure TlnFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;

  for i:=1 to nbpt do
    if input1[i]>0
      then output1[i]:=ln(input1[i])
      else output1[i]:=-1E100;
end;

procedure TlnFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do
      if Vx[i]>0
        then output[i]:=1/Vx[i]*argIn[i]
        else output[i]:=0;
  end;
end;

{ TabsFilter }

procedure TabsFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;
  for i:=1 to nbpt do
    output1[i]:=abs(input1[i]);
end;

procedure TabsFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do
      if Vx[i]>=0
        then output[i]:=argIn[i]
        else output[i]:=-argIn[i];
  end;
end;

{ TsqrFilter }

procedure TsqrFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;

  {for i:=1 to nbpt do
    output1[i]:=sqr(input1[i]); }

  ippsSqr(input1.tbD,output1.tbD,nbpt);
end;

procedure TsqrFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    {for i:=1 to nbpt do
      output[i]:=2*Vx[i]* argIn[i];
    }

    ippsMul(Vx.tbD,argin.tbD,output.tbD,nbpt);
    ippsMulC(2,output.tbD,nbpt);
  end;
end;


{ TsqrtFilter }

procedure TsqrtFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;
  for i:=1 to nbpt do
    output1[i]:=sqrt(input1[i]);
end;

procedure TsqrtFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do
      if Vx[i]>0
        then output[i]:=0.5/sqrt(Vx[i])* argIn[i]
        else output[i]:=0;
  end;
end;


{ TthreshFilter }

procedure TthreshFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;

  for i:=1 to nbpt do
    if input1[i]>0
      then output1[i]:=input1[i]
      else output1[i]:=0;
end;

procedure TthreshFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do
      if Vx[i]>=0
        then output[i]:=argIn[i]
        else output[i]:=0;
  end;
end;



{ TarctanFilter }

procedure TarctanFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;
  for i:=1 to nbpt do
    output1[i]:=arcTan(input1[i]);
end;

procedure TarctanFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do output[i]:=1/(1+sqr(Vx[i]))*argIn[i];
  end;
end;

{ THilbertFilter }

procedure THilbertFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  p1:array of single;
  p2:array of TSingleComp;
  status:integer;
  spec: PIppsHilbertSpec_32f32fc ;  { la version 64f n'existe pas! }

begin
  inherited;

  setlength(p1,nbpt);
  setlength(p2,nbpt);

  ippsConvert(Pdouble(input1.tb),@P1[0],nbpt);

  status := ippsHilbertInitAlloc(spec,nbpt, ippAlgHintNone);
  status := ippsHilbert(@p1[0],@p2[0], spec);
  ippsHilbertFree(spec);

  ippsimag(PsingleComp(@p2[0]),@p1[0],nbpt);
  ippsConvert(Psingle(@p1[0]),Pdouble(output1.tb),nbpt);
end;

procedure THilbertFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  p1:array of single;
  p2:array of TSingleComp;
  status:integer;
  spec: PIppsHilbertSpec_32f32fc ;  {la version 64 n'existe pas ! }
begin
  if numParam=-1 then
  begin
    { on se base sur le fait que
      si y(t)= Hilbert( x(t) )  alors   dy/dp=Hilbert(dx/dp)
    }
    setlength(p1,nbpt);
    setlength(p2,nbpt);

    ippsConvert(Pdouble(argin.tb),@P1[0],nbpt);

    status := ippsHilbertInitAlloc(spec,nbpt, ippAlgHintNone);
    status := ippsHilbert(@p1[0],@P2[0], spec);
    ippsHilbertFree(spec);

    ippsImag(PsingleComp(@p2[0]),@p1[0],nbpt);
    ippsConvert(Psingle(@p1[0]),Pdouble(output.tb),nbpt);
  end;
end;

{ TsinFilter }

procedure TSinFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;
  for i:=1 to nbpt do
    output1[i]:=sin(input1[i]);
end;

procedure TsinFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do output[i]:=cos(Vx[i])* argIn[i];
  end;
end;

{ TcosFilter }

procedure TcosFilter.evaluer(input1,output1:Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;
  for i:=1 to nbpt do
    output1[i]:=cos(input1[i]);
end;

procedure TcosFilter.evaluerDeriv(numParam:integer;argIN,output:Tvector;numOcc:integer);
var
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];
  if numParam=-1 then
  begin
    for i:=1 to nbpt do output[i]:=-sin(Vx[i])* argIn[i];
  end;
end;


{ Trealfilter }

constructor Trealfilter.create;
begin
end;

destructor TrealFilter.destroy;
begin
end;

procedure TrealFilter.setNbpt(nbpt1:integer);
begin
end;

procedure Trealfilter.evaluer(input1, output1: Tvector;numOcc:integer);
begin
  output1.fill(para[0]);
end;

function Trealfilter.paramCount: integer;
begin
  result:=1;
end;

function Trealfilter.paraName(i:integer):AnsiString;
begin
  result:=name;
end;

{ Tlinearfilter }

constructor Tlinearfilter.create;
begin
  inherited create;
  nblin:=1;
end;


procedure Tlinearfilter.evaluer(input1, output1: Tvector;numOcc:integer);
begin
  inherited;

  IPPStest;
  TRY
  {Le résultat du filtre linéaire est donné par une convolution}
  output1.modifyTemp((nbpt+nblin)*8);
  ippsConv(input1.tbD,nbpt,@para[0],Nblin,output1.tbD);
  output1.restoreTemp;

  FINALLY
  IPPSend;
  END;
end;

procedure Tlinearfilter.evaluerDeriv(numParam: integer; argIN,output: Tvector;numOcc:integer);
var
  ylin1:array of double;
  Vx:Tvector;
begin
  Vx:=input[numOcc];

  IPPStest;

  TRY
  if numParam=-1 then
  begin
    { Comme y(t)=h(t)*x(t) (convolution de l'entrée avec la réponse impulsionnelle)
      on a
      dy/dp = h(t) * dx/dp (convolution de ArgIn avec la réponse impulsionnelle)
    }
    setLength(ylin1,nbpt+nblin);
    ippsConv(argIN.tbD,nbpt,@para[0],Nblin,@ylin1[0]);
    move(ylin1[0],output.tb^,nbpt*8);
  end
  else
  begin
    { dy/dai est donné par un décalage du vecteur d'entrée de i unités }
    output.fill(0);
    move(Vx.getP(1)^,output.getP(1+numParam)^,(nbpt-numParam)*8);
  end;

  FINALLY
    IPPSend;
    setlength(ylin1,0);
  END;
end;


function Tlinearfilter.paramCount: integer;
begin
  result:=nblin;
end;

class procedure Tlinearfilter.GetParamList( var NumTypes: TarrayOfTypeNombre;var mini,maxi:TarrayOfFloat);
begin
  setLength(NumTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=0;
  maxi[0]:=100000;
end;

procedure Tlinearfilter.SetParamList(var Values: TarrayOfFloat);
begin
  inherited;
  nblin:=round(values[0]);
end;

{ TNL1filter }

constructor TNL1filter.create;
begin
  inherited create;
end;

procedure TNL1filter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  g0,alpha,cte:double;
begin
  inherited;

  IPPStest;
  TRY

  g0:=para^[0];
  alpha:=para^[1];
  cte:=para^[2];

  output1.Vcopy(input1);
  exposant1(output1,alpha,cte,g0,nbpt);

  FINALLY
  IPPSend;
  END;

end;

procedure TNL1filter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  Mdum:Tvector;
  g0,alpha,cte:double;
  Vx:Tvector;
begin
  Vx:=input[numOcc];

  IPPStest;

  TRY
  g0:=para^[0];
  alpha:=para^[1];
  cte:=para^[2];

  case numParam of
    -1:  begin
           output.Vcopy(Vx);
           exposant1(output,alpha-1,0,g0*alpha,nbpt);      { g0*alpha*exposant(alpha-1)  = dy/dX }
           ippsmul(argin.tbD,output.tbD,nbpt);             { * argin                      *dX/dp }
         end;

    0:   begin      { g0 }
           output.Vcopy(Vx);
           exposant1(output,alpha,nbpt);      { dy/dg0 = exposant(alpha) }
         end;

    1:   begin      { alpha }
           output.Vcopy(Vx);
           exposant1(output,alpha,0,g0,nbpt);
           Mdum:=Tvector.create32(g_double,1,nbpt);
           try
           Mdum.Vcopy(Vx);
           Thresh1(Mdum,1E-20,false,nbpt);          { seuil +epsilon }
           ln1(Mdum,nbpt);
           ippsmul(Mdum.tbD,output.tbD,nbpt);       { dy/dalpha = g0*exposant(alpha) * ln(x)}
           finally
           Mdum.free;
           end;
         end;


    2:   begin     {cte}
           output.Vcopy(Vx);
           output.fill(1);
         end;
  end;
  FINALLY
    IPPSend;
  END;
end;

function TNL1filter.paramCount: integer;
begin
  result:=3;
end;

procedure TNL1filter.initBounds;
begin
  paraMin[0]:=0.01;  { limiter g0 entre 0.01 et 100 }
  paraMax[0]:=100;

  paraMin[1]:=0.1;  { limiter alpha entre 0.1 et 5 }
  paraMax[1]:=5;
end;

function TNL1filter.paraName(i:integer):AnsiString;
begin
  case i of
    1: result:=name+'-g0';
    2: result:=name+'-alpha';
    3: result:=name+'-Cte';
  end;
end;

{ TNL2filter }


constructor TNL2filter.create;
begin
  inherited create;
end;

procedure TNL2filter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  g0,alpha:double;
begin
  inherited;

  IPPStest;
  TRY

  g0:=para^[0];
  alpha:=para^[1];

  output1.Vcopy(input1);
  AbsThresh(output1,1E-20,nbpt);
  exposant1(output1,alpha,0,g0,nbpt);

  FINALLY
  IPPSend;
  END;

end;

procedure TNL2filter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  Mdum:Tvector;
  g0,alpha:double;
  i:integer;
  Vx:Tvector;
begin
  Vx:=input[numOcc];

  IPPStest;

  TRY
  g0:=para^[0];
  alpha:=para^[1];

  case numParam of
    -1:  begin
           output.Vcopy(Vx);
           AbsThresh(output,1E-20,nbpt);
           exposant1(output,alpha-1,0,g0*alpha,nbpt);         { g0*alpha*exposant(alpha-1)  = dy/dX }

           with Vx do
           for i:=Istart to Iend do
             if Yvalue[i]<0 then output[i]:=-output[i]; {*sgn(input}

           ippsmul(argin.tbD,output.tbD,nbpt);                { * argin                      *dX/dp }
         end;

    0:   begin      { g0 }
           output.Vcopy(Vx);
           AbsThresh(output,1E-20,nbpt);
           exposant1(output,alpha,nbpt);      { dy/dg0 = exposant(alpha) }
         end;

    1:   begin      { alpha }
           output.Vcopy(Vx);
           AbsThresh(output,1E-20,nbpt);
           exposant1(output,alpha,0,g0,nbpt);
           Mdum:=Tvector.create32(g_double,1,nbpt);
           try
           Mdum.Vcopy(Vx);
           Thresh1(Mdum,1E-20,false,nbpt);          { seuil +epsilon }
           ln1(Mdum,nbpt);
           ippsmul(Mdum.tbD,output.tbD,nbpt);             { dy/dalpha = *exposant(alpha) * ln(x)}
           finally
           Mdum.free;
           end;
         end;

  end;

  FINALLY
    IPPSend;
  END;
end;

function TNL2filter.paramCount: integer;
begin
  result:=2;
end;

procedure TNL2filter.initBounds;
begin
  paraMin[0]:=0.01;  { limiter g0 entre 0.01 et 100 }
  paraMax[0]:=100;

  paraMin[1]:=0.1;  { limiter alpha entre 0.1 et 5 }
  paraMax[1]:=5;
end;

function TNL2filter.paraName(i:integer):AnsiString;
begin
  case i of
    1: result:=name+'-g0';
    2: result:=name+'-alpha';
  end;
end;

{ TStaticFilter }

constructor TStaticFilter.create;
begin
  inherited create;
  nbVal:=2;
  min:=0;
  max:=1;
  deltaVal:=(max-min)/(nbval-1);
end;

function TStaticFilter.f(x:double):double;
var
  i:integer;
begin
  if x<min then x:=min
  else
  if x>max then x:=max;

  i:=trunc((x-min)/DeltaVal);
  if i<nbval-1
    then result:=para^[i]+ (para^[i+1]-para^[i])/deltaVal*(x-i*deltaVal-min)
    else result:=para^[nbval-1];
end;

function TStaticFilter.fprim(x:double):double;
var
  i:integer;
begin
  if (x<min) or (x>=max) then result:=0
  else
  begin
    i:=trunc((x-min)/DeltaVal);
    result:=(para[i+1]-para[i])/deltaVal;
  end;
end;


procedure TStaticFilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;

  for i:=1 to nbpt do
    output1[i]:=f(input1[i]);
end;

procedure TStaticFilter.evaluerDeriv(numParam: integer; argIN,output: Tvector;numOcc:integer);
var
  i,k:integer;
  x:double;
  Vx:Tvector;
begin
  Vx:=input[numOcc];

  if numParam=-1 then
  begin
    for i:=1 to nbpt do
      output[i]:=fprim(Vx[i]);
    ippsmul(argin.tbD,output.tbD,nbpt);     { * argin             *dX/dp }
  end
  else
  begin
    output.fill(0);

    for i:=1 to nbpt do
    begin
      x:=Vx[i];
      if x<min then x:=min
      else
      if x>max then x:=max;
      k:=trunc((x-min)/DeltaVal);
      if (numParam=k) then output[i]:=1-(x-k*deltaval-min)/deltaVal
      else
      if (numParam=k+1) then output[i]:=(x-k*deltaval-min)/deltaVal;
    end;
  end;

end;

function TStaticFilter.paramCount: integer;
begin
  result:=nbval;
end;


class procedure TstaticFilter.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,3);
  setLength(mini,3);
  setLength(maxi,3);

  NumTypes[0]:=g_longint;
  mini[0]:=2;
  maxi[0]:=100000;

  NumTypes[1]:=g_extended;
  mini[1]:=-1E100;
  maxi[1]:=1E100;

  NumTypes[2]:=g_extended;
  mini[2]:=-1E100;
  maxi[2]:=1E100;

end;

procedure TstaticFilter.SetParamList(var Values: TarrayOfFloat);
begin
  nbval:=round(Values[0]);
  min:=Values[1];
  max:=Values[2];
  deltaVal:=(max-min)/(nbVal-1);

end;


{ TStaticFilterB }

constructor TStaticFilterB.create;
begin
  inherited create;
  nbVal:=2;
  setLength(Xcc,nbval);
end;

function TStaticFilterB.getIndex(x:double):integer;
var
  min,max,k:integer;
  x1:double;
begin
  min:=0;
  max:=nbval-1;
  if x<=Xcc[min] then
    begin
      result:=min;
      exit;
    end
  else
  if x>Xcc[max] then
    begin
      result:=max;
      exit;
    end;

  repeat
    k:=(max+min) div 2;
    x1:=Xcc[k];
    if x1<x then min:=k
    else
    if x1>x then max:=k;
  until (max-min<=1) or (x=x1);
  if x=x1 then result:=k
          else result:=min;
end;



function TStaticFilterB.f(x:double):double;
var
  i:integer;
begin
  i:=getIndex(x);

  if i<nbval-1
    then result:=para^[i]+ (para^[i+1]-para^[i])/(Xcc[i+1]-Xcc[i])* (x-Xcc[i])
    else result:=para^[nbval-1];
end;

function TStaticFilterB.fprim(x:double):double;
var
  i:integer;
begin
  if (x<Xcc[0]) or (x>=Xcc[nbval-1]) then result:=0
  else
  begin
    i:=getIndex(x);
    result:=(para[i+1]-para[i])/(Xcc[i+1]-Xcc[i]);
  end;
end;


procedure TStaticFilterB.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
begin
  inherited;

  for i:=1 to nbpt do
    output1[i]:=f(input1[i]);
end;

procedure TStaticFilterB.evaluerDeriv(numParam: integer; argIN,output: Tvector;numOcc:integer);
var
  i,k:integer;
  x:double;
  Vx:Tvector;
begin
  Vx:=input[numOcc];

  if numParam=-1 then
  begin
    for i:=1 to nbpt do
      output[i]:=fprim(Vx[i]);
    ippsmul(argin.tbD,output.tbD,nbpt);     { * argin             *dX/dp }
  end
  else
  begin
    output.fill(0);

    for i:=1 to nbpt do
    begin
      x:=Vx[i];
      if x<Xcc[0] then x:=Xcc[0]
      else
      if x>Xcc[nbval-1] then x:=Xcc[nbval-1];
      k:=getIndex(x);

      if (numParam=k) then output[i]:=1-(x-Xcc[k])/(Xcc[k+1]-Xcc[k])
      else
      if (numParam=k+1) then output[i]:=(x-Xcc[k])/(Xcc[k+1]-Xcc[k]);
    end;
  end;

end;

function TStaticFilterB.paramCount: integer;
begin
  result:=nbval;
end;


class procedure TstaticFilterB.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=2;
  maxi[0]:=100000;
end;

procedure TstaticFilterB.SetParamList(var Values: TarrayOfFloat);
begin
  nbval:=round(Values[0]);
  setLength(Xcc,nbVal);
  fillchar(Xcc[0],sizeof(Xcc[0])*nbval,0);
end;

procedure TstaticFilterB.setConsts(vec:Tvector);
var
  i:integer;
begin
  with vec do
  if Icount>=nbVal then
  for i:=0 to nbval-1 do
    Xcc[i]:=Yvalue[Istart+i];
end;


{ TpolyFilter }

constructor TpolyFilter.create;
begin
  inherited;

end;

procedure TpolyFilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i,j:integer;
  x,x1,w:double;
begin
  inherited;
  for i:=1 to nbpt do
  begin
    x:=input1[i];
    x1:=1;
    w:=0;
    for j:=0 to nbcoeff-1 do
    begin
      w:=w+para[j]*x1;
      x1:=x1*x;
    end;

    output1[i]:=w;
  end;
end;

procedure TpolyFilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  x,x1,w:double;
  Vx:Tvector;
begin
  Vx:=input[numOcc];

  if numParam=-1 then
  begin
    for i:=1 to nbpt do
    begin
      x:=Vx[i];
      x1:=1;
      w:=0;
      for j:=1 to nbcoeff-1 do
      begin
        w:=w+j*para[j]*x1;
        x1:=x1*x;
      end;
      output[i]:=w;
    end;

    ippsmul(argin.tbD,output.tbD,nbpt);            { * argin             *dX/dp }
  end
  else
  begin
    output.fill(1);
    for i:=1 to numParam do
      ippsmul(Vx.tbD,output.tbD,nbpt);

  end;
end;


class procedure TpolyFilter.GetParamList(var NumTypes: TarrayOfTypeNombre;var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=1;
  maxi[0]:=100000;
end;

function TpolyFilter.paramCount: integer;
begin
  result:=nbCoeff;
end;

procedure TpolyFilter.SetParamList(var Values: TarrayOfFloat);
begin
  nbCoeff:=round(Values[0]);
end;


{ TsynDep }

constructor TsynDep.create;
begin
  inherited;
end;

destructor TsynDep.destroy;
var
  i:integer;
begin
  inherited;
  for i:=0 to high(Vt0) do Vt0[i].free;
end;

function TsynDep.NewOcc: integer;
begin
  result:=inherited NewOcc;

  setLength(Vt0,LastOcc+1);
  Vt0[LastOcc]:=Tvector.create32(g_double,1,1);
  Vt0[LastOcc].ident:='Vt';
  Vt0[LastOcc].notPublished:=true;
end;

procedure TsynDep.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i,j:integer;
  tau,fdep,V2max:double;
begin
  inherited;

  tau:=para^[0];
  fdep:=para^[1];
  V2max:=para^[2];


  output1[1]:=V2max/(tau+1+tau*(1-fdep)*input1[1]);

  for i:=2 to nbpt do
    output1[i]:=(tau*output1[i-1]+V2max)/(tau+1+tau*(1-fdep)*input1[i]);

  Vt0[NumOcc].Vcopy(output1);
end;

procedure TsynDep.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  tau,fdep,V2max:double;
  dd:double;
  Vx,Vt:Tvector;
begin
  Vx:=input[numOcc];
  Vt:=Vt0[numOcc];

  tau:=para^[0];
  fdep:=para^[1];
  V2max:=para^[2];

  case numParam of
    -1: begin
          for i:=1 to nbpt do
          begin
            dd:=tau+1+tau*(1-fdep)*Vx[i];
            if i>1
              then output[i]:=(dd*tau*output[i-1]-(tau*Vt[i-1]+V2max)*tau*(1-fdep)*Argin[i])/sqr(dd)
              else output[i]:=(V2max*tau*(1-fdep)*Argin[i])/sqr(dd)
          end;
         end;

      0: begin { tau }
          for i:=1 to nbpt do
          begin
            dd:=tau+1+tau*(1-fdep)*Vx[i];
            if i>1
              then output[i]:=(dd*(Vt[i-1]+tau*output[i-1]) -(tau*Vt[i-1]+V2max)*(1+(1-fdep)*Vx[i]))/sqr(dd)
              else output[i]:=(-V2max*(1+(1-fdep)*Vx[i]))/sqr(dd);
          end;
         end;

      1: begin { fdep }
          for i:=1 to nbpt do
          begin
            dd:=tau+1+tau*(1-fdep)*Vx[i];
            if i>1
              then output[i]:=(dd* tau*output[i-1] +(tau*Vt[i-1]+V2max)* tau*Vx[i])/sqr(dd)
              else output[i]:=(V2max*tau*Vx[i])/sqr(dd);
          end;

         end;

      2: begin { V2max }
          for i:=1 to nbpt do
          begin
            dd:=tau+1+tau*(1-fdep)*Vx[i];
            if i>1
              then output[i]:=(tau*output[i-1]+1)/dd
              else output[i]:=1/dd;
          end;
         end;
  end;
end;



procedure TsynDep.initBounds;
begin
  paramin[0]:=0;
  paramax[0]:=1E9;

  paramin[1]:=0;
  paramax[1]:=1;

  paramin[2]:=0;
  paramax[2]:=0;

end;

function TsynDep.paramCount: integer;
begin
  result:=3;
end;

function TsynDep.paraName(i: integer): AnsiString;
begin
  case i of
    0 : result:='tau';
    1 : result:='fdep';
    2 : result:='V2max';
  end;
end;


{ TlowPassFilter }

constructor TlowPassFilter.create;
begin
  inherited;

end;

destructor TlowPassFilter.destroy;
var
  i:integer;
begin
  inherited;
  for i:=0 to high(Vy0) do Vy0[i].free;
end;

function TlowPassFilter.NewOcc: integer;
begin
  result:=inherited NewOcc;

  setLength(Vy0,LastOcc+1);
  Vy0[LastOcc]:=Tvector.create32(g_double,1,1);
  Vy0[LastOcc].ident:='Vy';
  Vy0[LastOcc].notPublished:=true;
end;


procedure TlowPassFilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  Vx,Vy:Tvector;
  b0:double;
begin
  inherited;
  Vx:=input1;
  Vy:=Vy0[numOcc];

  Vy.modify(g_double,1,nbpt);

  b0:=para^[0];
  Vy[1]:=Vx[1];
  for i:=2 to nbpt do
    Vy[i]:=(1-b0)*Vx[i]+b0*Vy[i-1];

  output1.Vcopy(Vy);
end;

procedure TlowPassFilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  b0:double;
  Vx,Vy,Vdxdp,Vdydp:Tvector;
begin

  b0:=para^[0];

  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];

  Vdxdp:=argIn;
  Vdydp:=output;

  Vdydp[1]:=0;

  case numParam of
    -1: begin
          for i:=2 to nbpt do
          begin
            Vdydp[i]:=(1-b0)*Vdxdp[i]+b0*Vdydp[i-1];
          end;
         end;

     0: begin { b }
          for i:=2 to nbpt do
          begin
            Vdydp[i]:=(1-b0)*Vdxdp[i] -Vx[i] +b0*Vdydp[i-1] +Vy[i-1];
          end;
        end;
  end;




end;



procedure TlowPassFilter.initBounds;
begin
  paramin[0]:=1E-12;
  paramax[0]:=1-1E-12;
end;

function TlowPassFilter.paramCount: integer;
begin
  result:=1;
end;

function TlowPassFilter.paraName(i: integer): AnsiString;
begin
  case i of
    0 : result:='b';
  end;
end;


{ ThighPassFilter }

procedure ThighPassFilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  Vx,Vy:Tvector;
  b0:double;
begin
  inherited;
  Vx:=input1;
  Vy:=Vy0[numOcc];

  Vy.modify(g_double,1,nbpt);

  b0:=para^[0];
  Vy[1]:=0;
  for i:=2 to nbpt do
    Vy[i]:=b0*Vy[i-1]+ Vx[i]-Vx[i-1] ;

  output1.Vcopy(Vy);
end;

procedure ThighPassFilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  b0:double;
  Vx,Vy,Vdxdp,Vdydp:Tvector;
begin
  b0:=para^[0];

  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];

  Vdxdp:=argIn;
  Vdydp:=output;

  Vdydp[1]:=0;

  case numParam of
    -1: begin
          for i:=2 to nbpt do
          begin
            Vdydp[i]:=b0*Vdydp[i-1] + Vdxdp[i]-Vdxdp[i-1] ;
          end;
         end;

     0: begin { b }
          for i:=2 to nbpt do
          begin
            Vdydp[i]:= b0*Vdydp[i-1] +Vy[i-1];
          end;
        end;
  end;
end;




{ TLPRfilter }

constructor TLPRfilter.create;
begin
  inherited;


end;

destructor TLPRfilter.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vy0) do
  begin
    Vy0[i].free;
    Vw0[i].free;
    Vz0[i].free;
  end;
end;

function TLPRfilter.NewOcc:integer;
begin
  result:=inherited NewOcc;

  setLength(Vy0,LastOcc+1);
  Vy0[LastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vy0[LastOcc].NotPublished:=true;

  setLength(Vw0,LastOcc+1);
  Vw0[LastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vw0[LastOcc].NotPublished:=true;

  setLength(Vz0,LastOcc+1);
  Vz0[LastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vz0[LastOcc].NotPublished:=true;

end;

procedure TLPRfilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  b0,G0,C0:double;
  Vx,Vy,Vw,Vz:Tvector;

  tot:double;
  Nmoy:integer;
begin
  inherited;

  Vx:=input1;
  Vy:=Vy0[numOcc];
  Vw:=Vw0[numOcc];
  Vz:=Vz0[numOcc];

  Vy.modify(g_double,1,nbpt);
  Vw.modify(g_double,1,nbpt);
  Vz.modify(g_double,1,nbpt);

  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input1;

  Vy[1]:=0;
  Vz[1]:=0;

  tot:=0;
  Nmoy:=round(b0);

  case mode of
    0:for i:=2 to nbpt do
      begin
        Vw[i]:=sqr(Vy[i-1]);
        Vz[i]:=(1-b0)*Vw[i]+b0*Vz[i-1];

        Vy[i]:=G0*Vx[i]/(Vz[i]+ C0);
      end;

    1:begin
        proVhilbert(Vx,Vw);
        for i:=1 to nbpt do
          Vw[i]:=sqrt(sqr(Vw[i])+sqr(Vx[i]));

        for i:=2 to nbpt do
        begin
          Vz[i]:=Vw[i]+b0*Vz[i-1];

          Vy[i]:=G0*Vx[i]/(Vz[i]+ C0);
          {Vw[i]:=sqr(Vy[i-1]);

          tot:=tot+Vw[i];
          if i>Nmoy then
          begin
            tot:=tot-Vw[i-Nmoy];
            Vz[i]:=tot/Nmoy;
          end
          else
          begin
            Vz[i]:=tot/i;
          end;

          Vy[i]:=G0*Vx[i]/(Vz[i]+ C0);
          }
        end;
      end;
  end;

  output1.Vcopy(Vy);
end;

procedure TLPRfilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  b0,G0,C0:double;
  Vx,Vy,Vz,Vw,Vdxdp,Vdydp:Tvector;
  dzdp,dwdp:double;
begin
  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];
  Vz:=Vz0[numOcc];
  Vw:=Vw0[numOcc];
  Vdxdp:=argIn;
  Vdydp:=output;

  dzdp:=0;
  dwdp:=0;
  Vdydp[1]:=0;

  case numParam of
    -1: begin
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp+b0*dzdp;
            Vdydp[i]:=G0/(Vz[i]+C0)*Vdxdp[i] -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp;
          end;
         end;

      0: begin { b }
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp -Vw[i] +b0*dzdp +Vz[i-1];
            Vdydp[i]:= -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp;
          end;
         end;

      1: begin { G }
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp+b0*dzdp ;
            Vdydp[i]:= Vx[i]/(Vz[i]+C0) -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp; ;
          end;
         end;

      2: begin { C }
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp+b0*dzdp ;
            Vdydp[i]:= -G0/sqr(Vz[i]+C0)*Vx[i] -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp;
          end;
         end;
  end;
end;



procedure TLPRFilter.getAux(numVec,numOcc: integer; vec: Tvector);
begin
  vec.Vcopy(Vz0[numOcc]);
end;


procedure TLPRfilter.initBounds;
begin
  inherited;

  case mode of
    0,1: begin
         paramin[0]:=0.1;
         paramax[0]:=1-1E-12;
       end;
    {
    1: begin
         paramin[0]:=1;
         paramax[0]:=1000;
       end;
    }
  end;

  paramin[1]:=1E-9;
  paramax[1]:=1E20;

  paramin[2]:=1E-9;
  paramax[2]:=1E20;
end;

function TLPRfilter.paramCount: integer;
begin
  result:=3;
end;

function TLPRfilter.paraName(i: integer): AnsiString;
begin
  case i of
    0 : result:='b';
    1 : result:='G';
    2 : result:='C';
  end;
end;

class procedure TLPRFilter.GetParamList(var NumTypes: TarrayOfTypeNombre;
  var mini, maxi: TarrayOfFloat);
begin
  setLength(numTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=0;
  maxi[0]:=1;

end;

procedure TLPRFilter.SetParamList(var Values: TarrayOfFloat);
begin
  mode:=round(Values[0]);
end;


{***************************************************}


{ THLPRfilter }

constructor THLPRfilter.create;
begin
  inherited;
end;

destructor THLPRfilter.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vy0) do
  begin
    Vy0[i].free;
    Vw0[i].free;
    Vz0[i].free;
    Vu0[i].free;
    Vh0[i].Free;
  end;
end;

function THLPRfilter.newOcc:integer;
begin
  result:=inherited newOcc;

  setLength(Vy0,lastOcc+1);
  Vy0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vy0[lastOcc].NotPublished:=true;

  setLength(Vw0,lastOcc+1);
  Vw0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vw0[lastOcc].NotPublished:=true;

  setLength(Vz0,lastOcc+1);
  Vz0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vz0[lastOcc].NotPublished:=true;

  setLength(Vu0,lastOcc+1);
  Vu0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vu0[lastOcc].NotPublished:=true;

  setLength(Vh0,lastOcc+1);
  Vh0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vh0[lastOcc].NotPublished:=true;
end;

procedure THLPRfilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  b0,G0,C0:double;
  Vx,Vy,Vw,Vz,Vu,Vh:Tvector;

begin
  inherited;

  Vy:=Vy0[numOcc];
  Vw:=Vw0[numOcc];
  Vz:=Vz0[numOcc];
  Vu:=Vu0[numOcc];
  Vh:=Vh0[numOcc];

  Vy.modify(g_double,1,nbpt);
  Vw.modify(g_double,1,nbpt);
  Vz.modify(g_double,1,nbpt);
  Vu.modify(g_double,1,nbpt);
  Vh.modify(g_double,1,nbpt);

  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input1;

  Vy[1]:=0;
  Vz[1]:=0;

  proVhilbert(Vx,Vh);

  case mode of
    0:for i:=2 to nbpt do
      begin
        Vw[i]:=sqrt(sqr(Vy[i-1]) +  sqr(Vu[i-1]));
        Vz[i]:=(1-b0)*Vw[i]+b0*Vz[i-1];

        Vy[i]:=G0*Vx[i]/(Vz[i]+ C0);


        Vu[i]:=G0*Vh[i]/(Vz[i]+ C0);
      end;

    1:for i:=2 to nbpt do
      begin
        Vw[i]:=sqr(Vy[i-1]) +  sqr(Vu[i-1]);
        Vz[i]:=(1-b0)*Vw[i]+b0*Vz[i-1];

        Vy[i]:=G0*Vx[i]/(Vz[i]+ C0);


        Vu[i]:=G0*Vh[i]/(Vz[i]+ C0);
      end;
  end;

  output1.Vcopy(Vy);
end;

{Hilbert pour deux vecteurs de doubles initialisés de 1 à N }
procedure Hilbert(src,dest:Tvector);
var
  p1:array of single;
  p2:array of TSingleComp;
  status:integer;
  spec: PIppsHilbertSpec_32f32fc ;  {la version 64 n'existe pas ! }
  nbpt:integer;
begin
  nbpt:=src.Icount;
  setlength(p1,nbpt);
  setlength(p2,nbpt);

  ippsConvert(Pdouble(src.tb),@P1[0],nbpt);

  status := ippsHilbertInitAlloc(spec,nbpt, ippAlgHintNone);
  status := ippsHilbert(@p1[0],@P2[0], spec);
  ippsHilbertFree(spec);

  ippsImag(PsingleComp(@p2[0]),@p1[0],nbpt);
  ippsConvert(Psingle(@p1[0]),Pdouble(dest.tb),nbpt);
end;


procedure THLPRfilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  b0,G0,C0:double;
  Vx,Vy,Vz,Vw,Vu,Vh,Vdxdp,Vdydp:Tvector;
  Hdxdp:Tvector;
  dzdp,dwdp,dudp:double;
begin
  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];
  Vz:=Vz0[numOcc];
  Vw:=Vw0[numOcc];
  Vu:=Vu0[numOcc];
  Vh:=Vh0[numOcc];


  Vdxdp:=argIn;
  Vdydp:=output;

  dzdp:=0;
  dwdp:=0;
  dudp:=0;
  Vdydp[1]:=0;

  case numParam of
    -1: begin
          Hdxdp:=Tvector.create32(g_double,1,nbpt);
          Hilbert(Vdxdp,Hdxdp);

          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp+b0*dzdp;
            Vdydp[i]:=G0/(Vz[i]+C0)*Vdxdp[i] -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp;

            dudp:=G0/(Vz[i]+C0)*Hdxdp[i] -G0/sqr(Vz[i]+C0)*Vh[i]*dzdp;
          end;
          Hdxdp.free;
         end;

      0: begin { b }
          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp- Vw[i] + b0*dzdp+Vz[i-1];
            Vdydp[i]:= -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp;

            dudp:= -G0/sqr(Vz[i]+C0)*Vh[i]*dzdp;
          end;
         end;

      1: begin { G }
          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp+b0*dzdp;
            Vdydp[i]:= -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp +Vx[i]/(Vz[i]+C0);

            dudp:= -G0/sqr(Vz[i]+C0)*Vh[i]*dzdp +Vh[i]/(Vz[i]+C0);
          end;
         end;

      2: begin { C }
          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp+b0*dzdp;
            Vdydp[i]:= -G0/sqr(Vz[i]+C0)*Vx[i]*dzdp -G0*Vx[i]/sqr(Vz[i]+C0);

            dudp:= -G0/sqr(Vz[i]+C0)*Vh[i]*dzdp -G0*Vh[i]/sqr(Vz[i]+C0);
          end;
         end;
  end;
end;



procedure THLPRfilter.getAux(numVec,numOcc: integer; vec: Tvector);
begin
  vec.Vcopy(Vz0[numOcc]);
end;


procedure THLPRfilter.initBounds;
begin
  case mode of
    0,1: begin
         paramin[0]:=0.5;
         paramax[0]:=1-1E-12;
       end;
    {
    1: begin
         paramin[0]:=1;
         paramax[0]:=1000;
       end;
    }
  end;

  paramin[1]:=0;
  paramax[1]:=1E20;

  paramin[2]:=1E-9;
  paramax[2]:=1E20;
end;

function THLPRfilter.paramCount: integer;
begin
  result:=3;
end;

function THLPRfilter.paraName(i: integer): AnsiString;
begin
  case i of
    0 : result:='b';
    1 : result:='G';
    2 : result:='C';
  end;
end;

class procedure THLPRfilter.GetParamList(var NumTypes: TarrayOfTypeNombre;
  var mini, maxi: TarrayOfFloat);
begin
  setLength(numTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=0;
  maxi[0]:=1;

end;

procedure THLPRfilter.SetParamList(var Values: TarrayOfFloat);
begin
  mode:=round(Values[0]);
end;



{ TLPRMfilter }

constructor TLPRMfilter.create;
begin
  inherited;

end;

destructor TLPRMfilter.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vy0) do
  begin
    Vy0[i].free;
    Vw0[i].free;
    Vz0[i].free;
  end;
end;

function TLPRMfilter.newOcc:integer;
begin
  result:=inherited newOcc;

  setLength(Vy0,lastOcc+1);
  Vy0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vy0[lastOcc].NotPublished:=true;

  setLength(Vw0,lastOcc+1);
  Vw0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vw0[lastOcc].NotPublished:=true;

  setLength(Vz0,lastOcc+1);
  Vz0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vz0[lastOcc].NotPublished:=true;
end;


procedure TLPRMfilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  b0,G0,C0:double;
  Vx,Vy,Vz,Vw:Tvector;

  tot:double;
  Nmoy:integer;
begin
  inherited;

  Vx:=input1;
  Vy:=Vy0[numOcc];
  Vz:=Vz0[numOcc];
  Vw:=Vw0[numOcc];

  Vy.modify(g_double,1,nbpt);
  Vw.modify(g_double,1,nbpt);
  Vz.modify(g_double,1,nbpt);

  b0:=para^[0];
  G0:=para^[1];

  Vy[1]:=0;
  Vz[1]:=0;

  tot:=0;
  Nmoy:=round(b0);

  case mode of
    0:for i:=2 to nbpt do
      begin
        Vw[i]:=Vy[i-1]; { sqr(Vy[i-1])}
        Vz[i]:=(1-b0)*Vw[i]+b0*Vz[i-1];

        Vy[i]:=Vx[i]-G0*Vz[i];
      end;

    1:begin
      end;
  end;

  output1.Vcopy(Vy);
end;

procedure TLPRMfilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  b0,G0,C0:double;
  Vx,Vy,Vz,Vw,Vdxdp,Vdydp:Tvector;
  dzdp,dwdp:double;
begin
  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];
  Vz:=Vz0[numOcc];
  Vw:=Vw0[numOcc];

  Vdxdp:=argIn;
  Vdydp:=output;

  dzdp:=0;
  dwdp:=0;
  Vdydp[1]:=0;

  case numParam of
    -1: begin
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp+b0*dzdp;
            Vdydp[i]:=Vdxdp[i] -G0*dzdp;
          end;
         end;

      0: begin { b }
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp -Vw[i] +b0*dzdp +Vz[i-1];
            Vdydp[i]:= -G0*dzdp;
          end;
         end;

      1: begin { G }
          for i:=2 to nbpt do
          begin
            dwdp:=2*Vy[i-1]*Vdydp[i-1];
            dzdp:=(1-b0)*dwdp+b0*dzdp ;
            Vdydp[i]:= -Vz[i] -G0*dzdp; ;
          end;
         end;

  end;
end;



procedure TLPRMfilter.getAux(numVec,NumOcc: integer; vec: Tvector);
begin
  vec.Vcopy(Vz0[numOcc]);
end;


procedure TLPRMfilter.initBounds;
begin
  inherited;

  case mode of
    0,1: begin
         paramin[0]:=0.1;
         paramax[0]:=1-1E-12;
       end;

  end;

  paramin[1]:=1E-9;
  paramax[1]:=1E20;

end;

function TLPRMfilter.paramCount: integer;
begin
  result:=2;
end;

function TLPRMfilter.paraName(i: integer): AnsiString;
begin
  case i of
    0 : result:='b';
    1 : result:='G';
  end;
end;

class procedure TLPRMfilter.GetParamList(var NumTypes: TarrayOfTypeNombre;
  var mini, maxi: TarrayOfFloat);
begin
  setLength(numTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=0;
  maxi[0]:=1;

end;

procedure TLPRMfilter.SetParamList(var Values: TarrayOfFloat);
begin
  mode:=round(Values[0]);
end;


{***************************************************}


{ THLPRMfilter }

constructor THLPRMfilter.create;
begin
  inherited;

end;

destructor THLPRMfilter.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vy0) do
  begin
    Vy0[i].free;
    Vw0[i].free;
    Vz0[i].free;
    Vu0[i].free;
    Vh0[i].Free;
  end;
end;

function THLPRMfilter.newOcc:integer;
begin
  result:=inherited newOcc;

  setLength(Vy0,lastOcc+1);
  Vy0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vy0[lastOcc].NotPublished:=true;

  setLength(Vw0,lastOcc+1);
  Vw0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vw0[lastOcc].NotPublished:=true;

  setLength(Vz0,lastOcc+1);
  Vz0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vz0[lastOcc].NotPublished:=true;

  setLength(Vu0,lastOcc+1);
  Vu0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vu0[lastOcc].NotPublished:=true;

  setLength(Vh0,lastOcc+1);
  Vh0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vh0[lastOcc].NotPublished:=true;
end;

procedure THLPRMfilter.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i:integer;
  b0,G0,C0:double;
  Vx,Vy,Vz,Vw,Vu,Vh:Tvector;

begin
  inherited;

  Vy:=Vy0[numOcc];
  Vw:=Vw0[numOcc];
  Vz:=Vz0[numOcc];
  Vu:=Vu0[numOcc];
  Vh:=Vh0[numOcc];

  Vy.modify(g_double,1,nbpt);
  Vw.modify(g_double,1,nbpt);
  Vz.modify(g_double,1,nbpt);
  Vu.modify(g_double,1,nbpt);
  Vh.modify(g_double,1,nbpt);


  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input1;

  Vy[1]:=0;
  Vz[1]:=0;

  proVhilbert(Vx,Vh);

  case mode of
    0:for i:=2 to nbpt do
      begin
        Vw[i]:=sqrt(sqr(Vy[i-1]) +  sqr(Vu[i-1]));
        Vz[i]:=(1-b0)*Vw[i]+b0*Vz[i-1];

        Vy[i]:=Vx[i]-G0*Vz[i];

        Vu[i]:=Vh[i]-G0*Vz[i];
      end;

    1:for i:=2 to nbpt do
      begin
        Vw[i]:=sqr(Vy[i-1]) +  sqr(Vu[i-1]);
        Vz[i]:=(1-b0)*Vw[i]+b0*Vz[i-1];

        Vy[i]:=Vx[i]-G0*Vz[i];

        Vu[i]:=Vh[i]-G0*Vz[i];
      end;
  end;

  output1.Vcopy(Vy);
end;


procedure THLPRMfilter.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  b0,G0,C0:double;
  Vx,Vy,Vz,Vw,Vu,Vh,Vdxdp,Vdydp:Tvector;
  Hdxdp:Tvector;
  dzdp,dwdp,dudp:double;
begin
  b0:=para^[0];
  G0:=para^[1];
  C0:=para^[2];

  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];
  Vw:=Vw0[numOcc];
  Vz:=Vz0[numOcc];
  Vu:=Vu0[numOcc];
  Vh:=Vh0[numOcc];

  Vdxdp:=argIn;
  Vdydp:=output;

  dzdp:=0;
  dwdp:=0;
  dudp:=0;
  Vdydp[1]:=0;

  case numParam of
    -1: begin
          Hdxdp:=Tvector.create32(g_double,1,nbpt);
          Hilbert(Vdxdp,Hdxdp);

          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp+b0*dzdp;

            Vdydp[i]:=Vdxdp[i] -G0*dzdp;

            dudp:=Hdxdp[i] -G0*dzdp;
          end;
          Hdxdp.free;
         end;

      0: begin { b }
          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp- Vw[i] + b0*dzdp+Vz[i-1];
            Vdydp[i]:= -G0*dzdp;
            dudp:= -G0*dzdp;
          end;
         end;

      1: begin { G }
          for i:=2 to nbpt do
          begin
            case mode of
              0: if Vw[i-1]>0
                   then dwdp:=(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp) / Vw[i-1]
                   else dwdp:=0;
              1: dwdp:=2*(Vy[i-1]*Vdydp[i-1] + Vu[i-1]*dudp);
            end;

            dzdp:=(1-b0)*dwdp+b0*dzdp;
            Vdydp[i]:= -G0*dzdp -Vz[i];

            dudp:= -G0*dzdp -Vz[i];
          end;
         end;

  end;
end;



procedure THLPRMfilter.getAux(numVec,numOcc: integer; vec: Tvector);
begin
  vec.Vcopy(Vz0[numOcc]);
end;


procedure THLPRMfilter.initBounds;
begin
  case mode of
    0,1: begin
         paramin[0]:=0.5;
         paramax[0]:=1-1E-12;
       end;
  end;

  paramin[1]:=0;
  paramax[1]:=1E20;
end;

function THLPRMfilter.paramCount: integer;
begin
  result:=2;
end;

function THLPRMfilter.paraName(i: integer): AnsiString;
begin
  case i of
    0 : result:='b';
    1 : result:='G';
  end;
end;

class procedure THLPRMfilter.GetParamList(var NumTypes: TarrayOfTypeNombre;
  var mini, maxi: TarrayOfFloat);
begin
  setLength(numTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=g_longint;
  mini[0]:=0;
  maxi[0]:=1;

end;

procedure THLPRMfilter.SetParamList(var Values: TarrayOfFloat);
begin
  mode:=round(Values[0]);
end;



{***************************************************}


procedure registerFilter(f:TfilterClass);
begin
  if not assigned(FilterTypes) then FilterTypes:=TstringList.create;
  with FilterTypes do
    addObject(Fmaj(f.ClassName) ,Tobject(f));
end;




{ Tlinearfilter2 }

constructor Tlinearfilter2.create;
var
  i:integer;
begin
  inherited;
  nbcoeff:=1;
  nbK:=1;
  nblin:=nbCoeff*nbK;

end;

procedure Tlinearfilter2.evaluer(input1, output1: Tvector;numOcc:integer);
var
  para1:array of double;
  DstLen:integer;
  phase:integer;
begin
  { On construit d'abord la réponse impulsionnelle interpolée:
      - avec UpSample, on intercale des zéros entre les coeffs
      - puis on calcule la convolution du résultat avec une fonction triangle

    Ensuite, on calcule la convolution entre l'entrée et la RI interpolée
  }

  inherited;

  {Interpolation}
  setLength(hI,nblin +2*nbK+1);

  setLength(para1,nbCoeff*nbK);
  phase:=0;
  ippsSampleUp(Pdouble(@para[0]),NbCoeff, Pdouble(@para1[0]),@dstLen,nbK,@phase);

  ippsConv(Pdouble(@para1[0]),NbCoeff*nbK,@Vtriangle[0],2*nbK+1, @hI[0] );
  move(hI[nbK],hI[0],(nblin+nbK+1)*8);

  {Le résultat du filtre linéaire est donné par une convolution}
  output1.modifyTemp((nbpt+nblin)*8);
  ippsConv(input1.tbD,nbpt,@hI[0],Nblin,output1.tbD);
  output1.restoreTemp;

  setLength(inputC,nbpt+2*nbK+1);
  ippsConv(input1.tbD,nbpt,@Vtriangle[0],2*nbK+1, @inputC[0] );

  { inputC est la convolution entre l'entrée et une fonction triangle
    Utile pour le calcule de dérivée.
  }
end;

procedure Tlinearfilter2.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  ylin1:array of double;
begin
  if numParam=-1 then
  begin
    setLength(ylin1,nbpt+nblin);
    ippsConv(argIN.tbD,nbpt,@hI[0],Nblin,@ylin1[0]);
    move(ylin1[0],output.tb^,nbpt*8);
  end
  else
  begin
    output.fill(0);
    move(inputC[nbK] ,output.getP(1+numParam*nbK)^,(nbpt-nbK*numParam)*8);
  end;
end;

class procedure Tlinearfilter2.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,2);
  setLength(mini,2);
  setLength(maxi,2);

  NumTypes[0]:=G_longint;
  mini[0]:=1;
  maxi[0]:=100000;

  NumTypes[1]:=G_longint;
  mini[1]:=1;
  maxi[1]:=100000;

end;

function Tlinearfilter2.paramCount: integer;
begin
  result:=nbCoeff;
end;

procedure Tlinearfilter2.SetParamList(var Values: TarrayOfFloat);
var
  i:integer;
begin
  nbCoeff:=round(Values[0]);
  nbK:=round(values[1]);

  nblin:=nbCoeff*nbK;

  setLength(Vtriangle,2*nbK+1);
  for i:=0 to nbK do
  begin
    Vtriangle[i]:=i/nbK;
    Vtriangle[nbK+i]:=(nbK-i)/nbK;
  end;
end;



{ TlinearfilterP }

constructor TlinearfilterP.create;
begin
  inherited;

end;

procedure TlinearfilterP.evaluer(input1, output1: Tvector;numOcc:integer);
var
  i,j:integer;
  w,w1:double;
begin
  inherited;

  {Calcul de la RI à partir des coeff des polynomes }
  for i:=0 to nblin-1 do
  begin
    w:=0;
    w1:=1;
    for j:=0 to nbcoeff-1 do
    begin
      w:=w+para[j]*w1;
      w1:=w1*i;
    end;
    h[i]:=w;
  end;

  {Le résultat du filtre linéaire est donné par une convolution}
  output1.modifyTemp((nbpt+nblin)*8);
  ippsConv(input1.tbD,nbpt,@h[0],Nblin,output1.tb);
  output1.restoreTemp;

  {Calcul des VH pour le calcul des dérivées}

  for j:=0 to nblin-1 do VH[0,j]:=1;
  for i:=1 to nbCoeff-1 do
    for j:=0 to nblin-1 do VH[i,j]:=VH[i-1,j]*j;

end;


procedure TlinearfilterP.evaluerDeriv(numParam: integer; argIN,output: Tvector;numOcc:integer);
var
  ylin1:array of double;
begin
  if numParam=-1 then
  begin
    setLength(ylin1,nbpt+nblin);
    ippsConv(argIN.tbD,nbpt,@h[0],Nblin,@ylin1[0]);
    move(ylin1[0],output.tb^,nbpt*8);
  end
  else
  begin
    output.fill(0);
    setLength(ylin1,nbpt+nblin);
    ippsConv(input[numOcc].tbD,nbpt,@VH[numParam,0],Nblin,@ylin1[0]);
    move(ylin1[0],output.tb^,nbpt*8);
  end;
end;


class procedure TlinearfilterP.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,2);
  setLength(mini,2);
  setLength(maxi,2);

  NumTypes[0]:=G_longint;
  mini[0]:=1;
  maxi[0]:=100000;

  NumTypes[1]:=G_longint;
  mini[1]:=1;
  maxi[1]:=100000;

end;

function TlinearfilterP.paramCount: integer;
begin
  result:=nbCoeff;
end;

procedure TlinearfilterP.SetParamList(var Values: TarrayOfFloat);
begin
  nbCoeff:=round(Values[0]);
  nblin:=round(Values[1]);

  setLength(VH,nbcoeff,nblin);
  setLength(H,nblin);


end;

procedure TlinearfilterP.getAux(numVec, numOcc: integer; vec: Tvector);
begin
  vec.modify(g_double,0,high(h));
  move(h[0],vec.tb^,length(h)*8);
end;


{ Tfilter2 }

constructor Tfilter2.create;
begin
  inherited;
end;

destructor Tfilter2.destroy;
var
  i:integer;
begin
  for i:=0 to high(input2) do input2[i].Free;
  inherited;
end;

function Tfilter2.NewOcc: integer;
begin
  result:=inherited NewOcc;

  setLength(input2,LastOcc+1);
  input2[LastOcc]:=Tvector.create32(g_double,1,1);
  input2[LastOcc].ident:='Input2';
  input2[LastOcc].notPublished:=true;

end;

procedure Tfilter2.evaluer2(inputA1,inputA2,output1:Tvector;numOcc:integer);
begin
  move(inputA1.tb^,input[numOcc].tb^,nbpt*8);
  move(inputA2.tb^,input2[numOcc].tb^,nbpt*8);
end;


procedure Tfilter2.setNbpt(nbpt1:integer);
var
  i:integer;
begin
  inherited;
  for i:=0 to lastOcc do input2[i].modify(g_double,1,nbpt);
end;

{ TLowPassFilter2 }

constructor TLowPassFilter2.create;
begin
  inherited;


end;

destructor TLowPassFilter2.destroy;
var
  i:integer;
begin
  for i:=0 to high(VtNorm0) do
  begin
    VtNorm0[i].Free;
    Vt0[i].free;
    Vexp0[i].free;
  end;
  inherited;
end;

function TLowPassFilter2.NewOcc: integer;
begin
  result:=inherited newOcc;

  setLength(VtNorm0,lastOcc+1);
  VtNorm0[lastOcc]:=Tvector.create32(g_double,1,1);
  VtNorm0[lastOcc].NotPublished:=true;

  setLength(Vt0,lastOcc+1);
  Vt0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vt0[lastOcc].NotPublished:=true;

  setLength(Vexp0,lastOcc+1);
  Vexp0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vexp0[lastOcc].NotPublished:=true;
end;

function TLowPassFilter2.Knorm(w: double): double;
var
  i,j:integer;
  x,tau:double;
begin
  if length(KN)=0 then
  begin
    setLength(KN,1000);
    for i:=1 to 999 do
    begin
      tau:=0.1*i;
      x:=0;
      for j:=0 to 1000 do
      begin
        x:=x+exp(-j/tau);
        KN[i]:=x;
      end;
    end;
  end;

  i:=roundL(w*10);
  if i<1 then result:=1
  else
  if i<1000 then result:=KN[i]
  else result:=w;
end;


procedure TLowPassFilter2.evaluer2(inputA1, inputA2, output1: Tvector;numOcc:integer);
var
  i,j:integer;
  w,xx,tt:double;
  Vxt:Tvector;
  VtNorm,VExp,Vt:Tvector;

const
  epsilon=1E-20;
begin
  inherited;
  (*
  for i:=1 to nbpt do
  begin
    w:=0;
    for j:=0 to Nmax-1 do
      if (i-j>0) then
      begin
        xx:=inputA1[i-j];
        tt:=inputA2[i-j];
        if tt<epsilon then tt:=epsilon;
        w:=w+xx*exp(-j/tt)/Knorm(tt);
      end;
    output1[i]:=w;
  end;
   *)


  Vxt:=Tvector.create32(g_double,1,nbpt);

  TRY
  thresh1(input2[numOcc],1E-20,false,nbpt);                 { Seuiller input2 }

  VtNorm:=VtNorm0[numOcc];
  VExp:=Vexp0[numOcc];
  Vt:=Vt0[numOcc];

  VtNorm.modify(g_double,1,nbpt);
  Vt.modify(g_double,1,nbpt);
  Vexp.modify(g_double,1,nbpt);

  for i:=1 to nbpt do
  begin
    Vt[i]:=1/inputA2[i];                             { Calcul 1/tau  }
    VtNorm[i]:=1/Knorm(inputA2[i]);                  { Calcul 1/tau normalisé }
    Vexp[i]:=exp(-1/inputA2[i]);                     { Calcul exp(-1/tau) }
  end;

  ippsMul(inputA1.tbD,VtNorm.tbD,Vxt.tbD,nbpt);       { Vtx := x * VtNorm }
  output1.Vcopy(Vxt);                               { Itération 0 dans output1 }

  for i:=1 to Nmax do
  begin
    ippsmul(Vexp.tbD,Vxt.tbD,nbpt);                 { Vxt:= Vxt * Vexp }
    ippsAdd(Vxt.tbD,@PtabDouble(output1.tb)^[i],nbpt-i);
  end;                                              { output =output + Vxt décalé de  i }


  FINALLY
  Vxt.free;
  END;
end;

procedure TLowPassFilter2.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i,j:integer;
  w,xx,tt:double;
  Vx,Vx2,Vxt,Va,Vdum:Tvector;
  VtNorm,VExp,Vt:Tvector;
const
  epsilon=1E-20;
begin
  TRY

  Vx:=Input[numOcc];
  Vx2:=Input2[numOcc];

  VtNorm:=VtNorm0[numOcc];
  VExp:=Vexp0[numOcc];
  Vt:=Vt0[numOcc];

  case numParam of
    -1: begin
          (*
          for i:=1 to nbpt do
          begin
            w:=0;
            for j:=0 to Nmax-1 do
              if (i-j>0) and (input2[i-j]>epsilon)
                then w:=w+argin[i-j]*exp(-j/input2[i-j])/input2[i-j];
            output[i]:=w;
          end;
          *)
          Vxt:=Tvector.create32(g_double,1,nbpt);
          TRY

          ippsMul(argin.tbD,Vt.tbD,Vxt.tbD,nbpt);        { Vtx := dx/dt * Vt }
          output.Vcopy(Vxt);                             { Itération 0 dans output1 }

          for i:=1 to Nmax do
          begin
            ippsmul(Vexp.tbD,Vxt.tbD,nbpt);              { Vxt:= Vxt * Vexp }
            ippsAdd(Vxt.tbD,@PtabDouble(output.tb)^[i],nbpt-i);{ output =output + Vxt décalé de  i }
          end;

          FINALLY
            Vxt.Free;
          END;
         end;

    -2: begin
          (*
          for i:=1 to nbpt do
          begin
            w:=0;
            for j:=0 to Nmax-1 do
              if (i-j>0) and (input2[i-j]>epsilon) then
              begin
                xx:=input[i-j];
                tt:=input2[i-j];
                w:=w+ xx* exp(-j/tt) *(j/tt-1) /sqr(tt)*argin[i-j];
              end;
            output[i]:=w;
          end;
          *)

          Vxt:=Tvector.create32(g_double,1,nbpt);
          Va:=Tvector.create32(g_double,1,nbpt);
          Vdum:=Tvector.create32(g_double,1,nbpt);

          TRY

          ippsMul(argin.tbD,Vx.tbD,Vxt.tbD,nbpt);     { Vtx := dtau/dt * x }
          ippsMul(Vt.tbD,Vxt.tbD,nbpt);
          ippsMul(Vt.tbD,Vxt.tbD,nbpt);                  { Vtx := dtau/dt * x  / tau²}

          output.Vcopy(Vxt);                             { Itération 0 dans output = -Vxt }
          ippsMulC(-1,output.tbD,nbpt);

          Va.fill(-1);

          for i:=1 to Nmax do
          begin
            ippsmul(Vexp.tbD,Vxt.tbD,nbpt);                    { Vxt:= Vxt * Vexp }
            ippsadd(vt.tbD,vA.tbD,nbpt);                       { Va := Va +Vt }
            ippsmul(Vxt.tbD,vA.tbD,Vdum.tbD,nbpt);             { Vdum := Vxt * Va }
            ippsAdd(Vdum.tbD,@PtabDouble(output.tb)^[i],nbpt-i);{ output =output + Vdum décalé de  i }
          end;

          FINALLY
            Vxt.Free;
            Va.free;
            Vdum.free;
          END;

        end;
  end;
  except
  end;
end;

function TLowPassFilter2.paramCount: integer;
begin
  result:=0;
end;



procedure TLowPassFilter2.SetParamList(var Values: TarrayOfFloat);
begin
  Nmax:=round(values[0]);
end;

class procedure TLowPassFilter2.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=G_longint;
  mini[0]:=1;
  maxi[0]:=maxEntierLong;
end;



{ TLowPassFilter2B }

constructor TLowPassFilter2B.create;
begin
  inherited;

end;

destructor TLowPassFilter2B.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vt0) do Vt0[i].free;

  inherited;
end;

function TLowPassFilter2B.NewOcc: integer;
begin
  result:=inherited NewOcc;

  setLength(Vt0,LastOcc+1);
  Vt0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vt0[lastOcc].NotPublished:=true;
end;

procedure TLowPassFilter2B.evaluer2(inputA1, inputA2, output1: Tvector;numOcc:integer);
var
  i:integer;
  Kfac:double;
const
  seuilMin=0;
begin
{ V(t)= 1/(1+K*g)*V(t-1) +K/(1+K*g)*I(t)

  avec K=Dt/C , Dt étant l'intervalle d'échantillonnage
                C la capacité
                g la conductance
}

  inherited;

  for i:=1 to nbpt do
  begin
    if inputA2[i]<seuilMin then inputA2[i]:=seuilMin;

    Kfac:=1/(1+k0*inputA2[i]);

    if i>1
      then output1[i]:=Kfac*output1[i-1] + inputA1[i]* Kfac*K0
      else output1[i]:=inputA1[i]* Kfac*K0;
  end;

  Vt0[numOcc].Vcopy(output1);
end;

procedure TLowPassFilter2B.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i:integer;
  w1:double;
  Vx,Vx2,Vt:Tvector;
const
  epsilon=1E-20;
begin
  TRY

  Vx:=input[numOcc];
  Vx2:=input2[numOcc];
  Vt:=Vt0[numOcc];

  case numParam of
    -1: begin
          output[1]:=0;
          for i:=2 to nbpt do
          begin
            w1:=1/(1+k0*Vx2[i]);
            output[i]:=w1*output[i-1]+k0*w1*argIn[i];
          end;
        end;

    -2: begin
          output[1]:=0;
          for i:=2 to nbpt do
          begin
            w1:=k0/sqr(1+k0*Vx2[i]);
            output[i]:=(-w1*Vt[i-1]-k0*w1*Vx[i])*argIn[i-1];
          end;
        end;
  end;
  except
  end;
end;

function TLowPassFilter2B.paramCount: integer;
begin
  result:=0;
end;

procedure TLowPassFilter2B.SetParamList(var Values: TarrayOfFloat);
begin
  K0:=values[0];
end;

class procedure TLowPassFilter2B.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,1);
  setLength(mini,1);
  setLength(maxi,1);

  NumTypes[0]:=G_extended;
  mini[0]:=0;
  maxi[0]:=1E100;

end;


{ TLowPassFilter2C }

constructor TLowPassFilter2C.create;
begin
  inherited;


end;

destructor TLowPassFilter2C.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vt0) do Vt0[i].free;

  inherited;
end;

function TLowPassFilter2C.NewOcc: integer;
begin
  result:=inherited NewOcc;

  setLength(Vt0,lastOcc+1);
  Vt0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vt0[lastOcc].NotPublished:=true;
end;

procedure TLowPassFilter2C.evaluer2(inputA1, inputA2, output1: Tvector;numOcc:integer);
var
  i:integer;
  gt:double;

const
  seuilMin=0;
begin
{ gt:= gm+g1+g2
  V(t)= gm/gt*V(t-1) + g1/gt*input(t) + g2/gt*V2

  avec gm=C/deltaT , DeltaT étant l'intervalle d'échantillonnage
                     C la capacité
                     g1 la conductance fixe
                     g2 la conductance variable (gShunt)
                     V2 le potentiel Vshunt
}

  inherited;

  g1:=para^[0];
  gm:=para^[1];
  V2:=para^[2];

  for i:=1 to nbpt do
  begin
    if inputA2[i]<seuilMin then inputA2[i]:=seuilMin;

    gt:=gm+g1+inputA2[i];

    if i>1
      then output1[i]:=gm/gt*output1[i-1] + g1/gt*inputA1[i] + inputA2[i]/gt*V2
      else output1[i]:=g1/gt*inputA1[i] + inputA2[i]/gt*V2;
  end;

  Vt0[numOcc].Vcopy(output1);
end;

procedure TLowPassFilter2C.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i:integer;
  Vx,Vx2,Vt:Tvector;
const
  epsilon=1E-20;
begin
  TRY
  g1:=para^[0];
  gm:=para^[1];
  V2:=para^[2];

  Vx:=input[numOcc];
  Vx2:=input2[numOcc];
  Vt:=Vt0[numOcc];

  case numParam of
    -1: begin
          output[1]:=argIn[1]*g1/(gm+g1+Vx2[1]);
          for i:=2 to nbpt do
          begin
            output[i]:=(gm*output[i-1]+g1*argIn[i])/(gm+g1+Vx2[i]);
          end;
        end;

    -2: begin
          output[1]:=Argin[1]*(-g1*Vx[1]+(gm+g1)*V2)/sqr(gm+g1+Vx2[i])  ;
          for i:=2 to nbpt do
          begin
            output[i]:=(-gm*Vt[i-1]-g1*Vx[i]+(gm+g1)*V2)*argIn[i]/sqr(gm+g1+Vx2[i]);
          end;
        end;

    0:  begin   {g1}
          output[1]:=((gm+Vx2[1])*Vx[1]-Vx2[1]*v2)/sqr(gm+g1+Vx2[1]);
          for i:=2 to nbpt do
          begin
            output[i]:=((gm+Vx2[i])*Vx[i]-gm*Vt[i-1]-Vx2[i]*v2)/sqr(gm+g1+Vx2[i]);
          end;
        end;

    1:  begin   {gm}
          output[1]:=(-g1*Vx[1]-Vx2[1]*v2)/sqr(gm+g1+Vx2[1]);
          for i:=2 to nbpt do
          begin
            output[i]:=((g1+Vx2[i])*Vt[i-1]-g1*Vx[i]-Vx2[i]*v2)/sqr(gm+g1+Vx2[i]);
          end;
        end;

    2:  begin   {v2}
          for i:=1 to nbpt do
          begin
            output[i]:=Vx2[i]/(gm+g1+Vx2[i]);
          end;
        end;

  end;
  except
  end;
end;


procedure TLowPassFilter2C.SetParamList(var Values: TarrayOfFloat);
begin
{
  g1:=values[0];
  gm:=values[1];
  V2:=values[2];
  }
end;

class procedure TLowPassFilter2C.GetParamList(var NumTypes: TarrayOfTypeNombre; var mini, maxi: TarrayOfFloat);
begin
  setLength(NumTypes,0);
  setLength(mini,0);
  setLength(maxi,0);
  {
  setLength(NumTypes,3);
  setLength(mini,3);
  setLength(maxi,3);

  NumTypes[0]:=G_extended;
  mini[0]:=0;
  maxi[0]:=1E100;

  NumTypes[1]:=G_extended;
  mini[1]:=0;
  maxi[1]:=1E100;

  NumTypes[2]:=G_extended;
  mini[2]:=-1E100;
  maxi[2]:=1E100;
  }
end;

function TLowPassFilter2C.paramCount: integer;
begin
  result:=3;
end;

procedure TLowPassFilter2C.initBounds;
begin
  paraMin[0]:=1E-20;  { g1 }
  paraMax[0]:=1E20;

  paraMin[1]:=1E-20;  { gm }
  paraMax[1]:=1E20;

  paraMin[2]:=-1E20;  { V2 }
  paraMax[2]:=1E20;

end;

function TLowPassFilter2C.paraName(i: integer): AnsiString;
begin
  case i of
    1: result:=name+'-g1';
    2: result:=name+'-gm';
    3: result:=name+'-V2';
  end;
end;


{ TRCcell }

constructor TRCcell.create;
begin
  inherited;


end;

destructor TRCcell.destroy;
var
  i:integer;
begin
  for i:=0 to high(Vt0) do Vt0[i].free;

  inherited;
end;

function TRCcell.NewOcc:integer;
begin
  result:= inherited newOcc;

  setLength(Vt0,lastOcc+1);
  Vt0[lastOcc]:=Tvector.create32(g_double,1,nbpt);
  Vt0[lastOcc].NotPublished:=true;
end;


procedure TRCcell.evaluer2(inputA1, inputA2, output1: Tvector;numOcc:integer);
var
  i:integer;
  gt:double;
  evalVec:TevalVec;
begin
{ gt:= gm+g0
  V(t)= gm/gt*V(t-1) + g0*V0/gt

  avec gm=C/deltaT , DeltaT étant l'intervalle d'échantillonnage
                     C la capacité
                     g0 la conductance

  input est V0
  input2 est g0
}

  inherited;

  gm:=para^[0];
  (*
  evalVec:=TevalVec.create(nbpt);
  TRY
  with evalvec do
  begin
    thresh(inputA2);
    add(gm,inputA2 ,v(1));        {v1=gt}
    mul(inputA1, inputA2 ,v(2));
    divide(v(2),v(1),v(2));       {v2=inputA2*inputA1/gt  }

    output1[1]:=v(2)[1];
    for i:=2 to nbpt do
      output1[i]:=gm/v(1)[i]*output1[i-1] + v(2)[i];
  end;

  FINALLY
  evalvec.free;
  END;
  *)
  for i:=1 to nbpt do
  begin
    if inputA2[i]<0 then inputA2[i]:=0;

    gt:=gm+inputA2[i];
    {
    if i>1
      then output1[i]:=gm/gt*output1[i-1] + inputA2[i]*inputA1[i]/gt
      else output1[i]:=inputA2[i]*inputA1[i]/gt;
    }
    if i>1
      then output1[i]:=gm/gt*output1[i-1] + inputA2[i]*inputA1[i]/gt
      else output1[i]:=gm/gt*inputA1[1]+inputA2[i]*inputA1[i]/gt;
  end;

  Vt0[numOcc].Vcopy(output1);
end;


procedure TRCcell.evaluerDeriv(numParam: integer; argIN, output: Tvector;numOcc:integer);
var
  i:integer;
  Vx,Vx2,Vt:Tvector;
  evalvec:Tevalvec;
  pOutput,p1,p2,p3,p4:PtabDouble1;
  time0:integer;
const
  epsilon=1E-20;
begin
  TRY
  gm:=para^[0];

  Vx:=input[numOcc];
  Vx2:=input2[numOcc];
  Vt:=Vt0[numOcc];

  case numParam of
    -1: begin

          time0:=getTickCount;
          output[1]:=Vx2[1]/(gm+Vx2[1])*argIn[1];
          for i:=2 to nbpt do
          begin
            output[i]:=(gm*output[i-1]+Vx2[i]*argIn[i])/(gm+Vx2[i]);
          end;
          affdebug('RC-1: '+Istr(getTickCount-time0),78);

          (*  L'amélioration evalvec est insignifiante 
          time0:=getTickCount;
          evalvec:=Tevalvec.create(nbpt);
          try
          with evalvec do
          begin
            mul(Vx2,argin,v1);           {v1=Vx2[i]*argIn[i]}
            add(gm,Vx2,v2);              {v2= gm+Vx2}
            divide(gm,v2,v3);            {v3= gm/(gm+Vx2)}

            divide(v1,v2,v4);            {v4=Vx2[i]*argIn[i]/(gm+Vx2[i]) }

            {
            output[1]:=v4[1];
            for i:=2 to nbpt do
              output.tbDouble[i]:=v3.tbDouble[i]*output.tbDouble[i-1]+v4.tbDouble[i];
            }
            poutput:=output.tb;
            p3:=v3.tb;
            p4:=v4.tb;

            poutput^[1]:=p4^[1];
            for i:=2 to nbpt do
              poutput^[i]:=p3^[i]*poutput^[i-1]+p4^[i];

          end;
          finally
            evalvec.Free;
          end;
          affdebug('RC-1-bis: '+Istr(getTickCount-time0),78);
          *)
        end;

    -2: begin
          {
          output[1]:=(gm*Vx[1])/sqr(gm+Vx2[1])* Argin[1]  ;
          for i:=2 to nbpt do
            output[i]:=gm*((Vx[i]-Vt[i-1])*argIn[i] +(gm+Vx2[i])*output[i-1]  )/sqr(gm+Vx2[i]);
          }

          output[1]:=((gm+Vx2[1])*Vx[1]-(Vx[1]*Vx2[1]))/sqr(gm+Vx2[1])*Argin[1];
          for i:=2 to nbpt do
            {output[i]:=((gm+Vx2[i])*(gm*output[i-1]+Vx[i]*Argin[i])-(gm*Vt[i-1]+Vx[i]*Vx2[i])*Argin[i])/sqr(gm+Vx2[i]); }


            output[i]:=gm/(gm+Vx2[i])*output[i-1] +Vx[i]*Argin[i]/(gm+Vx2[i]) -(gm*Vt[i-1]+Vx[i]*Vx2[i])*Argin[i]/sqr(gm+Vx2[i]);

          (*
          evalvec:=Tevalvec.create(nbpt);
          try
          with evalvec do
          begin
            ShiftR(Vt,1,v1);             {v1= Vt[i-1]}
            add(gm,Vx2,v2);              {v2= gm+Vx2}
            divide(gm,v2,v3);            {v3= gm/(gm+Vx2)}

            mul(Vx,Argin,v4);
            divide(v4,v2,v4);            {v4=Vx[i]*Argin[i]/(gm+Vx2[i]) }

            mul(gm,v1,v5);
            mul(vx,vx2,v6);
            add(v5,v6,v5);
            mul(v5,Argin,v5);
            divide(v5,v2,v5);
            divide(v5,v2,v5);            {v5= (gm*Vt[i-1]+Vx[i]*Vx2[i])*Argin[i]/sqr(gm+Vx2[i]) }

            sub(v4,v5,v4);

            {
            output[1]:=v4[1];
            for i:=2 to nbpt do
              output.tbDouble[i]:=v3.tbDouble[i]*output.tbDouble[i-1]+v4.tbDouble[i];
            }
            poutput:=output.tb;
            p3:=v3.tb;
            p4:=v4.tb;

            poutput^[1]:=p4^[1];
            for i:=2 to nbpt do
              poutput^[i]:=p3^[i]*poutput^[i-1]+p4^[i];

          end;
          finally
            evalvec.Free;
          end;
          *)
        end;

    0:  begin   {gm}

          output[1]:=-Vx[1]*Vx2[1]/sqr(gm+Vx2[1]);
          for i:=2 to nbpt do
            {output[i]:=((gm+Vx2[i])*(Vt[i-1]+gm*output[i-1]) -(gm*Vt[i-1]+Vx[i]*Vx2[i]))/sqr(gm+Vx2[i]);}

             output[i]:=  gm/(gm+Vx2[i])*output[i-1]  +Vt[i-1]/(gm+Vx2[i])   - (gm*Vt[i-1]+Vx[i]*Vx2[i])/sqr(gm+Vx2[i]);


          (*
          evalvec:=Tevalvec.create(nbpt);
          try
          with evalvec do
          begin
            ShiftR(Vt,1,v1);             {v1= Vt[i-1]}
            add(gm,Vx2,v2);              {v2= gm+Vx2}
            divide(gm,v2,v3);            {v3= gm/(gm+Vx2)}

            divide(v1,v2,v4);            {v4=Vt[i-1]/(gm+Vx2[i]) }

            mul(gm,v1,v5);
            mul(vx,vx2,v6);
            add(v5,v6,v5);
            divide(v5,v2,v5);
            divide(v5,v2,v5);            {(gm*Vt[i-1]+Vx[i]*Vx2[i])/sqr(gm+Vx2[i]) }

            sub(v4,v5,v4);

            {
            output[1]:=v4[1];
            for i:=2 to nbpt do
              output.tbDouble[i]:=v3.tbDouble[i]*output.tbDouble[i-1]+v4.tbDouble[i];
            }
            poutput:=output.tb;
            p3:=v3.tb;
            p4:=v4.tb;

            poutput^[1]:=p4^[1];
            for i:=2 to nbpt do
              poutput^[i]:=p3^[i]*poutput^[i-1]+p4^[i];

          end;
          finally
            evalvec.Free;
          end;
          *)
        end;

  end;


  except
  end;
end;


function TRCcell.paramCount: integer;
begin
  result:=1;
end;

procedure TRCcell.initBounds;
begin
  paraMin[0]:=1E-20;  { gm }
  paraMax[0]:=1E20;

end;

function TRCcell.paraName(i: integer): AnsiString;
begin
  case i of
    1: result:=name+'-gm';
  end;
end;


{ TdoubleGainFilter }

procedure TdoubleGainFilter.evaluer(input1, output1: Tvector; numOcc: integer);
var
  i:integer;
  g1,g2,w:double;
begin
  inherited;

  g1:=para[0];
  g2:=para[1];

  for i:=1 to nbpt do
  begin
    w:=input1[i];
    if w>=0
      then output1[i]:=g1*w
      else output1[i]:=g2*w;
  end;
end;


procedure TdoubleGainFilter.evaluerDeriv(numParam: integer; argIN, output: Tvector; numOcc: integer);
var
  i:integer;
  Vx:Tvector;
  g1,g2:double;
begin
  Vx:=input[numOcc];
  g1:=para[0];
  g2:=para[1];

  case numParam of
    -1:  for i:=1 to nbpt do
         begin
           if Vx[i]>0
             then output[i]:=g1* argIn[i]
             else output[i]:=g2* argIn[i];
         end;

      0: for i:=1 to nbpt do
         begin
           if Vx[i]>=0
             then output[i]:=Vx[i]
             else output[i]:=0;
         end;

      1: for i:=1 to nbpt do
         begin
           if Vx[i]<0
             then output[i]:=Vx[i]
             else output[i]:=0;
         end;
  end;
end;



function TdoubleGainFilter.paramCount: integer;
begin
  result:=2;
end;

function TdoubleGainFilter.paraName(i: integer): AnsiString;
begin
  case i of
    0: result:='g1';
    1: result:='g2';
  end;
end;

{ Tdelayfilter }

procedure Tdelayfilter.evaluer(input1, output1: Tvector; numOcc: integer);
var
  i:integer;
  w:double;
  p:integer;
begin
  inherited;

  initBounds;

  p:=round(para[0]);

  if (p>=0) and (p<nbpt) then
  begin
    output1.fill1(0,1,p);
    move(input1.getP(1)^,output1.getP(1+p)^,(nbpt-p)*8);
  end
  else output1.fill(0);
end;


procedure Tdelayfilter.evaluerDeriv(numParam: integer; argIN, output: Tvector; numOcc: integer);
var
  i:integer;
  Vx:Tvector;
  p:integer;
begin
  Vx:=input[numOcc];
  p:=round(para[0]);

  case numParam of
    -1:  if (p>=0) and (p<nbpt) then
         begin
           output.fill1(0,1,p);
           move(argin.getP(1)^,output.getP(1+p)^,(nbpt-p)*8);
         end
         else output.fill(0);

      0: if (p>=0) and (p<nbpt) then
         begin
           output.fill1(0,1,p+1);
           for i:=p+2 to nbpt do
             output[i]:=Vx[i-p-1]-Vx[i-p]
         end
         else output.fill(0);
  end;
end;


procedure Tdelayfilter.initBounds;
begin
  paramin[0]:=0;
  paramax[0]:=nbpt-1;

end;

function Tdelayfilter.paramCount: integer;
begin
  result:=1;
end;

{ TinvertFilter }

procedure TinvertFilter.evaluer(input1, output1: Tvector; numOcc: integer);
begin
  inherited;

  ippsAddC(para[0],input1.tbD,nbpt);
  output1.fill(1);
  ippsDiv(input1.tbD,output1.tbD,nbpt);

end;

procedure TinvertFilter.evaluerDeriv(numParam: integer; argIN,
  output: Tvector; numOcc: integer);
var
  Vx,Vy,Vz:Tvector;
begin
  inherited;
  Vx:=input[numOcc];
  Vy:=output;
  

  case numParam of
    -1:   try
            Vz:=Tvector.create32(g_double,1,nbpt);
            Vz.Vcopy(Vx);
            ippsAddC(para[0],Vz.tbD,nbpt);               {Vz=  x+C   }
            ippsSqr(Vz.tbD,nbpt);                        {Vz= (x+C)² }
            ippsSet(-1,Vy.tbD,nbpt);                     {Vy= -1 }
            ippsDiv(Vz.tbD,Vy.tbD,nbpt);                 {Vy= -1/ (x+C)² }

            ippsMul(argIn.tbD,Vy.tbD,nbpt);              {Vy= Vy * Argin }
          finally
            Vz.free;
          end;

    0:    try
            Vz:=Tvector.create32(g_double,1,nbpt);
            Vz.Vcopy(Vx);
            ippsAddC(para[0],Vz.tbD,nbpt);               {Vz=  x+C   }
            ippsSqr(Vz.tbD,nbpt);                        {Vz= (x+C)² }
            ippsSet(-1,Vy.tbD,nbpt);                     {Vy= -1 }
            ippsDiv(Vz.tbD,Vy.tbD,nbpt);                 {Vy= -1/ (x+C)² }
          finally
            Vz.free;
          end;
  end;
end;

procedure TinvertFilter.initBounds;
begin
  inherited;

  paramin[0]:=1E-20;
  paramax[0]:=1E20;
end;

function TinvertFilter.paramCount: integer;
begin
  result:=1;
end;

{ TSecondOrderFilter }


procedure TSecondOrderFilter.evaluer(input1, output1: Tvector;numOcc: integer);
var
  i:integer;
  Vx,Vy:Tvector;
  a0,a1,a2,b1,b2:double;
begin
  inherited;
  Vx:=input1;
  Vy:=Vy0[numOcc];

  Vy.modify(g_double,1,nbpt);

  a0:=para^[0];
  a1:=para^[1];
  a2:=para^[2];
  b1:=para^[3];
  b2:=para^[4];

  Vy[1]:=0;
  Vy[2]:=0;

  for i:=3 to nbpt do
    Vy[i]:=a0*Vx[i]+a1*Vx[i-1]+a2*Vx[i-2]- b1*Vy[i-1]-b2*Vy[i-2] ;

  output1.Vcopy(Vy);
end;



procedure TSecondOrderFilter.evaluerDeriv(numParam: integer; argIN, output: Tvector; numOcc: integer);
var
  i:integer;
  Vx,Vy:Tvector;
  Vdxdp,Vdydp:Tvector;
  a0,a1,a2,b1,b2:double;
begin
  inherited;
  Vx:=input[numOcc];
  Vy:=Vy0[numOcc];

  Vdxdp:=argIn;
  Vdydp:=output;

  a0:=para^[0];
  a1:=para^[1];
  a2:=para^[2];
  b1:=para^[3];
  b2:=para^[4];

  Vdydp[1]:=0;
  Vdydp[2]:=0;


  case numParam of
    -1: begin
          for i:=3 to nbpt do
          begin
            Vdydp[i]:=a0*Vdxdp[i]+a1*Vdxdp[i-1]+a2*Vdxdp[i-2]- b1*Vdydp[i-1] -b2*Vdydp[i-2] ;
          end;
         end;

     0: begin { a0 }
          for i:=1 to nbpt do
          begin
            Vdydp[i]:= Vx[i];
          end;
        end;

     1: begin { a1 }
          for i:=2 to nbpt do
          begin
            Vdydp[i]:= Vx[i-1];
          end;
        end;

     2: begin { a2 }
          for i:=3 to nbpt do
          begin
            Vdydp[i]:= Vx[i-2];
          end;
        end;

     3: begin { b1 }
          for i:=2 to nbpt do
          begin
            Vdydp[i]:= -Vy[i-1];
          end;
        end;

     4: begin { b2 }
          for i:=3 to nbpt do
          begin
            Vdydp[i]:= -Vy[i-2];
          end;
        end;
  end;
end;

procedure TSecondOrderFilter.initBounds;
var
  i:integer;
begin
  inherited;

  for i:=0 to 4 do
  begin
    paramin[i]:=-1E10;
    paramax[i]:=1E10;
  end;
end;


function TSecondOrderFilter.paramCount: integer;
begin
  result:=5;
end;

function TSecondOrderFilter.paraName(i: integer): AnsiString;
begin
  case i of
    0: result:='a0';
    1: result:='a1';
    2: result:='a2';
    3: result:='b1';
    4: result:='b2';
  end;
end;

Initialization
AffDebug('Initialization Models1',0);
  registerFilter(TlinearFilter);
  registerFilter(TlinearFilter2);
  registerFilter(TNL1Filter);
  registerFilter(TNL2Filter);
  registerFilter(TstaticFilter);
  registerFilter(TstaticFilterB); 
  registerFilter(TpolyFilter);
  registerFilter(TsynDep);

  registerFilter(TlowPassFilter);
  registerFilter(ThighPassFilter);

  registerFilter(TlinearFilterP);

  registerFilter(TlowPassFilter2);
  registerFilter(TlowPassFilter2B);
  registerFilter(TlowPassFilter2C);

  registerFilter(TRCcell);
  registerFilter(TLPRfilter);
  registerFilter(THLPRfilter);

  registerFilter(TLPRMfilter);
  registerFilter(THLPRMfilter);
  registerFilter(TdoubleGainfilter);

  registerFilter(Tdelayfilter);
  registerFilter(TinvertFilter);
  registerFilter(TsecondOrderFilter);

end.

