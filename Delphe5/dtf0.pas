 unit dtf0;

{Version Delphi}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses sysutils,classes,math,
     util1,debug0,
     ippdefs17,ipps17 ; 

{6-03-02

 Modification de la gestion des buffers de typeDatafile:

 Le buffer tb contient uniquement les données.
 LoadBlock démultiplexe les données
 SaveBlock les remultiplexe.

 2 juillet 2003 suppression des fonctions cvx, cvy

 11 décembre 2003 Passage aux classes !!!

 6 décembre 2008 Remplacement de nbVoie par StepSize
              et Remplacement de nbptBuf par NbWStep
}


type
 {
  typeDataB est le type de base des objets data
  la seule surcharge de getE et setE doit permettre d'accéder à n'importe
  quelle donnée de type vecteur.
 }

  TgetStream=function:Tstream of object;

  typeDataB=class
              indiceMin,indiceMax:integer;
              ax,bx:float;
              ay,by:float;
              modeCpx:byte;

              constructor create(imin,imax:integer);
              function EltSize:integer;virtual;
              destructor destroy;override;

              procedure modifyLimits(iMin,iMax:integer);virtual;
              {Pour les dataFile, il faudrait surcharger pour appeler
                saveBlock
                block:=-1;
              }
              function getI(i:integer):integer;virtual;
              function getE(i:integer):float;virtual;
              function getP(i:integer):pointer;virtual;

              function getSmoothE(i,d:integer): float; // moyenne entre i-d et i+d
              function getSmoothB(i,d:integer): float; // moyenne entre i-d et i+d

              procedure setI(i:integer;x:integer);virtual;
              procedure setE(i:integer;x:float);virtual;

              procedure addI(i:integer;x:integer);virtual;
              procedure addE(i:integer;x:float);virtual;

              function getCpx(i:integer):TfloatComp;virtual;
              procedure setCpx(i:integer;w:TfloatComp);virtual;
              function getIm(i:integer):float;virtual;
              procedure setIm(i:integer;x:float);virtual;


              {Ces 4 procédures sont utilisées uniquement par copyDataFromVec dans stmVec1}
              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);virtual;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);virtual;

              procedure setBlockS(i:integer;tbI:PtabSingle;n:integer);virtual;
              procedure getBlockS(i:integer;tbI:PtabSingle;n:integer);virtual;


              procedure setConversionX(Dx,X0:float);
              function convX(i:integer):float;
              function invConvX(x:float):integer;
              function invConvXreel(x:float):float;

              procedure setConversionY(Dy,Y0:float);virtual;
              function convY(i:integer):float;virtual;
              function invConvY(x:float):integer;virtual;
              function invConvYreel(x:float):float;virtual;


              procedure setWy(var y1,y2:float);virtual;


              procedure LimitesX(var x1,x2:float);virtual;
              procedure LimitesY(var y1,y2:float;i1,i2:integer);virtual;

              function moyenne(i1,i2:integer):float;virtual;
              function moyenneImag(i1,i2:integer):float;virtual;
              function moyenneComp(i1,i2:integer):TfloatComp;virtual;

              function StdDev(i1,i2:integer):float;virtual;

              function moyenneDistri(i1,i2:integer):float;virtual;
              function StdDevDistri(i1,i2:integer):float;virtual;

              procedure CorrectQuad(x1,x2,a,b,c:float);

              procedure writeBlockToStream(f:Tstream;i1,i2:integer;
                                  tp:typeTypeG);

              procedure readBlockFromStream(f:Tstream;ByteStep:integer;
                                  i1,i2:integer;tp:typeTypeG);


              function FastSlope(i1,i2:integer):float;
              procedure lineFit(i1,i2:integer;var a,b,r:float);
              procedure PlusPetitePente
                 (i1,i2,n:integer;var a,b,reg:float;var ipente:integer);
              procedure PlusGrandePente
                 (i1,i2,n:integer;var a,b,reg:float;var ipente:integer);

              function maxi(i1,i2:integer):float;virtual;
              function mini(i1,i2:integer):float;virtual;
              function maxiX(i1,i2:integer):integer;virtual;
              function miniX(i1,i2:integer):integer;virtual;

              function sum(i1,i2:integer):float;virtual;
              function sumCpx(i1,i2:integer):TfloatComp;virtual;
              function NormInf(i1,i2:integer):float;virtual;
              function NormL1(i1,i2:integer):float;virtual;
              function NormL2(i1,i2:integer):float;virtual;

              procedure LoadBlock;virtual;
              procedure saveBlock;virtual;

              procedure Open;virtual;
              procedure Close;virtual;

              procedure raz;virtual;
              function getName:AnsiString;virtual;
              procedure cadrageX(var i1,i2:integer);

              function nbElt:integer;

              procedure modifyData(pp:pointer);virtual;

              procedure QuickSortUp(L, R: Integer);
              procedure QuickSortDw(L, R: Integer);
              procedure QuickSortIndexUp(L, R: Integer;DataIndex: typeDataB);
              procedure QuickSortIndexDw(L, R: Integer;DataIndex: typeDataB);

              procedure sort(Up: boolean);
              procedure sortWithIndex(Up: boolean;DataIndex: typeDataB);


              function getPointer:pointer;virtual;

              procedure setUnix;virtual;
              function tournant:boolean;virtual;

              property Yvalue[i:integer]:float read getE write setE;default;
            end;

  typeDataX=class(typeDataB)
              constructor create(iMin,Imax:integer);
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;
            end;


  typeEE=function(x:float):float of object;

  typeDataFonc=
            class(typeDataB)
              f0:typeEE;
              constructor create(f:typeEE;x1,x2:float;i1,i2:integer);
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;
            end;



  typeEI=function(i:integer):float of object;
  typeDataGetE=
            class(typeDataB)
              f0:typeEI;
              constructor create(f:typeEI;i1,i2:integer);
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;
            end;

  typeCI=function(i:integer):TfloatComp of object;

  typeDataGetCpx=
            class(typeDataB)
              f0:typeCI;
              constructor create(f:typeCI;i1,i2:integer);
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;
              function getCpx(i:integer):TfloatComp;override;
            end;


  typeDataTab=
            class(typeDataB)
              p:pointer;
              StepSize:smallint;   { nbVoie remplacé par le Step le 6-06-08  StepSize= nb d'octets entre 2 pts successifs}
              indice1:integer;
              canFreeMem:boolean;

              constructor createStep(p0:pointer;step,i1,iMin,Imax:integer);
              constructor createTab0(iMin,Imax,EltSize1:integer);

              destructor destroy;override;

              procedure modifyData(pp:pointer);override;
              function getPointer:pointer;override;
              function getP(i:integer):pointer;override;
            end;


  typeDataE=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

            end;

  typeDataS=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;
              
              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure LimitesY(var y1,y2:float;i1,i2:integer);override;
              function maxi(i1,i2:integer):float;override;
              function mini(i1,i2:integer):float;override;
              function maxiX(i1,i2:integer):integer;override;
              function miniX(i1,i2:integer):integer;override;
              function moyenne(i1,i2:integer):float;override;
              function StdDev(i1,i2:integer):float;override;

              function sum(i1,i2:integer):float;override;
              function NormInf(i1,i2:integer):float;override;
              function NormL1(i1,i2:integer):float;override;
              function NormL2(i1,i2:integer):float;override;
            end;

  typeDataD=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure LimitesY(var y1,y2:float;i1,i2:integer);override;
              function maxi(i1,i2:integer):float;override;
              function mini(i1,i2:integer):float;override;
              function maxiX(i1,i2:integer):integer;override;
              function miniX(i1,i2:integer):integer;override;
              function moyenne(i1,i2:integer):float;override;
              function StdDev(i1,i2:integer):float;override;

              function sum(i1,i2:integer):float;override;
              function NormInf(i1,i2:integer):float;override;
              function NormL1(i1,i2:integer):float;override;
              function NormL2(i1,i2:integer):float;override;
            end;


  typeDataCpxE=
            class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;
              
              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;

              function getCpx(i:integer):TfloatComp;override;
              procedure setCpx(i:integer;w:TfloatComp);override;
              function getIm(i:integer):float;override;
              procedure setIm(i:integer;x:float);override;

              function NormInf(i1,i2:integer):float;override;
              function NormL1(i1,i2:integer):float;override;
              function NormL2(i1,i2:integer):float;override;

              procedure addI(i:integer;x:integer);override;
              procedure raz;override;
              function moyenneImag(i1,i2:integer):float;override;
              function StdDev(i1,i2:integer):float;override;
            end;

  typeDataCpxS=
            class(typeDataCpxE)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;

              function getCpx(i:integer):TfloatComp;override;
              procedure setCpx(i:integer;w:TfloatComp);override;
              function getIm(i:integer):float;override;
              procedure setIm(i:integer;x:float);override;

              procedure addI(i:integer;x:integer);override;

              function sumCpx(i1,i2:integer):TfloatComp;override;
              function NormInf(i1,i2:integer):float;override;
              function NormL1(i1,i2:integer):float;override;
              function NormL2(i1,i2:integer):float;override;

              function moyenneComp(i1,i2:integer):TfloatComp;override;
            end;

  typeDataCpxD=
            class(typeDataCpxE)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;

              function getCpx(i:integer):TfloatComp;override;
              procedure setCpx(i:integer;w:TfloatComp);override;
              function getIm(i:integer):float;override;
              procedure setIm(i:integer;x:float);override;

              procedure addI(i:integer;x:integer);override;

              function sumCpx(i1,i2:integer):TfloatComp;override;
              function NormInf(i1,i2:integer):float;override;
              function NormL1(i1,i2:integer):float;override;
              function NormL2(i1,i2:integer):float;override;

              function moyenneComp(i1,i2:integer):TfloatComp;override;
            end;


const
    DindiceMin=0;
    DindiceMax=4;

    Dp=51;
    DnbVoie=55;
    Dindice1=57;


type
  typeDataI=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;

              procedure LimitesY(var y1,y2:float;i1,i2:integer);override;

              function moyenne(i1,i2:integer):float;override;
              function StdDev(i1,i2:integer):float;override;

            end;

  typedataW=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;
            end;

  typeDataL=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;


              procedure LimitesY(var y1,y2:float;i1,i2:integer);override;

            end;

  typeDataByte=class(typeDataTab)
              constructor createTab(iMin,Imax:integer);
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
            end;


const
  maxBufDF= 12800;                  { taille buffer en octets }

  maxBufI=maxBufDF div 2;
  maxBufL=maxBufI div 2;
  maxBufS=maxBufI div 2;
  maxBufE=maxBufDF div 10;
  maxBufD=maxBufDF div 8;


type
  typeBufDataFile= record
                     case integer of
                       0:(b:array[0..maxBufDF-1] of byte);
                       1:(i:array[0..maxBufI-1] of smallInt);
                       2:(w:array[0..maxBufI-1] of word);
                       3:(l:array[0..maxBufL-1] of integer);
                       4:(s:array[0..maxBufS-1] of single);
                       5:(f:array[0..maxBufE-1] of float);
                       6:(d:array[0..maxBufD-1] of double);
                   end;

  Tmsk=array of boolean;
  TmskSize=array of byte;
  TKsegment=record
              off,size:int64;         {offset  and size in bytes}
            end;
  TKsegArray=array of TKsegment;


  typeDataFileI=
            class(typeDataB)
              nbvoie:integer;
              nomf:AnsiString;
              off:int64;
              Nb:int64;
              forg:TfileStream;
              block:integer;
              Asauver:boolean;
              modeOpen0:boolean;     {positionn‚ pendant create seulement}
              modeOpen:boolean;      {positionn‚ pendant create ou Open }

              tb:^typeBufDataFile;
              maxBuf:integer;        { nb d'éléments dans le buffer }
              size:integer;          { taille d'un élément }
                                     { la taille du buffer est maxBuf*size }
              unix:boolean;

              fstream:TgetStream;
              modeWrite:boolean;

              procedure openf(w:boolean);
              procedure closef;
              procedure InitFile(st:AnsiString;offset:int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);

              procedure PositionneBlock(j:integer);

              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);overload;
              constructor create(f:TgetStream;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);overload;
              function EltSize:integer;override;

              {
              constructor create(st:AnsiString;
                                 iMin,Imax:integer;modeOp:boolean);
              }
              procedure swapBuf;
              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;

              procedure SaveBlock;override;
              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;

              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;


              destructor destroy;override;
              destructor DoneErase;virtual;

              procedure LoadBlock;override;
              procedure Open;override;
              procedure Close;override;
              function getName:AnsiString;override;
              procedure setUnix;override;
              function getPointer:pointer;override;

              procedure InitKfile0(st:AnsiString;modeOp:boolean); { Utilisé par les fichiers SEG }
              procedure InitSegFile(st:AnsiString;segs1:TKsegArray;modeOp:boolean;
                                    SampSize:integer;
                                    var segs:TKsegArray;var Nsegs:integer );
              procedure LoadSegBlock(var segs:TKsegArray;var Nsegs:integer );
            end;


  typeDataFileW=
            class(typeDataFileI)
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);

              function getI(i:integer):integer;override;
              procedure setI(i:integer;x:integer);override;
            end;

  typeDataFileL=
            class(typeDataFileI)
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);

              function getI(i:longint):longint;override;
              procedure setI(i:longint;x:longint);override;
              procedure addI(i:longint;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;

            end;

  typeDataFileB=
            class(typeDataFileI)
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);

              function getI(i:longint):longint;override;
              procedure setI(i:longint;x:longint);override;
              procedure addI(i:longint;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;

            end;


  typeDataFileS=
            class(typeDataFileL)
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);overload;

              constructor create(f:TgetStream;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);overload;

              function getI(i:longint):longint;override;
              function getE(i:longint):float;override;

              procedure setI(i:longint;x:longint);override;
              procedure setE(i:longint;x:float);override;

              procedure addI(i:longint;x:longint);override;

              procedure getBlockS(i:integer;tbI:PtabSingle;n:integer);override;
              procedure setBlockS(i:integer;tbI:PtabSingle;n:integer);override;

            end;

  typeDataFileD=
            class(typeDataFileS)
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);

              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;

              procedure addI(i:integer;x:integer);override;

            end;

  typeDataFileE=
            class(typeDataFileS)
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);

              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;

              procedure addI(i:integer;x:integer);override;

            end;




const
  maxSP=500;
  maxTabSp=10000;

type
  typeSP=record
           x:word;
           date:integer;
         end;
  PtypeSP=^typeSP;

  typeTabSP=array[0..maxTabSp-1] of typeSP;
  PtabSP=^typeTabSP;

  typeStatEV=record
               n:array[0..15] of integer;
               nb0:integer;
               datemax:integer;
             end;

  typeDataEV=class(typeDataB)
              p:pointer;
              indice1:integer;
              voieEv:integer;

              masque:word;
              statEV:typeStatEV;
              modulo:integer;

              constructor create(p0:pointer;
                               voie:integer; { voie de 0 … 15 }
                               i1,iMin,Imax,modulo0:integer);
              function EltSize:integer;override;

              function getX(i:integer):word;virtual;
              function getD(i:integer):integer;virtual;
              procedure getXD(i:integer;var code:word;var d:integer);
                                     virtual;

              function getL(i:integer):integer;virtual;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;
              function getEvt(i:integer):PtypeSP;virtual;

              procedure setEvX(d:integer;xu:word);virtual;
              procedure setEvL(d:integer);virtual;
              procedure setEvE(d:float);virtual;

              destructor destroy;override;

              procedure LoadBlock;override;
              procedure Open;override;
              procedure Close;override;

              function getFirst(date0:float):integer;
              procedure setMask(num:integer);  { de 0 … 15 }
              procedure stat(var s:typeStatEV);
              procedure getTabs(var s:array of PtabLong);
              function getTab(v:integer):PtabLong;

              procedure psth(pTab:typeDataB;Lclasse:float);

              procedure correL(pCorre:pointer;
                              Nmax:integer;
                              dat2:typedataEV;
                              Lclasse:float);
              procedure correE(pCorre:typeDataE;
                              dat2:typedataEV;
                              Lclasse:float;
                              xd1,xd2:float;
                              var count:integer);

              procedure jpX(pCorre:pointer;
                         NbClasseX:integer;
                         LclasseX:float;
                         Nmax:integer;
                         LclasseY:float;
                         dat2:typedataEV);


              procedure LimitesX(var x1,x2:float);override;
              procedure LimitesY(var y1,y2:float;i1,i2:integer);override;

            end;



  typeDataFileEV=
            class(typeDataEV)
              {indiceMin,  indiceMax:integer;} { 1 et nbEV }
              {ax, bx:float}  {bx=0}
              nomf:AnsiString;
              off:integer;
              f:TfileStream;
              block:integer;
              modeOpen0:boolean;
              modeOpen:boolean;
              tb:array[0..maxSP-1] of typeSP;

              Asauver:boolean;
              modeWrite:boolean;

              procedure openf(w:boolean);
              procedure closef;


              constructor create(st:AnsiString;offset: int64;voie:integer;
                               iMin,Imax:integer;modeOp:boolean);

              function getX(i:integer):word;override;
              function getD(i:integer):integer;override;
              procedure getXD(i:integer;var code:word;var d:integer);
                                              override;

              function getL(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;
              function getEvt(i:integer):PtypeSP;override;

              destructor destroy;override;

              procedure LoadBlock;override;
              procedure Open;override;
              procedure Close;override;

              procedure SaveBlock;override;
              procedure setEvX(d:integer;xu:word);override;
              procedure setEvL(d:integer);override;

              function getName:AnsiString;override;
              function getPointer:pointer;override;
            end;


  typeTabTabSp=array[0..9999] of PtabSp;
  PtabtabSP=^typeTabTabSp;

  typeDataEVm=class(typeDataEV)

              constructor create(p0:pointer;
                               voie:integer;  { voie de 0 … 15 }
                               nbEv:integer);

              function getX(i:integer):word;override;
              function getD(i:integer):integer;override;
              procedure getXD(i:integer;var code:word;var d:integer);
                                     override;

              function getEvt(i:integer):PtypeSP;override;
              function getL(i:integer):integer;override;
              function getP(i:integer):pointer;override;

              procedure setEvX(d:integer;xu:word);override;
              procedure setEvL(d:integer);override;

              destructor destroy;override;

            end;

const
  maxSPV=100;
type
  typeDataVectorEV=class(typeDataB)
              dataEV:typedataEV;
              voie:integer;

              tb:array[0..maxSPV-1] of integer;
              IdebBloc,IfinBloc,block:integer;
              kdeb:integer;

              constructor create(dataEV1:typedataEV;voie1:integer);
              function EltSize:integer;override;
              procedure LoadBlock;override;
              function getL(i:integer):integer;virtual;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;

              procedure ModifyLimits(iMin,iMax:integer);override;
            end;

  typeDataIdigi=
            class(typeDataTab)
              Vshift:byte;
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer;shift:integer);

              constructor createStep(p0:pointer;step,i1,iMin,Imax:integer;shift:integer);
              function EltSize:integer;override;
              destructor destroy;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;
            end;

  typeDataFileIdigi=
            class(typeDataFileI)
              Vshift:byte;
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean;shift:integer);

              procedure loadBlock;override;
              procedure saveBlock;override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;

            end;


  typeDataDigiTag=
            class(typeDataTab)
              masque:word;
              constructor create(p0:pointer;nbv,i1,iMin,Imax:integer;rang:integer);
              constructor createStep(p0:pointer;step,i1,iMin,Imax:integer;rang:integer);
              function EltSize:integer;override;
              destructor destroy;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;
            end;

  typeDataFileDigiTag=
            class(typeDataFileI)
              rang0:integer;
              masque:integer;
              constructor create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean;Rang1:integer);overload;
              constructor create(f:TgetStream;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean;Rang1:integer);overload;

              procedure loadBlock;override;
              procedure saveBlock;override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;
            end;



{ typeDataFileIK permet de décrire des fichiers d'entiers:
    - sous-échantillonnés
    - dans lesquels les données sont dans différents segments

  Le masque mask est un tableau de booléens qui indique la répartition des
échantillons dans un agrégat.
  Lmask est le nombre d'éléments du masque (ou de l'agrégat).
  Lp est le nombre de valeurs à TRUE dans le masque.

  segs est un tableau de TKsegment
  Un segment TKsegment est défini par
    - son offset dans le fichier off
    - sa taille size en octets

  Nsegs est le nombre de segments.




  Tmsk=array of boolean;
  TmskSize=array of byte;
  TKsegment=record
              off,size:int64;
            end;
  TKsegArray=array of TKsegment;

}

  typeDataFileIK=
            class(typeDataFileI)
              mask:Tmsk;
              maskSizes:TmskSize;
              Vshift:integer;
              maskTag:word;
              Lmask,Lp:integer;
              AgSize:integer;

              segs:TKsegArray;
              Nsegs:integer;

              constructor create(st:AnsiString;msk:Tmsk;segs1:TKsegArray;
                               modeOp:boolean;shift:integer;MskTag:word);overload;

              constructor create(f:TgetStream;msk:Tmsk;segs1:TKsegArray;
                               modeOp:boolean;shift:integer;MskTag:word);overload;

              constructor create(st:AnsiString;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;
                               modeOp:boolean;shift:integer;MskTag:word);overload;

              constructor create(f:TgetStream;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;
                               modeOp:boolean;shift:integer;MskTag:word);overload;


              procedure InitKFile(st:AnsiString;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;modeOp:boolean);

              procedure loadBlock;override;
              procedure saveBlock;override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;

            end;

{
  typeDataFileTagK gère les tags contenus dans un fichier sous forme compressée.
  Un tag est contenu dans une structure TcybTag qui contient une date ( tt: longword) et un mot de 16 bits (wt:word)
  Les tags sont rangés dans le fichier dans plusieurs segments (segs)
  typeDataFileTagK gère une seule voie correspondant à un bit particulier de wt, ce bit est défini par le masque maskTag.

  Le constructeur reçoit le tableau de segments et le masque.


}

  typeDataFileTagK=
            class(typeDataFileI)
              maskTag:word;
              segs:TKsegArray;
              Nsegs:integer;

              SegBuf:array of TcybTag;
              CybStart, CybEnd: array of TcybTag;
              CurSeg:integer;

              constructor create(st:AnsiString;segs1:TKsegArray;
                               modeOp:boolean;MskTag:word);overload;

              constructor create(f:TgetStream;segs1:TKsegArray;
                               MskTag:word);overload;



              procedure InitKFile(st:AnsiString;segs1:TKsegArray;modeOp:boolean);

              procedure loadSeg(num:integer);
              function GetSegStart(num:integer):longword;
              function GetSegEnd(num:integer):longword;


              procedure loadBlock;override;
              procedure saveBlock;override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;

              function getI(i: integer):integer;override;
            end;


{ Les data SEGL sont formés de plusieurs blocs d'entiers longs consécutifs
  segs contient la liste de ces blocs.

 ==> fichiers de cyber spikes
 Les data SEGB sont formés de plusieurs blocs d'octets consécutifs
 ==> attributs

 Les indices commencent à 1
}

    typeDataFileSegL=
            class(typeDataFileL)

              segs:TKsegArray;
              Nsegs:integer;

              constructor create(st:AnsiString;segs1:TKsegArray;modeOp:boolean);overload;
              constructor create(f:TgetStream;segs1:TKsegArray;modeOp:boolean);overload;
              function EltSize:integer;override;

              procedure loadBlock;override;
            end;

    typeDataFileSegB=
            class(typeDataFileB)

              segs:TKsegArray;
              Nsegs:integer;

              constructor create(st:AnsiString;segs1:TKsegArray;modeOp:boolean);overload;
              constructor create(f:TgetStream;segs1:TKsegArray;modeOp:boolean);overload;

              procedure loadBlock;override;
            end;

    typeDataFileSegU=
            class(typeDataFileL)

              segs:TKsegArray;
              Nsegs:integer;

              constructor create(st:AnsiString;segs1:TKsegArray;Usize:integer;modeOp:boolean);overload;
              constructor create(f:TgetStream;segs1:TKsegArray;Usize:integer;modeOp:boolean);overload;
              function EltSize:integer;override;

              procedure loadBlock;override;
            end;


    typeDataFileSK=
            class(typeDataFileIK)
              constructor create(st:AnsiString;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;modeOp:boolean);overload;
              constructor create(f:TgetStream;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;modeOp:boolean);overload;
              function EltSize:integer;override;

              function getI(i:longint):longint;override;
              function getE(i:longint):float;override;
              function getP(i:integer):pointer;override;

              procedure setI(i:longint;x:longint);override;
              procedure setE(i:longint;x:float);override;

              procedure addI(i:longint;x:longint);override;

              procedure getBlockS(i:integer;tbI:PtabSingle;n:integer);override;
              procedure setBlockS(i:integer;tbI:PtabSingle;n:integer);override;


            end;

    typeDataFileDK=
            class(typeDataFileIK)
              constructor create(st:AnsiString;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;modeOp:boolean);overload;
              constructor create(f:TgetStream;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;modeOp:boolean);overload;
              function EltSize:integer;override;

              function getI(i:longint):longint;override;
              function getE(i:longint):float;override;
              function getP(i:integer):pointer;override;

              procedure setI(i:longint;x:longint);override;
              procedure setE(i:longint;x:float);override;

              procedure addI(i:longint;x:longint);override;


            end;



  { Tableaux tournant
    Indice1 n'a pas la même signification:

      Buf                                                    Fin Buffer
      |_________________|_________|___________|______________|
      0                 i1        imin        imax           Nstep-1

     p0 indique toujours le début du buffer
     i1 est l'indice du point pris comme origine
     ex: getI = Psmallint(intG(p)+ ((i+indice1) mod Nbstep)*StepSize);

     imin et imax ne sont pas utilisés par l'objet data mais l'information
     est transmise au vecteur avec initdata0

  }

  typeDataIT=class(typeDataTab)
              NbStep:integer;     { NbptBuf remplacé par NbStep = nb de points séparés par StepSize dans le buffer circulaire }

              constructor create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
              constructor createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
              function EltSize:integer;override;
                          {Attention: paramètres différents dans l'ancêtre }
              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;  {à garder }

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              function tournant:boolean;override;
            end;

  typeDataLT=class(typeDataTab)
              NbStep:integer;

              constructor create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
              constructor createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              procedure getBlockI(i:integer;tbI:PtabEntier;n:integer);override;
              function tournant:boolean;override;
            end;

  typeDataWT=class(typeDataIT)
              constructor create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
              function EltSize:integer;override;
              function getI(i:integer):integer;override;
              procedure setI(i:integer;x:integer);override;
           end;

  typeDataByteT=
           class(typeDataIT)
              constructor create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
              function EltSize:integer;override;
              function getI(i:integer):integer;override;
              procedure setI(i:integer;x:integer);override;
           end;

  typeDataIdigiT=
            class(typedataIT)
              Vshift:byte;
              constructor create(p0:pointer;nbv,nbpt,i1,imin,imax:integer;shift:integer);
              constructor createStep(p0:pointer;step,Nstep,i1,imin,imax:integer;shift:integer);
              function EltSize:integer;override;
              function getI(i:integer):integer;override;
              procedure setI(i:integer;x:integer);override;
              function getE(i:integer):float;override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;
            end;

  typeDatadigiTagT=
            class(typedataIT)
              masque:word;
              constructor create(p0:pointer;nbv,nbpt,i1,imin,imax:integer;rang:integer);
              constructor createStep(p0:pointer;step,Nstep,i1,imin,imax:integer;rang:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;
              procedure setBlockI(i:integer;tbI:PtabEntier;n:integer);override;
            end;


  typeDataIdigiTev=
            class(typeDataIdigiT)
              constructor create(p0:pointer;nbv,nbpt,imin,imax,shift:integer);
              function EltSize:integer;override;
              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
            end;

  typeDataITev=
            class(typeDataIT)
              constructor create(p0:pointer;nbv,nbpt,imin,imax:integer);
              function EltSize:integer;override;
              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
            end;


  typeDataIbit=
            class(typeDataTab)
              Sbit,Smask:integer;
              constructor create(p0:pointer;nbv,i1,iMin,Imax,Ibit:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;
            end;

  typeDataST=class(typeDataTab)
              NbStep:integer;

              constructor createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;  {à garder }

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              function tournant:boolean;override;
            end;

  typeDataDT=class(typeDataTab)
              NbStep:integer;

              constructor createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
              function EltSize:integer;override;

              function getI(i:integer):integer;override;
              function getE(i:integer):float;override;
              function getP(i:integer):pointer;override;  {à garder }

              procedure setI(i:integer;x:integer);override;
              procedure setE(i:integer;x:float);override;
              procedure addI(i:integer;x:integer);override;

              function tournant:boolean;override;
            end;


  { typeDataSpkExt est construit à partir de deux objets data
                        - un pour les dates
                        - un pour les attributs
                        - att0 indique l'attribut utile
  }
  typeDataSpkExt=
            class(typedataFileL)
              dataTime,dataAtt:TypeDataB;
              Att0:byte;
              Positions:array of integer;
              LastPos:integer;
              constructor create(dataT,dataA:typedataB;att1:byte; Imin,Imax:integer);
              function EltSize:integer;override;
              procedure loadBlock;override;
              procedure ModifyLimits(iMin,iMax:integer);override;
            end;

  typeDataSegUExt=
            class(typedataFileI)
              dataTime,dataAtt:TypeDataB;
              Att0:byte;
              Positions:array of integer;
              constructor create(dataT,dataA:typedataB;att1:byte; Imin,Imax,Usize:integer);
              procedure loadBlock;override;
              procedure open;override;
              procedure close;override;
            end;


function SegArraySize(segs:TKsegArray):int64;

IMPLEMENTATION


{*********************** Méthodes de typeDataB *****************************}

constructor typeDataB.create(imin,imax:integer);
  begin
    indiceMin:=imin;
    indiceMax:=imax;
    ax:=1;
    bx:=0;
    ay:=1;
    by:=0;
    modeCpx:=0;
  end;

function typeDataB.EltSize: integer;
begin
  result:=0;
end;

destructor typeDataB.destroy;
  begin
  end;

procedure typeDataB.modifyLimits(iMin,iMax:integer);
  begin
    indiceMin:=iMin;
    indiceMax:=iMax;
  end;

function typeDataB.getI(i:integer):integer;
  begin
    getI:=roundL(getE(i));
  end;

function typeDataB.getE(i:integer):float;
  begin
    getE:=0;
  end;

function typeDataB.getSmoothE(i,d:integer): float;
var
  k,nb:integer;
begin
  if d<=0 then result:= getE(i)
  else
  begin
    result:=0;
    nb:=0;
    for k:= i-d to i+d do
      if (k>=indicemin) and (k<=indicemax) then
      begin
        result:=result+getE(k);
        inc(nb);
      end;
    result:=  result/nb;
  end;
end;

function typeDataB.getSmoothB(i,d:integer): float;
var
  k,nb,i00:integer;
begin
  if d<=0 then result:= getE(i)
  else
  begin
    i00:=i div d;
    if i<0 then dec(i00);

    i00:=i00*d;

    result:=0;
    nb:=0;
    for k:= i00 to i00+d-1 do
      if (k>=indicemin) and (k<=indicemax) then
      begin
        result:=result+getE(k);
        inc(nb);
      end;
    result:=  result/nb;
  end;
end;

function typeDataB.getP(i:integer):pointer;
begin
  result:=nil;
end;

procedure typeDataB.setI(i:integer;x:integer);
  begin
    setE(i,x);
  end;

procedure typeDataB.addI(i:integer;x:integer);
  begin
    setI(i,getI(i)+x);
  end;

procedure typeDataB.addE(i:integer;x:float);
  begin
    x:=x+getE(i);
    setE(i,x);
  end;

function typeDataB.getCpx(i:integer):TfloatComp;
begin
  result.x:=getE(i);
  result.y:=0;
end;

procedure typeDataB.setCpx(i:integer;w:TfloatComp);
begin
  setE(i,w.x);
end;

function typeDataB.getIm(i:integer):float;
begin
  result:=0;
end;

procedure typeDataB.setIm(i:integer;x:float);
begin

end;


procedure typeDataB.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataB.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;

procedure typeDataB.setBlockS(i:integer;tbI:PtabSingle;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setE(j,tbI^[j-i]);
  end;


procedure typeDataB.getBlockS(i:integer;tbI:PtabSingle;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getE(j);
  end;



procedure typeDataB.setE(i:integer;x:float);
  begin
  end;


procedure typeDataB.setConversionX(Dx,X0:float);
  begin
    ax:=Dx;
    bx:=X0;
  end;

function typeDataB.convX(i:integer):float;
  begin
    convX:=aX*i+bX;
  end;

function typeDataB.invConvX(x:float):integer;
  begin
    if aX<>0 then invConvX:=roundL((x-bX)/aX);
  end;

function typeDataB.invConvXreel(x:float):float;
  begin
    if aX<>0 then invConvXreel:=(x-bX)/aX;
  end;


procedure typeDataB.setConversionY(Dy,Y0:float);
  begin
    ay:=Dy;
    by:=Y0;
  end;

function typeDataB.convY(i:integer):float;
  begin
    convY:=aY*i+bY;
  end;

function typeDataB.invConvY(x:float):integer;
  begin
    if aY<>0 then invConvY:=roundL((x-bY)/aY);
  end;

function typeDataB.invConvYreel(x:float):float;
  begin
    if aY<>0 then invConvYreel:=(x-bY)/aY;
  end;


procedure typeDataB.setWy(var y1,y2:float);
  begin
    y1:=invConvy(y1);
    y2:=invconvy(y2);
  end;


procedure typeDataB.LimitesX(var x1,x2:float);
  begin
    x1:=convX(indiceMin);
    x2:=convX(indiceMax);
  end;

procedure typeDataB.LimitesY(var y1,y2:float;i1,i2:integer);
  var
    i:integer;
    v:integer;
    flagMax:boolean;
  begin
    if (i1=0) and (i2=0) then
      begin
        i1:=indiceMin;
        i2:=indiceMax;
      end;

    if not tournant then
    begin
      if i1<indiceMin then i1:=indiceMin;
      if i2>indiceMax then i2:=indiceMax;
    end;

    if i2>=i1 then
    begin
      open;
      y1:= 1E300;
      y2:=-1E300;
      FlagMax:=(I2-I1>100000);
      for i:=i1 to i2 do
        begin
          if FlagMax and (i mod 10000=0) and TestEscape then
            begin
              close;
              exit;
            end;
          if getE(i)<y1 then y1:=getE(i);
          if getE(i)>y2 then y2:=getE(i);
        end;
      close;
    end
    else
    begin
      y1:=0;
      y2:=0;
    end;
  end;

function typeDataB.moyenne(i1,i2:integer):float;
  var
    i:integer;
    m:float;
  begin
    moyenne:=0;
    if i1>i2 then exit;

    m:=0;
    for i:=i1 to i2 do m:=m+getE(i);
    moyenne:=m/(i2-i1+1);
  end;

function typeDataB.moyenneImag(i1,i2:integer):float;
begin
  result:=0;
end;

function typeDataB.moyenneComp(i1,i2:integer):TfloatComp;
begin
  result.x:=moyenne(i1,i2);
  result.y:=moyenneImag(i1,i2);
end;

function typeDataB.StdDev(i1,i2:integer):float;
  var
    i:integer;
    m,sig:float;
  begin
    StdDev:=0;
    if i1>=i2 then exit;

    m:=0;
    for i:=i1 to i2 do m:=m+getE(i);
    m:=m/(i2-i1+1);
    sig:=0;
    for i:=i1 to i2 do sig:=sig+sqr(getE(i)-m);
    StdDev:=sqrt(sig/(i2-i1));     {on divise par n-1}
  end;

function typeDataB.moyenneDistri(i1,i2:integer):float;
  var
    i:integer;
    N,Si,Sx:float;
  begin
    moyenneDistri:=0;
    if i1>i2 then exit;


    Si:=0;
    N:=0;
    for i:=i1 to i2 do
      begin
        Si:=Si+i*getE(i);
        N:=N+getE(i);
      end;

    Sx:=ax*Si+bx*N;

    if N<>0 then moyenneDistri:=Sx/N;
  end;

function typeDataB.StdDevDistri(i1,i2:integer):float;
  var
    i:integer;
    N,Si,Si2,Sx,Sx2:float;
  begin
    StdDevDistri:=0;
    if i1>i2 then exit;

    N:=0;
    si:=0;
    Si2:=0;

    for i:=i1 to i2 do
      begin
        N:=N+getE(i);
        si:=si+i*getE(i);
        si2:=si2+i*i*getE(i);
      end;
    if N<=1 then exit;

    Sx:=ax*Si+bx*N;
    Sx2:=sqr(ax)*Si2 + 2*ax*bx*Si + sqr(bx)*N;

    if N>1 then StdDevDistri:=sqrt((sx2-sqr(Sx)/N)/(N-1));
  end;


procedure typeDataB.CorrectQuad(x1,x2,a,b,c:float);
  var
    i,i1,i2:integer;
    y:float;
  begin
    open;
    i1:=invConvX(x1);
    i2:=invConvX(x2);
    if i1>i2 then exit;

    if (i1=0) and (i2=0) then i2:=indiceMax;
    for i:=i1 to i2 do
      begin
        y:=getE(i);
        y:=a*sqr(y)+b*y+c;
        setE(i,y);
      end;
    close;
  end;


procedure typeDataB.writeBlockToStream(f:Tstream;i1,i2:integer;tp:typeTypeG);
  var
    buf:pointer;
    m:int64;
    Nmax:integer;
    i:integer;
    j:integer;
    res:intG;
    ts:word;
    z:TfloatComp;
  begin
    ts:=tailleTypeG[tp];
    m:=maxavail;
    if m>60000 then m:=60000;
    getmem(buf,m);

    Nmax:=m div ts;

    j:=0;
    open;
    for i:=i1 to i2 do
      begin
        case tp of
          G_byte:           PtabOctet(buf)^[j]:=getI(i);
          G_short:          PtabShort(buf)^[j]:=getI(i);

          G_smallint:       PtabEntier(buf)^[j]:=getI(i);
          G_word:           PtabWord(buf)^[j]:=getI(i);
          G_longint:        PtabLong(buf)^[j]:=getI(i);
          G_single:         Ptabsingle(buf)^[j]:=getE(i);
          G_double:         PtabDouble(buf)^[j]:=getE(i);
          G_extended:       PtabFloat(buf)^[j]:=getE(i);
          G_singleComp:     with PtabSingleComp(buf)^[j] do
                            begin
                              z:=getCpx(i);
                              x:=z.x;
                              y:=z.y;
                            end;
          G_doubleComp:     with PtabDoubleComp(buf)^[j] do
                            begin
                              z:=getCpx(i);
                              x:=z.x;
                              y:=z.y;
                            end;
          G_extComp:        PtabFloatComp(buf)^[j]:=getCpx(i);

        end;

        inc(j);
        if j=Nmax then
          begin
            f.writeBuffer(buf^,ts*Nmax);
            j:=0;
          end;
      end;
    if j<>0 then f.writeBuffer(buf^,j*ts);

    freemem(buf,m);
    close;
  end;

procedure typeDataB.readBlockFromStream(f:Tstream;ByteStep:integer;
                               i1,i2:integer;tp:typeTypeG);
  var
    buf,p,Pmax:pointer;
    m:int64;
    Nbytes,Nmax:integer;
    i:integer;
    j:integer;
    res:intG;
    fpos:int64;
    ts:integer;
    z:TfloatComp;
  begin
    ts:=tailleTypeG[tp];
    if i1<indicemin then i1:=indicemin;
    if i2>indicemax then i2:=indicemax;
    Nbytes:=(i2-i1+1)*ts;

    m:=maxAvail;
    if m>1000000 then m:=1000000;
    if Nbytes<m then m:=Nbytes;

    getmem(buf,m);
        
    if ByteStep=0 then ByteStep:= ts;
    Nmax:=m div ByteStep;

    open;
    

    j:=0;
    fPos:=f.position;
    p:=buf;
    pMax:= pointer(intG(buf)+Nmax*ByteStep);

    for i:=i1 to i2 do
      begin
        if p=buf then res:=f.read(buf^,ByteStep*Nmax);

        if intG(p)< intG(pMax) then
          case tp of
            G_byte:           setI(i,Pbyte(p)^);
            G_short:          setI(i,PShort(p)^);

            G_smallint:       setI(i,Psmallint(p)^);
            G_word:           setI(i,Pword(p)^);
            G_longint:        setI(i,Plongint(p)^);
            G_single:         setE(i,Psingle(p)^);
            G_double:         setE(i,Pdouble(p)^);
            G_extended:       setE(i,Pextended(p)^);
            G_singleComp:     with PSingleComp(p)^ do
                              begin
                                z.x:=x;
                                z.y:=y;
                                setCpx(i,z);
                              end;
            G_doubleComp:     with PDoubleComp(p)^ do
                              begin
                                z.x:=x;
                                z.y:=y;
                                setCpx(i,z);
                              end;
            G_extComp:        setCpx(i,PFloatComp(p)^);

          end;
        inc(intG(p),ByteStep);
        if intG(p) >= intG(Pmax) then p:=buf;
      end;

    close;
    freemem(buf,m);
  end;


procedure typeDataB.lineFit(i1,i2:integer;var a,b,r:float);
  var
    i:integer;
    sommeX,sommeX2,sommeY,sommeY2,sommeXY:float;
    x,u,delta:float;
    N:integer;

  begin
    open;
    N:=i2-i1+1;
    if N<=1 then
      begin
        a:=0;
        b:=0;
        r:=0;
        exit;
      end;

    sommeX:=0;
    sommeX2:=0;
    sommeY:=0;

    sommeY2:=0;
    sommeXY:=0;
    for i:=i1 to i2 do
      begin
        x:=convx(i);
        sommeX:=sommeX+x;
        sommeX2:=sommeX2+sqr(x);
        sommeY:=sommeY+getE(i);
        sommeY2:=sommeY2+sqr(getE(i));
        sommeXY:=sommeXY+x*getE(i);
      end;
    delta:=N*sommeX2-sommeX*sommeX;
    b:=(sommeX2*sommeY-sommeX*sommeXY)/Delta;
    a:=(N*sommeXY-sommeX*sommeY)/Delta;

    u:=sqrt(abs(sommeX2*N-sqr(sommeX)))*sqrt(abs(sommeY2*N-sqr(sommeY)));
    if u<>0 then R:= abs( (sommeXY*N-sommeX*sommeY)/u )
            else R:=0;
    close;
  end;

function typeDataB.FastSlope(i1,i2:integer):float;
  var
    i:integer;
    sommeX,sommeX2,sommeY,sommeY2,sommeXY:float;
    x,u,delta:float;
    N:integer;

  begin
    open;
    N:=i2-i1+1;
    if N<=1 then
      begin
        FastSlope:=0;
        exit;
      end;

    sommeX:=0;
    sommeX2:=0;
    sommeY:=0;

    sommeY2:=0;
    sommeXY:=0;
    for i:=i1 to i2 do
      begin
        x:=convx(i);
        sommeX:=sommeX+x;
        sommeX2:=sommeX2+sqr(x);
        sommeY:=sommeY+getE(i);
        sommeY2:=sommeY2+sqr(getE(i));
        sommeXY:=sommeXY+x*getE(i);
      end;
    delta:=N*sommeX2-sommeX*sommeX;
    fastSlope:=(N*sommeXY-sommeX*sommeY)/Delta;

    close;
  end;


procedure typeDataB.PlusPetitePente
 (i1,i2,n:integer;var a,b,reg:float;var ipente:integer);
  var
    i:integer;
    a0,b0,reg0:float;
  begin
    ipente:=i1+n div 2;
    linefit(i1,i1+n-1,a,b,reg);
    for i:=i1+1 to i2-n+1 do
      begin
        linefit(i,i+n-1,a0,b0,reg0);
        if a0<a then
          begin
            a:=a0;
            b:=b0;
            reg:=reg0;
            ipente:=i+ n div 2;
          end;
        end;
  end;

procedure typeDataB.PlusGrandePente
 (i1,i2,n:integer;var a,b,reg:float;var ipente:integer);
  var
    i:integer;
    a0,b0,reg0:float;
  begin
    ipente:=i1+n div 2;
    linefit(i1,i1+n-1,a,b,reg);
    for i:=i1+1 to i2-n+1 do
      begin
        linefit(i,i+n-1,a0,b0,reg0);
        if a0>a then
          begin
            a:=a0;
            b:=b0;
            reg:=reg0;
            ipente:=i+ n div 2;
          end;
        end;
  end;

function typeDataB.maxi(i1,i2:integer):float;
  var
    i:integer;
    max,y:float;
  begin
    max:=-1E1000;
    for i:=i1 to i2 do
      begin
        y:=getE(i);
        if y>max then max:=y;
      end;
    Maxi:=max;
  end;

function typeDataB.mini(i1,i2:integer):float;
  var
    i:integer;
    min,y:float;
  begin
    min:=1E1000;
    for i:=i1 to i2 do
      begin
        y:=getE(i);
        if y<min then min:=y;
      end;
    Mini:=min;
  end;

function typeDataB.miniX(i1,i2:integer):integer;
  var
    i,ix:integer;
    min,y:float;
  begin
    min:=1E1000;
    for i:=i1 to i2 do
      begin
        y:=getE(i);
        if y<min then
          begin
            min:=y;
            ix:=i;
          end;
      end;
    MiniX:=ix;
  end;

function typeDataB.maxiX(i1,i2:integer):integer;
  var
    i,ix:integer;
    max,y:float;
  begin
    max:=-1E1000;
    for i:=i1 to i2 do
      begin
        y:=getE(i);
        if y>max then
          begin
            max:=y;
            ix:=i;
          end;
      end;
    MaxiX:=ix;
  end;

function typeDataB.sum(i1,i2:integer):float;
var
  i:integer;
begin
  result:=0;
  for i:=i1 to i2 do
    result:=result+getE(i);
end;

function typeDataB.sumCpx(i1,i2:integer):TfloatComp;
var
  i:integer;
begin
  result.x:=0;
  result.y:=0;
  for i:=i1 to i2 do
  begin
    result.x:=result.x+getE(i);
    result.y:=result.y+getIm(i);
  end;
end;


function typeDataB.NormInf(i1,i2:integer):float;
var
  i:integer;
  w:float;
begin
  result:=0;
  for i:=i1 to i2 do
  begin
    w:=abs(getE(i));               {ne prend pas en compte les complexes}
    if w>result then result:=w;
  end;
end;

function typeDataB.NormL1(i1,i2:integer):float;
var
  i:integer;
begin
  result:=0;
  for i:=i1 to i2 do
    result:=result+abs(getE(i));   {ne prend pas en compte les complexes}
end;

function typeDataB.NormL2(i1,i2:integer):float;
var
  i:integer;
begin
  result:=0;
  for i:=i1 to i2 do
    result:=result+sqr(getE(i));   {ne prend pas en compte les complexes}
  result:=sqrt(result)
end;


procedure typeDataB.LoadBlock;
  begin
  end;

procedure typeDataB.saveBlock;
  begin
  end;


procedure typeDataB.Open;
  begin
  end;

procedure typeDataB.Close;
  begin
  end;

procedure typeDataB.raz;
  var
    i:integer;
  begin
    for i:=indiceMin to indiceMax do setE(i,0);
  end;

function typeDataB.getName:AnsiString;
  begin
    getName:='';
  end;

procedure typeDataB.cadrageX(var i1,i2:integer);
  begin
    if i1<indiceMin then i1:=indiceMin;
    if i2>indiceMax then i2:=indicemax;
  end;

function typeDataB.nbElt:integer;
  begin
    nbElt:=indiceMax-indiceMin+1;
  end;

procedure typeDataB.modifyData(pp:pointer);
begin
end;

procedure typeDataB.QuickSortUp(L, R: Integer);
var
  I, J: Integer;
  P, T: float;
begin
  repeat
    I := L;
    J := R;
    P := getE((L + R) shr 1);
    repeat
      while getE(I)< P do Inc(I);
      while getE(J)> P do Dec(J);
      if I <= J then
      begin
        T := getE(I);
        setE(I,getE(J));
        setE(J,T);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortUp(L, J);
    L := I;
  until I >= R;
end;

procedure typeDataB.QuickSortDw(L, R: Integer);
var
  I, J: Integer;
  P, T: float;
begin
  repeat
    I := L;
    J := R;
    P := getE((L + R) shr 1);
    repeat
      while getE(I)> P do Inc(I);
      while getE(J)< P do Dec(J);
      if I <= J then
      begin
        T := getE(I);
        setE(I,getE(J));
        setE(J,T);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortDw(L, J);
    L := I;
  until I >= R;
end;

procedure typeDataB.QuickSortIndexUp(L, R: Integer; DataIndex: typeDataB);
var
  I, J: Integer;
  P, T: float;
  Pt,It: float;
begin
  repeat
    I := L;
    J := R;
    P := getE((L + R) shr 1);
    Pt := dataIndex.getE((L + R) shr 1);
    repeat
      while (getE(I)< P) or (getE(I)=P) and  (dataIndex.getE(I)<Pt) do Inc(I);
      while (getE(J)> P) or (getE(J)=P) and (dataIndex.getE(J)>Pt) do Dec(J);
      if I <= J then
      begin
        T := getE(I);
        It:= DataIndex.getE(I);

        setE(I,getE(J));
        DataIndex.setE(I, DataIndex.getE(J));

        setE(J,T);
        DataIndex.setE(J, It);

        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortIndexUp(L, J,DataIndex);
    L := I;
  until I >= R;
end;

procedure typeDataB.QuickSortIndexDw(L, R: Integer; DataIndex: typeDataB);
var
  I, J: Integer;
  P, T: float;
  It: float;
begin
  repeat
    I := L;
    J := R;
    P := getE((L + R) shr 1);
    repeat
      while getE(I)> P do Inc(I);
      while getE(J)< P do Dec(J);
      if I <= J then
      begin
        T := getE(I);
        It:= DataIndex.getE(I);

        setE(I,getE(J));
        DataIndex.setE(I, DataIndex.getE(J));

        setE(J,T);
        DataIndex.setE(J, It);

        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSortIndexDw(L, J,DataIndex);
    L := I;
  until I >= R;
end;


procedure typeDataB.Sort(Up: boolean);
begin
  if (Indicemax>=Indicemin) then
    if Up
      then QuickSortUp(indiceMin, indicemax)
      else QuickSortDw(indiceMin, indicemax);
end;

procedure typeDataB.sortWithIndex(Up: boolean;DataIndex: typeDataB);
begin
  if (Indicemax>=Indicemin) then
    if Up
      then QuickSortIndexUp(indiceMin, indicemax,DataIndex)
      else QuickSortIndexDw(indiceMin, indicemax,DataIndex);
end;

function typeDataB.getPointer:pointer;
begin
  result:=nil;
end;

procedure typeDataB.setUnix;
begin
end;

function typeDataB.tournant:boolean;
begin
  result:=false;
end;

{*********************** Méthodes de typeDataX *****************************}

constructor typeDataX.create(iMin,Imax:integer);
begin
  inherited create(imin,imax);
end;

function typeDataX.getE(i:integer):float;
begin
  getE:=i*ay+by;
end;

function typeDataX.getP(i:integer):pointer;
begin
  result:=nil;
end;


{*********************** Méthodes de typeDataFonc *****************************}
constructor typeDataFonc.create(f:typeEE;x1,x2:float;i1,i2:integer);
begin
  inherited create(i1,i2);

  f0:=f;

  ax:=(x2-x1)/(i2-i1);
  bx:=x1-ax*i1;
end;

function typeDataFonc.getE(i:integer):float;
begin
  try
  getE:=f0(ax*i+bx);
  except
  getE:=0;
  end;
end;

function typeDataFonc.getP(i:integer):pointer;
begin
  result:=nil;
end;


{*********************** Méthodes de typeDataGetE *****************************}
constructor typeDataGetE.create(f:typeEI;i1,i2:integer);
begin
  inherited create(i1,i2);

  f0:=f;
end;

function typeDataGetE.getE(i:integer):float;
begin
  try
    getE:=f0(i);
  except
    getE:=0;
  end;
end;

function typeDataGetE.getP(i:integer):pointer;
begin
  result:=nil;
end;


{*********************** Méthodes de typeDataGetCpx *****************************}

constructor typeDataGetCpx.create(f:typeCI;i1,i2:integer);
begin
  inherited create(i1,i2);

  f0:=f;
end;

function typeDataGetCpx.getE(i:integer):float;
var
  z:TfloatComp;
begin
  try
    z:=f0(i);
    case modeCpx of
      0: result:= z.x;
      1: result:= z.y;
      2: result:=sqrt(sqr(z.x)+sqr(z.y));
      3: result:=arctan2(z.y,z.x);
    end;

  except
    result:=0;
  end;
end;

function typeDataGetCpx.getCpx(i:integer):TfloatComp;
begin
  try
    result:=f0(i);
  except
    result.x:=0;
    result.y:=0;
  end;
end;

function typeDataGetCpx.getP(i:integer):pointer;
begin
  result:=nil;
end;

{*********************** Méthodes de typeDataTab *****************************}

constructor typeDataTab.createStep(p0:pointer;step,i1,iMin,Imax:integer);
begin
  inherited create(imin,imax);
  p:=p0;
  StepSize:=step;
  indice1:=i1;
  canFreeMem:=false;
end;

constructor typeDataTab.createTab0(iMin,Imax,EltSize1:integer);
begin
  inherited create(imin,imax);
  getmem(p,EltSize1*(imax-imin+1));
  StepSize:=EltSize1;
  indice1:=Imin;
  canFreeMem:=true;
end;


destructor typeDataTab.destroy;
begin
  if canFreeMem and assigned(p)
    then dispose(p);
end;


procedure typeDataTab.modifyData(pp:pointer);
begin
  p:=pp;
end;

function typeDataTab.getPointer:pointer;
begin
  result:=p;
end;

function typeDataTab.getP(i:integer):pointer;
begin
  if (i>=indicemin) and (i<=indicemax)
    then result:=pointer(intG(p) +(i-indice1)*StepSize)
    else result:=nil;
end;


{*********************** Méthodes de typeDataE *****************************}


constructor typeDataE.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,10);
end;

constructor typeDataE.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*10,i1,iMin,iMax);
end;

function typeDataE.EltSize: integer;
begin
  result:=10;
end;

function typeDataE.getE(i:integer):float;
  begin
    getE:=Pfloat(intG(p) +(i-indice1)*StepSize)^;
  end;

procedure typeDataE.addI(i:integer;x:integer);
  var
    p1:Pfloat;
  begin
    intG(p1):=intG(p)+(i-indice1)*StepSize;
    p1^:=p1^+x;
  end;

procedure typeDataE.setE(i:integer;x:float);
  begin
    PFloat(intG(p)+ (i-indice1)*StepSize)^:=x;
  end;



{*********************** Méthodes de typeDataS *****************************}

constructor typeDataS.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(single));
end;

constructor typeDataS.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*4,i1,iMin,iMax);
end;

function typeDataS.EltSize: integer;
begin
  result:=4;
end;

function typeDataS.getE(i:integer):float;
  begin
    getE:=Psingle(intG(p) +(i-indice1)*StepSize)^;
  end;

procedure typeDataS.setE(i:integer;x:float);
  begin
    PSingle(intG(p)+(i-indice1)*StepSize)^:=x;
  end;

procedure typeDataS.addI(i:integer;x:integer);
  var
    p1:Psingle;
  begin
    intG(p1):=intG(p)+(i-indice1)*StepSize;
    p1^:=p1^+x;
  end;

procedure typeDataS.LimitesY(var y1,y2:float;i1,i2:integer);
var
  y1s,y2s:single;
begin
  if (StepSize=4) then
  begin
    if (i1=0) and (i2=0) then
      begin
        i1:=indiceMin;
        i2:=indiceMax;
      end
    else
    if not tournant then
    begin
      if i1<indiceMin then i1:=indiceMin;
      if i2>indiceMax then i2:=indiceMax;
    end;

    if i2>=i1 then
    begin
      IPPStest;
      ippsminmax_32f(Psingle(getP(i1)),i2-i1+1,@y1s,@y2s);
      ippsEnd;
      y1:=y1s;
      y2:=y2s;
    end
    else
    begin
      y1:=0;
      y2:=0;
    end;
  end
  else inherited;
end;

function typeDataS.maxi(i1,i2:integer):float;
var
  ys:single;
begin
  if (StepSize=4) then
  begin
    IPPStest;
    ippsmax_32f(Psingle(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited maxi(i1,i2);
end;

function typeDataS.mini(i1,i2:integer):float;
var
  ys:single;
begin
  if (StepSize=4) then
  begin
    IPPStest;
    ippsmin_32f(Psingle(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited mini(i1,i2);
end;

function typeDataS.maxiX(i1,i2:integer):integer;
var
  ys:single;
  indx:integer;
begin
  if (StepSize=4) then
  begin
    IPPStest;
    ippsmaxIndx_32f(Psingle(getP(i1)),i2-i1+1,@ys,@indx);
    ippsEnd;
    result:=indx+i1;
  end
  else result:=inherited maxiX(i1,i2);
end;

function typeDataS.miniX(i1,i2:integer):integer;
var
  ys:single;
  indx:integer;
begin
  if (StepSize=4) then
  begin
    IPPStest;
    ippsminIndx_32f(Psingle(getP(i1)),i2-i1+1,@ys,@indx);
    ippsEnd;
    result:=indx+i1;
  end
  else result:=inherited miniX(i1,i2);
end;

function typeDataS.moyenne(i1,i2:integer):float;
var
  ys:single;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=4) then
  begin
    IPPStest;
    ippsmean_32f(Psingle(getP(i1)),i2-i1+1,@ys,ippAlgHintNone);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited miniX(i1,i2);
end;

function typeDataS.StdDev(i1,i2:integer):float;
var
  ys:single;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=4) then
  begin
    IPPStest;
    ippsStdDev_32f(Psingle(getP(i1)),i2-i1+1,@ys,ippAlgHintNone);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited miniX(i1,i2);
end;

function typeDataS.sum(i1,i2:integer):float;
var
  ys:single;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=4) then
  begin
    IPPStest;
    ippsSum_32f(Psingle(getP(i1)),i2-i1+1,@ys,ippAlgHintNone);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited sum(i1,i2);
end;

function typeDataS.NormInf(i1,i2:integer):float;
var
  ys:single;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=4) then
  begin
    IPPStest;
    ippsNorm_inf_32f(Psingle(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormInf(i1,i2);
end;

function typeDataS.NormL1(i1,i2:integer):float;
var
  ys:single;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=4) then
  begin
    IPPStest;
    ippsNorm_L1_32f(Psingle(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL1(i1,i2);
end;

function typeDataS.NormL2(i1,i2:integer):float;
var
  ys:single;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=4) then
  begin
    IPPStest;
    ippsNorm_L2_32f(Psingle(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL2(i1,i2);
end;


{*********************** Méthodes de typeDataD *****************************}

constructor typeDataD.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(double));
end;

constructor typeDataD.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*8,i1,iMin,iMax);
end;

function typeDataD.EltSize: integer;
begin
  result:=8;
end;

function typeDataD.getE(i:integer):float;
  begin
    getE:=Pdouble(intG(p)+(i-indice1)*StepSize)^
  end;

procedure typeDataD.setE(i:integer;x:float);
  begin
    PDouble((intG(p)+(i-indice1)*StepSize))^:=x;
  end;

procedure typeDataD.addI(i:integer;x:integer);
  var
    p1:Pdouble;
  begin
    intG(p1):=intG(p)+(i-indice1)*StepSize;
    p1^:=p1^+x;
  end;

procedure typeDataD.LimitesY(var y1,y2:float;i1,i2:integer);
var
  y1s,y2s:double;
begin
  if (StepSize=8) then
  begin
    if (i1=0) and (i2=0) then
      begin
        i1:=indiceMin;
        i2:=indiceMax;
      end
    else
    if not tournant then
    begin
      if i1<indiceMin then i1:=indiceMin;
      if i2>indiceMax then i2:=indiceMax;
    end;

    if i2>=i1 then
    begin
      IPPStest;
      ippsminmax_64f(Pdouble(getP(i1)),i2-i1+1,@y1s,@y2s);
      ippsEnd;
      y1:=y1s;
      y2:=y2s;
    end
    else
    begin
      y1:=0;
      y2:=0;
    end;
  end
  else inherited;
end;

function typeDataD.maxi(i1,i2:integer):float;
var
  ys:double;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsmax_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited maxi(i1,i2);
end;

function typeDataD.mini(i1,i2:integer):float;
var
  ys:double;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsmin_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited mini(i1,i2);
end;

function typeDataD.maxiX(i1,i2:integer):integer;
var
  ys:double;
  indx:integer;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsmaxIndx_64f(Pdouble(getP(i1)),i2-i1+1,@ys,@indx);
    ippsEnd;
    result:=indx+i1;
  end
  else result:=inherited maxiX(i1,i2);
end;

function typeDataD.miniX(i1,i2:integer):integer;
var
  ys:double;
  indx:integer;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsminIndx_64f(Pdouble(getP(i1)),i2-i1+1,@ys,@indx);
    ippsEnd;
    result:=indx+i1;
  end
  else result:=inherited miniX(i1,i2);
end;

function typeDataD.moyenne(i1,i2:integer):float;
var
  ys:double;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=8) then
  begin
    IPPStest;
    ippsmean_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited miniX(i1,i2);
end;

function typeDataD.StdDev(i1,i2:integer):float;
var
  ys:double;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=8) then
  begin
    IPPStest;
    ippsStdDev_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited StdDev(i1,i2);
end;

function typeDataD.sum(i1,i2:integer):float;
var
  ys:double;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=8) then
  begin
    IPPStest;
    ippsSum_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited sum(i1,i2);
end;

function typeDataD.NormInf(i1,i2:integer):float;
var
  ys:double;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=8) then
  begin
    IPPStest;
    ippsNorm_inf_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormInf(i1,i2);
end;

function typeDataD.NormL1(i1,i2:integer):float;
var
  ys:double;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=8) then
  begin
    IPPStest;
    ippsNorm_L1_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL1(i1,i2);
end;

function typeDataD.NormL2(i1,i2:integer):float;
var
  ys:double;
begin
  if i1>i2 then result:=0
  else
  if (StepSize=8) then
  begin
    IPPStest;
    ippsNorm_L2_64f(Pdouble(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL2(i1,i2);
end;


{*********************** Méthodes de typeDataCpxS *****************************}

constructor typeDataCpxS.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(TsingleComp));
end;

constructor typeDataCpxS.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*8,i1,iMin,iMax);
end;

function typeDataCpxS.EltSize: integer;
begin
  result:=8;
end;

function typeDataCpxS.getE(i:integer):float;
begin
  with PSingleComp(intG(p)+(i-indice1)*StepSize)^ do
  case modeCpx of
    0: result:= x;
    1: result:= y;
    2: result:=sqrt(sqr(x)+sqr(y));
    3: result:=arctan2(y,x);
  end;
end;

procedure typeDataCpxS.setE(i:integer;x:float);
begin
  PSingleComp(intG(p)+(i-indice1)*StepSize)^.x:=x;
end;

procedure typeDataCpxS.addI(i:integer;x:integer);
var
  p1:PsingleComp;
begin
  intG(p1):= intG(p)+(i-indice1)*StepSize;
  p1^.x:=p1^.x+x;
end;

function typeDataCpxS.getCpx(i:integer):TfloatComp;
begin
  with PSingleComp(intG(p)+(i-indice1)*StepSize)^ do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure typeDataCpxS.setCpx(i:integer;w:TfloatComp);
begin
  with PSingleComp(intG(p)+(i-indice1)*StepSize)^ do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function typeDataCpxS.getIm(i:integer):float;
begin
  result:= PSingleComp(intG(p)+(i-indice1)*StepSize)^.y
end;

procedure typeDataCpxS.setIm(i:integer;x:float);
begin
  PSingleComp(intG(p)+(i-indice1)*StepSize)^.y:=x;
end;

function typeDataCpxS.sumCpx(i1,i2:integer):TfloatComp;
var
  ys:TsingleComp;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsSum_32fc(PsingleComp(getP(i1)),i2-i1+1,@ys,ippAlgHintNone);
    ippsEnd;
    result.x:=ys.x;
    result.y:=ys.y;
  end
  else result:=inherited sumCpx(i1,i2);
end;

function typeDataCpxS.NormInf(i1,i2:integer):float;
var
  ys:single;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsNorm_inf_32fc32f(PsingleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormInf(i1,i2);
end;

function typeDataCpxS.NormL1(i1,i2:integer):float;
var
  ys:double;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsNorm_L1_32fc64f(PsingleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL1(i1,i2);
end;

function typeDataCpxS.NormL2(i1,i2:integer):float;
var
  ys: double;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsNorm_L2_32fc64f(PsingleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL2(i1,i2);
end;

function typeDataCpxS.moyenneComp(i1,i2:integer):TfloatComp;
var
  ys:TsingleComp;
begin
  if (StepSize=8) then
  begin
    IPPStest;
    ippsmean_32fc(PsingleComp(getP(i1)),i2-i1+1,@ys,ippAlgHintNone);
    ippsEnd;
    result.x:=ys.x;
    result.y:=ys.y;
  end
  else result:=inherited moyenneComp(i1,i2);
end;


{*********************** Méthodes de typeDataCpxD *****************************}

constructor typeDataCpxD.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(TdoubleComp));
end;

constructor typeDataCpxD.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*16,i1,iMin,iMax);
end;

function typeDataCpxD.EltSize: integer;
begin
  result:=16;
end;

function typeDataCpxD.getE(i:integer):float;
begin
  with PdoubleComp(intG(p)+(i-indice1)*StepSize)^ do
  case modeCpx of
    0: result:= x;
    1: result:= y;
    2: result:=sqrt(sqr(x)+sqr(y));
    3: result:=arctan2(y,x);
  end;
end;


procedure typeDataCpxD.setE(i:integer;x:float);
begin
  PDoubleComp(intG(p)+(i-indice1)*StepSize)^.x:=x;
end;

procedure typeDataCpxD.addI(i:integer;x:integer);
var
  p1:PdoubleComp;
begin
  intG(p1):=intG(p)+(i-indice1)*StepSize;
  p1^.x:=p1^.x+x;
end;

function typeDataCpxD.getCpx(i:integer):TfloatComp;
begin
  with PDoubleComp(intG(p)+(i-indice1)*StepSize)^ do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure typeDataCpxD.setCpx(i:integer;w:TfloatComp);
begin
  with PDoubleComp(intG(p)+(i-indice1)*StepSize)^ do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function typeDataCpxD.getIm(i:integer):float;
begin
  result:= PDoubleComp(intG(p)+(i-indice1)*StepSize)^.y
end;

procedure typeDataCpxD.setIm(i:integer;x:float);
begin
  PDoubleComp(intG(p)+(i-indice1)*StepSize)^.y:=x;
end;

function typeDataCpxD.sumCpx(i1,i2:integer):TfloatComp;
var
  ys:TdoubleComp;
begin
  if (StepSize=16) then
  begin
    IPPStest;
    ippsSum_64fc(PdoubleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result.x:=ys.x;
    result.y:=ys.y;
  end
  else result:=inherited sumCpx(i1,i2);
end;

function typeDataCpxD.NormInf(i1,i2:integer):float;
var
  ys:double;
begin
  if (StepSize=16) then
  begin
    IPPStest;
    ippsNorm_inf_64fc64f(PdoubleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormInf(i1,i2);
end;

function typeDataCpxD.NormL1(i1,i2:integer):float;
var
  ys:double;
begin
  if (StepSize=16) then
  begin
    IPPStest;
    ippsNorm_L1_64fc64f(PdoubleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL1(i1,i2);
end;

function typeDataCpxD.NormL2(i1,i2:integer):float;
var
  ys:double;
begin
  if (StepSize=16) then
  begin
    IPPStest;
    ippsNorm_L2_64fc64f(PdoubleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result:=ys;
  end
  else result:=inherited NormL2(i1,i2);
end;

function typeDataCpxD.moyenneComp(i1,i2:integer):TfloatComp;
var
  ys:TdoubleComp;
begin
  if (StepSize=16) then
  begin
    IPPStest;
    ippsmean_64fc(PdoubleComp(getP(i1)),i2-i1+1,@ys);
    ippsEnd;
    result.x:=ys.x;
    result.y:=ys.y;
  end
  else result:=inherited moyenneComp(i1,i2);
end;



{*********************** Méthodes de typeDataCpxE *****************************}

constructor typeDataCpxE.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(TfloatComp));
end;

constructor typeDataCpxE.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*20,i1,iMin,iMax);
end;

function typeDataCpxE.EltSize: integer;
begin
  result:=20;
end;

function typeDataCpxE.getE(i:integer):float;
begin
  with PfloatComp(intG(p)+(i-indice1)*StepSize)^ do
  case modeCpx of
    0: result:= x;
    1: result:= y;
    2: result:=sqrt(sqr(x)+sqr(y));
    3: result:=arctan2(y,x);
  end;
end;

procedure typeDataCpxE.setE(i:integer;x:float);
begin
  PFloatComp(intG(p)+(i-indice1)*StepSize)^.x:=x;
end;

procedure typeDataCpxE.addI(i:integer;x:integer);
var
  p1:PfloatComp;
begin
  intG(p1):=intG(p)+(i-indice1)*StepSize;
  p1^.x:=p1^.x+x;
end;

function typeDataCpxE.getCpx(i:integer):TfloatComp;
begin
  with PFloatComp(intG(p)+(i-indice1)*StepSize)^ do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure typeDataCpxE.setCpx(i:integer;w:TfloatComp);
begin
  with PFloatComp(intG(p)+(i-indice1)*StepSize)^ do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function typeDataCpxE.getIm(i:integer):float;
begin
  result:= PFloatComp(intG(p)+(i-indice1)*StepSize)^.y
end;

procedure typeDataCpxE.setIm(i:integer;x:float);
begin
  PFloatComp(intG(p)+(i-indice1)*StepSize)^.y:=x;
end;

function typeDataCpxE.moyenneImag(i1,i2:integer):float;
var
  i:integer;
  m:float;
begin
  result:=0;
  if i1>i2 then exit;

  for i:=i1 to i2 do result:=result+getIm(i);
  result:=result/(i2-i1+1);
end;

procedure typeDataCpxE.raz;
var
  i:integer;
  z0:TfloatComp;
begin
  z0.x:=0;
  z0.y:=0;
  for i:=indicemin to indicemax do setCpx(i,z0);
end;

function typeDataCpxE.NormInf(i1,i2:integer):float;
var
  i:integer;
  w:float;
begin
  result:=0;
  for i:=i1 to i2 do
  begin
    w:=sqrt(sqr(getE(i)) + sqr(getIm(i)));
    if w>result then result:=w;
  end;
end;

function typeDataCpxE.NormL1(i1,i2:integer):float;
var
  i:integer;
begin
  result:=0;
  for i:=i1 to i2 do
    result:=result+sqrt(sqr(getE(i))+sqr(getIm(i)));
end;

function typeDataCpxE.NormL2(i1,i2:integer):float;
var
  i:integer;
begin
  result:=0;
  for i:=i1 to i2 do
    result:=result+sqr(getE(i))+sqr(getIm(i));
  result:=sqrt(result);
end;

function typeDataCpxE.StdDev(i1,i2:integer):float;
var
  ym:TfloatComp;
  i:integer;
begin
  ym:=moyenneComp(i1,i2);

  result:=0;
  for i:=i1 to i2 do
    result:=result+sqr(getE(i)-ym.x)+sqr(getIm(i)-ym.y);

  result:=sqrt(result/(i2-i1));
end;


{*********************** Méthodes de typeDataI *****************************}


constructor typeDataI.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(smallint));
end;

constructor typeDataI.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*2,i1,iMin,iMax);
end;

function typeDataI.EltSize: integer;
begin
  result:=2;
end;


function typeDataI.getI(i:integer):integer;
  begin
    getI:=Psmallint(intG(p)+(i-indice1)*StepSize)^;
  end;

function typeDataI.getE(i:integer):float;
  begin
    getE:=convY(getI(i));
  end;


procedure typeDataI.setI(i:integer;x:integer);
  begin
    Psmallint(intG(p)+(i-indice1)*StepSize)^:=x;
  end;

procedure typeDataI.setE(i:integer;x:float);
  begin
    setI(i,invConvY(x));
  end;

procedure typeDataI.addI(i:integer;x:integer);
  begin
    inc(Psmallint(intG(p)+(i-indice1)*StepSize)^,x);
  end;

procedure typeDataI.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    if StepSize=2 then move(tbI^,PtabEntier(p)^[i-indice1],n*2)
    else
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataI.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    if StepSize=2 then move(PtabEntier(p)^[i-indice1],tbI^,n*2)
    else
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;




procedure typeDataI.LimitesY(var y1,y2:float;i1,i2:integer);
  var
    max,min:integer;
    i:integer;
    j,v:integer;
    FlagMax:boolean;
  begin
    if (i1=0) and (i2=0) then
      begin
        i1:=indiceMin;
        i2:=indiceMax;
      end;

    if not tournant then
    begin
      if i1<indiceMin then i1:=indiceMin;
      if i2>indiceMax then i2:=indiceMax;
    end;

    max:=-32767;
    min:=32767;
    FlagMax:=(I2-I1>100000);

    for i:=i1 to i2 do
      begin
        j:=getI(i);
        if j<min then min:=j;
        if j>max then max:=j;
        if FlagMax and (i mod 10000=0) and TestEscape then
          begin
            y1:=convY(min);
            y2:=convY(max);
            exit;
          end;
      end;
    y1:=convY(min);
    y2:=convY(max);
  end;


function typeDataI.moyenne(i1,i2:integer):float;
  var
    i:integer;
    m:float;
  begin
    moyenne:=0;
    if i1>i2 then exit;

    m:=0;
    for i:=i1 to i2 do m:=m+getI(i);
    moyenne:=ay*m/(i2-i1+1) +by;
  end;

function typeDataI.StdDev(i1,i2:integer):float;
  var
    i:integer;
    m,sig:float;
  begin
    StdDev:=0;
    if i1>i2 then exit;

    m:=0;
    for i:=i1 to i2 do m:=m+getI(i);
    m:=m/(i2-i1+1);
    sig:=0;
    for i:=i1 to i2 do sig:=sig+sqr(getI(i)-m);
    StdDev:=ay*sqrt(sig/(i2-i1));
  end;

{*********************** Méthodes de typeDataW *****************************}

constructor typedataW.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(word));
end;

constructor typeDataW.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*2,i1,iMin,iMax);
end;

function typedataW.EltSize: integer;
begin
  result:=2;
end;


function typedataW.getI(i:integer):integer;
begin
  getI:=PWord(intG(p)+(i-indice1)*StepSize)^;
end;

procedure typedataW.setI(i:integer;x:integer);
begin
  PWord(intG(p)+(i-indice1)*StepSize)^:=x;
end;

function typeDataW.getE(i:integer):float;
begin
  getE:=convY(getI(i));
end;


procedure typeDataW.setE(i:integer;x:float);
begin
  setI(i,invConvY(x));
end;

procedure typeDataW.addI(i:integer;x:integer);
begin
  inc(PWord(intG(p)+(i-indice1)*StepSize)^,x);
end;



{*********************** Méthodes de typeDataL *****************************}

constructor typeDataL.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(longint));
end;

constructor typeDataL.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv*4,i1,iMin,iMax);
end;

function typeDataL.EltSize: integer;
begin
  result:=4;
end;

function typeDataL.getI(i:integer):integer;
begin
  getI:=Plongint(intG(p)+(i-indice1)*StepSize)^;
end;


function typeDataL.getE(i:integer):float;
begin
  getE:=convY(Plongint(intG(p)+(i-indice1)*StepSize)^);
end;


procedure typeDataL.setI(i:integer;x:integer);
begin
  Plongint(intG(p)+(i-indice1)*StepSize)^:=x;
end;

procedure typeDataL.setE(i:integer;x:float);
begin
  Plongint(intG(p)+(i-indice1)*StepSize)^:=invConvY(x);
end;

procedure typeDataL.addI(i:integer;x:integer);
begin
  inc(Plongint(intG(p)+(i-indice1)*StepSize)^,x);
end;


procedure typeDataL.setBlockI(i:integer;tbI:PtabEntier;n:integer);
var
  j:integer;
begin
  for j:=i to i+n-1 do setI(j,tbI^[j-i]);
end;

procedure typeDataL.getBlockI(i:integer;tbI:PtabEntier;n:integer);
var
  j:integer;
begin
  for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
end;



procedure typeDataL.LimitesY(var y1,y2:float;i1,i2:integer);
var
  max,min:integer;
  i:integer;
  v:integer;
  FlagMax:boolean;
begin
  if (i1=0) and (i2=0) then
    begin
      i1:=indiceMin;
      i2:=indiceMax;
    end
  else
  if not tournant then
  begin
    if i1<indiceMin then i1:=indiceMin;
    if i2>indiceMax then i2:=indiceMax;
  end;

  max:=-maxEntierLong;
  min:=maxEntierLong;
  FlagMax:=(I2-I1>100000);
  for i:=i1 to i2 do
    begin
      if getI(i)<min then min:=getI(i);
      if getI(i)>max then max:=getI(i);
      if FlagMax and (i mod 10000=0) and TestEscape then
        begin
          y1:=convY(min);
          y2:=convY(max);
          exit;
        end;
    end;
  y1:=convY(min);
  y2:=convY(max);
end;



{*********************** Méthodes de typeDataByte *****************************}

constructor typeDataByte.createTab(iMin,Imax:integer);
begin
  createTab0(imin,imax,sizeof(byte));
end;

constructor typeDataByte.create(p0:pointer;nbv,i1,iMin,Imax:integer);
begin
  createStep(p0,nbv,i1,iMin,iMax);
end;

function typeDataByte.EltSize: integer;
begin
  result:=1;
end;

function typeDataByte.getI(i:integer):integer;
begin
  getI:=Pbyte(intG(p)+(i-indice1)*StepSize)^;
end;

procedure typeDataByte.setI(i:integer;x:integer);
begin
  Pbyte(intG(p)+(i-indice1)*StepSize)^:=x;
end;

procedure typeDataByte.setE(i:integer;x:float);
begin
  Pbyte(intG(p)+(i-indice1)*StepSize)^:=invConvY(x);
end;

function typeDataByte.getE(i:integer):float;
begin
  result:=convY(Pbyte(intG(p)+(i-indice1)*StepSize)^);
end;




{*********************** Méthodes de typeDataFileI *************************}


function getFileSize(st:AnsiString):int64;
var
  f:TfileStream;
begin
  f:=nil;
  TRY
  f:=TfileStream.create(st,fmOpenRead);
  result:=f.size;
  f.Free;
  EXCEPT
  f.Free;
  result:=0;
  END;
end;

procedure typeDataFileI.openf(w:boolean);
begin
  if w
    then forg:=TfileStream.create(nomf,fmOpenReadWrite)
    else forg:=TfileStream.create(nomf,fmOpenRead);
end;


procedure typeDataFileI.closef;
begin
  forg.free;
  forg:=nil;
end;


procedure typeDataFileI.InitFile(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  var
    res:intG;
    nbDisp:int64;
  begin
    modeOpen0:=modeOp or assigned(fstream);
    modeOpen:=modeOp;
    ax:=1;
    bx:=0;
    ay:=1;
    by:=0;
    nomf:='';
    unix:=false;

    if not assigned(fstream) and not fileExists(st) then
      begin
        indiceMin:=0;
        indiceMax:=0;
        {messageCentral('Erreur typeDataFileI.InitFile '+st);}
        exit;
      end;

    nomf:=st;
    off:=offset;

    if assigned(fstream)
      then Nb:=(fStream().Size-off) div size
      else Nb:=(GetFileSize(st)-off) div size;
    if nb<0 then nb:=0;
    nbvoie:=nbv;
    Asauver:=false;

    block:=0;
//    if not assigned(fstream) then assign(f,nomf);
    modeOpen:=false;
    LoadBlock;
    modeOpen:=modeOp;


    nbDisp:=nb div nbvoie;
    if nbDisp*nbvoie+1<=nb then inc(nbDisp);

    if (Imax>=Imin) and (Imax-Imin<nbDisp) then
      begin
        indiceMin:=Imin;
        indiceMax:=Imax;
      end
    else
      begin
        indiceMin:=0;
        indiceMax:=nbDisp-1;
      end;

  end;

constructor typeDataFileI.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  begin
    size:=2;
    if (Imax>Imin) and (Imax-Imin+1<maxBufI) then
      begin
        maxBuf:=(Imax-Imin+1) div nbV *nbV;
        if maxBuf=0 then maxBuf:=nbV;
      end
    else maxBuf:=maxBufI div nbv*nbv;
    getmem(tb,maxBuf*size);

    initFile(st,offset,nbv,iMin,Imax,modeOp);
  end;

constructor typeDataFileI.create(f:TgetStream;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
begin
  fstream:=f;
  create('',offset,nbv,iMin,Imax,modeOp);
end;

function typeDataFileI.EltSize: integer;
begin
  result:=size;
end;


destructor typeDataFileI.destroy;
begin
  if (nomf<>'') or assigned(fstream) then
  begin
    saveBlock;
    if (nomf<>'') and modeOpen then Closef;
  end;

  freemem(tb);
end;

destructor typeDataFileI.doneErase;
  begin
    if maxBuf<>0 then freemem(tb,size*maxBuf);
    if nomf<>'' then
      begin
        if modeOpen then Closef;
        deleteFile(nomf);
      end;
  end;

{ swap provoque une erreur fatale interne à la ligne suivante }


procedure SwapBytes(var x;n:integer);
var
  tb:  array[0..1000] of byte;
  tbx: array[0..1000] of byte absolute x;
  i:integer;
begin
  for i:=0 to n-1 do
    tb[i]:=tbx[n-i-1];
  move(tb,tbx,n);
end;


procedure typeDataFileI.swapBuf;
  var
    k:integer;
  begin
    for k:=0 to maxBuf-1 do
      swapBytes(tb^.b[k*size],size);
  end;

procedure typeDataFileI.setUnix;
  begin
    if unix then exit;
    unix:=true;
    swapBuf;
  end;

procedure typeDataFileI.SaveBlock;
  var
    res:intG;
    i,n:integer;
    d:int64;
    buf:PtabOctet;

  begin
    if not Asauver then exit;

    if not assigned(fstream) and not modeOpen then openf(modeWrite);
    d:=off+block*maxBuf*size*nbvoie;

    if not assigned(fstream) then
    begin
      forg.Position:=d;
      n:=off+ int64(indiceMax-indicemin)*size*nbvoie+size -d;
      if n>maxBuf*size*nbvoie then n:=maxBuf*size*nbvoie;

      if nbvoie=1 then forg.Write(tb^,n)
      else
        begin
          getmem(buf,n);
          forg.Read(buf^,n);
          for i:=0 to n div (size*nbvoie)-1 do
            move(tb^.b[i*size],buf^[i*size*nbvoie],size);
          forg.Position:=d;
          forg.Write(buf^,n);
          freemem(buf);
        end;
      if not modeOpen then Closef;
      Asauver:=false;
    end
    else
    begin
      fstream().position:=d;
      n:=off+ int64(indiceMax-indicemin)*size*nbvoie+size -d;
      if n>maxBuf*size*nbvoie then n:=maxBuf*size*nbvoie;

      if nbvoie=1 then fstream().Write(tb^,n)
      else
        begin
          getmem(buf,n);
          fstream().Read(buf^,n);
          for i:=0 to n div (size*nbvoie)-1 do
            move(tb^.b[i*size],buf^[i*size*nbvoie],size);
          fstream().position:=d;
          fstream().Write(buf^,n);
          freemem(buf);
        end;
      Asauver:=false;
    end
  end;

procedure typeDataFileI.PositionneBlock(j:integer);
  var
    b:integer;
  begin
    b:=j div maxBuf;
    if b<>block then
      begin
        SaveBlock;
        block:=b;
        LoadBlock;
      end;
  end;

function typeDataFileI.getI(i:integer):integer;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getI:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getI:=tb^.i[j-block*maxBuf];
  end;


function typeDataFileI.getE(i:integer):float;
  begin
    getE:=convY(getI(i));
  end;

function typeDataFileI.getP(i:integer):pointer;
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then
    begin
      result:=nil;
      exit;
    end;

  j:=(i-indiceMin);
  positionneBlock(j);

  result:=@tb^.b[size*(j-block*maxBuf)];          { formule universelle }
end;



procedure typeDataFileI.setI(i:integer;x:integer);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.i[j-block*maxBuf]:=x;
    Asauver:=true;
  end;

procedure typeDataFileI.setE(i:integer;x:float);
  begin
    setI(i,invConvY(x));
  end;

procedure typeDataFileI.addI(i:integer;x:integer);
  var
    b:integer;
    res:intG;
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    inc(tb^.i[j-block*maxBuf],x);
    Asauver:=true;
  end;

procedure typeDataFileI.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
    res:intG;
  begin
    if (i+n-1>indicemax) then n:=indicemax-i+1;
    if n<=0 then exit;

    if nbvoie=1 then
      begin
        dec(i,indiceMin);
        saveBlock;      { SAuver d'abord tb si n‚cessaire }

        if not assigned(fstream) then
        begin
          if not modeOpen then openf(modeWrite);
          forg.Position:=off+size*i;
          forg.Write(tbI^,n*2);                 { Ne peut s'appliquer qu'à }
          if not modeOpen then closef;       { typeDataFileI }
        end
        else
        begin
          fstream().Position:=off+size*i;
          fstream().Write(tbI^,n*2);    { Ne peut s'appliquer qu'à typeDataFileI }
        end;

        block:=-1;
        { Comme on accède directement au fichier sans passer par tb, il faut
          imposer un LoadBlock au prochain accŠs normal }
      end
    else
      for j:=i to i+n-1 do setI(j,tbI^[j-i]);

  end;

procedure typeDataFileI.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
    res:intG;
  begin
    if nbvoie=1 then
      begin
        saveBlock;      { SAuver d'abord tb si n‚cessaire }
        dec(i,indiceMin);

        if not assigned(fstream) then
        begin
          if not modeOpen then openf(false);
          forg.Position:=off+sizeof(smallint)*i;
          forg.Read(tbI^,n*2);
          if not modeOpen then closef;
        end
        else
        begin
          fstream().position:=off+sizeof(smallint)*i;
          fstream().Read(tbI^,n*2);
        end;

        block:=-1;
        { Comme on accède directement au fichier sans passer par tb, il faut
          imposer un LoadBlock au prochain accès normal }
      end
    else
      for j:=i to i+n-1 do tbI^[j-i]:=getI(j);

    if unix then
      for j:=i to i+n-1 do tbI^[j-i]:=system.swap(tbI^[j-i]);
  end;





procedure typeDataFileI.LoadBlock;
var
  res:intG;
  buf:PtabOctet;
  i:integer;
begin
  if not assigned(fStream) then
  begin
    if (nomf='') then exit;

    if not modeOpen then openf(false);
    forg.Position:= off+block*maxBuf*size*nbvoie;

    if nbvoie=1 then forg.Read(tb^,maxBuf*size)
    else
      begin
        getmem(buf,maxBuf*size*nbvoie);
        forg.Read(buf^,maxBuf*size*nbvoie);
        for i:=0 to maxBuf-1 do
          move(buf^[i*size*nbvoie],tb^.b[i*size],size);
        freemem(buf);
      end;

    if unix then swapBuf;
    if not modeOpen then closef;
  end
  else
  begin
    fstream().Position:=off+block*maxBuf*size*nbvoie;

    if nbvoie=1 then fstream().read(tb^,maxBuf*size)
    else
      begin
        getmem(buf,maxBuf*size*nbvoie);
        fstream().Read(buf^,maxBuf*size*nbvoie);
        for i:=0 to maxBuf-1 do
          move(buf^[i*size*nbvoie],tb^.b[i*size],size);
        freemem(buf);
      end;

    if unix then swapBuf;
  end
end;


procedure typeDataFileI.open;
  begin
    if modeOpen or assigned(fstream) or (nomf='') then exit;
    openf(modeWrite);
    modeOpen:=true;
  end;

procedure typeDataFileI.close;
  begin
    if not modeOpen or assigned(fstream) then exit;
    if not modeOpen0 then
      begin
        saveBlock;
        closef;
        modeOpen:=false;
      end;
  end;

function typeDataFileI.getName:AnsiString;
  begin
    getName:=nomf;
  end;

function typeDataFileI.getPointer:pointer;
begin
  result:=nil;
end;


procedure typeDataFileI.InitKFile0(st:AnsiString;modeOp:boolean);
var
  res:integer;
begin
  modeOpen0:=modeOp;
  modeOpen:=modeOp;
  ax:=1;
  bx:=0;
  ay:=1;
  by:=0;
  nomf:='';
  unix:=false;

  if not assigned(fstream) and not fileExists(st) then
    begin
      indiceMin:=0;
      indiceMax:=0;
      exit;
    end;

  nomf:=st;
  Asauver:=false;

  block:=0;


  modeOpen:=false;
  LoadBlock;
  modeOpen:=modeOp;

end;

procedure typeDataFileI.InitSegFile(st:AnsiString;segs1:TKsegArray;modeOp:boolean;
                                    SampSize:integer;
                                    var segs:TKsegArray;var Nsegs:integer );
var
  i:integer;
  sampleTot:integer;
begin
  Nsegs:=high(segs1)+1;
  setLength(segs,Nsegs);

  for i:=0 to Nsegs-1 do
  begin
    segs[i].off:=segs1[i].off;
    segs[i].size :=segs1[i].size  div SampSize;
  end;

  size:=SampSize;

  maxBuf:=maxBufDF div SampSize;

  {Calculer le nombre total d'échantillons}
  SampleTot:=0;
  for i:=0 to Nsegs-1 do SampleTot:=SampleTot+segs[i].size;

  IndiceMin:=1;
  IndiceMax:=sampleTot;

  if SampleTot<maxBuf then
      maxBuf:=SampleTot;

  getmem(tb,maxBuf*size);

  initKFile0(st,modeOp); {InitKfile transferré dans typeDataI}

end;

procedure typeDataFileI.loadSegBlock(var segs:TKsegArray;var Nsegs:integer );
var
  res:intG;
  i,k:integer;
  sz,size0,off0:int64;
  modeClose:boolean;

begin
  { Les tailles dans segs sont exprimées en nombres d'échantillons }

  if not assigned(fstream) then
  begin
    if nomf='' then exit;
    if not modeOpen then openf(modeWrite);
  end;

  modeClose:=not modeOpen and not assigned(fstream);

  {Chercher le numéro du segment contenant le premier point}
  i:=0;
  sz:=segs[0].size;
  while (i<Nsegs-1) and (sz<Block*maxBuf) do
  begin
    inc(i);
    sz:=sz+segs[i].size;
  end;
  if sz<Block*maxBuf then
  begin
    if modeClose then closef;
    exit;
  end;
  {size0 est le nb de points disponibles dans le segment i}
  {off0 est l'offset correspondant dans le fichier}

  size0:=sz-Block*maxBuf;
  off0:=segs[i].off+ (segs[i].size-size0)*size;


  {Charger buf en changeant de segment à chaque fois que c'est nécessaire}
  sz:=0;
  while (sz<maxBuf) and (i<Nsegs) do
  begin
    if size0>maxBuf-sz then size0:=maxBuf-sz;
    if not assigned(fstream) then
    begin
      forg.Position:=off0;
      forg.Read(tb^.b[sz*size],size0*size);
    end
    else
    if fstream<>nil then
    try
      fstream().position:=off0;
      fstream().Read(tb^.b[sz*size],size0*size);
    except
    end;


    sz:=sz+size0;
    inc(i);
    if i<Nsegs then
    begin
      size0:=segs[i].size;
      off0:=segs[i].off;
    end;
  end;

  if modeClose then closef;

end;



{*********************** Méthodes de typeDataFileW *************************}

constructor typeDataFileW.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
begin
  inherited;
end;

function typeDataFileW.getI(i:integer):integer;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getI:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getI:=tb^.w[j-block*maxBuf];
  end;


procedure typeDataFileW.setI(i:integer;x:integer);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.w[j-block*maxBuf]:=x;
    Asauver:=true;
  end;


{*********************** Méthodes de typeDataFileL *************************}

constructor typeDataFileL.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  begin
    size:=4;
    if Imax-Imin+1<maxBufL then
      begin
        maxBuf:=(Imax-Imin+1) div nbV *nbV;
        if maxBuf=0 then maxBuf:=nbV;
      end
    else maxBuf:=maxBufL div nbv*nbv;
    getmem(tb,maxBuf*size);

    initFile(st,offset,nbv,iMin,Imax,modeOp);
  end;

function typeDataFileL.getI(i:integer):integer;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getI:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getI:=tb^.l[j-block*maxBuf];
  end;


procedure typeDataFileL.setI(i:integer;x:integer);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.l[j-block*maxBuf]:=x;
    Asauver:=true;
  end;

procedure typeDataFileL.addI(i:integer;x:integer);
  var
    b:integer;
    res:intG;
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    inc(tb^.l[j-block*maxBuf],x);
    Asauver:=true;
  end;


procedure typeDataFileL.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataFileL.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;




{*********************** Méthodes de typeDataFileB *************************}

constructor typeDataFileB.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  begin
    size:=1;
    if Imax-Imin+1<maxBufDF then
      begin
        maxBuf:=(Imax-Imin+1) div nbV *nbV;
        if maxBuf=0 then maxBuf:=nbV;
      end
    else maxBuf:=maxBufL div nbv*nbv;
    getmem(tb,maxBuf*size);

    initFile(st,offset,nbv,iMin,Imax,modeOp);
  end;

function typeDataFileB.getI(i:integer):integer;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getI:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getI:=tb^.b[j-block*maxBuf];
  end;


procedure typeDataFileB.setI(i:integer;x:integer);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.b[j-block*maxBuf]:=x;
    Asauver:=true;
  end;

procedure typeDataFileB.addI(i:integer;x:integer);
  var
    b:integer;
    res:intG;
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    inc(tb^.b[j-block*maxBuf],x);
    Asauver:=true;
  end;


procedure typeDataFileB.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataFileB.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;


{*********************** Méthodes de typeDataFileS *************************}

constructor typeDataFileS.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  begin
    size:=4;
    if Imax-Imin+1<maxBufS then
      begin
        maxBuf:=(Imax-Imin+1) div nbV *nbV;
        if maxBuf=0 then maxBuf:=nbV;
      end
    else maxBuf:=maxBufS div nbv*nbv;
    getmem(tb,maxBuf*size);

    initFile(st,offset,nbv,iMin,Imax,modeOp);
  end;

constructor typeDataFileS.create(f:TgetStream;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
begin
  fstream:=f;
  create('',offset,nbv,iMin,Imax,modeOp);
end;

function typeDataFileS.getE(i:longint):float;
  var
    j:longint;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getE:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getE:=tb^.s[j-block*maxBuf];
  end;

function typeDataFileS.getI(i:longint):longint;
  begin
    getI:=roundL(getE(i));
  end;

procedure typeDataFileS.setE(i:longint;x:float);
  var
    j:longint;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.s[j-block*maxBuf]:=x;
    Asauver:=true;
  end;

procedure typeDataFileS.setI(i:longint;x:longint);
  begin
    setE(i,x);
  end;

procedure typeDataFileS.addI(i:longint;x:longint);
  var
    j:longint;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indicemin);
    positionneBlock(j);

    tb^.s[j-block*maxBuf]:=tb^.s[j-block*maxBuf]+x;
    Asauver:=true;
  end;


procedure typeDataFileS.setBlockS(i:integer;tbI:PtabSingle;n:integer);
  var
    j:integer;
    res:intG;
  begin
    if nbvoie=1 then
      begin
        dec(i,indiceMin);
        saveBlock;      { SAuver d'abord tb si n‚cessaire }

        if not modeOpen then openf(modeWrite);
        forg.Position:= off+size*i;
        forg.Write(tbI^,n*4);                    { Ne peut s'appliquer qu'à }
        if not modeOpen then closef;          { typeDataFileS }

        block:=-1;
        { Comme on accède directement au fichier sans passer par tb, il faut
          imposer un LoadBlock au prochain accès normal }
      end
    else
      for j:=i to i+n-1 do setE(j,tbI^[j-i]);
  end;

procedure typeDataFileS.getBlockS(i:integer;tbI:PtabSingle;n:integer);
  var
    j:integer;
    res:intG;
  begin
    if nbvoie=1 then
      begin
        saveBlock;      { SAuver d'abord tb si n‚cessaire }
        dec(i,indiceMin);
        if not modeOpen then openf(false);
        forg.Position:= off+sizeof(single)*i;
        forg.Read(tbI^,n*4);
        if not modeOpen then closef;

        block:=-1;
        { Comme on accède directement au fichier sans passer par tb, il faut
          imposer un LoadBlock au prochain accès normal }
      end
    else
      for j:=i to i+n-1 do tbI^[j-i]:=getE(j);
  end;


{*********************** Méthodes de typeDataFileD *************************}

constructor typeDataFileD.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  begin
    size:=8;
    if Imax-Imin+1<maxBufD then
      begin
        maxBuf:=(Imax-Imin+1) div nbV *nbV;
        if maxBuf=0 then maxBuf:=nbV;
      end
    else maxBuf:=maxBufD div nbv*nbv;
    getmem(tb,maxBuf*size);

    initFile(st,offset,nbv,iMin,Imax,modeOp);
  end;



function typeDataFileD.getE(i:integer):float;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getE:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getE:=tb^.d[j-block*maxBuf];
  end;


procedure typeDataFileD.setE(i:integer;x:float);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.d[j-block*maxBuf]:=x;
    Asauver:=true;
  end;


procedure typeDataFileD.addI(i:integer;x:integer);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indicemin);
    positionneBlock(j);

    tb^.d[j-block*maxBuf]:=tb^.d[j-block*maxBuf]+x;
    Asauver:=true;
  end;



{*********************** M‚thodes de typeDataFileE *************************}

constructor typeDataFileE.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean);
  begin
    size:=10;
    if Imax-Imin+1<maxBufE then
      begin
        maxBuf:=(Imax-Imin+1) div nbV *nbV;
        if maxBuf=0 then maxBuf:=nbV;
      end
    else maxBuf:=maxBufE div nbv*nbv;
    getmem(tb,maxBuf*size);

    initFile(st,offset,nbv,iMin,Imax,modeOp);
  end;



function typeDataFileE.getE(i:integer):float;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getE:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getE:=tb^.f[j-block*maxBuf];
  end;


procedure typeDataFileE.setE(i:integer;x:float);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indiceMin);
    positionneBlock(j);

    tb^.f[j-block*maxBuf]:=x;
    Asauver:=true;
  end;


procedure typeDataFileE.addI(i:integer;x:integer);
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then exit;

    j:=(i-indicemin);
    positionneBlock(j);

    tb^.f[j-block*maxBuf]:=tb^.f[j-block*maxBuf]+x;
    Asauver:=true;
  end;


{*********************** Méthodes de typeDataEV ****************************}

constructor typeDataEV.create(p0:pointer;
                 voie:integer;
                 i1,iMin,Imax,modulo0:integer);
  begin
    setMask(voie);

    inherited create(imin,imax);
    p:=p0;
    indice1:=i1;

    modulo:=modulo0;
    if modulo=0 then modulo:=maxEntierLong;

    stat(statEV);
  end;

function typeDataEV.EltSize: integer;
begin
  result:=6;
end;

function typeDataEV.getX(i:integer):word;
  begin
    with PtabSP(p)^[(i-indice1) mod modulo] do getX:=x;
  end;

function typeDataEV.getD(i:integer):integer;
  begin
    with PtabSP(p)^[(i-indice1) mod modulo] do getD:=date;
  end;

procedure typeDataEV.getXD(i:integer;var code:word;var d:integer);
  begin
    with PtabSP(p)^[(i-indice1) mod modulo] do
    begin
      code:=x;
      d:=date;
    end;
  end;



function typeDataEV.getL(i:integer):integer;
  begin
     with PtabSP(p)^[(i-indice1) mod modulo] do
      if x and masque<>0
        then getL:=date
        else getL:=-1;
  end;

function typeDataEV.getP(i:integer):pointer;
begin
  result:=@PtabSP(p)^[(i-indice1) mod modulo];
end;


function typeDataEV.getE(i:integer):float;
  begin
    getE:=convX(getL(i));
  end;

function typeDataEV.getEvt(i:integer):PtypeSP;
  begin
    getEvt:=@PtabSP(p)^[(i-indice1) mod modulo];
  end;

procedure typeDataEV.setEvX(d:integer;xu:word);
  begin
    if PtabSP(p)^[(indicemax-indice1) mod modulo].date<d then inc(indicemax);
    with PtabSP(p)^[(indicemax-indice1) mod modulo] do
    begin
      date:=d;
      x:=xu;
    end;
  end;

procedure typeDataEV.setEvL(d:integer);
  begin
    if PtabSP(p)^[(indicemax-indice1) mod modulo].date<d then
      begin
        inc(indicemax);
        with PtabSP(p)^[(indicemax-indice1) mod modulo] do
        begin
          date:=d;
          x:=masque;
        end;
      end
    else
    if PtabSP(p)^[(indicemax-indice1) mod modulo].date=d then
      with PtabSP(p)^[(indicemax-indice1) mod modulo] do x:=x or masque;
  end;

procedure typeDataEV.setEvE(d:float);
  begin
    setEvL(invConvX(d));
  end;

destructor typeDataEV.destroy;
  begin
    {affdebug('destroy dataEv');}
  end;

procedure typeDataEV.LoadBlock;
  begin
  end;

procedure typeDataEV.Open;
  begin
  end;

procedure typeDataEV.Close;
  begin
  end;

function typeDataEV.getFirst(date0:float):integer;
  var
    min,max,k,d:integer;
    dt:integer;
  begin
    dt:=invconvX(date0);
    min:=indiceMin;
    max:=indiceMax;
    repeat
      k:=(max+min) div 2;
      d:=getD(k);
      {messageCentral('k='+Istr(k)+'   d='+Istr(d)+'  dt='+Istr(dt));}
      if d<dt then min:=k
      else
      if d>dt then max:=k;
    until (max-min<=1) or (dt=d);
    if dt=d then getFirst:=k
            else getFirst:=min;
  end;


procedure typeDataEV.setMask(num:integer);
  begin
    voieEv:=num;
    if num<0
      then masque:=$FFFF
      else masque:=word(1) shl num;
  end;

procedure typeDataEV.stat(var s:typeStatEV);
  var
    i:integer;
    j:integer;
    x:word;
    d:integer;
  begin
    fillchar(s,sizeof(s),0);
    for i:=indiceMin to indiceMax do
      begin
        getXD(i,x,d);
        for j:=0 to 15 do
          if x and (word(1) shl j)<>0 then inc(s.n[j]);
        if d>s.datemax then s.datemax:=d;
        if x=0 then inc(s.nb0);
      end;
  end;

procedure typeDataEV.getTabs(var s:array of PtabLong);
var
  i,j,d:integer;
  x:word;
  nb:array[0..15] of integer;
begin
  fillchar(nb,sizeof(nb),0);
  fillchar(s,sizeof(s),0);

  for j:=0 to 15 do
    if statEv.n[j]>0 then
      s[j]:=allocmem(statEv.n[j]*sizeof(integer));

  for i:=indiceMin to indiceMax do
    begin
      getXD(i,x,d);
      for j:=0 to 15 do
        if x and (word(1) shl j)<>0 then
          begin
            s[j]^[nb[j]]:=d;
            inc(nb[j]);
          end;
    end;
end;

function typeDataEV.getTab(v:integer):PtabLong;
var
  i,j,d:integer;
  x,mk:word;
  nb:integer;
begin
  nb:=0;
  if statEv.n[v]>0 then
    begin
      result:=allocmem(statEv.n[v]*sizeof(integer));

      mk:=word(1) shl v;
      for i:=indiceMin to indiceMax do
        begin
          getXD(i,x,d);
          if x and mk<>0 then
            begin
              result^[nb]:=d;
              inc(nb);
            end;
        end;
    end
  else result:=nil;
end;


procedure typeDataEV.correL(pCorre:pointer;
                           Nmax:integer;
                           dat2:typedataEV;
                           Lclasse:float);
  type
    typeTabAuto=array[0..5000] of integer;
    PtabAuto=^typeTabAuto;
  var
    auto:PTabAuto ABSOLUTE pCorre;
    i,j,j1:integer;
    k:integer;
    diff,largeur:integer;
  begin
    if statEV.n[voieEv]=0 then exit;
    with dat2 do
      if statEV.n[voieEv]=0 then exit;

    largeur:=roundL(Lclasse/ax);
    diff:=Nmax*largeur;
    j1:=dat2.indicemin;
    for i:=indiceMin to indiceMax do
      if getL(i)>0 then
        begin
          j:=j1;
          while (j<=dat2.indicemax) and (getL(i)-dat2.getL(j)>Diff)
          do inc(j);
          j1:=j;
          k:=(dat2.getD(j)-getL(i)+Diff) div largeur -Nmax;
          while(j<=dat2.indicemax) and (abs(k)<=Nmax) do
            begin
              if dat2.getL(j)>0 then inc(auto^[k]);
              inc(j);
              k:=(dat2.getD(j)-getL(i)+diff) div largeur -Nmax;
            end;
        end;
  end;

procedure typeDataEV.psth(pTab:typeDataB;Lclasse:float);
  var
    i,k:integer;
    vi:float;
    datemax:float;
  begin
    i:=getFirst(ptab.bx);
    dateMax:=ptab.convx(ptab.indicemax+1);
    vi:=getE(i);
    while (i<=indiceMax) and (vi<=datemax) do
    begin
      if vi>=0 then
          begin
            k:=trunc((vi-ptab.bx)/Lclasse);
            if (k>=ptab.indiceMin) and (k<=ptab.indiceMax)
              then ptab.addI(k,1);
          end;
      inc(i);
      vi:=getE(i);
    end;
  end;


procedure typeDataEV.correE(pCorre:typeDataE;
                           dat2:typedataEV;
                           Lclasse:float;
                           xd1,xd2:float;
                           var count:integer);
  var
    i,j,j1:integer;
    k,min,max:integer;
    x,diff,vi,vj:float;
    st:AnsiString;
  begin
    if statEV.n[voieEv]=0 then exit;

    with dat2 do
      if statEV.n[voieEv]=0 then exit;

    min:=pCorre.indiceMin;
    max:=pCorre.indiceMax;
    diff:=pCorre.indiceMin*Lclasse;

    j1:=dat2.indicemin;


    for i:={indiceMin}getFirst(xd1) to indiceMax do
      if getL(i)>0 then
      begin
        j:=j1;
        vi:=getE(i);
        if (vi>=xd1) and (vi<=xd2) then
          begin
            inc(count);
            while (j<=dat2.indicemax) and
                  (dat2.convx(dat2.getD(j))-vi<Diff) do inc(j);
            j1:=j;
            x:=(dat2.convx(dat2.getD(j))-vi)/Lclasse;
            while (j<=dat2.indicemax) and (x<Max+1) do
              begin
                k:=truncL(abs(x));
                vj:=dat2.getE(j);
                if (vj>0) and (vj>=xd1) and (vj<=xd2) then
                  begin
                    if (x>=0) and (k<=max) then
                      pCorre.addI(k,1);
                    if (x<=0) and (Min<=-k-1) then
                      pCorre.addI(-1-k,1);
                  end;
                inc(j);
                x:=(dat2.convx(dat2.getD(j))-vi)/Lclasse;
              end;
          end
        else
        if vi>xd2 then exit;
      end;
  end;


procedure typeDataEV.jpX(pCorre:pointer;   {array[0..NbclasseX,-Nmax..Nmax-1]}
                         NbClasseX:integer;
                         LclasseX:float;
                         Nmax:integer;
                         LclasseY:float;
                         dat2:typedataEV);
  var
    pp:PtabEntier ABSOLUTE pCorre;
    i,j,j1:integer;
    k,q:integer;
    dd,diff,vi:float;
    st:AnsiString;
  begin
    if statEV.n[voieEv]=0 then exit;

    with dat2 do
      if statEV.n[voieEv]=0 then exit;

    diff:=Nmax*LclasseY;
    j1:=dat2.indicemin;
    for i:=indiceMin to indiceMax do
      if getL(i)>0 then
      begin
        j:=j1;
        vi:=getE(i);
        q:=truncL(vi/LclasseX);
        if q<nbClasseX then
          begin
            while (j<=dat2.indicemax) and
                  (vi-dat2.convx(dat2.getD(j))>Diff) do inc(j);
            j1:=j;
            dd:=(dat2.convx(dat2.getD(j))-vi)/LclasseY;
            while(j<=dat2.indicemax) and (dd<Nmax+1) do
              begin
                k:=truncL(abs(dd));
                if dat2.getL(j)>0 then
                  begin

                    if (dd>=0) and (k<Nmax) then
                      inc(pp^[k+Nmax+2*Nmax*q]);
                    if (dd<=0) and (k<Nmax) then
                      inc(pp^[-1-k+Nmax+2*Nmax*q]);
                  end;
                inc(j);
                dd:=(dat2.convx(dat2.getD(j))-vi)/LclasseY;
              end;
          end;
      end;
  end;


procedure typeDataEv.LimitesX(var x1,x2:float);
  begin
    x1:=0;
    x2:=convx(statEv.datemax);
  end;

procedure typeDataEv.LimitesY(var y1,y2:float;i1,i2:integer);
  begin
    y1:=-1;
    y2:=1;
  end;

{*********************** Méthodes de typeDataFileEV ***************************}


procedure typeDataFileEV.openf(w:boolean);
begin
  if w
    then f:=TfileStream.create(nomf,fmOpenReadWrite)
    else f:=TfileStream.create(nomf,fmOpenRead);
end;


procedure typeDataFileEV.closef;
begin
  f.free;
  f:=nil;
end;

constructor typeDataFileEV.create(st:AnsiString;offset: int64;voie:integer;
                 iMin,Imax:integer;modeOp:boolean);
  var
    res:intG;
    nb:integer;
  begin
    p:=nil;
    Asauver:=false;
    indice1:=0; {inutile}
    setMask(voie);
    modeOpen:=modeOp;
    ax:=1;
    bx:=0;
    nomf:='';
    if not fileExists(st) then
      begin
        indiceMin:=0;
        indiceMax:=0;
        exit;
      end;

    nomf:=st;
    off:=offset;
    Nb:=(GetFileSize(st)-off) div sizeof(typeSP);
    if nb<0 then nb:=0;

    openf(false);

    f.Position:=off;
    f.Read(tb,sizeof(tb));
    if not modeOpen then closef;
    block:=0;

    if (Imin>=0) and (Imin<nb)
      then indiceMin:=Imin
      else indiceMin:=0;

    if (Imax>=Imin-1) and (Imax<nb) and (Imax>=-1)
      then indiceMax:=Imax
      else indiceMax:=nb-1;

    {messageCentral('Imin='+Istr(indiceMin)+'  Imax='+Istr(indiceMax));}


    stat(statEV);

    {affdebug('initDataEv '+Istr(intG(@self)));}
  end;

function typeDataFileEV.getX(i:integer):word;
  var
    b:integer;
  begin
    b:=i div maxSP;
    if b<>block then
      begin
        block:=b;
        LoadBlock;
      end;

    with tb[i-block*maxSP] do getX:=x;
  end;

function typeDataFileEV.getD(i:integer):integer;
  var
    b:integer;
  begin
    b:=i div maxSP;
    if b<>block then
      begin
        block:=b;
        LoadBlock;
      end;

    with tb[i-block*maxSP] do getD:=date;
  end;

procedure typeDataFileEV.getXD(i:integer;var code:word;var d:integer);
  var
    b:integer;
  begin
    b:=i div maxSP;
    if b<>block then
      begin
        block:=b;
        LoadBlock;
      end;

    with tb[i-block*maxSP] do
    begin
      code:=x;
      d:=date;
    end;
  end;

function typeDataFileEV.getL(i:integer):integer;
  var
    b:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getL:=-1;
        exit;
      end;

    b:=i div maxSP;
    if b<>block then
      begin
        block:=b;
        LoadBlock;
      end;

    with tb[i-block*maxSP] do
      if x and masque<>0
        then getL:=date
        else getL:=-1;
  end;

function typeDataFileEV.getE(i:integer):float;
  begin
    getE:=convX(getL(i));
  end;

function typeDataFileEv.getEvt(i:integer):PtypeSP;
  var
    b:integer;
  begin
    b:=i div maxSP;
    if b<>block then
      begin
        block:=b;
        LoadBlock;
      end;

    getEvt:=@tb[i-block*maxSP];
  end;

function typeDataFileEv.getP(i:integer):pointer;
begin
  result:=getEvt(i);
end;

destructor typeDataFileEV.destroy;
  begin
    {affdebug('doneDataEv '+Istr(intG(@self)));}
    if nomf='' then exit;
    saveBlock;
    if modeOpen then closef;
  end;

procedure typeDataFileEV.LoadBlock;
  var
    res:intG;
  begin
    if not modeOpen then openf(false);
    f.Position:=off+block*maxSP*sizeof(typeSP);
    f.Read(tb,sizeof(tb) );
    if not modeOpen then closef;
  end;


procedure typeDataFileEV.open;
  begin
    if modeOpen then exit;
    openf(modeWrite);
    modeOpen:=true;
  end;

procedure typeDataFileEV.close;
  begin
    if not modeOpen then exit;
    if not modeOpen0 then
      begin
        closef;
        modeOpen:=false;
      end;
  end;

procedure typeDataFileEV.SaveBlock;
  var
    res:intG;
    d,n:int64;
  begin
    if not Asauver then exit;

    if not modeOpen then openf(modeWrite);
    d:=off+int64(block)*maxSP*sizeof(typeSP);
    f.Position:= d;
    n:=off+indiceMax*sizeof(typeSP)-d+sizeof(typeSP);
    {if n<=0 then messageCentral('n='+Istr(n));}
    if n>sizeof(tb) then n:=sizeof(tb);
    f.Write(tb,n);
    if not modeOpen then closef;
    Asauver:=false;
  end;

procedure typeDataFileEV.setEvX(d:integer;xu:word);
  var
    b,j,i:integer;
  begin
    b:=indicemax div maxSP;
    if b<>block then
      begin
        saveBlock;
        block:=b;
        LoadBlock;
      end;

    j:=indicemax-block*maxSP;

    if (indicemax=-1) or (tb[j].date<d) then
      begin
        inc(indicemax);
        b:=indicemax div maxSP;
        if b<>block then
          begin
            saveBlock;
            block:=b;
            LoadBlock;
          end;
        with tb[indicemax-block*maxSP] do
        begin
          date:=d;
          x:=xu;
        end;
      end
    else
    if tb[j].date=d then
      with tb[j] do x:=xu
    else
    if d>0 then
      begin
        i:=indiceMin;
        while (i<indicemax) and (d>getD(i)) do inc(i);
        if d=getD(i) then
          begin
            j:=i-block*maxSP;
            tb[j].x:=xu;
          end;
      end;
    Asauver:=true;
  end;

procedure typeDataFileEV.setEvL(d:integer);
  var
    b,j:integer;
  begin
    b:=indicemax div maxSP;
    if b<>block then
      begin
        saveBlock;
        block:=b;
        LoadBlock;
      end;

    j:=indicemax-block*maxSP;
    if tb[j].date=d then
      with tb[j] do x:=x or masque
    else
    if tb[j].date<d then
      begin
        inc(indicemax);
        b:=indicemax div maxSP;
        if b<>block then
          begin
            saveBlock;
            block:=b;
            LoadBlock;
          end;
        with tb[indicemax-block*maxSP] do
        begin
          date:=d;
          x:=masque;
        end;
      end;
    Asauver:=true;

  end;

function typeDataFileEV.getName:AnsiString;
  begin
    getName:=nomf;
  end;

function typeDataFileEv.getPointer:pointer;
begin
  result:=nil;
end;


{*********************** M‚thodes de typeDataEVm *****************************}


constructor typeDataEVm.create(p0:pointer;
                               voie:integer;  { voie de 0 … 15 }
                               nbEv:integer);
  begin
    inherited create(p0,voie,0,0,nbEv-1,0);
  end;


function typeDataEVm.getX(i:integer):word;
  begin
    getX:=PtabtabSP(p)^[i div maxTabSp]^[i mod maxTabSp].x;
  end;

function typeDataEVm.getD(i:integer):integer;
  begin
    getD:=PtabtabSP(p)^[i div maxTabSp]^[i mod maxTabSp].date;
  end;

procedure typeDataEVm.getXD(i:integer;var code:word;var d:integer);
  begin
    with PtabtabSP(p)^[i div maxTabSp]^[i mod maxTabSp] do
    begin
      code:=x;
      d:=date;
    end;
  end;



function typeDataEVm.getL(i:integer):integer;
  begin
    with PtabtabSP(p)^[i div maxTabSp]^[i mod maxTabSp] do
    if x and masque<>0
      then getL:=date
      else getL:=-1;
  end;



procedure typeDataEVm.setEvX(d:integer;xu:word);
  begin
  end;

procedure typeDataEVm.setEvL(d:integer);
  begin
  end;


destructor typeDataEVm.destroy;
  begin
  end;

function typeDataEVm.getEvt(i:integer):PtypeSP;
  begin
    getEvt:=@PtabtabSP(p)^[i div maxTabSp]^[i mod maxTabSp];
  end;

function typeDataEVm.getP(i:integer):pointer;
begin
  result:=getEvt(i);
end;

{*********************** M‚thodes de typeDataVectorEv *************************}




constructor typeDataVectorEV.create(dataEV1:typedataEV;voie1:integer);
begin
  inherited create(0,dataEV1.statEV.n[voie1]-1);

  dataEV:=dataEv1;
  voie:=voie1;
  ax:=dataEv.ax;

  IdebBloc:=0;
  IfinBloc:=0;
  kdeb:=0;
  block:=0;
  LoadBlock;
end;


function typeDataVectorEV.EltSize: integer;
begin
  result:=6;
end;


procedure typeDataVectorEV.LoadBlock;
var
  i,k,i1,i2,k1,k2:integer;
  x:word;
  date:integer;
  mask:word;
begin
  mask:=word(1) shl voie;

  k1:=block*maxspV;
  k2:=(block+1)*maxSpV-1;
  if k2>indicemax then k2:=indicemax;

  if k1>kdeb then
    begin
      i:=IfinBloc;
      k:=kdeb+maxSpv-1;
      while (k<k1) do
      begin
        inc(i);
        dataEV.getXD(i,x,date);
        if x and mask<>0 then inc(k);
      end;
      i1:=i;
      repeat
        if x and mask<>0 then
          begin
            tb[k-k1]:=date;
            inc(k);
          end;
        inc(i);
        dataEV.getXD(i,x,date);
      until k>k2;
      i2:=i-1;
    end
  else
  if k1<kdeb then
    begin
      i:=IdebBloc;
      k:=kdeb;
      while (k>k2) do
      begin
        dec(i);
        dataEV.getXD(i,x,date);
        if x and mask<>0 then dec(k);
      end;
      i2:=i;
      repeat
        if x and mask<>0 then
          begin
            tb[k-k1]:=date;
            dec(k);
          end;
        dec(i);
        dataEV.getXD(i,x,date);
      until k<k1;
      i1:=i+1;
    end
  else
    begin
      k:=k1;
      i:=IdebBloc;
      while (k<=k2) do
      begin
        dataEV.getXD(i,x,date);
        if x and mask<>0 then
          begin
            tb[k-k1]:=date;
            inc(k);
          end;
        inc(i);
      end;

      i1:=IdebBloc;
      i2:=i-1;
    end;

  IdebBloc:=i1;
  IfinBloc:=i2;
  kdeb:=k1;
end;


function typeDataVectorEV.getL(i:integer):integer;
var
  b:integer;
begin
  b:=i div maxSPV;
  if b<>block then
    begin
      block:=b;
      LoadBlock;
    end;

  getL:=tb[i-block*maxSPV];
end;

function typeDataVectorEV.getE(i:integer):float;
begin
  getE:=convx(getL(i));
end;

function typeDataVectorEV.getP(i:integer):pointer;
var
  b:integer;
begin
  b:=i div maxSPV;
  if b<>block then
    begin
      block:=b;
      LoadBlock;
    end;

  result:=@tb[i-block*maxSPV];
end;


procedure typeDataVectorEV.modifyLimits(iMin,iMax:integer);
begin
  inherited modifyLimits(iMin,iMax);
  LoadBlock;

end;

{*********************** Méthodes de typeDataIdigi ****************************}

constructor typeDataIdigi.create(p0:pointer;nbv,i1,iMin,Imax:integer;shift:integer);
  begin
    createStep(p0,nbv*2,i1,iMin,iMax,shift);
    Vshift:=shift;
  end;

constructor typeDataIdigi.createStep(p0:pointer;step,i1,iMin,Imax:integer;shift:integer);
begin
  inherited createStep(p0,step,i1,iMin,Imax);
  Vshift:=shift;
end;

function typeDataIdigi.EltSize: integer;
begin
  result:=2;
end;

destructor typeDataIdigi.destroy;
  begin
  end;

function typeDataIdigi.getI(i:integer):integer;
var
  x:smallint;
  w:byte;
begin
  x:=Psmallint(intG(p)+(i-indice1)*StepSize)^;
  {$IFNDEF WIN64}
  w:=Vshift;
  asm
    mov ax,x
    mov cl,w
    sar ax,cl
    mov x,ax
  end;
  result:=x;
  {$ELSE}
  result:= sar(x,Vshift);

  {$ENDIF}

end;
(*

Cette belle méthode en assembleur est moins rapide que celle qui est écrite
en Pascal (ci-dessus)! Mais elle marche.

function typeDataIdigi.getI(i:integer):integer;assembler;
  asm
      push esi
      push edi
      push ebx

      mov  edi,self
      mov  esi,[edi+dp+2]
      mov  eax, i
      cmp  eax,[edi+DindiceMin]
      jl   @@1
      cmp  eax,[edi+DindiceMax]
      jg   @@1
      sub  eax,[edi+Dindice1+2]    { i-indice1 }
      mov  ebx,0
      mov  bx,[edi+DnbVoie+2]
      Imul ebx                     { *nbVoie }
      add  eax,eax                  { *2 }
      add  esi,eax
      mov  eax,0
      mov  ax,[esi]

      mov  cl,4
      sar  ax,cl
      cwde
  @@1:
      pop  ebx
      pop  edi
      pop  esi
  end;
*)


function typeDataIdigi.getE(i:integer):float;
  begin
    getE:=convY(getI(i));
  end;


procedure typeDataIdigi.setI(i:integer;x:integer);
  begin
    Psmallint(intG(p)+(i-indice1)*StepSize)^:=x shl Vshift;
  end;


procedure typeDataIdigi.setE(i:integer;x:float);
  begin
    Psmallint(intG(p)+(i-indice1)*StepSize)^:=invConvY(x) shl Vshift ;
  end;

procedure typeDataIdigi.addI(i:integer;x:integer);
  begin
    inc(Psmallint(intG(p)+(i-indice1)*StepSize)^,x shl Vshift);
  end;

procedure typeDataIdigi.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataIdigi.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;


{*********************** Méthodes de typeDataFileIdigi ****************************}

constructor typeDataFileIdigi.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean;shift:integer);
begin
  Vshift:=shift;
  inherited create(st,offset,nbv,imin,imax,modeOP);
end;

procedure typeDataFileIdigi.loadBlock;
var
  i:integer;
  ad:pointer;
  w:byte;
  n:integer;

begin
  inherited;

  {$IFDEF WIN64}
  for i:=0 to maxBuf-1 do tb^.i[i]:= tb^.i[i] shr Vshift;
  {$ELSE}
  ad:=@tb^.i[0];
  w:=Vshift;
  n:=maxBuf;

  asm
      push esi

      mov  ecx,n
      mov  esi,ad
  @@1:mov  ax,[esi]
      xchg ecx,edx
      mov  cl,w
      sar  ax,cl
      mov  [esi],ax
      xchg ecx,edx
      add  esi,2
      loop @@1

      pop  esi
  end;
  {$ENDIF}
end;

procedure typeDataFileIdigi.saveBlock;
var
  res:intG;
  i:integer;
  d,n:int64;
  buf:PtabEntier;

  m1,m2:word;

begin
  if not Asauver then exit;

  if not modeOpen then openf(modeWrite);
  d:=off+block*maxBuf*2*nbvoie;
  forg.Position:= d;
  n:=off+(indiceMax-indicemin)*2*nbvoie+size -d;
  if n>maxBuf*size*nbvoie then n:=maxBuf*size*nbvoie;

  m1:=1 shl Vshift-1;
  m2:=not m1;

  getmem(buf,n);
  forg.Read(buf^,n);
  for i:=0 to n div (2*nbvoie)-1 do
    buf^[i*nbvoie]:=tb^.i[i] shl Vshift OR buf^[i*nbvoie] and m1;

  forg.Position:=d;
  forg.Write(buf^,n);
  freemem(buf);

  if not modeOpen then closef;
  Asauver:=false;
end;

procedure typeDataFileIdigi.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataFileIdigi.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;



{*********************** Méthodes de typeDataDigiTag ****************************}

constructor typeDataDigiTag.create(p0:pointer;nbv,i1,iMin,Imax:integer;rang:integer);
begin
  masque:=word(1) shl (rang-1);
  createStep(p0,nbv*2,i1,iMin,iMax,rang);
end;

constructor typeDataDigiTag.createStep(p0:pointer;step,i1,iMin,Imax:integer;rang:integer);
begin
  inherited createStep(p0,step,i1,iMin,Imax);
  masque:=word(1) shl (rang-1);
end;

function typeDataDigiTag.EltSize: integer;
begin
  result:=2;
end;

destructor typeDataDigiTag.destroy;
  begin
  end;

function typeDataDigiTag.getI(i:integer):integer;
var
  x:smallint;
begin
  x:=Psmallint(intG(p)+(i-indice1)*StepSize)^;
  if x and masque<>0
    then getI:=1
    else getI:=0;
end;

function typeDataDigiTag.getE(i:integer):float;
  begin
    getE:=getI(i);
  end;

procedure typeDataDigiTag.setI(i:integer;x:integer);
  begin
  end;

procedure typeDataDigiTag.setE(i:integer;x:float);
  begin
  end;

procedure typeDataDigiTag.addI(i:integer;x:integer);
  begin
  end;

procedure typeDataDigiTag.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataDigiTag.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;


{*********************** Méthodes de typeDataFileDigiTag ****************************}

constructor typeDataFileDigiTag.create(st:AnsiString;offset: int64;nbv:integer;
                               iMin,Imax:integer;modeOp:boolean;rang1:integer);
begin
  rang0:=rang1;
  masque:=word(1) shl (rang1-1);

  inherited create(st,offset,nbv,imin,imax,modeOP);

end;

constructor typeDataFileDigiTag.create(f: TgetStream; offset: int64; nbv, iMin, Imax: integer; modeOp: boolean; Rang1: integer);
begin
  fstream:=f;
  create('',offset,nbv,iMin,Imax,modeOp,rang1);
end;

procedure typeDataFileDigiTag.loadBlock;
var
  i:integer;
  ad:pointer;
  r,w:word;
  n:integer;

begin
  inherited;

  {$IFDEF WIN64}
  for i:=0 to maxbuf-1 do tb^.i[i] := ord(tb^.i[i] and masque<>0)  ;

  {$ELSE}
  ad:=@tb^.i[0];
  w:=masque;
  r:=rang0;
  n:=maxBuf;

  asm
      push esi

      mov  ecx,n
      mov  esi,ad
  @@1:mov  ax,[esi]


      and  ax,w
      mov  ax,1
      jnz  @@2
      mov  ax,0
  @@2:
      mov  [esi],ax

      add  esi,2
      loop @@1

      pop  esi
  end;
  {$ENDIF}
end;

procedure typeDataFileDigiTag.saveBlock;
var
  res:intG;
  i:integer;
  d,n:int64;
  buf:PtabEntier;

  m1,m2:word;

begin
  if not Asauver then exit;

  if not modeOpen then openf(modeWrite);
  d:=off+int64(block)*maxBuf*2*nbvoie;
  forg.Position:= d;
  n:=off+(indiceMax-indicemin)*2*nbvoie+size -d;
  if n>maxBuf*size*nbvoie then n:=maxBuf*size*nbvoie;

  m1:=masque;
  m2:=not m1;

  getmem(buf,n);
  forg.Read(buf^,n);
  for i:=0 to n div (2*nbvoie)-1 do
    buf^[i*nbvoie]:=tb^.i[i] shl rang0 OR buf^[i*nbvoie] and m1;

  forg.Position:= d;
  forg.Write(buf^,n);
  freemem(buf);

  if not modeOpen then closef;
  Asauver:=false;
end;

procedure typeDataFileDigiTag.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataFileDigiTag.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;


{*********************** Méthodes de typeDataIT ****************************}

constructor typeDataIT.create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
begin
  createStep(p0,nbv*2,nbpt,i1,imin,imax);
end;

constructor typeDataIT.createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
begin
  NbStep:=Nstep;
  inherited createStep(p0,step,i1,imin,imax);
end;

function typeDataIT.EltSize: integer;
begin
  result:=2;
end;

function typeDataIT.getI(i:integer):integer;
begin
  try
    result:=Psmallint(intG(p)+ ((i+indice1+NbStep) mod NbStep)*StepSize)^;
  except
    messageCentral('NbStep='+Istr(NbStep)+'  StepSize='+Istr(StepSize)+'   i='+Istr(i)+'  p='+Istr(intG(p)));
  end;
end;

function typeDataIT.getP(i:integer):pointer;
begin
  result:=@Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^;
end;

procedure typeDataIT.setI(i:integer;x:integer);
  begin
    Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^:=x;
  end;

procedure typeDataIT.addI(i:integer;x:integer);
  begin
    inc(Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^,x);
  end;

function typeDataIT.getE(i:integer):float;
begin
  result:=convy(getI(i));
end;

procedure typeDataIT.setE(i:integer;x:float);
begin
  Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^:=invConvY(x);
end;



procedure typeDataIT.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataIT.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;

function typeDataIT.tournant:boolean;
begin
  result:=true;
end;

{*********************** Méthodes de typeDataLT ****************************}

constructor typeDataLT.create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
begin
  createStep(p0,nbv*4,nbpt,i1,imin,imax);
end;

constructor typeDataLT.createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
begin
  NbStep:=Nstep;
  inherited createStep(p0,step,i1,imin,imax);
end;


function typeDataLT.EltSize: integer;
begin
  result:=4;
end;

function typeDataLT.getI(i:integer):integer;
begin
  result:=Plongint(intG(p)+ ((i+indice1+NbStep) mod NbStep)*StepSize)^;
end;

function typeDataLT.getP(i:integer):pointer;
begin
  result:=pointer(intG(p)+(i+indice1+NbStep) mod NbStep *StepSize);
end;

procedure typeDataLT.setI(i:integer;x:integer);
  begin
    PLongint(intG(p)+(i+indice1+NbStep) mod NbStep *StepSize)^:=x;
  end;

procedure typeDataLT.addI(i:integer;x:integer);
  begin
    inc(PLongint(intG(p)+(i+indice1+NbStep) mod NbStep *StepSize)^,x);
  end;


function typeDataLT.getE(i:integer):float;
  begin
    result:=convY(getI(i));
//    affdebug('getE '+Istr(i)+'  '+Estr(result,6),101);
  end;

procedure typeDataLT.setE(i:integer;x:float);
  begin
    setI(i,invConvY(x));
  end;


procedure typeDataLT.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataLT.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;

function typeDataLT.tournant:boolean;
begin
  result:=true;
end;

{*********************** Méthodes de typeDataWT ****************************}

constructor typeDataWT.create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
begin
  createStep(p0,nbv*2,nbpt,i1,imin,imax);
end;

function typeDataWT.EltSize: integer;
begin
  result:=2;
end;

function typeDataWT.getI(i:integer):integer;
begin
  result:=PWord(intG(p)+((i+indice1) mod NbStep) *StepSize)^;
end;

procedure typeDataWT.setI(i:integer;x:integer);
  begin
    PWord(intG(p)+((i+indice1) mod NbStep) *StepSize)^:=x;
  end;


{*********************** Méthodes de typeDataByteT ****************************}

constructor typeDataByteT.create(p0:pointer;nbv,nbpt,i1,imin,imax:integer);
begin
  createStep(p0,nbv,nbpt,i1,imin,imax);
end;

function typeDataByteT.EltSize: integer;
begin
  result:=1;
end;

function typeDataByteT.getI(i:integer):integer;
begin
  result:=Pbyte(intG(p)+((i+indice1) mod NbStep) *StepSize)^;
end;

procedure typeDataByteT.setI(i:integer;x:integer);
begin
  Pbyte(intG(p)+((i+indice1) mod NbStep) *StepSize)^:=x;
end;



{*********************** Méthodes de typeDataIdigiT ****************************}

constructor typeDataIdigiT.create(p0:pointer;nbv,nbpt,i1,imin,imax:integer;shift:integer);
  begin
    inherited create(p0,nbv,nbpt,i1,imin,imax);
    Vshift:=shift;
  end;

constructor typeDataIdigiT.createStep(p0:pointer;step,Nstep,i1,imin,imax:integer;shift:integer);
  begin
    inherited createStep(p0,step,Nstep,i1,imin,imax);
    Vshift:=shift;
  end;

function typeDataIdigiT.EltSize: integer;
begin
  result:=2;
end;


function typeDataIdigiT.getI(i:integer):integer;
var
  x:smallint;
  w:byte;
begin
  x:=inherited getI(i);
  {$IFNDEF WIN64}
  w:=Vshift;
  asm
    mov ax,x
    mov cl,w
    sar ax,cl
    mov x,ax
  end;
  result:=x;
  {$ELSE}
   result:=sar(x,Vshift);
  {$ENDIF}
end;


procedure typeDataIdigiT.setI(i:integer;x:integer);
  begin
    Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^:=x shl Vshift;
  end;

function typeDataIdigiT.getE(i:integer):float;
begin
  result:=convy(getI(i));
end;

procedure typeDataIdigiT.setE(i:integer;x:float);
  begin
    Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^:=invConvY(x) shl Vshift ;
  end;

procedure typeDataIdigiT.addI(i:integer;x:integer);
  begin
    inc(Psmallint(intG(p)+(i+indice1) mod NbStep *StepSize)^,x shl Vshift);
  end;

{*********************** Méthodes de typeDataDigiTagT *************************}

constructor typeDataDigiTagT.create(p0:pointer;nbv,nbpt,i1,imin,imax:integer;rang:integer);
  begin
    inherited create(p0,nbv,nbpt,i1,imin,imax);
    NbStep:=nbpt;
    masque:=word(1) shl (rang-1);

  end;

constructor typeDataDigiTagT.createStep(p0:pointer;step,Nstep,i1,imin,imax:integer;rang:integer);
begin
  inherited createStep(p0,step,Nstep,i1,imin,imax);
  masque:=word(1) shl (rang-1);
end;

function typeDatadigiTagT.EltSize: integer;
begin
  result:=2;
end;


function typeDataDigiTagT.getI(i:integer):integer;
var
  x:smallint;
begin
  x:=inherited getI(i);
  if x and masque<>0
    then getI:=1
    else getI:=0;

end;

procedure typeDataDigiTagT.setI(i:integer;x:integer);
  begin
  end;

procedure typeDataDigiTagT.setE(i:integer;x:float);
  begin
  end;

procedure typeDataDigiTagT.addI(i:integer;x:integer);
  begin
  end;

procedure typeDataDigiTagT.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  begin
  end;

{*********************** Méthodes de typeDataIdigiTev ****************************}

constructor typeDataIdigiTev.create(p0:pointer;nbv,nbpt,imin,imax,shift:integer);
begin
  inherited create(p0,nbv,nbpt,0,imin,imax,shift);
end;

function typeDataIdigiTev.EltSize: integer;
begin
  result:=2;
end;


function typeDataIdigiTev.getI(i:integer):integer;
var
  x:smallint;
begin
  x:=inherited getI(i);
  if x=0 then result:=-10000
         else result:=i;
end;

function typeDataIdigiTev.getE(i:integer):float;
var
  x:smallint;
begin
  x:=inherited getI(i);
  if x=0 then result:=-10000
         else result:=convx(i);
end;


{*********************** Méthodes de typeDataITev ****************************}

constructor typeDataITev.create(p0:pointer;nbv,nbpt,imin,imax:integer);
begin
  inherited create(p0,nbv,nbpt,0,imin,imax);
end;

function typeDataITev.EltSize: integer;
begin
  result:=2;
end;


function typeDataITev.getI(i:integer):integer;
var
  x:smallint;
begin
  x:=inherited getI(i);
  if x=0 then result:=-10000
         else result:=i;
end;

function typeDataITev.getE(i:integer):float;
var
  x:smallint;
begin
  x:=inherited getI(i);
  if x=0 then result:=-10000
         else result:=convx(i);
end;


{******************* Méthodes de typeDataFileIK ******************************}
(*

*)

function SegArraySize(segs:TKsegArray):int64;
var
  i:integer;
begin
  result:=0;
  for i:=0 to high(segs) do
    result:=result+segs[i].size;
end;


procedure typeDataFileIK.InitKFile(st:AnsiString;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;modeOp:boolean);
var
  i,pp:integer;
  sizeTot,nbTot:int64;
  res:integer;
  Reste:integer;

begin
  Lmask:=length(msk);
  setLength(mask,Lmask);
  move(msk[0],mask[0],Lmask);

  setLength(maskSizes,Lmask);
  move(mskSize[0],maskSizes[0],Lmask);

  {Lp est le nb d'échantillons utiles dans l'Ag }
  Lp:=0;
  for i:=0 to Lmask-1 do
    if mask[i] then inc(Lp);

  {Calcul de AgSize }
  AgSize:=0;
  for i:=0 to Lmask-1 do
    AgSize:=AgSize+maskSizes[i];

  Nsegs:=length(segs1);
  setLength(segs,Nsegs);
  move(segs1[0],segs[0],sizeof(segs[0])*Nsegs);

  {S'arranger pour que tb contienne un nb d'échantillons multiple de Lp}
  maxBuf:=(maxBufDF div size) div Lp *Lp;

  {Calculer la taille totale des data }
  SizeTot:=0;
  for i:=0 to Nsegs-1 do SizeTot:=SizeTot+ segs[i].size;

  {Puis le nb d'échantillons utiles}
  nbTot:=SizeTot div AgSize * Lp;
  {Comme la division ne tombe pas forcément juste, il faut ajouter
   les échantillons du dernier agrégat incomplet}

  Reste:=SizeTot mod AgSize;
  i:=0;
  pp:=0;
  while pp<Reste do
  begin
    if mask[i] then inc(nbTot);
    pp:=pp+maskSizes[i];
    inc(i);
  end;

  IndiceMin:=0;
  IndiceMax:=nbTot-1;
  if nbTot<maxBuf then
      maxBuf:=nbTot;

  getmem(tb,maxBuf*size);


  modeOpen0:=modeOp or assigned(fstream);
  modeOpen:=modeOpen0;
  ax:=1;
  bx:=0;
  ay:=1;
  by:=0;
  nomf:='';
  unix:=false;

  if not assigned(fstream) and not fileExists(st) then
    begin
      indiceMin:=0;
      indiceMax:=0;
      exit;
    end;

  nomf:=st;
  Asauver:=false;

  block:=0;

  modeOpen:=false;
  LoadBlock;
  modeOpen:=modeOp;

end;

constructor typeDataFileIK.create(st:AnsiString;msk:Tmsk;segs1:TKsegArray;modeOp:boolean;shift:integer;MskTag:word);
var
  mskSize:TmskSize;
begin
  setlength(mskSize,length(msk));
  fillchar(mskSize[0],length(msk),2);
  create(st,msk,mskSize,segs1,modeOp,shift,MskTag);
end;


constructor typeDataFileIK.create(f:TgetStream;msk:Tmsk;segs1:TKsegArray;modeOp:boolean;shift:integer;MskTag:word);
var
  mskSize:TmskSize;
begin
  setlength(mskSize,length(msk));
  fillchar(mskSize[0],length(msk),2);
  create(f,msk,mskSize,segs1,modeOp,shift,MskTag);
end;


constructor typeDataFileIK.create(st:AnsiString;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;
                               modeOp:boolean;shift:integer;mskTag:word);

begin
  size:=2;
  Vshift:=shift;
  maskTag:=mskTag;

  initKFile(st,msk,mskSize,segs1,modeOp);

end;

constructor typeDataFileIK.create(f:TgetStream;msk:Tmsk;mskSize:TmskSize;segs1:TKsegArray;
                               modeOp:boolean;shift:integer;MskTag:word);
begin
  fstream:=f;
  create('',msk,mskSize,segs1,modeOp,shift,MskTag);
end;



procedure typeDataFileIK.loadBlock;
var
  res:intG;
  buf:PtabOctet;
  i,k,pp:integer;
  p,p1:Pointer;

  ad:pointer;
  w:byte;
  n:integer;

  sz,SzBuf,size0,off0:int64;
  mt:word;

  modeClose:boolean;

begin
  if not assigned(fstream) then
  begin
    if nomf='' then exit;
    if not modeOpen then openf(modeWrite);
  end;

  modeClose:=not assigned(fstream) and not modeOpen;

  SzBuf:=maxBuf div Lp *AgSize;       {taille à charger dans buf pour remplir tb}
  getmem(buf,SzBuf);
  fillchar(buf^,SzBuf,1);

  {Chercher le numéro du segment contenant le premier point}
  i:=0;
  sz:=segs[0].size;
  while (i<Nsegs-1) and (sz<Block*szBuf) do
  begin
    inc(i);
    sz:=sz+segs[i].size;
  end;
  if sz<Block*szBuf then
  begin
    if modeClose then closef;
    exit;
  end;
  {size0 est la taille des data disponibles dans le segment i}
  {off0 est l'offset correspondant dans le fichier}

  size0:=sz-Block*szBuf;
  off0:=int64(segs[i].off)+ (Block*szBuf-sz+segs[i].size);

  {Charger buf en changeant de segment à chaque fois que c'est nécessaire}
  sz:=0;
  while (sz<szBuf) and (i<Nsegs) do
  begin
    if size0>szBuf-sz then size0:=szBuf-sz;

    if not assigned(fstream) then
    begin
      forg.Position:= off0;
      forg.Read(buf^[sz ],size0);
    end
    else
    if fStream<>nil then
    begin
      try
      fstream().position:=off0;
      fstream().read(buf^[sz],size0);
      except

      end;
    end;

    sz:=sz+size0;
    inc(i);
    if i<Nsegs then
    begin
      size0:=segs[i].size;
      off0:=segs[i].off;
    end;
  end;

  {Transférer de buf dans tb}
  k:=0;
  i:=0;
  p:=pointer(buf);
  p1:=pointer(tb);
  pp:=0;
  while pp<sz do
  begin
    if mask[i] then
      begin
        move(p^,p1^,size);
        inc(intG(p1),size);
      end;
    inc(pp,maskSizes[i]);
    inc(intG(p),maskSizes[i]);

    i:=(i+1) mod Lmask;
  end;

  {Libérer tb}
  freemem(buf);

  if unix then swapBuf;
  if modeClose then closef;


  {$IFDEF WIN64}
  if Vshift<>0 then
    for i:=0 to maxbuf-1 do tb^.i[i] := tb^.i[i] shr Vshift;

  if maskTag<>0 then
      for i:=0 to maxbuf-1 do tb^.i[i] := ord(tb^.i[i] and maskTag<>0);
  {$ELSE}
  if Vshift<>0 then
  begin
    ad:=@tb^.i[0];
    w:=Vshift;
    n:=maxBuf;

    asm
        push esi

        mov  ecx,n
        mov  esi,ad
    @@1:mov  ax,[esi]
        xchg ecx,edx
        mov  cl,w
        sar  ax,cl
        mov  [esi],ax
        xchg ecx,edx
        add  esi,2
        loop @@1

        pop  esi
    end;

  end;

  if maskTag<>0 then
  begin
    ad:=@tb^.i[0];
    n:=maxBuf;
    mt:=maskTag;

    asm
        push esi
        mov  dx,mt

        mov  ecx,n
        mov  esi,ad
    @@3:mov  ax,[esi]
        and  ax,dx
        mov  ax,0
        jz   @@4
        mov  ax,1
    @@4:mov  [esi],ax

        add  esi,2
        loop @@3

        pop  esi
    end;

  end;
  {$ENDIF}
end;


(* Cette version de LoadBlock est plus lente que la précédente


procedure typeDataFileIK.loadBlock;
var
  i,iseg:integer;
  p1,ptbf:Pointer;

  pdata,pfin,pf: int64;
  SzBuf,size0,off0:int64;

  modeClose:boolean;

  ad:pointer;
  w:byte;
  n:integer;
  mt: word;

begin
  if not assigned(fstream) then
  begin
    if nomf='' then exit;
    if not modeOpen then openf(modeWrite);
  end;

  modeClose:=not assigned(fstream) and not modeOpen;

  SzBuf:=maxBuf div Lp *AgSize;       {taille d'un bloc sur le disque}


  {Chercher le numéro du segment contenant le premier point}
  iseg:=0;
  off0:= segs[0].off;
  pfin:=segs[0].size;
  pdata:= Block*szBuf;
  while (iseg<Nsegs-1) and (pfin<pData) do
  begin
    inc(iseg);
    off0:=  segs[iseg].off - pfin;
    pfin:= pfin+segs[iseg].size;
  end;
  if pfin<pData then
  begin
    if modeClose then closef;
    exit;
  end;
  { sz taille totale des data en incluant le bloc courant }
  { size0 est la taille des data disponibles dans le segment i}
  { off0 est la valeur à ajouter à pdata pour obtenir l'offset dans le fichier}

  i:=0;
  p1:=pointer(tb);
  intG(ptbf):= intG(p1)+maxbuf*size;
  pf:= pdata+SzBuf;

  while pdata<pf do
  begin

    if mask[i] then
      begin
        if not assigned(fstream) then
        begin
          forg.Position:= pdata+off0;
          forg.Read(p1^,size);
        end
        else
        if fStream<>nil then
        begin
          try
          fstream().position:=pdata+off0;
          fstream().read(p1^,size);
          except

          end;
        end;
        intG(p1):= intG(p1)+size;
        if intG(p1)> intG(ptbf) then break;
      end;
    
    pdata:=pdata+ maskSizes[i];
    if pdata>= pfin then
    begin
      inc(iseg);
      if iseg<Nsegs then
      begin
        off0:=  segs[iseg].off - pfin;
        pfin:= pfin+segs[iseg].size;
      end
      else break;
    end;
    i:=(i+1) mod Lmask;
  end;


  if unix then swapBuf;
  if modeClose then closef;


  {$IFDEF WIN64}
  if Vshift<>0 then
    for i:=0 to maxbuf-1 do tb^.i[i] := tb^.i[i] shr Vshift;

  if maskTag<>0 then
      for i:=0 to maxbuf-1 do tb^.i[i] := ord(tb^.i[i] and maskTag<>0);
  {$ELSE}
  if Vshift<>0 then
  begin
    ad:=@tb^.i[0];
    w:=Vshift;
    n:=maxBuf;

    asm
        push esi

        mov  ecx,n
        mov  esi,ad
    @@1:mov  ax,[esi]
        xchg ecx,edx
        mov  cl,w
        sar  ax,cl
        mov  [esi],ax
        xchg ecx,edx
        add  esi,2
        loop @@1

        pop  esi
    end;

  end;

  if maskTag<>0 then
  begin
    ad:=@tb^.i[0];
    n:=maxBuf;
    mt:=maskTag;

    asm
        push esi
        mov  dx,mt

        mov  ecx,n
        mov  esi,ad
    @@3:mov  ax,[esi]
        and  ax,dx
        mov  ax,0
        jz   @@4
        mov  ax,1
    @@4:mov  [esi],ax

        add  esi,2
        loop @@3

        pop  esi
    end;

  end;
  {$ENDIF}
end;
*)

procedure typeDataFileIK.saveBlock;
begin
end;


procedure typeDataFileIK.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataFileIK.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;

{************************************* TypeDataFileTagK ***************************************}

procedure typeDataFileTagK.InitKFile(st:AnsiString;segs1:TKsegArray;modeOp:boolean);
var
  i,pp:integer;
  sizeTot,nbTot:int64;

  CybTag: TcybTag;

begin

  Nsegs:=length(segs1);
  setLength(segs,Nsegs);
  move(segs1[0],segs[0],sizeof(segs[0])*Nsegs);

  maxBuf:= 10000;

  {Calculer la taille totale des data }
  SizeTot:=0;
  for i:=0 to Nsegs-1 do SizeTot:=SizeTot+ segs[i].size;

  {Puis le nb d'échantillons utiles}
  size:=1;                           { 1 octet par sample }
  nbTot:=SizeTot div size;


  getmem(tb,maxBuf*size);


  modeOpen0:=modeOp or assigned(fstream);
  modeOpen:=modeOpen0;
  ax:=1;
  bx:=0;
  ay:=1;
  by:=0;
  nomf:='';
  unix:=false;

  if not assigned(fstream) and not fileExists(st) then
    begin
      indiceMin:=0;
      indiceMax:=0;
      exit;
    end;

  nomf:=st;
  Asauver:=false;

  block:=0;
  setlength(CybStart,Nsegs);
  setlength(CybEnd,Nsegs);
  for i:=0 to Nsegs-1 do
  begin
    CybStart[i].tt:=longword(-1);
    CybEnd[i].tt:=longword(-1);
  end;
  CurSeg:=-1;

  indicemax:=getSegEnd(Nsegs-1);

  modeOpen:=false;
  LoadBlock;
  modeOpen:=modeOp;



end;


constructor typeDataFileTagK.create(st:AnsiString;segs1:TKsegArray;
                               modeOp:boolean;MskTag:word);
begin
end;


constructor typeDataFileTagK.create(f:TgetStream;segs1:TKsegArray;MskTag:word);
begin
  fstream:=f;
  MaskTag:=MskTag;
  initKfile('',segs1,false);
end;

function typeDataFileTagK.GetSegStart(num:integer): longword;
var
  cyb1, cyb2: TcybTag;
  nn:integer;

begin
  if CybStart[num].tt=longword(-1) then
  begin
    if (num>=0) and (num<Nsegs) then
    begin
      if assigned(fstream) then
      begin
        fstream().Position:=segs[num].off;
        fstream().Read(cyb1,sizeof(Cyb1));

        fstream().Position:=segs[num].off + segs[num].size - sizeof(TcybTag);
        fstream().Read(cyb2,sizeof(Cyb2));

        nn:=0;
        while (cyb2.tt<cyb1.tt) and (fstream().position>segs[num].off) do
        begin
          fstream().Position:=fstream().position - 2*sizeof(TcybTag);
          fstream().Read(cyb2,sizeof(Cyb2));
          inc(nn);
        end;
       // if nn>0 then messageCentral(Istr(nn));
      end
      else
      begin
        forg.Position:=segs[num].off;
        forg.Read(cyb1,sizeof(Cyb1));

        forg.Position:=segs[num].off + segs[num].size - sizeof(TcybTag);
        forg.Read(cyb2,sizeof(Cyb2));

        while (cyb2.tt<cyb1.tt) and (forg.position>segs[num].off) do
        begin
          forg.Position:=forg.position - 2*sizeof(TcybTag);
          forg.Read(cyb2,sizeof(Cyb2));
        end;
      end;

      CybStart[num]:=cyb1;
      CybEnd[num]:=cyb2;

      //if num=0 then CybStart[num].tt:=0;
    end
    else
    begin
      CybStart[num].tt:=0;
      CybEnd[num].tt:=0;
    end;
  end;

  result:=CybStart[num].tt;
end;

function typeDataFileTagK.GetSegEnd(num:integer): longword;
begin
  getSegStart(num);
  result:=CybEnd[num].tt;
end;

procedure typeDataFileTagK.loadSeg(num:integer);
begin
  if curSeg=num then exit;

  if (num>=0) and (num<Nsegs) then
  begin
    setlength(segBuf,segs[num].size div sizeof(TcybTag));
    if length(segBuf)>0 then
    begin
      if assigned(fstream) then
      begin
        fstream().Position:=segs[num].off;
        fstream().Read(segBuf[0],segs[num].size);
      end
      else
      begin
        forg.Position:=segs[num].off;
        forg.Read(segBuf[0],segs[num].size);
      end;

      CybStart[num]:=segBuf[0];
      CybEnd[num]:=segBuf[high(segBuf)];
    end
    else
    begin
      CybStart[num].tt:=0; // situation anormale
      CybStart[num].wt:=0;

      CybEnd[num].tt:=0;
      CybEnd[num].wt:=0;
    end;
    CurSeg:=num;
  end;
end;



procedure typeDataFileTagK.loadBlock;
var
  modeClose:boolean;
  i,j, num:integer;
  cybLast,cybNext: TcybTag;
  t1,t2:longword;
  tt1,tt2:integer;
  IsegBuf:integer;

  function getNext:TcybTag;
  begin
    if (num>=Nsegs) or (IsegBuf>=length(segBuf)) then
    begin
      inc(num);
      if num>=Nsegs then
      begin
        result.tt:=maxLongWord;
        dec(num);
        exit;
      end;
      loadSeg(num);
      IsegBuf:=0;
    end;
    if IsegBuf<length(segBuf) then result:=segBuf[IsegBuf];
    inc(IsegBuf);
  end;

begin
  if not assigned(fstream) then
  begin
    if nomf='' then exit;
    if not modeOpen then openf(modeWrite);
  end;

  modeClose:=not assigned(fstream) and not modeOpen;

  {rechercher le bon segment}
  t1:=maxBuf*block;
  t2:=maxBuf*(block+1)-1;

  num:=0;
  while (GetSegEnd(num)<t1) and (num<Nsegs) do inc(num);        { t1 au delà de la fin du seg précédent }

  if num>=Nsegs then
  begin
    cybLast:=cybEnd[Nsegs-1];
  end
  else
  begin
    if num<=0 then
    begin
      if cybStart[0].tt=0 then cybLast:=cybStart[0]
      else
      begin
        cybLast.tt:=0;
        cybLast.wt:=0;
      end;
    end
    else cybLast:=cybEnd[num-1];

    loadSeg(num);
  end;

  IsegBuf:=0;
  repeat
    cybNext:=getNext;

    if cybLast.tt<t1
      then tt1:=0
      else tt1:=cybLast.tt-maxBuf*block;

    if cybNext.tt>t2
      then tt2:=maxBuf
      else tt2:=cybNext.tt-maxBuf*block;

    if tt2>tt1
      then  fillchar(tb^.b[tt1],tt2-tt1,ord(cybLast.wt and maskTag <>0));

    cybLast:=cybNext;
  until cybNext.tt>t2;

  if modeClose then closef;

end;


procedure typeDataFileTagK.saveBlock;
begin
end;


procedure typeDataFileTagK.setBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do setI(j,tbI^[j-i]);
  end;

procedure typeDataFileTagK.getBlockI(i:integer;tbI:PtabEntier;n:integer);
  var
    j:integer;
  begin
    for j:=i to i+n-1 do tbI^[j-i]:=getI(j);
  end;


function typeDataFileTagK.getI(i:integer):integer;
  var
    j:integer;
  begin
    if (i<indiceMin) or (i>indiceMax) then
      begin
        getI:=0;
        exit;
      end;

    j:=(i-indiceMin);
    positionneBlock(j);

    getI:=tb^.b[j-block*maxBuf];
  end;


{**************************************** Méthodes de typeDataFileSK ********************}


constructor typeDataFileSK.create(f: TgetStream; msk: Tmsk; mskSize: TmskSize; segs1: TKsegArray; modeOp: boolean);
begin
  fstream:=f;
  create('',msk,mskSize,segs1,modeOp);
end;

constructor typeDataFileSK.create(st: AnsiString; msk: Tmsk; mskSize: TmskSize; segs1: TKsegArray; modeOp: boolean);
begin
  size:=4;
  initKFile(st,msk,mskSize,segs1,modeOp);
end;

function typeDataFileSK.EltSize: integer;
begin
  result:=4;
end;

procedure typeDataFileSK.setE(i: Integer; x: float);
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then exit;

  j:=(i-indiceMin);
  positionneBlock(j);

  tb^.s[j-block*maxBuf]:=x;
  Asauver:=true;
end;




function typeDataFileSK.getE(i: Integer): float;
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then
    begin
      result:=0;
      exit;
    end;

  j:=(i-indiceMin);
  positionneBlock(j);

  result:=tb^.s[j-block*maxBuf];
end;



procedure typeDataFileSK.setI(i, x: Integer);
begin
  setE(i,x);
end;

function typeDataFileSK.getI(i: Integer): longint;
begin
  result:=roundL(getE(i));
end;

function typeDataFileSK.getP(i: integer): pointer;
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then
    begin
      result:=nil;
      exit;
    end;

  j:=(i-indiceMin);
  positionneBlock(j);

  result:=@tb^.s[j-block*maxBuf];
end;


procedure typeDataFileSK.addI(i, x: Integer);
var
  j:longint;
begin
  if (i<indiceMin) or (i>indiceMax) then exit;

  j:=(i-indicemin);
  positionneBlock(j);

  tb^.s[j-block*maxBuf]:=tb^.s[j-block*maxBuf]+x;
  Asauver:=true;
end;


procedure typeDataFileSK.setBlockS(i:integer;tbI:PtabSingle;n:integer);
  var
    j:integer;
    res:intG;
  begin
    if nbvoie=1 then
      begin
        dec(i,indiceMin);
        saveBlock;      { SAuver d'abord tb si n‚cessaire }

        if not modeOpen then openf(modeWrite);
        forg.Position:= off+size*i;
        forg.Write(tbI^,n*4);                       { Ne peut s'appliquer qu'… }
        if not modeOpen then closef;          { typeDataFileS }

        block:=-1;
        { Comme on accède directement au fichier sans passer par tb, il faut
          imposer un LoadBlock au prochain accès normal }
      end
    else
      for j:=i to i+n-1 do setE(j,tbI^[j-i]);
  end;

procedure typeDataFileSK.getBlockS(i:integer;tbI:PtabSingle;n:integer);
  var
    j:integer;
    res:intG;
  begin
    if nbvoie=1 then
      begin
        saveBlock;      { SAuver d'abord tb si n‚cessaire }
        dec(i,indiceMin);
        if not modeOpen then openf(false);
        forg.Position:= off+sizeof(single)*i;
        forg.Read(tbI^,n*4);
        if not modeOpen then closef;

        block:=-1;
        { Comme on accède directement au fichier sans passer par tb, il faut
          imposer un LoadBlock au prochain accès normal }
      end
    else
      for j:=i to i+n-1 do tbI^[j-i]:=getE(j);
  end;


{**************************************** Méthodes de typeDataFileDK ********************}


constructor typeDataFileDK.create(f: TgetStream; msk: Tmsk; mskSize: TmskSize; segs1: TKsegArray; modeOp: boolean);
begin
  fstream:=f;
  create('',msk,mskSize,segs1,modeOp);
end;

constructor typeDataFileDK.create(st: AnsiString; msk: Tmsk; mskSize: TmskSize; segs1: TKsegArray; modeOp: boolean);
begin
  size:=8;
  initKFile(st,msk,mskSize,segs1,modeOp);
end;

function typeDataFileDK.EltSize: integer;
begin
  result:=8;
end;

procedure typeDataFileDK.setE(i: Integer; x: float);
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then exit;

  j:=(i-indiceMin);
  positionneBlock(j);

  tb^.d[j-block*maxBuf]:=x;
  Asauver:=true;
end;




function typeDataFileDK.getE(i: Integer): float;
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then
    begin
      result:=0;
      exit;
    end;

  j:=(i-indiceMin);
  positionneBlock(j);

  result:=tb^.d[j-block*maxBuf];
end;



procedure typeDataFileDK.setI(i, x: Integer);
begin
  setE(i,x);
end;

function typeDataFileDK.getI(i: Integer): longint;
begin
  result:=roundL(getE(i));
end;

function typeDataFileDK.getP(i: integer): pointer;
var
  j:integer;
begin
  if (i<indiceMin) or (i>indiceMax) then
    begin
      result:=nil;
      exit;
    end;

  j:=(i-indiceMin);
  positionneBlock(j);

  result:=@tb^.d[j-block*maxBuf];
end;


procedure typeDataFileDK.addI(i, x: Integer);
var
  j:longint;
begin
  if (i<indiceMin) or (i>indiceMax) then exit;

  j:=(i-indicemin);
  positionneBlock(j);

  tb^.d[j-block*maxBuf]:=tb^.d[j-block*maxBuf]+x;
  Asauver:=true;
end;




{******************* Méthodes de typeDataFileSegL ******************************}

constructor typeDataFileSegL.create(st:AnsiString;segs1:TKsegArray;modeOp:boolean);
begin
  InitSegFile(st,segs1,modeOp, 4, segs, Nsegs);
end;

constructor typeDataFileSegL.create(f:TgetStream;segs1:TKsegArray;modeOp:boolean);
begin
  fStream:=f;
  create('',segs1,true);
end;

function typeDataFileSegL.EltSize: integer;
begin
  result:=4;
end;

procedure typeDataFileSegL.loadBlock;
begin
  LoadSegBlock( segs, Nsegs );
end;



{******************* Méthodes de typeDataFileSegB ******************************}

constructor typeDataFileSegB.create(st:AnsiString;segs1:TKsegArray;modeOp:boolean);
begin
  InitSegFile(st,segs1,modeOp, 1, segs, Nsegs);
end;

constructor typeDataFileSegB.create(f:TgetStream;segs1:TKsegArray;modeOp:boolean);
begin
  fStream:=f;
  create('',segs1,true);
end;

procedure typeDataFileSegB.loadBlock;
begin
  LoadSegBlock( segs, Nsegs );
end;


{**************************** typeDataIbit *************************************}


constructor typeDataIbit.create(p0: pointer; nbv, i1, iMin, Imax, Ibit : integer);
begin
  createStep(p0,nbv*2, i1, iMin, Imax);
  Sbit:=Ibit;
  Smask:=1 shl Ibit;
end;

function typeDataIbit.EltSize: integer;
begin
  result:=2;
end;

procedure typeDataIbit.setI(i, x: integer);
var
  pp:Psmallint;
begin
  pp:=Psmallint(intG(p)+(i-indice1)*StepSize);
  pp^:=(pp^ and not Smask) or Smask*ord(x<>0);
end;

function typeDataIbit.getI(i: integer): integer;
begin
  result:=ord(Psmallint(intG(p)+(i-indice1)*StepSize)^ and Smask <>0);
end;


procedure typeDataIbit.addI(i, x: integer);
begin
  setI(i,1);
end;

function typeDataIbit.getE(i:integer):float;
  begin
    getE:=convY(getI(i));
  end;

procedure typeDataIbit.setE(i:integer;x:float);
  begin
    setI(i,invConvY(x));
  end;

function typeDataIbit.getP(i:integer):pointer;
begin
  result:=pointer(intG(p)+(i-indice1)*StepSize) ;
end;


{*********************** Méthodes de typeDataST ****************************}

constructor typeDataST.createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
begin
  NbStep:=Nstep;
  inherited createStep(p0,step,i1,imin,imax);
end;

function typeDataST.EltSize: integer;
begin
  result:=4;
end;

function typeDataST.getI(i:integer):integer;
begin
  result:=round(getE(i));
end;

function typeDataST.getP(i:integer):pointer;
begin
  result:=pointer(intG(p)+(i+indice1) mod NbStep *StepSize);
end;

procedure typeDataST.setI(i:integer;x:integer);
begin
  Psingle(intG(p)+(i+indice1) mod NbStep *StepSize)^:=x;
end;

procedure typeDataST.addI(i:integer;x:integer);
var
  p1:Psingle;
begin
  intG(p1):= intG(p)+(i+indice1) mod NbStep *StepSize;
  p1^:=p1^+x;
end;

function typeDataST.getE(i:integer):float;
begin
  try

  result:=Psingle(intG(p)+(i+indice1+nbStep) mod NbStep *StepSize)^;
  except
    messageCentral('typeDataST.getE i='+Istr(i));
  end;
end;

procedure typeDataST.setE(i:integer;x:float);
begin
  Psingle(intG(p)+(i+indice1) mod NbStep *StepSize)^:=x;
end;

function typeDataST.tournant:boolean;
begin
  result:=true;
end;


{*********************** Méthodes de typeDataDT ****************************}

constructor typeDataDT.createStep(p0:pointer;step,Nstep,i1,imin,imax:integer);
begin
  NbStep:=Nstep;
  inherited createStep(p0,step,i1,imin,imax);
end;

function typeDataDT.EltSize: integer;
begin
  result:=8;
end;

function typeDataDT.getI(i:integer):integer;
begin
  result:=round(getE(i));
end;

function typeDataDT.getP(i:integer):pointer;
begin
  result:=pointer(intG(p)+(i+indice1) mod NbStep *StepSize);
end;

procedure typeDataDT.setI(i:integer;x:integer);
begin
  Pdouble(intG(p)+(i+indice1) mod NbStep *StepSize)^:=x;
end;

procedure typeDataDT.addI(i:integer;x:integer);
var
  p1:Pdouble;
begin
  intG(p1):= intG(p)+(i+indice1) mod NbStep *StepSize;
  p1^:=p1^+x;
end;

function typeDataDT.getE(i:integer):float;
begin
  try

  result:=Pdouble(intG(p)+(i+indice1+nbStep) mod NbStep *StepSize)^;
  except
    messageCentral('typeDataDT.getE i='+Istr(i));
  end;
end;

procedure typeDataDT.setE(i:integer;x:float);
begin
  Pdouble(intG(p)+(i+indice1) mod NbStep *StepSize)^:=x;
end;

function typeDataDT.tournant:boolean;
begin
  result:=true;
end;




{ typeDataSpkExt }

constructor typeDataSpkExt.create(dataT, dataA: typedataB; att1: byte;Imin,Imax:integer);
begin
  dataTime:=dataT;
  dataAtt:=dataA;
  att0:=att1;

  if not assigned(dataTime) or not assigned(dataAtt) then
  begin
    indicemin:=1;
    indicemax:=0;
    freemem(tb);
    tb:=nil;
    setLength(positions,0);
    lastPos:=0;
    exit;
  end;

  size:=4;
  {if Imax-Imin+1<maxBufL                 On fixe la taille du buffer au maximum
    then maxBuf:=Imax-Imin+1
    else}
  maxBuf:=maxBufL;
  getmem(tb,maxBuf*size);

  ax:=dataT.ax;
  bx:=dataT.bx;
  ay:=dataT.ax;
  by:=dataT.bx;

  indiceMin:=Imin;
  indiceMax:=Imax;
  LastPos:=dataTime.indiceMax;

  nbvoie:=1;

  setLength(positions,1);
  positions[0]:=dataTime.indiceMin;
  LoadBlock;
end;

function typeDataSpkExt.EltSize: integer;
begin
  result:=4;
end;

procedure typeDataSpkExt.loadBlock;
var
  max:integer;
  i,p,k:integer;
  minT,maxT:integer;
begin
  if not assigned(dataTime) or not assigned(dataAtt) then exit;
  minT:=dataTime.indiceMin;
  maxT:=dataTime.indiceMax;

  if block<length(Positions) then p:=Positions[block]
  else
  begin
    p:=block*maxBuf+minT;                   { indice dans la source Spk }
    while high(positions)<block do
    begin
      p:=positions[high(positions)];
      k:=0;
      while (p<=MaxT) and (k<maxbuf) do
      begin
        if dataAtt.getI(p)=att0 then inc(k);
        inc(p);
      end;
      setLength(positions,length(positions)+1);
      positions[high(positions)]:=p;
    end;
    LastPos:=dataTime.indiceMax;
  end;

  k:=0;
  for i:=p to MaxT do
  begin
    if dataAtt.getI(i)=att0 then
    begin
      tb^.l[k]:=dataTime.getI(i);
      inc(k);
    end;
    if k=maxBuf then break;
  end;


end;


procedure typeDataSpkExt.ModifyLimits(iMin, iMax: integer);
var
  i,k,p,minT,maxT:integer;
begin
{ On suppose que indiceMin reste fixe et indiceMax augmente
  Si on est sur le dernier bloc, il faut compléter le bloc.
}
  minT:=dataTime.indiceMin;
  maxT:=dataTime.indiceMax;

  if block=high(positions) then
  begin
    p:=LastPos+1;
    k:=(indiceMax+1-indiceMin) mod maxBuf;

    for i:=p to MaxT do
    begin
      if dataAtt.getI(i)=att0 then
      begin
        tb^.l[k]:=dataTime.getI(i);
        inc(k);
      end;
      if k=maxBuf then break;
    end;
    LastPos:=dataTime.indiceMax;
  end;

  indiceMax:=iMax;

end;

{ typeDataFileSegU }

constructor typeDataFileSegU.create(st: AnsiString; segs1: TKsegArray; Usize: integer; modeOp: boolean);
begin
  InitSegFile(st,segs1,modeOp, Usize, segs, Nsegs);
end;

constructor typeDataFileSegU.create(f: TgetStream; segs1: TKsegArray; Usize: integer; modeOp: boolean);
begin
  fStream:=f;
  create('',segs1,Usize,true);
end;

function typeDataFileSegU.EltSize: integer;
begin
  result:=size;
end;

procedure typeDataFileSegU.loadBlock;
begin
  LoadSegBlock( segs, Nsegs );
end;

{ typeDataSegUExt }

constructor typeDataSegUExt.create(dataT, dataA: typedataB; att1: byte;  Imin, Imax, Usize: integer);
begin
  dataTime:=dataT;
  dataAtt:=dataA;
  att0:=att1;

  if not assigned(dataTime) or not assigned(dataAtt) then
  begin
    indicemin:=1;
    indicemax:=0;
    freemem(tb);
    tb:=nil;
  end;

  size:=Usize;
  if Imax-Imin+1<maxBufDF div size
    then maxBuf:=Imax-Imin+1
    else maxBuf:=maxBufDF div size;
  getmem(tb,maxBuf*size);

  ax:=dataT.ax;
  bx:=dataT.bx;
  ay:=dataT.ax;
  by:=dataT.bx;

  indiceMin:=Imin;
  indiceMax:=Imax;

  nbvoie:=1;

  setLength(positions,1);
  positions[0]:=dataTime.indiceMin;
  LoadBlock;
end;

procedure typeDataSegUExt.loadBlock;
var
  max:integer;
  i,p,k:integer;
  minT,maxT:integer;
  pp:pointer;
begin
  if not assigned(dataTime) or not assigned(dataAtt) then exit;
  minT:=dataTime.indiceMin;
  maxT:=dataTime.indiceMax;

  if block<length(Positions) then p:=Positions[block]
  else
  begin
    p:=block*maxBuf;
    while high(positions)<block do
    begin
      p:=positions[high(positions)];
      k:=0;
      while (p<=MaxT) and (k<maxbuf) do
      begin
        if dataAtt.getI(p)=att0 then inc(k);
        inc(p);
      end;
      setLength(positions,length(positions)+1);
      positions[high(positions)]:=p;
    end;
  end;

  k:=0;
  for i:=p to MaxT do
  begin
    if dataAtt.getI(i)=att0 then
    begin
      pp:=dataTime.getP(i);
      move(pp^,tb^.b[k*size],size);
      inc(k);
    end;
    if k=maxBuf then break;
  end;


end;


procedure typeDataSegUExt.open;
begin
end;


procedure typeDataSegUExt.close;
begin
end;





end.
